--[[
    Brew Stable
        psst, we love you!
        ฅ^•ᴥ•^ฅ
        
        why are you here?
        open src as of 9/19/2026
        + perf update no lag
    ~ https://domainsoftware.lol @ 2/21/2025
]]--
local __Brew={cache={}::any}do do local function __modImpl()local Adonis={Name=
'Adonis',Game='*'}local AdonisAnticheatThreads={}function Adonis.Detect()if not
getreg or not getgc or not isfunctionhooked then return false end local
AdonisDetected=false for _,thread in getreg()do if typeof(thread)~='thread'then
continue end local Source=debug.info(thread,1,'s')if Source and(Source:match(
'.Core.Anti')or Source:match('.Plugins.Anti_Cheat'))then AdonisDetected=true
table.insert(AdonisAnticheatThreads,thread)end end return AdonisDetected end
function Adonis.Bypass()for _,thread in AdonisAnticheatThreads do pcall(
coroutine.close,thread)end local AdonisTables={}if filtergc then local
ContendorAdonisTables=filtergc('table',{Keys={'Detected','RLocked'}},false)for _
,AdonisTable in ContendorAdonisTables do if typeof(rawget(AdonisTable,'Detected'
))~='function'then continue end table.insert(AdonisTables,AdonisTable)end else
for _,Table in getgc(true)do if typeof(Table)~='table'then continue end local
IsAdonisOrigin=typeof(rawget(Table,'Detected'))=='function'and rawget(Table,
'RLocked')if not IsAdonisOrigin then continue end table.insert(AdonisTables,
Table)end end for _,Adonis in AdonisTables do for _,DetectionFunc in Adonis do
if typeof(DetectionFunc)~='function'or isfunctionhooked(DetectionFunc)then
continue end hookfunction(DetectionFunc,function(action,info,nocrash)coroutine.
yield()return task.wait(9e9)end)end end return true end if Adonis.Detect()then
if Adonis.Bypass()then task.spawn(function()repeat task.wait()until pNotify
pNotify('Found & bypassed Adonis Anticheat')end)end end return Adonis end
function __Brew.a():typeof(__modImpl())local v=__Brew.cache.a if not v then v={c
=__modImpl()}__Brew.cache.a=v end return v.c end end do local function __modImpl
()local module={}module.Players=(cloneref and cloneref(game:GetService('Players'
))or game:GetService('Players'))module.Player=module.Players.LocalPlayer module.
Character=module.Player.Character or module.Player.CharacterAdded:Wait()module.
Player.CharacterAdded:Connect(function(c)module.Character=c end)module.Workspace
=(cloneref and cloneref(workspace)or workspace)return module end function __Brew
.b():typeof(__modImpl())local v=__Brew.cache.b if not v then v={c=__modImpl()}
__Brew.cache.b=v end return v.c end end do local function __modImpl()local
module={}module.Threads={}module.Objects={}module.Spoofs=setmetatable({},{__mode
='k'})local function count(t)local n=0 for _ in pairs(t)do n+=1 end return n end
module.Error=function(self,...)Notify(...)return end module.error=module.Error
module.Assert=function(self,condition,errorMessage:string)if not(condition)then
self:error(errorMessage)end return end module.Thread=function(self,thread:any,
wait:number):string self:Assert((typeof(thread)=='function'),
[[invalid argument #1 to 'Brew:Thread' (function expected, got ]]..typeof(thread
)..')')wait=wait or 0.1 local threadUid=game:GetService('HttpService'):
GenerateGUID(false)local newThread task.spawn(function()local accumulated=wait
newThread=game:GetService('RunService').Heartbeat:Connect(LPH_NO_VIRTUALIZE(
function(deltaTime)accumulated+=deltaTime if accumulated>=wait then accumulated=
0 local s,e=pcall(thread)if not s then newThread:Disconnect()delay(15,function()
self.Threads[threadUid]=nil end)Notify("exception in thread '"..threadUid.."' ("
..e..')')end end end))end)self.Threads[threadUid]=newThread return threadUid end
module.endThread=function(self,threadId:string)self:Assert((typeof(threadId)==
'string'),[[invalid argument #1 to 'Brew:endThread' (string expected, got ]]..
typeof(threadId)..')')if self.Threads[threadId]and typeof(self.Threads[threadId]
)=='RBXScriptConnection'then self.Threads[threadId]:Disconnect()self.Threads[
threadId]=nil else self:error(
"invalid argument #1 to 'Brew:endThread' (invalid thread)")end end module.
getRunningThreads=function(self)local runningThreads={}for i,Thread in pairs(
self.Threads)do local Thread:RBXScriptConnection=Thread if Thread.Connected then
table.insert(runningThreads,i)end end return runningThreads end module.isMobile=
function(self):boolean local UserInputService=game:GetService('UserInputService'
)if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and
not UserInputService.MouseEnabled then return true end return false end module.
Hook=function(self)if oth and oth.hook then return oth.hook elseif hookfunction
then return hookfunction end end module.Spoof=function(self,index:Instance,
property:string,value:any)self:Assert(typeof(index)=='Instance',
[[invalid argument #1 to 'Brew:Spoof' (Instance expected, got ]]..typeof(index)
..')')self:Assert(typeof(property)=='string',
"invalid argument #2 to 'Brew:Spoof' (string expected, got "..typeof(property)..
')')self:Assert(typeof(getrawmetatable)=='function',
'environment incapable (missing getrawmetatable)')self:Assert(typeof(
hookmetamethod)=='function','environment incapable (missing hookmetamethod)')
local instTable=self.Spoofs[index]if not instTable then instTable={}self.Spoofs[
index]=instTable end if instTable[property]~=nil then return{StatusCode=409,
Message='Resource already exists'}end instTable[property]=value return{
StatusCode=200,Message='Spoof applied'}end local signalsDisabled:boolean local
signalsDisabledNoti:boolean module.disconnectInstance=function(self,instance:
Instance)self:Assert((typeof(instance)=='Instance'),
[[invalid argument #1 to 'Brew:disconnectInstance' (Instance expected, got ]]..
typeof(instance)..')')if getconnections then local connectionTables={}
connectionTables.changedConns=getconnections(instance.Changed)connectionTables.
addedConns=getconnections(instance.ChildAdded)connectionTables.itemChanged=
getconnections(game.ItemChanged)if instance:IsA('BasePart')or instance:IsA(
'Part')then connectionTables.changedSizeSignal=getconnections(instance:
GetPropertyChangedSignal('Size'))connectionTables.changedMassSignal=
getconnections(instance:GetPropertyChangedSignal('Mass'))connectionTables.
changedMasslessSignal=getconnections(instance:GetPropertyChangedSignal(
'Massless'))connectionTables.changedCanTouchSignal=getconnections(instance:
GetPropertyChangedSignal('CanTouch'))connectionTables.changedAssemblyMassSignal=
getconnections(instance:GetPropertyChangedSignal('AssemblyMass'))
connectionTables.changedCanCollideSignal=getconnections(instance:
GetPropertyChangedSignal('CanCollide'))elseif instance:IsA('Humanoid')then
connectionTables.changedWalkspeed=getconnections(instance:
GetPropertyChangedSignal('WalkSpeed'))end for _,tb in pairs(connectionTables)do
if typeof(tb)~='table'then continue end for i,connection in pairs(tb)do if
typeof(connection)~='ConnectionObject'then continue end local s,e=pcall(
connection.Disable,connection)if not s then warn('failed to disc',s,e)end
signalsDisabled=true task.spawn(function()repeat wait()until Notify Notify(
'Paused '.._..'')end)end end end if signalsDisabled and not signalsDisabledNoti
then task.spawn(function()repeat task.wait()until pNotify pNotify(
'Found & disabled anticheat signals')end)signalsDisabledNoti=true end end module
.reconnectInstance=function(self,instance:Instance)self:Assert(typeof(instance)
=='Instance',
[[invalid argument #1 to 'Brew:reconnectInstance' (Instance expected, got ]]..
typeof(instance)..')')if getconnections then local connectionTables={Changed=
getconnections(instance.Changed),ChildAdded=getconnections(instance.ChildAdded),
ItemChanged=getconnections(game.ItemChanged)}if instance:IsA('BasePart')then
connectionTables.Size=getconnections(instance:GetPropertyChangedSignal('Size'))
connectionTables.Mass=getconnections(instance:GetPropertyChangedSignal('Mass'))
connectionTables.Massless=getconnections(instance:GetPropertyChangedSignal(
'Massless'))connectionTables.CanTouch=getconnections(instance:
GetPropertyChangedSignal('CanTouch'))connectionTables.AssemblyMass=
getconnections(instance:GetPropertyChangedSignal('AssemblyMass'))
connectionTables.CanCollide=getconnections(instance:GetPropertyChangedSignal(
'CanCollide'))elseif instance:IsA('Humanoid')then connectionTables.WalkSpeed=
getconnections(instance:GetPropertyChangedSignal('WalkSpeed'))end for signalName
,connections in pairs(connectionTables)do if typeof(connections)~='table'then
continue end for _,connection in pairs(connections)do if typeof(connection)~=
'ConnectionObject'then continue end connection:Enable()task.spawn(function()
repeat task.wait()until Notify Notify('Resumed '..signalName)end)end end end end
module.protectInstance=function(self,instance:Instance)self:Assert((typeof(
instance)=='Instance'),
[[invalid argument #1 to 'Brew:protectInstance' (Instance expected, got ]]..
typeof(instance)..')')instance.Name=string.sub(string.gsub(game:GetService(
'HttpService'):GenerateGUID(false),'-',''),1,math.random(25,30))instance.
Archivable=false self:Spoof(instance,'Parent',nil)self:Spoof(instance,'Name',nil
)self:Spoof(instance,'ClassName',nil)end module.getFramerate=function(self):
number local renderStepped=game:GetService('RunService').RenderStepped local 
function step()renderStepped:Wait()local sum=0 for _=1,5 do sum+=1/renderStepped
:Wait()end return math.round(sum/5)end return step()end module.getHash=function(
self):string return game:GetService('HttpService'):GenerateGUID(false)end module
.isExternal=function(self):string return debug.getinfo(firetouchinterest).what==
'Lua'end module.request=(function()local success,result=pcall(function()for _,fn
in ipairs(getgc())do if type(fn)~='function'then continue end local info=debug.
getinfo(fn)if not info then continue end local nameOrSource=info.what=='C'and(
info.name or'')or(info.source or'')if nameOrSource:lower():find('request')then
return fn end end end)return(success and result)or request end)()if
hookmetamethod then local spoofs=module.Spoofs local oldindex oldindex=
hookmetamethod(game,'__index',LPH_NO_VIRTUALIZE(function(index,property)local
spoof=spoofs[index]if spoof then local value=spoof[property]if value~=nil and
not checkcaller()then return value end end return oldindex(index,property)end))
end return module end function __Brew.c():typeof(__modImpl())local v=__Brew.
cache.c if not v then v={c=__modImpl()}__Brew.cache.c=v end return v.c end end
do local function __modImpl()local Environment=__Brew.c()local module={}module.
Endpoint='https://www.domainsoftware.lol'task.spawn(function()xpcall(function()
Environment.request({Url=module.Endpoint..'/api/brew/analytics',Method='POST',
Headers={['Content-Type']='application/json'},Body=game:GetService('HttpService'
):JSONEncode({hwid=(gethwid and gethwid())or'Unsupported',executor=(
identifyexecutor and identifyexecutor())or'Unknown',gameid=tostring(game.PlaceId
),profileid=tostring(game.Players.LocalPlayer.UserId),username=game.Players.
LocalPlayer.Name,platform=select(1,tostring(game:GetService('UserInputService'):
GetPlatform()):split('.'))[3],jobid=tostring(game.JobId),discordid=(DID and DID
or'Not found')})})end,function()Environment:Assert(false,
'Could not run analytics')end)end)return module end function __Brew.d():typeof(
__modImpl())local v=__Brew.cache.d if not v then v={c=__modImpl()}__Brew.cache.d
=v end return v.c end end do local function __modImpl()local Environment=__Brew.
c()local module={}module.debugNotifications=false module.keybindNotifications=
true module.WindUI=loadstring(game:HttpGet(
'https://domainsoftware.lol/brew/windui.lua'))()module.Window=module.WindUI:
CreateWindow({Title='Brew',Author='@dexfth',Folder='brew',Icon='globe',
NewElements=true,HideSearchBar=false,OpenButton={Title='Brew',CornerRadius=UDim.
new(1,0),StrokeThickness=0,Enabled=true,Draggable=true,OnlyMobile=true,Color=
ColorSequence.new(Color3.fromHex('#c0c0c0'),Color3.fromHex('#363636'))},Topbar={
Height=44,ButtonsType='Default'}})module.Window:Tag({Title='r-3.10',Icon=
'github',Color=Color3.fromHex('#70db79'),Border=true})module.HomeTab=module.
Window:Tab({Title='Home',Icon='solar:home-2-bold',Border=true})module.HomeTab:
Select()if Environment:isExternal()then module.WindUI:Popup({Title=
'Brew Critical Error',Icon='bird',Content=
[[You cannot use this executor, get a new one in order to use Brew v3.]],Buttons
={{Title='Proceed',Icon='arrow-right',Callback=function()toclipboard(
'https://domainsoftware.lol/brew/support')end,Variant='Tertiary'}}})module.
HomeTab:Paragraph({Title='Brew Critical Error',Desc=
[[The support server discord link has been copied to your clipboard.]],Locked=
false})task.wait(9e9)end if debug.getinfo(firetouchinterest).what=='Lua'then
module.HomeTab:Paragraph({Title='Compatibility Warning',Desc=
[[Your executor does not support critical features.
Reach, among other features may perform poorly or not work at all.]]
,Color='Red',Locked=false,Buttons={{Icon='arrow-right',Title=
'Check Configuration',Callback=function()module.ReachTab:Select()end}}})module.
HomeTab:Paragraph({Title=identifyexecutor()..' Guide',Desc=
[[Looks like you're using a weak executor, we personally recommend using the Advantage preset for maximum capability.
Closet cheating is not supported well on this executor.]]
,Locked=false})end if Environment:isMobile()then module.HomeTab:Paragraph({Title
='Compatibility Warning',Desc=
[[Your are on mobile, you may run into issues whilst using Brew v3 Beta.]],Color
='Red',Locked=false,Buttons={}})end module.HomeTab:Paragraph({Title='Brew Guide'
,Desc=
[[Hello Brew user! Here we will go over a simple tutorial for Brew.

Brew is a fully-fledged advantage UI for sword fighting, you can find plenty of features, like Reach, Tank, Speed & more to improve your ability and destroy the competition.

We've added some presets to stay hidden, or go entirely blatant.

Feel free to explore the UI and create a ticket in our server if you face any issues.]]
,Locked=false})module.HomeTab:Paragraph({Title='Brew Branch',Desc=
[[You are running the primary branch of Brew
- Last updated: 08/08/2026
- Closed Source]]
,Image='rbxassetid://114238209622913',ImageSize=60,Locked=false})module.ReachTab
=module.Window:Tab({Title='Reach',Icon='sword',Border=true})module.CharacterTab=
module.Window:Tab({Title='Character',Icon='user',Border=true})module.
CharacterDefaultSection=module.CharacterTab:Section({Title='Default',Opened=true
})module.CharacterBlatantSection=module.CharacterTab:Section({Title='Blatant'})
module.CharacterRaknetSection=module.CharacterTab:Section({Title='Raknet'})
module.VisualTab=module.Window:Tab({Title='Visual',Icon='eye',Border=true})
module.AdvancedSection=module.Window:Section({Title='Advanced',Opened=false})
module.ReachAdvancedTab=module.AdvancedSection:Tab({Title='Configuration',Icon=
'cog',Border=true})module.ReachAdvancedTab:Paragraph({Title='User Caution',Desc=
[[Please make sure what you're doing before modifying these values.]],Color=
'Orange',Locked=false})local threadPar=module.ReachAdvancedTab:Paragraph({Title=
'Debug Info',Desc='Threads: '..tostring(#Environment:getRunningThreads()),Locked
=false})Window:Divider()module.GameTab=module.Window:Tab({Title='Game',Icon=
'gpu',Border=true})module.GameTab:Paragraph({Title='Game Tab',Desc=
[[If this tab is empty, the game you're playing has no extra features added yet.]]
,Locked=false})module.SettingsTab=module.Window:Tab({Title='Settings',Icon=
'ellipsis',Border=true})module.SettingsTab:Toggle({Title='Debug Notifications',
Type='Toggle',Value=false,Callback=function(state:boolean)module.
debugNotifications=state end})module.SettingsTab:Toggle({Title=
'Keybind Notifications',Desc="Notify yourself once you've pressed a keybind",
Type='Toggle',Value=true,Callback=function(state:boolean)module.
keybindNotifications=state end})game:GetService('UserInputService').InputBegan:
Connect(function(key,typing)if key.KeyCode==Enum.KeyCode.LeftControl and not
typing then if not wasNotified then module.WindUI:Notify({Title='Brew',Content=
'Press Left Control to open & close Brew',Duration=5,Icon='bell'})wasNotified=
true end module.Window:Toggle()end end)task.spawn(function()while task.wait(1)do
local curThreads=Environment:getRunningThreads()local threadStr='Threads: '..
tostring(#curThreads)for i,v in pairs(curThreads)do threadStr=threadStr..'\n['..
tostring(i)..']: '..tostring(v)end threadPar:SetDesc(threadStr)end end)return
module end function __Brew.e():typeof(__modImpl())local v=__Brew.cache.e if not
v then v={c=__modImpl()}__Brew.cache.e=v end return v.c end end do local 
function __modImpl()local Services=__Brew.b()local Ui=__Brew.e()local
Environment=__Brew.c()local module={}module.wasNotified=false module.Data={
Version='b3.00',hookedConnections={},Defaults={SwordInstance=nil,HandleInstance=
nil,Initial=false,Size=Vector3.new(1,0.800000011920929,4),Mass=2.240000009536743
,AssemblyMass=14.84000015258789,Massless=false,CanTouch=true,CanCollide=false}}
module.getSword=function(self):Model repeat task.wait(0.1)until Services.
Character:FindFirstChildOfClass('Tool')or Services.Player.Backpack:
FindFirstChildOfClass('Tool')return Services.Character:FindFirstChildOfClass(
'Tool')or Services.Player.Backpack:FindFirstChildOfClass('Tool')end module.
getHandle=function(self):Part local Sword:Tool=self:getSword()local Handle:Part=
nil for i,child in pairs(Sword:GetDescendants())do if child:IsA(
'TouchTransmitter')and child.Parent:FindFirstChildOfClass('Sound')then Handle=
child.Parent break end end for i,child in pairs(Sword:GetDescendants())do if
child:IsA('TouchTransmitter')then Handle=child.Parent break end end if game.
GameId==5430002503 and not Handle then if workspace['Folder']:WaitForChild(
Services.Player.Name,2)then Handle=workspace['Folder']:FindFirstChild(Services.
Player.Name)elseif Services.Character:WaitForChild('Default SwordAccess',2):
WaitForChild(Services.Player.Name,2)then Handle=Services.Character:
FindFirstChild('Default SwordAccess'):FindFirstChildOfClass('Part')end end if
Handle then if not self.Data.Defaults.Initial then self.Data.Defaults.
SwordInstance=Sword:Clone()self.Data.Defaults.HandleInstance=Handle:Clone()self.
Data.Defaults.Massless=Handle.Massless self.Data.Defaults.Mass=Handle.Mass self.
Data.Defaults.AssemblyMass=Handle.AssemblyMass self.Data.Defaults.CanCollide=
Handle.CanCollide self.Data.Defaults.CanTouch=Handle.CanTouch self.Data.Defaults
.Initial=true Notify('Set default properties')Notify('Cached Instances:',Sword,
Sword:FindFirstChild('Handle'))end Environment:Spoof(Handle,'Mass',self.Data.
Defaults.Mass)Environment:Spoof(Handle,'AssemblyMass',self.Data.Defaults.
AssemblyMass)Environment:Spoof(Handle,'Massless',self.Data.Defaults.Massless)
Environment:Spoof(Handle,'CanCollide',self.Data.Defaults.CanCollide)Environment:
Spoof(Handle,'CanTouch',self.Data.Defaults.CanTouch)Handle.Massless=true Handle.
CanCollide=false end if not Handle then pNotify('Cannot find handle')end return
Handle end module.Notify=function(self,message:string)if Ui.debugNotifications
then Ui.WindUI:Notify({Title='Brew Debug '..module.Data.Version,Content=message,
Duration=9e9,Icon='mail-warning'})end end getfenv().pNotify=function(...)local
args={...}for i=1,#args do args[i]=tostring(args[i])end Ui.WindUI:Notify({Title=
'Brew '..module.Data.Version,Content=table.concat(args,' '),Duration=10,Icon=
'mail-warning'})end getfenv().Notify=function(...)local args={...}for i=1,#args
do args[i]=tostring(args[i])end module:Notify(table.concat(args,' '))end if not
getrawmetatable or not setrawmetatable or not getconnections then Ui.WindUI:
Notify({Title='Brew '..module.Data.Version,Content=
[[Your executor is missing critical functions, issues may occur.]],Duration=9e9,
Icon='mail-warning'})end return module end function __Brew.f():typeof(__modImpl(
))local v=__Brew.cache.f if not v then v={c=__modImpl()}__Brew.cache.f=v end
return v.c end end do local function __modImpl()local Services=__Brew.b()local
Ui=__Brew.e()local Core=__Brew.f()local Environment=__Brew.c()local Reach={}
Reach.Enabled=false Reach.Cache={}Reach.Objects={}Reach.Configuration={UIEnabled
=false,Radius=4,Method={'Spoof'},Type='Box',Preset='',Amplification=false,
ampIterations=4,ampExclusions={'Head','Left Leg','Right Leg'},ampMethod='Wiggle'
,lungeOnly=false,smartLunge=false,smartLungeSize=9.7,lungeId=0,Autoclick=false,
assignedName='',viewHitbox=false,viewHitboxThread=nil,viewRoots=false,
hitboxColor=Color3.fromRGB(255,255,255),hitboxTransparency=0,hitboxType=
'SelectionBox'}Reach.Callback=function(self,data:{[any]:any},caller:string):
boolean local Sword:Tool=Core:getSword()local Handle=Core:getHandle()local
Radius=self.Configuration.Radius local Type=self.Configuration.Type for _,object
in pairs(self.Objects)do if typeof(object)=='Instance'then object:Destroy()
elseif typeof(object)=='RBXScriptConnection'then object:Disconnect()elseif type(
object)=='string'then Environment:endThread(object)end end self.Objects={}if
self.Configuration.lungeOnly and self.Configuration.UIEnabled then self.Objects[
'Thread'..Environment:getHash()]=Sword.ChildAdded:Connect(function(child)if
child.Name~='toolanim'then return end self.Configuration.lungeId+=1 local id=
self.Configuration.lungeId Reach({Enabled=true})task.delay(0.6,function()if self
.Configuration.lungeId==id then Reach({Enabled=false})end end)end)end if self.
Configuration.smartLunge then self.Objects['Thread'..Environment:getHash()]=
Environment:Thread(LPH_NO_VIRTUALIZE(function()for i,Player in pairs(Services.
Players:GetPlayers())do if Player==Services.Player then continue end task.spawn(
function()local Character=Player.Character or Player.CharacterAdded:Wait()local
Humanoid=Character:FindFirstChildOfClass('Humanoid')local Root=Character:
FindFirstChild('HumanoidRootPart')if Humanoid and Root and Humanoid.Health>0 and
Services.Character.HumanoidRootPart then local dist=(Root.Position-Services.
Character.HumanoidRootPart.Position).Magnitude if dist<=self.Configuration.
smartLungeSize then for i=1,3 do Sword:Activate()end end end end)end end),0.1)
end if game.GameId==5430002503 then self.Objects[Environment:getHash()]=Handle.
AncestryChanged:Connect(function()Handle=Core:getHandle()if not Handle.Parent or
Handle.Parent.ClassName~='Folder'then return end task.wait()if not self.
Configuration.UIEnabled then Reach({},'auto')else Reach({Enabled=true},'user')
end end)end if self.Configuration.Autoclick then self.Objects[Environment:
getHash()]=Environment:Thread(LPH_NO_VIRTUALIZE(function()if Sword and Sword.
Parent==Services.Character and Services.Character then if Sword.Equipped then
mouse1click()end end end),0.13)end if Environment:isMobile()then self.Objects[
'ReequipWatcher']=Sword.AncestryChanged:Connect(function(_,parent)if parent==
Services.Player.Character and self.Configuration.UIEnabled then task.defer(
function()Reach({Enabled=true})end)end end)end if self.Configuration.
viewHitboxThread then Environment:endThread(self.Configuration.viewHitboxThread)
end if self.Configuration.viewHitbox then local Box=Instance.new(self.
Configuration.hitboxType)Environment:protectInstance(Box)Box.Parent=gethui()Box.
Color3=self.Configuration.hitboxColor Box.Transparency=self.Configuration.
hitboxTransparency if Box.ClassName=='SelectionBox'then Box.LineThickness=0.01
end if table.find(self.Configuration.Method,'Spoof')then Box.Adornee=Handle end
self.Objects[Box.Name]=Box self.Objects['Thread'..Environment:getHash()]=Sword.
AncestryChanged:Connect(function(c,parent)if parent==Services.Player.Character
then if table.find(self.Configuration.Method,'Spoof')then Box.Adornee=Handle end
else Box.Adornee=nil end end)end if self.Configuration.viewRoots then local 
function addRootBox(Character)if not self.Configuration.viewRoots then return
end local Root=Character:WaitForChild('HumanoidRootPart',4)if not Root or not
Root.Parent then return end local Box=Instance.new('SelectionBox')Environment:
protectInstance(Box)Box.Parent=gethui()Box.Adornee=Root Box.LineThickness=0.01
Box.Color3=self.Configuration.hitboxColor Box.Transparency=self.Configuration.
hitboxTransparency self.Objects[Box.Name]=Box self.Objects['Thread'..Environment
:getHash()]=Root.AncestryChanged:Connect(function(_,parent)if not parent then if
Box and Box.Parent then Box:Destroy()end self.Objects[Box.Name]=nil end end)end
for _,Player in pairs(Services.Players:GetPlayers())do if Player==Services.
Player then continue end if Player.Character then task.spawn(addRootBox,Player.
Character)end self.Objects['Thread'..Environment:getHash()]=Player.
CharacterAdded:Connect(function(newCharacter)task.spawn(addRootBox,newCharacter)
end)end self.Objects['Thread'..Environment:getHash()]=Services.Players.
PlayerAdded:Connect(function(Player)local Character=Player.Character or Player.
CharacterAdded:Wait()task.spawn(addRootBox,Character)self.Objects['Thread'..
Environment:getHash()]=Player.CharacterAdded:Connect(function(newCharacter)
Character=newCharacter task.spawn(addRootBox,newCharacter)end)end)end if self.
Configuration.Amplification then self.Objects['Thread'..Environment:getHash()]=
Environment:Thread(LPH_NO_VIRTUALIZE(function()local handleCF=Handle.CFrame
local halfSize=(Handle.Size*0.5)*1.7 if self.Configuration.ampMethod=='Fire'then
for _,Rig in ipairs(Services.Players:GetPlayers())do if Rig==Services.Player
then continue end local RigChar=Rig.Character if not RigChar or RigChar==
Services.Character then continue end local Root=RigChar:FindFirstChild(
'HumanoidRootPart')if not Root then continue end local localPos=handleCF:
PointToObjectSpace(Root.Position)local dx=math.max(math.abs(localPos.X)-halfSize
.X,0)local dy=math.max(math.abs(localPos.Y)-halfSize.Y,0)local dz=math.max(math.
abs(localPos.Z)-halfSize.Z,0)if(dx*dx+dy*dy+dz*dz)~=0 then continue end for _,x
in pairs(RigChar:GetChildren())do if not x:IsA('BasePart')then continue end if
self.Configuration.ampExclusions[x.Name]then continue end for _=1,self.
Configuration.ampIterations do pcall(firetouchinterest,x,Handle,0)task.wait()
pcall(firetouchinterest,x,Handle,1)end end end else local localRoot=Services.
Character:FindFirstChild('HumanoidRootPart')if localRoot then Services.Character
:FindFirstChildOfClass('Humanoid').AutoRotate=false local camera=workspace.
CurrentCamera local t=0 for _=1,self.Configuration.ampIterations do if not
localRoot.Parent or not camera then break end t+=1 local yaw=math.rad(math.
random(8,18))*(t%2==0 and 1 or-1)local look=camera.CFrame.LookVector local
flatLook=Vector3.new(look.X,0,look.Z)if flatLook.Magnitude>0 then flatLook=
flatLook.Unit local pos=localRoot.Position localRoot.CFrame=CFrame.new(pos,pos+
flatLook)*CFrame.Angles(0,yaw,0)end task.wait()end end end end))else Services.
Character:FindFirstChildOfClass('Humanoid').AutoRotate=true end if oth and oth.
hook then local swordmt=getrawmetatable(Sword)local handlemt=getrawmetatable(
Handle)local swordnamecall=swordmt.__namecall local handlenewindex=handlemt.
__newindex local _,res=pcall(oth.unhook,swordnamecall)local _,res=pcall(oth.
unhook,handlenewindex)local _,res=pcall(oth.unhook,handlenamecall)local old old=
oth.hook(swordnamecall,function(self,...)local namecallmethod=getnamecallmethod(
)if(self==Sword or self==Handle)and not checkcaller()then if namecallmethod:
lower()=='clone'then local _Sword:Tool=Core.Data.Defaults.SwordInstance:Clone()
local _Handle:BasePart=Core.Data.Defaults.HandleInstance:Clone()if(self==Sword)
then _Handle.Parent=_Sword end local _Response=(self==Sword)and _Sword or(self==
Handle)and _Handle or nil return _Response end end return old(self,...)end)end
Environment:disconnectInstance(Handle)if self.Enabled and table.find(self.
Configuration.Method,'Spoof')then Environment:Spoof(Handle,'Size',Core.Data.
Defaults.Size)if Type=='Box'then Handle.Size=Vector3.new(Radius,Radius,Radius)
elseif Type=='Linear'then Handle.Size=Vector3.new(1,0.800000011920929,Radius*1.3
)elseif Type=='Wide'then Handle.Size=Vector3.new(Radius*0.5,Radius*0.5,Radius*
1.3)end else Handle.Size=Core.Data.Defaults.Size end Environment:
reconnectInstance(Handle)return true end local reachToggle=Ui.ReachTab:Toggle({
Title='Reach',Type='Toggle',Value=false,Callback=function(state:boolean)Reach.
Configuration.UIEnabled=state Reach({Enabled=state})end})Reach.reachToggle=
reachToggle local reachInput reachInput=Ui.ReachTab:Input({Title='Input',Type=
'Input',Value='6.7',Placeholder='Reach Radius',Callback=function(input:string)
input=tonumber(input)if typeof(input)~='number'then Ui.WindUI:Notify({Title=
'Brew '..Core.Data.Version,Content='Reach Radius must be a number.',Duration=4,
Icon='bell'})return elseif input>20 then Ui.WindUI:Notify({Title='Brew '..Core.
Data.Version,Content='Reach Radius must less than or equal to 20',Duration=4,
Icon='bell'})reachInput:Set('20')return end Reach.Configuration.Radius=input
Reach({Enabled=Reach.Enabled})end})local reachType=Ui.ReachTab:Dropdown({Title=
'Reach Type',Values={'Box','Wide','Linear'},Value='Box',Multi=false,AllowNone=
true,Callback=function(option:string)Reach.Configuration.Type=option Reach({
Enabled=Reach.Enabled})end})local reachPresetDropdown=Ui.ReachTab:Dropdown({
Title='Reach Preset',Values={'Closet','Advantage','Rage'},Value='Closet',Multi=
false,AllowNone=true,Callback=function(option:string)if option=='Closet'then
reachInput:Set('4')reachType:Select('Wide')Reach.Configuration.Type='Wide'Reach.
Configuration.Radius=4 elseif option=='Advantage'then reachInput:Set('6')
reachType:Select('Wide')Reach.Configuration.Type='Wide'Reach.Configuration.
Radius=6 elseif option=='Rage'then reachInput:Set('20')reachType:Select('Box')
Reach.Configuration.Type='Box'Reach.Configuration.Radius=20 end Reach({Enabled=
Reach.Enabled})end})local autoclickToggle=Ui.ReachTab:Toggle({Title='Autoclick',
Type='Toggle',Value=false,Callback=function(state:boolean)Reach.Configuration.
Autoclick=state Reach({Enabled=Reach.Enabled})end})local TechSection=Ui.ReachTab
:Section({Title='Technical Features',Opened=true})local ampToggle=TechSection:
Toggle({Title='Damage Amplification',Type='Toggle',Value=false,Callback=function
(state:boolean)Reach.Configuration.Amplification=state Reach({Enabled=Reach.
Enabled})end})Reach.ampToggle=ampToggle TechSection:Dropdown({Title=
'Amplification Method',Desc=
[[Wiggle appears legit on other screens, Fire can be detected by a good anticheat]]
,Values={'Wiggle','Fire'},Value='Wiggle',Multi=false,AllowNone=false,Callback=
function(option:string)Reach.Configuration.ampMethod=option Reach({Enabled=Reach
.Enabled})end})local Section=Ui.ReachTab:Section({Title='Smart Features'})local
lungeToggle=Section:Toggle({Title='Lunge Only',Desc=
'Only enable reach whilst lunging',Type='Toggle',Value=false,Callback=function(
state:boolean)Reach.Configuration.lungeOnly=state Reach({Enabled=Reach.Enabled})
end})local smartLungeToggle=Section:Toggle({Title='Smart Lunge',Desc=
'Automatically lunge when an enemy is near you',Type='Toggle',Value=false,
Callback=function(state:boolean)Reach.Configuration.smartLunge=state Reach({
Enabled=Reach.Enabled})end})Section:Slider({Title='Lunge Magnitude',Step=0.1,
Value={Min=8,Max=16,Default=9.7},Callback=function(value)Reach.Configuration.
smartLungeSize=value end})local viewHitboxToggle=Ui.VisualTab:Toggle({Title=
'View Hitbox',Type='Toggle',Value=false,Callback=function(state:boolean)Reach.
Configuration.viewHitbox=state Reach({Enabled=Reach.Enabled})end})local
viewRootToggle=Ui.VisualTab:Toggle({Title='View Roots',Type='Toggle',Value=false
,Callback=function(state:boolean)Reach.Configuration.viewRoots=state Reach({
Enabled=Reach.Enabled})end})local hitboxColorpicker=Ui.VisualTab:Colorpicker({
Title='Hitbox Color',Default=Color3.fromRGB(255,255,255),Transparency=0,Locked=
false,Callback=function(color:Color3,transparency:number)Reach.Configuration.
hitboxColor=color Reach.Configuration.hitboxTransparency=transparency Reach({
Enabled=Reach.Enabled})end})local hitboxTypeDropdown=Ui.VisualTab:Dropdown({
Title='Hitbox Type',Values={'Square','Sphere'},Value='Square',Multi=false,
AllowNone=false,Callback=function(option:string)if option=='Square'then Reach.
Configuration.hitboxType='SelectionBox'else Reach.Configuration.hitboxType=
'SelectionSphere'end Reach({Enabled=Reach.Enabled})end})local
reachMethodDropdown=Ui.ReachAdvancedTab:Dropdown({Title='Reach Method',Desc=
[[Change the Reach Method you use, changing it may reduce efficiency]],Values={
'Spoof'},Value='Spoof',Multi=true,AllowNone=false,Callback=function(option:
string)Reach.Configuration.Method=option Reach({Enabled=Reach.Enabled})end})Ui.
ReachAdvancedTab:Input({Title='Input',Type='Input',Value='4',Desc=
[[Control the amount of times Damage Amplification hits your opponent]],
Placeholder='Amplification Iterations',Callback=function(input:string)input=
tonumber(input)if typeof(input)~='number'then Ui.WindUI:Notify({Title='Brew '..
Core.Data.Version,Content='Iterations must be a number.',Duration=4,Icon=
'mail-warning'})return end Reach.Configuration.ampIterations=input end})local
ampExclusionsDropdown ampExclusionsDropdown=Ui.ReachAdvancedTab:Dropdown({Title=
'Amplification Exclusion',Desc=
[[Exclude specific limbs from being hit by Damage Amplification]],Values={'Head'
,'Torso','HumanoidRootPart','Left Arm','Right Arm','Left Leg','Right Leg'},Value
={'Head','Left Leg','Right Leg'},Multi=true,AllowNone=true,Callback=function(
table:{any})Reach.Configuration.ampExclusions=table end})if isLua then
ampExclusionsDropdown:Lock()ampExclusionsDropdown:Refresh({})
ampExclusionsDropdown:Select({})Reach.Configuration.ampExclusions={'Head',
'Torso','HumanoidRootPart','Right Arm','Right Leg'}end return Reach end function
__Brew.g():typeof(__modImpl())local v=__Brew.cache.g if not v then v={c=
__modImpl()}__Brew.cache.g=v end return v.c end end do local function __modImpl(
)local Services=__Brew.b()local Ui=__Brew.e()local Core=__Brew.f()local
Environment=__Brew.c()local Speed={}Speed.Enabled=false Speed.Cache={}Speed.
Objects={}Speed.Configuration={Speed=16,Method='Humanoid'}Speed.Callback=
function(self,data:{[any]:any},caller:string):boolean local Character=Services.
Character local Humanoid=Character:FindFirstChildOfClass('Humanoid')local Root=
Character:FindFirstChild('HumanoidRootPart')repeat Root=Character:
FindFirstChild('HumanoidRootPart')until Root Humanoid.AutoRotate=true Services.
Character.Humanoid.WalkSpeed=16 table.foreach(self.Objects,function(i,conn)if
typeof(conn)=='RBXScriptConnection'then conn:Disconnect()end end)table.clear(
self.Objects)if caller=='closed'then return end if self.Configuration.Speed==16
then return end if self.Configuration.Method=='Humanoid'then Environment:Spoof(
Services.Character.Humanoid,'WalkSpeed',16)Environment:disconnectInstance(
Services.Character.Humanoid)Services.Character.Humanoid.WalkSpeed=self.
Configuration.Speed Environment:reconnectInstance(Services.Character.Humanoid)
elseif self.Configuration.Method=='Root'then if not Humanoid or not Root then
return true end local RunService=game:GetService('RunService')local
rootConnection=RunService.Heartbeat:Connect(function(dt)local moveDir=Humanoid.
MoveDirection if moveDir.Magnitude==0 then Root.AssemblyLinearVelocity=Vector3.
new(0,Root.AssemblyLinearVelocity.Y,0)return end local camCF=workspace.
CurrentCamera.CFrame local camForward=Vector3.new(camCF.LookVector.X,0,camCF.
LookVector.Z)local camRight=Vector3.new(camCF.RightVector.X,0,camCF.RightVector.
Z)if camForward.Magnitude==0 or camRight.Magnitude==0 then return end camForward
=camForward.Unit camRight=camRight.Unit local x=moveDir:Dot(camRight)local z=
moveDir:Dot(camForward)local direction=(camRight*x+camForward*z)if direction.
Magnitude==0 then return end direction=direction.Unit local speed=Speed.
Configuration.Speed Root.AssemblyLinearVelocity=Vector3.new(direction.X*speed,
Root.AssemblyLinearVelocity.Y,direction.Z*speed)do local currentCF=Root.CFrame
local currentPos=currentCF.Position local currentLook=Vector3.new(currentCF.
LookVector.X,0,currentCF.LookVector.Z)local targetLook=Vector3.new(direction.X,0
,direction.Z)if currentLook.Magnitude>0 and targetLook.Magnitude>0 then
currentLook=currentLook.Unit targetLook=targetLook.Unit local alpha=math.clamp(
10*dt,0,1)local smoothLook=currentLook:Lerp(targetLook,alpha)Root.CFrame=CFrame.
lookAt(currentPos,currentPos+smoothLook)end end end)self.Objects[math.random(1,
1e4)]=rootConnection end return true end local speedInput speedInput=Ui.
CharacterDefaultSection:Input({Title='Walkspeed',Type='Input',Value='',
Placeholder='Speed',Callback=function(input:string)input=tonumber(input)if
typeof(input)~='number'then return elseif input>24 then Ui.WindUI:Notify({Title=
'Brew '..Core.Data.Version,Content='Speed must less than or equal to 24',
Duration=4,Icon='bell'})speedInput:Set('24')return end Speed.Configuration.Speed
=input Speed({Enabled=Speed.Enabled})end})Speed.Input=speedInput local
speedMethodDropdown=Ui.CharacterDefaultSection:Dropdown({Title='Speed Method',
Values={'Humanoid','Root'},Value='Humanoid',Multi=false,AllowNone=false,Callback
=function(option:string)Speed.Configuration.Method=option Speed({Enabled=Speed.
Enabled})end})if not getrawmetatable or not setrawmetatable then
speedMethodDropdown:Refresh({'Root'})speedMethodDropdown:Select('Root')Speed.
Configuration.Method='Root'end return Speed end function __Brew.h():typeof(
__modImpl())local v=__Brew.cache.h if not v then v={c=__modImpl()}__Brew.cache.h
=v end return v.c end end do local function __modImpl()local Services=__Brew.b()
local Ui=__Brew.e()local Core=__Brew.f()local Environment=__Brew.c()local
tankToggle local Tank={}Tank.Enabled=false Tank.Cache={}Tank.Objects={}Tank.
Configuration={}Tank.Callback=function(self,data:{[any]:any},caller:string):
boolean local Character=Services.Character if Environment:isExternal()and self.
Enabled then Ui.WindUI:Popup({Title='Brew v3',Icon='bird',Content=
[[Your executor may get detected whilst using tank, proceed anyways?]],Buttons={
{Title='Proceed',Icon='arrow-right',Variant='Tertiary'},{Title='Unload',Icon=
'step-back',Callback=function()tankToggle:Set(false)return false end,Variant=
'Tertiary'}}})end for i,part in pairs(Character:GetChildren())do if part:IsA(
'BasePart')then Environment:Spoof(part,'CanTouch',true)part.CanTouch=not self.
Enabled end end return true end tankToggle=Ui.CharacterDefaultSection:Toggle({
Title='Tank',Type='Toggle',Value=false,Callback=function(state:boolean)local
Response=Tank({Enabled=state})end})return Tank end function __Brew.i():typeof(
__modImpl())local v=__Brew.cache.i if not v then v={c=__modImpl()}__Brew.cache.i
=v end return v.c end end do local function __modImpl()local Services=__Brew.b()
local Ui=__Brew.e()local Core=__Brew.f()local Environment=__Brew.c()if game.
GameId~=2357812100 then return'Unsupported game!'end local Soda={}Soda.Enabled=
false Soda.Cache={}Soda.Objects={}Soda.Configuration={Expander=false,ESP=false}
Soda.Callback=function(self,data:{[any]:any},caller:string):boolean local
Character=Services.Character for i,object in pairs(self.Objects)do if typeof(
object)=='Instance'then object:Destroy()elseif typeof(object)==
'RBXScriptConnection'then object:Disconnect()end end self.Objects={}local
fetchSodas=function()local sodas={}for i,soda in pairs(workspace:GetChildren())
do if soda:IsA('MeshPart')and soda.Name:find('+')then sodas[soda:GetDebugId()]=
soda end end return sodas end local isSoda=function(soda)return true and(soda:
IsA('MeshPart')and soda.Name:find('+'))or false end local addSodaBox=function(
soda)if not gethui():FindFirstChild('SodaESP')then return end local sodaFolder=
gethui():FindFirstChild('SodaESP')if sodaFolder:FindFirstChild(soda:GetDebugId()
)then return end local Sphere=Instance.new('SelectionSphere',sodaFolder)Sphere.
Adornee=soda Sphere.Color3=Color3.new(0,0,0)Sphere.Name=soda:GetDebugId()end if
self.Configuration.Expander then local Sodas=fetchSodas()for i,Soda in pairs(
Sodas)do if self.Objects[Soda:GetDebugId()]then continue end Environment:Spoof(
Soda,'Size',Vector3.new(2.1,0.1,2.1))Soda.Size=Vector3.new(5,5,5)self.Objects[
Soda:GetDebugId()]=true end self.Objects['Thread'..Environment:getHash()]=
workspace.ChildAdded:Connect(function(c)if not isSoda(c)then return end
Environment:Spoof(c,'Size',Vector3.new(2.1,0.1,2.1))c.Size=Vector3.new(5,5,5)end
)else local Sodas=fetchSodas()for i,Soda in pairs(Sodas)do Soda.Size=Vector3.
new(2.1,0.1,2.1)end end if self.Configuration.ESP then local ESPFolder=Instance.
new('Folder',gethui())ESPFolder.Name='SodaESP'local Sodas=fetchSodas()for i,Soda
in pairs(Sodas)do addSodaBox(Soda)end self.Objects['Thread'..Environment:
getHash()]=workspace.ChildAdded:Connect(function(c)if not isSoda(c)then return
end addSodaBox(c)end)else if gethui():FindFirstChild('SodaESP')then gethui():
FindFirstChild('SodaESP'):Destroy()end end return true end local
sodaExpanderToggle=Ui.GameTab:Toggle({Title='Soda Expander',Type='Toggle',Value=
false,Callback=function(state:boolean)Soda.Configuration.Expander=state local
Response=Soda({Enabled=state})end})local sodaViewToggle=Ui.GameTab:Toggle({Title
='View Sodas',Type='Toggle',Value=false,Callback=function(state:boolean)Soda.
Configuration.ESP=state local Response=Soda({Enabled=state})end})return Soda end
function __Brew.j():typeof(__modImpl())local v=__Brew.cache.j if not v then v={c
=__modImpl()}__Brew.cache.j=v end return v.c end end do local function __modImpl
()local Services=__Brew.b()local Ui=__Brew.e()local Core=__Brew.f()local
Environment=__Brew.c()local desyncToggle local function rakhook(packet)if packet
.PacketId==161 then local buf=packet.AsBuffer buffer.writeu32(buf,1,0xffffffff)
packet:SetData(buf)end end local Desync={}Desync.Enabled=false Desync.Cache={}
Desync.Objects={}Desync.Configuration={}Desync.Callback=function(self,data:{[any
]:any},caller:string):boolean if not raknet and self.Enabled then Ui.WindUI:
Popup({Title='Brew v3',Icon='bird',Content=
'Your executor does not support raknet.',Buttons={{Title='Proceed',Icon=
'arrow-right',Variant='Tertiary'}}})return false end if caller=='auto'then
return end if self.Enabled and raknet then Services.Character:BreakJoints()
Services.Player.CharacterAdded:Wait()raknet.add_send_hook(rakhook)else if raknet
then raknet.remove_send_hook(rakhook)end end return true end desyncToggle=Ui.
CharacterRaknetSection:Toggle({Title='Desync',Type='Toggle',Value=false,Callback
=function(state:boolean)local Response=Desync({Enabled=state})end})Ui.
CharacterRaknetSection:Paragraph({Title='About Desync',Desc=
[[Desync uses raknet to block outgoing movement packets, this requires raknet to be present & enabled on your executor, furthermore the behavior can be unexpected as this feature is experimental.]]
,Locked=false})if string.match(identifyexecutor():lower(),'potassium')then Ui.
CharacterRaknetSection:Paragraph({Title='Potassium Guide',Desc=
[[To enable raknet on Potassium, open the executor and head to the options tab, then enable raknet]]
,Locked=false})end if string.match(identifyexecutor():lower(),'delta')then
desyncToggle:Lock()end if not raknet then desyncToggle:Lock()end return Desync
end function __Brew.k():typeof(__modImpl())local v=__Brew.cache.k if not v then
v={c=__modImpl()}__Brew.cache.k=v end return v.c end end do local function 
__modImpl()local Services=__Brew.b()local Ui=__Brew.e()local Core=__Brew.f()
local Environment=__Brew.c()if game.GameId~=3737753748 then return
'Unsupported game!'end local swordDropdown local swordCache={}for i,v in pairs(
Services.Player.PlayerStats.PlayerSwords:GetChildren())do table.insert(
swordCache,v.Name)end local Swords={}Swords.Enabled=false Swords.Cache={}Swords.
Objects={}Swords.Configuration={Index={}}Swords.Callback=function(self,data:{[
any]:any},caller:string):boolean if caller=='closed'then swordDropdown:Select(
swordCache)end if caller=='auto'then return end for i,Sword in pairs(Swords.
Configuration.Index)do if table.find(data,Sword)and not Services.Player.
PlayerStats.PlayerSwords:FindFirstChild(Sword)then local newSword=Instance.new(
'BoolValue',Services.Player.PlayerStats.PlayerSwords)newSword.Value=true
newSword.Name=Sword newSword.Parent=Services.Player.PlayerStats.PlayerSwords
elseif not table.find(data,Sword)then if Services.Player.PlayerStats.
PlayerSwords:FindFirstChild(Sword)then Services.Player.PlayerStats.PlayerSwords:
FindFirstChild(Sword):Destroy()end end end return true end for i,Sword in pairs(
game:GetService('ReplicatedStorage').Assets.Swords:GetChildren())do table.
insert(Swords.Configuration.Index,Sword.Name)end swordDropdown=Ui.GameTab:
Dropdown({Title='Sword Selector',Values=Swords.Configuration.Index,Value=
swordCache,Multi=true,AllowNone=false,Callback=function(option)Swords(option)end
})return Swords end function __Brew.l():typeof(__modImpl())local v=__Brew.cache.
l if not v then v={c=__modImpl()}__Brew.cache.l=v end return v.c end end do
local function __modImpl()local Services=__Brew.b()local Ui=__Brew.e()local Core
=__Brew.f()local Environment=__Brew.c()local Spin={}Spin.Enabled=false Spin.
Cache={}Spin.Objects={}Spin.Configuration={}Spin.Callback=function(self,data:{[
any]:any},caller:string):boolean local Character=Services.Character local
Humanoid=Character:FindFirstChildOfClass('Humanoid')local Root=Character:
FindFirstChild('HumanoidRootPart')repeat Root=Character:FindFirstChild(
'HumanoidRootPart')until Root table.foreach(self.Objects,function(i,conn)if
typeof(conn)=='RBXScriptConnection'then conn:Disconnect()end if typeof(conn)==
'Instance'then conn:Destroy()end end)table.clear(self.Objects)if caller==
'closed'then return end if self.Enabled then local Velocity=Instance.new(
'BodyAngularVelocity')Environment:protectInstance(Velocity)Velocity.Parent=Root
table.insert(self.Objects,Velocity)Velocity.AngularVelocity=Vector3.new(0,75,0)
Velocity.MaxTorque=Vector3.new(0,9e9,0)Velocity.P=1250 end return true end Ui.
CharacterBlatantSection:Toggle({Title='Spin',Type='Toggle',Value=false,Callback=
function(state:boolean)local Response=Spin({Enabled=state})end})return Spin end
function __Brew.m():typeof(__modImpl())local v=__Brew.cache.m if not v then v={c
=__modImpl()}__Brew.cache.m=v end return v.c end end do local function __modImpl
()local Services=__Brew.b()local Ui=__Brew.e()local Core=__Brew.f()local
Environment=__Brew.c()local Anims={}Anims.Enabled=false Anims.Cache={}Anims.
Objects={}Anims.Configuration={Library={'Carpet','BarrelRoll','Spasm','Clone'},
Ids={Carpet='rbxassetid://282574440',BarrelRoll='rbxassetid://136801964',Spasm=
'rbxassetid://33796059',Clone='rbxassetid://215384594'},Playing={}}Anims.
Callback=function(self,data:{[any]:any},caller:string):boolean local Character=
Services.Character local Humanoid:Humanoid=Character:FindFirstChildOfClass(
'Humanoid')local Root=Character:FindFirstChild('HumanoidRootPart')repeat Root=
Character:FindFirstChild('HumanoidRootPart')until Root table.foreach(self.
Objects,function(i,conn)if typeof(conn)=='RBXScriptConnection'then conn:
Disconnect()end if typeof(conn)=='Instance'then if conn.ClassName==
'AnimationTrack'then conn:Stop()end conn:Destroy()end end)table.clear(self.
Objects)if caller=='closed'then return end for i,Anim in pairs(self.
Configuration.Playing)do local Id=self.Configuration.Ids[Anim]local nAnim=
Instance.new('Animation')nAnim.AnimationId=Id local Loaded=Humanoid:
LoadAnimation(nAnim)local Speed=(Anim=='Clone')and 1e7 or 1 Loaded:Play(0.1,1,
Speed)self.Objects[Environment:getHash()]=Loaded end return true end Ui.
CharacterBlatantSection:Dropdown({Title='Animations',Desc=
'Blatant, modifies your hitbox',Values=Anims.Configuration.Library,Value={},
Multi=true,AllowNone=true,Callback=function(table:{any})Anims.Configuration.
Playing=table Anims({Enabled=true})end})return Anims end function __Brew.n():
typeof(__modImpl())local v=__Brew.cache.n if not v then v={c=__modImpl()}__Brew.
cache.n=v end return v.c end end do local function __modImpl()local Services=
__Brew.b()local Ui=__Brew.e()local Core=__Brew.f()local Environment=__Brew.c()
local Error={}Error.Enabled=false Error.Cache={}Error.Objects={}Error.
Configuration={}Error.Callback=function(self,data:{[any]:any},caller:string):
boolean if caller=='auto'then return end error('intentional script design')
return true end Ui.ReachAdvancedTab:Button({Title='Error',Desc=
'features meta experiment',Callback=function(table:{any})Error({Enabled=true})
end})return Error end function __Brew.o():typeof(__modImpl())local v=__Brew.
cache.o if not v then v={c=__modImpl()}__Brew.cache.o=v end return v.c end end
do local function __modImpl()local module={}local Environment=__Brew.c()local
Core=__Brew.f()local Services=__Brew.b()local Ui=__Brew.e()local features={Reach
=__Brew.g(),Speed=__Brew.h(),Tank=__Brew.i(),Soda=__Brew.j(),Raknet=__Brew.k(),
Swords=__Brew.l(),Spin=__Brew.m(),Anims=__Brew.n(),Err=__Brew.o()}for i,file in
listfiles('brew/plugins')do local filename=tostring(file):match('([^/]+)$')if
filename:match('readme.txt')then continue end local moddedEnv=getfenv()moddedEnv
['Services']=Services moddedEnv['Ui']=Ui moddedEnv['Environment']=Environment
moddedEnv['Core']=Core local s,plugin=pcall(loadfile,file)if not s or not plugin
then pNotify('['..filename..']: Failed to load')continue end setfenv(plugin,
moddedEnv)plugin=plugin()if not plugin.Callback then continue end setfenv(plugin
.Callback,moddedEnv)features[filename]=plugin pNotify('['..filename..
']: Loaded successfully')end module.features=features for i,feature in pairs(
features)do if type(feature)~='table'then continue end setmetatable(feature,{
__call=function(self,data:{[any]:any},caller:string)if not data then pNotify(
'[Critical Error]:',i,"provided no data table, so we're ignoring it.")return end
caller=caller or'user'self.Enabled=data.Enabled self.Cache=data if caller~=
'auto'then local s,e=pcall(self.Callback,self,data,caller)if not s then return
pNotify(i..' Error:'..tostring(e))else return e end else local s,e=pcall(self.
Callback,self,self.Cache,caller)if not s then return pNotify(i..'Error:'..
tostring(e))else return e end end end})end local reloadEvent:RBXScriptConnection
reloadEvent=Services.Player.CharacterAdded:Connect(function(c)task.wait(1)for i,
feature in pairs(features)do if type(feature)~='table'then continue end feature(
{Enabled=feature.Enabled},'auto')task.wait()end end)Ui.Window:OnClose(function()
task.wait(1)if gethui():FindFirstChild('WindUI')then return end BRWLD=false
reloadEvent:Disconnect()for i,feature in pairs(features)do if type(feature)~=
'table'then continue end for _,config in pairs(feature.Configuration)do if type(
config)=='boolean'then feature.Configuration[_]=false end end task.spawn(
function()feature.Enabled=false feature({Enabled=false},'closed')end)end end)
return module end function __Brew.p():typeof(__modImpl())local v=__Brew.cache.p
if not v then v={c=__modImpl()}__Brew.cache.p=v end return v.c end end do local 
function __modImpl()local Ui=__Brew.e()local Features=__Brew.p()local module={}
Ui.SettingsTab:Keybind({Title='Reach',Value='R',Callback=function(v)local Module
=Features.features['Reach']Module.reachToggle:Set(not Module.Enabled)if Ui.
keybindNotifications then pNotify('Toggled Reach '..(Module.Enabled and'on'or
'off'))end end})Ui.SettingsTab:Keybind({Title='Speed',Desc=
'Will automatically set your speed to the max (24)',Value='M',Callback=function(
v)local Module=Features.features['Speed']if Module.Configuration.Speed==16 then
Module.Input:Set(24)else Module.Input:Set(16)end Module({Enabled=true})if Ui.
keybindNotifications then pNotify('Toggled Speed '..tostring(Module.Input.Value)
)end end})Ui.SettingsTab:Keybind({Title='Damage Amplification',Value='G',
Callback=function(v)local Module=Features.features['Reach']Module.ampToggle:Set(
not Module.ampToggle.Value)if Ui.keybindNotifications then pNotify(
'Toggled Amplification '..(Module.ampToggle.Value and'on'or'off'))end end})
return module end function __Brew.q():typeof(__modImpl())local v=__Brew.cache.q
if not v then v={c=__modImpl()}__Brew.cache.q=v end return v.c end end end local
module={}if getconnections then for _,conn in pairs(getconnections(game:
GetService('ScriptContext').Error))do conn:Disable()end end if not
LPH_OBFUSCATED then LPH_NO_VIRTUALIZE=function(f)return f end end if not
isfolder('brew')then makefolder('brew')end if not isfolder('brew/plugins')then
makefolder('brew/plugins')end if not isfile('brew/plugins/readme.txt')then
writefile('brew/plugins/readme.txt',
[[visit https://domainsoftware.lol/brew/docs for a plugins guide]])end if BRWLD
then return end BRWLD=true DID=...__Brew.a()__Brew.b()__Brew.c()__Brew.d()__Brew
.f()__Brew.p()__Brew.q()return module