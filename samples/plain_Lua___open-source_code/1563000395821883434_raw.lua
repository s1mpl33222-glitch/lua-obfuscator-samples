-- ============================================================
-- 🎃 CROKS HALLOWEEN PREMIUM v16.0 (O Que Funciona)
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer

local CFG = {
    Red = Color3.fromRGB(255,110,20), RedDark = Color3.fromRGB(140,50,10),
    RedGlow = Color3.fromRGB(255,160,60), RedSoft = Color3.fromRGB(255,190,110),
    Bg = Color3.fromRGB(15,12,20), Bg2 = Color3.fromRGB(10,6,16), Bg3 = Color3.fromRGB(22,14,30),
    Bg4 = Color3.fromRGB(44,30,58), Border = Color3.fromRGB(80,55,100),
    Text = Color3.new(1,1,1), Muted = Color3.fromRGB(180,170,195),
    Success = Color3.fromRGB(40,220,100), Danger = Color3.fromRGB(255,50,50), Warn = Color3.fromRGB(255,200,40),
    Version = "v16.0", Author = "Croks",
    Logo = "rbxassetid://74429482718401",
    KeyURL = "https://raw.githubusercontent.com/kevinhub588/HaloweenEventKey/main/Keyeventhaloween",
    KeyFile = "CroksKey.txt",
    DiscordLink = "https://discord.gg/dDqdH8tJdM",
    
    DROP_OFF = Vector3.new(-5810.43, -206.59, -7265.24),
    PUMPKIN_DELIVER_POS = Vector3.new(-5523,-201,-6611),
    VACUUM_POS = Vector3.new(-14666,28,2090)
}

local AUTO_STEAL = { Running=false, Tok=0, BestEggMode=true, FilterIndex=1 }
local state = { Delivered=0, Cancel=false, Carrying=false }

local function parentGui()
    if typeof(gethui) == "function" then
        local ok, r = pcall(gethui)
        if ok and typeof(r) == "Instance" then return r end
    end
    return lp:FindFirstChildOfClass("PlayerGui") or CoreGui
end

local function make(c, p) local i = Instance.new(c) for k, v in pairs(p or {}) do i[k] = v end return i end
local function corner(p, r) make("UICorner", { CornerRadius = UDim.new(0, r or 8) }).Parent = p end
local function stroke(p, c, t) local s = make("UIStroke", { Color = c or CFG.Red, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }); s.Parent = p; return s end
local function pad(p, a) local u = make("UIPadding", { PaddingTop = UDim.new(0,a or 8), PaddingBottom = UDim.new(0,a or 8), PaddingLeft = UDim.new(0,a or 8), PaddingRight = UDim.new(0,a or 8) }); u.Parent = p; return u end

-- ============ RGB ENGINE ============
local ActiveGradients = {}
local COLOR_SEQ_NEON_ORANGE = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 50, 0)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 120, 0)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 220, 20)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 120, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 50, 0)) })

task.spawn(function()
    local rot = 0
    while true do
        rot = (rot + 3) % 360
        for i = #ActiveGradients, 1, -1 do
            local g = ActiveGradients[i]
            if g and g.Parent then g.Rotation = rot else table.remove(ActiveGradients, i) end
        end
        task.wait(0.03)
    end
end)

local function addRGB(p, t, isText)
    local seq = COLOR_SEQ_NEON_ORANGE
    if isText then
        local g = make("UIGradient", { Color = seq, Rotation = 0 })
        g.Parent = p; table.insert(ActiveGradients, g); return g
    else
        local s = make("UIStroke", { Thickness = t or 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
        s.Parent = p
        local g = make("UIGradient", { Color = seq, Rotation = 0 })
        g.Parent = s; table.insert(ActiveGradients, g); return s, g
    end
end

-- ============ KEY SYSTEM ============
local function checkKey(key)
    if not key or key == "" then return false end
    local ok, body = pcall(function() return game:HttpGet(CFG.KeyURL) end)
    if not ok or not body then return false end
    for k in string.gmatch(body, "%S+") do if k == key then return true end end
    return false
end
local function saveKey(key) pcall(function() if type(writefile) == "function" then writefile(CFG.KeyFile, key) end end) end
local function loadSavedKey() local k; pcall(function() if type(isfile) == "function" and isfile(CFG.KeyFile) then k = readfile(CFG.KeyFile) end end); return k end
local isLogged = false
local savedKey = loadSavedKey()
if savedKey and checkKey(savedKey) then isLogged = true end

if not isLogged then
    local keyGui = make("ScreenGui", { Name="CroksKeySystem", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=9999999, Parent=parentGui() })
    local keyWin = make("Frame", { Size=UDim2.fromOffset(380,220), Position=UDim2.new(0.5,-190,0.5,-110), BackgroundColor3=CFG.Bg2, BorderSizePixel=0, Parent=keyGui })
    corner(keyWin, 12); addRGB(keyWin, 3, false)
    local kClose = make("TextButton", { Size=UDim2.fromOffset(24,24), Position=UDim2.new(1,-32,0,10), BackgroundColor3=CFG.Bg4, BorderSizePixel=0, Font=Enum.Font.Code, TextSize=14, TextColor3=CFG.Danger, Text="✕", Parent=keyWin })
    corner(kClose, 5)
    kClose.MouseButton1Click:Connect(function() keyGui:Destroy(); isLogged = false end)
    make("TextLabel", { Size=UDim2.new(1,0,0,40), Position=UDim2.fromOffset(0,20), BackgroundTransparency=1, Font=Enum.Font.GothamBold, TextSize=20, TextColor3=CFG.RedGlow, Text="CROKS KEY SYSTEM", Parent=keyWin })
    make("TextLabel", { Size=UDim2.new(1,0,0,20), Position=UDim2.fromOffset(0,60), BackgroundTransparency=1, Font=Enum.Font.Code, TextSize=12, TextColor3=CFG.Muted, Text="Insira sua key para acessar o Hub", Parent=keyWin })
    local box = make("TextBox", { Size=UDim2.new(1,-40,0,40), Position=UDim2.fromOffset(20,100), BackgroundColor3=CFG.Bg4, BorderSizePixel=0, Font=Enum.Font.Code, TextSize=14, TextColor3=CFG.Text, PlaceholderText="XXXX-XXXX-XXXX-XXXX", ClearTextOnFocus=false, Parent=keyWin })
    corner(box, 6); stroke(box, CFG.Border, 1)
    local btn = make("TextButton", { Size=UDim2.new(1,-40,0,36), Position=UDim2.fromOffset(20,155), BackgroundColor3=CFG.Red, BorderSizePixel=0, Font=Enum.Font.GothamBold, TextSize=14, TextColor3=Color3.new(1,1,1), Text="LOGIN", Parent=keyWin })
    corner(btn, 6)
    local status = make("TextLabel", { Size=UDim2.new(1,0,0,20), Position=UDim2.fromOffset(0,195), BackgroundTransparency=1, Font=Enum.Font.Code, TextSize=11, TextColor3=CFG.Danger, Text="", Parent=keyWin })
    btn.MouseButton1Click:Connect(function()
        status.Text = "Verificando..."; status.TextColor3 = CFG.Warn; task.wait(0.5)
        if checkKey(box.Text) then saveKey(box.Text); status.Text = "Key válida! Entrando..."; status.TextColor3 = CFG.Success; task.wait(1); keyGui:Destroy(); isLogged = true
        else status.Text = "Key inválida ou expirada."; status.TextColor3 = CFG.Danger end
    end)
    while keyGui.Parent and not isLogged do task.wait(0.1) end
end
if not isLogged then return end

pcall(function()
    if setclipboard then setclipboard(CFG.DiscordLink)
    elseif toclipboard then toclipboard(CFG.DiscordLink)
    elseif syn and syn.write_clipboard then syn.write_clipboard(CFG.DiscordLink) end
end)

-- ============ VARIÁVEIS E RARIDADE ============
local function safeReq(f) local ok, r = pcall(function() return require(f()) end) return ok and r or nil end
local nf = RS:WaitForChild("Packages",30)
if nf then nf = nf:WaitForChild("Networking",30) end
if not nf then nf = RS:FindFirstChild("Networking") end
local ES = safeReq(function() return RS.Client.EggState end)
local Assets = safeReq(function() return RS.Data.Assets end)

local function root() local c = lp.Character return c and c:FindFirstChild("HumanoidRootPart") end

if type(ES) == "table" and type(ES.CarryChanged) == "table" and type(ES.CarryChanged.Connect) == "function" then
    ES.CarryChanged:Connect(function(arg)
        local c = type(arg) == "table" and arg.IsCarrying == true
        if c and arg.GuardDisabled == true then c = false end
        state.Carrying = c
    end)
end

local RARITY_N, RARITY_C, RARITY_NAME_RANK, ASSETS_BY_LOWER = {}, {}, {}, {}
local RARITY_COLOR = { Common=Color3.fromRGB(200,200,200), Uncommon=Color3.fromRGB(180,255,180), Rare=Color3.fromRGB(120,200,255), Epic=Color3.fromRGB(200,130,255), Legendary=Color3.fromRGB(255,200,80), Mythic=Color3.fromRGB(255,120,120), Cosmic=Color3.fromRGB(255,150,220), Secret=Color3.fromRGB(255,230,100), Eternal=Color3.fromRGB(120,255,255), Divine=Color3.fromRGB(255,100,200) }
local RARITY_ORDER = { Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10 }
local FILTER_RARITIES = { "Off", "Common+", "Uncommon+", "Rare+", "Epic+", "Legendary+", "Mythic+", "Cosmic+", "Secret+", "Eternal+", "Divine+" }
local RARITY_VALUES = { ["Off"]=0, ["Common+"]=1, ["Uncommon+"]=2, ["Rare+"]=3, ["Epic+"]=4, ["Legendary+"]=5, ["Mythic+"]=6, ["Cosmic+"]=7, ["Secret+"]=8, ["Eternal+"]=9, ["Divine+"]=10 }

local function buildRarityMap()
    if type(Assets) == "table" and type(Assets.Directory) == "table" then
        for k, ent in pairs(Assets.Directory) do
            if type(ent) == "table" then
                local rar = ent.Rarity
                local num, name
                if type(rar) == "table" then 
                    num = tonumber(rar.RarityNumber or rar.Rank)
                    name = rar.Name or rar.DisplayName or rar._id
                elseif type(rar) == "string" then 
                    name = rar 
                end
                if type(name) == "string" and #name > 0 then
                    name = name:sub(1,1):upper()..name:sub(2):lower()
                    if num then RARITY_N[num] = name end
                    RARITY_C[name] = RARITY_COLOR[name] or Color3.fromRGB(200,200,200)
                    if RARITY_ORDER[name] then RARITY_NAME_RANK[name] = RARITY_ORDER[name] end
                end
                if type(k) == "string" then ASSETS_BY_LOWER[k:lower()] = ent end
            end
        end
    end
end
buildRarityMap()

local function getModelPosition(model)
    if not model then return nil end
    local ok, cf = pcall(function() return model:GetBoundingBox() end)
    if ok and cf then return cf.Position end
    local ok2, pivot = pcall(function() return model:GetPivot() end)
    if ok2 and pivot then return pivot.Position end
    return nil
end

-- ============ LERP (O Auto Steal que funcionava) ============
local function lerpTo(targetPos, speed)
    local hrp = root()
    if not hrp then return false end
    local dist = (targetPos - hrp.Position).Magnitude
    if dist < 5 then return true end

    speed = speed or 250
    local duration = dist / speed
    local startPos = hrp.Position
    local startTime = tick()

    local oldCollide = hrp.CanCollide
    hrp.CanCollide = false

    while (tick() - startTime) < duration do
        if state.Cancel or not AUTO_STEAL.Running then break end
        
        local alpha = (tick() - startTime) / duration
        if alpha > 1 then alpha = 1 end
        
        local currentPos = startPos:Lerp(targetPos, alpha)
        if hrp and hrp.Parent then
            hrp.CFrame = CFrame.new(currentPos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        task.wait()
    end

    if hrp and hrp.Parent then
        hrp.CFrame = CFrame.new(targetPos)
        hrp.CanCollide = oldCollide
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
    return true
end

-- ============ AUTO STEAL LOGIC ============
local function findPrompt(egg)
    local p = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
    if p then return p end
    local eggPos = getModelPosition(egg)
    if not eggPos then return nil end
    local best, bestDist = nil, 60
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local par = v.Parent
            local pos
            if par and par:IsA("BasePart") then pos = par.Position
            elseif par and par:IsA("Attachment") then pos = par.WorldPosition end
            if pos then
                local d = (pos - eggPos).Magnitude
                if d < bestDist then best, bestDist = v, d end
            end
        end
    end
    return best
end

local function getPromptPosition(prompt, egg)
    if not prompt then return getModelPosition(egg) end
    local par = prompt.Parent
    if par and par:IsA("BasePart") then return par.Position end
    if par and par:IsA("Attachment") then return par.WorldPosition end
    return getModelPosition(egg)
end

local function doGrab(prompt)
    if not prompt or not prompt.Enabled then return false end
    local hrp = root()
    if not hrp then return false end
    local holdCFrame = hrp.CFrame
    local lockConn = RunService.Heartbeat:Connect(function()
        if hrp and hrp.Parent and AUTO_STEAL.Running and not state.Cancel then
            hrp.CFrame = holdCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
    task.wait(0.1)
    pcall(function() 
        prompt.HoldDuration = 0 
        if fireproximityprompt then fireproximityprompt(prompt) else prompt:InputHoldBegin(); task.wait(0.1); prompt:InputHoldEnd() end
    end)
    task.wait(0.2)
    lockConn:Disconnect()
    return true
end

local function doFarmCycle(egg, isActive)
    if not egg.Parent then return false end
    local prompt = findPrompt(egg)
    local targetPos = prompt and getPromptPosition(prompt, egg) or getModelPosition(egg)
    if not prompt or not targetPos then return false end
    if not isActive() then return false end
    
    if not lerpTo(targetPos, 250) then return false end
    if not isActive() then return false end
    
    doGrab(prompt)
    
    local waitStart = tick()
    while (tick() - waitStart < 2.0) and AUTO_STEAL.Running and not state.Cancel do
        if state.Carrying then break end
        if not prompt.Enabled then break end
        task.wait(0.05)
    end

    if not isActive() then return false end
    
    lerpTo(CFG.DROP_OFF, 250)
    return true
end

local function getEggList()
    local list = {}
    local dim = Workspace:FindFirstChild("HalloweenDimension")
    local folder = dim and dim:FindFirstChild("WorldEggs") or Workspace:FindFirstChild("WorldEggs")
    if not folder then return list end
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Model") and child.Name == "HalloweenEgg" then
            table.insert(list, child)
        end
    end
    return list
end

local function getEggRarity(egg, category, scale)
    local rank = 0
    if type(Assets) == "table" and type(Assets.Directory) == "table" then
        local ent = Assets.Directory[tostring(category)] or ASSETS_BY_LOWER[tostring(category):lower()]
        if type(ent) == "table" then
            local rar = ent.Rarity
            if type(rar) == "table" then rank = tonumber(rar.RarityNumber or rar.Rank) or 0
            elseif type(rar) == "number" then rank = rar
            elseif type(rar) == "string" then
                local rn = rar:sub(1,1):upper()..rar:sub(2):lower()
                rank = RARITY_ORDER[rn] or 0
            end
            if rank == 0 then rank = tonumber(ent.RarityNumber or ent.Rank or ent.RarityValue) or 0 end
            if rank == 0 then
                for k, v in pairs(ent) do
                    if type(k) == "string" and (k:lower():find("rarity") or k:lower():find("rank")) then
                        if type(v) == "number" then rank = v break
                        elseif type(v) == "string" then
                            local rn = v:sub(1,1):upper()..v:sub(2):lower()
                            rank = RARITY_ORDER[rn] or 0
                            break
                        end
                    end
                end
            end
        end
    end
    if rank == 0 then
        local a = egg:GetAttribute("Rarity") or egg:GetAttribute("RarityNumber") or egg:GetAttribute("Rank")
        if type(a) == "number" then rank = a
        elseif type(a) == "string" then 
            local rn = a:sub(1,1):upper()..a:sub(2):lower()
            rank = RARITY_ORDER[rn] or tonumber(a) or 0
        end
    end
    if rank == 0 then
        for _, child in ipairs(egg:GetDescendants()) do
            if child:IsA("StringValue") or child:IsA("NumberValue") or child:IsA("IntValue") then
                local n = child.Name:lower()
                if n:find("rarity") or n:find("rank") then
                    if type(child.Value) == "number" then rank = child.Value break
                    elseif type(child.Value) == "string" then
                        local rn = child.Value:sub(1,1):upper()..child.Value:sub(2):lower()
                        rank = RARITY_ORDER[rn] or tonumber(child.Value) or 0
                        break
                    end
                end
            end
        end
    end
    if rank == 0 then
        local catLower = tostring(category):lower()
        for rName, rNum in pairs(RARITY_ORDER) do
            if catLower:find(rName:lower()) then rank = rNum break end
        end
    end
    if rank == 0 then rank = 1 end
    return rank
end

local function stealLoop()
    local tk = AUTO_STEAL.Tok
    while AUTO_STEAL.Running and tk == AUTO_STEAL.Tok do
        local eggs = getEggList()
        if #eggs == 0 then task.wait(1)
        else
            local pool = {}
            local hrp = root()
            for _, egg in ipairs(eggs) do
                local cat = tostring(egg:GetAttribute("PreparedSourceName") or egg:GetAttribute("Category") or egg.Name)
                if cat:lower():sub(-4) == " egg" then cat = cat:sub(1,-5) end
                local rank = getEggRarity(egg, cat, egg:GetAttribute("AssetScale"))
                if hrp then
                    local pos = getModelPosition(egg)
                    if pos then table.insert(pool, { egg=egg, rank=rank, dist=(pos-hrp.Position).Magnitude }) end
                end
            end

            if #pool > 0 then
                local minRank = RARITY_VALUES[FILTER_RARITIES[AUTO_STEAL.FilterIndex]] or 0
                local c = {}
                for _,e in ipairs(pool) do if e.rank >= minRank then table.insert(c, e) end end
                if #c == 0 then if AUTO_STEAL.FilterIndex == 1 then c = pool else task.wait(1) end end

                if #c > 0 then
                    if AUTO_STEAL.BestEggMode then
                        table.sort(c, function(a,b)
                            if a.rank ~= b.rank then return a.rank > b.rank end
                            return a.dist < b.dist
                        end)
                    else
                        for i = #c, 2, -1 do local j = math.random(i); c[i], c[j] = c[j], c[i] end
                    end
                    local chosen = c[1].egg
                    doFarmCycle(chosen, function() return AUTO_STEAL.Running end)
                end
            end
            if AUTO_STEAL.Running and tk == AUTO_STEAL.Tok then task.wait(0.5) end
        end
    end
end

local function startAutoSteal()
    if AUTO_STEAL.Running then return end
    AUTO_STEAL.Running = true
    AUTO_STEAL.Tok += 1
    state.Cancel = false
    task.spawn(stealLoop)
end

local function stopAutoSteal()
    AUTO_STEAL.Running = false
    AUTO_STEAL.Tok += 1
    state.Cancel = true
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    end
end

-- ============ MOB ============
local function equipWeapon()
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return nil end
    local eq = char:FindFirstChildWhichIsA("Tool")
    if eq and (eq.Name:lower():find("bat") or eq.Name:lower():find("sword") or eq.Name:lower():find("weapon")) then return eq end
    local bp = lp:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("sword") or t.Name:lower():find("weapon")) then
                pcall(function() hum:EquipTool(t) end); task.wait(0.2); return t
            end
        end
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then pcall(function() hum:EquipTool(t) end); task.wait(0.2); return t end
        end
    end
    return nil
end

-- ============ ESP ============
local function isArtifact(name)
    local l = string.lower(name)
    return l:find("artifact") ~= nil
end

-- ============ UI PRINCIPAL ============
local W, H, SB = 360, 320, 100
local old = parentGui():FindFirstChild("CroksHalloween")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name="CroksHalloween"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=999999
gui.Parent=parentGui()

local win = make("Frame", { Size=UDim2.fromOffset(W,H), Position=UDim2.new(0.5,-W/2,0.5,-H/2), BackgroundColor3=CFG.Bg, BackgroundTransparency=0.1, BorderSizePixel=0, Active=true, Parent=gui })
corner(win, 10); addRGB(win, 3, false)

local inner = make("Frame", { Size=UDim2.new(1,0,1,0), BackgroundColor3=CFG.Bg, BackgroundTransparency=0.3, BorderSizePixel=0, ClipsDescendants=true, ZIndex=1, Parent=win })
corner(inner, 10)

local sbar = make("Frame", { Size=UDim2.new(0,SB,1,0), BackgroundColor3=CFG.Bg2, BackgroundTransparency=0.1, BorderSizePixel=0, ZIndex=2, Parent=inner })
corner(sbar, 10)

local lcir = make("Frame", { Size=UDim2.fromOffset(40,40), Position=UDim2.new(0.5,-20,0,10), BackgroundColor3=CFG.Bg, BorderSizePixel=0, ClipsDescendants=true, ZIndex=5, Parent=sbar })
corner(lcir, 20); addRGB(lcir, 2)
make("ImageLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Image=CFG.Logo, ScaleType=Enum.ScaleType.Crop, ZIndex=6, Parent=lcir })

local tLbl = make("TextLabel", { Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,55), BackgroundTransparency=1, Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.new(1,1,1), TextXAlignment=Enum.TextXAlignment.Center, Text="CROKS", ZIndex=3, Parent=sbar })
addRGB(tLbl, 0, true)
make("TextLabel", { Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,0,70), BackgroundTransparency=1, Font=Enum.Font.Code, TextSize=9, TextColor3=CFG.Muted, TextXAlignment=Enum.TextXAlignment.Center, Text="🎃 HALLOWEEN", ZIndex=3, Parent=sbar })

local menu = make("ScrollingFrame", { Size=UDim2.new(1,-10,1,-140), Position=UDim2.fromOffset(5,90), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=3, Parent=sbar })
make("UIListLayout", { Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, Parent=menu })

local content = make("Frame", { Size=UDim2.new(1,-SB-6,1,-10), Position=UDim2.fromOffset(SB+3,5), BackgroundColor3=CFG.Bg2, BackgroundTransparency=0.2, BorderSizePixel=0, ZIndex=2, Parent=inner })
corner(content, 8)

local hbar = make("Frame", { Size=UDim2.new(1,0,0,28), BackgroundColor3=CFG.Bg3, BackgroundTransparency=0.2, BorderSizePixel=0, ZIndex=2, Parent=content })
corner(hbar, 8)
local htl = make("TextLabel", { Size=UDim2.new(1,-80,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Font=Enum.Font.Code, TextSize=11, TextColor3=CFG.Text, TextXAlignment=Enum.TextXAlignment.Left, Text="> HALLOWEEN", ZIndex=3, Parent=hbar })
local bMin = make("TextButton", { Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-48,0.5,-10), BackgroundColor3=CFG.Bg4, BorderSizePixel=0, Font=Enum.Font.Code, TextSize=12, TextColor3=CFG.Text, Text="—", ZIndex=3, Parent=hbar })
corner(bMin, 4)
local bClose = make("TextButton", { Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-24,0.5,-10), BackgroundColor3=CFG.Bg4, BorderSizePixel=0, Font=Enum.Font.Code, TextSize=12, TextColor3=CFG.Danger, Text="✕", ZIndex=3, Parent=hbar })
corner(bClose, 4)

local scroll = make("ScrollingFrame", { Size=UDim2.new(1,-10,1,-34), Position=UDim2.fromOffset(5,32), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=3, Parent=content })
local sList = make("Frame", { Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, ZIndex=3, Parent=scroll })
make("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, Parent=sList })

local PAGES = {}
local function mkSec(parent, title, order)
    local sec = make("Frame", { Size=UDim2.new(1,0,0,0), BackgroundColor3=CFG.Bg3, BorderSizePixel=0, AutomaticSize=Enum.AutomaticSize.Y, LayoutOrder=order or 0, ZIndex=3, Parent=parent })
    corner(sec, 6); stroke(sec, CFG.Border, 1); pad(sec, 8)
    make("TextLabel", { Size=UDim2.new(1,0,0,16), BackgroundTransparency=1, Font=Enum.Font.Code, TextSize=10, TextColor3=CFG.RedSoft, TextXAlignment=Enum.TextXAlignment.Left, Text="▸ "..title, ZIndex=4, Parent=sec })
    local body = make("Frame", { Size=UDim2.new(1,0,0,0), Position=UDim2.fromOffset(0,20), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, ZIndex=4, Parent=sec })
    make("UIListLayout", { Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, Parent=body })
    return body
end
local function mkPage(name, title)
    local p = make("Frame", { Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, Visible=false, ZIndex=3, Parent=sList })
    make("UIListLayout", { Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=p })
    PAGES[name] = { frame=p, title=title }
    return p
end
local function showPage(name)
    for n, p in pairs(PAGES) do p.frame.Visible = (n == name) end
    local p = PAGES[name]
    if p then htl.Text = "> "..string.upper(p.title) end
    for _, b in ipairs(menu:GetChildren()) do
        if b:IsA("TextButton") then
            local a = b:GetAttribute("PageName") == name
            local s = b:FindFirstChildOfClass("UIStroke")
            if a then Tween:Create(b, TweenInfo.new(0.2), { BackgroundColor3=CFG.Red, TextColor3=Color3.new(1,1,1) }):Play(); if s then s.Color=CFG.RedGlow; s.Thickness=1.5 end
            else Tween:Create(b, TweenInfo.new(0.2), { BackgroundColor3=CFG.Bg4, TextColor3=CFG.Text }):Play(); if s then s.Color=CFG.Border; s.Thickness=1 end end
        end
    end
end
local function mkBtn(name, label, ic, order)
    local b = make("TextButton", { Size=UDim2.new(1,0,0,30), BackgroundColor3=CFG.Bg4, BorderSizePixel=0, Font=Enum.Font.Code, TextSize=10, TextColor3=CFG.Text, TextXAlignment=Enum.TextXAlignment.Left, Text="  "..ic.."  "..label, AutoButtonColor=false, LayoutOrder=order, ZIndex=4, Parent=menu })
    corner(b, 5); stroke(b, CFG.Border, 1)
    b:SetAttribute("PageName", name)
    b.MouseButton1Click:Connect(function() showPage(name) end)
    return b
end
local function makeToggle(parent, label, def, onCh)
    local row = make("Frame", { Size=UDim2.new(1,0,0,30), BackgroundColor3=CFG.Bg4, BorderSizePixel=0, Parent=parent })
    corner(row, 5); stroke(row, CFG.Border, 1)
    make("TextLabel", { Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Font=Enum.Font.Code, TextSize=11, TextColor3=CFG.Text, TextXAlignment=Enum.TextXAlignment.Left, Text=label, ZIndex=5, Parent=row })
    local track = make("Frame", { Size=UDim2.fromOffset(36,16), Position=UDim2.new(1,-46,0.5,-8), BackgroundColor3=def and CFG.Red or Color3.fromRGB(70,60,85), BorderSizePixel=0, ZIndex=5, Parent=row })
    corner(track, 8)
    local ts = stroke(track, def and CFG.Red or CFG.Border, 1.5)
    local knob = make("Frame", { Size=UDim2.fromOffset(12,12), Position=def and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=6, Parent=track })
    corner(knob, 6)
    local st = def
    local btn = make("TextButton", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=10, Parent=row })
    local function upd(a)
        local i = TweenInfo.new(a and 0.2 or 0, Enum.EasingStyle.Quart)
        Tween:Create(knob, i, { Position=st and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6) }):Play()
        Tween:Create(track, i, { BackgroundColor3=st and CFG.Red or Color3.fromRGB(70,60,85) }):Play()
        ts.Color = st and CFG.Red or CFG.Border
        row.BackgroundColor3 = st and CFG.RedDark or CFG.Bg4
    end
    btn.MouseButton1Click:Connect(function()
        st = not st
        upd(true)
        if onCh then pcall(onCh, st) end
    end)
    return { Set=function(v, r) st=v upd(true) if r and onCh then pcall(onCh, st) end end, Get=function() return st end }
end

mkPage("halloween","Halloween"); mkPage("mobs","Mobs"); mkPage("itens","Itens (Echo)"); mkPage("abobora","Abóbora"); mkPage("config","Config")
mkBtn("halloween","Halloween","🎃",1); mkBtn("mobs","Mobs","👾",2); mkBtn("itens","Itens (Echo)","🔍",3); mkBtn("abobora","Evento Abóbora","🎃",4); mkBtn("config","Config","⚙",5)

-- ============ PÁGINAS ============
do
    local p = PAGES["halloween"].frame
    local s1 = mkSec(p, "🎃 AUTO STEAL", 1)
    makeToggle(s1, "Auto Roubar Ovos", false, function(v)
        if v then startAutoSteal() else stopAutoSteal() end
    end)
    makeToggle(s1, "🏆 Best Egg Mode", true, function(v) AUTO_STEAL.BestEggMode = v end)
    local fb = make("TextButton", { Size=UDim2.new(1,0,0,26), BackgroundColor3=CFG.Bg4, BorderSizePixel=0, Font=Enum.Font.Code, TextSize=10, TextColor3=CFG.Text, Text="Raridade: Off", AutoButtonColor=true, ZIndex=5, Parent=s1 })
    corner(fb, 5)
    local fs = stroke(fb, CFG.Border, 1)
    fb.MouseButton1Click:Connect(function()
        AUTO_STEAL.FilterIndex = AUTO_STEAL.FilterIndex % #FILTER_RARITIES + 1
        local nf2 = FILTER_RARITIES[AUTO_STEAL.FilterIndex]
        fb.Text = "Raridade: "..nf2
        fs.Color = (nf2=="Off") and CFG.Border or CFG.Red
    end)
end

do
    local p = PAGES["mobs"].frame
    local s1 = mkSec(p, "👾 FARM DE MOBS (CANDY)", 1)
    makeToggle(s1, "Auto Candy (Matar Tudo)", false, function(v)
        if v then
            if _G.CANDY_RUNNING then return end
            _G.CANDY_RUNNING = true
            task.spawn(function()
                while _G.CANDY_RUNNING do
                    local char = lp.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end
                    local tool = equipWeapon()
                    if not tool then task.wait(1) continue end

                    local best, bd = nil, 300
                    local hd = workspace:FindFirstChild("HalloweenDimension")
                    local monsters = hd and hd:FindFirstChild("Monsters")
                    if monsters then
                        for _,m in ipairs(monsters:GetChildren()) do
                            if m:IsA("Model") then
                                local r = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                                if r then
                                    local d = (r.Position - char.HumanoidRootPart.Position).Magnitude
                                    if d < bd then best, bd = m, d end
                                end
                            end
                        end
                    end
                    if best then
                        local r = best.PrimaryPart or best:FindFirstChildWhichIsA("BasePart")
                        if r then
                            lerpTo(r.Position, 250)
                            task.wait(0.1)
                            if best.Parent and tool and tool.Parent == char then
                                pcall(function() tool:Activate() end)
                            end
                            task.wait(0.3)
                        end
                    else task.wait(0.5) end
                end
            end)
        else _G.CANDY_RUNNING = false end
    end)
end

do
    local p = PAGES["abobora"].frame
    local s1 = mkSec(p, "🎃 AUTO FARM ABÓBORA", 1)
    makeToggle(s1, "Auto Pegar e Entregar", false, function(v)
        if v then
            if _G.PUMPKIN_RUNNING then return end
            _G.PUMPKIN_RUNNING = true
            task.spawn(function()
                while _G.PUMPKIN_RUNNING do
                    local char = lp.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    
                    if not hrp or not hum then task.wait(1) continue end
                    
                    local myPos = hrp.Position
                    local bestPrompt, bestPos, bd = nil, nil, 5000

                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.Enabled then
                            local ptxt = string.lower((obj.ActionText or "") .. " " .. (obj.ObjectText or "") .. " " .. obj.Name)
                            if ptxt:find("catch") or ptxt:find("lil pump") then
                                local part = obj.Parent
                                local pos
                                if part and part:IsA("BasePart") then pos = part.Position 
                                elseif part and part:IsA("Attachment") then pos = part.WorldPosition end
                                
                                if pos then
                                    local d = (pos - myPos).Magnitude
                                    if d < bd then bestPrompt, bestPos, bd = obj, pos, d end
                                end
                            end
                        end
                    end

                    if bestPrompt and bestPos then
                        lerpTo(bestPos, 250)
                        task.wait(0.2)
                        pcall(function() bestPrompt.HoldDuration = 0; fireproximityprompt(bestPrompt) end)
                        task.wait(1)
                        
                        lerpTo(CFG.PUMPKIN_DELIVER_POS, 250)
                        task.wait(0.5)
                        
                        local delivered = false
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and obj.Enabled then
                                local part = obj.Parent
                                local pos
                                if part and part:IsA("BasePart") then pos = part.Position 
                                elseif part and part:IsA("Attachment") then pos = part.WorldPosition end
                                
                                if pos and (pos - CFG.PUMPKIN_DELIVER_POS).Magnitude < 60 then
                                    local ptxt = string.lower((obj.ActionText or "") .. " " .. (obj.ObjectText or "") .. " " .. obj.Name)
                                    if ptxt:find("deposit") or ptxt:find("return") or ptxt:find("deliver") then
                                        pcall(function() obj.HoldDuration = 0; fireproximityprompt(obj) end)
                                        delivered = true; break
                                    end
                                end
                            end
                        end
                        
                        if not delivered then
                            local dp = workspace:FindFirstChild("PumpkinDeposit", true)
                            if dp then
                                local pp = dp:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if pp then pcall(function() pp.HoldDuration = 0; fireproximityprompt(pp) end) end
                            end
                        end
                        
                        task.wait(1)
                        if char:FindFirstChildWhichIsA("Tool") then pcall(function() hum:UnequipTools() end) end
                        task.wait(1)
                    else task.wait(1) end
                end
            end)
        else _G.PUMPKIN_RUNNING = false end
    end)
end

do
    local p = PAGES["itens"].frame
    local s1 = mkSec(p, "🐶 ECHO'S MEMORIES (ESP)", 1)
    makeToggle(s1, "Ver Artifacts", false, function(v)
        if v then
            _G.ARTIFACT_ESP = {}
            _G.ARTIFACT_ESP_ON = true
            task.spawn(function()
                while _G.ARTIFACT_ESP_ON do
                    local cur = {}
                    for _,obj in ipairs(workspace:GetDescendants()) do
                        if (obj:IsA("Model") or obj:IsA("BasePart")) and isArtifact(obj.Name) then
                            cur[obj] = true
                            if not _G.ARTIFACT_ESP[obj] then
                                local ad = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                                if ad then
                                    local bb = Instance.new("BillboardGui", parentGui())
                                    bb.Name = "CroksESP_" .. obj.Name; bb.Adornee = ad; bb.Size = UDim2.fromOffset(200, 40); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 1000
                                    
                                    local f = Instance.new("Frame", bb); f.Size = UDim2.fromScale(1, 1); f.BackgroundTransparency = 1
                                    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, 0, 0.5, 0); tl.BackgroundTransparency = 1; tl.Font = Enum.Font.GothamBold; tl.TextSize = 14; tl.TextColor3 = Color3.fromRGB(255, 255, 130); tl.TextStrokeTransparency = 0; tl.Text = "🎯 ARTIFACT"
                                    local bl = Instance.new("TextLabel", f); bl.Size = UDim2.new(1, 0, 0.5, 0); bl.Position = UDim2.fromScale(0, 0.5); bl.BackgroundTransparency = 1; bl.Font = Enum.Font.GothamBold; bl.TextSize = 14; bl.TextColor3 = CFG.Text; bl.TextStrokeTransparency = 0; bl.Text = obj.Name
                                    _G.ARTIFACT_ESP[obj] = bb
                                end
                            end
                        end
                    end
                    for obj, g in pairs(_G.ARTIFACT_ESP) do if not cur[obj] or not obj.Parent then g:Destroy(); _G.ARTIFACT_ESP[obj] = nil end end
                    task.wait(0.5)
                end
            end)
        else
            _G.ARTIFACT_ESP_ON = false
            if _G.ARTIFACT_ESP then for _, g in pairs(_G.ARTIFACT_ESP) do if g and g.Parent then g:Destroy() end end; _G.ARTIFACT_ESP = {} end
        end
    end)
end

do
    local p = PAGES["config"].frame
    local s1 = mkSec(p, "CONFIGURAÇÕES", 1)
    local noclip = false
    makeToggle(s1, "Atravessar Paredes (Noclip)", false, function(v)
        noclip = v
        if noclip then RunService.Stepped:Connect(function() if lp.Character then for _,v in ipairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
        else if lp.Character then for _,v in ipairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end end end
    end)
    local s2 = mkSec(p, "SOBRE", 2)
    make("TextLabel", { Size=UDim2.new(1,0,0,40), BackgroundTransparency=1, Font=Enum.Font.Code, TextSize=10, TextColor3=CFG.Text, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Text="Croks Halloween "..CFG.Version.."\nBy "..CFG.Author, ZIndex=5, Parent=s2 })
end

showPage("halloween")

-- DRAG & MINIMIZADOR
do
    local dragging, dragStart, startPos = false, nil, nil
    local function updateDrag(input)
        if not dragging then return end
        local vp = workspace.CurrentCamera.ViewportSize
        local d = input.Position - dragStart
        local absX = startPos.X.Scale * vp.X + startPos.X.Offset
        local absY = startPos.Y.Scale * vp.Y + startPos.Y.Offset
        local nx = math.clamp(absX + d.X, 10, vp.X - W - 10)
        local ny = math.clamp(absY + d.Y, 10, vp.Y - H - 10)
        win.Position = UDim2.fromOffset(nx, ny)
    end
    hbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.Target == bMin or input.Target == bClose then return end
            dragging = true; dragStart = input.Position; startPos = win.Position
        end
    end)
    UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateDrag(input) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

local ball = make("TextButton", { Size=UDim2.fromOffset(44,44), Position=UDim2.new(0,20,0.5,-22), BackgroundColor3=CFG.Bg, BorderSizePixel=0, Text="", Visible=false, Parent=gui })
corner(ball, 22); addRGB(ball, 2)
make("ImageLabel", { Size=UDim2.fromOffset(36,36), Position=UDim2.new(0.5,-18,0.5,-18), BackgroundTransparency=1, Image=CFG.Logo, ScaleType=Enum.ScaleType.Crop, ZIndex=3, Parent=ball })

local function openW() ball.Visible=false; win.Visible=true; win.Size=UDim2.fromOffset(0,0); win.Position=UDim2.new(0.5,0,0.5,0); Tween:Create(win, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size=UDim2.fromOffset(W,H), Position=UDim2.new(0.5,-W/2,0.5,-H/2) }):Play() end
local function closeW() Tween:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size=UDim2.fromOffset(0,0), Position=UDim2.new(0.5,0,0.5,0) }):Play(); task.wait(0.3); win.Visible=false; ball.Visible=true end

local db, dsb, spb, mb = false, nil, nil, false
ball.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        db=true; mb=false; dsb=input.Position; spb=ball.Position
        local conn; conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then db=false; if conn then conn:Disconnect() end; if not mb then openW() end end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if db then
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local vp = workspace.CurrentCamera.ViewportSize; local d = input.Position - dsb
            if math.abs(d.X)>3 or math.abs(d.Y)>3 then mb=true end
            ball.Position = UDim2.fromOffset(spb.X.Scale * vp.X + spb.X.Offset + d.X, spb.Y.Scale * vp.Y + spb.Y.Offset + d.Y)
        end
    end
end)

bMin.MouseButton1Click:Connect(closeW)
bClose.MouseButton1Click:Connect(function()
    stopAutoSteal()
    _G.CANDY_RUNNING = false
    _G.PUMPKIN_RUNNING = false
    _G.ARTIFACT_ESP_ON = false
    gui:Destroy()
end)

win.Size = UDim2.fromOffset(W,H)
win.Position = UDim2.new(0.5,-W/2,0.5,-H/2)