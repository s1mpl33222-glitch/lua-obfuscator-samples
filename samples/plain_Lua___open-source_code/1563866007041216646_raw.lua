--[[
    OpiumWare Hub  -  Murder Mystery 2  (Fluent-Modded)
    Halloween 2026 edition.  F6 toggles the window.

    Injected defaults (all auto-on at load):
      * Theme: Amethyst
      * Backdrop design: ON at 50% visibility
      * Backdrop over glass: ON
      * Particles, glow, slide-in animation, floating orb, top bar: ON
]]
local env = (getgenv and getgenv()) or _G
if type(env.MM2CandyFarm)=="table" and type(env.MM2CandyFarm.Cleanup)=="function" then
    pcall(env.MM2CandyFarm.Cleanup); env.MM2CandyFarm=nil
end
local TAG="[OpiumWare Hub]"
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local CoreGui=game:GetService("CoreGui")
local VirtualUser=game:GetService("VirtualUser")
local VirtualInputManager=game:GetService("VirtualInputManager")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local MarketplaceService=game:GetService("MarketplaceService")
local ContentProvider=game:GetService("ContentProvider")
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local ZERO=Vector3.new(0,0,0)
local Cleaning=false
local Fluent=nil
local Window=nil

--========== RoleESP ==========--
local RoleESP={enabled={Murderer=false,Sheriff=false,Innocent=false},tagCache={}}
local ROLE_COLORS={Murderer=Color3.fromRGB(255,0,0),Sheriff=Color3.fromRGB(0,150,255),Innocent=Color3.fromRGB(0,255,0)}

function RoleESP.resolveRole(player)
    local char=player.Character
    if not char then return "Innocent" end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health<=0 then return "Dead" end
    local hasKnife,hasGun=false,false
    for _,tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n=string.lower(tool.Name)
            if n:find("knife",1,true) then hasKnife=true end
            if n:find("gun",1,true) or n:find("revolver",1,true) then hasGun=true end
        end
    end
    if hasGun then return "Sheriff" end
    if hasKnife then return "Murderer" end
    return "Innocent"
end

local function clearRolePlayer(p)
    local e=RoleESP.tagCache[p]; if not e then return end
    if e.Tag and e.Tag.Parent then e.Tag:Destroy() end
    if e.Highlight and e.Highlight.Parent then e.Highlight:Destroy() end
    RoleESP.tagCache[p]=nil
end

local function applyRolePlayer(p)
    if p==LocalPlayer then return end
    local role=RoleESP.resolveRole(p)
    if role=="Dead" or not RoleESP.enabled[role] then clearRolePlayer(p); return end
    local char=p.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not (char and hrp) then clearRolePlayer(p); return end
    local color=ROLE_COLORS[role]
    local e=RoleESP.tagCache[p]
    if e and e.Tag and e.Tag.Parent and e.Highlight and e.Highlight.Parent then
        e.Highlight.FillColor=color
        e.Tag.Main.Text=p.Name.." | "..role
        return
    end
    clearRolePlayer(p)
    local bb=Instance.new("BillboardGui")
    bb.AlwaysOnTop=true; bb.StudsOffset=Vector3.new(0,2.5,0)
    bb.Size=UDim2.new(0,200,0,50); bb.MaxDistance=250; bb.LightInfluence=0; bb.Parent=hrp
    local main=Instance.new("TextLabel")
    main.Name="Main"; main.Size=UDim2.new(1,0,1,0); main.BackgroundTransparency=1
    main.Font=Enum.Font.GothamBold; main.TextSize=14; main.TextStrokeTransparency=0
    main.TextColor3=color; main.Text=p.Name.." | "..role; main.Parent=bb
    local hl=Instance.new("Highlight")
    hl.Adornee=char; hl.FillColor=color; hl.OutlineColor=Color3.new(1,1,1)
    hl.FillTransparency=0.5; hl.OutlineTransparency=0
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=hrp
    RoleESP.tagCache[p]={Tag=bb,Highlight=hl}
end

function RoleESP.refreshAll() for _,p in ipairs(Players:GetPlayers()) do pcall(applyRolePlayer,p) end end
function RoleESP.setRole(role,on) RoleESP.enabled[role]=on and true or false; RoleESP.refreshAll() end
function RoleESP.stopAll() for p in pairs(RoleESP.tagCache) do clearRolePlayer(p) end; RoleESP.tagCache={} end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.8); pcall(applyRolePlayer,p) end)
end)
Players.PlayerRemoving:Connect(clearRolePlayer)
task.spawn(function() while not Cleaning do task.wait(2); pcall(RoleESP.refreshAll) end end)

--========== Utilities ==========--
local function trim(s) return (string.gsub(s,"^%s*(.-)%s*$","%1")) end
local function parseKeywords(text)
    local out={} for piece in string.gmatch(tostring(text or ""),"[^,]+") do
        local kw=string.lower(trim(piece)); if kw~="" then out[#out+1]=kw end
    end return out
end
local function keywordsToString(l) return table.concat(l,", ") end

local Maid={} Maid.__index=Maid
function Maid.new() return setmetatable({_tasks={}},Maid) end
function Maid:Give(i) self._tasks[#self._tasks+1]=i; return i end
function Maid:Clean()
    local t=self._tasks; self._tasks={}
    for _,i in ipairs(t) do local k=typeof(i); pcall(function()
        if k=="RBXScriptConnection" then i:Disconnect()
        elseif k=="function" then i()
        elseif k=="Instance" then i:Destroy()
        elseif k=="table" and type(i.Destroy)=="function" then i:Destroy() end
    end) end
end

local Signal={} Signal.__index=Signal
function Signal.new() return setmetatable({_handlers={}},Signal) end
function Signal:Connect(fn)
    local h={fn=fn}; self._handlers[#self._handlers+1]=h
    return function() for i,x in ipairs(self._handlers) do if x==h then table.remove(self._handlers,i); break end end end
end
function Signal:Fire(...)
    local s={} for i,h in ipairs(self._handlers) do s[i]=h end
    for _,h in ipairs(s) do local ok,e=pcall(h.fn,...); if not ok then warn(TAG.." signal error: "..tostring(e)) end end
end

local function create(c,p) local i=Instance.new(c); local par
    for k,v in pairs(p or {}) do if k=="Parent" then par=v else i[k]=v end end
    i.Parent=par; return i end
local function round(i,r) return create("UICorner",{CornerRadius=r or UDim.new(0,8),Parent=i}) end
local function mountGui(g)
    local targets={}
    local okHui,hui=pcall(function() return gethui and gethui() or nil end)
    if okHui and hui then targets[#targets+1]=hui end
    targets[#targets+1]=CoreGui
    local pg=LocalPlayer:FindFirstChildOfClass("PlayerGui"); if pg then targets[#targets+1]=pg end
    for _,t in ipairs(targets) do local ok=pcall(function() g.Parent=t end); if ok and g.Parent then return true end end
    return false
end

local RootMaid=Maid.new(); local BootMaid=Maid.new()

--========== Config ==========--
-- DefaultTheme = "Amethyst": color theme auto-on at inject.
-- BackgroundVisibility = 0.5: design visibility 50% at inject.
local Config={
    Keywords={"candy","coin"},MaxPickupSize=6,RequireTouchInterest=false,
    Farm={
        ArriveRadius=8,TargetTimeout=15,SkipSeconds=5,MinVisibleTransparency=0.05,AutoMoveSpeed=100,
        OnlyInRound=true,ResetWhenFull=true,ResetAfter=0,LieDown=true,FarmSpeed=100,GroundOffset=1.5,
        AvoidMurderer=true,AvoidRadius=25,
        CoinDelay=0.35,CoinDelayJitter=0.25,
    },
    ESP={Color=Color3.fromRGB(170,90,255),Transparency=0.35,MaxDistance=400,MaxMarkers=200,UpdateInterval=0.25},
    Aim={SheriffLock=true,AutoShoot=false,MurdererLock=true,AutoThrow=false,Smooth=0.35,MaxDistance=200,
        Prediction=true,RequireLOS=true,Cooldown=1.5,ShowButton=true,KnifeSpeed=90},
    Flight={MinSpeed=10,MaxSpeed=150,DefaultSpeed=50,Smoothing=9,ApproachGain=3,MinApproachSpeed=6},
    WalkSpeed={Min=0,Max=100,Default=16},
    Brand={
        Name="🎃 Opiumware Premium Halloween AutoFarm",SubTitle="MM2 🦇",
        BackgroundVisibility=0.5,
        DefaultTheme="Amethyst",
        DefaultBackdropOverGlass=true,
        ToggleKey=Enum.KeyCode.F6,
        SlideDirection="Left",
    },
}

--========== Registry ==========--
local Registry={items={},conns={},count=0,liveCount=0,Added=Signal.new(),Removed=Signal.new()}
local function nameMatches(n) n=string.lower(n); for _,kw in ipairs(Config.Keywords) do if string.find(n,kw,1,true) then return true end end return false end
local function belongsToCharacter(i)
    local a=i.Parent
    while a and a~=Workspace do if a:IsA("Model") and Players:GetPlayerFromCharacter(a) then return true end; a=a.Parent end
    return false
end
local function isCandidate(i)
    if not i:IsA("BasePart") then return false end
    local s=i.Size; if math.max(s.X,s.Y,s.Z)>Config.MaxPickupSize then return false end
    if not (nameMatches(i.Name) or (i.Parent and nameMatches(i.Parent.Name))) then return false end
    if Config.RequireTouchInterest and not i:FindFirstChild("TouchInterest") then return false end
    if belongsToCharacter(i) then return false end
    if i.Transparency>=(1-Config.Farm.MinVisibleTransparency) then return false end
    if not i.CanTouch then return false end
    return true
end
function Registry.IsLive(p)
    local m=Registry.items[p]; if not m or not m.liveSpawn then return false end
    if not p:IsDescendantOf(Workspace) then return false end
    if p.Transparency>=(1-Config.Farm.MinVisibleTransparency) then return false end
    if not p.CanTouch then return false end
    return true
end
Registry.IsAvailable=Registry.IsLive
function Registry.Remove(p)
    local m=Registry.items[p]; if not m then return end
    Registry.items[p]=nil; Registry.count=Registry.count-1
    if m.liveSpawn then Registry.liveCount=math.max(0,Registry.liveCount-1) end
    local c=Registry.conns[p]
    if c then if type(c)=="table" then for _,x in ipairs(c) do pcall(function() x:Disconnect() end) end
        else pcall(function() c:Disconnect() end) end
        Registry.conns[p]=nil end
    Registry.Removed:Fire(p)
end
function Registry.Add(p,live)
    if Registry.items[p] then return end
    live=live and true or false
    Registry.items[p]={liveSpawn=live}
    Registry.count=Registry.count+1; if live then Registry.liveCount=Registry.liveCount+1 end
    local anc=p.AncestryChanged:Connect(function() if not p:IsDescendantOf(Workspace) then Registry.Remove(p) end end)
    local hc=p:GetPropertyChangedSignal("Transparency"):Connect(function()
        if p.Transparency>=(1-Config.Farm.MinVisibleTransparency) then Registry.Remove(p) end end)
    local tc=p:GetPropertyChangedSignal("CanTouch"):Connect(function()
        if not p.CanTouch then Registry.Remove(p) end end)
    Registry.conns[p]={anc,hc,tc}
    Registry.Added:Fire(p,live)
end
function Registry.Clear()
    local ps={} for p in pairs(Registry.items) do ps[#ps+1]=p end
    for _,p in ipairs(ps) do Registry.Remove(p) end
end
function Registry.Reconcile()
    local drop={}
    for p in pairs(Registry.items) do
        if not p:IsDescendantOf(Workspace) or p.Transparency>=(1-Config.Farm.MinVisibleTransparency) or not p.CanTouch then
            drop[#drop+1]=p
        end
    end
    for _,p in ipairs(drop) do Registry.Remove(p) end
end

--========== Scanner ==========--
local Scanner={users={},userCount=0,maid=nil,scanToken=0,dumping=false,reconcileElapsed=0,reconcileInterval=0.5}
function Scanner.Consider(i,live) if isCandidate(i) then Registry.Add(i,live) end end
function Scanner.Start()
    Scanner.maid=Maid.new()
    Scanner.maid:Give(Workspace.DescendantAdded:Connect(function(i)
        if i:IsA("BasePart") then Scanner.Consider(i,true) end end))
    Scanner.maid:Give(RunService.Heartbeat:Connect(function(dt)
        Scanner.reconcileElapsed=Scanner.reconcileElapsed+dt
        if Scanner.reconcileElapsed>=Scanner.reconcileInterval then
            Scanner.reconcileElapsed=0; pcall(Registry.Reconcile)
        end
    end))
end
function Scanner.Stop() Scanner.scanToken=Scanner.scanToken+1; if Scanner.maid then Scanner.maid:Clean(); Scanner.maid=nil end; Registry.Clear() end
function Scanner.Acquire(k) if Scanner.users[k] then return end
    Scanner.users[k]=true; Scanner.userCount=Scanner.userCount+1
    if Scanner.userCount==1 then Scanner.Start() end
end
function Scanner.Release(k) if not Scanner.users[k] then return end
    Scanner.users[k]=nil; Scanner.userCount=math.max(0,Scanner.userCount-1)
    if Scanner.userCount==0 then Scanner.Stop() end
end
function Scanner.Reload() if Scanner.userCount>0 then Registry.Clear() end end
function Scanner.Shutdown() Scanner.users={}; Scanner.userCount=0; Scanner.Stop() end
function Scanner.Dump()
    if Scanner.dumping then return end
    Scanner.dumping=true
    task.spawn(function()
        local ok,err=pcall(function()
            local groups,order,total={},{},0
            local list=Workspace:GetDescendants()
            for i=1,#list do local inst=list[i]
                if inst:IsA("BasePart") and isCandidate(inst) then
                    total=total+1
                    local key=inst.Parent and inst.Parent:GetFullName() or "<nil>"
                    local g=groups[key]; if not g then g={count=0,example=inst}; groups[key]=g; order[#order+1]=key end
                    g.count=g.count+1
                end
                if i%400==0 then task.wait() end
            end
            table.sort(order,function(a,b) return groups[a].count>groups[b].count end)
            print(string.format("%s live candidate dump | keywords: %s | max size: %s",TAG,keywordsToString(Config.Keywords),tostring(Config.MaxPickupSize)))
            print(string.format("%s %d LIVE candidate part(s) in %d container(s)",TAG,total,#order))
        end)
        if not ok then warn(TAG.." dump failed: "..tostring(err)) end
        Scanner.dumping=false
    end)
end

local function getCharacterParts()
    local c=LocalPlayer.Character; if not c then return nil end
    local h=c:FindFirstChildOfClass("Humanoid"); local hrp=c:FindFirstChild("HumanoidRootPart")
    if not h or not hrp or h.Health<=0 then return nil end
    return c,h,hrp
end

local Farm,ESP,AntiAFK,Flight,Noclip,WalkSpeed={},{},{},{},{},{}

--========== Flight ==========--
Flight.enabled=false; Flight.speed=Config.Flight.DefaultSpeed; Flight.conn=nil
Flight.bv=nil; Flight.bg=nil; Flight.hum=nil; Flight.hrp=nil; Flight.attached=false
Flight.velocity=ZERO; Flight.guide=nil; Flight.prevPlatformStand=false
Flight.lastFace=nil; Flight.errored=false; Flight.paused=false; Flight.prone=false

function Flight.SetSpeed(v) Flight.speed=math.clamp(tonumber(v) or Config.Flight.DefaultSpeed,Config.Flight.MinSpeed,Config.Flight.MaxSpeed) end
function Flight.SetGuide(p) if Flight.enabled then Flight.guide=p end end
function Flight.ClearGuide() Flight.guide=nil end
function Flight.Detach()
    local bv,bg,hum,hrp=Flight.bv,Flight.bg,Flight.hum,Flight.hrp
    Flight.bv,Flight.bg,Flight.hum,Flight.hrp=nil,nil,nil,nil
    Flight.attached=false
    pcall(function() if bv then bv:Destroy() end; if bg then bg:Destroy() end end)
    pcall(function() if hum and hum.Parent then hum.PlatformStand=Flight.prevPlatformStand end end)
    pcall(function() if hrp and hrp.Parent then hrp.AssemblyLinearVelocity=ZERO; hrp.AssemblyAngularVelocity=ZERO end end)
end
function Flight.Attach(hum,hrp)
    Flight.Detach()
    local bv=Instance.new("BodyVelocity")
    bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge); bv.P=90000; bv.Velocity=ZERO; bv.Parent=hrp
    local bg=Instance.new("BodyGyro")
    bg.MaxTorque=Vector3.new(400000,400000,400000); bg.P=30000; bg.D=1000; bg.CFrame=hrp.CFrame; bg.Parent=hrp
    Flight.prevPlatformStand=hum.PlatformStand; hum.PlatformStand=true
    Flight.bv,Flight.bg,Flight.hum,Flight.hrp=bv,bg,hum,hrp; Flight.attached=true
end
function Flight.ManualVector(hum)
    if UserInputService:GetFocusedTextBox() then return ZERO end
    local cam=Workspace.CurrentCamera; if not cam then return ZERO end
    local look,right=cam.CFrame.LookVector,cam.CFrame.RightVector
    local forward,strafe=0,0
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then forward=forward+1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then forward=forward-1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then strafe=strafe+1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then strafe=strafe-1 end
    if forward==0 and strafe==0 then
        local md=hum.MoveDirection
        if md.Magnitude>0.05 then
            local fl=Vector3.new(look.X,0,look.Z); local fr=Vector3.new(right.X,0,right.Z)
            if fl.Magnitude>0.01 and fr.Magnitude>0.01 then
                forward=md:Dot(fl.Unit); strafe=md:Dot(fr.Unit)
            end
        end
    end
    local v=look*forward+right*strafe
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
        v=v+Vector3.new(0,1,0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
        v=v-Vector3.new(0,1,0)
    end
    if v.Magnitude>1 then v=v.Unit end
    return v
end
function Flight.StepInner(dt)
    if Flight.paused then
        if Flight.attached then Flight.Detach() end
        Flight.velocity=ZERO; return
    end
    local _,hum,hrp=getCharacterParts()
    if not hum then if Flight.attached then Flight.Detach() end; Flight.velocity=ZERO; return end
    if not Flight.attached or Flight.hrp~=hrp then Flight.Attach(hum,hrp) end
    local desired,face=ZERO,nil
    if Flight.guide then
        local off=Flight.guide-hrp.Position; local dist=off.Magnitude
        if dist>0.5 then
            local spd=math.min(Flight.speed,dist*Config.Flight.ApproachGain)
            desired=off.Unit*math.max(spd,math.min(Config.Flight.MinApproachSpeed,Flight.speed))
            face=Vector3.new(off.X,0,off.Z)
        end
    else
        desired=Flight.ManualVector(hum)*Flight.speed
        local cam=Workspace.CurrentCamera
        if cam then local look=cam.CFrame.LookVector; face=Vector3.new(look.X,0,look.Z) end
    end
    local alpha=1-math.exp(-Config.Flight.Smoothing*dt)
    Flight.velocity=Flight.velocity:Lerp(desired,alpha)
    Flight.bv.Velocity=Flight.velocity
    if face and face.Magnitude>0.1 then Flight.lastFace=face.Unit end
    if Flight.prone and not Flight.lastFace then
        local lv=hrp.CFrame.LookVector; Flight.lastFace=Vector3.new(lv.X,0,lv.Z).Unit
    end
    if Flight.lastFace then
        local pos=hrp.Position
        local cf=CFrame.new(pos,pos+Flight.lastFace)
        if Flight.prone then cf=cf*CFrame.Angles(-math.pi/2,0,0) end
        Flight.bg.CFrame=cf
    end
end
function Flight.Step(dt)
    local ok,err=pcall(Flight.StepInner,dt)
    if not ok and not Flight.errored then Flight.errored=true; warn(TAG.." flight error: "..tostring(err)) end
end
function Flight.SetEnabled(state)
    state=state and true or false
    if state==Flight.enabled then return end
    Flight.enabled=state; Flight.velocity=ZERO; Flight.lastFace=nil; Flight.errored=false
    if state then Flight.conn=RunService.Heartbeat:Connect(Flight.Step)
    else
        if Flight.conn then Flight.conn:Disconnect(); Flight.conn=nil end
        Flight.guide=nil; Flight.Detach()
    end
end

--========== Noclip ==========--
Noclip.userEnabled=false; Noclip.autoWhileFarming=true; Noclip.conn=nil
Noclip.char=nil; Noclip.parts={}; Noclip.original=setmetatable({},{__mode="k"}); Noclip.lastRefresh=0

function Noclip.Wanted() return (not Cleaning) and (Noclip.userEnabled or (Noclip.autoWhileFarming and Farm.enabled and Farm.working)) end
function Noclip.Refresh()
    Noclip.char=LocalPlayer.Character; Noclip.parts={}; Noclip.lastRefresh=os.clock()
    if Noclip.char then
        for _,d in ipairs(Noclip.char:GetDescendants()) do if d:IsA("BasePart") then Noclip.parts[#Noclip.parts+1]=d end end
    end
end
function Noclip.Step()
    if LocalPlayer.Character~=Noclip.char or os.clock()-Noclip.lastRefresh>1 then Noclip.Refresh() end
    for _,part in ipairs(Noclip.parts) do
        if part.Parent then
            if Noclip.original[part]==nil then Noclip.original[part]=part.CanCollide end
            if part.CanCollide then part.CanCollide=false end
        end
    end
end
function Noclip.Enable() if Noclip.conn then return end; Noclip.Refresh(); Noclip.conn=RunService.Stepped:Connect(Noclip.Step) end
function Noclip.Disable()
    if Noclip.conn then Noclip.conn:Disconnect(); Noclip.conn=nil end
    for part,was in pairs(Noclip.original) do if part.Parent then part.CanCollide=was end end
    Noclip.original=setmetatable({},{__mode="k"})
end
function Noclip.Sync() if Noclip.Wanted() then Noclip.Enable() else Noclip.Disable() end end
function Noclip.SetUserEnabled(s) Noclip.userEnabled=s and true or false; Noclip.Sync() end
function Noclip.SetAutoWhileFarming(s) Noclip.autoWhileFarming=s and true or false; Noclip.Sync() end

--========== WalkSpeed ==========--
WalkSpeed.enabled=false; WalkSpeed.value=Config.WalkSpeed.Default; WalkSpeed.original=nil
WalkSpeed.hum=nil; WalkSpeed.conn=nil; WalkSpeed.pending=false
function WalkSpeed.Clamp(v) return math.clamp(tonumber(v) or Config.WalkSpeed.Default,Config.WalkSpeed.Min,Config.WalkSpeed.Max) end
function WalkSpeed.Apply()
    local hum=WalkSpeed.hum
    if WalkSpeed.enabled and hum and hum.Parent then
        local desired=WalkSpeed.Clamp(WalkSpeed.value)
        if hum.WalkSpeed~=desired then hum.WalkSpeed=desired end
    end
end
function WalkSpeed.Unbind() if WalkSpeed.conn then WalkSpeed.conn:Disconnect(); WalkSpeed.conn=nil end; WalkSpeed.hum=nil end
function WalkSpeed.Bind(hum)
    if WalkSpeed.hum==hum and WalkSpeed.conn then return end
    WalkSpeed.Unbind(); WalkSpeed.hum=hum
    WalkSpeed.conn=hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if not WalkSpeed.enabled or WalkSpeed.pending then return end
        if hum.WalkSpeed~=WalkSpeed.Clamp(WalkSpeed.value) then
            WalkSpeed.pending=true
            task.delay(0.1,function() WalkSpeed.pending=false; WalkSpeed.Apply() end)
        end
    end)
    if WalkSpeed.original==nil then WalkSpeed.original=hum.WalkSpeed end
    WalkSpeed.Apply()
end
function WalkSpeed.SetValue(v) WalkSpeed.value=WalkSpeed.Clamp(v); WalkSpeed.Apply() end
function WalkSpeed.SetEnabled(state)
    state=state and true or false
    if state==WalkSpeed.enabled then return end
    WalkSpeed.enabled=state
    if state then
        local _,hum=getCharacterParts(); if hum then WalkSpeed.Bind(hum) end
    else
        local hum=WalkSpeed.hum; local original=WalkSpeed.original or Config.WalkSpeed.Default
        WalkSpeed.Unbind(); WalkSpeed.original=nil
        if hum and hum.Parent then pcall(function() hum.WalkSpeed=original end) end
    end
end

--========== Round / Bag ==========--
local Round={map=nil,lastSearch=0,cf=nil,size=nil,bboxAt=0}
function Round.GetMap()
    local m=Round.map
    if m and m.Parent and m:IsDescendantOf(Workspace) then return m end
    Round.map=nil
    if os.clock()-Round.lastSearch<2 then return nil end
    Round.lastSearch=os.clock()
    local cc=Workspace:FindFirstChild("CoinContainer",true)
    if cc and cc.Parent and cc.Parent~=Workspace then Round.map=cc.Parent; Round.bboxAt=0; return Round.map end
    return nil
end
function Round.Check()
    local _,hum,hrp=getCharacterParts()
    if not hrp then return false,"Waiting: not alive" end
    if not Config.Farm.OnlyInRound then return true,"ok" end
    local map=Round.GetMap()
    if not map then
        if Registry.liveCount>0 then return true,"ok" end
        return false,"Waiting: no round"
    end
    if string.find(string.lower(map.Name),"lobby",1,true) then return false,"Waiting: lobby" end
    if map:IsA("Model") then
        if os.clock()-Round.bboxAt>3 then
            local ok,cf,size=pcall(function() return map:GetBoundingBox() end)
            if ok then Round.cf,Round.size,Round.bboxAt=cf,size,os.clock() end
        end
        if Round.cf then
            local rel=Round.cf:PointToObjectSpace(hrp.Position); local pad,sz=40,Round.size
            if math.abs(rel.X)>sz.X/2+pad or math.abs(rel.Y)>sz.Y/2+pad or math.abs(rel.Z)>sz.Z/2+pad then
                return false,"Waiting: not in round"
            end
        end
    end
    return true,"ok"
end

local Bag={maid=nil,full=false,cur=0,max=0,lastScan=0,lastResult=false}
function Bag.Reset() Bag.full=false; Bag.cur=0; Bag.max=0; Bag.lastResult=false end
function Bag.Note(...)
    local args={...}
    local label=type(args[1])=="string" and string.lower(args[1]) or nil
    if label and not string.find(label,"candy",1,true) then return end
    local nums={}
    for _,v in ipairs(args) do if type(v)=="number" then nums[#nums+1]=v end end
    if #nums<2 then return end
    local cur,max=nums[#nums-1],nums[#nums]
    if max<=0 then return end
    Bag.cur,Bag.max,Bag.full=cur,max,(cur>=max)
end
function Bag.ScanGui()
    if os.clock()-Bag.lastScan<1 then return Bag.lastResult end
    Bag.lastScan=os.clock(); Bag.lastResult=false
    pcall(function()
        local pg=LocalPlayer:FindFirstChildOfClass("PlayerGui"); if not pg then return end
        local bags=pg:FindFirstChild("CoinBags",true); if not bags then return end
        for _,d in ipairs(bags:GetDescendants()) do
            if d:IsA("TextLabel") and d.Visible then
                local a,b=string.match(d.Text or "","^%s*(%d+)%s*/%s*(%d+)%s*$")
                if a and tonumber(b)>0 and tonumber(a)>=tonumber(b) then
                    local n=d.Parent
                    while n and n~=bags.Parent do
                        if string.find(string.lower(n.Name),"candy",1,true) then Bag.lastResult=true; return end
                        n=n.Parent
                    end
                end
            end
        end
    end)
    return Bag.lastResult
end
function Bag.Start()
    if Bag.maid then return end
    local m=Maid.new(); Bag.maid=m; Bag.Reset()
    task.spawn(function()
        local ok,rem=pcall(function()
            local RS=game:GetService("ReplicatedStorage")
            local r=RS:WaitForChild("Remotes",8)
            local g=r and r:WaitForChild("Gameplay",8)
            return g and g:WaitForChild("CoinCollected",8)
        end)
        if ok and rem and rem:IsA("RemoteEvent") and Bag.maid==m then
            m:Give(rem.OnClientEvent:Connect(function(...) pcall(Bag.Note,...) end))
        end
    end)
end
function Bag.Stop() if Bag.maid then Bag.maid:Clean(); Bag.maid=nil end; Bag.Reset() end
function Bag.IsFull(guiAllowed) return Bag.full or (guiAllowed and Bag.ScanGui()) end

--========== Farm ==========--
Farm.enabled=false; Farm.token=0
Farm.skipUntil=setmetatable({},{__mode="k"})
Farm.target=nil; Farm.status="Disabled"; Farm.collected=0; Farm.onStatus=nil
Farm._preFlight=nil; Farm.working=false; Farm.bagFull=false; Farm.roundCollected=0; Farm.roundStart=0
Farm.resetRequested=false

function Farm.SetStatus(s) if s==Farm.status then return end; Farm.status=s; if Farm.onStatus then pcall(Farm.onStatus,s) end end
function Farm.Skip(p) Farm.skipUntil[p]=os.clock()+Config.Farm.SkipSeconds end

function Farm.MurdererPositions()
    local list={}
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer and RoleESP.resolveRole(pl)=="Murderer" then
            local c=pl.Character; local r=c and c:FindFirstChild("HumanoidRootPart")
            if r then list[#list+1]=r.Position end
        end
    end
    return list
end
function Farm.GroundY(pos)
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={LocalPlayer.Character}
    local hit=Workspace:Raycast(pos+Vector3.new(0,2,0),Vector3.new(0,-300,0),params)
    return hit and hit.Position.Y or (pos.Y-4)
end
function Farm.IdleGuide(hrp)
    local pos=hrp.Position
    return Vector3.new(pos.X,Farm.GroundY(pos)+Config.Farm.GroundOffset,pos.Z)
end
function Farm.SetWorking(state)
    state=state and true or false
    if state==Farm.working then return end
    Farm.working=state
    if state then
        Farm.roundStart=os.clock(); Farm.bagFull=false; Farm.roundCollected=0; Bag.Reset()
        Flight.prone=Config.Farm.LieDown
    else
        Flight.ClearGuide(); Flight.paused=true; Flight.prone=false
    end
    Noclip.Sync()
end
function Farm.PickTarget(origin)
    local now=os.clock(); local best,bestDist=nil,math.huge
    local danger=Config.Farm.AvoidMurderer and Farm.MurdererPositions() or nil
    for p in pairs(Registry.items) do
        local skipT=Farm.skipUntil[p]
        if (not skipT or skipT<=now) and Registry.IsLive(p) then
            local safe=true
            if danger then
                for _,mp in ipairs(danger) do
                    if (p.Position-mp).Magnitude<Config.Farm.AvoidRadius then safe=false; break end
                end
            end
            if safe then
                local d=(p.Position-origin).Magnitude
                if d<bestDist then best,bestDist=p,d end
            end
        end
    end
    return best
end
function Farm.WalkTo(hum,hrp,part,active)
    local startT=os.clock()
    local lastPos,lastMove,lastIssue=hrp.Position,startT,0
    local dist=(hrp.Position-part.Position).Magnitude
    local speed=Flight.enabled and Flight.speed or math.max(hum.WalkSpeed,8)
    local timeout=math.clamp(math.max(Config.Farm.TargetTimeout,dist/speed*1.5+3),5,40)
    while active() do
        if not Registry.IsLive(part) then return "gone",dist end
        if not hrp.Parent or not hum.Parent or hum.Health<=0 then return "dead",dist end
        dist=(hrp.Position-part.Position).Magnitude
        if dist<=Config.Farm.ArriveRadius then return "arrived",dist end
        local now=os.clock()
        if now-startT>timeout then return "timeout",dist end
        if Config.Farm.AvoidMurderer then
            for _,mp in ipairs(Farm.MurdererPositions()) do
                if (part.Position-mp).Magnitude<Config.Farm.AvoidRadius then return "danger",dist end
            end
        end
        if Flight.enabled and not Flight.paused then
            Flight.SetGuide(part.Position)
        elseif Flight.enabled then
            if now-lastIssue>=1 then lastIssue=now; hum:MoveTo(part.Position) end
        else
            if (hrp.Position-lastPos).Magnitude>1 then lastPos,lastMove=hrp.Position,now
            elseif now-lastMove>1.25 then hum.Jump=true; lastMove=now end
            if now-lastIssue>=1 then lastIssue=now; hum:MoveTo(part.Position) end
        end
        task.wait(0.1)
    end
    return "stopped",dist
end
function Farm.ShouldReset()
    if not Config.Farm.ResetWhenFull or Farm.bagFull then return false end
    if Bag.IsFull(os.clock()-Farm.roundStart>6) then return true end
    local n=Config.Farm.ResetAfter
    return n>0 and Farm.roundCollected>=n
end

local function fireNativeReset()
    local fired=false
    pcall(function()
        local rs=game:GetService("ReplicatedStorage")
        local r=rs:FindFirstChild("ResetCharacter",true)
        if r and r:IsA("RemoteEvent") then
            r:FireServer(); fired=true
        end
    end)
    return fired
end

function Farm.ResetSelf(active)
    if Farm.resetRequested then return end
    Farm.resetRequested=true
    Farm.bagFull=true
    Farm.SetStatus("Bag full - resetting")
    Flight.ClearGuide()

    local _,hum,hrp=getCharacterParts()
    if not (hum and hrp) then Farm.resetRequested=false; return end

    local startChar=LocalPlayer.Character
    local usedNative=fireNativeReset()

    if usedNative then
        local t0=os.clock()
        while active() and os.clock()-t0<8 do
            local c=LocalPlayer.Character
            if c~=startChar then break end
            local h=c and c:FindFirstChildOfClass("Humanoid")
            if (not h) or h.Health<=0 then break end
            task.wait(0.2)
        end
    end

    if getCharacterParts() then
        Farm.SetStatus("Waiting: round end (bag full)")
        Farm.working=false
        Flight.ClearGuide()
        local waitT0=os.clock()
        while active() and getCharacterParts() and os.clock()-waitT0<180 do
            if not Round.Check() then break end
            task.wait(0.5)
        end
        Farm.SetStatus("Waiting: next round")
    else
        Farm.SetStatus("Waiting: next round")
    end

    Farm.bagFull=false
    Farm.roundCollected=0
    Farm.resetRequested=false
    Bag.Reset()
    local t0=os.clock()
    while active() and (os.clock()-t0)<0.8 do task.wait(0.1) end
end

function Farm.Count() Farm.collected=Farm.collected+1; Farm.roundCollected=Farm.roundCollected+1 end

local FarmDelayRng = Random.new()
function Farm.PauseBetweenCoins(active)
    local base   = Config.Farm.CoinDelay or 0.35
    local jitter = Config.Farm.CoinDelayJitter or 0.25
    if base <= 0 and jitter <= 0 then return end
    local waitT = base + (jitter > 0 and FarmDelayRng:NextNumber(0, jitter) or 0)
    local t0 = os.clock()
    Farm.SetStatus("Cooling down")
    Flight.ClearGuide()
    while active() and (os.clock() - t0) < waitT do
        task.wait(0.05)
    end
end

function Farm.Step(active)
    local inGame,reason=Round.Check()
    if not inGame then
        Farm.SetWorking(false); Farm.SetStatus(reason); task.wait(0.5); return
    end
    Farm.SetWorking(true)
    Flight.paused=false
    Flight.prone=Config.Farm.LieDown

    local _,hum,hrp=getCharacterParts()
    if not hum then Farm.SetStatus("Idle"); Flight.ClearGuide(); task.wait(0.5); return end
    if Farm.ShouldReset() then Farm.ResetSelf(active); return end
    local target=Farm.PickTarget(hrp.Position)
    if not target then
        Farm.SetStatus("Searching")
        Flight.SetGuide(Farm.IdleGuide(hrp))
        task.wait(0.5); return
    end
    Farm.target=target; Farm.SetStatus("Farming")
    local result,dist=Farm.WalkTo(hum,hrp,target,active)
    Farm.target=nil

    local consumed = false
    if result=="arrived" then
        local t0=os.clock()
        while active() and os.clock()-t0<1 and Registry.IsLive(target) do
            if Flight.enabled then Flight.SetGuide(target.Position) else hum:MoveTo(target.Position) end
            task.wait(0.05)
        end
        if Registry.IsLive(target) then Farm.Skip(target) else Farm.Count(); consumed=true end
    elseif result=="gone" then
        if dist<=Config.Farm.ArriveRadius+4 then Farm.Count(); consumed=true end
    elseif result=="timeout" then
        Farm.Skip(target); Flight.ClearGuide()
    elseif result=="danger" then
        Farm.skipUntil[target]=os.clock()+5
        Farm.SetStatus("Avoiding murderer")
        Flight.SetGuide(Farm.IdleGuide(hrp)); task.wait(0.3)
    elseif result=="dead" then
        Flight.ClearGuide()
    end

    if consumed then Farm.PauseBetweenCoins(active) end
end
function Farm.Loop(token)
    local function active() return Farm.enabled and Farm.token==token and not Cleaning end
    while active() do
        if Farm.resetRequested and not Farm.bagFull then Farm.resetRequested=false end
        local ok,err=pcall(Farm.Step,active)
        if not ok then warn(TAG.." farm step error: "..tostring(err)); task.wait(1) end
    end
    Farm.resetRequested=false
end
function Farm.SetEnabled(state)
    state=state and true or false
    if state==Farm.enabled then return end
    Farm.enabled=state; Farm.token=Farm.token+1
    if state then
        Farm._preFlight=Flight.enabled
        if not Flight.enabled then Flight.SetEnabled(true) end
        Farm._preSpeed=Flight.speed; Flight.SetSpeed(Config.Farm.FarmSpeed)
        Farm.working=false; Flight.paused=true
        Farm.bagFull=false; Farm.roundCollected=0; Farm.resetRequested=false
        Scanner.Acquire("farm"); Bag.Start(); Farm.SetStatus("Searching")
        task.spawn(Farm.Loop,Farm.token)
    else
        Flight.ClearGuide(); Farm.working=false; Flight.paused=false; Flight.prone=false
        if Farm._preSpeed then Flight.SetSpeed(Farm._preSpeed); Farm._preSpeed=nil end
        local _,hum,hrp=getCharacterParts()
        if hum and hrp and not Flight.enabled then pcall(function() hum:MoveTo(hrp.Position) end) end
        if not Farm._preFlight then Flight.SetEnabled(false) end
        Farm._preFlight=nil
        Farm.target=nil; Farm.resetRequested=false; Farm.SetStatus("Disabled"); Scanner.Release("farm"); Bag.Stop()
    end
    Noclip.Sync()
end

--========== ESP ==========--
ESP.enabled=false; ESP.maid=nil; ESP.folder=nil
ESP.boxes={}; ESP.boxCount=0; ESP.elapsed=0

function ESP.GetContainer()
    if ESP.folder and ESP.folder.Parent then return ESP.folder end
    local folder=Instance.new("Folder"); folder.Name="OpiumCandyESP"; mountGui(folder); ESP.folder=folder; return folder
end
local function readColor(part)
    if part:IsA("BasePart") then return part.Color end
    if part:IsA("Model") then
        local p=part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart",true)
        if p then return p.Color end
    end
    return Config.ESP.Color
end
function ESP.CreateBox(part)
    if ESP.boxCount>=Config.ESP.MaxMarkers then return nil end
    local hl=Instance.new("Highlight")
    hl.Adornee=part; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency=Config.ESP.Transparency; hl.OutlineTransparency=0
    local c=readColor(part); hl.FillColor=c; hl.OutlineColor=c
    hl.Parent=ESP.GetContainer()
    local conn=part:GetPropertyChangedSignal("Color"):Connect(function()
        if part.Parent then local nc=readColor(part); hl.FillColor=nc; hl.OutlineColor=nc end
    end)
    ESP.boxes[part]={box=hl,conn=conn}; ESP.boxCount=ESP.boxCount+1
    return hl
end
function ESP.RemoveBox(part)
    local e=ESP.boxes[part]; if not e then return end
    ESP.boxes[part]=nil; ESP.boxCount=math.max(0,ESP.boxCount-1)
    pcall(function() if e.conn then e.conn:Disconnect() end end)
    pcall(function() e.box:Destroy() end)
end
function ESP.ApplyAll()
    for part,e in pairs(ESP.boxes) do
        e.box.FillTransparency=Config.ESP.Transparency
        local c=readColor(part); e.box.FillColor=c; e.box.OutlineColor=c
    end
    ESP.Refresh()
end
function ESP.Refresh()
    if not ESP.enabled then return end
    local _,_,hrp=getCharacterParts()
    local origin=hrp and hrp.Position or (Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position)
    if not origin then return end
    local seen={}
    for part in pairs(Registry.items) do
        if Registry.IsLive(part) then
            local dist=(part.Position-origin).Magnitude
            if dist<=Config.ESP.MaxDistance then
                if not ESP.boxes[part] then ESP.CreateBox(part) end
                if ESP.boxes[part] then seen[part]=true end
            end
        end
    end
    for part in pairs(ESP.boxes) do if not seen[part] then ESP.RemoveBox(part) end end
end
function ESP.RemoveAll()
    local ps={} for p in pairs(ESP.boxes) do ps[#ps+1]=p end
    for _,p in ipairs(ps) do ESP.RemoveBox(p) end
end
function ESP.SetEnabled(state)
    state=state and true or false
    if state==ESP.enabled then return end
    ESP.enabled=state
    if state then
        Scanner.Acquire("esp"); ESP.maid=Maid.new(); ESP.elapsed=0
        ESP.maid:Give(Registry.Removed:Connect(function(p) ESP.RemoveBox(p) end))
        ESP.maid:Give(Registry.Added:Connect(function() ESP.Refresh() end))
        ESP.maid:Give(RunService.Heartbeat:Connect(function(dt)
            ESP.elapsed=ESP.elapsed+dt
            if ESP.elapsed>=Config.ESP.UpdateInterval then ESP.elapsed=0; pcall(ESP.Refresh) end
        end))
        ESP.Refresh()
    else
        if ESP.maid then ESP.maid:Clean(); ESP.maid=nil end
        ESP.RemoveAll()
        if ESP.folder then pcall(function() ESP.folder:Destroy() end); ESP.folder=nil end
        Scanner.Release("esp")
    end
end
function ESP.Destroy() ESP.SetEnabled(false); ESP.RemoveAll()
    if ESP.folder then pcall(function() ESP.folder:Destroy() end); ESP.folder=nil end end

--========== Anti-AFK ==========--
AntiAFK.enabled=false; AntiAFK.conn=nil
function AntiAFK.SetEnabled(state)
    state=state and true or false
    if state==AntiAFK.enabled then return end
    AntiAFK.enabled=state
    if state then
        AntiAFK.conn=LocalPlayer.Idled:Connect(function()
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
        end)
    elseif AntiAFK.conn then
        AntiAFK.conn:Disconnect(); AntiAFK.conn=nil
    end
end

--========== Palette ==========--
local Palette={
    Navy=Color3.fromRGB(7,10,22), Panel=Color3.fromRGB(11,15,32),
    Blue=Color3.fromRGB(79,123,255), Purple=Color3.fromRGB(139,92,246),
    Text=Color3.fromRGB(232,236,255), Sub=Color3.fromRGB(150,160,200),
    Dim=Color3.fromRGB(95,105,145), Error=Color3.fromRGB(255,122,138),
}

--========== UI state ==========--
local Controls={}
local UI={
    ready=false,building=false,syncing=false,
    tabList={},items={},searchBoxes={},query="",
    animated=true,fxEnabled=false,fxToken=0,bgEnabled=true,bgFront=true,
    themeNames={},store=nil,
    root=nil,backdrop=nil,art=nil,shade=nil,fx=nil,scale=nil,card=nil,cardStroke=nil,orbGui=nil,
    profilePara=nil,optionId=0,
}

local function notify(title,content)
    if not (UI.ready and Fluent) then return end
    pcall(function() Fluent:Notify({Title=title,Content=content,Duration=4}) end)
end
local function guarded(label,fn)
    return function(...)
        if Cleaning then return end
        local ok,err=pcall(fn,...)
        if not ok then warn(TAG.." "..label.." error: "..tostring(err)) end
    end
end
local function nextId(prefix) UI.optionId=UI.optionId+1; return prefix..UI.optionId end
local function decimalsOf(step)
    if not step or step>=1 then return 0 end
    local d=string.match(tostring(step),"%.(%d+)"); return d and #d or 1
end

--========== Aimbot ==========--
local Aim={enabled=false,token=0,role="Innocent",equipped=false,target=nil,
    knownMurderer=nil,knownChar=nil,mapRef=nil,lastAct=0,busy=false,
    gui=nil,button=nil,renderConn=nil,dragMoved=false}

local function toolNameHas(t,a,b)
    local n=string.lower(t.Name)
    return string.find(n,a,1,true)~=nil or (b~=nil and string.find(n,b,1,true)~=nil)
end
local function aliveParts(pl)
    local c=pl.Character; if not c then return nil end
    local h=c:FindFirstChildOfClass("Humanoid"); local r=c:FindFirstChild("HumanoidRootPart")
    if not h or not r or h.Health<=0 then return nil end
    return c,h,r
end
function Aim.FindOwnTool(kind)
    local holders={LocalPlayer.Character,LocalPlayer:FindFirstChildOfClass("Backpack")}
    for _,h in ipairs(holders) do
        if h then
            for _,t in ipairs(h:GetChildren()) do
                if t:IsA("Tool") then
                    if kind=="knife" and toolNameHas(t,"knife") then return t,(h==LocalPlayer.Character) end
                    if kind=="gun" and toolNameHas(t,"gun","revolver") then return t,(h==LocalPlayer.Character) end
                end
            end
        end
    end
    return nil,false
end
function Aim.HoldsKnife(pl)
    local c=pl.Character; if not c then return false end
    for _,t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") and toolNameHas(t,"knife") then return true end
    end
    return false
end
function Aim.HasLOS(from,part)
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={LocalPlayer.Character,part.Parent}
    return Workspace:Raycast(from,part.Position-from,params)==nil
end
function Aim.AimPoint(part,from,role)
    local pos=part.Position
    if Config.Aim.Prediction then
        local d=(pos-from).Magnitude
        local t=(role=="Murderer") and (d/Config.Aim.KnifeSpeed) or 0.05
        pos=pos+part.AssemblyLinearVelocity*t
    end
    return pos
end
function Aim.UpdateMurderer()
    local m=Round.GetMap()
    if m~=Aim.mapRef then Aim.mapRef=m; Aim.knownMurderer=nil; Aim.knownChar=nil end
    local km=Aim.knownMurderer
    if km and (km.Parent~=Players or km.Character~=Aim.knownChar or not aliveParts(km)) then
        Aim.knownMurderer=nil; Aim.knownChar=nil
    end
    if not Aim.knownMurderer then
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer and aliveParts(pl) and Aim.HoldsKnife(pl) then
                Aim.knownMurderer=pl; Aim.knownChar=pl.Character; break
            end
        end
    end
    return Aim.knownMurderer
end
function Aim.NearestTarget(maxDist,needLOS,from)
    local best,bestD
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer then
            local _,_,r=aliveParts(pl)
            if r then
                local d=(r.Position-from).Magnitude
                if d<=maxDist and (not bestD or d<bestD) and (not needLOS or Aim.HasLOS(from,r)) then
                    best,bestD=r,d
                end
            end
        end
    end
    return best
end
function Aim.Equip(tool)
    local c,h=getCharacterParts()
    if not h then return false end
    if tool.Parent~=c then pcall(function() h:EquipTool(tool) end); task.wait(0.15) end
    return tool.Parent==c
end
function Aim.SnapCamera(point)
    local cam=Workspace.CurrentCamera; if not cam then return end
    cam.CFrame=CFrame.new(cam.CFrame.Position,point)
end
function Aim.FireGun(part)
    if Aim.busy then return end
    Aim.busy=true
    pcall(function()
        local tool=Aim.FindOwnTool("gun"); if not tool then return end
        if not Aim.Equip(tool) then return end
        local cam=Workspace.CurrentCamera; if not cam or not part.Parent then return end
        local pt=Aim.AimPoint(part,cam.CFrame.Position,"Sheriff")
        Aim.SnapCamera(pt); task.wait(0.03)
        local v,on=cam:WorldToViewportPoint(pt)
        if not on then return end
        VirtualInputManager:SendMouseMoveEvent(v.X,v.Y,game); task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(v.X,v.Y,0,true,game,0); task.wait(0.04)
        VirtualInputManager:SendMouseButtonEvent(v.X,v.Y,0,false,game,0)
    end)
    Aim.busy=false
end
function Aim.ThrowKnife(part)
    if Aim.busy then return end
    Aim.busy=true
    pcall(function()
        local tool=Aim.FindOwnTool("knife"); if not tool then return end
        if not Aim.Equip(tool) then return end
        local cam=Workspace.CurrentCamera; if not cam or not part.Parent then return end
        local _,_,hrp=getCharacterParts(); if not hrp then return end
        local pt=Aim.AimPoint(part,cam.CFrame.Position,"Murderer")
        Aim.SnapCamera(pt)
        hrp.CFrame=CFrame.new(hrp.Position,Vector3.new(pt.X,hrp.Position.Y,pt.Z))
        task.wait(0.05)
        local v,on=cam:WorldToViewportPoint(pt)
        if on then pcall(function() VirtualInputManager:SendMouseMoveEvent(v.X,v.Y,game) end) end
        VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.E,false,game); task.wait(0.15)
        VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.E,false,game)
    end)
    Aim.busy=false
end

function Aim.RefreshButton()
    local btn=Aim.button; if not btn then return end
    local show=Aim.enabled and Config.Aim.ShowButton and (Aim.role=="Sheriff" or Aim.role=="Murderer")
    btn.Visible=show and true or false
    if show then btn.Text=(Aim.role=="Sheriff") and "SHOOT" or "THROW" end
end

function Aim.Tick(skipAuto)
    local _,_,r=aliveParts(LocalPlayer)
    if not r then
        Aim.target=nil; Aim.role="Innocent"; Aim.equipped=false; Aim.RefreshButton(); return
    end
    local knife,kEq=Aim.FindOwnTool("knife")
    local gun,gEq=Aim.FindOwnTool("gun")
    local role,eq="Innocent",false
    if knife then role,eq="Murderer",kEq elseif gun then role,eq="Sheriff",gEq end
    Aim.role,Aim.equipped=role,eq
    local cam=Workspace.CurrentCamera
    local from=cam and cam.CFrame.Position or r.Position
    local target=nil
    if role=="Sheriff" then
        local m=Aim.UpdateMurderer()
        if m then
            local _,_,mr=aliveParts(m)
            if mr and (mr.Position-r.Position).Magnitude<=Config.Aim.MaxDistance
                and (not Config.Aim.RequireLOS or Aim.HasLOS(from,mr)) then target=mr end
        end
    elseif role=="Murderer" then
        target=Aim.NearestTarget(Config.Aim.MaxDistance,Config.Aim.RequireLOS,from)
    end
    Aim.target=target
    Aim.RefreshButton()
    if skipAuto or Aim.busy or not target or not eq then return end
    if os.clock()-Aim.lastAct<Config.Aim.Cooldown then return end
    if role=="Sheriff" and Config.Aim.AutoShoot then
        Aim.lastAct=os.clock(); task.spawn(Aim.FireGun,target)
    elseif role=="Murderer" and Config.Aim.AutoThrow then
        Aim.lastAct=os.clock(); task.spawn(Aim.ThrowKnife,target)
    end
end

function Aim.Render()
    if not Aim.enabled or not Aim.target or not Aim.equipped or Aim.busy then return end
    local lock=(Aim.role=="Sheriff" and Config.Aim.SheriffLock) or (Aim.role=="Murderer" and Config.Aim.MurdererLock)
    if not lock or not Aim.target.Parent then return end
    local cam=Workspace.CurrentCamera; if not cam then return end
    local pt=Aim.AimPoint(Aim.target,cam.CFrame.Position,Aim.role)
    cam.CFrame=cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position,pt),math.clamp(Config.Aim.Smooth,0.02,1))
end

function Aim.ManualAction()
    pcall(Aim.Tick,true)
    if Aim.role=="Sheriff" then
        local mr
        if Aim.knownMurderer then local _,_,r2=aliveParts(Aim.knownMurderer); mr=r2 end
        if not mr then notify("Aimbot","Murderer not found yet (nobody has shown a knife)."); return end
        task.spawn(Aim.FireGun,mr)
    elseif Aim.role=="Murderer" then
        local cam=Workspace.CurrentCamera
        local from=cam and cam.CFrame.Position or Vector3.new()
        local tgt=Aim.target or Aim.NearestTarget(Config.Aim.MaxDistance,false,from)
        if not tgt then notify("Aimbot","No target in range."); return end
        task.spawn(Aim.ThrowKnife,tgt)
    else
        notify("Aimbot","You need a Gun (Sheriff) or Knife (Murderer).")
    end
end

function Aim.BuildButton()
    if Aim.gui and Aim.gui.Parent then return end
    local gui=Instance.new("ScreenGui")
    gui.Name="OpiumAimButton"; gui.ResetOnSpawn=false; gui.DisplayOrder=150; gui.IgnoreGuiInset=true
    if not mountGui(gui) then gui:Destroy(); return end
    Aim.gui=gui
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.fromOffset(84,34); btn.Position=UDim2.new(1,-110,0.5,0)
    btn.BackgroundColor3=Palette.Panel; btn.BorderSizePixel=0; btn.AutoButtonColor=true
    btn.Font=Enum.Font.GothamBold; btn.TextSize=13; btn.TextColor3=Palette.Text
    btn.Text="SHOOT"; btn.Visible=false; btn.Active=true; btn.Parent=gui
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(1,0); c.Parent=btn
    local st=Instance.new("UIStroke"); st.Color=Palette.Purple; st.Thickness=1; st.Transparency=0.2; st.Parent=btn
    pcall(function()
        local drag=Instance.new("UIDragDetector"); drag.Parent=btn
        drag.DragStart:Connect(function() Aim.dragMoved=false end)
        drag.DragContinue:Connect(function() Aim.dragMoved=true end)
    end)
    btn.MouseButton1Click:Connect(function()
        if Aim.dragMoved then Aim.dragMoved=false; return end
        Aim.ManualAction()
    end)
    Aim.button=btn
end

function Aim.SetEnabled(state)
    state=state and true or false
    if state==Aim.enabled then return end
    Aim.enabled=state; Aim.token=Aim.token+1
    if state then
        Aim.BuildButton()
        Aim.renderConn=RunService.RenderStepped:Connect(function() pcall(Aim.Render) end)
        local tk=Aim.token
        task.spawn(function()
            while Aim.enabled and Aim.token==tk and not Cleaning do
                local ok,err=pcall(Aim.Tick)
                if not ok then warn(TAG.." aimbot tick error: "..tostring(err)) end
                task.wait(0.1)
            end
        end)
    else
        if Aim.renderConn then Aim.renderConn:Disconnect(); Aim.renderConn=nil end
        Aim.target=nil; Aim.knownMurderer=nil; Aim.knownChar=nil
        if Aim.button then Aim.button.Visible=false end
    end
end
function Aim.Destroy()
    Aim.SetEnabled(false)
    if Aim.gui then pcall(function() Aim.gui:Destroy() end); Aim.gui=nil; Aim.button=nil end
end

--========== Fluent loader ==========--
local FLUENT_URLS={
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua",
    "https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau",
}
local function loadFluent()
    for _,url in ipairs(FLUENT_URLS) do
        local ok,lib=pcall(function() return loadstring(game:HttpGet(url))() end)
        if ok and type(lib)=="table" and type(lib.CreateWindow)=="function" then return lib end
        warn(TAG.." could not load Fluent from "..url..": "..tostring(lib))
    end
    return nil
end

--========== Extra themes ==========--
local THEME_DEFS={
    {Name="Amberglow",accent=Color3.fromRGB(255,176,46),main=Color3.fromRGB(44,26,12),border=Color3.fromRGB(150,92,32),
        g1=Color3.fromRGB(78,42,12),g2=Color3.fromRGB(26,13,6),tint=Color3.fromRGB(255,176,96),
        elem=Color3.fromRGB(12,7,3),elemT=0.42,elemBorder=Color3.fromRGB(126,80,26),
        text=Color3.fromRGB(255,238,206),sub=Color3.fromRGB(245,166,48)},
    {Name="Halloween 2026",accent=Color3.fromRGB(255,128,20),main=Color3.fromRGB(34,14,3),border=Color3.fromRGB(214,98,18),
        g1=Color3.fromRGB(104,44,6),g2=Color3.fromRGB(26,10,2),tint=Color3.fromRGB(255,140,40),
        elem=Color3.fromRGB(18,8,2),elemT=0.4,elemBorder=Color3.fromRGB(200,92,16),
        text=Color3.fromRGB(255,240,220),sub=Color3.fromRGB(255,150,40)},
    {Name="Sakura Night",accent=Color3.fromRGB(255,128,176),main=Color3.fromRGB(32,16,30),border=Color3.fromRGB(150,70,118),
        g1=Color3.fromRGB(70,28,60),g2=Color3.fromRGB(20,10,22),tint=Color3.fromRGB(255,150,200),
        text=Color3.fromRGB(255,236,246),sub=Color3.fromRGB(214,160,190)},
    {Name="Neon Abyss",accent=Color3.fromRGB(64,255,214),main=Color3.fromRGB(8,18,26),border=Color3.fromRGB(30,110,120),
        g1=Color3.fromRGB(10,44,56),g2=Color3.fromRGB(5,10,16),tint=Color3.fromRGB(80,220,230),
        text=Color3.fromRGB(226,255,252),sub=Color3.fromRGB(130,190,196)},
}

local function themeStoreLookup()
    local getups=(debug and debug.getupvalues) or getupvalues
    local creator=Fluent.Creator
    if type(creator)=="table" and type(getups)=="function" then
        for _,fname in ipairs({"GetThemeProperty","UpdateTheme","AddThemeObject"}) do
            local fn=creator[fname]
            if type(fn)=="function" then
                local ok,ups=pcall(getups,fn)
                if ok and type(ups)=="table" then
                    for _,u in pairs(ups) do
                        if type(u)=="table" and type(u.Dark)=="table" and type(u.Names)=="table" then return u end
                    end
                end
            end
        end
    end
    local t=Fluent.Themes
    if type(t)=="table" and type(t.Dark)=="table" and type(t.Names)=="table" then return t end
    return nil
end

local function registerThemes()
    UI.themeNames={}
    local store=themeStoreLookup(); UI.store=store
    if store then
        local black=Color3.new(0,0,0)
        for _,p in ipairs(THEME_DEFS) do
            local t={}
            for k,v in pairs(store.Dark) do t[k]=v end
            t.Name=p.Name; t.Accent=p.accent
            t.AcrylicMain=p.main; t.AcrylicBorder=p.border
            t.AcrylicGradient=ColorSequence.new(p.g1,p.g2); t.AcrylicNoise=0.92
            t.TitleBarLine=p.border; t.Tab=p.tint
            t.Element=p.elem or p.tint; t.ElementBorder=p.elemBorder or p.main:Lerp(black,0.5); t.InElementBorder=p.border
            t.ElementTransparency=p.elemT or 0.87
            t.ToggleSlider=p.tint; t.ToggleToggled=black; t.SliderRail=p.tint
            t.DropdownFrame=p.tint:Lerp(Color3.new(1,1,1),0.2); t.DropdownHolder=p.main:Lerp(black,0.25)
            t.DropdownBorder=p.main:Lerp(black,0.5); t.DropdownOption=p.tint
            t.Keybind=p.tint; t.Input=p.tint:Lerp(Color3.new(1,1,1),0.2)
            t.InputFocused=p.main:Lerp(black,0.6); t.InputIndicator=p.accent
            t.Dialog=p.main:Lerp(black,0.15); t.DialogHolder=p.main:Lerp(black,0.3)
            t.DialogHolderLine=p.main:Lerp(black,0.5); t.DialogButton=p.main
            t.DialogButtonBorder=p.border; t.DialogBorder=p.border
            t.DialogInput=p.main:Lerp(p.tint,0.1); t.DialogInputLine=p.accent
            t.Text=p.text; t.SubText=p.sub; t.Hover=p.tint; t.HoverChange=0.07
            store[p.Name]=t
            if not table.find(store.Names,p.Name) then table.insert(store.Names,p.Name) end
        end
        for _,n in ipairs(store.Names) do UI.themeNames[#UI.themeNames+1]=n end
    else
        warn(TAG.." could not reach Fluent's theme table; custom themes unavailable.")
        UI.themeNames={"Dark","Darker","Light","Aqua","Amethyst","Rose"}
    end
end
local function themeField(name,field,fallback)
    local t=UI.store and UI.store[name]
    return (t and t[field]) or fallback
end

local function applyTheme(name)
    pcall(function() Fluent:SetTheme(name) end)
    UI.currentTheme=name
    local acc=themeField(name,"Accent",Color3.fromRGB(96,205,255))
    if UI.cardStroke then UI.cardStroke.Color=acc end
    if UI.orbStroke then UI.orbStroke.Color=acc end
    if UI.topStroke then UI.topStroke.Color=acc end
    if UI.topOpen then UI.topOpen.BackgroundColor3=acc end
    if UI.glowStroke then UI.glowStroke.Color=acc end
    if UI.sheenGrad then UI.sheenGrad.Color=ColorSequence.new(acc,Color3.new(1,1,1)) end
    for _,o in ipairs(UI.designAccent or {}) do if o.Parent then o.BackgroundColor3=acc end end
    if UI.shade then UI.shade.BackgroundColor3=themeField(name,"AcrylicMain",Color3.new(0,0,0)) end
end

--========== Search ==========--
local function resolveFrames()
    local claimed={}
    for _,it in ipairs(UI.items) do if it.frame and it.frame.Parent then claimed[it.frame]=true end end
    for _,it in ipairs(UI.items) do
        if not (it.frame and it.frame.Parent) then
            it.frame=nil
            local t=it.tab.t
            local cont=t.Container or t.ScrollFrame
            if typeof(cont)=="Instance" then
                for _,d in ipairs(cont:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Text==it.title then
                        local a=d
                        while a.Parent and a.Parent~=cont do a=a.Parent end
                        if a.Parent==cont and a:IsA("GuiObject") and not claimed[a] then
                            it.frame=a; claimed[a]=true; break
                        end
                    end
                end
            end
        end
    end
end

local function applyFilter(query)
    UI.query=query
    local q=string.lower(trim(query or ""))
    resolveFrames()
    local shown,counts=0,{}
    for _,it in ipairs(UI.items) do
        local match=(q=="") or string.find(it.key,q,1,true)~=nil
        if it.frame then it.frame.Visible=match end
        if match then shown=shown+1; counts[it.tab]=(counts[it.tab] or 0)+1 end
    end
    return shown,#UI.items,counts
end

local function addSearchBox(rec)
    local inp
    inp=rec.t:AddInput(nextId("Search"),{
        Title="Search features",Description="Type to filter every tab",
        Default="",Placeholder="e.g. speed, candy, aimbot...",Numeric=false,Finished=false,
        Callback=function(text)
            if UI.syncing or UI.building or Cleaning then return end
            text=tostring(text or "")
            UI.syncing=true
            for _,b in ipairs(UI.searchBoxes) do
                if b.inp~=inp and b.inp then pcall(function() b.inp:SetValue(text) end) end
            end
            UI.syncing=false
            local ok,shown,total,counts=pcall(applyFilter,text)
            if not ok then warn(TAG.." search error: "..tostring(shown)); return end
            local label=(trim(text)=="") and "Type to filter every tab"
                or string.format("Showing %d of %d features",shown,total)
            for _,b in ipairs(UI.searchBoxes) do
                if b.inp then pcall(function() b.inp:SetDesc(label) end) end
            end
            if trim(text)~="" and (counts[rec] or 0)==0 then
                for _,other in ipairs(UI.tabList) do
                    if (counts[other] or 0)>0 then pcall(function() Window:SelectTab(other.index) end); break end
                end
            end
        end,
    })
    UI.searchBoxes[#UI.searchBoxes+1]={inp=inp,rec=rec}
    return inp
end

--========== Element wrappers ==========--
local TAB_EMOJI={["Candies AutoFarm"]="🍬",["Visual ESP"]="👁",["Aimbot"]="🎯",["Movement"]="🦇",
    ["Appearance"]="🎃",["Profile"]="🧛",["Settings"]="🕯️"}
local function newTab(title,icon)
    local t=Window:AddTab({Title=(TAB_EMOJI[title] or "🎃").." "..title,Icon=icon})
    local rec={t=t,index=#UI.tabList+1,title=title}
    UI.tabList[#UI.tabList+1]=rec
    return rec
end
local HEADER_EMOJI={
    ["Candy statistics"]="🎃",["Candy farm"]="🍬",["Collection settings"]="🕯️",
    ["Candy Highlights"]="✨",["ESP Style"]="🎨",["Role ESP (equipped weapon)"]="👁",
    ["Master Switch"]="💀",["Sheriff (Gun)"]="🔫",["Murderer (Knife)"]="🔪",["Aim Tuning"]="🎯",
    ["Flight Controls"]="🦇",["Noclip Controls"]="👻",["Walk Speed Controls"]="🕷",
    ["Look & Feel"]="🎃",["Glass & Motion"]="🔮",["Backdrop"]="🌙",["Closed State"]="🕸",
    ["Player Card"]="🧛",["Idle Protection"]="😴",["Detection Tools"]="🔍",["Control"]="🛠",
}
local function header(rec,title)
    title=(HEADER_EMOJI[title] or "🎃").." "..title
    UI.headers=UI.headers or {}
    UI.headers[#UI.headers+1]={rec=rec,title=title}
    pcall(function() rec.t:AddSection(title) end)
end
local function styleHeaders()
    for _,h in ipairs(UI.headers or {}) do
        local cont=h.rec.t.Container or h.rec.t.ScrollFrame
        if typeof(cont)=="Instance" then
            for _,d in ipairs(cont:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text==h.title then
                    pcall(function() d.TextSize=20; d.Font=Enum.Font.GothamBold end)
                    break
                end
            end
        end
    end
end
local function track(rec,title,desc)
    UI.items[#UI.items+1]={tab=rec,title=title,key=string.lower(rec.title.." "..title.." "..(desc or "")),frame=nil}
end
local function addToggle(rec,title,desc,default,onChange)
    local ctl=rec.t:AddToggle(nextId("Tg"),{Title=title,Description=desc,
        Default=default and true or false,Callback=guarded(title,onChange)})
    track(rec,title,desc); return ctl
end
local function addSlider(rec,title,desc,min,max,default,step,onChange)
    local ctl=rec.t:AddSlider(nextId("Sl"),{Title=title,Description=desc,
        Default=math.clamp(default,min,max),Min=min,Max=max,Rounding=decimalsOf(step),
        Callback=guarded(title,onChange)})
    track(rec,title,desc); return ctl
end
local function addButton(rec,title,desc,onClick)
    local ctl=rec.t:AddButton({Title=title,Description=desc,Callback=guarded(title,onClick)})
    track(rec,title,desc); return ctl
end
local function addDropdown(rec,title,desc,values,default,onChange)
    local ctl=rec.t:AddDropdown(nextId("Dd"),{Title=title,Description=desc,Values=values,Multi=false,
        Default=table.find(values,default) or 1})
    ctl:OnChanged(guarded(title,function(v) if UI.building then return end; onChange(v) end))
    track(rec,title,desc); return ctl
end
local function addInput(rec,title,desc,default,placeholder,onFinished)
    local ctl=rec.t:AddInput(nextId("In"),{Title=title,Description=desc,Default=default,
        Placeholder=placeholder,Numeric=false,Finished=true,
        Callback=guarded(title,function(v) if UI.building then return end; onFinished(v) end)})
    track(rec,title,desc); return ctl
end
local function addParagraph(rec,title,content)
    local ok,ctl=pcall(function() return rec.t:AddParagraph({Title=title,Content=content}) end)
    return ok and ctl or nil
end
local lastPara=setmetatable({},{__mode="k"})
local function setParaDesc(p,text)
    if not p or lastPara[p]==text then return end
    lastPara[p]=text
    if not pcall(function() p:SetDesc(text) end) then pcall(function() p:SetValue(text) end) end
end

--========== Window extras ==========--
local function layerBackdrop(z)
    for _,o in ipairs({UI.backdrop,UI.art,UI.shade,UI.fx}) do if o then o.ZIndex=z end end
    if UI.art then for _,d in ipairs(UI.art:GetDescendants()) do if d:IsA("GuiObject") then d.ZIndex=z end end end
    if UI.fx then for _,c in ipairs(UI.fx:GetChildren()) do c.ZIndex=z end end
end

local function buildBackdrop(root)
    UI.designItems={}; UI.designAccent={}
    local acc=themeField(UI.currentTheme or Config.Brand.DefaultTheme,"Accent",Color3.fromRGB(255,128,20))
    local holder=create("Frame",{Name="OpiumBackdrop",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        ClipsDescendants=true,ZIndex=0,Parent=root})
    round(holder,UDim.new(0,8))
    local shade=create("Frame",{Name="Shade",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.35,BorderSizePixel=0,ZIndex=0,Parent=holder})
    create("UIGradient",{Rotation=0,Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.15),NumberSequenceKeypoint.new(0.45,0.55),NumberSequenceKeypoint.new(1,0.9)}),Parent=shade})
    local design=create("Frame",{Name="Design",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=0,Parent=holder})

    local function reg(obj,prop,base)
        obj[prop]=base; UI.designItems[#UI.designItems+1]={obj=obj,prop=prop,base=base}; return obj
    end
    local function circle(size,px,py,color,base,isAccent)
        local f=create("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(px,py),
            Size=UDim2.fromOffset(size,size),BackgroundColor3=color,BorderSizePixel=0,Parent=design})
        round(f,UDim.new(1,0)); reg(f,"BackgroundTransparency",base)
        if isAccent then UI.designAccent[#UI.designAccent+1]=f end
        return f
    end
    local function emoji(text,size,px,py,rot,base)
        local l=create("TextLabel",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.fromScale(px,py),Size=UDim2.fromOffset(size*1.4,size*1.4),Font=Enum.Font.GothamBold,
            TextSize=size,Text=text,TextColor3=Color3.new(1,1,1),Rotation=rot,Parent=design})
        reg(l,"TextTransparency",base); return l
    end
    local function bob(obj,dy,dur)
        local p=obj.Position
        TweenService:Create(obj,TweenInfo.new(dur,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
            {Position=UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset+dy)}):Play()
    end

    local wash=create("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=acc,BorderSizePixel=0,Parent=design})
    create("UIGradient",{Rotation=35,Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.55,0.7),NumberSequenceKeypoint.new(1,0)}),Parent=wash})
    reg(wash,"BackgroundTransparency",0.45); UI.designAccent[#UI.designAccent+1]=wash

    circle(150,0.8,0.2,Color3.fromRGB(255,170,70),0.9,false)
    circle(104,0.8,0.2,Color3.fromRGB(255,196,110),0.78,false)
    local orbBig=circle(300,0.88,0.9,acc,0.9,true)
    local orbMid=circle(180,0.88,0.9,acc,0.82,true)
    circle(210,0.1,0.04,Color3.fromRGB(255,160,50),0.93,false)
    TweenService:Create(orbBig,TweenInfo.new(3.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
        {Size=UDim2.fromOffset(340,340)}):Play()
    TweenService:Create(orbMid,TweenInfo.new(2.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
        {Size=UDim2.fromOffset(205,205)}):Play()

    circle(460,0.2,1.22,Color3.fromRGB(8,3,1),0.35,false)
    circle(560,0.78,1.3,Color3.fromRGB(8,3,1),0.4,false)

    local pumpkin=emoji("🎃",132,0.9,0.84,-8,0.55)
    TweenService:Create(pumpkin,TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Rotation=6}):Play()
    emoji("🕸️",124,0.985,0.07,0,0.7)
    bob(emoji("🦇",30,0.46,0.2,-10,0.5),10,2.2)
    bob(emoji("🦇",22,0.63,0.36,12,0.55),8,1.8)
    bob(emoji("🦇",26,0.32,0.56,-6,0.55),9,2.6)
    bob(emoji("👻",30,0.55,0.84,0,0.6),8,3.1)
    emoji("🕯️",26,0.7,0.92,0,0.6)
    emoji("🍬",20,0.4,0.9,15,0.6)

    local strip=create("Frame",{Size=UDim2.new(1,0,0,3),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=design})
    create("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,110,10)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,200,60)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,110,10))}),Parent=strip})
    reg(strip,"BackgroundTransparency",0.15)
    local garland=create("TextLabel",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,1),
        Position=UDim2.new(0.5,0,1,-2),Size=UDim2.new(1,0,0,22),Font=Enum.Font.GothamBold,TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Center,TextColor3=Color3.new(1,1,1),
        Text=string.rep("🎃  🦇  🕯️  👻  🍬  ",5),Parent=design})
    reg(garland,"TextTransparency",0.55)

    local fx=create("Frame",{Name="FX",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=0,Parent=holder})
    UI.backdrop,UI.art,UI.shade,UI.fx=holder,design,shade,fx
end

local function setBackdropVisibility(pct)
    Config.Brand.BackgroundVisibility=pct/100
    local k=UI.bgEnabled and (pct/50) or 0
    for _,d in ipairs(UI.designItems or {}) do
        if d.obj and d.obj.Parent then
            local t=math.clamp(1-(1-d.base)*k,0,1)
            TweenService:Create(d.obj,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{[d.prop]=t}):Play()
        end
    end
end

local FX_SPRITES={"🎃","🦇","👻","🕸️","🍬","🕯️"}
local function stopFX()
    UI.fxEnabled=false; UI.fxToken=UI.fxToken+1
    if UI.fx then for _,c in ipairs(UI.fx:GetChildren()) do pcall(function() c:Destroy() end) end end
end
local function startFX()
    UI.fxEnabled=true; UI.fxToken=UI.fxToken+1
    local tk=UI.fxToken
    task.spawn(function()
        local rng=Random.new()
        local first=true
        while UI.fxEnabled and UI.fxToken==tk and not Cleaning do
            local fx=UI.fx
            if fx and fx.Parent and #fx:GetChildren()<14 then
                local startX=rng:NextNumber(0.02,0.96)
                local s=create("TextLabel",{BackgroundTransparency=1,
                    Text=FX_SPRITES[rng:NextInteger(1,#FX_SPRITES)],TextSize=rng:NextInteger(16,26),
                    TextTransparency=0.45,Size=UDim2.fromOffset(30,30),
                    Position=UDim2.new(startX,0,first and 0.55 or 1.05,0),
                    Rotation=rng:NextInteger(-20,20),ZIndex=fx.ZIndex,Parent=fx})
                local tw=TweenService:Create(s,TweenInfo.new(rng:NextNumber(6,10),Enum.EasingStyle.Sine),{
                    Position=UDim2.new(startX+rng:NextNumber(-0.08,0.08),0,-0.12,0),
                    Rotation=s.Rotation+rng:NextInteger(-40,40),TextTransparency=1})
                tw.Completed:Connect(function() pcall(function() s:Destroy() end) end)
                tw:Play()
                first=false
            end
            task.wait(first and 0 or rng:NextNumber(0.7,1.4))
        end
    end)
end

local function buildGlow(root)
    if UI.glowEnabled==nil then UI.glowEnabled=true end
    local acc=themeField(UI.currentTheme or Config.Brand.DefaultTheme,"Accent",Color3.fromRGB(255,176,46))
    UI.glowStroke=create("UIStroke",{Name="OpiumGlow",Color=acc,Thickness=1.5,Transparency=0.75,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=root})
    local sheen=create("Frame",{Name="OpiumSheen",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0,ClipsDescendants=true,ZIndex=30,Visible=false,Parent=root})
    round(sheen,UDim.new(0,8))
    UI.sheenGrad=create("UIGradient",{Rotation=20,Offset=Vector2.new(-1.3,0),
        Color=ColorSequence.new(acc,Color3.new(1,1,1)),
        Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.42,1),
            NumberSequenceKeypoint.new(0.5,0.82),NumberSequenceKeypoint.new(0.58,1),NumberSequenceKeypoint.new(1,1)}),
        Parent=sheen})
    UI.sheen=sheen
    task.spawn(function()
        local t=0
        while not Cleaning and UI.glowStroke and UI.glowStroke.Parent do
            t=t+task.wait(0.05)
            if not UI.flashing then
                if UI.glowEnabled then
                    local k=(math.sin(t*1.6)+1)/2
                    UI.glowStroke.Transparency=0.82-0.38*k
                    UI.glowStroke.Thickness=1.5+1.0*k
                else
                    UI.glowStroke.Transparency=1
                end
            end
        end
    end)
end

local function playGlowBurst()
    if not UI.glowEnabled or not UI.glowStroke or not UI.glowStroke.Parent then return end
    UI.flashing=true
    local gs=UI.glowStroke
    gs.Transparency=0.05; gs.Thickness=5
    TweenService:Create(gs,TweenInfo.new(0.9,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {Thickness=1.5,Transparency=0.6}):Play()
    if UI.sheen and UI.sheenGrad then
        UI.sheen.Visible=true; UI.sheenGrad.Offset=Vector2.new(-1.3,0)
        local tw=TweenService:Create(UI.sheenGrad,TweenInfo.new(0.8,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),
            {Offset=Vector2.new(1.3,0)})
        tw.Completed:Connect(function() if UI.sheen then UI.sheen.Visible=false end end)
        tw:Play()
    end
    task.delay(0.95,function() UI.flashing=false end)
end

local SLIDE_OFFSETS={Left=Vector2.new(-110,0),Right=Vector2.new(110,0),Top=Vector2.new(0,-80),Bottom=Vector2.new(0,80)}
local function slideDelta()
    local o=SLIDE_OFFSETS[UI.slideDir or Config.Brand.SlideDirection] or SLIDE_OFFSETS.Left
    return UDim2.fromOffset(o.X,o.Y)
end

local function hookAnimation(root)
    UI.slideDir=UI.slideDir or Config.Brand.SlideDirection
    local scale=create("UIScale",{Scale=1,Parent=root}); UI.scale=scale
    UI.sliding=false
    local function slideIn()
        if Cleaning or not root.Parent then return end
        local target=UI.shownPos or root.Position
        UI.shownPos=target
        if UI.animated == false then root.Position=target; scale.Scale=1; return end
        UI.sliding=true
        root.Position=target+slideDelta(); scale.Scale=0.94
        TweenService:Create(root,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=target}):Play()
        TweenService:Create(scale,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
        task.delay(0.52,function() UI.sliding=false end)
        playGlowBurst()
    end
    BootMaid:Give(root:GetPropertyChangedSignal("Visible"):Connect(function() if root.Visible then slideIn() end end))
    local rawMinimize=Window.Minimize
    if type(rawMinimize)=="function" then
        pcall(function()
            Window.Minimize=function(self,...)
                if Cleaning or not root.Parent then return rawMinimize(self,...) end
                if UI.sliding then return end
                if root.Visible and UI.animated then
                    UI.sliding=true
                    local home=root.Position; UI.shownPos=home
                    local tw=TweenService:Create(root,TweenInfo.new(0.32,Enum.EasingStyle.Quint,Enum.EasingDirection.In),
                        {Position=home+slideDelta()})
                    TweenService:Create(scale,TweenInfo.new(0.32,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Scale=0.94}):Play()
                    tw:Play(); tw.Completed:Wait()
                    local r=rawMinimize(self,...)
                    if root.Parent then root.Position=home; scale.Scale=1 end
                    UI.sliding=false
                    return r
                end
                return rawMinimize(self,...)
            end
        end)
    end
end

--========== Player card ==========--
local function buildPlayerCard(root,tabWidth)
    local acc=themeField(UI.currentTheme or Config.Brand.DefaultTheme,"Accent",Color3.fromRGB(255,176,46))
    local card=create("Frame",{Name="OpiumPlayerCard",AnchorPoint=Vector2.new(0,1),
        Position=UDim2.new(0,14,1,-12),Size=UDim2.fromOffset(tabWidth-18,52),BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.45,BorderSizePixel=0,ZIndex=20,Parent=root})
    round(card,UDim.new(0,8))
    UI.cardStroke=create("UIStroke",{Color=acc,Thickness=1.5,Transparency=0.25,Parent=card})
    local avatar=create("ImageLabel",{Position=UDim2.fromOffset(8,8),Size=UDim2.fromOffset(36,36),
        BackgroundColor3=acc,BorderSizePixel=0,Image="",ZIndex=21,Parent=card})
    round(avatar,UDim.new(1,0))
    local dot=create("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,1,1,1),Size=UDim2.fromOffset(11,11),
        BackgroundColor3=ROLE_COLORS.Innocent,BorderSizePixel=0,ZIndex=23,Parent=avatar})
    round(dot,UDim.new(1,0))
    create("UIStroke",{Color=Color3.fromRGB(20,14,8),Thickness=2,Parent=dot})
    task.spawn(function()
        local ok,img=pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
        end)
        if ok and avatar.Parent then avatar.Image=img end
    end)
    local function label(y,size,font,color,text)
        return create("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(52,y),
            Size=UDim2.new(1,-58,0,16),Font=font,TextSize=size,TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,TextColor3=color,Text=text,ZIndex=21,Parent=card})
    end
    local nameL=label(9,13,Enum.Font.GothamBold,Color3.fromRGB(245,245,245),LocalPlayer.DisplayName)
    local userL=label(26,11,Enum.Font.Gotham,Color3.fromRGB(205,205,205),"@"..LocalPlayer.Name)
    UI.card=card
    task.spawn(function()
        while not Cleaning and card.Parent do
            local role=RoleESP.resolveRole(LocalPlayer)
            dot.BackgroundColor3=ROLE_COLORS[role] or Color3.fromRGB(120,120,120)
            nameL.Text=LocalPlayer.DisplayName; userL.Text="@"..LocalPlayer.Name
            task.wait(0.5)
        end
    end)
end

--========== Floating orb ==========--
local function toggleWindow() pcall(function() Window:Minimize() end) end
local function buildOrb()
    if UI.orbGui and UI.orbGui.Parent then return end
    local gui=create("ScreenGui",{Name="OpiumToggle",ResetOnSpawn=false,DisplayOrder=200,IgnoreGuiInset=true})
    if not mountGui(gui) then gui:Destroy(); return end
    UI.orbGui=gui
    local acc=themeField(UI.currentTheme or Config.Brand.DefaultTheme,"Accent",Color3.fromRGB(255,176,46))
    local btn=create("TextButton",{Size=UDim2.fromOffset(44,44),Position=UDim2.new(0,16,0.5,0),
        BackgroundColor3=Color3.fromRGB(16,12,22),BorderSizePixel=0,AutoButtonColor=true,Active=true,
        Font=Enum.Font.GothamBold,TextSize=22,TextColor3=Color3.new(1,1,1),Text="🎃",Parent=gui})
    round(btn,UDim.new(1,0))
    UI.orbStroke=create("UIStroke",{Color=acc,Thickness=2,Transparency=0.1,Parent=btn})
    local moved=false
    pcall(function()
        local drag=Instance.new("UIDragDetector"); drag.Parent=btn
        drag.DragStart:Connect(function() moved=false end)
        drag.DragContinue:Connect(function() moved=true end)
    end)
    btn.MouseButton1Click:Connect(function()
        if moved then moved=false; return end
        toggleWindow()
    end)
end

--========== Cleanup ==========--
local Handle={}
local Cleanup
local function stopAllFeatures()
    Farm.SetEnabled(false); Flight.SetEnabled(false)
    Noclip.SetUserEnabled(false); WalkSpeed.SetEnabled(false)
    ESP.SetEnabled(false); AntiAFK.SetEnabled(false)
    RoleESP.stopAll(); Aim.SetEnabled(false)
    for _,name in ipairs({"Farm","Flight","Noclip","WalkSpeed","ESP","AntiAFK","Aim"}) do
        local t=Controls[name]; if t then pcall(function() t:SetValue(false) end) end
    end
end
Cleanup=function()
    if Cleaning then return end
    Cleaning=true
    pcall(Farm.SetEnabled,false); pcall(Flight.SetEnabled,false)
    pcall(function() Noclip.userEnabled=false; Noclip.Disable() end)
    pcall(WalkSpeed.SetEnabled,false); pcall(ESP.Destroy)
    pcall(AntiAFK.SetEnabled,false); pcall(RoleESP.stopAll); pcall(Aim.Destroy)
    pcall(Scanner.Shutdown); Registry.Clear()
    UI.fxEnabled=false; UI.ready=false
    BootMaid:Clean(); RootMaid:Clean()
    if UI.orbGui then pcall(function() UI.orbGui:Destroy() end); UI.orbGui=nil end
    if UI.topGui then pcall(function() UI.topGui:Destroy() end); UI.topGui=nil; UI.topBar=nil end
    if env.MM2CandyFarm==Handle then env.MM2CandyFarm=nil end
    local f=Fluent; Window=nil
    if f then pcall(function() f:Destroy() end) end
end
Handle.Cleanup=Cleanup

--========== Top bar ==========--
local function setTopBar(show)
    local bar=UI.topBar
    if not bar or not bar.Parent then return end
    if show and UI.topEnabled==false then show=false end
    if show==UI.topShown then return end
    UI.topShown=show
    local shownPos=UDim2.new(0.5,0,0,8); local hiddenPos=UDim2.new(0.5,0,0,-64)
    if not UI.animated then bar.Position=show and shownPos or hiddenPos; bar.Visible=show; return end
    if show then
        bar.Visible=true; bar.Position=hiddenPos
        if UI.topStroke and UI.glowEnabled~=false then
            UI.topStroke.Thickness=4
            TweenService:Create(UI.topStroke,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Thickness=1.5}):Play()
        end
        TweenService:Create(bar,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=shownPos}):Play()
    else
        TweenService:Create(bar,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=hiddenPos}):Play()
        task.delay(0.32,function() if not UI.topShown and bar.Parent then bar.Visible=false end end)
    end
end

local function buildTopBar()
    local gui=create("ScreenGui",{Name="OpiumTopBar",ResetOnSpawn=false,DisplayOrder=190,
        IgnoreGuiInset=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    if not mountGui(gui) then gui:Destroy(); return end
    UI.topGui=gui
    local acc=themeField(UI.currentTheme or Config.Brand.DefaultTheme,"Accent",Color3.fromRGB(255,176,46))
    local cream=Color3.fromRGB(255,238,206)
    local cam=Workspace.CurrentCamera
    local vpx=cam and cam.ViewportSize.X or 1280
    local bar=create("Frame",{Name="Bar",AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,-64),
        Size=UDim2.fromOffset(math.min(410,vpx-20),40),BackgroundColor3=Color3.fromRGB(18,11,5),
        BackgroundTransparency=0.12,BorderSizePixel=0,Visible=false,Parent=gui})
    round(bar,UDim.new(1,0))
    UI.topStroke=create("UIStroke",{Color=acc,Thickness=1.5,Transparency=0.1,Parent=bar})
    create("UIGradient",{Rotation=0,Color=ColorSequence.new(Color3.fromRGB(40,23,9),Color3.fromRGB(14,9,5)),Parent=bar})
    create("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.fromOffset(26,40),
        Font=Enum.Font.GothamBold,TextSize=18,TextColor3=Color3.new(1,1,1),Text="🎃",Parent=bar})
    create("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(42,4),Size=UDim2.fromOffset(190,16),
        Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=cream,
        Text="Opiumware  |  MM2",Parent=bar})
    local statusL=create("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(42,20),
        Size=UDim2.fromOffset(190,15),Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd,TextColor3=Color3.fromRGB(245,166,48),Text="Window hidden",Parent=bar})
    local farmBtn=create("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-92,0.5,0),
        Size=UDim2.fromOffset(76,26),BackgroundColor3=Color3.fromRGB(30,20,10),AutoButtonColor=true,BorderSizePixel=0,
        Font=Enum.Font.GothamBold,TextSize=11,TextColor3=cream,Text="Farm: OFF",Parent=bar})
    round(farmBtn,UDim.new(1,0))
    create("UIStroke",{Color=acc,Thickness=1,Transparency=0.35,Parent=farmBtn})
    local openBtn=create("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.5,0),
        Size=UDim2.fromOffset(76,26),BackgroundColor3=acc,AutoButtonColor=true,BorderSizePixel=0,
        Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(26,14,4),Text="Open",Parent=bar})
    round(openBtn,UDim.new(1,0))
    UI.topOpen=openBtn; UI.topBar=bar
    openBtn.MouseButton1Click:Connect(function() toggleWindow() end)
    farmBtn.MouseButton1Click:Connect(function()
        local want=not Farm.enabled
        if Controls.Farm then pcall(function() Controls.Farm:SetValue(want) end) end
        if Farm.enabled~=want then Farm.SetEnabled(want) end
    end)
    task.spawn(function()
        while not Cleaning and bar.Parent do
            if UI.topShown then
                local role=RoleESP.resolveRole(LocalPlayer)
                statusL.Text=string.format("%s  |  %d candies  |  %s",role,Farm.collected,Farm.enabled and Farm.status or "Farm off")
                farmBtn.Text=Farm.enabled and "Farm: ON" or "Farm: OFF"
                farmBtn.BackgroundColor3=Farm.enabled and Color3.fromRGB(70,46,12) or Color3.fromRGB(30,20,10)
            end
            task.wait(0.5)
        end
    end)
    if UI.root then
        BootMaid:Give(UI.root:GetPropertyChangedSignal("Visible"):Connect(function() setTopBar(not UI.root.Visible) end))
    end
end

local function hookCloseDialog()
    local raw=Window.Dialog
    if type(raw)~="function" then return end
    pcall(function()
        Window.Dialog=function(self,cfg,...)
            if type(cfg)=="table" and not Cleaning then
                local blob=string.lower(tostring(cfg.Title or "").." "..tostring(cfg.Content or ""))
                if string.find(blob,"unload",1,true) or string.find(blob,"close",1,true) then
                    cfg={Title="Close window",
                        Content="Hide it to the top bar (reopen any time), or unload the script completely?",
                        Buttons={
                            {Title="Hide to top bar",Callback=function() task.defer(toggleWindow) end},
                            {Title="Unload script",Callback=function() task.defer(Cleanup) end},
                            {Title="Cancel",Callback=function() end},
                        }}
                end
            end
            return raw(self,cfg,...)
        end
    end)
end

--========== farmSync ==========--
local function farmSync()
    Config.Farm.FarmSpeed    = math.clamp(Config.Farm.FarmSpeed, 30, 150)
    Config.Farm.AvoidRadius  = math.clamp(Config.Farm.AvoidRadius, 5, 80)
    Config.Farm.ArriveRadius = math.clamp(Config.Farm.ArriveRadius, 3.5, 15)
    Config.Farm.TargetTimeout= math.clamp(Config.Farm.TargetTimeout, 4, 60)
    Config.Farm.SkipSeconds  = math.clamp(Config.Farm.SkipSeconds, 5, 300)
    if Farm.enabled then
        Flight.SetSpeed(Config.Farm.FarmSpeed)
        if Farm.working then Flight.prone = Config.Farm.LieDown end
    end
end

--========== Tab builders ==========--
local function buildFarmTab(rec)
    addSearchBox(rec)
    header(rec,"Candy statistics")
    local statRound=addParagraph(rec,"Halloween 2026","Live values will appear here")
    local statCandy=addParagraph(rec,"Candy collected","Live values will appear here")
    task.spawn(function()
        while not Cleaning do
            if Farm.enabled then
                setParaDesc(statRound,string.format("Status: %s   |   Role: %s   |   Live candies: %d",
                    Farm.status,RoleESP.resolveRole(LocalPlayer),Registry.liveCount))
                setParaDesc(statCandy,string.format("Session: %d   |   This round: %d   |   Bag: %d/%d",
                    Farm.collected,Farm.roundCollected,Bag.cur,Bag.max))
            else
                setParaDesc(statRound,"Live values will appear here")
                setParaDesc(statCandy,Farm.collected>0 and ("Session total: "..Farm.collected) or "Live values will appear here")
            end
            task.wait(0.5)
        end
    end)
    header(rec,"Candy farm")
    Controls.Farm=addToggle(rec,"🍬 Collect candies",
        "Only runs while you are alive in a round. Lies low and fast, resets safely when the bag is full.",
        false,function(state) Farm.SetEnabled(state) end)
    local statusBtn
    statusBtn=addButton(rec,"Farm Status","Disabled",function()
        notify("Farm status",string.format(
            "Status: %s\nLive candies tracked: %d\nPickups observed consumed: %d\n(Inferred - not game-confirmed.)",
            Farm.status,Registry.liveCount,Farm.collected))
    end)
    Farm.onStatus=function(status) pcall(function() statusBtn:SetDesc(status) end) end
    header(rec,"Collection settings")
    addSlider(rec,"Arrival Radius","Distance that counts as reaching a pickup.",
        3.5,15,Config.Farm.ArriveRadius,0.5,function(v) Config.Farm.ArriveRadius=v; farmSync() end)
    addSlider(rec,"Per-Target Timeout","Seconds before giving up.",
        4,60,Config.Farm.TargetTimeout,1,function(v) Config.Farm.TargetTimeout=v; farmSync() end)
    addSlider(rec,"Skip Duration","Seconds a failed pickup is ignored.",
        5,300,Config.Farm.SkipSeconds,5,function(v) Config.Farm.SkipSeconds=v; farmSync() end)
    addToggle(rec,"Only Farm During a Round","Farm only while you are alive and inside a running round.",
        Config.Farm.OnlyInRound,function(v) Config.Farm.OnlyInRound=v end)
    addToggle(rec,"Reset When Bag Full","Safely resets via the game's own ResetCharacter remote. Never uses BreakJoints.",
        Config.Farm.ResetWhenFull,function(v) Config.Farm.ResetWhenFull=v end)
    addSlider(rec,"Reset After N Candies","Backup trigger if bag detection fails (0 = off).",
        0,100,Config.Farm.ResetAfter,1,function(v) Config.Farm.ResetAfter=v end)
    addToggle(rec,"Lie Down While Farming","Keeps your character flat and low while farming.",
        Config.Farm.LieDown,function(v) Config.Farm.LieDown=v; farmSync() end)
    addSlider(rec,"Farm Speed","Flight speed while farming (studs/sec).",
        30,150,Config.Farm.FarmSpeed,5,function(v) Config.Farm.FarmSpeed=v; farmSync() end)
    addSlider(rec,"Coin Delay","Base pause after each collected candy (0 = off).",
        0,3,Config.Farm.CoinDelay,0.05,function(v) Config.Farm.CoinDelay=v end)
    addSlider(rec,"Coin Delay Jitter","Random extra delay added on top (0 = fixed pause).",
        0,3,Config.Farm.CoinDelayJitter,0.05,function(v) Config.Farm.CoinDelayJitter=v end)
    addToggle(rec,"Avoid Murderer","Skips candies near a player holding a knife.",
        Config.Farm.AvoidMurderer,function(v) Config.Farm.AvoidMurderer=v end)
    addSlider(rec,"Avoid Radius","How close the murderer may get before a candy is skipped.",
        10,80,Config.Farm.AvoidRadius,1,function(v) Config.Farm.AvoidRadius=v; farmSync() end)
end

local function buildVisualsTab(rec)
    addSearchBox(rec)
    header(rec,"Candy Highlights")
    Controls.ESP=addToggle(rec,"🎃 Candy ESP","Highlights each LIVE candy with its actual color.",
        false,function(state) ESP.SetEnabled(state) end)
    addButton(rec,"Refresh Markers","Re-scan highlights now.",function()
        if ESP.enabled then Registry.Reconcile(); ESP.Refresh()
        else notify("Candy ESP","Enable Candy ESP first.") end
    end)
    header(rec,"ESP Style")
    addSlider(rec,"Outline Opacity","0=invisible, 100=fully opaque.",
        0,100,math.floor((1-Config.ESP.Transparency)*100+0.5),1,
        function(v) Config.ESP.Transparency=1-v/100; ESP.ApplyAll() end)
    addSlider(rec,"ESP Max Distance","Candies farther are not highlighted.",
        50,1000,Config.ESP.MaxDistance,10,
        function(v) Config.ESP.MaxDistance=v; ESP.ApplyAll() end)
    addSlider(rec,"Update Interval","Seconds between refreshes.",
        0.1,1,Config.ESP.UpdateInterval,0.05,function(v) Config.ESP.UpdateInterval=v end)
    header(rec,"Role ESP (equipped weapon)")
    addParagraph(rec,"How this works",
        "Red = player has a Knife equipped. Blue = player has a Gun/Revolver equipped. "
        .."Green = no weapon. Only works while the weapon is drawn (not holstered). "
        .."An innocent who picks up a dropped knife will show Red.")
    addToggle(rec,"🔪 Murderer ESP (Knife = Red)","Reds any player holding a Knife",
        false,function(v) RoleESP.setRole("Murderer",v) end)
    addToggle(rec,"🔫 Sheriff ESP (Gun = Blue)","Blues any player holding a Gun/Revolver",
        false,function(v) RoleESP.setRole("Sheriff",v) end)
    addToggle(rec,"🙂 Innocent ESP (no weapon = Green)","Greens any player with no weapon equipped",
        false,function(v) RoleESP.setRole("Innocent",v) end)
end

local function buildAimTab(rec)
    addSearchBox(rec)
    header(rec,"Master Switch")
    Controls.Aim=addToggle(rec,"🎯 Aimbot",
        "Master switch. Only acts when you hold a Gun (Sheriff) or Knife (Murderer).",
        false,function(state) Aim.SetEnabled(state) end)
    header(rec,"Sheriff (Gun)")
    addToggle(rec,"Lock Onto Murderer","Aims only at the murderer, once someone has been seen holding a knife.",
        Config.Aim.SheriffLock,function(v) Config.Aim.SheriffLock=v end)
    addToggle(rec,"Auto Shoot Murderer","Fires automatically when the murderer is found, in range and visible.",
        Config.Aim.AutoShoot,function(v) Config.Aim.AutoShoot=v end)
    addButton(rec,"Shoot Murderer","Aim and fire once at the murderer.",function() Aim.ManualAction() end)
    header(rec,"Murderer (Knife)")
    addToggle(rec,"Lock Onto Nearest Player","Aims at the nearest visible Innocent or Sheriff.",
        Config.Aim.MurdererLock,function(v) Config.Aim.MurdererLock=v end)
    addToggle(rec,"Auto Throw Knife","Throws automatically at the nearest visible player.",
        Config.Aim.AutoThrow,function(v) Config.Aim.AutoThrow=v end)
    addButton(rec,"Throw Knife","Aim and throw once at the nearest player.",function() Aim.ManualAction() end)
    header(rec,"Aim Tuning")
    addSlider(rec,"Lock Smoothness","Higher = snappier camera lock (%).",
        5,100,math.floor(Config.Aim.Smooth*100+0.5),1,function(v) Config.Aim.Smooth=v/100 end)
    addSlider(rec,"Max Distance","Ignore targets farther than this (studs).",
        30,400,Config.Aim.MaxDistance,5,function(v) Config.Aim.MaxDistance=v end)
    addSlider(rec,"Auto Cooldown","Seconds between automatic shots/throws.",
        0.5,5,Config.Aim.Cooldown,0.1,function(v) Config.Aim.Cooldown=v end)
    addToggle(rec,"Prediction","Leads moving targets.",Config.Aim.Prediction,function(v) Config.Aim.Prediction=v end)
    addToggle(rec,"Require Line of Sight","Ignore targets behind walls.",Config.Aim.RequireLOS,function(v) Config.Aim.RequireLOS=v end)
    addToggle(rec,"Show On-screen Button","Small draggable SHOOT / THROW button while you hold a Gun or Knife.",
        Config.Aim.ShowButton,function(v) Config.Aim.ShowButton=v; Aim.RefreshButton() end)
end

local function buildMovementTab(rec)
    addSearchBox(rec)
    header(rec,"Flight Controls")
    Controls.Flight=addToggle(rec,"🦇 Flight","WASD / thumbstick to fly. Space/E=up, Shift/Q=down.",
        false,function(state) Flight.SetEnabled(state) end)
    addSlider(rec,"Flight Speed","Studs per second.",
        Config.Flight.MinSpeed,Config.Flight.MaxSpeed,Config.Flight.DefaultSpeed,1,
        function(v) Flight.SetSpeed(v) end)
    header(rec,"Noclip Controls")
    Controls.Noclip=addToggle(rec,"👻 Noclip","Turns off character collisions; restored when disabled.",
        false,function(state) Noclip.SetUserEnabled(state) end)
    Controls.AutoNoclip=addToggle(rec,"Auto Noclip While Farming","Also enables noclip automatically while Auto Farm is on.",
        Noclip.autoWhileFarming,function(state) Noclip.SetAutoWhileFarming(state) end)
    header(rec,"Walk Speed Controls")
    Controls.WalkSpeed=addToggle(rec,"🕷 Custom Walk Speed","Off restores normal speed. Flight ignores walk speed.",
        false,function(state) WalkSpeed.SetEnabled(state) end)
    addSlider(rec,"Walk Speed","0 - 100 (0 stops walking).",
        Config.WalkSpeed.Min,Config.WalkSpeed.Max,Config.WalkSpeed.Default,1,
        function(v) WalkSpeed.SetValue(v) end)
end

local function buildAppearanceTab(rec)
    addSearchBox(rec)
    header(rec,"Look & Feel")
    Controls.Theme=addDropdown(rec,"Color Theme","Amethyst (default), Amberglow, Halloween 2026 and more.",
        UI.themeNames,UI.currentTheme or Config.Brand.DefaultTheme,function(v) applyTheme(v) end)
    addButton(rec,"Preset: Amethyst","Amethyst theme with the backdrop art on.",function()
        if Controls.Theme then pcall(function() Controls.Theme:SetValue("Amethyst") end) end
        applyTheme("Amethyst")
        if Controls.BgOn then pcall(function() Controls.BgOn:SetValue(true) end) end
        if Controls.BgVis then pcall(function() Controls.BgVis:SetValue(50) end) end
        if Controls.BgFront then pcall(function() Controls.BgFront:SetValue(true) end) end
    end)
    addButton(rec,"Preset: Halloween 2026","Halloween theme + floating pumpkins + backdrop.",function()
        if Controls.Theme then pcall(function() Controls.Theme:SetValue("Halloween 2026") end) end
        applyTheme("Halloween 2026")
        if Controls.Fx then pcall(function() Controls.Fx:SetValue(true) end) end
        if Controls.BgOn then pcall(function() Controls.BgOn:SetValue(true) end) end
        if Controls.BgVis then pcall(function() Controls.BgVis:SetValue(50) end) end
        if Controls.BgFront then pcall(function() Controls.BgFront:SetValue(true) end) end
    end)
    addButton(rec,"Preset: Amberglow","Warm amber glass, no particles.",function()
        if Controls.Theme then pcall(function() Controls.Theme:SetValue("Amberglow") end) end
        applyTheme("Amberglow")
        if Controls.Fx then pcall(function() Controls.Fx:SetValue(false) end) end
    end)
    header(rec,"Glass & Motion")
    Controls.Acrylic=addToggle(rec,"Acrylic Blur","Frosted-glass blur behind the window.",true,function(v)
        if UI.building then return end
        pcall(function() Fluent:ToggleAcrylic(v) end)
    end)
    Controls.Transparency=addToggle(rec,"Window Transparency","See-through window surfaces.",true,function(v)
        if UI.building then return end
        pcall(function() Fluent:ToggleTransparency(v) end)
    end)
    Controls.Anim=addToggle(rec,"Animated Window","Slide + pop animation whenever the window opens or hides.",true,function(v)
        UI.animated=v
    end)
    Controls.Glow=addToggle(rec,"Window Glow","Pulsing glow border, plus a light sweep and flash when the window slides in.",true,function(v)
        UI.glowEnabled=v
    end)
    Controls.SlideDir=addDropdown(rec,"Slide Direction","Where the window slides in from.",
        {"Left","Right","Top","Bottom"},UI.slideDir or Config.Brand.SlideDirection,function(v) UI.slideDir=v end)
    header(rec,"Backdrop")
    Controls.BgOn=addToggle(rec,"Halloween Design","Pumpkin, harvest moon, bats and web drawn behind the UI (no image needed).",true,function(v)
        UI.bgEnabled=v; setBackdropVisibility(Config.Brand.BackgroundVisibility*100)
    end)
    Controls.BgVis=addSlider(rec,"Design Visibility","How strong the Halloween artwork is (%).",
        0,100,math.floor(Config.Brand.BackgroundVisibility*100+0.5),1,
        function(v) setBackdropVisibility(v) end)
    Controls.Fx=addToggle(rec,"Halloween Particles","Floating pumpkins, bats and ghosts.",true,function(v)
        if v then startFX() else stopFX() end
    end)
    header(rec,"Closed State")
    Controls.TopBar=addToggle(rec,"Top Bar When Closed",
        "Slide-down bar with Open / Farm buttons while the window is hidden.",true,function(v)
            UI.topEnabled=v
            if not v then setTopBar(false)
            elseif UI.root and not UI.root.Visible then setTopBar(true) end
        end)
    Controls.Orb=addToggle(rec,"Floating Button","Draggable pumpkin button that shows / hides the window.",true,function(v)
        if v then buildOrb()
        elseif UI.orbGui then pcall(function() UI.orbGui:Destroy() end); UI.orbGui=nil end
    end)
    -- Backdrop Over Glass is ON at inject
    Controls.BgFront=addToggle(rec,"Backdrop Over Glass","Draw artwork above the acrylic layer if it looks hidden.",
        Config.Brand.DefaultBackdropOverGlass,function(v)
            UI.bgFront=v; layerBackdrop(v and 2 or 0)
        end)
end

local function buildProfileTab(rec)
    header(rec,"Player Card")
    UI.profilePara=addParagraph(rec,LocalPlayer.DisplayName,"Loading...")
    addButton(rec,"Copy Username","Copies your @username to the clipboard.",function()
        if setclipboard then pcall(setclipboard,LocalPlayer.Name); notify("Profile","Username copied.")
        else notify("Profile","Clipboard not supported by this executor.") end
    end)
    addButton(rec,"Copy UserId","Copies your UserId to the clipboard.",function()
        if setclipboard then pcall(setclipboard,tostring(LocalPlayer.UserId)); notify("Profile","UserId copied.")
        else notify("Profile","Clipboard not supported by this executor.") end
    end)
    task.spawn(function()
        while not Cleaning and UI.profilePara do
            local role=RoleESP.resolveRole(LocalPlayer)
            local text=string.format(
                "@%s  |  UserId %d\nAccount age: %d days\nRole: %s\nCandies (inferred): %d\nFarm: %s\nLive candies tracked: %d\nPlayers in server: %d",
                LocalPlayer.Name,LocalPlayer.UserId,LocalPlayer.AccountAge,role,Farm.collected,
                Farm.status,Registry.liveCount,#Players:GetPlayers())
            local p=UI.profilePara
            if not pcall(function() p:SetDesc(text) end) then pcall(function() p:SetValue(text) end) end
            task.wait(1)
        end
    end)
end

local function buildSettingsTab(rec)
    addSearchBox(rec)
    header(rec,"Idle Protection")
    Controls.AntiAFK=addToggle(rec,"Anti-AFK","Sends a harmless input when Roblox reports you as idle.",
        false,function(state) AntiAFK.SetEnabled(state) end)
    header(rec,"Detection Tools")
    addInput(rec,"Name Keywords","Comma-separated. Matched against part name or parent name.",
        keywordsToString(Config.Keywords),"candy, coin",function(text)
            local list=parseKeywords(text)
            if #list==0 then notify("Detection","Keep at least one keyword."); return end
            Config.Keywords=list; Scanner.Reload()
        end)
    addSlider(rec,"Max Pickup Size","Ignore parts larger than this (studs).",
        1,20,Config.MaxPickupSize,1,function(v) Config.MaxPickupSize=v; Scanner.Reload() end)
    addToggle(rec,"Require TouchInterest","Stricter filter.",
        Config.RequireTouchInterest,function(v) Config.RequireTouchInterest=v; Scanner.Reload() end)
    addButton(rec,"Rescan Pickups","Clears registry; waits for next live spawn.",function()
        if Scanner.userCount>0 then Scanner.Reload(); notify("Detection","Waiting for next spawns...")
        else notify("Detection","Enable Auto Farm or Candy ESP first.") end
    end)
    addButton(rec,"Print Candidate Dump","Prints LIVE candidates to console (F9).",function()
        Scanner.Dump(); notify("Detection","Dump printed to console (F9).")
    end)
    header(rec,"Control")
    addButton(rec,"Stop All Features","Turns off all features.",function()
        stopAllFeatures(); notify("OpiumWare Hub","All features stopped.")
    end)
    addButton(rec,"Unload Script","Stops everything and closes the UI.",function() Cleanup() end)
end

--========== applyAppearanceDefaults ==========--
-- Full look on at inject:
--   * Amethyst theme
--   * Design visibility at 50%
--   * Backdrop Over Glass ON
--   * Particles, glow, slide-in, orb, top bar ON
local function applyAppearanceDefaults()
    if Cleaning then return end

    -- 1. State flags
    UI.animated    = true
    UI.glowEnabled = true
    UI.topEnabled  = true
    UI.bgEnabled   = true
    UI.bgFront     = true          -- Backdrop Over Glass ON
    UI.slideDir    = UI.slideDir or Config.Brand.SlideDirection

    -- 2. Theme = Amethyst (default), fallback if unavailable
    local wantTheme = Config.Brand.DefaultTheme or "Amethyst"
    if not table.find(UI.themeNames, wantTheme) then
        wantTheme = table.find(UI.themeNames, "Dark") and "Dark" or UI.themeNames[1]
    end
    if wantTheme then
        pcall(function() Fluent:SetTheme(wantTheme) end)
        applyTheme(wantTheme)
    end

    -- 3. Fluent window glass
    pcall(function() Fluent:ToggleAcrylic(true) end)
    pcall(function() Fluent:ToggleTransparency(true) end)

    -- 4. Backdrop Over Glass = ON (draw art above the acrylic layer)
    pcall(layerBackdrop, 2)

    -- 5. Design visibility = 50%
    pcall(setBackdropVisibility, Config.Brand.BackgroundVisibility * 100)

    -- 6. Particles
    if not UI.fxEnabled then pcall(startFX) end

    -- 7. Floating orb
    if not (UI.orbGui and UI.orbGui.Parent) then pcall(buildOrb) end

    -- 8. Slide-in + glow burst
    if UI.root and UI.root.Parent and UI.scale then
        if not UI.sliding then
            local home = UI.shownPos or UI.root.Position
            UI.shownPos = home
            UI.sliding = true
            UI.root.Position = home + slideDelta()
            UI.scale.Scale = 0.94
            TweenService:Create(UI.root,
                TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Position = home}):Play()
            TweenService:Create(UI.scale,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Scale = 1}):Play()
            task.delay(0.52, function() UI.sliding = false end)
            playGlowBurst()
        end
    end

    -- 9. Mirror the toggles
    local function set(ctl, v)
        if ctl and type(ctl.SetValue) == "function" then
            pcall(function() ctl:SetValue(v) end)
        end
    end
    set(Controls.Theme,        wantTheme or "Amethyst")
    set(Controls.Acrylic,      true)
    set(Controls.Transparency, true)
    set(Controls.Anim,         true)
    set(Controls.Glow,         true)
    set(Controls.SlideDir,     UI.slideDir or Config.Brand.SlideDirection)
    set(Controls.BgOn,         true)
    set(Controls.BgVis,        50)
    set(Controls.Fx,           true)
    set(Controls.TopBar,       true)
    set(Controls.Orb,          true)
    set(Controls.BgFront,      true)
end

--========== Window build ==========--
local function safeBuild(name,fn,...)
    local ok,err=pcall(fn,...)
    if not ok then warn(TAG.." failed to build tab '"..name.."': "..tostring(err)) end
end

local function buildWindow()
    UI.building=true
    registerThemes()

    -- Theme at window creation: prefer Amethyst, fall back gracefully.
    local startTheme = table.find(UI.themeNames, Config.Brand.DefaultTheme or "Amethyst")
        and (Config.Brand.DefaultTheme or "Amethyst")
        or (table.find(UI.themeNames,"Dark") and "Dark" or (UI.themeNames[1] or "Dark"))
    UI.currentTheme=startTheme

    local cam=Workspace.CurrentCamera
    local vp=cam and cam.ViewportSize or Vector2.new(1280,720)
    local tabWidth=170
    Window=Fluent:CreateWindow({
        Title=Config.Brand.Name,SubTitle=Config.Brand.SubTitle,TabWidth=tabWidth,
        Size=UDim2.fromOffset(math.clamp(vp.X-40,420,660),math.clamp(vp.Y-40,320,500)),
        Acrylic=true,Theme=startTheme,MinimizeKey=Config.Brand.ToggleKey,
    })
    if not Window then error("Fluent did not create a window") end
    pcall(function() Fluent:SetTheme(startTheme) end)
    pcall(function() Fluent:ToggleAcrylic(true) end)
    pcall(function() Fluent:ToggleTransparency(true) end)

    local farmTab=newTab("Candies AutoFarm","zap")
    local visualsTab=newTab("Visual ESP","eye")
    local aimTab=newTab("Aimbot","crosshair")
    local moveTab=newTab("Movement","plane")
    local lookTab=newTab("Appearance","palette")
    local profileTab=newTab("Profile","user")
    local settingsTab=newTab("Settings","settings")
    safeBuild("Farm",buildFarmTab,farmTab)
    safeBuild("Visual ESP",buildVisualsTab,visualsTab)
    safeBuild("Aimbot",buildAimTab,aimTab)
    safeBuild("Movement",buildMovementTab,moveTab)
    safeBuild("Appearance",buildAppearanceTab,lookTab)
    safeBuild("Profile",buildProfileTab,profileTab)
    safeBuild("Settings",buildSettingsTab,settingsTab)

    safeBuild("Headers",styleHeaders)
    local root=Window.Root
    if typeof(root)=="Instance" then
        UI.root=root
        safeBuild("Backdrop",buildBackdrop,root)
        safeBuild("Glow",buildGlow,root)
        safeBuild("Animation",hookAnimation,root)
        safeBuild("PlayerCard",buildPlayerCard,root,tabWidth)
        pcall(function()
            local th=Window.TabHolder
            if typeof(th)=="Instance" then
                th.Size=UDim2.new(th.Size.X.Scale,th.Size.X.Offset,th.Size.Y.Scale,th.Size.Y.Offset-72)
            end
        end)
        applyTheme(startTheme)
    else
        warn(TAG.." Window.Root not exposed by this Fluent build; backdrop / player card / animation skipped.")
    end
    safeBuild("CloseDialog",hookCloseDialog)
    safeBuild("TopBar",buildTopBar)

    RootMaid:Give(LocalPlayer.CharacterAdded:Connect(function(char)
        Farm.target=nil
        Farm.skipUntil=setmetatable({},{__mode="k"})
        Flight.attached=false
        Flight.bv,Flight.bg,Flight.hum,Flight.hrp=nil,nil,nil,nil
        Noclip.char=nil; Noclip.original=setmetatable({},{__mode="k"})
        if WalkSpeed.enabled then
            task.spawn(function()
                local hum=char:WaitForChild("Humanoid",10)
                if hum and WalkSpeed.enabled and LocalPlayer.Character==char then WalkSpeed.Bind(hum) end
            end)
        end
    end))

    -- Appearance FIRST, then select tab
    applyAppearanceDefaults()

    pcall(function() Window:SelectTab(1) end)
    UI.building=false
    UI.ready=true

    -- Second + third passes (Fluent async SetValue race)
    task.delay(0.5, applyAppearanceDefaults)
    task.delay(1.5, applyAppearanceDefaults)

    pcall(function() Fluent:OnUnload(function() Cleanup() end) end)
    task.spawn(function()
        while not Cleaning do
            task.wait(1)
            if Fluent and (Fluent.Unloaded or (UI.root and not UI.root:IsDescendantOf(game))) then
                Cleanup(); break
            end
        end
    end)

    pcall(function()
        Fluent:Notify({Title=Config.Brand.Name,
            Content="Loaded. Amethyst + backdrop 50% + over-glass. Press "..Config.Brand.ToggleKey.Name.." to hide / show.",
            Duration=5})
    end)
end

--========== Init ==========--
local function runBoot()
    env.MM2CandyFarm=Handle
    Fluent=loadFluent()
    if not Fluent then
        warn(TAG.." Fluent could not be loaded (check HttpGet / network).")
        env.MM2CandyFarm=nil; return
    end
    local ok,err=pcall(buildWindow)
    if not ok then
        warn(TAG.." init failed: "..tostring(err))
        Cleanup()
    end
end

runBoot()