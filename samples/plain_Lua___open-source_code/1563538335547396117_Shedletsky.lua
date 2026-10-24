local plrs=game:GetService("Players")
local lp=plrs.LocalPlayer
local rs=game:GetService("RunService")
local db=game:GetService("Debris")
local tws=game:GetService("TweenService")
local gui=game:GetService("StarterGui")

local function notif(t)
	gui:SetCore("SendNotification",{Title=t[1],Text=t[2],Duration=t[3]})
end

local spec=workspace.Players:FindFirstChild("Spectating")
if spec and spec:FindFirstChild(lp.Name) then
	notif({"yeahh no","ur not default Shedletsky buuuuddy",5})
	return
end

local ab=lp:WaitForChild("PlayerGui"):WaitForChild("MainUI"):WaitForChild("AbilityContainer")
if not ab:FindFirstChild("Slash") then
	notif({"yeahh no","ur not default Shedletsky buuuuddy",5})
	return
end

local skin=lp:WaitForChild("PlayerData"):WaitForChild("Equipped"):WaitForChild("Skins"):FindFirstChild("Shedletsky")
if skin and skin.Value~="" then
	notif({"yeahh no","ur not default Shedletsky buuuuddy",5})
	return
end

notif({"script firedd yay","Made by Artbilli on Discord",5})

local buy=lp:WaitForChild("PlayerData"):WaitForChild("Purchased"):WaitForChild("Skins")
local temp=Instance.new("IntValue")
temp.Name="ArtistShedletsky"
temp.Value=0
temp.Parent=buy
delay(.1,function()if temp.Parent then temp:Destroy()end end)

local ch=lp.Character or lp.CharacterAdded:Wait()

local s=ch:FindFirstChildOfClass("Shirt")
if s then s:Destroy()end
s=Instance.new("Shirt")
s.ShirtTemplate="rbxassetid://118042344317053"
s.Parent=ch

local p=ch:FindFirstChildOfClass("Pants")
if p then p:Destroy()end
p=Instance.new("Pants")
p.PantsTemplate="rbxassetid://100561495134250"
p.Parent=ch

local head=ch:FindFirstChild("Head")
if not head then return end

local hatoff=Vector3.new(.47,.97,0)
local hatrot=Vector3.new(0,-90,0)
local hat=Instance.new("Accessory")
hat.Name="CustomHat"
hat.Parent=ch

local handle=Instance.new("Part")
handle.Name="Handle"
handle.Size=Vector3.new(1,1,1)
handle.CanCollide=false
handle.Anchored=false
handle.Parent=hat

local mesh=Instance.new("SpecialMesh")
mesh.MeshId="rbxassetid://102770853506860"
mesh.TextureId="rbxassetid://117341189541689"
mesh.Parent=handle

handle.CFrame=head.CFrame*CFrame.new(hatoff)*CFrame.Angles(math.rad(hatrot.X),math.rad(hatrot.Y),math.rad(hatrot.Z))

local weld=Instance.new("WeldConstraint")
weld.Part0=head
weld.Part1=handle
weld.Parent=handle

local torso=ch:FindFirstChild("Torso")or ch:FindFirstChild("UpperTorso")
if not torso then return end

local toff=Vector3.new(0,-.34,0)
local trot=Vector3.new(0,-90,0)

local tacc=Instance.new("Accessory")
tacc.Name="CustomTorso"
tacc.Parent=ch

local th=Instance.new("Part")
th.Name="Handle"
th.Size=Vector3.new(2,2,1)
th.CanCollide=false
th.Anchored=false
th.Parent=tacc

local tmesh=Instance.new("SpecialMesh")
tmesh.MeshId="rbxassetid://122893327645752"
tmesh.TextureId="rbxassetid://104104537744071"
tmesh.Parent=th

th.CFrame=torso.CFrame*CFrame.new(toff)*CFrame.Angles(math.rad(trot.X),math.rad(trot.Y),math.rad(trot.Z))

local tw=Instance.new("WeldConstraint")
tw.Part0=torso
tw.Part1=th
tw.Parent=th

local decs={
	"http://www.roblox.com/asset/?id=17364186013",
	"http://www.roblox.com/asset/?id=17364186013"
}
local cols={
	Color3.fromRGB(255,0,255),
	Color3.fromRGB(56,56,255),
	Color3.fromRGB(255,30,30),
	Color3.fromRGB(255,255,40),
	Color3.fromRGB(30,255,30)
}

local function pick(a)return a[math.random(1,#a)]end
local t=0
local waitt=4

rs.Heartbeat:Connect(function(dt)
	if not ch.Parent then return end
	t=t+dt
	if t<waitt then return end
	t=0
	local lf=ch:FindFirstChild("LeftFoot")or ch:FindFirstChild("Left Leg")
	local rf=ch:FindFirstChild("RightFoot")or ch:FindFirstChild("Right Leg")
	if not lf or not rf then return end
	local foot=math.random()<.5 and lf or rf
	local pos=foot.Position-Vector3.new(0,foot.Size.Y/2+.05,0)
	local spl=Instance.new("Part")
	spl.Size=Vector3.new(6,.05,6)
	spl.Anchored=true
	spl.CanCollide=false
	spl.Position=pos
	spl.Parent=workspace
	spl.Transparency=1
	local d=Instance.new("Decal")
	d.Face=Enum.NormalId.Top
	d.Texture=pick(decs)
	d.Color3=pick(cols)
	d.Parent=spl
	local goal={Transparency=1,Size=Vector3.new(.2,.05,.2)}
	local info=TweenInfo.new(1,Enum.EasingStyle.Linear)
	local tw=tws:Create(spl,info,goal)
	tw:Play()
	db:AddItem(spl,1.1)
end)

local stopid=116618003477002
local playid=77448521277146

ch.Humanoid.AnimationPlayed:Connect(function(a)
	if a.Animation.AnimationId=="rbxassetid://"..stopid then
		a:Stop()
		local newa=Instance.new("Animation")
		newa.AnimationId="rbxassetid://"..playid
		local play=ch.Humanoid:LoadAnimation(newa)
		play:Play()
	end
end)

local icon=lp.PlayerGui:WaitForChild("TemporaryUI"):WaitForChild("PlayerInfo"):WaitForChild("CurrentSurvivors"):WaitForChild("Shedletsky")
if icon and icon:FindFirstChild("Icon")and icon:FindFirstChild("Username")then
	local txt=icon.Username.Text
	if txt==lp.Name.." (You)"then
		icon.Icon.Image="rbxassetid://110965459998666"
	end
end

print("I finally know how to properly FUCKING check if ur actually using preset skin/char")
print("well,,, using a busted method but WHATEVA!!")
