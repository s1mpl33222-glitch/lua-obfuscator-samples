local a={cache={}}do do local b=function()










local b=(getgenv or getfenv or getrenv)()local c=function(

c, d, e)
if type(d)==c then
return d
end

if e~=nil then
if e==true then
e=function(...)return...end
end

return e
end end


return setmetatable({
cloneref=c("function",cloneref,true),
setfpscap=c("function",setfpscap,function(d)
if typeof(b.FPS_CAP_THREAD)=="thread"then
task.cancel(b.FPS_CAP_THREAD)
end

b.FPS_CAP_THREAD=task.spawn(function()
local e=os.clock
local f=task.wait

local g=e()+(1/d)

while true do
f(math.max(g-e(),0))
g=e()+(1/d)
end
end)
end),
gethui=c("function",
gethui or
get_hidden_gui
),
sethiddenproperty=c("function",
sethiddenproperty or
set_hidden_property or
set_hidden_prop
),
gethiddenproperty=c("function",
gethiddenproperty or
get_hidden_property or
get_hidden_prop
),
queueteleport=c("function",
queue_on_teleport or
(syn and syn.queue_on_teleport)or
(fluxus and fluxus.queue_on_teleport)
),
httprequest=c("function",
request or
http_request or
(syn and syn.request)or
(http and http.request)or
(fluxus and fluxus.request)
),
setclipboard=c("function",
setclipboard or
toclipboard or
set_clipboard or
(Clipboard and Clipboard.set)
),
firetouchinterest=c("function",firetouchinterest),
makefolder=c("function",makefolder),
isfolder=c("function",isfolder),
getcustomasset=c("function",
getcustomasset or
getsynasset
),
hookfunction=c("function",hookfunction),
hookmetamethod=c("function",hookmetamethod),
getnamecallmethod=c("function",
getnamecallmethod or
get_namecall_method
),
checkcaller=c("function",checkcaller,
function()return false end
),
newcclosure=c("function",newcclosure),
getgc=c("function",getgc or get_gc_objects),
setthreadidentity=c("function",
setthreadidentity or
syn_context_set or
setthreadcontext or
(syn and syn.set_thread_identity)
),
replicatesignal=c("function",replicatesignal),
getconnections=c("function",
getconnections or
get_signal_cons
),
writefile=c("function",writefile),
readfile=c("function",readfile),
listfiles=c("function",listfiles),
loadstring=c("function",loadstring),
isfile=c("function",isfile,readfile and function(d)
local e,f=pcall(readfile,d)
return e and f~=nil and f~=""
end)
},{
__index=b,
__newindex=function(d,e,f)
b[e]=f
end
})end a.a=function()local c=a.cache.a if not c then c={c=b()}a.cache.a=c end return c.c end end do local b=function()
local b=a.a()

local c="IY-REMAKE-PRIVATEENV"

local d=b[c]or{}
b[c]=d

return d end a.b=function()local c=a.cache.b if not c then c={c=b()}a.cache.b=c end return c.c end end do local b=function()
return{
logText="infinite yield -> %s",
isEnabled=false
}end a.c=function()local c=a.cache.c if not c then c={c=b()}a.cache.c=c end return c.c end end do local b=function()
local b=a.c()
local c=b.logText

local d={}

d.isEnabled=function(e)
return b.isEnabled end


d.enable=function(e)
b.isEnabled=true end


d.disable=function(e)
b.isEnabled=false end


d.log=function(e, f, ...)
if not e:isEnabled()then return end
print(c:format(tostring(f)),...)end


d.debug=function(e, f, ...)
if not e:isEnabled()then return end
print(c:format(tostring(f)),...)end


d.warn=function(e, f)
if not e:isEnabled()then return end
(warn or print)(c:format(tostring(f)))end


d.error=function(e, f, g)
error(c:format(tostring(f)),g)end


d.fail=function(e, f)
e:error("failed to load: "..f)end


d.assert=function(e, f, g)
if not f then
e:error(g)
return
end
return f end


d.expect=function(e, f, g, h)
if not table.find(g,typeof(f))then
e:error((h or"")..` expected '{table.concat(g,", ")}'. got '{typeof(f)}'.`)
end
return f end


return d end a.d=function()local c=a.cache.d if not c then c={c=b()}a.cache.d=c end return c.c end end do local b=function()
local b=a.b()
local c=a.d()

local d={}local e=function(



e)
if type(e)~="table"then return end


if type(e.stop)=="function"then
pcall(e.stop)
end

if e.running~=nil then
e.running=false
end

if typeof(e.thread)=="thread"then
pcall(task.cancel,e.thread)
end end


d.init=function(f)
if b.screenGui then
b.screenGui:Destroy()
c:log"destroyed old interface"
end

if b.connectionService then
b.connectionService:cleanup()
b.connectionService=nil
c:log"cleaned old connections"
end

for g,h in b.iyGarbages or{}do
e(h)
end

c:log"finished cleanup!"end


return d end a.e=function()local c=a.cache.e if not c then c={c=b()}a.cache.e=c end return c.c end end do local b=function()
return{
action="discord|support|help",
description="Invite to the Infinite Yield discord server.",
run=function(b)
b.executorEnv.setclipboard(b.config.links.discord)
end
}end a.f=function()local c=a.cache.f if not c then c={c=b()}a.cache.f=c end return c.c end end do local b=function()
return{
action="console",
description="Opens the Roblox console",
run=function(b)
b.starterGui:SetCore("DevConsoleVisible",true)
end
}end a.g=function()local c=a.cache.g if not c then c={c=b()}a.cache.g=c end return c.c end end do local b=function()local b=function(
b)
b.fetchService.load("backups/console.luau","iy/oldconsole")()end local c=function(


c, d)
if d==true then
c.fetchService.load("backups/explorer.luau","iy/explorer")()
else
c.fetchService.load("backups/dexPlusPlus.luau","iy/dexPlusPlus")()
end end local d=function(


d, e)
local f=d.fetchService.load("backups/emotes/notify.luau","iy/7yd7/notify.luau")()

local g=e:nextValue()
local h=e:nextValue()

d.fetchService.load("backups/emotes/main.luau","iy/7yd7/emotes.luau"){
notifyFunction=if h~=false then f else function()end,
isMobile=d.isMobile,
keycode=g,
}end local e=function(


e)
e.fetchService.load("backups/cobalt.luau","iy/cobalt")()end local f=function(


f)
f.fetchService.load("backups/remotespy/main.luau","iy/remotespy")()end local g=function(


g)
g.fetchService.load("backups/audiologger.luau","iy/audiologger")()end


return{
{
action="oldconsole",
description="Loads an old-themed Roblox console",
run=function(h)task.spawn(b,h)end
},
{
action="explorer|dex",
description="Opens the dex Explorer",
args={name="load dex by moon",kind="boolean",optional=true},
run=function(h,i)task.spawn(c,h,i:nextValue())end
},
{
action="emotemenu|7yd7",
description="Opens animations/emotes menu By 7yd7",
run=function(h,i)task.spawn(d,h,i)end,
args={
{kind="keycode",name="open menu",optional=true},
{kind="boolean",name="notify",optional=true},
}
},
{
action="cobalt|remotespy|rspy|cspy",
description="Opens Cobalt to intercept incoming and outgoing network traffic",
run=function(h)task.spawn(e,h)end
},
{
action="simplespy|simplespy|sspy",
description="Opens Simple Spy V3 to intercept remote calls from the client to the server",
run=function(h)task.spawn(f,h)end
},
{
action="audiologger|alogger",
description="Opens Edges audio logger",
run=function(h)task.spawn(g,h)end
}
}end a.h=function()local c=a.cache.h if not c then c={c=b()}a.cache.h=c end return c.c end end do local b=function()
return{
action="serverinfo|info|sinfo",
description="Gives you info about the server",
run=function(b)
b.infiniteYield:createInfoMenu()
end
}end a.i=function()local c=a.cache.i if not c then c={c=b()}a.cache.i=c end return c.c end end do local b=function()
local b={
kind="boolean",
name="copy",
optional=true
}local c=function(

c, d, e)
if e==false then
c.executorEnv.setclipboard(d)
else
c:notify(d)
end end


return{
{
action="jobid",
description="Copies the games JobId to your clipboard, or notify",
args=b,
run=function(d,e)
local f=`roblox://placeId={game.PlaceId}&gameInstanceId={game.JobId}`
c(d,f,e:nextValue())
end
},
{
action="placeid",
description="Copies the current place id to your clipboard, or notify",
args=b,
run=function(d,e)
c(d,tostring(game.PlaceId),e:nextValue())
end
},
{
action="gameid",
description="Copies the current game id to your clipboard, or notify",
args=b,
run=function(d,e)
c(d,tostring(game.GameId),e:nextValue())
end
},
{
action="copyplaceid",
description="Copies the current place id to your clipboard",
run=function(d)
local e=d:expectExploit"setclipboard"
if not e then return end

e(tostring(game.PlaceId))
d:notify("Copied","place id copied to your clipboard")
end
},
{
action="copygameid",
description="Copies the current game id to your clipboard",
run=function(d)
local e=d:expectExploit"setclipboard"
if not e then return end

e(tostring(game.GameId))
d:notify("Copied","game id copied to your clipboard")
end
}
}end a.j=function()local c=a.cache.j if not c then c={c=b()}a.cache.j=c end return c.c end end do local b=function()local b=function(


b)
local c=game.CreatorId

if game.CreatorType~=Enum.CreatorType.User then
c=b.groupService:GetGroupInfoAsync(c).Owner.Id
end

return c end


return{
{
action="creatorid",
description="Notify, or copies the creators ID to your clipboard",
args={kind="boolean",name="copy",optional=true},
run=function(c,d)
local e=tostring(b(c))

if d:nextValue()then
c.executorEnv.setclipboard(e)
end

c:notify("Creator Id",`the OwnerId is '{e}'`)
end
},
{
client=true,
action="setcreatorid|setascreator",
description="Sets your userid to the creators ID",
run=function(c,d)
local e=b(c)
c.localPlayer.UserId=e
c:notify("Set ID",`Set UserId to '{e}'`)
end
}
}end a.k=function()local c=a.cache.k if not c then c={c=b()}a.cache.k=c end return c.c end end do local b=function()

return{
action="rejoin|rj",
description="Makes you rejoin the game",
run=function(b)
b.playerService:teleportToJobId(game.JobId)
end
}end a.l=function()local c=a.cache.l if not c then c={c=b()}a.cache.l=c end return c.c end end do local b=function()
return{
action="autorejoin|autorj",
description="Automatically rejoins the server if you get kicked/disconnected",
run=function(b)
if b.privateEnv.autoRejoinConn then
b:notify"auto rejoin is already enabled"
return
end

b.privateEnv.autoRejoinConn=b:connect(b.guiService.ErrorMessageChanged,function()
b:run"rejoin"
end)
end
}end a.m=function()local c=a.cache.m if not c then c={c=b()}a.cache.m=c end return c.c end end do local b=function()



local b=3 local c=function(

c, d, e)
local f=`https://games.roblox.com/v1/games/{d}/servers/Public?sortOrder=Asc&limit=100`
if e then
f=f.."&cursor="..e
end

local g=c{Url=f,Method="GET"}
return game:GetService"HttpService":JSONDecode(g.Body)end


return{
{
action="serverhop|shop",
description="Teleports you to a different server",
run=function(d)
local e=d:expectExploit"httprequest"
if not e then return end

d:notify("Serverhop","looking for a server with free space...")

task.spawn(function()
local f={}
local g

for h=1,b do
local i,j=pcall(c,e,game.PlaceId,g)
if not i or type(j)~="table"then break end

for k,l in j.data or{}do
if l.id~=game.JobId and l.playing<l.maxPlayers then
table.insert(f,l.id)
end
end

g=j.nextPageCursor
if not g then break end
end

if#f==0 then
d:notify("Serverhop","no other server with free space was found")
return
end

d.playerService:teleportToJobId(f[math.random(1,#f)])
end)
end
}
}end a.n=function()local c=a.cache.n if not c then c={c=b()}a.cache.n=c end return c.c end end do local b=function()

return{
action="selfkick|kickmyself",
description="Kick your self from the server",
args={
kind="string",
name="kick message",
optional=true
},
run=function(b,c)
local d=c:nextValue()
b.localPlayer:Kick(d)
end
}end a.o=function()local c=a.cache.o if not c then c={c=b()}a.cache.o=c end return c.c end end do local b=function()
local b=tostring(game.PlaceId)
local c=tostring(game.JobId)

return{
{
action="gameteleport|gametp",
description="Joins a game by ID",
args={
kind="number",
name="place id",
options={b}
},
run=function(d,e)
d.teleportService:Teleport(e:nextValue())
end
},
{
action="teleportjobid|tpjobid",
description="Joins a game by jobid",
args={
{
kind="string",
name="job id",
options={c}
},
{
kind="number",
name="place id",
options={b},
optional=true
}
},
run=function(d,e)
local f=e:nextValue()or game.JobId
local g=e:nextValue()or game.PlaceId

d.playerService:teleportToJobId(f,g)
end
}
}end a.p=function()local c=a.cache.p if not c then c={c=b()}a.cache.p=c end return c.c end end do local b=function()
return{
action="antiafk|antiidle",
description="Prevents the game from kicking you for being idle/afk",
run=function(b)
local c=b.executorEnv.getconnections
local d=b.privateEnv

if d.enabledAntiAfk then
b:notify"anti AFK is already enabled"
return
end

d.enabledAntiAfk=true

if not c then
b.localPlayer.Idled:Connect(function()
b.virtualUser:CaptureController()
b.virtualUser:ClickButton2(Vector2.new())
end)
return
end

for e,f in c(b.localPlayer.Idled)do
local g=f.Disconnect or f.Disable

if g then
g(f)
end
end

b:notify"anti AFK is now enabled"
end
}end a.q=function()local c=a.cache.q if not c then c={c=b()}a.cache.q=c end return c.c end end do local b=function()
return{
action="datalimit",
description="Set outgoing KBPS limit",
args={kind="number",name="KB per second"},
run=function(b,c)
local d=c:nextValue()
b.networkClient:SetOutgoingKBPSLimit(d)
end
}end a.r=function()local c=a.cache.r if not c then c={c=b()}a.cache.r=c end return c.c end end do local b=function()
return{
action="replicationlag|backtrack",
description="Set IncomingReplicationLag",
args={kind="number"},
run=function(b,c)
b.gameNetworkSettings.IncomingReplicationLag=c:nextValue()
end
}end a.s=function()local c=a.cache.s if not c then c={c=b()}a.cache.s=c end return c.c end end do local b=function()
return{
action="setfpscap|fpscap|maxfps",
description="limits your FPS",
args={
kind="number",
min=1,
max=10000
},
run=function(b,c)
local d=c:nextValue()
b.executorEnv.setfpscap(d)
end
}end a.t=function()local c=a.cache.t if not c then c={c=b()}a.cache.t=c end return c.c end end do local b=function()local b=function(
b)
if not b:IsA"PackageLink"then return end

if b.Parent:FindFirstChild"ADpart"then
b.Parent:Destroy()
end

if b.Parent:FindFirstChild"AdGuiAdornee"then
b.Parent.Parent:Destroy()
end end


return{
action="removeads|adblock",
description="Automatically removes ad billboards",
run=function(c)
if c.privateEnv.adBlockConn then return end

for d,e in workspace:GetDescendants()do
b(e)
end

c.privateEnv.adBlockConn=c:connect(workspace.DescendantAdded,function(d)
task.defer(b,d)
end)
end
}end a.u=function()local c=a.cache.u if not c then c={c=b()}a.cache.u=c end return c.c end end do local b=function()


return{
{
action="saveinstance|savegame|saveplace|savep",
description="Uses saveinstance to save the game",
run=function(b)
local c=b:expectExploit"saveinstance"
if not c then return end

b:notify("Saveinstance","saving the game, this can take a while")

task.spawn(function()
local d,e=pcall(c)

if d then
b:notify("Saveinstance","saved")
else
b:notify("Saveinstance",`failed: {tostring(e)}`)
end
end)
end
}
}end a.v=function()local c=a.cache.v if not c then c={c=b()}a.cache.v=c end return c.c end end do local b=function()

return{
action="clearerror",
description="Clears the annoying box and blur when a game kicks you",
run=function(b)
b.guiService:ClearError()
end
}end a.w=function()local c=a.cache.w if not c then c={c=b()}a.cache.w=c end return c.c end end do local b=function()

local b="CoreScripts/NetworkPause"local c=function(

c)
local d=c:collectGarbage"antigameplaypaused"
if d then
d.connection:Disconnect()
end end


return{
{
action="antigameplaypaused",
description="Clears the annoying box shown when a game is loading assets due to network lag",
run=function(d)
c(d)

local e=d.coreGui:FindFirstChild"RobloxGui"
if not e then
d:notify("Anti Pause","RobloxGui was not found")
return
end

local f=d:createGarbage"antigameplaypaused"
f.connection=d:connect(e.ChildAdded,function(g)
if g.Name==b then
g:Destroy()
end
end)

local g=e:FindFirstChild(b)
if g then
g:Destroy()
end
end
},
{
action="unantigameplaypaused",
description="Disables antigameplaypaused",
run=function(d)
c(d)
end
}
}end a.x=function()local c=a.cache.x if not c then c={c=b()}a.cache.x=c end return c.c end end do local b=function()

return{
action="clientantikick|antikick",
description="Prevents localscripts from kicking you (CLIENT)",
run=function(b)
if b.privateEnv.clientAntiKick then
b:notify("Client Antikick","already active")
return
end

local c=b:expectExploit"hookmetamethod"
local d=b:expectExploit"getnamecallmethod"
if not(c and d)then return end

local e=b.localPlayer


local f=b.executorEnv.hookfunction
if f then
pcall(f,e.Kick,function()end)
end

local g
g=c(game,"__index",function(h,i)
if h==e and typeof(i)=="string"and i:lower()=="kick"then
error("Expected ':' not '.' calling member function Kick",2)
end
return g(h,i)
end)

local h
h=c(game,"__namecall",function(i,...)
if i==e and d():lower()=="kick"then
return
end
return h(i,...)
end)

b.privateEnv.clientAntiKick=true
b:notify("Client Antikick","Client anti kick is now active (only effective on localscript kick)")
end
}end a.y=function()local c=a.cache.y if not c then c={c=b()}a.cache.y=c end return c.c end end do local b=function()

return{
action="clientantiteleport|antiteleport",
description="Prevents localscripts from teleporting you (CLIENT)",
run=function(b)
if b.privateEnv.clientAntiTeleport then
b:notify("Client AntiTP","already active")
return
end

local c=b:expectExploit"hookmetamethod"
local d=b:expectExploit"getnamecallmethod"
if not(c and d)then return end

local e=b.teleportService
local f=b.storage.settings
local g=b.executorEnv.checkcaller

local h
h=c(game,"__index",function(i,j)
if i==e and typeof(j)=="string"then
if j:lower()=="teleport"then
error("Expected ':' not '.' calling member function Teleport",2)
elseif j=="TeleportToPlaceInstance"then
error("Expected ':' not '.' calling member function TeleportToPlaceInstance",2)
end
end
return h(i,j)
end)

local i
i=c(game,"__namecall",function(j,...)
if j==e and not g()then
local k=d()
if k:lower()=="teleport"or k=="TeleportToPlaceInstance"then


local l=...
local m=f:getValue"allowRejoin"==true and l==game.PlaceId
if not m then return end
end
end
return i(j,...)
end)

b.privateEnv.clientAntiTeleport=true
b:notify("Client AntiTP","Client anti teleport is now active (only effective on localscript teleport)")
end
}end a.z=function()local c=a.cache.z if not c then c={c=b()}a.cache.z=c end return c.c end end do local b=function()

return{
client=true,
action="allowrejoin|allowrj",
description="Changes if antiteleport allows you to rejoin or not",
args={kind="boolean",name="allow",optional=true},
run=function(b,c)
local d=c:nextValue()


if d==nil then
d=not b.storage.settings:getValue"allowRejoin"
end

b.storage.settings:setValue("allowRejoin",d)
b:notify("Client AntiTP",`Scripts now {d and"may"or"may not"} make you rejoin the server`)
end
}end a.A=function()local c=a.cache.A if not c then c={c=b()}a.cache.A=c end return c.c end end do local b=function()

return{
action="cancelteleport|canceltp",
description="Cancels teleports in progress",
run=function(b)
b.playerService:cancelTween()
b.teleportService:TeleportCancel()
end
}end a.B=function()local c=a.cache.B if not c then c={c=b()}a.cache.B=c end return c.c end end do local b=function()

return{
action="volume|vol",
description="Adjusts your game volume on a scale of 0 to 10",
args={
kind="number",
clamp={0,10}
},
run=function(b,c)
local d=1/c:nextValue()
b.userGameSettings.MasterVolume=d
end
}end a.C=function()local c=a.cache.C if not c then c={c=b()}a.cache.C=c end return c.c end end do local b=function()
local b={
BasePart={
CastShadow=false,
Material=Enum.Material.Plastic,
Reflectance=0,
BackSurface=Enum.SurfaceType.SmoothNoOutlines,
BottomSurface=Enum.SurfaceType.SmoothNoOutlines,
FrontSurface=Enum.SurfaceType.SmoothNoOutlines,
LeftSurface=Enum.SurfaceType.SmoothNoOutlines,
RightSurface=Enum.SurfaceType.SmoothNoOutlines,
TopSurface=Enum.SurfaceType.SmoothNoOutlines
},
Decal={
Transparency=1,
Texture=""
},
ParticleEmitter={
Lifetime=NumberRange.new(0)
},
Trail={
Lifetime=NumberRange.new(0)
},
PostEffect={
Enabled=false
}
}

local c={
"ForceField",
"Sparkles",
"Smoke",
"Fire",
"Beam"
}local d=function(

d)
local e=workspace:FindFirstChildWhichIsA"Terrain"
local f=d.rbxServices.Lighting

e.WaterWaveSize=0
e.WaterWaveSpeed=0
e.WaterReflectance=0
e.WaterTransparency=1

f.GlobalShadows=false
f.FogEnd=9e9
f.FogStart=9e9

d.gameSettings.Rendering.QualityLevel=1

for g,h in game:GetDescendants()do
for i,j in b do
if not h:IsA(i)then continue end
for k,l in j do
h[k]=l
end
end
end

d:connect(workspace.DescendantAdded,function(g)
if g:IsA"BasePart"then
BasePart.CastShadow=false
return
end

for h,i in c do
if not g:IsA(i)then continue end

task.defer(function()
g:Destroy()
end)
end
end)end


return{
action="antilag|boostfps|lowgraphics",
description="Lowers game quality to boost FPS",
run=function(e)
if e.privateEnv.antiLagEnabled then
e:notify"anti lag is already enabled"
return
end

e.privateEnv.antiLagEnabled=true
d(e)
end
}end a.D=function()local c=a.cache.D if not c then c={c=b()}a.cache.D=c end return c.c end end do local b=function()
return{
{
action="record|rec",
description="Starts Roblox recorder",
run=function(b)
b.coreGui:ToggleRecording()
end
},
{
action="screenshot|scrnshot",
description="Takes a screenshot",
run=function(b)
b.coreGui:TakeScreenshot()
end
},
{
action="togglefullscreen|togglefs",
description="Toggles fullscreen",
run=function(b)
b.guiService:ToggleFullscreen()
end
}
}end a.E=function()local c=a.cache.E if not c then c={c=b()}a.cache.E=c end return c.c end end do local b=function()
local b={}
b.__index=b

b.next=function(c)
local d=c.index
c.index=c.index+1

return c.args[d]end


b.nextValue=function(c)
local d=c:next()
return d and d.value end


b.new=function(c)
for d,e in c do
local f=e.argData









end

return setmetatable({
args=c,
index=1
},b)end


return b end a.F=function()local c=a.cache.F if not c then c={c=b()}a.cache.F=c end return c.c end end do local b=function()
local b=a.F()

return{
action="lastcommand|lastcmd",
description="Executes the previous command used",
run=function(c)
local d=c.privateEnv.lastCommand
if not d then
c:notify("Last Command","no command was used yet")
return
end

c:run(d.name,b.new(d.args),true)
end
}end a.G=function()local c=a.cache.G if not c then c={c=b()}a.cache.G=c end return c.c end end do local b=function()

return{
action="notifyping|ping",
description="Notify yourself your ping",
run=function(b)
local c=b.localPlayer:GetNetworkPing()
b:notify("Ping",`{math.round(c*1000)}ms`)
end
}end a.H=function()local c=a.cache.H if not c then c={c=b()}a.cache.H=c end return c.c end end do local b=function()
return{
{
action="norender",
description="Disable 3d Rendering to decrease the amount of CPU the client uses",
run=function(b)
b.runService:Set3dRenderingEnabled(false)
end
},
{
action="render",
description="Enable 3d Rendering",
run=function(b)
b.runService:Set3dRenderingEnabled(true)
end
}
}end a.I=function()local c=a.cache.I if not c then c={c=b()}a.cache.I=c end return c.c end end do local b=function()
return{
{
action="use2022materials|2022materials",
description="Enables 2022 material textures",
run=function(b)
b.rbxServices.MaterialService.Use2022Materials=true
end
},
{
action="unuse2022materials|un2022materials",
description="Disables 2022 material textures",
run=function(b)
b.rbxServices.MaterialService.Use2022Materials=false
end
}
}end a.J=function()local c=a.cache.J if not c then c={c=b()}a.cache.J=c end return c.c end end do local b=function()
local b={
[Enum.KeyCode.Comma]=-1,
[Enum.KeyCode.Period]=1,
}

return{
{
action="alignmentkeys",
description="Enables the left and right alignment keys (comma and period)",
run=function(c)
local d=c:createGarbage"alignmentkeys"
if not d then return end

d.akConn=c:connect(c.robloxServices.UserInputService.InputBegan,function(e,f)
if f then return end

local g=b[e.KeyCode]
if not g then return end

local h=c.playerService:getCamera()
if not h then return end

h:PanUnits(g)
end)

d.akEmotes=c.starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
c.starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu,false)
end
},
{
action="unalignmentkeys|noalignmentkeys",
description="Disables the alignment keys",
run=function(c)
local d=c:collectGarbage"alignmentkeys"
if not d then return end

if d.akEmotes~=nil then
c.starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu,d.akEmotes)
end

d.akConn:Disconnect()
end
}
}end a.K=function()local c=a.cache.K if not c then c={c=b()}a.cache.K=c end return c.c end end do local b=function()local b=function(
b, c)
local d=b.localPlayer.PlayerScripts
local e=d.PlayerModule.CameraModule.MouseLockController
local f=e:FindFirstChild"BoundKeys"

if not f then
f=Instance.new("StringValue",e)
f.Name="BoundKeys"
end

f.Value=c end


return{
{
action="ctrllock",
description="Binds Shiftlock to LeftControl",
run=function(c)
b(c,"LeftControl")
end
},
{
action="unctrllock",
description="Re-binds Shiftlock to LeftShift",
run=function(c)
b(c,"LeftShift")
end
}
}end a.L=function()local c=a.cache.L if not c then c={c=b()}a.cache.L=c end return c.c end end do local b=function()
return{
action="exit|shutdown|leave",
description="Kills roblox process",
run=function()
game:shutdown()
end
}end a.M=function()local c=a.cache.M if not c then c={c=b()}a.cache.M=c end return c.c end end do local b=function()


return{
action="breakloops|break",
description="Stops any cmd loops (100^1^cmd)",
run=function(b)
b.loopService:stop()
end
}end a.N=function()local c=a.cache.N if not c then c={c=b()}a.cache.N=c end return c.c end end do local b=function()
return{
action="notifyjobid",
description="Notifies the JobId and PlaceId of the current server",
run=function(b)
b:notify("JobId / PlaceId",`{game.JobId} / {game.PlaceId}`)
end
}end a.O=function()local c=a.cache.O if not c then c={c=b()}a.cache.O=c end return c.c end end do local b=function()

local b={}

local c=a.a()
local d=a.d()

b.__index=function(e, f)
d:expect(f,{"string"},"[index] serviceName")

local g=game:GetService(f)
local h=c.cloneref(g)

rawset(e,f,h)
return h end


return setmetatable({},b)end a.P=function()local c=a.cache.P if not c then c={c=b()}a.cache.P=c end return c.c end end do local b=function()
local b=a.P()
return b.Players.LocalPlayer end a.Q=function()local c=a.cache.Q if not c then c={c=b()}a.cache.Q=c end return c.c end end do local b=function()
local b=a.P()
local c=a.Q()
local d=a.d()

local e=b.TeleportService
local f=b.TweenService

local g=c:GetMouse()

local h={}

local i
local j=100
local k

h.getMouse=function(l)
return g end


h.isMouseInGuiObject=function(l, m)
local n=m.AbsolutePosition
local o=m.AbsoluteSize

return g.X>=n.X
and g.X<n.X+o.X
and g.Y>=n.Y
and g.Y<n.Y+o.Y end


h.teleportToJobId=function(l, m, n)
n=n or game.PlaceId
e:TeleportToPlaceInstance(n,m,c)end


h.isAlive=function(l, m)
local n=if m
then m:FindFirstChildOfClass"Humanoid"
else l:getHumanoid()

return n~=nil and n.Health>0 end


h.getCharacter=function(l)
return c.Character end


h.getHumanoid=function(l)
local m=l:getCharacter()
return m and m:FindFirstChildOfClass"Humanoid"end


h.getRootPart=function(l)
local m=l:getHumanoid()
return m and m.RootPart end


h.resetCharacter=function(l)
local m=l:getCharacter()
if not m then return end

local n=m:FindFirstChildOfClass"Humanoid"
if n then
n:ChangeState(Enum.HumanoidStateType.Dead)
else
m:BreakJoints()
end end


h.getPlayersByName=function(l, m)
local n={}

local o=#m
m=m:lower()

for p,q in b.Players:GetPlayers()do
local r=string.lower(q.Name):sub(1,o)
local s=string.lower(q.displayName):sub(1,o)

if r==m or s==m then
table.insert(n,q)
end
end

return n end


h.getCamera=function(l)
return workspace.CurrentCamera end


h.unseat=function(l)
local m=l:getHumanoid()
if not m then return nil end

if m.SeatPart~=nil then
m.Sit=false
task.wait(0.1)
end

return l:getHumanoid()end


h.setRootCFrame=function(l, m)
local n=l:getRootPart()
if not n then return false end

n.CFrame=m
n.AssemblyLinearVelocity=Vector3.zero
return true end


h.teleportTo=function(l, m)
d:expect(m,{"CFrame","Vector3"},"'playerService:teleportTo' #1")

if typeof(m)=="Vector3"then
m=CFrame.new(m)
end

l:unseat()
return l:setRootCFrame(m)end


h.breakVelocity=function(l, m)
local n=l:getCharacter()
if not n then return end

local o=os.clock()+(m or 1)
task.spawn(function()
while os.clock()<o and n.Parent do
for p,q in n:GetDescendants()do
if q:IsA"BasePart"then
q.AssemblyLinearVelocity=Vector3.zero
q.AssemblyAngularVelocity=Vector3.zero
end
end
task.wait()
end
end)end local l=function()



local l=k
k=nil

if l and l.humanoid.Parent then
l.humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,l.wasEnabled)
end end local m=function(


m)
if k and k.humanoid==m then return end

l()
k={
humanoid=m,
wasEnabled=m:GetStateEnabled(Enum.HumanoidStateType.Seated)
}
m:SetStateEnabled(Enum.HumanoidStateType.Seated,false)end


h.cancelTween=function(n)
local o=i
i=nil

l()

if o then
o:Cancel()
return true
end

return false end


h.tweenTeleportTo=function(n, o)
d:expect(o,{"table"},"'playerService:tweenTeleportTo' #1")

local p=o.target
local q=o.speed or j

d:expect(p,{"CFrame","Vector3"},"'playerService:tweenTeleportTo' config.target")
d:expect(q,{"number"},"'playerService:tweenTeleportTo' config.speed")

if typeof(p)=="Vector3"then
p=CFrame.new(p)
end

n:unseat()

local r=n:getRootPart()
if not r then return nil end

local s=(p.Position-r.Position).Magnitude
local t=s/math.max(q,1)

local u=i
i=nil
if u then
u:Cancel()
end

local v=n:getHumanoid()
if v then
m(v)
end

local w=TweenInfo.new(t,Enum.EasingStyle.Linear)
local x=f:Create(r,w,{
CFrame=p
})

i=x
x.Completed:Once(function()
if i~=x then return end

i=nil
l()
n:breakVelocity()
end)

x:Play()
return x end


h.waitForStreamPlayerCharacter=function(n, o, p)
if not(o and workspace.StreamingEnabled)then return end

local q=o:GetPivot().Position
p=p or 5

task.spawn(c.RequestStreamAroundAsync,c,q,p)
o:WaitForChild("HumanoidRootPart",p)end


return h end a.R=function()local c=a.cache.R if not c then c={c=b()}a.cache.R=c end return c.c end end do local b=function()

local b=a.P()
local c=a.R()
local d=a.Q()local e=function(







e)
for f=#e,2,-1 do
local g=math.random(1,f)
e[f],e[g]=e[g],e[f]
end
return e end local f=function(


f)
local g=f.Character
return g and g:FindFirstChildOfClass"Humanoid"end local g=function(


g)
local h=g.Character
return h and h:FindFirstChild"HumanoidRootPart"end local h=function(


h)
local i=f(h)
return i~=nil and i.Health>0 end local i=function(



i)
local j=g(d)
local k=g(i)
if not(j and k)then return nil end

return(k.Position-j.Position).Magnitude end local j=function(


j, k)
local l={}
for m,n in j do
if k(n)then
table.insert(l,n)
end
end
return l end local k=function(


k)
return j(k,function(l)
return l~=d
end)end local l=function(


l)
return d.Team~=nil and l.Team==d.Team end local m=function(


m)
local n=f(m)
if not n then return false end

for o,p in n:GetAccessories()do
local q=p.Name:lower()
if q:find("bacon",1,true)or q:find("pal hair",1,true)then
return true
end
end
return false end local n=function(



n, o)
local p
local q

for r,s in k(n)do
local t=i(s)
if t then
local u=q==nil
or(o and t>q)
or(not o and t<q)

if u then
p,q=s,t
end
end
end

if p then
return{p}
end
return{}end


local o={
me=function()
return{d}
end,
all=function(o)
return o
end,
others=function(o)
return k(o)
end,
random=function(o)
if#o==0 then return{}end
return{o[math.random(1,#o)]}
end,
allies=function(o)
return j(o,l)
end,
team=function(o)
return j(o,l)
end,
enemies=function(o)
return j(k(o),function(p)
return not l(p)
end)
end,
nonteam=function(o)
return j(k(o),function(p)
return not l(p)
end)
end,
friends=function(o)
return j(k(o),function(p)
return d:IsFriendsWith(p.UserId)
end)
end,
nonfriends=function(o)
return j(k(o),function(p)
return not d:IsFriendsWith(p.UserId)
end)
end,
guests=function(o)
return j(o,function(p)
return p.UserId<=0
end)
end,
bacons=function(o)
return j(o,m)
end,
alive=function(o)
return j(o,h)
end,
dead=function(o)
return j(o,function(p)
return not h(p)
end)
end,
nearest=function(o)
return n(o,false)
end,
farthest=function(o)
return n(o,true)
end,
}

local p={
{
pattern="^#(%d+)$",
handler=function(p,q)
local r=e(p)
return table.move(r,1,math.min(tonumber(q),#r),1,{})
end,
},
{
pattern="^@(.+)$",
handler=function(p,q)

return j(p,function(r)
return r.Name:lower():sub(1,#q)==q
end)
end,
},
{
pattern="^%%(.+)$",
handler=function(p,q)
return j(p,function(r)
local s=r.Team
return s~=nil and s.Name:lower():sub(1,#q)==q
end)
end,
},
{
pattern="^age(%d+)$",
handler=function(p,q)
local r=tonumber(q)
return j(p,function(s)
return s.AccountAge<=r
end)
end,
},
{
pattern="^rad(%d+)$",
handler=function(p,q)
local r=tonumber(q)
return j(k(p),function(s)
local t=i(s)
return t~=nil and t<=r
end)
end,
},
{
pattern="^group(%d+)$",
handler=function(p,q)
local r=tonumber(q)
return j(p,function(s)
return s:IsInGroup(r)
end)
end,
},
}local q=function(


q)
local r=(q or"me"):lower()
if o[r]then return true end

for s,t in p do
if r:match(t.pattern)then return true end
end
return false end local r=function(



r)
return r:match"^%s*(.-)%s*$"end local s=function(



s, t)
local u=s:lower()

local v=o[u]
if v then
return v(t)
end

for w,x in p do
local y=u:match(x.pattern)
if y then
return x.handler(t,y)
end
end

return c:getPlayersByName(s)end local t=function(



t, u)
local v={}
local w={}

for x,y in t do
if not v[y]then
v[y]=true
table.insert(w,y)
end
end

for x,y in u do
if not v[y]then
v[y]=true
table.insert(w,y)
end
end

return w end local u=function(



u, v)
local w={}
for x,y in v do
w[y]=true
end

return j(u,function(x)
return not w[x]
end)end local v=function(




v)
local w={}
local x="+"
local y={}

for z=1,#v do
local A=v:sub(z,z)

if A=="+"or A=="-"then
table.insert(w,{op=x,term=r(table.concat(y))})
y={}
x=A
else
table.insert(y,A)
end
end

table.insert(w,{op=x,term=r(table.concat(y))})
return w end local w=function(




w, x)
local y=v(w)
local z=y[1]
local A={}

if z.term~=""then
A=s(z.term,x)
elseif y[2]and y[2].op=="-"then
A=table.clone(x)
end

for B=2,#y do
local C=y[B]
local D={}

if C.term~=""then
D=s(C.term,x)
end

if C.op=="+"then
A=t(A,D)
else
A=u(A,D)
end
end

return A end local x=function(



x)
local y={}

for z in x:gmatch"[^,]+"do
local A=r(z)

if A~=""then
table.insert(y,A)
end
end

return y end local y=function(



y)
return y~=nil and y:find"[,+%-]"~=nil end local z=function(




z)
local A=z or"me"
local B=b.Players:GetPlayers()
local C=s(r(A),B)

if#C>0 then
return C
end

if not y(A)then

return c:getPlayersByName(r(A))
end

local D={}

for E,F in x(A)do
D=t(D,w(F,B))
end

return D end



return setmetatable({
isSelector=q,
hasOperators=y,
parts=x,
},{
__call=function(A,B)
return z(B)
end,
})end a.S=function()local c=a.cache.S if not c then c={c=b()}a.cache.S=c end return c.c end end do local b=function()

local b=a.S()

return{
{
action="copyid|copyuserid",
description="Copies a player's user ID to your clipboard",
args={kind="player",optional=true},
run=function(c,d)
for e,f in b(d:nextValue())do
c.executorEnv.setclipboard(tostring(f.UserId))
end
end
},
{
action="appearanceid|aid",
description="Notifies a player's character appearance ID",
args={kind="player",optional=true},
run=function(c,d)
for e,f in b(d:nextValue())do
c:notify("Appearance ID",tostring(f.CharacterAppearanceId))
end
end
},
{
action="copyappearanceid|caid",
description="Copies a player's character appearance ID to your clipboard",
args={kind="player",optional=true},
run=function(c,d)
for e,f in b(d:nextValue())do
c.executorEnv.setclipboard(tostring(f.CharacterAppearanceId))
end
end
},
{
action="copycreatorid|copycreator",
description="Copies the game creator's user ID to your clipboard",
run=function(c)
local d=game.CreatorId

if game.CreatorType==Enum.CreatorType.Group then
d=c.groupService:GetGroupInfoAsync(d).Owner.Id
elseif game.CreatorType~=Enum.CreatorType.User then
return
end

c.executorEnv.setclipboard(tostring(d))
c:notify("Copied ID","Copied creator ID to clipboard")
end
}
}end a.T=function()local c=a.cache.T if not c then c={c=b()}a.cache.T=c end return c.c end end do local b=function()

return{
action="inviteprompt",
description="Prompts the game invite window, so you can invite friends",
run=function(b)
local c=game:GetService"SocialService"

local d,e=pcall(function()
c:PromptGameInvite(b.localPlayer)
end)

if not d then
b:notify("Invite Prompt","could not open the invite prompt: "..tostring(e))
end
end
}end a.U=function()local c=a.cache.U if not c then c={c=b()}a.cache.U=c end return c.c end end do local b=function()

local b={inventory=
Enum.CoreGuiType.Backpack,leaderboard=
Enum.CoreGuiType.PlayerList,emotes=
Enum.CoreGuiType.EmotesMenu
}

for c,d in Enum.CoreGuiType:GetEnumItems()do
b[string.lower(d.Name)]=d
end local c=function(

c, d, e)
if d=="reset"then
c.starterGui:SetCore("ResetButtonCallback",e)
return
end

local f=b[d]
if f then
c.starterGui:SetCoreGuiEnabled(f,e)
end end


return{
{
action="enable",
description="Enables a CoreGui element (inventory, leaderboard, chat, reset, emotes...)",
args={kind="string",name="gui name"},
run=function(d,e)
c(d,e:nextValue():lower(),true)
end
},
{
action="disable",
description="Disables a CoreGui element (inventory, leaderboard, chat, reset, emotes...)",
args={kind="string",name="gui name"},
run=function(d,e)
c(d,e:nextValue():lower(),false)
end
}
}end a.V=function()local c=a.cache.V if not c then c={c=b()}a.cache.V=c end return c.c end end do local b=function()

return{
action="clearnilinstances|nonilinstances|cni",
description="Destroys every nil instance (needs getnilinstances)",
run=function(b)
if not getnilinstances then
b:notify("Incompatible Exploit","Your exploit does not support this command (missing getnilinstances)")
return
end

for c,d in getnilinstances()do
d:Destroy()
end
end
}end a.W=function()local c=a.cache.W if not c then c={c=b()}a.cache.W=c end return c.c end end do local b=function()

return{
action="mousesensitivity|ms",
description="Sets your mouse delta sensitivity",
args={kind="number",name="sensitivity"},
run=function(b,c)
b.robloxServices.UserInputService.MouseDeltaSensitivity=c:nextValue()
end
}end a.X=function()local c=a.cache.X if not c then c={c=b()}a.cache.X=c end return c.c end end do local b=function()

local b=a.S()

return{
{
action="friend",
description="Sends a friend request to a player",
args={kind="player"},
run=function(c,d)
for e,f in b(d:nextValue())do
c.localPlayer:RequestFriendship(f)
end
end
},
{
action="unfriend",
description="Removes a player from your friends",
args={kind="player"},
run=function(c,d)
for e,f in b(d:nextValue())do
c.localPlayer:RevokeFriendship(f)
end
end
}
}end a.Y=function()local c=a.cache.Y if not c then c={c=b()}a.cache.Y=c end return c.c end end do local b=function()local b=function(


b)
local c=b.localPlayer
local d=c.Character
if not d then return end

local e=d:FindFirstChildWhichIsA"Humanoid"
if e then
e:ChangeState(Enum.HumanoidStateType.Dead)
end

d:ClearAllChildren()

local f=Instance.new"Model"
f.Parent=workspace

task.wait()
c.Character=f
task.wait()
c.Character=d
f:Destroy()end


return{
{
action="respawn",
description="Respawns your character in place (client side)",
run=function(c)
b(c)
end
},
{
action="refresh|re",
description="Respawns your character and puts you back where you were",
run=function(c)
local d=c.playerService:getRootPart()
if not d then return end

local e=c.localPlayer
local f=d.CFrame
local g=workspace.CurrentCamera.CFrame

b(c)

task.spawn(function()
local h=e.CharacterAdded:Wait()
local i=h:WaitForChild("HumanoidRootPart",10)
if not i then return end

i.CFrame=f
workspace.CurrentCamera.CFrame=g
end)
end
},
{
action="reset",
description="Resets your character",
run=function(c)
c.playerService:resetCharacter()
end
}
}end a.Z=function()local c=a.cache.Z if not c then c={c=b()}a.cache.Z=c end return c.c end end do local b=function()

local b=a.d()

return{
action="debug",
description="Turns the debug logger on or off (default is on)",
args={kind="boolean",name="enabled",optional=true},
run=function(c,d)
local e=d:nextValue()
if e==nil then
e=true
end

if e then
b:enable()
else
b:disable()
end

c:notify("debug",tostring(e))
end
}end a._=function()local c=a.cache._ if not c then c={c=b()}a.cache._=c end return c.c end end do local b=function()

return{
{
action="team",
description="Changes your team. Sometimes fools localscripts. (CLIENT)",
args={
kind="team"
},
run=function(b,c)
local d=c:nextValue()
local e=b.robloxServices.Teams:FindFirstChild(d)
if not e then
b:notify("Invalid Team",tostring(d).." is not a valid team")
return
end

local f=b.playerService:getRootPart()
local g=b.executorEnv.firetouchinterest


if f and g then
for h,i in workspace:GetDescendants()do
if i:IsA"SpawnLocation"and i.BrickColor==e.TeamColor and i.AllowTeamChangeOnTouch then
g(i,f,0)
g(i,f,1)
break
end
end
else
b.localPlayer.Team=e
end
end
}
}end a.aa=function()local c=a.cache.aa if not c then c={c=b()}a.cache.aa=c end return c.c end end do local b=function()

local b=a.S()

return{
{
action="handlekill|hkill",
description="Kills a player using tool damage (YOU NEED A TOOL) (TOOL)",
args={
{
kind="player"
},
{
kind="number",
name="radius",
optional=true
}
},
run=function(c,d)
local e=c:expectExploit"firetouchinterest"
if not e then return end

local f=c.playerService:getCharacter()
local g=f and f:FindFirstChildWhichIsA"Tool"
local h=g and g:FindFirstChild"Handle"
if not h then
c:notify("Handle Kill",'You need to hold a "Tool" that does damage on touch.')
return
end

local i=b(d:nextValue())
local j=d:nextValue()or math.huge


local k=c:collectGarbage"handlekill"
if k then
k.running=false
end

local l=c:createGarbage"handlekill"
l.running=true
c:notify("Handle Kill","Started!")


task.spawn(function()
while l.running do
task.wait()

local m=c.playerService:getCharacter()
if not(m and g.Parent==m)then break end

local n=c.playerService:getRootPart()
for o,p in i do
local q=p~=c.localPlayer and p.Character
local r=q and q:FindFirstChildWhichIsA"Humanoid"
local s=q and q:FindFirstChild"HumanoidRootPart"

if n and r and s and r.Health>0 and(n.Position-s.Position).Magnitude<=j then
e(h,s,1)
e(h,s,0)
end
end
end

l.running=false
c:notify("Handle Kill","Stopped!")
end)
end
}
}end a.ab=function()local c=a.cache.ab if not c then c={c=b()}a.cache.ab=c end return c.c end end do local b=function()




local b=0.01 local c=function(

c)
task.wait(math.max(c,b))end local d=function(


d, e)
local f=d:collectGarbage(e)
if not f then return false end

f.running=false
return true end local e=function(



e, f, g, h, i)
d(e,f)

local j=e:createGarbage(f)
j.running=true

task.spawn(function()
while j.running do
i(true)
c(h)
i(false)
c(g)
end
end)end


return{
{
action="autoclick",
description="Automatically clicks your mouse with a set delay",
args={
{
kind="number",
name="click delay"
},
{
kind="number",
name="release delay"
}
},
run=function(f,g)
local h=g:nextValue()or 0.1
local i=g:nextValue()or 0.05

local j=f.robloxServices.VirtualInputManager
e(f,"autoclick",h,i,function(k)
local l=f.playerService:getMouse()
j:SendMouseButtonEvent(l.X,l.Y,0,k,game,0)
end)
end
},
{
action="unautoclick|noautoclick",
description="Turns off autoclick",
run=function(f)
d(f,"autoclick")
end
},
{
action="autokeypress|keypress",
description="Automatically presses a key with a set delay",
args={
{
kind="keycode"
},
{
kind="number",
name="click delay"
},
{
kind="number",
name="release delay"
}
},
run=function(f,g)
local h=g:nextValue()
local i=g:nextValue()or 0.1
local j=g:nextValue()or 0.05

local k=f.robloxServices.VirtualInputManager
e(f,"autokeypress",i,j,function(l)
k:SendKeyEvent(l,h,false,game)
end)
end
},
{
action="unautokeypress|noautokeypress|unkeypress|nokeypress",
description="Stops autokeypress",
run=function(f)
d(f,"autokeypress")
end
}
}end a.ac=function()local c=a.cache.ac if not c then c={c=b()}a.cache.ac=c end return c.c end end do local b=function()




local b=a.P()
local c=b.Players

local d="Rolewatch"
local e="Staffwatch"
local f={"admin","mod","staff","owner","dev","support","manager"}local g=function(


g, h)
local i,j=pcall(function()
return g:GetRoleInGroup(h)
end)
return if i then j else nil end local h=function(


h, i)
local j=h:collectGarbage(i)
if not j then return false end

if j.connection then
j.connection:Disconnect()
end
return true end local i=function(




i, j, k)
if k==i.localPlayer then return end

local l=g(k,j.groupId)
if not l or l:lower()~=j.roleName then return end

i:notify(d,`{k.Name} has the role '{l}'`)

if i.privateEnv.rolewatchLeave then
i.localPlayer:Kick"rolewatch: a watched player joined"
end end local j=function(




j)
if game.CreatorType~=Enum.CreatorType.Group then
return j.UserId==game.CreatorId
end

local k=g(j,game.CreatorId)
if not k or k=="Guest"then return false end

local l=k:lower()
for m,n in f do
if l:find(n,1,true)then
return true
end
end
return false end


return{
{
action="rolewatch",
description="Notify if someone from a watched group joins the server",
args={
{
kind="number",
name="group id"
},
{
kind="string",
name="role name"
}
},
run=function(k,l)
local m=l:nextValue()
local n=l:nextValue()

h(k,"rolewatch")

local o=k:createGarbage"rolewatch"
o.groupId=m
o.roleName=n:lower()

for p,q in c:GetPlayers()do
i(k,o,q)
end

o.connection=k:connect(c.PlayerAdded,function(p)
i(k,o,p)
end)

k:notify(d,`watching for the role '{n}' in group {m}`)
end
},
{
action="rolewatchstop|unrolewatch",
description="Disable Rolewatch",
run=function(k)
if h(k,"rolewatch")then
k:notify(d,"disabled")
end
end
},
{
action="rolewatchleave",
description="Toggle if you should leave the game if someone from a watched group joins the server",
run=function(k)
local l=not k.privateEnv.rolewatchLeave
k.privateEnv.rolewatchLeave=l
k:notify(d,if l then"you will leave when a watched player joins"else"you will stay when a watched player joins")
end
},
{
action="staffwatch",
description="Notify if a staff member of the game joins the server",
run=function(k)
h(k,"staffwatch")

local l=k:createGarbage"staffwatch"local m=function(

m)
if m~=k.localPlayer and j(m)then
k:notify(e,`staff member {m.Name} is in the server`)
end end


for n,o in c:GetPlayers()do
m(o)
end

l.connection=k:connect(c.PlayerAdded,m)
k:notify(e,"watching for staff")
end
},
{
action="unstaffwatch",
description="Disable Staffwatch",
run=function(k)
if h(k,"staffwatch")then
k:notify(e,"disabled")
end
end
},
{
action="findfriendgroups",
description="Notifies you if any players are friends with each other",
run=function(k)
local l=c:GetPlayers()
local m={}

for n=1,#l do
for o=n+1,#l do
local p,q=l[n],l[o]

local r,s=pcall(function()
return p:IsFriendsWith(q.UserId)
end)

if r and s then
table.insert(m,`{p.Name} & {q.Name}`)
end
end
end

if#m==0 then
k:notify("Friend groups","no friends were found between the players in this server")
else
k:notify("Friend groups",table.concat(m,", "))
end
end
}
}end a.ad=function()local c=a.cache.ad if not c then c={c=b()}a.cache.ad=c end return c.c end end do local b=function()




return{
{
action="clickdelete",
description="Go to Settings > Keybinds > Add for click delete",
run=function(b)
local c=b.playerService:getMouse().Target
local d=b.playerService:getCharacter()

if not c then
b:notify("Click delete","nothing under the mouse")
return
end

if c:IsA"Terrain"then
b:notify("Click delete","terrain cannot be deleted")
return
end

if d and c:IsDescendantOf(d)then
b:notify("Click delete","that part belongs to your character")
return
end

local e=c:GetFullName()
c:Destroy()
b:notify("Click delete",`deleted {e}`)
end
},
{
action="clickteleport",
description="Go to Settings > Keybinds > Add for click teleport",
run=function(b)
b:run"mousetp"
end
}
}end a.ae=function()local c=a.cache.ae if not c then c={c=b()}a.cache.ae=c end return c.c end end do local b=function()local b=function(


b, c)
local d=b.playerService:getHumanoid()
if not d then
b:notify("Rig","your character is not loaded")
return
end

local e=b.robloxServices.AvatarEditorService

task.spawn(function()
e:PromptSaveAvatar(d.HumanoidDescription,Enum.HumanoidRigType[c])

local f=e.PromptSaveAvatarCompleted:Wait()
if f==Enum.AvatarPromptResult.Success then
b:run"reset"
end
end)end


return{
{
action="promptr6",
description="Prompts the game to switch your rig type to R6",
run=function(c)
b(c,"R6")
end
},
{
action="promptr15",
description="Prompts the game to switch your rig type to R15",
run=function(c)
b(c,"R15")
end
}
}end a.af=function()local c=a.cache.af if not c then c={c=b()}a.cache.af=c end return c.c end end do local b=function()

return{a.f()
,a.g()
,a.h()
,a.i()
,a.j()
,a.k()
,a.l()
,a.m()
,a.n()
,a.o()
,a.p()
,a.q()
,a.r()
,a.s()
,a.t()
,a.u()
,a.v()
,a.w()
,a.x()
,a.y()
,a.z()
,a.A()
,a.B()
,a.C()
,a.D()
,a.E()
,a.G()
,a.H()
,a.I()
,a.J()
,a.K()
,a.L()
,a.M()
,a.N()

,a.O()
,a.T()
,a.U()
,a.V()
,a.W()
,a.X()
,a.Y()
,a.Z()
,a._()
,a.aa()
,a.ab()
,a.ac()
,a.ad()
,a.ae()
,a.af()

}end a.ag=function()local c=a.cache.ag if not c then c={c=b()}a.cache.ag=c end return c.c end end do local b=function()

local b=a.d()

local c={}
c.__index=c

c.encrypt=function(d, e)
b:expect(e,{"string"},"'encryptor:encrypt' #1")
local f=d.encryptKey
local g={}

for h=1,#e do
f=(f*16807)%2147483647
table.insert(g,string.format("%02X",(e:byte(h)+f%256)%256))
end

return table.concat(g)end


c.decrypt=function(d, e, f)
b:expect(e,{"string"},"'encryptor:decrypt' #1")
local g=d.encryptKey
local h={}

for i=1,#e,2 do
local j=tonumber(e:sub(i,i+1),16)
g=(g*16807)%2147483647
h[#h+1]=string.char((j-g%256+256)%256)
end

return table.concat(h)end


c.new=function(d)
b:expect(d,{"number"},"'encryptor.new' #1")

return setmetatable({
encryptKey=d
},c)end


return c end a.ah=function()local c=a.cache.ah if not c then c={c=b()}a.cache.ah=c end return c.c end end do local b=function()
local b=a.P()
local c=a.d()

local d=b.HttpService
local e=d.JSONEncode
local f=d.JSONDecode

return{
encode=function(g,h)
local i,j=pcall(e,d,g)

if not i then
c:warn(`failed to encode json '{h or"unknown"}': {j}`)
return nil
end

return j
end,
decode=function(g,h)
local i,j=pcall(f,d,g)

if not i then
c:warn(`failed to decode json '{h or"unknown"}': {j}`)
return nil
end

return j
end
}end a.ai=function()local c=a.cache.ai if not c then c={c=b()}a.cache.ai=c end return c.c end end do local b=function()
return{
privateFolder="infiniteYield",
imagePath="assets/%s.png",
encryptKey=676767
}end a.aj=function()local c=a.cache.aj if not c then c={c=b()}a.cache.aj=c end return c.c end end do local b=function()
local b=a.a()

local c=a.ah()
local d=a.d()
local e=a.ai()

local f=a.aj()

local g=f.privateFolder
local h=f.encryptKey

c=c.new(h)

if g:sub(#g)=="/"then
g=g:sub(1,-2)
end

local i={}
i.__index=i local j=function(

j)
local k,l=pcall(b.isfile,j)

if k and type(l)=="boolean"then
return l
end

return false end local k=function(


k)
local l,m=pcall(b.isfolder,k)

if l and type(m)=="boolean"then
return m
end

return false end local l=function(


l)
if not j(l)then
d:log(`the file '{l}' don't exist, skipped!`)
return""
end

local m,n=pcall(b.readfile,l)

if not m then
d:warn(`failed to read file '{l}':\n\t{n}`)
n=nil
end

if type(n)~="string"then
n=""
end

return n end local m=function(


m)
local n=m:split"/"
local o={}

for p,q in n do
table.insert(o,q)

local r=table.concat(o,"/")
if k(r)then continue end

local s,t=pcall(b.makefolder,r)

if not s then
d:warn(`failed to create a folder '{r}':\n\t{t}`)
end
end end local n=function(


n, o)
local p,q=pcall(b.writefile,n,o)

if p then
d:log(`successfully writed the file '{n}'!`)
else
d:warn(`failed to write file '{n}':\n\t{q}`)
end end local o=function(


o)
local p,q=pcall(b.getcustomasset,o)

if not(p and type(q)=="string")then
d:warn(`failed to get custom asset '{o}':\n\t{q}`)
return
end

return q end local p=function(


p)
local q=string.split(p,"/")
local r=table.remove(q)

return table.concat(q,"/"),r end


i.getRealPath=function(q, r)
if r:sub(1,1)~="/"then
r="/"..r
end

r=g..r
return r end


i.deep=function(q, r)
local s=q.object
local t=r:split"."
local u=table.remove(t)

for v,w in t do
local x=s[w]
if type(x)~="table"then x={}end
s[w]=x
s=x
end

return s,u end


i.setValue=function(q, r, s)
local t,u=q:deep(r)
t[u]=s end


i.getValue=function(q, r)
local s,t=q:deep(r)
return s[t]end


i.hasValue=function(q, r)
return q:getValue(r)~=nil end


i.increment=function(q, r, s)
return q:setValue(r,(q:getValue(r)or 0)+s)end


i.exist=function(q, r)
r=q:getRealPath(r)
return j(r)end


i.writeFile=function(q, r, s)
if q.filePath~=nil then
r,s=q.filePath,r
else
r=q:getRealPath(r)
end

n(r,s)end


i.register=function(q, r, s)
local t=q:getValue(r)

if typeof(t)~=typeof(s)then
t=s
q:setValue(r,t)
end

return t end


i.add=function(q, r, s)
local t=q:getValue(r)
d:expect(t,{"table"},"'userData:add' #1")

if not table.find(t,s)then
table.insert(t,s)
end end


i.save=function(q)
if q.isSaving then return end

q.isSaving=true
q.lastSave=tick()

task.delay(1,function()
local r=e.encode(q.object,q.filePath)

if q.encryptData then
r=c:encrypt(r)
end

q.isSaving=false
q:writeFile(r)
end)end


i.getCustomAsset=function(q, r)
r=q:getRealPath(r)
return o(r)end


i.getData=function(q)
return table.clone(q.object)end


i.new=function(q, r)
d:expect(q,{"string"},"'fileSystem.new' #1")
d:expect(r,{"table","nil"},"'fileSystem.new' #2")

if q:sub(-5,-1)~=".json"then
q=q..".json"
end

local s=setmetatable({
object={},
lastSave=0,
isSaving=false,

encryptData=r and r.encrypt
},i)

local t=s:getRealPath(q)
local u=p(t)

s.filePath=t
s.folderPath=u

if#u>0 then
m(u)
end

local v=l(t)

if#v>0 then
if s.encryptData then
v=c:decrypt(v)
end

local w=e.decode(v)

if type(w)~="table"then
d:warn(`the json content has been returned a unexpected value '{t}'`)
return s
end

s.object=w
end

return s end


return i end a.ak=function()local c=a.cache.ak if not c then c={c=b()}a.cache.ak=c end return c.c end end do local b=function()
return a.ak().new"storage/settings"end a.al=function()local c=a.cache.al if not c then c={c=b()}a.cache.al=c end return c.c end end do local b=function()
return"v0.6.3"end a.am=function()local c=a.cache.am if not c then c={c=b()}a.cache.am=c end return c.c end end do local b=function()
return{
owner="tlredz",
repository="iy-remake"
}end a.an=function()local c=a.cache.an if not c then c={c=b()}a.cache.an=c end return c.c end end do local b=function()
local b=a.an()

return{
discord="https://discord.gg/78ZuWSq",
github=`https://github.com/{b.owner}/{b.repository}`
}end a.ao=function()local c=a.cache.ao if not c then c={c=b()}a.cache.ao=c end return c.c end end do local b=function()


local b=a.al()

return{
applicationName="Infinite Yield RV",
isRemakeVersion=true,
version=a.am(),
newVersionMessage="You're using an old version of Infinite Yield RV",

theme={
defaultTheme="dark",
selectedTheme=b:register("selectedTheme","dark")
},

commands={
cmdsRank={
maxTimesUsed=5,
decreasePerUse=0.25,
increasePerUse=1,
}
},

ui={
defaultTheme="Dark",
scale={
minScale=0.8,
maxScale=2.0,
current=b:register("interface.uiScale",1)
},
commands={
padding=0,
labelSize=17,
textSize=14,
placeholderText=">_ command bar"
},
window={
windowSize=UDim2.fromOffset(250,220),
draggable=true
}
},

links=a.ao(),
storage=a.aj(),
}end a.ap=function()local c=a.cache.ap if not c then c={c=b()}a.cache.ap=c end return c.c end end do local b=function()
local b=a.ap().ui.scale

return{
action="guiscale|uiscale",
description="Changes the size of the gui. [number] accepts decimals and whole numbers.",
args={
kind="number",
clamp={b.minScale,b.maxScale}
},
run=function(c,d)
local e=d:nextValue()
c.infiniteYield:setScale(e)
end
}end a.aq=function()local c=a.cache.aq if not c then c={c=b()}a.cache.aq=c end return c.c end end do local b=function()
return{
{
action="noprompts|nopurchaseprompts",
description="Prevents the game from showing you purchase/premium prompts",
run=function(b)
b.coreGui.PurchasePromptApp.Enabled=false
end
},
{
action="showprompts|showpurchaseprompts",
description="Allows the game to show purchase/premium prompts again",
run=function(b)
b.coreGui.PurchasePromptApp.Enabled=true
end
}
}end a.ar=function()local c=a.cache.ar if not c then c={c=b()}a.cache.ar=c end return c.c end end do local b=function()
local b={inventory=
Enum.CoreGuiType.Backpack,leaderboard=
Enum.CoreGuiType.PlayerList,emotes=
Enum.CoreGuiType.EmotesMenu
}

for c,d in Enum.CoreGuiType:GetEnumItems()do
b[string.lower(d.Name)]=d
end

return{
action="togglecoregui|togglegui|tcgui",
description="Toggles visibility of coregui items",
args={
{
kind="string",
options="inventory|playerlist|chat|reset|emotes|all",
name="gui name"
},
{
kind="boolean",
name="enabled"
}
},
run=function(c,d)
local e=d:nextValue()
local f=d:nextValue()

if e=="reset"then
c.starterGui:SetCore("ResetButtonCallback",f)
return
end

local g=b[e]

if g then
c.starterGui:SetCoreGuiEnabled(g,f)
end
end
}end a.as=function()local c=a.cache.as if not c then c={c=b()}a.cache.as=c end return c.c end end do local b=function()local b=function(
b, c)
local d=b:collectGarbage(c)
if not d then return end

for e,f in d do
e.Visible=f
end

local e=b:registerGarbage"bindedHideGuis"
e[c]=nil end local c=function(


c, d, e)
local f=c:registerGarbage"bindedHideGuis"

for g,h in f do
b(c,g)
end

f[d]=true

local g=c:createGarbage(d)
local h=c.localPlayer.PlayerGui

for i,j in h:GetDescendants()do
if j:IsA"GuiObject"and j.Visible~=e then
local k=j.Visible
j.Visible=e
g[j]=k
end
end end


return{
{
action="showguis",
description="Shows any invisible GUIs",
run=function(d)
c(d,"visibleGuiObjects",true)
end
},
{
action="unshowguis",
description="Undoes showguis",
run=function(d)
b(d,"visibleGuiObjects")
end
},
{
action="hideguis",
description="Hides any GUIs in PlayerGui",
run=function(d)
c(d,"invisibleGuiObjects",false)
end
},
{
action="unhideguis",
description="Undoes hideguis",
run=function(d)
b(d,"invisibleGuiObjects")
end
}
}end a.at=function()local c=a.cache.at if not c then c={c=b()}a.cache.at=c end return c.c end end do local b=function()
local b={
connections={}
}

local c=a.b()

if c.connectionService then c.connectionService:cleanup()end
c.connectionService=b

b.cleanup=function(d)
for e,f in d.connections do
f:Disconnect()
end end


b.disconnect=function(d, e)
if e then
e:Disconnect()
end end


b.Connect=function(d, e, f)
local g=e:Connect(f)
table.insert(d.connections,g)
return g end


return b end a.au=function()local c=a.cache.au if not c then c={c=b()}a.cache.au=c end return c.c end end do local b=function()








return{
bindings={
prefix={
label="Prefix",
settingKey="keybinds.prefix",
default="Semicolon",
also={"RightControl"},
},
},
}end a.av=function()local c=a.cache.av if not c then c={c=b()}a.cache.av=c end return c.c end end do local b=function()local b=function(

b)
local c={}

for d,e in b do

local f=Enum.KeyCode[d]
c[f]=e
end

return c end


return b{Quote=
"'",QuotedDouble=
"\"",Comma=
",",Minus=
"-",Period=
".",Slash=
"/",Colon=
":",Semicolon=
";",LessThan=
"<",Equals=
"=",GreaterThan=
">",Question=
"?",At=
"@",Hash=
"#",Dollar=
"$",Percent=
"%",Caret=
"^",Ampersand=
"&",Asterisk=
"*",LeftParenthesis=
"(",RightParenthesis=
")",Plus=
"+",Underscore=
"_",LeftBracket=
"[",BackSlash=
"\\",RightBracket=
"]",Backquote=
"`",LeftCurly=
"{",Pipe=
"|",RightCurly=
"}",Tilde=
"~",Zero=


"0",One=
"1",Two=
"2",Three=
"3",Four=
"4",Five=
"5",Six=
"6",Seven=
"7",Eight=
"8",Nine=
"9"
}end a.aw=function()local c=a.cache.aw if not c then c={c=b()}a.cache.aw=c end return c.c end end do local b=function()









local b=a.P()
local c=a.au()
local d=a.al()
local e=a.av()
local f=a.aw()

local g=b.UserInputService

local h={}

local i={}
local j
local k=false local l=function(

l)
if type(l)~="string"then return nil end

local m,n=pcall(function()
return Enum.KeyCode[l]
end)

return if m then n else nil end local m=function(


m)
local n=e.bindings[m]
assert(n,`keyboardService: there is no binding named '{m}'`)
return n end local n=function(



n)
local o=m(n)

return l(d:getValue(o.settingKey))
or l(o.default)
or Enum.KeyCode.Unknown end local o=function(



o)
local p=m(o)
local q={n(o)}

for r,s in p.also or{}do
local t=l(s)
if t then
table.insert(q,t)
end
end

return q end local p=function(


p, q)
if p.UserInputType~=Enum.UserInputType.Keyboard then return end

local r=p.KeyCode
if r==Enum.KeyCode.Unknown then return end


if j then
local s=j
j=nil

if r==Enum.KeyCode.Escape then
if s.onCancel then
s.onCancel()
end
else
s.onKey(r)
end

return
end


if q then return end

for s,t in table.clone(i)do
if t.connected and table.find(t.getKeys(),r)then
t.callback(p)
end
end end local q=function()



if k then return end

k=true
c:Connect(g.InputBegan,p)end local r=function(


r, s)
q()

local t={
getKeys=r,
callback=s,
connected=true,
}

table.insert(i,t)

local u={}

u.Disconnect=function(v)
t.connected=false

local w=table.find(i,t)
if w then
table.remove(i,w)
end end


return u end



h.onKeysPressed=function(s, t, u)
return r(function()
return t
end,u)end



h.onBindingPressed=function(s, t, u)
m(t)

return r(function()
return o(t)
end,u)end




h.capture=function(s, t, u)
q()

local v={onKey=t,onCancel=u}
j=v

return function()
if j==v then
j=nil
end
end end


h.getBinding=function(s, t)
return n(t)end


h.setBinding=function(s, t, u)
local v=m(t)
assert(typeof(u)=="EnumItem"and u.EnumType==Enum.KeyCode,"keyboardService: setBinding needs a KeyCode")

d:setValue(v.settingKey,u.Name)
d:save()end



h.resetBinding=function(s, t)
local u=m(t)

d:setValue(u.settingKey,nil)
d:save()end


h.getKeyName=function(s, t)

return f[t]or t.Name end











h.getBindingName=function(s, t)
return s:getKeyName(n(t))end


return h end a.ax=function()local c=a.cache.ax if not c then c={c=b()}a.cache.ax=c end return c.c end end do local b=function()



local b=a.ax()local c=function(

c)
local d=c:collectGarbage"hideiy"
if d and d.connection then
d.connection:Disconnect()
end end local d=function(




d, e)
c(d)

local f=d:registerGarbage"hideiy"
f.connection=b:onBindingPressed("prefix",function()

if e.mainFrame.Visible then return end

e:showCommandBar()
end)end local e=function(


e)
local f=e.infiniteYield
if not f or not f.mainFrame then
e:notify("IY","the main window is not created yet")
return
end

if not f.mainFrame.Visible then
e:notify("IY","already hidden")
return
end

f:hideWindow()
d(e,f)

local g=b:getBindingName"prefix"
e:notify("IY",`hidden. Press {g} or tap the IY button to type a command`)end local f=function(


f)
c(f)

local g=f.infiniteYield
if g then
g:showWindow()
end end


return{
{
action="hideiy|hideinterface",
description="Hides the main IY GUI",
run=function(g)
e(g)
end
},
{
action="showiy|unhideiy|unhideinterface",
description="Shows IY again",
run=function(g)
f(g)
end
}
}end a.ay=function()local c=a.cache.ay if not c then c={c=b()}a.cache.ay=c end return c.c end end do local b=function()

return{a.aq()


,a.ar()
,a.as()
,a.at()
,a.ay()

,

}end a.az=function()local c=a.cache.az if not c then c={c=b()}a.cache.az=c end return c.c end end do local b=function()





local b=a.P()

local c=b.UserInputService

local d={}

local e=Vector3.one*9e9 local f=function(


f)
local g=Vector3.new(f.X,0,f.Z)
if g.Magnitude==0 then
return Vector3.zero
end
return g.Unit end local g=function(



g, h)
local i=workspace.CurrentCamera.CFrame
local j=h.MoveDirection

local k=j:Dot(f(i.LookVector))
local l=j:Dot(f(i.RightVector))

local m=0
if g.privateEnv.qeFly~=false then
if c:IsKeyDown(Enum.KeyCode.E)then
m=m+1
end
if c:IsKeyDown(Enum.KeyCode.Q)then
m=m-1
end
end

local n=i.LookVector*k+i.RightVector*l+Vector3.yAxis*m
if n.Magnitude>1 then
n=n.Unit
end
return n end



d.stop=function(h, i)
local j=h:collectGarbage(i)
if not j then return end

if j.connection then
j.connection:Disconnect()
end
if j.velocity then
j.velocity:Destroy()
end
if j.gyro then
j.gyro:Destroy()
end
if j.humanoid then
j.humanoid.PlatformStand=false
end end






d.start=function(h, i)
d.stop(h,i.garbageName)

local j=h.playerService:getHumanoid()
local k=h.playerService:getRootPart()
if not(j and k)then
h:notify("Fly","your character is not loaded")
return
end

local l=Instance.new"BodyVelocity"
l.MaxForce=e
l.Velocity=Vector3.zero
l.Parent=k

local m=Instance.new"BodyGyro"
m.MaxTorque=e
m.P=9e4
m.CFrame=k.CFrame
m.Parent=k

if i.platformStand then
j.PlatformStand=true
end

local n=h:createGarbage(i.garbageName)
n.velocity=l
n.gyro=m
n.humanoid=j
n.kind=i.kind

n.connection=h:connect(h.runService.Heartbeat,function()
if not k:IsDescendantOf(workspace)or j.Health<=0 then
d.stop(h,i.garbageName)
return
end

l.Velocity=g(h,j)*i.getSpeed()
m.CFrame=workspace.CurrentCamera.CFrame
end)end


return d end a.aA=function()local c=a.cache.aA if not c then c={c=b()}a.cache.aA=c end return c.c end end do local b=function()

local b=a.aA()

local c=100

return{
{
action="fly",
description="Makes you fly",
args={
kind="number",
name="fly speed",
optional=true
},
run=function(d,e)
local f=e:nextValue()
if f then
d.privateEnv.flySpeed=f
end

b.start(d,{
garbageName="fly",
kind="fly",
platformStand=true,
getSpeed=function()
return d.privateEnv.flySpeed or c
end
})
end
},
{
action="flyspeed|flysp",
description="Set fly speed (default is 20)",
args={
kind="number",
name="fly speed"
},
run=function(d,e)
d.privateEnv.flySpeed=e:nextValue()or c
end
},
{
action="togglefly",
description="Toggles fly",
args={
kind="number",
name="fly speed",
optional=true
},
run=function(d,e)
local f=d:getGarbage"fly"
if f and f.kind=="fly"then
d:run"unfly"
else
d:run("fly",e)
end
end
},
{
action="unfly|nofly",
description="Disables fly",
run=function(d)
b.stop(d,"fly")
end
}
}end a.aB=function()local c=a.cache.aB if not c then c={c=b()}a.cache.aB=c end return c.c end end do local b=function()



local b="Noclip"
local c={kind="string",name="nonotify",optional=true}local d=function(

d)
local e=d:collectGarbage"noclip"
if not e then return false end

e.connection:Disconnect()

for f in e.parts do
if f.Parent then
f.CanCollide=true
end
end

return true end local e=function(


e)
local f=e:createGarbage"noclip"
f.parts=setmetatable({},{__mode="k"})

f.connection=e:connect(e.runService.Stepped,function()
local g=e.playerService:getCharacter()
if not g then return end

local h=e:getGarbage"float"
local i=h and h.platform

for j,k in g:GetDescendants()do
if k:IsA"BasePart"and k.CanCollide and k~=i then
k.CanCollide=false
f.parts[k]=true
end
end
end)end


return{
{
action="noclip",
description="Go through objects",
args=c,
run=function(f,g)
local h=g:nextValue()=="nonotify"

d(f)
e(f)

if not h then
f:notify(b,"Noclip Enabled")
end
end
},
{
action="unnoclip|clip",
description="Disables noclip",
args=c,
run=function(f,g)
local h=g:nextValue()=="nonotify"
d(f)

if not h then
f:notify(b,"Noclip Disabled")
end
end
},
{
action="togglenoclip",
description="Toggles noclip",
run=function(f)
f:run(if f:hasGarbage"noclip"then"unnoclip"else"noclip")
end
}
}end a.aC=function()local c=a.cache.aC if not c then c={c=b()}a.cache.aC=c end return c.c end end do local b=function()

local b=a.aA()

local c=100

return{
{
action="vehiclefly|vfly",
description="Makes you fly in a vehicle",
args={
kind="number",
name="vehicle fly speed",
optional=true
},
run=function(d,e)
local f=e:nextValue()
if f then
d.privateEnv.vehicleFlySpeed=f
end


b.start(d,{
garbageName="fly",
kind="vehiclefly",
platformStand=false,
getSpeed=function()
return d.privateEnv.vehicleFlySpeed or c
end
})
end
},
{
action="vehicleflyspeed|vflyspeed|vflysp",
description="Set vehicle fly speed",
args={
kind="number",
name="vehicle fly speed"
},
run=function(d,e)
d.privateEnv.vehicleFlySpeed=e:nextValue()or c
end
},
{
action="togglevfly",
description="Toggles vehicle fly",
args={
kind="number",
name="vehicle fly speed",
optional=true
},
run=function(d,e)
local f=d:getGarbage"fly"
if f and f.kind=="vehiclefly"then
d:run"unvehiclefly"
else
d:run("vehiclefly",e)
end
end
},
{
action="unvehiclefly|unvfly|novehiclefly|novfly",
description="Disables vehicle fly",
run=function(d)
b.stop(d,"fly")
end
}
}end a.aD=function()local c=a.cache.aD if not c then c={c=b()}a.cache.aD=c end return c.c end end do local b=function()

local b=50 local c=function(


c)
local d=c:collectGarbage"cframefly"
if not d then return end

d.connection:Disconnect()
d.humanoid.PlatformStand=false
d.head.Anchored=false end local d=function(



d)
c(d)

local e=d.playerService:getHumanoid()
local f=d.playerService:getCharacter()
local g=f and f:FindFirstChild"Head"
if not(e and g)then
d:notify("cframefly","your character is not loaded")
return
end

e.PlatformStand=true
g.Anchored=true

local h=d:createGarbage"cframefly"
h.humanoid=e
h.head=g
h.connection=d:connect(d.runService.Heartbeat,function(i)
if not g:IsDescendantOf(workspace)then
c(d)
return
end

local j=d.privateEnv.cframeFlySpeed or b
local k=e.MoveDirection*(j*i)

local l=g.CFrame
local m=workspace.CurrentCamera.CFrame
local n=l:ToObjectSpace(m).Position
m=m*CFrame.new(-n.X,-n.Y,-n.Z+1)

local o=m.Position
local p=l.Position
local q=CFrame.new(o,Vector3.new(p.X,o.Y,p.Z)):VectorToObjectSpace(k)

g.CFrame=CFrame.new(p)*(m-o)*CFrame.new(q)
end)end


return{
{
action="cframefly|cfly",
description="Makes you fly, bypassing some anti cheats (works on mobile)",
args={
kind="number",
name="speed",
optional=true
},
run=function(e,f)
local g=f:nextValue()
if g then
e.privateEnv.cframeFlySpeed=g
end
d(e)
end
},
{
action="cframeflyspeed|cflyspeed",
description="Sets cfly speed",
args={
kind="number"
},
run=function(e,f)
e.privateEnv.cframeFlySpeed=f:nextValue()or b
end
},
{
action="uncframefly|uncfly",
description="Disables cfly",
run=function(e)
c(e)
end
}
}end a.aE=function()local c=a.cache.aE if not c then c={c=b()}a.cache.aE=c end return c.c end end do local b=function()

return{
action="qefly|flyqe",
description="Enables or disables the Q and E hotkeys for fly",
args={
kind="boolean",
optional=true
},
run=function(b,c)

b.privateEnv.qeFly=c:nextValue()~=false
end
}end a.aF=function()local c=a.cache.aF if not c then c={c=b()}a.cache.aF=c end return c.c end end do local b=function()local b=function(


b)
local c=b
while c and not c:IsA"Model"do
c=c.Parent
end
return c end local c=function(


c)
local d=c:collectGarbage"vehiclenoclip"
if not d then return end

for e,f in d.parts do
f.CanCollide=true
end end


return{
{
action="vehiclenoclip|vnoclip",
description="Turns off vehicle collision",
run=function(d)
c(d)

local e=d.playerService:getHumanoid()
local f=e and e.SeatPart
local g=f and b(f)
if not g then
d:notify("vehiclenoclip","you are not sitting in a vehicle")
return
end

local h=d:createGarbage"vehiclenoclip"
h.parts={}

for i,j in g:GetDescendants()do
if j:IsA"BasePart"and j.CanCollide then
j.CanCollide=false
table.insert(h.parts,j)
end
end
end
},
{
action="togglevnoclip",
description="Toggles vehicle collision",
run=function(d)
d:run(if d:hasGarbage"vehiclenoclip"then"vehicleclip"else"vehiclenoclip")
end
},
{
action="vehicleclip|vclip|unvnoclip",
description="Enables vehicle collision",
run=function(d)
c(d)
end
},
}end a.aG=function()local c=a.cache.aG if not c then c={c=b()}a.cache.aG=c end return c.c end end do local b=function()

local b=-3.1 local c=function(

c)
local d=c:collectGarbage"float"
if not d then return end

for e,f in d.connections do
f:Disconnect()
end
d.platform:Destroy()end local d=function(


d)
if d:hasGarbage"float"then
d:notify"float is already enabled"
return
end

local e=d.playerService:getCharacter()
local f=d.playerService:getRootPart()
if not(e and f)then
d:notify("Float","your character is not loaded")
return
end

local g=Instance.new"Part"
g.Name="IYFloatPlatform"
g.Transparency=1
g.Size=Vector3.new(2,0.2,1.5)
g.Anchored=true
g.CFrame=f.CFrame*CFrame.new(0,b,0)
g.Parent=e

local h=d:createGarbage"float"
h.platform=g
h.offset=b
h.connections={}

table.insert(h.connections,d:connect(d.runService.Heartbeat,function()
local i=d.playerService:getRootPart()
if not(i and g:IsDescendantOf(workspace))then
c(d)
return
end

g.CFrame=i.CFrame*CFrame.new(0,h.offset,0)
end))


table.insert(h.connections,d:connect(d.robloxServices.UserInputService.InputBegan,function(i,j)
if j then return end

if i.KeyCode==Enum.KeyCode.E then
h.offset=h.offset+1.5
elseif i.KeyCode==Enum.KeyCode.Q then
h.offset=h.offset-0.5
end
end))

table.insert(h.connections,d:connect(d.robloxServices.UserInputService.InputEnded,function(i)
if i.KeyCode==Enum.KeyCode.E then
h.offset=h.offset-1.5
elseif i.KeyCode==Enum.KeyCode.Q then
h.offset=h.offset+0.5
end
end))

d:notify("Float","Enabled (Q = down & E = up)")end


return{
{
action="float|platform",
description="Spawns a platform beneath you causing you to float",
run=function(e)
d(e)
end
},
{
action="togglefloat",
description="Toggles float",
run=function(e)
e:run(if e:hasGarbage"float"then"unfloat"else"float")
end
},
{
action="unfloat|noplatform|nofloat|unplatform",
description="Removes the platform",
run=function(e)
if not e:hasGarbage"float"then return end

c(e)
e:notify("Float","Disabled")
end
}
}end a.aH=function()local c=a.cache.aH if not c then c={c=b()}a.cache.aH=c end return c.c end end do local b=function()local b=function()



local b={}
for c,d in Enum.HumanoidStateType:GetEnumItems()do
if d~=Enum.HumanoidStateType.None and d~=Enum.HumanoidStateType.Dead then
table.insert(b,d)
end
end
return b end local c=function(


c)
local d=c:collectGarbage"swim"
if not d then return end

for e,f in d.connections do
f:Disconnect()
end
for e,f in d.states do
d.humanoid:SetStateEnabled(f,true)
end
workspace.Gravity=d.gravity end local d=function(


d)
if d:hasGarbage"swim"then
d:notify"swim is already enabled"
return
end

local e=d.playerService:getHumanoid()
if not e then
d:notify("swim","your character is not loaded")
return
end

local f=d:createGarbage"swim"
f.humanoid=e
f.gravity=workspace.Gravity
f.states=b()
f.connections={}

workspace.Gravity=0
for g,h in f.states do
e:SetStateEnabled(h,false)
end
e:ChangeState(Enum.HumanoidStateType.Swimming)

table.insert(f.connections,d:connect(e.Died,function()
c(d)
end))


table.insert(f.connections,d:connect(d.runService.Heartbeat,function()
local g=d.playerService:getRootPart()
if not g then return end

local h=e.MoveDirection~=Vector3.zero
or d.robloxServices.UserInputService:IsKeyDown(Enum.KeyCode.Space)
if not h then
g.AssemblyLinearVelocity=Vector3.zero
end
end))end


return{
{
action="swim",
description="Allows you to swim in the air",
run=function(e)
d(e)
end
},
{
action="unswim|noswim",
description="Stops you from swimming everywhere",
run=function(e)
c(e)
end
},
{
action="toggleswim",
description="Toggles swimming",
run=function(e)
if e:hasGarbage"swim"then
c(e)
else
d(e)
end
end
}
}end a.aI=function()local c=a.cache.aI if not c then c={c=b()}a.cache.aI=c end return c.c end end do local b=function()local b=function(

b, c, d)
local e=b.playerService:getHumanoid()
if e then
e[c]=d
end end local c=function(


c, d, e, f)
return{
action=c,
description=d,
run=function(g)
b(g,e,f)
end
}end


return{
{
action="speed|ws|walkspeed",
description="Sets your walk speed (default is 16)",
args={kind="number",name="walk speed",optional=true},
run=function(d,e)
b(d,"WalkSpeed",e:nextValue()or 16)
end
},
{
action="jpower|jumppower|jp",
description="Sets your jump power (default is 50)",
args={kind="number",name="jump power",optional=true},
run=function(d,e)
local f=d.playerService:getHumanoid()
if not f then return end

local g=e:nextValue()or 50
if f.UseJumpPower then
f.JumpPower=g
else
f.JumpHeight=g
end
end
},
{
action="maxslopeangle|msa",
description="Sets the max slope angle your humanoid can walk up (default is 89)",
args={kind="number",name="angle",optional=true},
run=function(d,e)
b(d,"MaxSlopeAngle",e:nextValue()or 89)
end
},
{
action="hipheight|hheight",
description="Sets your hip height (default depends on your rig)",
args={kind="number",name="hip height",optional=true},
run=function(d,e)
local f=d.playerService:getHumanoid()
if not f then return end

local g=f.RigType==Enum.HumanoidRigType.R15
f.HipHeight=e:nextValue()or(g and 2.1 or 0)
end
},
c("stun|platformstand","Makes your character stiff (PlatformStand)","PlatformStand",true),
c("unstun|nostun|unplatformstand|noplatformstand","Disables stun","PlatformStand",false),
c("norotate|noautorotate","Stops your character from auto rotating","AutoRotate",false),
c("unnorotate|autorotate","Lets your character auto rotate again","AutoRotate",true),
{
action="trip",
description="Trips your character forward",
run=function(d)
local e=d.playerService:getHumanoid()
local f=d.playerService:getRootPart()
if not(e and f)then return end

e:ChangeState(Enum.HumanoidStateType.FallingDown)
f.AssemblyLinearVelocity=f.CFrame.LookVector*30
end
},
{
action="breakvelocity",
description="Stops the character's movement for one second",
run=function(d)
local e=d.localPlayer.Character
if not e then return end

local f=os.clock()
task.spawn(function()
while os.clock()-f<1 do
for g,h in e:GetDescendants()do
if h:IsA"BasePart"then
h.AssemblyLinearVelocity=Vector3.zero
h.AssemblyAngularVelocity=Vector3.zero
end
end
task.wait()
end
end)
end
},
{
action="deletevelocity|dv|removevelocity|removeforces",
description="Deletes the force and velocity objects on your character",
run=function(d)
local e=d.localPlayer.Character
if not e then return end

local f={
"BodyVelocity","BodyGyro","RocketPropulsion","BodyThrust",
"BodyAngularVelocity","AngularVelocity","BodyForce","VectorForce","LineForce"
}

for g,h in e:GetDescendants()do
for i,j in f do
if h:IsA(j)then
h:Destroy()
break
end
end
end
end
}
}end a.aJ=function()local c=a.cache.aJ if not c then c={c=b()}a.cache.aJ=c end return c.c end end do local b=function()local b=function(

b, c, d)
if b:hasGarbage(c)then
b:notify(`{c} is already enabled`)
return
end

local e=b:createGarbage(c)
e.connection=b:connect(b.robloxServices.UserInputService.JumpRequest,function()
if d and e.debouncing then return end

local f=b.playerService:getHumanoid()
if not f then return end

e.debouncing=true
f:ChangeState(Enum.HumanoidStateType.Jumping)
task.wait()
e.debouncing=false
end)end local c=function(


c, d)
local e=c:collectGarbage(d)
if e and e.connection then
e.connection:Disconnect()
end end local d=function(


d, e, f)
local g=d.playerService:getHumanoid()
local h,i=pcall(function()
return Enum.HumanoidStateType[e]
end)

if not h then
d:notify("Invalid state",`{e} is not a HumanoidStateType`)
return
end

if g then
g:SetStateEnabled(i,f)
end end


return{
{
action="sit",
description="Makes your character sit",
run=function(e)
local f=e.playerService:getHumanoid()
if f then
f.Sit=true
end
end
},
{
action="nosit",
description="Stops your character from being able to sit",
run=function(e)
d(e,"Seated",false)
end
},
{
action="unnosit",
description="Lets your character sit again",
run=function(e)
d(e,"Seated",true)
end
},
{
action="enablestate",
description="Enables a humanoid state (example: Jumping)",
args={kind="string",name="state name"},
run=function(e,f)
d(e,f:nextValue(),true)
end
},
{
action="disablestate",
description="Disables a humanoid state (example: Jumping)",
args={kind="string",name="state name"},
run=function(e,f)
d(e,f:nextValue(),false)
end
},
{
action="lay|laydown",
description="Lays your character down",
run=function(e)
local f=e.playerService:getHumanoid()
local g=e.playerService:getRootPart()
if not(f and g)then return end

f.Sit=true
task.wait(0.1)

g=e.playerService:getRootPart()
if not g then return end
g.CFrame=g.CFrame*CFrame.Angles(math.pi*0.5,0,0)

for h,i in f:GetPlayingAnimationTracks()do
i:Stop()
end
end
},
{
action="jump",
description="Makes your character jump once",
run=function(e)
local f=e.playerService:getHumanoid()
if f then
f:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
},
{
action="infjump|infinitejump",
description="Lets you jump again while in the air",
run=function(e)
b(e,"infjump",true)
end
},
{
action="uninfjump|uninfinitejump|noinfjump|noinfinitejump",
description="Disables infinite jump",
run=function(e)
c(e,"infjump")
end
},
{
action="flyjump",
description="Makes you jump every time a jump is requested",
run=function(e)
b(e,"flyjump",false)
end
},
{
action="unflyjump|noflyjump",
description="Disables flyjump",
run=function(e)
c(e,"flyjump")
end
},
{
action="nilchar",
description="Removes your character from the workspace (client side)",
run=function(e)
local f=e.localPlayer.Character
if f then
f.Parent=nil
end
end
},
{
action="unnilchar|nonilchar",
description="Puts your character back into the workspace",
run=function(e)
local f=e.localPlayer.Character
if f then
f.Parent=workspace
end
end
}
}end a.aK=function()local c=a.cache.aK if not c then c={c=b()}a.cache.aK=c end return c.c end end do local b=function()local b=function(


b, c)
if not b then return end

for d,e in b:GetDescendants()do
if c(e)then
e:Destroy()
end
end end local c=function(


c)
return c.localPlayer.Character end local d=function(


d)
local e=d.playerService:getHumanoid()
return e and e:GetAccessories()or{}end local e=function(


e)
return e:IsA"SpecialMesh"end


return{
{
action="blockhead",
description="Removes the mesh from your head (makes it block-like)",
run=function(f)
local g=c(f)
local h=g and g:FindFirstChild"Head"
local i=h and h:FindFirstChildOfClass"SpecialMesh"
if i then
i:Destroy()
end
end
},
{
action="blockhats",
description="Removes the meshes from your accessories",
run=function(f)
for g,h in d(f)do
b(h,e)
end
end
},
{
action="blocktool",
description="Removes the meshes from your equipped tools",
run=function(f)
local g=c(f)
if not g then return end

for h,i in g:GetChildren()do
if i:IsA"Tool"or i:IsA"HopperBin"then
b(i,e)
end
end
end
},
{
action="nobgui|unbgui|nobillboardgui|unbillboardgui|noname|rohg",
description="Removes BillboardGuis and SurfaceGuis from your character",
run=function(f)
b(c(f),function(g)
return g:IsA"BillboardGui"or g:IsA"SurfaceGui"
end)
end
},
{
action="naked",
description="Removes your clothing and shirt graphics",
run=function(f)
b(c(f),function(g)
return g:IsA"Clothing"or g:IsA"ShirtGraphic"
end)
end
},
{
action="noface|removeface",
description="Removes your face decal",
run=function(f)
b(c(f),function(g)
return g:IsA"Decal"and g.Name=="face"
end)
end
},
{
action="deletehats|nohats|rhats",
description="Removes the welds that hold your accessories on",
run=function(f)
b(c(f),function(g)
return g:IsA"Weld"and g:FindFirstAncestorWhichIsA"Accessory"~=nil
end)
end
},
{
action="drophats|drophat",
description="Drops your accessories into the workspace",
run=function(f)
for g,h in d(f)do
h.Parent=workspace
end
end
},
{
action="clearcharappearance|clearchar|clrchar",
description="Clears your character appearance",
run=function(f)
f.localPlayer:ClearCharacterAppearance()
end
},
{
action="split",
description="Splits your R15 character in half (removes the waist)",
run=function(f)
local g=c(f)
local h=f.playerService:getHumanoid()
if not(g and h)then return end

if h.RigType~=Enum.HumanoidRigType.R15 then
f:notify("R15 Required","This command requires the R15 rig type")
return
end

local i=g:FindFirstChild"UpperTorso"
local j=i and i:FindFirstChild"Waist"
if j then
j:Destroy()
end
end
}
}end a.aL=function()local c=a.cache.aL if not c then c={c=b()}a.cache.aL=c end return c.c end end do local b=function()

local b=a.S()local c=function(

c)
return c:IsA"Tool"or c:IsA"HopperBin"end local d=function(


d)
if not d then return end

for e,f in d:GetDescendants()do
if c(f)then
f:Destroy()
end
end end


return{
{
action="notools|rtools|clrtools|removetools|deletetools|dtools",
description="Deletes every tool in your backpack and character",
run=function(e)
d(e.localPlayer:FindFirstChildOfClass"Backpack")
d(e.localPlayer.Character)
end
},
{
action="deleteselectedtool|dst",
description="Deletes the tools you are currently holding",
run=function(e)
d(e.localPlayer.Character)
end
},
{
action="equiptools",
description="Equips every tool in your backpack",
run=function(e)
local f=e.localPlayer:FindFirstChildOfClass"Backpack"
local g=e.localPlayer.Character
if not(f and g)then return end

for h,i in f:GetChildren()do
if c(i)then
i.Parent=g
end
end
end
},
{
action="unequiptools",
description="Unequips all your tools",
run=function(e)
local f=e.playerService:getHumanoid()
if f then
f:UnequipTools()
end
end
},
{
action="droptools|droptool",
description="Drops every tool from your backpack to the workspace",
run=function(e)
local f=e.localPlayer:FindFirstChildOfClass"Backpack"
local g=e.localPlayer.Character
if not(f and g)then return end

for h,i in f:GetChildren()do
if c(i)then
i.Parent=g
end
end

task.wait()

for h,i in g:GetChildren()do
if c(i)then
i.Parent=workspace
end
end
end
},
{
action="copytools",
description="Copies the tools from a player's backpack into yours",
args={kind="player"},
run=function(e,f)
local g=e.localPlayer:FindFirstChildOfClass"Backpack"
if not g then return end

for h,i in b(f:nextValue())do
local j=i:FindFirstChildOfClass"Backpack"
if j then
for k,l in j:GetChildren()do
if c(l)then
local m=l:Clone()
m.Parent=g
end
end
end
end
end
}
}end a.aM=function()local c=a.cache.aM if not c then c={c=b()}a.cache.aM=c end return c.c end end do local b=function()

local b={
"27789359","30196114","248263260","45834924","33796059","28488254","52155728"
}

local c={
"3333432454","4555808220","4049037604","4555782893","10214311282",
"10714010337","10713981723","10714372526","10714076981","10714392151","11444443576"
}local d=function(

d)
for e,f in d:GetPlayingAnimationTracks()do
f:Stop()
end end local e=function(


e, f)
local g=e.localPlayer.Character
local h=g and g:FindFirstChild"Animate"
if h then
h.Disabled=f
end end local f=function(


f)
local g=f.playerService:getHumanoid()
local h=f.localPlayer.Character
local i=h and h:FindFirstChild"Animate"

if not(g and i)then
f:notify("Refresh Animations","Failed to get Animate/Humanoid")
return
end

i.Disabled=true
d(g)
i.Disabled=false end local g=function(


g)
local h=g:collectGarbage"dance"
if h and h.track then
h.track:Stop()
h.track:Destroy()
end end local h=function(


h, i)
h.robloxServices.StarterPlayer.AllowCustomAnimations=i
f(h)end


return{
{
action="animation|anim",
description="Plays an animation by its asset ID (optional speed)",
args={
{kind="string",name="animation id"},
{kind="number",name="speed",optional=true}
},
run=function(i,j)
local k=i.playerService:getHumanoid()
if not k then return end

local l=tostring(j:nextValue())
local m=j:nextValue()
if not l:find"rbxassetid://"then
l="rbxassetid://"..l
end

local n=Instance.new"Animation"
n.AnimationId=l

local o=k:LoadAnimation(n)
o.Priority=Enum.AnimationPriority.Movement
o:Play()

if m then
o:AdjustSpeed(m)
end
end
},
{
action="emote|em",
description="Plays an emote by its animation ID (optional speed)",
args={
{kind="number",name="emote id"},
{kind="number",name="speed",optional=true}
},
run=function(i,j)
local k=i.playerService:getHumanoid()
if not k then return end

local l=j:nextValue()
local m,n=pcall(function()
return k:PlayEmoteAndGetAnimTrackById(l)
end)


if not m or not n then
i:notify("Emote",`there is no emote with the ID {l}`)
return
end

local o=j:nextValue()
if n and o then
n:AdjustSpeed(o)
end
end
},
{
action="noanim",
description="Disables the default Roblox animations",
run=function(i)
e(i,true)
end
},
{
action="reanim",
description="Enables the default Roblox animations again",
run=function(i)
e(i,false)
end
},
{
action="animspeed",
description="Sets the speed of every playing animation (default is 1)",
args={kind="number",name="speed",optional=true},
run=function(i,j)
local k=i.playerService:getHumanoid()
if not k then return end

local l=j:nextValue()or 1
for m,n in k:GetPlayingAnimationTracks()do
n:AdjustSpeed(l)
end
end
},
{
action="stopanimations|stopanims|stopanim",
description="Stops every playing animation",
run=function(i)
local j=i.playerService:getHumanoid()
if j then
d(j)
end
end
},
{
action="refreshanimations|refreshanimation|refreshanims|refreshanim",
description="Restarts your character's default animations",
run=function(i)
f(i)
end
},
{
action="allowcustomanim|allowcustomanimations",
description="Allows custom animations on your character",
run=function(i)
h(i,true)
end
},
{
action="unallowcustomanim|unallowcustomanimations",
description="Stops custom animations on your character",
run=function(i)
h(i,false)
end
},
{
action="loopanimation|loopanim",
description="Makes the animations that are currently playing loop",
run=function(i)
local j=i.playerService:getHumanoid()
if not j then return end

for k,l in j:GetPlayingAnimationTracks()do
l.Looped=true
end
end
},
{
action="dance",
description="Plays a random dance on a loop",
run=function(i)
local j=i.playerService:getHumanoid()
if not j then return end

g(i)

local k=j.RigType==Enum.HumanoidRigType.R15 and c or b
local l=Instance.new"Animation"
l.AnimationId="rbxassetid://"..k[math.random(1,#k)]

local m=j:LoadAnimation(l)
m.Looped=true
m:Play()

i:registerGarbage"dance".track=m
end
},
{
action="undance|nodance",
description="Stops the dance",
run=function(i)
g(i)
end
}
}end a.aN=function()local c=a.cache.aN if not c then c={c=b()}a.cache.aN=c end return c.c end end do local b=function()local b=function(

b, c)
local d=b.localPlayer.Character
if not d then return end

for e,f in d:GetDescendants()do
if f:IsA"BasePart"then
f.CustomPhysicalProperties=PhysicalProperties.new(c,0.3,0.5)
end
end end


return{
{
action="strengthen",
description="Makes your body parts heavier (default is 100)",
args={kind="number",name="density",optional=true},
run=function(c,d)
b(c,d:nextValue()or 100)
end
},
{
action="weaken",
description="Makes your body parts lighter (default is 0)",
args={kind="number",name="density",optional=true},
run=function(c,d)
b(c,-(d:nextValue()or 0))
end
},
{
action="unweaken|unstrengthen",
description="Resets your body parts' density",
run=function(c)
b(c,0.7)
end
}
}end a.aO=function()local c=a.cache.aO if not c then c={c=b()}a.cache.aO=c end return c.c end end do local b=function()


local b=workspace.FallenPartsDestroyHeight

return{
{
action="antivoid",
description="Pushes you back up when you fall below the destroy height",
run=function(c)
if c:hasGarbage"antivoid"then
c:notify"antivoid is already enabled"
return
end

local d=c:createGarbage"antivoid"
d.connection=c:connect(c.runService.Stepped,function()
local e=c.playerService:getRootPart()
if e and e.Position.Y<=b+25 then
e.AssemblyLinearVelocity=e.AssemblyLinearVelocity+Vector3.new(0,250,0)
end
end)

c:notify("antivoid","Enabled")
end
},
{
action="unantivoid|noantivoid",
description="Disables antivoid",
run=function(c)
local d=c:collectGarbage"antivoid"
if d and d.connection then
d.connection:Disconnect()
c:notify("antivoid","Disabled")
end
end
}
}end a.aP=function()local c=a.cache.aP if not c then c={c=b()}a.cache.aP=c end return c.c end end do local b=function()local b=function(

b)
local c=b:collectGarbage"spasm"
if c and c.track then
c.track:Stop()
c.track:Destroy()
end end local c=function(


c)
for d,e in c:GetChildren()do
if e.Name=="Spinning"then
e:Destroy()
end
end end


return{
{
action="spasm",
description="Makes your R6 character spasm (uses an animation)",
run=function(d)
local e=d.playerService:getHumanoid()
if not e then return end

if e.RigType==Enum.HumanoidRigType.R15 then
d:notify("R6 Required","This command requires the r6 rig type")
return
end

b(d)

local f=Instance.new"Animation"
f.AnimationId="rbxassetid://33796059"

local g=e:LoadAnimation(f)
g:Play()
g:AdjustSpeed(99)

d:registerGarbage"spasm".track=g
end
},
{
action="unspasm|nospasm",
description="Stops the spasm",
run=function(d)
b(d)
end
},
{
action="headthrow",
description="Throws your R6 character's head (uses an animation)",
run=function(d)
local e=d.playerService:getHumanoid()
if not e then return end

if e.RigType==Enum.HumanoidRigType.R15 then
d:notify("R6 Required","This command requires the r6 rig type")
return
end

local f=Instance.new"Animation"
f.AnimationId="rbxassetid://35154961"

local g=e:LoadAnimation(f)
g:Play(0)
g:AdjustSpeed(1)
end
},
{
action="sitwalk",
description="Uses the sit animation while walking, running and jumping",
run=function(d)
local e=d.localPlayer.Character
local f=d.playerService:getHumanoid()
local g=e and e:FindFirstChild"Animate"
if not(f and g)then return end

local h=g:FindFirstChild"sit"
local i=h and h:FindFirstChildWhichIsA"Animation"
if not i then return end

for j,k in{"idle","walk","run","jump"}do
local l=g:FindFirstChild(k)
local m=l and l:FindFirstChildWhichIsA"Animation"
if m then
m.AnimationId=i.AnimationId
end
end

f.HipHeight=f.RigType==Enum.HumanoidRigType.R15 and 0.5 or-1.5
end
},
{
action="spin",
description="Spins your character (default speed is 20)",
args={kind="number",name="spin speed",optional=true},
run=function(d,e)
local f=d:getRoot()
if not f then return end

c(f)

local g=Instance.new"BodyAngularVelocity"
g.Name="Spinning"
g.MaxTorque=Vector3.new(0,math.huge,0)
g.AngularVelocity=Vector3.new(0,e:nextValue()or 20,0)
g.Parent=f
end
},
{
action="unspin",
description="Stops spinning your character",
run=function(d)
local e=d.playerService:getRootPart()
if e then
c(e)
end
end
}
}end a.aQ=function()local c=a.cache.aQ if not c then c={c=b()}a.cache.aQ=c end return c.c end end do local b=function()local b=function(

b)
return b:IsA"BillboardGui"or b:IsA"SurfaceGui"end local c=function(


c, d)
for e,f in d do
local g=c:FindFirstChild(f)
if g then
g:Destroy()
end
end end


return{
{
action="creeper",
description="Gives your character a creeper look (removes the face mesh, arms and accessories)",
run=function(d)
local e=d.localPlayer.Character
local f=d.playerService:getHumanoid()
if not(e and f)then return end

local g=e:FindFirstChild"Head"
local h=g and g:FindFirstChildOfClass"SpecialMesh"
if h then
h:Destroy()
end

if f.RigType==Enum.HumanoidRigType.R15 then
c(e,{"LeftUpperArm","RightUpperArm"})
else
c(e,{"Left Arm","Right Arm"})
end

f:RemoveAccessories()
end
},
{
action="chardelete|charremove|cd",
description="Deletes every part of your character with the given name",
args={kind="string",name="item name"},
run=function(d,e)
local f=d.localPlayer.Character
local g=e:nextValue()or""
if not f then return end

for h,i in f:GetDescendants()do
if i.Name:lower()==g:lower()then
i:Destroy()
end
end

d:notify("Item(s) Deleted",`Deleted {g}`)
end
},
{
action="chardeleteclass|charremoveclass|chardeleteclassname|charremoveclassname|cdc",
description="Deletes every part of your character with the given class name",
args={kind="className",name="class name"},
run=function(d,e)
local f=d.localPlayer.Character
local g=e:nextValue()or""
if not f then return end

for h,i in f:GetDescendants()do
if i.ClassName:lower()==g:lower()then
i:Destroy()
end
end

d:notify("Item(s) Deleted",`Deleted items with ClassName {g}`)
end
},
{
action="loopnobgui|loopunbgui|loopnobillboardgui|loopunbillboardgui|loopnoname|looprohg",
description="Removes BillboardGuis and SurfaceGuis from your character, including new ones",
run=function(d)
local e=d.localPlayer.Character
if not e then return end

local f=d:collectGarbage"nobgui"
if f and f.connection then
f.connection:Disconnect()
end

for g,h in e:GetDescendants()do
if b(h)then
h:Destroy()
end
end

local g=d:createGarbage"nobgui"
g.connection=d:connect(e.DescendantAdded,function(h)
if b(h)then
task.wait()
h:Destroy()
end
end)
end
},
{
action="unloopnobgui|unloopunbgui|unloopnobillboardgui|unloopunbillboardgui|unloopnoname|unlooprohg",
description="Stops removing BillboardGuis and SurfaceGuis from your character",
run=function(d)
local e=d:collectGarbage"nobgui"
if e and e.connection then
e.connection:Disconnect()
end
end
}
}end a.aR=function()local c=a.cache.aR if not c then c={c=b()}a.cache.aR=c end return c.c end end do local b=function()

return{
{
action="noroot|removeroot|rroot",
description="Removes your character's root part (client side)",
run=function(b)
local c=b.localPlayer.Character
if not c then return end

local d=c:FindFirstChildOfClass"Humanoid"
local e=d and d.RootPart

c.Parent=nil
if e then
e:Destroy()
end
c.Parent=workspace
end
},
{
action="replaceroot|replacerootpart",
description="Replaces your character's root part with a fresh copy",
run=function(b)
local c=b.localPlayer.Character
local d=b.playerService:getRootPart()
if not(c and d)then return end

local e=c.Parent
local f=d.CFrame

c.Parent=game
local g=d:Clone()
g.Parent=c
d:Destroy()
g.CFrame=f
c.Parent=e
end
}
}end a.aS=function()local c=a.cache.aS if not c then c={c=b()}a.cache.aS=c end return c.c end end do local b=function()local b=function(




b)
local c=b:registerGarbage"removespecifictool"
c.connections=c.connections or{}
return c end


return{
{
action="removespecifictool",
description="Keeps removing tools with the given name from your backpack",
args={kind="string",name="tool name"},
run=function(c,d)
local e=(d:nextValue()or""):lower()
local f=b(c)
if f.connections[e]then return end

f.connections[e]=c:connect(c.runService.RenderStepped,function()
local g=c.localPlayer:FindFirstChildOfClass"Backpack"
if not g then return end

for h,i in g:GetChildren()do
if i.Name:lower()==e then
i:Destroy()
end
end
end)
end
},
{
action="unremovespecifictool",
description="Stops removing tools with the given name",
args={kind="string",name="tool name"},
run=function(c,d)
local e=(d:nextValue()or""):lower()
local f=c:getGarbage"removespecifictool"
local g=f and f.connections and f.connections[e]

if g then
g:Disconnect()
f.connections[e]=nil
end
end
},
{
action="clearremovespecifictool",
description="Stops removing every tool that is being filtered",
run=function(c)
local d=c:collectGarbage"removespecifictool"
if not(d and d.connections)then return end

for e,f in d.connections do
f:Disconnect()
end
end
}
}end a.aT=function()local c=a.cache.aT if not c then c={c=b()}a.cache.aT=c end return c.c end end do local b=function()

local b=a.S()

return{
{
action="walkto|follow",
description="Walks your character to a player and keeps following them",
args={kind="player"},
run=function(c,d)
local e=b(d:nextValue())[1]
if not e then return end

local f=c:collectGarbage"walkto"
if f then
f.running=false
end

local g=c.playerService:getHumanoid()
if g and g.SeatPart then
g.Sit=false
task.wait(0.1)
end

local h=c:createGarbage"walkto"
h.running=true

task.spawn(function()
while h.running do
local i=c.playerService:getHumanoid()
local j=e.Character and e.Character:FindFirstChild"HumanoidRootPart"

if not(i and j)then
break
end

i:MoveTo(j.Position)
task.wait()
end
end)
end
},
{
action="unwalkto|nowalkto|unfollow|nofollow",
description="Stops walking to the player",
run=function(c)
local d=c:collectGarbage"walkto"
if d then
d.running=false
end
end
}
}end a.aU=function()local c=a.cache.aU if not c then c={c=b()}a.cache.aU=c end return c.c end end do local b=function()local b=function(

b, c)
b.WalkSpeed=c end local c=function(


c, d)
if c.UseJumpPower then
c.JumpPower=d
else
c.JumpHeight=d
end end local d=function(


d, e)
local f=d:collectGarbage(e)
if f and f.connections then
for g,h in f.connections do
h:Disconnect()
end
end end local e=function(



e, f, g, h, i)
d(e,f)

local j=e:createGarbage(f)
j.connections={}local k=function(

k)
h(k,i)
table.insert(j.connections,e:connect(k:GetPropertyChangedSignal(g),function()
h(k,i)
end))end


local l=e.playerService:getHumanoid()
if l then
k(l)
end

table.insert(j.connections,e:connect(e.localPlayer.CharacterAdded,function(m)
k(m:WaitForChild"Humanoid")
end))end


return{
{
action="loopspeed|loopws",
description="Keeps your walk speed set, even after respawning (default is 16)",
args={kind="number",name="walk speed",optional=true},
run=function(f,g)
e(f,"loopspeed","WalkSpeed",b,g:nextValue()or 16)
end
},
{
action="unloopspeed|unloopws",
description="Stops the walk speed loop",
run=function(f)
d(f,"loopspeed")
end
},
{
action="loopjumppower|loopjp|loopjpower",
description="Keeps your jump power set, even after respawning (default is 50)",
args={kind="number",name="jump power",optional=true},
run=function(f,g)
e(f,"loopjumppower","JumpPower",c,g:nextValue()or 50)
end
},
{
action="unloopjumppower|unloopjp|unloopjpower",
description="Stops the jump power loop",
run=function(f)
d(f,"loopjumppower")
end
}
}end a.aV=function()local c=a.cache.aV if not c then c={c=b()}a.cache.aV=c end return c.c end end do local b=function()

local b=a.F()

local c=PhysicalProperties.new(100,0.3,0.5)


local d=Vector3.yAxis*99999 local e=function()


local e=Instance.new"BodyAngularVelocity"

e.MaxTorque=Vector3.new(0,math.huge,0)
e.P=math.huge
return e end local f=function(


f)
if f:hasGarbage"fling"then
f:notify"fling is already enabled\ndisable using 'unfling'"
return
end

local g=f.playerService:getHumanoid()
if not(g and g.Health~=0)then return end

local h=f:getRoot()
if not h then return end

local i=g.Parent

f:notify"fling now is activated"

f:run("noclip",b.new{{value="nonotify"}})

local j=f:createGarbage"fling"
j.originalStates={}

for k,l in i:GetDescendants()do
if not l:IsA"BasePart"then continue end

j.originalStates[l]={
CustomPhysicalProperties=l.CustomPhysicalProperties,
Massless=l.Massless
}

l.CustomPhysicalProperties=c
end

local k=e()
j.flingVelocity=k

j.flingConnection=f:connect(g.Died,function()
f:notify"player died: disabling fling..."
f:run"unfling"
end)


j.flingThread=task.spawn(function()

task.wait(0.1)
if f:getGarbage"fling"~=j then return end

for l,m in i:GetChildren()do
if m:IsA"BasePart"then
m.Massless=true
m.Velocity=Vector3.zero
end
end

k.Parent=h


while f:getGarbage"fling"==j and h.Parent do
k.AngularVelocity=d
task.wait(0.2)
k.AngularVelocity=Vector3.zero
task.wait(0.1)
end
end)end local g=function(


g)
local h=g:collectGarbage"fling"
if not h then return end


if h.flingThread then
task.cancel(h.flingThread)
end

if h.flingVelocity then
h.flingVelocity:Destroy()
end

if h.flingConnection then
h.flingConnection:Disconnect()
end

for i,j in h.originalStates do
for k,l in j do
i[k]=l
end
end

g:notify"fling disabled"end




local h=0.1 local i=function(

i, j)
return i~=nil and i.Parent~=nil and j~=nil and j.Parent~=nil end local j=function(


j)
if j:hasGarbage"walkfling"then
j:notify"walkfling is already enabled\ndisable using 'unwalkfling'"
return
end

local k=j:createGarbage"walkfling"


if not j:hasGarbage"noclip"then
j:run("noclip",b.new{{value="nonotify"}})
k.enabledNoclip=true
end

local l=j.runService local m=function()

return j:getGarbage"walkfling"==k end


k.thread=task.spawn(function()
while m()do
l.Heartbeat:Wait()

local n=j.playerService:getCharacter()
local o=n and n:FindFirstChild"HumanoidRootPart"

while m()and not i(n,o)do
l.Heartbeat:Wait()
n=j.playerService:getCharacter()
o=n and n:FindFirstChild"HumanoidRootPart"
end

if not m()then break end

local p=o.AssemblyLinearVelocity
o.AssemblyLinearVelocity=p*10000+Vector3.new(0,10000,0)

l.RenderStepped:Wait()
if i(n,o)then
o.AssemblyLinearVelocity=p
end

l.Stepped:Wait()
if i(n,o)then
o.AssemblyLinearVelocity=p+Vector3.new(0,h,0)
end
end
end)


local n=j.playerService:getHumanoid()
if n then
k.diedConnection=j:connect(n.Died,function()
j:run"unwalkfling"
end)
end end local k=function(


k)
local l=k:collectGarbage"walkfling"
if not l then return end

if l.diedConnection then
l.diedConnection:Disconnect()
end

if l.enabledNoclip then
k:run("unnoclip",b.new{{value="nonotify"}})
end end local l=function(


l, m)
l:run"unvehiclefly"
l:run"unwalkfling"

local n=m and m:nextValue()
if n then
l.privateEnv.vehicleFlySpeed=n
end


l:run("vehiclefly",b.new{})
j(l)

local o=l:getGarbage"walkfling"
if o then
o.flyfling=true
end end local m=function(


m)
m:run"unvehiclefly"
m:run"unwalkfling"
m:run"breakvelocity"end


return{
{
action="fling|forcefling",
description="Flings anyone you touch",
run=f
},
{
action="unfling|nofling",
description="Disables the fling command",
run=g
},
{
action="flyfling",
description="Basically the invisfling command but not invisible",
args={
kind="number",
name="speed",
optional=true
},
run=l
},
{
action="unflyfling",
description="Disables the flyfling command",
run=m
},
{
action="walkfling",
description="Basically fling but no spinning",
run=j
},
{
action="unwalkfling|nowalkfling",
description="Disables walkfling",
run=k
},
{
action="togglefling",
description="Toggles fling",
run=function(n)
n:run(if n:hasGarbage"fling"then"unfling"else"fling")
end
},
{
action="toggleflyfling",
description="Toggles flyfling",
args={
kind="number",
name="speed",
optional=true
},
run=function(n,o)
local p=n:getGarbage"walkfling"
if p and p.flyfling then
n:run"unflyfling"
else
n:run("flyfling",o)
end
end
},
{
action="togglewalkfling",
description="Toggles walkfling",
run=function(n)
n:run(if n:hasGarbage"walkfling"then"unwalkfling"else"walkfling")
end
},
{
action="toggleantifling",
description="Toggles antifling",
run=function(n)
n:run(if n:hasGarbage"antifling"then"unantifling"else"antifling")
end
},
{
action="invisfling",
description="Enables invisible fling (the invis part is patched, try using the god command before using this)",
run=function(n)
n:run"invisible"

task.spawn(function()
n:run"fling"
end)
end
},
{
action="antifling",
description="Disables player collisions to prevent you from being flung",
run=function(n)
if n:hasGarbage"antifling"then return end

local o=n:createGarbage"antifling"
o.connection=n:connect(n.runService.Stepped,function()
for p,q in n.players:GetPlayers()do
if q~=n.localPlayer and q.Character then
for r,s in q.Character:GetDescendants()do
if s:IsA"BasePart"then
s.CanCollide=false
end
end
end
end
end)
end
},
{
action="unantifling",
description="Disables antifling",
run=function(n)
local o=n:collectGarbage"antifling"
if o then
o.connection:Disconnect()
end
end
}
}end a.aW=function()local c=a.cache.aW if not c then c={c=b()}a.cache.aW=c end return c.c end end do local b=function()local b=function(


b, c)
local d=b.playerService:getCharacter()
if not d then return end

for e,f in d:GetDescendants()do
if(f:IsA"BasePart"or f:IsA"Decal")and c.originals[f]==nil then
c.originals[f]=f.Transparency
f.Transparency=1
end
end end local c=function(


c)
local d=c:getGarbage"invisible"
if d and d.connection and d.connection.Connected then
c:notify("Invisible","you are already invisible")
return
end

local e={}
if d then
e=d.originals or{}
c:collectGarbage"invisible"
if d.connection then
d.connection:Disconnect()
end
end

local f=c:createGarbage"invisible"
f.originals=e

b(c,f)

f.connection=c:connect(c.localPlayer.CharacterAdded,function()
b(c,f)
end)

c:notify("Invisible","other players can no longer see your character")end local d=function(


d)
local e=d:collectGarbage"invisible"
if not e then return false end

if e.connection then
e.connection:Disconnect()
end

for f,g in e.originals do
if f.Parent then
f.Transparency=g
end
end

return true end


return{
{
action="invisible|invis",
description="Makes you invisible to other players",
run=function(e)
c(e)
end
},
{
action="visible|vis|uninvisible",
description="Makes you visible to other players",
run=function(e)
if not d(e)then
e:notify("Visible","you are already visible")
end
end
},
{
action="toggleinvis",
description="Toggles invisibility",
run=function(e)
e:run(if e:hasGarbage"invisible"then"visible"else"invisible")
end
},
{
action="toolinvisible|toolinvis|tinvis",
description="Makes you invisible to other players and able to use tools",
run=function(e)
c(e)
end
}
}end a.aX=function()local c=a.cache.aX if not c then c={c=b()}a.cache.aX=c end return c.c end end do local b=function()local b=function(

b, c)
for d,e in c do
local f=b:FindFirstChild(e)
if f then
f:Destroy()
end
end end local c=function(


c)
local d=c.playerService:getHumanoid()
return d~=nil and d.RigType==Enum.HumanoidRigType.R15 end


return{
{
action="noarms|rarms",
description="Removes your arms",
run=function(d)
local e=d.localPlayer.Character
if e then
b(e,c(d)and{"RightUpperArm","LeftUpperArm"}or{"Right Arm","Left Arm"})
end
end
},
{
action="nolegs|rlegs",
description="Removes your legs",
run=function(d)
local e=d.localPlayer.Character
if e then
b(e,c(d)and{"RightUpperLeg","LeftUpperLeg"}or{"Right Leg","Left Leg"})
end
end
},
{
action="nolimbs|rlimbs",
description="Removes your limbs",
run=function(d)
local e=d.localPlayer.Character
if e then
b(e,c(d)
and{"RightUpperLeg","LeftUpperLeg","RightUpperArm","LeftUpperArm"}
or{"Right Leg","Left Leg","Right Arm","Left Arm"})
end
end
}
}end a.aY=function()local c=a.cache.aY if not c then c={c=b()}a.cache.aY=c end return c.c end end do local b=function()local b=function(


b)
local c=b:collectGarbage"hatspin"
if not c then return end

c.connection:Disconnect()

for d,e in c.accessories do
local f=e:FindFirstChild"Handle"
if f then
for g,h in f:GetChildren()do
if h:IsA"BodyPosition"or h:IsA"BodyAngularVelocity"then
h:Destroy()
end
end
end

if c.character:IsDescendantOf(workspace)then

e.Parent=workspace
task.wait()
e.Parent=c.character
end
end end


return{
{
action="hatspin|spinhats",
description="Spins your characters accessories",
args={
kind="number",
name="spin speed",
optional=true
},
run=function(c,d)
b(c)

local e=c.playerService:getHumanoid()
local f=c.playerService:getCharacter()
if not(e and f)then return end

local g=d:nextValue()or 100

local h=c:createGarbage"hatspin"
h.character=f
h.accessories={}
h.keeps={}

for i,j in e:GetAccessories()do
local k=j:FindFirstChild"Handle"
local l=k and k:FindFirstChildOfClass"Weld"
if l then
l:Destroy()


local m=Instance.new"BodyPosition"
m.P=30000
m.D=50
m.Parent=k

local n=Instance.new"BodyAngularVelocity"
n.AngularVelocity=Vector3.new(0,g,0)
n.MaxTorque=Vector3.new(0,g*2,0)
n.Parent=k

table.insert(h.accessories,j)
table.insert(h.keeps,m)
end
end

h.connection=c:connect(c.runService.Stepped,function()
local i=c.playerService:getCharacter()
if i~=f then
b(c)
return
end

local j=f:FindFirstChild"Head"
if not j then return end

for k,l in h.keeps do
l.Position=j.Position
end
end)
end
},
{
action="unhatspin|unspinhats",
description="Undoes spinhats",
run=function(c)
b(c)
end
},
{
action="clearhats|cleanhats",
description="Clears hats in the workspace",
run=function(c)
local d=c:expectExploit"firetouchinterest"
if not d then return end


task.spawn(function()
local e=c.playerService:getCharacter()
local f=c.playerService:getHumanoid()
local g=c.playerService:getRootPart()
if not(e and f and g)then return end

local h=g.CFrame

local i={}
for j,k in workspace:GetChildren()do
if k:IsA"Accessory"then
table.insert(i,k)
end
end

for j,k in f:GetAccessories()do
k:Destroy()
end

for j,k in i do
local l=k:FindFirstChild"Handle"
local m=c.playerService:getRootPart()
if l and m then
d(l,m,0)
end


local n=0
while e.Parent and not e:FindFirstChildOfClass"Accessory"and n<120 do
task.wait()
n=n+1
end

local o=e:FindFirstChildOfClass"Accessory"
if o then
o:Destroy()
end
task.wait()
end

c.playerService:resetCharacter()
c.localPlayer.CharacterAdded:Wait()


for j=1,20 do
task.wait()
local k=c.playerService:getRootPart()
if k then
k.CFrame=h
end
end
end)
end
}
}end a.aZ=function()local c=a.cache.aZ if not c then c={c=b()}a.cache.aZ=c end return c.c end end do local b=function()



local b=60


local function copyTools(c,d)
for e,f in c:GetChildren()do
if f:IsA"Tool"or f:IsA"HopperBin"then
f:Clone().Parent=d
end
copyTools(f,d)
end
end local c=function(

c)
if not c then return end

for d,e in c:GetChildren()do
if e:IsA"Tool"then
e.CanBeDropped=true
end
end end local d=function(




d, e)
local f=d.playerService:getHumanoid()
if f and e:IsA"BackpackItem"and e:FindFirstChild"Handle"then
f:EquipTool(e)
end end local e=function(


e)
local f=e:collectGarbage"grabtools"
if f and f.connection then
f.connection:Disconnect()
end end local f=function(


f)
e(f)

local g=f:createGarbage"grabtools"

for h,i in workspace:GetChildren()do
d(f,i)
end

g.connection=f:connect(workspace.ChildAdded,function(h)
d(f,h)
end)end local g=function(





g)
local h=g:collectGarbage"reach"
if not h then return end

for i,j in h.records do
local k=j.handle

local l=k:FindFirstChild"SelectionBoxCreated"
if l then
l:Destroy()
end

k.Size=j.size
k.Massless=j.massless
j.tool.GripPos=j.gripPos
end end local h=function(


h, i)
g(h)

local j=h.playerService:getCharacter()
local k=h.playerService:getHumanoid()
if not(j and k)then
h:notify("Reach","your character is not loaded")
return
end

local l=h:createGarbage"reach"
l.records={}

for m,n in j:GetDescendants()do
if not n:IsA"Tool"then continue end

local o=n:FindFirstChild"Handle"
if not(o and o:IsA"BasePart")then continue end

table.insert(l.records,{
tool=n,
handle=o,
size=o.Size,
massless=o.Massless,
gripPos=n.GripPos
})

local p=Instance.new"SelectionBox"
p.Name="SelectionBoxCreated"
p.Adornee=o
p.Parent=o

o.Massless=true
o.Size=i
n.GripPos=Vector3.zero
end


k:UnequipTools()end


return{
{
action="tools|gears",
description="Copies tools from ReplicatedStorage and Lighting",
run=function(i)
local j=i.localPlayer:FindFirstChildOfClass"Backpack"
if not j then
i:notify("Tools","your backpack is not loaded")
return
end

copyTools(i.robloxServices.Lighting,j)
copyTools(i.robloxServices.ReplicatedStorage,j)

i:notify("Tools","Copied tools from ReplicatedStorage and Lighting")
end
},
{
action="grabtools",
description="Automatically get tools that are dropped",
run=function(i)
f(i)
i:notify("Grabtools","Picking up any dropped tools")
end
},
{
action="ungrabtools|nograbtools",
description="Disables grabtools",
run=function(i)
e(i)
i:notify("Grabtools","Grabtools has been disabled")
end
},
{
action="dupetools|clonetools",
description="Duplicates your inventory tools a set amount of times",
args={
kind="number"
},
run=function(i,j)
local k=i.localPlayer:FindFirstChildOfClass"Backpack"
if not k then
i:notify("Dupetools","your backpack is not loaded")
return
end


local l=math.clamp(math.floor(j:nextValue()or 1),1,100)
local m=0

for n,o in k:GetChildren()do
if o:IsA"Tool"or o:IsA"HopperBin"then
for p=1,l do
o:Clone().Parent=k
m=m+1
end
end
end

i:notify("Dupetools",`added {m} tool(s)`)
end
},
{
action="droppabletools",
description="Makes your tools droppable",
run=function(i)
c(i.playerService:getCharacter())
c(i.localPlayer:FindFirstChildOfClass"Backpack")
end
},
{
action="reach",
description="Increases the hitbox of your held tool",
args={
kind="number"
},
run=function(i,j)
local k=j and j:nextValue()or b
h(i,Vector3.new(0.5,0.5,k))
end
},
{
action="boxreach",
description="Increases the hitbox of your held tool in a box shape",
args={
kind="number"
},
run=function(i,j)
local k=j and j:nextValue()or b
h(i,Vector3.one*k)
end
},
{
action="unreach|noreach|unboxreach",
description="Turns off reach",
run=function(i)
g(i)
end
},
{
action="grippos",
description="Changes your current tools grip position",
args={
kind="vector3"
},
run=function(i,j)
local k=i.localPlayer.Character
local l=i.localPlayer:FindFirstChildOfClass"Backpack"
if not(k and l)then return end

local m=j:nextValue()
for n,o in k:GetChildren()do
if o:IsA"Tool"then
o.Parent=l
o.GripPos=m
o.Parent=k
end
end
end
},
{
action="usetools",
description="Activates all tools in your backpack at the same time",
args={
{
kind="number",
name="tools amount",
optional=true
},
{
kind="number",
name="equip delay",
optional=true
}
},
run=function(i,j)
local k=i.localPlayer:FindFirstChildOfClass"Backpack"
local l=i.playerService:getCharacter()
if not(k and l)then return end

local m=j:nextValue()or 1
local n=j:nextValue()

for o,p in k:GetChildren()do
if not p:IsA"Tool"then continue end

p.Parent=l
task.spawn(function()
for q=1,m do
p:Activate()
if n then
task.wait(n)
end
end
p.Parent=k
end)
end
end
}
}end a.a_=function()local c=a.cache.a_ if not c then c={c=b()}a.cache.a_=c end return c.c end end do local b=function()local b=function(


b, c)
local d=b:collectGarbage(c)
if d then
d.connection:Disconnect()
end end local c=function(



c, d)
local e=c.CFrame.LookVector*3
local f=Ray.new(c.Position-Vector3.new(0,1.5,0),e)
local g=Ray.new(c.Position+Vector3.new(0,1.5,0),e)

return workspace:FindPartOnRay(f,d)~=nil or workspace:FindPartOnRay(g,d)~=nil end


return{
{
action="autojump|ajump",
description="Automatically jumps when you run into an object",
run=function(d)
b(d,"autojump")

local e=d:createGarbage"autojump"
e.connection=d:connect(d.runService.RenderStepped,function()
local f=d.playerService:getCharacter()
local g=d.playerService:getHumanoid()
local h=d.playerService:getRootPart()
if f and g and h and c(h,f)then
g.Jump=true
end
end)
end
},
{
action="unautojump|noautojump|noajump|unajump",
description="Disables autojump",
run=function(d)
b(d,"autojump")
end
},
{
action="edgejump|ejump",
description="Automatically jumps when you get to the edge of an object",
run=function(d)
b(d,"edgejump")

local e=d:createGarbage"edgejump"
e.connection=d:connect(d.runService.RenderStepped,function()
local f=d.playerService:getHumanoid()
local g=d.playerService:getRootPart()
if not(f and g)then return end

local h=e.state
local i=f:GetState()
e.state=i


if h~=i and i==Enum.HumanoidStateType.Freefall and h~=Enum.HumanoidStateType.Jumping and e.lastCFrame then
g.CFrame=e.lastCFrame
local j=g.AssemblyLinearVelocity
g.AssemblyLinearVelocity=Vector3.new(j.X,f.JumpPower,j.Z)
end

e.lastCFrame=g.CFrame
end)
end
},
{
action="unedgejump|noedgejump|noejump|unejump",
description="Disables edgejump",
run=function(d)
b(d,"edgejump")
end
}
}end a.a0=function()local c=a.cache.a0 if not c then c={c=b()}a.cache.a0=c end return c.c end end do local b=function()local b=function(




b, c, d)
local e=b.privateEnv.spoofs or{}
b.privateEnv.spoofs=e

local f=e[c]
if f then
f.value=d
return
end

local g=b:expectExploit"hookmetamethod"
local h=b:expectExploit"checkcaller"
if not(g and h)then return end

local i=b.localPlayer
local j=string.lower(c)

f={value=d}
e[c]=f local k=function(

k, l)
if h()or typeof(k)~="Instance"or typeof(l)~="string"then
return false
end
if string.lower(l)~=j or not k:IsA"Humanoid"then
return false
end

local m=i.Character
return m~=nil and k:IsDescendantOf(m)end


local l
l=g(game,"__index",function(m,n)
if k(m,n)then
return f.last or f.value
end
return l(m,n)
end)

local m
m=g(game,"__newindex",function(n,o,p)
if k(n,o)then
f.last=tonumber(p)
end
return m(n,o,p)
end)end


return{
{
action="spoofspeed|spoofws",
description="Spoofs your WalkSpeed on the Client",
args={
kind="number"
},
run=function(c,d)
local e=d:nextValue()
if e then
b(c,"WalkSpeed",e)
end
end
},
{
action="spoofjumppower|spoofjp",
description="Spoofs your JumpPower on the Client",
args={
kind="number"
},
run=function(c,d)
local e=d:nextValue()
if e then
b(c,"JumpPower",e)
end
end
}
}end a.a1=function()local c=a.cache.a1 if not c then c={c=b()}a.cache.a1=c end return c.c end end do local b=function()

local b=a.S()local c=function(


c)
if c==1 then
return Vector3.new(2,1,1)
end
return Vector3.one*c end


return{
{
action="headsize",
description="Expands the head size for players Head (default is 1)",
args={
{
kind="player"
},
{
kind="number",
name="head size",
optional=true
}
},
run=function(d,e)
local f=b(e:nextValue())
local g=e:nextValue()or 1

for h,i in f do
local j=i~=d.localPlayer and i.Character and i.Character:FindFirstChild"Head"
if j and j:IsA"BasePart"then
j.CanCollide=false
j.Size=c(g)
end
end
end
},
{
action="hitbox",
description="Expands the hitbox for players HumanoidRootPart (default is 1)",
args={
{
kind="player"
},
{
kind="number",
name="size",
optional=true
},
{
kind="number",
name="transparency",
optional=true,
clamp={0,1}
}
},
run=function(d,e)
local f=b(e:nextValue())
local g=e:nextValue()or 1
local h=e:nextValue()or 0.4

for i,j in f do
local k=j~=d.localPlayer and j.Character and j.Character:FindFirstChild"HumanoidRootPart"
if k and k:IsA"BasePart"then
k.CanCollide=false
k.Size=c(g)
k.Transparency=h
end
end
end
}
}end a.a2=function()local c=a.cache.a2 if not c then c={c=b()}a.cache.a2=c end return c.c end end do local b=function()

local b=a.S()local c=function(

c)
local d=c:collectGarbage"orbit"
if not d then return end

for e,f in d.connections do
f:Disconnect()
end end


return{
{
action="orbit",
description="Makes your character orbit around a player with an optional speed and an optional distance",
args={
{
kind="player"
},
{
kind="number",
name="speed",
optional=true
},
{
kind="number",
name="distance",
optional=true
}
},
run=function(d,e)
c(d)

local f=b(e:nextValue())[1]
local g=e:nextValue()or 0.2
local h=e:nextValue()or 6

local i=d.playerService:getHumanoid()
if not(f and i)then return end

local j=d:createGarbage"orbit"
j.connections={}

local k=0 local l=function()


return f.Character and f.Character:FindFirstChild"HumanoidRootPart"end


table.insert(j.connections,d:connect(d.runService.Heartbeat,function()
local m=d.playerService:getRootPart()
local n=l()
if not(m and n)then return end

k=k+g
m.CFrame=CFrame.new(n.Position)*CFrame.Angles(0,math.rad(k),0)*CFrame.new(h,0,0)
end))


table.insert(j.connections,d:connect(d.runService.RenderStepped,function()
local m=d.playerService:getRootPart()
local n=l()
if m and n then
m.CFrame=CFrame.new(m.Position,n.Position)
end
end))

table.insert(j.connections,d:connect(i.Died,function()
c(d)
end))

table.insert(j.connections,d:connect(i.Seated,function(m)
if m then
c(d)
end
end))

d:notify("Orbit","Started orbiting "..f.Name)
end
},
{
action="unorbit",
description="Disables orbit",
run=function(d)
if not d:hasGarbage"orbit"then return end

c(d)
d:notify("Orbit","Stopped orbiting player")
end
}
}end a.a3=function()local c=a.cache.a3 if not c then c={c=b()}a.cache.a3=c end return c.c end end do local b=function()

local b=a.S()local c=function(

c)
local d=c:collectGarbage"headsit"
if d then
d.connection:Disconnect()
end end


return{
{
action="headsit",
description="Sit on a players head",
args={
kind="player"
},
run=function(d,e)
local f=b(e:nextValue())[1]
if not f then return end

c(d)

local g=d.playerService:getHumanoid()
if not g then return end
g.Sit=true

local h=d:createGarbage"headsit"
h.connection=d:connect(d.runService.Heartbeat,function()
local i=d.playerService:getRootPart()
local j=d.playerService:getHumanoid()
local k=f.Character and f.Character:FindFirstChild"HumanoidRootPart"

if not(i and j and k and j.Sit)then
c(d)
return
end

i.CFrame=k.CFrame*CFrame.new(0,1.6,0.4)
end)
end
}
}end a.a4=function()local c=a.cache.a4 if not c then c={c=b()}a.cache.a4=c end return c.c end end do local b=function()

return{
{
action="god",
description="Makes your character difficult to kill in most games",
run=function(b)
local c=b.localPlayer
local d=c.Character
local e=d and d:FindFirstChildWhichIsA"Humanoid"
if not e then return end

local f=workspace.CurrentCamera
local g=f.CFrame


local h=e:Clone()
h.Parent=d

c.Character=nil
h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
h.BreakJointsOnDeath=true
e:Destroy()
c.Character=d

f.CameraSubject=h
task.wait()
f.CFrame=g
h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None


local i=d:FindFirstChild"Animate"
if i then
i.Disabled=true
task.wait()
i.Disabled=false
end

h.Health=h.MaxHealth
end
}
}end a.a5=function()local c=a.cache.a5 if not c then c={c=b()}a.cache.a5=c end return c.c end end do local b=function()

local b=a.S()


local c=workspace.FallenPartsDestroyHeight


local d="rbxassetid://72042024"local e=function(

e)
if e.track then
e.track:Stop()
end
if e.connection then
e.connection:Disconnect()
end end


return{
{
action="fakeout",
description="Tp to the void and then back (useful to kill people attached to you)",
run=function(f)
local g=f.playerService:getRootPart()
if not g then return end

local h=g.CFrame


local i=f:hasGarbage"antivoid"
if i then
f:run"unantivoid"
end


pcall(function()
workspace.FallenPartsDestroyHeight=0/0
end)

g.CFrame=CFrame.new(0,c-25,0)
task.wait(1)

local j=f.playerService:getRootPart()
if j then
j.CFrame=h
end

pcall(function()
workspace.FallenPartsDestroyHeight=c
end)

if i then
f:run"antivoid"
end
end
},
{
action="scare|spook",
description="Teleports in front of a player for half a second",
args={
kind="player"
},
run=function(f,g)
local h=b(g:nextValue())[1]
local i=f.playerService:getRootPart()
local j=h and h~=f.localPlayer and h.Character and h.Character:FindFirstChild"HumanoidRootPart"
if not(i and j)then return end

local k=i.CFrame
i.CFrame=j.CFrame+j.CFrame.LookVector*2
i.CFrame=CFrame.new(i.Position,j.Position)
task.wait(0.5)

local l=f.playerService:getRootPart()
if l then
l.CFrame=k
end
end
},
{
action="jerk",
description="Makes you jork it",
run=function(f)
local g=f:collectGarbage"jerk"
if g then
local h=g.track~=nil and g.track.IsPlaying
e(g)
if h then return end
end

local h=f.playerService:getHumanoid()
local i=h and h:FindFirstChildOfClass"Animator"
if not i then
f:notify("Jerk","your character has no Animator")
return
end

local j=Instance.new"Animation"
j.AnimationId=d

local k,l=pcall(function()
return i:LoadAnimation(j)
end)
if not k then
f:notify("Jerk","could not load the jerk animation (check JERK_ANIMATION_ID in scare.luau)")
return
end

l.Looped=true
l:Play()

local m=f:createGarbage"jerk"
m.track=l

m.connection=f:connect(h.Died,function()
local n=f:collectGarbage"jerk"
if n then
e(n)
end
end)
end
}
}end a.a6=function()local c=a.cache.a6 if not c then c={c=b()}a.cache.a6=c end return c.c end end do local b=function()

local b=a.S()

local c="rbxassetid://148840371"
local d="rbxassetid://5918726674"
local e="rbxassetid://282574440"local f=function(


f)
if not f then return nil end

return f:FindFirstChild"Torso"
or f:FindFirstChild"UpperTorso"
or f:FindFirstChild"LowerTorso"
or f:FindFirstChild"HumanoidRootPart"end local g=function(



g, h)
local i=Instance.new"Animation"
i.AnimationId=h

local j=g:LoadAnimation(i)
j:Play(0.1,1,1)
return j,i end local h=function(


h)
local i=h:collectGarbage"bang"
if not i then return end

for j,k in i.connections do
k:Disconnect()
end
i.track:Stop()
i.animation:Destroy()end local i=function(


i)
local j=i:collectGarbage"carpet"
if not j then return end

for k,l in j.connections do
l:Disconnect()
end
j.track:Stop()
j.animation:Destroy()end


return{
{
action="bang",
description="owo",
args={
{
kind="player"
},
{
kind="number",
name="speed",
optional=true
}
},
run=function(j,k)
h(j)

local l=b(k:nextValue())[1]
local m=k:nextValue()or 3

local n=j.playerService:getHumanoid()
if not(l and n)then return end

local o=n.RigType==Enum.HumanoidRigType.R15 and d or c
local p,q=g(n,o)
p:AdjustSpeed(m)

local r=j:createGarbage"bang"
r.track=p
r.animation=q
r.connections={}

table.insert(r.connections,j:connect(n.Died,function()
h(j)
end))

local s=CFrame.new(0,0,1.1)
table.insert(r.connections,j:connect(j.runService.Stepped,function()
local t=j.playerService:getRootPart()
local u=f(l.Character)
if t and u then
t.CFrame=u.CFrame*s
end
end))
end
},
{
action="unbang",
description="uwu",
run=function(j)
h(j)
end
},
{
action="carpet",
description="Be someones carpet",
args={
kind="player"
},
run=function(j,k)
local l=j.playerService:getHumanoid()
if not l then return end

if l.RigType==Enum.HumanoidRigType.R15 then
j:notify("R6 Required","This command requires the r6 rig type")
return
end

i(j)

local m=b(k:nextValue())[1]
if not m then return end

local n,o=g(l,e)

local p=j:createGarbage"carpet"
p.track=n
p.animation=o
p.connections={}

table.insert(p.connections,j:connect(l.Died,function()
i(j)
end))

table.insert(p.connections,j:connect(j.runService.Heartbeat,function()
local q=j.playerService:getRootPart()
local r=m.Character and m.Character:FindFirstChild"HumanoidRootPart"
if q and r then
q.CFrame=r.CFrame
end
end))
end
},
{
action="uncarpet",
description="Undoes carpet",
run=function(j)
i(j)
end
}
}end a.a7=function()local c=a.cache.a7 if not c then c={c=b()}a.cache.a7=c end return c.c end end do local b=function()

local b=a.S()

local c="507768375"
local d="180435571"

return{
{
action="copyanimation|copyanim|copyemote",
description="Copies someone elses animation",
args={
kind="player"
},
run=function(e,f)
local g=e.playerService:getHumanoid()
if not g then return end

for h,i in b(f:nextValue())do
local j=i.Character and i.Character:FindFirstChildOfClass"Humanoid"
if j then
for k,l in g:GetPlayingAnimationTracks()do
l:Stop()
end

for k,l in j:GetPlayingAnimationTracks()do
if not string.find(l.Animation.AnimationId,c,1,true)then
local m=g:LoadAnimation(l.Animation)
m:Play(0.1,1,l.Speed)
m.TimePosition=l.TimePosition

task.spawn(function()
l.Stopped:Wait()
m:Stop()
m:Destroy()
end)
end
end
end
end
end
},
{
action="copyanimationid|copyanimid|copyemoteid",
description="Copies your animation id or someone elses to your clipboard",
args={
kind="player",
optional=true
},
run=function(e,f)
local g=e:expectExploit"setclipboard"
if not g then return end

local h=e.localPlayer
local i=f:nextValue()
if i then
h=b(i)[1]
end

local j=h and h.Character and h.Character:FindFirstChildWhichIsA"Humanoid"
if not j then
e:notify("Animations","character is not loaded")
return
end

local k={}
for l,m in j:GetPlayingAnimationTracks()do
local n=m.Animation.AnimationId
local o=string.find(n,c,1,true)
or string.find(n,d,1,true)

if not o then
local p=string.match(n,"rbxassetid://(%d+)")
if p then
local q,r=pcall(function()
return e.robloxServices.MarketplaceService:GetProductInfo(tonumber(p))
end)

local s="Failed to get name"
if q then
s=r.Name
end

table.insert(k,"Name: "..s.."\nAnimation Id: "..n)
else
table.insert(k,"Animation Id: "..n)
end
end
end

if#k==0 then
e:notify("Animations","No animations to copy")
return
end

g("Animations Copied\n\n"..table.concat(k,"\n\n"))
e:notify("Animations","Copied to clipboard")
end
}
}end a.a8=function()local c=a.cache.a8 if not c then c={c=b()}a.cache.a8=c end return c.c end end do local b=function()

return{a.aB()
,a.aC()
,a.aD()
,a.aE()
,a.aF()
,a.aG()
,a.aH()
,a.aI()
,a.aJ()
,a.aK()
,a.aL()
,a.aM()
,a.aN()
,a.aO()
,a.aP()
,a.aQ()
,a.aR()
,a.aS()
,a.aT()
,a.aU()
,a.aV()
,a.aW()
,a.aX()

,a.aY()
,a.aZ()
,a.a_()
,a.a0()
,a.a1()
,a.a2()
,a.a3()
,a.a4()
,a.a5()
,a.a6()
,a.a7()
,a.a8()

}end a.a9=function()local c=a.cache.a9 if not c then c={c=b()}a.cache.a9=c end return c.c end end do local b=function()

return a.ak().new"storage/createdWaypoints"end a.ba=function()local c=a.cache.ba if not c then c={c=b()}a.cache.ba=c end return c.c end end do local b=function()
local b={}

local c={Vector3=
function(c)
return`{c.X} {c.Y} {c.Z}`
end,Color3=
function(c)
return`{c.R} {c.G} {c.B}`
end
}

local d={Vector3=
function(d)
local e=d:split" "
return Vector3.new(e[1]or 0,e[2]or 0,e[3]or 0)
end,Color3=
function(d)
local e=d:split" "
return Color3.new(e[1]or 0,e[2]or 0,e[3]or 0)
end
}

b.stringify=function(e, f)
local g=c[typeof(f)]
assert(g,"can't convert to string")

return g(f)end


b.unstringify=function(e, f, g)
local h=d[g]
assert(h,"can't convert to value")

return h(f)end


return b end a.bb=function()local c=a.cache.bb if not c then c={c=b()}a.cache.bb=c end return c.c end end do local b=function()











local b=a.ba()
local c=a.b()
local d=a.R()
local e=a.bb()

local f="showingWaypoints"


local g=c.iyGarbages or{}
c.iyGarbages=g



local h={}local i=function()


return tostring(game.PlaceId)end local j=function(



j)
if j then
return b:register(i(),{})
end

local k=b:getValue(i())
return if type(k)=="table"then k else nil end local k=function(


k)
local l=0

if type(k)=="table"then
for m in k do
l=l+1
end
end

return l end local l=function(



l)
if type(l)~="string"then return nil end

local m,n=pcall(e.unstringify,e,l,"Vector3")
if m and typeof(n)=="Vector3"then
return n
end

return nil end



h.list=function()
local m={}

for n,o in j()or{}do
local p=l(o)

if p then
table.insert(m,{name=n,position=p})
end
end

table.sort(m,function(n,o)
return n.name:lower()<o.name:lower()
end)

return m end



h.find=function(m)
local n=m:lower()

for o,p in h.list()do
if p.name:lower()==n then
return p
end
end

return nil end



h.count=function()
return k(j())end



h.countAll=function()
local m=0

for n,o in b:getData()do
m=m+k(o)
end

return m end




h.save=function(m, n)
local o=(j(true))
local p=m:lower()
local q=false

for r in o do
if r:lower()==p then
o[r]=nil
q=true
end
end

o[m]=(e:stringify(n))
b:save()

return q end



h.remove=function(m)
local n=j()
local o=m:lower()
local p=false

if type(n)=="table"then
for q in n do
if q:lower()==o then
n[q]=nil
p=true
end
end
end

if p then
b:save()
end

return p end



h.clearPlace=function()
local m=h.count()

b:setValue(i(),nil)
b:save()

return m end



h.clearAll=function()
local m=0


for n,o in b:getData()do
m=m+k(o)
b:setValue(n,nil)
end

b:save()

return m end



h.format=function(m)
return`({math.round(m.X)}, {math.round(m.Y)}, {math.round(m.Z)})`end



h.parsePosition=function(m)
local n={}

for o in m:gmatch"[^%s,;]+"do
local p=tonumber(o)

if p==nil or p~=p or math.abs(p)==math.huge then
return nil
end

table.insert(n,p)
end

if#n~=3 then
return nil
end

return Vector3.new(n[1],n[2],n[3])end




h.go=function(m, n, o)
if n=="tween"then
o=if typeof(o)=="number"then o else nil

local p=d:tweenTeleportTo{
target=CFrame.new(m.position),
speed=o or c.tweenSpeed,
}

return p~=nil
end

if n=="walk"then
local p=d:unseat()
if not p then return false end

p:MoveTo(m.position)
return true
end

return d:teleportTo(CFrame.new(m.position))end




h.isShown=function()
return g[f]~=nil end



h.hide=function()
local m=g[f]
if m==nil then return false end

g[f]=nil

for n,o in m do
o:Destroy()
end

return true end local m=function(


m)
local n=Instance.new"Part"
n.Size=Vector3.new(5,5,5)
n.CFrame=CFrame.new(m.position)
n.Anchored=true
n.CanCollide=false
n.CanTouch=false
n.CanQuery=false
n.Parent=workspace

local o=Instance.new"BoxHandleAdornment"
o.Adornee=n
o.AlwaysOnTop=true
o.ZIndex=10
o.Size=n.Size
o.Parent=n

local p=Instance.new"BillboardGui"
p.Adornee=n
p.AlwaysOnTop=true
p.Size=UDim2.fromOffset(160,30)
p.StudsOffset=Vector3.new(0,4,0)
p.Parent=n

local q=Instance.new"TextLabel"
q.BackgroundTransparency=1
q.Size=UDim2.fromScale(1,1)
q.Text=m.name
q.TextColor3=Color3.new(1,1,1)
q.TextStrokeTransparency=0
q.TextScaled=true
q.Parent=p

return n end



h.show=function()
h.hide()

local n={}
local o=h.list()

for p,q in o do
table.insert(n,m(q))
end

g[f]=n
return#o end



h.refreshMarkers=function()
if h.isShown()then
h.show()
end end


return h end a.bc=function()local c=a.cache.bc if not c then c={c=b()}a.cache.bc=c end return c.c end end do local b=function()




local b=a.bc()

local c="Waypoints"local d=function(


d, e)
local f=b.find(e)

if not f then
d:notify(c,`there is no waypoint named '{e}'`)
end

return f end local e=function(


e, f, g)
local h=d(e,f:nextValue())
if not h then return end

local i=f:nextValue()
i=if typeof(i)=="number"then i else nil

b.go(h,g,i)end


return{
{
action="setwaypoint|swp|setwp|spos|savepos|setpos",
description="Sets a waypoint at your position",
args={kind="string",name="waypoint name"},
run=function(f,g)
local h=f:getRoot()
if not h then return end

local i=g:nextValue()

b.save(i,h.Position)
b.refreshMarkers()
f:notify(c,`saved waypoint '{i}' at {b.format(h.Position)}`)
end
},
{
action="waypointpos|wpp",
description="Sets a waypoint with specified coordinates",
args={
{kind="string",name="waypoint name"},
{kind="vector3",name="position"},
},
run=function(f,g)
local h=g:nextValue()
local i=g:nextValue()

b.save(h,i)
b.refreshMarkers()
f:notify(c,`saved waypoint '{h}' at {b.format(i)}`)
end
},
{
action="waypoints|positions",
description="Shows a list of currently active waypoints",
run=function(f)
local g=b.list()

if#g==0 then
f:notify(c,"there are no waypoints in this game")
return
end

local h={}
for i,j in g do
table.insert(h,`{j.name} {b.format(j.position)}`)
end

f:notify(c,table.concat(h,", "))
end
},
{
action="showwaypoints|showwp|showwps",
description="Shows all currently set waypoints",
run=function(f)
if b.count()==0 then
f:notify(c,"there are no waypoints to show")
return
end

b.show()
end
},
{
action="hidewaypoints|hidewp|hidewps",
description="Hides shown waypoints",
run=function()
b.hide()
end
},
{
action="waypoint|wp|gotowaypoint|gotowp|gwp|loadpos|lpos|loadposition",
description="Teleports player to a waypoint",
args={kind="waypoint",name="waypoint"},
run=function(f,g)
e(f,g,"teleport")
end
},
{
action="tweenwaypoint|twp|tweengotowaypoint|tgotowp",
description="Tweens player to a waypoint",
args={
{kind="waypoint",name="waypoint"},
{name="tween_speed",kind="number",optional=true},
},
run=function(f,g)
e(f,g,"tween")
end
},
{
action="walktowaypoint|wtwp|walktowp",
description="Walks player to a waypoint",
args={kind="waypoint",name="waypoint"},
run=function(f,g)
e(f,g,"walk")
end
},
{
action="deletewaypoint|dwp|deletepos|dpos",
description="Deletes a waypoint",
args={kind="waypoint",name="waypoint"},
run=function(f,g)
local h=d(f,g:nextValue())
if not h then return end

b.remove(h.name)
b.refreshMarkers()
f:notify(c,`deleted waypoint '{h.name}'`)
end
},
{
action="clearwaypoints|cwp|clearpositions|clearpos|cpos",
description="Clears all waypoints from every game",
args={kind="boolean",name="confirm",optional=true},
run=function(f,g)
local h=g:nextValue()
if not h then
f:notify(c,"cancelled, use 'true' to confirm")
return
end

local i=b.clearAll()

b.hide()
f:notify(c,`deleted {i} waypoints from every game`)
end
},
{
action="cleargamewaypoints|cgamewp",
description="Clears all waypoints for the game you are in",
args={kind="boolean",name="confirm",optional=true},
run=function(f,g)
local h=g:nextValue()
if not h then
f:notify(c,"cancelled, use 'true' to confirm")
return
end

local i=b.clearPlace()

b.hide()
f:notify(c,`deleted {i} waypoints from this game`)
end
}
}end a.bd=function()local c=a.cache.bd if not c then c={c=b()}a.cache.bd=c end return c.c end end do local b=function()

return{
action="tweenspeed|tspeed",
description="Sets how fast the tween commands move you, in studs per second (default is 100)",
args={kind="number",name="tween speed",optional=true},
run=function(b,c)

b.privateEnv.tweenSpeed=c:nextValue()
end
}end a.be=function()local c=a.cache.be if not c then c={c=b()}a.cache.be=c end return c.c end end do local b=function()

local b=a.S()local c=function(


c)
local d=c:collectGarbage"loopgoto"
if d and d.id then
c.loopService:remove(d.id)
end end local d=function(



d)
for e,f in d do
if f.Character then
return f.Character
end
end
return nil end local e=function(



e)
local f=e:GetPivot()
local g=f.Position
return CFrame.new(g+f.LookVector*3,g)end


return{
{
action="goto|to",
description="Go to a player",
args={kind="player"},
run=function(f,g)
local h=d(b(g:nextValue()))
if not h then return end

f.playerService:waitForStreamPlayerCharacter(h)
f.playerService:teleportTo(e(h))
end
},
{
action="tweengoto|tgoto|tweento|tto",
description="Tween to a player (bypasses some anti cheats)",
args={
{kind="player"},
{
kind="number",
name="tween speed",
optional=true
}
},
run=function(f,g)
local h=d(b(g:nextValue()))
if not h then return end

local i=g:nextValue()or f.privateEnv.tweenSpeed
f.playerService:tweenTeleportTo{
target=e(h),
speed=i
}
end
},
{
action="loopgoto",
description="Loop teleport to a player",
args={
{kind="player"},
{
kind="number",
name="distance",
optional=true
},
{
kind="number",
name="delay",
optional=true
}
},
run=function(f,g)
c(f)

local h=b(g:nextValue())[1]
local i=g:nextValue()or 3
local j=g:nextValue()or 0
if not h then return end

f.playerService:unseat()

local k=f:createGarbage"loopgoto"
k.id=f.loopService:add(function()
if h.Parent==nil then
c(f)
return
end

local l=h.Character
if l then
f.playerService:setRootCFrame(l:GetPivot()+Vector3.new(i,1,0))
end
end,j)
end
},
{
action="unloopgoto|noloopgoto",
description="Stops teleporting you to a player",
run=function(f)
c(f)
end
}
}end a.bf=function()local c=a.cache.bf if not c then c={c=b()}a.cache.bf=c end return c.c end end do local b=function()

local b=a.S()

return{
action="vehiclegoto|vgoto|vehicletp|vtp",
description="Go to a player while in a vehicle",
args={kind="player"},
run=function(c,d)
local e=c.playerService:getHumanoid()
local f=e and e.SeatPart
if not f then
c:notify("vehiclegoto","you are not sitting in a vehicle")
return
end

local g=b(d:nextValue())[1]
local h=g and g.Character and g.Character:FindFirstChild"HumanoidRootPart"
if not h then return end


local i=f:FindFirstAncestorWhichIsA"Model"
if i then
i:PivotTo(h:GetPivot())
end
end
}end a.bg=function()local c=a.cache.bg if not c then c={c=b()}a.cache.bg=c end return c.c end end do local b=function()

local b=a.S()

return{
action="pulsetp|ptp",
description="Teleports you to a player for a specified amount of time",
args={
{
kind="player"
},
{
kind="number",
name="time amount",
optional=true
}
},
run=function(c,d)
local e=b(d:nextValue())[1]
local f=d:nextValue()or 1

local g=e and e.Character and e.Character:FindFirstChild"HumanoidRootPart"
if not g then return end

local h=c.playerService:getRootPart()
if not h then return end
local i=h.CFrame

c.playerService:teleportTo(g.CFrame+Vector3.new(3,1,0))
task.wait(f)

c.playerService:setRootCFrame(i)
end
}end a.bh=function()local c=a.cache.bh if not c then c={c=b()}a.cache.bh=c end return c.c end end do local b=function()

local b=a.S()local c=function(


c, d)
local e=c:getGarbage"loopbring"
if not e then return end

if d then
for f,g in d do
e.targets[g]=nil
end
else
e.targets={}
end

if next(e.targets)==nil then
c:collectGarbage"loopbring"
if e.id then
c.loopService:remove(e.id)
end
end end


return{
{
action="clientbring|cbring",
description="Bring a player (CLIENT)",
args={
kind="player"
},
run=function(d,e)
for f,g in b(e:nextValue())do
local h=g.Character
local i=h and h:FindFirstChild"HumanoidRootPart"
if i then
local j=h:FindFirstChildOfClass"Humanoid"
if j then
j.Sit=false
end
task.wait()

local k=d.playerService:getRootPart()
if k then
i.CFrame=k.CFrame+Vector3.new(3,1,0)
end
end
end
end
},
{
action="loopbring",
description="Loop brings a player to you (useful for killing) (CLIENT)",
args={
{
kind="player"
},
{
kind="number",
name="distance",
optional=true
},
{
kind="number",
name="bring delay",
optional=true
}
},
run=function(d,e)
local f=b(e:nextValue())
local g=e:nextValue()or 3
local h=e:nextValue()or 0


local i=d:registerGarbage"loopbring"
i.targets=i.targets or{}
i.distance=g
for j,k in f do
if k~=d.localPlayer then
i.targets[k]=true
end
end

if i.id then
d.loopService:remove(i.id)
end

i.id=d.loopService:add(function()
local j=d.playerService:getRootPart()

for k in i.targets do
if k.Parent==nil then
i.targets[k]=nil
else
local l=k.Character and k.Character:FindFirstChild"HumanoidRootPart"
if j and l then
l.CFrame=j.CFrame+Vector3.new(i.distance,1,0)
end
end
end
end,h)
end
},
{
action="unloopbring|noloopbring",
description="Undoes loopbring",
args={
kind="player",
optional=true
},
run=function(d,e)
local f=e:nextValue()
if f then
c(d,b(f))
else
c(d,nil)
end
end
}
}end a.bi=function()local c=a.cache.bi if not c then c={c=b()}a.cache.bi=c end return c.c end end do local b=function()

local b=a.S()

local c="IYFloatPlatform"

return{
{
client=true,
action="freeze|fr",
description="Freezes a player",
args={kind="player"},
run=function(d,e)
for f,g in b(e:nextValue())do
local h=g.Character
if h then
for i,j in h:GetDescendants()do
if j:IsA"BasePart"and not j.Anchored then
j.Anchored=true
end
end
end
end
end
},
{
client=true,
action="unfreeze|thaw|unfr",
description="Unfreezes a player",
args={kind="player"},
run=function(d,e)
for f,g in b(e:nextValue())do
local h=g.Character
if h then
for i,j in h:GetDescendants()do
if j:IsA"BasePart"and j.Anchored and j.Name~=c then
j.Anchored=false
end
end
end
end
end
}
}end a.bj=function()local c=a.cache.bj if not c then c={c=b()}a.cache.bj=c end return c.c end end do local b=function()local b=function(


b, c)
local d=b.playerService:getCharacter()
if not d then return end

local e=d:FindFirstChildOfClass"Humanoid"or d:FindFirstChildOfClass"AnimationController"
if not e then return end

for f,g in e:GetPlayingAnimationTracks()do
g:AdjustSpeed(c)
end end


return{
{
action="freezeanims",
description="Freezes your animations / pauses your animations - Does not work on default animations",
run=function(c)
b(c,0)
end
},
{
action="unfreezeanims",
description="Unfreezes your animations / plays your animations",
run=function(c)
b(c,1)
end
}
}end a.bk=function()local c=a.cache.bk if not c then c={c=b()}a.cache.bk=c end return c.c end end do local b=function()local b=function(

b, c)
local d=b.playerService:getRootPart()
if d then
d.Anchored=c
end end


return{
{
action="anchor",
description="Anchors your characters RootPart",
run=function(c)
b(c,true)
end
},
{
action="unanchor",
description="Unanchors your characters RootPart",
run=function(c)
b(c,false)
end
}
}end a.bl=function()local c=a.cache.bl if not c then c={c=b()}a.cache.bl=c end return c.c end end do local b=function()

return{
{
action="tpposition|tppos",
description="Teleports you to certain coordinates",
args={kind="vector3"},
run=function(b,c)
b.playerService:teleportTo(c:nextValue())
end
},
{
action="tweentpposition|ttppos",
description="Tween to coordinates (bypasses some anti cheats)",
args={
{
kind="vector3"
},
{
kind="number",
name="tween speed",
optional=true
}
},
run=function(b,c)
local d=c:nextValue()
local e=c:nextValue()or b.privateEnv.tweenSpeed

b.playerService:tweenTeleportTo{
target=d,
speed=e
}
end
},
{
action="offset",
description="Offsets you by certain coordinates",
args={kind="vector3"},
run=function(b,c)
local d=b.playerService:getCharacter()
if d then
d:TranslateBy(c:nextValue())
end
end
},
{
action="tweenoffset|toffset",
description="Tween offset (bypasses some anti cheats)",
args={
{
kind="vector3"
},
{
kind="number",
name="tween speed",
optional=true
}
},
run=function(b,c)
local d=c:nextValue()
local e=c:nextValue()or b.privateEnv.tweenSpeed

local f=b.playerService:getRootPart()
if not f then return end

b.playerService:tweenTeleportTo{
target=f.Position+d,
speed=e
}
end
},
{
action="thru",
description="Teleports you [num] studs ahead of where your character is facing",
args={
kind="number",
optional=true
},
run=function(b,c)
local d=c:nextValue()or 5
local e=b.playerService:getRootPart()
if not e then return end

local f=e.CFrame.LookVector
local g=e.CFrame.Position+f*d
b.playerService:teleportTo(CFrame.new(g,g+f))
end
}
}end a.bm=function()local c=a.cache.bm if not c then c={c=b()}a.cache.bm=c end return c.c end end do local b=function()

local b=a.S()local c=function(


c, d)
local e=c.localPlayer
if d then
e=b(d)[1]
end

local f=e and e.Character
local g=f and(f:FindFirstChild"HumanoidRootPart"or f:FindFirstChildWhichIsA"BasePart")
if not g then return nil end

local h=g.Position
return tostring(math.round(h.X))..", "..tostring(math.round(h.Y))..", "..tostring(math.round(h.Z))end


return{
{
action="notifyposition|notifypos",
description="Notifies you the coordinates of a character",
args={
kind="player",
optional=true
},
run=function(d,e)
local f=c(d,e:nextValue())
if f then
d:notify("Position",f)
else
d:notify("Position","character is not loaded")
end
end
},
{
action="getposition|getpos",
description="Notifies you the coordinates of a player",
args={
kind="player"
},
run=function(d,e)
for f,g in b(e:nextValue())do
local h=c(d,g.Name)
d:notify(`{g.Name} Position`,h or"character is not loaded")
end
end
},
{
action="copyposition|copypos",
description="Copies the coordinates of a character to your clipboard",
args={
kind="player",
optional=true
},
run=function(d,e)
local f=d:expectExploit"setclipboard"
if not f then return end

local g=c(d,e:nextValue())
if g then
f(g)
else
d:notify("Position","character is not loaded")
end
end
}
}end a.bn=function()local c=a.cache.bn if not c then c={c=b()}a.cache.bn=c end return c.c end end do local b=function()

return{
action="walktoposition|walktopos",
description="Makes you walk to a coordinate",
args={kind="vector3"},
run=function(b,c)
local d=c:nextValue()

local e=b.playerService:getHumanoid()
if e and e.SeatPart then
e.Sit=false
task.wait(0.1)
end

e=b.playerService:getHumanoid()
if e then
e.WalkToPoint=d
end
end
}end a.bo=function()local c=a.cache.bo if not c then c={c=b()}a.cache.bo=c end return c.c end end do local b=function()local b=function(

b)
local c=b:collectGarbage"spawnpoint"
if c then
c.connection:Disconnect()
end
return c~=nil end


return{
{
action="spawnpoint|spawn",
description="Sets a position where you will spawn",
args={
kind="number",
name="delay",
optional=true
},
run=function(c,d)
local e=c.playerService:getRootPart()
if not e then return end

local f=d:nextValue()or 0.1
b(c)

local g=c:createGarbage"spawnpoint"
g.cframe=e.CFrame
g.delay=f


g.connection=c:connect(c.localPlayer.CharacterAdded,function(h)
h:WaitForChild("HumanoidRootPart",10)
task.wait(g.delay)

c.playerService:setRootCFrame(g.cframe)
end)

c:notify("Spawn Point","Spawn point created")
end
},
{
action="nospawnpoint|nospawn",
description="Removes your custom spawn point",
run=function(c)
if b(c)then
c:notify("Spawn Point","Removed spawn point")
end
end
}
}end a.bp=function()local c=a.cache.bp if not c then c={c=b()}a.cache.bp=c end return c.c end end do local b=function()

local b=a.au()
local c=a.Q()

local d local e=function(

e)
local f=e:WaitForChild("Humanoid",10)
if not f then return end

b:Connect(f.Died,function()
local g=e:FindFirstChild"HumanoidRootPart"
if g then
d=g.CFrame
end
end)end


b:Connect(c.CharacterAdded,e)
if c.Character then
task.spawn(e,c.Character)
end

return{
action="flashback|diedtp",
description="Teleports you to where you last died",
run=function(f)
if not d then
f:notify("flashback","you have not died yet")
return
end

f.playerService:teleportTo(d)
end
}end a.bq=function()local c=a.cache.bq if not c then c={c=b()}a.cache.bq=c end return c.c end end do local b=function()local b=function(

b)
local c=b:collectGarbage"walltp"
if c then
c.connection:Disconnect()
end end


return{
{
action="walltp",
description="Teleports you above/over any wall you run into",
run=function(c)
b(c)

local d=c.playerService:getCharacter()
local e=d and(d:FindFirstChild"UpperTorso"or d:FindFirstChild"Torso")
if not e then return end

local f=c:createGarbage"walltp"
f.connection=c:connect(e.Touched,function(g)
local h=c.playerService:getRootPart()
local i=c.playerService:getHumanoid()
if not(h and i and g.Parent)then return end
if not g:IsA"BasePart"then return end
if g.Position.Y<=h.Position.Y-i.HipHeight then return end

local j=h.CFrame.LookVector
local k=g.Parent:FindFirstChild"HumanoidRootPart"
if k then
c.playerService:setRootCFrame(g.CFrame*CFrame.new(j.X,k.Size.Z/2+i.HipHeight,j.Z))
else
c.playerService:setRootCFrame(g.CFrame*CFrame.new(j.X,g.Size.Y/2+i.HipHeight,j.Z))
end
end)
end
},
{
action="nowalltp|unwalltp",
description="Disables walltp",
run=function(c)
b(c)
end
}
}end a.br=function()local c=a.cache.br if not c then c={c=b()}a.cache.br=c end return c.c end end do local b=function()

return{
action="teleporttool|tptool",
description="Gives you a teleport tool",
run=function(b)
local c=b.localPlayer:FindFirstChildOfClass"Backpack"
if not c then
b:notify("Teleport Tool","your backpack is not loaded")
return
end

local d=Instance.new"Tool"
d.Name="Teleport Tool"
d.RequiresHandle=false
d.Parent=c


b:connect(d.Activated,function()
local e=b.playerService:getRootPart()
local f=b.playerService:getMouse()
if not(e and f.Hit)then return end

local g=f.Hit.Position+Vector3.new(0,3,0)
b.playerService:teleportTo(CFrame.new(g)*(e.CFrame-e.CFrame.Position))
end)
end
}end a.bs=function()local c=a.cache.bs if not c then c={c=b()}a.cache.bs=c end return c.c end end do local b=function()local b=function(



b, c, d)
b.playerService:unseat()
task.wait(b.privateEnv.gotopartDelay or 0.1)

if d then
b.playerService:tweenTeleportTo{
target=c,
speed=b.privateEnv.tweenSpeed
}
else
b.playerService:setRootCFrame(c)
end end local c=function(



c)
return{
action=c.action,
description=c.description,
args={kind=c.kind,name=c.argName},
run=function(d,e)
local f=(e:nextValue()or""):lower()

for g,h in workspace:GetDescendants()do
if h:IsA(c.className)and h[c.field]:lower()==f then
b(d,c.cframeOf(h),c.tween)
end
end
end
}end local d=function(



d)
return{
action=d.action,
description=d.description,
args={kind=d.kind,name=d.argName},
run=function(e,f)
local g=(f:nextValue()or""):lower()
local h=e.playerService:getRootPart()
if not h then return end

for i,j in workspace:GetDescendants()do
if j:IsA(d.className)and j[d.field]:lower()==g then
j.CFrame=h.CFrame
end
end
end
}end local e=function(


e)
return e.CFrame end local f=function(


f)
return f:GetPivot()end


return{
c{
action="gotopart|topart",
description="Teleports you to every part with the given name",
kind="string",argName="part name",
className="BasePart",field="Name",cframeOf=e,tween=false
},
c{
action="tweengotopart|tgotopart|ttopart",
description="Tweens you to every part with the given name",
kind="string",argName="part name",
className="BasePart",field="Name",cframeOf=e,tween=true
},
c{
action="gotopartclass|gpc",
description="Teleports you to every part with the given class name",
kind="className",argName="class name",
className="BasePart",field="ClassName",cframeOf=e,tween=false
},
c{
action="tweengotopartclass|tgpc",
description="Tweens you to every part with the given class name",
kind="className",argName="class name",
className="BasePart",field="ClassName",cframeOf=e,tween=true
},
c{
action="gotomodel|tomodel",
description="Teleports you to every model with the given name",
kind="string",argName="model name",
className="Model",field="Name",cframeOf=f,tween=false
},
c{
action="tweengotomodel|tgotomodel|ttomodel",
description="Tweens you to every model with the given name",
kind="string",argName="model name",
className="Model",field="Name",cframeOf=f,tween=true
},
d{
action="bringpart",
description="Brings every part with the given name to you",
kind="string",argName="part name",
className="BasePart",field="Name"
},
d{
action="bringpartclass|bpc",
description="Brings every part with the given class name to you",
kind="className",argName="class name",
className="BasePart",field="ClassName"
},
{
action="gotopartdelay",
description="Sets the delay before the goto part commands teleport (default is 0.1)",
args={kind="number",name="delay",optional=true},
run=function(g,h)
g.privateEnv.gotopartDelay=h:nextValue()or 0.1
end
}
}end a.bt=function()local c=a.cache.bt if not c then c={c=b()}a.cache.bt=c end return c.c end end do local b=function()

return{
action="mouseteleport|mousetp",
description="Teleports you to the spot your mouse is pointing at",
run=function(b)
local c=b.playerService:getRootPart()
local d=b.playerService:getMouse()
if not(c and d.Hit)then return end


local e=d.Hit.Position+Vector3.new(0,3,0)
b.playerService:teleportTo(CFrame.new(e)*(c.CFrame-c.CFrame.Position))
end
}end a.bu=function()local c=a.cache.bu if not c then c={c=b()}a.cache.bu=c end return c.c end end do local b=function()local b=function(

b)
local c=b:collectGarbage"tpwalk"
if c then
c.connection:Disconnect()
end end local c=function(




c)
local d=c.privateEnv.wallwalkSetEnabled
if d then
return d
end

local e,f=pcall(function()
return c.fetchService.load("backups/wallwalker.luau","iy/wallwalker")()
end)

if not e then
c:notify("Wallwalk","failed to fetch script")
return
end

c.privateEnv.wallwalkSetEnabled=f
return f end


return{
{
action="tpwalk|teleportwalk",
description="Teleports you to your move direction",
args={
{
kind="number",
name="distance",
optional=true
},
{
kind="boolean",
name="stack distance",
optional=true
}
},
run=function(d,e)
b(d)

local f=e:nextValue()or 1
local g=e:nextValue()
if g then
d.privateEnv.tpwalkStack=(d.privateEnv.tpwalkStack or 0)+f
end

local h=d.playerService:getCharacter()
local i=d.playerService:getHumanoid()
if not(h and i)then return end

local j=d:createGarbage"tpwalk"
j.connection=d:connect(d.runService.Heartbeat,function(k)
if not(h.Parent and i.Parent)then
b(d)
return
end

local l=i.MoveDirection
if l.Magnitude>0 then
local m=f+(d.privateEnv.tpwalkStack or 0)
h:TranslateBy(l*m*k*10)
end
end)
end
},
{
action="untpwalk|unteleportwalk",
description="Undoes tpwalk / teleportwalk",
run=function(d)
d.privateEnv.tpwalkStack=0
b(d)
end
},
{
action="wallwalk|walkonwalls",
description="Walk on walls",
run=function(d)
local e=d:collectGarbage"wallwalk"
if e and e.active then
e.stop()
d:notify("Wallwalk","disabled")
return
end

local f=c(d)
if not f then return end

local g,h=pcall(f,true)
if not g then
d:notify("Wallwalk",`could not start: {tostring(h)}`)
return
end

local i=d:createGarbage"wallwalk"
i.active=true
i.stop=function()
i.active=false
pcall(f,false)
end

d:notify("Wallwalk","walk on any surface; run wallwalk again to turn it off")
end
},
{
action="unwallwalk|nowallwalk",
description="Turns off wallwalk",
run=function(d)
local e=d:collectGarbage"wallwalk"
local f=e~=nil and e.active==true

if e and e.stop then
e.stop()
end

d:notify("Wallwalk",if f then"disabled"else"it is not running")
end
}
}end a.bv=function()local c=a.cache.bv if not c then c={c=b()}a.cache.bv=c end return c.c end end do local b=function()



local b=a.S()
local c=a.P()

local d=c.PathfindingService

local e=5
local f=2
local g=0.2
local h=0.1
local i=3 local j=function(










j)
local k=j.playerService:getRootPart()
local l=j.playerService:getHumanoid()
if k and l then
l:MoveTo(k.Position)
end end local k=function(


k)
local l=k:collectGarbage"pathfind"
if not l then return false end

l.running=false
j(k)
return true end local l=function(


l, m)
local n=d:CreatePath()
local o=pcall(function()
n:ComputeAsync(l.Position,m)
end)

if not o or n.Status~=Enum.PathStatus.Success then
return{{position=m,jump=false}}
end

local p={}
for q,r in n:GetWaypoints()do
table.insert(p,{
position=r.Position,
jump=r.Action==Enum.PathWaypointAction.Jump,
})
end

if#p>1 and(p[1].position-l.Position).Magnitude<2 then
table.remove(p,1)
end

if#p==0 then
return{{position=m,jump=false}}
end

return p end local m=function(


m, n)
return m==nil or(n-m.goal).Magnitude>e end local n=function(


n, o, p, q)
local r=false
local s=n.MoveToFinished:Connect(function()
r=true
end)

if p.jump then
n.Jump=true
end

n:MoveTo(p.position)

local t=0
local u=false

while not r and t<i and n.Parent do
if q()then
u=true
break
end

local v=Vector3.new(
o.Position.X-p.position.X,
0,
o.Position.Z-p.position.Z
).Magnitude

local w=math.abs(o.Position.Y-p.position.Y)

if v<3 and w<4 then
break
end

task.wait(h)
t=t+h
end

s:Disconnect()
return not u end local o=function(


o, p, q)
k(o)

local r=o:createGarbage"pathfind"
r.running=true

task.spawn(function()
local s

while r.running do
local t=q()
if not t then break end

local u=o.playerService:getHumanoid()
local v=o.playerService:getRootPart()

if not(u and v)then
s=nil
task.wait(g)
continue
end

local w=s~=nil and s.index>#s.points
local x=p and s~=nil and not w and os.clock()-s.computedAt>f

if m(s,t)or x then
local y=l(v,t)
if not r.running then break end

s={
goal=t,
points=y,
index=1,
computedAt=os.clock(),
}
elseif w then
if not p then break end

task.wait(g)
else
local y=s
local z=n(u,v,y.points[y.index],function()
if not r.running then return true end

local z=q()
return z==nil or(p and m(y,z))
end)

if z then
y.index=y.index+1
end
end
end

if o:getGarbage"pathfind"==r then
o:collectGarbage"pathfind"
end
end)end


return{
{
action="pathfindwalkto|pathfindfollow",
description="Follow a player using pathfinding",
args={
kind="player"
},
run=function(p,q)
local r=b(q:nextValue())[1]
if not r then
p:notify("Pathfind","player not found")
return
end

o(p,true,function()
local s=r.Character and r.Character:FindFirstChild"HumanoidRootPart"
return s and s.Position
end)
end
},
{
action="pathfindwalktowaypoint|pathfindwalktowp|pftowp",
description="Walk to a waypoint using pathfinding",
args={
kind="waypoint"
},
run=function(p,q)
local r=q:nextValue()
local s=p.storage.waypoints:getValue(tostring(game.PlaceId))
local t=type(s)=="table"and r and s[r]

if not t then
p:notify("Pathfind",`there is no waypoint named '{r}'`)
return
end

local u=p:unstringify(t,"Vector3")
o(p,false,function()
return u
end)
end
},
{
action="unpathfind|nopathfind|pathfindstop",
description="Stops pathfindwalkto and pathfindwalktowaypoint",
run=function(p)
if k(p)then
p:notify("Pathfind","stopped")
else
p:notify("Pathfind","nothing is walking right now")
end
end
}
}end a.bw=function()local c=a.cache.bw if not c then c={c=b()}a.cache.bw=c end return c.c end end do local b=function()

return{a.be()
,a.bf()
,a.bg()
,a.bh()
,a.bi()
,a.bj()
,a.bk()
,a.bl()
,a.bm()
,a.bn()
,a.bo()
,a.bp()
,a.bq()
,a.br()
,a.bs()
,a.bt()
,a.bu()
,a.bv()
,a.bw()

}end a.bx=function()local c=a.cache.bx if not c then c={c=b()}a.cache.bx=c end return c.c end end do local b=function()

return a.ak().new"storage/installedPlugins"end a.by=function()local c=a.cache.by if not c then c={c=b()}a.cache.by=c end return c.c end end do local b=function()
return a.ak().new("storage/.userData",{
encrypt=true
})end a.bz=function()local c=a.cache.bz if not c then c={c=b()}a.cache.bz=c end return c.c end end do local b=function()
return a.ak().new"storage/aliases"end a.bA=function()local c=a.cache.bA if not c then c={c=b()}a.cache.bA=c end return c.c end end do local b=function()
return a.ak().new"storage/totalUsedCommands"end a.bB=function()local c=a.cache.bB if not c then c={c=b()}a.cache.bB=c end return c.c end end do local b=function()
return a.ak().new"storage/eventBinds"end a.bC=function()local c=a.cache.bC if not c then c={c=b()}a.cache.bC=c end return c.c end end do local b=function()

return{
waypoints=a.ba(),
plugins=a.by(),
settings=a.al(),
user=a.bz(),
aliases=a.bA(),
usedCmds=a.bB(),
eventBinds=a.bC()
}end a.bD=function()local c=a.cache.bD if not c then c={c=b()}a.cache.bD=c end return c.c end end do local b=function()




local b=a.P()

local c={}

c.isLegacy=function()
return b.TextChatService.ChatVersion==Enum.ChatVersion.LegacyChatService end



c.send=function(d)
d=tostring(d)

local e,f=pcall(function()
if c.isLegacy()then
b.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(d,"All")
else
b.TextChatService.TextChannels.RBXGeneral:SendAsync(d)
end
end)

return e,if e then nil else tostring(f)end


return c end a.bE=function()local c=a.cache.bE if not c then c={c=b()}a.cache.bE=c end return c.c end end do local b=function()






local b={
Color3.fromRGB(253,41,67),
Color3.fromRGB(1,162,255),
Color3.fromRGB(2,184,87),
Color3.fromRGB(107,50,124),
Color3.fromRGB(218,133,65),
Color3.fromRGB(245,205,48),
Color3.fromRGB(232,186,200),
Color3.fromRGB(215,197,154),
}

local c={
Color3.fromRGB(196,40,28),
Color3.fromRGB(13,105,172),
Color3.fromRGB(39,70,45),
Color3.fromRGB(107,50,124),
Color3.fromRGB(218,133,65),
Color3.fromRGB(245,205,48),
Color3.fromRGB(232,186,200),
Color3.fromRGB(215,197,154),
}

local d={}



d.value=function(e)
local f=0
local g=#e

for h=1,g do
local i=string.byte(e,h)
local j=g-h+1

if g%2==1 then
j=j-1
end

if j%4>=2 then
i=-i
end

f=f+i
end

return f end



d.forPlayer=function(e, f)
if e.Team then
return e.Team.TeamColor.Color
end

local g=if f then c else b
return g[d.value(e.Name)%#g+1]end


return d end a.bF=function()local c=a.cache.bF if not c then c={c=b()}a.cache.bF=c end return c.c end end do local b=function()






local b=a.P()
local c=a.a()
local d=a.aj()
local e=a.bD()
local f=a.d()
local g=a.au()
local h=a.bE()
local i=a.bF()

local j=500
local k="https://files.catbox.moe/i968v2.jpg"
local l="logsWebhook"

local m={
chatEnabled=false,
joinEnabled=false,
started=false,
entries={chat={},join={}},
listeners={},
}

local n={}local o=function(

o, p)
p.time=os.date"%H:%M:%S"

local q=m.entries[o]
table.insert(q,p)
if#q>j then
table.remove(q,1)
end

for r,s in m.listeners do
task.spawn(s,o,p)
end end


m.getWebhook=function()
local p=e.settings:getValue(l)
if type(p)=="string"and p~=""then
return p
end
return nil end


m.setWebhook=function(p)
e.settings:setValue(l,p)
e.settings:save()end local p=function(



p)
local q=p.UserId
if n[q]then
return n[q]
end

local r=k
local s=c.httprequest

if s then
local t,u=pcall(function()
local t=s{
Url=`https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds={q}&size=420x420&format=Png&isCircular=false`,
Method="GET",
}
return b.HttpService:JSONDecode(t.Body).data
end)

local v=t and type(u)=="table"and u[1]
if type(v)=="table"and v.state=="Completed"and v.imageUrl then
r=v.imageUrl
end
end

n[q]=r
return r end local q=function(


q, r)
local s=m.getWebhook()
local t=c.httprequest
if not(s and t)then
return
end


task.spawn(function()
local u=b.HttpService:JSONEncode{
content=r,
avatar_url=p(q),
username=q.Name,
allowed_mentions={parse={}},
}

local v,w=pcall(t,{
Url=s,
Method="POST",
Headers={["Content-Type"]="application/json"},
Body=u,
})

if not v then
f:warn(`chat logs webhook failed: {w}`)
end
end)end local r=function(


r, s)
if not m.chatEnabled then
return
end

o("chat",{
name=r.Name,
message=s,
color=i.forPlayer(r,h.isLegacy()),
})
q(r,s)end



m.start=function()
if m.started then
return
end
m.started=true

local s=b.Players local t=function(

t)
if h.isLegacy()then
g:Connect(t.Chatted,function(u)
r(t,u)
end)
end end


for u,v in s:GetPlayers()do
t(v)
end

g:Connect(s.PlayerAdded,function(u)
if m.joinEnabled then
o("join",{
name=u.Name,
userId=u.UserId,
color=i.forPlayer(u,h.isLegacy()),
})
end
t(u)
end)

if not h.isLegacy()then
g:Connect(b.TextChatService.MessageReceived,function(u)
local v=u.TextSource
if not v or u.Status==Enum.TextChatMessageStatus.InvalidTextChannelPermissions then
return
end

local w=s:GetPlayerByUserId(v.UserId)
if not w then
return
end

local x=u.Text
if u.WasRewritten then
x=`(rephrased) {u.RewrittenText}`
end

r(w,x)
end)
end end


m.setChat=function(s)
m.chatEnabled=s
if s then
m.start()
end end


m.setJoin=function(s)
m.joinEnabled=s
if s then
m.start()
end end



m.onEntry=function(s)
table.insert(m.listeners,s)end


m.clear=function(s)
table.clear(m.entries[s])end



m.save=function(s)
local t=c.writefile
if not t then
return false,"your exploit does not support writing files"
end

local u={}
for v,w in m.entries[s]do
if s=="chat"then
table.insert(u,`[{w.time}] {w.name}: {w.message}`)
else
table.insert(u,`[{w.time}] {w.name} ({w.userId}) joined`)
end
end


if#u==0 then
return false,"nothing to save yet"
end

local v=d.privateFolder
if c.makefolder then
pcall(c.makefolder,v)
end

local w=`{v}/logs/{s}/{os.time()}.txt`
local x,y=pcall(t,w,table.concat(u,"\n"))
if x then
return true,w
end
return false,tostring(y)end


return m end a.bG=function()local c=a.cache.bG if not c then c={c=b()}a.cache.bG=c end return c.c end end do local b=function()

local b=a.bG()

return{
{
action="logs",
description="Opens the chat logs window with chat and join logs turned on",
run=function(c)
b.setChat(true)
b.setJoin(true)
c.infiniteYield:chatLogs"chat"
end
},
{
action="chatlogs|clogs",
description="Turns on chat logs and opens the chat tab",
run=function(c)
b.setChat(true)
c.infiniteYield:chatLogs"chat"
end
},
{
action="joinlogs|jlogs",
description="Turns on join logs and opens the joins tab",
run=function(c)
b.setJoin(true)
c.infiniteYield:chatLogs"join"
end
},
{
action="chatlogswebhook|logswebhook",
description="Set a discord webhook for chatlogs to go to (provide no url to disable this)",
args={
kind="string",
name="url",
optional=true
},
run=function(c,d)
local e=d:nextValue()

if not e then
b.setWebhook(nil)
c:notify("Logs Webhook","webhook disabled")
return
end

if not c.executorEnv.httprequest then
c:notify("Incompatible Exploit","Your exploit does not support this command (missing request)")
return
end

b.setWebhook(e)
c:notify("Logs Webhook","chat logs will be sent to the webhook")
end
}
}end a.bH=function()local c=a.cache.bH if not c then c={c=b()}a.cache.bH=c end return c.c end end do local b=function()

local b=a.bE()
local c=a.S()

local d="spam"
local e="pmspam:"local f=function(


f, g, h)
local i,j=b.send(h)
if not i then
f:notify(g,j)
end
return i end local g=function(


g)
local h=g:collectGarbage(d)
if h then
h.running=false
end end local h=function(



h, i)
g(h)

local j=h:createGarbage(d)
j.running=true

task.spawn(function()
while j.running do
if not f(h,"Spam",i)then
j.running=false
break
end
task.wait(h.privateEnv.spamSpeed or 1)
end

if h:getGarbage(d)==j then
h:collectGarbage(d)
end
end)end local i=function(


i)
return e..i.Name end local j=function(


j, k)
local l=j:collectGarbage(k)
if l then
l.running=false
end end local k=function(



k, l, m)
local n=i(l)
j(k,n)

local o=k:createGarbage(n)
o.running=true

task.spawn(function()
while o.running and l.Parent==k.players do
if not f(k,"PM Spam",`/w {l.Name} {m}`)then
o.running=false
break
end
task.wait(k.privateEnv.spamSpeed or 1)
end

if k:getGarbage(n)==o then
k:collectGarbage(n)
end
end)end local l=function(


l)
local m={}
for n in pairs(l.garbages)do
if n:sub(1,#e)==e then
table.insert(m,n)
end
end
return m end local m=function(




m, n)
local o={}
for p,q in c(n)do
table.insert(o,i(q))
end

if not c.isSelector(n)then
local p=n:lower()
for q,r in l(m)do
local s=r:sub(#e+1):lower()
if s:sub(1,#p)==p then
table.insert(o,r)
end
end
end

return o end


return{
{
action="chat|say",
description="Makes you chat a string (possible mute bypass)",
args={
kind="string",
name="your message"
},
run=function(n,o)
local p=o:nextValue()
if not p then return end
f(n,"Chat",p)
end
},
{
action="spam",
description="Makes you spam the chat",
args={
kind="string",
name="your message"
},
run=function(n,o)
local p=o:nextValue()
if not p then return end
h(n,p)
end
},
{
action="unspam|nospam",
description="Turns off spam",
run=function(n)
g(n)
end
},
{
action="whisper|pm",
description="Makes you whisper a string to someone (possible mute bypass)",
args={
{kind="player"},
{kind="string",name="your message"}
},
run=function(n,o)
local p=c(o:nextValue())
local q=o:nextValue()
if not q then return end

for r,s in p do
if s~=n.localPlayer then
f(n,"Whisper",`/w {s.Name} {q}`)
end
end
end
},
{
action="pmspam",
description="Makes you spam a players whispers",
args={
{kind="player"},
{kind="string",name="your message"}
},
run=function(n,o)
local p=c(o:nextValue())
local q=o:nextValue()
if not q then return end

for r,s in p do
if s~=n.localPlayer then
k(n,s,q)
end
end
end
},
{
action="unpmspam|nopmspam",
description="Turns off pm spam (no player: turns it off for everyone)",
args={kind="player",optional=true},
run=function(n,o)
local p=o:nextValue()
local q=if p then m(n,p)else l(n)

for r,s in q do
j(n,s)
end
end
},
{
action="spamspeed|spamdelay",
description="How quickly you spam (default is 1)",
args={kind="number",name="delay",optional=true},
run=function(n,o)
n.privateEnv.spamSpeed=math.max(o:nextValue()or 1,0)
end
}
}end a.bI=function()local c=a.cache.bI if not c then c={c=b()}a.cache.bI=c end return c.c end end do local b=function()

local b=a.P()
local c=a.bE()local d=function(


d)
if c.isLegacy()then
b.Chat.BubbleChatEnabled=d
else
b.TextChatService.BubbleChatConfiguration.Enabled=d
end end


return{
{
action="bubblechat",
description="Enables bubble chat for your client (CLIENT)",
client=true,
run=function()
d(true)
end
},
{
action="unbubblechat|nobubblechat",
description="Disables bubble chat for your client (CLIENT)",
client=true,
run=function()
d(false)
end
}
}end a.bJ=function()local c=a.cache.bJ if not c then c={c=b()}a.cache.bJ=c end return c.c end end do local b=function()

local b=a.P()
local c=a.bE()local d=function(

d)
if c.isLegacy()then
b.StarterGui:SetCore("ChatActive",d)
else
b.TextChatService.ChatWindowConfiguration.Enabled=d
end end local e=function()




local e=b.TextChatService

local f={
{e:FindFirstChildOfClass"BubbleChatConfiguration",{
Enabled=true,
BackgroundColor3=Color3.fromRGB(),
BackgroundTransparency=0.3,
TailVisible=true,
}},
{e:FindFirstChildOfClass"ChatWindowConfiguration",{
Enabled=true,
BackgroundColor3=Color3.fromRGB(),
BackgroundTransparency=0.3,
TextColor3=Color3.fromRGB(0xFF,0xFF,0xFF),
TextStrokeColor3=Color3.fromRGB(),
TextStrokeTransparency=0.5,
}},
{e:FindFirstChildOfClass"ChatInputBarConfiguration",{
Enabled=true,
BackgroundColor3=Color3.fromRGB(),
BackgroundTransparency=0.5,
PlaceholderColor3=Color3.fromRGB(0xFF,0xFF,0xFF),
TextColor3=Color3.fromRGB(0xFF,0xFF,0xFF),
TextStrokeColor3=Color3.fromRGB(),
TextStrokeTransparency=0.5,
}},
}

for g,h in f do
local i,j=h[1],h[2]
if i then
for k,l in j do
i[k]=l
end
end
end end


return{
{
action="chatwindow",
description="Enables the chat window for your client",
client=true,
run=function()
d(true)
end
},
{
action="unchatwindow|nochatwindow",
description="Disables the chat window for your client",
client=true,
run=function()
d(false)
end
},
{
action="darkchat",
description="Makes the chat window dark for your client",
client=true,
run=function(f)
if c.isLegacy()then
f:notify("Dark Chat","darkchat only works with the TextChatService chat")
return
end
e()
end
}
}end a.bK=function()local c=a.cache.bK if not c then c={c=b()}a.cache.bK=c end return c.c end end do local b=function()

local b=a.P()
local c=a.S()local d=function()



local d,e=pcall(function()
return b.VoiceChatInternal
end)
if d then
return e
end
return nil end local e=function(



e, f)
local g=d()
if not g then
e:notify("Voice Chat","this game has no voice chat service")
return
end

local h,i=pcall(f,g)
if not h then
e:notify("Voice Chat",tostring(i))
end end local f=function(



f)
local g=f:collectGarbage"listento"
if not g then
return false
end

if g.connection then
g.connection:Disconnect()
end
b.SoundService:SetListener(Enum.ListenerType.Camera)
return true end local g=function(



g, h)
local i=g:createGarbage"listento"local j=function(

j)
local k=j:WaitForChild("HumanoidRootPart",10)
if k and g:getGarbage"listento"==i then
b.SoundService:SetListener(Enum.ListenerType.ObjectPosition,k)
end end


i.connection=g:connect(h.CharacterAdded,function(k)
task.spawn(j,k)
end)

if h.Character then
task.spawn(j,h.Character)
end end


return{
{
action="listento",
description="Listens to the area around a player. Can also eavesdrop with vc",
args={kind="player",optional=true},
run=function(h,i)
local j=i:nextValue()

f(h)
if not j then return end

local k=c(j)[1]
if k then
g(h,k)
end
end
},
{
action="unlistento",
description="Disables listento",
run=function(h)
f(h)
end
},
{
action="muteallvoices|muteallvcs",
description="Mutes voice chat for all players",
run=function(h)
e(h,function(i)
i:SubscribePauseAll(true)
end)
end
},
{
action="unmuteallvoices|unmuteallvcs",
description="Unmutes voice chat for all players",
run=function(h)
e(h,function(i)
i:SubscribePauseAll(false)
end)
end
},
{
action="mutevc",
description="Mutes the voice chat of a player",
args={kind="player"},
run=function(h,i)
local j=c(i:nextValue())
e(h,function(k)
for l,m in j do
if m~=h.localPlayer then
k:SubscribePause(m.UserId,true)
end
end
end)
end
},
{
action="unmutevc",
description="Unmutes the voice chat of a player",
args={kind="player"},
run=function(h,i)
local j=c(i:nextValue())
e(h,function(k)
for l,m in j do
if m~=h.localPlayer then
k:SubscribePause(m.UserId,false)
end
end
end)
end
},
{
action="phonebook|call",
description="Prompts the Roblox phonebook UI to let you call your friends. Needs voice chat enabled",
run=function(h)
local i,j=pcall(function()
return b.SocialService:CanSendCallInviteAsync(h.localPlayer)
end)

if i and j then
b.SocialService:PromptPhoneBook(h.localPlayer,"")
else
h:notify("Phonebook","It seems you're not able to call anyone. Sorry!")
end
end
}
}end a.bL=function()local c=a.cache.bL if not c then c={c=b()}a.cache.bL=c end return c.c end end do local b=function()

return{
{
action="loopoof",
description="Makes every player's head play its sounds (oof) over and over",
run=function(b)
if b:hasGarbage"oof"then
b:notify"oof loop is already enabled"
return
end

local c=b:createGarbage"oof"
c.running=true

task.spawn(function()
while c.running do
for d,e in b.robloxServices.Players:GetPlayers()do
local f=e.Character and e.Character:FindFirstChild"Head"
if f then
for g,h in f:GetChildren()do
if h:IsA"Sound"then
h.Playing=true
end
end
end
end
task.wait(0.1)
end
end)
end
},
{
action="unloopoof",
description="Stops the oof loop",
run=function(b)
local c=b:collectGarbage"oof"
if c then
c.running=false
end
end
}
}end a.bM=function()local c=a.cache.bM if not c then c={c=b()}a.cache.bM=c end return c.c end end do local b=function()

local b=a.S()

return{
{
action="muteboombox",
description="Mutes someones boombox",
args={
kind="player"
},
run=function(c,d)
for e,f in b(d:nextValue())do
task.spawn(function()
local g={f.Character,f:FindFirstChildOfClass"Backpack"}
for h,i in g do
for j,k in i:GetDescendants()do
if k:IsA"Sound"then
k.Playing=false
end
end
end
end)
end
end
},
{
action="unmuteboombox",
description="Unmutes someones boombox",
args={
kind="player"
},
run=function(c,d)
for e,f in b(d:nextValue())do
task.spawn(function()
local g=f.Character
if not g then return end

for h,i in g:GetDescendants()do
if i:IsA"Sound"and not i.Playing then
i.Playing=true
end
end
end)
end
end
}
}end a.bN=function()local c=a.cache.bN if not c then c={c=b()}a.cache.bN=c end return c.c end end do local b=function()

return{a.bH()
,a.bI()
,a.bJ()
,a.bK()
,a.bL()
,a.bM()
,a.bN()

}end a.bO=function()local c=a.cache.bO if not c then c={c=b()}a.cache.bO=c end return c.c end end do local b=function()









local b=a.P()
local c=a.R()
local d=a.b()
local e=a.d()

local f=0.3
local g=0.25
local h=Color3.fromRGB(255,255,255)
local i="iy-esp"local j=function()


local j=b.CoreGui
local k=j:FindFirstChild(i)

if not k then
k=Instance.new"Folder"
k.Name=i
k.Parent=j
end

return k end local k=function(



k)
if k:IsA"BasePart"then
return k
end

if k:IsA"Model"then
return k:FindFirstChild"Head"
or k.PrimaryPart
or k:FindFirstChildWhichIsA"BasePart"
end

return nil end local l=function(



l, m)
local n=l:IsA"Model"and l:FindFirstChildOfClass"Humanoid"

if n then
return("%s <font color='rgb(160, 160, 160)'>[ %dm ]</font>\n<font color='rgb(25, 240, 25)'>[%d/%d]</font>"):format(
l.Name,
m,
math.floor(n.Health),
math.floor(n.MaxHealth)
)
end

return("%s < %dm >"):format(l.Name,m)end


local m={}
m.__index=m








m.new=function(n)
local o=Instance.new"Folder"
o.Name=n.tag
o.Parent=j()

return setmetatable({
tag=n.tag,
source=n.source,
color=n.color,
text=n.text or l,
showBoxes=n.showBoxes==true,
showText=n.showText==true,
interval=n.interval or g,
objects={},
folder=o,
running=false,
},m)end


m.create=function(n, o)
local p=k(o)
if not p then
return nil
end

local q={instance=o,adornee=p,boxes={}}

if n.showBoxes then
local r=o:IsA"Model"and o:GetChildren()or{o}

for s,t in r do
if t:IsA"BasePart"then
local u=Instance.new"BoxHandleAdornment"
u.Adornee=t
u.Size=t.Size
u.AlwaysOnTop=true
u.ZIndex=0
u.Parent=n.folder
table.insert(q.boxes,u)
end
end
end

if n.showText then
local r=Instance.new"BillboardGui"
r.Adornee=p
r.Size=UDim2.new(0,200,0,50)
r.StudsOffset=Vector3.new(0,2,0)
r.AlwaysOnTop=true
r.Parent=n.folder

local s=Instance.new"TextLabel"
s.BackgroundTransparency=1
s.Size=UDim2.new(1,0,1,0)
s.TextSize=14
s.TextStrokeTransparency=0
s.TextYAlignment=Enum.TextYAlignment.Bottom
s.RichText=true
s.Text=""
s.Parent=r

q.billboard=r
q.label=s
end

n.objects[o]=q
return q end


m.update=function(n, o, p)
local q=h
if n.color then
q=n.color(o.instance)
end

local r=d.espTransparency or f

for s,t in o.boxes do
t.Color3=q
t.Transparency=r
end

if o.label then
local s=0
if p then
s=(p.Position-o.adornee.Position).Magnitude
end

o.label.TextColor3=q
o.label.Text=n.text(o.instance,math.floor(s/5),math.floor(s))
end end


m.removeEsp=function(n, o, p)
for q,r in p.boxes do
r:Destroy()
end

if p.billboard then
p.billboard:Destroy()
end

n.objects[o]=nil end


m.refresh=function(n)
local o=c:getRootPart()
local p={}

for q,r in n.source()do
if not p[r]then
p[r]=true

local s=n.objects[r]


if s and not s.adornee:IsDescendantOf(workspace)then
n:removeEsp(r,s)
s=nil
end

s=s or n:create(r)

if s then
n:update(s,o)
end
end
end

for q,r in pairs(n.objects)do
if not p[q]or not q:IsDescendantOf(workspace)then
n:removeEsp(q,r)
end
end end


m.start=function(n)
if n.running then
return
end

n.running=true

task.spawn(function()
while n.running do
local o,p=pcall(n.refresh,n)

if not o then
n.running=false
e:warn(("esp [%s] stopped: %s"):format(n.tag,tostring(p)))
break
end

task.wait(n.interval)
end
end)end


m.destroy=function(n)
n.running=false

for o,p in pairs(n.objects)do
n:removeEsp(o,p)
end

n.folder:Destroy()end


return m end a.bP=function()local c=a.cache.bP if not c then c={c=b()}a.cache.bP=c end return c.c end end do local b=function()






local b=a.bP()
local c=a.S()
local d=a.P()
local e=a.b()

local f=d.Players

local g=0.3
local h=Color3.fromRGB(0,255,0)
local i=Color3.fromRGB(255,0,0)
local j=Color3.fromRGB(255,255,255)
local k=Color3.fromRGB(50,205,50)local l=function()



local l={}
local m=f.LocalPlayer

for n,o in f:GetPlayers()do
if o~=m and o.Character then
table.insert(l,o.Character)
end
end

return l end local m=function(


m)
local n=f:GetPlayerFromCharacter(m)
if n then
return n.TeamColor.Color
end
return j end local n=function(


n)
local o=f:GetPlayerFromCharacter(n)
if o and o.TeamColor==f.LocalPlayer.TeamColor then
return h
end
return i end local o=function(


o)
return function()
return o
end end local p=function(



p)
return function()
local q={}

for r,s in workspace:GetDescendants()do
if s:IsA"BasePart"and p[s.Name:lower()]then
table.insert(q,s)
end
end

return q
end end local q=function(



q, r, s)
local t=f:GetPlayerFromCharacter(q)
local u=q:FindFirstChildOfClass"Humanoid"

local v=0
if u then
v=math.floor(u.Health*10+0.5)/10
end

return("Name: %s | Health: %g | Studs: %d"):format(
t and t.Name or q.Name,
v,
s
)end local r=function(


r, s)
local t=r:collectGarbage(s)

if t and t.manager then
t.manager:destroy()
end end local s=function(


s, t, u)
r(s,t)

u.tag=t
local v=b.new(u)

local w=s:createGarbage(t)
w.manager=v
v:start()end local t=function(


t, u)
if t:hasGarbage"chams"then
t:notify("ESP","Disable chams (nochams) before using esp")
return
end

s(t,"esp",{
source=l,
color=u,

showBoxes=true,
showText=true,
})end



local u="locate:"local v=function(

v)
return u..v.Name end local w=function(



w, x)
s(w,v(x),{
source=function()
local y=x.Character
if y then
return{y}
end
return{}
end,
color=m,

showBoxes=true,
showText=true,
})end


return{
{
action="esp",
description="View all players and their status",
run=function(x)
t(x,m)
end
},
{
action="espteam",
description="ESP but teammates are green and bad guys are red",
run=function(x)
t(x,n)
end
},
{
action="noesp|unesp|unespteam",
description="Removes ESP",
run=function(x)
r(x,"esp")
end
},
{
action="esptransparency",
description="Changes the transparency of ESP related commands",
args={kind="number"},
run=function(x,y)
local z=y:nextValue()
e.espTransparency=math.clamp(z or g,0,1)
end
},
{
action="partesp",
description="Highlights a part",
args={
kind="string",
name="part name"
},
run=function(x,y)
local z=y:nextValue()
if not z then
x:notify("partesp","Write the name of a part")
return
end

local A=e.partEspNames or{}
e.partEspNames=A
A[z:lower()]=true

if not x:hasGarbage"partesp"then
s(x,"partesp",{
source=p(A),
color=o(k),
showBoxes=true,
showText=false,
interval=1,
})
end
end
},
{
action="unpartesp|nopartesp",
description="removes partesp",
args={
kind="string",
name="part name"
},
run=function(x,y)
local z=e.partEspNames or{}
e.partEspNames=z

local A=y:nextValue()
if A then
z[A:lower()]=nil
else
table.clear(z)
end

if next(z)==nil then
r(x,"partesp")
end
end
},
{
action="chams",
description="ESP but without text in the way",
run=function(x)
if x:hasGarbage"esp"then
x:notify("Chams","Disable ESP (noesp) before using chams")
return
end

s(x,"chams",{
source=l,
color=m,
showBoxes=true,
showText=false,
})
end
},
{
action="nochams|unchams",
description="Removes chams",
run=function(x)
r(x,"chams")
end
},
{
action="locate",
description="View a single player and their status",
args={kind="player"},
run=function(x,y)
local z=y:nextValue()
if not z then
return
end

for A,B in c(z)do
if B~=f.LocalPlayer then
w(x,B)
end
end
end
},
{
action="unlocate|nolocate",
description="Removes locate",
args={kind="player"},
run=function(x,y)
local z=y:nextValue()

if not z then

local A={}
for B in pairs(x.garbages)do
if B:sub(1,#u)==u then
table.insert(A,B)
end
end

for B,C in A do
r(x,C)
end
return
end


local A={}
for B,C in c(z)do
table.insert(A,v(C))
end


if not c.isSelector(z)then
local B=z:lower()
for C in pairs(x.garbages)do
if C:sub(1,#u)==u then
local D=C:sub(#u+1):lower()
if D:sub(1,#B)==B then
table.insert(A,C)
end
end
end
end

for B,C in A do
r(x,C)
end
end
}
}end a.bQ=function()local c=a.cache.bQ if not c then c={c=b()}a.cache.bQ=c end return c.c end end do local b=function()local b=function(


b)
local c=b.privateEnv.xrayEnabled==true

for d,e in workspace:GetDescendants()do
if e:IsA"BasePart"then
local f=e.Parent
local g=f and f.Parent
local h=(f and f:FindFirstChildWhichIsA"Humanoid")
or(g and g:FindFirstChildWhichIsA"Humanoid")

if not h then
e.LocalTransparencyModifier=c and 0.5 or 0
end
end
end end local c=function(


c)
local d=c:collectGarbage"loopxray"
if d then
d.connection:Disconnect()
end end


return{
{
action="xray",
description="Makes all parts in workspace transparent",
run=function(d)
d.privateEnv.xrayEnabled=true
b(d)
end
},
{
action="unxray|noxray",
description="Restores transparency to all parts in workspace",
run=function(d)
d.privateEnv.xrayEnabled=false
b(d)
end
},
{
action="loopxray",
description="Makes all parts in workspace transparent but looped",
run=function(d)
c(d)

local e=d:createGarbage"loopxray"
e.connection=d:connect(d.runService.RenderStepped,function()
d.privateEnv.xrayEnabled=true
b(d)
end)
end
},
{
action="unloopxray",
description="Unloops xray",
run=function(d)
c(d)
d.privateEnv.xrayEnabled=false
b(d)
end
},
{
action="togglexray",
description="Toggles xray",
run=function(d)
d.privateEnv.xrayEnabled=not d.privateEnv.xrayEnabled
b(d)
end
}
}end a.bR=function()local c=a.cache.bR if not c then c={c=b()}a.cache.bR=c end return c.c end end do local b=function()local b=function(



b, c)
if not c then return nil end

local d=c:FindFirstAncestorOfClass"Model"
if not d then return nil end

return b.players:GetPlayerFromCharacter(d)end local c=function(


c)
local d=c:collectGarbage"hovername"
if not d then return false end

if d.connection then
d.connection:Disconnect()
end
if d.gui then
d.gui:Destroy()
end
return true end local d=function(


d)
local e=Instance.new"ScreenGui"
e.Name="HovernameGui"
e.ResetOnSpawn=false

local f=d.executorEnv.gethui and d.executorEnv.gethui()
e.Parent=f or d.coreGui

local g=Instance.new"TextLabel"
g.Name="Name"
g.BackgroundTransparency=1
g.Size=UDim2.fromOffset(200,20)
g.Font=Enum.Font.SourceSansBold
g.TextSize=16
g.TextColor3=Color3.new(1,1,1)
g.TextStrokeTransparency=0
g.TextXAlignment=Enum.TextXAlignment.Left
g.Visible=false
g.Parent=e

return e,g end


return{
{
action="hovername",
description="Shows a players username when your mouse is hovered over them",
run=function(e)
c(e)

local f=e.playerService:getMouse()
local g,h=d(e)

local i=e:createGarbage"hovername"
i.gui=g
i.connection=e:connect(e.runService.RenderStepped,function()
local j=b(e,f.Target)

if j then
h.Text=j.Name
h.Position=UDim2.fromOffset(f.X+18,f.Y+12)
h.Visible=true
else
h.Visible=false
end
end)
end
},
{
action="unhovername|nohovername",
description="Turns off hovername",
run=function(e)
c(e)
end
}
}end a.bS=function()local c=a.cache.bS if not c then c={c=b()}a.cache.bS=c end return c.c end end do local b=function()local b=function(


b, c)
local d=pcall(function()
settings():GetService"RenderSettings".ShowBoundingBoxes=c
end)

if not d then
b:notify("Hitboxes","this executor cannot change the hitbox display")
end end


return{
{
client=true,
action="hitboxes|showhitboxes",
description="Shows player hitboxes (CLIENT)",
run=function(c)
b(c,true)
end
},
{
client=true,
action="unhitboxes|nohitboxes|unshowhitboxes",
description="Hides player hitboxes (CLIENT)",
run=function(c)
b(c,false)
end
}
}end a.bT=function()local c=a.cache.bT if not c then c={c=b()}a.cache.bT=c end return c.c end end do local b=function()

return{a.bQ()
,a.bR()
,a.bS()
,a.bT()

}end a.bU=function()local c=a.cache.bU if not c then c={c=b()}a.cache.bU=c end return c.c end end do local b=function()

return{}end a.bV=function()local c=a.cache.bV if not c then c={c=b()}a.cache.bV=c end return c.c end end do local b=function()
local b=a.bV()
local c=a.d()

local d={}

d.setProperties=function(e, f)
for g,h in f do
if b[g]then
b[g](e,h)
continue
end


if type(g)=="number"and typeof(h)=="Instance"then
h.Parent=e
continue
end

e[g]=h
end
return e end


d.setup=function(e, ...)
for f,g in{...}do
local h=typeof(g)

if h=="table"then
d.setProperties(e,g)
else
local i=if h=="string"then"Name"else"Parent"
e[i]=g
end
end
return e end


d.new=function(e, ...)
local f=Instance.new(e)
return d.setup(f,...)end


return d end a.bW=function()local c=a.cache.bW if not c then c={c=b()}a.cache.bW=c end return c.c end end do local b=function()


local b=a.P()
local c=b.UserInputService

local d=false

xpcall(
function()
d=table.find({
Enum.Platform.Android,
Enum.Platform.IOS
},c:GetPlatform())~=nil
end,
function()
d=(
c.TouchEnabled and
not c.KeyboardEnabled
)
end
)

return d end a.bX=function()local c=a.cache.bX if not c then c={c=b()}a.cache.bX=c end return c.c end end do local b=function()
local b=a.P()
local c=a.a()local d=function()


local d=b.CoreGui
local e=c.gethui

if typeof(e)=="function"then
local f,g=pcall(e)

if f and typeof(g)=="Instance"then
d=g
end
end

if d==b.CoreGui then
local f=d:FindFirstChild"RobloxGui"
d=if f~=nil then f else d
end

return d end


return d()end a.bY=function()local c=a.cache.bY if not c then c={c=b()}a.cache.bY=c end return c.c end end do local aa=function()













local b=a.P()
local c=a.bW()
local d=a.R()
local e=a.Q()

local f=a.bX()
local g=a.bY()

local h=b.ContextActionService
local i=b.UserInputService

local j={}

j.DEFAULT_SPEED=1
j.DEFAULT_BOOST=2
j.MIN_BOOST=1
j.MAX_BOOST=50

local k="freecam.boost"

local l="freecam"
local m="freecamKeys"
local n="freecamMouse"
local o=Enum.ContextActionPriority.High.Value
local p="freecamControls"

local q={
Enum.KeyCode.W,
Enum.KeyCode.A,
Enum.KeyCode.S,
Enum.KeyCode.D,
Enum.KeyCode.E,
Enum.KeyCode.Q,
Enum.KeyCode.Up,
Enum.KeyCode.Down,
}

local r=70
local s=64
local t=5
local u=math.pi/64


local v=math.rad(89)
local w=0.75
local x=0.01
local y=4
local z=0.25
local A=0.1
local B=512

local C=1
local D=64
local E=24
local F=40 local G=function()


return Enum.ContextActionResult.Sink end local H=function(



H)
return{
position=H,
velocity=H*0,
}end local I=function(


I, J, K)
local L=t*2*math.pi
local M=K-I.position
local N=math.exp(-L*J)

local O=K+(I.velocity*J-M*(L*J+1))*N
local P=(L*J*(M*L-I.velocity)+I.velocity)*N

I.position=O
I.velocity=P

return O end local J=function(



J, K)
local L=i:IsKeyDown(J)and 1 or 0
local M=i:IsKeyDown(K)and 1 or 0
return L-M end local K=function(



K, L, M)
local N=K.ViewportSize
local O=2*math.tan(math.rad(M)/2)
local P=N.X/N.Y*O

local Q=B
local R=L.LookVector

for S=0,1,0.5 do
for T=0,1,0.5 do
local U=L.RightVector*((S-0.5)*P)
-L.UpVector*((T-0.5)*O)
+L.LookVector

local V=U.Unit
local W=L.Position+U*A
local X=workspace:Raycast(W,V*B)
local Y=X and(X.Position-W).Magnitude or B

if Y<Q then
Q=Y
R=V
end
end
end

return L.LookVector:Dot(R)*Q end local L=function(






L, M)
if not L then return Vector3.zero end

local N=Vector3.new(-math.sin(M),0,-math.cos(M))
local O=Vector3.new(math.cos(M),0,-math.sin(M))
local P=L.MoveDirection
return Vector3.new(P:Dot(O),0,-P:Dot(N))end local M=function(


M)
return M.UserInputType==Enum.UserInputType.Touch end local N=function(



N, O)
for P,Q in N.controls do
local R=Q.AbsolutePosition
local S=Q.AbsoluteSize
if O.X>=R.X and O.X<=R.X+S.X
and O.Y>=R.Y and O.Y<=R.Y+S.Y then
return true
end
end
return false end local O=function(



O, P)
local Q=c.new("ScreenGui",g,{
Name=p,
ResetOnSpawn=false,
DisplayOrder=50,
})
P.gui=Q local R=function(


R, S, T)
local U=c.new("TextButton",Q,{
Name=R,
AnchorPoint=Vector2.new(1,1),
Position=T,
Size=UDim2.fromOffset(D,D),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.5,
AutoButtonColor=false,
Text=S,
TextColor3=Color3.new(1,1,1),
TextScaled=true,
Active=true,
})

table.insert(P.controls,U)
table.insert(P.connections,O:connect(U.InputBegan,function(V)
if M(V)then
P.holds[R]=V
end
end))end


R("rise","UP",UDim2.new(1,-E,1,-F-D-12))
R("fall","DOWN",UDim2.new(1,-E,1,-F))
R("boost","BOOST",UDim2.new(1,-E-D-12,1,-F))

local S=c.new("TextButton",Q,{
Name="Close",
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,-E,0,E),
Size=UDim2.fromOffset(D,D),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.5,
AutoButtonColor=false,
Text="X",
TextColor3=Color3.new(1,1,1),
TextScaled=true,
Active=true,
})

table.insert(P.controls,S)
table.insert(P.connections,O:connect(S.Activated,function()
j.stop(O)
end))


local T=c.new("TextButton",Q,{
Name="Teleport",
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,-E-D-12,0,E),
Size=UDim2.fromOffset(D,D),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.5,
AutoButtonColor=false,
Text="TP",
TextColor3=Color3.new(1,1,1),
TextScaled=true,
Active=true,
})

table.insert(P.controls,T)
table.insert(P.connections,O:connect(T.Activated,function()
j.teleport(O)
end))


table.insert(P.connections,O:connect(i.InputEnded,function(U)
for V,W in P.holds do
if U==W then
P.holds[V]=nil
end
end
end))end local P=function(




P, Q)
local R=b.Players.LocalPlayer:FindFirstChildOfClass"PlayerGui"
local S=R and R:FindFirstChild"TouchGui"
local T=S and S:FindFirstChild("JumpButton",true)
if not T then return end

Q.jumpButton=T
Q.jumpVisible=T.Visible
T.Visible=false

table.insert(Q.connections,P:connect(T:GetPropertyChangedSignal"Visible",function()
if T.Visible then
T.Visible=false
end
end))end local Q=function(



Q, R)
local S=Q.playerService:getRootPart()
if not S then return end

R.root=S
R.rootAnchored=S.Anchored
S.Anchored=true end local R=function(


R)
local S=R.root
if S and S.Parent~=nil then
S.Anchored=R.rootAnchored
end end local aa=function(


S, T, U)
local V=workspace.CurrentCamera


T.navMultiplier=math.clamp(
T.navMultiplier+U*J(Enum.KeyCode.Up,Enum.KeyCode.Down)*w,
x,
y
)


local W=S.playerService:getHumanoid()
local X=if f then L(W,T.rotation.Y)else Vector3.zero
if f and W then
W.Jump=false
end

local Y=T.holds.rise and 1 or 0
local Z=T.holds.fall and 1 or 0
local _=Vector3.new(
J(Enum.KeyCode.D,Enum.KeyCode.A)+X.X,
J(Enum.KeyCode.E,Enum.KeyCode.Q)+Y-Z,
J(Enum.KeyCode.S,Enum.KeyCode.W)+X.Z
)

local aa=i:IsKeyDown(Enum.KeyCode.LeftShift)and z or 1
local ab=if T.holds.boost then j.getBoost(S)else 1
local ac=(S.privateEnv.freecamSpeed or j.DEFAULT_SPEED)*T.navMultiplier*aa*ab
local ad=I(T.velocitySpring,U,_*ac)

local ae=I(T.panSpring,U,T.mouseDelta*u)
T.mouseDelta=Vector2.zero


local af=math.sqrt(math.tan(math.rad(r/2))/math.tan(math.rad(T.fieldOfView/2)))
local ag=T.rotation+ae*Vector2.new(0.75,1)*8*(U/af)
T.rotation=Vector2.new(
math.clamp(ag.X,-v,v),
ag.Y%(2*math.pi)
)

local ah=CFrame.fromOrientation(T.rotation.X,T.rotation.Y,0)
local ai=CFrame.new(T.position)*ah*CFrame.new(ad*s*U)
T.position=ai.Position

V.CFrame=ai
if T.anchor then
T.anchor.CFrame=ai
end
V.Focus=ai*CFrame.new(0,0,-K(V,ai,T.fieldOfView))
V.FieldOfView=T.fieldOfView end local ab=function(


ab)
return c.new("Part",workspace,{
Name="freecamAnchor",
Anchored=true,
CanCollide=false,
CanQuery=false,
CanTouch=false,
CastShadow=false,
Transparency=1,
Size=Vector3.one*0.2,
CFrame=CFrame.new(ab.position),
})end local ac=function(


ac)
local ad=e.Character or e.CharacterAdded:Wait()
local ae=ad:WaitForChild("Humanoid",100)

if ac and(
ac.CameraSubject==nil
or not ac.CameraSubject:IsDescendantOf(workspace)
)and d:isAlive(ad)then
ac.CameraSubject=ae
end end


j.stop=function(ad)
local ae=ad:collectGarbage(l)
if not ae then return false end

for af,ag in ae.connections do
ag:Disconnect()
end

h:UnbindAction(m)
h:UnbindAction(n)

if ae.gui then
ae.gui:Destroy()
end
if ae.jumpButton then
ae.jumpButton.Visible=ae.jumpVisible
end
R(ae)

local af=ae.cameraSubject
local ag=workspace.CurrentCamera

ag.CameraSubject=af

if ae.isLPHumanoid or(af and not af:IsDescendantOf(workspace))then
task.spawn(ac,ag)
end

ag.CameraType=ae.cameraType

if ae.anchor then
ae.anchor:Destroy()
end

ag.Focus=ae.focus
ag.FieldOfView=ae.fieldOfView

i.MouseBehavior=ae.mouseBehavior
i.MouseIconEnabled=ae.mouseIconEnabled

return true end


j.teleport=function(ad)
local ae=ad:getGarbage(l)
if not ae then return false end

local af=CFrame.new(ae.position)*CFrame.Angles(0,ae.rotation.Y,0)
j.stop(ad)

if not ad.playerService:teleportTo(af)then
ad:notify("Freecam","your character was not found")
end

return true end local ad=function(


ad, ae, af, ...)
local ag,ah=pcall(af,...)
if not ag then
ad:notify("Freecam",`{ae} failed: {ah}`)
end end local ae=function(


ae, af)
j.stop(ae)

local ag=workspace.CurrentCamera
local ah=ag.CFrame
local ai,S=ah:ToOrientation()

local T=ae:createGarbage(l)
T.connections={}
T.controls={}
T.holds={}
T.cameraType=ag.CameraType
T.cameraSubject=ag.CameraSubject

local U=e.Character and e.Character:FindFirstChildOfClass"Humanoid"
T.isLPHumanoid=
(T.cameraSubject~=nil and U==T.cameraSubject)or
T.cameraSubject==nil

T.focus=ag.Focus
T.fieldOfView=ag.FieldOfView
T.mouseBehavior=i.MouseBehavior
T.mouseIconEnabled=i.MouseIconEnabled

T.position=af or ah.Position
T.rotation=Vector2.new(ai,S)
T.mouseDelta=Vector2.zero
T.navMultiplier=1
T.velocitySpring=H(Vector3.zero)
T.panSpring=H(Vector2.zero)

T.anchor=ab(T)

ag.CameraType=Enum.CameraType.Custom
ag.CameraSubject=T.anchor
i.MouseBehavior=Enum.MouseBehavior.Default
i.MouseIconEnabled=true

h:BindActionAtPriority(m,G,false,o,table.unpack(q))
h:BindActionAtPriority(n,function(V,W,X)
local Y=X.Delta
T.mouseDelta=T.mouseDelta+Vector2.new(-Y.Y,-Y.X)
return Enum.ContextActionResult.Sink
end,false,o,Enum.UserInputType.MouseMovement)

if f then
Q(ae,T)
ad(ae,"buttons",O,ae,T)
ad(ae,"jump button",P,ae,T)

table.insert(T.connections,ae:connect(i.InputBegan,function(W,X)
if X or not M(W)then return end
if T.lookTouch~=nil or N(T,W.Position)then return end

if W.Position.X<workspace.CurrentCamera.ViewportSize.X/2 then return end
T.lookTouch=W
end))
table.insert(T.connections,ae:connect(i.InputChanged,function(W)
if W==T.lookTouch then
T.mouseDelta=T.mouseDelta+Vector2.new(-W.Delta.Y,-W.Delta.X)*C
end
end))
table.insert(T.connections,ae:connect(i.InputEnded,function(W)
if W==T.lookTouch then
T.lookTouch=nil
end
end))
end

table.insert(T.connections,ae:connect(ae.runService.RenderStepped,function(W)
local X,Y=pcall(aa,ae,T,W)
if not X then
j.stop(ae)
ae:notify("Freecam",`stopped, the camera was given back: {Y}`)
end
end))end


j.start=function(af, ag)
local ah,ai=pcall(ae,af,ag)
if not ah then
j.stop(af)
af:notify("Freecam",`could not start: {ai}`)
end end


j.getBoost=function(af)
local ag=af.storage.settings:getValue(k)
if type(ag)~="number"then
return j.DEFAULT_BOOST
end

return math.clamp(ag,j.MIN_BOOST,j.MAX_BOOST)end


j.addBoost=function(af, ag)
local ah=math.clamp(j.getBoost(af)+ag,j.MIN_BOOST,j.MAX_BOOST)

af.storage.settings:setValue(k,ah)
af.storage.settings:save()

return ah end


j.getPosition=function(af)
local ag=af:getGarbage(l)
return ag and ag.position end


return j end a.bZ=function()local ab=a.cache.bZ if not ab then ab={c=aa()}a.cache.bZ=ab end return ab.c end end do local aa=function()

local aa=a.S()
local ab=a.bZ()local ac=function(


ac)
if not ac then return nil end
return ac:FindFirstChildOfClass"Humanoid"or ac end local ad=function(


ad, ae)
local af=ad.playerService:getCamera()
if ae and af.CameraSubject~=ae then
af.CameraSubject=ae
end end local ae=function(



ae)
local af=ae.playerService:getHumanoid()
if af then
ad(ae,af)
end end local af=function(



af)
local ag=af:collectGarbage"view"
if not ag then return false end

for ah,ai in ag.connections do
ai:Disconnect()
end
return true end


return{
{
action="spectate|view",
description="View a player",
args={kind="player"},
run=function(ag,ah)
local ai=aa(ah:nextValue())[1]
if not ai then return end

ab.stop(ag)
af(ag)

local b=ag:createGarbage"view"
b.connections={}

local c=ag.playerService:getCamera()local d=function()



local d=ac(ai.Character)
if d then
ad(ag,d)
end end


table.insert(b.connections,ag:connect(c:GetPropertyChangedSignal"CameraSubject",d))

table.insert(b.connections,ag:connect(ai.CharacterAdded,function(e)
e:WaitForChild("Humanoid",10)
d()
end))


table.insert(b.connections,ag:connect(ag.players.PlayerRemoving,function(e)
if e==ai then
af(ag)
ae(ag)
end
end))

d()
ag:notify("Spectate","Viewing "..ai.Name)
end
},
{
action="viewpart|viewp",
description="View a part",
args={
kind="string",
name="part name"
},
run=function(ag,ah)
local ai=ah:nextValue()
if not ai then return end

ab.stop(ag)
af(ag)

local b=string.lower(ai)
for c,d in workspace:GetDescendants()do
if d:IsA"BasePart"and string.lower(d.Name)==b then
ad(ag,d)
return
end
end

ag:notify("Spectate","no part named "..ai)
end
},
{
action="unspectate|unview",
description="Stops viewing player, or part.",
run=function(ag)
ab.stop(ag)

local ah=af(ag)
ae(ag)

if ah then
ag:notify("Spectate","View turned off")
end
end
}
}end a.b_=function()local ab=a.cache.b_ if not ab then ab={c=aa()}a.cache.b_=ab end return ab.c end end do local aa=function()



local aa=a.S()
local ab=a.bZ()

local ac="Freecam"local ad=function(

ad, ae)
local af=ad.storage.waypoints:getValue(tostring(game.PlaceId))
local ag=type(af)=="table"and af[ae]
if not ag then return nil end

return ad:unstringify(ag,"Vector3")end local ae=function(


ae)
return`{math.round(ae.X)},{math.round(ae.Y)},{math.round(ae.Z)}`end


return{
{
action="freecam|fc",
description="Allows you to freely move camera around the game",
args={
kind="number",
name="camera speed",
optional=true
},
run=function(af,ag)
local ah=ag:nextValue()
if ah then
af.privateEnv.freecamSpeed=ah
end

ab.start(af)
end
},
{
action="freecampos|fcpos",
description="Moves / opens freecam in a certain position",
args={kind="vector3"},
run=function(af,ag)
local ah=ag:nextValue()
if ah then
ab.start(af,ah)
end
end
},
{
action="freecamwaypoint|fcwp",
description="Moves / opens freecam to a waypoint",
args={
kind="waypoint"
},
run=function(af,ag)
local ah=ag:nextValue()
local ai=ah and ad(af,ah)
if not ai then
af:notify(ac,`there is no waypoint named '{ah}'`)
return
end

ab.start(af,ai)
end
},
{
action="freecamgoto|fcgoto|freecamtp|fctp",
description="Moves / opens freecam to a player",
args={kind="player"},
run=function(af,ag)
local ah=aa(ag:nextValue())[1]
local ai=ah and ah.Character and ah.Character:FindFirstChild"HumanoidRootPart"
if not ai then
af:notify(ac,"that player's character is not loaded")
return
end

ab.start(af,ai.Position)
end
},
{
action="unfreecam|unfc|nofreecam|nofc",
description="Disables freecam",
run=function(af)
ab.stop(af)
end
},
{
action="freecamspeed|fcspeed",
description="Adjusts freecam speed (default is 1)",
args={kind="number"},
run=function(af,ag)
af.privateEnv.freecamSpeed=ag:nextValue()or ab.DEFAULT_SPEED
end
},
{
action="notifyfreecamposition|notifyfcpos",
description="Noitifies you your freecam coordinates",
run=function(af)
local ag=ab.getPosition(af)
if not ag then
af:notify(ac,"freecam is not on")
return
end

af:notify("Freecam Position",ae(ag))
end
},
{
action="copyfreecamposition|copyfcpos",
description="Copies your freecam coordinates to your clipboard",
run=function(af)
local ag=ab.getPosition(af)
if not ag then
af:notify(ac,"freecam is not on")
return
end

local ah=af:expectExploit"setclipboard"
if not ah then return end

ah(ae(ag))
af:notify(ac,"copied freecam position to clipboard")
end
},
{
action="freecamboost|fcboost",
description="Increases the freecam boost (the BOOST button) by an amount, and saves it",
args={kind="number",name="amount",optional=true},
run=function(af,ag)
local ah=ag:nextValue()or 1
local ai=ab.addBoost(af,ah)
af:notify(ac,`freecam boost is now {ai}x`)
end
},
}end a.b0=function()local ab=a.cache.b0 if not ab then ab={c=aa()}a.cache.b0=ab end return ab.c end end do local aa=function()

return{
{
action="gotocamera|gotocam|tocam",
description="Teleports you to the location of your camera",
run=function(aa)
aa.playerService:teleportTo(aa.playerService:getCamera().CFrame)
end
},
{
action="tweengotocamera|tweengotocam|tgotocamera|tgotocam",
description="Tweens you to the location of your camera",
run=function(aa)
aa.playerService:tweenTeleportTo{
target=aa.playerService:getCamera().CFrame,
speed=aa.privateEnv.tweenSpeed
}
end
}
}end a.b1=function()local ab=a.cache.b1 if not ab then ab={c=aa()}a.cache.b1=ab end return ab.c end end do local aa=function()

return{
{
action="firstp",
description="Forces camera to go into first person",
run=function(aa)
aa.localPlayer.CameraMode=Enum.CameraMode.LockFirstPerson
end
},
{
action="thirdp",
description="Allows camera to go into third person",
run=function(aa)
aa.localPlayer.CameraMode=Enum.CameraMode.Classic
end
}
}end a.b2=function()local ab=a.cache.b2 if not ab then ab={c=aa()}a.cache.b2=ab end return ab.c end end do local aa=function()local aa=function(


aa)
local ab=aa:FindFirstChild"PlayerScripts"
local ac=ab and ab:FindFirstChild"PlayerModule"
local ad=ac and ac:FindFirstChild"CameraModule"
local ae=ad and ad:FindFirstChild"ZoomController"
return ae and ae:FindFirstChild"Popper"end


return{
action="noclipcam|nccam",
description="Allows camera to go through objects like walls",
run=function(ab)
local ac=ab:expectExploit"getgc"
local ad=ab:expectExploit"getconstants"
local ae=ab:expectExploit"setconstant"
local af=ab:expectExploit"getfenv"
if not(ac and ad and ae and af)then return end

local ag=aa(ab.localPlayer)
if not ag then
ab:notify("noclipcam","camera popper not found")
return
end


for ah,ai in ac()do
if type(ai)=="function"and af(ai).script==ag then
for b,c in ad(ai)do
if tonumber(c)==0.25 then
ae(ai,b,0)
elseif tonumber(c)==0 then
ae(ai,b,0.25)
end
end
end
end
end
}end a.b3=function()local ab=a.cache.b3 if not ab then ab={c=aa()}a.cache.b3=ab end return ab.c end end do local aa=function()

return{
{
action="maxzoom",
description="Maximum camera zoom",
args={kind="number"},
run=function(aa,ab)
aa.localPlayer.CameraMaxZoomDistance=ab:nextValue()
end
},
{
action="minzoom",
description="Minimum camera zoom",
args={kind="number"},
run=function(aa,ab)
aa.localPlayer.CameraMinZoomDistance=ab:nextValue()
end
},
{
action="camdistance",
description="Changes camera distance from your player",
args={kind="number"},
run=function(aa,ab)
local ac=ab:nextValue()
local ad=aa.localPlayer
local ae=ad.CameraMaxZoomDistance
local af=ad.CameraMinZoomDistance

if ae<ac then
ae=ac
end

ad.CameraMaxZoomDistance=ac
ad.CameraMinZoomDistance=ac
task.wait()
ad.CameraMaxZoomDistance=ae
ad.CameraMinZoomDistance=af
end
}
}end a.b4=function()local ab=a.cache.b4 if not ab then ab={c=aa()}a.cache.b4=ab end return ab.c end end do local aa=function()

return{
action="fov",
description="Adjusts field of view (default is 70)",
args={kind="number",default=70},
run=function(aa,ab)
local ac=math.clamp(math.abs(ab:nextValue()or 70),1,120)
workspace.CurrentCamera.FieldOfView=ac
end
}end a.b5=function()local ab=a.cache.b5 if not ab then ab={c=aa()}a.cache.b5=ab end return ab.c end end do local aa=function()

local aa=a.bZ()

return{
action="fixcam|restorecam",
description="Fixes camera",
run=function(ab)
local ac=ab.playerService
local ad=ab.localPlayer


aa.stop(ab)


if ab:hasGarbage"view"then
ab:run"unview"
end

local ae=ac:getHumanoid()

if ae then
ab.signals.onCameraReset:Fire()

local af=ac:getCamera()
af.CameraSubject=ae
af.CameraType=Enum.CameraType.Custom

ad.CameraMinZoomDistance=0.5
ad.CameraMaxZoomDistance=400
ad.CameraMode=Enum.CameraMode.Classic

ab:notify"camera has been reseted successfully"
end
end
}end a.b6=function()local ab=a.cache.b6 if not ab then ab={c=aa()}a.cache.b6=ab end return ab.c end end do local aa=function()

return{
action="enableshiftlock|enablesl",
description="Enables the shift lock option",
run=function(aa)
local ab=aa.localPlayer
ab.DevEnableMouseLock=true


if aa:hasGarbage"shiftlock"then return end

local ac=aa:createGarbage"shiftlock"
ac.connection=aa:connect(ab:GetPropertyChangedSignal"DevEnableMouseLock",function()
ab.DevEnableMouseLock=true
end)

aa:notify("Shiftlock","Shift lock should now be available")
end
}end a.b7=function()local ab=a.cache.b7 if not ab then ab={c=aa()}a.cache.b7=ab end return ab.c end end do local aa=function()

local aa=a.S()


local ab={max=400,min=0.5}

return{
action="lookat",
description="Moves your camera view to a player",
args={kind="player"},
run=function(ac,ad)
local ae=aa(ad:nextValue())[1]
local af=ae and ae.Character and ae.Character:FindFirstChild"Head"
if not af then
ac:notify("Lookat","the player's character is not loaded")
return
end

local ag=ac.localPlayer
local ah=ac.playerService:getCamera()


if ag.CameraMaxZoomDistance~=0.5 then
ac.privateEnv.lookAtZoom={
max=ag.CameraMaxZoomDistance,
min=ag.CameraMinZoomDistance
}
end
local ai=ac.privateEnv.lookAtZoom or ab


ag.CameraMaxZoomDistance=0.5
ag.CameraMinZoomDistance=0.5
task.wait()

ah.CFrame=CFrame.new(ah.CFrame.Position,af.Position)
task.wait(0.1)

ag.CameraMaxZoomDistance=ai.max
ag.CameraMinZoomDistance=ai.min
end
}end a.b8=function()local ab=a.cache.b8 if not ab then ab={c=aa()}a.cache.b8=ab end return ab.c end end do local aa=function()

local aa=a.S()local ab=function(

ab)
local ac=ab:collectGarbage"stareat"
if ac then
ac.connection:Disconnect()
end end


return{
{
action="stareat|stare",
description="Stare / look at a player",
args={
kind="player"
},
run=function(ac,ad)
local ae=aa(ad:nextValue())[1]
if not ae then return end

ab(ac)

local af=ac:createGarbage"stareat"
af.connection=ac:connect(ac.runService.RenderStepped,function()
if ae.Parent==nil then
ab(ac)
return
end

local ag=ac.playerService:getRootPart()
local ah=ae.Character and ae.Character:FindFirstChild"HumanoidRootPart"
if not(ag and ah)then return end


local ai=Vector3.new(ah.Position.X,ag.Position.Y,ah.Position.Z)
if(ai-ag.Position).Magnitude<0.01 then return end

ag.CFrame=CFrame.new(ag.Position,ai)
end)
end
},
{
action="unstareat|unstare",
description="Disables stareat",
run=function(ac)
ab(ac)
end
}
}end a.b9=function()local ab=a.cache.b9 if not ab then ab={c=aa()}a.cache.b9=ab end return ab.c end end do local aa=function()

return{a.b_()
,a.b0()
,a.b1()
,a.b2()
,a.b3()
,a.b4()
,a.b5()
,a.b6()
,a.b7()
,a.b8()
,a.b9()

}end a.ca=function()local ab=a.cache.ca if not ab then ab={c=aa()}a.cache.ca=ab end return ab.c end end do local aa=function()


local aa

return{
{
client=true,
action="btools",
description="Gives you building tools (DOES NOT REPLICATE)",
run=function(ab)
local ac=ab.localPlayer:FindFirstChildWhichIsA"Backpack"
if not ac then
ab:notify("Btools","your backpack is not loaded")
return
end


for ad,ae in Enum.BinType:GetEnumItems()do
local af=Instance.new"HopperBin"
af.BinType=ae
af.Name="Building Tool"
af.Parent=ac
end
end
},
{
client=true,
action="f3x",
description="Gives you F3X building tools (DOES NOT REPLICATE)",
run=function(ab)
if aa==nil then
ab:notify("F3X","no script link is set, fill in F3X_SOURCE_URL at the top of workspace/clienttools.luau")
return
end

local ac=ab:expectExploit"loadstring"
if not ac then return end

local ad,ae=pcall(function()
ac(game:HttpGet(aa))()
end)

if not ad then
ab:notify("F3X",`failed to load: {tostring(ae)}`)
end
end
}
}end a.cb=function()local ab=a.cache.cb if not ab then ab={c=aa()}a.cache.cb=ab end return ab.c end end do local aa=function()local aa=function(






aa, ab)
local ac={}

for ad in aa do
ac[ad:lower()]=true
end

if not ac[ab:lower()]then
return ab
end

local ad=1
while ac[ab:lower()..ad]do
ad=ad+1
end

return ab..ad end local ab=function(



ab, ac)
local ad=ab.storage.waypoints
local ae=ad:register(tostring(game.PlaceId),{})

local af=aa(ae,ac.Name)
ae[af]=ab:stringify(ac.Position)
ad:save()

return af end


return{
{
action="partname|partpath",
description="Opens a window: click a part to see its path & name, then Select Part saves it as a waypoint",
run=function(ac)
ac.infiniteYield:openPartPath(function(ad)
local ae=ab(ac,ad)
ac:notify("Modified Waypoints","Created waypoint: "..ae)
end)
end
}
}end a.cc=function()local ab=a.cache.cc if not ab then ab={c=aa()}a.cache.cc=ab end return ab.c end end do local aa=function()local aa=function(


aa, ab, ac)
if ab==false then
aa:notify("Delete","cancelled: "..ac)
return false
end
return true end


return{
{
client=true,
action="delete|remove",
description="Removes any part with a certain name from the workspace (DOES NOT REPLICATE)",
args={
{
kind="string",
name="object name"
},
{
kind="boolean",
name="confirm"
}
},
run=function(ab,ac)
local ad=ac:nextValue()
local ae=ac:nextValue()
if not aa(ab,ae,ad)then return end

local af=ad:lower()
for ag,ah in workspace:GetDescendants()do
if ah.Name:lower()==af then
ah:Destroy()
end
end

ab:notify("Item(s) Deleted","Deleted "..ad)
end
},
{
client=true,
action="deleteclass|dc",
description="Removes any part with a certain classname from the workspace (DOES NOT REPLICATE)",
args={
{
kind="className"
},
{
kind="boolean",
name="confirm"
}
},
run=function(ab,ac)
local ad=ac:nextValue()
local ae=ac:nextValue()
if not aa(ab,ae,ad)then return end

local af=ad:lower()
for ag,ah in workspace:GetDescendants()do
if ah.ClassName:lower()==af then
ah:Destroy()
end
end

ab:notify("Item(s) Deleted","Deleted items with ClassName "..ad)
end
}
}end a.cd=function()local ab=a.cache.cd if not ab then ab={c=aa()}a.cache.cd=ab end return ab.c end end do local aa=function()




return{
{
action="lockworkspace|lockws",
description="Locks the whole workspace",
run=function(aa)
local ab=aa:createGarbage"lockworkspace"
if not ab then
aa:notify("Lock workspace","the workspace is already locked")
return
end

local ac=aa.playerService:getCharacter()

for ad,ae in workspace:GetDescendants()do
if ae:IsA"BasePart"and not(ac and ae:IsDescendantOf(ac))then
ab[ae]=ae.Locked
ae.Locked=true
end
end

aa:notify("Lock workspace","locked the parts in the workspace")
end
},
{
action="unlockworkspace|unlockws",
description="Unlocks the whole workspace",
run=function(aa)
local ab=aa:collectGarbage"lockworkspace"
if not ab then return end

for ac,ad in ab do
if ac.Parent then
ac.Locked=ad
end
end

aa:notify("Lock workspace","unlocked")
end
}
}end a.ce=function()local ab=a.cache.ce if not ab then ab={c=aa()}a.cache.ce=ab end return ab.c end end do local aa=function()

return{
{
client=true,
action="invisibleparts|invisparts",
description="Shows invisible parts",
run=function(aa)
local ab=aa.privateEnv.shownParts or{}
aa.privateEnv.shownParts=ab

for ac,ad in workspace:GetDescendants()do
if ad:IsA"BasePart"and ad.Transparency==1 then
if not table.find(ab,ad)then
table.insert(ab,ad)
end
ad.Transparency=0
end
end
end
},
{
client=true,
action="uninvisibleparts|uninvisparts",
description="Makes parts affected by invisparts return to normal",
run=function(aa)
for ab,ac in aa.privateEnv.shownParts or{}do
ac.Transparency=1
end
aa.privateEnv.shownParts={}
end
}
}end a.cf=function()local ab=a.cache.cf if not ab then ab={c=aa()}a.cache.cf=ab end return ab.c end end do local aa=function()local aa=function(

aa, ab, ac)
return{
action=aa,
description=ab,
run=function()
for ad,ae in workspace:GetDescendants()do
if ae:IsA(ac)then
ae.MaxActivationDistance=math.huge
end
end
end
}end


return{
aa(
"noclickdetectorlimits|nocdlimits|removecdlimits",
"Removes the activation distance limit of ClickDetectors",
"ClickDetector"
),
aa(
"noproximitypromptlimits|nopplimits|removepplimits",
"Removes the activation distance limit of ProximityPrompts",
"ProximityPrompt"
),
{
action="instantproximityprompts|instantpp",
description="Fires proximity prompts as soon as they are held (needs fireproximityprompt)",
run=function(ab)
local ac=ab.executorEnv.fireproximityprompt

if not ac then
ab:notify("Incompatible Exploit","Your exploit does not support this command (missing fireproximityprompt)")
return
end

if ab:hasGarbage"instantpp"then
ab:notify"instant proximity prompts is already enabled"
return
end

local ad=ab:createGarbage"instantpp"
ad.connection=ab:connect(ab.proximityPromptService.PromptButtonHoldBegan,function(ae)
ac(ae)
end)
end
},
{
action="uninstantproximityprompts|uninstantpp",
description="Disables instant proximity prompts",
run=function(ab)
local ac=ab:collectGarbage"instantpp"
if ac and ac.connection then
ac.connection:Disconnect()
end
end
}
}end a.cg=function()local ab=a.cache.cg if not ab then ab={c=aa()}a.cache.cg=ab end return ab.c end end do local aa=function()

local aa=workspace.Gravity
local ab=-500

return{
{
action="gravity|grav",
description="Sets the workspace gravity (no value resets it)",
args={kind="number",name="gravity",optional=true},
run=function(ac,ad)
workspace.Gravity=ad:nextValue()or aa
end
},
{
action="destroyheight|dh",
description="Sets the height where fallen parts get destroyed (default is -500)",
args={kind="number",name="height",optional=true},
run=function(ac,ad)
workspace.FallenPartsDestroyHeight=ad:nextValue()or ab
end
}
}end a.ch=function()local ab=a.cache.ch if not ab then ab={c=aa()}a.cache.ch=ab end return ab.c end end do local aa=function()

return{
{
action="deleteinvisparts|deleteinvisibleparts|dip",
description="Deletes invisible collidable parts",
run=function()
for aa,ab in workspace:GetDescendants()do
if ab:IsA"BasePart"and ab.Transparency==1 and ab.CanCollide then
ab:Destroy()
end
end
end
},
{
action="removeterrain|rterrain|noterrain",
description="Clears all the terrain",
run=function()
local aa=workspace:FindFirstChildOfClass"Terrain"
if aa then
aa:Clear()
end
end
}
}end a.ci=function()local ab=a.cache.ci if not ab then ab={c=aa()}a.cache.ci=ab end return ab.c end end do local aa=function()local aa=function(

aa, ab)
return ab==""
or aa.Name:lower()==ab
or(aa.Parent~=nil and aa.Parent.Name:lower()==ab)end local ab=function(


ab)
local ac=ab.Parent
if ac==nil then
return nil
elseif ac:IsA"Attachment"then
return ac.WorldPosition
elseif ac:IsA"BasePart"then
return ac.Position
elseif ac:IsA"Model"then
return ac:GetPivot().Position
end
return nil end local ac=function(


ac)
local ad=ac.playerService:getRootPart()
if not ad then
return nil
end

local ae
local af=math.huge

for ag,ah in workspace:GetDescendants()do
if ah:IsA"ProximityPrompt"and ah.Enabled then
local ai=ab(ah)
if not ai then continue end

local b=(ai-ad.Position).Magnitude

if b<af then
ae,af=ah,b
end
end
end

return ae end local ad=function(


ad, ae)
local af=ad.playerService:getRootPart()
local ag=ab(ae)

if af and ag then
af.CFrame=CFrame.new(ag+Vector3.new(0,3,0))
end end


return{
{
action="fireclickdetectors|firecd|firecds",
description="Uses all click detectors in a game or uses the optional name",
args={
kind="object",
optional=true
},
run=function(ae,af)
local ag=ae:expectExploit"fireclickdetector"
if not ag then return end

local ah=(af:nextValue()or""):lower()

for ai,b in workspace:GetDescendants()do
if b:IsA"ClickDetector"and aa(b,ah)then
ag(b)
end
end
end
},
{
action="fireproximityprompts|firepp",
description="Uses all proximity prompts in a game or uses the optional name",
args={
kind="object",
optional=true
},
run=function(ae,af)
local ag=ae:expectExploit"fireproximityprompt"
if not ag then return end

local ah=(af:nextValue()or""):lower()

for ai,b in workspace:GetDescendants()do
if b:IsA"ProximityPrompt"and aa(b,ah)then
ag(b)
end
end
end
},
{
action="fireclosestprompt|fcp",
description="Uses the closest proximity prompt to your character",
args={
optional=true,
kind="boolean",
name="teleport to prompt"
},
run=function(ae,af)
local ag=ae:expectExploit"fireproximityprompt"
if not ag then return end

local ah=ac(ae)
if not ah then
ae:notify"Can't find any ProximityPrompt on workspace"
return
end

if af:nextValue()then
ad(ae,ah)
task.wait(0.25)
end

ag(ah)
ae:notify(`fired prompt: {ah:GetFullName()}`)
end
},
{
action="firetouchinterests|touchinterests",
description="Uses all touchinterests in a game or uses the optional name",
args={
kind="object",
optional=true
},
run=function(ae,af)
local ag=ae:expectExploit"firetouchinterest"
if not ag then return end

local ah=ae.playerService:getRootPart()
if not ah then return end

local ai=(af:nextValue()or""):lower()

for b,c in workspace:GetDescendants()do
if c:IsA"TouchTransmitter"and c.Parent:IsA"BasePart"and aa(c.Parent,ai)then
ag(c.Parent,ah,0)
ag(c.Parent,ah,1)
end
end
end
}
}end a.cj=function()local ab=a.cache.cj if not ab then ab={c=aa()}a.cache.cj=ab end return ab.c end end do local aa=function()
local aa=a.S()local ab=function(


ab)
local ac=ab.Parent
if ac and ac:FindFirstChildWhichIsA"Humanoid"then
return true
end

local ad=ac and ac.Parent
return ad~=nil and ad:FindFirstChildWhichIsA"Humanoid"~=nil end local ac=function(



ac)
local ad=ac.playerService:getCharacter()
local ae={}

for af,ag in workspace:GetDescendants()do
if ag:IsA"BasePart"and not ag.Anchored and not(ad and ag:IsDescendantOf(ad))and not ab(ag)then
table.insert(ae,ag)
end
end

return ae end


return{
{
action="tpunanchored|tpua",
description="Teleports unanchored parts to a player",
args={
kind="player"
},
run=function(ad,ae)
local af=aa(ae:nextValue())[1]
local ag=af and af.Character and af.Character:FindFirstChild"Head"
if not ag then return end

local ah=ad:registerGarbage"tpunanchored"
ah.forces=ah.forces or{}

for ai,b in ac(ad)do

local c=Instance.new"BodyPosition"
c.MaxForce=Vector3.one*math.huge
c.Position=ag.Position
c.Parent=b
table.insert(ah.forces,c)
end
end
},
{
action="freezeunanchored|freezeua|animsunanchored",
description="Freezes unanchored parts",
run=function(ad)
if ad:hasGarbage"freezeua"then
ad:notify("Freeze","unanchored parts are already frozen, use thawunanchored")
return
end

local ae=ad:createGarbage"freezeua"
ae.parts={}

for af,ag in ac(ad)do
ag.Anchored=true
table.insert(ae.parts,ag)
end

ad:notify("Freeze",`froze {#ae.parts} unanchored part(s)`)
end
},
{
action="thawunanchored|thawua|unfreezeua",
description="Thaws unanchored parts",
run=function(ad)
local ae=ad:collectGarbage"tpunanchored"
if ae then
for af,ag in ae.forces or{}do
ag:Destroy()
end
end

local af=ad:collectGarbage"freezeua"
if af then
for ag,ah in af.parts do
if ah.Parent then
ah.Anchored=false
end
end
end
end
}
}end a.ck=function()local ab=a.cache.ck if not ab then ab={c=aa()}a.cache.ck=ab end return ab.c end end do local aa=function()

return{a.cb()
,a.cc()
,a.cd()
,a.ce()
,a.cf()
,a.cg()
,a.ch()
,a.ci()
,a.cj()
,a.ck()

}end a.cl=function()local ab=a.cache.cl if not ab then ab={c=aa()}a.cache.cl=ab end return ab.c end end do local aa=function()local aa=function(

aa)
local ab=aa.robloxServices.Lighting
ab.Brightness=2
ab.ClockTime=14
ab.FogEnd=100000
ab.GlobalShadows=false
ab.OutdoorAmbient=Color3.fromRGB(128,128,128)end local ab=function(


ab)
local ac=ab:collectGarbage"loopfullbright"
if ac then
ac.connection:Disconnect()
end end


return{
{
action="fullbright|fb",
description="Makes the map brighter / more visible (CLIENT)",
run=function(ac)
aa(ac)
end
},
{
action="loopfullbright|loopfb",
description="Makes the map brighter / more visible but looped (CLIENT)",
run=function(ac)
ab(ac)

local ad=ac:createGarbage"loopfullbright"
ad.connection=ac:connect(ac.runService.RenderStepped,function()
aa(ac)
end)
end
},
{
action="unloopfullbright|unloopfb",
description="Unloops fullbright",
run=function(ac)
ab(ac)
end
}
}end a.cm=function()local ab=a.cache.cm if not ab then ab={c=aa()}a.cache.cm=ab end return ab.c end end do local aa=function()

return{
client=true,
action="ambient",
description="Changes ambient",
args={kind="color3"},
run=function(aa,ab)
local ac=ab:nextValue()
local ad=aa.robloxServices.Lighting

ad.Ambient=ac
ad.OutdoorAmbient=ac
end
}end a.cn=function()local ab=a.cache.cn if not ab then ab={c=aa()}a.cache.cn=ab end return ab.c end end do local aa=function()

return{
{
client=true,
action="day",
description="Changes the time to day for the client",
run=function(aa)
aa.robloxServices.Lighting.ClockTime=14
end
},
{
client=true,
action="night",
description="Changes the time to night for the client",
run=function(aa)
aa.robloxServices.Lighting.ClockTime=0
end
}
}end a.co=function()local ab=a.cache.co if not ab then ab={c=aa()}a.cache.co=ab end return ab.c end end do local aa=function()

return{
client=true,
action="nofog",
description="Removes fog",
run=function(aa)
local ab=aa.robloxServices.Lighting
ab.FogEnd=100000

for ac,ad in ab:GetDescendants()do
if ad:IsA"Atmosphere"then
ad:Destroy()
end
end
end
}end a.cp=function()local ab=a.cache.cp if not ab then ab={c=aa()}a.cache.cp=ab end return ab.c end end do local aa=function()

return{
client=true,
action="brightness",
description="Changes the brightness lighting property",
args={kind="number"},
run=function(aa,ab)
aa.robloxServices.Lighting.Brightness=ab:nextValue()
end
}end a.cq=function()local ab=a.cache.cq if not ab then ab={c=aa()}a.cache.cq=ab end return ab.c end end do local aa=function()

return{
{
client=true,
action="globalshadows|gshadows",
description="Enables global shadows",
run=function(aa)
aa.robloxServices.Lighting.GlobalShadows=true
end
},
{
client=true,
action="noglobalshadows|nogshadows|unglobalshadows",
description="Disables global shadows",
run=function(aa)
aa.robloxServices.Lighting.GlobalShadows=false
end
}
}end a.cr=function()local ab=a.cache.cr if not ab then ab={c=aa()}a.cache.cr=ab end return ab.c end end do local aa=function()

local aa=a.b()
local ab=a.S()


local ac=a.P().Lighting

local ad={"Ambient","OutdoorAmbient","Brightness","ClockTime","FogEnd","FogStart","GlobalShadows"}
local ae={}local af=function()


for af,ag in ae do
ac[af]=ag
end end local ag=function()



if aa.originalLighting then
ae=aa.originalLighting
return
end

for ag,ah in ad do
ae[ah]=ac[ah]
end

aa.originalLighting=ae end


ag()

return{
{
action="restorelighting|rlighting",
description="Restores Lighting properties",
run=af
},
{
action="light",
description="Gives your player dynamic light (CLIENT)",
args={
{
kind="player"
},
{
kind="number",
name="radius",
optional=true
}
},
run=function(ah,ai)
local b=ab(ai:nextValue())
local c=ai:nextValue()or 10

for d,e in b do
local f=e.Character and e.Character:FindFirstChild"HumanoidRootPart"
if not f then return end

local g=Instance.new"PointLight"
g.Range=c
g.Brightness=5
g.Parent=f

table.insert(ah:registerGarbage"dynamicLights",g)
end
end
},
{
action="nolight|unlight",
description="Removes dynamic light from your player",
run=function(ah)
for ai,b in ah:collectGarbage"dynamicLights"or{}do
b:Destroy()
end

local ai=ah.playerService:getCharacter()
if ai then
for b,c in ai:GetDescendants()do
if c:IsA"PointLight"then
c:Destroy()
end
end
end
end
}
}end a.cs=function()local ab=a.cache.cs if not ab then ab={c=aa()}a.cache.cs=ab end return ab.c end end do local aa=function()

return{a.cm()
,a.cn()
,a.co()
,a.cp()
,a.cq()
,a.cr()
,a.cs()

}end a.ct=function()local ab=a.cache.ct if not ab then ab={c=aa()}a.cache.ct=ab end return ab.c end end do local aa=function()





local aa=a.bA()

local ab={}local ac=function(

ac, ad)
local ae=table.find(ac,ad)
if ae then
table.remove(ac,ae)
end end



ab.add=function(ad, ae, af)
ae=ae:lower()

if ad.lookup[ae]~=nil then
return false,`'{ae}' is already a command or an alias`
end

local ag=ad.lookup[af:lower()]
if not ag then
return false,"invalid command"
end

ad.lookup[ae]=ag
table.insert(ad.array,ae)

aa.object[ae]=ag.name
aa:save()

return true end



ab.remove=function(ad, ae)
ae=ae:lower()

local af=aa.object[ae]
if type(af)~="string"then
return false
end

ad.lookup[ae]=nil
ac(ad.array,ae)

aa.object[ae]=nil
aa:save()

return true,af end



ab.clear=function(ad)
local ae={}
for af in aa.object do
table.insert(ae,af)
end

for af,ag in ae do
ad.lookup[ag]=nil
ac(ad.array,ag)
aa.object[ag]=nil
end

aa:save()
return#ae end



ab.restore=function(ad)
for ae,af in aa.object do
local ag=type(af)=="string"and ad.lookup[af]

if ag and ad.lookup[ae]==nil then
ad.lookup[ae]=ag
table.insert(ad.array,ae)
end
end end


return ab end a.cu=function()local ab=a.cache.cu if not ab then ab={c=aa()}a.cache.cu=ab end return ab.c end end do local aa=function()

local aa=a.cu()

return{
{
action="addalias",
description="Adds an alias to a command",
args={
{
kind="command"
},
{
kind="string",
name="alias"
}
},
run=function(ab,ac)
local ad=ac:nextValue()
local ae=ac:nextValue()
if not(ad and ae)then return end

local af,ag=aa.add(ab.commandsList,ae,ad)
if af then
ab:notify("Aliases Modified",`Added {ae:lower()} as an alias to {ad}`)
else
ab:notify("Aliases Modified",ag)
end
end
},
{
action="removealias",
description="Removes a custom alias",
args={kind="alias"},
run=function(ab,ac)
local ad=ac:nextValue()
if not ad then return end

local ae,af=aa.remove(ab.commandsList,ad)
if ae then
ab:notify("Aliases Modified",`Removed the alias {ad} from {af}`)
end
end
},
{
action="clraliases",
description="Removes all custom aliases",
args={
kind="boolean",
name="confirm",
optional=true
},
run=function(ab,ac)

if ac and ac:nextValue()==false then return end

local ad=aa.clear(ab.commandsList)
ab:notify("Aliases Modified",`Removed {ad} custom alias(es)`)
end
}
}end a.cv=function()local ab=a.cache.cv if not ab then ab={c=aa()}a.cache.cv=ab end return ab.c end end do local aa=function()




















local aa=a.a()
local ab=a.aj()
local ac=a.by()

local ad={}

local ae=".luau"
local af=`{ab.privateFolder}/plugins`

ad.FOLDER=af


local ag={}


local ah={}local ai=function(

ai, b)
local c=table.find(ai,b)
if c then
table.remove(ai,c)
end end local b=function(



b)
local c=b
if c:sub(-#ae)==ae then
c=c:sub(1,-#ae-1)
end

if c:match"^[%w_%-]+$"then
return c
end
return nil end local c=function(


c)
return`{af}/{c}{ae}`end local d=function(


d)
if aa.readfile==nil or aa.isfile==nil then
return nil,"your exploit does not support readfile"
end

local e=c(d)

local f,g=pcall(aa.isfile,e)
if not(f and g)then
return nil,`file not found: {e}`
end

local h,i=pcall(aa.readfile,e)
if not(h and type(i)=="string")then
return nil,`could not read {e}`
end

return i end local e=function(



e)
if aa.loadstring==nil then
return nil,"your exploit does not support loadstring"
end

local f,g,h=pcall(aa.loadstring,e)
if not f then
return nil,tostring(g)
end
if not g then
return nil,tostring(h)
end

local i,j=pcall(g)
if not i then
return nil,`error while loading the plugin: {j}`
end
if type(j)~="table"then
return nil,"the plugin must return a table of commands"
end

return j end local f=function(




f)
local g=f
if type(f.action)=="string"then
g={f}
end

local h={}

for i,j in g do
if type(j)~="table"or type(j.action)~="string"then
return nil,"every command needs an action string"
end

if j.run~=nil and type(j.run)~="function"then
return nil,`run of '{j.action}' must be a function`
end

local k={}
for l,m in j.action:split"|"do
local n=m:lower()
if n==""then
return nil,`empty name in '{j.action}'`
end
table.insert(k,n)
end


local l={}
for m,n in j do
l[m]=n
end

local m=l.args or{}
if#m==0 and next(m)then
m={m}
end
l.args=m

local n=table.clone(k)
table.sort(n,function(o,p)
return#o<#p
end)

l.name=k[1]
l.aliases=n
l.action=nil

table.insert(h,{entry=l,names=k})
end

if#h==0 then
return nil,"the plugin has no commands"
end

return h end local g=function(



g, h)
local i,j=d(h)
if not i then
return false,j
end

local k,l=e(i)
if not k then
return false,l
end

local m,n=f(k)
if not m then
return false,n
end

local o={}
local p={}

for q,r in m do
for s,t in r.names do
if g.lookup[t]~=nil or p[t]then
return false,`'{t}' is already a command or an alias`
end
p[t]=true
table.insert(o,t)
end
end

for q,r in m do
for s,t in r.names do
g.lookup[t]=r.entry
table.insert(g.array,t)
end
end

ag[h]={keys=o,commands=#m}
return true,#m end local h=function(



h, i)
local j,k=g(h,i)

ah[i]=if j then nil else tostring(k)
return j,k end local i=function(


i, j)
local k=ag[j]
if not k then return end

for l,m in k.keys do
i.lookup[m]=nil
ai(i.array,m)
end

ag[j]=nil end



ad.add=function(j, k)
local l=b(k)
if not l then
return false,"plugin names can only use letters, numbers, '_' and '-'"
end

if ag[l]then
return false,`'{l}' is already loaded`
end

local m,n=h(j,l)
if not m then
return false,n
end

ac.object[l]=l..ae
ac:save()

return true,n end



ad.remove=function(j, k)
if ac.object[k]==nil and ag[k]==nil then
return false
end

i(j,k)
ah[k]=nil

ac.object[k]=nil
ac:save()

return true end



ad.reload=function(j, k)
if ac.object[k]==nil then
return false,`'{k}' is not installed`
end

i(j,k)
return h(j,k)end




ad.restore=function(j)
local k={}

for l in ac.object do
if not ag[l]then
local m,n=h(j,l)
if not m then
k[l]=tostring(n)
end
end
end

return k end



ad.addAll=function(j)
if aa.listfiles==nil then
return nil,"your exploit does not support listfiles"
end

local k,l=pcall(aa.listfiles,af)
if not(k and type(l)=="table")then
return nil,`could not read the folder {af} (create it and put your .luau plugins there)`
end

local m={added={},failed={}}

for n,o in l do
local p=type(o)=="string"and o:match"([^/\\]+)%.luau$"

if p and not ag[p]then
local q,r=ad.add(j,p)
if q then
table.insert(m.added,p)
else
table.insert(m.failed,`{p}: {r}`)
end
end
end

return m end




ad.getInstalled=function()
local j={}

for k in ac.object do
local l=ag[k]

table.insert(j,{
name=k,
loaded=l~=nil,
commands=if l then l.commands else 0,
error=if l then nil else ah[k],
})
end

table.sort(j,function(k,l)
return k.name:lower()<l.name:lower()
end)

return j end




ad.getAvailable=function()
if aa.listfiles==nil then
return nil,"your exploit does not support listfiles"
end

local j,k=pcall(aa.listfiles,af)
if not(j and type(k)=="table")then
return nil,`could not read the folder {af} (create it and put your .luau plugins there)`
end

local l={}

for m,n in k do
local o=type(n)=="string"and n:match"([^/\\]+)%.luau$"

if o and b(o)and ac.object[o]==nil then
table.insert(l,o)
end
end

table.sort(l,function(m,n)
return m:lower()<n:lower()
end)

return l end


return ad end a.cw=function()local ab=a.cache.cw if not ab then ab={c=aa()}a.cache.cw=ab end return ab.c end end do local aa=function()

local aa=a.cw()

return{
{
action="addplugin|plugin",
description="Add a plugin via command",
args={
kind="string",
name="plugin name"
},
run=function(ab,ac)
local ad=ac:nextValue()
if not ad then return end

local ae,af=aa.add(ab.commandsList,ad)
if ae then
ab:notify("Plugins",`Added '{ad}' ({af} command(s))`)
else
ab:notify("Plugin Error",af)
end
end
},
{
action="removeplugin|deleteplugin",
description="Remove a plugin via command",
args={kind="plugin"},
run=function(ab,ac)
local ad=ac:nextValue()
if not ad then return end

if aa.remove(ab.commandsList,ad)then
ab:notify("Plugins",`Removed '{ad}'`)
end
end
},
{
action="reloadplugin",
description="Reloads a plugin",
args={kind="plugin"},
run=function(ab,ac)
local ad=ac:nextValue()
if not ad then return end

local ae,af=aa.reload(ab.commandsList,ad)
if ae then
ab:notify("Plugins",`Reloaded '{ad}' ({af} command(s))`)
else
ab:notify("Plugin Error",af)
end
end
},
{
action="addallplugins|loadallplugins",
description="Adds all plugins from the infiniteYield/plugins folder",
run=function(ab)
local ac,ad=aa.addAll(ab.commandsList)
if not ac then
ab:notify("Plugin Error",ad)
return
end

local ae=`Added {#ac.added} plugin(s)`
if#ac.failed>0 then
ae=ae..`, {#ac.failed} failed (see console)`
for af,ag in ac.failed do
warn(`plugin {ag}`)
end
end

ab:notify("Plugins",ae)
end
}
}end a.cx=function()local ab=a.cache.cx if not ab then ab={c=aa()}a.cache.cx=ab end return ab.c end end do local aa=function()

local aa=a.d()local ab=function(


ab)
local ac={}
local ad={}
local ae={}local af=function(

af)
aa:expect(af.action,{"string"},"command action")
table.insert(ac,af)

local ag={}
local ah=af.args or{}
af.args=ah

for ai,b in af.action:split"|"do
if not af.name then
af.name=b
end

ad[b]=af

table.insert(ag,b)
table.insert(ae,b)
end

table.sort(ag,function(ai,b)
return#ai<#b
end)

if#ah==0 and next(ah)then
af.args={ah}
end

af.aliases=ag
af.action=nil end


for ag,ah in ab do
aa:expect(ah.name,{"string"},"section name")
aa:expect(ah.commands,{"table"},"section commands")

table.insert(ac,{
isSection=true,
sectionName=ah.name
})

for ai,b in ah.commands do
if#b==0 then
aa:assert(next(b),"the command cannot be empty")
af(b)
continue
end

for c=1,#b do
af(b[c])
end
end
end

return{
array=ae,
lookup=ad,
original=ac
}end


return ab{
{
name="general",
commands=a.ag()
},
{
name="interface",
commands=a.az()
},
{
name="character",
commands=a.a9()
},
{
name="waypoints",
commands=a.bd()
},
{
name="teleport",
commands=a.bx()
},
{
name="communication",
commands=a.bO()
},
{
name="visual",
commands=a.bU()
},
{
name="camera",
commands=a.ca()
},
{
name="workspace",
commands=a.cl()
},
{
name="lighting",
commands=a.ct()
},
{
name="aliases",
commands=a.cv()
},
{
name="plugins",
commands=a.cx()
}
}end a.cy=function()local ab=a.cache.cy if not ab then ab={c=aa()}a.cache.cy=ab end return ab.c end end do local aa=function()

































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































local aa={}
local ab={}

aa.__index=aa
ab.__index=ab

aa.Disconnect=function(ac)
if not ac._isConnected then return end

local ad=ac.Parent and ac.Parent.Connections
local ae=ad and table.find(ad,ac)

if ae then
table.remove(ad,ae)
end

ac._connectedFunc=nil
ac._isConnected=false end


aa.Fire=function(ac, ...)
if ac._connectedFunc~=nil then
task.spawn(ac._connectedFunc,...)
end end


aa.new=function(ac, ad)
local ae=setmetatable({
_isConnected=true,
_connectedFunc=ad,
Parent=ac
},aa)

table.insert(ac.Connections,ae)
return ae end


ab.Connect=function(ac, ad)
assert(type(ad)=="function",`function expected, got {type(ad)}`)

return aa.new(ac,ad)end


ab.Once=function(ac, ad)
local ae

ae=ac:Connect(function(...)
ae:Disconnect()
task.spawn(ad,...)
end)

return ae end


ab.Wait=function(ac)
local ad,ae=(coroutine.running())

ae=ac:Connect(function(...)
ae:Disconnect()
task.spawn(ad,...)
end)

return coroutine.yield()end


ab.Fire=function(ac, ...)
for ad,ae in ipairs(ac.Connections)do
ae:Fire(...)
end end


ab.new=function()
return setmetatable({
Connections={}
},ab)end


return ab end a.cz=function()local ab=a.cache.cz if not ab then ab={c=aa()}a.cache.cz=ab end return ab.c end end do local aa=function()
local aa={}


aa.searchAtArray=function(ab, 
ac, 
ad, 
ae)

if ad==""then return{}end

local af=ad:lower()
local ag={}
local ah={}

for ai,b in ac do
local c=tostring(b):lower()

if#c<#af then continue end

local d=c:find(af,1,true)

if d==1 then
table.insert(ag,b)
elseif d and not ae then
table.insert(ah,b)
end
end

for ai,b in ah do
table.insert(ag,b)
end

return ag end


return aa end a.cA=function()local ab=a.cache.cA if not ab then ab={c=aa()}a.cache.cA=ab end return ab.c end end do local aa=function()

local aa=a.an()
local ab=a.d()

local ac=aa.owner
local ad=aa.repository

local ae=`https://raw.githubusercontent.com/{ac}/{ad}/refs/heads/main/`
local af=`https://github.com/{ac}/{ad}/releases/latest/download/`

local ag={}local ah=function(

ah)
return game:HttpGet(ah)end local ai=function(


ai)
if ai:sub(1,1)=="/"then
return ai:sub(2)
end

return ai end local b=function(


b, c)
local d=b..ai(c)
local e,f=pcall(ah,d)

if not e then
ab:warn(`failed to fetch http url '{d}':\n\t{f}`)
return nil
end

if type(f)~="string"or#f==0 then
ab:warn(`empty response from '{d}'`)
return nil
end

return f end


ag.download=function(c)
return b(af,c)end



ag.downloadUrl=function(c)
return af..ai(c)end


ag.fetch=function(c)
return b(ae,c)end


ag.load=function(c, d)
local e=ag.fetch(c)
if e==nil then return nil end

local f,g=loadstring(e,d)
if f==nil then
ab:warn(`failed to compile '{c}':\n\t{g}`)
return nil
end

return f end


return ag end a.cB=function()local ab=a.cache.cB if not ab then ab={c=aa()}a.cache.cB=ab end return ab.c end end do local aa=function()
local aa=a.P()
local ab=aa.CoreGui

local ac={}
ac.__index=ac

ac.destroy=function(ad)
ad.message:destroy()
setmetatable(ad,nil)end


ac.set=function(ad, ae)
if ae and#ae>0 then
ad.message.Text=ae
ad.message.Parent=ab
else
ad.message.Parent=nil
end end


ac.new=function()
return setmetatable({
message=Instance.new"Message"
},ac)end


return ac end a.cC=function()local ab=a.cache.cC if not ab then ab={c=aa()}a.cache.cC=ab end return ab.c end end do local aa=function()
return{
isEnabled=true,
animationScale=1,
scrollSpeed=1
}end a.cD=function()local ab=a.cache.cD if not ab then ab={c=aa()}a.cache.cD=ab end return ab.c end end do local aa=function()
local aa=a.cD()

local ab={}

ab.getScale=function(ac, ad)
return aa.isEnabled and(ad*aa.animationScale)or 0 end


ab.getScrollSpeed=function(ac, ad)
return(ad*aa.scrollSpeed)end


return ab end a.cE=function()local ab=a.cache.cE if not ab then ab={c=aa()}a.cache.cE=ab end return ab.c end end do local aa=function()
return{
createService=a.bW(),
specialProps=a.bV(),

connectionService=a.au(),
fetchService=a.cB(),
keyboardService=a.ax(),
localPlayer=a.Q(),
messageService=a.cC(),
playerService=a.R(),
rbxServices=a.P(),
tweenService=a.cE(),
}end a.cF=function()local ab=a.cache.cF if not ab then ab={c=aa()}a.cache.cF=ab end return ab.c end end do local aa=function()

return{
DisplayName="Classic",

Font={
Normal=Enum.Font.BuilderSans,
Medium=Enum.Font.BuilderSansMedium,
Bold=Enum.Font.BuilderSansBold,
ExtraBold=Enum.Font.BuilderSansExtraBold,
MonoSpace=Enum.Font.RobotoMono,
},

Colors={
Background=Color3.fromRGB(36,36,37),
Primary=Color3.fromRGB(88,101,242),
OnPrimary=Color3.fromRGB(61,67,135),
Stroke=Color3.fromRGB(45,45,45),

Error=Color3.fromRGB(255,102,102),
Icons=Color3.fromRGB(232,233,235),

ScrollBar={
Thumb=Color3.fromRGB(78,78,79),
Arrow=Color3.fromRGB(232,233,235),
Background=Color3.fromRGB(26,26,26),
},

Buttons={
Holding=Color3.fromRGB(78,78,79),
Default=Color3.fromRGB(46,46,47),
},

Border={
Holding=Color3.fromRGB(60,60,60),
Default=Color3.fromRGB(38,38,38),
},

Text={
Default=Color3.new(1,1,1),
Dark=Color3.fromRGB(200,200,200),
Darker=Color3.fromRGB(175,175,175),
},

Slider={
SliderBar=Color3.fromRGB(1,76,105),
SliderNumber=Color3.fromRGB(232,233,235),
},
},
}end a.cG=function()local ab=a.cache.cG if not ab then ab={c=aa()}a.cache.cG=ab end return ab.c end end do local aa=function()

return{
DisplayName="Dark",

Font={
Normal=Enum.Font.BuilderSans,
Medium=Enum.Font.BuilderSansMedium,
Bold=Enum.Font.BuilderSansBold,
ExtraBold=Enum.Font.BuilderSansExtraBold,
MonoSpace=Enum.Font.RobotoMono
},
Colors={
Background=Color3.fromRGB(19,19,19),
Primary=Color3.fromRGB(88,101,242),
OnPrimary=Color3.fromRGB(61,67,135),
Stroke=Color3.fromRGB(45,45,45),

Error=Color3.fromRGB(255,102,102),
Icons=Color3.fromRGB(232,233,235),

ScrollBar={
Thumb=Color3.fromRGB(60,60,60),
Arrow=Color3.fromRGB(232,233,235),
Background=Color3.fromRGB(26,26,26)
},
Buttons={
Holding=Color3.fromRGB(42,42,42),
Default=Color3.fromRGB(34,34,34)
},
Border={
Holding=Color3.fromRGB(60,60,60),
Default=Color3.fromRGB(38,38,38),
},
Text={
Default=Color3.fromRGB(255,255,255),
Dark=Color3.fromRGB(200,200,200),
Darker=Color3.fromRGB(175,175,175),
},
Slider={
SliderBar=Color3.fromRGB(1,76,105),
SliderNumber=Color3.fromRGB(232,233,235),
},
}
}end a.cH=function()local ab=a.cache.cH if not ab then ab={c=aa()}a.cache.cH=ab end return ab.c end end do local aa=function()
return{
DisplayName="Light"
}end a.cI=function()local ab=a.cache.cI if not ab then ab={c=aa()}a.cache.cI=ab end return ab.c end end do local aa=function()
local aa={a.cG()
,a.cH()
,a.cI()

}

local ab={}

for ac,ad in aa do
local ae=string.lower(ad.DisplayName)
ab[ae]=ad
end

return ab end a.cJ=function()local ab=a.cache.cJ if not ab then ab={c=aa()}a.cache.cJ=ab end return ab.c end end do local aa=function()
local aa={}

local ab="abcdefghijklmnopqrstuvABCDEFGHIJKLMNOPQRSTUV_0123456789"

local ac={
["&"]="&amp;",
["<"]="&lt;",
[">"]="&gt;",
["\""]="&quot;",
["'"]="&apos;"
}

aa.randomString=function(ad)
local ae={}
for af=1,ad do
local ag=math.random(1,#ab)
table.insert(ae,ab:sub(ag,ag))
end
return table.concat(ae)end


aa.getDeep=function(ad, ae)
for af in ae:gmatch"[^%.]+"do
ad=ad[af]
end
return ad end


aa.simpleCreate=function(ad, ae)
local af=Instance.new(ad)
for ag,ah in ae do
af[ag]=ah
end
return af end


aa.chararray=function(ad)
local ae={}
for af=1,#ad do
table.insert(ae,ad:sub(af,af))
end
return ae end


aa.lookupify=function(ad)
local ae={}
for af=1,#ad do
local ag=ad[af]
ae[ag]=true
end
return ae end


aa.unlookupify=function(ad)
local ae={}
for af,ag in ad do
table.insert(ae,af)
end
return ae end


aa.escapeRichText=function(ad)
local ae=tostring(ad):gsub(".",function(ae)
return ac[ae]or ae
end)
return ae end


aa.charset=function(ad)
local ae={}
for af in ad:gmatch"."do
ae[af]=true
end
return ae end


aa.versionToNumber=function(ad)
local ae=ad:gsub("^v","")

local af=0
local ag=ae:split"."

for ah,ai in ag do
local b=tonumber(ai)or 0
af=af+b*math.pow(1000,3-ah)
end

return af end


aa.colorFromRGB=function(ad, ae)
return`<font color="#{ae:ToHex()}">{ad}</font>`end


aa.richFontSize=function(ad, ae)
return`<font size="{ae}">{ad}</font>`end


return aa end a.cK=function()local ab=a.cache.cK if not ab then ab={c=aa()}a.cache.cK=ab end return ab.c end end do local aa=function()
local aa=a.cJ()

local ab=a.d()
local ac=a.cK()

local ad={
objects={},
selectedTheme=nil
}


ad.isUsable=function(ae, af)
return af~=nil and af.Colors~=nil and af.Font~=nil end



ad.getThemes=function(ae)
local af={}

for ag,ah in aa do
table.insert(af,{
key=ag,
name=ah.DisplayName,
theme=ah,
usable=ae:isUsable(ah),
})
end

table.sort(af,function(ag,ah)
return ag.name<ah.name
end)

return af end


ad.selectTheme=function(ae, af)
ab:expect(af,{"string"},"'themeService:selectTheme' #1")

local ag=aa[af:lower()]

if not ag then
ab:error(`'{af}' isn't a valid theme`)
return
end

if ag~=ae.selectedTheme then
ae.selectedTheme=ag
ae:updateObjects()
end

return ae end


ad.updateObject=function(ae, af)

ae:updateObjectProperties(af,ae.objects[af])end


ad.updateObjectProperties=function(ae, 
af, 
ag)

for ah,ai in ag do
af[ah]=ac.getDeep(ae.selectedTheme,ai)
end end


ad.updateObjects=function(ae)
for af,ag in ae.objects do
ae:updateObject(af)
end end


ad.addObject=function(ae, af, ag)
ae.objects[af]=ag
ae:updateObject(af)end




ad.removeObject=function(ae, af)
ae.objects[af]=nil end


ad.init=function(ae, af)
ab:expect(af,{"table"},"'themeService:init' #1")

if af.theme~=nil then
ae:selectTheme(af.theme)
end end


return ad end a.cL=function()local ab=a.cache.cL if not ab then ab={c=aa()}a.cache.cL=ab end return ab.c end end do local aa=function()


local aa=a.cF()
local ab=a.d()

local ac=aa.specialProps
local ad=a.cL()

ac.ThemeTag=function(ae, af)
if type(af)~="table"then
ab:error"expected a 'table' when setting a theme tag"
return
end

ad:addObject(ae,af)end


return a.bW()end a.cM=function()local ab=a.cache.cM if not ab then ab={c=aa()}a.cache.cM=ab end return ab.c end end do local aa=function()return{logo=104371861083126,close=83276213460768,minimize=76683704146139,["lucide-chevron-left"]=116084397950605,["lucide-blocks"]=80329404661557,["lucide-terminal"]=138735373900955,["lucide-pin"]=85638424763987,["lucide-refresh-cw"]=127184558868486,["lucide-eraser"]=121383006814792,["lucide-tag"]=95367077436662,
["lucide-keyboard"]=102097005397654,
["lucide-palette"]=105784737972091,
["lucide-map-pin"]=132787420207871,
["lucide-puzzle"]=139412930697283,
["lucide-zap"]=124181719324437,imgstudiopluginlogo=

4113050383,pin=
6234691350,reference=


116342494079103,settings=
102340652201372,
}end a.cN=function()local ab=a.cache.cN if not ab then ab={c=aa()}a.cache.cN=ab end return ab.c end end do local aa=function()



local aa=a.a()
local ab=a.ap()

local ac=ab.storage.imagePath

local ad=a.ak()
local ae=a.cB()
local af=a.d()

local ag=a.cN()

local ah={}
local ai={}

local b=aa.getcustomasset

local c={}

c.newCustomAsset=function(d, e, f)
af:assert(not ah[e],"asset is already loaded")

local g=ad:getCustomAsset(f)

if g==nil then
g=ag[e]
ah[e]=g
return g
end

af:log(`new custom asset to '{f}': '{g}'`)
return g end


c.get=function(d, e)

if ah[e]then
return ah[e]
end

if type(b)~="function"then
return ag[e]
end

local f=ac:format(e)
af:log(`loading asset: '{f}'`)

if ad:exist(f)then
return d:newCustomAsset(e,f)
end

local g=ae.fetch(f)

if g==nil then
local h=ag[e]
h=if type(h)=="number"then`rbxassetid://{h}`else h

ah[e]=h
return h
end

ad:writeFile(f,g)
af:log(`created a file to asset: '{f}'`)

return d:newCustomAsset(e,f)end


c.loadImage=function(d, e, f)
af:assert(ag[f],`invalid asset name: {f}`)

local g=ah[f]
if g~=nil then
e.Image=g
return
end

e.Image=""

if ai[f]then
table.insert(ai[f],e)
return
end

ai[f]={e}

task.defer(function()
local h=d:get(f)
if not h then return end

for i,j in ai[f]do
j.Image=h
end

ai[f]=nil
end)end


return c end a.cO=function()local ab=a.cache.cO if not ab then ab={c=aa()}a.cache.cO=ab end return ab.c end end do local aa=function()
return{
uiScale=Instance.new"UIScale",
getScale=function(aa)
local ab=aa.uiScale
return ab and(ab:GetAttribute"REAL_SCALE"or ab.Scale)or 1
end,
setScale=function(aa,ab)
local ac=aa.uiScale

if ac then
ac.Scale=ab
ac:SetAttribute("REAL_SCALE",ab)
end
end
}end a.cP=function()local ab=a.cache.cP if not ab then ab={c=aa()}a.cache.cP=ab end return ab.c end end do local aa=function()



return{

defaultTime=5,
defaultTitle="Notification",



size=UDim2.fromOffset(250,100),
maxHeight=240,
cornerRadius=6,
titleHeight=20,
iconSize=11,


titleTextSize=14,
textSize=14,
padding=8,


spacing=4,
gapToWindow=0,
maxVisible=5,


actionHeight=22,
actionMinWidth=56,
actionPadding=12,
actionGap=4,
actionsTopGap=4,


tweenTime=0.5,
flashTime=0.5,
}end a.cQ=function()local ab=a.cache.cQ if not ab then ab={c=aa()}a.cache.cQ=ab end return ab.c end end do local aa=function()

local aa=Color3.fromRGB(248,109,115)
local ab=Color3.fromRGB(223,215,136)
local ac=Color3.fromRGB(156,121,223)
local ad=Color3.fromRGB(225,37,105)
local ae=Color3.fromRGB(118,113,94)
local af=Color3.fromRGB(97,181,195)
local ag=Color3.fromRGB(254,193,7)
local ah=Color3.fromRGB(244,66,54)
local ai=Color3.fromRGB(166,227,45)
local b=Color3.fromRGB(255,149,75)

return{
args={number=
ac,boolean=
ac,text=
ab,string=
ab,symbol=
ad,comment=
ae,others=
af,warn=
ag,error=
ah,valid=
ai,tag=
b,
},
commands={undefined=
ah,client=
ab,deprecated=
ae
}
}end a.cR=function()local ab=a.cache.cR if not ab then ab={c=aa()}a.cache.cR=ab end return ab.c end end do local aa=function()








local aa=a.cR().args
local ab=a.cK()

local ac={}


local ad=ab.charset":#()[]<>{}-––&*$%@"


local ae="^[%w_%.]+"


local af="^[%w_]+"local ag=function(

ag)
return ag~=""and string.match(ag,"[%w_%.]")~=nil end local ah=function(


ah)
return string.match(ah,"^%d+$")~=nil or string.match(ah,"^%d+%.%d+$")~=nil end local ai=function(




ai, b)
local c=string.sub(ai,b,b)
local d=b+1

while d<=#ai do
local e=string.sub(ai,d,d)

if e=="\\"then
d=d+2
elseif e==c then
return d
else
d=d+1
end
end

return nil end local b=function(



b)
local c={}local d=function(

d, e, f)
if d==""then
return
end

local g=c[#c]
if g and g.color==e and g.bold==f then
g.text=g.text..d
else
table.insert(c,{text=d,color=e,bold=f})
end end


local e=1
local f=#b

while e<=f do
local g=string.sub(b,e,e)
local h=if e>1 then string.sub(b,e-1,e-1)else""


if(g=="@"or g=="#")and not ag(h)then
local i,j=string.find(b,af,e+1)
if j then
d(string.sub(b,e,j),aa.tag,true)
e=j+1
continue
end
end


if(g=='"'or g=="'")and not ag(h)then
local i=ai(b,e)

if i then
d(string.sub(b,e,i),aa.string,false)
e=i+1
continue
end
end

if ag(g)then
local i,j=string.find(b,ae,e)
local k=string.sub(b,e,j)
d(k,if ah(k)then aa.number else nil,false)
e=j+1
else
d(g,if ad[g]then aa.symbol else nil,false)
e=e+1
end
end

return c end


ac.apply=function(c, d)
local e={}

for f,g in b(tostring(d))do
local h=ab.escapeRichText(g.text)

if g.color then
h=ab.colorFromRGB(h,g.color)
end
if g.bold then
h=`<b>{h}</b>`
end

table.insert(e,h)
end

return table.concat(e)end


return ac end a.cS=function()local ab=a.cache.cS if not ab then ab={c=aa()}a.cache.cS=ab end return ab.c end end do local aa=function()



local aa=a.cM()
local ab=a.cO()
local ac=a.cL()
local ad=a.cP()

local ae=a.au()
local af=a.P()
local ag=a.cQ()

local ah=a.cS()

local ai=4
local b=8



local c=5
local d=5
local e=ag.titleHeight+c+d*2

local f={
container=nil,

items={},
nextOrder=0,

queue={},


room=math.huge,
}local g=function(

g, h)
local i=aa.new("Frame","Notification",g,{
BorderSizePixel=0,
ClipsDescendants=true,
LayoutOrder=h,
Size=UDim2.fromOffset(ag.size.X.Offset,0),
ThemeTag={
BackgroundColor3="Colors.Background",
},
})

local j=ai+ag.iconSize+b

local k=aa.new("TextLabel","Title",i,{
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
Position=UDim2.fromScale(0.5,0),
Size=UDim2.new(1,-j*2,0,ag.titleHeight),
Text="",
TextSize=ag.titleTextSize,
TextTruncate=Enum.TextTruncate.AtEnd,
ThemeTag={
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},
})

local l=aa.new("Frame","Description",i,{
AnchorPoint=Vector2.new(0.5,1),
ClipsDescendants=true,
Position=UDim2.new(0.5,0,1,-c),
Size=UDim2.new(1,-10,1,-(ag.titleHeight+c)),
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
},
})

aa.new("UICorner",l,{
CornerRadius=UDim.new(0,ag.cornerRadius),
})


local m=aa.new("TextLabel","Text",l,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Position=UDim2.fromOffset(d,d),
Size=UDim2.new(1,-d*2,0,0),
Text="",
TextSize=ag.textSize,
RichText=true,
TextWrapped=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
ThemeTag={
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},
})

local n=aa.new("ImageButton","PinButton",i,{
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
Position=UDim2.new(0,ai,0,ag.titleHeight/2),
Size=UDim2.fromOffset(ag.iconSize,ag.iconSize),
ThemeTag={
ImageColor3="Colors.Icons",
},
})

local o=aa.new("ImageButton","CloseButton",i,{
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Position=UDim2.new(1,-ai,0,ag.titleHeight/2),
Size=UDim2.fromOffset(ag.iconSize,ag.iconSize),
ThemeTag={
ImageColor3="Colors.Icons",
},
})

ab:loadImage(n,"pin")
ab:loadImage(o,"close")

return i,k,m,n,o,l end local h=function(




h, i, j)
local k=aa.new("Frame","Actions",h,{
AnchorPoint=Vector2.new(0.5,1),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,1,-d),
Size=UDim2.new(1,-d*2,0,ag.actionHeight),
ZIndex=2,

aa.new("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Right,
Padding=UDim.new(0,ag.actionGap),
SortOrder=Enum.SortOrder.LayoutOrder,
VerticalAlignment=Enum.VerticalAlignment.Center,
}),
})

local l={}

for m,n in i do
local o=n.primary==true

local p=aa.new("TextButton","Action",k,{
AutoButtonColor=false,
AutomaticSize=Enum.AutomaticSize.X,
BorderSizePixel=0,
LayoutOrder=m,
Size=UDim2.fromOffset(0,ag.actionHeight),
Text=n.text,
TextSize=ag.textSize,
ZIndex=2,
ThemeTag={
BackgroundColor3=if n.primary then"Colors.Primary"else"Colors.Background",
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ag.cornerRadius),
}),
aa.new("UIPadding",{
PaddingLeft=UDim.new(0,ag.actionPadding),
PaddingRight=UDim.new(0,ag.actionPadding),
}),
aa.new("UISizeConstraint",{
MinSize=Vector2.new(ag.actionMinWidth,0),
}),
})local q=function(


q)
if o then
p.BackgroundTransparency=if q then 0.2 else 0
else
ac:updateObjectProperties(p,{
BackgroundColor3=if q then"Colors.Buttons.Holding"else"Colors.Background",
})
end end


table.insert(j,ae:Connect(p.MouseEnter,function()
q(true)
end))
table.insert(j,ae:Connect(p.MouseLeave,function()
q(false)
end))

l[m]=p
end

return l end local i=function(


i)
for j,k in i.connections do
ae:disconnect(k)
end

table.clear(i.connections)end


f.getContainer=function(j, k)
if j.container then
return j.container
end

local l=aa.new("Frame","Notifications",k,{
BackgroundTransparency=1,
BorderSizePixel=0,
Size=UDim2.fromOffset(ag.size.X.Offset,0),
})

aa.new("UIListLayout",l,{
Padding=UDim.new(0,ag.spacing),
SortOrder=Enum.SortOrder.LayoutOrder,
})

j.container=l


l.ChildAdded:Connect(function()
j:refreshLayout()
end)

l.ChildRemoved:Connect(function()
j:refreshLayout()
end)

local m=j.queue
j.queue={}

for n,o in m do
j:add(o.title,o.message,o.duration,o.choices)
end

return l end



f.getStackHeight=function(j)
local k=j.container
if not k then return 0 end

local l=0
local m=0

for n,o in k:GetChildren()do
if o:IsA"GuiObject"then
l=l+1
m=m+o.Size.Y.Offset
end
end

if l>1 then
m=m+(l-1)*ag.spacing
end

return m end



f.refreshLayout=function(j)
local k=j.container
if not k then return end

k.Size=UDim2.fromOffset(ag.size.X.Offset,j:getStackHeight())

if j.onLayoutChanged then
j.onLayoutChanged()
end end


f.tweenHeight=function(j, k, l)
if k.tween then
k.tween:Cancel()
end

local m=TweenInfo.new(ag.tweenTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut)
k.tween=af.TweenService:Create(k.frame,m,{
Size=UDim2.fromOffset(ag.size.X.Offset,l),
})
k.tween:Play()end




f.wantedHeight=function(j, k)
local l=math.max(ad:getScale(),0.01)
local m=k.textLabel.AbsoluteSize.Y/l


local n=if k.actionsHeight>0 then 0 else ag.size.Y.Offset
local o=math.max(m+e+k.actionsHeight,n)
return math.min(o,ag.maxHeight,j.room)end



f.fitHeight=function(j, k, l)
if k.removed or not k.textLabel then return end

local m=j:wantedHeight(k)
if m==k.height then return end
k.height=m

if l then
if k.tween then
k.tween:Cancel()
end

k.frame.Size=UDim2.fromOffset(ag.size.X.Offset,m)
else
j:tweenHeight(k,m)
end end




f.setRoom=function(j, k)
if k==j.room then return end
j.room=k

for l,m in j.items do
j:fitHeight(m,true)
end

j:trimToRoom()end



f.liveHeight=function(j)
local k=0

for l,m in j.items do
k=k+m.height
end

if#j.items>1 then
k=k+(#j.items-1)*ag.spacing
end

return k end



f.trimToRoom=function(j)
while#j.items>1 and j:liveHeight()>j.room do
local k

for l,m in j.items do
if l==#j.items then break end

if not m.pinned then
k=m
break
end
end

if not k then break end
j:remove(k)
end end


f.pin=function(j, k)
if k.pinned or k.removed then return end
k.pinned=true

k.titleLabel.Text=k.title.." (Pinned)"
ac:addObject(k.pinButton,{ImageColor3="Colors.Primary"})

local l=k.titleLabel
task.spawn(function()
l.TextTransparency=0.5
task.wait(ag.flashTime)
l.TextTransparency=0
end)end


f.remove=function(j, k)
if k.removed then return end
k.removed=true

local l=table.find(j.items,k)
if l then
table.remove(j.items,l)
end

i(k)

j:tweenHeight(k,0)
task.delay(ag.tweenTime,function()
k.frame:Destroy()
end)end


f.trim=function(j)
while#j.items>ag.maxVisible do
local k

for l,m in j.items do
if not m.pinned then
k=m
break
end
end

if not k then break end
j:remove(k)
end end


f.add=function(j, k, l, m, n)
j.nextOrder=j.nextOrder+1

local o={
title=k,
pinned=false,
removed=false,
connections={},
height=ag.size.Y.Offset,
actionsHeight=if n then ag.actionHeight+ag.actionsTopGap+d else 0,
}

local p
o.frame,o.titleLabel,o.textLabel,o.pinButton,o.closeButton,p=
g(j.container,j.nextOrder)

o.titleLabel.Text=k
o.textLabel.Text=ah:apply(l)

table.insert(o.connections,ae:Connect(o.pinButton.Activated,function()
j:pin(o)
end))



local q=n~=nil and type(m)~="number"

if q then
o.pinned=true
o.pinButton.Visible=false
end

if n then
local r=h(p,n,o.connections)

for s,t in r do
local u=n[s]

table.insert(o.connections,ae:Connect(t.Activated,function()
if o.removed then return end

j:remove(o)

if u.onTap then
u.onTap()
end
end))
end
end

table.insert(o.connections,ae:Connect(o.closeButton.Activated,function()
j:remove(o)
end))


table.insert(o.connections,ae:Connect(o.textLabel:GetPropertyChangedSignal"AbsoluteSize",function()
j:fitHeight(o)
end))

table.insert(j.items,o)
j:tweenHeight(o,o.height)


o.frame:GetPropertyChangedSignal"Size":Connect(function()
j:refreshLayout()
end)
j:refreshLayout()

if not q then
local r=if type(m)=="number"then m else ag.defaultTime
task.delay(r,function()
if not o.pinned then
j:remove(o)
end
end)
end

j:trim()
j:trimToRoom()end


f.notify=function(j, k, l, m)
if l==nil then
l=k
k=ag.defaultTitle
end

k=tostring(k)

if not j.container then
table.insert(j.queue,{title=k,message=l,duration=m})
return
end

j:add(k,l,m)end






f.ask=function(j, k, l, m, n)
k=tostring(k)

if not j.container then
table.insert(j.queue,{title=k,message=l,choices=m,duration=n})
return
end

j:add(k,l,n,m)end


f.destroy=function(j)
for k,l in j.items do
i(l)
end

table.clear(j.items)
table.clear(j.queue)
j.container=nil end


return f end a.cT=function()local ab=a.cache.cT if not ab then ab={c=aa()}a.cache.cT=ab end return ab.c end end do local aa=function()



local aa=a.b()
local ab=a.d()

local ac={

_callbacks={},
_nextId=0,
}local ad=function(


ad)
while true do
task.wait()

if next(ad._callbacks)==nil then
aa.loopThread=nil
return
end

local ae=os.clock()

for af,ag in ad._callbacks do
if ae-ag.lastCall>=ag.cooldown then
ag.lastCall=ae
task.defer(ag.func)
end
end
end end



ac.start=function(ae)
if aa.loopThread~=nil then
return
end

aa.loopThread=task.defer(ad,ae)end



ac.stop=function(ae)
local af=aa.loopThread
aa.loopThread=nil
table.clear(ae._callbacks)

if af~=nil then
task.cancel(af)
end end




ac.add=function(ae, af, ag)
ab:expect(af,{"function"},"'loopService:add' #1")
ab:expect(ag,{"number","nil"},"'loopService:add' #2")

ae._nextId=ae._nextId+1
local ah=ae._nextId

ae._callbacks[ah]={
func=af,
cooldown=math.max(ag or 0,0),
lastCall=-math.huge
}

ae:start()
return ah end



ac.remove=function(ae, af)
ab:expect(af,{"number"},"'loopService:remove' #1")
ae._callbacks[af]=nil end


return ac end a.cU=function()local ab=a.cache.cU if not ab then ab={c=aa()}a.cache.cU=ab end return ab.c end end do local aa=function()
local aa=a.b()
local ab=a.a()

local ac=a.cy()
local ad=a.cz()
local ae=a.d()

local af=a.bD().usedCmds
local ag=a.aj()
local ah=a.P()
local ai=a.ap()

local b=a.cA()
local c=a.F()
local d=a.cu()
local e=a.cw()

local f=ai.commands.cmdsRank
local g=f.maxTimesUsed
local h=f.decreasePerUse
local i=f.increasePerUse

local j=aa.iyGarbages or{}
aa.iyGarbages=j

local k={
garbages=j
}

k.registerGarbage=function(l, m)
return l:getGarbage(m)or l:createGarbage(m)end


k.createGarbage=function(l, m)
local n=l.garbages[m]
if n==nil then
n={}
l.garbages[m]=n
end

return n end


k.getCommandData=function(l, m)
return ac.lookup[m:lower()]end


k.hasGarbage=function(l, m)
return l.garbages[m]~=nil end


k.getGarbage=function(l, m)
return l.garbages[m]end


k.collectGarbage=function(l, m)
local n=l.garbages[m]

if n~=nil then
l.garbages[m]=nil
return n
end end


k.commandUsed=function(l, m)
local n=af:getValue(m)or 0

local o=math.clamp(n+i,0,g)
af:setValue(m,o)

for p,q in af:getData()do
if p==m then continue end

local r=(o==g)

if(r or q<o)and q>0 then
q=q-h

if q==0 then q=nil end
af:setValue(p,q)
end
end

af:save()end local l=function(



l)
local m={}
if l and l.args then
for n,o in l.args do
m[n]={value=o.value}
end
end
return m end





local m=setmetatable({},{__mode="k"})

local n=`{ag.privateFolder}/error-logs`local o=function(


o, p, q)
local r=ab.writefile
if not r then return nil end

if ab.makefolder then
pcall(ab.makefolder,ag.privateFolder)
pcall(ab.makefolder,n)
end

local s=`{n}/{os.time()}-{o}.txt`
local t=table.concat({
`command: {o}`,
`time: {os.date"%Y-%m-%d %H:%M:%S"}`,
`error: {p}`,
"",
"traceback:",
q or"(not available)",
},"\n")

local u=pcall(r,s,t)
if u then return s end

return nil end



k.reportError=function(p, q, r, s)
local t=tostring(r)
local u=o(q,t,s)

local v=t
if u then
v=v..`\nsaved to {u}`
end

p:notify(`'{q}' failed`,v)end



k.run=function(p, q, r, s)
ae:expect(q,{"string"},"'commandsController:run' #1")
ae:expect(r,{"table","nil"},"'commandsController:run' #2")

local t=ac.lookup[q]
ae:assert(t,"invalid command")


r=r or c.new{}

local u=coroutine.running()
local v=m[u]
local w=v~=nil
local x=w and not s

if not x then
p:commandUsed(t.name)


local y=l(r)
p.privateEnv.lastArgs=p.privateEnv.lastArgs or{}
p.privateEnv.lastArgs[t.name]=y

if t.name~="lastcommand"then
p.privateEnv.lastCommand={
name=t.name,
args=y
}
end
end

if t.run==nil then
ae:warn(`missing command run func: {t.name}`)
return
end

if not w then
v={reported=false}
m[u]=v
end

local y
local z,A=xpcall(function()
t.run(p,r)
end,function(z)

y=debug.traceback(tostring(z),2)
return z
end)

if not w then
m[u]=nil
end

if not z then


if not v.reported then
v.reported=true
p:reportError(t.name,A,y)
end

error(A,0)
end end



k.getLastArgs=function(p, q)
local r=p.privateEnv.lastArgs
return r and r[q]end local p=function(


p)
local q=ac.lookup[p:lower()]
if q==nil then return 0 end


return af:getValue(q.name)or 0 end


k.search=function(q, r, s)
local t=b:searchAtArray(ac.array,r,s)
local u=r:lower()
local v={}

for w,x in t do
table.insert(v,{
alias=x,
index=w,
isPrefix=x:lower():sub(1,#u)==u,
usage=p(x),
})
end

table.sort(v,function(w,x)
if w.isPrefix~=x.isPrefix then return w.isPrefix end
if w.usage~=x.usage then return w.usage>x.usage end
return w.index<x.index
end)

local w={}
for x,y in v do
w[x]=y.alias
end

return w end


k.init=function(q, r)
ae:assert(r,"'commandsController:init' #1 expected a config to init")

local s=a.au()
local t=a.bb()
local u=a.cT()


q.notify=function(v, ...)
return u:notify(...)end



q.ask=function(v, ...)
return u:ask(...)end


q.stringify=function(v, ...)
return t:stringify(...)end


q.unstringify=function(v, ...)
return t:unstringify(...)end


q.connect=function(v, ...)
return s:Connect(...)end


q.expectExploit=function(v, w)
local x=ab[w]
if x~=nil then return x end

v:notify("Incompatible Exploit",`Your exploit does not support this command (missing {w})`)end


q.getRoot=function(v)
local w=v.playerService:getRootPart()
if w then return w end

v:notify("Character","your character is not loaded")end


q.getRootPart=q.getRoot
q.Connect=q.connect


local v=a.bX()
q.isMobile=v
q.isPC=not v


q.localPlayer=a.Q()
q.executorEnv=ab
q.privateEnv=aa


q.infiniteYield=r.infiniteYield
q.playerService=r.playerService
q.fetchService=r.fetchService


q.signals={
onCameraReset=ad.new()
}


q.config={
links=ai.links
}


q.userSettings=UserSettings()
q.gameSettings=settings()

q.userGameSettings=q.userSettings:GetService"UserGameSettings"
q.gameNetworkSettings=q.gameSettings:GetService"NetworkSettings"


q.loopService=a.cU()


q.storage=a.bD()


q.robloxServices=ah
q.rbxServices=ah

q.teleportService=ah.TeleportService
q.groupService=ah.GroupService
q.runService=ah.RunService
q.starterGui=ah.StarterGui
q.coreGui=ah.CoreGui
q.players=ah.Players
q.guiService=ah.GuiService
q.networkClient=ah.NetworkClient
q.proximityPromptService=ah.ProximityPromptService
q.commandsList=ac


d.restore(ac)


for w,x in e.restore(ac)do
ae:warn(`plugin '{w}' could not be loaded: {x}`)
end end


return k end a.cV=function()local ab=a.cache.cV if not ab then ab={c=aa()}a.cache.cV=ab end return ab.c end end do local aa=function()


return{

settingKey="interface.keepIY",


bundleName="compiled.luau",


localBundlePath="iy-remake/compiled.luau",
}end a.cW=function()local ab=a.cache.cW if not ab then ab={c=aa()}a.cache.cW=ab end return ab.c end end do local aa=function()



local aa=a.a()
local ab=a.au()
local ac=a.P()
local ad=a.cB()
local ae=a.cW()
local af=a.al()
local ag=a.d()

local ah={}

local ai=false
local b=false local c=function()


return af:getValue(ae.settingKey)==true end local d=function()



local d=ad.downloadUrl(ae.bundleName)

return table.concat({
"local ok, source = pcall(readfile, \""..ae.localBundlePath.."\")",
"if not ok or type(source) ~= \"string\" or source == \"\" then",
"\tsource = game:HttpGet(\""..d.."\")",
"end",
"loadstring(source)()",
},"\n")end local e=function()



if b or not c()then return end

local e=aa.queueteleport
if e==nil then return end

b=true

local f,g=pcall(e,d())
if not f then
b=false
ag:warn("keepiy: failed to queue the loader: "..tostring(g))
end end


ah.start=function()
if ai then return end
ai=true

ab:Connect(ac.Players.LocalPlayer.OnTeleport,e)end


ah.enable=function(f)
if not f:expectExploit"queueteleport"then return end

f.infiniteYield:setKeepIY(true)
f:notify("Keepiy","on: IY runs again after you teleport, and the interface stays open")end


ah.disable=function(f)
f.infiniteYield:setKeepIY(false)
f:notify("Keepiy","off: IY will not run after the next teleport")end


ah.toggle=function(f)
if c()then
ah.disable(f)
else
ah.enable(f)
end end


return ah end a.cX=function()local ab=a.cache.cX if not ab then ab={c=aa()}a.cache.cX=ab end return ab.c end end do local aa=function()











local aa="any"

return{
ANY=aa,

events={
{
name="OnExecute",
description="when IY loads",
conditions={},
},
{
name="OnJoin",
description="a player joins",
conditions={
{kind="Player",label="$1 player",default=aa},
},
},
{
name="OnLeave",
description="a player leaves",
conditions={
{kind="Player",label="$1 player",default=aa},
},
},
{
name="OnSpawn",
description="a character spawns",
conditions={
{kind="Player",label="$1 player",default="me"},
},
},
{
name="OnDied",
description="a character dies",
conditions={
{kind="Player",label="$1 player",default="me"},
},
},
{
name="OnDamage",
description="a character takes damage",
conditions={
{kind="Player",label="$1 player",default="me"},
{kind="Number",label="$2 health at most",default=aa},
},
},
{
name="OnKilled",
description="a player kills another",
conditions={
{kind="Player",label="$1 victim",default="me"},
{kind="Player",label="$2 killer",default=aa},
},
},
{
name="OnChatted",
description="a player chats",
conditions={
{kind="Player",label="$1 player",default=aa},
{kind="String",label="$2 message contains",default=aa},
},
},
},
}end a.cY=function()local ab=a.cache.cY if not ab then ab={c=aa()}a.cache.cY=ab end return ab.c end end do local aa=function()

local aa=a.P()
local ab=a.S()
local ac=a.cy()
local ad=a.ba()
local ae=a.bA()
local af=a.by()
local ag=a.cK()

















local ah={}local ai=function(

ai, b, c)
return{
success=false,
message=ai,
options=b,
comment=c,
}end



ah.normalizeOptions=function(b)
if type(b)=="string"then
return string.split(b,"|")
end
return b or{}end



ah.getOptions=function(b, c)
local d=(c and c.options)or b.options
return ah.normalizeOptions(d)end local b=function(



b, c)
local d=c:lower()

for e,f in b do
local g=tostring(f)
if g:lower()==d then
return g
end
end

return nil end local c=function(


c)
if type(c)~="table"then return{}end
return ag.unlookupify(c)end local d=function(


d)
return{
success=true,
value=d,
color="string",
}end local e=function(


e, f)
local g=ah.normalizeOptions(f.options)

if#g==0 then
return d(e)
end

local h=b(g,e)

if h then
return{success=true,value=h,color="string"}
end

return ai(" - invalid option",g)end


local f={
["true"]=true,yes=
true,enabled=
true,
["false"]=false,no=
false,disabled=
false,
}local g=function(

g)
local h=f[g:lower()]

if h==nil then
return ai(" - invalid boolean",{"false","true"})
end

return{
success=true,
value=h,
color="boolean",
}end local h=function(


h, i)
local j=tonumber(h)

if j==nil or j~=j or math.abs(j)==math.huge then
return ai" - invalid number"
end

local k,l=i.min,i.max

if i.clamp then
k,l=i.clamp[1],i.clamp[2]
end

if k and j<k then
return ai(` - the <b>MIN</b> is <b>{k}</b>`)
end

if l and j>l then
return ai(` - the <b>MAX</b> is <b>{l}</b>`)
end

if i.floor and math.floor(j)~=j then
return ai" - whole numbers only"
end


if tonumber(string.format("%.5f",j))~=j then
return ai" - too many decimal places"
end

return{
success=true,
value=j,
display=`<b>{h}</b>`,
color="number",
}end local i=function(


i)
local j=i:split","

if#j>3 then
return ai" - too many args"
end

local k={}

for l,m in j do

if m:match"^%s*$"then
m="0"
end

local n=h(m,{})

if not n.success then
return n
end

k[l]=n.value
end

if#k~=3 then
return{
success=false,
comment=true,
message=`: {({"X","Y","Z"})[#k+1]}`,
}
end

local l=Vector3.new(k[1],k[2],k[3])

return{
success=true,
value=l,
display=`({l})`,
color="others",
}end local j=function(


j)
local k=j:match"^#?(%x%x%x%x%x%x)$"

if k then
local l=tonumber(k:sub(1,2),16)
local m=tonumber(k:sub(3,4),16)
local n=tonumber(k:sub(5,6),16)

return{
success=true,
value=Color3.fromRGB(l,m,n),
color="others",
}
end

local l=j:split","

if#l~=3 then
return ai" - use R,G,B or #hex"
end

local m={}

for n,o in l do
local p=h(o,{min=0,max=255,floor=true})

if not p.success then
return p
end

m[n]=p.value
end

return{
success=true,
value=Color3.fromRGB(m[1],m[2],m[3]),
color="others",
}end local k=function(


k)
if k==""then
return ai" - player missing"
end

local l=ab.parts(k)

if#l==0 then
return ai" - player missing"
end


for m,n in l do
if#ab(n)==0 then
if ab.hasOperators(n)then
return ai" - no players match this"
end

if ab.isSelector(n)then
return ai" - no players match this selector"
end

local o={}
for p,q in aa.Players:GetPlayers()do
table.insert(o,q.Name)
end

return ai(" - player not found",o)
end
end

return{success=true,value=k,color="valid"}end


local l={
"BasePart","Part","MeshPart","Model","Folder","Script","LocalScript",
"ModuleScript","Sound","Humanoid","Tool","ClickDetector",
"ProximityPrompt","TouchTransmitter","SpawnLocation","Seat","VehicleSeat",
}local m=function(

m)

local n=pcall(function()
local n=Instance.new(m)
n:Destroy()
end)

if n then
return{success=true,value=m,color="valid"}
end

return ai(" - invalid class name",l)end local n=function(


n)

local o=c(ad:getValue(tostring(game.PlaceId)))

if#o==0 then
return ai" - no waypoints created"
end

local p=b(o,n)

if p then
return{success=true,value=p,color="valid"}
end

return ai(" - invalid waypoint",o)end local o=function(


o)
local p={}

for q,r in aa.Teams:GetTeams()do
table.insert(p,r.Name)
end

if#p==0 then
return ai" - there are no teams"
end

local q=b(p,o)

if q then
return{success=true,value=q,color="valid"}
end

return ai(" - invalid team",p)end local p=function(


p)
local q=p:lower()
local r={}
local s

for t,u in Enum.KeyCode:GetEnumItems()do
table.insert(r,u.Name)

if u.Name:lower()==q then
s=u
end
end

if s then
return{success=true,value=s,color="valid"}
end

return ai(" - invalid key",r)end local q=function(


q)
local r=ac.lookup[q:lower()]

if r then
return{success=true,value=r.name,color="valid"}
end

return ai(" - invalid command",ac.array)end local r=function(



r, s, t, u)
local v=c(r:getData())

if#v==0 then
return ai(t)
end

local w=b(v,s)

if w then
return{success=true,value=w,color="valid"}
end

return ai(u,v)end local s=function(


s)
return r(ae,s," - no custom aliases"," - invalid alias")end local t=function(


t)
return r(af,t," - no plugins installed"," - invalid plugin")end


local u={
string=e,
text=e,
object=d,
boolean=g,
number=h,
vector3=i,
color3=j,
player=k,
waypoint=n,
className=m,
team=o,
keycode=p,
command=q,
alias=s,
plugin=t,
}

ah.validate=function(v, w, x)
local y=u[w.kind]

if not y then
return ai(` - missing parser {w.kind}`)
end

return y(x,w)end


return ah end a.cZ=function()local ab=a.cache.cZ if not ab then ab={c=aa()}a.cache.cZ=ab end return ab.c end end do local aa=function()

local aa=a.cV()
local ab=a.cA()

local ac=a.cy()
local ad=a.cR()

local ae=a.cK()
local af=a.cZ()

local ag=ae.colorFromRGB
local ah=ae.escapeRichText


local ai="\\"

local b="^"
local c="inf"

local d="!"

local e=ae.lookupify{"`","'","\""}
local f=ae.lookupify{" ","\t","\n","\r"}
local g=ae.lookupify{",","|","&"}local h=function(

h)
return ac.lookup[h]end local i=function(


i, j, k)
local l=ad.args
return ag(i,l[j]or k or l.others)end local j=function(


j)
local k=j:gsub(".",function(k)
return f[k]and"_"or k
end)
return k end local k=function(


k, l)
if k.name then
return`'{j(k.name)}'`
end
return`#{l}`end local l=function(



l, m, n)
local o=n+1

while true do
local p=l:find(m,o,true)

if not p then
return nil
end

if l:sub(p-1,p-1)~="\\"then
return p
end

o=p+1
end end local m=function(




m, n)
local o={}
local p=n
local q=#m

while p<=q do
local r=m:sub(p,p)

if f[r]or r==ai then
break
end

table.insert(o,r)
p=p+1

if g[r]then
while p<=q and f[m:sub(p,p)]do
p=p+1
end
end
end

return table.concat(o),p-1 end local n=function(


n, o, p, q, r, s)
return{
kind=n,
value=o,
usedChar=s,
from=q,
to=r,
raw=p:sub(q,r),
}end local o=function(



o, p)
if p==""then
return"","",o
end

local q,r=o:lower():find(p:lower(),1,true)

if not q then
return"","",o
end

return o:sub(1,q-1),o:sub(q,r),o:sub(r+1)end local p=function(


p, q)
if q then
return q..p..q
end

if p:find"%s"then
return`"{p}"`
end

return p end local q=function(



q, r)
if r then
return ah(r)..q..ah(r)
end

return q end local r=function(


r, s, t, u)
return{
from=r,
to=s,
text=p(t,u),
}end local s=function(




s)
local t=s:split(b)

if#t>2 then
return nil," - invalid loop"
end

local u
if t[1]:lower()==c then
u=math.huge
else
u=tonumber(t[1])

if u==nil or u<1 or u~=math.floor(u)then
return nil," - invalid loop count"
end
end

local v=0
if t[2]~=nil then
v=tonumber(t[2])

if v==nil or v<0 then
return nil," - invalid loop delay"
end
end

return{count=u,delay=v}end


local t={}
t.__index=t
t.colorFromName=i
t.removeWhiteSpace=j



t.parse=function(u, v)
local w=u.cmdInput
local x={}
local y={}
local z=#v
local A={tokens={},start=1}
local B=1

table.insert(x,A)

while B<=z do
local C=v:sub(B,B)

if f[C]then
B=B+1
elseif C==ai then
A.stop=B
A={tokens={},start=B+1}
table.insert(x,A)
B=B+1
else
local D
local E=e[C]and l(v,C,B)

if E then
local F=(v:sub(B+1,E-1):gsub("\\"..C,C))
D=n("string",F,v,B,E,C)
B=E+1
else
local F,G=m(v,B)
D=n("identifier",F,v,B,G)
B=G+1
end

table.insert(A.tokens,D)
table.insert(y,D)
end
end

A.stop=z+1

for C,D in x do
local E=D.tokens[1]
local F=D.tokens[#D.tokens]
local G=if F then F.to+1 else D.start

D.lead=if E then v:sub(D.start,E.from-1)else""
D.spaces=v:sub(G,D.stop-1)
end

local C={}
for D,E in y do
table.insert(C,E.value)
end

local D=x[#x]

w.rawText=v
w.parsed=y
w.spacesAtEnd=D.spaces
w.noHighlightText=table.concat(C," ")..D.spaces

return x end



t.parseArg=function(u, v, w, x, y)
local z=w.value
local A=af:validate(v,z)
local B=A.success and#z>0

local C={success=B,text=z}
if B then
C.value=A.value
end
y.args[x]=C

if B then

local D=if A.display then q(A.display,w.usedChar)else ah(w.raw)
return{success=true,display=i(D,A.color or"valid")}
end

local D=af.getOptions(v,A)
local E

if#z>0 then
E=ab:searchAtArray(D,z)[1]
end

if E then
local F,G,H=o(E,z)
y.correction=r(w.from,w.to,E,w.usedChar)

local I=ah(F)..i(ah(G),"warn")..ah(H)
return{
success=false,
suggestion=true,
display=i(q(I,w.usedChar),"comment"),
}
end

return{
success=false,
display=i(ah(w.raw),A.color or"warn"),
message=A.message,
comment=A.comment,
}end



t.parsePending=function(u, v, w, x)
local y=af:validate(v,"")
local z=af.getOptions(v,y)

if#z==0 then
return nil
end

local A=z[1]


if not v.optional then
w.correction={from=x.stop,to=x.stop-1,text=p(A)}
else
w.hasGhost=true
end

return i(ah(A),"comment")end



t.highlightArgs=function(u, v, w, x, y, z, A)
local B=x.tokens
local C=w.args
local D=#C
local E=#B-1

local F=1
local G

for H,I in C do
local J=B[H+1]

if J==nil then
if y then
local K=u:parsePending(I,v,x)
if K then
table.insert(z,K)
end
end
break
end

local K=u:parseArg(I,J,H,v)
F=H+1

if K.display then
table.insert(z,K.display)
end

if not K.success then
G={index=H,result=K}
break
end
end


for H=F+1,math.min(#B,D+1)do
table.insert(z,ah(B[H].raw))
end

if#B>D+1 then
local H=u.cmdInput.rawText:sub(B[D+2].from,B[#B].to)
table.insert(z,i(`<b>{ah(H)}</b>`,"warn"))

v.runError=" - extra arg"
v.comment={text=" - extra arg",color="warn"}
return
end

if G then
local H=G.result


v.runError=` - {k(C[G.index],G.index)} is invalid`

if H.message and not H.suggestion then
v.comment={text=H.message,color=if H.comment then"comment"else"warn"}
end
return
end


for H=E+1,D do
local I=C[H]

if not I.optional then
v.runError=` - {k(I,H)} is missing`
break
end
end

local H

if y then
H=E+1
elseif E>0 then
H=E
end

local I=H and C[H]


if I and A then
local J=if y then""else": "
v.comment={text=`{J}({u:highlightArgType(I)})`}
end end


t.highlightArgType=function(u, v)
local w=v.optional and i("?","symbol")or""
local x=`{i(v.kind,v.kind)}{w}`

if v.name then
return`{j(v.name)}: {x}`
end

return x end


t.highlightArgsType=function(u, v)
if#v==0 then return""end

local w={}

for x,y in v do
table.insert(w,u:highlightArgType(y))
end

return`({table.concat(w,", ")})`end


t.resetInput=function(u)
local v=u.cmdInput

v.highlightText=""
v.commandName=""
v.commandData=nil
v.isValidCommand=false
v.isAbreviated=false
v.bestMatch=nil
v.bestMatches={}
v.correctionText=nil
v.correction=nil
v.runError=nil
v.hasGhost=false
v.args={}
v.statements={}

u:setComment""end



t.highlightStatement=function(u, v, w)
local x=u.cmdInput
local y=v.tokens
local z={
lead=v.lead,
text="",
trailing=v.spaces,
args={},
commandName="",
bestMatches={},
isValidCommand=false,
isAbreviated=false,
}

if#y==0 then
z.empty=true
return z
end

local A=y[1]
local B=#v.spaces>0
local C=A.value
local D=C
local E
local F
local G=false


if A.kind=="identifier"then
local H,I=C:match"^(.*%^)(.*)$"

if H then
E,F=s(H:sub(1,-2))
D=I
end

if D:sub(1,1)==d then
G=true
D=D:sub(2)
end
end

local H=C:sub(1,#C-#D)
local I=D:lower()
local J=h(I)

z.commandName=I
z.commandData=J
z.isValidCommand=J~=nil
z.isAbreviated=J~=nil and J.name~=I
z.loop=E

if F then
z.text=i(ah(C),"error")
z.runError=F
z.comment={text=F,color="error"}
return z
end

local K=""
if H~=""then
K=i(ah(H),"comment")
end

if not J then
local L=aa:search(I)
local M=L[1]

z.bestMatches=L
z.bestMatch=M

if B or#y>1 or not M then
local N=x.rawText:sub(A.from,y[#y].to)

z.text=i(ah(N),"error")
z.runError=" - invalid command"
z.comment={text=" - invalid command",color="error"}
return z
end


local N,O,P=o(M,D)

z.text=K..i(ah(N)..i(ah(O),"warn")..ah(P),"comment")
z.correction=r(A.from,A.to,H..M,A.usedChar)
z.correctionText=M
z.runError=" - invalid command"
return z
end

local L={K..i(ah(D),"valid")}


if w and#y==1 and not B and#J.aliases>1 then
local M=table.clone(J.aliases)
local N=table.find(M,I)

if N then
table.remove(M,N)
end

z.comment={text=`: [{table.concat(M,", ")}]`,color="comment"}
end

if G and#y==1 then

z.repeatLast=true

if#J.args>0 and aa:getLastArgs(J.name)==nil then
z.runError=" - no previous arguments"
z.comment={text=" - no previous arguments",color="error"}
end
else
u:highlightArgs(z,J,v,B,L,w)
end

z.text=table.concat(L," ")
return z end




t.highlight=function(u, v)
local w=u.cmdInput
u:resetInput()

local x=#v
local y={}

for z,A in v do
y[z]=u:highlightStatement(A,z==x)
end

local z=y[x]

w.statements=y
w.commandName=z.commandName
w.commandData=z.commandData
w.isValidCommand=z.isValidCommand
w.isAbreviated=z.isAbreviated
w.bestMatch=z.bestMatch
w.bestMatches=z.bestMatches
w.args=z.args


local A

for B,C in y do

if C.empty and x>1 then
C.runError=" - command missing"
end

if C.runError and w.runError==nil then
w.runError=C.runError
end

if C.correction and w.correction==nil then
w.correction=C.correction
end

if C.hasGhost then
w.hasGhost=true
end

if C.comment and A==nil then
A=C.comment
end
end

if A then
u:setComment(A.text,A.color)
end

local B={}

for C,D in y do

local E=if D.correction or D.hasGhost then""else D.trailing
local F=D.lead..D.text..E

if C<x then
F=F..i(ah(ai),"symbol")
end

table.insert(B,F)
end

local C=table.concat(B)
w.highlightText=C

return C end


t.setComment=function(u, ...)
return u.setCommentCallback(...)end


t.new=function(u, v)
return setmetatable({
cmdInput=u,
setCommentCallback=v
},t)end


return t end a.c_=function()local ab=a.cache.c_ if not ab then ab={c=aa()}a.cache.c_=ab end return ab.c end end do local aa=function()






local aa=a.cV()
local ab=a.c_()
local ac=a.F()
local ad=a.cU()
local ae=a.d()

local af={}


af.runStatement=function(ag)
local ah=ag.commandData.name
local ai=ag.args

if ag.repeatLast then
ai=aa:getLastArgs(ah)or{}
end

if ag.loop then
af.startLoop(ah,ai,ag.loop)
return
end

aa:run(ah,ac.new(ai))end



af.startLoop=function(ag, ah, ai)
local b=0
local c

c=ad:add(function()
b=b+1

local d,e=pcall(function()
aa:run(ag,ac.new(ah))
end)

if not d then
ad:remove(c)
ae:error(`loop of '{ag}' stopped: {e}`)
return
end

if b>=ai.count then
ad:remove(c)
end
end,ai.delay)end local ag=function(




ag)
local ah={}
local ai=ab.new(ah,function()end)

ai:highlight(ai:parse(ag))

return ah.statements,ah.runError end local ah=function(



ah)
for ai,b in ah do
if b.empty then
return"write the command to run"
end

if not b.commandData then
return`'{b.commandName}' is not a command`
end
end

return nil end




af.checkText=function(ai)
local b=ag(ai)
local c=ah(b)

if c then
return false,c
end

return true end




af.runText=function(ai)
local b,c=ag(ai)
local d=ah(b)

if d then
return false,d
end

if c then

return false,(c:gsub("^%s*%-%s*",""))
end

for e,f in b do
local g,h=pcall(af.runStatement,f)

if not g then
return false,tostring(h)
end
end

return true end


return af end a.c0=function()local ab=a.cache.c0 if not ab then ab={c=aa()}a.cache.c0=ab end return ab.c end end do local aa=function()








local aa=a.cY()
local ab=a.bC()
local ac=a.c0()
local ad=a.cV()
local ae=a.S()

local af=aa.ANY

local ag={}


ag.events=aa.events

local ah={}
for ai,b in aa.events do
ah[b.name]=b
end local ai=function(

ai)
return ai:match"^%s*(.-)%s*$"or""end



ag.getEvent=function(b)
return ah[b]end



ag.getBinds=function(b)
local c=ab.object[b]

if type(c)~="table"then
return{}
end

return table.clone(c)end local b=function(




b, c)
local d=ai(c or"")

if d==""then
d=b.default
end

if d:lower()==af then
return af
end

if b.kind=="Number"and tonumber(d)==nil then
return nil,`{b.label} must be a number or any`
end

return d end




ag.add=function(c, d, e, f)
local g=ah[c]
if not g then
return false,"invalid event"
end

local h=ai(d)
local i,j=ac.checkText(h)

if not i then
return false,j
end

if type(e)~="number"or e<0 then
return false,"the delay must be 0 or more"
end

local k={}

for l,m in g.conditions do
local n,o=b(m,f and f[l])

if not n then
return false,o
end

k[l]=n
end

local l=ab.object[c]
if type(l)~="table"then
l={}
ab.object[c]=l
end

table.insert(l,{command=h,delay=e,conditions=k})
ab:save()

return true end



ag.remove=function(c, d)
local e=ab.object[c]

if type(e)~="table"or e[d]==nil then
return nil
end

local f=table.remove(e,d)
ab:save()

return f end




ag.restore=function(c, d, e)
if not ah[c]or type(e)~="table"then
return false
end

local f=ab.object[c]
if type(f)~="table"then
f={}
ab.object[c]=f
end

table.insert(f,math.clamp(d,1,#f+1),e)
ab:save()

return true end



ag.setDelay=function(c, d, e)
local f=ab.object[c]

if type(f)~="table"or type(f[d])~="table"then
return false
end

if type(e)~="number"or e<0 then
return false
end

f[d].delay=e
ab:save()

return true end local c=function(



c, d)
local e,f=pcall(ae,c)

if not e then
return false
end

for g,h in f do
if h.Name==d then
return true
end
end

return false end local d=function(



d, e, f)
if e:lower()==af then
return true
end

if d.kind=="Player"then
return c(e,tostring(f))
end

if d.kind=="String"then
return tostring(f):lower():find(e:lower(),1,true)~=nil
end

if d.kind=="Number"then
local g,h=tonumber(e),tonumber(f)
return g~=nil and h~=nil and h<=g
end

return false end local e=function(



e, f, g)
local h=f.conditions or{}

for i,j in e.conditions do
local k=tostring(h[i]or j.default)

if not d(j,k,g[i])then
return false
end
end

return true end local f=function(




f)
if f:match"^[%w_%-%.]+$"then
return f
end

return'"'..(f:gsub('"','\\"'))..'"'end local g=function(



g, h)
return(g:gsub("%$(%d+)",function(i)
local j=h[tonumber(i)]

if j==nil then
return nil
end

return f(tostring(j))
end))end local h=function(




h, i)
local j=h.delay or 0

if j>0 then
task.wait(j)
end

local k=g(h.command,i)
local l,m=ac.runText(k)

if not l then
ad:notify("Event Bind",`'{k}' did not run: {m}`)
end end




ag.fire=function(i, ...)
local j=ah[i]
local k=ab.object[i]

if not j or type(k)~="table"then
return
end

local l={...}

for m,n in table.clone(k)do
if type(n)=="table"and e(j,n,l)then
task.spawn(h,n,l)
end
end end


return ag end a.c1=function()local ab=a.cache.c1 if not ab then ab={c=aa()}a.cache.c1=ab end return ab.c end end do local aa=function()








local aa=a.P()
local ab=a.au()
local ac=a.c1()

local ad=aa.Players
local ae=aa.TextChatService

local af={}

local ag=false
local ah=false


local ai={}

local b={}local c=function(


c, d, e, f)
local g=ab:Connect(e,f)

local h=c[d]or{}
c[d]=h
table.insert(h,g)end local d=function(


d, e)
local f=d[e]
d[e]=nil

for g,h in f or{}do
ab:disconnect(h)
end end local e=function(



e, f)
d(b,e)

task.spawn(function()
local g=f:WaitForChild("Humanoid",10)


if not g or not g:IsA"Humanoid"or e.Character~=f then
return
end

local h=g.Health

c(b,e,g.HealthChanged,function(i)
if i<h then
ac.fire("OnDamage",e.Name,i)
end

h=i
end)

c(b,e,g.Died,function()
ac.fire("OnDied",e.Name)


local i=g:FindFirstChild"creator"
local j=if i and i:IsA"ObjectValue"then i.Value else nil

if j and j:IsA"Player"then
ac.fire("OnKilled",e.Name,j.Name)
end
end)
end)end local f=function(




f)
c(ai,f,f.CharacterAdded,function(g)
ac.fire("OnSpawn",f.Name)
e(f,g)
end)

if ah then
c(ai,f,f.Chatted,function(g)
ac.fire("OnChatted",f.Name,g)
end)
end

if f.Character then
e(f,f.Character)
end end local g=function(


g)
local h=g.TextSource

if not h or g.Status==Enum.TextChatMessageStatus.InvalidTextChannelPermissions then
return
end

local i=ad:GetPlayerByUserId(h.UserId)

if i then
ac.fire("OnChatted",i.Name,g.Text)
end end local h=function(


h)
ac.fire("OnLeave",h.Name)

d(ai,h)
d(b,h)end



af.start=function()
if ag then
return
end

ag=true
ah=ae.ChatVersion==Enum.ChatVersion.LegacyChatService

ab:Connect(ad.PlayerAdded,function(i)
ac.fire("OnJoin",i.Name)
f(i)
end)

ab:Connect(ad.PlayerRemoving,h)

if not ah then
ab:Connect(ae.MessageReceived,g)
end


for i,j in ad:GetPlayers()do
f(j)
end

ac.fire"OnExecute"end


return af end a.c2=function()local ab=a.cache.c2 if not ab then ab={c=aa()}a.cache.c2=ab end return ab.c end end do local aa=function()

return{NEW_YEAR=
"🎆",VALENTINE_DAYS=
"💝",CLOVER=
"☘️",HALLOWEEN=
"🎃",CHRISTMAS=
"🎄",EASTER=
"🥚",
}end a.c3=function()local ab=a.cache.c3 if not ab then ab={c=aa()}a.cache.c3=ab end return ab.c end end do local aa=function()



local aa={}

local ab=a.ap()
local ac=a.c3()

aa.getEasterDate=function()
local ad=tonumber(os.date"%Y")

local ae=math.floor(ad/100)
local af=math.floor((13+8*ae)/25)
local ag=(15-af+ae-math.floor(ae/4))%30
local ah=(4+ae-math.floor(ae/4))%7

local ai=(19*(ad%19)+ag)%30
local b=(2*(ad%4)+4*(ad%7)+6*ai+ah)%7
local c=22+ai+b

if ai==29 and b==6 then
return"04 19"
elseif ai==28 and b==6 then
return"04 18"
end

if c>31 then
return string.format("04 %02d",c-31)
end

return string.format("03 %02d",c)end


aa.getHolidayEmoji=function()
local ad=aa.getEasterDate()

local ae={
["01 01"]=ac.NEW_YEAR,
["02 14"]=ac.VALENTINE_DAYS,
["03 17"]=ac.CLOVER,
["10 31"]=ac.HALLOWEEN,
["12 25"]=ac.CHRISTMAS,
[ad]=ac.EASTER
}

local af=os.date"%m %d"
return ae[af]end


aa.getDisplayName=function()
local ad=ab.applicationName
local ae=ab.version

ad=string.gsub(ad,"!VERSION",ae)

local af=aa.getHolidayEmoji()

if af then
ad=`{af} {ad} {af}`
end

return ad end


return aa end a.c4=function()local ab=a.cache.c4 if not ab then ab={c=aa()}a.cache.c4=ab end return ab.c end end do local aa=function()









local aa={}








aa.compute=function(ab, ac, ad, ae)

local af=ab.x.scale*ac.width+ab.x.offset
local ag=af+ab.width

local ah=ac.width-ag-ae
local ai=af-ae

local b
if ah>=ad.width then
b=true
elseif ai>=ad.width then
b=false
else
b=ah>=ai
end

local c
if b then
c={scale=ab.x.scale,offset=ab.x.offset+ab.width+ae}
else
c={scale=ab.x.scale,offset=ab.x.offset-ae}
end


local d=ab.y.scale*ac.height+ab.y.offset
local e=d+ab.height



local f=(math.max(d,0)+math.min(e,ac.height))/2
local g=f>ac.height/2

local h,i,j
if g then

if e>=ac.height then
h={scale=1,offset=0}
else
h={scale=ab.y.scale,offset=ab.y.offset+ab.height}
end
i=1
j=math.min(e,ac.height)
else
if d<0 then
h={scale=0,offset=0}
else
h={scale=ab.y.scale,offset=ab.y.offset}
end
i=0
j=ac.height-math.max(d,0)
end

return{
x=c,
y=h,
anchorX=if b then 0 else 1,
anchorY=i,
room=math.max(j,0),
}end


return aa end a.c5=function()local ab=a.cache.c5 if not ab then ab={c=aa()}a.cache.c5=ab end return ab.c end end do local aa=function()



local aa=a.cM()

local ab={}

ab.create=function(ac)
local ad=aa.new("Frame","MainFrame",{
Active=true,
BorderSizePixel=0,
ThemeTag={
BackgroundColor3="Colors.Background"
},
aa.new("Frame","TopBar",{
Size=UDim2.fromOffset(250,20),
BorderSizePixel=0,
ThemeTag={
BackgroundColor3="Colors.Background"
}
})
})

local ae=ad.TopBar

local af=aa.new("TextLabel","Title",ae,{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
TextSize=16,
ThemeTag={
TextColor3="Colors.Text.Default",
Font="Font.Normal"
}
})

local ag=aa.new("ImageButton",ae,{
Name="SettingsButton",
BackgroundTransparency=1,
Position=UDim2.new(1,-2,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Size=UDim2.fromOffset(19,19),
ThemeTag={
ImageColor3="Colors.Icons"
}
})

local ah=aa.new("ImageButton",ae,{
Name="ReferenceButton",
BackgroundTransparency=1,
Position=UDim2.new(1,-22,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Size=UDim2.fromOffset(15,15),
ThemeTag={
ImageColor3="Colors.Icons"
}
})

return{
mainFrame=ad,
topBar=ae,
titleLabel=af,
buttons={
settings=ag,
reference=ah
}
}end


return ab end a.c6=function()local ab=a.cache.c6 if not ab then ab={c=aa()}a.cache.c6=ab end return ab.c end end do local aa=function()

local aa=a.cM()

local ab={up=
function(ab,ac)
local ad=1/ab
local ae=ac/ab

local af=UDim2.fromScale(ae,ad)
local ag=UDim2.fromScale(
0.5-(ae/2),
(ac-1)*ad
)
return af,ag
end,down=
function(ab,ac)
local ad=1/ab
local ae=ac/ab

local af=UDim2.fromScale(ae,ad)
local ag=UDim2.fromScale(
0.5-(ae/2),
1-(ac*ad)
)
return af,ag
end,left=
function(ab,ac)
local ad=1/ab
local ae=ac/ab

local af=UDim2.fromScale(ad,ae)
local ag=UDim2.fromScale(
(ac-1)*ad,
0.5-(ae/2)
)
return af,ag
end,right=
function(ab,ac)
local ad=1/ab
local ae=ac/ab

local af=UDim2.fromScale(ad,ae)
local ag=UDim2.fromScale(
1-(ac*ad),
0.5-(ae/2)
)
return af,ag
end
}

return function(ac,ad,ae)
local af=ab[ae]
if not af then
error("r u ok? Invalid direction: "..tostring(ae))
end

local ag=aa.new("Frame","Arrow",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
aa.new("UIScale",{
Scale=ad
})
})

for ah=1,ac do
local ai,b=af(ac,ah)

aa.new("Frame",`line_{ah}`,{
BackgroundColor3=Color3.fromRGB(220,220,220),
BorderSizePixel=0,
Size=ai,
Position=b,
Parent=ag,
ThemeTag={
BackgroundColor3="Colors.Icons"
}
})
end

return ag
end end a.c7=function()local ab=a.cache.c7 if not ab then ab={c=aa()}a.cache.c7=ab end return ab.c end end do local aa=function()



local aa=a.au()
local ab=a.P()

local ac=ab.UserInputService

local ad={
[Enum.UserInputType.MouseButton1]=true,
[Enum.UserInputType.Touch]=true
}

local ae={
[Enum.UserInputType.MouseMovement]=true,
[Enum.UserInputType.Touch]=true
}

local af={}

af.onReleaseEvent=function(ag)
local ah

ah=aa:Connect(ac.InputEnded,function(ai)
if af.isPressingInput(ai)then
ah:Disconnect()
ag(ai)
end
end)

return ah end


af.onMouseEvent=function(ag)
local ah

ah=aa:Connect(ac.InputChanged,function(ai)
if af.isMovingInput(ai)then
ag(ai)
end
end)

return ah end


af.isPressingInput=function(ag)
return ad[ag.UserInputType]~=nil end


af.isMovingInput=function(ag)
return ae[ag.UserInputType]~=nil end


return af end a.c8=function()local ab=a.cache.c8 if not ab then ab={c=aa()}a.cache.c8=ab end return ab.c end end do local aa=function()
local aa=a.au()
local ab=a.cM()
local ac=a.R()
local ad=a.cL()

local ae=a.c7()
local af=a.cP()

local ag=a.cz()

local ah=a.c8()

local ai={}
ai.__index=ai

ai.awake=function(b)
local c=ac:getMouse()

local d=b.scrollThumbFrame
local e=b.scrollThumb
local f=b.scrollBar

local g=false
local h=false
local i local j=function(

j, k)local l=function()

if g then return end
if not b:canScroll(k)then return end

g=true

b:scrollToDirection(k)

ah.onReleaseEvent(function()
g=false
end)

task.wait(0.4)

while b:canScroll(k)and g do
b:scrollToDirection(k)
task.wait(6.666666666666666E-2)
end end


aa:Connect(j.MouseButton1Down,l)end




j(b.upButton,"up")
j(b.downButton,"down")local k=function(



k)
if b.locked then return end
b:scrollTo(b.index+k*b.wheelIncrement)end


for l,m in{f,b.container}do
aa:Connect(m.MouseWheelForward,function()
k(-1)
end)

aa:Connect(m.MouseWheelBackward,function()
k(1)
end)
end

aa:Connect(f.InputBegan,function(l)
if not ah.isPressingInput(l)then return end
if b:isScrollBarDisabled()then return end

local m=not ac:isMouseInGuiObject(e)
local n=b.isHorizontal and"X"or"Y"

local o
h=true

ad:updateObjectProperties(e,{
BackgroundColor3="Colors.Primary"
})

local p=c[n]-e.AbsolutePosition[n]
local q local r=function()


if q then q:Disconnect()end end


ah.onReleaseEvent(function()
r()
h=false

ad:updateObjectProperties(e,{
BackgroundColor3="Colors.OnPrimary"
})
end)

if m then local s=function()

if b.locked then return end

local s=(c[n]>=e.AbsolutePosition[n]+e.AbsoluteSize[n])and 1 or 0
local t=b.visibleSpace-1

if s==0 and(
c[n]<e.AbsolutePosition[n]
)then
b:scrollTo(b.index-t)
elseif s==1 and(
c[n]>=e.AbsolutePosition[n]+e.AbsoluteSize[n]
)then
b:scrollTo(b.index+t)
end end


while h do
s()
task.wait(0.25)
end
return
end

q=ah.onMouseEvent(function(s)
if not h then return end
if b.locked then return end

local t=d.AbsoluteSize[n]-e.AbsoluteSize[n]
local u=c[n]-d.AbsolutePosition[n]-p

if u>t then
u=t
elseif u<0 then
u=0
end

if o~=u then
o=u
b:scrollTo(math.floor(0.5+u/t*(b.totalSpace-b.visibleSpace)))
end
end)
end)end


ai.create=function(b)
b.upButton=ab.new("ImageButton",b.upButtonName,{
BackgroundTransparency=1,
AutoButtonColor=false
})

b.downButton=ab.new("ImageButton",b.downButtoName,{
BackgroundTransparency=1,
AutoButtonColor=false
})

b:createButtonsArrows()

local c=ab.new("Frame","ScrollBar",{
Active=true,
BackgroundTransparency=1,

b.upButton,
b.downButton,

ab.new("Frame","ScrollThumbFrame",{
BackgroundTransparency=1,
AnchorPoint=b.isHorizontal
and Vector2.new(0.5,0)
or Vector2.new(0,0.5),
Position=b.isHorizontal
and UDim2.fromScale(0.5,0)
or UDim2.fromScale(0,0.5),

ab.new("Frame","ScrollThumb",{
AnchorPoint=b.isHorizontal
and Vector2.new(0,0.5)
or Vector2.new(0.5,0),
ThemeTag={
BackgroundColor3="Colors.OnPrimary"
},

ab.new("UICorner",{
CornerRadius=UDim.new(0,4),
}),
}),

ab.new("Frame","MarkerFrame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
}),
}),
})

b.scrollBar=c
b.scrollThumbFrame=c.ScrollThumbFrame
b.scrollThumb=c.ScrollThumbFrame.ScrollThumb
b.markerFrame=c.ScrollThumbFrame.MarkerFrame

b.container=ab.new("Frame","Container",{
BackgroundTransparency=1,
ClipsDescendants=true,
Active=true
})

b:setScrollBarThickness(b.barThickness)
b:awake()
b:update()


return c end


ai.createButtonsArrows=function(b)
local c=b.downButton
local d=b.upButton

ae(4,0.55,c.Name).Parent=c
ae(4,0.55,d.Name).Parent=d end


ai.canScrollUp=function(b)
return b:isScrollBarEnabled()and b.index>0 end


ai.canScrollDown=function(b)
local c=b:isScrollBarEnabled()
return c and b.index+b.visibleSpace<b.totalSpace end


ai.canScroll=function(b, c)
if b.locked then return false end

if c=="up"or c=="left"then
return b:canScrollUp()
elseif c=="down"or c=="right"then
return b:canScrollDown()
end
return false end


ai.getScrollPercent=function(b)
local c=b.totalSpace-b.visibleSpace
if c<=0 then return 0 end
return b.index/c end


ai.scrollTo=function(b, c, d)
local e=math.max(0,b.totalSpace-b.visibleSpace)

b.index=math.clamp(c,0,e)
b:update()

if not d then
b.scrolledSignal:Fire(b.index)
end end


ai.scrollUp=function(b)
b:scrollTo(b.index-b.increment)end


ai.scrollDown=function(b)
b:scrollTo(b.index+b.increment)end


ai.scrollToDirection=function(b, c)
if c=="up"or c=="left"then
return b:scrollUp()
elseif c=="down"or c=="right"then
return b:scrollDown()
end end


ai.isVisible=function(b, c)
local d=b.index
if c>=d and c<(d+b.visibleSpace)then
return true
end
return false end


ai.setScrollPercent=function(b, c)
local d=b.totalSpace-b.visibleSpace
b:scrollTo(math.floor(c*d))end


ai.update=function(b)
b:drawThumb()end


ai.setScrollBarThickness=function(b, c)
local d=b.scrollThumbFrame
local e=b.downButton
local f=b.container
local g=b.scrollBar
local h=b.upButton

b.barThickness=c

if f then
f.Size=UDim2.new(
1,
b.isHorizontal and 0 or-c,
1,
b.isHorizontal and-c or 0
)
end

if g then
g.Size=b.isHorizontal
and UDim2.new(1,0,0,c)
or UDim2.new(0,c,1,0)
g.Position=b.isHorizontal
and UDim2.new(0,0,1,-c)
or UDim2.new(1,-c,0,0)
end

if d then
d.Size=b.isHorizontal
and UDim2.new(1,-(c*2),0,c)
or UDim2.new(0,c,1,-(c*2))
end

if e then
e.Size=UDim2.fromOffset(c,c)
e.Position=b.isHorizontal
and UDim2.new(1,-c,0,0)
or UDim2.new(0,0,1,-c)
end

if h then
h.Size=UDim2.fromOffset(c,c)
h.Position=UDim2.fromOffset(0,0)
end end


ai.updateArrowTransparency=function(b, c, d)
if not c:FindFirstChild"Arrow"then return end

for e,f in c.Arrow:GetChildren()do
if not f:IsA"GuiObject"then continue end
f.Transparency=d and 0.6 or 0
end end


ai.drawThumb=function(b)
local c=b.scrollThumb
local d=b.scrollThumbFrame

local e=b:canScrollUp()
local f=b:canScrollDown()

b:updateArrowTransparency(b.upButton,not e)
b:updateArrowTransparency(b.downButton,not f)

if not c or not d then return end

if not e and not f then
c.Visible=false
return
end

c.Visible=true

local g=b:getScrollPercent()
local h=af:getScale()
local i=b.barThickness

if b.isHorizontal then
local j=d.AbsoluteSize.X/h
local k=math.max(i,(b.visibleSpace/b.totalSpace)*j)
c.Size=UDim2.new(0,k,1,-2)
c.Position=UDim2.new(0,g*(j-k),0.5,0)
else
local j=d.AbsoluteSize.Y/h
local k=math.max(i,(b.visibleSpace/b.totalSpace)*j)
c.Size=UDim2.new(1,-2,0,k)
c.Position=UDim2.new(0.5,0,0,g*(j-k))
end end


ai.addMarker=function(b, c, d)
b.markers[c]=d or Color3.new(1,1,0)
b:updateMarkers()end


ai.removeMarker=function(b, c)
b.markers[c]=nil
b:updateMarkers()end


ai.updateMarkers=function(b)
local c=b.markerFrame
if not c then return end

for d,e in pairs(c:GetChildren())do
e:Destroy()
end

for d,e in pairs(b.markers)do
if d>=b.totalSpace then continue end

local f=Instance.new"Frame"
f.BackgroundColor3=e
f.BorderSizePixel=0
f.BackgroundTransparency=0
f.Parent=c

local g=d/b.totalSpace
if b.isHorizontal then
f.Position=UDim2.new(g,0,1,-4)
f.Size=UDim2.new(0,2,0,4)
else
f.Position=UDim2.new(1,-4,g,0)
f.Size=UDim2.new(0,4,0,2)
end

f.Name="Marker_"..tostring(d)
end end


ai.setTotalSpace=function(b, c)
b.totalSpace=c
b:scrollTo(b.index,true)
b:update()end


ai.setVisibleSpace=function(b, c)
b.visibleSpace=c
b:scrollTo(b.index,true)
b:update()end


ai.disableScroll=function(b)
b.scrollBarEnabled=false
b:drawThumb()end


ai.enableScroll=function(b)
b.scrollBarEnabled=true
b:drawThumb()end


ai.isScrollBarEnabled=function(b)
return b.scrollBarEnabled end


ai.isScrollBarDisabled=function(b)
return not b.scrollBarEnabled or b.locked end






ai.setLocked=function(b, c)
b.locked=c==true end


ai.isLocked=function(b)
return b.locked end


ai.new=function(b)
local c=setmetatable({
isHorizontal=b.isHorizontal or false,
increment=b.increment or 1,
wheelIncrement=b.wheelIncrement or 3,
barThickness=b.barThickness or 16,

scrollBarEnabled=true,
locked=false,

index=0,
visibleSpace=b.visibleSpace or 0,
totalSpace=b.totalSpace or 0,

markers={},

scrollBar=b.scrollBar or nil,
scrollThumb=b.scrollThumb or nil,
scrollThumbFrame=b.scrollThumbFrame or nil,
markerFrame=b.markerFrame or nil,

scrolledSignal=ag.new(),
},ai)

c.upButtonName=c.isHorizontal and"left"or"up"
c.downButtoName=c.isHorizontal and"right"or"down"

return c end


return ai end a.c9=function()local ab=a.cache.c9 if not ab then ab={c=aa()}a.cache.c9=ab end return ab.c end end do local aa=function()
local aa={}
aa.__index=aa

aa.new=function(ab)
return setmetatable({
isClient=ab.client or ab.isClient or ab.onlyClient,
isDeprecated=ab.deprecated or ab.isDeprecated,

name=ab.name,
isSection=ab.isSection,
sectionName=ab.sectionName,
aliases=ab.aliases,
args=ab.args,
name=ab.name,
description=ab.description
},aa)end


return aa end a.da=function()local ab=a.cache.da if not ab then ab={c=aa()}a.cache.da=ab end return ab.c end end do local aa=function()
local aa=a.au()
local ab=a.P()
local ac=a.R()
local ad=a.cM()
local ae=a.da()

local af=a.c_()
local ag=a.c0()

local ah=a.c8()
local ai=a.cy()

local b=a.cz()
local c=a.d()
local d=a.cK()
local e=a.cP()

local f=a.al()
local g=a.cR().commands
local h=a.bX()

local i=ab.UserInputService
local j=ab.RunService

local k=d.richFontSize
local l=d.colorFromRGB

local m={}
m.__index=m

local n=0.15
local o=2.50
local p=50 local q=function(

q)
return ai.lookup[q]end local r=function(


r)
return math[(r<0)and"ceil"or"floor"](r)end local s=function(


s)
s=s:gsub("[\r\n]+$","")
s=s:gsub("[\r\n]+"," ")
return s end


m.refresh=function(t, u, v)
local w=t.parser:parse(u)
t.parser:highlight(w)

t:updateSearchBoxHighlight()

if v then
t:scheduleSearchedCommand()
else
t.scrollToken=t.scrollToken+1
t:updateSearchedCommand()
end end




m.scheduleSearchedCommand=function(t)
t.scrollToken=t.scrollToken+1
local u=t.scrollToken

task.delay(n,function()
if u~=t.scrollToken then return end
t:updateSearchedCommand()
end)end


m.applyCorrection=function(t)
local u=t.commandInput
local v=u.correction
local w=u.rawText

local x=w:sub(1,v.from-1)..v.text..w:sub(v.to+1)

if f:getValue"spaceAfterCorrection"then
x=x.." "
end

t:writeText(x)end


m.captureFocus=function(t)
local u=t.searchBox
if not u then return end






if u.Parent~=nil then
u:CaptureFocus()
end end





m.setInteractive=function(t, u)
u=u==true
if t.interactive==u then return end
t.interactive=u

t.scrollBar:setLocked(not u)


if not u then
local v=t.searchBox

if v and v:IsFocused()then
v:ReleaseFocus()
end
end end


m.isInteractive=function(t)
return t.interactive end


m.awake=function(t)
local u=t.commandInput
local v=t.searchBox
local w=t.searchBoxHolder
local x=t.inputMarker

local y=w.Placeholder

local z=v:GetPropertyChangedSignal"Text"

local A=0 local B=function()


if(tick()-A)>0.5 then
x.Visible=not x.Visible
A=tick()
end end local C=function()



if v:IsFocused()then
v:ReleaseFocus()
end end local D=function()



v:CaptureFocus()end local E=function()



if u.correction then
t:applyCorrection()
task.defer(D)
return true
end


t:sendInputCommand()
return false end local F=function()



local F=not v:IsFocused()and#v.Text==0
y.Visible=F end


t.commandClickedSignal:Connect(function(G)
if not t.interactive then return end

t:writeText(G.aliases[1])
task.defer(D)
end)

aa:Connect(w.Activated,function()
if not t.interactive then return end

D()
end)

aa:Connect(v.Focused,function()
if t.onInteraction then t.onInteraction()end

F()
t.markerConnection=aa:Connect(j.Stepped,B)

if#v.Text==0 then
t:setComment""
end
end)

aa:Connect(v.FocusLost,function(G)
F()
x.Visible=true
aa:disconnect(t.markerConnection)

if G then
t:refresh(s(v.Text))
E()
end
end)

aa:Connect(z,function()
if t.onInteraction then t.onInteraction()end

local G=v.Text


if G:find"\t"then
v.Text=(G:gsub("\t",""))
return
end


if t.historyIndex and G~=t.historyText then
t.historyIndex=nil
end

local H=G:sub(-1)=="\n"or G:sub(-1)=="\r"

if G:find"[\r\n]"then
G=s(G)
v.Text=G

if H then
t:refresh(G)

if not E()then
C()
end
return
end
end


local I=#G<#t.lastText
t.lastText=G

F()
t:refresh(G,I)
end)


aa:Connect(i.InputBegan,function(G)
if not v:IsFocused()then return end

if G.KeyCode==Enum.KeyCode.Up then
t:browseHistory(-1)
elseif G.KeyCode==Enum.KeyCode.Down then
t:browseHistory(1)
elseif G.KeyCode==Enum.KeyCode.Tab and t.commandInput.correction then
t:applyCorrection()
task.defer(D)
end
end)end


local t=50


m.sendInputCommand=function(u)
local v=u.commandInput

if v.runError then
u:setComment(v.runError,"error")
return
end

local w=v.statements

for x,y in w do
if not y.commandData then return end
end


if u.onCommandSent then
u.onCommandSent()
end

local x=v.rawText
local y,z

for A,B in w do
local C,D=pcall(function()
u:runStatement(B)
end)

if not C then
y=D
z=B.commandData.name
break
end
end

if f:getValue"clearOnEnter"then
u:writeText""
end

u.historyIndex=nil

if y then
u:setComment(`failed - {y}`,"error")
c:error(`failed to run command '{z}': {y}`)
else
u:addToHistory(x)
end end



m.runStatement=function(u, v)
ag.runStatement(v)end


m.addToHistory=function(u, v)
local w=(v or""):match"^(.-)%s*$"

if w==""then return end

local x=u.history

if x[#x]==w then return end

table.insert(x,w)

if#x>t then
table.remove(x,1)
end end



m.browseHistory=function(u, v)
local w=u.history

if#w==0 then return end

local x

if u.historyIndex==nil then
if v>0 then return end
x=#w
else
x=u.historyIndex+v
end

if x<1 then
x=1
end

if x>#w then
u.historyIndex=nil
u:setSearchText""
return
end

u.historyIndex=x
u:setSearchText(w[x])end


m.setSearchText=function(u, v)
u.historyText=v
u:writeText(v)end




m.writeText=function(u, v)
u.searchBox.Text=v
u.lastText=v
u:refresh(v)end


m.create=function(u)
u.searchBoxHolder=ad.new("ImageButton",{
Size=UDim2.new(1,-10,0,18),
Position=UDim2.fromScale(0.5,0),
AnchorPoint=Vector2.new(0.5,1),
BorderSizePixel=0,
ClipsDescendants=true,
ThemeTag={BackgroundColor3="Colors.Buttons.Default"},

ad.new("UICorner",{CornerRadius=UDim.new(0,6)}),

ad.new("TextLabel","Input",{
Size=UDim2.fromScale(0,1),
Position=UDim2.new(0,5,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,
AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,
TextSize=u.configs.textSize,
Visible=false,
RichText=true,
ThemeTag={
TextColor3="Colors.Text.Default",
Font="Font.MonoSpace"
},
ad.new("Frame","Holder",{
Size=UDim2.fromScale(0,1),
Position=UDim2.fromScale(1,0)
}),
}),

ad.new("TextLabel","Placeholder",{
Size=UDim2.new(1,-5,1,0),
Position=UDim2.new(0,5,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,
BackgroundTransparency=1,
TextSize=u.configs.textSize-1,
Text=u.configs.placeholderText,
ThemeTag={
TextColor3="Colors.Text.Dark",
Font="Font.MonoSpace"
},
}),
})

local v=u.searchBoxHolder
local w=v.Input.Holder

u.inputMarker=ad.new("Frame","Marker",w,{
Size=UDim2.new(0,1.5,1,-3),
Position=UDim2.new(1,0.2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BorderSizePixel=0,
Visible=false,
ThemeTag={BackgroundColor3="Colors.Primary"}
})

u.inputComment=ad.new("TextLabel","Comment",w,{
Size=UDim2.fromScale(1,1),
Position=UDim2.fromScale(1,0.5),
AnchorPoint=Vector2.new(0,0.5),
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,
BackgroundTransparency=1,
TextSize=u.configs.textSize,
RichText=true,
Text="",
ThemeTag={
TextColor3="Colors.Text.Default",
Font="Font.MonoSpace"
}
})

u.commandInfo=ad.new("TextLabel","Info",{
Size=UDim2.new(1,-25,0,0),
Position=UDim2.new(0,10,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
TextYAlignment=Enum.TextYAlignment.Center,
TextXAlignment=Enum.TextXAlignment.Left,
Font=u.configs.textFont,
TextSize=u.configs.textSize-5,
Visible=false,
ad.new("UICorner",{
CornerRadius=UDim.new(0,4)
}),
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
TextColor3="Colors.Text.Default"
}
})

u.searchBox=ad.new("TextBox","SearchBox",{
BackgroundTransparency=1,
BorderSizePixel=0,
TextTransparency=1,
Size=UDim2.fromScale(1,0),
Position=UDim2.fromScale(0,0.4),
ClearTextOnFocus=false,
ShowNativeInput=false,
TextSize=0,
Text="",
MultiLine=true
})



u.searchBox.ZIndex=0
pcall(function()
u.searchBox.Interactable=false
end)

u.commandsFolder=ad.new("Folder","Commands")end


m.createCommandsData=function(u)
for v,w in ai.original do
local x=ae.new(w)
w.commandData=x
x.position=v-1
table.insert(u.commandsData,x)
end end


m.updateSearchBoxHighlight=function(u)
local v=u.commandInput.highlightText
local w=u.searchBoxHolder
local x=w.Input
local y=e:getScale()

x.Text=v
x.Visible=#v>0

local z=w.AbsoluteSize.X*y
local A=z/2
local B=x.AbsoluteSize.X*y

if B<=A then
x.AnchorPoint=Vector2.new(0,0.5)
x.Position=UDim2.new(0,5,0.5,0)
else
x.AnchorPoint=Vector2.new(1,0.5)
x.Position=UDim2.new(0.5,0,0.5,0)
end end




m.updateSearchBoxPosition=function(u)
local v=u.searchBox
local w=u.searchBoxHolder
local x=u.screenGui
local y=u.scrollHolder and u.scrollHolder.Parent

if not u.isEnabled or not(v and w and x and y)then return end

local z=x.AbsoluteSize
local A=math.max(e:getScale(),0.01)



local B=y.Position
local C=B.X.Scale*z.X+B.X.Offset*A
local D=B.Y.Scale*z.Y+B.Y.Offset*A



local E=C+(w.AbsolutePosition.X-y.AbsolutePosition.X)
local F=D+(w.AbsolutePosition.Y-y.AbsolutePosition.Y)


local G=w.AbsoluteSize
local H=math.max(math.min(G.X,z.X),1)
local I=math.max(math.min(G.Y,z.Y),1)

local J=u:calculateLabelSize()*o*A

local K=math.clamp(E,0,math.max(z.X-H,0))
local L=math.clamp(F+I+J,0,math.max(z.Y-I,0))


local M=UDim2.fromOffset(K/A,L/A)
local N=UDim2.fromOffset(H/A,I/A)


if v.Position~=M or v.Size~=N then
v.Position=M
v.Size=N
end end


m.updateSearchedCommand=function(u)
local v=u.commandInput.bestMatch
local w=u.commandInput.commandName
if w==""then return end

local x=q(w)
or(v and q(v))

if x then
u.scrollBar:scrollTo(x.commandData.position)
end end


m.setComment=function(u, v, w)
if w~=nil then
v=af.colorFromName(v,w)
end

u.inputComment.Text=v
u.inputComment.Visible=#v>0 end


m.updateElementColor=function(u, v, w)
local x=if w%2==1 then 1 else 0.96
v.BackgroundTransparency=x end


m.updateElements=function(u)
local v=0
local w=0
local x={}
local y=u.scrollBar
local z=u.commandsFolder

for A,B in u.commandsData do
local C=y:isVisible(B.position)

if not C then
if B.element then B.element.Parent=nil end
continue
end

local D=B.element
if not D then
D=u:createCommandElement(B)
B.element=D
end

if not B.isSection then
if#B.args>0 and#B.name>w then
w=#B.name
end
table.insert(x,B)
end

u:updateElementColor(D,A)
D.Parent=z
D.Position=UDim2.fromOffset(
0,
v*(D.Size.Y.Offset+u.configs.padding)
)
v=v+1
end

for A,B in x do
u:updateDisplayName(B,w+3)
end

u.visibleCommands=x end


m.setCommandInfo=function(u, v)
v=v or""

if v==""then
u.commandInfo.Visible=false
return
end

u.commandInfo.Visible=true
u.commandInfo.Text=v end


m.createSection=function(u, v)


local w=ad.new("TextLabel","Command",{
Size=UDim2.fromScale(1,1),
Position=UDim2.fromOffset(5,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Bottom,
RichText=true,
TextSize=u.configs.textSize-3,
Text=`<b>#{v.sectionName}</b>`,
ThemeTag={
TextColor3="Colors.Text.Darker",
Font="Font.MonoSpace"
},
})

return ad.new("Frame",{
Size=UDim2.new(1,-10,0,u.configs.labelSize),
BackgroundTransparency=1,

w
})end


m.createCommandElement=function(u, v)
if v.isSection then
return u:createSection(v)
end

local w=ad.new("TextLabel","Command",{
Size=UDim2.fromScale(0,1),
Position=UDim2.fromOffset(5,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
AutomaticSize=Enum.AutomaticSize.X,
RichText=true,
TextSize=u.configs.textSize,
ThemeTag={
TextColor3="Colors.Text.Default",
Font="Font.MonoSpace"
},
})

return ad.new("Frame",{
Size=UDim2.new(1,0,0,u.configs.labelSize),
AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,
w
})end


m.createCommandDescription=function(u, v)
if v.isSection then return end
if not v.description then return end

local w=ad.new("TextLabel","Description",{
Size=UDim2.fromScale(1,1),
Position=UDim2.fromOffset(25,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
RichText=true,
TextSize=u.configs.textSize,
ThemeTag={
TextColor3="Colors.Text.Dark",
Font="Font.MonoSpace"
},
})

return ad.new("Frame","Description",{
Size=UDim2.new(1,-30,0,u.configs.labelSize),
BackgroundTransparency=1,
w
})end


m.getCommandColor=function(u, v, w)
local x=q(v)

local y=
if type(x.run)~="function"then"undefined"
elseif w.isClient then"client"
elseif w.isDeprecated then"deprecated"
else nil

if y~=nil then
v=l(v,g[y])
end

return v end


m.updateDisplayName=function(u, v, w)
local x=v.element
local y=v.name

local z=string.rep("—",(w-#y)-2)

y=u:getCommandColor(y,v)
local A=`{y} {af.colorFromName(z,"comment")} `

local B=u.parser:highlightArgsType(v.args)
local C=A..B

if v.isHolding then
v.originalText=C
else
u:setCommandText(v,C)
end end


m.setCommandText=function(u, v, w)
local x=v.element
if not x then return end

x.Command.Text=w end


m.getCommandText=function(u, v)
local w=v.element
return w and w.Command.Text or""end


m.calculateTotalSpace=function(u)
return#u.commandsData end


m.calculateVisibleSpace=function(u)
local v=u.scrollContainer.AbsoluteSize.Y
return math.floor(v/u:calculateLabelSize())end


m.calculateLabelSize=function(u)
return u.configs.padding+u.configs.labelSize end


m.getElementMouseIn=function(u)
for v,w in u.visibleCommands do
if ac:isMouseInGuiObject(w.element)then
return w
end
end end


m.horizontalScroll=function(u, v)
for w,x in u.visibleCommands do
local y=x.element

y.Position=UDim2.fromOffset(
math.min(y.Position.X.Offset+v,0),
y.Position.Y.Offset
)
end end






m.showHoverDescription=function(u, v)
local w=u.inputComment
local x=u.hoverText~=nil and w.Text==u.hoverText

if not x then
if w.Text~=""then
u.hoverText=nil
return false
end

u.savedComment=w.Text
end

u.hoverText=af.colorFromName(v,"comment")
w.Text=u.hoverText
w.Visible=true
return true end


m.clearHoverDescription=function(u)
if u.hoverText==nil then return end

local v=u.inputComment


if v.Text==u.hoverText then
v.Text=u.savedComment or""
v.Visible=#v.Text>0
end

u.hoverText=nil
u.savedComment=nil end


m.updateHoverDescription=function(u)
local v

if u.interactive and ac:isMouseInGuiObject(u.scrollContainer)then
v=u:getElementMouseIn()
end

local w=v and v.description
if not w then
u.hoveredCommand=nil
u:clearHoverDescription()
return
end

if v==u.hoveredCommand then return end


if u:showHoverDescription(w)then
u.hoveredCommand=v
end end


m.startedHoldingContainer=function(u, v)
if not u.interactive then return end
if not ah.isPressingInput(v)then return end
if u.scrollBar:isScrollBarDisabled()then return end

u.scrollAxis=nil
u.scrollBar:disableScroll()

local w=ac:getMouse()
local x=u:calculateLabelSize()
local y=u:getElementMouseIn()
local z=tick()

if y and y.description then
y.isHolding=true

local A=u.parser.colorFromName(y.description,"comment")

y.originalText=u:getCommandText(y)
u:setCommandText(y,A)
end

local A=w.Y
local B=w.X



local C=w.Y
local D=u.scrollBar.index<=0
local E=0
local F=false

local G local H=function()


u.scrollBar:enableScroll()


if D and u.scrollAxis=="y"and E>=p and u.onSwipeDown then
F=true
u.onSwipeDown()
end

if y then
y.isHolding=nil

if y.originalText then
u:setCommandText(y,y.originalText)
y.originalText=nil
end

if(tick()-z)<=0.15 and not F then
u.commandClickedSignal:Fire(y)
end
end

if G then G:Disconnect()end end


ah.onReleaseEvent(H)

G=ah.onMouseEvent(function(I)

if not u.interactive then return end
E=w.Y-C

local J=w.X-B
local K=w.Y-A

if not u.scrollAxis then
if math.abs(J)>4 or math.abs(K)>4 then
u.scrollAxis=math.abs(J)>math.abs(K)and"x"or"y"
end
return
end

if u.scrollAxis=="x"then
local L=r(J/3)
if math.floor(L)~=0 then
u:horizontalScroll(L)
B=w.X
end
else
local L=r(K/x)
if math.floor(L)~=0 then
u.scrollBar:scrollTo(u.scrollBar.index-L)
A=w.Y
end
end
end)end


m.update=function(u)
u.scrollBar:setVisibleSpace(u:calculateVisibleSpace())
u.scrollBar:setTotalSpace(u:calculateTotalSpace())
u:updateElements()end


m.enable=function(u)
if u.isEnabled then return end
local v=u.scrollContainer
u.isEnabled=true

u.commandsFolder.Parent=v
u.searchBox.Parent=u.screenGui
u.searchBoxHolder.Parent=u.scrollHolder
u.commandInfo.Parent=u.scrollHolder

u.scrollConnection=u.scrolledSignal:Connect(function()
u:updateElements()
end)

u.containerConnection=v.InputBegan:Connect(function(w)
u:startedHoldingContainer(w)
end)

u:update()
u:updateSearchBoxPosition()


u.searchBoxConnection=aa:Connect(j.RenderStepped,function()
u:updateSearchBoxPosition()
end)


if not h then
u.hoverConnection=aa:Connect(j.RenderStepped,function()
u:updateHoverDescription()
end)
end end


m.disable=function(u)
if not u.isEnabled then return end
u.isEnabled=false

u.commandsFolder.Parent=nil
u.searchBox.Parent=nil
u.searchBoxHolder.Parent=nil
u.commandInfo.Parent=nil

aa:disconnect(u.containerConnection)
aa:disconnect(u.markerConnection)
aa:disconnect(u.scrollConnection)
aa:disconnect(u.searchBoxConnection)
aa:disconnect(u.hoverConnection)

u.hoveredCommand=nil
u:clearHoverDescription()end


m.new=function(u)local v=function(
v)
return assert(u.configs[v],`missing config.configs['{v}']`)end


local w=setmetatable({
scrollContainer=u.scrollContainer,
scrolledSignal=u.scrolledSignal,
scrollHolder=u.scrollHolder,
scrollBar=u.scrollBar,
screenGui=u.screenGui,

configs={
placeholderText=v"placeholderText",
padding=v"padding",
labelSize=v"labelSize",
textSize=v"textSize"
},

commandClickedSignal=b.new(),

interactive=true,

commandInput={
bestMatch=nil,
bestMatches={},
searchResult={},
isValidCommand=false,
highlightText="",
noHighlightText="",
fullCommandText="",
commandName=""
},

visibleCommands={},
commandsData={},
history={},
historyIndex=nil,
historyText="",
lastText="",
scrollToken=0,
},m)

w.parser=af.new(w.commandInput,function(x,y)
return w:setComment(x,y)
end)

return w end


return m end a.db=function()local ab=a.cache.db if not ab then ab={c=aa()}a.cache.db=ab end return ab.c end end do local aa=function()












local aa=a.c8()
local ab=a.P()
local ac=a.cz()

local ad=ab.UserInputService

local ae=0.28
local af=0.2
local ag=10

local ah={}
ah.__index=ah local ai=function(



ai)
return ai.UserInputType~=Enum.UserInputType.Touch end local b=function(



b, c)
if c==b.input then return true end
return b.isMouse and c.UserInputType==Enum.UserInputType.MouseMovement end local c=function(



c, d)
if d==c.input then return true end
return c.isMouse and d.UserInputType==c.input.UserInputType end




ah._resetDrag=function(d)
for e,f in d._pressConnections do
f:Disconnect()
end
table.clear(d._pressConnections)

d._press=nil
d.isDragging=false
d.draggingObject=nil
d.dragStart=nil
d.startPos=nil
d.lastPos=nil
d.pressTime=0
d.travel=0 end




ah._endPress=function(d, e)
if d._press~=e then return end

local f=d.isDragging
local g=d.draggingObject
local h

if f then
h={
duration=os.clock()-d.pressTime,
travel=d.travel,
dy=d.lastPos.Y-d.dragStart.Y,
}
end

d:_resetDrag()

if f then
d.dragEnded:Fire(g,h)
end end



ah._beginDrag=function(d, e)
if d.isDragging or d._press~=e then return end

d.isDragging=true
d.draggingObject=e.object
d.dragStarted:Fire(e.object)end



ah._onPressMoved=function(d, e, f)
if d._press~=e or not b(e,f)then return end

if e.isButton and not d.isDragging then
if(f.Position-d.dragStart).Magnitude<=ag then return end

d:_beginDrag(e)
end

if d.isDragging then
d:update(e.object,f)
end end




ah._startPress=function(d, e, f)
local g={
object=e,
input=f,
isMouse=ai(f),
isButton=e:IsA"GuiButton",
}

d._press=g
d.dragStart=f.Position
d.lastPos=f.Position
d.startPos=e.Position
d.pressTime=os.clock()
d.travel=0


d._pressConnections={
f.Changed:Connect(function()
if f.UserInputState==Enum.UserInputState.End then
d:_endPress(g)
end
end),
ad.InputChanged:Connect(function(h)
d:_onPressMoved(g,h)
end),
ad.InputEnded:Connect(function(h)
if c(g,h)then
d:_endPress(g)
end
end),
}

if not g.isButton then
d:_beginDrag(g)
return
end

task.delay(af,function()
d:_beginDrag(g)
end)end





ah.addGuiObject=function(d, e)
return e.InputBegan:Connect(function(f)
if not aa.isPressingInput(f)then return end
if d._press then return end

d:_startPress(e,f)
end)end


ah.update=function(d, e, f)
local g=f.Position-d.dragStart
local h=(d._uiScale and d._uiScale.Scale)or 1

d.lastPos=f.Position
d.travel=math.max(d.travel,g.Magnitude)

local i=UDim2.new(
d.startPos.X.Scale,
d.startPos.X.Offset+(g.X/h),
d.startPos.Y.Scale,
d.startPos.Y.Offset+(g.Y/h)
)

if d.filters[e]~=nil then
local j=d.filters[e](i,h)
i=j or i
end

e.Position=e.Position:Lerp(i,ae)
d.onDragged:Fire(e)end


ah.canDragObject=function(d, e)
return(not d.isDragging)or(d.draggingObject==e)end


ah.setFilter=function(d, 
e, 
f)

d.filters[e]=f end


ah.new=function(d)
return setmetatable({
isDragging=false,
draggingObject=nil,
_uiScale=d,
dragStart=nil,
startPos=nil,
lastPos=nil,
pressTime=0,
travel=0,
_press=nil,
_pressConnections={},
filters={},

onDragged=ac.new(),
dragStarted=ac.new(),
dragEnded=ac.new(),
},ah)end


return ah end a.dc=function()local ab=a.cache.dc if not ab then ab={c=aa()}a.cache.dc=ab end return ab.c end end do local aa=function()

local aa=a.cP().uiScale
return a.dc().new(aa)end a.dd=function()local ab=a.cache.dd if not ab then ab={c=aa()}a.cache.dd=ab end return ab.c end end do local aa=function()
local aa=a.cK().colorFromRGB
local ab=a.cR().commands

local ac=a.cS()local ad=function(

ad)
return ac:apply(ad)end


return{
cases={
{"all","- includes everyone"},
{"others","- includes everyone except you"},
{"me","- includes your player only"},
{"@username","- searches for players by username only (ignores displaynames)"},
{"#[number]","- gets a specified amount of random players"},
{"random","- affects a random player"},
{"%[team name]","- includes everyone on a given team"},
{"allies / team","- players who are on your team"},
{"enemies / nonteam","- players who are not on your team"},
{"friends","- anyone who is friends with you"},
{"nonfriends","- anyone who is not friends with you"},
{"guests","- guest players (obsolete)"},
{"bacons","- anyone with the \"bacon\" or pal hair"},
{"age[number]","- includes anyone below or at the given age"},
{"rad[number]","- includes anyone within the given radius"},
{"nearest","- gets the closest player to you"},
{"farthest","- gets the farthest player from you"},
{"group[ID]","- gets players who are in a certain group"},
{"alive","- gets players who are alive"},
{"dead","- gets players who are dead"},
},
sections={
{
{"title","Commands Colors"},
{"text",`{aa("COMMAND_UNDEFINED",ab.undefined)} -> This command don't work (BETA)`},
{"text",`{aa("CLIENT",ab.client)} -> Only works on client`},
{"text",`{aa("DEPRECATED",ab.deprecated)} -> This command is deprecated`}
},
{
{"title","Special Player Cases"},
{"text","These keywords can be used to quickly select groups of players in commands:"},
{"cases"},
},
{
{"title","Command Arguments"},
{"text","Some commands need extra information. Anything you type after the command name is an argument, and arguments are separated by spaces."},
{"text",`The gray hint in the command bar shows what each argument expects. For example, {ad"(fly_speed: number?)"} means you type a number.`},
{"bold","The ? means the argument is optional. You can leave it out and the command still runs."},
{"text",`Arguments are read in order, so optional ones go last. If a value has spaces, put it in quotes, like {ad'"John Doe"'}.`},
{"text","If something is wrong, the command bar tells you what to fix, and nothing runs."},
{"bold","Examples:"},
{"text",";fly 50 - fly at speed 50\n;fov 90 - set the field of view to 90\n;tppos 0,10,0 - teleport to X 0, Y 10, Z 0"},
},
{
{"title","What the Hint Words Mean"},
{"text",`<b>number</b> - a number, like 10 or 2.5\n<b>string</b> - text, like a name or a word\n<b>boolean</b> - yes or no. You can also type true/false or enabled/disabled\n<b>player</b> - a player name, or one of the special words above\n<b>vector3</b> - a position written as three numbers with commas: X,Y,Z, like 0,10,0\n<b>color3</b> - a color, written as {ad"#ff0000"} or as red,green,blue from 0 to 255\n<b>waypoint</b> - the name of a waypoint you saved\n<b>className</b> - a type of object in the game, like Part or Model\n<b>team</b> - the name of a team in the game\n<b>keycode</b> - a keyboard key, like E\n<b>command</b> - the name of a command\n<b>alias</b> - a shortcut name you made with addalias\n<b>plugin</b> - the name of a plugin you installed\n<b>object</b> - any text, nothing is checked`},
},
{
{"title","Various Operators"},
{"bold","Use commas to separate multiple expressions:"},
{"text",";locate noob,noob2,bob"},
{"bold","Use - to exclude, and + to include players in your expression:"},
{"text",";locate %blue-friends (gets players in blue team who aren't your friends)"},
{"bold","Put ! before a command to run it with the last arguments it was ran with:"},
{"text","After running ;offset 0 100 0,  you can run !offset anytime to repeat that command with the same arguments that were used to run it last time"},
},
{
{"title","Command Looping"},
{"bold","Form: [How many times it loops]^[delay (optional)]^[command]"},
{"text","Use the 'breakloops' command to stop all running loops."},
{"bold","Examples:"},
{"text",";5^btools - gives you 5 sets of btools\n;10^3^drophats - drops your hats every 3 seconds 10 times\n;inf^0.1^animspeed 100 - infinitely loops your animation speed to 100"},
},
{
{"title","Execute Multiple Commands at Once"},
{"bold",'You can execute multiple commands at once using "\\"'},
{"bold","Examples:"},
{"text",";drophats\\respawn - drops your hats and respawns you\n;enable inventory\\enable playerlist\\refresh - enables those coregui items and refreshes you"},
},
{
{"title","Browse Command History"},
{"text","While focused on the command bar, you can use the up and down arrow keys to browse recently used commands"},
},
{
{"title","Autocomplete in the Command Bar"},
{"text","While focused on the command bar, you can use the tab key to insert the top suggested command into the command bar."},
},
{
{"title","Using Event Binds"},
{"text","Use event binds to set up commands that get executed when certain events happen. You can edit the conditions for an event command to run (such as which player triggers it)."},
{"text","Some events may send arguments; you can use them in your event command by using $ followed by the argument number ($1, $2, etc). You can find out the order and types of these arguments by looking at the settings of the event command."},
{"bold","Example:"},
{"text","Setting up 'goto $1' on the OnChatted event will teleport you to any player that chats."},
},
{
{"title","Get Further Help"},
{"text","You can join the Discord server to get support with IY,  and read up on more documentation such as the Plugin API."},
{"invite"},
},
}
}end a.de=function()local ab=a.cache.de if not ab then ab={c=aa()}a.cache.de=ab end return ab.c end end do local aa=function()


local aa=a.cM()
local ab=a.dd()
local ac=a.c9()

local ad=a.cP()
local ae=a.au()
local af=a.a()
local ag=a.ap()

local ah=a.de()

local ai=500
local b=20
local c=300
local d=b+c

local e=12
local f=20
local g=40

local h=0.5
local i=2

local j=UDim2.new(0.5,-ai/2,0,-500)
local k=UDim2.new(0.5,-ai/2,0.5,-d/2)

local l={["&"]="&amp;",["<"]="&lt;",[">"]="&gt;"}

local m=ah.cases
local n=ah.sections

local o={}
o.__index=o local p=function(

p)
return(p:gsub("[&<>]",l))end local q=function(


q)
return aa.new("TextLabel","Header",{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Text=q,
TextSize=20,
TextXAlignment=Enum.TextXAlignment.Left,
ThemeTag={
Font="Font.Bold",
TextColor3="Colors.Text.Default",
},
})end local r=function(


r, s)
return aa.new("TextLabel",s and"Bold"or"Text",{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Text=r,
TextSize=14,
TextWrapped=true,
RichText=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
ThemeTag={
Font=s and"Font.Bold"or"Font.Normal",
TextColor3="Colors.Text.Default",
},
})end local s=function()



local s=aa.new("Frame","Cases",{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
aa.new("UIListLayout",{
Padding=UDim.new(0,2),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

for t,u in m do
local v,w=u[1],u[2]

aa.new("TextLabel","Case",s,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
LayoutOrder=t,
RichText=true,
Size=UDim2.new(1,0,0,0),
Text=`<b>{p(v)}</b> {p(w)}`,
TextSize=14,
TextWrapped=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
ThemeTag={
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},
})
end

return s end local t=function(


t)
local u=aa.new("TextButton","InviteButton",{
BorderSizePixel=0,
Size=UDim2.new(1,0,0,25),
Text=`Copy Discord Invite Link ({t})`,
TextSize=16,
ThemeTag={
BackgroundColor3="Colors.Primary",
Font="Font.Bold",
TextColor3="Colors.Text.Default",
},
})

local v=u.Text
local w

ae:Connect(u.Activated,function()
if af.setclipboard then
af.setclipboard(t)
u.Text="Copied"
else
u.Text="No Clipboard Function, type out the link"
end

local x=tick()
w=x

task.wait(i)
if w~=x then return end

u.Text=v
end)

return u end local u=function(


u)
local v=u[1]

if v=="title"then
return q(u[2])
elseif v=="cases"then
return s()
elseif v=="invite"then
return t(ag.links.discord)
end

return r(u[2],v=="bold")end local v=function(


v, w, x)
local y=aa.new("Frame","Section",{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
LayoutOrder=v,
Size=UDim2.new(1,0,0,0),
aa.new("UIPadding",{
PaddingBottom=UDim.new(0,8),
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
PaddingTop=UDim.new(0,5),
}),
aa.new("UIListLayout",{
Padding=UDim.new(0,4),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

for z,A in w do
local B=u(A)
B.LayoutOrder=z
B.Parent=y
end

if not x then
aa.new("Frame","Line",y,{
BorderSizePixel=0,
LayoutOrder=#w+1,
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Colors.Stroke",
},
})
end

return y end


o.new=function()
return setmetatable({},o)end


o.open=function(w)
w.frame:TweenPosition(k,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,h,true)end


o.close=function(w)
w.frame:TweenPosition(j,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,h,true)end


o.create=function(w)
local x=aa.new("Frame","ReferenceFrame",{
Active=true,
BorderSizePixel=0,
Position=j,
Size=UDim2.fromOffset(ai,d),
ThemeTag={
BackgroundColor3="Colors.Background",
},
})

local y=aa.new("Frame","TopBar",x,{
BorderSizePixel=0,
Size=UDim2.new(1,0,0,b),
ThemeTag={
BackgroundColor3="Colors.Background",
},
})

aa.new("TextLabel","Title",y,{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Text="Reference",
TextSize=16,
ThemeTag={
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},
})

local z=aa.new("TextButton","Close",y,{
BackgroundTransparency=1,
Position=UDim2.new(1,-b,0,0),
Size=UDim2.fromOffset(b,b),
Text="",
})

local A=aa.new("ImageLabel","Icon",z,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(5,5),
Size=UDim2.fromOffset(10,10),
ThemeTag={
ImageColor3="Colors.Icons",
},
})

local B=ac.new{
isHorizontal=false,
barThickness=e,
increment=f,
wheelIncrement=g,
}

local C=B:create()
local D=B.container

local E=aa.new("Frame","Content",D,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
aa.new("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

aa.new("Frame","ScrollHolder",x,{
Active=true,
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,b),
Size=UDim2.new(1,0,0,c),

C,
D,
})

for F,G in n do
local H=v(F,G,F==#n)
H.Parent=E
end local F=function(


F)
E.Position=UDim2.fromOffset(0,-F)end local G=function()



local G=ad:getScale()

B:setTotalSpace(math.ceil(E.AbsoluteSize.Y/G))
B:setVisibleSpace(math.ceil(D.AbsoluteSize.Y/G))
F(B.index)end


ae:Connect(B.scrolledSignal,F)
ae:Connect(E:GetPropertyChangedSignal"AbsoluteSize",G)
ae:Connect(D:GetPropertyChangedSignal"AbsoluteSize",G)

ae:Connect(z.Activated,function()
w:close()
end)

ab:addGuiObject(x)

ab.dragStarted:Connect(function(H)
if H~=x then return end
B:disableScroll()
end)

ab.dragEnded:Connect(function(H)
if H~=x then return end
B:enableScroll()
end)

G()

w.frame=x
w.closeIcon=A
w.scrollBar=B

return x end


return o end a.df=function()local ab=a.cache.df if not ab then ab={c=aa()}a.cache.df=ab end return ab.c end end do local aa=function()


return{
window={
title="Server",
width=250,
topBarHeight=20,
closeIconSize=15,
closeInset=2,
rowHeight=17,
rowGap=0,
textInset=5,
verticalPadding=3,
stripeTransparency=0.96,
shownY=100,
hiddenY=-500,
tweenTime=0.5,
updateInterval=1,
},

copyButton={
width=50,
height=15,
gap=6,
cornerRadius=6,
idleText="Copy",
copiedText="Copied",
feedbackTime=1.5,
},

textSizes={
title=16,
section=11,
value=14,
copyButton=12,
},

headers={
localPlayer="#player",
runTime="#run-time",
statistics="#statistics",
},

labels={
playerId="player-id:  ",
appearance="appearance: ",
players="players:     ",
maxPlayers="max-players: ",
gameId="game-id:     ",
placeId="place-id:    ",
placeName="place-name:  ",
},

time={
hour="Hour(s)",
minute="Minute(s)",
second="Second(s)",
},

messages={
loading="LOADING",
unknownPlace="Unknown",
alreadyEnabled="the info menu is already enabled",
noClipboard="this executor doesn't support clipboard",
},
}end a.dg=function()local ab=a.cache.dg if not ab then ab={c=aa()}a.cache.dg=ab end return ab.c end end do local aa=function()


local aa=a.cM()
local ab=a.cO()
local ac=a.cL()

local ad=a.dd()
local ae=a.cT()

local af=a.cK()

local ag=a.cP()
local ah=a.au()
local ai=a.a()
local b=a.Q()
local c=a.P()
local d=a.b()

local e=a.dg()
local f=a.cS()

local g=UDim2.new(0.5,-e.window.width/2,0,e.window.shownY)
local h=UDim2.new(0.5,-e.window.width/2,0,e.window.hiddenY)

local i={}local j=function(

j)
return f:apply(j)end local k=function(


k, l)
return`{af.escapeRichText(k)}{j(l)}`end local l=function(


l)
if l==nil then return false end

if ai.setclipboard then
ai.setclipboard(tostring(l))
return true
end

ae:notify(e.messages.noClipboard)
return false end local m=function(


m)
local n=e.time
local o=math.floor(m/3600)
local p=math.floor((m%3600)/60)
local q=math.floor(m%60)

if o>0 then
return`{o} {n.hour}, {p} {n.minute}, {q} {n.second}`
elseif p>0 then
return`{p} {n.minute}, {q} {n.second}`
end

return`{q} {n.second}`end local n=function()



local n,o=pcall(function()
return c.MarketplaceService:GetProductInfo(game.PlaceId)
end)

if n and o then
return o.Name
end

return e.messages.unknownPlace end local o=function(


o, p)
local q=e.copyButton

local r=aa.new("TextButton","Copy",o,{
AnchorPoint=Vector2.new(1,0.5),
AutoButtonColor=false,
BorderSizePixel=0,
Position=UDim2.new(1,-e.window.textInset,0.5,0),
Size=UDim2.fromOffset(q.width,q.height),
Text=q.idleText,
TextSize=e.textSizes.copyButton,
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,q.cornerRadius),
}),
})

ah:Connect(r.MouseEnter,function()
ac:updateObjectProperties(r,{
BackgroundColor3="Colors.Buttons.Holding",
})
end)

ah:Connect(r.MouseLeave,function()
ac:updateObjectProperties(r,{
BackgroundColor3="Colors.Buttons.Default",
})
end)

ah:Connect(r.Activated,function()
if not l(p())then return end

r.Text=q.copiedText
task.wait(q.feedbackTime)
r.Text=q.idleText
end)

return r end local p=function(


p, q, r, s)
local t=e.window
local u=t.textInset
local v=0

if s.getCopyValue then
v=e.copyButton.width+e.copyButton.gap
end

local w=aa.new("Frame","Row",p,{
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=(q%2==1)and t.stripeTransparency or 1,
BorderSizePixel=0,
LayoutOrder=q,
Size=UDim2.new(1,0,0,t.rowHeight),
})

local x=aa.new("TextLabel",s.name,w,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(u,0),
RichText=true,
Size=UDim2.new(1,-(u*2+v),1,0),
Text=r,
TextSize=s.textSize,
TextTruncate=Enum.TextTruncate.AtEnd,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,
ThemeTag={
Font="Font.MonoSpace",
TextColor3=s.textColor,
},
})

if s.getCopyValue then
o(w,s.getCopyValue)
end

return x end local q=function(


q, r, s)
return p(q,r,`<b>{af.escapeRichText(s)}</b>`,{
name="Section",
textSize=e.textSizes.section,
textColor="Colors.Text.Darker",
})end local r=function(


r, s, t, u)
return p(r,s,t,{
name="Value",
textSize=e.textSizes.value,
textColor="Colors.Text.Default",
getCopyValue=u,
})end local s=function()



local s=e.window

local t={
labels={},
placeName=nil,
}

local u=aa.new("Frame","ServerInfo",{
Active=true,
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Position=h,
Size=UDim2.fromOffset(s.width,0),

aa.new("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

local v=aa.new("Frame","TopBar",u,{
BorderSizePixel=0,
LayoutOrder=1,
Size=UDim2.new(1,0,0,s.topBarHeight),
ThemeTag={
BackgroundColor3="Colors.Background",
},
})

aa.new("TextLabel","Title",v,{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Text=s.title,
TextSize=e.textSizes.title,
ThemeTag={
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},
})

local w=aa.new("ImageButton","Exit",v,{
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Position=UDim2.new(1,-s.closeInset,0.5,0),
Size=UDim2.fromOffset(s.closeIconSize,s.closeIconSize),
ThemeTag={
ImageColor3="Colors.Icons",
},
})

ab:loadImage(w,"close")

ah:Connect(w.Activated,function()
i:close()
end)

local x=aa.new("Frame","Body",u,{
Active=true,
AutomaticSize=Enum.AutomaticSize.Y,
BorderSizePixel=0,
LayoutOrder=2,
Size=UDim2.new(1,0,0,0),
ThemeTag={
BackgroundColor3="Colors.Background",
},

aa.new("UIPadding",{
PaddingBottom=UDim.new(0,s.verticalPadding),
PaddingTop=UDim.new(0,s.verticalPadding),
}),

aa.new("UIListLayout",{
Padding=UDim.new(0,s.rowGap),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

local y=t.labels
local z=e.labels
local A=e.messages.loading

local B=0 local C=function()

B=B+1
return B end


q(x,C(),e.headers.localPlayer)

y.playerId=r(x,C(),k(z.playerId,b.UserId),function()
return b.UserId
end)

y.appearance=r(x,C(),k(z.appearance,b.CharacterAppearanceId),function()
return b.CharacterAppearanceId
end)

q(x,C(),e.headers.runTime)
y.time=r(x,C(),j(A))

q(x,C(),e.headers.statistics)
y.players=r(x,C(),k(z.players,A))
y.maxPlayers=r(x,C(),k(z.maxPlayers,A))

y.placeId=r(x,C(),k(z.placeId,game.PlaceId),function()
return game.PlaceId
end)

y.gameId=r(x,C(),k(z.gameId,game.GameId),function()
return game.GameId
end)

y.placeName=r(x,C(),k(z.placeName,A),function()
return t.placeName
end)

ad:addGuiObject(u)

t.frame=u
return t end local t=function(


t)
local u=t.labels
local v=e.labels
local w=c.Players

while i.window==t do
u.players.Text=k(v.players,#w:GetPlayers())
u.maxPlayers.Text=k(v.maxPlayers,w.MaxPlayers)
u.time.Text=j(m(workspace.DistributedGameTime))

task.wait(e.window.updateInterval)
end end


i.create=function(u)
if u.isEnabled then
ae:notify(e.messages.alreadyEnabled)
return
end

u.isEnabled=true

local v=s()
u.window=v

local w=e.window.tweenTime

v.frame.Parent=d.screenGui
v.frame:TweenPosition(g,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,w,true)

task.spawn(function()
v.placeName=n()
v.labels.placeName.Text=k(e.labels.placeName,v.placeName)
end)

task.spawn(t,v)

return v end


i.close=function(u)
local v=u.window
if not v then return end

local w=e.window.tweenTime

u.window=nil
u.isEnabled=false

v.frame:TweenPosition(h,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,w,true)

task.delay(w,function()
v.frame:Destroy()
end)end


return i end a.dh=function()local ab=a.cache.dh if not ab then ab={c=aa()}a.cache.dh=ab end return ab.c end end do local aa=function()


return{
title="Chat Logs",
maxLabels=200,

window={
width=340,
height=240,
topBarHeight=20,
rowHeight=22,
closeIconSize=10,
buttonCorner=6,
buttonInset=2,
tabInset=0,
stripeTransparency=0.96,
entryHoverTransparency=0.88,
shownX=12,
shownY=100,
hiddenX=-360,
tweenTime=0.28,
tabTweenTime=0.2,
},

scrollBar={
barThickness=12,
increment=20,
wheelIncrement=40,
},

textSizes={
title=16,
control=12,
tab=13,
entry=13,
},

tabs={
chat="Chat",
join="Joins",
},

controls={
enabled="Enabled",
disabled="Disabled",
save="Save",
clear="Clear",
},

messages={
saved="Saved",
saveFailed="Save failed",


copied="Copied",
chatCopied="Message copied to the clipboard",
joinCopied="User ID copied to the clipboard:",
noClipboard="Your executor has no clipboard function",
},
}end a.di=function()local ab=a.cache.di if not ab then ab={c=aa()}a.cache.di=ab end return ab.c end end do local aa=function()



local aa=a.cM()
local ab=a.cO()
local ac=a.cL()
local ad=a.dd()
local ae=a.cP()
local af=a.c9()
local ag=a.cT()

local ah=a.b()
local ai=a.di()
local b=a.P()
local c=a.a()
local d=a.cE()
local e=a.bG()
local f=a.cR().args
local g=a.cS()
local h=a.cK()
local i=a.al()

local j=ai.window
local k=j.topBarHeight
local l=k+j.rowHeight
local m=UDim2.new(0,j.shownX,0,j.shownY)
local n=UDim2.new(0,j.hiddenX,0,j.shownY)


local o,p=0,0.125
local q,r=0.125,0.125
local s,t=0.25,0.25
local u,v=0.5,0.5


local w=0.5
local x={chat=0,join=0.5}
local y=j.tabInset
local z=UDim.new(0.5,0)


local A=j.entryHoverTransparency

local B={
window=nil,
listening=false,
}local C=function(


C, D, E)
local F=j.buttonInset
C.Position=UDim2.new(D,F,0,F)
C.Size=UDim2.new(E,-F*2,1,-F*2)end local D=function(



D, E)
ac:updateObjectProperties(D,{BackgroundColor3=E})end local E=function(


E)
return e[if E=="chat"then"chatEnabled"else"joinEnabled"]end local F=function(


F, G)
i:setValue(`chatlogs.{F}.enabled`,G==true)
i:save()end local G=function(


G, H)
H(i:getValue(`chatlogs.{G}.enabled`)==true)end local H=function(


H, I)
local J=h.colorFromRGB(`[{I.time}]`,f.comment)
local K=`<b>{h.colorFromRGB(h.escapeRichText(I.name),I.color or f.others)}</b>`

if H=="chat"then
return`{J} {K}: {g:apply(I.message)}`
end
return`{J} {K} {g:apply(`joined (id {I.userId})`)}`end local I=function(



I, J)
if I=="chat"then
return tostring(J.message)
end
return tostring(J.userId)end local J=function(


J, K)
if not c.setclipboard then
ag:notify(ai.messages.copied,ai.messages.noClipboard)
return
end

local L=I(J,K)
c.setclipboard(L)

if J=="chat"then
ag:notify(ai.messages.copied,ai.messages.chatCopied)
else
ag:notify(ai.messages.copied,`{ai.messages.joinCopied} {L}`)
end end local K=function(


K, L)
return K.tabButtons[K.tab]==L end local L=function(


L)
for M,N in L.tweens do
N:Cancel()
end
table.clear(L.tweens)end local M=function(



M, N)
L(M)

local O=UDim2.new(x[M.tab],y,0,y)
local P=d:getScale(j.tabTweenTime)
if not N or P<=0 then
M.thumb.Position=O
return
end

local Q=TweenInfo.new(P,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
local R=b.TweenService:Create(M.thumb,Q,{
Position=O,
})
table.insert(M.tweens,R)
R:Play()end local N=function(


N)
local O=E(N.tab)
N.toggle.Text=if O then ai.controls.enabled else ai.controls.disabled
D(N.toggle,if O then"Colors.OnPrimary"else"Colors.Buttons.Default")

for P,Q in N.actions do
D(Q,"Colors.Buttons.Default")
end


for P,Q in N.tabButtons do
Q.BackgroundTransparency=1
end end local O=function(


O)
for P,Q in O.connections do
Q:Disconnect()
end
table.clear(O.connections)end local P=function(


P, Q, R)
table.insert(P.connections,Q:Connect(R))end local Q=function(


Q, R)
P(Q,R.MouseEnter,function()
if not K(Q,R)then
D(R,"Colors.Buttons.Holding")
R.BackgroundTransparency=0
end
end)

P(Q,R.MouseLeave,function()
N(Q)
end)end local R=function(


R, S, T, U, W)
local X=aa.new("TextButton",S,R,{
AutoButtonColor=false,
BorderSizePixel=0,
Text=T,
TextSize=ai.textSizes.control,
TextTruncate=Enum.TextTruncate.AtEnd,
ThemeTag={
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,j.buttonCorner),
}),
})

C(X,U,W)
return X end local S=function(



S, T)
S.Position=UDim2.new(T,y,0,y)
S.Size=UDim2.new(w,-y*2,1,-y*2)end local T=function(



T, U, W, X)
local Y=aa.new("TextButton",U,T,{
AutoButtonColor=false,
BackgroundTransparency=1,
BorderSizePixel=0,
Text=W,
TextSize=ai.textSizes.tab,
TextTruncate=Enum.TextTruncate.AtEnd,
ThemeTag={
Font="Font.Bold",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=z,
}),
})

S(Y,X)
return Y end local U=function(


U)
U.content.Position=UDim2.fromOffset(0,-U.scrollBar.index)end local W=function(


W)
local X=ae:getScale()
W.scrollBar:setTotalSpace(math.ceil(W.content.AbsoluteSize.Y/X))
W.scrollBar:setVisibleSpace(math.ceil(W.container.AbsoluteSize.Y/X))
U(W)end local X=function(


X)
for Y,Z in X.labels do
Z:Destroy()
end
table.clear(X.labels)end local aj=function(


Y, Z, _)
Y.order=Y.order+1

local aj=if Y.order%2==1 then j.stripeTransparency else 1

local ak=aa.new("TextButton","Entry",Y.content,{
AutoButtonColor=false,
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=aj,
BorderSizePixel=0,
LayoutOrder=Y.order,
Size=UDim2.new(1,0,0,0),
RichText=true,
Text=H(Z,_),
TextSize=ai.textSizes.entry,
TextWrapped=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
ThemeTag={
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},
})


ak.MouseEnter:Connect(function()
ak.BackgroundTransparency=A
end)
ak.MouseLeave:Connect(function()
ak.BackgroundTransparency=aj
end)
ak.Activated:Connect(function()
J(Z,_)
end)

table.insert(Y.labels,ak)
while#Y.labels>ai.maxLabels do
table.remove(Y.labels,1):Destroy()
end


task.defer(function()
if Y.frame.Parent then
W(Y)
Y.scrollBar:scrollTo(math.huge)
end
end)end local ak=function(


ak, Y)
X(ak)

for Z,_ in e.entries[ak.tab]do
aj(ak,ak.tab,_)
end

N(ak)
M(ak,Y==true)end local al=function(


Y)
local Z={
tab=Y,
labels={},
order=0,
connections={},
tweens={},
}

local _=aa.new("Frame","ChatLogs",{
Active=true,
BorderSizePixel=0,
Position=n,
Size=UDim2.fromOffset(j.width,j.height),
ThemeTag={
BackgroundColor3="Colors.Background",
},
})
Z.frame=_


local al=aa.new("Frame","TopBar",_,{
BorderSizePixel=0,
Size=UDim2.new(1,0,0,k),
ThemeTag={
BackgroundColor3="Colors.Background",
},
})

aa.new("TextLabel","Title",al,{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Text=ai.title,
TextSize=ai.textSizes.title,
ThemeTag={
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},
})

local am=aa.new("TextButton","Close",al,{
BackgroundTransparency=1,
Position=UDim2.new(1,-k,0,0),
Size=UDim2.fromOffset(k,k),
Text="",
})

local an=aa.new("ImageLabel","Icon",am,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(5,5),
Size=UDim2.fromOffset(j.closeIconSize,j.closeIconSize),
ThemeTag={
ImageColor3="Colors.Icons",
},
})
ab:loadImage(an,"close")


local ao=aa.new("Frame","Controls",_,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,k),
Size=UDim2.new(1,0,0,j.rowHeight),
})

local ap=R(ao,"Clear",ai.controls.clear,o,p)
local aq=R(ao,"Save",ai.controls.save,q,r)
Z.toggle=R(ao,"Toggle",ai.controls.enabled,s,t)


local ar=aa.new("Frame","Switch",ao,{
BorderSizePixel=0,
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
},

aa.new("UICorner",{
CornerRadius=z,
}),
})
C(ar,u,v)

Z.thumb=aa.new("Frame","Thumb",ar,{
BorderSizePixel=0,
ThemeTag={
BackgroundColor3="Colors.Border.Holding",
},

aa.new("UICorner",{
CornerRadius=z,
}),
})
S(Z.thumb,x.chat)

local as=T(ar,"ChatTab",ai.tabs.chat,x.chat)
local at=T(ar,"JoinTab",ai.tabs.join,x.join)

Z.tabButtons={chat=as,join=at}
Z.actions={aq,ap}


local au=af.new{
isHorizontal=false,
barThickness=ai.scrollBar.barThickness,
increment=ai.scrollBar.increment,
wheelIncrement=ai.scrollBar.wheelIncrement,
}
local av=au:create()
local aw=au.container

local ax=aa.new("Frame","Content",aw,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),

aa.new("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

aa.new("Frame","ScrollHolder",_,{
Active=true,
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,l),
Size=UDim2.new(1,0,1,-l),

av,
aw,
})

Z.scrollBar=au
Z.container=aw
Z.content=ax

P(Z,au.scrolledSignal,function()
U(Z)
end)
P(Z,ax:GetPropertyChangedSignal"AbsoluteSize",function()
W(Z)
end)
P(Z,aw:GetPropertyChangedSignal"AbsoluteSize",function()
W(Z)
end)
P(Z,ad.dragStarted,function(ay)
if ay==_ then
au:disableScroll()
end
end)
P(Z,ad.dragEnded,function(ay)
if ay==_ then
au:enableScroll()
end
end)

P(Z,am.Activated,function()
B:close()
end)

P(Z,as.Activated,function()
B:select"chat"
end)

P(Z,at.Activated,function()
B:select"join"
end)

P(Z,Z.toggle.Activated,function()
local ay=E(Z.tab)
if Z.tab=="chat"then
e.setChat(not ay)
else
e.setJoin(not ay)
end

F(Z.tab,not ay)
N(Z)
end)

P(Z,aq.Activated,function()
local ay,az=e.save(Z.tab)
if ay then
ag:notify(ai.messages.saved,az)
else
ag:notify(ai.messages.saveFailed,az)
end
end)

P(Z,ap.Activated,function()
e.clear(Z.tab)
X(Z)
end)

for ay,az in{as,at,Z.toggle,aq,ap}do
Q(Z,az)
end

return Z end local am=function()




if B.listening then
return
end
B.listening=true

e.onEntry(function(am,an)
local ao=B.window
if ao and ao.tab==am then
aj(ao,am,an)
end
end)end


B.restore=function(an)
G("chat",e.setChat)
G("join",e.setJoin)end


B.open=function(an, ao)
an:restore()

am()

local ap=an.window
if ap then
an:select(ao)
return ap
end

ap=al(ao)
an.window=ap

ap.frame.Parent=ah.screenGui
ap.frame:TweenPosition(m,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,j.tweenTime,true)
ad:addGuiObject(ap.frame)

ak(ap)
return ap end


B.select=function(an, ao)
local ap=an.window
if not ap then
return
end

ap.tab=ao
ak(ap,true)end


B.close=function(an)
local ao=an.window
if not ao then
return
end

an.window=nil
O(ao)
L(ao)

ao.frame:TweenPosition(n,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,j.tweenTime,true)
task.delay(j.tweenTime,function()
ao.frame:Destroy()
end)end



B.reset=function(an)
local ao=an.window
if ao then
O(ao)
L(ao)
end
an.window=nil end


return B end a.dj=function()local ab=a.cache.dj if not ab then ab={c=aa()}a.cache.dj=ab end return ab.c end end do local aa=function()












local aa=a.cW()

return{

keys={
keepMenuOpen="interface.keepMenuOpen",
keepIY=aa.settingKey,
clearOnEnter="clearOnEnter",
theme="selectedTheme",
},


panel={
shownY=0,
hiddenY=1,
tweenTime=0.5,
padding=5,
rowHeight=25,
rowGap=4,
headerHeight=16,
stripeTransparency=0.5,
scrollBarThickness=4,
floatBackSize=25,
floatBackMargin=6,
floatBackFlat=0.3,
floatBackOut=0.5,
floatBackTime=0.35,
},

row={
labelInset=28,
iconInset=5,
iconSize=16,
chevronSize=14,
},

box={
size=16,
inset=4,
cornerRadius=3,
fillCornerRadius=2,
},

value={
width=20,
height=16,
cornerRadius=4,
keybindWidth=88,
aliasWidth=110,
inputWidth=110,
formDelayWidth=46,
addWidth=44,
delayWidth=44,
buttonWidth=36,
reloadWidth=52,
positionWidth=92,
},


badge={
height=12,
overhang=3,
},

textSizes={
header=12,
label=14,
value=12,
footer=11,
badge=10,
},


footer="{name} {version}",


pages={
back="Back",
backIcon="lucide-chevron-left",

theme={
title="#theme",
incomplete="(incomplete)",
},
keybinds={
title="#keybinds",
reset="Reset to defaults",
alwaysWorks="%s also works as the %s",
},
aliases={
title="#aliases",
addTitle="#add alias",
aliasHint="alias",
commandHint="command it runs",
addButton="Add alias",
listTitle="#custom aliases",
listHint="tap an alias to remove it",
empty="no custom aliases yet",
missing="write the alias and the command it runs",
spaces="an alias can't have spaces",
badCharacters="an alias can't have \\ ^ ! , | & or quotes: the command bar reads them as something else",
added="added '%s'",
removed="removed '%s'",
notifyTitle="Aliases",
undoTitle="Alias Removed",
undoMessage="'%s' ran '%s'",
undo="Undo",
undoTime=10,
restored="restored '%s'",
},
waypoints={
title="#waypoints",
notifyTitle="Waypoints",
newTitle="#new waypoint",
nameHint="name",
positionHint="x, y, z",
addButton="Add",
formHint="no position saves where you are standing",
modeTitle="#tap a waypoint to",

modes={
{mode="teleport",label="Teleport"},
{mode="tween",label="Tween"},
{mode="walk",label="Walk"},
},
markers="Show markers in the world",
listTitle="#waypoints of this game",
listHint="tap one to go there, Del removes it",
empty="no waypoints in this game yet",
delete="Del",
clearTitle="#clear",
clearGame="Clear this game",
clearAll="Clear every game",
missingName="write a name for the waypoint",
badPosition="the position needs 3 numbers, like 10, 5, -20",
noCharacter="your character was not found",
noMarkers="there are no waypoints to show",
saved="saved '%s' at %s",
updated="updated '%s' to %s",
went="teleported to '%s' %s",
wentTween="tweening to '%s' %s",
wentWalk="walking to '%s' %s",
cantGo="can't go there: your character was not found",
removed="removed '%s'",
restored="restored '%s'",
nameTaken="there is already a waypoint named '%s'",
undoTitle="Waypoint Removed",
undoMessage="'%s' %s was removed",
undo="Undo",
undoTime=10,
confirmTitle="Clear Waypoints",
confirmGame="Delete the %d waypoint(s) of this game?",
confirmAll="Delete the %d waypoint(s) of every game?",
confirmClear="Delete",
confirmCancel="Cancel",
cleared="deleted %d waypoint(s)",
nothingToClear="there are no waypoints to delete",
},
plugins={
title="#plugins",
notifyTitle="Plugins",
errorTitle="Plugin Error",
addTitle="#add plugin",
fileHint="plugin file name",
addButton="Add plugin",
folderHint="plugins are .luau files in the %s folder",
trustHint="a plugin runs code with full access: only add files you trust",
installedTitle="#installed plugins",
installedHint="tap a plugin to see its state, Reload reads its file again",
noneInstalled="no plugins installed yet",
folderTitle="#in the plugins folder",
noneInFolder="no new plugins in the folder",
add="Add",
addAll="Add all (%d)",
reload="Reload",
remove="Del",
failedLabel="%s (failed)",
loadedLabel="%s (%d)",
stateLoaded="'%s' is loaded with %d command(s)",
stateFailed="'%s' did not load: %s",
stateUnknown="'%s' is installed but not loaded",
added="added '%s' (%d command(s))",
reloaded="reloaded '%s' (%d command(s))",
removed="removed '%s'",
missingName="write the file name of the plugin",
addedAll="added %d plugin(s)",
failedAll=", %d failed (see the console)",
},
eventBinds={
title="#event binds",
notifyTitle="Event Binds",
notAdded="the bind was not added",
columns=4,
commandHint="command (goto $1)",
delayHint="delay",

conditionHints={
Player="any, me, friends...",
String="any, or text",
Number="any, or max",
},
addButton="Add",
header="#%s - %s",
listTitle="#binds of %s",
listHint="tap a bind to remove it, or type a new delay in its box",
empty="no binds for this event yet",
badDelay="the delay must be a number",
negativeDelay="the delay must be 0 or more",
added="added a bind to %s",
removed="removed '%s'",
delayChanged="the delay of '%s' is now %s",
restored="restored '%s'",
undoTitle="Bind Removed",
undoMessage="'%s' was removed from #%s",
undoDelay="delay %s",
undo="Undo",
undoTime=10,
},
},

sections={
{
title="#general",
options={
{kind="keybind",label="Prefix",icon="lucide-terminal",binding="prefix"},
{kind="switch",label="Keep Menu Open",icon="lucide-pin",setting="keepMenuOpen"},
{kind="switch",label="Keep Interface",icon="lucide-refresh-cw",setting="keepIY"},
{kind="switch",label="Clear On Enter",icon="lucide-eraser",setting="clearOnEnter"},
},
},
{
title="#editors",
options={
{kind="button",label="Edit Theme",icon="lucide-palette",action="theme"},
{kind="button",label="Edit Keybinds",icon="lucide-keyboard",action="keybinds"},
{kind="button",label="Edit Aliases",icon="lucide-tag",action="aliases"},
{kind="button",label="Edit/Goto Waypoints",icon="lucide-map-pin",action="waypoints"},
{kind="button",label="Manage Plugins",icon="lucide-puzzle",action="plugins"},
{kind="button",label="Edit Event Binds",icon="lucide-zap",action="eventBinds"},
},
},
},
}end a.dk=function()local ab=a.cache.dk if not ab then ab={c=aa()}a.cache.dk=ab end return ab.c end end do local aa=function()








local aa=a.cM()
local ab=a.cO()
local ac=a.cL()
local ad=a.ax()
local ae=a.dk()

local af=ae.panel
local ag=ae.row
local ah=ae.box
local ai=ae.value
local aj=ae.textSizes
local ak=ae.badge

local al={}local am=function(


am, an, ao)
ac:updateObjectProperties(am,{
BackgroundColor3=if ao then"Colors.Buttons.Holding"else"Colors.Buttons.Default",
})
am.BackgroundTransparency=if ao then 0 else an end



al.page=function(an, ao, ap)
return aa.new("ScrollingFrame",ao,an,{
Active=true,
AutomaticCanvasSize=Enum.AutomaticSize.Y,
BorderSizePixel=0,
CanvasSize=UDim2.new(),
ElasticBehavior=Enum.ElasticBehavior.Never,
Position=ap,
ScrollBarThickness=af.scrollBarThickness,
ScrollingDirection=Enum.ScrollingDirection.Y,
Size=UDim2.fromScale(1,1),
ThemeTag={
BackgroundColor3="Colors.Background",
ScrollBarImageColor3="Colors.ScrollBar.Thumb",
},

aa.new("UIPadding",{
PaddingLeft=UDim.new(0,af.padding),
PaddingRight=UDim.new(0,af.padding),
PaddingTop=UDim.new(0,af.padding),
PaddingBottom=UDim.new(0,af.padding),
}),
aa.new("UIListLayout",{
Padding=UDim.new(0,af.rowGap),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})end local an=function(



an)
ac:removeObject(an)

for ao,ap in an:GetDescendants()do
ac:removeObject(ap)
end end



al.clear=function(ao)
for ap,aq in ao:GetChildren()do
if not(aq:IsA"UIListLayout"or aq:IsA"UIPadding")then
an(aq)
aq:Destroy()
end
end end



al.list=function(ao)
return{parent=ao,order=0,index=0}end



al.group=function(ao)
ao.order=ao.order+1

return aa.new("Frame","Group",ao.parent,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
BorderSizePixel=0,
LayoutOrder=ao.order,
Size=UDim2.new(1,0,0,0),

aa.new("UIListLayout",{
Padding=UDim.new(0,af.rowGap),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})end


al.header=function(ao, ap)
ao.order=ao.order+1
ao.index=0

return aa.new("TextLabel","Header",ao.parent,{
BackgroundTransparency=1,
LayoutOrder=ao.order,
Size=UDim2.new(1,0,0,af.headerHeight),
Text=ap,
TextSize=aj.header,
TextXAlignment=Enum.TextXAlignment.Left,
ThemeTag={
Font="Font.MonoSpace",
TextColor3="Colors.Text.Darker",
},
})end



al.row=function(ao)
ao.order=ao.order+1
ao.index=ao.index+1

local ap=if ao.index%2==1 then af.stripeTransparency else 1

local aq=aa.new("TextButton","Option",ao.parent,{
AutoButtonColor=false,
BackgroundTransparency=ap,
BorderSizePixel=0,
LayoutOrder=ao.order,
Size=UDim2.new(1,0,0,af.rowHeight),
Text="",
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
},
})


aq.MouseEnter:Connect(function()
am(aq,ap,true)
end)

aq.MouseLeave:Connect(function()
am(aq,ap,false)
end)

return aq end



al.pageTop=function(ao, ap, aq)
local ar=al.row(ao)
ar.Name="BackRow"
al.icon(ar,ae.pages.backIcon)
al.label(ar,ae.pages.back,0)
ar.Activated:Connect(aq)

if ap then
al.header(ao,ap)
end end



al.label=function(ao, ap, aq, ar)
return aa.new("TextLabel","Label",ao,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(ag.labelInset,0),
Size=UDim2.new(1,-(ag.labelInset+aq),1,0),
Text=ap,
TextSize=aj.label,
TextTruncate=Enum.TextTruncate.AtEnd,
TextXAlignment=Enum.TextXAlignment.Left,
ThemeTag={
Font="Font.Normal",
TextColor3=ar or"Colors.Text.Default",
},
})end


al.icon=function(ao, ap)
local aq=aa.new("ImageLabel","Icon",ao,{
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
Position=UDim2.new(0,ag.iconInset,0.5,0),
Size=UDim2.fromOffset(ag.iconSize,ag.iconSize),
ThemeTag={
ImageColor3="Colors.Icons",
},
})

ab:loadImage(aq,ap)
return aq end



al.chevron=function(ao)
local ap=aa.new("ImageLabel","Chevron",ao,{
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Position=UDim2.new(1,-af.padding,0.5,0),
Rotation=180,
Size=UDim2.fromOffset(ag.chevronSize,ag.chevronSize),
ThemeTag={
ImageColor3="Colors.Text.Darker",
},
})

ab:loadImage(ap,ae.pages.backIcon)
return ap end






al.rowButton=function(ao, ap, aq, ar)
local as=aa.new("TextButton","RowButton",ao,{
AnchorPoint=Vector2.new(1,0.5),
AutoButtonColor=false,
BorderSizePixel=0,
Position=UDim2.new(1,-aq,0.5,0),
Size=UDim2.fromOffset(ar,ai.height+4),
Text=ap,
TextSize=aj.value,
ThemeTag={
BackgroundColor3="Colors.Background",
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})

as.MouseEnter:Connect(function()
ac:updateObjectProperties(as,{
BackgroundColor3="Colors.Primary",
})
end)

as.MouseLeave:Connect(function()
ac:updateObjectProperties(as,{
BackgroundColor3="Colors.Background",
})
end)

return as end



al.box=function(ao)
local ap=aa.new("Frame","Box",ao,{
AnchorPoint=Vector2.new(1,0.5),
BorderSizePixel=0,
Position=UDim2.new(1,-af.padding,0.5,0),
Size=UDim2.fromOffset(ah.size,ah.size),
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ah.cornerRadius),
}),
aa.new("UIStroke",{
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
Thickness=1,
ThemeTag={
Color="Colors.Border.Default",
},
}),
})

local aq=aa.new("Frame","Fill",ap,{
BorderSizePixel=0,
Position=UDim2.fromOffset(ah.inset,ah.inset),
Size=UDim2.new(1,-2*ah.inset,1,-2*ah.inset),
ThemeTag={
BackgroundColor3="Colors.Primary",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ah.fillCornerRadius),
}),
})

return ap,aq end



al.value=function(ao, ap, aq)
local ar=aa.new("Frame","Value",ao,{
AnchorPoint=Vector2.new(1,0.5),
BorderSizePixel=0,
Position=UDim2.new(1,-af.padding,0.5,0),
Size=UDim2.fromOffset(aq,ai.height),
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})

local as=aa.new("TextLabel","Text",ar,{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Text=ap,
TextSize=aj.value,
TextTruncate=Enum.TextTruncate.AtEnd,
ThemeTag={
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},
})

return ar,as end



al.valueInput=function(ao, ap, aq)
return aa.new("TextBox","ValueInput",ao,{
AnchorPoint=Vector2.new(1,0.5),
BorderSizePixel=0,
ClearTextOnFocus=false,
Position=UDim2.new(1,-af.padding,0.5,0),
Size=UDim2.fromOffset(aq,ai.height),
Text=ap,
TextSize=aj.value,
TextXAlignment=Enum.TextXAlignment.Center,
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})end





al.keybind=function(ao, ap, aq)
local ar,as=al.value(ao,"",ai.keybindWidth)
local at local au=function()


local au=at~=nil

as.Text=if au then"press a key"else ad:getBindingName(ap)
ac:updateObjectProperties(ar,{
BackgroundColor3=if au then"Colors.Primary"else"Colors.Buttons.Default",
})end local av=function()



if at then
local av=at
at=nil
av()
end

au()end


ao.Activated:Connect(function()
if at then
av()
return
end

at=ad:capture(function(aw)
at=nil
ad:setBinding(ap,aw)
au()

if aq then
aq()
end
end,function()

at=nil
au()
end)

au()
end)

au()
return au,av end



al.textBox=function(ao, ap)
ao.order=ao.order+1

return aa.new("TextBox","Input",ao.parent,{
BorderSizePixel=0,
ClearTextOnFocus=false,
LayoutOrder=ao.order,
PlaceholderText=ap,
Size=UDim2.new(1,0,0,af.rowHeight),
Text="",
TextSize=aj.value,
TextXAlignment=Enum.TextXAlignment.Left,
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
Font="Font.MonoSpace",
PlaceholderColor3="Colors.Text.Darker",
TextColor3="Colors.Text.Default",
},

aa.new("UIPadding",{
PaddingLeft=UDim.new(0,ag.labelInset/2),
PaddingRight=UDim.new(0,af.padding),
}),
aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})end local ao=function(



ao)
return aa.new("TextLabel","Badge",ao,{
AnchorPoint=Vector2.new(1,0),
AutomaticSize=Enum.AutomaticSize.X,
BorderSizePixel=0,
Position=UDim2.new(1,ak.overhang,0,-ak.overhang),
Size=UDim2.fromOffset(0,ak.height),
Text="",
TextSize=aj.badge,
Visible=false,
ZIndex=ao.ZIndex+1,
ThemeTag={
BackgroundColor3="Colors.Primary",
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ak.height/2),
}),
aa.new("UIPadding",{
PaddingLeft=UDim.new(0,3),
PaddingRight=UDim.new(0,3),
}),
aa.new("UIStroke",{
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
Thickness=1,
ThemeTag={
Color="Colors.Background",
},
}),
})end





al.choices=function(ap, aq, ar, as)
ap.order=ap.order+1

local at=af.rowGap
local au=aa.new("Frame","Choices",ap.parent,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
BorderSizePixel=0,
LayoutOrder=ap.order,
Size=UDim2.new(1,0,0,0),

aa.new("UIGridLayout",{
CellPadding=UDim2.fromOffset(at,at),
CellSize=UDim2.new(1/as,-at*(as-1)/as-1,0,af.rowHeight-3),
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

local av={}
local aw={}local ax=function(

ax)
for ay,az in av do
ac:updateObjectProperties(az,{
BackgroundColor3=if ay==ax then"Colors.Primary"else"Colors.Buttons.Default",
})
end end


for ay,az in aq do
local b=aa.new("TextButton","Choice",au,{
AutoButtonColor=false,
BorderSizePixel=0,
LayoutOrder=ay,
Text=az,
TextSize=aj.value,
TextTruncate=Enum.TextTruncate.AtEnd,
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})

av[ay]=b
aw[ay]=ao(b)

b.Activated:Connect(function()
ax(ay)
ar(ay)
end)
end local ay=function(


ay, az)
local b=aw[ay]
if not b then return end

b.Text=tostring(az)
b.Visible=az>0 end


return ax,ay end



al.inputRow=function(ap, aq, ar, as)
local at=al.row(ap)
al.label(at,aq,ai.inputWidth+2*af.padding)

local au=aa.new("TextBox","Input",at,{
AnchorPoint=Vector2.new(1,0.5),
BorderSizePixel=0,
ClearTextOnFocus=false,
PlaceholderText=ar,
Position=UDim2.new(1,-af.padding,0.5,0),
Size=UDim2.fromOffset(ai.inputWidth,ai.height),
Text=as or"",
TextSize=aj.value,
TextTruncate=Enum.TextTruncate.AtEnd,
ThemeTag={
BackgroundColor3="Colors.Background",
Font="Font.MonoSpace",
PlaceholderColor3="Colors.Text.Darker",
TextColor3="Colors.Text.Default",
},

aa.new("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
}),
aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})

return at,au end




al.formRow=function(ap, aq, ar, as, at)
ap.order=ap.order+1

local au=af.rowGap
local av=ai.addWidth
local aw=at or ai.formDelayWidth

local ax=aa.new("Frame","Form",ap.parent,{
BackgroundTransparency=1,
BorderSizePixel=0,
LayoutOrder=ap.order,
Size=UDim2.new(1,0,0,af.rowHeight),
})local ay=function(

ay, az, b, c, d)
return aa.new("TextBox",ay,ax,{
AnchorPoint=b,
BorderSizePixel=0,
ClearTextOnFocus=false,
PlaceholderText=az,
Position=c,
Size=d,
Text="",
TextSize=aj.value,
TextTruncate=Enum.TextTruncate.AtEnd,
TextXAlignment=Enum.TextXAlignment.Left,
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
Font="Font.MonoSpace",
PlaceholderColor3="Colors.Text.Darker",
TextColor3="Colors.Text.Default",
},

aa.new("UIPadding",{
PaddingLeft=UDim.new(0,6),
PaddingRight=UDim.new(0,4),
}),
aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})end


local az=ay("Command",aq,Vector2.zero,UDim2.fromOffset(0,0),
UDim2.new(1,-(av+aw+2*au),1,0))
local b=ay("Delay",ar,Vector2.new(1,0),UDim2.new(1,-(av+au),0,0),
UDim2.new(0,aw,1,0))

local c=aa.new("TextButton","Add",ax,{
AnchorPoint=Vector2.new(1,0),
AutoButtonColor=false,
BorderSizePixel=0,
Position=UDim2.fromScale(1,0),
Size=UDim2.new(0,av,1,0),
Text=as,
TextSize=aj.label,
ThemeTag={
BackgroundColor3="Colors.Primary",
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ai.cornerRadius),
}),
})

return az,b,c end




al.footer=function(ap, aq)
ap.order=ap.order+1

return aa.new("TextLabel","Footer",ap.parent,{
BackgroundTransparency=1,
LayoutOrder=ap.order,
Size=UDim2.new(1,0,0,af.headerHeight),
Text=aq,
TextSize=aj.footer,
TextXAlignment=Enum.TextXAlignment.Center,
ThemeTag={
Font="Font.MonoSpace",
TextColor3="Colors.Text.Darker",
},
})end



al.note=function(ap, aq)
ap.order=ap.order+1

return aa.new("TextLabel","Note",ap.parent,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
LayoutOrder=ap.order,
Size=UDim2.new(1,0,0,0),
Text=aq,
TextSize=aj.value,
TextWrapped=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
ThemeTag={
Font="Font.MonoSpace",
TextColor3="Colors.Text.Darker",
},


aa.new("UIPadding",{
PaddingLeft=UDim.new(0,ag.labelInset),
}),
})end


return al end a.dl=function()local ab=a.cache.dl if not ab then ab={c=aa()}a.cache.dl=ab end return ab.c end end do local aa=function()







local aa=a.cL()
local ab=a.al()
local ac=a.dk()
local ad=a.dl()

local ae=ac.panel
local af=ac.box local ag=function(

ag, ah)
local ai=ad.list(ag)
ad.pageTop(ai,ac.pages.theme.title,ah.back)

local aj={}local ak=function()


for ak,al in aj do
al.Visible=aa.selectedTheme==ak.theme
end end local al=function(


al)
aa:selectTheme(al.key)

ab:setValue(ac.keys.theme,al.key)
ab:save()

ak()end


for am,an in aa:getThemes()do
local ao=ad.row(ai)

if an.usable then
ad.label(ao,an.name,af.size+2*ae.padding)
ao.Activated:Connect(function()
al(an)
end)
else
ad.label(ao,`{an.name} {ac.pages.theme.incomplete}`,af.size+2*ae.padding,"Colors.Text.Darker")
end

local ap,aq=ad.box(ao)
aj[an]=aq
end

ak()end


return ag end a.dm=function()local ab=a.cache.dm if not ab then ab={c=aa()}a.cache.dm=ab end return ab.c end end do local aa=function()








local aa=a.ax()
local ab=a.av()
local ac=a.dk()
local ad=a.dl()

local ae=ac.panel
local af=ac.value local ag=function()


local ag={}

for ah in ab.bindings do
table.insert(ag,ah)
end

table.sort(ag)
return ag end local ah=function()




local ah={}

for ai,aj in ag()do
local ak=ab.bindings[aj]

for al,am in ak.also or{}do
local an=(Enum.KeyCode)[am]

if an then
table.insert(ah,string.format(
ac.pages.keybinds.alwaysWorks,
aa:getKeyName(an),
ak.label or aj
))
end
end
end

return ah end local ai=function(


ai, aj)
local ak=ad.list(ai)
ad.pageTop(ak,ac.pages.keybinds.title,aj.back)

local al={}

for am,an in ag()do
local ao=ab.bindings[an]
local ap=ad.row(ak)

ad.label(ap,ao.label or an,af.keybindWidth+2*ae.padding)

local aq,ar=ad.keybind(ap,an)
table.insert(al,aq)
table.insert(aj.stoppers,ar)
end

local am=ah()
if#am>0 then
ad.note(ak,table.concat(am,"\n"))
end

local an=ad.row(ak)
ad.label(an,ac.pages.keybinds.reset,0)

an.Activated:Connect(function()

for ao,ap in aj.stoppers do
ap()
end

for ao in ab.bindings do
aa:resetBinding(ao)
end

for ao,ap in al do
ap()
end
end)end


return ai end a.dn=function()local ab=a.cache.dn if not ab then ab={c=aa()}a.cache.dn=ab end return ab.c end end do local aa=function()









local aa=a.bA()
local ab=a.cu()
local ac=a.cy()
local ad=a.dk()
local ae=a.cT()
local af=a.dl()

local ag=ad.panel
local ah=ad.value
local ai=ad.pages.aliases local aj=function(

aj)
return aj:match"^%s*(.-)%s*$"or""end local ak=function(




ak)
return ak:find"[\\%^!,|&\"']"~=nil end local al=function(


al, am)
local an=af.list(al)
af.pageTop(an,ad.pages.aliases.title,am.back)

af.header(an,ai.addTitle)
local ao=af.textBox(an,ai.aliasHint)
local ap=af.textBox(an,ai.commandHint)

local aq=af.row(an)
af.label(aq,ai.addButton,0)

local ar=af.note(an,"")

af.header(an,ai.listTitle)
af.note(an,ai.listHint)

local as=af.group(an)

local at local au=function(


au, av)
ae:ask(ai.undoTitle,string.format(ai.undoMessage,au,av),{
{
text=ai.undo,
primary=true,
onTap=function()
local aw,ax=ab.add(ac,au,av)

if not aw then
ae:notify(ai.notifyTitle,ax or"")
return
end


if as.Parent then
ar.Text=string.format(ai.restored,au)
at()
end
end,
},
},ai.undoTime)end


at=function()
af.clear(as)

local av=aa:getData()
local aw={}

for ax in av do
table.insert(aw,ax)
end

table.sort(aw)

local ax=af.list(as)

if#aw==0 then
af.note(ax,ai.empty)
return
end

for ay,az in aw do
local b=af.row(ax)

af.label(b,az,ah.aliasWidth+2*ag.padding)
af.value(b,tostring(av[az]),ah.aliasWidth)

b.Activated:Connect(function()
local c,d=ab.remove(ac,az)

if c then
ar.Text=string.format(ai.removed,az)
au(az,d)
end

at()
end)
end end local av=function()



local av=aj(ao.Text)
local aw=aj(ap.Text)

if av==""or aw==""then
ar.Text=ai.missing
return
end

if av:find"%s"then
ar.Text=ai.spaces
return
end

if ak(av)then
ar.Text=ai.badCharacters
return
end

local ax,ay=ab.add(ac,av,aw)

if ax then
ar.Text=string.format(ai.added,av:lower())
ao.Text=""
ap.Text=""
at()
else
ar.Text=ay or""
end end


aq.Activated:Connect(av)


ao.FocusLost:Connect(function(aw)
if aw then
ap:CaptureFocus()
end
end)

ap.FocusLost:Connect(function(aw)
if aw then
av()
end
end)

at()end


return al end a.dp=function()local ab=a.cache.dp if not ab then ab={c=aa()}a.cache.dp=ab end return ab.c end end do local aa=function()













local aa=a.bc()
local ab=a.R()
local ac=a.dk()
local ad=a.cT()
local ae=a.dl()

local af=ac.panel
local ag=ac.box
local ah=ac.value
local ai=ac.pages.waypoints


local aj=1 local ak=function(

ak)
return ak:match"^%s*(.-)%s*$"or""end local al=function(


al, am)
local an=ai.modes
local ao=math.clamp(aj,1,#an)

local ap=ae.list(al)
ae.pageTop(ap,ai.title,am.back)


ae.header(ap,ai.newTitle)
local aq,ar,as=ae.formRow(ap,ai.nameHint,ai.positionHint,ai.addButton,ah.positionWidth)
local at=ae.note(ap,ai.formHint)


ae.header(ap,ai.modeTitle)

local au={}
for av,aw in an do
table.insert(au,aw.label)
end

local av=ae.choices(ap,au,function(av)
ao=av
aj=av
end,#an)
av(ao)


local aw=ae.row(ap)
ae.label(aw,ai.markers,ag.size+2*af.padding)
local ax,ay=ae.box(aw)


local az=ae.header(ap,"")
local b=ae.group(ap)


ae.header(ap,ai.clearTitle)
local c=ae.row(ap)
ae.label(c,ai.clearGame,0)
local d=ae.row(ap)
ae.label(d,ai.clearAll,0)

local e local f=function(


f)
at.Text=f
ad:notify(ai.notifyTitle,f)end local g=function()



ay.Visible=aa.isShown()end local h=function(



h)
local i=an[ao].mode
local j=aa.format(h.position)

if not aa.go(h,i)then
f(ai.cantGo)
return
end

local k=if i=="tween"then ai.wentTween elseif i=="walk"then ai.wentWalk else ai.went
at.Text=string.format(k,h.name,j)end local i=function(



i)
ad:ask(ai.undoTitle,string.format(ai.undoMessage,i.name,aa.format(i.position)),{
{
text=ai.undo,
primary=true,
onTap=function()

if aa.find(i.name)then
ad:notify(ai.notifyTitle,string.format(ai.nameTaken,i.name))
return
end

aa.save(i.name,i.position)
aa.refreshMarkers()


if b.Parent then
at.Text=string.format(ai.restored,i.name)
e()
end
end,
},
},ai.undoTime)end local j=function(


j)
if not aa.remove(j.name)then return end

aa.refreshMarkers()
at.Text=string.format(ai.removed,j.name)
e()
i(j)end


e=function()
ae.clear(b)

local k=aa.list()
local l=ae.list(b)

az.Text=ai.listTitle..(if#k>0 then` ({#k})`else"")
g()

if#k==0 then
ae.note(l,ai.empty)
return
end

ae.note(l,ai.listHint)

for m,n in k do
local o=ae.row(l)


local p=ae.rowButton(o,ai.delete,af.padding,ah.buttonWidth)
ae.label(o,n.name,ah.buttonWidth+2*af.padding)

o.Activated:Connect(function()
h(n)
end)

p.Activated:Connect(function()
j(n)
end)
end end local k=function()



local k=ak(aq.Text)

if k==""then
f(ai.missingName)
return
end

local l
local m=ak(ar.Text)

if m==""then
local n=ab:getRootPart()

if not n then
f(ai.noCharacter)
return
end

l=n.Position
else
l=aa.parsePosition(m)

if not l then
f(ai.badPosition)
return
end
end

local n=aa.save(k,l)
aa.refreshMarkers()

aq.Text=""
ar.Text=""
at.Text=string.format(if n then ai.updated else ai.saved,k,aa.format(l))
e()end


as.Activated:Connect(k)


for l,m in{aq,ar}do
m.FocusLost:Connect(function(n)
if n then
k()
end
end)
end

aw.Activated:Connect(function()
if aa.isShown()then
aa.hide()
elseif aa.count()==0 then
f(ai.noMarkers)
else
aa.show()
end

g()
end)local l=function(


l)
local m=if l then aa.countAll()else aa.count()

if m==0 then
at.Text=ai.nothingToClear
return
end

local n=string.format(if l then ai.confirmAll else ai.confirmGame,m)

ad:ask(ai.confirmTitle,n,{
{text=ai.confirmCancel},
{
text=ai.confirmClear,
primary=true,
onTap=function()
local o=if l then aa.clearAll()else aa.clearPlace()
aa.hide()


if b.Parent then
at.Text=string.format(ai.cleared,o)
e()
end
end,
},
})end


c.Activated:Connect(function()
l(false)
end)

d.Activated:Connect(function()
l(true)
end)

e()end


return al end a.dq=function()local ab=a.cache.dq if not ab then ab={c=aa()}a.cache.dq=ab end return ab.c end end do local aa=function()












local aa=a.cw()
local ab=a.cy()
local ac=a.dk()
local ad=a.cT()
local ae=a.dl()

local af=ac.panel
local ag=ac.value
local ah=ac.pages.plugins local ai=function(

ai)
return ai:match"^%s*(.-)%s*$"or""end local aj=function(


aj, ak)
local al=ae.list(aj)
ae.pageTop(al,ah.title,ak.back)


ae.header(al,ah.addTitle)
local am=ae.textBox(al,ah.fileHint)

local an=ae.row(al)
ae.label(an,ah.addButton,0)

local ao=ae.note(al,string.format(ah.folderHint,aa.FOLDER))
ae.note(al,ah.trustHint)


local ap=ae.header(al,ah.installedTitle)
local aq=ae.group(al)

ae.header(al,ah.folderTitle)
local ar=ae.group(al)

local as local at=function(


at)
ao.Text=at
ad:notify(ah.errorTitle,at)end local au=function(



au)
local av,aw=aa.add(ab,au)

if av then
ao.Text=string.format(ah.added,au,aw)
as()
return true
end

at(tostring(aw))
return false end local av=function(



av)
if av.loaded then
return string.format(ah.stateLoaded,av.name,av.commands)
end

if av.error then
return string.format(ah.stateFailed,av.name,av.error)
end

return string.format(ah.stateUnknown,av.name)end local aw=function()



ae.clear(aq)

local aw=aa.getInstalled()
local ax=ae.list(aq)

ap.Text=ah.installedTitle..(if#aw>0 then` ({#aw})`else"")

if#aw==0 then
ae.note(ax,ah.noneInstalled)
return
end

ae.note(ax,ah.installedHint)

local ay=af.rowGap
local az=af.padding
local b=az+ag.buttonWidth+ay
local c=b+ag.reloadWidth+af.padding

for d,e in aw do
local f=ae.row(ax)

local g=ae.rowButton(f,ah.remove,az,ag.buttonWidth)
local h=ae.rowButton(f,ah.reload,b,ag.reloadWidth)


local i=if e.loaded
then string.format(ah.loadedLabel,e.name,e.commands)
else string.format(ah.failedLabel,e.name)

ae.label(f,i,c,if e.loaded then nil else"Colors.Text.Darker")

f.Activated:Connect(function()
ao.Text=av(e)
end)

h.Activated:Connect(function()
local j,k=aa.reload(ab,e.name)

if j then
ao.Text=string.format(ah.reloaded,e.name,k)
as()
else
as()
at(tostring(k))
end
end)

g.Activated:Connect(function()
if aa.remove(ab,e.name)then
ao.Text=string.format(ah.removed,e.name)
as()
end
end)
end end local ax=function()



ae.clear(ar)

local ax,ay=aa.getAvailable()
local az=ae.list(ar)

if not ax then
ae.note(az,ay or"")
return
end

if#ax==0 then
ae.note(az,ah.noneInFolder)
return
end

local b=af.padding

for c,d in ax do
local e=ae.row(az)

local f=ae.rowButton(e,ah.add,b,ag.buttonWidth)
ae.label(e,d,ag.buttonWidth+2*af.padding)


e.Activated:Connect(function()
au(d)
end)

f.Activated:Connect(function()
au(d)
end)
end


local c=ae.row(az)
ae.label(c,string.format(ah.addAll,#ax),0)

c.Activated:Connect(function()
local d=0
local e={}

for f,g in ax do
local h,i=aa.add(ab,g)

if h then
d=d+1
else
table.insert(e,`{g}: {i}`)
end
end

local f=string.format(ah.addedAll,d)

if#e>0 then
f=f..string.format(ah.failedAll,#e)

for g,h in e do
warn(`plugin {h}`)
end
end

ao.Text=f
as()
end)end


as=function()
aw()
ax()end local ay=function()



local ay=ai(am.Text)

if ay==""then
at(ah.missingName)
return
end

if au(ay)then
am.Text=""
end end


an.Activated:Connect(ay)


am.FocusLost:Connect(function(az)
if az then
ay()
end
end)

as()end


return aj end a.dr=function()local ab=a.cache.dr if not ab then ab={c=aa()}a.cache.dr=ab end return ab.c end end do local aa=function()












local aa=a.c1()
local ab=a.dk()
local ac=a.cT()
local ad=a.dl()

local ae=ab.panel
local af=ab.value
local ag=ab.pages.eventBinds


local ah=1 local ai=function(


ai)
local aj={}

for ak,al in ai.conditions or{}do
table.insert(aj,tostring(al))
end

return aj end local aj=function(



aj)
local ak=ai(aj)

if#ak==0 then
return aj.command
end

return`{aj.command}  [{table.concat(ak,", ")}]`end local ak=function(



ak)
return`{ak}s`end local al=function(



al)
local am=al:gsub("%s",""):gsub("s$","")
return tonumber(am)end local am=function(


am, an)
local ao=aa.events
local ap=math.clamp(ah,1,#ao)
local aq={}


local ar={}
for as,at in ao do
table.insert(ar,(at.name:gsub("^On","")))
end

local as=ad.list(am)
ad.pageTop(as,nil,an.back)

local at,au
local av
local aw

at,au=ad.choices(as,ar,function(ax)
ap=ax
ah=ax
av()
end,ag.columns)local ax=function()



for ax,ay in ao do
au(ax,#aa.getBinds(ay.name))
end end



local ay=ad.header(as,"")


local az=ad.group(as)

local b,c,d=ad.formRow(as,ag.commandHint,ag.delayHint,ag.addButton)

local e=ad.note(as,"")

local f=ad.header(as,"")
local g=ad.group(as)local h=function()


return ao[ap]end local i=function(



i)
e.Text=i
ac:notify(ag.notifyTitle,i)end local j=function(



j, k, l)
local m=string.format(ag.undoMessage,l.command,j.name)


local n={}
local o=ai(l)

if(l.delay or 0)>0 then
table.insert(n,string.format(ag.undoDelay,ak(l.delay)))
end

if#o>0 then
table.insert(n,`[{table.concat(o,", ")}]`)
end

if#n>0 then
m=m.."\n"..table.concat(n,"  ")
end

ac:ask(ag.undoTitle,m,{
{
text=ag.undo,
primary=true,
onTap=function()
if aa.restore(j.name,k,l)then

if g.Parent then
e.Text=string.format(ag.restored,l.command)
ax()

if h()==j then
aw()
end
end
end
end,
},
},ag.undoTime)end local k=function()




ad.clear(az)
aq={}

local k=ad.list(az)

for l,m in h().conditions do
local n,o=ad.inputRow(
k,
m.label,
ag.conditionHints[m.kind]or"",
m.default
)

aq[l]=o
end end


aw=function()
ax()
ad.clear(g)

local l=h()
local m=ad.list(g)
local n=aa.getBinds(l.name)

f.Text=string.format(ag.listTitle,l.name)..(if#n>0 then` ({#n})`else"")

if#n==0 then
ad.note(m,ag.empty)
return
end

ad.note(m,ag.listHint)

for o,p in n do
local q=ad.row(m)
ad.label(q,aj(p),af.delayWidth+2*ae.padding)


local r=ad.valueInput(q,ak(p.delay or 0),af.delayWidth)


r.FocusLost:Connect(function()
if not r.Parent then return end

local s=al(r.Text)

if s==nil or s<0 then
r.Text=ak(p.delay or 0)
i(if s==nil then ag.badDelay else ag.negativeDelay)
return
end

if aa.setDelay(l.name,o,s)then
r.Text=ak(s)
e.Text=string.format(ag.delayChanged,p.command,ak(s))
end
end)

q.Activated:Connect(function()
local s=aa.remove(l.name,o)

if s then
e.Text=string.format(ag.removed,s.command)
aw()
j(l,o,s)
end
end)
end end


av=function()
ay.Text=string.format(ag.header,h().name,h().description)
e.Text=""

at(ap)
k()
aw()end local l=function()



local l=if c.Text==""then 0 else al(c.Text)

if l==nil then
i(ag.badDelay)
return
end

if l<0 then
i(ag.negativeDelay)
return
end

local m={}
for n,o in aq do
m[n]=o.Text
end

local n=h()
local o,p=aa.add(n.name,b.Text,l,m)

if o then

b.Text=""
aw()
e.Text=string.format(ag.added,n.name)
else
i(p or ag.notAdded)
end end


d.Activated:Connect(l)


for m,n in{b,c}do
n.FocusLost:Connect(function(o)
if o then
l()
end
end)
end

av()end


return am end a.ds=function()local ab=a.cache.ds if not ab then ab={c=aa()}a.cache.ds=ab end return ab.c end end do local aa=function()









local aa=a.cM()
local ab=a.au()
local ac=a.al()
local ad=a.dk()
local ae=a.ap()
local af=a.P()
local ag=a.cE()

local ah=a.dl()
local ai=a.dm()
local aj=a.dn()
local ak=a.dp()
local al=a.dq()
local am=a.dr()
local an=a.ds()

local ao=ad.panel
local ap=ad.box
local aq=ad.row
local ar=ad.value

local as=af.TweenService

local at=ao.shownY
local au=ao.hiddenY



local av=ao.floatBackSize
local aw=UDim2.new(1,-(ao.floatBackMargin+ao.scrollBarThickness),0,ao.floatBackMargin)
local ax=UDim2.fromOffset(av,av)
local ay=UDim2.fromOffset(av*ao.floatBackFlat,av)
local az=UDim2.new(1,0,0,-av*ao.floatBackOut)


local b={
theme=ai,
keybinds=aj,
aliases=ak,
waypoints=al,
plugins=am,
eventBinds=an,
}

local c={}
c.__index=c local d=function(

d, e)
ac:setValue(d,e==true)
ac:save()end local e=function(


e)
return ac:getValue(e)==true end local f=function(


f, g, h)
f:TweenPosition(g,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,ao.tweenTime,true,h)end


c.isKeepMenuOpen=function()
return e(ad.keys.keepMenuOpen)end


c.setKeepMenuOpen=function(g)
d(ad.keys.keepMenuOpen,g)end


c.isKeepIY=function()
return e(ad.keys.keepIY)end


c.setKeepIY=function(g)
d(ad.keys.keepIY,g)end



c.createOption=function(g, h, i)
local j=ah.row(h)

if i.icon then
ah.icon(j,i.icon)
end

if i.kind=="switch"then
local k=ad.keys[i.setting]
ah.label(j,i.label,ap.size+2*ao.padding)

local l,m=ah.box(j)local n=function()


m.Visible=e(k)end


j.Activated:Connect(function()
local o=not e(k)
d(k,o)
n()

if g.onSwitch then
g.onSwitch(i.setting,o)
end
end)

n()
return n
end

if i.kind=="keybind"then
ah.label(j,i.label,ar.keybindWidth+2*ao.padding)

local k,l=ah.keybind(j,i.binding)
table.insert(g.stoppers,l)

return k
end


local k=b[i.action]~=nil

if k then
ah.chevron(j)
end

ah.label(j,i.label,if k then aq.chevronSize+2*ao.padding else 0)

j.Activated:Connect(function()
if b[i.action]then
g:openPage(i.action)
elseif g.onButton then
g.onButton(i.action)
end
end)

return nil end


c.createOptions=function(g)
local h=ah.list(g.panel)

for i,j in ad.sections do
ah.header(h,j.title)

for k,l in j.options do
local m=g:createOption(h,l)

if m then
table.insert(g.refreshers,m)
end
end
end


local i=ad.footer
:gsub("{name}",ae.applicationName)
:gsub("{version}",ae.version)

ah.footer(h,i)end


c.createPages=function(g)
for h,i in b do
local j=ah.page(g.holder,`{h}Page`,UDim2.fromScale(1,au))


j.Visible=false

g.pages[h]={
frame=j,
build=i,
}
end end


c.new=function(g)
return setmetatable({
onSwitch=g.onSwitch,
onButton=g.onButton,
isOpen=false,
isShown=false,
holder=nil,
panel=nil,
current=nil,
pages={},
refreshers={},
stoppers={},
pageStoppers={},
pageConnections={},
backRow=nil,
floatingBack=nil,
floatingIcon=nil,
floatingShown=false,
floatingTween=nil,
backIcon=nil,
},c)end


c.create=function(g, h, i)
local j=aa.new("Frame","SettingsHolder",h,{
AnchorPoint=i.AnchorPoint,
BackgroundTransparency=1,
ClipsDescendants=true,
Position=i.Position,
Size=i.Size,
Visible=false,
})

g.holder=j
g.panel=ah.page(j,"Settings",UDim2.fromScale(0,au))
g.current=g.panel

g:createOptions()
g:createPages()
g:createFloatingBack(j)

return j end




c.createFloatingBack=function(g, h)
local i=aa.new("TextButton","FloatingBack",h,{
AnchorPoint=Vector2.new(1,0),
AutoButtonColor=false,
BorderSizePixel=0,
Position=aw,
Size=ax,
Text="",
Visible=false,
ZIndex=2,
ThemeTag={
BackgroundColor3="Colors.Buttons.Holding",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ar.cornerRadius),
}),
aa.new("UIStroke",{
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
Thickness=1,
ThemeTag={
Color="Colors.Border.Default",
},
}),
})


local j=ah.icon(i,ad.pages.backIcon)
j.AnchorPoint=Vector2.new(0.5,0.5)
j.Position=UDim2.fromScale(0.5,0.5)
j.Size=UDim2.fromScale(aq.iconSize/ao.floatBackSize,aq.iconSize/ao.floatBackSize)
j.ZIndex=i.ZIndex+1

i.Activated:Connect(function()
g:back()
end)

g.floatingBack=i
g.floatingIcon=j end



c.syncFloatingIcon=function(g)
local h,i=g.floatingIcon,g.backIcon

if h and i and i.Image~=""and h.Image~=i.Image then
h.Image=i.Image
end end




c.updateFloatingBack=function(g)
local h=g.floatingBack
if not h then return end

local i=g.current
local j=g.backRow
local k=false

if g.isShown and i~=g.panel and j and j.Parent then
k=j.AbsolutePosition.Y+j.AbsoluteSize.Y<=i.AbsolutePosition.Y
end

if k then
g:syncFloatingIcon()
end

if k==g.floatingShown then return end

g.floatingShown=k

if k then
g:showFloatingBack()
else
g:hideFloatingBack()
end end



c.showFloatingBack=function(g)
local h=g.floatingBack


if not h.Visible then
h.Position=az
h.Size=ay
h.Visible=true
end

g:tweenFloatingBack(aw,ax,Enum.EasingStyle.Back,Enum.EasingDirection.Out)end



c.hideFloatingBack=function(g)
local h=g.floatingBack
if not h.Visible then return end

g:tweenFloatingBack(az,ay,Enum.EasingStyle.Quart,Enum.EasingDirection.In,function()
h.Visible=false
end)end




c.tweenFloatingBack=function(g, h, i, j, k, l)
local m=g.floatingBack
g:stopFloatingTween()

local n=ag:getScale(ao.floatBackTime)

if n<=0 then
m.Position=h
m.Size=i

if l then
l()
end

return
end

local o=as:Create(m,TweenInfo.new(n,j,k),{
Position=h,
Size=i,
})

g.floatingTween=o

o.Completed:Connect(function(p)

if p~=Enum.PlaybackState.Completed then return end

if g.floatingTween==o then
g.floatingTween=nil
end

if l then
l()
end
end)

o:Play()end


c.stopFloatingTween=function(g)
local h=g.floatingTween
if not h then return end

g.floatingTween=nil
h:Cancel()end


c.refresh=function(g)
for h,i in g.refreshers do
i()
end end



c.stopWaiting=function(g)
for h,i in g.stoppers do
i()
end

for h,i in g.pageStoppers do
i()
end end



c.buildPage=function(g, h)
ah.clear(h.frame)
g.pageStoppers={}

for i,j in g.pageConnections do
j:Disconnect()
end
table.clear(g.pageConnections)

h.build(h.frame,{
back=function()
g:back()
end,
stoppers=g.pageStoppers,
})

g.backRow=h.frame:FindFirstChild"BackRow"
g.backIcon=if g.backRow then g.backRow:FindFirstChild"Icon"else nil

if g.backIcon then

table.insert(g.pageConnections,g.backIcon:GetPropertyChangedSignal"Image":Connect(function()
g:syncFloatingIcon()
end))

g:syncFloatingIcon()
end

table.insert(g.pageConnections,h.frame:GetPropertyChangedSignal"CanvasPosition":Connect(function()
g:updateFloatingBack()
end))end





c.hideWhenGone=function(g, h)
return function(i)
if i and h~=g.current then
h.Visible=false
end
end end



c.openPage=function(g, h)
local i=g.pages[h]
if not i or not g.isShown or g.current~=g.panel then return end

g:stopWaiting()


i.frame.Visible=true
g:buildPage(i)

i.frame.CanvasPosition=Vector2.zero
i.frame.Position=UDim2.fromScale(1,at)
g.current=i.frame

f(g.panel,UDim2.fromScale(-1,at),g:hideWhenGone(g.panel))
f(i.frame,UDim2.fromScale(0,at))

g:updateFloatingBack()end



c.back=function(g)
if g.current==g.panel then return end

g:stopWaiting()

local h=g.current
g.panel.Visible=true

f(h,UDim2.fromScale(1,at),g:hideWhenGone(h))
f(g.panel,UDim2.fromScale(0,at))
g.current=g.panel

g:updateFloatingBack()end



c.reset=function(g)
g.current=g.panel
g.panel.Visible=true
g.panel.Position=UDim2.fromScale(0,au)

for h,i in g.pages do
i.frame.Visible=false
i.frame.Position=UDim2.fromScale(1,au)
end end


c.toggle=function(g)
g.isOpen=not g.isOpen
g:setShown(g.isOpen)end


c.setShown=function(g, h)
if not g.panel or g.isShown==h then return end

g.isShown=h
local i=g.current

g:updateFloatingBack()

if h then
g.holder.Visible=true
f(i,UDim2.fromScale(0,at))
return
end

g:stopWaiting()

f(i,UDim2.fromScale(0,au),function(j)
if j and not g.isShown then
g.holder.Visible=false


if not g.isOpen then
g:reset()
end
end
end)end


c.watchCommandBar=function(g, h)
ab:Connect(h.Focused,function()
g:setShown(false)
end)

ab:Connect(h.FocusLost,function()
g:setShown(g.isOpen)
end)end


return c end a.dt=function()local ab=a.cache.dt if not ab then ab={c=aa()}a.cache.dt=ab end return ab.c end end do local aa=function()





return{
window={
title="Part Path",
width=250,
topBarHeight=20,
closeIconSize=15,
closeInset=2,
rowHeight=17,
buttonRowHeight=21,
buttonHeight=17,
buttonGap=6,
rowPadding=4,

pathCharsPerLine=28,
textInset=5,
verticalPadding=3,
stripeTransparency=0.96,
shownY=100,
hiddenY=-500,
tweenTime=0.5,
},

textSizes={
title=16,
section=11,
value=14,
help=11,
button=12,
},

headers={
path="#path",
actions="#actions",
},

labels={
hint="no part selected",
help='click a part to see its path. "select part" saves it as a waypoint.',
},

buttons={
selectPart="select part",
copyPath="copy path",
copied="copied",
feedbackTime=1.5,
cornerRadius=6,
},

messages={
noPart="select a part first",
noPath="select a part to copy its path",
noClipboard="this executor doesn't support clipboard",
},
}end a.du=function()local ab=a.cache.du if not ab then ab={c=aa()}a.cache.du=ab end return ab.c end end do local aa=function()







local aa={
["and"]=true,["break"]=true,["do"]=true,["else"]=true,["elseif"]=true,
["end"]=true,["false"]=true,["for"]=true,["function"]=true,["if"]=true,
["in"]=true,["local"]=true,["nil"]=true,["not"]=true,["or"]=true,
["repeat"]=true,["return"]=true,["then"]=true,["true"]=true,
["until"]=true,["while"]=true,
}local ab=function(

ab)
local ac=ab:gsub("\\","\\\\"):gsub('"','\\"'):gsub("\n","\\n")
return ac end local ac=function(


ac)
if string.match(ac,"^[%a_][%w_]*$")and not aa[ac]then
return"."..ac
end

return'["'..ab(ac)..'"]'end local ad=function(



ad)
local ae=pcall(game.GetService,game,ad.ClassName)

if ae then
return`game:GetService("{ad.ClassName}")`
end

return"game"..ac(ad.Name)end local ae=function(


ae)
if not ae then
return""
end


local af={}
local ag=ae

while ag and ag~=game do
table.insert(af,1,ag)
ag=ag.Parent
end


if ag~=game then
return ae:GetFullName()
end

if#af==0 then
return"game"
end

local ah=ad(af[1])

for ai=2,#af do
ah=ah..ac(af[ai].Name)
end

return ah end


return ae end a.dv=function()local ab=a.cache.dv if not ab then ab={c=aa()}a.cache.dv=ab end return ab.c end end do local aa=function()







local aa=a.cM()
local ab=a.cO()
local ac=a.cL()
local ad=a.cT()
local ae=a.dd()
local af=a.bY()

local ag=a.au()
local ah=a.R()
local ai=a.a()
local aj=a.du()

local ak=a.dv()
local al=a.cS()
local am=a.cK()

local an=aj.window
local ao=aj.textSizes
local ap=aj.buttons

local aq=UDim2.new(0.5,-an.width/2,0,an.shownY)
local ar=UDim2.new(0.5,-an.width/2,0,an.hiddenY)

local as=Color3.fromRGB(255,255,255)
local at=Color3.fromRGB(0,166,0)

local au={}
au.__index=au

au.new=function()
return setmetatable({
frame=nil,
hoverBox=nil,
selectedBox=nil,
pathLabel=nil,
copyButton=nil,

isOpen=false,
path=nil,
selectedPart=nil,
onSelectPart=nil,
connections={},
},au)end local av=function(



av, aw, ax, ay)
return aa.new("Frame",ay,av,{
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=if aw%2==1 then an.stripeTransparency else 1,
BorderSizePixel=0,
LayoutOrder=aw,
Size=UDim2.new(1,0,0,ax),
})end local aw=function(



aw, ax, ay, az)
local b=aa.new("Frame",ay,aw,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=if ax%2==1 then an.stripeTransparency else 1,
BorderSizePixel=0,
LayoutOrder=ax,
Size=UDim2.new(1,0,0,0),

aa.new("UIPadding",{
PaddingBottom=UDim.new(0,an.rowPadding),
PaddingLeft=UDim.new(0,an.textInset),
PaddingRight=UDim.new(0,an.textInset),
PaddingTop=UDim.new(0,an.rowPadding),
}),
aa.new("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

local c=aa.new("TextLabel",az.labelName,b,{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
TextSize=az.textSize,
TextWrapped=true,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
ThemeTag={
Font="Font.MonoSpace",
TextColor3=az.color,
},
})

return b,c end local ax=function(




ax)
local ay={}
local az=""

for b=1,#ax do
local c=string.sub(ax,b,b)

if(c=="."or c=="[")and az~=""then
table.insert(ay,az)
az=""
end

az=az..c
end

if az~=""then
table.insert(ay,az)
end

local b={}
local c=""

for d,e in ay do
if c~=""and#c+#e>aj.window.pathCharsPerLine then
table.insert(b,c)
c=""
end

c=c..e
end

if c~=""then
table.insert(b,c)
end

return table.concat(b,"\n")end local ay=function(


ay, az, b)
local c=av(ay,az,an.rowHeight,"Section")

aa.new("TextLabel","Title",c,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(an.textInset,0),
Size=UDim2.new(1,-an.textInset*2,1,0),
RichText=true,
Text=`<b>{am.escapeRichText(b)}</b>`,
TextSize=ao.section,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,
ThemeTag={
Font="Font.MonoSpace",
TextColor3="Colors.Text.Darker",
},
})

return c end local az=function(


az, b, c, d, e)
local f=aa.new("TextButton",b,az,{
AutoButtonColor=false,
BorderSizePixel=0,
Position=d,
Size=e,
Text=c,
TextSize=ao.button,
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
Font="Font.MonoSpace",
TextColor3="Colors.Text.Default",
},

aa.new("UICorner",{
CornerRadius=UDim.new(0,ap.cornerRadius),
}),
})

ag:Connect(f.MouseEnter,function()
ac:updateObjectProperties(f,{
BackgroundColor3="Colors.Buttons.Holding",
})
end)

ag:Connect(f.MouseLeave,function()
ac:updateObjectProperties(f,{
BackgroundColor3="Colors.Buttons.Default",
})
end)

return f end



au.create=function(b)
if b.frame then
return b.frame
end

local c=aa.new("Frame","PartPath",{
Active=true,
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Position=ar,
Size=UDim2.fromOffset(an.width,0),
Visible=false,

aa.new("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

local d=aa.new("Frame","TopBar",c,{
BorderSizePixel=0,
LayoutOrder=1,
Size=UDim2.new(1,0,0,an.topBarHeight),
ThemeTag={
BackgroundColor3="Colors.Background",
},
})

aa.new("TextLabel","Title",d,{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Text=an.title,
TextSize=ao.title,
ThemeTag={
Font="Font.Normal",
TextColor3="Colors.Text.Default",
},
})

local e=aa.new("ImageButton","Exit",d,{
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Position=UDim2.new(1,-an.closeInset,0.5,0),
Size=UDim2.fromOffset(an.closeIconSize,an.closeIconSize),
ThemeTag={
ImageColor3="Colors.Icons",
},
})

ab:loadImage(e,"close")

local f=aa.new("Frame","Body",c,{
Active=true,
AutomaticSize=Enum.AutomaticSize.Y,
BorderSizePixel=0,
LayoutOrder=2,
Size=UDim2.new(1,0,0,0),
ThemeTag={
BackgroundColor3="Colors.Background",
},

aa.new("UIPadding",{
PaddingBottom=UDim.new(0,an.verticalPadding),
PaddingTop=UDim.new(0,an.verticalPadding),
}),
aa.new("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
}),
})

ay(f,1,aj.headers.path)


local g,h=aw(f,2,"PathRow",{
labelName="Path",
textSize=ao.value,
color="Colors.Text.Default",
})
h.RichText=true

ay(f,3,aj.headers.actions)


local i=av(f,4,an.buttonRowHeight,"ButtonRow")
local j=an.buttonGap/2
local k=an.textInset
local l=(an.buttonRowHeight-an.buttonHeight)/2
local m=UDim2.new(0.5,-(k+j),0,an.buttonHeight)

local n=az(i,"SelectPart",ap.selectPart,
UDim2.new(0,k,0,l),m)
local o=az(i,"CopyPath",ap.copyPath,
UDim2.new(0.5,j,0,l),m)

local p,q=aw(f,5,"Help",{
labelName="HelpText",
textSize=ao.help,
color="Colors.Text.Darker",
})
q.Text=aj.labels.help


local r=aa.new("SelectionBox","Hover",af,{
Color3=as,
})

local s=aa.new("SelectionBox","Selected",af,{
Color3=at,
})

ag:Connect(e.Activated,function()
b:close()
end)

ag:Connect(n.Activated,function()
b:confirmSelection()
end)

ag:Connect(o.Activated,function()
b:copyPath()
end)

ae:addGuiObject(c)

b.frame=c
b.hoverBox=r
b.selectedBox=s
b.pathLabel=h
b.copyButton=o

b:setPath(nil)

return c end



au.open=function(b, c)
b:create()
b.onSelectPart=c

if b.isOpen then
return
end

b.isOpen=true
b.frame.Visible=true
b.frame:TweenPosition(aq,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,an.tweenTime,true)

b:startSelecting()end



au.close=function(b)
if not b.isOpen then
return
end

b.isOpen=false
b:disconnectMouse()
b:clearSelection()

b.frame:TweenPosition(ar,Enum.EasingDirection.InOut,Enum.EasingStyle.Quart,an.tweenTime,true)

task.delay(an.tweenTime,function()

if not b.isOpen and b.frame then
b.frame.Visible=false
end
end)end


au.isPointerOverWindow=function(b)
return b.frame~=nil and ah:isMouseInGuiObject(b.frame)end


au.startSelecting=function(b)
b:disconnectMouse()

local c=ah:getMouse()

table.insert(b.connections,c.Move:Connect(function()
local d=c.Target


if b:isPointerOverWindow()or d==b.selectedPart then
d=nil
end

b.hoverBox.Adornee=d
end))

table.insert(b.connections,c.Button1Down:Connect(function()
if b:isPointerOverWindow()then
return
end

local d=c.Target
if d then
b:selectPart(d)
end
end))end


au.disconnectMouse=function(b)
for c,d in b.connections do
d:Disconnect()
end

b.connections={}end


au.selectPart=function(b, c)
b.selectedPart=c
b.selectedBox.Adornee=c
b.hoverBox.Adornee=nil
b:setPath(ak(c))end



au.setPath=function(b, c)
local d=b.pathLabel
b.path=c

if c then
ac:addObject(d,{TextColor3="Colors.Text.Default",Font="Font.MonoSpace"})
d.RichText=true
d.Text=al:apply(ax(c))
else
ac:addObject(d,{TextColor3="Colors.Text.Darker",Font="Font.MonoSpace"})
d.RichText=false
d.Text=aj.labels.hint
end end


au.clearSelection=function(b)
b.selectedPart=nil
b.hoverBox.Adornee=nil
b.selectedBox.Adornee=nil
b:setPath(nil)end



au.confirmSelection=function(b)
local c=b.selectedPart

if not c or not c.Parent then
b:clearSelection()
ad:notify(an.title,aj.messages.noPart)
return
end

if b.onSelectPart then
b.onSelectPart(c)
end end



au.copyPath=function(b)
local c=b.path

if not c then
ad:notify(an.title,aj.messages.noPath)
return
end

if not ai.setclipboard then
ad:notify(an.title,aj.messages.noClipboard)
return
end

ai.setclipboard(c)

local d=b.copyButton
d.Text=ap.copied

task.delay(ap.feedbackTime,function()
d.Text=aj.buttons.copyPath
end)end


au.destroy=function(b)
b.isOpen=false
b:disconnectMouse()

if b.hoverBox then
b.hoverBox:Destroy()
end

if b.selectedBox then
b.selectedBox:Destroy()
end

if b.frame then
b.frame:Destroy()
end

b.frame=nil
b.hoverBox=nil
b.selectedBox=nil
b.pathLabel=nil
b.copyButton=nil end


return au end a.dw=function()local ab=a.cache.dw if not ab then ab={c=aa()}a.cache.dw=ab end return ab.c end end do local aa=function()







































local aa=a.P()
local ab=a.au()
local ac=a.cE()

local ad=aa.TweenService
local ae=aa.UserInputService
local af=aa.RunService

local ag=0.32
local ah=0.1
local ai=10
local aj=50
local ak=0.3
local al=20
local am=3
local an=0.5


local ao=0.2
local ap=0.5
local aq=1

local ar={
[Enum.UserInputType.MouseButton1]=true,
[Enum.UserInputType.Touch]=true,
}

local as={}
as.__index=as














as.new=function(at)
local au=setmetatable({
frame=at.frame,
screenGui=at.screenGui,
topBarHeight=at.topBarHeight,
clampPosition=at.clampPosition,
getScale=at.getScale,
onMinimize=at.onMinimize,
onInteractive=at.onInteractive,

hoverToOpen=at.hoverToOpen==true and ae.MouseEnabled,
commandBarInUse=at.commandBarInUse,
isMoving=at.isMoving,
lastMovingAt=-math.huge,

state="minimized",
interactive=nil,
hovering=false,
hoverRequest=0,
dragging=false,
keepOpen=at.keepOpen==true,
windowParts={},
tween=nil,
press=nil,
touches={},
outsideTouches={},
swipeLocked=false,
lastInteractionAt=-math.huge,
connections={},
},as)

au.frame.Position=au:targetFor"minimized"

table.insert(au.connections,ab:Connect(ae.InputBegan,function(av)
au:onInputBegan(av)
end))

table.insert(au.connections,ab:Connect(ae.InputEnded,function(av)
au:onInputEnded(av)
end))

table.insert(au.connections,ab:Connect(ae.InputChanged,function(av)
au:onInputChanged(av)
end))


table.insert(au.connections,ab:Connect(af.Heartbeat,function()
if au.isMoving and au.isMoving()then
au.lastMovingAt=os.clock()
end

au:checkLockIdle()
end))

au:setInteractive(false)

if au.hoverToOpen then

table.insert(au.connections,ab:Connect(au.frame.MouseEnter,function()
if au.frame.Visible then au:setHovering(true)end
end))

table.insert(au.connections,ab:Connect(au.frame.MouseLeave,function()
au:setHovering(false)
end))
end

return au end local at=function(


at, au)
local av=at.AbsolutePosition
local aw=at.AbsoluteSize

return au.X>=av.X and au.X<=av.X+aw.X
and au.Y>=av.Y and au.Y<=av.Y+aw.Y end



as.isOverWindow=function(au, av)
if at(au.frame,av)then
return true
end

for aw,ax in au.windowParts do
if at(ax,av)then
return true
end
end

return false end



as.addWindowPart=function(au, av)
table.insert(au.windowParts,av)end



as.setKeepOpen=function(au, av)
au.keepOpen=av==true

if au.keepOpen and au.state=="minimized"then
au:expand()
end end



as.reveal=function(au)

au:lockSwipe()

if au.state=="minimized"then
au:expand()
end end






as.lockSwipe=function(au)
if au.hoverToOpen then return end
if not au:fingerOutsideWindow()then return end

au.swipeLocked=true
au.lastInteractionAt=os.clock()end



as.fingerOutsideWindow=function(au)
for av,aw in au.touches do
if not au:isOverWindow(aw)then
return true
end
end

return false end



as.unlockSwipe=function(au)
au.swipeLocked=false end




as.noteInteraction=function(au)
au.lastInteractionAt=os.clock()end




as.checkLockIdle=function(au)
if au.swipeLocked and os.clock()-au.lastInteractionAt>=am then
au.swipeLocked=false
end end



as.onSettled=function(au, av)
local aw=au.tween

if aw and aw.PlaybackState==Enum.PlaybackState.Playing then
aw.Completed:Once(av)
else
task.defer(av)
end end





as.nearestSnap=function(au)
local av=au.frame
local aw=av.AbsolutePosition.Y
local ax=au.screenGui.AbsoluteSize.Y-(av.AbsolutePosition.Y+av.AbsoluteSize.Y)

if aw<=ax then
return"top"
end

if au.state=="expanded"then
return"expanded"
end

return"minimized"end



as.targetFor=function(au, av)
local aw=au.clampPosition(au.frame.Position).X

if av=="top"then

return UDim2.new(aw.Scale,aw.Offset,0,0)
end

if av=="expanded"then

return UDim2.new(aw.Scale,aw.Offset,1,-au.frame.Size.Y.Offset)
end


return UDim2.new(aw.Scale,aw.Offset,1,-au.topBarHeight)end




as.clampDrag=function(au, av)
local aw=au.clampPosition(av).X

local ax=math.max(au.getScale(),0.01)
local ay=au.screenGui.AbsoluteSize.Y/ax
local az=math.max(ay-au.topBarHeight,0)
local b=math.clamp(av.Y.Scale*ay+av.Y.Offset,0,az)

return UDim2.new(aw.Scale,aw.Offset,0,b)end



as.wasMovingRecently=function(au)
return os.clock()-au.lastMovingAt<an end



as.setInteractive=function(au, av)
if au.interactive==av then return end
au.interactive=av

if au.onInteractive then
au.onInteractive(av)
end end


as.cancel=function(au)
if au.tween then
au.tween:Cancel()
au.tween=nil
end end


as.moveTo=function(au, av, aw, ax)

if av==au.state and au.tween and au.tween.PlaybackState==Enum.PlaybackState.Playing then
return
end

local ay=au.state=="minimized"
au.state=av
au:cancel()


if av=="minimized"then
au.swipeLocked=false
elseif ay then
au:lockSwipe()
end


if av=="minimized"then
au:setInteractive(false)
end

local az=au:targetFor(av)
local b=ac:getScale(aw or ag)

if b<=0 then
au.frame.Position=az
au:setInteractive(av~="minimized")
return
end

local c=TweenInfo.new(b,Enum.EasingStyle.Quart,ax or Enum.EasingDirection.Out)
local d=ad:Create(au.frame,c,{Position=az})
au.tween=d



d.Completed:Connect(function(e)
if e~=Enum.PlaybackState.Completed then return end
if au.tween~=d or au.state=="minimized"then return end

au:setInteractive(true)
end)

d:Play()end


as.expand=function(au, av, aw)
au:moveTo("expanded",av,aw)end




as.setHovering=function(au, av)
if av==au.hovering then return end
au.hovering=av


if au.dragging then return end

if av then
au:onHoverEnter()
else
au:onHoverLeave()
end end




as.onHoverEnter=function(au)
au.hoverRequest=au.hoverRequest+1

if au.state=="minimized"then
au:expand(ao,Enum.EasingDirection.InOut)
end end




as.onHoverLeave=function(au)
au.hoverRequest=au.hoverRequest+1
local av=au.hoverRequest

if not au:canHoverMinimize()then return end

task.delay(aq,function()
if av~=au.hoverRequest or not au:canHoverMinimize()then return end

au:minimize(ap,Enum.EasingDirection.InOut)
end)end



as.canHoverMinimize=function(au)
return au.state=="expanded"and not au.keepOpen and not au:commandBarBusy()end







as.onCommandBarClosed=function(au, av)
if not au.hoverToOpen then return end


if au:fingerOnWindow()then return end

local aw=au.hoverRequest
task.wait()


if aw~=au.hoverRequest or au.dragging or not au:canHoverMinimize()then return end
if au.hovering and not av then return end
if au:fingerOnWindow()then return end

au:minimize(ap,Enum.EasingDirection.InOut)end





as.onMobileEnter=function(au, av)
if au.hoverToOpen then return end



if not au:wasMovingRecently()then return end

task.wait()

if au.dragging or av()then return end
if au.state~="expanded"or au.keepOpen then return end

au:minimize()end





as.setDragging=function(au, av)
local aw=au.dragging
au.dragging=av==true



if aw and not au.dragging and au.hoverToOpen and not au.hovering then
au:onHoverLeave()
end end


as.minimize=function(au, av, aw)

if au.onMinimize then
au.onMinimize()
end

au:moveTo("minimized",av,aw)end



as.reflow=function(au)
au:cancel()
au.frame.Position=au:targetFor(au.state)
au:setInteractive(au.state~="minimized")end




as.sleep=function(au)
au:cancel()
au.state="minimized"
au.swipeLocked=false
au.frame.Position=au:targetFor"minimized"
au:setInteractive(false)end



as.onDragEnded=function(au, av)
if av.travel<=ai then

au:moveTo(au.state)
return
end

if av.dy>=aj and not au:commandBarBusy()and not au.swipeLocked then
au:minimize()
return
end

au:moveTo(au:nearestSnap())end





as.onListSwipeDown=function(au)
if au.hoverToOpen or au.swipeLocked then return end
if au.state=="minimized"or au:commandBarBusy()then return end

au:minimize()end



as.commandBarBusy=function(au)
return au.commandBarInUse~=nil and au.commandBarInUse()==true end



as.fingerOnWindow=function(au)
for av,aw in au.touches do
if au:isOverWindow(aw)then
return true
end
end

return false end



as.onInputChanged=function(au, av)
if av.UserInputType~=Enum.UserInputType.Touch then return end
if au.touches[av]==nil then return end

au.touches[av]=av.Position

if au:isOverWindow(av.Position)then
au:noteInteraction()
end

local aw=au.outsideTouches[av]
if aw and(av.Position-aw).Magnitude>=al then
au:onOutsideSwipe()
end end





as.onOutsideSwipe=function(au)
if au.hoverToOpen or au.dragging or au.swipeLocked then return end
if au.state~="expanded"or au.keepOpen or au:commandBarBusy()then return end

table.clear(au.outsideTouches)
au:minimize()end


as.onInputBegan=function(au, av)
if av.UserInputType==Enum.UserInputType.Touch then
au.touches[av]=av.Position

if au:isOverWindow(av.Position)then
au:noteInteraction()
else
au.outsideTouches[av]=av.Position
end
end

if not ar[av.UserInputType]then return end

au.press={
type=av.UserInputType,
time=os.clock(),
position=av.Position,
inside=au:isOverWindow(av.Position),

startedExpanded=au.state=="expanded",
}end



as.onInputEnded=function(au, av)
if av.UserInputType==Enum.UserInputType.Touch then
au.touches[av]=nil
au.outsideTouches[av]=nil
end

local aw=au.press
if not aw or av.UserInputType~=aw.type then return end
au.press=nil

local ax=os.clock()-aw.time
local ay=(av.Position-aw.position).Magnitude

if aw.inside then

if ax<=ah and ay<=ai and au.state=="minimized"then
au:expand()
end

return
end



local az=ax<=ak and ay<=ai

if az and aw.startedExpanded and not au.hoverToOpen and au.state=="expanded"and not au.keepOpen
and not au:commandBarBusy()and not au:wasMovingRecently()then
au:minimize()
end end


as.destroy=function(au)
au:cancel()
au.hoverRequest=au.hoverRequest+1

for av,aw in au.connections do
ab:disconnect(aw)
end
table.clear(au.connections)
table.clear(au.touches)
table.clear(au.outsideTouches)end


return as end a.dx=function()local ab=a.cache.dx if not ab then ab={c=aa()}a.cache.dx=ab end return ab.c end end do local aa=function()



local aa=a.ap()
local ab=a.cQ()
local ac=a.b()
local ad=a.a()
local ae=a.au()
local af=a.P()
local ag=a.bX()

local ah=a.R()

local ai=a.al()
local aj=a.d()
local ak=a.cK()

local al=a.cM()
local am=a.cO()
local an=a.cL()

local ao=a.cJ()
local ap=a.bY()
local aq=a.cT()

local ar=a.c4()
local as=a.cP()
local at=a.c5()

local au=a.c6()
local av=a.c9()
local aw=a.db()
local ax=a.df()
local ay=a.dh()
local az=a.dj()
local b=a.dt()
local c=a.dw()

local d=a.dd()
local e=a.dx()

local f=450
local h=as.uiScale

local i={
awoken=false,
}local j=function(

j)
local k=type(j)=="string"and ao[j:lower()]

if k and k.Colors and k.Font then
return j
end

return aa.theme.defaultTheme end local k=function(


k, l, m, n)
local o=(k.Scale*m)/n+k.Offset
local p=math.floor(m/n-l)

if math.floor(o)>=p then
return 1,-l
end

return 0,math.clamp(math.floor(o),0,math.max(p,0))end


i.awake=function(l)
if l.awoken then
return l.screenGui
end

l.awoken=true

l:setupTheme()
l:setupScreenGui()
l:setupScale()
l:setupMainFrame()
l:createQuickCapture()
l:createReference()
l:createPartPath()
l:createNotifications()
l:setupListeners()
l:updateNotificationsPosition()

aj:log"interface started"
return l.screenGui end


i.setupTheme=function(l)
aj:debug"interface: initializing theme service"

an:init{
theme=j(aa.theme.selectedTheme),
}end


i.setupScreenGui=function(l)
local m=l:createScreenGui()

m.Parent=ap
ac.screenGui=m

h.Parent=m end


i.setupScale=function(l)
l:setScale(ai:getValue"interface.uiScale"or 1)end


i.setupMainFrame=function(l)
local m=l:createMainFrame()

l:createCommands()
l:dragMainFrame(m)
l.commands:enable()

m.Parent=l.screenGui end


i.setupListeners=function(l)
ae:Connect(l.screenGui:GetPropertyChangedSignal"AbsoluteSize",function()
l:updateMainFramePosition()
end)

ae:Connect(l.mainFrame:GetPropertyChangedSignal"AbsolutePosition",function()
l:updateNotificationsPosition()
end)

ae:Connect(l.mainFrame:GetPropertyChangedSignal"AbsoluteSize",function()
l:updateNotificationsPosition()
end)

ae:Connect(af.RunService.RenderStepped,function()
l:updateNotificationsPosition()
end)end


i.createScreenGui=function(l)
local m=al.new("ScreenGui",{
IgnoreGuiInset=true,
Name=ak.randomString(math.random(30,50)),
DisplayOrder=2147483647,
})

l.screenGui=m
return m end


i.calculateScale=function(l, m)
return(l.screenGui.AbsoluteSize.Y/f)*m end


i.setScale=function(l, m)
m=math.abs(m)

if m>=3 then
m=l:calculateScale(m)
end

if ai:getValue"interface.uiScale"~=m then
ai:setValue("interface.uiScale",m)
ai:save()
end

as:setScale(m)
l:updateMainFramePosition()end


i.calculateMainFramePosition=function(l, m)
local n=l.mainFrame
local o=l.screenGui
local p=as:getScale()
local q=n.Size

m=m or n.Position

local r,s=k(m.X,q.X.Offset,o.AbsoluteSize.X,p)
local t,u=k(m.Y,q.Y.Offset,o.AbsoluteSize.Y,p)

return UDim2.new(r,s,t,u)end


i.updateMainFramePosition=function(l)
if not l.mainFrame then return end

if l.dock then
l.dock:reflow()
else
l.mainFrame.Position=l:calculateMainFramePosition()
end

l:updateNotificationsPosition()end


i.createMainScroll=function(l, m)
local n=av.new{
isHorizontal=false,
barThickness=12,
}

local o=n:create()
local p=n.container

local q=al.new("Frame","ScrollHolder",m,{
Size=UDim2.new(1,0,0,180),
Position=UDim2.fromScale(0.5,1),
AnchorPoint=Vector2.new(0.5,1),
BackgroundTransparency=1,
Active=true,

o,
p,
})

l.scrollHolder=q
l.scrollBar=n
l.scrollContainer=p

return n end


i.createMainFrame=function(l)
local m=au:create()
local n=m.mainFrame

m.titleLabel.Text=ar.getDisplayName()

l.mainFrame=n
l.topBar=m.topBar
l.buttons=m.buttons

am:loadImage(l.buttons.settings,"settings")
am:loadImage(l.buttons.reference,"reference")

l:createMainScroll(n)

l.settings=b.new{

onSwitch=function(o,p)
if o=="keepMenuOpen"and l.dock then
l.dock:setKeepOpen(p)
end


if o=="keepIY"and p and ad.queueteleport==nil then
l:setKeepIY(false)
aq:notify("Keepiy","your exploit does not support queueteleport")
end
end,
}
l.settings:create(n,l.scrollHolder)

ae:Connect(l.buttons.settings.Activated,function()
l.settings:toggle()
end)

return n end


i.createCommands=function(l)
local m=l.scrollBar

local n=aw.new{
scrolledSignal=m.scrolledSignal,
scrollContainer=l.scrollContainer,
scrollHolder=l.scrollHolder,
screenGui=l.screenGui,
scrollBar=m,

configs={
placeholderText=aa.ui.commands.placeholderText,
padding=aa.ui.commands.padding,
labelSize=aa.ui.commands.labelSize,
textSize=aa.ui.commands.textSize,
},
}

aj:log"created commands interface"
n:create()

aj:log"initialized commands"
n:createCommandsData()

aj:log"awaked commands module"
n:awake()

l.commands=n


n.onCommandSent=function()
if l.dock then
l.dock:unlockSwipe()
end
end


n.onInteraction=function()
if l.dock then
l.dock:noteInteraction()
end
end

l.settings:watchCommandBar(n.searchBox)

if ag then

n.onSwipeDown=function()
if l.dock then
l.dock:onListSwipeDown()
end
end

ae:Connect(n.searchBox.Focused,function()
l.commandBarUsedAt=os.clock()
end)

ae:Connect(n.searchBox.FocusLost,function(o)
l.commandBarUsedAt=os.clock()


if o and l.dock then
l.dock:onMobileEnter(function()
return n.searchBox:IsFocused()
end)
end
end)
else

ae:Connect(n.searchBox.FocusLost,function(o)
if l.dock then
l.dock:onCommandBarClosed(o)
end
end)
end

return n end


i.createInfoMenu=function(l)
return ay:create()end


i.chatLogs=function(l, m)
return az:open(m or"chat")end


i.dragMainFrame=function(l, m)
m.Size=aa.ui.window.windowSize

m.Position=UDim2.fromOffset(1e5,1e5)
m.Position=l:calculateMainFramePosition()

l.dock=e.new{
frame=m,
screenGui=l.screenGui,
topBarHeight=l.topBar.Size.Y.Offset,
keepOpen=b.isKeepMenuOpen(),
clampPosition=function(n)
return l:calculateMainFramePosition(n)
end,
getScale=function()
return as:getScale()
end,
commandBarInUse=function()
return l:isCommandBarInUse()
end,
isMoving=function()
return l:isCharacterMoving()
end,
onInteractive=function(n)
if l.commands then
l.commands:setInteractive(n)
end
end,
hoverToOpen=not ag,
onMinimize=function()
l:releaseCommandFocus()


if l.hidden then
l:hideWindow()
end
end,
}

d:addGuiObject(m)

d:setFilter(m,function(n)
return l.dock:clampDrag(n)
end)

d.dragStarted:Connect(function(n)
if n~=m then return end

l.dock:cancel()
l.dock:setDragging(true)
l.scrollBar:disableScroll()
end)

d.dragEnded:Connect(function(n,o)
if n~=m then return end

l.scrollBar:enableScroll()
l.dock:setDragging(false)
l.dock:onDragEnded(o)
end)end



local l=0.3

i.isCommandBarInUse=function(m)
local n=m.commands and m.commands.searchBox
if n and n:IsFocused()then
return true
end

return os.clock()-(m.commandBarUsedAt or 0)<l end




i.isCharacterMoving=function(m)
local n=ah:getHumanoid()
if not n then return false end

if n.MoveDirection.Magnitude>0.05 then
return true
end

local o=n.RootPart
if not o then return false end

local p=o.AssemblyLinearVelocity
return Vector3.new(p.X,0,p.Z).Magnitude>1 end


i.releaseCommandFocus=function(m)
local n=m.commands and m.commands.searchBox

if n and n:IsFocused()then
n:ReleaseFocus()
end end



i.showWindow=function(m)
m.hidden=false
m:revealWindow()end




i.revealWindow=function(m)
if not m.mainFrame then return end

m.mainFrame.Visible=true
if m.dock then
m.dock:reveal()
end end



i.hideWindow=function(m)
if not m.mainFrame then return end

m.hidden=true
m.mainFrame.Visible=false

if m.dock then
m.dock:sleep()
end

m:releaseCommandFocus()end


i.showCommandBar=function(m)
local n=m.commands and m.commands.searchBox
if not n then return end

m:revealWindow()

m.dock:onSettled(function()
if m.dock.state=="minimized"then return end

m.commands:captureFocus()
end)end



i.setKeepIY=function(m, n)
b.setKeepIY(n)

if m.settings then
m.settings:refresh()
end end


i.createQuickCapture=function(m)
if not ag then return end

local n=al.new("TextButton",ak.randomString(math.random(30,50)),m.screenGui,{
BackgroundTransparency=0.14,
Position=UDim2.fromScale(0.5,0.15),
AnchorPoint=Vector2.new(0.5,0.5),
Size=UDim2.new(0,25,0,25),
Font=Enum.Font.SourceSansBold,
Text="IY",
TextSize=16,
ZIndex=10,
ThemeTag={
TextColor3="Colors.Icons",
BackgroundColor3="Colors.Buttons.Default"
},
al.new("UICorner",{
CornerRadius=UDim.new(0.5,0)
}),
})

m.dock:addWindowPart(n)
d:addGuiObject(n)

ae:Connect(n.Activated,function()
m:showCommandBar()
end)

m.quickCapture=n
return n end


i.createReference=function(m)
local n=ax.new()
local o=n:create()

am:loadImage(n.closeIcon,"close")

o.Parent=m.screenGui
m.reference=n

ae:Connect(m.buttons.reference.Activated,function()
n:open()
end)

return n end


i.createPartPath=function(m)
local n=c.new()
local o=n:create()

o.Parent=m.screenGui
m.partPathWindow=n

return n end




i.openPartPath=function(m, n)
if not m.partPathWindow then return end

m.partPathWindow:open(n)end


i.createNotifications=function(m)
local n=aq:getContainer(m.screenGui)
m.notificationsContainer=n

aq.onLayoutChanged=function()
m:updateNotificationsPosition()
end

m:updateNotificationsPosition()
return n end


i.updateNotificationsPosition=function(m)
local n=m.notificationsContainer
local o=m.mainFrame
local p=m.screenGui
if not(n and o and p)then return end



local q=as:getScale()
local r=p.AbsoluteSize/q

local s=o.Position
local t=at.compute({
x={scale=s.X.Scale,offset=s.X.Offset},
y={scale=s.Y.Scale,offset=s.Y.Offset},
width=o.Size.X.Offset,
height=o.Size.Y.Offset,
},{
width=r.X,
height=r.Y,
},{
width=n.Size.X.Offset,
},ab.gapToWindow)


aq:setRoom(t.room)

n.AnchorPoint=Vector2.new(t.anchorX,t.anchorY)
n.Position=UDim2.new(t.x.scale,t.x.offset,t.y.scale,t.y.offset)end


i.destroy=function(m)
aq:destroy()
if m.dock then
m.dock:destroy()
m.dock=nil
end

az:reset()

if m.partPathWindow then
m.partPathWindow:destroy()
m.partPathWindow=nil
end

if m.screenGui then
m.screenGui:Destroy()
end

m.screenGui=nil
m.awoken=false end


return i end a.dy=function()local ab=a.cache.dy if not ab then ab={c=aa()}a.cache.dy=ab end return ab.c end end do local aa=function()a.e()


:init()

local aa=a.cV()
local ab=a.cX()
local ac=a.R()
local ad=a.cB()
local ae=a.c2()



local af=a.dy()

local ag={}

ag.boot=function(ah)
ah.boot=nil

aa:init{
infiniteYield=af,
playerService=ac,
fetchService=ad
}

ab.start()


af:awake()


ae.start()end


return ag end a.dz=function()local ab=a.cache.dz if not ab then ab={c=aa()}a.cache.dz=ab end return ab.c end end end



















return a.dz():boot()