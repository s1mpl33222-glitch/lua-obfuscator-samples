-- ============================================================
-- MORTY CHEAT v7.5 — fixed ESP offset + detailed tooltips
-- Insert = menu | Home = unload
-- ============================================================

local Players2 = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players2.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local BRAND = "MORTY"
local CurrentLang = "ru"

-- ============================================================
-- ЛОКАЛИЗАЦИЯ
-- ============================================================
local L = {
    ru = { tab_aim="Аим", tab_wallhack="ВХ", tab_world="Мир", tab_misc="Разное", tab_customize="Тема",
        grp_aimbot="АИМБОТ", grp_target="ЦЕЛИ",
        grp_players="ИГРОКИ", grp_skeleton="СКЕЛЕТ", grp_drones="ДРОНЫ", grp_radar="РАДАР",
        grp_camera="КАМЕРА", grp_speed="СКОРОСТЬ", grp_freecam="ФРИКАМ", grp_ui="ИНТЕРФЕЙС",
        grp_colors="ЦВЕТА", grp_config="КОНФИГИ", grp_colors_player="ЦВЕТА ИГРОКОВ",
        grp_colors_other="ЦВЕТА ИНТЕРФЕЙСА", grp_binds="БИНДЫ",
        cfg_name="Имя конфига", cfg_save="Сохранить", cfg_load="Загрузить",
        picks="Выбрать",
        no_binds="ПКМ по пункту меню чтобы добавить бинд.",
        lang="ЯЗЫК",
        bind_title="БИНД: ", bind_hint="Нажмите клавишу...",
        bind_key="Клавиша: ", bind_mode="Режим:",
        bind_toggle="Переключ.", bind_hold="Удержание",
        bind_save="Сохранить", bind_cancel="Отмена", bind_clear="Сброс" },
    en = { tab_aim="Aim", tab_wallhack="Wallhack", tab_world="World", tab_misc="Misc", tab_customize="Theme",
        grp_aimbot="AIMBOT", grp_target="TARGETING",
        grp_players="PLAYERS", grp_skeleton="SKELETON", grp_drones="DRONES", grp_radar="RADAR",
        grp_camera="CAMERA", grp_speed="SPEED", grp_freecam="FREECAM", grp_ui="UI",
        grp_colors="COLORS", grp_config="CONFIGS", grp_colors_player="PLAYER COLORS",
        grp_colors_other="UI COLORS", grp_binds="BINDS",
        cfg_name="Config name", cfg_save="Save", cfg_load="Load",
        picks="Pick",
        no_binds="Right-click menu item to add bind.",
        lang="LANG",
        bind_title="BIND: ", bind_hint="Press any key...",
        bind_key="Key: ", bind_mode="Mode:",
        bind_toggle="Toggle", bind_hold="Hold",
        bind_save="Save", bind_cancel="Cancel", bind_clear="Clear" }
}
local function t(k) return (L[CurrentLang] and L[CurrentLang][k]) or k end

local ITEM_NAME = {
    AIM_Enabled={en="Enable",ru="Включить"},
    AIM_WallCheck={en="Visible Check",ru="Видимость"},
    AIM_ShowFOV={en="Show FOV",ru="Круг FOV"},
    AIM_DynamicSmooth={en="Dynamic Smooth",ru="Дин. сглаж."},
    AIM_AimKey={en="Aim Key",ru="Кнопка аима"}, AIM_FOV={en="FOV",ru="FOV"},
    AIM_Smooth={en="Smooth",ru="Сглаживание"}, AIM_TeamCheck={en="Team Check",ru="Проверка команды"},
    AIM_TargetBone={en="Bone",ru="Кость"},
    ESP_Enabled={en="Enable ESP",ru="Включить ESP"}, ESP_Boxes={en="Boxes",ru="Боксы"},
    ESP_Names={en="Names",ru="Ники"}, ESP_Distance={en="Distance",ru="Дистанция"},
    ESP_Health={en="Health Bar",ru="Полоса HP"}, ESP_Skeleton={en="Skeleton",ru="Скелет"},
    ESP_TeamCheck={en="Team Check",ru="Проверка команды"},
    ESP_MaxDist={en="Max Distance",ru="Макс. дистанция"},
    ESP_Drones={en="Drone ESP",ru="ESP дроны"},
    ESP_DronesTeamCheck={en="Drone Team Check",ru="Проверка команды дронов"},
    SPEED_Enabled={en="Speed Hack",ru="Ускорение"},
    SPEED_Value={en="Speed",ru="Скорость"},
    JUMP_Enabled={en="Jump Power",ru="Прыжок"},
    JUMP_Value={en="Jump",ru="Сила прыжка"},
    RADAR_Enabled={en="Radar",ru="Радар"},
    RADAR_Size={en="Radar Size",ru="Размер радара"},
    FREECAM_Enabled={en="Freecam",ru="Freecam"},
    FREECAM_Speed={en="Speed",ru="Скорость"},
    FREECAM_Sensitivity={en="Sensitivity",ru="Чувствительность"},
    UI_Watermark={en="Watermark",ru="Watermark"},
    C_Enemy={en="Enemy",ru="Враг"}, C_Team={en="Teammate",ru="Тиммейт"},
    C_DroneEnemy={en="Drone (enemy)",ru="Дрон (враг)"},
    C_DroneTeam={en="Drone (team)",ru="Дрон (тиммейт)"},
    C_Box={en="Box",ru="Бокс"}, C_Name={en="Name",ru="Ник"},
    C_Distance={en="Distance",ru="Дистанция"}, C_Skeleton={en="Skeleton",ru="Скелет"},
    C_HealthBg={en="HP bg",ru="HP фон"}, C_HealthHigh={en="HP high",ru="HP высокое"},
    C_HealthMid={en="HP mid",ru="HP среднее"}, C_HealthLow={en="HP low",ru="HP низкое"},
    C_RadarBg={en="Radar bg",ru="Радар фон"}, C_RadarBorder={en="Radar border",ru="Радар рамка"},
    C_RadarYou={en="Radar you",ru="Радар ты"}, C_RadarEnemy={en="Radar enemy",ru="Радар враг"},
    C_FOVCircle={en="FOV circle",ru="Круг FOV"}, C_FOVActive={en="FOV active",ru="FOV активный"},
    C_Accent={en="Accent",ru="Акцент"}
}
local function tItem(key, fallback)
    local n = ITEM_NAME[key]; if not n then return fallback or key end
    return n[CurrentLang] or n.en or fallback or key
end

-- ============================================================
-- ПОДРОБНЫЕ ОПИСАНИЯ
-- ============================================================
local DESC = {
    AIM_Enabled={en="Master switch for the whole aimbot.\nWhen off — nothing else in Aim tab works.",
                 ru="Главный выключатель аимбота.\nЕсли выкл — ничего в табе Аим не работает."},
    AIM_WallCheck={en="Don't aim at enemies behind walls.\nUses raycast — slight CPU cost.",
                   ru="Не целиться во врагов за стеной.\nИспользует raycast — слегка грузит CPU."},
    AIM_ShowFOV={en="Draw a circle showing the aim radius.\nOnly visual — doesn't affect aiming.",
                 ru="Рисует круг радиусом аима.\nТолько визуал — на аим не влияет."},
    AIM_DynamicSmooth={en="Smoothness scales with distance.\nFar target = faster lock, close = smoother.",
                       ru="Плавность зависит от дистанции.\nДалёкая цель = быстрее захват, близкая = плавнее."},
    AIM_AimKey={en="Mouse button that activates aim.\nRMB = right, LMB = left, Always = always on.",
                ru="Кнопка мыши для активации аима.\nRMB = правая, LMB = левая, Always = всегда."},
    AIM_FOV={en="Aim capture radius in pixels.\nOnly targets inside this circle are picked.",
             ru="Радиус захвата в пикселях.\nТолько цели внутри круга берутся."},
    AIM_Smooth={en="How fast aim moves to target.\n1 = instant (rage), 15+ = human-like.",
                ru="Скорость наведения на цель.\n1 = мгновенно (рейдж), 15+ = похоже на человека."},
    AIM_TeamCheck={en="Skip teammates (blue players).\nUses team container from Workspace.",
                   ru="Пропускать союзников (синих).\nИспользует контейнер команды из Workspace."},
    AIM_TargetBone={en="Which part of body to aim at.\nHead = most damage, Torso = safer.",
                    ru="Часть тела для прицела.\nHead = больше урона, Torso = безопаснее."},

    ESP_Enabled={en="Master switch for all ESP elements.\nOff = nothing visible on players.",
                 ru="Главный выключатель всех ESP элементов.\nВыкл = на игроках ничего не видно."},
    ESP_Boxes={en="Rectangle around each player.\nRed = enemy, blue = teammate.",
               ru="Прямоугольник вокруг игрока.\nКрасный = враг, синий = союзник."},
    ESP_Names={en="Show player name above box.\nUses Roblox username.",
               ru="Показывает ник над боксом.\nИспользует имя Roblox."},
    ESP_Distance={en="Distance to player in meters.\nDisplayed below box.",
                  ru="Дистанция до игрока в метрах.\nПоказывается под боксом."},
    ESP_Health={en="Vertical HP bar left of box.\nGreen > 60%, yellow 30-60%, red < 30%.",
                ru="Вертикальная полоса HP слева от бокса.\nЗелёная > 60%, жёлтая 30-60%, красная < 30%."},
    ESP_Skeleton={en="Lines between body parts.\nWorks with R6 and R15 rigs.",
                  ru="Линии между частями тела.\nРаботает и с R6 и с R15."},
    ESP_TeamCheck={en="Hide teammates from ESP.\nThey disappear from screen and radar.",
                   ru="Скрыть союзников из ESP.\nОни исчезают с экрана и радара."},
    ESP_MaxDist={en="Max render distance in studs.\nAbove this — ESP hidden.",
                 ru="Макс. дистанция отрисовки в studs.\nДальше — ESP скрыт."},
    ESP_Drones={en="Highlight FPV drones with purple box.\nWorks through walls.",
                ru="Подсветка FPV-дронов фиолетовым боксом.\nВидно через стены."},
    ESP_DronesTeamCheck={en="Hide teammate drones.\nOnly enemy drones shown.",
                         ru="Скрыть дроны союзников.\nПоказываются только враги."},

    SPEED_Enabled={en="Increase your walk speed.\nSmoothly ramps up — less detectable.",
                   ru="Увеличивает скорость бега.\nПлавный разгон — меньше палева."},
    SPEED_Value={en="Target speed in studs/sec.\nDefault Roblox = 16, sprint = 24.",
                 ru="Целевая скорость studs/сек.\nRoblox по умолч. = 16, спринт = 24."},
    JUMP_Enabled={en="Increase your jump power.\nAlso smooth — no snap.",
                  ru="Увеличивает силу прыжка.\nТоже плавно — без рывка."},
    JUMP_Value={en="Target jump power.\nDefault Roblox = 50, UseJumpPower mode.",
                ru="Целевая сила прыжка.\nRoblox по умолч. = 50."},

    RADAR_Enabled={en="Corner radar with enemies.\nRotates with your camera.",
                   ru="Радар в углу с врагами.\nВращается вместе с камерой."},
    RADAR_Size={en="Radar size in pixels.\nBigger = see further, less precise.",
                ru="Размер радара в пикселях.\nБольше = видно дальше, менее точно."},

    FREECAM_Enabled={en="Detach camera from your body.\nWASD = fly, Space/Q = up/down.",
                     ru="Отцепить камеру от тела.\nWASD = полёт, Space/Q = вверх/вниз."},
    FREECAM_Speed={en="Camera fly speed.\nHold Shift = 3x, Ctrl = 0.25x.",
                   ru="Скорость полёта камеры.\nShift = 3x, Ctrl = 0.25x."},
    FREECAM_Sensitivity={en="Mouse sensitivity for freecam.\nHigher = faster rotation.",
                         ru="Чувствительность мыши в freecam.\nБольше = быстрее поворот."},

    UI_Watermark={en="Info panel top-left.\nShows FPS, targets, role, binds count.",
                  ru="Инфо-панель сверху слева.\nПоказывает FPS, цели, роль, бинды."},

    C_Enemy={en="Color for enemies.\nShown in ESP, radar, skeleton.",
             ru="Цвет врагов.\nПоказывается в ESP, радаре, скелете."},
    C_Team={en="Color for teammates.\nTheir boxes and radar dots.",
            ru="Цвет союзников.\nИх боксы и точки на радаре."},
    C_DroneEnemy={en="Enemy drone box color.\nBright = high visibility.",
                  ru="Цвет бокса дронов врагов.\nЯркий = хорошо видно."},
    C_DroneTeam={en="Teammate drone color.\nUsed when Team Check off.",
                 ru="Цвет дронов союзников.\nВидно только если Team Check выкл."},
    C_Box={en="Box outline color.\nOverrides team/enemy color if you set it manually.",
           ru="Цвет рамки боксов.\nПеребивает цвета команды/врага вручную."},
    C_Name={en="Player name text color.",
            ru="Цвет текста ников."},
    C_Distance={en="Distance text color.",
                ru="Цвет текста дистанции."},
    C_Skeleton={en="Skeleton line color.\nWhite default — visible on any background.",
                ru="Цвет линий скелета.\nБелый по умолч. — видно на любом фоне."},
    C_HealthBg={en="Health bar background.\nDark grey shows missing HP.",
                ru="Фон полосы HP.\nТёмно-серый = недостающее HP."},
    C_HealthHigh={en="HP > 60% color.\nGreen by default.",
                  ru="Цвет HP > 60%.\nЗелёный по умолч."},
    C_HealthMid={en="HP 30-60% color.\nYellow by default.",
                 ru="Цвет HP 30-60%.\nЖёлтый по умолч."},
    C_HealthLow={en="HP < 30% color.\nRed by default.",
                 ru="Цвет HP < 30%.\nКрасный по умолч."},
    C_RadarBg={en="Radar background color.\nDark navy by default.",
               ru="Фон радара.\nТёмно-синий по умолч."},
    C_RadarBorder={en="Radar border line color.\nAccent-colored by default.",
                   ru="Рамка радара.\nАкцентный цвет по умолч."},
    C_RadarYou={en="Your position dot on radar.\nGreen by default.",
                ru="Твоя точка на радаре.\nЗелёная по умолч."},
    C_RadarEnemy={en="Enemy dots on radar.\nRed by default.",
                  ru="Точки врагов на радаре.\nКрасные по умолч."},
    C_FOVCircle={en="FOV circle when not aiming.\nWhite by default.",
                 ru="Круг FOV когда не аимишь.\nБелый по умолч."},
    C_FOVActive={en="FOV circle when aiming.\nAccent-colored by default.",
                 ru="Круг FOV при аиме.\nАкцентный цвет по умолч."},
    C_Accent={en="Main menu accent color.\nAffects headers, sliders, buttons.",
              ru="Главный акцент меню.\nВлияет на заголовки, слайдеры, кнопки."},
}
local function getDesc(key)
    local d = DESC[key]; if not d then return nil end
    return d[CurrentLang] or d.en
end

-- ============================================================
-- ЦВЕТА
-- ============================================================
local DefaultColors = {
    C_Enemy = Color3.fromRGB(255,80,80),
    C_Team = Color3.fromRGB(100,180,255),
    C_DroneEnemy = Color3.fromRGB(255,100,255),
    C_DroneTeam = Color3.fromRGB(180,140,255),
    C_Box = Color3.fromRGB(255,255,255),
    C_Name = Color3.fromRGB(255,255,255),
    C_Distance = Color3.fromRGB(220,220,220),
    C_Skeleton = Color3.fromRGB(240,240,245),
    C_HealthBg = Color3.fromRGB(30,30,34),
    C_HealthHigh = Color3.fromRGB(120,240,120),
    C_HealthMid = Color3.fromRGB(247,224,92),
    C_HealthLow = Color3.fromRGB(255,90,90),
    C_RadarBg = Color3.fromRGB(12,12,14),
    C_RadarBorder = Color3.fromRGB(247,224,92),
    C_RadarYou = Color3.fromRGB(120,240,120),
    C_RadarEnemy = Color3.fromRGB(255,80,80),
    C_FOVCircle = Color3.fromRGB(255,255,255),
    C_FOVActive = Color3.fromRGB(247,224,92),
    C_Accent = Color3.fromRGB(247,224,92),
}
local Colors = {}
for k, v in pairs(DefaultColors) do Colors[k] = v end
local function getColor(k) return Colors[k] or Color3.new(1,1,1) end
local function setColor(k, c) Colors[k] = c end

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    ESP_Enabled=true, ESP_Boxes=true, ESP_Names=true, ESP_Distance=true,
    ESP_Skeleton=true, ESP_Health=true, ESP_TeamCheck=false, ESP_MaxDist=3000,
    ESP_Drones=true, ESP_DronesTeamCheck=false,
    SPEED_Enabled=false, SPEED_Value=16, JUMP_Enabled=false, JUMP_Value=50,
    RADAR_Enabled=true, RADAR_Size=120,
    AIM_Enabled=false, AIM_FOV=300, AIM_Smooth=15, AIM_ShowFOV=true,
    AIM_TeamCheck=false, AIM_WallCheck=false, AIM_TargetBone="Head",
    AIM_AimKey="RMB", AIM_DynamicSmooth=true,
    FREECAM_Enabled=false, FREECAM_Speed=50, FREECAM_Sensitivity=1.0,
    UI_Watermark=true,
    MENU_Open=true, MENU_Tab="Wallhack"
}
local Tuning = {
    RefreshRate=0.08, DroneRefreshRate=0.3,
    NameOffset=18, DistOffset=4,
    RadarRange=400, RadarDotSize=6, HealthBarWidth=4, HealthBarOffset=6,
    SpeedStepPerFrame=2,
}
local Cache = {
    targets={}, humanoids={}, teamStatus={}, names={}, myRoot=nil,
    count=0, drawn=0,
    roleRoot=nil, myRole=nil, playerRoles={},
    drones={}, droneCount=0, droneDrawn=0,
    lastRefresh=0, lastDroneRefresh=0,
}
local AimBones = {"Head","Torso","HumanoidRootPart"}
local AimKeys = {"RMB","LMB","Always"}
local Binds = {}
local HoldActive = {}
local Conn = {}
local Unloaded = false

-- ============================================================
-- CONFIG SYSTEM
-- ============================================================
local ConfigSystem = { Folder="morty_cheat", CurrentName="default" }
local CONFIG_SKIP = { ESP_TeamCheck=true, AIM_TeamCheck=true, MENU_Open=true, MENU_Tab=true }

local function ensureFolder(p)
    if not isfolder or not makefolder then return false end
    pcall(function() if not isfolder(p) then makefolder(p) end end)
    return true
end
local function rgbToHex(c) return string.format("#%02X%02X%02X", math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5)) end
local function hexToColor(hex)
    hex = tostring(hex):gsub("#",""):gsub("%s","")
    if #hex ~= 6 then return nil end
    local r,g,b = tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16)
    if not (r and g and b) then return nil end
    return Color3.fromRGB(r,g,b)
end
function ConfigSystem.GetPath(n) return ConfigSystem.Folder .. "/" .. n .. ".json" end
function ConfigSystem.Save(name)
    if not writefile or not isfolder then return false end
    name = name or ConfigSystem.CurrentName or "default"
    ensureFolder(ConfigSystem.Folder)
    local data = { config = {}, colors = {}, binds = {}, lang = CurrentLang }
    for k,v in pairs(Config) do
        local tp = type(v)
        if tp == "boolean" or tp == "number" or tp == "string" then data.config[k] = v end
    end
    for k,c in pairs(Colors) do data.colors[k] = rgbToHex(c) end
    for k,b in pairs(Binds) do
        if b and b.key then data.binds[k] = { key = b.key.Name, mode = b.mode or "Toggle" } end
    end
    local ok, json = pcall(HttpService.JSONEncode, HttpService, data)
    if not ok then return false end
    if not pcall(writefile, ConfigSystem.GetPath(name), json) then return false end
    ConfigSystem.CurrentName = name
    return true
end
function ConfigSystem.Load(name)
    if not readfile or not isfile then return false end
    name = name or ConfigSystem.CurrentName or "default"
    local path = ConfigSystem.GetPath(name)
    if not isfile(path) then return false end
    local ok, content = pcall(readfile, path)
    if not ok or not content or content == "" then return false end
    local dok, data = pcall(HttpService.JSONDecode, HttpService, content)
    if not dok or type(data) ~= "table" then return false end
    if type(data.config) == "table" then
        for k,v in pairs(data.config) do
            if Config[k] ~= nil and not CONFIG_SKIP[k] and type(v) == type(Config[k]) then Config[k] = v end
        end
    end
    if type(data.colors) == "table" then
        for k,hex in pairs(data.colors) do
            local c = hexToColor(hex); if c then Colors[k] = c end
        end
    end
    Binds = {}
    if type(data.binds) == "table" then
        for k,b in pairs(data.binds) do
            if type(b) == "table" and b.key then
                local kc = Enum.KeyCode[b.key]
                if kc then Binds[k] = { key = kc, mode = b.mode or "Toggle" } end
            end
        end
    end
    if type(data.lang) == "string" and (data.lang == "ru" or data.lang == "en") then
        CurrentLang = data.lang
    end
    ConfigSystem.CurrentName = name
    return true
end

-- ============================================================
-- UI
-- ============================================================
local UI = Instance.new("ScreenGui")
UI.Name = "M_" .. tostring(math.random(100000, 999999))
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 999
UI.IgnoreGuiInset = true
pcall(function() UI.Parent = game:GetService("CoreGui") end)
if not UI.Parent then UI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "E_" .. tostring(math.random(100000, 999999))
ESPGui.ResetOnSpawn = false
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESPGui.DisplayOrder = 998
ESPGui.IgnoreGuiInset = false   -- ИСПРАВЛЕНО: теперь не игнорит топбар
pcall(function() ESPGui.Parent = game:GetService("CoreGui") end)
if not ESPGui.Parent then ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Watermark
local WM = Instance.new("Frame", UI)
WM.BackgroundColor3 = Color3.fromRGB(10,10,12); WM.BackgroundTransparency = 0.15
WM.BorderSizePixel = 0; WM.Position = UDim2.new(0, 10, 0, 10)
WM.Size = UDim2.new(0, 800, 0, 26); WM.ZIndex = 200
Instance.new("UICorner", WM).CornerRadius = UDim.new(0, 5)
local WMStroke = Instance.new("UIStroke", WM)
WMStroke.Color = getColor("C_Accent"); WMStroke.Thickness = 1; WMStroke.Transparency = 0.5
local WMBrand = Instance.new("TextLabel", WM)
WMBrand.BackgroundTransparency = 1; WMBrand.Position = UDim2.new(0, 10, 0, 0)
WMBrand.Size = UDim2.new(0, 80, 1, 0)
WMBrand.Font = Enum.Font.GothamBold; WMBrand.TextSize = 12
WMBrand.TextColor3 = getColor("C_Accent"); WMBrand.Text = BRAND
WMBrand.TextXAlignment = Enum.TextXAlignment.Left
local WmInfo = Instance.new("TextLabel", WM)
WmInfo.BackgroundTransparency = 1; WmInfo.Position = UDim2.new(0, 90, 0, 0)
WmInfo.Size = UDim2.new(1, -100, 1, 0)
WmInfo.Font = Enum.Font.GothamMedium; WmInfo.TextSize = 11
WmInfo.TextColor3 = Color3.fromRGB(200,200,200); WmInfo.TextXAlignment = Enum.TextXAlignment.Left
WmInfo.Text = "loading..."

-- Тултип
local Tooltip = { frame = nil, conn = nil }
local function hideTooltip()
    if Tooltip.frame then pcall(function() Tooltip.frame:Destroy() end); Tooltip.frame = nil end
    if Tooltip.conn then pcall(function() Tooltip.conn:Disconnect() end); Tooltip.conn = nil end
end
local function showTooltip(text)
    hideTooltip()
    local f = Instance.new("Frame", UI)
    f.BackgroundColor3 = Color3.fromRGB(19,19,22)
    f.BackgroundTransparency = 0.05
    f.BorderSizePixel = 0; f.Size = UDim2.new(0, 300, 0, 80)
    f.ZIndex = 2000; f.Active = false
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", f)
    st.Color = getColor("C_Accent"); st.Thickness = 1; st.Transparency = 0.3
    local lbl = Instance.new("TextLabel", f)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 8); lbl.Size = UDim2.new(1, -20, 1, -16)
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(240,240,245)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true; lbl.Text = text; lbl.ZIndex = 2001
    Tooltip.frame = f
    Tooltip.conn = RunService.RenderStepped:Connect(function()
        if not f.Parent then if Tooltip.conn then Tooltip.conn:Disconnect(); Tooltip.conn = nil end; return end
        local mp = UserInputService:GetMouseLocation()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local fw, fh = f.AbsoluteSize.X, f.AbsoluteSize.Y
        local tx = math.clamp(mp.X + 16, 4, math.max(4, vp.X - fw - 4))
        local ty = math.clamp(mp.Y + 16, 4, math.max(4, vp.Y - fh - 4))
        f.Position = UDim2.new(0, tx, 0, ty)
    end)
end

-- ============================================================
-- ROLE SCANNER
-- ============================================================
local function findRoleRoot()
    if Cache.roleRoot and Cache.roleRoot.Parent then return Cache.roleRoot end
    local myChar = LocalPlayer.Character
    if myChar and myChar.Parent and myChar.Parent:IsA("Model") then
        Cache.roleRoot = myChar.Parent.Parent
        Cache.myRole = myChar.Parent
        return Cache.roleRoot
    end
    return nil
end
local function scanRoles()
    local root = findRoleRoot()
    if not root then Cache.playerRoles = {}; return end
    local myChar = LocalPlayer.Character
    local myRole = (myChar and myChar.Parent) or Cache.myRole
    local found = {}
    for _, roleContainer in ipairs(root:GetChildren()) do
        if roleContainer:IsA("Model") then
            for _, model in ipairs(roleContainer:GetChildren()) do
                if model:IsA("Model") then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        found[model.Name] = {
                            char = model, role = roleContainer, hum = hum,
                            isMyTeam = (roleContainer == myRole),
                        }
                    end
                end
            end
        end
    end
    Cache.playerRoles = found
    Cache.myRole = myRole
end

local function isDroneModel(model)
    if not model or not model:IsA("Model") then return false end
    if model:FindFirstChildOfClass("Humanoid") then return false end
    return model:FindFirstChild("Rotators") ~= nil
        or model:FindFirstChild("explosive") ~= nil
        or model:FindFirstChild("Base") ~= nil
end
local function getDronePart(model)
    local r = model:FindFirstChild("Rotators")
    if r then
        local br = r:FindFirstChild("Rotator_BR") or r:FindFirstChild("Rotator_BL")
            or r:FindFirstChild("Rotator_FR") or r:FindFirstChild("Rotator_FL")
        if br then return br end
    end
    local ex = model:FindFirstChild("explosive")
    if ex then
        local e = ex:FindFirstChild("Explosive")
        if e then return e end
    end
    for _, c in ipairs(model:GetDescendants()) do
        if c:IsA("BasePart") then return c end
    end
    return nil
end
local function scanDrones()
    local root = findRoleRoot()
    if not root then Cache.drones = {}; return end
    local myChar = LocalPlayer.Character
    local myRole = (myChar and myChar.Parent) or Cache.myRole
    local drones = {}
    for _, roleContainer in ipairs(root:GetChildren()) do
        if roleContainer:IsA("Model") then
            local isMyTeam = (roleContainer == myRole)
            for _, model in ipairs(roleContainer:GetChildren()) do
                if model:IsA("Model") and isDroneModel(model) then
                    local part = getDronePart(model)
                    if part then
                        drones[model] = { model = model, part = part, isMyTeam = isMyTeam }
                    end
                end
            end
        end
    end
    Cache.drones = drones
    Cache.droneCount = 0
    for _ in pairs(drones) do Cache.droneCount = Cache.droneCount + 1 end
end

-- ============================================================
-- TARGETS
-- ============================================================
local function getRootPart(char)
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("Head")
        or char.PrimaryPart
end
local Targets = {}
function Targets.refresh()
    scanRoles()
    local new, newHum, newTeam = {}, {}, {}
    local myChar = LocalPlayer.Character
    Cache.myRoot = myChar and getRootPart(myChar)
    for _, plr in ipairs(Players2:GetPlayers()) do
        if plr ~= LocalPlayer then
            local entry = Cache.playerRoles[plr.Name]
            if entry then
                local char = entry.char
                local root = getRootPart(char)
                if root and entry.hum and entry.hum.Health > 0 then
                    new[root] = char
                    newHum[root] = entry.hum
                    newTeam[root] = entry.isMyTeam
                end
            end
        end
    end
    Cache.targets = new; Cache.humanoids = newHum; Cache.teamStatus = newTeam
    Cache.count = 0
    for _ in pairs(new) do Cache.count = Cache.count + 1 end
end

local Util = {}
function Util.getName(char)
    local plr = Players2:GetPlayerFromCharacter(char)
    return plr and plr.Name or char.Name
end

-- ============================================================
-- ESP
-- ============================================================
local ESP = { cache = {} }

local function makeLine(color, thickness)
    local f = Instance.new("Frame", ESPGui)
    f.BackgroundColor3 = color or Color3.new(1,1,1); f.BorderSizePixel = 0
    f.AnchorPoint = Vector2.new(0, 0.5)
    f.Size = UDim2.new(0, 0, 0, thickness or 1)
    f.ZIndex = 5; f.Visible = false
    return f
end
local function drawLine(line, x1, y1, x2, y2, color, thickness)
    thickness = thickness or 1
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx*dx + dy*dy)
    if len < 1 then line.Visible = false; return end
    line.Position = UDim2.new(0, x1, 0, y1)
    line.Size = UDim2.new(0, len, 0, thickness)
    line.Rotation = math.deg(math.atan2(dy, dx))
    if color then line.BackgroundColor3 = color end
    line.Visible = true
end
local SKEL_R6 = {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
local SKEL_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local function getSkel(char)
    if char:FindFirstChild("UpperTorso") and char:FindFirstChild("LowerTorso") then return SKEL_R15 end
    return SKEL_R6
end

function ESP.Create(root)
    if ESP.cache[root] then return end
    local box = Instance.new("Frame", ESPGui)
    box.BackgroundTransparency = 1; box.BorderSizePixel = 0; box.Visible = false; box.ZIndex = 3
    local boxStroke = Instance.new("UIStroke", box); boxStroke.Thickness = 2
    local name = Instance.new("TextLabel", ESPGui)
    name.BackgroundTransparency = 1; name.Font = Enum.Font.GothamBold
    name.TextSize = 13; name.TextColor3 = Color3.new(1,1,1)
    name.TextStrokeTransparency = 0; name.TextStrokeColor3 = Color3.new(0,0,0)
    name.Size = UDim2.new(0,220,0,16); name.TextXAlignment = Enum.TextXAlignment.Center
    name.Visible = false; name.ZIndex = 4
    local dist = Instance.new("TextLabel", ESPGui)
    dist.BackgroundTransparency = 1; dist.Font = Enum.Font.GothamMedium
    dist.TextSize = 11; dist.TextColor3 = Color3.fromRGB(220,220,220)
    dist.TextStrokeTransparency = 0; dist.TextStrokeColor3 = Color3.new(0,0,0)
    dist.Size = UDim2.new(0,220,0,14); dist.TextXAlignment = Enum.TextXAlignment.Center
    dist.Visible = false; dist.ZIndex = 4
    local hBg = Instance.new("Frame", ESPGui)
    hBg.BackgroundColor3 = getColor("C_HealthBg"); hBg.BorderSizePixel = 0; hBg.Visible = false; hBg.ZIndex = 3
    local hBar = Instance.new("Frame", ESPGui)
    hBar.BackgroundColor3 = getColor("C_HealthHigh"); hBar.BorderSizePixel = 0; hBar.Visible = false; hBar.ZIndex = 3
    local skel = {}
    for i = 1, 14 do skel[i] = makeLine(getColor("C_Skeleton"), 1) end
    ESP.cache[root] = { Box=box, BoxStroke=boxStroke, Name=name, Dist=dist,
        HealthBg=hBg, HealthBar=hBar, Skel=skel }
end
function ESP.Hide(esp)
    if not esp then return end
    for _, k in ipairs({"Box","Name","Dist","HealthBg","HealthBar"}) do
        if esp[k] then esp[k].Visible = false end
    end
    if esp.Skel then for _, l in ipairs(esp.Skel) do l.Visible = false end end
end
function ESP.Destroy(esp)
    if not esp then return end
    for _, k in ipairs({"Box","Name","Dist","HealthBg","HealthBar"}) do
        if esp[k] then pcall(function() esp[k]:Destroy() end) end
    end
    if esp.Skel then for _, l in ipairs(esp.Skel) do pcall(function() l:Destroy() end) end end
end
function ESP.Cleanup()
    local r = {}
    for root, e in pairs(ESP.cache) do
        if not Cache.targets[root] then ESP.Hide(e); ESP.Destroy(e); r[#r+1]=root end
    end
    for _, k in ipairs(r) do ESP.cache[k]=nil end
end

local function projectBounds(char, cam)
    local ok, cf, size = pcall(function() return char:GetBoundingBox() end)
    if not ok or not cf or not size then return nil end
    local hs = size * 0.5
    local corners = {
        cf * Vector3.new(-hs.X,-hs.Y,-hs.Z), cf * Vector3.new(-hs.X,-hs.Y, hs.Z),
        cf * Vector3.new(-hs.X, hs.Y,-hs.Z), cf * Vector3.new(-hs.X, hs.Y, hs.Z),
        cf * Vector3.new( hs.X,-hs.Y,-hs.Z), cf * Vector3.new( hs.X,-hs.Y, hs.Z),
        cf * Vector3.new( hs.X, hs.Y,-hs.Z), cf * Vector3.new( hs.X, hs.Y, hs.Z),
    }
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local any = false
    for _, c in ipairs(corners) do
        local sp = cam:WorldToViewportPoint(c)
        if sp.Z > 0 then
            any = true
            if sp.X < minX then minX = sp.X end
            if sp.X > maxX then maxX = sp.X end
            if sp.Y < minY then minY = sp.Y end
            if sp.Y > maxY then maxY = sp.Y end
        end
    end
    if not any or maxX - minX < 1 or maxY - minY < 1 then return nil end
    return minX, minY, maxX, maxY
end

function ESP.Render(esp, root, char, hum, cam, screenSize, screenCenter, dist, giY)
    local minX, minY, maxX, maxY = projectBounds(char, cam)
    if not minX then ESP.Hide(esp); return false end
    minY = minY + giY; maxY = maxY + giY
    local boxTop, boxBottom, boxLeft, boxRight = minY, maxY, minX, maxX
    local boxHeight = boxBottom - boxTop
    local boxWidth = boxRight - boxLeft
    local cx = (boxLeft + boxRight) * 0.5

    local isTeam = Cache.teamStatus[root] or false
    local col = isTeam and getColor("C_Team") or getColor("C_Enemy")

    if Config.ESP_Boxes and boxHeight > 4 and boxWidth > 4 then
        esp.Box.Position = UDim2.new(0, boxLeft, 0, boxTop)
        esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
        esp.BoxStroke.Color = col
        esp.Box.Visible = true
    else esp.Box.Visible = false end

    if Config.ESP_Names then
        esp.Name.Text = Util.getName(char)
        esp.Name.Position = UDim2.new(0, cx - 110, 0, boxTop - Tuning.NameOffset)
        esp.Name.TextColor3 = col; esp.Name.Visible = true
    else esp.Name.Visible = false end

    if Config.ESP_Distance then
        esp.Dist.Text = string.format("%d m", math.floor(dist))
        esp.Dist.Position = UDim2.new(0, cx - 110, 0, boxBottom + Tuning.DistOffset)
        esp.Dist.TextColor3 = getColor("C_Distance")
        esp.Dist.Visible = true
    else esp.Dist.Visible = false end

    if Config.ESP_Health then
        local pct = math.clamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
        local barX = boxLeft - Tuning.HealthBarOffset
        esp.HealthBg.Position = UDim2.new(0, barX - 1, 0, boxTop - 1)
        esp.HealthBg.Size = UDim2.new(0, Tuning.HealthBarWidth + 2, 0, boxHeight + 2)
        esp.HealthBg.BackgroundColor3 = getColor("C_HealthBg")
        esp.HealthBg.Visible = true
        local hh = boxHeight * pct
        esp.HealthBar.Position = UDim2.new(0, barX, 0, boxBottom - hh)
        esp.HealthBar.Size = UDim2.new(0, Tuning.HealthBarWidth, 0, hh)
        esp.HealthBar.BackgroundColor3 = pct > 0.6 and getColor("C_HealthHigh")
            or pct > 0.3 and getColor("C_HealthMid")
            or getColor("C_HealthLow")
        esp.HealthBar.Visible = true
    else esp.HealthBg.Visible = false; esp.HealthBar.Visible = false end

    if Config.ESP_Skeleton then
        local pairs_ = getSkel(char)
        local idx = 0
        for i, b in ipairs(pairs_) do
            if i > #esp.Skel then break end
            idx = i
            local p1, p2 = char:FindFirstChild(b[1]), char:FindFirstChild(b[2])
            if p1 and p2 then
                local s1, o1 = cam:WorldToViewportPoint(p1.Position)
                local s2, o2 = cam:WorldToViewportPoint(p2.Position)
                if o1 and o2 and s1.Z > 0 and s2.Z > 0 then
                    drawLine(esp.Skel[i], s1.X, s1.Y + giY, s2.X, s2.Y + giY, getColor("C_Skeleton"), 1)
                else esp.Skel[i].Visible = false end
            else esp.Skel[i].Visible = false end
        end
        for i = idx + 1, #esp.Skel do esp.Skel[i].Visible = false end
    else for _, l in ipairs(esp.Skel) do l.Visible = false end end
    return true
end

function ESP.Step(cam, screenSize, screenCenter)
    if not Config.ESP_Enabled then
        for _, e in pairs(ESP.cache) do ESP.Hide(e) end
        Cache.drawn = 0; return
    end
    ESP.Cleanup()
    local myRoot = Cache.myRoot
    local giY = -GuiService:GetGuiInset().Y
    local drawn = 0
    for root, char in pairs(Cache.targets) do
        if not root or not root.Parent or not char or not char.Parent then
            if ESP.cache[root] then ESP.Hide(ESP.cache[root]) end
        else
            local hum = Cache.humanoids[root]
            if not hum or not hum.Parent or hum.Health <= 0 then
                if ESP.cache[root] then ESP.Hide(ESP.cache[root]) end
            elseif Config.ESP_TeamCheck and Cache.teamStatus[root] then
                if ESP.cache[root] then ESP.Hide(ESP.cache[root]) end
            else
                if not ESP.cache[root] then ESP.Create(root) end
                local esp = ESP.cache[root]
                local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                if dist > Config.ESP_MaxDist then ESP.Hide(esp)
                else
                    local ok, res = pcall(ESP.Render, esp, root, char, hum, cam, screenSize, screenCenter, dist, giY)
                    if ok and res then drawn = drawn + 1 end
                end
            end
        end
    end
    Cache.drawn = drawn
end

-- ============================================================
-- DRONE ESP
-- ============================================================
local DroneESP = { cache = {} }

function DroneESP.Create(model)
    if DroneESP.cache[model] then return end
    local box = Instance.new("Frame", ESPGui)
    box.BackgroundTransparency = 1; box.BorderSizePixel = 0; box.Visible = false; box.ZIndex = 3
    local boxStroke = Instance.new("UIStroke", box); boxStroke.Thickness = 2
    local name = Instance.new("TextLabel", ESPGui)
    name.BackgroundTransparency = 1; name.Font = Enum.Font.GothamBold
    name.TextSize = 12; name.TextColor3 = Color3.new(1,1,1)
    name.TextStrokeTransparency = 0; name.TextStrokeColor3 = Color3.new(0,0,0)
    name.Size = UDim2.new(0,150,0,16); name.TextXAlignment = Enum.TextXAlignment.Center
    name.Text = "[FPV]"; name.Visible = false; name.ZIndex = 4
    local dist = Instance.new("TextLabel", ESPGui)
    dist.BackgroundTransparency = 1; dist.Font = Enum.Font.GothamMedium
    dist.TextSize = 10; dist.TextColor3 = Color3.fromRGB(220,220,220)
    dist.TextStrokeTransparency = 0; dist.TextStrokeColor3 = Color3.new(0,0,0)
    dist.Size = UDim2.new(0,100,0,14); dist.TextXAlignment = Enum.TextXAlignment.Center
    dist.Visible = false; dist.ZIndex = 4
    DroneESP.cache[model] = { Box=box, BoxStroke=boxStroke, Name=name, Dist=dist }
end
function DroneESP.Hide(esp)
    if not esp then return end
    for _, k in ipairs({"Box","Name","Dist"}) do
        if esp[k] then esp[k].Visible = false end
    end
end
function DroneESP.Destroy(esp)
    if not esp then return end
    for _, k in ipairs({"Box","Name","Dist"}) do
        if esp[k] then pcall(function() esp[k]:Destroy() end) end
    end
end
function DroneESP.Cleanup()
    local r = {}
    for m, e in pairs(DroneESP.cache) do
        if not Cache.drones[m] then DroneESP.Hide(e); DroneESP.Destroy(e); r[#r+1]=m end
    end
    for _, k in ipairs(r) do DroneESP.cache[k]=nil end
end
function DroneESP.Step(cam, screenSize, screenCenter)
    if not Config.ESP_Enabled or not Config.ESP_Drones then
        for _, e in pairs(DroneESP.cache) do DroneESP.Hide(e) end
        Cache.droneDrawn = 0
        return
    end
    DroneESP.Cleanup()
    local myRoot = Cache.myRoot
    local giY = -GuiService:GetGuiInset().Y
    local drawn = 0
    for model, info in pairs(Cache.drones) do
        if not model.Parent or not info.part or not info.part.Parent then
            if DroneESP.cache[model] then DroneESP.Hide(DroneESP.cache[model]) end
        elseif Config.ESP_DronesTeamCheck and info.isMyTeam then
            if DroneESP.cache[model] then DroneESP.Hide(DroneESP.cache[model]) end
        else
            if not DroneESP.cache[model] then DroneESP.Create(model) end
            local esp = DroneESP.cache[model]
            local pos = info.part.Position
            local dist = myRoot and (pos - myRoot.Position).Magnitude or 0
            if dist > Config.ESP_MaxDist then
                DroneESP.Hide(esp)
            else
                local sp, on = cam:WorldToViewportPoint(pos)
                if on and sp.Z > 0 then
                    local size = math.clamp(1000 / sp.Z, 18, 100)
                    local x = sp.X - size/2
                    local y = sp.Y - size/2 + giY
                    esp.Box.Position = UDim2.new(0, x, 0, y)
                    esp.Box.Size = UDim2.new(0, size, 0, size)
                    esp.BoxStroke.Color = info.isMyTeam and getColor("C_DroneTeam") or getColor("C_DroneEnemy")
                    esp.Box.Visible = true
                    esp.Name.Position = UDim2.new(0, sp.X - 75, 0, y - 16)
                    esp.Name.TextColor3 = info.isMyTeam and getColor("C_DroneTeam") or getColor("C_DroneEnemy")
                    esp.Name.Visible = true
                    esp.Dist.Position = UDim2.new(0, sp.X - 50, 0, y + size + 2)
                    esp.Dist.Text = string.format("%d m", math.floor(dist))
                    esp.Dist.Visible = true
                    drawn = drawn + 1
                else
                    DroneESP.Hide(esp)
                end
            end
        end
    end
    Cache.droneDrawn = drawn
end

-- ============================================================
-- RADAR
-- ============================================================
local RadarFrame = Instance.new("Frame", UI)
RadarFrame.BackgroundColor3 = getColor("C_RadarBg"); RadarFrame.BackgroundTransparency = 0.2
RadarFrame.BorderSizePixel = 0; RadarFrame.AnchorPoint = Vector2.new(1, 0)
Instance.new("UICorner", RadarFrame).CornerRadius = UDim.new(0, 6)
local RStroke = Instance.new("UIStroke", RadarFrame)
RStroke.Color = getColor("C_RadarBorder"); RStroke.Thickness = 1; RStroke.Transparency = 0.4
local RadarCenter = Instance.new("Frame", RadarFrame)
RadarCenter.BackgroundColor3 = getColor("C_RadarYou"); RadarCenter.BorderSizePixel = 0
RadarCenter.AnchorPoint = Vector2.new(0.5, 0.5); RadarCenter.Size = UDim2.new(0, 8, 0, 8)
Instance.new("UICorner", RadarCenter).CornerRadius = UDim.new(1, 0)
local radarDots = {}
for i = 1, 50 do
    local d = Instance.new("Frame", RadarFrame)
    d.BackgroundColor3 = getColor("C_RadarEnemy"); d.BorderSizePixel = 0
    d.AnchorPoint = Vector2.new(0.5, 0.5)
    d.Size = UDim2.new(0, Tuning.RadarDotSize, 0, Tuning.RadarDotSize); d.Visible = false
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    radarDots[i] = d
end
local function UpdateRadar(cam)
    if not Config.RADAR_Enabled then RadarFrame.Visible = false; return end
    local myRoot = Cache.myRoot
    if not myRoot or not myRoot.Parent then RadarFrame.Visible = false; return end
    local size = Config.RADAR_Size
    RadarFrame.Position = UDim2.new(1, -14, 0, 14)
    RadarFrame.Size = UDim2.new(0, size, 0, size); RadarFrame.Visible = true
    RadarCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
    local myLook = cam.CFrame.LookVector
    local ang = math.atan2(-myLook.X, -myLook.Z)
    local ca, sa = math.cos(ang), math.sin(ang)
    local scale = (size/2 - 10) / Tuning.RadarRange
    local idx = 1
    for root in pairs(Cache.targets) do
        if idx > #radarDots then break end
        if root and root.Parent then
            local isTeam = Cache.teamStatus[root]
            if not (Config.ESP_TeamCheck and isTeam) then
                local rx, rz = root.Position.X - myRoot.Position.X, root.Position.Z - myRoot.Position.Z
                local d2 = math.sqrt(rx^2 + rz^2)
                if d2 < Tuning.RadarRange then
                    local rotX = rx * ca - rz * sa
                    local rotZ = rx * sa + rz * ca
                    local rX, rY = rotX * scale, rotZ * scale
                    local maxD = size/2 - 8
                    local rD = math.sqrt(rX^2 + rY^2)
                    if rD > maxD then rX, rY = rX/rD*maxD, rY/rD*maxD end
                    radarDots[idx].Position = UDim2.new(0.5, rX, 0.5, rY)
                    radarDots[idx].BackgroundColor3 = isTeam and getColor("C_Team") or getColor("C_RadarEnemy")
                    radarDots[idx].Visible = true; idx = idx + 1
                end
            end
        end
    end
    for i = idx, #radarDots do radarDots[i].Visible = false end
end

-- ============================================================
-- AIMBOT
-- ============================================================
local Aim = { aiming=false, locked=nil }
Conn.mb2down = Mouse.Button2Down:Connect(function() Aim.aiming=true end)
Conn.mb2up = Mouse.Button2Up:Connect(function() Aim.aiming=false; Aim.locked=nil end)
local function wantsAim()
    local k = Config.AIM_AimKey
    if k == "Always" then return true end
    if k == "RMB" then return Aim.aiming or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) end
    if k == "LMB" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) end
    return false
end
local function getBest(cam)
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local best, bestScore = nil, math.huge
    for root, char in pairs(Cache.targets) do
        if root and root.Parent and char then
            local skip = false
            if Config.AIM_TeamCheck and Cache.teamStatus[root] then skip = true end
            if not skip then
                local head = char:FindFirstChild("Head") or root
                local sp, on = cam:WorldToViewportPoint(head.Position)
                if on and sp.Z > 0 then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d <= Config.AIM_FOV and d < bestScore then bestScore = d; best = char end
                end
            end
        end
    end
    return best
end
local function getAimPos(char, cam)
    local bone = Config.AIM_TargetBone
    if bone == "Head" or bone == "Torso" or bone == "HumanoidRootPart" then
        local p = char:FindFirstChild(bone); return p and p.Position
    end
    local p = char:FindFirstChild("Head") or char:FindFirstChild("Torso")
    return p and p.Position
end
local FOVCircle = Instance.new("Frame", UI)
FOVCircle.BackgroundTransparency = 1; FOVCircle.BorderSizePixel = 0
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5); FOVCircle.ZIndex = 5
local FOVS = Instance.new("UIStroke", FOVCircle)
FOVS.Color = getColor("C_FOVCircle"); FOVS.Thickness = 1
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

local lastAimWarn = 0
task.spawn(function()
    while not Unloaded do
        RunService.RenderStepped:Wait()
        if Config.AIM_Enabled then
            local cam = Workspace.CurrentCamera
            if cam then
                local ok, err = pcall(function()
                    if not wantsAim() then Aim.locked=nil; return end
                    if not Aim.locked or not Aim.locked.Parent then Aim.locked = getBest(cam) end
                    if not Aim.locked then return end
                    local hum = Aim.locked:FindFirstChild("Humanoid")
                    if not hum or hum.Health <= 0 then Aim.locked=nil; return end
                    local pos = getAimPos(Aim.locked, cam)
                    if not pos then return end
                    local sp, on = cam:WorldToViewportPoint(pos)
                    if not on or sp.Z <= 0 then return end
                    local dx = sp.X - cam.ViewportSize.X/2
                    local dy = sp.Y - cam.ViewportSize.Y/2
                    if math.abs(dx) < 0.5 and math.abs(dy) < 0.5 then return end
                    local sm = Config.AIM_Smooth
                    if Config.AIM_DynamicSmooth then
                        local d3 = (pos - cam.CFrame.Position).Magnitude
                        sm = math.clamp(Config.AIM_Smooth * math.min(d3/500, 1), 1, Config.AIM_Smooth)
                    end
                    local mx, my
                    if sm <= 1 then mx, my = dx, dy else mx, my = dx/sm, dy/sm end
                    mx = mx + (math.random() - 0.5) * 0.6
                    my = my + (math.random() - 0.5) * 0.6
                    pcall(mousemoverel, mx, my)
                end)
                if not ok and tick() - lastAimWarn > 3 then
                    lastAimWarn = tick(); warn("[MORTY AIM]", err)
                end
            end
        end
    end
end)

-- ============================================================
-- SPEED / JUMP
-- ============================================================
local Speed = { active=false, sw=nil, sj=nil, sjh=nil }
local function speedStep()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local wantS, wantJ = Config.SPEED_Enabled, Config.JUMP_Enabled
    if (wantS or wantJ) and not Speed.active then
        Speed.active = true
        Speed.sw = hum.WalkSpeed
        Speed.sj = hum.UseJumpPower and hum.JumpPower or nil
        Speed.sjh = (not hum.UseJumpPower) and hum.JumpHeight or nil
    end
    if wantS then
        local v = math.clamp(math.floor(Config.SPEED_Value), 1, 250)
        local cur = hum.WalkSpeed
        if cur < v then hum.WalkSpeed = math.min(cur + Tuning.SpeedStepPerFrame, v)
        elseif cur > v then hum.WalkSpeed = math.max(cur - Tuning.SpeedStepPerFrame, v) end
    end
    if wantJ then
        local v = math.clamp(math.floor(Config.JUMP_Value), 30, 300)
        if hum.UseJumpPower then
            local cur = hum.JumpPower
            if cur < v then hum.JumpPower = math.min(cur + Tuning.SpeedStepPerFrame, v)
            elseif cur > v then hum.JumpPower = math.max(cur - Tuning.SpeedStepPerFrame, v) end
        else
            local jh = v * 0.15
            local cur = hum.JumpHeight
            local step = Tuning.SpeedStepPerFrame * 0.15
            if cur < jh then hum.JumpHeight = math.min(cur + step, jh)
            elseif cur > jh then hum.JumpHeight = math.max(cur - step, jh) end
        end
    end
    if not wantS and not wantJ and Speed.active then
        Speed.active = false
        if Speed.sw then hum.WalkSpeed = Speed.sw end
        if Speed.sj and hum.UseJumpPower then hum.JumpPower = Speed.sj end
        if Speed.sjh and not hum.UseJumpPower then hum.JumpHeight = Speed.sjh end
        Speed.sw=nil; Speed.sj=nil; Speed.sjh=nil
    end
end

-- ============================================================
-- FREECAM
-- ============================================================
local FC = { enabled=false, savedCT=nil, savedSub=nil, savedFOV=nil,
    rot=Vector2.zero, pos=Vector3.zero, inputs={} }
Conn.fcKeyDown = UserInputService.InputBegan:Connect(function(i)
    if not FC.enabled then return end
    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
    FC.inputs[i.KeyCode] = true
end)
Conn.fcKeyUp = UserInputService.InputEnded:Connect(function(i)
    if not FC.enabled then return end
    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
    FC.inputs[i.KeyCode] = false
end)
Conn.fcMouse = UserInputService.InputChanged:Connect(function(i)
    if not FC.enabled then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement then
        local s = Config.FREECAM_Sensitivity * 0.0025
        FC.rot = Vector2.new(FC.rot.X - i.Delta.X * s,
            math.clamp(FC.rot.Y - i.Delta.Y * s, -math.rad(89), math.rad(89)))
    end
end)
local function freecamTick(dt)
    if Config.FREECAM_Enabled ~= FC.enabled then
        local cam = Workspace.CurrentCamera
        if Config.FREECAM_Enabled then
            if cam then
                FC.enabled = true
                FC.savedCT = cam.CameraType; FC.savedSub = cam.CameraSubject; FC.savedFOV = cam.FieldOfView
                FC.pos = cam.CFrame.Position
                local lk = cam.CFrame.LookVector
                FC.rot = Vector2.new(math.atan2(-lk.X, -lk.Z), math.asin(math.clamp(lk.Y, -1, 1)))
                FC.inputs = {}
                cam.CameraType = Enum.CameraType.Scriptable
            end
        else
            FC.enabled = false
            if cam then
                cam.CameraType = FC.savedCT or Enum.CameraType.Custom
                if FC.savedSub then cam.CameraSubject = FC.savedSub end
                if FC.savedFOV then cam.FieldOfView = FC.savedFOV end
            end
        end
    end
    if not FC.enabled then return end
    local cam = Workspace.CurrentCamera; if not cam then return end
    local rot = CFrame.fromEulerAnglesYXZ(FC.rot.Y, FC.rot.X, 0)
    local speed = Config.FREECAM_Speed
    if FC.inputs[Enum.KeyCode.LeftShift] then speed = speed * 3 end
    if FC.inputs[Enum.KeyCode.LeftControl] then speed = speed * 0.25 end
    local fwd, right = rot.LookVector, rot.RightVector
    local move = Vector3.zero
    if FC.inputs[Enum.KeyCode.W] then move = move + fwd end
    if FC.inputs[Enum.KeyCode.S] then move = move - fwd end
    if FC.inputs[Enum.KeyCode.D] then move = move + right end
    if FC.inputs[Enum.KeyCode.A] then move = move - right end
    if FC.inputs[Enum.KeyCode.Space] or FC.inputs[Enum.KeyCode.E] then move = move + Vector3.new(0,1,0) end
    if FC.inputs[Enum.KeyCode.Q] then move = move - Vector3.new(0,1,0) end
    if move.Magnitude > 0 then FC.pos = FC.pos + move.Unit * speed * dt end
    cam.CFrame = CFrame.new(FC.pos) * rot
end

-- ============================================================
-- COLOR PICKER
-- ============================================================
local ColorPicker = { frame=nil, conns={} }
function ColorPicker.Close()
    for _, c in ipairs(ColorPicker.conns) do pcall(function() c:Disconnect() end) end
    ColorPicker.conns = {}
    if ColorPicker.frame then pcall(function() ColorPicker.frame:Destroy() end); ColorPicker.frame=nil end
end
function ColorPicker.Open(key)
    ColorPicker.Close()
    local startCol = getColor(key)
    local h, s, v = Color3.toHSV(startCol)
    local W, H = 340, 260
    local f = Instance.new("Frame", UI)
    f.BackgroundColor3 = Color3.fromRGB(10,10,12); f.BorderSizePixel = 0
    f.Size = UDim2.new(0, W, 0, H); f.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    f.ZIndex = 1100; f.Active = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", f); st.Color = getColor("C_Accent"); st.Thickness = 1
    ColorPicker.frame = f

    local title = Instance.new("TextLabel", f)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 12, 0, 8); title.Size = UDim2.new(1, -24, 0, 20)
    title.Font = Enum.Font.GothamBold; title.TextSize = 13
    title.TextColor3 = getColor("C_Accent"); title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = tItem(key, key); title.ZIndex = 1101

    local prev = Instance.new("Frame", f)
    prev.BackgroundColor3 = startCol; prev.BorderSizePixel = 0
    prev.Position = UDim2.new(0, 12, 0, 34); prev.Size = UDim2.new(0, 40, 0, 30)
    Instance.new("UICorner", prev).CornerRadius = UDim.new(0, 5); prev.ZIndex = 1101

    local hueSlider = Instance.new("Frame", f)
    hueSlider.BackgroundColor3 = Color3.new(1,1,1); hueSlider.BorderSizePixel = 0
    hueSlider.Position = UDim2.new(0, 60, 0, 34); hueSlider.Size = UDim2.new(1, -72, 0, 30)
    Instance.new("UICorner", hueSlider).CornerRadius = UDim.new(0, 5)
    hueSlider.ClipsDescendants = true; hueSlider.ZIndex = 1101
    local hg = Instance.new("UIGradient", hueSlider); hg.Rotation = 0
    hg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,0))
    })
    local hueCursor = Instance.new("Frame", hueSlider)
    hueCursor.BackgroundColor3 = Color3.new(1,1,1); hueCursor.BorderSizePixel = 0
    hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    hueCursor.Size = UDim2.new(0, 4, 1, 0); hueCursor.ZIndex = 1110
    hueCursor.Position = UDim2.new(h, 0, 0.5, 0)

    local svCanvas = Instance.new("Frame", f)
    svCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1); svCanvas.BorderSizePixel = 0
    svCanvas.Position = UDim2.new(0, 12, 0, 74); svCanvas.Size = UDim2.new(0, 300, 0, 130)
    Instance.new("UICorner", svCanvas).CornerRadius = UDim.new(0, 5)
    svCanvas.ClipsDescendants = true; svCanvas.ZIndex = 1101
    local gw = Instance.new("Frame", svCanvas)
    gw.BackgroundColor3 = Color3.new(1,1,1); gw.BorderSizePixel = 0
    gw.Size = UDim2.new(1, 0, 1, 0); gw.ZIndex = 1102
    local gwg = Instance.new("UIGradient", gw)
    gwg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
    local gb = Instance.new("Frame", svCanvas)
    gb.BackgroundColor3 = Color3.new(0,0,0); gb.BorderSizePixel = 0
    gb.Size = UDim2.new(1, 0, 1, 0); gb.ZIndex = 1103
    local gbg = Instance.new("UIGradient", gb); gbg.Rotation = 90
    gbg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})
    local svCursor = Instance.new("Frame", svCanvas)
    svCursor.BackgroundTransparency = 1; svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    svCursor.Size = UDim2.new(0, 12, 0, 12); svCursor.ZIndex = 1110
    local svcStroke = Instance.new("UIStroke", svCursor); svcStroke.Color = Color3.new(1,1,1); svcStroke.Thickness = 2
    Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)
    svCursor.Position = UDim2.new(s, 0, 1 - v, 0)

    local curH, curS, curV = h, s, v
    local function sync()
        prev.BackgroundColor3 = Color3.fromHSV(curH, curS, curV)
        svCanvas.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)
        svCursor.Position = UDim2.new(curS, 0, 1 - curV, 0)
        hueCursor.Position = UDim2.new(curH, 0, 0.5, 0)
    end
    sync()

    local applyBtn = Instance.new("TextButton", f)
    applyBtn.BackgroundColor3 = getColor("C_Accent"); applyBtn.BorderSizePixel = 0
    applyBtn.Position = UDim2.new(0, 12, 1, -46); applyBtn.Size = UDim2.new(0.5, -18, 0, 32)
    applyBtn.Font = Enum.Font.GothamBold; applyBtn.TextSize = 12
    applyBtn.TextColor3 = Color3.new(0,0,0); applyBtn.Text = "OK"; applyBtn.ZIndex = 1101
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 5)
    local cancelBtn = Instance.new("TextButton", f)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(24,24,28); cancelBtn.BorderSizePixel = 0
    cancelBtn.Position = UDim2.new(0.5, 4, 1, -46); cancelBtn.Size = UDim2.new(0.5, -18, 0, 32)
    cancelBtn.Font = Enum.Font.GothamBold; cancelBtn.TextSize = 12
    cancelBtn.TextColor3 = Color3.fromRGB(200,200,200); cancelBtn.Text = "X"; cancelBtn.ZIndex = 1101
    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 5)

    local svDrag = false
    svCanvas.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = true end
    end)
    table.insert(ColorPicker.conns, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = false end
    end))
    local svConn = RunService.RenderStepped:Connect(function()
        if not f.Parent then svConn:Disconnect(); return end
        if svDrag then
            local mp = UserInputService:GetMouseLocation()
            local ap = svCanvas.AbsolutePosition; local asz = svCanvas.AbsoluteSize
            if asz.X <= 0 or asz.Y <= 0 then return end
            curS = math.clamp((mp.X - ap.X)/asz.X, 0, 1)
            curV = 1 - math.clamp((mp.Y - ap.Y)/asz.Y, 0, 1)
            sync()
        end
    end)
    table.insert(ColorPicker.conns, svConn)

    local hDrag = false
    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then hDrag = true end
    end)
    table.insert(ColorPicker.conns, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then hDrag = false end
    end))
    local hConn = RunService.RenderStepped:Connect(function()
        if not f.Parent then hConn:Disconnect(); return end
        if hDrag then
            local mp = UserInputService:GetMouseLocation()
            local ap = hueSlider.AbsolutePosition; local asz = hueSlider.AbsoluteSize
            if asz.X <= 0 then return end
            curH = math.clamp((mp.X - ap.X)/asz.X, 0, 1)
            sync()
        end
    end)
    table.insert(ColorPicker.conns, hConn)

    applyBtn.MouseButton1Click:Connect(function()
        setColor(key, Color3.fromHSV(curH, curS, curV))
        ColorPicker.Close()
    end)
    cancelBtn.MouseButton1Click:Connect(function() ColorPicker.Close() end)
end

-- ============================================================
-- BIND EDITOR
-- ============================================================
local BindEditor = { frame=nil, targetKey=nil, mode="Toggle", pendingKey=nil, conn=nil }
function BindEditor.Close()
    if BindEditor.conn then pcall(function() BindEditor.conn:Disconnect() end); BindEditor.conn=nil end
    if BindEditor.frame then pcall(function() BindEditor.frame:Destroy() end); BindEditor.frame=nil end
    BindEditor.targetKey = nil; BindEditor.pendingKey = nil
end
function BindEditor.Open(configKey, displayName)
    BindEditor.Close()
    local existing = Binds[configKey]
    BindEditor.targetKey = configKey
    BindEditor.mode = existing and existing.mode or "Toggle"
    BindEditor.pendingKey = existing and existing.key or nil

    local frame = Instance.new("Frame", UI)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,12); frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 300, 0, 210)
    frame.Position = UDim2.new(0.5, -150, 0.5, -105); frame.ZIndex = 999
    BindEditor.frame = frame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = getColor("C_Accent"); stroke.Thickness = 1

    local title = Instance.new("TextLabel", frame)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 14, 0, 12); title.Size = UDim2.new(1, -28, 0, 20)
    title.Font = Enum.Font.GothamBold; title.TextSize = 13
    title.TextColor3 = getColor("C_Accent"); title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = t("bind_title") .. displayName; title.ZIndex = 1000

    local hint = Instance.new("TextLabel", frame)
    hint.BackgroundTransparency = 1
    hint.Position = UDim2.new(0, 14, 0, 38); hint.Size = UDim2.new(1, -28, 0, 24)
    hint.Font = Enum.Font.GothamMedium; hint.TextSize = 12
    hint.TextColor3 = BindEditor.pendingKey and getColor("C_Accent") or Color3.fromRGB(130,130,140)
    hint.TextXAlignment = Enum.TextXAlignment.Center
    hint.Text = BindEditor.pendingKey and (t("bind_key") .. BindEditor.pendingKey.Name) or t("bind_hint")
    hint.ZIndex = 1000

    local modeFrame = Instance.new("Frame", frame)
    modeFrame.BackgroundTransparency = 1
    modeFrame.Position = UDim2.new(0, 14, 0, 70); modeFrame.Size = UDim2.new(1, -28, 0, 30); modeFrame.ZIndex = 1000
    local togBtn = Instance.new("TextButton", modeFrame)
    togBtn.BackgroundColor3 = BindEditor.mode == "Toggle" and getColor("C_Accent") or Color3.fromRGB(24,24,28)
    togBtn.BorderSizePixel = 0; togBtn.Size = UDim2.new(0.5, -3, 1, 0)
    togBtn.Font = Enum.Font.GothamBold; togBtn.TextSize = 12
    togBtn.TextColor3 = BindEditor.mode == "Toggle" and Color3.new(0,0,0) or Color3.fromRGB(240,240,245)
    togBtn.Text = t("bind_toggle"); togBtn.AutoButtonColor = false; togBtn.ZIndex = 1000
    Instance.new("UICorner", togBtn).CornerRadius = UDim.new(0, 5)
    local holdBtn = Instance.new("TextButton", modeFrame)
    holdBtn.BackgroundColor3 = BindEditor.mode == "Hold" and getColor("C_Accent") or Color3.fromRGB(24,24,28)
    holdBtn.BorderSizePixel = 0; holdBtn.Position = UDim2.new(0.5, 3, 0, 0); holdBtn.Size = UDim2.new(0.5, -3, 1, 0)
    holdBtn.Font = Enum.Font.GothamBold; holdBtn.TextSize = 12
    holdBtn.TextColor3 = BindEditor.mode == "Hold" and Color3.new(0,0,0) or Color3.fromRGB(240,240,245)
    holdBtn.Text = t("bind_hold"); holdBtn.AutoButtonColor = false; holdBtn.ZIndex = 1000
    Instance.new("UICorner", holdBtn).CornerRadius = UDim.new(0, 5)
    togBtn.MouseButton1Click:Connect(function()
        BindEditor.mode = "Toggle"
        togBtn.BackgroundColor3 = getColor("C_Accent"); togBtn.TextColor3 = Color3.new(0,0,0)
        holdBtn.BackgroundColor3 = Color3.fromRGB(24,24,28); holdBtn.TextColor3 = Color3.fromRGB(240,240,245)
    end)
    holdBtn.MouseButton1Click:Connect(function()
        BindEditor.mode = "Hold"
        holdBtn.BackgroundColor3 = getColor("C_Accent"); holdBtn.TextColor3 = Color3.new(0,0,0)
        togBtn.BackgroundColor3 = Color3.fromRGB(24,24,28); togBtn.TextColor3 = Color3.fromRGB(240,240,245)
    end)

    local actFrame = Instance.new("Frame", frame)
    actFrame.BackgroundTransparency = 1
    actFrame.Position = UDim2.new(0, 14, 1, -40); actFrame.Size = UDim2.new(1, -28, 0, 28); actFrame.ZIndex = 1000
    local function mkBtn(txt, xPos, bg, fg, cb)
        local b = Instance.new("TextButton", actFrame)
        b.BackgroundColor3 = bg; b.BorderSizePixel = 0
        b.Position = UDim2.new(xPos, 0, 0, 0); b.Size = UDim2.new(0.33, -3, 1, 0)
        b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.TextColor3 = fg; b.Text = txt
        b.AutoButtonColor = false; b.ZIndex = 1000
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(cb)
        return b
    end
    mkBtn(t("bind_clear"), 0, Color3.fromRGB(60,25,25), Color3.fromRGB(255,180,180), function()
        Binds[BindEditor.targetKey] = nil
        HoldActive[BindEditor.targetKey] = nil
        if GUI then GUI.RefreshItemVisual(BindEditor.targetKey) end
        BindEditor.Close()
    end)
    mkBtn(t("bind_save"), 0.34, getColor("C_Accent"), Color3.new(0,0,0), function()
        if not BindEditor.pendingKey then return end
        Binds[BindEditor.targetKey] = { key = BindEditor.pendingKey, mode = BindEditor.mode }
        if GUI then GUI.RefreshItemVisual(BindEditor.targetKey) end
        BindEditor.Close()
    end)
    mkBtn(t("bind_cancel"), 0.67, Color3.fromRGB(24,24,28), Color3.fromRGB(240,240,245), function()
        BindEditor.Close()
    end)

    BindEditor.conn = UserInputService.InputBegan:Connect(function(input)
        if not BindEditor.frame then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode.Unknown then return end
        if input.KeyCode == Enum.KeyCode.Escape then BindEditor.Close(); return end
        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.Home then return end
        BindEditor.pendingKey = input.KeyCode
        hint.Text = t("bind_key") .. input.KeyCode.Name
        hint.TextColor3 = getColor("C_Accent")
    end)
end

-- ============================================================
-- МЕНЮ
-- ============================================================
local Tabs = {
    { id="Aim", icon="*", langKey="tab_aim" },
    { id="Wallhack", icon="o", langKey="tab_wallhack" },
    { id="World", icon="+", langKey="tab_world" },
    { id="Misc", icon="#", langKey="tab_misc" },
    { id="Customize", icon="~", langKey="tab_customize" },
}
local Layout = {
    Aim = {
        col1 = {
            { titleKey="grp_aimbot", items = {
                {name="Enable", key="AIM_Enabled", type="toggle"},
                {name="Visible Check", key="AIM_WallCheck", type="toggle"},
                {name="Show FOV", key="AIM_ShowFOV", type="toggle"},
                {name="Dynamic Smooth", key="AIM_DynamicSmooth", type="toggle"},
                {name="Aim Key", key="AIM_AimKey", type="dropdown", list=AimKeys},
                {name="Aim Fov", key="AIM_FOV", type="slider", min=50, max=500, step=25},
                {name="Smooth Value", key="AIM_Smooth", type="slider", min=1, max=100, step=1},
                {name="Bone", key="AIM_TargetBone", type="dropdown", list=AimBones}
            }}
        },
        col2 = {
            { titleKey="grp_target", items = {
                {name="Team Check", key="AIM_TeamCheck", type="toggle"}
            }}
        }
    },
    Wallhack = {
        col1 = {
            { titleKey="grp_players", items = {
                {name="Enable ESP", key="ESP_Enabled", type="toggle"},
                {name="Boxes", key="ESP_Boxes", type="toggle"},
                {name="Names", key="ESP_Names", type="toggle"},
                {name="Distance", key="ESP_Distance", type="toggle"},
                {name="Health Bar", key="ESP_Health", type="toggle"},
                {name="Team Check", key="ESP_TeamCheck", type="toggle"},
                {name="Max Distance", key="ESP_MaxDist", type="slider", min=500, max=5000, step=100}
            }},
            { titleKey="grp_skeleton", items = {
                {name="Skeleton", key="ESP_Skeleton", type="toggle"}
            }}
        },
        col2 = {
            { titleKey="grp_drones", items = {
                {name="Drone ESP", key="ESP_Drones", type="toggle"},
                {name="Drone Team Check", key="ESP_DronesTeamCheck", type="toggle"}
            }},
            { titleKey="grp_radar", items = {
                {name="Enable Radar", key="RADAR_Enabled", type="toggle"},
                {name="Radar Size", key="RADAR_Size", type="slider", min=80, max=200, step=10}
            }}
        }
    },
    World = {
        col1 = {
            { titleKey="grp_freecam", items = {
                {name="Enable Freecam", key="FREECAM_Enabled", type="toggle"},
                {name="Speed", key="FREECAM_Speed", type="slider", min=5, max=300, step=5},
                {name="Sensitivity", key="FREECAM_Sensitivity", type="slider", min=0.1, max=5, step=0.1}
            }}
        },
        col2 = {
            { titleKey="grp_ui", items = {
                {name="Watermark", key="UI_Watermark", type="toggle"}
            }}
        }
    },
    Misc = {
        col1 = {
            { titleKey="grp_speed", items = {
                {name="Speed Hack", key="SPEED_Enabled", type="toggle"},
                {name="Speed Value", key="SPEED_Value", type="slider", min=16, max=250, step=2},
                {name="Jump Power", key="JUMP_Enabled", type="toggle"},
                {name="Jump Value", key="JUMP_Value", type="slider", min=50, max=300, step=5}
            }}
        },
        col2 = {
            { titleKey="grp_binds", items = { {name="Binds", key="__BINDS_UI", type="binds"} } }
        }
    },
    Customize = {
        col1 = {
            { titleKey="grp_config", items = { {name="Config", key="__CFG_UI", type="configui"} }},
            { titleKey="grp_colors_player", items = {
                {name="Enemy", key="C_Enemy", type="color"},
                {name="Teammate", key="C_Team", type="color"},
                {name="Drone (enemy)", key="C_DroneEnemy", type="color"},
                {name="Drone (team)", key="C_DroneTeam", type="color"},
                {name="Box", key="C_Box", type="color"},
                {name="Name", key="C_Name", type="color"},
                {name="Distance", key="C_Distance", type="color"},
                {name="Skeleton", key="C_Skeleton", type="color"}
            }}
        },
        col2 = {
            { titleKey="grp_colors", items = {
                {name="HP bg", key="C_HealthBg", type="color"},
                {name="HP high", key="C_HealthHigh", type="color"},
                {name="HP mid", key="C_HealthMid", type="color"},
                {name="HP low", key="C_HealthLow", type="color"},
                {name="Radar bg", key="C_RadarBg", type="color"},
                {name="Radar border", key="C_RadarBorder", type="color"},
                {name="Radar you", key="C_RadarYou", type="color"},
                {name="Radar enemy", key="C_RadarEnemy", type="color"},
                {name="FOV circle", key="C_FOVCircle", type="color"},
                {name="FOV active", key="C_FOVActive", type="color"},
                {name="Accent", key="C_Accent", type="color"}
            }}
        }
    }
}

local GUI = { Frame=nil, Dragging=false, DragOffset=Vector2.zero, ContentArea=nil,
    ItemVisuals={}, TabsButtons={}, LangButtons={}, TabConnections={} }

local function getBindString(key)
    local b = Binds[key]
    if not b or not b.key then return "" end
    return "[" .. b.key.Name .. "]"
end
local function triggerBind(configKey)
    local b = Binds[configKey]; if not b then return end
    local tt = type(Config[configKey])
    if b.mode == "Hold" then
        if not HoldActive[configKey] then
            HoldActive[configKey] = true
            if tt == "boolean" then Config[configKey] = true; if GUI then GUI.RefreshItemVisual(configKey) end end
        end
    else
        if tt == "boolean" then
            Config[configKey] = not Config[configKey]
            if GUI then GUI.RefreshItemVisual(configKey) end
        end
    end
end
local function attachRMB(obj, key, name)
    if obj:IsA("GuiButton") then
        obj.MouseButton2Down:Connect(function() BindEditor.Open(key, name) end)
    else
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then BindEditor.Open(key, name) end
        end)
    end
end
local function addHelpIcon(row, key, xOffset)
    local desc = getDesc(key)
    if not desc then return nil end
    local q = Instance.new("TextButton", row)
    q.BackgroundColor3 = Color3.fromRGB(28,28,34); q.BorderSizePixel = 0
    q.Position = UDim2.new(1, -(xOffset or 145), 0.5, -9)
    q.Size = UDim2.new(0, 18, 0, 18)
    q.Font = Enum.Font.GothamBold; q.TextSize = 11
    q.TextColor3 = getColor("C_Accent"); q.Text = "?"
    q.AutoButtonColor = false; q.ZIndex = 6
    Instance.new("UICorner", q).CornerRadius = UDim.new(1, 0)
    local qStroke = Instance.new("UIStroke", q)
    qStroke.Color = getColor("C_Accent"); qStroke.Thickness = 1; qStroke.Transparency = 0.5
    q.MouseEnter:Connect(function() showTooltip(desc) end)
    q.MouseLeave:Connect(function() hideTooltip() end)
    return q
end

local function buildToggle(parent, item)
    local row = Instance.new("Frame", parent)
    row.BackgroundTransparency = 1; row.Size = UDim2.new(1, 0, 0, 26)
    local box = Instance.new("Frame", row)
    box.BackgroundColor3 = Config[item.key] and getColor("C_Accent") or Color3.fromRGB(28,28,32)
    box.BorderSizePixel = 0; box.Position = UDim2.new(0, 0, 0.5, -9); box.Size = UDim2.new(0, 18, 0, 18)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local bs = Instance.new("UIStroke", box)
    bs.Color = Config[item.key] and getColor("C_Accent") or Color3.fromRGB(50,50,58); bs.Thickness = 1
    local check = Instance.new("TextLabel", box)
    check.BackgroundTransparency = 1; check.Size = UDim2.new(1,0,1,0)
    check.Font = Enum.Font.GothamBold; check.TextSize = 14
    check.TextColor3 = Color3.new(0,0,0); check.Text = "v"; check.Visible = Config[item.key]
    local lbl = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 28, 0, 0); lbl.Size = UDim2.new(1, -170, 1, 0)
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(240,240,245); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Text = tItem(item.key, item.name)
    addHelpIcon(row, item.key, 145)
    local bindLbl = Instance.new("TextLabel", row)
    bindLbl.BackgroundTransparency = 1; bindLbl.Position = UDim2.new(1, -120, 0, 0); bindLbl.Size = UDim2.new(0, 95, 1, 0)
    bindLbl.Font = Enum.Font.GothamMedium; bindLbl.TextSize = 11
    bindLbl.TextColor3 = getColor("C_Accent"); bindLbl.TextXAlignment = Enum.TextXAlignment.Right
    bindLbl.Text = getBindString(item.key)
    local hit = Instance.new("TextButton", row)
    hit.BackgroundTransparency = 1; hit.Size = UDim2.new(1, -125, 1, 0)
    hit.Text = ""; hit.AutoButtonColor = false
    hit.MouseButton1Click:Connect(function()
        Config[item.key] = not Config[item.key]
        box.BackgroundColor3 = Config[item.key] and getColor("C_Accent") or Color3.fromRGB(28,28,32)
        bs.Color = Config[item.key] and getColor("C_Accent") or Color3.fromRGB(50,50,58)
        check.Visible = Config[item.key]
    end)
    attachRMB(hit, item.key, tItem(item.key, item.name))
    GUI.ItemVisuals[item.key] = function()
        local v = Config[item.key]
        box.BackgroundColor3 = v and getColor("C_Accent") or Color3.fromRGB(28,28,32)
        bs.Color = v and getColor("C_Accent") or Color3.fromRGB(50,50,58)
        check.Visible = v
        bindLbl.Text = getBindString(item.key)
    end
    return row
end

local function buildSlider(parent, item)
    local fmt = function(v) if item.step < 1 then return string.format("%.1f", v) end; return tostring(math.floor(v)) end
    local row = Instance.new("Frame", parent)
    row.BackgroundTransparency = 1; row.Size = UDim2.new(1, 0, 0, 42)
    local lbl = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 0, 0, 0); lbl.Size = UDim2.new(0.6, -22, 0, 20)
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(240,240,245); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Text = tItem(item.key, item.name)
    addHelpIcon(row, item.key, 145)
    for _, c in ipairs(row:GetChildren()) do
        if c:IsA("TextButton") and c.Text == "?" then
            c.Position = UDim2.new(0.6, 0, 0, 1)
        end
    end
    local valLbl = Instance.new("TextLabel", row)
    valLbl.BackgroundTransparency = 1; valLbl.Position = UDim2.new(0.6, 22, 0, 0); valLbl.Size = UDim2.new(0.4, -22, 0, 20)
    valLbl.Font = Enum.Font.GothamMedium; valLbl.TextSize = 13
    valLbl.TextColor3 = Color3.fromRGB(240,240,245); valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Text = fmt(Config[item.key])
    local track = Instance.new("Frame", row)
    track.BackgroundColor3 = Color3.fromRGB(28,28,32); track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 0, 0, 26); track.Size = UDim2.new(1, 0, 0, 4)
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local pct0 = (Config[item.key] - item.min) / (item.max - item.min)
    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = Color3.fromRGB(139,127,255); fill.BorderSizePixel = 0
    fill.Size = UDim2.new(pct0, 0, 1, 0); Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", track)
    knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct0, 0, 0.5, 0); knob.Size = UDim2.new(0, 14, 0, 14)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    table.insert(GUI.TabConnections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end))
    table.insert(GUI.TabConnections, RunService.RenderStepped:Connect(function()
        if not dragging then return end
        if not track.Parent or not fill.Parent or not knob.Parent then dragging = false; return end
        local tw = track.AbsoluteSize.X; if tw <= 0 then return end
        local tx = track.AbsolutePosition.X
        local mx = UserInputService:GetMouseLocation().X
        local p = math.clamp((mx-tx)/tw, 0, 1)
        local v = item.min + p * (item.max - item.min)
        v = math.floor(v / item.step + 0.5) * item.step
        Config[item.key] = math.clamp(v, item.min, item.max)
        local np = (Config[item.key] - item.min) / (item.max - item.min)
        fill.Size = UDim2.new(np, 0, 1, 0)
        knob.Position = UDim2.new(np, 0, 0.5, 0)
        valLbl.Text = fmt(Config[item.key])
    end))
    attachRMB(lbl, item.key, tItem(item.key, item.name))
    GUI.ItemVisuals[item.key] = function()
        local v = Config[item.key]
        local np = (v - item.min) / (item.max - item.min)
        fill.Size = UDim2.new(np, 0, 1, 0)
        knob.Position = UDim2.new(np, 0, 0.5, 0)
        valLbl.Text = fmt(v)
    end
    return row
end

local function buildDropdown(parent, item)
    local row = Instance.new("Frame", parent)
    row.BackgroundTransparency = 1; row.Size = UDim2.new(1, 0, 0, 46)
    local lbl = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 0, 0, 0); lbl.Size = UDim2.new(1, -30, 0, 18)
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(130,130,140); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = tItem(item.key, item.name)
    addHelpIcon(row, item.key, 4)
    local btn = Instance.new("TextButton", row)
    btn.BackgroundColor3 = Color3.fromRGB(24,24,28); btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 0, 0, 20); btn.Size = UDim2.new(1, 0, 0, 26)
    btn.Text = ""; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    local bs = Instance.new("UIStroke", btn); bs.Color = Color3.fromRGB(30,30,34); bs.Thickness = 1
    local btnLbl = Instance.new("TextLabel", btn)
    btnLbl.BackgroundTransparency = 1; btnLbl.Position = UDim2.new(0, 10, 0, 0); btnLbl.Size = UDim2.new(1, -30, 1, 0)
    btnLbl.Font = Enum.Font.GothamMedium; btnLbl.TextSize = 13
    btnLbl.TextColor3 = Color3.fromRGB(240,240,245); btnLbl.TextXAlignment = Enum.TextXAlignment.Left
    btnLbl.Text = tostring(Config[item.key])
    local listFrame = Instance.new("Frame", UI)
    listFrame.BackgroundColor3 = Color3.fromRGB(19,19,22); listFrame.BorderSizePixel = 0
    listFrame.Visible = false; listFrame.ZIndex = 500
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 5)
    local ls = Instance.new("UIStroke", listFrame); ls.Color = Color3.fromRGB(30,30,34); ls.Thickness = 1
    local listLayout = Instance.new("UIListLayout", listFrame); listLayout.Padding = UDim.new(0, 0)
    for i, opt in ipairs(item.list) do
        local optBtn = Instance.new("TextButton", listFrame)
        optBtn.BackgroundColor3 = Color3.fromRGB(19,19,22); optBtn.BorderSizePixel = 0
        optBtn.Size = UDim2.new(1, 0, 0, 26)
        optBtn.Font = Enum.Font.GothamMedium; optBtn.TextSize = 13
        optBtn.TextColor3 = Color3.fromRGB(240,240,245); optBtn.Text = "  " .. opt
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.AutoButtonColor = false; optBtn.LayoutOrder = i; optBtn.ZIndex = 501
        optBtn.MouseButton1Click:Connect(function()
            Config[item.key] = opt; btnLbl.Text = opt
            listFrame.Visible = false
        end)
    end
    btn.MouseButton1Click:Connect(function()
        if not btn.Parent or not listFrame.Parent then return end
        local willOpen = not listFrame.Visible
        listFrame.Visible = false
        if not willOpen then return end
        listFrame.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 26 * #item.list)
        listFrame.Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 2)
        listFrame.Visible = true
    end)
    attachRMB(lbl, item.key, tItem(item.key, item.name))
    GUI.ItemVisuals[item.key] = function() btnLbl.Text = tostring(Config[item.key]) end
    return row
end

local function buildColorRow(parent, item)
    local row = Instance.new("Frame", parent)
    row.BackgroundTransparency = 1; row.Size = UDim2.new(1, 0, 0, 28)
    local swatch = Instance.new("Frame", row)
    swatch.BackgroundColor3 = getColor(item.key); swatch.BorderSizePixel = 0
    swatch.Position = UDim2.new(0, 0, 0.5, -8); swatch.Size = UDim2.new(0, 16, 0, 16)
    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 3)
    local lbl = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 24, 0, 0); lbl.Size = UDim2.new(1, -115, 1, 0)
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(240,240,245); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Text = tItem(item.key, item.name)
    addHelpIcon(row, item.key, 90)
    local btn = Instance.new("TextButton", row)
    btn.BackgroundColor3 = getColor("C_Accent"); btn.BorderSizePixel = 0
    btn.Position = UDim2.new(1, -60, 0.5, -11); btn.Size = UDim2.new(0, 60, 0, 22)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    btn.TextColor3 = Color3.new(0,0,0); btn.Text = t("picks"); btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function()
        ColorPicker.Open(item.key)
        task.spawn(function()
            while ColorPicker.frame and ColorPicker.frame.Parent do task.wait(0.1) end
            swatch.BackgroundColor3 = getColor(item.key)
        end)
    end)
    GUI.ItemVisuals[item.key] = function() swatch.BackgroundColor3 = getColor(item.key) end
    return row
end

local function buildConfigUI(parent)
    local wrap = Instance.new("Frame", parent)
    wrap.BackgroundTransparency = 1; wrap.Size = UDim2.new(1, 0, 0, 90)
    local nameBox = Instance.new("TextBox", wrap)
    nameBox.BackgroundColor3 = Color3.fromRGB(24,24,28); nameBox.BorderSizePixel = 0
    nameBox.Position = UDim2.new(0, 0, 0, 18); nameBox.Size = UDim2.new(1, 0, 0, 28)
    nameBox.Font = Enum.Font.GothamMedium; nameBox.TextSize = 13
    nameBox.TextColor3 = Color3.fromRGB(240,240,245)
    nameBox.PlaceholderText = "default"; nameBox.PlaceholderColor3 = Color3.fromRGB(130,130,140)
    nameBox.Text = ConfigSystem.CurrentName or "default"
    nameBox.ClearTextOnFocus = false; nameBox.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel", wrap)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 0, 0, 0); lbl.Size = UDim2.new(1, 0, 0, 14)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
    lbl.TextColor3 = Color3.fromRGB(130,130,140); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = t("cfg_name")
    local btnRow = Instance.new("Frame", wrap)
    btnRow.BackgroundTransparency = 1
    btnRow.Position = UDim2.new(0, 0, 0, 52); btnRow.Size = UDim2.new(1, 0, 0, 30)
    local saveBtn = Instance.new("TextButton", btnRow)
    saveBtn.BackgroundColor3 = getColor("C_Accent"); saveBtn.BorderSizePixel = 0
    saveBtn.Position = UDim2.new(0, 0, 0, 0); saveBtn.Size = UDim2.new(0.5, -3, 1, 0)
    saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 12
    saveBtn.TextColor3 = Color3.new(0,0,0); saveBtn.Text = t("cfg_save"); saveBtn.AutoButtonColor = false
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 5)
    local loadBtn = Instance.new("TextButton", btnRow)
    loadBtn.BackgroundColor3 = Color3.fromRGB(24,24,28); loadBtn.BorderSizePixel = 0
    loadBtn.Position = UDim2.new(0.5, 3, 0, 0); loadBtn.Size = UDim2.new(0.5, -3, 1, 0)
    loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 12
    loadBtn.TextColor3 = Color3.fromRGB(240,240,245); loadBtn.Text = t("cfg_load"); loadBtn.AutoButtonColor = false
    Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 5)
    saveBtn.MouseButton1Click:Connect(function()
        local nm = nameBox.Text ~= "" and nameBox.Text or "default"
        local ok = ConfigSystem.Save(nm)
        saveBtn.Text = ok and "OK!" or "FAIL"
        task.delay(1.5, function() saveBtn.Text = t("cfg_save") end)
    end)
    loadBtn.MouseButton1Click:Connect(function()
        local nm = nameBox.Text ~= "" and nameBox.Text or "default"
        local ok = ConfigSystem.Load(nm)
        loadBtn.Text = ok and "OK!" or "FAIL"
        task.delay(1.5, function() loadBtn.Text = t("cfg_load") end)
        if ok and GUI then
            for k in pairs(GUI.ItemVisuals) do pcall(GUI.ItemVisuals[k]) end
        end
    end)
    return wrap
end

local function buildBindsUI(parent)
    local wrap = Instance.new("Frame", parent)
    wrap.BackgroundTransparency = 1; wrap.Size = UDim2.new(1, 0, 0, 30)
    local lbl = Instance.new("TextLabel", wrap)
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(130,130,140); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = t("no_binds")
    return wrap
end

local ITEM_H = {toggle=26, slider=42, dropdown=46, color=28, configui=90, binds=30}
local function estimateCardHeight(section)
    local h = 18
    for _, it in ipairs(section.items) do h = h + (ITEM_H[it.type] or 26) + 6 end
    return h + 24
end
local function estimateColumnHeight(column)
    local total = 0
    for _, sec in ipairs(column) do total = total + estimateCardHeight(sec) + 10 end
    return total
end
local function buildCard(parent, section, order)
    local card = Instance.new("Frame", parent)
    card.BackgroundColor3 = Color3.fromRGB(19,19,22); card.BorderSizePixel = 0
    card.Size = UDim2.new(1, -12, 0, estimateCardHeight(section)); card.LayoutOrder = order
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local cs = Instance.new("UIStroke", card); cs.Color = Color3.fromRGB(30,30,34); cs.Thickness = 1
    local inner = Instance.new("Frame", card)
    inner.BackgroundTransparency = 1
    inner.Position = UDim2.new(0, 12, 0, 12); inner.Size = UDim2.new(1, -24, 1, -24)
    local il = Instance.new("UIListLayout", inner)
    il.SortOrder = Enum.SortOrder.LayoutOrder; il.Padding = UDim.new(0, 6)
    local title = Instance.new("TextLabel", inner)
    title.BackgroundTransparency = 1; title.Size = UDim2.new(1, 0, 0, 18)
    title.Font = Enum.Font.GothamBold; title.TextSize = 12
    title.TextColor3 = getColor("C_Accent"); title.TextXAlignment = Enum.TextXAlignment.Center
    title.Text = ". " .. t(section.titleKey) .. " ."; title.LayoutOrder = 0
    local orderIdx = 1
    for _, it in ipairs(section.items) do
        local row
        if it.type == "toggle" then row = buildToggle(inner, it)
        elseif it.type == "slider" then row = buildSlider(inner, it)
        elseif it.type == "dropdown" then row = buildDropdown(inner, it)
        elseif it.type == "color" then row = buildColorRow(inner, it)
        elseif it.type == "configui" then row = buildConfigUI(inner)
        elseif it.type == "binds" then row = buildBindsUI(inner) end
        if row then row.LayoutOrder = orderIdx; orderIdx = orderIdx + 1 end
    end
    return card
end

function GUI.RenderTab(tabId)
    if not GUI.ContentArea or not GUI.ContentArea.Parent then return end
    for _, c in ipairs(GUI.ContentArea:GetChildren()) do
        if c:IsA("Frame") then pcall(function() c:Destroy() end) end
    end
    if GUI.TabConnections then
        for _, c in ipairs(GUI.TabConnections) do pcall(function() c:Disconnect() end) end
    end
    GUI.TabConnections = {}
    GUI.ItemVisuals = {}
    local data = Layout[tabId]; if not data then return end
    local grid = Instance.new("Frame", GUI.ContentArea)
    grid.BackgroundTransparency = 1; grid.Size = UDim2.new(1, 0, 1, 0)
    local col1 = Instance.new("Frame", grid)
    col1.BackgroundTransparency = 1
    col1.Size = UDim2.new(0.5, -4, 0, 0); col1.AutomaticSize = Enum.AutomaticSize.Y
    local l1 = Instance.new("UIListLayout", col1)
    l1.SortOrder = Enum.SortOrder.LayoutOrder; l1.Padding = UDim.new(0, 10)
    local col2 = Instance.new("Frame", grid)
    col2.BackgroundTransparency = 1
    col2.Position = UDim2.new(0.5, 4, 0, 0); col2.Size = UDim2.new(0.5, -4, 0, 0)
    col2.AutomaticSize = Enum.AutomaticSize.Y
    local l2 = Instance.new("UIListLayout", col2)
    l2.SortOrder = Enum.SortOrder.LayoutOrder; l2.Padding = UDim.new(0, 10)
    if data.col1 then for i, sec in ipairs(data.col1) do buildCard(col1, sec, i) end end
    if data.col2 then for i, sec in ipairs(data.col2) do buildCard(col2, sec, i) end end
    local h1 = data.col1 and estimateColumnHeight(data.col1) or 0
    local h2 = data.col2 and estimateColumnHeight(data.col2) or 0
    GUI.ContentArea.CanvasSize = UDim2.new(0, 0, 0, math.max(h1, h2) + 24)
end
function GUI.RefreshTabLabels()
    for _, b in pairs(GUI.TabsButtons) do b.Label.Text = t(b.langKey) end
    GUI.RenderTab(Config.MENU_Tab)
end
function GUI.SwitchLang(lang)
    CurrentLang = lang
    for _, lb in pairs(GUI.LangButtons) do
        local active = lb.lang == lang
        lb.Button.BackgroundColor3 = active and getColor("C_Accent") or Color3.fromRGB(24,24,28)
        lb.Button.TextColor3 = active and Color3.new(0,0,0) or Color3.fromRGB(130,130,140)
    end
    GUI.RefreshTabLabels()
end
function GUI.SwitchTab(tabId)
    Config.MENU_Tab = tabId
    for _, b in pairs(GUI.TabsButtons) do
        if b.tabId == tabId then
            b.Label.TextColor3 = Color3.new(1,1,1)
            b.Icon.TextColor3 = getColor("C_Accent")
        else
            b.Label.TextColor3 = Color3.fromRGB(130,130,140)
            b.Icon.TextColor3 = Color3.fromRGB(80,80,90)
        end
    end
    GUI.RenderTab(tabId)
end

function GUI.Create()
    local W, H = 720, 500
    local headerH, footerH = 46, 32
    local main = Instance.new("Frame", UI)
    main.BackgroundColor3 = Color3.fromRGB(10,10,12); main.BorderSizePixel = 0
    main.Size = UDim2.new(0, W, 0, H); main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    main.Active = true; GUI.Frame = main
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local mStroke = Instance.new("UIStroke", main)
    mStroke.Color = Color3.fromRGB(30,30,34); mStroke.Thickness = 1
    local header = Instance.new("Frame", main)
    header.BackgroundTransparency = 1; header.Size = UDim2.new(1, 0, 0, headerH)
    local logo = Instance.new("TextLabel", header)
    logo.BackgroundTransparency = 1; logo.Position = UDim2.new(0, 18, 0, 0); logo.Size = UDim2.new(0, 22, 1, 0)
    logo.Font = Enum.Font.GothamBold; logo.TextSize = 18
    logo.TextColor3 = getColor("C_Accent"); logo.Text = "*"; logo.TextXAlignment = Enum.TextXAlignment.Left
    local brandLbl = Instance.new("TextLabel", header)
    brandLbl.BackgroundTransparency = 1; brandLbl.Position = UDim2.new(0, 42, 0, 0); brandLbl.Size = UDim2.new(0, 80, 1, 0)
    brandLbl.Font = Enum.Font.GothamBold; brandLbl.TextSize = 14
    brandLbl.TextColor3 = Color3.new(1,1,1); brandLbl.Text = BRAND
    brandLbl.TextXAlignment = Enum.TextXAlignment.Left
    local tabsFrame = Instance.new("Frame", header)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Position = UDim2.new(0, 130, 0, 0); tabsFrame.Size = UDim2.new(1, -140, 1, 0)
    local tl = Instance.new("UIListLayout", tabsFrame)
    tl.FillDirection = Enum.FillDirection.Horizontal; tl.SortOrder = Enum.SortOrder.LayoutOrder
    tl.Padding = UDim.new(0, 14); tl.VerticalAlignment = Enum.VerticalAlignment.Center
    for i, tab in ipairs(Tabs) do
        local tabBtn = Instance.new("TextButton", tabsFrame)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Size = UDim2.new(0, 100, 1, 0); tabBtn.Text = ""; tabBtn.AutoButtonColor = false
        tabBtn.LayoutOrder = i
        local icon = Instance.new("TextLabel", tabBtn)
        icon.BackgroundTransparency = 1; icon.Position = UDim2.new(0, 0, 0.5, -9)
        icon.Size = UDim2.new(0, 18, 0, 18)
        icon.Font = Enum.Font.GothamBold; icon.TextSize = 16
        icon.TextColor3 = i == 1 and getColor("C_Accent") or Color3.fromRGB(80,80,90)
        icon.Text = tab.icon; icon.TextXAlignment = Enum.TextXAlignment.Left
        local lbl = Instance.new("TextLabel", tabBtn)
        lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 22, 0, 0); lbl.Size = UDim2.new(1, -22, 1, 0)
        lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13
        lbl.TextColor3 = i == 1 and Color3.new(1,1,1) or Color3.fromRGB(130,130,140)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = t(tab.langKey)
        tabBtn.MouseButton1Click:Connect(function() GUI.SwitchTab(tab.id) end)
        GUI.TabsButtons[#GUI.TabsButtons+1] = {Button=tabBtn, Icon=icon, Label=lbl, tabId=tab.id, langKey=tab.langKey}
    end
    local div = Instance.new("Frame", main)
    div.BackgroundColor3 = Color3.fromRGB(30,30,34); div.BorderSizePixel = 0
    div.Position = UDim2.new(0, 0, 0, headerH); div.Size = UDim2.new(1, 0, 0, 1)
    local contentHolder = Instance.new("Frame", main)
    contentHolder.BackgroundTransparency = 1
    contentHolder.Position = UDim2.new(0, 0, 0, headerH + 1)
    contentHolder.Size = UDim2.new(1, 0, 1, -headerH - footerH - 1)
    local scroll = Instance.new("ScrollingFrame", contentHolder)
    scroll.BackgroundTransparency = 1
    scroll.Position = UDim2.new(0, 12, 0, 12); scroll.Size = UDim2.new(1, -24, 1, -24)
    scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = getColor("C_Accent"); scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    GUI.ContentArea = scroll
    local footer = Instance.new("Frame", main)
    footer.BackgroundTransparency = 1
    footer.Position = UDim2.new(0, 0, 1, -footerH); footer.Size = UDim2.new(1, 0, 0, footerH)
    local langLabel = Instance.new("TextLabel", footer)
    langLabel.BackgroundTransparency = 1; langLabel.Position = UDim2.new(0, 14, 0, 0)
    langLabel.Size = UDim2.new(0, 40, 1, 0)
    langLabel.Font = Enum.Font.GothamBold; langLabel.TextSize = 10
    langLabel.TextColor3 = Color3.fromRGB(130,130,140); langLabel.TextXAlignment = Enum.TextXAlignment.Left
    langLabel.Text = t("lang") .. ":"
    local langFrame = Instance.new("Frame", footer)
    langFrame.BackgroundTransparency = 1
    langFrame.Position = UDim2.new(0, 60, 0.5, -11); langFrame.Size = UDim2.new(0, 80, 0, 22)
    local ll = Instance.new("UIListLayout", langFrame)
    ll.FillDirection = Enum.FillDirection.Horizontal; ll.Padding = UDim.new(0, 4)
    ll.VerticalAlignment = Enum.VerticalAlignment.Center
    for _, code in ipairs({"en", "ru"}) do
        local btn = Instance.new("TextButton", langFrame)
        btn.BackgroundColor3 = code == CurrentLang and getColor("C_Accent") or Color3.fromRGB(24,24,28)
        btn.BorderSizePixel = 0; btn.Size = UDim2.new(0, 34, 0, 22)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
        btn.TextColor3 = code == CurrentLang and Color3.new(0,0,0) or Color3.fromRGB(130,130,140)
        btn.Text = code:upper(); btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function() GUI.SwitchLang(code) end)
        GUI.LangButtons[#GUI.LangButtons+1] = {Button=btn, lang=code}
    end
    local footerRight = Instance.new("TextLabel", footer)
    footerRight.BackgroundTransparency = 1
    footerRight.Position = UDim2.new(0, 0, 0, 0); footerRight.Size = UDim2.new(1, -14, 1, 0)
    footerRight.Font = Enum.Font.GothamMedium; footerRight.TextSize = 10
    footerRight.TextColor3 = Color3.fromRGB(130,130,140); footerRight.TextXAlignment = Enum.TextXAlignment.Right
    footerRight.Text = "by " .. BRAND .. "  v7.5"
    local function startDrag(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        GUI.Dragging = true
        local m = UserInputService:GetMouseLocation()
        GUI.DragOffset = m - Vector2.new(main.AbsolutePosition.X, main.AbsolutePosition.Y)
    end
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then GUI.Dragging = false end
    end
    header.InputBegan:Connect(startDrag); logo.InputBegan:Connect(startDrag); brandLbl.InputBegan:Connect(startDrag)
    UserInputService.InputEnded:Connect(endDrag)
    GUI.SwitchTab(Config.MENU_Tab)
end
function GUI.Step()
    if not GUI.Frame or not GUI.Frame.Parent then return end
    if GUI.Dragging then
        local m = UserInputService:GetMouseLocation()
        local p = m - GUI.DragOffset
        GUI.Frame.Position = UDim2.new(0, p.X, 0, p.Y)
    end
end

GUI.Create()

-- ============================================================
-- BIND INPUT
-- ============================================================
Conn.bindDown = UserInputService.InputBegan:Connect(function(input, gp)
    if Unloaded or gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.Home then return end
    for configKey, bind in pairs(Binds) do
        if bind.key == input.KeyCode then
            if bind.mode == "Hold" then
                if not HoldActive[configKey] then
                    HoldActive[configKey] = true
                    if type(Config[configKey]) == "boolean" then
                        Config[configKey] = true
                        if GUI then GUI.RefreshItemVisual(configKey) end
                    end
                end
            else triggerBind(configKey) end
        end
    end
end)
Conn.bindUp = UserInputService.InputEnded:Connect(function(input)
    if Unloaded then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for configKey, bind in pairs(Binds) do
        if bind.key == input.KeyCode and bind.mode == "Hold" then
            if HoldActive[configKey] then
                HoldActive[configKey] = false
                if type(Config[configKey]) == "boolean" then
                    Config[configKey] = false
                    if GUI then GUI.RefreshItemVisual(configKey) end
                end
            end
        end
    end
end)

-- ============================================================
-- MAIN LOOP
-- ============================================================
local lastFps = tick()
local fpsFrames, fps = 0, 0

Conn.render = RunService.RenderStepped:Connect(function(dt)
    if Unloaded then return end
    local ok, err = pcall(function()
        local cam = Workspace.CurrentCamera; if not cam then return end
        local screenSize = cam.ViewportSize
        local screenCenter = Vector2.new(screenSize.X/2, screenSize.Y/2)
        local now = tick()

        fpsFrames = fpsFrames + 1
        if now - lastFps >= 0.5 then
            fps = math.floor(fpsFrames / (now - lastFps))
            fpsFrames = 0; lastFps = now
        end

        if now - Cache.lastRefresh > Tuning.RefreshRate then
            Cache.lastRefresh = now
            pcall(Targets.refresh)
        end
        if now - Cache.lastDroneRefresh > Tuning.DroneRefreshRate then
            Cache.lastDroneRefresh = now
            pcall(scanDrones)
        end

        pcall(function() ESP.Step(cam, screenSize, screenCenter) end)
        pcall(function() DroneESP.Step(cam, screenSize, screenCenter) end)
        pcall(function() UpdateRadar(cam) end)
        pcall(speedStep)
        pcall(function() freecamTick(dt) end)
        pcall(GUI.Step)

        WMStroke.Color = getColor("C_Accent")
        WMBrand.TextColor3 = getColor("C_Accent")
        RStroke.Color = getColor("C_RadarBorder")
        RadarCenter.BackgroundColor3 = getColor("C_RadarYou")
        RadarFrame.BackgroundColor3 = getColor("C_RadarBg")

        if Config.AIM_Enabled and Config.AIM_ShowFOV then
            local gi = GuiService:GetGuiInset()
            FOVCircle.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y + gi.Y)
            FOVCircle.Size = UDim2.new(0, Config.AIM_FOV*2, 0, Config.AIM_FOV*2)
            FOVS.Color = (Aim.aiming and Aim.locked) and getColor("C_FOVActive") or getColor("C_FOVCircle")
            FOVCircle.Visible = true
        else FOVCircle.Visible = false end

        if Config.UI_Watermark then
            WM.Visible = true
            local myRoleName = Cache.myRole and Cache.myRole.Name or "?"
            local myTeamCount = 0
            for _, e in pairs(Cache.playerRoles) do
                if e.isMyTeam then myTeamCount = myTeamCount + 1 end
            end
            local bindCount = 0
            for _ in pairs(Binds) do bindCount = bindCount + 1 end
            WmInfo.Text = string.format("%d fps | esp %d/%d | drones %d/%d | role %s | team %d | binds %d",
                fps, Cache.drawn, Cache.count, Cache.droneDrawn, Cache.droneCount,
                myRoleName, myTeamCount, bindCount)
        else WM.Visible = false end
    end)
    if not ok then warn("[MORTY]", err) end
end)

Conn.input = UserInputService.InputBegan:Connect(function(i, gp)
    if Unloaded then return end
    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if i.KeyCode == Enum.KeyCode.Insert and not gp then
        GUI.Frame.Visible = not GUI.Frame.Visible
        if not GUI.Frame.Visible then
            pcall(ColorPicker.Close)
            pcall(BindEditor.Close)
            hideTooltip()
        end
    elseif i.KeyCode == Enum.KeyCode.Home then
        Unloaded = true
        for _, c in pairs(Conn) do pcall(function() c:Disconnect() end) end
        if GUI.TabConnections then
            for _, c in ipairs(GUI.TabConnections) do pcall(function() c:Disconnect() end) end
        end
        for _, e in pairs(ESP.cache) do ESP.Destroy(e) end
        for _, e in pairs(DroneESP.cache) do DroneESP.Destroy(e) end
        pcall(ColorPicker.Close)
        pcall(BindEditor.Close)
        hideTooltip()
        pcall(function() UI:Destroy() end)
        pcall(function() ESPGui:Destroy() end)
        print("[MORTY] Выгружен (HOME)")
    end
end)

-- Автозагрузка конфига
task.spawn(function()
    task.wait(1)
    if isfile and isfile(ConfigSystem.GetPath("autosave")) then
        ConfigSystem.Load("autosave")
    end
end)

print("[MORTY] v7.5 loaded")
print("[MORTY] Insert = меню | Home = выгрузка | ПКМ = бинд | ? = описание")