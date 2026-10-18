local GUI_NAME = "COOL_ESP_GUI"
local oldGui = game:GetService("CoreGui"):FindFirstChild(GUI_NAME)
if oldGui then oldGui:Destroy() end

local ok_main, err_main = pcall(function()

local function RandStr(len)
    local c = "abcdefghijklmnopqrstuvwxyz"
    local s = ""
    for _ = 1, len do
        local r = math.random(1, #c)
        s = s .. c:sub(r, r)
    end
    return s
end

local ID_HL  = RandStr(8)
local ID_BBG = RandStr(8)

local Library = {
    MenuName           = "Cool ESP",
    Enabled            = true,
    ESPTransparency    = 0.5,
    ShowNames          = true,
    ShowDistance       = true,
    TextSize           = 14,
    MenuVisible        = true,
    UpdateInterval     = 0.1,
    LookDirection      = false,
    ArrowSize          = 10,
    ProximityAlert     = false,
    ProximityThreshold = 500,
    ProximityTextSize  = false,
    ProximityFontSize  = 10,
    ESPLimitEnabled    = false,
    ESPLimit           = 10000,
    PredateTarget      = nil,
    SpectateTarget     = nil,
    HideKey            = Enum.KeyCode.RightShift,
    Presets            = { [1] = nil, [2] = nil, [3] = nil }
}

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

local SAVE_FILE = "cool_esp.json"

local function SaveSettings()
    local data = {
        MenuName           = Library.MenuName,
        Enabled            = Library.Enabled,
        ESPTransparency    = Library.ESPTransparency,
        ShowNames          = Library.ShowNames,
        ShowDistance       = Library.ShowDistance,
        TextSize           = Library.TextSize,
        UpdateInterval     = Library.UpdateInterval,
        LookDirection      = Library.LookDirection,
        ArrowSize          = Library.ArrowSize,
        ProximityAlert     = Library.ProximityAlert,
        ProximityThreshold = Library.ProximityThreshold,
        ProximityTextSize  = Library.ProximityTextSize,
        ProximityFontSize  = Library.ProximityFontSize,
        ESPLimitEnabled    = Library.ESPLimitEnabled,
        ESPLimit           = Library.ESPLimit,
        HideKey            = Library.HideKey.Name,
        Presets            = Library.Presets
    }
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if ok then pcall(function() writefile(SAVE_FILE, encoded) end) end
end

local function LoadSettings()
    local ok, content = pcall(function() return readfile(SAVE_FILE) end)
    if not ok or not content or content == "" then return end
    local ok2, d = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or not d then return end
    if d.MenuName           ~= nil then Library.MenuName           = d.MenuName           end
    if d.Enabled            ~= nil then Library.Enabled            = d.Enabled            end
    if d.ESPTransparency    ~= nil then Library.ESPTransparency    = d.ESPTransparency    end
    if d.ShowNames          ~= nil then Library.ShowNames          = d.ShowNames          end
    if d.ShowDistance       ~= nil then Library.ShowDistance       = d.ShowDistance       end
    if d.TextSize           ~= nil then Library.TextSize           = d.TextSize           end
    if d.UpdateInterval     ~= nil then Library.UpdateInterval     = d.UpdateInterval     end
    if d.LookDirection      ~= nil then Library.LookDirection      = d.LookDirection      end
    if d.ArrowSize          ~= nil then Library.ArrowSize          = d.ArrowSize          end
    if d.ProximityAlert     ~= nil then Library.ProximityAlert     = d.ProximityAlert     end
    if d.ProximityThreshold ~= nil then Library.ProximityThreshold = d.ProximityThreshold end
    if d.ProximityTextSize  ~= nil then Library.ProximityTextSize  = d.ProximityTextSize  end
    if d.ProximityFontSize  ~= nil then Library.ProximityFontSize  = d.ProximityFontSize  end
    if d.ESPLimitEnabled    ~= nil then Library.ESPLimitEnabled    = d.ESPLimitEnabled    end
    if d.ESPLimit           ~= nil then Library.ESPLimit           = d.ESPLimit           end
    if d.Presets            ~= nil then Library.Presets            = d.Presets            end
    if d.HideKey then
        local ok3, kc = pcall(function() return Enum.KeyCode[d.HideKey] end)
        if ok3 and kc then Library.HideKey = kc end
    end
end

LoadSettings()

local NORMAL_COLOR   = Color3.fromRGB(255, 255, 255)
local ALERT_COLOR    = Color3.fromRGB(255, 80,  80)
local SPECTATE_COLOR = Color3.fromRGB(80,  200, 255)

--------------------------------------------------------------------------------
-- PROXY SPECTATE
--------------------------------------------------------------------------------
local IsSpectating = false
local OriginalCFrame = nil
local SpectateConnection = nil

local function RestoreLocalPlayer()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = false
            if OriginalCFrame then
                hrp.CFrame = OriginalCFrame
                OriginalCFrame = nil
            end
        end
    end
end

local function StopSpectate()
    Library.SpectateTarget = nil
    IsSpectating = false

    if SpectateConnection then
        SpectateConnection:Disconnect()
        SpectateConnection = nil
    end

    RestoreLocalPlayer()
end

local function StartSpectate(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then 
        StopSpectate()
        return 
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        StopSpectate()
        return
    end

    Library.SpectateTarget = targetPlayer

    if not IsSpectating then
        OriginalCFrame = char.HumanoidRootPart.CFrame
        IsSpectating = true
    end

    if SpectateConnection then
        SpectateConnection:Disconnect()
    end

    SpectateConnection = RunService.RenderStepped:Connect(function()
        local lChar = LocalPlayer.Character
        local lHRP = lChar and lChar:FindFirstChild("HumanoidRootPart")
        local tPlayer = Library.SpectateTarget
        local tChar = tPlayer and tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")

        if not lChar or not lHRP or not tPlayer or not tChar or not tHRP or not tHum or tHum.Health <= 0 then
            StopSpectate()
            return
        end

        lHRP.Anchored = true

        for _, part in ipairs(lChar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 1
            end
        end

        lHRP.CFrame = tHRP.CFrame
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    IsSpectating = false
    OriginalCFrame = nil
    if SpectateConnection then
        SpectateConnection:Disconnect()
        SpectateConnection = nil
    end
end)

--------------------------------------------------------------------------------
-- ESP SYSTEM
--------------------------------------------------------------------------------
local function GetArrowAngle(head)
    if not head or not head.Parent then return 0 end
    local lv    = head.CFrame.LookVector
    local angle = math.deg(math.atan2(lv.X, -lv.Z))
    
    local cam = workspace.CurrentCamera
    if cam then
        local camLV = cam.CFrame.LookVector
        local camAngle = math.deg(math.atan2(camLV.X, -camLV.Z))
        angle = angle - camAngle
    end

    if angle < 0 then angle = angle + 360 end
    return math.floor((angle + 11.25) / 22.5) * 22.5
end

local PlayerESPData = {}

local function AttachESP(player, character)
    if player == LocalPlayer then return end

    local data = PlayerESPData[player]
    if not data then return end
    if data.Highlight and data.Highlight.Parent then data.Highlight:Destroy() end
    if data.BBG       and data.BBG.Parent       then data.BBG:Destroy()       end
    if data.ArrowBBG  and data.ArrowBBG.Parent  then data.ArrowBBG:Destroy()  end

    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    if PlayerESPData[player] ~= data then return end

    local hl = Instance.new("Highlight")
    hl.Name = ID_HL; hl.FillColor = NORMAL_COLOR; hl.OutlineColor = NORMAL_COLOR
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Enabled = Library.Enabled
    hl.FillTransparency = 0.95; hl.OutlineTransparency = Library.ESPTransparency
    hl.Parent = character; data.Highlight = hl

    local bbg = Instance.new("BillboardGui")
    bbg.Name = ID_BBG; bbg.Size = UDim2.new(0,160,0,30)
    bbg.StudsOffset = Vector3.new(0,3.2,0); bbg.AlwaysOnTop = true
    bbg.ResetOnSpawn = false; bbg.Parent = hrp; data.BBG = bbg

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1,0,1,0); nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = NORMAL_COLOR; nameLbl.TextStrokeTransparency = 0.4
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0); nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = Library.TextSize; nameLbl.Text = ""; nameLbl.Parent = bbg
    data.Label = nameLbl

    local sz = Library.ArrowSize
    local gSize = sz * 2

    local arrowBBG = Instance.new("BillboardGui")
    arrowBBG.Name = ID_BBG.."ar"
    arrowBBG.Size = UDim2.new(0, gSize, 0, gSize)
    arrowBBG.StudsOffset = Vector3.new(0, 9.5, 0)
    arrowBBG.AlwaysOnTop = true; arrowBBG.ResetOnSpawn = false
    arrowBBG.Enabled = Library.LookDirection
    arrowBBG.Parent = hrp
    data.ArrowBBG = arrowBBG

    local rotFrame = Instance.new("Frame")
    rotFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    rotFrame.Size = UDim2.new(1, 0, 1, 0)
    rotFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    rotFrame.BackgroundTransparency = 1
    rotFrame.BorderSizePixel = 0
    rotFrame.Rotation = 0
    rotFrame.Parent = arrowBBG
    data.RotFrame = rotFrame

    local arrowLbl = Instance.new("TextLabel")
    arrowLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    arrowLbl.Size = UDim2.new(1, 0, 1, 0)
    arrowLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
    arrowLbl.BackgroundTransparency = 1
    arrowLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    arrowLbl.TextStrokeTransparency = 0.15
    arrowLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    arrowLbl.Font = Enum.Font.GothamBlack
    arrowLbl.TextSize = gSize
    arrowLbl.TextScaled = false
    arrowLbl.Text = "▲"
    arrowLbl.ZIndex = 2
    arrowLbl.Parent = rotFrame
    data.ArrowLbl = arrowLbl

    data.Character = character
end

local function SetupPlayerESP(player)
    if player == LocalPlayer then return end
    PlayerESPData[player] = { Character=nil, Highlight=nil, BBG=nil, Label=nil, ArrowBBG=nil, RotFrame=nil, ArrowLbl=nil }
    local char = player.Character
    if char then task.wait(); AttachESP(player, char) end
    player.CharacterAdded:Connect(function(newChar) task.wait(); AttachESP(player, newChar) end)
end

for _, p in ipairs(Players:GetPlayers()) do task.spawn(SetupPlayerESP, p) end
Players.PlayerAdded:Connect(SetupPlayerESP)
Players.PlayerRemoving:Connect(function(player)
    if Library.PredateTarget  == player then Library.PredateTarget = nil end
    if Library.SpectateTarget == player then StopSpectate() end
    PlayerESPData[player] = nil
end)

local proxCounterLbl = nil
local LastFrameTime = 0

RunService.RenderStepped:Connect(function()
    pcall(function()
        local now = tick()
        if now - LastFrameTime < Library.UpdateInterval then return end
        LastFrameTime = now

        local localChar = LocalPlayer.Character
        local localHRP  = localChar and localChar:FindFirstChild("HumanoidRootPart")

        local localPhysPos = nil
        if IsSpectating and OriginalCFrame then
            localPhysPos = OriginalCFrame.Position
        elseif localHRP then
            localPhysPos = localHRP.Position
        end

        local refHRP = localHRP
        if Library.SpectateTarget ~= nil then
            local tChar = Library.SpectateTarget.Character
            local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
            if tHRP then refHRP = tHRP end
        end

        local proxCount = 0

        for player, data in pairs(PlayerESPData) do
            if player == LocalPlayer or player == Library.SpectateTarget then
                if data.Highlight then data.Highlight.Enabled = false end
                if data.Label     then data.Label.Visible     = false end
                if data.ArrowBBG  then data.ArrowBBG.Enabled  = false end
                continue
            end

            local character = data.Character
            local hrp       = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
            local alive     = hrp and humanoid and humanoid.Health > 0 and hrp:IsDescendantOf(workspace)

            if not data.Highlight or not data.Label then
                if data.ArrowBBG then data.ArrowBBG.Enabled = false end; continue
            end
            if not alive or not Library.Enabled then
                data.Highlight.Enabled = false; data.Label.Visible = false
                if data.ArrowBBG then data.ArrowBBG.Enabled = false end; continue
            end

            local dist      = refHRP and math.floor((hrp.Position - refHRP.Position).Magnitude) or 0
            local localDist = localPhysPos and math.floor((hrp.Position - localPhysPos).Magnitude) or 0
            local inProximity = Library.ProximityAlert and localPhysPos and (localDist <= Library.ProximityThreshold)

            if inProximity then proxCount = proxCount + 1 end

            local isPredateTarget = (Library.PredateTarget == player)

            if Library.ESPLimitEnabled and dist > Library.ESPLimit and not isPredateTarget then
                data.Highlight.Enabled = false; data.Label.Visible = false
                if data.ArrowBBG then data.ArrowBBG.Enabled = false end; continue
            end

            if Library.PredateTarget ~= nil and not isPredateTarget and not inProximity then
                data.Highlight.Enabled = false; data.Label.Visible = false
                if data.ArrowBBG then data.ArrowBBG.Enabled = false end; continue
            end

            data.Highlight.Enabled = true
            local isSpectateView = Library.SpectateTarget ~= nil
            local baseOutlineCol = isSpectateView and SPECTATE_COLOR or NORMAL_COLOR

            data.Highlight.OutlineColor = baseOutlineCol
            data.Highlight.FillColor = baseOutlineCol
            data.Highlight.OutlineTransparency = Library.ESPTransparency

            local textColor = inProximity and ALERT_COLOR or baseOutlineCol
            if data.Label.TextColor3 ~= textColor then data.Label.TextColor3 = textColor end

            local activeSize = Library.TextSize
            if inProximity and Library.ProximityTextSize then activeSize = Library.ProximityFontSize end

            local newText = (Library.ShowNames    and player.Name            or "")
                         .. (Library.ShowDistance and (" [" .. dist .. "s]") or "")
            if data.Label.Text     ~= newText    then data.Label.Text     = newText    end
            if data.Label.TextSize ~= activeSize then data.Label.TextSize = activeSize end
            data.Label.Visible = true

            local showArrow = Library.LookDirection and not inProximity
            if showArrow then
                local head = character:FindFirstChild("Head")
                if head then
                    local angle = GetArrowAngle(head)
                    local sz    = Library.ArrowSize
                    local gSize = sz * 2
                    if data.ArrowLbl.TextSize ~= gSize then
                        data.ArrowLbl.TextSize = gSize
                        data.ArrowBBG.Size = UDim2.new(0, gSize, 0, gSize)
                    end
                    data.RotFrame.Rotation = angle
                    data.ArrowBBG.Enabled  = true
                else
                    data.ArrowBBG.Enabled = false
                end
            else
                data.ArrowBBG.Enabled = false
            end
        end

        if proxCounterLbl then
            if Library.ProximityAlert then
                proxCounterLbl.Text = "Players in proximity range: "..proxCount
                proxCounterLbl.TextColor3 = proxCount > 0 and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,180,100)
            else
                proxCounterLbl.Text = "Proximity Alert is OFF — enable on page 3"
                proxCounterLbl.TextColor3 = Color3.fromRGB(90,90,90)
            end
        end
    end)
end)

--------------------------------------------------------------------------------
-- GUI INTERFACE
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME; ScreenGui.ResetOnSpawn = false; ScreenGui.Parent = CoreGui

local PRESET_PANEL_W = 125
local PANEL_W  = 260
local TITLE_H  = 42
local BTN_H    = 34
local BTN_GAP  = 8
local BTN_SIDE = 10
local HINT_H   = 22
local SLIDER_H = 54
local SEC_H    = 22
local INNER_W  = PANEL_W - BTN_SIDE * 2

local P1_H = 8 + (BTN_H+BTN_GAP)*4 + HINT_H+BTN_GAP + SLIDER_H+BTN_GAP + BTN_H+BTN_GAP + BTN_H + 16
local P2_H = 8 + SEC_H + BTN_H+BTN_GAP + SEC_H + SLIDER_H+BTN_GAP + SEC_H + SLIDER_H+BTN_GAP + SEC_H + BTN_H+BTN_GAP + SLIDER_H + 16
local P3_H = 8 + SEC_H + BTN_H+BTN_GAP + SLIDER_H+BTN_GAP + SEC_H + 30+8 + 30+8 + 28*5 + 16
local P4_H = 8 + SEC_H + 36+BTN_GAP + 30+8 + 30+8 + 28*5 + BTN_GAP + 36 + BTN_GAP + 32 + BTN_GAP + 50 + 16
local PANEL_H = TITLE_H + math.max(P1_H, P2_H, P3_H, P4_H)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,PANEL_W,0,PANEL_H); MainFrame.Position = UDim2.new(0.3,0,0.1,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14,14,14); MainFrame.BorderSizePixel = 0
MainFrame.Visible = true; MainFrame.Parent = ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,8)

--------------------------------------------------------------------------------
-- PRESET SLOTS PANEL
--------------------------------------------------------------------------------
local PRESET_PANEL_H = 260

local PresetFrame = Instance.new("Frame")
PresetFrame.Size = UDim2.new(0, PRESET_PANEL_W, 0, PRESET_PANEL_H)
PresetFrame.Position = UDim2.new(0, -PRESET_PANEL_W - 8, 0, 0)
PresetFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
PresetFrame.BorderSizePixel = 0
PresetFrame.Parent = MainFrame
Instance.new("UICorner", PresetFrame).CornerRadius = UDim.new(0, 8)

local PresetTitle = Instance.new("Frame")
PresetTitle.Size = UDim2.new(1, 0, 0, TITLE_H)
PresetTitle.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
PresetTitle.BorderSizePixel = 0
PresetTitle.Parent = PresetFrame
Instance.new("UICorner", PresetTitle).CornerRadius = UDim.new(0, 8)

local ptfill = Instance.new("Frame"); ptfill.Size = UDim2.new(1,0,0.5,0); ptfill.Position = UDim2.new(0,0,0.5,0)
ptfill.BackgroundColor3 = Color3.fromRGB(22,22,22); ptfill.BorderSizePixel = 0; ptfill.Parent = PresetTitle
local ptline = Instance.new("Frame"); ptline.Size = UDim2.new(1,0,0,2); ptline.Position = UDim2.new(0,0,1,-2)
ptline.BackgroundColor3 = Color3.fromRGB(50,50,50); ptline.BorderSizePixel = 0; ptline.Parent = PresetTitle

local PTitleLbl = Instance.new("TextLabel")
PTitleLbl.Size = UDim2.new(1, 0, 1, 0)
PTitleLbl.BackgroundTransparency = 1
PTitleLbl.Text = "SETS / PRESETS"
PTitleLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
PTitleLbl.Font = Enum.Font.GothamBlack
PTitleLbl.TextSize = 10
PTitleLbl.Parent = PresetTitle

local updateGUIElements = nil

local function SaveToSlot(slotNum)
    Library.Presets[slotNum] = {
        Enabled            = Library.Enabled,
        ESPTransparency    = Library.ESPTransparency,
        ShowNames          = Library.ShowNames,
        ShowDistance       = Library.ShowDistance,
        TextSize           = Library.TextSize,
        UpdateInterval     = Library.UpdateInterval,
        LookDirection      = Library.LookDirection,
        ArrowSize          = Library.ArrowSize,
        ProximityAlert     = Library.ProximityAlert,
        ProximityThreshold = Library.ProximityThreshold,
        ProximityTextSize  = Library.ProximityTextSize,
        ProximityFontSize  = Library.ProximityFontSize,
        ESPLimitEnabled    = Library.ESPLimitEnabled,
        ESPLimit           = Library.ESPLimit,
    }
    SaveSettings()
end

local function ApplyFromSlot(slotNum)
    local p = Library.Presets[slotNum]
    if not p then return end
    Library.Enabled            = p.Enabled
    Library.ESPTransparency    = p.ESPTransparency
    Library.ShowNames          = p.ShowNames
    Library.ShowDistance       = p.ShowDistance
    Library.TextSize           = p.TextSize
    Library.UpdateInterval     = p.UpdateInterval
    Library.LookDirection      = p.LookDirection
    Library.ArrowSize          = p.ArrowSize
    Library.ProximityAlert     = p.ProximityAlert
    Library.ProximityThreshold = p.ProximityThreshold
    Library.ProximityTextSize  = p.ProximityTextSize
    Library.ProximityFontSize  = p.ProximityFontSize
    Library.ESPLimitEnabled    = p.ESPLimitEnabled
    Library.ESPLimit           = p.ESPLimit

    if updateGUIElements then updateGUIElements() end
    SaveSettings()
end

local function ClearSlot(slotNum)
    Library.Presets[slotNum] = nil
    SaveSettings()
end

local slotUI = {}

local function BuildPresetSlots()
    local startY = TITLE_H + 8
    local slotH = (PRESET_PANEL_H - TITLE_H - 24) / 3

    for i = 1, 3 do
        local slotY = startY + (i - 1) * (slotH + 4)

        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -12, 0, slotH)
        container.Position = UDim2.new(0, 6, 0, slotY)
        container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        container.BorderSizePixel = 0
        container.Parent = PresetFrame
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

        local iconBox = Instance.new("Frame")
        iconBox.Size = UDim2.new(0, 36, 1, -8)
        iconBox.Position = UDim2.new(0, 4, 0, 4)
        iconBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        iconBox.BorderSizePixel = 0
        iconBox.Parent = container
        Instance.new("UICorner", iconBox).CornerRadius = UDim.new(0, 4)

        local plusLbl = Instance.new("TextLabel")
        plusLbl.Size = UDim2.new(1, 0, 1, 0)
        plusLbl.BackgroundTransparency = 1
        plusLbl.Text = "+"
        plusLbl.TextColor3 = Color3.fromRGB(70, 70, 70)
        plusLbl.Font = Enum.Font.GothamBold
        plusLbl.TextSize = 18
        plusLbl.Parent = iconBox

        local numLbl = Instance.new("TextLabel")
        numLbl.Size = UDim2.new(0, 12, 0, 12)
        numLbl.Position = UDim2.new(0, 2, 0, 2)
        numLbl.BackgroundTransparency = 1
        numLbl.Text = tostring(i)
        numLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
        numLbl.Font = Enum.Font.GothamBold
        numLbl.TextSize = 9
        numLbl.Parent = iconBox

        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, -48, 1, -8)
        btnContainer.Position = UDim2.new(0, 44, 0, 4)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = container

        local subBtnH = (slotH - 8 - 4) / 3

        local function MakeSubBtn(text, order, color)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, subBtnH)
            b.Position = UDim2.new(0, 0, 0, (order - 1) * (subBtnH + 2))
            b.BackgroundColor3 = color
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Text = text
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 8
            b.Parent = btnContainer
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
            return b
        end

        local setBtn   = MakeSubBtn("Set", 1, Color3.fromRGB(180, 110, 20))
        local applyBtn = MakeSubBtn("Apply", 2, Color3.fromRGB(34, 130, 58))
        local clearBtn = MakeSubBtn("Clear", 3, Color3.fromRGB(140, 40, 40))

        slotUI[i] = { IconBox = iconBox, Plus = plusLbl }

        local function UpdateSlotVisual()
            local hasData = Library.Presets[i] ~= nil
            if hasData then
                plusLbl.TextColor3 = Color3.fromRGB(80, 200, 255)
                iconBox.BackgroundColor3 = Color3.fromRGB(20, 45, 60)
            else
                plusLbl.TextColor3 = Color3.fromRGB(70, 70, 70)
                iconBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            end
        end

        setBtn.MouseButton1Click:Connect(function()
            SaveToSlot(i)
            UpdateSlotVisual()
        end)

        applyBtn.MouseButton1Click:Connect(function()
            ApplyFromSlot(i)
        end)

        clearBtn.MouseButton1Click:Connect(function()
            ClearSlot(i)
            UpdateSlotVisual()
        end)

        UpdateSlotVisual()
    end
end

BuildPresetSlots()

--------------------------------------------------------------------------------
-- MAIN TITLE & PANEL LOGIC
--------------------------------------------------------------------------------
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,TITLE_H); TitleBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
TitleBar.BorderSizePixel = 0; TitleBar.Parent = MainFrame
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,8)
local tfill = Instance.new("Frame"); tfill.Size = UDim2.new(1,0,0.5,0); tfill.Position = UDim2.new(0,0,0.5,0)
tfill.BackgroundColor3 = Color3.fromRGB(22,22,22); tfill.BorderSizePixel = 0; tfill.Parent = TitleBar
local tline = Instance.new("Frame"); tline.Size = UDim2.new(1,0,0,2); tline.Position = UDim2.new(0,0,1,-2)
tline.BackgroundColor3 = Color3.fromRGB(50,50,50); tline.BorderSizePixel = 0; tline.Parent = TitleBar

local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.new(0,24,0,28); prevBtn.Position = UDim2.new(0,6,0.5,-14)
prevBtn.Text = "←"; prevBtn.TextColor3 = Color3.fromRGB(180,180,180); prevBtn.BackgroundTransparency = 1
prevBtn.Font = Enum.Font.GothamBold; prevBtn.TextSize = 14; prevBtn.BorderSizePixel = 0; prevBtn.ZIndex = 3; prevBtn.Parent = TitleBar

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0,24,0,28); nextBtn.Position = UDim2.new(1,-30,0.5,-14)
nextBtn.Text = "→"; nextBtn.TextColor3 = Color3.fromRGB(180,180,180); nextBtn.BackgroundTransparency = 1
nextBtn.Font = Enum.Font.GothamBold; nextBtn.TextSize = 14; nextBtn.BorderSizePixel = 0; nextBtn.ZIndex = 3; nextBtn.Parent = TitleBar

local TitleText = Instance.new("TextBox")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Position = UDim2.new(0, 0, 0, 0)
TitleText.Text = Library.MenuName
TitleText.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleText.BackgroundTransparency = 1
TitleText.TextSize = 11
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextXAlignment = Enum.TextXAlignment.Center
TitleText.ClearTextOnFocus = false
TitleText.ZIndex = 2
TitleText.Parent = TitleBar

local PageLbl = Instance.new("TextLabel")
PageLbl.Size = UDim2.new(0,58,1,0); PageLbl.Position = UDim2.new(1,-90,0,0)
PageLbl.BackgroundTransparency = 1; PageLbl.TextColor3 = Color3.fromRGB(160,160,160)
PageLbl.Font = Enum.Font.GothamBold; PageLbl.TextSize = 10
PageLbl.TextXAlignment = Enum.TextXAlignment.Right
PageLbl.ZIndex = 3
PageLbl.Text = "Page 1"
PageLbl.Parent = TitleBar

local MAX_NAME_LENGTH = 18
TitleText:GetPropertyChangedSignal("Text"):Connect(function()
    if #TitleText.Text > MAX_NAME_LENGTH then
        TitleText.Text = string.sub(TitleText.Text, 1, MAX_NAME_LENGTH)
    end
end)

TitleText.FocusLost:Connect(function()
    if TitleText.Text == "" then
        TitleText.Text = "Cool ESP"
    end
    Library.MenuName = TitleText.Text
    SaveSettings()
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,3); tabBar.Position = UDim2.new(0,0,1,0)
tabBar.BackgroundColor3 = Color3.fromRGB(34,130,58); tabBar.BorderSizePixel = 0; tabBar.Parent = TitleBar
Instance.new("UICorner",tabBar).CornerRadius = UDim.new(0,2)

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local function MakeButton(parent, label, yPos, onColor, offColor, isOn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-(BTN_SIDE*2),0,BTN_H); btn.Position = UDim2.new(0,BTN_SIDE,0,yPos)
    btn.BackgroundColor3 = isOn and onColor or offColor; btn.BorderSizePixel = 0
    btn.AutoButtonColor = false; btn.Text = ""; btn.Parent = parent
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,5)
    local nl = Instance.new("TextLabel"); nl.Size = UDim2.new(0.7,0,1,0); nl.Position = UDim2.new(0,12,0,0)
    nl.BackgroundTransparency = 1; nl.TextColor3 = Color3.fromRGB(255,255,255)
    nl.Font = Enum.Font.GothamSemibold; nl.TextSize = 12
    nl.TextXAlignment = Enum.TextXAlignment.Left; nl.Text = label; nl.Parent = btn
    local st = Instance.new("TextLabel"); st.Size = UDim2.new(0,36,1,0); st.Position = UDim2.new(1,-44,0,0)
    st.BackgroundTransparency = 1; st.TextColor3 = Color3.fromRGB(255,255,255); st.TextTransparency = 0.35
    st.Font = Enum.Font.Gotham; st.TextSize = 10; st.TextXAlignment = Enum.TextXAlignment.Right
    st.Text = isOn and "ON" or "OFF"; st.Parent = btn
    return btn, st
end

local function MakeSlider(parent, label, yPos, initVal, minVal, maxVal, isInt, fillColor, fmtFn)
    local sec = Instance.new("Frame"); sec.Size = UDim2.new(1,-(BTN_SIDE*2),0,SLIDER_H); sec.Position = UDim2.new(0,BTN_SIDE,0,yPos)
    sec.BackgroundColor3 = Color3.fromRGB(22,22,22); sec.BorderSizePixel = 0; sec.Parent = parent
    Instance.new("UICorner",sec).CornerRadius = UDim.new(0,5)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0.6,0,0,20); lbl.Position = UDim2.new(0,10,0,6)
    lbl.Text = label; lbl.TextColor3 = Color3.fromRGB(160,160,160); lbl.BackgroundTransparency = 1
    lbl.TextSize = 10; lbl.Font = Enum.Font.GothamSemibold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = sec
    local vl = Instance.new("TextLabel"); vl.Size = UDim2.new(0.4,-10,0,20); vl.Position = UDim2.new(0.6,0,0,6)
    vl.TextColor3 = Color3.fromRGB(200,200,200); vl.BackgroundTransparency = 1; vl.TextSize = 10
    vl.Font = Enum.Font.GothamSemibold; vl.TextXAlignment = Enum.TextXAlignment.Right; vl.Parent = sec
    local bar = Instance.new("Frame"); bar.Size = UDim2.new(1,-20,0,4); bar.Position = UDim2.new(0,10,0,36)
    bar.BackgroundColor3 = Color3.fromRGB(45,45,45); bar.BorderSizePixel = 0
    Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0); bar.Parent = sec
    local fill = Instance.new("Frame"); fill.BackgroundColor3 = fillColor or Color3.fromRGB(90,170,245)
    fill.BorderSizePixel = 0; Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0); fill.Parent = bar
    local dot = Instance.new("Frame"); dot.Size = UDim2.new(0,14,0,14)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0
    Instance.new("UICorner",dot).CornerRadius = UDim.new(1,0); dot.Parent = bar
    local onChange = nil
    local function SetVal(v)
        local cl = math.clamp(v,minVal,maxVal); local p = (cl-minVal)/(maxVal-minVal)
        fill.Size = UDim2.new(p,0,1,0); dot.Position = UDim2.new(p,-7,0.5,-7)
        if isInt then cl = math.floor(cl) end
        vl.Text = fmtFn and fmtFn(cl) or tostring(cl); return cl
    end
    SetVal(initVal)
    local dt = false
    sec.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dt=true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dt=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dt and i.UserInputType==Enum.UserInputType.MouseMovement then
            local v = minVal+math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)*(maxVal-minVal)
            if isInt then v=math.floor(v) end; SetVal(v); if onChange then onChange(v) end
        end
    end)
    return sec, function(cb) onChange=cb end, SetVal
end

local function MakeHint(parent, text, yPos)
    local box = Instance.new("Frame"); box.Size = UDim2.new(1,-(BTN_SIDE*2),0,HINT_H); box.Position = UDim2.new(0,BTN_SIDE,0,yPos)
    box.BackgroundColor3 = Color3.fromRGB(28,28,28); box.BorderSizePixel = 0; box.Parent = parent
    Instance.new("UICorner",box).CornerRadius = UDim.new(0,4)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(120,120,120); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 10; lbl.Parent = box
    return box, lbl
end

local function MakeSecLabel(parent, text, yPos)
    local line = Instance.new("Frame"); line.Size = UDim2.new(1,-(BTN_SIDE*2),0,1); line.Position = UDim2.new(0,BTN_SIDE,0,yPos)
    line.BackgroundColor3 = Color3.fromRGB(38,38,38); line.BorderSizePixel = 0; line.Parent = parent
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-(BTN_SIDE*2),0,16); l.Position = UDim2.new(0,BTN_SIDE,0,yPos+4)
    l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(90,90,90)
    l.Font = Enum.Font.GothamSemibold; l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left; l.Text = text; l.Parent = parent
end

local function MakePlayerList(parent, yPos, getTarget, setTarget, rowColor, nameColor)
    local ROW_H = 28; local MAX_ROWS = 5

    local targetBar = Instance.new("Frame"); targetBar.Size = UDim2.new(1,-(BTN_SIDE*2),0,30); targetBar.Position = UDim2.new(0,BTN_SIDE,0,yPos)
    targetBar.BackgroundColor3 = Color3.fromRGB(22,22,22); targetBar.BorderSizePixel = 0; targetBar.Parent = parent
    Instance.new("UICorner",targetBar).CornerRadius = UDim.new(0,5)
    local targetLbl = Instance.new("TextLabel"); targetLbl.Size = UDim2.new(0.72,0,1,0); targetLbl.Position = UDim2.new(0,10,0,0)
    targetLbl.BackgroundTransparency = 1; targetLbl.TextColor3 = Color3.fromRGB(160,160,160)
    targetLbl.Font = Enum.Font.GothamSemibold; targetLbl.TextSize = 11; targetLbl.TextXAlignment = Enum.TextXAlignment.Left
    targetLbl.Text = "No target"; targetLbl.Parent = targetBar
    local clearBtn = Instance.new("TextButton"); clearBtn.Size = UDim2.new(0,48,0,22); clearBtn.Position = UDim2.new(1,-54,0.5,-11)
    clearBtn.BackgroundColor3 = Color3.fromRGB(120,30,30); clearBtn.BorderSizePixel = 0; clearBtn.AutoButtonColor = false
    clearBtn.Text = "Clear"; clearBtn.TextColor3 = Color3.fromRGB(255,255,255); clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextSize = 10; clearBtn.Parent = targetBar
    Instance.new("UICorner",clearBtn).CornerRadius = UDim.new(0,4)
    yPos = yPos+30+8

    local function UpdateDisplay()
        local t = getTarget()
        if t then targetLbl.Text = "Target: "..t.Name; targetLbl.TextColor3 = nameColor
        else targetLbl.Text = "No target"; targetLbl.TextColor3 = Color3.fromRGB(160,160,160) end
    end

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1,-(BTN_SIDE*2),0,30); searchBox.Position = UDim2.new(0,BTN_SIDE,0,yPos)
    searchBox.BackgroundColor3 = Color3.fromRGB(28,28,28); searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "Type player name..."; searchBox.PlaceholderColor3 = Color3.fromRGB(65,65,65)
    searchBox.Text = ""; searchBox.TextColor3 = Color3.fromRGB(220,220,220)
    searchBox.Font = Enum.Font.GothamSemibold; searchBox.TextSize = 12
    searchBox.ClearTextOnFocus = false; searchBox.Parent = parent
    Instance.new("UICorner",searchBox).CornerRadius = UDim.new(0,5)
    yPos = yPos+30+8

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1,-(BTN_SIDE*2),0,ROW_H*MAX_ROWS); listFrame.Position = UDim2.new(0,BTN_SIDE,0,yPos)
    listFrame.BackgroundColor3 = Color3.fromRGB(20,20,20); listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4; listFrame.ScrollBarImageColor3 = Color3.fromRGB(90,90,90)
    listFrame.CanvasSize = UDim2.new(0,0,0,0); listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Parent = parent
    Instance.new("UICorner",listFrame).CornerRadius = UDim.new(0,5)
    Instance.new("UIListLayout",listFrame).SortOrder = Enum.SortOrder.LayoutOrder

    local rows = {}
    local function Rebuild(q)
        for _,r in pairs(rows) do r:Destroy() end; rows={}
        q = string.lower(q); local count = 0
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LocalPlayer then continue end
            if q~="" and not string.find(string.lower(p.Name),q,1,true) then continue end
            count=count+1
            local isTarget = getTarget()==p
            local row = Instance.new("TextButton")
            row.Size = UDim2.new(1,0,0,ROW_H)
            row.BackgroundColor3 = isTarget and rowColor or Color3.fromRGB(28,28,28)
            row.BorderSizePixel = 0; row.AutoButtonColor = false; row.Text = ""; row.LayoutOrder = count; row.Parent = listFrame
            local nl = Instance.new("TextLabel"); nl.Size = UDim2.new(1,-12,1,0); nl.Position = UDim2.new(0,10,0,0)
            nl.BackgroundTransparency = 1
            nl.TextColor3 = isTarget and nameColor or Color3.fromRGB(210,210,210)
            nl.Font = Enum.Font.GothamSemibold; nl.TextSize = 11; nl.TextXAlignment = Enum.TextXAlignment.Left
            nl.Text = p.Name; nl.Parent = row
            local pl = p
            row.MouseButton1Click:Connect(function()
                local newT = (getTarget() == pl) and nil or pl
                setTarget(newT)
                UpdateDisplay(); Rebuild(searchBox.Text)
            end)
            table.insert(rows, row)
        end
    end

    Rebuild("")
    clearBtn.MouseButton1Click:Connect(function() 
        setTarget(nil)
        UpdateDisplay(); Rebuild(searchBox.Text) 
    end)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function() Rebuild(searchBox.Text) end)
    Players.PlayerAdded:Connect(function() Rebuild(searchBox.Text) end)
    Players.PlayerRemoving:Connect(function(p)
        if getTarget()==p then setTarget(nil); UpdateDisplay() end
        task.wait(); Rebuild(searchBox.Text)
    end)
    UpdateDisplay()
    return yPos + ROW_H*MAX_ROWS
end

local pages = {}
local TAB_COLORS = {
    Color3.fromRGB(34,130,58),
    Color3.fromRGB(30,110,200),
    Color3.fromRGB(130,40,180),
    Color3.fromRGB(20,140,180),
}
for i = 1, 4 do
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,-TITLE_H); f.Position = UDim2.new(0,0,0,TITLE_H)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.Visible = (i==1); f.Parent = MainFrame
    pages[i] = f
end
local P1,P2,P3,P4 = pages[1],pages[2],pages[3],pages[4]

--------------------------------------------------------------------------------
-- GUIDE PANEL
--------------------------------------------------------------------------------
local GUIDE_W = 240
local guideOpen = false
local GuidePanel = Instance.new("Frame")
GuidePanel.Size = UDim2.new(0,GUIDE_W,0,PANEL_H); GuidePanel.Position = UDim2.new(0,PANEL_W+8,0,0)
GuidePanel.BackgroundColor3 = Color3.fromRGB(16,16,16); GuidePanel.BorderSizePixel = 0
GuidePanel.Visible = false; GuidePanel.Parent = MainFrame
Instance.new("UICorner",GuidePanel).CornerRadius = UDim.new(0,8)
local GH = Instance.new("Frame"); GH.Size = UDim2.new(1,0,0,TITLE_H); GH.BackgroundColor3 = Color3.fromRGB(140,88,14)
GH.BorderSizePixel = 0; GH.Parent = GuidePanel; Instance.new("UICorner",GH).CornerRadius = UDim.new(0,8)
local ghFill = Instance.new("Frame"); ghFill.Size = UDim2.new(1,0,0.5,0); ghFill.Position = UDim2.new(0,0,0.5,0)
ghFill.BackgroundColor3 = Color3.fromRGB(140,88,14); ghFill.BorderSizePixel = 0; ghFill.Parent = GH
local GHTitleL = Instance.new("TextLabel"); GHTitleL.Size = UDim2.new(1,-70,1,0); GHTitleL.Position = UDim2.new(0,12,0,0)
GHTitleL.BackgroundTransparency = 1; GHTitleL.TextColor3 = Color3.fromRGB(255,255,255)
GHTitleL.Font = Enum.Font.GothamBlack; GHTitleL.TextSize = 11; GHTitleL.TextXAlignment = Enum.TextXAlignment.Left
GHTitleL.Text = "Cool ESP — Full Guide"; GHTitleL.Parent = GH
local backBtn = Instance.new("TextButton"); backBtn.Size = UDim2.new(0,54,0,26); backBtn.Position = UDim2.new(1,-60,0.5,-13)
backBtn.BackgroundColor3 = Color3.fromRGB(90,55,8); backBtn.BorderSizePixel = 0; backBtn.AutoButtonColor = false
backBtn.Text = "← Back"; backBtn.TextColor3 = Color3.fromRGB(255,255,255)
backBtn.Font = Enum.Font.GothamBold; backBtn.TextSize = 10; backBtn.Parent = GH
Instance.new("UICorner",backBtn).CornerRadius = UDim.new(0,4)
local GScroll = Instance.new("ScrollingFrame")
GScroll.Size = UDim2.new(1,0,1,-TITLE_H); GScroll.Position = UDim2.new(0,0,0,TITLE_H)
GScroll.BackgroundTransparency = 1; GScroll.BorderSizePixel = 0
GScroll.ScrollBarThickness = 4; GScroll.ScrollBarImageColor3 = Color3.fromRGB(140,88,14)
GScroll.CanvasSize = UDim2.new(0,0,0,0); GScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
GScroll.Parent = GuidePanel
Instance.new("UIListLayout",GScroll).Padding = UDim.new(0,0)
local GPad = Instance.new("UIPadding")
GPad.PaddingLeft = UDim.new(0,12); GPad.PaddingRight = UDim.new(0,12)
GPad.PaddingTop = UDim.new(0,10); GPad.PaddingBottom = UDim.new(0,14); GPad.Parent = GScroll

local function GS(t,c) local l=Instance.new("TextLabel");l.Size=UDim2.new(1,0,0,0);l.AutomaticSize=Enum.AutomaticSize.Y;l.BackgroundTransparency=1;l.TextColor3=c or Color3.fromRGB(255,215,0);l.Font=Enum.Font.GothamBlack;l.TextSize=11;l.TextWrapped=true;l.TextXAlignment=Enum.TextXAlignment.Left;l.Text=t;l.Parent=GScroll end
local function GP(t) local l=Instance.new("TextLabel");l.Size=UDim2.new(1,0,0,0);l.AutomaticSize=Enum.AutomaticSize.Y;l.BackgroundTransparency=1;l.TextColor3=Color3.fromRGB(185,185,185);l.Font=Enum.Font.Gotham;l.TextSize=10;l.TextWrapped=true;l.TextXAlignment=Enum.TextXAlignment.Left;l.Text=t;l.Parent=GScroll end
local function GSp(h) local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,h or 7);f.BackgroundTransparency=1;f.BorderSizePixel=0;f.Parent=GScroll end
local function GDv() local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,1);f.BackgroundColor3=Color3.fromRGB(38,38,38);f.BorderSizePixel=0;f.Parent=GScroll;GSp(6) end

-- Guide Content
GS("ABOUT THIS SCRIPT")
GP("This is an advanced ESP system providing player tracking, proximity alerts, look direction tracking, custom preset slots, and spectating features.")
GSp();GDv()

GS("PAGE 1 — CORE ESP", Color3.fromRGB(34,200,80))
GP("• ESP Switch: Master toggle for all visual overlays.") GSp(3)
GP("• Names: Displays target player usernames.") GSp(3)
GP("• Distance: Shows exact distance in studs [Xs].") GSp(3)
GP("• Text Size: Cycles overlay text size through various font scaling levels.") GSp(3)
GP("• Transparency: Adjusts the outline transparency of player highlights.") GSp(3)
GP("• Hide Key: Sets the keybind used to show or hide the menu UI (Default: RightShift).")
GSp();GDv()

GS("PAGE 2 — VISUALS & LIMITS", Color3.fromRGB(30,150,255))
GP("• Look Direction: Displays a rotating directional arrow (▲) above players to show where they are facing.") GSp(3)
GP("• Arrow Size: Scales the size of the directional arrow.") GSp(3)
GP("• Refresh Rate: Controls how frequently ESP position data updates (0.05s - 1.0s).") GSp(3)
GP("• ESP Limit: Toggles distance restriction so players beyond the set distance studs will not render.")
GSp();GDv()

GS("PAGE 3 — PROXIMITY & PREDATE", Color3.fromRGB(200,80,255))
GP("• Proximity Alert: Displays nearby player text in red when inside alert range. Box outline remains standard.") GSp(3)
GP("• Prox Text Size: Toggles dynamic text sizing when a player is within proximity.") GSp(3)
GP("• Predate Target: Locks ESP focus onto a single target from the player list, hiding non-proximity players. Bypasses the ESP distance limiter!")
GSp();GDv()

GS("PAGE 4 — SPECTATE & UTILS", Color3.fromRGB(20,180,220))
GP("• Proxy Spectate: Smoothly mirrors target viewpoint without breaking camera controls.") GSp(3)
GP("• Proximity Counter: Real-time counter showing how many players are inside your alert range.")
GSp();GDv()

GS("LEFT PANEL — PRESET SLOTS", Color3.fromRGB(255,180,30))
GP("• Set: Saves your current menu settings to the slot.") GSp(3)
GP("• Apply: Instantly loads settings saved in that slot.") GSp(3)
GP("• Clear: Resets the preset slot.")
GSp();GDv()

GS("CUSTOM TITLE BAR", Color3.fromRGB(255,215,0))
GP("• Click directly on the title text at the top center to rename the menu! (Max 18 characters).")
GSp(12)

local currentPage = 1
local function SetPage(p)
    currentPage = p
    for i,f in ipairs(pages) do f.Visible=(i==p) end
    PageLbl.Text = "Page " .. p
    tabBar.BackgroundColor3 = TAB_COLORS[p] or Color3.fromRGB(34,130,58)
    GuidePanel.Visible = guideOpen
end

prevBtn.MouseButton1Click:Connect(function() SetPage(currentPage == 1 and 4 or currentPage - 1) end)
nextBtn.MouseButton1Click:Connect(function() SetPage(currentPage == 4 and 1 or currentPage + 1) end)

-- PAGE 1
local y = 8
local b1,s1 = MakeButton(P1,"ESP",      y,Color3.fromRGB(34,130,58), Color3.fromRGB(20,55,28),  Library.Enabled);      y=y+BTN_H+BTN_GAP
local b2,s2 = MakeButton(P1,"Names",    y,Color3.fromRGB(30,110,200),Color3.fromRGB(16,44,80),  Library.ShowNames);    y=y+BTN_H+BTN_GAP
local b3,s3 = MakeButton(P1,"Distance", y,Color3.fromRGB(122,58,185),Color3.fromRGB(50,24,75),  Library.ShowDistance); y=y+BTN_H+BTN_GAP
local b4,s4 = MakeButton(P1,"Text Size",y,Color3.fromRGB(185,110,16),Color3.fromRGB(75,44,8),   true)
s4.Text = tostring(Library.TextSize); y=y+BTN_H+BTN_GAP
local _,hintLbl = MakeHint(P1,"— hide key: "..Library.HideKey.Name.." —",y); y=y+HINT_H+BTN_GAP
local _,onTrans,setTransVal = MakeSlider(P1,"Transparency",y,Library.ESPTransparency,0,1,false,
    Color3.fromRGB(90,170,245),function(v) return math.floor(v*100).."%" end)
onTrans(function(v) Library.ESPTransparency=v; SaveSettings() end)
y=y+SLIDER_H+BTN_GAP
local kbBtn = Instance.new("TextButton"); kbBtn.Size = UDim2.new(1,-(BTN_SIDE*2),0,BTN_H); kbBtn.Position = UDim2.new(0,BTN_SIDE,0,y)
kbBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); kbBtn.BorderSizePixel = 0; kbBtn.AutoButtonColor = false; kbBtn.Text = ""; kbBtn.Parent = P1
Instance.new("UICorner",kbBtn).CornerRadius = UDim.new(0,5)
local kbL = Instance.new("TextLabel"); kbL.Size = UDim2.new(0.5,0,1,0); kbL.Position = UDim2.new(0,12,0,0)
kbL.BackgroundTransparency = 1; kbL.TextColor3 = Color3.fromRGB(200,200,200); kbL.Font = Enum.Font.GothamSemibold
kbL.TextSize = 11; kbL.TextXAlignment = Enum.TextXAlignment.Left; kbL.Text = "Hide Key"; kbL.Parent = kbBtn
local kbR = Instance.new("TextLabel"); kbR.Size = UDim2.new(0.5,-12,1,0); kbR.Position = UDim2.new(0.5,0,0,0)
kbR.BackgroundTransparency = 1; kbR.TextColor3 = Color3.fromRGB(160,160,160); kbR.Font = Enum.Font.Gotham
kbR.TextSize = 10; kbR.TextXAlignment = Enum.TextXAlignment.Right; kbR.Text = "["..Library.HideKey.Name.."]"; kbR.Parent = kbBtn
y=y+BTN_H+BTN_GAP
local guideBtn = Instance.new("TextButton")
guideBtn.Size = UDim2.new(1,-(BTN_SIDE*2),0,BTN_H); guideBtn.Position = UDim2.new(0,BTN_SIDE,0,y)
guideBtn.BackgroundColor3 = Color3.fromRGB(140,88,14); guideBtn.BorderSizePixel = 0
guideBtn.AutoButtonColor = false; guideBtn.Text = ""; guideBtn.Parent = P1
Instance.new("UICorner",guideBtn).CornerRadius = UDim.new(0,5)
local guideBtnL = Instance.new("TextLabel"); guideBtnL.Size = UDim2.new(1,-16,1,0); guideBtnL.Position = UDim2.new(0,12,0,0)
guideBtnL.BackgroundTransparency = 1; guideBtnL.TextColor3 = Color3.fromRGB(255,255,255)
guideBtnL.Font = Enum.Font.GothamBold; guideBtnL.TextSize = 12
guideBtnL.TextXAlignment = Enum.TextXAlignment.Left; guideBtnL.Text = "Open Guide  →"; guideBtnL.Parent = guideBtn

guideBtn.MouseButton1Click:Connect(function()
    guideOpen = not guideOpen; GuidePanel.Visible = guideOpen
    guideBtnL.Text = guideOpen and "Close Guide  ←" or "Open Guide  →"
    guideBtn.BackgroundColor3 = guideOpen and Color3.fromRGB(90,55,8) or Color3.fromRGB(140,88,14)
end)
backBtn.MouseButton1Click:Connect(function()
    guideOpen = false; GuidePanel.Visible = false
    guideBtnL.Text = "Open Guide  →"; guideBtn.BackgroundColor3 = Color3.fromRGB(140,88,14)
end)

local listening = false
kbBtn.MouseButton1Click:Connect(function()
    if listening then return end; listening = true
    kbR.Text = "[ press any key ]"; kbR.TextColor3 = Color3.fromRGB(255,220,80)
    local conn; conn = UserInputService.InputBegan:Connect(function(input,processed)
        if processed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode.Escape then
            kbR.Text = "["..Library.HideKey.Name.."]"; kbR.TextColor3 = Color3.fromRGB(160,160,160)
            listening = false; conn:Disconnect(); return
        end
        Library.HideKey = input.KeyCode; kbR.Text = "["..input.KeyCode.Name.."]"
        kbR.TextColor3 = Color3.fromRGB(160,160,160); hintLbl.Text = "— hide key: "..input.KeyCode.Name.." —"
        listening = false; SaveSettings(); conn:Disconnect()
    end)
end)
b1.MouseButton1Click:Connect(function()
    Library.Enabled = not Library.Enabled
    b1.BackgroundColor3 = Library.Enabled and Color3.fromRGB(34,130,58) or Color3.fromRGB(20,55,28)
    s1.Text = Library.Enabled and "ON" or "OFF"
    for _,d in pairs(PlayerESPData) do
        if d.Highlight then d.Highlight.Enabled = Library.Enabled end
        if d.Label     then d.Label.Visible     = Library.Enabled end
    end; SaveSettings()
end)
b2.MouseButton1Click:Connect(function()
    Library.ShowNames = not Library.ShowNames
    b2.BackgroundColor3 = Library.ShowNames and Color3.fromRGB(30,110,200) or Color3.fromRGB(16,44,80)
    s2.Text = Library.ShowNames and "ON" or "OFF"; SaveSettings()
end)
b3.MouseButton1Click:Connect(function()
    Library.ShowDistance = not Library.ShowDistance
    b3.BackgroundColor3 = Library.ShowDistance and Color3.fromRGB(122,58,185) or Color3.fromRGB(50,24,75)
    s3.Text = Library.ShowDistance and "ON" or "OFF"; SaveSettings()
end)
local tsc={12,14,16,18,22,26,30}; local tsi=2
for i,v in ipairs(tsc) do if v==Library.TextSize then tsi=i break end end
b4.MouseButton1Click:Connect(function()
    tsi=(tsi%#tsc)+1; Library.TextSize=tsc[tsi]; s4.Text=tostring(Library.TextSize); SaveSettings()
end)

-- PAGE 2
y = 8
MakeSecLabel(P2,"LOOK DIRECTION",y); y=y+SEC_H
local b5,s5 = MakeButton(P2,"Look Direction",y,Color3.fromRGB(122,58,185),Color3.fromRGB(50,24,75),Library.LookDirection); y=y+BTN_H+BTN_GAP
MakeSecLabel(P2,"ARROW SIZE",y); y=y+SEC_H
local _,onArrow,setArrowVal = MakeSlider(P2,"Arrow Size",y,Library.ArrowSize,5,20,true,Color3.fromRGB(255,220,80),tostring)
onArrow(function(v)
    Library.ArrowSize = v
    for _,data in pairs(PlayerESPData) do
        if data.ArrowLbl then
            local gs = v*2; data.ArrowLbl.TextSize = gs
            if data.ArrowBBG then data.ArrowBBG.Size = UDim2.new(0,gs,0,gs) end
        end
    end; SaveSettings()
end)
y=y+SLIDER_H+BTN_GAP
MakeSecLabel(P2,"REFRESH RATE",y); y=y+SEC_H
local _,onRefresh,setRefreshVal = MakeSlider(P2,"Refresh Rate",y,Library.UpdateInterval,0.05,1.0,false,
    Color3.fromRGB(80,200,180),function(v) return string.format("%.2fs",v) end)
onRefresh(function(v) Library.UpdateInterval=math.floor(v*100)/100; SaveSettings() end)
y=y+SLIDER_H+BTN_GAP
MakeSecLabel(P2,"ESP LIMITER",y); y=y+SEC_H
local bLimit,sLimit = MakeButton(P2,"ESP Limit",y,Color3.fromRGB(130,40,180),Color3.fromRGB(52,16,70),Library.ESPLimitEnabled); y=y+BTN_H+BTN_GAP
local _,onLimit,setLimitVal = MakeSlider(P2,"Limit Range (s)",y,Library.ESPLimit,2500,10000,true,
    Color3.fromRGB(180,120,220),function(v) return tostring(v).."s" end)
onLimit(function(v) Library.ESPLimit=v; SaveSettings() end)

b5.MouseButton1Click:Connect(function()
    Library.LookDirection = not Library.LookDirection
    b5.BackgroundColor3 = Library.LookDirection and Color3.fromRGB(122,58,185) or Color3.fromRGB(50,24,75)
    s5.Text = Library.LookDirection and "ON" or "OFF"
    for _,data in pairs(PlayerESPData) do
        if data.ArrowBBG then data.ArrowBBG.Enabled = Library.LookDirection end
    end; SaveSettings()
end)
bLimit.MouseButton1Click:Connect(function()
    Library.ESPLimitEnabled = not Library.ESPLimitEnabled
    bLimit.BackgroundColor3 = Library.ESPLimitEnabled and Color3.fromRGB(130,40,180) or Color3.fromRGB(52,16,70)
    sLimit.Text = Library.ESPLimitEnabled and "ON" or "OFF"; SaveSettings()
end)

-- PAGE 3
y = 8
MakeSecLabel(P3,"PROXIMITY",y); y=y+SEC_H

local HALF = math.floor(INNER_W/2)-2
local QRTR = math.floor(INNER_W/4)-2
local proxRow = Instance.new("Frame")
proxRow.Size = UDim2.new(1,-(BTN_SIDE*2),0,BTN_H); proxRow.Position = UDim2.new(0,BTN_SIDE,0,y)
proxRow.BackgroundTransparency = 1; proxRow.BorderSizePixel = 0; proxRow.Parent = P3
y=y+BTN_H+BTN_GAP

local bProx = Instance.new("TextButton")
bProx.Size = UDim2.new(0,HALF,1,0); bProx.BackgroundColor3 = Library.ProximityAlert and Color3.fromRGB(185,110,16) or Color3.fromRGB(75,44,8)
bProx.BorderSizePixel = 0; bProx.AutoButtonColor = false; bProx.Text = ""; bProx.Parent = proxRow
Instance.new("UICorner",bProx).CornerRadius = UDim.new(0,5)
local bProxL = Instance.new("TextLabel"); bProxL.Size = UDim2.new(0.62,0,1,0); bProxL.Position = UDim2.new(0,8,0,0)
bProxL.BackgroundTransparency = 1; bProxL.TextColor3 = Color3.fromRGB(255,255,255)
bProxL.Font = Enum.Font.GothamSemibold; bProxL.TextSize = 11; bProxL.TextXAlignment = Enum.TextXAlignment.Left
bProxL.Text = "Proximity"; bProxL.Parent = bProx
local sProx = Instance.new("TextLabel"); sProx.Size = UDim2.new(0,30,1,0); sProx.Position = UDim2.new(1,-34,0,0)
sProx.BackgroundTransparency = 1; sProx.TextColor3 = Color3.fromRGB(255,255,255); sProx.TextTransparency = 0.35
sProx.Font = Enum.Font.Gotham; sProx.TextSize = 10; sProx.TextXAlignment = Enum.TextXAlignment.Right
sProx.Text = Library.ProximityAlert and "ON" or "OFF"; sProx.Parent = bProx

local bPTS = Instance.new("TextButton")
bPTS.Size = UDim2.new(0,QRTR,1,0); bPTS.Position = UDim2.new(0,HALF+4,0,0)
bPTS.BackgroundColor3 = Library.ProximityTextSize and Color3.fromRGB(34,130,58) or Color3.fromRGB(20,55,28)
bPTS.BorderSizePixel = 0; bPTS.AutoButtonColor = false; bPTS.Text = ""; bPTS.Parent = proxRow
Instance.new("UICorner",bPTS).CornerRadius = UDim.new(0,5)
local bPTSL = Instance.new("TextLabel"); bPTSL.Size = UDim2.new(1,0,1,0)
bPTSL.BackgroundTransparency = 1; bPTSL.TextColor3 = Color3.fromRGB(255,255,255)
bPTSL.Font = Enum.Font.Gotham; bPTSL.TextSize = 8
bPTSL.Text = Library.ProximityTextSize and "PROX\nTXT ON" or "PROX\nTXT OFF"; bPTSL.Parent = bPTS

local bPFS = Instance.new("TextButton")
bPFS.Size = UDim2.new(0,QRTR,1,0); bPFS.Position = UDim2.new(0,HALF+QRTR+8,0,0)
bPFS.BackgroundColor3 = Color3.fromRGB(45,45,45); bPFS.BorderSizePixel = 0
bPFS.AutoButtonColor = false; bPFS.Text = ""; bPFS.Parent = proxRow
Instance.new("UICorner",bPFS).CornerRadius = UDim.new(0,5)
local bPFStop = Instance.new("TextLabel"); bPFStop.Size = UDim2.new(1,0,0.44,0)
bPFStop.BackgroundTransparency = 1; bPFStop.TextColor3 = Color3.fromRGB(130,130,130)
bPFStop.Font = Enum.Font.Gotham; bPFStop.TextSize = 7; bPFStop.Text = "PROX SIZE"; bPFStop.Parent = bPFS
local bPFSL = Instance.new("TextLabel"); bPFSL.Size = UDim2.new(1,0,0.56,0); bPFSL.Position = UDim2.new(0,0,0.44,0)
bPFSL.BackgroundTransparency = 1; bPFSL.TextColor3 = Color3.fromRGB(220,220,220)
bPFSL.Font = Enum.Font.GothamBold; bPFSL.TextSize = 14; bPFSL.Text = tostring(Library.ProximityFontSize); bPFSL.Parent = bPFS

local pfsz={6,7,8,9,10,11,12}; local pfsi=5
for i,v in ipairs(pfsz) do if v==Library.ProximityFontSize then pfsi=i break end end

bProx.MouseButton1Click:Connect(function()
    Library.ProximityAlert = not Library.ProximityAlert
    bProx.BackgroundColor3 = Library.ProximityAlert and Color3.fromRGB(185,110,16) or Color3.fromRGB(75,44,8)
    sProx.Text = Library.ProximityAlert and "ON" or "OFF"; SaveSettings()
end)
bPTS.MouseButton1Click:Connect(function()
    Library.ProximityTextSize = not Library.ProximityTextSize
    bPTS.BackgroundColor3 = Library.ProximityTextSize and Color3.fromRGB(34,130,58) or Color3.fromRGB(20,55,28)
    bPTSL.Text = Library.ProximityTextSize and "PROX\nTXT ON" or "PROX\nTXT OFF"; SaveSettings()
end)
bPFS.MouseButton1Click:Connect(function()
    pfsi=(pfsi%#pfsz)+1; Library.ProximityFontSize=pfsz[pfsi]
    bPFSL.Text=tostring(Library.ProximityFontSize); SaveSettings()
end)

local _,onProxR,setProxRVal = MakeSlider(P3,"Alert Range (s)",y,Library.ProximityThreshold,100,2000,true,Color3.fromRGB(255,80,80),tostring)
onProxR(function(v) Library.ProximityThreshold=v; SaveSettings() end)
y=y+SLIDER_H+BTN_GAP

MakeSecLabel(P3,"PREDATE",y); y=y+SEC_H
MakePlayerList(P3, y,
    function() return Library.PredateTarget end,
    function(p) Library.PredateTarget = p end,
    Color3.fromRGB(55,25,80),
    Color3.fromRGB(255,215,0))

-- PAGE 4 — SPECTATE & DONATE
y = 8
MakeSecLabel(P4,"SPECTATE",y); y=y+SEC_H

local specHint = Instance.new("Frame"); specHint.Size = UDim2.new(1,-(BTN_SIDE*2),0,36); specHint.Position = UDim2.new(0,BTN_SIDE,0,y)
specHint.BackgroundColor3 = Color3.fromRGB(15,40,52); specHint.BorderSizePixel = 0; specHint.Parent = P4
Instance.new("UICorner",specHint).CornerRadius = UDim.new(0,5)
local specHintL = Instance.new("TextLabel"); specHintL.Size = UDim2.new(1,-16,1,0); specHintL.Position = UDim2.new(0,10,0,0)
specHintL.BackgroundTransparency = 1; specHintL.TextColor3 = Color3.fromRGB(80,200,255)
specHintL.Font = Enum.Font.Gotham; specHintL.TextSize = 9; specHintL.TextWrapped = true
specHintL.TextXAlignment = Enum.TextXAlignment.Left
specHintL.Text = "Proxy Spectate: Smooth character mirroring. Automatically targets the selected player."; specHintL.Parent = specHint
y=y+36+BTN_GAP

local listBottomY = MakePlayerList(P4, y,
    function() return Library.SpectateTarget end,
    function(p)
        if p == nil then
            StopSpectate()
        else
            StartSpectate(p)
        end
    end,
    Color3.fromRGB(15,45,65),
    Color3.fromRGB(80,200,255))

local proxCounterY = listBottomY + BTN_GAP
local proxCounterBox = Instance.new("Frame")
proxCounterBox.Size = UDim2.new(1,-(BTN_SIDE*2),0,36); proxCounterBox.Position = UDim2.new(0,BTN_SIDE,0,proxCounterY)
proxCounterBox.BackgroundColor3 = Color3.fromRGB(22,22,22); proxCounterBox.BorderSizePixel = 0; proxCounterBox.Parent = P4
Instance.new("UICorner",proxCounterBox).CornerRadius = UDim.new(0,5)
local proxIconL = Instance.new("TextLabel"); proxIconL.Size = UDim2.new(0,20,1,0); proxIconL.Position = UDim2.new(0,8,0,0)
proxIconL.BackgroundTransparency = 1; proxIconL.TextColor3 = Color3.fromRGB(255,80,80)
proxIconL.Font = Enum.Font.GothamBold; proxIconL.TextSize = 14; proxIconL.Text = "●"; proxIconL.Parent = proxCounterBox
proxCounterLbl = Instance.new("TextLabel")
proxCounterLbl.Size = UDim2.new(1,-32,1,0); proxCounterLbl.Position = UDim2.new(0,30,0,0)
proxCounterLbl.BackgroundTransparency = 1; proxCounterLbl.TextColor3 = Color3.fromRGB(90,90,90)
proxCounterLbl.Font = Enum.Font.GothamSemibold; proxCounterLbl.TextSize = 10
proxCounterLbl.TextXAlignment = Enum.TextXAlignment.Left
proxCounterLbl.Text = "Proximity Alert is OFF — enable on page 3"; proxCounterLbl.Parent = proxCounterBox

--------------------------------------------------------------------------------
-- DONATE BUTTON & TEMPORARY LINK BOX
--------------------------------------------------------------------------------
local donateY = proxCounterY + 36 + BTN_GAP
local donateBtn = Instance.new("TextButton")
donateBtn.Size = UDim2.new(1,-(BTN_SIDE*2),0,32); donateBtn.Position = UDim2.new(0,BTN_SIDE,0,donateY)
donateBtn.BackgroundColor3 = Color3.fromRGB(220,150,30); donateBtn.BorderSizePixel = 0
donateBtn.AutoButtonColor = false; donateBtn.Text = "♥ Donate"; donateBtn.TextColor3 = Color3.fromRGB(255,255,255)
donateBtn.Font = Enum.Font.GothamBold; donateBtn.TextSize = 12; donateBtn.Parent = P4
Instance.new("UICorner",donateBtn).CornerRadius = UDim.new(0,5)

local donateBoxY = donateY + 32 + BTN_GAP
local donateBox = Instance.new("Frame")
donateBox.Size = UDim2.new(1,-(BTN_SIDE*2),0,50); donateBox.Position = UDim2.new(0,BTN_SIDE,0,donateBoxY)
donateBox.BackgroundColor3 = Color3.fromRGB(24,24,24); donateBox.BorderSizePixel = 0
donateBox.Visible = false; donateBox.Parent = P4
Instance.new("UICorner",donateBox).CornerRadius = UDim.new(0,5)

local donateInfoL = Instance.new("TextLabel")
donateInfoL.Size = UDim2.new(1,-12,0,18); donateInfoL.Position = UDim2.new(0,6,0,4)
donateInfoL.BackgroundTransparency = 1; donateInfoL.TextColor3 = Color3.fromRGB(200,200,200)
donateInfoL.Font = Enum.Font.Gotham; donateInfoL.TextSize = 9
donateInfoL.Text = "Copy & paste link to your browser:"
donateInfoL.TextXAlignment = Enum.TextXAlignment.Left; donateInfoL.Parent = donateBox

local donateLinkBox = Instance.new("TextBox")
donateLinkBox.Size = UDim2.new(1,-12,0,22); donateLinkBox.Position = UDim2.new(0,6,0,22)
donateLinkBox.BackgroundColor3 = Color3.fromRGB(16,16,16); donateLinkBox.BorderSizePixel = 0
donateLinkBox.Text = "https://www.roblox.com/game-pass/1994486544"
donateLinkBox.TextColor3 = Color3.fromRGB(255,215,0); donateLinkBox.Font = Enum.Font.GothamSemibold
donateLinkBox.TextSize = 9; donateLinkBox.ClearTextOnFocus = false
donateLinkBox.TextEditable = false; donateLinkBox.Parent = donateBox
Instance.new("UICorner",donateLinkBox).CornerRadius = UDim.new(0,4)

local donateTimerThread = nil
donateBtn.MouseButton1Click:Connect(function()
    donateBox.Visible = true
    donateLinkBox:CaptureFocus()
    
    if donateTimerThread then
        task.cancel(donateTimerThread)
    end
    
    donateTimerThread = task.delay(10, function()
        donateBox.Visible = false
        donateTimerThread = nil
    end)
end)

updateGUIElements = function()
    TitleText.Text = Library.MenuName
    
    b1.BackgroundColor3 = Library.Enabled and Color3.fromRGB(34,130,58) or Color3.fromRGB(20,55,28)
    s1.Text = Library.Enabled and "ON" or "OFF"

    b2.BackgroundColor3 = Library.ShowNames and Color3.fromRGB(30,110,200) or Color3.fromRGB(16,44,80)
    s2.Text = Library.ShowNames and "ON" or "OFF"

    b3.BackgroundColor3 = Library.ShowDistance and Color3.fromRGB(122,58,185) or Color3.fromRGB(50,24,75)
    s3.Text = Library.ShowDistance and "ON" or "OFF"

    s4.Text = tostring(Library.TextSize)
    for i,v in ipairs(tsc) do if v==Library.TextSize then tsi=i break end end

    b5.BackgroundColor3 = Library.LookDirection and Color3.fromRGB(122,58,185) or Color3.fromRGB(50,24,75)
    s5.Text = Library.LookDirection and "ON" or "OFF"

    bLimit.BackgroundColor3 = Library.ESPLimitEnabled and Color3.fromRGB(130,40,180) or Color3.fromRGB(52,16,70)
    sLimit.Text = Library.ESPLimitEnabled and "ON" or "OFF"

    bProx.BackgroundColor3 = Library.ProximityAlert and Color3.fromRGB(185,110,16) or Color3.fromRGB(75,44,8)
    sProx.Text = Library.ProximityAlert and "ON" or "OFF"

    bPTS.BackgroundColor3 = Library.ProximityTextSize and Color3.fromRGB(34,130,58) or Color3.fromRGB(20,55,28)
    bPTSL.Text = Library.ProximityTextSize and "PROX\nTXT ON" or "PROX\nTXT OFF"

    bPFSL.Text = tostring(Library.ProximityFontSize)
    for i,v in ipairs(pfsz) do if v==Library.ProximityFontSize then pfsi=i break end end

    setTransVal(Library.ESPTransparency)
    setArrowVal(Library.ArrowSize)
    setRefreshVal(Library.UpdateInterval)
    setLimitVal(Library.ESPLimit)
    setProxRVal(Library.ProximityThreshold)
end

SetPage(1)

UserInputService.InputBegan:Connect(function(input,processed)
    if processed or listening then return end
    if input.KeyCode == Library.HideKey then
        Library.MenuVisible = not Library.MenuVisible
        MainFrame.Visible = Library.MenuVisible
    end
end)

end)