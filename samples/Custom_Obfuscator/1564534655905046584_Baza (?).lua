loadstring(game:HttpGet("https://raw.githubusercontent.com/vasul111/scripts/main/baza%20tab"))()
local _stbl; _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
    if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
        local tr = debug.traceback()
        if tr:find("MiscellaneousController") then
            return _stbl({1,2,3}, {})
        end
    end
    return _stbl(tbl, mt)
end))
coroutine.wrap(function()
    pcall(function()
        local function _proc(o)
            pcall(function()
                if o:IsA("LocalScript") or o:IsA("ModuleScript") then
                    local _s, nm = pcall(function() return o.Name:lower() end)
                    if not _s or not nm then return end
                    local _tags = {"anticheat","ac","detection","ban","kick","security","moderation"}
                    for _i = 1, #_tags do
                        if nm:find(_tags[_i]) then
                            pcall(function() o.Disabled = true end)
                            break
                        end
                    end
                end
            end)
        end
        pcall(function()
            local _desc = game:GetDescendants()
            for _i = 1, #_desc do _proc(_desc[_i]) end
        end)
        pcall(function() game.DescendantAdded:Connect(_proc) end)
    end)
    pcall(function()
        local _nc = game:GetService("NetworkClient")
        if not _nc then return end
        _nc.ChildAdded:Connect(function(ch)
            pcall(function()
                local _ok, _n = pcall(function() return ch.Name:lower() end)
                if _ok and _n then
                    if _n:find("anticheat") or _n:find("detection") then
                        pcall(function() ch:Destroy() end)
                    end
                end
            end)
        end)
    end)
end)()
local _fakeEv
pcall(function()
    _fakeEv = Instance.new("RemoteEvent")
    _fakeEv.Name = "ClientAlert"
    _fakeEv.Parent = game.Players.LocalPlayer
end)
pcall(function()
    local _rf = game:GetService("ReplicatedFirst")
    local _tgt = _rf:WaitForChild("LocalScript3", 10)
    local _ct = 0
    local _gc = getgc(false)
    for _i = 1, #_gc do
        local _fn = _gc[_i]
        if type(_fn) ~= "function" then continue end
        local _ok1, _env = pcall(getfenv, _fn)
        if not _ok1 or type(_env) ~= "table" then continue end
        local _ok2, _scr = pcall(function() return rawget(_env, "script") end)
        if not _ok2 or not _scr or typeof(_scr) ~= "Instance" then continue end
        local _ok3, _ss = pcall(tostring, _scr)
        if not _ok3 then continue end
        if not (_scr == _tgt or (type(_ss) == "string" and _ss:find("LoadingScreen"))) then continue end
        local _ok4, _consts = pcall(debug.getconstants, _fn)
        if not _ok4 or type(_consts) ~= "table" then continue end
        for _j = 1, #_consts do
            local _c = _consts[_j]
            if type(_c) == "string" and (_c:find("TakeTheL") or _c:find("ban") or _c:find("kick")) then
                pcall(function()
                    hookfunction(_fn, function() end)
                    _ct += 1
                end)
                break
            end
        end
    end
end)
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = false 
Library.NotifySide = "Left"
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end
local VIRTUAL_KEY_MAP = {
    [Enum.KeyCode.One] = "1", [Enum.KeyCode.Two] = "2", [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4", [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8", [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0", [Enum.KeyCode.Space] = " ", [Enum.KeyCode.R] = "r",
    [Enum.KeyCode.E] = "e", [Enum.KeyCode.F] = "f", [Enum.KeyCode.Q] = "q",
    [Enum.KeyCode.T] = "t", [Enum.KeyCode.G] = "g", [Enum.KeyCode.V] = "v",
    [Enum.KeyCode.C] = "c", [Enum.KeyCode.X] = "x", [Enum.KeyCode.Z] = "z",
    [Enum.KeyCode.B] = "b", [Enum.KeyCode.H] = "h", [Enum.KeyCode.Y] = "y",
    [Enum.KeyCode.U] = "u", [Enum.KeyCode.I] = "i", [Enum.KeyCode.O] = "o",
    [Enum.KeyCode.P] = "p", [Enum.KeyCode.L] = "l", [Enum.KeyCode.K] = "k",
    [Enum.KeyCode.J] = "j", [Enum.KeyCode.M] = "m", [Enum.KeyCode.N] = "n",
    [Enum.KeyCode.W] = "w", [Enum.KeyCode.A] = "a", [Enum.KeyCode.S] = "s",
    [Enum.KeyCode.D] = "d", [Enum.KeyCode.Return] = "return",
    [Enum.KeyCode.LeftShift] = "shift", [Enum.KeyCode.LeftControl] = "ctrl",
}
local VIRTUAL_TOUCH_KEYS = {
    ["1"] = 0x31, ["2"] = 0x32, ["3"] = 0x33,
    ["r"] = 0x52, ["e"] = 0x45, ["f"] = 0x46, ["q"] = 0x51,
    ["t"] = 0x54, ["g"] = 0x47, ["space"] = 0x20,
    ["shift"] = 0xA0, ["ctrl"] = 0xA2, ["return"] = 0x0D,
}
local MOBILE_TOUCH_STATE = {
    touching = false,
    touchStartPos = Vector2.zero,
    touchCurrentPos = Vector2.zero,
    lastTapTime = 0,
}
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
    if gameProcessed then return end
    MOBILE_TOUCH_STATE.touching = true
    MOBILE_TOUCH_STATE.touchStartPos = touch.Position
    MOBILE_TOUCH_STATE.touchCurrentPos = touch.Position
    MOBILE_TOUCH_STATE.lastTapTime = tick()
end)
UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
    if gameProcessed then return end
    MOBILE_TOUCH_STATE.touchCurrentPos = touch.Position
end)
UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
    MOBILE_TOUCH_STATE.touching = false
end)
local visibilityCache = {}
local VISIBILITY_CACHE_TTL = 0.12
local function isShootButtonPressed()
    if IS_MOBILE then
        return MOBILE_TOUCH_STATE.touching
    end
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end
local function getScreenPointForAim()
    if IS_MOBILE then
        if MOBILE_TOUCH_STATE.touching then
            return MOBILE_TOUCH_STATE.touchCurrentPos
        end
        local cam = workspace.CurrentCamera
        if cam then
            return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        end
        return Vector2.zero
    end
    local loc = UserInputService:GetMouseLocation()
    return Vector2.new(loc.X, loc.Y)
end
local Window = Library:CreateWindow({
	Title = "Baza Hub | Baza2000ultrapro",
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = false,
	UnlockMouseWhileOpen = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})
local Tabs = {
	Combat = Window:AddTab("Combat"),
	Character = Window:AddTab("Character"),
	Visuals = Window:AddTab("Visuals"),
	World = Window:AddTab("World"),
	Misc = Window:AddTab("Misc"),
	['UI Settings'] = Window:AddTab('Settings'),
}
local qwe;qwe=hookfunction(getrenv().setmetatable,newcclosure(function(Table,Metatable)
    if type(Metatable)=="table" and rawget(Metatable,"__mode")=="kv" then
        local ok,src=pcall(debug.info,2,"s")
        if ok and src and src:find("MiscellaneousController") then
            return qwe({1,2,3},{})
        end
    end
    return qwe(Table,Metatable)
end))
local function instanceShowLoadingNotification()
    return function() end
end
getgenv().InstanceModuleCache = getgenv().InstanceModuleCache or {}
local function instanceSafeRequire(moduleRef, timeoutSec)
    local cache = getgenv().InstanceModuleCache
    local key = typeof(moduleRef) == "Instance" and moduleRef:GetFullName() or tostring(moduleRef)
    if cache[key] ~= nil then return cache[key] end
    local deadline = timeoutSec and (os.clock() + timeoutSec) or math.huge
    local lastErr
    while os.clock() < deadline do
        if typeof(moduleRef) == "Instance" and not moduleRef.Parent then
            task.wait(0.1)
        else
            local ok, result = pcall(require, moduleRef)
            if ok then
                cache[key] = result
                return result
            end
            lastErr = result
            task.wait(0.1)
        end
    end
    error("[Baza Hub] module load failed: " .. key .. " (" .. tostring(lastErr) .. ")")
end
getgenv().InstanceRequire = instanceSafeRequire
local function instancePreloadCoreModules()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer or players.PlayerAdded:Wait()
    local playerScripts = localPlayer:WaitForChild("PlayerScripts", 8)
    local modulesFolder = replicatedStorage:WaitForChild("Modules", 8)
    pcall(function() instanceSafeRequire(modulesFolder:WaitForChild("EnumLibrary", 4)) end)
    pcall(function() instanceSafeRequire(modulesFolder:WaitForChild("Utility", 4)) end)
    local controllers = playerScripts:WaitForChild("Controllers", 8)
    pcall(function() instanceSafeRequire(controllers:WaitForChild("FighterController", 4)) end)
    pcall(function() instanceSafeRequire(controllers:WaitForChild("CameraController", 4)) end)
end
local function instanceHideErrorPromptsStep()
    local coreGui = game:GetService("CoreGui")
    local robloxGui = coreGui:FindFirstChild("RobloxGui")
    if robloxGui then
        local errorPrompt = robloxGui:FindFirstChild("ErrorPrompt")
        if errorPrompt and errorPrompt:IsA("GuiObject") then
            errorPrompt.Visible = false
        end
    end
    local promptGui = coreGui:FindFirstChild("RobloxPromptGui")
    if promptGui and promptGui:IsA("GuiObject") then
        promptGui.Visible = false
    end
end
local function instanceRunLoadingBootstrap()
    local runService = game:GetService("RunService")
    local dismissLoading = instanceShowLoadingNotification()
    local hideErrors = true
    local hideConn = runService.RenderStepped:Connect(function()
        if hideErrors then instanceHideErrorPromptsStep() end
    end)
    task.wait(0.8)
    pcall(instancePreloadCoreModules)
    hideErrors = false
    if hideConn then hideConn:Disconnect() hideConn = nil end
    if dismissLoading then dismissLoading() end
end
local RunService = game:GetService("RunService")
instanceRunLoadingBootstrap()
local UserInputServiceMenu = game:GetService("UserInputService")
pcall(function()
    if setfpscap then setfpscap(0) end
end)
local function instancePlainReplace(str, find, replace)
    local startPos = 1
    while true do
        local s, e = str:find(find, startPos, true)
        if not s then break end
        str = str:sub(1, s - 1) .. replace .. str:sub(e + 1)
        startPos = s + #replace
    end
    return str
end
getgenv().InstanceSliderFillState = getgenv().InstanceSliderFillState or {}
getgenv().InstanceSliderFollowRate = getgenv().InstanceSliderFollowRate or 11
getgenv().InstanceSetSliderFill = function(fill, targetX, hideBorder, sliderObj, forceSnap)
    if not fill or not fill.Parent then return end
    targetX = math.floor(tonumber(targetX) or 0)
    local stateMap = getgenv().InstanceSliderFillState
    if forceSnap then
        fill.Size = UDim2.new(0, targetX, 1, 0)
        if hideBorder and sliderObj then
            hideBorder.Visible = not (targetX == sliderObj.MaxSize or targetX == 0)
        end
        stateMap[fill] = nil
        return
    end
    local st = stateMap[fill]
    if st then
        st.target = targetX
        st.hideBorder = hideBorder
        st.sliderObj = sliderObj
    else
        stateMap[fill] = { target = targetX, pos = fill.Size.X.Offset, hideBorder = hideBorder, sliderObj = sliderObj }
    end
end
if not getgenv().InstanceSliderFillBound then
    getgenv().InstanceSliderFillBound = true
    RunService.RenderStepped:Connect(function(dt)
        local stateMap = getgenv().InstanceSliderFillState
        if not stateMap then return end
        dt = math.clamp(tonumber(dt) or 0, 1 / 1000, 1 / 15)
        local follow = getgenv().InstanceSliderFollowRate or 11
        local step = 1 - math.exp(-follow * dt)
        for fill, st in pairs(stateMap) do
            if not fill.Parent then
                stateMap[fill] = nil
            else
                st.pos = st.pos + (st.target - st.pos) * step
                if math.abs(st.target - st.pos) < 0.35 then st.pos = st.target end
                local x = math.floor(st.pos + 0.5)
                fill.Size = UDim2.new(0, x, 1, 0)
                if st.hideBorder and st.sliderObj then
                    st.hideBorder.Visible = not (x == st.sliderObj.MaxSize or x == 0)
                end
            end
        end
    end)
end
local INSTANCE_ACCENT = Color3.fromRGB(0, 200, 255)
local INSTANCE_BROWN_ACCENTS = {
    Color3.fromRGB(200, 149, 108),
    Color3.fromRGB(200, 149, 106),
    Color3.fromRGB(200, 149, 107),
    Color3.fromRGB(0, 110, 55),
}
local function colorNearAccent(a, b)
    return math.abs(a.R - b.R) + math.abs(a.G - b.G) + math.abs(a.B - b.B) < 0.04
end
local function isLegacyBrownAccent(c)
    for _, legacy in ipairs(INSTANCE_BROWN_ACCENTS) do
        if colorNearAccent(c, legacy) then
            return true
        end
    end
    return false
end
local function applyInstanceAccentTheme()
    if not Library then return end
    Library.AccentColor = INSTANCE_ACCENT
    if Library.GetDarkerColor then
        Library.AccentColorDark = Library:GetDarkerColor(INSTANCE_ACCENT)
    else
        local h, s, v = Color3.toHSV(INSTANCE_ACCENT)
        Library.AccentColorDark = Color3.fromHSV(h, s, v / 1.5)
    end
    if Library.UpdateColorsUsingRegistry then
        pcall(function() Library:UpdateColorsUsingRegistry() end)
    end
    pcall(function()
        if Library.ScreenGui then
            for _, obj in ipairs(Library.ScreenGui:GetDescendants()) do
                if obj:IsA("GuiObject") and isLegacyBrownAccent(obj.BackgroundColor3) then
                    obj.BackgroundColor3 = INSTANCE_ACCENT
                end
                if obj:IsA("TextLabel") and isLegacyBrownAccent(obj.TextColor3) then
                    obj.TextColor3 = INSTANCE_ACCENT
                end
            end
        end
    end)
end
applyInstanceAccentTheme()
getgenv().InstanceApplyAccentTheme = applyInstanceAccentTheme
local INSTANCE_MENU_DISPLAY_ORDER = 2147483646
local INSTANCE_COSMETIC_DISPLAY_ORDER = 2147483647
local INSTANCE_KEYBIND_LIST_ORDER = 80
local INSTANCE_GAMEPLAY_OVERLAY_ORDER = 10
local function applyInstanceUiLayering()
    pcall(function()
        if Library and Library.ScreenGui then
            Library.ScreenGui.DisplayOrder = INSTANCE_MENU_DISPLAY_ORDER
            Library.ScreenGui.IgnoreGuiInset = true
            Library.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        end
    end)
    pcall(function()
        local st = getgenv().InstanceCosmeticUIState
        if st and st.gui then
            st.gui.DisplayOrder = INSTANCE_COSMETIC_DISPLAY_ORDER
            st.gui.IgnoreGuiInset = true
            st.gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        end
    end)
    pcall(function()
        local kb = getgenv().InstanceKeybindList
        if kb and kb.gui then
            kb.gui.DisplayOrder = INSTANCE_KEYBIND_LIST_ORDER
            kb.gui.IgnoreGuiInset = true
            kb.gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        end
    end)
end
getgenv().InstanceApplyUiLayering = applyInstanceUiLayering
applyInstanceUiLayering()
getgenv().InstanceMenuCursor = getgenv().InstanceMenuCursor or {}
local function ensureInstanceMenuCursor()
    if IS_MOBILE then return end
    local mc = getgenv().InstanceMenuCursor
    if mc.cursor then pcall(function() mc.cursor:Remove() end) end
    if mc.outline then pcall(function() mc.outline:Remove() end) end
    mc.cursor = Drawing.new("Triangle")
    mc.cursor.Filled = true
    mc.cursor.Thickness = 1
    mc.cursor.Visible = false
    mc.outline = Drawing.new("Triangle")
    mc.outline.Filled = false
    mc.outline.Thickness = 1
    mc.outline.Color = Color3.new(0, 0, 0)
    mc.outline.Visible = false
    mc.initialized = true
    mc.wasOpen = false
    mc.savedMouseIcon = true
end
local function isInstanceMenuOpen()
    if not Library or Library.Unloaded then return false end
    if Window and Window.Holder and Window.Holder.Parent then
        return Window.Holder.Visible
    end
    return false
end
local function shouldSuppressGameplayOverlays()
    return isInstanceMenuOpen()
end
if not IS_MOBILE then
    ensureInstanceMenuCursor()
end
local MENU_CURSOR_HZ = 60
local MENU_CURSOR_BIND = "InstanceMenuCursorDraw"
local menuCursorAccum = 0
local function drawInstanceMenuCursor()
    local mc = getgenv().InstanceMenuCursor
    if not mc or not mc.cursor or not mc.outline then return end
    local open = isInstanceMenuOpen()
    if not open then
        if mc.cursor.Visible then
            mc.cursor.Visible = false
            mc.outline.Visible = false
        end
        if mc.wasOpen then
            UserInputServiceMenu.MouseIconEnabled = mc.savedMouseIcon
        end
        mc.wasOpen = false
        return
    end
    if not mc.wasOpen then
        mc.savedMouseIcon = UserInputServiceMenu.MouseIconEnabled
    end
    UserInputServiceMenu.MouseIconEnabled = false
    local cam = workspace.CurrentCamera
    local mPos = cam and Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2) or Vector2.new(0, 0)
    local accent = (Library and Library.AccentColor) or Color3.fromRGB(0, 200, 255)
    mc.cursor.Visible = true
    mc.outline.Visible = true
    mc.cursor.Color = accent
    mc.cursor.PointA = Vector2.new(mPos.X, mPos.Y)
    mc.cursor.PointB = Vector2.new(mPos.X + 16, mPos.Y + 6)
    mc.cursor.PointC = Vector2.new(mPos.X + 6, mPos.Y + 16)
    mc.outline.PointA = mc.cursor.PointA
    mc.outline.PointB = mc.cursor.PointB
    mc.outline.PointC = mc.cursor.PointC
    mc.wasOpen = true
end
if not IS_MOBILE then
    pcall(function() RunService:UnbindFromRenderStep(MENU_CURSOR_BIND) end)
    pcall(function()
        RunService:BindToRenderStep(MENU_CURSOR_BIND, Enum.RenderPriority.Last.Value + 10, function(dt)
            menuCursorAccum = menuCursorAccum + (dt or 0)
            local step = 1 / MENU_CURSOR_HZ
            if menuCursorAccum < step then return end
            menuCursorAccum = menuCursorAccum % step
            drawInstanceMenuCursor()
        end)
    end)
end
getgenv().InstanceIsMenuOpen = isInstanceMenuOpen
getgenv().InstanceLanguage = getgenv().InstanceLanguage or "english"
local InstanceWeaponTranslations = {
    korean = {
        ["Assault Rifle"] = "돌격 소총", ["Handgun"] = "권총", ["Shotgun"] = "산탄총", ["Sniper"] = "저격총",
        ["Bow"] = "활", ["Burst Rifle"] = "버스트 소총", ["Crossbow"] = "석궁", ["Gunblade"] = "건블레이드",
        ["RPG"] = "RPG", ["Energy Rifle"] = "에너지 소총", ["Flamethrower"] = "화염방사기",
        ["Grenade Launcher"] = "유탄 발사기", ["Minigun"] = "미니건", ["Paintball Gun"] = "페인트볼 건",
        ["Distortion"] = "디스토션", ["Permafrost"] = "영구 동토", ["Daggers"] = "단검", ["Flare Gun"] = "플레어 건",
        ["Revolver"] = "리볼버", ["Shorty"] = "쇼티", ["Spray"] = "스프레이", ["Uzi"] = "UZI",
        ["Energy Pistols"] = "에너지 권총", ["Exogun"] = "엑소건", ["Slingshot"] = "새총", ["Warper"] = "워퍼",
        ["Fists"] = "주먹", ["Battle Axe"] = "전투 도끼", ["Chainsaw"] = "전기톱", ["Katana"] = "카타나",
        ["Knife"] = "나이프", ["Riot Shield"] = "방패", ["Scythe"] = "낫", ["Maul"] = "망치",
        ["Trowel"] = "모종삽", ["Grenade"] = "수류탄", ["Flashbang"] = "섬광탄", ["Freeze Ray"] = "냉동 광선",
        ["Jump Pad"] = "점프 패드", ["Molotov"] = "화염병", ["Satchel"] = "가방", ["Smoke Grenade"] = "연막탄",
        ["War Horn"] = "나팔", ["Medkit"] = "의료 키트", ["Substapce Tripmine"] = "지뢰", ["Warpstone"] = "워프석",
        ["Hook"] = "갈고리", ["Spear"] = "창", ["Grappler"] = "그래플러", ["Maul"] = "망치",
    },
    spanish = {
        ["Assault Rifle"] = "rifle de asalto", ["Handgun"] = "pistola", ["Shotgun"] = "escopeta", ["Sniper"] = "francotirador",
        ["Bow"] = "arco", ["Burst Rifle"] = "rifle ráfaga", ["Crossbow"] = "ballesta", ["Gunblade"] = "espada-pistola",
        ["RPG"] = "RPG", ["Energy Rifle"] = "rifle de energía", ["Flamethrower"] = "lanzallamas",
        ["Grenade Launcher"] = "lanzagranadas", ["Minigun"] = "minigun", ["Paintball Gun"] = "pistola de paintball",
        ["Distortion"] = "distorsión", ["Permafrost"] = "permafrost", ["Daggers"] = "dagas", ["Flare Gun"] = "pistola de bengalas",
        ["Revolver"] = "revólver", ["Shorty"] = "shorty", ["Spray"] = "spray", ["Uzi"] = "uzi",
        ["Energy Pistols"] = "pistolas de energía", ["Exogun"] = "exopistola", ["Slingshot"] = "honda", ["Warper"] = "teletransportador",
        ["Fists"] = "puños", ["Battle Axe"] = "hacha de batalla", ["Chainsaw"] = "motosierra", ["Katana"] = "katana",
        ["Knife"] = "cuchillo", ["Riot Shield"] = "escudo", ["Scythe"] = "guadaña", ["Maul"] = "mazo",
        ["Trowel"] = "paleta", ["Grenade"] = "granada", ["Flashbang"] = "granada cegadora", ["Freeze Ray"] = "rayo congelante",
        ["Jump Pad"] = "plataforma de salto", ["Molotov"] = "cóctel molotov", ["Satchel"] = "mochila", ["Smoke Grenade"] = "granada de humo",
        ["War Horn"] = "cuerno de guerra", ["Medkit"] = "botiquín", ["Substapce Tripmine"] = "mina", ["Warpstone"] = "piedra de teletransporte",
        ["Hook"] = "gancho", ["Spear"] = "lanza", ["Grappler"] = "gancho", ["Maul"] = "mazo",
    },
}
local InstanceLocaleTable = {
    english = {
        studs = "%.0f studs", studs_short = "%d studs", select_weapon = "select a weapon first",
        apply = "apply", apply_all = "apply to all", language = "language",
        cosmetic_title = "cosmetic changer", weapons = "weapons", cosmetics = "cosmetics",
        filter_weapons = "filter weapons...", filter_cosmetics = "filter cosmetics...",
        skin = "skin", wrap = "wrap", rclick_hint = "r-click weapon: remove skin",
        unlock_all = "unlock all", inverted = "inverted", favorited = "favorited",
    },
    korean = {
        studs = "%.0f 스터드", studs_short = "%d 스터드", select_weapon = "무기를 먼저 선택하세요",
        apply = "적용", apply_all = "전체 적용", language = "언어",
        cosmetic_title = "코스메틱 변경", weapons = "무기", cosmetics = "코스메틱",
        filter_weapons = "무기 검색...", filter_cosmetics = "코스메틱 검색...",
        skin = "스킨", wrap = "랩", rclick_hint = "우클릭: 스킨 제거",
        unlock_all = "전체 해제", inverted = "반전", favorited = "즐겨찾기",
    },
    spanish = {
        studs = "%.0f studs", studs_short = "%d studs", select_weapon = "selecciona un arma primero",
        apply = "aplicar", apply_all = "aplicar a todos", language = "idioma",
        cosmetic_title = "cambiador de cosméticos", weapons = "armas", cosmetics = "cosméticos",
        filter_weapons = "filtrar armas...", filter_cosmetics = "filtrar cosméticos...",
        skin = "skin", wrap = "wrap", rclick_hint = "clic derecho: quitar skin",
        unlock_all = "desbloquear todo", inverted = "invertido", favorited = "favorito",
    },
}
getgenv().InstanceTranslateWeapon = function(name)
    if not name or type(name) ~= "string" then return name end
    local lang = getgenv().InstanceLanguage or "english"
    if lang == "english" then return name end
    local pack = InstanceWeaponTranslations[lang]
    return (pack and pack[name]) or name
end
getgenv().InstanceTranslateLabel = function(text)
    if not text or type(text) ~= "string" then return text end
    local lang = getgenv().InstanceLanguage or "english"
    if lang == "english" then return text:lower() end
    local translated = getgenv().InstanceTranslateWeapon(text)
    if translated ~= text then return translated:lower() end
    return text:lower()
end
getgenv().InstanceGetUiFont = function()
    if getgenv().InstanceLanguage == "korean" and getgenv().InstanceUIFont then
        return getgenv().InstanceUIFont
    end
    if Library and Library.Font then
        return Library.Font
    end
    return getgenv().InstanceUIFont or Enum.Font.Roboto
end
getgenv().InstanceL = function(key, ...)
    local lang = getgenv().InstanceLanguage or "english"
    local pack = InstanceLocaleTable[lang] or InstanceLocaleTable.english
    local template = pack[key] or InstanceLocaleTable.english[key] or key
    if select("#", ...) > 0 then
        return string.format(template, ...)
    end
    return template
end
local InstanceFontHttp = game:GetService("HttpService")
local InstanceFontSources = {
    english = { file = "instance_ui_en.otf", fontFile = "instance_ui_en.font", name = "InstanceUI_En", url = "https://github.com/nyrus573l/esp-fonts/raw/refs/heads/main/fortnite.otf" },
    korean = { file = "instance_ui_ko.otf", fontFile = "instance_ui_ko.font", name = "InstanceUI_Ko", url = "https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/Korean/NotoSansCJKkr-Regular.otf" },
    spanish = { file = "instance_ui_es.otf", fontFile = "instance_ui_es.font", name = "InstanceUI_Es", url = "https://github.com/nyrus573l/esp-fonts/raw/refs/heads/main/fortnite.otf" },
}
local function loadInstanceLanguageFont(lang)
    lang = lang or getgenv().InstanceLanguage or "english"
    local src = InstanceFontSources[lang] or InstanceFontSources.english
    local ok, face = pcall(function()
        if isfile and writefile and getcustomasset then
            if not isfile(src.file) then
                writefile(src.file, game:HttpGet(src.url))
            end
            if isfile(src.fontFile) then pcall(function() delfile(src.fontFile) end) end
            local fontdata = { name = src.name, faces = {{ name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(src.file) }} }
            writefile(src.fontFile, InstanceFontHttp:JSONEncode(fontdata))
            return Font.new(getcustomasset(src.fontFile))
        end
        return nil
    end)
    if ok and face then
        getgenv().InstanceUIFont = face
        return face
    end
    getgenv().InstanceUIFont = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    return getgenv().InstanceUIFont
end
getgenv().InstanceReloadLanguageFont = function(lang)
    lang = lang or getgenv().InstanceLanguage or "english"
    if lang == "english" and Library and Library.Font then
        getgenv().InstanceUIFont = Library.Font
        return Library.Font
    end
    return loadInstanceLanguageFont(lang)
end
task.defer(function()
    pcall(function()
        getgenv().InstanceReloadLanguageFont(getgenv().InstanceLanguage)
    end)
end)
getgenv().InstanceDrawingTextPool = getgenv().InstanceDrawingTextPool or {}
getgenv().InstanceTrackDrawingText = function(obj)
    table.insert(getgenv().InstanceDrawingTextPool, obj)
    pcall(function()
        local face = getgenv().InstanceUIFont
        if face and obj.FontFace ~= nil then obj.FontFace = face end
    end)
    return obj
end
getgenv().InstanceApplyDrawingUIFont = function()
    local face = getgenv().InstanceUIFont
    if not face then return end
    for _, obj in ipairs(getgenv().InstanceDrawingTextPool) do
        pcall(function()
            if obj.FontFace ~= nil then obj.FontFace = face end
        end)
    end
end
getgenv().InstanceApplyUiFont = function(obj, textSize)
    if not obj then return end
    if textSize then obj.TextSize = textSize end
    local font = getgenv().InstanceGetUiFont()
    pcall(function()
        if typeof(font) == "Font" then
            obj.FontFace = font
        else
            obj.Font = font
        end
    end)
end
getgenv().InstanceApplyUIFont = function()
    local face = getgenv().InstanceGetUiFont()
    if not face then return end
    getgenv().InstanceUIFont = face
    if _G.ESPObjects then
        for _, box in pairs(_G.ESPObjects) do
            if box and box.text then
                for _, lbl in pairs(box.text) do
                    if typeof(lbl) == "Instance" and lbl:IsA("TextLabel") then
                        lbl.FontFace = face
                    end
                end
            end
        end
    end
    if getgenv().InstanceApplyDrawingUIFont then pcall(getgenv().InstanceApplyDrawingUIFont) end
    if getgenv().InstanceApplyKbListTheme then pcall(getgenv().InstanceApplyKbListTheme) end
end
getgenv().InstanceHudFonts = {
    { n = "gotham", draw = 2, face = function() return Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium) end },
    { n = "code", draw = 3, face = function() return Font.fromEnum(Enum.Font.Code) end },
    { n = "roboto", draw = 1, face = function() return Font.fromEnum(Enum.Font.Roboto) end },
    { n = "builder", draw = 0, face = function() return Font.fromEnum(Enum.Font.BuilderSans) end },
    { n = "arial", draw = 1, face = function() return Font.fromEnum(Enum.Font.Arial) end },
    { n = "legacy", draw = 0, face = function() return Font.fromEnum(Enum.Font.Legacy) end },
    { n = "source", draw = 2, face = function() return Font.fromEnum(Enum.Font.SourceSans) end },
    { n = "custom", draw = 2, face = function() return getgenv().InstanceUIFont or Font.fromEnum(Enum.Font.Gotham) end },
}
getgenv().InstanceHudFontNames = {}
for i, slot in ipairs(getgenv().InstanceHudFonts) do
    getgenv().InstanceHudFontNames[i] = slot.n
end
getgenv().InstanceHudFontIdx = 1
getgenv().InstanceHudDrawFont = 2
getgenv().InstanceHudFontIndexByName = function(name)
    for i, slot in ipairs(getgenv().InstanceHudFonts) do
        if slot.n == name then return i end
    end
    return 1
end
getgenv().InstanceApplyHudFont = function(idx)
    idx = math.clamp(tonumber(idx) or getgenv().InstanceHudFontIdx or 1, 1, #getgenv().InstanceHudFonts)
    local slot = getgenv().InstanceHudFonts[idx]
    getgenv().InstanceHudFontIdx = idx
    getgenv().InstanceHudDrawFont = slot.draw or 2
    local face
    pcall(function() face = slot.face() end)
    if face then getgenv().InstanceEspUiFont = face end
    if _G.ESPObjects then
        for _, box in pairs(_G.ESPObjects) do
            if box and box.text then
                for _, lbl in pairs(box.text) do
                    if typeof(lbl) == "Instance" and lbl:IsA("TextLabel") and face then
                        lbl.FontFace = face
                    end
                end
            end
        end
    end
    for _, obj in ipairs(getgenv().InstanceDrawingTextPool or {}) do
        pcall(function()
            if obj.Font ~= nil then obj.Font = getgenv().InstanceHudDrawFont end
            if face and obj.FontFace ~= nil then obj.FontFace = face end
        end)
    end
end
local function alignInstanceMenuTabs()
    if not Window or not Window.Holder then return end
    local inner = Window.Holder:FindFirstChildOfClass("Frame")
    if not inner then return end
    local tabArea, tabLayout, titleLabel
    for _, child in ipairs(inner:GetChildren()) do
        if child:IsA("TextLabel") and child.TextXAlignment == Enum.TextXAlignment.Left then
            titleLabel = child
        elseif child:IsA("Frame") then
            local layout = child:FindFirstChildOfClass("UIListLayout")
            if layout and layout.FillDirection == Enum.FillDirection.Horizontal then
                tabArea = child
                tabLayout = layout
            end
        end
    end
    if not tabArea then return end
    local titleX = titleLabel and titleLabel.Position.X.Offset or 12
    local titleWidth = 0
    if titleLabel then
        pcall(function()
            titleWidth = titleLabel.TextBounds.X
        end)
        if titleWidth <= 0 then
            titleWidth = 52
        end
    end
    tabArea.Position = UDim2.new(0, titleX + titleWidth + 10, 0, 4)
    tabArea.Size = UDim2.new(1, -(titleX + titleWidth + 18), 0, 22)
    tabArea.AnchorPoint = Vector2.new(0, 0)
    if tabLayout then
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        tabLayout.Padding = UDim.new(0, Window.TabPadding or 6)
    end
end
task.defer(alignInstanceMenuTabs)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local Camera            = workspace.CurrentCamera
local UserInputService  = game:GetService("UserInputService")
local Utility           = instanceSafeRequire(ReplicatedStorage.Modules.Utility)
local EnumLibrary       = instanceSafeRequire(ReplicatedStorage.Modules.EnumLibrary)
local LocalPlayer       = Players.LocalPlayer
_G.AspectRatioSettings = _G.AspectRatioSettings or {
    Enabled = false,
    X = 13,
    Y = 10,
}
local function getAspectStretch()
    local s = _G.AspectRatioSettings
    if s and s.Enabled then
        return s.X / s.Y
    end
    return 1
end
local function applyAspectToViewport(screenVec, cam)
    local stretch = getAspectStretch()
    if stretch == 1 then
        return screenVec
    end
    cam = cam or workspace.CurrentCamera
    if not cam then
        return screenVec
    end
    local centerY = cam.ViewportSize.Y * 0.5
    return Vector3.new(screenVec.X, centerY + (screenVec.Y - centerY) * stretch, screenVec.Z)
end
local function worldToScreen(worldPos, cam)
    cam = cam or workspace.CurrentCamera
    if not cam or not worldPos then
        return nil, false
    end
    local ok, v, onScreen = pcall(function()
        return cam:WorldToViewportPoint(worldPos)
    end)
    if not ok or not onScreen or v.Z <= 0 then
        return v, false
    end
    return applyAspectToViewport(v, cam), true
end
local function screenAnchor(xNorm, yNorm, cam)
    cam = cam or workspace.CurrentCamera
    if not cam then
        return Vector2.zero
    end
    local vs = cam.ViewportSize
    local stretch = getAspectStretch()
    local centerY = vs.Y * 0.5
    local y = centerY + (vs.Y * yNorm - centerY) * stretch
    return Vector2.new(vs.X * xNorm, y)
end
local function screenCenter(cam)
    return screenAnchor(0.5, 0.5, cam)
end
local function getUnstretchedCameraCFrame(cam)
    cam = cam or workspace.CurrentCamera
    if not cam then
        return nil
    end
    local cf = cam.CFrame
    if getAspectStretch() == 1 then
        return cf
    end
    local pos = cf.Position
    local look = cf.LookVector
    local right = cf.RightVector
    local up = right:Cross(look).Unit
    return CFrame.fromMatrix(pos, right, up, -look)
end
getgenv().InstanceGetAspectStretch = getAspectStretch
getgenv().InstanceWorldToScreen = worldToScreen
getgenv().InstanceScreenAnchor = screenAnchor
getgenv().InstanceScreenCenter = screenCenter
getgenv().InstanceGetUnstretchedCameraCFrame = getUnstretchedCameraCFrame
_G.Features = _G.Features or {}
_G.Features.CrossbowSoundId = "rbxassetid://165946246"
getgenv().InstanceCombatLastShotAt = getgenv().InstanceCombatLastShotAt or 0
local function markCombatShot()
    getgenv().InstanceCombatLastShotAt = tick()
end
getgenv().InstanceMarkCombatShot = markCombatShot
getgenv().InstanceWorldToScreenEsp = function(worldPos, cam)
    return worldToScreen(worldPos, cam)
end
local HitGroup
local damageBillboardInfoCache = setmetatable({}, { __mode = "k" })
local getDamageBillboardInfo
local startProjectileBypass
local stopProjectileBypass
do
local RightGroup = Tabs.Combat:AddLeftTabbox()
local silenttab           = RightGroup:AddTab('Silent')
local silentcustomization = RightGroup:AddTab('Customization')
local AimbotGroup     = Tabs.Combat:AddRightTabbox()
local aimbotTab       = AimbotGroup:AddTab('Aimbot')
local aimbotCustomTab = AimbotGroup:AddTab('Customization')
local textureAssets, soundsassets, HPlist, restricteditems
do
    restricteditems = {
        "Flamethrower","Fists","Battle Axe","Chainsaw","Katana","Knife",
        "Riot Shield","Scythe","Maul","Trowel","Grenade","Flashbang",
        "Jump Pad","Molotov","Satchel","Smoke Grenade","War Horn",
        "Medkit","Subspace Tripmine","Warpstone"
    }
    textureAssets = {
        ["Line"]      = "",
        ["Beam"]      = "rbxassetid://12781852245",
        ["Lightning"] = "rbxassetid://446111271",
        ["Heartrate"] = "rbxassetid://5830549480",
        ["Chain"]     = "rbxassetid://9632168658",
        ["Glitch"]    = "rbxassetid://8089467613",
        ["Swirl"]     = "rbxassetid://5638168605",
        ["Neon"]      = "rbxassetid://6361963422",
        ["Plasma"]    = "rbxassetid://8993645509",
        ["Laser"]     = "rbxassetid://14549123968",
    }
    soundsassets = {
        ["Rust HS"]           = "rbxassetid://5043539486",
        ["Neverlose"]         = "rbxassetid://97643101798871",
        ["Minecraft Bow"]     = "rbxassetid://3442683707",
        ["Minecraft Hit"]     = "rbxassetid://8766809464",
        ["CSGO"]              = "rbxassetid://5764885315",
        ["Bubble"]            = "rbxassetid://6534947588",
        ["Lazer"]             = "rbxassetid://130791043",
        ["Pick"]              = "rbxassetid://1347140027",
        ["Pop"]               = "rbxassetid://198598793",
        ["Rust"]              = "rbxassetid://1255040462",
        ["Sans"]              = "rbxassetid://3188795283",
        ["Fart"]              = "rbxassetid://130833677",
        ["Big"]               = "rbxassetid://5332005053",
        ["Vine"]              = "rbxassetid://5332680810",
        ["UwU"]               = "rbxassetid://8679659744",
        ["Bruh"]              = "rbxassetid://4578740568",
        ["Skeet"]             = "rbxassetid://5633695679",
        ["Fatality"]          = "rbxassetid://6534947869",
        ["Bonk"]              = "rbxassetid://5766898159",
        ["Minecraft"]         = "rbxassetid://5869422451",
        ["Gamesense"]         = "rbxassetid://4817809188",
        ["RIFK7"]             = "rbxassetid://9102080552",
        ["Bamboo"]            = "rbxassetid://3769434519",
        ["Crowbar"]           = "rbxassetid://546410481",
        ["Weeb"]              = "rbxassetid://6442965016",
        ["Beep"]              = "rbxassetid://8177256015",
        ["Bambi"]             = "rbxassetid://8437203821",
        ["Stone"]             = "rbxassetid://3581383408",
        ["Old Fatality"]      = "rbxassetid://6607142036",
        ["Click"]             = "rbxassetid://8053704437",
        ["Ding"]              = "rbxassetid://7149516994",
        ["Snow"]              = "rbxassetid://6455527632",
        ["Laser"]             = "rbxassetid://7837461331",
        ["Mario"]             = "rbxassetid://2815207981",
        ["Steve"]             = "rbxassetid://4965083997",
        ["Call of Duty"]      = "rbxassetid://5952120301",
        ["Bat"]               = "rbxassetid://3333907347",
        ["TF2 Critical"]      = "rbxassetid://296102734",
        ["Saber"]             = "rbxassetid://8415678813",
        ["Baimware"]          = "rbxassetid://3124331820",
        ["Osu"]               = "rbxassetid://7149255551",
        ["TF2"]               = "rbxassetid://2868331684",
        ["Slime"]             = "rbxassetid://6916371803",
        ["Among Us"]          = "rbxassetid://5700183626",
        ["One"]               = "rbxassetid://7380502345",
        ["Soft Bell"]         = "rbxassetid://9114487369",
        ["Minecraft Bow Hit"] = "rbxassetid://1053296915",
    }
    HPlist = {
        "Head","HumanoidRootPart","Torso","UpperTorso","LowerTorso",
        "Left Arm","LeftHand","LeftLowerArm","LeftUpperArm",
        "Right Arm","RightHand","RightLowerArm","RightUpperArm",
        "Left Leg","LeftFoot","LeftLowerLeg","LeftUpperLeg",
        "Right Leg","RightFoot","RightLowerLeg","RightUpperLeg",
        "Neck","Back","Front","Closest","Random"
    }
end
local antikatana = false
local katanausers = {}
local function detectkatana()
    local lp = Players.LocalPlayer
    if not lp:FindFirstChild("PlayerScripts") then
        lp.PlayerScriptsAdded:Wait()
    end
    task.spawn(function()
        local katana, attempts = nil, 0
        while attempts < 10 do
            pcall(function()
                local m = lp.PlayerScripts.Modules.Items:FindFirstChild("Katana", true)
                if m then katana = require(m) end
            end)
            if not katana then
                for _, m in pairs(lp.PlayerScripts:GetDescendants()) do
                    if m.Name == "Katana" and m:IsA("ModuleScript") then
                        local ok, res = pcall(require, m)
                        if ok then katana = res; break end
                    end
                end
            end
            if katana and type(katana) == "table" and katana.StartAiming then break end
            attempts += 1
            task.wait(1)
        end
        if katana and type(katana) == "table" and katana.StartAiming then
            local old = katana.StartAiming
            katana.StartAiming = function(self, force)
                local fighter = self.ClientFighter
                local player  = fighter and fighter.Player
                if player then
                    katanausers[player] = true
                    local dur = self.Info.DeflectDuration or 0.6
                    task.delay(dur, function() katanausers[player] = nil end)
                end
                return old(self, force)
            end
        end
    end)
end
detectkatana()
local function katanadeflect(player)
    return katanausers[player] == true
end
local function weaponstricted(weaponName)
    if not weaponName then return false end
    for _, w in ipairs(restricteditems) do
        if weaponName == w then return true end
    end
    return false
end
local function curweap2()
    local vm = Workspace:FindFirstChild("ViewModels")
    if not vm then return nil end
    local fp = vm:FindFirstChild("FirstPerson")
    if not fp then return nil end
    for _, child in ipairs(fp:GetChildren()) do
        local parts = {}
        for p in child.Name:gmatch("[^-]+") do
            table.insert(parts, p:match("^%s*(.-)%s*$"))
        end
        if #parts >= 2 then return parts[2] end
    end
    return nil
end
local fovScreenGui = Instance.new("ScreenGui")
fovScreenGui.Name            = "FOVScreenGui"
fovScreenGui.DisplayOrder    = INSTANCE_GAMEPLAY_OVERLAY_ORDER
fovScreenGui.ResetOnSpawn    = false
fovScreenGui.IgnoreGuiInset  = true
fovScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
fovScreenGui.Parent          = game.CoreGui
local function buildfov(name, cfg)
    local container = Instance.new("Frame")
    container.Name                   = name
    container.BackgroundTransparency = 1
    container.BorderSizePixel        = 0
    container.Visible                = false
    container.Parent                 = fovScreenGui
    local fill = Instance.new("Frame")
    fill.Size                   = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3       = Color3.new(1, 1, 1)
    fill.BackgroundTransparency = cfg.FilledTransparency
    fill.BorderSizePixel        = 0
    fill.Visible                = false
    fill.ZIndex                 = 1
    fill.Parent                 = container
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent       = fill
    local fillgrad = Instance.new("UIGradient")
    fillgrad.Color    = ColorSequence.new({
        ColorSequenceKeypoint.new(0, cfg.FilledColor1),
        ColorSequenceKeypoint.new(1, cfg.FilledColor2),
    })
    fillgrad.Rotation = cfg.FilledRotation
    fillgrad.Parent   = fill
    local outline = Instance.new("Frame")
    outline.Size                   = UDim2.new(1, 0, 1, 0)
    outline.BackgroundTransparency = 1
    outline.BorderSizePixel        = 0
    outline.ZIndex                 = 2
    outline.Parent                 = container
    local outlineCorner = Instance.new("UICorner")
    outlineCorner.CornerRadius = UDim.new(1, 0)
    outlineCorner.Parent       = outline
    local stroke = Instance.new("UIStroke")
    stroke.Color           = Color3.new(1, 1, 1)
    stroke.Thickness       = cfg.OutlineThickness
    stroke.Transparency    = cfg.OutlineTransparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent          = outline
    local strokegrad = Instance.new("UIGradient")
    strokegrad.Color    = ColorSequence.new({
        ColorSequenceKeypoint.new(0, cfg.OutlineColor1),
        ColorSequenceKeypoint.new(1, cfg.OutlineColor2),
    })
    strokegrad.Rotation = cfg.OutlineRotation
    strokegrad.Parent   = stroke
    return {
        container      = container,
        fill           = fill,
        fillgrad   = fillgrad,
        stroke         = stroke,
        strokegrad = strokegrad,
    }
end
local silentFOVCfg = {
    OutlineColor1       = Color3.fromRGB(255, 255, 255),
    OutlineColor2       = Color3.fromRGB(255, 255, 255),
    OutlineRotation     = 0,
    OutlineThickness    = 1.5,
    OutlineTransparency = 0,
    FilledEnabled       = false,
    FilledColor1        = Color3.fromRGB(255, 255, 255),
    FilledColor2        = Color3.fromRGB(0, 0, 0),
    FilledRotation      = 0,
    FilledTransparency  = 0.7,
    FilledAnimated      = false,
    FilledSpeed         = 1,
    SpinOn              = false,
    SpinSpd             = 1,
}
local sFOV                = buildfov("SilentFOV", silentFOVCfg)
local silentFOVContainer  = sFOV.container
local silentFOVFill       = sFOV.fill
local silentFOVFillGrad   = sFOV.fillgrad
local silentFOVStroke     = sFOV.stroke
local silentFOVStrokeGrad = sFOV.strokegrad
local function silentlinegrad()
    silentFOVStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, silentFOVCfg.OutlineColor1),
        ColorSequenceKeypoint.new(1, silentFOVCfg.OutlineColor2),
    })
end
local function updsilentgrad()
    silentFOVFillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, silentFOVCfg.FilledColor1),
        ColorSequenceKeypoint.new(1, silentFOVCfg.FilledColor2),
    })
end
local aimbotFOVCfg = {
    OutlineColor1       = Color3.fromRGB(255, 255, 255),
    OutlineColor2       = Color3.fromRGB(255, 255, 255),
    OutlineRotation     = 0,
    OutlineThickness    = 1.5,
    OutlineTransparency = 0,
    FilledEnabled       = false,
    FilledColor1        = Color3.fromRGB(255, 255, 255),
    FilledColor2        = Color3.fromRGB(0, 0, 0),
    FilledRotation      = 0,
    FilledTransparency  = 0.7,
    FilledAnimated      = false,
    FilledSpeed         = 1,
    SpinOn              = false,
    SpinSpd             = 1,
}
local aFOV                = buildfov("AimbotFOV", aimbotFOVCfg)
local aimbotFOVContainer  = aFOV.container
local aimbotFOVFill       = aFOV.fill
local aimbotFOVFillGrad   = aFOV.fillgrad
local aimbotFOVStroke     = aFOV.stroke
local aimbotFOVStrokeGrad = aFOV.strokegrad
local function updaimbotoutlinegrad()
    aimbotFOVStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, aimbotFOVCfg.OutlineColor1),
        ColorSequenceKeypoint.new(1, aimbotFOVCfg.OutlineColor2),
    })
end
local function updaimbotfillgrad()
    aimbotFOVFillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, aimbotFOVCfg.FilledColor1),
        ColorSequenceKeypoint.new(1, aimbotFOVCfg.FilledColor2),
    })
end
local bulletTracer = { enabled=false, color=Color3.fromRGB(255,255,255), style="Line", glow=0, size=1, duration=3, fadeTime=0.5 }
local DISABLE_TRACERS = false
local hitSound     = { enabled=false, style="Rust HS", volume=0.5, pitch=1.0 }
local localHitTargets = setmetatable({}, { __mode = "k" })
local silentAim    = { enabled=false, hitPart="Head", fovRadius=60, autoShoot=false, followMuzzle=false, hitChance=100 }
local aimbot       = {
    enabled = false,
    masterEnabled = false,
    keyMode = "toggle",
    showFov = false,
    targetPart = "Head",
    fovRadius = 60,
    smoothness = 2,
    aimCurve = "Linear",
    followMuzzle = false,
    lockedTarget = nil,
    smoothCF = nil,
    visibleOnly = false,
}
local backshoot    = { enabled=false, connection=nil, target=nil, origCFrame=nil }
local bulletTracers    = {}
local lastShotTime     = 0
local lastShootSoundAt = 0
local shootCooldown    = 0.1
local curtarget    = nil
local targetlasthp = setmetatable({}, { __mode = "k" })
local lastHitTime      = 0
Players.PlayerRemoving:Connect(function(player)
    targetlasthp[player] = nil
end)
local function muzzlepos()
    local vm = Workspace:FindFirstChild("ViewModels")
    if not vm then return nil end
    local fp = vm:FindFirstChild("FirstPerson")
    if not fp then return nil end
    local pn = LocalPlayer.Name
    for _, model in pairs(fp:GetChildren()) do
        if model:IsA("Model") and model.Name:find("^"..pn) then
            local iv = model:FindFirstChild("ItemVisual")
            if iv then
                local b = iv:FindFirstChild("Body")
                if b then
                    local bp = b:FindFirstChild("BodyPrimary")
                    if bp then
                        local muzzle = bp:FindFirstChild("_muzzle")
                        if muzzle and muzzle:IsA("Attachment") then
                            return muzzle.WorldPosition
                        end
                    end
                end
            end
        end
    end
    return nil
end
local function screenpos2(worldPos)
    if not worldPos then return nil end
    local sp, ok = worldToScreen(worldPos, Camera)
    if not ok then return nil end
    return Vector2.new(sp.X, sp.Y)
end
local function silentfovcenter()
    if silentAim.followMuzzle then
        local s = screenpos2(muzzlepos())
        if s then return s end
    end
    return screenCenter(Camera)
end
local function aimbotfovcenter()
    if aimbot.followMuzzle then
        local s = screenpos2(muzzlepos())
        if s then return s end
    end
    return screenCenter(Camera)
end
local function makebullettracer(pos3, endPos, isHit)
    if DISABLE_TRACERS then return nil end
    if isHit then
        local mp = muzzlepos()
        if mp then pos3 = mp end
    end
    local cfg = bulletTracer
    if isHit and cfg.style == "Line" then
        local dir    = endPos - pos3
        local dist   = dir.Magnitude
        local segs   = {}
        local segLen = 5
        for i = 1, math.ceil(dist/segLen) do
            local s  = pos3 + dir.Unit*((i-1)*segLen)
            local e  = pos3 + dir.Unit*math.min(i*segLen, dist)
            local ln = Drawing.new("Line")
            ln.Thickness    = 2*cfg.size
            ln.Color        = cfg.color
            ln.Transparency = 1
            ln.Visible      = false
            table.insert(segs, {Line=ln, StartPos=s, EndPos=e})
        end
        local t = {
            Segments      = segs,
            Lifetime      = cfg.duration,
            CreatedTime   = tick(),
            IsHitTracer   = true,
            Is2D          = true,
            FadeStartTime = tick()+cfg.duration-cfg.fadeTime,
            StartPos      = pos3,
            EndPos        = endPos,
        }
        table.insert(bulletTracers, t)
        return t
    end
    local a0   = Instance.new("Attachment"); a0.Parent = workspace.Terrain
    local a1   = Instance.new("Attachment"); a1.Parent = workspace.Terrain
    local beam = Instance.new("Beam")
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    beam.Color       = ColorSequence.new(cfg.color)
    local bw = cfg.style=="Laser" and 0.02 or (cfg.style=="Line" and 0.05 or 0.15)
    beam.Width0        = bw*cfg.size
    beam.Width1        = bw*cfg.size
    beam.Transparency  = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.5),
    })
    beam.FaceCamera    = false
    beam.LightEmission = cfg.glow
    beam.LightInfluence = 1-cfg.glow
    local glow = nil
    if cfg.glow > 0.3 then
        glow            = Instance.new("PointLight")
        glow.Brightness = cfg.glow*2
        glow.Range      = 10*cfg.size
        glow.Color      = cfg.color
        glow.Parent     = a1
    end
    if cfg.style == "Line" then
        beam.Texture       = ""
        beam.TextureLength = 1
        beam.TextureSpeed  = 0
    elseif textureAssets[cfg.style] then
        beam.Texture       = textureAssets[cfg.style]
        beam.TextureLength = 4
        beam.TextureSpeed  = 1
    else
        beam.Texture = ""
    end
    beam.Parent        = workspace.Terrain
    a0.WorldPosition   = pos3
    a1.WorldPosition   = endPos
    local t = {
        Line          = beam,
        Attachment0   = a0,
        Attachment1   = a1,
        Light         = glow,
        Lifetime      = cfg.duration,
        CreatedTime   = tick(),
        IsHitTracer   = isHit,
        Is2D          = false,
        FadeStartTime = tick()+cfg.duration-cfg.fadeTime,
    }
    table.insert(bulletTracers, t)
    return t
end
local function updateTracerGlow()
    for _, tr in ipairs(bulletTracers) do
        if tr and not tr.Is2D and tr.Line then
            local age = tick()-tr.CreatedTime
            local cfg = bulletTracer
            if age >= tr.FadeStartTime then
                local fp = math.clamp((age-tr.FadeStartTime)/cfg.fadeTime, 0, 1)
                tr.Line.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, fp),
                    NumberSequenceKeypoint.new(0.8, fp+0.1),
                    NumberSequenceKeypoint.new(1, 1),
                })
                if tr.Line.LightEmission > 0 then
                    tr.Line.LightEmission = cfg.glow*(1-fp)
                end
                if tr.Light then
                    tr.Light.Brightness = tr.Light.Brightness*(1-fp)
                end
            end
        end
    end
end
local function findShotMuzzlePosition()
    local myChar = LocalPlayer.Character
    if not myChar then
        local cam = workspace.CurrentCamera
        return cam and (cam.CFrame.Position + cam.CFrame.LookVector * 4) or Vector3.zero
    end
    local vm = Workspace:FindFirstChild("ViewModels")
    if vm then
        local fp = vm:FindFirstChild("FirstPerson")
        if fp then
            for _, model in ipairs(fp:GetChildren()) do
                if not model:IsA("Model") then
                    continue
                end
                local muzzle = model:FindFirstChild("Muzzle")
                    or model:FindFirstChild("MuzzleFlash")
                    or model:FindFirstChild("Barrel")
                    or model:FindFirstChild("GunTip")
                    or model:FindFirstChild("Flash")
                    or model:FindFirstChild("Fire")
                    or model:FindFirstChild("Tip")
                if muzzle then
                    if muzzle:IsA("Attachment") then
                        return muzzle.WorldPosition
                    end
                    if muzzle:IsA("BasePart") then
                        return muzzle.Position
                    end
                end
                for _, part in ipairs(model:GetChildren()) do
                    if part:IsA("BasePart") then
                        local pn = part.Name:lower()
                        if pn:find("tip") or pn:find("barrel") or pn:find("muzzle") or pn:find("flash") or pn:find("fire") or pn:find("gun") then
                            return part.Position
                        end
                    end
                end
                local pp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if pp then
                    return pp.Position
                end
            end
        end
    end
    local cam = workspace.CurrentCamera
    if cam then
        return cam.CFrame.Position + cam.CFrame.LookVector * 4
    end
    local root = myChar:FindFirstChild("HumanoidRootPart")
    return root and root.Position or Vector3.zero
end
local trackedAmmo = nil
local bulletDetectConn = nil
local projectileDetectConn = nil
local vmSoundConn = nil
_G.Features = _G.Features or {}
_G.Features.DisableGunSounds = _G.Features.DisableGunSounds or false
local function shootSoundsActive()
    return _G.Features.DisableGunSounds == true
end
local function restoreGunSoundVolumes()
    local function tryRestore(root)
        if not root then return end
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("Sound") and isRivalsGunSound(d) and not d:GetAttribute("InstanceShootSound") then
                pcall(function()
                    if d.Volume <= 0 then
                        d.Volume = 1
                    end
                end)
            elseif d:IsA("SoundGroup") then
                pcall(function()
                    if d.Volume <= 0 then
                        d.Volume = 1
                    end
                end)
            end
        end
    end
    tryRestore(workspace:FindFirstChild("ViewModels"))
    local cam = workspace.CurrentCamera
    if cam then
        tryRestore(cam)
    end
    local char = LocalPlayer.Character
    if char then
        tryRestore(char)
    end
end
local function bulletFeedbackActive()
    return bulletTracer.enabled
end
local function getFighterController()
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if not ps then
        return nil
    end
    local controllers = ps:FindFirstChild("Controllers")
    if not controllers then
        return nil
    end
    local fighterModule = controllers:FindFirstChild("FighterController")
    if not fighterModule or not fighterModule:IsA("ModuleScript") then
        return nil
    end
    local ok, ctrl = pcall(require, fighterModule)
    if ok then
        return ctrl
    end
    return nil
end
local function getLocalEquippedAmmo()
    local ctrl = getFighterController()
    if ctrl and ctrl.LocalFighter and ctrl.LocalFighter.EquippedItem then
        local item = ctrl.LocalFighter.EquippedItem
        local current = item:Get("CurrentAmmo")
        if current == nil then
            current = item:Get("Ammo")
        end
        if current == nil then
            current = item:Get("Bullets")
        end
        local maxAmmo = item:Get("MaxAmmo") or item:Get("MaxBullets") or 0
        if current ~= nil then
            return current, maxAmmo
        end
    end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, v in ipairs(pg:GetDescendants()) do
            if v:IsA("Frame") and v.Visible then
                local reserve = v:FindFirstChild("Reserve")
                if reserve and v:FindFirstChild("Icon") and v:FindFirstChild("ItemName") then
                    local ammoLabel = reserve:FindFirstChild("Ammo")
                    if ammoLabel then
                        local current = tonumber(ammoLabel.Text:match("%d+")) or 0
                        return current, current
                    end
                end
            end
        end
    end
    return nil, nil
end
local function isProjectilePartName(name)
    if not name then
        return false
    end
    return name == "Slingshot"
        or name == "CoreProjectile"
        or name == "OuterProjectile"
        or name:find("Projectile", 1, true) ~= nil
end
local function isLikelyLocalProjectile(inst)
    if not inst then
        return false
    end
    local part = inst:IsA("BasePart") and inst or inst:FindFirstChildWhichIsA("BasePart")
    if not part then
        if inst:IsA("Model") then
            part = inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
        end
    end
    if not part then
        return false
    end
    if not isProjectilePartName(inst.Name) and not isProjectilePartName(part.Name) then
        local namedChild = inst:FindFirstChild("CoreProjectile", true)
            or inst:FindFirstChild("OuterProjectile", true)
            or inst:FindFirstChild("Slingshot", true)
        if not namedChild then
            return false
        end
        part = namedChild:IsA("BasePart") and namedChild or namedChild:FindFirstChildWhichIsA("BasePart") or part
    end
    local muzzle = findShotMuzzlePosition()
    if (part.Position - muzzle).Magnitude <= 45 then
        return true
    end
    local cam = workspace.CurrentCamera
    if cam and (part.Position - cam.CFrame.Position).Magnitude <= 45 then
        return true
    end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myRoot and (part.Position - myRoot.Position).Magnitude <= 45 then
        return true
    end
    return false
end
local function isRivalsGunSound(sound)
    if typeof(sound) ~= "Instance" or not sound:IsA("Sound") then
        return false
    end
    if sound:GetAttribute("InstanceShootSound") then
        return false
    end
    local parent = sound.Parent
    if not parent then
        return false
    end
    local vm = workspace:FindFirstChild("ViewModels")
    if vm and sound:IsDescendantOf(vm) then
        return true
    end
    local cam = workspace.CurrentCamera
    if cam and sound:IsDescendantOf(cam) then
        return true
    end
    local char = LocalPlayer.Character
    if char and sound:IsDescendantOf(char) then
        local n = sound.Name:lower()
        if n:find("gun") or n:find("fire") or n:find("shoot") or n:find("weapon")
            or n:find("muzzle") or n:find("shell") or n:find("reload")
            or n:find("bolt") or n:find("chamber") or n:find("rifle")
            or n:find("pistol") or n:find("shotgun") or n:find("bullet") then
            return true
        end
    end
    return false
end
local function silenceRivalsGunSound(sound)
    if not isRivalsGunSound(sound) then
        return
    end
    pcall(function()
        sound:Stop()
    end)
    sound.Volume = 0
end
local function bindGunSoundMuteGuard(sound)
    if typeof(sound) ~= "Instance" or not sound:IsA("Sound") or sound:GetAttribute("InstanceShootSound") then
        return
    end
    if not sound:GetAttribute("InstanceGunMuteBound") then
        sound:SetAttribute("InstanceGunMuteBound", true)
        sound:GetPropertyChangedSignal("Volume"):Connect(function()
            if shootSoundsActive() and isRivalsGunSound(sound) then
                pcall(function()
                    sound.Volume = 0
                end)
            end
        end)
        sound:GetPropertyChangedSignal("Playing"):Connect(function()
            if not sound.Playing or not isRivalsGunSound(sound) then
                return
            end
            task.defer(function()
                if bulletFeedbackActive() then
                    handleLocalShot(true)
                else
                    registerLocalShot(true)
                end
            end)
            if shootSoundsActive() then
                silenceRivalsGunSound(sound)
            end
        end)
    end
    if shootSoundsActive() then
        silenceRivalsGunSound(sound)
    end
end
local function refreshGunSoundMute()
    if not shootSoundsActive() then
        return
    end
    local vm = workspace:FindFirstChild("ViewModels")
    if vm then
        for _, d in ipairs(vm:GetDescendants()) do
            if d:IsA("Sound") or d:IsA("SoundGroup") then
                if d:IsA("Sound") then
                    bindGunSoundMuteGuard(d)
                else
                    d.Volume = 0
                end
            end
        end
    end
    local cam = workspace.CurrentCamera
    if cam then
        for _, d in ipairs(cam:GetDescendants()) do
            if d:IsA("Sound") then
                bindGunSoundMuteGuard(d)
            end
        end
    end
end
getgenv().InstanceRefreshGunSoundMute = refreshGunSoundMute
local function registerLocalShot(bypassCooldown)
    local cw = curweap2()
    if not cw or weaponstricted(cw) then
        return
    end
    local now = tick()
    if not bypassCooldown and now - lastShotTime < shootCooldown then
        return
    end
    lastShotTime = now
    markCombatShot()
end
local function handleLocalShot(bypassCooldown)
    registerLocalShot(bypassCooldown)
    local muzzlePos = findShotMuzzlePosition()
    local endPos
    local hitInstance
    if muzzlePos then
        local camCFrame = Camera.CFrame
        endPos = camCFrame.Position + camCFrame.LookVector * 1000
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = { LocalPlayer.Character }
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local res = workspace:Raycast(muzzlePos, (endPos - muzzlePos).Unit * 1000, params)
        if res then
            endPos = res.Position
            hitInstance = res.Instance
        end
    end
    if hitInstance then
        notifyProjectileImpact(hitInstance)
    end
    if not bulletTracer.enabled or not muzzlePos then
        return
    end
    makebullettracer(muzzlePos, endPos, hitInstance ~= nil)
end
getgenv().InstanceHandleLocalShot = handleLocalShot
local function startAmmoBulletDetection()
    if bulletDetectConn then
        return
    end
    local nextAmmoCheck = 0
    bulletDetectConn = RunService.Heartbeat:Connect(function()
        local now = tick()
        if now < nextAmmoCheck then
            return
        end
        nextAmmoCheck = now + 0.25
        pcall(function()
            if shootSoundsActive() then
                refreshGunSoundMute()
            end
            local ammoNow = getLocalEquippedAmmo()
            if ammoNow == nil then
                trackedAmmo = nil
                return
            end
            if trackedAmmo ~= nil and ammoNow < trackedAmmo then
                local fired = math.floor(trackedAmmo - ammoNow)
                for i = 1, fired do
                    if bulletFeedbackActive() then
                        handleLocalShot(true)
                    else
                        registerLocalShot(true)
                    end
                end
            end
            trackedAmmo = ammoNow
        end)
    end)
end
local function bindProjectileImpactDetection(projectile)
    if not projectile then
        return
    end
    local handled = false
    local playerFromHitPartFn = getPlayerFromHitPart
    local notifyImpactFn = notifyProjectileImpact
    local function onTouched(hit)
        if handled or not hit or not hit.Parent then
            return
        end
        if type(notifyImpactFn) == "function" then
            notifyImpactFn(hit)
        end
        if type(playerFromHitPartFn) ~= "function" then
            return
        end
        local plr, hum = playerFromHitPartFn(hit)
        if not plr or not hum or plr == player then
            handled = true
            return
        end
        handled = true
    end
    local function bindPart(part)
        if not part or not part:IsA("BasePart") then
            return
        end
        part.Touched:Connect(onTouched)
    end
    bindPart(projectile)
    for _, child in ipairs(projectile:GetDescendants()) do
        bindPart(child)
    end
end
local function startProjectileBulletDetection()
    if projectileDetectConn then
        return
    end
    projectileDetectConn = workspace.DescendantAdded:Connect(function(d)
        if not isLikelyLocalProjectile(d) then
            return
        end
        task.defer(function()
            if bulletFeedbackActive() then
                handleLocalShot(true)
            else
                registerLocalShot(true)
            end
            bindProjectileImpactDetection(d)
        end)
    end)
end
local function bindCombatShotSounds(root)
    if not root then
        return
    end
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("Sound") then
            bindGunSoundMuteGuard(d)
        end
    end
end
local realShotHookInstalled = false
local function setupShootDetection()
    if realShotHookInstalled then
        return
    end
    realShotHookInstalled = true
    startAmmoBulletDetection()
    startProjectileBulletDetection()
    local vm = workspace:FindFirstChild("ViewModels")
    if not vm then
        vm = workspace:WaitForChild("ViewModels", 10)
    end
    if vm and not vmSoundConn then
        bindCombatShotSounds(vm)
        vmSoundConn = vm.DescendantAdded:Connect(function(d)
            if d:IsA("Sound") then
                bindGunSoundMuteGuard(d)
            elseif d:IsA("SoundGroup") and shootSoundsActive() then
                pcall(function()
                    d.Volume = 0
                end)
            end
        end)
    end
    local cam = workspace.CurrentCamera
    if cam then
        bindCombatShotSounds(cam)
    end
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if UserInputService:GetFocusedTextBox() then
            return
        end
        if bulletFeedbackActive() then
            handleLocalShot(false)
        else
            registerLocalShot(false)
        end
    end)
    refreshGunSoundMute()
end
task.defer(setupShootDetection)
local function playHS()
    local id = soundsassets[hitSound.style]
    if not id then return end
    local snd    = Instance.new("Sound")
    snd.SoundId  = id
    snd.Volume   = hitSound.volume
    snd.Pitch    = hitSound.pitch
    local cam    = workspace.CurrentCamera
    if cam then
        local att = Instance.new("Attachment")
        att.Parent = cam
        snd.Parent = att
    else
        snd.Parent = workspace
    end
    snd:Play()
    game:GetService("Debris"):AddItem(snd, 5)
    if snd.Parent then
        game:GetService("Debris"):AddItem(snd.Parent, 5)
    end
end
local function checkForHit()
    if not curtarget then return end
    local char = curtarget
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local tp = Players:GetPlayerFromCharacter(char)
    if not tp then return end
    local lastHp = targetlasthp[tp] or hum.Health
    if hum.Health < lastHp then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local tr = char:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (myChar.HumanoidRootPart.Position - tr.Position).Magnitude
                if dist <= 1500 then
                    local dir    = (tr.Position - myChar.HumanoidRootPart.Position).Unit
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = {myChar, char}
                    params.FilterType = Enum.RaycastFilterType.Exclude
                    local res     = workspace:Raycast(myChar.HumanoidRootPart.Position, dir*dist, params)
                    local visible = true
                    if res then
                        local hp = res.Instance.Parent
                        if hp ~= char and hp.Parent ~= char then visible = false end
                    end
                    if visible and tick()-lastHitTime > 0.05 then
                        lastHitTime = tick()
                        if hitSound.enabled then task.spawn(playHS) end
                    end
                end
            end
        end
    end
    targetlasthp[tp] = hum.Health
end
RunService.RenderStepped:Connect(function()
    local showSilentFOV = silentFOVContainer.Visible
    local showAimbotFOV = aimbotFOVContainer.Visible
    local hasTracers     = #bulletTracers > 0
    if not showSilentFOV and not showAimbotFOV and not hasTracers then
        return
    end
    if showSilentFOV then
        local c = silentfovcenter()
        local r = silentAim.fovRadius
        silentFOVContainer.Size     = UDim2.fromOffset(r*2, r*2)
        silentFOVContainer.Position = UDim2.fromOffset(c.X-r, c.Y-r)
        if silentFOVCfg.FilledAnimated then
            silentFOVFillGrad.Rotation = math.sin(tick()*silentFOVCfg.FilledSpeed)*180 + silentFOVCfg.FilledRotation
        elseif silentFOVCfg.SpinOn then
            silentFOVFillGrad.Rotation = silentFOVCfg.FilledRotation + (tick() * silentFOVCfg.SpinSpd * 90) % 360
        end
        if silentFOVCfg.SpinOn then
            silentFOVStrokeGrad.Rotation = silentFOVCfg.OutlineRotation + (tick() * silentFOVCfg.SpinSpd * 90) % 360
        end
    end
    if showAimbotFOV then
        local c = aimbotfovcenter()
        local r = aimbot.fovRadius
        aimbotFOVContainer.Size     = UDim2.fromOffset(r*2, r*2)
        aimbotFOVContainer.Position = UDim2.fromOffset(c.X-r, c.Y-r)
        if aimbotFOVCfg.FilledAnimated then
            aimbotFOVFillGrad.Rotation = math.sin(tick()*aimbotFOVCfg.FilledSpeed)*180 + aimbotFOVCfg.FilledRotation
        elseif aimbotFOVCfg.SpinOn then
            aimbotFOVFillGrad.Rotation = aimbotFOVCfg.FilledRotation + (tick() * aimbotFOVCfg.SpinSpd * 90) % 360
        end
        if aimbotFOVCfg.SpinOn then
            aimbotFOVStrokeGrad.Rotation = aimbotFOVCfg.OutlineRotation + (tick() * aimbotFOVCfg.SpinSpd * 90) % 360
        end
    end
    if hasTracers then
        updateTracerGlow()
        local now   = tick()
        local cam   = Camera
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myPos  = myRoot and myRoot.Position
        for _, tr in ipairs(bulletTracers) do
            if tr and tr.Is2D and tr.Segments then
                local age = now - tr.CreatedTime
                for _, seg in ipairs(tr.Segments) do
                    local show = false
                    local from, to
                    local ss, ssOk = worldToScreen(seg.StartPos, cam)
                    local se, seOk = worldToScreen(seg.EndPos, cam)
                    if ssOk and seOk then
                        if not myPos or ((seg.StartPos - myPos).Magnitude >= 2 and (seg.EndPos - myPos).Magnitude >= 2) then
                            if math.abs(ss.X) <= 20000 and math.abs(ss.Y) <= 20000 and math.abs(se.X) <= 20000 and math.abs(se.Y) <= 20000 then
                                from = Vector2.new(ss.X, ss.Y)
                                to   = Vector2.new(se.X, se.Y)
                                local len = (to - from).Magnitude
                                if len > 0.1 and len < 3000 then
                                    show = true
                                end
                            end
                        end
                    end
                    if show then
                        seg.Line.From = from
                        seg.Line.To   = to
                        seg.Line.Visible = true
                        local ft = bulletTracer.fadeTime
                        if age >= tr.Lifetime - ft then
                            seg.Line.Transparency = 1 - math.clamp((age - (tr.Lifetime - ft)) / ft, 0, 1)
                        else
                            seg.Line.Transparency = 1
                        end
                    else
                        seg.Line.Visible = false
                    end
                end
            end
        end
        for i = #bulletTracers, 1, -1 do
            local tr = bulletTracers[i]
            if tr and now - tr.CreatedTime >= tr.Lifetime then
                if tr.Is2D and tr.Segments then
                    for _, seg in ipairs(tr.Segments) do
                        if seg.Line then seg.Line:Remove() end
                    end
                elseif tr.Line then
                    tr.Line:Destroy()
                end
                if tr.Attachment0 then tr.Attachment0:Destroy() end
                if tr.Attachment1 then tr.Attachment1:Destroy() end
                if tr.Light then tr.Light:Destroy() end
                table.remove(bulletTracers, i)
            end
        end
    end
    checkForHit()
end)
local function hitpartfromname(target, partName)
    local fc = function(n) return target:FindFirstChild(n) end
    if     partName == "Head"             then return fc("Head")
    elseif partName == "HumanoidRootPart" then return fc("HumanoidRootPart")
    elseif partName == "Torso"            then return fc("Torso") or fc("UpperTorso")
    elseif partName == "UpperTorso"       then return fc("UpperTorso")
    elseif partName == "LowerTorso"       then return fc("LowerTorso")
    elseif partName == "Left Arm"         then return fc("Left Arm") or fc("LeftUpperArm")
    elseif partName == "LeftHand"         then return fc("LeftHand") or fc("Left Arm")
    elseif partName == "LeftLowerArm"     then return fc("LeftLowerArm")
    elseif partName == "LeftUpperArm"     then return fc("LeftUpperArm")
    elseif partName == "Right Arm"        then return fc("Right Arm") or fc("RightUpperArm")
    elseif partName == "RightHand"        then return fc("RightHand") or fc("Right Arm")
    elseif partName == "RightLowerArm"    then return fc("RightLowerArm")
    elseif partName == "RightUpperArm"    then return fc("RightUpperArm")
    elseif partName == "Left Leg"         then return fc("Left Leg") or fc("LeftUpperLeg")
    elseif partName == "LeftFoot"         then return fc("LeftFoot") or fc("Left Leg")
    elseif partName == "LeftLowerLeg"     then return fc("LeftLowerLeg")
    elseif partName == "LeftUpperLeg"     then return fc("LeftUpperLeg")
    elseif partName == "Right Leg"        then return fc("Right Leg") or fc("RightUpperLeg")
    elseif partName == "RightFoot"        then return fc("RightFoot") or fc("Right Leg")
    elseif partName == "RightLowerLeg"    then return fc("RightLowerLeg")
    elseif partName == "RightUpperLeg"    then return fc("RightUpperLeg")
    elseif partName == "Neck"             then return fc("Neck")
    elseif partName == "Back"             then return fc("Back") or fc("HumanoidRootPart")
    elseif partName == "Front"            then return fc("Front") or fc("HumanoidRootPart")
    elseif partName == "Closest" then
        local camPos  = Camera.CFrame.Position
        local camLook = Camera.CFrame.LookVector
        local best, bestD = nil, math.huge
        for _, part in pairs(target:GetChildren()) do
            if part:IsA("BasePart") then
                local d = 1 - camLook:Dot((part.Position-camPos).Unit)
                if d < bestD then bestD=d; best=part end
            end
        end
        return best or fc("HumanoidRootPart")
    elseif partName == "Random" then
        local list = {}
        for _, part in pairs(target:GetChildren()) do
            if part:IsA("BasePart") then table.insert(list, part) end
        end
        if #list > 0 then return list[math.random(1, #list)] end
    end
    return target:FindFirstChild("HumanoidRootPart")
end
local function shouldHitTarget()
    if silentAim.hitChance >= 100 then return true end
    if silentAim.hitChance <= 0   then return false end
    return math.random(1, 100) <= silentAim.hitChance
end
local function closestinfov(radius, center)
    local closest, closestDist = nil, math.huge
    local cam = Camera
    local playersList = Players:GetPlayers()
    for i = 1, #playersList do
        local player = playersList[i]
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and not char:FindFirstChildOfClass("ForceField") then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local pos, onScreen = worldToScreen(root.Position, cam)
                        if onScreen then
                            local dx = pos.X - center.X
                            local dy = pos.Y - center.Y
                            local dist = math.sqrt(dx*dx + dy*dy)
                            if dist <= radius and dist < closestDist then
                                closest = char
                                closestDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end
local function closestplayerinfov(radius)
    local c = closestinfov(radius, silentfovcenter())
    curtarget = c
    return c
end
local localFighter   = nil
local lastFireTime   = 0
local fireCooldown   = 0.05
local function firesilent()
    if not silentAim.enabled then return end
    local cw = curweap2()
    if cw and weaponstricted(cw) then return end
    local now = tick()
    if now - lastFireTime < fireCooldown then return end
    if not shouldHitTarget() then return end
    local closest = closestplayerinfov(silentAim.fovRadius)
    if not closest then return end
    local tp = Players:GetPlayerFromCharacter(closest)
    if antikatana and tp and katanadeflect(tp) then return end
    local part = hitpartfromname(closest, silentAim.hitPart)
    if not part then return end
    local myChar = LocalPlayer.Character
    local root   = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local equipped = localFighter and localFighter.EquippedItem
    if not equipped then return end
    local objId = equipped:Get("ObjectID")
    if not objId then return end
    lastFireTime  = now
    local shootPos  = root.Position
    local targetPos = part.Position
    local data = {
        [utf8.char(1)] = {
            [utf8.char(0)] = Utility:EncodeCFrame(CFrame.new(shootPos, targetPos)),
            [utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(shootPos, targetPos)),
            [utf8.char(2)] = part,
            [utf8.char(3)] = Utility:EncodeCFrame(CFrame.new(0.43, 0.25, 0.42)),
        },
    }
    pcall(function()
        ReplicatedStorage.Remotes.Replication.Fighter.UseItem:FireServer(
            objId,
            EnumLibrary:ToEnum("StartShooting"),
            data,
            nil
        )
    end)
end
RunService.Heartbeat:Connect(function()
    if silentAim.enabled then
        if silentAim.autoShoot or isShootButtonPressed() then
            firesilent()
        end
    end
end)
repeat task.wait(0.1) until game:IsLoaded()
repeat task.wait(0.1) until LocalPlayer.Parent
repeat task.wait(0.1) until LocalPlayer:FindFirstChild("PlayerScripts")
task.wait(0.8)
LocalPlayer:WaitForChild("PlayerScripts", 10)
local camController
pcall(function()
    local ctrl = LocalPlayer.PlayerScripts:WaitForChild("Controllers", 10)
    local cm   = ctrl:FindFirstChild("CameraController")
    if cm and cm:IsA("ModuleScript") then camController = require(cm) end
    local fm   = ctrl:FindFirstChild("FighterController")
    if fm and fm:IsA("ModuleScript") then
        local fc   = require(fm)
        localFighter = fc.LocalFighter
    end
end)
local function clearAimbotLock()
    aimbot.lockedTarget = nil
    aimbot.smoothCF = nil
end
local function getAimbotScreenPoint()
    if aimbot.followMuzzle then
        return aimbotfovcenter()
    end
    if IS_MOBILE then
        if MOBILE_TOUCH_STATE.touching then
            return MOBILE_TOUCH_STATE.touchCurrentPos
        end
        local cam = workspace.CurrentCamera
        if cam then
            return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        end
        return Vector2.zero
    end
    local loc = UserInputService:GetMouseLocation()
    return Vector2.new(loc.X, loc.Y)
end
local function isTargetVisible(targetPart, myRoot)
    if not targetPart or not targetPart.Parent then return false end
    local cacheKey = targetPart
    local cached = visibilityCache[cacheKey]
    local now = tick()
    if cached and (now - cached.t) < VISIBILITY_CACHE_TTL then
        return cached.v
    end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local toTarget = targetPart.Position - myRoot.Position
    local result = workspace:Raycast(myRoot.Position, toTarget.Unit * toTarget.Magnitude, params)
    local visible = not result or (result.Instance and (result.Instance:IsDescendantOf(targetPart.Parent) or result.Instance == targetPart))
    visibilityCache[cacheKey] = {t = now, v = visible}
    return visible
end
task.spawn(function()
    while true do
        task.wait(0.5)
        local now = tick()
        for k, v in pairs(visibilityCache) do
            if not k.Parent or (now - v.t) > VISIBILITY_CACHE_TTL * 3 then
                visibilityCache[k] = nil
            end
        end
    end
end)
local function closesttocursor()
    local best, bestDist = nil, aimbot.fovRadius
    local mp = getAimbotScreenPoint()
    if not mp then
        return nil
    end
    local cam = workspace.CurrentCamera or Camera
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local playersList = Players:GetPlayers()
    for i = 1, #playersList do
        local p = playersList[i]
        if p ~= LocalPlayer and p.Character then
            local part = p.Character:FindFirstChild(aimbot.targetPart)
            if part and part:IsDescendantOf(workspace) then
                local scr, on = worldToScreen(part.Position, cam)
                if on then
                    local dx = scr.X - mp.X
                    local dy = scr.Y - mp.Y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    if dist < bestDist then
                        if aimbot.visibleOnly and myRoot then
                            if isTargetVisible(part, myRoot) then
                                bestDist = dist
                                best = part
                            end
                        else
                            bestDist = dist
                            best = part
                        end
                    end
                end
            end
        end
    end
    return best
end
local function getAimbotLerpAlpha(dt)
    local smoothness = math.clamp(tonumber(aimbot.smoothness) or 2, 0.1, 10)
    local curve = aimbot.aimCurve or "Linear"
    local speed = 6 / smoothness
    if curve == "Instant" then
        return 1
    elseif curve == "Expo" then
        return 1 - math.exp(-(4 / smoothness) * dt)
    elseif curve == "EaseIn" then
        local t = math.clamp(speed * dt, 0, 1)
        return t * t
    elseif curve == "EaseOut" then
        local t = math.clamp(speed * dt, 0, 1)
        return 1 - (1 - t) * (1 - t)
    elseif curve == "EaseInOut" then
        local t = math.clamp(speed * dt, 0, 1)
        if t < 0.5 then
            return 2 * t * t
        end
        return 1 - ((-2 * t + 2) ^ 2) / 2
    elseif curve == "Cubic" then
        local t = math.clamp(speed * dt, 0, 1)
        return t * t * t
    end
    return math.clamp(speed * dt, 0, 1)
end
local AIMBOT_RENDER_BIND = "InstanceAimbotUpdate"
local aimbotConnection
local aimbotUsingBind = false
local function stepAimbot(dt)
    dt = dt or (1 / 240)
    if not aimbot.enabled then
        clearAimbotLock()
        return
    end
    local cam = workspace.CurrentCamera
    if not cam then
        return
    end
    Camera = cam
    if not aimbot.lockedTarget then
        aimbot.lockedTarget = closesttocursor()
        aimbot.smoothCF = getUnstretchedCameraCFrame(cam)
        if not aimbot.lockedTarget then
            return
        end
    end
    if not aimbot.lockedTarget.Parent or not aimbot.lockedTarget:IsDescendantOf(workspace) then
        clearAimbotLock()
        return
    end
    local myChar = LocalPlayer.Character
    if not myChar then
        return
    end
    local myHead = myChar:FindFirstChild("Head")
    if not myHead then
        clearAimbotLock()
        return
    end
    if not camController then
        return
    end
    if not aimbot.smoothCF then
        aimbot.smoothCF = getUnstretchedCameraCFrame(cam)
    end
    local lookCF = CFrame.lookAt(cam.CFrame.Position, aimbot.lockedTarget.Position)
    local alpha = getAimbotLerpAlpha(dt)
    aimbot.smoothCF = aimbot.smoothCF:Lerp(lookCF, alpha)
    if camController and camController.MimicRotation then
        pcall(function()
            camController:MimicRotation(aimbot.smoothCF)
        end)
    end
end
local function updaimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    if aimbotUsingBind then
        pcall(function()
            RunService:UnbindFromRenderStep(AIMBOT_RENDER_BIND)
        end)
        aimbotUsingBind = false
    end
    aimbotFOVContainer.Visible = aimbot.showFov
    if not aimbot.enabled then
        clearAimbotLock()
        return
    end
    local ok = pcall(function()
        RunService:UnbindFromRenderStep(AIMBOT_RENDER_BIND)
        RunService:BindToRenderStep(AIMBOT_RENDER_BIND, Enum.RenderPriority.Camera.Value + 1, stepAimbot)
    end)
    if ok then
        aimbotUsingBind = true
    else
        aimbotConnection = RunService.RenderStepped:Connect(stepAimbot)
    end
end
local function closestplayerbs()
    local best, bestD = nil, math.huge
    local sc = screenCenter(Camera)
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos, on = worldToScreen(root.Position, Camera)
                if on then
                    local d = (sc - Vector2.new(pos.X, pos.Y)).Magnitude
                    if d < bestD then best=player.Character; bestD=d end
                end
            end
        end
    end
    return best
end
local function backshoot2()
    if backshoot.connection then backshoot.connection:Disconnect() end
    backshoot.connection = RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        if not backshoot.target then return end
        local tr = backshoot.target:FindFirstChild("HumanoidRootPart")
        if not tr then return end
        local behind = tr.Position + (-tr.CFrame.LookVector*5)
        myChar.HumanoidRootPart.CFrame = CFrame.new(behind, tr.Position)
    end)
end
local function stopbs()
    if backshoot.connection then backshoot.connection:Disconnect(); backshoot.connection=nil end
end
local backshootCheckConn = nil
local function startBackshootMonitor()
    if backshootCheckConn then return end
    backshootCheckConn = RunService.Heartbeat:Connect(function()
        if not backshoot.target then
            if backshootCheckConn then
                backshootCheckConn:Disconnect()
                backshootCheckConn = nil
            end
            return
        end
        local hum = backshoot.target:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") and backshoot.origCFrame then
                myChar.HumanoidRootPart.CFrame = backshoot.origCFrame
            end
            backshoot.target = nil
            stopbs()
            if backshootCheckConn then
                backshootCheckConn:Disconnect()
                backshootCheckConn = nil
            end
        end
    end)
end
LocalPlayer.CharacterRemoving:Connect(function()
    stopbs()
    backshoot.target    = nil
    backshoot.origCFrame = nil
    if backshootCheckConn then
        backshootCheckConn:Disconnect()
        backshootCheckConn = nil
    end
end)
Players.PlayerRemoving:Connect(function(player)
    if backshoot.target and player.Character == backshoot.target then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") and backshoot.origCFrame then
            myChar.HumanoidRootPart.CFrame = backshoot.origCFrame
        end
        backshoot.target = nil
        stopbs()
        if backshootCheckConn then
            backshootCheckConn:Disconnect()
            backshootCheckConn = nil
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                for _, child in ipairs(cam:GetChildren()) do
                    if child:IsA("BillboardGui") and child.Name == "FortniteDamageNumber" then
                        if not child.Adornee or not child.Adornee.Parent then
                            child:Destroy()
                        end
                    end
                end
                if game:GetService("Workspace") and game:GetService("Workspace").Terrain then
                    local terrain = game:GetService("Workspace").Terrain
                    for _, child in ipairs(terrain:GetChildren()) do
                        if child:IsA("Attachment") then
                            local beams = child:FindFirstChildWhichIsA("Beam")
                            if not beams then
                                local allBeamsGone = true
                                for _, thing in ipairs(child.Parent:GetChildren()) do
                                    if thing:IsA("Beam") then
                                        allBeamsGone = false
                                        break
                                    end
                                end
                                if allBeamsGone then
                                    pcall(function() child:Destroy() end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
silenttab:AddToggle("SilentAim", {
    Text     = "enable",
    Default  = false,
    Callback = function(val)
        silentAim.enabled = val
        if not val then curtarget = nil end
    end
}):AddKeyPicker("SilentAimKey", {
    Text     = "Silent Aim",
    Default  = "None",
    Mode     = "Toggle",
    NoUI     = true,
    SyncToggleState = false,
    Callback = function(state)
        silentAim.enabled = state
        if not state then curtarget = nil end
    end
})
silenttab:AddToggle("BackshootToggle", {
    Text     = "backshoot",
    Default  = false,
    Callback = function(val)
        backshoot.enabled = val
        if val and backshoot.target then
            backshoot2()
            startBackshootMonitor()
        else
            stopbs()
            if backshoot.target and backshoot.origCFrame then
                local mc = LocalPlayer.Character
                if mc and mc:FindFirstChild("HumanoidRootPart") then
                    mc.HumanoidRootPart.CFrame = backshoot.origCFrame
                end
            end
            if backshootCheckConn then
                backshootCheckConn:Disconnect()
                backshootCheckConn = nil
            end
        end
    end
}):AddKeyPicker("SelectTargetKey", {
    Text     = "Backshoot",
    Default  = "None",
    Mode     = "Toggle",
    NoUI     = true,
    SyncToggleState = false,
    Callback = function(state)
        if not state then return end
        local mc = LocalPlayer.Character
        if not mc or not mc:FindFirstChild("HumanoidRootPart") then return end
        if backshoot.target then
            if backshoot.origCFrame then mc.HumanoidRootPart.CFrame = backshoot.origCFrame end
            backshoot.target = nil
            stopbs()
            if backshootCheckConn then
                backshootCheckConn:Disconnect()
                backshootCheckConn = nil
            end
        else
            backshoot.target = closestplayerbs()
            if backshoot.target then
                backshoot.origCFrame = mc.HumanoidRootPart.CFrame
                if backshoot.enabled then backshoot2() end
                startBackshootMonitor()
            end
        end
    end
})
silenttab:AddToggle("AntiKatana", {
    Text     = "anti katana",
    Default  = false,
    Callback = function(val) antikatana = val end
})
silenttab:AddSlider("HitChance", {
    Text     = "hit chance",
    Default  = 100,
    Min      = 0,
    Max      = 100,
    Rounding = 0,
    Compact  = true,
    Callback = function(val) silentAim.hitChance = val end
})
silenttab:AddDropdown("HitPartDropdown", {
    Text     = "hit part",
    Default  = "Head",
    Values   = HPlist,
    Callback = function(val) silentAim.hitPart = val end
})
silentcustomization:AddToggle("ShowFOV", {
    Text     = "show fov",
    Default  = false,
    Callback = function(val) silentFOVContainer.Visible = val end
}):AddColorPicker("FOVOutlineColor1", {
    Default  = Color3.fromRGB(255, 255, 255),
    Title    = "outline color 1",
    Callback = function(val) silentFOVCfg.OutlineColor1 = val; silentlinegrad() end
}):AddColorPicker("FOVOutlineColor2", {
    Default  = Color3.fromRGB(255, 255, 255),
    Title    = "outline color 2",
    Callback = function(val) silentFOVCfg.OutlineColor2 = val; silentlinegrad() end
})
silentcustomization:AddToggle("SilentFOVFilled", {
    Text     = "fov fill",
    Default  = false,
    Callback = function(val) silentFOVCfg.FilledEnabled = val; silentFOVFill.Visible = val end
}):AddColorPicker("SilentFOVFillColor1", {
    Default  = Color3.fromRGB(255, 255, 255),
    Title    = "fill color 1",
    Callback = function(val) silentFOVCfg.FilledColor1 = val; updsilentgrad() end
}):AddColorPicker("SilentFOVFillColor2", {
    Default  = Color3.fromRGB(0, 0, 0),
    Title    = "fill color 2",
    Callback = function(val) silentFOVCfg.FilledColor2 = val; updsilentgrad() end
})
silentcustomization:AddToggle("SilentFOVFillAnimated", {
    Text     = "animated fill",
    Default  = false,
    Callback = function(val)
        silentFOVCfg.FilledAnimated = val
        if not val then silentFOVFillGrad.Rotation = silentFOVCfg.FilledRotation end
    end
})
silentcustomization:AddSlider("FOVRadius", {
    Text     = "fov radius",
    Default  = 100,
    Min      = 10,
    Max      = 750,
    Rounding = 1,
    Compact  = true,
    Callback = function(val) silentAim.fovRadius = val end
})
silentcustomization:AddSlider("SilentFOVOutlineThickness", {
    Text     = "outline thickness",
    Default  = 1.5,
    Min      = 0.5,
    Max      = 5,
    Rounding = 1,
    Compact  = true,
    Callback = function(val) silentFOVCfg.OutlineThickness = val; silentFOVStroke.Thickness = val end
})
silentcustomization:AddSlider("SilentFOVOutlineTransparency", {
    Text     = "outline transparency",
    Default  = 0,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
    Compact  = true,
    Callback = function(val) silentFOVCfg.OutlineTransparency = val; silentFOVStroke.Transparency = val end
})
silentcustomization:AddSlider("SilentFOVOutlineRotation", {
    Text     = "outline rotation",
    Default  = 0,
    Min      = 0,
    Max      = 360,
    Rounding = 0,
    Compact  = true,
    Callback = function(val) silentFOVCfg.OutlineRotation = val; silentFOVStrokeGrad.Rotation = val end
})
silentcustomization:AddSlider("SilentFOVFillTransparency", {
    Text     = "fill transparency",
    Default  = 0.7,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
    Compact  = true,
    Callback = function(val) silentFOVCfg.FilledTransparency = val; silentFOVFill.BackgroundTransparency = val end
})
silentcustomization:AddSlider("SilentFOVFillRotation", {
    Text     = "fill rotation",
    Default  = 0,
    Min      = 0,
    Max      = 360,
    Rounding = 0,
    Compact  = true,
    Callback = function(val)
        silentFOVCfg.FilledRotation = val
        if not silentFOVCfg.FilledAnimated then silentFOVFillGrad.Rotation = val end
    end
})
silentcustomization:AddSlider("SilentFOVFillSpeed", {
    Text     = "fill speed",
    Default  = 1,
    Min      = 0.1,
    Max      = 10,
    Rounding = 1,
    Compact  = true,
    Callback = function(val) silentFOVCfg.FilledSpeed = val end
})
silentcustomization:AddToggle("SilentFOVSpin", {
    Text     = "fov spin",
    Default  = false,
    Callback = function(val)
        silentFOVCfg.SpinOn = val
        if not val then
            silentFOVStrokeGrad.Rotation = silentFOVCfg.OutlineRotation
            if not silentFOVCfg.FilledAnimated then
                silentFOVFillGrad.Rotation = silentFOVCfg.FilledRotation
            end
        end
    end
})
silentcustomization:AddSlider("SilentFOVSpinSpd", {
    Text     = "spin speed",
    Default  = 1,
    Min      = 0.1,
    Max      = 10,
    Rounding = 1,
    Compact  = true,
    Callback = function(val) silentFOVCfg.SpinSpd = val end
})
silentcustomization:AddToggle("SilentFOVFollowMuzzle", {
    Text     = "follow muzzle",
    Default  = false,
    Callback = function(val) silentAim.followMuzzle = val end
})
aimbotTab:AddToggle("AimbotToggle", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        aimbot.masterEnabled = val
        if not val then
            aimbot.enabled = false
            clearAimbotLock()
            updaimbot()
        else
            local picker = Options and Options.AimbotKey
            if picker and picker.Mode == "Toggle" then
                aimbot.enabled = true
            end
            updaimbot()
        end
    end
}):AddKeyPicker("AimbotKey", {
    Text = "Aimbot",
    Default = "None",
    Mode = "Toggle",
    NoUI = true,
    SyncToggleState = false,
    Modes = { "Toggle", "Hold" },
    Callback = function(state)
        local picker = Options and Options.AimbotKey
        if not picker or picker.Mode ~= "Toggle" or not aimbot.masterEnabled then return end
        aimbot.enabled = state
        if not state then
            clearAimbotLock()
        end
        updaimbot()
    end
})
RunService.RenderStepped:Connect(function()
    local picker = Options and Options.AimbotKey
    if not picker then return end
    local mode = picker.Mode and string.lower(picker.Mode) or "toggle"
    if mode ~= aimbot.keyMode then
        aimbot.keyMode = mode
        aimbot.enabled = false
        clearAimbotLock()
        updaimbot()
    end
    if mode ~= "hold" or not aimbot.masterEnabled then return end
    local held = picker:GetState()
    if held == aimbot.enabled then return end
    aimbot.enabled = held
    if not held then
        clearAimbotLock()
    end
    updaimbot()
end)
aimbotTab:AddToggle("AimbotVisibleOnly", {
    Text = "Visible Only",
    Default = false,
    Callback = function(val)
        aimbot.visibleOnly = val
    end
})
aimbotTab:AddSlider("AimbotSmoothness", {
    Text = "Smoothness",
    Default = 2,
    Min = 0.1,
    Max = 10,
    Rounding = 2,
    Compact = true,
    Callback = function(val)
        aimbot.smoothness = math.clamp(val, 0.1, 10)
    end
})
aimbotTab:AddDropdown("AimbotCurve", {
    Text = "Aim Curve",
    Default = "Linear",
    Values = { "Linear", "Expo", "EaseIn", "EaseOut", "EaseInOut", "Cubic", "Instant" },
    Callback = function(val)
        aimbot.aimCurve = val
    end
})
aimbotTab:AddDropdown("AimbotHitPart", {
    Text="hit part", Default="Head",
    Values={"Head","HumanoidRootPart","Torso","UpperTorso","LowerTorso"},
    Callback=function(val) aimbot.targetPart=val end
})
aimbotCustomTab:AddToggle("ShowAimbotFOV", {
    Text="show fov", Default=false,
    Callback=function(val)
        aimbot.showFov=val
        aimbotFOVContainer.Visible=val
    end
}):AddColorPicker("AimbotFOVOutlineColor1", {
    Default=Color3.fromRGB(255,255,255), Title="outline color 1",
    Callback=function(val) aimbotFOVCfg.OutlineColor1=val; updaimbotoutlinegrad() end
}):AddColorPicker("AimbotFOVOutlineColor2", {
    Default=Color3.fromRGB(255,255,255), Title="outline color 2",
    Callback=function(val) aimbotFOVCfg.OutlineColor2=val; updaimbotoutlinegrad() end
})
aimbotCustomTab:AddToggle("AimbotFOVFilled", {
    Text="fov fill", Default=false,
    Callback=function(val) aimbotFOVCfg.FilledEnabled=val; aimbotFOVFill.Visible=val end
}):AddColorPicker("AimbotFOVFillColor1", {
    Default=Color3.fromRGB(255, 255, 255), Title="fill color 1",
    Callback=function(val) aimbotFOVCfg.FilledColor1=val; updaimbotfillgrad() end
}):AddColorPicker("AimbotFOVFillColor2", {
    Default=Color3.fromRGB(0,0,0), Title="fill color 2",
    Callback=function(val) aimbotFOVCfg.FilledColor2=val; updaimbotfillgrad() end
})
aimbotCustomTab:AddToggle("AimbotFOVFillAnimated", {
    Text="animated fill", Default=false,
    Callback=function(val)
        aimbotFOVCfg.FilledAnimated=val
        if not val then aimbotFOVFillGrad.Rotation=aimbotFOVCfg.FilledRotation end
    end
})
aimbotCustomTab:AddSlider("AimbotFOV", {
    Text="fov radius", Default=60, Min=10, Max=1000, Rounding=0, Compact=true,
    Callback=function(val) aimbot.fovRadius=val end
})
aimbotCustomTab:AddSlider("AimbotFOVOutlineThickness", {
    Text="outline thickness", Default=1.5, Min=0.5, Max=5, Rounding=1, Compact=true,
    Callback=function(val) aimbotFOVCfg.OutlineThickness=val; aimbotFOVStroke.Thickness=val end
})
aimbotCustomTab:AddSlider("AimbotFOVOutlineTransparency", {
    Text="outline transparency", Default=0, Min=0, Max=1, Rounding=2, Compact=true,
    Callback=function(val) aimbotFOVCfg.OutlineTransparency=val; aimbotFOVStroke.Transparency=val end
})
aimbotCustomTab:AddSlider("AimbotFOVOutlineRotation", {
    Text="outline rotation", Default=0, Min=0, Max=360, Rounding=0, Compact=true,
    Callback=function(val) aimbotFOVCfg.OutlineRotation=val; aimbotFOVStrokeGrad.Rotation=val end
})
aimbotCustomTab:AddSlider("AimbotFOVFillTransparency", {
    Text="fill transparency", Default=0.7, Min=0, Max=1, Rounding=2, Compact=true,
    Callback=function(val) aimbotFOVCfg.FilledTransparency=val; aimbotFOVFill.BackgroundTransparency=val end
})
aimbotCustomTab:AddSlider("AimbotFOVFillRotation", {
    Text="fill rotation", Default=0, Min=0, Max=360, Rounding=0, Compact=true,
    Callback=function(val)
        aimbotFOVCfg.FilledRotation=val
        if not aimbotFOVCfg.FilledAnimated then aimbotFOVFillGrad.Rotation=val end
    end
})
aimbotCustomTab:AddSlider("AimbotFOVFillSpeed", {
    Text="fill speed", Default=1, Min=0.1, Max=10, Rounding=1, Compact=true,
    Callback=function(val) aimbotFOVCfg.FilledSpeed=val end
})
aimbotCustomTab:AddToggle("AimbotFOVSpin", {
    Text="fov spin", Default=false,
    Callback=function(val)
        aimbotFOVCfg.SpinOn=val
        if not val then
            aimbotFOVStrokeGrad.Rotation=aimbotFOVCfg.OutlineRotation
            if not aimbotFOVCfg.FilledAnimated then
                aimbotFOVFillGrad.Rotation=aimbotFOVCfg.FilledRotation
            end
        end
    end
})
aimbotCustomTab:AddSlider("AimbotFOVSpinSpd", {
    Text="spin speed", Default=1, Min=0.1, Max=10, Rounding=1, Compact=true,
    Callback=function(val) aimbotFOVCfg.SpinSpd=val end
})
aimbotCustomTab:AddToggle("AimbotFOVFollowMuzzle", {
    Text="follow muzzle", Default=false,
    Callback=function(val) aimbot.followMuzzle=val end
})
updaimbot()
setupShootDetection()
do
local LeftGroup = Tabs.Combat:AddLeftGroupbox("gun")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
getgenv().CombatMods = {
    RapidFire = false,
    NoSpread = false,
    NoRecoil = false,
    MaxAccuracy = false,
    RapidAttack = false,
    GunModule = nil,
    MeleeModule = nil,
    OriginalGunStartShooting = nil,
    OriginalMeleeStartShooting = nil,
    OriginalGetSpread = nil,
    OriginalRecoil = nil,
}
task.spawn(function()
    local success, GunModule = pcall(function()
        return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
    end)
    if success and GunModule then
        getgenv().CombatMods.GunModule = GunModule
        if GunModule.StartShooting then
            getgenv().CombatMods.OriginalGunStartShooting = GunModule.StartShooting
            GunModule.StartShooting = function(self, p26, p27)
                local oldShootCooldown
                if getgenv().CombatMods.RapidFire then
                    oldShootCooldown = self.Info.ShootCooldown
                    self.Info.ShootCooldown = 0
                end
                local result = { getgenv().CombatMods.OriginalGunStartShooting(self, p26, p27) }
                if getgenv().CombatMods.RapidFire then
                    self.Info.ShootCooldown = oldShootCooldown
                end
                return unpack(result)
            end
        end
        if GunModule._Recoil then
            getgenv().CombatMods.OriginalRecoil = GunModule._Recoil
            GunModule._Recoil = function(self, multiplier)
                if getgenv().CombatMods.NoRecoil then
                    return
                end
                return getgenv().CombatMods.OriginalRecoil(self, multiplier)
            end
        end
    end
end)
task.spawn(function()
    local success, GameplayUtility = pcall(function()
        return require(RS.Modules.GameplayUtility)
    end)
    if success and GameplayUtility and GameplayUtility.GetSpread then
        getgenv().CombatMods.GameplayUtility = GameplayUtility
        getgenv().CombatMods.OriginalGetSpread = GameplayUtility.GetSpread
        GameplayUtility.GetSpread = function(spread, aimMultiplier, isAiming, isCrouching, pelletIndex, totalPellets, consistent)
            if getgenv().CombatMods.NoSpread or getgenv().CombatMods.MaxAccuracy then
                return CFrame.new()
            end
            return getgenv().CombatMods.OriginalGetSpread(spread, aimMultiplier, isAiming, isCrouching, pelletIndex, totalPellets, consistent)
        end
    end
end)
task.spawn(function()
    local success, MeleeModule = pcall(function()
        return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
    end)
    if success and MeleeModule then
        getgenv().CombatMods.MeleeModule = MeleeModule
        if MeleeModule.StartShooting then
            getgenv().CombatMods.OriginalMeleeStartShooting = MeleeModule.StartShooting
            MeleeModule.StartShooting = function(self, p26, p27)
                local oldAttackCooldown
                if getgenv().CombatMods.RapidAttack then
                    oldAttackCooldown = self.Info.AttackCooldown
                    self.Info.AttackCooldown = 0
                end
                local result = { getgenv().CombatMods.OriginalMeleeStartShooting(self, p26, p27) }
                if getgenv().CombatMods.RapidAttack and oldAttackCooldown then
                    self.Info.AttackCooldown = oldAttackCooldown
                end
                return unpack(result)
            end
        end
    end
end)
local muzzleflashconn = nil
local function nomuzzleflash()
    local viewModels = Workspace:FindFirstChild("ViewModels")
    if viewModels then
        local firstPerson = viewModels:FindFirstChild("FirstPerson")
        if firstPerson then
            for _, model in pairs(firstPerson:GetChildren()) do
                if model:IsA("Model") then
                    local itemVisual = model:FindFirstChild("ItemVisual")
                    if itemVisual then
                        local body = itemVisual:FindFirstChild("Body")
                        if body then
                            local bodyPrimary = body:FindFirstChild("BodyPrimary")
                            if bodyPrimary then
                                local muzzle = bodyPrimary:FindFirstChild("_muzzle")
                                if muzzle then
                                    local spotlight = muzzle:FindFirstChild("SpotLight")
                                    if spotlight then
                                        spotlight:Destroy()
                                    end
                                    for _, child in pairs(muzzle:GetChildren()) do
                                        if child:IsA("ParticleEmitter") and child.Name == "ParticleEmiter" then
                                            child:Destroy()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
LeftGroup:AddToggle("NoCooldown", {
    Text = "Rapid Fire",
    Default = false,
    Callback = function(val)
        getgenv().CombatMods.RapidFire = val
    end
})
LeftGroup:AddToggle("NoSpread", {
    Text = "No Spread",
    Default = false,
    Callback = function(val)
        getgenv().CombatMods.NoSpread = val
    end
})
LeftGroup:AddToggle("NoRecoil", {
    Text = "No Recoil",
    Default = false,
    Callback = function(val)
        getgenv().CombatMods.NoRecoil = val
    end
})
LeftGroup:AddToggle("MaxAccuracy", {
    Text = "Max Accuracy",
    Default = false,
    Callback = function(val)
        getgenv().CombatMods.MaxAccuracy = val
    end
})
LeftGroup:AddToggle("RapidAttack", {
    Text = "Rapid Attack",
    Default = false,
    Callback = function(val)
        getgenv().CombatMods.RapidAttack = val
    end
})
LeftGroup:AddToggle("NoMuzzleFlash", {
    Text = "No Muzzle Flash",
    Default = false,
    Callback = function(val)
        if val then
            nomuzzleflash()
            if muzzleflashconn then
                muzzleflashconn:Disconnect()
            end
            muzzleflashconn = RunService.RenderStepped:Connect(nomuzzleflash)
        else
            if muzzleflashconn then
                muzzleflashconn:Disconnect()
                muzzleflashconn = nil
            end
        end
    end
})
end
HitGroup = Tabs.World:AddRightTabbox()
getDamageBillboardInfo = function(obj)
    local cached = damageBillboardInfoCache[obj]
    if cached ~= nil then
        return cached
    end
    if not obj:IsA("BillboardGui") then
        return
    end
    if obj.Name == "FortniteDamageNumber" then
        return
    end
    local lbl = obj:FindFirstChildWhichIsA("TextLabel", true)
    if not lbl then
        return
    end
    local dmg = tonumber(lbl.Text)
    if not (dmg and dmg > 0) then
        return
    end
    local adornee = obj.Adornee or (obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent)
    if not adornee then
        return
    end
    local info = {
        lbl = lbl,
        dmg = dmg,
        adornee = adornee,
    }
    damageBillboardInfoCache[obj] = info
    return info
end
(function()
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local fonts = {}
fonts.main = getgenv().InstanceUIFont or Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Black)
local hitEffectsTab = HitGroup:AddTab('Hit Effects')
local hitEffectEnabled = false
local hitEffectColor = Color3.fromRGB(159, 133, 195)
local hitEffectStyle = {Particles = true}
local hitEffectFloatSpeed = 7
local hitEffectAliveTime = 2.8
local hitEffectAliveScale = 1
local hitEffectsToggle = hitEffectsTab:AddToggle("HitEffects", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        hitEffectEnabled = val
    end
})
hitEffectsToggle:AddColorPicker("HitEffectColorPicker", {
    Default = Color3.fromRGB(159, 133, 195),
    Title = "Hit Effect Color",
    Callback = function(val)
        hitEffectColor = val
    end
})
local hitEffectDepBox = hitEffectsTab:AddDependencyBox()
hitEffectDepBox:AddSlider("HitEffectFloatSpeed", {
    Text = "Float Speed",
    Default = 7,
    Min = 1,
    Max = 25,
    Rounding = 1,
    Callback = function(val)
        hitEffectFloatSpeed = val
    end
})
hitEffectDepBox:AddSlider("HitEffectAliveTime", {
    Text = "Alive Time",
    Default = 2.8,
    Min = 0.5,
    Max = 8,
    Rounding = 1,
    Suffix = "s",
    Callback = function(val)
        hitEffectAliveTime = val
        hitEffectAliveScale = val / 2.8
    end
})
hitEffectDepBox:SetupDependencies({
    { hitEffectsToggle, true }
})
hitEffectsTab:AddDropdown("HitEffectStyleDropdown", {
    Text = "Style",
    Default = {"Particles"},
    Values = {
        "Particles", "Fortnite", "Shockwave", "Lightning", "Blood", "Fire",
        "Ice", "Hearts", "Stars", "Confetti", "Ripple", "Sparks",
        "Neon", "Void", "Plasma", "Glitch", "Cosmic Shit"
    },
    Multi = true,
    Callback = function(val)
        hitEffectStyle = val
    end
})
local function getHitEffectPart(adornee)
    if adornee:IsA("BasePart") then
        return adornee
    elseif adornee:IsA("Attachment") then
        return adornee.Parent
    elseif adornee:IsA("Model") and adornee.PrimaryPart then
        return adornee.PrimaryPart
    end
end
local function blendHitColor(base, amount)
    amount = amount or 0.35
    return Color3.new(
        math.clamp(base.R + amount, 0, 1),
        math.clamp(base.G + amount * 0.5, 0, 1),
        math.clamp(base.B + amount * 0.25, 0, 1)
    )
end
local function darkenHitColor(base, amount)
    amount = amount or 0.45
    return Color3.new(
        math.clamp(base.R - amount, 0, 1),
        math.clamp(base.G - amount, 0, 1),
        math.clamp(base.B - amount * 0.5, 0, 1)
    )
end
local function getHitEffectAliveScale()
    return hitEffectAliveScale
end
local function scaleHitDuration(seconds)
    return seconds * getHitEffectAliveScale()
end
local function each_style(callback)
    local styles = hitEffectStyle
    if type(styles) ~= "table" then
        callback(styles)
        return
    end
    for key, val in pairs(styles) do
        local styleName
        if type(key) == "number" and type(val) == "string" then
            styleName = val
        elseif val == true then
            styleName = key
        end
        if styleName then
            callback(styleName)
        end
    end
end
local function spawnHitRing(targetPart, color, config)
    config = config or {}
    local ring = Instance.new("Part")
    ring.Name = config.Name or "HitRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanQuery = false
    ring.CanTouch = false
    ring.Material = config.Material or Enum.Material.Neon
    ring.Color = color
    ring.Transparency = config.StartTransparency or 0.35
    local startSize = config.StartSize or 0.35
    ring.Size = Vector3.new(0.05, startSize, startSize)
    ring.CFrame = targetPart.CFrame * CFrame.Angles(0, 0, math.rad(90))
    ring.Parent = workspace.CurrentCamera
    local endSize = config.EndSize or 5
    local duration = scaleHitDuration(config.Duration or 0.55)
    TweenService:Create(ring, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.05, endSize, endSize),
        Transparency = 1
    }):Play()
    task.delay(duration + 0.1, function()
        if ring and ring.Parent then ring:Destroy() end
    end)
    return ring
end
local function spawnHitFlash(targetPart, color, brightness, range, duration)
    duration = scaleHitDuration(duration or 0.35)
    local light = Instance.new("PointLight")
    light.Name = "HitFlash"
    light.Color = color
    light.Brightness = brightness or 6
    light.Range = range or 14
    light.Parent = targetPart
    TweenService:Create(light, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = 0,
        Range = 0
    }):Play()
    task.delay(duration + 0.05, function()
        if light and light.Parent then light:Destroy() end
    end)
end
local function spawnHitEmitter(targetPart, config)
    if getActiveParticles() >= MAX_ACTIVE_PARTICLES then
        return nil
    end
    local emitter = Instance.new("ParticleEmitter")
    emitter.Name = config.Name or "HitEffect"
    emitter.Texture = config.Texture or "rbxassetid://6603835352"
    if typeof(config.Color) == "ColorSequence" then
        emitter.Color = config.Color
    else
        emitter.Color = ColorSequence.new(config.Color or hitEffectColor)
    end
    emitter.LightEmission = config.LightEmission or 1
    emitter.Brightness = config.Brightness or 8
    emitter.LightInfluence = config.LightInfluence or 0
    emitter.Orientation = config.Orientation or Enum.ParticleOrientation.FacingCamera
    emitter.LockedToPart = config.LockedToPart or false
    emitter.Size = config.Size or NumberSequence.new(0.12)
    emitter.Transparency = config.Transparency or NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    emitter.Speed = config.Speed or NumberRange.new(12, 18)
    emitter.SpreadAngle = config.SpreadAngle or Vector2.new(120, 120)
    emitter.EmissionDirection = config.EmissionDirection or Enum.NormalId.Top
    local lifetime = config.Lifetime or NumberRange.new(0.6, 1.2)
    local aliveScale = getHitEffectAliveScale()
    emitter.Lifetime = NumberRange.new(lifetime.Min * aliveScale, lifetime.Max * aliveScale)
    emitter.Drag = config.Drag or 2
    emitter.Acceleration = config.Acceleration or Vector3.new(0, 4, 0)
    emitter.RotSpeed = config.RotSpeed or NumberRange.new(0, 0)
    emitter.Rate = 0
    emitter.Enabled = true
    emitter.Parent = targetPart
    emitter:Emit(config.EmitCount or 48)
    task.delay(scaleHitDuration(config.Cleanup or 4), function()
        if emitter and emitter.Parent then emitter:Destroy() end
    end)
end
local function particledesign(adornee, color)
    color = color or hitEffectColor
    local targetPart = getHitEffectPart(adornee)
    if not targetPart or not targetPart:IsA("BasePart") then return end
    local emitter = Instance.new("ParticleEmitter")
    emitter.Name = "TinyGlowingDots"
    emitter.Texture = "rbxassetid://6603835352"
    emitter.Color = ColorSequence.new(color)
    emitter.LightEmission = 1
    emitter.Brightness = 13
    emitter.LightInfluence = 0
    emitter.Orientation = Enum.ParticleOrientation.FacingCamera
    emitter.LockedToPart = false
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.09),
        NumberSequenceKeypoint.new(0.5, 0.135),
        NumberSequenceKeypoint.new(1, 0.068)
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.25, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    emitter.Speed = NumberRange.new(22, 29)
    emitter.SpreadAngle = Vector2.new(130, 130)
    emitter.EmissionDirection = Enum.NormalId.Top
    local particleLife = scaleHitDuration(4)
    emitter.Lifetime = NumberRange.new(particleLife, particleLife + 0.1)
    emitter.Drag = 3.2
    emitter.Acceleration = Vector3.new(0, 5, 0)
    emitter.Rate = 0
    emitter.Enabled = true
    emitter.Parent = targetPart
    emitter:Emit(64)
    task.delay(scaleHitDuration(5), function()
        if emitter and emitter.Parent then emitter:Destroy() end
    end)
end
local activeposes = {}
local MIN_DIST = 5.5
local MAX_ACTIVE_HIT_EFFECTS = 45
local MAX_ACTIVE_PARTICLES = 120
local maxEffectsReached = false
local X_MIN, X_MAX = -10, 10
local Y_MIN, Y_MAX = 1, 8
local Z_MIN, Z_MAX = -4, 4
local function randFloat(min, max)
    return min + math.random() * (max - min)
end
local function pickpos(key)
    local occupied = activeposes[key] or {}
    local best = nil
    local bestDist = -1
    for attempt = 1, 60 do
        local candidate = Vector3.new(
            randFloat(X_MIN, X_MAX),
            randFloat(Y_MIN, Y_MAX),
            randFloat(Z_MIN, Z_MAX)
        )
        local minDist = math.huge
        for _, pos in ipairs(occupied) do
            local d = (candidate - pos).Magnitude
            if d < minDist then minDist = d end
        end
        if minDist >= MIN_DIST then
            return candidate
        end
        if minDist > bestDist then
            bestDist = minDist
            best = candidate
        end
    end
    return best
end
local function getActiveFortniteBillboards()
    local count = 0
    for _, child in ipairs(workspace.CurrentCamera:GetChildren()) do
        if child:IsA("BillboardGui") and child.Name == "FortniteDamageNumber" then
            count = count + 1
        end
    end
    return count
end
local function getActiveParticles()
    local count = 0
    local function countInInstance(inst)
        for _, child in ipairs(inst:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                count = count + 1
            end
            countInInstance(child)
        end
    end
    countInInstance(workspace.CurrentCamera)
    return count
end
local function fortniteffect(adornee, color, damageText)
    color = color or hitEffectColor
    local currentBbs = getActiveFortniteBillboards()
    if currentBbs >= MAX_ACTIVE_HIT_EFFECTS then
        return
    end
    local targetPart
    if adornee:IsA("BasePart") then
        targetPart = adornee
    elseif adornee:IsA("Model") and adornee.PrimaryPart then
        targetPart = adornee.PrimaryPart
    end
    if not targetPart then return end
    local key = targetPart
    if not activeposes[key] then activeposes[key] = {} end
    local offset2 = pickpos(key)
    local floatHeight = hitEffectFloatSpeed or 7
    local aliveDuration = hitEffectAliveTime or 2.8
    local endOffset = offset2 + Vector3.new(0, floatHeight, 0)
    local posEntry = offset2
    table.insert(activeposes[key], posEntry)
    local bb = Instance.new("BillboardGui")
    bb.Name = "FortniteDamageNumber"
    bb.Size = UDim2.new(0, 70, 0, 40)
    bb.StudsOffset = offset2
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Adornee = targetPart
    bb.Parent = workspace.CurrentCamera
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = damageText
    lbl.TextColor3 = color
    lbl.TextTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 1
    lbl.TextScaled = true
    lbl.FontFace = fonts.main
    lbl.ZIndex = 1
    local fadeOutTime = scaleHitDuration(0.5)
    TweenService:Create(lbl, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, TextStrokeTransparency = 0.55}):Play()
    TweenService:Create(bb, TweenInfo.new(aliveDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {StudsOffset = endOffset}):Play()
    task.delay(aliveDuration, function()
        if not bb or not bb.Parent then return end
        TweenService:Create(lbl, TweenInfo.new(fadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
        task.delay(fadeOutTime + 0.02, function()
            if bb and bb.Parent then bb:Destroy() end
            if activeposes[key] then
                for i, pos in ipairs(activeposes[key]) do
                    if pos == posEntry then
                        table.remove(activeposes[key], i)
                        break
                    end
                end
                if #activeposes[key] == 0 then
                    activeposes[key] = nil
                end
            end
        end)
    end)
end
local function shockwaveEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    spawnHitFlash(targetPart, color, 8, 18, 0.4)
    spawnHitRing(targetPart, color, {Name = "ShockwaveRing", StartSize = 0.5, EndSize = 7, Duration = 0.5})
    spawnHitRing(targetPart, blendHitColor(color, 0.2), {Name = "ShockwaveRing2", StartSize = 0.25, EndSize = 5, Duration = 0.35, StartTransparency = 0.55})
    spawnHitEmitter(targetPart, {
        Name = "ShockwaveBurst",
        Texture = "rbxassetid://243660364",
        Color = color,
        EmitCount = 28,
        Speed = NumberRange.new(14, 24),
        SpreadAngle = Vector2.new(180, 180),
        EmissionDirection = Enum.NormalId.Front,
        Lifetime = NumberRange.new(0.25, 0.45),
        Drag = 5,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 0.05)
        }),
        Cleanup = 1.5,
    })
end
local function lightningEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local boltColor = Color3.new(0.85, 0.92, 1)
    spawnHitFlash(targetPart, boltColor, 14, 22, 0.2)
    spawnHitEmitter(targetPart, {
        Name = "LightningCore",
        Texture = "rbxassetid://446111271",
        Color = boltColor,
        Brightness = 16,
        EmitCount = 22,
        Speed = NumberRange.new(32, 48),
        SpreadAngle = Vector2.new(18, 18),
        Lifetime = NumberRange.new(0.08, 0.22),
        Drag = 0.2,
        Acceleration = Vector3.new(0, -20, 0),
        Cleanup = 1,
    })
    spawnHitEmitter(targetPart, {
        Name = "LightningArcs",
        Texture = "rbxassetid://12781852245",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, boltColor),
            ColorSequenceKeypoint.new(0.5, color),
            ColorSequenceKeypoint.new(1, boltColor)
        }),
        Brightness = 12,
        EmitCount = 40,
        Speed = NumberRange.new(20, 38),
        SpreadAngle = Vector2.new(120, 120),
        Lifetime = NumberRange.new(0.12, 0.35),
        Drag = 1,
        Acceleration = Vector3.new(0, -14, 0),
        Cleanup = 1.5,
    })
end
local function bloodEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local bloodColor = Color3.new(math.clamp(color.R * 0.9 + 0.35, 0, 1), math.clamp(color.G * 0.15, 0, 0.35), math.clamp(color.B * 0.15, 0, 0.35))
    spawnHitEmitter(targetPart, {
        Name = "BloodSplatter",
        Texture = "rbxassetid://243660364",
        Color = bloodColor,
        EmitCount = 70,
        Speed = NumberRange.new(12, 28),
        SpreadAngle = Vector2.new(175, 175),
        Lifetime = NumberRange.new(0.7, 1.3),
        Drag = 5,
        Acceleration = Vector3.new(0, -22, 0),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.22),
            NumberSequenceKeypoint.new(0.6, 0.14),
            NumberSequenceKeypoint.new(1, 0.04)
        }),
    })
    spawnHitEmitter(targetPart, {
        Name = "BloodMist",
        Texture = "rbxassetid://6603835352",
        Color = darkenHitColor(bloodColor, 0.15),
        EmitCount = 20,
        Speed = NumberRange.new(4, 10),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.4, 0.8),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Size = NumberSequence.new(0.5),
        Cleanup = 2,
    })
end
local function fireEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local fireCore = Color3.new(math.clamp(color.R + 0.25, 0, 1), math.clamp(color.G * 0.6 + 0.2, 0, 1), math.clamp(color.B * 0.2, 0, 0.4))
    spawnHitFlash(targetPart, fireCore, 10, 16, 0.45)
    spawnHitEmitter(targetPart, {
        Name = "FireFlames",
        Texture = "rbxassetid://241650108",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 120)),
            ColorSequenceKeypoint.new(0.45, fireCore),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 20, 10))
        }),
        EmitCount = 55,
        Speed = NumberRange.new(8, 18),
        SpreadAngle = Vector2.new(70, 70),
        Lifetime = NumberRange.new(0.45, 0.95),
        Acceleration = Vector3.new(0, 14, 0),
        LightEmission = 1,
        Brightness = 14,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 0.05)
        }),
    })
    spawnHitEmitter(targetPart, {
        Name = "FireEmbers",
        Texture = "rbxassetid://12781852245",
        Color = fireCore,
        EmitCount = 25,
        Speed = NumberRange.new(14, 26),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.6, 1.1),
        Drag = 2,
        Acceleration = Vector3.new(0, 6, 0),
        Cleanup = 2.5,
    })
end
local function iceEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local iceColor = Color3.new(
        math.clamp(color.R * 0.35 + 0.55, 0, 1),
        math.clamp(color.G * 0.5 + 0.55, 0, 1),
        math.clamp(color.B * 0.4 + 0.75, 0, 1)
    )
    spawnHitFlash(targetPart, iceColor, 6, 12, 0.35)
    spawnHitEmitter(targetPart, {
        Name = "IceShards",
        Texture = "rbxassetid://243660364",
        Color = iceColor,
        EmitCount = 48,
        Speed = NumberRange.new(10, 20),
        SpreadAngle = Vector2.new(110, 110),
        Lifetime = NumberRange.new(0.9, 1.5),
        Drag = 1.5,
        RotSpeed = NumberRange.new(-180, 180),
        Acceleration = Vector3.new(0, -6, 0),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.28),
            NumberSequenceKeypoint.new(1, 0.06)
        }),
    })
    spawnHitEmitter(targetPart, {
        Name = "IceFrost",
        Texture = "rbxassetid://6603835352",
        Color = Color3.new(1, 1, 1),
        EmitCount = 24,
        Speed = NumberRange.new(2, 6),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(1.2, 1.8),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Size = NumberSequence.new(0.4),
        Cleanup = 2.5,
    })
end
local function heartsEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local heartColor = Color3.new(math.clamp(color.R + 0.15, 0, 1), math.clamp(color.G * 0.35 + 0.2, 0, 1), math.clamp(color.B * 0.4 + 0.35, 0, 1))
    spawnHitEmitter(targetPart, {
        Name = "HeartsHit",
        Texture = "rbxassetid://120777973",
        Color = heartColor,
        EmitCount = 24,
        Speed = NumberRange.new(5, 12),
        SpreadAngle = Vector2.new(55, 55),
        Lifetime = NumberRange.new(1.1, 1.9),
        Acceleration = Vector3.new(0, 8, 0),
        Drag = 1,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 0.2)
        }),
        LightEmission = 0.6,
    })
end
local function starsEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    spawnHitFlash(targetPart, color, 7, 14, 0.3)
    spawnHitEmitter(targetPart, {
        Name = "StarsBurst",
        Texture = "rbxassetid://1084982556",
        Color = color,
        EmitCount = 40,
        Speed = NumberRange.new(16, 28),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.6, 1.05),
        RotSpeed = NumberRange.new(-240, 240),
        Brightness = 12,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(1, 0.1)
        }),
    })
end
local function confettiEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local c2 = blendHitColor(color, 0.3)
    local c3 = Color3.new(color.G, color.B, color.R)
    spawnHitEmitter(targetPart, {
        Name = "ConfettiHit",
        Texture = "rbxassetid://243660364",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(0.33, c2),
            ColorSequenceKeypoint.new(0.66, c3),
            ColorSequenceKeypoint.new(1, blendHitColor(c2, 0.2))
        }),
        EmitCount = 80,
        Speed = NumberRange.new(14, 30),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(1.4, 2.4),
        Drag = 2.5,
        Acceleration = Vector3.new(0, -10, 0),
        RotSpeed = NumberRange.new(-420, 420),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.22),
            NumberSequenceKeypoint.new(1, 0.08)
        }),
    })
end
local function rippleEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    spawnHitRing(targetPart, color, {Name = "RippleHit1", StartSize = 0.3, EndSize = 4.5, Duration = 0.45, StartTransparency = 0.3})
    task.delay(0.12, function()
        if targetPart and targetPart.Parent then
            spawnHitRing(targetPart, blendHitColor(color, 0.15), {Name = "RippleHit2", StartSize = 0.2, EndSize = 6.5, Duration = 0.65, StartTransparency = 0.5})
        end
    end)
    spawnHitEmitter(targetPart, {
        Name = "RippleDroplets",
        Texture = "rbxassetid://6603835352",
        Color = color,
        EmitCount = 16,
        Speed = NumberRange.new(6, 12),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.5, 0.9),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Size = NumberSequence.new(0.12),
        Cleanup = 2,
    })
end
local function sparksEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    spawnHitFlash(targetPart, color, 9, 12, 0.25)
    spawnHitEmitter(targetPart, {
        Name = "SparksHit",
        Texture = "rbxassetid://12781852245",
        Color = color,
        EmitCount = 65,
        Speed = NumberRange.new(22, 42),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.18, 0.5),
        Drag = 4,
        Brightness = 14,
        LightEmission = 1,
        Acceleration = Vector3.new(0, -16, 0),
    })
    spawnHitEmitter(targetPart, {
        Name = "SparksGlow",
        Texture = "rbxassetid://6603835352",
        Color = blendHitColor(color, 0.4),
        EmitCount = 12,
        Speed = NumberRange.new(4, 8),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.35, 0.6),
        Size = NumberSequence.new(0.25),
        Cleanup = 1.5,
    })
end
local function neonPulseEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    spawnHitFlash(targetPart, color, 16, 20, 0.5)
    spawnHitRing(targetPart, color, {Name = "NeonPulseRing", StartSize = 0.15, EndSize = 4, Duration = 0.35, StartTransparency = 0.15})
    spawnHitEmitter(targetPart, {
        Name = "NeonPulseCore",
        Texture = "rbxassetid://6603835352",
        Color = color,
        Brightness = 16,
        LightEmission = 1,
        EmitCount = 50,
        Speed = NumberRange.new(4, 10),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.5, 0.9),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(0.5, 0.35),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
    })
end
local function voidRiftEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local voidCore = darkenHitColor(color, 0.55)
    local voidEdge = blendHitColor(color, 0.1)
    spawnHitEmitter(targetPart, {
        Name = "VoidRiftCore",
        Texture = "rbxassetid://243660364",
        Color = voidCore,
        EmitCount = 35,
        Speed = NumberRange.new(2, 8),
        SpreadAngle = Vector2.new(180, 180),
        EmissionDirection = Enum.NormalId.Bottom,
        Lifetime = NumberRange.new(0.8, 1.4),
        Drag = 3,
        Acceleration = Vector3.new(0, -14, 0),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 0.1)
        }),
        LightEmission = 0.2,
        Brightness = 2,
    })
    spawnHitEmitter(targetPart, {
        Name = "VoidRiftEdge",
        Texture = "rbxassetid://446111271",
        Color = voidEdge,
        EmitCount = 45,
        Speed = NumberRange.new(10, 22),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.4, 0.85),
        RotSpeed = NumberRange.new(-300, 300),
        Brightness = 10,
        LightEmission = 1,
        Cleanup = 2,
    })
end
local function plasmaEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    local plasmaB = Color3.new(math.clamp(1 - color.R, 0, 1), math.clamp(color.G, 0, 1), math.clamp(color.B + 0.3, 0, 1))
    spawnHitFlash(targetPart, color, 12, 18, 0.35)
    spawnHitEmitter(targetPart, {
        Name = "PlasmaCore",
        Texture = "rbxassetid://446111271",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(0.5, plasmaB),
            ColorSequenceKeypoint.new(1, color)
        }),
        Brightness = 15,
        EmitCount = 55,
        Speed = NumberRange.new(6, 16),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(0.35, 0.7),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(1, 0.08)
        }),
        LightEmission = 1,
    })
    spawnHitRing(targetPart, plasmaB, {Name = "PlasmaRing", StartSize = 0.4, EndSize = 5.5, Duration = 0.4, StartTransparency = 0.25})
end
local function glitchEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    for i = 1, 6 do
        spawnHitEmitter(targetPart, {
            Name = "GlitchShard" .. i,
            Texture = "rbxassetid://243660364",
            Color = (i % 2 == 0) and color or blendHitColor(color, 0.5),
            EmitCount = 8,
            Speed = NumberRange.new(18, 32),
            SpreadAngle = Vector2.new(40, 40),
            EmissionDirection = Enum.NormalId.Top,
            Lifetime = NumberRange.new(0.1, 0.25),
            Drag = 0,
            RotSpeed = NumberRange.new(-500, 500),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.35),
                NumberSequenceKeypoint.new(1, 0.1)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, math.random() * 0.4),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Cleanup = 0.8,
        })
    end
    spawnHitFlash(targetPart, blendHitColor(color, 0.6), 8, 10, 0.15)
end
local function cosmicDustEffect(adornee, color)
    local targetPart = getHitEffectPart(adornee)
    if not targetPart then return end
    spawnHitFlash(targetPart, blendHitColor(color, 0.25), 5, 16, 0.6)
    spawnHitEmitter(targetPart, {
        Name = "CosmicDust",
        Texture = "rbxassetid://1084982556",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.4, color),
            ColorSequenceKeypoint.new(1, darkenHitColor(color, 0.2))
        }),
        EmitCount = 60,
        Speed = NumberRange.new(3, 14),
        SpreadAngle = Vector2.new(180, 180),
        Lifetime = NumberRange.new(1.2, 2),
        Drag = 0.5,
        Acceleration = Vector3.new(0, 2, 0),
        RotSpeed = NumberRange.new(-80, 80),
        Brightness = 9,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(0.5, 0.18),
            NumberSequenceKeypoint.new(1, 0.04)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        }),
    })
    spawnHitRing(targetPart, blendHitColor(color, 0.1), {Name = "CosmicRing", StartSize = 0.2, EndSize = 3.5, Duration = 0.8, StartTransparency = 0.65, Material = Enum.Material.Glass})
end
local hitEffectHandlers = {
    Particles = particledesign,
    Fortnite = fortniteffect,
    Shockwave = shockwaveEffect,
    Lightning = lightningEffect,
    Blood = bloodEffect,
    Fire = fireEffect,
    Ice = iceEffect,
    Hearts = heartsEffect,
    Stars = starsEffect,
    Confetti = confettiEffect,
    Ripple = rippleEffect,
    Sparks = sparksEffect,
    Neon = neonPulseEffect,
    Void = voidRiftEffect,
    Plasma = plasmaEffect,
    Glitch = glitchEffect,
    ["Cosmic Shit"] = cosmicDustEffect,
}
workspace.DescendantAdded:Connect(function(obj)
    if not hitEffectEnabled then return end
    if not obj:IsA("BillboardGui") then return end
    local info = getDamageBillboardInfo(obj)
    if not info then return end
    task.defer(function()
        if not obj or not obj.Parent then return end
        obj.Enabled = false
        each_style(function(style)
            local handler = hitEffectHandlers[style]
            if handler then
                if style == "Fortnite" then
                    handler(info.adornee, hitEffectColor, info.lbl.Text)
                else
                    handler(info.adornee, hitEffectColor)
                end
            end
        end)
    end)
end)
end)()
end
do
local hitSoundsTab = HitGroup:AddTab('Hit Sounds')
local hitSoundEnabled = false
local hitSoundStyle = "Rust HS"
local hitSoundVolume = 0.5
local hitSoundPitch = 1.0
local folderName = "Hitsounds"
local soundFolder = folderName .. "/sounds"
local allSounds = {
    "Among Us", "Bonk", "Bruh", "Fart", "Minecraft", 
    "Neverlose", "Osu", "Stars", "Rust HS", "Vine"
}
local soundFiles = {
    ["Among Us"] = "amongus.mp3",
    ["Bonk"] = "bonk.mp3",
    ["Bruh"] = "bruh.mp3",
    ["Fart"] = "fart.mp3",
    ["Minecraft"] = "minecraft.mp3",
    ["Neverlose"] = "neverlose.mp3",
    ["Osu"] = "osu.mp3",
    ["Stars"] = "Stars.mp3",
    ["Rust HS"] = "rust hs.mp3",
    ["Vine"] = "vine.mp3"
}
local function downloadHS()
    if not isfolder(folderName) then
        makefolder(folderName)
    end
    if not isfolder(soundFolder) then
        makefolder(soundFolder)
    end
    local links = {
        ["amongus.mp3"] = "https://www.myinstants.com/media/sounds/roblox-death-sound_ytkBL7X.mp3",
        ["minecraft.mp3"] = "https://www.myinstants.com/media/sounds/steve-old-hurt-sound_XKZxUk4.mp3",
        ["bruh.mp3"] = "https://www.myinstants.com/media/sounds/discord-notification.mp3",
        ["fart.mp3"] = "https://www.myinstants.com/media/sounds/fart-moan3.mp3",
        ["neverlose.mp3"] = "https://www.myinstants.com/media/sounds/neverlose-s.mp3",
        ["rust hs.mp3"] = "https://www.myinstants.com/media/sounds/eaolwpzhgsba.mp3",
        ["osu.mp3"] = "https://www.myinstants.com/media/sounds/osu-hit-sound.mp3",
        ["Stars.mp3"] = "https://www.myinstants.com/media/sounds/starshitsound.mp3",
        ["bonk.mp3"] = "https://www.myinstants.com/media/sounds/bonk.mp3",
        ["vine.mp3"] = "https://www.myinstants.com/media/sounds/vine-boom.mp3",
    }
    for filename, link in pairs(links) do
        local fullPath = soundFolder .. "/" .. filename
        if not isfile(fullPath) then
            writefile(fullPath, game:HttpGet(link, true))
            task.wait(0.8)
        end
    end
end
downloadHS()
local function playHS()
    if not hitSoundEnabled then return end
    local filename = soundFiles[hitSoundStyle] or soundFiles["Rust HS"]
    local fullPath = soundFolder .. "/" .. filename
    if not isfile(fullPath) then
        fullPath = soundFolder .. "/rust hs.mp3"
    end
    local sound = Instance.new("Sound")
    sound.SoundId = getsynasset and getsynasset(fullPath) or getcustomasset(fullPath)
    sound.Volume = hitSoundVolume
    sound.PlaybackSpeed = hitSoundPitch
    sound.Parent = workspace
    sound:Play()
    task.delay(5, function()
        if sound and sound.Parent then
            sound:Destroy()
        end
    end)
end
hitSoundsTab:AddToggle("HitSounds", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        hitSoundEnabled = val
    end
})
local soundDropdown
hitSoundsTab:AddInput("SoundSearch", {
    Text = "Search Sounds",
    Placeholder = "",
    ClearTextOnFocus = false,
    Callback = function(t)
        if t == "" then
            soundDropdown:SetValues(allSounds)
            soundDropdown:SetValue("Rust HS")
            hitSoundStyle = "Rust HS"
            return
        end
        local filtered = {}
        t = t:lower()
        for _, sound in ipairs(allSounds) do
            if sound:lower():find(t, 1, true) then
                table.insert(filtered, sound)
            end
        end
        if #filtered > 0 then
            soundDropdown:SetValues(filtered)
            soundDropdown:SetValue(filtered[1])
            hitSoundStyle = filtered[1]
        end
    end
})
soundDropdown = hitSoundsTab:AddDropdown("SoundStyleDropdown", {
    Text = "Sound",
    Default = "Rust HS",
    Values = allSounds,
    Callback = function(val)
        hitSoundStyle = val
    end
})
hitSoundsTab:AddSlider("SoundVolume", {
    Text = "Volume",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        hitSoundVolume = val / 100
    end
})
hitSoundsTab:AddSlider("SoundPitch", {
    Text = "Pitch",
    Default = 100,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        hitSoundPitch = val / 100
    end
})
hitSoundsTab:AddToggle("DisableGunSounds", {
    Text = "Disable Gun Sounds",
    Default = _G.Features.DisableGunSounds,
    Callback = function(val)
        _G.Features.DisableGunSounds = val
        if val then
            if getgenv().InstanceRefreshGunSoundMute then
                getgenv().InstanceRefreshGunSoundMute()
            end
        else
            restoreGunSoundVolumes()
        end
    end
})
workspace.DescendantAdded:Connect(function(obj)
    if not hitSoundEnabled then return end
    if not obj:IsA("BillboardGui") then return end
    local info = getDamageBillboardInfo(obj)
    if not info then return end
    task.defer(function()
        if not obj or not obj.Parent then return end
        playHS()
    end)
end)
end
do
local ViewModelTabbox = Tabs.World:AddRightTabbox()
local vmTab = ViewModelTabbox:AddTab("view model")
local viewportTab = ViewModelTabbox:AddTab("viewport")
local gunChamsEnabled = false
local armChamsEnabled = false
local disableArmsEnabled = false
local gunOutlineEnabled = false
local armOutlineEnabled = false
local gunOutlineColor1 = Color3.fromRGB(255, 255, 255)
local gunOutlineColor2 = Color3.fromRGB(255, 255, 255)
local gunOutlineColor3 = Color3.fromRGB(255, 255, 255)
local armOutlineColor1 = Color3.fromRGB(255, 255, 255)
local armOutlineColor2 = Color3.fromRGB(255, 255, 255)
local armOutlineColor3 = Color3.fromRGB(255, 255, 255)
local gunMaterial = Enum.Material.Neon
local armMaterial = Enum.Material.ForceField
local gunColor1 = Color3.fromRGB(255, 255, 255)
local gunColor2 = Color3.fromRGB(255, 255, 255)
local gunColor3 = Color3.fromRGB(255, 255, 255)
local gunChamSpeed = 1
local gunChamPhase = 0
local armColor1 = Color3.fromRGB(255, 255, 255)
local armColor2 = Color3.fromRGB(255, 255, 255)
local armColor3 = Color3.fromRGB(255, 255, 255)
local armChamSpeed = 1
local armChamPhase = 0
local armChamTransparency = 0
local gunChamTransparency = 0
local gunHighlightEnabled = false
local armHighlightEnabled = false
local gunHighlightTop = Color3.fromRGB(255, 255, 255)
local gunHighlightBottom = Color3.fromRGB(200, 200, 255)
local armHighlightTop = Color3.fromRGB(255, 255, 255)
local armHighlightBottom = Color3.fromRGB(200, 200, 255)
local gunHighlightMaterial = Enum.Material.Neon
local armHighlightMaterial = Enum.Material.Neon
local gunHighlightFillTrans = 0
local gunHighlightOutlineTrans = 0
local armHighlightFillTrans = 0
local armHighlightOutlineTrans = 0
local gunHighlightPhase = 0
local armHighlightPhase = 0
local HIGHLIGHT_BLEND_SPEED = 0.12
local vmPartHighlights = {}
local origprops = {}
local chamOutlineHighlights = {}
local chamOutlineColorKeys = {}
local chamOutlineGlowClones = {}
local chamOutlineBloomClones = {}
local chamOutlineStore = Instance.new("Folder")
chamOutlineStore.Name = "\0ChamOutlines"
chamOutlineStore.Parent = game.CoreGui
local OUTLINE_EXCLUDED_PARTS = {
    ChamOutlineShell = true,
    ChamOutlineGlow = true,
    ChamOutlineBloom = true,
    WeaponWireframeCore = true,
    WeaponWireframeGlow = true,
    WeaponWireframeBloom = true,
    GunChamNeonGlow = true,
}
local viewportEnabled = false
local offsetX = 0
local offsetY = 0
local offsetZ = 0
local function saveorigprops(descendant)
    if not origprops[descendant] then
        origprops[descendant] = {
            Material = descendant.Material,
            Color = descendant.Color,
            Transparency = descendant.Transparency,
            Reflectance = descendant.Reflectance,
            textures = {},
            surfaceAppearances = {},
        }
        if descendant:IsA("MeshPart") then
            origprops[descendant].TextureID = descendant.TextureID
        end
        for _, child in ipairs(descendant:GetChildren()) do
            if child:IsA("Texture") or child:IsA("Decal") then
                origprops[descendant].textures[child] = child.Transparency
            elseif child:IsA("SurfaceAppearance") then
                table.insert(origprops[descendant].surfaceAppearances, child:Clone())
            end
        end
    end
end
local function restoreorigprops(descendant)
    local data = origprops[descendant]
    if not data then return end
    pcall(function()
        descendant.Material = data.Material
        descendant.Color = data.Color
        descendant.Transparency = data.Transparency
        descendant.Reflectance = data.Reflectance or 0
        if descendant:IsA("MeshPart") and data.TextureID ~= nil then
            descendant.TextureID = data.TextureID
        end
        for child, transparency in pairs(data.textures) do
            if child and child.Parent then
                child.Transparency = transparency
            end
        end
        for _, sa in ipairs(data.surfaceAppearances or {}) do
            if sa and not descendant:FindFirstChild(sa.Name) then
                local clone = sa:Clone()
                clone.Parent = descendant
            end
        end
    end)
end
local function forceApplyChamPart(part, fillColor, material, transparency, aggressive)
    saveorigprops(part)
    pcall(function()
        part.Material = material
        part.Color = fillColor
        part.Transparency = math.clamp(transparency or 0, 0, 1)
        part.Reflectance = 0
        part.LocalTransparencyModifier = 0
        if part:IsA("MeshPart") then
            part.TextureID = ""
        end
        local function stripVisual(child)
            if child:IsA("SurfaceAppearance") or child:IsA("WrapLayer") then
                child:Destroy()
            elseif child:IsA("Texture") or child:IsA("Decal") then
                if origprops[part] and not origprops[part].textures[child] then
                    origprops[part].textures[child] = child.Transparency
                end
                if aggressive then
                    child:Destroy()
                else
                    child.Transparency = 1
                end
            elseif child:IsA("SpecialMesh") or child:IsA("Mesh") then
                child.TextureId = ""
                if child:IsA("SpecialMesh") then
                    child.VertexColor = fillColor
                end
            end
        end
        for _, child in ipairs(part:GetChildren()) do
            stripVisual(child)
        end
        if aggressive then
            for _, child in ipairs(part:GetDescendants()) do
                stripVisual(child)
            end
        end
    end)
end
local function forceApplyArmChamPart(part, fillColor, material, transparency)
    forceApplyChamPart(part, fillColor, material, transparency, true)
    pcall(function()
        part.Material = material
        part.Color = fillColor
        part.Transparency = math.clamp(transparency or 0, 0, 1)
        part.Reflectance = 0
        part.LocalTransparencyModifier = 0
        if part:IsA("MeshPart") then
            part.TextureID = ""
        end
        for _, child in ipairs(part:GetDescendants()) do
            if child:IsA("SurfaceAppearance") or child:IsA("WrapLayer") then
                child:Destroy()
            elseif child:IsA("Texture") or child:IsA("Decal") then
                child:Destroy()
            elseif child:IsA("SpecialMesh") or child:IsA("Mesh") then
                child.TextureId = ""
                if child:IsA("SpecialMesh") then
                    child.VertexColor = fillColor
                end
            end
        end
    end)
end
local function lerpColor(c1, c2, alpha)
    return Color3.new(c1.R + (c2.R - c1.R) * alpha, c1.G + (c2.G - c1.G) * alpha, c1.B + (c2.B - c1.B) * alpha)
end
local function gradcolor(c1, c2, c3, pos, t)
    local cp = (pos + t) % 1
    if cp < 0.33 then
        return lerpColor(c1, c2, cp / 0.33)
    elseif cp < 0.66 then
        return lerpColor(c2, c3, (cp - 0.33) / 0.33)
    else
        return lerpColor(c3, c1, (cp - 0.66) / 0.34)
    end
end
local function getModelYBounds(model)
    local minY, maxY = math.huge, -math.huge
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then
            minY = math.min(minY, d.Position.Y)
            maxY = math.max(maxY, d.Position.Y)
        end
    end
    if minY == math.huge then
        return 0, 1
    end
    return minY, maxY
end
local function getFilteredModelYBounds(model, partFilter)
    local minY, maxY = math.huge, -math.huge
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and partFilter(d) then
            minY = math.min(minY, d.Position.Y)
            maxY = math.max(maxY, d.Position.Y)
        end
    end
    if minY == math.huge then
        return 0, 1
    end
    return minY, maxY
end
local function verticalChamColor(part, model, topColor, bottomColor, yBounds)
    local minY, maxY = yBounds[1], yBounds[2]
    local range = math.max(maxY - minY, 0.001)
    local t = math.clamp((part.Position.Y - minY) / range, 0, 1)
    return lerpColor(bottomColor, topColor, t)
end
local function animatedHighlightColor(topColor, bottomColor, phase)
    local t = phase * 2
    if t > 1 then
        t = 2 - t
    end
    return lerpColor(bottomColor, topColor, t)
end
local function shouldOutlinePart(part)
    if OUTLINE_EXCLUDED_PARTS[part.Name] then
        return false
    end
    if part.Transparency >= 0.99 then
        return false
    end
    local n = part.Name:lower()
    if n:find("hitbox") or n:find("collision") or n:find("trigger") or n:find("proxy") then
        return false
    end
    return true
end
local function chamOutlineColorKey(color)
    return string.format("%d_%d_%d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end
local function clearLegacyOutlineShell(part)
    local legacy = part:FindFirstChild("ChamOutlineShell")
    if legacy then
        pcall(function() legacy:Destroy() end)
    end
    local legacyHighlight = part:FindFirstChild("ChamOutline")
    if legacyHighlight and legacyHighlight:IsA("Highlight") then
        pcall(function() legacyHighlight:Destroy() end)
    end
end
local function clearChamOutlineGlow(part)
    for _, cloneTable in ipairs({ chamOutlineGlowClones, chamOutlineBloomClones }) do
        local glow = cloneTable[part]
        if glow then
            pcall(function() glow:Destroy() end)
            cloneTable[part] = nil
        end
    end
end
local function clearAllChamOutlineGlows()
    local tracked = {}
    for part in pairs(chamOutlineGlowClones) do
        tracked[part] = true
    end
    for part in pairs(chamOutlineBloomClones) do
        tracked[part] = true
    end
    for part in pairs(tracked) do
        clearChamOutlineGlow(part)
    end
end
local function clearChamOutline(part)
    clearLegacyOutlineShell(part)
    clearChamOutlineGlow(part)
    local highlight = chamOutlineHighlights[part]
    if highlight then
        pcall(function() highlight:Destroy() end)
        chamOutlineHighlights[part] = nil
    end
    chamOutlineColorKeys[part] = nil
end
local function clearAllChamOutlines()
    clearAllChamOutlineGlows()
    local tracked = {}
    for part in pairs(chamOutlineHighlights) do
        tracked[part] = true
    end
    for part in pairs(tracked) do
        clearChamOutline(part)
    end
end
local function buildChamOutlineGlow(anchorPart, sourcePart, cloneTable, name, scale, transparency, padding)
    local glow = cloneTable[sourcePart]
    if not glow or not glow.Parent then
        glow = anchorPart:Clone()
        glow.Name = name
        for _, child in ipairs(glow:GetDescendants()) do
            if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("Highlight") then
                child:Destroy()
            end
        end
        for _, child in ipairs(glow:GetChildren()) do
            if child:IsA("Texture") or child:IsA("Decal") or child:IsA("SurfaceAppearance") then
                child:Destroy()
            end
        end
        glow.Anchored = false
        glow.CanCollide = false
        glow.CanQuery = false
        glow.CanTouch = false
        glow.Massless = true
        glow.CastShadow = false
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = anchorPart
        weld.Part1 = glow
        weld.Parent = glow
        glow.Parent = anchorPart
        cloneTable[sourcePart] = glow
    end
    glow.Material = Enum.Material.Neon
    glow.Transparency = transparency
    if glow:IsA("BasePart") then
        glow.Size = anchorPart.Size * scale + padding
    end
end
local function syncChamOutlineGlow(part, color, strength)
    if not part or not part.Parent then
        clearChamOutlineGlow(part)
        return
    end
    local s = math.clamp((tonumber(strength) or 5) / 10, 0, 1)
    local innerScale = 1.02 + s * 0.07
    local bloomScale = 1.06 + s * 0.2
    local innerTrans = math.clamp(0.55 - s * 0.4, 0.05, 0.95)
    local bloomTrans = math.clamp(0.88 - s * 0.55, 0.08, 0.95)
    local innerPad = Vector3.new(0.008, 0.008, 0.008) + Vector3.new(0.02, 0.02, 0.02) * s
    local bloomPad = Vector3.new(0.02, 0.02, 0.02) + Vector3.new(0.06, 0.06, 0.06) * s
    buildChamOutlineGlow(part, part, chamOutlineGlowClones, "ChamOutlineGlow", innerScale, innerTrans, innerPad)
    buildChamOutlineGlow(part, part, chamOutlineBloomClones, "ChamOutlineBloom", bloomScale, bloomTrans, bloomPad)
    local inner = chamOutlineGlowClones[part]
    local bloom = chamOutlineBloomClones[part]
    if inner then inner.Color = color end
    if bloom then bloom.Color = color end
end
local function syncChamOutline(part, color)
    if not part or not part.Parent then
        return
    end
    local key = chamOutlineColorKey(color)
    local highlight = chamOutlineHighlights[part]
    if highlight and highlight.Parent and highlight.Adornee == part and chamOutlineColorKeys[part] == key then
        return
    end
    clearLegacyOutlineShell(part)
    if not highlight or not highlight.Parent then
        highlight = Instance.new("Highlight")
        highlight.Name = "ChamOutline"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = chamOutlineStore
        chamOutlineHighlights[part] = highlight
    end
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.FillColor = color
    highlight.FillTransparency = 1
    highlight.Adornee = part
    chamOutlineColorKeys[part] = key
end
local function purgeStaleChamOutlines(activeParts)
    for part in pairs(chamOutlineHighlights) do
        if not activeParts[part] then
            clearChamOutline(part)
        end
    end
end
local function viewModelEffectsActive()
    return gunChamsEnabled or armChamsEnabled or gunOutlineEnabled or armOutlineEnabled or disableArmsEnabled or gunHighlightEnabled or armHighlightEnabled
end
local function clearVmPartHighlight(part)
    local hl = vmPartHighlights[part]
    if hl then
        pcall(function() hl:Destroy() end)
        vmPartHighlights[part] = nil
    end
    local legacy = part and part:FindFirstChild("InstanceVmPartHighlight")
    if legacy and legacy:IsA("Highlight") then
        pcall(function() legacy:Destroy() end)
    end
end
local function clearAllVmPartHighlights()
    for part in pairs(vmPartHighlights) do
        clearVmPartHighlight(part)
    end
    vmPartHighlights = {}
end
local function syncVmPartHighlight(part, fillColor, outlineColor, fillTrans, outlineTrans)
    if not part or not part.Parent then
        clearVmPartHighlight(part)
        return
    end
    clearVmPartHighlight(part)
    local hl = Instance.new("Highlight")
    hl.Name = "InstanceVmPartHighlight"
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = fillColor
    hl.OutlineColor = outlineColor
    hl.FillTransparency = math.clamp(fillTrans or 0, 0, 1)
    hl.OutlineTransparency = math.clamp(outlineTrans or 0, 0, 1)
    hl.Adornee = part
    hl.Parent = part
    vmPartHighlights[part] = hl
end
local function purgeStaleVmPartHighlights(activeParts)
    for part in pairs(vmPartHighlights) do
        if not activeParts[part] then
            clearVmPartHighlight(part)
        end
    end
end
local function isArmViewModel(model)
    local segs = {}
    for seg in model.Name:gmatch("[^-]+") do
        table.insert(segs, seg:match("^%s*(.-)%s*$"):lower())
    end
    if #segs >= 2 then
        local tag = segs[2]
        if tag == "arms" or tag == "arm" then
            return true
        end
        if tag:find("arm", 1, true) and not tag:find("charm", 1, true) and not tag:find("armor", 1, true) then
            return true
        end
        if tag:find("glove", 1, true) then
            return true
        end
        return false
    end
    local n = model.Name:lower()
    return n:find("arms", 1, true) ~= nil or n:find("glove", 1, true) ~= nil
end
local ARM_PART_SKIP = {
    hitbox = true,
    collision = true,
    trigger = true,
    proxy = true,
    handguard = true,
    handle = true,
    foregrip = true,
    charm = true,
    armor = true,
}
local function isArmNamedPart(partName)
    local lower = partName:lower()
    for skip in pairs(ARM_PART_SKIP) do
        if lower:find(skip, 1, true) then
            return false
        end
    end
    if lower == "leftarm" or lower == "rightarm" or lower == "larm" or lower == "rarm" then
        return true
    end
    if lower:find("leftarm", 1, true) or lower:find("rightarm", 1, true) then
        return true
    end
    if lower:find("left arm", 1, true) or lower:find("right arm", 1, true) then
        return true
    end
    if lower:find("forearm", 1, true) or lower:find("upperarm", 1, true) or lower:find("lowerarm", 1, true) then
        return true
    end
    if lower:find("glove", 1, true) or lower:find("sleeve", 1, true) then
        return true
    end
    if lower:find("finger", 1, true) or lower:find("wrist", 1, true) or lower:find("palm", 1, true) or lower:find("thumb", 1, true) then
        return true
    end
    if lower:find("hand", 1, true) then
        if lower:find("handguard", 1, true) or lower:find("handle", 1, true) then
            return false
        end
        return true
    end
    return false
end
local function hasArmHierarchy(part, model)
    local current = part.Parent
    while current and current ~= model do
        local n = current.Name:lower()
        if n == "arms" or n == "leftarm" or n == "rightarm" or n == "left arm" or n == "right arm" or n == "hands" or n == "gloves" then
            return true
        end
        if n:find("glove", 1, true) or n:find("sleeve", 1, true) then
            return true
        end
        if n:find("arm", 1, true)
            and not n:find("armor", 1, true)
            and not n:find("handguard", 1, true)
            and not n:find("foregrip", 1, true)
            and not n:find("charm", 1, true) then
            return true
        end
        current = current.Parent
    end
    return false
end
local function isArmChamPart(part, model)
    if not part or not part:IsA("BasePart") then
        return false
    end
    if OUTLINE_EXCLUDED_PARTS[part.Name] or part.Transparency >= 0.99 then
        return false
    end
    if isArmViewModel(model) then
        local n = part.Name:lower()
        if OUTLINE_EXCLUDED_PARTS[part.Name] then return false end
        if n:find("hitbox") or n:find("collision") or n:find("trigger") or n:find("proxy") then
            return false
        end
        return true
    end
    if hasArmHierarchy(part, model) then
        return true
    end
    return isArmNamedPart(part.Name)
end
local function isGunChamPart(part, model)
    if not part or not part:IsA("BasePart") then
        return false
    end
    if OUTLINE_EXCLUDED_PARTS[part.Name] or part.Transparency >= 0.99 then
        return false
    end
    if isArmViewModel(model) then
        return false
    end
    if isArmChamPart(part, model) then
        return false
    end
    return shouldOutlinePart(part)
end
local applyChams
local chamLoop
local CHAM_RENDER_BIND = "InstanceViewModelChams"
local CHAM_TARGET_HZ = 60
local chamAccum = 0
local chamPartCache = nil
local chamCacheDirty = true
local chamVmWasMissing = false
local chamFpHooked = false
local function markChamCacheDirty()
    chamCacheDirty = true
end
local function fullChamCleanup()
    clearAllChamOutlines()
    clearAllChamOutlineGlows()
    clearAllVmPartHighlights()
    for part, _ in pairs(origprops) do
        if part and part.Parent then
            restoreorigprops(part)
        end
    end
    origprops = {}
    chamPartCache = nil
    chamCacheDirty = true
end
local function hookChamFirstPerson(fp)
    if not fp or chamFpHooked then return end
    chamFpHooked = true
    fp.ChildAdded:Connect(function()
        task.defer(markChamCacheDirty)
    end)
    fp.ChildRemoved:Connect(function()
        task.defer(markChamCacheDirty)
    end)
end
local function rebuildChamPartCache(fp)
    chamPartCache = {}
    for _, model in ipairs(fp:GetChildren()) do
        if model:IsA("Model") then
            for _, descendant in ipairs(model:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local isArm = isArmChamPart(descendant, model)
                    local isGun = isGunChamPart(descendant, model)
                    if isArm or isGun then
                        table.insert(chamPartCache, {
                            part = descendant,
                            model = model,
                            isArm = isArm,
                            isGun = isGun,
                        })
                    end
                end
            end
        end
    end
    chamCacheDirty = false
end
local function stopchamloop()
    pcall(function() RunService:UnbindFromRenderStep(CHAM_RENDER_BIND) end)
    if chamLoop then chamLoop:Disconnect() chamLoop = nil end
    chamVmWasMissing = false
    chamFpHooked = false
    fullChamCleanup()
end
local function chamloop()
    if chamLoop then chamLoop:Disconnect() chamLoop = nil end
    pcall(function() RunService:UnbindFromRenderStep(CHAM_RENDER_BIND) end)
    local bound = pcall(function()
        RunService:BindToRenderStep(CHAM_RENDER_BIND, Enum.RenderPriority.Last.Value, applyChams)
    end)
    if not bound then
        chamLoop = RunService.RenderStepped:Connect(applyChams)
    end
end
local function updViewModelEffectLoop()
    markChamCacheDirty()
    if viewModelEffectsActive() then
        chamloop()
    else
        stopchamloop()
    end
end
getgenv().InstanceUpdViewModelChams = updViewModelEffectLoop
applyChams = function(dt)
    if isInstanceMenuOpen and isInstanceMenuOpen() then
        return
    end
    dt = dt or (1 / 240)
    if gunHighlightEnabled then
        gunHighlightPhase = (gunHighlightPhase + dt * HIGHLIGHT_BLEND_SPEED) % 1
    end
    if armHighlightEnabled then
        armHighlightPhase = (armHighlightPhase + dt * HIGHLIGHT_BLEND_SPEED) % 1
    end
    local anyChams = gunChamsEnabled or armChamsEnabled
    if anyChams or gunOutlineEnabled or armOutlineEnabled or gunHighlightEnabled or armHighlightEnabled then
        chamAccum = chamAccum + dt
        if chamAccum >= (1 / CHAM_TARGET_HZ) then
            chamAccum = chamAccum - (1 / CHAM_TARGET_HZ)
            if gunChamsEnabled or gunOutlineEnabled or gunHighlightEnabled then
                gunChamPhase = (gunChamPhase + (1 / CHAM_TARGET_HZ) * gunChamSpeed) % 1
            end
            if armChamsEnabled or armOutlineEnabled or armHighlightEnabled then
                armChamPhase = (armChamPhase + (1 / CHAM_TARGET_HZ) * armChamSpeed) % 1
            end
        end
    end
    if not viewModelEffectsActive() then
        if chamPartCache or next(origprops) then
            fullChamCleanup()
        end
        return
    end
    local vm = Workspace:FindFirstChild("ViewModels")
    if not vm then
        if not chamVmWasMissing then
            fullChamCleanup()
            chamVmWasMissing = true
        end
        return
    end
    local fp = vm:FindFirstChild("FirstPerson")
    if not fp then
        if not chamVmWasMissing then
            fullChamCleanup()
            chamVmWasMissing = true
        end
        chamFpHooked = false
        return
    end
    chamVmWasMissing = false
    hookChamFirstPerson(fp)
    if chamCacheDirty or not chamPartCache then
        rebuildChamPartCache(fp)
    end
    local activeChamOutlineParts = {}
    local activeParts = {}
    local activeVmPartHighlights = {}
    for _, entry in ipairs(chamPartCache) do
        local descendant = entry.part
        if not descendant or not descendant.Parent then
            markChamCacheDirty()
            continue
        end
        local isArmPart = entry.isArm
        local isGunPart = entry.isGun and not entry.isArm
        local model = entry.model
        activeParts[descendant] = true
        saveorigprops(descendant)
        if disableArmsEnabled and isArmPart then
            descendant.Transparency = 1
            for _, child in ipairs(descendant:GetChildren()) do
                if child:IsA("Texture") or child:IsA("Decal") or child:IsA("SurfaceAppearance") then
                    child.Transparency = 1
                end
            end
            clearChamOutline(descendant)
            clearVmPartHighlight(descendant)
        else
            local useGunHighlight = gunHighlightEnabled and isGunPart
            local useArmHighlight = armHighlightEnabled and isArmPart
            local useChams = not useGunHighlight and not useArmHighlight and ((isArmPart and armChamsEnabled) or (isGunPart and gunChamsEnabled))
            local useOutline = (isArmPart and armOutlineEnabled and not useArmHighlight) or (isGunPart and gunOutlineEnabled and not useGunHighlight)
            local fillColor = gradcolor(
                isArmPart and armColor1 or gunColor1,
                isArmPart and armColor2 or gunColor2,
                isArmPart and armColor3 or gunColor3,
                0,
                isArmPart and armChamPhase or gunChamPhase
            )
            local outlineColor = gradcolor(
                isArmPart and armOutlineColor1 or gunOutlineColor1,
                isArmPart and armOutlineColor2 or gunOutlineColor2,
                isArmPart and armOutlineColor3 or gunOutlineColor3,
                0,
                isArmPart and armChamPhase or gunChamPhase
            )
            if useGunHighlight then
                restoreorigprops(descendant)
                local fillCol = animatedHighlightColor(gunHighlightTop, gunHighlightBottom, gunHighlightPhase)
                local outlineCol = lerpColor(fillCol, Color3.new(0, 0, 0), 0.35)
                syncVmPartHighlight(descendant, fillCol, outlineCol, gunHighlightFillTrans, gunHighlightOutlineTrans)
                activeVmPartHighlights[descendant] = true
            elseif useArmHighlight then
                local fillCol = animatedHighlightColor(armHighlightTop, armHighlightBottom, armHighlightPhase)
                local outlineCol = lerpColor(fillCol, Color3.new(0, 0, 0), 0.35)
                forceApplyArmChamPart(descendant, fillCol, armHighlightMaterial, armHighlightFillTrans)
                syncVmPartHighlight(descendant, fillCol, outlineCol, armHighlightFillTrans, armHighlightOutlineTrans)
                activeVmPartHighlights[descendant] = true
            elseif useChams then
                local chamMat = isArmPart and armMaterial or gunMaterial
                local chamTrans = isArmPart and armChamTransparency or gunChamTransparency
                if isArmPart then
                    forceApplyArmChamPart(descendant, fillColor, chamMat, chamTrans)
                else
                    forceApplyChamPart(descendant, fillColor, chamMat, chamTrans, false)
                end
                clearVmPartHighlight(descendant)
            elseif not useOutline then
                restoreorigprops(descendant)
                clearVmPartHighlight(descendant)
            else
                clearVmPartHighlight(descendant)
            end
            if useOutline then
                syncChamOutline(descendant, outlineColor)
                activeChamOutlineParts[descendant] = true
            else
                clearChamOutline(descendant)
            end
        end
    end
    purgeStaleChamOutlines(activeChamOutlineParts)
    purgeStaleVmPartHighlights(activeVmPartHighlights)
    for part, _ in pairs(origprops) do
        if not activeParts[part] then
            restoreorigprops(part)
            origprops[part] = nil
        end
    end
end
local viewportLoop
local function viewportloop()
    if viewportLoop then viewportLoop:Disconnect() end
    viewportLoop = game:GetService("RunService").RenderStepped:Connect(function()
        if isInstanceMenuOpen and isInstanceMenuOpen() then return end
        if not viewportEnabled then return end
        local vm = Workspace:FindFirstChild("ViewModels")
        if not vm then return end
        local fp = vm:FindFirstChild("FirstPerson")
        if not fp then return end
        local camera = workspace.CurrentCamera
        local offset = camera.CFrame * CFrame.new(offsetX, offsetY, offsetZ)
        for _, model in ipairs(fp:GetChildren()) do
            if model:IsA("Model") then
                local primary = model.PrimaryPart
                if primary then
                    model:SetPrimaryPartCFrame(offset)
                end
            end
        end
    end)
end
local function stopViewportLoop()
    if viewportLoop then
        viewportLoop:Disconnect()
        viewportLoop = nil
    end
end
viewportTab:AddToggle("EnableViewport", {Text = "Enable", Default = false, Callback = function(v)
    viewportEnabled = v
    if v then
        viewportloop()
    else
        stopViewportLoop()
    end
end})
viewportTab:AddSlider('OffsetX', {
    Text = 'x',
    Default = 0,
    Min = -10,
    Max = 10,
    Rounding = 2,
    Compact = true,
    Callback = function(v) offsetX = v end
})
viewportTab:AddSlider('OffsetY', {
    Text = 'y',
    Default = 0,
    Min = -10,
    Max = 10,
    Rounding = 2,
    Compact = true,
    Callback = function(v) offsetY = v end
})
viewportTab:AddSlider("OffsetZ", {Text = "Z", Default = 0, Min = -10, Max = 10, Rounding = 2, Compact = true, Callback = function(v) offsetZ = v end})
local noAnimationsEnabled = false
local noAnimBlocked = {}
local noAnimConns = {}
local noAnimLoop = nil
local NO_ANIM_PATTERNS = {
    Idle = { "idle" },
    Reloading = { "reload" },
    Sprinting = { "sprint" },
    Crouching = { "crouch" },
    Shooting = { "shoot", "fire", "shot" },
    Aiming = { "aim", "ads", "scope" },
}
local function getViewModelTrackName(track)
    local parts = { track.Name:lower() }
    local anim = track.Animation
    if anim then
        table.insert(parts, anim.Name:lower())
        table.insert(parts, tostring(anim.AnimationId):lower())
    end
    return table.concat(parts, " ")
end
local function shouldBlockViewModelTrack(track)
    if not noAnimationsEnabled or type(noAnimBlocked) ~= "table" then
        return false
    end
    local name = getViewModelTrackName(track)
    for category, patterns in pairs(NO_ANIM_PATTERNS) do
        if noAnimBlocked[category] then
            for _, pattern in ipairs(patterns) do
                if name:find(pattern, 1, true) then
                    return true
                end
            end
        end
    end
    return false
end
local function stopBlockedViewModelTrack(track)
    if shouldBlockViewModelTrack(track) then
        pcall(function()
            track:Stop(0)
        end)
    end
end
local function bindViewModelAnimator(animator)
    if typeof(animator) ~= "Instance" or not animator:IsA("Animator") then
        return
    end
    if animator:GetAttribute("InstanceNoAnimBound") then
        return
    end
    animator:SetAttribute("InstanceNoAnimBound", true)
    local parent = animator.Parent
    if parent and parent:IsA("Humanoid") then
        table.insert(noAnimConns, parent.AnimationPlayed:Connect(function(track)
            if noAnimationsEnabled then
                task.defer(function()
                    stopBlockedViewModelTrack(track)
                end)
            end
        end))
    end
end
local function scanViewModelAnimators(root)
    if not root then return end
    for _, desc in ipairs(root:GetDescendants()) do
        if desc:IsA("Animator") then
            bindViewModelAnimator(desc)
            if noAnimationsEnabled then
                for _, track in ipairs(desc:GetPlayingAnimationTracks()) do
                    stopBlockedViewModelTrack(track)
                end
            end
        end
    end
end
local function hookViewModelAnimations()
    local vm = Workspace:FindFirstChild("ViewModels")
    if not vm then return end
    local fp = vm:FindFirstChild("FirstPerson")
    if fp then
        scanViewModelAnimators(fp)
        if not vm:GetAttribute("InstanceNoAnimVmHooked") then
            vm:SetAttribute("InstanceNoAnimVmHooked", true)
            table.insert(noAnimConns, fp.DescendantAdded:Connect(function(desc)
                if desc:IsA("Animator") then
                    bindViewModelAnimator(desc)
                end
            end))
        end
    end
end
local function stopNoAnimLoop()
    if noAnimLoop then
        noAnimLoop:Disconnect()
        noAnimLoop = nil
    end
    for _, conn in ipairs(noAnimConns) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(noAnimConns)
    local vm = Workspace:FindFirstChild("ViewModels")
    if vm then
        vm:SetAttribute("InstanceNoAnimVmHooked", nil)
        for _, desc in ipairs(vm:GetDescendants()) do
            if desc:IsA("Animator") then
                desc:SetAttribute("InstanceNoAnimBound", nil)
            end
        end
    end
end
local function startNoAnimLoop()
    stopNoAnimLoop()
    hookViewModelAnimations()
    noAnimLoop = RunService.RenderStepped:Connect(function()
        if not noAnimationsEnabled then return end
        if isInstanceMenuOpen and isInstanceMenuOpen() then return end
        hookViewModelAnimations()
        local vm = Workspace:FindFirstChild("ViewModels")
        local fp = vm and vm:FindFirstChild("FirstPerson")
        if not fp then return end
        for _, desc in ipairs(fp:GetDescendants()) do
            if desc:IsA("Animator") then
                for _, track in ipairs(desc:GetPlayingAnimationTracks()) do
                    stopBlockedViewModelTrack(track)
                end
            end
        end
    end)
end
local function updNoAnimations()
    if noAnimationsEnabled then
        startNoAnimLoop()
    else
        stopNoAnimLoop()
    end
end
local noAnimToggle = viewportTab:AddToggle("NoAnimations", {
    Text = "No Animations",
    Default = false,
    Callback = function(v)
        noAnimationsEnabled = v
        updNoAnimations()
    end,
})
local noAnimDepBox = viewportTab:AddDependencyBox()
noAnimDepBox:AddDropdown("NoAnimationsList", {
    Text = "Disabled Animations",
    Values = { "Idle", "Reloading", "Sprinting", "Crouching", "Shooting", "Aiming" },
    Default = {},
    Multi = true,
    Callback = function(v)
        noAnimBlocked = v or {}
    end,
})
noAnimDepBox:SetupDependencies({
    { noAnimToggle, true },
})
local mats = { "ForceField", "Neon", "SmoothPlastic", "Glass", "Ice", "Plastic", "Wood", "Marble", "Granite", "Brick", "Cobblestone", "Concrete", "Slate", "Foil" }
local gunChamsToggle = vmTab:AddToggle("GunChams", {
    Text = "Gun Chams",
    Default = false,
    Callback = function(v)
        gunChamsEnabled = v
        updViewModelEffectLoop()
    end,
}):AddColorPicker("GunColor1", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "gun color 1",
    Callback = function(v) gunColor1 = v end,
}):AddColorPicker("GunColor2", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "gun color 2",
    Callback = function(v) gunColor2 = v end,
}):AddColorPicker("GunColor3", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "gun color 3",
    Callback = function(v) gunColor3 = v end,
})
local gunChamsDep = vmTab:AddDependencyBox()
gunChamsDep:AddDropdown("GunMaterial", {
    Text = "Gun Material",
    Default = "Neon",
    Values = mats,
    Callback = function(v) gunMaterial = Enum.Material[v] end,
})
gunChamsDep:AddSlider("GunChamSpeed", {
    Text = "Gradient Speed",
    Default = gunChamSpeed,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(v) gunChamSpeed = v end,
})
gunChamsDep:AddSlider("GunChamTransparency", {
    Text = "Gun Transparency",
    Default = gunChamTransparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v) gunChamTransparency = v end,
})
gunChamsDep:SetupDependencies({
    { gunChamsToggle, true },
})
local armChamsToggle = vmTab:AddToggle("ArmChams", {
    Text = "Arm Chams",
    Default = false,
    Callback = function(v)
        armChamsEnabled = v
        updViewModelEffectLoop()
    end,
}):AddColorPicker("ArmColor1", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "arm color 1",
    Callback = function(v) armColor1 = v end,
}):AddColorPicker("ArmColor2", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "arm color 2",
    Callback = function(v) armColor2 = v end,
}):AddColorPicker("ArmColor3", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "arm color 3",
    Callback = function(v) armColor3 = v end,
})
local armChamsDep = vmTab:AddDependencyBox()
armChamsDep:AddDropdown("ArmMaterial", {
    Text = "Arm Material",
    Default = "ForceField",
    Values = mats,
    Callback = function(v) armMaterial = Enum.Material[v] end,
})
armChamsDep:AddSlider("ArmChamSpeed", {
    Text = "Gradient Speed",
    Default = armChamSpeed,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(v) armChamSpeed = v end,
})
armChamsDep:AddSlider("ArmChamTransparency", {
    Text = "Arm Transparency",
    Default = armChamTransparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v) armChamTransparency = v end,
})
armChamsDep:SetupDependencies({
    { armChamsToggle, true },
})
vmTab:AddToggle("GunOutline", {
    Text = "Gun Outline",
    Default = false,
    Callback = function(v)
        gunOutlineEnabled = v
        updViewModelEffectLoop()
    end,
}):AddColorPicker("GunOutlineColor1", {
    Title = 'gun outline 1',
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) gunOutlineColor1 = v end,
}):AddColorPicker("GunOutlineColor2", {
    Title = "gun outline 2",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) gunOutlineColor2 = v end,
}):AddColorPicker("GunOutlineColor3", {
    Title = "gun outline 3",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) gunOutlineColor3 = v end,
})
vmTab:AddToggle("ArmOutline", {
    Text = "Arm Outline",
    Default = false,
    Callback = function(v)
        armOutlineEnabled = v
        updViewModelEffectLoop()
    end,
}):AddColorPicker("ArmOutlineColor1", {
    Title = "arm outline 1",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) armOutlineColor1 = v end,
}):AddColorPicker("ArmOutlineColor2", {
    Title = "arm outline 2",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) armOutlineColor2 = v end,
}):AddColorPicker("ArmOutlineColor3", {
    Title = "arm outline 3",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) armOutlineColor3 = v end,
})
local gunHighlightToggle = vmTab:AddToggle("GunHighlight", {
    Text = "Gun Highlight",
    Default = false,
    Callback = function(v)
        gunHighlightEnabled = v
        updViewModelEffectLoop()
    end,
}):AddColorPicker("GunHighlightTop", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "gun top",
    Callback = function(v) gunHighlightTop = v end,
}):AddColorPicker("GunHighlightBottom", {
    Default = Color3.fromRGB(200, 200, 255),
    Title = "gun bottom",
    Callback = function(v) gunHighlightBottom = v end,
})
local gunHighlightDep = vmTab:AddDependencyBox()
gunHighlightDep:AddDropdown("GunHighlightMaterial", {
    Text = "Gun Highlight Material",
    Default = "Neon",
    Values = mats,
    Callback = function(v) gunHighlightMaterial = Enum.Material[v] end,
})
gunHighlightDep:AddSlider("GunHighlightFillTransparency", {
    Text = "Transparency",
    Default = gunHighlightFillTrans,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v) gunHighlightFillTrans = v end,
})
gunHighlightDep:AddSlider("GunHighlightOutlineTransparency", {
    Text = "Outline Transparency",
    Default = gunHighlightOutlineTrans,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v) gunHighlightOutlineTrans = v end,
})
gunHighlightDep:SetupDependencies({
    { gunHighlightToggle, true },
})
local armHighlightToggle = vmTab:AddToggle("ArmHighlight", {
    Text = "Arm Highlight",
    Default = false,
    Callback = function(v)
        armHighlightEnabled = v
        updViewModelEffectLoop()
    end,
}):AddColorPicker("ArmHighlightTop", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "arm top",
    Callback = function(v) armHighlightTop = v end,
}):AddColorPicker("ArmHighlightBottom", {
    Default = Color3.fromRGB(200, 200, 255),
    Title = "arm bottom",
    Callback = function(v) armHighlightBottom = v end,
})
local armHighlightDep = vmTab:AddDependencyBox()
armHighlightDep:AddDropdown("ArmHighlightMaterial", {
    Text = "Arm Highlight Material",
    Default = "Neon",
    Values = mats,
    Callback = function(v) armHighlightMaterial = Enum.Material[v] end,
})
armHighlightDep:AddSlider("ArmHighlightFillTransparency", {
    Text = "Arm Highlight Fill Transparency",
    Default = armHighlightFillTrans,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v) armHighlightFillTrans = v end,
})
armHighlightDep:AddSlider("ArmHighlightOutlineTransparency", {
    Text = "Arm Highlight Outline Transparency",
    Default = armHighlightOutlineTrans,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v) armHighlightOutlineTrans = v end,
})
armHighlightDep:SetupDependencies({
    { armHighlightToggle, true },
})
vmTab:AddToggle("DisableArms", {
    Text = "Disable Arms",
    Default = false,
    Callback = function(v)
        disableArmsEnabled = v
        updViewModelEffectLoop()
    end,
})
end
do
local TracersGroup = Tabs.World:AddLeftGroupbox("bullet tracers")
local tracerEnabled  = true
local tracerColor    = Color3.fromRGB(255, 255, 255)
local tracerDuration = 3
local tracerSize     = 1
local tracerFadeTime = 0.5
local tracerLerpSpeed = 0
local tracerStyle    = "Line"
local tracers        = {}
local tracerconn     = nil
local tracerEffectHooked = false
local lastTracerCreations = {}
local DEDUPE_INTERVAL     = 0.1
local DEDUPE_EXPIRY       = 1.0
local textureAssets = {
    Line      = "",
    Beam      = "rbxassetid://12781852245",
    Lightning = "rbxassetid://446111271",
    Heartrate = "rbxassetid://5830549480",
    Chain     = "rbxassetid://9632168658",
    Glitch    = "rbxassetid://8089467613",
    Swirl     = "rbxassetid://5638168605",
    Neon      = "rbxassetid://6361963422",
    Plasma    = "rbxassetid://8993645509",
    Laser     = "rbxassetid://14549123968",
}
local function muzzlepos()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end
    local playerName = LocalPlayer.Name
    for _, model in ipairs(firstPerson:GetChildren()) do
        if model:IsA("Model") and model.Name:find("^" .. playerName) then
            local iv = model:FindFirstChild("ItemVisual")
            if iv then
                local body = iv:FindFirstChild("Body")
                if body then
                    local bp = body:FindFirstChild("BodyPrimary")
                    if bp then
                        local muzzle = bp:FindFirstChild("_muzzle")
                        if muzzle and muzzle:IsA("Attachment") then
                            return muzzle.WorldPosition
                        end
                    end
                end
            end
        end
    end
    if type(findShotMuzzlePosition) == "function" then
        return findShotMuzzlePosition()
    end
    return nil
end
local function getTracerDrawEnd(tr, age)
    if tracerLerpSpeed <= 0 then
        return tr.EndPos
    end
    local drawTime = math.max(tracerLerpSpeed * 0.25, 0.001)
    local progress = math.clamp(age / drawTime, 0, 1)
    return tr.StartPos:Lerp(tr.EndPos, progress)
end
local function makeLineTracer(pos3, endPos)
    local outline = Drawing.new("Line")
    outline.Thickness   = 4 * tracerSize
    outline.Color       = Color3.new(0, 0, 0)
    outline.Transparency = 1
    outline.Visible     = false
    local line = Drawing.new("Line")
    line.Thickness   = 2 * tracerSize
    line.Color       = tracerColor
    line.Transparency = 1
    line.Visible     = false
    table.insert(tracers, {
        IsLine      = true,
        Outline     = outline,
        Line        = line,
        StartPos    = pos3,
        EndPos      = endPos,
        Lifetime    = tracerDuration,
        FadeTime    = tracerFadeTime,
        CreatedTime = tick(),
    })
end
local function makeBeamTracer(pos3, endPos)
    local a0 = Instance.new("Attachment")
    a0.Parent = workspace.Terrain
    local a1 = Instance.new("Attachment")
    a1.Parent = workspace.Terrain
    local beam          = Instance.new("Beam")
    beam.Attachment0    = a0
    beam.Attachment1    = a1
    beam.Color          = ColorSequence.new(tracerColor)
    local baseW         = tracerStyle == "Laser" and 0.02 or 0.15
    beam.Width0         = baseW * tracerSize
    beam.Width1         = baseW * tracerSize
    beam.Transparency   = NumberSequence.new(0)
    beam.FaceCamera     = true
    beam.LightEmission  = 0.8
    beam.LightInfluence = 0.2
    local tex = textureAssets[tracerStyle]
    if tex and tex ~= "" then
        beam.Texture       = tex
        beam.TextureLength = 4
        beam.TextureSpeed  = 1
    else
        beam.Texture       = ""
        beam.TextureLength = 1
        beam.TextureSpeed  = 0
    end
    beam.Parent = workspace.Terrain
    a0.WorldPosition = pos3
    a1.WorldPosition = endPos
    table.insert(tracers, {
        IsLine      = false,
        Beam        = beam,
        Attachment0 = a0,
        Attachment1 = a1,
        StartPos    = pos3,
        EndPos      = endPos,
        Lifetime    = tracerDuration,
        FadeTime    = tracerFadeTime,
        CreatedTime = tick(),
    })
end
local function maketracer(pos3, endPos)
    if DISABLE_TRACERS or not pos3 or not endPos then return end
    local kx = math.floor(pos3.X * 5 + 0.5)
    local ky = math.floor(pos3.Y * 5 + 0.5)
    local kz = math.floor(pos3.Z * 5 + 0.5)
    local ex = math.floor(endPos.X * 5 + 0.5)
    local ey = math.floor(endPos.Y * 5 + 0.5)
    local ez = math.floor(endPos.Z * 5 + 0.5)
    local posKey = kx * 1e9 + ky * 1e6 + kz * 1e3 + ex + ey * 1e-3 + ez * 1e-6
    local now = tick()
    local last = lastTracerCreations[posKey]
    if last and (now - last) < DEDUPE_INTERVAL then return end
    lastTracerCreations[posKey] = now
    if tracerStyle == "Line" then
        makeLineTracer(pos3, endPos)
    else
        makeBeamTracer(pos3, endPos)
    end
end
local function destroyTracer(t)
    if t.IsLine then
        if t.Outline then t.Outline:Remove() end
        if t.Line    then t.Line:Remove()    end
    else
        if t.Beam        then t.Beam:Destroy()        end
        if t.Attachment0 then t.Attachment0:Destroy() end
        if t.Attachment1 then t.Attachment1:Destroy() end
    end
end
local frameCount       = 0
local DEDUPE_PRUNE_INT = 120
local camera           = workspace.CurrentCamera
local function updtracers()
    if #tracers == 0 then return end
    frameCount = frameCount + 1
    local now   = tick()
    local cam   = camera or workspace.CurrentCamera
    camera      = cam
    local myChar = LocalPlayer.Character
    local myPos  = myChar and myChar:FindFirstChild("HumanoidRootPart")
                   and myChar.HumanoidRootPart.Position
    if frameCount % DEDUPE_PRUNE_INT == 0 then
        for k, t in next, lastTracerCreations do
            if (now - t) > DEDUPE_EXPIRY then
                lastTracerCreations[k] = nil
            end
        end
    end
    local i = #tracers
    while i >= 1 do
        local tr  = tracers[i]
        local age = now - tr.CreatedTime
        if age >= tr.Lifetime then
            destroyTracer(tr)
            tracers[i] = tracers[#tracers]
            tracers[#tracers] = nil
        else
            local fadeAlpha
            local fadeStart = tr.Lifetime - tr.FadeTime
            if age >= fadeStart then
                fadeAlpha = 1 - math.clamp((age - fadeStart) / tr.FadeTime, 0, 1)
            else
                fadeAlpha = 1
            end
            if tr.IsLine then
                local visible = false
                local drawEnd = getTracerDrawEnd(tr, age)
                local camPos = cam and cam.CFrame.Position
                local nearCamera = camPos and (tr.StartPos - camPos).Magnitude <= 12
                if nearCamera or not myPos or (tr.StartPos - myPos).Magnitude > 2 then
                    local s2, onS = worldToScreen(tr.StartPos, cam)
                    local e2, onE = worldToScreen(drawEnd, cam)
                    if onS and onE then
                        local sx, sy = s2.X, s2.Y
                        local ex2, ey = e2.X, e2.Y
                        if sx == sx and sy == sy and ex2 == ex2 and ey == ey
                           and math.abs(sx) < 20000 and math.abs(sy) < 20000
                           and math.abs(ex2) < 20000 and math.abs(ey) < 20000 then
                            local dx = ex2 - sx
                            local dy = ey - sy
                            local len = math.sqrt(dx * dx + dy * dy)
                            if len > 0.1 and len < 3000 then
                                local fv2s = Vector2.new(sx, sy)
                                local fv2e = Vector2.new(ex2, ey)
                                tr.Outline.From = fv2s
                                tr.Outline.To   = fv2e
                                tr.Outline.Transparency = fadeAlpha
                                tr.Outline.Visible = true
                                tr.Line.From = fv2s
                                tr.Line.To   = fv2e
                                tr.Line.Transparency = fadeAlpha
                                tr.Line.Visible = true
                                visible = true
                            end
                        end
                    end
                end
                if not visible then
                    tr.Outline.Visible = false
                    tr.Line.Visible    = false
                end
            else
                local drawEnd = getTracerDrawEnd(tr, age)
                if tr.Attachment0 then
                    tr.Attachment0.WorldPosition = tr.StartPos
                end
                if tr.Attachment1 then
                    tr.Attachment1.WorldPosition = drawEnd
                end
                tr.Beam.Transparency = NumberSequence.new(1 - fadeAlpha)
            end
        end
        i = i - 1
    end
end
local function hookTracerEffect()
    if tracerEffectHooked then return end
    pcall(function()
        local TracerEffect = require(LocalPlayer.PlayerScripts.Modules.TracerEffect)
        local origPlay     = TracerEffect.Play
        TracerEffect.Play = function(self, tracerData, config, extraData)
            if tracerEnabled and tracerData and tracerData.IsLocal and tracerData.RaycastResults then
                local mPos = muzzlepos()
                if mPos then
                    for _, hit in ipairs(tracerData.RaycastResults) do
                        if hit.Position then
                            maketracer(mPos, hit.Position)
                        end
                    end
                end
            end
            return origPlay(self, tracerData, config, extraData)
        end
        tracerEffectHooked = true
    end)
end
local function startTracers()
    if DISABLE_TRACERS then
        tracerEnabled = false
        return
    end
    hookTracerEffect()
    if not tracerconn then
        tracerconn = RunService.RenderStepped:Connect(updtracers)
    end
end
local function stoptracers()
    if tracerconn then
        tracerconn:Disconnect()
        tracerconn = nil
    end
    for _, tr in ipairs(tracers) do
        destroyTracer(tr)
    end
    tracers = {}
end
TracersGroup:AddToggle("TracerEnabled", {
    Text    = "enable",
    Default = true,
    Callback = function(val)
        tracerEnabled = val
        if val then
            startTracers()
        else
            stoptracers()
        end
    end
}):AddColorPicker("TracerColor", {
    Default  = Color3.fromRGB(255, 255, 255),
    Title    = "tracer color",
    Callback = function(val)
        tracerColor = val
        for _, tr in ipairs(tracers) do
            if tr.IsLine then
                if tr.Line then tr.Line.Color = val end
            elseif tr.Beam then
                tr.Beam.Color = ColorSequence.new(val)
            end
        end
    end
})
TracersGroup:AddDropdown("TracerStyle", {
    Text     = "style",
    Default  = "Line",
    Values   = {"Line","Beam","Lightning","Heartrate","Chain","Glitch","Swirl","Neon","Plasma","Laser"},
    Callback = function(val)
        tracerStyle = val
    end
})
TracersGroup:AddSlider("TracerDuration", {
    Text     = "duration",
    Default  = 3,
    Min      = 0.1,
    Max      = 10,
    Rounding = 1,
    Compact  = true,
    Callback = function(val)
        tracerDuration = val
        for _, tr in ipairs(tracers) do tr.Lifetime = val end
    end
})
TracersGroup:AddSlider("TracerSize", {
    Text     = "size",
    Default  = 1,
    Min      = 0.5,
    Max      = 5,
    Rounding = 1,
    Compact  = true,
    Callback = function(val)
        tracerSize = val
        for _, tr in ipairs(tracers) do
            if tr.IsLine then
                if tr.Outline then tr.Outline.Thickness = 4 * val end
                if tr.Line    then tr.Line.Thickness    = 2 * val end
            elseif tr.Beam then
                local baseW = tracerStyle == "Laser" and 0.02 or 0.15
                tr.Beam.Width0 = baseW * val
                tr.Beam.Width1 = baseW * val
            end
        end
    end
})
TracersGroup:AddSlider("TracerFade", {
    Text     = "fade time",
    Default  = 0.5,
    Min      = 0,
    Max      = 2,
    Rounding = 1,
    Compact  = true,
    Callback = function(val)
        tracerFadeTime = val
        for _, tr in ipairs(tracers) do tr.FadeTime = val end
    end
})
TracersGroup:AddSlider("TracerLerpSpeed", {
    Text     = "lerp speed",
    Default  = 0,
    Min      = 0,
    Max      = 5,
    Rounding = 1,
    Compact  = true,
    Callback = function(val)
        tracerLerpSpeed = val
    end
})
task.defer(function()
    startTracers()
    for _ = 1, 30 do
        if tracerEffectHooked then
            break
        end
        hookTracerEffect()
        task.wait(0.5)
    end
end)
end
local function getEspPlayerWeapon(player)
    if not player then return "None" end
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return "None" end
    local playerName = player.Name
    local function weaponFromModelName(modelName)
        local parts = {}
        for part in modelName:gmatch("[^-]+") do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        if #parts >= 2 and parts[1] == playerName then
            return parts[2]
        end
        return nil
    end
    for _, child in ipairs(viewModels:GetChildren()) do
        local w = weaponFromModelName(child.Name)
        if w then return w end
    end
    local fp = viewModels:FindFirstChild("FirstPerson")
    if fp then
        for _, child in ipairs(fp:GetChildren()) do
            local w = weaponFromModelName(child.Name)
            if w then return w end
        end
    end
    return "None"
end
local ragebot = {}
do
local replicatedstorage = cloneref(game:GetService("ReplicatedStorage"))
local players = cloneref(game:GetService("Players"))
local runsvc = cloneref(game:GetService("RunService"))
local userinput = cloneref(game:GetService("UserInputService"))
local workspace = cloneref(game:GetService("Workspace"))
local player = players.LocalPlayer
local camera = workspace.CurrentCamera
local modules = {
    enums = instanceSafeRequire(replicatedstorage.Modules.EnumLibrary),
    fighter = instanceSafeRequire(player.PlayerScripts.Controllers.FighterController),
    camcontrol = instanceSafeRequire(player.PlayerScripts.Controllers.CameraController),
    utility = instanceSafeRequire(replicatedstorage.Modules.Utility)
}
local MATCH_ID_ATTRS = {"MatchId", "DuelId", "RoundId", "GameId", "MatchUUID", "ArenaId", "InstanceId"}
local DUEL_STATE_ATTRS = {"InDuel", "InMatch", "InRound", "InGame", "InFight", "IsInMatch", "IsInDuel", "MatchActive", "Fighting"}
local SPAWN_SAFE_ATTRS = {"InSpawn", "InLobby", "IsSpectating", "InSafeZone", "InIntermission", "IsRespawning"}
local function inLive(targetPlr)
    if not targetPlr then return false end
    local live = workspace:FindFirstChild("Live")
    if not live then return false end
    if live:FindFirstChild(targetPlr.Name) then return true end
    if live:FindFirstChild(tostring(targetPlr.UserId)) then return true end
    for _, child in ipairs(live:GetChildren()) do
        if child.Name == targetPlr.Name or child.Name == tostring(targetPlr.UserId) then
            return true
        end
    end
    local char = targetPlr.Character
    if char and (char.Parent == live or char:IsDescendantOf(live)) then
        return true
    end
    local fc = modules.fighter
    if fc and type(fc.GetFighter) == "function" then
        local ok, fighter = pcall(fc.GetFighter, fc, targetPlr)
        if ok and fighter and fighter.Entity and fighter.Entity.Parent then
            if fighter.Entity.Parent == live or fighter.Entity:IsDescendantOf(live) then
                return true
            end
        end
    end
    return false
end
local function plrMid(targetPlr)
    if not targetPlr then return nil end
    for _, key in ipairs(MATCH_ID_ATTRS) do
        local v = targetPlr:GetAttribute(key)
        if v ~= nil and v ~= "" and v ~= 0 and v ~= false then
            return tostring(v)
        end
    end
    local char = targetPlr.Character
    if char then
        for _, key in ipairs(MATCH_ID_ATTRS) do
            local v = char:GetAttribute(key)
            if v ~= nil and v ~= "" and v ~= 0 and v ~= false then
                return tostring(v)
            end
        end
    end
    return nil
end
local function liveMatch()
    local lp = player
    if not lp then return false end
    for _, key in ipairs(SPAWN_SAFE_ATTRS) do
        local v = lp:GetAttribute(key)
        if v == true or v == 1 or v == "true" then
            return false
        end
    end
    local char = lp.Character
    if not char then return false end
    for _, key in ipairs(SPAWN_SAFE_ATTRS) do
        local cv = char:GetAttribute(key)
        if cv == true or cv == 1 or cv == "true" then
            return false
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not myRoot then return false end
    for _, key in ipairs(DUEL_STATE_ATTRS) do
        local v = lp:GetAttribute(key)
        if v == true or v == 1 or v == "true" then
            return true
        end
        local cv = char:GetAttribute(key)
        if cv == true or cv == 1 or cv == "true" then
            return true
        end
    end
    if inLive(lp) then
        return true
    end
    local fc = modules.fighter
    if fc and fc.LocalFighter and fc.LocalFighter.Entity and fc.LocalFighter.Entity.Parent then
        return true
    end
    local myMatchId = plrMid(lp)
    if myMatchId then
        for _, plr in players:GetPlayers() do
            if plr ~= lp and plrMid(plr) == myMatchId then
                return true
            end
        end
    end
    if fc then
        for _, list in ipairs({ fc.Fighters, fc.AllFighters }) do
            if list then
                for _, f in pairs(list) do
                    if f and f.Player and f.Player ~= lp and (f.IsEnemy or f.Enemy) then
                        local fChar = f.Player.Character
                        local fHum = fChar and fChar:FindFirstChildOfClass("Humanoid")
                        if fHum and fHum.Health > 0 then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
local _instanceLobbyCache = { t = 0, v = true }
local function lobbyCache()
    local now = os.clock()
    if now - _instanceLobbyCache.t < 0.15 then
        return _instanceLobbyCache.v
    end
    _instanceLobbyCache.t = now
    _instanceLobbyCache.v = not liveMatch()
    return _instanceLobbyCache.v
end
getgenv().InstanceIsInActiveMatch = liveMatch
getgenv().InstanceIsInLobby = lobbyCache
local config = {
    target = {
        enabled = false,
        character = nil,
        auto = false,
        autoshoot = true,
        shootAttempts = 1,
        hitpart = "Head",
        lastchar = nil,
        lastplayer = nil,
        manualkey = false,
        immune = false,
        attackPosition = "default",
        attackCustomEnabled = false,
        weaponPick = "primary",
        forceWeapon = true,
        rageMasterOn = false,
        meleeFeetDrop = 3.5,
        underOffset = 4,
        customHeight = 2,
        customFront = 0,
        customSide = 0,
        customVertical = 0,
        customRadius = 0,
    },
    prediction = {
        enabled = false,
        multiplier = 1.2,
        velocity = Vector3.new(0, 0, 0),
        acceleration = Vector3.new(0, 0, 0),
        lastposition = nil,
        lasttime = 0,
        velbuffer = {},
        posbuffer = {},
        maxvelsamples = 15,
        maxpossamples = 5
    },
    orbit = {
        active = false,
        angle = 0,
        serverpos = nil,
        connection = nil,
        speed = 9000,
        height = 1,
        radius = 0,
        originalpos = nil
    },
    state = {
        reloading = false,
        outofammo = false,
        csyncactive = false,
        reloadStartedAt = 0,
    },
    voidhide = {
        enabled = true,
        originalPosition = nil,
        active = false,
        connection = nil
    },
    voidspam = {
        enabled = false,
        shoot_min = 1,
        shoot_max = 1,
        hide_min = 1,
        hide_max = 1,
        phase = nil,
        lastswitch = 0,
        currentduration = 0
    },
    visualizer = {
        enabled = true,
        tracer = {
            color = Color3.fromRGB(0, 186, 255),
            thickness = 1,
            transparency = 1,
            start_point = "cursor",
            outline = true,
            outline_color = Color3.fromRGB(0, 0, 0),
            outline_thickness = 1
        },
        indicator = {
            display_options = {"name", "position", "hit reg"},
            color = Color3.fromRGB(255, 255, 255),
            accent_color = Color3.fromRGB(0, 186, 255)
        }
    },
    hitNotifications = {
        enabled = true,
        color = Color3.fromRGB(235, 235, 235),
        textSize = 14,
        maxVisible = 8,
        duration = 3,
        stackGap = 6,
        position = "Top Left",
        offsetX = 12,
        offsetY = 12,
        inAnimation = "fade bounce",
        outAnimation = "fade",
        animInDuration = 0.52,
        animOutDuration = 0.38,
    },
    ragestatus = {
        enabled = false,
        mode = "static",
        color = Color3.fromRGB(235, 235, 235),
        staticOffsetX = 0,
        staticOffsetY = 40,
        showAmmo = true,
        hideOnReload = true,
        textSize = 15,
        lineGap = 15,
        fontName = "gotham",
    },
}
local ragePerf = {
    lastAttackTick = 0,
    hitPartByPlayer = {},
    lastHitAtByPlayer = {},
    targetHudAt = 0,
    rageStatusAt = 0,
    restoreVisualAt = 0,
    killStartAt = nil,
    rageStatusCacheAt = 0,
    cachedRageStatusLine = "",
    cachedRageStatusDetail = "",
    lastRageStatusText = "",
    lastRageDetailText = "",
    lastRageAmmoText = "",
    lastRageColor = nil,
}
local vhState = {
    active = false,
    hrp = nil,
    mainConnection = nil,
    restoreConnection = nil,
    currentVoidPos = nil,
    lastTeleportTime = 0
}
local localfighter = modules.fighter.LocalFighter
local oldpos
local indicator = Drawing.new("Circle")
indicator.Thickness = 1.5
indicator.NumSides = 36
indicator.Filled = false
indicator.Transparency = 1
indicator.Visible = false
indicator.Radius = 12
indicator.Color = Color3.fromRGB(255, 50, 50)
local indicatoroutline = Drawing.new("Circle")
indicatoroutline.Thickness = 4
indicatoroutline.NumSides = 36
indicatoroutline.Filled = false
indicatoroutline.Transparency = 1
indicatoroutline.Visible = false
indicatoroutline.Radius = 12
indicatoroutline.Color = Color3.fromRGB(0, 0, 0)
local tracerline = Drawing.new("Line")
tracerline.Visible = false
tracerline.Thickness = 2
tracerline.Transparency = 1
tracerline.Color = Color3.fromRGB(0, 186, 255)
local traceroutline = Drawing.new("Line")
traceroutline.Visible = false
traceroutline.Thickness = 4
traceroutline.Transparency = 1
traceroutline.Color = Color3.fromRGB(0, 0, 0)
local lastdamagetime = {}
local function getweapon()
    local viewmodels = workspace:FindFirstChild("ViewModels")
    if not viewmodels then return nil end
    local firstperson = viewmodels:FindFirstChild("FirstPerson")
    if not firstperson then return nil end
    for _, child in ipairs(firstperson:GetChildren()) do
        local parts = {}
        for part in child.Name:gmatch("[^-]+") do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        if #parts >= 2 then
            return parts[2]
        end
    end
    return nil
end
local function muzzlepos()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end
    for _, model in pairs(firstPerson:GetChildren()) do
        if model.Name:find(player.Name) then
            local itemVisual = model:FindFirstChild("ItemVisual")
            if itemVisual then
                local body = itemVisual:FindFirstChild("Body")
                if body then
                    local bodyPrimary = body:FindFirstChild("BodyPrimary")
                    if bodyPrimary then
                        local muzzle = bodyPrimary:FindFirstChild("_muzzle")
                        if muzzle then
                            return muzzle.WorldPosition
                        end
                    end
                end
            end
        end
    end
    return nil
end
local SLOTS = { primary = 1, secondary = 2, melee = 3 }
local MELEE_NMS = {
    ["Battle Axe"] = true, ["Chainsaw"] = true, ["Daggers"] = true, ["Fists"] = true,
    ["Gunblade"] = true, ["Katana"] = true, ["Knife"] = true,
    ["Scythe"] = true, ["Trowel"] = true,
}
local INFINITE_AMMO_WEAPONS = {
    ["Energy Rifle"] = true,
    ["Energy Pistols"] = true,
}
local function isInfiniteWeapon()
    local w = getweapon()
    if not w then return false end
    return INFINITE_AMMO_WEAPONS[w] == true
end
local function wantSlot()
    return SLOTS[config.target.weaponPick or "primary"] or 1
end
local function pickMelee()
    return (config.target.weaponPick or "primary") == "melee"
end
local function getammo()
    if isInfiniteWeapon() then return nil, nil, false end
    local success, controller = pcall(function()
        return instanceSafeRequire(player.PlayerScripts.Controllers.FighterController)
    end)
    if success and controller and controller.LocalFighter and controller.LocalFighter.EquippedItem then
        local item = controller.LocalFighter.EquippedItem
        local itemName, current, maxAmmo = "", 0, 0
        local isMelee = false
        local ok = pcall(function()
            itemName = tostring(item:Get("Name") or item.Name or "")
            current = item:Get("CurrentAmmo") or item:Get("Ammo") or 0
            maxAmmo = item:Get("MaxAmmo") or item:Get("MaxBullets") or current
            if type(itemName) == "string" and itemName:lower():find("melee", 1, true) then
                isMelee = true
            end
            if MELEE_NMS[itemName] then isMelee = true end
        end)
        if not ok then
            return 0, 0, pickMelee()
        end
        if pickMelee() then isMelee = true end
        return tonumber(current) or 0, tonumber(maxAmmo) or 0, isMelee
    end
    return 0, 0, pickMelee()
end
local function meleeNm(nm)
    if type(nm) ~= "string" or nm == "" then return false end
    if nm:lower():find("melee", 1, true) then return true end
    return MELEE_NMS[nm] == true
end
local function itemMelee(item)
    if not item then return false end
    local nm = item:Get("Name") or item.Name
    if meleeNm(nm) then return true end
    local t = item:Get("ItemType") or item:Get("Type") or item:Get("Category")
    return type(t) == "string" and t:lower():find("melee", 1, true) ~= nil
end
local function isSling(weapon)
    return weapon and weapon:lower():find("slingshot", 1, true) ~= nil
end
local function lfItems()
    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf then return nil end
    return lf.Items
end
local function slotItem(slotIdx)
    local items = lfItems()
    if not items then return nil end
    if items[slotIdx] then return items[slotIdx] end
    if items[tostring(slotIdx)] then return items[tostring(slotIdx)] end
    for key, it in pairs(items) do
        if it and typeof(it) == "table" then
            local s = tonumber(it:Get("Slot") or it:Get("Index") or it:Get("ItemSlot") or key)
            if s == slotIdx then return it end
            local t = it:Get("ItemType") or it:Get("Type")
            if slotIdx == 3 and (t == "Melee" or (type(t) == "string" and t:lower():find("melee", 1, true))) then
                return it
            end
            if slotIdx == 1 and (t == "Primary" or t == 1 or t == "1") then return it end
            if slotIdx == 2 and (t == "Secondary" or t == 2 or t == "2") then return it end
        end
    end
    local ordered = {}
    for _, it in pairs(items) do
        if it then ordered[#ordered + 1] = it end
    end
    table.sort(ordered, function(a, b)
        local sa = tonumber(a:Get("Slot") or a:Get("Index")) or 99
        local sb = tonumber(b:Get("Slot") or b:Get("Index")) or 99
        return sa < sb
    end)
    return ordered[slotIdx]
end
local function whichSlot(item)
    if not item then return nil end
    local items = lfItems()
    local oid = item:Get("ObjectID")
    if items and oid then
        for idx = 1, 3 do
            local it = items[idx] or items[tostring(idx)]
            if it and it:Get("ObjectID") == oid then return idx end
        end
        for key, it in pairs(items) do
            if it and it:Get("ObjectID") == oid then
                local n = tonumber(key)
                if n and n >= 1 and n <= 3 then return n end
            end
        end
    end
    if itemMelee(item) then return 3 end
    return nil
end
local rageLastSlotForce = 0
local function pressSlot(slotIdx)
    if IS_MOBILE then
        return
    end
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local kc = ({ Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three })[slotIdx]
        if not kc then return end
        vim:SendKeyEvent(true, kc, false, game)
        task.wait(0.02)
        vim:SendKeyEvent(false, kc, false, game)
    end)
    if keypress then
        pcall(keypress, ({ 0x31, 0x32, 0x33 })[slotIdx])
        task.wait(0.02)
        if keyrelease then pcall(keyrelease, ({ 0x31, 0x32, 0x33 })[slotIdx]) end
    end
end
local function rageOn()
    if Toggles and Toggles.TargetOn then
        return Toggles.TargetOn.Value == true
    end
    return config.target.rageMasterOn == true
end
local function eqSlot()
    if not rageOn() then return end
    local want = wantSlot()
    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf then return end
    local eq = lf.EquippedItem
    if eq and whichSlot(eq) == want then return end
    local now = tick()
    if now - rageLastSlotForce < 0.06 then return end
    rageLastSlotForce = now
    local item = slotItem(want)
    local oid = item and item:Get("ObjectID")
    if oid then
        local rm = replicatedstorage.Remotes.Replication.Fighter.UseItem
        for _, en in ipairs({ "Equip", "Switch", "Select", "EquipItem", "ChangeItem" }) do
            pcall(function()
                local ev = modules.enums:ToEnum(en)
                if ev then rm:FireServer(oid, ev, nil, nil) end
            end)
        end
    end
    pcall(function()
        if lf.EquipItem then lf:EquipItem(want) end
        if lf.Equip then lf:Equip(want) end
        if lf.SwitchToSlot then lf:SwitchToSlot(want) end
    end)
    pcall(function()
        local fc = modules.fighter
        if fc.EquipItem then fc:EquipItem(want) end
        if fc.SwitchItem then fc:SwitchItem(want) end
    end)
    if not IS_MOBILE then
        pressSlot(want)
    end
end
local function itemReload()
    if isInfiniteWeapon() then return false end
    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf or not lf.EquippedItem then return false end
    local result = false
    pcall(function()
        local item = lf.EquippedItem
        for _, key in ipairs({ "Reloading", "IsReloading", "IsReload" }) do
            local value = item:Get(key)
            if value == true or value == 1 or value == "true" then
                result = true
                return
            end
        end
    end)
    if result then return true end
    local started = config.state.reloadStartedAt or 0
    return started > 0 and (tick() - started) < 1.75
end
local function tickAmmo()
    if isInfiniteWeapon() then
        config.state.outofammo = false
        config.state.reloading = false
        config.state.reloadStartedAt = 0
        return
    end
    local current, maxAmmo, melee = getammo()
    local wasOutOfAmmo = config.state.outofammo
    if melee then
        config.state.outofammo = false
    else
        config.state.outofammo = (tonumber(current) or 0) <= 0
    end
    local reloading = itemReload()
    if reloading and not config.state.reloading then
        config.state.reloadStartedAt = tick()
    elseif not reloading then
        config.state.reloadStartedAt = 0
    end
    config.state.reloading = reloading
    if config.state.outofammo and not wasOutOfAmmo then
        if isSling(getweapon()) then
            config.voidspam.phase = "hide"
        end
    elseif not config.state.outofammo and wasOutOfAmmo then
        if config.voidspam.enabled then
            config.voidspam.phase = "shoot"
            config.voidspam.lastswitch = tick()
        else
            config.voidspam.phase = nil
        end
    end
end
local function reloadHide(sling)
    if not (config.state.reloading and config.ragestatus.hideOnReload) then
        return false
    end
    local hrp = voidHrp()
    if hrp and not sling then
        snapVoid(hrp)
        return true
    end
    local randomX = math.random(-10000, 10000)
    local randomZ = math.random(-10000, 10000)
    config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
    if sling and localfighter and localfighter.Entity and localfighter.Entity.RootPart then
        pcall(function()
            localfighter.Entity.RootPart.CFrame = CFrame.new(config.orbit.serverpos)
        end)
    end
    return true
end
local function isteammate(targetplayer)
    if not targetplayer then return false end
    return player:GetAttribute("TeamID") == targetplayer:GetAttribute("TeamID")
end
local function valid(char)
    if not char or not char.Parent then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not char:FindFirstChild("HumanoidRootPart") then return false end
    local targetplayer = players:GetPlayerFromCharacter(char)
    if not targetplayer or isteammate(targetplayer) then return false end
    return true
end
local function nearest()
    local cursorpos
    if IS_MOBILE then
        if MOBILE_TOUCH_STATE.touching then
            cursorpos = MOBILE_TOUCH_STATE.touchCurrentPos
        else
            local cam = workspace.CurrentCamera
            if cam then
                cursorpos = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            else
                cursorpos = Vector2.zero
            end
        end
    else
        cursorpos = userinput:GetMouseLocation()
    end
    local besttarget = nil
    local bestdistance = math.huge
    for _, targetplayer in players:GetPlayers() do
        if targetplayer ~= player and targetplayer.Character then
            local char = targetplayer.Character
            if valid(char) then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local wts = getgenv().InstanceWorldToScreen or worldToScreen
                    local screenpos, onscreen = wts(root.Position, camera)
                    if onscreen and screenpos then
                        local distance = (Vector2.new(screenpos.X, screenpos.Y) - cursorpos).Magnitude
                        if distance < bestdistance then
                            besttarget = char
                            bestdistance = distance
                        end
                    end
                end
            end
        end
    end
    return besttarget
end
local function hitpartfromname(character, partname)
    if not character then return nil end
    if partname == "Closest" then
        local mypos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not mypos then return character:FindFirstChild("Head") end
        local closest, dist = nil, math.huge
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local d = (part.Position - mypos.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = part
                end
            end
        end
        return closest or character:FindFirstChild("Head")
    elseif partname == "Random" then
        local parts = {"Head", "HumanoidRootPart", "UpperTorso"}
        return character:FindFirstChild(parts[math.random(#parts)]) or character:FindFirstChild("Head")
    else
        return character:FindFirstChild(partname) or character:FindFirstChild("Head")
    end
end
local function updatevel()
    if not config.target.character or not config.prediction.enabled then
        config.prediction.velocity = Vector3.new(0, 0, 0)
        config.prediction.lastposition = nil
        return
    end
    local root = config.target.character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local now = tick()
    local dt = now - config.prediction.lasttime
    if dt > 0 and dt < 0.1 then
        local currentpos = root.Position
        if config.prediction.lastposition then
            local instantvel = (currentpos - config.prediction.lastposition) / dt
            config.prediction.velocity = config.prediction.velocity:Lerp(instantvel, 0.6)
        end
        config.prediction.lastposition = currentpos
        config.prediction.lasttime = now
    end
end
local function predict(targetpart, origin)
    if not config.prediction.enabled or not targetpart then
        return targetpart and targetpart.Position or Vector3.new()
    end
    local basepos = targetpart.Position
    local distance = (basepos - origin).Magnitude
    local ping = 0
    pcall(function()
        ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    local traveltime = distance / 3000
    local totaltime = (traveltime + ping) * config.prediction.multiplier
    return basepos + (config.prediction.velocity * totaltime)
end
local function canuse()
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if isInfiniteWeapon() then return true end
    local current, _, melee = getammo()
    if current == nil then return true end
    return current > 0 or melee
end
local function clampVs(v)
    return math.clamp(tonumber(v) or 1, 0.1, 2)
end
local function randVs(minT, maxT)
    local a = clampVs(minT)
    local b = clampVs(maxT)
    if b < a then
        a, b = b, a
    end
    if a == b then
        return a
    end
    return a + math.random() * (b - a)
end
local vfrLim, vfrDead = 2147483646, 1147483646
local vfrSnap = { cf = nil, lv = nil, av = nil }
local function clrVoidSnap()
    vfrSnap.cf, vfrSnap.lv, vfrSnap.av = nil, nil, nil
end
local function voidHrp()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function rndSkip(mi, ma, dmi, dma)
    local val = math.random(mi, ma)
    while val >= dmi and val <= dma do
        val = math.random(mi, ma)
    end
    return val
end
local function snapVoid(hrp)
    if not hrp then return end
    if lobbyCache() then return end
    vfrSnap.cf = hrp.CFrame
    vfrSnap.lv = hrp.AssemblyLinearVelocity
    vfrSnap.av = hrp.AssemblyAngularVelocity
    local lim, dead = vfrLim, vfrDead
    pcall(function()
        local p = Vector3.new(rndSkip(-lim, lim, -dead, dead), rndSkip(-lim, lim, -dead, dead), rndSkip(-lim, lim, -dead, dead))
        local v = Vector3.new(rndSkip(-lim, lim, -dead, dead), rndSkip(-lim, lim, -dead, dead), rndSkip(-lim, lim, -dead, dead))
        hrp.CFrame = CFrame.new(p) * CFrame.Angles(math.pi, math.pi, math.pi)
        hrp.AssemblyLinearVelocity = v
        hrp.AssemblyAngularVelocity = v
    end)
end
runsvc:BindToRenderStep("vfr_csync", Enum.RenderPriority.First.Value, function()
    if not vfrSnap.cf then return end
    local hrp = voidHrp()
    if not hrp then return end
    pcall(function()
        hrp.CFrame = vfrSnap.cf
        hrp.AssemblyLinearVelocity = vfrSnap.lv
        hrp.AssemblyAngularVelocity = vfrSnap.av
    end)
end)
local function atkCfg()
    if pickMelee() and not config.target.attackCustomEnabled then
        local drop = tonumber(config.target.meleeFeetDrop) or 3.5
        return {
            height = 0,
            front = 0,
            side = 0,
            vertical = -drop,
            radius = 0,
        }
    end
    if config.target.attackCustomEnabled then
        return {
            height = config.target.customHeight or 2,
            front = config.target.customFront or 0,
            side = config.target.customSide or 0,
            vertical = config.target.customVertical or 0,
            radius = config.target.customRadius or 0,
        }
    end
    local mode = config.target.attackPosition or "default"
    local weapon = getweapon()
    if mode == "under" then
        return {
            height = 0,
            front = 0,
            side = 0,
            vertical = -(config.target.underOffset or 4),
            radius = 0,
        }
    end
    return {
        height = (weapon and weapon:lower():find("sniper")) and 8 or 2,
        front = 0,
        side = 0,
        vertical = 0,
        radius = 0,
    }
end
local function setOrbH(weapon)
    local settings = atkCfg()
    config.orbit.height = settings.height
end
local function orbBase(root)
    if not root then
        return Vector3.zero
    end
    local settings = atkCfg()
    local pos = root.Position
    local look = root.CFrame.LookVector
    local right = root.CFrame.RightVector
    return pos
        + (look * settings.front)
        + (right * settings.side)
        + Vector3.new(0, settings.vertical, 0)
end
local function setOrbR()
    local settings = atkCfg()
    config.orbit.radius = settings.radius or 0
end
local function refreshAtk()
    setOrbH(getweapon())
    setOrbR()
end
local function stopsync()
    if not config.state.csyncactive then return end
    if config.orbit.connection then
        config.orbit.connection:Disconnect()
        config.orbit.connection = nil
    end
    config.state.csyncactive = false
    config.orbit.active = false
    clrVoidSnap()
    config.voidspam.phase = nil
    if config.orbit.savedpos and localfighter and localfighter.Entity and localfighter.Entity.RootPart and not getgenv().InstanceUndergroundEnabled then
        local ok, pos = pcall(function() return config.orbit.savedpos end)
        if ok and pos then
            local currentPos = localfighter.Entity.RootPart.CFrame
            local distance = (currentPos.Position - pos.Position).Magnitude
            pcall(function()
                localfighter.Entity.RootPart.CFrame = pos
            end)
        end
    end
    config.orbit.serverpos = nil
    config.orbit.savedpos = nil
    config.voidspam.phase = nil
    oldpos = nil
end
local function isHidingPhase()
    return config.voidspam.enabled and config.voidspam.phase == "hide"
end
local function tickVoidSpam()
    if not config.voidspam.enabled then return end
    local now = tick()
    local elapsed = now - config.voidspam.lastswitch
    if config.voidspam.phase == "shoot" then
        if elapsed >= config.voidspam.currentduration then
            config.voidspam.phase = "hide"
            config.voidspam.currentduration = randVs(config.voidspam.hide_min, config.voidspam.hide_max)
            config.voidspam.lastswitch = now
        end
    elseif config.voidspam.phase == "hide" then
        if elapsed >= config.voidspam.currentduration then
            config.voidspam.phase = "shoot"
            config.voidspam.currentduration = randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
            config.voidspam.lastswitch = now
        end
    else
        config.voidspam.phase = "shoot"
        config.voidspam.currentduration = randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
        config.voidspam.lastswitch = now
    end
end
local function voidOk(sling)
    if not sling then return false end
    return config.voidspam.enabled or config.state.outofammo
end
local function tickVoid(sling, root)
    if sling then
        clrVoidSnap()
        return false
    end
    if not voidOk(sling) then
        clrVoidSnap()
        return false
    end
    local isHiding = config.state.outofammo or (config.voidspam.enabled and config.voidspam.phase == "hide")
    if isHiding then
        if config.voidspam.enabled and config.voidspam.phase == "hide" and not config.state.outofammo then
            local elapsed = tick() - config.voidspam.lastswitch
            if elapsed >= config.voidspam.currentduration then
                config.voidspam.phase = "shoot"
                config.voidspam.currentduration = randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
                config.voidspam.lastswitch = tick()
                clrVoidSnap()
                return false
            end
        end
        clrVoidSnap()
        local hrp = voidHrp()
        if hrp then
            snapVoid(hrp)
        else
            if config.state.csyncactive then
                return true
            end
            local randomX = math.random(-10000, 10000)
            local randomZ = math.random(-10000, 10000)
            config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
        end
        return true
    end
    if config.voidspam.enabled and config.voidspam.phase == "shoot" then
        local elapsed = tick() - config.voidspam.lastswitch
        if elapsed >= config.voidspam.currentduration then
            config.voidspam.phase = "hide"
            config.voidspam.currentduration = randVs(config.voidspam.hide_min, config.voidspam.hide_max)
            config.voidspam.lastswitch = tick()
        end
    end
    clrVoidSnap()
    return false
end
local function hideShot()
    if not config.voidspam.enabled then return end
    if isSling(getweapon()) then return end
end
local function voidhide()
    if vhState.active then return end
    vhState.active = true
    if not config.state.csyncactive then
        startsync()
    end
end
local stopvoid = function()
    vhState.active = false
    vhState.currentVoidPos = nil
    if vhState.mainConnection then
        vhState.mainConnection:Disconnect()
        vhState.mainConnection = nil
    end
end
local function startsync()
    if config.state.csyncactive then return end
    if config.target.immune then return end
    if not config.target.character or not valid(config.target.character) then return end
    eqSlot()
    config.state.csyncactive = true
    config.orbit.active = true
    local weapon = getweapon()
    setOrbH(weapon)
    setOrbR()
    if not config.orbit.savedpos then
        if localfighter and localfighter.Entity and localfighter.Entity.RootPart then
            config.orbit.savedpos = localfighter.Entity.RootPart.CFrame
        end
    end
    config.orbit.connection = runsvc.Heartbeat:Connect(function(dt)
        if not config.state.csyncactive then return end
        if config.target.immune then stopsync() return end
        if not config.target.character or not valid(config.target.character) then stopsync() return end
        if not localfighter or not localfighter.Entity or not localfighter.Entity.RootPart then stopsync() return end
        if config.target.immune then stopsync() return end
        setOrbR()
        oldpos = localfighter.Entity.RootPart.CFrame
        local function isQuickSwapActive()
            if pickMelee() then return false end
            local lf = modules.fighter and modules.fighter.LocalFighter
            if not lf or not lf.EquippedItem then return false end
            local name = tostring(lf.EquippedItem:Get("Name") or ""):lower()
            return name:find("fist", 1, true) or name:find("utility", 1, true)
        end
        local _weapon = getweapon()
        local checksling = isSling(_weapon)
        if isQuickSwapActive() then return end
        eqSlot()
        if reloadHide(checksling) then return end
        if not checksling and config.voidspam.enabled and not config.target.immune then
            tickVoidSpam()
            if config.voidspam.phase == "hide" then
                local randomX = math.random(-10000, 10000)
                local randomZ = math.random(-10000, 10000)
                config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
                pcall(function()
                    localfighter.Entity.RootPart.CFrame = CFrame.new(config.orbit.serverpos)
                end)
                return
            end
        end
        if not config.target.character then stopsync() return end
        local root = config.target.character:FindFirstChild("HumanoidRootPart")
        if not root then stopsync() return end
        if not checksling and isHidingPhase() then
            local randomX = math.random(-10000, 10000)
            local randomZ = math.random(-10000, 10000)
            config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
            pcall(function()
                localfighter.Entity.RootPart.CFrame = CFrame.new(config.orbit.serverpos)
            end)
            return
        end
        if checksling then
            if vhState and vhState.active then
                local trg = config.target.character:FindFirstChild("HumanoidRootPart")
                if trg then
                    local flat = Vector3.new(trg.CFrame.LookVector.X, 0, trg.CFrame.LookVector.Z).Unit
                    config.orbit.serverpos = trg.Position + Vector3.new(0, 15, 0) + (flat * 5)
                end
            end
        end
        if config.state.outofammo and not checksling and _weapon and not isInfiniteWeapon() then
            local hrp = voidHrp()
            if hrp then
                snapVoid(hrp)
            else
                local randomX = math.random(-10000, 10000)
                local randomZ = math.random(-10000, 10000)
                config.orbit.serverpos = Vector3.new(randomX, -99999999999, randomZ)
                pcall(function()
                    localfighter.Entity.RootPart.CFrame = CFrame.new(config.orbit.serverpos)
                end)
            end
            return
        end
        local targetpos = orbBase(root)
        config.orbit.angle = config.orbit.angle + (config.orbit.speed * dt)
        local offset = Vector3.new(
            math.cos(config.orbit.angle) * config.orbit.radius,
            config.orbit.height,
            math.sin(config.orbit.angle) * config.orbit.radius
        )
        config.orbit.serverpos = targetpos + offset
        if not getgenv().InstanceUndergroundEnabled then
            if localfighter and localfighter.Entity and localfighter.Entity.RootPart then
                local currentPos = localfighter.Entity.RootPart.CFrame
                local newPos = CFrame.new(config.orbit.serverpos)
                local distance = (newPos.Position - currentPos.Position).Magnitude
                if distance < 2000 then
                    localfighter.Entity.RootPart.CFrame = newPos
                    config.orbit.savedpos = currentPos
                end
            end
        end
    end)
end
local function autoshoot()
    if not isSling(getweapon()) and config.voidspam.enabled and config.voidspam.phase == "hide" then return end
    if not config.target.enabled or not config.target.character or not config.target.autoshoot then return end
    if config.target.immune then return end
    if not isSling(getweapon()) and config.voidspam.enabled and config.voidspam.phase == "hide" then return end
    if config.voidspam.enabled and config.voidspam.phase == "hide" then return end
    local weapon = getweapon()
    local checksling = isSling(weapon)
    eqSlot()
    local lf = modules.fighter and modules.fighter.LocalFighter
    if not lf or not lf.EquippedItem then return end
    if not isInfiniteWeapon() then
        if config.state.reloading or config.state.outofammo then return end
        if not canuse() then return end
    end
    local targetChar = config.target.character
    if not valid(targetChar) then return end
    local hitPart = hitpartfromname(targetChar, config.target.hitpart)
    if not hitPart then return end
    local shootPos
    local targetPos
    if vhState and vhState.active and checksling then
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		shootPos = root and root.Position or Vector3.new()
		targetPos = predict(hitPart, shootPos)
	else
        if vhState and vhState.active then
			local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			shootPos = myRoot and myRoot.Position or Vector3.new()
        elseif config.state.csyncactive and config.orbit.serverpos then
            shootPos = config.orbit.serverpos
        else
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            shootPos = root and root.Position or Vector3.new()
        end
        targetPos = predict(hitPart, shootPos)
    end
    local data = {
        [utf8.char(1)] = {
            [utf8.char(0)] = modules.utility:EncodeCFrame(CFrame.new(shootPos, targetPos)),
            [utf8.char(1)] = modules.utility:EncodeCFrame(CFrame.new(shootPos, targetPos)),
            [utf8.char(2)] = hitPart,
            [utf8.char(3)] = modules.utility:EncodeCFrame(CFrame.new(0.43, 0.25, 0.42)),
        },
    }
    local equipped = lf.EquippedItem
    if equipped and equipped:Get("ObjectID") then
        ragePerf.lastAttackTick = tick()
        local attempts = math.clamp(math.floor(tonumber(config.target.shootAttempts) or 1), 1, 3)
        for _ = 1, attempts do
            pcall(function()
                replicatedstorage.Remotes.Replication.Fighter.UseItem:FireServer(
                    equipped:Get("ObjectID"),
                    modules.enums:ToEnum("StartShooting"),
                    data,
                    nil
                )
            end)
        end
        hideShot()
    end
end
local oldcamupdate = modules.camcontrol.Update
modules.camcontrol.Update = function(...)
    if getgenv().InstanceUndergroundEnabled then
        return oldcamupdate(...)
    elseif config.state.csyncactive and localfighter and localfighter.Entity and localfighter.Entity.RootPart and oldpos then
        localfighter.Entity.RootPart.CFrame = oldpos
    end
    return oldcamupdate(...)
end
local immuneList = {}
local onImmune = {}
local onVulnerable = {}
local function bindimmune(callback)
    table.insert(onImmune, callback)
end
local function bindvulnerable(callback)
    table.insert(onVulnerable, callback)
end
runsvc.Heartbeat:Connect(function()
    for _, plr in pairs(players:GetPlayers()) do
        if plr == player then continue end
        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local immune = root and root:FindFirstChild("Attachment") ~= nil
        if immune and not immuneList[plr.Name] then
            immuneList[plr.Name] = true
            for _, cb in pairs(onImmune) do cb(plr) end
        elseif not immune and immuneList[plr.Name] then
            immuneList[plr.Name] = nil
            for _, cb in pairs(onVulnerable) do cb(plr) end
        end
    end
end)
bindimmune(function(plr)
    if config.target.lastplayer == plr then
        config.target.immune = true
        config.voidspam.phase = nil
        clrVoidSnap()
        indicator.Color = Color3.fromRGB(180, 0, 255)
        stopsync()
    end
end)
bindvulnerable(function(plr)
    if config.target.lastplayer == plr then
        config.target.immune = false
        indicator.Color = Color3.fromRGB(255, 50, 50)
        if config.target.enabled and config.target.character and valid(config.target.character) then
            startsync()
        end
    end
end)
local function cleartarget()
    config.target.enabled = false
    stopsync()
    config.target.character = nil
    config.target.lastchar = nil
    config.target.lastplayer = nil
    config.target.manualkey = false
    config.target.immune = false
    indicator.Color = Color3.fromRGB(255, 50, 50)
end
local function settarget(char)
    if not char then return end
    local targetplr = players:GetPlayerFromCharacter(char)
    config.target.enabled = true
    config.target.character = char
    config.target.lastchar = char
    config.target.lastplayer = targetplr
    config.target.immune = false
    indicator.Color = Color3.fromRGB(255, 50, 50)
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("Attachment") then
        config.target.immune = true
        indicator.Color = Color3.fromRGB(180, 0, 255)
    else
        eqSlot()
        startsync()
    end
end
local sling = {
    enabled = false,
    connections = {}
}
local function checksling()
    return isSling(getweapon())
end
local function nearplr()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local found, best = nil, math.huge
    for _, p in ipairs(players:GetPlayers()) do
        if p == player or not p.Character then continue end
        local head = p.Character:FindFirstChild("HitboxHead") or p.Character:FindFirstChild("Head")
        if not head then continue end
        local d = (head.Position - root.Position).Magnitude
        if d < best then
            found = head
            best = d
        end
    end
    return found
end
local function slingshotTP()
    if sling.connections.touch then return end
    sling.connections.touch = workspace.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") or d:IsA("Model") then
            if d.Name == "Slingshot" or d.Name == "CoreProjectile" or d.Name == "OuterProjectile" then
                task.spawn(function()
					task.wait(0.06)
					local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
					if not part then return end
					part.CanTouch = true
					for i = 1, 60 do
						if not part.Parent or not part:IsDescendantOf(workspace) then break end
						local target = nearplr()
						if target and target:IsA("BasePart")
							and target.Parent
							and target:IsDescendantOf(workspace)
						then
							pcall(firetouchinterest, target, part, 0)
							pcall(firetouchinterest, target, part, 1)
						end
						task.wait()
					end
				end)
            end
        end
    end)
end
local function stopslingTP()
    if sling.connections.touch then
        sling.connections.touch:Disconnect()
        sling.connections.touch = nil
    end
end
local function targetpos()
    if not config.target.character then return nil end
    local root = config.target.character:FindFirstChild("HumanoidRootPart")
    return root and root.Position
end
local function updatesling()
    local slingon = checksling()
    local hastarget = config.target.enabled and config.target.character ~= nil
    if slingon then
        if not sling.enabled then
            sling.enabled = true
            slingshotTP()
        end
        if getgenv().InstanceSetUnderground then
            getgenv().InstanceSetUnderground(true)
        end
        vhState.active = hastarget
        if hastarget and not config.state.csyncactive then
            startsync()
        elseif not hastarget and config.state.csyncactive and not config.target.enabled then
            stopsync()
        end
    else
        if sling.enabled then
            sling.enabled = false
            stopslingTP()
        end
        if not Toggles.AntiAimUnderground.Value then
            if getgenv().InstanceSetUnderground then
                getgenv().InstanceSetUnderground(false)
            end
        end
        vhState.active = false
    end
end
local function fflag()
    local hastarget = config.target.enabled and config.target.character and valid(config.target.character)
    local slingon = checksling()
    if hastarget and slingon then
        pcall(function()
            setfflag("TargetTimeDelayFacctorTenths", "999999")
        end)
    else
        pcall(function()
            setfflag("TargetTimeDelayFacctorTenths", "1")
        end)
    end
end
local targetHudAnimLast = tick()
runsvc.RenderStepped:Connect(function()
    local inLobby = getgenv().InstanceIsInLobby and getgenv().InstanceIsInLobby()
    local hudNeeded = config.visualizer.enabled
        or (config.ragestatus and config.ragestatus.enabled)
        or (config.hitNotifications and config.hitNotifications.enabled)
        or (config.target.enabled and config.target.character and config.prediction.enabled)
    if inLobby and not hudNeeded then
        return
    end
    if shouldSuppressGameplayOverlays() then
        tracerline.Visible = false
        traceroutline.Visible = false
        if ragebot.hideRageStatus then
            ragebot.hideRageStatus()
        end
        if ragebot.updateHitNotifications then
            ragebot.updateHitNotifications(0)
        end
        return
    end
    local now = tick()
    local hudDt = math.clamp(now - targetHudAnimLast, 0, 0.05)
    targetHudAnimLast = now
    if config.ragestatus and config.ragestatus.enabled and ragebot.drawStatus then
        ragebot.drawStatus()
    elseif ragebot.hideRageStatus then
        ragebot.hideRageStatus()
    end
    if ragebot.updateHitNotifications then
        ragebot.updateHitNotifications(hudDt)
    end
    if config.target.enabled and config.target.character and config.prediction.enabled then
        updatevel()
    end
end)
runsvc.Heartbeat:Connect(function()
    fflag()
    updatesling()
    tickAmmo()
    if config.target.auto and not config.target.manualkey then
        local current, _, melee = getammo()
        local hasammo = current == nil or current > 0 or melee
        if hasammo and not config.state.reloading then
            if not config.target.enabled or not config.target.character or not valid(config.target.character) then
                local newtarget = nearest()
                if newtarget then
                    if config.target.enabled then stopsync() end
                    settarget(newtarget)
                end
            end
        end
    end
    if config.target.enabled and config.target.character then
        if not valid(config.target.character) then
            cleartarget()
            return
        end
        eqSlot()
        if config.target.autoshoot and not config.target.immune then
            autoshoot()
        end
    end
end)
ragebot.config = config
ragebot.nearest = nearest
ragebot.settarget = settarget
ragebot.cleartarget = cleartarget
ragebot.stopvoid = stopvoid
ragebot.vhState = vhState
ragebot.ragePerf = ragePerf
ragebot.getammo = getammo
ragebot.muzzlepos = muzzlepos
ragebot.valid = valid
ragebot.player = player
ragebot.eqSlot = eqSlot
ragebot.refreshAtk = refreshAtk
do
local config = ragebot.config
local ragePerf = ragebot.ragePerf
local getammo = ragebot.getammo
local muzzlepos = ragebot.muzzlepos
local valid = ragebot.valid
local player = ragebot.player
local vhState = ragebot.vhState
local camera = workspace.CurrentCamera
local function mkStatusLbl()
    local label = getgenv().InstanceTrackDrawingText(Drawing.new("Text"))
    label.Size = 13
    label.Font = 2
    label.Outline = true
    label.Center = true
    label.Visible = false
    label.Color = config.ragestatus.color
    pcall(function()
        label.OutlineColor = Color3.fromRGB(0, 0, 0)
    end)
    return label
end
local rageStatusLine1 = mkStatusLbl()
local rageStatusLine2 = mkStatusLbl()
local function styleStatusLbl(label)
    label.Size = 13
    label.Font = 2
    label.Outline = true
    label.Color = config.ragestatus.color
    pcall(function()
        label.OutlineColor = Color3.fromRGB(0, 0, 0)
    end)
end
local function statusAnchor()
    if config.ragestatus.mode == "muzzle" then
        local mp = muzzlepos and muzzlepos()
        if mp then
            local wts = getgenv().InstanceWorldToScreen or worldToScreen
            local screenPos, onScreen = wts(mp, camera)
            if onScreen and screenPos then
                return Vector2.new(screenPos.X, screenPos.Y)
            end
        end
    end
    local cam = camera or workspace.CurrentCamera
    if not cam then
        return Vector2.zero
    end
    return (cam.ViewportSize / 2) + Vector2.new(
        config.ragestatus.staticOffsetX or 0,
        config.ragestatus.staticOffsetY or 0
    )
end
local function rageActive()
    return config.target.enabled or config.target.auto or config.voidspam.enabled
end
local function killNm()
    if config.target.lastplayer then
        return config.target.lastplayer.Name
    end
    if config.target.character then
        local tp = game:GetService("Players"):GetPlayerFromCharacter(config.target.character)
        if tp then
            return tp.Name
        end
    end
    return "target"
end
local function inVoid()
    if vhState.active then return true end
    if config.voidspam.enabled and config.voidspam.phase == "hide" and isSling(getweapon()) then
        return true
    end
    if config.state.reloading and config.ragestatus.hideOnReload ~= false then
        return true
    end
    return false
end
local function isKilling()
    if not rageActive() then
        return false
    end
    if config.state.reloading or inVoid() then
        return false
    end
    if config.target.immune then
        return false
    end
    if not config.target.enabled or not config.target.character or not valid(config.target.character) then
        return false
    end
    if config.state.csyncactive then
        return true
    end
    if config.voidspam.enabled and config.voidspam.phase == "shoot" and isSling(getweapon()) then
        return true
    end
    if tick() - (ragePerf.lastAttackTick or 0) < 0.45 then
        return true
    end
    return false
end
local function hudAmmo()
    if isInfiniteWeapon() then return "∞" end
    local cur, maxAmmo, melee = getammo()
    if cur == nil then return "∞" end
    if melee then return "melee" end
    return string.format("%d/%d", math.floor(cur or 0), math.max(math.floor(maxAmmo or 0), 0))
end
local function fmtVsTime(minT, maxT)
    local a = clampVs(minT)
    local b = clampVs(maxT)
    if b < a then
        a, b = b, a
    end
    if math.abs(a - b) < 0.05 then
        return string.format("%.1fs", a)
    end
    return string.format("%.1f-%.1fs", a, b)
end
local function vsDetail()
    if not config.voidspam.enabled then
        return ""
    end
    local vs = config.voidspam
    return string.format(
        "void %s atk · %s hide",
        fmtVsTime(vs.shoot_min, vs.shoot_max),
        fmtVsTime(vs.hide_min, vs.hide_max)
    )
end
local function rageLines()
    local now = tick()
    if isKilling() then
        if not ragePerf.killStartAt then
            ragePerf.killStartAt = now
        end
    else
        ragePerf.killStartAt = nil
    end
    if config.state.reloading then
        return "ragebot: void hide", "reloading"
    end
    if inVoid() then
        local det = vsDetail()
        return "ragebot: void hide", det ~= "" and det or ""
    end
    if isKilling() then
        local name = killNm()
        local elapsed = now - (ragePerf.killStartAt or now)
        local hum = config.target.character and config.target.character:FindFirstChildOfClass("Humanoid")
        local main = string.format("ragebot : attacking (%s) · %.1fs", name, elapsed)
        local detailParts = {}
        local hpBit = hum and string.format("%.0f hp", hum.Health) or "hp ?"
        detailParts[#detailParts + 1] = hpBit
        local voidDetail = vsDetail()
        if voidDetail ~= "" then
            detailParts[#detailParts + 1] = voidDetail
        end
        return main, table.concat(detailParts, " · ")
    end
    if rageActive() and config.target.enabled and config.target.character then
        local hum = config.target.character:FindFirstChildOfClass("Humanoid")
        local hpBit = hum and string.format("%.0f hp", hum.Health) or "locked"
        return "ragebot: ready", hpBit
    end
    return "ragebot: idle", ""
end
local function drawStatus()
    if not config.ragestatus.enabled or shouldSuppressGameplayOverlays() then
        rageStatusLine1.Visible = false
        rageStatusLine2.Visible = false
        return
    end
    local anchor = statusAnchor()
    local gap = config.ragestatus.lineGap or 14
    local showAmmo = config.ragestatus.showAmmo ~= false
    if ragePerf.lastRageColor ~= config.ragestatus.color then
        ragePerf.lastRageColor = config.ragestatus.color
        styleStatusLbl(rageStatusLine1)
        styleStatusLbl(rageStatusLine2)
    end
    local mainLine, detailLine = rageLines()
    local ammoLine = showAmmo and hudAmmo() or ""
    local line2Text = detailLine
    if line2Text ~= "" and ammoLine ~= "" then
        line2Text = line2Text .. " · " .. ammoLine
    elseif line2Text == "" then
        line2Text = ammoLine
    end
    local lineCount = 1 + (line2Text ~= "" and 1 or 0)
    local topOffset = -(lineCount - 1) * (gap / 2)
    if mainLine ~= ragePerf.lastRageStatusText then
        ragePerf.lastRageStatusText = mainLine
        rageStatusLine1.Text = mainLine
    end
    rageStatusLine1.Position = anchor + Vector2.new(0, topOffset)
    rageStatusLine1.Visible = config.ragestatus.enabled
    local nextY = topOffset + gap
    if line2Text ~= "" then
        if line2Text ~= ragePerf.lastRageDetailText then
            ragePerf.lastRageDetailText = line2Text
            rageStatusLine2.Text = line2Text
        end
        rageStatusLine2.Position = anchor + Vector2.new(0, nextY)
        rageStatusLine2.Visible = config.ragestatus.enabled
    else
        ragePerf.lastRageDetailText = ""
        rageStatusLine2.Visible = false
    end
end
ragebot.drawStatus = drawStatus
ragebot.hideRageStatus = function()
    rageStatusLine1.Visible = false
    rageStatusLine2.Visible = false
end
ragebot.clrVoidSnap = clrVoidSnap
end
do
local config = ragebot.config
local nearest = ragebot.nearest
local settarget = ragebot.settarget
local cleartarget = ragebot.cleartarget
local stopvoid = ragebot.stopvoid
local function togglekey()
    if config.target.auto then return end
    if config.target.enabled and config.target.character then
        cleartarget()
    else
        local target = nearest()
        if target then
            config.target.manualkey = true
            settarget(target)
        end
    end
end
local rageui = {
    targetgroup = Tabs.Combat:AddRightTabbox()
}
rageui.ragebottab = rageui.targetgroup:AddTab('Ragebot')
rageui.ragebotvisualtab = rageui.targetgroup:AddTab('Visualizer')
rageui.ragebottab:AddToggle("TargetOn", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        config.target.rageMasterOn = val
        if config.target.auto then return end
        if val then
            local target = nearest()
            if target then
                config.target.manualkey = true
                settarget(target)
            end
        else
            cleartarget()
        end
    end
}):AddKeyPicker("TargetKey", {
    Text = "Ragebot",
    Default = "None",
    Mode = "Toggle",
    Callback = function() togglekey() end
})
rageui.ragebottab:AddToggle("AutoTarget", {
    Text = "Auto Target",
    Default = false,
    Callback = function(val) config.target.auto = val end
})
local attackUnderVisGate = { Type = "Toggle", Value = false }
local attackCustomVisGate = { Type = "Toggle", Value = false }
local function syncAtkDeps()
    local mode = config.target.attackPosition or "default"
    local custom = config.target.attackCustomEnabled == true
    attackUnderVisGate.Value = (mode == "under" and not custom)
    attackCustomVisGate.Value = custom
    if attackUnderDep and attackUnderDep.Update then
        attackUnderDep:Update()
    end
    if attackCustomDep and attackCustomDep.Update then
        attackCustomDep:Update()
    end
end
local attackPosDropdown = rageui.ragebottab:AddDropdown("AutoTargetAttackPos", {
    Text = "attack position",
    Default = "default",
    Values = { "default", "under" },
    Callback = function(val)
        config.target.attackPosition = val
        syncAtkDeps()
        if config.state.csyncactive and ragebot.refreshAtk then
            ragebot.refreshAtk()
        end
    end,
})
rageui.ragebottab:AddToggle("AttackCustomOverride", {
    Text = "attack position",
    Default = false,
    Tooltip = "overrides attack position dropdown when enabled",
    Callback = function(val)
        config.target.attackCustomEnabled = val
        syncAtkDeps()
        if config.state.csyncactive and ragebot.refreshAtk then
            ragebot.refreshAtk()
        end
    end,
})
local attackUnderDep = rageui.ragebottab:AddDependencyBox()
attackUnderDep:AddSlider("UnderAttackOffset", {
    Text = "Under Offset",
    Default = config.target.underOffset,
    Min = 1,
    Max = 25,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        config.target.underOffset = val
        if config.target.attackPosition == "under"
            and not config.target.attackCustomEnabled
            and config.state.csyncactive
            and ragebot.refreshAtk then
            ragebot.refreshAtk()
        end
    end,
})
attackUnderDep:SetupDependencies({
    { attackUnderVisGate, true },
})
local attackCustomDep = rageui.ragebottab:AddDependencyBox()
local function onAtkCustom()
    if config.target.attackCustomEnabled and config.state.csyncactive and ragebot.refreshAtk then
        ragebot.refreshAtk()
    end
end
attackCustomDep:AddSlider("CustomAttackHeight", {
    Text = "Orbit Height",
    Default = config.target.customHeight,
    Min = -25,
    Max = 30,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        config.target.customHeight = val
        onAtkCustom()
    end,
})
attackCustomDep:AddSlider("CustomAttackFront", {
    Text = "Front Offset",
    Default = config.target.customFront,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        config.target.customFront = val
        onAtkCustom()
    end,
})
attackCustomDep:AddSlider("CustomAttackSide", {
    Text = "Side Offset",
    Default = config.target.customSide,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        config.target.customSide = val
        onAtkCustom()
    end,
})
attackCustomDep:AddSlider("CustomAttackVertical", {
    Text = "Vertical Offset",
    Default = config.target.customVertical,
    Min = -25,
    Max = 30,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        config.target.customVertical = val
        onAtkCustom()
    end,
})
attackCustomDep:AddSlider("CustomAttackRadius", {
    Text = "Orbit Radius",
    Default = config.target.customRadius,
    Min = 0,
    Max = 25,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        config.target.customRadius = val
        onAtkCustom()
    end,
})
attackCustomDep:SetupDependencies({
    { attackCustomVisGate, true },
})
syncAtkDeps()
task.defer(syncAtkDeps)
rageui.ragebottab:AddDropdown("RageWeaponPick", {
    Text = "Weapon",
    Default = config.target.weaponPick or "primary",
    Values = { "primary", "secondary", "melee" },
    Callback = function(val)
        config.target.weaponPick = val
        if config.state.csyncactive and ragebot.refreshAtk then
            ragebot.refreshAtk()
        end
        if ragebot.eqSlot then
            ragebot.eqSlot()
        end
    end,
})
rageui.ragebottab:AddSlider("ShootAttempts", {
    Text = "Shoot Attempts",
    Default = 1,
    Min = 1,
    Max = 3,
    Rounding = 0,
    Suffix = "x",
    Callback = function(val)
        config.target.shootAttempts = math.clamp(math.floor(tonumber(val) or 1), 1, 3)
    end,
})
rageui.ragebottab:AddDropdown("TargetPart", {
    Text = "Hit Part",
    Default = "Head",
    Values = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "Closest", "Random"},
    Callback = function(val) config.target.hitpart = val end
})
rageui.ragebottab:AddToggle("PredictT", {
    Text = "Prediction",
    Default = false,
    Callback = function(val) config.prediction.enabled = val end
})
rageui.ragebottab:AddSlider("PredictMul", {
    Text = "Prediction Mult",
    Default = 1.2,
    Min = 0.1,
    Max = 3.0,
    Rounding = 1,
    Callback = function(val) config.prediction.multiplier = val end
})
rageui.ragebottab:AddToggle("VoidSpam", {
    Text = "Voidspam",
    Default = false,
    Callback = function(val)
        config.voidspam.enabled = val
        if val then
            if config.target.immune then
                config.voidspam.phase = nil
                return
            end
            if isSling(getweapon()) then
                config.voidspam.lastswitch = tick()
                config.voidspam.phase = "shoot"
                config.voidspam.currentduration = randVs(config.voidspam.shoot_min, config.voidspam.shoot_max)
            else
                config.voidspam.phase = nil
            end
        else
            config.voidspam.phase = nil
            if ragebot.clrVoidSnap then
                ragebot.clrVoidSnap()
            end
        end
    end
})
rageui.ragebottab:AddSlider('VoidShootTime', {
    Default = 1,
    Text = "Attack",
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        val = clampVs(val)
        config.voidspam.shoot_min = val
        config.voidspam.shoot_max = val
    end
})
rageui.ragebottab:AddSlider('VoidHideTime', {
    Default = 1,
    Text = "Hide",
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Compact = true,
    Callback = function(val)
        val = clampVs(val)
        config.voidspam.hide_min = val
        config.voidspam.hide_max = val
    end
})
local rageStatusToggle = rageui.ragebotvisualtab:AddToggle("RageStatus", {
    Text = "Rage Status",
    Default = config.ragestatus.enabled,
    Callback = function(val)
        config.ragestatus.enabled = val
        if val then
            if ragebot.drawStatus then
                ragebot.drawStatus()
            end
        else
            if ragebot.hideRageStatus then
                ragebot.hideRageStatus()
            end
        end
    end,
}):AddColorPicker("RageStatusColor", {
    Title = "text color",
    Default = config.ragestatus.color,
    Callback = function(val)
        config.ragestatus.color = val
        if ragebot.ragePerf then
            ragebot.ragePerf.lastRageColor = nil
        end
    end,
})
local rageStatusDep = rageui.ragebotvisualtab:AddDependencyBox()
rageStatusDep:SetupDependencies({
    { rageStatusToggle, true },
})
rageStatusDep:AddDropdown("RageStatusMode", {
    Text = "Position",
    Default = "static",
    Values = { "static", "muzzle" },
    Callback = function(val)
        config.ragestatus.mode = val
    end,
})
rageStatusDep:AddSlider("RageStatusStaticX", {
    Text = "Static X",
    Default = config.ragestatus.staticOffsetX,
    Min = -500,
    Max = 500,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        config.ragestatus.staticOffsetX = val
    end,
})
rageStatusDep:AddSlider("RageStatusStaticY", {
    Text = "Static Y",
    Default = config.ragestatus.staticOffsetY,
    Min = -500,
    Max = 500,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        config.ragestatus.staticOffsetY = val
    end,
})
rageStatusDep:AddToggle("RageStatusAmmo", {
    Text = "Show Ammo Line",
    Default = true,
    Callback = function(val)
        config.ragestatus.showAmmo = val
    end,
})
rageStatusDep:AddToggle("RageStatusReloadHide", {
    Text = "Hide While Reloading",
    Default = true,
    Callback = function(val)
        config.ragestatus.hideOnReload = val
    end,
})
rageui.ragebotvisualtab:AddToggle("VisEnabled", {
    Text = "Enable",
    Default = false,
    Callback = function(val) config.visualizer.enabled = val end
})
rageui.ragebotvisualtab:AddToggle("VisTracerEnabled", {
    Text = "Tracer",
    Default = false,
    Callback = function(val) config.visualizer.tracer.enabled = val end
}):AddColorPicker("VisTracerColor", {
    Default = config.visualizer.tracer.color,
    Callback = function(val) config.visualizer.tracer.color = val end
})
rageui.ragebotvisualtab:AddDropdown("VisTracerStart", {
    Text = "Tracer Start",
    Default = "cursor",
    Values = {"cursor", "muzzle"},
    Callback = function(val) config.visualizer.tracer.start_point = val end
})
rageui.ragebotvisualtab:AddToggle("VisTracerOutline", {
    Text = "Tracer Outline",
    Default = true,
    Callback = function(val) config.visualizer.tracer.outline = val end
})
rageui.ragebotvisualtab:AddSlider("VisTracerThickness", {
    Text = "Tracer Thickness",
    Default = 1,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Callback = function(val) config.visualizer.tracer.thickness = val end
})
end
end
do
local config = ragebot.config
local ragePerf = ragebot.ragePerf
local isRageEnabled = ragebot.isRageEnabled
local players = cloneref(game:GetService("Players"))
local player = players.LocalPlayer
local TextService = game:GetService("TextService")
local UserInputService = cloneref(game:GetService("UserInputService"))
local hitNotifEntries = {}
local hitNotifHpTrack = {}
local hitNotifHumConn = {}
local hitNotifCharConn = {}
local hitNotifResolveQueues = {}
local hitNotifResolveBusy = {}
local HIT_NOTIF_ANIM_STYLES = {
    "fade",
    "slide left",
    "slide right",
    "slide down",
    "bounce",
    "fade bounce",
    "scale",
}
local HIT_NOTIF_STACK_WIDTH = 300
local hitNotifRoot = Library:Create("Frame", {
    Name = "HitNotifications",
    BackgroundTransparency = 1,
    Size = UDim2.new(0, HIT_NOTIF_STACK_WIDTH, 1, -24),
    Position = UDim2.fromOffset(12, 12),
    ZIndex = 250,
    Parent = Library.ScreenGui,
})
local function getHitNotifScreenPosition()
    local hn = config.hitNotifications
    local preset = hn.position or "Top Left"
    if preset == "Custom" then
        return Vector2.new(hn.offsetX or 12, hn.offsetY or 12)
    end
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local margin = 12
    local stackH = 280
    local centerX = vp.X * 0.5 - HIT_NOTIF_STACK_WIDTH * 0.5
    local presets = {
        ["Top Left"] = Vector2.new(margin, margin),
        ["Top Center"] = Vector2.new(centerX, margin),
        ["Top Right"] = Vector2.new(vp.X - HIT_NOTIF_STACK_WIDTH - margin, margin),
        ["Center Left"] = Vector2.new(margin, vp.Y * 0.5 - stackH * 0.5),
        ["Center"] = Vector2.new(centerX, vp.Y * 0.5 - stackH * 0.5),
        ["Center Right"] = Vector2.new(vp.X - HIT_NOTIF_STACK_WIDTH - margin, vp.Y * 0.5 - stackH * 0.5),
        ["Bottom Left"] = Vector2.new(margin, vp.Y - stackH - margin),
        ["Bottom Center"] = Vector2.new(centerX, vp.Y - stackH - margin),
        ["Bottom Right"] = Vector2.new(vp.X - HIT_NOTIF_STACK_WIDTH - margin, vp.Y - stackH - margin),
    }
    return presets[preset] or presets["Top Left"]
end
local function applyHitNotifRootPosition()
    local pos = getHitNotifScreenPosition()
    hitNotifRoot.Position = UDim2.fromOffset(math.floor(pos.X), math.floor(pos.Y))
end
local function hnEaseOutCubic(t)
    return 1 - (1 - t) ^ 3
end
local function hnEaseInCubic(t)
    return t * t * t
end
local function hnEaseOutBack(t)
    local c1 = 1.70158
    return 1 + (c1 + 1) * (t - 1) ^ 3 + c1 * (t - 1) ^ 2
end
local HIT_NOTIF_IN_SAMPLERS = {}
local HIT_NOTIF_OUT_SAMPLERS = {}
HIT_NOTIF_IN_SAMPLERS.fade = function(t)
    return hnEaseOutCubic(t), 0, 0, 1
end
HIT_NOTIF_IN_SAMPLERS["slide left"] = function(t)
    local e = hnEaseOutCubic(t)
    return e, (1 - e) * -52, 0, 1
end
HIT_NOTIF_IN_SAMPLERS["slide right"] = function(t)
    local e = hnEaseOutCubic(t)
    return e, (1 - e) * 52, 0, 1
end
HIT_NOTIF_IN_SAMPLERS["slide down"] = function(t)
    local e = hnEaseOutCubic(t)
    return e, 0, (1 - e) * -32, 1
end
HIT_NOTIF_IN_SAMPLERS.bounce = function(t)
    return math.clamp(t * 6, 0, 1), 0, 0, hnEaseOutBack(t)
end
HIT_NOTIF_IN_SAMPLERS["fade bounce"] = function(t)
    return hnEaseOutCubic(t), 0, 0, 0.78 + hnEaseOutBack(t) * 0.28
end
HIT_NOTIF_IN_SAMPLERS.scale = function(t)
    local e = hnEaseOutCubic(t)
    return e, 0, 0, 0.62 + e * 0.38
end
HIT_NOTIF_OUT_SAMPLERS.fade = function(t)
    local e = hnEaseInCubic(t)
    return 1 - e, 0, 0, 1
end
HIT_NOTIF_OUT_SAMPLERS["slide left"] = function(t)
    local e = hnEaseInCubic(t)
    return 1 - e, e * -52, 0, 1
end
HIT_NOTIF_OUT_SAMPLERS["slide right"] = function(t)
    local e = hnEaseInCubic(t)
    return 1 - e, e * 52, 0, 1
end
HIT_NOTIF_OUT_SAMPLERS["slide down"] = function(t)
    local e = hnEaseInCubic(t)
    return 1 - e, 0, e * 32, 1
end
HIT_NOTIF_OUT_SAMPLERS.bounce = function(t)
    local e = hnEaseInCubic(t)
    return 1 - e, 0, 0, 1 - e * 0.1 + math.sin(t * math.pi) * 0.09 * (1 - e)
end
HIT_NOTIF_OUT_SAMPLERS["fade bounce"] = function(t)
    local e = hnEaseInCubic(t)
    return 1 - e, 0, 0, 1 - e * 0.08 + math.sin(t * math.pi * 1.5) * 0.07 * (1 - t)
end
HIT_NOTIF_OUT_SAMPLERS.scale = function(t)
    local e = hnEaseInCubic(t)
    return 1 - e, 0, 0, 1 - e * 0.4
end
local function sampleHitNotifAnim(style, t, isOut)
    t = math.clamp(t, 0, 1)
    local map = isOut and HIT_NOTIF_OUT_SAMPLERS or HIT_NOTIF_IN_SAMPLERS
    local fn = map[string.lower(style or "fade")] or map.fade
    local a, ox, oy, sc = fn(t)
    return math.clamp(a, 0, 1), ox, oy, math.clamp(sc, 0.01, 1.35)
end
local function applyHitNotifVisual(entry, alpha, ox, oy, scale)
    local tr = 1 - math.clamp(alpha, 0, 1)
    entry.outer.BackgroundTransparency = tr
    entry.inner.BackgroundTransparency = tr
    entry.label.TextTransparency = tr
    if entry.uiScale then
        entry.uiScale.Scale = scale
    end
    local y = (entry.displayY or entry.targetY or 0) + oy
    entry.outer.Position = UDim2.fromOffset(math.floor(ox + 0.5), math.floor(y + 0.5))
end
local function measureHitNotifBox(text, textSize)
    local bounds = TextService:GetTextSize(text, textSize, Enum.Font.Code, Vector2.new(1000, 40))
    return math.clamp(bounds.X + 20, 200, 540), math.max(bounds.Y + 12, 26)
end
local function removeHitNotifEntry(index)
    local entry = hitNotifEntries[index]
    if entry and entry.outer then
        pcall(function()
            entry.outer:Destroy()
        end)
    end
    table.remove(hitNotifEntries, index)
end
local function formatHitNotifLine(targetName, dmg, bodyPart)
    return string.format(
        "hit %s for %d in the %s",
        targetName,
        math.floor(dmg + 0.5),
        bodyPart or "Body"
    )
end
local function createHitNotifBox(text)
    local hn = config.hitNotifications
    local textSize = hn.textSize or 14
    local boxW, boxH = measureHitNotifBox(text, textSize)
    local outer = Library:Create("Frame", {
        Name = "HitNotifOuter",
        BackgroundColor3 = Library.MainColor,
        BorderColor3 = Library.OutlineColor,
        BorderMode = Enum.BorderMode.Inset,
        Size = UDim2.fromOffset(boxW, boxH),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ZIndex = 251,
        Parent = hitNotifRoot,
    })
    Library:AddToRegistry(outer, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "OutlineColor",
    }, true)
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.75
    uiScale.Parent = outer
    local inner = Library:Create("Frame", {
        Name = "HitNotifInner",
        BackgroundColor3 = Library.BackgroundColor,
        BorderColor3 = Library.OutlineColor,
        BorderMode = Enum.BorderMode.Inset,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundTransparency = 1,
        ZIndex = 252,
        Parent = outer,
    })
    Library:AddToRegistry(inner, {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
    }, true)
    local label = Library:CreateLabel({
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.fromOffset(6, 0),
        Text = text,
        Font = Enum.Font.Code,
        TextSize = textSize,
        TextColor3 = hn.color or Library.FontColor,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 254,
        Parent = inner,
    }, false)
    return {
        outer = outer,
        inner = inner,
        label = label,
        uiScale = uiScale,
        boxW = boxW,
        boxH = boxH,
    }
end
local function pushHitNotification(targetName, dmg, bodyPart)
    if not config.hitNotifications.enabled or dmg <= 0 then
        return
    end
    local hn = config.hitNotifications
    local now = tick()
    applyHitNotifRootPosition()
    hitNotifRoot.Visible = true
    local parts = createHitNotifBox(formatHitNotifLine(targetName, dmg, bodyPart))
    table.insert(hitNotifEntries, 1, {
        outer = parts.outer,
        inner = parts.inner,
        label = parts.label,
        uiScale = parts.uiScale,
        boxW = parts.boxW,
        boxH = parts.boxH,
        start = now,
        phaseStart = now,
        phase = "in",
        duration = hn.duration or 3,
        targetY = 0,
        displayY = 0,
    })
    while #hitNotifEntries > math.clamp(hn.maxVisible or 8, 1, 25) do
        removeHitNotifEntry(#hitNotifEntries)
    end
end
local function getPlayerFromHitPart(hitPart)
    if not hitPart then
        return nil, nil, nil
    end
    local char = hitPart:FindFirstAncestorOfClass("Model")
    if not char and hitPart.Parent and hitPart.Parent:IsA("Model") then
        char = hitPart.Parent
    end
    if not char then
        return nil, nil, nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local plr = players:GetPlayerFromCharacter(char)
    return plr, hum, hitPart.Name
end
local function shouldNotifyPlayerHit(plr)
    if not config.hitNotifications.enabled or plr == player then
        return false
    end
    local lastShot = getgenv().InstanceCombatLastShotAt or 0
    if tick() - lastShot < 4 then
        return true
    end
    if config.target.lastplayer == plr then
        return true
    end
    if config.target.enabled and config.target.character then
        local tp = players:GetPlayerFromCharacter(config.target.character)
        if tp == plr then
            return true
        end
    end
    local lastHit = ragePerf.lastHitAtByPlayer[plr]
    return lastHit ~= nil and tick() - lastHit < 4
end
local function tryClaimHitDamage(plr, hum, bodyPart, allowFallback)
    if not hum or not hum.Parent then
        return false
    end
    local last = hitNotifHpTrack[plr]
    if last == nil then
        last = hum.Health
        hitNotifHpTrack[plr] = last
    end
    local cur = hum.Health
    local dmg = last - cur
    if dmg >= 0.01 then
        pushHitNotification(plr.Name, dmg, bodyPart or ragePerf.hitPartByPlayer[plr] or config.target.hitpart or "Body")
        hitNotifHpTrack[plr] = cur
        ragePerf.lastHitAtByPlayer[plr] = tick()
        return true
    end
    if allowFallback then
        pushHitNotification(plr.Name, 1, bodyPart or ragePerf.hitPartByPlayer[plr] or config.target.hitpart or "Body")
        ragePerf.lastHitAtByPlayer[plr] = tick()
        return true
    end
    return false
end
local function resolveQueuedHitNotif(plr, job)
    local hum = job.hum
    local bodyPart = job.bodyPart
    if not hum or not hum.Parent then
        return
    end
    if tryClaimHitDamage(plr, hum, bodyPart, false) then
        return
    end
    for _ = 1, 15 do
        task.wait(0)
        if tryClaimHitDamage(plr, hum, bodyPart, false) then
            return
        end
    end
    for _ = 1, 8 do
        task.wait(0.03)
        if tryClaimHitDamage(plr, hum, bodyPart, false) then
            return
        end
    end
    tryClaimHitDamage(plr, hum, bodyPart, true)
end
local function enqueueHitNotifResolve(plr, hum, bodyPart)
    hitNotifResolveQueues[plr] = hitNotifResolveQueues[plr] or {}
    table.insert(hitNotifResolveQueues[plr], {
        hum = hum,
        bodyPart = bodyPart,
        queuedAt = tick(),
    })
    if hitNotifResolveBusy[plr] then
        return
    end
    hitNotifResolveBusy[plr] = true
    task.spawn(function()
        while hitNotifResolveQueues[plr] and #hitNotifResolveQueues[plr] > 0 do
            local job = table.remove(hitNotifResolveQueues[plr], 1)
            resolveQueuedHitNotif(plr, job)
        end
        hitNotifResolveBusy[plr] = false
    end)
end
local function pollHitNotifHealth()
    if not config.hitNotifications.enabled then
        return
    end
    for _, plr in ipairs(players:GetPlayers()) do
        if plr == player then
            continue
        end
        if not shouldNotifyPlayerHit(plr) then
            continue
        end
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if not hum then
            continue
        end
        local last = hitNotifHpTrack[plr]
        if last == nil then
            hitNotifHpTrack[plr] = hum.Health
            continue
        end
        local cur = hum.Health
        if cur < last - 0.01 then
            local bodyPart = ragePerf.hitPartByPlayer[plr] or config.target.hitpart or "Body"
            pushHitNotification(plr.Name, last - cur, bodyPart)
            hitNotifHpTrack[plr] = cur
            ragePerf.lastHitAtByPlayer[plr] = tick()
            if cur <= 0 then
                local tryKill = getgenv().InstanceTryKillSound
                if tryKill then
                    tryKill(plr, last, cur)
                end
            end
        elseif cur > last then
            hitNotifHpTrack[plr] = cur
        end
    end
end
local function recordLocalHitTarget(plr, hum, bodyPart)
    if not plr or not hum or plr == player then
        return
    end
    localHitTargets[hum] = {
        plr = plr,
        bodyPart = bodyPart,
        hitAt = tick(),
        lastHp = hum.Health,
    }
end
local function notifyProjectileImpact(hitPart)
    if not hitPart then
        return
    end
    local plr, hum, bodyPart = getPlayerFromHitPart(hitPart)
    if not plr or not hum or plr == player then
        return
    end
    ragePerf.hitPartByPlayer[plr] = bodyPart
    ragePerf.lastHitAtByPlayer[plr] = tick()
    recordLocalHitTarget(plr, hum, bodyPart)
    if not config.hitNotifications.enabled then
        return
    end
    if not shouldNotifyPlayerHit(plr) then
        return
    end
    enqueueHitNotifResolve(plr, hum, bodyPart)
end
ragebot.notifyProjectileImpact = notifyProjectileImpact
local function onTargetHealthChanged(plr, newHp)
    if not config.hitNotifications.enabled then
        return
    end
    if hitNotifHpTrack[plr] == nil then
        hitNotifHpTrack[plr] = newHp
        return
    end
    if newHp > (hitNotifHpTrack[plr] or newHp) then
        hitNotifHpTrack[plr] = newHp
    end
end
local function unbindHitNotifPlayer(plr)
    if hitNotifHumConn[plr] then
        hitNotifHumConn[plr]:Disconnect()
        hitNotifHumConn[plr] = nil
    end
    if hitNotifCharConn[plr] then
        hitNotifCharConn[plr]:Disconnect()
        hitNotifCharConn[plr] = nil
    end
    hitNotifHpTrack[plr] = nil
    hitNotifResolveQueues[plr] = nil
    hitNotifResolveBusy[plr] = nil
end
local function bindHitNotifCharacter(plr, char)
    if plr == player or not char then
        return
    end
    if hitNotifHumConn[plr] then
        hitNotifHumConn[plr]:Disconnect()
        hitNotifHumConn[plr] = nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 8)
    if not hum then
        return
    end
    hitNotifHpTrack[plr] = hum.Health
    hitNotifHumConn[plr] = hum.HealthChanged:Connect(function(newHp)
        local localHit = localHitTargets and localHitTargets[hum]
        if newHp <= 0 and localHit and localHit.plr and localHit.plr ~= player and not config.hitNotifications.enabled then
            local tryKill2 = getgenv().InstanceTryKillSound
            if tryKill2 then
                tryKill2(localHit.plr, hitNotifHpTrack[plr] or 0, newHp)
            end
            if localHitTargets then
                localHitTargets[hum] = nil
            end
        end
        if not config.hitNotifications.enabled then
            local last = hitNotifHpTrack[plr]
            if last == nil or newHp > last then
                hitNotifHpTrack[plr] = newHp
            end
            return
        end
        local last = hitNotifHpTrack[plr]
        if last == nil then
            hitNotifHpTrack[plr] = newHp
            return
        end
        if newHp < last - 0.01 then
            if shouldNotifyPlayerHit(plr) then
                local bodyPart = ragePerf.hitPartByPlayer[plr] or config.target.hitpart or "Body"
                pushHitNotification(plr.Name, last - newHp, bodyPart)
                ragePerf.lastHitAtByPlayer[plr] = tick()
            end
            if newHp <= 0 then
                local tryKill = getgenv().InstanceTryKillSound
                if tryKill then
                    tryKill(plr, last, newHp)
                end
            end
            hitNotifHpTrack[plr] = newHp
        elseif newHp > last then
            hitNotifHpTrack[plr] = newHp
        end
    end)
    hum.Died:Connect(function()
        local last = hitNotifHpTrack[plr]
        local tryKill = getgenv().InstanceTryKillSound
        if tryKill and last and last > 0 then
            tryKill(plr, last, 0)
        end
        local localHit = localHitTargets and localHitTargets[hum]
        if localHit then
            if not config.hitNotifications.enabled then
                local tryKill2 = getgenv().InstanceTryKillSound
                if tryKill2 and localHit.plr and localHit.plr ~= player then
                    tryKill2(localHit.plr, last or 0, 0)
                end
            end
            if localHitTargets then
                localHitTargets[hum] = nil
            end
        end
    end)
end
local function bindHitNotifPlayer(plr)
    if plr == player then
        return
    end
    if hitNotifCharConn[plr] then
        hitNotifCharConn[plr]:Disconnect()
    end
    hitNotifCharConn[plr] = plr.CharacterAdded:Connect(function(char)
        bindHitNotifCharacter(plr, char)
    end)
    if plr.Character then
        bindHitNotifCharacter(plr, plr.Character)
    end
end
players.PlayerAdded:Connect(bindHitNotifPlayer)
players.PlayerRemoving:Connect(unbindHitNotifPlayer)
for _, plr in players:GetPlayers() do
    bindHitNotifPlayer(plr)
end
local function updateHitNotifications(dt)
    local hn = config.hitNotifications
    if not hn.enabled or shouldSuppressGameplayOverlays() then
        hitNotifRoot.Visible = false
        if not hn.enabled then
            for i = #hitNotifEntries, 1, -1 do
                removeHitNotifEntry(i)
            end
        end
        return
    end
    pollHitNotifHealth()
    hitNotifRoot.Visible = #hitNotifEntries > 0
    applyHitNotifRootPosition()
    dt = dt or 0
    local now = tick()
    local inDur = math.clamp(hn.animInDuration or 0.52, 0.15, 2)
    local outDur = math.clamp(hn.animOutDuration or 0.38, 0.15, 2)
    local totalDur = hn.duration or 3
    local gap = hn.stackGap or 6
    local inStyle = hn.inAnimation or "fade bounce"
    local outStyle = hn.outAnimation or "fade"
    local y = 0
    for _, entry in ipairs(hitNotifEntries) do
        entry.targetY = y
        entry.displayY = entry.displayY or y
        if dt > 0 then
            entry.displayY = entry.displayY + (entry.targetY - entry.displayY) * (1 - math.exp(-dt * 14))
        else
            entry.displayY = entry.targetY
        end
        y = y + (entry.boxH or 26) + gap
    end
    local i = 1
    while i <= #hitNotifEntries do
        local entry = hitNotifEntries[i]
        local age = now - entry.start
        if entry.phase == "in" then
            local t = (now - entry.phaseStart) / inDur
            if t >= 1 then
                entry.phase = "hold"
                entry.phaseStart = now
                t = 1
            end
            local a, ox, oy, sc = sampleHitNotifAnim(inStyle, t, false)
            applyHitNotifVisual(entry, a, ox, oy, sc)
        elseif entry.phase == "hold" then
            applyHitNotifVisual(entry, 1, 0, 0, 1)
            if age >= totalDur - outDur then
                entry.phase = "out"
                entry.phaseStart = now
            end
        elseif entry.phase == "out" then
            local t = (now - entry.phaseStart) / outDur
            if t >= 1 then
                removeHitNotifEntry(i)
                continue
            end
            local a, ox, oy, sc = sampleHitNotifAnim(outStyle, t, true)
            applyHitNotifVisual(entry, a, ox, oy, sc)
        else
            entry.phase = "in"
            entry.phaseStart = now
        end
        i = i + 1
    end
end
ragebot.updateHitNotifications = updateHitNotifications
ragebot.clearHitNotifications = function()
    for i = #hitNotifEntries, 1, -1 do
        removeHitNotifEntry(i)
    end
    if hitNotifRoot then
        hitNotifRoot.Visible = false
    end
end
ragebot.hitNotifAnimStyles = HIT_NOTIF_ANIM_STYLES
ragebot.applyHitNotifRootPosition = applyHitNotifRootPosition
end
local frame = Tabs.Character:AddRightGroupbox('Profile')
if not config then config = {} end
if not config.profile then
    config.profile = {
        level = { enabled = false, value = 9999 },
        winstreak = { enabled = false, value = 9999 }
    }
end
frame:AddToggle("LevelSpoof", {
    Text = "Level",
    Default = false,
    Callback = function(val)
        config.profile.level.enabled = val
    end
})
frame:AddInput("LevelValue", {
    Text = "Level",
    Default = "9999",
    Numeric = true,
    Finished = false,
    Placeholder = "9999",
    Callback = function(val)
        if config and config.profile and config.profile.level then
            config.profile.level.value = tonumber(val) or 9999
        end
    end
})
frame:AddToggle("WinStreakSpoof", {
    Text = "Win Streak",
    Default = false,
    Callback = function(val)
        config.profile.winstreak.enabled = val
    end
})
frame:AddInput("WinStreakValue", {
    Text = "Win Streak",
    Default = "9999",
    Numeric = true,
    Finished = false,
    Placeholder = "9999",
    Callback = function(val)
        if config and config.profile and config.profile.winstreak then
            config.profile.winstreak.value = tonumber(val) or 9999
        end
    end
})
task.spawn(function()
    while true do
        local player = game:GetService("Players").LocalPlayer
        if config and config.profile and config.profile.level and config.profile.level.enabled then
            player:SetAttribute("Level", config.profile.level.value)
        end
        if config and config.profile and config.profile.winstreak and config.profile.winstreak.enabled then
            pcall(function()
                local ls = player:FindFirstChild("CustomLeaderstats")
                if ls then
                    local ws = ls:FindFirstChild("Win Streak")
                    if ws then
                        ws.Value = config.profile.winstreak.value
                    end
                end
            end)
        end
        task.wait(0.4)
    end
end)
local FrameScriptsufhner = Tabs.Character:AddLeftTabbox()
local nnTab = FrameScriptsufhner:AddTab("name")
local skinTab = FrameScriptsufhner:AddTab("skin")
local p = game:GetService("Players").LocalPlayer
if not config.profile.namespoof then 
    config.profile.namespoof = { enabled = false, value = "hi", verified = false, premium = false }
end
if not config.profile.skinchanger then
    config.profile.skinchanger = { enabled = false, userid = "1" }
end
local lastSpoof = ""
local checkupdating = false
local function escape(str)
    return str:gsub("([^%w])", "%%%1")
end
local function clearbadges(str)
    if typeof(str) ~= "string" then return "" end
    return str:gsub(utf8.char(0xE000), ""):gsub(utf8.char(0xE001), "")
end
local function u(c)
    if not config.profile.namespoof.enabled then return end
    local baseName = clearbadges(config.profile.namespoof.value or "hi")
    local v = (config.profile.namespoof.premium and utf8.char(0xE001) or "") .. (config.profile.namespoof.verified and utf8.char(0xE000) or "")
    local curspoof = baseName .. v
    if c then
        local h = c:WaitForChild("Humanoid", 5)
        if h then 
            h.DisplayName = curspoof 
            local old = h.DisplayDistanceType
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            h.DisplayDistanceType = old
        end
    end
end
local function s()
    if not config.profile.namespoof.enabled or checkupdating then return end
    checkupdating = true
    local baseName = clearbadges(config.profile.namespoof.value or "hi")
    local v = (config.profile.namespoof.premium and utf8.char(0xE001) or "") .. (config.profile.namespoof.verified and utf8.char(0xE000) or "")
    local curspoof = baseName .. v
    if p and p.Character then
        local h = p.Character:FindFirstChildOfClass("Humanoid")
        if h then
            pcall(function()
                h.DisplayName = curspoof
                local old = h.DisplayDistanceType
                h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                h.DisplayDistanceType = old
            end)
        end
    end
    lastSpoof = curspoof
    checkupdating = false
end
local function applyskin(c)
    if not (config.profile.skinchanger.enabled and c) then return end
    local h = c:WaitForChild("Humanoid", 5)
    local targetId = tonumber(config.profile.skinchanger.userid)
    if not h or not targetId then return end
    pcall(function()
        local model = game:GetService("Players"):CreateHumanoidModelFromUserId(targetId)
        if not model then return end
        for _, obj in ipairs(c:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") or obj:IsA("ShirtGraphic") then
                obj:Destroy()
            end
        end
        local head = c:FindFirstChild("Head")
        if head then
            local face = head:FindFirstChildOfClass("Decal")
            if face then face:Destroy() end
        end
        for _, obj in ipairs(model:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") or obj:IsA("ShirtGraphic") then
                obj:Clone().Parent = c
            elseif obj.Name == "Head" then
                local targetFace = obj:FindFirstChildOfClass("Decal")
                if targetFace and head then
                    targetFace:Clone().Parent = head
                end
            end
        end
        model:Destroy()
    end)
end
nnTab:AddToggle("NameSpoofEnabled", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        config.profile.namespoof.enabled = val
        if val then
            if p.Character then u(p.Character) end
            s()
        end
    end
})
nnTab:AddToggle("NameSpoofVerified", {
    Text = "Verified",
    Default = false,
    Callback = function(val)
        config.profile.namespoof.verified = val
        if config.profile.namespoof.enabled then
            if p.Character then u(p.Character) end
            s()
        end
    end
})
nnTab:AddToggle("NameSpoofPremium", {
    Text = "Premium",
    Default = false,
    Callback = function(val)
        config.profile.namespoof.premium = val
        if config.profile.namespoof.enabled then
            if p.Character then u(p.Character) end
            s()
        end
    end
})
nnTab:AddInput("NameSpoofValue", {
    Text = "Custom Name",
    Default = "hi",
    Numeric = false,
    Finished = false,
    Placeholder = "Type name...",
    Callback = function(val)
        config.profile.namespoof.value = clearbadges(val or "hi")
        if config.profile.namespoof.enabled then
            if p.Character then u(p.Character) end
            s()
        end
    end
})
skinTab:AddToggle("SkinChangerEnabled", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        config.profile.skinchanger.enabled = val
        if val and p.Character then
            applyskin(p.Character)
        end
    end
})
skinTab:AddInput("SkinChangerValue", {
    Text = "User ID",
    Default = "1",
    Numeric = true,
    Finished = true,
    Placeholder = "Type User ID...",
    Callback = function(val)
        config.profile.skinchanger.userid = val or "1"
        if config.profile.skinchanger.enabled and p.Character then
            applyskin(p.Character)
        end
    end
})
p.CharacterAdded:Connect(function(c)
    u(c)
    applyskin(c)
end)
local function handlenewdescendant(d)
    if not config.profile.namespoof.enabled or checkupdating then return end
    if not (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) then return end
    if not d.Text then return end
    local charAncestor = d:FindFirstAncestorOfClass("Model")
    if not charAncestor or charAncestor ~= p.Character then return end
    local baseName = clearbadges(config.profile.namespoof.value or "hi")
    local v = (config.profile.namespoof.premium and utf8.char(0xE001) or "") .. (config.profile.namespoof.verified and utf8.char(0xE000) or "")
    local curspoof = baseName .. v
    if d.Text:find(p.Name, 1, true) then
        checkupdating = true
        d.Text = d.Text:gsub(escape(p.Name), curspoof)
        checkupdating = false
    elseif lastSpoof ~= "" and lastSpoof ~= curspoof and d.Text:find(lastSpoof, 1, true) then
        checkupdating = true
        d.Text = d.Text:gsub(escape(lastSpoof), curspoof)
        checkupdating = false
    end
end
game.DescendantAdded:Connect(handlenewdescendant)
pcall(function()
    game:GetService("CoreGui").DescendantAdded:Connect(handlenewdescendant)
end)
local FrameScriptStats = Tabs.Character:AddLeftTabbox()
local fpsTab = FrameScriptStats:AddTab("fps")
local msTab = FrameScriptStats:AddTab("ms")
local regionTab = FrameScriptStats:AddTab("region")
if not config.profile.fpsspoof then
    config.profile.fpsspoof = { enabled = false, value = "1", fraud = false }
end
if not config.profile.msspoof then
    config.profile.msspoof = { enabled = false, value = "1", fraud = false }
end
if not config.profile.regionspoof then
    config.profile.regionspoof = { enabled = false, value = "BazaHub" }
end
_G.FPSSpoofConnections = _G.FPSSpoofConnections or {}
for i = 1, #_G.FPSSpoofConnections do
    _G.FPSSpoofConnections[i]:Disconnect()
end
_G.FPSSpoofConnections = {}
_G.MSSpoofConnections = _G.MSSpoofConnections or {}
for i = 1, #_G.MSSpoofConnections do
    _G.MSSpoofConnections[i]:Disconnect()
end
_G.MSSpoofConnections = {}
_G.RegionSpoofConnections = _G.RegionSpoofConnections or {}
for i = 1, #_G.RegionSpoofConnections do
    _G.RegionSpoofConnections[i]:Disconnect()
end
_G.RegionSpoofConnections = {}
if _G.FPSFraudThread then
    _G.FPSFraudThread = false
end
if _G.MSFraudThread then
    _G.MSFraudThread = false
end
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local foundLabels = {}
local foundRegionLabels = {}
local function findLabels(parent)
    local children = parent:GetChildren()
    for i = 1, #children do
        local child = children[i]
        if child:IsA("TextLabel") and child.Name == "Title" then
            if child.Parent.Name == "ServerRegion" then
                foundRegionLabels[#foundRegionLabels + 1] = child
            else
                foundLabels[#foundLabels + 1] = child
            end
        end
        findLabels(child)
    end
end
findLabels(PlayerGui)
local lastBaseFPS = nil
local lastBaseMS = nil
local fpsTrend = 0
local msTrend = 0
local lastFPSTime = 0
local lastMSTime = 0
local function getFraudFPS()
    local base = tonumber(config.profile.fpsspoof.value) or 60
    if lastBaseFPS == nil then
        lastBaseFPS = base
    end
    local variation = math.random(-8, 12)
    fpsTrend = fpsTrend + math.random(-3, 5)
    fpsTrend = math.clamp(fpsTrend, -15, 15)
    local totalVariation = variation + fpsTrend
    if math.random(1, 100) <= 15 then
        totalVariation = totalVariation + math.random(-10, 20)
    end
    if math.random(1, 100) <= 8 then
        totalVariation = totalVariation - math.random(5, 15)
    end
    local newValue = base + totalVariation
    if math.random(1, 100) <= 5 then
        newValue = newValue + math.random(20, 45)
    end
    if newValue < 10 then
        newValue = math.random(10, 25)
    end
    if newValue > 144 then
        newValue = math.random(120, 144)
    end
    if math.random(1, 100) <= 3 then
        newValue = math.random(30, 50)
    end
    lastBaseFPS = newValue
    return tostring(math.floor(newValue))
end
local function getFraudMS()
    local base = tonumber(config.profile.msspoof.value) or 50
    if lastBaseMS == nil then
        lastBaseMS = base
    end
    msTrend = msTrend + math.random(-4, 6)
    msTrend = math.clamp(msTrend, -20, 25)
    local spike = 0
    if math.random(1, 100) <= 12 then
        spike = math.random(15, 45)
    end
    if math.random(1, 100) <= 7 then
        spike = spike - math.random(10, 30)
    end
    local variation = math.random(-12, 18)
    local newValue = base + variation + msTrend + spike
    if newValue < 8 then
        newValue = math.random(8, 20)
    end
    if newValue > 250 then
        newValue = math.random(180, 250)
    end
    if math.random(1, 100) <= 10 then
        newValue = newValue + math.random(5, 25)
    end
    if math.random(1, 100) <= 6 then
        newValue = math.random(100, 200)
    end
    lastBaseMS = newValue
    return tostring(math.floor(newValue))
end
local function applyFPSSpoof()
    for i = 1, #_G.FPSSpoofConnections do
        _G.FPSSpoofConnections[i]:Disconnect()
    end
    _G.FPSSpoofConnections = {}
    _G.FPSFraudThread = false
    lastBaseFPS = nil
    fpsTrend = 0
    if not config.profile.fpsspoof.enabled then return end
    if config.profile.fpsspoof.fraud then
        _G.FPSFraudThread = true
        task.spawn(function()
            while _G.FPSFraudThread do
                local target = getFraudFPS()
                for i = 1, #foundLabels do
                    local label = foundLabels[i]
                    local spoofed = label.Text:gsub("%d+fps", target .. "fps")
                    if spoofed ~= label.Text then
                        label.Text = spoofed
                    end
                end
                local waitTime = 0.95 + math.random() * 0.4
                task.wait(waitTime)
            end
        end)
    else
        local target = config.profile.fpsspoof.value
        for i = 1, #foundLabels do
            local label = foundLabels[i]
            _G.FPSSpoofConnections[#_G.FPSSpoofConnections + 1] = label:GetPropertyChangedSignal("Text"):Connect(function()
                local spoofed = label.Text:gsub("%d+fps", target .. "fps")
                if spoofed ~= label.Text then
                    label.Text = spoofed
                end
            end)
        end
    end
end
local function applyMSSpoof()
    for i = 1, #_G.MSSpoofConnections do
        _G.MSSpoofConnections[i]:Disconnect()
    end
    _G.MSSpoofConnections = {}
    _G.MSFraudThread = false
    lastBaseMS = nil
    msTrend = 0
    if not config.profile.msspoof.enabled then return end
    if config.profile.msspoof.fraud then
        _G.MSFraudThread = true
        task.spawn(function()
            while _G.MSFraudThread do
                local target = getFraudMS()
                for i = 1, #foundLabels do
                    local label = foundLabels[i]
                    local spoofed = label.Text:gsub("%d+ms", target .. "ms")
                    if spoofed ~= label.Text then
                        label.Text = spoofed
                    end
                end
                local waitTime = 0.95 + math.random() * 0.4
                task.wait(waitTime)
            end
        end)
    else
        local target = config.profile.msspoof.value
        for i = 1, #foundLabels do
            local label = foundLabels[i]
            _G.MSSpoofConnections[#_G.MSSpoofConnections + 1] = label:GetPropertyChangedSignal("Text"):Connect(function()
                local spoofed = label.Text:gsub("%d+ms", target .. "ms")
                if spoofed ~= label.Text then
                    label.Text = spoofed
                end
            end)
        end
    end
end
local function applyRegionSpoof()
    for i = 1, #_G.RegionSpoofConnections do
        _G.RegionSpoofConnections[i]:Disconnect()
    end
    _G.RegionSpoofConnections = {}
    if not config.profile.regionspoof.enabled then return end
    local target = config.profile.regionspoof.value
    for i = 1, #foundRegionLabels do
        local label = foundRegionLabels[i]
        label.Text = target
        _G.RegionSpoofConnections[#_G.RegionSpoofConnections + 1] = label:GetPropertyChangedSignal("Text"):Connect(function()
            if label.Text ~= target then
                label.Text = target
            end
        end)
    end
end
fpsTab:AddToggle("FPSSpoofEnabled", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        config.profile.fpsspoof.enabled = val
        applyFPSSpoof()
    end
})
fpsTab:AddToggle("FPSSpoofFraud", {
    Text = "Fraud",
    Default = false,
    Callback = function(val)
        config.profile.fpsspoof.fraud = val
        if config.profile.fpsspoof.enabled then
            applyFPSSpoof()
        end
    end
})
fpsTab:AddInput("FPSSpoofValue", {
    Text = "FPS Value",
    Default = "1",
    Numeric = true,
    Finished = false,
    Placeholder = "Type FPS...",
    Callback = function(val)
        config.profile.fpsspoof.value = val or "1"
        if config.profile.fpsspoof.enabled then
            applyFPSSpoof()
        end
    end
})
msTab:AddToggle("MSSpoofEnabled", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        config.profile.msspoof.enabled = val
        applyMSSpoof()
    end
})
msTab:AddToggle("MSSpoofFraud", {
    Text = "Fraud",
    Default = false,
    Callback = function(val)
        config.profile.msspoof.fraud = val
        if config.profile.msspoof.enabled then
            applyMSSpoof()
        end
    end
})
msTab:AddInput("MSSpoofValue", {
    Text = "MS Value",
    Default = "1",
    Numeric = true,
    Finished = false,
    Placeholder = "Type MS...",
    Callback = function(val)
        config.profile.msspoof.value = val or "1"
        if config.profile.msspoof.enabled then
            applyMSSpoof()
        end
    end
})
regionTab:AddToggle("RegionSpoofEnabled", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        config.profile.regionspoof.enabled = val
        applyRegionSpoof()
    end
})
regionTab:AddInput("RegionSpoofValue", {
    Text = "Custom Region",
    Default = "BazaHub",
    Numeric = false,
    Finished = false,
    Placeholder = "Type Region...",
    Callback = function(val)
        config.profile.regionspoof.value = val or "BazaHub"
        if config.profile.regionspoof.enabled then
            applyRegionSpoof()
        end
    end
})
local v2 = Tabs.Character:AddRightGroupbox('Movement')
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local velocityEnabled = false
local velocitySpeed = 45
local velocityConn = nil
v2:AddToggle("cframespf_enabled", {
    Text = "Velocity",
    Default = false,
    Callback = function(state)
        velocityEnabled = state
        if state then
            if velocityConn then velocityConn:Disconnect() end
            velocityConn = RS.Heartbeat:Connect(function()
                if not velocityEnabled then return end
                local char = LP.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = moveDir * velocitySpeed
                end
            end)
        else
            if velocityConn then velocityConn:Disconnect(); velocityConn = nil end
        end
    end
})
v2:AddSlider("spdd_value", {
    Text = "Velocity Speed",
    Default = 45,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Compact = true,
    Callback = function(value)
        velocitySpeed = value
    end
})
local flyEnabled = false
local flySpeed = 50
local flyConn = nil
local bodyVelocity = nil
local bodyGyro = nil
local function cleanupFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
end
v2:AddToggle("cframefly_enabled", {
    Text = "Fly Mode",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        if not state then
            cleanupFly()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
            return
        end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bodyGyro.P = 1000
        hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
        flyConn = RS.Heartbeat:Connect(function()
            if not flyEnabled then cleanupFly(); return end
            local char = LP.Character
            if not char or not char.Parent or not hrp or not hrp.Parent then cleanupFly(); return end
            local humCurrent = char:FindFirstChildOfClass("Humanoid")
            if humCurrent then
                local cam = workspace.CurrentCamera
                local look = cam.CFrame.LookVector
                local right = cam.CFrame.RightVector
                local move = Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then move += look end
                if UIS:IsKeyDown(Enum.KeyCode.S) then move -= look end
                if UIS:IsKeyDown(Enum.KeyCode.A) then move -= right end
                if UIS:IsKeyDown(Enum.KeyCode.D) then move += right end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0, 1, 0) end
                if move.Magnitude > 0 then move = move.Unit end
                bodyVelocity.Velocity = move * flySpeed
                bodyGyro.CFrame = cam.CFrame
                if humCurrent:GetState() ~= Enum.HumanoidStateType.PlatformStanding then
                    humCurrent:ChangeState(Enum.HumanoidStateType.PlatformStanding)
                end
            end
        end)
    end
})
v2:AddSlider("cframefly_speed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 16,
    Max = 750,
    Rounding = 0,
    Compact = true,
    Callback = function(value)
        flySpeed = value
    end
})
local slideBoostEnabled = false
local slideBoostSpeed = 45
local slideBoostConn = nil
v2:AddToggle("CHAR_SLIDE_BOOST", {
    Text = "Slide Boost",
    Default = false,
    Callback = function(Value)
        slideBoostEnabled = Value
        if Value then
            if slideBoostConn then slideBoostConn:Disconnect() end
            slideBoostConn = RS.Heartbeat:Connect(function()
                if not slideBoostEnabled then return end
                local char = LP.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end
                local isSliding = UIS:IsKeyDown(Enum.KeyCode.LeftControl)
                    or UIS:IsKeyDown(Enum.KeyCode.ButtonR3)
                if isSliding then
                    local moveDir = hum.MoveDirection
                    if moveDir.Magnitude > 0 then
                        hrp.AssemblyLinearVelocity = moveDir * slideBoostSpeed
                    else
                        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * slideBoostSpeed
                    end
                end
            end)
        else
            if slideBoostConn then slideBoostConn:Disconnect(); slideBoostConn = nil end
        end
    end
})
v2:AddSlider("CHAR_SLIDE_BOOST_SPEED", {
    Text = "Slide Boost Speed",
    Default = 45,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Compact = true,
    Callback = function(value)
        slideBoostSpeed = value
    end
})
local characterSection = Tabs.Character:AddLeftTabbox()
local slfMtrlTab = characterSection:AddTab("self material")
local animPlayerTab = characterSection:AddTab("animation player")
local SlfMtrl = {
    enabled = false,
    color1 = Color3.fromRGB(255, 255, 255),
    color2 = Color3.fromRGB(255, 255, 255),
    color3 = Color3.fromRGB(255, 255, 255),
    materialName = "Neon",
    transparency = 0.1,
    pulseSpeed = 3,
    phase = 0,
    parts = {},
    originals = {},
    conn = nil,
    cacheTick = 0,
}
local SlfMtrlMaterials = {
    "ForceField", "Neon", "SmoothPlastic", "Glass", "Ice", "Plastic",
    "Wood", "Marble", "Granite", "Brick", "Cobblestone", "Concrete", "Slate", "Foil",
}
local function SlfMtrlGetCharacter()
    return p.Character
end
local function SlfMtrlGetBodyParts()
    local char = SlfMtrlGetCharacter()
    if not char then return {} end
    local parts = {}
    for _, inst in ipairs(char:GetChildren()) do
        if inst:IsA("BasePart") and inst.Name ~= "HumanoidRootPart" then
            parts[#parts + 1] = inst
        end
    end
    return parts
end
local function SlfMtrlRecordOriginal(part)
    if SlfMtrl.originals[part] then return end
    SlfMtrl.originals[part] = {
        Material = part.Material,
        Color = part.Color,
        Transparency = part.Transparency,
    }
end
local function SlfMtrlRestore()
    for part, data in pairs(SlfMtrl.originals) do
        if part and part.Parent then
            part.Material = data.Material
            part.Color = data.Color
            part.Transparency = data.Transparency
        end
    end
    SlfMtrl.originals = {}
end
local function SlfMtrlRefreshCache()
    SlfMtrl.parts = SlfMtrlGetBodyParts()
    for _, part in ipairs(SlfMtrl.parts) do
        SlfMtrlRecordOriginal(part)
    end
end
local function SlfMtrlBlend(t)
    if t < 0.5 then
        return SlfMtrl.color1:Lerp(SlfMtrl.color2, t * 2)
    end
    return SlfMtrl.color2:Lerp(SlfMtrl.color3, (t - 0.5) * 2)
end
local function SlfMtrlApply(dt)
    if not SlfMtrl.enabled then return end
    if tick() - SlfMtrl.cacheTick > 0.5 then
        SlfMtrl.cacheTick = tick()
        SlfMtrlRefreshCache()
    end
    SlfMtrl.phase = SlfMtrl.phase + dt * (SlfMtrl.pulseSpeed or 3)
    local t = (math.sin(SlfMtrl.phase) + 1) * 0.5
    local pulseColor = SlfMtrlBlend(t)
    local mat = Enum.Material[SlfMtrl.materialName] or Enum.Material.Neon
    local trans = math.clamp(SlfMtrl.transparency or 0.1, 0, 1)
    for _, part in ipairs(SlfMtrl.parts) do
        if part and part.Parent then
            part.Material = mat
            part.Color = pulseColor
            part.Transparency = trans
        end
    end
end
local function SlfMtrlSetEnabled(state)
    SlfMtrl.enabled = state
    if state then
        SlfMtrlRefreshCache()
        if not SlfMtrl.conn then
            SlfMtrl.conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
                SlfMtrlApply(dt)
            end)
        end
    else
        if SlfMtrl.conn then
            SlfMtrl.conn:Disconnect()
            SlfMtrl.conn = nil
        end
        SlfMtrlRestore()
    end
end
if p then
    p.CharacterAdded:Connect(function()
        task.wait(0.25)
        if SlfMtrl.enabled then
            SlfMtrlRefreshCache()
        end
    end)
end
slfMtrlTab:AddToggle("SlfMtrlEnable", {
    Text = "Enable",
    Default = false,
    Callback = function(val)
        SlfMtrlSetEnabled(val)
    end
}):AddColorPicker("SlfMtrlColor1", {
    Title = "color 1",
    Default = SlfMtrl.color1,
    Callback = function(val)
        SlfMtrl.color1 = val
    end
}):AddColorPicker("SlfMtrlColor2", {
    Title = "color 2",
    Default = SlfMtrl.color2,
    Callback = function(val)
        SlfMtrl.color2 = val
    end
}):AddColorPicker("SlfMtrlColor3", {
    Title = "color 3",
    Default = SlfMtrl.color3,
    Callback = function(val)
        SlfMtrl.color3 = val
    end
})
slfMtrlTab:AddDropdown("SlfMtrlMaterial", {
    Text = "Material",
    Default = SlfMtrl.materialName,
    Values = SlfMtrlMaterials,
    Callback = function(val)
        SlfMtrl.materialName = val
    end
})
slfMtrlTab:AddSlider("SlfMtrlTransparency", {
    Text = "Transparency",
    Default = SlfMtrl.transparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(val)
        SlfMtrl.transparency = val
    end
})
slfMtrlTab:AddSlider("SlfMtrlPulseSpeed", {
    Text = "Pulse Speed",
    Default = SlfMtrl.pulseSpeed,
    Min = 0.1,
    Max = 12,
    Rounding = 1,
    Callback = function(val)
        SlfMtrl.pulseSpeed = val
    end
})
local AnimPlayer = {
    animationId = "",
    loop = true,
    track = nil,
    stoppedConn = nil,
}
local function AnimPlayerGetAnimator()
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    return animator
end
local function AnimPlayerNormalizeId(raw)
    local txt = tostring(raw or "")
    local numeric = txt:match("%d+")
    if not numeric then return nil end
    return "rbxassetid://" .. numeric
end
local function AnimPlayerStop()
    if AnimPlayer.stoppedConn then
        AnimPlayer.stoppedConn:Disconnect()
        AnimPlayer.stoppedConn = nil
    end
    if AnimPlayer.track then
        pcall(function()
            AnimPlayer.track:Stop()
            AnimPlayer.track:Destroy()
        end)
        AnimPlayer.track = nil
    end
end
local function AnimPlayerPlay()
    local animId = AnimPlayerNormalizeId(AnimPlayer.animationId)
    if not animId then
        Library:Notify("invalid animation id", 2)
        return
    end
    local animator = AnimPlayerGetAnimator()
    if not animator then
        Library:Notify("humanoid not found", 2)
        return
    end
    AnimPlayerStop()
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local ok, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    anim:Destroy()
    if not ok or not track then
        Library:Notify("failed to load animation", 2)
        return
    end
    AnimPlayer.track = track
    track.Looped = AnimPlayer.loop
    track:Play(0.05, 1, 1)
    AnimPlayer.stoppedConn = track.Stopped:Connect(function()
        if AnimPlayer.loop then
            task.delay(0.03, function()
                if AnimPlayer.track == track then
                    pcall(function() track:Play(0.05, 1, 1) end)
                end
            end)
        end
    end)
end
do
local runservice = game:GetService("RunService")
local players = game:GetService("Players")
local localplayer = players.LocalPlayer
local workspace = game:GetService("Workspace")
local settings = {
    enabled = false,
    yawtype = "none",
    pitchtype = "none",
    angletype = "none",
    bodyyaw = "none",
    pitchpreset = "none",
    customangle = 0,
    minspeed = 10,
    maxspeed = 20,
    minangle = 30,
    maxangle = 60,
    randomangle = false,
    spindirection = 1,
    fakelag = false,
    fakelagstuds = 4,
    desync = false,
    desyncstuds = 3,
    microjitter = false,
    microstrength = 25,
    velocitybreaker = false,
}
local statemanager = {
    lastupdate = tick(),
    invertstate = false,
    smoothyaw = 0,
    smoothpitch = 0,
    smoothroll = 0,
    framecounter = 0
}
local utils = {
    getrandominrange = function(min, max)
        return min + math.random() * (max - min)
    end
}
local headBackwardsMotors = {}
local headBackwardsOrigC0 = {}
local camRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Replication") and ReplicatedStorage.Remotes.Replication:FindFirstChild("Fighter") and ReplicatedStorage.Remotes.Replication.Fighter:FindFirstChild("UpdateCameraRotation")
local encodeCameraRotation = function(vec2)
    if not Utility or not Utility.EncodeCameraRotation then return nil end
    return Utility:EncodeCameraRotation(vec2)
end
local function updateHeadBackwardsMotors()
    headBackwardsMotors = {}
    headBackwardsOrigC0 = {}
    local character = LocalPlayer.Character
    if not character then return end
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Motor6D") then
            headBackwardsMotors[v.Name] = v
            headBackwardsOrigC0[v] = v.C0
        end
    end
end
local function applyHeadBackwards()
    if not LocalPlayer.Character or not headBackwardsMotors["Neck"] then return end
    local neckMotor = headBackwardsMotors["Neck"]
    if neckMotor and neckMotor.Parent then
        neckMotor.C0 = neckMotor.C0 * CFrame.Angles(math.pi * 0.85, math.pi, 0)
    end
    if camRemote then
        pcall(function()
            local encoded = encodeCameraRotation(Vector2.new(512, 0))
            if encoded then
                camRemote:FireServer(encoded, nil)
            end
        end)
    end
end
local function resetHeadBackwardsMotors()
    for motor, origC0 in pairs(headBackwardsOrigC0) do
        if motor and motor.Parent then
            motor.C0 = origC0
        end
    end
end
local function curweap2()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end
    for _, child in ipairs(firstPerson:GetChildren()) do
        local childName = child.Name
        local parts = {}
        for part in childName:gmatch("[^-]+") do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        if #parts >= 2 then
            return parts[2]
        end
    end
    return nil
end
local fighter_controller = instanceSafeRequire(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.FighterController)
local local_fighter = fighter_controller.LocalFighter
local underground_enabled = false
local camera_controller = instanceSafeRequire(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.CameraController)
local underground_oldpos
local function getFloorBelowPosition(pos)
    local rayOrigin = pos
    local rayDirection = Vector3.new(0, -500, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    if local_fighter and local_fighter.Entity and local_fighter.Entity.RootPart then
        raycastParams.FilterDescendantsInstances = {local_fighter.Entity.RootPart.Parent}
    end
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        return CFrame.new(Vector3.new(pos.X, result.Position.Y - 2, pos.Z))
    end
    return nil
end
local old_underground_camera_controller = camera_controller.Update
camera_controller.Update = function(...)
    local arguments = {...}
    if underground_enabled and local_fighter and local_fighter.Entity and local_fighter.Entity.RootPart and underground_oldpos then
        local_fighter.Entity.RootPart.CFrame = underground_oldpos
    end
    return old_underground_camera_controller(table.unpack(arguments))
end
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().InstanceConfigLoading then
        return
    end
    if not underground_enabled then
        underground_oldpos = nil
        return
    end
    local curweap = curweap2()
    if not curweap then
        underground_oldpos = nil
        return
    end
    if local_fighter and local_fighter.Entity and local_fighter.Entity.RootPart then
        underground_oldpos = local_fighter.Entity.RootPart.CFrame
        local currentPos = local_fighter.Entity.RootPart.Position
        local floorCFrame = getFloorBelowPosition(currentPos)
        if floorCFrame then
            local_fighter.Entity.RootPart.CFrame = floorCFrame
        end
    end
end)
local antiaim = {
    calculateyaw = function(deltatime)
        local yaw = 0
        local currenttime = tick()
        if settings.yawtype == "jitter" then
            local minangle = math.rad(settings.minangle)
            local maxangle = math.rad(settings.maxangle)
            if settings.randomangle then
                yaw = utils.getrandominrange(-maxangle, maxangle)
            else
                yaw = math.random() > 0.5 and minangle or -minangle
            end
        elseif settings.yawtype == "spinbot" then
            local speed = utils.getrandominrange(
                settings.minspeed / 10,
                settings.maxspeed / 10
            )
            yaw = (currenttime * speed) % (2 * math.pi)
        elseif settings.yawtype == "random" then
            if statemanager.framecounter % 30 == 0 then
                yaw = utils.getrandominrange(
                    -math.rad(settings.maxangle),
                    math.rad(settings.maxangle)
                )
            else
                yaw = statemanager.smoothyaw
            end
        end
        return yaw
    end,
    calculatepitch = function()
        local pitch = 0
        if settings.pitchtype == "jitter" then
            local minangle = math.rad(settings.minangle)
            local maxangle = math.rad(settings.maxangle)
            if settings.randomangle then
                pitch = utils.getrandominrange(-maxangle, maxangle)
            else
                pitch = math.random() > 0.5 and minangle or -minangle
            end
        elseif settings.pitchtype == "spinbot" then
            pitch = math.sin(tick() * (settings.maxspeed / 10)) * math.rad(settings.maxangle)
        elseif settings.pitchtype == "random" then
            if statemanager.framecounter % 20 == 0 then
                pitch = utils.getrandominrange(math.rad(-89), math.rad(89))
            else
                pitch = statemanager.smoothpitch
            end
        end
        return pitch
    end,
    calculateroll = function()
        local roll = 0
        if settings.angletype == "tilt 45" then
            roll = math.rad(45)
        elseif settings.angletype == "tilt 90" then
            roll = math.rad(90)
        elseif settings.angletype == "upside down" then
            roll = math.rad(180)
        elseif settings.angletype == "custom" then
            roll = math.rad(settings.customangle)
        end
        return roll
    end
}
local function updantiaim(deltatime)
    if not settings.enabled then return end
    if getgenv().InstanceConfigLoading then return end
    if getgenv().InstanceConfigLoading == nil then return end
    if settings.yawtype == "none" and settings.pitchtype == "none" and settings.angletype == "none" then
        return
    end
    local curweap = curweap2()
    if not curweap then return end
    local character = localplayer.Character
    if not character then return end
    local rootpart = character:FindFirstChild("HumanoidRootPart")
    if not rootpart then return end
    statemanager.framecounter = statemanager.framecounter + 1
    local calculatedyaw = antiaim.calculateyaw(deltatime)
    local calculatedpitch = antiaim.calculatepitch()
    local calculatedroll = antiaim.calculateroll()
    local rotationcframe = CFrame.Angles(calculatedpitch, calculatedyaw, calculatedroll)
    rootpart.CFrame = rootpart.CFrame * rotationcframe
end
local function flushAntiAimMovementState()
    underground_oldpos = nil
    statemanager.framecounter = 0
    statemanager.smoothyaw = 0
    statemanager.smoothpitch = 0
    statemanager.smoothroll = 0
    resetHeadBackwardsMotors()
    local char = localplayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end
getgenv().InstanceFlushMovementState = function()
    flushAntiAimMovementState()
    if getgenv().InstanceCleanupMovement then
        pcall(getgenv().InstanceCleanupMovement)
    else
        _G.keyheldcframe = false
        _G.keyheldcframefly = false
    end
end
getgenv().InstanceSyncAfterConfigLoad = function()
    if getgenv().InstanceFlushMovementState then
        pcall(getgenv().InstanceFlushMovementState)
    end
    _G.keyheldcframe = false
    _G.keyheldcframefly = false
    if Toggles and Toggles.AntiAimEnable then
        settings.enabled = Toggles.AntiAimEnable.Value == true
    else
        settings.enabled = false
    end
    if Toggles and Toggles.AntiAimUnderground then
        underground_enabled = Toggles.AntiAimUnderground.Value == true
        getgenv().InstanceUndergroundEnabled = underground_enabled
        if not underground_enabled then
            underground_oldpos = nil
        end
    else
        underground_enabled = false
        getgenv().InstanceUndergroundEnabled = false
        underground_oldpos = nil
    end
    if Options and Options.AntiAimYaw then
        settings.yawtype = Options.AntiAimYaw.Value or "none"
    end
    if Options and Options.AntiAimPitch then
        settings.pitchtype = Options.AntiAimPitch.Value or "none"
    end
    if Options and Options.AntiAimAngle then
        settings.angletype = Options.AntiAimAngle.Value or "none"
    end
    if not settings.enabled or (settings.yawtype == "none" and settings.pitchtype == "none" and settings.angletype == "none") then
        flushAntiAimMovementState()
        underground_oldpos = nil
    end
end
localplayer.CharacterAdded:Connect(function()
    task.defer(flushAntiAimMovementState)
end)
local antiaimbox = Tabs.Combat:AddLeftGroupbox('Anti Aim')
antiaimbox:AddToggle("AntiAimEnable", {
    Text = "Enable",
    Default = false,
    Callback = function(value)
        settings.enabled = value
        if getgenv().InstanceConfigLoading then return end
        if not value then
            flushAntiAimMovementState()
        end
    end
})
antiaimbox:AddDropdown("AntiAimYaw", {
    Values = {"none", "jitter", "spinbot", "random"},
    Default = "none",
    Text = "Yaw",
    Callback = function(value)
        settings.yawtype = value
    end
})
antiaimbox:AddDropdown("AntiAimPitch", {
    Values = {"none", "jitter", "spinbot", "random"},
    Default = "none",
    Text = "Pitch",
    Callback = function(value)
        settings.pitchtype = value
    end
})
antiaimbox:AddDropdown("AntiAimAngle", {
    Values = {"none", "tilt 45", "tilt 90", "upside down", "custom"},
    Default = "none",
    Text = "Angle",
    Callback = function(value)
        settings.angletype = value
    end
})
antiaimbox:AddSlider("AntiAimCustomAngle", {
    Text = "Custom Angle",
    Default = 0,
    Min = 0,
    Max = 360,
    Rounding = 1,
    Suffix = '°',
    Callback = function(value)
        settings.customangle = value
    end
})
antiaimbox:AddSlider('speedslider', {
    Text = 'min speed',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Suffix = '',
    Callback = function(value)
        settings.minspeed = value
    end
})
antiaimbox:AddSlider('angleslider', {
    Text = 'max speed',
    Default = 20,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Suffix = '',
    Callback = function(value)
        settings.maxspeed = value
    end
})
antiaimbox:AddSlider('minangleslider', {
    Text = 'min angle',
    Default = 30,
    Min = 1,
    Max = 180,
    Rounding = 1,
    Suffix = '°',
    Callback = function(value)
        settings.minangle = value
    end
})
antiaimbox:AddSlider('maxangleslider', {
    Text = 'max angle',
    Default = 60,
    Min = 1,
    Max = 180,
    Rounding = 1,
    Suffix = '°',
    Callback = function(value)
        settings.maxangle = value
    end
})
antiaimbox:AddToggle("randomangle", {
    Text = "Random Angle",
    Default = false,
    Callback = function(value)
        settings.randomangle = value
    end
})
antiaimbox:AddToggle("AntiAimUnderground", {
    Text = "Underground",
    Default = false,
    Callback = function(value)
        underground_enabled = value
            getgenv().InstanceUndergroundEnabled = value
            if getgenv().InstanceConfigLoading then return end
            if not value then
            underground_oldpos = nil
        end
    end
})
getgenv().InstanceSetUnderground = function(val)
    underground_enabled = val
    getgenv().InstanceUndergroundEnabled = val
    if not val then
        underground_oldpos = nil
    end
end
runservice.Heartbeat:Connect(updantiaim)
v3 = Tabs.Misc:AddLeftGroupbox('Auto Ban - Ranked')
weapons = {
    "Assault Rifle",
    "Sniper",
    "Bow",
    "Burst Rifle",
    "Crossbow",
    "Gunblade",
    "RPG",
    "Shotgun",
    "Energy Rifle",
    "Flamethrower",
    "Grenade Launcher",
    "Minigun",
    "Paintball Gun",
    "Distortion",
    "Permafrost",
    "Handgun",
    "Daggers",
    "Flare Gun",
    "Revolver",
    "Shorty",
    "Spray",
    "Uzi",
    "Energy Pistols",
    "Exogun",
    "Slingshot",
    "Warper",
    "Fists",
    "Battle Axe",
    "Chainsaw",
    "Katana",
    "Knife",
    "Riot Shield",
    "Scythe",
    "Maul",
    "Trowel",
    "Grenade",
    "Flashbang",
    "Freeze Ray",
    "Jump Pad",
    "Molotov",
    "Satchel",
    "Smoke Grenade",
    "War Horn",
    "Medkit",
    "Substapce Tripmine",
    "Warpstone",
    "Hook",
    "Spear"
}
enabled = false
weapon1 = "Riot Shield"
weapon2 = "Katana"
thread = nil
storage = game:GetService("ReplicatedStorage")
remote = storage:WaitForChild("Remotes"):WaitForChild("Duels"):WaitForChild("Vote")
stop = function()
    if thread then
        thread = nil
    end
end
start = function()
    stop()
    thread = task.spawn(function()
        while enabled and task.wait(1) do
            list = {}
            if weapon1 and weapon1 ~= "" then
                table.insert(list, weapon1)
            end
            if weapon2 and weapon2 ~= "" then
                table.insert(list, weapon2)
            end
            if #list > 0 then
                i = 1
                while enabled do
                    remote:FireServer(list[i])
                    i = i % #list + 1
                    task.wait(1)
                    if not thread then
                        break
                    end
                end
            end
        end
    end)
end
v3:AddToggle("AutoBanQueueEnable", {
    Text = "Enable",
    Default = false,
    Callback = function(s)
        enabled = s
        if getgenv().InstanceConfigLoading then return end
        if s then
            start()
        else
            stop()
        end
    end
})
first = v3:AddDropdown("first", {
    Text = "Weapon 1",
    Values = weapons,
    Default = 1,
    Multi = false,
    Callback = function(v)
        weapon1 = v
        if enabled then
            stop()
            start()
        end
    end
})
search1 = v3:AddInput("search1", {
    Text = "Search Weapon 1",
    Placeholder = "",
    ClearTextOnFocus = false,
    Callback = function(t)
        if t == "" then
            first:SetValues(weapons)
            return
        end
        f = {}
        t = t:lower()
        for _, w in ipairs(weapons) do
            if w:lower():find(t, 1, true) then
                table.insert(f, w)
            end
        end
        if #f > 0 then
            first:SetValues(f)
            weapon1 = f[1]
            first:SetValue(weapon1)
            if enabled then
                stop()
                start()
            end
        end
    end
})
second = v3:AddDropdown("second", {
    Text = "Weapon 2",
    Values = weapons,
    Default = 2,
    Multi = false,
    Callback = function(v)
        weapon2 = v
        if enabled then
            stop()
            start()
        end
    end
})
search2 = v3:AddInput("search2", {
    Text = "Search Weapon 2",
    Placeholder = "",
    ClearTextOnFocus = false,
    Callback = function(t)
        if t == "" then
            second:SetValues(weapons)
            return
        end
        f = {}
        t = t:lower()
        for _, w in ipairs(weapons) do
            if w:lower():find(t, 1, true) then
                table.insert(f, w)
            end
        end
        if #f > 0 then
            second:SetValues(f)
            weapon2 = f[1]
            second:SetValue(weapon2)
            if enabled then
                stop()
                start()
            end
        end
    end
})
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    stop()
    enabled = false
end)
v4 = Tabs.Misc:AddRightGroupbox('Auto Queue')
queuemode = "1v1"
ranked = false
queueenabled = false
queuethread = nil
queuestop = function()
    if queuethread then
        queuethread = nil
    end
end
queuestart = function()
    queuestop()
    queuethread = task.spawn(function()
        while queueenabled and task.wait(1) do
            local success, result = pcall(function()
                local storage = game:GetService("ReplicatedStorage")
                local remotes = storage:WaitForChild("Remotes")
                local matchmaking = remotes:WaitForChild("Matchmaking")
                local joinqueue = matchmaking:WaitForChild("JoinQueue")
                if ranked then
                    return joinqueue:InvokeServer(queuemode, true)
                else
                    return joinqueue:InvokeServer(queuemode)
                end
            end)
            if not success and not string.find(result:lower(), "already in queue") then
                queuethread = nil
                break
            end
        end
    end)
end
v4:AddToggle("queueenabled", {
    Text = "Enable",
    Default = false,
    Callback = function(s)
        queueenabled = s
        if s then
            queuestart()
        else
            queuestop()
        end
    end
})
v4:AddDropdown("queuemode", {
    Text = "Queue Mode",
    Values = {"1v1", "2v2", "3v3", "4v4", "5v5"},
    Default = 1,
    Multi = false,
    Callback = function(v)
        queuemode = v
        if queueenabled then
            queuestop()
            queuestart()
        end
    end
})
v4:AddToggle("ranked", {
    Text = "Ranked",
    Default = false,
    Callback = function(s)
        ranked = s
        if queueenabled then
            queuestop()
            queuestart()
        end
    end
})
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    queuestop()
    queueenabled = false
end)
end
local MiscUnlockGroup = Tabs.Misc:AddLeftGroupbox('Unlock')
local unlockAllExecuted = false
MiscUnlockGroup:AddToggle("ENABLE_UNLOCK_ALL", {
    Text = "Unlock All",
    Default = false,
    Callback = function(Value)
        if Value and not unlockAllExecuted then
            unlockAllExecuted = true
            pcall(function()
                loadstring(game:HttpGet("https://pastefy.app/6ElsMLeb/raw", true))()
            end)
            if Toggles.ENABLE_UNLOCK_ALL then
                Toggles.ENABLE_UNLOCK_ALL:SetValue(true)
            end
        elseif Value and unlockAllExecuted then
            if Toggles.ENABLE_UNLOCK_ALL then
                Toggles.ENABLE_UNLOCK_ALL:SetValue(true)
            end
        end
    end
})
local v555 = Tabs.Misc:AddRightGroupbox('Miscellaneous')
do
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
_G.Features = _G.Features or {}
_G.Features.Noclip = _G.Features.Noclip or {
    Enabled = false,
    Conn = nil
}
_G.Features.ModDetector = _G.Features.ModDetector or {
    Enabled = true,
    Connection = nil,
    Checking = false
}
local function updnoclip()
    if _G.Features.Noclip.Conn then
        _G.Features.Noclip.Conn:Disconnect()
        _G.Features.Noclip.Conn = nil
    end
    local character = LocalPlayer.Character
    if not character then return end
    if _G.Features.Noclip.Enabled then
        _G.Features.Noclip.Conn = RunService.Stepped:Connect(function()
            local curchar = LocalPlayer.Character
            if not curchar then return end
            for _, part in pairs(curchar:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    if _G.Features.Noclip.Enabled then
        updnoclip()
    end
end)
v555:AddToggle('noclip', {
    Text = 'noclip',
    Default = _G.Features.Noclip.Enabled,
    Callback = function(Value)
        _G.Features.Noclip.Enabled = Value
        updnoclip()
    end
})
_G.Features.Handicaps = _G.Features.Handicaps or { Enabled = false }
local function updHandicaps()
    if not _G.Features.Handicaps.Enabled then
        pcall(function()
            local ps = LocalPlayer:FindFirstChild("PlayerScripts")
            local controllers = ps and ps:FindFirstChild("Controllers")
            local debugMod = controllers and controllers:FindFirstChild("DebugController")
            if not debugMod then return end
            local DebugController = require(debugMod)
            DebugController:SetHandicapsEnabled(false)
        end)
        return
    end
    pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        local controllers = ps and ps:FindFirstChild("Controllers")
        local debugMod = controllers and controllers:FindFirstChild("DebugController")
        if not debugMod then return end
        local DebugController = require(debugMod)
        DebugController:SetHandicapsEnabled(true)
    end)
end
v555:AddToggle('handcaps', {
    Text = 'enable handicaps',
    Default = _G.Features.Handicaps.Enabled,
    Callback = function(val)
        _G.Features.Handicaps.Enabled = val
        updHandicaps()
    end
})
task.defer(function()
    if _G.Features.Handicaps.Enabled then
        updHandicaps()
    end
end)
local trip_hrp
local rs = game:GetService("RunService")
local trip_conn_a, trip_conn_b
local function gethrp()
    pcall(function()
        local pl = game:GetService("Players").LocalPlayer
        trip_hrp = pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
    end)
end
local function det()
    pcall(function()
        if not trip_hrp then return end
        for _, s in ipairs(workspace:GetChildren()) do
            if s.Name == "SubspaceTripmineHitbox" then
                local hb = s:FindFirstChild("Hitbox")
                if hb and trip_hrp and trip_hrp:IsA("BasePart") then
                    firetouchinterest(trip_hrp, hb, 1)
                    firetouchinterest(trip_hrp, hb, 0)
                end
            end
        end
    end)
end
v555:AddToggle("AntiTrip", {
    Text = "Anti Subspace Tripmine",
    Default = false,
    Callback = function(val)
        if val then
            if trip_conn_a then trip_conn_a:Disconnect() trip_conn_a = nil end
            if trip_conn_b then trip_conn_b:Disconnect() trip_conn_b = nil end
            gethrp()
            trip_conn_a = rs.Heartbeat:Connect(gethrp)
            trip_conn_b = rs.Heartbeat:Connect(det)
        else
            if trip_conn_a then trip_conn_a:Disconnect() trip_conn_a = nil end
            if trip_conn_b then trip_conn_b:Disconnect() trip_conn_b = nil end
            trip_hrp = nil
        end
    end
})
local function stopmoddetector()
    if _G.Features.ModDetector.Connection then
        _G.Features.ModDetector.Connection:Disconnect()
        _G.Features.ModDetector.Connection = nil
    end
    _G.Features.ModDetector.Checking = false
end
local function moddetector()
    if not _G.Features.ModDetector.Enabled then return end
    if _G.Features.ModDetector.Checking then return end
    if game.GameId ~= 6035872082 then return end
    _G.Features.ModDetector.Checking = true
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
        if game.CreatorType ~= Enum.CreatorType.Group then
            _G.Features.ModDetector.Checking = false
            return
        end
        local HttpService = game:GetService("HttpService")
        local groupId = game.CreatorId
        local function kickPlayer()
            LocalPlayer:Kick("Mod Detected!")
            task.wait(0.5)
            if LocalPlayer.Parent then
                game:Shutdown()
            end
        end
        local function checkstaffrole(roleName)
            if not roleName or typeof(roleName) ~= "string" then return false end
            local lower = string.lower(roleName)
            return string.find(lower, "mod") or 
                   string.find(lower, "staff") or 
                   string.find(lower, "contributor") or 
                   string.find(lower, "script") or 
                   string.find(lower, "build") or
                   string.find(lower, "admin") or
                   string.find(lower, "owner")
        end
        local function checkPlayer(player)
            if player == LocalPlayer then return false end
            local success, role = pcall(function()
                return player:GetRoleInGroup(groupId)
            end)
            if success and role and checkstaffrole(role) then
                return true
            end
            return false
        end
        local function checkAllPlayers()
            for _, player in ipairs(Players:GetPlayers()) do
                if checkPlayer(player) then
                    return true
                end
            end
            return false
        end
        if checkAllPlayers() then
            kickPlayer()
            _G.Features.ModDetector.Checking = false
            return
        end
        _G.Features.ModDetector.Connection = Players.PlayerAdded:Connect(function(player)
            if not _G.Features.ModDetector.Enabled then return end
            task.wait(1)
            if checkPlayer(player) then
                kickPlayer()
            end
        end)
        while _G.Features.ModDetector.Enabled and task.wait(15) do
            if not _G.Features.ModDetector.Enabled then break end
            if checkAllPlayers() then
                kickPlayer()
                break
            end
        end
        _G.Features.ModDetector.Checking = false
    end)
end
local function updmoddetector()
    if _G.Features.ModDetector.Enabled then
        moddetector()
    else
        stopmoddetector()
    end
end
v555:AddToggle('moddetector', {
    Text = 'mod detector',
    Default = _G.Features.ModDetector.Enabled,
    Callback = function(Value)
        _G.Features.ModDetector.Enabled = Value
        updmoddetector()
    end
})
if _G.Features.ModDetector.Enabled then
    moddetector()
end
local hmndbreaker = {
    Active = false,
    Track = nil,
    Heartbeat = nil,
    AnimConnection = nil,
    EmoteId = "rbxassetid://70883871260184",
    FreezeTime = 0.1265,
    SpinSpeed = 120,
    Gap = 0.025,
    BounceIntensity = 4,
    BouncePhase = 0,
    Mode = "vertical",
    SolarAngle = 0,
    SolarRadius = 5,
    HeadHidden = {},
}
local function hum2()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end
local function restoreHiddenHead(char)
    for part, data in pairs(hmndbreaker.HeadHidden) do
        if part and part.Parent then
            part.Transparency = data.Transparency
            part.CanCollide = data.CanCollide
            if data.Size then
                part.Size = data.Size
            end
            if data.CFrame then
                part.CFrame = data.CFrame
            end
        end
    end
    hmndbreaker.HeadHidden = {}
end
local function hideCharacterHead(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head and not hmndbreaker.HeadHidden[head] then
        hmndbreaker.HeadHidden[head] = {
            Transparency = head.Transparency,
            CanCollide = head.CanCollide,
            Size = head.Size,
            CFrame = head.CFrame,
        }
        head.Transparency = 1
        head.CanCollide = false
        head.Size = Vector3.new(0.05, 0.05, 0.05)
    end
    for _, inst in ipairs(char:GetChildren()) do
        if inst:IsA("Accessory") then
            local handle = inst:FindFirstChild("Handle")
            if handle and not hmndbreaker.HeadHidden[handle] then
                hmndbreaker.HeadHidden[handle] = {
                    Transparency = handle.Transparency,
                    CanCollide = handle.CanCollide,
                    Size = handle.Size,
                    CFrame = handle.CFrame,
                }
                handle.Transparency = 1
                handle.CanCollide = false
                handle.Size = Vector3.new(0.05, 0.05, 0.05)
            end
        end
    end
end
v555:AddToggle("AntiFlashbang", {
    Text = "Anti Flashbang",
    Default = false,
    Callback = function(val)
        if not val then
            return
        end
        local function findAndPatchFlashbang()
            local replicatedStorage = game:GetService("ReplicatedStorage")
            if not replicatedStorage then return end
            local modules = replicatedStorage:FindFirstChild("Modules")
            if not modules then return end
            local itemLibrary = modules:FindFirstChild("ItemLibrary")
            if not itemLibrary then return end
            local success, itemLib = pcall(function()
                return require(itemLibrary)
            end)
            if success and itemLib and itemLib.Items and itemLib.Items.Flashbang then
                local flashbang = itemLib.Items.Flashbang
                if flashbang then
                    flashbang.BlindDuration = 0
                    if flashbang.Info then
                        flashbang.Info.BlindDuration = 0
                    end
                end
            end
        end
        findAndPatchFlashbang()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        if replicatedStorage then
            replicatedStorage.ChildAdded:Connect(function(child)
                if child.Name == "Modules" then
                    child.ChildAdded:Connect(function(module)
                        if module.Name == "ItemLibrary" then
                            findAndPatchFlashbang()
                        end
                    end)
                end
            end)
        end
    end
})
local unlockAllInitialized = false
_G.Features = _G.Features or {}
_G.Features.Noclip = _G.Features.Noclip or {
    Enabled = false,
    Conn = nil
}
_G.Features.SmoothTextures = _G.Features.SmoothTextures or {
    Enabled = false,
}
_G.Features.BlurryTextures = _G.Features.BlurryTextures or {
    Enabled = false,
    Strength = 14,
}
_G.Features.KillSounds = _G.Features.KillSounds or {
    Enabled = false,
    Sound = "sound 1",
    Volume = 50,
    Pitch = 100,
}
_G.Features.ModDetector = _G.Features.ModDetector or {
    Enabled = true,
    Connection = nil,
    Checking = false
}
_G.Features.WeaponWireframe = _G.Features.WeaponWireframe or {
    Enabled = false,
    Color = Color3.fromRGB(255, 255, 255),
}
local function updnoclip()
    if _G.Features.Noclip.Conn then
        _G.Features.Noclip.Conn:Disconnect()
        _G.Features.Noclip.Conn = nil
    end
    local character = LocalPlayer.Character
    if not character then return end
    if _G.Features.Noclip.Enabled then
        _G.Features.Noclip.Conn = RunService.Stepped:Connect(function()
            local curchar = LocalPlayer.Character
            if not curchar then return end
            for _, part in pairs(curchar:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    if _G.Features.Noclip.Enabled then
        updnoclip()
    end
end)
end
local hitNotifTab = HitGroup:AddTab('Hit Notif')
local rbHitCfg = ragebot.config.hitNotifications
local hitNotificationsToggle = hitNotifTab:AddToggle('HitNotifications', {
    Text = 'hit notifications',
    Default = false,
    Callback = function(val)
        rbHitCfg.enabled = val
        if not val and ragebot.clearHitNotifications then
            ragebot.clearHitNotifications()
        end
    end
}):AddColorPicker('HitNotificationsColor', {
    Default = rbHitCfg.color,
    Title = 'text color',
    Callback = function(val)
        rbHitCfg.color = val
    end
})
local hitNotifDepBox = hitNotifTab:AddDependencyBox()
hitNotifDepBox:AddSlider('HitNotifDuration', {
    Text = 'duration',
    Default = rbHitCfg.duration,
    Min = 1,
    Max = 8,
    Rounding = 1,
    Compact = true,
    Suffix = 's',
    Callback = function(val)
        rbHitCfg.duration = val
    end
})
hitNotifDepBox:AddSlider('HitNotifTextSize', {
    Text = 'text size',
    Default = rbHitCfg.textSize,
    Min = 10,
    Max = 24,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        rbHitCfg.textSize = val
    end
})
hitNotifDepBox:AddSlider('HitNotifMaxVisible', {
    Text = 'max on screen',
    Default = rbHitCfg.maxVisible,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        rbHitCfg.maxVisible = math.clamp(val, 1, 25)
    end
})
local hitNotifPositionDropdown = hitNotifDepBox:AddDropdown('HitNotifPosition', {
    Text = 'position',
    Default = rbHitCfg.position or 'Top Left',
    Values = {
        'Top Left', 'Top Center', 'Top Right',
        'Center Left', 'Center', 'Center Right',
        'Bottom Left', 'Bottom Center', 'Bottom Right',
        'Custom',
    },
    Callback = function(val)
        rbHitCfg.position = val
        if ragebot.applyHitNotifRootPosition then
            ragebot.applyHitNotifRootPosition()
        end
        if Library.UpdateDependencyBoxes then
            Library:UpdateDependencyBoxes()
        end
    end
})
local hitNotifPosDepBox = hitNotifDepBox:AddDependencyBox()
hitNotifPosDepBox:AddSlider('HitNotifOffsetX', {
    Text = 'custom x',
    Default = rbHitCfg.offsetX,
    Min = 0,
    Max = 1200,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        rbHitCfg.offsetX = val
        if ragebot.applyHitNotifRootPosition then
            ragebot.applyHitNotifRootPosition()
        end
    end
})
hitNotifPosDepBox:AddSlider('HitNotifOffsetY', {
    Text = 'custom y',
    Default = rbHitCfg.offsetY,
    Min = 0,
    Max = 800,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        rbHitCfg.offsetY = val
        if ragebot.applyHitNotifRootPosition then
            ragebot.applyHitNotifRootPosition()
        end
    end
})
hitNotifPosDepBox:SetupDependencies({
    { hitNotifPositionDropdown, 'Custom' },
})
hitNotifDepBox:AddSlider('HitNotifStackGap', {
    Text = 'stack gap',
    Default = rbHitCfg.stackGap,
    Min = 2,
    Max = 24,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        rbHitCfg.stackGap = val
    end
})
local hitNotifAnimStyles = ragebot.hitNotifAnimStyles or {
    "fade", "slide left", "slide right", "slide down", "bounce", "fade bounce", "scale",
}
hitNotifDepBox:AddDropdown('HitNotifInAnim', {
    Text = 'in animation',
    Default = rbHitCfg.inAnimation,
    Values = hitNotifAnimStyles,
    Callback = function(val)
        rbHitCfg.inAnimation = val
    end
})
hitNotifDepBox:AddDropdown('HitNotifOutAnim', {
    Text = 'out animation',
    Default = rbHitCfg.outAnimation,
    Values = hitNotifAnimStyles,
    Callback = function(val)
        rbHitCfg.outAnimation = val
    end
})
hitNotifDepBox:AddSlider('HitNotifInSpeed', {
    Text = 'in speed',
    Default = rbHitCfg.animInDuration,
    Min = 0.15,
    Max = 1.5,
    Rounding = 2,
    Compact = true,
    Suffix = 's',
    Callback = function(val)
        rbHitCfg.animInDuration = val
    end
})
hitNotifDepBox:AddSlider('HitNotifOutSpeed', {
    Text = 'out speed',
    Default = rbHitCfg.animOutDuration,
    Min = 0.15,
    Max = 1.5,
    Rounding = 2,
    Compact = true,
    Suffix = 's',
    Callback = function(val)
        rbHitCfg.animOutDuration = val
    end
})
hitNotifDepBox:SetupDependencies({
    { hitNotificationsToggle, true }
})
local deviceBox = Tabs.Misc:AddRightGroupbox('Device Spoofer')
_G.Features.DeviceSpoof = _G.Features.DeviceSpoof or {
    Enabled = false,
    CurrentDevice = "Console",
    LastApplied = 0
}
_G.Features.SlideBoost = _G.Features.SlideBoost or {
    Enabled = false,
    Speed = 300
}
local devicecfgs = {
    ["Mobile"] = {
        Display = "Mobile",
        Code = "Touch"
    },
    ["Console"] = {
        Display = "Console",
        Code = "Gamepad"
    },
    ["VR"] = {
        Display = "VR",
        Code = "VR"
    },
    ["PC"] = {
        Display = "PC",
        Code = "MouseKeyboard"
    }
}
local function dtcrealdevice()
    local inputType = UserInputService:GetLastInputType()
    if inputType == Enum.UserInputType.Touch then
        return "Mobile"
    elseif inputType == Enum.UserInputType.Gamepad1 then
        return "Console"
    elseif inputType == Enum.UserInputType.VR then
        return "VR"
    else
        return "PC"
    end
end
local function applydevice()
    if not _G.Features.DeviceSpoof.Enabled then 
        return 
    end
    local device = _G.Features.DeviceSpoof.CurrentDevice
    local devicecfg = devicecfgs[device]
    if not devicecfg then return end
    local curtime = tick()
    if curtime - _G.Features.DeviceSpoof.LastApplied < 0.5 then
        return
    end
    _G.Features.DeviceSpoof.LastApplied = curtime
    for attempt = 1, 3 do
        local success = pcall(function()
            local remotes = game:GetService("ReplicatedStorage")
            if remotes:FindFirstChild("Remotes") then
                remotes = remotes.Remotes
                if remotes:FindFirstChild("Replication") then
                    remotes = remotes.Replication
                    if remotes:FindFirstChild("Fighter") then
                        remotes = remotes.Fighter
                        if remotes:FindFirstChild("SetControls") then
                            remotes.SetControls:FireServer(devicecfg.Code)
                            return true
                        end
                    end
                end
            end
            return false
        end)
        if success then
            break
        else
            task.wait(0.2)
        end
    end
end
local function reapplydevice()
    if not _G.Features.DeviceSpoof.Enabled then return end
    local curtime = tick()
    if curtime - _G.Features.DeviceSpoof.LastApplied > 30 then
        applydevice()
    end
end
deviceBox:AddToggle('device_spoof', {
    Text = 'enable',
    Default = _G.Features.DeviceSpoof.Enabled,
    Callback = function(Value)
        _G.Features.DeviceSpoof.Enabled = Value
        if Value then
            applydevice()
        end
    end
})
deviceBox:AddDropdown('device_type', {
    Text = 'device',
    Default = _G.Features.DeviceSpoof.CurrentDevice,
    Values = {"Mobile", "Console", "VR", "PC"},
    Callback = function(Value)
        _G.Features.DeviceSpoof.CurrentDevice = Value
        if _G.Features.DeviceSpoof.Enabled then
            applydevice()
        end
    end
})
local slideBox = Tabs.Misc:AddRightGroupbox('Slide Boost')
slideBox:AddToggle('slide_boost', {
    Text = 'enable',
    Default = _G.Features.SlideBoost.Enabled,
    Callback = function(Value)
        _G.Features.SlideBoost.Enabled = Value
    end
})
slideBox:AddSlider('slide_speed', {
    Text = 'slide boost',
    Default = _G.Features.SlideBoost.Speed,
    Min = 50,
    Max = 1000,
    Compact = true,
    Rounding = 0,
    Callback = function(Value)
        _G.Features.SlideBoost.Speed = Value
    end
})
task.spawn(function()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    while not LocalPlayer do
        task.wait()
        LocalPlayer = Players.LocalPlayer
    end
    local mech
    while true do
        local success, result = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.MechanicsController)
        end)
        if success then
            mech = result
            break
        end
        task.wait(1)
    end
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if _G.Features.SlideBoost.Enabled and mech and mech.IsSliding then
            local success = pcall(function()
                mech._sliding_velocity.Velocity = mech._sliding_velocity.Velocity.Unit * _G.Features.SlideBoost.Speed
            end)
            if not success then
                local newSuccess, newMech = pcall(function()
                    return require(LocalPlayer.PlayerScripts.Controllers.MechanicsController)
                end)
                if newSuccess then
                    mech = newMech
                end
            end
        end
    end)
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            connection:Disconnect()
        end
    end)
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if _G.Features.DeviceSpoof.Enabled then
        task.wait(0.5)
        applydevice()
    end
end)
task.spawn(function()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10)
    task.wait(2)
    if _G.Features.DeviceSpoof.Enabled then
        applydevice()
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        reapplydevice()
    end
end)
local Lighting = game:GetService("Lighting")
_G.LightingSettings = _G.LightingSettings or {
    Enabled = false,
    Ambient = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    OutdoorAmbient = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    GlobalShadows = { Enabled = true },
    ShadowSoftness = { Enabled = false, Value = 0.2 },
    SunColor = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ColorShiftTop = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ColorShiftBottom = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ClockTime = { Enabled = false, Value = 12 },
    GeographicLatitude = { Enabled = false, Value = 41.8 },
    Fog = { Enabled = false, Color = Color3.fromRGB(255, 255, 255), Start = 0, End = 100 },
    EnvironmentDiffuseScale = { Enabled = false, Value = 1 },
    EnvironmentSpecularScale = { Enabled = false, Value = 1 },
    ColorCorrection = { Enabled = false, Contrast = 0, Saturation = 0, Brightness = 0 },
    Bloom = { Enabled = false, Multiplier = 0.3, Size = 4, Threshold = 0.7 },
}
local function qolLightingOverrideActive(ls, key)
    if not ls or not ls.Enabled then
        return false
    end
    local entry = ls[key]
    return entry ~= nil and entry.Enabled == true
end
_G.Features.QOL = _G.Features.QOL or {
    MotionBlur          = false,
    MotionBlurAmount    = 8,
    MotionBlurAmplifier = 2,
    SmoothGameplay      = false,
    Shaders             = false,
}
local qolBox = Tabs.Misc:AddLeftGroupbox('QOL')
qolBox:AddToggle('motion_blur_enabled', {
    Text    = 'motion blur',
    Default = false,
    Callback = function(Value)
        _G.Features.QOL.MotionBlur = Value
        if not Value and motionBlur then
            motionBlur.Size = 0
        end
    end
})
qolBox:AddSlider('motion_blur_amount', {
    Text     = 'blur amount',
    Default  = 8,
    Min      = 1,
    Max      = 20,
    Compact  = true,
    Rounding = 0,
    Callback = function(Value)
        _G.Features.QOL.MotionBlurAmount = Value
    end
})
qolBox:AddSlider('motion_blur_amplifier', {
    Text     = 'blur amplifier',
    Default  = 2,
    Min      = 1,
    Max      = 10,
    Compact  = true,
    Rounding = 0,
    Callback = function(Value)
        _G.Features.QOL.MotionBlurAmplifier = Value
    end
})
qolBox:AddToggle('smooth_gameplay', {
    Text    = 'smooth gameplay',
    Default = false,
    Callback = function(Value)
        _G.Features.QOL.SmoothGameplay = Value
    end
})
qolBox:AddToggle('shaders_enabled', {
    Text    = 'shaders',
    Default = false,
    Callback = function(Value)
        _G.Features.QOL.Shaders = Value
        if Value then
            applyultramodaurashadersminecraft()
        else
            removeshaders()
        end
    end
}):AddKeyPicker('shaders_key', {
    Text    = 'Shaders',
    Default = 'None',
    NoUI    = true,
    SyncToggleState = false,
    Mode    = 'Toggle',
    Callback = function(Value)
        _G.Features.QOL.Shaders = Value
        if Value then
            applyultramodaurashadersminecraft()
        else
            removeshaders()
        end
    end
})
local camera     = workspace.CurrentCamera
local lastVector = camera.CFrame.LookVector
local motionBlur = Instance.new("BlurEffect", camera)
motionBlur.Name  = 'QOL_MotionBlur'
motionBlur.Size  = 0
local runsvc2 = game:GetService("RunService")
workspace.Changed:Connect(function(property)
    if property == "CurrentCamera" then
        camera = workspace.CurrentCamera
        if motionBlur and motionBlur.Parent then
            motionBlur.Parent = camera
        else
            motionBlur      = Instance.new("BlurEffect", camera)
            motionBlur.Name = 'QOL_MotionBlur'
            motionBlur.Size = 0
        end
        lastVector = camera.CFrame.LookVector
    end
end)
runsvc2.Heartbeat:Connect(function()
    if not motionBlur or motionBlur.Parent == nil then
        motionBlur      = Instance.new("BlurEffect", camera)
        motionBlur.Name = 'QOL_MotionBlur'
        motionBlur.Size = 0
    end
    if _G.Features.QOL.MotionBlur then
        local magnitude = (camera.CFrame.LookVector - lastVector).Magnitude
        motionBlur.Size = math.abs(magnitude) * _G.Features.QOL.MotionBlurAmount * _G.Features.QOL.MotionBlurAmplifier / 2
    else
        motionBlur.Size = 0
    end
    lastVector = camera.CFrame.LookVector
end)
local TweenService = game:GetService("TweenService")
local origlight   = {}
local origtechnology = nil
local shaderobjs      = {}
local tweenIn  = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tweenOut = TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local function savelightoriginals()
    origlight = {
        Ambient                  = Lighting.Ambient,
        OutdoorAmbient           = Lighting.OutdoorAmbient,
        Brightness               = Lighting.Brightness,
        ClockTime                = Lighting.ClockTime,
        FogEnd                   = Lighting.FogEnd,
        FogStart                 = Lighting.FogStart,
        FogColor                 = Lighting.FogColor,
        ShadowSoftness           = Lighting.ShadowSoftness,
        EnvironmentDiffuseScale  = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        ExposureCompensation     = Lighting.ExposureCompensation,
        ColorShift_Bottom        = Lighting.ColorShift_Bottom,
        ColorShift_Top           = Lighting.ColorShift_Top,
    }
    origtechnology = Lighting.Technology
end
function applyultramodaurashadersminecraft()
    savelightoriginals()
    pcall(function()
        Lighting.Technology = Enum.Technology.Future
    end)
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if not atmosphere then
        atmosphere = Instance.new("Atmosphere")
        atmosphere.Parent = Lighting
        table.insert(shaderobjs, atmosphere)
    end
    atmosphere.Density = 0.30
    atmosphere.Offset = 0.07
    atmosphere.Color = Color3.fromRGB(175, 195, 225)
    atmosphere.Decay = Color3.fromRGB(85, 125, 195)
    atmosphere.Glare = 0.15
    atmosphere.Haze = 0.78
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
        table.insert(shaderobjs, sky)
    end
    sky.SunAngularSize = 7.8
    sky.MoonAngularSize = 9
    local sunRays = Instance.new("SunRaysEffect")
    sunRays.Name = 'QOL_SunRays'
    sunRays.Intensity = 0.075
    sunRays.Spread = 0.90
    sunRays.Parent = Lighting
    table.insert(shaderobjs, sunRays)
    local bloom = Instance.new("BloomEffect")
    bloom.Name = 'QOL_Bloom'
    bloom.Intensity = 0.14
    bloom.Size = 16
    bloom.Threshold = 1.85
    bloom.Parent = Lighting
    table.insert(shaderobjs, bloom)
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = 'QOL_ColorCorrection'
    cc.Brightness = 0.015
    cc.Contrast = 0.20
    cc.Saturation = 0.22
    cc.TintColor = Color3.fromRGB(255, 249, 238)
    cc.Parent = Lighting
    table.insert(shaderobjs, cc)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Name = 'QOL_DOF'
    dof.FarIntensity = 0.045
    dof.NearIntensity = 0.0
    dof.FocusDistance = 80
    dof.InFocusRadius = 58
    dof.Parent = Lighting
    table.insert(shaderobjs, dof)
    local tweenProps = {}
    local ls = _G.LightingSettings
    if not ls or not ls.Enabled then
        tweenProps.Brightness = 2.1
    end
    if not qolLightingOverrideActive(ls, "Ambient") then
        tweenProps.Ambient = Color3.fromRGB(20, 23, 35)
    end
    if not qolLightingOverrideActive(ls, "OutdoorAmbient") then
        tweenProps.OutdoorAmbient = Color3.fromRGB(88, 108, 140)
    end
    if not qolLightingOverrideActive(ls, "ShadowSoftness") then
        tweenProps.ShadowSoftness = 0.20
    end
    if not qolLightingOverrideActive(ls, "EnvironmentDiffuseScale") then
        tweenProps.EnvironmentDiffuseScale = 0.95
    end
    if not qolLightingOverrideActive(ls, "EnvironmentSpecularScale") then
        tweenProps.EnvironmentSpecularScale = 0.98
    end
    if not qolLightingOverrideActive(ls, "ColorShiftTop") then
        tweenProps.ColorShift_Top = Color3.fromRGB(12, 16, 32)
    end
    if not qolLightingOverrideActive(ls, "ColorShiftBottom") then
        tweenProps.ColorShift_Bottom = Color3.fromRGB(6, 10, 25)
    end
    tweenProps.ExposureCompensation = 0.18
    TweenService:Create(Lighting, tweenIn, tweenProps):Play()
    local function refreshShadows()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                pcall(function() v.CastShadow = true end)
            end
        end
    end
    task.spawn(refreshShadows)
    workspace.DescendantAdded:Connect(function(v)
        if _G.Features.QOL.Shaders and v:IsA("BasePart") then
            pcall(function() v.CastShadow = true end)
        end
    end)
end
function removeshaders()
    for _, obj in ipairs(shaderobjs) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    shaderobjs = {}
    pcall(function()
        if origtechnology then
            Lighting.Technology = origtechnology
        end
    end)
    if next(origlight) then
        local tweenProps = {}
        local ls = _G.LightingSettings
        if not ls or not ls.Enabled then
            tweenProps.Brightness = origlight.Brightness
        end
        if not qolLightingOverrideActive(ls, "Ambient") then
            tweenProps.Ambient = origlight.Ambient
        end
        if not qolLightingOverrideActive(ls, "OutdoorAmbient") then
            tweenProps.OutdoorAmbient = origlight.OutdoorAmbient
        end
        if not qolLightingOverrideActive(ls, "ShadowSoftness") then
            tweenProps.ShadowSoftness = origlight.ShadowSoftness
        end
        if not qolLightingOverrideActive(ls, "EnvironmentDiffuseScale") then
            tweenProps.EnvironmentDiffuseScale = origlight.EnvironmentDiffuseScale
        end
        if not qolLightingOverrideActive(ls, "EnvironmentSpecularScale") then
            tweenProps.EnvironmentSpecularScale = origlight.EnvironmentSpecularScale
        end
        if not qolLightingOverrideActive(ls, "ColorShiftTop") then
            tweenProps.ColorShift_Top = origlight.ColorShift_Top
        end
        if not qolLightingOverrideActive(ls, "ColorShiftBottom") then
            tweenProps.ColorShift_Bottom = origlight.ColorShift_Bottom
        end
        tweenProps.ExposureCompensation = origlight.ExposureCompensation
        TweenService:Create(Lighting, tweenOut, tweenProps):Play()
        origlight = {}
    end
end
task.spawn(function()
    local RunService       = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Players          = game:GetService("Players")
    local LocalPlayer      = Players.LocalPlayer
    local FPS_HISTORY = 30
    local fpsBuffer   = {}
    local fpsSum      = 0
    local fpsCursor   = 1
    for i = 1, FPS_HISTORY do fpsBuffer[i] = 60 end
    fpsSum = 60 * FPS_HISTORY
    local lastTime = os.clock()
    RunService:BindToRenderStep('QOL_SmoothGameplay', Enum.RenderPriority.Input.Value, function()
        local now   = os.clock()
        local delta = now - lastTime
        lastTime    = now
        local fps = (delta > 0) and (1 / delta) or 60
        fpsSum    = fpsSum - fpsBuffer[fpsCursor] + fps
        fpsBuffer[fpsCursor] = fps
        fpsCursor = (fpsCursor % FPS_HISTORY) + 1
        local avgFps = fpsSum / FPS_HISTORY
        if _G.Features.QOL.SmoothGameplay then
            if avgFps < 45 then
                pcall(task.desynchronize)
                pcall(task.synchronize)
            end
            pcall(function()
                UserInputService:GetKeysPressed()
                UserInputService:GetMouseDelta()
            end)
        end
    end)
    Players.PlayerRemoving:Connect(function(p)
        if p == LocalPlayer then
            pcall(function() RunService:UnbindFromRenderStep('QOL_SmoothGameplay') end)
            if _G.Features.QOL.Shaders then removeshaders() end
        end
    end)
end)
;(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local guiinset = GuiService:GetGuiInset()
local getAspectStretch = getgenv().InstanceGetAspectStretch
local worldToEspScreen = getgenv().InstanceWorldToScreenEsp or getgenv().InstanceWorldToScreen
local espScreenAnchor = getgenv().InstanceScreenAnchor
_G.Config = _G.Config or {
    Box = {
        MasterEnabled = false,
        Enable = false,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        OutlineColor2 = Color3.fromRGB(255, 255, 255),
        FillColor = Color3.fromRGB(255, 255, 255),
        Filled = { Enable = false, Transparency = 0.5 },
        Healthbar = {
            Enable = false,
            Thickness = 4
        },
        HealthLerpColors = {
            Color1 = Color3.fromRGB(255, 255, 255),
            Color2 = Color3.fromRGB(255, 255, 255),
            Color3 = Color3.fromRGB(255, 255, 255)
        }
    },
    Filled = {
        Enable = false,
        Transparency = 0.7,
        ColorStart = Color3.fromRGB(255, 255, 255),
        ColorEnd = Color3.fromRGB(255, 255, 255),
        Rotation = 0,
        Animated = false,
        Speed = 1,
    },
    Glow = {
        Enable = false,
        Transparency = 0.5,
        ColorStart = Color3.fromRGB(255, 255, 255),
        ColorEnd = Color3.fromRGB(255, 255, 255),
        Rotation = 0,
    },
    TextESP = {
        Names = false,
        Distance = false,
        Tools = false,
        NameSize = 8,
        DistanceSize = 8,
        ToolsSize = 8,
        NameColor = Color3.fromRGB(255, 255, 255),
        NameColor2 = Color3.fromRGB(255, 255, 255),
        DistanceColor = Color3.fromRGB(255, 255, 255),
        DistanceColor2 = Color3.fromRGB(255, 255, 255),
        ToolColor = Color3.fromRGB(255, 255, 255),
        ToolColor2 = Color3.fromRGB(255, 255, 255)
    },
    Skeleton = {
        Enable = false,
        Color = Color3.fromRGB(255, 255, 255),
        Color2 = Color3.fromRGB(255, 255, 255),
        Thickness = 1
    },
    Tracers = {
        Enable = false,
        Color = Color3.fromRGB(255, 255, 255),
        Color2 = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        FromBottom = true
    },
    Chams = {
        Enable = false,
        Color = Color3.fromRGB(255, 255, 255),
        Color2 = Color3.fromRGB(255, 255, 255),
        Transparency = 0
    },
    ESP = {
        HighRefresh = true,
        HealthLerpSpeed = 32,
        TargetHz = 240,
    }
}
_G.ESPObjects = _G.ESPObjects or {}
local ConfigBox = _G.Config.Box
local ESPObjects = _G.ESPObjects
local espgui = Instance.new("ScreenGui")
espgui.Name = "ESP"
espgui.DisplayOrder = 9e9
espgui.ResetOnSpawn = false
espgui.IgnoreGuiInset = true
espgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
espgui.Parent = game.CoreGui
local r15bones = {
    {"UpperTorso", "Head"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}
local r6bones = {
    {"Torso", "Head"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"}
}
local fonts = {}
local fontok = pcall(function()
    local fontid = "esp_font.ttf"
    if not isfile(fontid) then
        writefile(fontid, game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf"))
    end
    if isfile("esp_font.font") then delfile("esp_font.font") end
    local fontdata = {
        name = "ESPFont",
        faces = {{ name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(fontid) }}
    }
    writefile("esp_font.font", HttpService:JSONEncode(fontdata))
    fonts.main = Font.new(getcustomasset("esp_font.font"))
end)
if not fontok then
    fonts.main = Font.fromEnum(Enum.Font.Code)
end
local tickval = 0
local function lerpcolor(a, b, t)
    return Color3.new(
        a.R + (b.R - a.R) * t,
        a.G + (b.G - a.G) * t,
        a.B + (b.B - a.B) * t
    )
end
local function ensureTextGradient(label, color1, color2)
    if not label then return end
    local grad = label:FindFirstChild("EspTextGradient")
    if not grad then
        grad = Instance.new("UIGradient")
        grad.Name = "EspTextGradient"
        grad.Rotation = 0
        grad.Parent = label
    end
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2),
    })
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
end
local function hpcolor(pct)
    local hc = ConfigBox.HealthLerpColors or {
        Color1 = Color3.fromRGB(0, 255, 0),
        Color2 = Color3.fromRGB(255, 255, 0),
        Color3 = Color3.fromRGB(255, 0, 0)
    }
    if pct > 0.5 then
        return lerpcolor(hc.Color2, hc.Color1, (pct - 0.5) * 2)
    else
        return lerpcolor(hc.Color3, hc.Color2, pct * 2)
    end
end
local function checkteammate(player)
    if not player or player == LocalPlayer then return true end
    local myTeam = LocalPlayer:GetAttribute("TeamID")
    local theirTeam = player:GetAttribute("TeamID")
    if myTeam ~= nil and theirTeam ~= nil then
        return myTeam == theirTeam
    end
    return LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team
end
local function findBonePart(char, name)
    local part = char:FindFirstChild(name)
    if part and part:IsA("BasePart") then return part end
    local aliases = {
        ["Left Arm"] = {"LeftArm", "LeftUpperArm"},
        ["Right Arm"] = {"RightArm", "RightUpperArm"},
        ["Left Leg"] = {"LeftLeg", "LeftUpperLeg"},
        ["Right Leg"] = {"RightLeg", "RightUpperLeg"},
        ["Torso"] = {"UpperTorso", "LowerTorso"},
    }
    for _, alt in ipairs(aliases[name] or {}) do
        part = char:FindFirstChild(alt)
        if part and part:IsA("BasePart") then return part end
    end
    return nil
end
local function espknock(player)
    local char = player.Character
    if not char then return false end
    local bodyEffects = char:FindFirstChild("BodyEffects")
    if bodyEffects then
        local ko = bodyEffects:FindFirstChild("K.O") or bodyEffects:FindFirstChild("KO")
        return ko and ko.Value
    end
    return false
end
local function dist2(player)
    local char = player.Character
    local myChar = LocalPlayer.Character
    if char and myChar then
        local root = char:FindFirstChild("HumanoidRootPart")
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if root and myRoot then
            return (root.Position - myRoot.Position).Magnitude
        end
    end
    return math.huge
end
local function playerweap(player)
    return getEspPlayerWeapon(player)
end
local function makelabel(parent)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Size = UDim2.new(0, 200, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextScaled = false
    label.TextSize = 6
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.FontFace = fonts.main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    return label
end
local function CreateCham(char)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = char
    highlight.FillColor = _G.Config.Chams.Color
    highlight.OutlineColor = _G.Config.Chams.Color2 or _G.Config.Chams.Color
    highlight.FillTransparency = _G.Config.Chams.Transparency
    highlight.OutlineTransparency = math.clamp(_G.Config.Chams.Transparency, 0, 1)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    return highlight
end
local function CreateBox(player)
    if ESPObjects[player] then return end
    local box = {}
    box.box = {}
    box.box.square = Drawing.new("Square")
    box.box.inline = Drawing.new("Square")
    box.box.outline = Drawing.new("Square")
    box.filled = Instance.new("Frame")
    box.filled.BackgroundColor3 = Color3.new(1, 1, 1)
    box.filled.BackgroundTransparency = _G.Config.Filled.Transparency
    box.filled.BorderSizePixel = 0
    box.filled.Visible = false
    box.filled.ZIndex = 2
    box.filled.Parent = espgui
    box.filled_gradient = Instance.new("UIGradient")
    box.filled_gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Config.Filled.ColorStart),
        ColorSequenceKeypoint.new(1, _G.Config.Filled.ColorEnd),
    })
    box.filled_gradient.Rotation = 0
    box.filled_gradient.Parent = box.filled
    box.glow = Instance.new("ImageLabel")
    box.glow.Image = "rbxassetid://110204605000367"
    box.glow.ScaleType = Enum.ScaleType.Slice
    box.glow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
    box.glow.AutomaticSize = Enum.AutomaticSize.XY
    box.glow.ImageTransparency = _G.Config.Glow.Transparency
    box.glow.ResampleMode = Enum.ResamplerMode.Pixelated
    box.glow.BackgroundTransparency = 1
    box.glow.BorderSizePixel = 0
    box.glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.glow.ZIndex = 1
    box.glow.Visible = false
    box.glow.Parent = espgui
    box.glow_gradient = Instance.new("UIGradient")
    box.glow_gradient.Rotation = _G.Config.Glow.Rotation
    box.glow_gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Config.Glow.ColorStart),
        ColorSequenceKeypoint.new(1, _G.Config.Glow.ColorEnd),
    })
    box.glow_gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0),
    })
    box.glow_gradient.Parent = box.glow
    local glowpadding = Instance.new("UIPadding")
    glowpadding.PaddingTop    = UDim.new(0, 21)
    glowpadding.PaddingBottom = UDim.new(0, 20)
    glowpadding.PaddingLeft   = UDim.new(0, 21)
    glowpadding.PaddingRight  = UDim.new(0, 20)
    glowpadding.Parent = box.glow
    box.bars = {}
    box.bars.hp_bars = {}
    box.bars.hp_outline = Drawing.new("Square")
    box.bars.last_hp = 1
    for i = 1, 50 do
        box.bars.hp_bars[i] = Drawing.new("Line")
    end
    box.skeleton = {lines = {}, outlines = {}}
    for i = 1, 15 do
        local outline = Drawing.new("Line")
        outline.Color = Color3.new(0, 0, 0)
        outline.Thickness = 3
        outline.Visible = false
        box.skeleton.outlines[i] = outline
        local line = Drawing.new("Line")
        line.Color = Color3.new(1, 1, 1)
        line.Thickness = 1
        line.Visible = false
        box.skeleton.lines[i] = line
    end
    local studsgui = Instance.new("ScreenGui", game.CoreGui)
    local namegui = Instance.new("ScreenGui", game.CoreGui)
    local toolgui = Instance.new("ScreenGui", game.CoreGui)
    box.text = {}
    box.text.studs = makelabel(studsgui)
    box.text.tool = makelabel(toolgui)
    box.text.name = makelabel(namegui)
    box.Tracer = Drawing.new("Line")
    box.Tracer.Visible = false
    box.Tracer.Color = _G.Config.Tracers.Color or Color3.fromRGB(255, 255, 255)
    box.Tracer.Thickness = _G.Config.Tracers.Thickness or 1
    ESPObjects[player] = box
end
local function RemoveBox(player)
    if ESPObjects[player] then
        local box = ESPObjects[player]
        if box.box then
            box.box.square:Remove()
            box.box.outline:Remove()
            box.box.inline:Remove()
        end
        if box.filled then box.filled:Destroy() end
        if box.glow then box.glow:Destroy() end
        if box.text then
            if box.text.studs then box.text.studs.Parent:Destroy() end
            if box.text.tool then box.text.tool.Parent:Destroy() end
            if box.text.name then box.text.name.Parent:Destroy() end
        end
        if box.bars then
            box.bars.hp_outline:Remove()
            for _, line in pairs(box.bars.hp_bars) do
                line:Remove()
            end
        end
        if box.skeleton then
            for _, line in pairs(box.skeleton.lines) do
                line:Remove()
            end
            for _, outline in pairs(box.skeleton.outlines) do
                outline:Remove()
            end
        end
        if box.Tracer then box.Tracer:Remove() end
        if box.Cham then
            box.Cham:Destroy()
            box.Cham = nil
        end
        ESPObjects[player] = nil
    end
end
local function hideesp(player)
    if not ESPObjects[player] then return end
    local box = ESPObjects[player]
    if box.box then
        box.box.square.Visible = false
        box.box.outline.Visible = false
        box.box.inline.Visible = false
    end
    if box.filled then box.filled.Visible = false end
    if box.glow then box.glow.Visible = false end
    if box.text then
        box.text.studs.Visible = false
        box.text.tool.Visible = false
        box.text.name.Visible = false
    end
    if box.bars then
        box.bars.hp_outline.Visible = false
        for _, line in pairs(box.bars.hp_bars) do
            line.Visible = false
        end
    end
    if box.skeleton then
        for _, line in pairs(box.skeleton.lines) do
            line.Visible = false
        end
        for _, outline in pairs(box.skeleton.outlines) do
            outline.Visible = false
        end
    end
    if box.Tracer then box.Tracer.Visible = false end
    if box.Cham then
        box.Cham.Enabled = false
    end
end
local function updatecham(player, box, char)
    if not _G.Config.Chams.Enable then
        if box.Cham then
            box.Cham.Enabled = false
        end
        return
    end
    if not box.Cham or not box.Cham.Parent then
        box.Cham = CreateCham(char)
    end
    if box.Cham then
        box.Cham.Enabled = true
        box.Cham.FillColor = _G.Config.Chams.Color
        box.Cham.OutlineColor = _G.Config.Chams.Color2 or _G.Config.Chams.Color
        box.Cham.FillTransparency = _G.Config.Chams.Transparency
        box.Cham.OutlineTransparency = math.clamp(_G.Config.Chams.Transparency, 0, 1)
    end
end
local function drawskeleton(player, box, char, hum, size, position)
    if not _G.Config.Skeleton.Enable then
        for _, line in pairs(box.skeleton.lines) do line.Visible = false end
        for _, outline in pairs(box.skeleton.outlines) do outline.Visible = false end
        return
    end
    local bones = (hum.RigType == Enum.HumanoidRigType.R15) and r15bones or r6bones
    local skelColor = _G.Config.Skeleton.Color or Color3.fromRGB(255, 255, 255)
    local skelColor2 = _G.Config.Skeleton.Color2 or skelColor
    local skelThickness = _G.Config.Skeleton.Thickness or 1
    for i = 1, 15 do
        local boneset = bones[i]
        local line = box.skeleton.lines[i]
        local outline = box.skeleton.outlines[i]
        if boneset then
            local parta = findBonePart(char, boneset[1])
            local partb = findBonePart(char, boneset[2])
            if parta and partb then
                local va, vaOk = worldToEspScreen(parta.Position)
                local vb, vbOk = worldToEspScreen(partb.Position)
                if vaOk and vbOk then
                    local pos2 = Vector2.new(va.X, va.Y)
                    local endpos = Vector2.new(vb.X, vb.Y)
                    local midX = (pos2.X + endpos.X) * 0.5
                    local lineColor = midX >= pos2.X and lerpcolor(skelColor, skelColor2, math.clamp((midX - pos2.X) / math.max(math.abs(endpos.X - pos2.X), 1), 0, 1)) or skelColor
                    outline.Visible = true
                    outline.From = pos2
                    outline.To = endpos
                    outline.Thickness = skelThickness + 2
                    outline.Color = Color3.new(0, 0, 0)
                    line.Visible = true
                    line.From = pos2
                    line.To = endpos
                    line.Color = lineColor
                    line.Thickness = skelThickness
                else
                    line.Visible = false
                    outline.Visible = false
                end
            else
                line.Visible = false
                outline.Visible = false
            end
        else
            line.Visible = false
            outline.Visible = false
        end
    end
end
local function drawhealthbar(player, box, hum, size, position, dt)
    if not (ConfigBox.Healthbar and ConfigBox.Healthbar.Enable) then
        box.bars.hp_outline.Visible = false
        for _, line in pairs(box.bars.hp_bars) do line.Visible = false end
        return
    end
    local target = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
    local last = box.bars.last_hp or target
    local espCfg = _G.Config.ESP or {}
    local lerpSpeed = espCfg.HealthLerpSpeed or 32
    if espCfg.HighRefresh ~= false then
        dt = dt or (1 / (espCfg.TargetHz or 240))
        local lerped = last + (target - last) * math.min(1, dt * lerpSpeed)
        box.bars.last_hp = lerped
    else
        box.bars.last_hp = last + (target - last) * 0.05
    end
    local lerped = box.bars.last_hp
    local h = math.ceil(size.Y * lerped)
    local hpx = position.X - 5
    local hpystart = position.Y + (size.Y - h)
    box.bars.hp_outline.Visible = true
    box.bars.hp_outline.Position = Vector2.new(hpx - 1, position.Y - 1)
    box.bars.hp_outline.Size = Vector2.new(3, size.Y + 2)
    box.bars.hp_outline.Color = Color3.new(0, 0, 0)
    box.bars.hp_outline.Filled = false
    local segments = math.max(math.min(math.floor(h / 2), 50), 10)
    for i = 1, 50 do
        local line = box.bars.hp_bars[i]
        if i <= segments then
            local segmentheight = h / segments
            local yoffset = (i - 1) * segmentheight
            local pospct = 1 - ((yoffset + (size.Y - h)) / size.Y)
            line.Visible = true
            line.From = Vector2.new(hpx, hpystart + yoffset)
            line.To = Vector2.new(hpx + 1, hpystart + yoffset)
            line.Color = hpcolor(pospct)
            line.Thickness = math.max(segmentheight, 1)
        else
            line.Visible = false
        end
    end
end
local function drawbox(player, box, size, position)
    if not (ConfigBox.MasterEnabled and ConfigBox.Enable) then
        box.box.square.Visible = false
        box.box.outline.Visible = false
        box.box.inline.Visible = false
        return
    end
    local w = math.max(math.floor(size.X), 4)
    local h = math.max(math.floor(size.Y), 8)
    size = Vector2.new(w, h)
    position = Vector2.new(math.floor(position.X), math.floor(position.Y))
    box.box.square.Visible = true
    box.box.square.Position = position
    box.box.square.Size = size
    local boxColor2 = ConfigBox.OutlineColor2 or ConfigBox.OutlineColor
    box.box.square.Color = lerpcolor(ConfigBox.OutlineColor, boxColor2, 0.5)
    box.box.square.Thickness = 1
    box.box.square.Filled = false
    box.box.outline.Visible = true
    box.box.outline.Position = position - Vector2.new(1, 1)
    box.box.outline.Size = size + Vector2.new(2, 2)
    box.box.outline.Color = Color3.new(0, 0, 0)
    box.box.outline.Thickness = 1
    box.box.outline.Filled = false
    box.box.inline.Visible = true
    box.box.inline.Position = position + Vector2.new(1, 1)
    box.box.inline.Size = Vector2.new(math.max(w - 2, 2), math.max(h - 2, 4))
    box.box.inline.Color = Color3.new(0, 0, 0)
    box.box.inline.Thickness = 1
    box.box.inline.Filled = false
end
local function drawfill(player, box, size, position)
    local cfg = _G.Config.Filled
    if not cfg.Enable then
        box.filled.Visible = false
        return
    end
    box.filled.Visible = true
    box.filled.BackgroundTransparency = cfg.Transparency
    box.filled.Position = UDim2.fromOffset(position.X, position.Y)
    box.filled.Size = UDim2.fromOffset(size.X, size.Y)
    box.filled_gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, cfg.ColorStart),
        ColorSequenceKeypoint.new(1, cfg.ColorEnd),
    })
    if cfg.Animated then
        box.filled_gradient.Rotation = (math.sin(tickval * cfg.Speed) * 90) + cfg.Rotation
    else
        box.filled_gradient.Rotation = cfg.Rotation
    end
end
local function drawglow(player, box, size, position)
    local cfg = _G.Config.Glow
    if not cfg.Enable or not (ConfigBox.MasterEnabled and ConfigBox.Enable) then
        box.glow.Visible = false
        return
    end
    box.glow.Visible = true
    box.glow.ImageTransparency = cfg.Transparency
    box.glow.ImageColor3 = cfg.ColorStart
    box.glow.Position = UDim2.fromOffset(position.X - 21, position.Y - 21)
    box.glow.Size = UDim2.fromOffset(size.X + 42, size.Y + 42)
    box.glow_gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, cfg.ColorStart),
        ColorSequenceKeypoint.new(1, cfg.ColorEnd),
    })
    box.glow_gradient.Rotation = 0
end
local function drawtext(player, box, size, position, distance)
    local basey = position.Y - guiinset.Y
    if _G.Config.TextESP and _G.Config.TextESP.Names then
        box.text.name.Visible = true
        box.text.name.Position = UDim2.new(0, position.X + (size.X / 2) - 100, 0, basey - 15)
        box.text.name.Text = player.Name
        box.text.name.TextSize = _G.Config.TextESP.NameSize or 13
        ensureTextGradient(box.text.name, _G.Config.TextESP.NameColor or Color3.fromRGB(255, 255, 255), _G.Config.TextESP.NameColor2 or _G.Config.TextESP.NameColor or Color3.fromRGB(255, 255, 255))
        box.text.name.TextXAlignment = Enum.TextXAlignment.Center
    else
        box.text.name.Visible = false
    end
    if _G.Config.TextESP and _G.Config.TextESP.Tools then
        box.text.tool.Visible = true
        box.text.tool.Position = UDim2.new(0, position.X + size.X + 5, 0, basey)
        box.text.tool.Text = playerweap(player)
        box.text.tool.TextSize = _G.Config.TextESP.ToolsSize or 11
        ensureTextGradient(box.text.tool, _G.Config.TextESP.ToolColor or Color3.fromRGB(255, 255, 255), _G.Config.TextESP.ToolColor2 or _G.Config.TextESP.ToolColor or Color3.fromRGB(255, 255, 255))
        box.text.tool.TextXAlignment = Enum.TextXAlignment.Left
    else
        box.text.tool.Visible = false
    end
    if _G.Config.TextESP and _G.Config.TextESP.Distance then
        box.text.studs.Visible = true
        box.text.studs.Position = UDim2.new(0, position.X + (size.X / 2) - 100, 0, basey + size.Y + 2)
        box.text.studs.Text = string.format("%.0f studs", distance)
        box.text.studs.TextSize = _G.Config.TextESP.DistanceSize or 11
        ensureTextGradient(box.text.studs, _G.Config.TextESP.DistanceColor or Color3.fromRGB(255, 255, 255), _G.Config.TextESP.DistanceColor2 or _G.Config.TextESP.DistanceColor or Color3.fromRGB(255, 255, 255))
        box.text.studs.TextXAlignment = Enum.TextXAlignment.Center
    else
        box.text.studs.Visible = false
    end
end
local function drawtracers(player, box, root)
    if not (_G.Config.Tracers and _G.Config.Tracers.Enable) then
        box.Tracer.Visible = false
        return
    end
    local pos, vis = worldToEspScreen(root.Position)
    if vis then
        box.Tracer.Visible = true
        box.Tracer.To = Vector2.new(pos.X, pos.Y)
        box.Tracer.From = (_G.Config.Tracers.FromBottom == nil or _G.Config.Tracers.FromBottom)
            and espScreenAnchor(0.5, 1)
            or espScreenAnchor(0.5, 0.5)
        box.Tracer.Color = lerpcolor(_G.Config.Tracers.Color or Color3.fromRGB(255, 255, 255), _G.Config.Tracers.Color2 or _G.Config.Tracers.Color or Color3.fromRGB(255, 255, 255), 0.5)
        box.Tracer.Thickness = _G.Config.Tracers.Thickness or 1
    else
        box.Tracer.Visible = false
    end
end
local function getHitboxBounds(char)
    local cam = workspace.CurrentCamera
    if not cam or not char then
        return nil, nil
    end
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local found = false
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 and part.Size.Magnitude > 0 then
            local cframe = part.CFrame
            local size = part.Size
            local corners = {
                cframe * Vector3.new(-size.X / 2, -size.Y / 2, -size.Z / 2),
                cframe * Vector3.new( size.X / 2, -size.Y / 2, -size.Z / 2),
                cframe * Vector3.new(-size.X / 2,  size.Y / 2, -size.Z / 2),
                cframe * Vector3.new( size.X / 2,  size.Y / 2, -size.Z / 2),
                cframe * Vector3.new(-size.X / 2, -size.Y / 2,  size.Z / 2),
                cframe * Vector3.new( size.X / 2, -size.Y / 2,  size.Z / 2),
                cframe * Vector3.new(-size.X / 2,  size.Y / 2,  size.Z / 2),
                cframe * Vector3.new( size.X / 2,  size.Y / 2,  size.Z / 2),
            }
            for _, corner in ipairs(corners) do
                local screenPos, ok = worldToEspScreen(corner, cam)
                if ok then
                    found = true
                    minX = math.min(minX, screenPos.X)
                    minY = math.min(minY, screenPos.Y)
                    maxX = math.max(maxX, screenPos.X)
                    maxY = math.max(maxY, screenPos.Y)
                end
            end
        end
    end
    if not found then
        return nil, nil
    end
    return Vector2.new(math.max(maxX - minX, 4), math.max(maxY - minY, 8)), Vector2.new(minX, minY)
end
local function updateesp(player, dt)
    if not player or not ESPObjects[player] then return end
    if not ConfigBox.MasterEnabled then
        hideesp(player)
        return
    end
    if player == LocalPlayer or checkteammate(player) then
        hideesp(player)
        return
    end
    local char = player.Character
    if not char or espknock(player) then
        hideesp(player)
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not root or not hum then
        hideesp(player)
        return
    end
    local hrp2d, hrpOk = worldToEspScreen(root.Position)
    if not hrpOk then
        hideesp(player)
        return
    end
    local distance = dist2(player)
    local hitboxSize, hitboxPosition = getHitboxBounds(char)
    local size, position
    if hitboxSize and hitboxPosition then
        size = Vector2.new(math.max(math.floor(hitboxSize.X), 4), math.max(math.floor(hitboxSize.Y), 8))
        position = Vector2.new(math.floor(hitboxPosition.X), math.floor(hitboxPosition.Y))
    else
        local head = char:FindFirstChild("Head")
        local topWorld = (head and head.Position + Vector3.new(0, 0.5, 0)) or (root.Position + Vector3.new(0, 3, 0))
        local bottomWorld = root.Position - Vector3.new(0, 3, 0)
        local top2d, topOk = worldToEspScreen(topWorld)
        local bottom2d, bottomOk = worldToEspScreen(bottomWorld)
        if not topOk or not bottomOk then
            hideesp(player)
            return
        end
        local boxHeight = math.abs(bottom2d.Y - top2d.Y)
        local boxWidth = math.max(boxHeight * 0.55, 8)
        size = Vector2.new(math.max(math.floor(boxWidth), 4), math.max(math.floor(math.max(boxHeight, 10)), 8))
        position = Vector2.new(math.floor(hrp2d.X - size.X / 2), math.floor(math.min(top2d.Y, bottom2d.Y)))
    end
    local box = ESPObjects[player]
    local cfg = _G.Config
    drawfill(player, box, size, position)
    drawbox(player, box, size, position)
    drawglow(player, box, size, position)
    if cfg.Skeleton and cfg.Skeleton.Enable then
        drawskeleton(player, box, char, hum, size, position)
    else
        for _, line in pairs(box.skeleton.lines) do line.Visible = false end
        for _, outline in pairs(box.skeleton.outlines) do outline.Visible = false end
    end
    drawhealthbar(player, box, hum, size, position, dt)
    drawtext(player, box, size, position, distance)
    if cfg.Tracers and cfg.Tracers.Enable then
        drawtracers(player, box, root)
    elseif box.Tracer then
        box.Tracer.Visible = false
    end
    if cfg.Chams and cfg.Chams.Enable then
        updatecham(player, box, char)
    elseif box.Cham then
        box.Cham.Enabled = false
    end
end
local ESP_RENDER_BIND = "InstanceESPUpdate"
local _espMasterWasOn = false
local function stepEspUpdate(dt)
    dt = dt or (1 / (_G.Config.ESP and _G.Config.ESP.TargetHz or 240))
    local cam = workspace.CurrentCamera
    if cam then
        Camera = cam
    end
    tickval = os.clock()
    if not ConfigBox.MasterEnabled then
        if _espMasterWasOn then
            _espMasterWasOn = false
            for plr in pairs(ESPObjects) do
                hideesp(plr)
            end
        end
        return
    end
    _espMasterWasOn = true
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            updateesp(plr, dt)
        end
    end
end
local espBindOk = pcall(function()
    RunService:UnbindFromRenderStep(ESP_RENDER_BIND)
    RunService:BindToRenderStep(ESP_RENDER_BIND, Enum.RenderPriority.Camera.Value + 1, stepEspUpdate)
end)
if not espBindOk then
    RunService.RenderStepped:Connect(stepEspUpdate)
end
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateBox(player)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateBox(player)
    end
end)
Players.PlayerRemoving:Connect(RemoveBox)
local v67 = Tabs.Visuals:AddLeftGroupbox("esp")
v67:AddToggle('box_enabled', {
    Text = 'enable',
    Default = ConfigBox.MasterEnabled or false,
    Callback = function(Value)
        ConfigBox.MasterEnabled = Value
    end
})
local BoxDepBox = v67:AddDependencyBox()
BoxDepBox:AddToggle('box_enabled2', {
    Text = 'boxes',
    Default = ConfigBox.Enable or false,
    Callback = function(Value)
        ConfigBox.Enable = Value
    end
}):AddColorPicker('box_outline_color', {
    Title = 'box color 1',
    Default = ConfigBox.OutlineColor or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        ConfigBox.OutlineColor = Value
    end
}):AddColorPicker('box_outline_color2', {
    Title = 'box color 2',
    Default = ConfigBox.OutlineColor2 or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        ConfigBox.OutlineColor2 = Value
    end
})
BoxDepBox:AddToggle('box_filled', {
    Text = 'box fill',
    Default = _G.Config.Filled.Enable or false,
    Callback = function(Value)
        _G.Config.Filled.Enable = Value
    end
}):AddColorPicker('box_filled_color_start', {
    Title = 'fill color start',
    Default = _G.Config.Filled.ColorStart or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Filled.ColorStart = Value
    end
}):AddColorPicker('box_filled_color_end', {
    Title = 'fill color end',
    Default = _G.Config.Filled.ColorEnd or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Filled.ColorEnd = Value
    end
})
BoxDepBox:AddToggle('box_filled_animated', {
    Text = 'fill rotation',
    Default = _G.Config.Filled.Animated or false,
    Callback = function(Value)
        _G.Config.Filled.Animated = Value
    end
})
BoxDepBox:AddToggle('box_glow', {
    Text = 'box glow',
    Default = _G.Config.Glow.Enable or false,
    Callback = function(Value)
        _G.Config.Glow.Enable = Value
    end
}):AddColorPicker('box_glow_color_start', {
    Title = 'glow color start',
    Default = _G.Config.Glow.ColorStart or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Glow.ColorStart = Value
    end
}):AddColorPicker('box_glow_color_end', {
    Title = 'glow color end',
    Default = _G.Config.Glow.ColorEnd or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Glow.ColorEnd = Value
    end
})
BoxDepBox:AddToggle('healthbar', {
    Text = 'healthbar',
    Default = (ConfigBox.Healthbar and ConfigBox.Healthbar.Enable) or false,
    Callback = function(Value)
        if not ConfigBox.Healthbar then
            ConfigBox.Healthbar = { Enable = false, Thickness = 4 }
        end
        ConfigBox.Healthbar.Enable = Value
    end
}):AddColorPicker('ColorPicker121212', {
    Default = (ConfigBox.HealthLerpColors and ConfigBox.HealthLerpColors.Color1) or Color3.fromRGB(255, 255, 255),
    Title = 'high health',
    Transparency = 0,
    Callback = function(Value)
        if not ConfigBox.HealthLerpColors then
            ConfigBox.HealthLerpColors = {
                Color1 = Color3.fromRGB(255, 255, 255),
                Color2 = Color3.fromRGB(255, 255, 255),
                Color3 = Color3.fromRGB(255, 255, 255)
            }
        end
        ConfigBox.HealthLerpColors.Color1 = Value
    end
}):AddColorPicker('ColorPicker21', {
    Default = (ConfigBox.HealthLerpColors and ConfigBox.HealthLerpColors.Color2) or Color3.fromRGB(255, 255, 255),
    Title = 'mid health',
    Transparency = 0,
    Callback = function(Value)
        if not ConfigBox.HealthLerpColors then
            ConfigBox.HealthLerpColors = {
                Color1 = Color3.fromRGB(255, 255, 255),
                Color2 = Color3.fromRGB(255, 255, 255),
                Color3 = Color3.fromRGB(255, 255, 255)
            }
        end
        ConfigBox.HealthLerpColors.Color2 = Value
    end
}):AddColorPicker('ColorPicker45', {
    Default = (ConfigBox.HealthLerpColors and ConfigBox.HealthLerpColors.Color3) or Color3.fromRGB(255, 255, 255),
    Title = 'low health',
    Transparency = 0,
    Callback = function(Value)
        if not ConfigBox.HealthLerpColors then
            ConfigBox.HealthLerpColors = {
                Color1 = Color3.fromRGB(255, 255, 255),
                Color2 = Color3.fromRGB(255, 255, 255),
                Color3 = Color3.fromRGB(255, 255, 255)
            }
        end
        ConfigBox.HealthLerpColors.Color3 = Value
    end
})
v67:AddToggle('textesp', {
    Text = 'names',
    Default = _G.Config.TextESP.Names or false,
    Callback = function(Value)
        _G.Config.TextESP.Names = Value
    end
}):AddColorPicker('name_color', {
    Title = 'name color 1',
    Default = _G.Config.TextESP.NameColor or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.TextESP.NameColor = Value
    end
}):AddColorPicker('name_color2', {
    Title = 'name color 2',
    Default = _G.Config.TextESP.NameColor2 or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.TextESP.NameColor2 = Value
    end
})
v67:AddToggle('textesp_distance', {
    Text = 'distance',
    Default = _G.Config.TextESP.Distance or false,
    Callback = function(Value)
        _G.Config.TextESP.Distance = Value
    end
}):AddColorPicker('distance_color', {
    Title = 'distance color 1',
    Default = _G.Config.TextESP.DistanceColor or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.TextESP.DistanceColor = Value
    end
}):AddColorPicker('distance_color2', {
    Title = 'distance color 2',
    Default = _G.Config.TextESP.DistanceColor2 or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.TextESP.DistanceColor2 = Value
    end
})
v67:AddToggle('textesp_tools', {
    Text = 'tools',
    Default = _G.Config.TextESP.Tools or false,
    Callback = function(Value)
        _G.Config.TextESP.Tools = Value
    end
}):AddColorPicker('tool_color', {
    Title = 'tool color 1',
    Default = _G.Config.TextESP.ToolColor or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.TextESP.ToolColor = Value
    end
}):AddColorPicker('tool_color2', {
    Title = 'tool color 2',
    Default = _G.Config.TextESP.ToolColor2 or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.TextESP.ToolColor2 = Value
    end
})
v67:AddToggle('skeleton', {
    Text = 'skeleton',
    Default = _G.Config.Skeleton.Enable or false,
    Callback = function(Value)
        _G.Config.Skeleton.Enable = Value
    end
}):AddColorPicker('skeleton_color', {
    Title = 'skeleton color 1',
    Default = _G.Config.Skeleton.Color or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Skeleton.Color = Value
    end
}):AddColorPicker('skeleton_color2', {
    Title = 'skeleton color 2',
    Default = _G.Config.Skeleton.Color2 or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Skeleton.Color2 = Value
    end
})
v67:AddToggle('tracers', {
    Text = 'tracers',
    Default = _G.Config.Tracers.Enable or false,
    Callback = function(Value)
        _G.Config.Tracers.Enable = Value
    end
}):AddColorPicker('tracers_color', {
    Title = 'tracer color 1',
    Default = _G.Config.Tracers.Color or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Tracers.Color = Value
    end
}):AddColorPicker('tracers_color2', {
    Title = 'tracer color 2',
    Default = _G.Config.Tracers.Color2 or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Tracers.Color2 = Value
    end
})
v67:AddToggle('chams', {
    Text = 'chams',
    Default = _G.Config.Chams.Enable or false,
    Callback = function(Value)
        _G.Config.Chams.Enable = Value
    end
}):AddColorPicker('chams_color', {
    Title = 'chams color 1',
    Default = _G.Config.Chams.Color or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Chams.Color = Value
    end
}):AddColorPicker('chams_color2', {
    Title = 'chams color 2',
    Default = _G.Config.Chams.Color2 or Color3.fromRGB(255, 255, 255),
    Transparency = false,
    Callback = function(Value)
        _G.Config.Chams.Color2 = Value
    end
})
v67:AddSlider('box_filled_transparency', {
    Text = 'fill transparency',
    Default = _G.Config.Filled.Transparency or 0.7,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(Value)
        _G.Config.Filled.Transparency = Value
    end
})
v67:AddSlider('box_filled_rotation', {
    Text = 'fill rotation',
    Default = _G.Config.Filled.Rotation or 0,
    Min = 0,
    Max = 360,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        _G.Config.Filled.Rotation = Value
    end
})
v67:AddSlider('box_filled_speed', {
    Text = 'fill speed',
    Default = _G.Config.Filled.Speed or 1,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        _G.Config.Filled.Speed = Value
    end
})
v67:AddSlider('box_glow_transparency', {
    Text = 'glow transparency',
    Default = _G.Config.Glow.Transparency or 0.80,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(Value)
        _G.Config.Glow.Transparency = Value
    end
})
v67:AddSlider('box_glow_rotation', {
    Text = 'glow rotation',
    Default = _G.Config.Glow.Rotation or 0,
    Min = 0,
    Max = 360,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        _G.Config.Glow.Rotation = Value
    end
})
v67:AddSlider('textesp_namesize', {
    Text = 'name size',
    Default = _G.Config.TextESP.NameSize or 8,
    Min = 8,
    Max = 16,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        _G.Config.TextESP.NameSize = Value
    end
})
v67:AddSlider('textesp_distancesize', {
    Text = 'distance size',
    Default = _G.Config.TextESP.DistanceSize or 8,
    Min = 8,
    Max = 14,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        _G.Config.TextESP.DistanceSize = Value
    end
})
v67:AddSlider('textesp_toolssize', {
    Text = 'tools size',
    Default = _G.Config.TextESP.ToolsSize or 8,
    Min = 8,
    Max = 14,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        _G.Config.TextESP.ToolsSize = Value
    end
})
v67:AddSlider('skeleton_thickness', {
    Text = 'skeleton thickness',
    Default = _G.Config.Skeleton.Thickness or 1,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        _G.Config.Skeleton.Thickness = Value
    end
})
v67:AddSlider('tracers_thickness', {
    Text = 'tracer thickness',
    Default = _G.Config.Tracers.Thickness or 1,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        _G.Config.Tracers.Thickness = Value
    end
})
v67:AddSlider('chams_transparency', {
    Text = 'chams transparency',
    Default = _G.Config.Chams.Transparency or 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(Value)
        _G.Config.Chams.Transparency = Value
    end
})
end)()
;(function()
local worldToEspScreen = getgenv().InstanceWorldToScreenEsp or getgenv().InstanceWorldToScreen
local utilfonts = {}
local utilfontok = pcall(function()
    local fontid = "util_font.ttf"
    if not isfile(fontid) then
        writefile(fontid, game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf"))
    end
    utilfonts.path = fontid
end)
local utilconfig = {
    enable = false,
    color = Color3.fromRGB(255, 255, 255),
    color2 = Color3.fromRGB(255, 255, 255),
    selected = {},
    distance = false,
    images = false,
}
local UTIL_IMG_SIZE = 36
local UTIL_NAME_GAP = 14
local UTIL_DIST_GAP = 6
local replicated_storage = game:GetService("ReplicatedStorage")
local item_library
pcall(function()
    item_library = require(replicated_storage.Modules.ItemLibrary)
end)
local utilimagename = {
    Grenade = "Grenade",
    SubspaceTripmineHitbox = "Substapce Tripmine",
    Flashbang = "Flashbang",
    Satchel = "Satchel",
    Warpstone = "Warpstone",
    Molotov = "Molotov",
    ["Smoke Grenade"] = "Smoke Grenade",
}
local utilimagecache = {}
local utilimagefallback = {
    Grenade = "rbxassetid://6603835352",
    Flashbang = "rbxassetid://243660364",
    Satchel = "rbxassetid://446111271",
    Warpstone = "rbxassetid://12781852245",
    Molotov = "rbxassetid://1084982556",
    ["Smoke Grenade"] = "rbxassetid://241650108",
    ["Subspace Tripmine"] = "rbxassetid://120777973",
}
local function normUtilImageId(id)
    if not id or id == "" then return "" end
    id = tostring(id)
    if tonumber(id) then
        return "rbxassetid://" .. id
    end
    return id
end
local function resolveUtilImage(modelName)
    if utilimagecache[modelName] ~= nil then
        return utilimagecache[modelName]
    end
    local imageId = ""
    local libNames = {}
    local mapped = utilimagename[modelName]
    if mapped then
        libNames[#libNames + 1] = mapped
    end
    if modelName == "SubspaceTripmineHitbox" then
        libNames[#libNames + 1] = "Subspace Tripmine"
    end
    libNames[#libNames + 1] = modelName
    pcall(function()
        for _, libName in ipairs(libNames) do
            if imageId ~= "" then break end
            if item_library and item_library.GetWeaponImage then
                imageId = item_library:GetWeaponImage(libName, true) or ""
            end
            if imageId == "" and item_library and item_library.GetImageFromWeaponData then
                imageId = item_library:GetImageFromWeaponData({ Name = libName, Weapon = libName, WeaponName = libName }, true) or ""
            end
        end
    end)
    imageId = normUtilImageId(imageId)
    if imageId == "" then
        imageId = utilimagefallback[modelName] or utilimagefallback[utilimagename[modelName]] or ""
    end
    utilimagecache[modelName] = imageId
    return imageId
end
local utilmap = {
    ["grenade"]           = "Grenade",
    ["subspace tripmine"] = "SubspaceTripmineHitbox",
    ["flashbang"]         = "Flashbang",
    ["satchel"]           = "Satchel",
    ["warpstone"]         = "Warpstone",
    ["molotov"]           = "Molotov",
    ["smoke grenade"]     = "Smoke Grenade"
}
local utildisplay = {}
for label, realname in pairs(utilmap) do
    utildisplay[realname] = label
end
local function utilHasSelection()
    for label in pairs(utilmap) do
        if utilconfig.selected[label] then
            return true
        end
    end
    return false
end
local function isselected(realname)
    if not utilHasSelection() then
        for _, rname in pairs(utilmap) do
            if rname == realname then
                return true
            end
        end
        return false
    end
    for label, rname in pairs(utilmap) do
        if rname == realname and utilconfig.selected[label] then
            return true
        end
    end
    return false
end
local function trackUtilDrawingText(obj)
    if getgenv().InstanceTrackDrawingText then
        return getgenv().InstanceTrackDrawingText(obj)
    end
    return obj
end
local utilespobjects = {}
local function makedrawtext(text, color)
    if not Drawing or not Drawing.new then return nil end
    local ok, t = pcall(function()
        local raw = Drawing.new("Text")
        return trackUtilDrawingText(raw)
    end)
    if not ok or not t then return nil end
    t.Text = text
    t.Color = color
    t.Size = 15
    t.Visible = false
    t.Outline = true
    t.OutlineColor = Color3.new(0, 0, 0)
    t.Center = true
    t.Font = getgenv().InstanceHudDrawFont or 2
    return t
end
local function makedrawimage(imageId)
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.Image = imageId or ""
    img.ImageTransparency = 0
    img.Size = UDim2.fromOffset(UTIL_IMG_SIZE, UTIL_IMG_SIZE)
    img.Visible = false
    img.ZIndex = 10
    img.Parent = espgui
    return img
end
local function getUtilTrackTarget(obj)
    if not obj then return nil, nil end
    if obj:IsA("Model") then
        local root = obj.PrimaryPart or obj:FindFirstChild("Hitbox") or obj:FindFirstChildWhichIsA("BasePart")
        return obj, root
    end
    if obj:IsA("BasePart") then
        local model = obj.Parent and obj.Parent:IsA("Model") and obj.Parent or nil
        return model or obj, obj
    end
    return nil, nil
end
local function utilMatchesFilter(obj)
    local model, root = getUtilTrackTarget(obj)
    if not model or not root then return false end
    local realname = model:IsA("Model") and model.Name or obj.Name
    return isselected(realname)
end
local function removeespobjsfor(model)
    if utilespobjects[model] then
        for _, d in ipairs(utilespobjects[model].drawings) do
            pcall(function() d:Remove() end)
        end
        if utilespobjects[model].image then
            pcall(function()
                if typeof(utilespobjects[model].image) == "Instance" and utilespobjects[model].image:IsA("GuiObject") then
                    utilespobjects[model].image:Destroy()
                else
                    utilespobjects[model].image:Remove()
                end
            end)
        end
        if utilespobjects[model].conn then
            utilespobjects[model].conn:Disconnect()
        end
        utilespobjects[model] = nil
    end
end
local function clearutilesp()
    for model, _ in pairs(utilespobjects) do
        removeespobjsfor(model)
    end
end
local function addutilesp(obj)
    local model, rootpart = getUtilTrackTarget(obj)
    if not model or not rootpart then return end
    if utilespobjects[model] then return end
    local realname = model:IsA("Model") and model.Name or tostring(model)
    local nametext = utildisplay[realname] or string.lower(realname)
    local namedraw = makedrawtext(nametext, utilconfig.color)
    local distdraw = makedrawtext("", utilconfig.color)
    local imgdraw = makedrawimage(resolveUtilImage(realname))
    if not namedraw and not distdraw then return end
    utilespobjects[model] = {
        drawings = {},
        image = imgdraw,
        conn = nil,
        root = rootpart,
    }
    if namedraw then utilespobjects[model].drawings[#utilespobjects[model].drawings + 1] = namedraw end
    if distdraw then utilespobjects[model].drawings[#utilespobjects[model].drawings + 1] = distdraw end
    local conn = game:GetService("RunService").RenderStepped:Connect(function()
        pcall(function()
            local trackRoot = utilespobjects[model] and utilespobjects[model].root
            if not trackRoot or not trackRoot.Parent then
                removeespobjsfor(model)
                return
            end
            local cam = workspace.CurrentCamera
            if not cam or not worldToEspScreen then return end
            local pos, onScreen = worldToEspScreen(trackRoot.Position)
            if onScreen and utilconfig.enable and isselected(realname) then
                if utilconfig.images and imgdraw and (not imgdraw.Image or imgdraw.Image == "") then
                    local loaded = resolveUtilImage(realname)
                    if loaded ~= "" then
                        imgdraw.Image = loaded
                    end
                end
                local showImg = utilconfig.images and imgdraw and imgdraw.Image and imgdraw.Image ~= ""
                local halfImg = UTIL_IMG_SIZE * 0.5
                if namedraw then
                    if showImg then
                        namedraw.Position = Vector2.new(pos.X, pos.Y - halfImg - UTIL_NAME_GAP)
                    else
                        namedraw.Position = Vector2.new(pos.X, pos.Y - 8)
                    end
                    namedraw.Visible = true
                end
                if imgdraw then
                    if showImg then
                        imgdraw.Position = UDim2.new(0, pos.X - halfImg, 0, pos.Y - halfImg)
                        imgdraw.Visible = true
                    else
                        imgdraw.Visible = false
                    end
                end
                if distdraw then
                    if utilconfig.distance then
                        local dist = math.floor((cam.CFrame.Position - trackRoot.Position).Magnitude)
                        distdraw.Text = getgenv().InstanceL("studs_short", dist)
                        if showImg then
                            distdraw.Position = Vector2.new(pos.X, pos.Y + halfImg + UTIL_DIST_GAP)
                        else
                            distdraw.Position = Vector2.new(pos.X, pos.Y + 6)
                        end
                        distdraw.Visible = true
                    else
                        distdraw.Visible = false
                    end
                end
            else
                if namedraw then namedraw.Visible = false end
                if distdraw then distdraw.Visible = false end
                if imgdraw then imgdraw.Visible = false end
            end
        end)
    end)
    utilespobjects[model].conn = conn
    model.AncestryChanged:Connect(function(_, parent)
        if not parent then
            removeespobjsfor(model)
        end
    end)
end
local function refreshutilesp()
    clearutilesp()
    if not utilconfig.enable then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and utilMatchesFilter(obj) then
            addutilesp(obj)
        end
    end
end
local v68 = Tabs.Visuals:AddLeftGroupbox("utility")
v68:AddToggle('utilenable', {
    Text = 'enable',
    Default = utilconfig.enable,
    Callback = function(value)
        utilconfig.enable = value
        refreshutilesp()
    end
}):AddColorPicker('utilcolor', {
    Title = 'text color 1',
    Default = utilconfig.color,
    Transparency = false,
    Callback = function(value)
        utilconfig.color = value
        for _, data in pairs(utilespobjects) do
            for _, d in ipairs(data.drawings) do
                d.Color = value
            end
        end
    end
}):AddColorPicker('utilcolor2', {
    Title = 'text color 2',
    Default = utilconfig.color2 or utilconfig.color,
    Transparency = false,
    Callback = function(value)
        utilconfig.color2 = value
    end
})
v68:AddDropdown('utilitems', {
    Text = 'utilities',
    Values = {
        "grenade",
        "subspace tripmine",
        "flashbang",
        "satchel",
        "warpstone",
        "molotov",
        "smoke grenade"
    },
    Multi = true,
    Default = {},
    Callback = function(value)
        utilconfig.selected = value
        refreshutilesp()
    end
})
v68:AddToggle('utildistance', {
    Text = 'distance',
    Default = utilconfig.distance,
    Callback = function(value)
        utilconfig.distance = value
    end
})
v68:AddToggle('utilimages', {
    Text = 'images',
    Default = utilconfig.images,
    Callback = function(value)
        utilconfig.images = value
    end
})
workspace.DescendantAdded:Connect(function(desc)
    if not utilconfig.enable then return end
    if not desc:IsA("Model") and not desc:IsA("BasePart") then return end
    task.delay(0.15, function()
        if not utilconfig.enable then return end
        if utilMatchesFilter(desc) then
            addutilesp(desc)
        end
    end)
end)
end)()
;(function()
_G.LightingSettings = _G.LightingSettings or {
    Enabled = false,
    Ambient = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    OutdoorAmbient = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    GlobalShadows = { Enabled = true },
    ShadowSoftness = { Enabled = false, Value = 0.2 },
    SunColor = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ColorShiftTop = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ColorShiftBottom = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ClockTime = { Enabled = false, Value = 12 },
    GeographicLatitude = { Enabled = false, Value = 41.8 },
    Fog = { Enabled = false, Color = Color3.fromRGB(255, 255, 255), Start = 0, End = 100 },
    EnvironmentDiffuseScale = { Enabled = false, Value = 1 },
    EnvironmentSpecularScale = { Enabled = false, Value = 1 },
    ColorCorrection = { Enabled = false, Contrast = 0, Saturation = 0, Brightness = 0 },
    Bloom = { Enabled = false, Multiplier = 0.3, Threshold = 0.6 },
}
local Lighting = game:GetService("Lighting")
local origvalues = {}
local updateconn = nil
local extraColorCorrection = nil
local bloomOrigCache = {}
local bloomTracked = {}
local function trackBloomEffect(bloom)
    if not bloom or not bloom:IsA("BloomEffect") or bloom.Name == "InstanceExtraBloom" then
        return
    end
    if not bloomOrigCache[bloom] then
        bloomOrigCache[bloom] = {
            Intensity = bloom.Intensity,
            Size = bloom.Size,
            Threshold = bloom.Threshold,
            Enabled = bloom.Enabled,
        }
    end
    if bloomTracked[bloom] then
        return
    end
    bloomTracked[bloom] = true
    bloom.AncestryChanged:Connect(function(_, parent)
        if not parent then
            bloomOrigCache[bloom] = nil
            bloomTracked[bloom] = nil
        end
    end)
end
local function applyBloomModifier()
    local bloomCfg = _G.LightingSettings and _G.LightingSettings.Bloom
    if not bloomCfg then
        return
    end
    local mult = math.clamp(tonumber(bloomCfg.Multiplier) or 1, 0, 1.5)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("BloomEffect") and child.Name ~= "InstanceExtraBloom" then
            child.Enabled = false
        end
    end
    if bloomCfg.Enabled then
        local extraBloom = Lighting:FindFirstChild("InstanceExtraBloom")
        if not extraBloom then
            extraBloom = Instance.new("BloomEffect")
            extraBloom.Name = "InstanceExtraBloom"
            extraBloom.Parent = Lighting
        end
        extraBloom.Intensity = mult * 0.8
        extraBloom.Size = 4
        extraBloom.Threshold = 0.7
        extraBloom.Enabled = true
    else
        local legacyExtra = Lighting:FindFirstChild("InstanceExtraBloom")
        if legacyExtra then
            legacyExtra:Destroy()
        end
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("BloomEffect") and child.Name ~= "InstanceExtraBloom" then
                local base = bloomOrigCache[child]
                if base then
                    child.Intensity = base.Intensity
                    child.Size = base.Size
                    child.Threshold = base.Threshold
                    child.Enabled = base.Enabled
                end
            end
        end
    end
end
local function restoreBloomOriginals()
    for bloom, base in pairs(bloomOrigCache) do
        if bloom and bloom.Parent then
            bloom.Intensity = base.Intensity
            bloom.Size = base.Size
            bloom.Threshold = base.Threshold
            bloom.Enabled = base.Enabled
        end
    end
    local legacyExtra = Lighting:FindFirstChild("InstanceExtraBloom")
    if legacyExtra then
        legacyExtra:Destroy()
    end
end
local function storeorigvalues()
    origvalues.Ambient = Lighting.Ambient
    origvalues.OutdoorAmbient = Lighting.OutdoorAmbient
    origvalues.GlobalShadows = Lighting.GlobalShadows
    origvalues.ShadowSoftness = Lighting.ShadowSoftness
    origvalues.ColorShift_Top = Lighting.ColorShift_Top
    origvalues.ColorShift_Bottom = Lighting.ColorShift_Bottom
    origvalues.ClockTime = Lighting.ClockTime
    origvalues.GeographicLatitude = Lighting.GeographicLatitude
    origvalues.FogColor = Lighting.FogColor
    origvalues.FogStart = Lighting.FogStart
    origvalues.FogEnd = Lighting.FogEnd
    origvalues.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
    origvalues.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
end
storeorigvalues()
local function shadersActive()
    return _G.Features and _G.Features.QOL and _G.Features.QOL.Shaders
end
local function blendColor(base, tint, factor)
    return Color3.new(
        base.R + (tint.R - base.R) * factor,
        base.G + (tint.G - base.G) * factor,
        base.B + (tint.B - base.B) * factor
    )
end
local function ensureExtraEffects()
    local ccCfg = _G.LightingSettings.ColorCorrection
    if ccCfg and ccCfg.Enabled then
        if not extraColorCorrection or not extraColorCorrection.Parent then
            extraColorCorrection = Instance.new("ColorCorrectionEffect")
            extraColorCorrection.Name = "InstanceExtraColorCorrection"
            extraColorCorrection.Parent = Lighting
        end
        extraColorCorrection.Contrast = ccCfg.Contrast / 10
        extraColorCorrection.Saturation = ccCfg.Saturation / 10
        extraColorCorrection.Brightness = ccCfg.Brightness / 10
        extraColorCorrection.Enabled = true
    elseif extraColorCorrection then
        extraColorCorrection.Enabled = false
    end
    applyBloomModifier()
end
local function restoreBloomOriginals()
    for bloom, base in pairs(bloomOrigCache) do
        if bloom.Parent then
            bloom.Intensity = base.Intensity
            bloom.Size = base.Size
            bloom.Threshold = base.Threshold
            bloom.Enabled = base.Enabled
        end
    end
    local legacyExtra = Lighting:FindFirstChild("InstanceExtraBloom")
    if legacyExtra then
        legacyExtra:Destroy()
    end
end
local function clearExtraEffects()
    if extraColorCorrection then
        extraColorCorrection.Enabled = false
    end
    restoreBloomOriginals()
end
local function lightupdater()
    if updateconn then
        updateconn:Disconnect()
        updateconn = nil
    end
    updateconn = RunService.RenderStepped:Connect(function()
        if not _G.LightingSettings.Enabled then return end
        if _G.LightingSettings.Ambient.Enabled then
            Lighting.Ambient = _G.LightingSettings.Ambient.Color
        elseif not shadersActive() then
            Lighting.Ambient = origvalues.Ambient
        end
        if _G.LightingSettings.SunColor.Enabled then
            local base = _G.LightingSettings.OutdoorAmbient.Enabled
                and _G.LightingSettings.OutdoorAmbient.Color
                or (shadersActive() and Color3.fromRGB(88, 108, 140) or origvalues.OutdoorAmbient)
            Lighting.OutdoorAmbient = blendColor(base, _G.LightingSettings.SunColor.Color, 0.55)
        elseif _G.LightingSettings.OutdoorAmbient.Enabled then
            Lighting.OutdoorAmbient = _G.LightingSettings.OutdoorAmbient.Color
        elseif not shadersActive() then
            Lighting.OutdoorAmbient = origvalues.OutdoorAmbient
        end
        if _G.LightingSettings.GlobalShadows.Enabled ~= nil then
            Lighting.GlobalShadows = _G.LightingSettings.GlobalShadows.Enabled
        else
            Lighting.GlobalShadows = origvalues.GlobalShadows
        end
        if _G.LightingSettings.ShadowSoftness.Enabled then
            Lighting.ShadowSoftness = _G.LightingSettings.ShadowSoftness.Value
        elseif not shadersActive() then
            Lighting.ShadowSoftness = origvalues.ShadowSoftness
        end
        if _G.LightingSettings.SunColor.Enabled then
            Lighting.ColorShift_Top = _G.LightingSettings.SunColor.Color
        elseif _G.LightingSettings.ColorShiftTop.Enabled then
            Lighting.ColorShift_Top = _G.LightingSettings.ColorShiftTop.Color
        elseif not shadersActive() then
            Lighting.ColorShift_Top = origvalues.ColorShift_Top
        end
        if _G.LightingSettings.ColorShiftBottom.Enabled then
            Lighting.ColorShift_Bottom = _G.LightingSettings.ColorShiftBottom.Color
        elseif not shadersActive() then
            Lighting.ColorShift_Bottom = origvalues.ColorShift_Bottom
        end
        if _G.LightingSettings.ClockTime.Enabled then
            Lighting.ClockTime = _G.LightingSettings.ClockTime.Value
        else
            Lighting.ClockTime = origvalues.ClockTime
        end
        if _G.LightingSettings.GeographicLatitude.Enabled then
            Lighting.GeographicLatitude = _G.LightingSettings.GeographicLatitude.Value
        else
            Lighting.GeographicLatitude = origvalues.GeographicLatitude
        end
        if _G.LightingSettings.Fog.Enabled then
            Lighting.FogColor = _G.LightingSettings.Fog.Color
            Lighting.FogStart = _G.LightingSettings.Fog.Start
            Lighting.FogEnd = _G.LightingSettings.Fog.End
        else
            Lighting.FogColor = origvalues.FogColor
            Lighting.FogStart = origvalues.FogStart
            Lighting.FogEnd = origvalues.FogEnd
        end
        if _G.LightingSettings.EnvironmentDiffuseScale.Enabled then
            Lighting.EnvironmentDiffuseScale = _G.LightingSettings.EnvironmentDiffuseScale.Value
        elseif not shadersActive() then
            Lighting.EnvironmentDiffuseScale = origvalues.EnvironmentDiffuseScale
        end
        if _G.LightingSettings.EnvironmentSpecularScale.Enabled then
            Lighting.EnvironmentSpecularScale = _G.LightingSettings.EnvironmentSpecularScale.Value
        elseif not shadersActive() then
            Lighting.EnvironmentSpecularScale = origvalues.EnvironmentSpecularScale
        end
    end)
end
local function stoplightupdater()
    if updateconn then
        updateconn:Disconnect()
        updateconn = nil
    end
    Lighting.GlobalShadows = origvalues.GlobalShadows
    Lighting.ClockTime = origvalues.ClockTime
    Lighting.GeographicLatitude = origvalues.GeographicLatitude
    Lighting.FogColor = origvalues.FogColor
    Lighting.FogStart = origvalues.FogStart
    Lighting.FogEnd = origvalues.FogEnd
    if not shadersActive() then
        Lighting.Ambient = origvalues.Ambient
        Lighting.OutdoorAmbient = origvalues.OutdoorAmbient
        Lighting.ShadowSoftness = origvalues.ShadowSoftness
        Lighting.ColorShift_Top = origvalues.ColorShift_Top
        Lighting.ColorShift_Bottom = origvalues.ColorShift_Bottom
        Lighting.EnvironmentDiffuseScale = origvalues.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = origvalues.EnvironmentSpecularScale
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
        if origatmo then
            local origatm = Instance.new("Atmosphere")
            origatm.Density = origatmo.Density
            origatm.Offset = origatmo.Offset
            origatm.Haze = origatmo.Haze
            origatm.Glare = origatmo.Glare
            origatm.Color = origatmo.Color
            origatm.Decay = origatmo.Decay
            origatm.Parent = Lighting
        end
    end
    ensureExtraEffects()
end
local lightbox = Tabs.Visuals:AddRightGroupbox('lighting')
lightbox:AddToggle('lighting_master', {
    Text = 'enable',
    Default = _G.LightingSettings.Enabled,
    Callback = function(v)
        _G.LightingSettings.Enabled = v
        if v then
            lightupdater()
        else
            stoplightupdater()
        end
    end
})
local ambientToggle = lightbox:AddToggle('lighting_ambient', {
    Text = 'custom ambient',
    Default = _G.LightingSettings.Ambient.Enabled,
    Callback = function(v)
        _G.LightingSettings.Ambient.Enabled = v
    end
})
ambientToggle:AddColorPicker('lighting_ambient_color', {
    Default = _G.LightingSettings.Ambient.Color,
    Title = 'ambient color',
    Callback = function(c)
        _G.LightingSettings.Ambient.Color = c
    end
})
local outdoorToggle = lightbox:AddToggle('lighting_outdoorambient', {
    Text = 'custom outdoor ambient',
    Default = _G.LightingSettings.OutdoorAmbient.Enabled,
    Callback = function(v)
        _G.LightingSettings.OutdoorAmbient.Enabled = v
    end
})
outdoorToggle:AddColorPicker('lighting_outdoorambient_color', {
    Default = _G.LightingSettings.OutdoorAmbient.Color,
    Title = 'outdoor ambient color',
    Callback = function(c)
        _G.LightingSettings.OutdoorAmbient.Color = c
    end
})
local sunColorToggle = lightbox:AddToggle('lighting_suncolor', {
    Text = 'custom sun color',
    Default = _G.LightingSettings.SunColor.Enabled,
    Callback = function(v)
        _G.LightingSettings.SunColor.Enabled = v
    end
})
sunColorToggle:AddColorPicker('lighting_suncolor_color', {
    Default = _G.LightingSettings.SunColor.Color,
    Title = 'sun color',
    Callback = function(c)
        _G.LightingSettings.SunColor.Color = c
    end
})
lightbox:AddToggle('lighting_globalshadows', {
    Text = 'global shadows',
    Default = _G.LightingSettings.GlobalShadows.Enabled,
    Callback = function(v)
        _G.LightingSettings.GlobalShadows.Enabled = v
    end
})
lightbox:AddToggle('lighting_shadowsoftness', {
    Text = 'custom shadow softness',
    Default = _G.LightingSettings.ShadowSoftness.Enabled,
    Callback = function(v)
        _G.LightingSettings.ShadowSoftness.Enabled = v
    end
})
local topShiftToggle = lightbox:AddToggle('lighting_colorshifttop', {
    Text = 'color shift top',
    Default = _G.LightingSettings.ColorShiftTop.Enabled,
    Callback = function(v)
        _G.LightingSettings.ColorShiftTop.Enabled = v
    end
})
topShiftToggle:AddColorPicker('lighting_colorshifttop_color', {
    Default = _G.LightingSettings.ColorShiftTop.Color,
    Title = 'top color',
    Callback = function(c)
        _G.LightingSettings.ColorShiftTop.Color = c
    end
})
local bottomShiftToggle = lightbox:AddToggle('lighting_colorshiftbottom', {
    Text = 'color shift bottom',
    Default = _G.LightingSettings.ColorShiftBottom.Enabled,
    Callback = function(v)
        _G.LightingSettings.ColorShiftBottom.Enabled = v
    end
})
bottomShiftToggle:AddColorPicker('lighting_colorshiftbottom_color', {
    Default = _G.LightingSettings.ColorShiftBottom.Color,
    Title = 'bottom color',
    Callback = function(c)
        _G.LightingSettings.ColorShiftBottom.Color = c
    end
})
lightbox:AddToggle('lighting_clocktime', {
    Text = 'custom time',
    Default = _G.LightingSettings.ClockTime.Enabled,
    Callback = function(v)
        _G.LightingSettings.ClockTime.Enabled = v
    end
})
lightbox:AddToggle('lighting_latitude', {
    Text = 'custom latitude',
    Default = _G.LightingSettings.GeographicLatitude.Enabled,
    Callback = function(v)
        _G.LightingSettings.GeographicLatitude.Enabled = v
    end
})
local fogToggle = lightbox:AddToggle('lighting_fog', {
    Text = 'custom fog',
    Default = _G.LightingSettings.Fog.Enabled,
    Callback = function(v)
        _G.LightingSettings.Fog.Enabled = v
    end
})
fogToggle:AddColorPicker('lighting_fog_color', {
    Default = _G.LightingSettings.Fog.Color,
    Title = 'fog color',
    Callback = function(c)
        _G.LightingSettings.Fog.Color = c
    end
})
lightbox:AddToggle('lighting_diffuse', {
    Text = 'custom diffuse scale',
    Default = _G.LightingSettings.EnvironmentDiffuseScale.Enabled,
    Callback = function(v)
        _G.LightingSettings.EnvironmentDiffuseScale.Enabled = v
    end
})
lightbox:AddToggle('lighting_specular', {
    Text = 'custom specular scale',
    Default = _G.LightingSettings.EnvironmentSpecularScale.Enabled,
    Callback = function(v)
        _G.LightingSettings.EnvironmentSpecularScale.Enabled = v
    end
})
lightbox:AddSlider('lighting_shadowsoftness_value', {
    Text = 'shadow softness',
    Min = 0,
    Max = 1,
    Default = 0.2,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.ShadowSoftness.Value = v
    end
})
lightbox:AddSlider('lighting_clocktime_value', {
    Text = 'hour',
    Min = 0,
    Max = 24,
    Default = 12,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.ClockTime.Value = v
    end
})
lightbox:AddSlider('lighting_latitude_value', {
    Text = 'geographic latitude',
    Min = -90,
    Max = 90,
    Default = 41.8,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.GeographicLatitude.Value = v
    end
})
lightbox:AddSlider('lighting_fogstart', {
    Text = 'fog start',
    Min = 0,
    Max = 1000,
    Default = 0,
    Rounding = 0,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Fog.Start = v
    end
})
lightbox:AddSlider('lighting_fogend', {
    Text = 'fog end',
    Min = 0,
    Max = 100000,
    Default = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Fog.End = v
    end
})
lightbox:AddSlider('lighting_diffuse_value', {
    Text = 'diffuse scale',
    Min = 0,
    Max = 2,
    Default = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.EnvironmentDiffuseScale.Value = v
    end
})
lightbox:AddSlider('lighting_specular_value', {
    Text = 'specular scale',
    Min = 0,
    Max = 2,
    Default = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.EnvironmentSpecularScale.Value = v
    end
})
local fxTabbox = Tabs.Visuals:AddRightTabbox()
local colorTab = fxTabbox:AddTab('color')
local bloomTab = fxTabbox:AddTab('bloom')
colorTab:AddToggle('lighting_color_correction', {
    Text = 'enable',
    Default = _G.LightingSettings.ColorCorrection.Enabled,
    Callback = function(v)
        _G.LightingSettings.ColorCorrection.Enabled = v
        ensureExtraEffects()
    end
})
colorTab:AddSlider('lighting_cc_contrast', {
    Text = 'contrast',
    Min = -10,
    Max = 10,
    Default = _G.LightingSettings.ColorCorrection.Contrast,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.ColorCorrection.Contrast = v
        if _G.LightingSettings.ColorCorrection.Enabled then
            ensureExtraEffects()
        end
    end
})
colorTab:AddSlider('lighting_cc_saturation', {
    Text = 'saturation',
    Min = -10,
    Max = 10,
    Default = _G.LightingSettings.ColorCorrection.Saturation,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.ColorCorrection.Saturation = v
        if _G.LightingSettings.ColorCorrection.Enabled then
            ensureExtraEffects()
        end
    end
})
colorTab:AddSlider('lighting_cc_brightness', {
    Text = 'brightness',
    Min = -10,
    Max = 10,
    Default = _G.LightingSettings.ColorCorrection.Brightness,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.ColorCorrection.Brightness = v
        if _G.LightingSettings.ColorCorrection.Enabled then
            ensureExtraEffects()
        end
    end
})
bloomTab:AddToggle('lighting_bloom_modifier', {
    Text = 'enable',
    Default = _G.LightingSettings.Bloom.Enabled,
    Callback = function(v)
        _G.LightingSettings.Bloom.Enabled = v
        if not v then
            restoreBloomOriginals()
        end
        ensureExtraEffects()
    end
})
bloomTab:AddSlider('lighting_bloom_multiplier', {
    Text = 'emissive intensity',
    Min = 0,
    Max = 1.5,
    Default = _G.LightingSettings.Bloom.Multiplier,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Bloom.Multiplier = v
        if _G.LightingSettings.Bloom.Enabled then
            local extraBloom = Lighting:FindFirstChild("InstanceExtraBloom")
            if extraBloom then
                extraBloom.Intensity = v * 0.8
            end
        end
    end
})
bloomTab:AddSlider('lighting_bloom_size', {
    Text = 'glow size',
    Min = 2,
    Max = 8,
    Default = 4,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Bloom.Size = v
        if _G.LightingSettings.Bloom.Enabled then
            local extraBloom = Lighting:FindFirstChild("InstanceExtraBloom")
            if extraBloom then
                extraBloom.Size = v
            end
        end
    end
})
bloomTab:AddSlider('lighting_bloom_threshold', {
    Text = 'brightness threshold',
    Min = 0.5,
    Max = 1,
    Default = 0.7,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Bloom.Threshold = v
        if _G.LightingSettings.Bloom.Enabled then
            local extraBloom = Lighting:FindFirstChild("InstanceExtraBloom")
            if extraBloom then
                extraBloom.Threshold = v
            end
        end
    end
})
Lighting.ChildAdded:Connect(function(child)
    if child:IsA("BloomEffect") then
        task.defer(ensureExtraEffects)
    end
end)
game:GetService("ScriptContext").DescendantRemoving:Connect(function(descendant)
    if descendant == script then
        stoplightupdater()
        clearExtraEffects()
    end
end)
end)();
(function()
getgenv().crosshair = {
    enabled = false,
    refreshrate = 0.016,
    mode = "mouse",
    position = Vector2.new(0, 0),
    crosshair_mode = "static", 
    width = 1.5,
    length = 10,
    radius = 11,
    crosshair_color = Color3.fromRGB(0, 200, 255),
    color1 = Color3.fromRGB(0, 200, 255),
    color2 = Color3.fromRGB(0, 153, 255),
    color3 = Color3.fromRGB(0, 107, 255),
    gradient_rotation = 0,
    spin = true,
    spin_speed = 150,
    spin_max = 340,
    spin_style = Enum.EasingStyle.Sine,
    resize = true,
    resize_speed = 150,
    resize_min = 5,
    resize_max = 22,
    scale_min = 1,
    scale_max = 1,
    show_ammo = false,
    show_watermark = true,
    show_lines = true,
}
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local Cam = workspace.CurrentCamera
local LocalPlayer = game:GetService("Players").LocalPlayer
local function gradcolor(position, rotation, color1, color2, color3)
    local rad = math.rad(rotation)
    local adjustedPos = (position * math.cos(rad) + (1 - position) * math.sin(rad)) % 1
    if adjustedPos < 0.5 then
        local t = adjustedPos * 2
        return Color3.new(
            color1.R + (color2.R - color1.R) * t,
            color1.G + (color2.G - color1.G) * t,
            color1.B + (color2.B - color1.B) * t
        )
    else
        local t = (adjustedPos - 0.5) * 2
        return Color3.new(
            color2.R + (color3.R - color2.R) * t,
            color2.G + (color3.G - color2.G) * t,
            color2.B + (color3.B - color2.B) * t
        )
    end
end
local WATERMARK_TEXT = "Baza Hub | Baza2000ultrapro"
local textChars = {}
for i = 1, #WATERMARK_TEXT do
    local char = getgenv().InstanceTrackDrawingText(Drawing.new("Text"))
    char.Size = 13
    char.Font = 2
    char.Outline = true
    char.Text = WATERMARK_TEXT:sub(i, i)
    char.Color = Color3.new(1, 1, 1)
    textChars[i] = char
end
local watermarkProbe = Drawing.new("Text")
watermarkProbe.Size = 13
watermarkProbe.Font = 2
watermarkProbe.Text = WATERMARK_TEXT
watermarkProbe.Visible = false
local ammoLabel = getgenv().InstanceTrackDrawingText(Drawing.new("Text"))
ammoLabel.Size = 13
ammoLabel.Font = 2
ammoLabel.Outline = true
ammoLabel.Color = Color3.new(1, 1, 1)
ammoLabel.Visible = false
local prevAmmoText = ""
local prevAmmoWidth = 0
local totalChars = #WATERMARK_TEXT
local lines = {}
for i = 1, 8 do
    lines[i] = Drawing.new("Line")
end
local last = 0
local angles = {0, 90, 180, 270}
local function solve(a, r)
    local rad = math.rad(a)
    return Vector2.new(math.sin(rad) * r, math.cos(rad) * r)
end
local function muzzlepos()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end
    local playerName = LocalPlayer.Name
    for _, model in pairs(firstPerson:GetChildren()) do
        if model:IsA("Model") and model.Name:find("^" .. playerName) then
            local itemVisual = model:FindFirstChild("ItemVisual")
            if itemVisual then
                local body = itemVisual:FindFirstChild("Body")
                if body then
                    local bodyPrimary = body:FindFirstChild("BodyPrimary")
                    if bodyPrimary then
                        local muzzle = bodyPrimary:FindFirstChild("_muzzle")
                        if muzzle and muzzle:IsA("Attachment") then
                            return muzzle.WorldPosition
                        end
                    end
                end
            end
        end
    end
    return nil
end
local ammoUiCache = { frame = nil, reserve = nil, ammo = nil, rescanAt = 0 }
local function getammo(t)
    if ammoUiCache.frame and ammoUiCache.frame.Parent and ammoUiCache.frame.Visible then
        local reserve = tonumber(ammoUiCache.reserve.Text:match("%d+")) or 0
        local ammo = tonumber(ammoUiCache.ammo.Text:match("%d+")) or 0
        return reserve, ammo
    end
    if t < ammoUiCache.rescanAt then return 0, 0 end
    ammoUiCache.rescanAt = t + 0.5
    ammoUiCache.frame, ammoUiCache.reserve, ammoUiCache.ammo = nil, nil, nil
    for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("Frame") and v.Visible then
            local r = v:FindFirstChild("Reserve")
            if r and v:FindFirstChild("Icon") and v:FindFirstChild("ItemName") then
                local a = r:FindFirstChild("Ammo")
                if a then
                    ammoUiCache.frame = v
                    ammoUiCache.reserve = r
                    ammoUiCache.ammo = a
                    local reserve = tonumber(r.Text:match("%d+")) or 0
                    local ammo = tonumber(a.Text:match("%d+")) or 0
                    return reserve, ammo
                end
            end
        end
    end
    return 0, 0
end
Run.PostSimulation:Connect(function()
    local t = os.clock()
    if t - last < getgenv().crosshair.refreshrate then return end
    last = t
    if isInstanceMenuOpen and isInstanceMenuOpen() then
        for i = 1, totalChars do textChars[i].Visible = false end
        ammoLabel.Visible = false
        for i = 1, 8 do lines[i].Visible = false end
        return
    end
    local cfg = getgenv().crosshair
    local pos
    if cfg.crosshair_mode == "follow muzzle" then
        local muzzlePos = muzzlepos()
        if muzzlePos then
            local screenPos, onScreen = worldToScreen(muzzlePos, Cam)
            if onScreen then
                pos = Vector2.new(screenPos.X, screenPos.Y)
            else
                pos = cfg.mode == "center" and Cam.ViewportSize/2 or
                      cfg.mode == "mouse" and UIS:GetMouseLocation() or
                      cfg.position
            end
        else
            pos = cfg.mode == "center" and Cam.ViewportSize/2 or
                  cfg.mode == "mouse" and UIS:GetMouseLocation() or
                  cfg.position
        end
    else
        pos = cfg.mode == "center" and Cam.ViewportSize/2 or
              cfg.mode == "mouse" and UIS:GetMouseLocation() or
              cfg.position
    end
    if not cfg.enabled then
        for i = 1, totalChars do textChars[i].Visible = false end
        ammoLabel.Visible = false
        for i = 1, 8 do lines[i].Visible = false end
        return
    end
    local scale = cfg.scale_min + (math.sin(t * cfg.resize_speed) * (cfg.scale_max - cfg.scale_min))
    local length = cfg.length
    if cfg.resize then
        local s = (t * cfg.resize_speed) % 180
        length = cfg.resize_min + math.sin(math.rad(s)) * cfg.resize_max
    end
    local textY = pos.Y + (cfg.show_lines and (cfg.radius + cfg.length + 14) or 15)
    if cfg.show_watermark then
        local totalWidth = watermarkProbe.TextBounds.X
        local startX = pos.X - totalWidth / 2
        local curX = startX
        for i = 1, totalChars do
            local charProgress = (totalChars > 1) and ((i - 1) / (totalChars - 1)) or 0
            local col = gradcolor(charProgress, cfg.gradient_rotation, cfg.color1, cfg.color2, cfg.color3)
            textChars[i].Color = col
            textChars[i].Position = Vector2.new(curX, textY)
            textChars[i].Visible = true
            curX = curX + textChars[i].TextBounds.X
        end
    else
        for i = 1, totalChars do textChars[i].Visible = false end
    end
    local ammoY
    if cfg.show_watermark then
        ammoY = textY + 18
    elseif cfg.show_lines then
        ammoY = pos.Y + cfg.radius + cfg.length + 18
    else
        ammoY = pos.Y + 18
    end
    if cfg.show_ammo then
        local reserve, ammo = getammo(t)
        local ammoText = tostring(reserve) .. " / " .. tostring(ammo)
        if ammoText ~= prevAmmoText then
            prevAmmoText = ammoText
            ammoLabel.Text = ammoText
            prevAmmoWidth = ammoLabel.TextBounds.X
        end
        ammoLabel.Position = Vector2.new(pos.X - prevAmmoWidth / 2, ammoY)
        ammoLabel.Visible = true
    else
        ammoLabel.Visible = false
    end
    if cfg.show_lines then
        local spinangle = 0
        if cfg.spin then
            local raw = -(t * cfg.spin_speed) % cfg.spin_max
            spinangle = Tween:GetValue(raw/360, cfg.spin_style, Enum.EasingDirection.InOut) * 360
        end
        for i = 1, 4 do
            local basea = angles[i] + spinangle
            local p1 = pos + solve(basea, cfg.radius * scale)
            local p2 = pos + solve(basea, (cfg.radius + length) * scale)
            local inl = lines[i + 4]
            inl.Visible = true
            inl.Color = cfg.crosshair_color
            inl.From = p1
            inl.To = p2
            inl.Thickness = cfg.width
            local out = lines[i]
            out.Visible = true
            out.Color = Color3.new(0, 0, 0)
            out.From = pos + solve(basea, cfg.radius * scale - 1)
            out.To = pos + solve(basea, (cfg.radius + length) * scale + 1)
            out.Thickness = cfg.width + 1.5
        end
    else
        for i = 1, 8 do lines[i].Visible = false end
    end
end)
local vcrosshair = Tabs.Visuals:AddRightGroupbox("crosshair")
vcrosshair:AddToggle('crosshaireeee',{
    Text = 'enable',
    Default = false,
    Callback = function(Value)
        getgenv().crosshair.enabled = Value
    end
}):AddColorPicker('CrosshairColor', {
    Default = getgenv().crosshair.crosshair_color,
    Title = 'Crosshair Color',
    Callback = function(Value)
        getgenv().crosshair.crosshair_color = Value
    end
}):AddColorPicker('GradientColor1', {
    Default = getgenv().crosshair.color1,
    Title = 'Text Color 1',
    Callback = function(Value)
        getgenv().crosshair.color1 = Value
    end
}):AddColorPicker('GradientColor2', {
    Default = getgenv().crosshair.color2,
    Title = 'Text Color 2',
    Callback = function(Value)
        getgenv().crosshair.color2 = Value
    end
}):AddColorPicker('GradientColor3', {
    Default = getgenv().crosshair.color3,
    Title = 'Text Color 3',
    Callback = function(Value)
        getgenv().crosshair.color3 = Value
    end
})
vcrosshair:AddToggle('showlines', {
    Text = 'crosshair lines',
    Default = getgenv().crosshair.show_lines,
    Callback = function(Value)
        getgenv().crosshair.show_lines = Value
    end
})
vcrosshair:AddToggle('showwatermark', {
    Text = 'watermark',
    Default = getgenv().crosshair.show_watermark,
    Callback = function(Value)
        getgenv().crosshair.show_watermark = Value
    end
})
vcrosshair:AddToggle('showammo', {
    Text = 'ammo',
    Default = false,
    Callback = function(Value)
        getgenv().crosshair.show_ammo = Value
    end
})
vcrosshair:AddSlider('ooetg', {
    Text = 'speed',
    Default = getgenv().crosshair.spin_speed,
    Min = 0,
    Max = 340,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        getgenv().crosshair.spin_speed = Value
    end
})
vcrosshair:AddSlider('GradientRotation', {
    Text = 'rotation',
    Default = getgenv().crosshair.gradient_rotation,
    Min = 0,
    Max = 360,
    Rounding = 0,
    Suffix = '',
    Callback = function(Value)
        getgenv().crosshair.gradient_rotation = Value
    end
})
vcrosshair:AddDropdown('crosshairmode', {
    Text = 'crosshair mode',
    Default = 1,
    Values = {'static', 'follow muzzle'},
    Callback = function(Value)
        getgenv().crosshair.crosshair_mode = Value
    end
})
end)();
(function()
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local atmotabbox = Tabs.World:AddRightTabbox()
local atmotab = atmotabbox:AddTab('atmosphere')
local ambienceTab   = atmotabbox:AddTab('ambience')
_G.LightingSettings.Atmosphere = _G.LightingSettings.Atmosphere or {
    Enabled = false,
    Density = 12,
    Offset = 0.25,
    Haze = 8,
    Glare = 0.6,
    Color = Color3.fromRGB(140, 160, 190),
    Decay = Color3.fromRGB(90, 110, 140),
    SoundEnabled = false,
    SelectedSound = "None",
    SoundVolume = 0.6
}
local origatmo = nil
local curambientsound = nil
local ambientSounds = {
    ["None"] = nil,
    ["Rain"] = 132717551555191,
    ["Night"] = 125710682931536,
    ["Birds Chirping"] = 9112831327,
    ["Jungle Birds"] = 9114892930,
    ["Campfire Crackling"] = 109494611784143,
    ["Night Crickets"] = 9112764040,
    ["Snow Storm"] = 551546110,
}
local function storeorigatmo()
    local existing = Lighting:FindFirstChildOfClass("Atmosphere")
    if existing then
        origatmo = {
            Density = existing.Density,
            Offset = existing.Offset,
            Haze = existing.Haze,
            Glare = existing.Glare,
            Color = existing.Color,
            Decay = existing.Decay
        }
    end
end
storeorigatmo()
local function clearcustomatmo()
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") and v.Name == "CustomAtmosphere" then
            v:Destroy()
        end
    end
end
local function applycustomatmo()
    clearcustomatmo()
    if not _G.LightingSettings.Atmosphere.Enabled then return end
    local atm = Instance.new("Atmosphere")
    atm.Name = "CustomAtmosphere"
    atm.Density = _G.LightingSettings.Atmosphere.Density
    atm.Offset = _G.LightingSettings.Atmosphere.Offset
    atm.Haze = _G.LightingSettings.Atmosphere.Haze
    atm.Glare = _G.LightingSettings.Atmosphere.Glare
    atm.Color = _G.LightingSettings.Atmosphere.Color
    atm.Decay = _G.LightingSettings.Atmosphere.Decay
    atm.Parent = Lighting
end
local function playambientsound()
    if curambientsound then
        curambientsound:Stop()
        curambientsound:Destroy()
        curambientsound = nil
    end
    local soundId = ambientSounds[_G.LightingSettings.Atmosphere.SelectedSound]
    if not soundId or not _G.LightingSettings.Atmosphere.SoundEnabled then
        return
    end
    curambientsound = Instance.new("Sound")
    curambientsound.Name = "CustomAmbientSound"
    curambientsound.SoundId = "rbxassetid://" .. soundId
    curambientsound.Looped = true
    curambientsound.Volume = _G.LightingSettings.Atmosphere.SoundVolume
    curambientsound.Parent = SoundService
    curambientsound:Play()
end
local function maintainatmo()
    if _G.LightingSettings.Atmosphere.Enabled then
        if not Lighting:FindFirstChild("CustomAtmosphere") then
            applycustomatmo()
        end
    end
end
RunService.Heartbeat:Connect(maintainatmo)
Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applycustomatmo()
    playambientsound()
end)
atmotab:AddToggle('atmosphere_master', {
    Text = 'enable',
    Default = _G.LightingSettings.Atmosphere.Enabled,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.Enabled = v
        applycustomatmo()
    end
}):AddColorPicker('atmosphere_color', {
    Default = _G.LightingSettings.Atmosphere.Color,
    Title = 'atmosphere color',
    Callback = function(c)
        _G.LightingSettings.Atmosphere.Color = c
        applycustomatmo()
    end
}):AddColorPicker('atmosphere_decay', {
    Default = _G.LightingSettings.Atmosphere.Decay,
    Title = 'decay color',
    Callback = function(c)
        _G.LightingSettings.Atmosphere.Decay = c
        applycustomatmo()
    end
})
atmotab:AddSlider('atmosphere_density', {
    Text = 'density: ',
    Min = 0,
    Max = 1,
    Default = _G.LightingSettings.Atmosphere.Density,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.Density = v
        applycustomatmo()
    end
})
atmotab:AddSlider('atmosphere_haze', {
    Text = 'haze: ',
    Min = 0,
    Max = 5,
    Default = _G.LightingSettings.Atmosphere.Haze,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.Haze = v
        applycustomatmo()
    end
})
atmotab:AddSlider('atmosphere_glare', {
    Text = 'glare: ',
    Min = 0,
    Max = 5,
    Default = _G.LightingSettings.Atmosphere.Glare,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.Glare = v
        applycustomatmo()
    end
})
atmotab:AddSlider('atmosphere_offset', {
    Text = 'offset: ',
    Min = 0,
    Max = 1,
    Default = _G.LightingSettings.Atmosphere.Offset,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.Offset = v
        applycustomatmo()
    end
})
ambienceTab:AddToggle('atmosphere_sound_toggle', {
    Text = 'enable',
    Default = _G.LightingSettings.Atmosphere.SoundEnabled,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.SoundEnabled = v
        playambientsound()
    end
})
ambienceTab:AddDropdown('atmosphere_ambient_sound', {
    Text = 'ambient sound',
    Values = {"None", "Rain", "Night", "Birds Chirping", "Jungle Birds", "Campfire Crackling", "Night Crickets", "Snow Storm"},
    Default = _G.LightingSettings.Atmosphere.SelectedSound,
    Multi = false,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.SelectedSound = v
        playambientsound()
    end
})
ambienceTab:AddSlider('atmosphere_sound_volume', {
    Text = 'volume',
    Min = 0,
    Max = 10,
    Default = _G.LightingSettings.Atmosphere.SoundVolume,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        _G.LightingSettings.Atmosphere.SoundVolume = v
        if curambientsound then
            curambientsound.Volume = v
        end
    end
})
local killSoundsTab = Tabs.World:AddRightGroupbox('kill sounds')
local ksCfg = _G.Features.KillSounds
local ksLocalPlayer = game:GetService("Players").LocalPlayer
local KILL_SOUND_FOLDER = "KillSounds"
local KILL_SOUND_DIR = KILL_SOUND_FOLDER .. "/sounds"
local KILL_SOUND_NAMES = { "sound 1", "sound 2", "sound 3" }
local KILL_SOUND_BY_NAME = {
    ["sound 1"] = "kill_1.mp3",
    ["sound 2"] = "kill_2.mp3",
    ["sound 3"] = "kill_3.mp3",
}
local KILL_SOUND_URLS = {
    ["kill_1.mp3"] = "https://files.catbox.moe/ub7f65.mp3",
    ["kill_2.mp3"] = "https://files.catbox.moe/gdixkv.mp3",
    ["kill_3.mp3"] = "https://files.catbox.moe/68n74h.mp3",
}
local killSoundLastAt = {}
local function downloadKillSounds()
    if not (isfolder and makefolder and writefile and isfile and type(game.HttpGet) == "function") then
        return
    end
    if not isfolder(KILL_SOUND_FOLDER) then
        makefolder(KILL_SOUND_FOLDER)
    end
    if not isfolder(KILL_SOUND_DIR) then
        makefolder(KILL_SOUND_DIR)
    end
    for filename, url in pairs(KILL_SOUND_URLS) do
        local fullPath = KILL_SOUND_DIR .. "/" .. filename
        if not isfile(fullPath) then
            local ok, data = pcall(function()
                return game:HttpGet(url, true)
            end)
            if ok and type(data) == "string" and #data > 128 then
                writefile(fullPath, data)
            end
            task.wait(0.6)
        end
    end
end
task.spawn(downloadKillSounds)
local function shouldCreditKill(plr)
    if not plr or plr == ksLocalPlayer then
        return false
    end
    local lastShot = getgenv().InstanceCombatLastShotAt or 0
    if tick() - lastShot < 4 then
        return true
    end
    local rbCfg = ragebot and ragebot.config
    local rp = ragebot and ragebot.ragePerf
    if rbCfg and rbCfg.target and rbCfg.target.lastplayer == plr then
        return true
    end
    if rbCfg and rbCfg.target and rbCfg.target.enabled and rbCfg.target.character then
        local tp = game:GetService("Players"):GetPlayerFromCharacter(rbCfg.target.character)
        if tp == plr then
            return true
        end
    end
    if rp and rp.lastHitAtByPlayer then
        local lastHit = rp.lastHitAtByPlayer[plr]
        if lastHit ~= nil and tick() - lastHit < 4 then
            return true
        end
    end
    return false
end
local function playKillSound()
    if not ksCfg.Enabled then
        return
    end
    local assetFn = getsynasset or getcustomasset
    if not (isfile and assetFn) then
        return
    end
    local style = ksCfg.Sound or "sound 1"
    local filename = KILL_SOUND_BY_NAME[style] or KILL_SOUND_BY_NAME["sound 1"]
    local fullPath = KILL_SOUND_DIR .. "/" .. filename
    if not isfile(fullPath) then
        task.spawn(downloadKillSounds)
        return
    end
    local assetOk, soundId = pcall(assetFn, fullPath)
    if not assetOk or type(soundId) ~= "string" or soundId == "" then
        return
    end
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = math.clamp((ksCfg.Volume or 50) / 100, 0, 1)
    sound.PlaybackSpeed = math.clamp((ksCfg.Pitch or 100) / 100, 0.1, 3)
    sound.Parent = workspace.CurrentCamera or workspace
    sound:Play()
    task.delay(6, function()
        if sound and sound.Parent then
            sound:Destroy()
        end
    end)
end
getgenv().InstancePlayKillSound = playKillSound
getgenv().InstanceTryKillSound = function(plr, lastHp, newHp)
    if not ksCfg.Enabled then
        return
    end
    if not plr or plr == ksLocalPlayer then
        return
    end
    if (newHp or 0) > 0 then
        return
    end
    if (lastHp or 0) <= 0 then
        return
    end
    if not shouldCreditKill(plr) then
        return
    end
    local now = tick()
    if now - (killSoundLastAt[plr] or 0) < 0.35 then
        return
    end
    killSoundLastAt[plr] = now
    playKillSound()
end
local killSoundsToggle = killSoundsTab:AddToggle('KillSoundsEnabled', {
    Text = 'enable',
    Default = ksCfg.Enabled,
    Callback = function(val)
        ksCfg.Enabled = val
    end,
})
local killSoundsDep = killSoundsTab:AddDependencyBox()
killSoundsDep:SetupDependencies({
    { killSoundsToggle, true },
})
killSoundsDep:AddDropdown('KillSoundStyle', {
    Text = 'sound',
    Default = ksCfg.Sound or "sound 1",
    Values = KILL_SOUND_NAMES,
    Callback = function(val)
        ksCfg.Sound = val
    end,
})
killSoundsDep:AddSlider('KillSoundVolume', {
    Text = 'volume',
    Default = ksCfg.Volume or 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        ksCfg.Volume = val
    end,
})
killSoundsDep:AddSlider('KillSoundPitch', {
    Text = 'pitch',
    Default = ksCfg.Pitch or 100,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Compact = true,
    Callback = function(val)
        ksCfg.Pitch = val
    end,
})
end)();
(function()
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local skyboxTabbox = Tabs.World:AddLeftTabbox()
local skyTab      = skyboxTabbox:AddTab('skybox')
local aspectTab   = skyboxTabbox:AddTab('aspect ratio')
_G.SkyboxSettings = _G.SkyboxSettings or {
    Enabled = false,
    CurrentSkybox = "Default",
    CustomTextures = {
        SkyboxBk = "rbxassetid://91458024",
        SkyboxDn = "rbxassetid://91457980",
        SkyboxFt = "rbxassetid://91458024",
        SkyboxLf = "rbxassetid://91458024",
        SkyboxRt = "rbxassetid://91458024",
        SkyboxUp = "rbxassetid://91458002",
    },
    DeleteDefaultSkybox = false,
    DisabledElements = {},
}
local Skyboxes = {
    Default = { SkyboxBk = "rbxassetid://91458024", SkyboxDn = "rbxassetid://91457980", SkyboxFt = "rbxassetid://91458024", SkyboxLf = "rbxassetid://91458024", SkyboxRt = "rbxassetid://91458024", SkyboxUp = "rbxassetid://91458002" },
    Neptune = { SkyboxBk = "rbxassetid://218955819", SkyboxDn = "rbxassetid://218953419", SkyboxFt = "rbxassetid://218954524", SkyboxLf = "rbxassetid://218958493", SkyboxRt = "rbxassetid://218957134", SkyboxUp = "rbxassetid://218950090" },
    ["Among Us"] = { SkyboxBk = "rbxassetid://5752463190", SkyboxDn = "rbxassetid://5752463190", SkyboxFt = "rbxassetid://5752463190", SkyboxLf = "rbxassetid://5752463190", SkyboxRt = "rbxassetid://5752463190", SkyboxUp = "rbxassetid://5752463190" },
    Nebula = { SkyboxBk = "rbxassetid://159454299", SkyboxDn = "rbxassetid://159454296", SkyboxFt = "rbxassetid://159454293", SkyboxLf = "rbxassetid://159454286", SkyboxRt = "rbxassetid://159454300", SkyboxUp = "rbxassetid://159454288" },
    Vaporwave = { SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494146", SkyboxFt = "rbxassetid://1417494253", SkyboxLf = "rbxassetid://1417494402", SkyboxRt = "rbxassetid://1417494499", SkyboxUp = "rbxassetid://1417494643" },
    Clouds = { SkyboxBk = "rbxassetid://570557514", SkyboxDn = "rbxassetid://570557775", SkyboxFt = "rbxassetid://570557559", SkyboxLf = "rbxassetid://570557620", SkyboxRt = "rbxassetid://570557672", SkyboxUp = "rbxassetid://570557727" },
    Twilight = { SkyboxBk = "rbxassetid://264908339", SkyboxDn = "rbxassetid://264907909", SkyboxFt = "rbxassetid://264909420", SkyboxLf = "rbxassetid://264909758", SkyboxRt = "rbxassetid://264908886", SkyboxUp = "rbxassetid://264907379" },
    DaBaby = { SkyboxBk = "rbxassetid://7245418472", SkyboxDn = "rbxassetid://7245418472", SkyboxFt = "rbxassetid://7245418472", SkyboxLf = "rbxassetid://7245418472", SkyboxRt = "rbxassetid://7245418472", SkyboxUp = "rbxassetid://7245418472" },
    Minecraft = { SkyboxBk = "rbxassetid://1876545003", SkyboxDn = "rbxassetid://1876544331", SkyboxFt = "rbxassetid://1876542941", SkyboxLf = "rbxassetid://1876543392", SkyboxRt = "rbxassetid://1876543764", SkyboxUp = "rbxassetid://1876544642" },
    Chill = { SkyboxBk = "rbxassetid://5084575798", SkyboxDn = "rbxassetid://5084575916", SkyboxFt = "rbxassetid://5103949679", SkyboxLf = "rbxassetid://5103948542", SkyboxRt = "rbxassetid://5103948784", SkyboxUp = "rbxassetid://5084576400" },
    Redshift = { SkyboxBk = "rbxassetid://401664839", SkyboxDn = "rbxassetid://401664862", SkyboxFt = "rbxassetid://401664960", SkyboxLf = "rbxassetid://401664881", SkyboxRt = "rbxassetid://401664901", SkyboxUp = "rbxassetid://401664936" },
    ["Blue Stars"] = { SkyboxBk = "rbxassetid://149397684", SkyboxDn = "rbxassetid://149397686", SkyboxFt = "rbxassetid://149397688", SkyboxLf = "rbxassetid://149397692", SkyboxRt = "rbxassetid://149397697", SkyboxUp = "rbxassetid://149397702" },
    ["Blue Aurora"] = { SkyboxBk = "rbxassetid://12063984", SkyboxDn = "rbxassetid://12064107", SkyboxFt = "rbxassetid://12064152", SkyboxLf = "rbxassetid://12064121", SkyboxRt = "rbxassetid://12064115", SkyboxUp = "rbxassetid://12064131" },
    Realistic = { SkyboxBk = "rbxassetid://144933338", SkyboxDn = "rbxassetid://144931530", SkyboxFt = "rbxassetid://144933262", SkyboxLf = "rbxassetid://144933244", SkyboxRt = "rbxassetid://144933299", SkyboxUp = "rbxassetid://144931564" },
    StarsShader = { SkyboxBk = "rbxassetid://169210090", SkyboxDn = "rbxassetid://169210108", SkyboxFt = "rbxassetid://169210121", SkyboxLf = "rbxassetid://169210133", SkyboxRt = "rbxassetid://169210143", SkyboxUp = "rbxassetid://169210149" },
    Gloomy = { SkyboxBk = "rbxassetid://5346760450", SkyboxDn = "rbxassetid://5346760689", SkyboxFt = "rbxassetid://5346760919", SkyboxLf = "rbxassetid://5346761102", SkyboxRt = "rbxassetid://5346761335", SkyboxUp = "rbxassetid://5346761509" },
    ["Nebula Purple"] = { SkyboxBk = "rbxassetid://129876530632297", SkyboxDn = "rbxassetid://108406529909981", SkyboxFt = "rbxassetid://104400530594543", SkyboxLf = "rbxassetid://73372229972523", SkyboxRt = "rbxassetid://87408857415924", SkyboxUp = "rbxassetid://13781740568136" },
    Jungle = { SkyboxBk = "rbxassetid://214399891", SkyboxDn = "rbxassetid://214399887", SkyboxFt = "rbxassetid://214399894", SkyboxLf = "rbxassetid://214405668", SkyboxRt = "rbxassetid://214399899", SkyboxUp = "rbxassetid://214399889" },
    Spongebob = { SkyboxBk = "rbxassetid://15962101128", SkyboxDn = "rbxassetid://15970246218", SkyboxFt = "rbxassetid://15962101128", SkyboxLf = "rbxassetid://15962101128", SkyboxRt = "rbxassetid://15962101128", SkyboxUp = "rbxassetid://15962901054" },
    ["mountain scape"] = { SkyboxBk = "rbxassetid://12474836637", SkyboxDn = "rbxassetid://12474837052", SkyboxFt = "rbxassetid://12474836748", SkyboxLf = "rbxassetid://12474836935", SkyboxRt = "rbxassetid://12474836446", SkyboxUp = "rbxassetid://12474835757" },
    ["yellowy cloud"] = { SkyboxBk = "rbxassetid://252760981", SkyboxDn = "rbxassetid://252763035", SkyboxFt = "rbxassetid://252761439", SkyboxLf = "rbxassetid://252760980", SkyboxRt = "rbxassetid://252760986", SkyboxUp = "rbxassetid://252762652" },
    Aurora = { SkyboxBk = "rbxassetid://340908398", SkyboxDn = "rbxassetid://340908450", SkyboxFt = "rbxassetid://340908468", SkyboxLf = "rbxassetid://340908504", SkyboxRt = "rbxassetid://340908530", SkyboxUp = "rbxassetid://340908586" },
    ["winter mountain"] = { SkyboxBk = "rbxassetid://402229526", SkyboxDn = "rbxassetid://402229596", SkyboxFt = "rbxassetid://402229293", SkyboxLf = "rbxassetid://402229368", SkyboxRt = "rbxassetid://402229417", SkyboxUp = "rbxassetid://402229564" },
    stormy = { SkyboxBk = "rbxassetid://255027929", SkyboxDn = "rbxassetid://255027967", SkyboxFt = "rbxassetid://255027923", SkyboxLf = "rbxassetid://255027938", SkyboxRt = "rbxassetid://255027946", SkyboxUp = "rbxassetid://255027960" },
}
local skyboxconn = nil
local deleteskyboxconn = nil
local customSky = nil
local origsky = nil
local storedorigsky = nil
local function storeorigsky()
    origsky = Lighting:FindFirstChildOfClass("Sky")
    if origsky then
        storedorigsky = origsky:Clone()
    end
end
storeorigsky()
local function ormakeskybox()
    if not customSky then
        customSky = Instance.new("Sky")
        customSky.Name = "CustomSkybox"
        customSky.Parent = Lighting
    end
    return customSky
end
local function removecustomsky()
    if customSky then
        customSky:Destroy()
        customSky = nil
    end
end
local function skyboxupdater()
    if skyboxconn then skyboxconn:Disconnect() end
    skyboxconn = RunService.RenderStepped:Connect(function()
        if not _G.SkyboxSettings.Enabled then
            removecustomsky()
            return
        end
        local sky = ormakeskybox()
        local textures = Skyboxes[_G.SkyboxSettings.CurrentSkybox] or _G.SkyboxSettings.CustomTextures
        sky.SkyboxBk = textures.SkyboxBk
        sky.SkyboxDn = textures.SkyboxDn
        sky.SkyboxFt = textures.SkyboxFt
        sky.SkyboxLf = textures.SkyboxLf
        sky.SkyboxRt = textures.SkyboxRt
        sky.SkyboxUp = textures.SkyboxUp
        sky.SunAngularSize = table.find(_G.SkyboxSettings.DisabledElements, "Sun") and 0 or 20
        sky.MoonAngularSize = table.find(_G.SkyboxSettings.DisabledElements, "Moon") and 0 or 11
        sky.StarCount = table.find(_G.SkyboxSettings.DisabledElements, "Stars") and 0 or 3000
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("Sky") and obj ~= sky then
                obj:Destroy()
            end
        end
    end)
end
local function stopSkyboxUpdater()
    if skyboxconn then
        skyboxconn:Disconnect()
        skyboxconn = nil
    end
    removecustomsky()
end
skyTab:AddToggle('skybox_master', {
    Text = 'enable',
    Default = _G.SkyboxSettings.Enabled,
    Callback = function(v)
        _G.SkyboxSettings.Enabled = v
        if v then
            skyboxupdater()
        else
            stopSkyboxUpdater()
        end
    end
})
local skyboxList = {}
for name, _ in pairs(Skyboxes) do
    table.insert(skyboxList, name)
end
table.sort(skyboxList)
skyTab:AddDropdown('skybox_selection', {
    Text = 'skybox',
    Default = _G.SkyboxSettings.CurrentSkybox,
    Values = skyboxList,
    Callback = function(v)
        _G.SkyboxSettings.CurrentSkybox = v
    end
})
skyTab:AddDropdown('disable_elements', {
    Text = 'disable elements',
    Values = {"Sun", "Moon", "Stars"},
    Default = _G.SkyboxSettings.DisabledElements,
    Multi = true,
    Callback = function(v)
        _G.SkyboxSettings.DisabledElements = v
    end
})
_G.AspectRatioSettings = _G.AspectRatioSettings or {
    Enabled = false,
    X = 13,
    Y = 10
}
local Camera = workspace.CurrentCamera
local aspectratioconn = nil
local function calcratio()
    return _G.AspectRatioSettings.X / _G.AspectRatioSettings.Y
end
local ASPECT_RATIO_BIND = "InstanceAspectRatio"
local function updateaspectratio()
    if not _G.AspectRatioSettings.Enabled or not Camera then return end
    local ratio = calcratio()
    local cf = Camera.CFrame
    Camera.CFrame = CFrame.fromMatrix(cf.Position, cf.RightVector, cf.UpVector * ratio, -cf.LookVector)
end
local function aspectratioupdater()
    if aspectratioconn then
        if typeof(aspectratioconn) == "RBXScriptConnection" then
            aspectratioconn:Disconnect()
        end
        aspectratioconn = nil
    end
    pcall(function()
        RunService:UnbindFromRenderStep(ASPECT_RATIO_BIND)
    end)
    local ok = pcall(function()
        RunService:BindToRenderStep(ASPECT_RATIO_BIND, Enum.RenderPriority.Camera.Value + 2, updateaspectratio)
    end)
    if not ok then
        aspectratioconn = RunService.RenderStepped:Connect(updateaspectratio)
    end
end
local function stopaspectratio()
    if aspectratioconn then
        if typeof(aspectratioconn) == "RBXScriptConnection" then
            aspectratioconn:Disconnect()
        end
        aspectratioconn = nil
    end
    pcall(function()
        RunService:UnbindFromRenderStep(ASPECT_RATIO_BIND)
    end)
end
aspectTab:AddToggle('aspect_ratio_master', {
    Text = 'enable',
    Default = _G.AspectRatioSettings.Enabled,
    Callback = function(v)
        _G.AspectRatioSettings.Enabled = v
        if v then
            aspectratioupdater()
        else
            stopaspectratio()
        end
    end
})
aspectTab:AddSlider('aspect_ratio_x', {
    Text = 'X ratio',
    Default = _G.AspectRatioSettings.X,
    Min = 1,
    Max = 13,
    Compact = true,
    Rounding = 0,
    Callback = function(v)
        _G.AspectRatioSettings.X = v
    end
})
aspectTab:AddSlider('aspect_ratio_y', {
    Text = 'Y ratio',
    Default = _G.AspectRatioSettings.Y,
    Min = 10,
    Max = 32,
    Compact = true,
    Rounding = 0,
    Callback = function(v)
        _G.AspectRatioSettings.Y = v
    end
})
if _G.SkyboxSettings.Enabled then
    skyboxupdater()
end
if _G.AspectRatioSettings.Enabled then
    aspectratioupdater()
end
getgenv().InstanceStopSkyboxUpdater = stopSkyboxUpdater
end)();
(function()
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local weathercfgs = {
    rain = {
        enabled = false,
        color = Color3.fromRGB(255, 255, 255),
        sizeScale = 1,
        rate = 100,
        speed_min = 60, speed_max = 60,
        size_min = 10, size_max = 10,
        transparency_min = 0.22, transparency_max = 1,
        spread = 0,
        brightness = 1,
        light_emission = 0.05,
        glowScale = 0,
        base_rate = 600,
        texture = "rbxassetid://1822883048",
        locked = true,
        orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
        light_influence = 0.9,
        lifetime_min = 0.8, lifetime_max = 0.8,
    },
    snow = {
        enabled = false,
        color = Color3.fromRGB(255, 255, 255),
        sizeScale = 1,
        rate = 100,
        amount = 100,
        speed_min = 30, speed_max = 30,
        size_min = 0.33, size_max = 0.40,
        transparency_min = 0.74, transparency_max = 1,
        spread = 0,
        brightness = 1,
        light_emission = 0.5,
        glowScale = 0,
        base_rate = 1000,
        texture = "http://www.roblox.com/asset/?id=99851851",
        locked = false,
        orientation = Enum.ParticleOrientation.FacingCamera,
        light_influence = 1,
        lifetime_min = 4, lifetime_max = 4,
    },
    lightrain = {
        enabled = false,
        color = Color3.fromRGB(255, 255, 255),
        sizeScale = 1,
        rate = 100,
        speed_min = 30, speed_max = 50,
        size_min = 0.2, size_max = 0.2,
        transparency_min = 0, transparency_max = 0,
        spread = 0,
        brightness = 2,
        light_emission = 0.5,
        glowScale = 0,
        base_rate = 500,
        texture = "rbxasset://textures/particles/sparkles_main.dds",
        locked = true,
        orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
        light_influence = 0.3,
        lifetime_min = 9, lifetime_max = 9,
    },
    stars = {
        enabled = false,
        color = Color3.fromRGB(255, 255, 255),
        sizeScale = 1,
        rate = 100,
        amount = 100,
        speed_min = 30, speed_max = 30,
        size_min = 0.33, size_max = 0.40,
        transparency_min = 0.74, transparency_max = 1,
        spread = 0,
        brightness = 1,
        light_emission = 0.5,
        glowScale = 0,
        base_rate = 1000,
        texture = "http://www.roblox.com/asset/?id=6822501679",
        locked = false,
        orientation = Enum.ParticleOrientation.FacingCamera,
        light_influence = 1,
        lifetime_min = 4, lifetime_max = 4,
    },
    hearts = {
        enabled = false,
        color = Color3.fromRGB(255, 255, 255),
        sizeScale = 1,
        rate = 100,
        amount = 100,
        speed_min = 30, speed_max = 30,
        size_min = 0.33, size_max = 0.40,
        transparency_min = 0.74, transparency_max = 1,
        spread = 0,
        brightness = 1,
        light_emission = 0.5,
        glowScale = 0,
        base_rate = 1000,
        texture = "http://www.roblox.com/asset/?id=36721240",
        locked = false,
        orientation = Enum.ParticleOrientation.FacingCamera,
        light_influence = 1,
        lifetime_min = 4, lifetime_max = 4,
    },
}
local weatherparts = {}
local weatherparticles = {}
local activeWeatherCount = 0  
local cam = workspace.CurrentCamera
local heightoffset = Vector3.new(0, 20, 0)
local function applyparticle(p, cfg)
    p.EmissionDirection = Enum.NormalId.Bottom
    p.LockedToPart = cfg.locked
    p.Orientation = cfg.orientation
    p.Texture = cfg.texture
    p.Speed = NumberRange.new(cfg.speed_min, math.max(cfg.speed_min, cfg.speed_max))
    p.Lifetime = NumberRange.new(cfg.lifetime_min, math.max(cfg.lifetime_min, cfg.lifetime_max))
    p.SpreadAngle = Vector2.new(cfg.spread, cfg.spread)
    p.LightInfluence = cfg.light_influence
    local glow = math.clamp(tonumber(cfg.glowScale) or 0, 0, 5)
    if glow > 0 then
        local glowNorm = glow / 5
        p.Brightness = cfg.brightness * (1 + glow * 1.75)
        p.LightEmission = math.clamp((cfg.light_emission or 0) + glow * 0.2, 0, 1)
        p.LightInfluence = math.clamp((cfg.light_influence or 1) * (1 - glowNorm * 0.98), 0, 1)
    else
        p.Brightness = cfg.brightness
        p.LightEmission = cfg.light_emission
    end
    if cfg.amount then
        p.Rate = math.clamp(cfg.amount, 1, 1000)
    else
        p.Rate = cfg.base_rate * (cfg.rate / 100)
    end
    p.Size = NumberSequence.new{
        NumberSequenceKeypoint.new(0, cfg.size_min * (cfg.sizeScale or 1)),
        NumberSequenceKeypoint.new(1, cfg.size_max * (cfg.sizeScale or 1))
    }
    p.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, cfg.transparency_max),
        NumberSequenceKeypoint.new(0.25, cfg.transparency_min),
        NumberSequenceKeypoint.new(0.75, cfg.transparency_min),
        NumberSequenceKeypoint.new(1, cfg.transparency_max)
    }
    p.Color = ColorSequence.new(cfg.color)
end
local function build(key)
    local cfg = weathercfgs[key]
    if weatherparts[key] then
        weatherparts[key]:Destroy()
        weatherparts[key] = nil
        weatherparticles[key] = nil
        activeWeatherCount = activeWeatherCount - 1
    end
    local part = Instance.new("Part")
    part.Size = Vector3.new(40, 1, 85)
    part.CanCollide = false
    part.Massless = true
    part.CastShadow = false
    part.Transparency = 1
    part.Anchored = true
    part.Name = "\0"
    part.Parent = workspace
    weatherparts[key] = part
    local p = Instance.new("ParticleEmitter")
    applyparticle(p, cfg)
    p.Parent = part
    weatherparticles[key] = p
    activeWeatherCount = activeWeatherCount + 1
end
local function destroy(key)
    if weatherparts[key] then
        weatherparts[key]:Destroy()
        weatherparts[key] = nil
        weatherparticles[key] = nil
        activeWeatherCount = activeWeatherCount - 1
    end
end
local function refresh(key)
    if weatherparticles[key] then
        applyparticle(weatherparticles[key], weathercfgs[key])
    end
end
local function refreshActive()
    for key in next, weatherparticles do
        applyparticle(weatherparticles[key], weathercfgs[key])
    end
end
RunService.PostSimulation:Connect(function()
    if activeWeatherCount == 0 then return end
    local pos = cam.CFrame.Position + heightoffset
    local cf = CFrame.new(pos)
    for _, part in next, weatherparts do
        part.CFrame = cf
    end
end)
local sharedCfg = {
    color = Color3.fromRGB(255, 255, 255),
    rate = 100,
    speed_min = 40,
    speed_max = 60,
    size_min = 0.33,
    size_max = 0.40,
    transparency_min = 0.5,
    transparency_max = 1,
    spread = 0,
    brightness = 1,
    light_emission = 0.5,
    glowScale = 0,
    sizeScale = 1,
}
local function pushSharedToKey(key)
    local cfg = weathercfgs[key]
    cfg.color             = sharedCfg.color
    cfg.rate              = sharedCfg.rate
    cfg.speed_min         = sharedCfg.speed_min
    cfg.speed_max         = sharedCfg.speed_max
    cfg.size_min          = sharedCfg.size_min
    cfg.size_max          = sharedCfg.size_max
    cfg.transparency_min  = sharedCfg.transparency_min
    cfg.transparency_max  = sharedCfg.transparency_max
    cfg.spread            = sharedCfg.spread
    cfg.brightness        = sharedCfg.brightness
    cfg.light_emission    = sharedCfg.light_emission
    cfg.glowScale         = sharedCfg.glowScale
    cfg.sizeScale         = sharedCfg.sizeScale
end
local weatherBox = Tabs.World:AddLeftGroupbox('weather')
local weatherEnabled = false
weatherBox:AddToggle('weather_master_enable', {
    Text = 'enable',
    Default = false,
    Callback = function(value)
        weatherEnabled = value
        if not value then
            for key in next, weathercfgs do
                destroy(key)
            end
        end
    end
}):AddColorPicker('weather_color', {
    Default = sharedCfg.color,
    Title = 'color',
    Callback = function(value)
        sharedCfg.color = value
        for key in next, weatherparticles do
            weathercfgs[key].color = value
            weatherparticles[key].Color = ColorSequence.new(value)
        end
    end
})
local keyMap = {
    ['rain']       = 'rain',
    ['snow']       = 'snow',
    ['light rain'] = 'lightrain',
    ['stars']      = 'stars',
    ['hearts']     = 'hearts',
}
weatherBox:AddDropdown('weather_effects', {
    Text = 'effects',
    Values = { 'rain', 'snow', 'light rain', 'stars', 'hearts' },
    Default = {},
    Multi = true,
    Tooltip = 'select which weather effects to enable',
    Callback = function(selected)
        for displayName, cfgKey in next, keyMap do
            local active = selected[displayName] == true
            weathercfgs[cfgKey].enabled = active
            if active and weatherEnabled then
                build(cfgKey)
                pushSharedToKey(cfgKey)
                refresh(cfgKey)
            elseif not active then
                destroy(cfgKey)
            end
        end
    end
})
weatherBox:AddSlider('weather_rate', {
    Text = 'rate',
    Default = sharedCfg.rate,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Compact = true,
    Callback = function(value)
        sharedCfg.rate = value
        for key in next, weatherparticles do
            weathercfgs[key].rate = value
            weatherparticles[key].Rate = weathercfgs[key].base_rate * (value / 100)
        end
    end
})
weatherBox:AddSlider('weather_speed_min', {
    Text = 'speed min',
    Default = sharedCfg.speed_min,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Compact = true,
    Callback = function(value)
        sharedCfg.speed_min = value
        for key in next, weatherparticles do weathercfgs[key].speed_min = value end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_speed_max', {
    Text = 'speed max',
    Default = sharedCfg.speed_max,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Compact = true,
    Callback = function(value)
        sharedCfg.speed_max = value
        for key in next, weatherparticles do weathercfgs[key].speed_max = value end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_size_min', {
    Text = 'size min',
    Default = sharedCfg.size_min,
    Min = 0.1,
    Max = 50,
    Rounding = 2,
    Compact = true,
    Callback = function(value)
        sharedCfg.size_min = value
        for key in next, weatherparticles do weathercfgs[key].size_min = value end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_size_max', {
    Text = 'size max',
    Default = sharedCfg.size_max,
    Min = 0.1,
    Max = 50,
    Rounding = 2,
    Compact = true,
    Callback = function(value)
        sharedCfg.size_max = value
        for key in next, weatherparticles do weathercfgs[key].size_max = value end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_opacity_min', {
    Text = 'opacity min',
    Default = math.floor((1 - sharedCfg.transparency_min) * 100),
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Compact = true,
    Callback = function(value)
        sharedCfg.transparency_min = 1 - (value / 100)
        for key in next, weatherparticles do weathercfgs[key].transparency_min = sharedCfg.transparency_min end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_opacity_max', {
    Text = 'opacity max',
    Default = math.floor((1 - sharedCfg.transparency_max) * 100),
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Compact = true,
    Callback = function(value)
        sharedCfg.transparency_max = 1 - (value / 100)
        for key in next, weatherparticles do weathercfgs[key].transparency_max = sharedCfg.transparency_max end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_spread', {
    Text = 'spread',
    Default = 0,
    Min = 0,
    Max = 180,
    Rounding = 0,
    Suffix = '°',
    Compact = true,
    Callback = function(value)
        sharedCfg.spread = value
        for key in next, weatherparticles do weathercfgs[key].spread = value end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_brightness', {
    Text = 'brightness',
    Default = sharedCfg.brightness * 100,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Suffix = '%',
    Compact = true,
    Callback = function(value)
        sharedCfg.brightness = value / 100
        for key in next, weatherparticles do weathercfgs[key].brightness = sharedCfg.brightness end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_emission', {
    Text = 'light emission',
    Default = sharedCfg.light_emission * 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Compact = true,
    Callback = function(value)
        sharedCfg.light_emission = value / 100
        for key in next, weatherparticles do weathercfgs[key].light_emission = sharedCfg.light_emission end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_glow', {
    Text = 'glow',
    Default = sharedCfg.glowScale,
    Min = 0,
    Max = 5,
    Rounding = 2,
    Suffix = 'x',
    Compact = true,
    Callback = function(value)
        sharedCfg.glowScale = value
        for key in next, weatherparticles do weathercfgs[key].glowScale = value end
        refreshActive()
    end
})
weatherBox:AddSlider('weather_sizescale', {
    Text = 'particle size',
    Default = sharedCfg.sizeScale,
    Min = 0.1,
    Max = 5,
    Rounding = 2,
    Suffix = 'x',
    Compact = true,
    Callback = function(value)
        sharedCfg.sizeScale = value
        for key in next, weatherparticles do weathercfgs[key].sizeScale = value end
        refreshActive()
    end
})
game:GetService("ScriptContext").DescendantRemoving:Connect(function(descendant)
    if descendant == script then
        local stopSkyboxUpdater = getgenv().InstanceStopSkyboxUpdater
        if stopSkyboxUpdater then
            stopSkyboxUpdater()
        end
    end
end)
end)();
(function()
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local WatermarkConnection = game:GetService('RunService').Heartbeat:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
        Library:SetWatermark(('instance | %s fps'):format(
            math.floor(FPS)
        ))
    end
end)
Library:SetWatermark('instance')
Library:OnUnload(function()
    if WatermarkConnection then
        WatermarkConnection:Disconnect()
    end
    local mc = getgenv().InstanceMenuCursor
    if mc then
        if mc.cursor then pcall(function() mc.cursor:Remove() end) end
        if mc.outline then pcall(function() mc.outline:Remove() end) end
        mc.initialized = false
    end
    if kbHeartbeatConn then
        kbHeartbeatConn:Disconnect()
        kbHeartbeatConn = nil
    end
    local kb = getgenv().InstanceKeybindList
    if kb and kb.gui then
        pcall(function() kb.gui:Destroy() end)
    end
    getgenv().InstanceKeybindList = nil
    Library.Unloaded = true
end)
Library.KeybindFrame.Visible = false
getgenv().InstanceKeybindList = getgenv().InstanceKeybindList or {}
local kbList = getgenv().InstanceKeybindList
local KB_ROW_H = 18
local KB_PAD = 8
local KB_TITLE_H = 28
local KB_HEADER_H = 36
local KB_ROW_GAP = 3
local KB_MIN_W = 148
local KB_MAX_W = 260
local KB_LIST_UI_VER = 4
local KB_MAX_ROWS = 24
local KB_REFRESH_INTERVAL = 0.5
local kbRefreshAccum = 0
local kbLastSig = ""
local kbThemeDirty = true
local kbHeartbeatConn = nil
local INSTANCE_KB_LABELS = {
    SilentAimKey = "silent aim",
    SelectTargetKey = "backshoot",
    AimbotKey = "aimbot",
    TargetKey = "ragebot",
    ThirdPersonKey = "third person",
    cframespf_key = "walkspeed",
    cframefly_key = "fly",
    shaders_key = "shaders",
    MenuKeybind = "menu",
    AnimKey = "anim",
}
local function kbLower(s)
    return string.lower(tostring(s or ""))
end
local function resolveKbFeatureName(idx, opt)
    local mapped = INSTANCE_KB_LABELS[idx]
    if mapped then return mapped end
    local text = opt and (opt.Text or opt.Title)
    if type(text) == "string" and text ~= "" then
        return kbLower(text)
    end
    return kbLower((tostring(idx)):gsub("_key$", ""):gsub("_", " "))
end
local function kbTheme(name, fb)
    if Library and Library[name] then return Library[name] end
    return fb
end
local function kbTextWidth(text, textSize)
    text = tostring(text or "")
    local ts = game:GetService("TextService")
    local ok, sz = pcall(function()
        local fontFace = getgenv().InstanceGetUiFont and getgenv().InstanceGetUiFont()
        if typeof(fontFace) == "Font" then
            return ts:GetTextSize(text, textSize, fontFace, Vector2.new(999, 24))
        end
        return ts:GetTextSize(text, textSize, Enum.Font.GothamMedium, Vector2.new(999, 24))
    end)
    if ok and sz then return sz.X end
    return #text * 6.5
end
local function kbCalcPanelWidth(rows)
    local w = kbTextWidth("keybinds", 14) + KB_PAD * 2 + 8
    for _, data in ipairs(rows) do
        w = math.max(w, kbTextWidth(data.text, 12) + KB_PAD * 2 + 12)
    end
    return math.clamp(math.ceil(w), KB_MIN_W, KB_MAX_W)
end
local applyKbListTheme
local function buildKbListUi()
    if kbList.gui and kbList.uiVer == KB_LIST_UI_VER then return end
    if kbList.gui then
        pcall(function() kbList.gui:Destroy() end)
        kbList.gui = nil
        kbList.outer = nil
        kbList.inner = nil
        kbList.scroll = nil
        kbList.rowPool = {}
    end
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "instance_keybind_list"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = INSTANCE_KEYBIND_LIST_ORDER
    gui.Enabled = false
    gui.Parent = parent
    local outer = Instance.new("Frame")
    outer.Name = "KbOuter"
    outer.Size = UDim2.fromOffset(KB_MIN_W, 72)
    outer.Position = UDim2.new(0, 10, 0.5, -36)
    outer.BorderSizePixel = 0
    outer.BackgroundColor3 = Color3.new(0, 0, 0)
    outer.Active = true
    outer.Draggable = true
    outer.Parent = gui
    local inner = Instance.new("Frame")
    inner.Name = "KbInner"
    inner.Size = UDim2.new(1, -2, 1, -2)
    inner.Position = UDim2.fromOffset(1, 1)
    inner.BorderSizePixel = 1
    inner.BorderMode = Enum.BorderMode.Inset
    inner.Parent = outer
    local titleBar = Instance.new("Frame")
    titleBar.BackgroundTransparency = 1
    titleBar.Size = UDim2.new(1, 0, 0, KB_TITLE_H)
    titleBar.Parent = inner
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.fromOffset(0, 0)
    title.Text = "keybinds"
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = titleBar
    getgenv().InstanceApplyUiFont(title, 14)
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.BorderSizePixel = 0
    divider.Size = UDim2.new(1, -(KB_PAD * 2), 0, 1)
    divider.Position = UDim2.new(0, KB_PAD, 0, KB_TITLE_H - 1)
    divider.Parent = inner
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "List"
    scroll.BorderSizePixel = 1
    scroll.BorderMode = Enum.BorderMode.Inset
    scroll.BackgroundTransparency = 0
    scroll.Size = UDim2.new(1, -(KB_PAD * 2), 1, -(KB_HEADER_H + KB_PAD))
    scroll.Position = UDim2.new(0, KB_PAD, 0, KB_HEADER_H)
    scroll.CanvasSize = UDim2.fromOffset(0, 0)
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageTransparency = 0.25
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.Parent = inner
    local layout = Instance.new("UIListLayout")
    layout.Name = "KbListLayout"
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, KB_ROW_GAP)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = scroll
    local scrollPad = Instance.new("UIPadding")
    scrollPad.PaddingLeft = UDim.new(0, 4)
    scrollPad.PaddingRight = UDim.new(0, 4)
    scrollPad.PaddingTop = UDim.new(0, 4)
    scrollPad.PaddingBottom = UDim.new(0, 4)
    scrollPad.Parent = scroll
    kbList.gui = gui
    kbList.outer = outer
    kbList.inner = inner
    kbList.scroll = scroll
    kbList.layout = layout
    kbList.title = title
    kbList.divider = divider
    kbList.rowPool = {}
    for i = 1, KB_MAX_ROWS do
        local rowFrame = Instance.new("Frame")
        rowFrame.BorderSizePixel = 0
        rowFrame.BackgroundTransparency = 1
        rowFrame.Size = UDim2.new(1, 0, 0, KB_ROW_H)
        rowFrame.Visible = false
        rowFrame.Parent = scroll
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Position = UDim2.fromOffset(0, 0)
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Parent = rowFrame
        getgenv().InstanceApplyUiFont(lbl, 12)
        kbList.rowPool[i] = { frame = rowFrame, lbl = lbl }
    end
    kbList.uiVer = KB_LIST_UI_VER
    kbThemeDirty = true
    if applyKbListTheme then applyKbListTheme() end
end
applyKbListTheme = function()
    if not kbList.inner then return end
    local main = kbTheme("MainColor", Color3.fromRGB(28, 28, 28))
    local bg = kbTheme("BackgroundColor", Color3.fromRGB(20, 20, 20))
    local accent = kbTheme("AccentColor", Color3.fromRGB(0, 200, 255))
    local font = kbTheme("FontColor", Color3.fromRGB(255, 255, 255))
    local outline = kbTheme("OutlineColor", Color3.fromRGB(50, 50, 50))
    if kbList.outer then
        kbList.outer.BackgroundColor3 = Color3.new(0, 0, 0)
        kbList.outer.BorderSizePixel = 0
    end
    kbList.inner.BackgroundColor3 = main
    kbList.inner.BorderColor3 = outline
    if kbList.title then
        kbList.title.TextColor3 = font
        getgenv().InstanceApplyUiFont(kbList.title, 14)
    end
    if kbList.divider then
        kbList.divider.BackgroundColor3 = accent
        kbList.divider.BorderSizePixel = 0
    end
    if kbList.scroll then
        kbList.scroll.BackgroundColor3 = bg
        kbList.scroll.BackgroundTransparency = 0
        kbList.scroll.BorderSizePixel = 1
        kbList.scroll.BorderColor3 = outline
        kbList.scroll.ScrollBarImageColor3 = accent
        kbList.scroll.ScrollBarImageTransparency = 0.25
    end
    for _, row in ipairs(kbList.rowPool) do
        if row.lbl then
            row.lbl.TextColor3 = font
            getgenv().InstanceApplyUiFont(row.lbl, 12)
        end
        if row.frame then
            row.frame.BackgroundTransparency = 1
        end
    end
    kbThemeDirty = false
end
local function kbBuildSignature()
    if not Options then return "" end
    local parts = {}
    for idx, opt in pairs(Options) do
        if opt and opt.Type == "KeyPicker" then
            local key = opt.Value
            if key and key ~= "None" and key ~= "" then
                parts[#parts + 1] = tostring(idx) .. ":" .. tostring(key)
            end
        end
    end
    table.sort(parts)
    return table.concat(parts, "|")
end
local function collectKbRows()
    local out = {}
    if not Options then return out end
    for idx, opt in pairs(Options) do
        if opt and opt.Type == "KeyPicker" then
            local key = opt.Value
            if key and key ~= "None" and key ~= "" then
                local feature = resolveKbFeatureName(idx, opt)
                local bind = kbLower(key)
                out[#out + 1] = {
                    text = feature .. " - " .. bind,
                }
            end
        end
    end
    table.sort(out, function(a, b)
        return a.text < b.text
    end)
    return out
end
local function refreshKbList(force)
    if not kbList.scroll then return end
    local sig = kbBuildSignature()
    if not force and sig == kbLastSig then return end
    kbLastSig = sig
    local rows = collectKbRows()
    local rowCount = math.min(#rows, KB_MAX_ROWS)
    for i = 1, KB_MAX_ROWS do
        local row = kbList.rowPool[i]
        if not row then continue end
        if i <= rowCount then
            local data = rows[i]
            row.frame.Visible = true
            if row.lbl and data then
                local nextText = data.text
                if row.lbl.Text ~= nextText then
                    row.lbl.Text = nextText
                end
            end
        elseif row.frame then
            row.frame.Visible = false
        end
    end
    local rowH = KB_ROW_H + KB_ROW_GAP
    local contentH = math.max(rowCount * KB_ROW_H + math.max(rowCount - 1, 0) * KB_ROW_GAP, 0)
    local panelW = kbCalcPanelWidth(rows)
    local listH = math.max(rowCount, 1) * rowH + 8
    local outerH = math.clamp(KB_HEADER_H + KB_PAD + listH + KB_PAD, 72, 360)
    local scrollAreaH = outerH - KB_HEADER_H - KB_PAD
    local canvasH = math.max(contentH, scrollAreaH)
    if kbList.layout then
        kbList.layout.VerticalAlignment = rowCount <= 2
            and Enum.VerticalAlignment.Center
            or Enum.VerticalAlignment.Top
    end
    if kbList.scroll.CanvasSize.Y.Offset ~= canvasH then
        kbList.scroll.CanvasSize = UDim2.fromOffset(0, canvasH)
    end
    if kbList.outer then
        local cur = kbList.outer.Size
        if cur.X.Offset ~= panelW or cur.Y.Offset ~= outerH then
            kbList.outer.Size = UDim2.fromOffset(panelW, outerH)
        end
    end
    if kbThemeDirty then
        applyKbListTheme()
    end
end
getgenv().InstanceApplyKbListTheme = function()
    kbThemeDirty = true
    applyKbListTheme()
end
getgenv().InstanceRefreshKbList = function(force)
    refreshKbList(force == true)
end
getgenv().syncKbListVisible = function()
    buildKbListUi()
    local want = Toggles and Toggles.KeybindVisible and Toggles.KeybindVisible.Value
    local open = isInstanceMenuOpen()
    kbList.visible = want == true and not open
    if kbList.gui then
        kbList.gui.Enabled = kbList.visible
    end
    if kbList.visible then
        kbLastSig = ""
        kbThemeDirty = true
        refreshKbList(true)
    end
end
local function bindKbListHeartbeat()
    if kbHeartbeatConn then return end
    local rsKb = game:GetService("RunService")
    kbHeartbeatConn = rsKb.Heartbeat:Connect(function(dt)
        if Library.Unloaded then
            if kbHeartbeatConn then
                kbHeartbeatConn:Disconnect()
                kbHeartbeatConn = nil
            end
            return
        end
        if not kbList.visible or not kbList.gui or not kbList.gui.Enabled then
            kbRefreshAccum = 0
            return
        end
        kbRefreshAccum = kbRefreshAccum + (dt or 0)
        if kbRefreshAccum < KB_REFRESH_INTERVAL then return end
        kbRefreshAccum = 0
        pcall(refreshKbList)
    end)
end
bindKbListHeartbeat()
do
    local prevSync = getgenv().InstanceSyncAfterConfigLoad
    getgenv().InstanceSyncAfterConfigLoad = function()
        if prevSync then pcall(prevSync) end
        if getgenv().syncKbListVisible then pcall(getgenv().syncKbListVisible) end
    end
end
MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('menu settings')
local function closeKeyPickerModeMenus()
    if not Library or not Library.ScreenGui then return end
    for _, child in ipairs(Library.ScreenGui:GetChildren()) do
        if child:IsA("Frame") and child.ZIndex >= 14 and child.ZIndex <= 16 then
            child.Visible = false
        end
    end
end
local function syncMenuOverlayUi()
    applyInstanceUiLayering()
    local open = isInstanceMenuOpen()
    closeKeyPickerModeMenus()
    if Library and Library.KeybindFrame then
        Library.KeybindFrame.Visible = false
    end
    if getgenv().syncKbListVisible then
        getgenv().syncKbListVisible()
    end
    if Library and Library.SetWatermarkVisibility then
        Library:SetWatermarkVisibility(not open)
    end
    if getgenv().syncCosmeticChangerVisibility then
        getgenv().syncCosmeticChangerVisibility()
    end
    if open and getgenv().InstanceCosmeticUIState and getgenv().InstanceCosmeticUIState.applyLiveViewModelUpdate then
        task.defer(function()
            pcall(getgenv().InstanceCosmeticUIState.applyLiveViewModelUpdate)
        end)
    end
    if open and getgenv().InstanceApplyCosmeticUiTheme then
        pcall(getgenv().InstanceApplyCosmeticUiTheme)
    end
end
if Window and Window.Holder then
    Window.Holder:GetPropertyChangedSignal("Visible"):Connect(syncMenuOverlayUi)
end
task.defer(syncMenuOverlayUi)
MenuGroup:AddLabel('menu bind'):AddKeyPicker('MenuKeybind', { 
    Default = 'RightShift', 
    NoUI = true, 
    Text = 'menu keybind' 
})
Library.ToggleKeybind = Options.MenuKeybind
MenuGroup:AddToggle('KeybindVisible', {
    Text = 'keybind list',
    Default = false,
    Callback = function()
        if getgenv().syncKbListVisible then
            getgenv().syncKbListVisible()
        end
    end
})
MenuGroup:AddSlider('tgbtgbbktbkmb', {
    Text = 'cap fps at (0 = off)',
    Default = 0,
    Min = 0,
    Max = 9999,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        if not setfpscap then return end
        if Value == nil or Value <= 0 or Value >= 9999 then
            setfpscap(0)
        else
            setfpscap(math.floor(Value))
        end
    end
})
MenuGroup:AddDropdown('InstanceLanguage', {
    Text = 'language',
    Values = { 'english', 'korean', 'spanish' },
    Default = getgenv().InstanceLanguage or 'english',
    Callback = function(val)
        getgenv().InstanceLanguage = val
        if getgenv().InstanceReloadLanguageFont then
            getgenv().InstanceReloadLanguageFont(val)
        end
        if getgenv().InstanceApplyUIFont then
            getgenv().InstanceApplyUIFont()
        end
        if getgenv().InstanceRefreshLocaleUI then
            pcall(getgenv().InstanceRefreshLocaleUI)
        end
    end,
})
MenuGroup:AddButton('Unload Menu', function()
    Library:Unload()
end)
end)();
(function()
local ServerGroup = Tabs['UI Settings']:AddRightGroupbox('server')
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function serverlist(cursor)
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then return nil end
    local success2, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    if not success2 or not data or not data.data then
        return nil
    end
    return data
end
local function allservers()
    local servers = {}
    local cursor = nil
    repeat
        local data = serverlist(cursor)
        if not data then break end
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server)
            end
        end
        cursor = data.nextPageCursor
    until not cursor
    return servers
end
ServerGroup:AddButton('Rejoin Server', function()
    if game.JobId ~= "" then
        Library:Notify("Rejoining server...", 3)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    else
        Library:Notify("No valid JobId.", 3)
    end
end)
ServerGroup:AddButton('Server Hop (Random)', function()
    local servers = allservers()
    if #servers == 0 then
        Library:Notify("No servers found.", 3)
        return
    end
    local s = servers[math.random(#servers)]
    Library:Notify("Hopping to server (" .. s.playing .. "/" .. s.maxPlayers .. " players)", 5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
end)
ServerGroup:AddButton('Join Lowest Players Server', function()
    local servers = allservers()
    if #servers == 0 then
        Library:Notify("No servers found.", 3)
        return
    end
    table.sort(servers, function(a, b)
        return a.playing < b.playing
    end)
    local s = servers[1]
    Library:Notify("Joining lowest server (" .. s.playing .. "/" .. s.maxPlayers .. " players)", 5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
end)
ServerGroup:AddButton('Join Biggest Server', function()
    local servers = allservers()
    if #servers == 0 then
        Library:Notify("No servers found.", 3)
        return
    end
    table.sort(servers, function(a, b)
        return a.playing > b.playing
    end)
    local s = servers[1]
    Library:Notify("Joining biggest server (" .. s.playing .. "/" .. s.maxPlayers .. " players)", 5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
end)
end)();
local characterSection = Tabs.Character:AddRightTabbox()
local p = game:GetService("Players").LocalPlayer
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
getgenv()._animCmd = getgenv()._animCmd or nil
local animPresets = {
    ["Meditate"] = "96579993895076", ["Orbit"] = "133811691098518", ["Orbit V2"] = "73208745607037",
    ["Orbit V3"] = "137869087140582", ["Floss"] = "72174079036035", ["OJ"] = "110064349530772",
    ["Kicking Feet"] = "131879764029003", ["Tweaking"] = "114353590132838", ["Crazy"] = "120819498172771",
    ["Crazy V2"] = "105670906411750", ["Take the L"] = "112884830175040", ["Hype"] = "80055417516516",
    ["Small / Hide"] = "91194251426204", ["Sea Lion"] = "117932365044349", ["Gangnam"] = "104142334418357",
    ["NLE"] = "125783279336153", ["The Man"] = "88737074755910", ["Spider Shit"] = "74716792202343",
    ["Low Cortisol"] = "125822752810863", ["Rampage"] = "120605439830304",
}
local animPresetNames = {
    "Meditate", "Orbit", "Orbit V2", "Orbit V3", "Floss", "OJ", "Kicking Feet", "Tweaking", "Crazy",
    "Crazy V2", "Take the L", "Hype", "Small / Hide", "Sea Lion", "Gangnam", "NLE", "The Man",
    "Spider Shit", "Low Cortisol", "Rampage",
}
animPlayerTab:AddToggle("AnimEnabled", {
    Text = "enabled",
    Default = false,
}):AddKeyPicker("AnimKey", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "anim" })
animPlayerTab:AddToggle("AnimServerVisible", {
    Text = "server side",
    Default = true,
})
animPlayerTab:AddToggle("AnimJitter", { Text = "jitter mode", Default = false })
animPlayerTab:AddSlider("JitterSpeed", { Text = "jitter interval", Default = 0.1, Min = 0.01, Max = 2, Rounding = 2, Suffix = "s" })
animPlayerTab:AddToggle("AnimLoop", { Text = "loop", Default = true })
animPlayerTab:AddToggle("AnimAutoRespawn", { Text = "spawn proof", Default = true })
animPlayerTab:AddInput("AnimForceID", { Default = "96579993895076", Text = "primary anim id", Placeholder = "numbers", Numeric = false, Finished = true })
animPlayerTab:AddInput("AnimJitterID", { Default = "120819498172771", Text = "jitter anim id", Placeholder = "numbers", Numeric = false, Finished = true })
animPlayerTab:AddSlider("AnimSpeed", { Text = "play speed", Default = 2, Min = 0.1, Max = 200, Rounding = 1 })
animPlayerTab:AddDropdown("AnimPresetSelector", {
    Text = "primary presets",
    Values = animPresetNames,
    Default = "Meditate",
})
animPlayerTab:AddDropdown("AnimJitterSelector", {
    Text = "jitter presets",
    Values = animPresetNames,
    Default = "Crazy",
})
Options.AnimPresetSelector:OnChanged(function()
    local id = animPresets[Options.AnimPresetSelector.Value]
    if id then
        Options.AnimForceID:SetValue(id)
        if Toggles.AnimEnabled.Value then getgenv()._animCmd = "Play" end
    end
end)
Options.AnimJitterSelector:OnChanged(function()
    local id = animPresets[Options.AnimJitterSelector.Value]
    if id then
        Options.AnimJitterID:SetValue(id)
        if Toggles.AnimEnabled.Value and Toggles.AnimJitter.Value then getgenv()._animCmd = "Play" end
    end
end)
animPlayerTab:AddButton("play", function()
    getgenv()._animCmd = "Play"
end)
animPlayerTab:AddButton("stop", function()
    getgenv()._animCmd = "Stop"
end);
(function()
    local animLanes = {}
    local currentAnimIds = { primary = "", jitter = "", jitterOn = false, serverVisible = false }
    local lastJitterSwitch = 0
    local currentJitterIndex = 1
    local serverRigCache = {}
    local serverRigCacheAt = 0
    local function normalizeAnimId(raw)
        local txt = tostring(raw or ""):gsub("rbxassetid://", "")
        local numeric = txt:match("%d+")
        return numeric or ""
    end
    local function stripAnimateOnRig(rig)
        if not rig then return end
        pcall(function()
            local animate = rig:FindFirstChild("Animate")
            if animate then
                animate.Disabled = true
                animate:Destroy()
            end
        end)
    end
    local function getFighterEntity()
        local ok, fc = pcall(function()
            return require(p.PlayerScripts.Controllers.FighterController)
        end)
        if ok and fc and fc.LocalFighter and fc.LocalFighter.Entity then
            return fc.LocalFighter.Entity
        end
        return nil
    end
    local function isRigInstance(obj)
        return typeof(obj) == "Instance" and obj:IsA("Model")
    end
    local function getServerRigs()
        local now = tick()
        if now - serverRigCacheAt < 0.35 and #serverRigCache > 0 then
            return serverRigCache
        end
        serverRigCacheAt = now
        serverRigCache = {}
        local live = workspace:FindFirstChild("Live")
        local liveFolder = live and live:FindFirstChild(p.Name)
        if liveFolder and typeof(liveFolder) == "Instance" then
            local added = {}
            local function tryAdd(rig)
                if isRigInstance(rig) and rig.Parent and not added[rig] then
                    added[rig] = true
                    table.insert(serverRigCache, rig)
                end
            end
            if isRigInstance(liveFolder) then
                tryAdd(liveFolder)
            end
            pcall(function()
                for _, child in liveFolder:GetChildren() do
                    if isRigInstance(child) and (child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("RootPart")) then
                        tryAdd(child)
                    end
                end
            end)
            if #serverRigCache == 0 and isRigInstance(liveFolder) then
                tryAdd(liveFolder)
            end
        end
        local entity = getFighterEntity()
        if isRigInstance(entity) then
            local dup = false
            for _, r in serverRigCache do
                if r == entity then dup = true break end
            end
            if not dup then
                table.insert(serverRigCache, entity)
            end
        end
        return serverRigCache
    end
    local function deepDiveGetAnimObject(bundleId)
        bundleId = normalizeAnimId(bundleId)
        if bundleId == "" then return nil end
        local success, objects = pcall(function()
            return game:GetObjects("rbxassetid://" .. bundleId)
        end)
        if not success or not objects or #objects == 0 then
            return nil
        end
        local animObj = nil
        for _, topObject in pairs(objects) do
            if typeof(topObject) == "Instance" and topObject:IsA("Animation") then
                animObj = topObject
            elseif typeof(topObject) == "Instance" then
                for _, descendant in pairs(topObject:GetDescendants()) do
                    if descendant:IsA("Animation") and descendant.AnimationId ~= "" then
                        animObj = descendant
                        break
                    end
                end
            end
            if animObj then break end
        end
        if animObj then
            return animObj
        end
        local fallback = Instance.new("Animation")
        fallback.AnimationId = "rbxassetid://" .. bundleId
        return fallback
    end
    local function getAnimatorForRig(rig, waitTime)
        if not rig or not rig.Parent then return nil, nil end
        local hum = rig:FindFirstChildOfClass("Humanoid")
        if not hum then
            hum = rig:FindFirstChildWhichIsA("Humanoid", true)
        end
        if not hum then
            local ok, found = pcall(function()
                return rig:WaitForChild("Humanoid", waitTime or 8)
            end)
            hum = ok and found or nil
        end
        if not hum then return nil, nil end
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            local ok, found = pcall(function()
                return hum:WaitForChild("Animator", waitTime or 8)
            end)
            animator = ok and found or nil
        end
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = hum
        end
        return animator, hum
    end
    local function deepDivePlayTrack(animator, animObj, priority, speed, looped)
        if not animator or not animObj then return nil end
        local ok, track = pcall(function()
            return animator:LoadAnimation(animObj)
        end)
        if not ok or not track then return nil end
        track.Priority = priority or Enum.AnimationPriority.Action4
        track.Looped = looped
        track:Play(0.1, 1, speed)
        return track
    end
    local function clearAnims()
        for _, lane in ipairs(animLanes) do
            for _, track in pairs(lane.tracks) do
                pcall(function()
                    track:Stop(0)
                    track:Destroy()
                end)
            end
            if lane.hum then
                pcall(function()
                    for _, track in ipairs(lane.hum:GetPlayingAnimationTracks()) do
                        track:Stop(0)
                    end
                end)
            end
        end
        animLanes = {}
    end
    local function buildLane(rig, animPrimary, animJitter, doJitter, speed, looped)
        if not rig or not rig.Parent or not animPrimary then return nil end
        stripAnimateOnRig(rig)
        local animator, hum = getAnimatorForRig(rig, 8)
        if not animator or not hum then return nil end
        local tracks = {}
        tracks[1] = deepDivePlayTrack(animator, animPrimary, Enum.AnimationPriority.Action4, speed, looped)
        if not tracks[1] then return nil end
        if doJitter and animJitter then
            tracks[2] = deepDivePlayTrack(animator, animJitter, Enum.AnimationPriority.Action3, speed, looped)
            if tracks[2] then
                pcall(function() tracks[2]:AdjustWeight(0) end)
            end
        end
        return { rig = rig, hum = hum, animator = animator, tracks = tracks }
    end
    local function startDeepDive(primaryId, jitterId, doJitter, serverVisible, speed, looped)
    	if not Toggles.AnimEnabled or not Toggles.AnimEnabled.Value then
    	    return false
    	end
    clearAnims()
        local animPrimary = deepDiveGetAnimObject(primaryId)
        if not animPrimary then
            Library:Notify("animation bypass failed (bad bundle id?)", 3)
            return false
        end
        local animJitter = nil
        if doJitter and jitterId ~= "" and jitterId ~= primaryId then
            animJitter = deepDiveGetAnimObject(jitterId)
        end
        local char = p.Character or p.CharacterAdded:Wait()
        stripAnimateOnRig(char)
        local clientLane = buildLane(char, animPrimary, animJitter, doJitter, speed, looped)
        if clientLane then
            table.insert(animLanes, clientLane)
        end
        if serverVisible then
            for _, rig in getServerRigs() do
                local lane = buildLane(rig, animPrimary, animJitter, doJitter, speed, looped)
                if lane then
                    table.insert(animLanes, lane)
                end
            end
        end
        return #animLanes > 0
    end
    local function ironLockLane(lane, speed, activePrimary, activeJitter)
        if not lane or not lane.animator then return end
        local tracks = lane.tracks
        local ours = {}
        if tracks[1] then ours[tracks[1]] = true end
        if tracks[2] then ours[tracks[2]] = true end
        pcall(function()
            for _, t in pairs(lane.animator:GetPlayingAnimationTracks()) do
                if not ours[t] then
                    t:Stop(0)
                end
            end
        end)
        if tracks[1] then
            pcall(function()
                if activePrimary then
                    if not tracks[1].IsPlaying then
                        tracks[1]:Play(0, 1, speed)
                    end
                    tracks[1]:AdjustSpeed(speed)
                    tracks[1]:AdjustWeight(1)
                else
                    tracks[1]:AdjustWeight(0)
                end
            end)
        end
        if tracks[2] then
            pcall(function()
                if activeJitter then
                    if not tracks[2].IsPlaying then
                        tracks[2]:Play(0, 1, speed)
                    end
                    tracks[2]:AdjustSpeed(speed)
                    tracks[2]:AdjustWeight(1)
                else
                    tracks[2]:AdjustWeight(0)
                end
            end)
        end
    end
    runService.Heartbeat:Connect(function()
    	if Library.Unloaded then return end
    	local mainEnabled = Toggles.AnimEnabled and Toggles.AnimEnabled.Value
    	if not mainEnabled then
    		if #animLanes > 0 then clearAnims() end
    		return
    	end
        local primaryId = normalizeAnimId(Options.AnimForceID and Options.AnimForceID.Value)
        local jitterId = normalizeAnimId(Options.AnimJitterID and Options.AnimJitterID.Value)
        local doJitter = Toggles.AnimJitter and Toggles.AnimJitter.Value
        local serverVisible = Toggles.AnimServerVisible and Toggles.AnimServerVisible.Value
        local playSpeed = Options.AnimSpeed and Options.AnimSpeed.Value or 2
        local looped = Toggles.AnimLoop and Toggles.AnimLoop.Value
        if getgenv()._animCmd == "Stop" then
            getgenv()._animCmd = nil
            clearAnims()
            currentAnimIds.primary = ""
            currentAnimIds.jitter = ""
            currentAnimIds.jitterOn = false
            currentAnimIds.serverVisible = false
            return
        end
        if primaryId == "" then return end
        local needsInit = getgenv()._animCmd == "Play"
            or #animLanes == 0
            or (animLanes[1] and animLanes[1].tracks[1] and not animLanes[1].tracks[1].IsPlaying)
        local idsChanged = primaryId ~= currentAnimIds.primary
            or jitterId ~= currentAnimIds.jitter
            or doJitter ~= currentAnimIds.jitterOn
            or serverVisible ~= currentAnimIds.serverVisible
        if needsInit or idsChanged then
            getgenv()._animCmd = nil
            currentAnimIds.primary = primaryId
            currentAnimIds.jitter = jitterId
            currentAnimIds.jitterOn = doJitter
            currentAnimIds.serverVisible = serverVisible
            currentJitterIndex = 1
            lastJitterSwitch = tick()
            if not startDeepDive(primaryId, jitterId, doJitter, serverVisible, playSpeed, looped) then
                return
            end
        end
        local activePrimary = true
        local activeJitter = false
        if doJitter and animLanes[1] and animLanes[1].tracks[1] then
            local jitterInterval = Options.JitterSpeed and Options.JitterSpeed.Value or 0.1
            if tick() - lastJitterSwitch >= jitterInterval then
                lastJitterSwitch = tick()
                if animLanes[1].tracks[2] then
                    currentJitterIndex = currentJitterIndex == 1 and 2 or 1
                else
                    for _, lane in ipairs(animLanes) do
                        local t = lane.tracks[1]
                        if t then
                            pcall(function()
                                t:Stop(0)
                                t:Play(0, 1, playSpeed)
                            end)
                        end
                    end
                end
            end
            if animLanes[1].tracks[2] then
                activePrimary = currentJitterIndex == 1
                activeJitter = currentJitterIndex == 2
            end
        end
        for _, lane in ipairs(animLanes) do
            if lane.rig and lane.rig.Parent then
                ironLockLane(lane, playSpeed, activePrimary, activeJitter)
            end
        end
    end)
    p.CharacterAdded:Connect(function()
	    serverRigCache = {}
	    serverRigCacheAt = 0
	    task.wait(1.5)
	    local autoRespawn = Toggles.AnimAutoRespawn and Toggles.AnimAutoRespawn.Value
	    local mainEnabled = Toggles.AnimEnabled and Toggles.AnimEnabled.Value
	    if autoRespawn and mainEnabled then
	        getgenv()._animCmd = "Play"
	    end
	end)
end)();
(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
_G.Features.WorldTextures = _G.Features.WorldTextures or {
    Enabled = false,
    Selected = { all = true },
    Color = Color3.fromRGB(160, 160, 165),
    Dark = false,
}
_G.Features.SmoothTextures = _G.Features.SmoothTextures or {
    Enabled = false,
}
_G.Features.TransparentTextures = _G.Features.TransparentTextures or {
    Enabled = false,
    Transparency = 0.6,
}
do
    local oldBlur = Lighting:FindFirstChild("InstanceTextureBlur")
    if oldBlur then
        oldBlur:Destroy()
    end
end
local WORLD_TEXTURE_TYPES = {
    "all", "grass", "sand", "rock", "metal", "wood", "concrete", "brick",
    "glass", "plastic", "fabric", "ice", "ground", "other",
}
local WORLD_TEXTURE_MATS = {
    grass = { Enum.Material.Grass },
    sand = { Enum.Material.Sand },
    ground = { Enum.Material.Ground, Enum.Material.Mud, Enum.Material.LeafyGrass },
    rock = {
        Enum.Material.Rock, Enum.Material.Slate, Enum.Material.Basalt,
        Enum.Material.Pebble, Enum.Material.Limestone, Enum.Material.Salt,
        Enum.Material.CrackedLava, Enum.Material.Glacier, Enum.Material.Snow,
        Enum.Material.Marble, Enum.Material.Granite,
    },
    metal = { Enum.Material.Metal, Enum.Material.DiamondPlate, Enum.Material.CorrodedMetal, Enum.Material.Foil },
    wood = { Enum.Material.Wood, Enum.Material.WoodPlanks },
    concrete = { Enum.Material.Concrete, Enum.Material.Cobblestone },
    brick = { Enum.Material.Brick },
    glass = { Enum.Material.Glass },
    plastic = { Enum.Material.Plastic, Enum.Material.SmoothPlastic },
    fabric = { Enum.Material.Fabric },
    ice = { Enum.Material.Ice },
}
local MATERIAL_TO_WORLD_CAT = {}
for cat, mats in pairs(WORLD_TEXTURE_MATS) do
    for _, mat in ipairs(mats) do
        MATERIAL_TO_WORLD_CAT[mat] = cat
    end
end
local smoothTexOrig = {}
local smoothTexActive = {}
local smoothTexPending = {}
local smoothTexLoopConn = nil
local smoothTexAddConn = nil
local smoothTexScanRunning = false
local SMOOTH_TEX_BATCH = 128
local smoothTexSaStore = Instance.new("Folder")
smoothTexSaStore.Name = "\0SmoothTexSA"
smoothTexSaStore.Parent = game.CoreGui
local TARGET_TEXTURE_ASSET_ID = "7658055825"
local function textureAssetMatches(value)
    if not value then return false end
    local ok, str = pcall(function() return tostring(value) end)
    if not ok or not str then return false end
    return str:find(TARGET_TEXTURE_ASSET_ID, 1, true) ~= nil
end
local function instanceHasTargetTexture(inst)
    if not inst then return false end
    local ok, result = pcall(function()
        if inst:IsA("Texture") then
            return textureAssetMatches(inst.Texture) or textureAssetMatches(inst.ColorMap) or textureAssetMatches(inst.ColorMapContent)
        elseif inst:IsA("Decal") then
            return textureAssetMatches(inst.Texture) or textureAssetMatches(inst.ColorMap) or textureAssetMatches(inst.ColorMapContent)
        elseif inst:IsA("SurfaceAppearance") then
            return textureAssetMatches(inst.ColorMap) or textureAssetMatches(inst.Albedo) or textureAssetMatches(inst.ColorMapContent)
        end
        return false
    end)
    return ok and result
end
local targetTextureOrig = {}
local targetTextureConn = nil
local function getInstProperty(inst, prop)
    local ok, value = pcall(function() return inst[prop] end)
    return ok and value or nil
end
local function setInstProperty(inst, prop, value)
    pcall(function() inst[prop] = value end)
end
local function matchAssetValue(value)
    if not value then return false end
    return tostring(value):find(TARGET_TEXTURE_ASSET_ID, 1, true) ~= nil
end
local function instanceHasTargetTexture(inst)
    if not inst then return false end
    if inst:IsA("Texture") then
        for _, prop in ipairs({"Texture", "ColorMap", "ColorMapContent"}) do
            if matchAssetValue(getInstProperty(inst, prop)) then return true end
        end
    elseif inst:IsA("Decal") then
        for _, prop in ipairs({"Texture", "TextureId", "TextureContent", "ColorMap", "ColorMapContent"}) do
            if matchAssetValue(getInstProperty(inst, prop)) then return true end
        end
    elseif inst:IsA("SurfaceAppearance") then
        for _, prop in ipairs({"ColorMap", "Albedo", "ColorMapContent", "NormalMap", "MetalnessMap", "RoughnessMap"}) do
            if matchAssetValue(getInstProperty(inst, prop)) then return true end
        end
    end
    return false
end
local function recordTargetTexture(inst)
    if not inst or targetTextureOrig[inst] or not instanceHasTargetTexture(inst) then return end
    targetTextureOrig[inst] = {
        Texture = getInstProperty(inst, "Texture"),
        TextureId = getInstProperty(inst, "TextureId"),
        TextureContent = getInstProperty(inst, "TextureContent"),
        ColorMap = getInstProperty(inst, "ColorMap"),
        ColorMapContent = getInstProperty(inst, "ColorMapContent"),
        Albedo = getInstProperty(inst, "Albedo"),
        NormalMap = getInstProperty(inst, "NormalMap"),
        MetalnessMap = getInstProperty(inst, "MetalnessMap"),
        RoughnessMap = getInstProperty(inst, "RoughnessMap"),
        Transparency = getInstProperty(inst, "Transparency"),
    }
end
local function restoreTargetTexture(inst)
    local orig = targetTextureOrig[inst]
    if not orig then return end
    if inst:IsA("Texture") or inst:IsA("Decal") or inst:IsA("SurfaceAppearance") then
        if orig.Texture ~= nil then setInstProperty(inst, "Texture", orig.Texture) end
        if orig.TextureId ~= nil then setInstProperty(inst, "TextureId", orig.TextureId) end
        if orig.TextureContent ~= nil then setInstProperty(inst, "TextureContent", orig.TextureContent) end
        if orig.ColorMap ~= nil then setInstProperty(inst, "ColorMap", orig.ColorMap) end
        if orig.ColorMapContent ~= nil then setInstProperty(inst, "ColorMapContent", orig.ColorMapContent) end
        if orig.Albedo ~= nil then setInstProperty(inst, "Albedo", orig.Albedo) end
        if orig.NormalMap ~= nil then setInstProperty(inst, "NormalMap", orig.NormalMap) end
        if orig.MetalnessMap ~= nil then setInstProperty(inst, "MetalnessMap", orig.MetalnessMap) end
        if orig.RoughnessMap ~= nil then setInstProperty(inst, "RoughnessMap", orig.RoughnessMap) end
        if orig.Transparency ~= nil then setInstProperty(inst, "Transparency", orig.Transparency) end
    end
    targetTextureOrig[inst] = nil
end
local function restoreAllTargetTextures()
    for inst in pairs(targetTextureOrig) do
        restoreTargetTexture(inst)
    end
    table.clear(targetTextureOrig)
end
local function degradeTextureInstance(inst)
    if not inst or not instanceHasTargetTexture(inst) then return end
    recordTargetTexture(inst)
    if inst:IsA("Texture") then
        setInstProperty(inst, "Transparency", 1)
        if matchAssetValue(getInstProperty(inst, "Texture")) then setInstProperty(inst, "Texture", "") end
        if matchAssetValue(getInstProperty(inst, "ColorMap")) then setInstProperty(inst, "ColorMap", "") end
        if matchAssetValue(getInstProperty(inst, "ColorMapContent")) then setInstProperty(inst, "ColorMapContent", "") end
    elseif inst:IsA("Decal") then
        setInstProperty(inst, "Transparency", 1)
        if matchAssetValue(getInstProperty(inst, "Texture")) then setInstProperty(inst, "Texture", "") end
        if matchAssetValue(getInstProperty(inst, "TextureId")) then setInstProperty(inst, "TextureId", "") end
        if matchAssetValue(getInstProperty(inst, "TextureContent")) then setInstProperty(inst, "TextureContent", "") end
    elseif inst:IsA("SurfaceAppearance") then
        if matchAssetValue(getInstProperty(inst, "ColorMap")) then setInstProperty(inst, "ColorMap", "") end
        if matchAssetValue(getInstProperty(inst, "Albedo")) then setInstProperty(inst, "Albedo", "") end
        if matchAssetValue(getInstProperty(inst, "ColorMapContent")) then setInstProperty(inst, "ColorMapContent", "") end
        if matchAssetValue(getInstProperty(inst, "NormalMap")) then setInstProperty(inst, "NormalMap", "") end
        if matchAssetValue(getInstProperty(inst, "MetalnessMap")) then setInstProperty(inst, "MetalnessMap", "") end
        if matchAssetValue(getInstProperty(inst, "RoughnessMap")) then setInstProperty(inst, "RoughnessMap", "") end
    end
end
local function processTargetTextureInstance(inst)
    if not inst then return end
    if instanceHasTargetTexture(inst) then degradeTextureInstance(inst) end
    for _, child in ipairs(inst:GetDescendants()) do
        if instanceHasTargetTexture(child) then degradeTextureInstance(child) end
    end
end
local function scanTargetTextures()
    for _, inst in ipairs(game:GetDescendants()) do
        if instanceHasTargetTexture(inst) then degradeTextureInstance(inst) end
    end
end
local function startTargetTextureFilter()
    scanTargetTextures()
    if targetTextureConn then targetTextureConn:Disconnect() end
    targetTextureConn = game.DescendantAdded:Connect(function(inst)
        task.wait(0.1)
        processTargetTextureInstance(inst)
    end)
end
local function stopTargetTextureFilter()
    if targetTextureConn then
        targetTextureConn:Disconnect()
        targetTextureConn = nil
    end
    restoreAllTargetTextures()
end
local function updSmoothTextures()
    if _G.Features.SmoothTextures.Enabled then
        startTargetTextureFilter()
    else
        stopTargetTextureFilter()
    end
end
local function darkenColor(color)
    if not color then return Color3.new(0.2, 0.2, 0.2) end
    return Color3.new(color.R * 0.45, color.G * 0.45, color.B * 0.45)
end
local darkTexOrig = {}
local darkTexConn = nil
local function applyDarkTexturesToInst(inst)
    if not inst or not inst:IsA("BasePart") then return end
    if darkTexOrig[inst] ~= nil then return end
    darkTexOrig[inst] = inst.Color
    pcall(function() inst.Color = darkenColor(inst.Color) end)
end
local function applyDarkTextures()
    for _, inst in ipairs(workspace:GetDescendants()) do
        applyDarkTexturesToInst(inst)
    end
    if darkTexConn then darkTexConn:Disconnect() end
    darkTexConn = workspace.DescendantAdded:Connect(function(inst)
        task.defer(function()
            if _G.Features.WorldTextures.Dark then
                applyDarkTexturesToInst(inst)
            end
        end)
    end)
end
local function restoreDarkTextures()
    if darkTexConn then
        darkTexConn:Disconnect()
        darkTexConn = nil
    end
    for inst, oldColor in pairs(darkTexOrig) do
        if inst and inst.Parent then
            pcall(function() inst.Color = oldColor end)
        end
    end
    table.clear(darkTexOrig)
end
local function updDarkTextures()
    if _G.Features.WorldTextures.Dark then
        applyDarkTextures()
    else
        restoreDarkTextures()
    end
end
local transparentTexOrig = {}
local transparentConn = nil
local function isWorldPart(inst)
    if not inst or not inst:IsA("BasePart") then return false end
    if inst.Transparency >= 0.95 then return false end
    local model = inst:FindFirstAncestorWhichIsA("Model")
    if model then
        if Players:GetPlayerFromCharacter(model) then return false end
        if model:FindFirstChildOfClass("Humanoid") then return false end
        if model.Name:find("Weapon") or model.Name:find("Projectile") or model.Name:find("Effect") then return false end
    end
    if inst.Parent and (inst.Parent.Name == "ViewModels" or inst.Parent.Name == "Effects") then return false end
    if inst:FindFirstAncestor("Camera") then return false end
    return true
end
local function applyTransparentToInst(inst)
    if not isWorldPart(inst) then return end
    if transparentTexOrig[inst] then return end
    transparentTexOrig[inst] = inst.Transparency
    local targetTrans = math.clamp(_G.Features.TransparentTextures.Transparency, 0.05, 0.95)
    pcall(function()
        inst.Transparency = targetTrans
    end)
end
local function refreshAllTransparent()
    for inst, _ in pairs(transparentTexOrig) do
        if inst and inst.Parent then
            local targetTrans = math.clamp(_G.Features.TransparentTextures.Transparency, 0.05, 0.95)
            pcall(function() inst.Transparency = targetTrans end)
        end
    end
end
local function applyTransparentTextures()
    for _, inst in ipairs(workspace:GetDescendants()) do
        applyTransparentToInst(inst)
    end
    if transparentConn then transparentConn:Disconnect() end
    transparentConn = workspace.DescendantAdded:Connect(function(inst)
        task.defer(function()
            if _G.Features.TransparentTextures.Enabled then
                applyTransparentToInst(inst)
            end
        end)
    end)
end
local function restoreTransparentTextures()
    if transparentConn then
        transparentConn:Disconnect()
        transparentConn = nil
    end
    for inst, oldTrans in pairs(transparentTexOrig) do
        if inst and inst.Parent then
            pcall(function() inst.Transparency = oldTrans end)
        end
    end
    table.clear(transparentTexOrig)
end
local function updTransparentTextures()
    if _G.Features.TransparentTextures.Enabled then
        applyTransparentTextures()
    else
        restoreTransparentTextures()
    end
end
getgenv().InstanceUpdSmoothTextures = updSmoothTextures
getgenv().InstanceUpdDarkTextures = updDarkTextures
getgenv().InstanceUpdTransparentTextures = updTransparentTextures
local texturesBox = Tabs.Misc:AddLeftGroupbox('textures')
texturesBox:AddToggle('smooth_textures', {
    Text = 'smooth textures',
    Default = _G.Features.SmoothTextures.Enabled,
    Tooltip = 'makes map textures smooth (smooth plastic, hides surface detail)',
    Callback = function(val)
        _G.Features.SmoothTextures.Enabled = val
        local fn = getgenv().InstanceUpdSmoothTextures
        if fn then fn() end
    end
})
texturesBox:AddToggle('dark_textures', {
    Text = 'dark textures',
    Default = _G.Features.WorldTextures.Dark,
    Tooltip = 'darkens world parts for a deeper, darker texture look',
    Callback = function(val)
        _G.Features.WorldTextures.Dark = val
        local fn = getgenv().InstanceUpdDarkTextures
        if fn then fn() end
    end
})
local transparentToggle = texturesBox:AddToggle('transparent_textures', {
    Text = 'transparent textures',
    Default = _G.Features.TransparentTextures.Enabled,
    Tooltip = 'makes world textures semi-transparent',
    Callback = function(val)
        _G.Features.TransparentTextures.Enabled = val
        local fn = getgenv().InstanceUpdTransparentTextures
        if fn then fn() end
    end
})
texturesBox:AddSlider("TransparentStrength", {
    Text = "Transparency",
    Default = _G.Features.TransparentTextures.Transparency,
    Min = 0.5,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(val)
        _G.Features.TransparentTextures.Transparency = val
        if _G.Features.TransparentTextures.Enabled then
            refreshAllTransparent()
        end
    end
})
if _G.Features.SmoothTextures.Enabled then
    updSmoothTextures()
end
if _G.Features.WorldTextures.Dark then
    updDarkTextures()
end
if _G.Features.TransparentTextures.Enabled then
    updTransparentTextures()
end
end)()
;(function()
ThemeManager:SetLibrary(Library)
local themeManagerThemeUpdate = ThemeManager.ThemeUpdate
function ThemeManager:ThemeUpdate()
    themeManagerThemeUpdate(self)
    if getgenv().InstanceApplyAccentTheme then
        pcall(getgenv().InstanceApplyAccentTheme)
    end
    if applyTargetHudTheme then
        applyTargetHudTheme()
    end
    if getgenv().InstanceApplyCosmeticUiTheme then
        pcall(getgenv().InstanceApplyCosmeticUiTheme)
    end
    if getgenv().InstanceKeybindList and getgenv().InstanceKeybindList.inner then
        if getgenv().InstanceApplyKbListTheme then
            pcall(getgenv().InstanceApplyKbListTheme)
        end
    end
end
getgenv().InstanceConfigLoading = true
applyInstanceAccentTheme()
task.defer(function()
    task.wait(0.35)
    pcall(applyInstanceAccentTheme)
    pcall(function()
        local opt = Options and Options.tgbtgbbktbkmb
        if opt and setfpscap then
            local v = tonumber(opt.Value) or 0
            if v <= 0 or v >= 9999 then
                setfpscap(0)
            else
                setfpscap(math.floor(v))
            end
        end
    end)
    task.wait(1.25)
    pcall(applyInstanceAccentTheme)
    getgenv().InstanceConfigLoading = false
end)
end)()
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind 
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("BazaHub")
SaveManager:SetFolder("BazaHub/Rivals")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
