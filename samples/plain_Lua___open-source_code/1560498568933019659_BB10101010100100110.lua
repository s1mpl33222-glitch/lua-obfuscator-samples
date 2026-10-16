a=game:GetService("Players")

b=game:GetService("RunService")

c=game:GetService"ReplicatedStorage"

d=game:GetService"UserInputService"

e=game:GetService"TweenService"

f=game:GetService"Debris"

g=game:GetService"Workspace"

h=game:GetService"ContextActionService"

i=c:WaitForChild"Remotes"

j=require(c.Modules.Core.Util)

k=require(c.Modules.Game.UI.BuyPromptUI)

l=require(c.Modules.Game.Emotes.EmotesUI)

m=require(c.Modules.Game.Emotes.EmotesList)

n=require(c.Modules.Core.UI)

o=require(c.Modules.Core.Char)

p=c:WaitForChild"Items"

q=p:WaitForChild"melee"

r=a.LocalPlayer

s=r.Character or r.CharacterAdded:Wait()

t=s:WaitForChild"Humanoid"

u=s:WaitForChild"HumanoidRootPart"

v=a.LocalPlayer

local w={}

x=workspace:WaitForChild"DroppedItems"



y=g.CurrentCamera

r:GetMouse()

z=d.TouchEnabled and not d.KeyboardEnabled



local A

pcall(

function()

A=loadstring(game:HttpGet"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")()

end

)

local B
if A then
B=
A:CreateWindow
{
Title="BB Hub |กุไม่แจก🔫",
Icon="rbxassetid://100758136601163",
Author="[🔫] Tik Tok |@rc43283 ",
Folder="Boss",
Size=UDim2.fromOffset(650,400),
Theme="Dark",
Transparent=true,
Resizable=true,
KeyCode=Enum.KeyCode.L
}

B:EditOpenButton({
    Title = "BB Hub |กุไม่แจก🔫",
    Icon ="rbxassetid://100758136601163",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("#FFFFFF"), 
        Color3.fromHex("#000000")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

B:Tag({
    Title = "PVP | Paid",
    Icon = "github",
    Color = Color3.fromHex("#ac30ff"),
    Radius = 13,
})

else

B={

Tab=function(C)

return{

Section=function()

end,

Toggle=function()

end,

Slider=function()

end,

Button=function()

end,

Input=function()

return{}

end,

Divider=function()

end

}

end

}

end



local C=B.ConfigManager

local D=C:CreateConfig"CathubConfig"

local E

pcall(

function()

E=c:WaitForChild("Remotes",5):WaitForChild("Send",5)

end

)


local Radius = 50
local CheckInterval = 0.0000001
local ActiveConnections = {}

local PingHistory = {}
local MaxHistory = 10

local G=false

local H=120

local I

local J

local K=Drawing.new"Line"

K.Thickness=1

K.Color=Color3.fromRGB(255,50,50)

K.Transparency=1

K.Visible=false



local L={}

local M=false

local N=false

local O=false

local P={}



local Q=false

local R=0.05

local S=false

local T=false

local U=40

local V=false

local W=false

local X

local Y=10

local Z

local _

local aa

local ab=false

local ac=0

local ad=false




local ae=1

local af=0.4

local ag=false

local ah

local ai=getgenv or function()

return _G

end

ai().Sky=false

ai().SkyAmount=1000

local aj=false

local ak=false

local JumpHeight = 30

local al={}

local am=-100

local an=30

local ao=0.1









local ap=20

local aq=0

local ar=0

local as=false



local at={Common=

Color3.fromRGB(255,255,255),Uncommon=

Color3.fromRGB(99,255,52),Rare=

Color3.fromRGB(51,170,255),Epic=

Color3.fromRGB(237,44,255),Legendary=

Color3.fromRGB(255,150,0),Omega=

Color3.fromRGB(255,20,51)

}

local au={}

local av={}

local aw=false

local ax

local ay=false

local az={}

local aA=100

local aB={}



local aC

pcall(

function()

for aD,aE in ipairs(getgc(true))do

if typeof(aE)=="table"and rawget(aE,"event")and rawget(aE,"func")then

aC=aE

break

end

end

end

)



local function getPing()

local aD=r:FindFirstChild"PlayerGui"

if not aD then

return 0.2

end



local aE=aD:FindFirstChild"NetworkStats"

if not aE then

return 0.2

end



local aF=aE:FindFirstChild"PingLabel"

if not aF then

return 0.2

end



local aG=aF.Text

if typeof(aG)~="string"then

return 0.2

end



local aH=tonumber(aG:match"%d+")

if not aH then

return 0.2

end



local aI=aH/1000

if aI<0 or aI>2 then

aI=0.2

end



return aI

end



local function isPlayerExcluded(aD)

for aE,aF in ipairs(P)do

if aF~=""and string.find(string.lower(aD),string.lower(aF))then

return true

end

end

return false

end

local function getClosestTarget()

local aD

local aE=H

local aF=Vector2.new(y.ViewportSize.X/2,y.ViewportSize.Y/2)

for aG,aH in ipairs(a:GetPlayers())do

if aH~=r and aH.Character then

local aI=aH.Character:FindFirstChild"Head"

local aJ=aH.Character:FindFirstChild"Humanoid"

local aK=aH.Character:FindFirstChild"HumanoidRootPart"

if aI and aJ and aJ.Health>0 and aK then

local aL,aM=y:WorldToViewportPoint(aI.Position)

if aM then

local aN=Vector2.new(aL.X,aL.Y)

local aO=(aN-aF).Magnitude

if aO<=H and not isPlayerExcluded(aH.Name)then

if aO<aE then

aE=aO

aD=aH

end

end

end

end

end

end

return aD

end

local function GetSmoothedPing()
    local Stats = game:GetService("Stats")
    local PingStats = Stats.Network.ServerStatsItem["Data Ping"]
    local pingValue = PingStats:GetValue()
    
    table.insert(PingHistory, pingValue)
    if #PingHistory > MaxHistory then
        table.remove(PingHistory, 1)
    end
    
    local sum = 0
    for _, val in ipairs(PingHistory) do
        sum = sum + val
    end
    return (sum / #PingHistory) / 1000
end

-- Position Prediction
local function predictPosition(aD, aE)
    if not aD then return Vector3.zero end
    
    local aF = GetSmoothedPing()
    if aF > 1 then aF = aF + 0.15 end
    
    local aG = (aE and aE.AssemblyLinearVelocity) or Vector3.zero
    return aD.Position + (aG * aF * 1)
end


local function isBehindWall(aD,aE)

local aF=aE-aD

if aF.Magnitude<1 then

return false

end



local aG={}



local aH=r.Character

if aH then

table.insert(aG,aH)

end



local aI=I and I.Character

if aI then

table.insert(aG,aI)

end



local aJ=workspace:Raycast(aD,aF,RaycastParams.new())

if not aJ then

return false

end



local aK=aJ.Instance

return aK and not table.find(aG,aK.Parent)

end


local function setupCharacter(aD)

s=aD

t=aD:WaitForChild"Humanoid"

u=aD:WaitForChild"HumanoidRootPart"

if _ then

pcall(

function()

_:Disconnect()

end

)

end

_=

b.RenderStepped:Connect(

function()

if Q and t and u then

if t.MoveDirection.Magnitude>0 then

u.CFrame=u.CFrame+(t.MoveDirection.Unit*R)

end

end

end

)

end

local function isDowned()

local aD=o.get_hum()

if not aD then

return false

end





if aD.Health<=0 then

return false

end



return aD:GetAttribute"HasBeenDowned"or aD:GetAttribute"IsDead"

end



local function getHRP()

local aD=o.current_char.get()

if not aD then

return

end

return aD:FindFirstChild"HumanoidRootPart"

end



local function teleportUnderground()

local aD=getHRP()

if not aD then

return

end

if not ah then

local aE=aD.CFrame

ah=aE+Vector3.new(0,am,0)

end

    aD.CFrame = CFrame.new(ah.Position)
end



local function flickerAndMove()

if ag then

return

end

ag=true



task.spawn(

function()

while ag and enabled and isDowned()do

local aD=o.get_hum()

if aD and aD.Health<=0 then

break

end



local aE=getHRP()

if aE and ah then

local aF=math.random()*math.pi*2

local aG=Vector3.new(math.cos(aF),0,math.sin(aF))*an

local aH=ah.Position+aG



aE.CFrame=CFrame.new(aH)

task.wait(0.05)

aE.CFrame=ah

end



task.wait(ao)

end



ag=false

end

)

end



local function NetGet(...)

if not aC or not aC.func then

return

end

local aD={...}

for aE,aF in ipairs(aD)do

if typeof(aF)=="Instance"then

if aF:IsA"Model"and#aF:GetChildren()==0 then

local aG=g:FindFirstChild"DroppedItems"

if aG then

local aH=aG:FindFirstChildWhichIsA"Model"

if aH then

aD[aE]=aH

else

return

end

else

return

end

end

end

end

aC.func=(aC.func or 0)+1

local aE,aF=

pcall(

function()

local aE=c:WaitForChild"Remotes":WaitForChild"Get"

return aE:InvokeServer(aC.func,unpack(aD))

end

)

if not aE then

warn("[NetGet Error]",aF)

end

return aF

end




local function GetDroppedItemsContainer()
    return workspace:FindFirstChild("DroppedItems")
end

local function PickupItem(Item, Character)
    local PickupZone = Item:FindFirstChild("PickUpZone")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if PickupZone and HumanoidRootPart then
        
        pcall(function()
            firetouchinterest(PickupZone, HumanoidRootPart, 0)
            firetouchinterest(PickupZone, HumanoidRootPart, 1)
        end)
    end
end


local function CheckAndPickup()
    local Character = r.Character 
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local CharacterPosition = Character:GetPivot().Position
    local DroppedItemsContainer = GetDroppedItemsContainer()
    
    if DroppedItemsContainer then
        for _, Item in ipairs(DroppedItemsContainer:GetChildren()) do
            if Item:IsA("Model") then
                local ItemPosition = Item:GetPivot().Position
                local Distance = (ItemPosition - CharacterPosition).Magnitude
                
                if Distance <= Radius then
                    PickupItem(Item, Character)
                end
            end
        end
    end
end




local function SafeCall(aD,...)

local aE,aF=pcall(aD,...)

return aE,aF

end



local aD=table.unpack or unpack



local function CallRemote(aE,...)

if not aE then

return

end



local aF={...}



if aE.ClassName=="RemoteEvent"then

if aC and type(aC.event)=="number"then

aC.event=aC.event+1

SafeCall(

function(...)

aE:FireServer(aC.event,...)

end,

aD(aF)

)

else

aq=(aq or 0)+1

SafeCall(

function(...)

aE:FireServer(aq,...)

end,

aD(aF)

)

end

elseif aE.ClassName=="RemoteFunction"then

if aC and type(aC.func)=="number"then

aC.func=aC.func+1

SafeCall(

function(...)

aE:InvokeServer(aC.func,...)

end,

aD(aF)

)

else

ar=(ar or 0)+1

SafeCall(

function(...)

aE:InvokeServer(ar,...)

end,

aD(aF)

)

end

else

SafeCall(

function(...)

if aE.FireServer then

aE:FireServer(...)

elseif aE.InvokeServer then

aE:InvokeServer(...)

end

end,

aD(aF)

)

end

end



local function getPlayersInRange(aE)

local aF={}

local aG=r.Character

if not aG or not aG.PrimaryPart then

return aF

end

local aH=aG.PrimaryPart.Position

for aI,aJ in pairs(a:GetPlayers())do

if aJ~=r and aJ.Character and aJ.Character.PrimaryPart then

local aK,aL=

pcall(

function()

return(aJ.Character.PrimaryPart.Position-aH).Magnitude

end

)

if aK and aL and aL<=aE then

table.insert(aF,aJ)

end

end

end

return aF

end



local function getActiveTool()

local aE=r and r.Character

if aE then

for aF,aG in ipairs(aE:GetChildren())do

if

pcall(

function()

return aG:IsA"Tool"

end

)and aG:IsA"Tool"

then

return aG

end

end

end

local aF=r and r:FindFirstChild"Backpack"

if aF then

for aG,aH in ipairs(aF:GetChildren())do

if

pcall(

function()

return aH:IsA"Tool"

end

)and aH:IsA"Tool"

then

return aH

end

end

end

return nil

end



local function isMeleeTool(aE)

if not aE then

return false

end

if aE.Name=="Fists"then

return true

end



local aF=game:GetService"ReplicatedStorage"

local aG=aF:WaitForChild"Items":WaitForChild"melee"

local aH=aF:WaitForChild"Items":WaitForChild"throwable"

if aG:FindFirstChild(aE.Name)and not aH:FindFirstChild(aE.Name)then

return true

end



return false

end



local function AttackNearby()

if not E then

return

end

local aE=r.Character

if not aE or not aE.PrimaryPart then

return

end



local aF=getActiveTool()

if not aF or not isMeleeTool(aF)then

return

end

local aG,aH=

pcall(

function()

return aF.Parent

end

)

if not aG or aH~=r.Character then

return

end



local aI=getPlayersInRange(ap)

if#aI==0 then

return

end



local aJ,aK=

pcall(

function()

return aE.PrimaryPart.Position

end

)

if not aJ or not aK then

return

end



local aL={}

local aM={}



for aN,aO in pairs(aI)do

if aO and aO.Character and aO.Character.PrimaryPart then

local aP=aO.Character:FindFirstChild"Head"

local aQ=aO.Character.PrimaryPart

if aP and aQ then

local aR=predictPosition(aP,aQ)

table.insert(aL,aO)

table.insert(aM,aR)

end

end

end



if#aL==0 then

return

end



local aN=aM[1]

local aO=CFrame.lookAt(aK,aN)



local aP={

"melee_attack",

aF,

aL,

aO,

0.75

}



pcall(

function()

CallRemote(E,aD(aP))

end

)

end



local aE=false

local function StartAutoAttack()

if aE then

return

end

aE=true

task.spawn(

function()

while aE do

task.wait(af)

if ab and r and r.Character and r.Character.PrimaryPart then

pcall(AttackNearby)

end

end

end

)

end



local function createNeonEffectAtPosition(aF,aG)

if not s then

return

end

end

local function performTeleport()

if not u then

return

end

local aF=u.Position

local aG=Vector3.new(aF.X,aF.Y-Y,aF.Z)

u.CFrame=CFrame.new(aG)

X=aG.Y

local aH=Instance.new"Sound"

aH.SoundId="rbxassetid://108156925383225"

aH.Volume=1

aH.PlayOnRemove=true

aH.Parent=u

aH:Destroy()

createNeonEffectAtPosition(aF,1.5)

createNeonEffectAtPosition(aG,2)

end

local function toggleTeleport()

if not W then

return

end

V=not V

if V then

performTeleport()

else

X=nil

end

end

local aF

local function lockYPosition()

if aF then

pcall(

function()

aF:Disconnect()

end

)

end

aF=

b.Heartbeat:Connect(

function()

if V and X and u then

local aG=u.Position

if math.abs(aG.Y-X)>0.1 then

u.CFrame=CFrame.new(aG.X,X,aG.Z)

end

end

end

)

end



local function registerItems(aG)

for aH,aI in ipairs(aG:GetChildren())do

if aI:IsA"Tool"then

local aJ=aI:FindFirstChild"Handle"

local aK

local aL=aI:GetAttribute"DisplayName"or aI.Name

local aM=aI:GetAttribute"ItemId"or aI:GetAttribute"Id"or aI.Name

local aN=aI:GetAttribute"RarityName"or"Common"

local aO=aI:GetAttribute"ImageId"or"rbxassetid://7072725737"





if aJ then

local aP=aJ:FindFirstChildOfClass"SpecialMesh"

if aP and aP.MeshId~=""then

aK=aP.MeshId..(aP.TextureId or"").."_RARITY_"..aN

elseif aJ:IsA"MeshPart"and aJ.MeshId~=""then

aK=aJ.MeshId..(aJ.TextureID or"").."_RARITY_"..aN

end

end





if not aK and aM and aM~=""and aM~=aI.Name then

aK="ITEMID_"..aM.."_RARITY_"..aN

end





if not aK then

aK="NAME_"..aL.."_"..aI.Name.."_RARITY_"..aN

end





if au[aK]then

warn(

"Duplicate weapon key detected: "..aK.." (Tool: "..aI.Name..", Rarity: "..aN..")"

)

end



au[aK]={

Name=aL,

Rarity=aN,

ImageId=aO,

ToolName=aI.Name

}

end

end

end



local function getItemKey(aG)

local aH=aG:FindFirstChild"Handle"

local aI=aG:GetAttribute"DisplayName"or aG.Name

local aJ=aG:GetAttribute"ItemId"or aG:GetAttribute"Id"or aG.Name

local aK=aG:GetAttribute"RarityName"or"Common"



if aH then

local aL=aH:FindFirstChildOfClass"SpecialMesh"

if aL and aL.MeshId~=""then

return aL.MeshId..(aL.TextureId or"").."_RARITY_"..aK

elseif aH:IsA"MeshPart"and aH.MeshId~=""then

return aH.MeshId..(aH.TextureID or"").."_RARITY_"..aK

end

end



if aJ and aJ~=""and aJ~=aG.Name then

return"ITEMID_"..aJ.."_RARITY_"..aK

end



return"NAME_"..aI.."_"..aG.Name.."_RARITY_"..aK

end



local function getWeaponInfo(aG)

if not aG or not aG:IsA"Tool"then

return nil

end

local aH=getItemKey(aG)

return au[aH]

end



local function createBillboardForPlayer(aG)

if not aw or aG==r then

return

end

local aH=aG.Character

if not aH then

return

end

local aI=aH:FindFirstChild"HumanoidRootPart"

if not aI then

return

end

if av[aG]then

av[aG]:Destroy()

av[aG]=nil

end

local aJ=Instance.new"BillboardGui"

aJ.Adornee=aI

aJ.Size=UDim2.new(0,90,0,20)

aJ.StudsOffset=Vector3.new(0,-5,0)

aJ.AlwaysOnTop=true

aJ.Parent=aH

aJ:ClearAllChildren()

local aK=Instance.new("UIListLayout",aJ)

aK.FillDirection=Enum.FillDirection.Horizontal

aK.SortOrder=Enum.SortOrder.LayoutOrder

aK.Padding=UDim.new(0,5)

aK.HorizontalAlignment=Enum.HorizontalAlignment.Center

local aL={}

for aM,aN in ipairs{"Backpack","StarterGear","StarterPack"}do

local aO=aG:FindFirstChild(aN)

if aO then

for aP,aQ in ipairs(aO:GetChildren())do

if aQ:IsA"Tool"and aQ.Name~="Fists"then

table.insert(aL,aQ)

end

end

end

end

if aH then

for aM,aN in ipairs(aH:GetChildren())do

if aN:IsA"Tool"and aN.Name~="Fists"then

table.insert(aL,aN)

end

end

end

for aM,aN in ipairs(aL)do

local aO=getWeaponInfo(aN)

if aO then

local aP=Instance.new("ImageLabel",aJ)

aP.Size=UDim2.new(0,20,0,20)

aP.BackgroundTransparency=0.1

aP.Image=aO.ImageId

aP.BackgroundColor3=Color3.fromRGB(255, 255, 255)

Instance.new("UICorner",aP).CornerRadius=UDim.new(0,5)

local aQ=Instance.new("UIStroke",aP)

aQ.Color=at[aO.Rarity]or Color3.new(1,1,1)

aQ.Thickness=2

end

end

av[aG]=aJ

end



local function setFinishPrompt(aG)

if aG and aG:IsA"ProximityPrompt"then

aG.HoldDuration=ae

aG.MaxActivationDistance=20

end

end

local function tryHoldPrompt(aG,aH)

if not aG or aG:GetAttribute"__AutoFinishBusy"then

return

end

aG:SetAttribute("__AutoFinishBusy",true)

pcall(

function()

if aG.InputHoldBegin then

aG:InputHoldBegin()

end

end

)

pcall(

function()

if aG.HoldBegin then

aG:HoldBegin()

end

end

)

pcall(

function()

if aG.Trigger then

aG:Trigger()

end

end

)

task.wait(aH)

pcall(

function()

if aG.InputHoldEnd then

aG:InputHoldEnd()

end

end

)

pcall(

function()

if aG.HoldEnd then

aG:HoldEnd()

end

end

)

aG:SetAttribute("__AutoFinishBusy",nil)

end

local function findFinishPrompts()

local aG={}

for aH,aI in pairs(workspace:GetChildren())do

local aJ=a:GetPlayerFromCharacter(aI)

if aJ and not isPlayerExcluded(aJ.Name)then

local aK=aI:FindFirstChild"HumanoidRootPart"

if aK then

local aL=aK:FindFirstChild"FinishPrompt"

if aL then

setFinishPrompt(aL)

table.insert(aG,aL)

end

end

end

end

return aG

end

local function applyToAll()

for aG,aH in ipairs(a:GetPlayers())do

if aH~=r and aH.Character then

local aI=aH.Character:FindFirstChild"HumanoidRootPart"

if aI then

local aJ=aI:FindFirstChild"FinishPrompt"

if aJ then

setFinishPrompt(aJ)

end

end

end

end

end

local function setupFastFinishForPlayer(aG)

if aG~=r then

aG.CharacterAdded:Connect(

function(aH)

aH.DescendantAdded:Connect(

function(aI)

if

ad and aI.Name=="FinishPrompt"and aI:IsA"ProximityPrompt"and

aI.Parent and

aI.Parent.Name=="HumanoidRootPart"

then

setFinishPrompt(aI)

end

end

)

local aI=aH:WaitForChild("HumanoidRootPart",5)

if aI and ad then

local aJ=aI:FindFirstChild"FinishPrompt"

if aJ then

setFinishPrompt(aJ)

end

end

end

)

if aG.Character then

local aH=aG.Character

aH.DescendantAdded:Connect(

function(aI)

if

ad and aI.Name=="FinishPrompt"and aI:IsA"ProximityPrompt"and

aI.Parent and

aI.Parent.Name=="HumanoidRootPart"

then

setFinishPrompt(aI)

end

end

)

local aI=aH:FindFirstChild"HumanoidRootPart"

if aI and ad then

local aJ=aI:FindFirstChild"FinishPrompt"

if aJ then

setFinishPrompt(aJ)

end

end

end

end

end





































































































































local function TrySkipCrate()

local aG,aH=

pcall(

function()

return require(c.Modules.Game.CrateSystem.Crate)

end

)



if not(aG and aH)then

return

end



task.spawn(

function()

local aI=aH.spinning

if not aI then

return

end





local aJ=0

while not aI.get()do

if aJ>3 then

break

end

task.wait(0.05)

aJ=aJ+0.05

end



if aI.get()then

pcall(

function()

aH.skip_spin()

end

)

end

end

)

end



local function SetupAutoSkip()

local aG=c:WaitForChild("Remotes",5)

if not aG then

return

end



local aH=aG:WaitForChild("Send",5)

if not(aH and aH:IsA"RemoteEvent")then

return

end



aH.OnClientEvent:Connect(

function(...)

if aj then

TrySkipCrate()

end

end

)

end



local function createESP(aG)

if L[aG]then

return

end





local aH=Drawing.new"Text"

aH.Size=16

aH.Center=true

aH.Outline=true

aH.Color=isPlayerExcluded(aG.Name)and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,255,255)

aH.Font=4





local aI=Drawing.new"Text"

aI.Size=14

aI.Center=true

aI.Outline=true

aI.Color=Color3.fromRGB(255,255,255)

aI.Font=4





local aJ=Drawing.new"Square"

aJ.Filled=false

aJ.Thickness=1

aJ.Color=Color3.fromRGB(0,0,0)

aJ.Transparency=0.9

aJ.Visible=false





local aK=Drawing.new"Square"

aK.Filled=true

aK.Transparency=0.9

aK.Visible=false



local aL={aH,aI,aJ,aK}



local aM=

b.RenderStepped:Connect(

function()

if not aG or not aG.Character or not aG.Character:FindFirstChild"HumanoidRootPart"then

for aM,aN in pairs(aL)do

aN.Visible=false

end

return

end



local aM=aG.Character.HumanoidRootPart

local aN=aG.Character:FindFirstChild"Humanoid"

local aO=0

if r.Character and r.Character:FindFirstChild"HumanoidRootPart"then

aO=(aM.Position-r.Character.HumanoidRootPart.Position).Magnitude

end



local aP,aQ=y:WorldToViewportPoint(aM.Position)

if not aQ or aP.Z<=0 then

for aR,aS in pairs(aL)do

aS.Visible=false

end

return

end



local aR=aP.X

local aS=aP.Y-15





if O and aN and aN.Health>0 then

local aT=aN.Health/(aN.MaxHealth>0 and aN.MaxHealth or 1)

local aU=4

local aV=60

local aW=aR-aV/2



aJ.Position=Vector2.new(aW,aS-aU-2)

aJ.Size=Vector2.new(aV,aU)

aJ.Visible=true



aK.Position=Vector2.new(aW,aS-aU-2)

aK.Size=Vector2.new(aV*aT,aU)

aK.Color=Color3.fromHSV(aT*0.333,0.8,0.9)

aK.Visible=true



aS=aS-aU-6

else

aJ.Visible=false

aK.Visible=false

end







if M then

local aT,aU=14,42

local aV=math.clamp(aO/50,0,1)

local aW=aU-(aU-aT)*aV



aH.Text=aG.Name

aH.Size=math.floor(aW)

aH.Color=

isPlayerExcluded(aG.Name)and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,255,255)

aH.Outline=true

aH.Position=Vector2.new(aR,aS-16)

aH.Visible=true

else

aH.Visible=false

end



aI.Text=N and string.format("%.0f studs",aO)or""

aI.Position=Vector2.new(aR,aP.Y+20)

aI.Visible=N

end

)



L[aG]={conn=aM,drawings=aL}

end



local function loadESP()

for aG,aH in pairs(a:GetPlayers())do

if aH~=r and not L[aH]then

createESP(aH)

end

end



a.PlayerAdded:Connect(

function(aG)

if aG~=r then

aG.CharacterAdded:Connect(

function()

task.wait(0.1)

if not L[aG]then

createESP(aG)

end

end

)

if aG.Character and not L[aG]then

task.wait(0.1)

createESP(aG)

end

end

end

)



a.PlayerRemoving:Connect(

function(aG)

if L[aG]then

for aH,aI in pairs(L[aG].drawings)do

if aI and aI.Destroy then

pcall(

function()

aI:Destroy()

end

)

elseif typeof(aI)=="table"and aI.Visible~=nil then

aI.Visible=false

end

end

if L[aG].conn then

pcall(

function()

L[aG].conn:Disconnect()

end

)

end

end

end

)

end



if not z then

J=Drawing.new"Circle"

J.Color=Color3.fromRGB(255,255,255)

J.Thickness=1.4

J.NumSides=64

J.Filled=false

J.Transparency=3

J.Radius=H

J.Visible=false

else

local aG=Instance.new"ScreenGui"

aG.Name="MobileFOV"

aG.Parent=r:WaitForChild"PlayerGui"

J=Instance.new"Frame"

J.Size=UDim2.fromOffset(H*2,H*2)

J.AnchorPoint=Vector2.new(0.5,0.5)

J.Position=UDim2.fromScale(0.5,0.5)

J.BackgroundTransparency=1

local aH=Instance.new"UICorner"

aH.CornerRadius=UDim.new(1,0)

aH.Parent=J

local aI=Instance.new"UIStroke"

aI.Color=Color3.fromRGB(255,255,255)

aI.Thickness=2

aI.Transparency=0.2

aI.Parent=J

J.Parent=aG

end



local aG=6

local aH=0.80

local aI=150

local aJ=1



local aK={}

local aL=Vector3.new()



b.Heartbeat:Connect(

function()

for aM,aN in ipairs(a:GetPlayers())do

if aN~=r and aN.Character then

local aO=aN.Character

local aP=aO:FindFirstChild"HumanoidRootPart"

local aQ=aO:FindFirstChild"Humanoid"

if aP and aQ and aQ.Health>0 then

aK[aN]=aK[aN]or{}

table.insert(aK[aN],{time=os.clock(),pos=aP.Position})

if#aK[aN]>aG then

table.remove(aK[aN],1)

end

else

aK[aN]=nil

end

end

end

end

)



a.PlayerRemoving:Connect(

function(aM)

aK[aM]=nil

end

)



local function calculateVelocity(aM)

local aN=aK[aM]

if not aN or#aN<2 then

return Vector3.new()

end



local aO=Vector3.new()

local aP=0

for aQ=2,#aN do

local aR=aN[aQ].time-aN[aQ-1].time

if aR>0 then

aO=aO+(aN[aQ].pos-aN[aQ-1].pos)/aR

aP=aP+1

end

end

if aP==0 then

return Vector3.new()

end



local aQ=aO/aP

if aO.Magnitude < 10 then

return aO

end

if aQ.Y>aI then

return Vector3.new(aQ.X*1.11,math.clamp(aQ.Y*0.97,0,360),aQ.Z*1.11)

end

return aQ

end


local function predictPosition(aM,aN)

if not aM then

return Vector3.zero

end



local aO=aM.Parent

local aP=aO and a:GetPlayerFromCharacter(aO)

if not aP then

return aM.Position

end



local aQ=calculateVelocity(aP)or Vector3.zero

local aR=(getPing and getPing())or 0.1

if aR<0 then

aR=0.1

end



return aM.Position+(aQ*aR*aH)

end













































































local function isShotgun()

if not s then return false end

for aM,aN in ipairs(s:GetChildren())do

if aN:IsA"Tool"then

local aO=aN:GetAttribute"AmmoType"

if aO=="shotgun"or aO=="shootgun"then

return true

end

end

end

return false

end



local aM

if E and E.FireServer then local

aN=pcall(function()

aM=hookfunction(E.FireServer,function(aN,...)

if aN~=E then

return aM(aN,...)

end



local aO={...}



if F and aO[2]=="shoot_gun"and I then

local aP=I.Character and I.Character:FindFirstChild"Head"

local aQ=I.Character and I.Character:FindFirstChild"HumanoidRootPart"

local aR=I.Character and I.Character:FindFirstChild"Humanoid"



if aP and aQ and aR then

local aS=predictPosition(aP,aQ)

local aT=r.Character and r.Character:FindFirstChild"Head"

local aU=aT and aT.Position or nil



if isShotgun()then

aO[4]=CFrame.new(aU,aS)



local aV={}

for aW=1,8 do

local aX=Vector3.new(

math.random(-2,2)*0.03,

math.random(-2,2)*0.03,

math.random(-2,2)*0.03

)

table.insert(aV,{

[1]={

Instance=aP,

Normal=Vector3.new(0,1,0),

Position=aS+aX

}

})

end



aO[5]=aV



else

local aV=isBehindWall(aU,aS)



if aV then

aO[4]=CFrame.new(math.huge,math.huge,math.huge)

else

aO[4]=CFrame.new(aU,aS)

end



aO[5]={

[1]={

[1]={

Instance=aP,

Normal=Vector3.new(0,1,0),

Position=aS

}

}

}

end



local aV,aW=

pcall(

function()

local aV=Instance.new"Part"

aV.Anchored=true

aV.CanCollide=false

aV.Size=

Vector3.new(

0.08,

0.08,

(aS-r.Character.Head.Position).Magnitude

)

aV.CFrame=

CFrame.new(r.Character.Head.Position,aS)*

CFrame.new(0,0,-aV.Size.Z/2)

aV.Material=Enum.Material.Neon

aV.Transparency=0.35

aV.Color=Color3.fromRGB(255,0,0)

aV.Parent=workspace

f:AddItem(aV,4)

return aV

end

)



if aR then

local aX=aR.Health

spawn(

function()

wait(0.1)

if aR and aR.Health<aX then

if aV and aW then

aW.Color=Color3.fromRGB(0,255,0)

end

for aY,aZ in ipairs(I.Character:GetDescendants())do

if aZ:IsA"BasePart"then

local a_=Instance.new"Part"

a_.Size=aZ.Size+Vector3.new(0.05,0.05,0.05)

a_.CFrame=aZ.CFrame

a_.Anchored=true

a_.CanCollide=false

a_.Material=Enum.Material.Neon

a_.Color=Color3.fromRGB(255,0,0)

a_.Transparency=0.5

a_.Parent=g

local a0=TweenInfo.new(1.5,Enum.EasingStyle.Linear)

e:Create(a_,a0,{Transparency=1}):Play()

f:AddItem(a_,2)

end

end

if aP then

local aY=Instance.new"Part"

aY.Size=Vector3.new(0.2,0.2,0.2)

aY.Shape=Enum.PartType.Ball

aY.Material=Enum.Material.Neon

aY.Color=Color3.fromRGB(255,0,0)

aY.CFrame=CFrame.new(aP.Position)

aY.Anchored=false

aY.CanCollide=false

aY.Parent=g

local aZ=Instance.new"BodyVelocity"

aZ.Velocity=

Vector3.new(

math.random(-5,5),

math.random(5,10),

math.random(-5,5)

)

aZ.P=5000

aZ.MaxForce=Vector3.new(4000,4000,4000)

aZ.Parent=aY

f:AddItem(aY,1)

end

else

if aV and aW then

aW.Color=Color3.fromRGB(255,0,0)

end

end

end

)

end

end

end



return aM(aN,unpack(aO))

end

)

end

)



if not aN then

end

end



b.RenderStepped:Connect(

function()

pcall(

function()

if G then

I=getClosestTarget()

end

I=(F or G)and getClosestTarget()or nil





local aN=getClosestTarget()





if J then

J.Visible=F

if F then

if z then

J.Position=UDim2.fromScale(0.5,0.5)

J.Size=UDim2.fromOffset(H*2,H*2)

else

J.Position=Vector2.new(y.ViewportSize.X/2,y.ViewportSize.Y/2)

J.Radius=H

end

end

end



if aN and aN.Character then

local aO=aN.Character

local aP=aO:FindFirstChild"Humanoid"

local aQ=

(SelectedAimPart=="HumanoidRootPart")and aO:FindFirstChild"HumanoidRootPart"or

aO:FindFirstChild"Head"



if aP and aP.Health>0 and aQ then

local aR=Vector2.new(y.ViewportSize.X/2,y.ViewportSize.Y/2)





local aS=aQ.Position

aL=aL:Lerp(aS,aJ)

local aT=aL



local aU,aV=y:WorldToViewportPoint(aT)

if aV then



K.Visible=true

K.From=aR

K.To=Vector2.new(aU.X,aU.Y)

K.Color=Color3.fromRGB(255,50,50)

K.Thickness=1.3



if not TracerESP then

TracerESP={}

for aW=1,4 do

TracerESP[aW]=Drawing.new"Line"

TracerESP[aW].Color=Color3.fromRGB(255,255,255)

TracerESP[aW].Thickness=1.2

TracerESP[aW].Visible=true

end

end



local aW=y:WorldToViewportPoint(aQ.Position+Vector3.new(0,0.5,0))

local aX=

y:WorldToViewportPoint(aQ.Position-Vector3.new(0,0.5,0))



local aY=Vector2.new(aU.X,aU.Y)

local aZ=(aW-aX).Magnitude/2

local a_=aZ



local a0=8

local a1=25

a_=math.clamp(a_,a0,a1)

aZ=math.clamp(aZ,a0,a1)



local a2=Vector2.new(aY.X,aY.Y-aZ)

local a3=Vector2.new(aY.X,aY.Y+aZ)

local a4=Vector2.new(aY.X-a_,aY.Y)

local a5=Vector2.new(aY.X+a_,aY.Y)





TracerESP[1].From,TracerESP[1].To=a2,a5

TracerESP[2].From,TracerESP[2].To=a5,a3

TracerESP[3].From,TracerESP[3].To=a3,a4

TracerESP[4].From,TracerESP[4].To=a4,a2



for a6=1,4 do

TracerESP[a6].Visible=true

end

else

K.Visible=false

if TracerESP then

for aW=1,4 do

TracerESP[aW].Visible=false

end

end

end

else

K.Visible=false

if TracerESP then

for aR=1,4 do

TracerESP[aR].Visible=false

end

end

end

else

K.Visible=false

if TracerESP then

for aO=1,4 do

TracerESP[aO].Visible=false

end

end

aL=Vector3.new()

end





if S and T and u then

local aO=u.Velocity

u.Velocity=Vector3.new(aO.X,U,aO.Z)

end

if V and X and u then

local aO=u.Position

if math.abs(aO.Y-X)>0.1 then

u.CFrame=CFrame.new(aO.X,X,aO.Z)

end

end

end

)

end

)



r.CharacterAdded:Connect(

function(aN)

s=aN

end

)

b.Heartbeat:Connect(

function()

if ai().Sky and r.Character and r.Character:FindFirstChild"HumanoidRootPart"then

local aN=r.Character.HumanoidRootPart

local aO=aN.Velocity

local aP=math.rad(tick()*1500%360)

local aQ=math.cos(aP)*ai().SkyAmount

local aR=math.sin(aP)*ai().SkyAmount



local aS=math.random(280,480)



aN.Velocity=Vector3.new(aQ,aS,aR)

b.RenderStepped:Wait()

aN.Velocity=aO

end

end

)



b.Heartbeat:Connect(

function()

if not enabled then

return

end

if isDowned()then

local aN=getHRP()

if aN then

    if not ah then

teleportUnderground()

end

aN.CFrame = ah

end

else

            if ah then
                local hum = o.get_hum() 
                if hum then
                    hum.Health = 0
                end
                ah = nil
            end
            ag = false
        end
    end

)

b.Heartbeat:Connect(

function()

if not r.Character or not r.Character:FindFirstChild"HumanoidRootPart"then

s=r.Character or r.CharacterAdded:Wait()

u=s:WaitForChild"HumanoidRootPart"

end

pcall(CheckAndPickup)

end

)




h:BindAction(
    "FlyUp",
    function(aN,aO,aP)
        if not S then return Enum.ContextActionResult.Pass end
        
        if aP.UserInputType == Enum.UserInputType.Keyboard and aP.KeyCode == Enum.KeyCode.Space then
            if aO == Enum.UserInputState.Begin then
                T = true
                t.Jump = true
            elseif aO == Enum.UserInputState.End then
                T = false
            end
            return Enum.ContextActionResult.Sink
        end

        return Enum.ContextActionResult.Pass
    end,
    false,
    Enum.KeyCode.Space
) 

b.RenderStepped:Connect(

function(aN)

if S and T then

u.Velocity=

Vector3.new(u.Velocity.X,U,u.Velocity.Z)

end

end

)

r.CharacterAdded:Connect(function(aN)
    local aO = aN:WaitForChild("Humanoid")
    local aP = aN:WaitForChild("HumanoidRootPart") -- เพิ่มบรรทัดนี้เพื่อดึง RootPart มาใช้

    if aa then
        aa:Disconnect()
    end

    aa = aO:GetPropertyChangedSignal("Jump"):Connect(function()

        if S and aO.Jump then

            aP:ApplyImpulse(Vector3.new(0, aP.AssemblyMass * JumpHeight, 0))
        end
    end)
end)



r.CharacterAdded:Connect(setupCharacter)

if r.Character then

setupCharacter(r.Character)

end

d.InputBegan:Connect(

function(aN,aO)

if aO then

return

end

if aN.KeyCode==Enum.KeyCode.G and A and B then

if B.Toggle then

B:Toggle()

elseif B.SetVisible then

B:SetVisible(not B.Visible)

end

end

end

)

d.InputBegan:Connect(

function(aN,aO)

if aO then

return

end

if aN.KeyCode==Enum.KeyCode.Z and W then

toggleTeleport()

end

end

)

r.CharacterAdded:Connect(

function(aN)

s=aN

u=aN:WaitForChild"HumanoidRootPart"

X=nil

V=false

lockYPosition()

end

)

lockYPosition()

r.CharacterAdded:Connect(

function()

task.wait(1)

aE=false

task.wait(0.1)

StartAutoAttack()

end

)

StartAutoAttack()

for aN,aO in ipairs{"gun","melee","throwable","consumable","farming","misc","rod","fish"}do

registerItems(c:WaitForChild"Items"[aO])

end

a.PlayerAdded:Connect(

function(aN)

aN.CharacterAdded:Connect(

function()

if aw then

wait(0.2)

createBillboardForPlayer(aN)

end

end

)

end

)

a.PlayerRemoving:Connect(

function(aN)

if av[aN]then

av[aN]:Destroy()

av[aN]=nil

end

end

)

for aN,aO in ipairs(a:GetPlayers())do

setupFastFinishForPlayer(aO)

end

a.PlayerAdded:Connect(setupFastFinishForPlayer)

task.spawn(

function()

while true do

task.wait(af)

if ad then

for aN,aO in ipairs(findFinishPrompts())do

task.spawn(

function()

tryHoldPrompt(aO,ae)

end

)

end

end

end

end

)

SetupAutoSkip()

c.ChildAdded:Connect(

function(aN)

if aN.Name=="Remotes"then

SetupAutoSkip()

end

end

)

a.PlayerAdded:Connect(

function(aN)

aN.CharacterAdded:Connect(

function(aO)

if highlightEnabled then

highlights[aN]=createHighlight(aO)

end

if L[aN]and L[aN].drawings then

local aP=L[aN].drawings[1]

aP.Color=

isPlayerExcluded(aN.Name)and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,255,255)

end

end

)

end

)

a.PlayerRemoving:Connect(

function(aN)

if L[aN]then

for aO,aP in pairs(L[aN].drawings)do

if aP and aP.Destroy then

pcall(

function()

aP:Destroy()

end

)

elseif typeof(aP)=="table"and aP.Visible~=nil then

aP.Visible=false

end

end

if L[aN].conn then

pcall(

function()

L[aN].conn:Disconnect()

end

)

end

L[aN]=nil

end

end

)

task.spawn(

function()

while task.wait(0.01)do

if highlightEnabled then

updateHighlights()

end

end

end

)

loadESP()



local aN=B:Tab{Title="เอ็มบอท",Icon="crosshair"}

aN:Section{Title="ปืน"}

local aO=

aN:Toggle

{

Title="Silent Aim",

Default=false,

Callback=function(aO)

F=aO

I=nil



end

}



D:Register("SilentAim",aO)

local aP=

aN:Toggle

{

Title="Line Lock",

Default=false,

Callback=function(aP)

G=aP

I=nil

end

}



D:Register("SilentAimAttach",aP)



local aQ=

aN:Slider

{

Title="FOV: ",

Step=1,

Value={

Min=20,

Max=800,

Default=H

},

Callback=function(aQ)

H=tonumber(aQ)or 120

end

}



D:Register("FOVRadius",aQ)




local aR=

aN:Input

{

Title="Safe Friend",

Desc="",

Value="",

InputIcon="shield-check",

Type="Input",

Placeholder="",

Callback=function(aR)

P={}

for aS in string.gmatch(aR,"%S+")do

table.insert(P,aS)

end

for aS,aT in pairs(a:GetPlayers())do

if L[aT]and L[aT].drawings then

local aU=L[aT].drawings[1]

aU.Color=

isPlayerExcluded(aT.Name)and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,255,255)

end

end

end

}



D:Register("FriendsList",aR)



pcall(

function()

aN:Divider()

end

)



local aS=B:Tab{Title="แต่งอาวุธ",Icon="layers"}

aS:Section{Title="ม็อด"}



local aT=c:WaitForChild"Items":WaitForChild"gun"



ai().FireRateValue=1000

ai().AccuracyValue=1

ai().RecoilValue=0

ai().Durability=999999999

ai().Auto=true

ai().automatic=true

ai().AutoValue=true

ai().GunModsAutoApply=false



local function isGunTool(aU)

if not aU or not aU:IsA"Tool"then

return false

end

return aT:FindFirstChild(aU.Name)~=nil or aU.Name:match"Gun"or aU:FindFirstChild"Handle"

end



local function forceSetAttribute(aU,aV,aW)

if aU and aU.SetAttribute then

pcall(

function()

aU:SetAttribute(aV,aW)

end

)

end

end



local function debugPrintAttributes(aU)

local aV=aU:GetAttributes()

local aW={}

for aX,aY in pairs(aV)do

table.insert(aW,aX)

end

table.sort(aW)

if#aW>=11 then

end

end



local function applyGodGun(aU)

if not aU or not isGunTool(aU)then

return

end



pcall(

function()



aU:SetAttribute("fire_rate",ai().FireRateValue)

aU:SetAttribute("accuracy",ai().AccuracyValue)

aU:SetAttribute("Recoil",ai().RecoilValue)

aU:SetAttribute("Durability",ai().Durability)

aU:SetAttribute("automatic",ai().AutoValue)

end

)



task.spawn(

function()

for aV=1,20 do

local aW=aU:GetAttributes()

local aX={}

for aY in pairs(aW)do

table.insert(aX,aY)

end

table.sort(aX)



if#aX>=11 then

local aY=aX[11]

for aZ=1,5 do

forceSetAttribute(aU,aY,true)

task.wait(0.01)

end



end

task.wait(0.1)

end

end

)





task.wait(0.5)

debugPrintAttributes(aU)

end



b.Heartbeat:Connect(

function()

if not ai().GunModsAutoApply then

return

end



local aU=r.Character

if not aU then

return

end



for aV,aW in ipairs(aU:GetChildren())do

if aW:IsA"Tool"and isGunTool(aW)then

pcall(applyGodGun,aW)

end

end

end

)





r.CharacterAdded:Connect(

function(aU)

task.wait(1)

repeat

task.wait(0.1)

for aV,aW in ipairs(aU:GetChildren())do

if aW:IsA"Tool"and isGunTool(aW)then

task.spawn(applyGodGun,aW)

end

end

until not ai().GunModsAutoApply

end

)



r.Character.ChildAdded:Connect(

function(aU)

if aU:IsA"Tool"and ai().GunModsAutoApply then

task.wait(0.2)

applyGodGun(aU)

end

end

)



aS:Slider

{

Title="Fire Rate",

Step=10,

Value={Min=100,Max=5000,Default=1000},

Callback=function(aU)

ai().FireRateValue=aU

end

}



aS:Slider

{

Title="Accuracy",

Step=0.01,

Value={Min=0,Max=5,Default=1},

Callback=function(aU)

ai().AccuracyValue=aU

end

}



aS:Slider

{

Title="Recoil",

Step=0.1,

Value={Min=0,Max=10,Default=0},

Callback=function(aU)

ai().RecoilValue=aU

end

}



aS:Slider

{

Title="Reload Time",

Step=0.1,

Value={Min=0.1,Max=10,Default=0.1},

Callback=function(aU)

ai().ReloadValue=aU

end

}





aS:Toggle

{

Title="Automatic",

Icon="check",

Type="Checkbox",

Value=false,

Callback=function(aU)

ai().automatic=aU

ai().GunModsAutoApply=aU

if aU and A then

A:Notify

{

Title="✅ Auto Modify",

Duration=2

}



end

end

}





aS:Section{Title="COMBAT"}



local function modifyFists(aU,aV)

if aU then

local aW=aU:GetAttributes()

local aX={}

for aY,aZ in pairs(aW)do

table.insert(aX,aY)

end

table.sort(aX)

if#aX>=7 then

local aY=aX[6]

local aZ=aX[7]

if aV then

if az[aY]==nil then

az[aY]=aU:GetAttribute(aY)

end

if az[aZ]==nil then

az[aZ]=aU:GetAttribute(aZ)

end

aU:SetAttribute(aY,360)

aU:SetAttribute(aZ,20)

else

if az[aY]then

aU:SetAttribute(aY,az[aY])

end

if az[aZ]then

aU:SetAttribute(aZ,az[aZ])

end

end

end

end

end

local aU={}

for aV,aW in ipairs(q:GetChildren())do

table.insert(aU,aW.Name)

end



local function isMeleeTool(aV)

if not aV:IsA"Tool"then

return false

end

if aV.Name=="Fists"then

return true

end

for aW,aX in ipairs(aU)do

if aV.Name==aX then

return true

end

end

return false

end



local function checkAndModifyFists()

local aV=r.Character

local aW=r:FindFirstChild"Backpack"

if not aV or not aW then

return

end

local aX={}

for aY,aZ in ipairs(aV:GetChildren())do

if isMeleeTool(aZ)then

table.insert(aX,aZ)

end

end

for aY,aZ in ipairs(aW:GetChildren())do

if isMeleeTool(aZ)then

table.insert(aX,aZ)

end

end

for aY,aZ in ipairs(aX)do

modifyFists(aZ,ay)

end

end





b.Heartbeat:Connect(

function()

if ay then

checkAndModifyFists()

end

end

)





r.CharacterAdded:Connect(

function()

task.wait(1)

if ay then

checkAndModifyFists()

end

end

)



D:Register(

"Fists Modifier",

aS:Toggle

{

Title="Melee Aura",

Desc="WideFists",

Default=false,

Callback=function(aV)

ay=aV

checkAndModifyFists()

end

}



)



local aV=

aS:Toggle

{

Title="Auto Attack",

Default=false,

Callback=function(aV)

ab=aV

end

}





D:Register("AutoAttack_Enabled",aV)



local aW=B:Tab{Title="มอง",Icon="eye"}

aW:Section{Title="ดู"}

local aX=

aW:Toggle

{

Title="Inventory Viewer",

Default=false,

Callback=function(aX)

aw=aX

if aX then

for aY,aZ in ipairs(a:GetPlayers())do

if aZ~=r and aZ.Character then

createBillboardForPlayer(aZ)

end

end

ax=

b.Heartbeat:Connect(

function()

for aY,aZ in ipairs(a:GetPlayers())do

if aZ~=r and aZ.Character then

createBillboardForPlayer(aZ)

end

end

end

)

if A then

A:Notify

{

Title="✅ ESP Items Enabled",

Duration=3

}



end

else

if ax then

ax:Disconnect()

ax=nil

end

for aY,aZ in pairs(av)do

aZ:Destroy()

end

av={}

if A then

A:Notify

{

Title="❌ ESP Items Disabled",

Duration=3

}



end

end

end

}



D:Register("ItemsESP",aX)

local aY=

aW:Toggle

{

Title="Name",

Default=false,

Callback=function(aY)

M=aY

end

}



D:Register("NameESP",aY)

local aZ=

aW:Toggle

{

Title="Health",

Default=false,

Callback=function(aZ)

O=aZ

end

}



D:Register("HealthESP",aZ)

local a_=

aW:Toggle

{

Title="Distance",

Default=false,

Callback=function(a_)

N=a_

end

}



D:Register("DistanceESP",a_)





local a0=

aW:Toggle

{

Title="Highlight",

Default=false,

Callback=function(a0)

highlightEnabled=a0



for a1,a2 in pairs(game.Players:GetPlayers())do

updateHighlight(a2)

end

end

}



D:Register("HighlightESP",a0)



function updateHighlight(a1)

if a1==game.Players.LocalPlayer then

return

end

if not a1.Character then

return

end

local a2=a1.Character:FindFirstChild"HumanoidRootPart"

if not a2 then

return

end





if aB[a1]then

aB[a1]:Destroy()

aB[a1]=nil

end



if highlightEnabled then

local a3=Instance.new"Highlight"

a3.Name="PlayerHighlight"

a3.Adornee=a1.Character

a3.FillColor=Color3.fromRGB(136, 0, 153)

a3.OutlineColor=Color3.fromRGB(136, 0, 153)

a3.Parent=workspace

aB[a1]=a3

end

end





game.Players.PlayerAdded:Connect(

function(a1)

a1.CharacterAdded:Connect(

function()

task.wait(0.1)

updateHighlight(a1)

end

)

end

)



game.Players.PlayerRemoving:Connect(

function(a1)

if aB[a1]then

aB[a1]:Destroy()

aB[a1]=nil

end

end

)





for a1,a2 in pairs(game.Players:GetPlayers())do

if a2~=game.Players.LocalPlayer then

a2.CharacterAdded:Connect(

function()

task.wait(0.1)

updateHighlight(a2)

end

)

updateHighlight(a2)

end

end



local a1=B:Tab{Title="ตัวละคร",Icon="user"}

a1:Section{Title="ตัวละคร"}

local a2=

a1:Toggle

{

Title="Walk Speed",

Default=false,

Callback=function(a2)

Q=a2

end

}



D:Register("WalkSpeed",a2)

local a3=

a1:Slider

{

Title="Speed Multiplier",

Step=0.5,

Value={

Min=1,

Max=5,

Default=2

},

Callback=function(a3)

R=a3*0.05

end

}



D:Register("SpeedMultiplier",a3)

local a4=

a1:Toggle

{

Title="Jump Power",

Default=false,

Callback=function(a4)

S=a4

if not S then

flying=false

end

end

}



D:Register("JumpPower",a4)



local a5={}

function a5.send(...)

local a6={...}

aC.event=aC.event+1

pcall(

function()

i.Send:FireServer(aC.event,unpack(a6))

end

)

end

local a65=

a1:Slider

{

Title = "Jump Height",
    Step = 5,
    Value = {
        Min = 1,
        Max = 50,
        Default = 10
    },
    Callback = function(v)
        JumpHeight = v -- ตัวแปรนี้จะถูกเรียกใช้ในส่วนที่ 2
    end
}

local a6=

a1:Toggle

{

Title="Infinite Stamina",

Default=false,

Callback=function(a6)

as=a6

if as then



local a7,a8=

pcall(

function()

return require(c.Modules.Game.Sprint)

end

)

if a7 and a8 then

local a9=a8.consume_stamina

local ba=getupvalue(a9,2).sprint_bar

if ba then

local bb=ba.update

ba.update=function(...)

return bb(

function()

return 1

end

)

end



ai().OriginalSprintUpdate=bb



ai().AutoSprintLoop=

task.spawn(

function()

while as do

pcall(

function()

a5.send("set_sprinting_1",true)

task.wait(0.5)

a5.send("set_sprinting_1",false)

end

)

task.wait(0.1)

end



pcall(

function()

a5.send("set_sprinting_1",false)

end

)

end

)

if A then

A:Notify

{

Title="✅ INF STAMINA",

Duration=3

}



end

else

as=false

AutoSprintToggle:Set(false)

end

else

as=false

AutoSprintToggle:Set(false)

end

else



if ai().AutoSprintLoop then

task.cancel(ai().AutoSprintLoop)

ai().AutoSprintLoop=nil

end



pcall(

function()

a5.send("set_sprinting_1",false)

end

)



local a7,a8=

pcall(

function()

return require(c.Modules.Game.Sprint)

end

)

if a7 and a8 then

local a9=a8.consume_stamina

local ba=getupvalue(a9,2).sprint_bar

if ba and ai().OriginalSprintUpdate then

ba.update=ai().OriginalSprintUpdate

ai().OriginalSprintUpdate=nil

end

end

if A then

A:Notify

{

Title="❌ Auto Sprint Disabled",

Duration=3

}



end

end

end

}



D:Register("AutoSprint",a6)

local a7=

a1:Toggle

{

Title="Anti Lock",

Default=false,

Callback=function(a7)

ai().Sky=a7

if a7 then

ai().SkyAmount=1500

end

end

}



D:Register("AntiLock",a7)

local a8=

a1:Toggle

{

Title="Anti Kill",

Default=false,

Callback=function(a8)

enabled=a8

if a8 then

if A then

A:Notify

{

Title=" Anti Kill Enabled",

Duration=3

}



end

else

if A then

A:Notify

{

Title="❌ Anti Kill Disabled",

Duration=3

}



end

end

end

}



D:Register("AntiKill",a8)

pcall(

function()

if a1 and typeof(a1.Divider)=="function"then

a1:Divider()

end

end

)

pcall(

function()

if a1 and typeof(a1.Section)=="function"then

a1:Section{Title="Att:"}

end

end

)

local a9=

a1:Toggle

{

Title="Pickup items",

Default=false,

Callback=function(a9)

ak=a9

end

}



D:Register("PickupItems",a9)

local ba=

a1:Toggle

{

Title="Anti Ragdoll",

Default=false,

Callback=function(ba)

local bb=ba

if not bb then

return

end

pcall(

function()

local bc=game:GetService"ReplicatedStorage"

local bd=game:GetService"Players"local be=

bd.LocalPlayer

local function findCounter()

for bf,bg in ipairs(getgc and getgc(true)or{})do

if typeof(bg)=="table"and rawget(bg,"event")and rawget(bg,"func")then

return bg

end

end

end

local bf=findCounter()

if not bf then

return

end

local function sendRemoteAction(bg)

bf.event=(bf.event or 0)+1

local bh=bc:WaitForChild"Remotes":WaitForChild"Send"

bh:FireServer(bf.event,bg)

end

task.spawn(

function()

while bb do

sendRemoteAction"end_ragdoll_early"

task.wait(0.3)

if not bb then

break

end

sendRemoteAction"clear_ragdoll"

task.wait(0.3)

end

end

)

end

)

end

}



D:Register("AntiRagdoll",ba)

local bb=

a1:Toggle

{

Title="Hide Name",

Default=false,

Callback=function(bb)

pcall(

function()

local bc=a.LocalPlayer

local bd=bc.Character or bc.CharacterAdded:Wait()

local be=bd:WaitForChild"HumanoidRootPart"

local bf=be:FindFirstChild"CharacterBillboardGui"

if bf then

local bg=bf:FindFirstChild"PlayerName"

if bg and bg:IsA"TextLabel"then

bg.Visible=not bb

end

end

end

)

end

}


D:Register("HideName",bb)

local bc=

a1:Toggle

{

Title="Auto Respawn",

Default=false,

Callback=function(bc)

local bd=bc

if not bd then

return

end

pcall(

function()

local be=game:GetService"ReplicatedStorage"

local bf=game:GetService"Players"

local bg=bf.LocalPlayer

local function findCounter()

for bh,bi in ipairs(getgc and getgc(true)or{})do

if typeof(bi)=="table"and rawget(bi,"event")and rawget(bi,"func")then

return bi

end

end

end

local bh=findCounter()

if not bh then

return

end

local function sendRemoteAction(bi)

bh.event=(bh.event or 0)+1

local bj=be:WaitForChild"Remotes":WaitForChild"Send"

bj:FireServer(bh.event,bi)

end

task.spawn(

function()

while bd do

local bi=bg.Character

local bj=bi and bi:FindFirstChildOfClass"Humanoid"

if bj and bj.Health<=0 then

task.wait(6)

if bd then

sendRemoteAction"death_screen_request_respawn"

end

end

task.wait(0.5)

end

end

)

end

)

end

}



D:Register("AutoRespawn",bc)

local buu = a1:Toggle({
    Title = "Health Blood",
    Default = false,
    Callback = function(bb)
        
        _G.AutoHealEnabled = bb 
        
        
        if not _G.HealLoopStarted then
            _G.HealLoopStarted = true
            
            task.spawn(function()
                while true do
                    task.wait(1)
                    
                    
                    if _G.AutoHealEnabled then
                        local Players = game:GetService("Players")
                        local Plr = Players.LocalPlayer
                        local Ch = Plr.Character
                        
                        if Ch and Ch:FindFirstChildWhichIsA("Humanoid") and Ch.Humanoid.Health < 95 then
                            
                            local function GetHeal()
                                local SearchPlaces = {Plr.Backpack, Plr.Character, Plr:FindFirstChild("Inventory"), Plr:FindFirstChild("StarterGear")}
                                for _, Place in pairs(SearchPlaces) do
                                    if Place then
                                        for _, T in pairs(Place:GetChildren()) do
                                            if T:IsA("Tool") and (T:GetAttribute("HealthRestoreAmount") or T:GetAttribute("HealAmount") or T:GetAttribute("RestoreHealth")) then
                                                return T
                                            end
                                        end
                                    end
                                end
                                return nil
                            end

                            local T = GetHeal()
                            if T then
                                
                                local Old = Ch:FindFirstChildWhichIsA("Tool")
                                T.Parent = Ch
                                task.wait(0.01)
                                
                                if T:FindFirstChild("RemoteEvent") then T.RemoteEvent:FireServer()
                                elseif T:FindFirstChild("Use") then T:Use()
                                else T:Activate() end
                                
                                
                                local Hum = Ch:FindFirstChildWhichIsA("Humanoid")
                                local Anim = Hum and Hum:FindFirstChildWhichIsA("Animator")
                                if Anim then for _, Track in pairs(Anim:GetPlayingAnimationTracks()) do Track:Stop(0) end end
                                
                                task.wait(0.2)
                                if Old and Old.Parent == Ch then Old.Parent = Plr.Backpack end
                            end
                        end
                    end
                end
            end)
        end
    end
})


D:Register("Health Blood",buu)

a1:Divider()

a1:Section{Title="PC HOLD (Z)"}



local bd=

a1:Toggle

{

Title="Snap Under Map",

Default=false,

Callback=function(bd)

W=bd



if W then

ac=ac+1



if ac<2 then

return

end



Z=u and u.Position.Y or nil

V=true

performTeleport()

else

V=false

X=nil

Z=nil

end

end

}





D:Register("SnapUnderMap",bd)

local be=

a1:Slider

{

Title="Snap:",

Step=1,

Value={Min=1,Max=300,Default=10},

Callback=function(be)

Y=be

if V and u and Z then

local bf=

Vector3.new(u.Position.X,Z-Y,u.Position.Z)

u.CFrame=CFrame.new(bf)

X=bf.Y

end

end

}



D:Register("SnapHeight",be)

local bf=B:Tab{Title="ผู้เล่น",Icon="person-standing"}

bf:Section{Title="ผู้เล่น"}

local bg=Instance.new("Folder",g)

local bh=Instance.new("Part",bg)

Instance.new("Attachment",bh)

bh.Anchored=true

bh.CanCollide=false

bh.Transparency=1

local bi=

bf:Toggle

{

Title="Auto Finnish",

Default=false,

Callback=function(bi)

ad=bi

if bi then

applyToAll()

if A then

A:Notify{Title="✅ Auto Finish Enabled",Description="✅ Auto Enabled",Duration=3}

end

else

if A then

A:Notify{Title="❌ Auto Disabled",Description="❌ Auto Disabled",Duration=3}

end

end

end

}



D:Register("AutoFinnish",bi)

bf:Divider()



local bk=B:Tab{Title="การตั้งค่า",Icon="warehouse"}



local bl=game.PlaceId





bk:Input

{

Title="Server Hop by ID",

Value="",

InputIcon="send",

Type="Input",

Placeholder="id sever here!",

Callback=function(bm)

if not bm or bm==""then

return

end



local bn={}

for bo in string.gmatch(bm,"[%w%-]+")do

table.insert(bn,bo)

end



if#bn==0 then

return

end



for bo,bp in ipairs(bn)do

print("กำลังวาร์ปไปเซิร์ฟ:",bp)

task.wait(0.5)

pcall(

function()

game:GetService"TeleportService":TeleportToPlaceInstance(bl,bp,r)

end

)

end

end

}





bk:Button

{

Title="Server Rejoin",

Desc="Come back old sever",

Callback=function()

game:GetService"TeleportService":TeleportToPlaceInstance(

game.PlaceId,

game.JobId,

game.Players.LocalPlayer

)

end

}





game:GetService"HttpService"local bm=

game.PlaceId









































































































bk:Button

{

Title="Server Hop",

Desc="Hop to a new server (sometime don't work)",

Locked=false,

Callback=function()

local bn=104715542330896

local bo=game:GetService"HttpService"

local bp=game:GetService"TeleportService"



local bq,br=

pcall(

function()

return bo:JSONDecode(

game:HttpGet(

"https://games.roblox.com/v1/games/"..

bn.."/servers/Public?sortOrder=Desc&limit=100"

)

)

end

)



if not bq or not br or not br.data then

warn"ไม่สามารถดึงข้อมูลเซิร์ฟเวอร์ได้เลยพี่"

return

end



local bs={}

for bt,bu in ipairs(br.data)do

if bu.playing<bu.maxPlayers and bu.id~=game.JobId then

table.insert(bs,bu)

end

end



if#bs==0 then

warn"ไม่มีเซิร์ฟเวอร์ว่างเลยพี่ขณะนี้"

return

end



table.sort(

bs,

function(bt,bu)

return bt.playing>bu.playing

end

)



local bt=bs[1]



game.StarterGui:SetCore(

"SendNotification",

{

Title="Server Hop",

Text="กำลังย้ายไปเซิร์ฟเวอร์คนเยอะ...",

Duration=3

}

)



bp:TeleportToPlaceInstance(bn,bt.id,game.Players.LocalPlayer)

end

}





bk:Divider()



local bn=

bk:Button

{

Title="Claim All Quest",

Callback=function()

task.spawn(

function()

local bn,bo=

pcall(

function()

local bn=game:GetService"Players"

local bo=game:GetService"ReplicatedStorage"

local bp=bn.LocalPlayer



local function findCounter()

for bq,br in ipairs(getgc and getgc(true)or{})do

if typeof(br)=="table"and rawget(br,"event")and rawget(br,"func")then

return br

end

end

return nil

end

local bq=findCounter()

if not bq then

return

end



local br={}

function br.get(...)

local bs={...}

bq.func=(bq.func or 0)+1

local bt=bo:WaitForChild"Remotes":WaitForChild"Get"

return bt:InvokeServer(bq.func,table.unpack(bs))

end

local bs=

bp:WaitForChild"PlayerGui":WaitForChild"Quests":WaitForChild"QuestsHolder":WaitForChild

"QuestsScrollingFrame"



for bt,bu in ipairs(bs:GetChildren())do

if bu:IsA"Frame"or bu:IsA"TextButton"or bu:IsA"ImageButton"then

br.get("claim_quest",bu.Name)

task.wait(0.2)

end

end

end

)

if bn then

print"Claim All Quests Completed"

else

warn(bo)

end

end

)

end

}



D:Register("ClaimAllQuest",bn)



local bo=D.Save

local bp=D.Delete

local bq=D.Load



bk:Section{Title="Config Management"}



local br=

bk:Button

{

Title="Save Config",

Callback=function()

if bo then

bo(D)

end

end

}



D:Register("SaveConfig",br)



local bs=

bk:Button

{

Title="Delete Config",

Callback=function()

if bp then

bp(D)

end

end

}



D:Register("DeleteConfig",bs)



if bq then

bq(D)

end





local bt=j.tween



j.tween=function(bu,bv,bw)

if bu and bu:IsA"NumberValue"and bw and bw.Value~=nil then

bu.Value=bw.Value

return{

Cancel=function()

end

}

end

return bt(bu,bv,bw)

end



local bu,bv=

pcall(

function()

return k.get"SellPromptSellButton"

end

)

if bu and bv then

local bw=bv:FindFirstChild("HoldStroke",true)

if bw then

bw.Enabled=false

local bx=bw:FindFirstChildOfClass"UIGradient"

if bx then

bx.Enabled=false

end

end

for bx,by in pairs(bv:GetDescendants())do

if by:IsA"NumberValue"then

by.Value=1

end

end

end



task.wait(2)

print"Bypass"



local function lockTool(bw)

if bw and bw:IsA"Tool"then

pcall(

function()

bw:SetAttribute("Locked",true)

end

)

end

end



local function setupBackpack(bw)

if not bw then

return

end

for bx,by in ipairs(bw:GetChildren())do

lockTool(by)

end

bw.ChildAdded:Connect(lockTool)

end



local function init()

local bw=r:FindFirstChildOfClass"Backpack"

if bw then

setupBackpack(bw)

else

r.ChildAdded:Connect(

function(bx)

if bx:IsA"Backpack"then

setupBackpack(bx)

end

end

)

end

end



init()



r.CharacterAdded:Connect(

function()

task.wait(1)

init()

end

)



task.wait(1)



print"Bypass hotbar inf"

local function hookButton(bw)

if not bw then

return

end



if bw:FindFirstChild"UnlocksAtText"then

bw.UnlocksAtText.Visible=false

end

if bw:FindFirstChild"EmoteName"then

bw.EmoteName.Visible=true

end



n.on_click(

bw,

function()

local bx=o.get_hum()

if not bx or bx.Health<=0 then

return

end



if l.current_emote_playing.get()==bw then

l.current_emote_playing.set(nil)

else

l.current_emote_playing.set(bw)

end



task.wait(0.12)



l.enabled.set(false)

end

)



l.current_emote_playing.hook(

function(bx)

if bw:FindFirstChild"EmoteEquipped"then

bw.EmoteEquipped.Visible=(bx==bw)

end

end

)

end



local function hookAllEmotes()

for bw,bx in pairs(m)do

local by=n.get"EmoteTemplate".Parent:FindFirstChild(bx.name)

hookButton(by)

end

end



hookAllEmotes()



r.CharacterAdded:Connect(

function()

task.wait(1)

hookAllEmotes()

end

)



task.wait(2)



local bw

repeat

task.wait()

until workspace.CurrentCamera

bw=workspace.CurrentCamera



local function getRarityColor(bx)

if bx.Name=="Money"then

return Color3.fromRGB(0,255,0)

end

for by,bz in ipairs(p:GetChildren())do

if bz:IsA"Folder"then

local bA=bz:FindFirstChild(bx.Name)

if bA and bA:GetAttribute"RarityName"then

local bB=bA:GetAttribute"RarityName"

return at[bB]or Color3.fromRGB(255,255,255)

end

end

end

return Color3.fromRGB(255,255,255)

end





local function cleanupItemDrawings()

for bx,by in pairs(w)do

if not bx or not bx.Parent then

if by.circle then

pcall(

function()

by.circle:Remove()

end

)

end

if by.innerCircle then

pcall(

function()

by.innerCircle:Remove()

end

)

end

if by.name then

pcall(

function()

by.name:Remove()

end

)

end

if by.amount then

pcall(

function()

by.amount:Remove()

end

)

end

if by.highlight then

pcall(

function()

by.highlight:Destroy()

end

)

end

w[bx]=nil

end

end

end





b.RenderStepped:Connect(

function()

cleanupItemDrawings()

if not x then

return

end



local bx=v.Character and v.Character:FindFirstChild"HumanoidRootPart"

if not bx then

return

end





for by,bz in pairs(w)do

bz.circle.Visible=false

bz.innerCircle.Visible=false

bz.name.Visible=false

bz.amount.Visible=false

if bz.highlight then

bz.highlight.Enabled=false

end

end



local by={}

for bz,bA in ipairs(x:GetChildren())do

if bA:IsA"Model"and bA:FindFirstChild"PickUpZone"and not bA:GetAttribute"Locked"then

local bB,bC=

pcall(

function()

return bA.PickUpZone.Position

end

)

if bB and bC then

local bD=(bC-bx.Position).Magnitude

table.insert(by,{item=bA,dist=bD})

end

end

end

table.sort(

by,

function(bz,bA)

return bz.dist<bA.dist

end

)



for bz=1,math.min(20,#by)do

local bA=by[bz].item

local bB=w[bA]



if not bB then

bB={

circle=Drawing.new"Circle",

innerCircle=Drawing.new"Circle",

name=Drawing.new"Text",

amount=Drawing.new"Text"

}



bB.circle.Thickness=2

bB.circle.Transparency=0.7

bB.circle.Filled=false



bB.innerCircle.Thickness=2

bB.innerCircle.Transparency=1

bB.innerCircle.Filled=true





bB.name.Outline=true

bB.name.OutlineColor=Color3.fromRGB(0,0,0)

bB.name.Center=true

bB.name.Size=16

bB.name.Font=4





bB.amount.Outline=true

bB.amount.OutlineColor=Color3.fromRGB(0,0,0)

bB.amount.Center=true

bB.amount.Size=13

bB.amount.Color=Color3.fromRGB(200,200,200)



w[bA]=bB

end



if not bB.highlight or not bB.highlight.Parent then

local bC=Instance.new"Highlight"

bC.Name="ESP_Highlight"

bC.FillTransparency=0.5

bC.OutlineTransparency=0.1

bC.Adornee=bA

bC.Parent=bA

bB.highlight=bC

end



local bC,bD=bw:WorldToViewportPoint(bA.PickUpZone.Position)

if bD then

local bE=getRarityColor(bA)

local bF=math.clamp(aA/bC.Z,3,6)



if bB.highlight then

bB.highlight.FillColor=bE

bB.highlight.OutlineColor=bE

bB.highlight.Enabled=true

end



bB.circle.Position=Vector2.new(bC.X,bC.Y)

bB.circle.Radius=bF+5

bB.circle.Color=bE

bB.circle.Visible=true



bB.innerCircle.Position=Vector2.new(bC.X,bC.Y)

bB.innerCircle.Radius=bF

bB.innerCircle.Color=bE

bB.innerCircle.Visible=true



bB.name.Color=bE

bB.name.Position=Vector2.new(bC.X,bC.Y-bF-20)

bB.name.Text=bA.Name

bB.name.Visible=true



local bG=bA:GetAttribute"Amount"or 1

bB.amount.Position=Vector2.new(bC.X,bC.Y+bF+15)

bB.amount.Text=bG>1 and"["..tostring(bG).."]"or""

bB.amount.Visible=bG>1

else

bB.circle.Visible=false

bB.innerCircle.Visible=false

bB.name.Visible=false

bB.amount.Visible=false

if bB.highlight then

bB.highlight.Enabled=false

end

end

end

end

)



a.PlayerRemoving:Connect(

function(bx)

if bx==v then

for by,bz in pairs(w)do

pcall(

function()

bz.circle:Remove()

end

)

pcall(

function()

bz.innerCircle:Remove()

end

)

pcall(

function()

bz.name:Remove()

end

)

pcall(

function()

bz.amount:Remove()

end

)

pcall(

function()

if bz.highlight then

bz.highlight:Destroy()

end

end

)

end

w={}

end

end

)



local BuyTab = B:Tab({Title = "ซื้อ", Icon = "house"})



BuyTab:Section(

    {

        Title = "ซื้อ"

    }

)



local CrateController = require(game:GetService("ReplicatedStorage").Modules.Game.CrateSystem.Crate)



local EnabledSkip = false



local buu11= BuyTab:Toggle({

    Title = "Skip animation",

    Desc = "",

    Value = false,

    Callback = function(v)

        EnabledSkip = v



        if EnabledSkip then

            task.spawn(function()

                while EnabledSkip do

                    task.wait()



                    if CrateController.class and CrateController.class.objects then

                        for _, crate in pairs(CrateController.class.objects) do

                            pcall(function()

                                if crate.states and crate.states.open and crate.states.open.set then

                                    crate.states.open.set(true)

                                end

                                if CrateController.skipping and CrateController.skipping.set then

                                    CrateController.skipping.set(true)

                                end

                            end)

                        end

                    end



                    if CrateController.spinning and CrateController.skip_spin then

                        if not CrateController.spinning.get() then

                            pcall(function()

                                CrateController.skip_spin()

                            end)

                        end

                    end

                end

            end)

        else



            pcall(function()

                if CrateController.skipping and CrateController.skipping.set then

                    CrateController.skipping.set(false)

                end

            end)

        end

    end

})

D:Register("Skip animation",buu11)



local VehicleTab = B:Tab({Title = "รถ", Icon = "car"})



VehicleTab:Section(

    {

        Title = "รถ"

    }

)



VehicleTab:Button({

        Title = "Pull Car Owner",

        Desc = "",

        Callback = function()

            local Players = game:GetService("Players")

local Client = Players.LocalPlayer



local Character = Client.Character or Client.CharacterAdded:Wait()

local RootPart = Character:WaitForChild("HumanoidRootPart")



local Vehicles = workspace:WaitForChild("Vehicles")



for _, vehicle in pairs(Vehicles:GetChildren()) do

    if vehicle:IsA("Model") then

        local ownerId = vehicle:GetAttribute("OwnerUserId")

        

        if ownerId and ownerId == Client.UserId then

            local offset = CFrame.new(math.random(-5,5), 3, math.random(-15,-5))

            

            if vehicle.PrimaryPart then

                vehicle:SetPrimaryPartCFrame(RootPart.CFrame * offset)

            else

                local part = vehicle:FindFirstChildWhichIsA("BasePart")

                if part then

                    part.CFrame = RootPart.CFrame * offset

                end

            end

        end

    end

end

            B:Notify({

                Title = "Button",

                Desc = "Action performed successfully.",

                Time = 3

            })

        end

    })
