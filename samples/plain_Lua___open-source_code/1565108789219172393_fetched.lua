local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local lp = Players.LocalPlayer
local req = request or http_request or (syn and syn.request)

local hook = ""

local lastWin = 0
local COOLDOWN = 5

local function stripTags(t)
	return t and t:gsub("<[^>]+>", "") or ""
end

local function short(n)
	if n >= 1e12 then return string.format("%.1fT",n/1e12)
	elseif n >= 1e9 then return string.format("%.1fB",n/1e9)
	elseif n >= 1e6 then return string.format("%.1fM",n/1e6)
	elseif n >= 1e3 then return string.format("%.1fK",n/1e3) end
	return tostring(math.floor(n))
end

local function num(v)
	v = tostring(v):gsub("%s","")
	local n,s = v:match("([%d%.]+)(%a?)")
	n = tonumber(n) or 0
	if s == "K" or s == "k" then n = n * 1e3
	elseif s == "M" or s == "m" then n = n * 1e6
	elseif s == "B" or s == "b" then n = n * 1e9
	elseif s == "T" or s == "t" then n = n * 1e12 end
	return n
end

local function getBrainrot()
	local p3 = Vector3.new(-476.752,10.464,7.107)
	local p7 = Vector3.new(-476.752,10.464,114.107)
	local mine
	
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Name == "PlotSign" then
			local d3 = (v.Position-p3).Magnitude
			local d7 = (v.Position-p7).Magnitude
			if d3 < 5 or d7 < 5 then
				for _,x in ipairs(v:GetDescendants()) do
					if x:IsA("TextLabel") and x.Text ~= "" then
						if x.Text:find(lp.Name) or x.Text:find(lp.DisplayName) then
							mine = d3 < 5 and 3 or 7
						end
					end
				end
			end
		end
	end
	
	if not mine then return "Unknown","N/A" end
	local pos = mine == 3 and p7 or p3
	local db = workspace:FindFirstChild("Debris")
	if not db then return "Unknown","N/A" end
	
	local best,bestVal
	for _,v in ipairs(db:GetChildren()) do
		repeat
		if v.Name ~= "FastOverheadTemplate" then break end
		local sg = v:FindFirstChildOfClass("SurfaceGui")
		if not sg or not sg.Adornee then break end
		if (sg.Adornee.Position-pos).Magnitude > 50 then break end
		local gen = sg:FindFirstChild("Generation",true)
		if gen and gen:IsA("TextLabel") then
			local val = num(gen.Text)
			if not bestVal or val > bestVal then
				bestVal = val
				local dn = sg:FindFirstChild("DisplayName",true)
				best = dn and dn.Text or v.Name
			end
		end
		until true
	end
	return best or "Unknown", bestVal and short(bestVal) or "N/A"
end

local function send(brainrot, value)
	if not req or hook == "" then return end
	local s = tostring(brainrot):gsub("`","'")
	pcall(function()
		req({
			Url = hook,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = Http:JSONEncode({
				embeds = {{
					title = "\u{1FAE8}POLM HUB DUELS\u{1FAE8}",
					description = "```\u{1F62E}\u{200D}\u{1F4A8} SOMONE JUST MOGGED WITH DUELS V2 \u{1F62E}\u{200D}\u{1F4A8}```",
					color = 0xADD8E6,
					fields = {
						{name="\u{1F9E0} Brainrot",value="```"..s.."```",inline=true},
						{name="\u{1F4B0} Value",value="```"..value.."```",inline=true}
					},
					footer = {text = "POLM HUB | "..os.date("%H:%M:%S")},
					timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
				}}
			})
		})
	end)
end

local function onWin()
	if tick()-lastWin < COOLDOWN then return end
	lastWin = tick()
	
	print("[POLM HUB] WIN DETECTED!")
	local br,val = getBrainrot()
	print(string.format("[POLM HUB] %s | %s", br, val))
	send(br, val)
end
-- this print not ai i put it to test the script
local function scan(obj)
	if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
	local clean = stripTags(obj.Text):lower()
	if clean:find(lp.Name:lower(),1,true) and clean:find("won the duel") then
		onWin()
	end
end

local pg = lp:WaitForChild("PlayerGui")

for _,v in ipairs(pg:GetDescendants()) do
	scan(v)
	if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
		v:GetPropertyChangedSignal("Text"):Connect(function() scan(v) end)
	end
end

pg.DescendantAdded:Connect(function(v)
	scan(v)
	if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
		v:GetPropertyChangedSignal("Text"):Connect(function() scan(v) end)
	end
end)-- Lua 5.1 compatible build v2 (no _G usage: shared names live in one local table)
local __HH = {}
local LP = LP
local Lighting = Lighting
local Players = Players
local RunService = RunService
local SKY_PRESETS = SKY_PRESETS
local TS = TS
local loadConfig = loadConfig
local uiScaleValue = uiScaleValue
do

-- ============================================================
-- RED CIRCLE — always ON. No toggle, no button, no config.
-- Flat red disc on the ground right under the player, exactly
-- like Polm Hub's red circle. Follows the ground everywhere and
-- keeps working across respawns automatically.
-- ============================================================
do
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
        local plrs = game:GetService("Players")
        local run  = game:GetService("RunService")
        local lplr = plrs.LocalPlayer
        local c = Instance.new("Part")
        c.Name = "PolmHubRedCircle"
        c.Shape = Enum.PartType.Cylinder
        c.Size = Vector3.new(12, 0.1, 12)
        c.Anchored = true
        c.CanCollide = false
        c.CanQuery = false
        c.CanTouch = false
        c.CastShadow = false
        c.Material = Enum.Material.SmoothPlastic
        c.Color = Color3.fromRGB(255, 45, 48)
        c.Transparency = 0.4
        c.Parent = workspace
        print("[polmhub] RED CIRCLE CREATED ✓")
        run.Heartbeat:Connect(function()
            pcall(function()
                if not (c and c.Parent) then return end
                local char = lplr.Character
                if not char then c.Visible = false; return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then c.Visible = false; return end
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {char, c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local res = workspace:Raycast(hrp.Position, Vector3.new(0, -2000, 0), rp)
                if res then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local gy = res.Position.Y + 0.06
                    if hum then
                        -- hard clamp: the circle never rises into the player
                        gy = math.min(gy, hrp.Position.Y - hum.HipHeight - 0.05)
                    end
                    c.Visible = true
                    c.CFrame = CFrame.new(res.Position.X, gy, res.Position.Z)
                else
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial ~= Enum.Material.Air then
                        c.Visible = true
                        c.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - hum.HipHeight - 0.1, hrp.Position.Z)
                    else
                        c.Visible = false
                    end
                end
            end)
        end)
    end)
end

task.spawn(function() pcall(function()
repeat task.wait() until game:IsLoaded()
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")
local SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
local SKY_PRESETS = {
    Off={kind="off"},
    Night={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140}},
    Aurora={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150}},
    Sunset={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110}},
    Galaxy={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110}},
    Tech={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180}},
    Sakura={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150}},
    Volcanic={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50}},
    Arctic={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140}},
    Vaporwave={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210}},
    Toxic={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70}},
    Hellscape={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40}},
    Heaven={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220}},
    Storm={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120}},
    Sunrise={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230}},
    Inferno={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220}}
}
local function _vC3(t) return Color3.fromRGB(t[1],t[2],t[3]) end
local function _v4mpClearSky()
    for _,v in ipairs(game:GetService("Lighting"):GetChildren()) do if v:GetAttribute("_AceDuelsSky") then pcall(function() v:Destroy() end) end end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,v in ipairs(terrain:GetChildren()) do if v:GetAttribute("_AceDuelsSky") then pcall(function() v:Destroy() end) end end end
end
local function applyCustomSky(mode)
    _v4mpClearSky()
    local p = SKY_PRESETS[mode]
    local Lighting = game:GetService("Lighting")
    if not p or p.kind=="off" then 
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.GlobalShadows=true; 
        __HH.currentSkyTheme="Off"; return 
    end
    Lighting.ClockTime=p.clock or 14; Lighting.Brightness=p.brightness or 2; 
    if p.ambient then Lighting.Ambient=_vC3(p.ambient) end; 
    if p.outAmb then Lighting.OutdoorAmbient=_vC3(p.outAmb) end
    local atm=Instance.new("Atmosphere"); atm:SetAttribute("_AceDuelsSky",true); atm.Density=0.35; atm.Color=Lighting.Ambient; atm.Decay=Lighting.OutdoorAmbient; atm.Parent=Lighting
    local sky=Instance.new("Sky"); sky:SetAttribute("_AceDuelsSky",true); sky.StarCount=(mode=="Galaxy" or mode=="Deep Space") and 10000 or 2000; sky.Parent=Lighting
    __HH.currentSkyTheme=mode
end
end) end)

-- insta steal
task.spawn(function() pcall(function()
repeat task.wait() until game:IsLoaded()
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats             = game:GetService("Stats")
local LP = Players.LocalPlayer
if _G.InstaStealConn then
    pcall(function() _G.InstaStealConn:Disconnect() end)
    _G.InstaStealConn = nil
end
if _G.FRHUBNormalSteal and _G.FRHUBNormalSteal.stealConn then
    pcall(function() _G.FRHUBNormalSteal.stealConn:Disconnect() end)
end
if _G.FRHUBSemiSteal and _G.FRHUBSemiSteal.conn then
    pcall(function() _G.FRHUBSemiSteal.conn:Disconnect() end)
end
pcall(function()
    local old = CoreGui:FindFirstChild("InstaSteal_Standalone")
    if old then old:Destroy() end
end)
local CONFIG_PATH = "Polm Hub/polm_config.json"
local Radii = {Normal = 60, Semi = 9, SemiV2 = 51, SemiV3 = 60}
local selectedMode   = "SemiV3"
local isEnabled      = true
local uiScaleValue   = 100
local mainUIScale    = nil
local function saveConfig()
    pcall(function()
        local data = {
            normalRadius = Radii.Normal,
            semiRadius   = Radii.Semi,
            semiV2Radius = Radii.SemiV2,
            semiV3Radius = Radii.SemiV3,
            mode         = selectedMode,
            enabled      = isEnabled,
            uiScale      = uiScaleValue,
        }
        writefile(CONFIG_PATH, game:GetService("HttpService"):JSONEncode(data))
    end)
end
local function loadConfig()
    pcall(function()
        if not isfile(CONFIG_PATH) then return end
        local raw = readfile(CONFIG_PATH)
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
        if not ok or type(data) ~= "table" then return end
        if type(data.normalRadius) == "number" then Radii.Normal = data.normalRadius end
        if type(data.semiRadius)   == "number" then Radii.Semi   = data.semiRadius   end
        if type(data.semiV2Radius) == "number" then Radii.SemiV2 = data.semiV2Radius end
        if type(data.semiV3Radius) == "number" then Radii.SemiV3 = data.semiV3Radius end
        -- Only the SemiV3 engine is implemented in this script.
        -- Old configs that saved mode "Normal"/"Semi"/"SemiV2" were silently
        -- disabling the auto steal entirely, so always force SemiV3.
        selectedMode = "SemiV3"
        if type(data.enabled) == "boolean" then isEnabled = data.enabled end
        if type(data.uiScale) == "number"  then uiScaleValue = math.clamp(math.floor(data.uiScale + 0.5), 50, 200) end
    end)
end
loadConfig()
local ProgressBarFill = nil
local ProgressPercentLabel = nil
local grabPercentageLabel = nil
local _currentStealProgress = 0
_G.PolmHubIntroFinished = false
local function setProgress(val, labelText)
    _currentStealProgress = math.clamp(val, 0, 1)
    if _G.StealBar then
        _G.StealBar.SetState("STEALING")
        _G.StealBar.SetProgress(_currentStealProgress, labelText)
    end
    if ProgressBarFill then
        TweenService:Create(ProgressBarFill, TweenInfo.new(0.05), {
            Size = UDim2.new(_currentStealProgress, 0, 1, 0)
        }):Play()
    end
    if ProgressPercentLabel then
        ProgressPercentLabel.Text = math.floor(_currentStealProgress * 100 + 0.5) .. "%"
    end
    if grabPercentageLabel then
        if type(labelText) == "string" and labelText ~= "" then
            grabPercentageLabel.Text = string.upper(labelText)
        elseif _currentStealProgress > 0 then
            grabPercentageLabel.Text = "STEALING  " .. math.floor(_currentStealProgress * 100 + 0.5) .. "%"
        else
            grabPercentageLabel.Text = "GRAB PERCENTAGE"
        end
    end
end

-- Nexus-style steal HUD card (AUTO STEAL | state | FPS/ping | % + progress line)
local function setupNexusGrabBar()
    local pg=LP:WaitForChild("PlayerGui"); local old=pg:FindFirstChild("StealBarGui"); if old then old:Destroy() end
    local cg=game:GetService("CoreGui"); local oldc=cg:FindFirstChild("StealBarGui"); if oldc then oldc:Destroy() end
    local gui=Instance.new("ScreenGui"); gui.Name="StealBarGui"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.Enabled=false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=cg end) then gui.Parent=pg end

    local savedPos=nil
    pcall(function()
        if isfile and isfile("polm_steal_bar_pos.json") then savedPos=game:GetService("HttpService"):JSONDecode(readfile("polm_steal_bar_pos.json")) end
    end)
    local pos=(type(savedPos)=="table" and UDim2.new(savedPos.xs or .5,savedPos.xo or -128,savedPos.ys or .78,savedPos.yo or 0)) or UDim2.new(.5,-128,.78,0)

    local ACCENT=Color3.fromRGB(162, 56, 255)
    local ACCENT_LIT=Color3.fromRGB(195, 126, 255)
    local ACCENT_DARK=Color3.fromRGB(138, 67, 200)

    local card=Instance.new("Frame",gui); card.Name="PersistentGrabHUD"; card.Size=UDim2.new(0,268,0,64); card.Position=pos
    card.BackgroundColor3=Color3.fromRGB(24, 12, 44); card.BackgroundTransparency=.04; card.BorderSizePixel=0; card.Active=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,18)
    local sbStroke=Instance.new("UIStroke",card); sbStroke.Color=ACCENT_LIT; sbStroke.Thickness=2; sbStroke.Transparency=0.05
    sbStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local cardGlow=Instance.new("UIGradient",card); cardGlow.Rotation=110
    cardGlow.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(150,130,190))})

    local sideAccent=Instance.new("Frame",card); sideAccent.Size=UDim2.new(0,0,0,0); sideAccent.Visible=false
    sideAccent.BackgroundColor3=ACCENT; sideAccent.BorderSizePixel=0

    local dot=Instance.new("Frame",card); dot.Size=UDim2.new(0,9,0,9); dot.Position=UDim2.new(0,14,0,10)
    dot.BackgroundColor3=ACCENT; dot.BackgroundTransparency=0; dot.BorderSizePixel=0; Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

    local stealLbl=Instance.new("TextLabel",card); stealLbl.Size=UDim2.new(0,110,0,16); stealLbl.Position=UDim2.new(0,30,0,6)
    stealLbl.BackgroundTransparency=1; stealLbl.Text="AUTO GRAB"; stealLbl.TextColor3=Color3.fromRGB(255,255,255)
    stealLbl.Font=Enum.Font.GothamBlack; stealLbl.TextSize=12; stealLbl.TextXAlignment=Enum.TextXAlignment.Left
    local stealGrad=Instance.new("UIGradient",stealLbl); stealGrad.Rotation=0
    stealGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(215,185,255))})

    local stateLbl=Instance.new("TextLabel",card); stateLbl.Size=UDim2.new(0,66,0,17); stateLbl.Position=UDim2.new(1,-78,0,6)
    stateLbl.BackgroundColor3=Color3.fromRGB(58, 30, 98); stateLbl.BackgroundTransparency=0; stateLbl.BorderSizePixel=0
    stateLbl.Text="OFF"; stateLbl.TextColor3=Color3.fromRGB(225,205,255); stateLbl.TextSize=9
    stateLbl.Font=Enum.Font.GothamBlack; stateLbl.TextXAlignment=Enum.TextXAlignment.Center
    Instance.new("UICorner",stateLbl).CornerRadius=UDim.new(1,0)

    local perfLbl=Instance.new("TextLabel",card); perfLbl.Size=UDim2.new(0,180,0,12); perfLbl.Position=UDim2.new(0,14,0,26)
    perfLbl.BackgroundTransparency=1; perfLbl.Text="FPS --  |  discord.gg/polmhub"; perfLbl.TextColor3=Color3.fromRGB(200,180,235); perfLbl.TextSize=8
    perfLbl.Font=Enum.Font.GothamMedium; perfLbl.TextXAlignment=Enum.TextXAlignment.Left

    local pctLbl=Instance.new("TextLabel",card); pctLbl.Size=UDim2.new(0,46,0,14); pctLbl.Position=UDim2.new(1,-58,0,24)
    pctLbl.BackgroundTransparency=1; pctLbl.Text="0%"; pctLbl.TextColor3=Color3.fromRGB(255,255,255); pctLbl.Font=Enum.Font.GothamBlack
    pctLbl.TextSize=11; pctLbl.TextXAlignment=Enum.TextXAlignment.Right

    local track=Instance.new("Frame",card); track.Size=UDim2.new(1,-24,0,12); track.Position=UDim2.new(0,12,1,-18)
    track.BackgroundColor3=Color3.fromRGB(52, 28, 88); track.BackgroundTransparency=0; track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local trackStroke=Instance.new("UIStroke",track); trackStroke.Color=Color3.fromRGB(190,150,255); trackStroke.Thickness=1; trackStroke.Transparency=0.6

    local fillLine=Instance.new("Frame",track); fillLine.Size=UDim2.new(0,0,1,0); fillLine.BackgroundColor3=ACCENT
    fillLine.BackgroundTransparency=0; fillLine.BorderSizePixel=0; Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
    local fillGrad=Instance.new("UIGradient",fillLine)
    fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(206, 150, 255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(155, 54, 245))})

    local dragging,ds,sp=false,nil,nil
    card.InputBegan:Connect(function(i)
        if _G.YousefUiLocked then return end
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true;ds=i.Position;sp=card.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and not _G.YousefUiLocked and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            card.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            if not _G.YousefUiLocked then
                pcall(function() writefile("polm_steal_bar_pos.json",game:GetService("HttpService"):JSONEncode({xs=card.Position.X.Scale,xo=card.Position.X.Offset,ys=card.Position.Y.Scale,yo=card.Position.Y.Offset})) end)
            end
        end
    end)

    task.spawn(function()
        local last=tick();local n=0;local fps=60
        RunService.RenderStepped:Connect(function() n = n + 1 end)
        while card.Parent do
            local now=tick();local dt=now-last
            if dt>=.25 then fps=n/dt;n=0;last=now end
            perfLbl.Text=string.format("FPS %d  |  discord.gg/polmhub",math.floor(fps+0.5))
            task.wait(.1)
        end
    end)

    task.spawn(function()
        while gui.Parent do
            if _G.PolmHubIntroFinished then
                gui.Enabled=true; card.Visible=true
            end
            task.wait(0.05)
        end
    end)

    _G.StealBar={
        SetProgress=function(v,labelText)
            v=math.clamp(tonumber(v) or 0,0,1)
            if _G.PolmHubIntroFinished then gui.Enabled=true end
            card.Visible=true; fillLine.Visible=true
            fillLine.Size=UDim2.new(v,0,1,0)
            pctLbl.Text=math.floor(v*100+.5).."%"
            if type(labelText)=="string" and labelText~="" then
                stateLbl.Text=string.upper(labelText)
            elseif v>0 then
                stateLbl.Text="STEALING"
            end
            dot.BackgroundColor3=ACCENT_LIT; sbStroke.Color=ACCENT_LIT
        end,
        SetState=function(txt)
            if type(txt)=="string" and txt~="" then
                stateLbl.Text=string.upper(txt)
                local s=string.upper(txt)
                if s=="STEALING" or s=="OP HOLD" then
                    stateLbl.TextColor3=Color3.fromRGB(120,255,175); stateLbl.BackgroundColor3=Color3.fromRGB(18,78,52)
                else
                    stateLbl.TextColor3=Color3.fromRGB(225,205,255); stateLbl.BackgroundColor3=Color3.fromRGB(58, 30, 98)
                end
            end
        end,
        Reset=function()
            fillLine.Size=UDim2.new(0,0,1,0); pctLbl.Text="0%"
            local masterOn = isEnabled
            if _G.PolmStealModes and _G.PolmStealModes.GetEnabled then
                local ok, value = pcall(_G.PolmStealModes.GetEnabled)
                if ok then masterOn = value == true end
            end
            stateLbl.Text = masterOn and "READY" or "OFF"
            stateLbl.TextColor3=Color3.fromRGB(225,205,255); stateLbl.BackgroundColor3=Color3.fromRGB(58, 30, 98)
            dot.BackgroundColor3=ACCENT_DARK; sbStroke.Color=ACCENT_DARK
        end
    }
    _G.StealBar.Reset()
end
task.delay(.15,setupNexusGrabBar)

task.spawn(function()
    local lastFrame = tick()
    local fpsSamples = {}
    local fpsAvg = 60
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - lastFrame
        lastFrame = now
        if dt > 0 then
            table.insert(fpsSamples, 1 / dt)
            if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
            local sum = 0
            for _, v in ipairs(fpsSamples) do sum = sum + v end
            fpsAvg = sum / #fpsSamples
        end
    end)
    while true do
        task.wait(0.5)
        pcall(function()
            if ProgressPercentLabel and ProgressPercentLabel.Parent then
                local pctStr = tostring(math.floor(_currentStealProgress * 100 + 0.5)) .. "%"
                ProgressPercentLabel.Text = string.format("%s | FPS:%d | discord.gg/polmhub", pctStr, math.floor(fpsAvg + 0.5))
            end
        end)
    end
end)

local function getHRP()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
end
local function isMyBase(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end




local SemiV3State = {
    conn = nil, isStealing = false, stealStartTime = nil, Data = {},
    HalfFireRange = 10, HalfHoldMin = 1.3, HalfHoldMax = 2.6, HalfEntryDelay = 0.3,
    lastScan = 0, lastFallbackScan = 0, lastFallbackResult = nil,
}
local function sv3PromptDist(prompt)
    local char = LP.Character
    if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    while part and not part:IsA("BasePart") and part ~= workspace and part.Parent ~= nil do
        part = part.Parent
    end
    if part and part:IsA("BasePart") then return (part.Position - root.Position).Magnitude end
    local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf - root.Position).Magnitude end
    return math.huge
end
local function sv3IsStealPrompt(pr)
    if not (pr and pr:IsA("ProximityPrompt")) then return false end
    local a = (pr.ActionText or ""):lower()
    return a:find("steal") ~= nil or a:find("grab") ~= nil or a:find("snatch") ~= nil
end
local function sv3FindNearestPrompt()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyBase(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= Radii.SemiV3 and d < dist then
                            local found = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if sv3IsStealPrompt(pr) then found = pr end
                                end
                            end
                            if not found then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if sv3IsStealPrompt(pr) then found = pr end
                                end
                            end
                            if found then nearest, dist = found, d end
                        end
                    end
                end
            end
        end
    end
    return nearest
end
-- Generic fallback scan: if the AnimalPodiums/Spawn structure above was not
-- found (different map / game update), search every ProximityPrompt on enemy
-- plots that looks like a steal prompt. Throttled by the caller.
local function sv3FindNearestPromptFallback()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyBase(plot.Name) then
            for _, pr in ipairs(plot:GetDescendants()) do
                if pr:IsA("ProximityPrompt") then
                    local a = (pr.ActionText or ""):lower()
                    if a:find("steal") or a:find("grab") then
                        local d = sv3PromptDist(pr)
                        if d <= Radii.SemiV3 and d < dist then
                            nearest, dist = pr, d
                        end
                    end
                end
            end
        end
    end
    return nearest
end
local function sv3CaptureConnections(prompt, data)
    if not getconnections then return end
    pcall(function()
        for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
            if c.Function then table.insert(data.hold, c.Function) end
        end
        for _, c in ipairs(getconnections(prompt.Triggered)) do
            if c.Function then table.insert(data.trigger, c.Function) end
        end
    end)
end
local function sv3FireHold(data)
    for _, fn in ipairs(data.hold) do task.spawn(fn) end
end
local function sv3FireTrigger(prompt, data)
    if #data.trigger > 0 then
        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
        return
    end
    -- No captured handlers (executor without getconnections, or the game
    -- connected later). Simulate the prompt directly instead of doing nothing.
    if fireproximityprompt then
        pcall(function() fireproximityprompt(prompt) end)
        return
    end
    pcall(function() prompt:InputHoldBegin() end)
    task.wait(0.3)
    pcall(function() prompt:InputHoldEnd() end)
end
local function sv3ExecuteSteal(prompt)
    if SemiV3State.isStealing then return end
    if not SemiV3State.Data[prompt] then
        SemiV3State.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        sv3CaptureConnections(prompt, SemiV3State.Data[prompt])
    end
    local data = SemiV3State.Data[prompt]
    if not data.ready then return end
    data.ready = false
    SemiV3State.isStealing = true
    SemiV3State.stealStartTime = tick()
    task.spawn(function()
        local fired = false
        local ok, err = pcall(function()
            sv3FireHold(data)
            task.wait(SemiV3State.HalfHoldMin)
            local lastWasInRange = sv3PromptDist(prompt) <= SemiV3State.HalfFireRange
            while true do
                local el = tick() - SemiV3State.stealStartTime
                if el > SemiV3State.HalfHoldMax or not prompt.Parent then break end
                setProgress(math.clamp(el / SemiV3State.HalfHoldMax, 0, 1))
                local nowInRange = sv3PromptDist(prompt) <= SemiV3State.HalfFireRange
                local firedNow = false
                if nowInRange then
                    if lastWasInRange then
                        firedNow = true
                    else
                        task.wait(0.3)
                        if sv3PromptDist(prompt) <= SemiV3State.HalfFireRange and prompt.Parent then
                            firedNow = true
                        else
                            lastWasInRange = false
                            task.wait()
                        end
                    end
                    if firedNow then
                        sv3FireTrigger(prompt, data)
                        fired = true
                        break
                    end
                else
                    lastWasInRange = nowInRange
                    task.wait()
                end
            end
        end)
        if not ok then warn("[polmhub] steal error: " .. tostring(err)) end
        if fired then setProgress(1) end
        task.wait(0.05)
        setProgress(0)
        -- Always unlock, even if something above threw.
        data.ready = true
        SemiV3State.isStealing = false
    end)
end
local function startSemiV3Mode()
    if SemiV3State.conn then pcall(function() SemiV3State.conn:Disconnect() end); SemiV3State.conn = nil end
    SemiV3State.isStealing = false
    SemiV3State.conn = RunService.Heartbeat:Connect(function()
        if not isEnabled then return end
        local now = tick()
        -- Watchdog: if a steal ever gets stuck (error inside a captured
        -- connection etc.), force-unlock the engine so it never dies.
        if SemiV3State.isStealing then
            if SemiV3State.stealStartTime and (now - SemiV3State.stealStartTime) > (SemiV3State.HalfHoldMax + 3) then
                SemiV3State.isStealing = false
                for _, d in pairs(SemiV3State.Data) do d.ready = true end
                setProgress(0)
            end
            return
        end
        -- Throttle the world scan (no need to run it 60x per second).
        if now - (SemiV3State.lastScan or 0) < 0.2 then return end
        SemiV3State.lastScan = now
        local ok, p = pcall(sv3FindNearestPrompt)
        if not p and (now - (SemiV3State.lastFallbackScan or 0)) > 1.5 then
            SemiV3State.lastFallbackScan = now
            task.spawn(function()
                local ok2, p2 = pcall(sv3FindNearestPromptFallback)
                if ok2 then SemiV3State.lastFallbackResult = p2 end
            end)
        end
        if not p and SemiV3State.lastFallbackResult then
            local d = sv3PromptDist(SemiV3State.lastFallbackResult)
            if d <= Radii.SemiV3 then p = SemiV3State.lastFallbackResult end
        end
        if ok and p then pcall(sv3ExecuteSteal, p) end
    end)
end
local function stopSemiV3Mode()
    if SemiV3State.conn then pcall(function() SemiV3State.conn:Disconnect() end); SemiV3State.conn = nil end
    SemiV3State.isStealing = false
    setProgress(0)
end




local function stopAll()
    stopSemiV3Mode()
    setProgress(0)
end
local function startAll()
    if not isEnabled then return end
    startSemiV3Mode()
end

-- ============================================================
-- UI BRIDGE  (this was MISSING -> the "Instant Steal" toggle
-- button in the main GUI did nothing, and the Radius box too)
-- ============================================================
_G.YousefInstantSteal = {
    SetEnabled = function(v)
        isEnabled = (v == true)
        if isEnabled then startAll() else stopAll() end
        saveConfig()
    end,
    GetEnabled = function() return isEnabled end,
    SetRadius = function(v)
        local n = tonumber(v) or Radii.SemiV3
        n = math.clamp(math.floor(n + 0.5), 1, 500)
        Radii.Normal = n
        Radii.Semi   = n
        Radii.SemiV2 = n
        Radii.SemiV3 = n
        saveConfig()
    end,
    GetRadius = function() return Radii.SemiV3 end,
    SetMode = function(m)
        -- Only the SemiV3 engine is implemented, so the engine always
        -- runs in SemiV3 regardless of what gets passed here.
        selectedMode = "SemiV3"
        if isEnabled then startAll() end
        saveConfig()
    end,
    GetMode = function() return "SemiV3" end,
}

startAll()
end) end)
-- end of insta steal
repeat task.wait() until game:IsLoaded()

Players, RunService, __HH.UIS, TS, Lighting, __HH.HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
LP = Players.LocalPlayer

__HH.antiRagdollEnabled, __HH.infJumpEnabled = false, false
__HH.medusaCounterEnabled = false
__HH.medusaResetEnabled = false
__HH.batCounterEnabled = false
__HH.unwalkEnabled = false
__HH.medusaDebounce, __HH.medusaLastUsed, __HH.dropActive = false, 0, false
Conns = {autoSteal = nil, antiRag = nil, batCounter = nil, anchor = {}}
__HH.tpLockEnabled = false
__HH.tpLockSetVisual = nil
__HH.mobBtnRefs = nil
__HH.batV2Enabled = false
__HH.batV2SetVisual = nil
__HH.antiDieEnabled = false
__HH.setAntiDieVisual = nil
__HH.antiDieConns = {}
__HH.setBatCounterVisual = nil
local startBatCounter, stopBatCounter
__HH.antiLagEnabled = false
__HH.removeAccessoriesEnabled = false
__HH.antiLagDescConn = nil
__HH.stretchRezEnabled = false
__HH.stretchRezConn = nil
__HH.setStretchRezVisual = nil

-- FRHUB Auto Left / Auto Right state, UI setters and controller functions.
-- Pure is already near Luau's 200-local limit, so these cross-script bridge
-- names are initialized explicitly while the implementation itself is scoped.
autoLeftEnabled, autoRightEnabled = false, false
autoLeftSetVisual, autoRightSetVisual = nil, nil
startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight = nil, nil, nil, nil
toggleAutoLeft, toggleAutoRight = nil, nil

__HH.unwalkSavedAnimate = nil
__HH._anyKeyListening = false
end
do
__HH._lastKbSet = 0
__HH.autoTPEnabled = false
__HH.autoTPHeight = 20
__HH.autoTPConn = nil
__HH.setAutoTPVisual = nil
__HH.setInfJumpVisual = nil
__HH.mainFrame = nil
__HH.bgImage = nil
local _guiLocked = false

setCarryVisual = nil
setLaggerVisual = nil
setAutoSwingVisual = nil
__HH.setBatCounterVisual = nil
setAntiRagVisual = nil
setMedusaVisual = nil
setMedusaResetVisual = nil
setUnwalkVisual = nil
setAntiLagVisual = nil
__HH.setStretchRezVisual = nil
__HH.setAutoTPVisual = nil
setSaturationVisual = nil
setVoidModeVisual = nil
setStretchRezV2Visual = nil
setTranspVisual = nil
setLockVisual = nil
setMobVisual = nil
setCircleBtnsVisual = nil
setShapeVisual = nil
setRectVisual = nil
__HH.setInfJumpVisual = nil

__HH.espEnabled = false
__HH.headlessEnabled = false
__HH.korbloxEnabled = false
__HH.setESPVisual = nil

uiScaleValue = 0.6
__HH.uiScaleObject = nil

__HH.TOGGLE_ON_COLOR = Color3.fromRGB(198, 134, 255)
__HH.TOGGLE_OFF_COLOR = Color3.fromRGB(80, 36, 120)

-- ============================================
-- FR Hub NEW AIMBOT (replaces Pure/Cursed aimbot engine).
if type(aimbotV1Speed) ~= "number" then aimbotV1Speed = 56 end
if type(batAimMode) ~= "string" or (batAimMode ~= "normal" and batAimMode ~= "bypass") then batAimMode = "normal" end
autoBatEnabled = autoBatEnabled == true
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local GRAVITY = -196.2

    local _hCache = setmetatable({}, {__mode = "k"})
    local _vCache = setmetatable({}, {__mode = "k"})

    local function _destroyH(part)
        local c = _hCache[part]
        if c then
            pcall(function() if c[1] and c[1].Parent then c[1]:Destroy() end end)
            pcall(function() if c[2] and c[2].Parent then c[2]:Destroy() end end)
            _hCache[part] = nil
        end
    end
    local function _destroyV(part)
        local c = _vCache[part]
        if c then
            pcall(function() if c[1] and c[1].Parent then c[1]:Destroy() end end)
            pcall(function() if c[2] and c[2].Parent then c[2]:Destroy() end end)
            _vCache[part] = nil
        end
    end
    local function _destroyLV(part)
        _destroyH(part)
        _destroyV(part)
    end
    local function _getHLV(part)
        local c = _hCache[part]
        local lv = c and c[1]
        if lv and lv.Parent == part then return lv end
        _destroyH(part)
        local att = Instance.new("Attachment"); att.Parent = part
        lv = Instance.new("LinearVelocity")
        lv.Attachment0 = att
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
        lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
        lv.MaxForce = math.huge
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.PlaneVelocity = Vector2.zero
        lv.Parent = part
        _hCache[part] = {lv, att}
        return lv
    end
    local function _getVLV(part)
        local c = _vCache[part]
        local lv = c and c[1]
        if lv and lv.Parent == part then return lv end
        _destroyV(part)
        local att = Instance.new("Attachment"); att.Parent = part
        lv = Instance.new("LinearVelocity")
        lv.Attachment0 = att
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.MaxForce = math.huge
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VectorVelocity = Vector3.zero
        lv.Parent = part
        _vCache[part] = {lv, att}
        return lv
    end
    local function _setV(part, vec)
        if not part or not part.Parent then return end
        if vec.Magnitude < 0.01 then
            _destroyLV(part)
            return
        end
        if math.abs(vec.Y) < 0.01 then
            _destroyV(part)
            local lv = _getHLV(part)
            lv.PlaneVelocity = Vector2.new(vec.X, vec.Z)
        else
            _destroyH(part)
            local lv = _getVLV(part)
            lv.VectorVelocity = vec
        end
    end
    local function _getV(part)
        if not part or not part.Parent then return Vector3.zero end
        return part.AssemblyLinearVelocity
    end

    local newAimEnabled = false
    local newBatEquippedThisRun = false
    local _aimbotTarget = nil
    local _aimbotTargetPlr = nil
    local _jumpHistory = {}
    local _infiniteJumpDetected = false
    local _tpDownDetected = false
    local _peakY = 0
    local _normalModeTimer = 0
    local _lastTargetY = 0

    local function getAimSpeed()
        local n = tonumber(aimbotV1Speed) or 56
        return math.clamp(n, 1, 200)
    end

    local function findBat()
        local char = LP.Character
        if not char then return nil end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                    return tool
                end
            end
        end
        return nil
    end

    local function getClosestTarget()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil, math.huge end
        local closest, closestPlr, minDist = nil, nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local dist = (tRoot.Position - root.Position).Magnitude
                    if dist < minDist then minDist = dist; closest = tRoot; closestPlr = plr end
                end
            end
        end
        return closest, closestPlr, minDist
    end

    local function getStickyTarget(currentRoot)
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil end
        local newClosest, newPlr, newDist = getClosestTarget()
        if not newClosest then return nil, nil end
        if currentRoot and currentRoot.Parent then
            local currentPlr = Players:GetPlayerFromCharacter(currentRoot.Parent)
            local hum = currentRoot.Parent:FindFirstChildOfClass("Humanoid")
            if currentPlr and hum and hum.Health > 0 then
                local currentDist = (currentRoot.Position - root.Position).Magnitude
                if currentPlr == newPlr or newDist > currentDist * 0.7 then
                    return currentRoot, currentPlr
                end
            end
        end
        return newClosest, newPlr
    end

    local function swingCurrentBat(char)
        local bat = findBat()
        if bat and bat.Parent == char and bat:IsA("Tool") then
            pcall(function() bat:Activate() end)
        end
    end

    local function detectInfiniteJumpGeneric(targetHRP, hist, infDetected, tpDetected, peakY, normalTimer, lastY)
        if not targetHRP then
            return "normal", {}, false, false, 0, 0, 0
        end
        local velY = targetHRP.Velocity.Y
        local posY = targetHRP.Position.Y
        if posY > peakY then peakY = posY end
        table.insert(hist, velY)
        if #hist > 12 then table.remove(hist, 1) end
        local upwardSpikes = 0
        for i = 2, #hist do
            if hist[i] > 0 and hist[i-1] < 0 then
                upwardSpikes = upwardSpikes + 1
            end
        end
        if upwardSpikes >= 0 and not infDetected then
            infDetected = true; peakY = posY; tpDetected = false
        end
        if infDetected and velY < -80 then
            tpDetected = true
            return "tp_down", hist, infDetected, tpDetected, peakY, normalTimer, posY
        end
        if infDetected and velY < -20 and (posY < peakY - 5) then
            return "falling", hist, infDetected, tpDetected, peakY, normalTimer, posY
        end
        if infDetected and math.abs(velY) < 5 and posY < lastY + 2 then
            normalTimer = normalTimer + 1
            if normalTimer > 8 then
                return "normal", {}, false, false, 0, 0, posY
            end
        else
            normalTimer = 0
        end
        lastY = posY
        if infDetected then
            return tpDetected and "tp_down" or "infinite_jump", hist, infDetected, tpDetected, peakY, normalTimer, lastY
        end
        return "normal", hist, infDetected, tpDetected, peakY, normalTimer, lastY
    end

    local function computePredictedPos(myHRP, targetHRP, mode)
        local curPos = targetHRP.Position
        local curVel = _getV(targetHRP)
        if mode == "tp_down" then
            local landX = curPos.X + curVel.X * 0.5
            local landZ = curPos.Z + curVel.Z * 0.5
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LP.Character}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(Vector3.new(landX, curPos.Y, landZ), Vector3.new(0, -200, 0), rp)
            local groundY = rr and rr.Position.Y or curPos.Y
            return Vector3.new(landX, groundY + 0.5, landZ)
        elseif mode == "infinite_jump" then
            return curPos + Vector3.new(curVel.X * 0.175, -2, curVel.Z * 0.175)
        elseif mode == "falling" then
            local deltaY = curVel.Y * 0.22
            local disc = curVel.Y * curVel.Y - 2 * GRAVITY * math.abs(deltaY)
            local ballT = disc > 0 and ((-curVel.Y - math.sqrt(disc)) / (-GRAVITY)) or 0.18
            ballT = math.clamp(ballT, 0.04, 0.55)
            return Vector3.new(
                curPos.X + curVel.X * ballT,
                curPos.Y + curVel.Y * ballT + 0.5 * GRAVITY * ballT * ballT + 2.8,
                curPos.Z + curVel.Z * ballT
            )
        else
            local myPos = myHRP.Position
            local targetPos = targetHRP.Position
            local distance = (targetPos - myPos).Magnitude
            local speedFactor = math.clamp(curVel.Magnitude / 40, 0, 1.2)
            local distFactor = math.clamp(distance / 80, 0, 1)
            local leadTime = 0.14 + speedFactor * 0.12 + distFactor * 0.08
            local predictPos = targetPos + curVel * leadTime
            predictPos = predictPos + targetHRP.CFrame.LookVector * 0.3
            return predictPos
        end
    end

    local function enableNewAim()
        newAimEnabled = true
        newBatEquippedThisRun = false
        _jumpHistory = {}; _infiniteJumpDetected = false; _tpDownDetected = false
        _peakY = 0; _normalModeTimer = 0; _lastTargetY = 0
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = false end
    end

    local function disableNewAim()
        newAimEnabled = false
        newBatEquippedThisRun = false
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp then _destroyLV(hrp); hrp.AssemblyAngularVelocity = Vector3.zero end
        if hum then hum.AutoRotate = true end
    end

    local function setAutoBatState(enabled)
        if enabled then
            if _G.PolmStealModes then _G.PolmStealModes.Suspend() end
            if __HH.stopBodyLock then __HH.stopBodyLock() end
        else
            if _G.PolmStealModes then _G.PolmStealModes.Resume() end
            if __HH.bodyLockEnabled and __HH.startBodyLock then task.delay(0.2, __HH.startBodyLock) end
        end
        if batAimMode == "bypass" then
            if enabled then
                disableNewAim()
                if _G.HHGoodAimSet then _G.HHGoodAimSet(true) end
            else
                if _G.HHGoodAimSet then _G.HHGoodAimSet(false) end
            end
        else
            if enabled then
                if _G.HHGoodAimSet then _G.HHGoodAimSet(false) end
                enableNewAim()
            else
                disableNewAim()
            end
        end
    end

    -- MIRROR TP DOWN (ported from FR HUB and adapted to Pure's AIM BOT).
    -- It watches Pure's current sticky target and mirrors any sudden 3-stud
    -- downward move by placing the local root at Pure's TP DOWN level.
    do
        local MIRROR_TP_DROP_THRESHOLD = 3
        local MIRROR_TP_DOWN_Y = -7.00
        local mirrorEnabled = false
        local mirrorTrackedRoot = nil
        local mirrorPreviousY = nil
        local mirrorLastTeleport = 0
        local mirrorHeartbeat = nil
        local mirrorCharacterConn = nil

        local function clearMirrorTracking()
            mirrorTrackedRoot = nil
            mirrorPreviousY = nil
        end

        local function getPureAimTarget()
            if not newAimEnabled then return nil end
            local target = _aimbotTarget
            if not target or not target.Parent then return nil end
            local targetHumanoid = target.Parent:FindFirstChildOfClass("Humanoid")
            if not targetHumanoid or targetHumanoid.Health <= 0 then return nil end
            return target
        end

        local function mirrorTeleportDown()
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not root or not humanoid or humanoid.Health <= 0 then return end

            local now = tick()
            if now - mirrorLastTeleport < 0.08 then return end
            mirrorLastTeleport = now

            local _, yaw = root.CFrame:ToEulerAnglesYXZ()
            root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z)
                * CFrame.Angles(0, yaw, 0)

            -- Use Pure's own AIM BOT LinearVelocity cleanup, matching FR's
            -- shared-velocity behavior without writing HRP.Velocity directly.
            _setV(root, Vector3.zero)
            root.AssemblyAngularVelocity = Vector3.zero
        end

        local function setMirrorEnabled(on)
            mirrorEnabled = on == true
            if not mirrorEnabled then clearMirrorTracking() end
            if _G.PureMirrorTPDownSetVisual then
                pcall(_G.PureMirrorTPDownSetVisual, mirrorEnabled)
            end
            return mirrorEnabled
        end

        pcall(function()
            if _G.PureMirrorTPDown and _G.PureMirrorTPDown.Destroy then
                _G.PureMirrorTPDown.Destroy()
            end
        end)

        mirrorHeartbeat = RunService.Heartbeat:Connect(function()
            if not mirrorEnabled then
                clearMirrorTracking()
                return
            end

            local target = getPureAimTarget()
            if not target then
                clearMirrorTracking()
                return
            end

            local currentY = target.Position.Y
            if target ~= mirrorTrackedRoot then
                mirrorTrackedRoot = target
                mirrorPreviousY = currentY
                return
            end

            local previousY = mirrorPreviousY
            mirrorPreviousY = currentY
            if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
                mirrorTeleportDown()
                mirrorPreviousY = target.Parent and target.Position.Y or nil
            end
        end)

        mirrorCharacterConn = LP.CharacterAdded:Connect(clearMirrorTracking)

        _G.PureMirrorTPDown = {
            enabled = function() return mirrorEnabled end,
            setEnabled = setMirrorEnabled,
            getTarget = getPureAimTarget,
            Destroy = function()
                mirrorEnabled = false
                clearMirrorTracking()
                if mirrorHeartbeat then mirrorHeartbeat:Disconnect(); mirrorHeartbeat = nil end
                if mirrorCharacterConn then mirrorCharacterConn:Disconnect(); mirrorCharacterConn = nil end
            end,
        }
    end

    RunService.RenderStepped:Connect(function()
        if not newAimEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

        if not newBatEquippedThisRun then
            newBatEquippedThisRun = true
            if not char:FindFirstChildOfClass("Tool") then
                local bat = findBat()
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end

        local target, targetPlr = getStickyTarget(_aimbotTarget)
        if not target then
            _aimbotTarget = nil
            _lastTargetY = 0
            swingCurrentBat(char)
            return
        end
        _aimbotTarget = target
        _aimbotTargetPlr = targetPlr

        local mode
        mode, _jumpHistory, _infiniteJumpDetected, _tpDownDetected, _peakY, _normalModeTimer, _lastTargetY =
            detectInfiniteJumpGeneric(target, _jumpHistory, _infiniteJumpDetected, _tpDownDetected, _peakY, _normalModeTimer, _lastTargetY)

        local predictPos = computePredictedPos(root, target, mode)

        local direction = predictPos - root.Position
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 0) end

        local desiredHeight = predictPos.Y
        if mode == "normal" then
            local jumpOffset = math.max(0, _getV(target).Y * 0.18)
            desiredHeight = predictPos.Y + 3.7 + jumpOffset
        end

        local yVel = (desiredHeight - root.Position.Y) * 22 + _getV(target).Y * 1.1
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 135)

        local spd = getAimSpeed()
        local desiredVel = Vector3.new(flatDir.X * spd, yVel, flatDir.Z * spd)
        _setV(root, _getV(root):Lerp(desiredVel, 0.85))

        local rotPredictTime = math.clamp(_getV(target).Magnitude / 120, 0.05, 0.25)
        local rotPredictedPos = target.Position + _getV(target) * rotPredictTime
        local toPredict = rotPredictedPos - root.Position
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(root.Position, rotPredictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 50, ry * 50, rz * 50))
        end

        swingCurrentBat(char)
    end)

    RunService.RenderStepped:Connect(function()
        if not newAimEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local v = _getV(root)
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
            _setV(root, Vector3.new(0, v.Y, 0))
        end
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        newBatEquippedThisRun = false
        _jumpHistory = {}; _infiniteJumpDetected = false; _tpDownDetected = false
        _peakY = 0; _normalModeTimer = 0; _lastTargetY = 0
        _aimbotTarget = nil
        if newAimEnabled then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = false end
        end
    end)

    -- Raw AIM BOT backend. Anti Kick only performs temporary Timer suppression.
    _G.PureCursedSetAimbot = setAutoBatState
    _G.PureCursedGetAimbot = function()
        if batAimMode == "bypass" then
            return (_G.HHGoodAimGet and _G.HHGoodAimGet()) or false
        end
        return newAimEnabled
    end
    _G.PureCursedClearAimVelocity = function()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if batAimMode == "bypass" then
            root.Velocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        else
            _destroyLV(root)
        end
    end
    function toggleBatV2()
        local turningOn = not __HH.batV2Enabled
        _G.PureDropThenAimSafeModeAuthorized = false
        __HH.batV2Enabled = turningOn
        setAutoBatState(__HH.batV2Enabled)
        if __HH.batV2SetVisual then __HH.batV2SetVisual(__HH.batV2Enabled) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(__HH.batV2Enabled) end
        return __HH.batV2Enabled
    end
    function stopAimbotFull()
        __HH.batV2Enabled = false
        setAutoBatState(false)
        if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(false) end
    end
    function queueAutoBatStart()
        if not __HH.batV2Enabled then __HH.batV2Enabled = true end
        setAutoBatState(true)
    end
    function stopBatAimbot()
        setAutoBatState(false)
    end
    -- TP BAT (ported from M10RU TP BAT — exact behavior)
    local tpBatActive = false
    local tpBatHeartbeat = nil
    local tpBatHittingCooldown = false

    local function getBatTP()
        local char = LP.Character
        if not char then return nil end
        local tool = char:FindFirstChild("Bat")
        if tool then return tool end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            tool = bp:FindFirstChild("Bat")
            if tool then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(tool) end) end
                return tool
            end
        end
        return nil
    end

    local function tryHitBatTP()
        if tpBatHittingCooldown then return end
        tpBatHittingCooldown = true
        pcall(function()
            local bat = getBatTP()
            if bat then
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
            end
        end)
        task.delay(0.08, function()
            tpBatHittingCooldown = false
        end)
    end

    local function getClosestPlayerTP()
        local char = LP.Character
        if not char then return nil, math.huge end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, math.huge end
        local closest, minDist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    local d = (hrp.Position - tr.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = p
                    end
                end
            end
        end
        return closest, minDist
    end

    local function tpBatTick()
        if not tpBatActive then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local target = getClosestPlayerTP()
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
                end
                local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                if (hrp.Position - targetPos).Magnitude > 8 then
                    hrp.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                end
                tryHitBatTP()
            end
        end
    end

    function startTPLock()
        if tpBatActive then return end

        -- Polm integration: turn off AIM BOT / Auto Left / Auto Right first (unrelated to M10RU logic below)
        if __HH.batV2Enabled and toggleBatV2 then pcall(toggleBatV2) end
        if autoLeftEnabled and stopAutoLeft then
            autoLeftEnabled = false
            pcall(stopAutoLeft)
        end
        if autoRightEnabled and stopAutoRight then
            autoRightEnabled = false
            pcall(stopAutoRight)
        end

        if _G.PolmStealModes then _G.PolmStealModes.Suspend() end
        if __HH.stopBodyLock then __HH.stopBodyLock() end
        tpBatActive = true
        __HH.tpLockEnabled = true
        __HH.antiVoidTPBat = true
        __HH._tpBatOldAntiDie = __HH.antiDieEnabled
        __HH.antiDieEnabled = true
        if __HH.startAntiDie then __HH.startAntiDie() end
        if tpBatHeartbeat then tpBatHeartbeat:Disconnect() end
        tpBatHeartbeat = RunService.Heartbeat:Connect(tpBatTick)

        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(true) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(true) end
        return true
    end

    function stopTPLock()
        if not tpBatActive then return end
        tpBatActive = false
        __HH.tpLockEnabled = false
        __HH.antiVoidTPBat = false
        if __HH._tpBatOldAntiDie ~= nil then
            __HH.antiDieEnabled = __HH._tpBatOldAntiDie
            if __HH.antiDieEnabled and __HH.startAntiDie then __HH.startAntiDie() elseif __HH.stopAntiDie then __HH.stopAntiDie() end
            __HH._tpBatOldAntiDie = nil
        end
        if _G.PolmStealModes then _G.PolmStealModes.Resume() end
        if __HH.bodyLockEnabled and __HH.startBodyLock then task.delay(0.2,__HH.startBodyLock) end

        if tpBatHeartbeat then
            tpBatHeartbeat:Disconnect()
            tpBatHeartbeat = nil
        end
        do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and sethiddenproperty then
                pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", nil) end)
            end
        end

        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(false) end
    end

    function toggleTPLock()
        if tpBatActive then
            stopTPLock()
        else
            startTPLock()
        end
        return __HH.tpLockEnabled
    end

    _G.PureTPBatV4Start = startTPLock
    _G.PureTPBatV4Stop = stopTPLock
    _G.PureTPBatV4Toggle = toggleTPLock

end


do
-- ============ FR "GOOD AIMBOT" (BYPASSES ALL ANTI BAT) ============
-- Ported from FR's merged aimbots: destroys every anti-bat lock
-- (LockBAV / LockAngVel / BatLock / ...) each heartbeat, drives rotation
-- through its own AngularVelocity (_GB_AngV) and moves with raw Velocity.
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer

    local GOOD_CFG = { SPEED = 58, VERT_SPEED = 58, LOOK_OFFSET = 5, antiLaggerMode = false, SPEED_LIMIT = 60 }
    local GOOD_TURN_SPEED = 40
    local GOOD_MAX_TURN   = 28

    local goodEnabled         = false
    local goodEquippedThisRun = false
    local goodAngVelc         = nil
    local goodAngVelcAtt      = nil
    local _goodIntendedVel    = Vector3.zero
    local _goodTarget         = nil

    local _tpDownLastY     = 0
    local _tpDownTracked    = nil
    local _tpDownCooldown   = false

    local DETECT_NAMES = {"LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt","AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"}

    local function purgeHRP(hrp)
        if not hrp then return end
        pcall(function()
            for _, n in ipairs(DETECT_NAMES) do
                local o = hrp:FindFirstChild(n)
                if o then o:Destroy() end
            end
            for _, c in ipairs(hrp:GetChildren()) do
                local low = c.Name:lower()
                if c.Name ~= "_GB_AngV" and c.Name ~= "_GB_Att"
                and (low:find("lockb") or low:find("lockangv") or low:find("batlock") or low:find("antiaim") or low:find("velocitylock")) then
                    pcall(function() c:Destroy() end)
                end
            end
        end)
    end

    local function setupGoodAngVelc(hrp)
        pcall(function()
            local o1 = hrp:FindFirstChild("_GB_AngV")
            local o2 = hrp:FindFirstChild("_GB_Att")
            if o1 then o1:Destroy() end
            if o2 then o2:Destroy() end
        end)
        local att = Instance.new("Attachment"); att.Name = "_GB_Att"; att.Parent = hrp
        local av = Instance.new("AngularVelocity")
        av.Name = "_GB_AngV"; av.Attachment0 = att
        av.RelativeTo = Enum.ActuatorRelativeTo.World
        av.MaxTorque = math.huge; av.AngularVelocity = Vector3.zero; av.Parent = hrp
        goodAngVelcAtt = att; goodAngVelc = av
    end

    local function cleanGoodAngVelc()
        pcall(function() if goodAngVelc    and goodAngVelc.Parent    then goodAngVelc:Destroy()    end end)
        pcall(function() if goodAngVelcAtt and goodAngVelcAtt.Parent then goodAngVelcAtt:Destroy() end end)
        goodAngVelc = nil; goodAngVelcAtt = nil
    end

    local function goodEnable()
        goodEquippedThisRun = false; goodEnabled = true; _goodIntendedVel = Vector3.zero
        local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then purgeHRP(hrp); setupGoodAngVelc(hrp) end
    end

    local function goodDisable()
        goodEnabled = false; goodEquippedThisRun = false
        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hrp then hrp.Velocity = hrp.Velocity * 0.3; purgeHRP(hrp) end
        if hum then hum.AutoRotate = true end
        if goodAngVelc then pcall(function() goodAngVelc.AngularVelocity = Vector3.zero end) end
        cleanGoodAngVelc()
    end

    local function detectTPDown()
        local target = _goodTarget
        if not target or not target.Parent then
            _tpDownLastY = 0; _tpDownTracked = nil
            return false
        end
        if _tpDownTracked ~= target then
            _tpDownTracked = target; _tpDownLastY = target.Position.Y
            return false
        end
        local y = target.Position.Y
        local drop = _tpDownLastY - y
        _tpDownLastY = y
        local velY = target.Velocity.Y
        return (drop > 20) or (drop > 8 and velY < -80)
    end

    local function executeTPDownCounter()
        if _tpDownCooldown then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local filterList = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then table.insert(filterList, plr.Character) end
        end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = filterList
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = false
        local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), rayParams)
        if rayResult then
            _tpDownCooldown = true
            hrp.Velocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
            task.delay(0.05, function() _tpDownCooldown = false end)
        end
    end

    RunService.Heartbeat:Connect(function()
        if not goodEnabled then return end
        local char = LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then return end
        purgeHRP(root)
        pcall(function()
            if _G and _G.FR_State then
                _G.FR_State.antiBatEnabled = false; _G.FR_State.bypassAntiBatEnabled = false
            end
        end)
        if detectTPDown() then executeTPDownCounter() end
        if not goodAngVelc or not goodAngVelc.Parent then setupGoodAngVelc(root) end
        if not goodEquippedThisRun then
            goodEquippedThisRun = true
            if not char:FindFirstChildOfClass("Tool") then
                local bp  = LP:FindFirstChild("Backpack")
                local bat = bp and bp:FindFirstChild("Bat")
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end
        local closestTR, closestDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                local h2 = plr.Character:FindFirstChildOfClass("Humanoid")
                if tr and h2 and h2.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d < closestDist then closestDist = d; closestTR = tr end
                end
            end
        end
        if closestTR then
            if _goodTarget ~= closestTR then _goodTarget = closestTR end
            local _vs     = closestTR.Velocity.Magnitude
            local _dynOff = _vs < 0.1 and 1.5 or GOOD_CFG.LOOK_OFFSET
            local fp      = closestTR.Position + closestTR.CFrame.LookVector * _dynOff
            local look    = fp - root.Position
            local flatLook = Vector3.new(look.X, 0, look.Z)
            hum.AutoRotate = false
            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local tYaw  = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawD  = (tYaw - root.Orientation.Y + 180) % 360 - 180
                local tPit  = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                local pitD  = (tPit - root.Orientation.X + 180) % 360 - 180
                local yawR  = math.clamp(math.rad(yawD) * GOOD_TURN_SPEED, -GOOD_MAX_TURN, GOOD_MAX_TURN)
                local pitR  = math.clamp(math.rad(pitD) * GOOD_TURN_SPEED, -GOOD_MAX_TURN, GOOD_MAX_TURN)
                local yRad  = math.rad(root.Orientation.Y)
                local rAxis = Vector3.new(math.cos(yRad), 0, -math.sin(yRad))
                goodAngVelc.AngularVelocity = Vector3.new(0, yawR, 0) + (rAxis * pitR)
            else
                goodAngVelc.AngularVelocity = Vector3.zero
            end
            local mDir = fp - root.Position
            local hDir = Vector3.new(mDir.X, 0, mDir.Z)

            local effectiveSpeed = GOOD_CFG.SPEED
            if GOOD_CFG.antiLaggerMode then
                local targetHorizSpeed = Vector3.new(closestTR.Velocity.X, 0, closestTR.Velocity.Z).Magnitude
                if targetHorizSpeed < 30 then
                    effectiveSpeed = 30
                else
                    effectiveSpeed = math.min(GOOD_CFG.SPEED_LIMIT, targetHorizSpeed)
                end
            end

            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * effectiveSpeed or Vector3.zero
            local vVel = math.abs(mDir.Y) > 0.8
                and Vector3.new(0, math.sign(mDir.Y) * GOOD_CFG.VERT_SPEED, 0)
                or  Vector3.new(0, -2, 0)
            _goodIntendedVel = hVel + vVel; root.Velocity = _goodIntendedVel
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
            if closestDist <= 5 then
                local bat = char:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then
                    pcall(function()
                        bat:Activate()
                        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then ev:FireServer() end
                    end)
                end
            end
        else
            _goodTarget = nil
            hum.AutoRotate = true
            if goodAngVelc then pcall(function() goodAngVelc.AngularVelocity = Vector3.zero end) end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not goodEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local v = root.Velocity
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then root.Velocity = _goodIntendedVel end
        purgeHRP(root)
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        goodEquippedThisRun = false
        _tpDownLastY = 0; _tpDownTracked = nil
        _goodTarget = nil
        if goodEnabled then
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then purgeHRP(hrp); setupGoodAngVelc(hrp) end
        end
    end)

    _G.HHGoodAimSet   = function(on) if on then goodEnable() else goodDisable() end end
    _G.HHGoodAimGet   = function() return goodEnabled end
    _G.HHGoodAimPurge = purgeHRP
    _G.HHGoodAimCfg   = GOOD_CFG
end

-- BAT SPAM (ported from FR HUB).
-- Uses FR's activation loop, close-range double swing and watchdog behavior.
do
    local S = {enabled=false, thread=nil, delay=50, watchdog=nil}

    local function getEquippedBat()
        local character = LP.Character
        if not character then return nil end
        local bat = character:FindFirstChild("bat") or character:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") and bat.Parent == character then return bat end
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat") or name:find("slap") then return tool end
            end
        end
        return nil
    end

    local function getNearestDistance(root)
        local nearest = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                    local distance = (targetRoot.Position - root.Position).Magnitude
                    if distance < nearest then nearest = distance end
                end
            end
        end
        return nearest
    end

    local function runSpamLoop()
        if S.thread then return end
        S.thread = task.spawn(function()
            while S.enabled do
                pcall(function()
                    local character = LP.Character
                    local bat = getEquippedBat()
                    if character and bat then
                        bat:Activate()
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root and getNearestDistance(root) < 6 then
                            task.wait(0.02)
                            if bat.Parent == character then bat:Activate() end
                        end
                    end
                end)
                task.wait(S.delay / 1000)
            end
            S.thread = nil
        end)
    end

    local function startBatSpam()
        S.enabled = true
        runSpamLoop()
        if not S.watchdog then
            S.watchdog = task.spawn(function()
                while S.enabled do
                    task.wait(0.6)
                    if S.enabled and not S.thread then runSpamLoop() end
                end
                S.watchdog = nil
            end)
        end
    end

    local function stopBatSpam()
        S.enabled = false
        if S.thread then pcall(task.cancel, S.thread); S.thread = nil end
        if S.watchdog then pcall(task.cancel, S.watchdog); S.watchdog = nil end
    end

    local function setBatSpamEnabled(on)
        if on == true then startBatSpam() else stopBatSpam() end
        if _G.PureBatSpamSetVisual then pcall(_G.PureBatSpamSetVisual, S.enabled) end
        return S.enabled
    end

    pcall(function()
        if _G.PureBatSpam and _G.PureBatSpam.Destroy then _G.PureBatSpam.Destroy() end
    end)

    _G.PureBatSpam = {
        enabled = function() return S.enabled end,
        setEnabled = setBatSpamEnabled,
        Destroy = function() stopBatSpam() end,
    }
end

__HH.guiTransparencyEnabled = false
__HH.selectedDevice = nil -- "PC" | "MOBILE" | "CONTROLLER" (set by the device picker / Reset Device)
__HH.mobileButtonsEnabled = true
__HH.mobileButtonsSize = 80
__HH.circleButtonsEnabled = false
__HH.shapeButtonsEnabled = false
__HH.rectangularButtonsEnabled = false
__HH.mobBtnRefs = {}
local apExtSetLeft  = nil   -- visual updater for external LEFT btn
local apExtSetRight = nil   -- visual updater for external RIGHT btn
-- Mobile tab: per-button visibility (true = show, false = hidden)
__HH.buttonVisibility = {
    drop=true, tpDown=true, batV1=true, batV2=true, tpLock=true,
    lagger=true, laggerCarry=true, carrySpeed=true,
    instaReset=true,
}
-- Auto drop + aimbot when TP BAT / BAT V2 enabled while carrying (always on)
local function refreshAPExtBtns()
    local COL_ON  = Color3.fromRGB(0, 130, 255)
    local COL_OFF = Color3.fromRGB(20, 28, 65)
    if apExtSetLeft  then apExtSetLeft (autoLeftEnabled and COL_ON or COL_OFF) end
    if apExtSetRight then apExtSetRight(autoRightEnabled and COL_ON or COL_OFF) end
end
__HH.mobGuiRef = nil
__HH.infJumpMode = "manual"
__HH.holdInfJumpConn = nil
__HH.uiLocked = false
__HH.perButtonDragEnabled = true

__HH.BTN_OFF = Color3.fromRGB(193, 122, 255)
__HH.BTN_ON = Color3.fromRGB(255, 105, 115)
__HH.TEXT_OFF = Color3.fromRGB(232, 205, 255)
__HH.TEXT_ON = Color3.fromRGB(232, 205, 255)

__HH.KB = {
    DropBrainrot  = {kb = Enum.KeyCode.X,           gp = nil},
    
    TPLock        = {kb = Enum.KeyCode.E,           gp = nil},
    TPFloor       = {kb = Enum.KeyCode.F,           gp = nil},
    GuiHide       = {kb = Enum.KeyCode.LeftControl, gp = nil},
    SpeedToggle   = {kb = Enum.KeyCode.Q,           gp = nil},
    -- Frame Reset uses its original R key. Lagger moves to the old reset key
    -- so the two actions never fire from the same keyboard input.
    LaggerToggle  = {kb = Enum.KeyCode.G,           gp = nil},
    InstaReset    = {kb = Enum.KeyCode.R,           gp = nil},
    AutoLeft      = {kb = Enum.KeyCode.Z,           gp = nil},
    AutoRight     = {kb = Enum.KeyCode.C,           gp = nil},
    BatV2Toggle   = {kb = Enum.KeyCode.V,           gp = nil}
}

__HH.isGamepadInput = function(inp)
    if not inp then return false end
    if inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") then return true end
    return false
end

__HH.isBindableInput = function(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return __HH.isGamepadInput(inp)
end

end
do
local CONTROLLER_BUTTONS = {
    [Enum.KeyCode.ButtonA]      = "A",       [Enum.KeyCode.ButtonB]      = "B",
    [Enum.KeyCode.ButtonX]      = "X",       [Enum.KeyCode.ButtonY]      = "Y",
    [Enum.KeyCode.ButtonL1]     = "LB",      [Enum.KeyCode.ButtonR1]     = "RB",
    [Enum.KeyCode.ButtonL2]     = "LT",      [Enum.KeyCode.ButtonR2]     = "RT",
    [Enum.KeyCode.ButtonL3]     = "LS",      [Enum.KeyCode.ButtonR3]     = "RS",
    [Enum.KeyCode.ButtonStart]  = "START",   [Enum.KeyCode.ButtonSelect] = "SELECT",
    [Enum.KeyCode.DPadUp]       = "DPAD_UP", [Enum.KeyCode.DPadLeft]     = "DPAD_LEFT",
    [Enum.KeyCode.DPadRight]    = "DPAD_RIGHT"
}

__HH.getKeyDisplayName = function(key, isGp)
    if isGp and CONTROLLER_BUTTONS[key] then return CONTROLLER_BUTTONS[key] end
    return key and key.Name or "None"
end

__HH.kbMatch = function(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local laggerState = {enabled = false, thread = nil, waitTime = 0.25, intensity = 270}
local isTouchEnabled = __HH.UIS.TouchEnabled
if isTouchEnabled then laggerState.waitTime = 5.8 end
local _laggerActive = false

local function createNestedTable(amount)
    local nested = {{}}; local current = nested[1]
    for i = 1, amount do local t = {}; table.insert(current, t); current = t end
    return nested
end

local function sendLagSpam()
    local nested = createNestedTable(laggerState.intensity)
    local payload = {}
    local maxCopies = math.min(499999 / (laggerState.intensity + 2), 1500)
    for i = 1, maxCopies do table.insert(payload, nested) end
    pcall(function()
        local r = game:GetService("RobloxReplicatedStorage"):FindFirstChild("SetPlayerBlockList")
        if r then r:FireServer(payload) end
    end)
end

local function removeNetworkLimit()
    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
end

local function startLaggerEngine()
    if laggerState.thread then task.cancel(laggerState.thread); laggerState.thread = nil end
    laggerState.enabled = true
    laggerState.thread = task.spawn(function()
        while laggerState.enabled do removeNetworkLimit(); sendLagSpam(); task.wait(laggerState.waitTime) end
    end)
end

local function stopLaggerEngine()
    laggerState.enabled = false
    if laggerState.thread then task.cancel(laggerState.thread); laggerState.thread = nil end
end

local AP_L1, AP_L2 = Vector3.new(-476.48,-6.28,92.73), Vector3.new(-483.12,-4.95,94.80)
local AP_R1, AP_R2 = Vector3.new(-476.16,-6.52,25.62), Vector3.new(-483.06,-5.03,25.48)

-- ============================================
-- ============================================
-- SPEED SYSTEM (LinearVelocity-based)
-- ============================================
NS = 60
CS = 30
LAGGER_SPEED = 13
LAGGER_CARRY_SPEED = 13

carrySpeedActive = false
laggerModeEnabled = false
laggerCarryToggled = false
laggerPhase = 0
speedMode = false
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil

local lastMoveDir = Vector3.new(0, 0, 0)
local MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true
}

local AutoCarry = {
    _autoCarryFromSteal = false,
    _autoCarryGraceUntil = 0,
    _waitingForCarryPickup = false,
    _carryPickupWatchUntil = 0,
    _autoCarryReturnMode = nil,
}

local _spdLV = nil
local _spdAtt = nil
local _vertAtt = nil
local _vertLV = nil
local _stealAttrWasActive = false

local function isCarryName(name)
    local n = tostring(name or ""):lower()
    return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold")
end

local function isIgnoredCarryTool(name)
    local n = tostring(name or ""):lower()
    return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone")
end

__HH.isCarryingBrainrot = function(char)
    if not char then return false end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end
            if isCarryName(child.Name) then return true end
        elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
            return true
        end
    end
    return false
end

function destroySpeedLV()
    if _spdLV and _spdLV.Parent then _spdLV:Destroy() end
    if _spdAtt and _spdAtt.Parent then _spdAtt:Destroy() end
    _spdLV, _spdAtt = nil, nil
end

local function setupSpeedLV(hrp)
    destroySpeedLV()
    _spdAtt = Instance.new("Attachment", hrp)
    _spdAtt.Name = "NovaHubSpeedAtt"
    _spdLV = Instance.new("LinearVelocity", hrp)
    _spdLV.Name = "NovaHubSpeedLV"
    _spdLV.Attachment0 = _spdAtt
    _spdLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    _spdLV.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    _spdLV.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    _spdLV.MaxForce = math.huge
    _spdLV.RelativeTo = Enum.ActuatorRelativeTo.World
end

function destroyVertLV()
    if _vertLV and _vertLV.Parent then _vertLV:Destroy() end
    if _vertAtt and _vertAtt.Parent then _vertAtt:Destroy() end
    _vertLV, _vertAtt = nil, nil
end

local function getVertLV(root)
    if not _vertLV or _vertLV.Parent ~= root then
        destroyVertLV()
        _vertAtt = Instance.new("Attachment", root)
        _vertLV = Instance.new("LinearVelocity", root)
        _vertLV.Attachment0 = _vertAtt
        _vertLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        _vertLV.MaxForce = math.huge
        _vertLV.RelativeTo = Enum.ActuatorRelativeTo.World
    end
    return _vertLV
end

local function driveHorizontal(root, dir, spd)
    if not dir or dir.Magnitude <= 0.1 then
        return
    end
    root.Velocity = Vector3.new(dir.X * spd, root.Velocity.Y, dir.Z * spd)
end

function drive3D(root, vel)
    local lv = getVertLV(root)
    lv.VectorVelocity = vel
end

local _nearBrainrotAt, _nearBrainrotValue = 0, false
local function isNearBrainrot(char)
    -- The actual stealable Brainrots have a ProximityPrompt, so detect the prompt itself
    -- instead of relying only on the model's display name.
    if tick() - _nearBrainrotAt < 0.15 then return _nearBrainrotValue end
    _nearBrainrotAt = tick(); _nearBrainrotValue = false
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local holder = obj.Parent
            local part = holder and (holder:IsA("BasePart") and holder or holder:FindFirstAncestorWhichIsA("BasePart"))
            if part and (part.Position - root.Position).Magnitude <= 11 then
                _nearBrainrotValue = true
                return true
            end
        end
    end
    return false
end

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

-- Auto Carry Speed Logic
local function setCarrySpeedMode(on)
    carrySpeedActive = on == true
    speedMode = on == true
end

local function enableCarrySpeedForSteal()
    AutoCarry._waitingForCarryPickup = false
    AutoCarry._carryPickupWatchUntil = 0
    if not AutoCarry._autoCarryFromSteal then
        -- Keep the selected speed family, so Lagger switches to Lagger Carry.
        AutoCarry._autoCarryReturnMode = laggerCarryToggled and "Lagger Carry"
            or (laggerModeEnabled and "Lagger")
            or (carrySpeedActive and "Carry")
            or "Normal"
    end
    AutoCarry._autoCarryFromSteal = true
    AutoCarry._autoCarryGraceUntil = tick() + 0.75

    if AutoCarry._autoCarryReturnMode == "Lagger" or AutoCarry._autoCarryReturnMode == "Lagger Carry" then
        laggerModeEnabled = false
        carrySpeedActive = false
        laggerCarryToggled = true
        laggerPhase = 2
        speedMode = false
    else
        setCarrySpeedMode(true)
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
end

local function disableAutoCarrySpeed()
    if not AutoCarry._autoCarryFromSteal and not AutoCarry._waitingForCarryPickup then return end
    local wasAutoApplied = AutoCarry._autoCarryFromSteal
    local returnMode = AutoCarry._autoCarryReturnMode
    AutoCarry._autoCarryFromSteal = false
    AutoCarry._waitingForCarryPickup = false
    if not wasAutoApplied then return end
    if returnMode == "Lagger Carry" then
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = false, true, false, false
        laggerPhase = 2
    elseif returnMode == "Lagger" then
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = true, false, false, false
        laggerPhase = 1
    elseif returnMode == "Carry" then
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = false, false, true, true
        laggerPhase = 0
    else
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = false, false, false, false
        laggerPhase = 0
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
end

-- Main Speed Loop (direct velocity)
RunService.RenderStepped:Connect(function()
    -- Auto carry speed detection
    if autoCarrySpeedEnabled then
        local aChar = LP.Character
        local aHum = aChar and aChar:FindFirstChildOfClass("Humanoid")
        if aChar and aHum then
            local gotHit = isRagdollState(aHum)
            local stealingAttr = LP:GetAttribute("Stealing") == true
            local nearBrainrot = isNearBrainrot(aChar)
            local carryingBrainrot = __HH.isCarryingBrainrot(aChar) or nearBrainrot
            -- Auto Switch Speed immediately enables Carry Speed as soon as a steal prompt is nearby.
            if nearBrainrot and not AutoCarry._autoCarryFromSteal then enableCarrySpeedForSteal() end
            if stealingAttr and not _stealAttrWasActive then
                _stealAttrWasActive = true
                enableCarrySpeedForSteal()
            elseif not stealingAttr then
                _stealAttrWasActive = false
            end
            if AutoCarry._waitingForCarryPickup then
                if gotHit or tick() > (AutoCarry._carryPickupWatchUntil or 0) then
                    AutoCarry._waitingForCarryPickup = false
                elseif carryingBrainrot then
                    enableCarrySpeedForSteal()
                end
            end
            if carryingBrainrot and not AutoCarry._autoCarryFromSteal then enableCarrySpeedForSteal() end
            if AutoCarry._autoCarryFromSteal then
                if gotHit or (tick() > AutoCarry._autoCarryGraceUntil and not carryingBrainrot and not stealingAttr) then
                    disableAutoCarrySpeed()
                end
            end
        end
    end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if isRagdollState(hum) then
        _G.PureRagdollKilledCarry = true
        lastMoveDir = Vector3.new(0, 0, 0)
        return
    end

    -- don't interfere with tpLock / batV2 / aimbot
    if __HH.tpLockEnabled or autoLeftEnabled or autoRightEnabled or __HH.batV2Enabled or autoBatEnabled or __HH.dropActive then
        return
    end

    local md = hum.MoveDirection
    local spd = getActiveMoveSpeed()
    local moving = false

    if md.Magnitude > 0 then
        lastMoveDir = md
        moving = true
        driveHorizontal(hrp, md, spd)
    elseif __HH.antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
        local anyHeld = false
        for key in pairs(MOVE_KEYS) do
            if __HH.UIS:IsKeyDown(key) then anyHeld = true; break end
        end
        if anyHeld then
            moving = true
            driveHorizontal(hrp, lastMoveDir, spd)
        end
    end

    -- when not moving, don't set velocity (matches YOUSEF67 approach)
end)

function toggleCarryMode()
    if laggerModeEnabled or laggerCarryToggled then
        laggerModeEnabled = false; laggerCarryToggled = false; laggerPhase = 0
        carrySpeedActive = true; speedMode = true
    else
        carrySpeedActive = not carrySpeedActive
        speedMode = carrySpeedActive
    end
    refreshSpeedModeLabel()
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    carrySpeedActive = false; speedMode = false
    laggerModeEnabled = not laggerModeEnabled
    laggerPhase = laggerModeEnabled and 1 or 0
    refreshSpeedModeLabel()
end

function toggleLaggerCarryMode()
    if laggerModeEnabled then laggerModeEnabled = false; laggerPhase = 0 end
    carrySpeedActive = false; speedMode = false
    laggerCarryToggled = not laggerCarryToggled
    if laggerCarryToggled then laggerPhase = 2 else laggerPhase = 0 end
    refreshSpeedModeLabel()
end

refreshSpeedModeLabel = function()
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text="Lagger Carry"
        elseif laggerModeEnabled then modeValLbl.Text="Lagger"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(205,232,255) or Color3.fromRGB(0,0,0),BackgroundTransparency=on and 0.4 or 0.85}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(205,232,255) or Color3.fromRGB(150,150,150)}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(205,232,255) or Color3.fromRGB(0,0,0),BackgroundTransparency=on and 0.4 or 0.85}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(205,232,255) or Color3.fromRGB(150,150,150)}):Play()
    end
    if __HH.mobBtnRefs and __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
    if __HH.mobBtnRefs and __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
    if __HH.mobBtnRefs and __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
end

-- ============ FR HUB ROUND 3 SPEED BOOST (add-on) ============
-- This is ONLY an addition on top of the Pure speed system.
-- Engine: direct Velocity like FR Hub. Normalized MoveDirection so the
-- full speed is reached even with a partial mobile joystick.
do
    local R3Boost = {
        enabled = false,
        carrySpeed = 32,
        normalSpeed = 62,
        forceCarry = false,
    }
    pcall(function()
        if not (isfile and readfile and isfile("Round3SpeedBooster6_Config.json")) then return end
        local raw = readfile("Round3SpeedBooster6_Config.json")
        local cfg = game:GetService("HttpService"):JSONDecode(raw)
        if type(cfg) == "table" then
            if type(cfg.carrySpeed) == "number" and cfg.carrySpeed > 0 then R3Boost.carrySpeed = cfg.carrySpeed end
            if type(cfg.normalSpeed) == "number" and cfg.normalSpeed > 0 then R3Boost.normalSpeed = cfg.normalSpeed end
        end
    end)

    local Bridge = {
        Enabled = R3Boost.enabled,
        NormalSpeed = R3Boost.normalSpeed,
        CarrySpeed = R3Boost.carrySpeed,
        CarryMode = false,
        ForceCarry = false,
        Force = true,
    }
    _G.Round3SpeedBooster = Bridge

    local function syncBridge()
        Bridge.Enabled = R3Boost.enabled
        Bridge.NormalSpeed = R3Boost.normalSpeed
        Bridge.CarrySpeed = R3Boost.carrySpeed
        Bridge.CarryMode = R3Boost.forceCarry
        Bridge.ForceCarry = R3Boost.forceCarry
    end
    local function saveR3()
        pcall(function()
            if writefile then
                writefile("Round3SpeedBooster6_Config.json", game:GetService("HttpService"):JSONEncode({
                    carrySpeed = R3Boost.carrySpeed,
                    normalSpeed = R3Boost.normalSpeed,
                }))
            end
        end)
    end
    Bridge.setNormalSpeed = function(value)
        value = tonumber(value)
        if not value or value <= 0 then return end
        R3Boost.normalSpeed = value
        syncBridge(); saveR3()
    end
    Bridge.setCarrySpeed = function(value)
        value = tonumber(value)
        if not value or value <= 0 then return end
        R3Boost.carrySpeed = value
        syncBridge(); saveR3()
    end
    Bridge.setForceCarry = function(on)
        R3Boost.forceCarry = on == true
        syncBridge()
    end
    Bridge.setEnabled = function(on)
        R3Boost.enabled = on == true
        if not R3Boost.enabled then R3Boost.forceCarry = false end
        syncBridge()
    end
    local function getR3BoostSpeed()
        if not R3Boost.enabled then return R3Boost.normalSpeed end
        return R3Boost.forceCarry and R3Boost.carrySpeed or R3Boost.normalSpeed
    end
    syncBridge()

    RunService.RenderStepped:Connect(function()
        if not R3Boost.enabled then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        -- let the other movement features own the player while they run
        if __HH.tpLockEnabled or autoLeftEnabled or autoRightEnabled or __HH.batV2Enabled or autoBatEnabled or __HH.dropActive then return end
        local md = hum.MoveDirection
        local spd = getR3BoostSpeed()
        if md.Magnitude > 0.01 then
            -- normalize: mobile joystick gives partial magnitude, which is
            -- why 62 used to feel like ~34. Unit vector = full speed.
            md = md.Unit
            hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
        else
            hrp.Velocity = Vector3.zero
        end
        if R3Boost.forceCarry ~= carrySpeedActive then
            carrySpeedActive = R3Boost.forceCarry
            speedMode = carrySpeedActive
            if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        end
    end)
end

-- R3-aware overrides: when the FR boost is enabled, the Pure velocity loop
-- and the CARRY SPD button drive the FR speeds instead of the Pure ones.
-- Wrapped in do..end so the chunk-level local limit (200) is untouched.
do
    local pureGet = getActiveMoveSpeed
    local pureToggleCarry = toggleCarryMode
    function getActiveMoveSpeed()
        local b = _G.Round3SpeedBooster
        if b and b.Enabled == true then
            return (b.ForceCarry == true) and b.CarrySpeed or b.NormalSpeed
        end
        return pureGet()
    end
    function toggleCarryMode()
        local b = _G.Round3SpeedBooster
        if b and b.Enabled == true then
            if b.setForceCarry then b.setForceCarry(not (b.ForceCarry == true)) end
            carrySpeedActive = (b.ForceCarry == true)
            speedMode = carrySpeedActive
            refreshSpeedModeLabel()
            return
        end
        pureToggleCarry()
    end
end

-- ============================================

-- ============================================================
-- ANTI RAGDOLL (VisDuels version)
-- ============================================================
do
    local visAntiConn = nil
    local visResetCooldown = 0

    local function visForceReset()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") then obj.Enabled = true end
                if obj:IsA("Constraint") then obj.Enabled = true end
            end
            if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end
            local ps = LP:FindFirstChild("PlayerScripts")
            local pm = ps and ps:FindFirstChild("PlayerModule")
            local cm = pm and pm:FindFirstChild("ControlModule")
            if cm then local controls = require(cm); if controls then controls:Enable() end end
            hum.AutoRotate = true
            hum.PlatformStand = false
            hum.Sit = false
        end)
    end

    __HH.stopAntiRagdoll = function()
        if visAntiConn then visAntiConn:Disconnect(); visAntiConn = nil end
    end

    __HH.startAntiRagdoll = function()
        __HH.stopAntiRagdoll()
        if not __HH.antiRagdollEnabled then return end
        visAntiConn = RunService.Heartbeat:Connect(function()
            if not __HH.antiRagdollEnabled then return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            local state = hum:GetState()
            local ragdolled = state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
            if ragdolled and tick() - visResetCooldown > 0.15 then
                visResetCooldown = tick()
                visForceReset()
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if __HH.antiRagdollEnabled then __HH.startAntiRagdoll() end
    end)
end

-- Instant Reset (Nexus Hub port from Lord Hub): camera-lock + collision strip +
-- HipHeight spike until respawn, hard-kill fallback. Replaces the old void-teleport reset.
end
do
__HH.FrameReset = {}
do
    -- Nexus Hub instant reset (ported from Lord Hub):
    -- camera lock + collision strip + giant HipHeight until respawn is
    -- detected, with a hard-kill fallback if the char refuses to die.
    local camLocked          = false
    local lockedCamCFrame    = nil
    local resetCooldown      = false
    local resetThread        = nil
    local resetStop          = false
    local respawnConn        = nil
    local runtimeAlive       = true
    local deathResetEnabled  = false
    local deathResetThread   = nil
    local INSTANT_RESET_STEP = 0.05

    local function ResetPlayer()
        if resetCooldown then return end
        resetCooldown = true
        resetStop = false
        camLocked = false

        -- Clear anti-die connections so the character can actually die/respawn.
        for _, conn in pairs(__HH.antiDieConns) do pcall(function() conn:Disconnect() end) end
        __HH.antiDieConns = {}

        local character = LP.Character
        if not character then
            resetCooldown = false
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            resetCooldown = false
            return
        end

        local camera = workspace.CurrentCamera
        if camera then
            lockedCamCFrame = camera.CFrame
            camLocked = true
            camera.CFrame = lockedCamCFrame
        end

        local ok = false
        local isRespawning = false

        resetThread = task.spawn(function()
            local attempts = 0
            local maxAttempts = 40
            local originalHipHeight = humanoid.HipHeight

            while character and character.Parent
                and humanoid and humanoid.Health > 0
                and not isRespawning
                and not resetStop do

                if LP.Character ~= character then
                    isRespawning = true
                    break
                end

                pcall(function()
                    humanoid.HipHeight = 1e30
                    humanoid.AutoRotate = true

                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CanCollide = false
                    end

                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end)

                if not character or not character.Parent
                    or not humanoid or humanoid.Health <= 0
                    or LP.Character ~= character then
                    ok = true
                    break
                end

                attempts = attempts + 1
                if attempts >= maxAttempts then break end
                task.wait(INSTANT_RESET_STEP)
            end

            if not ok
                and not resetStop
                and character and character.Parent
                and humanoid and humanoid.Health > 0
                and not isRespawning then

                pcall(function()
                    humanoid.Health = 0
                end)

                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    ok = true
                end
            end

            if not ok and character and character.Parent and humanoid then
                pcall(function()
                    humanoid.HipHeight = originalHipHeight

                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CanCollide = true
                    end

                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end)
            end

            camLocked = false
            resetCooldown = false
            resetThread = nil
            resetStop = false
        end)

        if respawnConn then respawnConn:Disconnect() end
        respawnConn = LP.CharacterAdded:Connect(function(newChar)
            if respawnConn then respawnConn:Disconnect(); respawnConn = nil end
            camLocked = false
            resetCooldown = false
            if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
            local newHum = newChar:WaitForChild("Humanoid", 3)
            pcall(function()
                if camera then
                    camera.CameraSubject = newHum
                    camera.CameraType = Enum.CameraType.Custom
                end
            end)
        end)
    end

    local function StopResetSequence()
        resetStop = true
        if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
        camLocked = false
        resetCooldown = false
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera
        if hum and cam then
            pcall(function() cam.CameraSubject = hum; cam.CameraType = Enum.CameraType.Custom end)
        end
    end

    -- camera lock (Nexus RenderStepped style)
    RunService.RenderStepped:Connect(function()
        if camLocked and lockedCamCFrame and workspace.CurrentCamera then
            workspace.CurrentCamera.CFrame = lockedCamCFrame
        end
    end)

    local function ToggleDeathReset(enable)
        deathResetEnabled = enable == true
        if deathResetEnabled and not deathResetThread then
            deathResetThread = task.spawn(function()
                local cooldown = 0
                while runtimeAlive and deathResetEnabled do
                    task.wait(0.1)
                    local char = LP.Character
                    if not char then
                        if tick() - cooldown > 2 then
                            cooldown = tick()
                            ResetPlayer()
                        end
                    else
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 and tick() - cooldown > 0 then
                            cooldown = tick()
                            ResetPlayer()
                            task.wait(0.1)
                        end
                    end
                end
                deathResetThread = nil
            end)
        elseif not deathResetEnabled and deathResetThread then
            task.cancel(deathResetThread)
            deathResetThread = nil
        end
    end

    __HH.FrameReset.ResetPlayer = ResetPlayer
    __HH.FrameReset.StopResetSequence = StopResetSequence
    __HH.FrameReset.ToggleDeathReset = ToggleDeathReset
    __HH.FrameReset.Destroy = function()
        runtimeAlive = false
        ToggleDeathReset(false)
        StopResetSequence()
    end
end

pcall(function()
    if _G.PureFrameReset and _G.PureFrameReset.Destroy then
        _G.PureFrameReset.Destroy()
    end
end)
_G.PureFrameReset = __HH.FrameReset

__HH.stopAntiDie = function()
    for _, conn in pairs(__HH.antiDieConns) do pcall(function() conn:Disconnect() end) end
    __HH.antiDieConns = {}
end

__HH.startAntiDie = function()
    __HH.stopAntiDie()
    if not __HH.antiDieEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.BreakJointsOnDeath = false
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    table.insert(__HH.antiDieConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then
            hum.Health = hum.MaxHealth
        end
    end))

    table.insert(__HH.antiDieConns, hum.Died:Connect(function()
        task.wait()
        local newHum = Instance.new("Humanoid")
        newHum.Name = "ReplacedHumanoid"
        newHum.Parent = char
        workspace.CurrentCamera.CameraSubject = newHum
        hum:Destroy()
    end))
end

-- Frame Reset automatic reset-on-death integration.
__HH.autoResetOnDeath = false
__HH.setAutoResetOnDeathVisual = nil
__HH.setupDeathReset = function()
    __HH.FrameReset.ToggleDeathReset(__HH.autoResetOnDeath)
end

RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)


-- ========== AUTO LEFT / AUTO RIGHT (FULL FRHUB PORT) ==========
-- Pure's old path backend is gone. This block carries FRHUB's complete path
-- coordinates, two-phase controller, speed selection, LinearVelocity driver,
-- completion behavior, stop behavior, visual sync and toggle functions.
-- The scope releases all internal helper registers after this backend is built.
do
local FRHubAutoPathPOS = {
    L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80),
    R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.04,-5.09,23.14),
}
local FRHubAutoPathConns = {autoLeft=nil, autoRight=nil}
local FRHubAutoLeftPhase, FRHubAutoRightPhase = 1, 1

local function getFRHubAutoMoveSpeed()
    if laggerCarryToggled then return NS
    elseif laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

-- Dedicated copy of the horizontal branch used by FRHUB's _setV helper. It
-- prevents Pure's normal speed actuator from replacing the Auto Path force.
local FRHubAutoVelocityCache = setmetatable({}, {__mode="k"})
local function destroyFRHubAutoVelocity(root)
    local cached=FRHubAutoVelocityCache[root]
    if cached then
        pcall(function() if cached[1] and cached[1].Parent then cached[1]:Destroy() end end)
        pcall(function() if cached[2] and cached[2].Parent then cached[2]:Destroy() end end)
        FRHubAutoVelocityCache[root]=nil
    end
end
local function getFRHubAutoVelocity(root)
    local cached=FRHubAutoVelocityCache[root]
    local lv=cached and cached[1]
    if lv and lv.Parent==root then return lv end
    destroyFRHubAutoVelocity(root)
    local attachment=Instance.new("Attachment"); attachment.Name="FRHubAutoPathAttachment"; attachment.Parent=root
    lv=Instance.new("LinearVelocity")
    lv.Name="FRHubAutoPathVelocity"
    lv.Attachment0=attachment
    lv.VelocityConstraintMode=Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis=Vector3.new(1,0,0)
    lv.SecondaryTangentAxis=Vector3.new(0,0,1)
    lv.MaxForce=math.huge
    lv.RelativeTo=Enum.ActuatorRelativeTo.World
    lv.PlaneVelocity=Vector2.zero
    lv.Parent=root
    FRHubAutoVelocityCache[root]={lv,attachment}
    return lv
end
local function setFRHubAutoVelocity(root, velocity)
    if not root or not root.Parent then return end
    if velocity.Magnitude < 0.01 then return end
    root.AssemblyLinearVelocity = Vector3.new(velocity.X, root.AssemblyLinearVelocity.Y, velocity.Z)
end
_G.PureCursedClearAutoPathVelocity = function(root)
    if root then setFRHubAutoVelocity(root,Vector3.zero) end
end

startAutoLeft = function()
    if FRHubAutoPathConns.autoLeft then FRHubAutoPathConns.autoLeft:Disconnect() end
    FRHubAutoLeftPhase=1
    FRHubAutoPathConns.autoLeft=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end; local spd=getFRHubAutoMoveSpeed()
        if FRHubAutoLeftPhase==1 then
            local target=Vector3.new(FRHubAutoPathPOS.L1.X,root.Position.Y,FRHubAutoPathPOS.L1.Z)
            if (target-root.Position).Magnitude<1 then FRHubAutoLeftPhase=2; return end
            local delta=FRHubAutoPathPOS.L1-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        elseif FRHubAutoLeftPhase==2 then
            local target=Vector3.new(FRHubAutoPathPOS.L2.X,root.Position.Y,FRHubAutoPathPOS.L2.Z)
            if (target-root.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); setFRHubAutoVelocity(root,Vector3.zero)
                autoLeftEnabled=false
                if FRHubAutoPathConns.autoLeft then FRHubAutoPathConns.autoLeft:Disconnect(); FRHubAutoPathConns.autoLeft=nil end
                FRHubAutoLeftPhase=1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(false) end
                saveConfig()
                return
            end
            local delta=FRHubAutoPathPOS.L2-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        end
    end)
end

stopAutoLeft = function()
    if FRHubAutoPathConns.autoLeft then FRHubAutoPathConns.autoLeft:Disconnect(); FRHubAutoPathConns.autoLeft=nil end
    FRHubAutoLeftPhase=1
    local char=LP.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero,false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(false) end
end

startAutoRight = function()
    if FRHubAutoPathConns.autoRight then FRHubAutoPathConns.autoRight:Disconnect() end
    FRHubAutoRightPhase=1
    FRHubAutoPathConns.autoRight=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end; local spd=getFRHubAutoMoveSpeed()
        if FRHubAutoRightPhase==1 then
            local target=Vector3.new(FRHubAutoPathPOS.R1.X,root.Position.Y,FRHubAutoPathPOS.R1.Z)
            if (target-root.Position).Magnitude<1 then FRHubAutoRightPhase=2; return end
            local delta=FRHubAutoPathPOS.R1-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        elseif FRHubAutoRightPhase==2 then
            local target=Vector3.new(FRHubAutoPathPOS.R2.X,root.Position.Y,FRHubAutoPathPOS.R2.Z)
            if (target-root.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); setFRHubAutoVelocity(root,Vector3.zero)
                autoRightEnabled=false
                if FRHubAutoPathConns.autoRight then FRHubAutoPathConns.autoRight:Disconnect(); FRHubAutoPathConns.autoRight=nil end
                FRHubAutoRightPhase=1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(false) end
                saveConfig()
                return
            end
            local delta=FRHubAutoPathPOS.R2-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        end
    end)
end

stopAutoRight = function()
    if FRHubAutoPathConns.autoRight then FRHubAutoPathConns.autoRight:Disconnect(); FRHubAutoPathConns.autoRight=nil end
    FRHubAutoRightPhase=1
    local char=LP.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero,false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(false) end
end

toggleAutoLeft = function()
    autoLeftEnabled=not autoLeftEnabled
    if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(autoLeftEnabled) end
    if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    saveConfig()
end

toggleAutoRight = function()
    autoRightEnabled=not autoRightEnabled
    if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(autoRightEnabled) end
    if autoRightEnabled then startAutoRight() else stopAutoRight() end
    saveConfig()
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if autoLeftEnabled then startAutoLeft() end
    if autoRightEnabled then startAutoRight() end
end)
end

function runDrop()
    -- Ace Drop: briefly rise, then place the player safely on the ground.
    if __HH.dropActive then return end
    if __HH.autoTPEnabled and __HH.stopAutoTP then __HH.stopAutoTP() end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    __HH.dropActive = true
    local startTime = tick()
    local dropConn
    dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            if dropConn then dropConn:Disconnect() end
            __HH.dropActive = false
            return
        end

        if tick() - startTime >= 0.2 then
            if dropConn then dropConn:Disconnect() end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                currentRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                currentRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            __HH.dropActive = false
            return
        end

        currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, 150, currentRoot.Velocity.Z)
    end)
end

local _lastTPTime = 0
local function doPureAutoTPDown(force)
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
    if hum2.Health <= 0 then return end
    local now = tick()
    if now - _lastTPTime < 0.08 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= __HH.autoTPHeight) then return end
    end
    if hrp.Position.Y <= -6.5 and not force then return end
    _lastTPTime = now
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
end

function startAutoTP()
    if __HH.autoTPConn then task.cancel(__HH.autoTPConn); __HH.autoTPConn = nil end
    __HH.autoTPConn = task.spawn(function()
        while __HH.autoTPEnabled do task.wait(0.1); pcall(function() doPureAutoTPDown(false) end) end
    end)
end

__HH.stopAutoTP = function()
    __HH.autoTPEnabled = false
    if __HH.autoTPConn then task.cancel(__HH.autoTPConn); __HH.autoTPConn = nil end
end

-- TP DOWN backend ported from FRHUB. Pure's previous manual TP DOWN
-- dispatch was removed; every TP DOWN surface calls this directly.
__HH.tpToGround = function()
    local char=LP.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)

    -- FRHUB finishes with _setV(hrp, Vector3.zero). Clear Pure's equivalent
    -- movement constraints without using the deleted Pure TP DOWN backend.
    if _G.PureCursedClearAimVelocity then pcall(_G.PureCursedClearAimVelocity) end
    if _G.PureCursedClearAutoPathVelocity then pcall(_G.PureCursedClearAutoPathVelocity,hrp) end
    destroySpeedLV()
    destroyVertLV()
end

__HH.startUnwalk = function()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim = c:FindFirstChild("Animate")
    if anim then __HH.unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end

__HH.stopUnwalk = function()
    local c = LP.Character
    if c and __HH.unwalkSavedAnimate then __HH.unwalkSavedAnimate:Clone().Parent = c; __HH.unwalkSavedAnimate = nil end
end


-- Ace Animation Pack (Replaced with Asker Hub Animation Packs)
__HH.aceSelectedAnimationPack = "OFF"
__HH.aceAnimationPackIndex = 1
__HH.aceAnimationPackList = {
    "OFF",
    "Unwalk",
    "Hit Harder",
    "Crazy",
    "Adidas Sports",
    "Adidas Community",
    "Adidas Aura",
    "Wicked Popular",
    "Elder",
    "Zombie",
    "Mage",
    "Catwalk Glam",
    "Astronaut",
    "Wicked \"Dancing Through Life\"",
    "Werewolf",
    "Superhero",
    "Toy",
    "No Boundaries",
    "NFL",
    "Amazon Unboxed",
    "Vampire",
    "Ninja",
    "Robot",
    "Levitation",
    "Stylish",
    "Bubbly",
    "Cartoon"
}
local aceAnimationPacks = {
    ["Crazy"] = {
        WalkAnim = 134824450619865,
        RunAnim = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 121454505477205,
        Swim = 121454505477205,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
        ClimbAnim = 121454505477205,
    },
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}
local aceSavedAnimate = nil
__HH.aceOriginalAnims = {}
local aceHitHarderAnimEnabled = false
local aceHitHarderAnims = {
    idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309", run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985", fall = "rbxassetid://116936326516985",
}

local function aceGetAnimate(char)
    char = char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end

local function aceStopCurrentAnimations(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

local function aceSetAnim(animObj, id)
    if animObj and id then
        local idStr = tostring(id)
        if not string.find(idStr, "rbxassetid://") then
            idStr = "rbxassetid://" .. idStr
        end
        pcall(function() animObj.AnimationId = idStr end)
    end
end

local function aceEnsureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

local function aceEnsureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i = 1, n do
        aceEnsureAnim(idleFolder, "Animation" .. i)
    end
end

local function acePick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

local function aceSaveOriginalAnimate(char)
    if not char then return end
    if aceSavedAnimate then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        aceSavedAnimate = animate:Clone()
    end
end

local function aceResetAnimations()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        aceStopCurrentAnimations(char)
    end
    if not aceSavedAnimate then return end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    local newAnimate = aceSavedAnimate:Clone()
    newAnimate.Parent = char
    newAnimate.Disabled = true
    task.wait(0.06)
    newAnimate.Disabled = false
end

local function aceEnableUnwalk()
    __HH.unwalkEnabled = true
    local char = LP.Character
    if char and char:FindFirstChild("Animate") then __HH.startUnwalk() end
    if setUnwalkVisual then setUnwalkVisual(true) end
end

local function aceDisableUnwalk()
    if __HH.unwalkEnabled then __HH.stopUnwalk() end
    __HH.unwalkEnabled = false
    if setUnwalkVisual then setUnwalkVisual(false) end
end

local function aceEnableHitHarderAnimation()
    aceHitHarderAnimEnabled = true
    local char = LP.Character
    local animate = aceGetAnimate(char)
    if not animate then return end
    aceSaveOriginalAnimate(char)
    aceStopCurrentAnimations(char)
    local idle1 = animate.idle and animate.idle:FindFirstChild("Animation1")
    local idle2 = animate.idle and animate.idle:FindFirstChild("Animation2")
    local walkObj = animate.walk and animate.walk:FindFirstChild("WalkAnim")
    local runObj = animate.run and animate.run:FindFirstChild("RunAnim")
    local jumpObj = animate.jump and animate.jump:FindFirstChild("JumpAnim")
    local fallObj = animate.fall and animate.fall:FindFirstChild("FallAnim")
    if idle1 then pcall(function() idle1.AnimationId = aceHitHarderAnims.idle1 end) end
    if idle2 then pcall(function() idle2.AnimationId = aceHitHarderAnims.idle2 end) end
    if walkObj then pcall(function() walkObj.AnimationId = aceHitHarderAnims.walk end) end
    if runObj then pcall(function() runObj.AnimationId = aceHitHarderAnims.run end) end
    if jumpObj then pcall(function() jumpObj.AnimationId = aceHitHarderAnims.jump end) end
    if fallObj then pcall(function() fallObj.AnimationId = aceHitHarderAnims.fall end) end
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end

local function aceDisableHitHarderAnimation()
    aceHitHarderAnimEnabled = false
    aceResetAnimations()
end

__HH.aceSyncAnimationPackIndex = function()
    for i, name in ipairs(__HH.aceAnimationPackList) do
        if name == __HH.aceSelectedAnimationPack then
            __HH.aceAnimationPackIndex = i
            return
        end
    end
    __HH.aceSelectedAnimationPack = "OFF"
    __HH.aceAnimationPackIndex = 1
end

__HH.aceApplyAnimationPack = function(packName)
    __HH.aceSelectedAnimationPack = packName or "OFF"
    __HH.aceSyncAnimationPackIndex()

    if __HH.aceSelectedAnimationPack ~= "Unwalk" then
        aceDisableUnwalk()
    end
    if __HH.aceSelectedAnimationPack ~= "Hit Harder" and aceHitHarderAnimEnabled then
        aceDisableHitHarderAnimation()
    end
    if __HH.aceSelectedAnimationPack == "Unwalk" then
        aceResetAnimations()
        aceEnableUnwalk()
        return
    end
    if __HH.aceSelectedAnimationPack == "Hit Harder" then
        aceEnableHitHarderAnimation()
        return
    end
    if __HH.aceSelectedAnimationPack == "OFF" then
        aceResetAnimations()
        return
    end

    local pack = aceAnimationPacks[__HH.aceSelectedAnimationPack]
    local char = LP.Character
    local animate = aceGetAnimate(char)
    if not pack or not animate then return end
    aceSaveOriginalAnimate(char)
    aceStopCurrentAnimations(char)

    local runObj   = aceEnsureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = aceEnsureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = aceEnsureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = aceEnsureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = aceEnsureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = aceEnsureAnim(animate:FindFirstChild("swim"),  "Swim")
    local swimIdleObj = aceEnsureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder  = animate:FindFirstChild("idle")

    aceSetAnim(walkObj,  acePick(pack, "WalkAnim", "Walk", "walk"))
    aceSetAnim(runObj,   acePick(pack, "RunAnim", "Run", "run"))
    aceSetAnim(jumpObj,  acePick(pack, "JumpAnim", "Jump", "jump"))
    aceSetAnim(fallObj,  acePick(pack, "FallAnim", "Fall", "fall"))
    aceSetAnim(climbObj, acePick(pack, "ClimbAnim", "Climb", "climb"))
    aceSetAnim(swimObj,  acePick(pack, "Swim", "swim"))
    aceSetAnim(swimIdleObj, acePick(pack, "SwimIdle", "swimidle") or acePick(pack, "Swim", "swim"))

    if idleFolder then
        local a1 = acePick(pack, "Animation1")
        local a2 = acePick(pack, "Animation2")
        if a1 or a2 then
            aceEnsureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            aceSetAnim(idleFolder:FindFirstChild("Animation1"), id1)
            aceSetAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            aceEnsureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            aceSetAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            aceSetAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then aceSetAnim(a, pack.Idle[i]) end
            end
        elseif pack.idle and #pack.idle > 0 then
            aceEnsureIdleSlots(idleFolder, math.max(2, #pack.idle))
            aceSetAnim(idleFolder:FindFirstChild("Animation1"), pack.idle[1])
            aceSetAnim(idleFolder:FindFirstChild("Animation2"), pack.idle[2] or pack.idle[1])
            for i = 3, #pack.idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then aceSetAnim(a, pack.idle[i]) end
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

-- Infinite Jump (voided) — manual + hold mode
local function applyInfJumpBoost(boost)
    if not __HH.infJumpEnabled then return end
    if __HH.infJumpMode == "manual" then
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z) end
    end
end

__HH.UIS.JumpRequest:Connect(function() applyInfJumpBoost(50) end)
__HH.UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not __HH.UIS:GetFocusedTextBox() then
        task.delay(0.12, function() if __HH.UIS:IsKeyDown(Enum.KeyCode.Space) then applyInfJumpBoost(50) end end)
    end
end)
RunService.Heartbeat:Connect(function()
    if __HH.infJumpEnabled and __HH.infJumpMode == "manual" then
        if __HH.UIS:IsKeyDown(Enum.KeyCode.Space) then applyInfJumpBoost(50) end
    end
end)

__HH.startHoldInfJump = function()
    if __HH.holdInfJumpConn then return end
    __HH.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not __HH.infJumpEnabled or __HH.infJumpMode ~= "hold" then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = __HH.UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.Velocity.Y < 35 then root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z) end
        if root.Velocity.Y < -120 then root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z) end
    end)
end

__HH.stopHoldInfJump = function()
    if __HH.holdInfJumpConn then __HH.holdInfJumpConn:Disconnect(); __HH.holdInfJumpConn = nil end
end

-- ============ Auto Jump (while holding brainrot, every 2s) ============
-- Detection style matches FR: WalkSpeed < 25 means you're carrying.
-- While holding, applies one 55-stud upward hop every 2 seconds.
__HH.autoJumpBrainrot = __HH.autoJumpBrainrot == true
local autoJumpLastJump = 0
RunService.Heartbeat:Connect(function()
    if not __HH.autoJumpBrainrot then
        autoJumpLastJump = 0
        return
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then
        autoJumpLastJump = 0
        return
    end
    if hum.WalkSpeed >= 25 then
        autoJumpLastJump = 0  -- not holding: reset so next grab jumps instantly
        return
    end
    local now = tick()
    if now - autoJumpLastJump < 2 then return end
    autoJumpLastJump = now
    local cur = root.AssemblyLinearVelocity
    root.AssemblyLinearVelocity = Vector3.new(cur.X, 55, cur.Z)
end)


if __HH.infJumpEnabled and __HH.infJumpMode == "hold" then __HH.startHoldInfJump() end


_G.PureMedusaState = _G.PureMedusaState or {connections={}, debounce=false, lastUsed=0}
local function aceFindMedusa()
    local char=LP.Character; if not char then return nil end
    local function scan(container)
        if not container then return nil end
        for _,tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then local n=tool.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return tool end end
        end
    end
    return scan(char) or scan(LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack"))
end
local function aceUseMedusaCounter(force)
    local state=_G.PureMedusaState
    if (not force and not __HH.medusaCounterEnabled) or state.debounce or tick()-(state.lastUsed or 0)<25 then return end
    local char=LP.Character; if not char then return end
    state.debounce=true
    local tool=aceFindMedusa()
    if tool then
        if tool.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then pcall(function() hum:EquipTool(tool) end); task.wait(.05) end end
        pcall(function() tool:Activate() end); state.lastUsed=tick()
    end
    state.debounce=false
end
setupMedusa = function(char)
    stopMedusaCounter(); char=char or LP.Character; if not char then return end
    local function hook(part)
        if part:IsA("BasePart") then table.insert(_G.PureMedusaState.connections,part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if __HH.medusaCounterEnabled and part.Anchored and part.Transparency==1 then aceUseMedusaCounter() end
        end)) end
    end
    for _,part in ipairs(char:GetDescendants()) do hook(part) end
    table.insert(_G.PureMedusaState.connections,char.DescendantAdded:Connect(hook))
end
stopMedusaCounter = function()
    for _,conn in ipairs(_G.PureMedusaState.connections) do pcall(function() conn:Disconnect() end) end
    _G.PureMedusaState.connections={}; _G.PureMedusaState.debounce=false
end

-- SPIN BOT (ported from FRHUB)
do
    local Spin = _G.PureSpinBot or {}
    _G.PureSpinBot = Spin
    if Spin.stop then pcall(Spin.stop) end
    Spin.enabled = Spin.enabled == true
    Spin.setVisual = nil

    local _spBAV = nil
    local _spMConns = {}

    local function _spStop()
        if _spBAV then pcall(function() _spBAV:Destroy() end); _spBAV = nil end
        for _, connection in ipairs(_spMConns) do
            pcall(function() connection:Disconnect() end)
        end
        _spMConns = {}
    end

    local function _spStart()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if _spBAV then pcall(function() _spBAV:Destroy() end) end

        _spBAV = Instance.new("BodyAngularVelocity")
        _spBAV.Name = "SpinForce"
        _spBAV.MaxTorque = Vector3.new(0, math.huge, 0)
        _spBAV.AngularVelocity = Vector3.new(0, 25, 0)
        _spBAV.P = 1e5
        _spBAV.Parent = root

        for _, connection in ipairs(_spMConns) do
            pcall(function() connection:Disconnect() end)
        end
        _spMConns = {}

        local character = root.Parent
        if character then
            local function _spOnMedusa(part)
                if part.Anchored and part.Transparency == 1 then
                    pcall(function() aceUseMedusaCounter(true) end)
                    local unanchorConnection
                    unanchorConnection = part:GetPropertyChangedSignal("Anchored"):Connect(function()
                        if not part.Anchored then
                            pcall(function() unanchorConnection:Disconnect() end)
                            if _spBAV then task.defer(_spStart) end
                        end
                    end)
                    table.insert(_spMConns, unanchorConnection)
                end
            end

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(_spMConns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                        _spOnMedusa(part)
                    end))
                end
            end
            table.insert(_spMConns, character.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") then
                    table.insert(_spMConns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                        _spOnMedusa(part)
                    end))
                end
            end))
        end
    end

    Spin.restart = function()
        if not Spin.enabled then return end
        if _spBAV then _spBAV = nil end
        for _, connection in ipairs(_spMConns) do
            pcall(function() connection:Disconnect() end)
        end
        _spMConns = {}
        task.defer(_spStart)
    end

    Spin.start = _spStart
    Spin.stop = _spStop
    Spin.setEnabled = function(on)
        on = on == true
        Spin.enabled = on
        if Spin.setVisual then Spin.setVisual(on) end
        if on then _spStart() else _spStop() end
    end
end

batCounterDebounce = false
BAT_COUNTER_SLAP_LIST = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "ZeyHubb Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
function findBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end
local function swingBatForCounter(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.8); pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end); task.wait(0.8); pcall(function() bat:Activate() end)
    end
end
startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not __HH.batCounterEnabled then return end
        if batCounterDebounce then return end
        local char = LP.Character; if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st = hum2:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, char) end
                task.wait(0.5); batCounterDebounce = false
            end)
        end
    end)
end
stopBatCounter = function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter = nil end
    batCounterDebounce = false
end

end
do
local SKY_TAG = "VynxSkyTheme"
__HH.currentSkyTheme = "Off"
SKY_PRESETS = {
    ["Off"]           = {kind="off"},
    ["Night"]         = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]        = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]        = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]        = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]         = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]        = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]    = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]    = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]  = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]      = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]        = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]= {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]     = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]         = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]     = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]        = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]         = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]       = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]    = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]= {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]       = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]      = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SKY_ORDER = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function _color3(rgb) return Color3.fromRGB(rgb[1], rgb[2], rgb[3]) end

local function applySkyTheme(mode)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
        end
    end
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14; Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000; Lighting.GlobalShadows = true
        __HH.currentSkyTheme = "Off"; return
    end
    Lighting.FogStart = 0; Lighting.FogEnd = 100000; Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0); Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true; Lighting.ClockTime = preset.clock or 14; Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _color3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _color3(preset.ambient) end
    if preset.sky then
        local sky = Instance.new("Sky"); sky:SetAttribute(SKY_TAG, true)
        if preset.sky.stars then sky.StarCount = preset.sky.stars end
        if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
        sky.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere"); atm:SetAttribute(SKY_TAG, true)
        atm.Density = preset.atm.dens or 0.3; atm.Color = _color3(preset.atm.color)
        atm.Decay = _color3(preset.atm.decay); atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds"); clouds:SetAttribute(SKY_TAG, true)
        clouds.Cover = preset.clouds.cover or 0.5; clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _color3(preset.clouds.color); clouds.Parent = terrain
    end
    __HH.currentSkyTheme = mode
end

local defLightBrightness, defLightClock, defLightAmbient

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

local function enableAntiLag()
    __HH.removeAccessoriesEnabled = true; __HH.antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1e10; Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if __HH.antiLagDescConn then __HH.antiLagDescConn:Disconnect() end
    __HH.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if __HH.removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

local function disableAntiLag()
    __HH.removeAccessoriesEnabled = false; __HH.antiLagEnabled = false
    if __HH.antiLagDescConn then __HH.antiLagDescConn:Disconnect(); __HH.antiLagDescConn = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
        Lighting.ExposureCompensation = 0
    end)
end

local function enableStretchRez()
    __HH.stretchRezEnabled = true; workspace.CurrentCamera.FieldOfView = 107
    if __HH.stretchRezConn then __HH.stretchRezConn:Disconnect() end
    __HH.stretchRezConn = RunService.RenderStepped:Connect(function()
        if not __HH.stretchRezEnabled then __HH.stretchRezConn:Disconnect(); __HH.stretchRezConn = nil; return end
        workspace.CurrentCamera.FieldOfView = 107
    end)
end

local function disableStretchRez()
    __HH.stretchRezEnabled = false
    if __HH.stretchRezConn then __HH.stretchRezConn:Disconnect(); __HH.stretchRezConn = nil end
    workspace.CurrentCamera.FieldOfView = 70
end

function saveConfig()
    local function ks(e) return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil} end
    local cfg = {
        normalSpeed = NS, carrySpeed = CS,
        r3Enabled = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.Enabled) == true,
        r3NormalSpeed = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.NormalSpeed) or NS,
        r3CarrySpeed = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.CarrySpeed) or CS,
        r3ForceCarry = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.ForceCarry) == true,
        dropBrainrotKey = ks(__HH.KB.DropBrainrot), 
        tpLockKey = ks(__HH.KB.TPLock), laggerToggleKey = ks(__HH.KB.LaggerToggle),
        frameResetKey = ks(__HH.KB.InstaReset), frameResetKeyVersion = 1,
        autoLeftKey = ks(__HH.KB.AutoLeft), autoRightKey = ks(__HH.KB.AutoRight), tpFloorKey = ks(__HH.KB.TPFloor), guiHideKey = ks(__HH.KB.GuiHide),
        speedToggleKey = ks(__HH.KB.SpeedToggle), batV2Key = ks(__HH.KB.BatV2Toggle),
        antiRagdoll = __HH.antiRagdollEnabled,
        infiniteJump = __HH.infJumpEnabled, medusaCounter = __HH.medusaCounterEnabled,
        medusaReset = __HH.medusaResetEnabled, batCounter = __HH.batCounterEnabled,
        carryMode = carrySpeedActive, laggerMode = laggerModeEnabled, laggerCarryMode = (laggerModeEnabled and carrySpeedActive),
        laggerSpeed = LAGGER_SPEED, laggerCarrySpeed = LAGGER_CARRY_SPEED,
        aimbotV1Speed = aimbotV1Speed,
        autoCarrySpeedEnabled = autoCarrySpeedEnabled,
        tpLockEnabled = __HH.tpLockEnabled, autoSwing = autoSwingEnabled,
        mirrorTPDownEnabled = (_G.PureMirrorTPDown and _G.PureMirrorTPDown.enabled
            and _G.PureMirrorTPDown.enabled()) == true,
        batSpamEnabled = (_G.PureBatSpam and _G.PureBatSpam.enabled
            and _G.PureBatSpam.enabled()) == true,
        spinBotEnabled = (_G.PureSpinBot and _G.PureSpinBot.enabled) == true,
        unwalkEnabled = __HH.unwalkEnabled, antiLag = __HH.antiLagEnabled, stretchRez = __HH.stretchRezEnabled,
        autoTPEnabled = __HH.autoTPEnabled, autoTPHeight = __HH.autoTPHeight,
        autoJumpBrainrot = __HH.autoJumpBrainrot,
        floatEnabled = __HH.floatEnabled, floatHeight = __HH.floatHeight,
        guiTransparencyEnabled = __HH.guiTransparencyEnabled,
        mobileButtonsEnabled = __HH.mobileButtonsEnabled, mobileButtonsSize = __HH.mobileButtonsSize,
        circleButtonsEnabled = __HH.circleButtonsEnabled, shapeButtonsEnabled = __HH.shapeButtonsEnabled,
        rectangularButtonsEnabled = __HH.rectangularButtonsEnabled,
        infJumpMode = __HH.infJumpMode,
        antiDie = __HH.antiDieEnabled, autoResetOnDeath = __HH.autoResetOnDeath,
        uiLocked = __HH.uiLocked, perButtonDragEnabled = __HH.perButtonDragEnabled,
        batV2Enabled = __HH.batV2Enabled,
        batAimMode = batAimMode,
        skyTheme = __HH.currentSkyTheme, uiScale = uiScaleValue,
        buttonVisibility = __HH.buttonVisibility,
        espEnabled = __HH.espEnabled,
        headlessEnabled = __HH.headlessEnabled,
        korbloxEnabled = __HH.korbloxEnabled,
        accessoryPack = currentAccessoryPack,
        autoLeftEnabled = autoLeftEnabled,
        autoRightEnabled = autoRightEnabled,
        antiKick = antiKickEnabled,
        safeMode = antiKickEnabled,
        aceAnimationPack = __HH.aceSelectedAnimationPack,
        -- v17 integrated feature state
        autoStealEnabled = (_G.PolmStealModes and _G.PolmStealModes.GetEnabled and _G.PolmStealModes.GetEnabled()) == true,
        autoStealMode = (_G.PolmStealModes and _G.PolmStealModes.GetMode and _G.PolmStealModes.GetMode()) or "Instant",
        autoStealRadius = (_G.PolmStealModes and _G.PolmStealModes.GetRadius and _G.PolmStealModes.GetRadius()) or 61,
        bodyLockEnabled = __HH.bodyLockEnabled == true,
        bodyLockRange = __HH.bodyLockRange or 20,
        antiFlingEnabled = __HH.antiFlingEnabled == true,
        selectedDevice = __HH.selectedDevice,
    }
    pcall(function() writefile("VynxPC.json", __HH.HS:JSONEncode(cfg)) end)
    return cfg
end

-- Build the exact same settings table saveConfig() writes to disk, without
-- touching the file. Used by "Copy Config" so the exported code always
-- matches what would be auto-saved.
function __HH.buildConfigTable()
    return saveConfig()
end

-- Copy Config / Load Config: turns the full settings table into a single
-- portable text code (JSON + Base64) and back. Base64 keeps it safe to
-- paste anywhere; JSON round-trips every field exactly so Load Config
-- restores settings identically ("نفسها بالظبط").
-- Implemented as plain Lua (no HttpService:Base64Encode/Decode, which does
-- not exist on Roblox's HttpService and was silently failing before).
local B64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function base64Encode(data)
    local out = {}
    local len = #data
    local i = 1
    while i <= len do
        local b1, b2, b3 = data:byte(i, i + 2)
        b2 = b2 or 0
        b3 = b3 or 0
        local n = b1 * 65536 + b2 * 256 + b3
        local c1 = math.floor(n / 262144) % 64
        local c2 = math.floor(n / 4096) % 64
        local c3 = math.floor(n / 64) % 64
        local c4 = n % 64
        local rem = len - i + 1
        out[#out + 1] = B64_CHARS:sub(c1 + 1, c1 + 1)
        out[#out + 1] = B64_CHARS:sub(c2 + 1, c2 + 1)
        out[#out + 1] = (rem >= 2) and B64_CHARS:sub(c3 + 1, c3 + 1) or "="
        out[#out + 1] = (rem >= 3) and B64_CHARS:sub(c4 + 1, c4 + 1) or "="
        i = i + 3
    end
    return table.concat(out)
end

local B64_LOOKUP = {}
for idx = 1, #B64_CHARS do
    B64_LOOKUP[B64_CHARS:sub(idx, idx)] = idx - 1
end

local function base64Decode(data)
    data = data:gsub("[^" .. B64_CHARS .. "=]", "")
    local out = {}
    local i = 1
    local len = #data
    while i <= len do
        local c1 = data:sub(i, i)
        local c2 = data:sub(i + 1, i + 1)
        local c3 = data:sub(i + 2, i + 2)
        local c4 = data:sub(i + 3, i + 3)
        local n1 = B64_LOOKUP[c1]
        local n2 = B64_LOOKUP[c2]
        if not n1 or not n2 then break end
        local n3 = (c3 ~= "=" and c3 ~= "") and B64_LOOKUP[c3] or nil
        local n4 = (c4 ~= "=" and c4 ~= "") and B64_LOOKUP[c4] or nil
        local n = n1 * 262144 + n2 * 4096 + (n3 or 0) * 64 + (n4 or 0)
        local byte1 = math.floor(n / 65536) % 256
        local byte2 = math.floor(n / 256) % 256
        local byte3 = n % 256
        out[#out + 1] = string.char(byte1)
        if n3 then out[#out + 1] = string.char(byte2) end
        if n4 then out[#out + 1] = string.char(byte3) end
        i = i + 4
    end
    return table.concat(out)
end

local CONFIG_CODE_PREFIX = "HZNV2-"
function __HH.encodeConfigCode(cfg)
    local json = __HH.HS:JSONEncode(cfg)
    local b64 = base64Encode(json)
    return CONFIG_CODE_PREFIX .. b64
end

function __HH.decodeConfigCode(code)
    if type(code) ~= "string" then return nil end
    code = code:gsub("^%s+", ""):gsub("%s+$", "")
    if code == "" then return nil end
    local body = code
    if code:sub(1, #CONFIG_CODE_PREFIX) == CONFIG_CODE_PREFIX then
        body = code:sub(#CONFIG_CODE_PREFIX + 1)
    end
    local okB64, json = pcall(base64Decode, body)
    if not okB64 or type(json) ~= "string" or json == "" then return nil end
    local okJson, cfg = pcall(function() return __HH.HS:JSONDecode(json) end)
    if not okJson or type(cfg) ~= "table" then return nil end
    return cfg
end

task.spawn(function() while task.wait(5) do saveConfig() end end)


local overheadGui = nil
local overheadSpeedLabel = nil

local function createHeadLabels(char)
    if overheadGui then
        pcall(function() overheadGui:Destroy() end)
        overheadGui = nil
        overheadSpeedLabel = nil
    end
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end
    
    overheadGui = Instance.new("BillboardGui")
    overheadGui.Name = "yousef_duels_OverheadInfo"
    overheadGui.Size = UDim2.new(0, 320, 0, 100)
    overheadGui.StudsOffset = Vector3.new(0, 3, 0)
    overheadGui.AlwaysOnTop = true
    overheadGui.LightInfluence = 0
    overheadGui.Parent = head
    

    
    -- Discord Link (Middle)
    local discordLbl = Instance.new("TextLabel")
    discordLbl.Name = "Discord"
    discordLbl.Size = UDim2.new(1, 0, 0, 26)
    discordLbl.Position = UDim2.new(0, 0, 0, 26)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "discord.gg/polmhub"
    discordLbl.TextColor3 = Color3.fromRGB(232, 205, 255)
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    discordLbl.TextStrokeTransparency = 0
    discordLbl.Font = Enum.Font.GothamBold
    discordLbl.TextSize = 14
    discordLbl.TextXAlignment = Enum.TextXAlignment.Center
    discordLbl.ZIndex = 10
    discordLbl.Parent = overheadGui
    
    -- Speed (Bottom)
    overheadSpeedLabel = Instance.new("TextLabel")
    overheadSpeedLabel.Name = "Speed"
    overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 26)
    overheadSpeedLabel.Position = UDim2.new(0, 0, 0, 52)
    overheadSpeedLabel.BackgroundTransparency = 1
    overheadSpeedLabel.Text = "Speed: 0"
    overheadSpeedLabel.TextColor3 = Color3.fromRGB(232, 205, 255)
    overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    overheadSpeedLabel.TextStrokeTransparency = 0
    overheadSpeedLabel.Font = Enum.Font.GothamBold
    overheadSpeedLabel.TextSize = 16
    overheadSpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
    overheadSpeedLabel.ZIndex = 10
    overheadSpeedLabel.Parent = overheadGui
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent or not overheadSpeedLabel then conn:Disconnect(); return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hrp then
            local md = hum.MoveDirection
            if md.Magnitude > 0.1 then
                -- player is moving: show the configured speed (stable)
                overheadSpeedLabel.Text = "Speed: " .. tostring(getActiveMoveSpeed())
            else
                overheadSpeedLabel.Text = "Speed: 0"
            end
        end

    end)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    createHeadLabels(char)
end)

if LP.Character then
    task.spawn(function()
        task.wait(0.5)
        createHeadLabels(LP.Character)
    end)
end

-- Clean Hub ragdoll countdown (billboard over head), recolored blue.
do
    local _ragCountdownRunning = false
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local cGui = game:GetService("CoreGui")
        local pGui = LP:WaitForChild("PlayerGui")
        local existing = cGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local existing2 = pGui:FindFirstChild("RagCountdownBillboard")
        if existing2 then existing2:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = Vector3.new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        if not pcall(function() bb.Parent = cGui end) then
            bb.Parent = pGui
        end
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(100, 205, 255)
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 20, 50)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        return bb, lbl
    end
    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end
    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end
    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end

-- AIM BOT carry handoff:
-- when the internal or floating AIM BOT button is ON during carry animation
-- 71186871415348, disable AIM BOT first and run Pure's DROP BR. AIM BOT stays
-- disabled until the drop motion is finished, the carry animation is gone, and
-- any carry state detected at the start is cleared for stable consecutive frames.
-- If confirmation fails, DROP BR retries while AIM BOT remains disabled; only a
-- confirmed drop restores it. Anti Kick never cancels this cycle.
_G.PureDropThenAimCycleActive = false
_G.PureDropThenAimSafeModeAuthorized = false
do
    local CARRY_DROP_AIM_ANIM_ID = "71186871415348"
    local carryDropAimWasPlaying = false
    local carryDropAimLastTrigger = 0
    local carryDropAimSequenceActive = false

    local function isCarryDropAimAnimationPlaying()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then return false end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local animation = track.Animation
            local animationId = animation and animation.AnimationId or ""
            if string.find(animationId, CARRY_DROP_AIM_ANIM_ID, 1, true) then return true end
        end
        return false
    end

    _G.PureCursedDropAimCarryAnimationPlaying = isCarryDropAimAnimationPlaying

    local function isPureAimButtonActive()
        if not __HH.batV2Enabled then return false end
        local getter = _G.PureCursedGetAimbot
        if type(getter) ~= "function" then return false end
        local ok, enabled = pcall(getter)
        return ok and enabled == true
    end

    -- Ragdoll destroys the carry animation PERMANENTLY: after a ragdoll ends
    -- (~3 seconds) the carry anim id does NOT come back, so the drop must
    -- never fire again for that brainrot. AntiRagdoll and the always-on speed
    -- loop both stamp _G.PureRagdollKilledCarry = true the moment ragdoll is
    -- detected (even while AIM BOT is off). The flag only resets when a
    -- brand-new carry animation starts (fresh pickup), via rising edge below.
    local function recentlyRagdolled()
        return _G.PureRagdollKilledCarry == true
    end

    local function stopCarryAnimNow()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local animation = track.Animation
            local animationId = animation and animation.AnimationId or ""
            if string.find(animationId, CARRY_DROP_AIM_ANIM_ID, 1, true) then
                track:Stop(0)
            end
        end
    end

    local DROP_CONFIRM_STABLE_HEARTBEATS = 3
    local DROP_RETRY_INTERVAL = 0.75

    local function hasDetectedCarryState()
        local ok, carrying = pcall(__HH.isCarryingBrainrot, LP.Character)
        return ok and carrying == true
    end

    local function restorePureAimAfterConfirmedDrop(requireCarryStateClear)
        task.spawn(function()
            local stableClearHeartbeats = 0
            local lastDropAttemptAt = tick()
            while carryDropAimSequenceActive do
                RunService.Heartbeat:Wait()

                local dropMotionFinished = __HH.dropActive ~= true
                local carryAnimationCleared = not isCarryDropAimAnimationPlaying()
                local carryStateCleared = not requireCarryStateClear or not hasDetectedCarryState()

                if dropMotionFinished and carryAnimationCleared and carryStateCleared then
                    stableClearHeartbeats = stableClearHeartbeats + 1
                else
                    stableClearHeartbeats = 0
                end

                if stableClearHeartbeats >= DROP_CONFIRM_STABLE_HEARTBEATS then
                    -- Confirmed drop: finish the handoff and re-enable AIM BOT
                    -- automatically, mirroring the same enable path used by the
                    -- normal BAT V2 toggle (backend + visual + mobile button).
                    _G.PureDropThenAimSafeModeAuthorized = false
                    __HH.batV2Enabled = true
                    if _G.PureCursedSetAimbot then pcall(_G.PureCursedSetAimbot, true) end
                    if __HH.batV2SetVisual then __HH.batV2SetVisual(true) end
                    if __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(true) end
                    carryDropAimSequenceActive = false
                    _G.PureDropThenAimCycleActive = false
                    saveConfig()
                    return
                end

                -- Failed/not-yet-confirmed drop: keep AIM BOT OFF and retry DROP BR.
                -- Never retry on top of an active drop movement.
                local now = tick()
                if __HH.dropActive ~= true and now - lastDropAttemptAt >= DROP_RETRY_INTERVAL then
                    lastDropAttemptAt = now
                    runDrop()
                end
            end
        end)
    end

    local function triggerPureDropAimCycle()
        local now = tick()
        if carryDropAimSequenceActive then return end
        if now - carryDropAimLastTrigger < 0.75 then return end
        carryDropAimLastTrigger = now
        carryDropAimSequenceActive = true
        antiKickAimPending = false
        _G.PureDropThenAimCycleActive = true
        _G.PureDropThenAimSafeModeAuthorized = false

        -- Stop the backend and synchronize both Aim Bot controls before DROP BR.
        __HH.batV2Enabled = false
        if _G.PureCursedSetAimbot then pcall(_G.PureCursedSetAimbot, false) end
        if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
        if __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(false) end

        -- If a concrete carry state exists now, require that exact condition to
        -- clear too; otherwise the known carry animation is the confirmation signal.
        local requireCarryStateClear = hasDetectedCarryState()
        runDrop()
        restorePureAimAfterConfirmedDrop(requireCarryStateClear)
    end

    local carryAnimPrev = false

    RunService.Heartbeat:Connect(function()
        if carryDropAimSequenceActive then
            carryDropAimWasPlaying = isCarryDropAimAnimationPlaying()
            carryAnimPrev = carryDropAimWasPlaying
            return
        end

        local isPlaying = isCarryDropAimAnimationPlaying()

        -- Always-on rising edge: a brand-new carry animation just started
        -- (fresh brainrot pickup). This is the only thing that re-arms the
        -- drop after a ragdoll permanently destroyed the previous carry.
        if isPlaying and not carryAnimPrev then
            _G.PureRagdollKilledCarry = false
        end
        carryAnimPrev = isPlaying

        if not isPureAimButtonActive() then
            carryDropAimWasPlaying = false
            return
        end

        if recentlyRagdolled() then
            -- A ragdoll destroyed this carry for good (the anim id never comes
            -- back), so never drop it: just stop the anim and let AIM BOT run
            -- with no drop movement.
            stopCarryAnimNow()
            carryDropAimWasPlaying = false
            return
        end

        if isPlaying and not carryDropAimWasPlaying then triggerPureDropAimCycle() end
        carryDropAimWasPlaying = isPlaying
    end)
end

-- Anti Kick E01 carry timer (top-screen wide banner, very light blue).
do
    local e01Gui, e01Lbl, e01Active = nil, nil, false
    local E01_ANIM = "71186871415348"
    local function e01InCarry()
        local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local animator=hum and hum:FindFirstChildOfClass("Animator")
        if not animator then return false end
        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do if track.Animation.AnimationId:find(E01_ANIM) then return true end end
        return false
    end
    local function clearE01()
        e01Active=false
        if e01Gui then e01Gui:Destroy(); e01Gui=nil end
        e01Lbl=nil
    end
    local function showE01()
        if e01Active then return end
        e01Active=true
        e01Gui=Instance.new("ScreenGui")
        e01Gui.Name="AntiKickE01"; e01Gui.ResetOnSpawn=false; e01Gui.IgnoreGuiInset=true
        e01Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; e01Gui.DisplayOrder=15
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(e01Gui) end end)
        if not pcall(function() e01Gui.Parent=game:GetService("CoreGui") end) then
            e01Gui.Parent=LP:WaitForChild("PlayerGui")
        end
        local bar=Instance.new("Frame",e01Gui)
        bar.AnchorPoint=Vector2.new(0.5,0)
        bar.Size=UDim2.new(1,-40,0,50); bar.Position=UDim2.new(0.5,0,0,70)
        bar.BackgroundColor3=Color3.fromRGB(4,16,32); bar.BackgroundTransparency=.5; bar.BorderSizePixel=0
        Instance.new("UICorner",bar).CornerRadius=UDim.new(0,10)
        local stroke=Instance.new("UIStroke",bar); stroke.Color=Color3.fromRGB(200,242,255); stroke.Thickness=1.5; stroke.Transparency=.3
        e01Lbl=Instance.new("TextLabel",bar)
        e01Lbl.Size=UDim2.new(1,-8,1,0); e01Lbl.Position=UDim2.new(0,4,0,0)
        e01Lbl.BackgroundTransparency=1; e01Lbl.Text="DON'T WIN OR E01"
        e01Lbl.Font=Enum.Font.GothamBlack; e01Lbl.TextSize=24
        e01Lbl.TextColor3=Color3.fromRGB(190,232,255); e01Lbl.ZIndex=5
        local began=tick()
        task.spawn(function()
            while e01Active do
                task.wait(.05)
                if not e01InCarry() then clearE01(); return end
                local left=math.max(0,3.1-(tick()-began))
                if left<=0 then clearE01(); return end
                if left < 1 then
                    e01Lbl.Text = "YOU CAN WIN"
                    e01Lbl.TextSize = 28
                    e01Lbl.TextColor3 = Color3.fromRGB(215,247,255)
                else
                    e01Lbl.Text = "DON'T WIN OR E01"
                    e01Lbl.TextSize = 24
                    e01Lbl.TextColor3 = Color3.fromRGB(190,232,255)
                end
            end
        end)
    end
    task.spawn(function() local was=false; while task.wait(.12) do local now=e01InCarry(); if now and not was then showE01() elseif not now and was then clearE01() end; was=now end end)
end

local playerSpeedLabels = {}

local function createPlayerSpeedLabel(plr)
    if plr == LP then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if playerSpeedLabels[plr] then
        playerSpeedLabels[plr].gui:Destroy()
        playerSpeedLabels[plr] = nil
    end

    local speedGui = Instance.new("BillboardGui")
    speedGui.Name = "VynxSpeedLabel_Other"
    speedGui.Adornee = head
    speedGui.Size = UDim2.new(0, 160, 0, 28)
    speedGui.StudsOffset = Vector3.new(0, 2.8, 0)
    speedGui.AlwaysOnTop = true
    speedGui.Parent = char

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1,0,1,0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0"
    speedLbl.TextColor3 = Color3.fromRGB(232, 205, 255)
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.TextStrokeTransparency = 0
    speedLbl.Font = Enum.Font.GothamBold
    speedLbl.TextSize = 14
    speedLbl.TextScaled = true
    speedLbl.TextXAlignment = Enum.TextXAlignment.Center
    speedLbl.Parent = speedGui

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent then
            conn:Disconnect()
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local spd = hum and hum.WalkSpeed or 0
        speedLbl.Text = string.format("Speed: %.0f", spd)
    end)

    playerSpeedLabels[plr] = {gui = speedGui, lbl = speedLbl, conn = conn}
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LP then
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerSpeedLabel(plr)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if playerSpeedLabels[plr] then
        playerSpeedLabels[plr].gui:Destroy()
        if playerSpeedLabels[plr].conn then playerSpeedLabels[plr].conn:Disconnect() end
        playerSpeedLabels[plr] = nil
    end
end)

local _cachedChar, _cachedHum, _cachedHrp = nil, nil, nil

LP.CharacterAdded:Connect(function(char)
    _cachedChar = nil; _cachedHum = nil; _cachedHrp = nil
    task.wait(0.3)
    _cachedChar = char
    _cachedHum = char:FindFirstChildOfClass("Humanoid")
    _cachedHrp = char:FindFirstChild("HumanoidRootPart")
    if _G.PureSpinBot and _G.PureSpinBot.enabled and _G.PureSpinBot.restart then
        _G.PureSpinBot.restart()
    end
    if __HH.medusaCounterEnabled or __HH.medusaResetEnabled then setupMedusa(char) end
    if __HH.batCounterEnabled then startBatCounter() end
    if __HH.unwalkEnabled then task.wait(0.5); __HH.startUnwalk() end
    if __HH.aceSelectedAnimationPack ~= "OFF" then
        task.wait(0.15)
        __HH.aceOriginalAnims = {}
        pcall(function() __HH.aceApplyAnimationPack(__HH.aceSelectedAnimationPack) end)
    end
    if __HH.antiRagdollEnabled then __HH.stopAntiRagdoll(); __HH.startAntiRagdoll() end
    __HH.startAntiDie()
    if __HH.autoResetOnDeath then __HH.setupDeathReset() end
    if __HH.tpLockEnabled then
        task.delay(0.2, function()
            if __HH.tpLockEnabled and startTPLock then startTPLock() end
        end)
    end
end)

__HH.UIS.InputBegan:Connect(function(input, gpe)
    if __HH._anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or __HH.UIS:GetFocusedTextBox() then return end
    end
    if not __HH.isGamepadInput(input) then
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    end
    if not __HH.isBindableInput(input) then return end
    local kc = input.KeyCode
    if __HH.kbMatch(__HH.KB.LaggerToggle, kc) then toggleLaggerMode(); saveConfig()
    elseif __HH.kbMatch(__HH.KB.SpeedToggle, kc) then toggleCarryMode(); saveConfig()
    elseif __HH.kbMatch(__HH.KB.DropBrainrot, kc) then runDrop()
    elseif __HH.kbMatch(__HH.KB.InstaReset, kc) then
        if tick() - __HH._lastKbSet > 0.5 then pcall(__HH.FrameReset.ResetPlayer) end
    elseif __HH.kbMatch(__HH.KB.TPFloor, kc) then __HH.tpToGround()
    elseif __HH.kbMatch(__HH.KB.AutoLeft, kc) then
        toggleAutoLeft()
    elseif __HH.kbMatch(__HH.KB.AutoRight, kc) then
        toggleAutoRight()
    elseif __HH.kbMatch(__HH.KB.TPLock, kc) then
        if __HH.batV2Enabled then toggleBatV2() end
        toggleTPLock(); saveConfig()
    elseif __HH.kbMatch(__HH.KB.GuiHide, kc) then
        if __HH.mainFrame then __HH.mainFrame.Visible = not __HH.mainFrame.Visible end
    elseif __HH.kbMatch(__HH.KB.BatV2Toggle, kc) then
        if not __HH.batV2Enabled and _G.AceSafeModeTryStart
            and not _G.AceSafeModeTryStart(false) then return end
        if __HH.tpLockEnabled then toggleTPLock() end
        toggleBatV2(); saveConfig()
    end
end)

local MOB_POS_FILE = "vynx_btnpos.json"
local DRAG_THRESHOLD = 15

local function loadBtnPositions()
    if not (isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok, data = pcall(function() return __HH.HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data) == "table" then return data end
    return {}
end

local function saveBtnPositions()
    if not writefile then return end; if not __HH.mobGuiRef then return end
    local out = {}
    for _, child in ipairs(__HH.mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key = child:GetAttribute("BtnKey")
            out[key] = {xo = child.Position.X.Offset, yo = child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE, __HH.HS:JSONEncode(out)) end)
end

local function destroyMobileButtons()
    if __HH.mobGuiRef then pcall(function() __HH.mobGuiRef:Destroy() end); __HH.mobGuiRef = nil end
    __HH.mobBtnRefs = {}
end

local function resetBtnPositions()
    pcall(function() if writefile then writefile(MOB_POS_FILE, "{}") end end)
    if __HH.mobileButtonsEnabled then buildMobileButtons() end
end

local function buildMobileButtons()
    destroyMobileButtons()
    if not __HH.mobileButtonsEnabled then return end
    local savedPositions = loadBtnPositions()
    local BTN_SIZE = math.floor(__HH.mobileButtonsSize * 0.65)
    local fontSize = math.max(9, math.floor(__HH.mobileButtonsSize * 0.13))
    local spacing = 20; local cols = 2
    local isRect = __HH.rectangularButtonsEnabled
    local btnW = BTN_SIZE; local btnH = BTN_SIZE
    if isRect then btnW = math.floor(BTN_SIZE*1.4); btnH = math.floor(BTN_SIZE*0.75); spacing = 16 end
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local totalW = cols * btnW + (cols-1) * spacing
    local startX = viewport.X - totalW - 30; local startY = 30
    local buttonOrder = {
        {key="drop",         label="DROP BR",         toggle=false},
        {key="tpDown",       label="TP DOWN",         toggle=false},
        {key="batV2",        label="AIM BOT",          toggle=true},
        {key="tpLock",       label="TP BAT",     toggle=true},
        {key="lagger",       label="LAGGER",          toggle=true},
        {key="laggerCarry",  label="LAGGER CARRY",    toggle=true},
        {key="carrySpeed",   label="CARRY SPEED",     toggle=true},
        {key="instaReset",   label="INSTA RESET",     toggle=false},
        {key="autoLeft",     label="AUTO LEFT",       toggle=true},
        {key="autoRight",    label="AUTO RIGHT",      toggle=true},
    }
    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "VynxMobileButtons"; mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 15; mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = LP:WaitForChild("PlayerGui")
    end
    __HH.mobGuiRef = mobGui

    -- only render buttons that are visible
    local visibleOrder = {}
    for _, def in ipairs(buttonOrder) do
        if __HH.buttonVisibility[def.key] ~= false then
            visibleOrder[#visibleOrder+1] = def
        end
    end
    for i, def in ipairs(visibleOrder) do
        local col = (i-1) % cols; local row = math.floor((i-1)/cols)
        local xPos = startX + col*(btnW+spacing); local yPos = startY + row*(btnH+spacing)
        local saved = savedPositions[def.key]
        local initX = saved and saved.xo or xPos; local initY = saved and saved.yo or yPos
        local frame = Instance.new("Frame", mobGui)
        frame.Name = "MobBtn_"..def.key
        frame.Size = UDim2.new(0,btnW,0,btnH)
        frame.Position = UDim2.new(0,initX,0,initY)
        frame.BackgroundColor3 = __HH.BTN_OFF; frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0; frame.Active = true; frame.ZIndex = 102
        frame:SetAttribute("BtnKey", def.key)
        local cornerRadius
        if __HH.circleButtonsEnabled then cornerRadius = UDim.new(1,0)
        elseif __HH.shapeButtonsEnabled then cornerRadius = UDim.new(0,4)
        elseif __HH.rectangularButtonsEnabled then cornerRadius = UDim.new(0,9)
        else cornerRadius = UDim.new(0, math.max(8, math.floor(math.min(btnW,btnH)*0.2))) end
        local uic = Instance.new("UICorner", frame); uic.CornerRadius = cornerRadius

        local fstroke = Instance.new("UIStroke", frame)
        fstroke.Color = Color3.fromRGB(255,255,255); fstroke.Thickness = 1.5
        fstroke.Transparency = 0.7
        fstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local gloss = Instance.new("UIGradient", frame); gloss.Rotation = 90
        gloss.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150,150,150))})
        local shine = Instance.new("Frame", frame); shine.Name = "Shine"
        shine.Size = UDim2.new(1,-14,0,3); shine.Position = UDim2.new(0,7,0,4)
        shine.BackgroundColor3 = Color3.fromRGB(255,255,255); shine.BackgroundTransparency = 0.6
        shine.BorderSizePixel = 0; shine.ZIndex = 103; shine:SetAttribute("NoTheme", true)
        Instance.new("UICorner", shine).CornerRadius = UDim.new(1,0)

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
        btn.Text = def.label; btn.TextColor3 = __HH.TEXT_OFF
        btn.Font = Enum.Font.GothamBold; btn.TextSize = fontSize
        btn.LineHeight = 1.1; btn.TextWrapped = true
        btn.AutoButtonColor = false; btn.ZIndex = 105
        local isOn = false
        local function setOn(v)
            isOn = v
            if v then
                frame:SetAttribute("BtnIsOn", true)
                local color = (def.key == "carrySpeed") and Color3.fromRGB(255, 105, 115) or __HH.BTN_ON
                TS:Create(frame, TweenInfo.new(0.12,Enum.EasingStyle.Quad), {BackgroundColor3 = color}):Play()
                TS:Create(fstroke, TweenInfo.new(0.12), {Color=Color3.fromRGB(255,255,255), Thickness=3, Transparency=0.05}):Play()
                TS:Create(btn, TweenInfo.new(0.12), {TextColor3 = __HH.TEXT_ON}):Play()
            else
                frame:SetAttribute("BtnIsOn", false)
                TS:Create(frame, TweenInfo.new(0.12,Enum.EasingStyle.Quad), {BackgroundColor3 = __HH.BTN_OFF}):Play()
                TS:Create(fstroke, TweenInfo.new(0.12), {Color=Color3.fromRGB(255,255,255), Thickness=1.5, Transparency=0.7}):Play()
                TS:Create(btn, TweenInfo.new(0.12), {TextColor3 = __HH.TEXT_OFF}):Play()
            end
        end
        __HH.mobBtnRefs[def.key] = setOn
        local dragData = {start=nil,startPos=nil,moved=false,down=false}
        btn.InputBegan:Connect(function(input)
            if __HH.uiLocked or not __HH.perButtonDragEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragData.moved=false; dragData.down=true
                dragData.start=input.Position; dragData.startPos=frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragData.down=false
                        if dragData.moved then pcall(saveBtnPositions) end
                    end
                end)
            end
        end)
        btn.InputChanged:Connect(function(input)
            if dragData.down and not __HH.uiLocked and __HH.perButtonDragEnabled and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragData.start
                if delta.Magnitude > DRAG_THRESHOLD then dragData.moved = true end
                if dragData.moved then
                    frame.Position = UDim2.new(dragData.startPos.X.Scale, dragData.startPos.X.Offset+delta.X, dragData.startPos.Y.Scale, dragData.startPos.Y.Offset+delta.Y)
                end
            end
        end)
        local function flashWhite()
            TS:Create(frame, TweenInfo.new(0.06), {BackgroundColor3=Color3.fromRGB(220, 181, 255)}):Play()
            TS:Create(btn, TweenInfo.new(0.06), {TextColor3=Color3.fromRGB(232, 205, 255)}):Play()
            task.delay(0.15, function()
                if isOn then
                    local color = (def.key == "carrySpeed") and Color3.fromRGB(255, 105, 115) or __HH.BTN_ON
                    TS:Create(frame, TweenInfo.new(0.12), {BackgroundColor3=color}):Play()
                    TS:Create(btn, TweenInfo.new(0.12), {TextColor3=__HH.TEXT_ON}):Play()
                else
                    TS:Create(frame, TweenInfo.new(0.12), {BackgroundColor3=__HH.BTN_OFF}):Play()
                    TS:Create(btn, TweenInfo.new(0.12), {TextColor3=__HH.TEXT_OFF}):Play()
                end
            end)
        end
        btn.MouseButton1Click:Connect(function()
            if dragData.moved then dragData.moved=false; return end
            flashWhite()
            if def.key == "tpLock" then
                if __HH.batV2Enabled then toggleBatV2() end
                toggleTPLock(); setOn(__HH.tpLockEnabled); saveConfig(); return
            end
            if def.key == "batV2" then
                if not __HH.batV2Enabled and _G.AceSafeModeTryStart
                    and not _G.AceSafeModeTryStart(true) then
                    setOn(false); saveConfig(); return
                end
                if __HH.tpLockEnabled then toggleTPLock() end
                toggleBatV2(); setOn(__HH.batV2Enabled)
                saveConfig(); return
            end
            if def.key == "carrySpeed" then
                toggleCarryMode(); setOn(carrySpeedActive)
                if __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
                if __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
                saveConfig(); return
            end
            if def.key == "lagger" then
                toggleLaggerMode(); setOn(laggerModeEnabled)
                if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
                if __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
                saveConfig(); return
            end
            if def.key == "laggerCarry" then
                toggleLaggerCarryMode(); setOn(laggerCarryToggled)
                if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
                if __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
                saveConfig(); return
            end
            if def.key == "drop" then runDrop(); return end
            if def.key == "tpDown" then __HH.tpToGround(); return end
            if def.key == "instaReset" then __HH.FrameReset.ResetPlayer(); return end
            if def.key == "autoLeft" then toggleAutoLeft(); return end
            if def.key == "autoRight" then toggleAutoRight(); return end
        end)
    end
    
    if __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(__HH.tpLockEnabled) end
    if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(autoLeftEnabled) end
    if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(autoRightEnabled) end
    if __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(__HH.batV2Enabled) end
    if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
    if __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
    if __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
end

-- loadConfig(externalCfg) applies a settings table either read from disk or
-- passed in directly (used by "Load Config" to restore a pasted code).
-- On a brand-new install (no VynxPC.json yet, or a corrupt one) it writes an
-- initial config immediately so auto-save is active from the very first run
-- instead of waiting for the user to change a setting first.
loadConfig = function(externalCfg)
    local cfg = externalCfg
    if not cfg then
        if not (isfile and isfile("VynxPC.json")) then
            saveConfig()
            return
        end
        local ok, decoded = pcall(function() return __HH.HS:JSONDecode(readfile("VynxPC.json")) end)
        if not ok or type(decoded) ~= "table" then
            saveConfig()
            return
        end
        cfg = decoded
    end
    if cfg.normalSpeed then NS = cfg.normalSpeed end
    if cfg.carrySpeed then CS = cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED = cfg.laggerSpeed end
    if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED = cfg.laggerCarrySpeed end
    if cfg.aimbotV1Speed then aimbotV1Speed = cfg.aimbotV1Speed end
    if cfg.autoCarrySpeedEnabled ~= nil then autoCarrySpeedEnabled = cfg.autoCarrySpeedEnabled end
    if _G.Round3SpeedBooster then
        if cfg.r3Enabled ~= nil then
            _G.Round3SpeedBooster.setEnabled(cfg.r3Enabled == true)
        end
        if cfg.r3NormalSpeed then _G.Round3SpeedBooster.setNormalSpeed(cfg.r3NormalSpeed) end
        if cfg.r3CarrySpeed then _G.Round3SpeedBooster.setCarrySpeed(cfg.r3CarrySpeed) end
        if cfg.r3ForceCarry ~= nil and _G.Round3SpeedBooster.setForceCarry then
            _G.Round3SpeedBooster.setForceCarry(cfg.r3ForceCarry == true)
        end
    end
    if cfg.autoTPHeight then __HH.autoTPHeight = cfg.autoTPHeight end
    if cfg.autoJumpBrainrot ~= nil then __HH.autoJumpBrainrot = cfg.autoJumpBrainrot end
    if cfg.floatHeight then __HH.floatHeight = math.clamp(tonumber(cfg.floatHeight) or 6, 0, 200) end
    if cfg.floatEnabled ~= nil then __HH.floatEnabled = cfg.floatEnabled end
    if cfg.mobileButtonsSize then __HH.mobileButtonsSize = cfg.mobileButtonsSize end
    if cfg.antiRagdoll ~= nil then __HH.antiRagdollEnabled = cfg.antiRagdoll end
    if cfg.infiniteJump ~= nil then __HH.infJumpEnabled = cfg.infiniteJump end
    if cfg.medusaCounter ~= nil then __HH.medusaCounterEnabled = cfg.medusaCounter end
    if cfg.medusaReset ~= nil then __HH.medusaResetEnabled = cfg.medusaReset end
    if cfg.batCounter ~= nil then __HH.batCounterEnabled = cfg.batCounter end
    if cfg.carryMode ~= nil then carrySpeedActive = cfg.carryMode; speedMode = cfg.carryMode end
    if cfg.laggerMode ~= nil then laggerModeEnabled = cfg.laggerMode end
    if cfg.laggerCarryMode ~= nil then laggerCarryToggled = cfg.laggerCarryMode end
    if cfg.tpLockEnabled ~= nil then __HH.tpLockEnabled = cfg.tpLockEnabled end
    if cfg.autoSwing ~= nil then autoSwingEnabled = cfg.autoSwing end
    if cfg.mirrorTPDownEnabled ~= nil and _G.PureMirrorTPDown
    and _G.PureMirrorTPDown.setEnabled then
        _G.PureMirrorTPDown.setEnabled(cfg.mirrorTPDownEnabled)
    end
    if _G.PureBatSpam and cfg.batSpamEnabled ~= nil
    and _G.PureBatSpam.setEnabled then
        _G.PureBatSpam.setEnabled(cfg.batSpamEnabled)
    end
    if cfg.spinBotEnabled ~= nil and _G.PureSpinBot then _G.PureSpinBot.enabled = cfg.spinBotEnabled end
    if cfg.unwalkEnabled ~= nil then __HH.unwalkEnabled = cfg.unwalkEnabled end
    if cfg.antiLag ~= nil then __HH.antiLagEnabled = cfg.antiLag end
    if cfg.stretchRez ~= nil then __HH.stretchRezEnabled = cfg.stretchRez end
    if cfg.autoTPEnabled ~= nil then __HH.autoTPEnabled = cfg.autoTPEnabled end
    if cfg.guiTransparencyEnabled ~= nil then __HH.guiTransparencyEnabled = cfg.guiTransparencyEnabled end
    if cfg.mobileButtonsEnabled ~= nil then __HH.mobileButtonsEnabled = cfg.mobileButtonsEnabled end
    if cfg.circleButtonsEnabled ~= nil then __HH.circleButtonsEnabled = cfg.circleButtonsEnabled end
    if cfg.shapeButtonsEnabled ~= nil then __HH.shapeButtonsEnabled = cfg.shapeButtonsEnabled end
    if cfg.rectangularButtonsEnabled ~= nil then __HH.rectangularButtonsEnabled = cfg.rectangularButtonsEnabled end
    if cfg.antiDie ~= nil then __HH.antiDieEnabled = cfg.antiDie end
    if cfg.autoResetOnDeath ~= nil then __HH.autoResetOnDeath = cfg.autoResetOnDeath end
    if cfg.infJumpMode ~= nil then __HH.infJumpMode = cfg.infJumpMode end
    if cfg.uiLocked ~= nil then __HH.uiLocked = cfg.uiLocked end
    _G.YousefUiLocked = __HH.uiLocked
    if cfg.perButtonDragEnabled ~= nil then __HH.perButtonDragEnabled = cfg.perButtonDragEnabled end
    if cfg.batV2Enabled ~= nil then __HH.batV2Enabled = cfg.batV2Enabled end
    if cfg.batAimMode == "normal" or cfg.batAimMode == "bypass" then
        batAimMode = cfg.batAimMode
    elseif cfg.batAimMode == "v1" or cfg.batAimMode == "v2" then
        batAimMode = "normal"
    end
    if cfg.skyTheme ~= nil then __HH.currentSkyTheme = cfg.skyTheme end
    if cfg.uiScale ~= nil then uiScaleValue = cfg.uiScale end
        if cfg.espEnabled ~= nil then __HH.espEnabled = cfg.espEnabled end
    if type(cfg.headlessEnabled) == "boolean" then __HH.headlessEnabled = cfg.headlessEnabled end
    if type(cfg.korbloxEnabled) == "boolean" then __HH.korbloxEnabled = cfg.korbloxEnabled end
    if type(cfg.accessoryPack) == "string" then currentAccessoryPack = cfg.accessoryPack end
    if cfg.autoLeftEnabled ~= nil then autoLeftEnabled = cfg.autoLeftEnabled end
    if cfg.autoRightEnabled ~= nil then autoRightEnabled = cfg.autoRightEnabled end
    if cfg.safeMode ~= nil then antiKickEnabled = cfg.safeMode
    elseif cfg.antiKick ~= nil then antiKickEnabled = cfg.antiKick end
    if type(cfg.aceAnimationPack) == "string" then __HH.aceSelectedAnimationPack = cfg.aceAnimationPack end
    if cfg.bodyLockEnabled ~= nil then __HH.bodyLockEnabled = cfg.bodyLockEnabled == true end
    if cfg.bodyLockRange ~= nil then __HH.bodyLockRange = math.clamp(tonumber(cfg.bodyLockRange) or 20, 5, 200) end
    if cfg.antiFlingEnabled ~= nil then __HH.antiFlingEnabled = cfg.antiFlingEnabled == true end
    if _G.PolmStealModes then
        if cfg.autoStealRadius ~= nil then _G.PolmStealModes.SetRadius(cfg.autoStealRadius) end
        if cfg.autoStealMode == "Semi" or cfg.autoStealMode == "Instant" then _G.PolmStealModes.SetMode(cfg.autoStealMode) end
        if cfg.autoStealEnabled ~= nil then _G.PolmStealModes.SetEnabled(cfg.autoStealEnabled == true) end
    end
    __HH.aceSyncAnimationPackIndex()
    if type(cfg.buttonVisibility) == "table" then
        for k, v in pairs(cfg.buttonVisibility) do
            if __HH.buttonVisibility[k] ~= nil then __HH.buttonVisibility[k] = v end
        end
    end
    local function applyKey(target, saved)
        if not saved or not target then return end
        if saved.kb and Enum.KeyCode[saved.kb] then target.kb = Enum.KeyCode[saved.kb] else target.kb = nil end
        if saved.gp and Enum.KeyCode[saved.gp] then target.gp = Enum.KeyCode[saved.gp] else target.gp = nil end
    end
    applyKey(__HH.KB.DropBrainrot, cfg.dropBrainrotKey); 
    applyKey(__HH.KB.TPLock, cfg.tpLockKey)
    if cfg.frameResetKey then
        -- New Frame Reset keybind storage: preserve any rebind made in the
        -- existing Combat row.
        applyKey(__HH.KB.LaggerToggle, cfg.laggerToggleKey)
        applyKey(__HH.KB.InstaReset, cfg.frameResetKey)
    else
        -- Migrate old Pure configs (Lagger=R, Insta Reset=G) to the Frame
        -- layout (Frame Reset=R, Lagger=G) without moving the UI row.
        local oldLagger = cfg.laggerToggleKey
        if oldLagger and oldLagger.kb == "R" and not oldLagger.gp then
            __HH.KB.LaggerToggle.kb = Enum.KeyCode.G
            __HH.KB.LaggerToggle.gp = nil
        else
            applyKey(__HH.KB.LaggerToggle, oldLagger)
        end
        __HH.KB.InstaReset.kb = Enum.KeyCode.R
        __HH.KB.InstaReset.gp = nil
    end
    applyKey(__HH.KB.AutoLeft, cfg.autoLeftKey); applyKey(__HH.KB.AutoRight, cfg.autoRightKey); applyKey(__HH.KB.TPFloor, cfg.tpFloorKey)
    applyKey(__HH.KB.GuiHide, cfg.guiHideKey); applyKey(__HH.KB.SpeedToggle, cfg.speedToggleKey)
    applyKey(__HH.KB.BatV2Toggle, cfg.batV2Key)
    if cfg.selectedDevice == "PC" or cfg.selectedDevice == "MOBILE" or cfg.selectedDevice == "CONTROLLER" then
        __HH.selectedDevice = cfg.selectedDevice
    end
    -- Persist immediately so first-run always has a config file on disk,
    -- and so a freshly-loaded/pasted config is saved right away too.
    saveConfig()
end

local function applyState()
    if __HH.antiRagdollEnabled then __HH.stopAntiRagdoll(); __HH.startAntiRagdoll() end
    if setAntiRagVisual then setAntiRagVisual(__HH.antiRagdollEnabled) end
    if __HH.setInfJumpVisual then __HH.setInfJumpVisual(__HH.infJumpEnabled) end
    if __HH.infJumpEnabled and __HH.infJumpMode == "hold" then __HH.startHoldInfJump() end
    if __HH.setAutoJumpBrainrotVisual then __HH.setAutoJumpBrainrotVisual(__HH.autoJumpBrainrot) end
    if __HH.setFloatVisual then __HH.setFloatVisual(__HH.floatEnabled) end
    if __HH.FRFloat then __HH.FRFloat.setHeight(__HH.floatHeight or 6) end
    if __HH.floatEnabled and __HH.FRFloat then __HH.FRFloat.setEnabled(true) end
    if __HH.medusaCounterEnabled or __HH.medusaResetEnabled then
        setupMedusa(LP.Character)
        if setMedusaVisual then setMedusaVisual(__HH.medusaCounterEnabled) end
        if setMedusaResetVisual then setMedusaResetVisual(__HH.medusaResetEnabled) end
    end
    if __HH.batCounterEnabled then startBatCounter() end
    if __HH.setBatCounterVisual then __HH.setBatCounterVisual(__HH.batCounterEnabled) end
    if _G.PureSpinBot then
        if _G.PureSpinBot.enabled and _G.PureSpinBot.start then _G.PureSpinBot.start() end
        if _G.PureSpinBot.setVisual then _G.PureSpinBot.setVisual(_G.PureSpinBot.enabled) end
    end
    if __HH.tpLockEnabled then
        if startTPLock then startTPLock() end
        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(true) end
    end
    if __HH.unwalkEnabled then __HH.startUnwalk() end
    if setUnwalkVisual then setUnwalkVisual(__HH.unwalkEnabled) end
    if __HH.aceSelectedAnimationPack ~= "OFF" then
        pcall(function() __HH.aceApplyAnimationPack(__HH.aceSelectedAnimationPack) end)
    end
    if __HH.antiLagEnabled then enableAntiLag() end
    if setAntiLagVisual then setAntiLagVisual(__HH.antiLagEnabled) end
    if __HH.stretchRezEnabled then enableStretchRez() end
    if __HH.setStretchRezVisual then __HH.setStretchRezVisual(__HH.stretchRezEnabled) end
    if __HH.autoTPEnabled then startAutoTP() end
    if __HH.setAutoTPVisual then __HH.setAutoTPVisual(__HH.autoTPEnabled) end
    if __HH.batV2Enabled then toggleBatV2() end
    if __HH.batV2SetVisual then __HH.batV2SetVisual(__HH.batV2Enabled) end
    if _G.PureMirrorTPDown and _G.PureMirrorTPDown.enabled
    and _G.PureMirrorTPDownSetVisual then
        pcall(_G.PureMirrorTPDownSetVisual, _G.PureMirrorTPDown.enabled())
    end
    if _G.PureBatSpam and _G.PureBatSpam.enabled and _G.PureBatSpamSetVisual then
        pcall(_G.PureBatSpamSetVisual, _G.PureBatSpam.enabled())
    end
    if __HH.antiDieEnabled then __HH.startAntiDie() end
    if __HH.setAntiDieVisual then __HH.setAntiDieVisual(__HH.antiDieEnabled) end
    if __HH.autoResetOnDeath then __HH.setupDeathReset() end
    if __HH.setAutoResetOnDeathVisual then __HH.setAutoResetOnDeathVisual(__HH.autoResetOnDeath) end
    if __HH.bodyLockEnabled and not __HH.batV2Enabled and not __HH.tpLockEnabled and __HH.startBodyLock then __HH.startBodyLock() end
    if __HH.setBodyLockVisual then __HH.setBodyLockVisual(__HH.bodyLockEnabled) end
    if __HH.setAntiFlingVisual then __HH.setAntiFlingVisual(__HH.antiFlingEnabled) end
    refreshSpeedModeLabel()
    
    if __HH.currentSkyTheme and __HH.currentSkyTheme ~= "Off" then applySkyTheme(__HH.currentSkyTheme) end
    if __HH.mainFrame and __HH.uiScaleObject then __HH.uiScaleObject.Scale = uiScaleValue end
    if autoLeftEnabled then startAutoLeft() end
    if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    if autoRightEnabled then startAutoRight() end
    if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    if __HH.espEnabled and startPlayerESP then startPlayerESP() end
    if __HH.setESPVisual then __HH.setESPVisual(__HH.espEnabled) end
    if __HH.headlessEnabled or __HH.korbloxEnabled then
        task.spawn(function()
            task.wait(0.4)
            local char = LP.Character
            if char then
                pcall(function()
                    if __HH.headlessEnabled then applyHeadless(char, true) end
                    if __HH.korbloxEnabled then applyKorblox(char, true) end
                end)
            end
        end)
    end
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.spawn(function()
            task.wait(0.5)
            local char = LP.Character
            if char and currentAccessoryPack ~= "Off" then
                pcall(function() applyAccessoryPack(currentAccessoryPack) end)
            end
        end)
    end
    if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
end

-- ============================================
-- VIS SEMI STEAL + BODY LOCK / FR ANTI FLING / BAKI ANTI VOID
-- ============================================
do
    local P=game:GetService("Players"); local R=game:GetService("RunService"); local me=P.LocalPlayer
    local semi={running=false,conn=nil,busy=false,radius=61,finishRange=9,data={}}
    local desired=true; local suspended=false; local mode="Instant"
    local function mine(plot)
        local sign=plot and plot:FindFirstChild("PlotSign"); local y=sign and sign:FindFirstChild("YourBase")
        return y and y:IsA("BillboardGui") and y.Enabled==true
    end
    local function nearest()
        local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart");if not root then return end
        local plots=workspace:FindFirstChild("Plots");if not plots then return end
        local best,bd,bn,bsp=nil,math.huge,nil,nil
        for _,plot in ipairs(plots:GetChildren()) do if not mine(plot) then
            local pods=plot:FindFirstChild("AnimalPodiums");if pods then for _,pod in ipairs(pods:GetChildren()) do
                local base=pod:FindFirstChild("Base");local sp=base and base:FindFirstChild("Spawn")
                if sp then local d=(sp.Position-root.Position).Magnitude;if d<=semi.radius and d<bd then
                    for _,pr in ipairs(sp:GetDescendants()) do local ac=(pr:IsA("ProximityPrompt") and (pr.ActionText or ""):lower()) or ""
                        if ac:find("steal") or ac:find("grab") then best,bd,bn,bsp=pr,d,pod.Name,sp;break end
                    end
                end end
            end end
        end end
        return best,bn,bsp
    end
    local function valid() return desired and not suspended and mode=="Semi" and semi.running end
    local function execute(pr,pod,sp)
        if semi.busy or not valid() then return end
        if not semi.data[pr] then
            semi.data[pr]={hold={},trigger={},ready=true}
            pcall(function()
                if getconnections then
                    for _,c in ipairs(getconnections(pr.PromptButtonHoldBegan)) do if c.Function then table.insert(semi.data[pr].hold,c.Function) end end
                    for _,c in ipairs(getconnections(pr.Triggered)) do if c.Function then table.insert(semi.data[pr].trigger,c.Function) end end
                end
            end)
        end
        local data=semi.data[pr];if not data.ready then return end
        data.ready=false;semi.busy=true
        task.spawn(function()
            pcall(function()
                -- Exact Vis start: call the prompt's captured hold handlers.
                if #data.hold>0 then for _,f in ipairs(data.hold) do task.spawn(f) end else pr:InputHoldBegin() end
                local started=tick();local duration=1.3;local stopTime=.96
                while valid() and pr.Parent and tick()-started<stopTime do
                    local pct=math.clamp((tick()-started)/duration,0,.73)
                    if _G.StealBar then _G.StealBar.SetState("SEMI");_G.StealBar.SetProgress(pct,"SEMI") end
                    task.wait()
                end
                if not valid() or not pr.Parent then return end
                -- Vis pause point: exactly 73% until entering its 9-stud finish radius.
                if _G.StealBar then _G.StealBar.SetState("SEMI 73%");_G.StealBar.SetProgress(.73,"SEMI 73%") end
                while valid() and pr.Parent do
                    local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart")
                    if root and sp and (root.Position-sp.Position).Magnitude<=semi.finishRange then break end
                    if _G.StealBar then _G.StealBar.SetProgress(.73,"SEMI 73%") end
                    task.wait()
                end
                if not valid() or not pr.Parent then return end
                local fill=tick();local fillDuration=math.max(duration-stopTime,.05)
                while valid() and pr.Parent do
                    local fp=math.clamp((tick()-fill)/fillDuration,0,1)
                    if _G.StealBar then _G.StealBar.SetProgress(.73+fp*.27,"SEMI") end
                    if fp>=1 then break end
                    task.wait()
                end
                if valid() and pr.Parent then
                    if #data.trigger>0 then for _,f in ipairs(data.trigger) do task.spawn(f) end
                    elseif fireproximityprompt then fireproximityprompt(pr)
                    else pr:InputHoldEnd() end
                    local re=game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
                    if re and pod then re:FireServer(pod) end
                end
            end)
            pcall(function() pr:InputHoldEnd() end)
            data.ready=true;semi.busy=false
            if _G.StealBar then _G.StealBar.Reset() end
        end)
    end
    local function stopSemi()
        semi.running=false;if semi.conn then semi.conn:Disconnect();semi.conn=nil end
        if _G.StealBar then _G.StealBar.Reset() end
    end
    local function stopInstant() if _G.YousefInstantSteal then _G.YousefInstantSteal.SetEnabled(false) end end
    local function apply()
        stopSemi();stopInstant()
        if not desired or suspended then return end
        if mode=="Semi" then
            semi.running=true;semi.conn=R.Heartbeat:Connect(function() if not semi.busy then local p,n,sp=nearest();if p then execute(p,n,sp) end end end)
        elseif _G.YousefInstantSteal then _G.YousefInstantSteal.SetEnabled(true) end
    end
    _G.PolmStealModes={
        SetMode=function(m) mode=(m=="Semi") and "Semi" or "Instant";apply();if _G.StealBar then _G.StealBar.Reset() end end,
        GetMode=function() return mode end,
        SetEnabled=function(on) desired=on==true;apply();if _G.StealBar then _G.StealBar.Reset() end end,
        GetEnabled=function() return desired end,
        Suspend=function() suspended=true;apply() end,
        Resume=function() suspended=false;apply() end,
        IsSuspended=function() return suspended end,
        SetRadius=function(v) semi.radius=math.clamp(tonumber(v) or 61,1,500);if _G.YousefInstantSteal then _G.YousefInstantSteal.SetRadius(semi.radius) end end,
        GetRadius=function() return semi.radius end,
    }
    apply()
end

do
    local P=game:GetService("Players"); local R=game:GetService("RunService"); local me=P.LocalPlayer
    __HH.bodyLockEnabled=false; __HH.bodyLockRange=20; __HH.bodyLockConn=nil; __HH.setBodyLockVisual=nil
    local function stopBL()
        if __HH.bodyLockConn then __HH.bodyLockConn:Disconnect();__HH.bodyLockConn=nil end
        local c=me.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local r=c and c:FindFirstChild("HumanoidRootPart")
        if h then h.AutoRotate=true end;if r then r.AssemblyAngularVelocity=Vector3.zero end
    end
    __HH.stopBodyLock=stopBL
    __HH.startBodyLock=function()
        stopBL(); if not __HH.bodyLockEnabled or __HH.batV2Enabled or __HH.tpLockEnabled then return end
        __HH.bodyLockConn=R.RenderStepped:Connect(function()
            if __HH.batV2Enabled or __HH.tpLockEnabled then return end
            local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart");local hum=c and c:FindFirstChildOfClass("Humanoid");if not root or not hum then return end
            local target,dist=nil,math.huge
            for _,p in ipairs(P:GetPlayers()) do if p~=me and p.Character then local tr=p.Character:FindFirstChild("HumanoidRootPart");local th=p.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.Health>0 then local d=(tr.Position-root.Position).Magnitude;if d<dist then target,dist=tr,d end end end end
            if not target or dist>__HH.bodyLockRange then hum.AutoRotate=true;return end
            hum.AutoRotate=false
            local tv=target.AssemblyLinearVelocity
            local predicted=target.Position+tv*math.clamp(tv.Magnitude/80,.08,.35)
            local head=target.Parent and target.Parent:FindFirstChild("Head")
            local targetY=head and head.Position.Y or target.Position.Y
            local correction=math.clamp((targetY-(root.Position.Y+(hum.HipHeight or 0)))*.15,-1.5,1.5)
            local flat=Vector3.new(predicted.X,root.Position.Y+correction,predicted.Z)
            if (flat-root.Position).Magnitude>.1 then
                local goal=CFrame.lookAt(root.Position,flat);local diff=root.CFrame:Inverse()*goal
                local _,ry,_=diff:ToEulerAnglesXYZ();ry=math.clamp(ry,-2.5,2.5)
                root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(0,ry*42,0))
            end
        end)
    end

    __HH.antiFlingEnabled=false; __HH.setAntiFlingVisual=nil
    local fixing=false;local untilT=0
    R.Heartbeat:Connect(function()
        if not __HH.antiFlingEnabled or __HH.batV2Enabled or __HH.tpLockEnabled or __HH.dropActive then fixing=false;return end
        local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart");if not root then return end
        if fixing then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero;if os.clock()>=untilT then fixing=false end
        elseif root.AssemblyLinearVelocity.Magnitude>=140 or root.AssemblyAngularVelocity.Magnitude>=90 then fixing=true;untilT=os.clock()+.15 end
    end)

    __HH.antiVoidTPBat=false;local hist={}
    R.Heartbeat:Connect(function()
        if not __HH.antiVoidTPBat then hist={};return end
        local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart");if not root then return end
        local now=os.clock();table.insert(hist,{t=now,p=root.Position});while #hist>0 and now-hist[1].t>2 do table.remove(hist,1) end
        local old=nil;for i=#hist,1,-1 do if hist[i].t<=now-.6 then old=hist[i].p;break end end
        if old and (root.Position-old).Magnitude>150 then root.CFrame=CFrame.new(old);root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero;hist={} end
    end)
end

-- ============================================
-- ESP (UVA DUELS port): mini avatar billboard + highlight box + tracer lines
-- ============================================
do
    local playerData = {}
    local playerSPConnections = {}
    local playerSPRenderConn = nil
    local playerSPRunning = false

    local ESP_CONFIG = {
        CircleSize = 32,
        AvatarOffset = 2.5,
        LineColor = Color3.fromRGB(80, 140, 255),
        LineThickness = 1.5,
        BoxColor = Color3.fromRGB(105, 215, 255),
        BoxThickness = 2,
        GlowColor = Color3.fromRGB(175, 235, 255),
        GlowSize = 0.65,
        GlowTransparency = 0.05,
        FontSize = 10,
        NameOffset = 2,
    }

    -- clean leftovers from previous versions / previous runs
    pcall(function()
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name == "VoidedESP" or d.Name == "VoidedESPTag"
                or d.Name == "MiniAvatarESP" or d.Name == "RedESPBox" then
                d:Destroy()
            end
        end
        local function sweep(root)
            if not root then return end
            for _, g in ipairs(root:GetChildren()) do
                if string.sub(g.Name, 1, 11) == "PolmESP_" or string.sub(g.Name, 1, 8) == "DiceESP_" then
                    g:Destroy()
                end
            end
        end
        sweep(game:GetService("CoreGui"))
        sweep(LP:FindFirstChildOfClass("PlayerGui"))
    end)

    local function createPlayerSPBillboard(player, char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        local existing = head:FindFirstChild("MiniAvatarESP")
        if existing then existing:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MiniAvatarESP"
        billboard.Size = UDim2.new(0, 80, 0, 110)
        billboard.StudsOffset = Vector3.new(0, ESP_CONFIG.AvatarOffset, 0)
        billboard.AlwaysOnTop = true
        billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        billboard.Parent = head

        local container = Instance.new("Frame", billboard)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.ClipsDescendants = false

        local circleSize = ESP_CONFIG.CircleSize
        local radius = circleSize / 2

        local circleBg = Instance.new("Frame", container)
        circleBg.Size = UDim2.new(0, circleSize, 0, circleSize)
        circleBg.Position = UDim2.new(0.5, -radius, 0, 0)
        circleBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        circleBg.BackgroundTransparency = 0.3
        circleBg.BorderSizePixel = 0
        circleBg.ZIndex = 1

        local corner = Instance.new("UICorner", circleBg)
        corner.CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke", circleBg)
        stroke.Color = Color3.fromRGB(80, 140, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.5

        local avatarImage = Instance.new("Frame", circleBg)
        avatarImage.Size = UDim2.new(1, -4, 1, -4)
        avatarImage.Position = UDim2.new(0, 2, 0, 2)
        avatarImage.BackgroundTransparency = 1
        avatarImage.ZIndex = 2

        local avatarUrl = string.format(
            "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png",
            player.UserId
        )

        local nameLabel = Instance.new("TextLabel", container)
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.Position = UDim2.new(0, 0, 0, circleSize + ESP_CONFIG.NameOffset)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.DisplayName or player.Name
        nameLabel.TextColor3 = Color3.fromRGB(80, 140, 255)
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = ESP_CONFIG.FontSize
        nameLabel.TextScaled = false
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.ZIndex = 3

        return billboard
    end

    local function createPlayerSPBox(char)
        if not char then return end
        local existing = char:FindFirstChild("RedESPBox")
        if existing then existing:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.Name = "RedESPBox"
        highlight.Adornee = char
        highlight.FillColor = ESP_CONFIG.BoxColor
        highlight.OutlineColor = Color3.fromRGB(0,0,0)
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0.1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        return highlight
    end

    -- Small light-blue point that stays directly under every ESP target (non-Neon).
    local function createPlayerSPGlow(player)
        local old = workspace:FindFirstChild("PolmESPGlow_" .. tostring(player.UserId))
        if old then old:Destroy() end

        local glow = Instance.new("Part")
        glow.Name = "PolmESPGlow_" .. tostring(player.UserId)
        glow.Shape = Enum.PartType.Ball
        glow.Size = Vector3.new(ESP_CONFIG.GlowSize, ESP_CONFIG.GlowSize, ESP_CONFIG.GlowSize)
        glow.Anchored = true
        glow.CanCollide = false
        glow.CanTouch = false
        glow.CanQuery = false
        glow.CastShadow = false
        glow.Material = Enum.Material.SmoothPlastic
        glow.Color = ESP_CONFIG.GlowColor
        glow.Transparency = ESP_CONFIG.GlowTransparency
        glow.CFrame = CFrame.new(0, -10000, 0)
        glow.Parent = workspace

        local light = Instance.new("PointLight", glow)
        light.Name = "PolmESPBlueLight"
        light.Color = ESP_CONFIG.GlowColor
        light.Brightness = 2.5
        light.Range = 9
        light.Shadows = false
        return glow
    end

    local function setupPlayerESP(player)
        if player == LP then return end
        if playerData[player] then return end

        local data = {
            Line = nil,
            Billboard = nil,
            Box = nil,
            Glow = nil,
            Connections = {},
        }

        local line = nil
        if Drawing and type(Drawing.new) == "function" then
            line = Drawing.new("Line")
            line.Color = ESP_CONFIG.LineColor
            line.Thickness = ESP_CONFIG.LineThickness
            line.Transparency = 0.6
            line.Visible = false
        end
        data.Line = line
        data.Glow = createPlayerSPGlow(player)

        local charAddedConn = player.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            local bill = createPlayerSPBillboard(player, char)
            if bill then data.Billboard = bill end
            local box = createPlayerSPBox(char)
            if box then data.Box = box end

            char:GetPropertyChangedSignal("Parent"):Connect(function()
                if not char.Parent then
                    if data.Billboard then pcall(function() data.Billboard:Destroy() end); data.Billboard = nil end
                    if data.Box then pcall(function() data.Box:Destroy() end); data.Box = nil end
                end
            end)
        end)

        table.insert(data.Connections, charAddedConn)

        local nameChangedConn = player:GetPropertyChangedSignal("DisplayName"):Connect(function()
            if data.Billboard then
                local nameLabel = data.Billboard:FindFirstChildWhichIsA("TextLabel")
                if nameLabel then nameLabel.Text = player.DisplayName end
            end
        end)
        table.insert(data.Connections, nameChangedConn)

        if player.Character then
            task.wait(0.2)
            local bill = createPlayerSPBillboard(player, player.Character)
            if bill then data.Billboard = bill end
            local box = createPlayerSPBox(player.Character)
            if box then data.Box = box end
        end

        playerData[player] = data
    end

    local function removePlayerESP(player)
        if playerData[player] then
            if playerData[player].Line then
                pcall(function() playerData[player].Line:Remove() end)
            end
            if playerData[player].Billboard then
                pcall(function() playerData[player].Billboard:Destroy() end)
            end
            if playerData[player].Box then
                pcall(function() playerData[player].Box:Destroy() end)
            end
            if playerData[player].Glow then
                pcall(function() playerData[player].Glow:Destroy() end)
            end
            for _, conn in ipairs(playerData[player].Connections or {}) do
                pcall(function() conn:Disconnect() end)
            end
            playerData[player] = nil
        end
    end

    local function updatePlayerSPLines()
        local myChar = LP.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if not myHrp then
            for _, data in pairs(playerData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end

        local myPos, visible = workspace.CurrentCamera:WorldToViewportPoint(myHrp.Position)
        if not visible then
            for _, data in pairs(playerData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end

        for player, data in pairs(playerData) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp then
                -- Keep the light point attached under the actual character,
                -- not on the floor. It follows flight, falling and dead bodies.
                if data.Glow and data.Glow.Parent then
                    local bottomOffset = (hrp.Size.Y * 0.5) + 2.35
                    data.Glow.CFrame = CFrame.new(hrp.Position - Vector3.new(0, bottomOffset, 0))
                    data.Glow.Transparency = ESP_CONFIG.GlowTransparency
                end
                local targetPos, visible2 = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if data.Line then
                    if visible2 then
                        data.Line.Visible = true
                        data.Line.From = Vector2.new(myPos.X, myPos.Y)
                        data.Line.To = Vector2.new(targetPos.X, targetPos.Y)
                    else
                        data.Line.Visible = false
                    end
                end
            else
                if data.Line then data.Line.Visible = false end
                if data.Glow and data.Glow.Parent then
                    data.Glow.CFrame = CFrame.new(0, -10000, 0)
                end
            end
        end
    end

    function startPlayerESP()
        if playerSPRunning then return end
        playerSPRunning = true
        __HH.espEnabled = true

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                setupPlayerESP(player)
            end
        end

        if playerSPRenderConn then playerSPRenderConn:Disconnect() end
        playerSPRenderConn = RunService.RenderStepped:Connect(function()
            pcall(updatePlayerSPLines)
        end)

        local playerAddedConn = Players.PlayerAdded:Connect(function(p)
            if p ~= LP then setupPlayerESP(p) end
        end)
        table.insert(playerSPConnections, playerAddedConn)

        local playerRemovingConn = Players.PlayerRemoving:Connect(function(p)
            removePlayerESP(p)
        end)
        table.insert(playerSPConnections, playerRemovingConn)

        local charAddedConn = LP.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for player, data in pairs(playerData) do
                if player.Character then
                    local bill = createPlayerSPBillboard(player, player.Character)
                    if bill then
                        if data.Billboard then pcall(function() data.Billboard:Destroy() end) end
                        data.Billboard = bill
                    end
                    local box = createPlayerSPBox(player.Character)
                    if box then
                        if data.Box then pcall(function() data.Box:Destroy() end) end
                        data.Box = box
                    end
                end
            end
        end)
        table.insert(playerSPConnections, charAddedConn)
    end

    function stopPlayerESP()
        if not playerSPRunning then return end
        playerSPRunning = false
        __HH.espEnabled = false

        if playerSPRenderConn then
            playerSPRenderConn:Disconnect()
            playerSPRenderConn = nil
        end

        for _, conn in ipairs(playerSPConnections) do
            pcall(function() conn:Disconnect() end)
        end
        playerSPConnections = {}

        for player, data in pairs(playerData) do
            removePlayerESP(player)
        end
        playerData = {}
    end
end

-- ============================================
-- AVATAR (Nexus port): Headless + Korblox (client-side cosmetics)
-- ============================================
local HEADLESS_MESH_ID  = "rbxassetid://1095708"
local KORBLOX_MESH_ID   = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local cosmeticState = setmetatable({}, {__mode = "k"})

function applyHeadless(char, enabled)
    local head = char and char:FindFirstChild("Head"); if not head then return end
    local state = cosmeticState[char] or {}; cosmeticState[char] = state
    if enabled then
        if state.headTransparency == nil then
            state.headTransparency = head.Transparency; state.headCanCollide = head.CanCollide
            local face = head:FindFirstChild("face"); state.face = face and face:Clone() or nil
        end
        head.Transparency = 1; head.CanCollide = false
        local face = head:FindFirstChild("face"); if face then face:Destroy() end
        local old = head:FindFirstChild("PolmHeadlessMesh"); if old then old:Destroy() end
        local mesh = Instance.new("SpecialMesh", head)
        mesh.Name = "PolmHeadlessMesh"; mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID; mesh.Scale = Vector3.new(.001, .001, .001)
    else
        local mesh = head:FindFirstChild("PolmHeadlessMesh"); if mesh then mesh:Destroy() end
        if state.headTransparency ~= nil then
            head.Transparency = state.headTransparency; head.CanCollide = state.headCanCollide
            if state.face and not head:FindFirstChild("face") then state.face:Clone().Parent = head end
            state.headTransparency = nil; state.headCanCollide = nil; state.face = nil
        end
    end
end

function applyKorblox(char, enabled)
    local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local state = cosmeticState[char] or {}; cosmeticState[char] = state
    if hum.RigType == Enum.HumanoidRigType.R6 then
        local leg = char:FindFirstChild("Right Leg"); if not leg then return end
        if enabled then
            if not state.r6LegColor then
                state.r6LegColor = leg.Color; state.r6Meshes = {}
                for _, v in ipairs(leg:GetChildren()) do
                    if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then
                        table.insert(state.r6Meshes, v:Clone()); v:Destroy()
                    end
                end
            end
            leg.Color = Color3.fromRGB(64, 64, 64)
            local old = leg:FindFirstChild("PolmKorbloxMesh"); if old then old:Destroy() end
            local mesh = Instance.new("SpecialMesh", leg)
            mesh.Name = "PolmKorbloxMesh"; mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = KORBLOX_MESH_ID; mesh.TextureId = KORBLOX_TEXTURE_ID
        else
            local mesh = leg:FindFirstChild("PolmKorbloxMesh"); if mesh then mesh:Destroy() end
            if state.r6LegColor then leg.Color = state.r6LegColor end
            if state.r6Meshes then for _, v in ipairs(state.r6Meshes) do v:Clone().Parent = leg end end
            state.r6LegColor = nil; state.r6Meshes = nil
        end
    else
        local upper = char:FindFirstChild("RightUpperLeg")
        local lower = char:FindFirstChild("RightLowerLeg")
        local foot  = char:FindFirstChild("RightFoot")
        if not upper then return end
        if enabled then
            if not state.r15Transparency then
                state.r15Transparency = {upper.Transparency, lower and lower.Transparency or 0, foot and foot.Transparency or 0}
            end
            upper.Transparency = 1; if lower then lower.Transparency = 1 end; if foot then foot.Transparency = 1 end
            local old = char:FindFirstChild("PolmKorbloxLeg"); if old then old:Destroy() end
            local leg = Instance.new("Part", char)
            leg.Name = "PolmKorbloxLeg"; leg.Size = Vector3.new(1, 2, 1)
            leg.Anchored = false; leg.CanCollide = false; leg.Massless = true; leg.Color = Color3.fromRGB(64, 64, 64)
            local mesh = Instance.new("SpecialMesh", leg)
            mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = KORBLOX_MESH_ID; mesh.TextureId = KORBLOX_TEXTURE_ID
            local weld = Instance.new("Weld", leg)
            weld.Name = "PolmKorbloxWeld"; weld.Part0 = upper; weld.Part1 = leg; weld.C0 = CFrame.new(0, -.8, 0)
        else
            local vals = state.r15Transparency
            if vals then
                upper.Transparency = vals[1]
                if lower then lower.Transparency = vals[2] end
                if foot then foot.Transparency = vals[3] end
            end
            local leg = char:FindFirstChild("PolmKorbloxLeg"); if leg then leg:Destroy() end
            state.r15Transparency = nil
        end
    end
end

-- re-apply cosmetics on respawn
LP.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    pcall(function()
        if __HH.headlessEnabled then applyHeadless(char, true) end
        if __HH.korbloxEnabled then applyKorblox(char, true) end
    end)
end)

-- ============================================
-- CATALOG CHANGER (VisDuels port): Pack Accessory — Bleed 1 / Bleed 2 / Bleed 3
-- Changes shirt / pants / head / accessory / korblox (client-side).
-- ============================================
currentAccessoryPack = "Off"
__HH.OriginalOutfit = {shirt = nil, pants = nil}
__HH.OriginalAccessories = {}

local ACCESSORY_PACK_ORDER = {
    {"Off", "Off"},
    {"Bleed 1", "Bleed 1"},
    {"Bleed 2", "Bleed 2"},
    {"Bleed 3", "Bleed 3"},
}

local BLEED_PACKS = {
    ["Bleed 1"] = {
        accessory = 306969564,
        offset = Vector3.new(0.0000, 0.3000, 0.0000),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
        korblox = "right",
    },
    ["Bleed 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0.0000, 1.4000, -0.2000),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
        korblox = "right",
    },
    ["Bleed 3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0.0000, 0.6000, 0.0000),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        korblox = "right",
    },
}

local function saveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    __HH.OriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    __HH.OriginalOutfit.pants = pants and pants.PantsTemplate or nil
end

local function restoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
    if __HH.OriginalOutfit.shirt then
        local newShirt = Instance.new("Shirt")
        newShirt.ShirtTemplate = __HH.OriginalOutfit.shirt
        newShirt.Parent = char
    end
    if __HH.OriginalOutfit.pants then
        local newPants = Instance.new("Pants")
        newPants.PantsTemplate = __HH.OriginalOutfit.pants
        newPants.Parent = char
    end
    __HH.OriginalOutfit.shirt = nil
    __HH.OriginalOutfit.pants = nil
end

local function clearAllOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
end

local function saveOriginalAccessories(char)
    __HH.OriginalAccessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            local clone = child:Clone()
            table.insert(__HH.OriginalAccessories, clone)
        end
    end
end

local function restoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
            child:Destroy()
        end
    end
    for _, clone in ipairs(__HH.OriginalAccessories) do
        if clone and clone.Parent == nil then
            local newAcc = clone:Clone()
            newAcc.Parent = char
            for _, weld in ipairs(newAcc:GetDescendants()) do
                if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                    if weld:IsA("Weld") then
                        local part0Name = weld.Part0 and weld.Part0.Name
                        local part1Name = weld.Part1 and weld.Part1.Name
                        if part0Name then
                            local newPart0 = char:FindFirstChild(part0Name)
                            if newPart0 then weld.Part0 = newPart0 end
                        end
                        if part1Name then
                            local newPart1 = char:FindFirstChild(part1Name)
                            if newPart1 then weld.Part1 = newPart1 end
                        end
                    elseif weld:IsA("WeldConstraint") then
                        local part0Name = weld.Part0 and weld.Part0.Name
                        local part1Name = weld.Part1 and weld.Part1.Name
                        if part0Name then
                            local newPart0 = char:FindFirstChild(part0Name)
                            if newPart0 then weld.Part0 = newPart0 end
                        end
                        if part1Name then
                            local newPart1 = char:FindFirstChild(part1Name)
                            if newPart1 then weld.Part1 = newPart1 end
                        end
                    end
                end
            end
        end
    end
    __HH.OriginalAccessories = {}
end

local function clearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
            child:Destroy()
        end
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then
            child:Destroy()
        end
    end
    local partsToHide = {"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    for _, partName in ipairs(partsToHide) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") then
        head.Transparency = 0
    end
end

local function applyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end

    local char = LP.Character
    if not char then return false end

    char:WaitForChild("Head", 10)
    local head = char:FindFirstChild("Head")
    if not head then return false end

    if config.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                pcall(function() d:Destroy() end)
            end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = config.headMesh
            sm.TextureId = config.headTexture or ""
        end
    end

    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end

    if config.accessory and head then
        local old = char:FindFirstChild("AuFfitAccessory")
        if old then old:Destroy() end
        local objs = nil
        local ok, res = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(config.accessory))
        end)
        if ok and typeof(res) == "table" and #res > 0 then
            objs = res
        else
            ok, res = pcall(function()
                return game:GetService("InsertService"):LoadAsset(config.accessory)
            end)
            if ok and res then objs = {res} end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if config.korblox and config.korblox ~= "none" then
        local function attachKorblox(side)
            local ids = { left = 139607673, right = 139607718 }
            local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
            local hides = {
                left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
                right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
            }
            local targetPart = char:FindFirstChild(targets[side])
            if not targetPart then return false end
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local success, objects = pcall(function()
                return game:GetObjects("rbxassetid://" .. ids[side])
            end)
            if not success or not objects or #objects == 0 then return false end
            local assetModel = objects[1]
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if not mainMesh then assetModel:Destroy(); return false end
            mainMesh.CanCollide = false
            mainMesh.Massless = true
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            assetModel.Parent = char
            return true
        end
        if config.korblox == "left" then
            attachKorblox("left")
        elseif config.korblox == "right" then
            attachKorblox("right")
        end
    end

    return true
end

function applyAccessoryPack(packName)
    local char = LP.Character
    if not char then return end

    if packName == "Off" then
        clearAllAccessories(char)
        restoreOriginalOutfit(char)
        restoreOriginalAccessories(char)
        return
    end

    if not __HH.OriginalOutfit.shirt and not __HH.OriginalOutfit.pants then
        saveOriginalOutfit(char)
    end
    if #__HH.OriginalAccessories == 0 then
        saveOriginalAccessories(char)
    end

    clearAllOutfit(char)
    clearAllAccessories(char)
    applyBleedOutfit(packName)
end

-- re-apply pack on respawn (same as VisDuels reapplyAllStates)
LP.CharacterAdded:Connect(function(char)
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.wait(0.3)
        if LP.Character == char and currentAccessoryPack ~= "Off" then
            pcall(function() applyAccessoryPack(currentAccessoryPack) end)
        end
    end
end)

pcall(function()
    local cg = game:GetService("CoreGui")
    for _, name in ipairs({"Polm Hub", "Polm Hub", "Pure hub", "PolmHubMobileButtons", "PureHubMobileButtons", "VynxMobileButtons", "YousefIntro", "StealBarGui"}) do
        local old = cg:FindFirstChild(name)
        if old then old:Destroy() end
    end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        for _, name in ipairs({"Polm Hub", "Polm Hub", "Pure hub", "StealBarGui", "YousefIntro", "VynxMobileButtons"}) do
            local old = pg:FindFirstChild(name)
            if old then old:Destroy() end
        end
    end
end)
_G.VYNX_LOADED = true

-- =============== SAFE MODE: CERTZ 5s / GUI PHRASE 2s + 5s ===============
do
    -- Keep all Safe Mode state inside one table so this large script does not
    -- gain many long-lived top-level locals (Luau has a local/register limit).
    local SM = {
        duration          = 5,
        guiLeadDelay      = 2,
        activeDuration    = 5,
        signalCooldown    = 1,
        liveCooldown      = 10,
        roundSignalTime   = 0,
        restoreThread     = nil,
        lastSignalAt      = 0,
        lastGuiSignalAt   = 0,
        p3                = Vector3.new(-476.752, 10.464,   7.107),
        p7                = Vector3.new(-476.752, 10.464, 114.107),
        lastName          = "",
        lastValue         = 0,
        lastLiveAt        = 0,
        wasEnabled        = false,
        generation        = (_G.AceSafeModeGeneration or 0) + 1,
    }
    _G.AceSafeModeGeneration = SM.generation

    function _G.AceSafeModeGetCountdownLabel() return nil end
    function _G.AceSafeModeCountdownNumber(text) return false end
    function _G.AceSafeModeInDuelCountdown() return false end

    function _G.AceSafeModeIsLocked()
        if antiKickEnabled ~= true or SM.roundSignalTime <= 0 then return false end
        return tick() - SM.roundSignalTime < SM.activeDuration
    end

    function _G.AceSafeModeForceStop(reason)
        -- Drop-then-Aim may bypass ordinary manual stops, but it must never
        -- bypass an active Safe Mode window. Otherwise its restore coroutine
        -- can turn AIM BOT back on 1-2 seconds early in later rounds.
        local safeLocked = _G.AceSafeModeIsLocked
            and _G.AceSafeModeIsLocked() == true
        if not safeLocked and (_G.PureDropThenAimCycleActive == true
        or _G.PureDropThenAimSafeModeAuthorized == true) then
            return false
        end

        local backendOn = false
        if _G.PureCursedGetAimbot then
            local ok, enabled = pcall(_G.PureCursedGetAimbot)
            backendOn = ok and enabled == true
        end
        if not __HH.batV2Enabled and not backendOn then return false end

        antiKickAimPending = false
        __HH.batV2Enabled = false
        if stopAimbotFull then
            pcall(stopAimbotFull)
        elseif _G.PureCursedSetAimbot then
            pcall(_G.PureCursedSetAimbot, false)
        end
        if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(false) end
        return true
    end

    function _G.AceSafeModeRestorePendingAim()
        antiKickAimPending = false
        return false
    end

    function _G.AceSafeModeTryStart(allowDropThenAim)
        if not (_G.AceSafeModeIsLocked and _G.AceSafeModeIsLocked()) then
            return true
        end
        antiKickAimPending = false
        _G.AceSafeModeForceStop("AIM BOT BEFORE START")
        return false
    end

    local function _smOnRoundSignal(source)
        if antiKickEnabled ~= true then return false end

        local now = tick()
        local isGuiPhrase = source == "WON THIS ROUND GUI SAFE MODE"

        -- Certz can detect the result shortly before the visible GUI sentence.
        -- The GUI sentence is authoritative: it is allowed to realign the timer
        -- once, while repeated Text events are ignored. After the sentence, a
        -- late Certz snapshot cannot shorten or restart that same round.
        if isGuiPhrase then
            if SM.lastGuiSignalAt > 0
            and now - SM.lastGuiSignalAt < 1 then return false end
            SM.lastGuiSignalAt = now
        else
            if SM.lastGuiSignalAt > 0
            and now - SM.lastGuiSignalAt < (SM.duration + SM.guiLeadDelay) then return false end
            if SM.lastSignalAt > 0
            and now - SM.lastSignalAt < SM.signalCooldown then return false end
        end

        -- Certz starts a direct five-second pause. The GUI sentence starts with
        -- a two-second lead, followed by the same five-second pause (seven total).
        SM.activeDuration = SM.duration + (isGuiPhrase and SM.guiLeadDelay or 0)
        SM.lastSignalAt = now
        SM.roundSignalTime = now

        -- A completed carry handoff leaves this flag true. Clear that stale
        -- authorization at every new round so it cannot defeat Safe Mode.
        _G.PureDropThenAimSafeModeAuthorized = false
        _G.AceSafeModeForceStop(source or "ROUND SAFE MODE")
        print(string.format(
            "[SAFE MODE] signal=%s | lead=%.2fs | countdown=%.2fs | total=%.2fs",
            tostring(source or "unknown"),
            isGuiPhrase and SM.guiLeadDelay or 0,
            SM.duration,
            SM.activeDuration
        ))

        if SM.restoreThread then
            pcall(task.cancel, SM.restoreThread)
            SM.restoreThread = nil
        end

        SM.restoreThread = task.delay(SM.activeDuration, function()
            if _G.AceSafeModeGeneration ~= SM.generation then
                SM.restoreThread = nil
                return
            end
            SM.restoreThread = nil
            antiKickAimPending = false
            -- Manual behavior requested: when the Safe Mode timer ends, AIM BOT
            -- stays OFF and can only be enabled again by the user.
            print("[SAFE MODE] timer ended; AIM BOT remains OFF until manually enabled")
        end)
        return true
    end

    local function _smNum(value)
        value = tostring(value):gsub("%s", "")
        local number, suffix = value:match("([%d%.]+)(%a?)")
        number = tonumber(number) or 0
        if suffix == "K" or suffix == "k" then number = number * 1e3
        elseif suffix == "M" or suffix == "m" then number = number * 1e6
        elseif suffix == "B" or suffix == "b" then number = number * 1e9
        elseif suffix == "T" or suffix == "t" then number = number * 1e12 end
        return number
    end

    local function _smMyPlot()
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") and object.Name == "PlotSign" then
                local d3 = (object.Position - SM.p3).Magnitude
                local d7 = (object.Position - SM.p7).Magnitude
                if d3 < 5 or d7 < 5 then
                    for _, label in ipairs(object:GetDescendants()) do
                        if label:IsA("TextLabel") and label.Text ~= "" then
                            if label.Text:find(LP.Name, 1, true)
                            or label.Text:find(LP.DisplayName, 1, true) then
                                return d3 < 5 and 3 or 7
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    -- Certz live-win logic, merged only as a Safe Mode round signal. It does
    -- not send a webhook and deliberately does not check which player won.
    -- The first valid snapshot is accepted immediately, which covers the first
    -- round instead of waiting for a previous "won this round!" GUI sentence.
    task.spawn(function()
        while _G.AceSafeModeGeneration == SM.generation do
            repeat
            task.wait(1)

            if antiKickEnabled ~= true then
                SM.wasEnabled = false
                SM.roundSignalTime = 0
                SM.activeDuration = SM.duration
                SM.lastSignalAt = 0
                SM.lastGuiSignalAt = 0
                if SM.restoreThread then
                    pcall(task.cancel, SM.restoreThread)
                    SM.restoreThread = nil
                end
                break -- continue
            end

            if not SM.wasEnabled then
                SM.wasEnabled = true
                SM.lastName = ""
                SM.lastValue = 0
                SM.lastLiveAt = 0
            end

            local mine = _smMyPlot()
            if not mine then break --[[continue]] end

            local opponentPosition = mine == 3 and SM.p7 or SM.p3
            local debris = workspace:FindFirstChild("Debris")
            if not debris then break --[[continue]] end

            local bestName, bestValue
            for _, object in ipairs(debris:GetChildren()) do
                repeat
                if object.Name ~= "FastOverheadTemplate" then break --[[continue]] end

                local surface = object:FindFirstChildOfClass("SurfaceGui")
                if not surface or not surface.Adornee then break --[[continue]] end
                if (surface.Adornee.Position - opponentPosition).Magnitude > 50 then break --[[continue]] end

                local generation = surface:FindFirstChild("Generation", true)
                if generation and generation:IsA("TextLabel") then
                    local value = _smNum(generation.Text)
                    if not bestValue or value > bestValue then
                        bestValue = value
                        local displayName = surface:FindFirstChild("DisplayName", true)
                        bestName = displayName and displayName.Text or object.Name
                    end
                end
                until true
            end

            if bestName and bestValue then
                local changed = bestName ~= SM.lastName or bestValue ~= SM.lastValue
                if changed then
                    local firstSnapshot = SM.lastName == "" and SM.lastValue == 0
                    SM.lastName = bestName
                    SM.lastValue = bestValue

                    local now = tick()
                    if firstSnapshot or now - SM.lastLiveAt > SM.liveCooldown then
                        SM.lastLiveAt = now
                        _smOnRoundSignal(firstSnapshot
                            and "FIRST ROUND LIVE-WIN SAFE MODE"
                            or "LIVE-WIN CHANGE SAFE MODE")
                    end
                end
            end
            until true
        end
    end)

    local function _smStrip(text)
        return text and text:gsub("<[^>]+>", "") or ""
    end

    local function _smScan(object)
        if _G.AceSafeModeGeneration ~= SM.generation then return end
        if not (object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox")) then return end

        local clean = _smStrip(object.Text):lower()
        -- Ignore punctuation so both "won this round" and
        -- "won this round!" are accepted after RichText tags are removed.
        if clean:find("won this round", 1, true) then
            _smOnRoundSignal("WON THIS ROUND GUI SAFE MODE")
        end
    end

    local playerGui = LP:WaitForChild("PlayerGui")
    for _, object in ipairs(playerGui:GetDescendants()) do
        pcall(_smScan, object)
        if object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox") then
            object:GetPropertyChangedSignal("Text"):Connect(function()
                pcall(_smScan, object)
            end)
        end
    end
    playerGui.DescendantAdded:Connect(function(object)
        pcall(_smScan, object)
        if object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox") then
            object:GetPropertyChangedSignal("Text"):Connect(function()
                pcall(_smScan, object)
            end)
        end
    end)

    if _G.AceSafeModeMonitorConn then
        pcall(function() _G.AceSafeModeMonitorConn:Disconnect() end)
    end
    _G.AceSafeModeMonitorStarted = nil
    _G.AceSafeModeMonitorConn = RunService.Heartbeat:Connect(function()
        if _G.AceSafeModeGeneration ~= SM.generation then return end
        if not _G.AceSafeModeIsLocked() then
            antiKickAimPending = false
            if _G.PureDropThenAimCycleActive ~= true then
                _G.PureDropThenAimSafeModeAuthorized = false
            end
            return
        end
        -- Keep enforcing the lock even if Drop-then-Aim finishes during it.
        -- That coroutine may restore AIM BOT once; this heartbeat turns it back
        -- off immediately and the normal Safe Mode timer remains authoritative.
        _G.AceSafeModeForceStop("SAFE MODE HEARTBEAT")
    end)
end
-- =====================================================



-- ===================== Polm color / font system =====================
do
    local hz = {}
    __HH.hz = hz
    local BASE_HUE = 0.755
    hz.PALETTE = {
        {"Purple",190,140,255},{"Violet",150,90,240},{"Lavender",205,180,255},{"Magenta",235,70,235},
        {"Pink",255,120,190},{"Hot Pink",255,45,140},{"Red",245,65,65},{"Crimson",210,25,70},
        {"Orange",255,150,45},{"Gold",255,205,50},{"Yellow",255,238,80},{"Lime",170,240,60},
        {"Green",65,225,115},{"Mint",110,245,195},{"Teal",35,205,195},{"Cyan",65,225,255},
        {"Sky",115,185,255},{"Blue",55,115,255},{"Navy",60,80,200},{"Brown",175,110,65},
        {"White",255,255,255},{"Gray",155,155,170},
    }
    hz.guiName, hz.btnName, hz.grabName, hz.fontName = "Purple", "Default", "Default", "Default"
    hz.curGuiHue, hz.curGrabHue = BASE_HUE, BASE_HUE

    function hz.resolve(name)
        if name == nil or name == "Default" then return nil end
        if name == "Rainbow" then return Color3.fromHSV((os.clock() * 0.25) % 1, 0.75, 1) end
        for _, e in ipairs(hz.PALETTE) do
            if e[1] == name then return Color3.fromRGB(e[2], e[3], e[4]) end
        end
        return nil
    end
    function hz.guiNames()
        local t = {}
        for _, e in ipairs(hz.PALETTE) do if e[1] ~= "White" and e[1] ~= "Gray" then t[#t + 1] = e[1] end end
        return t
    end
    function hz.btnNames()
        local t = {"Default"}
        for _, e in ipairs(hz.PALETTE) do t[#t + 1] = e[1] end
        t[#t + 1] = "Rainbow"
        return t
    end
    function hz.grabNames()
        local t = {"Default"}
        for _, n in ipairs(hz.guiNames()) do t[#t + 1] = n end
        return t
    end

    -- persistence
    function hz.save()
        pcall(function()
            if writefile then
                writefile("PolmTheme.json", game:GetService("HttpService"):JSONEncode({
                    gui = hz.guiName, btn = hz.btnName, grab = hz.grabName, font = hz.fontName }))
            end
        end)
    end
    pcall(function()
        if isfile and readfile and isfile("PolmTheme.json") then
            local d = game:GetService("HttpService"):JSONDecode(readfile("PolmTheme.json"))
            if type(d) == "table" then
                if type(d.gui) == "string" then hz.guiName = d.gui end
                if type(d.btn) == "string" then hz.btnName = d.btn end
                if type(d.grab) == "string" then hz.grabName = d.grab end
                if type(d.font) == "string" then hz.fontName = d.font end
            end
        end
    end)

    -- hue-shift sweep (GUI + steal bar)
    local function nearHue(a, b)
        local d = math.abs(a - b); if d > 0.5 then d = 1 - d end
        return d < 0.045
    end
    local function shift(c, fromHue, toHue)
        local h, sat, v = c:ToHSV()
        if sat < 0.05 or v < 0.06 then return nil end
        if nearHue(h, BASE_HUE) or nearHue(h, fromHue) then return Color3.fromHSV(toHue, sat, v) end
        return nil
    end
    local function setc(d, prop, fromHue, toHue)
        pcall(function()
            local n = shift(d[prop], fromHue, toHue)
            if n then d[prop] = n end
        end)
    end
    local function sweep(root, fromHue, toHue)
        if not root then return end
        local list = { root }
        pcall(function() for _, d in ipairs(root:GetDescendants()) do list[#list + 1] = d end end)
        for _, d in ipairs(list) do
            local skip = false
            pcall(function() skip = d:GetAttribute("NoTheme") == true end)
            if not skip then
                pcall(function()
                    if d:IsA("GuiObject") then
                        setc(d, "BackgroundColor3", fromHue, toHue)
                        setc(d, "BorderColor3", fromHue, toHue)
                    end
                    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                        setc(d, "TextColor3", fromHue, toHue)
                        setc(d, "TextStrokeColor3", fromHue, toHue)
                    elseif d:IsA("UIStroke") then
                        setc(d, "Color", fromHue, toHue)
                    elseif d:IsA("ScrollingFrame") then
                        setc(d, "ScrollBarImageColor3", fromHue, toHue)
                    elseif d:IsA("UIGradient") then
                        local seq = d.Color
                        local ks, changed = {}, false
                        for _, k in ipairs(seq.Keypoints) do
                            local n = shift(k.Value, fromHue, toHue)
                            if n then changed = true end
                            ks[#ks + 1] = ColorSequenceKeypoint.new(k.Time, n or k.Value)
                        end
                        if changed then d.Color = ColorSequence.new(ks) end
                    end
                end)
            end
        end
    end
    local function findGui(name)
        local g
        pcall(function() g = game:GetService("CoreGui"):FindFirstChild(name) end)
        if g then return g end
        pcall(function() g = LP and LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild(name) end)
        return g
    end
    function hz.mainRoot()
        local m = __HH.mainFrame
        return m and m.Parent or nil
    end

    function hz.setGui(name)
        local c = hz.resolve(name)
        if not c or name == "Rainbow" then return end
        hz.guiName = name
        local toHue = c:ToHSV()
        local from = hz.curGuiHue
        hz.curGuiHue = toHue
        sweep(hz.mainRoot(), from, toHue)
        pcall(function() __HH.TOGGLE_ON_COLOR = shift(__HH.TOGGLE_ON_COLOR, from, toHue) or __HH.TOGGLE_ON_COLOR end)
        pcall(function() __HH.TOGGLE_OFF_COLOR = shift(__HH.TOGGLE_OFF_COLOR, from, toHue) or __HH.TOGGLE_OFF_COLOR end)
        hz.save()
    end
    function hz.setGrab(name)
        hz.grabName = name or "Default"
        local from = hz.curGrabHue
        local toHue = BASE_HUE
        if hz.grabName ~= "Default" then
            local c = hz.resolve(hz.grabName)
            if c then toHue = c:ToHSV() end
        end
        hz.curGrabHue = toHue
        sweep(findGui("StealBarGui"), from, toHue)
        hz.save()
    end

    -- mobile buttons
    hz.defOff, hz.defOn, hz.defTOff, hz.defTOn = __HH.BTN_OFF, __HH.BTN_ON, __HH.TEXT_OFF, __HH.TEXT_ON
    function hz.applyBtns()
        local gui = __HH.mobGuiRef
        if not (gui and gui.Parent) then return end
        for _, fr in ipairs(gui:GetChildren()) do
            if fr:IsA("Frame") and fr:GetAttribute("BtnKey") then
                pcall(function()
                    local on = fr:GetAttribute("BtnIsOn") == true
                    local key = fr:GetAttribute("BtnKey")
                    if on then
                        fr.BackgroundColor3 = (key == "carrySpeed") and Color3.fromRGB(255, 105, 115) or __HH.BTN_ON
                    else
                        fr.BackgroundColor3 = __HH.BTN_OFF
                    end
                    for _, d in ipairs(fr:GetChildren()) do
                        if d:IsA("TextButton") then d.TextColor3 = on and __HH.TEXT_ON or __HH.TEXT_OFF end
                    end
                end)
            end
        end
    end
    local function setBtnColors(c)
        if not c then
            __HH.BTN_OFF, __HH.BTN_ON, __HH.TEXT_OFF, __HH.TEXT_ON = hz.defOff, hz.defOn, hz.defTOff, hz.defTOn
        else
            local lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B
            __HH.BTN_ON = c
            __HH.BTN_OFF = c:Lerp(Color3.fromRGB(0, 0, 0), 0.6)
            __HH.TEXT_OFF = Color3.fromRGB(255, 255, 255)
            __HH.TEXT_ON = lum > 0.6 and Color3.fromRGB(20, 10, 40) or Color3.fromRGB(255, 255, 255)
        end
    end
    function hz.setBtn(name)
        hz.btnName = name or "Default"
        setBtnColors(hz.resolve(hz.btnName))
        hz.applyBtns()
        hz.save()
    end

    -- fonts
    hz.FONTS = {"Default","Gotham","GothamBlack","Arcade","Bangers","Creepster","Fredoka","Luckiest Guy",
        "Permanent Marker","Sci-Fi","Oswald","Kalam","Jura","Michroma","Special Elite","Ubuntu","Cartoon",
        "Nunito","Fondamento","Highway","Code","Titillium"}
    local FONT_ENUM = {Gotham="Gotham", GothamBlack="GothamBlack", Arcade="Arcade", Bangers="Bangers",
        Creepster="Creepster", Fredoka="FredokaOne", ["Luckiest Guy"]="LuckiestGuy", ["Permanent Marker"]="PermanentMarker",
        ["Sci-Fi"]="SciFi", Oswald="Oswald", Kalam="Kalam", Jura="Jura", Michroma="Michroma",
        ["Special Elite"]="SpecialElite", Ubuntu="Ubuntu", Cartoon="Cartoon", Nunito="Nunito",
        Fondamento="Fondamento", Highway="Highway", Code="Code", Titillium="TitilliumWeb"}
    local fontOrig = setmetatable({}, {__mode = "k"})
    local fontHooked = setmetatable({}, {__mode = "k"})
    local function fontRoots()
        local t = {}
        local a = hz.mainRoot(); if a then t[#t + 1] = a end
        if __HH.mobGuiRef and __HH.mobGuiRef.Parent then t[#t + 1] = __HH.mobGuiRef end
        local sb = findGui("StealBarGui"); if sb then t[#t + 1] = sb end
        return t
    end
    local function applyFont(d)
        if not (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) then return end
        if fontOrig[d] == nil then fontOrig[d] = d.Font end
        pcall(function() d.Font = hz.fontEnum or fontOrig[d] end)
    end
    local function hookFonts()
        for _, rt in ipairs(fontRoots()) do
            if not fontHooked[rt] then
                fontHooked[rt] = true
                pcall(function()
                    for _, d in ipairs(rt:GetDescendants()) do applyFont(d) end
                    rt.DescendantAdded:Connect(function(d)
                        if hz.fontEnum then task.defer(function() pcall(applyFont, d) end) end
                    end)
                end)
            end
        end
    end
    function hz.setFont(name)
        hz.fontName = name or "Default"
        hz.fontEnum = nil
        local key = FONT_ENUM[hz.fontName]
        if key then
            local ok, v = pcall(function() return Enum.Font[key] end)
            if ok and v then hz.fontEnum = v end
        end
        for _, rt in ipairs(fontRoots()) do
            pcall(function() for _, d in ipairs(rt:GetDescendants()) do applyFont(d) end end)
        end
        hookFonts()
        hz.save()
    end

    function hz.applyAll()
        pcall(function() if hz.guiName ~= "Purple" then hz.setGui(hz.guiName) end end)
        pcall(function() if hz.btnName ~= "Default" then hz.setBtn(hz.btnName) end end)
        pcall(function() if hz.grabName ~= "Default" then hz.setGrab(hz.grabName) end end)
        pcall(function() if hz.fontName ~= "Default" then hz.setFont(hz.fontName) end end)
        if hz._loop then return end
        hz._loop = true
        task.spawn(function()
            local tick2 = 0
            while true do
                task.wait(0.3)
                tick2 = tick2 + 1
                if hz.btnName == "Rainbow" then
                    local c = Color3.fromHSV((os.clock() * 0.25) % 1, 0.75, 1)
                    __HH.BTN_ON = c; __HH.BTN_OFF = c:Lerp(Color3.fromRGB(0, 0, 0), 0.6)
                    pcall(hz.applyBtns)
                end
                if tick2 % 4 == 0 then
                    if math.abs(hz.curGuiHue - BASE_HUE) > 0.003 then pcall(function() sweep(hz.mainRoot(), hz.curGuiHue, hz.curGuiHue) end) end
                    if math.abs(hz.curGrabHue - BASE_HUE) > 0.003 then pcall(function() sweep(findGui("StealBarGui"), hz.curGrabHue, hz.curGrabHue) end) end
                    if hz.fontEnum then pcall(hookFonts) end
                end
            end
        end)
    end
end
-- =======================================================================

local function buildGui()
    local WHITE    = Color3.fromRGB(232, 205, 255)
    local BLACK    = Color3.fromRGB(57, 25, 85)
    local DARK     = Color3.fromRGB(26, 14, 48)
    local DARKER   = Color3.fromRGB(15,  10,  18)
    local MID      = Color3.fromRGB(40,  40,  40)
    local DIM_LINE = Color3.fromRGB(101, 35, 160)
    local CHECK_OFF= Color3.fromRGB(80, 36, 120)
    local BTN_ACT  = Color3.fromRGB(195, 126, 255)
    local INP_BG   = Color3.fromRGB(24, 21, 26)

    for _, name in ipairs({"Polm Hub", "Polm Hub", "Pure hub", "PolmHubMobileButtons", "PureHubMobileButtons", "yousefStealBar", "yousefRagdollTimer"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(name)
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Polm Hub"; gui.ResetOnSpawn = false
    gui.DisplayOrder = 10; gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    __HH.uiScaleObject = Instance.new("UIScale", gui)
    __HH.uiScaleObject.Scale = uiScaleValue

    __HH.mainFrame = Instance.new("Frame", gui)
    __HH.mainFrame.Name = "MainFrame"
    __HH.mainFrame.Size = UDim2.new(0, 580, 0, 650)
    __HH.mainFrame.Position = UDim2.new(0.02, 0, 0.5, -325)
    __HH.mainFrame.BackgroundColor3 = DARK
    __HH.mainFrame.BorderSizePixel = 0
    __HH.mainFrame.ClipsDescendants = true
    Instance.new("UICorner", __HH.mainFrame).CornerRadius = UDim.new(0, 24)

    __HH.bgImage = nil

    local bgOverlay = Instance.new("Frame", __HH.mainFrame)
    bgOverlay.Size = UDim2.new(1,0,1,0); bgOverlay.BackgroundColor3 = DARK
    bgOverlay.BackgroundTransparency = 1
    bgOverlay.BorderSizePixel = 0; bgOverlay.ZIndex = 2
    Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0,24)

    local dragging, dragInput2, dragStart2, startPos2
    __HH.mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart2 = input.Position
            startPos2 = __HH.mainFrame.Position
            dragInput2 = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragInput2 = nil
                end
            end)
        end
    end)
    __HH.mainFrame.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart2
            if delta.Magnitude > 5 then
                __HH.mainFrame.Position = UDim2.new(
                    startPos2.X.Scale,
                    startPos2.X.Offset + delta.X,
                    startPos2.Y.Scale,
                    startPos2.Y.Offset + delta.Y
                )
            end
        end
    end)

    local Header = Instance.new("Frame", __HH.mainFrame)
    Header.Name = "Header"; Header.Size = UDim2.new(1,0,0,65)
    Header.BackgroundTransparency = 1; Header.ZIndex = 3

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(0,300,1,0); Title.Position = UDim2.new(0,14,0,0)
    Title.BackgroundTransparency = 1; Title.Text = "POLM HUB"
    Title.TextColor3 = WHITE; Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.ZIndex = 4

    local HeaderLine = Instance.new("Frame", Header)
    HeaderLine.Size = UDim2.new(1,-28,0,1); HeaderLine.Position = UDim2.new(0,14,1,0)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(200, 138, 255); HeaderLine.BackgroundTransparency = 0.5
    HeaderLine.BorderSizePixel = 0; HeaderLine.ZIndex = 3

    local closeBtn = Instance.new("TextButton", Header)
    closeBtn.Size = UDim2.new(0,24,0,24); closeBtn.Position = UDim2.new(1,-34,0.5,-12)
    closeBtn.BackgroundColor3 = MID; closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"; closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 18; closeBtn.ZIndex = 6
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)
    local closeBtnStroke = Instance.new("UIStroke", closeBtn)
    closeBtnStroke.Color = WHITE; closeBtnStroke.Thickness = 1

    local miniToggleBtn = Instance.new("TextButton", gui)
    miniToggleBtn.Name = "MiniToggle"
    miniToggleBtn.Size = UDim2.new(0, 64, 0, 64)
    miniToggleBtn.Position = UDim2.new(0.02, 0, 0.45, 60)
    miniToggleBtn.BackgroundColor3 = Color3.fromRGB(195, 126, 255)
    miniToggleBtn.Text = "HO"
    miniToggleBtn.TextColor3 = WHITE
    miniToggleBtn.Font = Enum.Font.GothamBlack
    miniToggleBtn.TextSize = 26
    miniToggleBtn.BorderSizePixel = 0
    miniToggleBtn.ZIndex = 100
    miniToggleBtn.Visible = false
    Instance.new("UICorner", miniToggleBtn).CornerRadius = UDim.new(1, 0)
    local miniStroke = Instance.new("UIStroke", miniToggleBtn)
    miniStroke.Color = Color3.fromRGB(162, 56, 255); miniStroke.Thickness = 2.5

    local miniShadow = Instance.new("UIStroke", miniToggleBtn)
    miniShadow.Color = Color3.fromRGB(95, 33, 150); miniShadow.Thickness = 4
    miniShadow.Transparency = 0.7

    miniToggleBtn.MouseButton1Click:Connect(function()
        __HH.mainFrame.Visible = true
        miniToggleBtn.Visible = false
    end)

    local miniDrag, miniDragStart, miniStartPos
    miniToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDrag = true
            miniDragStart = input.Position
            miniStartPos = miniToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then miniDrag = false end
            end)
        end
    end)
    __HH.UIS.InputChanged:Connect(function(input)
        if miniDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - miniDragStart
            miniToggleBtn.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        __HH.mainFrame.Visible = false
        miniToggleBtn.Visible = true
    end)

    -- tab bar on TOP
    local Sidebar = Instance.new("Frame", __HH.mainFrame)
    Sidebar.Name = "TabBar"; Sidebar.Size = UDim2.new(1,0,0,46)
    Sidebar.Position = UDim2.new(0,0,0,67); Sidebar.BackgroundTransparency = 1; Sidebar.ZIndex = 3

    local SidebarLine = Instance.new("Frame", Sidebar)
    SidebarLine.Size = UDim2.new(1,-28,0,1); SidebarLine.Position = UDim2.new(0,14,1,0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(176, 120, 255); SidebarLine.BackgroundTransparency = 0.5
    SidebarLine.BorderSizePixel = 0; SidebarLine.ZIndex = 3

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Size = UDim2.new(1,-20,1,-8); TabContainer.Position = UDim2.new(0,10,0,4)
    TabContainer.BackgroundTransparency = 1; TabContainer.ZIndex = 3
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabListLayout.Padding = UDim.new(0,5); TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentContainer = Instance.new("Frame", __HH.mainFrame)
    ContentContainer.Size = UDim2.new(1,-24,1,-126); ContentContainer.Position = UDim2.new(0,12,0,118)
    ContentContainer.BackgroundTransparency = 1; ContentContainer.ZIndex = 3

    local currentTab = nil
    local TabRefs = {contents = {}, btns = {}, underlines = {}, active = "Speed"}
    local TabList = {"Speed","Combat","Mechns","Visual","Extra","Mobile"}

    for i, name in ipairs(TabList) do
        local wrapper = Instance.new("Frame", TabContainer)
        wrapper.Size = UDim2.new(0,88,0,32)
        wrapper.BackgroundTransparency = 1
        wrapper.LayoutOrder = i

        local btn = Instance.new("TextButton", wrapper)
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundTransparency = (i == 1) and 0.6 or 1
        btn.BackgroundColor3 = Color3.fromRGB(198, 134, 255)
        local tabDisplay = {Speed="Speed Boost", Combat="Important", Mechns="Key Bind", Visual="Visual", Extra="Settings", Mobile="Mobile"}
        btn.Text = tabDisplay[name] or name
        btn.TextColor3 = WHITE
        btn.TextTransparency = (i == 1) and 0 or 0.5
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,14)
        local tabStroke = Instance.new("UIStroke", btn); tabStroke.Color = Color3.fromRGB(200, 170, 255); tabStroke.Thickness = 1; tabStroke.Transparency = 0.55

        TabRefs.btns[name] = btn

        local page = Instance.new("ScrollingFrame", ContentContainer)
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = WHITE
        page.Visible = (i == 1)
        page.ZIndex = 3
        local pageLayout = Instance.new("UIListLayout", page)
        pageLayout.Padding = UDim.new(0,10)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local pagePad = Instance.new("UIPadding", page)
        pagePad.PaddingLeft = UDim.new(0,4)
        pagePad.PaddingRight = UDim.new(0,8)
        pagePad.PaddingTop = UDim.new(0,6)
        pagePad.PaddingBottom = UDim.new(0,6)

        TabRefs.contents[name] = page

        if i == 1 then
            currentTab = {Btn = btn, Pg = page}
        end

        btn.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Btn.BackgroundTransparency = 1
                currentTab.Btn.TextTransparency = 0.5
                currentTab.Pg.Visible = false
            end
            btn.BackgroundTransparency = 0.6
            btn.TextTransparency = 0
            page.Visible = true
            currentTab = {Btn = btn, Pg = page}
            TabRefs.active = name
        end)
    end

    local function mkSect(parent, txt)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1,0,0,16); f.BackgroundTransparency = 1
        f.LayoutOrder = #parent:GetChildren() + 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
        l.Text = txt:upper(); l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBlack; l.TextSize = 9
        l.TextXAlignment = Enum.TextXAlignment.Left
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1,0,0,1); line.Position = UDim2.new(0,0,1,-1)
        line.BackgroundColor3 = WHITE; line.BackgroundTransparency = 0.75; line.BorderSizePixel = 0
    end

    local function mkRow(parent)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1,0,0,32); f.BackgroundTransparency = 1
        f.LayoutOrder = #parent:GetChildren() + 1
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.6,0,1,0); l.Position = UDim2.new(0,0,0,0)
        l.BackgroundTransparency = 1; l.Text = txt
        l.TextColor3 = WHITE; l.Font = Enum.Font.GothamBold
        l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
    end

    -- ON/OFF switch (pill + sliding knob) used instead of the old small squares
    local function mkSwitch(row, initState)
        local offCol = function() return __HH.TOGGLE_OFF_COLOR or CHECK_OFF end
        local track = Instance.new("TextButton", row)
        track.Name = "Switch"
        track.Size = UDim2.new(0,46,0,22); track.Position = UDim2.new(1,-52,0.5,-11)
        track.BackgroundColor3 = initState and __HH.TOGGLE_ON_COLOR or offCol()
        track.BorderSizePixel = 0; track.Text = ""; track.AutoButtonColor = false; track.ZIndex = 5
        Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
        local tst = Instance.new("UIStroke", track); tst.Color = WHITE; tst.Thickness = 1; tst.Transparency = 0.45
        local txt = Instance.new("TextLabel", track)
        txt.BackgroundTransparency = 1; txt.Size = UDim2.new(0,24,1,0); txt.Font = Enum.Font.GothamBlack
        txt.TextSize = 8; txt.TextColor3 = Color3.fromRGB(255,255,255); txt.ZIndex = 6
        local knob = Instance.new("Frame", track)
        knob.Name = "Knob"; knob.Size = UDim2.new(0,16,0,16); knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        knob.BorderSizePixel = 0; knob.ZIndex = 7
        knob:SetAttribute("NoTheme", true); txt:SetAttribute("NoTheme", true)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
        local ks = Instance.new("UIStroke", knob); ks.Color = Color3.fromRGB(0,0,0); ks.Thickness = 1; ks.Transparency = 0.8
        local function paint(on, animate)
            local goalPos = on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
            txt.Text = on and "ON" or "OFF"
            txt.Position = on and UDim2.new(0,6,0,0) or UDim2.new(1,-28,0,0)
            txt.TextXAlignment = on and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
            local col = on and __HH.TOGGLE_ON_COLOR or offCol()
            if animate then
                TS:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Position = goalPos}):Play()
                TS:Create(track, TweenInfo.new(0.16), {BackgroundColor3 = col}):Play()
            else
                knob.Position = goalPos; track.BackgroundColor3 = col
            end
        end
        paint(initState == true, false)
        return track, paint
    end

    local function mkToggle(parent, txt, cb, initVal)
        local row = mkRow(parent)
        mkLabel(row, txt)
        local state = initVal == true
        local chk, paint = mkSwitch(row, state)
        local function sv(s)
            state = s
            paint(s, true)
        end
        chk.MouseButton1Click:Connect(function()
            if __HH._anyKeyListening then return end
            state = not state; sv(state); cb(state)
        end)
        return sv
    end

    local function mkBoxRow(parent, txt, default, cb)
        local row = mkRow(parent)
        mkLabel(row, txt)
        local tb = Instance.new("TextBox", row)
        tb.Size = UDim2.new(0,60,0,22); tb.Position = UDim2.new(1,-65,0.5,-11)
        tb.BackgroundColor3 = INP_BG; tb.Text = tostring(default)
        tb.TextColor3 = WHITE; tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11; tb.ClearTextOnFocus = false; tb.ZIndex = 5
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0,10)
        local bs = Instance.new("UIStroke", tb); bs.Color = DIM_LINE; bs.Thickness = 1
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color=WHITE}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color=DIM_LINE}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    local function mkKB(parent, kbEntry, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0,40,0,18); btn.Position = UDim2.new(1,-110,0.5,-9)
        btn.BackgroundColor3 = INP_BG; btn.BorderSizePixel = 0
        local function getLabel()
            return (kbEntry.gp and __HH.getKeyDisplayName(kbEntry.gp, true)) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        end
        btn.Text = getLabel(); btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 8; btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
        local bs = Instance.new("UIStroke", btn); bs.Color = DIM_LINE; bs.Thickness = 1
        local li, lc, pv, listenStart = false, nil, btn.Text, 0
        btn.MouseButton1Click:Connect(function()
            if li then
                li = false; __HH._anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return
            end
            pv = btn.Text; li = true; __HH._anyKeyListening = true; listenStart = tick(); btn.Text = "..."
            lc = __HH.UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false; __HH._anyKeyListening = false
                    if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return
                end
                local isGp = __HH.isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not __HH.isBindableInput(inp) then return end
                btn.Text = __HH.getKeyDisplayName(inp.KeyCode, isGp)
                pv = btn.Text; li = false; __HH._anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                if cb then cb(inp.KeyCode, isGp) end
            end)
        end)
        return btn
    end

    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row = mkRow(parent)
        mkLabel(row, txt)
        if kbEntry then
            mkKB(row, kbEntry, function(k, isGp)
                if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end
                if onKB then onKB(k, isGp) end
            end)
        end
        local state = false
        local chk, paint = mkSwitch(row, false)
        local function sv(s)
            state = s
            paint(s, true)
        end
        chk.MouseButton1Click:Connect(function()
            if __HH._anyKeyListening then return end
            state = not state; sv(state); if onToggle then onToggle(state) end
        end)
        return sv
    end

    local function mkActionRow(parent, txt, onActivate, kbEntry)
        local row = mkRow(parent)
        mkLabel(row, txt)
        if kbEntry then
            mkKB(row, kbEntry, function(k, isGp)
                if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end
                saveConfig()
            end)
        end
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0,40,0,20); btn.Position = UDim2.new(1,-46,0.5,-10)
        btn.BackgroundColor3 = BTN_ACT; btn.BorderSizePixel = 0
        btn.Text = ">"; btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBlack; btn.TextSize = 10
        btn.AutoButtonColor = false; btn.ZIndex = 5
        btn.Size = UDim2.new(0,46,0,22); btn.Position = UDim2.new(1,-52,0.5,-11)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
        local bg2 = Instance.new("UIGradient", btn); bg2.Rotation = 90
        bg2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(165,165,165))})
        local bs = Instance.new("UIStroke", btn); bs.Color = WHITE; bs.Thickness = 1; bs.Transparency = 0.35
        btn.MouseButton1Click:Connect(function()
            TS:Create(btn, TweenInfo.new(0.06), {BackgroundColor3 = Color3.fromRGB(198, 134, 255)}):Play()
            TS:Create(btn, TweenInfo.new(0.06), {TextColor3 = BLACK}):Play()
            task.delay(0.14, function()
                TS:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = BTN_ACT}):Play()
                TS:Create(btn, TweenInfo.new(0.1), {TextColor3 = WHITE}):Play()
            end)
            if onActivate then onActivate() end
        end)
        return row
    end

    local sfSpeed   = TabRefs.contents["Speed"]
    local sfCombat  = TabRefs.contents["Combat"]
    local sfMechns  = TabRefs.contents["Mechns"]
    local sfVisual  = TabRefs.contents["Visual"]
    local sfExtra   = TabRefs.contents["Extra"]
    local sfMobile  = TabRefs.contents["Mobile"]

    -- ─── Shared Reset All Settings logic ───────────────────────────────────
    -- Wipes every saved toggle/speed/keybind/UI setting back to the script's
    -- hardcoded defaults. Does NOT touch the selected device (PC/Mobile/
    -- Controller) — that is what "Reset Device" is for. Used by both the
    -- Extra tab and Mobile tab "Reset All Settings" buttons.
    local function performResetAllSettings()
        -- Turn off anything currently running so the reset takes effect
        -- immediately, not just on the next join.
        pcall(function() if __HH.tpLockEnabled and stopTPLock then stopTPLock() end end)
        pcall(function() if __HH.batV2Enabled and toggleBatV2 then toggleBatV2() end end)
        pcall(function() if autoLeftEnabled and stopAutoLeft then autoLeftEnabled = false; stopAutoLeft() end end)
        pcall(function() if autoRightEnabled and stopAutoRight then autoRightEnabled = false; stopAutoRight() end end)
        pcall(function() if __HH.antiRagdollEnabled and __HH.stopAntiRagdoll then __HH.stopAntiRagdoll() end end)
        pcall(function() if __HH.medusaCounterEnabled and stopMedusaCounter then stopMedusaCounter() end end)
        pcall(function() if __HH.batCounterEnabled and stopBatCounter then stopBatCounter() end end)
        pcall(function() if __HH.unwalkEnabled and __HH.stopUnwalk then __HH.stopUnwalk() end end)
        pcall(function() if __HH.antiLagEnabled and disableAntiLag then disableAntiLag() end end)
        pcall(function() if __HH.stretchRezEnabled and disableStretchRez then disableStretchRez() end end)
        pcall(function() if __HH.autoTPEnabled and __HH.stopAutoTP then __HH.stopAutoTP() end end)
        pcall(function() if __HH.antiDieEnabled and __HH.stopAntiDie then __HH.stopAntiDie() end end)
        pcall(function() if __HH.espEnabled and stopPlayerESP then stopPlayerESP() end end)
        pcall(function() if __HH.bodyLockEnabled and __HH.stopBodyLock then __HH.stopBodyLock() end end)
        pcall(function() if __HH.headlessEnabled and applyHeadless and LP.Character then applyHeadless(LP.Character, false) end end)
        pcall(function() if __HH.korbloxEnabled and applyKorblox and LP.Character then applyKorblox(LP.Character, false) end end)
        pcall(function() if applyAccessoryPack then applyAccessoryPack("Off") end end)
        pcall(function() if _G.PureSpinBot and _G.PureSpinBot.enabled and _G.PureSpinBot.stop then _G.PureSpinBot.enabled = false; _G.PureSpinBot.stop() end end)
        pcall(function() if _G.PolmStealModes then _G.PolmStealModes.SetEnabled(false) end end)
        pcall(function() if _G.PureMirrorTPDown and _G.PureMirrorTPDown.setEnabled then _G.PureMirrorTPDown.setEnabled(false) end end)
        pcall(function() if _G.PureBatSpam and _G.PureBatSpam.setEnabled then _G.PureBatSpam.setEnabled(false) end end)
        pcall(function() if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setEnabled then _G.Round3SpeedBooster.setEnabled(false) end end)

        -- Speeds / numeric values back to script defaults.
        NS = 60; CS = 30
        LAGGER_SPEED = 13; LAGGER_CARRY_SPEED = 13
        aimbotV1Speed = 56
        autoCarrySpeedEnabled = false
        carrySpeedActive = false; laggerModeEnabled = false; laggerCarryToggled = false
        speedMode = false; laggerPhase = 0
        pcall(function()
            if _G.Round3SpeedBooster then
                if _G.Round3SpeedBooster.setNormalSpeed then _G.Round3SpeedBooster.setNormalSpeed(62) end
                if _G.Round3SpeedBooster.setCarrySpeed then _G.Round3SpeedBooster.setCarrySpeed(32) end
                if _G.Round3SpeedBooster.setForceCarry then _G.Round3SpeedBooster.setForceCarry(false) end
            end
        end)
        batAimMode = "normal"
        uiScaleValue = 0.6
        __HH.autoTPHeight = 20
        __HH.floatHeight = 6
        __HH.mobileButtonsSize = 80
        __HH.bodyLockRange = 20
        __HH.currentSkyTheme = "Off"
        currentAccessoryPack = "Off"
        __HH.aceSelectedAnimationPack = "OFF"

        -- Toggles back to OFF / defaults.
        __HH.antiRagdollEnabled = false
        __HH.infJumpEnabled = false
        __HH.infJumpMode = "manual"
        __HH.medusaCounterEnabled = false
        __HH.medusaResetEnabled = false
        __HH.batCounterEnabled = false
        __HH.unwalkEnabled = false
        __HH.antiLagEnabled = false
        __HH.stretchRezEnabled = false
        __HH.autoTPEnabled = false
        __HH.autoJumpBrainrot = false
        __HH.floatEnabled = false
        __HH.guiTransparencyEnabled = false
        __HH.circleButtonsEnabled = false
        __HH.shapeButtonsEnabled = false
        __HH.rectangularButtonsEnabled = false
        __HH.antiDieEnabled = false
        __HH.autoResetOnDeath = false
        __HH.uiLocked = false; _G.YousefUiLocked = false
        __HH.perButtonDragEnabled = true
        __HH.batV2Enabled = false
        __HH.espEnabled = false
        __HH.headlessEnabled = false
        __HH.korbloxEnabled = false
        __HH.bodyLockEnabled = false
        __HH.antiFlingEnabled = false
        __HH.tpLockEnabled = false
        autoSwingEnabled = false
        autoLeftEnabled = false; autoRightEnabled = false
        antiKickEnabled = false

        -- Mobile-specific settings back to defaults.
        __HH.mobileButtonsEnabled = (__HH.selectedDevice == "MOBILE")

        -- Keybinds back to their original defaults.
        __HH.KB.DropBrainrot  = {kb = Enum.KeyCode.X,           gp = nil}
        __HH.KB.TPLock        = {kb = Enum.KeyCode.E,           gp = nil}
        __HH.KB.TPFloor       = {kb = Enum.KeyCode.F,           gp = nil}
        __HH.KB.GuiHide       = {kb = Enum.KeyCode.LeftControl, gp = nil}
        __HH.KB.SpeedToggle   = {kb = Enum.KeyCode.Q,           gp = nil}
        __HH.KB.LaggerToggle  = {kb = Enum.KeyCode.G,           gp = nil}
        __HH.KB.InstaReset    = {kb = Enum.KeyCode.R,           gp = nil}
        __HH.KB.AutoLeft      = {kb = Enum.KeyCode.Z,           gp = nil}
        __HH.KB.AutoRight     = {kb = Enum.KeyCode.C,           gp = nil}
        __HH.KB.BatV2Toggle   = {kb = Enum.KeyCode.V,           gp = nil}

        -- Button visibility (mobile buttons) back to all-on.
        __HH.buttonVisibility = {
            drop=true, tpDown=true, batV1=true, batV2=true, tpLock=true,
            lagger=true, laggerCarry=true, carrySpeed=true,
            instaReset=true,
        }

        -- Reset saved mobile button positions too, so "Reset All Settings"
        -- from the Mobile tab also puts the floating buttons back at their
        -- default layout.
        pcall(function() if writefile then writefile(MOB_POS_FILE, "{}") end end)

        -- Persist the wipe immediately, then rebuild the whole UI so every
        -- toggle/keybind label reflects the new defaults without needing a
        -- rejoin.
        saveConfig()
        task.delay(0.3, function()
            pcall(function()
                if __HH.mainFrame then __HH.mainFrame:Destroy() end
                buildGui()
                applyState()
                if __HH.mobileButtonsEnabled and buildMobileButtons then task.spawn(buildMobileButtons)
                elseif destroyMobileButtons then destroyMobileButtons() end
                if __HH.mainFrame then __HH.mainFrame.Visible = true end
            end)
        end)
    end

    -- Attaches a two-click "arm/confirm" reset flow to any button, calling
    -- performResetAllSettings() and optionally flashing a status message.
    local function wireResetAllButton(btn, defaultText, flashStatusFn)
        local armed = false
        local armedUntil = 0
        btn.MouseButton1Click:Connect(function()
            if not armed or tick() > armedUntil then
                armed = true
                armedUntil = tick() + 3
                btn.Text = "Confirm?"
                task.delay(3, function()
                    if armed and tick() > armedUntil - 0.05 then
                        armed = false
                        btn.Text = defaultText
                    end
                end)
                return
            end
            armed = false
            btn.Text = defaultText
            performResetAllSettings()
            if flashStatusFn then flashStatusFn("All settings reset to default!") end
        end)
    end

    -- Speed control helper: label + [-] [value box] [+] buttons
    local function mkSpeedCtrl(parent, txt, getVal, setVal, step)
        step = step or 5
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,0,0,32); row.BackgroundTransparency = 1
        row.LayoutOrder = #parent:GetChildren() + 1
        mkLabel(row, txt)
        local minBtn = Instance.new("TextButton", row)
        minBtn.Size = UDim2.new(0,24,0,22); minBtn.Position = UDim2.new(1,-148,0.5,-11)
        minBtn.BackgroundColor3 = BTN_ACT; minBtn.BorderSizePixel = 0
        minBtn.Text = "-"; minBtn.TextColor3 = WHITE
        minBtn.Font = Enum.Font.GothamBlack; minBtn.TextSize = 15
        minBtn.AutoButtonColor = false; minBtn.ZIndex = 5
        Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,5)
        local mStroke = Instance.new("UIStroke", minBtn); mStroke.Color = WHITE; mStroke.Thickness = 1
        local valTb = Instance.new("TextBox", row)
        valTb.Size = UDim2.new(0,52,0,22); valTb.Position = UDim2.new(1,-120,0.5,-11)
        valTb.BackgroundColor3 = INP_BG; valTb.Text = tostring(getVal())
        valTb.TextColor3 = WHITE; valTb.Font = Enum.Font.GothamBold
        valTb.TextSize = 11; valTb.ClearTextOnFocus = false
        valTb.TextXAlignment = Enum.TextXAlignment.Center; valTb.ZIndex = 5
        Instance.new("UICorner", valTb).CornerRadius = UDim.new(0,5)
        local tbStroke = Instance.new("UIStroke", valTb); tbStroke.Color = DIM_LINE; tbStroke.Thickness = 1
        valTb.Focused:Connect(function() TS:Create(tbStroke, TweenInfo.new(0.12), {Color=WHITE}):Play() end)
        valTb.FocusLost:Connect(function()
            TS:Create(tbStroke, TweenInfo.new(0.12), {Color=DIM_LINE}):Play()
            local n = tonumber(valTb.Text)
            if n then setVal(math.clamp(math.floor(n), 1, 500)) end
            valTb.Text = tostring(getVal())
        end)
        local plusBtn = Instance.new("TextButton", row)
        plusBtn.Size = UDim2.new(0,24,0,22); plusBtn.Position = UDim2.new(1,-64,0.5,-11)
        plusBtn.BackgroundColor3 = BTN_ACT; plusBtn.BorderSizePixel = 0
        plusBtn.Text = "+"; plusBtn.TextColor3 = WHITE
        plusBtn.Font = Enum.Font.GothamBlack; plusBtn.TextSize = 15
        plusBtn.AutoButtonColor = false; plusBtn.ZIndex = 5
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,5)
        local pStroke = Instance.new("UIStroke", plusBtn); pStroke.Color = WHITE; pStroke.Thickness = 1
        local function flash(b)
            TS:Create(b, TweenInfo.new(0.07), {BackgroundColor3=WHITE}):Play()
            task.delay(0.14, function() TS:Create(b, TweenInfo.new(0.10), {BackgroundColor3=BTN_ACT}):Play() end)
        end
        minBtn.MouseButton1Click:Connect(function()
            setVal(math.max(1, getVal() - step)); valTb.Text = tostring(getVal()); flash(minBtn)
        end)
        plusBtn.MouseButton1Click:Connect(function()
            setVal(math.min(500, getVal() + step)); valTb.Text = tostring(getVal()); flash(plusBtn)
        end)
    end

    mkSect(sfSpeed, "Speed Values")
    local grabSpeedTb
    mkBoxRow(sfSpeed, "Normal Speed", NS, function(v)
        if v>0 and v<=500 then
            NS=v; CS=math.max(1, math.floor(NS/2)); saveConfig()
            -- Grab Speed is auto-derived from Normal Speed, so its own
            -- textbox must reflect the new value immediately instead of
            -- showing a stale number until the panel is reopened.
            if grabSpeedTb then grabSpeedTb.Text = tostring(CS) end
        end
    end)
    grabSpeedTb = mkBoxRow(sfSpeed, "Grab Speed",   CS, function(v) if v>0 and v<=500 then CS=v; saveConfig() end end)
    mkBoxRow(sfSpeed, "Lagger Normal", LAGGER_SPEED, function(v) if v>0 and v<=500 then LAGGER_SPEED=v end; saveConfig() end)
    mkBoxRow(sfSpeed, "Lagger Carry", LAGGER_CARRY_SPEED, function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end; saveConfig() end)
    mkBoxRow(sfSpeed, "AIM BOT Speed", aimbotV1Speed, function(v) if v>0 and v<=500 then aimbotV1Speed=v end; saveConfig() end)
    setAutoCarrySpeedVisual = mkToggle(sfSpeed, "Auto Switch Speed", function(on)
        autoCarrySpeedEnabled = on
        if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
        saveConfig()
    end, autoCarrySpeedEnabled)

    mkSect(sfSpeed, "Round 3 Speed Boost")
    mkToggle(sfSpeed, "ROUND 3 SPEED", function(on)
        if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setEnabled then
            _G.Round3SpeedBooster.setEnabled(on)
        end
        saveConfig()
    end, (_G.Round3SpeedBooster and _G.Round3SpeedBooster.Enabled) == true)
    mkBoxRow(sfSpeed, "Normal Speed", (_G.Round3SpeedBooster and _G.Round3SpeedBooster.NormalSpeed) or 62, function(v)
        if v>0 and v<=500 then
            if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setNormalSpeed then
                _G.Round3SpeedBooster.setNormalSpeed(v)
            end
        end
        saveConfig()
    end)
    mkBoxRow(sfSpeed, "Carry Speed", (_G.Round3SpeedBooster and _G.Round3SpeedBooster.CarrySpeed) or 32, function(v)
        if v>0 and v<=500 then
            if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setCarrySpeed then
                _G.Round3SpeedBooster.setCarrySpeed(v)
            end
        end
        saveConfig()
    end)
    mkToggle(sfSpeed, "Force Carry", function(on)
        if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setForceCarry then
            _G.Round3SpeedBooster.setForceCarry(on)
        end
        saveConfig()
    end, (_G.Round3SpeedBooster and _G.Round3SpeedBooster.ForceCarry) == true)

    mkSect(sfCombat, "Combat")
    setAutoSwingVisual   = mkToggle(sfCombat, "Auto Swing",     function(on) autoSwingEnabled=on; saveConfig() end, autoSwingEnabled)
    if _G.PureSpinBot then
        _G.PureSpinBot.setVisual = mkToggle(sfCombat, "SPIN BOT", function(on)
            _G.PureSpinBot.setEnabled(on)
            saveConfig()
        end, _G.PureSpinBot.enabled)
    end
    setAntiRagVisual     = mkToggle(sfCombat, "Anti Ragdoll",   function(on) __HH.antiRagdollEnabled=on; if on then __HH.startAntiRagdoll() else __HH.stopAntiRagdoll() end; saveConfig() end, __HH.antiRagdollEnabled)
    setMedusaResetVisual = mkToggle(sfCombat, "Medusa Reset",   function(on) __HH.medusaResetEnabled=on; saveConfig() end, __HH.medusaResetEnabled)
    setUnwalkVisual      = mkToggle(sfCombat, "Unwalk",         function(on) __HH.unwalkEnabled=on; if on then __HH.startUnwalk() else __HH.stopUnwalk() end; saveConfig() end, __HH.unwalkEnabled)

    mkSect(sfCombat, "Body Protection")
    __HH.setBodyLockVisual = mkToggle(sfCombat, "Body Lock", function(on)
        __HH.bodyLockEnabled=on==true
        if on and not __HH.batV2Enabled and not __HH.tpLockEnabled then __HH.startBodyLock() else __HH.stopBodyLock() end
        saveConfig()
    end, __HH.bodyLockEnabled)
    mkBoxRow(sfCombat, "Body Lock Range", __HH.bodyLockRange, function(v) __HH.bodyLockRange=math.clamp(math.floor(v),5,200);saveConfig() end)
    __HH.setAntiFlingVisual = mkToggle(sfCombat, "Anti Fling", function(on) __HH.antiFlingEnabled=on==true;saveConfig() end, __HH.antiFlingEnabled)

    mkSect(sfCombat, "Yousef")
    __HH.setBatCounterVisual  = mkToggle(sfCombat, "Bat Counter",    function(on) __HH.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end; saveConfig() end, __HH.batCounterEnabled)
    setMedusaVisual      = mkToggle(sfCombat, "Medusa Counter", function(on) __HH.medusaCounterEnabled=on; if on then setupMedusa(LP.Character) else stopMedusaCounter() end; saveConfig() end, __HH.medusaCounterEnabled)




    _G.PureMirrorTPDownSetVisual = mkToggle(sfCombat, "MIRROR TP DOWN", function(on)
        if _G.PureMirrorTPDown and _G.PureMirrorTPDown.setEnabled then
            _G.PureMirrorTPDown.setEnabled(on)
        end
        saveConfig()
    end, (_G.PureMirrorTPDown and _G.PureMirrorTPDown.enabled
        and _G.PureMirrorTPDown.enabled()) == true)

    _G.PureBatSpamSetVisual = mkToggle(sfCombat, "Bat Spam", function(on)
        if _G.PureBatSpam and _G.PureBatSpam.setEnabled then
            _G.PureBatSpam.setEnabled(on)
        end
        saveConfig()
    end, (_G.PureBatSpam and _G.PureBatSpam.enabled
        and _G.PureBatSpam.enabled()) == true)

    __HH.setAntiDieVisual = mkToggle(sfCombat, "Anti Die", function(on)
        __HH.antiDieEnabled = on
        if on then __HH.startAntiDie() else __HH.stopAntiDie() end
        saveConfig()
    end, __HH.antiDieEnabled)

    __HH.setAutoResetOnDeathVisual = mkToggle(sfCombat, "Instant Reset on Die", function(on)
        __HH.autoResetOnDeath = on
        if on and __HH.antiDieEnabled then
            __HH.antiDieEnabled = false
            __HH.stopAntiDie()
            if __HH.setAntiDieVisual then __HH.setAntiDieVisual(false) end
        end
        __HH.setupDeathReset()
        saveConfig()
    end, __HH.autoResetOnDeath)

    mkSect(sfMechns, "Actions")
    mkActionRow(sfMechns, "Speed Toggle",  nil, __HH.KB.SpeedToggle)
    mkActionRow(sfMechns, "Lagger Toggle", nil, __HH.KB.LaggerToggle)
    mkActionRow(sfMechns, "Insta Reset",   function() __HH.FrameReset.ResetPlayer() end, __HH.KB.InstaReset)
    mkActionRow(sfMechns, "Drop Brainrot", function() runDrop() end,     __HH.KB.DropBrainrot)
    mkActionRow(sfMechns, "TP Down",       function() __HH.tpToGround() end,  __HH.KB.TPFloor)
    mkActionRow(sfMechns, "Hide GUI",      function() if __HH.mainFrame then __HH.mainFrame.Visible = not __HH.mainFrame.Visible end end, __HH.KB.GuiHide)

    mkSect(sfMechns, "Toggles")
    __HH.tpLockSetVisual = mkToggleKB(sfMechns, "TP BAT", __HH.KB.TPLock, function(on)
        if __HH._anyKeyListening then return end
        if on then
            
            if __HH.batV2Enabled then toggleBatV2() end
            toggleTPLock()
        else if __HH.tpLockEnabled then toggleTPLock() end end
        saveConfig()
    end, function() saveConfig() end)
    __HH.tpLockSetVisual(__HH.tpLockEnabled)

    __HH.batV2SetVisual = mkToggleKB(sfMechns, "AIM BOT", __HH.KB.BatV2Toggle, function(on)
        if __HH._anyKeyListening then return end
        if on then
            if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart(true) then
                if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
                return
            end
            if __HH.tpLockEnabled then toggleTPLock() end
            toggleBatV2()
        else
            if __HH.batV2Enabled then toggleBatV2() end
        end
        saveConfig()
    end, function() saveConfig() end)
    __HH.batV2SetVisual(__HH.batV2Enabled)


    do
        local mRow = mkRow(sfMechns); mkLabel(mRow, "AIM Mode")
        local mBtns = {}
        local function mkAimModeBtn(lbl, xOff, mode)
            local b = Instance.new("TextButton", mRow)
            b.Size = UDim2.new(0,58,0,20); b.Position = UDim2.new(1,xOff,0.5,-10)
            b.BackgroundColor3 = (batAimMode==mode) and WHITE or BTN_ACT
            b.BorderSizePixel = 0; b.Text = lbl
            b.TextColor3 = (batAimMode==mode) and BLACK or Color3.fromRGB(180,180,200)
            b.Font = Enum.Font.GothamBold; b.TextSize = 8; b.AutoButtonColor = false; b.ZIndex = 5
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            table.insert(mBtns, b)
            b.MouseButton1Click:Connect(function()
                if batAimMode == mode then return end
                batAimMode = mode
                b.BackgroundColor3 = WHITE; b.TextColor3 = BLACK
                for _, ob in ipairs(mBtns) do
                    if ob ~= b then
                        ob.BackgroundColor3 = BTN_ACT; ob.TextColor3 = Color3.fromRGB(180,180,200)
                    end
                end
                if __HH.batV2Enabled then
                    stopAimbotFull()
                    queueAutoBatStart()
                    if __HH.batV2SetVisual then __HH.batV2SetVisual(true) end
                    if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(true) end
                end
                saveConfig()
            end)
            return b
        end
        mkAimModeBtn("Normal", -122, "normal")
        mkAimModeBtn("Bypass", -58,  "bypass")
    end
    autoLeftSetVisual = mkToggleKB(sfMechns, "Auto Left", __HH.KB.AutoLeft, function(on)
        if __HH._anyKeyListening then return end
        autoLeftEnabled = on
        if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(on) end
        if on then startAutoLeft() else stopAutoLeft() end
        saveConfig()
    end, function() saveConfig() end)
    autoLeftSetVisual(autoLeftEnabled)

    autoRightSetVisual = mkToggleKB(sfMechns, "Auto Right", __HH.KB.AutoRight, function(on)
        if __HH._anyKeyListening then return end
        autoRightEnabled = on
        if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(on) end
        if on then startAutoRight() else stopAutoRight() end
        saveConfig()
    end, function() saveConfig() end)
    autoRightSetVisual(autoRightEnabled)


    mkSect(sfCombat, "Auto Steal")
    do
        local bridge = _G.PolmStealModes
        mkToggle(sfCombat, "Auto Steal", function(on) if bridge then bridge.SetEnabled(on) end end, bridge and bridge.GetEnabled() or false)
        local row=mkRow(sfCombat);mkLabel(row,"Steal Mode")
        local iBtn=Instance.new("TextButton",row);iBtn.Size=UDim2.new(0,58,0,20);iBtn.Position=UDim2.new(1,-122,.5,-10);iBtn.Text="Instant";iBtn.Font=Enum.Font.GothamBold;iBtn.TextSize=8;iBtn.BorderSizePixel=0;iBtn.ZIndex=5;Instance.new("UICorner",iBtn).CornerRadius=UDim.new(0,4)
        local sBtn=Instance.new("TextButton",row);sBtn.Size=UDim2.new(0,58,0,20);sBtn.Position=UDim2.new(1,-58,.5,-10);sBtn.Text="Semi";sBtn.Font=Enum.Font.GothamBold;sBtn.TextSize=8;sBtn.BorderSizePixel=0;sBtn.ZIndex=5;Instance.new("UICorner",sBtn).CornerRadius=UDim.new(0,4)
        local function paint(m) iBtn.BackgroundColor3=m=="Instant" and WHITE or BTN_ACT;sBtn.BackgroundColor3=m=="Semi" and WHITE or BTN_ACT;iBtn.TextColor3=m=="Instant" and BLACK or WHITE;sBtn.TextColor3=m=="Semi" and BLACK or WHITE end
        iBtn.MouseButton1Click:Connect(function() if bridge then bridge.SetMode("Instant");paint("Instant") end end)
        sBtn.MouseButton1Click:Connect(function() if bridge then bridge.SetMode("Semi");paint("Semi") end end);paint(bridge and bridge.GetMode() or "Instant")
        mkBoxRow(sfCombat,"Radius",bridge and bridge.GetRadius() or 61,function(v) if bridge then bridge.SetRadius(v) end end)
    end

    mkSect(sfCombat, "Misc")
    setSafeModeVisual = mkToggle(sfCombat, "Anti Kick", function(on)
        antiKickEnabled = on
        if on and _G.AceSafeModeIsLocked and _G.AceSafeModeIsLocked()
            and _G.AceSafeModeForceStop then
            _G.AceSafeModeForceStop("AIM BOT BEFORE START")
        end
        saveConfig()
    end, antiKickEnabled)
    __HH.setInfJumpVisual = mkToggle(sfCombat, "Infinite Jump", function(on)
        __HH.infJumpEnabled = on
        if __HH.infJumpEnabled then if __HH.infJumpMode == "hold" then __HH.startHoldInfJump() end
        else __HH.stopHoldInfJump() end
        saveConfig()
    end, __HH.infJumpEnabled)

    -- Jump Mode selector: Manual / Hold
    do
        local jRow = mkRow(sfCombat); mkLabel(jRow, "Jump Mode")
        local jBtns = {}
        local function mkJumpModeBtn(lbl, xOff, mode)
            local b = Instance.new("TextButton", jRow)
            b.Size = UDim2.new(0,52,0,20); b.Position = UDim2.new(1,xOff,0.5,-10)
            b.BackgroundColor3 = (__HH.infJumpMode==mode) and WHITE or BTN_ACT
            b.BorderSizePixel = 0; b.Text = lbl
            b.TextColor3 = (__HH.infJumpMode==mode) and BLACK or Color3.fromRGB(180,180,200)
            b.Font = Enum.Font.GothamBold; b.TextSize = 8; b.AutoButtonColor = false; b.ZIndex = 5
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            table.insert(jBtns, b)
            b.MouseButton1Click:Connect(function()
                if __HH.infJumpMode == mode then return end
                __HH.infJumpMode = mode
                b.BackgroundColor3 = WHITE; b.TextColor3 = BLACK
                for _, ob in ipairs(jBtns) do
                    if ob ~= b then
                        ob.BackgroundColor3 = BTN_ACT; ob.TextColor3 = Color3.fromRGB(180,180,200)
                    end
                end
                __HH.stopHoldInfJump()
                if __HH.infJumpEnabled and mode == "hold" then __HH.startHoldInfJump() end
                saveConfig()
            end)
            return b
        end
        mkJumpModeBtn("Manual", -110, "manual")
        mkJumpModeBtn("Hold",    -54,  "hold")
    end

    mkSect(sfCombat, "Auto Jump - Brainrot")
    __HH.setAutoJumpBrainrotVisual = mkToggle(sfCombat, "Auto Jump while holding", function(on)
        __HH.autoJumpBrainrot = on
        saveConfig()
    end, __HH.autoJumpBrainrot)

    mkSect(sfCombat, "Float")
    __HH.setFloatVisual = mkToggle(sfCombat, "Float", function(on)
        __HH.floatEnabled = on
        if __HH.FRFloat then __HH.FRFloat.setEnabled(on) end
        saveConfig()
    end, __HH.floatEnabled)
    do
        local fRow = mkRow(sfCombat)
        mkLabel(fRow, "Float Height (studs)")
        local fBox = Instance.new("TextBox", fRow)
        fBox.Size = UDim2.new(0,70,0,20); fBox.Position = UDim2.new(1,-76,0.5,-10)
        fBox.BackgroundColor3 = INP_BG
        fBox.Text = tostring((__HH.FRFloat and __HH.FRFloat.getHeight()) or (__HH.floatHeight or 6))
        fBox.TextColor3 = WHITE; fBox.Font = Enum.Font.GothamBold; fBox.TextSize = 10
        fBox.ClearTextOnFocus = false; fBox.TextXAlignment = Enum.TextXAlignment.Center; fBox.ZIndex = 5
        Instance.new("UICorner", fBox).CornerRadius = UDim.new(0,4)
        local fbs = Instance.new("UIStroke", fBox); fbs.Color = DIM_LINE; fbs.Thickness = 1
        fBox.Focused:Connect(function() TS:Create(fbs, TweenInfo.new(0.12), {Color=WHITE}):Play() end)
        fBox.FocusLost:Connect(function()
            TS:Create(fbs, TweenInfo.new(0.12), {Color=DIM_LINE}):Play()
            local n = tonumber(fBox.Text)
            if n then
                __HH.floatHeight = math.clamp(n, 0, 200)
                if __HH.FRFloat then __HH.FRFloat.setHeight(__HH.floatHeight) end
                saveConfig()
                fBox.Text = tostring(__HH.floatHeight)
            else
                fBox.Text = tostring((__HH.FRFloat and __HH.FRFloat.getHeight()) or (__HH.floatHeight or 6))
            end
        end)
    end

    mkSect(sfCombat, "Auto TP")
    __HH.setAutoTPVisual = mkToggle(sfCombat, "Auto TP", function(on)
        __HH.autoTPEnabled=on; if on then startAutoTP() else __HH.stopAutoTP() end; saveConfig()
    end, __HH.autoTPEnabled)
    mkBoxRow(sfCombat, "TP Height", __HH.autoTPHeight, function(v) if v>=0 and v<=500 then __HH.autoTPHeight=v end; saveConfig() end)

    mkSect(sfVisual, "Avatar")
    mkToggle(sfVisual, "Headless", function(on)
        __HH.headlessEnabled = on == true
        local char = LP.Character
        if char then pcall(function() applyHeadless(char, __HH.headlessEnabled) end) end
        saveConfig()
    end, __HH.headlessEnabled)
    mkToggle(sfVisual, "Korblox", function(on)
        __HH.korbloxEnabled = on == true
        local char = LP.Character
        if char then pcall(function() applyKorblox(char, __HH.korbloxEnabled) end) end
        saveConfig()
    end, __HH.korbloxEnabled)

    -- Pack Accessory (Catalog Changer — VisDuels port)
    do
        local row = mkRow(sfVisual)
        mkLabel(row, "Pack Accessory")
        row.Size = UDim2.new(1, -4, 0, 42)
        row.ClipsDescendants = true

        local left = Instance.new("TextButton", row)
        left.BackgroundColor3 = Color3.fromRGB(7, 7, 10); left.BackgroundTransparency = 0.04
        left.Text = "<"; left.TextColor3 = Color3.fromRGB(232, 205, 255); left.TextSize = 12
        left.Font = Enum.Font.GothamSemibold; left.Size = UDim2.new(0, 42, 0, 28)
        left.Position = UDim2.new(1, -186, 0.5, -14); left.BorderSizePixel = 0; left.ZIndex = 8
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 8)
        local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = Color3.fromRGB(90, 90, 105); leftStroke.Transparency = 0.42

        local holder = Instance.new("Frame", row)
        holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0); holder.BackgroundTransparency = 0.28
        holder.Size = UDim2.new(0, 92, 0, 28); holder.Position = UDim2.new(1, -139, 0.5, -14); holder.ClipsDescendants = true; holder.ZIndex = 7
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)
        local holderStroke = Instance.new("UIStroke", holder); holderStroke.Color = Color3.fromRGB(232, 205, 255); holderStroke.Transparency = 0.35

        local accValueLabel = Instance.new("TextLabel", holder)
        accValueLabel.BackgroundTransparency = 1; accValueLabel.Text = currentAccessoryPack
        accValueLabel.TextColor3 = Color3.fromRGB(232, 205, 255); accValueLabel.TextSize = 11
        accValueLabel.Font = Enum.Font.GothamSemibold; accValueLabel.Size = UDim2.new(1, 0, 1, 0); accValueLabel.ZIndex = 9
        accValueLabel.TextXAlignment = Enum.TextXAlignment.Center

        local right = Instance.new("TextButton", row)
        right.BackgroundColor3 = Color3.fromRGB(7, 7, 10); right.BackgroundTransparency = 0.04
        right.Text = ">"; right.TextColor3 = Color3.fromRGB(232, 205, 255); right.TextSize = 12
        right.Font = Enum.Font.GothamSemibold; right.Size = UDim2.new(0, 42, 0, 28)
        right.Position = UDim2.new(1, -42, 0.5, -14); right.BorderSizePixel = 0; right.ZIndex = 8
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 8)
        local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = Color3.fromRGB(90, 90, 105); rightStroke.Transparency = 0.42

        local function updateAccessorySelector(direction)
            local idx = 1
            for i, entry in ipairs(ACCESSORY_PACK_ORDER) do
                if entry[2] == currentAccessoryPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ACCESSORY_PACK_ORDER end
            if newIdx > #ACCESSORY_PACK_ORDER then newIdx = 1 end
            local packName = ACCESSORY_PACK_ORDER[newIdx][2]
            currentAccessoryPack = packName
            accValueLabel.Text = packName
            applyAccessoryPack(packName)
            saveConfig()
        end

        left.MouseButton1Click:Connect(function() updateAccessorySelector(-1) end)
        right.MouseButton1Click:Connect(function() updateAccessorySelector(1) end)
    end

    mkSect(sfVisual, "ESP")
    __HH.setESPVisual = mkToggle(sfVisual, "ESP Players", function(on)
        __HH.espEnabled = on == true
        if on then
            if startPlayerESP then startPlayerESP() end
        else
            if stopPlayerESP then stopPlayerESP() end
        end
        saveConfig()
    end, __HH.espEnabled)

    mkSect(sfVisual, "Visual Effects")
    setAntiLagVisual    = mkToggle(sfVisual, "Anti Lag",    function(on) if on then enableAntiLag() else disableAntiLag() end; saveConfig() end, __HH.antiLagEnabled)
    __HH.setStretchRezVisual = mkToggle(sfVisual, "Stretch Rez", function(on) if on then enableStretchRez() else disableStretchRez() end; saveConfig() end, __HH.stretchRezEnabled)

    mkSect(sfVisual, "Colors & Font")
    do
        local hz = __HH.hz
        local function lumOf(c) return 0.299 * c.R + 0.587 * c.G + 0.114 * c.B end
        local function pickerRow(title, names, cur, onPick, isColor)
            local row = mkRow(sfVisual)
            mkLabel(row, title)
            local idx = 1
            for i, n in ipairs(names) do if n == cur then idx = i end end
            local function mkArrow(txt, x)
                local b = Instance.new("TextButton", row)
                b.Size = UDim2.new(0,26,0,22); b.Position = UDim2.new(1,x,0.5,-11)
                b.BackgroundColor3 = INP_BG; b.BorderSizePixel = 0; b.Text = txt; b.TextColor3 = WHITE
                b.Font = Enum.Font.GothamBlack; b.TextSize = 12; b.AutoButtonColor = false; b.ZIndex = 5
                Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
                local st = Instance.new("UIStroke", b); st.Color = WHITE; st.Thickness = 1; st.Transparency = 0.5
                return b
            end
            local la = mkArrow("<", -196)
            local val = Instance.new("TextButton", row)
            val.Size = UDim2.new(0,128,0,22); val.Position = UDim2.new(1,-166,0.5,-11)
            val.BorderSizePixel = 0; val.TextSize = 11; val.Font = Enum.Font.GothamBold
            val.AutoButtonColor = false; val.ZIndex = 5
            val:SetAttribute("NoTheme", true)
            Instance.new("UICorner", val).CornerRadius = UDim.new(0,10)
            local grad = Instance.new("UIGradient", val); grad.Enabled = false
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 220, 70)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 235, 130)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 170, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 90, 255)),
            })
            local ra = mkArrow(">", -32)
            local function show()
                local n = names[idx]
                val.Text = n
                grad.Enabled = false
                if isColor and n ~= "Default" then
                    if n == "Rainbow" then
                        val.BackgroundColor3 = Color3.fromRGB(255, 255, 255); grad.Enabled = true
                        val.TextColor3 = Color3.fromRGB(20, 10, 40)
                    else
                        local c = hz.resolve(n) or Color3.fromRGB(255, 255, 255)
                        val.BackgroundColor3 = c
                        val.TextColor3 = lumOf(c) > 0.55 and Color3.fromRGB(20, 10, 40) or Color3.fromRGB(255, 255, 255)
                    end
                else
                    val.BackgroundColor3 = Color3.fromRGB(70, 60, 100)
                    val.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
            show()
            local function step(d)
                idx = idx + d
                if idx < 1 then idx = #names elseif idx > #names then idx = 1 end
                show()
                pcall(onPick, names[idx])
            end
            la.MouseButton1Click:Connect(function() step(-1) end)
            ra.MouseButton1Click:Connect(function() step(1) end)
            val.MouseButton1Click:Connect(function() step(1) end)
        end
        pickerRow("GUI Color", hz.guiNames(), hz.guiName, function(n) hz.setGui(n) end, true)
        pickerRow("Buttons Color", hz.btnNames(), hz.btnName, function(n) hz.setBtn(n) end, true)
        pickerRow("Auto Grab Color", hz.grabNames(), hz.grabName, function(n) hz.setGrab(n) end, true)
        pickerRow("Font", hz.FONTS, hz.fontName, function(n) hz.setFont(n) end, false)
    end

    mkSect(sfVisual, "Button Shapes")
    setCircleBtnsVisual = mkToggle(sfVisual, "Circle Buttons", function(on)
        __HH.circleButtonsEnabled=on
        if on then __HH.shapeButtonsEnabled=false; __HH.rectangularButtonsEnabled=false
            if setShapeVisual then setShapeVisual(false) end
            if setRectVisual then setRectVisual(false) end
        end
        if __HH.mobGuiRef then buildMobileButtons() end; saveConfig()
    end, __HH.circleButtonsEnabled)

    setShapeVisual = mkToggle(sfVisual, "Shape Buttons", function(on)
        __HH.shapeButtonsEnabled=on
        if on then __HH.circleButtonsEnabled=false; __HH.rectangularButtonsEnabled=false
            if setCircleBtnsVisual then setCircleBtnsVisual(false) end
            if setRectVisual then setRectVisual(false) end
        end
        if __HH.mobGuiRef then buildMobileButtons() end; saveConfig()
    end, __HH.shapeButtonsEnabled)

    setRectVisual = mkToggle(sfVisual, "Rectangular Buttons", function(on)
        __HH.rectangularButtonsEnabled=on
        if on then __HH.circleButtonsEnabled=false; __HH.shapeButtonsEnabled=false
            if setCircleBtnsVisual then setCircleBtnsVisual(false) end
            if setShapeVisual then setShapeVisual(false) end
        end
        if __HH.mobGuiRef then buildMobileButtons() end; saveConfig()
    end, __HH.rectangularButtonsEnabled)

    mkSect(sfVisual, "Sky Theme")
    do
        local skyThemes = SKY_PRESETS_LIST or {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Tech", "Sakura", "Pink Night", "Blood Moon", "Emerald Dawn", "Volcanic", "Arctic", "Midnight Ocean", "Vaporwave", "Toxic", "Solar Eclipse", "Hellscape", "Heaven", "Storm", "Sunrise", "Deep Space", "Lavender Dream", "Inferno", "Mint Sky"}
        local skyIndex = 1
        for i, name in ipairs(skyThemes) do if name == __HH.currentSkyTheme then skyIndex = i break end end
        
        local row = mkRow(sfVisual); mkLabel(row, "Sky Theme")
        row.Size = UDim2.new(1, -4, 0, 42)
        row.ClipsDescendants = true
        
        local left = Instance.new("TextButton", row)
        left.BackgroundColor3 = Color3.fromRGB(7, 7, 10); left.BackgroundTransparency = 0.04
        left.Text = "<"; left.TextColor3 = Color3.fromRGB(232, 205, 255); left.TextSize = 12
        left.Font = Enum.Font.GothamSemibold; left.Size = UDim2.new(0, 42, 0, 28)
        left.Position = UDim2.new(1, -186, 0.5, -14); left.BorderSizePixel = 0; left.ZIndex = 8
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 8)
        local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = Color3.fromRGB(90, 90, 105); leftStroke.Transparency = 0.42
        
        local holder = Instance.new("Frame", row)
        holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0); holder.BackgroundTransparency = 0.28
        holder.Size = UDim2.new(0, 92, 0, 28); holder.Position = UDim2.new(1, -139, 0.5, -14); holder.ClipsDescendants = true; holder.ZIndex = 7
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)
        local holderStroke = Instance.new("UIStroke", holder); holderStroke.Color = Color3.fromRGB(232, 205, 255); holderStroke.Transparency = 0.35
        
        skyValueLabel = Instance.new("TextLabel", holder)
        skyValueLabel.BackgroundTransparency = 1; skyValueLabel.Text = skyThemes[skyIndex]
        skyValueLabel.TextColor3 = Color3.fromRGB(232, 205, 255); skyValueLabel.TextSize = 11
        skyValueLabel.Font = Enum.Font.GothamSemibold; skyValueLabel.Size = UDim2.new(1, 0, 1, 0); skyValueLabel.ZIndex = 9
        skyValueLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        local right = Instance.new("TextButton", row)
        right.BackgroundColor3 = Color3.fromRGB(7, 7, 10); right.BackgroundTransparency = 0.04
        right.Text = ">"; right.TextColor3 = Color3.fromRGB(232, 205, 255); right.TextSize = 12
        right.Font = Enum.Font.GothamSemibold; right.Size = UDim2.new(0, 42, 0, 28)
        right.Position = UDim2.new(1, -42, 0.5, -14); right.BorderSizePixel = 0; right.ZIndex = 8
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 8)
        local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = Color3.fromRGB(90, 90, 105); rightStroke.Transparency = 0.42
        
        local function setSkyIndex(nextIndex)
            if nextIndex < 1 then nextIndex = #skyThemes end
            if nextIndex > #skyThemes then nextIndex = 1 end
            skyIndex = nextIndex
            __HH.currentSkyTheme = skyThemes[skyIndex]
            if type(applySkyTheme) == "function" then applySkyTheme(__HH.currentSkyTheme) end
            if skyValueLabel then skyValueLabel.Text = __HH.currentSkyTheme end
            saveConfig()
        end
        left.MouseButton1Click:Connect(function() setSkyIndex(skyIndex - 1) end)
        right.MouseButton1Click:Connect(function() setSkyIndex(skyIndex + 1) end)
    end


    do
        local row = mkRow(sfExtra)
        mkLabel(row, "Anim Changer")

        local function makePackButton(text, xOffset)
            local button = Instance.new("TextButton", row)
            button.Size = UDim2.new(0, 42, 0, 22)
            button.Position = UDim2.new(1, xOffset, 0.5, -11)
            button.BackgroundColor3 = BTN_ACT
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 12
            button.AutoButtonColor = false
            button.ZIndex = 5
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = WHITE
            stroke.Thickness = 1
            stroke.Transparency = 0.55
            return button
        end

        local leftButton = makePackButton("<", -160)
        local valueLabel = Instance.new("TextLabel", row)
        valueLabel.Size = UDim2.new(0, 106, 1, 0)
        valueLabel.Position = UDim2.new(1, -116, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextColor3 = WHITE
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 9
        valueLabel.TextXAlignment = Enum.TextXAlignment.Center
        valueLabel.ZIndex = 5
        local rightButton = makePackButton(">", -48)

        local function refreshAcePackLabel()
            valueLabel.Text = __HH.aceSelectedAnimationPack
        end
        local function setAcePack(index)
            if index < 1 then index = #__HH.aceAnimationPackList end
            if index > #__HH.aceAnimationPackList then index = 1 end
            __HH.aceAnimationPackIndex = index
            __HH.aceSelectedAnimationPack = __HH.aceAnimationPackList[index]
            refreshAcePackLabel()
            pcall(function() __HH.aceApplyAnimationPack(__HH.aceSelectedAnimationPack) end)
            saveConfig()
        end

        __HH.aceSyncAnimationPackIndex()
        refreshAcePackLabel()
        leftButton.MouseButton1Click:Connect(function()
            setAcePack(__HH.aceAnimationPackIndex - 1)
        end)
        rightButton.MouseButton1Click:Connect(function()
            setAcePack(__HH.aceAnimationPackIndex + 1)
        end)
    end

    mkSect(sfExtra, "Performance")
    mkToggle(sfExtra, "Nuke Optimizer", function(on)
        if on then
            pcall(function()
                Lighting.GlobalShadows = false; Lighting.FogEnd = 9e9
                Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
                for _, e in ipairs(Lighting:GetChildren()) do
                    if e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("Atmosphere") or e:IsA("Clouds") then
                        e:Destroy()
                    end
                end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
                        pcall(function() obj:Destroy() end)
                    end
                    if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
                        pcall(function() obj.CastShadow = false end)
                    end
                end
            end)
        end; saveConfig()
    end, false)

    mkSect(sfExtra, "UI Scale")
    mkBoxRow(sfExtra, "UI Scale", uiScaleValue, function(v)
        if v>=0.4 and v<=1.3 then
            uiScaleValue=v; if __HH.uiScaleObject then __HH.uiScaleObject.Scale=v end; saveConfig()
        end
    end)

    -- ─── Device & Config ────────────────────────────────────────────────────
    -- (kept in one shared "do" block so the device label can be refreshed
    -- from both the Reset Device button and the Load Config handler below)
    mkSect(sfExtra, "Device")
    local devLbl
    do
        local row = mkRow(sfExtra)
        mkLabel(row, "Current Device")
        devLbl = Instance.new("TextLabel", row)
        devLbl.Size = UDim2.new(0, 90, 0, 20); devLbl.Position = UDim2.new(1, -95, 0.5, -10)
        devLbl.BackgroundTransparency = 1; devLbl.Text = __HH.selectedDevice or "PC"
        devLbl.TextColor3 = BTN_ACT; devLbl.Font = Enum.Font.GothamBold; devLbl.TextSize = 11
        devLbl.TextXAlignment = Enum.TextXAlignment.Right; devLbl.ZIndex = 5

        local resetRow = mkRow(sfExtra)
        mkLabel(resetRow, "Reset Device")
        local resetDevBtn = Instance.new("TextButton", resetRow)
        resetDevBtn.Size = UDim2.new(0,90,0,20); resetDevBtn.Position = UDim2.new(1,-95,0.5,-10)
        resetDevBtn.BackgroundColor3 = BTN_ACT; resetDevBtn.BorderSizePixel = 0
        resetDevBtn.Text = "Reset"; resetDevBtn.TextColor3 = WHITE
        resetDevBtn.Font = Enum.Font.GothamBold; resetDevBtn.TextSize = 10
        resetDevBtn.AutoButtonColor = false; resetDevBtn.ZIndex = 5
        Instance.new("UICorner", resetDevBtn).CornerRadius = UDim.new(0,5)
        local rdStroke = Instance.new("UIStroke", resetDevBtn); rdStroke.Color = WHITE; rdStroke.Thickness = 1
        resetDevBtn.MouseButton1Click:Connect(function()
            if __HH.runDeviceSelection then
                __HH.mainFrame.Visible = false
                __HH.runDeviceSelection(true)
                if devLbl then devLbl.Text = __HH.selectedDevice or "PC" end
                __HH.mainFrame.Visible = true
            end
        end)
    end

    mkSect(sfExtra, "Config")
    do
        local copyRow = mkRow(sfExtra)
        mkLabel(copyRow, "Copy Config")
        local copyBtn = Instance.new("TextButton", copyRow)
        copyBtn.Size = UDim2.new(0,90,0,20); copyBtn.Position = UDim2.new(1,-95,0.5,-10)
        copyBtn.BackgroundColor3 = BTN_ACT; copyBtn.BorderSizePixel = 0
        copyBtn.Text = "Copy"; copyBtn.TextColor3 = WHITE
        copyBtn.Font = Enum.Font.GothamBold; copyBtn.TextSize = 10
        copyBtn.AutoButtonColor = false; copyBtn.ZIndex = 5
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,5)
        local copyStroke = Instance.new("UIStroke", copyBtn); copyStroke.Color = WHITE; copyStroke.Thickness = 1

        local loadRow = mkRow(sfExtra)
        mkLabel(loadRow, "Load Config")
        local loadInput = Instance.new("TextBox", loadRow)
        loadInput.Size = UDim2.new(0, 150, 0, 22); loadInput.Position = UDim2.new(1, -215, 0.5, -11)
        loadInput.BackgroundColor3 = INP_BG; loadInput.PlaceholderText = "paste code here"
        loadInput.Text = ""; loadInput.ClearTextOnFocus = false
        loadInput.TextColor3 = WHITE; loadInput.PlaceholderColor3 = Color3.fromRGB(152, 131, 170)
        loadInput.Font = Enum.Font.GothamBold; loadInput.TextSize = 9; loadInput.ZIndex = 5
        loadInput.ClipsDescendants = true
        Instance.new("UICorner", loadInput).CornerRadius = UDim.new(0,6)
        local loadInputStroke = Instance.new("UIStroke", loadInput); loadInputStroke.Color = DIM_LINE; loadInputStroke.Thickness = 1

        local loadBtn = Instance.new("TextButton", loadRow)
        loadBtn.Size = UDim2.new(0,55,0,20); loadBtn.Position = UDim2.new(1,-60,0.5,-10)
        loadBtn.BackgroundColor3 = BTN_ACT; loadBtn.BorderSizePixel = 0
        loadBtn.Text = "Load"; loadBtn.TextColor3 = WHITE
        loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 10
        loadBtn.AutoButtonColor = false; loadBtn.ZIndex = 5
        Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0,5)
        local loadStroke = Instance.new("UIStroke", loadBtn); loadStroke.Color = WHITE; loadStroke.Thickness = 1

        local statusRow = mkRow(sfExtra)
        local statusLbl = Instance.new("TextLabel", statusRow)
        statusLbl.Size = UDim2.new(1,0,1,0); statusLbl.BackgroundTransparency = 1
        statusLbl.Text = ""; statusLbl.TextColor3 = BTN_ACT
        statusLbl.Font = Enum.Font.GothamBold; statusLbl.TextSize = 10
        statusLbl.TextXAlignment = Enum.TextXAlignment.Left; statusLbl.ZIndex = 5

        local function flashStatus(msg)
            statusLbl.Text = msg
            task.delay(3, function() if statusLbl.Text == msg then statusLbl.Text = "" end end)
        end

        copyBtn.MouseButton1Click:Connect(function()
            local ok, code = pcall(function() return __HH.encodeConfigCode(__HH.buildConfigTable()) end)
            if ok and code then
                local copied = false
                pcall(function()
                    if setclipboard then setclipboard(code); copied = true
                    elseif toclipboard then toclipboard(code); copied = true end
                end)
                if copied then
                    flashStatus("Config copied to clipboard!")
                else
                    loadInput.Text = code
                    flashStatus("Clipboard unsupported — code placed in the box above, copy it manually.")
                end
            else
                flashStatus("Failed to build config code.")
            end
        end)

        loadBtn.MouseButton1Click:Connect(function()
            local raw = loadInput.Text
            if not raw or raw == "" then flashStatus("Paste a config code first."); return end
            local ok, cfg = pcall(function() return __HH.decodeConfigCode(raw) end)
            if ok and type(cfg) == "table" then
                loadConfig(cfg)
                applyState()
                if __HH.mobileButtonsEnabled and buildMobileButtons then task.spawn(buildMobileButtons)
                elseif destroyMobileButtons then destroyMobileButtons() end
                if devLbl then devLbl.Text = __HH.selectedDevice or "PC" end
                flashStatus("Config loaded successfully!")
                -- Rebuild the whole panel so every textbox/toggle/keybind
                -- (Normal Speed, Grab Speed, Lagger Speeds, AIM BOT Speed,
                -- all switches, keybinds, sliders, etc.) actually shows the
                -- real values that were just loaded, instead of leaving the
                -- old numbers/labels frozen on screen until a manual rejoin.
                task.delay(0.3, function()
                    pcall(function()
                        if __HH.mainFrame then __HH.mainFrame:Destroy() end
                        buildGui()
                        applyState()
                        if __HH.mobileButtonsEnabled and buildMobileButtons then task.spawn(buildMobileButtons)
                        elseif destroyMobileButtons then destroyMobileButtons() end
                        if __HH.mainFrame then __HH.mainFrame.Visible = true end
                    end)
                end)
            else
                flashStatus("Invalid config code.")
            end
        end)

        -- ─── Reset All Settings ─────────────────────────────────────────────
        -- Wipes every saved toggle/speed/keybind/UI setting back to the
        -- script's hardcoded defaults. Does NOT touch the selected device
        -- (PC/Mobile/Controller) — that is what "Reset Device" is for.
        local resetAllRow = mkRow(sfExtra)
        mkLabel(resetAllRow, "Reset All Settings")
        local resetAllBtn = Instance.new("TextButton", resetAllRow)
        resetAllBtn.Size = UDim2.new(0,90,0,20); resetAllBtn.Position = UDim2.new(1,-95,0.5,-10)
        resetAllBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90); resetAllBtn.BorderSizePixel = 0
        resetAllBtn.Text = "Reset All"; resetAllBtn.TextColor3 = WHITE
        resetAllBtn.Font = Enum.Font.GothamBold; resetAllBtn.TextSize = 10
        resetAllBtn.AutoButtonColor = false; resetAllBtn.ZIndex = 5
        Instance.new("UICorner", resetAllBtn).CornerRadius = UDim.new(0,5)
        local resetAllStroke = Instance.new("UIStroke", resetAllBtn); resetAllStroke.Color = WHITE; resetAllStroke.Thickness = 1
        wireResetAllButton(resetAllBtn, "Reset All", flashStatus)
    end

    -- ─── Mobile Tab ─────────────────────────────────────────────────────────
    do
        mkSect(sfMobile, "Button Visibility")
        local mobBtnDefs = {
            {key="drop",         label="DROP BR"},
            {key="tpDown",       label="TP DOWN"},
            {key="batV2",        label="AIM BOT"},
            {key="tpLock",       label="TP BAT"},
            {key="lagger",       label="LAGGER"},
            {key="laggerCarry",  label="LAGGER CARRY"},
            {key="carrySpeed",   label="CARRY SPD"},
            {key="instaReset",   label="INSTA RESET"},
            {key="autoLeft",     label="AUTO LEFT"},
            {key="autoRight",    label="AUTO RIGHT"},
        }
        for _, def in ipairs(mobBtnDefs) do
            local key = def.key
            mkToggle(sfMobile, def.label, function(on)
                __HH.buttonVisibility[key] = on
                if __HH.mobileButtonsEnabled then buildMobileButtons() end
                saveConfig()
            end, __HH.buttonVisibility[key] ~= false)
        end

        -- ─── Mobile Settings ─────────────────────────────────────────────────
        mkSect(sfMobile, "Mobile Settings")

        local mobShowSet = mkToggle(sfMobile, "Show Mobile UI", function(on)
            __HH.mobileButtonsEnabled = on
            if on then buildMobileButtons() else destroyMobileButtons() end
            if setMobVisual then setMobVisual(on) end
            saveConfig()
        end, __HH.mobileButtonsEnabled)

        mkBoxRow(sfMobile, "Btn Size", __HH.mobileButtonsSize, function(v)
            if v >= 10 and v <= 200 then
                __HH.mobileButtonsSize = v
                if __HH.mobileButtonsEnabled then buildMobileButtons() end
                saveConfig()
            end
        end)

        local mobDragSet = mkToggle(sfMobile, "Btn Drag Per Btn", function(on)
            __HH.perButtonDragEnabled = on
            if __HH.mobileButtonsEnabled then buildMobileButtons() end
            saveConfig()
        end, __HH.perButtonDragEnabled)

        local mobLockSet = mkToggle(sfMobile, "Lock UI", function(on)
            __HH.uiLocked = on
            _G.YousefUiLocked = on
            if setLockVisual then setLockVisual(on) end
            saveConfig()
        end, __HH.uiLocked)

        do
            local row = mkRow(sfMobile); mkLabel(row, "Reset Mobile Btns")
            local resetBtn = Instance.new("TextButton", row)
            resetBtn.Size = UDim2.new(0,60,0,20); resetBtn.Position = UDim2.new(1,-65,0.5,-10)
            resetBtn.BackgroundColor3 = BTN_ACT; resetBtn.BorderSizePixel = 0
            resetBtn.Text = "Reset"; resetBtn.TextColor3 = WHITE
            resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 9
            resetBtn.AutoButtonColor = false; resetBtn.ZIndex = 5
            Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,5)
            local rStroke = Instance.new("UIStroke", resetBtn); rStroke.Color = WHITE; rStroke.Thickness = 1
            resetBtn.MouseButton1Click:Connect(function()
                resetBtnPositions()
                TS:Create(resetBtn, TweenInfo.new(0.1), {BackgroundColor3=WHITE}):Play()
                task.delay(0.15, function()
                    TS:Create(resetBtn, TweenInfo.new(0.1), {BackgroundColor3=BTN_ACT}):Play()
                end)
            end)
        end

        -- ─── Reset All Settings (Mobile tab copy) ──────────────────────────────
        -- Same shared reset as the Extra tab's button — every toggle, speed,
        -- keybind and mobile setting goes back to default. Kept here too so
        -- it's reachable straight from the Mobile tab without switching tabs.
        do
            local mobResetAllRow = mkRow(sfMobile)
            mkLabel(mobResetAllRow, "Reset All Settings")
            local mobResetAllBtn = Instance.new("TextButton", mobResetAllRow)
            mobResetAllBtn.Size = UDim2.new(0,90,0,20); mobResetAllBtn.Position = UDim2.new(1,-95,0.5,-10)
            mobResetAllBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90); mobResetAllBtn.BorderSizePixel = 0
            mobResetAllBtn.Text = "Reset All"; mobResetAllBtn.TextColor3 = WHITE
            mobResetAllBtn.Font = Enum.Font.GothamBold; mobResetAllBtn.TextSize = 10
            mobResetAllBtn.AutoButtonColor = false; mobResetAllBtn.ZIndex = 5
            Instance.new("UICorner", mobResetAllBtn).CornerRadius = UDim.new(0,5)
            local mobResetAllStroke = Instance.new("UIStroke", mobResetAllBtn); mobResetAllStroke.Color = WHITE; mobResetAllStroke.Thickness = 1

            local mobResetStatusRow = mkRow(sfMobile)
            local mobResetStatusLbl = Instance.new("TextLabel", mobResetStatusRow)
            mobResetStatusLbl.Size = UDim2.new(1,0,1,0); mobResetStatusLbl.BackgroundTransparency = 1
            mobResetStatusLbl.Text = ""; mobResetStatusLbl.TextColor3 = BTN_ACT
            mobResetStatusLbl.Font = Enum.Font.GothamBold; mobResetStatusLbl.TextSize = 10
            mobResetStatusLbl.TextXAlignment = Enum.TextXAlignment.Left; mobResetStatusLbl.ZIndex = 5
            local function mobFlashStatus(msg)
                mobResetStatusLbl.Text = msg
                task.delay(3, function() if mobResetStatusLbl.Text == msg then mobResetStatusLbl.Text = "" end end)
            end

            wireResetAllButton(mobResetAllBtn, "Reset All", mobFlashStatus)
        end

        -- ─── Button Shapes ───────────────────────────────────────────────────
        mkSect(sfMobile, "Button Shapes")

        local mobCircleSet = mkToggle(sfMobile, "Circle Buttons", function(on)
            __HH.circleButtonsEnabled = on
            if on then
                __HH.shapeButtonsEnabled = false
                __HH.rectangularButtonsEnabled = false
                if setShapeVisual then setShapeVisual(false) end
                if setRectVisual then setRectVisual(false) end
            end
            if __HH.mobileButtonsEnabled then buildMobileButtons() end
            saveConfig()
        end, __HH.circleButtonsEnabled)

        local mobShapeSet = mkToggle(sfMobile, "Shape Buttons", function(on)
            __HH.shapeButtonsEnabled = on
            if on then
                __HH.circleButtonsEnabled = false
                __HH.rectangularButtonsEnabled = false
                if setCircleBtnsVisual then setCircleBtnsVisual(false) end
                if setRectVisual then setRectVisual(false) end
            end
            if __HH.mobileButtonsEnabled then buildMobileButtons() end
            saveConfig()
        end, __HH.shapeButtonsEnabled)

        local mobRectSet = mkToggle(sfMobile, "Rectangular Buttons", function(on)
            __HH.rectangularButtonsEnabled = on
            if on then
                __HH.circleButtonsEnabled = false
                __HH.shapeButtonsEnabled = false
                if setCircleBtnsVisual then setCircleBtnsVisual(false) end
                if setShapeVisual then setShapeVisual(false) end
            end
            if __HH.mobileButtonsEnabled then buildMobileButtons() end
            saveConfig()
        end, __HH.rectangularButtonsEnabled)

    end

    __HH.mainFrame.Visible = false
    miniToggleBtn.Visible = false
    print("[POLM HUB] build v34 - intro ends ONLY when the full song finishes (truncated downloads re-fetched, no early close)")
    task.delay(2, function() pcall(__HH.hz.applyAll) end)
    print("Polm Hub GUI Fully Loaded")
end

loadConfig()
uiScaleValue = 0.6

-- ============================================================
-- DEVICE SELECTION (PC / MOBILE / CONTROLLER)
-- ============================================================
-- Shows a full-screen picker the first time the script ever runs (or again
-- after "Reset Device" is pressed from the Extra tab). PC and Controller
-- both hide the floating mobile buttons and rely on keybinds / gamepad
-- buttons; Mobile shows the floating buttons normally.
do
    local DEV_ICE   = Color3.fromRGB(232, 205, 255)
    local DEV_ACCENT= Color3.fromRGB(195, 126, 255)
    local DEV_NAVY  = Color3.fromRGB(57, 25, 85)
    local DEV_DARK  = Color3.fromRGB(10, 10, 14)

    -- Small toast used for the "welcome to polm hub!" message.
    local function showWelcomeToast()
        print("welcome to polm hub!")
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            local playerGui = LP:WaitForChild("PlayerGui")
            local old = coreGui:FindFirstChild("PolmWelcomeToast") or playerGui:FindFirstChild("PolmWelcomeToast")
            if old then old:Destroy() end

            local toastGui = Instance.new("ScreenGui")
            toastGui.Name = "PolmWelcomeToast"
            toastGui.ResetOnSpawn = false
            toastGui.IgnoreGuiInset = true
            toastGui.DisplayOrder = 2147483646
            if not pcall(function() toastGui.Parent = coreGui end) then
                toastGui.Parent = playerGui
            end

            local card = Instance.new("Frame", toastGui)
            card.AnchorPoint = Vector2.new(0.5, 0)
            card.Position = UDim2.new(0.5, 0, 0, 24)
            card.Size = UDim2.new(0, 280, 0, 44)
            card.BackgroundColor3 = DEV_DARK
            card.BackgroundTransparency = 0.05
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
            local cardStroke = Instance.new("UIStroke", card)
            cardStroke.Color = DEV_ACCENT; cardStroke.Thickness = 1.4; cardStroke.Transparency = 0.15

            local lbl = Instance.new("TextLabel", card)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, -16, 1, 0)
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.Text = "welcome to polm hub!"
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 15
            lbl.TextColor3 = DEV_ICE
            lbl.TextXAlignment = Enum.TextXAlignment.Center

            card.BackgroundTransparency = 1
            cardStroke.Transparency = 1
            lbl.TextTransparency = 1
            local TSvc = game:GetService("TweenService")
            TSvc:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 0.05}):Play()
            TSvc:Create(cardStroke, TweenInfo.new(0.25), {Transparency = 0.15}):Play()
            TSvc:Create(lbl, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
            task.delay(2.6, function()
                if not toastGui.Parent then return end
                TSvc:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TSvc:Create(cardStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
                TSvc:Create(lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                task.delay(0.35, function() pcall(function() toastGui:Destroy() end) end)
            end)
        end)
    end
    __HH.showWelcomeToast = showWelcomeToast

    -- Same picker structure/behaviour as the original source (backdrop +
    -- centered card + row of mode buttons, MouseButton1Click sets the
    -- selection and destroys the GUI, then a blocking wait returns the
    -- result) — only the name, the color scheme (light blue instead of
    -- white/black) and a third "CONTROLLER" button were added/changed.
    local function choosePlatformMode()
        local pickerGui = Instance.new("ScreenGui")
        pickerGui.Name = "PolmDevicePicker"
        pickerGui.ResetOnSpawn = false
        pickerGui.IgnoreGuiInset = true
        pickerGui.DisplayOrder = 9998 -- stays below the intro and appears after it disappears
        pickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(pickerGui) end end)
        if not pcall(function() pickerGui.Parent = game:GetService("CoreGui") end) then
            pickerGui.Parent = LP:WaitForChild("PlayerGui")
        end

        local backdrop = Instance.new("Frame", pickerGui)
        backdrop.Size = UDim2.fromScale(1, 1)
        backdrop.BackgroundColor3 = DEV_ICE
        backdrop.BorderSizePixel = 0
        backdrop.ZIndex = 1

        local card = Instance.new("Frame", backdrop)
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.Size = UDim2.fromOffset(460, 220)
        card.BackgroundColor3 = DEV_ICE
        card.BorderSizePixel = 0
        card.ZIndex = 2
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = DEV_NAVY
        cardStroke.Thickness = 2

        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(1, -30, 0, 42)
        title.Position = UDim2.fromOffset(15, 18)
        title.BackgroundTransparency = 1
        title.Text = "SELECT YOUR DEVICE"
        title.TextColor3 = DEV_NAVY
        title.Font = Enum.Font.PermanentMarker
        title.TextSize = 22
        title.ZIndex = 3

        local hint = Instance.new("TextLabel", card)
        hint.Size = UDim2.new(1, -30, 0, 24)
        hint.Position = UDim2.fromOffset(15, 58)
        hint.BackgroundTransparency = 1
        hint.Text = "Choose the interface mode"
        hint.TextColor3 = DEV_NAVY
        hint.Font = Enum.Font.Gotham
        hint.TextSize = 12
        hint.ZIndex = 3

        local selected = nil
        local function makeButton(label, x, device)
            local button = Instance.new("TextButton", card)
            button.Size = UDim2.fromOffset(130, 62)
            button.Position = UDim2.fromOffset(x, 112)
            button.BackgroundColor3 = DEV_ACCENT
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = label
            button.TextColor3 = DEV_ICE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 18
            button.ZIndex = 3
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = DEV_NAVY
            stroke.Thickness = 1
            button.MouseButton1Click:Connect(function()
                selected = device
                pickerGui:Destroy()
            end)
            return button
        end

        makeButton("PC", 20, "PC")
        makeButton("MOBILE", 165, "MOBILE")
        makeButton("CONTROLLER", 310, "CONTROLLER")

        while pickerGui.Parent and not selected do
            task.wait()
        end
        return selected or "PC"
    end
    __HH.choosePlatformMode = choosePlatformMode

    -- Runs the picker (if needed) and applies the resulting device choice.
    -- force = true always re-shows the picker (used by "Reset Device").
    __HH.runDeviceSelection = function(force)
        if force or not __HH.selectedDevice then
            local device = choosePlatformMode()
            __HH.selectedDevice = device
            __HH.mobileButtonsEnabled = (device == "MOBILE")
            saveConfig()
            if __HH.mobGuiRef then
                if __HH.mobileButtonsEnabled and buildMobileButtons then
                    task.spawn(buildMobileButtons)
                elseif destroyMobileButtons then
                    destroyMobileButtons()
                end
            end
            if setMobVisual then pcall(setMobVisual, __HH.mobileButtonsEnabled) end
            showWelcomeToast()
        end
    end
end

local function _runIntro(onComplete)
    local TSx        = game:GetService("TweenService")
    local SoundService = game:GetService("SoundService")
    local coreGui    = game:GetService("CoreGui")
    local playerGui  = LP:WaitForChild("PlayerGui")

    -- music: the Monster intro song only (no images / beat effects)
    local MUSIC_URL  = "https://files.catbox.moe/qhpfe5.mp3"
    local MUSIC_FILE = "polm_intro_monster.mp3"
    local MUSIC_VOL  = 0.75

    local introFinished = false
    local introSound    = nil

    -- clean old intro GUIs from previous versions
    pcall(function()
        for _, name in ipairs({"MonsterIntro","PolmDuelsIntro","PolmHubIntroV6","PolmHubSpriteIntro","PolmHubVideoIntro","PolmHubIntro","PureHubSpriteIntro","PureHubVideoIntro","PureHubIntro","PureHubIntroV6"}) do
            local a = coreGui:FindFirstChild(name)
            if a then a:Destroy() end
            local b = playerGui:FindFirstChild(name)
            if b then b:Destroy() end
        end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name           = "PolmDuelsIntro"
    gui.ResetOnSpawn   = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder   = 2147483647
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = coreGui end) then
        gui.Parent = playerGui
    end

    local bg = Instance.new("Frame", gui)
    bg.Size                  = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3      = Color3.new(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel       = 0
    bg.ZIndex                = 1

    -- ===== title group: "polm hub" + "v2" side by side, shakes as one =====
    -- everything lives inside this holder so the whole text shakes together
    local holder = Instance.new("Frame", gui)
    holder.Name                  = "TitleHolder"
    holder.Size                  = UDim2.new(1, 0, 1, 0)
    holder.Position              = UDim2.new(0, 0, 0, 0)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel       = 0
    holder.ZIndex                = 5

    -- auto-sized horizontal row keeps the pair perfectly centered
    local row = Instance.new("Frame", holder)
    row.Name                  = "TitleRow"
    row.AnchorPoint           = Vector2.new(0.5, 0.5)
    row.Position              = UDim2.new(0.5, 0, 0.5, -8)
    row.Size                  = UDim2.new(0, 0, 0, 64)
    row.AutomaticSize         = Enum.AutomaticSize.X
    row.BackgroundTransparency = 1
    row.BorderSizePixel       = 0
    row.ClipsDescendants      = false
    row.ZIndex                = 5

    local rowLayout = Instance.new("UIListLayout", row)
    rowLayout.FillDirection      = Enum.FillDirection.Horizontal
    rowLayout.VerticalAlignment  = Enum.VerticalAlignment.Center
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    rowLayout.SortOrder          = Enum.SortOrder.LayoutOrder
    rowLayout.Padding            = UDim.new(0, 12)

    -- main title (very light blue)
    local title = Instance.new("TextLabel", row)
    title.LayoutOrder           = 1
    title.Size                  = UDim2.new(0, 0, 0, 64)
    title.AutomaticSize         = Enum.AutomaticSize.X
    title.BackgroundTransparency = 1
    title.Text                  = "polm hub"
    title.TextColor3            = Color3.fromRGB(232, 205, 255)
    title.Font                  = Enum.Font.GothamBlack
    title.TextSize              = 46
    title.TextTransparency      = 1
    title.ZIndex                = 5
    local titleStroke = Instance.new("UIStroke", title)
    titleStroke.Color       = Color3.fromRGB(206, 150, 255)
    titleStroke.Thickness   = 2
    titleStroke.Transparency = 0.45

    -- slot that reserves the space for "v2" so the drop animation can't
    -- shift the title around while it falls
    local v2Slot = Instance.new("Frame", row)
    v2Slot.Name                  = "V2Slot"
    v2Slot.LayoutOrder           = 2
    v2Slot.Size                  = UDim2.new(0, 62, 0, 64)
    v2Slot.BackgroundTransparency = 1
    v2Slot.BorderSizePixel       = 0
    v2Slot.ClipsDescendants      = false
    v2Slot.ZIndex                = 5

    -- "v2" — same font as the title, falls in from above
    local v2 = Instance.new("TextLabel", v2Slot)
    v2.Name                  = "V2Tag"
    v2.AnchorPoint           = Vector2.new(0.5, 0.5)
    v2.Size                  = UDim2.new(1, 0, 0, 58)
    v2.BackgroundTransparency = 1
    v2.Text                  = "ho"
    v2.TextColor3            = Color3.fromRGB(232, 205, 255)
    v2.Font                  = Enum.Font.GothamBlack   -- same font as the title
    v2.TextSize              = 46                      -- same size as the title
    v2.TextTransparency      = 1
    v2.ZIndex                = 6
    local v2Stroke = Instance.new("UIStroke", v2)
    v2Stroke.Color        = Color3.fromRGB(206, 150, 255)
    v2Stroke.Thickness    = 2
    v2Stroke.Transparency = 0.45

    local V2_HOME  = UDim2.new(0.5, 0, 0.5, 0)      -- final spot next to the title
    local V2_START = UDim2.new(0.5, 0, 0.5, -520)   -- way above the screen
    v2.Position = V2_START

    -- light blue underline under the text
    local underline = Instance.new("Frame", holder)
    underline.AnchorPoint            = Vector2.new(0.5, 0.5)
    underline.Position               = UDim2.new(0.5, 0, 0.5, 34)
    underline.Size                   = UDim2.new(0, 260, 0, 3)
    underline.BackgroundColor3       = Color3.fromRGB(222, 185, 255)
    underline.BackgroundTransparency = 1
    underline.BorderSizePixel        = 0
    underline.ZIndex                 = 5
    local ulGlow = Instance.new("UIStroke", underline)
    ulGlow.Color       = Color3.fromRGB(213, 165, 255)
    ulGlow.Transparency = 0.35
    ulGlow.Thickness   = 3

    -- SKIP INTRO button (Monster style)
    local skip = Instance.new("TextButton", gui)
    skip.AnchorPoint            = Vector2.new(1, 0)
    skip.Position               = UDim2.new(1, -14, 0, 14)
    skip.Size                   = UDim2.fromOffset(105, 36)
    skip.BackgroundColor3       = Color3.fromRGB(88, 40, 130)
    skip.BackgroundTransparency = 0.15
    skip.BorderSizePixel        = 0
    skip.Text                   = "SKIP INTRO"
    skip.TextColor3             = Color3.fromRGB(226, 193, 255)
    skip.TextSize               = 12
    skip.Font                   = Enum.Font.GothamBold
    skip.AutoButtonColor        = false
    skip.ZIndex                 = 500
    Instance.new("UICorner", skip).CornerRadius = UDim.new(0, 7)
    local skipStroke = Instance.new("UIStroke", skip)
    skipStroke.Color       = Color3.fromRGB(184, 103, 255)
    skipStroke.Transparency = 0.55
    skipStroke.Thickness   = 1

    local function finishIntro()
        if introFinished then return end
        introFinished = true
        -- The song is NOT cut: it keeps playing until it ends on its own.
        pcall(function() gui:Destroy() end)
        onComplete()
    end

    skip.MouseButton1Click:Connect(finishIntro)
    skip.MouseEnter:Connect(function()
        TSx:Create(skip, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(123, 59, 180)}):Play()
    end)
    skip.MouseLeave:Connect(function()
        TSx:Create(skip, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(88, 40, 130)}):Play()
    end)

    -- fade the title + underline in
    TSx:Create(title, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    TSx:Create(underline, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()

    -- "v2" drops in from above next to the title, and the MOMENT it lands the
    -- whole text (title + v2 + underline) shakes like an earthquake until the
    -- intro finishes.
    task.spawn(function()
        task.wait(0.55)
        if introFinished or not v2.Parent then return end

        TSx:Create(v2, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
        local drop = TSx:Create(
            v2,
            TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = V2_HOME}
        )
        drop:Play()
        drop.Completed:Wait()
        if introFinished or not holder.Parent then return end

        -- impact: hard slam then continuous quake on the whole group
        local rnd = Random.new()
        local t0  = tick()
        while not introFinished and holder.Parent do
            local age = tick() - t0
            -- big jolt on landing, settles into a steady tremble
            local power = (age < 0.35) and 22 or 9
            local rot   = (age < 0.35) and 5 or 2.2
            holder.Position = UDim2.new(
                0, rnd:NextNumber(-power, power),
                0, rnd:NextNumber(-power * 0.7, power * 0.7)
            )
            holder.Rotation = rnd:NextNumber(-rot, rot)
            task.wait(0.025)
        end
        pcall(function()
            holder.Position = UDim2.new(0, 0, 0, 0)
            holder.Rotation = 0
        end)
    end)

    -- music loader (bulletproof + truncated-download protection)
    -- The real song (qhpfe5.mp3) is 294802 bytes / ~12.28s at 192kbps.
    -- Anything shorter than that is a truncated download and must be
    -- re-downloaded, otherwise the song "cuts off" mid-play.
    local EXPECTED_SIZE = 294802
    local MIN_SIZE      = 280000
    local EARLY_END_MAX = 9.5      -- loaded length below this = truncated file
    local downloadTries = 0

    local function clearBadCache()
        pcall(function()
            if not (isfile and isfile(MUSIC_FILE)) then return end
            local bad = true
            pcall(function()
                local d = readfile and readfile(MUSIC_FILE)
                if type(d) == "string" and #d >= MIN_SIZE then bad = false end
            end)
            if bad and delfile then delfile(MUSIC_FILE) end
        end)
    end

    local function tryDownload()
        local body
        pcall(function()
            local d = game:HttpGet(MUSIC_URL, true)
            if type(d) == "string" and #d >= MIN_SIZE then body = d end
        end)
        if not body then
            pcall(function()
                local d = game:HttpGet(MUSIC_URL)
                if type(d) == "string" and #d >= MIN_SIZE then body = d end
            end)
        end
        if not body then
            local _req = syn and syn.request or request or http_request
            if _req then
                local okR, r = pcall(_req, {Url = MUSIC_URL, Method = "GET"})
                if okR and r then
                    local b = r.Body or r.body
                    if type(b) == "string" and #b >= MIN_SIZE then body = b end
                end
            end
        end
        if body and writefile then
            pcall(function() writefile(MUSIC_FILE, body) end)
        end
        return body
    end

    local function loadAsset()
        clearBadCache()
        local asset
        pcall(function()
            if isfile and isfile(MUSIC_FILE) and getcustomasset then
                asset = getcustomasset(MUSIC_FILE)
            end
        end)
        return asset
    end

    task.spawn(function()
        if introFinished then return end
        local asset = loadAsset()
        while not asset and downloadTries < 3 and not introFinished do
            downloadTries = downloadTries + 1
            tryDownload()
            asset = loadAsset()
            if not asset then task.wait(1) end
        end
        if introFinished then return end
        if not asset then
            -- song unavailable at all: don't trap the player forever
            task.delay(6, finishIntro)
            return
        end

        local plays = 0
        local function startSong()
            if introFinished then return end
            -- remove any older instance still playing (script re-exec)
            pcall(function()
                local old = SoundService:FindFirstChild("PolmIntroMusic")
                if old then old:Destroy() end
            end)
            introSound = Instance.new("Sound")
            introSound.Name     = "PolmIntroMusic"
            introSound.SoundId  = asset
            introSound.Volume   = MUSIC_VOL
            introSound.Looped   = false
            introSound.Parent   = SoundService
            -- The intro ONLY ends when the FULL song really finishes.
            introSound.Ended:Connect(function()
                local endedEarly = false
                pcall(function()
                    local tl = introSound and introSound.TimeLength or 0
                    if tl > 0 and tl < EARLY_END_MAX then endedEarly = true end
                end)
                local s = introSound
                if endedEarly and plays < 2 and not introFinished then
                    -- truncated playback: refresh the file and replay it
                    plays = plays + 1
                    pcall(function() if s then s:Destroy() end end)
                    introSound = nil
                    clearBadCache()
                    tryDownload()
                    local newAsset = loadAsset()
                    if newAsset then asset = newAsset end
                    task.delay(0.4, startSong)
                    return
                end
                pcall(function() if s then s:Destroy() end end)
                if introSound == s then introSound = nil end
                finishIntro()
            end)
            pcall(function() introSound:Play() end)
        end
        startSong()
    end)
end

-- Ask the player which device they're on before anything else shows up.
-- Runs once ever (persisted in VynxPC.json); "Reset Device" in the Extra
-- tab re-triggers this with force=true.
if __HH.runDeviceSelection then __HH.runDeviceSelection(false) end

_runIntro(function()
    buildGui()
    _G.PolmHubIntroFinished = true
    -- The grab progress HUD only appears after the intro finishes.
    pcall(function()
        local stealGui = game:GetService("CoreGui"):FindFirstChild("StealBarGui")
            or LP:WaitForChild("PlayerGui"):FindFirstChild("StealBarGui")
        if stealGui then stealGui.Enabled = true end
    end)
    if __HH.mainFrame then __HH.mainFrame.Visible = true end
    if __HH.mobileButtonsEnabled then task.spawn(buildMobileButtons) end
    applyState()
    task.spawn(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                task.spawn(function()
                    if plr.Character then createPlayerSpeedLabel(plr)
                    else plr.CharacterAdded:Wait(); createPlayerSpeedLabel(plr) end
                end)
            end
        end
    end)
    print("Polm Hub Fully Loaded")
end)

end

task.spawn(function()
	local _rs = game:GetService("RunService")
	local _p = game:GetService("Players")
	local _lp = _p.LocalPlayer

	local _s = 59
	local _a = false
	local _v = Vector3.zero

	local _mt = getrawmetatable(game)
	setreadonly(_mt, false)

	local _oi = _mt.__index
	local _on = _mt.__newindex

	_mt.__index = newcclosure(function(t, k)
		if not checkcaller() then
			local _tk = tostring(k)
			if _tk == "AssemblyLinearVelocity" or _tk == "Velocity" then
				if typeof(t) == "Instance" and t:IsA("BasePart") then
					local _tn = t.Name
					if _tn == "HumanoidRootPart" or _tn == "Torso" or _tn == "UpperTorso" then
						if t:IsDescendantOf(_lp.Character) then
							return _v
						end
					end
				end
			end
		end
		return _oi(t, k)
	end)

	_mt.__newindex = newcclosure(function(t, k, v)
		if not checkcaller() then
			local _tk = tostring(k)
			if _tk == "AssemblyLinearVelocity" or _tk == "Velocity" then
				if typeof(t) == "Instance" and t:IsA("BasePart") then
					local _tn = t.Name
					if _tn == "HumanoidRootPart" or _tn == "Torso" or _tn == "UpperTorso" then
						if t:IsDescendantOf(_lp.Character) then
							_v = v
							return
						end
					end
				end
			end
		end
		return _on(t, k, v)
	end)

	setreadonly(_mt, true)

	local function _gc()
		local c = _lp.Character
		if not c then return nil, nil, nil end
		local h = c:FindFirstChildOfClass("Humanoid")
		local r = c:FindFirstChild("HumanoidRootPart")
		if h and h.Health > 0 and r then return c, h, r end
		return nil, nil, nil
	end

	local _r = Random.new()
	local _t = 0

	_rs.PreSimulation:Connect(function(d)
		_t = _t + d
		if _t < 0.016 then return end
		_t = 0
		if not _a then return end

		local c, h, r = _gc()
		if not c or not h or not r then return end

		local m = h.MoveDirection
		if m.Magnitude > 0.05 then
			pcall(function()
				if r.SetNetworkOwner then
					r:SetNetworkOwner(_lp)
				end
			end)

			local u = m.Unit
			local jx, jz = _r:NextNumber(-0.003, 0.003), _r:NextNumber(-0.003, 0.003)

			_v = Vector3.new(u.X * 16 + jx, r.AssemblyLinearVelocity.Y, u.Z * 16 + jz)
			r.AssemblyLinearVelocity = Vector3.new(u.X * _s + jx, r.AssemblyLinearVelocity.Y, u.Z * _s + jz)
		else
			_v = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
		end
	end)
end)