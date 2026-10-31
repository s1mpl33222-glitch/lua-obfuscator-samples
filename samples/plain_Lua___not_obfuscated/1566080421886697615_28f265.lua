-- Startup wrapper: catches compilation errors and gives an on-screen message.
local player=game:GetService("Players").LocalPlayer
local pg=player:WaitForChild("PlayerGui")
-- Best-effort: only activate a visible, explicitly named skip button inside a loading/intro GUI.
task.spawn(function()
 local deadline=os.clock()+45;local attempted={}
 while os.clock()<deadline do
  for _,item in ipairs(pg:GetDescendants()) do
   if item:IsA("GuiButton") and not attempted[item] and item.Visible and item.AbsoluteSize.X>0 and item.AbsoluteSize.Y>0 then
    local name=(item.Name.." "..(item:IsA("TextButton") and item.Text or "")):lower()
    local context=item.Parent;local loading=false;local visible=true
    while context and context~=pg do
     local n=context.Name:lower();if n:find("load",1,true) or n:find("intro",1,true) then loading=true end
     if context:IsA("GuiObject") and not context.Visible then visible=false end
     if context:IsA("ScreenGui") and not context.Enabled then visible=false end
     context=context.Parent
    end
    if loading and visible and name:find("skip",1,true) then
     attempted[item]=true
     local ok=false;if type(firesignal)=="function" then ok=pcall(function()firesignal(item.MouseButton1Click)end)end
     if not ok then pcall(function()local vim=game:GetService("VirtualInputManager");local pos=item.AbsolutePosition+item.AbsoluteSize/2;vim:SendMouseButtonEvent(pos.X,pos.Y,0,true,game,0);vim:SendMouseButtonEvent(pos.X,pos.Y,0,false,game,0)end)end
    end
   end
  end
  task.wait(1)
 end
end)
local old=pg:FindFirstChild("AutoFishBootDiagnostic");if old then old:Destroy() end
local gui=Instance.new("ScreenGui");gui.Name="AutoFishBootDiagnostic";gui.ResetOnSpawn=false;gui.DisplayOrder=2147483647;gui.Parent=pg
local frame=Instance.new("Frame");frame.Size=UDim2.fromOffset(310,126);frame.Position=UDim2.new(0.5,-155,0,120);frame.BackgroundColor3=Color3.fromRGB(28,30,37);frame.Parent=gui;Instance.new("UICorner",frame)
local label=Instance.new("TextLabel");label.Size=UDim2.new(1,-18,1,-52);label.Position=UDim2.fromOffset(9,5);label.Text="AUTO FISH: compiling...";label.TextColor3=Color3.new(1,1,1);label.TextSize=12;label.TextWrapped=true;label.BackgroundTransparency=1;label.Font=Enum.Font.Gotham;label.Parent=frame
local copy=Instance.new("TextButton");copy.Size=UDim2.new(1,-18,0,34);copy.Position=UDim2.new(0,9,1,-41);copy.Text="COPY STARTUP STATUS";copy.TextColor3=Color3.new(1,1,1);copy.BackgroundColor3=Color3.fromRGB(65,85,120);copy.Font=Enum.Font.GothamBold;copy.TextSize=12;copy.Parent=frame;Instance.new("UICorner",copy)
local status="Starting";local function say(t) status=t;label.Text=t;print("[AUTO FISH STARTUP] "..t) end
copy.MouseButton1Click:Connect(function() local f=setclipboard or toclipboard;if type(f)=="function" then pcall(f,status) end end)
if type(writefile)=="function" then pcall(writefile,"auto_fish_crash.txt","") end
local source=[====[
local a="v13.55-harvest-hold-test"print("[AUTOFISH] >>> STARTED "..a.." <<<")pcall(function()if type(writefile)=="function"then writefile("auto_fish_boot.txt","AUTO FISH "..a.." loaded at "..os.date("%Y-%m-%d %H:%M:%S"))end end)local b,c=pcall(function()local d=type(tick)=="function"and tick or os.clock;local e=type(math)=="table"and type(math.clamp)=="function"and math.clamp or function(f,g,h)if f<g then return g elseif f>h then return h end;return f end;local i=type(task)=="table"and type(task.spawn)=="function"and task.spawn or type(spawn)=="function"and spawn or function(j)if j then j()end end;local k=type(task)=="table"and type(task.wait)=="function"and task.wait or type(wait)=="function"and wait or function()end;local l=type(table)=="table"and type(table.pack)=="function"and table.pack or function(...)local m={...}m.n=select("#",...)return m end;local n=type(table)=="table"and type(table.unpack)=="function"and table.unpack or unpack;local function o(p,...)if type(p)~="function"then return nil end;local q,g=pcall(p,...)if q then return g end;return nil end;local function r()local s=o(function()if type(getgenv)=="function"then return getgenv()end end)if type(s)=="table"then return s end;return _G end;local t={CarName="G-Cruzer",ItemsRemote="MD_ItemsEvent",ItemsCandidates={"ItemsEvent","SpawnEvent","VehicleEvent","CarEvent"},ActionSync="Sync",ActionSpawn="Spawn",ActionSelectSlot="SelectSlot",HouseRemote="MD_HouseRentalRemote",HouseCandidates={"HouseRentalRemote","ShopRemote","MD_ShopEvent"},OpenAction="OpenFishing",BuyAction="BuyFishing",EquipBaitAction="EquipFishingBait",FishingRemote="MD_FishingRemote",FishingCandidates={"FishingRemote","MD_FishRemote","FishRemote"},DriveInputRemote="MD_DriveInput",DriveInputCandidates={"DriveInput","VehicleInput","CarInput","MD_Drive"},DriveInputHz=15,UseDriveInput=true,FaceTravel=true,RodSlot=2,RodId="FishingRodRegular",BaitId="WormtecRegular",RodQty=1,BaitQty=10,RodPrice=100,BaitPrice=20,DefaultShopSpot="-136.81973266601562, 255.0787353515625, 154.70967102050781",DefaultMark1="124.570068359, 244.745315552, -761.677307129",DefaultMark2="140.47694397, 246.912689209, -771.702758789",RecordedCast="149.96356201171875, 250.3606719970703, -861.33642578125",UseRecordedCast=false,UnderFloorClearance=16,UndergroundMode=false,ParkDrop=3,ParkLift=0,FloorThickness=4,SnapHeight=3,FloorSize=4000,SpeedFallback=65,SurfaceAcceleration=22,SurfaceBraking=60,Door1File="auto_fish_door_1.txt",Door2File="auto_fish_door_2.txt",WalkPathFile="auto_fish_atm_shop_walk.txt",RouteMode="Above ground",CarSpeedMultiplier=2.5,BuySpeedMultiplier=3,AccelerationOn=false,ArriveRadius=8,SmoothDrive=false,StuckSwitchTime=0.7,SmoothMaxDt=0.10,UndergroundCruiseSpeed=130,SurfacePulseInterval=5,SurfacePulseDwell=0.12,UndergroundArriveRadius=1.25,CastRetries=3,BiteWatchdog=10,ReparkDrift=3,ShopBuyGap=1.2,BuyRetries=2,AnchorWhenParked=true,LockPose=true,NoCollideWhenParked=true,AutoRepair=true,RepairBelow=0.5,RepairEvery=2.5,DodgeObstacles=true,DodgeLookahead=35,SurfaceScanRadius=160,SurfaceCarLength=16,SurfaceCarWidth=7,MaxTurnAttempts=120,DodgeHoldTime=1.4,DriveDepth=16,TryGameRodEquip=false,DriveTimeout=60,SurfaceLift=1,ShopOpenWait=0.45,ShopBuyWait=0.18,ShopEventWait=0.5,ReturnWait=0.3,AutoRecast=true,AutoResupply=true,MaxStepPerFrame=14,RubberBandStuds=18,SurfaceHopAfter=3,RecastWait=1.0,ReelLead=0.10,CastTimeout=25,VerifySeconds=5,ManualTapSeconds=12,SpawnTimeout=15,CooldownTimeout=180,MaxPromptDist=12,DoorStandOff=3.5,DoorCloseOff=2.0,StandHeight=3,SeatLift=2.5,GlideSpeed=60,GlideStep=1.2,MaxGetInAttempts=3,PreferredSide="left",CooldownGui="MD_ItemsGui",CooldownPath={"ItemInspector","Footer","Action1"},ReportFile="auto_fish_report.txt",AllFile="auto_fish_all.txt",MinigameFile="auto_fish_minigame.txt",ShopSpotFile="auto_fish_shop_spot.txt",Mark1File="auto_fish_mark1.txt",Mark2File="auto_fish_mark2.txt",ShopReportFile="shop_report.txt",MarksFile="fishing_marks.txt",MarksUnderFile="fishing_marks_underground...",FishMark1File="fishing_mark1.txt",FishMark2File="fishing_mark2.txt",GuiTitle="AUTO FISH SURFACE ROUTE",DriverHints={"driveprompt","driver","md_driverdoor"},PassengerHints={"passenger"},SeatHints={"driveseat","driverseat","vehicleseat","seat"},ShopHints={"md_jackfarmstore","jack","hardware","buy farming supplies","farm","fishing","bait","shop","store","market"},RodHints={"fishingrod","fishing rod","rod"},BaitHints={"bait","worm","prawn","lure"},Verbose=true}local u=game:GetService("Players")local v=game:GetService("RunService")local w=game:GetService("UserInputService")local x=game:GetService("Workspace")local y=game:GetService("ReplicatedStorage")local z=u.LocalPlayer;local A=o(function()return game:GetService("VirtualInputManager")end)local B={t0=d(),events={},notes={},results={},lastMsg="Ready. Tap AUTO FISH...",car=nil,seated=false,busy=false,done=false,stop=false,phase="IDLE",stage="SHOP",shopTarget=nil,shopTargetSource="none",fishTarget=nil,fishTargetSource="none",castTarget=nil,castTargetSource="none",shopDone=false,shopAttempted=false,autoFishStarted=false,baitQty=t.BaitQty,rodBought=false,baitBought=false,rodEquipped=false,baitEquipped=false,cheapestRod=nil,cheapestBait=nil,catalog={},shopFeedback={},shopEventsConnected=false,catalogSeen=false,gameMaxSpeed=nil,speedSource="none",speed=0,snapped=false,facingTicks=0,driveInputs=0,lastDriveInput=0,floor=nil,floorY=nil,groundY=nil,underY=nil,pinY=nil,underground=false,autoDrive=nil,liftStarted=false,casts=0,reels=0,bites=0,caught=0,autoFish=false,castActive=false,castToken=0,fishConnected=false,lastBiteKey=nil,recastPending=false,minigameRec=false,minigameEvents={},report=""}local C={version=a,active=false,session=d(),rollbackCount=0}pcall(function()r().ArenaFishDriveTrace=C end)local D,E,F,G;local H={}local I;local J;local K={}pcall(function()local L=r().ArenaAutoFishStop;if type(L)=="function"then L()end end)local M,N,O;local P=function()end;local Q,R=string.char(10),string.char(13)local function p(f)if type(f)~="number"then return"0"end;if f~=f or f==math.huge or f==-math.huge then return"0"end;return string.format("%.12g",f)end;local function S(f)return string.format("%q",tostring(f or""))end;local function T()return d()-B.t0 end;local function U()return os.date("%Y-%m-%d %H:%M:%S")end;local function V(W,X)if W==nil then return nil end;return o(function()return W[X]end)end;local function Y(W)if W==nil then return"?"end;local q,Z=pcall(function()return W:GetFullName()end)if q and type(Z)=="string"and Z~=""then return Z end;return tostring(W)end;local function _(a0,a1,a2)return Vector3.new(a0,a1,a2)end;local function a3(g,h)if not g or not h then return nil end;local q,a4=pcall(function()return(g-h).Magnitude end)if q and type(a4)=="number"then return a4 end;return nil end;local function a5(f)if type(f)=="number"then return f end;if type(f)~="string"then return nil end;return tonumber(f:gsub(",",""):gsub("%s+",""))end;local function a6(...)local m={}for a7=1,select("#",...)do m[#m+1]=tostring(select(a7,...))end;local a8=table.concat(m," ")B.events[#B.events+1]={t=T(),text=a8}if B.fullLogAdd then pcall(B.fullLogAdd,"SCRIPT",a8)end;B.lastMsg=a8;if t.Verbose then print("[AUTOFISH] "..a8)end;if E then E()end end;local function a9(Z)for aa,ab in ipairs(B.notes)do if ab==Z then return end end;B.notes[#B.notes+1]=tostring(Z)end;local function ac(Z)B.results[#B.results+1]=tostring(Z);if B.fullLogAdd then pcall(B.fullLogAdd,"RESULT",tostring(Z))end end;local function ad(ae)if type(ae)~="string"then return nil end;local af={}for ab in ae:gmatch("[-]?%d+%.?%d*[eE]?[-+]?%d*")do local f=tonumber(ab)if f then af[#af+1]=f end;if#af>=3 then break end end;if#af>=3 then return af[1],af[2],af[3]end;return nil end;local function ag(ah)if ah==nil then return"n/a"end;local g=o(function()return{ah:GetComponents()}end)if type(g)=="table"and#g>=12 then local W={}for a7=1,12 do W[a7]=p(g[a7])end;return table.concat(W,", ")end;local ai=V(ah,"Position")if ai then return table.concat({p(ai.X),p(ai.Y),p(ai.Z),"1","0","0","0","1","0","0","0","1"},", ")end;return"n/a"end;local function aj(f,ak,al)ak,al=ak or 0,al or{}local m=type(f)if m=="nil"or m=="boolean"or m=="number"then return tostring(f)end;if m=="string"then if#f>180 then f=f:sub(1,180).."..."end;return S(f)end;if m=="function"or m=="thread"then return"<"..m..">"end;if ak>4 then return"<maxdepth>"end;local am=V(f,"ClassName")if type(am)=="string"and am~=""then return"Instance<"..Y(f).."> ("..am..")"end;local a0,a1,a2=V(f,"X"),V(f,"Y"),V(f,"Z")if type(a0)=="number"and type(a1)=="number"and type(a2)=="number"then return"Vector3.new("..p(a0)..", "..p(a1)..", "..p(a2)..")"end;if m=="userdata"then return S(tostring(f))end;if m~="table"or al[f]then return"<"..m..">"end;al[f]=true;local af,ab={},0;for X,an in pairs(f)do ab=ab+1;if ab>25 then af[#af+1]="..."break end;af[#af+1]=(type(X)=="string"and S(X)or"["..S(X).."]").."="..aj(an,ak+1,al)end;al[f]=nil;return"{"..table.concat(af,", ").."}"end;local function ao()local ap=V(z,"Character")if not ap then return nil end;return o(function()return ap:FindFirstChild("HumanoidRootPart")end)end;local function aq()local ap=V(z,"Character")if not ap then return nil end;return o(function()return ap:FindFirstChildOfClass("Humanoid")end)end;local function ar()local as=ao()return as and V(as,"Position")or nil end;local function at(au)if not au then return nil end;local q,ai=pcall(function()return au:GetPivot().Position end)if q and ai then return ai end;local aw=V(au,"PrimaryPart")return aw and V(aw,"Position")or nil end;local function ax(au)if not au then return nil end;local q,cf=pcall(function()return au:GetPivot()end)if q then return cf end;return V(au,"WorldPivot")end;local function ay(az,aA,aB,aC)if not az then return 0 end;local aD,aE,aF={{o=az,d=0}},1,0;while aE<=#aD and aF<aA do local aG=aD[aE]aE=aE+1;local W=aG.o;if W then aF=aF+1;if aC then pcall(aC,W,aG.d)end;if aG.d<aB then local aH=o(function()return W:GetChildren()end)if type(aH)=="table"then for a7=1,math.min(#aH,120)do if aF+#aD-aE+1>=aA then break end;aD[#aD+1]={o=aH[a7],d=aG.d+1}end end end end end;return aF end;local function aI(au)if not au then return nil end;local aw=V(au,"PrimaryPart")if aw then return aw end;local aJ=nil;ay(au,250,5,function(W)if aJ then return end;local aK=tostring(V(W,"ClassName")or"")if aK=="Part"or aK=="MeshPart"then aJ=W end end)return aJ end;local function aL(au)if not au then return false end;local aM=aq()local aN=aM and V(aM,"SeatPart")if not aN or V(aM,"Sit")~=true then return false end;return o(function()return aN:IsDescendantOf(au)end)==true end;local function aO(aP)if not aP then return nil end;local aQ=V(aP,"Parent")local aR,aS=nil,-1e9;for ak=1,8 do if not aQ or aQ==x then break end;if tostring(V(aQ,"ClassName"))=="Model"then local aT,aU,aV=0,0,0;ay(aQ,260,6,function(W)local aW=tostring(V(W,"ClassName")or"")if aW=="VehicleSeat"then aT=aT+1 end;if aW=="Part"or aW=="MeshPart"or aW=="UnionOperation"then aU=aU+1;local aX=tostring(V(W,"Name")or""):lower()if aX:find("wheel",1,true)or aX:find("tire",1,true)then aV=aV+1 end end end)if aT>=1 and aT<=8 then local aY=(V(aQ,"PrimaryPart")and 40 or 0)+math.min(aU,20)*2+math.min(aV,4)*12-ak*2-(aT-1)*12;local aZ=o(function()local aa,a_=aQ:GetBoundingBox()return a_ end)if aZ and(aZ.X>65 or aZ.Z>65 or aZ.Y>35)then aY=aY-150 end;local b0=o(function()return aQ:GetAttributes()end)or{}for X in pairs(b0)do if tostring(X):lower():find("owner",1,true)then aY=aY+20;break end end;if aY>aS then aR,aS=aQ,aY end end end;aQ=V(aQ,"Parent")end;return aR end;local function b1(f)if f==z then return true end;if type(f)=="number"then return f==tonumber(V(z,"UserId"))end;local b2=tostring(f or"")return b2~=""and(b2==tostring(V(z,"Name"))or b2==tostring(V(z,"UserId")))end;local function b3(au)if not au then return false end;if B.syncOwnedCar==au and au:IsDescendantOf(x) then return true end;local b4=false;local aQ=au;for aa=1,3 do if not aQ or aQ==x then break end;local b0=o(function()return aQ:GetAttributes()end)or{}for X,f in pairs(b0)do local b5=tostring(X):lower()if b5:find("owner",1,true)or b5=="userid"or b5=="creator"then b4=true;if not b1(f)then return false end end end;for aa,b6 in ipairs({"Owner","MD_Owner","OwnerUserId","OwnerId","Creator","UserId"})do local W=o(function()return aQ:FindFirstChild(b6)end)if W then local f=V(W,"Value")if f~=nil then b4=true;if not b1(f)then return false end end end end;aQ=V(aQ,"Parent")end;if b4 then return true end;local aM=aq()local aP=aM and V(aM,"SeatPart")return aM~=nil and aP~=nil and o(function()return aP:IsA("VehicleSeat")and aP:IsDescendantOf(au)end)==true and(V(aP,"Occupant")==aM or V(aM,"SeatPart")==aP)or false end;local function b7()local af,al={},{}local function b8(W)if not W or al[W]then return end;al[W]=true;if tostring(V(W,"ClassName"))~="Model"then return end;local aP=o(function()return W:FindFirstChildWhichIsA("VehicleSeat",true)end)if aP and aO(aP)==W and b3(W)then af[#af+1]=W end end;local aM=aq()local aP=aM and V(aM,"SeatPart")if aP then b8(aO(aP))end;local b9=ar()local q,aU=pcall(function()return b9 and x:GetPartBoundsInRadius(b9,180)end)if q and type(aU)=="table"then for a7=1,math.min(#aU,1000)do local aQ=aU[a7]for aa=1,6 do if not aQ or aQ==x then break end;if tostring(V(aQ,"ClassName"))=="Model"then b8(aQ)end;aQ=V(aQ,"Parent")end end end;if#af==0 then local aH=o(function()return x:GetChildren()end)or{}for ba=1,math.min(#aH,180)do local aQ=aH[ba]if tostring(V(aQ,"ClassName"))=="Model"then b8(aQ)end;local bb=tostring(V(aQ,"Name")or""):lower()if bb:find("vehicle",1,true)or bb:find("car",1,true)or bb:find("garage",1,true)then local bc=o(function()return aQ:GetChildren()end)or{}for bd=1,math.min(#bc,120)do b8(bc[bd])end end end end;return af end;local function be(b6,bf)local function bg(ab)local bh=o(function()return y:FindFirstChild(ab)end)if bh then return bh end;local aJ=nil;ay(y,350,6,function(W)if aJ then return end;if tostring(V(W,"Name")or"")==ab then aJ=W end end)return aJ end;local bh=bg(b6)if bh then return bh end;for aa,ab in ipairs(bf or{})do bh=bg(ab)if bh then return bh end end;return nil end;local function bi()return be(t.ItemsRemote,t.ItemsCandidates)end;local function bj()return be(t.HouseRemote,t.HouseCandidates)end;local function bk()return be(t.FishingRemote,t.FishingCandidates)end;local function bl()return be(t.DriveInputRemote,t.DriveInputCandidates)end;local function bm(bn,...)if not bn then return false end;local g=l(...)
 if B.fullLogAdd then pcall(function()local values={};for index=1,g.n or #g do values[#values+1]=aj(g[index])end;B.fullLogAdd("SCRIPT REMOTE OUT",Y(bn).." "..table.concat(values," | "))end)end
 local ok,err=pcall(function()bn:FireServer(n(g,1,g.n or#g))end)
 if not ok and B.fullLogAdd then pcall(B.fullLogAdd,"REMOTE ERROR",tostring(err))end
 return ok,err
end;local function bo(b6)if type(readfile)~="function"then return nil end;if type(isfile)=="function"then local q,bp=pcall(isfile,b6)if not q or not bp then return nil end end;local q,bq=pcall(readfile,b6)if q and type(bq)=="string"and bq~=""then return bq end;return nil end;local function br(b6,bq)if type(writefile)~="function"then return false end;return pcall(writefile,b6,bq)end;local function bs(bq,b5)if type(bq)~="string"then return nil end;local bt=b5 .."="local g=bq:find(bt,1,true)if not g then return nil end;local h=bq:find(Q,g,true)or bq:find(R,g,true)or#bq+1;local f=bq:sub(g+#bt,h-1)f=f:gsub("^%s+",""):gsub("%s+$",""):gsub("%c+$","")if f~=""and f~="none"and f:find("%d")then return f end;return nil end;local function bu(bv,bw,a0,a1,a2)if not(a0 and a1 and a2)then return false end;B[bv]={x=a0,y=a1,z=a2}B[bv.."Source"]=bw;return true end;local function bx(bv,bw,an)if type(an)~="string"then return false end;return bu(bv,bw,ad(an))end;local function by()local s=r()local function bz(bw,f)return bx("shopTarget",bw,f)end;local function bA(bw,f)return bx("fishTarget",bw,f)end;local function bB(bw,f)return bx("castTarget",bw,f)end;if type(s)=="table"then bz("getgenv().AutoFishShopSpot",s.AutoFishShopSpot)if not B.shopTarget then bz("getgenv().ShopTarget",s.ShopTarget)end;if not B.shopTarget then bz("getgenv().FishBaitTarget",s.FishBaitTarget)end;if not B.shopTarget then bz("getgenv().FishBaitOneButt...",s.FishBaitOneButtonSpot)end;if not B.shopTarget and type(s.ShopScan)=="table"then bz("ShopScan.markedSpot",s.ShopScan.markedSpot)end;if not B.shopTarget and type(s.FishingMarks)=="table"then if type(s.FishingMarks.mark1)=="table"then bA("FishingMarks.mark1",s.FishingMarks.mark1.cframe or s.FishingMarks.mark1.original)end;if type(s.FishingMarks.mark2)=="table"then bB("FishingMarks.mark2",s.FishingMarks.mark2.cframe or s.FishingMarks.mark2.original)end end;if not B.fishTarget then bA("getgenv().AutoFishMark1",s.AutoFishMark1)end;if not B.castTarget then bB("getgenv().AutoFishMark2",s.AutoFishMark2)end;if not B.fishTarget then bA("getgenv().FishingMark1",s.FishingMark1)end;if not B.castTarget then bB("getgenv().FishingMark2",s.FishingMark2)end end;local bC=bo(t.ShopReportFile)if not B.shopTarget and bC then local bD=bC:match("MARKED SPOT:%s*([^"..Q..R.."]+)")if bD then bu("shopTarget","shop_report.txt MARKED SPOT",ad(bD))end end;local bE=bo(t.MarksFile)or bo(t.MarksUnderFile)if bE then if not B.fishTarget then bA("fishing_marks.txt MARK1",bs(bE,"MARK1")or bs(bE,"CORRECTED_MARK1"))end;if not B.castTarget then bB("fishing_marks.txt MARK2",bs(bE,"MARK2"))end end;if not B.fishTarget then bA(t.FishMark1File,bo(t.FishMark1File))end;if not B.castTarget then bB(t.FishMark2File,bo(t.FishMark2File))end;if not B.shopTarget then bz(t.ShopSpotFile,bo(t.ShopSpotFile))end;if not B.fishTarget then bA(t.Mark1File,bo(t.Mark1File))end;if not B.castTarget then bB(t.Mark2File,bo(t.Mark2File))end;if not B.shopTarget then bz("CFG.DefaultShopSpot",t.DefaultShopSpot)end;if not B.fishTarget then bA("CFG.DefaultMark1",t.DefaultMark1)end;if not B.castTarget then bB("CFG.DefaultMark2",t.DefaultMark2)end;if t.UseRecordedCast then bx("castTarget","CFG.RecordedCast",t.RecordedCast)end;for aa,bF in ipairs({{"shopTarget",t.DefaultShopSpot,120},{"fishTarget",t.DefaultMark1,150}})do local m=B[bF[1]]local bG,bH,bI=ad(bF[2])if m and bG then local bJ=math.sqrt((m.x-bG)^2+(m.z-bI)^2)if bJ>bF[3]then a6("ROUTE LOCK: ignored stale "..bF[1].." "..p(bJ).." studs from verified...")bu(bF[1],"verified map anchor",bG,bH,bI)end end end;if not(B.shopTarget and B.fishTarget and B.castTarget)then a6("NO TARGETS - tap MARK...")return false end;B.stage="SHOP"a6("SHOP SPOT : "..p(B.shopTarget.x)..", "..p(B.shopTarget.y)..", "..p(B.shopTarget.z).." ["..B.shopTargetSource.."]")a6("MARK 1    : "..p(B.fishTarget.x)..", "..p(B.fishTarget.y)..", "..p(B.fishTarget.z).." ["..B.fishTargetSource.."]")a6("MARK 2    : "..p(B.castTarget.x)..", "..p(B.castTarget.y)..", "..p(B.castTarget.z).." ["..B.castTargetSource.."]")return true end;local function bK(bv,b5,bL,ae)if not bx(bv,b5,ae)then return false end;local s=r()if type(s)=="table"then s[b5]=ae end;br(bL,ae)a6(b5 .." saved: "..ae)ac(b5)D(false)return true end;local function bM()local bN=ao()if not bN then a6("MARK SHOP failed - no HRP")return false end;local ah=V(bN,"CFrame")if not ah then a6("MARK SHOP failed - no CFrame")return false end;return bK("shopTarget","AutoFishShopSpot",t.ShopSpotFile,ag(ah))end;local function bO()local bN=ao()if not bN then a6("MARK 1 failed - no HRP")return false end;local ah=V(bN,"CFrame")if not ah then a6("MARK 1 failed - no CFrame")return false end;local ai=V(ah,"Position")or ar()if not ai then a6("MARK 1 failed - no position")return false end;local bP=V(ah,"Rotation")local bQ=CFrame.new(ai.X,ai.Y,ai.Z)if bP then pcall(function()bQ=CFrame.new(ai.X,ai.Y,ai.Z)*bP end)end;return bK("fishTarget","AutoFishMark1",t.Mark1File,ag(bQ))end;local function bR()local bS=o(function()return z:GetMouse()end)local bT=bS and V(bS,"Hit")or nil;local ai=bT and V(bT,"Position")or ar()if not ai then a6("MARK 2 failed - no position")return false end;local ae=table.concat({p(ai.X),p(ai.Y),p(ai.Z),"1","0","0","0","1","0","0","0","1"},", ")return bK("castTarget","AutoFishMark2",t.Mark2File,ae)end;local function bU(W,b5)local f=o(function()return W:GetAttribute(b5)end)if f==nil then local b0=o(function()return W:GetAttributes()end)if type(b0)=="table"then f=b0[b5]end end;if f==nil then f=V(W,b5)end;return tonumber(f)end;local function bV(au)if not au then return nil,"none"end;local bW,an,bw=0,nil,"none"local function bX(W,ai,b5,bY)local f=bU(W,b5)if f and f>0 and ai>bW then bW,an,bw=ai,f,bY.."."..b5 end end;bX(au,4,"MD_MaxSpeed","vehicle")ay(au,300,6,function(W)local aX=tostring(V(W,"Name")or"")local am=tostring(V(W,"ClassName")or"")if aX=="MD_Dynamics"then bX(W,3,"MaxSpeed","MD_Dynamics")end;if aX=="Engine"then bX(W,2,"forwardMaxSpeed","Engine")end;if am=="VehicleSeat"or am=="Seat"or aX=="DriveSeat"then bX(W,1,"MaxSpeed","Seat")end end)return an,bw end;local function bZ()local f,bw=bV(B.car)if f and f>0 then B.gameMaxSpeed,B.speedSource=f,bw else B.gameMaxSpeed,B.speedSource=nil,"fallback"end;B.speed=B.gameMaxSpeed or t.SpeedFallback;a6("GAME MAX SPEED = "..p(B.speed).." studs/s from "..B.speedSource)return B.speed end;local function b_(c0,c1)local c2=B.carYaw or 0;if c2==0 then return c0,c1 end;local aK,c3=math.cos(c2),math.sin(c2)return c0*aK-c1*c3,c0*c3+c1*aK end;local function c4(c0,c1)c0,c1=b_(c0,c1)if not t.FaceTravel or not B.car then return false end;local ai=at(B.car)or ar()if not ai then return false end;local ah=nil;pcall(function()ah=CFrame.lookAt(_(ai.X,ai.Y,ai.Z),_(ai.X+c0,ai.Y,ai.Z+c1))end)if not ah then pcall(function()ah=CFrame.new(ai.X,ai.Y,ai.Z,ai.X+c0,ai.Y,ai.Z+c1)end)end;if not ah then return false end;local q=pcall(function()B.car:PivotTo(ah)end)if not q then q=pcall(function()B.car:SetPrimaryPartCFrame(ah)end)end;if q then B.facingTicks=B.facingTicks+1 end;return q end;local function c5()if not t.UseDriveInput then return false end;local c6=d()if c6-(B.lastDriveInput or 0)<1/t.DriveInputHz then return false end;B.lastDriveInput=c6;local bn=bl()if not bn then return false end;local q=pcall(function()bn:FireServer(B.car,1,0,false)end)if q then B.driveInputs=B.driveInputs+1 end;return q end;local function c7(au)local aJ=false;ay(au,250,5,function(W)if aJ then return end;if tostring(V(W,"ClassName")or"")=="ProximityPrompt"then local bb=(Y(W).." "..tostring(V(W,"Name")or"")):lower()for aa,as in ipairs(t.DriverHints)do if bb:find(as,1,true)then aJ=true;break end end end end)return aJ end;local function c8()local c9=ar()local aR,ca=nil,nil;for aa,aK in ipairs(b7())do if b3(aK)and(c7(aK)or o(function()return aK:FindFirstChildWhichIsA("VehicleSeat",true)end))then local a4=a3(c9,at(aK))or 1e6;if not ca or a4<ca then aR,ca=aK,a4 end end end;return aR,ca end;local function cb()local aM=aq()local aP=aM and V(aM,"SeatPart")local cc=aO(aP)if cc and b3(cc)then return cc end;return B.car end;local function cd()
 local current=cb();if current and aL(current) then a6("VEHICLE: already seated in "..tostring(current.Name));return current end
 local nearby,distance=c8();if nearby and distance and distance<=200 then a6("VEHICLE: nearby owned "..tostring(nearby.Name).." at "..p(distance));return nearby end
 local remote=bi();if not remote or not remote:IsA("RemoteEvent") then a6("VEHICLE: MD_ItemsEvent missing");return nil end
 local vehicles=nil;local existing=nil
 local function usableActive(car,items)
  if typeof(car)~="Instance" or not car:IsA("Model") or not car:IsDescendantOf(x) then return false end
  local owned=false;for _,entry in pairs(items or {}) do if type(entry)=="table" and entry.name==car.Name and entry.destroyed~=true then owned=true;break end end
  if not owned then return false end
  local pos=at(car);local player=ar();if not pos or not player or (pos-player).Magnitude>200 or math.abs(pos.Y-player.Y)>35 then return false end
  local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={car,z.Character};params.IgnoreWater=true;params.RespectCanCollide=true
  local ok,hit=pcall(function()return x:Raycast(pos+Vector3.new(0,8,0),Vector3.new(0,-30,0),params)end)
  return ok and hit~=nil and hit.Normal.Y>.6 and pos.Y-hit.Position.Y>=-2 and pos.Y-hit.Position.Y<=12
 end
 local connection=remote.OnClientEvent:Connect(function(action,items,slots,active)
  if action=="Sync" and type(items)=="table" then vehicles=items;existing=active end
 end)
 a6("VEHICLE: requesting owned vehicle list")
 if not bm(remote,"Sync") then connection:Disconnect();a6("VEHICLE: inventory Sync could not be sent");return nil end
 local deadline=d()+5;while not vehicles and not B.stop and d()<deadline do k(.1)end;connection:Disconnect()
 if not vehicles then a6("VEHICLE: no inventory Sync received; spawn not attempted");return nil end
 if usableActive(existing,vehicles) then B.syncOwnedCar=existing;a6("VEHICLE: using server-confirmed nearby car on a surface; no spawn cooldown needed");return existing end
 if typeof(existing)=="Instance" then a6("VEHICLE: active model is not nearby on verified ground; waiting for a fresh spawn")end
 local choices={}
 for _,entry in pairs(vehicles) do if type(entry)=="table" and type(entry.name)=="string" and entry.name~="" and entry.destroyed~=true then choices[#choices+1]=entry.name end end
 table.sort(choices);if #choices==0 then a6("VEHICLE: no usable owned vehicle in inventory");return nil end
 local selected=choices[1];local preferred=B.preferredCar
 if type(preferred)=="string" then for _,name in ipairs(choices) do if name==preferred then selected=name;break end end end
 a6("VEHICLE: owned="..table.concat(choices,", ").."; attempting "..selected)
 local okNow,serverNow=pcall(function()return x:GetServerTimeNow()end);local ready=tonumber(z:GetAttribute("MD_CarSpawnReadyAt"))
 if okNow and ready and ready>serverNow then local waitFor=ready-serverNow;if waitFor>600 then a6("VEHICLE: spawn cooldown exceeds 10 minutes; stop rather than spam");return nil end;a6("VEHICLE: waiting "..p(waitFor).."s for spawn cooldown; no repeated spawn requests");B.phase="WAITING FOR VEHICLE COOLDOWN";local untilTime=d()+waitFor;while not B.stop and not B.done and d()<untilTime do k(.2)end end
 if B.stop then return nil end
 local activeConnection=remote.OnClientEvent:Connect(function(action,items,slots,active)
  if action=="Sync" and typeof(active)=="Instance" and active:IsA("Model") and active:IsDescendantOf(x) then
   local owned=false;if type(items)=="table" then for _,entry in pairs(items) do if type(entry)=="table" and entry.name==active.Name and entry.destroyed~=true then owned=true;break end end end
   if owned then B.syncOwnedCar=active;a6("VEHICLE: server Sync identified active owned model "..Y(active))end
  end
 end)
 local sent=bm(remote,"Spawn",selected);a6("VEHICLE: recorded spawn request "..selected.." sent="..tostring(sent))
 if not sent then activeConnection:Disconnect();return nil end
 local limit=d()+30;local nextSync=d()+1
 while not B.stop and d()<limit do
  local car=B.syncOwnedCar;local pos=car and at(car);local dist=pos and a3(ar(),pos)
  if car and car.Parent and dist and dist<=250 then activeConnection:Disconnect();a6("VEHICLE: server-confirmed owned car "..tostring(car.Name).." dist="..p(dist));return car end
  car,dist=c8();if car and dist and dist<=250 then activeConnection:Disconnect();a6("VEHICLE: owned car observed "..tostring(car.Name).." dist="..p(dist));return car end
  if d()>=nextSync then bm(remote,"Sync");nextSync=d()+2 end
  k(.3)
 end
 activeConnection:Disconnect();a6("VEHICLE: no verified owned car appeared; spawn not confirmed");return nil
end;local function cn(au)local ah=ax(au)if not ah then return nil end;local g=o(function()return{ah:GetComponents()}end)if type(g)~="table"or#g<12 then return nil end;return _(g[1],g[2],g[3]),{X=g[4],Z=g[10]},{X=-g[6],Z=-g[12]}end;local function co(ai)local cp=V(ai,"Parent")if not cp then return nil end;local q,b9=pcall(function()if cp:IsA("BasePart")then return cp.Position end;if cp:IsA("Attachment")then return cp.WorldPosition end;if cp:IsA("Model")then return cp:GetPivot().Position end;return nil end)if q and b9 then return b9 end;return nil end;local function cq(au)local aR,aY,cr=nil,-1e9,0;local c9=ar()ay(au,250,5,function(W)if tostring(V(W,"ClassName")or"")~="ProximityPrompt"then return end;cr=cr+1;local cs=Y(W)local bb=(cs.." "..tostring(V(W,"Name")or"")):lower()local ct=0;for aa,as in ipairs(t.DriverHints)do if bb:find(as,1,true)then ct=ct+100 end end;for aa,as in ipairs(t.PassengerHints)do if bb:find(as,1,true)then ct=ct-100 end end;if V(W,"Enabled")==false then ct=ct-50 end;local ref=W:FindFirstChild("MD_TargetSeat",true);local linked=ref and ref:IsA("ObjectValue") and ref.Value;if linked and linked:IsDescendantOf(au) and (linked:IsA("VehicleSeat") or linked:IsA("Seat")) then local name=linked.Name:lower();if linked:IsA("VehicleSeat") or name:find("driver",1,true) or name:find("drive",1,true) then ct=ct+1000 else ct=ct-1000 end end;local b9=co(W)local a4=a3(c9,b9)or a3(c9,at(au))if a4 then ct=ct-math.min(a4,500)/10 end;if ct>aY then aY=ct;aR={obj=W,path=cs,pos=b9,dist=a4}end end)return aR,cr end;local function cu(au)
 if not au then return nil end;local best,score=nil,-1e9
 for _,seat in ipairs(au:GetDescendants()) do if seat:IsA("VehicleSeat") or seat:IsA("Seat") then
  local n=seat.Name:lower();local value=seat:IsA("VehicleSeat") and 50 or 0
  if n:find("driver",1,true) or n:find("drive",1,true) then value=value+100 end
  if n:find("passenger",1,true) then value=value-100 end
  if seat.Occupant and seat.Occupant~=aq() then value=value-200 end
  if value>score then best,score=seat,value end
 end end;return best
end;local function cv(cw,cx,cy)local aM,bN=aq(),ao()if not(aM and bN and cw)then return false,"humanoid/root missing"end;local cz={cw};local direct=true
if not direct then pcall(function()
 local start=bN.Position+Vector3.new(0,2,0);local finish=cw+Vector3.new(0,2,0)
 if (finish-start).Magnitude>65 then return end
 local ignore={z.Character};if B.car then ignore[#ignore+1]=B.car end
 for tries=1,16 do
  local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances=ignore;ray.RespectCanCollide=true
  local hit=x:Raycast(start,finish-start,ray)
  if not hit then direct=true;return end
  local part=hit.Instance;local name=(part.Name.." "..(part.Parent and part.Parent.Name or "")):lower()
  if not part.CanCollide or name:find("barrier",1,true) then ignore[#ignore+1]=part else return end
 end
end) end
local q,cA=false,nil
if not direct then q,cA=pcall(function()local cB=game:GetService("PathfindingService")local cC=cB:CreatePath({AgentRadius=2,AgentHeight=5,AgentCanJump=true,WaypointSpacing=5})cC:ComputeAsync(bN.Position,cw)if cC.Status==Enum.PathStatus.Success then return cC:GetWaypoints()end;return nil end) end;if direct then a6("WALK: direct physical route; ignoring walk-through barriers") elseif q and type(cA)=="table"and#cA>0 and#cA<=600 then cz={}for aa,cD in ipairs(cA)do cz[#cz+1]=cD end else local cE=ar()local cF=a3(cE,cw)or 1e9;if cF>12 then return false,"no navigable path; will..."end;local cG=pcall(function()local cH=RaycastParams.new()cH.FilterType=Enum.RaycastFilterType.Exclude;cH.FilterDescendantsInstances={V(z,"Character")}local cI=_(cE.X,cE.Y+2,cE.Z)local cJ=_(cw.X,cw.Y+2,cw.Z)if x:Raycast(cI,cJ-cI,cH)then error("wall")end end)if not cG then return false,"direct path blocked by a..."end end;local cK=d();local sampleAt=d();local samplePos=ar();for a7,cD in ipairs(cz)do local cL=o(function()return cD.Position end)or cD;if a7>1 then local cM=o(function()local cH=RaycastParams.new()cH.FilterType=Enum.RaycastFilterType.Exclude;cH.FilterDescendantsInstances={V(z,"Character")}local bT=x:Raycast(_(cL.X,cL.Y+5,cL.Z),_(0,-18,0),cH)if bT and tostring(bT.Material):lower():find("water",1,true)then return nil end;return bT end)if not cM then return false,"waypoint lacks dry..."end end;local cN=a7==#cz and(cx or 2.5)or 2.8;local cO,aR=d(),1e9;local previousPos=nil;local reached=false
if tostring(o(function()return cD.Action end)):find("Jump",1,true)then pcall(function()aM.Jump=true end)end
pcall(function()aM:Move(Vector3.zero,false)end)
while not B.stop and not B.done and d()-cK<(cy or 9)do
 if B.boardApproach then
  local hum=aq();local state=hum and hum:GetState()
  if not hum or hum.Health<=0 or hum.PlatformStand or state==Enum.HumanoidStateType.PlatformStanding or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Physics then return false,"character downed or unable to move" end
 end
 if B.car and aL(B.car)then return false,"switched to owned car"end
 local b9=ar();local root=ao()
 if b9 and root then
  local cP,cQ=cL.X-b9.X,cL.Z-b9.Z;local a4=math.sqrt(cP*cP+cQ*cQ)
  if a4<=cN then reached=true;break end
  if previousPos then
   local sx,sz=previousPos.X,previousPos.Z;local dx,dz=b9.X-sx,b9.Z-sz;local length=dx*dx+dz*dz
   if length>0.0001 then
    local along=math.clamp(((cL.X-sx)*dx+(cL.Z-sz)*dz)/length,0,1)
    local lateral=math.sqrt((sx+along*dx-cL.X)^2+(sz+along*dz-cL.Z)^2)
    if not B.boardApproach and lateral<=cN and along<1 and a4<=cN+4 then reached=true;a6("GLIDE: crossed waypoint; instant stop/advance");break end
   end
  end
  previousPos=b9
  if a4<aR-0.4 then aR,cO=a4,d()end
  if d()-cO>3.5 then return false,"path blocked at waypoint "..tostring(a7)end
  local requested=B.sellerWalking and 60 or math.clamp(tonumber(t.GlideSpeed)or 32,16,60)
  local desired=B.sellerWalking and math.min(requested,math.max(28,a4*8)) or requested
  pcall(function()
   if aM.WalkSpeed~=requested then aM.WalkSpeed=requested end
   local velocity=root.AssemblyLinearVelocity
   root.AssemblyLinearVelocity=Vector3.new(cP/a4*desired,velocity.Y,cQ/a4*desired)

  end)
  if d()-sampleAt>=1 and samplePos then
   local elapsed=d()-sampleAt;local actual=Vector3.new(b9.X-samplePos.X,0,b9.Z-samplePos.Z).Magnitude/elapsed
   if not B.lastGlideLog or d()-B.lastGlideLog>=2 then B.lastGlideLog=d();a6("GLIDE: requested="..p(requested).." observed="..p(actual).." studs/s waypoint="..a7.."/"..#cz.." (server may limit)")end
   sampleAt=d();samplePos=b9
  end
 end
 game:GetService("RunService").Heartbeat:Wait()
end;local ai=ar()local cP,cQ=ai and ai.X-cL.X or 1e5,ai and ai.Z-cL.Z or 1e5;if not reached and math.sqrt(cP*cP+cQ*cQ)>cN then return false,"path timed out at waypoint "..tostring(a7)end end;return true,"ground path "..tostring(#cz).." waypoints"end;local function cR(cw,cx,cy)local aM=aq()if not aM then return false,"humanoid missing"end;local cS=tonumber(V(aM,"WalkSpeed"))or 16;local cT=math.max(16,math.min(60,tonumber(t.GlideSpeed)or 32))pcall(function()aM.WalkSpeed=cT end)local group=nil
pcall(function()
 if not B.car or not z.Character then return end
 group=Instance.new("Folder");group.Name="AutoFishWalkCarNoCollision";group.Parent=B.car
 for _,body in ipairs(z.Character:GetDescendants()) do if body:IsA("BasePart") then
  for _,part in ipairs(B.car:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then
   local nc=Instance.new("NoCollisionConstraint");nc.Part0=body;nc.Part1=part;nc.Parent=group
  end end
 end end
end)
local cU,q,cV=pcall(cv,cw,cx,cy)
if group then pcall(function()group:Destroy()end)end
pcall(function()local root=ao();if root and not aM.SeatPart then local vel=root.AssemblyLinearVelocity;root.AssemblyLinearVelocity=Vector3.new(0,vel.Y,0);aM:Move(Vector3.zero,false);aM:MoveTo(root.Position)end;aM.WalkSpeed=cS end)if not cU then return false,"ground glide error: "..tostring(q)end;return q,cV end;local function cW(bD)local g,h,aK=tostring(bD or""):match("^%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)")g,h,aK=tonumber(g),tonumber(h),tonumber(aK)if not g or not h or not aK or math.abs(g)>6000 or math.abs(aK)>6000 then return nil end;return _(g,h,aK)end;local function cX()B.door1=cW(bo(t.Door1File))B.door2=cW(bo(t.Door2File))B.walkPath={}local bq=bo(t.WalkPathFile)if bq then for bD in bq:gmatch("[^\r\n]+")do local b9=cW(bD)if b9 and#B.walkPath<300 then B.walkPath[#B.walkPath+1]=b9 end end end;a6("SURFACE WALK: "..#B.walkPath.." recorded points; door 1="..tostring(B.door1~=nil).." door 2="..tostring(B.door2~=nil))end;local function cY(cZ)if B.busy then a6("MARK DOOR refused: stop...")return end;local b9=ar()if not b9 or aq()and V(aq(),"SeatPart")then a6("MARK DOOR: stand on foot..."..cZ)return end;local ae=p(b9.X)..","..p(b9.Y)..","..p(b9.Z)if cZ==1 then B.door1=b9 else B.door2=b9 end;local c_=br(cZ==1 and t.Door1File or t.Door2File,ae)a6("DOOR "..cZ.." MARKED "..ae.." saved="..tostring(c_))end;local function d0()if B.walkRecording then B.walkRecording=false;local d1=B.walkRecordingPoints or{}if#d1<2 then a6("WALK RECORD: too few...")return end;B.walkPath=d1;local af={}for aa,ai in ipairs(d1)do af[#af+1]=p(ai.X)..","..p(ai.Y)..","..p(ai.Z)end;local c_=br(t.WalkPathFile,table.concat(af,"\n"))a6("WALK RECORD SAVED: "..#d1 .." points, file="..t.WalkPathFile.." saved="..tostring(c_))return end;if B.busy or B.autoFish or aq()and V(aq(),"SeatPart")then a6("WALK RECORD: stop...")return end;B.walkRecording=true;B.walkRecordingPoints={}a6("WALK RECORD START: walk...")i(function()local d2,d3=nil,d()while B.walkRecording and d()-d3<180 and#B.walkRecordingPoints<295 do local as=aq()local b9=ar()if as and V(as,"SeatPart")then a6("WALK RECORD stopped:...")B.walkRecording=false;break end;if b9 and(not d2 or(a3(b9,d2)or 0)>=7)then B.walkRecordingPoints[#B.walkRecordingPoints+1]=b9;d2=b9 end;k(0.2)end;if B.walkRecording then d0()end end)end;local function d4(cL)if not cL then return end;local d5=ar()if not d5 or(a3(d5,cL)or 999)>16 then return end;local d6=o(function()return x:GetPartBoundsInRadius(cL,14)end)or{}for aa,d7 in ipairs(d6)do local cc=V(d7,"Parent")local aJ=nil;if cc then ay(cc,75,3,function(W)if aJ or tostring(V(W,"ClassName"))~="ProximityPrompt"then return end;local bY=(tostring(V(W,"Name")or"").." "..tostring(V(W,"ActionText")or"").." "..tostring(V(W,"ObjectText")or"")):lower()local d8=co(W)if d8 and(bY:find("door",1,true)or bY:find("open",1,true))and(a3(d8,cL)or 999)<12 and(a3(d8,d5)or 999)<(tonumber(V(W,"MaxActivationDistance"))or 10)+1 then aJ=W end end)end;if aJ then local d9=tonumber(V(aJ,"HoldDuration"))or 0.2;pcall(function()if type(fireproximityprompt)=="function"then fireproximityprompt(aJ,d9+0.2,true)else aJ:InputHoldBegin()k(d9+0.2)aJ:InputHoldEnd()end end)a6("DOOR: attempted normal..."..tostring(V(aJ,"Name")))k(0.3)return end end end;local function da(db)local d1=B.walkPath or{}local cz={}if#d1>=2 then if db then for a7=#d1,1,-1 do cz[#cz+1]=d1[a7]end else for aa,ai in ipairs(d1)do cz[#cz+1]=ai end end;local d5=ar()if not d5 or(a3(d5,cz[1])or 999)>75 then return false,"recorded route starts..."end;a6("REPLAY "..(db and"SHOP -> ATM"or"ATM -> SHOP").." "..#cz.." walked points")else if db then if B.door2 then cz[#cz+1]=B.door2 end;if B.door1 then cz[#cz+1]=B.door1 end else if B.door1 then cz[#cz+1]=B.door1 end;if B.door2 then cz[#cz+1]=B.door2 end end;a6("SURFACE WALK: no..."..#cz.." door marks + pathfinder")end;for a7,cL in ipairs(cz)do if B.done or B.stop then return false,"run stopped"end;local dc=B.door1 and(a3(cL,B.door1)or 999)<9 and B.door1 or B.door2 and(a3(cL,B.door2)or 999)<9 and B.door2;if dc then d4(dc)end;local a4=a3(ar(),cL)or 999;if a4>4 then local dd=math.min(90,math.max(12,a4/math.max(8,t.GlideSpeed)*3+10))local q,cV=cR(cL,3.5,dd)if not q then return false,"walk mark "..a7 .."/"..#cz..": "..tostring(cV)end end;if dc then d4(dc)end end;local cw=db and at(B.car)or B.shopTarget and _(B.shopTarget.x,B.shopTarget.y+2,B.shopTarget.z)if not cw then return false,"missing shop/car destination"end;local de=a3(ar(),cw)or 999;local dd=math.min(180,math.max(20,de/math.max(8,t.GlideSpeed)*2.5+18))return cR(cw,db and 9 or 5,dd)end;cX()local function df(au,dg)local af,aM,bN={},aq(),ao()if aM and V(aM,"Sit")==true then af[#af+1]="Sit"end;local aN=aM and V(aM,"SeatPart")if aN then af[#af+1]="SeatPart"end;if au and bN then local dh,di=0,false;ay(au,250,5,function(W)local am=tostring(V(W,"ClassName")or"")if(am:find("Weld",1,true)or am=="Motor6D")and(V(W,"Part0")==bN or V(W,"Part1")==bN)then dh=dh+1 end;if am=="VehicleSeat"or am=="Seat"then if V(W,"Occupant")then di=true end end end)if dh>0 then af[#af+1]="weld"end;if di then af[#af+1]="Occupant"end end;local dj=x.CurrentCamera;local dk=dj and V(dj,"CameraSubject")if dk and au and o(function()return dk:IsDescendantOf(au)end)then af[#af+1]="Camera"end;if dg and V(dg.obj,"Enabled")==false then af[#af+1]="PromptUsed"end;return af end;local function dl(au,dg,d3,dm)dm=dm or{}local dn=d()while d()-dn<d3 do if B.stop then break end;for aa,dp in ipairs(df(au,dg))do if not dm[dp]then return true,dp end end;k(0.2)end;return false,"none"end;local function dq(ai,attempt)
 if B.car and aL(B.car) then return true,"already seated" end
 if attempt==1 then
  B.activeBoardPrompt=ai.obj
  local ok=pcall(function()ai.obj:InputHoldBegin();k(math.clamp((tonumber(ai.obj.HoldDuration)or 0)+0.2,0.25,4))end)
  local ended=pcall(function()ai.obj:InputHoldEnd()end);if B.activeBoardPrompt==ai.obj then B.activeBoardPrompt=nil end
  return ok and ended,"single InputHold (released)"
 end
 if attempt==2 and type(fireproximityprompt)=="function" then
  local ok=pcall(function()fireproximityprompt(ai.obj,1,true)end);return ok,"single fireproximityprompt"
 end
 if A then local key=Enum.KeyCode.E;B.boardKeyDown=true;local ok=pcall(function()A:SendKeyEvent(true,key,false,game);k(.1)end);local ended=pcall(function()A:SendKeyEvent(false,key,false,game)end);B.boardKeyDown=false;return ok and ended,"single E (released)" end
 return false,"no prompt method"
end;local ds;local function dt(au)
 B.boardProblem=nil
 if not au or not b3(au) then return false end
 if aL(au) then B.seated=true;return true end
 local body=au:FindFirstChild("Chassis",true)
 if body and body:IsA("BasePart") then
  local up=body.CFrame.UpVector.Y;local seat=cu(au)
  a6("BOARD CHECK: chassis up="..p(up).." anchored="..tostring(body.Anchored).." driverDisabled="..tostring(seat and seat.Disabled).." occupied="..tostring(seat and seat.Occupant~=nil))
  if up<.35 then B.boardProblem="unsafe vehicle tipped; right or respawn it";a6("BOARD: "..B.boardProblem);B.justReturnedFromFishing=false;return false end
  if body.Anchored then
   -- A parked owned car cannot accept boarding reliably while anchored.
   -- Release it only after the same upright/dry-ground checks, not only when
   -- the transient justReturnedFromFishing flag happens to be set.
   local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={au,z.Character};params.IgnoreWater=false;params.RespectCanCollide=true
   local ok,hit=pcall(function()return x:Raycast(body.Position+Vector3.new(0,3,0),Vector3.new(0,-13,0),params)end)
   if not ok or not hit or hit.Material==Enum.Material.Water or hit.Normal.Y<.6 then B.boardProblem="unsafe vehicle: parked car not verified on dry ground";a6("BOARD: "..B.boardProblem);B.justReturnedFromFishing=false;return false end
   if body.Position.Y-hit.Position.Y>8 then B.boardProblem="unsafe vehicle: car too high above ground";a6("BOARD: "..B.boardProblem);return false end
   local shell=au:FindFirstChild("MD_BodyCollision",true) or body
   local op=OverlapParams.new();op.FilterType=Enum.RaycastFilterType.Exclude;op.FilterDescendantsInstances={au,z.Character};op.MaxParts=100
   local checked,hits=pcall(function()return x:GetPartBoundsInBox(shell.CFrame,shell.Size,op)end)
   local clear=checked;local bottom=shell.Position.Y-shell.Size.Y/2
   local blocker=nil
   if checked then for _,part in ipairs(hits) do
    if part.CanCollide and part.Position.Y+part.Size.Y/2>bottom+.25 then
     -- Exempt only a flat, axis-aligned block that the ground ray actually hit,
     -- and only if its top is close to the bottom of the upright body. AABB
     -- overlap with the supporting road alone must not block the driver door.
     local support=part==hit.Instance and part.ClassName=="Part" and part.Shape==Enum.PartType.Block and part.CFrame.UpVector.Y>.995 and hit.Position.Y<=bottom+.75 and math.abs((part.Position.Y+part.Size.Y/2)-hit.Position.Y)<.15
     if not support then clear=false;blocker=part;break end
    end
   end end
   if not clear then B.boardProblem="unsafe vehicle: parked car overlaps obstacle";a6("BOARD: "..B.boardProblem.." blocker="..(blocker and Y(blocker) or "overlap query failed").." ground="..Y(hit.Instance).." groundY="..p(hit.Position.Y).." bodyBottom="..p(bottom));return false end
   local released,result=pcall(function()return anchorCar(false)end)
   if not released or not result then B.boardProblem="unsafe vehicle: could not safely release anchor";a6("BOARD: "..B.boardProblem);B.justReturnedFromFishing=false;return false end
   a6("BOARD: released verified grounded parked car before driver prompt");k(.2)
  end
 end
 local fishReturnBoard=B.justReturnedFromFishing==true
 B.justReturnedFromFishing=false
 local function dryBoardPath(destination)
  if not fishReturnBoard then return true end
  local current=ao();if not current or not destination then return false,"missing return position" end
  local start=current.Position;local delta=Vector3.new(destination.X-start.X,0,destination.Z-start.Z)
  if delta.Magnitude>250 then return false,"return path too long" end
  local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={z.Character,au};rp.IgnoreWater=false;rp.RespectCanCollide=true
  local steps=math.max(1,math.ceil(delta.Magnitude/3));local lastY=nil
  for step=0,steps do
   local point=start+delta*(step/steps)
   local ok,hit=pcall(function()return x:Raycast(Vector3.new(point.X,math.max(start.Y,destination.Y)+8,point.Z),Vector3.new(0,-32,0),rp)end)
   if not ok or not hit or hit.Material==Enum.Material.Water or hit.Normal.Y<.65 then return false,"water or unverified ground at sample "..step.."/"..steps end
   if hit.Instance~=x.Terrain and not hit.Instance.CanCollide then return false,"noncollidable ground" end
   if math.abs(hit.Position.Y-start.Y)>8 or (lastY and math.abs(hit.Position.Y-lastY)>4) then return false,"ground height discontinuity" end
   lastY=hit.Position.Y
  end
  return true
 end
 local function waitUntilMobile()
  local deadline=d()+12;local logged=false
  while not B.stop and not B.done do
   local hum=aq();if not hum or hum.Health<=0 then a6("BOARD: character missing or dead");return false end
   local state=hum:GetState();local down=hum.PlatformStand or state==Enum.HumanoidStateType.PlatformStanding or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Physics
   if not down then return true end
   if not logged then a6("BOARD: character downed or ragdolled; waiting for recovery without moving or firing prompts");logged=true end
   if d()>=deadline then a6("BOARD: character still unable to move; stop and recover before retrying");return false end
   k(.2)
  end
  return false
 end
 if not waitUntilMobile() then return false end
 local door=cq(au);if not door or not door.pos then a6("BOARD: no driver prompt");return false end
 local driver=cu(au);local link=door.obj:FindFirstChild("MD_TargetSeat",true);local target=link and link:IsA("ObjectValue") and link.Value
 a6("BOARD TARGET: seat="..Y(driver).." prompt="..Y(door.obj).." linkedSeat="..Y(target).." seatPos="..tostring(driver and driver.Position).." promptPos="..tostring(door.pos))
 if target and driver and target~=driver then B.boardProblem="driver prompt points to a different seat";a6("BOARD: "..B.boardProblem);return false end
 local root=ao();local center=at(au);if not root or not center then return false end
 local delta=Vector3.new(door.pos.X-center.X,0,door.pos.Z-center.Z)
 local dir=delta.Magnitude>0.01 and delta.Unit or Vector3.new(1,0,0)
 local stand=door.pos+dir*2
 if Vector3.new(root.Position.X-door.pos.X,0,root.Position.Z-door.pos.Z).Magnitude>4 then
  local goal=Vector3.new(stand.X,root.Position.Y,stand.Z);local safe,whyDry=dryBoardPath(goal)
  if not safe then B.boardProblem="unsafe vehicle: return to driver crosses "..tostring(whyDry);a6("BOARD: "..B.boardProblem);return false end
  B.boardApproach=true;local ok,why=cR(goal,1.5,14);B.boardApproach=false
  if aL(au) then B.seated=true;return true end
  if not ok then a6("BOARD: approach incomplete: "..tostring(why).."; checking prompt")end
 end
 for attempt=1,5 do
  if B.stop or B.done then return false end
  if aL(au) then B.seated=true;return true end
  if not waitUntilMobile() then return false end
  local latest=cq(au);if latest and latest.obj and latest.pos then door=latest end
  door.pos=co(door.obj) or door.pos;root=ao();if not root or not door.pos then return false end
  local range=tonumber(door.obj.MaxActivationDistance) or 10
  local actualRange=range
  if range<1 then range=10 end
  local gap=door.pos-root.Position;local horizontal=Vector3.new(gap.X,0,gap.Z).Magnitude
  local vertical=math.abs(gap.Y)
  if horizontal>math.max(2,math.min(range-1,7)) or attempt==3 or attempt==5 then
   local centerNow=at(au);local offset=centerNow and Vector3.new(door.pos.X-centerNow.X,0,door.pos.Z-centerNow.Z) or Vector3.new(1,0,0)
   local outward=offset.Magnitude>.01 and offset.Unit or Vector3.new(1,0,0)
   local side=Vector3.new(-outward.Z,0,outward.X)
   local destination=(attempt==3 or attempt==5) and door.pos+outward*2+side*(attempt==3 and 2 or -2) or door.pos
   local goal=Vector3.new(destination.X,root.Position.Y,destination.Z);local safe,whyDry=dryBoardPath(goal)
   if not safe then B.boardProblem="unsafe vehicle: return to driver crosses "..tostring(whyDry);a6("BOARD: "..B.boardProblem);return false end
   B.boardApproach=true;local ok,why=cR(goal,(attempt==3 or attempt==5) and 1 or 2,8);B.boardApproach=false
   if aL(au) then B.seated=true;return true end
   root=ao();door.pos=co(door.obj) or door.pos;if not root or not door.pos then return false end
   gap=door.pos-root.Position;horizontal=Vector3.new(gap.X,0,gap.Z).Magnitude;vertical=math.abs(gap.Y)
   if not ok then a6("BOARD: approach retry "..attempt.." "..tostring(why))end
  end
  a6("BOARD RANGE attempt="..attempt.." 3d="..p(gap.Magnitude).." horizontal="..p(horizontal).." vertical="..p(vertical).." configured="..p(actualRange).." promptEnabled="..tostring(door.obj.Enabled).." char="..tostring(root.Position).." seat="..tostring(driver and driver.Position).." characterSeat="..Y(aq() and aq().SeatPart).." humanoidState="..tostring(aq() and aq():GetState()))
  -- Within a small horizontal/vertical envelope, try the prompt even when
  -- the local 3-D calculation disagrees; only a confirmed seat counts.
  if horizontal<=math.max(5,math.min(range+2,12)) and vertical<=8 then
   local plantBoard=B.plantTestRunning and B.plantTestRunning() and not B.farmRequested
   local methodIndex=((attempt-1)%3)+1
   if (plantBoard or fishReturnBoard) and type(fireproximityprompt)=="function" then if methodIndex==1 then methodIndex=2 elseif methodIndex==2 then methodIndex=1 end end
   local ok,method=dq(door,methodIndex);a6("BOARD attempt "..attempt..": "..tostring(method).." sent="..tostring(ok))
   local untilTime=d()+(plantBoard and 1.25 or 2.0)
   while d()<untilTime and not B.stop and not B.done do
    if aL(au) then B.seated=true;a6("BOARD: seat verified");return true end;k(.1)
   end
  else
   a6("BOARD: waiting for door to settle or become reachable")
   k(.6)
  end
 end
 if aL(au) then B.seated=true;return true end
 a6("BOARD: no verified seat after five attempts");B.seated=false;return false
end;local function dG(bY)
 if tostring(bY):lower()=="sell" then
  local root=ao();local hum=aq()
  if not root or not hum or hum.SeatPart then return false,"seller exit not confirmed"end
  a6("SELL EXIT: on foot; use recorded seller route without oversized-car bounding-box escape")
  return true
 end
 if (bY=="ATM" or bY=="FISH" or tostring(bY):lower():find("shop",1,true)) and B.car then
  local root=ao();local hum=aq();if not root or not hum then return false,"missing avatar after exit"end
  local body=B.car:FindFirstChild("MD_BodyCollision",true) or B.car:FindFirstChild("Chassis",true)
  if body and body:IsA("BasePart") then
   local function inside()
    local current=ao();if not current then return false end
    local localPos=body.CFrame:PointToObjectSpace(current.Position);local half=body.Size/2
    return math.abs(localPos.X)<half.X+1 and math.abs(localPos.Z)<half.Z+1 and math.abs(localPos.Y)<half.Y+2
   end
   if not inside() then a6(tostring(bY).." EXIT: clear of live chassis");return true end
   if bY=="ATM" then
    -- The game can leave an unseated character inside the parked car's shell.
    -- Temporarily disable only this car's collisions while walking out sideways;
    -- restore every original collision state before proceeding or stopping.
    if hum.SeatPart then return false,"ATM exit: still seated" end
    local localPos=body.CFrame:PointToObjectSpace(root.Position)
    local side=localPos.X<0 and -1 or 1
    local target=body.CFrame:PointToWorldSpace(Vector3.new(side*(body.Size.X/2+4),localPos.Y,math.clamp(localPos.Z,-body.Size.Z/2,body.Size.Z/2)))
    local goal=Vector3.new(target.X,root.Position.Y,target.Z)
    local saved={}
    for _,part in ipairs(B.car:GetDescendants()) do
     if part:IsA("BasePart") then
      local ok,collide=pcall(function()return part.CanCollide end)
      if ok then saved[#saved+1]={part,collide};pcall(function()part.CanCollide=false end) end
     end
    end
    a6("ATM EXIT: walking sideways out of parked chassis; car collision temporarily off")
    local ok,cleared=pcall(function()
     hum.PlatformStand=false;hum:MoveTo(goal)
     local deadline=d()+4
     while d()<deadline and not B.stop and not B.done do
      if hum.SeatPart then return false end
      if not inside() then return true end
      k(.1)
     end
     return false
    end)
    local current=ao();if current then pcall(function()hum:MoveTo(current.Position);hum:Move(Vector3.zero,false)end) end
    for _,entry in ipairs(saved) do pcall(function()if entry[1].Parent then entry[1].CanCollide=entry[2] end end) end
    if ok and cleared and not B.stop and not B.done then a6("ATM EXIT: chassis cleared; car collision restored");return true end
    a6("ATM EXIT: unable to clear chassis; car collision restored")
    return false,"ATM: unable to walk clear of parked chassis"
   end
   local center=body.Position;local delta=Vector3.new(root.Position.X-center.X,0,root.Position.Z-center.Z)
   local dir=delta.Magnitude>.1 and delta.Unit or body.CFrame.RightVector
   local goal=root.Position+Vector3.new(dir.X,0,dir.Z)*(math.max(body.Size.X,body.Size.Z)/2+4)
   local deadline=d()+3;hum:MoveTo(goal)
   while d()<deadline and not B.stop and not B.done do if not inside() then local current=ao();if current then pcall(function()hum:MoveTo(current.Position);hum:Move(Vector3.zero,false)end) end;a6(tostring(bY).." EXIT: chassis cleared");return true end;k(.1)end
   return false,"avatar still inside live chassis"
  end
 end
 if B.routeMode~="Above ground"or not B.car then return true end;local aM,bN=aq(),ao()if not aM or not bN then return false,"missing avatar after..."end;local dH,ah,a_=pcall(function()return B.car:GetBoundingBox()end)if not dH or not ah or not a_ then return false,"cannot check car clearance"end;local function dI()local ai=ao()and V(ao(),"Position")if not ai then return true end;local S=o(function()return ah:PointToObjectSpace(ai)end)return S and math.abs(S.X)<a_.X/2+1 and math.abs(S.Z)<a_.Z/2+1 and S.Y<a_.Y/2+2 or false end;if not dI()then return true end;local dJ=cq(B.car)local dc=dJ and dJ.pos;local dz=dc and o(function()return ah:PointToObjectSpace(dc)end)local dx=dz and math.abs(dz.X)>=math.abs(dz.Z)or not dz;local dK=dx and _(dz and dz.X<0 and-a_.X/2-5 or a_.X/2+5,0,dz and dz.Z or 0)or _(dz and dz.X or 0,0,dz and dz.Z<0 and-a_.Z/2-5 or a_.Z/2+5)local dL=o(function()return ah:PointToWorldSpace(dK)end)if not dL then return false,"no safe car-door exit..."end;local ai=V(bN,"Position")local dM=_(dL.X,ai.Y+0.5,dL.Z)a6("SURFACE EXIT ["..bY.."]: freeing avatar beside...")local cK=d()while not B.stop and not B.done and d()-cK<4 do if not dI()then return true end;pcall(function()aM.PlatformStand=false;if bY~="ATM" then aM.Jump=true;aM:ChangeState(Enum.HumanoidStateType.Jumping)else aM.Jump=false end;aM:MoveTo(dM)end)k(0.25)end;return not dI(),"avatar still under car;..."end;local function dN(bY,cw,cx,cy)if not B.car or not aL(B.car)then return false,bY..": driver not seated"end;
 if B.autoDrive and B.autoDrive.done and B.routeMode=="Above ground" then
  local root=aI(B.car);if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
  local anchored,ok=pcall(function()return anchorCar(true)end)
  if not anchored or not ok then return false,"could not secure parked car before exit"end
  a6("PARK: car secured before exiting; driver route will release it on return")
 end
 local aM=aq()if not aM then return false,bY..": humanoid missing"end;pcall(function()aM.Sit=false;aM.PlatformStand=false;aM.AutoRotate=true;aM.Jump=true end)pcall(function()aM:ChangeState(Enum.HumanoidStateType.GettingUp)end)for aa=1,10 do if not aL(B.car)then break end;pcall(function()aM.Jump=true end)k(0.12)end;if aL(B.car)then return false,bY..": could not exit seat"end;k(0.2)local dO,dP=dG(bY)if not dO then return false,tostring(dP)end;local bN=ao()if bN and cw then pcall(function()local ai=bN.Position;bN.AssemblyAngularVelocity=_(0,0,0)bN.CFrame=CFrame.lookAt(ai,_(cw.X,ai.Y,cw.Z))end)end;if not cw then return true,"on foot"end;local q,cV=cR(cw,cx or 3,cy or 12)a6("ON FOOT ["..bY.."] "..tostring(q).." "..tostring(cV))return q,cV end;local function dQ(bY)if aL(B.car)then return true end;local aP=cu(B.car)local aM=aq()local dA=aP and V(aP,"Position")if not dA or not aM then return false end;local dR=_(dA.X,dA.Y+2,dA.Z)
 if tostring(bY):lower()=="sell" then
  local door=cq(B.car);local body=B.car and (B.car:FindFirstChild("MD_BodyCollision",true) or B.car:FindFirstChild("Chassis",true));local root=ao()
  if not door or not door.pos or not body or not root then B.boardProblem="driver door position unavailable";a6("SELL RETURN: "..B.boardProblem);return false end
  local offset=Vector3.new(door.pos.X-body.Position.X,0,door.pos.Z-body.Position.Z)
  local outward=offset.Magnitude>.1 and offset.Unit or Vector3.new(body.CFrame.RightVector.X,0,body.CFrame.RightVector.Z).Unit
  local stand=door.pos+outward*3
  dR=Vector3.new(stand.X,root.Position.Y,stand.Z)
  a6("SELL RETURN: approaching driver door outside vehicle; prompt="..tostring(door.pos).." stand="..tostring(dR))
 end
 local dS=B.routeMode=="Above ground"and math.min(180,math.max(20,(a3(ar(),dR)or 30)/math.max(8,t.GlideSpeed)*2.5+18))or 15;local q,cV;if B.routeMode=="Above ground" and B.shopEntryTrail and #B.shopEntryTrail>0 then
 local trail=B.shopEntryTrail;B.shopEntryTrail=nil;B.useDoorWalk=true;q=true;a6("SHOP RETURN: retracing "..#trail.." entry points")
 for j=#trail,1,-1 do
  if B.stop or B.done then q=false;cV="run stopped";break end
  local pos=ar();if pos and (pos-trail[j]).Magnitude>3.2 then
   local ok,why=cR(trail[j],2.8,12);if not ok then q=false;cV=why;break end
  end
 end
 if q then q,cV=cR(dR,5,dS)end;B.useDoorWalk=false
elseif B.routeMode=="Above ground"and B.walkedFromAtm then B.useDoorWalk=true;local ok;q,cV=nil,nil;ok,q,cV=pcall(da,true);if not ok then cV=q;q=false end;if q then q,cV=cR(dR,5,dS)end;B.useDoorWalk=false;B.walkedFromAtm=false else q,cV=cR(dR,5,dS)end;a6("RETURN TO CAR ["..bY.."] "..tostring(q).." "..tostring(cV))if not q and not aL(B.car) then return false end;if aL(B.car) then return true end;a6("RETURN TO CAR: using driver prompt without forced seat");return dt(B.car) end;local function dT()local dU;pcall(function()if type(RaycastParams)=="table"and type(RaycastParams.new)=="function"then dU=RaycastParams.new()if Enum and Enum.RaycastFilterType then dU.FilterType=Enum.RaycastFilterType.Exclude end;pcall(function()dU.IgnoreWater=false end)local dV={V(z,"Character")}if B.car then dV[#dV+1]=B.car end;if B.floor then dV[#dV+1]=B.floor end;dU.FilterDescendantsInstances=dV end end)return dU end;local function dW(a0,a2)local dU=dT()local q,bT=pcall(function()local W=_(a0,900,a2)local dX=_(0,-1800,0)if dU then return x:Raycast(W,dX,dU)end;return x:Raycast(W,dX)end)if q and bT then local dY=V(bT,"Position")if dY then return dY.Y end end;return nil end;local function dZ(a0,a1,a2,cP,cQ,de)local dU=dT()if dU then pcall(function()dU.RespectCanCollide=true end)end;if B.underground then local d_=dU and pcall(function()local e0={V(z,"Character"),B.car,x.Terrain}dU.FilterDescendantsInstances=e0 end)if not d_ then return{Position=_(a0,a1,a2),Instance={ClassName="ProbeUnavailable"}}end end;local q,bT=pcall(function()local W=_(a0,a1,a2)local dX=_(cP*de,0,cQ*de)if dU then return x:Raycast(W,dX,dU)end;return x:Raycast(W,dX)end)if q and bT and B.autoDrive and B.autoDrive.stage=="ATM" and B.autoDrive.connector and B.atmTarget then
 local hm=B.atmTarget;local near=(a0-hm.x)^2+(a2-hm.z)^2<=160^2
 if near and dU then
  local ignore={z.Character,B.car};if B.floor then ignore[#ignore+1]=B.floor end
  for pass=1,12 do
   local part=bT and bT.Instance;if not part then break end
   local cur=part;local fence=false
   for level=1,5 do if not cur or cur==x then break end;local name=cur.Name:lower();if name:find("fence",1,true) or name:find("gate",1,true) then fence=true;break end;cur=cur.Parent end
   if not fence then break end
   ignore[#ignore+1]=part;dU.FilterDescendantsInstances=ignore
   local ok,nextHit=pcall(function()return x:Raycast(_(a0,a1,a2),_(cP*de,0,cQ*de),dU)end)
   if not ok then break end;bT=nextHit
  end
 end
end
if q then return bT end;return{Position=_(a0,a1,a2),Instance={ClassName="ProbeUnavailable"}}end;local function e1(ai,cP,cQ,de,e2)if B.farmRequested and B.routeMode=="Above ground" and not B.underground then return de end;if B.routeMode=="Above ground" and not B.underground and not(B.autoDrive and B.autoDrive.connector) then return de end;local aR=de;for aa,dz in ipairs(e2 and{0,-3,3}or{0})do local bT=dZ(ai.X-cQ*dz,ai.Y+2,ai.Z+cP*dz,cP,cQ,de)if bT then local e3=V(bT,"Instance")if tostring(V(e3,"ClassName")or"")~="Terrain"then local dY=V(bT,"Position")if dY then local dV,e4=ai.X-cQ*dz,ai.Z+cP*dz;aR=math.min(aR,math.sqrt((dY.X-dV)^2+(dY.Z-e4)^2))else aR=0 end end end end;return aR end;local function e5(c0,c1,e6)local aK,e7=math.cos(e6),math.sin(e6)return c0*aK-c1*e7,c0*e7+c1*aK end;local function e8(ai,c0,c1,e9)local ea=t.DodgeLookahead or 28;local c6=d()if e9.dodgeAt and c6-e9.dodgeAt<0.10 and e9.steerX then return e9.steerX,e9.steerZ end;e9.dodgeAt=c6;local eb=e1(ai,c0,c1,ea,true)local ec=B.avoid;if not ec and eb>=ea-4 then e9.steerX,e9.steerZ=c0,c1;return c0,c1 end;local function ed(a0,a2)if math.abs(a0)>6000 or math.abs(a2)>6000 then return false end;local cz=e9.surfaceWaypoints;if cz then local cS=e9.origin;for aa,cL in ipairs(cz)do local bG,bI=cS and(cS.X or cS.x)or cL.x,cS and(cS.Z or cS.z)or cL.z;local ee,ef=cL.x,cL.z;local eg,eh=ee-bG,ef-bI;local ei=eg*eg+eh*eh;local m=ei>1 and e(((a0-bG)*eg+(a2-bI)*eh)/ei,0,1)or 0;local c2=math.sqrt((a0-bG-eg*m)^2+(a2-bI-eh*m)^2)if c2<32 then return true end;cS=cL end;return false end;local ej=e9.origin;if not ej then return true end;local ek,el=ej.X or ej.x,ej.Z or ej.z;local em,en=e9.target.x,e9.target.z;local eg,eh=em-ek,en-el;local eo=eg*eg+eh*eh;if eo<1 then return true end;local m=e(((a0-ek)*eg+(a2-el)*eh)/eo,0,1)local c2=math.sqrt((a0-ek-eg*m)^2+(a2-el-eh*m)^2)return c2<52 and math.abs(a0)<6000 and math.abs(a2)<6000 end;if not ec then local dz,aY=nil,-1;for aa,ep in ipairs({1,-1})do local eq,aZ=e5(c0,c1,ep*math.pi/2)local er=e1(ai,eq,aZ,25,true)local es,et=e5(c0,c1,ep*0.95)local eu=e1(ai,es,et,22)local ev=er+eu*0.5;if ed(ai.X+eq*19,ai.Z+aZ*19)and er>8 and ev>aY then dz,aY=ep,ev end end;if not dz then a6("DODGE: building blocks...")return nil,nil end;ec={side=dz,x=ai.X,z=ai.Z,startedAt=c6}B.avoid=ec;a6("DODGE: building "..p(eb).." studs ahead; turning "..(dz>0 and"right"or"left").." on the surface")end;local eq,aZ=e5(c0,c1,ec.side*math.pi/2)local ew=math.sqrt((ai.X-ec.x)^2+(ai.Z-ec.z)^2)if eb>=ea-3 and ew>=10 then ec.clearSince=ec.clearSince or c6;if c6-ec.clearSince>0.35 then a6("DODGE: forward lane...")B.avoid=nil;e9.steerX,e9.steerZ=c0,c1;return c0,c1 end else ec.clearSince=nil end;if c6-ec.startedAt>13 then a6("DODGE: obstacle too wide...")return nil,nil end;local ex,ey,aS=nil,nil,-1;for aa,ez in ipairs({0.45,0.8,1.15,1.57})do local eA,eB=e5(c0,c1,ec.side*ez)if ed(ai.X+eA*18,ai.Z+eB*18)then local er=e1(ai,eA,eB,22,true)if er>=10 then local ev=er+(ez<1.5 and 2 or 0)if ev>aS then ex,ey,aS=eA,eB,ev end end end end;if not ex then a6("DODGE: no safe...")return nil,nil end;e9.steerX,e9.steerZ=ex,ey;return ex,ey end;local function eC()if B.repairRemote then return B.repairRemote end;local aJ;ay(y,500,6,function(W)if aJ then return end;local aK=tostring(V(W,"ClassName")or"")if aK~="RemoteEvent"and aK~="RemoteFunction"then return end;local ab=tostring(V(W,"Name")or""):lower()for aa,av in ipairs(REPAIR_WORDS)do if ab:find(av,1,true)then aJ=W;break end end end)B.repairRemote=aJ;return aJ end;local function eD()
 if not B.car then return nil,nil end
 local hp=tonumber(B.car:GetAttribute("MD_Health"));local max=tonumber(B.car:GetAttribute("MD_MaxHealth"))
 local value=B.car:FindFirstChild("CarHealth",true);if not hp and value and value:IsA("ValueBase") then hp=tonumber(value.Value) end
 if not hp then hp=tonumber(B.car:GetAttribute("Health")) end
 return hp,max
end;local function eH(eI)
 if not t.AutoRepair then return false end
 if B.repairPoll then B.repairPoll() end
 return true
end;local function eK()if B.rodKeeper then return end;B.rodKeeper=true;i(function()while not B.stop and B.autoFish do if B.car and not rodInHand()then local eL=V(z,"Backpack")local eM=findToolIn(eL,B.cheapestRod and B.cheapestRod.name or t.RodId)or findToolIn(eL,"rod")local aM=aq()if eM and aM then pcall(function()aM:EquipTool(eM)end)B.rodDropFixes=(B.rodDropFixes or 0)+1;if B.rodDropFixes<=2 or B.rodDropFixes%20==0 then a6("ROD KEEPER: rod was put..."..tostring(B.rodDropFixes)..")")end end end;k(0.6)end;B.rodKeeper=false end)end;local function eN()if B.repairLoop then return end;B.repairLoop=true;i(function()while not B.stop and(B.busy or B.autoFish)do local ok,err=pcall(eH);if not ok then a6("REPAIR POLL ERROR: "..tostring(err))end;k(t.RepairEvery or 2.5)end;B.repairLoop=false end)end;local function eO(eP)if not B.car then return false end;
 if eP then a6("CAR COLLISION: retaining original vehicle part states; no blanket enable");return true end
 if eP and B.autoDrive and B.autoDrive.active and aL(B.car) then eP=false end;local eQ=false;ay(B.car,250,5,function(W)local aK=tostring(V(W,"ClassName")or"")if aK=="Part"or aK=="MeshPart"or aK=="UnionOperation"or aK=="WedgePart"then local q=pcall(function()W.CanCollide=eP end)if q then eQ=true end end end)a6("CAR COLLIDE "..(eP and"ON (normal)"or"OFF (parked under the map)"))return eQ end;local function arenaRestoreSurfaceCollision()
 if B.farmRequested and B.car and aL(B.car) and B.autoDrive and B.autoDrive.active and not B.skyState then return end
 if B.arenaCollisionConn then B.arenaCollisionConn:Disconnect();B.arenaCollisionConn=nil end
 local clear=true;local car=B.arenaSurfaceCar
 if car and car.Parent and B.arenaSurfaceParts then
  local body=car:FindFirstChild("MD_BodyCollision",true) or car:FindFirstChild("Chassis",true)
  if not body or not body:IsA("BasePart") then clear=false else
   local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={car,z.Character};params.MaxParts=100
   local ok,hits=pcall(function()return x:GetPartBoundsInBox(body.CFrame,body.Size+Vector3.new(1,1,1),params)end)
   if not ok then clear=false else
    local bottom=body.Position.Y-body.Size.Y/2
    if body.CFrame.UpVector.Y<.85 then clear=false end
    local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances={car,z.Character};ray.IgnoreWater=false
    local hit=x:Raycast(body.Position+Vector3.new(0,2,0),Vector3.new(0,-math.max(8,body.Size.Y+5),0),ray)
    if hit and hit.Position.Y>bottom+.75 then clear=false end
    for _,part in ipairs(hits)do if part.CanCollide and part.Position.Y+part.Size.Y/2>bottom+1 then clear=false;break end end
   end
  end
 end
 if clear then
  if B.arenaSurfaceParts then for part,value in pairs(B.arenaSurfaceParts) do pcall(function()if part.Parent then part.CanCollide=value end end)end end
  B.arenaSurfaceParts=nil;B.arenaSurfaceCar=nil
 else
  -- Car collision may remain off while overlapped. Restore the character's
  -- saved collision states independently; otherwise a failed car restore also
  -- leaves the player in the travel noclip state.
  local character=z.Character;local restored=0
  if character and B.arenaSurfaceParts then
   for part,value in pairs(B.arenaSurfaceParts) do
    if part.Parent and part:IsDescendantOf(character) then
     local ok=pcall(function()part.CanCollide=value end)
     if ok then B.arenaSurfaceParts[part]=nil;restored=restored+1 end
    end
   end
  end
  if restored>0 then a6("COLLISION: restored "..restored.." character parts; car restore remains deferred")end
  if not B.collisionWarningAt or d()-B.collisionWarningAt>3 then B.collisionWarningAt=d();a6("COLLISION RESTORE DEFERRED: vehicle body overlaps an obstacle; avoiding launch")end
 end
 if B.fishUpright then pcall(function() B.fishUpright:Destroy() end);B.fishUpright=nil end
 if B.fishUprightAttachment then pcall(function() B.fishUprightAttachment:Destroy() end);B.fishUprightAttachment=nil end
end
local function arenaSurfaceNoclip()
 if not B.car then return end
 if B.arenaSurfaceCar~=B.car then arenaRestoreSurfaceCollision();B.arenaSurfaceCar=B.car;B.arenaSurfaceParts={} end
 local function disable(model)
  if not model then return end
  for _,part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then
   if B.arenaSurfaceParts[part]==nil then B.arenaSurfaceParts[part]=part.CanCollide end
   if part.CanCollide then part.CanCollide=false end
  end end
 end
 disable(B.car);disable(z.Character)
 if not B.arenaCollisionConn then
  B.arenaCollisionConn=game:GetService("RunService").Stepped:Connect(function()
   if B.arenaSurfaceParts and B.car and B.autoDrive and B.autoDrive.active and aL(B.car) then
    pcall(disable,B.car);pcall(disable,z.Character)
   end
  end)
 end
end
B.ensureUnderFloor=function(pin,ride)
 if B.underFloor and B.underFloor.Parent then return true end
 local ok,why=pcall(function()
  local folder=Instance.new("Folder");folder.Name="DRIXN_UndergroundFloor";folder.Parent=x;B.underFloor=folder
  for ix=-3,2 do for iz=-3,2 do
   local tile=Instance.new("Part");tile.Name="Support";tile.Anchored=true;tile.Transparency=1;tile.CanCollide=true;tile.CanQuery=false;tile.CanTouch=false
   tile.Size=Vector3.new(2048,2,2048);tile.Position=Vector3.new((ix+.5)*2048,pin-ride-4,(iz+.5)*2048);tile.Parent=folder
  end end
 end)
 if not ok then if B.underFloor then B.underFloor:Destroy();B.underFloor=nil end;return false,tostring(why) end
 a6("UNDERGROUND: invisible tiled floor created locally; noclip vehicle uses vertical hold") return true
end
B.releaseUnderFloor=function()
 if B.underHold then pcall(function()B.underHold:Destroy()end);B.underHold=nil end
 if B.underFloor then B.underFloor:Destroy();B.underFloor=nil end;B.underPinY=nil
end
B.holdUnderground=function(pin)
 local seat=aq() and aq().SeatPart;local root=seat and (seat.AssemblyRootPart or seat) or aI(B.car);local pivot=at(B.car)
 if not root or not pivot then return false,"vehicle root unavailable" end;if not B.finiteVector(root.Position) or not B.finiteVector(pivot) then return false,"non-finite vehicle position" end
 local ok,why=pcall(function()
  if B.underHold then B.underHold:Destroy();B.underHold=nil end
  local hold=Instance.new("BodyPosition");hold.Name="DRIXN_UndergroundHold"
  local mass=0
  for _,part in ipairs(B.car:GetDescendants()) do if part:IsA("BasePart") and not part.Massless then
   local m=part:GetMass();if m==m and m>0 and m<10000 then mass=mass+m end
  end end
  mass=math.clamp(mass,1,10000);hold.MaxForce=Vector3.new(0,mass*workspace.Gravity*4,0)
  hold.P=mass*500;hold.D=mass*45;a6("UNDERGROUND HOLD: finite part mass="..p(mass));hold.Position=Vector3.new(root.Position.X,root.Position.Y+(pin-pivot.Y),root.Position.Z);hold.Parent=root;B.underHold=hold
 end)
 return ok,why
end
B.finiteVector=function(v)
 if not v then return false end
 for _,n in ipairs({v.X,v.Y,v.Z})do if type(n)~="number" or n~=n or math.abs(n)>100000 then return false end end
 return true
end
local function eR()if not B.pose then return end;B.pose=nil;pcall(anchorCar,false)pcall(eO,true)a6("POSE UNLOCKED - the car...")end;local function eS(a0,a1,a2,c0,c1)if not B.car then return false end;c0,c1=b_(c0,c1)local bQ=nil;pcall(function()bQ=CFrame.lookAt(_(a0,a1,a2),_(a0+c0,a1,a2+c1))end)if not bQ then pcall(function()bQ=CFrame.new(a0,a1,a2,a0+c0,a1,a2+c1)end)end;if not bQ then return false end;local q=pcall(function()B.car:PivotTo(bQ)end)if not q then q=pcall(function()B.car:SetPrimaryPartCFrame(bQ)end)end;if q then B.facingTicks=B.facingTicks+1 end;return q end;local function eT(a0,a2,a1,c0,c1)if not B.finiteVector(Vector3.new(a0,a1,a2)) or not B.finiteVector(Vector3.new(c0,0,c1)) then return false,"non-finite placement input"end;if B.stop or not B.car or not aL(B.car)then return false,"driver not seated"end;if not eS(a0,a1,a2,c0,c1)then return false,"vehicle placement refused"end;k(0.25)local ai=at(B.car)if not B.finiteVector(ai) or not aL(B.car)or math.abs(ai.Y-a1)>3 or math.sqrt((ai.X-a0)^2+(ai.Z-a2)^2)>3 then return false,"placement expected="..tostring(Vector3.new(a0,a1,a2)).." actual="..tostring(ai).." seated="..tostring(aL(B.car)) end;return true end;local function eU(au)if B.vehicleProfile and B.vehicleProfile.car==au and B.vehicleProfile.wheels then return B.vehicleProfile.wheels end;if B.wheelCacheCar==au and B.wheelCache then return B.wheelCache end;local af={}ay(au,250,5,function(W)local aX=tostring(V(W,"Name")or""):lower()local am=tostring(V(W,"ClassName")or"")if(am=="Part"or am=="MeshPart")and(aX:find("wheel",1,true)or aX:find("tire",1,true)or aX:find("tyre",1,true))then af[#af+1]=W end end)B.wheelCacheCar,B.wheelCache=au,af;return af end;B.scanVehicle=function(car)
 if not car or not car.Parent or not b3(car) then return false,"owned vehicle missing" end
 local deadline=d()+4;local seat,door
 repeat
  seat=cu(car);door=cq(car)
  if seat and door and door.obj and door.pos then break end
  if B.stop or B.done then return false,"scan cancelled" end
  k(.2)
 until d()>=deadline
 if not seat or not door or not door.obj or not door.pos then return false,"driver seat or driver prompt not replicated" end
 local ok,desc=pcall(function()return car:GetDescendants()end);if not ok or type(desc)~="table" then return false,"vehicle descendants unavailable" end
 local boundsOk,box,size=pcall(function()return car:GetBoundingBox()end)
 if not boundsOk or not size or size.X<=0 or size.Y<=0 or size.Z<=0 then return false,"vehicle bounds unavailable" end
 local profile={car=car,name=car.Name,size=size,seat=seat,prompt=door.obj,parts=0,anchored=0,collidable=0,mass=0,wheels={},seats=0,prompts=0,detail={},total=#desc}
 local finite=function(n)return type(n)=="number" and n==n and n>0 and n<100000 end
 for _,obj in ipairs(desc) do
  local line=tostring(obj.ClassName).." "..Y(obj)
  if obj:IsA("BasePart") then
   profile.parts=profile.parts+1;if obj.Anchored then profile.anchored=profile.anchored+1 end;if obj.CanCollide then profile.collidable=profile.collidable+1 end
   if not obj.Massless then local okMass,m=pcall(function()return obj:GetMass()end);if okMass and finite(m)then profile.mass=profile.mass+m end end
   local n=obj.Name:lower();local cur=obj.Parent
   for level=1,3 do if not cur or cur==car then break end;n=n.." "..cur.Name:lower();cur=cur.Parent end
   if (n:find("wheel",1,true) or n:find("tire",1,true) or n:find("tyre",1,true)) and not n:find("steering",1,true) and not n:find("spare",1,true) then profile.wheels[#profile.wheels+1]=obj end
   line=line.." size="..tostring(obj.Size).." collide="..tostring(obj.CanCollide).." anchored="..tostring(obj.Anchored).." massless="..tostring(obj.Massless)
  elseif obj:IsA("Seat") or obj:IsA("VehicleSeat") then profile.seats=profile.seats+1
  elseif obj:IsA("ProximityPrompt") then profile.prompts=profile.prompts+1;line=line.." range="..tostring(obj.MaxActivationDistance).." enabled="..tostring(obj.Enabled) end
  profile.detail[#profile.detail+1]=line
 end
 -- Seat subclasses also count as BaseParts, so compute their count separately.
 profile.seats=0;for _,obj in ipairs(desc)do if obj:IsA("Seat") or obj:IsA("VehicleSeat") then profile.seats=profile.seats+1 end end
 local maxSpeed,source=bV(car);profile.gameSpeed=finite(maxSpeed) and maxSpeed or nil;profile.speedSource=source or "unknown"
 profile.width=math.min(size.X,size.Z);profile.length=math.max(size.X,size.Z);profile.height=size.Y
 profile.pathRadius=math.clamp(profile.width/2+.75,2,12);profile.pathHeight=math.clamp(math.ceil(size.Y+1),5,20)
 B.vehicleProfile=profile;B.wheelCacheCar=car;B.wheelCache=profile.wheels
 a6("VEHICLE SCAN: "..profile.name.." descendants="..profile.total.." parts="..profile.parts.." wheels="..#profile.wheels.." seats="..profile.seats.." prompts="..profile.prompts.." dimensions="..tostring(size).." mass="..p(profile.mass).." speed="..tostring(profile.gameSpeed).." source="..profile.speedSource.." driver="..Y(seat).." prompt="..Y(door.obj))
 if #profile.wheels==0 then a6("VEHICLE SCAN: no named wheels found; ride-height fallback will be used")end
 return true
end
local function eV(a0,a2,eW)local dU=dT()local eX=eW or 900;local eY=eW and 120 or 1800;local q,bT=pcall(function()if dU then return x:Raycast(_(a0,eX,a2),_(0,-eY,0),dU)end;return x:Raycast(_(a0,eX,a2),_(0,-eY,0))end)if not q or not bT then return nil,"no ground"end;local ai=V(bT,"Position")local eZ=tostring(V(bT,"Material")or"")if not ai or eZ:lower():find("water",1,true)then return nil,"water/no ground"end;return ai.Y,eZ end;local function e_(bQ,f0)local f1=at(B.car)or ar()if not f1 then return nil,"no car position"end;if f0=="ATM" or f0=="PLANT_ATM" then local a1,cV=eV(bQ.x,bQ.z,(bQ.y or f1.Y)+2)if not a1 then return nil,"ATM parking has no dry ground: "..tostring(cV)end;if bQ.y and math.abs(a1-bQ.y)>6 then return nil,"ATM parking height mismatch: targetY="..p(bQ.y).." groundY="..p(a1).." material="..tostring(cV).." planned="..tostring(bQ.atmPark)end;return{x=bQ.x,y=a1,z=bQ.z,atmPark=bQ.atmPark,pivotY=bQ.y,hx=bQ.hx,hz=bQ.hz,stand=bQ.stand,seatDist=bQ.seatDist},"marked ATM parking"end;local aR,aY=nil,1e9;local eg,eh=f1.X-bQ.x,f1.Z-bQ.z;local f2=math.max(0.1,math.sqrt(eg*eg+eh*eh))local f3=math.atan2(eh,eg)for aa,bh in ipairs(f0=="SHOP"and{6,8,10,12,14}or{13,17,22,28})do for aa,ez in ipairs({0,0.45,-0.45,0.9,-0.9,1.6,-1.6,3.14})do local a0,a2=bQ.x+math.cos(f3+ez)*bh,bQ.z+math.sin(f3+ez)*bh;local f4=tonumber(bQ.y)or f1.Y;local a1=eV(a0,a2,f4+1.5)if a1 and a1<=f4+1.25 and a1>=f4-5 and math.abs(a1-f1.Y)<90 then local cG=true;local q,aU=pcall(function()return x:GetPartBoundsInBox(CFrame.new(a0,a1+3,a2),_(9,5,12))end)if not q or type(aU)~="table"then cG=false end;if q and type(aU)=="table"then for aa,W in ipairs(aU)do local f5=o(function()return W:IsDescendantOf(B.car)end)local ap=V(z,"Character")local f6=ap and o(function()return W:IsDescendantOf(ap)end)local f7=o(function()return W.Position.Y+W.Size.Y/2 end)if not f5 and not f6 and V(W,"CanCollide")~=false and(not f7 or f7>a1+1.2)then cG=false;break end end end;local ev=bh+math.abs(ez)*2+math.sqrt((a0-f1.X)^2+(a2-f1.Z)^2)*0.02;if cG and ev<aY then aR={x=a0,y=a1,z=a2}aY=ev end end end;if aR then break end end;if not aR then return nil,"no safe surface parking..."..tostring(f0)end;return aR,"safe parking "..p(aY).." score"end;local function f8(cE,f9)local cC,d1;local q=pcall(function()local fa=game:GetService("PathfindingService");local radius=6
 local body=B.car and (B.car:FindFirstChild("MD_BodyCollision",true) or B.car:FindFirstChild("Chassis",true))
 if body and body:IsA("BasePart")then radius=math.clamp(math.min(body.Size.X,body.Size.Z)/2+1,3,12)end
 local height=body and math.clamp(body.Size.Y+3,6,14) or 8
 a6("CONNECTOR PATH: collision body radius="..p(radius).." height="..p(height))
 cC=fa:CreatePath({AgentRadius=radius,AgentHeight=height,AgentCanJump=false,WaypointSpacing=10})cC:ComputeAsync(cE,_(f9.x,f9.y+2,f9.z))if cC.Status==Enum.PathStatus.Success then d1=cC:GetWaypoints()end end)if not q or type(d1)~="table"or#d1<2 or#d1>220 then return nil end;local cz={}for a7,cD in ipairs(d1)do local f=V(cD,"Position")if not f or tostring(V(cD,"Action")):find("Jump",1,true)then return nil end;local fb=eV(f.X,f.Z,f.Y+7)if not fb or math.abs(fb-f.Y)>5 or math.abs(fb-f9.y)>12 then return nil end;if a7>1 then cz[#cz+1]={x=f.X,z=f.Z}end end;cz[#cz+1]={x=f9.x,z=f9.z}a6("SURFACE ROAD PATH: "..#cz.." wide-car waypoints...")return cz end;local function fc(a0,a1,a2,c0,c1,fb)if B.routeMode=="Above ground" and not B.underground and not(B.autoDrive and B.autoDrive.connector) then return true end;local au=B.car;local fd=au and ax(au)local q,fe,a_=pcall(function()return au:GetBoundingBox()end)if not fd or not q or not fe or not a_ then return false end;local ff=o(function()return fd:ToObjectSpace(fe)end)if not ff then return false end;local fg=CFrame.lookAt(_(a0,a1,a2),_(a0+c0,a1,a2+c1))local cj,aU=pcall(function()return x:GetPartBoundsInBox(fg*ff,a_)end)if not cj or type(aU)~="table"then return false end;for aa,d7 in ipairs(aU)do local f5=o(function()return d7:IsDescendantOf(au)end)local ap=V(z,"Character")local f6=ap and o(function()return d7:IsDescendantOf(ap)end)local f7=o(function()return d7.Position.Y+d7.Size.Y/2 end)if not f5 and not f6 and V(d7,"CanCollide")~=false and(not f7 or f7>fb+0.8)then return false end end;return true end;local function fh(ai,c0,c1,e9,eI)if B.routeMode=="Above ground" and not B.underground and e9 and e9.connector~=true then return nil,nil end;local fb=eV(ai.X,ai.Z,ai.Y+7)if not fb then return nil,nil end;local fi=e9.localTurn;if fi and not eI then local cP,cQ=fi.x-ai.X,fi.z-ai.Z;local fj=math.sqrt(cP*cP+cQ*cQ)if fj>2.0 then local eA,eB=cP/fj,cQ/fj;if e1(ai,eA,eB,math.min(fj+4,60),true)>math.min(fj,50)then return eA,eB end else e9.localTurn=nil end end;local fk=(e9.connector and e9.surfaceWaypoints and e9.surfaceWaypoints[e9.roadIndex or 1]) or e9.target;if fk and fk.x and fk.z and not eI then local fl,fm=fk.x-ai.X,fk.z-ai.Z;local fn=math.sqrt(fl*fl+fm*fm)if fn>4 then local fo,fp=fl/fn,fm/fn;local fq=e1(ai,fo,fp,math.min(fn+4,180),true)if fq>math.min(fn-2,140)then e9.localTurn=nil;e9.blockedAt=nil;return fo,fp end end end;e9.turnCount=(e9.turnCount or 0)+1;local fr=e9.surfaceWaypoints;local fs=fr and fr[e9.roadIndex or 1]or e9.target;local ft=math.sqrt((fs.x-ai.X)^2+(fs.z-ai.Z)^2)local fk=e9.target;local fu=fk and math.sqrt((fk.x-ai.X)^2+(fk.z-ai.Z)^2)or 0;local fv=e9.turnVisited or{}e9.turnVisited=fv;local ah=ax(B.car)local fw=ah and V(ah,"LookVector")local fx,fy=fw and fw.X or c0,fw and fw.Z or c1;local fz=math.max(0.001,math.sqrt(fx*fx+fy*fy))fx,fy=fx/fz,fy/fz;local fA,fB=c0,c1;local fC=math.max(0.001,math.sqrt(fA*fA+fB*fB))fA,fB=fA/fC,fB/fC;local cx=math.max(100,math.min(300,t.SurfaceScanRadius or 160))local aR,aS=nil,-1e9;local fD={}for a7=0,23 do table.insert(fD,a7*math.pi/12)end;for aa,e6 in ipairs(fD)do local eA,eB=e5(c0,c1,e6)local er=e1(ai,eA,eB,cx,true)local fE=math.min(e9.stage=="ATM" and 20 or 50,er-5)if fE>=6 then local db=eA*fx+eB*fy<-0.5;local fF,fG=db and fx or eA,db and fy or eB;local fH=db or fc(ai.X,ai.Y,ai.Z,fF,fG,fb)if fH then local fI=true;local fJ=math.ceil(fE/5)for bd=1,fJ do local m=fE*bd/fJ;local a0,a2=ai.X+eA*m,ai.Z+eB*m;local bh=eV(a0,a2,ai.Y+7)if not bh or math.abs(bh-fb)>2.8 or math.abs(a0)>6000 or math.abs(a2)>6000 or not fc(a0,bh+(B.surfaceRideHeight or 2.5),a2,fF,fG,bh)then fI=false;break end end;if fI then local a0,a2=ai.X+eA*fE,ai.Z+eB*fE;local fK=math.sqrt((fs.x-a0)^2+(fs.z-a2)^2)local fL=fk and math.sqrt((fk.x-a0)^2+(fk.z-a2)^2)or fK;local fM=math.max(0,fL-fu)local fN=e1({X=a0,Y=ai.Y,Z=a2},eA,eB,22,true)if fL<=fu+200 or fN>14 then local b5=math.floor(a0/10)..":"..math.floor(a2/10)local fO=fv[b5]or 0;local fP=eA*fA+eB*fB;local aY=(ft-fK)*(e9.stage=="ATM" and 4 or 2.2)+er*0.8+fP*(e9.stage=="ATM" and 50 or 25)-fO*50-(db and 4 or 0)-fM*(e9.stage=="ATM" and 3 or 0.6)+fN*0.4;if aY>aS then aR={x=a0,z=a2,fx=eA,fz=eB,faceX=fF,faceZ=fG,key=b5,angle=e6,open=er,travel=fE}aS=aY end end end end end end;if not aR then if e1(ai,-fx,-fy,45,false)>22 then local fQ=true;for aa,de in ipairs({8,16,24,36})do local a0,a2=ai.X-fx*de,ai.Z-fy*de;local bh=eV(a0,a2,ai.Y+7)if not bh or math.abs(bh-fb)>2.8 or not fc(a0,bh+(B.surfaceRideHeight or 2.5),a2,fx,fy,bh)then fQ=false;break end end;if fQ then local a0,a2=ai.X-fx*36,ai.Z-fy*36;local b5=math.floor(a0/10)..":"..math.floor(a2/10)fv[b5]=(fv[b5]or 0)+1;e9.localTurn={x=a0,z=a2,at=d(),faceX=fx,faceZ=fy}e9.stuckAt,e9.progressAt,e9.blockedAt=d(),d(),nil;a6("DEAD END: reverse 36...")return-fx,-fy end end;return nil,nil end;fv[aR.key]=(fv[aR.key]or 0)+1;e9.localTurn={x=aR.x,z=aR.z,at=d(),faceX=aR.faceX,faceZ=aR.faceZ}e9.stuckAt,e9.progressAt=d(),d()e9.blockedAt=nil;a6("SMART DODGE: angle="..p(aR.angle*180/math.pi).." travel="..p(aR.travel).." open="..p(aR.open).." sameDir="..p(aR.fx*fA+aR.fz*fB).." ("..e9.turnCount..")")return aR.fx,aR.fz end;-- Route graph sampled from the two supplied recordings; vehicle points only.
do
local arenaRouteNodes={}
for x,y,z in ([=[689.43,256.31,330.87;664.25,254.81,290.24;645.59,254.81,262.25;626.92,254.81,234.26;608.31,255.06,206.33;592.12,254.82,176.85;587.77,254.81,144.91;603.95,255.21,120.46;563.32,254.93,98.76;539.74,254.94,74.86;517.06,254.96,51.90;492.24,254.98,32.92;461.94,256.45,29.65;430.68,256.17,40.99;399.96,255.61,52.02;371.46,255.60,66.80;346.54,255.46,89.33;321.57,255.46,111.90;296.62,255.61,134.46;271.70,255.71,156.99;241.76,255.70,184.06;215.83,255.47,205.75;188.08,255.92,224.67;158.59,255.72,241.34;125.91,255.71,249.47;93.38,255.70,257.55;60.65,255.81,265.69;28.08,255.46,273.79;-3.27,255.46,281.58;-35.82,255.46,289.68;-69.05,255.72,296.63;-102.49,255.62,298.78;-136.00,255.62,300.93;-169.60,255.62,303.09;-203.14,255.62,305.24;-219.00,255.62,331.62;-219.62,255.62,363.52;-219.25,255.61,387.98;-221.24,255.04,362.76;-219.87,255.04,330.46;-209.87,255.04,300.58;-183.22,263.09,292.74;-153.29,254.87,292.16;-122.49,255.14,308.17;-123.47,255.12,341.27;-131.66,255.04,373.90;-121.73,255.05,397.05;-138.33,255.04,425.79;-137.29,255.35,435.69;-90.75,255.45,444.77;-78.86,255.35,474.19;-78.40,255.34,508.48;-87.94,255.44,541.47;-128.30,255.45,542.68;-162.15,255.44,542.78;-192.90,255.35,533.44;-194.13,255.34,503.30;-213.74,256.00,486.68;-207.25,255.35,482.99;-188.88,255.35,508.96;-186.35,255.44,536.19;-153.09,255.44,539.49;-119.47,255.44,539.38;-87.50,255.44,537.35;-58.83,255.19,519.87;-30.13,255.19,502.37;-1.43,255.19,484.87;26.13,255.19,468.06;56.42,255.37,452.32;88.46,255.43,449.04;103.57,255.43,439.76;94.26,255.44,407.48;84.93,255.46,375.14;75.63,255.45,342.90;66.32,255.42,310.61;56.99,255.39,278.27;55.98,255.67,243.85;60.57,255.52,210.09;61.59,255.54,176.48;79.29,255.43,148.77;99.09,262.10,158.04;61.75,256.22,133.90;36.90,255.97,111.30;12.06,255.97,88.72;-10.98,255.97,63.63;-21.74,255.97,31.83;-32.10,255.97,1.20;-42.86,255.97,-30.62;-53.62,255.97,-62.40;-64.41,255.97,-94.30;-68.81,256.22,-126.49;-67.97,256.22,-160.02;-70.01,256.22,-196.33;-98.40,256.26,-211.75;-127.89,256.32,-227.78;-157.20,256.56,-242.35;-185.72,256.25,-259.21;-194.34,255.46,-266.36;-157.14,255.46,-282.18;-126.15,255.46,-295.36;-95.34,259.27,-297.06;-74.01,268.28,-293.70;-43.13,255.19,-280.54;-19.66,255.16,-270.51;-29.09,255.18,-289.62;-25.32,255.18,-321.70;-21.40,255.18,-355.08;-17.48,255.18,-388.51;-13.72,255.73,-420.55;-8.86,255.73,-454.16;2.89,255.18,-485.58;14.24,255.18,-515.96;25.94,255.18,-547.24;44.59,255.44,-581.15;70.48,264.59,-583.95;86.77,255.42,-573.77;97.25,256.46,-570.07;72.29,264.43,-591.53;48.88,255.45,-583.07;32.07,255.19,-560.36;19.39,255.19,-529.29;6.72,255.19,-498.19;-5.46,255.74,-468.33;-18.14,255.19,-437.24;-30.36,255.19,-407.26;-43.03,255.19,-376.21;-55.72,255.19,-345.08;-66.34,255.44,-313.89;-67.37,255.44,-274.07;-65.90,255.44,-241.69;-64.39,255.44,-208.17;-62.87,255.44,-174.59;-61.35,255.44,-141.15;-59.83,255.24,-107.52;-58.36,255.19,-75.00;-56.88,255.19,-42.26;-55.40,255.19,-9.54;-53.93,255.19,22.95;-52.74,255.19,56.83;-58.83,255.34,90.03;-65.85,255.29,122.97;-72.82,255.35,155.68;-79.80,255.35,188.42;-88.25,255.35,228.06;-96.04,255.15,258.84;-117.84,254.26,286.79;-147.57,255.36,299.84;-180.97,255.35,303.01;-214.54,255.35,306.20;-219.62,255.35,334.73;-219.23,255.35,367.54;-219.25,255.34,387.98;-220.73,255.04,350.58;-219.01,255.04,310.21;-190.47,255.04,294.41;-165.08,260.24,291.76;-133.86,255.04,299.78;-120.23,255.04,328.40;-128.38,255.14,360.86;-132.96,255.05,389.56;-130.10,255.04,415.28;-146.14,256.32,435.69;-153.85,255.35,439.76;-122.63,255.35,433.57;-81.70,255.44,457.08;-76.52,255.35,489.26;-81.17,255.35,522.80;-102.66,255.45,541.91;-143.13,255.45,543.13;-176.90,255.44,541.22;-193.04,255.35,518.66;-199.62,255.35,488.25;-199.67,255.35,483.42;-189.09,255.35,516.45;-180.06,255.44,536.86;-146.77,255.44,539.47;-113.13,255.44,539.36;-82.08,255.44,534.04;-53.39,255.19,516.55;-24.67,255.19,499.04;3.92,255.16,481.61;31.58,255.19,464.74;62.73,255.42,451.67;96.14,255.43,448.25;105.69,255.43,447.12;97.49,255.43,418.71;98.51,254.91,396.76;126.06,254.92,374.12;158.30,254.92,364.59;184.33,254.79,352.01;201.89,255.41,335.48;222.39,254.65,312.07;244.57,254.69,286.66;251.60,254.90,257.88;257.59,254.65,227.65;272.86,254.41,197.65;287.42,254.66,168.99;302.66,254.65,139.03;321.02,254.65,110.57;345.46,254.65,81.52;367.04,254.80,55.87;388.72,254.81,30.11;413.67,254.78,15.01;441.99,254.77,31.11;444.05,254.97,33.06;429.48,255.35,18.99;409.05,255.20,-7.51;388.43,255.74,-34.26;368.10,255.19,-60.63;347.51,255.19,-87.33;322.89,255.19,-119.25;298.37,255.44,-131.97;285.46,255.54,-153.07;273.07,255.46,-176.15;250.96,255.46,-200.01;222.00,255.42,-217.01;193.01,255.43,-234.02;181.89,255.53,-241.80;200.39,255.44,-263.42;208.71,255.45,-296.00;217.03,255.46,-328.62;234.85,254.22,-353.65;261.16,255.21,-370.00;285.10,255.27,-390.80;299.51,255.20,-427.63;302.40,255.19,-459.98;302.47,255.19,-493.61;299.05,255.19,-526.66;281.54,255.19,-552.30;258.85,256.97,-575.58;235.32,255.19,-589.38;223.36,255.20,-620.79;206.21,255.39,-637.94;186.31,255.01,-643.25;217.24,255.64,-640.49;222.73,255.67,-600.23;217.17,258.32,-572.41;186.27,259.27,-570.48;139.38,255.69,-571.96;110.58,254.70,-570.38;98.18,255.01,-572.54;77.45,262.60,-587.53;55.18,255.63,-585.24;34.14,255.19,-565.46;21.44,255.19,-534.31;8.75,255.19,-503.18;-3.92,255.74,-472.10;-16.58,255.20,-441.06;-29.30,255.19,-409.88;-41.98,255.19,-378.77;-57.22,255.19,-341.40;-66.89,255.44,-309.89;-67.49,255.44,-276.83;-65.97,255.44,-243.22;-64.45,255.44,-209.58;-62.93,255.44,-176.04;-61.47,255.44,-143.60;-59.95,255.41,-110.09;-58.43,255.19,-76.46;-56.97,255.19,-44.28;-55.46,255.19,-10.83;-53.94,255.19,22.87;-52.71,255.19,56.59;-58.77,255.34,89.78;-65.78,255.29,122.64;-74.21,255.35,162.20;-80.98,255.35,193.92;-87.97,255.35,226.70;-95.68,255.16,258.23;-117.30,256.67,285.47;-146.02,255.36,299.69;-179.34,255.35,302.86;-212.87,255.35,306.04;-219.59,255.35,334.56;-219.24,255.35,367.46;-219.25,255.35,387.98;-220.20,255.04,338.18;-218.77,255.04,304.61;-185.63,255.74,293.04;-160.22,258.46,292.20;-128.87,255.04,302.40;-121.59,255.04,333.78;-129.74,255.14,366.27;-128.26,255.05,392.69;-133.56,255.04,419.69;-146.25,256.35,435.69;-153.85,255.35,439.76;-121.29,257.25,433.38;-98.72,255.45,444.11;-80.35,255.34,465.18;-76.52,255.34,498.77;-82.92,255.35,531.84;-111.91,255.45,542.19;-144.22,255.45,543.16;-177.95,255.44,541.11;-193.04,255.35,518.99;-199.60,255.34,488.29;-216.13,255.98,486.60;-190.92,255.35,499.71;-188.92,255.35,533.86;-161.77,255.44,538.79;-121.60,255.44,539.39;-90.45,255.44,539.15;-61.71,255.26,521.63;-33.02,255.19,504.13;-5.49,255.19,487.34;23.27,255.19,469.81;50.80,255.32,453.03;85.09,255.43,449.38;112.10,255.61,450.67;103.67,255.43,440.08;94.35,255.44,407.79;85.04,255.46,375.49;75.72,255.45,343.20;66.40,255.42,310.87;57.07,255.39,278.53;55.99,255.67,243.85;60.56,255.52,210.24;61.58,255.54,176.68;79.18,255.43,148.88;99.22,255.60,147.17;93.78,254.76,155.65;130.14,255.61,140.05;163.33,255.61,134.42;196.19,255.62,128.53;228.32,255.59,118.90;260.52,255.61,109.25;290.31,255.36,96.46;317.40,255.36,76.47;343.28,255.36,57.36;370.55,255.51,37.24;397.34,255.50,17.46;427.50,255.59,22.61;433.24,255.44,23.86;412.70,255.19,-2.78;392.19,255.74,-29.38;371.76,255.19,-55.88;351.23,255.19,-82.50;330.75,255.19,-109.06;310.28,255.37,-131.86;280.16,255.43,-140.19;275.29,255.46,-173.36;254.07,255.46,-198.19;226.17,255.42,-214.57;197.19,255.42,-231.57;199.26,255.44,-259.01;207.53,255.45,-291.39;215.66,255.46,-323.26;228.29,253.93,-351.35;257.25,255.20,-367.09;284.24,255.19,-387.19;295.60,255.19,-417.58;302.38,255.19,-449.21;302.44,255.19,-482.80;300.57,255.19,-515.05;289.88,255.19,-543.72;266.61,255.19,-567.68;239.66,255.29,-579.84;224.85,255.19,-616.93;208.71,255.38,-639.25;191.90,254.94,-643.94;222.85,255.67,-633.93;222.73,255.67,-600.27;213.35,255.63,-572.67;187.58,259.42,-570.10;138.15,255.69,-571.99;110.26,254.03,-570.52;96.64,254.97,-570.15;73.08,264.62,-591.41;47.66,255.44,-582.65;31.61,255.19,-559.24;18.91,255.19,-528.10;6.22,255.19,-496.97;-6.44,255.74,-465.91;-19.12,255.19,-434.83;-34.39,255.19,-397.39;-46.59,255.19,-367.47;-59.29,255.19,-336.31;-67.62,255.44,-304.61;-67.25,255.44,-271.49;-65.72,255.44,-237.64;-64.21,255.44,-204.19;-62.68,255.44,-170.56;-61.16,255.44,-136.95;-59.66,255.19,-103.77;-58.18,255.19,-70.97;-56.65,255.19,-37.22;-55.14,255.19,-3.82;-53.63,255.19,29.72;-53.41,255.19,63.57;-60.96,255.44,100.02;-67.95,255.31,132.84;-74.94,255.35,165.61;-81.93,255.35,198.41;-88.95,255.35,231.33;-99.71,255.02,263.45;-119.25,255.28,289.48;-150.67,255.36,300.14;-184.20,255.35,303.32;-214.66,255.35,306.23;-220.43,255.35,339.39;-218.76,255.35,372.32;-219.65,255.04,325.12;-205.98,255.04,299.34;-179.18,263.87,292.18;-149.00,255.04,292.27;-120.60,255.14,311.90;-124.50,255.14,345.40;-132.69,255.04,377.99;-120.21,255.05,402.64;-140.94,255.04,429.12;-145.29,255.44,436.95;-118.59,260.67,436.36;-97.23,255.45,444.10;-79.94,255.35,467.68;-78.36,255.35,508.32;-87.88,255.44,541.47;-121.53,255.45,542.48;-153.86,255.44,543.46;-187.59,255.44,540.09;-193.25,255.35,509.23;-207.17,255.35,487.00;-207.12,255.35,483.00;-188.88,255.35,508.94;-186.30,255.44,536.20;-153.07,255.44,539.49;-119.42,255.44,539.38;-81.67,255.44,533.79;-52.96,255.19,516.29;-24.27,255.19,498.80;4.39,255.19,481.32;33.14,255.19,463.79;64.48,255.43,451.49;98.16,255.43,448.04;113.79,256.36,455.42;113.37,255.44,421.97;117.64,255.45,389.77;142.03,255.45,370.30;173.86,255.46,360.18;193.05,264.35,345.36;210.98,255.34,325.14;233.11,255.19,299.78;252.85,255.44,275.57;250.63,255.12,241.36;264.78,254.47,213.47;279.97,255.20,183.65;295.20,255.20,153.71;310.40,255.19,123.82;332.02,255.19,97.50;357.48,255.33,67.24;379.07,255.35,41.57;400.35,255.34,16.29;429.79,255.43,24.55;428.47,255.33,17.68;407.93,255.19,-8.96;387.53,255.66,-35.42;366.97,255.19,-62.09;346.36,255.19,-88.81;326.76,255.19,-114.24;303.91,255.54,-131.86;285.68,255.54,-153.38;271.96,255.47,-177.54;250.61,255.46,-200.22;221.67,255.42,-217.20;192.69,255.43,-234.21;181.24,256.23,-228.23;170.44,255.46,-196.63;159.50,255.46,-164.80;148.59,255.44,-133.07;134.46,255.54,-96.75;112.14,255.19,-71.66;90.49,255.19,-47.33;68.32,255.19,-22.43;45.96,255.19,2.70;23.69,255.19,27.73;1.26,255.19,52.94;-15.21,255.19,81.16;-29.58,255.19,111.53;-43.93,255.19,141.87;-58.36,255.20,172.35;-72.73,255.35,202.74;-87.13,255.35,233.16;-99.58,255.17,263.39;-119.72,255.27,290.27;-159.57,255.35,300.98;-193.06,255.35,304.16;-216.18,255.35,314.99;-220.67,255.35,347.77;-217.93,255.35,380.86;-225.06,255.09,360.28;-221.97,255.09,326.67;-199.13,255.10,296.60;-173.39,263.93,292.14;-143.29,255.10,292.14;-122.17,262.33,285.10;-109.18,262.21,254.89;-93.21,255.10,231.08;-87.03,255.10,198.20;-81.04,255.10,166.38;-74.82,255.10,133.33;-68.59,255.18,100.20;-84.27,254.94,71.53;-108.89,254.94,48.62;-132.92,254.94,58.49;-158.09,260.21,62.79;-180.00,255.00,58.13;-211.40,255.00,70.14;-243.63,257.01,66.01;-277.23,254.99,58.43;-308.34,254.99,64.72;-335.14,254.94,85.00;-361.71,254.95,105.10;-389.61,255.11,122.10;-422.94,254.95,125.11;-446.16,255.19,144.13;-468.03,255.19,169.99;-498.80,259.48,193.25;-498.71,259.73,186.08;-478.31,257.76,162.53;-466.02,255.19,139.06;-463.85,255.19,105.47;-475.69,255.19,76.58;-497.15,255.19,42.42;-511.50,262.49,16.67;-516.17,255.19,-9.75;-525.55,255.19,-41.97;-534.97,255.37,-74.30;-544.34,255.46,-106.48;-562.94,255.46,-129.78;-588.85,255.42,-150.44;-595.35,255.12,-157.80;-566.72,255.46,-147.56;-536.34,255.46,-159.53;-505.43,255.46,-172.78;-475.66,260.50,-181.66;-445.83,255.46,-176.03;-418.00,259.99,-166.93;-384.46,255.19,-165.21;-352.21,255.19,-163.07;-319.57,255.45,-156.12;-303.16,255.46,-177.29;-298.28,255.46,-209.37;-293.26,255.52,-242.45;-268.90,255.46,-261.26;-236.57,255.32,-260.72;-203.62,256.99,-255.40;-196.45,256.09,-258.49;-174.61,255.46,-282.08;-152.58,255.46,-307.50;-128.87,255.54,-329.96;-96.45,255.54,-339.65;-73.66,255.19,-359.84;-55.17,255.19,-387.43;-40.45,255.19,-417.61;-25.72,255.19,-447.81;-11.53,255.74,-476.91;3.18,255.19,-507.08;17.86,255.19,-537.17;32.05,255.19,-566.29;59.02,255.43,-583.63;73.78,265.00,-573.07;96.04,255.14,-573.52;98.18,255.44,-572.54;122.83,255.44,-575.06;156.30,255.43,-575.19;180.44,264.87,-572.68;188.92,255.19,-551.52;192.34,264.34,-523.94;197.47,255.22,-501.56;203.26,255.18,-468.84;203.27,255.20,-435.41;203.44,255.56,-404.20;204.78,255.19,-369.73;204.06,255.34,-337.23;203.31,255.45,-303.79;202.41,255.44,-263.35;192.25,254.49,-243.14;192.30,254.21,-243.12;228.97,255.42,-225.59;261.91,255.42,-218.89;293.63,255.37,-212.43;325.27,255.19,-206.00;355.27,255.21,-203.94;390.18,255.21,-205.64;422.68,255.20,-205.89;455.37,255.20,-208.26;487.50,255.20,-213.63;520.72,255.20,-218.50;554.43,255.20,-218.48;586.80,255.20,-216.95;627.95,255.19,-210.67;661.16,255.19,-205.61;692.85,255.19,-198.43;707.73,255.19,-169.14;702.18,255.19,-135.66;725.07,255.19,-128.69;759.04,255.18,-127.51;788.10,255.19,-135.89;820.88,255.42,-144.18;830.66,255.44,-165.25;795.44,258.40,-143.35;813.12,262.69,-155.41;829.62,255.09,-176.21;835.71,254.67,-155.29;814.00,259.73,-137.13;812.61,267.98,-118.40;808.64,255.39,-85.02;783.18,255.19,-65.35;752.12,255.19,-52.67;721.10,255.19,-40.00;691.14,255.19,-27.77;652.52,255.19,-12.00;624.99,255.19,4.98;600.00,255.27,27.55;575.35,255.34,49.83;551.35,255.33,71.51;526.39,255.31,94.06;500.10,255.20,116.77;466.53,255.20,118.37;432.98,255.20,119.98;399.43,255.19,121.58;367.87,255.20,131.09;337.78,255.19,144.67;308.30,255.20,160.88;278.83,255.42,177.08;250.39,255.44,192.71;213.78,255.42,213.05;184.68,255.35,228.37;153.68,255.45,242.60;121.01,255.43,250.72;88.38,255.42,258.83;57.04,255.54,266.61;24.43,255.19,274.71;-7.45,255.19,282.63;-39.50,255.19,290.59;-72.80,255.39,296.87;-106.31,255.35,299.02;-139.83,255.35,301.18;-173.41,255.35,303.33;-206.99,255.35,305.49;-218.46,255.35,328.61;-218.91,255.35,370.84;-223.00,255.09,333.29;-213.00,255.09,301.36;-184.01,259.71,292.80;-155.92,257.31,292.52;-125.81,255.09,304.00;-122.39,255.09,336.99;-132.51,255.09,377.27;-119.78,255.10,402.09;-140.46,255.09,428.51;-142.70,255.36,436.48;-119.10,260.51,441.50;-86.75,255.45,444.59;-78.19,255.35,478.23;-79.11,255.35,512.17;-91.76,255.45,541.58;-125.36,255.45,542.60;-159.25,255.45,543.09;-193.15,255.35,536.40;-193.22,255.35,505.39;-210.26,255.36,486.84;-210.80,255.39,482.78;-190.18,255.38,503.91;-185.98,255.44,536.23;-152.76,255.44,539.48;-120.41,255.44,539.38;-89.42,255.44,538.52;-60.76,255.21,521.04;-32.05,255.19,503.54;-3.31,255.19,486.02;25.34,255.19,468.54;55.42,255.36,452.42;88.90,255.43,448.99;109.47,256.38,448.11;102.91,255.44,437.31;93.59,255.45,405.03;84.27,255.46,372.74;75.31,255.75,341.72;65.99,255.58,309.42;56.66,255.40,277.11;55.94,255.26,244.44;60.52,255.51,213.74;61.36,255.54,180.17;76.63,255.43,151.24;98.03,255.70,147.81;95.13,255.25,150.40;124.66,255.61,140.98;157.87,255.61,135.34;190.87,255.62,129.74;221.60,255.59,120.92;259.05,255.61,109.69;288.27,255.36,97.97;314.99,255.36,78.25;342.07,255.36,58.26;369.10,255.51,38.31;394.96,255.60,19.22;424.62,255.60,20.82;430.05,255.33,18.25;409.41,255.19,-8.25;388.80,255.74,-34.72;365.11,255.19,-65.16;344.45,255.19,-91.68;324.60,255.19,-117.18;300.18,255.54,-131.87;283.84,255.54,-150.71;252.95,255.00,-178.72;234.01,254.95,-206.68;218.13,254.96,-236.66;209.97,254.97,-269.23;201.80,254.99,-301.88;193.96,254.92,-333.20;185.79,254.73,-365.84;181.54,254.98,-399.35;186.84,254.74,-432.78;196.74,263.18,-452.70;204.68,263.91,-484.43;179.61,261.57,-523.06;179.23,252.43,-548.45;175.61,263.90,-569.69;144.80,254.97,-570.57;111.95,254.94,-569.96;80.46,261.69,-585.22;58.86,255.43,-586.51;35.59,255.19,-569.01;23.44,255.19,-539.20;10.75,255.19,-508.09;-1.46,255.19,-478.12;-16.04,255.20,-442.40;-28.68,255.19,-411.38;-41.39,255.19,-380.21;-54.10,255.19,-349.04;-65.56,255.44,-319.51;-67.93,255.44,-286.55;-66.41,255.44,-252.90;-64.89,255.44,-219.33;-63.37,255.44,-185.74;-61.85,255.44,-152.15;-60.39,255.44,-119.91;-58.87,255.19,-86.29;-57.42,255.19,-54.25;-55.90,255.19,-20.57;-54.37,255.19,13.17;-52.67,255.19,50.81;-57.40,255.43,83.34;-64.36,255.27,115.97;-71.16,255.34,147.86;-78.10,255.35,180.43;-85.11,255.35,213.33;-93.85,255.68,246.27;-111.28,255.28,274.98;-133.88,255.36,298.54;-167.30,255.35,301.72;-200.70,255.35,304.89;-217.51,255.35,322.58;-220.42,255.35,355.38;-217.75,255.34,386.18;-223.81,255.09,338.54;-218.67,255.09,305.32;-186.04,255.11,293.04;-162.33,259.30,292.14;-130.80,255.09,301.39;-121.08,255.09,331.76;-129.25,255.19,364.30;-130.08,255.11,391.47;-132.18,255.09,417.94;-146.35,256.45,435.67;-147.88,254.77,436.68;-119.22,260.83,433.08;-101.44,255.45,444.12;-80.62,255.35,463.56;-76.52,255.35,497.18;-83.24,255.41,533.46;-112.24,255.45,542.20;-145.87,255.45,543.21;-179.62,255.44,540.93;-193.02,255.35,517.26;-200.16,255.35,486.85;-215.87,256.28,482.55;-191.40,255.35,498.46;-188.80,255.35,532.43;-164.38,255.44,538.52;-131.02,255.44,539.42;-97.47,255.44,539.31;-69.85,255.41,526.59;-41.02,255.19,509.01;-12.39,255.19,491.55;16.13,255.19,474.16;44.87,255.27,456.64;76.96,255.43,450.21;111.08,255.50,450.74;108.72,255.53,457.10;101.32,255.44,431.78;92.34,255.45,400.71;83.01,255.46,368.38;73.69,255.72,336.09;64.39,255.55,303.88;55.51,255.79,270.97;54.64,256.73,238.27;60.61,255.52,206.55;61.82,255.53,172.91;83.72,255.43,147.03;99.18,260.69,157.96;131.69,256.20,141.90;161.63,256.20,129.44;194.47,256.29,119.55;222.32,256.21,130.11;252.83,256.18,116.13;282.79,255.99,102.16;309.89,255.95,82.18;336.01,255.95,62.92;363.03,256.10,43.00;390.03,256.19,23.09;419.34,256.12,19.03;440.80,256.95,32.35;423.23,255.19,9.49;402.49,255.19,-17.15;381.88,255.19,-43.61;361.27,255.19,-70.08;341.33,255.19,-95.70;320.79,255.19,-122.08;295.78,255.62,-133.01;288.31,255.65,-157.01;268.23,255.46,-182.23;245.17,255.46,-203.41;216.45,255.42,-220.27;189.76,255.62,-236.04;189.74,254.63,-235.90;197.87,255.44,-261.04;194.01,255.45,-294.45;190.16,255.45,-327.80;186.31,255.19,-361.24;182.60,255.44,-393.38;185.82,255.20,-427.06;195.74,263.77,-449.69;204.73,264.38,-479.83;205.77,260.31,-499.44;184.53,260.82,-519.96;179.17,255.79,-542.33;175.50,264.36,-568.05;126.06,255.44,-571.05;80.56,261.66,-585.14;58.90,255.43,-586.53;35.66,255.19,-569.19;22.94,255.19,-537.99;10.30,255.19,-506.98;-2.41,255.51,-475.79;-15.07,255.20,-444.78;-27.78,255.19,-413.60;-39.97,255.19,-383.69;-55.22,255.19,-346.30;-66.18,255.44,-315.03;-67.73,255.44,-282.14;-66.21,255.44,-248.62;-64.75,255.44,-216.29;-63.23,255.44,-182.72;-61.71,255.44,-149.06;-60.19,255.44,-115.50;-58.68,255.19,-81.92;-57.21,255.19,-49.63;-55.71,255.19,-16.38;-54.22,255.19,16.57;-52.72,255.19,49.81;-57.20,255.43,82.42;-64.20,255.27,115.21;-72.34,255.35,153.40;-79.36,255.35,186.34;-86.08,255.35,217.88;-94.72,255.11,247.68;-112.35,254.61,277.25;-138.40,255.36,298.97;-171.82,255.35,302.15;-205.28,255.35,305.32;-218.29,255.35,327.08;-219.98,255.35,359.88;-218.63,255.35,387.45;-224.68,255.09,346.85;-219.89,255.09,313.25;-193.71,255.09,295.36;-167.10,263.10,291.85;-136.87,255.09,298.21;-119.41,255.17,325.12;-127.59,255.19,357.71;-135.59,255.10,387.81;-128.04,255.09,412.65;-146.31,256.28,435.73;-123.77,255.35,433.74;-107.89,264.02,444.19;-82.10,255.45,454.68;-76.59,255.35,487.85;-80.95,255.35,521.66;-101.61,255.45,541.88;-135.18,255.45,542.89;-168.92,255.44,542.07;-193.19,255.35,526.68;-196.76,255.35,495.66;-216.53,256.33,486.55;-226.87,255.34,483.93;-271.61,255.35,465.35;-305.30,255.38,460.66;-328.07,255.19,437.54;-347.68,255.19,410.27;-367.31,255.19,382.98;-386.88,255.19,355.76;-406.54,255.19,328.40;-425.98,255.45,301.37;-445.63,255.19,274.04;-465.25,255.19,246.76;-484.86,255.19,219.50;-501.14,255.28,199.29;-499.85,259.72,191.24;-492.18,258.69,172.69;-466.35,255.43,144.27;-464.28,255.19,112.14;-472.17,255.19,82.19;-489.38,255.19,54.79;-507.26,256.11,27.76;-512.84,257.76,1.69;-521.83,255.19,-29.19;-533.47,255.30,-69.17;-542.88,255.46,-101.48;-559.84,255.46,-127.26;-585.94,255.46,-148.44;-586.68,255.47,-156.10;-559.31,255.46,-149.69;-528.29,255.46,-162.98;-497.57,255.47,-176.15;-467.44,260.57,-180.71;-437.74,255.47,-173.39;-410.44,262.45,-166.50;-381.36,255.19,-165.01;-349.15,255.19,-162.87;-318.86,255.45,-152.66;-302.67,255.46,-180.52;-297.62,255.46,-213.70;-292.57,255.54,-246.98;-263.02,255.46,-261.15;-229.79,255.61,-260.10;-203.62,257.08,-255.42;-199.81,255.47,-254.26;-175.85,255.46,-274.23;-144.98,255.46,-287.35;-112.82,255.59,-299.81;-86.48,264.90,-296.50;-60.62,255.33,-288.00;0.62,252.94,-262.55;985.34,254.28,-326.20;947.31,254.68,-340.40;919.02,254.83,-352.08;885.84,254.68,-354.48;852.38,254.68,-353.81;813.23,254.68,-351.24;779.68,254.93,-349.04;746.09,254.83,-346.84;712.54,254.92,-344.64;686.90,254.86,-329.60;663.74,254.68,-305.18;640.61,254.68,-280.77;617.50,254.87,-256.41;588.23,254.69,-243.69;556.67,257.04,-238.64;525.44,254.68,-207.36;492.19,254.68,-205.52;459.65,254.68,-203.72;426.34,254.68,-202.75;386.51,254.64,-202.16;352.56,254.68,-206.05;335.11,254.68,-185.83;319.62,254.68,-156.03;290.62,255.02,-146.08;271.85,254.91,-126.13;256.23,254.92,-97.34;226.11,254.99,-100.77;194.74,254.86,-97.45;163.02,254.75,-86.34;131.31,254.67,-75.23;100.82,254.67,-64.55;69.12,254.67,-53.44;37.32,254.67,-42.30;5.64,254.67,-31.20;-30.90,254.68,-18.39;-62.62,254.68,-7.28;-90.17,254.68,10.59;-105.50,262.07,31.12;-122.58,254.68,54.53;-144.74,254.31,80.09;-124.99,255.01,45.22;-96.03,255.02,55.93;-73.75,257.87,77.93;-74.31,255.21,106.28;-68.12,255.12,112.50;-60.75,255.25,85.97;-68.74,255.27,53.31;-41.49,255.02,32.68;-12.81,255.02,15.29;15.97,255.02,-2.16;43.61,255.02,-18.92;72.28,255.02,-36.30;101.07,255.02,-53.76;129.84,255.02,-71.21;158.58,255.11,-88.63;183.48,255.25,-110.31;207.95,255.25,-133.47;232.34,255.28,-156.55;256.75,255.29,-179.66;281.20,255.29,-202.80;307.52,255.03,-230.77;327.79,255.02,-256.96;343.92,255.02,-286.40;360.03,255.02,-315.79;377.05,255.27,-345.64;403.76,255.02,-365.99;429.59,255.02,-385.68;445.50,262.70,-403.57;464.14,259.72,-413.55;472.23,264.19,-449.64;470.68,264.19,-483.13;469.15,264.18,-516.30;499.21,264.19,-519.68;516.51,258.58,-514.57;487.95,264.58,-513.27;466.98,257.69,-524.02;451.28,255.41,-553.11;440.86,255.41,-584.94;428.02,261.12,-610.19;421.58,255.40,-630.35;397.37,255.56,-654.77;374.62,255.41,-679.42;348.34,255.41,-707.89;330.50,263.07,-730.69;312.87,255.41,-743.47;282.20,255.41,-753.75;251.48,258.41,-764.06;233.91,254.26,-791.26;217.08,254.26,-820.36;214.06,258.71,-823.64;186.75,254.27,-806.30;151.05,254.27,-787.44;122.43,257.82,-771.87;96.61,255.42,-751.60;70.13,255.42,-730.80;51.02,255.42,-705.38;36.56,255.42,-675.09;22.64,255.42,-645.94;8.15,255.42,-615.61;-6.36,255.42,-585.22;-20.79,255.42,-555.00;-34.72,255.42,-525.83;-49.21,255.42,-495.49;-63.68,255.67,-465.18;-63.41,255.67,-432.97;-66.76,255.51,-399.51;-93.71,255.42,-365.98;-110.50,255.68,-338.97;-120.94,255.71,-307.78;-131.45,255.70,-276.37;-141.83,255.69,-245.33;-152.49,255.70,-213.48;-163.16,255.69,-181.58;-173.82,255.69,-149.73;-186.79,255.69,-118.22;-208.25,255.56,-93.38;-229.84,255.42,-68.38;-251.82,255.42,-42.94;-273.75,255.42,-17.55;-295.72,255.42,7.88;-316.46,255.48,33.16;-326.39,255.60,71.22;-326.40,255.60,104.83;-326.41,255.42,138.44;-326.42,255.42,171.95;-326.43,255.42,205.66;-326.44,255.42,239.25;-326.45,255.42,272.93;-326.45,255.42,306.53;-326.46,255.42,340.13;-326.47,255.42,373.69;-319.39,255.42,405.58;-311.04,254.75,427.82;-287.70,254.95,458.99;-255.70,254.94,462.94;-223.22,254.95,471.51;-225.31,255.56,433.92;-220.41,255.57,389.35;-224.56,255.56,355.78;-221.72,255.56,322.05;-202.81,255.56,297.20;-175.68,264.41,291.43;-147.63,255.56,292.09;-123.95,261.23,288.05;-110.45,262.74,258.31;-93.62,256.21,235.13;-85.30,255.57,203.00;-77.22,255.57,171.83;-68.77,255.50,139.21;-59.12,255.42,101.99;-65.50,255.66,70.79;-68.53,255.56,37.26;-64.54,255.41,3.82;-60.71,255.41,-28.15;-56.73,255.41,-61.50;-52.73,255.41,-94.90;-48.74,255.41,-128.31;-44.75,255.41,-161.67;-40.93,255.41,-193.70;-36.94,255.41,-227.08;-32.94,255.41,-260.50;-28.95,255.41,-293.86;-24.97,255.41,-327.23;-20.98,255.41,-360.58;-16.49,255.41,-398.15;-12.52,255.96,-431.35;-5.45,255.46,-464.44;5.36,255.41,-496.23;16.20,255.41,-528.11;26.58,255.41,-558.65;37.42,255.50,-590.53;56.43,255.41,-617.03;86.63,254.73,-633.77;116.04,255.67,-645.69;138.46,255.41,-666.94;157.33,255.41,-694.77;176.30,255.61,-722.77;195.06,255.41,-750.44;199.99,259.76,-770.92;204.80,244.18,-810.35;200.38,255.18,-823.01;172.39,254.29,-809.77;145.91,254.29,-789.09;122.29,255.90,-768.28;111.08,255.44,-736.66;91.47,255.64,-720.28;66.85,255.43,-714.14;48.70,255.44,-687.64;33.61,255.44,-657.72;18.43,255.44,-627.63;3.29,255.44,-597.63;-11.84,255.43,-567.63;-30.62,255.44,-530.41;-45.14,255.44,-501.62;-60.25,255.61,-471.68;-59.65,255.59,-441.35;-60.80,255.50,-408.93;-81.48,255.44,-382.32;-102.02,255.44,-355.90;-111.08,255.76,-327.37;-125.10,255.72,-295.32;-135.62,255.71,-263.87;-146.07,255.71,-232.66;-156.46,255.71,-201.59;-166.94,255.79,-170.27;-177.58,255.71,-138.48;-193.84,255.71,-110.06;-219.94,255.45,-79.85;-241.93,255.44,-54.39;-263.87,255.44,-28.99;-285.82,255.44,-3.58;-307.76,255.44,21.83;-322.31,255.69,50.71;-326.39,255.62,82.96;-326.40,255.53,115.21;-326.41,255.44,148.81;-326.42,255.44,182.42;-326.43,255.44,216.06;-326.44,255.44,249.62;-326.45,255.44,283.33;-326.46,255.44,316.88;-326.47,255.44,350.51;-324.59,255.44,389.96;-314.05,255.44,421.65;-310.50,254.78,437.49;-290.39,254.24,440.78;-278.24,254.95,460.16;-246.13,254.94,464.12;-217.83,256.10,479.59;-224.56,255.56,442.55;-218.40,264.41,424.66;-219.41,255.57,396.45;-224.09,255.56,363.23;-222.87,255.56,329.12;-210.67,255.56,300.39;-183.40,263.13,291.31;-153.61,256.34,291.42;-125.72,256.63,290.99;-110.71,262.80,266.28;-94.31,262.82,237.77;-87.09,255.57,209.90;-78.65,255.57,177.34;-70.22,255.51,144.79;-60.11,255.43,105.78;-64.36,255.64,74.55;-68.99,255.65,41.14;-65.00,255.41,7.74;-61.18,255.41,-24.28;-57.18,255.41,-57.68;-53.19,255.41,-91.09;-49.21,255.41,-124.42;-45.21,255.41,-157.85;-41.38,255.41,-189.92;-37.39,255.41,-223.24;-33.41,255.41,-256.60;-29.42,255.41,-289.98;-25.42,255.41,-323.43;-21.44,255.41,-356.72;-16.78,255.41,-395.70;-12.79,255.96,-429.07;-6.19,255.77,-462.27;4.20,255.41,-492.82;15.01,255.41,-524.63;25.83,255.41,-556.45;36.67,255.43,-588.32;54.34,255.41,-616.07;81.34,254.41,-630.93;111.91,255.67,-644.14;135.62,255.41,-662.76;154.48,255.41,-690.57;173.38,255.50,-718.46;191.52,255.41,-745.21;199.68,253.02,-768.85;203.68,244.19,-801.27;206.17,244.63,-821.26]=]):gmatch("([%-%d%.]+),([%-%d%.]+),([%-%d%.]+)") do arenaRouteNodes[#arenaRouteNodes+1]={tonumber(x),tonumber(y),tonumber(z)} end
local arenaRouteEdges={}
for a,b in ([=[1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10;10,11;10,616;11,12;12,13;13,14;13,204;13,205;13,815;14,15;14,204;14,205;14,333;14,334;14,453;14,698;14,815;15,16;16,17;16,201;16,450;17,18;17,200;17,449;18,19;18,199;18,448;18,449;19,20;19,198;19,447;19,448;20,21;20,197;20,625;21,22;21,626;22,23;22,627;23,24;23,628;24,25;24,629;25,26;25,630;26,27;26,631;27,28;27,76;27,316;27,632;27,681;27,682;27,798;28,29;28,633;29,30;29,634;30,31;30,635;31,32;31,636;32,33;32,146;32,270;32,397;32,484;32,637;33,34;33,43;33,44;33,147;33,157;33,271;33,281;33,397;33,398;33,406;33,407;33,484;33,494;33,495;33,638;33,646;33,647;33,752;33,762;33,871;33,881;33,1089;33,1090;33,1183;33,1184;34,35;34,43;34,148;34,156;34,272;34,279;34,280;34,398;34,399;34,485;34,639;34,645;34,646;34,753;34,760;34,761;34,872;34,1183;35,36;35,41;35,149;35,154;35,155;35,273;35,278;35,279;35,399;35,400;35,404;35,486;35,487;35,492;35,640;35,644;35,754;35,759;35,760;35,873;35,878;35,879;35,1087;35,1181;36,37;36,40;36,150;36,153;36,154;36,274;36,277;36,401;36,403;36,487;36,488;36,491;36,641;36,643;36,755;36,758;36,874;36,877;36,878;36,1086;36,1180;37,38;37,39;37,151;37,153;37,275;37,402;37,488;37,489;37,490;37,642;37,756;37,875;37,877;37,1085;37,1179;38,39;38,151;38,152;38,275;38,276;38,402;38,489;38,642;38,757;38,876;38,1084;38,1178;39,40;39,151;39,153;39,275;39,402;39,488;39,489;39,490;39,642;39,756;39,875;39,877;39,1085;39,1179;40,41;40,150;40,153;40,154;40,274;40,277;40,401;40,403;40,487;40,488;40,491;40,641;40,643;40,755;40,758;40,874;40,877;40,878;40,1086;40,1180;41,42;41,149;41,154;41,155;41,273;41,278;41,400;41,404;41,486;41,487;41,492;41,640;41,644;41,754;41,759;41,873;41,878;41,879;41,1087;41,1181;42,43;42,156;42,405;42,493;42,645;42,761;42,880;42,1088;42,1182;43,44;43,147;43,156;43,157;43,271;43,280;43,398;43,406;43,485;43,494;43,638;43,646;43,752;43,753;43,761;43,871;43,872;43,881;43,1089;43,1183;44,45;44,146;44,157;44,158;44,281;44,397;44,407;44,484;44,637;44,638;44,647;44,752;44,762;44,871;44,881;44,882;44,1090;44,1184;45,46;45,158;45,159;45,282;45,408;45,648;45,763;45,882;45,883;46,47;46,159;46,160;46,283;46,284;46,409;46,649;46,764;46,765;46,883;46,884;47,48;47,160;47,161;47,284;47,409;47,410;47,650;47,765;47,884;47,885;48,49;48,161;48,162;48,163;48,164;48,285;48,286;48,287;48,288;48,411;48,412;48,651;48,652;48,766;48,767;48,768;48,769;48,885;48,886;48,887;49,50;49,161;49,162;49,163;49,164;49,285;49,286;49,287;49,288;49,411;49,412;49,413;49,651;49,652;49,653;49,766;49,767;49,768;49,769;49,886;49,887;50,51;50,165;50,289;50,414;50,654;50,770;50,771;50,889;51,52;51,165;51,166;51,290;51,415;51,655;51,771;51,889;51,890;52,53;52,166;52,167;52,291;52,304;52,416;52,656;52,669;52,772;52,785;52,890;52,891;53,54;53,64;53,167;53,168;53,178;53,292;53,303;53,417;53,428;53,657;53,668;53,773;53,784;53,891;53,892;54,55;54,63;54,169;54,176;54,177;54,293;54,294;54,302;54,418;54,427;54,658;54,667;54,774;54,775;54,783;54,893;55,56;55,62;55,169;55,170;55,175;55,176;55,294;55,295;55,301;55,419;55,426;55,659;55,666;55,775;55,776;55,782;55,894;56,57;56,61;56,170;56,171;56,174;56,175;56,295;56,296;56,300;56,420;56,425;56,660;56,665;56,776;56,777;56,781;56,895;57,58;57,60;57,171;57,172;57,173;57,174;57,296;57,297;57,299;57,421;57,422;57,424;57,661;57,664;57,777;57,778;57,780;57,896;58,59;58,172;58,173;58,297;58,298;58,422;58,423;58,662;58,663;58,778;58,779;58,896;58,897;58,898;58,1082;58,1175;59,60;59,172;59,173;59,297;59,298;59,422;59,423;59,662;59,663;59,778;59,779;59,896;59,897;59,898;59,1082;59,1175;60,61;60,171;60,174;60,296;60,299;60,421;60,424;60,661;60,664;60,777;60,780;60,895;60,896;61,62;61,170;61,171;61,174;61,175;61,295;61,296;61,300;61,420;61,425;61,660;61,665;61,776;61,777;61,781;61,894;61,895;62,63;62,169;62,176;62,294;62,301;62,419;62,426;62,659;62,666;62,775;62,782;62,893;62,894;63,64;63,168;63,177;63,293;63,302;63,418;63,427;63,658;63,667;63,774;63,783;63,892;63,893;64,65;64,167;64,168;64,178;64,292;64,303;64,417;64,428;64,657;64,668;64,773;64,784;64,785;64,891;64,892;65,66;65,179;65,304;65,429;65,656;65,669;65,785;65,786;66,67;66,180;66,305;66,430;66,670;66,786;66,787;67,68;67,181;67,306;67,431;67,671;67,787;67,788;68,69;68,182;68,307;68,432;68,672;68,788;68,789;69,70;69,183;69,308;69,433;69,673;69,789;69,790;70,71;70,184;70,185;70,309;70,311;70,434;70,674;70,675;70,676;70,790;70,792;70,793;71,72;71,184;71,185;71,186;71,309;71,310;71,311;71,434;71,435;71,436;71,674;71,675;71,676;71,791;71,792;71,793;72,73;72,186;72,187;72,312;72,677;72,794;73,74;73,313;73,678;73,795;74,75;74,314;74,679;74,796;75,76;75,315;75,680;75,797;76,77;76,316;76,632;76,681;76,798;77,78;77,317;77,682;77,799;78,79;78,318;78,683;78,800;79,80;79,319;79,684;79,801;80,81;80,320;80,321;80,322;80,685;80,686;80,687;80,802;80,803;81,82;81,320;81,321;81,686;81,687;81,802;81,803;82,83;83,84;84,85;85,86;85,476;85,477;86,87;86,994;86,995;87,88;87,981;88,89;88,136;88,260;88,387;88,742;88,861;88,981;88,1100;88,1194;89,90;89,135;89,136;89,259;89,260;89,386;89,741;89,859;89,860;89,1101;89,1195;90,91;90,134;90,135;90,258;90,259;90,385;90,740;90,858;90,859;90,1102;90,1196;91,92;91,133;91,134;91,257;91,258;91,384;91,739;91,858;91,1103;91,1197;92,93;92,132;92,133;92,256;92,257;92,383;92,738;92,857;93,94;93,131;93,255;93,256;93,382;93,737;93,855;93,856;94,95;95,96;95,1149;96,97;96,1057;96,1149;97,98;97,546;97,547;97,939;97,940;97,941;98,99;98,546;98,547;98,939;98,940;98,941;99,100;99,548;99,941;99,942;100,101;100,942;100,943;100,1055;100,1056;100,1147;101,102;101,943;101,944;102,103;102,944;103,104;103,105;103,945;103,1108;103,1202;104,105;104,946;104,1107;104,1201;104,1202;105,106;105,1108;105,1202;106,107;106,1109;106,1203;107,108;107,1110;107,1204;108,109;108,376;108,1111;108,1205;109,110;109,124;109,125;109,248;109,249;109,375;109,729;109,730;109,849;109,1112;109,1206;110,111;110,123;110,124;110,247;110,248;110,374;110,375;110,555;110,729;110,848;110,1113;110,1207;111,112;111,122;111,123;111,246;111,247;111,373;111,374;111,556;111,557;111,728;111,847;111,1114;111,1208;112,113;112,121;112,122;112,245;112,246;112,372;112,373;112,557;112,558;112,727;112,846;112,1114;112,1115;112,1209;113,114;113,120;113,121;113,244;113,245;113,371;113,372;113,558;113,559;113,726;113,845;113,1115;113,1116;113,1210;114,115;114,119;114,243;114,244;114,370;114,559;114,560;114,724;114,725;114,843;114,844;114,1117;114,1211;115,116;115,118;115,242;115,369;115,561;115,723;115,842;116,117;116,241;116,368;116,562;116,563;116,723;116,842;117,118;117,240;117,241;117,367;117,368;117,562;117,563;117,722;118,119;118,242;118,369;118,561;118,723;118,842;119,120;119,243;119,370;119,560;119,724;119,725;119,843;119,844;119,1117;119,1211;120,121;120,244;120,371;120,559;120,725;120,844;120,1116;120,1210;121,122;121,245;121,372;121,558;121,726;121,845;121,1115;121,1209;122,123;122,246;122,373;122,557;122,727;122,728;122,846;122,1114;122,1208;123,124;123,247;123,374;123,556;123,728;123,847;123,1113;123,1207;124,125;124,248;124,375;124,555;124,729;124,848;124,1112;124,1206;125,126;125,249;125,376;125,554;125,730;125,849;125,1111;125,1205;126,127;126,250;126,377;126,553;126,731;126,850;127,128;127,251;127,378;127,732;127,851;128,129;128,252;128,379;128,733;128,852;129,130;129,253;129,380;129,734;129,735;129,853;129,945;130,131;130,254;130,381;130,735;130,854;131,132;131,255;131,382;131,736;131,855;132,133;132,256;132,383;132,737;132,856;133,134;133,257;133,384;133,738;133,739;133,857;133,1103;133,1197;134,135;134,258;134,385;134,739;134,740;134,858;134,1102;134,1196;134,1197;135,136;135,259;135,386;135,740;135,741;135,859;135,1101;135,1102;135,1195;135,1196;136,137;136,260;136,387;136,741;136,742;136,860;136,1100;136,1101;136,1194;136,1195;137,138;137,261;137,388;137,742;137,861;137,982;137,1099;137,1100;137,1193;137,1194;138,139;138,262;138,389;138,743;138,862;138,994;138,1098;138,1099;138,1193;139,140;139,263;139,390;139,744;139,863;139,993;139,1097;139,1191;140,141;140,264;140,391;140,501;140,745;140,864;140,989;140,992;140,1096;140,1097;140,1190;140,1191;141,142;141,265;141,392;141,500;141,746;141,865;141,990;141,991;141,1095;141,1190;142,143;142,266;142,393;142,499;142,747;142,866;142,1094;142,1095;142,1189;143,144;143,267;143,394;143,481;143,498;143,748;143,867;143,1093;143,1094;143,1188;144,145;144,268;144,395;144,482;144,497;144,749;144,750;144,868;144,869;144,1092;144,1187;145,146;145,269;145,396;145,483;145,750;145,869;146,147;146,157;146,270;146,281;146,397;146,484;146,637;146,647;146,751;146,752;146,762;146,870;146,1090;146,1184;147,148;147,156;147,157;147,271;147,280;147,281;147,398;147,406;147,485;147,494;147,638;147,646;147,752;147,753;147,761;147,762;147,871;147,881;147,1089;147,1183;148,149;148,155;148,156;148,272;148,279;148,399;148,485;148,486;148,492;148,639;148,645;148,753;148,754;148,760;148,761;148,872;148,879;149,150;149,154;149,273;149,278;149,400;149,403;149,404;149,486;149,487;149,491;149,492;149,640;149,644;149,754;149,755;149,759;149,873;149,874;149,878;149,1086;149,1087;149,1181;150,151;150,153;150,274;150,277;150,401;150,403;150,487;150,488;150,491;150,641;150,643;150,755;150,756;150,758;150,874;150,877;150,878;150,1085;150,1086;150,1180;151,152;151,153;151,275;151,276;151,402;151,488;151,489;151,490;151,642;151,756;151,757;151,875;151,876;151,877;151,1084;151,1085;151,1179;152,153;152,275;152,276;152,402;152,489;152,642;152,757;152,876;152,1084;152,1178;153,154;153,274;153,275;153,277;153,401;153,402;153,488;153,490;153,642;153,643;153,756;153,758;153,875;153,877;153,1085;153,1179;153,1180;154,155;154,273;154,278;154,400;154,403;154,404;154,487;154,491;154,640;154,641;154,644;154,754;154,755;154,759;154,873;154,874;154,878;154,1086;154,1087;154,1180;154,1181;155,156;155,272;155,279;155,399;155,404;155,486;155,492;155,639;155,640;155,645;155,754;155,760;155,872;155,873;155,879;155,1087;155,1181;156,157;156,271;156,272;156,279;156,280;156,398;156,405;156,406;156,485;156,493;156,494;156,639;156,645;156,646;156,753;156,760;156,761;156,872;156,880;156,1088;156,1089;156,1182;156,1183;157,158;157,270;157,271;157,281;157,397;157,398;157,406;157,407;157,484;157,494;157,638;157,647;157,752;157,762;157,871;157,881;157,1089;157,1090;157,1183;157,1184;158,159;158,282;158,407;158,408;158,648;158,763;158,882;159,160;159,283;159,408;159,409;159,649;159,764;159,883;160,161;160,284;160,409;160,410;160,649;160,650;160,765;160,884;161,162;161,164;161,285;161,288;161,410;161,411;161,650;161,651;161,766;161,769;161,885;161,887;162,163;162,285;162,286;162,287;162,411;162,412;162,651;162,652;162,767;162,768;162,886;163,164;163,286;163,287;163,411;163,412;163,651;163,652;163,767;163,768;163,886;164,165;164,285;164,288;164,411;164,413;164,651;164,652;164,653;164,766;164,769;164,885;164,887;165,166;165,289;165,290;165,414;165,415;165,654;165,655;165,771;165,889;166,167;166,291;166,415;166,416;166,655;166,772;166,890;167,168;167,178;167,292;167,303;167,304;167,416;167,417;167,428;167,656;167,657;167,668;167,669;167,773;167,785;167,891;168,169;168,177;168,293;168,302;168,303;168,417;168,418;168,427;168,657;168,667;168,668;168,773;168,774;168,784;168,892;169,170;169,176;169,294;169,301;169,302;169,418;169,419;169,426;169,658;169,659;169,666;169,775;169,782;169,783;169,893;170,171;170,175;170,295;170,300;170,301;170,420;170,425;170,659;170,660;170,665;170,776;170,781;170,782;170,894;170,895;171,172;171,174;171,296;171,299;171,300;171,421;171,424;171,425;171,660;171,661;171,664;171,665;171,777;171,780;171,781;171,895;172,173;172,297;172,298;172,299;172,421;172,422;172,423;172,661;172,662;172,663;172,664;172,778;172,779;172,780;172,896;172,897;172,1175;173,174;173,297;173,298;173,299;173,422;173,423;173,662;173,663;173,778;173,779;173,780;173,896;173,897;173,1175;174,175;174,296;174,299;174,300;174,421;174,424;174,425;174,660;174,661;174,664;174,665;174,777;174,780;174,781;174,895;175,176;175,295;175,300;175,301;175,420;175,425;175,659;175,660;175,665;175,776;175,781;175,782;175,894;175,895;176,177;176,294;176,301;176,419;176,426;176,658;176,659;176,666;176,775;176,782;176,783;176,893;177,178;177,293;177,302;177,418;177,427;177,657;177,658;177,667;177,774;177,783;177,784;177,892;178,179;178,292;178,303;178,417;178,428;178,657;178,668;178,773;178,784;178,785;178,891;178,892;179,180;179,304;179,429;179,669;179,785;179,786;180,181;180,305;180,430;180,670;180,786;180,787;181,182;181,306;181,431;181,671;181,787;181,788;182,183;182,307;182,432;182,672;182,788;182,789;183,184;183,308;183,433;183,673;183,789;183,790;184,185;184,309;184,310;184,311;184,434;184,435;184,674;184,675;184,676;184,790;184,791;184,792;184,793;185,186;185,309;185,310;185,311;185,434;185,435;185,674;185,675;185,676;185,791;185,792;185,793;186,187;186,312;186,436;186,676;186,677;186,793;186,794;187,188;187,312;187,437;187,677;187,794;188,189;188,437;188,438;189,190;189,438;189,439;190,191;190,439;191,192;191,441;192,193;192,441;192,442;193,194;193,442;193,443;194,195;194,443;194,444;195,196;195,444;195,445;196,197;196,445;196,446;196,625;197,198;197,446;197,447;197,625;198,199;198,447;198,448;199,200;199,448;199,449;200,201;200,449;200,450;200,811;201,202;201,331;201,450;201,451;201,696;201,812;202,203;202,331;202,332;202,451;202,452;202,696;202,697;202,813;203,204;203,206;203,332;203,333;203,334;203,335;203,452;203,453;203,454;203,697;203,698;203,699;203,814;203,816;204,205;204,206;204,333;204,334;204,453;204,454;204,698;204,699;204,815;205,206;205,333;205,334;205,453;205,454;205,699;205,815;206,207;206,333;206,334;206,453;206,454;206,698;206,699;206,814;206,815;206,816;207,208;207,335;207,455;207,700;207,817;208,209;208,336;208,456;208,701;208,818;209,210;209,337;209,457;209,702;209,818;209,819;210,211;210,338;210,458;210,703;210,820;211,212;211,339;211,340;211,459;211,704;211,821;212,213;212,340;212,341;212,460;212,705;212,822;212,970;213,214;213,341;213,461;213,706;213,823;213,970;214,215;214,342;214,462;214,707;214,824;214,1005;215,216;215,343;215,463;215,580;215,707;215,708;215,825;215,1005;216,217;216,344;216,464;216,579;216,708;216,709;216,826;217,218;217,345;217,465;217,466;217,577;217,578;217,827;217,828;218,219;218,345;218,465;218,466;218,577;218,578;218,827;218,828;219,220;219,346;219,576;219,577;219,578;219,710;219,829;220,221;220,347;220,575;220,711;220,830;221,222;221,348;221,574;222,223;222,349;223,224;223,350;224,225;224,351;225,226;225,352;225,353;226,227;226,353;227,228;227,354;227,355;228,229;228,355;228,356;229,230;229,356;229,357;230,231;230,357;230,358;231,232;231,236;231,358;231,363;232,233;232,235;232,236;232,359;232,362;232,363;233,234;233,235;233,360;233,361;233,362;234,235;234,361;235,236;235,360;235,362;236,237;236,359;236,363;237,238;237,364;238,239;238,365;238,566;238,567;238,720;238,840;239,240;239,366;239,564;239,565;239,721;239,841;240,241;240,367;240,368;240,562;240,563;240,564;240,722;240,841;241,242;241,367;241,368;241,562;241,563;241,722;241,723;241,842;242,243;242,369;242,561;242,723;242,842;243,244;243,370;243,560;243,724;243,843;243,1117;243,1211;244,245;244,370;244,371;244,559;244,725;244,844;244,1116;244,1210;245,246;245,372;245,558;245,726;245,845;245,1115;245,1209;246,247;246,373;246,557;246,727;246,846;246,1114;246,1208;247,248;247,374;247,556;247,728;247,847;247,1113;247,1207;248,249;248,375;248,555;248,729;248,848;248,1112;248,1206;249,250;249,376;249,554;249,730;249,849;249,1111;249,1205;250,251;250,376;250,377;250,553;250,731;250,850;251,252;251,378;251,732;251,851;252,253;252,379;252,733;252,852;253,254;253,380;253,734;253,853;253,945;254,255;254,381;254,735;254,854;255,256;255,382;255,736;255,855;256,257;256,383;256,737;256,856;257,258;257,384;257,738;257,857;257,1103;257,1198;258,259;258,385;258,739;258,858;258,1102;258,1103;258,1196;258,1197;259,260;259,386;259,740;259,859;259,1101;259,1102;259,1195;259,1196;260,261;260,387;260,741;260,860;260,1100;260,1101;260,1194;260,1195;261,262;261,388;261,742;261,861;261,982;261,1099;261,1100;261,1193;261,1194;262,263;262,389;262,743;262,862;262,994;262,1098;262,1099;262,1193;263,264;263,390;263,744;263,863;263,993;263,1097;263,1191;264,265;264,391;264,501;264,745;264,864;264,989;264,992;264,1096;264,1097;264,1190;264,1191;265,266;265,392;265,500;265,746;265,865;265,990;265,991;265,1095;265,1096;265,1190;266,267;266,393;266,480;266,499;266,747;266,748;266,866;266,1094;266,1188;266,1189;267,268;267,394;267,481;267,498;267,748;267,749;267,867;267,1093;267,1187;267,1188;268,269;268,395;268,482;268,497;268,749;268,750;268,868;268,1092;268,1187;269,270;269,396;269,483;269,750;269,869;270,271;270,281;270,397;270,484;270,495;270,637;270,647;270,751;270,752;270,762;270,870;270,1090;270,1184;270,1185;271,272;271,280;271,281;271,398;271,406;271,485;271,494;271,638;271,646;271,647;271,752;271,753;271,761;271,762;271,871;271,881;271,1089;271,1183;272,273;272,279;272,280;272,399;272,485;272,486;272,492;272,639;272,645;272,753;272,754;272,760;272,761;272,872;272,879;273,274;273,278;273,400;273,403;273,404;273,486;273,487;273,492;273,640;273,644;273,754;273,755;273,759;273,873;273,874;273,878;273,879;273,1086;273,1087;273,1181;274,275;274,277;274,401;274,403;274,487;274,488;274,491;274,641;274,643;274,755;274,756;274,758;274,874;274,877;274,878;274,1085;274,1086;274,1180;275,276;275,402;275,488;275,489;275,490;275,642;275,756;275,757;275,875;275,876;275,877;275,1084;275,1085;275,1179;276,277;276,402;276,489;276,642;276,757;276,876;276,1084;276,1178;277,278;277,401;277,403;277,488;277,491;277,641;277,643;277,755;277,756;277,758;277,874;277,875;277,877;277,1085;277,1086;277,1180;278,279;278,400;278,403;278,404;278,487;278,492;278,640;278,644;278,754;278,755;278,759;278,873;278,878;278,1086;278,1087;278,1181;279,280;279,399;279,404;279,486;279,492;279,639;279,645;279,753;279,754;279,760;279,872;279,879;279,1087;280,281;280,398;280,405;280,406;280,485;280,493;280,494;280,639;280,646;280,753;280,761;280,872;280,880;280,1088;280,1089;280,1183;281,282;281,397;281,398;281,407;281,484;281,494;281,638;281,647;281,752;281,762;281,871;281,881;281,1089;281,1090;281,1184;282,283;282,407;282,408;282,648;282,763;282,882;283,284;283,408;283,409;283,649;283,764;283,883;284,285;284,409;284,410;284,649;284,650;284,765;284,884;284,885;285,286;285,288;285,410;285,411;285,412;285,651;285,652;285,766;285,767;285,769;285,885;285,886;285,887;286,287;286,411;286,412;286,651;286,652;286,767;286,768;286,886;287,288;287,411;287,412;287,651;287,652;287,767;287,768;287,886;288,289;288,411;288,413;288,651;288,652;288,653;288,766;288,769;288,885;288,887;288,888;289,290;289,413;289,414;289,653;289,654;289,770;289,889;290,291;290,415;290,654;290,655;290,771;290,889;291,292;291,416;291,655;291,656;291,772;291,890;292,293;292,303;292,417;292,428;292,656;292,657;292,668;292,773;292,784;292,785;292,891;292,892;293,294;293,302;293,303;293,418;293,427;293,657;293,658;293,667;293,774;293,783;293,784;293,892;294,295;294,301;294,419;294,426;294,658;294,659;294,666;294,775;294,782;294,783;294,893;295,296;295,300;295,301;295,420;295,425;295,659;295,660;295,665;295,776;295,781;295,782;295,894;295,895;296,297;296,299;296,300;296,420;296,421;296,424;296,425;296,660;296,661;296,664;296,665;296,777;296,780;296,781;296,895;297,298;297,299;297,421;297,422;297,423;297,661;297,662;297,663;297,664;297,778;297,779;297,780;297,896;297,897;297,1175;298,299;298,422;298,423;298,662;298,663;298,778;298,779;298,896;298,897;298,898;298,1082;298,1175;299,300;299,421;299,422;299,424;299,661;299,664;299,777;299,778;299,780;299,896;300,301;300,420;300,425;300,660;300,665;300,776;300,777;300,781;300,894;300,895;301,302;301,419;301,426;301,659;301,666;301,775;301,776;301,782;301,894;302,303;302,418;302,427;302,658;302,667;302,774;302,783;302,892;302,893;303,304;303,417;303,428;303,657;303,668;303,773;303,784;303,891;303,892;304,305;304,416;304,429;304,656;304,669;304,785;304,891;305,306;305,430;305,670;305,786;306,307;306,431;306,671;306,787;307,308;307,432;307,672;307,788;308,309;308,432;308,433;308,673;308,789;309,310;309,311;309,433;309,434;309,674;309,676;309,790;310,311;310,434;310,435;310,675;310,676;310,791;310,792;310,793;311,312;311,434;311,435;311,436;311,674;311,675;311,676;311,791;311,792;311,793;312,313;312,677;312,794;313,314;313,678;313,795;314,315;314,679;314,796;315,316;315,680;315,797;316,317;316,632;316,681;316,798;317,318;317,682;317,799;318,319;318,683;318,800;319,320;319,684;319,801;320,321;320,322;320,685;320,686;320,687;320,802;320,803;321,322;321,686;321,687;321,802;321,803;322,323;322,685;322,686;322,687;322,802;322,803;323,324;323,688;323,804;324,325;324,689;324,805;325,326;325,690;325,806;326,327;326,691;326,807;327,328;327,692;327,808;328,329;328,693;328,809;329,330;329,694;329,810;330,331;330,450;330,695;330,811;331,332;331,451;331,696;331,812;332,333;332,452;332,697;332,813;333,334;333,453;333,454;333,698;333,699;333,814;333,815;333,816;334,335;334,453;334,454;334,698;334,699;334,814;334,815;334,816;335,336;335,455;335,700;335,816;335,817;336,337;336,456;336,701;336,817;336,818;337,338;337,457;337,702;337,818;337,819;338,339;338,458;338,703;338,819;338,820;339,340;339,459;339,704;339,820;339,821;340,341;340,460;340,704;340,705;340,821;340,822;341,342;341,461;341,705;341,706;341,822;341,823;341,970;341,971;342,343;342,462;342,823;342,824;342,1005;343,344;343,463;343,707;343,708;343,824;343,825;343,1005;344,345;344,464;344,579;344,708;344,826;345,465;345,466;345,577;345,578;345,709;345,827;345,828;346,347;346,576;346,577;346,578;346,710;346,829;347,348;347,575;347,711;347,830;348,349;348,574;349,350;350,351;351,352;352,353;353,354;354,355;355,356;356,357;357,358;358,359;359,360;359,362;359,363;360,361;360,362;361,362;362,363;363,364;364,365;365,366;365,566;365,567;365,720;365,840;366,367;366,564;366,565;366,721;366,841;367,368;367,562;367,563;367,564;367,722;367,841;368,369;368,562;368,563;368,722;368,842;369,370;369,561;369,723;369,842;370,371;370,560;370,724;370,725;370,843;370,844;370,1117;370,1211;371,372;371,559;371,725;371,726;371,844;371,1116;371,1210;372,373;372,558;372,726;372,727;372,845;372,1115;372,1209;373,374;373,557;373,727;373,728;373,846;373,1114;373,1208;374,375;374,556;374,728;374,847;374,1113;374,1207;375,376;375,555;375,729;375,848;375,1112;375,1206;376,377;376,554;376,730;376,731;376,849;376,850;376,1111;376,1205;377,378;377,553;377,731;377,732;377,850;378,379;378,732;378,733;378,851;379,380;379,733;379,734;379,852;379,945;380,381;380,734;380,735;380,853;380,945;381,382;381,735;381,736;381,854;381,855;382,383;382,736;382,737;382,855;382,856;383,384;383,737;383,738;383,856;383,857;383,1104;383,1198;384,385;384,738;384,739;384,857;384,858;384,1103;384,1197;385,386;385,739;385,740;385,858;385,859;385,1102;385,1196;386,387;386,740;386,741;386,859;386,860;386,1101;386,1195;386,1196;387,388;387,741;387,742;387,860;387,861;387,1100;387,1194;387,1195;388,389;388,742;388,743;388,861;388,862;388,982;388,1099;388,1193;388,1194;389,390;389,743;389,744;389,862;389,863;389,994;389,1098;389,1192;390,391;390,744;390,745;390,863;390,864;390,993;390,1097;390,1191;391,392;391,501;391,745;391,746;391,864;391,865;391,990;391,991;391,992;391,1096;391,1190;392,393;392,500;392,746;392,747;392,865;392,866;392,991;392,1095;392,1189;393,394;393,480;393,499;393,747;393,748;393,866;393,867;393,1094;393,1188;393,1189;394,395;394,481;394,498;394,748;394,749;394,867;394,868;394,1093;394,1187;394,1188;395,396;395,482;395,497;395,749;395,750;395,868;395,869;395,1092;395,1187;396,397;396,483;396,750;396,751;396,869;396,870;397,398;397,484;397,637;397,647;397,751;397,752;397,762;397,870;397,871;397,881;397,1090;397,1184;398,399;398,406;398,485;398,494;398,638;398,646;398,752;398,753;398,761;398,762;398,871;398,872;398,881;398,1089;398,1183;399,400;399,486;399,492;399,639;399,645;399,753;399,754;399,760;399,872;399,873;399,879;399,1087;400,401;400,403;400,404;400,486;400,487;400,491;400,492;400,640;400,644;400,754;400,755;400,759;400,873;400,874;400,878;400,1086;400,1087;400,1181;401,402;401,403;401,488;401,490;401,491;401,641;401,643;401,755;401,756;401,758;401,874;401,875;401,877;401,1085;401,1086;401,1180;402,403;402,489;402,490;402,642;402,756;402,757;402,875;402,876;402,1084;402,1085;402,1179;403,404;403,487;403,491;403,641;403,643;403,755;403,758;403,759;403,874;403,878;403,1086;403,1180;404,405;404,486;404,487;404,492;404,640;404,644;404,754;404,759;404,760;404,873;404,878;404,879;404,1087;404,1181;405,406;405,493;405,645;405,761;405,880;405,1088;405,1182;406,407;406,485;406,494;406,638;406,646;406,752;406,753;406,761;406,762;406,871;406,881;406,1089;406,1183;407,408;407,484;407,637;407,647;407,752;407,762;407,763;407,881;407,882;407,1184;408,409;408,648;408,763;408,764;408,882;408,883;409,410;409,649;409,764;409,765;409,883;409,884;410,411;410,650;410,765;410,766;410,884;410,885;411,412;411,651;411,652;411,766;411,767;411,768;411,885;411,886;411,887;412,413;412,651;412,652;412,767;412,768;412,886;412,887;413,414;413,653;413,769;413,770;413,887;413,888;414,415;414,654;414,770;414,889;415,416;415,655;415,771;415,889;415,890;416,417;416,656;416,669;416,772;416,785;416,890;416,891;417,418;417,428;417,657;417,668;417,773;417,784;417,891;417,892;418,419;418,427;418,658;418,667;418,774;418,783;418,892;418,893;419,420;419,426;419,659;419,666;419,775;419,782;419,893;419,894;420,421;420,425;420,660;420,665;420,776;420,781;420,894;420,895;421,422;421,424;421,661;421,664;421,777;421,780;421,895;421,896;422,423;422,662;422,663;422,778;422,779;422,780;422,896;422,897;422,898;422,1175;423,424;423,662;423,663;423,778;423,779;423,896;423,897;423,898;423,1082;423,1175;424,425;424,661;424,664;424,777;424,780;424,895;424,896;425,426;425,660;425,665;425,776;425,777;425,781;425,894;425,895;426,427;426,659;426,666;426,775;426,782;426,893;426,894;427,428;427,658;427,667;427,774;427,783;427,784;427,892;427,893;428,429;428,656;428,657;428,668;428,773;428,784;428,785;428,891;428,892;429,430;429,669;429,785;429,786;430,431;430,670;430,786;430,787;431,432;431,671;431,787;431,788;432,433;432,672;432,788;432,789;433,434;433,673;433,789;433,790;434,435;434,674;434,675;434,676;434,790;434,791;434,792;434,793;435,436;435,675;435,676;435,791;435,792;436,437;436,676;436,793;437,438;438,439;439,440;440,441;441,442;442,443;443,444;444,445;445,446;446,447;446,625;447,448;447,624;448,449;449,450;450,451;450,695;450,811;451,452;451,696;451,812;451,813;452,453;452,697;452,813;452,814;453,454;453,698;453,699;453,814;453,815;453,816;454,455;454,698;454,699;454,814;454,815;454,816;455,456;455,700;455,817;456,457;456,701;456,818;457,458;457,702;457,819;458,459;458,703;458,820;459,460;459,704;459,821;460,461;460,705;460,821;460,822;460,970;461,462;461,706;461,823;461,970;462,463;462,707;462,824;462,1005;463,464;463,580;463,707;463,708;463,825;463,1005;464,465;464,579;464,708;464,709;464,826;465,466;465,577;465,578;465,827;465,828;466,467;466,577;466,578;466,827;466,828;467,468;468,469;469,470;470,471;470,976;471,472;471,976;471,977;471,999;471,1000;472,473;472,977;472,998;472,999;473,474;473,998;474,475;474,997;475,476;476,477;477,478;478,479;479,480;480,481;480,748;480,1094;480,1188;481,482;481,498;481,749;481,867;481,868;481,1093;481,1187;482,483;482,497;482,749;482,750;482,868;482,869;482,1092;483,484;483,750;483,751;483,869;483,870;484,485;484,637;484,647;484,751;484,752;484,762;484,870;484,871;484,881;484,1090;484,1184;485,486;485,494;485,638;485,639;485,646;485,753;485,761;485,871;485,872;485,1089;485,1183;486,487;486,492;486,639;486,640;486,644;486,645;486,754;486,760;486,872;486,873;486,879;486,1087;486,1181;487,488;487,491;487,640;487,641;487,643;487,644;487,754;487,755;487,759;487,873;487,874;487,878;487,1086;487,1180;487,1181;488,489;488,490;488,491;488,641;488,643;488,756;488,758;488,874;488,875;488,877;488,1085;488,1179;488,1180;489,490;489,642;489,757;489,875;489,876;489,1084;489,1178;489,1179;490,491;490,642;490,756;490,758;490,875;490,877;490,1085;490,1179;491,492;491,641;491,643;491,755;491,758;491,759;491,874;491,877;491,878;491,1086;491,1180;492,493;492,640;492,644;492,645;492,754;492,759;492,760;492,873;492,879;492,1087;492,1181;493,494;493,645;493,646;493,761;493,880;493,1088;493,1182;494,495;494,638;494,646;494,647;494,752;494,761;494,762;494,871;494,881;494,1089;494,1090;494,1183;494,1184;495,496;495,637;495,752;495,871;495,1090;495,1184;496,497;496,750;496,751;496,1091;496,1185;497,498;497,749;497,750;497,868;497,869;497,1092;498,499;498,748;498,749;498,867;498,868;498,1093;498,1187;499,500;499,747;499,748;499,866;499,867;499,1094;499,1188;500,501;500,746;500,747;500,865;500,866;500,991;500,1095;500,1189;501,502;501,745;501,746;501,864;501,865;501,990;501,991;501,992;501,1096;501,1190;502,503;502,988;502,989;502,1097;502,1191;503,504;503,985;503,987;503,988;504,505;504,985;504,987;505,506;505,986;506,507;507,508;508,509;509,510;510,511;510,1068;510,1159;511,512;511,1068;511,1069;511,1160;512,513;513,514;514,515;515,516;515,520;515,913;516,517;516,519;517,518;517,910;517,911;517,912;518,519;518,910;518,911;518,912;519,520;519,912;519,913;520,521;520,913;521,522;521,914;522,523;522,915;523,524;523,916;523,917;524,525;524,917;524,918;525,526;525,918;525,919;526,527;526,919;527,528;527,920;528,529;528,921;529,530;529,532;529,922;529,925;530,531;530,923;530,924;531,532;531,923;531,924;532,533;532,922;532,923;532,924;532,925;533,534;533,926;534,535;534,927;535,536;535,928;536,537;536,929;537,538;537,929;537,930;538,539;538,931;539,540;539,932;540,541;540,933;541,542;541,934;542,543;542,935;543,544;543,936;544,545;544,937;545,546;545,938;546,547;546,939;546,940;547,548;547,939;547,940;548,549;548,941;549,550;549,942;550,551;550,1054;550,1146;551,552;551,1054;551,1145;551,1146;552,553;552,1053;553,554;553,731;553,850;553,1052;554,555;554,730;554,849;555,556;555,729;555,848;555,1112;556,557;556,728;556,847;556,1113;556,1207;557,558;557,727;557,846;557,1114;557,1208;557,1209;558,559;558,726;558,845;558,1115;558,1209;558,1210;559,560;559,725;559,844;559,1116;559,1210;560,561;560,723;560,724;560,842;560,843;561,562;561,723;561,842;562,563;562,722;562,723;562,842;563,564;563,722;563,723;563,842;564,565;564,722;564,841;565,566;565,721;566,567;566,720;566,840;567,568;567,719;567,839;568,569;568,718;568,838;569,570;569,837;570,571;571,572;571,715;571,834;572,573;573,574;573,713;573,832;574,575;574,712;574,831;575,576;575,711;575,830;576,577;576,710;576,829;577,578;577,827;577,828;577,829;578,579;578,827;578,828;578,829;579,580;579,708;579,709;579,826;580,581;581,582;581,1006;582,583;583,584;583,967;584,585;584,966;585,586;585,965;586,587;586,964;587,588;587,963;588,589;588,962;589,590;589,961;590,591;591,592;592,593;593,594;594,595;595,596;596,597;597,598;598,599;598,601;599,600;599,604;599,605;600,603;600,604;601,602;601,605;602,605;603,604;604,605;605,606;606,607;607,608;608,609;609,610;610,611;611,612;612,613;613,614;614,615;615,616;616,617;617,618;618,619;619,620;620,621;621,622;622,623;623,624;624,625;625,626;626,627;627,628;628,629;629,630;630,631;631,632;632,633;632,681;632,798;633,634;634,635;635,636;636,637;637,638;637,647;637,1090;637,1184;638,639;638,646;638,647;638,752;638,762;638,871;638,881;638,1089;638,1090;638,1183;638,1184;639,640;639,645;639,646;639,753;639,760;639,761;639,872;639,879;640,641;640,644;640,754;640,755;640,759;640,873;640,878;640,879;640,1087;640,1181;641,642;641,643;641,755;641,758;641,874;641,877;641,878;641,1086;641,1180;642,643;642,756;642,757;642,875;642,876;642,1084;642,1085;642,1179;643,644;643,755;643,758;643,874;643,877;643,878;643,1086;643,1180;644,645;644,754;644,755;644,759;644,873;644,878;644,879;644,1087;644,1181;645,646;645,753;645,754;645,760;645,761;645,872;645,879;645,880;645,1087;645,1088;645,1182;646,647;646,753;646,761;646,871;646,872;646,880;646,881;646,1089;646,1183;647,648;647,752;647,762;647,871;647,881;647,1090;647,1184;648,649;648,763;648,882;648,883;649,650;649,764;649,765;649,883;649,884;650,651;650,765;650,766;650,884;650,885;651,652;651,766;651,767;651,768;651,769;651,885;651,886;651,887;652,653;652,766;652,767;652,768;652,886;652,887;653,654;653,769;653,770;653,887;653,888;654,655;654,770;654,771;654,889;655,656;655,771;655,772;655,890;656,657;656,669;656,772;656,773;656,785;656,891;657,658;657,668;657,773;657,774;657,784;657,892;658,659;658,667;658,774;658,775;658,783;658,893;659,660;659,666;659,775;659,776;659,782;659,894;660,661;660,665;660,776;660,777;660,781;660,895;661,662;661,664;661,777;661,778;661,780;661,895;661,896;662,663;662,778;662,779;662,896;662,897;662,898;662,1082;662,1175;663,664;663,778;663,779;663,896;663,897;663,898;663,1082;663,1175;664,665;664,777;664,778;664,780;664,896;665,666;665,776;665,777;665,781;665,782;665,894;665,895;666,667;666,775;666,782;666,783;666,893;666,894;667,668;667,774;667,783;667,892;667,893;668,669;668,773;668,784;668,891;668,892;669,670;669,785;669,891;670,671;670,786;671,672;671,787;672,673;672,788;673,674;673,789;673,790;674,675;674,676;674,790;674,792;674,793;675,676;675,791;675,792;675,793;676,677;676,791;676,792;676,793;677,678;677,794;678,679;678,795;679,680;679,796;680,681;680,797;681,682;681,798;682,683;682,799;683,684;683,800;684,685;684,801;685,686;685,687;685,802;686,687;686,802;686,803;687,688;687,802;687,803;688,689;688,804;689,690;689,805;690,691;690,806;691,692;691,807;692,693;692,808;693,694;693,809;694,695;694,810;695,696;695,811;696,697;696,812;697,698;697,813;698,699;698,814;698,815;698,816;699,700;699,814;699,815;699,816;700,701;700,817;701,702;701,818;702,703;702,819;703,704;703,820;704,705;704,821;705,706;705,822;705,970;706,707;706,822;706,823;706,970;707,708;707,824;707,1005;708,709;708,825;709,710;709,826;710,711;710,829;711,712;711,830;712,713;712,831;713,714;713,832;714,715;714,833;715,716;715,834;716,717;716,835;717,718;717,836;717,837;718,719;718,838;718,839;719,720;719,839;720,721;720,840;721,722;721,841;722,841;723,724;723,842;723,843;724,725;724,842;724,843;724,1117;725,726;725,844;725,1116;725,1117;725,1210;725,1211;726,727;726,845;726,1115;726,1116;726,1209;726,1210;727,728;727,846;727,1114;727,1115;727,1208;727,1209;728,729;728,847;728,1113;728,1114;728,1207;728,1208;729,730;729,848;729,1112;729,1206;730,731;730,849;730,1111;730,1205;731,732;731,850;732,733;732,851;733,734;733,852;734,735;734,853;734,945;735,736;735,854;736,737;736,855;737,738;737,856;738,739;738,857;738,1104;738,1198;739,740;739,858;739,1103;739,1197;740,741;740,859;740,1102;740,1196;741,742;741,860;741,1101;741,1195;742,743;742,861;742,982;742,1100;742,1194;743,744;743,862;743,1099;743,1193;744,745;744,863;744,993;744,994;744,1098;744,1192;745,746;745,864;745,989;745,992;745,1096;745,1097;745,1191;746,747;746,865;746,990;746,991;746,1096;746,1190;747,748;747,866;747,1095;747,1189;748,749;748,867;748,1094;748,1188;749,750;749,868;749,1093;749,1187;750,751;750,869;750,1092;751,752;751,870;751,1090;751,1184;752,753;752,762;752,871;752,881;752,1089;752,1090;752,1183;752,1184;753,754;753,760;753,761;753,872;753,1089;753,1183;754,755;754,759;754,760;754,873;754,878;754,879;754,1087;754,1181;755,756;755,758;755,759;755,873;755,874;755,878;755,1086;755,1180;756,757;756,758;756,875;756,877;756,1085;756,1179;757,758;757,876;757,1084;757,1178;758,759;758,874;758,875;758,877;758,1085;758,1086;758,1180;759,760;759,873;759,874;759,878;759,1086;759,1087;759,1181;760,761;760,872;760,879;760,1087;761,762;761,872;761,880;761,1088;761,1089;761,1182;761,1183;762,763;762,871;762,881;762,1089;762,1090;762,1184;763,764;763,882;764,765;764,883;765,766;765,884;765,885;766,767;766,769;766,885;766,887;767,768;767,886;768,769;768,886;769,770;769,887;769,888;770,771;771,772;771,889;772,773;772,890;773,774;773,784;773,785;773,891;773,892;774,775;774,783;774,784;774,892;775,776;775,782;775,783;775,893;776,777;776,781;776,782;776,894;776,895;777,778;777,780;777,781;777,895;777,896;778,779;778,780;778,896;778,897;778,1175;779,780;779,897;779,898;779,1082;779,1175;780,781;780,896;781,782;781,895;782,783;782,894;783,784;783,893;784,785;784,892;785,786;785,891;786,787;787,788;788,789;789,790;790,791;791,792;791,793;792,793;793,794;794,795;795,796;796,797;797,798;798,799;799,800;800,801;801,802;802,803;803,804;804,805;805,806;806,807;807,808;808,809;809,810;810,811;811,812;812,813;813,814;814,816;815,816;816,817;817,818;818,819;819,820;820,821;821,822;822,823;822,970;823,824;823,970;824,825;824,1005;825,826;826,827;827,828;828,829;829,830;830,831;831,832;832,833;833,834;834,835;835,836;836,837;837,838;838,839;839,840;840,841;842,843;843,844;843,1117;844,845;844,1116;844,1117;844,1210;844,1211;845,846;845,1115;845,1116;845,1209;845,1210;846,847;846,1114;846,1115;846,1208;846,1209;847,848;847,1113;847,1114;847,1207;847,1208;848,849;848,1112;848,1113;848,1206;848,1207;849,850;849,1111;849,1205;849,1206;850,851;851,852;852,853;853,854;853,945;854,855;855,856;856,857;857,858;857,1104;857,1198;858,859;858,1102;858,1103;858,1197;859,860;859,1101;859,1102;859,1196;860,861;860,1100;860,1101;860,1195;861,862;861,982;861,1100;861,1194;862,863;862,994;862,1099;862,1193;863,864;863,993;863,994;863,1098;863,1192;864,865;864,989;864,992;864,1096;864,1097;864,1191;865,866;865,990;865,991;865,1096;865,1190;866,867;866,1094;866,1095;866,1189;867,868;867,1093;867,1094;867,1188;868,869;868,1092;868,1093;868,1187;869,870;869,1092;870,871;870,1090;870,1184;871,872;871,881;871,1089;871,1090;871,1183;871,1184;872,873;872,1183;873,874;873,878;873,879;873,1087;873,1181;874,875;874,877;874,878;874,1086;874,1180;875,876;875,877;875,1085;875,1179;876,877;876,1084;876,1178;877,878;877,1085;877,1179;877,1180;878,879;878,1086;878,1180;878,1181;879,880;879,1087;879,1181;880,881;880,1088;880,1182;880,1183;881,882;881,1089;881,1090;881,1183;881,1184;882,883;883,884;884,885;885,886;885,887;887,888;888,889;889,890;890,891;891,892;892,893;893,894;894,895;895,896;896,897;897,898;897,1082;897,1175;898,899;898,1082;898,1175;899,900;899,1080;899,1081;899,1173;900,901;900,1080;901,902;901,1079;901,1170;901,1171;902,903;903,904;904,905;905,906;906,907;907,908;908,909;909,910;910,911;911,912;912,913;913,914;914,915;915,916;916,917;917,918;918,919;919,920;920,921;921,922;922,923;923,924;924,925;925,926;926,927;927,928;928,929;929,930;930,931;931,932;932,933;933,934;934,935;935,936;936,937;937,938;938,939;939,940;940,941;941,942;942,943;942,1056;942,1147;943,944;943,1055;943,1147;944,945;947,948;948,949;949,950;950,951;951,952;952,953;953,954;954,955;955,956;956,957;957,958;958,959;959,960;960,961;961,962;962,963;963,964;964,965;965,966;966,967;967,968;968,969;969,970;970,971;971,972;972,973;973,974;974,975;974,1002;975,976;975,1001;976,977;976,1000;977,978;977,999;978,979;978,998;979,980;980,981;981,982;982,983;982,1099;982,1100;982,1193;982,1194;983,984;984,985;985,986;985,987;986,987;987,988;988,989;989,990;989,992;989,1097;989,1191;990,991;990,1096;990,1190;991,992;991,1096;991,1190;992,993;992,1096;992,1097;992,1190;992,1191;993,994;993,1097;993,1098;993,1191;993,1192;994,995;995,996;996,997;997,998;998,999;999,1000;1000,1001;1001,1002;1002,1003;1003,1004;1004,1005;1005,1006;1006,1007;1007,1008;1008,1009;1009,1010;1010,1011;1011,1012;1012,1013;1013,1014;1014,1015;1015,1016;1016,1017;1017,1018;1018,1019;1018,1021;1018,1022;1019,1020;1019,1021;1020,1021;1021,1022;1022,1023;1023,1024;1024,1025;1025,1026;1026,1027;1027,1028;1028,1029;1029,1030;1030,1031;1031,1032;1032,1033;1033,1034;1034,1035;1035,1036;1035,1127;1036,1037;1036,1127;1037,1038;1037,1127;1037,1128;1038,1039;1038,1129;1039,1040;1039,1130;1040,1041;1040,1131;1041,1042;1041,1133;1042,1043;1042,1133;1042,1134;1043,1044;1043,1134;1043,1135;1044,1045;1044,1135;1044,1136;1045,1046;1045,1136;1045,1137;1046,1047;1046,1137;1046,1138;1047,1048;1047,1138;1048,1049;1048,1139;1049,1050;1049,1140;1050,1051;1050,1141;1051,1052;1051,1142;1052,1053;1052,1143;1053,1054;1053,1144;1053,1145;1054,1055;1054,1145;1054,1146;1055,1056;1055,1146;1055,1147;1056,1057;1056,1147;1056,1148;1057,1058;1057,1148;1057,1149;1058,1059;1058,1149;1058,1150;1059,1060;1059,1150;1059,1151;1060,1061;1060,1151;1060,1152;1061,1062;1061,1153;1062,1063;1062,1154;1063,1064;1063,1154;1063,1155;1064,1065;1064,1155;1064,1156;1065,1066;1065,1156;1065,1157;1066,1067;1066,1157;1066,1158;1067,1068;1067,1158;1067,1159;1068,1069;1068,1159;1068,1160;1069,1070;1069,1160;1069,1161;1070,1071;1070,1162;1071,1072;1071,1163;1072,1073;1072,1164;1073,1074;1073,1165;1074,1075;1074,1166;1075,1076;1075,1167;1076,1077;1076,1168;1077,1078;1077,1169;1078,1169;1078,1170;1079,1080;1079,1170;1079,1171;1080,1081;1080,1172;1080,1173;1081,1082;1081,1174;1082,1083;1082,1175;1083,1084;1083,1176;1084,1085;1084,1178;1085,1086;1085,1179;1086,1087;1086,1180;1087,1088;1087,1181;1088,1089;1088,1182;1089,1090;1089,1183;1089,1184;1090,1091;1090,1184;1091,1092;1091,1185;1092,1093;1092,1186;1093,1094;1093,1187;1094,1095;1094,1188;1095,1096;1095,1189;1096,1097;1096,1190;1097,1098;1097,1191;1098,1099;1098,1192;1099,1100;1099,1193;1100,1101;1100,1194;1101,1102;1101,1195;1102,1103;1102,1196;1103,1104;1103,1197;1104,1105;1104,1198;1105,1106;1105,1199;1106,1107;1106,1200;1107,1108;1107,1201;1108,1109;1108,1202;1109,1110;1109,1203;1110,1111;1110,1204;1111,1112;1111,1205;1112,1113;1112,1206;1113,1114;1113,1207;1114,1115;1114,1208;1115,1116;1115,1209;1116,1117;1116,1210;1117,1118;1117,1211;1118,1119;1118,1212;1119,1120;1119,1213;1120,1121;1120,1214;1121,1122;1121,1215;1122,1123;1122,1216;1123,1124;1123,1217;1124,1125;1124,1218;1124,1219;1125,1126;1125,1219;1126,1220;1126,1221;1127,1128;1128,1129;1129,1130;1130,1131;1131,1132;1132,1133;1133,1134;1134,1135;1135,1136;1136,1137;1137,1138;1138,1139;1139,1140;1140,1141;1141,1142;1142,1143;1143,1144;1144,1145;1145,1146;1146,1147;1147,1148;1148,1149;1149,1150;1150,1151;1151,1152;1152,1153;1153,1154;1154,1155;1155,1156;1156,1157;1157,1158;1158,1159;1159,1160;1160,1161;1161,1162;1162,1163;1163,1164;1164,1165;1165,1166;1166,1167;1167,1168;1168,1169;1169,1170;1170,1171;1171,1172;1172,1173;1173,1174;1174,1175;1175,1176;1176,1177;1177,1178;1178,1179;1179,1180;1180,1181;1181,1182;1182,1183;1183,1184;1184,1185;1185,1186;1186,1187;1187,1188;1188,1189;1189,1190;1190,1191;1191,1192;1192,1193;1193,1194;1194,1195;1195,1196;1196,1197;1197,1198;1198,1199;1199,1200;1200,1201;1201,1202;1202,1203;1203,1204;1204,1205;1205,1206;1206,1207;1207,1208;1208,1209;1209,1210;1210,1211;1211,1212;1212,1213;1213,1214;1214,1215;1215,1216;1216,1217;1217,1218;1218,1219;1219,1220;1220,1221]=]):gmatch("(%d+),(%d+)") do arenaRouteEdges[#arenaRouteEdges+1]={tonumber(a),tonumber(b)} end
local arenaNeighbors={}
for i=1,#arenaRouteNodes do arenaNeighbors[i]={} end
for _,edge in ipairs(arenaRouteEdges) do local a,b=edge[1],edge[2];table.insert(arenaNeighbors[a],b);table.insert(arenaNeighbors[b],a) end
-- User's yellow recording: split at recording gaps; edges are validated for
-- dry ground and the current car's body before each route can use them.
local yellowFirst=#arenaRouteNodes+1
if game.PlaceId==130475254262127 then
 local original=#arenaRouteNodes;local pieces=0;local added=0
 for segment in ([=====[-29.01,254.76,117.20;-21.56,254.76,137.66;-18.46,255.29,155.11;-15.07,254.69,172.37;-13.00,255.29,188.67;-9.36,255.29,206.04;-2.57,254.98,220.99;6.49,254.76,236.18;15.16,254.76,250.15;24.63,254.76,265.20;34.07,254.76,280.21;42.91,254.76,294.13;52.73,254.76,307.28;62.66,254.76,321.88;72.44,254.99,336.82;82.21,255.11,351.69;94.17,254.99,364.66;106.62,255.01,375.29;117.34,255.01,389.45;129.27,255.01,402.51;141.85,255.01,413.05;155.58,255.01,422.03;171.22,255.01,430.22;194.80,259.14,435.20;208.49,254.82,436.15;220.53,254.76,438.37;236.59,254.76,441.12;250.08,254.76,441.23;234.31,254.76,439.31;222.40,254.76,437.26;205.60,254.84,433.27;185.79,259.95,437.21;180.91,255.01,453.55|183.08,255.01,479.12;183.75,254.81,493.97;183.82,260.00,507.39;183.31,254.76,518.40;184.16,258.26,499.95|181.81,254.91,470.86;178.80,255.01,456.26;177.76,255.01,438.67;174.76,255.01,422.55;174.17,255.01,406.13;176.02,255.01,388.48;178.44,255.01,370.86;184.48,255.12,354.13;187.58,255.11,336.86;202.74,254.99,329.95;219.11,254.99,327.87;236.32,254.89,323.76;252.18,254.76,319.48;267.99,254.76,311.86;282.40,254.76,301.45;296.06,254.76,292.33;306.91,254.98,278.47;313.64,254.76,263.52;322.55,254.76,248.23;329.24,254.76,233.15;333.90,254.76,216.03;343.86,255.27,201.71;358.50,261.08,191.64;373.96,262.95,183.10;396.78,254.76,178.86;415.06,254.76,178.56;431.81,254.76,172.77;449.02,254.76,168.56;432.64,254.76,174.83;417.15,254.76,179.85;401.83,254.85,181.68;384.09,258.61,181.10;366.38,259.84,181.65;353.36,256.10,191.12;344.69,255.45,206.51;340.07,254.76,223.73;336.05,254.76,240.94;333.77,254.76,258.57;332.97,254.76,274.96;331.74,254.76,292.67;332.10,254.76,310.37;341.15,254.76,321.65;358.09,254.98,327.06;375.44,254.99,327.56;392.45,254.99,322.86;407.24,254.96,329.71;421.76,254.73,339.81;421.82,254.97,323.31;426.25,258.87,335.72;431.16,260.18,347.43;432.74,254.76,359.62;438.20,254.76,373.24;446.80,254.76,387.05;449.74,254.76,409.79;459.37,254.76,424.67;473.50,258.89,435.82;482.81,259.96,454.99;498.96,259.53,471.88;511.77,262.38,483.30;509.40,261.01,497.03;514.78,254.76,474.41;524.26,258.64,456.71;532.58,259.99,442.70;546.27,257.67,436.27|569.57,259.85,420.02;582.31,259.13,409.51;592.32,254.78,396.29;605.78,255.10,385.09;619.27,254.87,373.58;622.11,254.76,357.87;619.31,254.76,339.80;614.50,254.76,321.08;615.05,254.76,300.37;616.16,254.76,279.60;617.02,254.76,260.37;618.96,254.76,239.66;618.90,254.76,218.92;610.36,254.94,200.27;598.20,254.73,183.34;584.34,257.69,168.09;570.49,260.10,154.77;555.56,258.91,143.01;534.87,254.71,139.86;514.88,254.76,142.41|488.49,259.64,152.18;471.89,259.50,161.81;456.72,254.76,166.83;470.91,259.31,162.52;488.66,261.43,152.60;506.75,259.40,143.86;525.70,254.60,140.94;538.60,254.76,137.71|567.21,261.67,150.71;582.85,262.29,164.64;595.80,259.08,178.80;611.06,254.97,190.94;630.96,254.76,184.90;646.40,254.76,173.55;662.20,254.76,160.47;677.11,254.84,148.28;693.16,255.71,134.85;709.63,259.82,122.49;727.01,259.92,113.99;744.53,255.71,103.51;751.67,254.74,90.87;773.23,256.14,92.54;793.83,261.62,89.80;804.97,262.90,83.79|797.88,261.97,58.54;795.07,262.33,39.46;795.07,260.35,18.68;794.14,255.84,-2.07;791.17,254.79,-22.09;784.75,254.76,-40.35;780.38,254.76,-59.30;780.63,254.76,-79.63;781.74,255.04,-98.74;782.57,254.76,-118.04;787.30,254.76,-138.10;791.99,254.76,-156.75;796.83,254.76,-175.51;799.61,254.76,-189.73;801.55,254.76,-175.50;793.76,254.76,-156.46;787.59,254.76,-138.23;781.09,254.76,-120.01|780.06,254.80,-94.85;784.52,254.72,-74.95;782.75,254.76,-56.34;785.40,254.76,-41.70|812.53,255.27,-33.13;830.82,255.00,-38.81;851.42,254.76,-40.26;872.02,254.76,-39.30;891.38,254.76,-39.18;911.98,254.76,-39.15;931.23,254.76,-38.44;951.91,254.76,-37.30;971.06,254.76,-35.60;990.10,254.76,-32.94;1010.81,254.76,-33.98;1029.98,254.76,-35.70;1050.48,255.28,-32.67;1069.66,255.29,-33.22;1090.38,255.29,-35.61;1111.06,255.29,-37.05;1129.86,255.29,-43.92;1139.32,254.76,-62.57;1153.87,254.76,-77.16;1169.96,254.97,-90.32;1186.33,254.75,-103.13;1200.41,254.76,-116.21;1211.85,254.95,-131.64;1219.35,254.90,-150.90;1225.51,254.90,-169.14;1232.19,254.90,-188.80;1240.66,254.89,-207.74;1246.59,254.87,-226.02;1248.00,254.97,-246.67;1250.38,254.89,-267.41;1254.46,254.90,-288.02;1261.57,254.76,-307.25;1265.83,254.76,-327.51;1267.95,254.76,-346.63;1270.00,254.76,-367.33;1271.82,254.76,-388.06;1273.12,254.76,-407.21;1273.11,254.76,-426.45;1267.83,254.76,-446.57;1262.59,254.76,-466.58;1258.14,254.76,-486.88;1253.37,254.76,-505.48;1246.79,254.90,-523.56;1240.05,254.90,-538.97;1240.68,254.98,-556.52;1244.10,254.98,-573.98;1245.86,254.98,-590.37;1243.09,254.98,-607.78;1239.91,254.98,-623.99;1230.23,254.98,-638.78;1216.82,254.98,-648.20;1199.73,254.98,-653.94;1181.52,254.95,-660.31;1161.43,254.76,-665.40;1140.77,254.76,-664.02;1119.90,254.76,-663.27;1099.24,254.76,-664.47;1078.47,254.76,-665.93;1057.77,254.76,-667.40;1038.51,254.76,-668.54;1019.23,254.76,-667.19;998.97,254.76,-663.67;981.15,254.76,-664.57;964.75,254.76,-666.29;947.06,254.76,-667.95;930.58,254.76,-668.85;912.91,254.76,-668.15;896.60,254.76,-665.85;879.77,254.76,-660.08;869.40,255.10,-646.44;867.03,255.08,-628.14;865.34,255.08,-608.97;865.75,254.92,-588.23;865.01,255.22,-569.01;860.83,254.89,-550.68;846.56,254.74,-538.29;826.35,254.76,-533.88;805.60,254.76,-533.12;786.32,254.76,-532.65;765.67,254.76,-534.65;745.40,254.76,-538.83;729.01,254.76,-539.35;711.27,254.76,-538.34;696.28,254.76,-532.80;686.69,255.14,-517.93;678.53,254.87,-502.27;673.52,254.77,-486.58;668.28,254.76,-469.54;664.85,254.76,-452.05;657.24,254.76,-434.67;648.42,254.76,-417.65;642.65,254.76,-399.67;642.77,254.76,-381.29;642.43,254.76,-363.13;647.42,254.76,-343.02;652.71,254.76,-324.56;653.68,254.76,-303.86|652.96,254.76,-333.31;655.11,254.76,-351.08;667.43,254.76,-362.13;683.83,254.76,-364.05;701.54,254.76,-364.49;719.30,254.76,-364.17;735.74,254.76,-364.45;753.52,254.76,-365.28;769.99,254.76,-366.12;789.95,254.76,-367.16;810.60,254.76,-368.87;829.78,254.76,-367.70;847.44,254.76,-377.25;860.73,254.91,-393.23;867.14,254.75,-411.97;867.85,254.76,-432.69;869.33,254.76,-451.82;866.34,254.76,-472.59;865.68,254.76,-493.21;862.96,254.76,-511.79;870.00,254.93,-526.43;886.35,254.75,-528.14;903.92,254.76,-530.53;920.39,254.76,-531.17;938.17,254.76,-531.39;954.63,254.76,-531.65;972.43,254.76,-531.99;990.17,254.76,-532.37;1010.59,254.76,-532.81;1029.86,254.76,-533.23;1050.59,254.76,-532.72;1071.37,254.76,-531.84;1090.41,255.13,-529.12;1110.77,254.90,-525.18;1131.51,254.90,-523.03;1151.88,254.90,-519.46;1171.05,254.90,-518.10;1189.90,254.90,-521.49;1208.34,254.90,-526.92;1225.86,254.90,-529.83;1238.09,254.90,-537.39;1215.24,254.90,-533.91;1197.86,254.90,-530.47;1181.63,254.90,-527.62;1164.06,254.90,-524.91;1146.35,254.90,-524.07;1129.86,254.90,-524.20;1113.72,254.90,-526.78;1097.74,254.95,-530.52;1079.94,254.74,-529.54;1062.24,254.76,-528.02;1045.95,254.76,-529.35;1028.18,254.76,-530.84;1010.39,254.76,-531.60;993.95,254.76,-532.12;976.17,254.76,-532.27;958.45,254.76,-531.11;940.73,254.76,-529.56;922.95,254.76,-528.58;905.15,254.76,-528.22;888.63,254.76,-528.53;871.08,254.92,-530.82;853.46,254.77,-533.04;835.72,254.76,-534.33;817.86,254.76,-535.10;800.07,254.76,-535.52;782.31,254.76,-535.94;764.59,254.76,-536.36;748.08,254.76,-536.74;731.63,254.76,-537.11;713.85,254.76,-538.23;696.62,254.76,-542.54;683.00,254.95,-553.48;671.88,254.78,-565.66;661.71,254.76,-580.19;653.94,254.76,-594.69;645.71,254.76,-608.86;633.28,254.76,-621.65;621.30,254.76,-634.77;609.35,254.98,-646.08;596.43,254.98,-656.16;578.94,254.98,-657.09;561.29,254.89,-656.77;544.85,254.92,-658.16;527.25,254.75,-660.92;511.02,254.76,-663.52;495.86,254.76,-669.68;478.92,254.76,-675.07;461.32,254.76,-677.36;443.54,254.76,-679.23;427.72,254.76,-683.91;410.38,254.76,-687.06;392.68,254.76,-687.32;376.49,254.76,-684.36;361.68,254.76,-691.51;356.98,254.76,-708.51;352.83,254.93,-724.53;353.26,254.73,-742.17;356.89,254.74,-758.17;359.81,254.74,-775.68;362.71,254.74,-791.88;364.44,254.74,-809.73;365.26,254.74,-827.36;363.61,254.74,-845.01;360.50,254.74,-861.20;361.50,254.74,-878.80;363.43,254.74,-895.13;363.91,254.74,-911.64;365.01,254.74,-928.04;367.25,254.74,-945.57;368.47,254.34,-962.00;370.36,253.75,-979.68;373.71,253.24,-997.08;378.34,253.35,-1012.89;386.66,253.17,-1027.14;395.56,254.46,-1042.31;404.53,254.74,-1057.76;412.18,254.74,-1073.70;418.54,254.74,-1088.86;410.57,254.74,-1073.21;400.37,254.74,-1058.89;390.52,254.74,-1044.26;385.01,253.68,-1028.74;377.34,253.38,-1012.75;374.79,253.19,-995.22;372.39,253.40,-978.86;367.96,254.22,-960.19;364.60,254.74,-939.61;363.72,254.74,-918.93;363.55,254.74,-899.62;363.02,254.74,-878.97;362.31,254.74,-859.79;362.36,254.74,-840.53;360.43,254.74,-819.85;361.20,254.74,-799.16;362.19,254.74,-780.05;356.32,254.74,-761.74;352.61,254.74,-741.42;350.55,254.96,-720.75;346.33,254.76,-701.95;340.61,254.76,-682.02;335.19,254.76,-661.94;332.25,254.76,-641.39;332.09,254.76,-620.54;331.57,254.76,-599.76;328.79,254.76,-579.18;326.55,254.76,-558.50;324.95,254.76,-537.83;323.91,254.76,-518.61;324.39,254.76,-499.37;325.76,254.76,-478.81;326.87,254.76,-459.50;327.09,254.76,-438.78;327.27,254.76,-419.18;327.21,254.76,-398.74;326.84,254.76,-379.54;322.31,254.76,-360.85;320.01,254.76,-340.27;320.61,254.76,-321.05;323.34,254.76,-300.49;326.04,254.76,-281.47;329.99,254.76,-261.15;333.76,254.76,-242.32;337.31,254.76,-223.36;338.96,254.76,-202.65;339.03,254.76,-181.90;339.08,254.76,-162.66;339.13,254.76,-143.41;339.18,254.76,-122.59;339.23,254.76,-101.76;339.52,254.76,-81.09;338.26,254.76,-61.97;333.05,254.76,-41.84;326.54,254.76,-22.20;327.96,254.76,-1.50;330.64,254.76,19.18;333.78,254.76,39.60;330.09,254.76,58.51;325.08,254.76,78.54;320.43,254.76,97.25;310.56,254.76,115.36;296.86,255.08,128.72;280.13,255.01,141.02;265.24,255.01,153.17;250.47,255.01,165.46;235.70,255.01,177.78;219.89,255.01,191.20;205.32,254.76,203.71;190.61,254.76,216.08;176.91,255.01,229.47;167.45,255.01,247.95;160.05,255.00,265.70;153.27,254.99,285.36;144.97,254.76,304.33;136.31,254.76,321.51;127.11,255.10,338.47;117.41,255.14,356.49;108.21,255.01,373.53;98.00,255.01,391.69;87.22,255.01,407.59;74.28,255.01,423.86;60.66,254.99,437.40;47.43,254.99,451.32;37.24,254.74,467.42;31.13,254.76,487.25;26.17,254.76,505.79;23.87,254.76,526.51;25.95,254.76,547.10;33.12,254.79,566.61;47.73,254.97,580.96;65.02,254.99,589.36;83.48,254.76,598.81;103.10,254.76,605.90;122.77,254.76,612.42;141.06,254.76,618.37;156.96,255.19,623.60;174.25,254.76,627.45;190.43,254.76,630.49;207.21,254.76,636.36;222.56,254.76,642.14;239.68,254.76,647.28;256.52,254.85,652.71;271.77,254.97,659.05;289.14,254.99,663.78;308.09,255.29,667.08;328.31,255.09,664.28;341.29,254.87,654.65;324.52,254.76,643.16;305.82,254.76,634.20;285.10,254.76,635.86;264.38,254.76,636.84;243.63,254.76,635.51;224.43,254.76,635.00;203.67,254.76,634.67;185.41,254.76,634.38;168.87,254.76,634.04;152.42,254.76,633.59;134.68,254.76,633.17;118.23,254.76,632.78;100.44,254.76,632.68;83.93,254.76,632.68;66.15,254.76,632.69;48.41,254.79,632.70;29.07,254.79,632.91;8.58,254.79,634.83;-10.69,254.79,636.70;-29.87,254.79,638.57;-50.53,254.79,640.58;-71.22,254.79,642.59;-91.85,254.76,645.11;-112.17,254.76,649.42;-130.46,254.88,655.44;-149.75,254.99,663.01;-165.99,254.27,669.68;-183.18,254.06,673.23;-200.97,254.07,672.60;-218.63,254.14,670.41;-235.83,255.00,666.08;-251.66,254.99,661.53;-267.74,254.99,657.96;-285.04,254.89,654.18;-302.71,254.89,654.21;-321.96,254.99,654.80;-342.61,254.97,655.62;-363.37,254.89,656.82;-382.55,254.98,658.85;-401.31,255.00,654.97|-401.80,254.79,629.66;-389.04,254.80,613.67;-378.41,254.80,595.62;-371.15,254.80,578.03;-370.75,254.76,559.21;-369.52,254.76,541.89;-361.56,254.76,526.14;-351.82,254.73,511.40;-342.55,254.76,497.50;-335.83,254.76,481.19;-326.64,254.76,467.82;-314.00,254.76,457.23;-322.86,254.95,478.48;-335.91,254.75,492.64;-347.16,254.76,508.12;-356.19,254.76,526.81;-368.02,254.76,543.86;-369.93,254.76,562.24;-361.32,254.79,580.81;-345.88,254.80,594.03;-327.85,254.80,600.74;-311.92,254.80,611.40;-291.40,254.76,611.33;-270.52,254.76,610.67;-249.98,254.76,613.01;-229.49,254.76,611.43;-210.14,254.76,611.09;-191.58,254.76,614.93;-173.82,254.83,622.31;-153.42,254.69,625.41;-134.50,254.76,627.50;-118.24,254.76,629.66;-100.73,254.76,632.83;-83.34,254.76,636.12;-65.57,254.79,638.16;-47.93,254.79,639.68;-31.43,254.79,640.21;-13.77,254.79,639.28;3.99,254.79,638.62;23.33,254.79,635.79;43.83,254.79,633.28;63.06,254.76,634.31;83.66,254.76,637.46;104.33,254.76,638.43;124.94,254.76,637.17;144.33,254.76,635.83;165.04,254.76,634.75;185.88,254.76,635.46;206.31,254.76,637.68;224.21,254.76,637.05;241.82,254.76,634.81;258.35,254.76,635.62;275.72,254.76,632.55;292.14,254.76,633.26;308.57,254.76,630.34;315.63,254.76,614.21;320.91,254.76,598.66;322.91,254.76,580.77;324.46,254.76,560.92;325.90,254.76,541.60;326.41,254.76,520.95;326.51,254.76,500.15;326.77,254.76,480.79;327.32,254.76,461.50;327.56,254.76,440.85;326.53,254.76,420.04;322.42,254.76,399.65;324.79,254.76,379.08;326.04,254.76,361.76;328.94,254.76,344.40;334.30,254.76,329.09;350.12,254.76,321.39;341.98,254.76,311.10;333.67,254.76,295.64;327.56,254.76,280.57;328.13,254.76,262.84;326.92,254.76,245.05;326.73,254.76,225.72;327.07,254.76,204.82;327.33,254.76,184.25;327.57,254.76,163.41;327.43,254.76,142.66;326.81,254.76,123.46;326.32,254.76,102.52;327.20,254.76,81.86;329.39,254.76,61.05;330.99,254.76,40.54;333.17,254.76,24.19;325.27,254.76,8.42;314.43,254.76,-5.72;301.70,254.76,-16.43;287.23,254.76,-26.32;271.62,254.76,-34.76;256.90,254.73,-42.16;242.52,254.76,-52.29;228.83,254.76,-62.34;213.33,254.76,-73.63;199.26,254.93,-86.96;189.29,254.99,-104.91;180.89,255.01,-123.92;172.84,255.01,-141.33;159.54,255.01,-157.15;145.82,255.01,-170.61;128.27,255.01,-182.03;108.41,255.01,-187.98;88.27,255.01,-191.85;70.74,255.01,-195.07;53.34,254.99,-198.24;39.26,254.92,-206.68;24.31,254.76,-216.32;10.96,254.76,-225.85;-3.03,254.76,-236.84;-16.71,255.04,-248.43;-31.35,254.76,-258.98;-48.06,254.76,-267.14;-67.34,254.97,-274.95;-85.31,258.59,-281.74;-99.70,260.25,-287.16;-119.06,255.00,-296.44;-138.75,255.01,-301.75;-157.84,255.01,-301.82;-174.13,255.01,-299.97;-190.58,255.01,-306.15;-204.94,255.01,-316.39;-215.70,255.01,-328.84;-225.84,255.00,-341.80;-238.83,254.95,-351.81;-249.24,254.76,-365.90;-257.86,255.39,-380.13;-266.90,259.50,-395.21;-273.50,259.62,-410.24;-276.53,255.65,-427.56;-281.87,255.01,-443.01;-285.26,255.01,-459.08|-292.99,255.01,-484.35;-312.06,255.01,-491.96;-332.67,254.86,-491.36;-349.81,254.76,-479.90;-363.81,254.76,-464.90;-362.10,254.76,-444.64;-357.37,254.76,-424.51;-360.52,254.76,-405.59;-362.30,254.76,-384.79;-364.81,254.76,-364.31;-369.52,254.76,-347.11;-374.39,254.76,-331.49;-374.30,254.76,-315.06;-369.58,254.76,-298.02;-367.17,254.76,-281.80;-369.25,254.76,-264.17;-368.22,254.76,-246.45;-368.02,254.76,-230.01;-369.28,254.76,-212.91;-368.25,254.76,-192.26;-369.30,254.76,-171.70;-374.80,254.76,-153.27;-370.01,254.76,-133.54;-361.41,254.76,-116.52;-362.72,254.78,-96.06;-360.01,254.80,-77.05;-360.31,254.80,-56.30;-363.16,254.80,-37.30;-364.09,254.80,-16.56;-365.18,254.80,-0.03;-367.21,254.80,17.63;-368.38,254.80,35.36;-368.07,254.76,53.07;-367.61,254.76,69.49;-366.60,254.76,86.05;-364.00,254.76,103.42;-360.79,254.76,119.58;-356.86,255.28,137.75;-352.70,254.76,156.68;-348.17,254.76,176.82;-343.50,254.76,195.63;-340.32,254.76,216.16;-340.17,254.76,236.78;-340.44,254.76,257.57;-343.15,254.76,278.27;-345.74,254.76,298.93;-349.78,254.76,319.16;-352.89,254.76,337.53;-354.43,254.76,353.89;-355.23,254.76,370.35;-358.52,255.27,387.85;-360.73,252.09,402.35|-198.81,258.60,59.98;-196.19,254.80,38.38;-187.87,254.97,24.50;-181.50,254.75,8.16;-172.99,254.76,-5.60;-158.61,254.76,-16.17;-144.14,254.76,-26.39;-127.86,254.76,-32.65;-110.21,254.76,-34.87;-93.43,254.79,-35.58;-78.29,254.80,-28.66;-66.21,254.80,-18.83;-72.38,254.80,-3.47;-88.73,254.80,-0.55;-105.37,254.76,-6.75;-119.46,254.76,-17.52;-134.56,254.76,-23.54;-152.22,254.76,-24.12;-166.83,254.76,-16.66;-179.64,254.76,-4.37;-180.58,254.82,17.00;-183.02,254.80,33.22;-190.32,254.80,47.95;-199.15,254.80,58.66;-182.34,254.80,66.77;-164.95,254.91,75.18;-144.12,260.29,86.23;-152.07,254.91,99.21;-134.82,254.97,97.18;-122.37,254.76,96.20;-107.64,254.76,96.75;-95.59,255.22,99.03;-82.02,254.89,110.36;-74.77,254.90,124.56;-71.21,254.88,136.78;-72.21,254.90,149.53;-73.01,254.90,170.06;-60.49,254.88,186.56;-47.55,254.76,202.38;-34.59,254.76,216.83;-20.49,254.76,231.86;-6.67,254.76,245.47;9.38,254.76,258.54;24.84,254.76,270.14;43.04,254.83,279.99;61.45,254.75,289.58;78.67,254.76,298.03;97.67,254.76,300.74;118.43,254.76,301.25;137.67,254.76,301.49;158.36,254.76,301.86;178.99,254.76,302.75;198.38,254.76,303.62;219.00,254.76,304.44;239.91,254.76,304.80;260.57,254.76,305.12;281.53,254.76,305.46;302.14,254.76,305.79;321.40,254.76,307.47;340.59,254.76,306.93;361.06,254.76,309.31;380.31,254.76,310.56;400.57,254.76,306.08;420.62,254.76,300.61;441.39,254.76,299.38;459.43,254.76,291.37;470.34,254.98,273.66;471.95,254.75,255.60;472.89,254.76,242.89;490.06,260.09,226.17;493.37,260.12,205.43;495.02,258.51,184.74;493.27,254.72,173.43;495.81,254.76,160.83;498.22,254.76,148.23;502.33,259.71,125.31|522.33,260.02,105.33;531.65,258.31,90.19;544.54,254.90,87.09;561.46,254.90,77.99;581.63,254.90,73.57;600.49,254.90,69.60;618.73,254.96,59.60;628.69,254.80,43.42;632.53,254.80,23.07;643.33,254.80,5.64;656.70,254.80,-6.67;673.47,254.80,-18.32|673.86,254.80,-45.62;670.95,254.80,-64.62;668.92,254.80,-83.82;664.88,254.80,-102.55;656.96,254.80,-121.74;648.22,254.76,-138.71;639.99,254.76,-157.43;638.51,254.76,-175.86;639.98,254.76,-194.91;639.40,254.76,-215.65;640.57,254.76,-234.84;643.52,254.76,-255.38;644.98,254.76,-274.73;643.97,254.76,-292.95;642.20,254.76,-309.37;643.21,254.76,-326.45;648.01,254.76,-341.80;659.16,254.76,-351.93;676.46,254.76,-355.44;657.63,254.76,-363.08;636.87,254.76,-364.64;616.25,254.76,-367.18;597.26,254.76,-370.05;578.22,254.76,-372.50;559.46,254.76,-369.70;540.73,254.76,-366.72;520.08,254.76,-369.27;500.96,254.76,-370.62;481.81,254.76,-371.74;463.83,254.76,-374.47;446.01,254.76,-373.43;429.21,254.76,-378.57;411.34,254.76,-379.07;393.66,254.76,-379.03;377.24,254.76,-378.91;359.65,254.76,-380.42;344.15,254.76,-385.99;337.93,254.76,-400.00;333.06,254.76,-418.69;320.39,254.76,-409.16;305.68,254.90,-396.76;290.40,254.75,-383.03;271.75,254.76,-379.48;250.94,254.76,-379.37;231.72,254.76,-378.94;211.00,254.76,-379.81;191.77,254.76,-379.95;171.23,254.76,-376.87;151.67,254.76,-374.27;133.97,254.76,-373.53;117.48,254.77,-372.91;99.88,254.76,-371.15;83.73,254.76,-368.79;66.00,254.76,-369.39;50.87,254.76,-363.31;38.61,254.76,-350.56;27.88,254.76,-338.12;15.87,254.76,-324.68;4.08,254.76,-307.41;-14.60,255.17,-299.51;-34.22,254.76,-301.71;-48.45,254.76,-314.52;-58.76,254.76,-330.72;-71.87,254.99,-344.93;-88.62,254.76,-356.94;-104.34,254.76,-370.26;-118.87,254.76,-386.99;-125.66,255.11,-403.78;-125.93,254.88,-388.97;-125.39,258.57,-401.72;-124.87,261.43,-420.93;-122.71,260.63,-440.17;-118.88,255.68,-460.59;-115.71,255.01,-480.85;-113.01,255.01,-498.40;-111.96,255.01,-514.92;-116.72,255.05,-531.84;-114.92,255.05,-548.08;-112.48,255.01,-565.68;-116.06,255.04,-581.71;-125.69,255.01,-596.42;-141.69,255.01,-603.69;-159.22,255.01,-605.92;-175.39,255.01,-608.73;-191.49,255.01,-605.63;-208.74,255.01,-601.52;-225.03,255.01,-594.42;-237.37,255.05,-584.03;-245.94,255.05,-568.54;-256.18,255.00,-554.06;-265.06,255.01,-538.68;-269.93,255.01,-521.65;-272.79,255.01,-505.45;-276.98,255.01,-488.28;-281.38,255.01,-472.40;-284.55,255.01,-454.93;-290.28,255.01,-439.72;-300.23,255.05,-426.72;-316.16,255.34,-419.07;-330.95,254.78,-409.25;-345.02,254.76,-400.55;-361.48,254.76,-394.26;-378.75,254.76,-390.80;-395.11,254.76,-388.45;-412.22,254.76,-384.13;-427.22,254.83,-389.73;-435.63,255.06,-403.86;-441.99,254.76,-420.41;-444.36,254.76,-436.70;-440.34,254.76,-422.86;-439.01,254.76,-405.47;-448.96,254.92,-391.08;-465.46,254.74,-384.86;-481.00,254.76,-379.52;-497.26,254.76,-377.57;-513.61,254.76,-375.91;-530.04,254.76,-375.14;-546.39,254.76,-376.82;-563.94,254.76,-376.31;-579.98,254.76,-372.46;-595.95,254.76,-364.95;-611.96,254.76,-361.08;-628.54,254.76,-355.32;-642.75,254.99,-346.68;-651.21,255.36,-331.65;-657.31,255.29,-316.14;-659.10,254.76,-298.48;-661.58,254.76,-281.04;-663.67,254.76,-263.43;-661.70,254.76,-245.74;-658.81,254.76,-228.25;-653.88,254.87,-212.64;-644.80,254.76,-197.47;-635.10,254.76,-182.56;-625.80,254.76,-167.51;-616.60,254.76,-153.72;-603.40,255.00,-141.85;-586.74,255.01,-136.88;-570.25,255.01,-134.43;-558.36,255.01,-121.87;-555.58,255.01,-105.87;-550.81,255.10,-88.88;-551.89,255.04,-72.83;-561.42,254.73,-58.02;-576.70,254.76,-52.42;-592.96,254.76,-49.52;-610.39,254.76,-46.47;-628.00,254.76,-44.08;-645.63,254.76,-42.13;-656.67,254.76,-28.85;-663.15,254.76,-13.85;-667.15,254.76,3.37;-666.19,254.76,19.71;-658.19,259.14,35.36;-646.61,262.22,46.95;-634.83,261.70,58.34;-628.24,257.08,74.66;-626.51,254.76,92.32;-625.92,254.76,110.06;-627.47,254.76,126.43;-630.69,254.76,143.83;-631.67,254.76,160.21;-627.60,254.76,177.42;-620.83,254.76,192.36;-610.52,254.76,206.76;-597.95,254.76,219.29;-585.88,254.76,230.37;-569.21,254.76,236.26;-553.97,254.76,242.35;-536.90,254.76,239.61;-521.48,254.76,230.93;-507.19,254.78,222.83;-497.05,254.99,210.91;-495.98,254.98,194.56|-480.91,254.88,216.60;-465.83,254.76,225.38;-441.50,258.47,225.75;-423.99,260.27,222.57;-408.15,256.41,228.00;-398.92,254.76,241.10;-396.47,254.76,257.32;-392.05,254.76,274.23;-398.14,254.76,290.83;-402.35,254.76,308.09;-411.05,258.37,323.32;-422.83,260.85,334.52;-435.90,259.73,344.20;-446.22,254.66,358.68;-451.39,254.76,375.57;-453.77,254.76,391.80;-459.75,254.76,406.93;-472.53,254.76,419.13;-484.17,254.76,430.70;-494.31,254.76,443.58;-503.48,254.76,457.16;-511.69,254.76,472.89;-518.53,254.76,487.85;-523.97,254.76,504.71;-527.09,254.76,520.86;-531.34,254.94,538.11;-536.50,254.99,554.97;-539.73,254.99,571.19;-541.77,255.00,588.72;-551.76,254.76,602.85;-565.04,254.76,612.43;-581.23,254.76,614.44;-598.91,254.76,615.09;-615.07,254.76,617.69;-632.41,254.76,620.75;-648.70,254.76,618.43;-663.39,254.76,608.89;-675.42,254.76,597.72;-674.58,254.76,580.34|-660.54,254.76,605.26;-648.74,254.76,618.39;-631.59,254.76,622.21;-613.92,255.29,623.69;-597.50,254.66,625.04;-579.84,254.76,625.96;-563.40,254.76,626.92;-545.87,254.76,627.28;-529.54,254.76,625.19;-511.89,255.29,623.52;-495.49,255.30,622.81;-477.78,255.30,622.70;-461.38,255.30,623.33;-444.97,255.30,624.02;-428.58,255.11,624.07;-410.91,254.76,622.85;-396.33,254.80,634.85;-388.08,254.80,648.82;-374.20,254.96,657.71;-368.23,254.99,673.62;-367.31,254.99,689.98;-366.73,254.99,707.74;-366.52,254.99,725.38;-366.49,254.99,741.84;-366.16,254.99,758.27;-366.75,254.99,774.69;-367.92,254.99,791.12;-367.14,254.99,808.87;-368.46,254.99,826.56;-369.74,254.99,842.95;-368.76,254.99,860.61;-367.04,254.99,876.98;-367.00,254.99,894.67;-369.42,254.99,910.96;-372.67,254.99,928.31;-361.15,254.99,909.78;-359.76,254.99,892.03;-358.19,254.99,874.36;-358.33,254.99,857.94;-359.94,254.99,840.26;-360.81,254.99,822.49;-360.38,254.99,804.82;-359.17,254.99,788.44;-356.61,254.99,770.85;-356.74,254.99,753.08;-357.75,254.99,735.37;-358.91,254.99,717.78;-358.75,254.99,701.41;-356.06,254.99,683.88;-353.99,254.99,667.58;-345.32,254.85,653.18;-329.68,254.80,648.47;-311.95,254.80,648.24;-294.22,254.76,649.65;-277.86,254.76,650.81;-260.16,254.76,649.62;-242.83,254.76,645.78;-226.47,254.76,644.68;-208.85,254.76,646.55;-191.14,254.76,647.71;-174.72,254.76,648.13;-156.96,254.76,648.17;-139.20,254.76,647.31;-121.60,254.76,645.01;-105.37,254.76,642.43;-87.82,254.76,641.39;-71.39,254.79,640.10;-54.21,254.79,635.61;-40.48,254.79,624.63;-30.60,254.79,610.09;-25.08,254.79,594.66;-21.94,254.79,577.25;-19.71,254.79,559.66;-18.21,254.76,543.28;-16.90,254.76,525.47;-15.13,254.76,507.97;-13.29,254.76,491.55;-10.80,254.76,473.97;-8.18,255.32,456.40;-6.19,255.29,438.83;-5.65,255.29,422.35;-8.06,255.29,404.87;-7.37,255.29,388.41;-9.64,255.29,370.76;-9.73,255.29,353.20;-5.94,254.76,337.22;-5.64,254.76,319.49;-8.99,254.76,303.49;-15.79,254.76,280.36]=====]):gmatch("[^|]+") do
  local previous=nil;pieces+=1
  for sx,sy,sz in segment:gmatch("([%-%d%.]+),([%-%d%.]+),([%-%d%.]+)") do
   local px,py,pz=tonumber(sx),tonumber(sy),tonumber(sz)
   local id=#arenaRouteNodes+1;arenaRouteNodes[id]={px,py,pz};arenaNeighbors[id]={};added+=1
   if previous then table.insert(arenaNeighbors[id],previous);table.insert(arenaNeighbors[previous],id) end
   local nearest,nearestDist=nil,8
   for j=1,original do local node=arenaRouteNodes[j];local delta=math.sqrt((node[1]-px)^2+(node[3]-pz)^2)
    if delta<nearestDist and math.abs(node[2]-py)<5 then nearest=j;nearestDist=delta end
   end
   if nearest then table.insert(arenaNeighbors[id],nearest);table.insert(arenaNeighbors[nearest],id) end
   previous=id
  end
 end
 a6("YELLOW ROUTES: "..added.." recorded points in "..pieces.." disconnected sections; car clearance checked before use")
end
do
 local filename="auto_fish_dev_trails_"..tostring(game.PlaceId)..".json"
 local http=game:GetService("HttpService");local trails={};local added=0
 local function valid(p)
  return type(p)=="table" and type(p.x)=="number" and type(p.y)=="number" and type(p.z)=="number" and p.x==p.x and p.y==p.y and p.z==p.z and math.abs(p.x)<6000 and math.abs(p.y)<1500 and math.abs(p.z)<6000
 end
 local function install(points)
  if type(points)~="table" or #points<2 or #points>400 or added+#points>400 then return false,"trail length limit"end
  for i,p in ipairs(points)do
   if not valid(p) then return false,"invalid point"end
   if i>1 then local q=points[i-1];local dist=math.sqrt((p.x-q.x)^2+(p.z-q.z)^2);if dist>28 or math.abs(p.y-q.y)>6 then return false,"disconnected or airborne segment"end end
  end
  local original=#arenaRouteNodes;local last=nil
  for _,point in ipairs(points)do
   local nearest,nearDist=nil,10
   for i=1,original do local n=arenaRouteNodes[i];local delta=math.sqrt((n[1]-point.x)^2+(n[3]-point.z)^2)
    if delta<nearDist and math.abs(n[2]-point.y)<4 then nearest=i;nearDist=delta end
   end
   local id=#arenaRouteNodes+1;arenaRouteNodes[id]={point.x,point.y,point.z};arenaNeighbors[id]={}
   if last then table.insert(arenaNeighbors[id],last);table.insert(arenaNeighbors[last],id)end
   if nearest then
    local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={z.Character,B.car};rp.RespectCanCollide=true
    local from=Vector3.new(point.x,point.y+1,point.z);local node=arenaRouteNodes[nearest];local direction=Vector3.new(node[1]-point.x,0,node[3]-point.z)
    local hit=direction.Magnitude>.1 and x:Raycast(from,direction,rp)
    if not hit then table.insert(arenaNeighbors[id],nearest);table.insert(arenaNeighbors[nearest],id)end
   end
   last=id
  end
  added=added+#points;return true
 end
 local raw=bo(filename)
 if raw and raw~=""then local ok,data=pcall(function()return http:JSONDecode(raw)end)
  if ok and type(data)=="table" and data.placeId==game.PlaceId and type(data.trails)=="table"then
   for _,points in ipairs(data.trails)do local accepted=install(points);if accepted then trails[#trails+1]=points end end
  end
 end
 B.addDeveloperTrail=function(points)
  if not B.devEnabled then return false,"developer mode locked"end
  if #trails>=20 then return false,"20-trail limit reached"end
  -- Validate and persist before installing, so storage failures don't leave a
  -- trail that appears saved but disappears on rejoin.
  if type(points)~="table" or #points<2 or #points>400 or added+#points>400 then return false,"need 2-400 total saved points"end
  for i,p in ipairs(points)do if not valid(p) then return false,"invalid point"end;if i>1 then local q=points[i-1];if math.sqrt((p.x-q.x)^2+(p.z-q.z)^2)>28 or math.abs(p.y-q.y)>6 then return false,"recording contains a gap or airborne segment"end end end
  local nextTrails={};for _,trail in ipairs(trails)do nextTrails[#nextTrails+1]=trail end;nextTrails[#nextTrails+1]=points
  local ok,encoded=pcall(function()return http:JSONEncode({placeId=game.PlaceId,trails=nextTrails})end)
  if not ok or not br(filename,encoded) then return false,"executor could not save trail file"end
  local accepted,why=install(points);if not accepted then return false,why end
  trails=nextTrails;a6("DEV TRAIL: saved "..#points.." grounded points; "..#trails.." trails total");return true
 end
end
-- Local-only display of the actual active waypoint plan.
local arenaRouteVisible=false;pcall(function()local old=x:FindFirstChild("AutoFishPlannedRoute");if old then old:Destroy()end end)
local arenaRouteFolder=nil
local arenaRoutePlan=nil
local arenaRouteStart=nil
local function arenaClearRouteVisual()
 if arenaRouteFolder then pcall(function() arenaRouteFolder:Destroy() end);arenaRouteFolder=nil end
end
local function arenaShowRouteVisual(origin,points,stage)
 arenaRouteStart=origin;arenaRoutePlan=points
 arenaClearRouteVisual()
 if not arenaRouteVisible or not origin or not points or #points==0 then return end
 local folder=Instance.new("Folder");folder.Name="AutoFishPlannedRoute";folder.Parent=x;arenaRouteFolder=folder
 local last=origin+Vector3.new(0,2,0)
 for index,waypoint in ipairs(points) do
  local floor=eV(waypoint.x,waypoint.z,origin.Y+30)
  local position=Vector3.new(waypoint.x,(floor or origin.Y)+3,waypoint.z)
  local delta=position-last;local length=delta.Magnitude
  if length>0.05 then
   local beam=Instance.new("Part");beam.Name="Route "..index;beam.Anchored=true;beam.CanCollide=false;beam.CanTouch=false;beam.CanQuery=false;beam.CastShadow=false;beam.Material=Enum.Material.Neon;beam.Color=Color3.fromRGB(255,95,35);beam.Transparency=0.18;beam.Size=Vector3.new(.32,.32,math.min(length,2048));beam.CFrame=CFrame.lookAt((last+position)*.5,position);beam.Parent=folder
  end
  local point=Instance.new("Part");point.Name="Waypoint "..index;point.Anchored=true;point.CanCollide=false;point.CanTouch=false;point.CanQuery=false;point.CastShadow=false;point.Material=Enum.Material.Neon;point.Color=Color3.fromRGB(255,210,50);point.Shape=Enum.PartType.Ball;point.Size=Vector3.new(1.3,1.3,1.3);point.Position=position;point.Parent=folder
  if index==1 or index==#points or index%5==0 then
   local tag=Instance.new("BillboardGui");tag.Size=UDim2.fromOffset(120,24);tag.StudsOffset=Vector3.new(0,2,0);tag.AlwaysOnTop=true;tag.MaxDistance=2000;tag.Adornee=point;tag.Parent=point
   local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1;label.TextColor3=Color3.fromRGB(255,220,85);label.TextStrokeTransparency=0;label.TextSize=13;label.Text=(index==#points and tostring(stage).." DESTINATION" or "WAYPOINT "..index);label.Parent=tag
  end
  last=position
 end
end
local function arenaRecordedRoute(origin,goal,exactGoal)
 if not origin or not goal or not goal.x or not goal.z then return nil end
 local count=#arenaRouteNodes;local dist,prev,used={},{},{}
 local yellowChecks={}
 local function yellowClear(a,b)
  if a<yellowFirst and b<yellowFirst then return true end
  local key=math.min(a,b)..":"..math.max(a,b);if yellowChecks[key]~=nil then return yellowChecks[key] end
  local car=B.car;local body=car and (car:FindFirstChild("MD_BodyCollision",true) or car:FindFirstChild("Chassis",true))
  if not body or not body:IsA("BasePart") then yellowChecks[key]=false;return false end
  local from,to=arenaRouteNodes[a],arenaRouteNodes[b]
  local dx,dz=to[1]-from[1],to[3]-from[3];local length=math.sqrt(dx*dx+dz*dz)
  if length>25 or math.abs(from[2]-to[2])>6 then yellowChecks[key]=false;return false end
  local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.FilterDescendantsInstances={car,z.Character};overlap.MaxParts=100
  local clear=true;local steps=math.max(1,math.ceil(length/5));local lastGround=nil
  for step=0,steps do
   local alpha=step/steps;local px,pz=from[1]+dx*alpha,from[3]+dz*alpha;local expected=from[2]+(to[2]-from[2])*alpha
   local ground=eV(px,pz,expected+9)
   if not ground or math.abs(ground-expected)>6 or (lastGround and math.abs(ground-lastGround)>3) then clear=false;break end
   lastGround=ground
   local facing=length>.1 and Vector3.new(dx/length,0,dz/length) or Vector3.new(0,0,-1)
   local center=Vector3.new(px,ground+body.Size.Y/2+1,pz)
   local ok,hits=pcall(function()return workspace:GetPartBoundsInBox(CFrame.lookAt(center,center+facing),Vector3.new(body.Size.X+1,body.Size.Y,body.Size.Z+1),overlap)end)
   if not ok then clear=false;break end
   for _,part in ipairs(hits) do if part.CanCollide and part.Position.Y+part.Size.Y/2>ground+1 then clear=false;break end end
   if not clear then break end
  end
  yellowChecks[key]=clear;return clear
 end
 local function metric(x,z,node) return math.sqrt((node[1]-x)^2+(node[3]-z)^2) end
 local nearStart,nearGoal=0,0;local closestStart,closestGoal=math.huge,math.huge
 for i,node in ipairs(arenaRouteNodes) do local a=metric(origin.X,origin.Z,node);local b=metric(goal.x,goal.z,node);closestStart=math.min(closestStart,a);closestGoal=math.min(closestGoal,b);if a<=60 then dist[i]=a;nearStart=nearStart+1 else dist[i]=math.huge end;if b<=60 then nearGoal=nearGoal+1 end end
 if closestStart>600 or closestGoal>600 then a6("RECORDED ROUTE: too far from saved path; start="..p(closestStart).." destination="..p(closestGoal));return nil end
 if nearStart==0 then
  for i,node in ipairs(arenaRouteNodes) do local a=metric(origin.X,origin.Z,node);if a<=closestStart+8 then dist[i]=a end end
  a6("OFF-PATH SPAWN: nearest recorded path "..p(closestStart).." studs away; dodge obstacles to join")
 end
 local goalLimit=nearGoal>0 and 60 or closestGoal+8
 if nearGoal==0 then a6("OFF-PATH DESTINATION: nearest recorded path "..p(closestGoal).." studs away")end
 local best,score=nil,math.huge
 for _=1,count do
  local selected,bestDist=nil,math.huge
  for i=1,count do if not used[i] and dist[i]<bestDist then selected,bestDist=i,dist[i] end end
  if not selected or bestDist>=score then break end
  used[selected]=true
  local node=arenaRouteNodes[selected];local toGoal=metric(goal.x,goal.z,node)
  if ((exactGoal and selected==exactGoal) or (not exactGoal and toGoal<=goalLimit)) and bestDist+toGoal<score then best,score=selected,bestDist+toGoal end
  for _,j in ipairs(arenaNeighbors[selected]) do if not used[j] and yellowClear(selected,j) then local nextNode=arenaRouteNodes[j];local step=metric(node[1],node[3],nextNode);local value=bestDist+step;if value<dist[j] then dist[j]=value;prev[j]=selected end end end
 end
 if not best then return nil end
 local reverse={};while best do local node=arenaRouteNodes[best];reverse[#reverse+1]={x=node[1],z=node[3]};best=prev[best] end
 local route={};for i=#reverse,1,-1 do route[#route+1]=reverse[i] end
 if #route>0 then
  local first=route[1];first.connector=math.sqrt((first.x-origin.X)^2+(first.z-origin.Z)^2)>14
  local last=route[#route];route[#route+1]={x=goal.x,z=goal.z,connector=math.sqrt((goal.x-last.x)^2+(goal.z-last.z)^2)>1.5}
 end
 return route
end
B.closestRecordedFishRoad=function(mark)
 local best,bestDist=nil,math.huge
 local level10=(mark.X-496.336)^2+(mark.Z+1073.662)^2<25^2
 for index,node in ipairs(arenaRouteNodes) do
  local distance=math.sqrt((node[1]-mark.X)^2+(node[3]-mark.Z)^2)
  if (not level10 or index>=yellowFirst) and distance>=20 and distance<=600 and distance<bestDist then
   local ground=eV(node[1],node[3],node[2]+12)
   if ground and math.abs(ground-node[2])<9 then
    local dry=true
    for _,off in ipairs({{0,0},{5,0},{-5,0},{0,7},{0,-7}}) do
     local sample=eV(node[1]+off[1],node[3]+off[2],ground+12)
     if not sample or math.abs(sample-ground)>5 then dry=false;break end
    end
    if dry then
     local ok,parts=pcall(function()return x:GetPartBoundsInBox(CFrame.new(node[1],ground+3,node[3]),Vector3.new(9,5,12))end)
     local clear=ok and type(parts)=="table"
     if clear then for _,part in ipairs(parts)do
      local own=B.car and part:IsDescendantOf(B.car);local character=z.Character and part:IsDescendantOf(z.Character)
      local top=part.Position.Y+part.Size.Y/2
      if not own and not character and part.CanCollide and top>ground+1.2 then clear=false;break end
     end end
     if clear then best={x=node[1],y=ground,z=node[3]};bestDist=distance end
    end
   end
  end
 end
 if best then a6("FISH PARK: dry footprint recorded road distance="..p(bestDist))
 else a6("FISH PARK: no checked dry road at least 20 studs from spot; stopping")end
 return best,bestDist
end
-- Fish parking must be reachable from the current recorded-road component,
-- not merely geometrically nearest to the selected fishing mark.
B.connectedFishParking=function(mark,origin,preferred,preferredDist)
 if not mark or not origin then return nil end
 B.fishParkingPlan=nil
 local function reaches(park,index)
  if not index then
   local best=0.15
   for i,node in ipairs(arenaRouteNodes) do
    local d=math.sqrt((node[1]-park.x)^2+(node[3]-park.z)^2)
    if d<best then best=d;index=i end
   end
  end
  if not index then return false end
  -- Search to the actual parking node rather than a cheaper neighbouring
  -- node; a neighbouring node may leave an unsafe unchecked final jump.
  local route=arenaRecordedRoute(origin,park,index)
  if not route or #route<2 then return false end
  local previous=route[#route-1];local last=route[#route]
  local gap=math.sqrt((last.x-previous.x)^2+(last.z-previous.z)^2)
  if gap>1 then return false end
  B.fishParkingPlan={origin=origin,park=park,route=route,node=index}
  return true
 end
 if preferred and reaches(preferred) then a6("FISH PARK: exact parking node reachable");return preferred,preferredDist end
 local level10=(mark.X-496.336)^2+(mark.Z+1073.662)^2<25^2
 a6(level10 and "FISH PARK: closest yellow point unreachable; checking other dry yellow points" or "FISH PARK: closest parking belongs to an unreachable road section; checking connected alternatives")
 local candidates={};local unique={}
 -- Level 10: try the remaining yellow samples, not just the single closest.
 -- Other levels retain their existing original-road fallback.
 for index=level10 and yellowFirst or 1,level10 and #arenaRouteNodes or yellowFirst-1 do
  local node=arenaRouteNodes[index];local dist=math.sqrt((node[1]-mark.X)^2+(node[3]-mark.Z)^2)
  if dist>=20 and dist<=550 then candidates[#candidates+1]={node=node,dist=dist,index=index} end
 end
 table.sort(candidates,function(a,b)return a.dist<b.dist end)
 local tried=0
 for _,candidate in ipairs(candidates) do
  local node=candidate.node;local cell=math.floor(node[1]/18)..":"..math.floor(node[3]/18)
  if not unique[cell] then
   unique[cell]=true
   local ground=eV(node[1],node[3],node[2]+12)
   if ground and math.abs(ground-node[2])<9 then
    local dry=true
    for _,off in ipairs({{0,0},{5,0},{-5,0},{0,7},{0,-7}}) do
     local sample=eV(node[1]+off[1],node[3]+off[2],ground+12)
     if not sample or math.abs(sample-ground)>5 then dry=false;break end
    end
    if dry then
     local ok,parts=pcall(function()return x:GetPartBoundsInBox(CFrame.new(node[1],ground+3,node[3]),Vector3.new(9,5,12))end)
     local clear=ok and type(parts)=="table"
     if clear then for _,part in ipairs(parts)do
      local own=B.car and part:IsDescendantOf(B.car);local character=z.Character and part:IsDescendantOf(z.Character)
      if not own and not character and part.CanCollide and part.Position.Y+part.Size.Y/2>ground+1.2 then clear=false;break end
     end end
     if clear then
      local candidatePark={x=node[1],y=ground,z=node[3]};tried+=1
      if reaches(candidatePark,candidate.index) then a6("FISH PARK: connected dry "..(level10 and "yellow" or "recorded-road").." alternative "..p(candidate.dist).." studs from mark; checked "..tried);return candidatePark,candidate.dist end
      if level10 then k(.03) end
      if tried>=24 then break end
     end
    end
   end
  end
 end
 a6("FISH PARK: no connected dry recorded-road parking found after "..tried.." checks")
 return nil
end
B.arenaRecordedRoute=arenaRecordedRoute;B.arenaShowRouteVisual=arenaShowRouteVisual;B.arenaClearRouteVisual=arenaClearRouteVisual
B.arenaSetRouteVisible=function(value) arenaRouteVisible=false;arenaClearRouteVisual() end
end
do
 local env=r();if type(env)=="table" and env.DRIXN_AntiIdleConnection then pcall(function()env.DRIXN_AntiIdleConnection:Disconnect()end)end
 local connection=z.Idled:Connect(function()
  local ok,err=pcall(function()
   local vu=game:GetService("VirtualUser");local camera=x.CurrentCamera
   vu:CaptureController();vu:Button2Down(Vector2.new(0,0),camera and camera.CFrame or CFrame.new())
   task.wait(.8);vu:Button2Up(Vector2.new(0,0),camera and camera.CFrame or CFrame.new())
  end)
  a6(ok and "ANTI AFK: idle input sent" or ("ANTI AFK unavailable: "..tostring(err)))
 end)
 if type(env)=="table" then env.DRIXN_AntiIdleConnection=connection end
end
B.levelFishingSpots={
 [0]=Vector3.new(126.304,243.623,-764.967),
 [10]=Vector3.new(496.336,241.372,-1073.662),
 [20]=Vector3.new(-393.909,245.755,831.326),
 [25]=Vector3.new(75.388,246.922,809.052),
}
B.resolveSpotTier=function()
 if B.spotChoice~="auto" then return tonumber(B.spotChoice) end
 local gui=z:FindFirstChild("PlayerGui");local skills=gui and gui:FindFirstChild("MD_SkillsGui")
 local ui=skills and skills:FindFirstChild("SkillsProgressUI");local list=ui and ui:FindFirstChild("ListPage");local careers=list and list:FindFirstChild("Careers");local fishing=careers and careers:FindFirstChild("Fishing");local title=fishing and fishing:FindFirstChild("Title")
 local text=title and title:IsA("TextLabel") and title.Text or nil
 local level=text and tonumber(text:match("[Ff]ishing%s*:%s*(%d+)"))
 if not level then for _,key in ipairs({"MD_FishingLevel","FishingLevel"}) do local value=z:GetAttribute(key);if type(value)=="number" and value>=0 then level=value;break end end end
 if not level then a6("AUTO FISH LEVEL unavailable: skills title or fishing level attribute missing; choose a manual spot");return nil end
 local tier=level>=25 and 25 or level>=20 and 20 or level>=10 and 10 or 0
 a6("AUTO FISH LEVEL: "..level.." -> level "..tier.." spot")
 return tier
end
B.chooseFishingSpot=function()
 local tier=B.resolveSpotTier()
 if not tier or not B.levelFishingSpots[tier] then return nil,"fishing level unavailable: open skills or select a manual spot"end
 local index=({[0]=6,[10]=3,[20]=13,[25]=12})[tier]
 -- New level 20/30 coordinates are explicit; older saved marks must not override them.
 local entry=(tier~=20 and tier~=25) and B.orderedCoords and B.orderedCoords[index] or nil
 local spot=entry and Vector3.new(entry.x,entry.y,entry.z) or B.levelFishingSpots[tier]
 B.underFishMark=spot;B.selectedSpotTier=tier
 a6("FISH SPOT: using ordered mark "..tostring(index)..(entry and " from saved marks" or " from supplied coordinates"))
 a6("FISH SPOT: manually selected level "..tier.." at "..tostring(spot))
 return spot
end
B.teleportCharacter=function(v,label,exactFish,streamRetried)
 local root=ao();local hum=aq();if not root or not hum or not v then return false,"character or target missing"end
 if hum.SeatPart then
  hum.Sit=false;hum.Jump=true;pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)end);k(.5)
  if hum.SeatPart then return false,"exit current seat before teleport"end
 end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={z.Character};params.IgnoreWater=false;params.RespectCanCollide=true
 local offsets=exactFish and {Vector3.zero} or {Vector3.new(2,0,0),Vector3.new(-2,0,0),Vector3.new(0,0,2),Vector3.new(0,0,-2),Vector3.zero}
 for _,offset in ipairs(offsets) do
  local point=v+offset;local hit=workspace:Raycast(point+Vector3.new(0,6,0),Vector3.new(0,-20,0),params)
  if hit and hit.Material~=Enum.Material.Water and hit.Normal.Y>=.6 and math.abs(hit.Position.Y-v.Y)<=10 and (label~="PLANT shop" or hit.Position.Y<=v.Y+.5) then
   local target=(label=="FISH" and exactFish and B.selectedSpotTier==25) and point or Vector3.new(point.X,hit.Position.Y+hum.HipHeight+root.Size.Y/2,point.Z)
   local ok=pcall(function()hum:Move(Vector3.zero,false);root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero;root.CFrame=CFrame.new(target)*root.CFrame.Rotation end)
   if ok then k(.5);local current=ar();if current and (current-target).Magnitude<=((label=="FISH" and exactFish and B.selectedSpotTier==25) and 1 or 5) then a6("TELEPORT "..tostring(label)..": confirmed character="..tostring(current).." floor="..Y(hit.Instance));return true,target end end
   return false,"teleport corrected or rejected; no further action sent"
  end
 end
 if label=="FISH" and not streamRetried then
  a6("TELEPORT FISH: floor not loaded or not found; requesting destination streaming before one checked retry")
  local complete=false;task.spawn(function()pcall(function()z:RequestStreamAroundAsync(v,5)end);complete=true end)
  local untilTime=os.clock()+6;while not complete and os.clock()<untilTime and not B.stop do task.wait(.1)end
  if not B.stop then return B.teleportCharacter(v,label,exactFish,true)end
 end
 return false,"no verified dry floor near destination"
end
B.teleportToShopPrompt=function(prompt)
 local root=ao();local hum=aq();local pos=prompt and co(prompt)
 if not root or not hum or not pos then return false,"shop prompt or character unavailable"end
 if hum.SeatPart then hum.Sit=false;hum.Jump=true;k(.5);if hum.SeatPart then return false,"exit seat first"end end
 local range=tonumber(prompt.MaxActivationDistance) or 10
 if range<=1 then return false,"shop prompt range unavailable"end
 local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances={z.Character};ray.IgnoreWater=false;ray.RespectCanCollide=true
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.FilterDescendantsInstances={z.Character};overlap.MaxParts=100
 -- Probe near the register at the known shop-floor elevation, not above its
 -- display cabinets. Never walk toward the register in teleport mode.
 local expected=(B.shopTarget and B.shopTarget.y) or 255.23
 for _,offset in ipairs({Vector3.new(3,0,0),Vector3.new(-3,0,0),Vector3.new(0,0,3),Vector3.new(0,0,-3),Vector3.new(5,0,0),Vector3.new(-5,0,0),Vector3.new(0,0,5),Vector3.new(0,0,-5),Vector3.new(4,0,4),Vector3.new(-4,0,-4)})do
  local point=pos+offset;local hit=workspace:Raycast(Vector3.new(point.X,expected+1,point.Z),Vector3.new(0,-12,0),ray)
  if hit and hit.Material~=Enum.Material.Water and hit.Normal.Y>=.6 and math.abs(hit.Position.Y-expected)<=6 then
   local dest=Vector3.new(point.X,hit.Position.Y+hum.HipHeight+root.Size.Y/2,point.Z)
   if (dest-pos).Magnitude<=range-.6 then
    local clear=true;local success,parts=pcall(function()return workspace:GetPartBoundsInBox(CFrame.new(dest),Vector3.new(2,3.5,2),overlap)end)
    if not success then clear=false else for _,part in ipairs(parts)do if part.CanCollide and part.Position.Y+part.Size.Y/2>hit.Position.Y+.3 then clear=false;break end end end
    if clear then
     local ok=pcall(function()hum:Move(Vector3.zero,false);root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero;root.CFrame=CFrame.new(dest)*root.CFrame.Rotation end)
     if not ok then return false,"placement failed"end;k(.5)
     local actual=ar();if actual and (actual-dest).Magnitude<=3 and (actual-pos).Magnitude<=range then a6("SHOP TELEPORT: in range="..p((actual-pos).Magnitude).." floor="..Y(hit.Instance));return true,dest end
     return false,"shop teleport corrected or out of range"
    end
   end
  end
 end
 return false,"no clear floor within shop prompt range"
end
local function fR(bQ,f0)
 if B.travelMode=="Teleport" then
  if B.unlockTravelCamera then B.unlockTravelCamera()end
  local dest
  if f0=="FISH" then
   local mark,why=B.chooseFishingSpot();if not mark then G("fishing spot: "..tostring(why));return false end;dest=mark
  elseif f0=="ATM" then
   local atm=B.atmTarget;local obj=atm and H.resolveMarkedAtm(atm);local prompt=obj and obj:FindFirstChild("MD_ATMPrompt",true);dest=prompt and co(prompt)
  elseif f0=="SELL" then local t=B.sellerTrail;dest=t and t[1]
  elseif f0=="SHOP" then local store=workspace:FindFirstChild("HardwareStore",true);local prompt=store and store:FindFirstChild("MD_JackFarmStore",true);dest=prompt and co(prompt)
  else dest=bQ and bQ.x and Vector3.new(bQ.x,bQ.y,bQ.z) end
  if not dest then G("teleport: "..tostring(f0).." destination not available");return false end
  local ok,placed
  if f0=="SHOP" then local store=workspace:FindFirstChild("HardwareStore",true);local prompt=store and store:FindFirstChild("MD_JackFarmStore",true);ok,placed=B.teleportToShopPrompt(prompt)
  else ok,placed=B.teleportCharacter(dest,f0,f0=="FISH")end
  if not ok then G("teleport "..tostring(f0)..": "..tostring(placed));return false end
  B.car=nil;B.underground=false;B.inUnderFish=false;B.stage=f0;B.autoDrive={active=false,done=true,stage=f0,mode="teleport"}
  if f0=="FISH" then B.underFishMark=placed;B.castTarget={x=placed.X,y=placed.Y,z=placed.Z} end
  task.spawn(function()if not B.stop and not B.done then I(f0)end end)
  return true
 end
 if f0~="FISH" and B.unlockTravelCamera then B.unlockTravelCamera()end
 if B.inUnderFish then
  local ok,why=B.returnMarkedFishSurface();if not ok then G("unable to return to surface: "..tostring(why));return false end
  if B.car and not aL(B.car) and not dt(B.car) then G("surface return: could not board parked car");return false end
 end
 if f0=="FISH" then
  local mark,why=B.chooseFishingSpot();if not mark then G("fishing spot: "..tostring(why));return false end
  local road,dist=B.closestRecordedFishRoad(mark)
  local origin=B.car and at(B.car)
  if road and origin and aL(B.car) then road,dist=B.connectedFishParking(mark,origin,road,dist) end
  if not road or not dist or dist>550 then G("no route: no connected verified dry parking within glide range of selected fishing spot");return false end
  B.fishingSurfaceRoad=road;bQ=road
  if B.activeFarmMode=="Sky" then
   B.castTarget={x=mark.X,y=mark.Y,z=mark.Z}
   a6("SKY: selected mark "..tostring(B.selectedSpotTier).." used for platform and water search")
  end
 end
 B.atmRoutePending=f0=="ATM"
 if B.car and (not B.vehicleProfile or B.vehicleProfile.car~=B.car) then local ok,why=B.scanVehicle(B.car);if not ok then G("vehicle scan failed: "..tostring(why));return false end end
 if B.car and not B.finiteVector(at(B.car)) then G("non-finite vehicle physics; reset character, respawn vehicle, and reload script");return false end
 if f0=="FISH" and not B.car then B.car=cb() or c8();if not B.car then G("fishing trip requires owned car; on-foot fallback disabled");return false end end
 if B.skyState then local ok,why=B.skyDescend();if not ok then G(why);return false end end
 if not bQ or not bQ.x or not bQ.z or bQ.x==0 and bQ.z==0 then a6("AUTO DRIVE refused - no..."..tostring(f0))return false end;if math.abs(bQ.x)>6000 or math.abs(bQ.z)>6000 then a6("AUTO DRIVE refused - target "..p(bQ.x)..", "..p(bQ.z).." is off the map for "..tostring(f0))return false end;do local fS=at(B.car)or ar()if fS then local fT=math.sqrt((bQ.x-fS.X)^2+(bQ.z-fS.Z)^2)if fT>4000 then a6("AUTO DRIVE refused - "..p(fT).." studs away for "..tostring(f0)..", that is not the same...")return false end end end;if not B.car then local fU=cd()if fU then B.car=fU;B.seated=true;a6("SURFACE DRIVE: spawned car "..tostring(V(B.car,"Name")).."; boarding")if not aL(B.car)then local aP=cu(B.car)if aP then local aM=aq()local bN=ao()if aM and bN then local d8=V(aP,"Position")if d8 and a3(V(bN,"Position"),d8)<=9 then pcall(function()aP:Sit(aM)end)k(1.0)end end end end;if not aL(B.car)then a6("SURFACE DRIVE: car...")else
  a6("SURFACE DRIVE: verified seat; switching directly to vehicle route")
  return fR(bQ,f0)
 end end;local cw=bQ;if f0=="ATM"and B.atmTarget then local g=B.atmTarget;local c0,c1=g.fx-g.x,g.fz-g.z;local dy=math.max(0.1,math.sqrt(c0*c0+c1*c1))cw={x=g.x+c0/dy*5,y=g.y,z=g.z+c1/dy*5}elseif f0=="FISH"and B.castTarget then local av=B.castTarget;local bS=math.max(0.1,math.sqrt((bQ.x-av.x)^2+(bQ.z-av.z)^2))cw={x=av.x+(bQ.x-av.x)/bS*math.min(17,bS),y=bQ.y,z=av.z+(bQ.z-av.z)/bS*math.min(17,bS)}end;local dJ=f0~="FISH"and cw.y and cw.y+8 or nil;local a1,cV=eV(cw.x,cw.z,dJ)if not a1 then a6("FOOT ROUTE refused: "..tostring(cV))return false end;local fV=_(cw.x,a1+2,cw.z)B.underground=false;B.stage=f0 or"SHOP"B.phase="ON FOOT TO "..B.stage;local fW={active=true,done=false,stage=B.stage,target={x=cw.x,z=cw.z},mode="path"}B.autoDrive=fW;B.liftStarted=false;a6("FOOT ROUTE ["..B.stage.."]: pathfinding around..."..p(cw.x)..","..p(cw.z))i(function()local b9=ar()local cF=a3(b9,fV)or 1e9;local dd=math.min(300,math.max(18,cF/12*2.5+25))local q,cV=cR(fV,f0=="ATM"and 2.5 or 3.5,dd)if B.stop or B.done or B.autoDrive~=fW then return end;if not q then fW.active=false;if cV=="switched to owned car"and B.car and aL(B.car)then B.autoDrive=nil;a6("FOOT -> CAR: resuming "..fW.stage.." using "..tostring(V(B.car,"Name")))if not fR(bQ,fW.stage)then G("car route not safe after...")end;return end;G("foot route "..B.stage.." blocked: "..tostring(cV))return end;fW.active,fW.done=false,true;a6("ARRIVED ON FOOT ["..B.stage.."] "..tostring(cV))if I then local fI,ci=pcall(I,fW.stage)if not fI then G("foot arrival error: "..tostring(ci))end end end)D(false)return true end;if not B.car then local fU=cd()if fU then B.car=fU end end;if not B.car or not aL(B.car)then local cf,a4=c8()if cf and a4 and a4<=40 then B.car=cf;local aP=cu(B.car)local aM=aq()local bN=ao()if aP and aM and bN then local d8=V(aP,"Position")if d8 and a3(V(bN,"Position"),d8)<=9 then pcall(function()aP:Sit(aM)end)k(0.8)end end end;if not aL(B.car)then a6("SURFACE DRIVE: not seated")return false end end;if B.pose then pcall(eR)end;pcall(anchorCar,false)
 do
  local released=false;local lastRoot=nil
  for attempt=1,6 do
   if B.stop or B.done then return false end
   local hum=aq();local seat=hum and hum.SeatPart;local root=seat and seat.AssemblyRootPart
   if root and root:IsDescendantOf(B.car) and not root.Anchored then released=true;break end
   lastRoot=root;if root and root:IsDescendantOf(B.car) then pcall(anchorCar,false)end;k(.25)
  end
  if not released then G("vehicle assembly still anchored or external after unanchor: "..tostring(lastRoot).."; stopped before route");return false end
  a6("DRIVE READY: driver assembly root verified unanchored")
 end
 pcall(function()eO(true)end)
 B.underContinuing=B.activeFarmMode=="Underground" and B.underground and B.underFloor~=nil
 if not B.underContinuing then if B.floor then pcall(function()B.floor:Destroy()end)B.floor=nil end;B.underground,B.snapped,B.pinY,B.driveY=false,false,nil,nil end
 local fX=at(B.car)if not fX then return false end;
if not B.underContinuing and B.stage=="SHOP" and B.shopTarget and math.sqrt((fX.X-B.shopTarget.x)^2+(fX.Z-B.shopTarget.z)^2)<70 then
 local ground=eV(fX.X,fX.Z,B.shopTarget.y+15)
 if ground and math.abs(ground-B.shopTarget.y)<10 and fX.Y<ground-2 then
  a6("SHOP DEPARTURE: car below verified shop floor; recovering to surface")
  local cf=ax(B.car);local forward=cf and cf.LookVector or Vector3.new(0,0,-1)
  local ok,why=eT(fX.X,fX.Z,ground+3,forward.X,forward.Z)
  if not ok then G("shop ground recovery rejected: "..tostring(why));return false end
  fX=at(B.car);if not fX then return false end
 end
end
local cM,fY=eV(fX.X,fX.Z,B.underContinuing and ((B.castTarget and B.castTarget.y or 255)+25) or fX.Y+7)
if not B.underContinuing and cM and fX.Y>cM+12 then
 a6("GROUND HANDOFF: car airborne; waiting for natural landing before drive")
 local untilTime=d()+18
 while not B.stop and not B.done and d()<untilTime and aL(B.car) do
  local seat=cu(B.car);local root=seat and seat.AssemblyRootPart
  if root then pcall(function()local v=root.AssemblyLinearVelocity;root.AssemblyLinearVelocity=Vector3.new(0,math.min(v.Y,0),0);root.AssemblyAngularVelocity=Vector3.zero end)end
  k(.2);fX=at(B.car);if not fX then break end;cM,fY=eV(fX.X,fX.Z,fX.Y+7)
  if cM and fX.Y>=cM-2 and fX.Y<=cM+8 then break end
 end
end
if B.stop or B.done then return false end
if not fX or not cM or (not B.underContinuing and (fX.Y<cM-2 or fX.Y>cM+12)) or not aL(B.car) then B.unsafeVehicleLatch=true;G("ground drive stopped: car not safely on ground after boarding");return false end
local wheelOffset,wheelCount=0,0
for _,wheel in ipairs(eU(B.car)) do pcall(function()
 local cf=wheel.CFrame;local sz=wheel.Size
 local radius=(math.abs(cf.RightVector.Y)*sz.X+math.abs(cf.UpVector.Y)*sz.Y+math.abs(cf.LookVector.Y)*sz.Z)*.5
 local offset=fX.Y-(wheel.Position.Y-radius)
 if offset>0.1 and offset<math.max(8,(B.vehicleProfile and B.vehicleProfile.height or 5)+3) then wheelOffset=wheelOffset+offset;wheelCount=wheelCount+1 end
end)end
B.surfaceRideHeight=wheelCount>0 and math.clamp(wheelOffset/wheelCount+.05,1,10) or math.clamp(fX.Y-cM,1,8);if B.vehicleProfile then B.vehicleProfile.rideHeight=B.surfaceRideHeight end
a6("GROUND RIDE wheel-based pivot height="..p(B.surfaceRideHeight).." samples="..wheelCount)
local f9,fZ
if f0=="FISH" and B.activeFarmMode=="Underground" and B.fishingSurfaceRoad then f9=B.fishingSurfaceRoad;fZ="verified dry recorded road before fishing glide";a6("FISH PARK: stopping on recorded dry road, not driving into water")end
if f0=="SHOP" and B.cashReadyFootShop and math.sqrt((bQ.x+136.82)^2+(bQ.z-154.71)^2)<12 then
 f9,fZ=e_({x=-80.73,y=254.16,z=122.44},"SHOP")
 if f9 then B.recordedShopFoot=true;a6("SHOP PARK: using recorded roadside parking before shop foot route")else B.recordedShopFoot=false;a6("SHOP PARK: recorded parking unavailable; using existing checked parking")end
else B.recordedShopFoot=false end
if not f9 and f0=="SHOP" and B.cashReadyFootShop and B.door1 and B.door2 then
 local first,second=B.door1,B.door2;local shop=Vector3.new(bQ.x,bQ.y,bQ.z)
 if (first-shop).Magnitude<=65 and (second-shop).Magnitude<=65 and (first-second).Magnitude>=2 and (first-second).Magnitude<=35 then
  local outside=(first-fX).Magnitude<(second-fX).Magnitude and first or second
  f9,fZ=e_({x=outside.X,y=outside.Y,z=outside.Z},"SHOP")
  if f9 then a6("SHOP PARK: using approach-side marked door") end
 end
end
if f0=="SELL" and B.sellerMarks and B.sellerMarks.road then
 local road=B.sellerMarks.road;local door=B.sellerMarks.inside
 local away=Vector3.new(road.X-door.X,0,road.Z-door.Z);if away.Magnitude<1 then B.lastRouteFailure="seller parking direction unavailable";return false end;away=away.Unit
 local side=Vector3.new(-away.Z,0,away.X)
 local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={B.car,z.Character};rp.IgnoreWater=false;rp.RespectCanCollide=true
 local sizes={Vector3.new(18,5,24),Vector3.new(24,5,18)}
 for _,offset in ipairs({{14,0},{20,0},{26,0},{20,8},{20,-8},{30,8},{30,-8}}) do
  local point=road+away*offset[1]+side*offset[2]
  local ok,hit=pcall(function()return x:Raycast(Vector3.new(point.X,road.Y+12,point.Z),Vector3.new(0,-30,0),rp)end)
  local clear=ok and hit and hit.Material~=Enum.Material.Water and hit.Normal.Y>.7 and math.abs(hit.Position.Y-road.Y)<7
  if clear then for _,size in ipairs(sizes) do
   local query,parts=pcall(function()return x:GetPartBoundsInBox(CFrame.new(point.X,hit.Position.Y+3.5,point.Z),size)end)
   if not query then clear=false;break end
   for _,part in ipairs(parts) do
    local own=part:IsDescendantOf(B.car);local character=z.Character and part:IsDescendantOf(z.Character)
    if not own and not character and part.CanCollide and part.Position.Y+part.Size.Y/2>hit.Position.Y+1.2 then clear=false;break end
   end
   if not clear then break end
  end end
  if clear then local park={x=point.X,y=hit.Position.Y,z=point.Z};local route=arenaRecordedRoute(fX,park)
   if route and #route>0 then f9=park;fZ="clear seller parking away from door and sign";a6("SELL PARK: checked alternative "..p(offset[1]).." studs away from seller door; runtime final clearance still required");break end
  end
 end
 if not f9 then B.lastRouteFailure="no checked seller parking away from door and sign";a6("SELL PARK STOP: "..B.lastRouteFailure);return false end
end
if not f9 then f9,fZ=e_(bQ,f0);if f0=="SHOP" and B.cashReadyFootShop then a6("SHOP PARK: using safe shop-side parking; mark both sides of door for closer positioning")end end
if not f9 then B.lastRouteFailure=tostring(fZ);a6("SURFACE DRIVE refused: "..tostring(fZ))return false end;a6("ARRIVAL PARK ["..tostring(f0).."] "..p(f9.x)..","..p(f9.z).." ("..fZ..")")if t.UndergroundMode then local ak=B.underContinuing and B.pinY or cM-(t.UnderFloorClearance or 16)local ft=ax(B.car)local ea=ft and ft.LookVector;local c0,c1=ea and ea.X or 0,ea and ea.Z or 1;local okFloor,floorWhy=B.ensureUnderFloor(ak,B.surfaceRideHeight or 2.5);if not okFloor then G("underground floor unavailable: "..tostring(floorWhy));return false end
 local f_,g0=true,nil
 if not B.underContinuing or math.abs(fX.Y-ak)>3 then
  B.underground=true;B.pinY=ak;arenaSurfaceNoclip();pcall(anchorCar,true)
  f_,g0=eT(fX.X,fX.Z,ak,c0,c1)
 end
 if not f_ then G("underground entry rejected: "..tostring(g0));return false end
 local held,holdWhy=B.holdUnderground(ak);if not held then G("underground vertical hold failed: "..tostring(holdWhy));return false end
 pcall(anchorCar,false);local g1=at(B.car)if not B.finiteVector(g1) or math.abs(g1.Y-ak)>4 or not aL(B.car)then G("underground depth or seat not verified after entry; actual="..tostring(g1).." targetY="..p(ak).." seated="..tostring(aL(B.car)));return false end;B.underground,B.pinY,B.driveY=true,ak,ak;a6("UNDERGROUND: seated..."..p(ak).."; accelerating within...")end;bQ=f9;B.stage=f0 or"SHOP"B.rbCount,B.rbRecovery,B.lastDrivePos,B.surfaceHop,B.seatLostAt,B.avoid=0,false,nil,false,nil,nil;B.surfacePulseAt,B.surfacePulseDue,B.surfacePulseActive=d(),nil,false;B.surfaceHopActive=false;local g2=math.max(1,tonumber(B.gameMaxSpeed)or tonumber(t.SpeedFallback)or 65)local g3=55*math.max(0.5,math.min(5,tonumber(t.CarSpeedMultiplier)or 1))local g4=math.min(g3,g2*2.5);if g4<g3 then a6("SPEED: adjusted for this vehicle max to "..p(g4))end;if g4>g2 then a6("SPEED: requesting "..p(g3).." studs/s; reported vehicle maximum "..p(g2).." may be enforced by server")end;local g5=0;do local fS=at(B.car)or ar()if fS then g5=math.sqrt((bQ.x-fS.X)^2+(bQ.z-fS.Z)^2)end end;local g6=nil;if B.routeMode=="Above ground"and not B.underground then
 local saved=f0=="FISH" and B.fishParkingPlan
 if saved and saved.park and math.sqrt((saved.park.x-f9.x)^2+(saved.park.z-f9.z)^2)<1 then
  if (fX-saved.origin).Magnitude<=8 then g6=saved.route;a6("RECORDED ROUTE: using exact checked parking plan")
  else g6=B.arenaRecordedRoute(fX,f9,saved.node);a6("RECORDED ROUTE: car moved; replanned to exact parking node")end
 else g6=B.arenaRecordedRoute(fX,f9)end
 if g6 and #g6>0 then a6("RECORDED ROUTE: "..tostring(#g6).." original recorded waypoints")else B.lastRouteFailure="cannot connect to recorded path";a6("ROUTE STOP: no recorded route; refusing direct shop shortcut");B.lastFailure="no route: cannot connect recorded path";return false end;pcall(B.arenaShowRouteVisual,fX,g6,f0) end;
if f0=="FISH" and g6 then
 local previous={x=fX.X,z=fX.Z};local probe=fX.Y+30
 for _,way in ipairs(g6) do
  local dx,dz=way.x-previous.x,way.z-previous.z;local length=math.sqrt(dx*dx+dz*dz)
  local steps=math.max(1,math.ceil(length/8));local sx,sz=0,0
  if length>.01 then sx,sz=-dz/length*3,dx/length*3 end
  for n=1,steps do
   local x0,z0=previous.x+dx*n/steps,previous.z+dz*n/steps
   for _,offset in ipairs({0,-1,1}) do
    local ground=eV(x0+sx*offset,z0+sz*offset,probe)
    if not ground then B.lastRouteFailure="fishing route crosses water or unverified ground";a6("FISH ROUTE STOP: "..B.lastRouteFailure);return false end
   end
  end
  previous=way
 end
 a6("FISH ROUTE: sampled recorded route and connectors for dry ground")
end
B.autoDrive={active=true,done=false,stage=B.stage,surfaceWaypoints=g6,roadIndex=1,lastGround=cM,park=f9,maxSpeed=g4,accel=t.SurfaceAcceleration,brake=t.SurfaceBraking,target={x=bQ.x,z=bQ.z},origin=at(B.car)or ar(),started=d(),mode="physics",dist=g5,timeout=math.min(240,math.max(100,g5/g4*5+45)),bestDist=nil,progressAt=d(),logAt=d()}B.hops=0;B.liftStarted=false;B.done,B.stop=false,false;B.speed=0;B.autoDrive.undergroundHopAt=d()C.active,C.stage=true,B.stage;C.targetX,C.targetZ=bQ.x,bQ.z;C.speed,C.gameMax=B.speed,B.gameMaxSpeed;C.startAt,C.rollbackCount=d(),0;C.commandAt,C.rollbackAt=nil,nil;B.phase=(B.underground and"UNDERGROUND DRIVE TO "or"SURFACE DRIVE TO ")..B.stage;local ai=at(B.car)or ar()if ai then local cP,cQ=bQ.x-ai.X,bQ.z-ai.Z;local a4=math.sqrt(cP*cP+cQ*cQ)if a4>0.001 then c4(cP/a4,cQ/a4)end end;local dD=ai and math.sqrt((bQ.x-ai.X)^2+(bQ.z-ai.Z)^2)or-1;a6("AUTO DRIVE ["..B.stage.."] -> "..p(bQ.x)..", "..p(bQ.z).." | "..p(dD).." studs away | "..(B.underground and"teleport hops"or"surface travel").." up to "..p(g4).." studs/s | gameMax="..p(B.gameMaxSpeed or 0).." from "..B.speedSource.." | faceDir="..tostring(t.FaceTravel))ac("AUTO DRIVE "..B.stage.." "..(B.underground and"teleport hops"or"road").." accel="..tostring(t.AccelerationOn).." brake="..p(t.SurfaceBraking).." cap="..p(g4))D(false)return true end;local function g7(g)local g8=tostring(g[1]or"")if g8=="FishingShop"or g8=="FarmShop"or g8=="CleaningShop"then
 if g8=="FishingShop" then B.fishingShopSeq=(B.fishingShopSeq or 0)+1;a6("SHOP: FishingShop catalog received seq="..B.fishingShopSeq) end
 B.catalogSeen=true;B.shopCatalog=B.shopCatalog or {rod={FishingRodRegular=100},bait={WormtecRegular=20}};for a7=2,6 do if type(g[a7])=="table"then for X,f in pairs(g[a7])do if type(f)=="table"then local aX=tostring(f.name or f.Name or f.id or f.Id or X)local g9=a5(f.price or f.Price)if g9 and g9>0 then local bb=aX:lower()local ga={name=aX,price=g9,kind=tostring(f.kind or"")}if bb:find("bait",1,true)or bb:find("worm",1,true)or bb:find("prawn",1,true)or bb:find("lure",1,true)then B.shopCatalog.bait[aX]=g9;if not B.selectedBait and (not B.cheapestBait or g9<B.cheapestBait.price)then B.cheapestBait=ga end elseif bb:find("rod",1,true)then B.shopCatalog.rod[aX]=g9;if not B.selectedRod and (not B.cheapestRod or g9<B.cheapestRod.price)then B.cheapestRod=ga end end end end end end end elseif g8=="FarmFeedback"then
 local msg=tostring(g[2]or"");local lower=msg:lower()
 B.shopFeedback[#B.shopFeedback+1]=msg
 if lower:find("bait unequipped",1,true) then B.observedBaitState="unequipped";B.observedBaitName=nil;B.baitEquipAmbiguous=false;B.baitFeedbackSeq=(B.baitFeedbackSeq or 0)+1;B.baitEquipped=false
 elseif lower:find("equipped bait",1,true) then B.observedBaitState="equipped";B.observedBaitName=msg:match("[Ee]quipped bait:%s*([^%s]+)");B.baitEquipAmbiguous=false;B.baitFeedbackSeq=(B.baitFeedbackSeq or 0)+1;B.baitEquipped=true end
 a6("SHOP FEEDBACK: "..msg)
 end end;local function gb()if B.shopEventsConnected then return true end;local bn=bj()if not bn then return false end;local dp=V(bn,"OnClientEvent")if not dp then return false end;if pcall(function()dp:Connect(function(...)g7(l(...))end)end)then B.shopEventsConnected=true;a6("shop event listener...")end;return B.shopEventsConnected end;local function gc(dw)local aR,ca=nil,nil;ay(x,900,7,function(W)local am=tostring(V(W,"ClassName")or"")if am~="ProximityPrompt"and am~="ClickDetector"then return end;local gd=(Y(W).." "..tostring(V(W,"Name")or"").." "..tostring(V(W,"ActionText")or"").." "..tostring(V(W,"ObjectText")or"")):lower()local bT=false;for aa,as in ipairs(t.ShopHints)do if gd:find(as,1,true)then bT=true;break end end;if not bT then return end;local a4=a3(co(W),dw)or 999;if a4>40 then return end;if not ca or a4<ca then aR,ca=W,a4 end end)return aR,ca end;local function ge()
 if not gb() then a6("SHOP: cannot listen for shop response; refusing to buy");return false end
 local bn=bj();if not bn then a6("SHOP: house remote missing");return false end
 local before=B.fishingShopSeq or 0
 local function opened(waitSeconds)
  local deadline=d()+waitSeconds
  while not B.stop and not B.done and d()<deadline do
   if (B.fishingShopSeq or 0)>before then return true end;k(.1)
  end
  return (B.fishingShopSeq or 0)>before
 end
 local sent=bm(bn,t.OpenAction);a6("SHOP OPEN: "..tostring(t.OpenAction).." sent="..tostring(sent).."; waiting for fresh FishingShop")
 if sent and opened(.45) then return true end
 if B.stop or B.done then return false end
 -- Some maps place the prompt on the register or its ancestors instead of
 -- naming it fishing/bait. Search the actual hardware-store descendants.
 local root=ao();local best,bestDist=nil,math.huge
 if root then
  local ok,objects=pcall(function()
   local store=x:FindFirstChild("HardwareStore",true);return store and store:GetDescendants() or x:GetDescendants()
  end)
  if ok then for _,obj in ipairs(objects)do
   if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
    local path=Y(obj):lower();local place=co(obj);local dist=place and (place-root.Position).Magnitude or math.huge
    if path:find("hardwarestore",1,true) and (path:find("cashregister",1,true) or path:find("cashdrawer",1,true)) and dist<bestDist and dist<=18 and (not obj:IsA("ProximityPrompt") or obj.Enabled) then best,bestDist=obj,dist end
   end
  end end
 end
 if not best then
  local mark=Vector3.new(B.shopTarget.x,B.shopTarget.y,B.shopTarget.z);local candidate=gc(mark);local pos=candidate and co(candidate)
  if candidate and root and pos and (pos-root.Position).Magnitude<=18 then best=candidate;bestDist=(pos-root.Position).Magnitude end
 end
 if (B.fishingShopSeq or 0)>before then return true end
 if best then
  local ok=false;local method="none"
  if best:IsA("ProximityPrompt") and type(fireproximityprompt)=="function" then ok=pcall(function()fireproximityprompt(best,1,true)end);method="fireproximityprompt"
  elseif best:IsA("ClickDetector") and type(fireclickdetector)=="function" then ok=pcall(function()fireclickdetector(best)end);method="fireclickdetector"
  elseif best:IsA("ProximityPrompt") then ok=pcall(function()best:InputHoldBegin();k(math.max(.2,tonumber(best.HoldDuration) or 0));best:InputHoldEnd()end);method="InputHold" end
  a6("SHOP REGISTER: "..Y(best).." distance="..p(bestDist).." method="..method.." sent="..tostring(ok))
  if opened(.6) then return true end
 else a6("SHOP REGISTER: no nearby hardware-store register prompt found") end
 if B.stop or B.done then return false end
 sent=bm(bn,t.OpenAction);a6("SHOP OPEN: one retry after register attempt sent="..tostring(sent))
 if sent and opened(3) then return true end
 a6("SHOP OPEN: no fresh FishingShop response; no purchase sent")
 return false
end;local function gg(Z)return tostring(Z or""):lower():gsub("[%s_%-%./]","")end;local function gh(b6)local bb=gg(b6)local gi=tostring(b6):lower()local gj={}local eL=o(function()return z:FindFirstChild("Backpack")end)or V(z,"Backpack")local ap=V(z,"Character")if eL then gj[#gj+1]=eL end;if ap then gj[#gj+1]=ap end;local aR=nil;for aa,az in ipairs(gj)do ay(az,200,4,function(W)if aR then return end;local aX=gg(V(W,"Name"))local gk=gg(bU(W,"MD_ItemId"))local gl=gg(bU(W,"DisplayName"))if aX~=""and aX:find(bb,1,true)or gk~=""and gk:find(bb,1,true)or gl~=""and gl:find(bb,1,true)or tostring(V(W,"Name")or""):lower():find(gi,1,true)then aR=W end end)if aR then break end end;return aR end;local function findToolIn(gm,gn)if not gm then return nil end;local go=gg(gn)local aJ=nil;ay(gm,250,4,function(W)if aJ then return end;local am=tostring(V(W,"ClassName")or"")if am~="Tool"and am~="HopperBin"then return end;local ab=gg(V(W,"Name"))local gk=gg(bU(W,"MD_ItemId"))if go~=""and(ab~=""and ab:find(go,1,true)or gk~=""and gk:find(go,1,true))or ab:find("rod",1,true)or gk:find("rod",1,true)then aJ=W end end)return aJ end;local function rodInHand()local ap=V(z,"Character")if not ap then return false end;return findToolIn(ap,B.cheapestRod and B.cheapestRod.name or t.RodId)~=nil end;local function gp(eI)local gq=B.cheapestRod and B.cheapestRod.name or t.RodId;if not eI and rodInHand()then B.rodEquipped=true;return true end;local eL=o(function()return z:FindFirstChild("Backpack")end)local ap=V(z,"Character")local aM=aq()local eM=findToolIn(ap,gq)or findToolIn(eL,gq)or findToolIn(eL,t.RodId)or findToolIn(eL,"rod")local gr=eM or gh(gq)if gr and not eM then local gs=tostring(V(gr,"ClassName")or"")if gs=="Tool"or gs=="HopperBin"then eM=gr end end;if t.TryGameRodEquip and gr then local gt=bm(bj(),"EquipFishingRod",gr)a6("ROD game-equip..."..tostring(V(gr,"Name"))..") "..(gt and"[FIRED]"or"[FAILED]"))k(0.25)end;if eM then local gu=false;pcall(function()gu=eM.Parent==eL end)if gu and aM then local gv=pcall(function()aM:EquipTool(eM)end)a6("ROD EquipTool("..tostring(V(eM,"Name"))..") "..(gv and"[OK]"or"[FAILED]"))k(0.2)end end;local gw=tonumber(bU(gr,"MD_HotbarSlot"))or t.RodSlot;pcall(function()local gx=bi()if gx then gx:FireServer(gw)end end)a6("ROD hotbar: "..t.ItemsRemote..":FireServer("..tostring(gw)..")")for gy=1,3 do k(0.25)if rodInHand()then break end;local gz=findToolIn(V(z,"Backpack"),gq)or findToolIn(V(z,"Backpack"),"rod")local gA=aq()if gz and gA then local gB=pcall(function()gA:EquipTool(gz)end)a6("ROD EquipTool retry "..gy.." "..(gB and"[OK]"or"[FAILED]"))end end;B.rodEquipped=rodInHand()a6("ROD IN HAND: "..tostring(B.rodEquipped).." (slot "..tostring(t.RodSlot)..", item "..tostring(gq)..")")return B.rodEquipped end;local function gC()if B.rodEquipped and rodInHand()then return true end;ac("ROD EQUIP slot "..tostring(t.RodSlot))return gp(true)end;local function gD()
 local name=B.cheapestBait and B.cheapestBait.name or t.BaitId
 if B.baitEquipAmbiguous then a6("BAIT EQUIP: unresolved request; check the game before reloading");return false end
 if B.observedBaitState=="equipped" and B.observedBaitName==name then B.baitEquipped=true;return true end
 local item=gh(name) or gh(t.BaitId)
 if not item then a6("BAIT EQUIP: bait not found in backpack");return false end
 for attempt=1,2 do
  if B.stop or B.done then return false end
  local before=B.baitFeedbackSeq or 0;local sent=bm(bj(),t.EquipBaitAction,item)
  a6("BAIT EQUIP request "..attempt.." sent="..tostring(sent));if not sent then return false end
  local deadline=d()+2.5
  while d()<deadline and not B.stop and not B.done and (B.baitFeedbackSeq or 0)==before do k(.1)end
  if (B.baitFeedbackSeq or 0)==before then B.baitEquipAmbiguous=true;a6("BAIT EQUIP: no response; refusing blind toggle");return false end
  if B.observedBaitState=="equipped" then B.baitEquipped=true;a6("BAIT EQUIP confirmed by server");return true end
  if B.observedBaitState~="unequipped" then return false end
  a6("BAIT: server confirmed unequipped; sending one corrective equip")
 end
 return false
end;local function gF(b6,gG)local dn=d()while d()-dn<(gG or 2)do if gh(b6)then return true end;k(0.15)end;return gh(b6)~=nil end;local function gH()local ab=#B.shopFeedback;if ab==0 then return false end;local bq=tostring(B.shopFeedback[ab]):lower()for aa,av in ipairs({"not enough","no money","cannot","can't","cant ","fail","sold out","out of stock","error","limit","already own","already have"})do if bq:find(av,1,true)then return true end end;return false end;local function gI(gJ,gk,gK,g9,gL)if not gk or gk==""then gk=gJ=="ROD"and t.RodId or t.BaitId end;local gM=1;for gN=1,gM do local bn=bj()if not bn then a6("BUY "..gJ.." failed - house remote...")return false end;local gO=(B.selectedRod or B.selectedBait) and gk or (gN>=2 and gL or gk);local gP=bm(bn,t.BuyAction,gO,gK)a6("BUY "..gJ.." ("..tostring(gN).."/"..tostring(gM).."): "..t.BuyAction..", "..tostring(gO)..", "..tostring(gK).." ($"..p(g9)..") "..(gP and"[FIRED]"or"[FAILED]"))ac("BUY "..gJ.." "..tostring(gO).." $"..p(g9))k(math.max(0.35,(t.ShopBuyGap or 1.2)/math.max(1,tonumber(t.BuySpeedMultiplier)or 1)))local ab=#B.shopFeedback;a6("SHOP REPLY ["..gJ.."]: "..(ab>0 and tostring(B.shopFeedback[ab])or"(nothing sent back)"))if gF(gO,1.5)then a6("BUY "..gJ.." CONFIRMED: "..tostring(gO).." is in the backpack")return true end;if gH()then a6("BUY "..gJ.." refused by the shop -...")else a6("BUY "..gJ.." awaiting delayed inventory sync; no duplicate request");if gF(gO,7) then a6("BUY "..gJ.." CONFIRMED on delayed inventory recheck");return true end;a6("BUY "..gJ.." sent but not confirmed; no retry");return false end end;return false end;local function gQ()local boughtRodNow=false;local gR=B.cheapestRod and B.cheapestRod.name or t.RodId;local gS=B.cheapestBait and B.cheapestBait.name or t.BaitId;local gT=B.cheapestRod and B.cheapestRod.price or t.RodPrice;local gU=B.cheapestBait and B.cheapestBait.price or t.BaitPrice;B.baitPrice=gU;a6("CHEAPEST ROD  : "..tostring(gR).." $"..p(gT).." - buying exactly "..tostring(t.RodQty))a6("CHEAPEST BAIT : "..tostring(gS).." $"..p(gU).." - buying exactly "..tostring(tonumber(B.baitQty)or t.BaitQty))if not bj()then a6("BUY KIT failed - house...")return false end;if gh(gR)then a6("ROD already owned - not...")B.rodBought=true else boughtRodNow=true;B.rodBought=gI("ROD",gR,t.RodQty,gT,t.RodId)end;if not B.rodBought then a6("ROD purchase not confirmed; stopping before bait purchase");return false end;if boughtRodNow then local delay=math.max(0.35,(t.ShopBuyGap or 1.2)/math.max(1,tonumber(t.BuySpeedMultiplier)or 1));a6("SHOP: waiting "..p(delay).."s after confirmed rod purchase");k(delay) else a6("SHOP: rod already owned; starting bait purchase immediately")end;local missing=math.max(0,(tonumber(B.baitQty)or t.BaitQty)-(H.baitCount()or 0));if missing==0 then a6("BAIT target already owned")B.baitBought=true else
 B.baitBought=false
 while missing>0 and not B.stop and not B.done do
  local before=H.baitCount();missing=math.max(0,(tonumber(B.baitQty)or t.BaitQty)-before)
  if missing==0 then a6("BAIT: selected target already reached; no purchase sent");break end
  local batch=math.min(5,missing);local remote=bj()
  if not remote then a6("BAIT: shop remote unavailable");break end
  if B.pendingBaitPurchase then
   local pending=B.pendingBaitPurchase
   if before>=pending.before+pending.quantity then
    a6("BAIT: earlier pending purchase now reflected in inventory");B.pendingBaitPurchase=nil
    missing=math.max(0,(tonumber(B.baitQty)or t.BaitQty)-before)
    if missing==0 then break end;batch=math.min(5,missing)
   else a6("BAIT: earlier purchase still unresolved; no duplicate request. Check inventory and cash before reloading");break end
  end
  local cashBefore=H.readCashNumber();local feedbackBefore=#B.shopFeedback
  local sent,err=bm(remote,t.BuyAction,gS,batch)
  a6("BAIT REQUEST: remote="..Y(remote).." action="..tostring(t.BuyAction).." item="..tostring(gS).." qty="..batch.." owned="..before.." cash="..tostring(cashBefore).." sent="..tostring(sent)..(sent and "" or " error="..tostring(err)))
  if not sent then break end
  B.pendingBaitPurchase={before=before,quantity=batch,item=gS,cash=cashBefore}
  local deadline=d()+10;local after=before
  while d()<deadline and not B.stop and not B.done do after=H.baitCount();if after>=before+batch then break end;k(.1)end
  if after<before+batch then
   local cashAfter=H.readCashNumber();local reply=#B.shopFeedback>feedbackBefore and tostring(B.shopFeedback[#B.shopFeedback]) or "none"
   a6("BAIT UNCONFIRMED: item="..tostring(gS).." requested="..batch.." inventory="..before.."->"..after.." cash="..tostring(cashBefore).."->"..tostring(cashAfter).." feedback="..reply.."; no duplicate request")
   break
  end
  B.pendingBaitPurchase=nil
  a6("BAIT purchase confirmed: "..before.." -> "..after);missing=math.max(0,(tonumber(B.baitQty)or t.BaitQty)-after)
  if missing>0 then k(math.max(.35,(t.ShopBuyGap or 1.2)/math.max(1,tonumber(t.BuySpeedMultiplier)or 1)))end
 end
 B.baitBought=missing==0
 end;if B.rodBought and B.baitBought then if not(B.car and aL(B.car))then gp(true);gD()else a6("SHOP: bought while seated")end else a6("SHOP: not equipping until purchase is confirmed")end;B.shopDone=B.rodBought and B.baitBought;a6("SHOP "..(B.shopDone and"DONE"or"INCOMPLETE")..": rod="..tostring(B.rodBought).." bait="..tostring(B.baitBought).." rodInHand="..tostring(rodInHand()).." baitEquipped="..tostring(B.baitEquipped))D(false)return B.shopDone end;local function gV()if B.travelMode=="Teleport" then B.resupply=false;B.autoFishStarted=false;B.autoDrive=nil;return fR(B.fishTarget,"FISH") end;if not B.car then B.car=cb() or c8() end;if not B.car then G("shop -> fishing: owned car not found; refusing to walk to fishing spot")return false end;if not aL(B.car)then a6("SHOP: returning to car before fishing")if not dQ("shop -> fishing")then G("shop -> fishing: could not re-enter car")return false end end;if not aL(B.car)then G("shop -> fishing: seat not confirmed")return false end;B.resupply=false;if B.activeFarmMode~="Underground" then B.underground,B.pinY,B.driveY=false,nil,nil end;B.speed=B.gameMaxSpeed or t.SpeedFallback;B.autoDrive,B.done,B.stop=nil,false,false;B.autoFishStarted=false;a6("SHOP DONE: drive to MARK...")local ok=fR(B.fishTarget,"FISH");if not ok and B.phase~="FAILED" then G("no route: shop to fishing route could not be verified")end;return ok end;local function gW()if B.shopAttempted or B.done or B.stop then return end;B.shopAttempted=true;do local gX=math.ceil(H.moneyNeeded())local gY=H.readCashNumber()or 0;B.cash=gY;if gY<gX then B.shopAttempted=false;H.ensureMoney(gX,"bait for the run")return end end;B.rodBought,B.baitBought,B.baitEquipped=false,false,false;B.phase="SHOP BUY"gb()if B.car and not aL(B.car)and not B.walkedFromAtm then G("shop arrival: driver...")return end;local gZ=B.routeMode=="Above ground"B.phase=gZ and"SHOP: PARK AND GLIDE TO..."or(B.car and"SHOP: BUY WHILE SEATED"or"SHOP: WALK TO PROMPT")local g_=_(B.shopTarget.x,B.shopTarget.y+2,B.shopTarget.z)local dg=gc(g_)local d8=dg and co(dg)or g_;local h0=dg and(tonumber(V(dg,"MaxActivationDistance"))or 10)or 10;local cF;if B.car and gZ then local dd=math.min(180,math.max(20,(a3(ar(),d8)or 30)/math.max(8,t.GlideSpeed)*2.5+18))local cf,cV
if B.cashReadyFootShop and aL(B.car) and not B.walkedFromAtm then
 B.cashReadyFootShop=false;local trail={};B.shopEntryTrail=trail;local capturing=true
 i(function()while capturing and not B.stop and not B.done do
  local pos=ar();if pos and not aL(B.car) and (#trail==0 or (pos-trail[#trail]).Magnitude>=2.5) and #trail<150 then trail[#trail+1]=pos end;k(.12)
 end end)
 local outside,inside=B.door1,B.door2;local start=at(B.car)
 if B.recordedShopFoot then
  a6("SHOP: following recorded on-foot approach from roadside")
  local points={_(-89.24,257,132.50),_(-99.57,255.03,132.49),_(-108.23,255.03,137.45),_(-116.74,255.06,142.31),_(-125.07,255.15,147.07),_(-132.29,255.23,151.20)}
  pcall(function()anchorCar(false)end);cf,cV=dN("shop",points[1],3,dd)
  if cf then B.useDoorWalk=true;for j=2,#points do if B.stop or B.done then cf=false;cV="stopped";break end;cf,cV=cR(points[j],3,15);if not cf then break end end;if cf then cf,cV=cR(_(d8.X,d8.Y+2,d8.Z),4,dd)end;B.useDoorWalk=false end
 elseif outside and inside and start and (outside-d8).Magnitude<65 and (inside-d8).Magnitude<65 and (outside-inside).Magnitude>=2 and (outside-inside).Magnitude<=35 then
  if (inside-start).Magnitude<(outside-start).Magnitude then outside,inside=inside,outside end
  a6("SHOP: walking via marked outside and inside door points")
  pcall(function()anchorCar(false)end);cf,cV=dN("shop door",outside,3,dd)
  if cf then B.useDoorWalk=true;d4(outside);cf,cV=cR(inside,2.5,18);if cf then d4(inside);cf,cV=cR(_(d8.X,d8.Y+2,d8.Z),4,dd)end;B.useDoorWalk=false end
 else
  a6("SHOP: no paired door marks; using normal foot path and recording return")
  pcall(function()anchorCar(false)end);cf,cV=dN("shop",_(d8.X,d8.Y+2,d8.Z),4,dd)
 end
 capturing=false;local last=ar();if last and (#trail==0 or (last-trail[#trail]).Magnitude>1) then trail[#trail+1]=last end
 a6("SHOP: recorded "..#trail.." entry points for reverse return")
elseif aL(B.car)then pcall(function()anchorCar(false)end)cf,cV=dN("shop",_(d8.X,d8.Y+2,d8.Z),4,dd)
else cf,cV=cR(_(d8.X,d8.Y+2,d8.Z),4,dd)end
if not cf then G("shop foot route blocked: "..tostring(cV))return end;cF=a3(ar(),d8)or 1e9 elseif B.car then local aP=cu(B.car)local h1=aP and V(aP,"Position")if not h1 or not aL(B.car)then G("shop: driver not seated;...")return end;local h2=a3(h1,g_)or 1e9;cF=a3(h1,d8)or 1e9;a6("SHOP IN CAR: seat to mark "..p(h2).."; seat to prompt "..p(cF))if h2>15 or cF>h0+0.5 then G("no safe seated parking...")return end else local cf,cV;if B.travelMode=="Teleport" then cf,cV=(a3(ar(),d8)or 999)<=h0,"teleported within shop prompt range" elseif(a3(ar(),d8)or 999)<=4 then cf,cV=true,"already by shop"else cf,cV=cR(_(d8.X,d8.Y+2,d8.Z),4,24)end;if not cf then G("shop walk blocked: "..tostring(cV))return end;cF=a3(ar(),d8)or 1e9;if cF>h0+0.5 then G("shop prompt too far on...")return end end;if not ge()then G("shop open not confirmed: no FishingShop response; no purchase sent")return end;local h3=math.ceil(H.moneyNeeded())local h4=H.readCashNumber()or 0;a6("SHOP CASH GATE after..."..tostring(h3).." wallet $"..tostring(h4))if h4<h3 then B.shopAttempted=false;if B.car and not aL(B.car)then if not(gZ and dQ("shop cash gate"))then G("shop cash gate: cannot...")return end end;H.ensureMoney(h3,"verified cheapest rod + bait")return end;if not gQ()then G("SHOP BUY incomplete: purchase not confirmed; check inventory and cash before restarting")return end;k(t.ReturnWait)if B.car and not aL(B.car)then if not(gZ and dQ("shop"))then G("shop: cannot return to...")return end end;gV()end;local function h5()local h6={}ay(y,400,6,function(W)local am=tostring(V(W,"ClassName")or"")if am=="RemoteEvent"or am=="RemoteFunction"then local aX=tostring(V(W,"Name")or"")if aX:lower():find("fish",1,true)then h6[#h6+1]=aX end end end)local h7,al={},{}for aa,ab in ipairs(h6)do if not al[ab]then al[ab]=true;h7[#h7+1]=ab end end;a6("FISH REMOTES FOUND: "..(#h7>0 and table.concat(h7,", ")or"NONE - is a rod equipped?"))return h7 end;anchorCar=function(eP)
 if not t.AnchorWhenParked or not B.car then return false end
 local ok,list=pcall(function()return B.car:GetDescendants()end);if not ok then return false end;local changed=0;local failures=0
 for _,part in ipairs(list)do if part:IsA("BasePart")then local success=pcall(function()part.Anchored=eP end);if success then changed=changed+1 else failures=failures+1 end end end
 a6("ANCHOR "..(eP and "ON" or "OFF").." car parts="..changed.." errors="..failures);return changed>0 and failures==0
end;local function h8()local eM=findToolIn(V(z,"Character"),"rod")or findToolIn(V(z,"Backpack"),"rod")if not eM then return nil,nil end;local eE,eF;local b0=o(function()return eM:GetAttributes()end)if type(b0)=="table"then for X,f in pairs(b0)do local eG=tostring(X):lower()if type(f)=="number"then if eG:find("max",1,true)and(eG:find("ammo",1,true)or eG:find("bait",1,true))then eF=f elseif eG:find("ammo",1,true)or eG:find("bait",1,true)or eG=="count"then eE=f end end end end;ay(eM,80,3,function(W)local aK=tostring(V(W,"ClassName")or"")if aK~="IntValue"and aK~="NumberValue"and aK~="StringValue"then return end;local ab=tostring(V(W,"Name")or""):lower()local f=tonumber(V(W,"Value"))if f then if ab:find("max",1,true)then eF=f elseif ab:find("ammo",1,true)or ab:find("bait",1,true)or ab:find("count",1,true)then eE=f end end end)return eE,eF end;local function h9(ha)local eE,eF=h8()if not eE then a6("ROD AMMO ["..ha.."]: cannot read it (rod...")return nil end;a6("ROD AMMO ["..ha.."]: "..p(eE).."/"..p(eF or 0)..((eE or 0)<=0 and"  <-- NO BAIT LOADED,..."or""))return eE end;equipBaitRoutes=function()local gq=B.cheapestBait and B.cheapestBait.name or t.BaitId;local gr=gh(gq)or gh(t.BaitId)if not gr then a6("BAIT EQUIP: no "..tostring(gq).." in the backpack to equip")return false end;local hb={{"MD_HouseRentalRemote",t.EquipBaitAction,"item"},{"MD_ItemsEvent","EquipBait","item"},{"MD_ItemsEvent","EquipFishingBait","item"},{"MD_ItemsEvent",tonumber(bU(gr,"MD_HotbarSlot"))or 2,"num"}}for a7,bh in ipairs(hb)do local bn=be(bh[1],{})if bn then local q;if bh[3]=="item"then q=bm(bn,bh[2],gr)elseif bh[3]=="num"then q=type(bh[2])=="number"and bm(bn,bh[2])or false else q=bm(bn,bh[2],bh[3])end;a6("BAIT EQUIP route "..a7 ..": "..bh[1]..":"..tostring(bh[2]).." "..(q and"[FIRED]"or"[FAILED]"))k(0.4)local eE=h8()if eE and eE>0 then a6("BAIT EQUIP OK - rod now..."..p(eE).." bait")B.baitEquipped=true;return true end end end;local eE=h9("after bait equip")B.baitEquipped=eE and eE>0 or B.baitEquipped;return B.baitEquipped end;local function hc(hd)k(t.BiteWatchdog)if B.autoFish and not B.stop and hd==B.castToken and B.castActive and (not B.lastBiteAt or d()-B.lastBiteAt>=t.BiteWatchdog) then a6("CAST waiting for a bite; no duplicate cast sent") end end;local function he()if B.fishConnected then return true end;local bn=bk()if not bn then a6("MD_FishingRemote not found")return false end;local dp=V(bn,"OnClientEvent")if not dp then a6("MD_FishingRemote.OnClient...")return false end;if pcall(function()dp:Connect(function(...)local q,ci=pcall(J,l(...))if not q then a6("FISH EVENT ERROR: "..tostring(ci))end end)end)then B.fishConnected=true;a6("Connected...")end;return B.fishConnected end;local function hf(cV)if not t.AutoRecast or not B.autoFish or B.stop or B.recastPending then return end;if B.castInProgress then a6("CAST END observed during attempt; retry handled by cast controller")return end;if B.pendingInstaSell and not B.resupply then local selected=B.pendingInstaSell;B.pendingInstaSell=nil;B.instaSellTrip=true;H.startResupply("selected fish: "..selected);return end;if (B.unsold or 0)>=(B.sellAt or 10) and not B.resupply then a6("SELL LIMIT: "..tostring(B.unsold).."/"..tostring(B.sellAt or 10).." confirmed catches; returning to sell");H.startResupply("fish catch limit reached");return end;if not B.resupply then local hg=H.baitCount();local ammo=h8();B.baitLeft=hg
 if hg<=0 and (ammo==nil or ammo<=0) then a6("OUT OF BAIT: sell held fish regardless of catch limit, then restock");H.startResupply("no bait left");return end
 end
 local cashNow=H.readCashNumber();local threshold=tonumber(B.autoDepositThreshold) or 10000
 if cashNow and cashNow>=threshold and not B.depositOnly then
  B.depositOnly=true;B.autoFish=false;B.busy=true;B.castActive=false;B.castToken=(B.castToken or 0)+1
  task.spawn(function()
   local atm=(H.scanAtms()or{})[1];if not atm then B.depositOnly=false;G("auto deposit: no marked ATM")return end
   B.atmTarget=atm;B.atmStageTarget=H.atmDriveTarget(atm);a6("AUTO DEPOSIT: wallet="..cashNow.." threshold="..threshold)
   if not fR(B.atmStageTarget,"ATM") then B.depositOnly=false;G("auto deposit: ATM travel failed")end
  end);return
 end
 B.recastPending=true;local caught=tostring(B.lastCastOutcome or ""):lower():find("caught",1,true)~=nil;i(function()k(caught and 1.25 or math.max(5,tonumber(t.RecastWait)or 1))B.recastPending=false;if B.autoFish and not B.stop then a6("RECAST after "..tostring(cV));local ok=castOnce();if not ok and B.autoFish and not B.done then G("cast stopped: "..tostring(B.castFailureReason or "not acknowledged"))end end end)end;J=function(g)local g8=tostring(g[1]or"")B.fishEventCount=(B.fishEventCount or 0)+1;B.lastFishEventAt=d()if g8=="Cast"or g8=="Wait"or g8=="Bite"then B.castAcceptedAt=d()B.castActive=true end;if g8~="Bite"then a6("FISH EVENT: "..g8 .." (event #"..tostring(B.fishEventCount)..")")end;if g8=="Bite"then B.castFailures=0;local a4=g[2]if type(a4)~="table"then return end;local dw=e(tonumber(a4.center)or 0.5,0,1)local hh=tonumber(a4.period)or 1.65;if hh<=0 then hh=1.65 end;local cE=tonumber(a4.start)or H.serverNow()local hi=tonumber(a4.hits)or 0;local hj=tonumber(a4.required)or 3;local b5=tostring(B.castToken)..":"..tostring(a4.round)..":"..tostring(cE)..":"..tostring(hi)..":"..tostring(dw)if B.lastBiteKey==b5 then return end;B.lastBiteKey=b5;B.lastBiteAt=d()B.bites=B.bites+1;if hi>=hj then a6("BITE ignored - required...")return end;local round=tonumber(a4.round)or 1;local now=H.serverNow();local cycle=math.max(0,math.floor((now-cE)/hh));local target=cE+(cycle+dw)*hh;if target<now+0.04 then target=target+hh end;local delay=e(target-now,0.04,hh+0.1)
 B.reelPending=B.reelPending or {};local key=tostring(round)..":"..tostring(hi)..":"..tostring(cE)
 if B.reelPending[key] then return end;B.reelPending[key]=true
 a6("BITE hits="..hi.."/"..hj.." round="..round.." -> reel in "..p(delay).."s")
 i(function()k(delay);B.reelPending[key]=nil;if not B.autoFish or B.stop then return end
  local at=H.serverNow();local sent=bm(bk(),"Reel",{at=at,round=round})
  if sent then B.reels=B.reels+1;B.lastReelAt=d();a6("AUTO REEL sent round="..round.." at="..p(at).."; waiting for next Bite") else a6("AUTO REEL send failed")end
 end)
 elseif g8=="End"then
 B.castActive=false;local message=tostring(g[2]or"");local lower=message:lower();B.castEndSeq=(B.castEndSeq or 0)+1;B.lastCastOutcome=message
 if lower:find("caught",1,true) then if B.unsoldCharacter~=z.Character then B.unsold=0;B.unsoldCharacter=z.Character end;B.unsold=(B.unsold or 0)+1;B.caught=B.caught+1;B.castFailures=0;ac("CAUGHT "..message)
 B.catchHistory=B.catchHistory or {};table.insert(B.catchHistory,1,message);if #B.catchHistory>100 then table.remove(B.catchHistory)end
 if B.catchHistoryWidget then pcall(function()B.catchHistoryWidget:SetDesc(message)end)end
 local species=message:match("^[Cc]aught%s+(.+)%s+%[") or message:match("^[Cc]aught%s+(.+)%s+[%d%.]+%s*kg")
 species=species and species:lower():gsub("^%s+",""):gsub("%s+$","") or nil
 if species and B.instaFish and B.instaFish[species] then B.pendingInstaSell=species;a6("INSTA SELL: selected "..species.." caught; heading to seller") end
 elseif lower:find("cancel",1,true) then B.castFailures=(B.castFailures or 0)+1;ac("CAST CANCELLED "..message)
 else B.castFailures=0;ac("FISH END "..message) end
 a6("FISH END: "..message.."; consecutive cancellations="..tostring(B.castFailures or 0));D(false)
 if (lower:find("buy bait",1,true) or lower:find("out of bait",1,true) or lower:find("no bait",1,true) or lower:find("not enough bait",1,true)) and not B.castInProgress then
  a6("BAIT: server confirmed empty; selling held fish regardless of slider")
  task.spawn(function()if B.autoFish and not B.stop and not B.done then H.startResupply("server confirmed out of bait")end end);return
 end
 if (B.castFailures or 0)>=2 and not B.castInProgress then G("two casts cancelled by game; stopped to preserve bait");return end
 hf("End")
elseif g8=="Cast"or g8=="Wait"or g8=="Cancel"then if g8=="Cast"then B.castActive=true end;if g8=="Cancel"then B.castActive=false end;a6("FISH EVENT "..g8)end end;local function hl()B.fishAim=nil;local dj=V(x,"CurrentCamera")if dj then pcall(function()dj.CameraType=Enum.CameraType.Custom end)end end;H.atmDriveTarget=function(hm)local cP,cQ=hm.fx-hm.x,hm.fz-hm.z;local f2=math.sqrt(cP*cP+cQ*cQ)if f2<0.5 then return nil end;if type(H.planAtmPark)=="function"then local a1=hm.y-2.3;local hn=B.shopTarget;if hn and math.sqrt((hn.x-hm.x)^2+(hn.z-hm.z)^2)<120 and math.abs(hn.y+t.SurfaceLift-a1)<8 then a1=hn.y+t.SurfaceLift end;local f9,reason=H.planAtmPark(hm,cP/f2,cQ/f2,a1)if f9 then a6("ATM PLAN: checked parking x="..p(f9.x).." y="..p(f9.y).." z="..p(f9.z));return{x=f9.x,y=f9.y,z=f9.z,atmPark=true,hx=f9.hx,hz=f9.hz,stand=f9.stand,seatDist=f9.seatDist}end;a6("ATM PLAN: checked parking unavailable: "..tostring(reason).."; trying existing fallback")end;return{x=hm.x+cP/f2*30,y=hm.y,z=hm.z+cQ/f2*30}end;H.validateTargets=function()a6("ROUTE LOCK: shop "..p(B.shopTarget.x)..", "..p(B.shopTarget.z).." | MARK 1 "..p(B.fishTarget.x)..", "..p(B.fishTarget.z))return false end;H.watchMoney=function()local gY,bw=H.readCash()B.cash,B.cashSource=gY,bw;return gY end;H.ensureMoney=function(gX,cV)local gY=H.readCashNumber()or 0;B.cash=gY;if gY>=(gX or 0)then return true end;a6("MONEY GATE: cash $"..tostring(gY).." < needed $"..tostring(gX).." ("..tostring(cV)..") - pulling it out of...")local hm=(H.scanAtms()or{})[1]if not hm then a6("MONEY GATE: no ATM found...")return false end;B.atmTarget=hm;B.atmStageTarget=H.atmDriveTarget(hm)B.pendingShop=true;fR(B.atmStageTarget,"ATM")return false end;H.readCash=function()local ho=V(z,"leaderstats")if ho then for aa,ab in ipairs({"Cash","Money","Coins","Dollars","$"})do local f=V(ho,ab)local a5=f and tonumber(V(f,"Value"))if a5 then return a5,"leaderstats."..ab end end end;for aa,ab in ipairs({"Cash","Money","Coins","CashValue","Balance"})do local q,g=pcall(function()return z:GetAttribute(ab)end)if q and tonumber(g)then return tonumber(g),"attribute "..ab end end;if B.cash then return tonumber(B.cash),"last ATM balance"end;return nil,"unknown"end;H.readCashNumber=function()local hp=H.readCash()return tonumber(hp)end;H.fishOnMe=function()if B.unsoldCharacter~=z.Character then if (B.unsold or 0)>0 then a6("FISH LEDGER: character changed; cleared prior-life catch count")end;B.unsold=0;B.unsoldCharacter=z.Character end;local hum=aq();if hum and hum.Health<=0 then B.unsold=0 end;local ab=0;for aa,gm in ipairs({V(z,"Backpack"),V(z,"Character")})do if gm then pcall(function()for aa,W in ipairs(gm:GetChildren())do local g8=tostring(bU(W,"MD_FarmKind")or"")local aX=tostring(V(W,"Name")or""):lower()if W:IsA("Tool") and (g8=="fish" or ((aX:find("fish") and not aX:find("fishing")) or aX:find("bass") or aX:find("salmon") or aX:find("carp"))) then if not aX:find("rod") and not aX:find("bait") then ab=ab+1 end end end end)end end;return math.max(ab,B.unsold or 0)end;H.moneyNeeded=function()local gK=math.max(0,(tonumber(B.baitQty)or t.BaitQty)-(H.baitCount()or 0));local g9=tonumber(B.baitPrice)or B.cheapestBait and B.cheapestBait.price or t.BaitPrice;local gX=gK*g9;if not gh(B.cheapestRod and B.cheapestRod.name or t.RodId)then gX=gX+(B.cheapestRod and B.cheapestRod.price or t.RodPrice)end;return gX end;H.goShopOrFish=function(cV)
 if B.depositAfterSell then
  local hm=(H.scanAtms()or{})[1]
  if not hm then G("sale confirmed but marked ATM unavailable; deposit still pending");return false end
  B.atmTarget=hm;B.atmStageTarget=H.atmDriveTarget(hm);a6("RECOVERY: confirmed sale deposit still pending; resume ATM first")
  return fR(B.atmStageTarget,"ATM")
 end
 local gX=H.moneyNeeded()local hg=H.baitCount()local gY,bw=H.readCash()
 -- On Auto Farm start, sell fish already held before buying or fishing.
 -- A confirmed sale with a pending deposit above still takes priority.
 local heldFish=H.fishOnMe()
 if heldFish>0 then
  a6("SMART: already holding "..heldFish.." fish; selling first before Auto Farm")
  B.sellTarget=B.sellTarget or H.findSellPoint()
  if not B.sellTarget then G("held fish: no marked sell location; no sale sent");return false end
  return fR(B.sellTarget,"SELL")
 end
 if B.selectedRod or B.selectedBait then local bank=tonumber(z:GetAttribute("MD_Bank")) or tonumber(B.bank);if bank and tonumber(gY) and gY+bank<gX then if B.notifyNotEnough then B.notifyNotEnough()end;G("Not enough money! Need $"..p(gX).."; wallet + bank $"..p(gY+bank));return false end end;a6("SMART ("..tostring(cV).."): bait in bag="..tostring(hg)..", cash="..tostring(gY).." ("..tostring(bw).."), need=$"..tostring(gX))local gn=tonumber(B.baitQty)or t.BaitQty;local hq=gh(B.cheapestRod and B.cheapestRod.name or t.RodId)~=nil;if hg>=gn and hq then a6("SMART: holding "..tostring(hg).." bait + a rod - straight...")B.shopDone,B.rodBought,B.baitBought=true,true,true;return fR(B.fishTarget,"FISH")end;a6("SMART: bait "..tostring(hg).."/"..tostring(gn).." rod="..tostring(hq).." - shop leg first")if(not gY or gY<gX)and (H.fishOnMe()<=0 or (tonumber(z:GetAttribute("MD_Bank")) or tonumber(B.bank) or 0)>=gX) then local hr=(H.scanAtms()or{})[1]if hr then a6("SMART: cash $"..tostring(gY).." < $"..tostring(gX).." - ATM first ("..tostring(hr.name).."), then the shop")B.atmTarget=hr;B.atmStageTarget=H.atmDriveTarget(hr)B.pendingShop=true;return fR(B.atmStageTarget,"ATM")end end;if gY and gY>=gX then B.cashReadyFootShop=true;a6("SMART: enough cash; park outside and walk through the shop door")return fR(B.shopTarget,"SHOP")end;if H.fishOnMe()>0 then a6("SMART: not enough cash..."..tostring(H.fishOnMe())..") - selling first, then...")B.sellTarget=B.sellTarget or H.findSellPoint()if B.sellTarget then return fR(B.sellTarget,"SELL")end end;local hm=(H.scanAtms()or{})[1]if hm then a6("SMART: no cash and..."..tostring(hm.name)..") to pull bait money")B.atmTarget=hm;B.atmStageTarget=H.atmDriveTarget(hm)return fR(B.atmStageTarget,"ATM")end;a6("SMART: no cash, no fish,...")return fR(B.shopTarget,"SHOP")end;H.serverNow=function()local q,m=pcall(function()return x:GetServerTimeNow()end)if q and type(m)=="number"then return m end;return d()end;H.findCastButton=function()local ck=V(z,"PlayerGui")if not ck then return nil end;local q,hs=pcall(function()return ck:GetDescendants()end)if not q or type(hs)~="table"then return nil end;for aa,W in ipairs(hs)do if tostring(V(W,"Name")or"")=="FishingCastButton"then return W end end;for aa,W in ipairs(hs)do local am=tostring(V(W,"ClassName")or"")if am:find("Button")and tostring(V(W,"Text")or""):upper()=="CAST"then return W end end;return nil end;local function ht()local m=findToolIn(V(z,"Character"),"rod")or findToolIn(V(z,"Backpack"),"rod")local a4=m and tonumber(bU(m,"MaxDistance"))return a4 or t.RodMaxDistance or 60 end;local function hu(g,h)if not g or not h then return nil end;local bG,bI=g.X or g.x or 0,g.Z or g.z or 0;local ee,ef=h.X or h.x or 0,h.Z or h.z or 0;return math.sqrt((bG-ee)^2+(bI-ef)^2)end;-- Experimental client-side sky staging. All placements are validated for correction.
B.skyAscend=function()
 if not B.car or not aL(B.car) or not B.castTarget then return false,"missing seated car or cast mark" end
 local pos=at(B.car);local cf=ax(B.car);if not pos or not cf then return false,"car position unavailable" end
 local bbox,size=B.car:GetBoundingBox();local m=B.castTarget;local range=ht()
 local bottomOffset=pos.Y-(bbox.Position.Y-size.Y/2)
 -- Reserve extra space for the camera origin and server tolerance; 60 is cast range, not a guaranteed platform altitude.
 local topY=m.y+math.min(145,range-24)+bottomOffset
 if topY<=pos.Y+3 then return false,"rod range leaves no room for sky platform" end
 local folder=Instance.new("Folder");folder.Name="AutoFishSkyLayers";folder.Parent=x
 B.skyState={folder=folder,start=pos,topY=topY,look=cf.LookVector,parts={},waterX=m.x,waterZ=m.z}
 pcall(function()anchorCar(false)end)
 for layer=1,3 do
  local y=pos.Y+(topY-pos.Y)*layer/3
  local floor=Instance.new("Part");floor.Name="SkyLayer"..layer;floor.Anchored=true;floor.CanCollide=true;floor.CanQuery=false;floor.Transparency=1;floor.Color=Color3.fromRGB(90,175,255);floor.Size=Vector3.new(math.max(size.X,4),1,math.max(size.Z,4));floor.CFrame=CFrame.new(m.x,y-bottomOffset-.5,m.z)*cf.Rotation;floor.Parent=folder
  local ok,why=eT(m.x,m.z,y,cf.LookVector.X,cf.LookVector.Z)
  if not ok then return false,"sky layer "..layer.." rejected: "..tostring(why) end
  a6("SKY layer "..layer.."/3 reached at Y="..p(y))
 end
 -- Keep the car fixed at the top and allow the avatar to stand in its footprint.
 local state=B.skyState
 for _,part in ipairs(B.car:GetDescendants()) do if part:IsA("BasePart") then state.parts[part]=part.CanCollide end end
 local exclusions=Instance.new("Folder");exclusions.Name="SkyCharacterCarNoCollision";exclusions.Parent=folder
 for _,body in ipairs(z.Character:GetDescendants()) do if body:IsA("BasePart") then
  for part in pairs(state.parts) do if part.CanCollide then local nc=Instance.new("NoCollisionConstraint");nc.Part0=body;nc.Part1=part;nc.Parent=exclusions end end
 end end
 pcall(function()anchorCar(true)end)
 local hum,root=aq(),ao();if not hum or not root then return false,"character missing at sky platform" end
 pcall(function()hum.Sit=false;hum.Jump=true;hum:ChangeState(Enum.HumanoidStateType.GettingUp)end)
 k(.5);if aL(B.car) then return false,"could not exit car on sky platform" end
 local topFloor=folder:FindFirstChild("SkyLayer3");if not topFloor then return false,"top floor missing" end
 root.CFrame=CFrame.new(topFloor.Position+Vector3.new(0,3.5,0));root.AssemblyLinearVelocity=Vector3.zero
 k(.4);local actual=ar();local target=Vector3.new(m.x,m.y,m.z);a6("SKY: water="..tostring(target).." avatar="..tostring(actual).." 3D distance="..p(actual and (actual-target).Magnitude or -1).." rod max="..p(range).."; client observation only")
 return true
end
B.skyDescend=function()
 local state=B.skyState;if not state then return true end
 if B.skyCameraStop then B.skyCameraStop() end
 local current=at(B.car)
 if current and aL(B.car) and (current-state.start).Magnitude<=4 then
  for part,value in pairs(state.parts) do pcall(function()if part.Parent then part.CanCollide=value end end)end
  if state.folder then state.folder:Destroy() end;B.skyState=nil;pcall(function()anchorCar(false)end);a6("SKY: already at verified landing; stale state cleared");return true
 end
 local seat=cu(B.car);local hum=aq();if not seat or not hum then return false,"sky return: seat unavailable" end
 if not aL(B.car) then for attempt=1,4 do pcall(function()seat:Sit(hum)end);k(.35);if aL(B.car) then break end end end
 if not aL(B.car) then return false,"sky return: could not re-enter car; platforms retained" end
 pcall(function()anchorCar(true)end)
 for layer=2,0,-1 do
  local y=state.start.Y+(state.topY-state.start.Y)*layer/3
  local sx,sz=layer==0 and state.start.X or state.waterX,layer==0 and state.start.Z or state.waterZ;local ok,why=eT(sx,sz,y,state.look.X,state.look.Z)
  if not ok then return false,"sky return layer "..layer.." rejected: "..tostring(why) end
 end
 for part,value in pairs(state.parts) do pcall(function()if part.Parent then part.CanCollide=value end end)end
 state.folder:Destroy();B.skyState=nil;pcall(function()anchorCar(false)end);a6("SKY: returned car to ground")
 return true
end
function castOnce()
 if B.castInProgress or B.castActive then B.castFailureReason="cast already active";a6("CAST: already active; no duplicate sent");return false end
 if not B.shopDone or aL(B.car) or B.underground then B.castFailureReason="missing supplies or player is seated";return false end
 local mark=B.castTarget;if not mark then B.castFailureReason="water mark missing";return false end
 if not rodInHand() and not gp(true) then B.castFailureReason="rod not equipped";return false end
 if h8()==0 then
  if H.baitCount()<=0 then a6("OUT OF BAIT: selling held fish before restocking");task.spawn(function()if not B.stop and not B.done then H.startResupply("no bait left")end end);return true end
  if not gD() then B.castFailureReason="bait equip not confirmed";return false end
 end
 local target;if B.closestWater then target=B.closestWater()else target=Vector3.new(mark.x,mark.y,mark.z)end
 if not target then B.castFailureReason="no water detected near selected fishing spot";return false end
 local position=ar();local range=ht();local distance=position and (position-target).Magnitude
 a6("CAST target="..tostring(target).." distance="..p(distance or -1).." rod max="..p(range))
 if not distance or distance>range-1 then B.castFailureReason="target exceeds rod range";return false end
 if B.skyCameraStart then B.skyCameraStart(target);k(.15) end
 B.castInProgress=true;B.castFailureReason=nil
 for attempt=1,2 do
  if B.stop or B.done or not B.autoFish then break end
  if (B.castFailures or 0)>=2 then B.castFailureReason="two casts cancelled by game; preserving bait";break end
  local button=H.findCastButton();local label=button and button:IsA("TextButton") and tostring(button.Text):upper():match("^%s*(.-)%s*$")
  if not button or label~="CAST" then B.castFailureReason="cast button is not ready (text="..tostring(label)..")";a6("CAST: "..B.castFailureReason);break end
  B.castToken=(B.castToken or 0)+1;local token=B.castToken;local endBefore=B.castEndSeq or 0;B.castAcceptedAt=nil;B.castActive=false;B.phase="CASTING AT WATER"
  if B.inspectCastAim then pcall(B.inspectCastAim,target) end;local sent,why=B.pressGameButton(button);a6("CAST: single button activation attempt "..attempt.." sent="..tostring(sent).." "..tostring(why))
  if not sent then B.castFailureReason="button activation failed: "..tostring(why);break end
  B.casts=B.casts+1
  local deadline=d()+10
  while not B.stop and not B.done and not B.castAcceptedAt and (B.castEndSeq or 0)==endBefore and d()<deadline do k(.1) end
  if B.castAcceptedAt and (B.castEndSeq or 0)==endBefore then
   local settle=d()+.8;while not B.stop and not B.done and (B.castEndSeq or 0)==endBefore and d()<settle do k(.05)end
   if (B.castEndSeq or 0)==endBefore then B.castInProgress=false;B.lastBiteAt=d();a6("CAST accepted and still active; waiting for bite");i(function()pcall(hc,token)end);return true end
  end
  local ended=(B.castEndSeq or 0)~=endBefore
  if ended and tostring(B.lastCastOutcome or ""):lower():find("caught",1,true) then
   B.castInProgress=false;B.castActive=false;a6("CAST: quick catch confirmed; continuing to sell/recast")
   task.defer(function()if B.autoFish and not B.stop and not B.done then hf("quick catch")end end)
   return true
  end
  B.castFailureReason=ended and ("game ended cast: "..tostring(B.lastCastOutcome)) or "no cast acknowledgement"
  a6("CAST attempt "..attempt.." failed: "..B.castFailureReason)
  local outcome=tostring(B.lastCastOutcome or ""):lower()
  if ended and outcome:find("fishing level",1,true) and outcome:find("required",1,true) then
   B.castFailureReason="fishing level requirement: "..tostring(B.lastCastOutcome).."; choose another fishing spot"
   a6("CAST: server rejected this water's level requirement; no retry")
   break
  end
  if ended and (outcome:find("buy bait",1,true) or outcome:find("out of bait",1,true) or outcome:find("no bait",1,true) or outcome:find("not enough bait",1,true)) then
   B.castInProgress=false;B.castActive=false;B.baitLeft=0;B.resupply=false
   a6("BAIT: server confirmed empty; starting sell/resupply instead of recasting")
   task.spawn(function()if not B.stop and not B.done then H.startResupply("server confirmed out of bait")end end)
   return true
  end
  if attempt<2 and not B.stop and not B.done and (B.castFailures or 0)<2 then
   a6("CAST: waiting 5 seconds before one retry; no cancel or duplicate sent")
   local waitUntil=d()+5;while not B.stop and not B.done and d()<waitUntil do k(.1)end
  end
 end
 B.castInProgress=false;return false
end;local function hx()if B.autoFish then return true end;if not B.shopDone then G("shop stage not completed")return false end;if B.car and not aL(B.car) and not B.inUnderFish then G("not in driver seat")return false end;he()B.autoFish,B.stop,B.busy=true,false,false;B.autoDrive,B.speed=nil,0;B.stage="FISHING"B.phase="FISHING - STAYING STILL"B.castFailures=0;B.castEndSeq=0;B.castInProgress=false;eK()B.castActive,B.castToken,B.lastBiteKey=false,0,nil;if B.selectedRod then B.rodEquipped=false;gC();if not findToolIn(z.Character,B.selectedRod.name)then G("selected rod not equipped; refusing wrong altitude");return false end end;if B.car and B.activeFarmMode~="Underground" then local ok,why=B.skyAscend();if not ok then G("SKY setup: "..tostring(why));return false end
 elseif B.car and B.activeFarmMode=="Underground" then
  if not B.inUnderFish or aL(B.car) then G("underground marked fishing spot not reached on foot");return false end
  a6("UNDERGROUND FISH: on foot at marked game floor; using normal water camera and cast button")
 end;if not B.rodEquipped then gC()end;ac("AUTO FISH started; "..tostring(B.activeFarmMode).." casting")D(false)k(0.1)h9("before first cast");if not B.baitEquipped and not gD() then G("bait equip not confirmed; check bait before retrying");return false end;if not castOnce()then G("cast stopped: "..tostring(B.castFailureReason or "not confirmed"))return false end;return true end;F=function()pcall(eR)pcall(function()anchorCar(B.underground==true)end)B.parked=false;B.autoFish,B.castActive,B.recastPending=false,false,false;B.autoFishStarted=false;B.stage="STOPPED"B.phase="STOPPED"bm(bk(),"Cancel")a6("AUTO FISH stopped -...")ac("AUTO FISH stopped")D(true)end;H.atmRemote=function()local q,bh=pcall(function()return y:FindFirstChild("MD_ATMRemote")end)if q then return bh end;return nil end;H.objPos=function(W)local q,ai=pcall(function()local am=W.ClassName;if am=="Part"or am=="MeshPart"or am=="UnionOperation"or am=="WedgePart"then return W.Position end;if W.PrimaryPart then return W.PrimaryPart.Position end;local hF=W:FindFirstChildWhichIsA("BasePart")if hF then return hF.Position end;local aw=W:FindFirstChild("HumanoidRootPart")if aw then return aw.Position end;return nil end)if q then return ai end;return nil end;H.objLook=function(W)local q,hG=pcall(function()local d7=nil;if W.ClassName~="Model"then d7=W else d7=W.PrimaryPart or W:FindFirstChildWhichIsA("BasePart")end;if not d7 then return nil end;local ah=d7.CFrame;local fw=ah.LookVector;local a_=d7.Size;local dy=math.max(a_.X,a_.Z)*0.5;return{pos=d7.Position,look=Vector3.new(fw.X,0,fw.Z).Unit,len=dy}end)if q then return hG end;return nil end;B.saveSellerMark=function(which)
 local pos=ar();if not pos or (B.car and aL(B.car)) then a6("SELL MARK: stand on foot at the location first");return end
 local files={road="auto_fish_sell_road.txt",door="auto_fish_sell_door.txt",inside="auto_fish_sell_inside.txt"};local file=files[which];if not file then return end
 B.sellerMarks=B.sellerMarks or {};B.sellerMarks[which]=pos;B.sellTarget=nil
 local saved=br(file,string.format("%.6f, %.6f, %.6f",pos.X,pos.Y,pos.Z));a6("SELL MARK "..which.." = "..tostring(pos).." persisted="..tostring(saved))
end
H.findSellPoint=function()
 local trail={Vector3.new(-308.06,258.91,430.51),Vector3.new(-300.08,255.03,429.03),Vector3.new(-293.63,259.51,426.88),Vector3.new(-283.28,259.15,427.19),Vector3.new(-277.05,256.04,424.46),Vector3.new(-269.59,256.04,417.80),Vector3.new(-261.18,256.04,410.27),Vector3.new(-253.71,256.04,403.61),Vector3.new(-247.92,256.04,395.89),Vector3.new(-245.13,256.04,386.60),Vector3.new(-248.53,256.28,382.70)}
 B.sellerTrail=trail;B.sellerMarks={road=Vector3.new(-315.42,254.32,423.86),door=trail[#trail-1],inside=trail[#trail]}
 local point=trail[#trail];a6("SELL RECORDED: ground-level stop "..tostring(point).." road parking="..tostring(B.sellerMarks.road).."; replaying user path")
 return {x=point.X,y=point.Y,z=point.Z,tag="recorded seller",marked=true}
end;H.atmSpot=function(W)local hI=H.objLook(W)if not hI then return nil end;local ai,fw,dy=hI.pos,hI.look,hI.len;pcall(function()local dg=W:FindFirstChildWhichIsA("ProximityPrompt",true)if dg and tostring(V(dg,"ActionText")or""):lower():find("atm")then local hJ=dg.Parent;if hJ and hJ:IsA("BasePart")then ai=hJ.Position;local dX=hJ.CFrame.LookVector;fw=Vector3.new(dX.X,0,dX.Z).Unit end end end)if not dy or dy<1 or dy>40 then dy=4 end;if fw.Magnitude<0.5 then fw=Vector3.new(0,0,1)end;local hK=Vector3.new(ai.X+fw.X*5,ai.Y,ai.Z+fw.Z*5)return{x=ai.X,y=ai.Y,z=ai.Z,fx=hK.X,fz=hK.Z,look={x=fw.X,z=fw.Z},name=tostring(V(W,"Name")),object=W}end;H.resolveMarkedAtm=function(hL)local aR,hM;local al={}local function b8(W)if not W or al[W]then return end;al[W]=true;if tostring(V(W,"ClassName")or"")~="Model"or tostring(V(W,"Name")or""):lower()~="atm"then return end;local g_=H.atmSpot(W)if not g_ then return end;local a4=math.sqrt((g_.x-hL.x)^2+(g_.z-hL.z)^2)if a4<=22 and math.abs(g_.y-hL.y)<=30 and(not hM or a4<hM)then aR,hM=W,a4 end end;local q,aU=pcall(function()return x:GetPartBoundsInRadius(Vector3.new(hL.x,hL.y,hL.z),32)end)if q and type(aU)=="table"then for aa,d7 in ipairs(aU)do local aQ=d7;for aa=1,7 do if not aQ then break end;if tostring(V(aQ,"ClassName")or"")=="Model"and tostring(V(aQ,"Name")or""):lower()=="atm"then b8(aQ)break end;aQ=V(aQ,"Parent")end end end;if not aR then ay(x,25000,10,b8)end;return aR end;H.scanAtms=function()local hN=ar()or at(B.car)local hO="-132.218079,258.478638,106.940025,-132.564561,101.952045"if type(hO)~="string"then B.atmList={}a6("ONE ATM: no saved mark....")return B.atmList end;local hP={}for aG in hO:gmatch("[^,]+")do hP[#hP+1]=tonumber(aG)end;local a0,a1,a2,c0,c1=hP[1],hP[2],hP[3],hP[4],hP[5]if#hP~=5 or not(a0 and a1 and a2 and c0 and c1)or math.abs(a0)>6000 or math.abs(a2)>6000 or math.sqrt((c0-a0)^2+(c1-a2)^2)>20 then B.atmList={}a6("ONE ATM: saved mark is...")return B.atmList end;local de=hN and math.sqrt((a0-hN.X)^2+(a2-hN.Z)^2)or-1;local g_={x=a0,y=a1,z=a2,fx=c0,fz=c1,dist=de,name="MARKED ATM",marked=true}B.atmList={g_}a6("ONLY USER-MARKED ATM: "..p(a0)..", "..p(a2).." | front "..p(c0)..", "..p(c1).." | "..p(de).." studs away")return B.atmList end;H.baitCount=function()local hQ=0;for aa,gm in ipairs({V(z,"Backpack"),V(z,"Character")})do if gm then pcall(function()for aa,W in ipairs(gm:GetChildren())do local aX=tostring(V(W,"Name")or""):lower()if (aX:find("worm")or aX:find("bait")or aX:find("prawn")or aX:find("lure")) and (not B.selectedBait or gg(V(W,"Name"))==gg(B.selectedBait.name) or gg(bU(W,"MD_ItemId"))==gg(B.selectedBait.name)) then local ab=tonumber(bU(W,"MD_StackCount"))or 0;hQ=hQ+ab end end end)end end;return hQ end;H.connectAtm=function()B.bank=tonumber(o(function()return z:GetAttribute("MD_Bank")end))or B.bank;local bn=H.atmRemote()if not bn then a6("ATM: MD_ATMRemote missing")return false end;if B.atmConnected then return true end;B.atmConnected=true;pcall(function()bn.OnClientEvent:Connect(function(g,h,aK,a4)local g8=tostring(g or"")if g8=="Balance"then B.cash,B.bank=tonumber(h)or B.cash,tonumber(aK)or B.bank;a6("ATM BALANCE: cash="..tostring(B.cash).." bank="..tostring(B.bank))elseif g8=="Open"then B.atmOpen=true;B.cash=tonumber(aK)or B.cash;B.bank=tonumber(a4)or B.bank;a6("ATM OPEN: cash="..tostring(B.cash).." bank="..tostring(B.bank))end end)end)return true end;H.sellStage=function()
 if B.done or B.stop then return end;B.phase="SELLING FISH"
 local m=B.sellTarget or H.findSellPoint();local trail=B.sellerTrail
 if not m or not trail or #trail==0 then G("recorded seller route unavailable");return end
 local cf,cV;local nextIndex=2;B.sellerWalking=true
 if B.car then local dd=math.min(90,math.max(20,(a3(ar(),trail[1])or 30)/math.max(8,t.GlideSpeed)*2.5+18));B.useDoorWalk=true;local called;called,cf,cV=pcall(dN,"sell",trail[1],2.5,dd);B.useDoorWalk=false;if not called then cV=cf;cf=false end
 else cf,cV=cR(trail[1],2.5,40)end
 if not cf and not B.stop and not B.done and trail[2] then
  local pos=ar();local gap=pos and Vector3.new(pos.X-trail[2].X,0,pos.Z-trail[2].Z).Magnitude or math.huge
  if gap<=18 then a6("SELL: first sample blocked; trying nearby second recorded sample without another exit");B.useDoorWalk=true;cf,cV=cR(trail[2],2.5,10);B.useDoorWalk=false;if cf then nextIndex=3 end end
 end
 if not cf then B.sellerWalking=false;G("cannot reach recorded seller walk: "..tostring(cV));return end
 B.useDoorWalk=true
 local idx=nextIndex
 while idx<=#trail do
  if B.stop or B.done then B.useDoorWalk=false;B.sellerWalking=false;return end
  cf,cV=cR(trail[idx],2.3,12)
  if not cf and idx<#trail-1 and not B.stop and not B.done then
   local pos=ar();local nextPoint=trail[idx+1];local gap=pos and Vector3.new(pos.X-nextPoint.X,0,pos.Z-nextPoint.Z).Magnitude or math.huge
   if gap<=18 then a6("SELL: sample "..idx.." blocked; trying adjacent recorded point");cf,cV=cR(nextPoint,2.3,10);if cf then idx=idx+1 end end
  end
  if not cf then B.useDoorWalk=false;B.sellerWalking=false;G("recorded seller walk blocked at "..idx..": "..tostring(cV));return end
  idx=idx+1
 end
 B.useDoorWalk=false;B.sellerWalking=false
 if (a3(ar(),trail[#trail])or 1e9)>5 then G("not at recorded seller position; no sale sent");return end
 a6("SELL: replayed recorded on-foot approach to seller")
 -- Give the seller area time to register our arrival before sending the one sale request.
 k(1.5)
 if B.stop or B.done then return end
 if (a3(ar(),trail[#trail])or 1e9)>5 then G("seller position changed before sale; no sale sent");return end
 local beforeFish=B.actualFishCount();local beforeCash=H.readCashNumber()
 if beforeFish<=0 then
  B.unsold=0;B.unsoldCharacter=z.Character
  G("no verified fish in inventory at seller; no sale sent; check inventory before restarting")
  return
 end
 local bn=bk();local sent=bn and bm(bn,"SellAll")
 B.sellFired=(B.sellFired or 0)+1;a6("SELL ALL sent="..tostring(sent).." visibleFish="..beforeFish.." cash="..tostring(beforeCash))
 if not sent then G("sell request could not be sent");return end
 local deadline=d()+15;local verified=false
 while d()<deadline and not B.stop do local afterFish=B.actualFishCount();local afterCash=H.readCashNumber()
  if beforeFish>0 and afterFish<beforeFish or beforeCash and afterCash and afterCash>beforeCash then verified=true;break end;k(.2)
 end
 if not verified then G("sale not confirmed by inventory or cash; stopped before deposit and buying");return end
 B.unsold=0;B.depositAfterSell=true;a6("SELL CONFIRMED: deposit proceeds at ATM before buying")
 if B.car then B.useDoorWalk=true;local returned=true;for idx=#trail-1,1,-1 do if B.stop or B.done then returned=false;break end;local ok=cR(trail[idx],2.3,12);if not ok then returned=false;break end end;B.useDoorWalk=false;if not returned then G("sale confirmed but recorded seller return path blocked");return end;local called;called,returned=pcall(dQ,"sell");if not called or not returned then G("cannot return to car after sell")return end end;local hm=(H.scanAtms()or{})[1]if not hm then G("sale confirmed but no marked ATM available; stopped before buying") return end;local hR,hS=hm.fx-hm.x,hm.fz-hm.z;local hT=math.sqrt(hR*hR+hS*hS)if hT>40 or hT<1 then local hU=at(B.car)or ar()if hU then local hV,hW=hU.X-hm.x,hU.Z-hm.z;local hX=math.max(1,math.sqrt(hV*hV+hW*hW))hm.fx=hm.x+hV/hX*12;hm.fz=hm.z+hW/hX*12;a6("ATM front point fixed -...")end end;B.atmTarget=hm;a6("ATM CHOSEN "..hm.name.." pos "..p(hm.x)..", "..p(hm.z).." front "..p(hm.fx)..", "..p(hm.fz).." "..p(hm.dist or-1).." studs")B.atmStageTarget=H.atmDriveTarget(hm)if not fR(B.atmStageTarget,"ATM")then G("sell -> marked ATM...")end end;H.planAtmPark=function(hm,cP,cQ,a1)local fd=ax(B.car)local aP=cu(B.car)if not fd or not aP then return nil,"no car pivot or driver seat"end;local aU={}ay(B.car,250,5,function(W)if o(function()return W:IsA("BasePart")end)and (V(W,"CanCollide")~=false or (B.arenaSurfaceParts and B.arenaSurfaceParts[W]==true)) then aU[#aU+1]=W end end)if#aU==0 then return nil,"no collidable car parts..."end;local hY=o(function()return fd:PointToObjectSpace(aP.Position)end)if not hY then return nil,"could not locate driver..."end;local aR,aY=nil,1e9;for aa,dX in ipairs({{cQ,-cP},{-cQ,cP},{-cP,-cQ}})do local hZ,h_=dX[1],dX[2]local f3=CFrame.lookAt(_(0,0,0),_(hZ,0,h_))local i0=1e9;local i1,i2,i3=1e9,1e9,1e9;local i4,i5,i6=-1e9,-1e9,-1e9;for aa,d7 in ipairs(aU)do local q,i7=pcall(function()return fd:ToObjectSpace(d7.CFrame)end)if q then local aZ=d7.Size;local bh=f3*i7;local aK=bh.Position;local i8=math.abs(bh.RightVector.X*cP+bh.RightVector.Z*cQ)*aZ.X*0.5+math.abs(bh.LookVector.X*cP+bh.LookVector.Z*cQ)*aZ.Z*0.5+math.abs(bh.UpVector.X*cP+bh.UpVector.Z*cQ)*aZ.Y*0.5;i0=math.min(i0,aK.X*cP+aK.Z*cQ-i8)local i9=i7.Position;local ia=i7.RightVector;local ib=i7.UpVector;local ic=i7.LookVector;local dV=math.abs(ia.X)*aZ.X*0.5+math.abs(ib.X)*aZ.Y*0.5+math.abs(ic.X)*aZ.Z*0.5;local id=math.abs(ia.Y)*aZ.X*0.5+math.abs(ib.Y)*aZ.Y*0.5+math.abs(ic.Y)*aZ.Z*0.5;local e4=math.abs(ia.Z)*aZ.X*0.5+math.abs(ib.Z)*aZ.Y*0.5+math.abs(ic.Z)*aZ.Z*0.5;i1,i4=math.min(i1,i9.X-dV),math.max(i4,i9.X+dV)i2,i5=math.min(i2,i9.Y-id),math.max(i5,i9.Y+id)i3,i6=math.min(i3,i9.Z-e4),math.max(i6,i9.Z+e4)end end;if i0<1e8 and i1<i4 then local ie,ig=cQ,-cP;for aa,ih in ipairs({0,5,-5,10,-10})do local dC=math.max(13,9-i0)local ii,ij=hm.x+cP*dC+ie*ih,hm.z+cQ*dC+ig*ih;local ah=CFrame.lookAt(_(ii,a1,ij),_(ii+hZ,a1,ij+h_))local ik=ah:PointToWorldSpace(hY)local il=math.sqrt((ik.X-hm.x)^2+(ik.Y+2-hm.y)^2+(ik.Z-hm.z)^2)local im=false;local ek,io,el=(i1+i4)/2,(i2+i5)/2,(i3+i6)/2;local q,cf=pcall(function()return x:GetPartBoundsInBox(ah*CFrame.new(ek,io,el),_(i4-i1+0.6,i5-i2+0.6,i6-i3+0.6))end)if q and type(cf)=="table"then for aa,ip in ipairs(cf)do local f5=o(function()return ip:IsDescendantOf(B.car)end)local ap=V(z,"Character")local f6=ap and o(function()return ip:IsDescendantOf(ap)end)local f7=o(function()return ip.Position.Y+ip.Size.Y/2 end)local iq=f7 and f7<a1+0.3 and(V(ip,"Size")and ip.Size.Y<3)if not f5 and not f6 and not iq and V(ip,"CanCollide")~=false then im=true;break end end end;local ev=math.abs(il-11)+math.abs(ih)*0.05;if not im and il>=7 and ev<aY then aR,aY={x=ii,y=a1,z=ij,hx=hZ,hz=h_,stand=dC,seatDist=il},ev end end end end;if not aR then return nil,"no clear surface parking..."end;return aR end;H.ensureAtmStable=function(prompt)
 B.atmTransactionHold=true
 local root=ao();local hum=aq();local target=co(prompt)
 if not root or not hum or not target then return false,"ATM prompt or avatar missing" end
 pcall(function()hum:Move(Vector3.zero,false);hum:MoveTo(root.Position);root.AssemblyLinearVelocity=Vector3.zero end)
 local start=d();local prev=root.Position;local stableSince=nil
 while d()-start<4 and not B.stop and not B.done do
  root=ao();target=co(prompt);if not root or not target then return false,"ATM position disappeared" end
  local pos=root.Position;local dist=(pos-target).Magnitude;local speed=root.AssemblyLinearVelocity.Magnitude
  if dist<=math.min(9,(tonumber(prompt.MaxActivationDistance)or 10)-0.5) and (pos-prev).Magnitude<0.8 and speed<3 then
   stableSince=stableSince or d();if d()-stableSince>=0.6 then a6("ATM: stable in range "..p(dist).."; transaction ready");return true end
  else stableSince=nil end
  prev=pos;k(.2)
 end
 return false,"avatar moved, airborne or outside ATM range; no transaction sent"
end
H.atmFootStage=function()if B.done or B.stop then return end;local hm=B.atmTarget;if not hm or not hm.marked then G("foot ATM: only the...")return end;H.connectAtm()local bn=H.atmRemote()local cc=H.resolveMarkedAtm(hm)if not bn or not cc then G("foot ATM: marked...")return end;local dg=o(function()return cc:FindFirstChild("MD_ATMPrompt",true)end)if not dg or tostring(V(dg,"ClassName"))~="ProximityPrompt"then G("foot ATM: marked ATM...")return end;local d8=co(dg)if not d8 then G("foot ATM: bank prompt...")return end;local ir=tonumber(V(dg,"MaxActivationDistance"))or 10;local d5=ar()if not d5 then G("foot ATM: no character")return end;local a4=a3(d5,d8)or 1e9;if a4>ir-1 then local q,cV=cR(_(d8.X,d8.Y+2,d8.Z),math.max(1,ir-2),20)if not q then G("foot ATM: cannot walk to..."..tostring(cV))return end end;if(a3(ar(),d8)or 1e9)>ir+0.2 then G("foot ATM: outside prompt...")return end;B.phase="ON FOOT: OPEN MARKED ATM"B.atmOpen=false;local is=math.max(0.3,tonumber(V(dg,"HoldDuration"))or 0.15)local it=type(fireproximityprompt)=="function"and fireproximityprompt or o(function()return r().fireproximityprompt end)if it then pcall(it,dg,is+0.25,true)end;local dn=d()while not B.atmOpen and not B.stop and d()-dn<1.6 do k(0.1)end;if not B.atmOpen then local q=pcall(function()dg:InputHoldBegin()end)if q then k(is+0.25)pcall(function()dg:InputHoldEnd()end)end;local iu=d()while not B.atmOpen and not B.stop and d()-iu<1.6 do k(0.1)end end;if not B.atmOpen then G("foot ATM: server did not...")return end;B.phase="ON FOOT: CONFIRMED BANKING"local stable,why=H.ensureAtmStable(dg);if B.stop or B.done then B.atmTransactionHold=false;return end;if not stable then G("ATM stability: "..tostring(why));return end;local gX=math.ceil(H.moneyNeeded())local gY=H.readCashNumber()or 0;if gY>0 and gY>=(tonumber(B.autoDepositThreshold) or 10000) then if not bm(bn,"Deposit",gY)then G("foot ATM: deposit...")return end;local gz=d()while(H.readCashNumber()or gY)>=gY and d()-gz<3 do k(0.1)end;if(H.readCashNumber()or gY)>=gY then G("foot ATM: deposit not...")return end;ac("ATM DEPOSIT "..tostring(gY).." on foot")end;B.depositAfterSell=false;B.suppressDeposit=false
 if B.depositOnly then
  B.depositOnly=false;B.atmTransactionHold=false;B.autoFishStarted=false;B.busy=true
  a6("AUTO DEPOSIT: confirmed or no longer required; returning to fishing")
  if not fR(B.fishTarget,"FISH")then G("auto deposit: return to fishing failed")end;return
 end
 local c6=H.readCashNumber()or 0;local iv=tonumber(o(function()return z:GetAttribute("MD_Bank")end))or tonumber(B.bank)or 0;local bX=math.min(math.max(0,gX-c6),iv)if bX>0 then if not bm(bn,"Withdraw",bX)then G("foot ATM: withdrawal...")return end;local iw=d()while(H.readCashNumber()or c6)<=c6 and d()-iw<3 do k(0.1)end;if(H.readCashNumber()or c6)<=c6 then G("foot ATM: withdrawal not confirmed; balances unchanged, check bank before retrying")return end;ac("ATM WITHDRAW "..tostring(bX).." on foot")end;local ix=H.readCashNumber()or 0;if ix<gX then G("foot ATM: confirmed wallet $"..ix.." below shop need $"..gX)return end;a6("FOOT ATM confirmed wallet $"..ix.."; walking to shop")B.atmTransactionHold=false;B.shopAttempted,B.shopDone,B.resupply=false,false,false;if not fR(B.shopTarget,"SHOP")then G("foot ATM -> shop: no...")end end;H.atmStage=function()if B.done or B.stop then return end;if not B.car then return H.atmFootStage()end;local hm=B.atmTarget;if not hm then G("no marked ATM selected")return end;if not B.car or not aL(B.car)then G("ATM: driver must remain...")return end;B.phase="ATM: PARKED SURFACE /..."H.connectAtm()local bn=H.atmRemote()if not bn then G("ATM remote missing; no...")return end;local cP,cQ=hm.fx-hm.x,hm.fz-hm.z;local dy=math.sqrt(cP*cP+cQ*cQ)if dy<0.5 then G("marked ATM has no usable...")return end;cP,cQ=cP/dy,cQ/dy;local a1=hm.y-2.3;local hn=B.shopTarget;if hn and math.sqrt((hn.x-hm.x)^2+(hn.z-hm.z)^2)<120 and math.abs(hn.y+t.SurfaceLift-a1)<8 then a1=hn.y+t.SurfaceLift end;local iy=B.autoDrive and B.autoDrive.park;local f9,cV;if iy and iy.atmPark and iy.hx then f9={x=iy.x,y=iy.pivotY or a1,z=iy.z,hx=iy.hx,hz=iy.hz,stand=iy.stand,seatDist=iy.seatDist}a6("ATM: using same checked...")else f9,cV=H.planAtmPark(hm,cP,cQ,a1)end;if not f9 then G("ATM: no collision-free..."..tostring(cV))return end;a6("ATM PARK PLAN: pivot "..p(f9.stand).." studs out, driver ~"..p(f9.seatDist).." studs from screen; heading "..p(f9.hx)..","..p(f9.hz))pcall(eR)pcall(function()anchorCar(false)end)pcall(function()eO(true)end)B.atmOpen=false;local f1=at(B.car)local iz=B.routeMode=="Above ground"if not f1 or math.sqrt((f1.X-f9.x)^2+(f1.Z-f9.z)^2)>(iz and 350 or 1.8)then G("ATM: car stopped outside...")return end;local a0,a2=f1.X,f1.Z;if iz then local fb=eV(a0,a2,f1.Y+7)if not fb or math.abs(f1.Y-fb)>9 then G("ATM: surface car not on...")return end else local q,cf=pcall(function()return x:GetPartBoundsInBox(CFrame.new(a0,f9.y,a2),_(10,6,16))end)if not q or type(cf)~="table"then G("ATM: actual parking...")return end;for aa,d7 in ipairs(cf)do local f5=o(function()return d7:IsDescendantOf(B.car)end)local ap=V(z,"Character")local f6=ap and o(function()return d7:IsDescendantOf(ap)end)local f7=o(function()return d7.Position.Y+d7.Size.Y/2 end)if not f5 and not f6 and V(d7,"CanCollide")~=false and(not f7 or f7>f9.y+0.3)then G("ATM: obstacle at gradual...")return end end;local iA,iB=eT(a0,a2,f9.y,f9.hx,f9.hz)if not iA then G("ATM: checked surface..."..tostring(iB))return end end;B.underground,B.pinY,B.driveY=false,nil,nil;pcall(function()anchorCar(not iz)end)B.speed=0;a6((iz and"ATM: parked on road "or"ATM: checked surface snap ")..p(a0)..", "..p(f9.y)..", "..p(a2))k(0.4)local iA=at(B.car)if not iA or not iz and(math.sqrt((iA.X-f9.x)^2+(iA.Z-f9.z)^2)>5 or math.abs(iA.Y-f9.y)>4)or not aL(B.car)then G("ATM: safe landing...")return end;hm.object=H.resolveMarkedAtm(hm)if not hm.object then G("marked ATM model not...")return end;local dg,iC;ay(hm.object,180,7,function(W)if tostring(V(W,"ClassName")or"")~="ProximityPrompt"then return end;local bY=(tostring(V(W,"Name")or"").." "..tostring(V(W,"ActionText")or"").." "..tostring(V(W,"ObjectText")or"")):lower()local aY=0;if tostring(V(W,"Name"))=="MD_ATMPrompt"then aY=aY+200 end;if bY:find("md bank",1,true)then aY=aY+80 end;if bY:find("atm",1,true)then aY=aY+55 end;if bY:find("bank",1,true)then aY=aY+50 end;if bY:find("use",1,true)or bY:find("open",1,true)then aY=aY+20 end;if bY:find("hack",1,true)then aY=aY-150 end;if V(W,"Enabled")==false then aY=aY-30 end;local iD=co(W)if iD then aY=aY-math.sqrt((iD.X-hm.x)^2+(iD.Z-hm.z)^2)end;if not dg or aY>iC then dg,iC=W,aY end end)if not dg then G("marked ATM has no...")return end;a6("ATM PROMPT: "..tostring(V(dg,"Name")).." "..tostring(V(dg,"ActionText")).." / "..tostring(V(dg,"ObjectText")).." (score="..p(iC)..")")local d8=co(dg)or _(hm.x,hm.y,hm.z)local aM,aP,bN=aq(),cu(B.car),ao()if not(aM and aP and bN)then G("ATM: missing driver,...")return end;pcall(function()aM.Sit=false;aM.PlatformStand=false;aM.AutoRotate=true end)pcall(function()aM:ChangeState(Enum.HumanoidStateType.GettingUp)end)for a7=1,8 do if not aL(B.car)then break end;pcall(function()aM.Jump=true end)k(0.12)end;if aL(B.car)then G("ATM: could not get out...")return end;k(0.12)local iE,iF=dG("ATM")if not iE then G("ATM: "..tostring(iF))return end;for a7=1,5 do pcall(function()aM.PlatformStand=false;aM.AutoRotate=true;bN.AssemblyAngularVelocity=_(0,0,0)local ai=bN.Position;bN.CFrame=CFrame.lookAt(_(ai.X,ai.Y,ai.Z),_(d8.X,ai.Y,d8.Z))end)k(0.08)end;pcall(function()aM:ChangeState(Enum.HumanoidStateType.Running)end)a6("ATM EXIT: upright upY="..p(o(function()return bN.CFrame.UpVector.Y end)or-1))B.phase="ATM: UPRIGHT GRAVITY GLIDE"local iG=_(d8.X+cP*2,(iz and d8.Y or a1)+2,d8.Z+cQ*2)local iH=iz and math.min(180,math.max(20,(a3(ar(),iG)or 30)/math.max(8,t.GlideSpeed)*2.5+18))or 10;local ir=tonumber(V(dg,"MaxActivationDistance"))or 10;local iI,cV=false,"not attempted";local de=a3(ar(),d8)or 1e9
-- Match the stricter transaction stability radius, with a small margin.
-- Opening the UI alone does not mean the character is close enough to transact.
local stableApproachRange=math.max(1,math.min(9,ir-0.5)-0.6)
if de>stableApproachRange then
 local sideX,sideZ=cQ,-cP
 for attempt,offset in ipairs({{6,0},{6,4},{6,-4},{8,0},{4,0}}) do
  if B.stop or B.done then break end
  local current=ar();if not current then cV="avatar position unavailable";break end
  local goal=_(d8.X+cP*offset[1]+sideX*offset[2],current.Y,d8.Z+cQ*offset[1]+sideZ*offset[2])
  a6("ATM APPROACH "..attempt..": front="..p(offset[1]).." side="..p(offset[2]).." from="..tostring(current).." goal="..tostring(goal))
  pcall(function()aM.Sit=false;aM.PlatformStand=false;aM:ChangeState(Enum.HumanoidStateType.Running)end)
  iI,cV=cR(goal,1.5,math.min(iH,8));de=a3(ar(),d8)or 1e9
  do
   local settleStart=d();local pos=ar();local horizontal=pos and math.sqrt((pos.X-d8.X)^2+(pos.Z-d8.Z)^2)or 1e9
   if horizontal<25 and pos and pos.Y>d8.Y+6 then
    a6("ATM: waiting for airborne avatar to descend before checking prompt range")
    while not B.stop and not B.done and d()-settleStart<5 do
     local current=ar();local hum=aq();if not current then break end
     if current.Y<=d8.Y+6 then break end
     if hum then pcall(function()hum.Jump=false end)end;k(.1)
    end
    de=a3(ar(),d8)or 1e9;a6("ATM: after landing wait position="..tostring(ar()).." range="..p(de))
   end
  end
  a6("ATM APPROACH "..attempt.." result="..tostring(iI).." reason="..tostring(cV).." range="..p(de).."/"..p(ir))
  if de<=stableApproachRange then break end
  if not iI then pcall(function()
   local pos=ar();local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;local ignores={z.Character};if B.car then ignores[#ignores+1]=B.car end;rp.FilterDescendantsInstances=ignores;rp.RespectCanCollide=true
   local start=pos+_(0,2,0);local delta=(goal+_(0,2,0))-start;local hit=x:Raycast(start,delta,rp)
   if hit then a6("ATM APPROACH blocked by "..Y(hit.Instance).." at "..tostring(hit.Position).." material="..tostring(hit.Material))else a6("ATM APPROACH probe clear; pathfinding or movement failed")end
  end)end
 end
end
de=a3(ar(),d8)or 1e9;a6("ATM GROUND GLIDE "..tostring(iI).." ("..tostring(cV)..") range="..p(de).."/"..p(ir).." open="..tostring(B.atmOpen))if B.stop or B.done then return end;if de>ir and not(B.atmOpen and de<=20)then G("ATM: could not reach prompt after front/side approaches; no transaction attempted")return end;B.phase="ATM: OPEN MD BANK..."if not B.atmOpen then local is=math.max(0.3,tonumber(V(dg,"HoldDuration"))or 0.15)local it=type(fireproximityprompt)=="function"and fireproximityprompt or o(function()return r().fireproximityprompt end)if it then local q=pcall(it,dg,is+0.25,true)a6("ATM direct prompt helper..."..tostring(q))local dn=d()while not B.atmOpen and d()-dn<1.5 and not B.stop do k(0.1)end end;if not B.atmOpen then local iJ=pcall(function()dg:InputHoldBegin()end)if iJ then k(is+0.25)pcall(function()dg:InputHoldEnd()end)end;local iu=d()while not B.atmOpen and d()-iu<1.5 and not B.stop do k(0.1)end end end;if not B.atmOpen then G("ATM did not send Open...")return end;B.phase="ATM: DEPOSIT / WITHDRAW..."local stable,why=H.ensureAtmStable(dg);if B.stop or B.done then B.atmTransactionHold=false;return end;if not stable then G("ATM stability: "..tostring(why));return end;local repairInfo=B.getRepairQuote and B.getRepairQuote() or nil;if B.repairFunding and not repairInfo then G("repair ATM: fresh quote unavailable; no withdrawal made");return end;local resumeFish=B.instaSellTrip and ((H.baitCount()or 0)>0 or (h8()or 0)>0) and gh(B.cheapestRod and B.cheapestRod.name or t.RodId)~=nil
 local gX=(resumeFish and 0 or math.ceil(H.moneyNeeded()))+(repairInfo and repairInfo.quote or 0);local gY=H.readCashNumber()or 0;a6("ATM FUNDS: supplies="..p(H.moneyNeeded()).." repair="..p(repairInfo and repairInfo.quote or 0).." wallet="..p(gY).." total="..p(gX));B.bank=tonumber(o(function()return z:GetAttribute("MD_Bank")end))or B.bank;a6("ATM OPEN on foot: wallet $"..tostring(gY).." bank $"..tostring(B.bank).." estimated cheapest..."..tostring(gX))if not B.depositAfterSell and (B.suppressDeposit or B.repairFunding or repairInfo) then B.suppressDeposit=false elseif gY>0 then if not bm(bn,"Deposit",gY)then G("ATM: deposit request failed")return end;local dn=d()while(H.readCashNumber()or gY)>=gY and d()-dn<2.5 do k(0.1)end;if(H.readCashNumber()or gY)>=gY then G("ATM: deposit not...")return end;ac("ATM DEPOSIT "..tostring(gY).." on foot")end;B.depositAfterSell=false;local iK=H.readCashNumber()or 0;local iL=tonumber(o(function()return z:GetAttribute("MD_Bank")end))or tonumber(B.bank)or 0;local bX=math.min(math.max(0,gX-iK),iL)a6("ATM WITHDRAW for..."..tostring(bX).." (wallet $"..tostring(iK)..")")if bX>0 then if not bm(bn,"Withdraw",bX)then G("ATM: withdrawal request...")return end;local dn=d()while(H.readCashNumber()or iK)<=iK and d()-dn<3 do k(0.1)end;if(H.readCashNumber()or iK)<=iK then G("ATM: withdrawal not confirmed; balances unchanged, check bank before retrying")return end;ac("ATM WITHDRAW "..tostring(bX).." on foot")end;local ix=H.readCashNumber()or 0;if ix<gX then G("ATM: wallet $"..tostring(ix).." below rod+bait cost $"..tostring(gX))return end;if repairInfo then
 local success,reason=B.executeRepair(repairInfo.name,repairInfo.quote)
 if not success then B.repairFunding=nil;G("repair after withdrawal: "..tostring(reason));return end
 a6("ATM: repair confirmed; walking through door to shop for rod/bait")
end
B.repairFunding=nil;B.atmTransactionHold=false
if B.instaSellTrip then B.instaSellTrip=false;if resumeFish then
 a6("INSTA SELL: deposit confirmed; bait remains, return to car and fish")
 B.resupply=false;B.shopDone=true;B.shopAttempted=false
 if B.car and not aL(B.car) and not dQ("ATM -> fishing") then G("cannot return to car after deposit");return end
 if not gV() then G("cannot resume fishing after deposit")end;return
 else a6("INSTA SELL: no confirmed remaining bait; restocking before fishing")end end
if iz then B.phase="ATM -> SHOP: REPLAY..."B.shopAttempted,B.shopDone,B.resupply=false,false,false;
local root=ao();if root then
 local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={z.Character,B.car};rp.RespectCanCollide=true
 local hit=x:Raycast(Vector3.new(root.Position.X,hm.y+10,root.Position.Z),Vector3.new(0,-22,0),rp)
 if hit and math.abs(hit.Position.Y-hm.y)<8 and root.Position.Y<hit.Position.Y-2 and hit.Position.Y-root.Position.Y<=15 then
  a6("ATM EXIT: correcting avatar up to marked ground floor");root.CFrame=CFrame.new(root.Position.X,hit.Position.Y+3,root.Position.Z)*root.CFrame.Rotation;root.AssemblyLinearVelocity=Vector3.zero;k(.25)
 elseif hit and root.Position.Y<hit.Position.Y-2 then G("ATM exit is below the ground; unable to verify safe correction");return end
end
B.useDoorWalk=true;local called,du,iM=pcall(da,false);B.useDoorWalk=false;if not called or not du then G("ATM -> shop foot route: "..tostring(called and iM or du))return end;B.walkedFromAtm=true;B.stage="SHOP"gW()return end;B.phase="ATM: RETURN TO CAR AFTER..."local dA=V(aP,"Position")if not dA then G("ATM: driver seat missing...")return end;local dR=_(dA.X,dA.Y+t.SeatLift,dA.Z)local iN=iz and math.min(180,math.max(20,(a3(ar(),dR)or 30)/math.max(8,t.GlideSpeed)*2.5+18))or 12;local iO,iP=cR(dR,4,iN)a6("ATM RETURN GROUND GLIDE "..tostring(iO).." ("..tostring(iP)..")")if not iO then G("ATM: could not return to...")return end;for a7=1,3 do pcall(function()aP:Sit(aM)end)k(0.3)if aL(B.car)then break end end;if not aL(B.car)then G("ATM: cannot re-enter...")return end;pcall(function()anchorCar(false)end)B.shopAttempted,B.shopDone,B.resupply=false,false,false;a6("ATM confirmed $"..tostring(ix)..": "..(iz and"road"or"underground").." drive -> shop -> MARK 1")if not fR(B.shopTarget,"SHOP")then G("ATM -> SHOP drive refused")return end;local fW=B.autoDrive;i(function()local iQ=d()+18;while not B.done and not B.stop and B.autoDrive==fW and d()<iQ do local f1=at(B.car)local a4=f1 and math.sqrt((f1.X-fW.target.x)^2+(f1.Z-fW.target.z)^2)or 1e9;if a4<=(t.ArriveRadius or 8)+1 and aL(B.car)then if fW.active then fW.active,fW.done=false,true;B.speed=0;a6("SHOP ARRIVAL GUARD: at..."..p(a4).." studs")end;if fW.done and not B.shopAttempted then gW()end;return end;if not fW.active then return end;k(0.15)end end)end;H.startResupply=function(cV)if B.resupply then return end;B.resupply=true;B.autoFish=false;if B.unlockTravelCamera then B.unlockTravelCamera()end;B.castToken=(B.castToken or 0)+1;B.busy=true;B.phase="OUT OF BAIT"a6("RESUPPLY: "..tostring(cV))ac("RESUPPLY: "..tostring(cV))if B.castActive then bm(bk(),"Cancel")end;B.castActive=false;H.scanAtms()if B.skyState then local ok,why=B.skyDescend();if not ok then G(why);return end end;if B.inUnderFish then local ok,why=B.returnMarkedFishSurface();if not ok then G("return from fishing spot: "..tostring(why));return end end;if B.car and not aL(B.car)then
 a6("RETURN FROM FISH: approaching driver prompt directly")
 if not dt(B.car) then G("cannot return to car for fishing resupply; "..tostring(B.boardProblem or "driver seat not confirmed"))return end
 end;if H.fishOnMe()<=0 then a6("SMART: nothing to sell -...")local iR=H.readCashNumber()if not iR or iR<H.moneyNeeded()then local hr=(B.atmList or{})[1]if hr then B.atmTarget=hr;B.atmStageTarget=H.atmDriveTarget(hr)a6("SMART: cash is short -..."..tostring(hr.name)..")")B.autoFish=false;B.suppressDeposit=true;fR(B.atmStageTarget,"ATM")return end end;B.autoFish=false;B.shopAttempted,B.shopDone=false,false;fR(B.shopTarget,"SHOP")return end;if not B.sellTarget then B.sellTarget=H.findSellPoint()end;if B.sellTarget then B.autoFish=false;fR(B.sellTarget,"SELL")else G("no marked sell location;...")end end;B.realFishFloor=function(px,pz,nearY)
 local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.IgnoreWater=true;rp.RespectCanCollide=true
 local exclude={z.Character};if B.car then exclude[#exclude+1]=B.car end;if B.underFloor then exclude[#exclude+1]=B.underFloor end;if B.skyState and B.skyState.folder then exclude[#exclude+1]=B.skyState.folder end;rp.FilterDescendantsInstances=exclude
 local ok,hit=pcall(function()return x:Raycast(Vector3.new(px,nearY+3,pz),Vector3.new(0,-14,0),rp)end)
 if not ok or not hit or hit.Material==Enum.Material.Water or hit.Normal.Y<.6 then return nil end
 if hit.Instance~=x.Terrain and not hit.Instance.CanCollide then return nil end
 return hit
end
B.glideFishingXZ=function(target,timeout,minY)
 local root=ao();local hum=aq();if not root or not hum or hum.SeatPart then return false,"on-foot root unavailable"end
 local start=root.Position;local delta=Vector3.new(target.X-start.X,0,target.Z-start.Z)
 if delta.Magnitude>600 then return false,"glide exceeds 600 studs"end
 local mass=root.AssemblyMass;if mass~=mass or mass<=0 or mass>10000 then return false,"character mass unavailable"end
 local travelY=math.max(start.Y,tonumber(minY) or start.Y)
 local hold=Instance.new("BodyPosition");hold.Name="DRIXN_FishGlide";hold.MaxForce=Vector3.new(0,mass*x.Gravity*4,0);hold.P=mass*500;hold.D=mass*45;hold.Position=Vector3.new(start.X,travelY,start.Z);hold.Parent=root;B.fishingGlide=true
 local untilTime=d()+(timeout or 25);local reached=false
 while d()<untilTime and not B.stop and not B.done do
  if hum.SeatPart then break end
  local position=root.Position;if not B.finiteVector(position) or not B.finiteVector(root.AssemblyLinearVelocity)then break end
  hold.Position=Vector3.new(position.X,travelY,position.Z)
  local step=Vector3.new(target.X-position.X,0,target.Z-position.Z);local gap=step.Magnitude
  if gap<=3 and (not minY or position.Y>=minY-2) then reached=true;break end
  local v=root.AssemblyLinearVelocity;local speed=gap>3 and math.min(60,math.max(4,gap*3)) or 0
  root.AssemblyLinearVelocity=gap>0.001 and Vector3.new(step.X/gap*speed,v.Y,step.Z/gap*speed) or Vector3.new(0,v.Y,0)
  root.AssemblyAngularVelocity=Vector3.zero;game:GetService("RunService").Heartbeat:Wait()
 end
 pcall(function()root.AssemblyLinearVelocity=Vector3.zero;hold:Destroy()end);B.fishingGlide=false
 return reached,reached and "on foot above selected spot" or "could not reach above selected spot while on foot"
end
B.runMarkedFishBelow=function()
 local mark=B.underFishMark;if not mark or not B.car or not aL(B.car) then return false,"fishing mark or seated car missing"end
 local ok,why=dN("FISH",nil);if not ok then return false,"could not leave car: "..tostring(why)end
 local start=ar();if not start then return false,"player position unavailable"end
 B.underFishSurface={player=start};a6("FISH: car parked on dry road; gliding character above selected spot")
 local reached,glideWhy=B.glideFishingXZ(mark,math.max(15,math.min(30,(Vector3.new(start.X-mark.X,0,start.Z-mark.Z).Magnitude/45)+8)),mark.Y+6)
 if not reached then if not B.stop and not B.done then a6("FISH glide failed; attempting return to dry parking");B.glideFishingXZ(start,30)end;return false,glideWhy end
 local root=ao();local hum=aq();if not root or not hum or hum.SeatPart then return false,"character is not on foot after glide"end
 local horizontal=Vector3.new(root.Position.X-mark.X,0,root.Position.Z-mark.Z).Magnitude
 if horizontal>5 or root.Position.Y<mark.Y+4 then return false,"not close enough above selected mark for drop"end
 a6("FISH: on foot above mark "..tostring(mark).." horizontal distance="..p(horizontal).."; checking floor before teleport down")
 local floor=B.realFishFloor(mark.X,mark.Z,mark.Y)
 if not floor then
  a6("FISH: no verified game floor at mark; gliding back to parked car")
  B.glideFishingXZ(start,30);return false,"no solid game floor detected near selected mark"
 end
 local target=Vector3.new(mark.X,floor.Position.Y+hum.HipHeight+root.Size.Y/2,mark.Z)
 a6("FISH: teleporting CHARACTER down; car stays parked. Mark="..tostring(mark).." floor-adjusted landing="..tostring(target))
 B.underFishMark=target;B.inUnderFish=true
 local moved,err=pcall(function()root.AssemblyLinearVelocity=Vector3.zero;root.CFrame=CFrame.new(target)*root.CFrame.Rotation end)
 if not moved then B.inUnderFish=false;return false,"character placement failed: "..tostring(err)end
 k(.35);local actual=ar()
 if not B.finiteVector(actual) or (actual-target).Magnitude>5 then return false,"server did not hold the marked character placement"end
 if not B.savedSkyCastTarget then B.savedSkyCastTarget=B.castTarget end
 B.castTarget={x=target.X,y=target.Y,z=target.Z};a6("FISH: character at marked game floor; camera will lock toward detected water")
 return true
end
B.returnMarkedFishSurface=function()
 if B.unlockTravelCamera then B.unlockTravelCamera()end
 if not B.inUnderFish then return true end
 local saved=B.underFishSurface;local root=ao();if not saved or not saved.player or not root then return false,"surface return position or character missing"end
 if aq() and aq().SeatPart then return false,"cannot return character while seated"end
 -- Choose a landing beside the live driver door, never move the vehicle.
 -- Both the parked car and the entire short on-foot corridor must be dry.
 local car=B.car;local seat=car and cu(car);local door=car and cq(car);local carPos=car and at(car);local hum=aq()
 if not carPos or not seat or not door or not door.pos or not hum then return false,"unsafe vehicle: parked car or driver door unavailable" end
 local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.IgnoreWater=false;rp.RespectCanCollide=true
 local excluded={z.Character,car};if B.underFloor then excluded[#excluded+1]=B.underFloor end;rp.FilterDescendantsInstances=excluded
 local function dryAt(px,pz)
  local ok,hit=pcall(function()return x:Raycast(Vector3.new(px,seat.Position.Y+12,pz),Vector3.new(0,-30,0),rp)end)
  if not ok or not hit or hit.Material==Enum.Material.Water or hit.Normal.Y<.7 or (hit.Instance~=x.Terrain and not hit.Instance.CanCollide) or math.abs(hit.Position.Y-seat.Position.Y)>8 then return nil end
  return hit.Position.Y
 end
 if not dryAt(carPos.X,carPos.Z) then return false,"unsafe vehicle: parked car is over water or unsupported ground" end
 local outward=Vector3.new(door.pos.X-carPos.X,0,door.pos.Z-carPos.Z);outward=outward.Magnitude>.1 and outward.Unit or Vector3.new(1,0,0)
 local side=Vector3.new(-outward.Z,0,outward.X);local landing=nil
 for _,offset in ipairs({{10,0},{12,3},{12,-3},{15,0},{15,5},{15,-5}}) do
  local candidate=door.pos+outward*offset[1]+side*offset[2];local y=dryAt(candidate.X,candidate.Z)
  if y then
   local clear=true;local lastY=y;local delta=Vector3.new(door.pos.X-candidate.X,0,door.pos.Z-candidate.Z);local steps=math.max(1,math.ceil(delta.Magnitude/2))
   for n=1,steps do local point=candidate+delta*(n/steps);local nextY=dryAt(point.X,point.Z);if not nextY or math.abs(nextY-lastY)>3 then clear=false;break end;lastY=nextY end
   if clear then
    local h=math.max(2.5,hum.HipHeight+root.Size.Y/2)+.3
    local point=Vector3.new(candidate.X,y+h,candidate.Z)
    local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.FilterDescendantsInstances=excluded;overlap.MaxParts=50
    local ok,hits=pcall(function()return x:GetPartBoundsInBox(CFrame.new(point+Vector3.new(0,1,0)),Vector3.new(2,3,2),overlap)end)
    if ok then for _,part in ipairs(hits)do if part.CanCollide then clear=false;break end end else clear=false end
    if clear then landing=point;break end
   end
  end
 end
 if not landing then a6("FISH RETURN: no verified dry landing and corridor beside the driver door");return false,"unsafe vehicle: no dry return route to driver door" end
 a6("FISH RETURN: character to verified dry ground "..tostring(landing).."; car remains at "..tostring(carPos).."; glide to driver next")
 local ok,why=pcall(function()root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero;root.CFrame=CFrame.new(landing)*root.CFrame.Rotation end)
 if not ok then return false,tostring(why)end
 k(.35);local actual=ar();local now=at(car)
 if not B.finiteVector(actual) or (actual-landing).Magnitude>3 or not now or (now-carPos).Magnitude>5 then return false,"unsafe vehicle: dry landing or parked car position not confirmed"end
 local floor=dryAt(actual.X,actual.Z)
 if not floor or actual.Y<floor+1 or root.AssemblyLinearVelocity.Y < -12 then return false,"unsafe vehicle: avatar did not settle on dry ground" end
 B.inUnderFish=false;B.underFishSurface=nil;B.justReturnedFromFishing=true;a6("FISH: returned character to verified dry ground; gliding to driver")
 return true
end
local function iS(f0)local fW=B.autoDrive;local f9=fW and fW.park;if not B.car or not f9 or not aL(B.car)then return false,"no parked seated car"end;local f1=at(B.car)if not f1 or math.sqrt((f1.X-f9.x)^2+(f1.Z-f9.z)^2)>(t.UndergroundArriveRadius or 1.25)+0.5 then return false,"arrival is not at..."end;local a0,a2=f1.X,f1.Z;local cM,cV=eV(a0,a2,f9.y+2)if not cM or math.abs(cM-f9.y)>2 then return false,"floor-level landing..."..tostring(cV)end;local hL=nil;if f0~="ATM" then hL=B[f0=="SHOP"and"shopTarget"or f0=="FISH"and"fishTarget"or"sellTarget"] end;if hL and hL.y and(cM>hL.y+1.25 or cM<hL.y-5)then return false,"roof or wrong floor at..."end;local a1=cM+(B.surfaceRideHeight or 2.5)local q,cf=pcall(function()return x:GetPartBoundsInBox(CFrame.new(a0,cM+3,a2),_(10,6,16))end)if not q or type(cf)~="table"then return false,"cannot check landing..."end;for aa,d7 in ipairs(cf)do local f5=o(function()return d7:IsDescendantOf(B.car)end)local ap=V(z,"Character")local f6=ap and o(function()return d7:IsDescendantOf(ap)end)local f7=o(function()return d7.Position.Y+d7.Size.Y/2 end)if not f5 and not f6 and V(d7,"CanCollide")~=false and(not f7 or f7>cM+1.2)then return false,"wall/building at landing"end end;local ah=ax(B.car)local ea=ah and ah.LookVector;local c0,c1=ea and ea.X or 0,ea and ea.Z or 1;pcall(anchorCar,true);local iT,iU=eT(a0,a2,a1,c0,c1)if not iT then return false,"checked surface teleport..."..tostring(iU)end;f1=at(B.car)if not f1 or math.abs(f1.Y-a1)>3 or not aL(B.car)then return false,"server corrected landing..."end;B.underground,B.pinY,B.driveY=false,nil,nil;if B.releaseUnderFloor then B.releaseUnderFloor()end;pcall(anchorCar,false);arenaRestoreSurfaceCollision();a6("DIRECT SURFACE SNAP near "..tostring(f0).." at "..p(a0)..","..p(a2))return true end;I=function(f0)if B.done or B.stop then return end;if not B.autoDrive or not B.autoDrive.done then return end;if B.car and B.underground and f0~="FISH"then local q,cV=iS(f0)if not q then G("unsafe arrival: "..tostring(cV))return end end;if f0=="SHOP"then gW()elseif f0=="SELL"then H.sellStage()elseif f0=="ATM"then if B.travelMode=="Teleport" then H.atmFootStage()else H.atmStage()end elseif f0=="FISH"then if B.autoFishStarted then return end;B.autoFishStarted=true
 if B.activeFarmMode=="Underground" and B.travelMode~="Teleport" then local ok,why=B.runMarkedFishBelow();if not ok then G("marked underground fishing setup: "..tostring(why));return end end
 hx()end end;local function iV(bq)local aF=false;local function gy(j)if type(j)=="function"and pcall(j,bq)then aF=true end end;local s=r()if type(s)=="table"then gy(rawget(s,"setclipboard"))gy(rawget(s,"toclipboard"))gy(rawget(s,"set_clipboard"))end;o(function()gy(setclipboard)end)o(function()gy(toclipboard)end)o(function()gy(set_clipboard)end)return aF end;local function iW(bq)local a_,d7=900,0;local hQ=math.max(1,math.ceil(#bq/a_))for a7=1,#bq,a_ do d7=d7+1;print("[AUTOFISH][DUMP "..tostring(d7).."/"..tostring(hQ).."]")print(bq:sub(a7,a7+a_-1))end;return hQ end;local function iX()local W={}local function iY(a0)W[#W+1]=tostring(a0 or"")end;local function iZ(m)return m and p(m.x)..", "..p(m.y)..", "..p(m.z)or"NONE"end;iY("===== AUTO FISH FROM CAR "..a.." "..U().." =====")iY("phase "..B.phase.." | stage "..tostring(B.stage).." | travel "..tostring(B.travelMode or "Drive"))iY("mode "..(B.car and"owned vehicle "..tostring(V(B.car,"Name"))or"on foot").." | seated "..tostring(aL(B.car)).." | underground "..tostring(B.underground).." | pinY "..tostring(B.pinY and p(B.pinY)).." | driveY "..tostring(B.driveY and p(B.driveY)))iY("shop "..iZ(B.shopTarget).." | MARK1 "..iZ(B.fishTarget).." | MARK2 "..iZ(B.castTarget))iY("parked "..tostring(B.parkY).." | water "..iZ(B.waterTarget).." | route "..tostring(B.goodRoute))iY("bait qty "..tostring(B.baitQty).." @ $"..tostring(B.baitPrice).." | left "..tostring(B.baitLeft).." | sell "..tostring(B.sellFired).." | atm "..tostring(B.atmTarget and B.atmTarget.name))iY("cash "..tostring(B.cash).." bank "..tostring(B.bank))iY("casts "..tostring(B.casts).." reels "..tostring(B.reels).." bites "..tostring(B.bites).." caught "..tostring(B.caught))iY("speed "..p(B.gameMaxSpeed or 0).." ("..B.speedSource..")")iY("last failure "..tostring(B.lastFailure or"none"))
 if B.vehicleProfile then local q=B.vehicleProfile;iY("--- vehicle scan ---");iY("model="..q.name.." bounds="..tostring(q.size).." parts="..q.parts.." descendants="..q.total.." wheels="..#q.wheels.." seats="..q.seats.." prompts="..q.prompts.." mass="..p(q.mass).." ride="..tostring(q.rideHeight).." reportedSpeed="..tostring(q.gameSpeed).." source="..tostring(q.speedSource).." pathRadius="..p(q.pathRadius).." pathHeight="..p(q.pathHeight));for _,line in ipairs(q.detail)do iY(line)end end
 iY("--- recent events ---")for a7=math.max(1,#B.events-99),#B.events do local i_=B.events[a7]iY(p(i_.t).."s "..tostring(i_.text))end;iY("--- results ---")for aa,bh in ipairs(B.results)do iY(bh)end;for aa,ab in ipairs(B.notes)do iY("note: "..ab)end;iY("===== END =====")return table.concat(W,"\n")end;local function j0()local bq=B.fullLogReport and B.fullLogReport() or iX()pcall(function()if type(writefile)=="function"then writefile(t.ReportFile,bq)end end)local j1=iV(bq)a6("REPORT: "..tostring(#bq).." chars, file "..t.ReportFile..", clipboard "..tostring(j1))if not j1 then iW(bq)end;return bq end;local function j2()D(false,true)a6("DUMPED report to console")end;G=function(a8)
 if B.boardProblem then a8=tostring(a8).."; "..B.boardProblem;B.boardProblem=nil end
 B.sellerWalking=false
 if B.autoDrive then B.autoDrive.active=false end
 if tostring(a8):find("non%-finite") then if B.underHold then pcall(function()B.underHold:Destroy()end);B.underHold=nil end end
 if B.underground and B.car then pcall(anchorCar,true)end;B.atmTransactionHold=false;if B.skyCameraStop then pcall(B.skyCameraStop) end;pcall(hl)a6("!! "..tostring(a8))B.lastFailure=tostring(a8)pcall(function()P("AUTO FISH stopped",tostring(a8))end)B.done,B.busy,B.speed,B.autoFish=true,false,0,false;C.active=false;C.failure=tostring(a8)B.phase="FAILED"D(true)E()end;local function j3()if B.activeBoardPrompt then pcall(function()B.activeBoardPrompt:InputHoldEnd()end);B.activeBoardPrompt=nil end;if B.boardKeyDown and A then pcall(function()A:SendKeyEvent(false,Enum.KeyCode.E,false,game)end);B.boardKeyDown=false end;local keepUnsafeParked=B.car and B.arenaSurfaceCar==B.car and B.arenaSurfaceParts~=nil and not aL(B.car);B.sellerWalking=false;B.waitingForSpot=false;B.atmTransactionHold=false;B.runSerial=(B.runSerial or 0)+1;B.pendingInstaSell=nil;B.instaSellTrip=false;if B.skyCameraStop then B.skyCameraStop() end;arenaRestoreSurfaceCollision();if B.fishUpright then pcall(function() B.fishUpright:Destroy();B.fishUprightAttachment:Destroy() end);B.fishUpright=nil;B.fishUprightAttachment=nil end;pcall(hl)if F then pcall(F)end;B.stop,B.busy,B.done=true,false,true;C.active=false;B.autoFishStarted,B.shopDone,B.shopAttempted,B.snapped=false,false,false,false;B.stage,B.autoDrive,B.speed="IDLE",nil,0;B.phase="STOPPED"pcall(eR)pcall(function()anchorCar(B.underground==true or keepUnsafeParked)end)if keepUnsafeParked then a6("STOP: keeping overlapping parked car secured; manually clear or respawn it")end;B.parked=false;local az=aI(B.car)if az then pcall(function()az.AssemblyLinearVelocity=Vector3.new(0,0,0)end)end;a6("!! STOP - velocity 0,...")D(true)E()end;pcall(function()r().ArenaAutoFishStop=function()B.farmRequested=false;B.recovering=false;j3()end end)local function j4()local fW=B.autoDrive;if not(fW and fW.active and B.underground and B.car and aL(B.car))then return end;local ai=at(B.car)local ak=B.pinY;if not ai or not ak or math.abs(ai.Y-ak)>4 then return end;local a0,a2=ai.X,ai.Z;local j5=ak+(t.UnderFloorClearance or 16)local cM=eV(a0,a2,j5+1.5)if not cM or cM>j5+1.25 or cM<j5-12 then a6("5s surface lift skipped:...")return end;local q,aU=pcall(function()return x:GetPartBoundsInBox(CFrame.new(a0,cM+3,a2),_(10,6,16))end)if not q or type(aU)~="table"then a6("5s surface lift skipped:...")return end;for aa,d7 in ipairs(aU)do local f5=o(function()return d7:IsDescendantOf(B.car)end)local f6=V(z,"Character")and o(function()return d7:IsDescendantOf(V(z,"Character"))end)local f7=o(function()return d7.Position.Y+d7.Size.Y/2 end)if not f5 and not f6 and V(d7,"CanCollide")~=false and(not f7 or f7>cM+1.2)then a6("5s surface lift skipped:...")return end end;local ah=ax(B.car)local ea=ah and ah.LookVector;local c0,c1=ea and ea.X or 0,ea and ea.Z or 1;local j6=cM+(B.surfaceRideHeight or 2.5)local j7,j8=eT(a0,a2,j6,c0,c1)if not j7 then G("checked pulse surface..."..tostring(j8))return end;k(t.SurfacePulseDwell or 0.12)local j9=at(B.car)if not j9 or not aL(B.car)or math.abs(j9.Y-j6)>4 or math.sqrt((j9.X-a0)^2+(j9.Z-a2)^2)>4 then G("server rejected checked...")return end;if not fW.active or B.stop or B.done then return end;local f_,g0=eT(a0,a2,ak,c0,c1)if not f_ then G("pulse direct depth snap..."..tostring(g0))return end;local g1=at(B.car)if not g1 or not aL(B.car)or math.abs(g1.Y-ak)>4 or math.sqrt((g1.X-a0)^2+(g1.Z-a2)^2)>4 then G("surface pulse return...")return end;B.lastDrivePos={x=g1.X,y=g1.Y,z=g1.Z}a6("5s pulse: checked...")end;local function ja(ai,c0,c1)local fb=B.surfaceGroundAt and B.surfaceGroundAt(ai.X,ai.Z,ai.Y+12) or eV(ai.X,ai.Z,ai.Y+7)if not fb then return nil end;local jb,hM=nil,1e9;for aa,jc in ipairs({1.6,3.2,5.0})do for aa,dz in ipairs({0,-2.5,2.5})do local bT=dZ(ai.X-c1*dz,fb+jc,ai.Z+c0*dz,c0,c1,t.DodgeLookahead or 35)local d7=bT and V(bT,"Instance")local aX=d7 and(tostring(V(d7,"Name")or"").." "..tostring(V(V(d7,"Parent"),"Name")or"")):lower()or""local dY=bT and V(bT,"Position")if dY and(aX:find("fence",1,true)or aX:find("brick",1,true))then local cF=math.sqrt((dY.X-ai.X)^2+(dY.Z-ai.Z)^2)if cF<hM then jb,hM=d7,cF end end end end;return jb,hM end;local function jd(ai,c0,c1,d7,cF)if not(B.car and aL(B.car)and B.autoDrive and B.autoDrive.active)then return false,"no owned seated car"end;local cM=eV(ai.X,ai.Z,ai.Y+7)local f7=o(function()return d7.Position.Y+d7.Size.Y*0.5 end)if not cM or not f7 or f7-cM>9 or f7-cM<0.8 then return false,"fence too tall or ground..."end;local je=ax(B.car)local jf,fe,a_=pcall(function()return B.car:GetBoundingBox()end)if not jf or not fe or not a_ or not je then return false,"vehicle clearance..."end;local jg=math.max(a_.X,a_.Z)*0.5;if cF<jg+2 then return false,"too close to lift..."end;local bQ=B.autoDrive.target;local jh=math.sqrt((bQ.x-ai.X)^2+(bQ.z-ai.Z)^2)local ji=cF+jg+5;if ji>math.min(52,jh-8)then return false,"no safe landing before..."end;local jj,jk=ai.X+c0*ji,ai.Z+c1*ji;local fb=eV(jj,jk,ai.Y+7)if not fb or math.abs(fb-cM)>2.5 then return false,"landing is not the same..."end;local jl=math.max(5,f7-cM+a_.Y*0.5+2-(ai.Y-cM))if jl>12 then return false,"fence requires an unsafe..."end;local T=o(function()return je:ToObjectSpace(fe)end)if not T then return false,"vehicle box orientation..."end;local function jm(a0,a1,a2)local fg=CFrame.lookAt(_(a0,a1,a2),_(a0+c0,a1,a2+c1))local q,cf=pcall(function()return x:GetPartBoundsInBox(fg*T,a_+_(0.3,0.3,0.3))end)if not q or type(cf)~="table"then return false end;for aa,ip in ipairs(cf)do local f5=o(function()return ip:IsDescendantOf(B.car)end)local f6=V(z,"Character")and o(function()return ip:IsDescendantOf(V(z,"Character"))end)local jn=o(function()return ip.Position.Y+ip.Size.Y/2 end)local jo=jn and jn<=cM+0.6;if not f5 and not f6 and not jo and V(ip,"CanCollide")~=false then return false end end;return true end;local jp={}for a7=1,3 do jp[#jp+1]={ai.X,ai.Y+jl*a7/3,ai.Z,0.1}end;local fJ=math.max(4,math.ceil(ji/6))for a7=1,fJ do local jq=ji*a7/fJ;jp[#jp+1]={ai.X+c0*jq,ai.Y+jl,ai.Z+c1*jq,math.max(0.08,ji/fJ/math.max(1,B.gameMaxSpeed or 65))}end;for a7=1,3 do jp[#jp+1]={jj,ai.Y+jl+(fb-cM)*a7/3-jl*a7/3,jk,0.1}end;for aa,S in ipairs(jp)do if not jm(S[1],S[2],S[3])then return false,"fence hop blocked by..."end end;a6("FENCE HOP: "..p(f7-cM).."-stud brick fence; "..p(ji).."-stud checked arc, no...")for aa,S in ipairs(jp)do if B.stop or B.done or not aL(B.car)then return false,"seat lost during fence hop"end;if not eS(S[1],S[2],S[3],c0,c1)then return false,"hop placement refused"end;k(S[4])local jr=at(B.car)if not jr or not aL(B.car)or math.sqrt((jr.X-S[1])^2+(jr.Z-S[3])^2)>4 or math.abs(jr.Y-S[2])>4 then return false,"server corrected hop or..."end end;local iT=at(B.car)B.autoDrive.progressAt,B.autoDrive.stuckAt,B.autoDrive.bestDist=d(),d(),nil;B.lastDrivePos=iT and{x=iT.X,y=iT.Y,z=iT.Z}or nil;B.avoid=nil;a6("FENCE HOP LANDED: seated="..tostring(aL(B.car)))return true end;local function js(cV)if B.autoDrive and B.autoDrive.connector then return false end;if B.routeMode~="Above ground"or B.underground or not B.car or not aL(B.car)then return false end;local fW=B.autoDrive;if not fW or not fW.active or not(fW.stage=="ATM"or fW.stage=="SHOP"or fW.stage=="FISH"or fW.stage=="SELL")then return false end;local f1=at(B.car)local fb=f1 and eV(f1.X,f1.Z,f1.Y+7)if not fb or math.abs(f1.Y-fb)>9 then return false end;fW.active,fW.done=false,true;B.speed=0;B.avoid=nil;pcall(function()anchorCar(true)end)a6("SURFACE CAR PARKED: "..tostring(cV).."; gliding on foot from...")if f1 then B.parkedCarPos={x=f1.X,z=f1.Z,y=f1.Y}end;if not B.liftStarted then B.liftStarted=true;i(function()local q,ci=pcall(I,fW.stage)if not q then G("surface on-foot callback: "..tostring(ci))end end)end;return true end;local jt=0;local function ju()if d()-jt<1.5 then return end;jt=d()if not B.car then return end;local aP=cu(B.car)local aM=aq()local bN=ao()if not(aP and aM and bN)then a6("NOT SEATED and no...")return end;local d8=V(aP,"Position")if not d8 or(a3(V(bN,"Position"),d8)or 1e9)>9 then a6("RESEAT refused: driver...")return end;pcall(function()aP:Sit(aM)end)a6("RESEAT attempt on "..tostring(V(aP,"Name")).." (sit="..tostring(V(aM,"Sit"))..")")end;local function jv(jw)if B.stop or B.localUnderTrip then return end;if B.autoDrive and (B.autoDrive.surfaceRecovering or B.autoDrive.connectorPlanning) then return end;jw=tonumber(jw)or 0.0167;if jw<=0 then jw=0.0167 end;if jw>t.SmoothMaxDt then jw=t.SmoothMaxDt end;if not B.car then return end;if B.surfacePulseActive or B.surfaceHopActive then return end;if not aL(B.car)then arenaRestoreSurfaceCollision();local az=aI(B.car)if az then pcall(function()az.AssemblyLinearVelocity=Vector3.new(0,0,0)end)end;if B.autoDrive and B.autoDrive.active then if not B.seatLostAt then B.seatLostAt=d()B.phase="RESEATING DRIVER"a6("SEAT LOST during travel;...")end;ju()if d()-B.seatLostAt>7 then B.autoDrive.active=false;G("driver seat lost during...")end end;return end;if B.seatLostAt then B.seatLostAt=nil;B.phase=(B.underground and"UNDERGROUND DRIVE TO "or"SURFACE DRIVE TO ")..tostring(B.stage)a6("DRIVER RESEATED; route...")end;local az=aI(B.car)if B.routeMode=="Above ground" and not B.underground then local hum=aq();local seat=hum and hum.SeatPart;if seat and seat:IsDescendantOf(B.car) then az=seat.AssemblyRootPart or seat end end;if not az then return end;for aa,av in ipairs(eU(B.car))do pcall(function()av.AssemblyAngularVelocity=Vector3.new(0,0,0)end)end;if B.done or B.stop or not B.autoDrive or not B.autoDrive.active then arenaRestoreSurfaceCollision();return end;arenaSurfaceNoclip();if B.autoDrive and B.autoDrive.mode=="path" then return end;local jx=B.autoDrive.timeout or t.DriveTimeout or 60;if d()-(B.autoDrive.started or 0)>jx then B.autoDrive.active=false;B.speed=0;local jy=B.autoDrive.stage or B.stage;B.driveRetry=(B.driveRetry or 0)+1;a6("AUTO DRIVE timeout after "..p(jx).."s on the "..tostring(jy).." leg ("..p(B.autoDrive.dist or-1).." studs) retry "..tostring(B.driveRetry).."/2")B.driveRetry=0;G("could not reach the "..tostring(jy).." destination; stopped...")pcall(function()az.AssemblyLinearVelocity=Vector3.new(0,0,0)end)return end;if B.speed<0 then B.speed=0 end;local ai=at(B.car)or V(az,"Position")local em,en=B.autoDrive.target.x,B.autoDrive.target.z;if not(ai and em and en)then return end;
 if not B.finiteVector(ai) or not B.finiteVector(az.AssemblyLinearVelocity) or not B.finiteVector(az.AssemblyAngularVelocity) or em~=em or en~=en then G("non-finite vehicle physics; reset character, respawn vehicle, and reload script");return end
 if not B.underground then
  local ground=eV(ai.X,ai.Z,ai.Y+7);local vy=az.AssemblyLinearVelocity.Y
  if ground and ai.Y-ground>(B.surfaceRideHeight or 2.5)+3 and vy>12 then
   B.autoDrive.active=false;B.speed=0;B.unsafeVehicleLatch=true
   pcall(function()az.AssemblyLinearVelocity=Vector3.new(0,math.min(0,vy),0);az.AssemblyAngularVelocity=Vector3.zero end)
   G("unsafe vehicle upward motion: stopped; allow the car to settle before restarting");return
  end
 end
 if B.underground and B.pinY and (math.abs(ai.Y-B.pinY)>8 or math.abs(az.AssemblyLinearVelocity.Y)>100) then
  G("unsafe underground vertical motion; stopped vehicle before uncontrolled flight");return
 end;local cP,cQ=em-ai.X,en-ai.Z;local a4=math.sqrt(cP*cP+cQ*cQ)local jz=B.lastDrivePos;if jz then local jA=math.sqrt((ai.X-jz.x)^2+(ai.Z-jz.z)^2)local aA=math.max(t.RubberBandStuds or 18,(B.speed or 60)*jw*2.5)if jA>aA then B.rbCount=(B.rbCount or 0)+1;C.rollbackCount,C.rollbackAt=B.rbCount,d()C.fromX,C.fromZ=jz.x,jz.z;C.toX,C.toZ=ai.X,ai.Z;C.jump,C.remaining=jA,a4;C.speedBefore,C.gameMax=B.speed,B.gameMaxSpeed;a6("SERVER PULLBACK #"..tostring(B.rbCount)..": "..p(jA).." studs; corrected car "..p(ai.X)..","..p(ai.Z).."; target still "..p(a4).." away")if B.rbCount>5 then B.autoDrive.active=false;G("server repeatedly...")return end;local g2=tonumber(B.gameMaxSpeed)or t.SpeedFallback or 65;B.speed=math.min(B.speed or 0,math.max(5,g2*0.18))C.speedAfter=B.speed;local fW=B.autoDrive;if B.rbCount>1 then fW.maxSpeed=math.min(fW.maxSpeed or g2,g2*0.75)end;fW.origin=ai;fW.started=d()fW.dist=a4;fW.timeout=math.max(fW.timeout or 0,a4/math.max(1,B.speed)*2+20)fW.bestDist,fW.progressAt,fW.stuckAt,fW.stuckCount=a4,d(),d(),0;fW.blockedAt=nil;fW.undergroundHopAt=d()B.lastDrivePos={x=ai.X,y=ai.Y,z=ai.Z}B.avoid,B.surfaceHop=nil,false;B.rbRecovery=true;B.surfacePulseAt=d()B.surfacePulseDue=d()+2;B.phase="RECOVERING SERVER..."..tostring(fW.stage)a6("PULLBACK RECOVERY:..."..tostring(fW.stage).." from "..p(B.speed).." studs/s; obstacle...")D(false)return end end;local ej=B.autoDrive.origin;if ej then local ek,el=ej.X or ej.x,ej.Z or ej.z;local eg,eh=em-ek,en-el;local eo=eg*eg+eh*eh;if eo>1 then local m=e(((ai.X-ek)*eg+(ai.Z-el)*eh)/eo,0,1)local c2=math.sqrt((ai.X-ek-eg*m)^2+(ai.Z-el-eh*m)^2)local jB=false;if B.autoDrive.surfaceWaypoints and c2>60 then
 local prevX,prevZ=ek,el
 for _,node in ipairs(B.autoDrive.surfaceWaypoints) do
  local dx,dz=node.x-prevX,node.z-prevZ;local denom=dx*dx+dz*dz
  local q=denom>0 and math.clamp(((ai.X-prevX)*dx+(ai.Z-prevZ)*dz)/denom,0,1) or 0
  if math.sqrt((ai.X-prevX-dx*q)^2+(ai.Z-prevZ-dz*q)^2)<45 then jB=true;break end
  prevX,prevZ=node.x,node.z
 end
end;if B.autoDrive.localTurn and c2<200 then jB=true end;if c2>60 and not jB then a6("OFF ROUTE "..p(c2).." studs; stopped before..."..tostring(B.autoDrive.stage).." target="..p(em)..","..p(en))B.autoDrive.active,B.busy,B.done,B.phase=false,false,true,"OFF ROUTE"D(true)return end end end;local jC=(B.underground or B.routeMode=="Above ground"and B.car)and math.max(3,math.min(8,(B.speed or 0)*jw+2)) or t.ArriveRadius;if B.underground then jC=1.25 elseif B.autoDrive.stage=="SHOP" and B.cashReadyFootShop and a4<=20 then jC=20 end
if (B.autoDrive.stage=="ATM" or B.autoDrive.stage=="PLANT_ATM") and B.autoDrive.connector and a4<=38 and aL(B.car) then
 local near=B.autoDrive
 if not near.atmStopPos or (ai-near.atmStopPos).Magnitude>2 then near.atmStopPos=ai;near.atmStopSince=d() end
 if d()-(near.atmStopSince or d())>=1.5 then
  jC=math.max(jC,a4+0.1);a6("ATM: connector blocked near parking; stopping here and approaching on foot")
 end
else B.autoDrive.atmStopPos=nil;B.autoDrive.atmStopSince=nil end
if a4<=jC then pcall(function()az.AssemblyLinearVelocity=Vector3.zero;az.AssemblyAngularVelocity=Vector3.zero end);B.autoDrive.active=false;B.autoDrive.done=true;C.active=false;C.arrivedAt=d()arenaRestoreSurfaceCollision();if B.fishUpright then pcall(function() B.fishUpright:Destroy();B.fishUprightAttachment:Destroy() end);B.fishUpright=nil;B.fishUprightAttachment=nil end;B.speed=0;B.avoid=nil;pcall(function()anchorCar(B.routeMode~="Above ground")end)pcall(function()az.AssemblyAngularVelocity=Vector3.new(0,0,0)end)pcall(function()az.AssemblyLinearVelocity=Vector3.new(0,0,0)end)local f0=B.autoDrive.stage or B.stage or"FISH"a6("ARRIVED at "..f0 .." spot (dist="..p(a4)..")")if not B.liftStarted then B.liftStarted=true;i(function()local q,ci=pcall(I,f0)if not q then a6("ON ARRIVE error: "..tostring(ci))end end)end elseif a4>0.001 then local e9=B.autoDrive;local c0,c1=cP/a4,cQ/a4;local fr=e9.surfaceWaypoints;local jD=a4;if fr then local jE=e9.roadIndex or 1;while jE<#fr do local cD=fr[jE]if math.sqrt((cD.x-ai.X)^2+(cD.z-ai.Z)^2)>14 then break end;jE=jE+1;e9.stuckAt,e9.progressAt,e9.bestDist=d(),d(),nil;a6("ROAD WAYPOINT "..jE.."/"..#fr.." (gate/house detour)")end;e9.roadIndex=jE;local jF=fr[jE]
 local connector=jF and jF.connector==true
 if connector~=e9.connector then e9.connector=connector;if connector then if e9.stage=="PLANT_ATM" or e9.stage=="PLANT_TRAVEL" then a6("PLANT PATH CONNECTOR: obstacle dodge OFF; stop if blocked") else a6("PATH CONNECTOR: obstacle dodge ON until recorded path or parking") end else e9.localTurn=nil;B.avoid=nil;e9.blockedAt=nil;a6("RECORDED PATH JOINED: obstacle dodge OFF")end end
 if jF and e9.stage=="SHOP" and a4<50 and not connector and not B.farmRequested then
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={B.car,z.Character};params.RespectCanCollide=true
 local origin=ai+Vector3.new(0,2,0);local direction=Vector3.new(jF.x-ai.X,0,jF.z-ai.Z)
 if direction.Magnitude>1 then local hit=x:Raycast(origin,direction,params);if hit and hit.Instance and hit.Instance.CanCollide then e9.active=false;arenaRestoreSurfaceCollision();G("shop approach blocked by "..hit.Instance.Name.."; car stopped outside instead of driving through a wall");return end end
end;if jF then local jG,jH=jF.x-ai.X,jF.z-ai.Z;jD=math.sqrt(jG*jG+jH*jH)if jD>0.01 then c0,c1=jG/jD,jH/jD end end end;local jI=B.lastDrivePos;if false then local jJ,hK=ja(ai,c0,c1)if jJ then e9.lastFenceTry=d()B.surfaceHopActive=true;pcall(function()az.AssemblyLinearVelocity=_(0,0,0)end)i(function()local cU,q,cV=pcall(jd,ai,c0,c1,jJ,hK)B.surfaceHopActive=false;if not cU or not q then local fY=cU and cV or q;a6("FENCE HOP REFUSED: "..tostring(fY).."; steering around instead")local jK,en=fh(at(B.car)or ai,c0,c1,e9,true)if jK then return end;if d()-(e9.lastFenceTry or 0)>8 then if js("fence and all car turns...")then return end;e9.active=false;G("fence blocks car route: "..tostring(fY))end end end)return end end;B.lastDrivePos={x=ai.X,y=B.pinY or ai.Y,z=ai.Z}
if e9.connector and e9.localTurn then
 local turn=e9.localTurn;local tx,tz=turn.x-ai.X,turn.z-ai.Z;local length=math.sqrt(tx*tx+tz*tz)
 if length<=6 then e9.localTurn=nil;a6("CONNECTOR DODGE: maneuver completed; resuming waypoint")
 elseif d()-(turn.at or d())>7 then e9.localTurn=nil;a6("CONNECTOR DODGE: maneuver timed out; replanning")
 else c0,c1=tx/length,tz/length end
end
if e9.connector then
 if e9.connectorBest==nil or a4<e9.connectorBest-4 then e9.connectorBest=a4;e9.connectorProgressAt=d() end
 if d()-(e9.connectorProgressAt or d())>7 then
  if e9.stage=="PLANT_ATM" or e9.stage=="PLANT_TRAVEL" then
   local body=B.car and (B.car:FindFirstChild("MD_BodyCollision",true) or B.car:FindFirstChild("Chassis",true))
   local clear=body and body:IsA("BasePart") and body.CFrame.UpVector.Y>=.85
   if clear then
    local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={B.car,z.Character};params.MaxParts=100
    local ok,hits=pcall(function()return workspace:GetPartBoundsInBox(body.CFrame,body.Size+Vector3.new(1,1,1),params)end)
    clear=ok;local bottom=body.Position.Y-body.Size.Y/2
    if ok then for _,part in ipairs(hits) do if part.CanCollide and part.Position.Y+part.Size.Y/2>bottom+1 then clear=false;break end end end
   end
   if not clear then
    e9.active=false;pcall(function()az.AssemblyLinearVelocity=Vector3.zero end);B.speed=0;B.unsafeVehicleLatch=true
    arenaRestoreSurfaceCollision();G("PLANT car overlaps obstacle; stopped: move or respawn car before restarting");return
   end
   a6("PLANT: connector blocked; trying a checked car-width path, smart dodge still off")
  end
  e9.connectorReplans=(e9.connectorReplans or 0)+1
  if e9.connectorReplans>2 then e9.active=false;pcall(function()az.AssemblyLinearVelocity=Vector3.zero end);arenaRestoreSurfaceCollision();G("connector stalled after two replans; stopped instead of oscillating");return end
  e9.connectorPlanning=true;pcall(function()az.AssemblyLinearVelocity=Vector3.zero end);B.speed=0
  local current=ai;local existing=e9.surfaceWaypoints;local idx=e9.roadIndex or 1
  local nextPoint=existing and existing[idx];local park=nextPoint and {x=nextPoint.x,z=nextPoint.z,y=e9.lastGround or eV(ai.X,ai.Z,ai.Y+7)} or e9.park
  if not park.y then park=e9.park end
  a6("CONNECTOR STALLED: no progress; planning car-width detour "..e9.connectorReplans.."/2")
  i(function()
   local ok,route=pcall(f8,current,park)
   if B.stop or B.done or B.autoDrive~=e9 or not e9.active then e9.connectorPlanning=false;return end
   if not ok or not route or #route==0 then e9.connectorPlanning=false;e9.active=false;B.unsafeVehicleLatch=true;arenaRestoreSurfaceCollision();G("connector blocked: no body-width detour; stopped without restoring overlapping collisions; check car position before restarting");return end
   for _,point in ipairs(route) do point.connector=true end
   if nextPoint and existing then
    for index=idx+1,#existing do route[#route+1]=existing[index] end
   end
   e9.surfaceWaypoints=route;e9.roadIndex=1;e9.localTurn=nil;e9.connectorBest=nil;e9.connectorProgressAt=d();e9.stuckAt=d();e9.stuckCount=0;e9.connectorPlanning=false
   pcall(B.arenaShowRouteVisual,current,route,e9.stage);a6("CONNECTOR REPLAN: "..#route.." obstacle-avoiding waypoints")
  end)
  return
 end
else e9.connectorBest=nil;e9.connectorProgressAt=nil;e9.connectorReplans=0 end
local ea=math.max(14,t.DodgeLookahead or 35)local jL=e1(ai,c0,c1,ea,true)if t.DodgeObstacles and e9.stage~="PLANT_ATM" and e9.stage~="PLANT_TRAVEL" and e9.connector==true and jL<ea-4 then if B.routeMode=="Above ground"and not B.underground then local jM,jN=fh(ai,c0,c1,e9,false)if jM then c0,c1=jM,jN;jL=e1(ai,c0,c1,ea,true)else if jL>6 then e9.blockedAt=nil else if js("wall blocks car route")then return end;e9.active=false;G("obstacle blocks vehicle...")return end end else e9.localTurn=nil;e9.blockedAt=nil end elseif a4<=t.ArriveRadius+4 then B.avoid=nil end;if(B.avoid or e9.localTurn)and jI then local fE=math.sqrt((ai.X-jI.x)^2+(ai.Z-jI.z)^2)if fE>0.5 then e9.stuckAt,e9.stuckCount,e9.progressAt=d(),0,d()end end;if e9.bestDist==nil or a4<e9.bestDist-8 then e9.bestDist,e9.stuckAt=a4,d()end;if d()-(e9.stuckAt or d())>6 then e9.stuckAt=d()e9.stuckCount=(e9.stuckCount or 0)+1;a6("STUCK "..tostring(e9.stuckCount).." - checking route progress")e9.localTurn=nil;if fr then
 e9.replanCount=e9.replanCount or 0
 if e9.stuckCount>=2 and e9.replanCount<2 then
  e9.replanCount=e9.replanCount+1;a6("TROUBLESHOOT: stalled; re-planning recorded route from current position, attempt "..e9.replanCount)
  local route=B.arenaRecordedRoute(ai,e9.park)
  if route and #route>0 then e9.surfaceWaypoints=route;e9.roadIndex=1;e9.stuckAt=d();e9.stuckCount=0;pcall(B.arenaShowRouteVisual,ai,route,e9.stage);return end
  a6("TROUBLESHOOT: no recorded path from current location")
 elseif e9.stuckCount>=3 then e9.active=false;G("car not progressing after "..e9.replanCount.." route replans; check Copy Report") return end
else local jK,en=fh(ai,c0,c1,e9,true)if jK then e9.blockedAt=nil;return end end;if d()-(e9.stuckAt or d())>25 then if js("no car-width route...")then return end;e9.active=false;G("all car directions...")end end;if e9.bestDist==nil or a4<e9.bestDist-6 then e9.bestDist,e9.progressAt=a4,d()end;local jO=d()-(e9.progressAt or 0)<t.StuckSwitchTime;if not jO and t.SmoothDrive and e9.mode~="smooth"then e9.mode="smooth"a6("DRIVE MODE -> SMOOTH:...".."stepped forward every...")end;local jP=math.max(12,tonumber(e9.brake)or 38)local jQ=math.max(5,tonumber(e9.accel)or 22)local fj=math.max(0,a4-jC)local jR=math.sqrt(2*jP*fj)if fr and(e9.roadIndex or 1)<#fr and jD<15 then jR=math.min(jR,math.max(18,jD*4))end;local ea=math.min(70,math.max(14,(B.speed or 0)*(B.speed or 0)/(2*jP)+10))local cG=e1(ai,c0,c1,ea,true)local jS=math.sqrt(2*jP*math.max(0,cG-(B.underground and 6 or 4)))local wanted=e9.connector and math.min(35,e9.maxSpeed or 32) or (e9.maxSpeed or 32);if B.underground then wanted=math.min(wanted,math.max(5,a4*3))end;local safeStop=math.max(7,wanted*jw+5);if e9.connector and cG<=safeStop then B.speed=0 else B.speed=wanted end;if d()-(e9.logAt or 0)>1.5 then e9.logAt=d()a6("DRIVE ["..tostring(e9.stage).."] left "..p(a4).." studs | dir "..p(c0)..", "..p(c1).." | car "..p(ai.X)..", "..p(ai.Z).." | mode="..(B.underground and"physics velocity"or tostring(e9.mode or"physics")).." | speed="..p(B.speed))end;if B.underground or B.routeMode=="Above ground" then e9.mode="physics" end;if e9.mode~="smooth"then c5()end;if e9.mode=="smooth"then if B.speed<=0.05 then e9.blockedAt=e9.blockedAt or d()if B.routeMode=="Above ground"and not B.underground and d()-(e9.lastZeroRecovery or 0)>0.5 then e9.lastZeroRecovery=d()e9.localTurn=nil;local jU,jV=fh(ai,c0,c1,e9,true)if jU then e9.blockedAt=nil;return end end;if d()-e9.blockedAt>12 then if js("no car-width route...")then return end;e9.active=false;G("all car directions...")end;return end;if B.underground then local c6=d()local jW=c6-(e9.undergroundHopAt or c6)if jW<0.2 then pcall(function()az.AssemblyLinearVelocity=_(0,0,0)end)return end;e9.undergroundHopAt=c6;pcall(function()az.AssemblyLinearVelocity=_(0,0,0)end)jw=math.min(jW,0.2)end;local jq=B.speed*jw;if jq<0.02 then jq=0.02 end;local jX=B.underground and math.min(28,(e9.maxSpeed or 70)*0.2)or(t.MaxStepPerFrame or 14)if jq>jX then jq=jX end;if jq>a4 then jq=a4 end;if t.DodgeObstacles then local cG=e1(ai,c0,c1,math.max(9,jq+6),true)if cG<jq+4 then jq=math.max(0,cG-4)if jq<0.02 then e9.blockedAt=e9.blockedAt or d()if d()-e9.blockedAt>1.4 then if js("obstacle too close for car")then return end;e9.active=false;G("obstacle too close;...")end;return end else e9.blockedAt=nil end end;local eA,eB=ai.X+c0*jq,ai.Z+c1*jq;C.commandAt,C.commandX,C.commandZ=d(),eA,eB;C.observedX,C.observedZ=ai.X,ai.Z;C.speed,C.gameMax=B.speed,B.gameMaxSpeed;if B.underground then local cG=e1(ai,c0,c1,math.max(9,jq+6),true)if cG<jq+4 then e9.blockedAt=e9.blockedAt or d()if d()-e9.blockedAt>1.6 then e9.active=false;G("buried wall blocks the...")end;return end;e9.blockedAt=nil;if not eS(eA,B.pinY or ai.Y,eB,c0,c1)then e9.active=false;G("underground teleport hop...")return end else local fb,jY=eV(eA,eB,ai.Y+7)local jZ=eV(ai.X,ai.Z,ai.Y+7)if not fb or not jZ or math.abs(fb-jZ)>3.5 then e9.blockedAt=e9.blockedAt or d()if d()-e9.blockedAt>2 then e9.active=false;G("unsafe surface step..."..tostring(jY))end;return end;e9.blockedAt=nil;local j_=fb+(B.surfaceRideHeight or 2.5)local fF=e9.localTurn and e9.localTurn.faceX or c0;local fG=e9.localTurn and e9.localTurn.faceZ or c1;if not fc(eA,j_,eB,fF,fG,fb)then e9.blockedAt=e9.blockedAt or d()e9.localTurn=nil;local jK,en=fh(ai,c0,c1,e9,true)if jK then return end;if d()-e9.blockedAt>15 then if js("gate/house blocks every...")then return end;e9.active=false;G("surface car width would...")return end;return end;if not eS(eA,j_,eB,fF,fG)then e9.active=false;G("surface car move refused")return end end else if not e9.physicsUnanchored then pcall(function()anchorCar(false)end)e9.physicsUnanchored=true end;pcall(function()
 local hum=aq();local seat=hum and hum.SeatPart
 local relative=(seat and seat:IsDescendantOf(B.car)) and az.CFrame:ToObjectSpace(seat.CFrame).Rotation or CFrame.identity
 local wanted=CFrame.lookAt(Vector3.zero,Vector3.new(c0,0,c1))*relative:Inverse()
 az.CFrame=CFrame.new(az.Position)*wanted
 az.AssemblyAngularVelocity=Vector3.zero
end);pcall(function()local vy=az.AssemblyLinearVelocity.Y;if B.underground and B.pinY then vy=math.clamp((B.pinY-ai.Y)*3,-12,12) elseif B.routeMode=="Above ground" then arenaSurfaceNoclip();local probe=math.max(ai.Y+10,(e9.lastGround or ai.Y)+12);local ground;if B.surfaceGroundAt then ground=B.surfaceGroundAt(ai.X,ai.Z,probe) else ground=eV(ai.X,ai.Z,probe) end
 if not ground or e9.lastGround and math.abs(ground-e9.lastGround)>12 then B.autoDrive.active=false;arenaRestoreSurfaceCollision();G("surface glide stopped: no consistent road ground");return end
 if B.surfaceGroundAt and e9.lastGround and ground>e9.lastGround+3 then
  local lower=B.surfaceGroundAt(ai.X,ai.Z,e9.lastGround+2.5)
  if lower and math.abs(lower-e9.lastGround)<2 then
   a6("ROAD PROBE: high obstruction ignored for vertical road sampling; horizontal safety remains active")
   ground=lower
  end
 end
 if B.surfaceGroundAt and e9.lastGround and ground>e9.lastGround+3 then
  local left=B.surfaceGroundAt(ai.X-c1*6,ai.Z+c0*6,probe);local right=B.surfaceGroundAt(ai.X+c1*6,ai.Z-c0*6,probe)
  if left and right and math.abs(left-right)<1.5 and math.max(left,right)<ground-2 and math.abs((left+right)/2-e9.lastGround)<3 then
   if not e9.roadOutlierAt or d()-e9.roadOutlierAt>1 then e9.roadOutlierAt=d();a6("ROAD PROBE: narrow raised surface="..p(ground).."; side road="..p((left+right)/2))end
   ground=(left+right)/2
  else
   e9.active=false;B.speed=0;pcall(function()az.AssemblyLinearVelocity=Vector3.zero;az.AssemblyAngularVelocity=Vector3.zero end);arenaRestoreSurfaceCollision()
   G("ground rose abruptly near obstacle; stopped instead of climbing building (previous="..p(e9.lastGround).." sampled="..p(ground)..")");return
  end
 end
 e9.lastGround=ground;local ride=B.surfaceRideHeight or 2.5
 if ai.Y>ground+ride+7 then if not e9.highSince then e9.highSince=d() end;if d()-e9.highSince>2 then e9.active=false;B.speed=0;pcall(function()az.AssemblyLinearVelocity=Vector3.zero end);arenaRestoreSurfaceCollision();G("car remained above road; stopped to prevent flying");return end else e9.highSince=nil end
 if ai.Y<ground-2 then
  if not e9.belowSince then e9.belowSince=d();a6("ROAD RECOVERY: below sampled road; attempting bounded upward motion, no teleport")end
  B.speed=math.min(B.speed,8)
  if d()-e9.belowSince>3 then e9.active=false;arenaRestoreSurfaceCollision();G("road recovery timed out: carY="..p(ai.Y).." sampledRoad="..p(ground).."; stopped safely");return end
 else e9.belowSince=nil end
 vy=math.clamp((ground+ride-ai.Y)*5,-35,35) end;az.AssemblyLinearVelocity=Vector3.new(c0*B.speed,vy,c1*B.speed)end);if B.routeMode=="Above ground" and (not e9.diagAt or d()-e9.diagAt>2) then e9.diagAt=d();local own="unknown";if type(isnetworkowner)=="function" then local q,val=pcall(isnetworkowner,az);if q then own=tostring(val) end end;local vv=az.AssemblyLinearVelocity;a6("SURFACE PHYSICS root="..Y(az).." anchored="..tostring(az.Anchored).." owner="..own.." velocity="..p(vv.X)..","..p(vv.Y)..","..p(vv.Z).." wanted="..p(B.speed).." noclip="..tostring(B.arenaSurfaceParts~=nil)) end end end end;local function k0()if B.busy then j3()return false end;local startRoot=ao();if startRoot and startRoot.Position.Y < -500 then B.farmRequested=false;B.lastFailure="character below map; reset character before restarting";B.phase="PAUSED: RESET CHARACTER";a6("VOID SAFETY: start refused below map; reset character first");return false end;if B.stopDevTrail then B.stopDevTrail(false)end;if B.stopFreecam then B.stopFreecam()end;
 if not B.spotChoice or (B.spotChoice~="auto" and not B.levelFishingSpots[tonumber(B.spotChoice)]) or (B.spotChoice=="auto" and not B.resolveSpotTier()) then
  B.waitingForSpot=true;B.busy=false;B.stop=false;B.done=false;B.lastFailure=nil
  B.phase="WAITING: CHOOSE FISHING SPOT";a6("AUTO FARM waiting: choose a fishing level; vehicle startup will begin after selection")
  pcall(function()P("Choose a fishing spot","Select Level 0, 10, 20 or 30. Auto Farm will start automatically.")end)
  D(false);return false
 end
 B.waitingForSpot=false
 B.manualUnderground=false;
 B.atmRoutePending=false
 if B.car and not B.finiteVector(at(B.car)) then G("non-finite vehicle physics; reset character, respawn vehicle, and reload script");return false end;
 if B.unsafeVehicleLatch and B.car then
  local pos=at(B.car);local frame=ax(B.car);local ground=pos and eV(pos.X,pos.Z,pos.Y+7);local root=aI(B.car);local vel=root and root.AssemblyLinearVelocity
  if not pos or not ground or not frame or frame.UpVector.Y<.85 or math.abs(pos.Y-ground)>7 or not vel or math.abs(vel.Y)>2 then
   G("unsafe vehicle: car is not settled upright on dry ground; wait or respawn it before restarting");return false
  end
  B.unsafeVehicleLatch=false;a6("VEHICLE SAFETY: settled upright on ground; restart permitted")
 end;if B.underground and B.farmMode=="Sky" then
 local pos=at(B.car);local ground=pos and eV(pos.X,pos.Z,pos.Y+8)
 if pos and ground and pos.Y>=ground-2 and pos.Y<=ground+12 then B.underground=false;B.pinY=nil;B.driveY=nil;if B.releaseUnderFloor then B.releaseUnderFloor()end
 else G("return the vehicle to the surface before switching to Sky");return false end
 end;B.resupply=false;B.runSerial=(B.runSerial or 0)+1;local runSerial=B.runSerial;B.pendingInstaSell=nil;B.instaSellTrip=false;if B.walkRecording then a6("START refused: tap walk...")return false end;B.walkedFromAtm=false;B.cashReadyFootShop=false;B.shopEntryTrail=nil;B.stop,B.done,B.busy,B.seated=false,false,true,false;B.phase="STARTING"B.lastFailure=nil;B.results,B.events,B.notes={},{},{}B.casts,B.reels,B.bites,B.caught=0,0,0,0;B.autoFish,B.autoFishStarted,B.castActive,B.recastPending=false,false,false,false;B.rodBought,B.baitBought,B.rodEquipped,B.baitEquipped=false,false,false,false;B.cheapestRod,B.cheapestBait,B.shopFeedback=B.selectedRod,B.selectedBait,{}B.shopDone,B.shopAttempted,B.snapped=false,false,false;B.smartStarted,B.driveRetry,B.carYaw,B.bank=false,0,0,tonumber(o(function()return z:GetAttribute("MD_Bank")end))B.gameMaxSpeed,B.speedSource=nil,"none"B.driveInputs,B.lastDriveInput,B.facingTicks=0,0,0;B.minigameEvents={}if B.underFloor and not B.underground and B.releaseUnderFloor then B.releaseUnderFloor()end;B.activeFarmMode="Underground";if B.activeFarmMode=="Sky" and B.savedSkyCastTarget then B.castTarget=B.savedSkyCastTarget;B.savedSkyCastTarget=nil end;B.routeMode="Above ground";t.UndergroundMode=false;a6("FARM MODE: "..B.activeFarmMode.."; car multiplier "..p(t.CarSpeedMultiplier).."; acceleration "..tostring(t.AccelerationOn))if not by()then a6("AUTO FISH aborted - no...")B.busy,B.done=false,true;D(true)E()return false end;
 local cost=math.ceil(H.moneyNeeded());local key=tostring(B.baitQty or t.BaitQty)..":"..tostring(B.selectedBait and B.selectedBait.name)..":"..tostring(B.selectedRod and B.selectedRod.name)..":"..tostring(cost)
 if cost>=500 and B.approvedPurchaseKey~=key then
  if B.pendingPurchaseKey==key then B.approvedPurchaseKey=key;B.pendingPurchaseKey=nil;a6("PURCHASE CONFIRMED: "..p(cost).." for "..tostring(B.baitQty or t.BaitQty).." bait and any missing rod")
  else B.pendingPurchaseKey=key;G("purchase confirmation required: estimated $"..p(cost).." for "..tostring(B.baitQty or t.BaitQty).." bait; adjust quantity or toggle Auto Farm off and on again to approve");return false end
 end
 B.busy=true;B.startupSerial=runSerial;i(function()while B.busy or B.autoFish do pcall(H.watchMoney)k(1.0)end end)D(false)local q,ci=pcall(function()eN()B.phase="CHECK OWNED VEHICLE OR WALK"
 if B.inUnderFish then local returned,reason=B.returnMarkedFishSurface();if not returned then G("return from fishing spot: "..tostring(reason));return end end
 if B.travelMode=="Teleport" then
  local hum=aq();if hum and hum.SeatPart then hum.Sit=false;hum.Jump=true;k(.5);if hum.SeatPart then G("teleport mode: exit seat before starting");return end end
  B.car=nil;B.inUnderFish=false;B.smartStarted=true;pcall(H.validateTargets);a6("TELEPORT MODE: character only; vehicle spawn and boarding skipped")
  if not H.goShopOrFish("start") and B.phase~="FAILED" then G("teleport startup failed")end;return
 end
 local spawned=cd();if B.stop or B.runSerial~=runSerial then return end;B.car=spawned
 if not B.car then G("vehicle spawn not confirmed; check cooldown and respawn vehicle");return end
 do
  local position=at(B.car);local character=ar();local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={B.car,z.Character};params.IgnoreWater=true;params.RespectCanCollide=true
  local checked,hit=pcall(function()return position and x:Raycast(position+Vector3.new(0,8,0),Vector3.new(0,-30,0),params)end)
  if not position or not character or math.abs(position.Y-character.Y)>35 or not checked or not hit or hit.Normal.Y<.6 or position.Y-hit.Position.Y < -2 or position.Y-hit.Position.Y>12 then
   G("unsafe vehicle spawn: car not on a verified nearby surface; respawn it before restarting");return
  end
 end
 if B.car then
 local scanOk,scanWhy=B.scanVehicle(B.car);if not scanOk then G("vehicle scan failed: "..tostring(scanWhy));return end
 local k1=dt(B.car);if B.stop or B.runSerial~=runSerial then return end;if not k1 then G("vehicle boarding not confirmed; check driver prompt and try again");return else bZ()end end;if B.activeFarmMode~="Underground" then B.underground,B.pinY,B.driveY=false,nil,nil end;B.surfacePulseActive,B.surfacePulseDue=false,nil;a6(B.car and"OWNED CAR: "..tostring(V(B.car,"Name")).."; checked underground route"or"ON FOOT: no car required")pcall(H.validateTargets)if not B.smartStarted then B.smartStarted=true;if not H.goShopOrFish("start")then if B.phase=="FAILED" then return else error("smart start failed: "..tostring(B.lastFailure or B.lastRouteFailure or "unknown"))end end elseif not fR(B.shopTarget,"SHOP")then error("shop drive failed")end end)if B.startupSerial==runSerial then B.startupSerial=nil end;if not q then a6("RUN ALL failed: "..tostring(ci));if not B.lastFailure then B.lastFailure=tostring(ci) end;B.busy,B.done,B.phase=false,true,"FAILED"D(true)E()return false end;E()return true end;local function k2()if B.busy or B.autoFish then j3()else i(function()local ok,err=pcall(k0);if not ok then G("START ERROR: "..tostring(err)) end end)end end;local function k3()if B.busy or B.autoFish or B.snapTesting then a6("SNAP TEST refused: stop...")return end;B.snapTesting=true;local aM=aq()local aP=aM and V(aM,"SeatPart")local au=aP and aO(aP)if not au or not b3(au)or not aL(au)then a6("SNAP TEST refused: sit...")B.snapTesting=false;return end;local k4,k5,k6=B.car,B.stop,B.surfacePulseActive;B.car,B.stop,B.surfacePulseActive=au,false,true;local cE=at(au)local cM=cE and eV(cE.X,cE.Z,cE.Y+7)if not cE or not cM or cE.Y<cM-2 or cE.Y>cM+12 then a6("SNAP TEST refused: no...")B.car,B.stop,B.surfacePulseActive=k4,k5,k6;B.snapTesting=false;return end;local ah=ax(au)local ea=ah and ah.LookVector;local c0,c1=ea and ea.X or 0,ea and ea.Z or 1;local ak=cM-(t.UnderFloorClearance or 16)local q,cV=eT(cE.X,cE.Z,ak,c0,c1)k(1.75)local fK=at(au)local k7=q and fK and math.abs(fK.Y-ak)<=3 and aL(au)local k8=fK and math.sqrt((fK.X-cE.X)^2+(fK.Z-cE.Z)^2)>4;local k9=fK and not k8 and math.abs(fK.Y-cE.Y)<=3 and aL(au)if fK and not k8 and not k9 and aL(au)then local fb=eV(cE.X,cE.Z,cE.Y+7)if fb and math.abs(fb-cM)<=2 then k9=eT(cE.X,cE.Z,cE.Y,c0,c1)end end;local ka="OWNED CAR SNAP TEST "..U().."\ncar="..Y(au).."\nstartY="..p(cE.Y).." targetY="..p(ak).."\nafter2sY="..p(fK and fK.Y).." clientHeld2s="..tostring(k7).."\nserverCorrectedAway="..tostring(k8).."\nrestored="..tostring(k9).." reason="..tostring(cV).."\nClient position is not..."pcall(function()if type(writefile)=="function"then writefile("auto_fish_snap_test.txt",ka)end end)iV(ka)a6("SNAP TEST copied:..."..tostring(k7).." restored="..tostring(k9))B.car,B.stop,B.surfacePulseActive=k4,k5,k6;B.snapTesting=false end;local function kb()if B.busy then a6("BUY KIT skipped - run in...")return false end;B.phase="MANUAL SHOP BUY"gb()if not ge()then return false end;local q=gQ()if not q then G("manual shop buy incomplete")end;return q end;D=function(kc,kd)B.lastMsg=tostring(B.phase).." | "..tostring(B.stage).." | casts "..tostring(B.casts).." caught "..tostring(B.caught)pcall(E)if kc and B.devEnabled then local q,bq=pcall(iX)if q and type(bq)=="string"then pcall(function()if type(writefile)=="function"then writefile(t.ReportFile,bq)end end)if kd then pcall(iW,bq)end end end end;E=function()local aP=B.car and(aL(B.car)and"YES"or"no")or"ON FOOT"local ke=B.autoDrive and B.autoDrive.mode or"-"local bD=("%s | %s | speed=%s | drive=%s | seat=%s"):format(tostring(B.phase),tostring(B.stage),p(B.gameMaxSpeed or B.speed),tostring(ke),aP)local kf=("casts=%d reels=%d bites=%d caught=%d | foot=%d | %s"):format(B.casts,B.reels,B.bites,B.caught,t.GlideSpeed,tostring(B.routeMode or t.RouteMode))if K.statusP then pcall(function()K.statusP:SetDesc(bD.."\n"..kf)end)end;if K.msgP then pcall(function()K.msgP:SetDesc(tostring(B.lastMsg))end)end;if M then M.Text=bD.." | casts="..tostring(B.casts)end;if N then N.Text=(B.busy or B.autoFish)and"STOP"or"START / STOP (BACKUP)"end end;local kg="autofish_original_drix_wi..."local function kh(a8)B.windProblem=tostring(a8)a6("WindUI ERROR: "..B.windProblem)end;local ki={"https://github.com/Footag...","https://github.com/Footag..."}local function kj(h)return type(h)=="string"and#h>1000 and h:find("CreateWindow",1,true)~=nil end;local function kk(kl)local km=r()local function kn(j)if type(j)~="function"then return nil end;local q,bh=pcall(j,{Url=kl,Method="GET",Headers={Accept="text/plain"}})if q and type(bh)=="table"then local ko=bh.Body or bh.body;if kj(ko)then return ko end end;return nil end;local kp={function()return type(km)=="table"and rawget(km,"request")end,function()return type(km)=="table"and rawget(km,"http_request")end,function()return request end,function()return http_request end,function()return syn and syn.request end,function()return http and http.request end}for aa,kq in ipairs(kp)do local q,j=pcall(kq)local ko=q and kn(j)if ko then return ko end end;local kr={function()return game:HttpGet(kl)end,function()return game:HttpGet(kl,true)end,function()return game:GetService("HttpService"):GetAsync(kl)end}for aa,j in ipairs(kr)do local q,ko=pcall(j)if q and kj(ko)then return ko end end;return nil end;local function ks(kt)local ku=o(function()local s=r()return type(s)=="table"and rawget(s,"ArenaBundledWindUI")end)if kj(ku)then return ku end;local bw;if not kt then pcall(function()if type(isfile)=="function"and type(readfile)=="function"and isfile(kg)then local c_=readfile(kg)if kj(c_)then bw=c_ end end end)end;if bw then a6("WindUI: using the cached...")return bw end;for aa,kv in ipairs(ki)do bw=kk(kv)if bw then a6("WindUI: downloaded from "..kv)pcall(function()if type(writefile)=="function"then writefile(kg,bw)end end)return bw end end;return nil end;local function kw(kt)local s=r()if not kt and type(s)=="table"and type(s.WindUI)=="table"and type(s.WindUI.CreateWindow)=="function"then a6("WindUI: reusing...")return s.WindUI end;local bw=ks(kt)if not bw then kh("source unavailable via...")return nil end;local kx=loadstring or load;if type(kx)~="function"then kh("executor has no loadstring")return nil end;local ky="local DRIX_TI=function()..."..bw:gsub("TweenInfo%.new%(","DRIX_TI(")local q,j=pcall(kx,ky)local cU,kz=false,nil;if q and type(j)=="function"then cU,kz=pcall(j)end;if not cU or type(kz)~="table"then q,j=pcall(kx,bw)if not q or type(j)~="function"then kh("library compilation "..tostring(j))return nil end;cU,kz=pcall(j)end;if cU and type(kz)=="table"and type(kz.CreateWindow)=="function"then pcall(function()if type(s)=="table"then s.WindUI=kz end end)a6("WindUI: official library...")return kz end;kh("library execution "..tostring(kz))return nil end;local function kA(ab)ab=math.max(1,math.min(100,math.floor(tonumber(ab)or t.BaitQty)))if B.baitQty==ab then return end;B.baitQty=ab;if B.selectedBait or B.selectedRod then local wallet=H.readCashNumber();local bank=tonumber(z:GetAttribute("MD_Bank")) or tonumber(B.bank);local cost=H.moneyNeeded();if wallet and bank and wallet+bank<cost then if B.notifyNotEnough then B.notifyNotEnough()end;B.phase="Not enough money!";a6("Not enough money! Need $"..p(cost).."; wallet + bank $"..p(wallet+bank));D(false)end end;if K.sliderLbl then pcall(function()K.sliderLbl:SetDesc("buying "..tostring(ab).." bait per trip")end)end;if O then O.Text="BAIT TO BUY: "..tostring(ab)end;a6("BAIT: buying "..tostring(ab).." per shop trip")end;local kB=""local function kC(fY,kD)local kE={"AUTO FISH..."..a,"reason="..tostring(fY).." time="..U(),"player="..tostring(V(z,"Name")).." id="..tostring(V(z,"UserId"))}local function iY(m)if#kE<180 then kE[#kE+1]=tostring(m)end end;local ap=V(z,"Character")local aM=aq()local aP=aM and V(aM,"SeatPart")iY("seat="..(aP and Y(aP)or"none").." Sit="..tostring(aM and V(aM,"Sit")))local kF=aP and aO(aP)iY("seat vehicle model="..(kF and Y(kF)or"none").." ownerVerified="..tostring(kF and b3(kF)))if kF and b3(kF)and aL(kF)then B.car=kF;a6("AUTO VEHICLE SCAN:..."..tostring(V(kF,"Name")))end;for aa,az in ipairs({V(z,"Backpack"),ap})do if az then local kG={}local bc=o(function()return az:GetChildren()end)or{}for bd=1,math.min(#bc,80)do local W=bc[bd]if tostring(V(W,"ClassName"))=="Tool"then kG[#kG+1]=tostring(V(W,"Name"))end end;iY("inventory "..Y(az).." tools="..table.concat(kG,", "))end end;local ck=V(z,"PlayerGui")for aa,kH in ipairs({{z,"Inventory"},{z,"Vehicles"},{z,"Cars"},{ck,"MD_ItemsGui"},{ck,"MD_CarGarageGui"}})do local az=kH[1]and o(function()return kH[1]:FindFirstChild(kH[2])end)if az then local kI={}local bc=o(function()return az:GetChildren()end)or{}for bd=1,math.min(#bc,35)do local aG=bc[bd]kI[#kI+1]=tostring(V(aG,"Name")).."("..tostring(V(aG,"ClassName"))..")"end;iY("inventory root "..Y(az).." children="..table.concat(kI,","))end end;local d6=0;local b9=ar()local q,aU=pcall(function()return b9 and x:GetPartBoundsInRadius(b9,180)end)local al={}if q and type(aU)=="table"then for a7=1,math.min(#aU,500)do local d7=aU[a7]local aQ=d7;for aa=1,6 do if not aQ or aQ==x then break end;if tostring(V(aQ,"ClassName"))=="VehicleSeat"and not al[aQ]then al[aQ]=true;d6=d6+1;if d6<=10 then local au=aO(aQ)local b0=au and o(function()return au:GetAttributes()end)or{}local kJ={}for X,f in pairs(b0)do if tostring(X):lower():find("owner",1,true)then kJ[#kJ+1]=tostring(X).."="..tostring(f)end end;iY("nearby seat "..d6 .." "..Y(aQ).." model="..(au and Y(au)or"none").." ownerOK="..tostring(au and b3(au)).." occupant="..tostring(V(aQ,"Occupant")).." ownerAttrs="..table.concat(kJ,","))end end;aQ=V(aQ,"Parent")end end end;iY("raw vehicle seats nearby="..d6)local kK=b7()iY("verified nearby vehicle..."..#kK)for a7=1,math.min(#kK,8)do local au=kK[a7]local kL=o(function()return au:FindFirstChildWhichIsA("VehicleSeat",true)end)local iD=at(au)local b0=o(function()return au:GetAttributes()end)or{}local kJ={}for X,f in pairs(b0)do local bb=tostring(X):lower()if bb:find("owner",1,true)or bb:find("speed",1,true)or bb:find("driver",1,true)then kJ[#kJ+1]=tostring(X).."="..tostring(f)end end;iY("car "..a7 .." "..Y(au).." seat="..(kL and Y(kL)or"none").." occupant="..tostring(kL and V(kL,"Occupant")).." dist="..p(a3(ar(),iD)or-1).." attrs="..table.concat(kJ,","))end;if not kF and#kK==0 then iY("No verified car: unknown...")end;kB=table.concat(kE,"\n")pcall(function()if type(writefile)=="function"then writefile("auto_fish_vehicle_scan.txt",kB)end end)if kD then local j1=iV(kB)a6("VEHICLE SCAN copied="..tostring(j1).." "..#kB.." chars")end;return kB end;local kM=0;local function kN(fY,eI)local c6=d()if not eI and c6<kM then return end;kM=c6+1.5;i(function()k(eI and 0.1 or 0.6)pcall(kC,fY,false)end)end;local function kO(kP)local aM=kP and o(function()return kP:FindFirstChildOfClass("Humanoid")end)if not aM then return end;pcall(function()aM:GetPropertyChangedSignal("SeatPart"):Connect(function()kN("seat changed",true)end)end)end;pcall(function()z.CharacterAdded:Connect(function(ap)k(0.5)kO(ap)kN("respawn")end)end)kO(V(z,"Character"))pcall(function()x.DescendantAdded:Connect(function(W)if tostring(V(W,"ClassName"))=="VehicleSeat"then kN("vehicle seat spawned")task.delay(2,function()kN("vehicle settled")end)end end)end)task.delay(1,function()pcall(kC,"execution",false)end)local function kQ(kR,kz)local kS,kT,kU=kR,kz,120412740818179;local cp=gethui and gethui()or game:GetService("CoreGui")local cS=cp:FindFirstChild("drixAutoFishOpenUI")if cS then cS:Destroy()end;local kV=Instance.new("ScreenGui")kV.Name,kV.ResetOnSpawn,kV.IgnoreGuiInset,kV.DisplayOrder="drixAutoFishOpenUI",false,true,-100000;kV.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;pcall(function()kV.ScreenInsets=Enum.ScreenInsets.None end)if not pcall(function()kV.Parent=cp end)then kV.Parent=z:WaitForChild("PlayerGui")end;local kW=kU~=0 and"rbxthumb://type=Asset&id="..kU.."&w=150&h=150"or""local kX=Color3.fromRGB(125,22,24)local function kY(W,bh)Instance.new("UICorner",W).CornerRadius=bh end;local function kZ(k_,a_,bh)local l0=Instance.new("ImageLabel")l0.Size,l0.BackgroundColor3,l0.BorderSizePixel=a_,Color3.fromRGB(40,8,10),0;l0.ScaleType,l0.Image,l0.Parent=Enum.ScaleType.Crop,kW,k_;kY(l0,bh)if kW==""then local m=Instance.new("TextLabel",l0)m.Size,m.BackgroundTransparency,m.Text=UDim2.fromScale(1,1),1,"D"m.Font,m.TextScaled,m.TextColor3=Enum.Font.GothamBlack,true,Color3.new(1,1,1)end;return l0 end;local l1=Instance.new("TextButton")l1.Name,l1.Text,l1.AutoButtonColor="Pill","",false;l1.Size=UDim2.fromOffset(214,40)l1.AnchorPoint=Vector2.new(0.5,0)l1.Position=UDim2.new(0.5,0,0,12)l1.BackgroundColor3,l1.BackgroundTransparency=Color3.new(0,0,0),0.3;l1.Parent=kV;kY(l1,UDim.new(1,0))local l2=Instance.new("UIStroke",l1)l2.Color,l2.Thickness,l2.ApplyStrokeMode=kX,2,Enum.ApplyStrokeMode.Border;local l3=Instance.new("ImageLabel")l3.Size,l3.Position,l3.AnchorPoint=UDim2.fromOffset(18,18),UDim2.new(0,22,0.5,0),Vector2.new(0.5,0.5)l3.BackgroundTransparency,l3.ImageColor3,l3.ImageTransparency=1,Color3.fromRGB(150,150,155),0.15;l3.Parent=l1;if not pcall(function()local l4=kT.Creator.Icon("move")l3.Image=l4[1]l3.ImageRectSize=l4[2].ImageRectSize;l3.ImageRectOffset=l4[2].ImageRectPosition end)or l3.Image==""then l3.BackgroundTransparency=1;local m=Instance.new("TextLabel",l3)m.Size,m.BackgroundTransparency,m.Text=UDim2.fromScale(1,1),1,"✥"m.TextScaled,m.TextColor3=true,Color3.fromRGB(150,150,155)end;local l5=Instance.new("Frame")l5.Size,l5.Position=UDim2.new(0,1,1,0),UDim2.fromOffset(44,0)l5.BackgroundColor3,l5.BackgroundTransparency,l5.BorderSizePixel=Color3.fromRGB(70,70,75),0.3,0;l5.Parent=l1;local l6=kZ(l1,UDim2.fromOffset(24,24),UDim.new(0,5))l6.AnchorPoint,l6.Position=Vector2.new(0,0.5),UDim2.new(0,56,0.5,0)local l7=Instance.new("TextLabel")l7.BackgroundTransparency,l7.Text=1,"drixnvsp | AUTO FISH"l7.Size,l7.Position=UDim2.new(1,-92,1,0),UDim2.fromOffset(88,0)l7.TextColor3,l7.TextSize,l7.TextXAlignment=Color3.new(1,1,1),15,Enum.TextXAlignment.Center;l7.Font=Enum.Font.GothamMedium;pcall(function()l7.Font=Enum.Font.BuilderSansMedium;l7.TextSize=16 end)l7.Parent=l1;local l8=Instance.new("ImageButton")l8.Name,l8.AutoButtonColor="Square",true;l8.Size=UDim2.fromOffset(30,30)l8.AnchorPoint=Vector2.new(0.5,0)l8.BackgroundColor3,l8.BackgroundTransparency=Color3.fromRGB(12,12,14),0;l8.Parent=kV;kY(l8,UDim.new(0,8))local l9=Instance.new("UIStroke",l8)l9.Color,l9.Thickness,l9.ApplyStrokeMode=Color3.fromRGB(30,30,34),2,Enum.ApplyStrokeMode.Border;local la=kZ(l8,UDim2.fromScale(1,1),UDim.new(0,8))la.Active=false;local lb=false;local function lc(cm,ld,le)local lf,iI,lg,fS=false,false,nil,nil;cm.InputBegan:Connect(function(a7)if a7.UserInputType==Enum.UserInputType.MouseButton1 or a7.UserInputType==Enum.UserInputType.Touch then lf,iI,lg,fS=true,false,a7.Position,cm.Position;a7.Changed:Connect(function()if a7.UserInputState==Enum.UserInputState.End and lf then lf=false;if not iI then pcall(ld)elseif le then le()end end end)end end)w.InputChanged:Connect(function(a7)if lf and(a7.UserInputType==Enum.UserInputType.MouseMovement or a7.UserInputType==Enum.UserInputType.Touch)then local a4=a7.Position-lg;if a4.Magnitude>6 then iI=true end;if iI then cm.Position=UDim2.new(fS.X.Scale,fS.X.Offset+a4.X,fS.Y.Scale,fS.Y.Offset+a4.Y)end end end)end;lc(l1,function()kS:Open()end)do local g1,dn,lg,fS,lh,li,lj=false,0,nil,nil,false,false,false;local ct=Instance.new("UIScale",l8)l8.InputBegan:Connect(function(a7)if a7.UserInputType~=Enum.UserInputType.MouseButton1 and a7.UserInputType~=Enum.UserInputType.Touch then return end;g1,dn,lg,fS,lh,li,lj=true,os.clock(),a7.Position,l8.Position,false,false,false;local c9=dn;task.delay(1,function()if g1 and dn==c9 and not li then lh=true;ct.Scale=1.12;l9.Color=Color3.fromRGB(200,200,205)end end)a7.Changed:Connect(function()if a7.UserInputState==Enum.UserInputState.End and g1 then g1=false;ct.Scale=1;l9.Color=Color3.fromRGB(30,30,34)if lj then lb=true elseif not lh and not li then pcall(function()kS:Toggle()end)end end end)end)w.InputChanged:Connect(function(a7)if not g1 or a7.UserInputType~=Enum.UserInputType.MouseMovement and a7.UserInputType~=Enum.UserInputType.Touch then return end;local a4=a7.Position-lg;if not lh then if a4.Magnitude>10 then li=true end;return end;if not lj then lj=true;lg=a7.Position;fS=l8.Position;a4=Vector3.zero end;l8.Position=UDim2.new(fS.X.Scale,fS.X.Offset+a4.X,fS.Y.Scale,fS.Y.Offset+a4.Y)end)end;local lk;lk=v.Heartbeat:Connect(function()if not kV.Parent or kS.Destroyed then if lk then lk:Disconnect()end;pcall(function()kV:Destroy()end)return end;local ll=kS.Closed and true or false;l1.Visible=ll;if not lb then local aw=l1.Position;l8.Position=UDim2.new(aw.X.Scale,aw.X.Offset,aw.Y.Scale,aw.Y.Offset+l1.Size.Y.Offset+5)end end)return true end;do
 local records={};local active=false;local installed=false;local hookNote="not installed";local started=0;local links={}
 local function fmt(v,depth)
  depth=depth or 0;local kind=typeof(v)
  if kind=="Instance" then return v:GetFullName().." ["..v.ClassName.."]" end
  if kind=="string" then return string.format("%q",v:sub(1,300)) end
  if kind=="table" then if depth>=3 then return "<depth>" end;local out={};local count=0;for k,val in pairs(v) do count=count+1;if count>25 then out[#out+1]="...";break end;out[#out+1]=fmt(k,depth+1).."="..fmt(val,depth+1) end;return "{"..table.concat(out,", ").."}" end
  return tostring(v)
 end
 local function log(kind,...)
  if not active then return end;local args=table.pack(...);local out={};for i=1,args.n do local ok,value=pcall(fmt,args[i]);out[i]=ok and value or "<unreadable>" end
  if #records>=1000 then table.remove(records,1)end;records[#records+1]=string.format("[%.2fs] %s %s",os.clock()-started,kind,table.concat(out," | "))
 end
 local function snapshot()
  local car=B.car or cb();local hp,max=eD();log("SNAPSHOT","car",car,"health",hp,"max",max,"wallet",H.readCashNumber(),"bank",z:GetAttribute("MD_Bank"))
  if car then local objects=car:GetDescendants();table.insert(objects,1,car);for _,obj in ipairs(objects) do
   local attrs=obj:GetAttributes();for name,value in pairs(attrs) do local n=name:lower();if n:find("health",1,true) or n:find("damage",1,true) or n:find("repair",1,true) or n:find("condition",1,true) or n:find("cost",1,true) or n:find("price",1,true) or n=="hp" then log("CAR ATTRIBUTE",obj,name,value)end end
   if obj:IsA("ValueBase") then local n=obj.Name:lower();if n:find("health",1,true) or n:find("repair",1,true) or n:find("condition",1,true) or n:find("cost",1,true) or n:find("price",1,true) or n=="hp" then log("CAR VALUE",obj,obj.Value)end end
  end end
  local pg=z:FindFirstChildOfClass("PlayerGui");if pg then for _,obj in ipairs(pg:GetDescendants()) do local n=obj.Name:lower();local text=(obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text or "";local low=text:lower();if n:find("repair",1,true) or n:find("garage",1,true) or low:find("repair",1,true) then log("GUI",obj,text,obj:IsA("GuiObject") and obj.Visible or nil)end end end
 end
 B.startRepairRecorder=function()
  records={};started=os.clock();active=true
  if not installed then
   if type(hookmetamethod)=="function" and type(getnamecallmethod)=="function" then
    local previous;local wrapper=function(self,...)
     local method=getnamecallmethod();if active and (method=="FireServer" or method=="InvokeServer") then local args=table.pack(...);task.defer(function()pcall(log,"OUT "..method,self,unpack(args,1,args.n))end)end
     return previous(self,...)
    end
    if type(newcclosure)=="function" then wrapper=newcclosure(wrapper) end
    local ok,result=pcall(function()return hookmetamethod(game,"__namecall",wrapper)end)
    if ok and type(result)=="function" then previous=result;installed=true;hookNote="enabled; remains installed until rejoin" else hookNote="failed: "..tostring(result) end
   else hookNote="not supported; passive snapshots only" end
  end
  log("RECORDER START",hookNote);snapshot()
  if #links==0 then for _,remote in ipairs(y:GetDescendants()) do if remote:IsA("RemoteEvent") then local c=remote.OnClientEvent:Connect(function(...)if active then log("REMOTE IN",remote,...)end end);links[#links+1]=c end end end
  task.spawn(function() while active do task.wait(1);if active then pcall(snapshot) end end end)
  a6("REPAIR RECORDER STARTED: manually repair once, then copy. Rejoin if controls become unresponsive.")
 end
 B.stopRepairRecorder=function()active=false;a6("REPAIR RECORDER stopped")end
 B.copyRepairRecorder=function()
  if active then pcall(snapshot);log("RECORDER END")end;active=false
  local report="AUTO FISH REPAIR RECORDER"..string.char(10).."PlaceId="..tostring(game.PlaceId)..string.char(10).."Hook: "..hookNote..string.char(10)..table.concat(records,string.char(10))
  if type(writefile)=="function" then pcall(writefile,"auto_fish_repair_recording.txt",report)end
  local fn=setclipboard or toclipboard;local ok=type(fn)=="function" and pcall(fn,report);a6("REPAIR REPORT "..(ok and "copied" or "saved if supported").."; "..#records.." events")
 end
end
do
 local hooked=false;local inventory={};local lastSync=0;local lastAsk=0;local working=false;local lastAttempt=0;B.repairInventory=inventory
 local function ensureListener()
  if hooked then return true end
  local remote=bi();if not remote then return false end
  remote.OnClientEvent:Connect(function(action,items)
   if action~="Sync" or type(items)~="table" then return end
   for _,entry in pairs(items) do
    if type(entry)=="table" and type(entry.name)=="string" and tonumber(entry.health) and tonumber(entry.maxHealth) then
     inventory[entry.name]={name=entry.name,health=tonumber(entry.health),maxHealth=tonumber(entry.maxHealth),quote=tonumber(entry.repairPrice),at=os.clock(),damaged=entry.damaged}
    end
   end
   lastSync=os.clock()
  end);hooked=true;return true
 end
 B.getRepairQuote=function()
  if not B.car or not ensureListener() then return nil end
  local name=B.car.Name;local old=inventory[name] and inventory[name].at or 0
  if true then
   bm(bi(),"Sync");local deadline=os.clock()+4
   while os.clock()<deadline and (not inventory[name] or inventory[name].at<=old) do k(.1) end
  end
  local v=inventory[name]
  if not v or v.at<=old then a6("REPAIR ATM: fresh Sync entry unavailable for "..name);return nil end
  a6("REPAIR ATM: "..name.." health="..p(v.health).."/"..p(v.maxHealth).." quote="..p(v.quote or -1).." syncAge="..p(os.clock()-v.at))
  if os.clock()-v.at>8 or v.maxHealth<=0 or v.health/v.maxHealth>0.5 or not v.quote or v.quote<=0 then a6("REPAIR ATM: no current qualifying quote; not withdrawing repair money") return nil end
  return {name=v.name,quote=v.quote}
 end
 B.executeRepair=function(name,quote)
  if type(name)~="string" or type(quote)~="number" or quote<=0 then return false,"invalid repair quote" end
  local wallet=H.readCashNumber();if not wallet or wallet<quote then return false,"insufficient verified wallet for quote" end
  local remote=bi();if not remote then return false,"items remote missing" end
  local before=inventory[name];if not before or os.clock()-before.at>12 or before.quote~=quote then bm(remote,"Sync");local deadline=os.clock()+3;local oldAt=before and before.at or 0;while os.clock()<deadline and (not inventory[name] or inventory[name].at<=oldAt) do k(.1) end;before=inventory[name];if not before or before.at<=oldAt or not before.quote or before.quote<=0 then return false,"fresh repair quote unavailable" end;if before.quote~=quote then quote=before.quote;a6("REPAIR: updated server quote $"..p(quote));local cash=H.readCashNumber();if not cash or cash<quote then return false,"new repair quote exceeds wallet" end end end;local beforeAt=before.at
  if not bm(remote,"Repair",{name=name,quote=quote}) then return false,"repair request failed to send" end
  a6("REPAIR: sent "..name.." quoted $"..p(quote).."; awaiting Sync confirmation")
  local deadline=os.clock()+8;local nextRefresh=os.clock()+1
  while os.clock()<deadline and not B.stop do
   if os.clock()>=nextRefresh then bm(remote,"Sync");nextRefresh=os.clock()+2 end
   local v=inventory[name]
   if v and v.at>beforeAt and v.maxHealth>0 and v.health>=v.maxHealth and (v.quote==nil or v.quote==0) then
    B.repairs=(B.repairs or 0)+1;a6("REPAIR CONFIRMED "..name.." "..p(v.health).."/"..p(v.maxHealth));return true
   end
   k(.2)
  end
  return false,"no confirming health Sync; request may have failed"
 end
 B.repairPoll=function()
  if not ensureListener() then return end
  local now=os.clock();if now-lastAsk>8 then lastAsk=now;bm(bi(),"Sync") end
  if working or B.repairFunding or B.inUnderFish or B.localUnderTrip or B.startupSerial==B.runSerial or not B.car or not(B.busy or B.autoFish) then return end
  local name=B.car.Name;local v=inventory[name]
  if not v or now-v.at>20 or not v.maxHealth or v.maxHealth<=0 or v.health/v.maxHealth>0.5 then return end
  if not v.quote or v.quote<=0 then if now-lastAttempt>20 then lastAttempt=now;a6("REPAIR: health at/below 50%, no valid quote; waiting for fresh Sync")end;return end
  if now-lastAttempt<15 then return end;lastAttempt=now;working=true
  local repairRun=B.runSerial
  task.spawn(function()
   local ok,err=pcall(function()
    if B.stop or B.done or B.runSerial~=repairRun or B.startupSerial==repairRun then return end
    if B.stage=="ATM" or B.atmRoutePending or B.repairFunding then a6("REPAIR: existing ATM trip will handle the quote");return end
    local fresh=B.getRepairQuote();if not fresh then a6("REPAIR: fresh qualifying server quote unavailable; retrying on next poll");return end
    if B.stop or B.done or B.runSerial~=repairRun or B.startupSerial==repairRun then return end
    if B.stage=="ATM" or B.atmRoutePending then a6("REPAIR: ATM trip started while quote was loading; no second route");return end
    v=inventory[name];if not v then return end
    local wallet=H.readCashNumber()
    if wallet==nil then a6("REPAIR: wallet unavailable; not sending repair or withdrawing");return end
    if wallet>=v.quote then local success,why=B.executeRepair(name,v.quote);if not success then a6("REPAIR not confirmed: "..tostring(why))end;return end
    if B.stage=="ATM" or (B.stage=="SHOP" and not aL(B.car)) then a6("REPAIR: need $"..p(v.quote-wallet).."; waiting for current ATM/shop interaction");return end
    local resume=B.stage or "SHOP"
    if B.skyState then if F then F() end;B.stop=false;B.done=false;local descended,why=B.skyDescend();if not descended then G("repair needs ATM: "..tostring(why));return end end
    if B.autoDrive then B.autoDrive.active=false end
    B.speed=0;local seat=aq() and aq().SeatPart;local root=seat and (seat.AssemblyRootPart or seat) or aI(B.car)
    if root then pcall(function()root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end)end
    arenaRestoreSurfaceCollision();k(.2)
    if B.stop or B.done or B.runSerial~=repairRun or not aL(B.car) then a6("REPAIR: driver unavailable during ATM handoff");return end;if B.startupSerial==repairRun or B.atmRoutePending or B.stage=="ATM" then a6("REPAIR: initial ATM route took priority; no duplicate trip");return end
    a6("REPAIR: previous drive stopped; vehicle collision restored before ATM parking plan")
    local atm=(H.scanAtms()or{})[1];if not atm then a6("REPAIR: insufficient wallet and no marked ATM");return end
    B.cashReadyFootShop=false;B.repairFunding={name=name,quote=v.quote,resumeStage=resume};B.atmTarget=atm;B.atmStageTarget=H.atmDriveTarget(atm)
    a6("REPAIR at <=50%: wallet $"..p(wallet).." / quote $"..p(v.quote).."; going to ATM for difference")
    B.busy=true;B.lastRouteFailure=nil;if not fR(B.atmStageTarget,"ATM") then B.repairFunding=nil;G("repair ATM route failed: "..tostring(B.lastRouteFailure or "route setup refused"))else task.delay(3,function() if B.busy and not B.stop then eN() end end)end
   end)
   working=false;if not ok then a6("REPAIR ERROR: "..tostring(err))end
  end)
 end
end
do
 local cameraConn=nil;local cameraSave=nil;local ignoreCache={};local ignoreTime=0
 B.skyCameraStop=function()
  if cameraConn then cameraConn:Disconnect();cameraConn=nil end
  local cam=x.CurrentCamera;if cam and cameraSave then pcall(function()cam.CameraType=cameraSave.kind;cam.CameraSubject=cameraSave.subject end)end;cameraSave=nil
 end
 B.unlockTravelCamera=function()
  B.skyCameraStop()
  if B.freecamActive then return end
  local camera=x.CurrentCamera;local hum=aq()
  if camera then pcall(function()camera.CameraType=Enum.CameraType.Custom;if hum then camera.CameraSubject=hum end end)end
 end
 B.closestWater=function()
  local mark=B.castTarget;if not mark then return nil end
  local reference=Vector3.new(mark.x,mark.y,mark.z);local root=ao();if not root then return reference end
  local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.IgnoreWater=false
  local exclude={z.Character};if B.car then exclude[#exclude+1]=B.car end;if B.skyState and B.skyState.folder then exclude[#exclude+1]=B.skyState.folder end;rp.FilterDescendantsInstances=exclude
  if B.selectedSpotTier==20 then
   -- Search actual water in cast range, then face the avatar toward it.
   -- A coordinate alone does not encode which way the player was facing.
   local best,bestScore=nil,math.huge;local maxRange=ht();local look=root.CFrame.LookVector
   local forward=Vector3.new(look.X,0,look.Z);if forward.Magnitude>.01 then forward=forward.Unit end
   for dx=-60,60,4 do for dz=-60,60,4 do
    local hit=x:Raycast(root.Position+Vector3.new(dx,60,dz),Vector3.new(0,-120,0),rp)
    if hit and (hit.Material==Enum.Material.Water or hit.Instance.Name:lower():find("water",1,true)) then
     local delta=hit.Position-root.Position;local flat=Vector3.new(delta.X,0,delta.Z);local distance=delta.Magnitude
     if flat.Magnitude>=3 and distance<maxRange-1 then
      local dot=forward.Magnitude>.01 and forward:Dot(flat.Unit) or 0
      local score=distance+(dot<0 and 10 or 0)
      if score<bestScore then best,bestScore=hit.Position,score end
     end
    end
   end end
   if not best then a6("WATER LEVEL 20: no detected water within rod range");return nil end
   local target=Vector3.new(best.X,root.Position.Y,best.Z)
   if (target-root.Position).Magnitude>.1 then pcall(function()root.CFrame=CFrame.lookAt(root.Position,target)end)end
   a6("WATER LEVEL 20: facing detected in-range water "..tostring(best));return best
  end
  if B.selectedSpotTier~=nil then
   local best,bestDist=nil,math.huge
   for dx=-60,60,12 do for dz=-60,60,12 do
    local hit=x:Raycast(reference+Vector3.new(dx,90,dz),Vector3.new(0,-150,0),rp)
    if hit and (hit.Material==Enum.Material.Water or hit.Instance.Name:lower():find("water",1,true)) then
     local distance=(hit.Position-reference).Magnitude;if distance<bestDist then best,bestDist=hit.Position,distance end
    end
   end end
   if best then a6("WATER: closest detected sample "..tostring(best));return best end
   a6("WATER: no water detected near selected fishing spot");return nil
  end
  local hit=x:Raycast(root.Position,Vector3.new(0,-math.max(100,ht()+20),0),rp)
  if hit and (hit.Material==Enum.Material.Water or hit.Instance.Name:lower():find("water",1,true)) then a6("WATER: detected below avatar "..tostring(hit.Position));return hit.Position end
  a6("WATER: downward probe="..(hit and (Y(hit.Instance).." material="..tostring(hit.Material).." hit="..tostring(hit.Position)) or "no hit").."; using unverified MARK 2 "..tostring(reference));return reference
 end
 B.skyCameraStart=function(target)
  B.skyCameraStop();local cam=x.CurrentCamera;if not cam then return end
  cameraSave={kind=cam.CameraType,subject=cam.CameraSubject};cam.CameraType=Enum.CameraType.Scriptable
  local right=Vector3.new(1,0,0);local side=18
  if B.car then pcall(function()local cf,size=B.car:GetBoundingBox();local rv=cf.RightVector;local flat=Vector3.new(rv.X,0,rv.Z);if flat.Magnitude>.01 then right=flat.Unit end;side=math.clamp(math.max(size.X,size.Z)*.5+8,16,24)end) end
  local root=ao()
  if root and B.car then pcall(function()
   local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={z.Character};rp.IgnoreWater=false
   local eye=root.Position+right*side+Vector3.new(0,5,0);local hit=x:Raycast(eye,target-eye,rp)
   if hit and hit.Instance:IsDescendantOf(B.car) then right=-right;a6("CAST CAMERA: switched side to avoid car")end
  end)end
  local level10Offset=nil
  if B.selectedSpotTier==10 and root then
   -- The old wide camera can sit behind the lakeshore collision even when
   -- the water target itself is in range. Probe several near-player eyes.
   local flat=Vector3.new(target.X-root.Position.X,0,target.Z-root.Position.Z)
   if flat.Magnitude>.01 then
    local forward=flat.Unit;local sideways=Vector3.new(-forward.Z,0,forward.X)
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={z.Character};params.IgnoreWater=false
    local offsets={Vector3.new(0,2,0),Vector3.new(0,3,0),-forward*2+Vector3.new(0,2,0),sideways*2+Vector3.new(0,2,0),-sideways*2+Vector3.new(0,2,0),forward*2+Vector3.new(0,2,0)}
    for _,offset in ipairs(offsets) do
     local eye=root.Position+offset;local direction=target-eye
     if direction.Magnitude>0.1 and direction.Magnitude<=ht() then
      local hit=x:Raycast(eye,direction.Unit*(direction.Magnitude+2),params)
      if hit and (hit.Material==Enum.Material.Water or hit.Instance.Name:lower():find("water",1,true)) then level10Offset=offset;a6("CAST CAMERA LEVEL 10: water-visible eye "..tostring(offset).." hit="..Y(hit.Instance));break end
     end
    end
    if not level10Offset then a6("CAST CAMERA LEVEL 10: no tested eye had a water ray; retaining existing camera; server may reject cast") end
   end
  end
  local cameraRecord=B.recordedFishCameras and B.recordedFishCameras[B.selectedSpotTier]
  if not cameraRecord then
   local presets={
    [0]={Vector3.new(126.303886,243.623428,-764.967407),Vector3.new(-6.721924,2.948730,10.431641),CFrame.new(0,0,0,0.840597,0.064945,-0.537754,0,0.992786,0.119899,0.541662,-0.100787,0.834533)},
    [10]={Vector3.new(496.335663,241.371597,-1073.661621),Vector3.new(-4.334076,2.918777,-11.632202),CFrame.new(0,0,0,-0.937069,0.041025,-0.346726,0,0.993073,0.117502,0.349145,0.110107,-0.930577)},
    [20]={Vector3.new(-392.343506,245.746384,831.498474),Vector3.new(4.773743,7.356430,-14.631348),CFrame.new(0,0,0,-0.950679,-0.111134,0.289583,0,0.933609,0.358294,-0.310176,0.340623,-0.887563)},
    [25]={Vector3.new(75.388077,246.921799,809.052307),Vector3.new(4.509430,2.523270,-2.949341),CFrame.new(0,0,0,-0.547364,-0.163487,0.820771,0,0.980734,0.195349,-0.836894,0.106927,-0.536819)}
   };local preset=presets[B.selectedSpotTier];if preset then cameraRecord={origin=preset[1],offset=preset[2],rotation=preset[3]}end
  end
  if cameraRecord and root and (root.Position-cameraRecord.origin).Magnitude>20 then a6("CAST CAMERA: saved view too far from recorded position; using automatic water aim");cameraRecord=nil end
  if cameraRecord then a6("CAST CAMERA: using saved level "..tostring(B.selectedSpotTier).." view")end
  cameraConn=game:GetService("RunService").RenderStepped:Connect(function()
   if not B.autoFish or B.stop or B.done then B.unlockTravelCamera();return end
   local root=ao();local live=x.CurrentCamera;if not root or not live then return end
   if cameraRecord then pcall(function()local cf=CFrame.new(root.Position+cameraRecord.offset)*cameraRecord.rotation;live.CFrame=cf end);return end
    local eye=level10Offset and (root.Position+level10Offset) or (root.Position+right*side+Vector3.new(0,5,0))
   pcall(function()
    local cf=CFrame.lookAt(eye,target)
    if B.selectedSpotTier==0 then cf=cf*CFrame.Angles(math.rad(-1),math.rad(-2),0)
    elseif B.selectedSpotTier==10 then cf=cf*CFrame.Angles(math.rad(-1),math.rad(2),0)end
    live.CFrame=cf
   end)
  end)
 end
 B.inspectCastAim=function(target)
  local cam=x.CurrentCamera;local root=ao();if not cam or not root then return end
  local eye=cam.CFrame.Position;local vector=target-eye;local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances={z.Character};ray.IgnoreWater=false
  local hit=x:Raycast(eye,vector.Unit*math.min(vector.Magnitude,ht()),ray)
  local details=hit and (Y(hit.Instance).." material="..tostring(hit.Material).." position="..tostring(hit.Position).." fromCamera="..p((hit.Position-eye).Magnitude)) or "no ray hit within target/range"
  a6("CAST AIM: rootDist="..p((root.Position-target).Magnitude).." cameraDist="..p(vector.Magnitude).." max="..p(ht()).." ray="..details.." (client probe, may differ from game cast)")
 end
 B.surfaceGroundAt=function(px,pz,probe)
  if os.clock()-ignoreTime>1 then
   ignoreTime=os.clock();ignoreCache={z.Character};if B.car then ignoreCache[#ignoreCache+1]=B.car end
   for _,player in ipairs(u:GetPlayers()) do if player.Character then ignoreCache[#ignoreCache+1]=player.Character end end
   local parts=x:GetPartBoundsInRadius(Vector3.new(px,probe-12,pz),75)
   local seen={};for _,part in ipairs(parts) do local model=part:FindFirstAncestorOfClass("Model");if model and not seen[model] then seen[model]=true;local seat=model:FindFirstChildWhichIsA("VehicleSeat",true);if seat then ignoreCache[#ignoreCache+1]=model end end end
  end
  local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.RespectCanCollide=true;rp.IgnoreWater=false
  local ignored={};for _,item in ipairs(ignoreCache) do ignored[#ignored+1]=item end
  for attempt=1,24 do
   rp.FilterDescendantsInstances=ignored
   local hit=x:Raycast(Vector3.new(px,probe,pz),Vector3.new(0,-120,0),rp)
   if not hit or hit.Material==Enum.Material.Water then return nil end
   local obj=hit.Instance;local name=(obj.Name.." "..(obj.Parent and obj.Parent.Name or "")):lower()
   if name:find("fence",1,true) or name:find("gate",1,true) or name:find("guardrail",1,true) then ignored[#ignored+1]=obj else B.lastGroundHit=Y(obj);return hit.Position.Y end
  end
  return nil
 end
end
do
 local stepped=nil;local enabled=true;local lastRefresh=0;local parts={}
 pcall(function()local env=r();local stop=env.ArenaFishCharacterNoclipStop;if type(stop)=="function" then stop()end end)
 B.setCharacterNoclip=function(value)
  enabled=value==true
  if not enabled then for part,old in pairs(parts) do pcall(function()if part.Parent then part.CanCollide=old end end)end;parts={} end
 end
 B.characterNoclipEnabled=function()return enabled end
 stepped=game:GetService("RunService").Stepped:Connect(function()
  if not enabled then return end
  local character=z.Character;if not character then return end
  if os.clock()-lastRefresh>.4 then lastRefresh=os.clock();for _,part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") and parts[part]==nil then parts[part]=part.CanCollide end end end
  local skyFloor=B.skyState and B.skyState.folder and B.skyState.folder:FindFirstChild("SkyLayer3")
  local skyHum=character:FindFirstChildOfClass("Humanoid")
  for part in pairs(parts) do pcall(function()if part.Parent and part:IsDescendantOf(character) then
   local name=part.Name;local isFoot=name=="LeftFoot" or name=="RightFoot" or name=="Left Leg" or name=="Right Leg"
   part.CanCollide=skyFloor~=nil and skyHum and not skyHum.SeatPart and isFoot or false
  end end)end
  local hum=skyHum;local root=character:FindFirstChild("HumanoidRootPart")
  if B.atmTransactionHold or B.fishingGlide then return end
  if not root or not hum or hum.SeatPart or hum.Health<=0 or hum:GetState()==Enum.HumanoidStateType.Swimming then return end
  if skyFloor and B.autoFish then
   local localPos=skyFloor.CFrame:PointToObjectSpace(root.Position);local half=skyFloor.Size/2
   local lx=math.clamp(localPos.X,-math.max(0,half.X-2),math.max(0,half.X-2));local lz=math.clamp(localPos.Z,-math.max(0,half.Z-2),math.max(0,half.Z-2))
   local floorY=skyFloor.Position.Y+skyFloor.Size.Y/2;local targetY=floorY+hum.HipHeight+root.Size.Y/2
   if math.abs(localPos.X-lx)>.5 or math.abs(localPos.Z-lz)>.5 or math.abs(root.Position.Y-targetY)>2 then
    local fixed=skyFloor.CFrame:PointToWorldSpace(Vector3.new(lx,0,lz));root.CFrame=CFrame.new(fixed.X,targetY,fixed.Z)*root.CFrame.Rotation;root.AssemblyLinearVelocity=Vector3.zero
   end
  end
  local ground=nil
  if B.skyState and B.skyState.folder then local floor=B.skyState.folder:FindFirstChild("SkyLayer3");if floor and math.abs(root.Position.Y-floor.Position.Y)<12 then ground=floor.Position.Y+floor.Size.Y/2 end end
  if not ground and (B.manualUnderground or B.inUnderFish) and B.realFishFloor then
   local hit=B.realFishFloor(root.Position.X,root.Position.Z,root.Position.Y);if hit then ground=hit.Position.Y end
  elseif not ground and B.surfaceGroundAt then ground=B.surfaceGroundAt(root.Position.X,root.Position.Z,root.Position.Y+10) end
  if ground then
   local desired=ground+hum.HipHeight+root.Size.Y/2
   if math.abs(root.Position.Y-desired)<8 then local velocity=root.AssemblyLinearVelocity;root.AssemblyLinearVelocity=Vector3.new(velocity.X,math.clamp((desired-root.Position.Y)*8,-28,28),velocity.Z) end
  end
 end)
 pcall(function()r().ArenaFishCharacterNoclipStop=function() if stepped then stepped:Disconnect();stepped=nil end;B.setCharacterNoclip(false) end end)
end
do
 B.pressGameButton=function(button)
  if not button or not button:IsA("GuiButton") then return false,"button missing" end
  if not button.Visible then return false,"button not visible" end
  local chosen=nil
  if type(getconnections)=="function" then
   for _,name in ipairs({"Activated","MouseButton1Click"}) do
    local ok,connections=pcall(getconnections,button[name]);if ok and type(connections)=="table" and #connections>0 then chosen={name=name,signal=button[name],connections=connections};break end
   end
  elseif type(firesignal)=="function" then chosen={name="Activated",signal=button.Activated} end
  if not chosen then return false,"executor cannot inspect/fire button connections" end
  if type(firesignal)=="function" then local ok,err=pcall(firesignal,chosen.signal);if ok then return true,chosen.name.." signal" end end
  local count=0
  for _,connection in ipairs(chosen.connections or {}) do
   local ok=pcall(function() if type(connection.Fire)=="function" then connection:Fire();count=count+1 elseif type(connection.Function)=="function" then task.spawn(connection.Function);count=count+1 end end)
  end
  return count>0,chosen.name.." callbacks="..count
 end
 B.actualFishCount=function()
  local total=0
  for _,container in ipairs({z:FindFirstChildOfClass("Backpack"),z.Character}) do if container then for _,obj in ipairs(container:GetChildren()) do
   if obj:IsA("Tool") then local kind=tostring(obj:GetAttribute("MD_FarmKind") or ""):lower();local name=obj.Name:lower()
    if kind=="fish" or ((name:find("fish",1,true) or name:find("bass",1,true) or name:find("salmon",1,true) or name:find("carp",1,true)) and not name:find("fishing",1,true) and not name:find("rod",1,true) and not name:find("bait",1,true)) then total=total+(tonumber(obj:GetAttribute("MD_StackCount")) or 1) end
   end
  end end end;return total
 end
end
do
 local capacity=30000;local entries={};local total=0;local dropped=0;local alive=true;local conns={};local watched={};local started=os.clock()
 pcall(function()local old=r().ArenaFishSessionRecorderStop;if type(old)=="function" then old()end end)
 local function add(kind,message)
  -- Before developer mode retain only script milestones and passive state;
  -- never record input, prompt events or remote traffic before it is enabled.
  if not alive or (not B.devEnabled and kind~="SCRIPT" and kind~="RESULT" and kind~="STATE" and kind~="RECORDER ERROR") then return end;total=total+1;if total>capacity then dropped=dropped+1 end
  local text=tostring(message or "");if #text>4000 then text=text:sub(1,4000).." <truncated>" end
  entries[((total-1)%capacity)+1]=string.format("[%09.2fs] #%d %s %s",os.clock()-started,total,tostring(kind),text)
 end
 B.fullLogAdd=add
 B.fullLogReport=function(silent)
  if not silent then add("REPORT","Copy Report pressed") end
  local highlights={};local patterns={"BOARD RANGE", "BOARD attempt", "BOARD: no verified seat", "BOARD TARGET", "FISH SPOT:", "FISH PARK:", "ROUTE STOP", "FISH: teleporting", "CAST AIM:", "CAST target=", "SELL ALL", "SELL CONFIRMED", "COLLISION RESTORE DEFERRED", "VOID SAFETY:", "ATM WITHDRAW", "!! "}
  local firstSaved=math.max(1,total-capacity+1)
  for index=firstSaved,total do
   local entry=entries[((index-1)%capacity)+1]
   if entry and entry:find(" SCRIPT ",1,true) then for _,pattern in ipairs(patterns) do if entry:find(pattern,1,true) then highlights[#highlights+1]=entry;break end end end
  end
  local summary={"===== AUTOMATIC DIAGNOSTIC SUMMARY =====", "This section reports observations, not confirmed causes.", "Current phase="..tostring(B.phase).." stage="..tostring(B.stage).." lastFailure="..tostring(B.lastFailure or "none"), "Selected level="..tostring(B.selectedSpotTier or B.spotChoice).." mark="..tostring(B.underFishMark).." water="..aj(B.waterTarget).." character="..tostring(ar()).." car="..tostring(B.car and at(B.car)).." seated="..tostring(B.car and aL(B.car)), "Recent diagnostic milestones (up to 35):"}
  for i=math.max(1,#highlights-34),#highlights do summary[#summary+1]=highlights[i] end
  if #highlights==0 then summary[#summary+1]="No matching milestones retained."end
  summary[#summary+1]="===== END DIAGNOSTIC SUMMARY ====="
  local output={table.concat(summary,"\n"),"",iX(),"", "===== FULL SESSION BLACKBOX =====", "PlaceId="..tostring(game.PlaceId).." user="..tostring(z.Name), "Script milestones and state retained before Developer Mode; input, prompts and remotes only while Developer Mode is enabled.", "Events="..total.." retained="..math.min(total,capacity).." dropped="..dropped.." capacity="..capacity, "Input codes/positions, local snapshots, script remote attempts and observed incoming remotes are included. No global outgoing hook; other scripts/server-only activity may be missing.", "--- FULL SESSION EVENTS ---"}
  local first=math.max(1,total-capacity+1)
  for index=first,total do output[#output+1]=entries[((index-1)%capacity)+1] or "<missing>" end
  output[#output+1]="===== END SESSION BLACKBOX ====="
  return table.concat(output,string.char(10))
 end
 local function watch(remote)
  if watched[remote] or not remote:IsA("RemoteEvent") then return end;watched[remote]=true
  local ok,c=pcall(function()return remote.OnClientEvent:Connect(function(...)
   local g=table.pack(...);local values={};for i=1,g.n do local success,value=pcall(aj,g[i]);values[#values+1]=success and value or "<unreadable>" end
   add("REMOTE IN",Y(remote).." "..table.concat(values," | "))
  end)end);if ok and c then conns[#conns+1]=c end
 end
 for _,remote in ipairs(y:GetDescendants()) do if remote:IsA("RemoteEvent") then watch(remote)end end
 conns[#conns+1]=y.DescendantAdded:Connect(function(obj)if obj:IsA("RemoteEvent")then watch(obj)end end)
 conns[#conns+1]=w.InputBegan:Connect(function(input,processed)
  if w:GetFocusedTextBox() then return end
  add("INPUT BEGIN",tostring(input.UserInputType).." key="..tostring(input.KeyCode).." position="..tostring(input.Position).." processed="..tostring(processed))
 end)
 conns[#conns+1]=w.InputEnded:Connect(function(input,processed)
  if w:GetFocusedTextBox() then return end
  add("INPUT END",tostring(input.UserInputType).." key="..tostring(input.KeyCode).." position="..tostring(input.Position).." processed="..tostring(processed))
 end)
 pcall(function()local service=game:GetService("ProximityPromptService");conns[#conns+1]=service.PromptTriggered:Connect(function(prompt,player)if player==z then add("PROMPT",Y(prompt).." action="..tostring(prompt.ActionText).." object="..tostring(prompt.ObjectText))end end)end)
 add("SESSION","Recorder started; continuously retains across auto-fish starts and stops")
 task.spawn(function()
  while alive do
   local ok,err=pcall(function()
    local car=B.car;local pos=car and at(car);local hum=aq();local character=ao();local root=car and aI(car);local drive=B.autoDrive
    if car and hum and hum.SeatPart and hum.SeatPart:IsDescendantOf(car) then root=hum.SeatPart.AssemblyRootPart or hum.SeatPart end
    local vel=root and root.AssemblyLinearVelocity;local anchored=root and root.Anchored
    local state="phase="..tostring(B.phase).." stage="..tostring(B.stage).." busy="..tostring(B.busy).." stop="..tostring(B.stop).." car="..tostring(car and car.Name).." seated="..tostring(car and aL(car)).." char="..tostring(character and character.Position).." charVel="..tostring(character and character.AssemblyLinearVelocity).." humanoidState="..tostring(hum and hum:GetState()).." floorMaterial="..tostring(hum and hum.FloorMaterial).." carPos="..tostring(pos).." velocity="..tostring(vel).." anchored="..tostring(anchored).." speed="..tostring(B.speed).." health="..tostring(hum and hum.Health)
    if drive then state=state.." driveActive="..tostring(drive.active).." target="..aj(drive.target).." waypoint="..tostring(drive.roadIndex).." ground="..tostring(drive.lastGround).." hopUntil="..tostring(drive.hopUntil).." landing="..tostring(drive.awaitFenceLanding).." replans="..tostring(drive.replanCount) end
    local owned="unknown";if root and type(isnetworkowner)=="function" then local q,v=pcall(isnetworkowner,root);if q then owned=tostring(v)end end
    add("STATE",state.." owner="..owned.." cash="..tostring(z:GetAttribute("Money")).." bank="..tostring(z:GetAttribute("MD_Bank")))
   end)
   if not ok then add("RECORDER ERROR",tostring(err)) end
   task.wait((B.busy or B.autoFish or B.autoDrive and B.autoDrive.active) and .5 or 2)
  end
 end)
 pcall(function()r().ArenaFishSessionRecorderStop=function()alive=false;for _,conn in ipairs(conns) do pcall(function()conn:Disconnect()end)end end end)
end
local function lm(kt)
 local ok,err=pcall(function()
  local TweenService=game:GetService("TweenService")
  local UIS=game:GetService("UserInputService")
  local playerGui=z:WaitForChild("PlayerGui")
  local uiParent=playerGui
  pcall(function() if type(gethui)=="function" and gethui() then uiParent=gethui() end end)
  for _,parent in ipairs({playerGui,uiParent}) do local old=parent:FindFirstChild("EditorialAutoFish");if old then old:Destroy() end end
  local screen=Instance.new("ScreenGui");screen.Name="EditorialAutoFish";screen.ResetOnSpawn=false;screen.IgnoreGuiInset=true;screen.DisplayOrder=2147483647;screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;screen.Parent=uiParent
  do
   local badge=Instance.new("TextLabel");badge.Name="GameVersion";badge.AnchorPoint=Vector2.new(1,1)
   badge.Position=UDim2.new(1,-8,1,-8);badge.Size=UDim2.fromOffset(205,22)
   badge.BackgroundColor3=Color3.fromRGB(10,10,13);badge.BackgroundTransparency=.25;badge.BorderSizePixel=0
   badge.TextColor3=Color3.fromRGB(225,225,230);badge.Font=Enum.Font.Gotham;badge.TextSize=11
   local ok,version=pcall(function()return game.PlaceVersion end)
   badge.Text=ok and ("GAME VERSION "..tostring(version)) or "GAME VERSION UNAVAILABLE";badge.Parent=screen
  end
  local cream=Color3.fromRGB(166,211,226);local panel=Color3.fromRGB(166,211,226);local card=Color3.fromRGB(150,196,210);local ink=Color3.fromRGB(7,9,11);local muted=Color3.fromRGB(49,75,85);local accent=Color3.fromRGB(7,9,11)
  local function create(kind,properties,parent) local obj=Instance.new(kind);for key,value in pairs(properties) do obj[key]=value end;obj.Parent=parent;return obj end
  local function round(obj,radius) create("UICorner",{CornerRadius=UDim.new(0,radius)},obj) end
  local function outline(obj) create("UIStroke",{Color=ink,Thickness=1},obj) end
  local function frame(parent,color) return create("Frame",{BackgroundColor3=color,BorderSizePixel=0},parent) end
  local function txt(parent,value,size,color,bold) return create("TextLabel",{Text=value,TextColor3=color,TextSize=size,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1},parent) end
  local function button(parent,value,color,bg) return create("TextButton",{Text=value,TextColor3=color,BackgroundColor3=bg,BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false},parent) end
  local function anim(obj,values) TweenService:Create(obj,TweenInfo.new(.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),values):Play() end
  local window=frame(screen,cream);window.Name="Window";window.AnchorPoint=Vector2.new(.5,0);window.Position=UDim2.new(.5,0,0,8);window.Size=UDim2.fromOffset(350,78);window.ClipsDescendants=true;round(window,9);outline(window)
  local camera=workspace.CurrentCamera;local view=camera and camera.ViewportSize or Vector2.new(900,600)
  create("UIScale",{Scale=math.min(1,(view.X-16)/760,(view.Y-85)/460)},window)
  local header=frame(window,panel);header.Size=UDim2.new(1,0,0,46);header.Active=true
  local title=txt(header,"DRIXN",17,ink,true);title.Position=UDim2.fromOffset(72,3);title.Size=UDim2.new(1,-80,0,40)
  local menu=button(header,"",ink,panel);menu.BackgroundTransparency=1;menu.Size=UDim2.fromOffset(48,46);menu.Position=UDim2.fromOffset(9,1)
  for index,width in ipairs({25,25,17}) do local bar=frame(menu,ink);bar.Position=UDim2.fromOffset(10,11+(index-1)*8);bar.Size=UDim2.fromOffset(width,2) end
  local headLine=frame(header,ink);headLine.Size=UDim2.new(1,0,0,1);headLine.Position=UDim2.new(0,0,1,-1)
  local area=frame(window,cream);area.Size=UDim2.new(1,0,1,-46);area.Position=UDim2.fromOffset(0,46)
  local strip=frame(area,accent);strip.Size=UDim2.new(1,0,0,32)
  local statusLine=txt(strip,"■  WITH LOVE - DRIXNVSP",10,panel,true);statusLine.Position=UDim2.fromOffset(12,0);statusLine.Size=UDim2.new(1,-24,1,0);statusLine.TextTruncate=Enum.TextTruncate.AtEnd
  local rule=frame(strip,ink);rule.Size=UDim2.new(1,0,0,1);rule.Position=UDim2.new(0,0,1,-1)
  local nav=frame(area,panel);nav.Position=UDim2.fromOffset(0,32);nav.Size=UDim2.new(0,170,1,-32)
  local navLabel=txt(nav,"INDEX",11,muted,true);navLabel.Position=UDim2.fromOffset(20,15);navLabel.Size=UDim2.new(1,-40,0,35)
  local divider=frame(area,ink);divider.Position=UDim2.fromOffset(169,32);divider.Size=UDim2.new(0,1,1,-32)
  local content=frame(area,cream);content.Position=UDim2.fromOffset(190,32);content.Size=UDim2.new(1,-210,1,-42)
  local tabs={};local current=nil
  local function switch(name)
   current=name
   for n,tb in pairs(tabs) do tb.scroll.Visible=(n==name);tb.nav.BackgroundColor3=n==name and accent or panel;tb.nav.TextColor3=n==name and cream or muted end
  end
  local function createTab(name,index)
   local symbols={ ["Auto Fish"]="🐟",Travel="➤",Protection="◇",Settings="⚙" };local navBtn=button(nav,"  "..(symbols[name] or "•").."  "..name:upper(),muted,panel);navBtn.TextXAlignment=Enum.TextXAlignment.Left;navBtn.Position=UDim2.fromOffset(10,70+(index-1)*43);navBtn.Size=UDim2.new(1,-20,0,37);round(navBtn,5)
   local line=frame(nav,ink);line.Position=UDim2.fromOffset(10,70+index*43-1);line.Size=UDim2.new(1,-20,0,1)
   local scroll=create("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),Visible=false},content)
   local layout=create("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
   local heading=txt(scroll,name..".",25,ink,true);heading.Size=UDim2.new(1,-12,0,40);heading.LayoutOrder=0
   local tb={nav=navBtn,scroll=scroll,count=0,line=line};tabs[name]=tb
   navBtn.MouseButton1Click:Connect(function() switch(name) end)
   function tb:add(title,desc,height)
    self.count=self.count+1;local box=frame(self.scroll,card)
    local priority=name=="Auto Fish" and ({["AUTO FARM"]=1,["INCLUDE PLANTING"]=2,["Bait to buy"]=3,["FISH BEFORE SELL"]=4})[title]
    box.LayoutOrder=priority or 100+self.count;box.Size=UDim2.new(1,-12,0,height or 64);round(box,10)
    local main=txt(box,title:upper(),13,ink,true);main.Position=UDim2.fromOffset(13,7);main.Size=UDim2.new(1,-26,0,23)
    local sub=txt(box,desc or "",10,muted);sub.Position=UDim2.fromOffset(13,31);sub.Size=UDim2.new(1,-26,0,23);sub.TextTruncate=Enum.TextTruncate.AtEnd
    return box,main,sub
   end
   function tb:Button(title,desc,callback)
    local box=self:add(title,desc,64);local action=button(box,"→",cream,ink);action.Size=UDim2.fromOffset(78,32);action.Position=UDim2.new(1,-90,.5,-16);round(action,6);local hit=button(box,"",ink,card);hit.BackgroundTransparency=1;hit.Size=UDim2.fromScale(1,1);hit.MouseButton1Click:Connect(function() task.spawn(function() local success,problem=pcall(callback);if not success then a6("UI action error: "..tostring(problem)) end end) end)
   end
   function tb:Paragraph(title,description)
    local _,_,sub=self:add(title,description,64)
    return {SetDesc=function(_,value) sub.Text=tostring(value) end}
   end
   function tb:Slider(title,desc,min,max,default,step,callback)
    local box,main,sub=self:add(title,desc,76);local value=default
    main.Size=UDim2.new(1,-185,0,23);sub.Size=UDim2.new(1,-185,0,23)
    local number=txt(box,tostring(value),15,ink,true);number.Position=UDim2.new(1,-173,0,20);number.Size=UDim2.fromOffset(35,32);number.TextXAlignment=Enum.TextXAlignment.Center
    local bar=frame(box,Color3.fromRGB(80,80,80));bar.Position=UDim2.new(1,-130,0,32);bar.Size=UDim2.fromOffset(112,7);round(bar,3)
    local fill=frame(bar,Color3.fromRGB(0,0,0));fill.Size=UDim2.new((value-min)/(max-min),0,1,0);round(fill,3)
    local knob=frame(bar,Color3.fromRGB(0,0,0));knob.AnchorPoint=Vector2.new(.5,.5);knob.Position=UDim2.new((value-min)/(max-min),0,.5,0);knob.Size=UDim2.fromOffset(15,15);round(knob,8)
    local hit=button(bar,"",ink,panel);hit.BackgroundTransparency=1;hit.Position=UDim2.fromOffset(-8,-16);hit.Size=UDim2.new(1,16,0,36)
    local active=nil;local priorScrolling=nil;local dragX=nil;local dragValue=nil
    local function finish()
     if not active then return end;active=nil
     if scroll.Parent and priorScrolling~=nil then scroll.ScrollingEnabled=priorScrolling end;priorScrolling=nil
    end
    local function update(input)
     if bar.AbsoluteSize.X<=0 then return end
     local dx=input.Position.X-dragX;if math.abs(dx)<3 then return end
     local ratio=math.clamp((dragValue-min)/(max-min)+dx/bar.AbsoluteSize.X,0,1)
     local nextValue=math.clamp(min+math.floor(((max-min)*ratio)/step+.5)*step,min,max)
     if nextValue==value then return end;value=nextValue;number.Text=tostring(value)
     fill.Size=UDim2.new((value-min)/(max-min),0,1,0);knob.Position=UDim2.new((value-min)/(max-min),0,.5,0);pcall(callback,value)
    end
    hit.InputBegan:Connect(function(input)
     if active or (input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch) then return end
     active=input;dragX=input.Position.X;dragValue=value;priorScrolling=scroll.ScrollingEnabled;scroll.ScrollingEnabled=false
     input.Changed:Connect(function()if input==active and (input.UserInputState==Enum.UserInputState.End or input.UserInputState==Enum.UserInputState.Cancel) then finish()end end)
    end)
    UIS.InputChanged:Connect(function(input)if screen.Parent and active and ((active.UserInputType==Enum.UserInputType.Touch and input==active) or (active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then update(input) end end)
    UIS.InputEnded:Connect(function(input)if input==active or (active and active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then finish() end end)
    UIS.WindowFocusReleased:Connect(finish)
    scroll:GetPropertyChangedSignal("Visible"):Connect(function()if not scroll.Visible then finish()end end)
    return {SetDesc=function() end}
   end
   function tb:Toggle(title,desc,initial,callback)
    local box=self:add(title,desc,64);local on=initial;local switcher=button(box,"",ink,panel);switcher.Size=UDim2.fromOffset(46,26);switcher.Position=UDim2.new(1,-59,.5,-13);round(switcher,13);outline(switcher)
    local knob=frame(switcher,ink);knob.Size=UDim2.fromOffset(18,18);round(knob,9)
    local function render() knob.Position=UDim2.fromOffset(on and 24 or 4,4);switcher.BackgroundColor3=on and accent or panel;knob.BackgroundColor3=on and panel or ink end
    switcher.MouseButton1Click:Connect(function() on=not on;render();pcall(callback,on) end);render()
    return {Set=function(_,value)on=value and true or false;render()end}
   end
   function tb:Choice(title,desc,choices,initial,callback)
    local box=self:add(title,desc,64);local index=table.find(choices,initial) or 1
    local choose=button(box,choices[index].."  ▾",ink,panel);choose.Size=UDim2.fromOffset(120,34);choose.Position=UDim2.new(1,-132,.5,-17);round(choose,5);outline(choose)
    choose.MouseButton1Click:Connect(function() index=index%#choices+1;choose.Text=choices[index].."  ▾";pcall(callback,choices[index]) end)
   end
   function tb:Dropdown(title,desc,items,selected,choose,multi)
    local box,_,sub=self:add(title,desc,64);local trigger=button(box,"SELECT  ▾",ink,Color3.fromRGB(127,169,182));trigger.Size=UDim2.fromOffset(125,34);trigger.Position=UDim2.new(1,-138,0,15);trigger.TextSize=14;trigger.Font=Enum.Font.Gotham;trigger.TextXAlignment=Enum.TextXAlignment.Center;round(trigger,5)
    local list=frame(box,panel);list.Position=UDim2.new(1,-208,0,60);list.Size=UDim2.fromOffset(195,0);round(list,6);list.Visible=false
    local opened=false
    if not multi then for _,entry in ipairs(items())do if selected(entry) then trigger.Text=entry.label.."  ▾";sub.Text=entry.label;break end end end
    trigger.TextTruncate=Enum.TextTruncate.AtEnd
    local function refresh()
     for _,child in ipairs(list:GetChildren())do child:Destroy()end
     local opts=items();local h=0
     for _,entry in ipairs(opts) do local item=button(list,entry.label,ink,selected(entry) and Color3.fromRGB(110,195,229) or panel);item.TextXAlignment=Enum.TextXAlignment.Center;item.TextSize=14;item.Font=Enum.Font.Gotham;item.Position=UDim2.fromOffset(0,h);item.Size=UDim2.new(1,0,0,34);round(item,4);h=h+38
      item.MouseButton1Click:Connect(function()choose(entry);if multi then refresh()else opened=false;list.Visible=false;box.Size=UDim2.new(1,-12,0,64);sub.Text=entry.label;trigger.Text=entry.label.."  ▾" end end)
     end
     if #opts==0 then local label=txt(list,"Open the fishing shop to load prices",11,muted);label.Size=UDim2.new(1,0,0,34);h=38 end
     list.Size=UDim2.fromOffset(195,h);box.Size=UDim2.new(1,-12,0,opened and 64+h or 64)
    end
    trigger.MouseButton1Click:Connect(function()opened=not opened;list.Visible=opened;if opened then refresh()else box.Size=UDim2.new(1,-12,0,64)end end)
   end
   return tb
  end
  local home=createTab("Auto Fish",1);local settings=createTab("Travel",2);local protection=createTab("Protection",3);local tools=createTab("Settings",4)
  local dev=createTab("Developer",5);local explore=createTab("Explore",6);dev.nav.Visible=false;dev.line.Visible=false;explore.nav.Visible=false;explore.line.Visible=false;B.devEnabled=false
  local devButton=dev.Button
  function dev:Button(title,desc,callback) return devButton(self,title,desc,function(...)if B.devEnabled then callback(...)end end)end
  do
   local box=tools:add("Developer mode","Enter code to show or hide developer tools",76)
   local field=create("TextBox",{Text="",PlaceholderText="Code",ClearTextOnFocus=false,TextColor3=ink,PlaceholderColor3=muted,BackgroundColor3=panel,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=15},box)
   field.Position=UDim2.new(1,-146,0,18);field.Size=UDim2.fromOffset(67,36);round(field,5);outline(field)
   local unlock=button(box,"UNLOCK",cream,ink);unlock.Position=UDim2.new(1,-73,0,18);unlock.Size=UDim2.fromOffset(60,36);round(unlock,5)
   unlock.Activated:Connect(function()
    if B.devEnabled then
     if B.stopDevTrail then B.stopDevTrail(false)end;B.devEnabled=false;B.coordinateClipboardHoldUntil=nil;if B.stopFreecam then B.stopFreecam()end;if B.stopRepairRecorder then B.stopRepairRecorder()end
     dev.nav.Visible=false;dev.line.Visible=false;explore.nav.Visible=false;explore.line.Visible=false;if current=="Developer" or current=="Explore" then switch("Settings")end
     unlock.Text="UNLOCK";field.Text="";a6("Developer mode disabled")
    elseif field.Text:match("^%s*33%s*$") then
     B.devEnabled=true;dev.nav.Visible=true;dev.line.Visible=true;explore.nav.Visible=true;explore.line.Visible=true;unlock.Text="LOCK";field.Text="";a6("Developer mode enabled");switch("Developer")
    else field.Text="";pcall(function()P("Developer mode","Incorrect code")end)end
   end)
  end
  -- Explorer is isolated from the fishing and planting routines; passive only.
  do
   local explorerSource=[===[
-- DRIXN planting explorer: passive client observers; no namecall hooks or scripted transactions.
local Players=game:GetService('Players')
local RS=game:GetService('ReplicatedStorage')
local PService=game:GetService('ProximityPromptService')
local HttpService=game:GetService('HttpService')
local player=Players.LocalPlayer
local pg=player:WaitForChild('PlayerGui')
local env=(type(getgenv)=='function' and getgenv()) or _G
if env.DRIXNPlantExplorerStop then pcall(env.DRIXNPlantExplorerStop) end
local gui=Instance.new('ScreenGui');gui.Name='DRIXNPlantExplore';gui.ResetOnSpawn=false;gui.DisplayOrder=15000;gui.Parent=pg
local f=Instance.new('Frame');f.Size=UDim2.fromOffset(300,230);f.Position=UDim2.new(.5,-150,.18,0);f.BackgroundColor3=Color3.fromRGB(15,20,31);f.Active=true;f.Draggable=true;f.Parent=gui;Instance.new('UICorner',f)
local label=Instance.new('TextLabel');label.Position=UDim2.fromOffset(8,5);label.Size=UDim2.new(1,-16,0,76);label.BackgroundTransparency=1;label.TextColor3=Color3.new(1,1,1);label.TextSize=13;label.TextWrapped=true;label.Text='DRIXN PLANT EXPLORE V2\nPassive; no hooks or transactions';label.Parent=f
local function btn(x,y,w,text) local b=Instance.new('TextButton');b.Position=UDim2.fromOffset(x,y);b.Size=UDim2.fromOffset(w,36);b.BackgroundColor3=Color3.fromRGB(25,80,145);b.TextColor3=Color3.new(1,1,1);b.TextSize=13;b.Text=text;b.Parent=f;Instance.new('UICorner',b);return b end
local snapshot=btn(8,85,138,'SNAPSHOT')
local copy=btn(154,85,138,'COPY REPORT')
local stop=btn(8,128,138,'STOP')
local close=btn(154,128,138,'CLOSE')
local foot=Instance.new('TextLabel');foot.Position=UDim2.fromOffset(8,169);foot.Size=UDim2.new(1,-16,0,52);foot.BackgroundTransparency=1;foot.TextColor3=Color3.fromRGB(190,210,240);foot.TextSize=11;foot.TextWrapped=true;foot.Text='Manually rent, shop, plant and claim. STOP then COPY REPORT. No outgoing remote capture.';foot.Parent=f
local links={};local log={};local cap=5000;local dropped=0;local startTime=os.clock();local active=true;local observed=setmetatable({},{__mode='k'})
local function path(o) local ok,v=pcall(function()return o:GetFullName()end);return ok and v or tostring(o) end
local function scalar(v,depth)
 depth=depth or 0;local kind=typeof(v)
 if kind=='Instance' then return 'Instance<'..path(v)..'>' end
 if kind=='string' then return string.format('%q',v:sub(1,300)) end
 if kind=='table' then
  if depth>=2 then return '{...}' end
  local parts={};for k,x in pairs(v) do if #parts>=25 then parts[#parts+1]='...';break end;parts[#parts+1]=tostring(k)..'='..scalar(x,depth+1) end;return '{'..table.concat(parts,', ')..'}'
 end
 return tostring(v)
end
local function attrs(o)
 local parts={};local ok,all=pcall(function()return o:GetAttributes()end)
 if ok then for k,v in pairs(all) do if #parts<35 then parts[#parts+1]=tostring(k)..'='..scalar(v) end end end
 return '{'..table.concat(parts,', ')..'}'
end
local function emit(category,msg)
 if not active then return end
 if #log>=cap then dropped+=1;return end
 log[#log+1]=string.format('[%08.2fs] %s %s',os.clock()-startTime,category,tostring(msg):sub(1,3000))
end
local function attach(signal,fn) local ok,c=pcall(function() return signal:Connect(fn) end);if ok then links[#links+1]=c end end
local function guiTarget(o)
 local s=path(o):lower();return s:find('houserental',1,true) or s:find('jackfarmshop',1,true) or s:find('atm',1,true) or s:find('bank',1,true)
end
local function guiDetails(o)
 local out=path(o)..' class='..o.ClassName
 if o:IsA('TextButton') or o:IsA('TextLabel') or o:IsA('TextBox') then out..=' text='..scalar(o.Text) end
 if o:IsA('GuiObject') then out..=' visible='..tostring(o.Visible) end
 return out..' attrs='..attrs(o)
end
local function watchGui(o)
 if observed[o] or not guiTarget(o) then return end
 if o:IsA('GuiButton') then
  observed[o]=true;attach(o.Activated,function()emit('GUI ACTIVATED',guiDetails(o))end)
 elseif o:IsA('TextBox') then
  observed[o]=true;attach(o.FocusLost,function(enter)emit('GUI TEXT',guiDetails(o)..' enter='..tostring(enter))end)
 end
end
local function scanGui() for _,o in ipairs(pg:GetDescendants()) do watchGui(o) end end
local function watchRemote(o)
 if observed[o] or not o:IsA('RemoteEvent') then return end
 local n=o.Name:lower()
 if not (n:find('house',1,true) or n:find('farm',1,true) or n:find('bank',1,true) or n:find('atm',1,true)) then return end
 observed[o]=true;emit('REMOTE LISTEN',path(o));attach(o.OnClientEvent,function(...)
  local args=table.pack(...);local parts={};for i=1,math.min(args.n,10) do parts[#parts+1]=scalar(args[i]) end;emit('REMOTE IN',path(o)..' '..table.concat(parts,' | '))
 end)
end
local function watchTool(o)
 if not o:IsA('Tool') then return end
 emit('TOOL',path(o)..' attrs='..attrs(o))
end
local function watchOwnedHouse(h)
 if observed[h] or not h:IsA('Model') or h:GetAttribute('MD_RentedBy')==nil then return end
 observed[h]=true
 attach(h:GetAttributeChangedSignal('MD_RentedBy'),function()emit('HOUSE OWNER',path(h)..' MD_RentedBy='..scalar(h:GetAttribute('MD_RentedBy')))end)
end
local function relevantPot(o)
 if not o:IsA('Model') or not o.Name:match('^MD_Pot%d+$') then return false end
 local folder=o.Parent;return folder and folder.Name=='MD_FarmingPots'
end
local function watchPot(o)
 if observed[o] or not relevantPot(o) then return end
 observed[o]=true;emit('POT FOUND',path(o)..' attrs='..attrs(o))
 attach(o.AttributeChanged,function(name)emit('POT ATTRIBUTE',path(o)..' '..name..'='..scalar(o:GetAttribute(name)))end)
end
local function scanWorld()
 local map=workspace:FindFirstChild('Map');local tiles=map and map:FindFirstChild('Tiles');if not tiles then emit('SCAN','Tiles unavailable');return end
 local count=0
 for _,o in ipairs(tiles:GetDescendants()) do
  if o:IsA('Model') and o:GetAttribute('MD_RentedBy')~=nil then
   watchOwnedHouse(o);local owner=o:GetAttribute('MD_RentedBy');if tostring(owner)==tostring(player.UserId) then emit('OWN HOUSE',path(o)..' attrs='..attrs(o)) end
  elseif relevantPot(o) then watchPot(o) end
  count+=1;if count%1200==0 then task.wait() end
 end
 emit('SCAN','Completed visible world objects='..count)
end
local function snapshotNow()
 emit('SNAPSHOT','player='..player.Name..' UserId='..player.UserId..' attrs='..attrs(player))
 local char=player.Character;local root=char and char:FindFirstChild('HumanoidRootPart');local h=char and char:FindFirstChildOfClass('Humanoid')
 emit('STATE','position='..tostring(root and root.Position)..' seat='..tostring(h and h.SeatPart)..' health='..tostring(h and h.Health))
 for _,container in ipairs({player:FindFirstChild('Backpack'),char}) do if container then for _,o in ipairs(container:GetChildren()) do watchTool(o) end end end
 for _,o in ipairs(pg:GetDescendants()) do if guiTarget(o) and o:IsA('GuiObject') and o.Visible and (o:IsA('GuiButton') or o:IsA('TextLabel') or o:IsA('TextBox')) then emit('GUI',guiDetails(o)) end end
 task.spawn(scanWorld)
end
local function watchContainer(c)
 if not c then return end
 attach(c.ChildAdded,function(o)if o:IsA('Tool') then emit('INVENTORY ADD',path(o)..' attrs='..attrs(o));attach(o.AttributeChanged,function(k)emit('TOOL ATTRIBUTE',path(o)..' '..k..'='..scalar(o:GetAttribute(k)))end) end end)
 attach(c.ChildRemoved,function(o)if o:IsA('Tool') then emit('INVENTORY REMOVE',path(o)) end end)
end
attach(player.AttributeChanged,function(k)
 local n=k:lower();if n:find('farm',1,true) or n:find('fish',1,true) or n:find('level',1,true) or n:find('xp',1,true) or n:find('cash',1,true) or n:find('money',1,true) or n:find('bank',1,true) then emit('PLAYER ATTRIBUTE',k..'='..scalar(player:GetAttribute(k))) end
end)
watchContainer(player:FindFirstChild('Backpack'));watchContainer(player.Character)
attach(player.CharacterAdded,function(c)watchContainer(c);emit('CHARACTER','spawned '..path(c))end)
attach(pg.DescendantAdded,watchGui)
for _,o in ipairs(RS:GetDescendants()) do watchRemote(o) end
attach(RS.DescendantAdded,watchRemote)
attach(PService.PromptTriggered,function(p,who)
 if who and who~=player then return end
 emit('PROMPT',path(p)..' action='..scalar(p.ActionText)..' object='..scalar(p.ObjectText)..' enabled='..tostring(p.Enabled)..' range='..tostring(p.MaxActivationDistance))
 local model=p:FindFirstAncestorOfClass('Model');if model then emit('PROMPT MODEL',path(model)..' attrs='..attrs(model));watchPot(model) end
end)
local map=workspace:FindFirstChild('Map');local tiles=map and map:FindFirstChild('Tiles')
if tiles then attach(tiles.DescendantAdded,function(o) if relevantPot(o) then watchPot(o) elseif o:IsA('Model') and o:GetAttribute('MD_RentedBy')~=nil then watchOwnedHouse(o) end end) end
-- Independent local prompt observers plus proximity-based state snapshots.
-- PromptTriggered service can be absent on some clients; these are passive as well.
local promptWatches=setmetatable({},{__mode='k'})
local function watchFarmPrompt(p)
 if promptWatches[p] or not p:IsA('ProximityPrompt') then return end
 local q=path(p):lower()
 if not (q:find('farm',1,true) or q:find('pot',1,true) or q:find('mailbox',1,true)) then return end
 promptWatches[p]=true
 attach(p.Triggered,function(who) if not who or who==player then emit('LOCAL PROMPT',path(p)..' action='..scalar(p.ActionText)..' object='..scalar(p.ObjectText)) end end)
 attach(p:GetPropertyChangedSignal('ActionText'),function()emit('PROMPT ACTION',path(p)..' action='..scalar(p.ActionText))end)
 attach(p:GetPropertyChangedSignal('Enabled'),function()emit('PROMPT ENABLED',path(p)..' enabled='..tostring(p.Enabled))end)
end
if tiles then
 task.spawn(function()
  local count=0
  for _,o in ipairs(tiles:GetDescendants()) do if not active then return end;watchFarmPrompt(o);count+=1;if count%1200==0 then task.wait()end end
  emit('PROMPT SCAN','Visible map prompts observed')
 end)
 attach(tiles.DescendantAdded,watchFarmPrompt)
end
local lastNear=''
task.spawn(function()
 while active do
  local c=player.Character;local r=c and c:FindFirstChild('HumanoidRootPart')
  if r then
   local best,bestDist=nil,18
   for p in pairs(promptWatches) do
    if p.Parent then
     local par=p.Parent;local pos
     if par:IsA('Attachment') then pos=par.WorldPosition elseif par:IsA('BasePart') then pos=par.Position end
     if pos then local dist=(r.Position-pos).Magnitude;if dist<bestDist then best,bestDist=p,dist end end
    end
   end
   if best then
    local m=best:FindFirstAncestorOfClass('Model')
    local signature=path(best)..' action='..tostring(best.ActionText)..' enabled='..tostring(best.Enabled)..' modelAttrs='..(m and attrs(m) or '{}')
    if signature~=lastNear then emit('NEAR PROMPT',signature..' distance='..string.format('%.1f',bestDist));lastNear=signature end
   else lastNear='' end
  end
  task.wait(.5)
 end
end)
local function report()
 return '===== DRIXN PLANT EXPLORE =====\nPlaceId='..game.PlaceId..' user='..player.Name..' UserId='..player.UserId..'\nPassive: no global hook; outgoing remote arguments NOT captured.\nEvents='..#log..' dropped='..dropped..'\n'..table.concat(log,'\n')..'\n===== END ====='
end
env.DRIXNPlantExplorerReport=report
local function shutdown()
 if not active then return end
 emit('STOP','Observers disconnected');active=false
 for _,c in ipairs(links) do pcall(function()c:Disconnect()end) end
 label.Text='Stopped. Press COPY REPORT.'
end
env.DRIXNPlantExplorerStop=shutdown
snapshot.MouseButton1Click:Connect(function() if active then task.spawn(snapshotNow) else label.Text='Stopped; copy report.' end end)
copy.MouseButton1Click:Connect(function()
 local text=report();local saved=false;if type(writefile)=='function' then saved=pcall(writefile,'drixn_plant_explore_report.txt',text) end
 local fcopy=setclipboard or toclipboard
 if type(fcopy)=='function' then local ok=pcall(fcopy,text);label.Text=ok and ('Copied '..#log..' events; dropped '..dropped) or 'Copy failed. Check saved file.' else label.Text=saved and 'Clipboard unavailable; saved report file.' or 'Clipboard and file access unavailable.' end
end)
stop.MouseButton1Click:Connect(shutdown)
close.MouseButton1Click:Connect(function()shutdown();gui:Destroy()end)
emit('START','No hooks; no automated purchases, rental, planting or movement. Local UI activation and incoming remotes only.')
scanGui();snapshotNow()

]===]
   explore:Paragraph("Directions 1", "Start explorer; use ATM and rent a $400 home.")
   explore:Paragraph("Directions 2", "Open hardware store; buy soil and sunflower seeds.")
   explore:Paragraph("Directions 3", "At your pot: equip soil, add soil, equip seed, plant.")
   explore:Paragraph("Directions 4", "Press STOP in explorer, then COPY ALL here.")
   explore:Button("START EXPLORER", "No hooks, purchases, or automated movement",function()
    if not B.devEnabled then return end
    if B.busy or B.autoFish or B.farmRequested then a6("EXPLORER: stop Auto Farm first");return end
    local loader=loadstring or load
    if type(loader)~="function" then a6("EXPLORER: loadstring unavailable");return end
    local fn,err=loader(explorerSource)
    if not fn then a6("EXPLORER compile error: "..tostring(err));return end
    local ok,why=pcall(fn);a6(ok and "EXPLORER started; follow the numbered directions" or ("EXPLORER error: "..tostring(why)))
   end)
   explore:Button("COPY ALL", "Copies all explorer events",function()
    if not B.devEnabled then return end
    local env=type(getgenv)=="function" and getgenv() or _G
    local text="Explorer has not been started."
    if type(env.DRIXNPlantExplorerReport)=="function" then local ok,result=pcall(env.DRIXNPlantExplorerReport);if ok then text=tostring(result) end end
    local copier=setclipboard or toclipboard
    if type(copier)=="function" then local ok=pcall(copier,text);a6(ok and "EXPLORE: copied all events" or "EXPLORE: copy failed") else a6("EXPLORE: clipboard unavailable")end
   end)
  end
  local cfg={};local http=game:GetService("HttpService");local configFile="auto_fish_settings.json"
  B.notifyNotEnough=function()
   if B.lastMoneyNotice and os.clock()-B.lastMoneyNotice<2 then return end;B.lastMoneyNotice=os.clock()
   local ok,err=pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title="Auto Fish",Text="Not enough money! Choose a less expensive rod or bait.",Duration=6})end)
   if not ok then a6("MONEY POPUP unavailable: "..tostring(err))end
  end
  pcall(function()if type(readfile)=="function" and (type(isfile)~="function" or isfile(configFile))then local data=http:JSONDecode(readfile(configFile));if type(data)=="table" then cfg=data end end end)
  B.instaFish=type(cfg.instaFish)=="table" and cfg.instaFish or B.instaFish or {}
  if tonumber(cfg.baitQty) then B.baitQty=math.clamp(math.floor(cfg.baitQty),1,100)end
  if type(cfg.rod)=="table" and type(cfg.rod.name)=="string" and tonumber(cfg.rod.price) and cfg.rod.price>0 then B.selectedRod={name=cfg.rod.name,price=cfg.rod.price};B.cheapestRod=B.selectedRod end
  if type(cfg.bait)=="table" and type(cfg.bait.name)=="string" and tonumber(cfg.bait.price) and cfg.bait.price>0 then B.selectedBait={name=cfg.bait.name,price=cfg.bait.price};B.cheapestBait=B.selectedBait;B.baitPrice=cfg.bait.price end
  B.farmMode="Underground";cfg.farmMode="Underground";B.spotChoice="auto";B.sellAt=math.clamp(math.floor(tonumber(cfg.sellAt) or 10),1,100);B.autoExecuteHop=cfg.autoExecuteHop==true
  B.saveUserConfig=function()
   cfg.farmMode=B.farmMode;cfg.fishingSpot=B.spotChoice;cfg.sellAt=B.sellAt;cfg.baitQty=B.baitQty;cfg.instaFish=B.instaFish;cfg.rod=B.selectedRod;cfg.bait=B.selectedBait;cfg.autoExecuteHop=B.autoExecuteHop;cfg.autoDepositThreshold=B.autoDepositThreshold
   if type(writefile)~="function" then a6("SAVE CONFIG failed: executor has no writefile");return false end
   local ok,err=pcall(function()writefile(configFile,http:JSONEncode(cfg))end);a6(ok and "CONFIG saved" or ("SAVE CONFIG failed: "..tostring(err)));return ok
  end
  B.customUnderFishMark=cW(bo("auto_fish_under_fish_spot.txt"));B.underFishMark=B.customUnderFishMark
  B.orderedCoords={}
  do
   local raw=bo("auto_fish_ordered_coords.json")
   if raw and raw~="" then
    local ok,data=pcall(function()return game:GetService("HttpService"):JSONDecode(raw)end)
    if ok and type(data)=="table" and data.placeId==game.PlaceId and type(data.points)=="table" then
     for _,point in ipairs(data.points)do
      local x1,y1,z1=tonumber(point.x),tonumber(point.y),tonumber(point.z)
      if x1 and y1 and z1 and x1==x1 and y1==y1 and z1==z1 and math.abs(x1)<100000 and math.abs(y1)<100000 and math.abs(z1)<100000 then B.orderedCoords[#B.orderedCoords+1]={x=x1,y=y1,z=z1}end
     end
    end
   end
  end
  B.addOrderedCoordinate=function()
   local camera=x.CurrentCamera;local root=ao()
   local position=B.freecamActive and camera and camera.CFrame.Position or root and root.Position
   if not position or not B.finiteVector(position) then a6("COORDS: position unavailable");return end
   if #B.orderedCoords>=1000 then a6("COORDS: 1000-point limit reached");return end
   B.orderedCoords[#B.orderedCoords+1]={x=position.X,y=position.Y,z=position.Z}
   local index=#B.orderedCoords
   local ok,encoded=pcall(function()return game:GetService("HttpService"):JSONEncode({placeId=game.PlaceId,points=B.orderedCoords})end)
   local saved=ok and br("auto_fish_ordered_coords.json",encoded) or false
   a6("COORD "..index.." marked: "..tostring(position).." source="..(B.freecamActive and "freecam" or "character").." saved="..tostring(saved))
   pcall(function()P("Coord "..index.." marked",string.format("X %.3f   Y %.3f   Z %.3f",position.X,position.Y,position.Z))end)
  end
  B.copyOrderedCoordinates=function()
   local lines={"===== MARKED COORDINATES =====","PlaceId: "..tostring(game.PlaceId),"Order: first marked to last marked"}
   for index,point in ipairs(B.orderedCoords)do lines[#lines+1]=string.format("Coord %d: X = %.3f, Y = %.3f, Z = %.3f",index,point.x,point.y,point.z)end
   if #B.orderedCoords==0 then lines[#lines+1]="No coordinates marked yet."end
   lines[#lines+1]="===== END COORDINATES ====="
   local text=table.concat(lines,"\n")
   B.coordinateClipboardHoldUntil=os.clock()+120
   local copied=iV(text);local saved=br("auto_fish_coordinates.txt",text)
   a6("COORDS: copied "..#B.orderedCoords.." ordered points="..tostring(copied).." file="..tostring(saved).."; report auto-copy paused for 120s")
   if not copied then iW(text)end
   pcall(function()P(copied and "All coords copied" or "Clipboard unavailable",copied and "Report auto-copy paused for 2 minutes" or "Check executor console or coordinates file")end)
  end
  dev:Button("MARK COORD","Save freecam position, or character position when freecam is off",function()B.addOrderedCoordinate()end)
  dev:Button("COPY ALL COORDS","Copy marked coordinates in the order saved",function()B.copyOrderedCoordinates()end)
  dev:Button("NOCLIP DOWN","Move onto a nearby solid floor below",function()
   if B.busy or B.autoFish then a6("NOCLIP DOWN: stop Auto Farm first");return end
   if B.stopFreecam then B.stopFreecam()end
   local root=ao();local hum=aq();if not root or not hum or hum.SeatPart then a6("NOCLIP DOWN: exit the car first");return end
   local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.IgnoreWater=true;rp.RespectCanCollide=true
   local ignored={z.Character};if B.car then ignored[#ignored+1]=B.car end;if B.underFloor then ignored[#ignored+1]=B.underFloor end;rp.FilterDescendantsInstances=ignored
   local start=root.Position-Vector3.new(0,5,0)
   local ok,hit=pcall(function()return x:Raycast(start,Vector3.new(0,-18,0),rp)end)
   if not ok or not hit or hit.Normal.Y<.6 or hit.Material==Enum.Material.Water or (hit.Instance~=x.Terrain and not hit.Instance.CanCollide) then
    a6("NOCLIP DOWN: no solid game floor found within 18 studs below surface; no move made")
    pcall(function()P("No nearby floor","No move made. Use Freecam to find a solid floor.")end);return
   end
   local targetY=hit.Position.Y+hum.HipHeight+root.Size.Y/2
   if targetY>=root.Position.Y-.5 or root.Position.Y-targetY>22 then
    a6("NOCLIP DOWN: floor is not just below the current position; no move made");return
   end
   B.setCharacterNoclip(true);B.manualUnderground=true
   local old=root.Position;local success,err=pcall(function()
    root.AssemblyLinearVelocity=Vector3.zero
    root.CFrame=root.CFrame+Vector3.new(0,targetY-old.Y,0)
   end)
   if not success then B.manualUnderground=false end
   a6(success and ("NOCLIP DOWN: placed "..tostring(root.Position).." above game floor "..Y(hit.Instance)) or ("NOCLIP DOWN failed: "..tostring(err)))
  end)
  dev:Button("MARK UNDERGROUND FISH SPOT","Stand on the game's underground floor to save",function()
   if B.busy or B.autoFish then a6("MARK: stop Auto Farm first");return end
   local root=ao();local hum=aq();if not root or not hum or hum.SeatPart then a6("MARK: stand on foot at the spot");return end
   local hit=B.realFishFloor(root.Position.X,root.Position.Z,root.Position.Y)
   if not hit then a6("MARK refused: no solid game floor below your feet");pcall(function()P("Mark not saved","Stand on a solid underground floor first")end);return end
   local mark=root.Position;B.underFishMark=mark
   local saved=br("auto_fish_under_fish_spot.txt",p(mark.X)..","..p(mark.Y)..","..p(mark.Z))
   a6("UNDERGROUND FISH MARK: "..tostring(mark).." floor="..tostring(hit.Instance).." persisted="..tostring(saved))
   pcall(function()P("Fishing spot marked",saved and "Underground spot saved" or "Saved for this session; executor file saving unavailable")end)
  end)
  do
   local controls=nil;local renderConn=nil;local endConn=nil;local savedCam=nil;local savedWalk=nil;local pressed={};local yaw,pitch=0,0;local position=nil
   local function closeFreecam()
    if renderConn then renderConn:Disconnect();renderConn=nil end
    if endConn then endConn:Disconnect();endConn=nil end
    if controls then controls:Destroy();controls=nil end
    pressed={};local cam=x.CurrentCamera
    if cam and savedCam then pcall(function()cam.CameraType=savedCam.kind;cam.CameraSubject=savedCam.subject;cam.CFrame=savedCam.cf end)end
    if savedWalk then pcall(function()if savedWalk.hum.Parent then savedWalk.hum.WalkSpeed=savedWalk.walk;savedWalk.hum.JumpPower=savedWalk.jump;savedWalk.hum.AutoRotate=savedWalk.rotate end end)end
    savedCam=nil;savedWalk=nil;position=nil;B.freecamActive=false
   end
   B.stopFreecam=closeFreecam
   local function saveCameraMark()
    local cam=x.CurrentCamera;local hum=aq();local root=ao();if not cam or not hum or not root then return end
    local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.IgnoreWater=true;rp.RespectCanCollide=true
    local ignored={z.Character};if B.car then ignored[#ignored+1]=B.car end;if B.underFloor then ignored[#ignored+1]=B.underFloor end;if B.skyState and B.skyState.folder then ignored[#ignored+1]=B.skyState.folder end;rp.FilterDescendantsInstances=ignored
    local ok,hit=pcall(function()return x:Raycast(cam.CFrame.Position,Vector3.new(0,-60,0),rp)end)
    if not ok or not hit or hit.Normal.Y<.6 or hit.Material==Enum.Material.Water or (hit.Instance~=x.Terrain and not hit.Instance.CanCollide) then
     a6("FREECAM MARK: no solid floor within 60 studs below camera");pcall(function()P("Mark not saved","Position freecam above the solid floor")end);return
    end
    local mark=Vector3.new(hit.Position.X,hit.Position.Y+hum.HipHeight+root.Size.Y/2,hit.Position.Z)
    B.underFishMark=mark
    local saved=br("auto_fish_under_fish_spot.txt",p(mark.X)..","..p(mark.Y)..","..p(mark.Z))
    a6("FREECAM MARK: "..tostring(mark).." floor="..Y(hit.Instance).." persisted="..tostring(saved))
    pcall(function()P("Fishing spot marked",saved and "Floor coordinates saved" or "Saved for this session only")end)
   end
   local function beginFreecam()
    if B.freecamActive then closeFreecam();return end
    if B.busy or B.autoFish then a6("FREECAM: stop Auto Farm first");return end
    local cam=x.CurrentCamera;local hum=aq();if not cam or not hum then a6("FREECAM: camera or character unavailable");return end
    savedCam={kind=cam.CameraType,subject=cam.CameraSubject,cf=cam.CFrame};savedWalk={hum=hum,walk=hum.WalkSpeed,jump=hum.JumpPower,rotate=hum.AutoRotate}
    position=cam.CFrame.Position;local look=cam.CFrame.LookVector;yaw=math.atan2(-look.X,-look.Z);pitch=math.asin(math.clamp(look.Y,-1,1))
    hum.WalkSpeed=0;hum.JumpPower=0;hum.AutoRotate=false;cam.CameraType=Enum.CameraType.Scriptable;B.freecamActive=true
    controls=create("Frame",{Name="FreecamControls",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=100},screen)
    local scale=math.min(1,(cam.ViewportSize.X-12)/700,(cam.ViewportSize.Y-12)/390)
    local left=create("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,12,1,-10),Size=UDim2.fromOffset(154,152),ZIndex=101},controls)
    create("UIScale",{Scale=scale},left)
    local right=create("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-12,1,-10),Size=UDim2.fromOffset(214,152),ZIndex=101},controls)
    create("UIScale",{Scale=scale},right)
    local function hold(parent,label,key,xPos,yPos)
     local b=create("TextButton",{Text=label,Size=UDim2.fromOffset(46,44),Position=UDim2.fromOffset(xPos,yPos),BackgroundColor3=Color3.fromRGB(10,18,25),BackgroundTransparency=.15,TextColor3=Color3.fromRGB(165,220,245),TextSize=20,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=102},parent);round(b,7)
     b.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then pressed[key]=input end end)
     b.InputEnded:Connect(function(input)if pressed[key]==input then pressed[key]=nil end end)
    end
    hold(left,"▲","forward",50,0);hold(left,"◀","left",0,49);hold(left,"▼","back",50,49);hold(left,"▶","right",100,49)
    hold(right,"↑","up",0,0);hold(right,"↓","down",0,49);hold(right,"↶","yawLeft",54,49);hold(right,"↷","yawRight",108,49);hold(right,"⌃","pitchUp",54,0);hold(right,"⌄","pitchDown",108,0)
    local coordBtn=create("TextButton",{Text="MARK COORD",Size=UDim2.fromOffset(102,40),Position=UDim2.fromOffset(0,-47),BackgroundColor3=Color3.fromRGB(35,105,145),TextColor3=Color3.new(1,1,1),TextSize=12,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=102},right);round(coordBtn,7);coordBtn.Activated:Connect(function()B.addOrderedCoordinate()end)
    local copyBtn=create("TextButton",{Text="COPY ALL",Size=UDim2.fromOffset(102,40),Position=UDim2.fromOffset(108,-47),BackgroundColor3=Color3.fromRGB(35,45,55),TextColor3=Color3.new(1,1,1),TextSize=12,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=102},right);round(copyBtn,7);copyBtn.Activated:Connect(function()B.copyOrderedCoordinates()end)
    local markBtn=create("TextButton",{Text="MARK FLOOR",Size=UDim2.fromOffset(102,40),Position=UDim2.fromOffset(0,105),BackgroundColor3=Color3.fromRGB(35,105,145),TextColor3=Color3.new(1,1,1),TextSize=12,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=102},right);round(markBtn,7);markBtn.Activated:Connect(saveCameraMark)
    local closeBtn=create("TextButton",{Text="EXIT CAM",Size=UDim2.fromOffset(102,40),Position=UDim2.fromOffset(108,105),BackgroundColor3=Color3.fromRGB(35,45,55),TextColor3=Color3.new(1,1,1),TextSize=12,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=102},right);round(closeBtn,7);closeBtn.Activated:Connect(closeFreecam)
    endConn=UIS.InputEnded:Connect(function(input)for key,value in pairs(pressed)do if value==input then pressed[key]=nil end end end)
    renderConn=game:GetService("RunService").RenderStepped:Connect(function(dt)
     local live=x.CurrentCamera;if not live or not position then return end;dt=math.min(dt,.1)
     local function down(key,code)return pressed[key]~=nil or (code and UIS:IsKeyDown(code)) end
     yaw=yaw+((down("yawLeft",Enum.KeyCode.Left) and 1 or 0)-(down("yawRight",Enum.KeyCode.Right) and 1 or 0))*1.5*dt
     pitch=math.clamp(pitch+((down("pitchUp",Enum.KeyCode.Up) and 1 or 0)-(down("pitchDown",Enum.KeyCode.Down) and 1 or 0))*1.2*dt,-1.48,1.48)
     local rotation=CFrame.Angles(0,yaw,0)*CFrame.Angles(pitch,0,0)
     local forward=(down("forward",Enum.KeyCode.W) and 1 or 0)-(down("back",Enum.KeyCode.S) and 1 or 0)
     local strafe=(down("right",Enum.KeyCode.D) and 1 or 0)-(down("left",Enum.KeyCode.A) and 1 or 0)
     local rise=(down("up",Enum.KeyCode.E) and 1 or 0)-(down("down",Enum.KeyCode.Q) and 1 or 0)
     local direction=rotation.LookVector*forward+rotation.RightVector*strafe+Vector3.new(0,rise,0)
     if direction.Magnitude>1 then direction=direction.Unit end
     position=position+direction*35*dt;live.CameraType=Enum.CameraType.Scriptable;live.CFrame=CFrame.new(position)*rotation
    end)
    a6("FREECAM: touch controls; MARK FLOOR saves floor below camera; avatar remains in place")
   end
   screen.Destroying:Connect(closeFreecam)
   dev:Button("FREECAM","Touch controls; mark the floor beneath the camera",beginFreecam)
  end
  do
   local active=false;local points={};local vehicle=nil
   B.stopDevTrail=function(save)
    if not active then return end;active=false
    if save then local ok,why=B.addDeveloperTrail(points);a6(ok and "DEV TRAIL: saved and available to route planner" or ("DEV TRAIL not saved: "..tostring(why)));pcall(function()P("Developer trail",ok and ("Saved "..#points.." points") or tostring(why))end)
    else a6("DEV TRAIL: cancelled")end
   end
   dev:Button("START TRAIL","Stop Auto Farm, sit in your car and drive on dry roads",function()
    if active then a6("DEV TRAIL: already recording");return end
    if B.busy or B.autoFish then a6("DEV TRAIL: stop Auto Farm first");return end
    local hum=aq();local seat=hum and hum.SeatPart;vehicle=seat and aO(seat)
    if not vehicle or not seat:IsA("VehicleSeat") then a6("DEV TRAIL: sit in driver's seat first");pcall(function()P("Developer trail","Sit in your car first")end);return end
    points={};active=true;a6("DEV TRAIL: recording manually driven dry road; press STOP / SAVE")
    task.spawn(function()
     while active and B.devEnabled do
      local current=aq();local pos=at(vehicle);local cf=ax(vehicle);local ground=pos and eV(pos.X,pos.Z,pos.Y+7)
      if not current or not current.SeatPart or not current.SeatPart:IsDescendantOf(vehicle) or not pos or not ground or not cf or cf.UpVector.Y<.8 or pos.Y-ground<-.5 or pos.Y-ground>8 then
       B.stopDevTrail(false);a6("DEV TRAIL: cancelled: no seated dry-ground vehicle position");break
      end
      local last=points[#points];local dist=last and math.sqrt((pos.X-last.x)^2+(pos.Z-last.z)^2) or 1e9
      if dist>=8 then
       if last and (dist>28 or math.abs(pos.Y-last.y)>6) then B.stopDevTrail(false);a6("DEV TRAIL: cancelled: path gap / flight detected");break end
       points[#points+1]={x=pos.X,y=pos.Y,z=pos.Z};if #points>=400 then B.stopDevTrail(true);break end
      end
      task.wait(.1)
     end
    end)
   end)
   dev:Button("STOP / SAVE TRAIL","Save and add the recorded road to the path graph",function()if active then B.stopDevTrail(true)else a6("DEV TRAIL: not recording")end end)
   dev:Button("CANCEL TRAIL","Discard the current recording",function()B.stopDevTrail(false)end)
  end
  dev:Button("SET LEVEL 0 SPOT","Stand at a working Level 0 fishing position, then press",function()
   if B.busy or B.autoFish then a6("LEVEL 0: stop Auto Farm first");return end
   local root=ao();local hum=aq();if not root or not hum or hum.SeatPart then a6("LEVEL 0: stand at the fishing spot on foot");return end
   local position=root.Position;local hit=B.realFishFloor(position.X,position.Z,position.Y)
   if not hit or math.abs(position.Y-hit.Position.Y)>8 then a6("LEVEL 0: no nearby game floor; spot not saved");pcall(function()P("Level 0 spot","Stand on the game floor first")end);return end
   if not B.orderedCoords or #B.orderedCoords<6 then a6("LEVEL 0: ordered mark 6 unavailable; use MARK COORD first");return end
   local previous=B.orderedCoords[6];B.orderedCoords[6]={x=position.X,y=position.Y,z=position.Z}
   local ok,encoded=pcall(function()return game:GetService("HttpService"):JSONEncode({placeId=game.PlaceId,points=B.orderedCoords})end)
   local saved=ok and br("auto_fish_ordered_coords.json",encoded)
   if not saved then B.orderedCoords[6]=previous;a6("LEVEL 0: could not save ordered mark 6");return end
   B.levelFishingSpots[0]=position;B.spotChoice="0";cfg.fishingSpot="0"
   a6("LEVEL 0: user-set position "..tostring(position).."; cast water still requires server validation")
   pcall(function()P("Level 0 spot","Saved your standing position; select Level 0 and test a cast")end)
  end)
  dev:Button("VEHICLE SNAP TEST","Experimental; stop farming and use at your own risk",function()k3()end)
  dev:Button("COPY VEHICLE SCAN","Copy a diagnostic scan of the current vehicle",function()kC("developer scan",true)end)
  dev:Button("START REPAIR RECORDER","Experimental remote hook remains until rejoin",function()if B.busy or B.autoFish then a6("Stop farming before starting repair recorder");return end;B.startRepairRecorder()end)
  dev:Button("COPY REPAIR REPORT","Stop recorder and copy the captured report",function()B.copyRepairRecorder()end)
  home:Dropdown("FISHING SPOT","Required: choose your level; applies next trip",function()return {
   {label="Automatic",value="auto"},{label="Level 0",value="0"},{label="Level 10",value="10"},{label="Level 20",value="20"},{label="Level 25",value="25"}
  }end,function(item)return item.value==B.spotChoice end,function(item)
   B.spotChoice=item.value;cfg.fishingSpot=item.value;a6("FISH SPOT selection: "..item.label.." (next fishing trip)")
   if B.waitingForSpot and B.userFarmIntent then
    B.waitingForSpot=false;B.phase="STARTING: "..item.label
    task.defer(function()if screen.Parent and B.userFarmIntent then
     if B.activeIncludePlanting then a6("AUTO FARM: level selected; starting planting cycle");B.startIntegratedPlant()
     else a6("AUTO FARM: level selected; starting fishing");B.farmRequested=true;k2() end
    end end)
   end
  end,false)
  B.autoDepositThreshold=math.clamp(math.floor(tonumber(cfg.autoDepositThreshold) or 10000),1,100000)
  home:Slider("AUTO DEPOSIT","Deposit wallet when it reaches this amount",1,100000,B.autoDepositThreshold,1,function(value)
   B.autoDepositThreshold=value;cfg.autoDepositThreshold=value
  end)
  home:Slider("FISH BEFORE SELL","Confirmed catches; out-of-bait and Insta Sell can sell earlier",1,100,B.sellAt,1,function(value)
   B.sellAt=value;cfg.sellAt=value;a6("SELL LIMIT: "..tostring(value).." confirmed catches")
   if B.saveUserConfig then B.saveUserConfig()end
  end)
  -- Experimental plant workflow. Unknown transaction protocols are never guessed.
  do
   local running,cancel=false,false
   local plantUserEnabled=false;local autoRetries=0
   local report="No plant run yet."
   local function plantAction(value)
    if not value then if running then cancel=true;B.farmRequested=false;if B.busy or B.autoFish then pcall(j3) end;a6("PLANT: stopping") end;return end
    if running then return end
    if B.busy or B.autoFish or B.farmRequested or B.recovering or (B.autoDrive and B.autoDrive.active) then a6("PLANT: stop Auto Farm first");return end
    if type(fireproximityprompt)~="function" then a6("PLANT: proximity prompt support required");return end
    running=true;cancel=false;B.stop=false;B.done=false
    task.spawn(function()
     local lines={"===== INTEGRATED PLANT RUN ====="};local lastNote=""
     local function note(t) lastNote=t;lines[#lines+1]=t;report=table.concat(lines,"\n");a6(t) end
     local function valid() return not cancel and screen.Parent and not B.farmRequested and z.Character and z.Character:FindFirstChild("HumanoidRootPart") end
     local function promptPos(p) local q=p and p.Parent;return q and (q:IsA("BasePart") and q.Position or q:IsA("Attachment") and q.WorldPosition) end
     -- Only PLANT on-foot travel: never interfere with the driver's vehicle seat
     -- or with the fishing phase. Sitting in an ordinary house chair is accidental.
     task.spawn(function()
      while running and not cancel and screen.Parent do
       local ch=z.Character;local hum=ch and ch:FindFirstChildOfClass("Humanoid")
       local seat=hum and hum.SeatPart
       if not B.farmRequested and seat and seat:IsA("Seat") and not seat:IsA("VehicleSeat") then
        pcall(function() hum.Sit=false;hum.Jump=true;hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        note("PLANT: jumped out of house chair")
        task.wait(.4)
       else task.wait(.15) end
      end
     end)
     local function approach(p)
      local v=promptPos(p);if not v then return false end
      -- Pot teleport is limited to a nearby confirmed owned house. Never use it
      -- for mailbox, ATM, shop, car, or fishing movement.
      if p.Name=="MD_FarmAction" then
       local node=p.Parent;local owner=nil
       while node and node~=workspace do
        if node:IsA("Model") and node:GetAttribute("MD_RentedBy")~=nil then owner=tostring(node:GetAttribute("MD_RentedBy"));break end
        node=node.Parent
       end
       local ch=z.Character;local root=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
       if owner~=tostring(z.UserId) or not root or not hum or hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then return false end
       if (root.Position-v).Magnitude>120 then note("STOP: pot too far for nearby teleport");return false end
       local range=tonumber(p.MaxActivationDistance) or 0;if range<=1 then range=7 end
       local tolerance=math.max(1.5,range-.6)
       if Vector3.new(root.Position.X-v.X,0,root.Position.Z-v.Z).Magnitude<=.5 and (root.Position-v).Magnitude<=tolerance and not hum.SeatPart then return true end
       local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={ch};params.IgnoreWater=false
       for _,offset in ipairs({Vector3.zero}) do
        local point=v+offset
        local hit=workspace:Raycast(point+Vector3.new(0,6,0),Vector3.new(0,-16,0),params)
        if hit and hit.Material~=Enum.Material.Water and hit.Normal.Y>=.6 then
         local height=math.max(2,hum.HipHeight+root.Size.Y/2)
         local destination=Vector3.new(point.X,hit.Position.Y+height,point.Z)
         if (destination-v).Magnitude<=tolerance and math.abs(hit.Position.Y-v.Y)<=8 then
          pcall(function()hum.Sit=false;hum.Jump=true;hum:Move(Vector3.zero,false);root.AssemblyLinearVelocity=Vector3.zero;root.CFrame=CFrame.new(destination);hum:MoveTo(destination) end)
          task.wait(.3)
          root=ch:FindFirstChild("HumanoidRootPart")
          if valid() and root and (root.Position-v).Magnitude<=tolerance then note("PLANT: positioned at "..p.Parent.Name.." ("..string.format("%.1f",(root.Position-v).Magnitude).." studs)");return true end
         end
        end
       end
       note("STOP: could not verify a nearby dry pot position");return false
      end
      local root=z.Character and z.Character:FindFirstChild("HumanoidRootPart");if not root then return false end
      local configured=tonumber(p.MaxActivationDistance) or 0
      -- Some farming prompts replicate with distance zero; use a close physical
      -- approach and still require the server to confirm every action.
      local range=configured>1 and configured or 7
      if (root.Position-v).Magnitude<=math.max(2,range-1) then return true end
      local ok,why=cR(v+Vector3.new(0,2,0),math.max(1.5,math.min(3,range-2)),90)
      root=z.Character and z.Character:FindFirstChild("HumanoidRootPart")
      local distance=root and (root.Position-v).Magnitude or math.huge
      if not ok or distance>range then note("APPROACH "..p.Name.." distance="..string.format("%.1f",distance).." range="..tostring(configured).." reason="..tostring(why));return false end
      return true
     end
     local function houseOwned(tiles)
      local found={};for _,o in ipairs(tiles:GetDescendants()) do if o:IsA("Model") and tostring(o:GetAttribute("MD_RentedBy"))==tostring(z.UserId) then found[#found+1]=o end end
      if #found==1 then return found[1] end
      return nil,#found
     end
     local purchaseLedger={}
     local function count(name)
      local n=0;local ch=z.Character;local bag=z:FindFirstChild("Backpack")
      for _,container in ipairs({ch,bag}) do if container then for _,v in ipairs(container:GetChildren()) do if v:IsA("Tool") and v.Name==name then n+=math.max(1,tonumber(v:GetAttribute("MD_StackCount")) or 1) end end end end
      local ledger=purchaseLedger[name]
      if ledger then n=math.max(n,math.max(0,ledger.base+ledger.bought-ledger.used)) end
      return n
     end
     local function equip(name)
      local ch=z.Character;local h=ch and ch:FindFirstChildOfClass("Humanoid");local bag=z:FindFirstChild("Backpack");local tool=ch and (ch:FindFirstChild(name) or (bag and bag:FindFirstChild(name)))
      if not h or not tool or not tool:IsA("Tool") then return false end
      if tool.Parent~=ch then h:EquipTool(tool) end
      local deadline=os.clock()+3;while valid() and tool.Parent~=ch and os.clock()<deadline do task.wait(.1) end
      return tool.Parent==ch
     end
     local function action(p,expected,tool)
      if not valid() or not p or not p.Parent then return false,"prompt missing" end
      if not approach(p) then return false,"could not reach prompt" end
      local untilEnabled=os.clock()+3;while valid() and p.Parent and not p.Enabled and os.clock()<untilEnabled do task.wait(.1) end
      if not p.Enabled or not p.ActionText:lower():find(expected,1,true) then return false,"prompt unavailable or changed: "..tostring(p.ActionText) end
      if tool and not equip(tool) then return false,"missing "..tool end
      if tool=="SunflowerSeeds" then task.wait(.6);if not valid() or not z.Character or not z.Character:FindFirstChild(tool) then return false,"seed equip did not remain confirmed" end end
      -- Equipping or server correction may move the avatar: re-check immediately
      -- before each one-shot action; never retry an unconfirmed action.
      if not approach(p) then return false,"moved out of prompt range" end
      local ancestor=p.Parent;local owned=false
      while ancestor and ancestor~=workspace do
       if ancestor:IsA("Model") and ancestor:GetAttribute("MD_RentedBy")~=nil then owned=tostring(ancestor:GetAttribute("MD_RentedBy"))==tostring(z.UserId);break end
       ancestor=ancestor.Parent
      end
      if not owned then return false,"house ownership not confirmed" end
      local before=p.ActionText
      local ok
      if expected=="harvest" then
       local hold=math.max(0,tonumber(p.HoldDuration) or 0)
       a6("PLANT HARVEST: single prompt attempt; hold="..tostring(hold))
       ok=pcall(fireproximityprompt,p,hold+.25)
      else
       ok=pcall(fireproximityprompt,p)
      end
      if not ok then return false,"prompt call failed" end
      local untilTime=os.clock()+5
      while valid() and p.Parent and os.clock()<untilTime do
       local state=p.ActionText:lower()
       local confirmed=(expected=="harvest" and (state:find("add soil",1,true) or state:find("plant seed",1,true)))
        or (expected=="add soil" and state:find("plant seed",1,true))
        or (expected=="plant seed" and (state:find("water",1,true) or state:find("fertilize",1,true)))
       if confirmed then
        if tool and purchaseLedger[tool] then purchaseLedger[tool].used+=1 end
        return true
       end;task.wait(.1)
      end
      return false,"no state confirmation; no retry"
     end
     local function travel(v,shopApproach,atm,houseApproach)
      if not valid() then return false end
      B.plantFootPath=nil
      if B.travelMode=="Teleport" then
       local target=v
       if atm then B.atmTarget=atm;local obj=H.resolveMarkedAtm(atm);local prompt=obj and obj:FindFirstChild("MD_ATMPrompt",true);target=prompt and promptPos(prompt) end
       if not target then note("STOP: teleport destination unavailable");return false end
       local ok,why=B.teleportCharacter(target,"PLANT",false);if not ok then note("STOP: teleport failed "..tostring(why));return false end
       B.car=nil;B.autoDrive={active=false,done=true,stage="PLANT_TRAVEL",mode="teleport"};return true
      end
      local car=B.car or cd();if not car then note("STOP: car unavailable");return false end
      B.car=car;B.stop=false;B.done=false;B.busy=true;B.routeMode="Above ground";B.activeFarmMode="Underground";B.lastFailure=nil;B.lastRouteFailure=nil
      if not aL(car) then
       local gui=z:FindFirstChild("PlayerGui");local atmGui=gui and gui:FindFirstChild("MD_ATMGui");local panel=atmGui and atmGui:FindFirstChild("Panel")
       local close=panel and panel:FindFirstChild("Close")
       if panel and panel.Visible and close and close:IsA("GuiButton") and close.Visible then
        local closed,why=B.pressGameButton(close);note("ATM UI close attempted: "..tostring(closed).." "..tostring(why));task.wait(.3)
       end
       local chassis=car:FindFirstChild("Chassis",true)
       if chassis and chassis:IsA("BasePart") and chassis.Anchored then
        -- Reuse existing grounded-car release check inside dt; never force a seat.
        B.justReturnedFromFishing=true;note("RETURN: checking parked car is grounded before releasing anchor")
       end
       if not dQ("PLANT") then B.justReturnedFromFishing=false;note("STOP: could not return to or board car: "..tostring(B.boardProblem or "seat not confirmed"));return false end
      end
      -- Never unanchor and restart a car that is already embedded in a wall.
      local body=car:FindFirstChild("MD_BodyCollision",true) or car:FindFirstChild("Chassis",true)
      if body and body:IsA("BasePart") then
       local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={car,z.Character};params.MaxParts=100
       local ok,hits=pcall(function()return workspace:GetPartBoundsInBox(body.CFrame,body.Size+Vector3.new(1,1,1),params)end)
       local clear=ok;local bottom=body.Position.Y-body.Size.Y/2
       if ok then for _,part in ipairs(hits) do if part.CanCollide and part.Position.Y+part.Size.Y/2>bottom+1 then clear=false;break end end end
       if not clear then note("STOP: car is already overlapping an obstacle; move or respawn it before restarting");return false end
      end
      B.liftStarted=false
      local target={x=v.X,y=v.Y,z=v.Z};local stage="PLANT_TRAVEL"
      if atm then
       B.atmTarget=atm
       target=H.atmDriveTarget(atm)
       if not target then note("STOP: ATM parking planner returned no target");return false end
       stage="PLANT_ATM";note("ATM: planned parking after vehicle scan/boarding")
      end
      -- When far from the recorded road, check a car-width join before moving.
      -- Do not enable smart dodging or bridge unrelated trail gaps.
      local join=nil;local alternateRecorded=nil;local carPos=at(car)
      local recorded=carPos and B.arenaRecordedRoute(carPos,target)
      local first=recorded and recorded[1]
      if carPos and first then
       local distance=Vector3.new(first.x-carPos.X,0,first.z-carPos.Z).Magnitude
       if distance>14 then
        local ground=eV(first.x,first.z,carPos.Y+12)
        if not ground then note("STOP: road-join ground not verified");return false end
        note("PLANT: checking car-width route to recorded road ("..math.floor(distance).." studs)")
        join=f8(carPos,{x=first.x,y=ground,z=first.z})
        if not join or #join==0 then
         -- Pathfinder can reject a short, straight open road. Test the full
         -- car-body corridor instead of treating that rejection as a wall.
         local body=car:FindFirstChild("MD_BodyCollision",true) or car:FindFirstChild("Chassis",true)
         local clear=body and body:IsA("BasePart") and body.CFrame.UpVector.Y>=.85
         local corridor={};local dx,dz=first.x-carPos.X,first.z-carPos.Z;local length=math.sqrt(dx*dx+dz*dz)
         if clear and length>0 and length<=85 then
          local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={car,z.Character};params.MaxParts=100
          local steps=math.max(1,math.ceil(length/4))
          for step=1,steps do
           local x=carPos.X+dx*step/steps;local z=carPos.Z+dz*step/steps
           local y=eV(x,z,carPos.Y+12)
           if not y or math.abs(y-ground)>5 then clear=false;break end
           local center=Vector3.new(x,y+body.Size.Y/2+0.8,z)
           local frame=CFrame.lookAt(center,center+Vector3.new(dx,0,dz))
           local ok,hits=pcall(function()return workspace:GetPartBoundsInBox(frame,body.Size+Vector3.new(1,0,1),params)end)
           if not ok then clear=false;break end
           for _,part in ipairs(hits) do if part.CanCollide and part.Position.Y+part.Size.Y/2>y+1.2 then clear=false;break end end
           if not clear then break end
           if step==steps or step%3==0 then corridor[#corridor+1]={x=x,z=z,connector=true} end
          end
         else clear=false end
         if clear and #corridor>0 then
          join=corridor;note("PLANT: pathfinder declined; short car-body corridor checked clear")
         else
          note("PLANT: first road join blocked; checking alternate recorded-road joins")
          local seen={}
          for _,offset in ipairs({Vector3.new(65,0,0),Vector3.new(-65,0,0),Vector3.new(0,0,65),Vector3.new(0,0,-65),Vector3.new(95,0,95),Vector3.new(-95,0,-95)}) do
           if not valid() then return false end
           local road=B.closestRecordedFishRoad(carPos+offset)
           if road then
            local key=math.floor(road.x/5)..":"..math.floor(road.z/5)
            local dist=Vector3.new(road.x-carPos.X,0,road.z-carPos.Z).Magnitude
            if not seen[key] and dist<=180 then
             seen[key]=true
             local trial=f8(carPos,road)
             local route=trial and B.arenaRecordedRoute(Vector3.new(road.x,road.y,road.z),target)
             if trial and #trial>0 and route and #route>0 then join=trial;alternateRecorded=route;note("PLANT: alternate car-width road join found");break end
            end
           end
          end
          if not join then
           local distance=(Vector3.new(v.X,0,v.Z)-Vector3.new(carPos.X,0,carPos.Z)).Magnitude
           -- ATM-specific fallback: park only on verified dry ground, then
           -- follow a separately computed pedestrian path, not the car route.
           if atm and distance<=600 then
            local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={car,z.Character};params.IgnoreWater=false
            local ground=workspace:Raycast(carPos+Vector3.new(0,3,0),Vector3.new(0,-15,0),params)
            local body=car:FindFirstChild("MD_BodyCollision",true) or car:FindFirstChild("Chassis",true)
            local upright=body and body:IsA("BasePart") and body.CFrame.UpVector.Y>=.85
            local ok,path=pcall(function()
             local p=game:GetService("PathfindingService"):CreatePath({AgentRadius=2,AgentHeight=5,AgentCanJump=true,WaypointSpacing=6})
             p:ComputeAsync(carPos+Vector3.new(0,2,0),v);return p
            end)
            local points=ok and path and path.Status==Enum.PathStatus.Success and path:GetWaypoints() or nil
            local safe=points and #points>0 and #points<=250 and ground and ground.Material~=Enum.Material.Water and ground.Normal.Y>=.6 and carPos.Y-ground.Position.Y<=8 and upright
            if safe then
             local prior=carPos
             for _,waypoint in ipairs(points) do
              local dest=waypoint.Position;local length=(dest-prior).Magnitude
              if length>35 then safe=false;break end
              for j=1,math.max(1,math.ceil(length/5)) do
               local pt=prior:Lerp(dest,j/math.max(1,math.ceil(length/5)))
               local hit=workspace:Raycast(pt+Vector3.new(0,5,0),Vector3.new(0,-14,0),params)
               if not hit or hit.Material==Enum.Material.Water or hit.Normal.Y<.55 or math.abs(pt.Y-hit.Position.Y)>9 then safe=false;break end
              end
              if not safe then break end;prior=dest
             end
            end
            if not safe and ground and ground.Material~=Enum.Material.Water and ground.Normal.Y>=.6 and carPos.Y-ground.Position.Y<=8 and upright and distance<=250 then
             -- If Roblox pathfinding returns no route, test short direct and
             -- dogleg pedestrian corridors, sampling ground and both sides.
             local function checkedWalk(stops)
              local output={};local previous=carPos;local floorY=ground.Position.Y
              local cast=RaycastParams.new();cast.FilterType=Enum.RaycastFilterType.Exclude;cast.FilterDescendantsInstances={car,z.Character};cast.IgnoreWater=false;cast.RespectCanCollide=true
              for _,goal in ipairs(stops) do
               local horizontal=Vector3.new(goal.X-previous.X,0,goal.Z-previous.Z);local length=horizontal.Magnitude
               local dir=length>.01 and horizontal.Unit or Vector3.new(1,0,0);local side=Vector3.new(-dir.Z,0,dir.X)
               local steps=math.max(1,math.ceil(length/5));local prevGround=Vector3.new(previous.X,floorY,previous.Z)
               for i=1,steps do
                local p=previous:Lerp(goal,i/steps)
                local hit=workspace:Raycast(Vector3.new(p.X,floorY+8,p.Z),Vector3.new(0,-18,0),cast)
                if not hit or hit.Material==Enum.Material.Water or hit.Normal.Y<.6 or math.abs(hit.Position.Y-floorY)>3 then return nil end
                local nextGround=Vector3.new(p.X,hit.Position.Y,p.Z)
                for _,off in ipairs({-1.2,0,1.2}) do for _,height in ipairs({1.5,3.5}) do
                 local start=prevGround+side*off+Vector3.new(0,height,0)
                 local finish=nextGround+side*off+Vector3.new(0,height,0)
                 local obstruction=workspace:Raycast(start,finish-start,cast)
                 if obstruction and obstruction.Instance.CanCollide then return nil end
                end end
                floorY=hit.Position.Y;prevGround=nextGround
                output[#output+1]={Position=nextGround,Action=Enum.PathWaypointAction.Walk}
               end
               previous=goal
              end
              return output
             end
             local dx,dz=v.X-carPos.X,v.Z-carPos.Z;local norm=math.max(1,math.sqrt(dx*dx+dz*dz));local side=Vector3.new(-dz/norm,0,dx/norm)
             local mid=(carPos+v)*.5
             for _,shift in ipairs({0,25,-25,50,-50}) do
              local stops=shift==0 and {v} or {mid+side*shift,v}
              local trial=checkedWalk(stops)
              if trial and #trial>0 then points=trial;safe=true;note("PLANT ATM: checked dry walking corridor offset="..shift);break end
             end
            end
            note("PLANT ATM: pedestrian fallback distance="..math.floor(distance).." path="..tostring(points and #points or 0).." dry="..tostring(safe and true or false))
            if safe then
             local root=aI(car);if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
             local anchored,parked=pcall(anchorCar,true)
             if anchored and parked then
              B.plantFootPath=points;B.autoDrive={active=false,done=true,stage="PLANT_ATM"}
              note("PLANT ATM: car parked on dry ground; following checked pedestrian path")
              return true
             end
            end
           end
           local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances={car,z.Character};ray.IgnoreWater=false
           local hit=workspace:Raycast(carPos+Vector3.new(0,3,0),Vector3.new(0,-15,0),ray)
           local footSafe=houseApproach and distance<=600
           local lastY=hit and hit.Position.Y
           if footSafe and hit then
            local steps=math.max(1,math.ceil(distance/10))
            for i=1,steps do
             local pt=carPos:Lerp(v,i/steps)
             local surface=workspace:Raycast(Vector3.new(pt.X,math.max(carPos.Y,v.Y)+12,pt.Z),Vector3.new(0,-35,0),ray)
             if not surface or surface.Material==Enum.Material.Water or surface.Normal.Y<.6 or (lastY and math.abs(surface.Position.Y-lastY)>9) then footSafe=false;break end
             lastY=surface.Position.Y
            end
           else footSafe=false end
           note("PLANT: house foot fallback distance="..math.floor(distance).." dry samples="..tostring(footSafe).." car ground="..tostring(hit and hit.Material))
           if footSafe and hit and hit.Material~=Enum.Material.Water and hit.Normal.Y>=.6 and carPos.Y-hit.Position.Y<=8 then
            local root=aI(car);if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
            local ok,parked=pcall(anchorCar,true)
            if ok and parked then
             B.autoDrive={active=false,done=true,stage="PLANT_TRAVEL"};note("PLANT: no verified car route; parked safely and gliding to the house on foot")
             return true
            end
           end
           note("STOP: no checked road join; no unsafe driving or automatic retry");return false
          end
         end
        end
        for _,node in ipairs(join) do node.connector=true end
       end
      end
      if not fR(target,stage) then note("STOP: route refused "..tostring(B.lastFailure or B.lastRouteFailure));return false end
      local drive=B.autoDrive
      if join and drive and drive.active and drive.surfaceWaypoints and #drive.surfaceWaypoints>0 then
       local original=alternateRecorded or drive.surfaceWaypoints
       for _,node in ipairs(original) do join[#join+1]=node end
       drive.surfaceWaypoints=join;drive.roadIndex=1;drive.connector=true;drive.localTurn=nil;B.avoid=nil
       note("PLANT: following checked join, then recorded route; smart dodge remains off")
      end
      local deadline=os.clock()+240
      while valid() and drive and drive.active and not B.stop and os.clock()<deadline do
       if (shopApproach or houseApproach) and aL(car) then
        local pos=at(car);local body=car:FindFirstChild("MD_BodyCollision",true) or car:FindFirstChild("Chassis",true)
        if pos and body and body:IsA("BasePart") and (Vector3.new(pos.X,0,pos.Z)-Vector3.new(v.X,0,v.Z)).Magnitude<=(houseApproach and 120 or 90) and body.CFrame.UpVector.Y>=.85 then
         local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.FilterDescendantsInstances={car,z.Character};overlap.MaxParts=100
         local ok,hits=pcall(function()return workspace:GetPartBoundsInBox(body.CFrame,body.Size+Vector3.new(1,1,1),overlap)end)
         local clear=ok;local bottom=body.Position.Y-body.Size.Y/2
         if ok then for _,part in ipairs(hits) do if part.CanCollide and part.Position.Y+part.Size.Y/2>bottom+1 then clear=false;break end end end
         local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances={car,z.Character};ray.IgnoreWater=false
         local grounded=workspace:Raycast(pos+Vector3.new(0,3,0),Vector3.new(0,-15,0),ray)
         if clear and grounded and grounded.Material~=Enum.Material.Water and grounded.Normal.Y>=.6 then
          drive.active=false;drive.done=true;B.speed=0
          local root=aI(car);if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
          local anchored,parked=pcall(anchorCar,true)
          if not anchored or not parked then note("STOP: could not secure shop parking");return false end
          arenaRestoreSurfaceCollision()
          if B.arenaSurfaceParts then note("STOP: shop parking collision clearance unconfirmed");return false end
          note((houseApproach and "HOUSE PARK" or "SHOP PARK")..": stopped on dry clear ground outside; continuing on foot")
          break
         end
        end
       end
       task.wait(.05)
      end
      if not valid() or B.stop or not drive or not drive.done then
       if car and aL(car) then
        local chassis=car:FindFirstChild("Chassis",true);local pos=at(car)
        if chassis and pos and chassis.CFrame.UpVector.Y>.85 then
         local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances={car,z.Character};ray.IgnoreWater=false
         local hit=workspace:Raycast(pos+Vector3.new(0,3,0),Vector3.new(0,-15,0),ray)
         if hit and hit.Material~=Enum.Material.Water and hit.Normal.Y>=.6 then pcall(anchorCar,true);note("PLANT: stopped vehicle secured; inspect before moving") end
        end
       end
       note("STOP: vehicle route incomplete "..tostring(B.lastFailure));return false
      end
      return true
     end
     local function exitTo(v)
      if B.travelMode=="Teleport" then local pos=ar();if pos and (pos-v).Magnitude<=8 then return true end;local ok,why=B.teleportCharacter(v,"PLANT approach",false);if not ok then note("STOP: "..tostring(why))end;return ok end
      if not B.car or not aL(B.car) then return false end
      local path=B.plantFootPath;B.plantFootPath=nil
      if path then
       local ok,why=dN("PLANT",nil)
       if not ok then note("STOP: car exit failed "..tostring(why));return false end
       for index,wp in ipairs(path) do
        if not valid() then return false end
        local hum=z.Character and z.Character:FindFirstChildOfClass("Humanoid")
        if hum and wp.Action==Enum.PathWaypointAction.Jump then hum.Jump=true end
        local reached,reason=cR(wp.Position+Vector3.new(0,2,0),2.5,20)
        if not reached then note("STOP: checked ATM foot path "..index.."/"..#path.." "..tostring(reason));return false end
       end
       local root=z.Character and z.Character:FindFirstChild("HumanoidRootPart")
       if not root or (root.Position-v).Magnitude>10 then
        local reached,reason=cR(v,4,20);if not reached then note("STOP: ATM final foot approach "..tostring(reason));return false end
       end
       return true
      end
      local ok,why=dN("PLANT",v,5,80)
      if not ok then note("STOP: car exit/glide failed "..tostring(why));return false end
      return true
     end
     local function button(b)
      if not b then return false end
      local ok,why=B.pressGameButton(b);if not ok then note("UI activation failed: "..tostring(why)) end;return ok
     end
     local shopHold=false
     local function supplies(soil,seed,rent)
      local missingSoil=math.max(0,soil-count("RegularSoil"));local missingSeed=math.max(0,seed-count("SunflowerSeeds"))
      local needed=missingSoil*15+missingSeed*90+(rent and 400 or 0)
      note("Budget: $"..needed.." (soil "..missingSoil..", seeds "..missingSeed..", rent "..(rent and 400 or 0)..")")
      local cash=H.readCashNumber();if cash==nil then note("STOP: cash balance unknown");return false end
      local walkedFromATM=false
      if cash<needed then
       local atm=(H.scanAtms() or {})[1];if not atm then note("STOP: no marked ATM");return false end
       if not travel(Vector3.new(atm.x,atm.y,atm.z),false,atm) then return false end
       local obj=H.resolveMarkedAtm(atm);local p=obj and obj:FindFirstChild("MD_ATMPrompt",true)
       local pos=p and promptPos(p);if not pos or not exitTo(pos+Vector3.new(0,2,0)) or not approach(p) then note("STOP: ATM prompt unreachable");return false end
       if not H.connectAtm() then return false end;B.atmOpen=false
       pcall(fireproximityprompt,p,math.max(.3,p.HoldDuration+.25),true)
       local deadline=os.clock()+5;while valid() and not B.atmOpen and os.clock()<deadline do task.wait(.1) end
       if not B.atmOpen then note("STOP: ATM open not confirmed");return false end
       cash=H.readCashNumber();local withdraw=math.max(0,needed-(cash or 0));local bank=tonumber(B.bank) or tonumber(z:GetAttribute("MD_Bank"))
       if not cash or not bank or bank<withdraw then note("STOP: insufficient or unknown bank balance");return false end
       local stable,why=H.ensureAtmStable(p);if not stable then note("STOP: ATM unstable "..tostring(why));return false end
       if withdraw>0 then
        if not bm(H.atmRemote(),"Withdraw",withdraw) then note("STOP: withdrawal send failed");return false end
        deadline=os.clock()+5;while valid() and (H.readCashNumber() or cash)<cash+withdraw and os.clock()<deadline do task.wait(.1) end
        if (H.readCashNumber() or cash)<cash+withdraw then note("STOP: withdrawal unconfirmed; no repeat");return false end
        note("Withdrawal confirmed: $"..withdraw)
       end
       B.atmTransactionHold=false;walkedFromATM=true
       local gui=z:FindFirstChild("PlayerGui");local atmGui=gui and gui:FindFirstChild("MD_ATMGui");local panel=atmGui and atmGui:FindFirstChild("Panel");local close=panel and panel:FindFirstChild("Close")
       if panel and panel.Visible and close and close:IsA("GuiButton") and close.Visible then button(close);task.wait(.2) end
      end
      if missingSoil+missingSeed==0 then return true end
      local store=workspace:FindFirstChild("HardwareStore",true);local prompt=nil
      if store then for _,p in ipairs(store:GetDescendants()) do if p:IsA("ProximityPrompt") and p.Name=="MD_JackFarmStore" then prompt=p;break end end end
      local pos=prompt and promptPos(prompt);if not pos then note("STOP: farm shop prompt not replicated");return false end
      if B.travelMode=="Teleport" then
       local ok,why=B.teleportToShopPrompt(prompt);if not ok then note("STOP: shop teleport "..tostring(why));return false end
      elseif walkedFromATM then
       note("ATM complete: leaving car parked and gliding to shop")
      else
       local target=B.shopTarget;if not target or not travel(Vector3.new(target.x,target.y,target.z),true) then return false end
       local exited,why=dN("PLANT",nil);if not exited then note("STOP: shop exit failed "..tostring(why));return false end
      end
      local first=B.walkPath and B.walkPath[1]
      if B.travelMode~="Teleport" and first and ar() and (ar()-first).Magnitude>60 then
       B.useDoorWalk=true;local reached,why=cR(first,5,90);B.useDoorWalk=false
       if not reached then note("STOP: shop entrance approach "..tostring(why));return false end
      end
      if B.travelMode~="Teleport" then
       B.useDoorWalk=true;local walked,why=da(false);B.useDoorWalk=false
       if not walked then note("STOP: recorded shop entry "..tostring(why));return false end
      end
      B.walkedFromAtm=true
      if B.travelMode=="Teleport" then
       local root=ao();local p=promptPos(prompt);local range=tonumber(prompt.MaxActivationDistance) or 0
       if not root or not p or range<=0 or (root.Position-p).Magnitude>range then note("STOP: shop prompt out of range after teleport; no purchase sent");return false end
      elseif not approach(prompt) then note("STOP: shop prompt unreachable");return false end
      local character=z.Character;local hum=character and character:FindFirstChildOfClass("Humanoid");local root=character and character:FindFirstChild("HumanoidRootPart")
      if not hum or not root then note("STOP: shop avatar unavailable");return false end
      local shopStand=root.Position;shopHold=true
      pcall(function()hum:Move(Vector3.zero,false);hum:MoveTo(shopStand);root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)end)
      task.spawn(function()
       while shopHold and valid() and z.Character==character do
        local current=character:FindFirstChild("HumanoidRootPart")
        if not current or hum.Health<=0 then break end
        pcall(function()hum:MoveTo(shopStand)end)
        task.wait(.25)
       end
      end)
      note("SHOP: holding position until all requested supplies are confirmed")
      pcall(fireproximityprompt,prompt)
      local gui=z:FindFirstChild("PlayerGui");local panel=gui and gui:FindFirstChild("MD_JackFarmShop",true);local deadline=os.clock()+5
      while valid() and (not panel or not panel.Visible) and os.clock()<deadline do task.wait(.1);panel=gui and gui:FindFirstChild("MD_JackFarmShop",true) end
      if not panel or not panel.Visible then
       note("SHOP: open not observed; retrying prompt once, no purchase sent")
       pcall(fireproximityprompt,prompt);deadline=os.clock()+3
       while valid() and (not panel or not panel.Visible) and os.clock()<deadline do task.wait(.1);panel=gui and gui:FindFirstChild("MD_JackFarmShop",true)end
      end
      if not panel or not panel.Visible then note("STOP: farm shop not confirmed open; no purchase sent");return false end
      local tab=panel:FindFirstChild("FarmTab",true);if tab then button(tab);task.wait(.5) end
      for _,item in ipairs({{"RegularSoil",missingSoil},{"SunflowerSeeds",missingSeed}}) do
       if item[1]=="SunflowerSeeds" then local seedTab=panel:FindFirstChild("SeedsTab",true);if seedTab and seedTab.Visible then button(seedTab);task.wait(.4) end end
       for _=1,item[2] do
        local catalog=panel:FindFirstChild("Catalogue",true);local card=catalog and catalog:FindFirstChild(item[1]);local price=card and card:FindFirstChild("Price")
        if not card or not price or not card.Visible then note("STOP: "..item[1].." shop card missing");return false end
        local current=z.Character and z.Character:FindFirstChild("HumanoidRootPart");local register=promptPos(prompt)
        if not current or not register or (current.Position-register).Magnitude>prompt.MaxActivationDistance then note("STOP: moved outside shop range; no purchase sent");return false end
        if not panel.Visible then note("STOP: shop closed before purchasing; no purchase sent");return false end
        if not purchaseLedger[item[1]] then purchaseLedger[item[1]]={base=count(item[1]),bought=0,used=0} end
        local old=count(item[1]);local beforeFeedback=#(B.shopFeedback or {});local cashBefore=H.readCashNumber()
        note("SHOP BUY attempt "..item[1].." old="..old.." cashBefore="..tostring(cashBefore).." feedbackBefore="..beforeFeedback)
        if not button(price) then note("STOP: "..item[1].." UI activation failed; no confirmed purchase");return false end
        local confirmed,method=false,nil;deadline=os.clock()+8
        while valid() and os.clock()<deadline do
         if count(item[1])>old then confirmed=true;method="inventory";break end
         for index=beforeFeedback+1,#(B.shopFeedback or {}) do
          local msg=tostring(B.shopFeedback[index] or "");local lower=msg:lower();local normalized=lower:gsub("[^%w]","")
          local itemMatch=normalized:find(item[1]:lower():gsub("[^%w]",""),1,true)~=nil
          local positive=lower:find("bought",1,true) or lower:find("purchased",1,true) or lower:find("purchase successful",1,true) or lower:find("purchase complete",1,true)
          local negative=lower:find("not enough",1,true) or lower:find("cannot",1,true) or lower:find("failed",1,true) or lower:find("out of stock",1,true) or lower:find("not available",1,true)
          local expectedPrice=item[1]=="RegularSoil" and 15 or 90;local nowCash=H.readCashNumber()
          local charged=cashBefore and nowCash and cashBefore-nowCash==expectedPrice
          if positive and not negative and (itemMatch or charged) then confirmed=true;method="server feedback";break end
         end
         if confirmed then break end;task.wait(.1)
        end
        if not confirmed then
         note("STOP: "..item[1].." purchase unconfirmed; no repeat; inventory="..old.."->"..count(item[1]).." cash="..tostring(cashBefore).."->"..tostring(H.readCashNumber()).." feedback="..beforeFeedback.."->"..#(B.shopFeedback or {}));return false
        end
        purchaseLedger[item[1]].bought+=1
        note(item[1].." purchase confirmed via "..method)
        -- Allow cash and shop UI to catch up before another click. Do not
        -- infer failure or resend if replication is delayed.
        local settle=os.clock()+3
        if cashBefore then while valid() and os.clock()<settle and H.readCashNumber()==cashBefore do task.wait(.1)end end
        -- The shop may ignore clicks sent immediately after confirmation.
        -- Allow the previously successful one-second spacing; never resend
        -- an unconfirmed transaction.
        task.wait(1.0)
        note("SHOP BUY settled "..item[1].." count="..count(item[1]).." cash="..tostring(H.readCashNumber()))
       end
      end
      shopHold=false;pcall(function()local r=character:FindFirstChild("HumanoidRootPart");if r then hum:Move(Vector3.zero,false);hum:MoveTo(r.Position) end end)
      note("SHOP: all planned purchases confirmed; returning to car")
      local close=panel:FindFirstChild("Close");if close and close.Visible then button(close) end
      return true
     end
     local ok,err=pcall(function()
      local ch=z.Character;local h=ch and ch:FindFirstChildOfClass("Humanoid")
      if not h or h.Health<=0 then note("STOP: character unavailable or dead");return end
      if h.SeatPart and not (B.car and aL(B.car)) then local existing=cb();if existing and aL(existing) then B.car=existing else note("STOP: seated in unrecognized vehicle");return end end
      local tiles=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Tiles")
      if not tiles then note("STOP: map unavailable");return end
      while valid() do
      local house,n=houseOwned(tiles)
      local unlocked=tonumber(z:GetAttribute("MD_FarmingPotsUnlocked"))
      if not unlocked or unlocked<1 then note("STOP: unlocked pot count not replicated");return end
      local soilNeed,seedNeed=unlocked,unlocked
      if house then
       local f=house:FindFirstChild("MD_FarmingPots");if not f then note("STOP: owned pots unavailable for budget");return end
       soilNeed,seedNeed=0,0
       for _,pot in ipairs(f:GetChildren()) do
        local p=pot:FindFirstChild("MD_FarmAction",true);local text=p and p.ActionText:lower() or ""
        if p and p.Enabled and (text:find("harvest",1,true) or text:find("add soil",1,true)) then soilNeed+=1;seedNeed+=1
        elseif p and p.Enabled and text:find("plant seed",1,true) then seedNeed+=1 end
       end
      end
      -- With an owned house, plant what is already held before making another
      -- shop trip; a level-up may have unlocked a pot after the budget was made.
      if not house then if not supplies(soilNeed,seedNeed,true) then return end end
      if not house then
       if n and n>1 then note("STOP: multiple owned houses; cannot choose safely");return end
       local choices={};local root=ch:FindFirstChild("HumanoidRootPart")
       local seen,mailboxes,unowned=0,0,0
       for _,obj in ipairs(tiles:GetDescendants()) do
        if obj.Name:lower():find("mailbox",1,true) then mailboxes+=1 end
        if obj:IsA("Model") and tostring(obj:GetAttribute("MD_RentedBy"))=="0" then unowned+=1 end
        if obj:IsA("ProximityPrompt") then
         seen+=1
         local cur=obj;local owner=nil;local path=""
         while cur and cur~=tiles do
          path=string.lower(cur.Name).."/"..path
          if owner==nil and cur:IsA("Model") then owner=cur:GetAttribute("MD_RentedBy") end
          cur=cur.Parent
         end
         local desc=(obj.Name.." "..obj.ActionText.." "..obj.ObjectText.." "..path):lower()
         local plausible=desc:find("mailbox",1,true) or desc:find("rent",1,true)
         local free=tostring(owner)=="0"
         if plausible and free and promptPos(obj) then choices[#choices+1]={prompt=obj,enabled=obj.Enabled,owner=owner} end
        end
       end
       local origin=(B.car and at(B.car)) or root.Position
       table.sort(choices,function(a,b)
        if a.enabled~=b.enabled then return a.enabled end
        return (promptPos(a.prompt)-origin).Magnitude<(promptPos(b.prompt)-origin).Magnitude
       end)
       local entry=choices[1];local p=entry and entry.prompt
       note("Mailbox scan: "..mailboxes.." mailbox objects, "..unowned.." unowned house models, "..seen.." prompts, "..#choices.." rental candidates")
       if not p then note("STOP: no replicated mailbox/rental prompt found; map may be streamed out");return end
       note("Candidate "..p:GetFullName().." enabled="..tostring(p.Enabled).." owner="..tostring(entry.owner))
       note("Driving to available mailbox")
       local mailboxPos=promptPos(p);if not travel(mailboxPos,false,nil,true) or not exitTo(mailboxPos+Vector3.new(0,2,0)) then return end
       local gui=z:FindFirstChild("PlayerGui")
       local function rentalPanel()
        local g=gui and gui:FindFirstChild("MD_HouseRentalGui");local panel=g and g:FindFirstChild("Panel");local btn=panel and panel:FindFirstChild("Rent")
        return panel,btn
       end
       local panel,rentButton=rentalPanel()
       for attempt=1,3 do
        if not valid() then return end
        if panel and panel.Visible and rentButton then break end
        if attempt>1 then
         local root=z.Character and z.Character:FindFirstChild("HumanoidRootPart");local v=promptPos(p)
         if not root or not v then note("STOP: mailbox position lost");return end
         local offset=Vector3.new(root.Position.X-v.X,0,root.Position.Z-v.Z)
         if offset.Magnitude<.5 then offset=Vector3.new(1,0,0) end
         local touchPart=p.Parent;local width=touchPart and touchPart:IsA("BasePart") and math.max(touchPart.Size.X,touchPart.Size.Z)/2 or 6
         local outside=v+offset.Unit*math.clamp(width+8,14,35)+Vector3.new(0,2,0)
         note("MAILBOX: stepping out and re-entering touch zone ("..attempt.."/3)")
         local backed,why=cR(outside,2,20);if not backed then note("STOP: mailbox reposition failed "..tostring(why));return end
        end
        local v=promptPos(p);if not v then note("STOP: mailbox position lost");return end
        local reached,why=cR(v+Vector3.new(0,2,0),1.5,25)
        if not reached then note("STOP: mailbox touch-zone approach "..tostring(why));return end
        local enabledUntil=os.clock()+2
        while valid() and p.Parent and not p.Enabled and os.clock()<enabledUntil do
         panel,rentButton=rentalPanel();if panel and panel.Visible and rentButton then break end;task.wait(.1)
        end
        panel,rentButton=rentalPanel()
        if not (panel and panel.Visible and rentButton) and p.Enabled then
         note("MAILBOX: attempting prompt "..attempt.."/3")
         local fired=pcall(fireproximityprompt,p);if not fired then note("STOP: mailbox prompt failed");return end
        end
        local untilTime=os.clock()+3
        while valid() and os.clock()<untilTime do panel,rentButton=rentalPanel();if panel and panel.Visible and rentButton then break end;task.wait(.1) end
       end
       panel,rentButton=rentalPanel()
       if not panel or not panel.Visible or not rentButton then note("STOP: mailbox offer did not open after 3 approaches; no rent sent");return end
       note("Mailbox offer open; attempting rent once")
       if not button(rentButton) then note("STOP: rent button activation failed");return end
       local deadline=os.clock()+8;while valid() and os.clock()<deadline do house=houseOwned(tiles);if house then break end;task.wait(.25) end
       if not house then note("STOP: rental not confirmed");return end
      end
      note("Owned house: "..house:GetFullName())
      local folder=house:FindFirstChild("MD_FarmingPots");if not folder then note("STOP: owned pots not replicated");return end
      local function pots()
       local out={};for _,p in ipairs(folder:GetChildren()) do if p:IsA("Model") and p.Name:match("^MD_Pot%d+$") then out[#out+1]=p end end
       table.sort(out,function(a,b)return a.Name<b.Name end);return out
      end
      local first=pots()[1];local firstPrompt=first and first:FindFirstChild("MD_FarmAction",true);local yard=firstPrompt and promptPos(firstPrompt)
      if not yard then note("STOP: owned backyard prompt position unavailable");return end
      local here=ar()
      if here and not aL(B.car) and (here-yard).Magnitude<=120 then
       note("Owned house confirmed; gliding around to its backyard")
       if not approach(firstPrompt) then note("STOP: backyard pot approach failed");return end
      else
       if not travel(yard,false,nil,true) or not exitTo(yard+Vector3.new(0,2,0)) then return end
      end
      if tostring(house:GetAttribute("MD_RentedBy"))~=tostring(z.UserId) then note("STOP: house ownership changed");return end
      local initial=pots();note("Replicated pots: "..#initial.."; unlocked attribute: "..tostring(z:GetAttribute("MD_FarmingPotsUnlocked")))
      for _,pot in ipairs(initial) do
       local p=pot:FindFirstChild("MD_FarmAction",true)
       if p and p:IsA("ProximityPrompt") and p.ActionText:lower():find("harvest",1,true) then
        local done,why=action(p,"harvest");if not done then note("STOP "..pot.Name.." harvest: "..tostring(why));return end
        note(pot.Name..": harvest state changed");task.wait(.1)
       end
      end
      local harvestCash=H.readCashNumber();local depositLimit=tonumber(B.autoDepositThreshold) or 10000
      if harvestCash and harvestCash>=depositLimit then
       local atm=(H.scanAtms()or{})[1];if not atm then note("STOP: auto deposit ATM unavailable");return end
       if not travel(Vector3.new(atm.x,atm.y,atm.z),false,atm) then return end
       local obj=H.resolveMarkedAtm(atm);local prompt=obj and obj:FindFirstChild("MD_ATMPrompt",true);local pos=prompt and promptPos(prompt)
       if not pos or not exitTo(pos+Vector3.new(0,2,0)) or not approach(prompt) then note("STOP: auto deposit prompt unreachable");return end
       H.connectAtm();B.atmOpen=false;pcall(fireproximityprompt,prompt,math.max(.3,prompt.HoldDuration+.25),true)
       local deadline=os.clock()+5;while valid() and not B.atmOpen and os.clock()<deadline do task.wait(.1)end
       if not B.atmOpen then note("STOP: auto deposit ATM not open; no transaction sent");return end
       local stable,why=H.ensureAtmStable(prompt);if not stable then note("STOP: auto deposit stability "..tostring(why));return end
       local before=H.readCashNumber();if not before then note("STOP: auto deposit balance unknown");return end
       if before>=depositLimit then
        if not bm(H.atmRemote(),"Deposit",before)then note("STOP: deposit send failed; check bank");return end
        deadline=os.clock()+5;while valid() and (H.readCashNumber() or before)>=before and os.clock()<deadline do task.wait(.1)end
        if (H.readCashNumber() or before)>=before then note("STOP: deposit unconfirmed; no repeat");return end
        note("AUTO DEPOSIT confirmed after harvest: $"..before)
       end
       B.atmTransactionHold=false
       local pg=z:FindFirstChild("PlayerGui");local g=pg and pg:FindFirstChild("MD_ATMGui");local panel=g and g:FindFirstChild("Panel");local close=panel and panel:FindFirstChild("Close");if close and close.Visible then button(close)end
       if not travel(yard,false,nil,true) or not exitTo(yard+Vector3.new(0,2,0)) then return end
      end
      local list=pots();local completed=0
      for pass=1,2 do
       local soilAvailable=count("RegularSoil");local seedAvailable=count("SunflowerSeeds")
       local deferredSoil,deferredSeed=0,0;completed=0
       note("PLANT: pot-by-pot pass "..pass.."; available soil="..soilAvailable.." seeds="..seedAvailable)
       for _,pot in ipairs(list) do
        if not valid() then note("STOP: cancelled");return end
        local p=pot:FindFirstChild("MD_FarmAction",true)
        if not p or not p:IsA("ProximityPrompt") then note("STOP "..pot.Name..": prompt unavailable");return end
        local text=p.ActionText:lower()
        if text:find("water",1,true) or text:find("fertilize",1,true) then
         completed+=1
        elseif text:find("add soil",1,true) or text:find("plant seed",1,true) then
         local needsSoil=text:find("add soil",1,true)~=nil
         if (needsSoil and soilAvailable<1) or seedAvailable<1 then
          if needsSoil then deferredSoil+=1 end;deferredSeed+=1
          note("PLANT: "..pot.Name.." deferred until supplies are available")
         else
          note("PLANT: moving to "..pot.Name)
          if not approach(p) then note("STOP "..pot.Name..": cannot reach pot");return end
          local deadline=os.clock()+3;while valid() and p.Parent and not p.Enabled and os.clock()<deadline do task.wait(.1) end
          if not p.Enabled then note("STOP "..pot.Name..": prompt disabled after approach");return end
          if needsSoil then
           local done,why=action(p,"add soil","RegularSoil");if not done then note("STOP "..pot.Name.." soil: "..tostring(why));return end
           soilAvailable-=1;note(pot.Name..": soil state confirmed")
          end
          local done,why=action(p,"plant seed","SunflowerSeeds");if not done then note("STOP "..pot.Name.." seed: "..tostring(why));return end
          seedAvailable-=1;note(pot.Name..": seed state confirmed");completed+=1
         end
        else note("STOP "..pot.Name..": unrecognized state "..p.ActionText);return end
       end
       if deferredSeed==0 and deferredSoil==0 then break end
       if pass==2 then note("STOP: supplies still missing after shop trip; planted pots retained");return end
       note("PLANT: planted available pots first; need more supplies for "..deferredSeed.." remaining pot(s)")
       if not supplies(deferredSoil,deferredSeed,false) then return end
       if tostring(house:GetAttribute("MD_RentedBy"))~=tostring(z.UserId) then note("STOP: house ownership changed while shopping");return end
       if not travel(yard,false,nil,true) or not exitTo(yard+Vector3.new(0,2,0)) then return end
       list=pots()
      end
      note("RESULT "..completed.."/"..#list.." pots growing; returning to car and starting fishing")
      if B.travelMode~="Teleport" and (not B.car or not dQ("PLANT backyard")) then note("STOP: could not return to or board car after planting");return end
      B.busy=false;B.stop=false;B.done=false;B.farmRequested=true
      k2()
      local start=os.clock();local startup=os.clock()+30
      while not cancel and screen.Parent and not B.busy and not B.autoFish and os.clock()<startup do task.wait(.2) end
      if not B.busy and not B.autoFish then note("STOP: Auto Fish did not start; select fishing level if needed");B.farmRequested=false;return end
      note("Fishing for up to 10 minutes from planting completion")
      local idleSince=nil
      while not cancel and screen.Parent and z.Character and os.clock()-start<600 do
       if not B.userFarmIntent then note("STOP: user stopped Auto Farm");B.farmRequested=false;return end
       if B.busy or B.autoFish or B.recovering then idleSince=nil else idleSince=idleSince or os.clock() end
       if not B.farmRequested or (idleSince and os.clock()-idleSince>20) then note("STOP: fishing paused before harvest timer: "..tostring(B.lastFailure or B.phase));B.farmRequested=false;return end
       task.wait(1)
      end
      B.farmRequested=false;j3();if cancel or not screen.Parent then return end
      B.stop=false;B.done=false;B.busy=false
      autoRetries=0;note("Timer elapsed; resuming owned-house harvest cycle")
      end
     end)
     shopHold=false
     pcall(function()local ch=z.Character;local hum=ch and ch:FindFirstChildOfClass("Humanoid");local root=ch and ch:FindFirstChild("HumanoidRootPart");if hum and root and not hum.SeatPart then hum:Move(Vector3.zero,false);hum:MoveTo(root.Position) end end)
     if not ok then note("ERROR: "..tostring(err)) end
     if cancel and (B.busy or B.autoFish) then B.farmRequested=false;pcall(j3) end
     if not B.farmRequested then B.busy=false;B.stop=true;B.done=true;B.phase="STOPPED" end
     running=false;cancel=false
     if plantUserEnabled and B.userFarmIntent and screen.Parent then
      local reason=string.lower(lastNote.." "..tostring(B.lastFailure or ""))
      local unsafe=reason:find("unconfirmed",1,true) or reason:find("not confirmed",1,true) or reason:find("no repeat",1,true) or reason:find("no retry",1,true) or reason:find("no state confirmation",1,true) or reason:find("unknown bank",1,true) or reason:find("insufficient",1,true) or reason:find("ownership changed",1,true) or reason:find("rent",1,true) and reason:find("sent",1,true)
      if not unsafe and autoRetries<3 then
       autoRetries+=1;B.phase="PLANT RECOVERING: "..autoRetries.."/3";a6("PLANT: retrying safe failed step after 5 seconds; attempt "..autoRetries)
       task.delay(5,function()if screen.Parent and B.userFarmIntent and plantUserEnabled and not running then B.farmRequested=false;B.stop=false;B.done=false;B.busy=false;plantAction(true)end end)
      else B.phase="PLANT PAUSED: check Copy Report";a6("PLANT PAUSED: unsafe or retry limit; inspect Copy Report before restarting") end
     end
    end)
   end
   B.startIntegratedPlant=function()plantUserEnabled=true;autoRetries=0;plantAction(true)end
   B.stopIntegratedPlant=function()plantUserEnabled=false;plantAction(false)end
   B.plantTestRunning=function() return running end
  end
  B.includePlanting=false
  local farmUserEnabled=false
  local statsBox=home:add("RUN TOTAL", "Net wallet + bank change since Auto Farm started",72)
  statsBox.LayoutOrder=0
  local statsLabel=txt(statsBox,"NET --   |   FARM TIME 0:00",12,ink,true);statsLabel.Position=UDim2.new(0,13,0,48);statsLabel.Size=UDim2.new(1,-26,0,18)
  local runStart,runEnd,baseline,finalNet=nil,nil,nil,nil
  local farmSwitch=home:Toggle("AUTO FARM","Start fishing; optionally include planting",false,function(value)
   farmUserEnabled=value;B.userFarmIntent=value
   if value then runStart=os.clock();runEnd=nil;finalNet=nil;local cash=H.readCashNumber();local bank=tonumber(z:GetAttribute("MD_Bank")) or tonumber(B.bank);baseline=cash and bank and cash+bank or nil
   elseif runStart then runEnd=os.clock();local cash=H.readCashNumber();local bank=tonumber(z:GetAttribute("MD_Bank")) or tonumber(B.bank);if baseline and cash and bank then finalNet=cash+bank-baseline end end
   if not value then B.waitingForSpot=false;B.recovering=false;B.stopIntegratedPlant();B.farmRequested=false;j3();return end
   B.activeIncludePlanting=B.includePlanting
   if not B.spotChoice or (B.spotChoice~="auto" and not B.levelFishingSpots[tonumber(B.spotChoice)]) or (B.spotChoice=="auto" and not B.resolveSpotTier()) then B.waitingForSpot=true;B.phase="WAITING: CHOOSE FISHING SPOT";a6("AUTO FARM: choose a fishing level to start");return end
   if B.activeIncludePlanting then if not (B.plantTestRunning and B.plantTestRunning()) then B.startIntegratedPlant()end
   else B.farmRequested=true;if not(B.busy or B.autoFish or B.recovering) then k2()end end
  end)
  home:Toggle("INCLUDE PLANTING","When on: plant, fish 10 minutes, harvest and repeat; applies next start",false,function(value)
   B.includePlanting=value;a6("INCLUDE PLANTING "..(value and "ON" or "OFF").."; applies the next time Auto Farm starts")
  end)
  task.spawn(function()while screen.Parent do
   farmSwitch:Set(farmUserEnabled)
   local cash=H.readCashNumber();local bank=tonumber(z:GetAttribute("MD_Bank")) or tonumber(B.bank)
   if runStart and not baseline and cash and bank then baseline=cash+bank end
   local elapsed=runStart and math.max(0,math.floor((runEnd or os.clock())-runStart)) or 0
   local net=runEnd and finalNet or (not runEnd and baseline and cash and bank and (cash+bank-baseline) or nil)
   statsLabel.Text="NET "..(net and ((net>=0 and "+$" or "-$")..tostring(math.floor(math.abs(net)))) or "--").."   |   FARM TIME "..string.format("%d:%02d",math.floor(elapsed/60),elapsed%60)
   task.wait(.5)
  end end)

  do
   local attempts={};local lastPos=nil;local lastMove=os.clock();local lastDrive=nil;local recoveryBusy=false;local blocked=false;local lastCatch=B.caught;local lastDeposit=B.depositAfterSell
   task.spawn(function()while screen.Parent do
    local now=os.clock()
    if B.farmRequested and ((B.caught or 0)>(lastCatch or 0) or (B.depositAfterSell and not lastDeposit)) then attempts={};a6("RECOVERY: retry budget reset after verified farm progress") end
    lastCatch=B.caught;lastDeposit=B.depositAfterSell
    if not B.farmRequested then attempts={};lastPos=nil;lastDrive=nil;lastMove=now;blocked=false
    elseif not B.waitingForSpot and not B.recovering and not recoveryBusy and not blocked then
     local drive=B.autoDrive;local driving=drive and drive.active and B.car and aL(B.car) and not B.autoFish and not B.castActive
     if not driving or drive~=lastDrive then lastDrive=driving and drive or nil;lastPos=driving and at(B.car) or nil;lastMove=now
     else local pos=at(B.car);if pos and (not lastPos or (pos-lastPos).Magnitude>=5) then lastPos=pos;lastMove=now end end
     local phase=tostring(B.phase or "");local failed=phase=="FAILED" or phase=="OFF ROUTE"
     local stalled=driving and now-lastMove>=(B.underground and 15 or 45)
     if failed or stalled then
      local why=tostring(B.lastFailure or phase):lower()
      local unsafe=why:find("money",1,true) or why:find("fund",1,true) or why:find("afford",1,true) or why:find("sell",1,true) or why:find("sale",1,true) or why:find("repair",1,true) or why:find("no route",1,true) or why:find("unsafe",1,true) or why:find("withdraw",1,true) or why:find("deposit",1,true) or why:find("atm stability",1,true) or why:find("no verified dry floor",1,true) or why:find("non-finite",1,true) or why:find("purchase confirmation",1,true) or why:find("purchase not confirmed",1,true)  or why:find("bait equip not confirmed",1,true) or why:find("fishing level",1,true) or why:find("choose a fishing level",1,true) or why:find("connector blocked",1,true) or why:find("unsafe vehicle",1,true) or why:find("car not safely on ground",1,true)
      local recent={};for _,t0 in ipairs(attempts)do if now-t0<300 then recent[#recent+1]=t0 end end;attempts=recent
      if unsafe then
       blocked=true;B.phase="RECOVERY PAUSED: check unsafe route or transaction";a6(B.phase.."; no automatic replay of unsafe or ambiguous actions")
      else
       local delayTime=#attempts>=3 and 60 or 4
       if delayTime>4 then attempts={};a6("RECOVERY: repeated failures; waiting 60 seconds before another attempt") end
       attempts[#attempts+1]=now;recoveryBusy=true
       a6("RECOVERY: "..(stalled and "travel stalled" or phase).."; restarting Auto Farm in "..delayTime.."s")
       j3();B.phase="RECOVERING: restarting farm";local serial=B.runSerial
       task.delay(delayTime,function()
        if screen.Parent and B.farmRequested and B.runSerial==serial and not B.recovering then
         local ok,err=pcall(k0);if not ok then G("RECOVERY START ERROR: "..tostring(err))end
        end
        lastDrive=nil;lastPos=nil;lastMove=os.clock();recoveryBusy=false
       end)
      end
     end
    end
    task.wait(2)
   end end)
  end
  do
   local box,main,sub=home:add("Bait to buy","Target quantity to carry; buys only missing bait",76)
   main.Size=UDim2.new(1,-185,0,23);sub.Size=UDim2.new(1,-185,0,23)
   local value=math.clamp(tonumber(B.baitQty) or t.BaitQty,1,100)
   local number=txt(box,tostring(value),15,ink,true);number.Position=UDim2.new(1,-173,0,20);number.Size=UDim2.fromOffset(35,32);number.TextXAlignment=Enum.TextXAlignment.Center
   local bar=frame(box,Color3.fromRGB(80,80,80));bar.Position=UDim2.new(1,-130,0,32);bar.Size=UDim2.fromOffset(112,7);round(bar,3)
   local fill=frame(bar,Color3.fromRGB(0,0,0));fill.Size=UDim2.new((value-1)/99,0,1,0);round(fill,3)
   local knob=frame(bar,Color3.fromRGB(0,0,0));knob.AnchorPoint=Vector2.new(.5,.5);knob.Position=UDim2.new((value-1)/99,0,.5,0);knob.Size=UDim2.fromOffset(15,15);round(knob,8)
   local hit=button(bar,"",ink,panel);hit.BackgroundTransparency=1;hit.Position=UDim2.fromOffset(-8,-16);hit.Size=UDim2.new(1,16,0,36)
   local active=nil;local priorScrolling=nil;local dragX=nil;local dragValue=nil
   local function finish()
    if not active then return end;active=nil
    if home.scroll.Parent and priorScrolling~=nil then home.scroll.ScrollingEnabled=priorScrolling end;priorScrolling=nil
   end
   local function update(input)
    if bar.AbsoluteSize.X<=0 then return end
    local dx=input.Position.X-dragX;if math.abs(dx)<3 then return end
    local ratio=math.clamp((dragValue-1)/99+dx/bar.AbsoluteSize.X,0,1)
    local nextValue=math.clamp(1+math.floor(ratio*99+.5),1,100);if nextValue==value then return end;value=nextValue;number.Text=tostring(value)
    fill.Size=UDim2.new((value-1)/99,0,1,0);knob.Position=UDim2.new((value-1)/99,0,.5,0);kA(value)
   end
   hit.InputBegan:Connect(function(input)
    if active or (input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1) then return end
    active=input;dragX=input.Position.X;dragValue=value;priorScrolling=home.scroll.ScrollingEnabled;home.scroll.ScrollingEnabled=false
    input.Changed:Connect(function()if input==active and (input.UserInputState==Enum.UserInputState.End or input.UserInputState==Enum.UserInputState.Cancel) then finish()end end)
   end)
   UIS.InputChanged:Connect(function(input)if screen.Parent and active and ((active.UserInputType==Enum.UserInputType.Touch and input==active) or (active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then update(input)end end)
   UIS.InputEnded:Connect(function(input)if input==active or (active and active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then finish() end end)
   UIS.WindowFocusReleased:Connect(finish)
   home.scroll:GetPropertyChangedSignal("Visible"):Connect(function()if not home.scroll.Visible then finish()end end)
  end
  K.statusP=home:Paragraph("Status","idle");K.msgP=nil
  B.catchHistoryWidget=home:Paragraph("Last catch","No catches this session")
  do
   local recording=false;local samples={};local started=0
   dev:Button("START CAR ENTRY EXPLORE","Records seat and prompt state for 30 seconds; manually get in the car",function()
    if not B.devEnabled then a6("CAR EXPLORE: developer mode required");return end
    if recording then a6("CAR EXPLORE: already recording");return end
    recording=true;samples={"===== PASSIVE CAR ENTRY EXPLORE =====", "No hooks or input blocking. Start on foot, then manually enter the driver's seat."};started=os.clock()
    a6("CAR EXPLORE: recording 30 seconds; manually enter car, then press COPY CAR ENTRY")
    task.spawn(function()
     while recording and screen.Parent and os.clock()-started<30 do
      local ch=z.Character;local hum=ch and ch:FindFirstChildOfClass("Humanoid");local root=ch and ch:FindFirstChild("HumanoidRootPart")
      local car=B.car or B.syncOwnedCar;local nearest,dist=c8();if (not car or not car.Parent) and nearest then car=nearest end
      local seat=hum and hum.SeatPart;local driver=car and cu(car);local door=car and cq(car);local pos=car and at(car);local prompt=door and door.obj;local pp=prompt and co(prompt)
      local body=car and car:FindFirstChild("Chassis",true);local delta=pp and root and (pp-root.Position).Magnitude
      samples[#samples+1]=string.format("t=%.2f char=%s state=%s seat=%s sit=%s car=%s carPos=%s carDist=%s chassisAnchored=%s driver=%s occupant=%s disabled=%s prompt=%s enabled=%s range=%s promptDist=%s hold=%s spawnReadyAt=%s",os.clock()-started,tostring(root and root.Position),tostring(hum and hum:GetState()),seat and seat:GetFullName() or "none",tostring(hum and hum.Sit),car and car:GetFullName() or "none",tostring(pos),tostring(pos and root and (pos-root.Position).Magnitude),tostring(body and body.Anchored),driver and driver:GetFullName() or "none",tostring(driver and driver.Occupant),tostring(driver and driver.Disabled),prompt and prompt:GetFullName() or "none",tostring(prompt and prompt.Enabled),tostring(prompt and prompt.MaxActivationDistance),tostring(delta),tostring(prompt and prompt.HoldDuration),tostring(z:GetAttribute("MD_CarSpawnReadyAt")))
      task.wait(.25)
     end
     recording=false;a6("CAR EXPLORE: recording complete; press COPY CAR ENTRY")
    end)
   end)
   dev:Button("COPY CAR ENTRY","Stop recording and copy the passive car entry report",function()
    recording=false;local f=setclipboard or toclipboard
    if type(f)=="function" then local ok=pcall(f,table.concat(samples,"\n").."\n===== END CAR ENTRY EXPLORE =====");a6("CAR EXPLORE copied="..tostring(ok)) else a6("CAR EXPLORE: clipboard unavailable")end
   end)
  end
  dev:Button("COPY CATCH HISTORY","Up to 100 catches from this session",function() local text=table.concat(B.catchHistory or {},"\n");if text=="" then text="No catches this session" end;local clip=type(setclipboard)=="function" and setclipboard or o(function()return r().setclipboard end);if clip then pcall(clip,text);a6("CATCH HISTORY copied") else a6("CATCH HISTORY: clipboard not available")end end)
  B.instaFish=B.instaFish or {};B.shopCatalog=B.shopCatalog or {rod={FishingRodRegular=100},bait={WormtecRegular=20}}
  do
   local observedRod={FishingRodRegular=100,FishingRodPro=800,FishingRodAdvanced=2300,FishingRodUltimate=5000}
   local observedBait={WormtecRegular=20,WormtecPro=25,WormtecUltimate=30,PrawntecRegular=35,PrawntecPro=40,PrawntecUltimate=45}
   for name,price in pairs(observedRod)do if B.shopCatalog.rod[name]==nil then B.shopCatalog.rod[name]=price end end
   for name,price in pairs(observedBait)do if B.shopCatalog.bait[name]==nil then B.shopCatalog.bait[name]=price end end
   if not B.selectedRod then B.selectedRod={name="FishingRodRegular",price=100};B.cheapestRod=B.selectedRod end
   if not B.selectedBait then B.selectedBait={name="WormtecRegular",price=20};B.cheapestBait=B.selectedBait;B.baitPrice=20 end
  end
  home:Dropdown("INSTA SELL","Choose fish; selected catches trigger Sell All",function()local out={} for _,name in ipairs({"Pufferfish","Tuna","Marlin","Sailfish","Anglerfish","Shark","Coelacanth","Perch","Salmon","Bass","Northern Pike"})do out[#out+1]={label=name,key=name:lower()}end;return out end,function(item)return B.instaFish[item.key]==true end,function(item)B.instaFish[item.key]=not B.instaFish[item.key]end,true)
  for _,kind in ipairs({"rod","bait"}) do
   local category=kind
   home:Dropdown(category=="rod" and "ROD" or "BAIT","Open fishing shop once to load game catalog",function()
    local out={};for name,price in pairs(B.shopCatalog[category] or {})do out[#out+1]={label=name.."  $"..tostring(price),name=name,price=price}end;table.sort(out,function(a,b)return a.price<b.price or a.price==b.price and a.name<b.name end);return out
   end,function(item)local selected;if category=="rod" then selected=B.selectedRod else selected=B.selectedBait end;return selected and selected.name==item.name end,function(item)
    local selected={name=item.name,price=item.price};if category=="rod" then B.selectedRod=selected;B.cheapestRod=selected;B.rodEquipped=false else B.selectedBait=selected;B.cheapestBait=selected;B.baitPrice=item.price;B.baitEquipped=false end
    local wallet=H.readCashNumber();local bank=tonumber(z:GetAttribute("MD_Bank")) or tonumber(B.bank);local cost=H.moneyNeeded();if wallet and bank and wallet+bank<cost then if B.notifyNotEnough then B.notifyNotEnough()end;B.phase="Not enough money!";a6("Not enough money! Need $"..p(cost).."; wallet + bank $"..p(wallet+bank));D(false)end
   end,false)
  end
  -- Drive implementation remains in this file for a future version.
  B.travelMode="Teleport"
  settings:Paragraph("Travel","Character teleport; server correction may pause the cycle")
  B.setCharacterNoclip(true)
  B.arenaSetRouteVisible(false)
  do
   local threshold=math.clamp(math.floor(tonumber(cfg.threshold) or 10),1,100);local crowd=cfg.crowd==true;local shot=cfg.shot==true;local busyHop=false;local lastTrace=0;local healthConn=nil
   local function hop(reason)
    if busyHop then return end;busyHop=true;a6("HOP: looking for low-population public server ("..reason..")")
    task.spawn(function()
     local requestFn=(type(request)=="function" and request) or (type(http_request)=="function" and http_request) or (syn and syn.request)
     local best=nil;local cursor=nil;local ok=true
     for page=1,10 do
      local url="https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Asc&limit=100"..(cursor and "&cursor="..game:GetService("HttpService"):UrlEncode(cursor) or "")
      local success,body=pcall(function()if requestFn then local response=requestFn({Url=url,Method="GET"});return response.Body end;return game:HttpGet(url)end)
      if not success then ok=false;break end;local decodedOk,data=pcall(function()return game:GetService("HttpService"):JSONDecode(body)end);if not decodedOk or type(data)~="table"then ok=false;break end
      for _,server in ipairs(data.data or {})do if server.id~=game.JobId and tonumber(server.playing) and tonumber(server.maxPlayers) and server.playing<server.maxPlayers and (not best or server.playing<best.playing) then best=server end end
      cursor=data.nextPageCursor;if reason=="character health loss" and best then break end;if not cursor or cursor=="" then break end
     end
     if best then a6("HOP: selected discovered server with "..best.playing.." players")
      if B.autoExecuteHop and (reason=="character health loss" or reason=="player threshold") then
       local queue=(type(queue_on_teleport)=="function" and queue_on_teleport) or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
       if not queue or type(readfile)~="function" or type(isfile)~="function" or not isfile("auto_fish_hop_source.lua") or not B.saveUserConfig() then a6("HOP cancelled: auto-execute needs queue_on_teleport and saved source/config");busyHop=false;return end
       local bootstrap=string.format([[repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer; if game.PlaceId~=%d or game.JobId~=%q or os.time()>%d then return end; local env=(type(getgenv)=="function" and getgenv()) or _G; env.ArenaFishHopResume=true; local f=loadstring or load; local ok,err=pcall(function() f(readfile("auto_fish_hop_source.lua"))() end); if not ok then warn("Auto Fish hop reload failed: "..tostring(err)) end]],game.PlaceId,best.id,os.time()+180)
       local queued,why=pcall(queue,bootstrap)
       if not queued then a6("HOP cancelled: could not queue restart "..tostring(why));busyHop=false;return end
      end
      local success,err=pcall(function()game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,best.id,z)end);if not success then a6("HOP failed: "..tostring(err));busyHop=false end
     else a6(ok and "HOP: no available different public server found" or "HOP: public-server list unavailable on this executor");busyHop=false end
     task.delay(15,function()busyHop=false end)
    end)
   end
   do
    local box=protection:add("Player threshold","Hop at or above this player count",64)
    local minus=button(box,"−",cream,ink);minus.Size=UDim2.fromOffset(34,34);minus.Position=UDim2.new(1,-130,0,15);round(minus,4)
    local number=txt(box,tostring(threshold),15,ink,true);number.TextXAlignment=Enum.TextXAlignment.Center;number.Position=UDim2.new(1,-91,0,15);number.Size=UDim2.fromOffset(40,34)
    local plus=button(box,"+",cream,ink);plus.Size=UDim2.fromOffset(34,34);plus.Position=UDim2.new(1,-46,0,15);round(plus,4)
    minus.MouseButton1Click:Connect(function()threshold=math.max(1,threshold-1);cfg.threshold=threshold;number.Text=tostring(threshold)end)
    plus.MouseButton1Click:Connect(function()threshold=math.min(100,threshold+1);cfg.threshold=threshold;number.Text=tostring(threshold)end)
   end
   protection:Toggle("Auto hop by player count","Triggers at or above threshold",crowd,function(value)crowd=value;cfg.crowd=value end)
   protection:Toggle("Hop on damage","Hop on any character health loss, including non-combat damage",shot,function(value)shot=value;cfg.shot=value;a6("DAMAGE HOP "..(value and "enabled" or "disabled"))end)
   protection:Toggle("Auto execute after hop","Reload only after a damage or player-count hop; executor support required",B.autoExecuteHop,function(value)B.autoExecuteHop=value end)
   local stuckHop=cfg.stuckHop==true;local lastProgress=os.clock();local previousPosition=nil;local previousPhase=nil;local previousCaught=nil
   protection:Toggle("Hop if stuck","Hop after 5 minutes idle except while fishing",stuckHop,function(value)stuckHop=value;cfg.stuckHop=value;lastProgress=os.clock();previousPosition=nil end)
   UIS.InputBegan:Connect(function(input,processed)if screen.Parent and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.Keyboard or input.UserInputType==Enum.UserInputType.MouseButton1) then lastProgress=os.clock()end end)
   task.spawn(function()while screen.Parent do
    if stuckHop then
     local position=(B.car and aL(B.car) and at(B.car)) or ar();local phase=tostring(B.phase or "")
     if B.autoFish or B.castActive or B.recovering then lastProgress=os.clock()
     elseif previousPosition and position and (position-previousPosition).Magnitude>=6 then lastProgress=os.clock();previousPosition=position
     elseif not previousPosition and position then previousPosition=position;lastProgress=os.clock()end
     if previousPhase and phase~=previousPhase then lastProgress=os.clock()end;previousPhase=phase
     if previousCaught~=nil and B.caught~=previousCaught then lastProgress=os.clock()end;previousCaught=B.caught
     if os.clock()-lastProgress>=300 then lastProgress=os.clock();a6("STUCK HOP: five minutes without movement or progress, not fishing");hop("five minutes idle")end
    else lastProgress=os.clock();previousPosition=nil;previousPhase=nil end
    task.wait(2)
   end end)
   protection:Button("HOP TO LOWEST SERVER","Lowest available among discovered public servers",function()hop("manual")end)
   task.spawn(function()while screen.Parent do if crowd and #game:GetService("Players"):GetPlayers()>=threshold then hop("player threshold")end;task.wait(3)end end)
   local function attach(character)
    if healthConn then healthConn:Disconnect();healthConn=nil end;local hum=character:WaitForChild("Humanoid",10);if not hum then return end;local previous=hum.Health
    healthConn=hum.HealthChanged:Connect(function(value)
     local before=previous;previous=value
     if screen.Parent and shot and type(value)=="number" and type(before)=="number" and value<before then
      a6("DAMAGE HOP: health "..tostring(before).." -> "..tostring(value));hop("character health loss")
     end
    end)
   end
   if z.Character then task.spawn(attach,z.Character)end;z.CharacterAdded:Connect(attach)
   local remote=game:GetService("ReplicatedStorage"):FindFirstChild("MD_ItemsEvent")
   if remote and remote:IsA("RemoteEvent")then remote.OnClientEvent:Connect(function(action,tool,endpoint,origin)
    if not screen.Parent or not shot or (action~="BulletTrace" and action~="BulletTraceSet")then return end;local root=ao();if not root then return end
    local points=typeof(endpoint)=="Vector3" and {endpoint} or type(endpoint)=="table" and endpoint or {};for _,point in pairs(points)do if typeof(point)=="Vector3" and (point-root.Position).Magnitude<=9 then lastTrace=os.clock();break end end
   end)end
   game:GetService("TeleportService").TeleportInitFailed:Connect(function(player,result,message)if player==z then busyHop=false;a6("HOP failed: "..tostring(result).." "..tostring(message))end end)
  end
  do
   local enabled=cfg.hideName==true;local previous=setmetatable({}, {__mode="k"});local originalHum=setmetatable({}, {__mode="k"});local badge=nil;local badgeHead=nil
   local function cleanup()
    if badge then badge:Destroy();badge=nil;badgeHead=nil end
    for label,text in pairs(previous)do pcall(function()label.Text=text end)end;previous=setmetatable({}, {__mode="k"})
    for hum,mode in pairs(originalHum)do pcall(function()hum.DisplayDistanceType=mode end)end;originalHum=setmetatable({}, {__mode="k"})
   end
   local function setHideName(value)
    enabled=value;cfg.hideName=value;if not value then cleanup();return end
    task.spawn(function()while enabled and screen.Parent do
     pcall(function()
      local character=z.Character;local head=character and character:FindFirstChild("Head");local hum=character and character:FindFirstChildOfClass("Humanoid")
      if hum then if not originalHum[hum] then originalHum[hum]=hum.DisplayDistanceType end;hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None end
      if head and head~=badgeHead then if badge then badge:Destroy()end;badgeHead=head;badge=Instance.new("BillboardGui");badge.Name="LocalHiddenName";badge.Adornee=head;badge.Size=UDim2.fromOffset(160,35);badge.StudsOffset=Vector3.new(0,2.6,0);badge.AlwaysOnTop=true;badge.Parent=head;local label=Instance.new("TextLabel");label.BackgroundTransparency=1;label.Size=UDim2.fromScale(1,1);label.Text="......";label.TextColor3=Color3.new(1,1,1);label.TextStrokeTransparency=0;label.Font=Enum.Font.GothamBold;label.TextSize=18;label.Parent=badge end
      if character then for _,obj in ipairs(character:GetDescendants())do if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and (not badge or not obj:IsDescendantOf(badge)) and (obj.Text==z.Name or obj.Text==z.DisplayName) then if not previous[obj] then previous[obj]=obj.Text end;obj.Text="......" end end end
     end);task.wait(.5)
    end;cleanup()end)
   end
   tools:Toggle("Hide username","Local visual only; other players may still see it",enabled,setHideName);if enabled then setHideName(true)end
  end
  tools:Button("SAVE CONFIG","Save settings to executor workspace",function() B.saveUserConfig() end)
  do
   B.recordedFishCameras=B.recordedFishCameras or {}
   local function captureCamera()
    local root=ao();local camera=workspace.CurrentCamera
    if not root or not camera then a6("CAMERA SAVE: character or camera unavailable");return end
    local level=B.resolveSpotTier and B.resolveSpotTier() or tonumber(B.spotChoice)
    local spot=level and B.levelFishingSpots and B.levelFishingSpots[level]
    local close=spot and (root.Position-spot).Magnitude<=25
    if close then B.recordedFishCameras[level]={origin=root.Position,offset=camera.CFrame.Position-root.Position,rotation=camera.CFrame.Rotation} end
    local components={camera.CFrame:GetComponents()};local values={};for _,v in ipairs(components)do values[#values+1]=string.format("%.6f",v)end
    local text=table.concat({"===== CAMERA ANGLE =====","PlaceId: "..tostring(game.PlaceId),"Selection: "..tostring(B.spotChoice).." | resolved level: "..tostring(level or "unknown"),"Character position: "..tostring(root.Position),"Camera position: "..tostring(camera.CFrame.Position),"Camera look vector: "..tostring(camera.CFrame.LookVector),"Camera up vector: "..tostring(camera.CFrame.UpVector),"Camera CFrame components: "..table.concat(values,", "),"Camera offset from character: "..tostring(camera.CFrame.Position-root.Position),"Camera type: "..tostring(camera.CameraType).." | FOV: "..tostring(camera.FieldOfView),"Session angle saved: "..tostring(close and true or false),"===== END CAMERA ANGLE ====="},"\n")
    local copied=iV(text);local saved=br("auto_fish_camera_angle.txt",text)
    a6("CAMERA SAVE: clipboard="..tostring(copied).." file="..tostring(saved).." level="..tostring(level).." session="..tostring(close and true or false))
    if not copied then iW(text)end
    pcall(function()P(copied and "Camera angle copied" or "Clipboard unavailable",close and "Angle also saved for this level for this session." or "Copied view; session lock not saved because you are not near the selected spot.")end)
   end
   dev:Button("SAVE CAMERA ANGLE","Copy current view for any selected fishing spot",captureCamera)
   dev:Button("CLEAR SAVED CAMERAS","Return to automatic water aim",function()B.recordedFishCameras={};a6("CAMERA SAVE: cleared")end)
   local show=false;local adornments={}
   local function clearBarriers() for _,box in pairs(adornments) do pcall(function()box:Destroy()end)end;adornments={} end
   local function hiddenBarrier(part)
    -- Never include camera-faded visible parts. Exclude colliders occupying
    -- the same volume as visible building geometry; they are not standalone
    -- invisible barriers. A visual overlap is a conservative heuristic.
    if not part.CanCollide or part.Transparency<.98 then return false end
    local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={part,z.Character};params.MaxParts=120
    local size=Vector3.new(math.max(.1,part.Size.X-.1),math.max(.1,part.Size.Y-.1),math.max(.1,part.Size.Z-.1))
    local ok,hits=pcall(function()return workspace:GetPartBoundsInBox(part.CFrame,size,params)end)
    if not ok then return false end
    for _,other in ipairs(hits) do
     if other:IsA("BasePart") and other.Transparency<.95 and not (z.Character and other:IsDescendantOf(z.Character)) then return false end
    end
    return true
   end
   dev:Toggle("Invisible collision ESP","Local boxes for invisible collidable parts within 150 studs",false,function(value)
    show=value;clearBarriers();if not value then return end
    task.spawn(function()
     while show and B.devEnabled and screen.Parent do
      local root=ao();local wanted={}
      if root then
       local ok,parts=pcall(function()return workspace:GetPartBoundsInRadius(root.Position,150)end)
       if ok then local count=0;for _,part in ipairs(parts)do
        if part:IsA("BasePart") and not (z.Character and part:IsDescendantOf(z.Character)) and count<500 and hiddenBarrier(part) then
         count+=1;wanted[part]=true
         if not adornments[part] then local box=Instance.new("BoxHandleAdornment");box.Name="DrixInvisibleCollisionESP";box.Adornee=part;box.Size=part.Size;box.Color3=Color3.fromRGB(255,75,75);box.Transparency=.65;box.AlwaysOnTop=true;box.ZIndex=5;box.Parent=screen;adornments[part]=box end
         adornments[part].Size=part.Size
        end
       end end
      end
      for part,box in pairs(adornments)do if not wanted[part] or not part.Parent then box:Destroy();adornments[part]=nil end end
      task.wait(2)
     end
     show=false;clearBarriers()
    end)
   end)
  end
  dev:Button("COPY REPORT","Full retained session + state history",function() j0() end)
  tools:Button("STOP EVERYTHING","Stop the active run",function() j3() end)
  -- Fail closed if a character falls far below the map, including during car
  -- spawn/cooldown waits. Do not reset the character or replay a transaction.
  task.spawn(function()
   local warned=false
   while screen.Parent do
    local root=ao();local hum=aq()
    if (B.busy or B.autoFish) and root and hum and hum.Health>0 and root.Position.Y < -500 then
     if not warned then
      warned=true
      local pos=root.Position;local velocity=root.AssemblyLinearVelocity
      B.farmRequested=false
      a6("VOID SAFETY: character below map y="..p(pos.Y).." velocityY="..p(velocity.Y).."; stopping farm, no automatic transaction retry. Reset character before restarting.")
      j3();B.lastFailure="character below map; reset character before restarting";B.phase="PAUSED: RESET CHARACTER"
     end
    elseif root and root.Position.Y > -100 then warned=false end
    task.wait(.25)
   end
  end)
  task.spawn(function()local lastCar=nil;local lastAttempt=0;while screen.Parent do
   local car=B.car;if car and aL(car) then
    local known=nil;for _,key in ipairs({"MD_Locked","Locked","CarLocked","IsLocked"})do local value=car:GetAttribute(key);if type(value)=="boolean" then known=value;break end end
    if car~=lastCar then lastCar=car;if known==nil then a6("AUTO LOCK: lock state not exposed; cannot safely toggle lock button")end end
    if known==false and os.clock()-lastAttempt>5 then lastAttempt=os.clock();local pg=z:FindFirstChildOfClass("PlayerGui");local gui=pg and pg:FindFirstChild("MD_CarLockControls");local btn=gui and gui:FindFirstChild("LockCar",true);local ok,why=B.pressGameButton(btn);a6("AUTO LOCK requested="..tostring(ok).." "..tostring(why).."; awaiting replicated state")end
   end;task.wait(1)
  end end)
  do
   local recovering=false;local recoverySerial=0;local lastActive=0
   task.spawn(function()while screen.Parent do
    if B.busy or B.autoFish then lastActive=os.clock()end
    local death=playerGui:FindFirstChild("MD_DownedDeathScreen");local button=death and death:FindFirstChild("Respawn",true)
    local visible=button and button:IsA("GuiButton") and button.Visible
    if visible then local parent=button.Parent;while parent and parent~=playerGui do if parent:IsA("GuiObject") and not parent.Visible or parent:IsA("ScreenGui") and not parent.Enabled then visible=false;break end;parent=parent.Parent end end
    if visible and not recovering and (B.busy or B.autoFish or (lastActive>0 and os.clock()-lastActive<30 and B.phase~="STOPPED")) then
     recovering=true;recoverySerial=recoverySerial+1;local serial=recoverySerial;local oldCharacter=z.Character
     B.unsold=0;B.unsoldCharacter=nil;a6("DEATH: cleared prior-life fish count; stopping old run and attempting observed Respawn button");j3();B.recovering=true
     task.spawn(function()
      local started=os.clock();local lastPress=0
      while screen.Parent and B.recovering and recoverySerial==serial and os.clock()-started<45 do
       if z.Character and z.Character~=oldCharacter then local hum=z.Character:FindFirstChildOfClass("Humanoid");local root=z.Character:FindFirstChild("HumanoidRootPart");if hum and root and hum.Health>0 then break end end
       local gui=playerGui:FindFirstChild("MD_DownedDeathScreen");local btn=gui and gui:FindFirstChild("Respawn",true)
       if btn and btn.Visible and os.clock()-lastPress>3 then lastPress=os.clock();local ok,why=B.pressGameButton(btn);a6("RESPAWN button="..tostring(ok).." "..tostring(why))end
       task.wait(.25)
      end
      local character=z.Character;local hum=character and character:FindFirstChildOfClass("Humanoid");local ready=character and character~=oldCharacter and hum and hum.Health>0 and character:FindFirstChild("HumanoidRootPart")
      if screen.Parent and B.recovering and recoverySerial==serial and ready then
       task.wait(3);if B.recovering and screen.Parent then B.recovering=false;B.car=nil;B.stop=false;B.done=false;a6("RESPAWN: character ready; restarting owned-car and farm checks");task.spawn(k0)end
      else B.recovering=false;a6("RESPAWN: new living character not verified; farm remains stopped")end;recovering=false
     end)
    end
    task.wait(.4)
   end end)
  end
  pcall(gb)
  switch("Auto Fish");nav.Visible=false;content.Visible=false;divider.Visible=false
  local collapsed=true
  menu.MouseButton1Click:Connect(function()
   collapsed=not collapsed;nav.Visible=not collapsed;content.Visible=not collapsed;divider.Visible=not collapsed
   local headHeight=collapsed and 46 or 60
   header.Size=UDim2.new(1,0,0,headHeight);area.Position=UDim2.fromOffset(0,headHeight);area.Size=UDim2.new(1,0,1,-headHeight)
   title.Position=UDim2.fromOffset(72,collapsed and 3 or 10)
   anim(window,{Size=UDim2.fromOffset(collapsed and 350 or 760,collapsed and 78 or 460),Position=UDim2.new(.5,0,0,collapsed and 8 or 75)})
  end)
  local function money(value) if tonumber(value)==nil then return "--" end;local n=math.floor(math.abs(tonumber(value)));local result=tostring(n):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","");return (tonumber(value)<0 and "-$" or "$")..result end
  task.spawn(function() while screen.Parent do local cash=nil;pcall(function() cash=H.readCash() end);local bank=nil;pcall(function() bank=z:GetAttribute("MD_Bank") end);bank=bank or B.bank;statusLine.Text=(not farmUserEnabled and "■  WITH LOVE - DRIXNVSP  |  "..money(bank) or "■  "..tostring(B.phase or "FARMING").."  |  "..money(bank));task.wait(1) end end)
  K.ready=true;K.tab=home;K.testTab=settings;K.tools=tools
  local env=r();if type(env)=="table" and env.ArenaFishHopResume then env.ArenaFishHopResume=nil;task.delay(3,function()if screen.Parent and not B.busy then a6("HOP: starting Auto Farm in new server");B.farmRequested=true;k0()end end)end
 end)
 if not ok then warn("[AUTO FISH] Editorial UI failed: "..tostring(err));return false end
 a6("Editorial Auto Fish UI ready")
 return true
end;
local function lx()local gj={}for aa,kq in ipairs({function()return type(gethui)=="function"and gethui()end,function()return V(z,"PlayerGui")end,function()return game:GetService("CoreGui")end})do local q,az=pcall(kq)if q and az then gj[#gj+1]=az end end;for aa,az in ipairs(gj)do for aa,b6 in ipairs({"AutoFishUI","AutoFishEmergencyUI","drixAutoFishOpenUI"})do local cS=o(function()return az:FindFirstChild(b6)end)if cS then pcall(function()cS:Destroy()end)end end end;if lm(false)then return true end;if lm(true)then return true end;a6("OFFICIAL WINDUI...")pcall(function()if type(writefile)=="function"then writefile("auto_fish_windui_status.txt",tostring(B.windProblem or"WindUI failed (unknown..."))end end)local k_=o(function()if type(gethui)=="function"then return gethui()end end)if not k_ then k_=o(function()return z:FindFirstChild("PlayerGui")end)end;if not k_ then a6("GUI skipped - keys still...")return false end;local kV=Instance.new("ScreenGui")kV.Name="AutoFishEmergencyUI"kV.ResetOnSpawn=false;pcall(function()kV.DisplayOrder=99999 end)if not pcall(function()kV.Parent=k_ end)then return false end;local ly=Instance.new("Frame",kV)ly.Size=UDim2.new(0,250,0,300)ly.AnchorPoint=Vector2.new(0.5,0)ly.Position=UDim2.new(0.5,0,0,55)ly.BackgroundColor3=Color3.fromRGB(16,16,18)ly.BorderSizePixel=0;ly.Active=true;ly.Draggable=true;local h=Instance.new("TextButton",ly)h.Size=UDim2.new(1,-16,0,54)h.Position=UDim2.new(0,8,0,8)h.BackgroundColor3=Color3.fromRGB(125,22,24)h.TextColor3=Color3.new(1,1,1)h.Font=Enum.Font.GothamBold;h.TextSize=18;h.Text="START / STOP (BACKUP)"h.MouseButton1Click:Connect(function()o(k2)h.Text=(B.busy or B.autoFish)and"STOP"or"START / STOP (BACKUP)"E()end)N=h;local lz=Instance.new("TextLabel",ly)lz.Size=UDim2.new(1,-16,0,20)O=lz;lz.Position=UDim2.new(0,8,0,68)lz.BackgroundTransparency=1;lz.Text="BAIT TO BUY: "..tostring(B.baitQty or t.BaitQty)lz.TextColor3=Color3.fromRGB(235,235,245)lz.TextXAlignment=Enum.TextXAlignment.Left;lz.Font=Enum.Font.GothamBold;lz.TextSize=13;local function lA(ab)kA(ab)lz.Text="BAIT TO BUY: "..tostring(B.baitQty)end;local lB=Instance.new("TextButton",ly)lB.Size=UDim2.new(0,60,0,34)lB.Position=UDim2.new(0,8,0,92)lB.BackgroundColor3=Color3.fromRGB(52,52,64)lB.Text="-10"lB.TextColor3=Color3.new(1,1,1)lB.Font=Enum.Font.GothamBold;lB.TextSize=15;lB.MouseButton1Click:Connect(function()lA((B.baitQty or 1)-10)end)local lC=Instance.new("TextButton",ly)lC.Size=UDim2.new(0,60,0,34)lC.Position=UDim2.new(0,122,0,92)lC.BackgroundColor3=Color3.fromRGB(52,52,64)lC.Text="+10"lC.TextColor3=Color3.new(1,1,1)lC.Font=Enum.Font.GothamBold;lC.TextSize=15;lC.MouseButton1Click:Connect(function()lA((B.baitQty or 1)+10)end)local lD=Instance.new("Frame",ly)lD.Size=UDim2.new(1,-16,0,10)lD.Position=UDim2.new(0,8,0,140)lD.BackgroundColor3=Color3.fromRGB(44,44,56)lD.BorderSizePixel=0;local lE=Instance.new("Frame",lD)lE.Size=UDim2.new(math.min(B.baitQty or 1,99)/99,0,1,0)lE.BackgroundColor3=Color3.fromRGB(0.2,0.6,0.9)lE.BorderSizePixel=0;local lF=Instance.new("TextButton",lD)lF.Size=UDim2.new(0,24,0,24)lF.Position=UDim2.new(lE.Size.X.Scale,-12,0.5,-12)lF.BackgroundColor3=Color3.fromRGB(240,240,250)lF.Text=""lF.AutoButtonColor=false;local lf=false;local function lG(ii)local lH=lD.AbsoluteSize.X;if not lH or lH<=0 then return end;local T=math.clamp((ii-lD.AbsolutePosition.X)/lH,0,1)lE.Size=UDim2.new(T,0,1,0)lF.Position=UDim2.new(T,-12,0.5,-12)lA(math.floor(T*98)+1)end;lF.MouseButton1Down:Connect(function()lf=true end)lF.MouseButton1Up:Connect(function()lf=false end)lD.InputBegan:Connect(function(a7)if a7.UserInputType==Enum.UserInputType.MouseButton1 or a7.UserInputType==Enum.UserInputType.Touch then lf=true;lG(a7.Position.X)end end)w.InputChanged:Connect(function(a7)if lf and(a7.UserInputType==Enum.UserInputType.MouseMovement or a7.UserInputType==Enum.UserInputType.Touch)then lG(a7.Position.X)end end)w.InputEnded:Connect(function(a7)if a7.UserInputType==Enum.UserInputType.MouseButton1 or a7.UserInputType==Enum.UserInputType.Touch then lf=false end end)M=Instance.new("TextLabel",ly)M.Size=UDim2.new(1,-16,0,52)M.Position=UDim2.new(0,8,0,156)M.BackgroundTransparency=1;M.TextXAlignment=Enum.TextXAlignment.Left;M.TextWrapped=true;M.TextSize=11;M.TextColor3=Color3.new(1,0.88,0.5)M.Text=B.lastMsg;local lI=Instance.new("TextButton",ly)lI.Size=UDim2.new(1,-16,0,37)lI.Position=UDim2.new(0,8,0,211)lI.BackgroundColor3=Color3.fromRGB(54,68,103)lI.TextColor3=Color3.new(1,1,1)lI.Font=Enum.Font.GothamBold;lI.TextSize=14;lI.Text="COPY CAR + INVENTORY SCAN"lI.MouseButton1Click:Connect(function()pcall(kC,"mobile copy",true)end)local lJ=Instance.new("TextButton",ly)lJ.Size=UDim2.new(1,-16,0,36)lJ.Position=UDim2.new(0,8,0,254)lJ.BackgroundColor3=Color3.fromRGB(55,82,125)lJ.TextColor3=Color3.new(1,1,1)lJ.Font=Enum.Font.GothamBold;lJ.TextSize=14;lJ.Text="RETRY OFFICIAL WINDUI"lJ.MouseButton1Click:Connect(function()if lm(true)then pcall(function()kV:Destroy()end)M,N,O=nil,nil,nil;E()else lJ.Text="WINDUI FAILED - SEE..."end end)E()a6("GUI ready - ONE button")return true end;local function lK(lL)local dr=V(lL,"KeyCode")local aX=dr and V(dr,"Name")return aX and tostring(aX)or""end;w.InputBegan:Connect(function(lL,lM)if lM then return end;local X=lK(lL)if X=="R"then k2()elseif X=="X"then j3()elseif B.devEnabled then if X=="S"then bM()elseif X=="One"or X=="1"then bO()elseif X=="Two"or X=="2"then bR()elseif X=="B"then kb()elseif X=="C"then j0()elseif X=="V"then kC("manual key",true)elseif X=="D"then j2()end end;E()end)do
 local lastCheck=0;local unsupportedAt=nil
 v.Heartbeat:Connect(function()
  local now=d();if now-lastCheck<.15 then return end;lastCheck=now
  if B.farmRequested and B.car and B.autoDrive and B.autoDrive.active and aL(B.car) and not B.skyState then pcall(arenaSurfaceNoclip)end
 if B.stop or B.done or not(B.busy or B.autoFish or (B.autoDrive and B.autoDrive.active)) or B.skyState or B.fishingGlide or B.freecamActive then unsupportedAt=nil;return end
  local car=B.car;local hum=aq();local root=ao()
  if car and aL(car) and B.autoDrive and B.autoDrive.active then
   local pos=at(car);local axis=aI(car);local ground=pos and eV(pos.X,pos.Z,pos.Y+7)
   local gap=pos and ground and pos.Y-ground-(B.surfaceRideHeight or 2.5)
   if not ground then
    unsupportedAt=unsupportedAt or now
    if now-unsupportedAt>.8 then
     B.autoDrive.active=false;B.unsafeVehicleLatch=true;B.speed=0
     if axis then local vv=axis.AssemblyLinearVelocity;axis.AssemblyLinearVelocity=Vector3.new(0,math.min(0,vv.Y),0);axis.AssemblyAngularVelocity=Vector3.zero end
     G("unsafe vehicle: no verified surface under car; stopped without guessing a landing");unsupportedAt=nil
    end
   elseif gap and gap>5 then
    unsupportedAt=unsupportedAt or now
    if axis and axis.AssemblyLinearVelocity.Y>0 then local vv=axis.AssemblyLinearVelocity;axis.AssemblyLinearVelocity=Vector3.new(vv.X,0,vv.Z)end
    if now-unsupportedAt>.65 then
     B.autoDrive.active=false;B.unsafeVehicleLatch=true;B.speed=0
     if axis then local vv=axis.AssemblyLinearVelocity;axis.AssemblyLinearVelocity=Vector3.new(0,math.min(0,vv.Y),0);axis.AssemblyAngularVelocity=Vector3.zero end
     G("unsafe vehicle airborne: stopped to let it land; restart after it settles");unsupportedAt=nil
    end
   else unsupportedAt=nil end
  elseif hum and root and not hum.SeatPart and not B.inUnderFish and hum:GetState()~=Enum.HumanoidStateType.Swimming then
   local ground=B.surfaceGroundAt and B.surfaceGroundAt(root.Position.X,root.Position.Z,root.Position.Y+2)
   local desired=ground and ground+hum.HipHeight+root.Size.Y/2
   if desired and root.Position.Y-desired>7 then
    unsupportedAt=unsupportedAt or now
    if now-unsupportedAt>.65 then local vv=root.AssemblyLinearVelocity;root.AssemblyLinearVelocity=Vector3.new(vv.X,math.min(vv.Y,-8),vv.Z)end
    if now-unsupportedAt>3 then G("unexpected airborne character: stopped; wait for a safe landing");unsupportedAt=nil end
   else unsupportedAt=nil end
  else unsupportedAt=nil end
 end)
end
v.Heartbeat:Connect(function(jw)local q,ci=pcall(jv,jw)if q then B.physicsErrors=0;return end;B.physicsErrors=(B.physicsErrors or 0)+1;if B.physicsErrors<=2 then a6("DRIVE TICK ERROR: "..tostring(ci))end;if B.physicsErrors>=3 and B.autoDrive and B.autoDrive.active then B.autoDrive.active=false;G("drive tick crashed: "..tostring(ci))end end)do end;a6("PREFLIGHT:..."..tostring(type(fireproximityprompt)=="function").." writefile="..tostring(type(writefile)=="function").." readfile="..tostring(type(readfile)=="function").." gethui="..tostring(type(gethui)=="function"))pcall(H.watchMoney)local lN,lO=pcall(lx)if not lN then a6("GUI failed (keys still..."..tostring(lO))end;pcall(by)D(false)i(function()local q,a8=pcall(function()if not B.shopTarget then a6("SHOP CHECK: no shop...")return end;local aK=_(B.shopTarget.x,B.shopTarget.y,B.shopTarget.z)local ai,a4=gc(aK)local lP=-1;if B.fishTarget then lP=math.sqrt((B.shopTarget.x-B.fishTarget.x)^2+(B.shopTarget.z-B.fishTarget.z)^2)end;if ai then a6("SHOP CHECK: prompt found ["..Y(ai).."] "..p(a4 or 0).." studs from shop target..."..p(lP).." studs")else a6("SHOP CHECK: NO shop..."..p(B.shopTarget.x)..", "..p(B.shopTarget.z).." | MARK 1 -> SHOP = "..p(lP).." studs - stand at the...")end end)if not q then a6("SHOP CHECK error: "..tostring(a8))end end)a6(">>> BOOT OK <<<")a6("START: use owned car or...")a6("Car: underground at bike...")a6("Speed comes from the...")a9("Server validates money,...")a9("Physics + remote replay...")end)if not b then local a8="AUTO FISH "..a.." FATAL: "..tostring(c)print("[AUTOFISH] !!! FATAL..."..tostring(c))pcall(function()if type(writefile)=="function"then writefile("auto_fish_crash.txt",a8)end end)print("[AUTOFISH] That error...")end
]====]
local loader=loadstring or load
if type(loader)~="function" then say("Executor has no loadstring; cannot compile Auto Fish.");return end
local ok,chunk,compileError=pcall(loader,source)
if type(writefile)=="function" then pcall(writefile,"auto_fish_hop_source.lua",source) end
source=nil
if not ok or type(chunk)~="function" then say("Compilation failed: "..tostring(ok and compileError or chunk));return end
say("Compiled. Starting Auto Fish...")
local runOK,runError=pcall(chunk)
if not runOK then say("Startup failed: "..tostring(runError));return end
task.wait(2)
local found=pg:FindFirstChild("EditorialAutoFish")
if not found then pcall(function() local h=type(gethui)=="function" and gethui();if h then found=h:FindFirstChild("EditorialAutoFish") end end) end
if found then gui:Destroy();return end
local errorText=""
if type(readfile)=="function" then pcall(function() errorText=readfile("auto_fish_crash.txt") end) end
say(errorText~="" and ("Auto Fish failed: "..errorText) or "Auto Fish returned without showing the UI. Please copy this status and send it.")
