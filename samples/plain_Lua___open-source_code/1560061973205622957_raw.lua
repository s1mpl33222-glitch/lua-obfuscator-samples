-- Vaper.vs (FIXED BY MANUS)
-- FIXED: Speed Carry limited to 28 to avoid BAC-8635 kick.
-- MODIFIED: TP Bat logic replaced with Vision TP Bat (sethiddenproperty PhysRep, camera lock, 8-stud range hit with 0.08s cooldown).

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local LP = Players.LocalPlayer
local player = LP

-- PERSISTENT CONFIG MODE
-- Keep the existing Vaper.vs settings between executions.
-- Positions, sizes, visibility and feature settings are loaded normally.
local HEARTLESS_FRESH_START = false
if HEARTLESS_FRESH_START then
    for _,fileName in ipairs({"Spectrum_PC.json", "Spectrum_BtnPos.json"}) do
        if delfile and isfile and isfile(fileName) then
            pcall(function() delfile(fileName) end)
        elseif writefile then
            -- Fallback: overwrite instead of deleting when delfile is unavailable.
            pcall(function() writefile(fileName, "{}") end)
        end
    end
end

-- EARLY CONFIG LOAD
-- Declare this before reading the saved config so Hide Buttons updates
-- the actual local state instead of creating a temporary global.
local mobileButtonsVisible = true
if isfile and isfile("Spectrum_PC.json") then
    local ok2, d2 = pcall(function() return HS:JSONDecode(readfile("Spectrum_PC.json")) end)
    if ok2 and type(d2)=="table" then
        if type(d2.animEnabled)=="boolean" then animEnabled=d2.animEnabled end
        if type(d2.mobileButtonsVisible)=="boolean" then mobileButtonsVisible=d2.mobileButtonsVisible end
    end
end

repeat task.wait() until game:IsLoaded()

local function playHeartlessIntro()
    local introPlayer = Players.LocalPlayer
    if not introPlayer then return end

    local ContentProvider = game:GetService("ContentProvider")
    local PlayerGui = introPlayer:WaitForChild("PlayerGui")
    local Images = {
        "rbxassetid://96533744445232", "rbxassetid://118993542874276",
        "rbxassetid://99866892158060", "rbxassetid://84540124030580",
        "rbxassetid://132934292097292", "rbxassetid://104010736352149",
        "rbxassetid://94361033271077", "rbxassetid://72190372137981",
        "rbxassetid://103523696318850", "rbxassetid://101803539971689",
        "rbxassetid://107529606059299", "rbxassetid://130784948902307",
        "rbxassetid://114784420279972", "rbxassetid://105123015099972",
        "rbxassetid://131596264264581", "rbxassetid://117641319299892",
        "rbxassetid://77534392596501", "rbxassetid://137414609886581",
        "rbxassetid://83131507934505", "rbxassetid://120539267437814",
        "rbxassetid://75439074806720", "rbxassetid://115488810796302",
        "rbxassetid://112728809681073", "rbxassetid://134318680085983",
        "rbxassetid://123066810237014", "rbxassetid://102121135737318",
        "rbxassetid://139699026047974", "rbxassetid://74182313853112",
        "rbxassetid://121416642632033", "rbxassetid://134801197105164",
        "rbxassetid://93349115381247", "rbxassetid://128713300077569",
        "rbxassetid://105980529035481", "rbxassetid://120098855834318",
        "rbxassetid://78738310303690", "rbxassetid://120357336501453",
        "rbxassetid://118779397888922", "rbxassetid://132769993677180",
        "rbxassetid://104815503921105", "rbxassetid://77088103549177",
        "rbxassetid://72670821879917", "rbxassetid://70849955940425",
        "rbxassetid://108744596090889", "rbxassetid://76080560700977",
        "rbxassetid://78134833803844", "rbxassetid://88784536566963",
        "rbxassetid://98157171075972", "rbxassetid://110334342917414",
        "rbxassetid://97359534131775", "rbxassetid://72958519562189",
        "rbxassetid://92480523122234", "rbxassetid://117453595633818"
    }

    pcall(function() ContentProvider:PreloadAsync(Images) end)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "vis intro"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 10000
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local layer1 = Instance.new("ImageLabel")
    layer1.Size = UDim2.fromScale(1, 1)
    layer1.BackgroundTransparency = 1
    layer1.ScaleType = Enum.ScaleType.Crop
    layer1.Image = Images[1]
    layer1.ZIndex = 2
    layer1.Parent = frame

    local layer2 = Instance.new("ImageLabel")
    layer2.Size = UDim2.fromScale(1, 1)
    layer2.BackgroundTransparency = 1
    layer2.ScaleType = Enum.ScaleType.Crop
    layer2.Image = Images[1]
    layer2.ZIndex = 1
    layer2.Parent = frame

    local continueText = Instance.new("TextButton")
    continueText.Name = "Continue"
    continueText.AnchorPoint = Vector2.new(0.5, 0.5)
    continueText.Position = UDim2.fromScale(0.5, 0.5)
    continueText.Size = UDim2.fromOffset(300, 60)
    continueText.BackgroundTransparency = 1
    continueText.Text = "TAP TO CONTINUE"
    continueText.TextColor3 = Color3.new(1, 1, 1)
    continueText.TextSize = 28
    continueText.Font = Enum.Font.GothamBlack
    continueText.TextTransparency = 0.35
    continueText.TextStrokeColor3 = Color3.new(0, 0, 0)
    continueText.TextStrokeTransparency = 0.5
    continueText.ZIndex = 100
    continueText.AutoButtonColor = false
    continueText.Parent = screenGui

    local skipped = false
    local sound

    continueText.Activated:Connect(function()
        skipped = true
    end)

    -- El audio original usa funciones de executor (isfile/writefile/getcustomasset).
    -- Si el executor no las soporta, la intro sigue funcionando sin audio en vez de detener todo el script.
    pcall(function()
        if type(isfile) == "function" and type(writefile) == "function" and type(getcustomasset) == "function" then
            local url = "https://files.catbox.moe/iyw1cb.mp3"
            local fileName = "AceDuelsIntroSong_7.mp3"
            if not isfile(fileName) then
                local data = game:HttpGet(url)
                writefile(fileName, data)
            end
            sound = Instance.new("Sound")
            sound.SoundId = getcustomasset(fileName)
            sound.Volume = 1
            sound.Parent = game:GetService("SoundService")
            sound:Play()
        end
    end)

    local index = 1
    local startTime = os.clock()
    local frameDelay = 1 / 30
    while not skipped and os.clock() - startTime < 9 do
        local nextIndex = (index % #Images) + 1
        local behind, front
        if layer1.ZIndex == 1 then
            behind, front = layer1, layer2
        else
            behind, front = layer2, layer1
        end
        behind.Image = Images[nextIndex]
        behind.ZIndex = 2
        front.ZIndex = 1
        index = nextIndex
        task.wait(frameDelay)
    end

    if sound then pcall(function() sound:Stop(); sound:Destroy() end) end
    pcall(function() screenGui:Destroy() end)
end

playHeartlessIntro()

-- STATE
-- ============================================================
local TS=TweenService
LP=Players.LocalPlayer
-- Forward declarations used by skin and UI callbacks.
local refreshSpeedModeLabel,saveConfig
local NS,CS=60,30
local speedCarryActive=false
local modeCarry={Normal=false,Lagger=false,Custom=false}
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local LAGGER_SPEED=15
local LAGGER_CARRY_SPEED=24.0
local laggerModeEnabled = false
-- ROTX movement logic: Velocity/ApplyImpulse is the default so gravity remains active.
-- Supported values: "Velocity", "AssemblyLinearVelocity", "WalkSpeed", "Humanoid Move", "LinearVelocity", "ApplyImpulse", "CFrame".
local speedMethod = "Velocity"
local speedObjects = {linearVelocity=nil, attachment=nil, lastMethod=nil}
local function ensureSpeedAttachment(hrp)
    local att=speedObjects.attachment
    if not att or att.Parent~=hrp then
        if att then pcall(function() att:Destroy() end) end
        att=Instance.new("Attachment");att.Name="HeartlessMoveeLinVelAtt";att.Parent=hrp
        speedObjects.attachment=att
    end
    return att
end
local function destroySpeedObjects()
    for key,obj in pairs(speedObjects) do
        if key~="lastMethod" and obj and typeof(obj)=="Instance" then pcall(function() obj:Destroy() end);speedObjects[key]=nil end
    end
end
local function applyHeartlessSpeedMethod(hrp,humanoid,direction,currentSpeed,dt)
    if not hrp or not humanoid then return end
    local method=speedMethod
    if speedObjects.lastMethod~=method then
        destroySpeedObjects()
        if method~="WalkSpeed" and humanoid.WalkSpeed~=16 then humanoid.WalkSpeed=16 end
        speedObjects.lastMethod=method
    end
    local flat=Vector3.new(direction.X,0,direction.Z)
    flat=flat.Magnitude>0 and flat.Unit or Vector3.zero
    local function massImpulse()
        local mass=hrp.AssemblyMass or 1
        local current=hrp.AssemblyLinearVelocity
        local desired=Vector3.new(flat.X*currentSpeed,current.Y,flat.Z*currentSpeed)
        local delta=desired-current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X,0,delta.Z)*mass) end)
    end
    if method=="Velocity" or method=="AssemblyLinearVelocity" or method=="ApplyImpulse" then
        -- Change only horizontal velocity; never force Y, so jumping and falling remain natural.
        massImpulse()
    elseif method=="WalkSpeed" then
        humanoid.WalkSpeed=currentSpeed
    elseif method=="Humanoid Move" then
        humanoid.WalkSpeed=currentSpeed;humanoid:Move(flat,false)
    elseif method=="LinearVelocity" then
        if not speedObjects.linearVelocity or speedObjects.linearVelocity.Parent~=hrp then
            if speedObjects.linearVelocity then pcall(function() speedObjects.linearVelocity:Destroy() end) end
            local lv=Instance.new("LinearVelocity");lv.Name="HeartlessMoveeLinearVelocity";lv.Attachment0=ensureSpeedAttachment(hrp)
            lv.MaxForce=1e8;lv.RelativeTo=Enum.ActuatorRelativeTo.World;lv.Parent=hrp;speedObjects.linearVelocity=lv
        end
        -- Preserve the current vertical actuator component instead of injecting an upward force.
        local currentY=hrp.AssemblyLinearVelocity.Y
        speedObjects.linearVelocity.VectorVelocity=Vector3.new(flat.X*currentSpeed,currentY,flat.Z*currentSpeed)
    elseif method=="CFrame" then
        hrp.CFrame=hrp.CFrame+(flat*currentSpeed*(dt or 1/60))
    end
end
local function setHeartlessSpeedMethod(method)
    local allowed={Velocity=true,AssemblyLinearVelocity=true,WalkSpeed=true,["Humanoid Move"]=true,LinearVelocity=true,ApplyImpulse=true,CFrame=true}
    if allowed[method] then speedMethod=method;speedObjects.lastMethod=nil;destroySpeedObjects() end
end

-- End ROTX movement primitives.

local antiRagdollEnabled,infJumpEnabled=false,false
local antiRagdollMode = "Splatter"
local antiRagdollNoSplatterCooldown = 0
local medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
local medusaDebounce,medusaLastUsed,dropActive=false,0,false
local autoLeftEnabled,autoRightEnabled=false,false
local autoLeftSetVisual,autoRightSetVisual=nil,nil
local speedLabel=nil
local speedModeLabel=nil
local autoBatEnabled=false
local autoSwingEnabled=true
local autoMoveSwingEnabled=false
local autoMoveSwingInterval=0.3
local _alSwingDebounce=false
local _arSwingDebounce=false
local autoBatSetVisual=nil
local tpBat1Enabled=false
local tpBat2Enabled=false
local tpBatMode="Original"
local TP_BAT_STUDS=6 -- equilibrio recomendado entre precisión y movimiento
local TP_BAT_SWING_INTERVAL=0.12
local activeProfile="Balanced"
local savedProfiles={}
local tpBat1SetVisual=nil
local tpBat2SetVisual=nil
local resetAutoBatMotion=nil
local AUTO_BAT_SPEED,AUTO_BAT_VERT_SPEED,AUTO_BAT_DIST,AUTO_BAT_HEIGHT,AUTO_BAT_V_OFF,AUTO_BAT_TURN_SPEED,AUTO_BAT_MAX_TURN_RATE = 60,58,-2.6,4.6,1,320,32
local AUTO_BAT_SWING_INTERVAL = 0.2 -- cooldown between swings to avoid overlapping the bat animation
local _autoBatTarget = nil
local _autoBatLastScan = 0
local _autoBatLastSwing = 0
local _autoBatEquippedThisRun = false
local setBatCounterVisual=nil
local startBatCounter,stopBatCounter
local antiLagEnabled=false
local saturatedColorsEnabled=false
local antiLagConn=nil
local stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
local unwalkSavedAnimate,_anyKeyListening=nil,false
local cursedResetRemote=nil
local CURSED_RESET_GUID="f888ee6e-c86d-46e1-93d7-0639d6635d42"
local guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
mobileButtonsVisible = mobileButtonsVisible ~= false
local mobileButtonsSize=80
local circleButtonsEnabled=false
local stealBarFrame
local mobBtnRefs={}
local mobGuiRef=nil
local mobileInputConns={}
local fovValue=80
local fovOptions={80,120,180}
local fovIndex=1
local laggerModePillRef=nil
local autoSwitchSpeedEnabled=false
local mobBtnTransparencyEnabled=false
local perButtonDragEnabled=false
local uiLocked=false
local infJumpMode="manual"
local holdInfJumpConn=nil
local DROP_ASCEND_DURATION=0.2
local DROP_ASCEND_SPEED=150
local dropMode="Jump"
local _GuiKeys = nil

-- VISUAL SETTINGS
local tabPosition = "Left"
local interfaceVersion = "V1"
local v1MenuWidth = 340
local v1MenuHeight = 495
local mobileButtonWidth = 49
local mobileButtonHeight = 49
local mobileButtonOutline = 2
local menuWidth = 265
local menuHeight = 350
local buttonStyle = "Cubes"
local mobileTextSize = 12.5
local themeName = "Black"
local themeIndex = 1
-- Color UI: Black only.
local THEME_ORDER = {"Black"}
local THEME_IMAGES = {Pink="127919774357239", Green="98501044780305", Black="rbxthumb://type=Asset&id=2937776598&w=420&h=420", Purple="82815528233653", Blue="72123515136858"}
local THEME_COLORS = {Blue=Color3.fromRGB(70,145,255), Green=Color3.fromRGB(65,210,115), Pink=Color3.fromRGB(255,105,190), Black=Color3.fromRGB(25,25,30), Purple=Color3.fromRGB(165,80,255)}
-- Colores pastel editables del panel de nombre. Cambia estos valores RGB cuando quieras.
local NAME_PANEL_PRIMARY = Color3.fromRGB(255,205,232)
local NAME_PANEL_ACCENT = Color3.fromRGB(205,190,255)
local NAME_PANEL_THEME_COLORS = {
    Blue = {primary=Color3.fromRGB(190,220,255), accent=Color3.fromRGB(210,195,255)},
    Green = {primary=Color3.fromRGB(190,255,220), accent=Color3.fromRGB(205,245,190)},
    Pink = {primary=Color3.fromRGB(255,205,232), accent=Color3.fromRGB(235,200,255)},
    Black = {primary=Color3.fromRGB(205,205,212), accent=Color3.fromRGB(125,125,140)},
    Purple = {primary=Color3.fromRGB(220,195,255), accent=Color3.fromRGB(185,125,255)},
}
local function getPastelThemeColor(name)
    local accent=THEME_COLORS[name] or THEME_COLORS.Blue
    return accent:Lerp(Color3.fromRGB(255,255,255),0.42)
end
local lineESPEnabled=false
local lineESPObjects={}
local lineESPConn=nil
local updateLineESP=nil

-- HEARTLESS SKIN: black body, invisible head, purple fire, visible legs and white star rosette.
local heartlessSkinEnabled = false -- Mantener el avatar original del jugador por defecto
local skinMode = "Skin1"
-- LegacySkin4: avatar violeta/azul con roseta energética violeta y manos claras,
-- inspirada en la referencia proporcionada.
-- Globals intentionally used here: the executor's Lua register limit is 200.
skin4BodyColor = Color3.fromRGB(48, 18, 105)
skin4HandColor = Color3.fromRGB(248, 248, 255)
skin4AccentColor = Color3.fromRGB(160, 65, 255)
skin4GlowColor = Color3.fromRGB(185, 75, 255)
skin1BodyColor = Color3.fromRGB(255, 221, 0)
skin4ValkAssetId = 101759037049993
skin4HornsAssetId = 72821116354344
skin1HeadAssetId = 114232040619461
skin1SuitAssetId = 104987421710322
sk5LoadState = {Head=false, Suit=false}
sk5Epoch = 0
local rightLegHiddenEnabled = false
-- Generation token used to invalidate delayed Skin 4 accessory loads when
-- the user changes skin or disables the Heartless skin.
local skin4AccessoryEpoch = 0
local skin4AccessoryLoading = {Valk = false, Horns = false}
local blackSmokeEnabled = false
local smokeColor = "Black"
local crownEnabled = true
local crownStyle = "White"
local hideHeadEnabled = false
local HEARTLESS = {
    original = {}, renderConn = nil, characterConn = nil, lastSkinChar = nil,
    skinColor = Color3.fromRGB(8, 8, 10),
    firePrimary = Color3.fromRGB(150, 45, 255), fireSecondary = Color3.fromRGB(230, 145, 255),
    crownColor = Color3.fromRGB(248, 248, 255), crownScale = 0.72,
    speedMode = "Normal", customSpeedNorm = 66, customSpeedSteal = 34,
    speedConn = nil,
    speedCards = {}, statusLabel = nil,
}

function heartlessRemember(obj, data)
    if obj and HEARTLESS.original[obj] == nil then HEARTLESS.original[obj] = data end
end

function restoreHeartlessSkin()
    for obj, data in pairs(HEARTLESS.original) do
        if obj and obj.Parent and type(data) == "table" then
            pcall(function()
                if data.kind == "part" and obj:IsA("BasePart") then
                    obj.Color = data.color
                    obj.Material = data.material
                    obj.Transparency = data.transparency
                    obj.LocalTransparencyModifier = data.localTransparency
                    obj.Reflectance = data.reflectance
                    if data.size then obj.Size = data.size end
                elseif data.kind == "bodycolors" and obj:IsA("BodyColors") then
                    obj.HeadColor3 = data.head
                    obj.LeftArmColor3 = data.leftArm
                    obj.RightArmColor3 = data.rightArm
                    obj.LeftLegColor3 = data.leftLeg
                    obj.RightLegColor3 = data.rightLeg
                    obj.TorsoColor3 = data.torso
                elseif data.kind == "shirt" and obj:IsA("Shirt") then
                    obj.ShirtTemplate = data.template
                elseif data.kind == "pants" and obj:IsA("Pants") then
                    obj.PantsTemplate = data.template
                elseif data.kind == "graphic" and obj:IsA("ShirtGraphic") then
                    obj.Graphic = data.graphic
                elseif data.kind == "texture" and (obj:IsA("Decal") or obj:IsA("Texture")) then
                    obj.Transparency = data.transparency
                end
            end)
        end
    end
    local char = LP.Character
    if char then
        for _, name in ipairs({"HeartlessSkinRosette", "HeartlessBlackSmoke", "HeartlessLegacySkin4Valk", "HeartlessLegacySkin4Horns", "HeartlessSkin1Head", "HeartlessSkin1Suit"}) do
            local effect = char:FindFirstChild(name, true)
            if effect then pcall(function() effect:Destroy() end) end
        end
    end
    HEARTLESS.original = {}
end

function applyHeartlessBody(char)
    if not char or not char.Parent then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            local lowerName = obj.Name:lower()
            local compactName = lowerName:gsub("[%s_%-]", "")
            local isRootPart = compactName == "humanoidrootpart" or compactName == "rootpart" or compactName == "root"
            local isBodyPart = compactName == "head"
                or compactName:find("torso", 1, true) ~= nil
                or compactName:find("arm", 1, true) ~= nil
                or compactName:find("leg", 1, true) ~= nil
                or compactName:find("foot", 1, true) ~= nil
                or compactName:find("hand", 1, true) ~= nil
            local isRightLeg = compactName == "rightleg" or compactName == "rightupperleg" or compactName == "rightlowerleg" or compactName == "rightfoot"
            local accessoryAncestor = obj:FindFirstAncestorOfClass("Accessory")
            local inAccessory = accessoryAncestor ~= nil
            local accessoryName = accessoryAncestor and accessoryAncestor.Name:lower() or ""
            local isLegacySkin4GeneratedAccessory = accessoryName == "heartlessskin4valk" or accessoryName == "heartlessskin4horns"
            local isSkin1GeneratedAccessory = accessoryName == "heartlessskin1head" or accessoryName == "heartlessskin1suit"
            local inRosette = obj:FindFirstAncestor("HeartlessSkinRosette") ~= nil
            heartlessRemember(obj, {
                kind = "part", color = obj.Color, material = obj.Material, size = obj.Size,
                transparency = obj.Transparency, localTransparency = obj.LocalTransparencyModifier,
                reflectance = obj.Reflectance,
            })
            if inAccessory and skinMode ~= "LegacySkin4" and skinMode ~= "Skin1" then
                -- LegacySkin4 conserva los accesorios originales del avatar.
                obj.LocalTransparencyModifier = 1
                obj.Reflectance = 0
            elseif inAccessory and (skinMode == "LegacySkin4" or skinMode == "Skin1") then
                -- Los accesorios generados de Skin 4 deben permanecer visibles.
                if isSkin1GeneratedAccessory then
                    obj.LocalTransparencyModifier = 0
                    obj.Transparency = 0
                    obj.Reflectance = 0
                elseif skinMode == "Skin1" then
                    -- Skin 5 oculta accesorios originales para que solo se vea Homer Uchiha.
                    obj.LocalTransparencyModifier = 1
                    obj.Reflectance = 0
                elseif isLegacySkin4GeneratedAccessory then
                    obj.Color = accessoryName == "heartlessskin4horns" and Color3.fromRGB(0, 0, 0) or skin4AccentColor
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Transparency = 0
                    obj.LocalTransparencyModifier = 0
                    obj.Reflectance = 0
                elseif accessoryName:find("horn", 1, true) or accessoryName:find("antler", 1, true) then
                    obj.Color = Color3.fromRGB(0, 0, 0)
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Transparency = 0
                    obj.LocalTransparencyModifier = 0
                end
            elseif inRosette and (skinMode == "LegacySkin1" or skinMode == "LegacySkin3" or skinMode == "LegacySkin4") then
                obj.Color = skinMode == "LegacySkin4" and skin4AccentColor or HEARTLESS.crownColor
                obj.Material = Enum.Material.Neon
                obj.Transparency = 0.02
                obj.LocalTransparencyModifier = 0
            else
                obj.Reflectance = 0
                if not isRootPart then
                    obj.Color = skinMode == "LegacySkin2" and Color3.fromRGB(0,0,0) or (skinMode == "LegacySkin3" and Color3.fromRGB(255,255,255) or (skinMode == "LegacySkin4" and skin4BodyColor or (skinMode == "Skin1" and skin1BodyColor or HEARTLESS.skinColor)))
                    obj.Material = Enum.Material.SmoothPlastic
                end
                if isRootPart then
                    -- El root invisible evita que aparezca el cuadrado central.
                    obj.Transparency = 1
                    obj.LocalTransparencyModifier = 1
                elseif skinMode == "LegacySkin2" or skinMode == "LegacySkin3" or skinMode == "LegacySkin4" or skinMode == "Skin1" then
                    -- Skin 2/3/4: show the body; Skin 4 uses the violet reference color.
                    if isBodyPart then
                        local hideThisHead = compactName == "head" and hideHeadEnabled
                        local hideThisRightLeg = rightLegHiddenEnabled and isRightLeg
                        obj.Transparency = (hideThisHead or hideThisRightLeg) and 1 or 0
                        obj.LocalTransparencyModifier = (hideThisHead or hideThisRightLeg) and 1 or 0
                        -- La referencia conserva manos claras sobre el cuerpo violeta.
                        if skinMode == "LegacySkin4" and (compactName:find("hand", 1, true) or compactName:find("arm", 1, true)) then
                            obj.Color = compactName:find("hand", 1, true) and skin4HandColor or skin4BodyColor
                        end
                    else
                        obj.Transparency = 1
                        obj.LocalTransparencyModifier = 1
                    end
                elseif compactName == "head" then
                    obj.Transparency = (hideHeadEnabled or (rightLegHiddenEnabled and isRightLeg)) and 1 or 0
                    obj.LocalTransparencyModifier = (hideHeadEnabled or (rightLegHiddenEnabled and isRightLeg)) and 1 or 0
                elseif compactName:find("leg", 1, true) or compactName:find("foot", 1, true) then
                    obj.Transparency = 0
                    obj.LocalTransparencyModifier = 0
                    obj.Material = Enum.Material.SmoothPlastic
                end
                obj.Reflectance = 0
            end
        elseif obj:IsA("BodyColors") then
            heartlessRemember(obj, {
                kind = "bodycolors", head = obj.HeadColor3, leftArm = obj.LeftArmColor3,
                rightArm = obj.RightArmColor3, leftLeg = obj.LeftLegColor3,
                rightLeg = obj.RightLegColor3, torso = obj.TorsoColor3,
            })
            local bodyColor = skinMode == "LegacySkin2" and Color3.fromRGB(0,0,0) or (skinMode == "LegacySkin3" and Color3.fromRGB(255,255,255) or (skinMode == "LegacySkin4" and skin4BodyColor or (skinMode == "Skin1" and skin1BodyColor or HEARTLESS.skinColor)))
            obj.HeadColor3 = bodyColor
            obj.LeftArmColor3 = bodyColor
            obj.RightArmColor3 = bodyColor
            obj.LeftLegColor3 = bodyColor
            obj.RightLegColor3 = bodyColor
            obj.TorsoColor3 = bodyColor
        elseif obj:IsA("Shirt") and skinMode ~= "Skin1" then
            heartlessRemember(obj, {kind = "shirt", template = obj.ShirtTemplate})
            obj.ShirtTemplate = ""
        elseif obj:IsA("Pants") and skinMode ~= "Skin1" then
            heartlessRemember(obj, {kind = "pants", template = obj.PantsTemplate})
            obj.PantsTemplate = ""
        elseif obj:IsA("ShirtGraphic") and skinMode ~= "Skin1" then
            heartlessRemember(obj, {kind = "graphic", graphic = obj.Graphic})
            obj.Graphic = ""
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            heartlessRemember(obj, {kind = "texture", transparency = obj.Transparency})
            obj.Transparency = 1
        end
    end
end

function addHeartlessRosette(char)
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local old = char:FindFirstChild("HeartlessSkinRosette")
    if old then old:Destroy() end
    local rosette = Instance.new("Model")
    rosette.Name = "HeartlessSkinRosette"
    rosette.Parent = char
    function attachBeam(name, a, b, thickness)
        local midpoint = (a + b) * 0.5
        local length = (b - a).Magnitude
        local part = Instance.new("Part")
        part.Name = name
        part.Size = Vector3.new(thickness, thickness, length)
        part.Color = skinMode == "LegacySkin4" and skin4AccentColor or (crownStyle == "Black" and Color3.fromRGB(0,0,0) or HEARTLESS.crownColor)
        part.Material = Enum.Material.SmoothPlastic
        part.Transparency = 0.02
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.CastShadow = false
        local scaledPosition = midpoint * HEARTLESS.crownScale
        local scaledCFrame = CFrame.fromMatrix(scaledPosition, CFrame.lookAt(midpoint, b).XVector, CFrame.lookAt(midpoint, b).YVector, CFrame.lookAt(midpoint, b).ZVector)
        part.Size = part.Size * HEARTLESS.crownScale
        part.CFrame = head.CFrame * scaledCFrame
        part.Parent = rosette
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = head
        weld.Part1 = part
        weld.Parent = part
    end
    local orbitRadius = 1.24
    local centerY = 1.12
    local starCount = 12
    for starIndex = 1, starCount do
        local orbitAngle = ((starIndex - 1) / starCount) * math.pi * 2
        local center = Vector3.new(math.cos(orbitAngle) * orbitRadius, centerY, math.sin(orbitAngle) * orbitRadius)
        local radius = 0.23 + (starIndex % 3) * 0.015
        local points = {}
        for pointIndex = 1, 6 do
            local pointAngle = ((pointIndex - 1) / 6) * math.pi * 2
            local pointRadius = (pointIndex % 2 == 1) and radius or radius * 0.32
            points[pointIndex] = Vector3.new(center.X + math.cos(pointAngle) * pointRadius, center.Y + math.sin(pointAngle) * pointRadius, center.Z)
        end
        for pointIndex = 1, 6 do
            local nextIndex = (pointIndex % 6) + 1
            local crossIndex = ((pointIndex + 2) % 6) + 1
            attachBeam("HeartlessStar" .. starIndex .. "Edge" .. pointIndex, points[pointIndex], points[nextIndex], 0.04)
            attachBeam("HeartlessStar" .. starIndex .. "Cross" .. pointIndex, points[pointIndex], points[crossIndex], 0.024)
        end
    end
end

function repairHeartlessLegs(char)
    if not char or not char.Parent then return end
    local legNames={"Left Leg","Right Leg","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
    local legParts={}
    for _,name in ipairs(legNames) do
        local part=char:FindFirstChild(name,true)
        if part and part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Accessory") then
            legParts[part]=true
            local normalizedName=part.Name:lower():gsub("[%s_%-]", "")
            local isRightLegPart=normalizedName=="rightleg" or normalizedName=="rightupperleg" or normalizedName=="rightlowerleg" or normalizedName=="rightfoot"
            local hideThisPart=rightLegHiddenEnabled and isRightLegPart and (skinMode=="LegacySkin3" or skinMode=="LegacySkin4")
            part.Transparency=hideThisPart and 1 or 0
            part.LocalTransparencyModifier=hideThisPart and 1 or 0
            part.Anchored=false
            part.CanCollide=false
            part.Massless=false
            -- Restore the avatar's original proportions; never force a generic size onto R6/R15 parts.
            local saved=HEARTLESS.original[part]
            if saved and saved.kind=="part" and saved.size then part.Size=saved.size end
        end
    end
    -- Re-enable the hip, knee, ankle, and root joints so the legs stay connected to the body.
    for _,obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Motor6D") and (legParts[obj.Part0] or legParts[obj.Part1]) then
            obj.Enabled=true
        end
    end
end
function hideHeartlessLegacySkin4Hair(char)
    if not char or skinMode ~= "LegacySkin4" then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") then
            local accessoryName = child.Name:lower()
            local isHair = accessoryName:find("hair", 1, true) ~= nil
            pcall(function() isHair = isHair or child.AccessoryType == Enum.AccessoryType.Hair end)
            local handle = child:FindFirstChild("Handle")
            if handle and handle:FindFirstChild("HairAttachment") then isHair = true end
            if isHair and child.Name ~= "HeartlessLegacySkin4Horns" and child.Name ~= "HeartlessLegacySkin4Valk" then
                for _, obj in ipairs(child:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        heartlessRemember(obj, {kind="part", color=obj.Color, material=obj.Material, size=obj.Size, transparency=obj.Transparency, localTransparency=obj.LocalTransparencyModifier, reflectance=obj.Reflectance})
                        obj.LocalTransparencyModifier = 1
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        heartlessRemember(obj, {kind="texture", transparency=obj.Transparency})
                        obj.Transparency = 1
                    end
                end
            end
        end
    end
end

function mountHeartlessLegacySkin4Valk(accessory, target, offset, scale)
    if not accessory or not target then return end
    local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
    if not handle then return end
    handle.Anchored = false
    handle.CanCollide = false
    handle.CanTouch = false
    handle.CanQuery = false
    handle.Massless = true
    local oldWeld = handle:FindFirstChild("AccessoryWeld")
    if oldWeld then oldWeld:Destroy() end
    if scale and scale ~= 1 then
        for _, obj in ipairs(accessory:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Size = obj.Size * scale end
            if obj:IsA("SpecialMesh") then obj.Scale = obj.Scale * scale end
        end
    end
    handle.CFrame = target.CFrame * (offset or CFrame.new())
    local mount = Instance.new("WeldConstraint")
    mount.Name = "HeartlessLegacySkin4Mount"
    mount.Part0 = target
    mount.Part1 = handle
    mount.Parent = handle
end

function addHeartlessLegacySkin4Valk(char)
    if not char or skinMode ~= "LegacySkin4" then return end
    if char:FindFirstChild("HeartlessLegacySkin4Valk") or skin4AccessoryLoading.Valk then return end
    skin4AccessoryLoading.Valk = true
    local epoch = skin4AccessoryEpoch
    local ok, assets = pcall(function()
        return game:GetObjects("rbxassetid://" .. skin4ValkAssetId)
    end)
    if not ok or not assets or not assets[1] then skin4AccessoryLoading.Valk = false; return end
    local source = assets[1]
    local accessory = source:IsA("Accessory") and source or source:FindFirstChildWhichIsA("Accessory", true)
    if not accessory then
        pcall(function() source:Destroy() end)
        skin4AccessoryLoading.Valk = false
        return
    end
    if epoch ~= skin4AccessoryEpoch or skinMode ~= "LegacySkin4" or LP.Character ~= char or not char.Parent then
        pcall(function() source:Destroy() end)
        skin4AccessoryLoading.Valk = false
        return
    end
    accessory.Name = "HeartlessLegacySkin4Valk"
    local head = char:FindFirstChild("Head")
    accessory.Parent = char
    if head then
        -- Purple Ethereal Valk: montada arriba de la cabeza.
        mountHeartlessLegacySkin4Valk(accessory, head, CFrame.new(0, 0.45, 0))
    end
    if source ~= accessory then pcall(function() source:Destroy() end) end
    skin4AccessoryLoading.Valk = false
end

function addHeartlessLegacySkin4Horns(char)
    if not char or skinMode ~= "LegacySkin4" then return end
    if char:FindFirstChild("HeartlessLegacySkin4Horns") or skin4AccessoryLoading.Horns then return end
    skin4AccessoryLoading.Horns = true
    local epoch = skin4AccessoryEpoch
    local ok, assets = pcall(function()
        return game:GetObjects("rbxassetid://" .. skin4HornsAssetId)
    end)
    if not ok or not assets or not assets[1] then skin4AccessoryLoading.Horns = false; return end
    local source = assets[1]
    local accessory = source:IsA("Accessory") and source or source:FindFirstChildWhichIsA("Accessory", true)
    if not accessory then
        pcall(function() source:Destroy() end)
        skin4AccessoryLoading.Horns = false
        return
    end
    if epoch ~= skin4AccessoryEpoch or skinMode ~= "LegacySkin4" or LP.Character ~= char or not char.Parent then
        pcall(function() source:Destroy() end)
        skin4AccessoryLoading.Horns = false
        return
    end
    accessory.Name = "HeartlessLegacySkin4Horns"
    for _, obj in ipairs(accessory:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Color = Color3.fromRGB(0, 0, 0)
            obj.Material = Enum.Material.SmoothPlastic
            obj.Transparency = 0
            obj.LocalTransparencyModifier = 0
        end
    end
    local head = char:FindFirstChild("Head")
    accessory.Parent = char
    if head then
        -- Cuernos: fijados directamente a la cabeza para evitar que floten.
        mountHeartlessLegacySkin4Valk(accessory, head, CFrame.new(0, 0.65, 0))
    end
    if source ~= accessory then pcall(function() source:Destroy() end) end
    skin4AccessoryLoading.Horns = false
end

local function removeHeartlessSkin1Accessories(char)
    if not char then return end
    for _, name in ipairs({"HeartlessSkin1Head", "HeartlessSkin1Suit"}) do
        local item = char:FindFirstChild(name, true)
        if item then pcall(function() item:Destroy() end) end
    end
end

local function addHeartlessSkin1Asset(char, assetId, itemName, stateKey, epoch)
    if not char or skinMode ~= "Skin1" or not assetId or sk5LoadState[stateKey] then return end
    if char:FindFirstChild(itemName, true) then return end
    sk5LoadState[stateKey] = true
    local ok, objects = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(assetId)) end)
    local source = ok and objects and objects[1]
    if not source or epoch ~= sk5Epoch or skinMode ~= "Skin1" or LP.Character ~= char or not char.Parent then
        if source then pcall(function() source:Destroy() end) end
        sk5LoadState[stateKey] = false
        return
    end
    local accessory = source:IsA("Accessory") and source or source:FindFirstChildWhichIsA("Accessory", true)
    local item = accessory or source:FindFirstChildWhichIsA("Shirt", true) or source:FindFirstChildWhichIsA("Pants", true) or source
    if item then
        item.Name = itemName
        item.Parent = char
        if accessory then
            local head = char:FindFirstChild("Head")
            local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
            if head and handle then mountHeartlessLegacySkin4Valk(accessory, head, stateKey == "Head" and CFrame.new(0, 0.28, 0) or CFrame.new()) end
        end
    end
    if source ~= item and source.Parent then pcall(function() source:Destroy() end) end
    sk5LoadState[stateKey] = false
end

local function addHeartlessSkin1(char)
    if not char or skinMode ~= "Skin1" then return end
    local epoch = sk5Epoch
    addHeartlessSkin1Asset(char, skin1HeadAssetId, "HeartlessSkin1Head", "Head", epoch)
    addHeartlessSkin1Asset(char, skin1SuitAssetId, "HeartlessSkin1Suit", "Suit", epoch)
end

function removeHeartlessAccessories(char)
    if not char or skinMode == "LegacySkin4" or skinMode == "Skin1" then return end
    -- Hide accessories without destroying them so restoreHeartlessSkin can restore them
    -- immediately when the skin is disabled, preserving their instances and welds.
    for _,child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") then
            for _,obj in ipairs(child:GetDescendants()) do
                if obj:IsA("BasePart") then
                    heartlessRemember(obj, {
                        kind="part", color=obj.Color, material=obj.Material,
                        size=obj.Size, transparency=obj.Transparency,
                        localTransparency=obj.LocalTransparencyModifier,
                        reflectance=obj.Reflectance,
                    })
                    obj.LocalTransparencyModifier=1
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    heartlessRemember(obj, {kind="texture", transparency=obj.Transparency})
                    obj.Transparency=1
                end
            end
        end
    end
end
function removeHeartlessLegacySkin4Accessories(char)
    if not char then return end
    for _, name in ipairs({"HeartlessLegacySkin4Valk", "HeartlessLegacySkin4Horns", "HeartlessLegacySkin4Glasses"}) do
        local item = char:FindFirstChild(name, true)
        if item then pcall(function() item:Destroy() end) end
    end
end

function applyHeartlessSkin(char)
    if not heartlessSkinEnabled or not char or not char.Parent then return end
    if skinMode ~= "LegacySkin4" then removeHeartlessLegacySkin4Accessories(char) end
    if skinMode ~= "Skin1" then removeHeartlessSkin1Accessories(char) end
    if skinMode == "LegacySkin2" then
        -- Skin 2 no usa fuego ni corona; Skin 3 y Skin 4 conservan la roseta opcional.
        for _,name in ipairs({"HeartlessSkinRosette"}) do
            local effect = char:FindFirstChild(name, true)
            if effect then pcall(function() effect:Destroy() end) end
        end
    end
    removeHeartlessAccessories(char)
    if skinMode == "LegacySkin4" then
        addHeartlessLegacySkin4Valk(char)
        addHeartlessLegacySkin4Horns(char)
        hideHeartlessLegacySkin4Hair(char)
    elseif skinMode == "Skin1" then
        addHeartlessSkin1(char)
    end
    applyHeartlessBody(char)
    repairHeartlessLegs(char)
    if skinMode == "LegacySkin4" then addHeartlessLegacySkin4HeadGlow(char)
    else
        local oldGlow=char:FindFirstChild("HeartlessLegacySkin4HeadGlow",true)
        if oldGlow then pcall(function() oldGlow:Destroy() end) end
    end
    if blackSmokeEnabled then addHeartlessBlackSmoke(char)
    else
        local oldBlack=char:FindFirstChild("HeartlessBlackSmoke",true)
        if oldBlack then pcall(function() oldBlack:Destroy() end) end
    end
    if (skinMode == "LegacySkin1" or skinMode == "LegacySkin3") and crownEnabled then
        if not char:FindFirstChild("HeartlessSkinRosette") then addHeartlessRosette(char) end
    else
        local oldRosette = char:FindFirstChild("HeartlessSkinRosette")
        if oldRosette then pcall(function() oldRosette:Destroy() end) end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then
            root.Transparency = 1
            root.LocalTransparencyModifier = 1
        end
    end
end

function setHeartlessRightLegHidden(on, silent)
    rightLegHiddenEnabled = on == true
    if heartlessSkinEnabled then applyHeartlessSkin(LP.Character) end
    if not silent then saveConfig() end
end

local function getHeartlessSmokeColor()
    if smokeColor=="White" then return Color3.fromRGB(245,245,245),Color3.fromRGB(215,215,215) end
    if smokeColor=="Gray" then return Color3.fromRGB(125,125,125),Color3.fromRGB(75,75,75) end
    return Color3.fromRGB(0,0,0),Color3.fromRGB(12,12,12)
end

function addHeartlessLegacySkin4HeadGlow(char)
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local glow = head:FindFirstChild("HeartlessLegacySkin4HeadGlow")
    if glow and not glow:IsA("Fire") then glow:Destroy(); glow=nil end
    if not glow then glow=Instance.new("Fire"); glow.Name="HeartlessLegacySkin4HeadGlow"; glow.Parent=head end
    glow.Color=skin4GlowColor
    glow.SecondaryColor=skin4AccentColor
    glow.Heat=0
    glow.Size=3.5
    glow.Enabled=true
end

function addHeartlessBlackSmoke(char)
    local head=char and char:FindFirstChild("Head")
    if not head then return end
    local smoke=head:FindFirstChild("HeartlessBlackSmoke")
    if smoke and not smoke:IsA("Fire") then smoke:Destroy();smoke=nil end
    if not smoke then smoke=Instance.new("Fire");smoke.Name="HeartlessBlackSmoke";smoke.Parent=head end
    smoke.Color,smoke.SecondaryColor=getHeartlessSmokeColor()
    smoke.Heat=5;smoke.Size=5;smoke.Enabled=true
end
function setHeartlessBlackSmokeEnabled(on, silent)
    blackSmokeEnabled=on==true
    local char=LP.Character
    local smoke=char and char:FindFirstChild("HeartlessBlackSmoke",true)
    if blackSmokeEnabled and heartlessSkinEnabled then addHeartlessBlackSmoke(char)
    elseif smoke then pcall(function() smoke:Destroy() end) end
    if heartlessSkinEnabled then applyHeartlessSkin(char) end
    if not silent then saveConfig() end
end
local heartlessVisualGuardStarted=false

-- Reapplies visibility after the body pass or another visual routine changes
-- accessory parts. This keeps Skin 4 accessories visible for the whole session.
function enforceHeartlessLegacySkin4AccessoryVisibility(char)
    if not char or skinMode ~= "LegacySkin4" then return end
    for _, accessoryName in ipairs({"HeartlessLegacySkin4Valk", "HeartlessLegacySkin4Horns"}) do
        local accessory = char:FindFirstChild(accessoryName, true)
        if accessory then
            for _, obj in ipairs(accessory:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Transparency = 0
                    obj.LocalTransparencyModifier = 0
                    obj.CanCollide = false
                    obj.CanTouch = false
                    obj.CanQuery = false
                    obj.Massless = true
                    obj.CastShadow = false
                    if accessoryName == "HeartlessLegacySkin4Horns" then
                        obj.Color = Color3.fromRGB(0, 0, 0)
                        obj.Material = Enum.Material.SmoothPlastic
                    else
                        obj.Color = skin4AccentColor
                        obj.Material = Enum.Material.SmoothPlastic
                    end
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 0
                end
            end
        end
    end
end

function startHeartlessVisualGuard()
    if heartlessVisualGuardStarted then return end
    heartlessVisualGuardStarted=true
    task.spawn(function()
        while task.wait(0.35) do
            if heartlessSkinEnabled and LP.Character and LP.Character.Parent then
                local char=LP.Character
                local crown=char:FindFirstChild("HeartlessSkinRosette")
                local crownAllowed=(skinMode=="LegacySkin1" or skinMode=="LegacySkin3") and crownEnabled
                if crownAllowed then
                    if not crown then addHeartlessRosette(char) end
                    crown=char:FindFirstChild("HeartlessSkinRosette")
                    if crown then
                        for _,p in ipairs(crown:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.Transparency=0.02;p.LocalTransparencyModifier=0;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
                                p.Color=(skinMode=="LegacySkin4") and skin4AccentColor or ((crownStyle=="Black") and Color3.fromRGB(0,0,0) or HEARTLESS.crownColor)
                                p.Material=Enum.Material.SmoothPlastic
                            end
                        end
                    end
                elseif crown then
                    pcall(function() crown:Destroy() end)
                end
                local head=char:FindFirstChild("Head")
                if skinMode=="LegacySkin4" and head then
                    addHeartlessLegacySkin4Valk(char)
                    addHeartlessLegacySkin4Horns(char)
                    enforceHeartlessLegacySkin4AccessoryVisibility(char)
                    hideHeartlessLegacySkin4Hair(char)
                    addHeartlessLegacySkin4HeadGlow(char)
                elseif skinMode=="Skin1" and head then
                    addHeartlessSkin1(char)
                else
                    removeHeartlessLegacySkin4Accessories(char)
                    removeHeartlessSkin1Accessories(char)
                    local glow=head and head:FindFirstChild("HeartlessLegacySkin4HeadGlow")
                    if glow then pcall(function() glow:Destroy() end) end
                end
                local black=head and head:FindFirstChild("HeartlessBlackSmoke")
                if blackSmokeEnabled and head then
                    if not black or not black:IsA("Fire") then
                        if black then black:Destroy() end
                        addHeartlessBlackSmoke(char)
                    else
                        black.Enabled=true;black.Color,black.SecondaryColor=getHeartlessSmokeColor();black.Heat=5;black.Size=5
                    end
                elseif black then
                    pcall(function() black:Destroy() end)
                end
            end
        end
    end)
end

local enemySpeedDisplayStarted = false
function getEnemyHorizontalSpeed(root)
    if not root or not root.Parent then return 0 end
    -- Read each enemy's current movement velocity; this is not a fixed value.
    local velocity = root.AssemblyLinearVelocity
    local horizontal = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    return horizontal < 0.05 and 0 or horizontal
end

function formatEnemySpeed(value)
    return string.format("%.1f", tonumber(value) or 0)
end

function updateEnemySpeedDisplay(playerObj)
    if not playerObj or playerObj == LP then return end
    local char = playerObj.Character
    local head = char and char:FindFirstChild("Head")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not head or not root or not hum or hum.Health <= 0 then return end
    local gui = head:FindFirstChild("HeartlessEnemySpeedDisplay")
    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = "HeartlessEnemySpeedDisplay"
        gui.Adornee = head
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0, 120, 0, 28)
        gui.StudsOffset = Vector3.new(0, 3.2, 0)
        gui.MaxDistance = 1000
        gui.Parent = head
        local label = Instance.new("TextLabel")
        label.Name = "SpeedLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = getPastelThemeColor(themeName)
        label.TextStrokeTransparency = 1
        label.Font = (HEARTLESS.statusLabel and HEARTLESS.statusLabel.Font) or Enum.Font.GothamBold
        label.TextSize = (HEARTLESS.statusLabel and HEARTLESS.statusLabel.TextSize) or 11
        label.TextScaled = false
        label.TextXAlignment = (HEARTLESS.statusLabel and HEARTLESS.statusLabel.TextXAlignment) or Enum.TextXAlignment.Center
        label.TextYAlignment = (HEARTLESS.statusLabel and HEARTLESS.statusLabel.TextYAlignment) or Enum.TextYAlignment.Center
        label.Parent = gui
    end
    local label = gui:FindFirstChild("SpeedLabel")
    if label then
        label.TextColor3 = getPastelThemeColor(themeName)
        label.TextStrokeTransparency = 1
        local horizontalSpeed = getEnemyHorizontalSpeed(root)
        label.Text = "Speed: " .. formatEnemySpeed(horizontalSpeed)
    end
end

function startEnemySpeedDisplay()
    if enemySpeedDisplayStarted then return end
    enemySpeedDisplayStarted = true
    task.spawn(function()
        while task.wait(0.25) do
            for _, playerObj in ipairs(Players:GetPlayers()) do
                if playerObj ~= LP then updateEnemySpeedDisplay(playerObj) end
            end
        end
    end)
end

function setHeartlessSmokeColor(color, silent)
    if color~="Black" and color~="Gray" and color~="White" then return end
    smokeColor=color
    if blackSmokeEnabled and heartlessSkinEnabled then applyHeartlessSkin(LP.Character) end
    if not silent then saveConfig() end
end

function setHeartlessCrownEnabled(on, silent)
    crownEnabled=on==true
    if heartlessSkinEnabled then applyHeartlessSkin(LP.Character) end
    if not silent then saveConfig() end
end

function setHeartlessCrownStyle(style, silent)
    if style ~= "White" and style ~= "Black" then return end
    crownStyle=style
    if heartlessSkinEnabled and crownEnabled then applyHeartlessSkin(LP.Character) end
    if not silent then saveConfig() end
end

function setHeartlessHeadHidden(on, silent)
    hideHeadEnabled = on == true
    if heartlessSkinEnabled then
        applyHeartlessSkin(LP.Character)
    end
    if not silent then saveConfig() end
end

function setHeartlessSkinMode(mode, silent)
    if mode ~= "Skin1" then return end
    if skinMode == mode then return end
    -- Invalidate any game:GetObjects call still loading a Skin 4 accessory.
    skin4AccessoryEpoch = skin4AccessoryEpoch + 1
    sk5Epoch = sk5Epoch + 1
    sk5LoadState.Head = false; sk5LoadState.Suit = false
    skin4AccessoryLoading.Valk = false
    skin4AccessoryLoading.Horns = false
    local wasEnabled = heartlessSkinEnabled
    if wasEnabled then restoreHeartlessSkin() end
    skinMode = mode
    if wasEnabled then applyHeartlessSkin(LP.Character) end
    if not silent then saveConfig() end
end

function setHeartlessSkinEnabled(on, silent)
    if heartlessSkinEnabled ~= (on == true) then
        skin4AccessoryEpoch = skin4AccessoryEpoch + 1
        sk5Epoch = sk5Epoch + 1
        sk5LoadState.Head = false; sk5LoadState.Suit = false
        skin4AccessoryLoading.Valk = false
        skin4AccessoryLoading.Horns = false
    end
    heartlessSkinEnabled = on == true
    if heartlessSkinEnabled then
        applyHeartlessSkin(LP.Character)
        if not HEARTLESS.characterConn then
            HEARTLESS.characterConn = LP.CharacterAdded:Connect(function(char)
                task.wait(0.35)
                if heartlessSkinEnabled then
                    HEARTLESS.original = {}
                    HEARTLESS.lastSkinChar = nil
                    applyHeartlessSkin(char)
                end
            end)
        end
        if not HEARTLESS.renderConn then
            HEARTLESS.renderConn = RunService.Heartbeat:Connect(function()
                if not heartlessSkinEnabled then return end
                local char = LP.Character
                if char and char.Parent then
                    local head = char:FindFirstChild("Head")
                    local headWasShown = hideHeadEnabled and head and (head.Transparency < 1 or head.LocalTransparencyModifier < 1)
                    if char ~= HEARTLESS.lastSkinChar or headWasShown then
                        HEARTLESS.lastSkinChar = char
                        applyHeartlessSkin(char)
                    end
                end
            end)
        end
    else
        if HEARTLESS.renderConn then HEARTLESS.renderConn:Disconnect(); HEARTLESS.renderConn = nil end
        if HEARTLESS.characterConn then HEARTLESS.characterConn:Disconnect(); HEARTLESS.characterConn = nil end
        restoreHeartlessSkin()
        HEARTLESS.lastSkinChar = nil
    end
    if not silent then saveConfig() end
end

-- ============================================================
-- BACKGROUND & ANIMATIONS
-- ============================================================
local animEnabled = false

currentSkyTheme = currentSkyTheme or "Off"
CANDY_SKY_TAG = "blessvsSkyTheme"
_G._blessvsSkyMode = _G._blessvsSkyMode or "Off"
candyOriginalLighting = nil

-- Added full custom sky preset set from uploaded skys.txt.
CANDY_SKY_PRESETS = {
    ["Off"] = {kind = "off"},

    ["Night"] = {
        clock = 22, brightness = 2,
        ambient = {110,100,130}, outAmb = {120,110,140},
        sky = {stars = 4000, moon = 18, sun = 0, moonTex = true},
        atm = {dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2},
    },
    ["Aurora"] = {
        clock = 14, brightness = 3,
        ambient = {150,120,150}, outAmb = {160,130,160},
        atm = {dens = 0.55, color = {255,80,200}, decay = {255,20,150}, glare = 2.5, haze = 3},
        clouds = {cover = 0.7, dens = 0.7, color = {255,240,250}},
    },
    ["Sunset"] = {
        clock = 17.2, brightness = 2.5,
        ambient = {170,120,100}, outAmb = {180,130,110},
        sky = {stars = 0, sun = 25, moon = 0},
        atm = {dens = 0.5, color = {255,130,60}, decay = {255,80,30}, glare = 2, haze = 2.5},
        clouds = {cover = 0.55, dens = 0.55, color = {255,200,140}},
    },
    ["Galaxy"] = {
        clock = 0, brightness = 1.5,
        ambient = {70,60,100}, outAmb = {80,70,110},
        sky = {stars = 10000, moon = 30, sun = 0},
        atm = {dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5},
    },
    ["Cyber"] = {
        clock = 21, brightness = 2.2,
        ambient = {90,130,170}, outAmb = {100,140,180},
        sky = {stars = 2000, moon = 12},
        atm = {dens = 0.4, color = {0,200,255}, decay = {150,0,255}, glare = 2, haze = 2},
        clouds = {cover = 0.4, dens = 0.6, color = {100,200,255}},
    },
    ["Sakura"] = {
        clock = 11, brightness = 3.5,
        ambient = {170,150,160}, outAmb = {180,160,170},
        sky = {sun = 8},
        atm = {dens = 0.3, color = {255,200,220}, decay = {255,170,200}, glare = 1, haze = 1.5},
        clouds = {cover = 0.6, dens = 0.4, color = {255,250,252}},
    },
    ["Pink Night"] = {
        clock = 23, brightness = 2.2,
        ambient = {120,60,110}, outAmb = {140,70,120},
        sky = {stars = 5000, moon = 22, sun = 0, moonTex = true},
        atm = {dens = 0.5, color = {255,80,180}, decay = {140,30,100}, glare = 0.7, haze = 1.4},
        clouds = {cover = 0.3, dens = 0.5, color = {180,90,150}},
    },

    -- ================================================================
    -- 15 NEW PRESETS
    -- ================================================================

    ["Blood Moon"] = {
        clock = 22.5, brightness = 1.6,
        ambient = {130,40,40}, outAmb = {150,50,50},
        sky = {stars = 1500, moon = 28, sun = 0, moonTex = true},
        atm = {dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2},
        clouds = {cover = 0.5, dens = 0.7, color = {120,30,30}},
    },
    ["Emerald Dawn"] = {
        clock = 6.5, brightness = 2.8,
        ambient = {130,170,140}, outAmb = {140,180,150},
        sky = {sun = 18, moon = 0, stars = 0},
        atm = {dens = 0.4, color = {80,200,140}, decay = {40,150,90}, glare = 1.8, haze = 2.2},
        clouds = {cover = 0.5, dens = 0.5, color = {200,255,220}},
    },
    ["Volcanic"] = {
        clock = 19, brightness = 2,
        ambient = {180,80,40}, outAmb = {200,90,50},
        sky = {stars = 200, sun = 12, moon = 0},
        atm = {dens = 0.75, color = {255,60,0}, decay = {180,20,0}, glare = 3, haze = 3.5},
        clouds = {cover = 0.8, dens = 0.9, color = {120,40,20}},
    },
    ["Arctic"] = {
        clock = 9, brightness = 3.2,
        ambient = {200,220,235}, outAmb = {210,230,245},
        sky = {sun = 10, stars = 0, moon = 0},
        atm = {dens = 0.3, color = {180,220,255}, decay = {140,200,240}, glare = 1.5, haze = 1.8},
        clouds = {cover = 0.7, dens = 0.6, color = {250,253,255}},
    },
    ["Midnight Ocean"] = {
        clock = 1.5, brightness = 1.7,
        ambient = {60,90,130}, outAmb = {70,100,140},
        sky = {stars = 6000, moon = 24, sun = 0, moonTex = true},
        atm = {dens = 0.5, color = {20,60,140}, decay = {10,30,90}, glare = 0.6, haze = 1.5},
    },
    ["Vaporwave"] = {
        clock = 19.5, brightness = 2.4,
        ambient = {180,120,200}, outAmb = {190,130,210},
        sky = {stars = 1000, moon = 14},
        atm = {dens = 0.45, color = {255,100,220}, decay = {120,60,255}, glare = 2.2, haze = 2.4},
        clouds = {cover = 0.5, dens = 0.55, color = {200,150,255}},
    },
    ["Toxic"] = {
        clock = 13, brightness = 2.5,
        ambient = {140,180,80}, outAmb = {150,190,90},
        atm = {dens = 0.55, color = {100,220,40}, decay = {60,150,20}, glare = 1.8, haze = 2.6},
        clouds = {cover = 0.65, dens = 0.7, color = {180,255,120}},
    },
    ["Solar Eclipse"] = {
        clock = 12, brightness = 0.9,
        ambient = {50,40,60}, outAmb = {60,50,70},
        sky = {stars = 3500, sun = 22, moon = 0},
        atm = {dens = 0.5, color = {255,140,40}, decay = {30,20,40}, glare = 2.8, haze = 1.8},
    },
    ["Hellscape"] = {
        clock = 18, brightness = 1.8,
        ambient = {200,60,30}, outAmb = {220,70,40},
        sky = {stars = 100, sun = 30, moon = 0},
        atm = {dens = 0.85, color = {255,30,0}, decay = {120,0,0}, glare = 3.5, haze = 4},
        clouds = {cover = 0.95, dens = 0.95, color = {80,20,10}},
    },
    ["Heaven"] = {
        clock = 12, brightness = 4,
        ambient = {240,235,210}, outAmb = {250,245,220},
        sky = {sun = 16, moon = 0, stars = 0},
        atm = {dens = 0.25, color = {255,250,220}, decay = {255,240,200}, glare = 3, haze = 1.5},
        clouds = {cover = 0.85, dens = 0.5, color = {255,255,255}},
    },
    ["Storm"] = {
        clock = 15, brightness = 1.4,
        ambient = {90,90,110}, outAmb = {100,100,120},
        sky = {stars = 0, sun = 6, moon = 0},
        atm = {dens = 0.65, color = {80,90,120}, decay = {40,50,80}, glare = 0.5, haze = 3},
        clouds = {cover = 0.95, dens = 0.95, color = {60,65,80}},
    },
    ["Sunrise"] = {
        clock = 6.2, brightness = 2.8,
        ambient = {220,180,130}, outAmb = {230,190,140},
        sky = {sun = 22, stars = 0, moon = 0},
        atm = {dens = 0.45, color = {255,180,100}, decay = {255,140,80}, glare = 2.4, haze = 2.2},
        clouds = {cover = 0.4, dens = 0.4, color = {255,220,180}},
    },
    ["Deep Space"] = {
        clock = 0, brightness = 1,
        ambient = {30,25,50}, outAmb = {40,35,60},
        sky = {stars = 15000, moon = 0, sun = 0},
        atm = {dens = 0.08, color = {15,5,40}, decay = {5,0,20}, glare = 0.2, haze = 0.3},
    },
    ["Lavender Dream"] = {
        clock = 18.5, brightness = 2.6,
        ambient = {180,160,220}, outAmb = {190,170,230},
        sky = {stars = 800, moon = 16, sun = 0},
        atm = {dens = 0.4, color = {200,160,255}, decay = {160,120,220}, glare = 1.4, haze = 1.8},
        clouds = {cover = 0.55, dens = 0.5, color = {220,200,255}},
    },
    ["Inferno"] = {
        clock = 17.5, brightness = 2.2,
        ambient = {220,100,40}, outAmb = {235,110,50},
        sky = {sun = 26, moon = 0, stars = 0},
        atm = {dens = 0.6, color = {255,90,20}, decay = {200,40,0}, glare = 3, haze = 3.2},
        clouds = {cover = 0.7, dens = 0.7, color = {200,80,40}},
    },
    ["Mint Sky"] = {
        clock = 10, brightness = 3.2,
        ambient = {180,230,210}, outAmb = {190,240,220},
        sky = {sun = 10},
        atm = {dens = 0.32, color = {150,255,210}, decay = {100,220,180}, glare = 1.6, haze = 1.6},
        clouds = {cover = 0.55, dens = 0.45, color = {240,255,250}},
    },
}

function candySaveOriginalLighting()
	if candyOriginalLighting then return end
	candyOriginalLighting={
		ClockTime=Lighting.ClockTime,
		OutdoorAmbient=Lighting.OutdoorAmbient,
		Ambient=Lighting.Ambient,
		Brightness=Lighting.Brightness,
		FogStart=Lighting.FogStart,
		FogEnd=Lighting.FogEnd,
		FogColor=Lighting.FogColor,
		ColorShift_Top=Lighting.ColorShift_Top,
		ColorShift_Bottom=Lighting.ColorShift_Bottom,
		GeographicLatitude=Lighting.GeographicLatitude,
		GlobalShadows=Lighting.GlobalShadows,
		LightingChildren={},
		TerrainChildren={}
	}
	for _,child in ipairs(Lighting:GetChildren()) do
		if child:IsA("Sky") or child:IsA("Atmosphere") then table.insert(candyOriginalLighting.LightingChildren,child:Clone()) end
	end
	local terrain=workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _,child in ipairs(terrain:GetChildren()) do
			if child:IsA("Clouds") then table.insert(candyOriginalLighting.TerrainChildren,child:Clone()) end
		end
	end
end

function candyClearSky(removeAll)
	for _,child in ipairs(Lighting:GetChildren()) do
		if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and (child:IsA("Sky") or child:IsA("Atmosphere"))) then pcall(function() child:Destroy() end) end
	end
	local terrain=workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _,child in ipairs(terrain:GetChildren()) do
			if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and child:IsA("Clouds")) then pcall(function() child:Destroy() end) end
		end
	end
end

function candyInstance(className,parent,props)
	local inst=Instance.new(className)
	inst:SetAttribute(CANDY_SKY_TAG,true)
	for k,v in pairs(props or {}) do pcall(function() inst[k]=v end) end
	inst.Parent=parent
	return inst
end

function candyColor(rgb)
	return Color3.fromRGB(rgb[1],rgb[2],rgb[3])
end

function CandyApplyCustomSky(mode)
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset then mode="Off";preset=CANDY_SKY_PRESETS.Off end
    currentSkyTheme=mode
    candySaveOriginalLighting()
    candyClearSky(true)

    if mode=="Off" or preset.kind=="off" then
        if candyOriginalLighting then
            for k,v in pairs(candyOriginalLighting) do
                if k~="LightingChildren" and k~="TerrainChildren" then pcall(function() Lighting[k]=v end) end
            end
            for _,child in ipairs(candyOriginalLighting.LightingChildren or {}) do pcall(function() child:Clone().Parent=Lighting end) end
            local offTerrain=workspace:FindFirstChildOfClass("Terrain")
            if offTerrain then
                for _,child in ipairs(candyOriginalLighting.TerrainChildren or {}) do pcall(function() child:Clone().Parent=offTerrain end) end
            end
        end
        _G._blessvsSkyMode="Off"
        return true
    end

    local terrain=workspace:FindFirstChildOfClass("Terrain")
    pcall(function()
        Lighting.FogStart=0
        Lighting.FogEnd=100000
        Lighting.FogColor=Color3.fromRGB(170,95,235)
        Lighting.ColorShift_Top=Color3.fromRGB(0,0,0)
        Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0)
        Lighting.GlobalShadows=true
        Lighting.ClockTime=preset.clock or 14
        Lighting.Brightness=preset.brightness or 2
        if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
        if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    end)

    -- Always create a dedicated Sky, so themes without explicit sky data still render.
    local skyProps={Name="BlessSkyTheme",StarCount=0,MoonAngularSize=0,SunAngularSize=0}
    if preset.sky then
        if preset.sky.stars~=nil then skyProps.StarCount=preset.sky.stars end
        if preset.sky.moon~=nil then skyProps.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun~=nil then skyProps.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyProps.MoonTextureId="rbxasset://sky/moon.jpg" end
    end
    candyInstance("Sky",Lighting,skyProps)

    if preset.atm then
        candyInstance("Atmosphere",Lighting,{Name="BlessAtmosphere",Density=preset.atm.dens or 0.3,Color=candyColor(preset.atm.color),Decay=candyColor(preset.atm.decay),Glare=preset.atm.glare or 1,Haze=preset.atm.haze or 1})
    end
    if preset.clouds and terrain then
        candyInstance("Clouds",terrain,{Name="BlessClouds",Cover=preset.clouds.cover or 0.5,Density=preset.clouds.dens or 0.5,Color=candyColor(preset.clouds.color)})
    end
    _G._blessvsSkyMode=mode
    return true
end

CandySkyOrder={{"Off","Off"},{"Night","Night"},{"Aurora","Aurora"},{"Sunset","Sunset"},{"Galaxy","Galaxy"},{"Cyber","Cyber"},{"Sakura","Sakura"},{"Pink Night","Pink Night"},{"Blood Moon","Blood Moon"},{"Emerald Dawn","Emerald Dawn"},{"Volcanic","Volcanic"},{"Arctic","Arctic"},{"Midnight Ocean","Midnight Ocean"},{"Vaporwave","Vaporwave"},{"Toxic","Toxic"},{"Solar Eclipse","Solar Eclipse"},{"Hellscape","Hellscape"},{"Heaven","Heaven"},{"Storm","Storm"},{"Sunrise","Sunrise"},{"Deep Space","Deep Space"},{"Lavender Dream","Lavender Dream"},{"Inferno","Inferno"},{"Mint Sky","Mint Sky"}}




-- Imported animation packs from rotx_fe_klan(2), exposed in a reordered selector.
HEARTLESS_ANIMATION_PACKS = {
	["Adidas Sports"] = {WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,SwimIdle=18537387180,Swim=18537389531,Animation1=18537376492,Animation2=18537371272,ClimbAnim=18537363391},
	["Adidas Community"] = {WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,SwimIdle=109346520324160,Swim=133308483266208,Animation1=122257458498464,Animation2=102357151005774,ClimbAnim=88763136693023},
	["Adidas Aura"] = {WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,SwimIdle=94922130551805,Swim=134530128383903,Animation1=110211186840347,Animation2=114191137265065,ClimbAnim=97824616490448},
	["Wicked Popular"] = {WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,Animation1=118832222982049,ClimbAnim=131326830509784,SwimIdle=113199415118199,Swim=99384245425157,Animation2=76049494037641},
	["Elder"] = {WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,SwimIdle=10921110146,Swim=10921108971,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
	["Zombie"] = {WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,SwimIdle=10921353442,Swim=10921352344,Animation1=10921344533,Animation2=10921345304,ClimbAnim=10921343576},
	["Mage"] = {WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,SwimIdle=10921151661,Swim=10921150788,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
	["Catwalk Glam"] = {WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,SwimIdle=98854111361360,Swim=134591743181628,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
	["Astronaut"] = {WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,SwimIdle=10921045006,Swim=10921044000,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
	['Wicked "Dancing Through Life"'] = {WalkAnim=73718308412641,RunAnim=135515454877967,JumpAnim=78508480717326,FallAnim=78147885297412,SwimIdle=129183123083281,Swim=110657013921774,ClimbAnim=129447497744818,Animation1=92849173543269,Animation2=132238900951109},
	["Werewolf"] = {WalkAnim=10921342074,RunAnim=10921336997,FallAnim=10921337907,SwimIdle=10921341319,Swim=10921340419,ClimbAnim=10921329322,Animation1=10921330408,Animation2=10921333667},
	["Superhero"] = {WalkAnim=10921298616,RunAnim=10921291831,JumpAnim=10921294559,FallAnim=10921293373,SwimIdle=10921297391,Swim=10921295495,ClimbAnim=10921286911,Animation1=10921288909,Animation2=10921290167},
	["Toy"] = {WalkAnim=10921312010,RunAnim=10921306285,JumpAnim=10921308158,FallAnim=10921307241,SwimIdle=10921310341,Swim=10921309319,ClimbAnim=10921300839,Animation1=10921301576},
	["No Boundaries"] = {WalkAnim=18747074203,RunAnim=18747070484,JumpAnim=18747069148,FallAnim=18747062535,SwimIdle=18747071682,Swim=18747073181,ClimbAnim=18747060903,Animation1=18747067405,Animation2=18747063918},
	["NFL"] = {WalkAnim=110358958299415,RunAnim=117333533048078,JumpAnim=119846112151352,FallAnim=129773241321032,SwimIdle=79090109939093,Swim=132697394189921,ClimbAnim=134630013742019,Animation1=92080889861410,Animation2=74451233229259},
	["Amazon Unboxed"] = {WalkAnim=90478085024465,RunAnim=134824450619865,JumpAnim=121454505477205,FallAnim=94788218468396,SwimIdle=129126268464847,Swim=105962919001086,ClimbAnim=121145883950231,Animation1=98281136301627},
	["Vampire"] = {WalkAnim=10921326949,RunAnim=10921320299,JumpAnim=10921322186,FallAnim=10921321317,SwimIdle=10921325443,Swim=10921324408,ClimbAnim=10921314188,Animation1=10921315373},
	["Ninja"] = {RunAnim=656118852,WalkAnim=656121766,JumpAnim=656117878,FallAnim=656115606,Swim=656119721,SwimIdle=656121397,ClimbAnim=656114359,Idle={656117400,656118341,886742569}},
	["Robot"] = {RunAnim=616091570,WalkAnim=616095330,JumpAnim=616090535,FallAnim=616087089,Swim=616092998,SwimIdle=616094091,ClimbAnim=616086039,Idle={616088211,616089559,885531463}},
	["Levitation"] = {RunAnim=616010382,WalkAnim=616013216,JumpAnim=616008936,FallAnim=616005863,Swim=616011509,SwimIdle=616012453,ClimbAnim=616003713,Idle={616006778,616008087,886862142}},
	["Stylish"] = {RunAnim=616140816,WalkAnim=616146177,JumpAnim=616139451,FallAnim=616134815,Swim=616143378,SwimIdle=616144772,ClimbAnim=616133594,Idle={616136790,616138447,886888594}},
	["Bubbly"] = {RunAnim=910025107,WalkAnim=910034870,JumpAnim=910016857,FallAnim=910001910,Swim=910028158,SwimIdle=910030921,ClimbAnim=909997997,Idle={910004836,910009958,1018536639}},
	["Cartoon"] = {RunAnim=742638842,WalkAnim=742640026,JumpAnim=742637942,FallAnim=742637151,Swim=742639220,SwimIdle=742639812,ClimbAnim=742636889,Idle={742637544,742638445,885477856}},
}

-- Zombie Anims (Rembembi)
local animPackName = "Zombie"
local RembembiAnims = {
    WalkAnim  = 73718308412641,
    RunAnim   = 135515454877967,
    JumpAnim  = 78508480717326,
    FallAnim  = 78147885297412,
    SwimIdle  = 129183123083281,
    Swim      = 110657013921774,
    ClimbAnim = 129447497744818,
    Animation1 = 92849173543269,
    Animation2 = 132238900951109,
}
local AnimRefs = { heartbeat=nil, savedAnimate=nil, originalAnims=nil }
local startAnimToggle, stopAnimToggle
do
    local LP_anim = Players.LocalPlayer
    function isRembembiAnim(id)
        if not id then return false end
        for _,v in pairs(RembembiAnims) do if v == id then return true end end
        return false
    end
    function saveOriginalAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        function g(obj) return obj and obj.AnimationId or nil end
        local ids = {
            walk=g(animate.walk and animate.walk.WalkAnim),
            run=g(animate.run and animate.run.RunAnim),
            jump=g(animate.jump and animate.jump.JumpAnim),
            fall=g(animate.fall and animate.fall.FallAnim),
            climb=g(animate.climb and animate.climb.ClimbAnim),
            swim=g(animate.swim and animate.swim.Swim),
            swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),
            idle1=g(animate.idle and animate.idle.Animation1),
            idle2=g(animate.idle and animate.idle.Animation2),
        }
        if not AnimRefs.originalAnims then AnimRefs.originalAnims = ids end
    end
    function applyRembembiAnims(char)
        local animate = char and char:FindFirstChild("Animate")
        if not animate then return end
        local pack = HEARTLESS_ANIMATION_PACKS[animPackName] or RembembiAnims
        local function pick(...) for i=1,select("#",...) do local v=pack[select(i,...)]; if v~=nil then return v end end end
        local function idleAt(i) return pack["Animation"..i] or (pack.Idle and pack.Idle[i]) end
        local function ensure(folder,name)
            if not folder then return nil end
            local obj=folder:FindFirstChild(name)
            if not obj then obj=Instance.new("Animation");obj.Name=name;obj.Parent=folder end
            return obj
        end
        local function set(obj,id) if obj and id then obj.AnimationId="rbxassetid://"..tostring(id) end end
        set(ensure(animate:FindFirstChild("run"),"RunAnim"),pick("RunAnim","Run"))
        set(ensure(animate:FindFirstChild("walk"),"WalkAnim"),pick("WalkAnim","Walk"))
        set(ensure(animate:FindFirstChild("jump"),"JumpAnim"),pick("JumpAnim","Jump"))
        set(ensure(animate:FindFirstChild("fall"),"FallAnim"),pick("FallAnim","Fall"))
        set(ensure(animate:FindFirstChild("climb"),"ClimbAnim"),pick("ClimbAnim","Climb"))
        set(ensure(animate:FindFirstChild("swim"),"Swim"),pick("Swim","SwimAnim"))
        set(ensure(animate:FindFirstChild("swimidle"),"SwimIdle"),pick("SwimIdle","Swim"))
        local idleFolder=animate:FindFirstChild("idle")
        if idleFolder then
            local count=pack.Idle and #pack.Idle or 2
            for i=1,math.max(2,count) do
                local id=idleAt(i)
                if id then set(ensure(idleFolder,"Animation"..i),id) end
            end
        end
    end
    function restartAnimPlayback(char)
        local animate=char and char:FindFirstChild("Animate")
        if not animate then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then for _,track in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end end
        animate.Disabled=true
        task.wait(0.06)
        animate.Disabled=false
        local hum2=char:FindFirstChildOfClass("Humanoid")
        if hum2 then pcall(function() hum2:ChangeState(Enum.HumanoidStateType.Landed);task.wait(0.03);hum2:ChangeState(Enum.HumanoidStateType.Running) end) end
    end
    function restoreOriginalAnims(char)
        local orig = AnimRefs.originalAnims
        if not orig then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        function s(obj, id) if obj and id then obj.AnimationId = id end end
        s(animate.walk and animate.walk.WalkAnim, orig.walk)
        s(animate.run and animate.run.RunAnim, orig.run)
        s(animate.jump and animate.jump.JumpAnim, orig.jump)
        s(animate.fall and animate.fall.FallAnim, orig.fall)
        s(animate.climb and animate.climb.ClimbAnim, orig.climb)
        s(animate.swim and animate.swim.Swim, orig.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, orig.swimidle)
        s(animate.idle and animate.idle.Animation1, orig.idle1)
        s(animate.idle and animate.idle.Animation2, orig.idle2)
    end
    function startAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then saveOriginalAnims(char); applyRembembiAnims(char); restartAnimPlayback(char) end
        local lastAnimChar=nil
        local lastAnimApply=0
        AnimRefs.heartbeat = RunService.Heartbeat:Connect(function()
            if not animEnabled then return end
            local now=os.clock()
            local c=LP_anim.Character
            local newChar=(c~=lastAnimChar)
            if c and (newChar or now-lastAnimApply>=0.5) then
                lastAnimChar=c
                lastAnimApply=now
                applyRembembiAnims(c)
                if newChar then restartAnimPlayback(c) end
            end
        end)
    end
    function stopAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then restoreOriginalAnims(char) end
    end
end

-- MOBILE BUTTON POSITIONS
local MOB_POS_FILE="Spectrum_BtnPos.json"
function loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end; return {}
end
function saveBtnPositions()
    if not writefile then return end; if not mobGuiRef then return end
    local out={}
    -- Save the MobileButtons group frame itself so its position persists
    local group=mobGuiRef:FindFirstChild("MobileButtons")
    if group then out["__group"]={xs=group.Position.X.Scale,xo=group.Position.X.Offset,ys=group.Position.Y.Scale,yo=group.Position.Y.Offset} end
    -- Save every SBtn_ frame, including those nested inside the MobileButtons group
    for _,child in ipairs(mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child.Name:sub(1,5)=="SBtn_" then
            local lbl=child.Name:sub(6)
            out[lbl]={xs=child.Position.X.Scale,xo=child.Position.X.Offset,ys=child.Position.Y.Scale,yo=child.Position.Y.Offset}
        end
    end
    local lockFr=mobGuiRef:FindFirstChild("SBtnLock") or (group and group:FindFirstChild("SBtnLock"))
    if lockFr then out["__lock"]={xs=lockFr.Position.X.Scale,xo=lockFr.Position.X.Offset,ys=lockFr.Position.Y.Scale,yo=lockFr.Position.Y.Offset} end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
end
task.spawn(function() while true do task.wait(3);pcall(saveBtnPositions) end end)

local startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter
local startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local enableAntiLag,disableAntiLag,enableStretchRez,disableStretchRez
local startBatAimbot,stopBatAimbot,queueAutoBatStart,startTpBat,stopTpBat,startTpBat2,stopTpBat2,runDrop,runTPFloor,cursedInstaReset
local startAutoSteal,stopAutoSteal,toggleLaggerMode

function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(200,200,200))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
local fovConn=nil
function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam and cam.FieldOfView~=fovValue then cam.FieldOfView=fovValue end end)
end
applyFOV()

-- RAGDOLL TIMERS DISABLED
function createRagdollBillboard(duration,labelText,color) return nil end
function onHumanoidStateChanged(old,new) end
function onMedusaStateChanged() end
function setupRagdollTriggers() end

function setupSpeedIndicator(char)
    local anchor=char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("Head",5)
    if not anchor then return end
    local old=char:FindFirstChild("MoveeSpeedBB",true)
    if old then pcall(function() old:Destroy() end) end
    local bb=Instance.new("BillboardGui")
    bb.Name="MoveeSpeedBB";bb.Adornee=anchor;bb.Parent=anchor
    bb.Size=UDim2.new(0,160,0,56);bb.StudsOffset=Vector3.new(0,3.7,0)
    bb.AlwaysOnTop=true;bb.Enabled=true;bb.LightInfluence=0;bb.MaxDistance=1000
    -- Se elimina el texto de marca que aparecía encima del personaje.
    speedLabel=Instance.new("TextLabel",bb);speedLabel.Size=UDim2.new(1,0,1,0);speedLabel.Position=UDim2.new(0,0,0,0);speedLabel.BackgroundTransparency=1;speedLabel.Text="0"
    speedLabel.TextColor3=getPastelThemeColor(themeName);speedLabel.Font=Enum.Font.GothamBlack;speedLabel.TextScaled=true;speedLabel.TextStrokeTransparency=1;speedLabel.Visible=true
    local limit=Instance.new("UITextSizeConstraint",speedLabel);limit.MinTextSize=11;limit.MaxTextSize=24
    speedModeLabel=nil
    -- Color pastel sólido, sin efecto mate ni shimmer.

end
function isHeartlessCarryState()
    return isStealing==true or (Steal and Steal.AutoStealEnabled and stealStartTime~=nil)
end
function getActiveMoveSpeed()
    -- Only the manual control decides between Carry and Normal.
    local carrying=(speedCarryActive==true)
    if HEARTLESS.speedMode=="Lagger" or laggerModeEnabled then return carrying and LAGGER_CARRY_SPEED or LAGGER_SPEED end
    if HEARTLESS.speedMode=="Custom" then return carrying and HEARTLESS.customSpeedSteal or HEARTLESS.customSpeedNorm end
    return carrying and CS or NS
end
function selectHeartlessSpeedProfile(profile)
    if profile~="Normal" and profile~="Lagger" and profile~="Custom" then return end
    local sameProfile=(HEARTLESS.speedMode==profile)
    if sameProfile then
        modeCarry[profile]=not (modeCarry[profile]==true)
    else
        local currentCarry=(speedCarryActive==true)
        HEARTLESS.speedMode=profile
        modeCarry[profile]=currentCarry
    end
    speedCarryActive=(modeCarry[profile]==true)
    if profile=="Normal" then laggerModeEnabled=false
    elseif profile=="Lagger" then laggerModeEnabled=true
    else laggerModeEnabled=false end
    refreshSpeedModeLabel()
    if HEARTLESS.statusLabel then
        HEARTLESS.statusLabel.Text="Speed: "..profile.."  |  Normal: "..string.format("%.1f", tonumber(getActiveMoveSpeed()) or 0).."  |  Steal: "..string.format("%.1f", tonumber((profile=="Normal" and CS) or (profile=="Lagger" and LAGGER_CARRY_SPEED) or HEARTLESS.customSpeedSteal) or 0)
    end
    for name,setter in pairs(HEARTLESS.speedCards) do pcall(function() setter(name==profile) end) end
    saveConfig()
end
function updateHeartlessSpeedStatus()
    if not HEARTLESS.statusLabel then return end
    local profile=HEARTLESS.speedMode
    local normal=(profile=="Normal" and NS) or (profile=="Lagger" and LAGGER_SPEED) or HEARTLESS.customSpeedNorm
    local steal=(profile=="Normal" and CS) or (profile=="Lagger" and LAGGER_CARRY_SPEED) or HEARTLESS.customSpeedSteal
    HEARTLESS.statusLabel.Text="Speed: "..profile.." | "..(speedCarryActive and "CARRY" or "NORMAL").." | Normal: "..string.format("%.1f", tonumber(normal) or 0).." | Steal: "..string.format("%.1f", tonumber(steal) or 0)
    for _,setter in pairs(HEARTLESS.speedCards) do pcall(function() setter(false) end) end
    if HEARTLESS.speedCards[profile] then pcall(function() HEARTLESS.speedCards[profile](true) end) end
end
function getAutoPathSpeed()
    return getActiveMoveSpeed()
end
local _lastSpeedUiRefresh=0
local _lastMovementTick=0
function startHeartlessSpeedController()
    if _G.__HEARTLESS_SPEED_CONTROLLER and _G.__HEARTLESS_SPEED_CONTROLLER ~= HEARTLESS.speedConn then
        pcall(function() _G.__HEARTLESS_SPEED_CONTROLLER:Disconnect() end)
        _G.__HEARTLESS_SPEED_CONTROLLER=nil
    end
    if HEARTLESS.speedConn then return end
    HEARTLESS.speedConn=RunService.RenderStepped:Connect(function(dt)
        local movementNow=os.clock()
        if movementNow-_lastMovementTick<0.03 then return end
        _lastMovementTick=movementNow
        local char=LP.Character;local hum=char and char:FindFirstChildOfClass("Humanoid");local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if isRagdollState(hum) then
            lastMoveDir=Vector3.zero
            destroySpeedObjects()
            return
        end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
            local md=hum.MoveDirection
            if typeof(md)~="Vector3" then md=Vector3.zero end
            if typeof(lastMoveDir)~="Vector3" then lastMoveDir=Vector3.zero end
            local speed=getActiveMoveSpeed();local dir=Vector3.zero
            if md.Magnitude>0 then
                lastMoveDir=md;dir=md
            elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
                local held=false
                for key in pairs(MOVE_KEYS or {}) do if UIS:IsKeyDown(key) then held=true;break end end
                if held then dir=lastMoveDir end
            end
            if dir.Magnitude>0 then
                local ok=pcall(function() applyHeartlessSpeedMethod(hrp,hum,dir,speed,dt) end)
                if not ok then destroySpeedObjects() end
            else
                destroySpeedObjects()
            end
        end
        local now=os.clock()
        if now-_lastSpeedUiRefresh>=0.15 then
            _lastSpeedUiRefresh=now
            if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
        end
    end)
    _G.__HEARTLESS_SPEED_CONTROLLER=HEARTLESS.speedConn
end
function stopHeartlessSpeedController()
    if HEARTLESS.speedConn then HEARTLESS.speedConn:Disconnect();HEARTLESS.speedConn=nil end
    if _G.__HEARTLESS_SPEED_CONTROLLER then pcall(function() _G.__HEARTLESS_SPEED_CONTROLLER:Disconnect() end);_G.__HEARTLESS_SPEED_CONTROLLER=nil end
    destroySpeedObjects()
    speedObjects.lastMethod=nil
end
function refreshHeartlessSpeedController()
    -- Keep the speed controller alive for manual Normal/Carry values.
    startHeartlessSpeedController()
end
local _autoSwitchWasSteal=false
function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local char=LP.Character;if not char then return end
    local h=char:FindFirstChildOfClass("Humanoid");if not h then return end
    local isStealSpeed=h.WalkSpeed<25
    if isStealSpeed==_autoSwitchWasSteal then return end
    _autoSwitchWasSteal=isStealSpeed
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
end
task.spawn(function() while true do task.wait(0.5);updateAutoSwitchSpeed() end end)
function startHoldJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn=RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not root or not hum then return end
        local isJumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump==true)
        if isJumpHeld and root.Velocity.Y<35 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end)
end
function stopHoldJump() if holdInfJumpConn then holdInfJumpConn:Disconnect();holdInfJumpConn=nil end end

-- Blacklist check
task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    while task.wait(10) do -- check every 10s instead of every 3s (less network and CPU usage)
        pcall(function()
            local r=game:HttpGet(BLACKLIST_URL)
            if r and string.find(r,tostring(LP.UserId),1,true) then LP:Kick("You have been removed for cheating | CODE: BAC-1633") end
        end)
    end
end)

-- Undetected Insta Reset
local UNDTECTED_RESET_POS = CFrame.new(2000.5, 9911.9, 4000.2)
local UNDTECTED_RESET_BIND_NAME = "HeartlessUndetectedResetCamera"

local function undetectedInstaReset()
    if instaResetting then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    instaResetting = true
    local cam = workspace.CurrentCamera
    local lockedCamCFrame = cam and cam.CFrame
    if cam and lockedCamCFrame then
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = lockedCamCFrame
    end
    pcall(function() RunService:UnbindFromRenderStep(UNDTECTED_RESET_BIND_NAME) end)
    RunService:BindToRenderStep(UNDTECTED_RESET_BIND_NAME, Enum.RenderPriority.Camera.Value + 1, function()
        if cam and lockedCamCFrame then cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = lockedCamCFrame end
        local activeChar = LP.Character
        local activeHrp = activeChar and activeChar:FindFirstChild("HumanoidRootPart")
        if activeHrp then
            activeHrp.AssemblyLinearVelocity = Vector3.zero
            activeHrp.AssemblyAngularVelocity = Vector3.zero
            activeHrp.CFrame = UNDTECTED_RESET_POS
        end
    end)
    local respawnConn
    respawnConn = LP.CharacterAdded:Connect(function(newChar)
        if respawnConn then respawnConn:Disconnect() end
        pcall(function() RunService:UnbindFromRenderStep(UNDTECTED_RESET_BIND_NAME) end)
        local newHum = newChar:WaitForChild("Humanoid", 5)
        task.wait(0.05)
        if cam and newHum then pcall(function() cam.CameraSubject = newHum; cam.CameraType = Enum.CameraType.Custom end) end
        instaResetting = false
    end)
end

cursedInstaReset = undetectedInstaReset
local KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},InstaReset={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil}}
local AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
Steal={AutoStealEnabled=false,StealRadius=62,StealDuration=0.3,GrabMode="V1",BarStyle="V1",Mode="half",HalfFireRange=10,HalfHoldMin=1.3,HalfHoldMax=2.6,HalfEntryDelay=0.3,Data={}}
isStealing,stealStartTime=false,nil
local stealPaused=false
local Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
local MEDUSA_COOLDOWN=25;batCounterDebounce=false -- global intencional para evitar el límite de 200 registros locales
modeValLbl=nil;lastMoveDir=Vector3.new(0,0,0) -- estados compartidos para liberar registros locales
function isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    local plot=plots:FindFirstChild(plotName);if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end
function isNearPodiumWithPrompt()
    local char=LP.Character;local hrpL=char and char:FindFirstChild("HumanoidRootPart");if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
        local podiums=plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for _,podium in ipairs(podiums:GetChildren()) do
                local base=podium:FindFirstChild("Base")
                if base then
                    local sp=base:FindFirstChild("Spawn")
                    if sp then
                        local d=(hrpL.Position-sp.Position).Magnitude
                        if d<=Steal.StealRadius then
                            local att=sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
                            end
                        end
                    end
                end
            end
        end
        end
    end
    return false,math.huge
end
function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
        local pods=plot:FindFirstChild("AnimalPodiums")
        if pods then
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
        end
    end
    return nearest
end
function promptDistance(prompt)
    local char=LP.Character;if not char then return math.huge end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return math.huge end
    local parent=prompt.Parent
    if parent and parent:IsA("Attachment") then parent=parent.Parent end
    if parent and parent:IsA("BasePart") then return (parent.Position-root.Position).Magnitude end
    local ok,pos=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and pos then return (pos-root.Position).Magnitude end
    return math.huge
end
function getConfiguredStealDuration()
    return math.clamp(tonumber(Steal and Steal.StealDuration) or 0.3,0.05,10)
end
function executeSteal(prompt)
    if isStealing or not prompt or not prompt.Parent then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
            for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
        end
    end
    local data=Steal.Data[prompt];if not data.ready then return end
    data.ready=false;isStealing=true;stealPaused=false;stealStartTime=tick()
    local configuredDuration=getConfiguredStealDuration()
    if Steal.GrabMode=="V1" then
        task.spawn(function()
            for _,fn in ipairs(data.hold) do task.spawn(fn) end
            task.wait(configuredDuration)
            if prompt.Parent then for _,fn in ipairs(data.trigger) do task.spawn(fn) end end
            task.wait(0.05);data.ready=true;isStealing=false;stealPaused=false;stealStartTime=nil
        end)
        return
    end
    task.spawn(function()
        local cycleStart=stealStartTime
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        local pausePoint=configuredDuration*0.75
        local resumedAfterPause=false
        while prompt.Parent and tick()-cycleStart<pausePoint do task.wait() end
        if not prompt.Parent then
            data.ready=true;isStealing=false;stealPaused=false;stealStartTime=nil;return
        end
        -- V2: at 75%, pause for up to 1.3 seconds if the character is not beside the Brainrot.
        if promptDistance(prompt)>Steal.HalfFireRange then
            stealPaused=true
            local pauseStart=tick();local beside=false
            while prompt.Parent and tick()-pauseStart<1.3 do
                if promptDistance(prompt)<=Steal.HalfFireRange then beside=true;break end
                task.wait()
            end
            stealPaused=false
            if not beside then
                data.ready=true;isStealing=false;stealStartTime=nil
                return
            end
            -- The original hold is already active; do not start a second load,
            -- because duplicating it can cause a sudden rise or visual jump.
            resumedAfterPause=true
        end
        if resumedAfterPause then
            local resumeStart=tick()
            while prompt.Parent and tick()-resumeStart<(configuredDuration*0.25) do task.wait() end
        else
            while prompt.Parent and tick()-cycleStart<configuredDuration do task.wait() end
        end
        if prompt.Parent and promptDistance(prompt)<=Steal.HalfFireRange then
            -- The trigger only runs after the resumed load is complete.
            for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        end
        task.wait(0.05);data.ready=true;isStealing=false;stealPaused=false;stealStartTime=nil
    end)
end
startAutoSteal=function()
    if Conns.autoSteal then return end
    local nextScan=0
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local now=os.clock()
        if now<nextScan then return end
        nextScan=now+0.15
        local p=findNearestPrompt();if p then executeSteal(p) end
    end)
end
stopAutoSteal=function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    isStealing=false;stealPaused=false;stealStartTime=nil
end
task.spawn(function()
    while true do
        task.wait(1) -- reduced scan frequency to avoid recurring FPS drops
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                for _,part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide=false end
                end
            end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");local hrp=char:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
        -- Movement is applied once by the ROTX speed controller.
        -- Keep only the last direction for anti-ragdoll visual/state handling.
        local md=hum.MoveDirection
        if md.Magnitude>0 then lastMoveDir=md end
    end
    if speedLabel and speedLabel.Parent then
        -- ROTX modifies only horizontal speed and keeps WalkSpeed at 16.
        -- The indicator must show the active profile, not Humanoid.WalkSpeed.
        local activeSpd=tonumber(getActiveMoveSpeed()) or 0
        local profile=HEARTLESS.speedMode or "Normal"
        speedLabel.Visible=true
        speedLabel.Text=tostring(math.floor(activeSpd+0.5))
    end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5);setupSpeedIndicator(char);setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    -- Keep BAT AIMBOT enabled across character reset/respawn.
    if autoBatEnabled then
        task.spawn(function()
            for i=1,4 do
                task.wait(0.35)
                if not autoBatEnabled then return end
                if LP.Character == char and startBatAimbot then startBatAimbot(); return end
            end
        end)
    end
    -- Keep TP BAT enabled across character reset/respawn.
    if tpBat1Enabled then
        task.spawn(function()
            for i=1,4 do
                task.wait(0.35)
                if not tpBat1Enabled then return end
                if LP.Character == char and startTpBat then startTpBat(); return end
            end
        end)
    end
    if tpBat2Enabled then
        task.spawn(function()
            for i=1,4 do
                task.wait(0.35)
                if not tpBat2Enabled then return end
                if LP.Character==char and startTpBat2 then startTpBat2();return end
            end
        end)
    end
end)
if LP.Character then setupSpeedIndicator(LP.Character);setupRagdollTriggers() end
_autoSide=_autoSide or {al=nil,ar=nil,lp=1,rp=1}
stopAutoLeft=function()
    if _autoSide.al then _autoSide.al:Disconnect();_autoSide.al=nil end;_autoSide.lp=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if _autoSide.ar then _autoSide.ar:Disconnect();_autoSide.ar=nil end;_autoSide.rp=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end
startAutoLeft=function()
    if _autoSide.al then _autoSide.al:Disconnect() end;_autoSide.lp=1
    _autoSide.al=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if _autoSide.lp==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then _autoSide.lp=2;local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif _autoSide.lp==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoLeftEnabled=false;if _autoSide.al then _autoSide.al:Disconnect();_autoSide.al=nil end;_autoSide.lp=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;if saveConfig then pcall(saveConfig) end;return end
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
    if _autoSide.ar then _autoSide.ar:Disconnect() end;_autoSide.rp=1
    _autoSide.ar=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if _autoSide.rp==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then _autoSide.rp=2;local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif _autoSide.rp==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoRightEnabled=false;if _autoSide.ar then _autoSide.ar:Disconnect();_autoSide.ar=nil end;_autoSide.rp=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;if saveConfig then pcall(saveConfig) end;return end
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
-- DROP BRAINROT (K7 implementation: Jump / Stand modes)
_wfConns=_wfConns or {}
runDrop=function()
    if dropActive then return end
    if dropMode=="Jump" then
        local char=LP.Character
        if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        dropActive=true
        local t0=tick()
        local dc
        dc=RunService.Heartbeat:Connect(function()
            local r=char and char:FindFirstChild("HumanoidRootPart")
            if not r then
                dc:Disconnect()
                dropActive=false
                return
            end

            if tick()-t0>=DROP_ASCEND_DURATION then
                dc:Disconnect()
                local rp=RaycastParams.new()
                rp.FilterDescendantsInstances={char}
                rp.FilterType=Enum.RaycastFilterType.Exclude
                local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
                if rr then
                    local hum2=char:FindFirstChildOfClass("Humanoid")
                    local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2)
                    r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
                    r.AssemblyLinearVelocity=Vector3.new(0,0,0)
                end
                dropActive=false
                return
            end

            r.AssemblyLinearVelocity=Vector3.new(
                r.AssemblyLinearVelocity.X,
                DROP_ASCEND_SPEED,
                r.AssemblyLinearVelocity.Z
            )
        end)
    else
        if autoBatEnabled then
            autoBatEnabled=false
            if autoBatSetVisual then autoBatSetVisual(false) end
            stopBatAimbot()
        end

        dropActive=true

        local colConn=RunService.Stepped:Connect(function()
            if not dropActive then return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    for _,part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide=false
                        end
                    end
                end
            end
        end)
        table.insert(_wfConns,colConn)

        local flingThread=coroutine.create(function()
            while dropActive do
                RunService.Heartbeat:Wait()
                local c=LP.Character
                local root=c and c:FindFirstChild("HumanoidRootPart")
                if not root then break end

                local vel=root.Velocity
                root.Velocity=vel*10000+Vector3.new(0,10000,0)

                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity=vel end

                RunService.Stepped:Wait()
                if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
            end
        end)

        table.insert(_wfConns,flingThread)
        coroutine.resume(flingThread)

        task.delay(0.1,function()
            dropActive=false
            for _,c in ipairs(_wfConns) do
                if typeof(c)=="RBXScriptConnection" then
                    c:Disconnect()
                elseif type(c)=="thread" then
                    pcall(coroutine.close,c)
                end
            end
            _wfConns={}
        end)
    end
end
function doTPDown(force)
    local char=LP.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end
runTPFloor=function() pcall(function() doTPDown(true) end) end
STRETCH_NAME="Movee_Stretch"
enableStretchRez=function()
    stretchRezEnabled=true;if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function() RunService:BindToRenderStep(STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end
disableStretchRez=function() stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end) end
defLightBrightness,defLightClock,defLightAmbient = nil,nil,nil
function isProtectedHeartlessLegacySkin4Accessory(obj)
    if not obj then return false end
    local accessory = obj:IsA("Accessory") and obj or obj:FindFirstAncestorOfClass("Accessory")
    if not accessory then return false end
    local name = accessory.Name:lower()
    return name == "heartlessskin4valk" or name == "heartlessskin4horns"
end

function enableAntiLag()
    if antiLagEnabled then return end
    antiLagEnabled=true
    pcall(function() Lighting.GlobalShadows = false end)
    for _, e in ipairs(Lighting:GetDescendants()) do
        pcall(function()
            if e:IsA("PostEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
               e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or
               e:IsA("Atmosphere") or e:IsA("Clouds") then
                e.Enabled = false
            end
        end)
    end
    local function apply7UpAntiLag(obj)
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.CastShadow = false
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or
                   obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                    pcall(function() obj:Destroy() end)
                end
            elseif obj:IsA("SurfaceAppearance") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Model") then
                local n = obj.Name:lower()
                local hasStealPrompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true) ~= nil
                if not hasStealPrompt and (n:find("brainrot",1,true) or n:find("animal",1,true) or n:find("carry",1,true) or
                   n:find("grab",1,true) or n:find("steal",1,true) or n:find("hold",1,true)) then
                    pcall(function() obj:Destroy() end)
                end
            elseif obj:IsA("Animator") and obj.Parent and obj.Parent.Parent ~= LP.Character then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("PostEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or
                   obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or obj:IsA("DepthOfFieldEffect") or
                   obj:IsA("Atmosphere") or obj:IsA("Clouds") then
                obj.Enabled = false
            end
        end)
    end
    local antiLagObjects = workspace:GetDescendants()
    for index, obj in ipairs(antiLagObjects) do
        if not antiLagEnabled then break end
        apply7UpAntiLag(obj)
        if index % 150 == 0 then task.wait() end
    end
    if antiLagConn then antiLagConn:Disconnect() end
    local antiLagPending = {}
    local antiLagFlushQueued = false
    antiLagConn = workspace.DescendantAdded:Connect(function(obj)
        if not antiLagEnabled then return end
        antiLagPending[#antiLagPending + 1] = obj
        if antiLagFlushQueued then return end
        antiLagFlushQueued = true
        task.defer(function()
            antiLagFlushQueued = false
            local pending = antiLagPending
            antiLagPending = {}
            for index, pendingObj in ipairs(pending) do
                if antiLagEnabled and pendingObj and pendingObj.Parent then apply7UpAntiLag(pendingObj) end
                if index % 100 == 0 then task.wait() end
            end
        end)
    end)
end
function disableAntiLag()
    antiLagEnabled = false
    if antiLagConn then antiLagConn:Disconnect(); antiLagConn = nil end
    pcall(function()
        Lighting.GlobalShadows = true
        for _, e in ipairs(Lighting:GetDescendants()) do
            pcall(function()
                if e:IsA("PostEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
                   e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or
                   e:IsA("Atmosphere") or e:IsA("Clouds") then
                    e.Enabled = true
                end
            end)
        end
    end)
end

SATURATION_TAG="HeartlessSaturatedColors"
function clearSaturatedColors()
    if satPulseConn then pcall(function() satPulseConn:Disconnect() end);satPulseConn=nil end
    satColorFx=nil
    pcall(function()
        for _,e in ipairs(Lighting:GetChildren()) do if e:GetAttribute(SATURATION_TAG) then e:Destroy() end end
    end)
end
function enableSaturatedColors()
    clearSaturatedColors();saturatedColorsEnabled=true
    local color=Instance.new("ColorCorrectionEffect")
    color.Name="HeartlessSaturation";color:SetAttribute(SATURATION_TAG,true);color.Saturation=0.6;color.Contrast=0.4;color.Brightness=0.05;color.TintColor=Color3.fromRGB(255,240,220);color.Parent=Lighting;satColorFx=color
    local bloom=Instance.new("BloomEffect");bloom.Name="HeartlessSaturationBloom";bloom:SetAttribute(SATURATION_TAG,true);bloom.Intensity=0.8;bloom.Size=24;bloom.Threshold=1;bloom.Parent=Lighting
    local atmosphere=Instance.new("Atmosphere");atmosphere.Name="HeartlessSaturationAtmosphere";atmosphere:SetAttribute(SATURATION_TAG,true);atmosphere.Density=0.3;atmosphere.Offset=0.25;atmosphere.Color=Color3.fromRGB(199,199,255);atmosphere.Decay=Color3.fromRGB(106,112,125);atmosphere.Glare=0.2;atmosphere.Haze=1;atmosphere.Parent=Lighting
    local sun=Instance.new("SunRaysEffect");sun.Name="HeartlessSaturationSunRays";sun:SetAttribute(SATURATION_TAG,true);sun.Intensity=0.2;sun.Spread=0.8;sun.Parent=Lighting
    local dof=Instance.new("DepthOfFieldEffect");dof.Name="HeartlessSaturationDOF";dof:SetAttribute(SATURATION_TAG,true);dof.FocusDistance=25;dof.InFocusRadius=10;dof.NearIntensity=0.2;dof.FarIntensity=0.4;dof.Parent=Lighting
    satPulseConn=RunService.Heartbeat:Connect(function()
        if saturatedColorsEnabled and satColorFx and satColorFx.Parent then satColorFx.Contrast=0.35+math.sin(tick()*2)*0.05 end
    end)
end
function disableSaturatedColors()
    saturatedColorsEnabled=false;clearSaturatedColors()
end

function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function useMedusaCounter()
    if medusaDebounce then return end;if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if medusaCounterEnabled then useMedusaCounter() end
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
BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
function swingBatForCounter(bat,char)
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
aimbotConn=nil
_predBall=nil
function findBat()
    local char=LP.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end
function getClosestTarget()
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
function swingCurrentBat()
    if not autoSwingEnabled then return end;local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end
function startBatAimbot()
    if aimbotConn then pcall(function() aimbotConn:Disconnect() end); aimbotConn=nil end
    autoBatEnabled = true
    local oldAimbotSwingCooldown = false
    local char0 = LP.Character
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local bat = findBat()
        if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        local target, minDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local ph = p.Character:FindFirstChildOfClass("Humanoid")
                if tr and ph and ph.Health > 0 then
                    local d = (root.Position - tr.Position).Magnitude
                    if d < minDist then minDist=d; target=tr end
                end
            end
        end
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        if direction.Magnitude < 0.01 then return end
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude < 0.01 then return end
        flatDir = flatDir.Unit
        local chaseSpeed = math.clamp(tonumber(AUTO_BAT_SPEED) or 60, 1, 500)
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(Vector3.new(flatDir.X*chaseSpeed, yVel, flatDir.Z*chaseSpeed), 0.8)
        local predictedPos = targetPos + targetVel * math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(rx,-2.5,2.5)*42, math.clamp(ry,-2.5,2.5)*42, math.clamp(rz,-2.5,2.5)*42))
        end
        if autoSwingEnabled and bat and not oldAimbotSwingCooldown then
            oldAimbotSwingCooldown = true
            pcall(function() bat:Activate() end)
            task.delay(0.08, function() oldAimbotSwingCooldown=false end)
        end
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then pcall(function() aimbotConn:Disconnect() end);aimbotConn=nil end
    autoBatEnabled=false
    _autoBatEquippedThisRun=false
    _autoBatTarget=nil
    if _predBall then pcall(function() _predBall:Destroy() end);_predBall=nil end
    local char=LP.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate=true end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
queueAutoBatStart=function()
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end

tpBat1Conn = nil
tpBat2Conn = nil

-- TP BAT 1: Vision TP Bat fijo (8 studs y cooldown de 0.08 s).
startTpBat = function()
    if tpBat1Conn then pcall(function() tpBat1Conn:Disconnect() end); tpBat1Conn=nil end
    if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
    tpBat1Enabled = true
    local tpCooldown = false
    tpBat1Conn = RunService.Heartbeat:Connect(function()
        if not (tpBat1Enabled and LP.Character and LP.Character.Parent) then return end
        local char = LP.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local target, minDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    local d=(root.Position-tr.Position).Magnitude
                    if d < minDist then minDist=d; target=tr end
                end
            end
        end
        if not target then return end

        local bat=char:FindFirstChild("Bat")
        if not bat then
            local bp=LP:FindFirstChild("Backpack")
            bat=bp and bp:FindFirstChild("Bat")
            if bat then bat.Parent=char end
        end
        if sethiddenproperty then
            pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",target) end)
        end
        local targetPos=target.Position+Vector3.new(0,0.9,0)
        if (root.Position-targetPos).Magnitude>8 then
            root.CFrame=CFrame.new(targetPos)
        end
        local cam=workspace.CurrentCamera
        if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,target.Position) end

        if not tpCooldown then
            tpCooldown=true
            pcall(function()
                local currentBat=char:FindFirstChild("Bat")
                if currentBat then
                    currentBat:Activate()
                    local ev=currentBat:FindFirstChildWhichIsA("RemoteEvent")
                    if ev then ev:FireServer() end
                end
            end)
            task.delay(0.08,function() tpCooldown=false end)
        end
    end)
    if tpBat1SetVisual then tpBat1SetVisual(true) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(true) end
end
stopTpBat = function()
    if tpBat1Conn then tpBat1Conn:Disconnect();tpBat1Conn=nil end
    tpBat1Enabled=false
    local char=LP.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then
        if sethiddenproperty then pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",nil) end) end
        root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
    end
    local hum2=char and char:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate=true end
    if tpBat1SetVisual then tpBat1SetVisual(false) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
end

-- TP BAT 2: implementation transferred from Cleannigga.txt.
startTpBat2 = function() startTpBat() end
stopTpBat2 = function() stopTpBat() end
function getTpBatModeLabel() return "TP Bat" end
function startSelectedTpBat()
    if tpBatMode=="Clean" then startTpBat2() else startTpBat() end
end
function stopSelectedTpBat()
    stopTpBat();stopTpBat2()
end

local function captureConfigProfile()
    return {
        tpBatStuds=math.clamp(tonumber(TP_BAT_STUDS) or 6,3,12),
        tpBatInterval=math.clamp(tonumber(TP_BAT_SWING_INTERVAL) or 0.12,0.10,0.30),
        autoSwing=autoSwingEnabled,
        aimbotSpeed=math.clamp(tonumber(AUTO_BAT_SPEED) or 60,1,500),
        normalSpeed=NS,
        carrySpeed=CS,
        speedMode=HEARTLESS.speedMode,
    }
end
local function applyConfigProfile(name)
    local profile=savedProfiles[name]
    if type(profile)~="table" then
        profile=(name=="Legit") and {tpBatStuds=8,tpBatInterval=0.18,autoSwing=true,aimbotSpeed=50,normalSpeed=60,carrySpeed=30,speedMode="Normal"}
            or {tpBatStuds=6,tpBatInterval=0.12,autoSwing=true,aimbotSpeed=60,normalSpeed=60,carrySpeed=30,speedMode="Normal"}
    end
    TP_BAT_STUDS=math.clamp(tonumber(profile.tpBatStuds) or 6,3,12)
    TP_BAT_SWING_INTERVAL=math.clamp(tonumber(profile.tpBatInterval) or 0.12,0.10,0.30)
    if type(profile.autoSwing)=="boolean" then autoSwingEnabled=profile.autoSwing end
    AUTO_BAT_SPEED=math.clamp(tonumber(profile.aimbotSpeed) or AUTO_BAT_SPEED,1,500)
    NS=math.clamp(tonumber(profile.normalSpeed) or NS,1,200)
    CS=math.clamp(tonumber(profile.carrySpeed) or CS,1,200)
    if profile.speedMode=="Normal" or profile.speedMode=="Lagger" or profile.speedMode=="Custom" then HEARTLESS.speedMode=profile.speedMode end
    activeProfile=name
    saveConfig()
end
local function saveConfigProfile(name)
    if name~="Legit" and name~="Balanced" then return end
    savedProfiles[name]=captureConfigProfile()
    activeProfile=name
    saveConfig()
end

saveConfig=function()
    function ks(e)
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
    local cfg={normalSpeed=NS,carrySpeed=CS,manualCarrySpeed=speedCarryActive,modeCarry=modeCarry,dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,grabMode=Steal.GrabMode,stealBarStyle=Steal.BarStyle,halfFireRange=Steal.HalfFireRange,halfHoldMin=Steal.HalfHoldMin,halfHoldMax=Steal.HalfHoldMax,halfEntryDelay=Steal.HalfEntryDelay,heartlessSkinEnabled=heartlessSkinEnabled,skinMode=skinMode,hideHeadEnabled=hideHeadEnabled,rightLegHiddenEnabled=rightLegHiddenEnabled,blackSmokeEnabled=blackSmokeEnabled,smokeColor=smokeColor,crownEnabled=crownEnabled,crownStyle=crownStyle,antiRagdoll=antiRagdollEnabled, antiRagdollMode=antiRagdollMode,autoStealEnabled=Steal.AutoStealEnabled,autoLeftEnabled=autoLeftEnabled,autoRightEnabled=autoRightEnabled,autoBatEnabled=autoBatEnabled,infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,laggerModeEnabled=laggerModeEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,autoBat=autoBatEnabled,aimbotSpeed=AUTO_BAT_SPEED,tpBatStuds=TP_BAT_STUDS,tpBatInterval=TP_BAT_SWING_INTERVAL,activeProfile=activeProfile,configProfiles=savedProfiles,tpBat1Enabled=tpBat1Enabled,tpBat2Enabled=tpBat2Enabled,tpBatMode=tpBatMode,autoSwing=autoSwingEnabled,unwalkEnabled=unwalkEnabled,antiLag=antiLagEnabled,saturatedColors=saturatedColorsEnabled,stretchRez=stretchRezEnabled,
        tabPosition=tabPosition, menuWidth=menuWidth, menuHeight=menuHeight, mobileButtonWidth=mobileButtonWidth, mobileButtonHeight=mobileButtonHeight, mobileButtonOutline=mobileButtonOutline, buttonStyle=buttonStyle, mobileTextSize=mobileTextSize,
        dropMode=dropMode,
        customSpeedNorm=HEARTLESS.customSpeedNorm, customSpeedSteal=HEARTLESS.customSpeedSteal,
        speedMode=HEARTLESS.speedMode, themeName=themeName, lineESPEnabled=lineESPEnabled,
        speedMethod=speedMethod,autoSwitchSpeed=autoSwitchSpeedEnabled,mobileButtonsEnabled=mobileButtonsEnabled,mobileButtonsVisible=mobileButtonsVisible,mobileButtonsSize=mobileButtonsSize,circleButtonsEnabled=circleButtonsEnabled,guiTransparencyEnabled=guiTransparencyEnabled,mobileButtonsLocked=mobileButtonsLocked,mobBtnTransparencyEnabled=mobBtnTransparencyEnabled,perButtonDragEnabled=perButtonDragEnabled,uiLocked=uiLocked,animEnabled=animEnabled,animPack=animPackName,skyTheme=currentSkyTheme,
        keys=(function() if not _GuiKeys then return {} end;local t={};for k,v in pairs(_GuiKeys) do t[k]=v.Name end;return t end)()}
    if writefile then pcall(function() writefile("Spectrum_PC.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
function resetAllSettings()
    NS=60;CS=30;speedCarryActive=false;rightLegHiddenEnabled=false;blackSmokeEnabled=false;smokeColor="Black";crownEnabled=true;crownStyle="White";skinMode="Skin1";LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5;laggerModeEnabled=false
    HEARTLESS.speedMode="Normal";HEARTLESS.customSpeedNorm=66;HEARTLESS.customSpeedSteal=34;stopHeartlessSpeedController()
    autoSwitchSpeedEnabled=false;antiRagdollEnabled=false; antiRagdollMode="Splatter";infJumpEnabled=false;infJumpMode="manual"
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;AUTO_BAT_SPEED=60;tpBat1Enabled=false;tpBat2Enabled=false;tpBatMode="Original";autoSwingEnabled=true;autoMoveSwingEnabled=false;lineESPEnabled=false
    antiLagEnabled=false;saturatedColorsEnabled=false;stretchRezEnabled=false
    setHeartlessSkinEnabled(false, true)
    Steal.AutoStealEnabled=false;Steal.StealRadius=62;Steal.StealDuration=0.3;Steal.GrabMode="V1";Steal.BarStyle="V1"
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsVisible=true;mobileButtonsSize=80
    circleButtonsEnabled=false;uiLocked=false;fovValue=80;fovIndex=1
    themeName="Black";themeIndex=1
    tabPosition="Left"; mobileButtonWidth=60; mobileButtonHeight=60; mobileButtonOutline=2; menuWidth=265; menuHeight=350; buttonStyle="Cubes"; mobileTextSize=12.5
    dropMode="Jump"
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil};KB.TpBat1={kb=nil,gp=nil};KB.TpBat2={kb=nil,gp=nil};KB.InstaReset={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
    stopBatAimbot();stopTpBat();stopTpBat2();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopHoldJump()
    if stretchRezEnabled then disableStretchRez() end;if antiLagEnabled then disableAntiLag() end;saveConfig()
    rebuildGUILayout()
    buildMobileButtons()
end
-- Only visual setters that receive assignments and are used later are retained.
setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual = nil,nil,nil,nil
-- Removed unused legacy UI variables to reduce local register usage.
_persistentConns={}
function trackConn(conn) table.insert(_persistentConns,conn);return conn end
function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then modeValLbl.Text=laggerModeEnabled and "Lagger Mode" or (speedCarryActive and "Carry" or "Normal") end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local WHITE=Color3.fromRGB(255,255,255);local OFF=Color3.fromRGB(46,24,38);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
end
_prevCarryBeforeLagger = false
toggleLaggerMode=function()
    laggerModeEnabled=not laggerModeEnabled
    refreshSpeedModeLabel()
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end
function setManualCarrySpeed(on, silent)
    speedCarryActive=(on==true)
    local activeProfile=HEARTLESS.speedMode or "Normal"
    modeCarry[activeProfile]=speedCarryActive
    if mobBtnRefs.carrySpeed then pcall(mobBtnRefs.carrySpeed, speedCarryActive) end
    if HEARTLESS.carryVisualSetter then pcall(HEARTLESS.carryVisualSetter, speedCarryActive) end
    if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
    if HEARTLESS.speedConn then stopHeartlessSpeedController() end
    startHeartlessSpeedController()
    if HEARTLESS.statusLabel then pcall(updateHeartlessSpeedStatus) end
    if not silent then saveConfig() end
end
function toggleCarryMode()
    local activeProfile=HEARTLESS.speedMode or "Normal"
    setManualCarrySpeed(not (modeCarry[activeProfile]==true))
end
function speedToggleAction()
    toggleCarryMode()
end

function forceNoSplatterReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
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

        workspace.CurrentCamera.CameraSubject = hum

        local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

startAntiRagdoll=function()
    if Conns.antiRag then return end
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                          state == Enum.HumanoidStateType.Ragdoll or
                          state == Enum.HumanoidStateType.FallingDown)

        if antiRagdollMode == "No Splatter" then
            if ragdolled then
                local now = tick()
                if now - antiRagdollNoSplatterCooldown > 0.4 then -- longer cooldown: fewer calls to forceNoSplatterReset (GetDescendants + require are expensive)
                    antiRagdollNoSplatterCooldown = now
                    forceNoSplatterReset()
                end
            end
            return
        end

        if not root then return end
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            pcall(function()
                LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            -- One GetDescendants() pass instead of two (lower CPU usage)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                elseif d:IsA("Motor6D") and d.Enabled == false then
                    d.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end
stopAntiRagdoll=function() if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end end
startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end

-- STEAL BAR
function createStealBar()
    local barStyle=Steal.BarStyle=="V2" and "V2" or "V1"
    for _,n in ipairs({"MoveeStealBar"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    local WHITE=Color3.fromRGB(255,255,255)
    local BARBG=Color3.fromRGB(0,0,0)
    local themeAccent=THEME_COLORS[themeName] or Color3.fromRGB(70,145,255)
    local lightAccent=themeAccent:Lerp(WHITE,0.62)
    -- V1: barra amplia y estética. V2: versión compacta y clara.
    local SB_W,SB_H=(barStyle=="V2" and 300 or 330),(barStyle=="V2" and 42 or 38)
    local stealGui=Instance.new("ScreenGui");stealGui.Name="MoveeStealBar";stealGui.ResetOnSpawn=false;stealGui.IgnoreGuiInset=true;stealGui.DisplayOrder=8
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    if not pcall(function() stealGui.Parent=game:GetService("CoreGui") end) then stealGui.Parent=LP:WaitForChild("PlayerGui") end
    stealBarFrame=Instance.new("Frame",stealGui)
    stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H);stealBarFrame.Position=UDim2.new(0.5,-SB_W/2,0.06,0)
    stealBarFrame.BackgroundColor3=(barStyle=="V2" and lightAccent:Lerp(WHITE,0.58) or themeAccent:Lerp(Color3.fromRGB(18,12,28),0.78));stealBarFrame.BackgroundTransparency=(barStyle=="V2" and 0.04 or 0.08);stealBarFrame.BorderSizePixel=0;stealBarFrame.ZIndex=20;stealBarFrame.ClipsDescendants=true
    Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(0,barStyle=="V2" and 12 or 18)
    local sbStroke=Instance.new("UIStroke",stealBarFrame);sbStroke.Color=(barStyle=="V2" and lightAccent or themeAccent);sbStroke.Thickness=(barStyle=="V2" and 1 or 1.5);sbStroke.Transparency=(barStyle=="V2" and 0.18 or 0.08)
    task.spawn(function()
        local t=0
        while sbStroke and sbStroke.Parent do
            t=t+0.05
            sbStroke.Transparency=(barStyle=="V2" and 0.18 or 0.08)
            sbStroke.Color=(barStyle=="V2" and lightAccent or themeAccent)
            task.wait(0.04)
        end
    end)
    local fillLine=Instance.new("Frame",stealBarFrame);fillLine.Size=UDim2.new(0,0,1,0)
    fillLine.BackgroundColor3=(barStyle=="V2" and lightAccent or themeAccent);fillLine.BackgroundTransparency=(barStyle=="V2" and 0.08 or 0.08);fillLine.BorderSizePixel=0;fillLine.ZIndex=21
    Instance.new("UICorner",fillLine).CornerRadius=UDim.new(0,barStyle=="V2" and 12 or 18)
    local fillGrad=Instance.new("UIGradient",fillLine)
    fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,themeAccent:Lerp(WHITE,0.18)),ColorSequenceKeypoint.new(0.5,themeAccent:Lerp(WHITE,0.52)),ColorSequenceKeypoint.new(1,themeAccent:Lerp(WHITE,0.28))})
    local stealSection=Instance.new("Frame",stealBarFrame)
    stealSection.Size=UDim2.new(0,(barStyle=="V2" and 78 or 118),1,0);stealSection.Position=UDim2.new(0,8,0,0)
    stealSection.BackgroundTransparency=1;stealSection.ZIndex=25
    local stealLbl=Instance.new("TextLabel",stealSection)
    stealLbl.Size=UDim2.new(0,(barStyle=="V2" and 64 or 62),0,(barStyle=="V2" and 18 or SB_H));stealLbl.Position=UDim2.new(0,(barStyle=="V2" and 7 or 0),0,(barStyle=="V2" and 2 or 0))
    stealLbl.BackgroundTransparency=1;stealLbl.Text=(barStyle=="V2" and "STEAL" or "STEAL")
    stealLbl.TextColor3=(barStyle=="V2" and themeAccent:Lerp(Color3.fromRGB(25,35,55),0.55) or themeAccent:Lerp(WHITE,0.28));stealLbl.Font=Enum.Font.GothamBlack;stealLbl.TextSize=(barStyle=="V2" and 12 or 13)
    stealLbl.TextXAlignment=Enum.TextXAlignment.Left;stealLbl.ZIndex=26
    local pctLbl=Instance.new("TextLabel",stealSection)
    pctLbl.Size=UDim2.new(0,(barStyle=="V2" and 58 or 74),0,(barStyle=="V2" and 18 or SB_H));pctLbl.Position=UDim2.new(0,(barStyle=="V2" and 7 or 70),0,(barStyle=="V2" and 20 or 0))
    pctLbl.BackgroundTransparency=1;pctLbl.Text="0%"
    pctLbl.TextColor3=(barStyle=="V2" and themeAccent:Lerp(Color3.fromRGB(45,55,75),0.55) or themeAccent:Lerp(WHITE,0.4));pctLbl.Font=Enum.Font.GothamBlack;pctLbl.TextSize=(barStyle=="V2" and 12 or 11)
    pctLbl.TextXAlignment=Enum.TextXAlignment.Left;pctLbl.ZIndex=26
    local div1=Instance.new("Frame",stealBarFrame);div1.Size=UDim2.new(0,1,0,SB_H*0.55);div1.Position=UDim2.new(0,(barStyle=="V2" and 78 or 146),0.5,-(SB_H*0.275))
    div1.BackgroundColor3=(barStyle=="V2" and themeAccent:Lerp(WHITE,0.45) or themeAccent);div1.BackgroundTransparency=0.35;div1.BorderSizePixel=0;div1.ZIndex=25
    local fpsLbl=Instance.new("TextLabel",stealBarFrame)
    fpsLbl.Size=UDim2.new(0,(barStyle=="V2" and 82 or 68),1,0);fpsLbl.Position=UDim2.new(0,(barStyle=="V2" and 88 or 154),0,0)
    fpsLbl.BackgroundTransparency=1;fpsLbl.Text=(barStyle=="V2" and "FPS--" or "FPS: --")
    fpsLbl.TextColor3=(barStyle=="V2" and themeAccent:Lerp(Color3.fromRGB(45,55,75),0.6) or themeAccent:Lerp(WHITE,0.45));fpsLbl.Font=Enum.Font.GothamBold;fpsLbl.TextSize=(barStyle=="V2" and 9 or 10)
    fpsLbl.TextXAlignment=Enum.TextXAlignment.Left;fpsLbl.ZIndex=26
    task.spawn(function()
        local frames=0;local t0=tick()
        while fpsLbl and fpsLbl.Parent do
            frames=frames+1;local now=tick()
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5)
                fpsLbl.Text=(barStyle=="V2" and "FPS"..tostring(fps) or "FPS: "..tostring(fps))
                frames=0;t0=now
            end
            task.wait()
        end
    end)
    local div2=Instance.new("Frame",stealBarFrame);div2.Size=UDim2.new(0,1,0,SB_H*0.55);div2.Position=UDim2.new(0,(barStyle=="V2" and 176 or 226),0.5,-(SB_H*0.275))
    div2.BackgroundColor3=(barStyle=="V2" and themeAccent:Lerp(WHITE,0.45) or themeAccent);div2.BackgroundTransparency=0.35;div2.BorderSizePixel=0;div2.ZIndex=25
    local pingLbl=Instance.new("TextLabel",stealBarFrame)
    pingLbl.Size=UDim2.new(0,(barStyle=="V2" and 112 or 82),1,0);pingLbl.Position=UDim2.new(0,(barStyle=="V2" and 186 or 236),0,0)
    pingLbl.BackgroundTransparency=1;pingLbl.Text=(barStyle=="V2" and "PING--ms" or "PING: --")
    pingLbl.TextColor3=(barStyle=="V2" and themeAccent:Lerp(Color3.fromRGB(45,55,75),0.6) or themeAccent:Lerp(WHITE,0.45));pingLbl.Font=Enum.Font.GothamBold;pingLbl.TextSize=(barStyle=="V2" and 9 or 10)
    pingLbl.TextXAlignment=Enum.TextXAlignment.Left;pingLbl.ZIndex=26
    task.spawn(function()
        while pingLbl and pingLbl.Parent do
            pcall(function()
                local ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                local pingColor
                if ping<80 then pingColor=Color3.fromRGB(155,235,190)
                elseif ping<150 then pingColor=Color3.fromRGB(255,220,155)
                else pingColor=Color3.fromRGB(255,170,190) end
                pingLbl.Text=(barStyle=="V2" and "PING"..tostring(ping).."ms" or "PING: "..tostring(ping).."ms")
                pingLbl.TextColor3=pingColor
            end)
            task.wait(1)
        end
    end)
    task.spawn(function()
        while fillLine and fillLine.Parent do
            local now=tick()
            if Steal.AutoStealEnabled then
                local inRadius=isNearPodiumWithPrompt()
                local pct=0
                if isStealing and stealStartTime then
                    pct=math.clamp((now-stealStartTime)/math.max(getConfiguredStealDuration(),0.01),0,1)
                    if stealPaused then
                        pct=0.75;fillLine.Size=UDim2.new(pct,0,1,0)
                        pctLbl.Text="75%";pctLbl.TextColor3=themeAccent:Lerp(WHITE,0.4)
                    else
                        fillLine.Size=UDim2.new(pct,0,1,0);fillGrad.Offset=Vector2.new(0,0)
                        if pct>=0.75 then
                            pctLbl.Text=math.floor(pct*100).."%";pctLbl.TextColor3=themeAccent:Lerp(WHITE,0.55)
                        else
                            pctLbl.Text=math.floor(pct*100).."%";pctLbl.TextColor3=themeAccent:Lerp(WHITE,0.4)
                        end
                    end
                elseif inRadius then
                    pct=1;fillLine.Size=UDim2.new(1,0,1,0);fillGrad.Offset=Vector2.new(0,0)
                    pctLbl.Text="100%";pctLbl.TextColor3=themeAccent:Lerp(WHITE,0.55)
                else
                    fillLine.Size=UDim2.new(0,0,1,0);pctLbl.Text="0%";pctLbl.TextColor3=themeAccent:Lerp(WHITE,0.3)
                end
            else
                fillLine.Size=UDim2.new(0,0,1,0);pctLbl.Text="0%";pctLbl.TextColor3=themeAccent:Lerp(WHITE,0.3)
            end
            task.wait(0.1)
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
createStealBar()

-- MOBILE BUTTONS
-- Centralized visibility setter: hiding/showing does not destroy the buttons.
function setMobileButtonsVisible(visible)
    mobileButtonsVisible = (visible == true)
    local group = mobGuiRef and mobGuiRef:FindFirstChild("MobileButtons")
    if group then
        group.Visible = mobileButtonsVisible
    elseif mobileButtonsVisible and not mobileButtonsBuildBusy then
        task.defer(function()
            if not mobGuiRef or not mobGuiRef.Parent then buildMobileButtons() end
            local rebuilt = mobGuiRef and mobGuiRef:FindFirstChild("MobileButtons")
            if rebuilt then rebuilt.Visible = true end
        end)
    end
end

function destroyMobileButtons()
    for i,conn in ipairs(mobileInputConns) do pcall(function() conn:Disconnect() end);mobileInputConns[i]=nil end
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"SpectrumMobileButtons","MoveeMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
-- Restores the mobile controls to their default positions and rebuilds them.
-- This also removes stale/off-screen coordinates saved by older versions.
function resetMobileButtons()
    if delfile and isfile and isfile(MOB_POS_FILE) then
        pcall(function() delfile(MOB_POS_FILE) end)
    end
    if writefile then
        pcall(function() writefile(MOB_POS_FILE, HS:JSONEncode({})) end)
    end
    if mobGuiRef then
        pcall(function() mobGuiRef:Destroy() end)
        mobGuiRef = nil
    end
    mobBtnRefs = {}
    for i = #mobileInputConns, 1, -1 do
        local conn = mobileInputConns[i]
        if conn then pcall(function() conn:Disconnect() end) end
        mobileInputConns[i] = nil
    end
    mobileButtonsEnabled = true
    mobileButtonsVisible = true
    buildMobileButtons()
    if saveConfig then pcall(saveConfig) end
end

mobileButtonsBuildBusy = false
function resetAutoLeftDropControls()
    -- Reset only the two requested features and their visual references.
    autoLeftEnabled = false
    _alSwingDebounce = false
    if stopAutoLeft then pcall(stopAutoLeft) end
    dropActive = false
    for i = #_wfConns, 1, -1 do
        local conn = _wfConns[i]
        if typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        elseif type(conn) == "thread" then
            pcall(coroutine.close, conn)
        end
        _wfConns[i] = nil
    end
    if autoLeftSetVisual then pcall(autoLeftSetVisual, false) end
    if mobBtnRefs.autoLeft then pcall(mobBtnRefs.autoLeft, false) end
    if mobBtnRefs.drop then pcall(mobBtnRefs.drop, false) end
    if buildMobileButtons then pcall(buildMobileButtons) end
    if saveConfig then pcall(saveConfig) end
end

function buildMobileButtons()
    if mobileButtonsBuildBusy then return end
    mobileButtonsBuildBusy = true
    destroyMobileButtons()
    -- Always create the floating controls requested by the user, even if an
    -- older saved configuration had mobile buttons disabled.
    mobileButtonsEnabled = true
    -- Some mobile clients report TouchEnabled/KeyboardEnabled late or inconsistently.
    -- Do not use that flag to disable the GUI; the safe right-center layout works
    -- on phones and desktop clients alike.
    HEARTLESS_IS_MOBILE = true

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "SpectrumMobileButtons"; mobGui.ResetOnSpawn = false; mobGui.DisplayOrder = 9998; mobGui.IgnoreGuiInset = true
    mobGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    mobGui.Enabled = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    local coreGui = game:GetService("CoreGui")
    local parented = pcall(function() mobGui.Parent = coreGui end) and mobGui.Parent ~= nil
    if not parented then
        local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
        if playerGui then
            pcall(function() mobGui.Parent = playerGui end)
            parented = mobGui.Parent ~= nil
        end
    end
    if not parented then
        mobGui:Destroy()
        mobileButtonsBuildBusy = false
        return
    end
    mobGuiRef = mobGui

    local savedPos = loadBtnPositions()
    -- Bless-style mobile button dimensions.
    local QS_W = math.max(30, mobileButtonWidth or 49)
    local QS_H = math.max(30, mobileButtonHeight or 49)
    local QG = 10
    local QR = (buttonStyle == "Circular") and math.min(QS_W, QS_H)/2 or 14
    local OUTLINE = math.max(0, mobileButtonOutline or 2)
    local TEXT_SIZE = math.max(8, mobileTextSize or 12.5)

    -- Bless visual palette.
    local Q_OFF        = Color3.fromRGB(0,0,0)
    local Q_ON         = Color3.fromRGB(0,0,0)
    local Q_BORDER     = Color3.fromRGB(55,55,55)
    local Q_BORDER_ON  = Color3.fromRGB(238, 225, 255)
    local Q_TEXT       = Color3.fromRGB(255,255,255)
    local Q_TEXT_ON    = Color3.fromRGB(255,255,255)

    local QW = QS_W * 2 + QG
    -- The nine buttons occupy five rows. Keep the group centered vertically
    -- on the right side instead of reusing old top/off-screen positions.
    local QH = QS_H * 5 + QG * 4
    local mbGroup = Instance.new("Frame", mobGui)
    mbGroup.Name = "MobileButtons"
    mbGroup.AnchorPoint = Vector2.new(1, 0.5)
    mbGroup.Size = UDim2.new(0, QW + 20, 0, QH + 20)
    mbGroup.Position = UDim2.new(1, -18, 0.5, 0)
    mbGroup.BackgroundTransparency = 1
    mbGroup.BorderSizePixel = 0
    mbGroup.Active = false
    mbGroup.ZIndex = 100
    -- Keep the group visible; the saved Hide Buttons setting remains respected
    -- by the final visibility sync below.
    mbGroup.Visible = mobileButtonsVisible ~= false

    function makeMobileBtn(label, col, rowN, isToggle, onAction)
        local relX = 10 + col * (QS_W + QG)
        local relY = 10 + rowN * (QS_H + QG)

        local frame = Instance.new("Frame", mbGroup)
        frame.Size = UDim2.new(0, QS_W, 0, QS_H)
        local posData = savedPos[label]
        -- Ignore legacy positions that would place a button outside the group.
        -- The group itself is anchored to the right edge, so button coordinates
        -- must remain inside its current bounds to be visible on every device.
        local posX = posData and tonumber(posData.xo) or relX
        local posY = posData and tonumber(posData.yo) or relY
        local maxX = math.max(10, QW - QS_W - 10)
        local maxY = math.max(10, QH - QS_H - 10)
        if not posData or (posData.xs or 0) ~= 0 or (posData.ys or 0) ~= 0 then
            posX, posY = relX, relY
        end
        posX = math.clamp(posX, 10, maxX)
        posY = math.clamp(posY, 10, maxY)
        frame.Position = UDim2.new(0, posX, 0, posY)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.Active = true
        frame.Selectable = false
        frame.ZIndex = 102
        frame.Visible = true
        frame.Name = "SBtn_" .. label
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, QR)

        local buttonImage = Instance.new("ImageLabel", frame)
        buttonImage.Name = "ButtonImage"
        buttonImage.Size = UDim2.new(1, 0, 1, 0)
        buttonImage.Position = UDim2.new(0, 0, 0, 0)
        buttonImage.BackgroundTransparency = 1
        -- Imagen de los botones flotantes
        local FLOATING_BUTTON_IMAGE = "rbxthumb://type=Asset&id=7004973094&w=420&h=420"
        buttonImage.Image = FLOATING_BUTTON_IMAGE
        buttonImage.Visible = true
        buttonImage.ImageColor3 = Color3.new(1, 1, 1)
        buttonImage.ImageTransparency = 0
        buttonImage.ScaleType = Enum.ScaleType.Crop
        buttonImage.ResampleMode = Enum.ResamplerMode.Default
        -- La imagen queda detrás del texto para que las letras sigan visibles.
        buttonImage.ZIndex = 102
        Instance.new("UICorner", buttonImage).CornerRadius = UDim.new(0, QR)

        -- Aura alrededor del botón flotante
        local auraOuter = Instance.new("UIStroke", frame)
        auraOuter.Name = "AuraOuter"
        auraOuter.Color = Color3.fromRGB(170, 70, 255)
        auraOuter.Thickness = 8
        auraOuter.Transparency = 0.58
        auraOuter.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local auraInner = Instance.new("UIStroke", frame)
        auraInner.Name = "AuraInner"
        auraInner.Color = Color3.fromRGB(170, 70, 255)
        auraInner.Thickness = 5
        auraInner.Transparency = 0.42
        auraInner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Q_BORDER
        stroke.Thickness = OUTLINE
        stroke.Transparency = 0.8
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = label
        btn.TextColor3 = Q_TEXT
        btn.TextStrokeTransparency = 1
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = TEXT_SIZE
        btn.TextScaled = true
        local btnLimit=Instance.new("UITextSizeConstraint",btn); btnLimit.MinTextSize=8; btnLimit.MaxTextSize=TEXT_SIZE
        btn.TextWrapped = true
        btn.LineHeight = 1.2
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.ZIndex = 103
        btn.Visible = true

        local isOn = false
        local function setter(s)
            isOn = s
            TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundColor3 = s and Q_ON or Q_OFF, BackgroundTransparency = 1}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Color = s and Q_BORDER_ON or Q_BORDER, Transparency = s and 0.2 or 0.8}):Play()
            btn.TextColor3 = s and Q_TEXT_ON or Q_TEXT
        end

        -- Bless-style hover feedback for mouse and touch-compatible UI.
        frame.MouseEnter:Connect(function()
            if not isOn then
                TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundColor3 = Q_ON}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.1), {Color = Q_BORDER_ON, Transparency = 0.2}):Play()
                btn.TextColor3 = Q_TEXT_ON
            end
        end)
        frame.MouseLeave:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundColor3 = isOn and Q_ON or Q_OFF}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.1), {Color = isOn and Q_BORDER_ON or Q_BORDER, Transparency = isOn and 0.2 or 0.8}):Play()
            btn.TextColor3 = isOn and Q_TEXT_ON or Q_TEXT
        end)

        local lastClick=0
        local suppressClick=false
        local function onActivated()
            if suppressClick then suppressClick=false;return end
            local now=os.clock()
            if now-lastClick<0.22 then return end
            lastClick=now
            if isToggle then
                isOn = not isOn
                TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundColor3 = isOn and Q_ON or Q_OFF, BackgroundTransparency = 1}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.15), {Color = isOn and Q_BORDER_ON or Q_BORDER, Transparency = isOn and 0.2 or 0.8}):Play()
                btn.TextColor3 = isOn and Q_TEXT_ON or Q_TEXT
                if onAction then onAction(isOn) end
            else
                TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundColor3 = Q_ON, BackgroundTransparency = 1}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.1), {Color = Q_BORDER_ON, Transparency = 0.2}):Play()
                btn.TextColor3 = Q_TEXT_ON
                task.delay(0.25, function()
                    TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Q_OFF, BackgroundTransparency = 1}):Play()
                    TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Q_BORDER, Transparency = 0.8}):Play()
                    btn.TextColor3 = Q_TEXT
                end)
                if onAction then onAction() end
            end
        end
        btn.Activated:Connect(onActivated)

        local _dn, _sp, _fp, _li, _wd = false, nil, nil, nil, false
        table.insert(mobileInputConns, btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                _dn = true; _wd = false; _sp = i.Position; _fp = frame.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then _dn = false end end)
            end
        end))
        table.insert(mobileInputConns, btn.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then _li = i end
        end))
        table.insert(mobileInputConns, UIS.InputChanged:Connect(function(i)
            if i == _li and _dn and _sp and _fp then
                if uiLocked then return end
                local dx = i.Position.X - _sp.X; local dy = i.Position.Y - _sp.Y
                if math.abs(dx) > 6 or math.abs(dy) > 6 then
                    _wd = true
                    frame.Position = UDim2.new(_fp.X.Scale, _fp.X.Offset + dx, _fp.Y.Scale, _fp.Y.Offset + dy)
                end
            end
        end))
        table.insert(mobileInputConns, UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if _dn then
                    if _wd then pcall(saveBtnPositions);suppressClick=true end
                    _dn=false;_wd=false;_sp=nil;_fp=nil;_li=nil
                end
            end
        end))

        return frame, setter
    end

    local frameDrop, refDrop = makeMobileBtn("DROP\nBRAINROT", 0, 0, false, runDrop)
    frameDrop.Visible = true
    mobBtnRefs["drop"] = refDrop
    local frameAutoLeft, refAutoLeft = makeMobileBtn("AUTO\nLEFT", 1, 0, true, function(on)
        if on then
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled = true; startAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(true) end
        else
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
        end
        saveConfig()
    end)
    mobBtnRefs["autoLeft"] = refAutoLeft
    frameAutoLeft.Visible = true
    if mbGroup.Visible == false and mobileButtonsVisible ~= false then mbGroup.Visible = true end
    local _, refAutoBat = makeMobileBtn("BAT\nAIMBOT", 0, 1, true, function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart()
            if autoBatSetVisual then autoBatSetVisual(true) end
        else
            stopBatAimbot()
            if autoBatSetVisual then autoBatSetVisual(false) end
        end
        saveConfig()
    end)
    mobBtnRefs["autoBat"] = refAutoBat
    local _, refTP = makeMobileBtn("TP\nDOWN", 0, 2, false, runTPFloor)
    mobBtnRefs["tpDown"] = refTP
    local _, refLagger = makeMobileBtn("LAGGER\nMODE", 0, 3, true, function(on)
        toggleLaggerMode()
        if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
            saveConfig()
    end)
    mobBtnRefs["lagger"] = refLagger
    local _, refReset = makeMobileBtn("INSTA\nRESET", 1, 3, false, cursedInstaReset)
    mobBtnRefs["instaReset"] = refReset
    local _, refTpBat = makeMobileBtn("TP\nBAT", 0, 4, true, function(on)
        if on then startSelectedTpBat() else stopSelectedTpBat() end
        saveConfig()
    end)
    mobBtnRefs["tpBat"] = refTpBat
    local _, refCarry = makeMobileBtn("CARRY\nSPEED", 1, 4, true, function(on)
        setManualCarrySpeed(on)
    end)
    mobBtnRefs["carrySpeed"] = refCarry
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(tpBat1Enabled or tpBat2Enabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedCarryActive) end
    -- Keep the requested floating controls present after rebuilding the GUI.
    frameDrop.Visible = true
    frameAutoLeft.Visible = true
    mbGroup.Visible = mobileButtonsVisible ~= false
    mobileButtonsBuildBusy = false
end

-- Rebuild automatically when an executor, respawn, or another GUI cleanup
-- removes the mobile controls from CoreGui/PlayerGui.
task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            local group = mobGuiRef and mobGuiRef:FindFirstChild("MobileButtons")
            local dropButton = group and group:FindFirstChild("SBtn_DROP\nBRAINROT")
            local leftButton = group and group:FindFirstChild("SBtn_AUTO\nLEFT")
            if not mobGuiRef or not mobGuiRef.Parent or not group or not dropButton or not leftButton then
                if not mobileButtonsBuildBusy then buildMobileButtons() end
            end
        end)
    end
end)

-- ============================================================
-- FULL CONFIG LOAD (including new settings)
-- ============================================================
pcall(function()
    if not(isfile and isfile("Spectrum_PC.json")) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile("Spectrum_PC.json")) end)
    if not(ok and type(d)=="table") then return end
    if type(d.normalSpeed)=="number" and d.normalSpeed>0 then NS=d.normalSpeed end
    if type(d.carrySpeed)=="number" and d.carrySpeed>0 then CS=d.carrySpeed end
    -- Each mode keeps its own Carry state; if none exists, start in Normal.
    if type(d.modeCarry)=="table" then
        for _,profile in ipairs({"Normal","Lagger","Custom"}) do
            if type(d.modeCarry[profile])=="boolean" then modeCarry[profile]=d.modeCarry[profile] end
        end
    end
    speedCarryActive=(modeCarry[HEARTLESS.speedMode] == true)
    if type(d.laggerSpeed)=="number" and d.laggerSpeed>0 then LAGGER_SPEED=d.laggerSpeed end
    if type(d.laggerCarrySpeed)=="number" and d.laggerCarrySpeed>0 then LAGGER_CARRY_SPEED=math.clamp(d.laggerCarrySpeed,1,200) end
    if type(d.laggerModeEnabled)=="boolean" then laggerModeEnabled=d.laggerModeEnabled end
    if type(d.customSpeedNorm)=="number" then HEARTLESS.customSpeedNorm=math.clamp(d.customSpeedNorm,1,200) end
    if type(d.customSpeedSteal)=="number" then HEARTLESS.customSpeedSteal=math.clamp(d.customSpeedSteal,1,200) end
    if d.speedMode=="Normal" or d.speedMode=="Lagger" or d.speedMode=="Custom" then HEARTLESS.speedMode=d.speedMode end
    if type(d.speedMethod)=="string" then setHeartlessSpeedMethod(d.speedMethod) end
    if type(d.antiRagdoll)=="boolean" then antiRagdollEnabled=d.antiRagdoll end
    if type(d.antiRagdollMode)=="string" then antiRagdollMode=d.antiRagdollMode end
    if type(d.infiniteJump)=="boolean" then infJumpEnabled=d.infiniteJump end
    if type(d.infJumpMode)=="string" then infJumpMode=d.infJumpMode end
    if type(d.dropMode)=="string" and (d.dropMode=="Jump" or d.dropMode=="Stand") then dropMode=d.dropMode end
    if type(d.medusaCounter)=="boolean" then medusaCounterEnabled=d.medusaCounter end
    if type(d.batCounter)=="boolean" then batCounterEnabled=d.batCounter end
    if type(d.autoStealEnabled)=="boolean" then Steal.AutoStealEnabled=d.autoStealEnabled end
    if type(d.autoLeftEnabled)=="boolean" then autoLeftEnabled=d.autoLeftEnabled end
    if type(d.autoRightEnabled)=="boolean" then autoRightEnabled=d.autoRightEnabled end
    if type(d.autoBatEnabled)=="boolean" then autoBatEnabled=d.autoBatEnabled end
    if type(d.aimbotSpeed)=="number" then AUTO_BAT_SPEED=math.clamp(d.aimbotSpeed,1,500) end
    if type(d.grabRadius)=="number" then Steal.StealRadius=math.clamp(d.grabRadius,1,500) end
    if type(d.stealDuration)=="number" then Steal.StealDuration=math.clamp(d.stealDuration,0.05,10) end
    if d.grabMode=="V1" or d.grabMode=="V2" then Steal.GrabMode=d.grabMode end
    if d.stealBarStyle=="V1" or d.stealBarStyle=="V2" then Steal.BarStyle=d.stealBarStyle end
    if type(d.halfFireRange)=="number" then Steal.HalfFireRange=math.clamp(d.halfFireRange,1,50) end
    if type(d.halfHoldMin)=="number" then Steal.HalfHoldMin=math.clamp(d.halfHoldMin,0.05,10) end
    if type(d.halfHoldMax)=="number" then Steal.HalfHoldMax=math.clamp(d.halfHoldMax,0.05,10) end
    if type(d.halfEntryDelay)=="number" then Steal.HalfEntryDelay=math.clamp(d.halfEntryDelay,0,5) end
    if type(d.autoSwing)=="boolean" then autoSwingEnabled=d.autoSwing end
    if type(d.tpBat1Enabled)=="boolean" then tpBat1Enabled=d.tpBat1Enabled elseif type(d.tpBatEnabled)=="boolean" then tpBat1Enabled=d.tpBatEnabled end
    if type(d.tpBat2Enabled)=="boolean" then tpBat2Enabled=d.tpBat2Enabled end
    if type(d.tpBatStuds)=="number" then TP_BAT_STUDS=math.clamp(d.tpBatStuds,3,12) end
    if type(d.tpBatInterval)=="number" then TP_BAT_SWING_INTERVAL=math.clamp(d.tpBatInterval,0.10,0.30) end
    if d.activeProfile=="Legit" or d.activeProfile=="Balanced" then activeProfile=d.activeProfile end
    if type(d.configProfiles)=="table" then for _,name in ipairs({"Legit","Balanced"}) do if type(d.configProfiles[name])=="table" then savedProfiles[name]=d.configProfiles[name] end end end
    if d.tpBatMode=="Original" or d.tpBatMode=="Clean" then tpBatMode=d.tpBatMode end
    if type(d.unwalkEnabled)=="boolean" then unwalkEnabled=d.unwalkEnabled end
    if type(d.antiLag)=="boolean" then antiLagEnabled=d.antiLag end
    if type(d.saturatedColors)=="boolean" then saturatedColorsEnabled=d.saturatedColors end
    if type(d.stretchRez)=="boolean" then stretchRezEnabled=d.stretchRez end
    if type(d.fovValue)=="number" then fovValue=d.fovValue end
    if type(d.fovIndex)=="number" then fovIndex=d.fovIndex end
    if type(d.autoMoveSwing)=="boolean" then autoMoveSwingEnabled=d.autoMoveSwing end
    if type(d.autoMoveSwingInterval)=="number" then autoMoveSwingInterval=d.autoMoveSwingInterval end
    if type(d.mobileButtonsEnabled)=="boolean" then mobileButtonsEnabled=d.mobileButtonsEnabled end
    if type(d.mobileButtonsVisible)=="boolean" then mobileButtonsVisible=d.mobileButtonsVisible end
    if type(d.mobileButtonsSize)=="number" then mobileButtonsSize=d.mobileButtonsSize end
    if type(d.circleButtonsEnabled)=="boolean" then circleButtonsEnabled=d.circleButtonsEnabled end
    if type(d.guiTransparencyEnabled)=="boolean" then guiTransparencyEnabled=d.guiTransparencyEnabled end
    if type(d.mobileButtonsLocked)=="boolean" then mobileButtonsLocked=d.mobileButtonsLocked end
    if type(d.mobBtnTransparencyEnabled)=="boolean" then mobBtnTransparencyEnabled=d.mobBtnTransparencyEnabled end
    if type(d.perButtonDragEnabled)=="boolean" then perButtonDragEnabled=d.perButtonDragEnabled end
    if type(d.uiLocked)=="boolean" then uiLocked=d.uiLocked end
    if type(d.lineESPEnabled)=="boolean" then lineESPEnabled=d.lineESPEnabled end
    if type(d.animEnabled)=="boolean" then animEnabled=d.animEnabled end
    if type(d.animPack)=="string" and HEARTLESS_ANIMATION_PACKS[d.animPack] then animPackName=d.animPack end
    if type(d.skyTheme)=="string" and CANDY_SKY_PRESETS[d.skyTheme] then currentSkyTheme=d.skyTheme end
    heartlessSkinEnabled=false -- No cambiar el avatar original al iniciar
    if d.skinMode=="Skin1" then skinMode="Skin1" end
    if type(d.hideHeadEnabled)=="boolean" then hideHeadEnabled=d.hideHeadEnabled end
    if type(d.rightLegHiddenEnabled)=="boolean" then rightLegHiddenEnabled=d.rightLegHiddenEnabled end
    if type(d.blackSmokeEnabled)=="boolean" then blackSmokeEnabled=d.blackSmokeEnabled end
    if d.smokeColor=="Black" or d.smokeColor=="Gray" or d.smokeColor=="White" then smokeColor=d.smokeColor end
    if type(d.crownEnabled)=="boolean" then crownEnabled=d.crownEnabled end
    if d.crownStyle=="White" or d.crownStyle=="Black" then crownStyle=d.crownStyle end
    if type(d.autoSwitchSpeed)=="boolean" then autoSwitchSpeedEnabled=d.autoSwitchSpeed end
    if type(d.tabPosition)=="string" then tabPosition=d.tabPosition end
    if type(d.mobileButtonWidth)=="number" then mobileButtonWidth=d.mobileButtonWidth end
    if type(d.mobileButtonHeight)=="number" then mobileButtonHeight=d.mobileButtonHeight end
    if type(d.mobileButtonOutline)=="number" then mobileButtonOutline=d.mobileButtonOutline end
    if type(d.menuWidth)=="number" then menuWidth=d.menuWidth end
    if type(d.menuHeight)=="number" then menuHeight=d.menuHeight end
    if type(d.buttonStyle)=="string" then buttonStyle=d.buttonStyle end
    if type(d.mobileTextSize)=="number" then mobileTextSize=d.mobileTextSize end
    if type(d.themeName)=="string" then for i,name in ipairs(THEME_ORDER) do if d.themeName==name then themeName=name;themeIndex=i end end end
    if createStealBar then createStealBar() end
end)
-- Carry mode can only be activated manually after starting.
speedCarryActive=(modeCarry[HEARTLESS.speedMode] == true)

-- RESTORE ALL SAVED ACTIVE OPTIONS
pcall(function()
    local function later(delay, fn)
        task.spawn(function() task.wait(delay); pcall(fn) end)
    end
    if autoLeftEnabled then later(0.9,function() startAutoLeft() end) end
    if autoRightEnabled then later(0.9,function() startAutoRight() end) end
    if autoBatEnabled then later(1.0,function() startBatAimbot() end) end
    if unwalkEnabled then later(0.8,function() startUnwalk() end) end
    if Steal.AutoStealEnabled then later(1.0,function() if startAutoSteal then startAutoSteal() end end) end
    if blackSmokeEnabled or crownEnabled then later(0.9,function() if heartlessSkinEnabled then applyHeartlessSkin(LP.Character) end end) end
end)

-- APPLY CONFIG
pcall(function()
    if animEnabled then
        task.spawn(function()
            task.wait(1)
            if startAnimToggle then startAnimToggle() end
        end)
    end
    if antiLagEnabled then
        task.spawn(function() task.wait(1); if antiLagEnabled then enableAntiLag() end end)
    end
    if saturatedColorsEnabled then
        task.spawn(function() task.wait(1); if saturatedColorsEnabled then enableSaturatedColors() end end)
    end
    if stretchRezEnabled then
        task.spawn(function()
            task.wait(0.5)
            if enableStretchRez then enableStretchRez() end
        end)
    end
    if antiRagdollEnabled then
        task.spawn(function()
            task.wait(0.5)
            if startAntiRagdoll then startAntiRagdoll() end
        end)
    end
    if infJumpEnabled then
        task.spawn(function()
            task.wait(0.5)
            startHoldJump()
        end)
    end
    if Steal.AutoStealEnabled then
        task.spawn(function()
            task.wait(1)
            if startAutoSteal then startAutoSteal() end
        end)
    end
    if batCounterEnabled then
        task.spawn(function()
            task.wait(1)
            if startBatCounter then startBatCounter() end
        end)
    end
    if medusaCounterEnabled then
        task.spawn(function()
            task.wait(1)
            local char = LP.Character
            if char and setupMedusa then setupMedusa(char) end
        end)
    end
    if heartlessSkinEnabled then
        task.spawn(function()
            task.wait(0.75)
            setHeartlessSkinEnabled(true, true)
        end)
    end
    if tpBat1Enabled or tpBat2Enabled then
        task.spawn(function()
            task.wait(1)
            tpBat1Enabled=false;tpBat2Enabled=false
            startSelectedTpBat()
        end)
    end
end)

-- ============================================================
-- Vaper.vs GUI (with rebuildGUILayout inside the closure)
-- ============================================================
;(function()

PlayerGui = LP:WaitForChild("PlayerGui")

function makeDraggable_cyber(dragTarget, moveTarget)
    moveTarget = moveTarget or dragTarget
    local dragging=false; local dragInputType=nil; local dragStart=nil; local startPos=nil
    dragTarget.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragInputType=(input.UserInputType==Enum.UserInputType.Touch and Enum.UserInputType.Touch or Enum.UserInputType.MouseMovement); dragStart=input.Position; startPos=moveTarget.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false; dragInputType=nil end end)
        end
    end)
    dragTarget.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false; dragInputType=nil end
    end)
    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInputType=input.UserInputType end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then dragging=false; return end
        if dragging and dragInputType and input.UserInputType==dragInputType then
            local delta=input.Position-dragStart
            moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local C={
    bg=Color3.fromRGB(6,6,6), bgDark=Color3.fromRGB(3,3,3), row=Color3.fromRGB(16,16,16),
    input=Color3.fromRGB(16,16,16), blue=Color3.fromRGB(210,210,210), blueDim=Color3.fromRGB(70,70,70),
    blueDark=Color3.fromRGB(22,22,22), text=Color3.fromRGB(255,255,255), textDim=Color3.fromRGB(160,160,160),
    textMuted=Color3.fromRGB(100,100,100), white=Color3.fromRGB(255,255,255), divider=Color3.fromRGB(32,32,32),
    green=Color3.fromRGB(80,220,120),
}
local GuiRefs={}
updateLineESP=function()
    local accent=Color3.fromRGB(255, 40, 40)
    local char=LP.Character
    local source=char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
    for p,r in pairs(lineESPObjects) do
        if p.Parent~=Players then
            if r.beam then r.beam:Destroy() end
            if r.auraBeam then r.auraBeam:Destroy() end
            if r.target then r.target:Destroy() end
            lineESPObjects[p]=nil
        elseif r.beam then
            r.beam.Color=ColorSequence.new(accent)
            r.beam.Enabled=false
            if r.auraBeam then
                r.auraBeam.Color=ColorSequence.new(accent)
                r.auraBeam.Enabled=false
            end
        end
    end
    if not lineESPEnabled or not source then return end
    local sourceAttachment=source:FindFirstChild("HeartlessLineESPSource")
    if not sourceAttachment then
        sourceAttachment=Instance.new("Attachment")
        sourceAttachment.Name="HeartlessLineESPSource"
        sourceAttachment.Parent=source
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local ch=p.Character
            local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            local target=ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso"))
            local r=lineESPObjects[p]
            if not r then
                r={}
                r.target=Instance.new("Attachment")
                r.target.Name="HeartlessLineESPTarget"
                r.beam=Instance.new("Beam")
                r.beam.Name="HeartlessLineESP"
                r.auraBeam=Instance.new("Beam")
                r.auraBeam.Name="HeartlessLineESPAura"
                r.beam.FaceCamera=true
                r.beam.LightEmission=1
                r.beam.LightInfluence=0
                r.beam.Width0=0.08
                r.beam.Width1=0.03
                r.beam.Segments=1
                r.beam.Transparency=NumberSequence.new(0)
                r.beam.Parent=workspace
                r.auraBeam.FaceCamera=true
                r.auraBeam.LightEmission=1
                r.auraBeam.LightInfluence=0
                r.auraBeam.Width0=0.28
                r.auraBeam.Width1=0.16
                r.auraBeam.Segments=1
                r.auraBeam.Transparency=NumberSequence.new(0.55)
                r.auraBeam.Parent=workspace
                lineESPObjects[p]=r
            end
            if target and hum and hum.Health>0 then
                r.target.Parent=target
                r.beam.Attachment0=sourceAttachment
                r.beam.Attachment1=r.target
                r.beam.Color=ColorSequence.new(accent)
                r.beam.Enabled=true
                r.auraBeam.Attachment0=sourceAttachment
                r.auraBeam.Attachment1=r.target
                r.auraBeam.Color=ColorSequence.new(accent)
                r.auraBeam.Enabled=true
            else
                r.beam.Enabled=false
                if r.auraBeam then r.auraBeam.Enabled=false end
            end
        end
    end
end
if not lineESPConn then
    lineESPConn=RunService.RenderStepped:Connect(function()
        if lineESPEnabled then updateLineESP() end
    end)
end
Players.PlayerRemoving:Connect(function(p)
    local r=lineESPObjects[p]
    if r then if r.beam then r.beam:Destroy() end; if r.auraBeam then r.auraBeam:Destroy() end; if r.target then r.target:Destroy() end; lineESPObjects[p]=nil end
end)
function applyColorTheme(name)
    local idx=1
    for i,n in ipairs(THEME_ORDER) do if n==name then idx=i break end end
    themeIndex=idx;themeName=THEME_ORDER[idx]
    local nameColors=NAME_PANEL_THEME_COLORS[themeName] or NAME_PANEL_THEME_COLORS.Blue
    NAME_PANEL_PRIMARY=nameColors.primary
    NAME_PANEL_ACCENT=nameColors.accent
    local accent=THEME_COLORS[themeName]
    C.blue=accent
    C.blueDim=accent:Lerp(C.bg,0.55)
    C.blueDark=accent:Lerp(C.bg,0.82)
    C.green=accent
    local roots={GuiRefs.hub,mobGuiRef}
    for _,root in ipairs(roots) do
        if root then
            for _,obj in ipairs(root:GetDescendants()) do
                if obj:IsA("UIStroke") then
                    obj.Color=accent
                elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    if obj.BackgroundTransparency<1 then obj.BackgroundColor3=accent end
                    obj.TextColor3=C.white
                elseif obj:IsA("TextLabel") then
                    obj.TextColor3=C.white
                elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                    if obj.Name=="ThemeToggleTrack" then
                        obj.BackgroundColor3=accent
                    elseif obj.Name=="ThemeToggleKnob" then
                        obj.BackgroundColor3=C.white
                    elseif obj.BackgroundTransparency<1 and obj.Name~="Outer" then
                        obj.BackgroundColor3=C.row
                    end
                end
            end
        end
    end
    if mobGuiRef then
        local mobileAccent=Color3.fromRGB(0,0,0)
        for _,obj in ipairs(mobGuiRef:GetDescendants()) do
            if obj:IsA("Frame") and obj.Name:sub(1,5)=="SBtn_" then
                obj.BackgroundColor3=mobileAccent
            elseif obj:IsA("UIStroke") and obj.Parent and obj.Parent.Name:sub(1,5)=="SBtn_" then
                if obj.Name == "AuraOuter" or obj.Name == "AuraInner" then
                    obj.Color = Color3.fromRGB(170, 70, 255)
                else
                    obj.Color=accent
                end
            elseif obj:IsA("TextButton") and obj.Parent and obj.Parent.Name:sub(1,5)=="SBtn_" then
                obj.TextColor3=C.white
            end
        end
    end
        if speedLabel then speedLabel.TextColor3=C.white; speedLabel.TextStrokeTransparency=1 end
    if speedTitleLabel then speedTitleLabel.TextColor3=C.white end
    if GuiRefs.titleLabel then GuiRefs.titleLabel.TextColor3=C.white; GuiRefs.titleLabel.TextStrokeTransparency=1 end
    if GuiRefs.footer then
        local footerText=GuiRefs.footer:FindFirstChildWhichIsA("TextLabel",true)
        if footerText then footerText.TextColor3=C.white; footerText.TextStrokeTransparency=1 end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        local char=plr.Character
        local speedGui=char and char:FindFirstChild("HeartlessEnemySpeedDisplay",true)
        local otherSpeed=speedGui and speedGui:FindFirstChild("SpeedLabel")
        if otherSpeed then otherSpeed.TextColor3=C.white; otherSpeed.TextStrokeTransparency=1 end
    end
    if HEARTLESS and HEARTLESS.statusLabel then HEARTLESS.statusLabel.TextColor3=C.white end
    if GuiRefs.bgDecal then
        GuiRefs.bgDecal.Image=THEME_IMAGES[themeName]
        GuiRefs.bgDecal.Visible=true
    end
    -- Actualiza ambas barras para usar el color del tema seleccionado.
    if createStealBar then createStealBar() end
    if updateLineESP then updateLineESP() end
    if saveConfig then saveConfig() end
end
function guiCorner(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,math.min(tonumber(r) or 12,16));c.Parent=p;return c end
function updateV1Style()
    local title=GuiRefs and GuiRefs.titleLabel
    if title then
        title.Font=Enum.Font.GothamBlack; title.TextColor3=C.white; title.TextSize=26; title.TextScaled=false; title.TextStrokeTransparency=1
            for _,obj in ipairs(title:GetChildren()) do if obj:IsA("UITextSizeConstraint") then obj:Destroy() end end
    end
    if GuiRefs.footer then GuiRefs.footer.Visible=false end
end
function updateInterfaceCorners()
    local hub=GuiRefs and GuiRefs.hub
    if not hub then return end
    for _,obj in ipairs(hub:GetDescendants()) do
        if obj:IsA("UICorner") then obj.CornerRadius=UDim.new(0,14) end
    end
end
function guiStroke(p,col,t) local s=Instance.new("UIStroke");s.Color=col or Color3.fromRGB(60,60,70);s.Thickness=t or 1;s.Transparency=0.72;s.Parent=p;return s end
function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.12),props):Play() end
function fitHeartlessText(obj,minSize,maxSize)
    if not obj then return end
    obj.TextScaled=true
    local limit=Instance.new("UITextSizeConstraint",obj); limit.MinTextSize=minSize or 8; limit.MaxTextSize=maxSize or 16
end

local GuiToggleSetters={}
local LeftPanel=nil

local Keys={
    circle=Enum.KeyCode.E,
    speed=Enum.KeyCode.Q,
    laggerToggle=Enum.KeyCode.K,
    guiHide=Enum.KeyCode.RightControl,
    dropBrainrot=Enum.KeyCode.H,
    tpDown=Enum.KeyCode.T,
    instaReset=Enum.KeyCode.B,
    autoLeft=Enum.KeyCode.J,
    autoRight=Enum.KeyCode.L,
    tpBat=Enum.KeyCode.R,
    speedNormal=Enum.KeyCode.G,
    speedLagger=Enum.KeyCode.F,
    speedCustom=Enum.KeyCode.Three,
}
pcall(function()
    if not(isfile and isfile("Spectrum_PC.json")) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile("Spectrum_PC.json")) end)
    if ok and type(d)=="table" and type(d.keys)=="table" then
        for k,v in pairs(d.keys) do
            local ok2,kc=pcall(function() return Enum.KeyCode[v] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then Keys[k]=kc end
        end
    end
end)
_GuiKeys = Keys

-- ===== rebuildGUILayout (now inside closure) =====
function rebuildGUILayout()
    if not GuiRefs or not GuiRefs.outer then return end
    local Outer = GuiRefs.outer
    local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local outerScale=GuiRefs.outerScale
    local baseW=math.max(200,tonumber(v1MenuWidth) or 265)
    local baseH=math.max(200,tonumber(v1MenuHeight) or 410)
    if outerScale then
        local fitX=math.max(0.72,math.min(1,(vp.X-24)/baseW))
        local fitY=math.max(0.72,math.min(1,(vp.Y-84)/baseH))
        outerScale.Scale=math.min(fitX,fitY)
    end
    Outer.Size=UDim2.new(0,baseW,0,baseH)
    local scaledW=baseW*(outerScale and outerScale.Scale or 1)
    local scaledH=baseH*(outerScale and outerScale.Scale or 1)
    Outer.Position=UDim2.new(0,math.max(12,math.min(20,vp.X-scaledW-12)),0,math.max(48,math.min(110,vp.Y-scaledH-18)))
    updateV1Style()
    updateInterfaceCorners()

    local Inner = GuiRefs.inner
    local LeftPanel = GuiRefs.leftPanel
    local ContentFrame = GuiRefs.contentFrame
    local TopTabs = GuiRefs.topTabs
    if ContentFrame then
        local contentScale=GuiRefs.contentScale
        if not contentScale then contentScale=Instance.new("UIScale");contentScale.Name="ResponsiveTextScale";contentScale.Parent=ContentFrame;GuiRefs.contentScale=contentScale end
        contentScale.Scale=1
    end
    if CategoryRefs and CategoryRefs.contents then
        for name,page in pairs(CategoryRefs.contents) do
            page.Visible=(name==CategoryRefs.active)
        end
    end

    if not LeftPanel or not ContentFrame then return end

    if TopTabs then TopTabs:Destroy(); GuiRefs.topTabs = nil end

    LeftPanel.Visible=true
    local CatList = LeftPanel:FindFirstChild("CategoryList")
    if CatList then CatList.Visible=true end
    LeftPanel.Size=UDim2.new(1,-24,0,42)
    LeftPanel.Position=UDim2.new(0,12,0,63)
    ContentFrame.Size=UDim2.new(1,0,1,-118)
    ContentFrame.Position=UDim2.new(0,0,0,105)


    -- Ensure the inner frame updates
    task.wait()
    Inner.Size = UDim2.new(1, 0, 1, 0)
end

;(function()
    local GuiHub=Instance.new("ScreenGui")
    GuiHub.Name="GridelsVS"; GuiHub.ResetOnSpawn=false
    GuiHub.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; GuiHub.Parent=PlayerGui
    GuiRefs.hub=GuiHub

    local Outer=Instance.new("Frame")
    Outer.Name="Outer"; Outer.Size=UDim2.new(0,340,0,495); Outer.AnchorPoint=Vector2.new(0,0); Outer.Position=UDim2.new(0,6,0,18)
    Outer.BackgroundTransparency=1; Outer.BorderSizePixel=0; Outer.ClipsDescendants=false; Outer.Parent=GuiHub
    GuiRefs.outer=Outer
    -- compact scale for mobile (opens on the LEFT, under Roblox settings)
    local OuterScale=Instance.new("UIScale"); OuterScale.Name="V1Scale"; OuterScale.Scale=1; OuterScale.Parent=Outer; GuiRefs.outerScale=OuterScale

    local Inner=Instance.new("Frame")
    Inner.Name="Inner"; Inner.ClipsDescendants=false; Inner.Size=UDim2.new(1,0,1,0)
    Inner.BackgroundColor3=C.bg; Inner.BackgroundTransparency=0; Inner.BorderSizePixel=0; Inner.Parent=Outer
    guiCorner(Inner,24); guiStroke(Inner,Color3.fromRGB(45,45,45),1.5); GuiRefs.inner=Inner

    local BgCont=Instance.new("Frame")
    BgCont.Name="BackgroundContainer"; BgCont.Size=UDim2.new(1,0,1,0)
    BgCont.BackgroundTransparency=1; BgCont.ZIndex=0; BgCont.Parent=Inner

    local BgGrad=Instance.new("Frame")
    BgGrad.Name="BgGrad"; BgGrad.Size=UDim2.new(1,0,1,0); BgGrad.BackgroundColor3=C.bgDark
    BgGrad.BorderSizePixel=0; BgGrad.ZIndex=0; BgGrad.Parent=BgCont; guiCorner(BgGrad,24)
    local grad=Instance.new("UIGradient")
    grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(4,4,4)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(7,7,7)),ColorSequenceKeypoint.new(1,Color3.fromRGB(4,4,4))})
    grad.Rotation=135; grad.Parent=BgGrad; GuiRefs.bgGrad=BgGrad

    local BgImg=Instance.new("ImageLabel")
    BgImg.Name="BackgroundImage"; BgImg.Size=UDim2.new(1,0,1,0); BgImg.BackgroundTransparency=1
    BgImg.Image="rbxassetid://132826602147402"; BgImg.ScaleType=Enum.ScaleType.Crop; BgImg.ZIndex=0
    BgImg.ImageTransparency=0.55; BgImg.Visible=true
    BgImg.Parent=BgCont; guiCorner(BgImg,24); GuiRefs.backgroundImage=BgImg; GuiRefs.bgDecal=BgImg; bgImageRef=BgImg

    local HF=Instance.new("Frame")
    HF.Name="HeaderFrame"; HF.Size=UDim2.new(1,0,0,62); HF.BackgroundTransparency=1
    HF.BorderSizePixel=0; HF.Parent=Inner; HF.ZIndex=2
    makeDraggable_cyber(HF, Outer)

    local TL=Instance.new("TextLabel")
    TL.Position=UDim2.new(0,14,0,8); TL.Size=UDim2.new(1,-90,0,22); TL.BackgroundTransparency=1
    TL.Text="Vaper.vs"; TL.TextColor3=Color3.fromRGB(255,255,255); TL.TextSize=17; TL.Font=Enum.Font.GothamBlack
    TL.TextXAlignment=Enum.TextXAlignment.Left; TL.Parent=HF; TL.ZIndex=3

    local ML=Instance.new("TextLabel")
    ML.Position=UDim2.new(0,14,0,32); ML.Size=UDim2.new(0,200,0,14); ML.BackgroundTransparency=1
    ML.Text="Vaper.vs • PREMIUM"; ML.TextColor3=Color3.fromRGB(255,255,255); ML.TextSize=10; ML.Font=Enum.Font.GothamBold
    ML.TextXAlignment=Enum.TextXAlignment.Left; ML.Parent=HF; ML.ZIndex=3

    local DiscordLbl=Instance.new("TextLabel")
    DiscordLbl.Position=UDim2.new(0,14,0,46); DiscordLbl.Size=UDim2.new(0,230,0,12); DiscordLbl.BackgroundTransparency=1
    DiscordLbl.Text="discord.gg/"; DiscordLbl.TextColor3=Color3.fromRGB(255,255,255); DiscordLbl.TextSize=9; DiscordLbl.Font=Enum.Font.GothamBold
    DiscordLbl.TextXAlignment=Enum.TextXAlignment.Left; DiscordLbl.Parent=HF; DiscordLbl.ZIndex=3

    local DiscordNumber=Instance.new("TextLabel")
    DiscordNumber.Position=UDim2.new(0,14,0,57); DiscordNumber.Size=UDim2.new(0,230,0,12); DiscordNumber.BackgroundTransparency=1
    DiscordNumber.Text="2d8pjb8K5"; DiscordNumber.TextColor3=Color3.fromRGB(255,255,255); DiscordNumber.TextSize=9; DiscordNumber.Font=Enum.Font.GothamBold
    DiscordNumber.TextXAlignment=Enum.TextXAlignment.Left; DiscordNumber.Parent=HF; DiscordNumber.ZIndex=3

    -- MINIMIZE BUTTON
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Size=UDim2.new(0,28,0,28); CloseBtn.Position=UDim2.new(1,-38,0,8)
    CloseBtn.BackgroundColor3=C.bgDark; CloseBtn.BorderSizePixel=0
    CloseBtn.Text="-"; CloseBtn.TextColor3=Color3.fromRGB(255,255,255); CloseBtn.Font=Enum.Font.GothamBlack; CloseBtn.TextSize=22
    CloseBtn.ZIndex=5; CloseBtn.Parent=HF
    guiCorner(CloseBtn,7); guiStroke(CloseBtn,Color3.fromRGB(45,45,45),1)
    CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(28,28,28),TextColor3=Color3.fromRGB(255,255,255)}) end)
    CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.bgDark,TextColor3=Color3.fromRGB(255,255,255)}) end)

    -- MINI RESTORE BUTTON
    local MiniBtn=Instance.new("TextButton")
    MiniBtn.Size=UDim2.new(0,110,0,28); MiniBtn.AnchorPoint=Vector2.new(0,0); MiniBtn.Position=UDim2.new(0,8,0,16)
    MiniBtn.BackgroundColor3=C.bgDark; MiniBtn.BorderSizePixel=0
    MiniBtn.Text="Vaper.vs"; MiniBtn.TextColor3=Color3.fromRGB(255,255,255); MiniBtn.Font=Enum.Font.GothamBlack; MiniBtn.TextSize=11
    MiniBtn.ZIndex=20; MiniBtn.Visible=false; MiniBtn.Parent=GuiRefs.hub
    guiCorner(MiniBtn,8); guiStroke(MiniBtn,Color3.fromRGB(45,45,45),1.2)
    makeDraggable_cyber(MiniBtn, MiniBtn)
    MiniBtn.MouseEnter:Connect(function() tw(MiniBtn,{BackgroundColor3=Color3.fromRGB(22,22,22)}) end)
    MiniBtn.MouseLeave:Connect(function() tw(MiniBtn,{BackgroundColor3=C.bgDark}) end)

    local function showGui() Outer.Visible=true; MiniBtn.Visible=false end
    local function hideGui() Outer.Visible=false; MiniBtn.Visible=true end
    CloseBtn.MouseButton1Click:Connect(hideGui)
    MiniBtn.MouseButton1Click:Connect(showGui)

    local HSep=Instance.new("Frame")
    HSep.Position=UDim2.new(0,14,0,62); HSep.Size=UDim2.new(1,-28,0,1); HSep.BackgroundColor3=C.blue
    HSep.BackgroundTransparency=0.7; HSep.BorderSizePixel=0; HSep.Parent=Inner; HSep.ZIndex=2

    LeftPanel=Instance.new("Frame")
    LeftPanel.Name="LeftPanel"; LeftPanel.Size=UDim2.new(1,-28,0,36); LeftPanel.Position=UDim2.new(0,14,0,70)
    LeftPanel.BackgroundColor3=C.bgDark; LeftPanel.BackgroundTransparency=0.5; LeftPanel.BorderSizePixel=0
    LeftPanel.Parent=Inner; guiCorner(LeftPanel,12); LeftPanel.ZIndex=2; GuiRefs.leftPanel=LeftPanel

    local CatList=Instance.new("ScrollingFrame")
    CatList.Name="CategoryList"; CatList.Size=UDim2.new(1,0,1,0); CatList.BackgroundTransparency=1
    CatList.BorderSizePixel=0; CatList.ScrollBarThickness=2; CatList.ScrollBarImageColor3=C.blue
    CatList.CanvasSize=UDim2.new(0,0,0,0); CatList.AutomaticCanvasSize=Enum.AutomaticSize.Y; CatList.Active=true; CatList.Parent=LeftPanel
    CatList.ScrollingDirection=Enum.ScrollingDirection.X; CatList.AutomaticCanvasSize=Enum.AutomaticSize.X; CatList.ScrollBarThickness=0
    local CatLay=Instance.new("UIListLayout"); CatLay.SortOrder=Enum.SortOrder.LayoutOrder; CatLay.Padding=UDim.new(0,4)
    CatLay.FillDirection=Enum.FillDirection.Horizontal; CatLay.VerticalAlignment=Enum.VerticalAlignment.Center; CatLay.Parent=CatList
    CatLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() CatList.CanvasSize = UDim2.new(0, CatLay.AbsoluteContentSize.X + 6, 0, 0) end)
    local CatPad=Instance.new("UIPadding"); CatPad.PaddingLeft=UDim.new(0,6); CatPad.PaddingRight=UDim.new(0,6)
    CatPad.PaddingTop=UDim.new(0,4); CatPad.PaddingBottom=UDim.new(0,4); CatPad.Parent=CatList
    GuiRefs.categoryList=CatList

    local CF=Instance.new("ScrollingFrame")
    CF.Name="ContentFrame"; CF.Size=UDim2.new(1,0,1,-172); CF.Position=UDim2.new(0,0,0,112)
    CF.BackgroundTransparency=1; CF.BorderSizePixel=0; CF.ScrollBarThickness=6; CF.ScrollBarImageColor3=C.blue
    CF.CanvasSize=UDim2.new(0,0,0,0); CF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    CF.ScrollingDirection=Enum.ScrollingDirection.Y; CF.ScrollingEnabled=true; CF.Active=true
    CF.ElasticBehavior=Enum.ElasticBehavior.Never; CF.Parent=Inner; GuiRefs.contentFrame=CF
    local CLay=Instance.new("UIListLayout"); CLay.SortOrder=Enum.SortOrder.LayoutOrder; CLay.Padding=UDim.new(0,6); CLay.Parent=CF
    CLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() CF.CanvasSize = UDim2.new(0, 0, 0, CLay.AbsoluteContentSize.Y + 25) end)
    local CPad=Instance.new("UIPadding"); CPad.PaddingLeft=UDim.new(0,12); CPad.PaddingRight=UDim.new(0,12)
    CPad.PaddingTop=UDim.new(0,10); CPad.PaddingBottom=UDim.new(0,8); CPad.Parent=CF

    local BotSep=Instance.new("Frame")
    BotSep.Position=UDim2.new(0,8,1,-54); BotSep.Size=UDim2.new(1,-16,0,1); BotSep.BackgroundColor3=C.blue
    BotSep.BackgroundTransparency=0.65; BotSep.BorderSizePixel=0; BotSep.Parent=Inner; BotSep.ZIndex=2
end)()

-- Responsive sizing for the new Xpluzo-style main menu.
pcall(function() rebuildGUILayout() end)
do
    local resizeCam=workspace.CurrentCamera
    local resizePending=false
    if resizeCam then
        resizeCam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if resizePending then return end
            resizePending=true
            task.defer(function()
                resizePending=false
                if GuiRefs.outer and GuiRefs.outer.Parent then pcall(rebuildGUILayout) end
            end)
        end)
    end
end

-- KEYBIND SYSTEM
KeyListen={cb=nil,label=nil,active=false,keyName=nil}
local KEY_ALIASES={
    ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonR1="RB",ButtonR2="RT",ButtonL1="LB",ButtonL2="LT",
    DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",ButtonStart="▶",ButtonSelect="◀",
    LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",
    LeftSuper="LSuper",RightSuper="RSuper",Return="Enter",BackSpace="Backspace",Tab="Tab",CapsLock="CapsLock",
    Escape="Esc",Space="Space",PageUp="PgUp",PageDown="PgDn",End="End",Home="Home",Insert="Ins",Delete="Del",
    Up="↑",Down="↓",Left="←",Right="→",F1="F1",F2="F2",F3="F3",F4="F4",F5="F5",F6="F6",F7="F7",F8="F8",
    F9="F9",F10="F10",F11="F11",F12="F12",Print="PrtScn",ScrollLock="ScrLk",Pause="Pause",
    Minus="-",Equals="=",LeftBracket="[",RightBracket="]",BackSlash="\\",Semicolon=";",Quote="'",
    Comma=",",Period=".",Slash="/",Backquote="`"
}
function prettyKey(kc)
    if not kc or kc==Enum.KeyCode.Unknown then return "None" end
    return KEY_ALIASES[kc.Name] or kc.Name
end
function cancelKL()
    if KeyListen.label then KeyListen.label.BackgroundColor3=C.blue; KeyListen.label.BackgroundTransparency=0.15 end
    KeyListen.cb=nil; KeyListen.label=nil; KeyListen.active=false; KeyListen.keyName=nil
end
function startKL(lbl,onSet,keyName)
    cancelKL(); KeyListen.cb=onSet; KeyListen.label=lbl; KeyListen.active=true; KeyListen.keyName=keyName
    lbl.Text="..."; lbl.BackgroundColor3=Color3.fromRGB(80,220,120); lbl.BackgroundTransparency=0.3
    local cap=lbl; local capKey=keyName; task.delay(8,function() if KeyListen.label==cap and KeyListen.active then cancelKL(); if lbl and lbl.Parent then lbl.Text=prettyKey(capKey and Keys[capKey]); lbl.BackgroundColor3=C.blue; lbl.BackgroundTransparency=0.15 end end end)
end
UIS.InputBegan:Connect(function(inp,gp)
    if not KeyListen.active then return end; if gp then return end
    local ut=inp.UserInputType
    if ut~=Enum.UserInputType.Keyboard and ut~=Enum.UserInputType.Gamepad1 then return end
    local k=inp.KeyCode
    if k==Enum.KeyCode.Unknown then return end
    if k==Enum.KeyCode.Escape then cancelKL(); return end
    local cb=KeyListen.cb; local lb=KeyListen.label; cancelKL()
    if lb and lb.Parent then lb.Text=prettyKey(k); lb.BackgroundColor3=C.blue; lb.BackgroundTransparency=0.15 end
    if cb then task.spawn(cb,k) end
end)

-- ROW BUILDERS
function addSectLbl(parent,text,order)
    local w=Instance.new("Frame",parent); w.Size=UDim2.new(1,0,0,22); w.BackgroundTransparency=1; w.LayoutOrder=order
    local L=Instance.new("TextLabel",w); L.Size=UDim2.new(1,0,0,16); L.BackgroundTransparency=1
    L.Text=text; L.TextColor3=Color3.fromRGB(255,255,255); L.TextSize=9; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
    return L
end
function addInputRow(parent,label,value,order,cb)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,32); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.15; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(255,255,255); Lb.TextSize=10; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local BC=Instance.new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-58,0.5,-10); BC.Size=UDim2.new(0,48,0,20)
    BC.BackgroundColor3=C.input; BC.BackgroundTransparency=0.35; BC.BorderSizePixel=0; guiCorner(BC,6); guiStroke(BC,Color3.fromRGB(55,55,60),1)
    local Box=Instance.new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
    Box.Text=tostring(value); Box.TextColor3=Color3.fromRGB(255,255,255); Box.TextSize=11; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=false
    Box.FocusLost:Connect(function() local n=tonumber(Box.Text); if n and n>0 then cb(n) else Box.Text=tostring(value) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.15}) end)
    return Row,Box
end
function addToggleRow(parent,label,enabled,order,kbKey,onToggle)
    -- Key assignment is now handled only in the dedicated Keybinds category.
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,32); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.15; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(255,255,255); Lb.TextSize=10; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local Track=Instance.new("Frame",Row); Track.Name="ThemeToggleTrack"; Track.Size=UDim2.new(0,36,0,18); Track.Position=UDim2.new(1,-46,0,10)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.35; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Name="ThemeToggleKnob"; Knob.Size=UDim2.new(0,14,0,14)
    Knob.Position=enabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.3 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,7)
    local st=enabled
    local function setV(on) st=on; tw(Knob,{Position=on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)}); tw(Knob,{BackgroundTransparency=on and 0.3 or 0.5}) end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,36,0,18); Btn.Position=UDim2.new(1,-46,0,10); Btn.BackgroundTransparency=1; Btn.Text=""; Btn.ZIndex=3; Btn.Active=true
    Btn.MouseButton1Click:Connect(function() st=not st; setV(st); if onToggle then onToggle(st) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0; hov.Active=false
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.15}) end)
    if kbKey then GuiToggleSetters[kbKey]=setV end
    return Row,setV
end
function addActionRow(parent,label,kbKey,onAction,order)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,36); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.15; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.55,0,0,16); Lb.Position=UDim2.new(0,12,0,8)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(255,255,255); Lb.TextSize=10; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local AB=Instance.new("TextButton",Row); AB.Size=UDim2.new(0.55,0,1,0); AB.BackgroundTransparency=1; AB.Text=""; AB.MouseButton1Click:Connect(onAction)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.15}) end)
    return Row
end
function addKeybindRow(parent,label,kbKey,order)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,36); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.15; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.62,0,0,16); Lb.Position=UDim2.new(0,12,0,8)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(255,255,255); Lb.TextSize=10; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local KB=Instance.new("TextButton",Row); KB.Size=UDim2.new(0,52,0,22); KB.Position=UDim2.new(1,-62,0.5,-11)
    KB.BackgroundColor3=C.blue; KB.BackgroundTransparency=0.35; KB.BorderSizePixel=0; KB.Text=prettyKey(Keys[kbKey])
    KB.TextColor3=C.white; KB.TextSize=9; KB.Font=Enum.Font.GothamBold; guiCorner(KB,5)
    KB.MouseButton1Click:Connect(function()
        startKL(KB,function(nk) Keys[kbKey]=nk; KB.Text=prettyKey(nk); saveConfig() end,kbKey)
    end)
    local Clear=Instance.new("TextButton",Row); Clear.Size=UDim2.new(0,22,0,22); Clear.Position=UDim2.new(1,-88,0.5,-11)
    Clear.BackgroundColor3=Color3.fromRGB(150,35,45); Clear.BackgroundTransparency=0.35; Clear.BorderSizePixel=0; Clear.Text="X"
    Clear.TextColor3=C.white; Clear.TextSize=11; Clear.Font=Enum.Font.GothamBlack; guiCorner(Clear,5)
    Clear.MouseButton1Click:Connect(function()
        Keys[kbKey]=Enum.KeyCode.Unknown
        KB.Text="None"
        saveConfig()
    end)
    return Row
end
function addSpeedProfileCard(parent,title,subtitle,profile,keyName,normGetter,stealGetter,normSetter,stealSetter,order)
    local card=Instance.new("Frame",parent); card.Size=UDim2.new(1,0,0,92); card.BackgroundColor3=Color3.fromRGB(28,28,31); card.BackgroundTransparency=0.12; card.BorderSizePixel=0; card.LayoutOrder=order; guiCorner(card,12); guiStroke(card,Color3.fromRGB(48,48,52),1)
    local dot=Instance.new("Frame",card); dot.Size=UDim2.new(0,16,0,16); dot.Position=UDim2.new(0,16,0,28); dot.BackgroundColor3=Color3.fromRGB(25,25,28); dot.BorderSizePixel=0; guiCorner(dot,4)
    local ds=guiStroke(dot,Color3.fromRGB(65,65,70),1)
    local hit=Instance.new("TextButton",card); hit.Size=UDim2.new(0,48,0,48); hit.Position=UDim2.new(0,0,0,14); hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=4
    local name=Instance.new("TextLabel",card); name.Size=UDim2.new(0.27,0,0,34); name.Position=UDim2.new(0.17,0,0,8); name.BackgroundTransparency=1; name.Text=title; name.TextColor3=C.white; name.TextSize=14; name.Font=Enum.Font.GothamBold; name.TextWrapped=true; name.TextXAlignment=Enum.TextXAlignment.Left; fitHeartlessText(name,8,14)
    local sub=Instance.new("TextLabel",card); sub.Size=UDim2.new(0.27,0,0,20); sub.Position=UDim2.new(0.17,0,0,48); sub.BackgroundTransparency=1; sub.Text=subtitle; sub.TextColor3=Color3.fromRGB(255,255,255); sub.TextSize=10; sub.Font=Enum.Font.Gotham; sub.TextWrapped=true; sub.TextXAlignment=Enum.TextXAlignment.Left; fitHeartlessText(sub,7,10)
    local key=Instance.new("TextButton",card); key.Size=UDim2.new(0.12,0,0,28); key.Position=UDim2.new(0.47,0,0,32); key.BackgroundColor3=Color3.fromRGB(38,38,43); key.BackgroundTransparency=0.25; key.BorderSizePixel=0; key.Text=prettyKey(Keys[keyName]); key.TextColor3=C.white; key.TextSize=12; key.Font=Enum.Font.GothamBold; guiCorner(key,8); fitHeartlessText(key,8,12)
    key.MouseButton1Click:Connect(function() startKL(key,function(nk) Keys[keyName]=nk; key.Text=prettyKey(nk); saveConfig() end,keyName) end)
    local normHead=Instance.new("TextLabel",card); normHead.Size=UDim2.new(0.16,0,0,14); normHead.Position=UDim2.new(0.63,0,0,10); normHead.BackgroundTransparency=1; normHead.Text="norm spd"; normHead.TextColor3=Color3.fromRGB(255,255,255); normHead.TextSize=9; normHead.Font=Enum.Font.Gotham; normHead.TextXAlignment=Enum.TextXAlignment.Center; fitHeartlessText(normHead,6,9)
    local stealHead=normHead:Clone(); stealHead.Position=UDim2.new(0.82,0,0,10); stealHead.Text="steal spd"; stealHead.Parent=card
    local norm=Instance.new("TextBox",card); norm.Size=UDim2.new(0.16,0,0,24); norm.Position=UDim2.new(0.63,0,0,34); norm.BackgroundColor3=Color3.fromRGB(42,42,46); norm.BackgroundTransparency=0.2; norm.BorderSizePixel=0; norm.TextColor3=C.white; norm.TextSize=14; norm.Font=Enum.Font.GothamBold; norm.TextXAlignment=Enum.TextXAlignment.Center; norm.ClearTextOnFocus=false; guiCorner(norm,5); fitHeartlessText(norm,8,14)
    local steal=norm:Clone(); steal.Position=UDim2.new(0.82,0,0,34); steal.Parent=card
    local function refresh()
        norm.Text=tostring(normGetter()); steal.Text=tostring(stealGetter())
    end
    norm.FocusLost:Connect(function() normSetter(norm.Text); refresh(); updateHeartlessSpeedStatus(); saveConfig() end)
    steal.FocusLost:Connect(function() stealSetter(steal.Text); refresh(); updateHeartlessSpeedStatus(); saveConfig() end)
    local function setActive(on)
        dot.BackgroundColor3=on and C.white or Color3.fromRGB(25,25,28); ds.Color=on and C.white or Color3.fromRGB(65,65,70); refresh()
    end
    hit.Activated:Connect(function() selectHeartlessSpeedProfile(profile) end)
    HEARTLESS.speedCards[profile]=setActive; refresh(); setActive(HEARTLESS.speedMode==profile)
    return card
end
function addCycleRow(parent,label,value,order,onCycle)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,32); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.15; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(255,255,255); Lb.TextSize=10; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local CB=Instance.new("TextButton",Row); CB.Size=UDim2.new(0,60,0,22); CB.Position=UDim2.new(1,-72,0.5,-11)
    CB.BackgroundColor3=C.blue; CB.BackgroundTransparency=0.35; CB.BorderSizePixel=0; CB.Text=value
    CB.TextColor3=C.white; CB.TextSize=9; CB.Font=Enum.Font.GothamBold; guiCorner(CB,5)
    CB.MouseButton1Click:Connect(function() local nv=onCycle(); CB.Text=nv end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.15}) end)
    return Row,CB
end

-- CATEGORY SETUP
Categories={"Speed","Combat","Steal","Movement","Visual","Keybinds"}
CategoryRefs={contents={},btnsSide={},active="Speed"}
;(function()
    for _,name in pairs(Categories) do
        local page=Instance.new("Frame"); page.Size=UDim2.new(1,0,0,0); page.AutomaticSize=Enum.AutomaticSize.Y; page.BackgroundTransparency=1
        page.Visible=(name==CategoryRefs.active); page.Parent=GuiRefs.contentFrame; CategoryRefs.contents[name]=page
        local lay=Instance.new("UIListLayout"); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,4); lay.Parent=page
    end
    for i,name in ipairs(Categories) do
        local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,66,0,28); btn.BackgroundColor3=C.blueDark
        btn.BackgroundTransparency=0.3; btn.Text=name; btn.TextColor3=(name=="Speed") and C.white or C.textMuted
        btn.TextSize=8; btn.Font=Enum.Font.GothamBold; btn.BorderSizePixel=0; btn.LayoutOrder=i; btn.Parent=GuiRefs.categoryList; guiCorner(btn,10)
        local ind=Instance.new("Frame"); ind.Name="indicator"; ind.Size=UDim2.new(0,2,0,16); ind.Position=UDim2.new(1,-2,0.5,-8)
        ind.BackgroundColor3=C.blue; ind.BackgroundTransparency=(name=="Speed") and 0.3 or 1; ind.BorderSizePixel=0; ind.Parent=btn
        CategoryRefs.btnsSide[name]=btn
        btn.MouseButton1Click:Connect(function()
            for _,f in pairs(CategoryRefs.contents) do f.Visible=false end
            local selectedPage = CategoryRefs.contents[name]
            selectedPage.Visible=true; CategoryRefs.active=name
            GuiRefs.contentFrame.CanvasPosition=Vector2.new(0,0)
            for n,b in pairs(CategoryRefs.btnsSide) do
                local ac=(n==name); b.TextColor3=ac and C.white or C.textMuted; b.BackgroundTransparency=ac and 0.2 or 0.3
                local i2=b:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency=ac and 0.3 or 1 end
            end
            local lay = selectedPage:FindFirstChildOfClass("UIListLayout")
            if lay then
                GuiRefs.contentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(GuiRefs.contentFrame.AbsoluteWindowSize.Y + 1, lay.AbsoluteContentSize.Y + 58))
                task.defer(function() GuiRefs.contentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(GuiRefs.contentFrame.AbsoluteWindowSize.Y + 1, lay.AbsoluteContentSize.Y + 58)) end)
            end
        end)
        btn.MouseEnter:Connect(function() if CategoryRefs.active~=name then btn.TextColor3=Color3.fromRGB(255,255,255); btn.BackgroundTransparency=0.25 end end)
        btn.MouseLeave:Connect(function() if CategoryRefs.active~=name then btn.TextColor3=Color3.fromRGB(255,255,255); btn.BackgroundTransparency=0.3 end end)
    end
    local spBtn=CategoryRefs.btnsSide["Speed"]
    if spBtn then spBtn.TextColor3=C.white; spBtn.BackgroundTransparency=0.2; local i2=spBtn:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency=0.3 end end
end)()

-- SPEED PAGE
;(function()
    local sp=CategoryRefs.contents["Speed"]
    addSectLbl(sp,"SPEED PROFILES",0)
    addSpeedProfileCard(sp,"Normal Speed","default mode","Normal","speedNormal",function() return NS end,function() return CS end,function(v) NS=math.clamp(tonumber(v) or NS,1,200) end,function(v) CS=math.clamp(tonumber(v) or CS,1,200) end,1)
    -- Solo se muestra el perfil Normal Speed. Los perfiles Lagger Speed y Custom Speed fueron retirados del menú.
    local status=Instance.new("Frame",sp); status.Size=UDim2.new(1,0,0,34); status.BackgroundColor3=Color3.fromRGB(86,86,90); status.BackgroundTransparency=0.05; status.BorderSizePixel=0; status.LayoutOrder=15; guiCorner(status,8)
    local sl=Instance.new("TextLabel",status); sl.Size=UDim2.new(1,-20,1,0); sl.Position=UDim2.new(0,10,0,0); sl.BackgroundTransparency=1; sl.TextColor3=C.white; sl.TextStrokeColor3=Color3.fromRGB(255,255,255); sl.TextStrokeTransparency=0.45; sl.TextSize=11; sl.Font=Enum.Font.GothamBold; sl.TextXAlignment=Enum.TextXAlignment.Center; sl.Text="Speed: "..HEARTLESS.speedMode.." | "..(speedCarryActive and "CARRY" or "NORMAL"); HEARTLESS.statusLabel=sl; updateHeartlessSpeedStatus()
    addSectLbl(sp,"CONTROLS",16)
    local _,setCarryVisual=addToggleRow(sp,"Carry Speed",speedCarryActive,13,nil,function(on)
        setManualCarrySpeed(on)
    end)
    HEARTLESS.carryVisualSetter=setCarryVisual
    setCarryVisual(speedCarryActive)
    addToggleRow(sp,"Lagger Mode",laggerModeEnabled,14,"laggerToggle",function(on)
        laggerModeEnabled=on; if mobBtnRefs.lagger then mobBtnRefs.lagger(on) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end; saveConfig()
    end)
end)()

-- COMBAT PAGE
;(function()
    local cp=CategoryRefs.contents["Combat"]
    addSectLbl(cp,"BAT CONTROLS",0)
    local _,svAutoBat=addToggleRow(cp,"Bat Aimbot",autoBatEnabled,1,"circle",function(on)
        if on then
            if tpBat1Enabled then stopTpBat() end
            if tpBat2Enabled then stopTpBat2() end
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
        else stopBatAimbot();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        saveConfig()
    end)
    autoBatSetVisual=svAutoBat
    addInputRow(cp,"Aimbot Speed",AUTO_BAT_SPEED,1.5,function(v)
        AUTO_BAT_SPEED=math.clamp(tonumber(v) or AUTO_BAT_SPEED,1,500)
        saveConfig()
    end)

    tpBatMode = "Original"
    local _,svTpBat=addToggleRow(cp,"TP Bat",tpBat1Enabled or tpBat2Enabled,2.75,nil,function(on)
        if on then startSelectedTpBat() else stopSelectedTpBat() end
        saveConfig()
    end)
    tpBat1SetVisual=function(on) if svTpBat then svTpBat(on) end end
    tpBat2SetVisual=function(on) if svTpBat then svTpBat(on) end end
    local _,svAutoSwing=addToggleRow(cp,"Auto Swing",autoSwingEnabled,2,nil,function(on) autoSwingEnabled=on;saveConfig() end)
    local _,svBatCounter=addToggleRow(cp,"Bat Counter",batCounterEnabled,3,nil,function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    setBatCounterVisual=svBatCounter
    addSectLbl(cp,"RAGDOLL",4)
        local _,svRagdoll=addToggleRow(cp,"Anti Ragdoll",antiRagdollEnabled,5,nil,function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
    setAntiRagVisual=svRagdoll
    local modes = {"Splatter", "No Splatter"}
    addCycleRow(cp, "Anti Ragdoll Mode", antiRagdollMode, 5.5, function()
        local idx = 1
        for i, m in ipairs(modes) do if m == antiRagdollMode then idx = i break end end
        idx = idx % #modes + 1
        antiRagdollMode = modes[idx]
        saveConfig()
        return antiRagdollMode
    end)
    if antiRagdollEnabled then svRagdoll(true) end
    local _,svMedusa=addToggleRow(cp,"Medusa Counter",medusaCounterEnabled,6,nil,function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setMedusaVisual=svMedusa
    local _,svUnwalk=addToggleRow(cp,"Unwalk",unwalkEnabled,7,nil,function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)
    setUnwalkVisual=svUnwalk
    addSectLbl(cp,"ACTIONS",9)
    local dropModes = {"Jump", "Stand"}
    addCycleRow(cp, "Drop Mode", dropMode, 9.5, function()
        local idx = 1
        for i, m in ipairs(dropModes) do if m == dropMode then idx = i break end end
        idx = idx % #dropModes + 1
        dropMode = dropModes[idx]
        saveConfig()
        return dropMode
    end)
    addActionRow(cp, "Insta Reset", "instaReset", function()
        cursedInstaReset()
    end, 10.5)
end)()

-- STEAL PAGE
;(function()
    local st=CategoryRefs.contents["Steal"]
    addSectLbl(st,"STEAL / GRAB",0)
    local barStyles={"V1","V2"}
    local barStyleIndex=1
    for i,style in ipairs(barStyles) do if style==Steal.BarStyle then barStyleIndex=i end end
    addCycleRow(st,"STEAL BAR STYLE",Steal.BarStyle,1,function()
        barStyleIndex=barStyleIndex%#barStyles+1
        Steal.BarStyle=barStyles[barStyleIndex]
        createStealBar()
        saveConfig()
        return Steal.BarStyle
    end)
    local _,setAutoStealVisual=addToggleRow(st,"Auto Steal",Steal.AutoStealEnabled,2.5,nil,function(on)
        Steal.AutoStealEnabled=on
        if on then startAutoSteal() else stopAutoSteal() end
        saveConfig()
    end)
    -- Reapply the saved state after creating the control so it appears active when rerun.
    setAutoStealVisual(Steal.AutoStealEnabled)
    addInputRow(st,"Steal Radius",Steal.StealRadius,3.5,function(v)
        Steal.StealRadius=math.clamp(tonumber(v) or Steal.StealRadius,1,500)
        saveConfig()
    end)
    addInputRow(st,"Steal Duration",Steal.StealDuration,4.5,function(v)
        local parsed=tonumber(v)
        if parsed then Steal.StealDuration=math.clamp(parsed,0.05,10) end
        saveConfig()
    end)
end)()

-- MOVEMENT PAGE
;(function()
    local mv=CategoryRefs.contents["Movement"]
    addSectLbl(mv,"AUTO PATHS",0)
    local _,svAutoLeft=addToggleRow(mv,"Auto Left",autoLeftEnabled,1,"autoLeft",function(on)
        if on then
            if tpBat1Enabled then stopTpBat() end
            if tpBat2Enabled then stopTpBat2() end
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true;startAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
        else autoLeftEnabled=false;stopAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        saveConfig()
    end)
    autoLeftSetVisual=svAutoLeft
    local _,svAutoRight=addToggleRow(mv,"Auto Right",autoRightEnabled,2,"autoRight",function(on)
        if on then
            if tpBat1Enabled then stopTpBat() end
            if tpBat2Enabled then stopTpBat2() end
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true;startAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
        else autoRightEnabled=false;stopAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        saveConfig()
    end)
    autoRightSetVisual=svAutoRight
    addSectLbl(mv,"SETTINGS",3)
    local _,svHoldJump=addToggleRow(mv,"Hold Jump",infJumpEnabled,4,nil,function(on)
        infJumpEnabled=on; if on then startHoldJump() else stopHoldJump() end; saveConfig()
    end)
    setInfJumpVisual=svHoldJump
end)()

-- VISUAL PAGE (with all new settings)
;(function()
    local vi=CategoryRefs.contents["Visual"]

    addSectLbl(vi,"VISUAL",0)
    addSectLbl(vi,"COLOR STYLE",0.5)
    local _,themeButton=addCycleRow(vi,"Color UI","Black",0.8,function()
        themeName="Black"
        themeIndex=1
        applyColorTheme("Black")
        return "Black"
    end)
    themeButton.Size=UDim2.new(0,88,0,24)
    themeButton.Text="Black"
    addToggleRow(vi,"Line ESP",lineESPEnabled,0.6,nil,function(on)
        lineESPEnabled=on==true
        if updateLineESP then updateLineESP() end
        saveConfig()
    end)
    addToggleRow(vi,"Animations Enabled",animEnabled,2,nil,function(on)
        animEnabled=on; if on then startAnimToggle() else stopAnimToggle() end; saveConfig()
    end)
    local animPackOrder={"Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut",'Wicked "Dancing Through Life"',"Werewolf","Superhero","Toy","No Boundaries","NFL","Amazon Unboxed","Vampire","Ninja","Robot","Levitation","Stylish","Bubbly","Cartoon"}
    local animPackIndex=table.find(animPackOrder,animPackName) or 1
    addCycleRow(vi,"Animation Pack",animPackName,2,function()
        animPackIndex=animPackIndex%#animPackOrder+1; animPackName=animPackOrder[animPackIndex]
        if animEnabled then
            startAnimToggle()
            if LP.Character then applyRembembiAnims(LP.Character) end
        end
        saveConfig(); return animPackName
    end)
    addToggleRow(vi,"Anti Lag",antiLagEnabled,3,nil,function(on)
        antiLagEnabled=on==true
        if on then enableAntiLag() else disableAntiLag() end
        saveConfig()
    end)
    addToggleRow(vi,"Saturación",saturatedColorsEnabled,3.5,nil,function(on)
        saturatedColorsEnabled=on==true
        if on then enableSaturatedColors() else disableSaturatedColors() end
        saveConfig()
    end)
    addToggleRow(vi,"Stretch Rez",stretchRezEnabled,4,nil,function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
    addToggleRow(vi,"Heartless Clothing",heartlessSkinEnabled,5.5,nil,function(on) setHeartlessSkinEnabled(on) end)
    -- Única skin disponible: la antigua Skin 5, ahora llamada Skin 1.
    addCycleRow(vi,"Clothing Style","Heartless Clothing",5.7,function()
        setHeartlessSkinMode("Skin1")
        return "Heartless Clothing"
    end)
        addToggleRow(vi,"Hide Head",hideHeadEnabled,6.5,nil,function(on) setHeartlessHeadHidden(on) end)
    addToggleRow(vi,"Hide Right Leg",rightLegHiddenEnabled,6.7,nil,function(on) setHeartlessRightLegHidden(on) end)
    addToggleRow(vi,"Black Smoke",blackSmokeEnabled,6.8,nil,function(on) setHeartlessBlackSmokeEnabled(on) end)
    local smokeColors={"Black","Gray","White"}; local smokeColorIndex=(smokeColor=="Gray" and 2) or (smokeColor=="White" and 3) or 1
    addCycleRow(vi,"Smoke Color",smokeColors[smokeColorIndex],6.9,function()
        smokeColorIndex=smokeColorIndex%#smokeColors+1
        setHeartlessSmokeColor(smokeColors[smokeColorIndex])
        return smokeColors[smokeColorIndex]
    end)
    addToggleRow(vi,"Crown",crownEnabled,6.9,nil,function(on) setHeartlessCrownEnabled(on) end)
    local crownStyles={"White","Black"}; local crownStyleIndex=(crownStyle=="Black") and 2 or 1
    addCycleRow(vi,"Crown Color",crownStyles[crownStyleIndex],7.0,function()
        crownStyleIndex=crownStyleIndex%#crownStyles+1
        setHeartlessCrownStyle(crownStyles[crownStyleIndex])
        return crownStyles[crownStyleIndex]
    end)
    -- TAB CHANGER
    addSectLbl(vi,"TAB CHANGER",6)
    local tabPositions = {"Left","Right","Top"}
    local tabIdx = 1
    for i, v in ipairs(tabPositions) do if v == tabPosition then tabIdx = i break end end
    local _, tabCycle = addCycleRow(vi, "Tab Position", tabPosition, 7, function()
        tabIdx = tabIdx % #tabPositions + 1
        tabPosition = tabPositions[tabIdx]
        rebuildGUILayout()
        saveConfig()
        return tabPosition
    end)

    -- BUTTON STYLE
    addSectLbl(vi,"MOBILE BUTTONS",8)
    addToggleRow(vi,"Lock / Unlock",uiLocked,8.05,nil,function(on)
        uiLocked=on==true
        saveConfig()
    end)
    addCycleRow(vi, "Reset Auto Left + Drop", "RESET", 8.15, function()
        resetAutoLeftDropControls()
        return "RESET"
    end)
    addToggleRow(vi, "Hide Buttons", not mobileButtonsVisible, 8.2, nil, function(on)
        setMobileButtonsVisible(not on)
        saveConfig()
    end)
    addCycleRow(vi, "Reset Mobile Buttons", "RESET", 8.5, function()
        resetMobileButtons()
        return "RESET"
    end)
    local styles = {"Cubes","Circular"}
    local styleIdx = 1
    for i, v in ipairs(styles) do if v == buttonStyle then styleIdx = i break end end
    local _, styleCycle = addCycleRow(vi, "Button Style", buttonStyle, 9, function()
        styleIdx = styleIdx % #styles + 1
        buttonStyle = styles[styleIdx]
        buildMobileButtons()
        saveConfig()
        return buttonStyle
    end)


    -- FOV
    addSectLbl(vi,"FOV",22)
    local fovRow=Instance.new("Frame"); fovRow.Size=UDim2.new(1,0,0,32); fovRow.BackgroundColor3=C.row
    fovRow.BackgroundTransparency=0.15; fovRow.BorderSizePixel=0; fovRow.LayoutOrder=23; fovRow.Parent=vi
    guiCorner(fovRow,10); guiStroke(fovRow,C.divider,1)
    local fovLbl=Instance.new("TextLabel",fovRow); fovLbl.Size=UDim2.new(0.5,0,0,16); fovLbl.Position=UDim2.new(0,12,0,6)
    fovLbl.BackgroundTransparency=1; fovLbl.Text="FOV"; fovLbl.TextColor3=Color3.fromRGB(255,255,255); fovLbl.TextSize=11; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextXAlignment=Enum.TextXAlignment.Left
    local fovBtn=Instance.new("TextButton",fovRow); fovBtn.Size=UDim2.new(0,52,0,22); fovBtn.Position=UDim2.new(1,-60,0.5,-11)
    fovBtn.BackgroundColor3=C.blue; fovBtn.BackgroundTransparency=0.15; fovBtn.BorderSizePixel=0
    fovBtn.Text=tostring(fovValue); fovBtn.TextColor3=C.white; fovBtn.TextSize=11; fovBtn.Font=Enum.Font.GothamBold; guiCorner(fovBtn,5)
    fovBtn.MouseButton1Click:Connect(function()
        fovIndex=fovIndex%#fovOptions+1; fovValue=fovOptions[fovIndex]; fovBtn.Text=tostring(fovValue); applyFOV(); saveConfig()
    end)
    local hov3=Instance.new("TextButton",fovRow); hov3.Size=UDim2.new(1,0,1,0); hov3.BackgroundTransparency=1; hov3.Text=""; hov3.ZIndex=0
    hov3.MouseEnter:Connect(function() tw(fovRow,{BackgroundTransparency=0.3}) end); hov3.MouseLeave:Connect(function() tw(fovRow,{BackgroundTransparency=0.15}) end)

    -- GUI HIDE KEY
    addSectLbl(vi,"GUI",24)
    local gRow=Instance.new("Frame"); gRow.Size=UDim2.new(1,0,0,36); gRow.BackgroundColor3=C.row
    gRow.BackgroundTransparency=0.15; gRow.BorderSizePixel=0; gRow.LayoutOrder=25; gRow.Parent=vi
    guiCorner(gRow,10); guiStroke(gRow,C.divider,1)
    local gLbl=Instance.new("TextLabel",gRow); gLbl.Size=UDim2.new(0.6,0,0,16); gLbl.Position=UDim2.new(0,12,0,8)
    gLbl.BackgroundTransparency=1; gLbl.Text="Hide GUI Key"; gLbl.TextColor3=Color3.fromRGB(255,255,255); gLbl.TextSize=11; gLbl.Font=Enum.Font.GothamBold; gLbl.TextXAlignment=Enum.TextXAlignment.Left
    local gKB=Instance.new("TextButton",gRow); gKB.Size=UDim2.new(0,45,0,22); gKB.Position=UDim2.new(1,-82,0.5,-11)
    gKB.BackgroundColor3=C.blue; gKB.BackgroundTransparency=0.15; gKB.BorderSizePixel=0; gKB.Text=prettyKey(Keys.guiHide)
    gKB.TextColor3=C.white; gKB.TextSize=9; gKB.Font=Enum.Font.GothamBold; guiCorner(gKB,5)
        gKB.MouseButton1Click:Connect(function() startKL(gKB,function(nk) Keys.guiHide=nk; gKB.Text=prettyKey(nk); saveConfig() end,"guiHide") end)
    local gClear=Instance.new("TextButton",gRow); gClear.Size=UDim2.new(0,22,0,22); gClear.Position=UDim2.new(1,-30,0.5,-11)
    gClear.BackgroundColor3=Color3.fromRGB(150,35,45); gClear.BackgroundTransparency=0.15; gClear.BorderSizePixel=0; gClear.Text="X"
    gClear.TextColor3=C.white; gClear.TextSize=11; gClear.Font=Enum.Font.GothamBlack; guiCorner(gClear,5)
    gClear.MouseButton1Click:Connect(function() Keys.guiHide=Enum.KeyCode.Unknown; gKB.Text="None"; saveConfig() end)
    -- RESET
    addSectLbl(vi,"RESET",26)
    local resetRow=Instance.new("Frame"); resetRow.Size=UDim2.new(1,0,0,32); resetRow.BackgroundColor3=C.row
    resetRow.BackgroundTransparency=0.15; resetRow.BorderSizePixel=0; resetRow.LayoutOrder=27; resetRow.Parent=vi
    guiCorner(resetRow,10); guiStroke(resetRow,C.divider,1)
    local resetLbl=Instance.new("TextLabel",resetRow); resetLbl.Size=UDim2.new(0.55,0,0,16); resetLbl.Position=UDim2.new(0,12,0,6)
    resetLbl.BackgroundTransparency=1; resetLbl.Text="Reset Settings"; resetLbl.TextColor3=Color3.fromRGB(255,255,255); resetLbl.TextSize=11; resetLbl.Font=Enum.Font.GothamBold; resetLbl.TextXAlignment=Enum.TextXAlignment.Left
    local resetBtn=Instance.new("TextButton",resetRow); resetBtn.Size=UDim2.new(0,52,0,22); resetBtn.Position=UDim2.new(1,-60,0.5,-11)
    resetBtn.BackgroundColor3=Color3.fromRGB(150,30,40); resetBtn.BackgroundTransparency=0.2; resetBtn.BorderSizePixel=0
    resetBtn.Text="RESET"; resetBtn.TextColor3=C.white; resetBtn.TextSize=9; resetBtn.Font=Enum.Font.GothamBold; guiCorner(resetBtn,5)
    resetBtn.MouseButton1Click:Connect(function() resetAllSettings() end)
    local hov4=Instance.new("TextButton",resetRow); hov4.Size=UDim2.new(1,0,1,0); hov4.BackgroundTransparency=1; hov4.Text=""; hov4.ZIndex=0
    hov4.MouseEnter:Connect(function() tw(resetRow,{BackgroundTransparency=0.3}) end); hov4.MouseLeave:Connect(function() tw(resetRow,{BackgroundTransparency=0.15}) end)
end)()
-- KEYBINDS PAGE: all shortcut assignment controls are kept here.
;(function()
    local kbPage=CategoryRefs.contents["Keybinds"]
    addSectLbl(kbPage,"KEYBINDS",0)
    local keyOrder={"circle","speed","guiHide","dropBrainrot","tpDown","instaReset","autoLeft","autoRight","tpBat"}
    local keyLabels={circle="Bat Aimbot",speed="Speed",guiHide="Hide GUI",dropBrainrot="Drop Brainrot",tpDown="TP Down",instaReset="Insta Reset",autoLeft="Auto Left",autoRight="Auto Right",tpBat="TP Bat"}
    for i,keyName in ipairs(keyOrder) do
        addKeybindRow(kbPage,keyLabels[keyName],keyName,i)
    end
end)()
-- KEYBOARD SHORTCUTS
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if UIS:GetFocusedTextBox() then return end
    if inp.KeyCode==Keys.guiHide then if GuiRefs.outer then if GuiRefs.outer.Visible then hideGui() else showGui() end end
    elseif inp.KeyCode==Keys.speedNormal then selectHeartlessSpeedProfile("Normal")
    elseif inp.KeyCode==Keys.speedLagger then selectHeartlessSpeedProfile("Lagger")
    elseif inp.KeyCode==Keys.speedCustom then selectHeartlessSpeedProfile("Custom")
    elseif inp.KeyCode==Keys.speed then speedToggleAction(); saveConfig()
    elseif inp.KeyCode==Keys.laggerToggle then toggleLaggerMode(); saveConfig()
    elseif inp.KeyCode==Keys.circle then autoBatEnabled=not autoBatEnabled; if autoBatEnabled then startBatAimbot() else stopBatAimbot() end; saveConfig()
    elseif inp.KeyCode==Keys.dropBrainrot then runDrop()
    elseif inp.KeyCode==Keys.tpDown then runTPFloor()
    elseif inp.KeyCode==Keys.tpBat then
        if tpBat1Enabled or tpBat2Enabled then stopSelectedTpBat() else startSelectedTpBat() end
        saveConfig()
    elseif inp.KeyCode==Keys.instaReset then cursedInstaReset()
    elseif inp.KeyCode==Keys.autoLeft then
        if autoLeftEnabled then
            autoLeftEnabled=false; stopAutoLeft()
        else
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true; startAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
        saveConfig()
    elseif inp.KeyCode==Keys.autoRight then
        if autoRightEnabled then
            autoRightEnabled=false; stopAutoRight()
        else
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true; startAutoRight()
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            saveConfig()
    end
end)


-- STARTUP
if infJumpEnabled then startHoldJump() end
if antiRagdollEnabled then startAntiRagdoll() end
if medusaCounterEnabled then setupMedusa(LP.Character) end
if animEnabled then startAnimToggle() end
if currentSkyTheme and currentSkyTheme~="Off" then
    task.delay(0.35,function()
        if CandyApplyCustomSky then pcall(CandyApplyCustomSky,currentSkyTheme) end
    end)
end
refreshHeartlessSpeedController()
    buildMobileButtons()
    applyColorTheme(themeName)
task.defer(function()
    startHeartlessVisualGuard()
    startEnemySpeedDisplay()
    task.wait(0.35)
    if not mobGuiRef or not mobGuiRef.Parent or not mobGuiRef:FindFirstChild("MobileButtons") then
        mobileButtonsBuildBusy=false
        buildMobileButtons()
        applyColorTheme(themeName)
    end
end)
end)() -- end GUI function

-- ============================================================
-- FORCE ALL MENU TEXT TO PURE WHITE
-- Keeps every menu label/button/input at RGB(255,255,255),
-- even if a theme, hover, click, or rebuild tries to recolor it.
-- ============================================================
local WHITE_MENU_TEXT = Color3.fromRGB(255,255,255)

local function forceMenuTextWhite(obj)
    if not obj then return end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        if obj.TextColor3 ~= WHITE_MENU_TEXT then
            obj.TextColor3 = WHITE_MENU_TEXT
        end
    end
end

local function installMenuWhiteGuard(root)
    if not root or root:GetAttribute("VaperWhiteTextGuard") then return end
    root:SetAttribute("VaperWhiteTextGuard", true)

    for _, obj in ipairs(root:GetDescendants()) do
        forceMenuTextWhite(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj:GetPropertyChangedSignal("TextColor3"):Connect(function()
                if obj.Parent then forceMenuTextWhite(obj) end
            end)
        end
    end

    root.DescendantAdded:Connect(function(obj)
        forceMenuTextWhite(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj:GetPropertyChangedSignal("TextColor3"):Connect(function()
                if obj.Parent then forceMenuTextWhite(obj) end
            end)
        end
    end)
end

installMenuWhiteGuard(GuiRefs.hub)
installMenuWhiteGuard(mobGuiRef)

print("Vaper.vs")
print("LEKAD BY FRNK33.")
