
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
 



-- ============================================================
-- SKY THEME SYSTEM
-- ============================================================
local CANDY_SKY_TAG = "GrinchSkyTheme"
local currentSkyTheme = "Night"
local CANDY_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
local function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
local function CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- STATE
-- ============================================================
local TS=TweenService
local LP=Players.LocalPlayer
local NS,CS=60,30
local LAGGER_SPEED=15
local LAGGER_CARRY_SPEED=24.5
local carrySpeedActive = false
local laggerModeEnabled = false
local laggerCarryActive = false

local antiRagdollEnabled,infJumpEnabled=false,false
local medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
local medusaResetEnabled = false -- unused, kept for config compat
local medusaDebounce,medusaLastUsed,dropActive=false,0,false
local autoLeftEnabled,autoRightEnabled=false,false
local autoLeftSetVisual,autoRightSetVisual=nil,nil
local speedLabel=nil
local autoBatEnabled=false
local aimbotV2Enabled=false
local autoSwingEnabled=true
local autoMoveSwingEnabled=false
local autoMoveSwingInterval=0.3
local _alSwingDebounce=false
local _arSwingDebounce=false
local autoBatSetVisual=nil
local resetAutoBatMotion=nil
local setBatCounterVisual=nil
local startBatCounter,stopBatCounter
local antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
local stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
local unwalkSavedAnimate,_anyKeyListening=false,nil
local autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,20,nil,nil
local cursedResetRemote=nil
local CURSED_RESET_GUID="f888ee6e-c86d-46e1-93d7-0639d6635d42"
local guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
local mobileButtonsSize=80
local circleButtonsEnabled=false
local stealBarFrame
local mobBtnRefs={}
local mobGuiRef=nil
local fovValue=80
local fovOptions={80,120,180}
local fovIndex=1
local laggerModePillRef=nil
local carryModePillRef=nil
local autoSwitchSpeedEnabled=false -- unused
local mobBtnTransparencyEnabled=false
local perButtonDragEnabled=false
local antiKickEnabled=false
local antiKickSetVisual=nil
local brainrotDetected=false
local activeBatBillboard=nil
local activeMedusaBillboard=nil
local ragdollGuiEnabled=false  -- removed from GUI
local persistentRagdollGui=nil -- reference to a persistent "always on" display
local uiLocked=false
local infJumpMode="manual"
local holdInfJumpConn=nil
local DROP_ASCEND_DURATION=0.2
local DROP_ASCEND_SPEED=150

local MOB_POS_FILE="grinchvs_btnpos.json"
local function loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end; return {}
end
local function saveBtnPositions()
    if not writefile then return end; if not mobGuiRef then return end
    local out={}
    for _,child in ipairs(mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key=child:GetAttribute("BtnKey")
            out[key]={xs=child.Position.X.Scale,xo=child.Position.X.Offset,ys=child.Position.Y.Scale,yo=child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
end
task.spawn(function() while true do task.wait(3);pcall(saveBtnPositions) end end)

local refreshSpeedModeLabel,saveConfig
local startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter
local startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag,enableStretchRez,disableStretchRez
local startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor,cursedInstaReset
local startAutoSteal,stopAutoSteal,enableAntiKick,disableAntiKick,toggleCarryMode,toggleLaggerMode,toggleLaggerCarryMode

local function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(80,200,50)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(80,200,50))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
local fovConn=nil
local function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=fovValue end end)
end
applyFOV()

local function createRagdollBillboard(duration,labelText,color)
    if not ragdollGuiEnabled then return nil end
    local PINK  = color or Color3.fromRGB(80,200,50)
    local BG    = Color3.fromRGB(6,6,6)
    local WHITE = Color3.fromRGB(255,255,255)
    local W,H   = 210,80
    local guiName="GrinchRagdollTimer_"..labelText
    pcall(function()
        local cg=game:GetService("CoreGui");local old=cg:FindFirstChild(guiName);if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(guiName);if o then o:Destroy() end end
    end)
    local sg=Instance.new("ScreenGui")
    sg.Name=guiName;sg.ResetOnSpawn=false;sg.IgnoreGuiInset=true;sg.DisplayOrder=25
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    if not pcall(function() sg.Parent=game:GetService("CoreGui") end) then sg.Parent=LP:WaitForChild("PlayerGui") end
    -- Outer card — dark, thick pink border, matches photo
    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,W,0,H);card.Position=UDim2.new(0.5,-W/2,0,58)
    card.BackgroundColor3=BG;card.BackgroundTransparency=0.05
    card.BorderSizePixel=0;card.ZIndex=30;card.Active=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    -- Thick animated pink border
    local stroke=Instance.new("UIStroke",card)
    stroke.Color=PINK;stroke.Thickness=3;stroke.Transparency=0.05
    task.spawn(function()
        local t=0
        while stroke and stroke.Parent do
            t=t+0.05
            stroke.Transparency=0.02+math.abs(math.sin(t*2.5))*0.25
            stroke.Color=Color3.fromRGB(255,math.clamp(math.floor(PINK.G*255+math.abs(math.sin(t*1.5))*35),0,255),math.clamp(math.floor(PINK.B*255+math.abs(math.sin(t*1.5))*25),0,255))
            task.wait(0.04)
        end
    end)
    -- Title (white bold, centered, photo style — no colored bar)
    local titleLbl=Instance.new("TextLabel",card)
    titleLbl.Size=UDim2.new(1,-16,0,28);titleLbl.Position=UDim2.new(0,8,0,6)
    titleLbl.BackgroundTransparency=1
    titleLbl.Text=(labelText=="RAGDOLL" and "RAGDOLL TIMER" or (labelText=="STONE" and "STONE TIMER" or labelText.." TIMER"))
    titleLbl.TextColor3=WHITE;titleLbl.Font=Enum.Font.GothamBlack;titleLbl.TextSize=13
    titleLbl.TextXAlignment=Enum.TextXAlignment.Center;titleLbl.ZIndex=32
    -- Thin pink divider under title
    local divider=Instance.new("Frame",card)
    divider.Size=UDim2.new(1,-20,0,1);divider.Position=UDim2.new(0,10,0,34)
    divider.BackgroundColor3=PINK;divider.BackgroundTransparency=0.5;divider.BorderSizePixel=0;divider.ZIndex=31
    -- Countdown label (big, pink, shimmer)
    local timerLbl=Instance.new("TextLabel",card)
    timerLbl.Size=UDim2.new(1,0,0,H-38);timerLbl.Position=UDim2.new(0,0,0,36)
    timerLbl.BackgroundTransparency=1;timerLbl.Text=string.format("%.1f",duration).."s"
    timerLbl.TextColor3=PINK;timerLbl.Font=Enum.Font.GothamBlack;timerLbl.TextSize=24
    timerLbl.TextXAlignment=Enum.TextXAlignment.Center;timerLbl.ZIndex=32
    local shimmer=addShimmerToLabel(timerLbl,PINK,WHITE)
    task.spawn(function() local t=0;while timerLbl and timerLbl.Parent do t=t+0.04;shimmer.Offset=Vector2.new(math.sin(t)*0.5,0);task.wait(0.04) end end)
    -- Drag support
    local dragStart,dragStartPos,dragging=nil,nil,false
    card.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true;dragStart=inp.Position;dragStartPos=card.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-dragStart
            card.Position=UDim2.new(dragStartPos.X.Scale,dragStartPos.X.Offset+d.X,dragStartPos.Y.Scale,dragStartPos.Y.Offset+d.Y)
        end
    end)
    -- Auto-countdown and destroy
    local startTime=tick();local conn
    conn=RunService.Heartbeat:Connect(function()
        local remaining=math.max(0,duration-(tick()-startTime))
        if remaining<=0 then conn:Disconnect();pcall(function() sg:Destroy() end)
        elseif timerLbl and timerLbl.Parent then timerLbl.Text=string.format("%.1f",remaining).."s" end
    end)
    return sg
end
local function onHumanoidStateChanged(old,new)
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not activeBatBillboard then
        activeBatBillboard=createRagdollBillboard(2.6,"RAGDOLL",Color3.fromRGB(80,200,50))
        task.delay(2.6,function() if activeBatBillboard then pcall(function() activeBatBillboard:Destroy() end);activeBatBillboard=nil end end)
    end
end
local function onMedusaStateChanged()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not activeMedusaBillboard then
        activeMedusaBillboard=createRagdollBillboard(4.5,"STONE",Color3.fromRGB(255,255,255))
        task.delay(4.5,function() if activeMedusaBillboard then pcall(function() activeMedusaBillboard:Destroy() end);activeMedusaBillboard=nil end end)
    end
end
local function setupRagdollTriggers()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.StateChanged:Connect(onHumanoidStateChanged);hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged) end
end
local function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("GrinchSpeedBB") then head.GrinchSpeedBB:Destroy() end
    local bb=Instance.new("BillboardGui",head);bb.Name="GrinchSpeedBB";bb.Size=UDim2.new(0,140,0,52);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
    local discordLabel=Instance.new("TextLabel",bb);discordLabel.Size=UDim2.new(1,0,0.4,0);discordLabel.BackgroundTransparency=1;discordLabel.Text=".gg/grinchduels"
    discordLabel.TextColor3=Color3.fromRGB(80,200,50);discordLabel.Font=Enum.Font.GothamBold;discordLabel.TextScaled=true;discordLabel.TextStrokeTransparency=0
    speedLabel=Instance.new("TextLabel",bb);speedLabel.Size=UDim2.new(1,0,0.5,0);speedLabel.Position=UDim2.new(0,0,0.4,0);speedLabel.BackgroundTransparency=1;speedLabel.Text="0"
    speedLabel.TextColor3=Color3.fromRGB(255,255,255);speedLabel.Font=Enum.Font.GothamBold;speedLabel.TextScaled=true;speedLabel.TextStrokeTransparency=0
    local gr1=addShimmerToLabel(speedLabel,Color3.fromRGB(80,200,50),Color3.fromRGB(255,255,255))
    local gr2=addShimmerToLabel(discordLabel,Color3.fromRGB(190,160,255),Color3.fromRGB(255,255,255))
    task.spawn(function() local t=0;while bb and bb.Parent do t=t+0.03;gr1.Offset=Vector2.new(math.sin(t)*0.4,0);gr2.Offset=Vector2.new(math.sin(t)*0.4,0);task.wait(0.04) end end)
end
local function getActiveMoveSpeed()
    if laggerCarryActive then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end
local function getAutoPathSpeed()
    if laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

local function manualJumpBoost(boost)
    if not infJumpEnabled or infJumpMode~="manual" then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if root then root.Velocity=Vector3.new(root.Velocity.X,boost,root.Velocity.Z) end
end
local function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn=RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or infJumpMode~="hold" then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not root or not hum then return end
        local isJumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump==true)
        if isJumpHeld and root.Velocity.Y<35 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end)
end
local function stopHoldInfJump() if holdInfJumpConn then holdInfJumpConn:Disconnect();holdInfJumpConn=nil end end
UIS.JumpRequest:Connect(function() manualJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        task.delay(0.12,function() if UIS:IsKeyDown(Enum.KeyCode.Space) then manualJumpBoost(50) end end)
    end
end)
RunService.Heartbeat:Connect(function() if UIS:IsKeyDown(Enum.KeyCode.Space) then manualJumpBoost(50) end end)

-- Blacklist URL removed as requested

local _antiKickConns={}
enableAntiKick=function()
    antiKickEnabled=true
    task.spawn(function()
        while antiKickEnabled do
            task.wait(0.5);local char=LP.Character
            if char then
                for _,tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n=tool.Name:lower()
                        if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                            brainrotDetected=true
                            if autoBatEnabled then autoBatEnabled=false;if resetAutoBatMotion then resetAutoBatMotion() end;if autoBatSetVisual then autoBatSetVisual(false) end end
                            if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end end
                            if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end end
                        else brainrotDetected=false end
                    end
                end
            end
        end
    end)
end
disableAntiKick=function()
    antiKickEnabled=false;brainrotDetected=false
    for _,c in ipairs(_antiKickConns) do pcall(function() c:Disconnect() end) end;_antiKickConns={}
end
pcall(function()
    if hookfunction and newcclosure then
        local o; o = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return o(self, ...)
        end))
    end
end)
task.spawn(function()
    task.wait(2)
    if not cursedResetRemote then
        for _, desc in pairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
                cursedResetRemote = desc; break
            end
        end
    end
end)
cursedInstaReset=function()
    if not cursedResetRemote then
        for _, desc in pairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then cursedResetRemote = desc; break end
        end
    end
    if not cursedResetRemote then return end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character then
        pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end); return
    end
    if humanoid and humanoid.Health <= 0 then
        pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end); return
    end
    local resetDetected = false
    local conns = {}
    if humanoid then
        table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
        table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then resetDetected = true end
        end))
    end
    if character then
        table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then resetDetected = true end
        end))
    end
    task.spawn(function()
        local attempts = 0
        while not resetDetected and attempts < 50 do
            attempts = attempts + 1
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
            task.wait()
        end
        for _, conn in pairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local KB={
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    AimbotV2={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    LaggerCarryToggle={kb=nil,gp=nil},   -- new
    NormalSpeed={kb=nil,gp=nil},         -- new
    AntiDesync={kb=nil,gp=nil},
    LaggerPanel={kb=nil,gp=nil}
}
local AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal={AutoStealEnabled=false,StealRadius=60,StealDuration=1.4,Data={}}
local isStealing,stealStartTime=false,nil
local Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
local MEDUSA_COOLDOWN=25;local batCounterDebounce=false
local modeValLbl;local lastMoveDir=Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local function isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
local function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    local plot=plots:FindFirstChild(plotName);if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end
local function isNearPodiumWithPrompt()
    local char=LP.Character;local hrpL=char and char:FindFirstChild("HumanoidRootPart");if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums");if not podiums then continue end
        for _,podium in ipairs(podiums:GetChildren()) do
            local base=podium:FindFirstChild("Base");if not base then continue end
            local sp=base:FindFirstChild("Spawn");if not sp then continue end
            local d=(hrpL.Position-sp.Position).Magnitude;if d>Steal.StealRadius then continue end
            local att=sp:FindFirstChild("PromptAttachment");if not att then continue end
            for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
        end
    end
    return false,math.huge
end
local function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            local base=pod:FindFirstChild("Base");local sp=base and base:FindFirstChild("Spawn")
            if sp then
                local d=(sp.Position-root.Position).Magnitude
                if d<=Steal.StealRadius and dist>d then
                    local att=sp:FindFirstChild("PromptAttachment")
                    if att then for _,prompt in ipairs(att:GetChildren()) do if prompt:IsA("ProximityPrompt") and prompt.ActionText:find("Steal") then nearest,dist=prompt,d end end end
                end
            end
        end
    end
    return nearest
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
    local data=Steal.Data[prompt];if not data.ready then return end
    data.ready=false;isStealing=true;stealStartTime=tick()
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        data.ready=true;isStealing=false;stealStartTime=nil
    end)
end
startAutoSteal=function()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p=findNearestPrompt();if p then executeSteal(p) end
    end)
end
stopAutoSteal=function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    isStealing=false;stealStartTime=nil
end
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then for _,part in ipairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end end end
end)
RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");local hrp=char:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
        local md=hum.MoveDirection;local spd=getActiveMoveSpeed()
        if md.Magnitude>0 then lastMoveDir=md;hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
            local anyHeld=false;for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
            if anyHeld then hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) end
        end
    end
    if speedLabel then speedLabel.Text=string.format("%.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5);setupSpeedIndicator(char);setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
end)
if LP.Character then setupSpeedIndicator(LP.Character);setupRagdollTriggers() end
local alConn,arConn=nil,nil;local alPhase,arPhase=1,1
stopAutoLeft=function()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end
startAutoLeft=function()
    if alConn then alConn:Disconnect() end;alPhase=1
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then alPhase=2;local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end;alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;return end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _alSwingDebounce then
            _alSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _alSwingDebounce=false end)
        end
    end)
end
startAutoRight=function()
    if arConn then arConn:Disconnect() end;arPhase=1
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then arPhase=2;local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end;arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;return end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _arSwingDebounce then
            _arSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _arSwingDebounce=false end)
        end
    end)
end
runDrop=function()
    if dropActive then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    dropActive=true;local t0=tick();local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect();dropActive=false;return end
        if tick()-t0>=DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp=RaycastParams.new();rp.FilterDescendantsInstances={char};rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then local hum2=char:FindFirstChildOfClass("Humanoid");local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2);r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z);r.AssemblyLinearVelocity=Vector3.new(0,0,0) end
            dropActive=false;return end
        r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
    end)
end
local function doAutoTPDown(force)
    local char=LP.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end
startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function() while autoTPEnabled do task.wait(0.1);pcall(function() doAutoTPDown(false) end) end end)
end
stopAutoTP=function() autoTPEnabled=false;if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end
local STRETCH_NAME="Grinch_Stretch"
enableStretchRez=function()
    stretchRezEnabled=true;if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function() RunService:BindToRenderStep(STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end
disableStretchRez=function() stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end) end
local defLightBrightness,defLightClock,defLightAmbient
local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end
enableAntiLag=function()
    removeAccessoriesEnabled=true;antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness;defLightClock=defLightClock or Lighting.ClockTime;defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1;Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end end) end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end)
end
disableAntiLag=function()
    removeAccessoriesEnabled=false;antiLagEnabled=false;if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
    pcall(function() if defLightBrightness then Lighting.Brightness=defLightBrightness end;if defLightClock then Lighting.ClockTime=defLightClock end;if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end;Lighting.ExposureCompensation=0 end)
end
local function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if medusaDebounce then return end;if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if medusaResetEnabled then
                cursedInstaReset()
            elseif medusaCounterEnabled then
                useMedusaCounter()
            end
        end
    end)
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char=LP.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true;task.spawn(function() local bat=findBatForCounter();if bat then swingBatForCounter(bat,char) end;task.wait(0.5);batCounterDebounce=false end)
        end
    end)
end
stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end;batCounterDebounce=false end
local aimbotConn=nil
local aimbotV2Conn=nil
local function findBat()
    local char=LP.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end
local function getClosestTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart");local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude;if dist<minDist then minDist=dist;closest=tRoot end end
        end
    end
    return closest
end
local function swingCurrentBat()
    if not autoSwingEnabled then return end;local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end
local function getClosestPlayerAim(maxDist)
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not root then return nil,math.huge end
    local closest,minDist=nil,maxDist or math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart");local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude;if dist<minDist then minDist=dist;closest=plr end end
        end
    end
    return closest,minDist
end
local _predBall=nil
startBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect() end;autoBatEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");local hum0=char:FindFirstChildOfClass("Humanoid")
    if not root or not hum0 then return end;hum0.AutoRotate=false
    
    local AIMBOT_SPEED=62;local MELEE_OFFSET=3;local velHistory={};local MAX_HIST=6;local lastTargetPos=nil
    
    aimbotConn=RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c=LP.Character;if not c then return end
        local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end
        local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end
        
        local bat=findBat();if bat and bat.Parent~=c then pcall(function() hum:EquipTool(bat) end) end
        
        local target=getClosestTarget()
        if not target then swingCurrentBat();if _predBall then _predBall:Destroy();_predBall=nil end;velHistory={};lastTargetPos=nil;return end
        
        local targetVel=target.AssemblyLinearVelocity;local targetPos=target.Position
        
        if lastTargetPos and (targetPos-lastTargetPos).Magnitude>20 then velHistory={} end
        lastTargetPos=targetPos
        
        table.insert(velHistory,targetVel);if #velHistory>MAX_HIST then table.remove(velHistory,1) end
        local smoothVel=Vector3.zero;local totalW=0
        for i,v in ipairs(velHistory) do local w=i/#velHistory;smoothVel=smoothVel+v*w;totalW=totalW+w end
        if totalW>0 then smoothVel=smoothVel/totalW end
        
        local speed=smoothVel.Magnitude
        local predictTime=#velHistory<2 and 0 or math.clamp(speed/150,0.05,0.2)
        local predictedPos=targetPos+smoothVel*predictTime
        
        local toTarget=predictedPos-hrp.Position
        if toTarget.Magnitude>0.5 then
            local goalCF=CFrame.lookAt(hrp.Position,hrp.Position+toTarget)
            local diffCF=hrp.CFrame:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-3,3);ry=math.clamp(ry,-3,3);rz=math.clamp(rz,-3,3)
            hrp.AssemblyAngularVelocity=hrp.CFrame:VectorToWorldSpace(Vector3.new(rx*50,ry*50,rz*50))
        end
        
        local dirToTarget=predictedPos-hrp.Position;local targetStandPos=predictedPos
        if dirToTarget.Magnitude>0 then targetStandPos=predictedPos-(dirToTarget.Unit*MELEE_OFFSET) end
        
        local moveDir=targetStandPos-hrp.Position
        if moveDir.Magnitude>1 then
            hrp.AssemblyLinearVelocity=moveDir.Unit*AIMBOT_SPEED
        else
            hrp.AssemblyLinearVelocity=smoothVel
        end
        swingCurrentBat()
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect();aimbotConn=nil end;autoBatEnabled=false
    if _predBall then _predBall:Destroy();_predBall=nil end
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end
    if autoTPEnabled then startAutoTP() end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
startAimbotV2=function()
    if aimbotV2Conn then aimbotV2Conn:Disconnect() end;aimbotV2Enabled=true
    if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    local FACE_OFFSET=3;local VYSE_HIT_DIST=12;local AIMBOT_SPD=55
    aimbotV2Conn=RunService.Heartbeat:Connect(function()
        if not aimbotV2Enabled then return end
        local char2=LP.Character;if not char2 then return end
        local root2=char2:FindFirstChild("HumanoidRootPart");if not root2 then return end
        local target,dist=getClosestPlayerAim()
        if target and target.Character then
            local tr=target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local head=target.Character:FindFirstChild("Head")
                local basePos=head and head.Position or tr.Position
                local aimPoint=basePos+tr.CFrame.LookVector*FACE_OFFSET
                local direction=(aimPoint-root2.Position).Unit
                root2.Velocity=direction*AIMBOT_SPD
                if dist<=VYSE_HIT_DIST and autoSwingEnabled then swingCurrentBat() end
            end
        else
            root2.Velocity=Vector3.new(0,root2.Velocity.Y,0)
        end
    end)
    if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(true) end
end
stopAimbotV2=function()
    if aimbotV2Conn then aimbotV2Conn:Disconnect();aimbotV2Conn=nil end;aimbotV2Enabled=false
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(0,root.Velocity.Y,0) end
    if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end
end
queueAutoBatStart=function()
    if antiKickEnabled and brainrotDetected then return end
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end
saveConfig=function()
    local function ks(e)
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
    local cfg={normalSpeed=NS,carrySpeed=CS,dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),aimbotV2Key=ks(KB.AimbotV2),laggerToggleKey=ks(KB.LaggerToggle),laggerCarryToggleKey=ks(KB.LaggerCarryToggle),normalSpeedKey=ks(KB.NormalSpeed),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),antiDesyncKey=ks(KB.AntiDesync),grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,carrySpeedActive=carrySpeedActive,laggerModeEnabled=laggerModeEnabled,laggerCarryActive=laggerCarryActive,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,autoBat=autoBatEnabled,aimbotV2=aimbotV2Enabled,autoSwing=autoSwingEnabled,unwalkEnabled=unwalkEnabled,antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,guiTransparencyEnabled=guiTransparencyEnabled,mobileButtonsEnabled=mobileButtonsEnabled,mobileButtonsLocked=mobileButtonsLocked,mobileButtonsSize=mobileButtonsSize,circleButtonsEnabled=circleButtonsEnabled,antiKick=antiKickEnabled,fovValue=fovValue,perButtonDrag=perButtonDragEnabled,skyTheme=currentSkyTheme,medusaReset=nil,autoMoveSwing=autoMoveSwingEnabled,autoMoveSwingInterval=autoMoveSwingInterval,ragdollGui=ragdollGuiEnabled}
    if writefile then pcall(function() writefile("grinchvs.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
local function resetAllSettings()
    NS=60;CS=30;LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5;carrySpeedActive=false;laggerModeEnabled=false;laggerCarryActive=false
    antiRagdollEnabled=false;infJumpEnabled=false;infJumpMode="manual"
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;autoSwingEnabled=true;autoMoveSwingEnabled=false
    autoTPEnabled=false;autoTPHeight=20;antiLagEnabled=false;stretchRezEnabled=false
    Steal.AutoStealEnabled=false;Steal.StealRadius=60;Steal.StealDuration=1.4
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsSize=80
    circleButtonsEnabled=false;antiKickEnabled=false;uiLocked=false;fovValue=80;fovIndex=1
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil};KB.InstaReset={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    KB.LaggerCarryToggle={kb=nil,gp=nil};KB.NormalSpeed={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopAutoTP();stopHoldInfJump()
    if stretchRezEnabled then disableStretchRez() end;if antiLagEnabled then disableAntiLag() end;saveConfig()
end
local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual
local setTranspVisual,setLockVisual,setMobVisual,setCircleBtnsVisual,setMedusaResetVisual
local normalBox,carryBox,laggerBox,radInput,autoTPHeightBox,durationBox
local mainFrame=nil
local _persistentConns={}
local function trackConn(conn) table.insert(_persistentConns,conn);return conn end
local function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerCarryActive then modeValLbl.Text="Lagger Carry"
        elseif laggerModeEnabled then modeValLbl.Text="Lagger"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local PINK2=Color3.fromRGB(40,100,25);local OFF=Color3.fromRGB(12,12,12);local WHITE=Color3.fromRGB(255,255,255);local GRAY=Color3.fromRGB(55,110,35)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and WHITE or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local PINK2=Color3.fromRGB(40,100,25);local OFF=Color3.fromRGB(12,12,12);local WHITE=Color3.fromRGB(255,255,255);local GRAY=Color3.fromRGB(55,110,35)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and WHITE or GRAY}):Play()
    end
end
toggleCarryMode=function()
    carrySpeedActive = not carrySpeedActive
    if carrySpeedActive then
        laggerModeEnabled = false
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end
toggleLaggerMode=function()
    if laggerModeEnabled then
        laggerModeEnabled = false
        laggerCarryActive = true
    else
        laggerModeEnabled = true
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end
toggleLaggerCarryMode=function()
    if laggerCarryActive then
        laggerCarryActive = false
        laggerModeEnabled = true
    else
        laggerCarryActive = true
        laggerModeEnabled = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end

-- ============================================================
-- ANTI-RAGDOLL (REPLACED WITH NEW LOGIC)
-- ============================================================
startAntiRagdoll = function()
    if Conns.antiRag then return end
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        local st = hum:GetState()
        local isRag = hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown

        -- also catch server‑set ragdoll end time attribute
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            isRag = true
        end

        if isRag then
            -- clear server ragdoll attribute
            pcall(function()
                LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)

            -- destroy ragdoll constraints
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") then
                    pcall(function() d:Destroy() end)
                end
                if d:IsA("Attachment") and d.Name:find("RagdollAttachment") then
                    pcall(function() d:Destroy() end)
                end
            end

            -- re‑enable all Motor6D
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("Motor6D") and not d.Enabled then
                    d.Enabled = true
                end
            end

            -- force running state (if alive)
            if hum.Health > 0 then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end

            -- restore camera subject
            pcall(function()
                workspace.CurrentCamera.CameraSubject = hum
            end)

            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

stopAntiRagdoll = function()
    if Conns.antiRag then
        Conns.antiRag:Disconnect()
        Conns.antiRag = nil
    end
end

startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end

-- ============================================================
-- STEAL BAR
-- ============================================================
local function createStealBar()
    for _,n in ipairs({"GrinchStealBar"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    local PINK=Color3.fromRGB(80,200,50)
    local WHITE=Color3.fromRGB(255,255,255)
    local BARBG=Color3.fromRGB(6,6,6)
    local SB_W,SB_H=260,32
    local stealGui=Instance.new("ScreenGui");stealGui.Name="GrinchStealBar";stealGui.ResetOnSpawn=false;stealGui.IgnoreGuiInset=true;stealGui.DisplayOrder=8
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    if gethui then stealGui.Parent=gethui() elseif not pcall(function() stealGui.Parent=game:GetService("CoreGui") end) then stealGui.Parent=LP:WaitForChild("PlayerGui") end
    -- silence.vs styled steal bar
    local SB_BG    = Color3.fromRGB(10,10,10)
    local SB_PINK  = Color3.fromRGB(80,200,50)
    local SB_PINK2 = Color3.fromRGB(120,230,80)
    local SB_WHITE = Color3.fromRGB(255,255,255)
    local SB_GRAY  = Color3.fromRGB(55,110,35)
    stealBarFrame=Instance.new("Frame",stealGui)
    stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H);stealBarFrame.Position=UDim2.new(0.5,-SB_W/2,0.06,0)
    stealBarFrame.BackgroundColor3=SB_BG;stealBarFrame.BorderSizePixel=0;stealBarFrame.ZIndex=20;stealBarFrame.ClipsDescendants=true
    Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(1,0)
    local sbStroke=Instance.new("UIStroke",stealBarFrame);sbStroke.Color=SB_PINK;sbStroke.Thickness=2;sbStroke.Transparency=0.1
    task.spawn(function()
        local t=0
        while sbStroke and sbStroke.Parent do
            t=t+0.05
            sbStroke.Transparency=0.05+math.abs(math.sin(t*2.5))*0.25
            sbStroke.Color=Color3.fromRGB(
                math.clamp(math.floor(60+math.abs(math.sin(t*1.5))*40),0,255),
                math.clamp(math.floor(200+math.abs(math.sin(t*1.5))*40),0,255),
                math.clamp(math.floor(30+math.abs(math.sin(t*1.5))*20),0,255))
            task.wait(0.04)
        end
    end)
    -- Fill bar with shimmer gradient
    local fillLine=Instance.new("Frame",stealBarFrame);fillLine.Size=UDim2.new(0,0,1,0)
    fillLine.BackgroundColor3=SB_PINK;fillLine.BorderSizePixel=0;fillLine.ZIndex=21
    Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
    local fillGrad=Instance.new("UIGradient",fillLine)
    fillGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(40,100,25)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(120,230,80)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(40,100,25))
    })
    task.spawn(function() local t=0;while fillGrad and fillGrad.Parent do t=t+0.04;fillGrad.Offset=Vector2.new(math.sin(t)*0.5,0);task.wait(0.04) end end)
    -- Left section: STEAL label + pct
    local stealSection=Instance.new("Frame",stealBarFrame)
    stealSection.Size=UDim2.new(0,110,1,0);stealSection.Position=UDim2.new(0,14,0,0)
    stealSection.BackgroundTransparency=1;stealSection.ZIndex=25
    local stealLbl=Instance.new("TextLabel",stealSection)
    stealLbl.Size=UDim2.new(0,52,1,0);stealLbl.Position=UDim2.new(0,0,0,0)
    stealLbl.BackgroundTransparency=1;stealLbl.Text="STEAL"
    stealLbl.TextColor3=SB_WHITE;stealLbl.Font=Enum.Font.GothamBlack;stealLbl.TextSize=11
    stealLbl.TextXAlignment=Enum.TextXAlignment.Left;stealLbl.ZIndex=26
    -- shimmer on STEAL label
    local stealGrad=Instance.new("UIGradient",stealLbl)
    stealGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,SB_PINK),ColorSequenceKeypoint.new(0.5,SB_WHITE),ColorSequenceKeypoint.new(1,SB_PINK)})
    stealGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    task.spawn(function() local t=0;while stealGrad and stealGrad.Parent do t=t+0.04;stealGrad.Offset=Vector2.new(math.sin(t)*0.5,0);task.wait(0.04) end end)
    local pctLbl=Instance.new("TextLabel",stealSection)
    pctLbl.Size=UDim2.new(0,48,1,0);pctLbl.Position=UDim2.new(0,54,0,0)
    pctLbl.BackgroundTransparency=1;pctLbl.Text="0%"
    pctLbl.TextColor3=SB_PINK2;pctLbl.Font=Enum.Font.GothamBlack;pctLbl.TextSize=11
    pctLbl.TextXAlignment=Enum.TextXAlignment.Left;pctLbl.ZIndex=26
    -- Divider
    local div1=Instance.new("Frame",stealBarFrame);div1.Size=UDim2.new(0,1,0,SB_H*0.5);div1.Position=UDim2.new(0,128,0.5,-(SB_H*0.5)/2)
    div1.BackgroundColor3=SB_PINK;div1.BackgroundTransparency=0.55;div1.BorderSizePixel=0;div1.ZIndex=25
    -- Right section: FPS
    local fpsLbl=Instance.new("TextLabel",stealBarFrame)
    fpsLbl.Size=UDim2.new(0,100,1,0);fpsLbl.Position=UDim2.new(0,138,0,0)
    fpsLbl.BackgroundTransparency=1;fpsLbl.Text="FPS: --"
    fpsLbl.TextColor3=SB_GRAY;fpsLbl.Font=Enum.Font.GothamBold;fpsLbl.TextSize=10
    fpsLbl.TextXAlignment=Enum.TextXAlignment.Left;fpsLbl.ZIndex=26
    task.spawn(function()
        local frames=0;local t0=tick()
        while fpsLbl and fpsLbl.Parent do
            frames=frames+1;local now=tick()
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5)
                fpsLbl.Text="FPS: "..tostring(fps)
                frames=0;t0=now
            end
            task.wait()
        end
    end)
    task.spawn(function()
        while fillLine and fillLine.Parent do
            local now=tick()
            if Steal.AutoStealEnabled then
                local inRadius=isNearPodiumWithPrompt()
                local pct=0
                if isStealing and stealStartTime then
                    pct=math.clamp((now-stealStartTime)/Steal.StealDuration,0,1)
                    fillLine.Size=UDim2.new(pct,0,1,0);fillGrad.Offset=Vector2.new(math.sin(now*3)*0.5,0)
                elseif inRadius then
                    local cyclePos=(now%Steal.StealDuration)/Steal.StealDuration
                    pct=cyclePos*cyclePos*(3-2*cyclePos)
                    fillLine.Size=UDim2.new(pct,0,1,0);fillGrad.Offset=Vector2.new(math.sin(now*3)*0.5,0)
                else fillLine.Size=UDim2.new(0,0,1,0) end
                pctLbl.Text=math.floor(pct*100).."%"
            else
                fillLine.Size=UDim2.new(0,0,1,0);pctLbl.Text="0%"
            end
            task.wait(0.016)
        end
    end)
    local dragStart2,dragStartPos2,dragging2=nil,nil,false
    stealBarFrame.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging2=true;dragStart2=input.Position;dragStartPos2=stealBarFrame.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging2=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then dragging2=false;return end
        if dragging2 and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart2
            stealBarFrame.Position=UDim2.new(dragStartPos2.X.Scale,dragStartPos2.X.Offset+delta.X,dragStartPos2.Y.Scale,dragStartPos2.Y.Offset+delta.Y)
        end
    end)
end

-- ============================================================
-- MOBILE BUTTONS
-- ============================================================
local C_BTN_OFF_TRANSPARENCY_GLOBAL=0.15

local function destroyMobileButtons()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"GrinchMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
local function buildMobileButtons()
    destroyMobileButtons();if not mobileButtonsEnabled then return end
    local savedPositions=loadBtnPositions()
    perButtonDragEnabled=true -- free buttons, always individual drag

    -- OLD size formula restored (mobileButtonsSize default=80 → BTN_SIZE=44)
    local BTN_SIZE=math.floor(mobileButtonsSize*0.55)
    local BTN_GAP=10
    local CORNER_R=circleButtonsEnabled and BTN_SIZE or math.max(8,math.floor(BTN_SIZE*0.22))
    local fontSize=math.max(7,math.floor(mobileButtonsSize*0.10))

    -- 8 buttons, 2 cols, 4 rows — photo order:
    -- Row1: DROP BR    | AUTO LEFT
    -- Row2: BAT AIMBOT | AUTO RIGHT
    -- Row3: TP DOWN    | CARRY SPD
    -- Row4: LAGGER MODE | INSTA RESET
    -- Row5: AIMBOT V2  | (spare)
    local buttons={
        {key="drop",        label="DROP\nBR",       toggle=false, exclusive=false},
        {key="autoLeft",    label="AUTO\nLEFT",     toggle=true,  exclusive=true},
        {key="autoBat",     label="BAT\nAIMBOT",    toggle=true,  exclusive=true},
        {key="autoRight",   label="AUTO\nRIGHT",    toggle=true,  exclusive=true},
        {key="tpDown",      label="TP\nDOWN",       toggle=false, exclusive=false},
        {key="carrySpeed",  label="CARRY\nSPD",     toggle=true,  exclusive=false},
        {key="lagger",      label="LAGGER\nMODE",   toggle=true,  exclusive=false},
        {key="laggerCarry", label="LAGGER\nCARRY",  toggle=true,  exclusive=false},
        {key="instaReset",  label="INSTA\nRESET",   toggle=false, exclusive=false},
        {key="aimbotV2",    label="AIMBOT\nV2",     toggle=true,  exclusive=true},
    }

    local COLS=2
    local totalW=(COLS*(BTN_SIZE+BTN_GAP))-BTN_GAP
    local totalH=(math.ceil(#buttons/COLS)*(BTN_SIZE+BTN_GAP))-BTN_GAP

    -- Panel padding for background card
    local PAD=10

    local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local savedPanel=savedPositions["_panel"]
    local defPanelX=vp.X-BTN_SIZE-BTN_GAP-20
    local defPanelY=math.max(10,vp.Y/2-totalH/2)
    local panelXO=savedPanel and savedPanel.xo or defPanelX
    local panelYO=savedPanel and savedPanel.yo or defPanelY

    local mobGui=Instance.new("ScreenGui")
    mobGui.Name="GrinchMobileButtons";mobGui.ResetOnSpawn=false;mobGui.DisplayOrder=15;mobGui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if gethui then mobGui.Parent=gethui() elseif not pcall(function() mobGui.Parent=game:GetService("CoreGui") end) then mobGui.Parent=LP:WaitForChild("PlayerGui") end
    mobGuiRef=mobGui

    -- Colors exactly matching photo
    local PINK_ON      = Color3.fromRGB(80,200,50)
    local BTN_BG_OFF   = Color3.fromRGB(12,12,12)       -- dark maroon card
    local PANEL_BG     = Color3.fromRGB(8,8,8)        -- even darker panel behind buttons
    local BORDER_OFF   = Color3.fromRGB(30,70,15)      -- dim pink border when off
    local BORDER_ON    = Color3.fromRGB(80,200,50)     -- bright pink border when on
    local TEXT_OFF     = Color3.fromRGB(55,110,35)     -- soft pink-white text off
    local TEXT_ON      = Color3.fromRGB(255,255,255)     -- white text on
    local STROKE_W     = math.max(2,math.floor(BTN_SIZE*0.05))

    -- No panel — buttons are free, parented directly to mobGui

    for i,def in ipairs(buttons) do
        local col=(i-1)%COLS
        local rowN=math.floor((i-1)/COLS)
        local localX=PAD+col*(BTN_SIZE+BTN_GAP)
        local localY=PAD+rowN*(BTN_SIZE+BTN_GAP)

        -- Per-button saved positions (absolute screen coords)
        local initXO,initYO
        if perButtonDragEnabled then
            local sp=savedPositions[def.key]
            -- default: stack on right side of screen
            local defColX = vp.X - (COLS-col)*(BTN_SIZE+BTN_GAP) + BTN_GAP - 8
            local defRowY = math.max(10,vp.Y/2-totalH/2) + rowN*(BTN_SIZE+BTN_GAP)
            initXO=sp and sp.xo or defColX
            initYO=sp and sp.yo or defRowY
        else
            initXO=localX;initYO=localY
        end

        local frameParent=perButtonDragEnabled and mobGui or panel

        local frame=Instance.new("Frame",frameParent)
        frame.Name="MobBtn_"..def.key
        frame.Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)
        frame.Position=UDim2.new(0,initXO,0,initYO)
        frame.BackgroundColor3=BTN_BG_OFF
        frame.BackgroundTransparency=0
        frame.BorderSizePixel=0;frame.Active=true;frame.ZIndex=102
        frame:SetAttribute("BtnKey",def.key)

        local uic=Instance.new("UICorner",frame)
        uic.CornerRadius=circleButtonsEnabled and UDim.new(1,0) or UDim.new(0,CORNER_R)

        local fstroke=Instance.new("UIStroke",frame)
        fstroke.Color=BORDER_OFF;fstroke.Thickness=STROKE_W;fstroke.Transparency=0

        local btn=Instance.new("TextButton",frame)
        btn.Size=UDim2.new(1,0,1,0);btn.BackgroundTransparency=1
        btn.Text=def.label
        btn.TextColor3=TEXT_OFF
        btn.Font=Enum.Font.GothamBlack
        btn.TextSize=fontSize
        btn.LineHeight=1.1
        btn.TextWrapped=true;btn.AutoButtonColor=false;btn.ZIndex=105
        btn.TextStrokeTransparency=1

        local isOn=false

        local function setOn(v)
            isOn=v
            if v then
                frame:SetAttribute("BtnIsOn",true)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=PINK_ON}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=BORDER_ON,Thickness=STROKE_W+1}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=TEXT_ON}):Play()
            else
                frame:SetAttribute("BtnIsOn",false)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=BTN_BG_OFF}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=BORDER_OFF,Thickness=STROKE_W}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=TEXT_OFF}):Play()
            end
        end

        mobBtnRefs[def.key]=setOn

        local function flash()
            TweenService:Create(frame,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(80,255,50)}):Play()
            task.delay(0.18,function()
                TweenService:Create(frame,TweenInfo.new(0.1),{BackgroundColor3=BTN_BG_OFF}):Play()
            end)
        end

        -- Per-button drag
        local dragStart2,dragStartPos2,dragMoved,dragDown=nil,nil,false,false
        if perButtonDragEnabled then
            btn.InputBegan:Connect(function(input)
                if uiLocked then return end
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    dragMoved=false;dragDown=true;dragStart2=input.Position;dragStartPos2=frame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState==Enum.UserInputState.End then
                            dragDown=false;if dragMoved then pcall(saveBtnPositions) end
                        end
                    end)
                end
            end)
            btn.InputChanged:Connect(function(input)
                if dragDown and not uiLocked and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                    local delta=input.Position-dragStart2
                    if delta.Magnitude>4 then dragMoved=true end
                    if dragMoved then
                        frame.Position=UDim2.new(dragStartPos2.X.Scale,dragStartPos2.X.Offset+delta.X,dragStartPos2.Y.Scale,dragStartPos2.Y.Offset+delta.Y)
                    end
                end
            end)
        end

        btn.Activated:Connect(function()
            if dragMoved then return end

            if def.key=="tpDown" then runTPFloor();flash();return end
            if def.key=="drop" then runDrop();flash();return end
            if def.key=="instaReset" then cursedInstaReset();flash();return end

            if def.exclusive then
                local alreadyOn=(def.key=="autoLeft" and autoLeftEnabled) or (def.key=="autoRight" and autoRightEnabled) or (def.key=="autoBat" and autoBatEnabled) or (def.key=="aimbotV2" and aimbotV2Enabled)
                if alreadyOn then
                    if def.key=="autoLeft" then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;setOn(false)
                    elseif def.key=="autoRight" then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;setOn(false)
                    elseif def.key=="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;setOn(false)
                    elseif def.key=="aimbotV2" then stopAimbotV2();setOn(false) end
                    return
                end
                if autoLeftEnabled and def.key~="autoLeft" then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled and def.key~="autoRight" then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled and def.key~="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if aimbotV2Enabled and def.key~="aimbotV2" then stopAimbotV2();if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
                if def.key=="autoLeft" then autoLeftEnabled=true;startAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(true) end;setOn(true)
                elseif def.key=="autoRight" then autoRightEnabled=true;startAutoRight();if autoRightSetVisual then autoRightSetVisual(true) end;setOn(true)
                elseif def.key=="autoBat" then queueAutoBatStart();if autoBatSetVisual then autoBatSetVisual(true) end;setOn(true)
                elseif def.key=="aimbotV2" then startAimbotV2();setOn(true) end
                return
            end

            if def.key=="carrySpeed" then toggleCarryMode();setOn(carrySpeedActive);if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end;saveConfig();return end
            if def.key=="lagger" then toggleLaggerMode();setOn(laggerModeEnabled);if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end;if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end;saveConfig();return end
            if def.key=="laggerCarry" then toggleLaggerCarryMode();setOn(laggerCarryActive);if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end;saveConfig();return end
        end)
    end

    -- Sync initial states
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(aimbotV2Enabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end

-- ============================================================
-- MAIN GUI — Blossom Hub style: horizontal tabs, section labels, bordered rows
-- ============================================================
local function buildGui()
    clearPersistentConns();createStealBar()

    -- Color palette (dark maroon base, pink accent — Blossom Hub style)
    local BG         = Color3.fromRGB(6, 6, 6)      -- main background (very dark maroon)
    local BG2        = Color3.fromRGB(10, 10, 10)      -- header background
    local ROW_BG     = Color3.fromRGB(14, 14, 14)      -- row background
    local ROW_BORDER = Color3.fromRGB(30, 70, 15)      -- row border
    local WHITE      = Color3.fromRGB(255, 255, 255)
    local GRAY       = Color3.fromRGB(55, 110, 35)
    local INP        = Color3.fromRGB(10, 10, 10)
    local PINK       = Color3.fromRGB(80, 200, 50)
    local PINK2      = Color3.fromRGB(40, 100, 25)
    local PINK3      = Color3.fromRGB(30, 70, 15)
    local OFF        = Color3.fromRGB(12, 12, 12)
    local TAB_ACTIVE = Color3.fromRGB(80, 200, 50)
    local TAB_INACT  = Color3.fromRGB(55, 110, 35)
    local SECT_LBL   = Color3.fromRGB(80, 200, 50)   -- section label color

    for _,n in ipairs({"GrinchVS"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(n);if o then o:Destroy() end end
    end

    local gui=Instance.new("ScreenGui");gui.Name="GrinchVS";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if gethui then gui.Parent=gethui() elseif not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end

    -- Tall rectangle: 260 wide, 420 high (more height than length)
    local W, H = 260, 420
    mainFrame=Instance.new("Frame",gui);mainFrame.Name="Main"
    mainFrame.Size=UDim2.new(0,W,0,H);mainFrame.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
    mainFrame.BackgroundColor3=BG;mainFrame.BackgroundTransparency=guiTransparencyEnabled and 0.65 or 0
    mainFrame.BorderSizePixel=0;mainFrame.ClipsDescendants=true;mainFrame.ZIndex=5
    Instance.new("UICorner",mainFrame).CornerRadius=UDim.new(0,18)  -- no sharp edges

    local mfStroke=Instance.new("UIStroke",mainFrame);mfStroke.Color=PINK;mfStroke.Thickness=1.5;mfStroke.Transparency=0.3
    task.spawn(function()
        local t=0
        while mfStroke and mfStroke.Parent do
            t=t+0.05
            mfStroke.Transparency=0.4+math.sin(t*3)*0.25
            mfStroke.Color=Color3.fromRGB(math.floor(80+math.sin(t*2)*30),math.floor(200+math.sin(t*2)*20),50)
            task.wait(0.04)
        end
    end)

    local bgImage=Instance.new("ImageLabel",mainFrame);bgImage.Size=UDim2.new(1,0,1,0);bgImage.BackgroundTransparency=1
    bgImage.Image="rbxassetid://84153275206442"  -- specified asset ID
    bgImage.ZIndex=6;bgImage.ImageTransparency=0.85;bgImage.Visible=true
    Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,18)
    -- Subtle shimmer on background
    task.spawn(function()
        local t=0
        while bgImage and bgImage.Parent do
            t=t+0.02
            bgImage.ImageTransparency=0.82+math.sin(t*1.2)*0.08
            task.wait(0.04)
        end
    end)

    local bgWatermark=Instance.new("TextLabel",bgImage)
    bgWatermark.Size=UDim2.new(1,0,1,0);bgWatermark.BackgroundTransparency=1
    bgWatermark.Text="";bgWatermark.TextColor3=Color3.fromRGB(255,255,255)
    bgWatermark.Font=Enum.Font.GothamBlack;bgWatermark.TextSize=38
    bgWatermark.TextTransparency=0.4;bgWatermark.ZIndex=7
    bgWatermark.TextXAlignment=Enum.TextXAlignment.Center;bgWatermark.TextYAlignment=Enum.TextYAlignment.Center
    _G._GrinchDuels_bgImage=bgImage

    local _transpOriginals=nil
    local function applyTransparencyToGui(transparent)
        if not transparent then
            mainFrame.BackgroundTransparency=0
            if _transpOriginals then for frame,val in pairs(_transpOriginals) do if frame and frame.Parent then frame.BackgroundTransparency=val end end end
            bgImage.ImageTransparency=0.85;bgImage.Visible=true
            return
        end
        if not _transpOriginals then
            _transpOriginals={}
            local function snapshot(parent)
                for _,child in ipairs(parent:GetChildren()) do
                    if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child~=bgImage then _transpOriginals[child]=child.BackgroundTransparency end
                    snapshot(child)
                end
            end
            snapshot(mainFrame)
        end
        mainFrame.BackgroundTransparency=0.92
        for frame,_ in pairs(_transpOriginals) do if frame and frame.Parent then frame.BackgroundTransparency=0.88 end end
        bgImage.ImageTransparency=0.92;bgImage.Visible=true
    end

    -- Drag handler (only on header)
    local function dragHandle(handle)
        local dn,ds,sp,di=false
        handle.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true;ds=i.Position;sp=mainFrame.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
            end
        end)
        handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
        trackConn(UIS.InputChanged:Connect(function(i)
            if i==di and dn and not uiLocked then
                mainFrame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+(i.Position.X-ds.X),sp.Y.Scale,sp.Y.Offset+(i.Position.Y-ds.Y))
            end
        end))
    end

    -- ===== HEADER =====
    local headerH = 36
    local header=Instance.new("Frame",mainFrame)
    header.Size=UDim2.new(1,0,0,headerH)
    header.BackgroundColor3=BG2;header.BorderSizePixel=0;header.ZIndex=6
    Instance.new("UICorner",header).CornerRadius=UDim.new(0,18)
    -- Fix rounded corners blending into body
    local headerFix=Instance.new("Frame",mainFrame)
    headerFix.Size=UDim2.new(1,0,0,12);headerFix.Position=UDim2.new(0,0,0,headerH-10)
    headerFix.BackgroundColor3=BG2;headerFix.BorderSizePixel=0;headerFix.ZIndex=5
    -- Divider line below header
    local hDivider=Instance.new("Frame",mainFrame)
    hDivider.Size=UDim2.new(1,0,0,1);hDivider.Position=UDim2.new(0,0,0,headerH)
    hDivider.BackgroundColor3=PINK;hDivider.BackgroundTransparency=0.6;hDivider.BorderSizePixel=0;hDivider.ZIndex=7

    dragHandle(header)

    -- Title centered in header
    local titleLbl=Instance.new("TextLabel",header)
    titleLbl.Size=UDim2.new(1,-80,1,0);titleLbl.Position=UDim2.new(0,12,0,0)
    titleLbl.BackgroundTransparency=1;titleLbl.Text="GRINCH.VS"
    titleLbl.TextColor3=WHITE;titleLbl.Font=Enum.Font.GothamBlack
    titleLbl.TextSize=14;titleLbl.TextXAlignment=Enum.TextXAlignment.Left;titleLbl.ZIndex=8

    local discSmall=Instance.new("TextLabel",header)
    discSmall.Size=UDim2.new(0,120,0,12);discSmall.Position=UDim2.new(0,12,1,-14)
    discSmall.BackgroundTransparency=1;discSmall.Text="discord.gg/grinchduels"
    discSmall.TextColor3=PINK;discSmall.Font=Enum.Font.GothamBold
    discSmall.TextSize=8;discSmall.TextXAlignment=Enum.TextXAlignment.Left;discSmall.ZIndex=8

    -- Ping / FPS label (right side of header)
    local pingFpsLbl=Instance.new("TextLabel",header)
    pingFpsLbl.Size=UDim2.new(0,100,0,14);pingFpsLbl.Position=UDim2.new(1,-136,0,6)
    pingFpsLbl.BackgroundTransparency=1;pingFpsLbl.Text="-- ms · -- fps"
    pingFpsLbl.TextColor3=GRAY;pingFpsLbl.Font=Enum.Font.GothamBold
    pingFpsLbl.TextSize=8;pingFpsLbl.TextXAlignment=Enum.TextXAlignment.Right;pingFpsLbl.ZIndex=8
    task.spawn(function()
        local frames=0;local t0=tick()
        while pingFpsLbl and pingFpsLbl.Parent do
            frames=frames+1;local now=tick()
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5)
                local ok,ms=pcall(function() return LP:GetNetworkPing()*1000 end)
                pingFpsLbl.Text=(ok and math.floor(ms+0.5) or "--").."ms · "..fps.."fps"
                frames=0;t0=now
            end
            task.wait()
        end
    end)

    -- GUI toggle via steal bar (set up after steal bar is created at end of buildGui)

    -- ===== TAB BAR (horizontal, scrollable) =====
    local TAB_BAR_H = 28
    local tabBarY = headerH + 1
    local tabContainer=Instance.new("Frame",mainFrame)
    tabContainer.Size=UDim2.new(1,0,0,TAB_BAR_H);tabContainer.Position=UDim2.new(0,0,0,tabBarY)
    tabContainer.BackgroundColor3=BG2;tabContainer.BorderSizePixel=0;tabContainer.ZIndex=6
    tabContainer.ClipsDescendants=true

    local tabScroller=Instance.new("ScrollingFrame",tabContainer)
    tabScroller.Size=UDim2.new(1,0,1,0);tabScroller.BackgroundTransparency=1;tabScroller.BorderSizePixel=0
    tabScroller.ScrollBarThickness=2;tabScroller.ScrollBarImageColor3=PINK3
    tabScroller.ScrollingDirection=Enum.ScrollingDirection.X
    tabScroller.CanvasSize=UDim2.new(0,0,0,0)
    local tabsInner=Instance.new("Frame",tabScroller)
    tabsInner.Size=UDim2.new(0,0,1,0);tabsInner.BackgroundTransparency=1
    local tabLayout=Instance.new("UIListLayout",tabsInner)
    tabLayout.FillDirection=Enum.FillDirection.Horizontal
    tabLayout.SortOrder=Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
    tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center
    tabLayout.Padding=UDim.new(0,2)

    -- Divider below tab bar
    local tabDivider=Instance.new("Frame",mainFrame)
    tabDivider.Size=UDim2.new(1,0,0,1);tabDivider.Position=UDim2.new(0,0,0,tabBarY+TAB_BAR_H)
    tabDivider.BackgroundColor3=ROW_BORDER;tabDivider.BackgroundTransparency=0.3;tabDivider.BorderSizePixel=0;tabDivider.ZIndex=7

    local TABS={"Speed","Combat","Steal","Visual","Keybinds","Settings"}
    local tabPages={};local tabBtnRefs={};local activeTab=nil

    -- Content area below tab bar
    local bodyY=tabBarY+TAB_BAR_H+2
    local bodyH=H-bodyY

    for _,name in ipairs(TABS) do
        local sf=Instance.new("ScrollingFrame",mainFrame)
        sf.Size=UDim2.new(1,0,0,bodyH);sf.Position=UDim2.new(0,0,0,bodyY)
        sf.BackgroundTransparency=1;sf.BorderSizePixel=0
        sf.ScrollBarThickness=2;sf.ScrollBarImageColor3=PINK3
        sf.CanvasSize=UDim2.new(0,0,0,0);sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
        sf.ScrollingDirection=Enum.ScrollingDirection.Y;sf.Visible=false;sf.ZIndex=3
        local ll=Instance.new("UIListLayout",sf);ll.SortOrder=Enum.SortOrder.LayoutOrder
        -- ADDED SPACING: 6px between rows
        ll.Padding=UDim.new(0,6)
        local pd=Instance.new("UIPadding",sf);pd.PaddingLeft=UDim.new(0,10);pd.PaddingRight=UDim.new(0,10);pd.PaddingTop=UDim.new(0,8);pd.PaddingBottom=UDim.new(0,8)
        tabPages[name]=sf
    end

    -- Steal bar click = toggle GUI
    if stealBarFrame then
        local _togDrag=false;local _togDragStart=nil
        stealBarFrame.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                _togDrag=false;_togDragStart=input.Position
            end
        end)
        stealBarFrame.InputChanged:Connect(function(input)
            if _togDragStart and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                if (input.Position-_togDragStart).Magnitude > 6 then _togDrag=true end
            end
        end)
        stealBarFrame.InputEnded:Connect(function(input)
            if (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) and not _togDrag then
                mainFrame.Visible=not mainFrame.Visible
            end
        end)
    end

    local function switchTab(name)
        if activeTab==name then return end
        if activeTab then tabPages[activeTab].Visible=false end
        for _,t in ipairs(TABS) do
            local bd=tabBtnRefs[t]
            if bd then
                local isActive=(t==name)
                bd.lbl.TextColor3=isActive and TAB_ACTIVE or TAB_INACT
                bd.lbl.Font=isActive and Enum.Font.GothamBlack or Enum.Font.GothamBold
                bd.underline.Visible=isActive
            end
        end
        activeTab=name;tabPages[name].Visible=true
    end

    local tabW = math.floor(W/#TABS)  -- base width, but we'll auto-size
    for _,name in ipairs(TABS) do
        local tabItem=Instance.new("Frame",tabsInner)
        tabItem.Size=UDim2.new(0,60,1,0)  -- fixed width for each tab
        tabItem.BackgroundTransparency=1;tabItem.ZIndex=7

        local lbl=Instance.new("TextButton",tabItem)
        lbl.Size=UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency=1;lbl.Text=name
        lbl.TextColor3=TAB_INACT;lbl.Font=Enum.Font.GothamBold
        lbl.TextSize=9;lbl.AutoButtonColor=false;lbl.ZIndex=8

        -- Pink underline (shown when active)
        local underline=Instance.new("Frame",tabItem)
        underline.Size=UDim2.new(0.7,0,0,2)
        underline.Position=UDim2.new(0.15,0,1,-2)
        underline.BackgroundColor3=PINK;underline.BorderSizePixel=0
        underline.Visible=false;underline.ZIndex=9

        tabBtnRefs[name]={lbl=lbl,underline=underline}
        local capName=name
        lbl.Activated:Connect(function() switchTab(capName) end)
    end

    -- update canvas size after layout
    task.spawn(function()
        task.wait()
        local totalW=0
        for _,child in ipairs(tabsInner:GetChildren()) do
            if child:IsA("Frame") then totalW=totalW+child.Size.X.Offset+2 end
        end
        tabScroller.CanvasSize=UDim2.new(0,totalW+8,0,0)
    end)

    -- ===== ROW HELPERS — Blossom Hub style =====
    -- Each row: full-width bordered box, label left, control right

    local function mkSectionLbl(parent, txt)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,3);spacer.BackgroundTransparency=1;spacer.LayoutOrder=#parent:GetChildren()

        local row=Instance.new("Frame",parent)
        row.Size=UDim2.new(1,0,0,14);row.BackgroundTransparency=1;row.LayoutOrder=#parent:GetChildren()
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(1,0,1,0);l.BackgroundTransparency=1
        l.Text=txt:upper();l.TextColor3=SECT_LBL
        l.Font=Enum.Font.GothamBold;l.TextSize=9
        l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9

        local div=Instance.new("Frame",parent)
        div.Size=UDim2.new(1,0,0,1);div.BackgroundColor3=ROW_BORDER
        div.BackgroundTransparency=0.4;div.BorderSizePixel=0;div.LayoutOrder=#parent:GetChildren()
        local sp2=Instance.new("Frame",parent)
        sp2.Size=UDim2.new(1,0,0,2);sp2.BackgroundTransparency=1;sp2.LayoutOrder=#parent:GetChildren()
    end

    local function mkRow(parent, h)
        local f=Instance.new("Frame",parent)
        f.Size=UDim2.new(1,0,0,h or 30)
        f.BackgroundColor3=ROW_BG;f.BorderSizePixel=0;f.ZIndex=8
        f.LayoutOrder=#parent:GetChildren()
        local stroke=Instance.new("UIStroke",f)
        stroke.Color=ROW_BORDER;stroke.Thickness=1;stroke.Transparency=0.2
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,1);spacer.BackgroundTransparency=1
        spacer.LayoutOrder=#parent:GetChildren()+1
        return f
    end

    local function mkLabel(row, txt)
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(0.6,0,1,0);l.Position=UDim2.new(0,10,0,0)
        l.BackgroundTransparency=1;l.Text=txt
        l.TextColor3=WHITE;l.Font=Enum.Font.GothamBold
        l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9
        return l
    end

    local function mkPill(row)
        local pill=Instance.new("Frame",row)
        pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill)
        dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(0,3,0.5,-5)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        return pill,dot
    end

    local function animPill(pill, dot, on)
        TweenService:Create(pill,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),
            BackgroundColor3=on and WHITE or GRAY
        }):Play()
    end

    local function mkToggle(parent, txt, cb)
        local row=mkRow(parent,30);mkLabel(row,txt)
        local pill,dot=mkPill(row);local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function() on=not on;sv(on);cb(on) end)
        return sv
    end

    -- Value box (dark rounded box on right side, Blossom Hub style)
    local function mkBoxRow(parent, txt, default, cb)
        local row=mkRow(parent,30);mkLabel(row,txt)
        local tb=Instance.new("TextBox",row)
        tb.Size=UDim2.new(0,54,0,18);tb.Position=UDim2.new(1,-62,0.5,-9)
        tb.BackgroundColor3=INP;tb.BorderSizePixel=0
        tb.Text=tostring(default);tb.TextColor3=PINK
        tb.Font=Enum.Font.GothamBold;tb.TextSize=11
        tb.ClearTextOnFocus=false;tb.ZIndex=9
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5)
        tb.FocusLost:Connect(function()
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
        end)
        return tb
    end

    -- Keybind display button (pink text label, right side)
    local GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true}
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
    local function isBindableInput(inp)
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
    end
    local function kbMatch(entry,kc) return kc and (kc==entry.kb or (entry.gp and kc==entry.gp)) end

    local function mkKBButton(row, kbEntry, cb)
        local function getLabel()
            if kbEntry.kb then return kbEntry.kb.Name
            elseif kbEntry.gp then return kbEntry.gp.Name
            else return "..." end
        end
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,66,0,18);btn.Position=UDim2.new(1,-74,0.5,-9)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0
        btn.Text=getLabel();btn.TextColor3=PINK
        btn.Font=Enum.Font.GothamBold;btn.TextSize=10
        btn.AutoButtonColor=false;btn.ZIndex=9
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
        local li=false;local lc;local pv=btn.Text;local ls=0
        btn.Activated:Connect(function()
            if li then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=PINK;return end
            pv=btn.Text;li=true;_anyKeyListening=true;ls=tick();btn.Text="...";btn.TextColor3=WHITE
            lc=UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode==Enum.KeyCode.Escape then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=PINK;return end
                local isGp=isGamepadInput(inp);if isGp and not(tick()-ls>=0.15) then return end
                if not isBindableInput(inp) then return end
                btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end
                btn.TextColor3=PINK
                if isGp then kbEntry.gp=inp.KeyCode;kbEntry.kb=nil else kbEntry.kb=inp.KeyCode;kbEntry.gp=nil end
                if cb then cb(inp.KeyCode,isGp) end
            end)
        end)
        return btn
    end

    -- Toggle row with a keybind button on the right (pill at far right, kb just left of it)
    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row=mkRow(parent,30);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        -- shift pill left of KB button — place pill at right edge, kb just inside
        -- Actually for this layout: label left, [kb btn] [pill] right
        pill:Destroy() -- rebuild properly below
        -- Rebuilt: kb at right-78 to right-8, pill at right-44 to right-10 → let's offset
        local pill2=Instance.new("Frame",row);pill2.Size=UDim2.new(0,34,0,18);pill2.Position=UDim2.new(1,-44,0.5,-9)
        pill2.BackgroundColor3=OFF;pill2.BorderSizePixel=0;pill2.ZIndex=9
        Instance.new("UICorner",pill2).CornerRadius=UDim.new(1,0)
        local dot2=Instance.new("Frame",pill2);dot2.Size=UDim2.new(0,12,0,12);dot2.Position=UDim2.new(0,3,0.5,-6)
        dot2.BackgroundColor3=GRAY;dot2.BorderSizePixel=0;dot2.ZIndex=10
        Instance.new("UICorner",dot2).CornerRadius=UDim.new(1,0)
        -- reposition kb button to fit next to pill
        local kbb=row:FindFirstChildOfClass("TextButton")
        if kbb then kbb.Position=UDim2.new(1,-122,0.5,-11);kbb.Size=UDim2.new(0,70,0,22) end
        local on=false
        local function sv(s) on=s;animPill(pill2,dot2,s) end
        local clk=Instance.new("TextButton",pill2);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);if onToggle then onToggle(on) end end)
        return sv
    end

    local function mkKBRow(parent, txt, kbEntry, onKB)
        local row=mkRow(parent,30);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        return row
    end

    local function mkActionRow(parent, txt, onActivate)
        local row=mkRow(parent,30);mkLabel(row,txt)
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,50,0,18);btn.Position=UDim2.new(1,-58,0.5,-9)
        btn.BackgroundColor3=PINK3;btn.BorderSizePixel=0
        btn.Text="▶";btn.TextColor3=WHITE;btn.Font=Enum.Font.GothamBlack;btn.TextSize=11
        btn.AutoButtonColor=false;btn.ZIndex=9
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
        btn.Activated:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(200,60,120)}):Play()
            task.delay(0.12,function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=PINK3}):Play() end)
            if onActivate then onActivate() end
        end)
        return row,btn
    end

    -- ===== SPEED TAB =====
    local pg=tabPages["Speed"]
    mkSectionLbl(pg,"SPEED CONFIGURATION")
    normalBox=mkBoxRow(pg,"Normal Speed",NS,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end)
    carryBox=mkBoxRow(pg,"Carry Speed",CS,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end)
    mkSectionLbl(pg,"CONTROLS")
    do
        local row=mkRow(pg,30);mkLabel(row,"Carry Mode")
        local pill,dot=Instance.new("Frame",row),Instance.new("Frame")
        pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        dot.Parent=pill;dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(0,3,0.5,-5)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        carryModePillRef={pill=pill,dot=dot};animPill(pill,dot,carrySpeedActive)
        -- mode label
        modeValLbl=Instance.new("TextLabel",row)
        modeValLbl.Size=UDim2.new(0,60,0,14);modeValLbl.Position=UDim2.new(0,10,0.5,-7)
        modeValLbl.BackgroundTransparency=1;modeValLbl.Text="Normal"
        modeValLbl.TextColor3=GRAY;modeValLbl.Font=Enum.Font.GothamBold
        modeValLbl.TextSize=9;modeValLbl.ZIndex=9
        -- update label x pos since we have the main label already
        modeValLbl.Position=UDim2.new(0.45,0,0.5,-7)
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function() toggleCarryMode();saveConfig() end)
    end

    -- ===== LAGGER MODE SECTION =====
    mkSectionLbl(pg,"LAGGER MODE")
    laggerBox=mkBoxRow(pg,"Lagger Speed",LAGGER_SPEED,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end)
    mkBoxRow(pg,"Lagger Carry Speed",LAGGER_CARRY_SPEED,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end)
    do
        local sv=mkToggle(pg,"Lagger Mode",function(on) toggleLaggerMode();saveConfig() end)
        laggerModePillRef=nil -- use mkToggle pill directly
        sv(laggerModeEnabled)
    end

    -- ===== COMBAT TAB =====
    pg=tabPages["Combat"]
    mkSectionLbl(pg,"RAGDOLL")
    setAntiRagVisual=mkToggle(pg,"Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end end)
    setBatCounterVisual=mkToggle(pg,"Bat Counter",function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    setMedusaVisual=mkToggle(pg,"Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setUnwalkVisual=mkToggle(pg,"Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end end)
    mkSectionLbl(pg,"BAT CONTROLS")
    do
        local sv=mkToggle(pg,"Auto Bat Aimbot",function(on)
            if on then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if aimbotV2Enabled then stopAimbotV2();if aimbotV2SetVisual then aimbotV2SetVisual(false) end;if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
                queueAutoBatStart();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            else stopBatAimbot();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            saveConfig()
        end)
        autoBatSetVisual=sv
    end
    setAutoSwingVisual=mkToggle(pg,"Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end)
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
    do
        local sv=mkToggle(pg,"Aimbot V2",function(on)
            if on then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                startAimbotV2();if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(true) end
            else stopAimbotV2();if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
            saveConfig()
        end)
        aimbotV2SetVisual=sv
    end
    do
        local sv=mkToggle(pg,"Auto Left",function(on)
            if on then
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if aimbotV2Enabled then stopAimbotV2();if aimbotV2SetVisual then aimbotV2SetVisual(false) end;if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
                autoLeftEnabled=true;startAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else autoLeftEnabled=false;stopAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            saveConfig()
        end)
        autoLeftSetVisual=sv
    end
    do
        local sv=mkToggle(pg,"Auto Right",function(on)
            if on then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if aimbotV2Enabled then stopAimbotV2();if aimbotV2SetVisual then aimbotV2SetVisual(false) end;if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
                autoRightEnabled=true;startAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else autoRightEnabled=false;stopAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            saveConfig()
        end)
        autoRightSetVisual=sv
    end
    mkActionRow(pg,"Drop Brainrot",function() runDrop() end)
    mkActionRow(pg,"Insta Reset",function() cursedInstaReset() end)
    mkSectionLbl(pg,"MISC")
    do
        local row=mkRow(pg,30);mkLabel(row,"Anti Kick")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(0,3,0.5,-5)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end;antiKickSetVisual=sv
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function() on=not on;sv(on);antiKickEnabled=on;if on then enableAntiKick() else disableAntiKick() end;saveConfig() end)
    end
    setAutoTPVisual=mkToggle(pg,"Auto TP",function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
    autoTPHeightBox=mkBoxRow(pg,"TP Height",autoTPHeight,function(v) if v>=0 and v<=500 then autoTPHeight=v end;saveConfig() end)
    mkActionRow(pg,"TP Down",function() runTPFloor() end)
    setInfJumpVisual=mkToggle(pg,"Infinite Jump",function(on) infJumpEnabled=on;if infJumpEnabled then if infJumpMode=="hold" then startHoldInfJump() end else stopHoldInfJump() end;saveConfig() end)
    do
        local row=mkRow(pg,30);mkLabel(row,"Jump Mode")
        local manualBtn=Instance.new("TextButton",row)
        manualBtn.Size=UDim2.new(0,50,0,22);manualBtn.Position=UDim2.new(1,-110,0.5,-11)
        manualBtn.BackgroundColor3=(infJumpMode=="manual") and PINK2 or Color3.fromRGB(50,30,40)
        manualBtn.BorderSizePixel=0;manualBtn.Text="Manual"
        manualBtn.TextColor3=WHITE;manualBtn.Font=Enum.Font.GothamBold;manualBtn.TextSize=9
        manualBtn.AutoButtonColor=false;manualBtn.ZIndex=12
        Instance.new("UICorner",manualBtn).CornerRadius=UDim.new(0,5)
        local holdBtn=Instance.new("TextButton",row)
        holdBtn.Size=UDim2.new(0,46,0,22);holdBtn.Position=UDim2.new(1,-57,0.5,-11)
        holdBtn.BackgroundColor3=(infJumpMode=="hold") and PINK2 or Color3.fromRGB(50,30,40)
        holdBtn.BorderSizePixel=0;holdBtn.Text="Hold"
        holdBtn.TextColor3=WHITE;holdBtn.Font=Enum.Font.GothamBold;holdBtn.TextSize=9
        holdBtn.AutoButtonColor=false;holdBtn.ZIndex=12
        Instance.new("UICorner",holdBtn).CornerRadius=UDim.new(0,5)
        manualBtn.Activated:Connect(function() infJumpMode="manual";manualBtn.BackgroundColor3=PINK2;holdBtn.BackgroundColor3=Color3.fromRGB(50,30,40);stopHoldInfJump();saveConfig() end)
        holdBtn.Activated:Connect(function() infJumpMode="hold";holdBtn.BackgroundColor3=PINK2;manualBtn.BackgroundColor3=Color3.fromRGB(50,30,40);if infJumpEnabled then startHoldInfJump() end;saveConfig() end)
    end

    -- ===== STEAL TAB =====
    pg=tabPages["Steal"]
    mkSectionLbl(pg,"AUTO STEAL")
    radInput=mkBoxRow(pg,"Steal Radius",Steal.StealRadius,function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v end;saveConfig() end)
    durationBox=mkBoxRow(pg,"Steal Duration",Steal.StealDuration,function(v) if v>=0.1 and v<=10 then Steal.StealDuration=v else durationBox.Text=tostring(Steal.StealDuration) end;saveConfig() end)
    do
        local row=mkRow(pg,30);mkLabel(row,"Auto Steal")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(0,3,0.5,-5)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end;setInstaGrab=sv
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(function()
            on=not on;sv(on);Steal.AutoStealEnabled=on
            if on then if not pcall(startAutoSteal) then Steal.AutoStealEnabled=false;sv(false) end else stopAutoSteal() end
            saveConfig()
        end)
    end

    -- ===== VISUAL TAB =====
    pg=tabPages["Visual"]
    mkSectionLbl(pg,"VISUALS")
    setAntiLagVisual=mkToggle(pg,"Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
    setStretchRezVisual=mkToggle(pg,"Stretch Rez",function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
    mkSectionLbl(pg,"SKY")
    do
        local row=mkRow(pg,30);mkLabel(row,"Sky Theme")
        local skyIndex=1
        for i,theme in ipairs(SkyOrder) do if theme==currentSkyTheme then skyIndex=i;break end end
        local skyVal=Instance.new("TextLabel",row)
        skyVal.Size=UDim2.new(0,70,0,22);skyVal.Position=UDim2.new(1,-120,0.5,-11)
        skyVal.BackgroundTransparency=1;skyVal.Text=currentSkyTheme
        skyVal.TextColor3=PINK;skyVal.Font=Enum.Font.GothamBold;skyVal.TextSize=9
        skyVal.TextXAlignment=Enum.TextXAlignment.Right;skyVal.ZIndex=9
        local cycleBtn=Instance.new("TextButton",row)
        cycleBtn.Size=UDim2.new(0,40,0,22);cycleBtn.Position=UDim2.new(1,-48,0.5,-11)
        cycleBtn.BackgroundColor3=PINK3;cycleBtn.BorderSizePixel=0
        cycleBtn.Text="Next";cycleBtn.TextColor3=WHITE
        cycleBtn.Font=Enum.Font.GothamBold;cycleBtn.TextSize=9
        cycleBtn.AutoButtonColor=false;cycleBtn.ZIndex=10
        Instance.new("UICorner",cycleBtn).CornerRadius=UDim.new(0,5)
        cycleBtn.Activated:Connect(function()
            if _anyKeyListening then return end
            skyIndex=skyIndex%#SkyOrder+1
            local newTheme=SkyOrder[skyIndex]
            skyVal.Text=newTheme;currentSkyTheme=newTheme
            CandyApplyCustomSky(newTheme);saveConfig()
        end)
    end
    mkSectionLbl(pg,"FOV")
    do
        local row=mkRow(pg,30);mkLabel(row,"FOV")
        local fovBtn=Instance.new("TextButton",row)
        fovBtn.Size=UDim2.new(0,58,0,22);fovBtn.Position=UDim2.new(1,-66,0.5,-11)
        fovBtn.BackgroundColor3=INP;fovBtn.BorderSizePixel=0
        fovBtn.Text=tostring(fovValue);fovBtn.TextColor3=PINK
        fovBtn.Font=Enum.Font.GothamBold;fovBtn.TextSize=11;fovBtn.ZIndex=11
        Instance.new("UICorner",fovBtn).CornerRadius=UDim.new(0,5)
        for idx,v in ipairs(fovOptions) do if v==fovValue then fovIndex=idx end end
        fovBtn.Activated:Connect(function()
            fovIndex=fovIndex%#fovOptions+1;fovValue=fovOptions[fovIndex]
            fovBtn.Text=tostring(fovValue);applyFOV();saveConfig()
        end)
    end

    -- ===== KEYBINDS TAB =====
    pg=tabPages["Keybinds"]
    mkSectionLbl(pg,"SPEED KEYBINDS")
    mkKBRow(pg,"Normal Speed",KB.NormalSpeed,function() saveConfig() end)
    mkKBRow(pg,"Carry Speed (Toggle)",KB.SpeedToggle,function() saveConfig() end)
    mkKBRow(pg,"Lagger Mode (Toggle)",KB.LaggerToggle,function() saveConfig() end)
    mkKBRow(pg,"Lagger Carry (Toggle)",KB.LaggerCarryToggle,function() saveConfig() end)
    mkSectionLbl(pg,"ACTION KEYBINDS")
    mkKBRow(pg,"Drop Brainrot",KB.DropBrainrot,function() saveConfig() end)
    mkKBRow(pg,"TP Floor",KB.TPFloor,function() saveConfig() end)
    mkKBRow(pg,"Insta Reset",KB.InstaReset,function() saveConfig() end)
    mkSectionLbl(pg,"COMBAT KEYBINDS")
    mkKBRow(pg,"Auto Left",KB.AutoLeft,function() saveConfig() end)
    mkKBRow(pg,"Auto Right",KB.AutoRight,function() saveConfig() end)
    mkKBRow(pg,"Auto Bat Aimbot",KB.AutoBat,function() saveConfig() end)
    mkKBRow(pg,"Aimbot V2",KB.AimbotV2,function() saveConfig() end)
    mkSectionLbl(pg,"MISC KEYBINDS")
    mkKBRow(pg,"Hide GUI",KB.GuiHide,function() saveConfig() end)
    mkKBRow(pg,"Anti-Desync Panel",KB.AntiDesync,function() saveConfig() end)

    -- ===== SETTINGS TAB =====
    pg=tabPages["Settings"]
    mkSectionLbl(pg,"GUI")
    setLockVisual=mkToggle(pg,"Lock UI",function(on) uiLocked=on;saveConfig() end)
    setMobVisual=mkToggle(pg,"Mobile Buttons",function(on) mobileButtonsEnabled=on;if on then buildMobileButtons() else destroyMobileButtons() end;saveConfig() end)
    if mobileButtonsEnabled then setMobVisual(true) end
    mkSectionLbl(pg,"MOBILE BUTTONS")
    do
        local row=mkRow(pg,30);mkLabel(row,"Btn Size")
        local sizeBox=Instance.new("TextBox",row)
        sizeBox.Size=UDim2.new(0,58,0,22);sizeBox.Position=UDim2.new(1,-66,0.5,-11)
        sizeBox.BackgroundColor3=INP;sizeBox.BorderSizePixel=0
        sizeBox.Text=tostring(mobileButtonsSize);sizeBox.TextColor3=PINK
        sizeBox.Font=Enum.Font.GothamBold;sizeBox.TextSize=10;sizeBox.ClearTextOnFocus=false;sizeBox.ZIndex=9
        Instance.new("UICorner",sizeBox).CornerRadius=UDim.new(0,5)
        sizeBox.FocusLost:Connect(function()
            local n=tonumber(sizeBox.Text)
            if n and n>=40 and n<=150 then mobileButtonsSize=n;if mobileButtonsEnabled then buildMobileButtons() end;saveConfig()
            else sizeBox.Text=tostring(mobileButtonsSize) end
        end)
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Reset Btn Pos")
        local resetPosBtn=Instance.new("TextButton",row)
        resetPosBtn.Size=UDim2.new(0,58,0,22);resetPosBtn.Position=UDim2.new(1,-66,0.5,-11)
        resetPosBtn.BackgroundColor3=PINK3;resetPosBtn.BorderSizePixel=0
        resetPosBtn.Text="Reset";resetPosBtn.TextColor3=WHITE
        resetPosBtn.Font=Enum.Font.GothamBold;resetPosBtn.TextSize=9;resetPosBtn.ZIndex=9
        Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,5)
        resetPosBtn.Activated:Connect(function()
            pcall(function() if writefile then writefile(MOB_POS_FILE,"{}") end end)
            if mobileButtonsEnabled then buildMobileButtons() end
        end)
    end
    mkSectionLbl(pg,"RESET")
    do
        local row=mkRow(pg,30);mkLabel(row,"Reset Settings")
        local resetBtn=Instance.new("TextButton",row)
        resetBtn.Size=UDim2.new(0,54,0,20);resetBtn.Position=UDim2.new(1,-62,0.5,-10)
        resetBtn.BackgroundColor3=Color3.fromRGB(140,25,65);resetBtn.BorderSizePixel=0
        resetBtn.Text="RESET";resetBtn.TextColor3=WHITE
        resetBtn.Font=Enum.Font.GothamBold;resetBtn.TextSize=9;resetBtn.ZIndex=9
        Instance.new("UICorner",resetBtn).CornerRadius=UDim.new(0,5)
        resetBtn.Activated:Connect(function() resetAllSettings() end)
    end

    switchTab("Speed")

    -- ===== GLOBAL KEYBIND HANDLER =====
    trackConn(UIS.InputBegan:Connect(function(input,gpe)
        if _anyKeyListening then return end
        if input.UserInputType==Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end
        if not isBindableInput(input) then return end
        local kc=input.KeyCode
        if kbMatch(KB.LaggerToggle,kc) then toggleLaggerMode();saveConfig()
        elseif kbMatch(KB.LaggerCarryToggle,kc) then toggleLaggerCarryMode();saveConfig()
        elseif kbMatch(KB.NormalSpeed,kc) then
            carrySpeedActive=false;laggerModeEnabled=false;laggerCarryActive=false
            refreshSpeedModeLabel()
            if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
            if mobBtnRefs.lagger then mobBtnRefs.lagger(false) end
            if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end
            saveConfig()
        elseif kbMatch(KB.SpeedToggle,kc) then toggleCarryMode();saveConfig()
        elseif kbMatch(KB.DropBrainrot,kc) then runDrop()
        elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
        elseif kbMatch(KB.InstaReset,kc) then cursedInstaReset()
        elseif kbMatch(KB.AutoLeft,kc) then
            autoLeftEnabled=not autoLeftEnabled
            if autoLeftEnabled then
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                startAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(true) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        elseif kbMatch(KB.AutoRight,kc) then
            autoRightEnabled=not autoRightEnabled
            if autoRightEnabled then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                startAutoRight();if autoRightSetVisual then autoRightSetVisual(true) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        elseif kbMatch(KB.AutoBat,kc) then
            if not autoBatEnabled then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                queueAutoBatStart();if autoBatSetVisual then autoBatSetVisual(true) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            else stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        elseif kbMatch(KB.AimbotV2,kc) then
            if not aimbotV2Enabled then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                startAimbotV2();if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(true) end
            else stopAimbotV2();if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(false) end end
        elseif kbMatch(KB.GuiHide,kc) then
            if mainFrame.Visible then mainFrame.Visible=false;miniBtn.Visible=true
            else mainFrame.Visible=true;miniBtn.Visible=false end
        elseif kbMatch(KB.AntiDesync,kc) then
            local adGui=_G._SilenceAntiDesyncGui
            if adGui and adGui.Parent then
                local m=adGui:FindFirstChild("Main")
                if m then m.Visible=not m.Visible end
            end
        end
    end))
end

local _savedCfg=nil
local function loadConfigKeys()
    if not(isfile and isfile("grinchvs.json")) then return end
    local ok,cfg=pcall(function() return HS:JSONDecode(readfile("grinchvs.json")) end)
    if not ok or not cfg then return end;_savedCfg=cfg
    local function lk(e,d)
        if type(d)~="table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] else e.kb=nil end
        if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] else e.gp=nil end
    end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.AimbotV2,cfg.aimbotV2Key);lk(KB.LaggerToggle,cfg.laggerToggleKey)
    lk(KB.LaggerCarryToggle,cfg.laggerCarryToggleKey);lk(KB.NormalSpeed,cfg.normalSpeedKey)
    lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey)
    lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey)
    lk(KB.AntiDesync,cfg.antiDesyncKey)
    if cfg.normalSpeed then NS=cfg.normalSpeed end;if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED=cfg.laggerSpeed end;if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.grabRadius then Steal.StealRadius=cfg.grabRadius end;if cfg.stealDuration then Steal.StealDuration=cfg.stealDuration end
    if cfg.autoTPHeight then autoTPHeight=cfg.autoTPHeight end
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
    if cfg.guiTransparencyEnabled~=nil then guiTransparencyEnabled=cfg.guiTransparencyEnabled end
    if cfg.mobileButtonsEnabled~=nil then mobileButtonsEnabled=cfg.mobileButtonsEnabled end
    if cfg.mobileButtonsSize~=nil then mobileButtonsSize=cfg.mobileButtonsSize end
    if cfg.circleButtonsEnabled~=nil then circleButtonsEnabled=cfg.circleButtonsEnabled==true end
    if cfg.antiKick~=nil then antiKickEnabled=cfg.antiKick==true end
    if cfg.carrySpeedActive~=nil then carrySpeedActive=cfg.carrySpeedActive end
    if cfg.laggerModeEnabled~=nil then laggerModeEnabled=cfg.laggerModeEnabled end
    if cfg.laggerCarryActive~=nil then laggerCarryActive=cfg.laggerCarryActive end
    if cfg.infJumpMode then infJumpMode=cfg.infJumpMode end
    if cfg.fovValue then fovValue=cfg.fovValue;for idx,v in ipairs(fovOptions) do if v==fovValue then fovIndex=idx end end end
    if cfg.chromeImageVisible~=nil then _G._GrinchDuels_bgImageVisible=cfg.chromeImageVisible==true end
    if cfg.perButtonDrag~=nil then perButtonDragEnabled=cfg.perButtonDrag==true end
    if cfg.autoMoveSwing~=nil then autoMoveSwingEnabled=cfg.autoMoveSwing==true end
    if cfg.autoMoveSwingInterval then autoMoveSwingInterval=cfg.autoMoveSwingInterval end
    if cfg.skyTheme then currentSkyTheme=cfg.skyTheme;CandyApplyCustomSky(currentSkyTheme) end
    if cfg.medusaReset~=nil then medusaResetEnabled=cfg.medusaReset==true end
    if cfg.ragdollGui~=nil then ragdollGuiEnabled=cfg.ragdollGui==true end
end
local function loadConfigState()
    local cfg=_savedCfg;if not cfg then return end
    if normalBox then normalBox.Text=tostring(NS) end;if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end;if durationBox then durationBox.Text=tostring(Steal.StealDuration) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end;if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    task.spawn(function()
        task.wait(0.15)
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
        if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end;if infJumpMode=="hold" then startHoldInfJump() end end
        if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end

        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        refreshSpeedModeLabel()
        if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        if cfg.autoBat then
            autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            queueAutoBatStart()
        end
        if cfg.aimbotV2 then
            aimbotV2Enabled=true;if aimbotV2SetVisual then aimbotV2SetVisual(true) end
            if mobBtnRefs.aimbotV2 then mobBtnRefs.aimbotV2(true) end
            startAimbotV2()
        end
        if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
        if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end
        if cfg.antiKick then enableAntiKick();if antiKickSetVisual then antiKickSetVisual(true) end end
        if circleButtonsEnabled and setCircleBtnsVisual then setCircleBtnsVisual(true) end
        if cfg.skyTheme then CandyApplyCustomSky(cfg.skyTheme) end
    end)
end

loadConfigKeys()
buildGui()
if mobileButtonsEnabled then buildMobileButtons() end
loadConfigState()
CandyApplyCustomSky(currentSkyTheme)

-- Optional mini loader (removed the k7 mini loadstring per request, but kept the call empty)
task.spawn(function()
    -- removed external load
end)