local re=game:GetService("Workspace")
local sandbox=function(var,func)
	local env=getfenv(func)
	local newenv=setmetatable({},{
		__index=function(self,k)
			if k=="script" then
				return var
			else
				return env[k]
			end
		end,
	})
	setfenv(func,newenv)
	return func
end
cors={}
local _Name="Telekinesis V5"
local uis=game:GetService("UserInputService")
local _Ins, _CF_new, _VTR_new=Instance.new, CFrame.new, Vector3.new
mas=_Ins("Model",game:GetService("Lighting"))
local con=getfenv().sethiddenproperty
Tool0=_Ins("Tool")
Part1=_Ins("Part")
Script2=_Ins("Script")
local selectionbox=Instance.new("SelectionBox", game:GetService("Players").LocalPlayer.Character)
selectionbox.LineThickness=0.3
selectionbox.Color3=Color3.fromRGB(255, 255, 255)	
LocalScript3=_Ins("LocalScript")
re=game:GetService("RunService")
Tool0.Name=_Name
Tool0.Parent=mas
Tool0.Grip=_CF_new(0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1)
Tool0.GripPos=_VTR_new(0, 0, 1)
Part1.Name="Handle"
Part1.Parent=Tool0
local changed="Changed"
Part1.CFrame=_CF_new(-3.5, 5.30000019, -3.5, 1, 0, 0, 0, -1, 0, 0, 0, -1)
Part1.Orientation=_VTR_new(0, 180, 180)
Part1.Position=_VTR_new(-3.5, 5.300000190734863, -3.5)
Part1.Rotation=_VTR_new(-180, 0, 0)
Part1.Color=Color3.new(0.972549, 0.972549, 0.972549)
Part1.Transparency=1
local cam=re.RenderStepped
local w=wait
Part1.Size=_VTR_new(1, 1, 1)
Part1.BottomSurface=Enum.SurfaceType.Smooth
Part1.BrickColor=BrickColor.new("Institutional white")
Part1.Locked=true
local speed=31
local mb=uis.TouchEnabled
Part1.TopSurface=Enum.SurfaceType.Smooth
Part1.brickColor=BrickColor.new("Institutional white")
Script2.Name="LineConnect"
Script2.Parent=Tool0
local Sound=_Ins("Sound", game.Workspace)
Sound.SoundId="rbxassetid://1092093337"
Sound:Play()
cam:Connect(function() if con then con(game:GetService("Players").LocalPlayer, changed, speed) end end)
table.insert(cors,sandbox(Script2,function()
	w()
	local check=script.Part2
	local part1=script.Part1.Value
	local part2=script.Part2.Value
	local parent=script.Par.Value
	local color=script.Color
	local line=_Ins("Part")
	line.TopSurface=0
	line.BottomSurface=0
	line.Reflectance=.5
	line.Name="Laser"
	line.Locked=true
	line.CanCollide=false
	line.Anchored=true
	line.formFactor=0
	line.Size=_VTR_new(1,1,1)
	local mesh=_Ins("BlockMesh")
	mesh.Parent=line
	while true do
		if (check.Value==nil) then break end
		if (part1==nil or part2==nil or parent==nil) then break end
		if (part1.Parent==nil or part2.Parent==nil) then break end
		if (parent.Parent==nil) then break end
		local lv=_CF_new(part1.Position,part2.Position)
		local dist=(part1.Position-part2.Position).magnitude
		line.Parent=parent
		line.BrickColor=color.Value.BrickColor
		line.Reflectance=color.Value.Reflectance
		line.Transparency=color.Value.Transparency
		line.CFrame=_CF_new(part1.Position+lv.lookVector*dist/2)
		line.CFrame=_CF_new(line.Position,part2.Position)
		mesh.Scale=_VTR_new(.25,.25,dist)
		w()
	end
	line:remove()
	script:remove() 
end))
changed="SimulationRadius"
Script2.Disabled=true
LocalScript3.Name="MainScript"
LocalScript3.Parent=Tool0
table.insert(cors,sandbox(LocalScript3,function()
	w() 
	tool=script.Parent
	lineconnect=tool.LineConnect
	object=nil
	mousedown=false
	found=false
	BP=_Ins("BodyPosition")
	BP.maxForce=_VTR_new(math.huge*math.huge,math.huge*math.huge,math.huge*math.huge) --pwns everyone elses bodyposition
	BP.P=BP.P*3
	dist=nil
	point=_Ins("Part")
	point.Locked=true
	point.Anchored=true
	point.formFactor=0
	point.Shape=0
	point.BrickColor=BrickColor.Blue() 
	point.Size=_VTR_new(1,1,1)
	point.CanCollide=false
	local mesh=_Ins("SpecialMesh")
	mesh.MeshType="Sphere"
	mesh.Scale=_VTR_new(.7,.7,.7)
	mesh.Parent=point
	handle=tool.Handle
	front=tool.Handle
	color=tool.Handle
	objval=nil
	local hooked=false 
	local hookBP=BP:clone() 
	hookBP.maxForce=_VTR_new(30000,30000,30000) 

	local LineConnect=function(part1,part2,parent)
		local p1=_Ins("ObjectValue")
		p1.Value=part1
		p1.Name="Part1"
		local p2=_Ins("ObjectValue")
		p2.Value=part2
		p2.Name="Part2"
		local par=_Ins("ObjectValue")
		par.Value=parent
		par.Name="Par"
		local col=_Ins("ObjectValue")
		col.Value=color
		col.Name="Color"
		local s=lineconnect:clone()
		s.Disabled=false
		p1.Parent=s
		p2.Parent=s
		par.Parent=s
		col.Parent=s
		s.Parent=workspace
		if (part2==object) then
			objval=p2
		end
	end

	local onButton1Down=function(mouse)
		if (mousedown==true) then return end
		mousedown=true
		coroutine.resume(coroutine.create(function()
			local p=point:clone()
			p.Parent=tool
			LineConnect(front,p,workspace)
			while (mousedown==true) do
				p.Parent=tool
				if (object==nil) then
					if (mouse.Target==nil) then
						local lv=_CF_new(front.Position,mouse.Hit.p)
						p.CFrame=_CF_new(front.Position+(lv.lookVector*1000))
					else
						p.CFrame=_CF_new(mouse.Hit.p)
					end
				else
					LineConnect(front,object,workspace)
					break
				end
				w()
			end
			p:remove()
		end))
		while (mousedown==true) do
			if (mouse.Target~=nil) then
				local t=mouse.Target
				if (t.Anchored==false) then
					object=t
					selectionbox.Adornee=object
					dist=(object.Position-front.Position).magnitude
					break
				end
			end
			w()
		end
		while (mousedown==true) do
			if (object.Parent==nil) then break end
			local lv=_CF_new(front.Position,mouse.Hit.p)
			BP.Parent=object
			BP.position=front.Position+lv.lookVector*dist
			w()
		end
		BP:remove()
		object=nil
		objval.Value=nil
		selectionbox.Adornee=nil
	end

	local onKeyDown=function(key,mouse) 
		local key=key:lower() 
		local yesh=false 
		if (key=="q") then 
			if (dist>=5) then 
				dist=dist-5 
			end 
		end
		if (key=="u") then 
			if (dist ~=1) then 
				BX=_Ins("BodyGyro")
				BX.MaxTorque=_VTR_new(math.huge,0,math.huge)
				BX.CFrame=BX.CFrame * CFrame.Angles(0, math.rad(45), 0)
				BX.D=0
				BX.Parent=object
				--object.CFrame=CFrame.Angles(math.rad(90), 0,0) -- not used
				--object.Orientation=_VTR_new(50,0,0)
				--BX.Orientation=_VTR_new(23,0,0)
			end 
		end 
		if (key=="p") then 
			if (dist ~=1) then
				BX=_Ins("BodyVelocity")
				BX.maxForce=_VTR_new(0,math.huge,0)
				BX.velocity=_VTR_new(0,1,0)
				--BX.CFrame=BX.CFrame * CFrame.Angles(0, math.rad(45), 0)
				BX.Parent=object
			end 
		end 
		if key == "l" then 
			if (object==nil) then return end 
			for _,v in pairs(object:children()) do 
				if v.className == "BodyGyro" then 
					return nil 
				end 
			end 
			BG=_Ins("BodyGyro") 
			BG.maxTorque=_VTR_new(math.huge,math.huge,math.huge) 
			BG.cframe=_CF_new(object.CFrame.p) 
			BG.Parent=object 
			repeat w() until(object.CFrame == _CF_new(object.CFrame.p))
			BG.Parent=nil 
			if (object==nil) then return end 
			for _,v in pairs(object:children()) do 
				if v.className == "BodyGyro" then 
					v.Parent=nil 
				end 
			end 
			object.Velocity=_VTR_new(0,0,0) 
			object.RotVelocity=_VTR_new(0,0,0) 
		end 
		if (key=="y") then 
			if (dist ~=100) then 
				dist=100 
			end 
		end 
		if (key=="j") then 
			if (dist~=5000) then 
				dist=5000 
			end 
		end
		if (key=="e") then
			dist=dist+5
		end
		if (key=="x") then 
			if dist ~= 15 then 
				dist=15 
			end 
		end 
	end
	local onEquipped=function(mouse)
		keymouse=mouse
		local char=tool.Parent
		human=char.Humanoid
		human.Changed:connect(function() if (human.Health==0) then mousedown=false BP:remove() point:remove() tool:remove() end end)
		mouse.Button1Down:connect(function() onButton1Down(mouse) end)
		mouse.KeyDown:connect(function(key) onKeyDown(key,mouse) end)
		mouse.Icon="rbxasset://textures\\GunCursor.png"
		if mb then
			uis.TouchLongPress:Connect(function() onKeyDown("y",mouse) end)
			uis.TouchEnded:Connect(function() mousedown=false end)
		else
			mouse.Button1Up:connect(function() mousedown=false end)
		end
	end
	tool.Equipped:connect(onEquipped)
	tool.Unequipped:connect(function() mousedown=false end)
end))
for i,v in pairs(mas:GetChildren()) do
	v.Parent=game:GetService("Players").LocalPlayer.Backpack
	pcall(function() v:MakeJoints() end)
end
mas:Destroy()
for i,v in pairs(cors) do
	spawn(function()
		pcall(v)
	end)
end