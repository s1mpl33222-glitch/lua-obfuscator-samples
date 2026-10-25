-- ============================================================
-- AUTO GRAB GUI — exact "UNREADY / READY" floating pill
-- Extracted verbatim from Done.lua (StealProgressGui).
-- The whole pill IS the progress bar; it fills while stealing
-- and flips UNREADY -> READY. Tapping it toggles Auto Steal.
-- Steal a Brainrot.
-- ============================================================
repeat task.wait() until game:IsLoaded()

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local TS         = game:GetService("TweenService")
local UIS        = game:GetService("UserInputService")
local LP         = Players.LocalPlayer

-- ============================================================
-- MINIMAL STEAL STATE (from Done.lua, needed by the bar)
-- ============================================================
local Steal = {
	AutoStealEnabled=false, StealRadius=60, StealDuration=1,
	Mode="half", -- locked to half autograb
	HalfFireRange=10, HalfHoldMin=1.3, HalfHoldMax=2.6, HalfEntryDelay=0.3,
	Data={}
}
local isStealing = false
local stealStartTime = nil
local autoConn = nil
local progressFill, progressPct

local function isMyPlotByName(plotName)
	local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
	local plot=plots:FindFirstChild(plotName); if not plot then return false end
	local sign=plot:FindFirstChild("PlotSign")
	if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
	return false
end
local function findNearestPrompt()
	local char=LP.Character; if not char then return nil end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return nil end
	local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
	local nearest,dist=nil,math.huge
	for _,plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
			local pods=plot:FindFirstChild("AnimalPodiums")
			if pods then
				for _,pod in ipairs(pods:GetChildren()) do
					local base=pod:FindFirstChild("Base")
					local sp=base and base:FindFirstChild("Spawn")
					if sp then
						local d=(sp.Position-root.Position).Magnitude
						if d<=Steal.StealRadius and d<dist then
							local found=nil
							local att=sp:FindFirstChild("PromptAttachment")
							if att then for _,pr in ipairs(att:GetChildren()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if not found then for _,pr in ipairs(sp:GetDescendants()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if found then nearest,dist=found,d end
						end
					end
				end
			end
		end
	end
	return nearest
end
local function _promptDist(prompt)
	local char=LP.Character; if not char then return math.huge end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return math.huge end
	local part=prompt.Parent
	if part and part:IsA("Attachment") then part=part.Parent end
	if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
	local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
	if ok and cf then return (cf-root.Position).Magnitude end
	return math.huge
end
local function executeSteal(prompt)
	if isStealing then return end
	if not Steal.Data[prompt] then
		Steal.Data[prompt]={hold={},trigger={},ready=true}
		if getconnections then
			for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
			for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
		end
	end
	local data=Steal.Data[prompt]; if not data.ready then return end
	data.ready=false; isStealing=true; stealStartTime=tick()
	if Steal.Mode=="half" then
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			task.wait(Steal.HalfHoldMin)
			local inRange=_promptDist(prompt)<=Steal.HalfFireRange
			while true do
				local el=tick()-stealStartTime
				if el>Steal.HalfHoldMax or not prompt.Parent then break end
				if _promptDist(prompt)<=Steal.HalfFireRange then
					if not inRange then task.wait(Steal.HalfEntryDelay) end
					for _,fn in ipairs(data.trigger) do task.spawn(fn) end; break
				end
				task.wait()
			end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	else
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			local el=0; while el<Steal.StealDuration do el=el+task.wait() end
			for _,fn in ipairs(data.trigger) do task.spawn(fn) end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	end
end
local function startAutoSteal()
	if autoConn then return end
	autoConn=RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p=findNearestPrompt(); if p then executeSteal(p) end
	end)
end
local function stopAutoSteal()
	if autoConn then autoConn:Disconnect(); autoConn=nil end
	isStealing=false
end
_G.AutoSteal = Steal

-- ============================================================
-- THE EXACT GUI (StealProgressGui from Done.lua)
-- ============================================================
do
	local _oldSPG = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
	if _oldSPG then _oldSPG:Destroy() end
	local spScreenGui=Instance.new("ScreenGui")
	spScreenGui.Name="StealProgressScreenGui";spScreenGui.ResetOnSpawn=false
	spScreenGui.DisplayOrder=200;spScreenGui.IgnoreGuiInset=true
	spScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	spScreenGui.Parent=LP.PlayerGui

	local spFrame=Instance.new("Frame",spScreenGui)
	spFrame.Name="StealProgressGui"
	spFrame.Size=UDim2.new(0,320,0,24)
	spFrame.Position=UDim2.new(0.5,0,1,-90)
	spFrame.AnchorPoint=Vector2.new(0.5,1)
	spFrame.BackgroundColor3=Color3.fromRGB(10,10,10)
	spFrame.BorderSizePixel=0;spFrame.Active=true;spFrame.Visible=true
	spFrame.ZIndex=300;spFrame.ClipsDescendants=true
	Instance.new("UICorner",spFrame).CornerRadius=UDim.new(1,0)
	local spBorder=Instance.new("UIStroke",spFrame)
	spBorder.Color=Color3.fromRGB(255,30,60);spBorder.Thickness=2;spBorder.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

	local _spWasDragged=false
	local spToggleBtn=Instance.new("TextButton",spFrame)
	spToggleBtn.Name="ToggleGUIBtn";spToggleBtn.Size=UDim2.new(1,0,1,0)
	spToggleBtn.BackgroundTransparency=1;spToggleBtn.Text="";spToggleBtn.AutoButtonColor=false;spToggleBtn.ZIndex=310
	spToggleBtn.Activated:Connect(function()
		if _spWasDragged then return end
		local base=spFrame.Size
		TS:Create(spFrame,TweenInfo.new(0.08),{Size=UDim2.new(base.X.Scale,base.X.Offset*0.95,base.Y.Scale,base.Y.Offset*0.9)}):Play()
		task.delay(0.1,function() TS:Create(spFrame,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Size=base}):Play() end)
		-- half autograb is always on; tap is cosmetic only
	end)

	-- whole-panel fill (the window IS the bar)
	local spFill=Instance.new("Frame",spFrame)
	spFill.Name="ProgressFill";spFill.Size=UDim2.new(0,0,1,-6);spFill.Position=UDim2.new(0,3,0,3)
	spFill.BackgroundColor3=Color3.fromRGB(255,30,60);spFill.BackgroundTransparency=0.15
	spFill.BorderSizePixel=0;spFill.ZIndex=301
	Instance.new("UICorner",spFill).CornerRadius=UDim.new(1,0)

	local spPct=Instance.new("TextLabel",spFrame)
	spPct.Size=UDim2.new(1,-28,1,0);spPct.Position=UDim2.new(0,14,0,0)
	spPct.BackgroundTransparency=1;spPct.Text="UNREADY";spPct.TextColor3=Color3.fromRGB(255,255,255)
	spPct.Font=Enum.Font.GothamBlack;spPct.TextSize=12;spPct.TextStrokeTransparency=0.15;spPct.TextStrokeColor3=Color3.fromRGB(0,0,0)
	spPct.TextXAlignment=Enum.TextXAlignment.Center;spPct.TextYAlignment=Enum.TextYAlignment.Center;spPct.ZIndex=304

	progressFill=spFill
	progressPct=spPct

	-- drive fill/label
	local _lastPct=0
	RunService.RenderStepped:Connect(function()
		if not spFrame.Visible then return end
		local pct=0
		if isStealing and stealStartTime then
			-- half mode fills over the hold-min window
			pct=math.clamp((tick()-stealStartTime)/math.max(Steal.HalfHoldMin,0.01),0,1)
		elseif Steal.AutoStealEnabled then
			pct=(findNearestPrompt() and 1 or 0)
		end
		_lastPct=_lastPct+(pct-_lastPct)*0.2
		local f=math.clamp(_lastPct,0,1)
		spFill.Size=UDim2.new(f,-6*f,1,-6)
		if _lastPct>=0.87 then spPct.Text="READY";spPct.TextColor3=Color3.fromRGB(120,255,140)
		else spPct.Text="UNREADY";spPct.TextColor3=Color3.fromRGB(255,255,255) end
	end)

	-- drag handling with off-screen clamp
	local dragging,dragStart,startPos=false,nil,nil
	spToggleBtn.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
			dragging=true;_spWasDragged=false;dragStart=inp.Position;startPos=spFrame.Position
			inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if not dragging then return end
		if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
			local dx=inp.Position.X-dragStart.X
			local dy=inp.Position.Y-dragStart.Y
			if math.abs(dx)>5 or math.abs(dy)>5 then _spWasDragged=true end
			local cam=workspace.CurrentCamera
			local vp=cam and cam.ViewportSize or Vector2.new(1000,1000)
			local sz=spFrame.AbsoluteSize
			local newXScalePx=startPos.X.Scale*vp.X
			local newX=math.clamp(newXScalePx+startPos.X.Offset+dx,sz.X/2,vp.X-sz.X/2)
			local newY=math.clamp(startPos.Y.Scale*vp.Y+startPos.Y.Offset+dy,sz.Y,vp.Y)
			spFrame.Position=UDim2.new(startPos.X.Scale,newX-newXScalePx,startPos.Y.Scale,newY-startPos.Y.Scale*vp.Y)
		end
	end)
	_G._CursedSetProgressBarVisible=function(v) spFrame.Visible=v end
end

-- half autograb always on
Steal.AutoStealEnabled=true
pcall(startAutoSteal)

-- ============================================================
-- TORSO BILLBOARD — Ghoxt Hub / discord.gg/3cM2dEDr3
-- ============================================================
do
	local TEXT = "Ghoxt Hub\nhttps://discord.gg/3cM2dEDr3"
	local function attach(char)
		if not char then return end
		local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:WaitForChild("HumanoidRootPart",5)
		if not torso then return end
		local old = torso:FindFirstChild("GhoxtHubTag")
		if old then old:Destroy() end
		local bb = Instance.new("BillboardGui")
		bb.Name = "GhoxtHubTag"
		bb.Adornee = torso
		bb.Size = UDim2.new(0,320,0,70)
		bb.StudsOffset = Vector3.new(0,0,0)
		bb.AlwaysOnTop = true
		bb.MaxDistance = 1000
		bb.Parent = torso
		local lbl = Instance.new("TextLabel",bb)
		lbl.BackgroundTransparency = 1
		lbl.Size = UDim2.new(1,0,1,0)
		lbl.Font = Enum.Font.GothamBlack
		lbl.TextScaled = true
		lbl.Text = TEXT
		lbl.TextColor3 = Color3.fromRGB(255,255,255)
		lbl.TextStrokeTransparency = 0
		lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	end
	if LP.Character then attach(LP.Character) end
	LP.CharacterAdded:Connect(function(c) task.wait(0.3); attach(c) end)
end