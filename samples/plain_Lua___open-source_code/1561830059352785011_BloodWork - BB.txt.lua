repeat task.wait() until game:IsLoaded()

local IsSupported = true
if not setfflag or not hookmetamethod or not newcclosure or not islclosure or not getconnections or not debug.getupvalues or not checkcaller or not getgc or not setthreadidentity or not getthreadidentity then
    IsSupported = false
end

local NeverZen = {
    Version = '1.4'
};

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = cloneref(game:GetService("Players"))
local Stats = cloneref(game:GetService("Stats"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local TweenService = cloneref(game:GetService("TweenService"))
local CollectionService = cloneref(game:GetService("CollectionService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Workspace = cloneref(game:GetService("Workspace"))
local TextService = cloneref(game:GetService('TextService'));
local Debris = cloneref(game:GetService("Debris"))
local HttpService = cloneref(game:GetService("HttpService"))


local _PARRY_PATCH = {
    keyTable    = nil,
    transformFn = nil,
    netModule   = nil,
    remoteId    = nil,
    parryHash   = nil,
    parryRemote = nil,
    parryIndex  = 0.5,
    ready       = false,
    spoofing    = false,
}

do
    local ok_hook = pcall(function()
        local old_dinfo
        old_dinfo = hookfunction(getrenv().debug.info, function(f, t)
            if not _PARRY_PATCH.spoofing then
                return old_dinfo(f, t)
            end
            if type(f) == "function" then
                return "[C]"
            elseif f == 4 and t == "s" then
                return "ReplicatedStorage.Controllers.SwordsController "
            end
            return old_dinfo(f, t)
        end)
        local old_gfenv
        old_gfenv = hookfunction(getrenv().getfenv, function(l)
            if not _PARRY_PATCH.spoofing then
                return old_gfenv(l)
            end
            if l ~= nil and type(l) == "number" then
                if l >= 1 and l <= 10 then return old_gfenv(10) end
            end
            return old_gfenv(l)
        end)
    end)
    if not ok_hook then
        warn("[PARRY PATCH] bypass hooks failed to install")
    end
end

function _PARRY_PATCH.resolve()
    _PARRY_PATCH.spoofing = true
    local ok, err = pcall(function()
        local Controllers = ReplicatedStorage:WaitForChild("Controllers", 15)
        if not Controllers then return end

        local SC
        for _, child in ipairs(Controllers:GetChildren()) do
            if child.Name:sub(1, 16) == "SwordsController" then
                SC = child
                break
            end
        end
        if not SC then
            warn("[PARRY PATCH] SwordsController not found")
            return
        end

        local PRY = SC:WaitForChild("PRY", 15)
        if not PRY then
            warn("[PARRY PATCH] PRY module not found")
            return
        end

        local Parry_Function = require(PRY)
        local getupvals = debug.getupvalues or getupvalues
        if not getupvals then
            warn("[PARRY PATCH] executor missing getupvalues")
            return
        end

        local ups = getupvals(Parry_Function)
        if not ups or #ups < 8 then
            warn("[PARRY PATCH] unexpected upvalue count")
            return
        end

        _PARRY_PATCH.keyTable    = ups[3]
        _PARRY_PATCH.transformFn = ups[4]
        _PARRY_PATCH.netModule   = ups[6]
        _PARRY_PATCH.remoteId    = ups[7]
        _PARRY_PATCH.parryHash   = ups[8]

        local rok = pcall(function()
            _PARRY_PATCH.parryRemote = _PARRY_PATCH.netModule:RemoteEvent(_PARRY_PATCH.remoteId)
        end)
        if not rok or not _PARRY_PATCH.parryRemote then
            warn("[PARRY PATCH] remote resolution failed")
            return
        end

        _PARRY_PATCH.ready = true
    end)
    _PARRY_PATCH.spoofing = false
    if not ok then warn("[PARRY PATCH] init error:", tostring(err)) end
    return _PARRY_PATCH.ready
end

function _PARRY_PATCH.fire(curveCFrame, screenPositions, mouseLocation)
    if not _PARRY_PATCH.ready then return false end
    local kt = _PARRY_PATCH.keyTable
    if not kt then return false end
    local keyIndex = kt[3]
    local currentKey = kt[1] and kt[1][keyIndex]
    if not currentKey then return false end

    local tok, transformed = pcall(_PARRY_PATCH.transformFn, currentKey, "TIME")
    if not tok or not transformed then
        tok, transformed = pcall(_PARRY_PATCH.transformFn, currentKey)
        if not tok or not transformed then return false end
    end

    local serverTime = workspace:GetServerTimeNow() * 100
    local timeStr = tostring(math.floor(serverTime))
    local tc = {}
    for i = 1, #timeStr do
        local ki = (i - 1) % #transformed + 1
        local kb = string.byte(transformed, ki)
        local tb = (string.byte(timeStr, i) + i) % 256
        tc[i] = string.char(bit32.bxor(tb, kb))
    end
    local token = table.concat(tc)

    local fok = pcall(function()
        _PARRY_PATCH.parryRemote:FireServer(
            _PARRY_PATCH.parryHash,
            currentKey,
            token,
            _PARRY_PATCH.parryIndex or 0.5,
            curveCFrame,
            screenPositions,
            mouseLocation,
            false
        )
    end)
    return fok
end

local _AZURE_PF = nil
pcall(function()
    _AZURE_PF = function()
        pcall(function()
            local conns = getconnections(Players.LocalPlayer.PlayerGui.Hotbar.Block.Activated)
            if conns and conns[2] then conns[2]:Fire() end
        end)
    end
end)

local SETTINGS_FILE = "EryndorSetting.json"
local ApplyLoadedState
local function SaveSettings(data)
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if success then
        writefile(SETTINGS_FILE, encoded)
    else
        warn("Failed to save settings: " .. tostring(encoded))
    end
end

local function LoadSettings()
    if isfile(SETTINGS_FILE) then
        local content = readfile(SETTINGS_FILE)
        if content and content ~= "" then
            local success, decoded = pcall(function()
                return HttpService:JSONDecode(content)
            end)
            if success then
                return decoded
            else
                warn("Failed to decode settings: " .. tostring(decoded))
            end
        end
    end
    return nil
end

do
    local CurrentCamera = workspace.CurrentCamera;
    local LocalPlayer = Players.LocalPlayer;
    local Mouse = LocalPlayer:GetMouse();

    NeverZen.ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;
    NeverZen.MinimumTabSize = 535;

    NeverZen.Connections = {};
    NeverZen.Guis = {};
    NeverZen.Cleanups = {};

    function NeverZen:Track(conn)
        table.insert(NeverZen.Connections, conn);
        return conn;
    end;

    function NeverZen:IsMouseOverFrame(Frame)
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;
        if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
            return true;
        end;
    end;

    function NeverZen:NewInput(frame, call)
        local Bth = Instance.new('TextButton',frame);
        Bth.ZIndex = frame.ZIndex + 10;
        Bth.Size = UDim2.fromScale(1,1);
        Bth.BackgroundTransparency = 1;
        Bth.TextTransparency = 1;
        if call then
            Bth.MouseButton1Click:Connect(call)
        end
        return Bth;
    end;

    NeverZen.Lucide = {
        ["lucide-accessibility"] = "rbxassetid://10709751939",
        ["lucide-activity"] = "rbxassetid://10709752035",
        ["lucide-air-vent"] = "rbxassetid://10709752131",
        ["lucide-airplay"] = "rbxassetid://10709752254",
        ["lucide-alarm-check"] = "rbxassetid://10709752405",
        ["lucide-alarm-clock"] = "rbxassetid://10709752630",
        ["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
        ["lucide-alarm-minus"] = "rbxassetid://10709752732",
        ["lucide-alarm-plus"] = "rbxassetid://10709752825",
        ["lucide-album"] = "rbxassetid://10709752906",
        ["lucide-alert-circle"] = "rbxassetid://10709752996",
        ["lucide-alert-octagon"] = "rbxassetid://10709753064",
        ["lucide-alert-triangle"] = "rbxassetid://10709753149",
        ["lucide-align-center"] = "rbxassetid://10709753570",
        ["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
        ["lucide-align-center-vertical"] = "rbxassetid://10709753421",
        ["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
        ["lucide-align-end-vertical"] = "rbxassetid://10709753808",
        ["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
        ["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
        ["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
        ["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
        ["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
        ["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
        ["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
        ["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
        ["lucide-align-justify"] = "rbxassetid://10709759610",
        ["lucide-align-left"] = "rbxassetid://10709759764",
        ["lucide-align-right"] = "rbxassetid://10709759895",
        ["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
        ["lucide-align-start-vertical"] = "rbxassetid://10709760244",
        ["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
        ["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
        ["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
        ["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
        ["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
        ["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
        ["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
        ["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
        ["lucide-anchor"] = "rbxassetid://10709761530",
        ["lucide-angry"] = "rbxassetid://10709761629",
        ["lucide-annoyed"] = "rbxassetid://10709761722",
        ["lucide-aperture"] = "rbxassetid://10709761813",
        ["lucide-apple"] = "rbxassetid://10709761889",
        ["lucide-archive"] = "rbxassetid://10709762233",
        ["lucide-archive-restore"] = "rbxassetid://10709762058",
        ["lucide-armchair"] = "rbxassetid://10709762327",
        ["lucide-arrow-big-down"] = "rbxassetid://10747796644",
        ["lucide-arrow-big-left"] = "rbxassetid://10709762574",
        ["lucide-arrow-big-right"] = "rbxassetid://10709762727",
        ["lucide-arrow-big-up"] = "rbxassetid://10709762879",
        ["lucide-arrow-down"] = "rbxassetid://10709767827",
        ["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
        ["lucide-arrow-down-left"] = "rbxassetid://10709767656",
        ["lucide-arrow-down-right"] = "rbxassetid://10709767750",
        ["lucide-arrow-left"] = "rbxassetid://10709768114",
        ["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
        ["lucide-arrow-left-right"] = "rbxassetid://10709768019",
        ["lucide-arrow-right"] = "rbxassetid://10709768347",
        ["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
        ["lucide-arrow-up"] = "rbxassetid://10709768939",
        ["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
        ["lucide-arrow-up-down"] = "rbxassetid://10709768538",
        ["lucide-arrow-up-left"] = "rbxassetid://10709768661",
        ["lucide-arrow-up-right"] = "rbxassetid://10709768787",
        ["lucide-asterisk"] = "rbxassetid://10709769095",
        ["lucide-at-sign"] = "rbxassetid://10709769286",
        ["lucide-award"] = "rbxassetid://10709769406",
        ["lucide-axe"] = "rbxassetid://10709769508",
        ["lucide-axis-3d"] = "rbxassetid://10709769598",
        ["lucide-baby"] = "rbxassetid://10709769732",
        ["lucide-backpack"] = "rbxassetid://10709769841",
        ["lucide-baggage-claim"] = "rbxassetid://10709769935",
        ["lucide-banana"] = "rbxassetid://10709770005",
        ["lucide-banknote"] = "rbxassetid://10709770178",
        ["lucide-bar-chart"] = "rbxassetid://10709773755",
        ["lucide-bar-chart-2"] = "rbxassetid://10709770317",
        ["lucide-bar-chart-3"] = "rbxassetid://10709770431",
        ["lucide-bar-chart-4"] = "rbxassetid://10709770560",
        ["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
        ["lucide-barcode"] = "rbxassetid://10747360675",
        ["lucide-baseline"] = "rbxassetid://10709773863",
        ["lucide-bath"] = "rbxassetid://10709773963",
        ["lucide-battery"] = "rbxassetid://10709774640",
        ["lucide-battery-charging"] = "rbxassetid://10709774068",
        ["lucide-battery-full"] = "rbxassetid://10709774206",
        ["lucide-battery-low"] = "rbxassetid://10709774370",
        ["lucide-battery-medium"] = "rbxassetid://10709774513",
        ["lucide-beaker"] = "rbxassetid://10709774756",
        ["lucide-bed"] = "rbxassetid://10709775036",
        ["lucide-bed-double"] = "rbxassetid://10709774864",
        ["lucide-bed-single"] = "rbxassetid://10709774968",
        ["lucide-beer"] = "rbxassetid://10709775167",
        ["lucide-bell"] = "rbxassetid://10709775704",
        ["lucide-bell-minus"] = "rbxassetid://10709775241",
        ["lucide-bell-off"] = "rbxassetid://10709775320",
        ["lucide-bell-plus"] = "rbxassetid://10709775448",
        ["lucide-bell-ring"] = "rbxassetid://10709775560",
        ["lucide-bike"] = "rbxassetid://10709775894",
        ["lucide-binary"] = "rbxassetid://10709776050",
        ["lucide-bitcoin"] = "rbxassetid://10709776126",
        ["lucide-bluetooth"] = "rbxassetid://10709776655",
        ["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
        ["lucide-bluetooth-off"] = "rbxassetid://10709776344",
        ["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
        ["lucide-bold"] = "rbxassetid://10747813908",
        ["lucide-bomb"] = "rbxassetid://10709781460",
        ["lucide-bone"] = "rbxassetid://10709781605",
        ["lucide-book"] = "rbxassetid://10709781824",
        ["lucide-book-open"] = "rbxassetid://10709781717",
        ["lucide-bookmark"] = "rbxassetid://10709782154",
        ["lucide-bookmark-minus"] = "rbxassetid://10709781919",
        ["lucide-bookmark-plus"] = "rbxassetid://10709782044",
        ["lucide-bot"] = "rbxassetid://10709782230",
        ["lucide-box"] = "rbxassetid://10709782497",
        ["lucide-box-select"] = "rbxassetid://10709782342",
        ["lucide-boxes"] = "rbxassetid://10709782582",
        ["lucide-briefcase"] = "rbxassetid://10709782662",
        ["lucide-brush"] = "rbxassetid://10709782758",
        ["lucide-bug"] = "rbxassetid://10709782845",
        ["lucide-building"] = "rbxassetid://10709783051",
        ["lucide-building-2"] = "rbxassetid://10709782939",
        ["lucide-bus"] = "rbxassetid://10709783137",
        ["lucide-cake"] = "rbxassetid://10709783217",
        ["lucide-calculator"] = "rbxassetid://10709783311",
        ["lucide-calendar"] = "rbxassetid://10709789505",
        ["lucide-calendar-check"] = "rbxassetid://10709783474",
        ["lucide-calendar-check-2"] = "rbxassetid://10709783392",
        ["lucide-calendar-clock"] = "rbxassetid://10709783577",
        ["lucide-calendar-days"] = "rbxassetid://10709783673",
        ["lucide-calendar-heart"] = "rbxassetid://10709783835",
        ["lucide-calendar-minus"] = "rbxassetid://10709783959",
        ["lucide-calendar-off"] = "rbxassetid://10709788784",
        ["lucide-calendar-plus"] = "rbxassetid://10709788937",
        ["lucide-calendar-range"] = "rbxassetid://10709789053",
        ["lucide-calendar-search"] = "rbxassetid://10709789200",
        ["lucide-calendar-x"] = "rbxassetid://10709789407",
        ["lucide-calendar-x-2"] = "rbxassetid://10709789329",
        ["lucide-camera"] = "rbxassetid://10709789686",
        ["lucide-camera-off"] = "rbxassetid://10747822677",
        ["lucide-car"] = "rbxassetid://10709789810",
        ["lucide-carrot"] = "rbxassetid://10709789960",
        ["lucide-cast"] = "rbxassetid://10709790097",
        ["lucide-charge"] = "rbxassetid://10709790202",
        ["lucide-check"] = "rbxassetid://10709790644",
        ["lucide-check-circle"] = "rbxassetid://10709790387",
        ["lucide-check-circle-2"] = "rbxassetid://10709790298",
        ["lucide-check-square"] = "rbxassetid://10709790537",
        ["lucide-chef-hat"] = "rbxassetid://10709790757",
        ["lucide-cherry"] = "rbxassetid://10709790875",
        ["lucide-chevron-down"] = "rbxassetid://10709790948",
        ["lucide-chevron-first"] = "rbxassetid://10709791015",
        ["lucide-chevron-last"] = "rbxassetid://10709791130",
        ["lucide-chevron-left"] = "rbxassetid://10709791281",
        ["lucide-chevron-right"] = "rbxassetid://10709791437",
        ["lucide-chevron-up"] = "rbxassetid://10709791523",
        ["lucide-chevrons-down"] = "rbxassetid://10709796864",
        ["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
        ["lucide-chevrons-left"] = "rbxassetid://10709797151",
        ["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
        ["lucide-chevrons-right"] = "rbxassetid://10709797382",
        ["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
        ["lucide-chevrons-up"] = "rbxassetid://10709797622",
        ["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
        ["lucide-chrome"] = "rbxassetid://10709797725",
        ["lucide-circle"] = "rbxassetid://10709798174",
        ["lucide-circle-dot"] = "rbxassetid://10709797837",
        ["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
        ["lucide-circle-slashed"] = "rbxassetid://10709798100",
        ["lucide-citrus"] = "rbxassetid://10709798276",
        ["lucide-clapperboard"] = "rbxassetid://10709798350",
        ["lucide-clipboard"] = "rbxassetid://10709799288",
        ["lucide-clipboard-check"] = "rbxassetid://10709798443",
        ["lucide-clipboard-copy"] = "rbxassetid://10709798574",
        ["lucide-clipboard-edit"] = "rbxassetid://10709798682",
        ["lucide-clipboard-list"] = "rbxassetid://10709798792",
        ["lucide-clipboard-signature"] = "rbxassetid://10709798890",
        ["lucide-clipboard-type"] = "rbxassetid://10709798999",
        ["lucide-clipboard-x"] = "rbxassetid://10709799124",
        ["lucide-clock"] = "rbxassetid://10709805144",
        ["lucide-clock-1"] = "rbxassetid://10709799535",
        ["lucide-clock-10"] = "rbxassetid://10709799718",
        ["lucide-clock-11"] = "rbxassetid://10709799818",
        ["lucide-clock-12"] = "rbxassetid://10709799962",
        ["lucide-clock-2"] = "rbxassetid://10709803876",
        ["lucide-clock-3"] = "rbxassetid://10709803989",
        ["lucide-clock-4"] = "rbxassetid://10709804164",
        ["lucide-clock-5"] = "rbxassetid://10709804291",
        ["lucide-clock-6"] = "rbxassetid://10709804435",
        ["lucide-clock-7"] = "rbxassetid://10709804599",
        ["lucide-clock-8"] = "rbxassetid://10709804784",
        ["lucide-clock-9"] = "rbxassetid://10709804996",
        ["lucide-cloud"] = "rbxassetid://10709806740",
        ["lucide-cloud-cog"] = "rbxassetid://10709805262",
        ["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
        ["lucide-cloud-fog"] = "rbxassetid://10709805477",
        ["lucide-cloud-hail"] = "rbxassetid://10709805596",
        ["lucide-cloud-lightning"] = "rbxassetid://10709805727",
        ["lucide-cloud-moon"] = "rbxassetid://10709805942",
        ["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
        ["lucide-cloud-off"] = "rbxassetid://10709806060",
        ["lucide-cloud-rain"] = "rbxassetid://10709806277",
        ["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
        ["lucide-cloud-snow"] = "rbxassetid://10709806374",
        ["lucide-cloud-sun"] = "rbxassetid://10709806631",
        ["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
        ["lucide-cloudy"] = "rbxassetid://10709806859",
        ["lucide-clover"] = "rbxassetid://10709806995",
        ["lucide-code"] = "rbxassetid://10709810463",
        ["lucide-code-2"] = "rbxassetid://10709807111",
        ["lucide-codepen"] = "rbxassetid://10709810534",
        ["lucide-codesandbox"] = "rbxassetid://10709810676",
        ["lucide-coffee"] = "rbxassetid://10709810814",
        ["lucide-cog"] = "rbxassetid://10709810948",
        ["lucide-coins"] = "rbxassetid://10709811110",
        ["lucide-columns"] = "rbxassetid://10709811261",
        ["lucide-command"] = "rbxassetid://10709811365",
        ["lucide-compass"] = "rbxassetid://10709811445",
        ["lucide-component"] = "rbxassetid://10709811595",
        ["lucide-concierge-bell"] = "rbxassetid://10709811706",
        ["lucide-connection"] = "rbxassetid://10747361219",
        ["lucide-contact"] = "rbxassetid://10709811834",
        ["lucide-contrast"] = "rbxassetid://10709811939",
        ["lucide-cookie"] = "rbxassetid://10709812067",
        ["lucide-copy"] = "rbxassetid://10709812159",
        ["lucide-copyleft"] = "rbxassetid://10709812251",
        ["lucide-copyright"] = "rbxassetid://10709812311",
        ["lucide-corner-down-left"] = "rbxassetid://10709812396",
        ["lucide-corner-down-right"] = "rbxassetid://10709812485",
        ["lucide-corner-left-down"] = "rbxassetid://10709812632",
        ["lucide-corner-left-up"] = "rbxassetid://10709812784",
        ["lucide-corner-right-down"] = "rbxassetid://10709812939",
        ["lucide-corner-right-up"] = "rbxassetid://10709813094",
        ["lucide-corner-up-left"] = "rbxassetid://10709813185",
        ["lucide-corner-up-right"] = "rbxassetid://10709813281",
        ["lucide-cpu"] = "rbxassetid://10709813383",
        ["lucide-croissant"] = "rbxassetid://10709818125",
        ["lucide-crop"] = "rbxassetid://10709818245",
        ["lucide-cross"] = "rbxassetid://10709818399",
        ["lucide-crosshair"] = "rbxassetid://10709818534",
        ["lucide-crown"] = "rbxassetid://10709818626",
        ["lucide-cup-soda"] = "rbxassetid://10709818763",
        ["lucide-curly-braces"] = "rbxassetid://10709818847",
        ["lucide-currency"] = "rbxassetid://10709818931",
        ["lucide-database"] = "rbxassetid://10709818996",
        ["lucide-delete"] = "rbxassetid://10709819059",
        ["lucide-diamond"] = "rbxassetid://10709819149",
        ["lucide-dice-1"] = "rbxassetid://10709819266",
        ["lucide-dice-2"] = "rbxassetid://10709819361",
        ["lucide-dice-3"] = "rbxassetid://10709819508",
        ["lucide-dice-4"] = "rbxassetid://10709819670",
        ["lucide-dice-5"] = "rbxassetid://10709819801",
        ["lucide-dice-6"] = "rbxassetid://10709819896",
        ["lucide-dices"] = "rbxassetid://10723343321",
        ["lucide-diff"] = "rbxassetid://10723343416",
        ["lucide-disc"] = "rbxassetid://10723343537",
        ["lucide-divide"] = "rbxassetid://10723343805",
        ["lucide-divide-circle"] = "rbxassetid://10723343636",
        ["lucide-divide-square"] = "rbxassetid://10723343737",
        ["lucide-dollar-sign"] = "rbxassetid://10723343958",
        ["lucide-download"] = "rbxassetid://10723344270",
        ["lucide-download-cloud"] = "rbxassetid://10723344088",
        ["lucide-droplet"] = "rbxassetid://10723344432",
        ["lucide-droplets"] = "rbxassetid://10734883356",
        ["lucide-drumstick"] = "rbxassetid://10723344737",
        ["lucide-edit"] = "rbxassetid://10734883598",
        ["lucide-edit-2"] = "rbxassetid://10723344885",
        ["lucide-edit-3"] = "rbxassetid://10723345088",
        ["lucide-egg"] = "rbxassetid://10723345518",
        ["lucide-egg-fried"] = "rbxassetid://10723345347",
        ["lucide-electricity"] = "rbxassetid://10723345749",
        ["lucide-electricity-off"] = "rbxassetid://10723345643",
        ["lucide-equal"] = "rbxassetid://10723345990",
        ["lucide-equal-not"] = "rbxassetid://10723345866",
        ["lucide-eraser"] = "rbxassetid://10723346158",
        ["lucide-euro"] = "rbxassetid://10723346372",
        ["lucide-expand"] = "rbxassetid://10723346553",
        ["lucide-external-link"] = "rbxassetid://10723346684",
        ["lucide-eye"] = "rbxassetid://10723346959",
        ["lucide-eye-off"] = "rbxassetid://10723346871",
        ["lucide-factory"] = "rbxassetid://10723347051",
        ["lucide-fan"] = "rbxassetid://10723354359",
        ["lucide-fast-forward"] = "rbxassetid://10723354521",
        ["lucide-feather"] = "rbxassetid://10723354671",
        ["lucide-figma"] = "rbxassetid://10723354801",
        ["lucide-file"] = "rbxassetid://10723374641",
        ["lucide-file-archive"] = "rbxassetid://10723354921",
        ["lucide-file-audio"] = "rbxassetid://10723355148",
        ["lucide-file-audio-2"] = "rbxassetid://10723355026",
        ["lucide-file-axis-3d"] = "rbxassetid://10723355272",
        ["lucide-file-badge"] = "rbxassetid://10723355622",
        ["lucide-file-badge-2"] = "rbxassetid://10723355451",
        ["lucide-file-bar-chart"] = "rbxassetid://10723355887",
        ["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
        ["lucide-file-box"] = "rbxassetid://10723355989",
        ["lucide-file-check"] = "rbxassetid://10723356210",
        ["lucide-file-check-2"] = "rbxassetid://10723356100",
        ["lucide-file-clock"] = "rbxassetid://10723356329",
        ["lucide-file-code"] = "rbxassetid://10723356507",
        ["lucide-file-cog"] = "rbxassetid://10723356830",
        ["lucide-file-cog-2"] = "rbxassetid://10723356676",
        ["lucide-file-diff"] = "rbxassetid://10723357039",
        ["lucide-file-digit"] = "rbxassetid://10723357151",
        ["lucide-file-down"] = "rbxassetid://10723357322",
        ["lucide-file-edit"] = "rbxassetid://10723357495",
        ["lucide-file-heart"] = "rbxassetid://10723357637",
        ["lucide-file-image"] = "rbxassetid://10723357790",
        ["lucide-file-input"] = "rbxassetid://10723357933",
        ["lucide-file-json"] = "rbxassetid://10723364435",
        ["lucide-file-json-2"] = "rbxassetid://10723364361",
        ["lucide-file-key"] = "rbxassetid://10723364605",
        ["lucide-file-key-2"] = "rbxassetid://10723364515",
        ["lucide-file-line-chart"] = "rbxassetid://10723364725",
        ["lucide-file-lock"] = "rbxassetid://10723364957",
        ["lucide-file-lock-2"] = "rbxassetid://10723364861",
        ["lucide-file-minus"] = "rbxassetid://10723365254",
        ["lucide-file-minus-2"] = "rbxassetid://10723365086",
        ["lucide-file-output"] = "rbxassetid://10723365457",
        ["lucide-file-pie-chart"] = "rbxassetid://10723365598",
        ["lucide-file-plus"] = "rbxassetid://10723365877",
        ["lucide-file-plus-2"] = "rbxassetid://10723365766",
        ["lucide-file-question"] = "rbxassetid://10723365987",
        ["lucide-file-scan"] = "rbxassetid://10723366167",
        ["lucide-file-search"] = "rbxassetid://10723366550",
        ["lucide-file-search-2"] = "rbxassetid://10723366340",
        ["lucide-file-signature"] = "rbxassetid://10723366741",
        ["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
        ["lucide-file-symlink"] = "rbxassetid://10723367098",
        ["lucide-file-terminal"] = "rbxassetid://10723367244",
        ["lucide-file-text"] = "rbxassetid://10723367380",
        ["lucide-file-type"] = "rbxassetid://10723367606",
        ["lucide-file-type-2"] = "rbxassetid://10723367509",
        ["lucide-file-up"] = "rbxassetid://10723367734",
        ["lucide-file-video"] = "rbxassetid://10723373884",
        ["lucide-file-video-2"] = "rbxassetid://10723367834",
        ["lucide-file-volume"] = "rbxassetid://10723374172",
        ["lucide-file-volume-2"] = "rbxassetid://10723374030",
        ["lucide-file-warning"] = "rbxassetid://10723374276",
        ["lucide-file-x"] = "rbxassetid://10723374544",
        ["lucide-file-x-2"] = "rbxassetid://10723374378",
        ["lucide-files"] = "rbxassetid://10723374759",
        ["lucide-film"] = "rbxassetid://10723374981",
        ["lucide-filter"] = "rbxassetid://10723375128",
        ["lucide-fingerprint"] = "rbxassetid://10723375250",
        ["lucide-flag"] = "rbxassetid://10723375890",
        ["lucide-flag-off"] = "rbxassetid://10723375443",
        ["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
        ["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
        ["lucide-flame"] = "rbxassetid://10723376114",
        ["lucide-flashlight"] = "rbxassetid://10723376471",
        ["lucide-flashlight-off"] = "rbxassetid://10723376365",
        ["lucide-flask-conical"] = "rbxassetid://10734883986",
        ["lucide-flask-round"] = "rbxassetid://10723376614",
        ["lucide-flip-horizontal"] = "rbxassetid://10723376884",
        ["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
        ["lucide-flip-vertical"] = "rbxassetid://10723377138",
        ["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
        ["lucide-flower"] = "rbxassetid://10747830374",
        ["lucide-flower-2"] = "rbxassetid://10723377305",
        ["lucide-focus"] = "rbxassetid://10723377537",
        ["lucide-folder"] = "rbxassetid://10723387563",
        ["lucide-folder-archive"] = "rbxassetid://10723384478",
        ["lucide-folder-check"] = "rbxassetid://10723384605",
        ["lucide-folder-clock"] = "rbxassetid://10723384731",
        ["lucide-folder-closed"] = "rbxassetid://10723384893",
        ["lucide-folder-cog"] = "rbxassetid://10723385213",
        ["lucide-folder-cog-2"] = "rbxassetid://10723385036",
        ["lucide-folder-down"] = "rbxassetid://10723385338",
        ["lucide-folder-edit"] = "rbxassetid://10723385445",
        ["lucide-folder-heart"] = "rbxassetid://10723385545",
        ["lucide-folder-input"] = "rbxassetid://10723385721",
        ["lucide-folder-key"] = "rbxassetid://10723385848",
        ["lucide-folder-lock"] = "rbxassetid://10723386005",
        ["lucide-folder-minus"] = "rbxassetid://10723386127",
        ["lucide-folder-open"] = "rbxassetid://10723386277",
        ["lucide-folder-output"] = "rbxassetid://10723386386",
        ["lucide-folder-plus"] = "rbxassetid://10723386531",
        ["lucide-folder-search"] = "rbxassetid://10723386787",
        ["lucide-folder-search-2"] = "rbxassetid://10723386674",
        ["lucide-folder-symlink"] = "rbxassetid://10723386930",
        ["lucide-folder-tree"] = "rbxassetid://10723387085",
        ["lucide-folder-up"] = "rbxassetid://10723387265",
        ["lucide-folder-x"] = "rbxassetid://10723387448",
        ["lucide-folders"] = "rbxassetid://10723387721",
        ["lucide-form-input"] = "rbxassetid://10723387841",
        ["lucide-forward"] = "rbxassetid://10723388016",
        ["lucide-frame"] = "rbxassetid://10723394389",
        ["lucide-framer"] = "rbxassetid://10723394565",
        ["lucide-frown"] = "rbxassetid://10723394681",
        ["lucide-fuel"] = "rbxassetid://10723394846",
        ["lucide-function-square"] = "rbxassetid://10723395041",
        ["lucide-gamepad"] = "rbxassetid://10723395457",
        ["lucide-gamepad-2"] = "rbxassetid://10723395215",
        ["lucide-gauge"] = "rbxassetid://10723395708",
        ["lucide-gavel"] = "rbxassetid://10723395896",
        ["lucide-gem"] = "rbxassetid://10723396000",
        ["lucide-ghost"] = "rbxassetid://10723396107",
        ["lucide-gift"] = "rbxassetid://10723396402",
        ["lucide-gift-card"] = "rbxassetid://10723396225",
        ["lucide-git-branch"] = "rbxassetid://10723396676",
        ["lucide-git-branch-plus"] = "rbxassetid://10723396542",
        ["lucide-git-commit"] = "rbxassetid://10723396812",
        ["lucide-git-compare"] = "rbxassetid://10723396954",
        ["lucide-git-fork"] = "rbxassetid://10723397049",
        ["lucide-git-merge"] = "rbxassetid://10723397165",
        ["lucide-git-pull-request"] = "rbxassetid://10723397431",
        ["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
        ["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
        ["lucide-glass"] = "rbxassetid://10723397788",
        ["lucide-glass-2"] = "rbxassetid://10723397529",
        ["lucide-glass-water"] = "rbxassetid://10723397678",
        ["lucide-glasses"] = "rbxassetid://10723397895",
        ["lucide-globe"] = "rbxassetid://10723404337",
        ["lucide-globe-2"] = "rbxassetid://10723398002",
        ["lucide-grab"] = "rbxassetid://10723404472",
        ["lucide-graduation-cap"] = "rbxassetid://10723404691",
        ["lucide-grape"] = "rbxassetid://10723404822",
        ["lucide-grid"] = "rbxassetid://10723404936",
        ["lucide-grip-horizontal"] = "rbxassetid://10723405089",
        ["lucide-grip-vertical"] = "rbxassetid://10723405236",
        ["lucide-hammer"] = "rbxassetid://10723405360",
        ["lucide-hand"] = "rbxassetid://10723405649",
        ["lucide-hand-metal"] = "rbxassetid://10723405508",
        ["lucide-hard-drive"] = "rbxassetid://10723405749",
        ["lucide-hard-hat"] = "rbxassetid://10723405859",
        ["lucide-hash"] = "rbxassetid://10723405975",
        ["lucide-haze"] = "rbxassetid://10723406078",
        ["lucide-headphones"] = "rbxassetid://10723406165",
        ["lucide-heart"] = "rbxassetid://10723406885",
        ["lucide-heart-crack"] = "rbxassetid://10723406299",
        ["lucide-heart-handshake"] = "rbxassetid://10723406480",
        ["lucide-heart-off"] = "rbxassetid://10723406662",
        ["lucide-heart-pulse"] = "rbxassetid://10723406795",
        ["lucide-help-circle"] = "rbxassetid://10723406988",
        ["lucide-hexagon"] = "rbxassetid://10723407092",
        ["lucide-highlighter"] = "rbxassetid://10723407192",
        ["lucide-history"] = "rbxassetid://10723407335",
        ["lucide-home"] = "rbxassetid://10723407389",
        ["lucide-hourglass"] = "rbxassetid://10723407498",
        ["lucide-ice-cream"] = "rbxassetid://10723414308",
        ["lucide-image"] = "rbxassetid://10723415040",
        ["lucide-image-minus"] = "rbxassetid://10723414487",
        ["lucide-image-off"] = "rbxassetid://10723414677",
        ["lucide-image-plus"] = "rbxassetid://10723414827",
        ["lucide-import"] = "rbxassetid://10723415205",
        ["lucide-inbox"] = "rbxassetid://10723415335",
        ["lucide-indent"] = "rbxassetid://10723415494",
        ["lucide-indian-rupee"] = "rbxassetid://10723415642",
        ["lucide-infinity"] = "rbxassetid://10723415766",
        ["lucide-info"] = "rbxassetid://10723415903",
        ["lucide-inspect"] = "rbxassetid://10723416057",
        ["lucide-italic"] = "rbxassetid://10723416195",
        ["lucide-japanese-yen"] = "rbxassetid://10723416363",
        ["lucide-joystick"] = "rbxassetid://10723416527",
        ["lucide-key"] = "rbxassetid://10723416652",
        ["lucide-keyboard"] = "rbxassetid://10723416765",
        ["lucide-lamp"] = "rbxassetid://10723417513",
        ["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
        ["lucide-lamp-desk"] = "rbxassetid://10723417016",
        ["lucide-lamp-floor"] = "rbxassetid://10723417131",
        ["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
        ["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
        ["lucide-landmark"] = "rbxassetid://10723417608",
        ["lucide-languages"] = "rbxassetid://10723417703",
        ["lucide-laptop"] = "rbxassetid://10723423881",
        ["lucide-laptop-2"] = "rbxassetid://10723417797",
        ["lucide-lasso"] = "rbxassetid://10723424235",
        ["lucide-lasso-select"] = "rbxassetid://10723424058",
        ["lucide-laugh"] = "rbxassetid://10723424372",
        ["lucide-layers"] = "rbxassetid://10723424505",
        ["lucide-layout"] = "rbxassetid://10723425376",
        ["lucide-layout-dashboard"] = "rbxassetid://10723424646",
        ["lucide-layout-grid"] = "rbxassetid://10723424838",
        ["lucide-layout-list"] = "rbxassetid://10723424963",
        ["lucide-layout-template"] = "rbxassetid://10723425187",
        ["lucide-leaf"] = "rbxassetid://10723425539",
        ["lucide-library"] = "rbxassetid://10723425615",
        ["lucide-life-buoy"] = "rbxassetid://10723425685",
        ["lucide-lightbulb"] = "rbxassetid://10723425852",
        ["lucide-lightbulb-off"] = "rbxassetid://10723425762",
        ["lucide-line-chart"] = "rbxassetid://10723426393",
        ["lucide-link"] = "rbxassetid://10723426722",
        ["lucide-link-2"] = "rbxassetid://10723426595",
        ["lucide-link-2-off"] = "rbxassetid://10723426513",
        ["lucide-list"] = "rbxassetid://10723433811",
        ["lucide-list-checks"] = "rbxassetid://10734884548",
        ["lucide-list-end"] = "rbxassetid://10723426886",
        ["lucide-list-minus"] = "rbxassetid://10723426986",
        ["lucide-list-music"] = "rbxassetid://10723427081",
        ["lucide-list-ordered"] = "rbxassetid://10723427199",
        ["lucide-list-plus"] = "rbxassetid://10723427334",
        ["lucide-list-start"] = "rbxassetid://10723427494",
        ["lucide-list-video"] = "rbxassetid://10723427619",
        ["lucide-list-x"] = "rbxassetid://10723433655",
        ["lucide-loader"] = "rbxassetid://10723434070",
        ["lucide-loader-2"] = "rbxassetid://10723433935",
        ["lucide-locate"] = "rbxassetid://10723434557",
        ["lucide-locate-fixed"] = "rbxassetid://10723434236",
        ["lucide-locate-off"] = "rbxassetid://10723434379",
        ["lucide-lock"] = "rbxassetid://10723434711",
        ["lucide-log-in"] = "rbxassetid://10723434830",
        ["lucide-log-out"] = "rbxassetid://10723434906",
        ["lucide-luggage"] = "rbxassetid://10723434993",
        ["lucide-magnet"] = "rbxassetid://10723435069",
        ["lucide-mail"] = "rbxassetid://10734885430",
        ["lucide-mail-check"] = "rbxassetid://10723435182",
        ["lucide-mail-minus"] = "rbxassetid://10723435261",
        ["lucide-mail-open"] = "rbxassetid://10723435342",
        ["lucide-mail-plus"] = "rbxassetid://10723435443",
        ["lucide-mail-question"] = "rbxassetid://10723435515",
        ["lucide-mail-search"] = "rbxassetid://10734884739",
        ["lucide-mail-warning"] = "rbxassetid://10734885015",
        ["lucide-mail-x"] = "rbxassetid://10734885247",
        ["lucide-mails"] = "rbxassetid://10734885614",
        ["lucide-map"] = "rbxassetid://10734886202",
        ["lucide-map-pin"] = "rbxassetid://10734886004",
        ["lucide-map-pin-off"] = "rbxassetid://10734885803",
        ["lucide-maximize"] = "rbxassetid://10734886735",
        ["lucide-maximize-2"] = "rbxassetid://10734886496",
        ["lucide-medal"] = "rbxassetid://10734887072",
        ["lucide-megaphone"] = "rbxassetid://10734887454",
        ["lucide-megaphone-off"] = "rbxassetid://10734887311",
        ["lucide-meh"] = "rbxassetid://10734887603",
        ["lucide-menu"] = "rbxassetid://10734887784",
        ["lucide-message-circle"] = "rbxassetid://10734888000",
        ["lucide-message-square"] = "rbxassetid://10734888228",
        ["lucide-mic"] = "rbxassetid://10734888864",
        ["lucide-mic-2"] = "rbxassetid://10734888430",
        ["lucide-mic-off"] = "rbxassetid://10734888646",
        ["lucide-microscope"] = "rbxassetid://10734889106",
        ["lucide-microwave"] = "rbxassetid://10734895076",
        ["lucide-milestone"] = "rbxassetid://10734895310",
        ["lucide-minimize"] = "rbxassetid://10734895698",
        ["lucide-minimize-2"] = "rbxassetid://10734895530",
        ["lucide-minus"] = "rbxassetid://10734896206",
        ["lucide-minus-circle"] = "rbxassetid://10734895856",
        ["lucide-minus-square"] = "rbxassetid://10734896029",
        ["lucide-monitor"] = "rbxassetid://10734896881",
        ["lucide-monitor-off"] = "rbxassetid://10734896360",
        ["lucide-monitor-speaker"] = "rbxassetid://10734896512",
        ["lucide-moon"] = "rbxassetid://10734897102",
        ["lucide-more-horizontal"] = "rbxassetid://10734897250",
        ["lucide-more-vertical"] = "rbxassetid://10734897387",
        ["lucide-mountain"] = "rbxassetid://10734897956",
        ["lucide-mountain-snow"] = "rbxassetid://10734897665",
        ["lucide-mouse"] = "rbxassetid://10734898592",
        ["lucide-mouse-pointer"] = "rbxassetid://10734898476",
        ["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
        ["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
        ["lucide-move"] = "rbxassetid://10734900011",
        ["lucide-move-3d"] = "rbxassetid://10734898756",
        ["lucide-move-diagonal"] = "rbxassetid://10734899164",
        ["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
        ["lucide-move-horizontal"] = "rbxassetid://10734899414",
        ["lucide-move-vertical"] = "rbxassetid://10734899821",
        ["lucide-music"] = "rbxassetid://10734905958",
        ["lucide-music-2"] = "rbxassetid://10734900215",
        ["lucide-music-3"] = "rbxassetid://10734905665",
        ["lucide-music-4"] = "rbxassetid://10734905823",
        ["lucide-navigation"] = "rbxassetid://10734906744",
        ["lucide-navigation-2"] = "rbxassetid://10734906332",
        ["lucide-navigation-2-off"] = "rbxassetid://10734906144",
        ["lucide-navigation-off"] = "rbxassetid://10734906580",
        ["lucide-network"] = "rbxassetid://10734906975",
        ["lucide-newspaper"] = "rbxassetid://10734907168",
        ["lucide-octagon"] = "rbxassetid://10734907361",
        ["lucide-option"] = "rbxassetid://10734907649",
        ["lucide-outdent"] = "rbxassetid://10734907933",
        ["lucide-package"] = "rbxassetid://10734909540",
        ["lucide-package-2"] = "rbxassetid://10734908151",
        ["lucide-package-check"] = "rbxassetid://10734908384",
        ["lucide-package-minus"] = "rbxassetid://10734908626",
        ["lucide-package-open"] = "rbxassetid://10734908793",
        ["lucide-package-plus"] = "rbxassetid://10734909016",
        ["lucide-package-search"] = "rbxassetid://10734909196",
        ["lucide-package-x"] = "rbxassetid://10734909375",
        ["lucide-paint-bucket"] = "rbxassetid://10734909847",
        ["lucide-paintbrush"] = "rbxassetid://10734910187",
        ["lucide-paintbrush-2"] = "rbxassetid://10734910030",
        ["lucide-palette"] = "rbxassetid://10734910430",
        ["lucide-palmtree"] = "rbxassetid://10734910680",
        ["lucide-paperclip"] = "rbxassetid://10734910927",
        ["lucide-party-popper"] = "rbxassetid://10734918735",
        ["lucide-pause"] = "rbxassetid://10734919336",
        ["lucide-pause-circle"] = "rbxassetid://10735024209",
        ["lucide-pause-octagon"] = "rbxassetid://10734919143",
        ["lucide-pen-tool"] = "rbxassetid://10734919503",
        ["lucide-pencil"] = "rbxassetid://10734919691",
        ["lucide-percent"] = "rbxassetid://10734919919",
        ["lucide-person-standing"] = "rbxassetid://10734920149",
        ["lucide-phone"] = "rbxassetid://10734921524",
        ["lucide-phone-call"] = "rbxassetid://10734920305",
        ["lucide-phone-forwarded"] = "rbxassetid://10734920508",
        ["lucide-phone-incoming"] = "rbxassetid://10734920694",
        ["lucide-phone-missed"] = "rbxassetid://10734920845",
        ["lucide-phone-off"] = "rbxassetid://10734921077",
        ["lucide-phone-outgoing"] = "rbxassetid://10734921288",
        ["lucide-pie-chart"] = "rbxassetid://10734921727",
        ["lucide-piggy-bank"] = "rbxassetid://10734921935",
        ["lucide-pin"] = "rbxassetid://10734922324",
        ["lucide-pin-off"] = "rbxassetid://10734922180",
        ["lucide-pipette"] = "rbxassetid://10734922497",
        ["lucide-pizza"] = "rbxassetid://10734922774",
        ["lucide-plane"] = "rbxassetid://10734922971",
        ["lucide-play"] = "rbxassetid://10734923549",
        ["lucide-play-circle"] = "rbxassetid://10734923214",
        ["lucide-plus"] = "rbxassetid://10734924532",
        ["lucide-plus-circle"] = "rbxassetid://10734923868",
        ["lucide-plus-square"] = "rbxassetid://10734924219",
        ["lucide-podcast"] = "rbxassetid://10734929553",
        ["lucide-pointer"] = "rbxassetid://10734929723",
        ["lucide-pound-sterling"] = "rbxassetid://10734929981",
        ["lucide-power"] = "rbxassetid://10734930466",
        ["lucide-power-off"] = "rbxassetid://10734930257",
        ["lucide-printer"] = "rbxassetid://10734930632",
        ["lucide-puzzle"] = "rbxassetid://10734930886",
        ["lucide-quote"] = "rbxassetid://10734931234",
        ["lucide-radio"] = "rbxassetid://10734931596",
        ["lucide-radio-receiver"] = "rbxassetid://10734931402",
        ["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
        ["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
        ["lucide-recycle"] = "rbxassetid://10734932295",
        ["lucide-redo"] = "rbxassetid://10734932822",
        ["lucide-redo-2"] = "rbxassetid://10734932586",
        ["lucide-refresh-ccw"] = "rbxassetid://10734933056",
        ["lucide-refresh-cw"] = "rbxassetid://10734933222",
        ["lucide-refrigerator"] = "rbxassetid://10734933465",
        ["lucide-regex"] = "rbxassetid://10734933655",
        ["lucide-repeat"] = "rbxassetid://10734933966",
        ["lucide-repeat-1"] = "rbxassetid://10734933826",
        ["lucide-reply"] = "rbxassetid://10734934252",
        ["lucide-reply-all"] = "rbxassetid://10734934132",
        ["lucide-rewind"] = "rbxassetid://10734934347",
        ["lucide-rocket"] = "rbxassetid://10734934585",
        ["lucide-rocking-chair"] = "rbxassetid://10734939942",
        ["lucide-rotate-3d"] = "rbxassetid://10734940107",
        ["lucide-rotate-ccw"] = "rbxassetid://10734940376",
        ["lucide-rotate-cw"] = "rbxassetid://10734940654",
        ["lucide-rss"] = "rbxassetid://10734940825",
        ["lucide-ruler"] = "rbxassetid://10734941018",
        ["lucide-russian-ruble"] = "rbxassetid://10734941199",
        ["lucide-sailboat"] = "rbxassetid://10734941354",
        ["lucide-save"] = "rbxassetid://10734941499",
        ["lucide-scale"] = "rbxassetid://10734941912",
        ["lucide-scale-3d"] = "rbxassetid://10734941739",
        ["lucide-scaling"] = "rbxassetid://10734942072",
        ["lucide-scan"] = "rbxassetid://10734942565",
        ["lucide-scan-face"] = "rbxassetid://10734942198",
        ["lucide-scan-line"] = "rbxassetid://10734942351",
        ["lucide-scissors"] = "rbxassetid://10734942778",
        ["lucide-screen-share"] = "rbxassetid://10734943193",
        ["lucide-screen-share-off"] = "rbxassetid://10734942967",
        ["lucide-scroll"] = "rbxassetid://10734943448",
        ["lucide-search"] = "rbxassetid://10734943674",
        ["lucide-send"] = "rbxassetid://10734943902",
        ["lucide-separator-horizontal"] = "rbxassetid://10734944115",
        ["lucide-separator-vertical"] = "rbxassetid://10734944326",
        ["lucide-server"] = "rbxassetid://10734949856",
        ["lucide-server-cog"] = "rbxassetid://10734944444",
        ["lucide-server-crash"] = "rbxassetid://10734944554",
        ["lucide-server-off"] = "rbxassetid://10734944668",
        ["lucide-settings"] = "rbxassetid://10734950309",
        ["lucide-settings-2"] = "rbxassetid://10734950020",
        ["lucide-share"] = "rbxassetid://10734950813",
        ["lucide-share-2"] = "rbxassetid://10734950553",
        ["lucide-sheet"] = "rbxassetid://10734951038",
        ["lucide-shield"] = "rbxassetid://10734951847",
        ["lucide-shield-alert"] = "rbxassetid://10734951173",
        ["lucide-shield-check"] = "rbxassetid://10734951367",
        ["lucide-shield-close"] = "rbxassetid://10734951535",
        ["lucide-shield-off"] = "rbxassetid://10734951684",
        ["lucide-shirt"] = "rbxassetid://10734952036",
        ["lucide-shopping-bag"] = "rbxassetid://10734952273",
        ["lucide-shopping-cart"] = "rbxassetid://10734952479",
        ["lucide-shovel"] = "rbxassetid://10734952773",
        ["lucide-shower-head"] = "rbxassetid://10734952942",
        ["lucide-shrink"] = "rbxassetid://10734953073",
        ["lucide-shrub"] = "rbxassetid://10734953241",
        ["lucide-shuffle"] = "rbxassetid://10734953451",
        ["lucide-sidebar"] = "rbxassetid://10734954301",
        ["lucide-sidebar-close"] = "rbxassetid://10734953715",
        ["lucide-sidebar-open"] = "rbxassetid://10734954000",
        ["lucide-sigma"] = "rbxassetid://10734954538",
        ["lucide-signal"] = "rbxassetid://10734961133",
        ["lucide-signal-high"] = "rbxassetid://10734954807",
        ["lucide-signal-low"] = "rbxassetid://10734955080",
        ["lucide-signal-medium"] = "rbxassetid://10734955336",
        ["lucide-signal-zero"] = "rbxassetid://10734960878",
        ["lucide-siren"] = "rbxassetid://10734961284",
        ["lucide-skip-back"] = "rbxassetid://10734961526",
        ["lucide-skip-forward"] = "rbxassetid://10734961809",
        ["lucide-skull"] = "rbxassetid://10734962068",
        ["lucide-slack"] = "rbxassetid://10734962339",
        ["lucide-slash"] = "rbxassetid://10734962600",
        ["lucide-slice"] = "rbxassetid://10734963024",
        ["lucide-sliders"] = "rbxassetid://10734963400",
        ["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
        ["lucide-smartphone"] = "rbxassetid://10734963940",
        ["lucide-smartphone-charging"] = "rbxassetid://10734963671",
        ["lucide-smile"] = "rbxassetid://10734964441",
        ["lucide-smile-plus"] = "rbxassetid://10734964188",
        ["lucide-snowflake"] = "rbxassetid://10734964600",
        ["lucide-sofa"] = "rbxassetid://10734964852",
        ["lucide-sort-asc"] = "rbxassetid://10734965115",
        ["lucide-sort-desc"] = "rbxassetid://10734965287",
        ["lucide-speaker"] = "rbxassetid://10734965419",
        ["lucide-sprout"] = "rbxassetid://10734965572",
        ["lucide-square"] = "rbxassetid://10734965702",
        ["lucide-star"] = "rbxassetid://10734966248",
        ["lucide-star-half"] = "rbxassetid://10734965897",
        ["lucide-star-off"] = "rbxassetid://10734966097",
        ["lucide-stethoscope"] = "rbxassetid://10734966384",
        ["lucide-sticker"] = "rbxassetid://10734972234",
        ["lucide-sticky-note"] = "rbxassetid://10734972463",
        ["lucide-stop-circle"] = "rbxassetid://10734972621",
        ["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
        ["lucide-stretch-vertical"] = "rbxassetid://10734973130",
        ["lucide-strikethrough"] = "rbxassetid://10734973290",
        ["lucide-subscript"] = "rbxassetid://10734973457",
        ["lucide-sun"] = "rbxassetid://10734974297",
        ["lucide-sun-dim"] = "rbxassetid://10734973645",
        ["lucide-sun-medium"] = "rbxassetid://10734973778",
        ["lucide-sun-moon"] = "rbxassetid://10734973999",
        ["lucide-sun-snow"] = "rbxassetid://10734974130",
        ["lucide-sunrise"] = "rbxassetid://10734974522",
        ["lucide-sunset"] = "rbxassetid://10734974689",
        ["lucide-superscript"] = "rbxassetid://10734974850",
        ["lucide-swiss-franc"] = "rbxassetid://10734975024",
        ["lucide-switch-camera"] = "rbxassetid://10734975214",
        ["lucide-sword"] = "rbxassetid://10734975486",
        ["lucide-swords"] = "rbxassetid://10734975692",
        ["lucide-syringe"] = "rbxassetid://10734975932",
        ["lucide-table"] = "rbxassetid://10734976230",
        ["lucide-table-2"] = "rbxassetid://10734976097",
        ["lucide-tablet"] = "rbxassetid://10734976394",
        ["lucide-tag"] = "rbxassetid://10734976528",
        ["lucide-tags"] = "rbxassetid://10734976739",
        ["lucide-target"] = "rbxassetid://10734977012",
        ["lucide-tent"] = "rbxassetid://10734981750",
        ["lucide-terminal"] = "rbxassetid://10734982144",
        ["lucide-terminal-square"] = "rbxassetid://10734981995",
        ["lucide-text-cursor"] = "rbxassetid://10734982395",
        ["lucide-text-cursor-input"] = "rbxassetid://10734982297",
        ["lucide-thermometer"] = "rbxassetid://10734983134",
        ["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
        ["lucide-thermometer-sun"] = "rbxassetid://10734982771",
        ["lucide-thumbs-down"] = "rbxassetid://10734983359",
        ["lucide-thumbs-up"] = "rbxassetid://10734983629",
        ["lucide-ticket"] = "rbxassetid://10734983868",
        ["lucide-timer"] = "rbxassetid://10734984606",
        ["lucide-timer-off"] = "rbxassetid://10734984138",
        ["lucide-timer-reset"] = "rbxassetid://10734984355",
        ["lucide-toggle-left"] = "rbxassetid://10734984834",
        ["lucide-toggle-right"] = "rbxassetid://10734985040",
        ["lucide-tornado"] = "rbxassetid://10734985247",
        ["lucide-toy-brick"] = "rbxassetid://10747361919",
        ["lucide-train"] = "rbxassetid://10747362105",
        ["lucide-trash"] = "rbxassetid://10747362393",
        ["lucide-trash-2"] = "rbxassetid://10747362241",
        ["lucide-tree-deciduous"] = "rbxassetid://10747362534",
        ["lucide-tree-pine"] = "rbxassetid://10747362748",
        ["lucide-trees"] = "rbxassetid://10747363016",
        ["lucide-trending-down"] = "rbxassetid://10747363205",
        ["lucide-trending-up"] = "rbxassetid://10747363465",
        ["lucide-triangle"] = "rbxassetid://10747363621",
        ["lucide-trophy"] = "rbxassetid://10747363809",
        ["lucide-truck"] = "rbxassetid://10747364031",
        ["lucide-tv"] = "rbxassetid://10747364593",
        ["lucide-tv-2"] = "rbxassetid://10747364302",
        ["lucide-type"] = "rbxassetid://10747364761",
        ["lucide-umbrella"] = "rbxassetid://10747364971",
        ["lucide-underline"] = "rbxassetid://10747365191",
        ["lucide-undo"] = "rbxassetid://10747365484",
        ["lucide-undo-2"] = "rbxassetid://10747365359",
        ["lucide-unlink"] = "rbxassetid://10747365771",
        ["lucide-unlink-2"] = "rbxassetid://10747397871",
        ["lucide-unlock"] = "rbxassetid://10747366027",
        ["lucide-upload"] = "rbxassetid://10747366434",
        ["lucide-upload-cloud"] = "rbxassetid://10747366266",
        ["lucide-usb"] = "rbxassetid://10747366606",
        ["lucide-user"] = "rbxassetid://10747373176",
        ["lucide-user-check"] = "rbxassetid://10747371901",
        ["lucide-user-cog"] = "rbxassetid://10747372167",
        ["lucide-user-minus"] = "rbxassetid://10747372346",
        ["lucide-user-plus"] = "rbxassetid://10747372702",
        ["lucide-user-x"] = "rbxassetid://10747372992",
        ["lucide-users"] = "rbxassetid://10747373426",
        ["lucide-utensils"] = "rbxassetid://10747373821",
        ["lucide-utensils-crossed"] = "rbxassetid://10747373629",
        ["lucide-venetian-mask"] = "rbxassetid://10747374003",
        ["lucide-verified"] = "rbxassetid://10747374131",
        ["lucide-vibrate"] = "rbxassetid://10747374489",
        ["lucide-vibrate-off"] = "rbxassetid://10747374269",
        ["lucide-video"] = "rbxassetid://10747374938",
        ["lucide-video-off"] = "rbxassetid://10747374721",
        ["lucide-view"] = "rbxassetid://10747375132",
        ["lucide-voicemail"] = "rbxassetid://10747375281",
        ["lucide-volume"] = "rbxassetid://10747376008",
        ["lucide-volume-1"] = "rbxassetid://10747375450",
        ["lucide-volume-2"] = "rbxassetid://10747375679",
        ["lucide-volume-x"] = "rbxassetid://10747375880",
        ["lucide-wallet"] = "rbxassetid://10747376205",
        ["lucide-wand"] = "rbxassetid://10747376565",
        ["lucide-wand-2"] = "rbxassetid://10747376349",
        ["lucide-watch"] = "rbxassetid://10747376722",
        ["lucide-waves"] = "rbxassetid://10747376931",
        ["lucide-webcam"] = "rbxassetid://10747381992",
        ["lucide-wifi"] = "rbxassetid://10747382504",
        ["lucide-wifi-off"] = "rbxassetid://10747382268",
        ["lucide-wind"] = "rbxassetid://10747382750",
        ["lucide-wrap-text"] = "rbxassetid://10747383065",
        ["lucide-wrench"] = "rbxassetid://10747383470",
        ["lucide-x"] = "rbxassetid://10747384394",
        ["lucide-x-circle"] = "rbxassetid://10747383819",
        ["lucide-x-octagon"] = "rbxassetid://10747384037",
        ["lucide-x-square"] = "rbxassetid://10747384217",
        ["lucide-zoom-in"] = "rbxassetid://10747384552",
        ["lucide-zoom-out"] = "rbxassetid://10747384679",
    };

    local function Fixed(planePos, planeNormal, rayOrigin, rayDirection)
        local n = planeNormal
        local d = rayDirection
        local v = rayOrigin - planePos
        local num = (n.x*v.x) + (n.y*v.y) + (n.z*v.z)
        local den = (n.x*d.x) + (n.y*d.y) + (n.z*d.z)
        local a = -num / den
        return rayOrigin + (a * rayDirection), a;
    end;

    function NeverZen:SetBlur(frame, NoAutoBackground)
        local Part = Instance.new('Part',workspace.Camera);
        local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
        local SurfaceGui = Instance.new('SurfaceGui',Part);
        local BlockMesh = Instance.new("BlockMesh");
        BlockMesh.Parent = Part;
        Part.Material = Enum.Material.Glass;
        Part.Transparency = 1;
        Part.Reflectance = 1;
        Part.CastShadow = false;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CollisionGroup = NeverZen:RandomString();
        Part.Size = Vector3.new(1, 1, 1) * 0.01;
        Part.Color = Color3.fromRGB(0,0,0);
        TweenService:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
            Transparency = 0.8;
        }):Play()
        DepthOfField.Enabled = true;
        DepthOfField.FarIntensity = 1;
        DepthOfField.FocusDistance = 0;
        DepthOfField.InFocusRadius = 500;
        DepthOfField.NearIntensity = 1;
        SurfaceGui.AlwaysOnTop = true;
        SurfaceGui.Adornee = Part;
        SurfaceGui.Active = true;
        SurfaceGui.Face = Enum.NormalId.Front;
        SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
        DepthOfField.Name = NeverZen:RandomString();
        Part.Name = NeverZen:RandomString();
        SurfaceGui.Name = NeverZen:RandomString();
        local C4 = {
            Update = nil,
            Collection = SurfaceGui,
            Enabled = true,
            Instances = {
                BlockMesh = BlockMesh,
                Part = Part,
                DepthOfField = DepthOfField,
                SurfaceGui = SurfaceGui,
            },
            Signal = nil
        };
        local Update = function()
            local _,updatec = pcall(function()
                local userSettings = UserSettings():GetService("UserGameSettings")
                local qualityLevel = userSettings.SavedQualityLevel.Value
                if not NoAutoBackground then
                    if qualityLevel < 8 then
                        TweenService:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
                            Transparency = 1;
                        }):Play()
                        frame.BackgroundTransparency = 0.01
                    else
                        TweenService:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
                            Transparency = 0.8;
                        }):Play()
                        frame.BackgroundTransparency = 0.075
                    end;
                end;
            end)
            local corner0 = frame.AbsolutePosition;
            local corner1 = corner0 + frame.AbsoluteSize;
            local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
            local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);
            local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);
            local planeNormal = CurrentCamera.CFrame.LookVector;
            local pos0 = Fixed(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
            local pos1 = Fixed(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);
            pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
            pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);
            local size   = pos1 - pos0;
            local center = (pos0 + pos1) / 2;
            BlockMesh.Offset = center
            BlockMesh.Scale  = size / 0.0101;
            Part.CFrame = CurrentCamera.CFrame;
        end
        C4.Update = Update;
        C4.Signal = NeverZen:Track(RunService.RenderStepped:Connect(Update));
        pcall(function()
            C4.Signal2 = NeverZen:Track(CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(function()
                Part.CFrame = CurrentCamera.CFrame;
            end));
        end)
        C4.Destroy = function()
            C4.Signal:Disconnect();
            C4.Signal2:Disconnect();
            C4.Update = function() end;
            TweenService:Create(Part,TweenInfo.new(1),{
                Transparency = 1
            }):Play();
            DepthOfField:Destroy();
            Part:Destroy()
        end;
        return C4;
    end;

    function NeverZen:GetIcon(name)
        return NeverZen.Lucide['lucide-'..tostring(name)] or NeverZen.Lucide[name] or NeverZen.Lucide[tostring(name)] or "";
    end;

    function NeverZen:RandomString()
        return string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))
    end;

    function NeverZen:Rounding(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end;

    NeverZen.Theme = {
        WindowBackgroundColor = Color3.fromRGB(10, 6, 7),
        HeadText = Color3.fromRGB(232, 210, 212),
        LineColor = Color3.fromRGB(46, 20, 24),
        BackgroundColor = Color3.fromRGB(30, 14, 17),
        SectionColor = Color3.fromRGB(20, 10, 12),
        Hightlight = Color3.fromRGB(220, 20, 40),
        StrokeColor = Color3.fromRGB(54, 22, 27),
        StrokeColor2 = Color3.fromRGB(150, 96, 104),
        BackgroundColor2 = Color3.fromRGB(18, 9, 11),
        IconColor = Color3.fromRGB(255, 235, 238),
    }

    NeverZen.Chroma = {
        Enabled = true,
        Speed = 0.45,
        Targets = {},
    }

    function NeverZen:ChromaColor(offset)
        local t = (tick() * NeverZen.Chroma.Speed) + (offset or 0)
        local wave = (math.sin(t * math.pi * 2) + 1) / 2
        local hue = ((wave * 0.055) + 0.972) % 1
        local sat = 0.85 + (math.sin(t * math.pi * 1.3) * 0.10)
        local val = 0.80 + (math.sin(t * math.pi * 1.7) * 0.18)
        return Color3.fromHSV(hue, math.clamp(sat, 0, 1), math.clamp(val, 0.35, 1))
    end

    function NeverZen:BindChroma(instance, property, offset, gate)
        if not instance or not property then return end
        local entry = {
            Instance = instance,
            Property = property,
            Offset = offset or 0,
            Gate = gate,
        }
        table.insert(NeverZen.Chroma.Targets, entry)
        return entry
    end

    task.spawn(function()
        while task.wait() do
            if NeverZen.Chroma.Enabled then
                local base = NeverZen:ChromaColor(0)
                NeverZen.Theme.Hightlight = base
                for i = #NeverZen.Chroma.Targets, 1, -1 do
                    local entry = NeverZen.Chroma.Targets[i]
                    local inst = entry.Instance
                    if not inst or not inst.Parent then
                        table.remove(NeverZen.Chroma.Targets, i)
                    elseif (not entry.Gate) or entry.Gate() then
                        local ok = pcall(function()
                            inst[entry.Property] = NeverZen:ChromaColor(entry.Offset)
                        end)
                        if not ok then
                            table.remove(NeverZen.Chroma.Targets, i)
                        end
                    end
                end
            end
        end
    end)

    function NeverZen:SetTheme(name)
        if name == "Default" or name == "Gamesense" or name == "Skeet" then
            NeverZen.Theme = {
                WindowBackgroundColor = Color3.fromRGB(12, 12, 12),
                HeadText = Color3.fromRGB(209, 209, 209),
                LineColor = Color3.fromRGB(35, 35, 35),
                BackgroundColor = Color3.fromRGB(32, 32, 32),
                SectionColor = Color3.fromRGB(23, 23, 23),
                Hightlight = Color3.fromRGB(161, 208, 42),
                StrokeColor = Color3.fromRGB(40, 40, 40),
                StrokeColor2 = Color3.fromRGB(136, 136, 136),
                BackgroundColor2 = Color3.fromRGB(20, 20, 20),
                IconColor = Color3.fromRGB(255, 255, 255),
            }
        elseif name == "Neverlose" then
            NeverZen.Theme = {
                WindowBackgroundColor = Color3.fromRGB(6,8,5),
                HeadText = Color3.fromRGB(233,239,237),
                LineColor = Color3.fromRGB(18,20,19),
                BackgroundColor = Color3.fromRGB(6,8,5),
                SectionColor = Color3.fromRGB(9,11,10),
                Hightlight = Color3.fromRGB(0,169,239),
                StrokeColor = Color3.fromRGB(18,20,19),
                StrokeColor2 = Color3.fromRGB(77,90,92),
                BackgroundColor2 = Color3.fromRGB(10,14,13),
                IconColor = Color3.fromRGB(5,164,233),
            };
        elseif name == "Fatality" then
            NeverZen.Theme = {
                WindowBackgroundColor = Color3.fromRGB(8, 7, 20),
                HeadText = Color3.fromRGB(245,245,245),
                LineColor = Color3.fromRGB(54,47,86),
                BackgroundColor = Color3.fromRGB(11,10,26),
                SectionColor = Color3.fromRGB(17, 14, 36),
                Hightlight = Color3.fromRGB(198,9,85),
                StrokeColor = Color3.fromRGB(54,47,86),
                StrokeColor2 = Color3.fromRGB(54,47,86),
                BackgroundColor2 = Color3.fromRGB(21,18,45),
                IconColor = Color3.fromRGB(233,5,89),
            };
        elseif name == "Anyx" then
            NeverZen.Theme = {
                WindowBackgroundColor = Color3.fromRGB(17, 17, 17),
                HeadText = Color3.fromRGB(245,245,245),
                LineColor = Color3.fromRGB(42, 42, 42),
                BackgroundColor = Color3.fromRGB(20, 20, 20),
                SectionColor = Color3.fromRGB(20,20,20),
                Hightlight = Color3.fromRGB(81,195,206),
                StrokeColor = Color3.fromRGB(29,35,38),
                StrokeColor2 = Color3.fromRGB(29,35,38),
                BackgroundColor2 = Color3.fromRGB(31,31,31),
                IconColor = Color3.fromRGB(128,174,172),
            };
        elseif name == "Hyperion" then
            NeverZen.Theme = {
                WindowBackgroundColor = Color3.fromRGB(23, 26, 29),
                HeadText = Color3.fromRGB(211,34,35),
                LineColor = Color3.fromRGB(52,55,60),
                BackgroundColor = Color3.fromRGB(38, 43, 49),
                SectionColor = Color3.fromRGB(38,42,48),
                Hightlight = Color3.fromRGB(197,29,29),
                StrokeColor = Color3.fromRGB(48,51,56),
                StrokeColor2 = Color3.fromRGB(54, 58, 63),
                BackgroundColor2 = Color3.fromRGB(43,48,55),
                IconColor = Color3.fromRGB(220,221,222),
            };
        elseif name == "Airflow" then
            NeverZen.Theme = {
                WindowBackgroundColor = Color3.fromRGB(41,40,38),
                HeadText = Color3.fromRGB(229,229,228),
                LineColor = Color3.fromRGB(49,49,48),
                BackgroundColor = Color3.fromRGB(69,66,63),
                SectionColor = Color3.fromRGB(42,41,40),
                Hightlight = Color3.fromRGB(143,107,190),
                StrokeColor = Color3.fromRGB(49,49,48),
                StrokeColor2 = Color3.fromRGB(36, 36, 35),
                BackgroundColor2 = Color3.fromRGB(46,46,44),
                IconColor = Color3.fromRGB(143,107,190),
            };
        end;
    end;

    function NeverZen.new(config)
        config = config or {};
        config.Name = config.Name or "NEVERZEN";
        config.Keybind = config.Keybind or Enum.KeyCode.LeftControl;
        config.Scale = config.Scale or UDim2.new(0, 611, 0, 396);
        config.Resizable = config.Resizable;
        config.Shadow = config.Shadow or false;
        config.ShowProfile = config.ShowProfile or false;
        config.Acrylic = config.Acrylic or false;

        local WindowSignal = {};
        WindowSignal.SelectedTab = nil;
        WindowSignal.Tabs = {};
        WindowSignal.Config = config;
        WindowSignal.Toggle = true;
        WindowSignal.FrameMemory = {
            WindowBackgroundColor = {},
            HeadText = {},
            LineColor = {},
        };

        local Content = Instance.new("ScreenGui")
        local WindowFrame = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local UIStroke = Instance.new("UIStroke")
        local Header = Instance.new("Frame")
        local HeaderText = Instance.new("TextLabel")
        local SubTitleText = Instance.new("TextLabel")
        local Line = Instance.new("Frame")
        local Frame = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")
        local SearchFrame = Instance.new("Frame")
        local SearchButton = Instance.new("ImageButton")
        local UIStroke_2 = Instance.new("UIStroke")
        local UICorner_2 = Instance.new("UICorner")
        local TextBox = Instance.new("TextBox")
        local MinButton = Instance.new("ImageButton")
        local Line_2 = Instance.new("Frame")
        local BthFrames = Instance.new("Frame")
        local InformationFrame = Instance.new("Frame")
        local ProfileIcon = Instance.new("ImageLabel")
        local UICorner_3 = Instance.new("UICorner")
        local UIStroke_3 = Instance.new("UIStroke")
        local UsernameText = Instance.new("TextLabel")
        local UIGradient = Instance.new("UIGradient")
        local TabButtons = Instance.new("Frame")
        local TBSFrame = Instance.new("ScrollingFrame")
        local UIListLayout_2 = Instance.new("UIListLayout")
        local Line_3 = Instance.new("Frame")
        local TabWin = Instance.new("Frame")

        Content.Name = NeverZen:RandomString()
        Content.Parent = CoreGui;
        Content.ResetOnSpawn = false
        Content.IgnoreGuiInset = true
        Content.ZIndexBehavior = Enum.ZIndexBehavior.Global;
        table.insert(NeverZen.Guis, Content);
        NeverZen.ProtectGui(Content);

        WindowFrame.Name = NeverZen:RandomString()
        WindowFrame.Parent = Content
        WindowFrame.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
        WindowFrame.BackgroundTransparency = 0.1
        WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        WindowFrame.BorderSizePixel = 0
        WindowFrame.ClipsDescendants = true
        WindowFrame.Position = UDim2.new(0, 177, 0, 177)
        WindowFrame.Size = UDim2.new(0,0,0,0)
        WindowFrame.Active = true
        table.insert(WindowSignal.FrameMemory.WindowBackgroundColor , WindowFrame)

        if config.Shadow then
            local DropShadow = Instance.new("ImageLabel")
            DropShadow.Name = NeverZen:RandomString()
            DropShadow.Parent = WindowFrame
            DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            DropShadow.BackgroundTransparency = 1.000
            DropShadow.BorderSizePixel = 0
            DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            DropShadow.Rotation = 0.01
            DropShadow.Size = UDim2.new(1, 47, 1, 47)
            DropShadow.ZIndex = -1
            DropShadow.Image = "rbxassetid://6015897843"
            DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            DropShadow.ImageTransparency = 1
            DropShadow.ScaleType = Enum.ScaleType.Slice
            DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
            task.delay(1,function()
                TweenService:Create(DropShadow,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    ImageTransparency = 0.75
                }):Play()
            end)
        end

        TweenService:Create(WindowFrame,TweenInfo.new(1,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size = config.Scale,
            Position = UDim2.new(0, 75, 0, 75)
        }):Play()

        if config.Acrylic == nil then
            config.Acrylic = true
        end

        if config.Acrylic then
            local Blur = NeverZen:SetBlur(WindowFrame)
            table.insert(NeverZen.Cleanups, Blur.Destroy);
        end;

        function WindowSignal:SetScale(new)
            WindowSignal.Config.Scale = new;
            TweenService:Create(WindowFrame,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Size = new,
            }):Play()
        end;

        function WindowSignal:SetSubTitle(text)
            SubTitleText.Text = text or ""
        end;

        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = WindowFrame

        UIStroke.Transparency = 0.850
        UIStroke.Color = Color3.fromRGB(0, 25, 34)
        UIStroke.Parent = WindowFrame

        Header.Name = NeverZen:RandomString()
        Header.Parent = WindowFrame
        Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Header.BackgroundTransparency = 1.000
        Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Header.BorderSizePixel = 0
        Header.ClipsDescendants = true
        Header.Size = UDim2.new(1, 0, 0, 45)
        Header.Position = UDim2.new(0,0,0,-50)
        Header.Active = true

        task.delay(0.2,function()
            TweenService:Create(Header,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0,0,0,0)
            }):Play()
        end)

        HeaderText.Name = NeverZen:RandomString()
        HeaderText.Parent = Header
        HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HeaderText.BackgroundTransparency = 1.000
        HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
        HeaderText.BorderSizePixel = 0
        HeaderText.Position = UDim2.new(0, 10, 0, 3)
        HeaderText.Size = UDim2.new(0, 160, 1, -20)
        HeaderText.Font = Enum.Font.GothamBold
        HeaderText.Text = config.Name;
        HeaderText.TextColor3 = NeverZen.Theme.HeadText
        HeaderText.TextScaled = false
        HeaderText.TextXAlignment = Enum.TextXAlignment.Left
        HeaderText.TextSize = 25.000
        HeaderText.TextWrapped = true
        table.insert(WindowSignal.FrameMemory.HeadText , HeaderText)

        task.delay(0.4,function()
            TweenService:Create(HeaderText,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0, 10, 0, 5)
            }):Play()
        end)

        Line.Name = NeverZen:RandomString()
        Line.Parent = Header
        Line.AnchorPoint = Vector2.new(0, 1)
        Line.BackgroundColor3 =NeverZen.Theme.LineColor
        Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Line.BorderSizePixel = 0
        Line.Position = UDim2.new(0, 170, 1, 0)
        Line.Size = UDim2.new(1, -170, 0, 1)

        SubTitleText.Name = NeverZen:RandomString()
        SubTitleText.Parent = Header
        SubTitleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SubTitleText.BackgroundTransparency = 1.000
        SubTitleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SubTitleText.BorderSizePixel = 0
        SubTitleText.AnchorPoint = Vector2.new(0, 0.5)
        SubTitleText.Position = UDim2.new(0, 10, 0.7, 0)
        SubTitleText.Size = UDim2.new(0, 160, 0, 15)
        SubTitleText.Font = Enum.Font.GothamMedium
        SubTitleText.Text = config.SubTitle or ""
        SubTitleText.TextColor3 = NeverZen.Theme.HeadText
        SubTitleText.TextSize = 12.000
        SubTitleText.TextTransparency = 0.500
        SubTitleText.TextXAlignment = Enum.TextXAlignment.Left
        SubTitleText.ClipsDescendants = true

        Frame.Parent = Header
        Frame.AnchorPoint = Vector2.new(1, 0.5)
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame.BackgroundTransparency = 1.000
        Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.new(1, -10, -0.5, 0)
        Frame.Size = UDim2.new(0, 150, 0.5, 0)
        Frame.ZIndex = 5

        task.delay(0.6,function()
            TweenService:Create(Frame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(1, -10, 0.5, 0)
            }):Play()
        end)

        UIListLayout.Parent = Frame
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Padding = UDim.new(0, 5)

        SearchFrame.Name = NeverZen:RandomString()
        SearchFrame.Parent = Frame
        SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SearchFrame.BackgroundTransparency = 1.000
        SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SearchFrame.BorderSizePixel = 0
        SearchFrame.ClipsDescendants = true
        SearchFrame.Size = UDim2.new(0, 140, 0, 22)

        SearchButton.Name = NeverZen:RandomString()
        SearchButton.Parent = SearchFrame
        SearchButton.AnchorPoint = Vector2.new(1, 0.5)
        SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SearchButton.BackgroundTransparency = 1.000
        SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SearchButton.BorderSizePixel = 0
        SearchButton.Position = UDim2.new(1, -2, 0.5, 0)
        SearchButton.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
        SearchButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
        SearchButton.Image = "rbxassetid://10734943674"
        SearchButton.ImageTransparency = 0.200

        UIStroke_2.Color = NeverZen.Theme.LineColor;
        UIStroke_2.Parent = SearchFrame

        UICorner_2.CornerRadius = UDim.new(0, 4)
        UICorner_2.Parent = SearchFrame

        TextBox.Parent = SearchFrame
        TextBox.AnchorPoint = Vector2.new(0, 0.5)
        TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.BackgroundTransparency = 1.000
        TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.BorderSizePixel = 0
        TextBox.Position = UDim2.new(0, 5, 0.5, 0)
        TextBox.Size = UDim2.new(1, -27, 0.649999976, 0)
        TextBox.ClearTextOnFocus = false
        TextBox.Font = Enum.Font.GothamMedium
        TextBox.PlaceholderText = "Search"
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 14.000
        TextBox.TextTransparency = 0.200
        TextBox.TextXAlignment = Enum.TextXAlignment.Left

        TextBox:GetPropertyChangedSignal('Text'):Connect(function()
            if WindowSignal.SelectedTab then
                if TextBox.Text:byte() then
                    WindowSignal.SelectedTab.Search(TextBox.Text);
                else
                    WindowSignal.SelectedTab.Search(nil);
                end
            end;
        end)

        MinButton.Name = NeverZen:RandomString()
        MinButton.Parent = Frame
        MinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MinButton.BackgroundTransparency = 1.000
        MinButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        MinButton.BorderSizePixel = 0
        MinButton.Size = UDim2.new(1, 0, 1, 0)
        MinButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
        MinButton.Image = NeverZen:GetIcon('scan')
        MinButton.ImageTransparency = 0.200

        Line_2.Name = NeverZen:RandomString()
        Line_2.Parent = WindowFrame
        Line_2.BackgroundColor3 =NeverZen.Theme.LineColor
        Line_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Line_2.BorderSizePixel = 0
        Line_2.Position = UDim2.new(0, 170, 0, 0)
        Line_2.Size = UDim2.new(0, 1, 1, 0)

        BthFrames.Name = NeverZen:RandomString()
        BthFrames.Parent = WindowFrame
        BthFrames.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BthFrames.BackgroundTransparency = 1.000
        BthFrames.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BthFrames.BorderSizePixel = 0
        BthFrames.Position = UDim2.new(-1, 0, 0, 45)
        BthFrames.Size = UDim2.new(0, 170, 1, -45)

        task.delay(0.3,function()
            TweenService:Create(BthFrames,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0, 0, 0, 45)
            }):Play()
        end)

        InformationFrame.Name = NeverZen:RandomString()
        InformationFrame.Parent = BthFrames
        InformationFrame.AnchorPoint = Vector2.new(0, 1)
        InformationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        InformationFrame.BackgroundTransparency = 1.000
        InformationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        InformationFrame.BorderSizePixel = 0
        InformationFrame.Position = UDim2.new(0, 0, 1, 55)
        InformationFrame.Size = UDim2.new(1, 0, 0, 45)
        InformationFrame.Visible = config.ShowProfile

        task.delay(0.3,function()
            TweenService:Create(InformationFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0, 0, 1, 0)
            }):Play()
        end)

        ProfileIcon.Name = NeverZen:RandomString()
        ProfileIcon.Parent = InformationFrame
        ProfileIcon.Active = true
        ProfileIcon.AnchorPoint = Vector2.new(0, 0.5)
        ProfileIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ProfileIcon.BackgroundTransparency = 1.000
        ProfileIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ProfileIcon.BorderSizePixel = 0
        ProfileIcon.Position = UDim2.new(0, 5, 1.3, 0)
        ProfileIcon.Size = UDim2.new(0, 35, 0, 35)
        pcall(function()
            ProfileIcon.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
        end)
        task.delay(0.45,function()
            TweenService:Create(ProfileIcon,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0, 5, 0.5, 0)
            }):Play()
        end)

        UICorner_3.CornerRadius = UDim.new(1, 0)
        UICorner_3.Parent = ProfileIcon

        UIStroke_3.Thickness = 2.000
        UIStroke_3.Color =NeverZen.Theme.LineColor
        UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke_3.Parent = ProfileIcon

        UsernameText.Name = NeverZen:RandomString()
        UsernameText.Parent = InformationFrame
        UsernameText.AnchorPoint = Vector2.new(0, 0.5)
        UsernameText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        UsernameText.BackgroundTransparency = 1.000
        UsernameText.BorderColor3 = Color3.fromRGB(0, 0, 0)
        UsernameText.BorderSizePixel = 0
        UsernameText.Position = UDim2.new(0, 47, 1.4, 0)
        UsernameText.Size = UDim2.new(1, -35, 0, -25)
        UsernameText.Font = Enum.Font.GothamBold
        UsernameText.Text = string.sub(LocalPlayer.DisplayName , 0, math.round(#LocalPlayer.DisplayName / 2))..string.rep("*",math.round(#LocalPlayer.DisplayName / 2));
        UsernameText.TextColor3 = Color3.fromRGB(206, 206, 206)
        UsernameText.TextSize = 14.000
        UsernameText.TextXAlignment = Enum.TextXAlignment.Left

        task.delay(0.5,function()
            TweenService:Create(UsernameText,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0, 47, 0.5, 0)
            }):Play()
        end)

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.20, 0.24), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(0.80, 0.24), NumberSequenceKeypoint.new(1.00, 1.00)}
        UIGradient.Parent = UsernameText

        TabButtons.Name = NeverZen:RandomString()
        TabButtons.Parent = BthFrames
        TabButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButtons.BackgroundTransparency = 1.000
        TabButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButtons.BorderSizePixel = 0
        TabButtons.ClipsDescendants = true
        TabButtons.Size = UDim2.new(0, 170, 1.13661206, -100)

        TBSFrame.Name = NeverZen:RandomString()
        TBSFrame.Parent = TabButtons
        TBSFrame.Active = true
        TBSFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        TBSFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TBSFrame.BackgroundTransparency = 1.000
        TBSFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TBSFrame.BorderSizePixel = 0
        TBSFrame.ClipsDescendants = false
        TBSFrame.Position = UDim2.new(-0.4, 0, 0.5, 0)
        TBSFrame.Size = UDim2.new(1, -5, 1, -5)
        TBSFrame.ZIndex = 2
        TBSFrame.BottomImage = ""
        TBSFrame.ScrollBarThickness = 0
        TBSFrame.TopImage = ""

        task.delay(0.3,function()
            TweenService:Create(TBSFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
        end)

        UIListLayout_2.Parent = TBSFrame
        UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 3)

        UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            TBSFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 5)
        end)

        Line_3.Name = NeverZen:RandomString()
        Line_3.Parent = BthFrames
        Line_3.AnchorPoint = Vector2.new(0, 1)
        Line_3.BackgroundColor3 =NeverZen.Theme.LineColor
        Line_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Line_3.BorderSizePixel = 0
        Line_3.Position = UDim2.new(0, 0, 1, -45)
        Line_3.Size = UDim2.new(0, 170, 0, 1)
        Line_3.Visible = config.ShowProfile

        TabWin.Name = NeverZen:RandomString()
        TabWin.Parent = WindowFrame
        TabWin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabWin.BackgroundTransparency = 1.000
        TabWin.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabWin.BorderSizePixel = 0
        TabWin.Position = UDim2.new(0, 170, 1, 45)
        TabWin.Size = UDim2.new(1, -170, 1, -45)
        TabWin.ZIndex = 2

        task.delay(0.3,function()
            TweenService:Create(TabWin,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.new(0, 170, 0, 45)
            }):Play()
        end);

        function WindowSignal:StatusBar()
            local Statusbar = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")
            Statusbar.Name = NeverZen:RandomString();
            Statusbar.Parent = Content;
            Statusbar.AnchorPoint = Vector2.new(1, 0)
            Statusbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Statusbar.BackgroundTransparency = 1.000
            Statusbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Statusbar.BorderSizePixel = 0
            Statusbar.Position = UDim2.new(1, -5, 0, 5)
            Statusbar.Size = UDim2.new(0, 150, 0, 1)
            UIListLayout.Parent = Statusbar
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 3);
            return {
                create = function(name)
                    local Frame = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local Label = Instance.new("TextLabel")
                    Frame.Parent = Statusbar
                    Frame.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
                    Frame.BackgroundTransparency = 0.100
                    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Frame.BorderSizePixel = 0
                    Frame.Size = UDim2.new(0, 250, 0, 20)
                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = Frame
                    Label.Name = NeverZen:RandomString()
                    Label.Parent = Frame
                    Label.AnchorPoint = Vector2.new(0.5, 0.5)
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Label.BackgroundTransparency = 1.000
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Label.BorderSizePixel = 0
                    Label.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Label.Size = UDim2.new(1, -10, 0.699999988, 0)
                    Label.Font = Enum.Font.GothamMedium
                    Label.Text = name or ""
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 14.000
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    return {
                        Visible = function(self,a)
                            if a then
                                Frame.Visible = true
                            else
                                Frame.Visible = false
                            end
                        end,
                        Text = function(self , name)
                            Label.Text = name or ""
                        end,
                    }
                end,
            };
        end;

        function WindowSignal:AddLabel(name)
            local TBSTitle = Instance.new("TextLabel")
            TBSTitle.Name = NeverZen:RandomString()
            TBSTitle.Parent = TBSFrame
            TBSTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TBSTitle.BackgroundTransparency = 1.000
            TBSTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TBSTitle.BorderSizePixel = 0
            TBSTitle.Size = UDim2.new(1, -17, 0, 15)
            TBSTitle.ZIndex = 5
            TBSTitle.Font = Enum.Font.GothamBold
            TBSTitle.Text = name
            TBSTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TBSTitle.TextSize = 14.000
            TBSTitle.TextTransparency = 1
            TBSTitle.TextXAlignment = Enum.TextXAlignment.Left
            task.delay(#WindowSignal.Tabs / 5,function()
                TweenService:Create(TBSTitle,TweenInfo.new(0.45),{
                    TextTransparency = 0.75
                }):Play()
            end)
            table.insert(WindowSignal.Tabs,{TBSTitle});
        end;

        function WindowSignal:AddTab(config)
            config = config or {};
            config.Name = config.Name or 'Example';
            config.Icon = config.Icon or "target";
            config.SingleMode = config.SingleMode or false;

            local TabSignal = {};
            local TabButton = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local TabIcon = Instance.new("ImageLabel")
            local TabName = Instance.new("TextLabel")

            TabButton.Name = NeverZen:RandomString()
            TabButton.Parent = TBSFrame
            TabButton.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
            TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TabButton.BorderSizePixel = 0
            TabButton.Size = UDim2.new(0, 0, 0, 35)
            TabButton.ZIndex = 5

            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = TabButton

            TabIcon.Name = NeverZen:RandomString()
            TabIcon.Parent = TabButton
            TabIcon.AnchorPoint = Vector2.new(0, 0.5)
            TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.BackgroundTransparency = 1.000
            TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TabIcon.BorderSizePixel = 0
            TabIcon.Position = UDim2.new(0, 7, 0.5, 0)
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.ZIndex = 5
            TabIcon.Image = NeverZen:GetIcon(config.Icon);
            TabIcon.ImageTransparency = 1
            TabIcon.ImageColor3 = NeverZen.Theme.IconColor

            TabName.Name = NeverZen:RandomString()
            TabName.Parent = TabButton
            TabName.AnchorPoint = Vector2.new(0, 0.5)
            TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabName.BackgroundTransparency = 1.000
            TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TabName.BorderSizePixel = 0
            TabName.Position = UDim2.new(0, 37, 0.5, 0)
            TabName.Size = UDim2.new(1, -45, 0, 15)
            TabName.ZIndex = 5
            TabName.Font = Enum.Font.GothamMedium
            TabName.Text = config.Name
            TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabName.TextScaled = true
            TabName.TextSize = 14.000
            TabName.TextTransparency = 1
            TabName.TextWrapped = true
            TabName.TextXAlignment = Enum.TextXAlignment.Left

            local TabFrame = Instance.new("Frame")
            local LeftFrame = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")
            local RightFrame = Instance.new("ScrollingFrame")
            local UIListLayout_2 = Instance.new("UIListLayout")
            local CTFrame = Instance.new("ScrollingFrame")
            local UIListLayoutAF = Instance.new("UIListLayout")

            TabFrame.Name = NeverZen:RandomString()
            TabFrame.Parent = TabWin
            TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabFrame.BackgroundTransparency = 1.000
            TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TabFrame.BorderSizePixel = 0
            TabFrame.ClipsDescendants = true
            TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            TabFrame.Size = UDim2.new(1, -2, 1, -2)
            TabFrame.ZIndex = 4

            CTFrame.Name = NeverZen:RandomString()
            CTFrame.Parent = TabFrame
            CTFrame.Active = true
            CTFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            CTFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CTFrame.BackgroundTransparency = 1.000
            CTFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            CTFrame.BorderSizePixel = 0
            CTFrame.ClipsDescendants = false
            CTFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            CTFrame.Size = UDim2.new(1, -1, 1, -3)
            CTFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
            CTFrame.ScrollBarThickness = 0
            CTFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

            UIListLayoutAF.Parent = CTFrame
            UIListLayoutAF.FillDirection = Enum.FillDirection.Horizontal
            UIListLayoutAF.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayoutAF.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayoutAF.Padding = UDim.new(0, 2)

            LeftFrame.Name = NeverZen:RandomString()
            LeftFrame.Parent = CTFrame
            LeftFrame.Active = true
            LeftFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            LeftFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LeftFrame.BackgroundTransparency = 1.000
            LeftFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            LeftFrame.BorderSizePixel = 0
            LeftFrame.ClipsDescendants = false
            LeftFrame.Position = UDim2.new(0.25, 0, 0.5, 0)
            LeftFrame.Size = UDim2.new(0.5, -5, 1, -3)
            LeftFrame.ScrollBarThickness = 0
            LeftFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

            UIListLayout.Parent = LeftFrame
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)

            UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                LeftFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 5)
            end)

            RightFrame.Name = NeverZen:RandomString()
            RightFrame.Parent = CTFrame
            RightFrame.Active = true
            RightFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            RightFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            RightFrame.BackgroundTransparency = 1.000
            RightFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            RightFrame.BorderSizePixel = 0
            RightFrame.ClipsDescendants = false
            RightFrame.Position = UDim2.new(0.75, 0, 0.5, 0)
            RightFrame.Size = UDim2.new(0.5, -5, 1, -3)
            RightFrame.ScrollBarThickness = 0

            UIListLayout_2.Parent = RightFrame
            UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_2.Padding = UDim.new(0, 5)

            UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                RightFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 5)
            end)

            task.spawn(function()
                while true do task.wait(0.1)
                    if WindowSignal.Config.Scale.X.Offset <= NeverZen.MinimumTabSize or config.SingleMode then
                        UIListLayoutAF.FillDirection = Enum.FillDirection.Vertical
                        UIListLayoutAF.HorizontalAlignment = Enum.HorizontalAlignment.Center
                        UIListLayoutAF.SortOrder = Enum.SortOrder.LayoutOrder
                        CTFrame.ScrollingEnabled = true
                        TweenService:Create(RightFrame,TweenInfo.new(0.2),{
                            Size = UDim2.new(1,-5,0,UIListLayout_2.AbsoluteContentSize.Y + 2)
                        }):Play()
                        TweenService:Create(LeftFrame,TweenInfo.new(0.2),{
                            Size = UDim2.new(1, -5, 0,UIListLayout.AbsoluteContentSize.Y + 3)
                        }):Play()
                        TweenService:Create(UIListLayoutAF,TweenInfo.new(0.2),{
                            Padding = UDim.new(0, 2)
                        }):Play()
                        RightFrame.ScrollingEnabled = false
                        LeftFrame.ScrollingEnabled = false
                        RightFrame.CanvasPosition = Vector2.new(0,0)
                        LeftFrame.CanvasPosition = Vector2.new(0,0)
                        CTFrame.CanvasSize = UDim2.fromOffset(0,UIListLayoutAF.AbsoluteContentSize.Y)
                    else
                        CTFrame.CanvasSize = UDim2.fromOffset(0,0)
                        TweenService:Create(UIListLayoutAF,TweenInfo.new(0.2),{
                            Padding = UDim.new(0, 5)
                        }):Play()
                        TweenService:Create(RightFrame,TweenInfo.new(0.2),{
                            Size = UDim2.new(0.5, -5, 1, -3)
                        }):Play()
                        TweenService:Create(LeftFrame,TweenInfo.new(0.2),{
                            Size = UDim2.new(0.5, -5, 1, -3)
                        }):Play()
                        CTFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
                        UIListLayoutAF.FillDirection = Enum.FillDirection.Horizontal
                        UIListLayoutAF.HorizontalAlignment = Enum.HorizontalAlignment.Center
                        UIListLayoutAF.SortOrder = Enum.SortOrder.LayoutOrder
                        CTFrame.ScrollingEnabled = false
                        RightFrame.ScrollingEnabled = true
                        LeftFrame.ScrollingEnabled = true
                        CTFrame.CanvasPosition = Vector2.new(0,0)
                    end;
                end;
            end);

            local ToggleFunc = function(value)
                if value then
                    TabFrame.Visible = true;
                    TweenService:Create(TabButton,TweenInfo.new(0.2),{
                        BackgroundTransparency = 0.1
                    }):Play()
                    TweenService:Create(TabIcon,TweenInfo.new(0.3),{
                        ImageTransparency = 0.25,
                        Size = UDim2.new(0, 25, 0, 25),
                        Position = UDim2.new(0, 4, 0.5, 0)
                    }):Play()
                    TweenService:Create(TabName,TweenInfo.new(0.1),{
                        TextTransparency = 0.1,
                        Position = UDim2.new(0, 37, 0.5, 0)
                    }):Play()
                else
                    TabFrame.Visible = false;
                    TweenService:Create(TabButton,TweenInfo.new(0.2),{
                        BackgroundTransparency = 1
                    }):Play()
                    TweenService:Create(TabIcon,TweenInfo.new(0.3),{
                        ImageTransparency = 0.5,
                        Position = UDim2.new(0, 7, 0.5, 0),
                        Size = UDim2.new(0, 20, 0, 20)
                    }):Play()
                    TweenService:Create(TabName,TweenInfo.new(0.1),{
                        TextTransparency = 0.2,
                        Position = UDim2.new(0, 33, 0.5, 0)
                    }):Play()
                end;
            end;

            local itemForSearch = {};
            local searchItem = function(q)
                if q and q:byte() then
                    for i,v in next , itemForSearch do
                        if (i % 25) == 1 then
                            task.wait()
                        end
                        if string.find(string.lower(v.Name) , string.lower(q) , 1, true) then
                            v.Frame.Visible = true;
                            task.wait()
                        else
                            v.Frame.Visible = false;
                        end;
                    end;
                else
                    for i,v in next , itemForSearch do
                        if (i % 25) == 1 then
                            task.wait()
                        end
                        v.Frame.Visible = true;
                    end;
                end;
            end;

            local TabIden = {
                call = ToggleFunc,
                target = TabButton,
                Search = searchItem,
            };

            task.delay(#WindowSignal.Tabs / 8,function()
                TweenService:Create(TabButton,TweenInfo.new(0.35),{
                    Size = UDim2.new(1, 0, 0, 35)
                }):Play()
            end)

            ToggleFunc(WindowSignal.SelectedTab == nil and true)

            table.insert(WindowSignal.Tabs,TabIden);

            WindowSignal.SelectedTab = TabIden;

            task.delay(0.1,function()
                WindowSignal.SelectedTab = TabIden;
            end)

            NeverZen:NewInput(TabButton,function()
                if not Content.Enabled or not Content.Parent then
                    return;
                end;
                WindowSignal.SelectedTab = TabIden;
                for i,v in next , WindowSignal.Tabs do
                    if v.target == TabButton then
                        ToggleFunc(true)
                    else
                        if v.call then
                            v.call(false)
                        end
                    end;
                end;
            end);

            function TabSignal:AddSection(Config)
                Config = Config or {};
                Config.Name = Config.Name or "Section";
                Config.Position = Config.Position or "left";

                local SectionSignal = {};
                local Section = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local head = Instance.new("Frame")
                local Label = Instance.new("TextLabel")
                local Frame = Instance.new("Frame")
                local UIListLayout = Instance.new("UIListLayout")

                Section.Name = NeverZen:RandomString()
                Section.Parent = (string.lower(Config.Position) == "left" and LeftFrame) or RightFrame;
                Section.BackgroundColor3 = NeverZen.Theme.SectionColor
                Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Section.BorderSizePixel = 0
                Section.ClipsDescendants = true
                Section.Size = UDim2.new(1, 0, 0, 25)

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Section

                UIStroke.Color = NeverZen.Theme.BackgroundColor
                UIStroke.Parent = Section

                head.Name = "head"
                head.Parent = Section
                head.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                head.BackgroundTransparency = 1.000
                head.BorderColor3 = Color3.fromRGB(0, 0, 0)
                head.BorderSizePixel = 0
                head.Size = UDim2.new(1, 0, 0, 24)

                Label.Name = "Label"
                Label.Parent = head
                Label.AnchorPoint = Vector2.new(0.5, 0)
                Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Label.BackgroundTransparency = 1.000
                Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Label.BorderSizePixel = 0
                Label.Position = UDim2.new(0.5, 0, 0, 2)
                Label.Size = UDim2.new(1, -10, 0, 20)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = Config.Name
                Label.TextColor3 = Color3.fromRGB(254, 254, 254)
                Label.TextSize = 14.000
                Label.TextTransparency = 0.200
                Label.TextXAlignment = Enum.TextXAlignment.Left

                Frame.Parent = head
                Frame.AnchorPoint = Vector2.new(0, 1)
                Frame.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.BorderSizePixel = 0
                Frame.Position = UDim2.new(0, 0, 1, 0)
                Frame.Size = UDim2.new(1, 0, 0, 1)
                Frame.ZIndex = 6

                UIListLayout.Parent = Section
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 3)

                UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                    TweenService:Create(Section,TweenInfo.new(0.3,Enum.EasingStyle.Quint),{
                        Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 3)
                    }):Play()
                end)

                function SectionSignal:AddDivider(config)
                    config = config or {};
                    config.Color = config.Color or NeverZen.Theme.LineColor;
                    config.Height = config.Height or 1;
                    local Divider = Instance.new("Frame");
                    local UICorner = Instance.new("UICorner");
                    table.insert(itemForSearch,{
                        Frame = Divider,
                        Name = ""
                    });
                    Divider.Name = NeverZen:RandomString();
                    Divider.Parent = Section;
                    Divider.BackgroundColor3 = config.Color;
                    Divider.BorderColor3 = Color3.fromRGB(0, 0, 0);
                    Divider.BorderSizePixel = 0;
                    Divider.Size = UDim2.new(1, -10, 0, config.Height);
                    UICorner.CornerRadius = UDim.new(0, 2);
                    UICorner.Parent = Divider;
                    return {
                        SetColor = function(self, newColor)
                            config.Color = newColor;
                            Divider.BackgroundColor3 = newColor;
                        end,
                        SetHeight = function(self, newHeight)
                            config.Height = newHeight;
                            Divider.Size = UDim2.new(1, -10, 0, newHeight);
                        end,
                        Visible = function(self, value)
                            Divider.Visible = value;
                        end,
                        Destroy = function(self)
                            Divider:Destroy();
                        end
                    };
                end;

                function SectionSignal:AddToggle(config)
                    config = config or {};
                    config.Default = config.Default or false;
                    config.Name = config.Name or "Toggle";
                    config.Callback = config.Callback or function() end;

                    local Toggle = Instance.new("Frame")
                    local Label = Instance.new("TextLabel")
                    local sys = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local color = Instance.new("Frame")
                    local UICorner_2 = Instance.new("UICorner")
                    local UIStroke = Instance.new("UIStroke")

                    table.insert(itemForSearch,{
                        Frame = Toggle,
                        Name = config.Name
                    })

                    Toggle.Name = NeverZen:RandomString()
                    Toggle.Parent = Section
                    Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Toggle.BackgroundTransparency = 1.000
                    Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Toggle.BorderSizePixel = 0
                    Toggle.Size = UDim2.new(1, -5, 0, 25)

                    Label.Name = "Label"
                    Label.Parent = Toggle
                    Label.AnchorPoint = Vector2.new(0, 0.5)
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Label.BackgroundTransparency = 1.000
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Label.BorderSizePixel = 0
                    Label.Position = UDim2.new(0, 5, 0.5, 0)
                    Label.Size = UDim2.new(1, -25, 0.649999976, 0)
                    Label.Font = Enum.Font.GothamMedium
                    Label.Text = config.Name
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 14.000
                    Label.TextTransparency = 0.100
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    sys.Name = "sys"
                    sys.Parent = Toggle
                    sys.AnchorPoint = Vector2.new(1, 0.5)
                    sys.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                    sys.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    sys.BorderSizePixel = 0
                    sys.Position = UDim2.new(1, -3, 0.5, 0)
                    sys.Size = UDim2.new(0, 25, 0, 15)

                    UICorner.CornerRadius = UDim.new(1, 0)
                    UICorner.Parent = sys

                    color.Name = "color"
                    color.Parent = sys
                    color.AnchorPoint = Vector2.new(0.5, 0.5)
                    color.BackgroundColor3 = NeverZen.Theme.Hightlight
                    color.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    local ToggleActive = config.Default and true or false
                    NeverZen:BindChroma(color, "BackgroundColor3", 0.05, function()
                        return ToggleActive
                    end)
                    color.BorderSizePixel = 0
                    color.Position = UDim2.new(0.75, 0, 0.5, 0)
                    color.Size = UDim2.new(1, 0, 1, 0)
                    color.SizeConstraint = Enum.SizeConstraint.RelativeYY

                    UICorner_2.CornerRadius = UDim.new(1, 0)
                    UICorner_2.Parent = color

                    UIStroke.Color = NeverZen.Theme.StrokeColor
                    UIStroke.Parent = sys

                    local setValue = function(value)
                        ToggleActive = value and true or false
                        if value then
                            TweenService:Create(color,TweenInfo.new(0.2),{
                                Position = UDim2.new(0.75, 0, 0.5, 0),
                                BackgroundColor3 = NeverZen.Theme.Hightlight
                            }):Play()
                            TweenService:Create(Label,TweenInfo.new(0.4),{
                                TextTransparency = 0.1
                            }):Play()
                        else
                            TweenService:Create(Label,TweenInfo.new(0.4),{
                                TextTransparency = 0.4
                            }):Play()
                            TweenService:Create(color,TweenInfo.new(0.2),{
                                Position = UDim2.new(0.25, 0, 0.5, 0),
                                BackgroundColor3 = Color3.fromRGB(152, 152, 152)
                            }):Play()
                        end;
                    end;

                    setValue(config.Default);

                    NeverZen:NewInput(Toggle,function()
                        if not Content.Enabled or not Content.Parent then
                            return;
                        end;
                        config.Default = not config.Default
                        setValue(config.Default)
                        config.Callback(config.Default,config)
                    end);

                    return {
                        SetValue = function(self,newvalue)
                            config.Default = newvalue
                            setValue(config.Default)
                            config.Callback(config.Default,config)
                        end,
                        Visible = function(self,value)
                            Toggle.Visible = value;
                        end,
                    }
                end;

                function SectionSignal:AddLabel(name)
                    local Label = Instance.new("TextLabel")
                    table.insert(itemForSearch,{
                        Frame = Label,
                        Name = name
                    })
                    Label.Name = NeverZen:RandomString()
                    Label.Parent = Section
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Label.BackgroundTransparency = 1.000
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Label.BorderSizePixel = 0
                    Label.Size = UDim2.new(1, -10, 0, 20)
                    Label.ZIndex = 5
                    Label.Font = Enum.Font.GothamBold
                    Label.Text = name
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 13.000
                    Label.TextTransparency = 0.200
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    return {
                        SetValue = function(self,newvalue)
                            Label.Text = newvalue
                        end,
                        Visible = function(self,value)
                            Label.Visible = value;
                        end,
                    }
                end;

                function SectionSignal:AddButton(config)
                    config = config or {};
                    config.Name = config.Name or "Button";
                    config.Callback = config.Callback or function() end;

                    local Button = Instance.new("Frame")
                    local Label = Instance.new("TextLabel")
                    local UICorner = Instance.new("UICorner")
                    local UIStroke = Instance.new("UIStroke")

                    table.insert(itemForSearch,{
                        Frame = Button,
                        Name = config.Name
                    })

                    Button.Name = NeverZen:RandomString()
                    Button.Parent = Section
                    Button.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                    Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Button.BorderSizePixel = 0
                    Button.Size = UDim2.new(1, -10, 0, 25)

                    Label.Name = "Label"
                    Label.Parent = Button
                    Label.AnchorPoint = Vector2.new(0.5, 0.5)
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Label.BackgroundTransparency = 1.000
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Label.BorderSizePixel = 0
                    Label.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Label.Size = UDim2.new(1, -25, 0.649999976, 0)
                    Label.Font = Enum.Font.GothamMedium
                    Label.Text = config.Name
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 14.000
                    Label.TextTransparency = 0.100

                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = Button

                    UIStroke.Color = NeverZen.Theme.StrokeColor
                    UIStroke.Parent = Button

                    local button = NeverZen:NewInput(Button,function()
                        if not Content.Enabled or not Content.Parent then
                            return;
                        end;
                        config.Callback(config);
                    end)

                    button.MouseEnter:Connect(function()
                        TweenService:Create(Button,TweenInfo.new(0.1),{
                            BackgroundColor3 = NeverZen.Theme.Hightlight
                        }):Play()
                    end)

                    button.MouseLeave:Connect(function()
                        TweenService:Create(Button,TweenInfo.new(0.1),{
                            BackgroundColor3 = NeverZen.Theme.BackgroundColor
                        }):Play()
                    end)

                    return {
                        SetText = function(self,newvalue)
                            Label.Text = newvalue
                        end,
                        Fire = config.Callback,
                        Visible = function(self,value)
                            Button.Visible = value;
                        end,
                    };
                end;

                function SectionSignal:AddSlider(config)
                    config = config or {};
                    config.Name = config.Name or "Slider"
                    config.Min = config.Min or 0;
                    config.Max = config.Max or 100;
                    config.Default = config.Default or config.Min;
                    config.Round = config.Round or 0;
                    config.Type = config.Type or "";
                    config.Callback = config.Callback or function() end;

                    local Slider = Instance.new("Frame")
                    local value = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local LabelValue = Instance.new("TextBox")
                    local UIStroke = Instance.new("UIStroke")
                    local Label = Instance.new("TextLabel")
                    local con = Instance.new("Frame")
                    local UICorner_2 = Instance.new("UICorner")
                    local UIStroke_2 = Instance.new("UIStroke")
                    local block = Instance.new("Frame")
                    local UICorner_3 = Instance.new("UICorner")
                    local move = Instance.new("Frame")
                    local UICorner_4 = Instance.new("UICorner")

                    table.insert(itemForSearch,{
                        Frame = Slider,
                        Name = config.Name
                    })

                    Slider.Name = NeverZen:RandomString()
                    Slider.Parent = Section
                    Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Slider.BackgroundTransparency = 1.000
                    Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Slider.BorderSizePixel = 0
                    Slider.Size = UDim2.new(1, -5, 0, 22)

                    value.Name = "value"
                    value.Parent = Slider
                    value.AnchorPoint = Vector2.new(1, 0.5)
                    value.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                    value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    value.BorderSizePixel = 0
                    value.Position = UDim2.new(1, -3, 0.5, 0)
                    value.Size = UDim2.new(0, 35, 0, 15)

                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = value

                    LabelValue.Name = "LabelValue"
                    LabelValue.Parent = value
                    LabelValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    LabelValue.BackgroundTransparency = 1.000
                    LabelValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    LabelValue.BorderSizePixel = 0
                    LabelValue.Size = UDim2.new(1, 0, 1, 0)
                    LabelValue.Font = Enum.Font.GothamMedium
                    LabelValue.Text = tostring(config.Default)..tostring(config.Type)
                    LabelValue.TextColor3 = Color3.fromRGB(255, 255, 255)
                    LabelValue.TextSize = 10.000
                    LabelValue.TextTransparency = 0.250
                    LabelValue.ClearTextOnFocus = false
                    LabelValue.MultiLine = false
                    LabelValue.TextEditable = true
                    LabelValue.ZIndex = 20

                    UIStroke.Color = NeverZen.Theme.StrokeColor
                    UIStroke.Parent = value
                    value.Active = false

                    Label.Name = "Label"
                    Label.Parent = Slider
                    Label.AnchorPoint = Vector2.new(0, 0.5)
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Label.BackgroundTransparency = 1.000
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Label.BorderSizePixel = 0
                    Label.Position = UDim2.new(0, 5, 0.5, 0)
                    Label.Size = UDim2.new(1, -40, 0.649999976, 0)
                    Label.Font = Enum.Font.GothamMedium
                    Label.Text = config.Name
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 14.000
                    Label.TextTransparency = 0.250
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    con.Name = "con"
                    con.Parent = Slider
                    con.AnchorPoint = Vector2.new(1, 0.5)
                    con.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                    con.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    con.BorderSizePixel = 0
                    con.Position = UDim2.new(1, -40, 0.5, 0)
                    con.Size = UDim2.new(1, -140, 1, -1)

                    UICorner_2.CornerRadius = UDim.new(1, 0)
                    UICorner_2.Parent = con

                    UIStroke_2.Color = NeverZen.Theme.StrokeColor
                    UIStroke_2.Parent = con

                    local hitArea = Instance.new("Frame")
                    hitArea.Name = "hitArea"
                    hitArea.Parent = con
                    hitArea.BackgroundTransparency = 1
                    hitArea.AnchorPoint = Vector2.new(0.5, 0.5)
                    hitArea.Position = UDim2.new(0.5, 0, 0.5, 0)
                    hitArea.Size = UDim2.new(1, 0, 0, UserInputService.TouchEnabled and 44 or 20)
                    hitArea.ZIndex = con.ZIndex + 5

                    block.Name = "block"
                    block.Parent = con
                    block.BackgroundColor3 = NeverZen.Theme.Hightlight
                    block.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    NeverZen:BindChroma(block, "BackgroundColor3", 0.10)
                    block.BorderSizePixel = 0
                    block.Size = UDim2.new(((config.Default - config.Min) / (config.Max - config.Min)), 0, 1, 0)
                    block.ZIndex = 15
                    block.Active = true

                    UICorner_3.CornerRadius = UDim.new(1, 0)
                    UICorner_3.Parent = block

                    move.Name = "move"
                    move.Parent = block
                    move.AnchorPoint = Vector2.new(0.5, 0.5)
                    move.BackgroundColor3 = NeverZen.Theme.Hightlight
                    move.BackgroundTransparency = 1
                    move.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    move.BorderSizePixel = 0
                    move.Position = UDim2.new(1, 0, 0.5, 0)
                    move.Size = UDim2.new(2, 0, 2, 0)
                    move.SizeConstraint = Enum.SizeConstraint.RelativeYY

                    UICorner_4.CornerRadius = UDim.new(1, 0)
                    UICorner_4.Parent = move

                    local IsHold = false;

                    local updateSIZE = function()
                        local test = "2."..string.rep("4",(config.Round or 0) + 1)..tostring(config.Type);
                        local scale = TextService:GetTextSize(test,LabelValue.TextSize,LabelValue.Font,Vector2.new(math.huge,math.huge));
                        local scalelab = TextService:GetTextSize(Label.Text,Label.TextSize,Label.Font,Vector2.new(math.huge,math.huge));
                        local valueWidth = math.max(scale.X + 10, 35)
                        local labelWidth = scalelab.X + 10
                        value.Size = UDim2.new(0, valueWidth, 0, 15)
                        con.Position = UDim2.new(1, -(valueWidth + 8), 0.5, 0)
                        con.Size = UDim2.new(1, -(labelWidth + valueWidth + 15), 0.200000003, 0)
                    end

                    updateSIZE()

                    local function update(Input)
                        local SizeScale = math.clamp((((Input.Position.X) - con.AbsolutePosition.X) / con.AbsoluteSize.X), 0, 1);
                        local Main = ((config.Max - config.Min) * SizeScale) + config.Min;
                        local Value = NeverZen:Rounding(Main,config.Round);
                        local normalized = (Value - config.Min) / (config.Max - config.Min);
                        TweenService:Create(block , TweenInfo.new(0.04),{
                            Size = UDim2.new(normalized, 0, 1, 0)
                        }):Play();
                        LabelValue.Text = tostring(Value)..tostring(config.Type)
                        config.Default = Value
                        updateSIZE()
                        config.Callback(Value,config)
                    end;

                    local function applyTypedValue(raw)
                        local cleaned = tostring(raw or ""):gsub("[^%d%.%-]", "")
                        local typed = tonumber(cleaned)
                        if not typed then
                            LabelValue.Text = tostring(config.Default)..tostring(config.Type)
                            updateSIZE()
                            return
                        end
                        local Value = NeverZen:Rounding(math.clamp(typed, config.Min, config.Max), config.Round)
                        config.Default = Value
                        local normalized = (Value - config.Min) / (config.Max - config.Min)
                        TweenService:Create(block, TweenInfo.new(0.08), {
                            Size = UDim2.new(normalized, 0, 1, 0)
                        }):Play()
                        LabelValue.Text = tostring(Value)..tostring(config.Type)
                        updateSIZE()
                        config.Callback(Value, config)
                    end

                    LabelValue.Focused:Connect(function()
                        IsHold = false
                        LabelValue.Text = tostring(config.Default)
                    end)

                    LabelValue.FocusLost:Connect(function()
                        applyTypedValue(LabelValue.Text)
                    end)

                    local function onInputBegan(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            if LabelValue:IsFocused() then return end
                            IsHold = true
                            update(Input)
                        end
                    end

                    con.InputBegan:Connect(onInputBegan)
                    hitArea.InputBegan:Connect(onInputBegan)

                    NeverZen:Track(UserInputService.InputEnded:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            IsHold = false
                        end
                    end))

                    NeverZen:Track(UserInputService.InputChanged:Connect(function(Input)
                        if IsHold then
                            if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                                update(Input)
                            end
                        end
                    end));

                    return {
                        SetValue = function(self,newvalue)
                            config.Default = newvalue;
                            block.Size = UDim2.new(((config.Default - config.Min) / (config.Max - config.Min)), 0, 1, 0)
                            LabelValue.Text = tostring(config.Default)..tostring(config.Type)
                            updateSIZE()
                        end,
                        Fire = config.Callback,
                        Visible = function(self,value)
                            Slider.Visible = value;
                        end,
                    };
                end;

                function SectionSignal:AddKeybind(config)
                    config = config or {};
                    config.Name = config.Name or "Keybind";
                    config.Default = config.Default or nil;
                    config.Callback = config.Callback or function() end;

                    local Keys = {
                        One = '1',
                        Two = '2',
                        Three = '3',
                        Four = '4',
                        Five = '5',
                        Six = '6',
                        Seven = '7',
                        Eight = '8',
                        Nine = '9',
                        Zero = '0',
                        ['Minus'] = "-",
                        ['Plus'] = "+",
                        BackSlash = "\\",
                        Slash = "/",
                        Period = '.',
                        Semicolon = ';',
                        Colon = ":",
                        LeftControl = "LCtrl",
                        RightControl = "RCtrl",
                        LeftShift = "LShift",
                        RightShift = "RShift",
                    };

                    local GetItem = function(item)
                        if item then
                            if typeof(item) == 'EnumItem' then
                                return Keys[item.Name] or item.Name;
                            else
                                return Keys[tostring(item)] or string.upper(tostring(item))
                            end;
                        else
                            return 'NONE';
                        end;
                    end;

                    local Keybind = Instance.new("Frame")
                    local sys = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local value = Instance.new("TextLabel")
                    local UIStroke = Instance.new("UIStroke")
                    local Label = Instance.new("TextLabel")

                    table.insert(itemForSearch,{
                        Frame = Keybind,
                        Name = config.Name
                    })

                    Keybind.Name = NeverZen:RandomString()
                    Keybind.Parent = Section
                    Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Keybind.BackgroundTransparency = 1.000
                    Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Keybind.BorderSizePixel = 0
                    Keybind.Size = UDim2.new(1, -5, 0, 25)

                    sys.Name = "sys"
                    sys.Parent = Keybind
                    sys.AnchorPoint = Vector2.new(1, 0.5)
                    sys.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                    sys.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    sys.BorderSizePixel = 0
                    sys.Position = UDim2.new(1, -3, 0.5, 0)
                    sys.Size = UDim2.new(0, 25, 0, 15)

                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = sys

                    value.Name = "value"
                    value.Parent = sys
                    value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    value.BackgroundTransparency = 1.000
                    value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    value.BorderSizePixel = 0
                    value.Size = UDim2.new(1, 0, 1, 0)
                    value.Font = Enum.Font.GothamMedium
                    value.Text = GetItem(config.Default)
                    value.TextColor3 = NeverZen.Theme.Hightlight;
                    NeverZen:BindChroma(value, "TextColor3", 0.15)
                    value.TextSize = 12.000
                    value.TextTransparency = 0.250

                    UIStroke.Color = NeverZen.Theme.StrokeColor
                    UIStroke.Parent = sys

                    Label.Name = "Label"
                    Label.Parent = Keybind
                    Label.AnchorPoint = Vector2.new(0, 0.5)
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Label.BackgroundTransparency = 1.000
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Label.BorderSizePixel = 0
                    Label.Position = UDim2.new(0, 5, 0.5, 0)
                    Label.Size = UDim2.new(1, -25, 0.649999976, 0)
                    Label.Font = Enum.Font.GothamMedium
                    Label.Text = config.Name
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 14.000
                    Label.TextTransparency = 0.250
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    local UpdateScale = function()
                        local BindLabelScale = TextService:GetTextSize(value.Text,value.TextSize,value.Font,Vector2.new(math.huge,math.huge));
                        TweenService:Create(sys,TweenInfo.new(0.1),{
                            Size = UDim2.new(0, BindLabelScale.X + 10, 0, 15)
                        }):Play();
                    end;

                    UpdateScale();

                    local Button = NeverZen:NewInput(Keybind);
                    local IsBinding = false;

                    Button.MouseButton1Click:Connect(function()
                        if not Content.Enabled or not Content.Parent then
                            return;
                        end;
                        if IsBinding then return; end;
                        IsBinding = true;
                        value.Text = "...";
                        UpdateScale();
                        local Selected = nil;
                        while not Selected do
                            local Key = UserInputService.InputBegan:Wait();
                            if Key.KeyCode ~= Enum.KeyCode.Unknown then
                                Selected = Key.KeyCode;
                            end;
                        end;
                        config.Default = Selected;
                        value.Text = GetItem(Selected);
                        UpdateScale();
                        IsBinding = false;
                        config.Callback(Selected,config);
                    end)

                    return {
                        SetValue = function(self,newvalue)
                            config.Default = newvalue;
                            value.Text = GetItem(newvalue);
                            UpdateScale();
                            config.Callback(newvalue,config);
                        end,
                        Fire = config.Callback,
                        Visible = function(self,value)
                            Keybind.Visible = value;
                        end,
                    };
                end;

                function SectionSignal:AddInput(config)
                    config = config or {};
                    config.Name = config.Name or "Input";
                    config.Default = config.Default or "";
                    config.Placeholder = config.Placeholder or "Type here...";
                    config.ClearTextOnFocus = config.ClearTextOnFocus or false;
                    config.Callback = config.Callback or function() end;
                    config.FireOnEnter = config.FireOnEnter or false;
                    config.FireOnLostFocus = config.FireOnLostFocus or false;
                    config.Numeric = config.Numeric or false;
                    config.MaxLength = config.MaxLength or 100;

                    local Input = Instance.new("Frame");
                    local Label = Instance.new("TextLabel");
                    local inputFrame = Instance.new("Frame");
                    local UICorner = Instance.new("UICorner");
                    local UIStroke = Instance.new("UIStroke");
                    local textBox = Instance.new("TextBox");
                    local UICorner_2 = Instance.new("UICorner");

                    table.insert(itemForSearch, {
                        Frame = Input,
                        Name = config.Name
                    });

                    Input.Name = NeverZen:RandomString();
                    Input.Parent = Section;
                    Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    Input.BackgroundTransparency = 1.000;
                    Input.BorderColor3 = Color3.fromRGB(0, 0, 0);
                    Input.BorderSizePixel = 0;
                    Input.Size = UDim2.new(1, -5, 0, 25);

                    Label.Name = NeverZen:RandomString();
                    Label.Parent = Input;
                    Label.AnchorPoint = Vector2.new(0, 0.5);
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    Label.BackgroundTransparency = 1.000;
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0);
                    Label.BorderSizePixel = 0;
                    Label.Position = UDim2.new(0, 5, 0.5, 0);
                    Label.Size = UDim2.new(0, 80, 0.649999976, 0);
                    Label.Font = Enum.Font.GothamMedium;
                    Label.Text = config.Name;
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255);
                    Label.TextSize = 14.000;
                    Label.TextTransparency = 0.250;
                    Label.TextXAlignment = Enum.TextXAlignment.Left;

                    inputFrame.Name = NeverZen:RandomString();
                    inputFrame.Parent = Input;
                    inputFrame.AnchorPoint = Vector2.new(1, 0.5);
                    inputFrame.BackgroundColor3 = NeverZen.Theme.BackgroundColor;
                    inputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0);
                    inputFrame.BorderSizePixel = 0;
                    inputFrame.Position = UDim2.new(1, -3, 0.5, 0);
                    inputFrame.Size = UDim2.new(1, -85, 0, 15);

                    UICorner.CornerRadius = UDim.new(0, 4);
                    UICorner.Parent = inputFrame;

                    UIStroke.Color = NeverZen.Theme.StrokeColor;
                    UIStroke.Parent = inputFrame;

                    textBox.Name = NeverZen:RandomString();
                    textBox.Parent = inputFrame;
                    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    textBox.BackgroundTransparency = 1.000;
                    textBox.BorderColor3 = Color3.fromRGB(0, 0, 0);
                    textBox.BorderSizePixel = 0;
                    textBox.Position = UDim2.new(0, 2, 0, 0);
                    textBox.Size = UDim2.new(1, -4, 1, 0);
                    textBox.Font = Enum.Font.GothamMedium;
                    textBox.Text = config.Default;
                    textBox.TextColor3 = Color3.fromRGB(255, 255, 255);
                    textBox.TextSize = 12.000;
                    textBox.TextTransparency = 0.250;
                    textBox.TextXAlignment = Enum.TextXAlignment.Left;
                    textBox.PlaceholderText = config.Placeholder;
                    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150);
                    textBox.ClearTextOnFocus = config.ClearTextOnFocus;
                    textBox.MaxVisibleGraphemes = config.MaxLength;

                    if config.Numeric then
                        textBox.Text = tostring(config.Default);
                        textBox:GetPropertyChangedSignal("Text"):Connect(function()
                            local text = textBox.Text
                            local filteredText = ""
                            for i = 1, #text do
                                local char = text:sub(i, i)
                                if char:match("[0-9]") or char == "." or (char == "-" and i == 1) then
                                    filteredText = filteredText .. char
                                end
                            end
                            if filteredText ~= text then
                                textBox.Text = filteredText
                            end
                        end)
                    end

                    UICorner_2.CornerRadius = UDim.new(0, 3);
                    UICorner_2.Parent = textBox;

                    local function fireCallback()
                        if config.Numeric then
                            local numValue = tonumber(textBox.Text) or 0
                            config.Callback(numValue, config)
                        else
                            config.Callback(textBox.Text, config)
                        end
                    end

                    local isFocused = false

                    textBox.Focused:Connect(function()
                        isFocused = true
                        TweenService:Create(inputFrame, TweenInfo.new(0.2), {
                            BackgroundColor3 = NeverZen.Theme.BackgroundColor2
                        }):Play()
                        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
                            Color = NeverZen.Theme.Hightlight
                        }):Play()
                        TweenService:Create(textBox, TweenInfo.new(0.2), {
                            TextTransparency = 0.1
                        }):Play()
                    end)

                    textBox.FocusLost:Connect(function(enterPressed)
                        isFocused = false
                        TweenService:Create(inputFrame, TweenInfo.new(0.2), {
                            BackgroundColor3 = NeverZen.Theme.BackgroundColor
                        }):Play()
                        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
                            Color = NeverZen.Theme.StrokeColor
                        }):Play()
                        TweenService:Create(textBox, TweenInfo.new(0.2), {
                            TextTransparency = 0.250
                        }):Play()
                        if config.FireOnLostFocus or (enterPressed and config.FireOnEnter) then
                            fireCallback()
                        end
                    end)

                    if not config.Numeric then
                        textBox:GetPropertyChangedSignal("Text"):Connect(function()
                            if not config.FireOnLostFocus and not config.FireOnEnter then
                                fireCallback()
                            end
                        end)
                    else
                        if not config.FireOnLostFocus and not config.FireOnEnter then
                            textBox:GetPropertyChangedSignal("Text"):Connect(function()
                                fireCallback()
                            end)
                        end
                    end

                    textBox.FocusLost:Connect(function(enterPressed)
                        if enterPressed and config.FireOnEnter then
                            fireCallback()
                        end
                    end)

                    return {
                        SetValue = function(self, value)
                            textBox.Text = tostring(value)
                            if not config.FireOnLostFocus and not config.FireOnEnter then
                                fireCallback()
                            end
                        end,
                        GetValue = function(self)
                            if config.Numeric then
                                return tonumber(textBox.Text) or 0
                            else
                                return textBox.Text
                            end
                        end,
                        SetPlaceholder = function(self, placeholder)
                            config.Placeholder = placeholder
                            textBox.PlaceholderText = placeholder
                        end,
                        Clear = function(self)
                            textBox.Text = ""
                        end,
                        Focus = function(self)
                            textBox:CaptureFocus()
                        end,
                        SetLabel = function(self, newLabel)
                            config.Name = newLabel
                            Label.Text = newLabel
                        end,
                        SetMaxLength = function(self, maxLength)
                            config.MaxLength = maxLength
                            textBox.MaxVisibleGraphemes = maxLength
                        end,
                        SetNumeric = function(self, isNumeric)
                            config.Numeric = isNumeric
                            if isNumeric then
                                local currentText = textBox.Text
                                local filteredText = ""
                                for i = 1, #currentText do
                                    local char = currentText:sub(i, i)
                                    if char:match("[0-9]") or char == "." or (char == "-" and i == 1) then
                                        filteredText = filteredText .. char
                                    end
                                end
                                textBox.Text = filteredText
                            end
                        end,
                        Disable = function(self)
                            textBox.TextEditable = false
                            textBox.ClearTextOnFocus = false
                            TweenService:Create(textBox, TweenInfo.new(0.2), {
                                TextTransparency = 0.5
                            }):Play()
                            TweenService:Create(Label, TweenInfo.new(0.2), {
                                TextTransparency = 0.5
                            }):Play()
                        end,
                        Enable = function(self)
                            textBox.TextEditable = true
                            textBox.ClearTextOnFocus = config.ClearTextOnFocus
                            TweenService:Create(textBox, TweenInfo.new(0.2), {
                                TextTransparency = 0.250
                            }):Play()
                            TweenService:Create(Label, TweenInfo.new(0.2), {
                                TextTransparency = 0.250
                            }):Play()
                        end,
                        Visible = function(self, value)
                            Input.Visible = value
                        end,
                        Fire = config.Callback,
                        FireCallback = fireCallback
                    };
                end;

                function SectionSignal:AddDropdown(config)
                    config = config or {};
                    config.Name = config.Name or "Dropdown";
                    config.Values = config.Values or {};
                    config.Default = config.Default or {};
                    config.Multi = config.Multi or false;
                    config.Callback = config.Callback or function() end;

                    local parse = function(value)
                        if not value then return 'NONE' end;
                        if typeof(value) == 'table' then
                            if #value > 0 then
                                local x = {};
                                for i,v in next , value do
                                    table.insert(x , tostring(v))
                                end;
                                return table.concat(x,' , ')
                            else
                                local x = {};
                                for i,v in next , value do
                                    if v == true then
                                        table.insert(x , tostring(i))
                                    end
                                end;
                                return table.concat(x,' , ')
                            end;
                        else
                            return tostring(value);
                        end;
                    end;

                    local Dropown = Instance.new("Frame")
                    local sys = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local value = Instance.new("TextLabel")
                    local UIStroke = Instance.new("UIStroke")
                    local Label = Instance.new("TextLabel")

                    table.insert(itemForSearch,{
                        Frame = Dropown,
                        Name = config.Name
                    })

                    Dropown.Name = NeverZen:RandomString()
                    Dropown.Parent = Section
                    Dropown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Dropown.BackgroundTransparency = 1.000
                    Dropown.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Dropown.BorderSizePixel = 0
                    Dropown.Size = UDim2.new(1, -5, 0, 25)

                    sys.Name = NeverZen:RandomString()
                    sys.Parent = Dropown
                    sys.AnchorPoint = Vector2.new(1, 0.5)
                    sys.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                    sys.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    sys.BorderSizePixel = 0
                    sys.Position = UDim2.new(1, -3, 0.5, 0)
                    sys.Size = UDim2.new(0, 55, 0, 15)

                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = sys

                    value.Name = NeverZen:RandomString()
                    value.Parent = sys
                    value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    value.BackgroundTransparency = 1.000
                    value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    value.BorderSizePixel = 0
                    value.Size = UDim2.new(1, 0, 1, 0)
                    value.Font = Enum.Font.GothamMedium
                    value.Text = parse(config.Default)
                    value.TextColor3 = Color3.fromRGB(255, 255, 255)
                    value.TextSize = 12.000
                    value.TextTransparency = 0.250

                    UIStroke.Color = NeverZen.Theme.StrokeColor
                    UIStroke.Parent = sys

                    Label.Name = NeverZen:RandomString()
                    Label.Parent = Dropown
                    Label.AnchorPoint = Vector2.new(0, 0.5)
                    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Label.BackgroundTransparency = 1.000
                    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Label.BorderSizePixel = 0
                    Label.Position = UDim2.new(0, 5, 0.5, 0)
                    Label.Size = UDim2.new(1, -25, 0.649999976, 0)
                    Label.Font = Enum.Font.GothamMedium
                    Label.Text = config.Name
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 14.000
                    Label.TextTransparency = 0.250
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    local DropdownItems = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local UIStroke = Instance.new("UIStroke")
                    local Scroll = Instance.new("ScrollingFrame")
                    local UIListLayout = Instance.new("UIListLayout")
                    local DropShadow = Instance.new("ImageLabel")

                    DropdownItems.Name = NeverZen:RandomString()
                    DropdownItems.Parent = Content
                    DropdownItems.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
                    DropdownItems.BackgroundTransparency = 0.050
                    DropdownItems.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    DropdownItems.BorderSizePixel = 0
                    DropdownItems.ClipsDescendants = true
                    DropdownItems.Position = UDim2.new(0.518932879, 0, 0.54108721, 0)
                    DropdownItems.Size = UDim2.new(0, 165, 0, 0)
                    DropdownItems.ZIndex = 100
                    DropdownItems.Visible = false

                    table.insert(WindowSignal.FrameMemory.WindowBackgroundColor , DropdownItems)

                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = DropdownItems

                    UIStroke.Color = NeverZen.Theme.BackgroundColor
                    UIStroke.Parent = DropdownItems

                    Scroll.Name = NeverZen:RandomString()
                    Scroll.Parent = DropdownItems
                    Scroll.Active = true
                    Scroll.AnchorPoint = Vector2.new(0.5, 0.5)
                    Scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Scroll.BackgroundTransparency = 1.000
                    Scroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Scroll.BorderSizePixel = 0
                    Scroll.ClipsDescendants = false
                    Scroll.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Scroll.Size = UDim2.new(1, -5, 1, -5)
                    Scroll.ZIndex = 101
                    Scroll.ScrollBarThickness = 0

                    UIListLayout.Parent = Scroll
                    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    UIListLayout.Padding = UDim.new(0, 5)

                    UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function(...)
                        Scroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 2)
                    end)

                    DropShadow.Name = NeverZen:RandomString()
                    DropShadow.Parent = DropdownItems
                    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
                    DropShadow.BackgroundTransparency = 1.000
                    DropShadow.BorderSizePixel = 0
                    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
                    DropShadow.Rotation = 0.000
                    DropShadow.Size = UDim2.new(1, 47, 1, 47)
                    DropShadow.ZIndex = 99
                    DropShadow.Image = "rbxassetid://6015897843"
                    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                    DropShadow.ImageTransparency = 0.500
                    DropShadow.ScaleType = Enum.ScaleType.Slice
                    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

                    DropdownItems:GetPropertyChangedSignal('Size'):Connect(function()
                        if DropdownItems.Size.Y.Offset < 5 then
                            DropdownItems.Visible = false
                        else
                            DropdownItems.Visible = true
                        end
                    end);

                    local Icons = {
                        Selected = "rbxassetid://10734923868",
                        Normal = "rbxassetid://10734895856"
                    }

                    local update = function()
                        local scale = TextService:GetTextSize(value.Text,value.TextSize,value.Font,Vector2.new(math.huge,math.huge));
                        TweenService:Create(sys , TweenInfo.new(0.1),{
                            Size = UDim2.new(0, scale.X + 10, 0, 15)
                        }):Play()
                    end;

                    update()

                    NeverZen:Track(UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType ~= Enum.UserInputType.MouseButton1 or input.UserInputType ~= Enum.UserInputType.Touch then
                            if not NeverZen:IsMouseOverFrame(DropdownItems) then
                                TweenService:Create(DropdownItems,TweenInfo.new(0.1),{
                                    Size = UDim2.new(0, 165, 0, 0)
                                }):Play()
                                DropdownItems:SetAttribute('OPENED',false)
                            end;
                        end;
                    end))

                    NeverZen:Track(RunService.Stepped:Connect(function()
                        if DropdownItems:GetAttribute('OPENED') then
                            TweenService:Create(DropdownItems,TweenInfo.new(0.1),{
                                Position = UDim2.fromOffset(sys.AbsolutePosition.X - (DropdownItems.AbsoluteSize.X / 2),sys.AbsolutePosition.Y),
                                Size = UDim2.new(0, 165, 0, math.clamp(UIListLayout.AbsoluteContentSize.Y + 5, 15 , 150))
                            }):Play()
                        else
                            DropdownItems.Position = UDim2.fromOffset(sys.AbsolutePosition.X - (DropdownItems.AbsoluteSize.X / 2),sys.AbsolutePosition.Y)
                        end;
                    end));

                    local CreateButton = function(name,val)
                        local Selected = Instance.new("Frame")
                        local Icon = Instance.new("ImageLabel")
                        local Label = Instance.new("TextLabel")
                        local UIStroke = Instance.new("UIStroke")
                        local UICorner = Instance.new("UICorner")

                        Selected.Name = NeverZen:RandomString()
                        Selected.Parent = Scroll
                        Selected.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
                        Selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        Selected.BorderSizePixel = 0
                        Selected.Size = UDim2.new(1, 0, 0, 25)
                        Selected.ZIndex = 102

                        Icon.Name = NeverZen:RandomString()
                        Icon.Parent = Selected
                        Icon.AnchorPoint = Vector2.new(0, 0.5)
                        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Icon.BackgroundTransparency = 1.000
                        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        Icon.BorderSizePixel = 0
                        Icon.Position = UDim2.new(0, 2, 0.5, 0)
                        Icon.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
                        Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
                        Icon.ZIndex = 102
                        Icon.ImageTransparency = 0.500

                        Label.Name = NeverZen:RandomString()
                        Label.Parent = Selected
                        Label.AnchorPoint = Vector2.new(0, 0.5)
                        Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Label.BackgroundTransparency = 1.000
                        Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        Label.BorderSizePixel = 0
                        Label.Position = UDim2.new(0, 25, 0.5, 0)
                        Label.Size = UDim2.new(1, -25, 0.649999976, 0)
                        Label.ZIndex = 102
                        Label.Font = Enum.Font.GothamMedium
                        Label.Text = tostring(name)
                        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Label.TextSize = 12.000
                        Label.TextTransparency = 0.500
                        Label.TextXAlignment = Enum.TextXAlignment.Left

                        UIStroke.Transparency = 0.850
                        UIStroke.Color = NeverZen.Theme.StrokeColor2
                        UIStroke.Parent = Selected

                        UICorner.CornerRadius = UDim.new(0, 4)
                        UICorner.Parent = Selected

                        return Selected , Icon
                    end;

                    local refresh = function()
                        for i,v in next , Scroll:GetChildren() do
                            if v:IsA('Frame') then
                                v:Destroy()
                            end;
                        end;

                        local valueBl = (typeof(config.Default) == 'table' and table.clone(config.Default)) or config.Default;
                        local old_call;

                        if config.Multi then
                            if typeof(valueBl) == 'table' and #valueBl > 0 then
                                local fake = {};
                                for i,v in next , valueBl do
                                    fake[v] = true;
                                end;
                                table.clear(valueBl)
                                valueBl = {};
                                valueBl = fake;
                            end;
                        end;

                        config.Default = valueBl;

                        for i,v in next,config.Values do
                            local IsDefault = config.Default == v or (typeof(valueBl) == 'table' and (config.Default[v] or table.find(config.Default,v)));
                            local Selected , Icon = CreateButton(v,IsDefault);

                            local effect = function(val)
                                local x = TweenService:Create(Icon,TweenInfo.new(0.4),{
                                    Rotation = (val and 180) or -180
                                });
                                x:Play()
                                x.Completed:Connect(function()
                                    Icon.Rotation = 0
                                end)
                            end;

                            local call = function(v)
                                if v then
                                    if Icon.Image ~= Icons.Selected then
                                        effect(true)
                                    end
                                    Icon.Image = Icons.Selected
                                    Icon.ImageTransparency = 0.1
                                    Icon.ImageColor3 = NeverZen.Theme.Hightlight;
                                else
                                    if Icon.Image ~= Icons.Normal then
                                        effect(false)
                                    end
                                    Icon.Image = Icons.Normal
                                    Icon.ImageTransparency = 0.5
                                    Icon.ImageColor3 = Color3.fromRGB(255, 255, 255);
                                end;
                            end;

                            if IsDefault then
                                old_call = call;
                                call(true)
                            else
                                call(false)
                            end;

                            NeverZen:NewInput(Selected,function()
                                if not Content.Enabled or not Content.Parent then
                                    return;
                                end;
                                if config.Multi then
                                    config.Default[v] = not (config.Default[v] or table.find(config.Default,v));
                                    call(config.Default[v])
                                    if #config.Default > 0 then
                                        for i,v in ipairs(config.Default) do
                                            table.remove(config.Default,i)
                                        end
                                    end;
                                    value.Text = parse(config.Default)
                                    update()
                                    config.Callback(config.Default)
                                else
                                    config.Default = v;
                                    if old_call then
                                        old_call(false)
                                    end;
                                    call(true)
                                    old_call = call;
                                    value.Text = parse(config.Default)
                                    update()
                                    config.Callback(config.Default)
                                end;
                            end);
                        end;
                    end;

                    local upd = NeverZen:NewInput(Dropown);

                    DropdownItems:SetAttribute('OPENED',false)

                    upd.MouseButton1Click:Connect(function()
                        if not Content.Enabled or not Content.Parent then
                            return;
                        end;
                        DropdownItems:SetAttribute('OPENED',true)
                        TweenService:Create(DropdownItems,TweenInfo.new(0.1),{
                            Size = UDim2.new(0, 165, 0, math.clamp(UIListLayout.AbsoluteContentSize.Y , 15 , 150))
                        }):Play()
                        refresh()
                    end);

                    return {
                        SetValue = function(self,newvalue)
                            config.Default = newvalue;
                            value.Text = parse(newvalue)
                            update();
                        end,
                        SetValues = function(self , new)
                            config.Values = new
                        end,
                        Fire = config.Callback,
                        Visible = function(self,value)
                            Dropown.Visible = value;
                        end,
                    };
                end;

                function SectionSignal:AddColorPicker(config)
                    config = config or {};
                    config.Name = config.Name or "Color";
                    config.Default = config.Default or Color3.fromRGB(255, 255, 255);
                    config.Callback = config.Callback or function() end;

                    local currentColor = config.Default;

                    local Row = Instance.new("Frame")
                    local Label = Instance.new("TextLabel")
                    local Swatch = Instance.new("Frame")
                    local UICorner_sw = Instance.new("UICorner")
                    local UIStroke_sw = Instance.new("UIStroke")

                    table.insert(itemForSearch, { Frame = Row, Name = config.Name })

                    Row.Name = NeverZen:RandomString()
                    Row.Parent = Section
                    Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Row.BackgroundTransparency = 1
                    Row.BorderSizePixel = 0
                    Row.Size = UDim2.new(1, -5, 0, 25)

                    Label.Parent = Row
                    Label.AnchorPoint = Vector2.new(0, 0.5)
                    Label.BackgroundTransparency = 1
                    Label.BorderSizePixel = 0
                    Label.Position = UDim2.new(0, 5, 0.5, 0)
                    Label.Size = UDim2.new(1, -35, 0.65, 0)
                    Label.Font = Enum.Font.GothamMedium
                    Label.Text = config.Name
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 14
                    Label.TextTransparency = 0.25
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    Swatch.Name = "Swatch"
                    Swatch.Parent = Row
                    Swatch.AnchorPoint = Vector2.new(1, 0.5)
                    Swatch.BackgroundColor3 = currentColor
                    Swatch.BorderSizePixel = 0
                    Swatch.Position = UDim2.new(1, -3, 0.5, 0)
                    Swatch.Size = UDim2.new(0, 28, 0, 15)

                    UICorner_sw.CornerRadius = UDim.new(0, 4)
                    UICorner_sw.Parent = Swatch

                    UIStroke_sw.Color = NeverZen.Theme.StrokeColor
                    UIStroke_sw.Parent = Swatch

                    local Picker = Instance.new("Frame")
                    local UICorner_pk = Instance.new("UICorner")
                    local UIStroke_pk = Instance.new("UIStroke")
                    local SVField = Instance.new("Frame")
                    local SVWhite = Instance.new("UIGradient")
                    local SVBlack = Instance.new("Frame")
                    local SVBlackGrad = Instance.new("UIGradient")
                    local SVCursor = Instance.new("Frame")
                    local UICorner_svc = Instance.new("UICorner")
                    local HueBar = Instance.new("Frame")
                    local HueGrad = Instance.new("UIGradient")
                    local UICorner_hb = Instance.new("UICorner")
                    local HueCursor = Instance.new("Frame")
                    local UICorner_hc = Instance.new("UICorner")
                    local HexFrame = Instance.new("Frame")
                    local UICorner_hex = Instance.new("UICorner")
                    local UIStroke_hex = Instance.new("UIStroke")
                    local HexBox = Instance.new("TextBox")

                    Picker.Name = NeverZen:RandomString()
                    Picker.Parent = Content
                    Picker.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
                    Picker.BackgroundTransparency = 0.05
                    Picker.BorderSizePixel = 0
                    Picker.Size = UDim2.new(0, 165, 0, 175)
                    Picker.ZIndex = 200
                    Picker.Visible = false
                    Picker.ClipsDescendants = true

                    UICorner_pk.CornerRadius = UDim.new(0, 5)
                    UICorner_pk.Parent = Picker

                    UIStroke_pk.Color = NeverZen.Theme.BackgroundColor
                    UIStroke_pk.Parent = Picker

                    SVField.Name = "SVField"
                    SVField.Parent = Picker
                    SVField.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
                    SVField.BorderSizePixel = 0
                    SVField.Position = UDim2.new(0, 8, 0, 8)
                    SVField.Size = UDim2.new(1, -16, 0, 100)
                    SVField.ZIndex = 201
                    SVField.ClipsDescendants = true

                    local UICorner_svf = Instance.new("UICorner")
                    UICorner_svf.CornerRadius = UDim.new(0, 3)
                    UICorner_svf.Parent = SVField

                    SVWhite.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                        ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
                    }
                    SVWhite.Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    }
                    SVWhite.Rotation = 0
                    SVWhite.Parent = SVField

                    SVBlack.BackgroundColor3 = Color3.new(0,0,0)
                    SVBlack.BorderSizePixel = 0
                    SVBlack.Size = UDim2.fromScale(1,1)
                    SVBlack.ZIndex = 202
                    SVBlack.Parent = SVField

                    local UICorner_svb = Instance.new("UICorner")
                    UICorner_svb.CornerRadius = UDim.new(0, 3)
                    UICorner_svb.Parent = SVBlack

                    SVBlackGrad.Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                    SVBlackGrad.Rotation = 90
                    SVBlackGrad.Parent = SVBlack

                    SVCursor.BackgroundColor3 = Color3.new(1,1,1)
                    SVCursor.BorderSizePixel = 0
                    SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                    SVCursor.Size = UDim2.fromOffset(8, 8)
                    SVCursor.ZIndex = 205
                    SVCursor.Parent = SVField
                    UICorner_svc.CornerRadius = UDim.new(1,0)
                    UICorner_svc.Parent = SVCursor

                    local UIStroke_svc = Instance.new("UIStroke")
                    UIStroke_svc.Color = Color3.new(0,0,0)
                    UIStroke_svc.Thickness = 1.5
                    UIStroke_svc.Parent = SVCursor

                    HueBar.Parent = Picker
                    HueBar.BackgroundColor3 = Color3.new(1,1,1)
                    HueBar.BorderSizePixel = 0
                    HueBar.Position = UDim2.new(0, 8, 0, 116)
                    HueBar.Size = UDim2.new(1, -16, 0, 10)
                    HueBar.ZIndex = 201
                    UICorner_hb.CornerRadius = UDim.new(1, 0)
                    UICorner_hb.Parent = HueBar

                    HueGrad.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,1,1)),
                        ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),
                        ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),
                        ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,1,1)),
                        ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),
                        ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),
                        ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,1,1)),
                    }
                    HueGrad.Parent = HueBar

                    HueCursor.BackgroundColor3 = Color3.new(1,1,1)
                    HueCursor.BorderSizePixel = 0
                    HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                    HueCursor.Size = UDim2.fromOffset(6, 14)
                    HueCursor.Position = UDim2.new(0, 0, 0.5, 0)
                    HueCursor.ZIndex = 205
                    HueCursor.Parent = HueBar
                    UICorner_hc.CornerRadius = UDim.new(0, 2)
                    UICorner_hc.Parent = HueCursor

                    local UIStroke_hc = Instance.new("UIStroke")
                    UIStroke_hc.Color = Color3.new(0,0,0)
                    UIStroke_hc.Thickness = 1
                    UIStroke_hc.Parent = HueCursor

                    HexFrame.Parent = Picker
                    HexFrame.BackgroundColor3 = NeverZen.Theme.BackgroundColor
                    HexFrame.BorderSizePixel = 0
                    HexFrame.Position = UDim2.new(0, 8, 0, 134)
                    HexFrame.Size = UDim2.new(1, -16, 0, 16)
                    HexFrame.ZIndex = 201
                    UICorner_hex.CornerRadius = UDim.new(0, 4)
                    UICorner_hex.Parent = HexFrame
                    UIStroke_hex.Color = NeverZen.Theme.StrokeColor
                    UIStroke_hex.Parent = HexFrame

                    HexBox.Parent = HexFrame
                    HexBox.BackgroundTransparency = 1
                    HexBox.BorderSizePixel = 0
                    HexBox.Position = UDim2.new(0, 5, 0, 0)
                    HexBox.Size = UDim2.new(1, -10, 1, 0)
                    HexBox.Font = Enum.Font.GothamMedium
                    HexBox.Text = currentColor:ToHex():upper()
                    HexBox.TextColor3 = Color3.new(1,1,1)
                    HexBox.TextTransparency = 0.2
                    HexBox.TextSize = 11
                    HexBox.TextXAlignment = Enum.TextXAlignment.Left
                    HexBox.ZIndex = 202
                    HexBox.ClearTextOnFocus = false
                    HexBox.MaxVisibleGraphemes = 6

                    local PreviewRow = Instance.new("Frame")
                    PreviewRow.Parent = Picker
                    PreviewRow.BackgroundTransparency = 1
                    PreviewRow.BorderSizePixel = 0
                    PreviewRow.Position = UDim2.new(0, 8, 0, 156)
                    PreviewRow.Size = UDim2.new(1, -16, 0, 13)
                    PreviewRow.ZIndex = 201

                    local PreviewSwatch = Instance.new("Frame")
                    PreviewSwatch.Parent = PreviewRow
                    PreviewSwatch.BackgroundColor3 = currentColor
                    PreviewSwatch.BorderSizePixel = 0
                    PreviewSwatch.AnchorPoint = Vector2.new(1, 0.5)
                    PreviewSwatch.Position = UDim2.new(1, 0, 0.5, 0)
                    PreviewSwatch.Size = UDim2.fromOffset(28, 13)
                    PreviewSwatch.ZIndex = 202
                    local UICorner_pv = Instance.new("UICorner")
                    UICorner_pv.CornerRadius = UDim.new(0, 3)
                    UICorner_pv.Parent = PreviewSwatch

                    local RGBLabel = Instance.new("TextLabel")
                    RGBLabel.Parent = PreviewRow
                    RGBLabel.BackgroundTransparency = 1
                    RGBLabel.BorderSizePixel = 0
                    RGBLabel.AnchorPoint = Vector2.new(0, 0.5)
                    RGBLabel.Position = UDim2.new(0, 0, 0.5, 0)
                    RGBLabel.Size = UDim2.new(1, -36, 1, 0)
                    RGBLabel.Font = Enum.Font.GothamMedium
                    RGBLabel.TextColor3 = Color3.new(1,1,1)
                    RGBLabel.TextTransparency = 0.4
                    RGBLabel.TextSize = 10
                    RGBLabel.TextXAlignment = Enum.TextXAlignment.Left
                    RGBLabel.ZIndex = 202

                    local function colorToRGBStr(c)
                        return math.round(c.R*255)..", "..math.round(c.G*255)..", "..math.round(c.B*255)
                    end

                    local hue, sat, val = Color3.toHSV(currentColor)

                    local function applyColor(h, s, v)
                        hue, sat, val = h, s, v
                        currentColor = Color3.fromHSV(h, s, v)
                        Swatch.BackgroundColor3 = currentColor
                        PreviewSwatch.BackgroundColor3 = currentColor
                        SVField.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        HexBox.Text = currentColor:ToHex():upper()
                        RGBLabel.Text = colorToRGBStr(currentColor)
                        SVCursor.Position = UDim2.new(s, 0, 1-v, 0)
                        HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
                        config.Callback(currentColor, config)
                    end

                    applyColor(hue, sat, val)

                    local svDrag = false
                    local hueDrag = false

                    NeverZen:Track(SVField.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            svDrag = true
                            local rel = inp.Position - SVField.AbsolutePosition
                            local s2 = math.clamp(rel.X / SVField.AbsoluteSize.X, 0, 1)
                            local v2 = math.clamp(1 - (rel.Y / SVField.AbsoluteSize.Y), 0, 1)
                            applyColor(hue, s2, v2)
                        end
                    end))

                    NeverZen:Track(HueBar.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            hueDrag = true
                            local rel = inp.Position - HueBar.AbsolutePosition
                            local h2 = math.clamp(rel.X / HueBar.AbsoluteSize.X, 0, 1)
                            applyColor(h2, sat, val)
                        end
                    end))

                    NeverZen:Track(UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            svDrag = false
                            hueDrag = false
                        end
                    end))

                    NeverZen:Track(UserInputService.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                            if svDrag then
                                local rel = inp.Position - SVField.AbsolutePosition
                                local s2 = math.clamp(rel.X / SVField.AbsoluteSize.X, 0, 1)
                                local v2 = math.clamp(1 - (rel.Y / SVField.AbsoluteSize.Y), 0, 1)
                                applyColor(hue, s2, v2)
                            elseif hueDrag then
                                local rel = inp.Position - HueBar.AbsolutePosition
                                local h2 = math.clamp(rel.X / HueBar.AbsoluteSize.X, 0, 1)
                                applyColor(h2, sat, val)
                            end
                        end
                    end))

                    HexBox.FocusLost:Connect(function()
                        local hex = HexBox.Text:gsub("#","")
                        if #hex == 6 then
                            local ok, c = pcall(function() return Color3.fromHex(hex) end)
                            if ok then
                                local h2, s2, v2 = Color3.toHSV(c)
                                applyColor(h2, s2, v2)
                            end
                        end
                        HexBox.Text = currentColor:ToHex():upper()
                    end)

                    local pickerOpen = false

                    local function updatePickerPos()
                        Picker.Position = UDim2.fromOffset(
                            Swatch.AbsolutePosition.X + Swatch.AbsoluteSize.X - Picker.AbsoluteSize.X,
                            Swatch.AbsolutePosition.Y + Swatch.AbsoluteSize.Y + 4
                        )
                    end

                    NeverZen:NewInput(Swatch, function()
                        if not Content.Enabled or not Content.Parent then return end
                        pickerOpen = not pickerOpen
                        if pickerOpen then
                            updatePickerPos()
                            Picker.Visible = true
                        else
                            Picker.Visible = false
                        end
                    end)

                    UserInputService.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            if pickerOpen and not NeverZen:IsMouseOverFrame(Picker) and not NeverZen:IsMouseOverFrame(Swatch) then
                                pickerOpen = false
                                Picker.Visible = false
                            end
                        end
                    end)

                    return {
                        SetValue = function(self, newColor)
                            local h2, s2, v2 = Color3.toHSV(newColor)
                            applyColor(h2, s2, v2)
                        end,
                        GetValue = function(self)
                            return currentColor
                        end,
                        Fire = config.Callback,
                        Visible = function(self, value)
                            Row.Visible = value
                        end,
                    }
                end;

                return SectionSignal;
            end;

            function TabSignal:Rename(new)
                TabName.Text = new;
            end;

            function TabSignal:Icon(new)
                TabIcon.Image = NeverZen:GetIcon(new);
            end;

            return TabSignal;
        end;

        local llk;
        local ToggleWin = function(v)
            if llk then
                llk.Visible = (v and true) or false;
            end;

            if not v then
                TweenService:Create(WindowFrame,TweenInfo.new(0.7,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
                    Size = UDim2.fromOffset(210,44)
                }):Play()
                TweenService:Create(BthFrames,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Position = UDim2.new(-1, 0, 0, 45)
                }):Play()
                TweenService:Create(InformationFrame,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Position = UDim2.new(0, 0, 1, 55)
                }):Play()
                TweenService:Create(TabWin,TweenInfo.new(0.45,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Position = UDim2.new(1, 170, 0, 45)
                }):Play()
                TweenService:Create(SearchFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Size = UDim2.new(0, 0, 0, 22)
                }):Play()
                TweenService:Create(UIStroke_2,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Transparency = 1
                }):Play()
            else
                TweenService:Create(UIStroke_2,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Transparency = 0
                }):Play()
                TweenService:Create(SearchFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Size = UDim2.new(0, 140, 0, 22)
                }):Play()
                TweenService:Create(InformationFrame,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Position = UDim2.new(0, 0, 1, 0)
                }):Play()
                TweenService:Create(BthFrames,TweenInfo.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Position = UDim2.new(0, 0, 0, 45)
                }):Play()
                TweenService:Create(TabWin,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Position = UDim2.new(0, 170, 0, 45)
                }):Play()
                TweenService:Create(WindowFrame,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                    Size = WindowSignal.Config.Scale
                }):Play()
            end;
        end;

        MinButton.MouseButton1Click:Connect(function()
            WindowSignal.Toggle = not WindowSignal.Toggle;
            ToggleWin(WindowSignal.Toggle)
        end)

        _G.NZ_RESET = function(msg)
            TweenService:Create(WindowFrame,TweenInfo.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                Position = UDim2.fromOffset(115,155)
            }):Play()
        end;

        NeverZen:Track(UserInputService.InputBegan:Connect(function(input, ty)
            if not ty then
                if input.KeyCode == WindowSignal.Config.Keybind then
                    WindowSignal.Toggle = not WindowSignal.Toggle;
                    ToggleWin(WindowSignal.Toggle)
                end;
            end
        end))

        if config.Resizable then
            local Resize = Instance.new("TextButton")
            local IsHold = false;

            Resize.Name = NeverZen:RandomString();
            Resize.Parent = WindowFrame
            Resize.AnchorPoint = Vector2.new(0.5, 0.5)
            Resize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Resize.BackgroundTransparency = 1.000
            Resize.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Resize.BorderSizePixel = 0
            Resize.Position = UDim2.new(1, 0, 1, 0)
            Resize.Rotation = 0.010
            Resize.Size = UDim2.new(0.075000003, 0, 0.075000003, 0)
            Resize.SizeConstraint = Enum.SizeConstraint.RelativeYY
            Resize.ZIndex = 100
            Resize.Font = Enum.Font.SourceSans
            Resize.Text = ""
            Resize.TextColor3 = Color3.fromRGB(0, 0, 0)
            Resize.TextSize = 14.000
            Resize.Active = true
            llk = Resize;

            local label = Instance.new('ImageLabel',Resize)

            label.BackgroundTransparency = 1
            label.Size = UDim2.fromOffset(10,10)
            label.ZIndex = Resize.ZIndex + 1
            label.Image = NeverZen:GetIcon('minimize-2')
            label.Position = UDim2.fromScale(0.5,0.5)
            label.AnchorPoint = Vector2.new(0.5,0.5)

            Resize.InputBegan:Connect(function(std)
                if std.UserInputType == Enum.UserInputType.MouseButton1 or std.UserInputType == Enum.UserInputType.Touch then
                    IsHold = true
                    if UserInputService.TouchEnabled then
                        Resize.Size = UDim2.new(0.15000003, 85, 0.15000003, 85)
                    end
                end
            end)

            Resize.InputEnded:Connect(function(std)
                if std.UserInputType == Enum.UserInputType.MouseButton1 or std.UserInputType == Enum.UserInputType.Touch then
                    IsHold = false
                    Resize.Size = UDim2.new(0.075000003, 0, 0.075000003, 0)
                end
            end)

            NeverZen:Track(UserInputService.InputChanged:Connect(function(input)
                if IsHold and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and WindowSignal.Toggle then
                    local pios = input.Position;
                    local x = (pios.X - WindowFrame.AbsolutePosition.X)
                    local y = (pios.Y - WindowFrame.AbsolutePosition.Y)
                    if x < 390 then x = 390 end
                    if y < 240 then y = 240 end
                    local Offset = UDim2.new(0,x,0,y)
                    local plus = UDim2.fromOffset(-(WindowFrame.AbsoluteSize.X - x) / 2, -(WindowFrame.AbsoluteSize.Y - y) / 2);
                    TweenService:Create(WindowFrame , TweenInfo.new(0.05),{
                        Size = Offset,
                    }):Play();
                    WindowSignal.Config.Scale = Offset
                end;
            end));
        end;

        local dragToggle = nil
        local dragSpeed = 0.2
        local dragStart = nil
        local startPos = nil

        local function updateInput(input)
            local delta = input.Position - dragStart
            local position = UDim2.new(startPos.X.Scale, math.max(startPos.X.Offset + delta.X , -10),
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            game:GetService('TweenService'):Create(WindowFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
        end

        Header.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                dragToggle = true
                dragStart = input.Position
                startPos = WindowFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragToggle = false
                    end
                end)
            end
        end)

        NeverZen:Track(UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if dragToggle then
                    updateInput(input)
                end
            end
        end))

        return WindowSignal;
    end;

    function NeverZen:CreateNotifier()
        local Content = Instance.new("ScreenGui")
        local Notification = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")

        Content.Name = NeverZen:RandomString()
        Content.Parent = CoreGui;
        Content.ResetOnSpawn = false
        Content.IgnoreGuiInset = true
        Content.ZIndexBehavior = Enum.ZIndexBehavior.Global;
        table.insert(NeverZen.Guis, Content);
        NeverZen.ProtectGui(Content)

        Notification.Name = NeverZen:RandomString()
        Notification.Parent = Content
        Notification.AnchorPoint = Vector2.new(1, 1)
        Notification.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
        Notification.BackgroundTransparency = 1.000
        Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Notification.BorderSizePixel = 0
        Notification.Position = UDim2.new(1, -5, 1, -5)
        Notification.Size = UDim2.new(0, 220, 0, 65)
        Notification.ZIndex = 100

        UIListLayout.Parent = Notification
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        UIListLayout.Padding = UDim.new(0,5)

        return {
            new = function(head , body , duration)
                local Notify = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local Header = Instance.new("TextLabel")
                local Body = Instance.new("TextLabel")

                Notify.Name = NeverZen:RandomString()
                Notify.Parent = Notification
                Notify.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
                Notify.BackgroundTransparency = 0.100
                Notify.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Notify.BorderSizePixel = 0
                Notify.Size = UDim2.new(0, 0,0, 0)
                Notify.ClipsDescendants = true

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Notify

                UIStroke.Color = NeverZen.Theme.BackgroundColor
                UIStroke.Parent = Notify

                Header.Name = NeverZen:RandomString()
                Header.Parent = Notify
                Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Header.BackgroundTransparency = 1.000
                Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Header.BorderSizePixel = 0
                Header.Position = UDim2.new(0, 5, 0, 2)
                Header.Size = UDim2.new(1, -10, 0, 20)
                Header.Font = Enum.Font.GothamBold
                Header.Text = head
                Header.TextColor3 = Color3.fromRGB(255, 255, 255)
                Header.TextSize = 14.000
                Header.TextTransparency = 0.100
                Header.TextXAlignment = Enum.TextXAlignment.Left

                Body.Name = NeverZen:RandomString()
                Body.Parent = Notify
                Body.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Body.BackgroundTransparency = 1.000
                Body.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Body.BorderSizePixel = 0
                Body.Position = UDim2.new(0, 5, 0, 22)
                Body.Size = UDim2.new(1, -10, 1, -25)
                Body.Font = Enum.Font.GothamMedium
                Body.Text = body
                Body.TextColor3 = Color3.fromRGB(255, 255, 255)
                Body.TextSize = 11.000
                Body.TextTransparency = 0.500
                Body.TextXAlignment = Enum.TextXAlignment.Left
                Body.TextYAlignment = Enum.TextYAlignment.Top

                local Min = TextService:GetTextSize(Header.Text,Header.TextSize,Header.Font,Vector2.new(math.huge,math.huge));
                local scale = TextService:GetTextSize(Body.Text,Body.TextSize,Body.Font,Vector2.new(math.huge,math.huge));

                Notify.Size = UDim2.new(0,  math.clamp(scale.X + 25 , Min.X + 10 , 10000),0, 0)

                TweenService:Create(Notify,TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),{
                    Size = UDim2.new(0, math.clamp(scale.X + 25 , Min.X + 10 , 10000), 0, scale.Y + 25)
                }):Play()

                task.delay(((duration or 5) - 0.3),function()
                    TweenService:Create(Notify,TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),{
                    Size = UDim2.new(0, 0,0, scale.Y + 25)
                    }):Play()
                    task.wait(.3)
                    Notify:Destroy()
                end)
            end,
        }
    end;

    function NeverZen:Unload()
        for i, v in next, NeverZen.Cleanups do
            pcall(v);
        end;
        table.clear(NeverZen.Cleanups);
        for i, v in next, NeverZen.Connections do
            pcall(function()
                v:Disconnect();
            end)
        end;
        table.clear(NeverZen.Connections);
        for i, v in next, NeverZen.Guis do
            pcall(function()
                v:Destroy();
            end)
        end;
        table.clear(NeverZen.Guis);
    end;
end

local NZNotification = NeverZen:CreateNotifier()

if not IsSupported then
    NZNotification.new('BloodWork :[', 'Your executor was not supported.', 10)
    return
end

local EryndorASSETS = {
    CurrentCamera = nil,
    ServerStatsItem = nil,
    SwordAPI = nil,
    swordInstancesInstance = nil,
    swordInstances = nil,
    SwordController = nil,
    Replion = nil,
    Runtime = nil,
}

local ParryDATA = {
    ParryFunction = nil,
    ParryRemote = nil,
    ParryIndex = 0.500,
}

local function AttemptFunctionFetch()
    _PARRY_PATCH.ready = false
    _PARRY_PATCH.resolve()
    return {
        ParryFunction = _PARRY_PATCH.ready and _PARRY_PATCH.fire or nil,
        ParryRemote   = _PARRY_PATCH.parryRemote,
    }
end

NZNotification.new('BloodWork :[', 'Attempting to fetch game data', 5)

local Result = AttemptFunctionFetch()
ParryDATA.ParryFunction = Result.ParryFunction
ParryDATA.ParryRemote = Result.ParryRemote

if ParryDATA.ParryFunction and ParryDATA.ParryRemote then
    NZNotification.new('BloodWork :[', 'Successfully fetched game data.', 5)
else
    NZNotification.new('BloodWork :[', 'Failed to fetch game data, please check developer console.', 5)
end
print(string.format("[BloodWork]:[DEBUG]\nParryFunction: %s\nParryRemote: %s", tostring(ParryDATA.ParryFunction), tostring(ParryDATA.ParryRemote)))

NZNotification.new('BloodWork :[', 'Attempting to load main script.', 5)

EryndorASSETS.CurrentCamera = Workspace.CurrentCamera
EryndorASSETS.ServerStatsItem = Stats.Network.ServerStatsItem
EryndorASSETS.SwordAPI = ReplicatedStorage.Shared.SwordAPI
EryndorASSETS.swordInstancesInstance = ReplicatedStorage.Shared.ReplicatedInstances.Swords
EryndorASSETS.DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
EryndorASSETS.ThreadSafeTargetingHelper = require(ReplicatedStorage.Shared.ThreadSafeTargetingHelper)
do
    local OldThreadIdentity = (getthreadidentity and getthreadidentity()) or 2
    if setthreadidentity then setthreadidentity(2) end
    EryndorASSETS.swordInstances = require(EryndorASSETS.swordInstancesInstance)
    if setthreadidentity then setthreadidentity(OldThreadIdentity) end
end
EryndorASSETS.SwordController = nil
EryndorASSETS.Runtime = Workspace:WaitForChild("Runtime")

do
    for _, connection in pairs(getconnections(ReplicatedStorage.Remotes.FireSwordInfo.OnClientEvent)) do
        if connection.Function and islclosure(connection.Function) then
            local upvalues = debug.getupvalues(connection.Function)
            if #upvalues == 1 and type(upvalues[1]) == "table" then
                EryndorASSETS.SwordController = upvalues[1]
                break
            end
        end
    end
end

local EryndorDATA = {
    Player = {
        LocalPlayer = Players.LocalPlayer,
        Character = nil,
        Humanoid = nil,
    },
    Connections = {},
    Balls = Workspace:WaitForChild("Balls"),
    Parry = {},
    Global = {
        LastInput = nil,
        AutoParryParried = false,
        Parries = 0,
        SuccessParries = 0,
        TornadoTime = 0,
        LerpRadians = 0,
        lastParryTime = 0,
        AutoParryCurrentAccuracy = 0,
        AutoSpamParryCurrentAccuracy = 0,
    },
    Config = {
        AutoParry = {
            Enabled = false,
            AntiCurveEnabled = true,
            AnimationFix = false
        },
        LobbyAutoParry = {
            Enabled = false,
            AntiCurveEnabled = true,
            AnimationFix = false
        },
        AutoSpamParry = {
            Enabled = false,
            Keybind = nil,
            DetectionMode = "Speed",
            AnimationFix = false,
            Spamming = false,
            Threshold = 3,
            ParryThreshold = 1.5,
            DistanceMultiplier = 1.0
        },
        ManualSpamParry = {
            Spamming = false,
            UI = false,
            Keybind = nil,
            AnimationFix = false,
            SuperSpam = false,
            SuperSpamClicks = 5,
        },
        TriggerBot = {
            Enabled = false,
            UI = false,
            Keybind = nil,
            AnimationFix = false,
            InfinityDetection = false
        },
        BallStats = {
            Enabled = false
        },
        ClientStats = {
            Enabled = false
        },
        Animation = {
            GrabParry = nil,
            AnimationCache = {},
            AnimationDelay = 1,
            SpamAnimationParries = 0,
            AnimationSpammingMode = false,
        },
        ParrySettings = {
            Detections = {
                InfinityBall = {
                    Enabled = false,
                    Flag = false
                },
                DeathSlashBall = {
                    Enabled = false,
                    Flag = false
                },
                TimeHole = {
                    Enabled = false,
                    Flag = false
                },
                SlashesofFury = {
                    Enabled = false,
                    Flag = false,
                    Count = 0
                },
                Forcefield = {
                    Enabled = false,
                    Flag = false
                },
                Phantom = {
                    Enabled = false,
                    Flag = false
                },
                Singularity = {
                    Enabled = false,
                    Flag = false
                },
                Dribble = {
                    Enabled = false,
                    Flag = false
                },
                Pull = {
                    Enabled = false,
                    Flag = false
                },
                Pulse = {
                    Enabled = false,
                    Flag = false
                },
                AbilityActive = {
                    Enabled = false,
                    Flag = false
                },
                Tornado = {
                    Enabled = false,
                    Flag = false
                },
                HellHook = {
                    Enabled = false,
                    Flag = false
                }
            },
            SpeedDivisorMultiplier = 1.1,
            AutoParryAccuracy = 80,
            AutoParryAutoAccuracy = false,
            ParryMethod = "Blatant",
            SlashesofFuryDetectionMaxParryCount = 36,
            SlashesofFuryDetectionParryDelay = 0.05,
            SpammingRPS = 180,
            ParryCurveDirection = "Camera",
            FastBallProtection = false,
            LobbyAutoParryAccuracy = 80,
            LobbySpeedDivisorMultiplier = 1.1,
            VisualiserParries = 0,
            SafeMode = true
        }
    }
}

local TriggerBotParried = false

local Visuals = {
    VisualisersEnabled = false,
    VisualiserService = {},
    HitEffectEnabled = false,
    HitEffectService = {
        BallEffects = {}
    },
    VisualParts = {}
}

function Visuals.VisualiserService:ClearAll()
    for _, part in pairs(Visuals.VisualParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    Visuals.VisualParts = {}
end

local Immortality = {
    Enabled = false,
    SpeedBypassEnabled = true,
    Angle = 72,
    Height = 15,
    Depth = -8,
    SquareRadius = 10,
    UI = false
}

local ImmortalityUIService = {}

local SkinChanger = {
    Enabled = false,
    Targets = {
        SwordModel = {
            Enabled = false,
            ModelName = ""
        },
        SwordAnimation = {
            Enabled = false,
            AnimationName = ""
        },
        SwordFX = {
            Enabled = false,
            FXName = ""
        }
    },
    System = {
        SlashName = "SlashEffect",
        parrySuccessAllConnection = nil,
        parrySuccessClientConnection = nil,
        playParryFunc = nil,
        lastOtherParryTimestamp = 0,
        OriginalEquipSwordTo = nil,
        functions = {}
    }
}

local UI = {
    Window = NeverZen.new({
        Name = "BloodWork :[",
        SubTitle = "v1.4 | Blade Ball",
        Keybind = Enum.KeyCode.LeftControl,
        Scale = UDim2.new(0, 545, 0, 353),
        Resizable = true,
        Shadow = false,
        Acrylic = false,
        ShowProfile = false
    }),
    AutoParryToggle = nil,
    ManualSpamParryToggle = nil,
    SpamLoopRPSLabel = nil,
    SpamAccumulatorLabel = nil,
    TriggerBotToggle = nil,
    BallStats = {
        ScreenGui = nil,
        Handler = nil,
        SpeedValue = nil,
        PeakSpeedValue = nil,
        PeakSpeed = 0,
    },
    TriggerBotUI = {
        ScreenGui = nil,
        Handler = nil,
        ToggleButton = nil,
    },
    ImmortalityToggle = nil,
    SpamUI = {
        ScreenGui = nil,
        Handler = nil,
        SpamButton = nil,
    },
    ImmortalityUI = {
        ScreenGui = nil,
        Handler = nil,
        ToggleButton = nil,
    },
    StatsUI = {
        ScreenGui = nil,
        Handler = nil,
        States ={
            FPS = nil,
            PING = nil,
            CPU = nil,
            MEMORY = nil
        }
    }
}

local Debug = {
    Spamming = {
        Speed = 0,
        LastRepeat = 0,
        RepeatedAmount = 0,
    }
}

local ManualSpamParryUIService = {}

local TriggerBotUIService = {}
local BallStatsUIService = {}

local StatsUIService = {}

local AnimationFixService = {
    Rate = 180,
    FEMode = false,
    Cache = {}
}

local ClearCache = nil
local ResetAccumulator = nil

local UnloadEryndor = nil

local function GetCharacter()
    return EryndorDATA.Player.LocalPlayer.Character
end

local function GetHumanoid()
    local character = GetCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function StopAnimation(animationtrack, FadeTime)
    local StopFadeTime = FadeTime or animationtrack:GetAttribute("StopFadeTime")
    animationtrack:Stop(StopFadeTime)
end

local function PlayGrabAnimation(animationtrack)
    local PlayFadeTime = animationtrack:GetAttribute("PlayFadeTime")
    local PlayWeight = animationtrack:GetAttribute("PlayWeight")
    local PlaySpeed = animationtrack:GetAttribute("PlaySpeed")
    animationtrack:Play(PlayFadeTime, PlayWeight, PlaySpeed)
end

local function GetParryAnimation(swordName)
    local character = GetCharacter()
    if not character then return nil end

    if not swordName then
        return EryndorASSETS.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
    end

    if AnimationFixService.Cache[swordName] then
        return AnimationFixService.Cache[swordName]
    end

    local success, swordData = pcall(function()
        return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(swordName)
    end)

    if not success or not swordData or type(swordData) ~= "table" then
        AnimationFixService.Cache[swordName] = EryndorASSETS.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        return AnimationFixService.Cache[swordName]
    end

    if not swordData.AnimationType or type(swordData.AnimationType) ~= "string" then
        AnimationFixService.Cache[swordName] = EryndorASSETS.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        return AnimationFixService.Cache[swordName]
    end

    local swordCollection = EryndorASSETS.SwordAPI.Collection
    for _, object in pairs(swordCollection:GetChildren()) do
        if object.Name == swordData.AnimationType then
            local animation = object:FindFirstChild("GrabParry") or object:FindFirstChild("Grab")
            if animation then
                AnimationFixService.Cache[swordName] = animation
                return animation
            end
        end
    end

    AnimationFixService.Cache[swordName] = EryndorASSETS.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
    return AnimationFixService.Cache[swordName]
end

local SpamAnimationFixLastPlayed = 0
local SpamAnimationFixBypass = false

local function PlayParry_Animation()
    local IsBlockLegit = true

    local LocalPlayer = EryndorDATA.Player.LocalPlayer
    local Character = GetCharacter()
    if not Character then IsBlockLegit = false end
    if Character:GetAttribute("Stunned") then
        IsBlockLegit = false
    end
    local IsInLobbyTrainning = LocalPlayer:GetAttribute("LobbyTraining") and (Character.Parent == workspace.Dead and true or false)
    if Character.Parent ~= Workspace.Alive and not (EryndorASSETS.DebugFlags.LobbyParry or (LocalPlayer:GetAttribute("LobbyParry") or IsInLobbyTrainning)) then
        IsBlockLegit = false
    end
    if Character:GetAttribute("DoNotParry") or Character:GetAttribute("ChargingAdrenaline") and LocalPlayer.Upgrades["Qi-Charge"].Value < 2 then
        IsBlockLegit = false
    end
    if LocalPlayer:GetAttribute("LobbyParry") and LocalPlayer:GetAttribute("InLobbyParryCooldown") then
        IsBlockLegit = false
    end

    local SafeModeEnabled = EryndorDATA.Config.ParrySettings.SafeMode
    local ShouldExecuteRemoteFireServer = (IsBlockLegit and SafeModeEnabled) or not SafeModeEnabled
    if not ShouldExecuteRemoteFireServer then
        return
    end

    local humanoid = GetHumanoid()
    if not humanoid then return end

    local currentSword = nil
    if SkinChanger.Enabled and SkinChanger.Targets.SwordAnimation.Enabled and SkinChanger.Targets.SwordAnimation.AnimationName ~= "" then
        currentSword = SkinChanger.Targets.SwordAnimation.AnimationName
    else
        local character = GetCharacter()
        if not character then return end
        currentSword = character:GetAttribute("CurrentlyEquippedSword")
    end

    local animation = GetParryAnimation(currentSword)
    if not animation then
        animation = EryndorASSETS.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        if not animation then return end
    end

    for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        if track.Name == "GrabParry" or track.Name == "Grab" then
            if not EryndorDATA.Config.Animation.AnimationSpammingMode and not AnimationFixService.FEMode then
                track.TimePosition = 0
            end
            StopAnimation(track)
        elseif track.Name == "SuccessParry" or track.Name == "Success" then
            if EryndorDATA.Config.Animation.AnimationSpammingMode and not AnimationFixService.FEMode then
                track.TimePosition = 0
            end
            StopAnimation(track)
        end
    end
    EryndorDATA.Config.Animation.GrabParry = humanoid.Animator:LoadAnimation(animation)
    PlayGrabAnimation(EryndorDATA.Config.Animation.GrabParry)
end

local AnimationFixDelayLimit = 0

local function SpamParry_Animation()
    if os.clock() - AnimationFixDelayLimit >= (1/AnimationFixService.Rate) then
        AnimationFixDelayLimit = os.clock()
        if ((os.clock() - SpamAnimationFixLastPlayed) >= 0.1) or SpamAnimationFixBypass or EryndorDATA.Config.Animation.AnimationSpammingMode then
            SpamAnimationFixLastPlayed = os.clock()
            SpamAnimationFixBypass = false
            PlayParry_Animation()
        end
    end
end

NeverZen:Track(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    EryndorDATA.Global.LastInput = input.UserInputType
end))

do
    SkinChanger.System.functions.setSword = function()
        pcall(function()
            debug.setupvalue(SkinChanger.System.OriginalEquipSwordTo,3,false)
        end)

        if SkinChanger.Targets.SwordModel.Enabled and SkinChanger.Targets.SwordModel.ModelName ~= "" then
            EryndorASSETS.swordInstances:EquipSwordTo(GetCharacter(), SkinChanger.Targets.SwordModel.ModelName)
        end

        if SkinChanger.Targets.SwordAnimation.Enabled and SkinChanger.Targets.SwordAnimation.AnimationName ~= "" and EryndorASSETS.SwordController then
            EryndorASSETS.SwordController:SetSword(SkinChanger.Targets.SwordAnimation.AnimationName)
        end
    end

    SkinChanger.System.functions.getSlashName = function(swordName)
        local swordData = EryndorASSETS.swordInstances:GetSword(swordName)
        return (swordData and swordData.SlashName) or "SlashEffect"
    end

    SkinChanger.System.functions.updateSword = function()
        if SkinChanger.Targets.SwordFX.Enabled and SkinChanger.Targets.SwordFX.FXName ~= "" then
            SkinChanger.System.SlashName = SkinChanger.System.functions.getSlashName(SkinChanger.Targets.SwordFX.FXName)
        end
        SkinChanger.System.functions.setSword()
    end
end

local function GetParry_Data(curveDirection, IsInLobbyTrainning)
    local PlayerPositions = {}
    local Vector2_Mouse_Location

    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local isRelevantInput = EryndorDATA.Global.LastInput and (
        EryndorDATA.Global.LastInput == Enum.UserInputType.MouseButton1 or
        EryndorDATA.Global.LastInput == Enum.UserInputType.MouseButton2 or
        EryndorDATA.Global.LastInput == Enum.UserInputType.Keyboard
    )

    if isRelevantInput and not isMobile then
        local Mouse_Location = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = {Mouse_Location.X, Mouse_Location.Y}
    else
        local viewportSize = EryndorASSETS.CurrentCamera.ViewportSize
        Vector2_Mouse_Location = {viewportSize.X / 2, viewportSize.Y / 2}
    end

    if IsInLobbyTrainning then
        for _, player_character in workspace.Dead:GetChildren() do
            local player = Players:GetPlayerFromCharacter(player_character)

            if player and (player:GetAttribute("LobbyTraining") and player_character.PrimaryPart) then
                PlayerPositions[player_character.Name] = EryndorASSETS.CurrentCamera:WorldToScreenPoint(player_character.PrimaryPart.Position)
            end
        end

        for _, target in CollectionService:GetTagged("LobbyTrainingTarget") do
            PlayerPositions[target.Name] = EryndorASSETS.CurrentCamera:WorldToScreenPoint(target.Position)
        end
    else
        local CurrentlySelectedMode = Workspace:GetAttribute("CurrentlySelectedMode")

        if CurrentlySelectedMode == "Hovergoal" or CurrentlySelectedMode == "Soccer" then
            local TeamNumber
            if EryndorASSETS.ThreadSafeTargetingHelper.GetPlayerTeam(EryndorDATA.Player.LocalPlayer) == 1 then TeamNumber = 2 else TeamNumber = 1 end

            for _, hovergoalgoal in CollectionService:GetTagged("HovergoalGoal") do
                if hovergoalgoal.Name == ("Goal%*"):format((tostring(TeamNumber))) then
                    PlayerPositions[hovergoalgoal.Name] = EryndorASSETS.CurrentCamera:WorldToScreenPoint(hovergoalgoal.Target.Position)

                    break
                end
            end

            for _, player_character in Workspace.Alive:GetChildren() do
                if player_character.PrimaryPart and player_character:GetAttribute("IsTheRisingZombie") then
                    PlayerPositions[player_character.Name] = EryndorASSETS.CurrentCamera:WorldToScreenPoint(player_character.PrimaryPart.Position)
                end
            end
        else
            for _, player_character in Workspace.Alive:GetChildren() do
                if player_character.PrimaryPart then
                    PlayerPositions[player_character.Name] = EryndorASSETS.CurrentCamera:WorldToScreenPoint(player_character.PrimaryPart.Position)
                end
            end
        end
    end

    if curveDirection == 'Camera' then
        return {EryndorASSETS.CurrentCamera.CFrame, PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Straight' then
        local closestEntity = nil
        local closestDistance = math.huge
        local mouseVector = Vector2.new(Vector2_Mouse_Location[1], Vector2_Mouse_Location[2])

        if IsInLobbyTrainning then
            for _, player_character in workspace.Dead:GetChildren() do
                local player = Players:GetPlayerFromCharacter(player_character)

                if player and (player:GetAttribute("LobbyTraining") and player_character:FindFirstChild("HumanoidRootPart")) then
                    local screenPos, isOnScreen = EryndorASSETS.CurrentCamera:WorldToScreenPoint(player_character.PrimaryPart.Position)
                    if isOnScreen then
                        local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (mouseVector - playerScreenPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestEntity = player_character
                        end
                    end
                end
            end

            for _, target in CollectionService:GetTagged("LobbyTrainingTarget") do
                local screenPos, isOnScreen = EryndorASSETS.CurrentCamera:WorldToScreenPoint(target.Position)
                if isOnScreen then
                    local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (mouseVector - playerScreenPos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestEntity = target
                    end
                end
            end
        else
            local CurrentlySelectedMode = Workspace:GetAttribute("CurrentlySelectedMode")

            if CurrentlySelectedMode == "Hovergoal" or CurrentlySelectedMode == "Soccer" then
                local TeamNumber
                if EryndorASSETS.ThreadSafeTargetingHelper.GetPlayerTeam(EryndorDATA.Player.LocalPlayer) == 1 then TeamNumber = 2 else TeamNumber = 1 end

                for _, hovergoalgoal in CollectionService:GetTagged("HovergoalGoal") do
                    if hovergoalgoal.Name == ("Goal%*"):format((tostring(TeamNumber))) then
                        local screenPos, isOnScreen = EryndorASSETS.CurrentCamera:WorldToScreenPoint(hovergoalgoal.Target.Position)
                        if isOnScreen then
                            local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                            local distance = (mouseVector - playerScreenPos).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestEntity = hovergoalgoal.Target
                            end
                        end
                        break
                    end
                end

                for _, player_character in Workspace.Alive:GetChildren() do
                    if player_character.PrimaryPart and player_character:GetAttribute("IsTheRisingZombie") then
                        local screenPos, isOnScreen = EryndorASSETS.CurrentCamera:WorldToScreenPoint(player_character.PrimaryPart.Position)
                        if isOnScreen then
                            local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                            local distance = (mouseVector - playerScreenPos).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestEntity = player_character
                            end
                        end
                    end
                end
            else
                for _, player_character in Workspace.Alive:GetChildren() do
                    if player_character.PrimaryPart then
                        local screenPos, isOnScreen = EryndorASSETS.CurrentCamera:WorldToScreenPoint(player_character.PrimaryPart.Position)
                        if isOnScreen then
                            local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                            local distance = (mouseVector - playerScreenPos).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestEntity = player_character
                            end
                        end
                    end
                end
            end
        end

        if closestEntity and closestEntity.PrimaryPart then
            return {CFrame.new(GetCharacter().PrimaryPart.Position, closestEntity.PrimaryPart.Position), PlayerPositions, Vector2_Mouse_Location}
        else
            return {EryndorASSETS.CurrentCamera.CFrame, PlayerPositions, Vector2_Mouse_Location}
        end
    elseif curveDirection == 'Up' then
        local upDirection = EryndorASSETS.CurrentCamera.CFrame.UpVector * 1e9
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + upDirection), PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Down' then
        local downDirection = EryndorASSETS.CurrentCamera.CFrame.UpVector * -1e9
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + downDirection), PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Left' then
        local leftDirection = EryndorASSETS.CurrentCamera.CFrame.RightVector * -1e9
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + leftDirection), PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Right' then
        local rightDirection = EryndorASSETS.CurrentCamera.CFrame.RightVector * 1e9
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + rightDirection), PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Backward' then
        local backDirection = EryndorASSETS.CurrentCamera.CFrame.LookVector * -1e9
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + backDirection), PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Random' then
        local randomDirection = Vector3.new(math.random(-1e9, 1e9), math.random(-1e9, 1e9), math.random(-1e9, 1e9))
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + randomDirection), PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Accelerate' then
        local accelerateDirection = EryndorASSETS.CurrentCamera.CFrame.LookVector * 10 + Vector3.new(0,7,0)
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + accelerateDirection), PlayerPositions, Vector2_Mouse_Location}
    elseif curveDirection == 'Decelerate' then
        local decelerateDirection = Vector3.new(0, -1, 0) * 1e9
        return {CFrame.new(EryndorASSETS.CurrentCamera.CFrame.Position, EryndorASSETS.CurrentCamera.CFrame.Position + decelerateDirection), PlayerPositions, Vector2_Mouse_Location}
    else
        return {
            EryndorASSETS.CurrentCamera.CFrame,
            PlayerPositions,
            Vector2_Mouse_Location
        }
    end
end

local function Parry(ParryData)
    if not _PARRY_PATCH.ready then
        _PARRY_PATCH.resolve()
        if not _PARRY_PATCH.ready then return false end
    end

    local Camera = EryndorASSETS.CurrentCamera or Workspace.CurrentCamera
    local curveCF, screenPositions, mouseLocation

    if type(ParryData) == "table" then
        curveCF         = ParryData[1]
        screenPositions = ParryData[2]
        mouseLocation   = ParryData[3]
    end

    if not curveCF then curveCF = Camera.CFrame end

    if not screenPositions then
        screenPositions = {}
        for _, entity in pairs(Workspace.Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok, sp = pcall(function()
                    return Camera:WorldToScreenPoint(entity.PrimaryPart.Position)
                end)
                if ok then screenPositions[entity.Name] = sp end
            end
        end
    end

    if not mouseLocation then
        local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
        local okMouse, mouse = pcall(function()
            return UserInputService:GetMouseLocation()
        end)
        if okMouse and mouse and not isMobile then
            mouseLocation = {mouse.X, mouse.Y}
        else
            local vp = Camera.ViewportSize
            mouseLocation = {vp.X / 2, vp.Y / 2}
        end
    end

    return _PARRY_PATCH.fire(curveCF, screenPositions, mouseLocation)
end

local ExecuteRemoteFireServer = function(ParryData)
    return Parry(ParryData)
end

local FireParry = function()
    local ParryMethod = EryndorDATA.Config.ParrySettings.ParryMethod
    if ParryMethod == "Blatant" then
        local IsBlockLegit = true

        local LocalPlayer = EryndorDATA.Player.LocalPlayer
        local Character = GetCharacter()
        if not Character then IsBlockLegit = false end
        if Character:GetAttribute("Stunned") then
            IsBlockLegit = false
        end
        local IsInLobbyTrainning = LocalPlayer:GetAttribute("LobbyTraining") and (Character.Parent == workspace.Dead and true or false)
        if Character.Parent ~= Workspace.Alive and not (EryndorASSETS.DebugFlags.LobbyParry or (LocalPlayer:GetAttribute("LobbyParry") or IsInLobbyTrainning)) then
            IsBlockLegit = false
        end
        if Character:GetAttribute("DoNotParry") or Character:GetAttribute("ChargingAdrenaline") and LocalPlayer.Upgrades["Qi-Charge"].Value < 2 then
            IsBlockLegit = false
        end
        if LocalPlayer:GetAttribute("LobbyParry") and LocalPlayer:GetAttribute("InLobbyParryCooldown") then
            IsBlockLegit = false
        end

        local SafeModeEnabled = EryndorDATA.Config.ParrySettings.SafeMode
        local ShouldExecuteRemoteFireServer = (IsBlockLegit and SafeModeEnabled) or not SafeModeEnabled
        if ShouldExecuteRemoteFireServer then
            local ParryData = GetParry_Data(EryndorDATA.Config.ParrySettings.ParryCurveDirection, IsInLobbyTrainning)
            ExecuteRemoteFireServer(ParryData)
        end
    elseif ParryMethod == "Legit" then
        if _AZURE_PF then
            pcall(_AZURE_PF)
        end
    end

    if EryndorDATA.Global.Parries <= 7 then
        EryndorDATA.Global.Parries += 1
        task.delay(0.5, function()
            if EryndorDATA.Global.Parries > 0 then
                EryndorDATA.Global.Parries -= 1
            end
        end)
    end
end

local function Get_Balls()
    local BallInstances = {}
    for _, Instance in pairs(EryndorDATA.Balls:GetChildren()) do
        if Instance:GetAttribute("realBall") then
            table.insert(BallInstances, Instance)
        end
    end
    return BallInstances
end

local function GetTraining_Balls()
    local BallInstances = {}
    for _, Instance in pairs(Workspace:WaitForChild("TrainingBalls"):GetChildren()) do
        if Instance:GetAttribute("realBall") then
            table.insert(BallInstances, Instance)
        end
    end
    return BallInstances
end

local function GetLinear_Interpolation(a, b, time_volume)
    return a + (b - a) * time_volume
end

local function IsBall_Curved(Ball, Ping, char)
    if not Ball then
        return false
    end

    local Zoomies = Ball:FindFirstChild("zoomies")

    if not Zoomies then
        return false
    end

    local velocity = Zoomies.VectorVelocity
    local ball_direction = velocity.Unit
    local direction = (char.PrimaryPart.Position - Ball.Position).Unit
    local dot = direction:Dot(ball_direction)
    local speed = velocity.Magnitude
    local speed_threshold = math.min(speed / 100, 40)
    local direction_difference = (ball_direction - velocity).Unit
    local direction_similarity = direction:Dot(direction_difference)
    local dot_difference = dot - direction_similarity
    local distance = (char.PrimaryPart.Position - Ball.Position).Magnitude
    local dot_threshold = 0.5 - (Ping / 1000)
    local reach_time = distance / speed - (Ping / 1000)
    local ball_distance_threshold = 15 - math.min(distance / 1000, 15) + speed_threshold
    local clamped_dot = math.clamp(dot, -1, 1)
    local radians = math.rad(math.asin(clamped_dot))

    EryndorDATA.Parry[Ball].lerp_radians = GetLinear_Interpolation(EryndorDATA.Parry[Ball].lerp_radians, radians, 0.8)
    if speed > 0 and reach_time > Ping / 10 then
        ball_distance_threshold = math.max(ball_distance_threshold - 15, 15)
    end

    if distance < ball_distance_threshold then
        return false
    end
    if dot_difference < dot_threshold then
        return true
    end
    if EryndorDATA.Parry[Ball].lerp_radians < 0.018 then
        EryndorDATA.Parry[Ball].last_warping = tick()
    end
    if (tick() - EryndorDATA.Parry[Ball].last_warping) < (reach_time / 1.5) then
        return true
    end
    if (tick() - EryndorDATA.Parry[Ball].curving) < (reach_time / 1.5) then
        return true
    end

    return dot < dot_threshold
end

local function GetClosest_Player()
    local closestPlayer = nil
    local closestDistance = math.huge
    local lpCharacter = GetCharacter()
    if not lpCharacter or not lpCharacter.PrimaryPart then
        return nil
    end

    for _, entity in ipairs(Workspace.Alive:GetChildren()) do
        if entity ~= lpCharacter and entity.PrimaryPart then
            local distance = (lpCharacter.PrimaryPart.Position - entity.PrimaryPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = entity
            end
        end
    end

    return closestPlayer, closestDistance
end

local function MainConnection()
    if not GetCharacter() or not GetCharacter().PrimaryPart then
        return
    end
    local IsSpamming = EryndorDATA.Config.AutoSpamParry.Spamming or EryndorDATA.Config.ManualSpamParry.Spamming
    do
        local BallsList = Get_Balls()
        if EryndorDATA.Config.AutoParry.Enabled and not IsSpamming and not EryndorDATA.Config.TriggerBot.Enabled then
            for _, Ball in pairs(BallsList) do
                if not Ball then
                end

                if not EryndorDATA.Parry[Ball] then
                    EryndorDATA.Parry[Ball] = {
                        lastVelUnit = nil,
                        velHistory = {},
                        lerp_radians = 0,
                        last_warping = 0,
                        curving = tick(),
                        LastParry = 0,
                        LobbyParried = false,
                        LobbyLastParry = os.clock(),
                        TargetConn = Ball:GetAttributeChangedSignal('target'):Connect(function()
                            EryndorDATA.Global.AutoParryParried = false
                        end)
                    }
                end

                local zoomies = Ball:FindFirstChild('zoomies')
                if not zoomies then
                    continue
                end

                Ball:GetAttributeChangedSignal('target'):Once(function()
                    EryndorDATA.Global.AutoParryParried = false
                end)

                if EryndorDATA.Global.AutoParryParried then
                    continue
                end

                local ball_target = Ball:GetAttribute('target')
                local velocity = zoomies.VectorVelocity
                local distance = (GetCharacter().PrimaryPart.Position - Ball.Position).Magnitude
                local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
                local ping_threshold = math.clamp(ping / 10, 5, 17)
                local speed = velocity.Magnitude
                local capped_speed_diff = math.min(math.max(speed - 9.5, 0), 650)
                local speed_divisor = (2.4 + capped_speed_diff * 0.002) * EryndorDATA.Config.ParrySettings.SpeedDivisorMultiplier
                local parry_accuracy = ping_threshold + math.max(speed / speed_divisor, 9.5)
                local curved = IsBall_Curved(Ball, ping * 10, GetCharacter())

                EryndorDATA.Global.AutoParryCurrentAccuracy = parry_accuracy

                if Ball:FindFirstChild('AeroDynamicSlashVFX') then
                    EryndorDATA.Global.TornadoTime = tick()
                end

                local TornadoDet = EryndorDATA.Config.ParrySettings.Detections.Tornado
                if TornadoDet then
                    if EryndorASSETS.Runtime:FindFirstChild('Tornado') then
                        TornadoDet.Flag =
                            (tick() - EryndorDATA.Global.TornadoTime) < ((EryndorASSETS.Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159)
                    else
                        TornadoDet.Flag = false
                    end
                end

                if Ball:FindFirstChild('ComboCounter') then continue end

                do
                    local Det = EryndorDATA.Config.ParrySettings.Detections
                    local skip = false
                    for _, key in ipairs({
                        "InfinityBall", "DeathSlashBall", "TimeHole",
                        "Forcefield", "Phantom", "Singularity", "Dribble",
                        "Pull", "Pulse", "AbilityActive", "Tornado", "HellHook",
                    }) do
                        local d = Det[key]
                        if d and d.Enabled and d.Flag then skip = true break end
                    end
                    if skip then continue end
                end
                if EryndorDATA.Config.AutoParry.AntiCurveEnabled and curved then continue end

                if getgenv().CooldownProtection then
                    local ok, ParryCD = pcall(function() return EryndorDATA.Player.LocalPlayer.PlayerGui.Hotbar.Block.UIGradient end)
                    if ok and ParryCD and ParryCD.Offset.Y < 0.4 then
                        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                    end
                end

                if ball_target == tostring(EryndorDATA.Player.LocalPlayer) and distance <= parry_accuracy then
                    local parry_time = os.clock()
                    local time_view = parry_time - EryndorDATA.Parry[Ball].LastParry
                    if time_view > 0.25 and EryndorDATA.Config.AutoParry.AnimationFix and EryndorDATA.Config.ParrySettings.ParryMethod ~= "Legit" then
                        PlayParry_Animation()
                    end
                    FireParry()
                    EryndorDATA.Parry[Ball].LastParry = parry_time
                    EryndorDATA.Global.AutoParryParried = true
                end
                local last_parrys = tick()
                repeat
                    RunService.PreSimulation:Wait()
                until (tick() - last_parrys) >= 1 or not EryndorDATA.Global.AutoParryParried
                EryndorDATA.Global.AutoParryParried = false
            end
        else
            EryndorDATA.Global.AutoParryCurrentAccuracy = 0
        end

        if EryndorDATA.Config.LobbyAutoParry.Enabled then
            local LobbyBallsList = GetTraining_Balls()
            for _, Ball in pairs(LobbyBallsList) do
                if not Ball then
                    return
                end

                if not EryndorDATA.Parry[Ball] then
                    EryndorDATA.Parry[Ball] = {
                        lastVelUnit = nil,
                        velHistory = {},
                        lerp_radians = 0,
                        last_warping = 0,
                        curving = tick(),
                        LastParry = os.clock(),
                        LobbyParried = false,
                        LobbyLastParry = os.clock(),
                        TargetConn = Ball:GetAttributeChangedSignal('target'):Connect(function()
                            EryndorDATA.Parry[Ball].LobbyParried = false
                        end)
                    }
                end

                local Zoomies = Ball:FindFirstChild('zoomies')
                if not Zoomies then
                    return
                end

                if EryndorDATA.Parry[Ball].LobbyParried then
                    return
                end

                local Ball_Target = Ball:GetAttribute('target')
                local Velocity = Zoomies.VectorVelocity
                local Distance = (GetCharacter().PrimaryPart.Position - Ball.Position).Magnitude - 5
                local Ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
                local Ping_Threshold = math.clamp(Ping / 20, 5, 17)
                local Speed = Velocity.Magnitude * 1.5
                local cappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                local speed_divisor_base = 2.4 + cappedSpeedDiff * 0.002
                local speed_divisor = speed_divisor_base * EryndorDATA.Config.ParrySettings.LobbySpeedDivisorMultiplier
                local Parry_Accuracy = Ping_Threshold + math.max(Speed / speed_divisor, 9.5) + (Distance / 75)
                local Curved = false

                local CurveVaildation = Curved and EryndorDATA.Config.LobbyAutoParry.AntiCurveEnabled

                if Ball_Target == tostring(EryndorDATA.Player.LocalPlayer) and Distance <= Parry_Accuracy and not CurveVaildation then
                    local Parry_Time = os.clock()
                    local Time_View = Parry_Time - (EryndorDATA.Parry[Ball].LobbyLastParry)
                    if Time_View > 0.25 and EryndorDATA.Config.LobbyAutoParry.AnimationFix and EryndorDATA.Config.ParrySettings.ParryMethod ~= "Legit" then
                        PlayParry_Animation()
                    end

                    FireParry()

                    EryndorDATA.Parry[Ball].LobbyLastParry = Parry_Time
                    EryndorDATA.Parry[Ball].LobbyParried = true
                end
                local Last_Parrys = tick()
                repeat
                    RunService.PreSimulation:Wait()
                until (tick() - Last_Parrys) >= 1 or not EryndorDATA.Parry[Ball].LobbyParried
                EryndorDATA.Parry[Ball].LobbyParried = false
            end
        end

        if EryndorDATA.Config.AutoSpamParry.Enabled then
            for _, Ball in pairs(BallsList) do
                local Zoomies = Ball:FindFirstChild('zoomies')
                if not Zoomies then
                    EryndorDATA.Config.AutoSpamParry.Spamming = false
                    return
                end

                local Closest_Entity, Closest_Distance = GetClosest_Player()
                local Root = GetCharacter() and GetCharacter().PrimaryPart

                if not Root then
                    EryndorDATA.Config.AutoSpamParry.Spamming = false
                    return
                end

                if not Closest_Entity or not Closest_Entity.PrimaryPart then
                    EryndorDATA.Config.AutoSpamParry.Spamming = false
                    return
                end

                local Ping = EryndorASSETS.ServerStatsItem["Data Ping"]:GetValue()
                local PingFactor = Ping / 500
                local BallSpeed = Zoomies.VectorVelocity.Magnitude

                local TargetCheck = 30.3
                if Ping <= 0 or Ping >= 130 then
                    if Ping <= 131 or Ping >= 160 then
                        if Ping <= 161 or Ping >= 225 then
                            if Ping > 226 and Ping < 500 then
                                TargetCheck = math.clamp(math.floor(math.max(BallSpeed / 4 + PingFactor, 32.5)), 32.5, 80)
                            end
                        else
                            TargetCheck = math.clamp(math.floor(math.max(BallSpeed / 4.25 + PingFactor, 29.5)), 29.5, 70)
                        end
                    else
                        TargetCheck = math.clamp(math.floor(math.max(BallSpeed / 4.65 + PingFactor, 27.25)), 27.25, 70)
                    end
                else
                    TargetCheck = math.clamp(math.floor(math.max(BallSpeed / 5 + PingFactor, 26)), 26, 70)
                end

                local RootPos = Root.Position
                local BallPos = Ball.Position
                local TargetPos = Closest_Entity.PrimaryPart.Position

                local DistToBall = (RootPos - BallPos).Magnitude
                local DistToTarget = (RootPos - TargetPos).Magnitude

                local ParryThreshold = EryndorDATA.Config.AutoSpamParry.ParryThreshold or 1.5
                local DistanceMultiplier = EryndorDATA.Config.AutoSpamParry.DistanceMultiplier or 1.0
                local BallCheck = TargetCheck * ParryThreshold
                local TargetRange = TargetCheck * DistanceMultiplier

                EryndorDATA.Global.AutoSpamParryCurrentAccuracy = BallCheck

                local SpamVaildation = false
                if EryndorDATA.Config.AutoSpamParry.DetectionMode == "Speed" then
                    SpamVaildation = EryndorDATA.Global.Parries > 1
                elseif EryndorDATA.Config.AutoSpamParry.DetectionMode == "Distance" then
                    SpamVaildation = true
                end
                EryndorDATA.Config.AutoSpamParry.Spamming = DistToBall <= BallCheck and DistToTarget <= TargetRange and SpamVaildation
            end
        else
            EryndorDATA.Config.AutoSpamParry.Spamming = false
            EryndorDATA.Global.AutoSpamParryCurrentAccuracy = 0
        end

        if EryndorDATA.Config.TriggerBot.Enabled and not IsSpamming then
            for _, Ball in pairs(BallsList) do
                if not Ball then continue end

                Ball:GetAttributeChangedSignal('target'):Once(function()
                    TriggerBotParried = false
                end)

                if TriggerBotParried then continue end

                local Ball_Target = Ball:GetAttribute('target')
                local Singularity_Cape = EryndorDATA.Player.LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape')

                if Singularity_Cape then continue end
                if EryndorDATA.Config.TriggerBot.InfinityDetection and EryndorDATA.Config.ParrySettings.Detections.InfinityBall.Flag then continue end

                if Ball_Target == tostring(EryndorDATA.Player.LocalPlayer) then
                    if EryndorDATA.Config.TriggerBot.AnimationFix then
                        PlayParry_Animation()
                    end
                    FireParry()
                    TriggerBotParried = true
                end
                local TriggerBot_Last_Parrys = tick()
                repeat
                    RunService.PreSimulation:Wait()
                until (tick() - TriggerBot_Last_Parrys) >= 1 or not TriggerBotParried
                TriggerBotParried = false
            end
        end
        if #BallsList <= 0 then
            EryndorDATA.Global.AutoSpamParryCurrentAccuracy = 0
        end
    end
end

NeverZen:Track(EryndorDATA.Balls.ChildRemoved:Connect(function(Child)
    if EryndorDATA.Parry[Child] then
        EryndorDATA.Parry[Child].TargetConn:Disconnect()
        EryndorDATA.Parry[Child] = nil
    end
    if Visuals.HitEffectService.BallEffects[Child] then
        local hit = Visuals.HitEffectService.BallEffects[Child]
        if hit and hit.Parent then hit:Destroy() end
        Visuals.HitEffectService.BallEffects[Child] = nil
    end
    EryndorDATA.Global.Parries = 0
    EryndorDATA.Config.Animation.SpamAnimationParries = 0
    EryndorDATA.Config.AutoSpamParry.Spamming = false
    UI.BallStats.PeakSpeed = 0
end))

NeverZen:Track(Workspace:WaitForChild("TrainingBalls").ChildRemoved:Connect(function(Child)
    if EryndorDATA.Parry[Child] then
        EryndorDATA.Parry[Child].TargetConn:Disconnect()
        EryndorDATA.Parry[Child] = nil
    end
    if Visuals.HitEffectService.BallEffects[Child] then
        local hit = Visuals.HitEffectService.BallEffects[Child]
        if hit and hit.Parent then hit:Destroy() end
        Visuals.HitEffectService.BallEffects[Child] = nil
    end
end))

local function MakeDraggable(Recv, update, speed)
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(update, TweenInfo.new(speed), {Position = position}):Play()
    end

    Recv.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = update.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    NeverZen:Track(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end))
end

function Visuals.VisualiserService:Enabled(value)
    if value then
        for _, VisualPart in pairs(Visuals.VisualParts) do
            VisualPart.Transparency = 0
        end
    else
        for _, VisualPart in pairs(Visuals.VisualParts) do
            VisualPart.Transparency = 1
        end
    end
end

function Visuals.VisualiserService:SetColor(color)
    for _, Part in pairs(Visuals.VisualParts) do
        TweenService:Create(Part, TweenInfo.new(0.2), {Color = color}):Play()
    end
end

function Visuals.VisualiserService:Update(hrp, position, size)
    local visualPart = Visuals.VisualParts[hrp]
    if visualPart and not visualPart.Parent then
        visualPart = nil
        Visuals.VisualParts[hrp] = nil
    end

    if not visualPart then
        local NewPart = Instance.new("Part")
        NewPart.Name = "VisualPart"
        NewPart.Anchored = true
        NewPart.CanCollide = false
        NewPart.CastShadow = false
        NewPart.Shape = Enum.PartType.Ball
        NewPart.Transparency = Visuals.VisualisersEnabled and 0 or 1
        NewPart.Material = Enum.Material.ForceField
        NewPart.Color = Color3.fromRGB(255, 255, 255)
        NewPart.Size = Vector3.new(size, size, size)
        NewPart.Parent = Workspace

        Visuals.VisualParts[hrp] = NewPart
        visualPart = NewPart
    end

    visualPart.Position = position
    if visualPart.Parent ~= Workspace then
        visualPart.Parent = Workspace
    end

    TweenService:Create(visualPart, TweenInfo.new(0.2), {Size = Vector3.new(size, size, size)}):Play()
end

function Visuals.HitEffectService:Emit(ball, position)
    if not Visuals.HitEffectService.BallEffects[ball] then
        local HitEffect = Instance.new("Attachment")
        local Arcs = Instance.new("ParticleEmitter")

        HitEffect.Name = "HitEffect"
        HitEffect.Parent = ball
        Arcs.Enabled = false
        Arcs.RotSpeed = NumberRange.new(250)
        Arcs.VelocitySpread = -360
        Arcs.Texture = "rbxassetid://8084911316"
        Arcs.ZOffset = 1
        Arcs.LightEmission = 1
        Arcs.Rotation = NumberRange.new(-360, 360)
        Arcs.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1, 0),
            NumberSequenceKeypoint.new(0.25, 0, 0),
            NumberSequenceKeypoint.new(0.75, 0, 0),
            NumberSequenceKeypoint.new(1, 1, 0)
        })
        Arcs.Name = "Arcs"
        Arcs.Lifetime = NumberRange.new(1)
        Arcs.Speed = NumberRange.new(math.random(1, 3))
        Arcs.SpreadAngle = Vector2.new(-360, 360)
        Arcs.Rate = 0
        Arcs.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
        Arcs.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 10, 0),
            NumberSequenceKeypoint.new(1, 10, 0)
        })

        Arcs.Parent = HitEffect
        Visuals.HitEffectService.BallEffects[ball] = HitEffect
    end

    local BallEffect = Visuals.HitEffectService.BallEffects[ball].Arcs
    BallEffect:Emit(1)
end

function ManualSpamParryUIService:Visible(value)
    UI.SpamUI.ScreenGui.Enabled = value
end

function ManualSpamParryUIService:SetColor(value)
    if value then
        local TargetColor = NeverZen.Theme.Hightlight
        local BackgroundColorTween = TweenService:Create(UI.SpamUI.SpamButton, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
        local StrokeColorTween = TweenService:Create(UI.SpamUI.SpamButton.UIStroke, TweenInfo.new(0.2), {Color = TargetColor})
        BackgroundColorTween:Play()
        StrokeColorTween:Play()
        UI.SpamUI.SpamButton.Text = "SPAMMING"
    else
        local TargetColor = Color3.new(152/255, 152/255, 152/255)
        local BackgroundColorTween = TweenService:Create(UI.SpamUI.SpamButton, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
        local StrokeColorTween = TweenService:Create(UI.SpamUI.SpamButton.UIStroke, TweenInfo.new(0.2), {Color = TargetColor})
        BackgroundColorTween:Play()
        StrokeColorTween:Play()
        UI.SpamUI.SpamButton.Text = "SPAM"
    end
end

function TriggerBotUIService:Visible(value)
    UI.TriggerBotUI.ScreenGui.Enabled = value
end

function TriggerBotUIService:SetColor(value)
    if value then
        local TargetColor = NeverZen.Theme.Hightlight
        local BackgroundColorTween = TweenService:Create(UI.TriggerBotUI.TriggerButton, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
        local StrokeColorTween = TweenService:Create(UI.TriggerBotUI.TriggerButton.UIStroke, TweenInfo.new(0.2), {Color = TargetColor})
        BackgroundColorTween:Play()
        StrokeColorTween:Play()
        UI.TriggerBotUI.TriggerButton.Text = "TB ACTIVE"
    else
        local TargetColor = Color3.new(152/255, 152/255, 152/255)
        local BackgroundColorTween = TweenService:Create(UI.TriggerBotUI.TriggerButton, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
        local StrokeColorTween = TweenService:Create(UI.TriggerBotUI.TriggerButton.UIStroke, TweenInfo.new(0.2), {Color = TargetColor})
        BackgroundColorTween:Play()
        StrokeColorTween:Play()
        UI.TriggerBotUI.TriggerButton.Text = "TRIGGER BOT"
    end
end

function ImmortalityUIService:Visible(value)
    if UI.ImmortalityUI.ScreenGui then
        UI.ImmortalityUI.ScreenGui.Enabled = value
    end
end

function ImmortalityUIService:SetColor(value)
    if value then
        local TargetColor = NeverZen.Theme.Hightlight
        local BackgroundColorTween = TweenService:Create(UI.ImmortalityButton, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
        local StrokeColorTween = TweenService:Create(UI.ImmortalityButton.UIStroke, TweenInfo.new(0.2), {Color = TargetColor})
        BackgroundColorTween:Play()
        StrokeColorTween:Play()
        UI.ImmortalityButton.Text = "IMMO ACTIVE"
    else
        local TargetColor = Color3.new(152/255, 152/255, 152/255)
        local BackgroundColorTween = TweenService:Create(UI.ImmortalityButton, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
        local StrokeColorTween = TweenService:Create(UI.ImmortalityButton.UIStroke, TweenInfo.new(0.2), {Color = TargetColor})
        BackgroundColorTween:Play()
        StrokeColorTween:Play()
        UI.ImmortalityButton.Text = "Immortality"
    end
end

function BallStatsUIService:Visible(value)
    if UI.BallStats.ScreenGui then
        UI.BallStats.ScreenGui.Enabled = value
    end
end

function StatsUIService:Visible(value)
    if UI.StatsUI.ScreenGui then
        UI.StatsUI.ScreenGui.Enabled = value
    end
end

local function SaveAllSettings()
    local data = {
        AutoParry = EryndorDATA.Config.AutoParry,
        LobbyAutoParry = EryndorDATA.Config.LobbyAutoParry,
        AutoSpamParry = {
            Enabled = EryndorDATA.Config.AutoSpamParry.Enabled,
            Keybind = EryndorDATA.Config.AutoSpamParry.Keybind,
            DetectionMode = EryndorDATA.Config.AutoSpamParry.DetectionMode,
            AnimationFix = EryndorDATA.Config.AutoSpamParry.AnimationFix,
            Threshold = EryndorDATA.Config.AutoSpamParry.Threshold,
            ParryThreshold = EryndorDATA.Config.AutoSpamParry.ParryThreshold,
            DistanceMultiplier = EryndorDATA.Config.AutoSpamParry.DistanceMultiplier,
            Spamming = false,
        },
        ManualSpamParry = {
            UI = EryndorDATA.Config.ManualSpamParry.UI,
            Keybind = EryndorDATA.Config.ManualSpamParry.Keybind,
            AnimationFix = EryndorDATA.Config.ManualSpamParry.AnimationFix,
            SuperSpam = EryndorDATA.Config.ManualSpamParry.SuperSpam,
            SuperSpamClicks = EryndorDATA.Config.ManualSpamParry.SuperSpamClicks,
            Spamming = false,
        },
        TriggerBot = EryndorDATA.Config.TriggerBot,
        BallStats = EryndorDATA.Config.BallStats,
        ClientStats = EryndorDATA.Config.ClientStats,
        ParrySettings = EryndorDATA.Config.ParrySettings,
        Visuals = {
            VisualisersEnabled = Visuals.VisualisersEnabled,
            HitEffectEnabled = Visuals.HitEffectEnabled,
        },
        Immortality = Immortality,
        SkinChanger = SkinChanger,
        AnimationFixService = AnimationFixService,
    }
    SaveSettings(data)
end

local function LoadAllSettings()
    local data = LoadSettings()
    if data then
        for k, v in pairs(data) do
            if k == "AutoParry" then
                for kk, vv in pairs(v) do EryndorDATA.Config.AutoParry[kk] = vv end
            elseif k == "LobbyAutoParry" then
                for kk, vv in pairs(v) do EryndorDATA.Config.LobbyAutoParry[kk] = vv end
            elseif k == "AutoSpamParry" then
                for kk, vv in pairs(v) do EryndorDATA.Config.AutoSpamParry[kk] = vv end
            elseif k == "ManualSpamParry" then
                for kk, vv in pairs(v) do EryndorDATA.Config.ManualSpamParry[kk] = vv end
            elseif k == "TriggerBot" then
                for kk, vv in pairs(v) do EryndorDATA.Config.TriggerBot[kk] = vv end
            elseif k == "BallStats" then
                EryndorDATA.Config.BallStats.Enabled = v.Enabled
            elseif k == "ClientStats" then
                EryndorDATA.Config.ClientStats.Enabled = v.Enabled
            elseif k == "ParrySettings" then
                for kk, vv in pairs(v) do
                    if kk == "Detections" and type(vv) == "table" then
                        local Dst = EryndorDATA.Config.ParrySettings.Detections
                        for detName, detVal in pairs(vv) do
                            if type(detVal) == "table" and type(Dst[detName]) == "table" then
                                for fieldName, fieldVal in pairs(detVal) do
                                    Dst[detName][fieldName] = fieldVal
                                end
                            end
                        end
                    else
                        EryndorDATA.Config.ParrySettings[kk] = vv
                    end
                end
            elseif k == "Visuals" then
                Visuals.VisualisersEnabled = v.VisualisersEnabled
                Visuals.HitEffectEnabled = v.HitEffectEnabled
            elseif k == "Immortality" then
                for kk, vv in pairs(v) do Immortality[kk] = vv end
            elseif k == "SkinChanger" then
                for kk, vv in pairs(v) do SkinChanger[kk] = vv end
            elseif k == "AnimationFixService" then
                for kk, vv in pairs(v) do AnimationFixService[kk] = vv end
            end
        end
        return true
    end
    return false
end


do
    local ok, err = pcall(function()
        return LoadAllSettings()
    end)
    if ok then
        EryndorDATA.Global.SettingsPreloaded = err and true or false
    else
        EryndorDATA.Global.SettingsPreloaded = false
        warn("[BloodWork] preload settings failed:", tostring(err))
    end

    EryndorDATA.Config.ManualSpamParry.Spamming = false
    EryndorDATA.Config.AutoSpamParry.Spamming = false
    EryndorDATA.Global.AutoParryParried = false

    local PS = EryndorDATA.Config.ParrySettings
    if type(PS.AutoParryAccuracy) == "number" then
        PS.SpeedDivisorMultiplier = 0.7 + (PS.AutoParryAccuracy - 0.8) * (0.35 / 99)
    end
    if type(PS.LobbyAutoParryAccuracy) == "number" then
        PS.LobbySpeedDivisorMultiplier = 0.7 + (PS.LobbyAutoParryAccuracy - 0.8) * (0.35 / 99)
    end
end

do
    UI.Window:AddLabel('General')

    local CombatTab = UI.Window:AddTab({
        Name = "Combat",
        Icon = "swords"
    })

    local AutoParrySection = CombatTab:AddSection({
        Name = "Auto Parry",
        Position = "left"
    })

    local LobbyAutoParrySection = CombatTab:AddSection({
        Name = "Lobby Auto Parry",
        Position = "left"
    })

    local AutoSpamParrySection = CombatTab:AddSection({
        Name = "Auto Spam Parry [BETA]",
        Position = "right"
    })

    local ManualSpamParrySection = CombatTab:AddSection({
        Name = "Manual Spam Parry",
        Position = "right"
    })

    local TriggerBotSection = CombatTab:AddSection({
        Name = "Trigger Bot",
        Position = "left"
    })

    do
        UI.AutoParryToggle = AutoParrySection:AddToggle({
            Name = 'Enabled',
            Default = EryndorDATA.Config.AutoParry.Enabled,
            Callback = function(value)
                EryndorDATA.Config.AutoParry.Enabled = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddSlider({
            Name = "Accuracy",
            Min = 0,
            Max = 100,
            Round = 0,
            Default = EryndorDATA.Config.ParrySettings.AutoParryAccuracy,
            Type = "%",
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.AutoParryAccuracy = value
                EryndorDATA.Config.ParrySettings.SpeedDivisorMultiplier = 0.7 + (value - 0.8) * (0.35 / 99)
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddToggle({
            Name = 'Auto Accuracy',
            Default = EryndorDATA.Config.ParrySettings.AutoParryAutoAccuracy,
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.AutoParryAutoAccuracy = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddKeybind({
            Name = "Keybind",
            Default = EryndorDATA.Config.AutoParry.Keybind,
            Callback = function(key)
                EryndorDATA.Config.AutoParry.Keybind = key
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddToggle({
            Name = 'Animation Fix',
            Default = EryndorDATA.Config.AutoParry.AnimationFix,
            Callback = function(value)
                EryndorDATA.Config.AutoParry.AnimationFix = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddDivider({
            Color = Color3.fromRGB(50, 50, 50),
            Height = 1
        })

        AutoParrySection:AddToggle({
            Name = 'Anti Curve',
            Default = EryndorDATA.Config.AutoParry.AntiCurveEnabled,
            Callback = function(value)
                EryndorDATA.Config.AutoParry.AntiCurveEnabled = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddDivider({
            Color = Color3.fromRGB(50, 50, 50),
            Height = 1
        })

        AutoParrySection:AddToggle({
            Name = 'Infinity Detection',
            Default = EryndorDATA.Config.ParrySettings.Detections.InfinityBall.Enabled,
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.Detections.InfinityBall.Enabled = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddToggle({
            Name = 'Death Slash Detection',
            Default = EryndorDATA.Config.ParrySettings.Detections.DeathSlashBall.Enabled,
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.Detections.DeathSlashBall.Enabled = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddToggle({
            Name = 'Time Hole Detection',
            Default = EryndorDATA.Config.ParrySettings.Detections.TimeHole.Enabled,
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.Detections.TimeHole.Enabled = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddDivider({
            Color = Color3.fromRGB(50, 50, 50),
            Height = 1
        })

        AutoParrySection:AddToggle({
            Name = 'Slashes of Fury Detection',
            Default = EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Enabled,
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Enabled = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddSlider({
            Name = "Count",
            Min = 1,
            Max = 36,
            Round = 0,
            Default = EryndorDATA.Config.ParrySettings.SlashesofFuryDetectionMaxParryCount,
            Type = "",
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.SlashesofFuryDetectionMaxParryCount = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddSlider({
            Name = "Delay",
            Min = 0,
            Max = 1,
            Round = 2,
            Default = EryndorDATA.Config.ParrySettings.SlashesofFuryDetectionParryDelay,
            Type = "",
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.SlashesofFuryDetectionParryDelay = value
                SaveAllSettings()
            end,
        })

        AutoParrySection:AddDivider({
            Color = Color3.fromRGB(50, 50, 50),
            Height = 1
        })

        do
            local AddedDetections = {
                {Name = 'Forcefield Detection',    Key = 'Forcefield'},
                {Name = 'Phantom Detection',       Key = 'Phantom'},
                {Name = 'Singularity Detection',   Key = 'Singularity'},
                {Name = 'Dribble Detection',       Key = 'Dribble'},
                {Name = 'Pull Detection',          Key = 'Pull'},
                {Name = 'Pulse Detection',         Key = 'Pulse'},
                {Name = 'Ability Active Detection',Key = 'AbilityActive'},
                {Name = 'Tornado Detection',       Key = 'Tornado'},
                {Name = 'Anti Hell Hook',          Key = 'HellHook'},
            }
            for _, det in ipairs(AddedDetections) do
                AutoParrySection:AddToggle({
                    Name = det.Name,
                    Default = EryndorDATA.Config.ParrySettings.Detections[det.Key].Enabled,
                    Callback = function(value)
                        EryndorDATA.Config.ParrySettings.Detections[det.Key].Enabled = value
                        SaveAllSettings()
                    end,
                })
            end
        end

        AutoParrySection:AddDivider({
            Color = Color3.fromRGB(50, 50, 50),
            Height = 1
        })

    end

    do
        LobbyAutoParrySection:AddToggle({
            Name = 'Enabled',
            Default = EryndorDATA.Config.LobbyAutoParry.Enabled,
            Callback = function(value)
                EryndorDATA.Config.LobbyAutoParry.Enabled = value
                SaveAllSettings()
            end,
        })

        LobbyAutoParrySection:AddSlider({
            Name = "Accuracy",
            Min = 0,
            Max = 100,
            Round = 0,
            Default = EryndorDATA.Config.ParrySettings.LobbyAutoParryAccuracy,
            Type = "%",
            Callback = function(value)
                EryndorDATA.Config.ParrySettings.LobbyAutoParryAccuracy = value
                EryndorDATA.Config.ParrySettings.LobbySpeedDivisorMultiplier = 0.7 + (value - 0.8) * (0.35 / 99)
                SaveAllSettings()
            end,
        })

        LobbyAutoParrySection:AddToggle({
            Name = 'Anti Curve',
            Default = EryndorDATA.Config.LobbyAutoParry.AntiCurveEnabled,
            Callback = function(value)
                EryndorDATA.Config.LobbyAutoParry.AntiCurveEnabled = value
                SaveAllSettings()
            end,
        })

        LobbyAutoParrySection:AddToggle({
            Name = 'Animation Fix',
            Default = EryndorDATA.Config.LobbyAutoParry.AnimationFix,
            Callback = function(value)
                EryndorDATA.Config.LobbyAutoParry.AnimationFix = value
                SaveAllSettings()
            end,
        })
    end

    do
        AutoSpamParrySection:AddToggle({
            Name = 'Enabled',
            Default = EryndorDATA.Config.AutoSpamParry.Enabled,
            Callback = function(value)
                EryndorDATA.Config.AutoSpamParry.Enabled = value
                SaveAllSettings()
            end,
        })

        AutoSpamParrySection:AddDropdown({
            Name = "Detection Mode",
            Default = EryndorDATA.Config.AutoSpamParry.DetectionMode,
            Values = {"Distance", "Speed"},
            Callback = function(value)
                EryndorDATA.Config.AutoSpamParry.DetectionMode = value
                SaveAllSettings()
            end,
        })

        AutoSpamParrySection:AddSlider({
            Name = "Parry Threshold",
            Min = 1,
            Max = 4.5,
            Round = 1,
            Default = EryndorDATA.Config.AutoSpamParry.ParryThreshold,
            Type = "x",
            Callback = function(value)
                EryndorDATA.Config.AutoSpamParry.ParryThreshold = math.clamp(value, 1, 4.5)
                SaveAllSettings()
            end,
        })

        AutoSpamParrySection:AddSlider({
            Name = "Distance Multiplier",
            Min = 0.3,
            Max = 5,
            Round = 1,
            Default = EryndorDATA.Config.AutoSpamParry.DistanceMultiplier,
            Type = "x",
            Callback = function(value)
                EryndorDATA.Config.AutoSpamParry.DistanceMultiplier = math.clamp(value, 0.3, 5)
                SaveAllSettings()
            end,
        })

        AutoSpamParrySection:AddToggle({
            Name = 'Animation Fix',
            Default = EryndorDATA.Config.AutoSpamParry.AnimationFix,
            Callback = function(value)
                EryndorDATA.Config.AutoSpamParry.AnimationFix = value
                SaveAllSettings()
            end,
        })
    end

    do
        UI.ManualSpamParryToggle = ManualSpamParrySection:AddToggle({
            Name = 'Active',
            Default = EryndorDATA.Config.ManualSpamParry.Spamming,
            Callback = function(value)
                EryndorDATA.Config.ManualSpamParry.Spamming = value
                ManualSpamParryUIService:SetColor(value)
                SaveAllSettings()
            end,
        })

        ManualSpamParrySection:AddToggle({
            Name = 'UI',
            Default = EryndorDATA.Config.ManualSpamParry.UI,
            Callback = function(value)
                EryndorDATA.Config.ManualSpamParry.UI = value
                ManualSpamParryUIService:Visible(value)
                SaveAllSettings()
            end,
        })

        ManualSpamParrySection:AddKeybind({
            Name = "Keybind",
            Default = EryndorDATA.Config.ManualSpamParry.Keybind,
            Callback = function(key)
                EryndorDATA.Config.ManualSpamParry.Keybind = key
                SaveAllSettings()
            end,
        })

        ManualSpamParrySection:AddToggle({
            Name = 'Animation Fix',
            Default = EryndorDATA.Config.ManualSpamParry.AnimationFix,
            Callback = function(value)
                EryndorDATA.Config.ManualSpamParry.AnimationFix = value
                SaveAllSettings()
            end,
        })

        ManualSpamParrySection:AddToggle({
            Name = 'Super Spam',
            Default = EryndorDATA.Config.ManualSpamParry.SuperSpam,
            Callback = function(value)
                EryndorDATA.Config.ManualSpamParry.SuperSpam = value
                SaveAllSettings()
            end,
        })

        ManualSpamParrySection:AddSlider({
            Name = "Clicks Per Burst",
            Min = 1,
            Max = 20,
            Round = 0,
            Default = EryndorDATA.Config.ManualSpamParry.SuperSpamClicks,
            Type = "",
            Callback = function(value)
                EryndorDATA.Config.ManualSpamParry.SuperSpamClicks = value
                SaveAllSettings()
            end,
        })
    end

    do
        UI.TriggerBotToggle = TriggerBotSection:AddToggle({
            Name = 'Active',
            Default = EryndorDATA.Config.TriggerBot.Enabled,
            Callback = function(value)
                EryndorDATA.Config.TriggerBot.Enabled = value
                TriggerBotUIService:SetColor(value)
                SaveAllSettings()
            end,
        })

        TriggerBotSection:AddToggle({
            Name = 'UI',
            Default = EryndorDATA.Config.TriggerBot.UI,
            Callback = function(value)
                EryndorDATA.Config.TriggerBot.UI = value
                TriggerBotUIService:Visible(value)
                SaveAllSettings()
            end,
        })

        TriggerBotSection:AddKeybind({
            Name = "Keybind",
            Default = EryndorDATA.Config.TriggerBot.Keybind,
            Callback = function(key)
                EryndorDATA.Config.TriggerBot.Keybind = key
                SaveAllSettings()
            end,
        })

        TriggerBotSection:AddToggle({
            Name = 'Animation Fix',
            Default = EryndorDATA.Config.TriggerBot.AnimationFix,
            Callback = function(value)
                EryndorDATA.Config.TriggerBot.AnimationFix = value
                SaveAllSettings()
            end,
        })

        TriggerBotSection:AddDivider({
            Color = Color3.fromRGB(50, 50, 50),
            Height = 1
        })

        TriggerBotSection:AddToggle({
            Name = 'Infinity Detection',
            Default = EryndorDATA.Config.TriggerBot.InfinityDetection,
            Callback = function(value)
                EryndorDATA.Config.TriggerBot.InfinityDetection = value
                SaveAllSettings()
            end,
        })
    end

    UI.Window:AddLabel('Miscellaneous')

    local SettingsTab = UI.Window:AddTab({
        Name = "Settings",
        Icon = "settings"
    })

    local SpammingSection = SettingsTab:AddSection({
        Name = "Spamming",
        Position = "left"
    })

    UI.SpamLoopRPSLabel = SpammingSection:AddLabel("Loop RPS: 0")
    UI.SpamAccumulatorLabel = SpammingSection:AddLabel("Accumulator: 0")

    SpammingSection:AddDivider({
        Color = Color3.fromRGB(50, 50, 50),
        Height = 1
    })

    SpammingSection:AddSlider({
        Name = "Target RPS",
        Min = 60,
        Max = 640,
        Round = 0,
        Default = EryndorDATA.Config.ParrySettings.SpammingRPS,
        Type = " rps",
        Callback = function(value)
            EryndorDATA.Config.ParrySettings.SpammingRPS = value
            SaveAllSettings()
        end,
    })

    SpammingSection:AddButton({
        Name = "Reset Accumulator",
        Callback = function()
            ResetAccumulator()
        end,
    })

    local ParrySystemSection = SettingsTab:AddSection({
        Name = "Parry System",
        Position = "right"
    })

    ParrySystemSection:AddDropdown({
        Name = "Method",
        Default = EryndorDATA.Config.ParrySettings.ParryMethod,
        Values = {"Legit", "Blatant"},
        Callback = function(value)
            EryndorDATA.Config.ParrySettings.ParryMethod = value
            SaveAllSettings()
        end,
    })

    ParrySystemSection:AddDivider({
        Color = Color3.fromRGB(50, 50, 50),
        Height = 2
    })

    ParrySystemSection:AddButton({
        Name = "Refetch function",
        Callback = function()
            NZNotification.new("BloodWork :[", "Attempting to re-fetch parry function, might cause a possible freeze", 5)
            local Result = AttemptFunctionFetch()
            ParryDATA.ParryFunction = Result.ParryFunction
            ParryDATA.ParryRemote = Result.ParryRemote

            if ParryDATA.ParryFunction and ParryDATA.ParryRemote then
                NZNotification.new('BloodWork :[', 'Successfully fetched game data.', 5)
            else
                NZNotification.new('BloodWork :[', 'Failed to fetch game data, please check developer console.', 5)
            end
        end,
    })

    ParrySystemSection:AddDivider({
        Color = Color3.fromRGB(50, 50, 50),
        Height = 1
    })

    ParrySystemSection:AddDropdown({
        Name = "Curve Direction",
        Default = EryndorDATA.Config.ParrySettings.ParryCurveDirection,
        Values = {"Camera", "Straight", "Up", "Down", "Left", "Right", "Backward", "Accelerate", "Decelerate", "Random"},
        Callback = function(value)
            EryndorDATA.Config.ParrySettings.ParryCurveDirection = value
            SaveAllSettings()
        end,
    })

    ParrySystemSection:AddToggle({
        Name = 'Safe Mode',
        Default = EryndorDATA.Config.ParrySettings.SafeMode,
        Callback = function(value)
            EryndorDATA.Config.ParrySettings.SafeMode = value
            SaveAllSettings()
        end,
    })

    local AnimationFixSection = SettingsTab:AddSection({
        Name = "Animation Fix",
        Position = "left"
    })

    AnimationFixSection:AddSlider({
        Name = "Max Rate",
        Min = 30,
        Max = 240,
        Round = 0,
        Default = AnimationFixService.Rate,
        Type = " FPS",
        Callback = function(value)
            AnimationFixService.Rate = value
            SaveAllSettings()
        end,
    })

    AnimationFixSection:AddToggle({
        Name = 'Spam FE',
        Default = AnimationFixService.FEMode,
        Callback = function(value)
            AnimationFixService.FEMode = value
            SaveAllSettings()
        end,
    })

    local UtilitiesSettingsSection = SettingsTab:AddSection({
        Name = "Utilities",
        Position = "right"
    })

    UtilitiesSettingsSection:AddButton({
        Name = "FPS Boost",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/EjPHWj2u"))()
        end,
    })

    local ConfigSection = SettingsTab:AddSection({
        Name = "Configuration",
        Position = "right"
    })

    ConfigSection:AddButton({
        Name = "Reset Config",
        Callback = function()
            local removed = false
            pcall(function()
                if isfile and isfile(SETTINGS_FILE) and delfile then
                    delfile(SETTINGS_FILE)
                    removed = true
                end
            end)
            if removed then
                NZNotification.new('BloodWork :[', 'Config reset. Rejoin or reload to apply defaults.', 5)
            else
                NZNotification.new('BloodWork :[', 'No config file to reset.', 3)
            end
        end,
    })

    local MaintenceSection = SettingsTab:AddSection({
        Name = "Maintenance",
        Position = "left"
    })

    MaintenceSection:AddButton({
        Name = "Clear Cache",
        Callback = function()
            ClearCache()
        end,
    })

    MaintenceSection:AddButton({
        Name = "Unload",
        Callback = function()
            UnloadEryndor()
        end,
    })
end

do
    UI.SpamUI.ScreenGui = Instance.new("ScreenGui")
    UI.SpamUI.ScreenGui.Name = "ScreenGui"
    UI.SpamUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.SpamUI.ScreenGui.ResetOnSpawn = false
    UI.SpamUI.ScreenGui.IgnoreGuiInset = true
    UI.SpamUI.ScreenGui.Parent = CoreGui

    NeverZen.ProtectGui(UI.SpamUI.ScreenGui)

    UI.SpamUI.Handler = Instance.new("CanvasGroup")
    UI.SpamUI.Handler.Name = "Handler"
    UI.SpamUI.Handler.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.SpamUI.Handler.Size = UDim2.new(0, 140, 0, 80)
    UI.SpamUI.Handler.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.SpamUI.Handler.BackgroundTransparency = 1
    UI.SpamUI.Handler.BorderSizePixel = 0
    UI.SpamUI.Handler.BorderColor3 = Color3.new(0, 0, 0)
    UI.SpamUI.Handler.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.SpamUI.Handler.Transparency = 1
    UI.SpamUI.Handler.ClipsDescendants = true
    UI.SpamUI.Handler.Active = true
    UI.SpamUI.Handler.Parent = UI.SpamUI.ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = UI.SpamUI.Handler

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "ButtonFrame"
    ButtonFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    ButtonFrame.Size = UDim2.new(1, 0, 1, 0)
    ButtonFrame.BackgroundColor3 = Color3.new(0.0470588, 0.0470588, 0.0470588)
    ButtonFrame.BackgroundTransparency = 0.1
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.BorderColor3 = Color3.new(0, 0, 0)
    ButtonFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ButtonFrame.Transparency = 0.1
    ButtonFrame.Parent = UI.SpamUI.Handler

    UI.SpamUI.SpamButton = Instance.new("TextButton")
    UI.SpamUI.SpamButton.Name = "SpamButton"
    UI.SpamUI.SpamButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.SpamUI.SpamButton.Size = UDim2.new(1, -15, 1, -15)
    UI.SpamUI.SpamButton.BackgroundColor3 = Color3.new(152/255, 152/255, 152/255)
    UI.SpamUI.SpamButton.BackgroundTransparency = 0.75
    UI.SpamUI.SpamButton.BorderSizePixel = 0
    UI.SpamUI.SpamButton.BorderColor3 = Color3.new(0, 0, 0)
    UI.SpamUI.SpamButton.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.SpamUI.SpamButton.TextTransparency = 0.25
    UI.SpamUI.SpamButton.Text = "SPAM"
    UI.SpamUI.SpamButton.TextColor3 = Color3.new(1, 1, 1)
    UI.SpamUI.SpamButton.TextSize = 18
    UI.SpamUI.SpamButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    UI.SpamUI.SpamButton.TextScaled = false
    UI.SpamUI.SpamButton.TextWrapped = true
    UI.SpamUI.SpamButton.Parent = ButtonFrame

    local UICorner2 = Instance.new("UICorner")
    UICorner2.Name = "UICorner"
    UICorner2.CornerRadius = UDim.new(0, 2)
    UICorner2.Parent = UI.SpamUI.SpamButton

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.Color = Color3.new(152/255, 152/255, 152/255)
    UIStroke.Transparency = 0.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = UI.SpamUI.SpamButton

    local UIStroke2 = Instance.new("UIStroke")
    UIStroke2.Name = "UIStroke"
    UIStroke2.Color = Color3.new(0, 0.0980392, 0.133333)
    UIStroke2.Transparency = 0.85
    UIStroke2.Parent = UI.SpamUI.Handler

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    UIAspectRatioConstraint.AspectRatio = 2
    UIAspectRatioConstraint.Parent = UI.SpamUI.Handler

    local function ToggleSpam()
        EryndorDATA.Config.ManualSpamParry.Spamming = not EryndorDATA.Config.ManualSpamParry.Spamming
        UI.ManualSpamParryToggle:SetValue(EryndorDATA.Config.ManualSpamParry.Spamming)
        ManualSpamParryUIService:SetColor(EryndorDATA.Config.ManualSpamParry.Spamming)
        SaveAllSettings()
    end

    UI.SpamUI.SpamButton.MouseButton1Click:Connect(ToggleSpam)
    MakeDraggable(UI.SpamUI.Handler, UI.SpamUI.Handler, 0.2)
end

do
    UI.TriggerBotUI.ScreenGui = Instance.new("ScreenGui")
    UI.TriggerBotUI.ScreenGui.Name = "TriggerScreenGui"
    UI.TriggerBotUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.TriggerBotUI.ScreenGui.ResetOnSpawn = false
    UI.TriggerBotUI.ScreenGui.IgnoreGuiInset = true
    UI.TriggerBotUI.ScreenGui.Parent = CoreGui

    NeverZen.ProtectGui(UI.TriggerBotUI.ScreenGui)

    UI.TriggerBotUI.Handler = Instance.new("CanvasGroup")
    UI.TriggerBotUI.Handler.Name = "TriggerHandler"
    UI.TriggerBotUI.Handler.Position = UDim2.new(0.3, 0, 0.5, 0)
    UI.TriggerBotUI.Handler.Size = UDim2.new(0, 140, 0, 80)
    UI.TriggerBotUI.Handler.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.TriggerBotUI.Handler.BackgroundTransparency = 1
    UI.TriggerBotUI.Handler.BorderSizePixel = 0
    UI.TriggerBotUI.Handler.BorderColor3 = Color3.new(0, 0, 0)
    UI.TriggerBotUI.Handler.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.TriggerBotUI.Handler.Transparency = 1
    UI.TriggerBotUI.Handler.ClipsDescendants = true
    UI.TriggerBotUI.Handler.Active = true
    UI.TriggerBotUI.Handler.Parent = UI.TriggerBotUI.ScreenGui

    local UICornerTrigger = Instance.new("UICorner")
    UICornerTrigger.Name = "UICorner"
    UICornerTrigger.CornerRadius = UDim.new(0, 4)
    UICornerTrigger.Parent = UI.TriggerBotUI.Handler

    local TriggerButtonFrame = Instance.new("Frame")
    TriggerButtonFrame.Name = "TriggerButtonFrame"
    TriggerButtonFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TriggerButtonFrame.Size = UDim2.new(1, 0, 1, 0)
    TriggerButtonFrame.BackgroundColor3 = Color3.new(0.0470588, 0.0470588, 0.0470588)
    TriggerButtonFrame.BackgroundTransparency = 0.1
    TriggerButtonFrame.BorderSizePixel = 0
    TriggerButtonFrame.BorderColor3 = Color3.new(0, 0, 0)
    TriggerButtonFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    TriggerButtonFrame.Transparency = 0.1
    TriggerButtonFrame.Parent = UI.TriggerBotUI.Handler

    UI.TriggerBotUI.TriggerButton = Instance.new("TextButton")
    UI.TriggerBotUI.TriggerButton.Name = "TriggerButton"
    UI.TriggerBotUI.TriggerButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.TriggerBotUI.TriggerButton.Size = UDim2.new(1, -15, 1, -15)
    UI.TriggerBotUI.TriggerButton.BackgroundColor3 = Color3.new(152/255, 152/255, 152/255)
    UI.TriggerBotUI.TriggerButton.BackgroundTransparency = 0.75
    UI.TriggerBotUI.TriggerButton.BorderSizePixel = 0
    UI.TriggerBotUI.TriggerButton.BorderColor3 = Color3.new(0, 0, 0)
    UI.TriggerBotUI.TriggerButton.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.TriggerBotUI.TriggerButton.TextTransparency = 0.25
    UI.TriggerBotUI.TriggerButton.Text = "TRIGGER BOT"
    UI.TriggerBotUI.TriggerButton.TextColor3 = Color3.new(1, 1, 1)
    UI.TriggerBotUI.TriggerButton.TextSize = 18
    UI.TriggerBotUI.TriggerButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    UI.TriggerBotUI.TriggerButton.TextScaled = false
    UI.TriggerBotUI.TriggerButton.TextWrapped = true
    UI.TriggerBotUI.TriggerButton.Parent = TriggerButtonFrame

    local UICornerTrigger2 = Instance.new("UICorner")
    UICornerTrigger2.Name = "UICorner"
    UICornerTrigger2.CornerRadius = UDim.new(0, 2)
    UICornerTrigger2.Parent = UI.TriggerBotUI.TriggerButton

    local UIStrokeTrigger = Instance.new("UIStroke")
    UIStrokeTrigger.Name = "UIStroke"
    UIStrokeTrigger.Color = Color3.new(152/255, 152/255, 152/255)
    UIStrokeTrigger.Transparency = 0.5
    UIStrokeTrigger.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStrokeTrigger.Parent = UI.TriggerBotUI.TriggerButton

    local UIStrokeTrigger2 = Instance.new("UIStroke")
    UIStrokeTrigger2.Name = "UIStroke"
    UIStrokeTrigger2.Color = Color3.new(0, 0.0980392, 0.133333)
    UIStrokeTrigger2.Transparency = 0.85
    UIStrokeTrigger2.Parent = UI.TriggerBotUI.Handler

    local UIAspectRatioConstraintTrigger = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraintTrigger.Name = "UIAspectRatioConstraint"
    UIAspectRatioConstraintTrigger.AspectRatio = 2
    UIAspectRatioConstraintTrigger.Parent = UI.TriggerBotUI.Handler

    local function ToggleTriggerBot()
        EryndorDATA.Config.TriggerBot.Enabled = not EryndorDATA.Config.TriggerBot.Enabled
        UI.TriggerBotToggle:SetValue(EryndorDATA.Config.TriggerBot.Enabled)
        TriggerBotUIService:SetColor(EryndorDATA.Config.TriggerBot.Enabled)
        SaveAllSettings()
    end

    UI.TriggerBotUI.TriggerButton.MouseButton1Click:Connect(ToggleTriggerBot)
    MakeDraggable(UI.TriggerBotUI.Handler, UI.TriggerBotUI.Handler, 0.2)
end

do
    UI.ImmortalityUI.ScreenGui = Instance.new("ScreenGui")
    UI.ImmortalityUI.ScreenGui.Name = "ImmortalityScreenGui"
    UI.ImmortalityUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.ImmortalityUI.ScreenGui.ResetOnSpawn = false
    UI.ImmortalityUI.ScreenGui.IgnoreGuiInset = true
    UI.ImmortalityUI.ScreenGui.Parent = CoreGui

    NeverZen.ProtectGui(UI.ImmortalityUI.ScreenGui)

    UI.ImmortalityUI.Handler = Instance.new("CanvasGroup")
    UI.ImmortalityUI.Handler.Name = "ImmortalityHandler"
    UI.ImmortalityUI.Handler.Position = UDim2.new(0.1, 0, 0.5, 0)
    UI.ImmortalityUI.Handler.Size = UDim2.new(0, 140, 0, 80)
    UI.ImmortalityUI.Handler.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.ImmortalityUI.Handler.BackgroundTransparency = 1
    UI.ImmortalityUI.Handler.BorderSizePixel = 0
    UI.ImmortalityUI.Handler.BorderColor3 = Color3.new(0, 0, 0)
    UI.ImmortalityUI.Handler.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.ImmortalityUI.Handler.Transparency = 1
    UI.ImmortalityUI.Handler.ClipsDescendants = true
    UI.ImmortalityUI.Handler.Active = true
    UI.ImmortalityUI.Handler.Parent = UI.ImmortalityUI.ScreenGui

    local UICornerImm = Instance.new("UICorner")
    UICornerImm.Name = "UICorner"
    UICornerImm.CornerRadius = UDim.new(0, 4)
    UICornerImm.Parent = UI.ImmortalityUI.Handler

    local ImmButtonFrame = Instance.new("Frame")
    ImmButtonFrame.Name = "ImmButtonFrame"
    ImmButtonFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImmButtonFrame.Size = UDim2.new(1, 0, 1, 0)
    ImmButtonFrame.BackgroundColor3 = Color3.new(0.0470588, 0.0470588, 0.0470588)
    ImmButtonFrame.BackgroundTransparency = 0.1
    ImmButtonFrame.BorderSizePixel = 0
    ImmButtonFrame.BorderColor3 = Color3.new(0, 0, 0)
    ImmButtonFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ImmButtonFrame.Transparency = 0.1
    ImmButtonFrame.Parent = UI.ImmortalityUI.Handler

    UI.ImmortalityButton = Instance.new("TextButton")
    UI.ImmortalityButton.Name = "ImmortalityButton"
    UI.ImmortalityButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.ImmortalityButton.Size = UDim2.new(1, -15, 1, -15)
    UI.ImmortalityButton.BackgroundColor3 = Color3.new(152/255, 152/255, 152/255)
    UI.ImmortalityButton.BackgroundTransparency = 0.75
    UI.ImmortalityButton.BorderSizePixel = 0
    UI.ImmortalityButton.BorderColor3 = Color3.new(0, 0, 0)
    UI.ImmortalityButton.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.ImmortalityButton.TextTransparency = 0.25
    UI.ImmortalityButton.Text = "Immortality"
    UI.ImmortalityButton.TextColor3 = Color3.new(1, 1, 1)
    UI.ImmortalityButton.TextSize = 18
    UI.ImmortalityButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    UI.ImmortalityButton.TextScaled = false
    UI.ImmortalityButton.TextWrapped = true
    UI.ImmortalityButton.Parent = ImmButtonFrame

    local UICornerImm2 = Instance.new("UICorner")
    UICornerImm2.Name = "UICorner"
    UICornerImm2.CornerRadius = UDim.new(0, 2)
    UICornerImm2.Parent = UI.ImmortalityButton

    local UIStrokeImm = Instance.new("UIStroke")
    UIStrokeImm.Name = "UIStroke"
    UIStrokeImm.Color = Color3.new(152/255, 152/255, 152/255)
    UIStrokeImm.Transparency = 0.5
    UIStrokeImm.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStrokeImm.Parent = UI.ImmortalityButton

    local UIStrokeImm2 = Instance.new("UIStroke")
    UIStrokeImm2.Name = "UIStroke"
    UIStrokeImm2.Color = Color3.new(0, 0.0980392, 0.133333)
    UIStrokeImm2.Transparency = 0.85
    UIStrokeImm2.Parent = UI.ImmortalityUI.Handler

    local UIAspectImm = Instance.new("UIAspectRatioConstraint")
    UIAspectImm.Name = "UIAspectRatioConstraint"
    UIAspectImm.AspectRatio = 2
    UIAspectImm.Parent = UI.ImmortalityUI.Handler

    local function ToggleImmortality()
        Immortality.Enabled = not Immortality.Enabled
        if UI.ImmortalityToggle then
            UI.ImmortalityToggle:SetValue(Immortality.Enabled)
        end
        ImmortalityUIService:SetColor(Immortality.Enabled)
        SaveAllSettings()
    end

    UI.ImmortalityButton.MouseButton1Click:Connect(ToggleImmortality)
    MakeDraggable(UI.ImmortalityUI.Handler, UI.ImmortalityUI.Handler, 0.2)
end

do
    UI.BallStats.ScreenGui = Instance.new("ScreenGui")
    UI.BallStats.ScreenGui.Name = "BallStatsUI"
    UI.BallStats.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.BallStats.ScreenGui.ResetOnSpawn = false
    UI.BallStats.ScreenGui.IgnoreGuiInset = true
    UI.BallStats.ScreenGui.Enabled = false
    UI.BallStats.ScreenGui.Parent = CoreGui

    NeverZen.ProtectGui(UI.BallStats.ScreenGui)

    UI.BallStats.Handler = Instance.new("CanvasGroup")
    UI.BallStats.Handler.Name = "Handler"
    UI.BallStats.Handler.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.BallStats.Handler.Size = UDim2.new(0, 170, 0, 90)
    UI.BallStats.Handler.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.BallStats.Handler.BackgroundTransparency = 1
    UI.BallStats.Handler.BorderSizePixel = 0
    UI.BallStats.Handler.BorderColor3 = Color3.new(0, 0, 0)
    UI.BallStats.Handler.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.BallStats.Handler.ClipsDescendants = true
    UI.BallStats.Handler.Active = true
    UI.BallStats.Handler.Parent = UI.BallStats.ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = UI.BallStats.Handler

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.BackgroundColor3 = Color3.new(0.0470588, 0.0470588, 0.0470588)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.BorderColor3 = Color3.new(0, 0, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = UI.BallStats.Handler

    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = "LabelFrame"
    LabelFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LabelFrame.Size = UDim2.new(1, -15, 1, -15)
    LabelFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.BorderSizePixel = 0
    LabelFrame.BorderColor3 = Color3.new(0, 0, 0)
    LabelFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LabelFrame.Parent = MainFrame

    local Speed = Instance.new("Frame")
    Speed.Name = "Speed"
    Speed.Size = UDim2.new(1, 0, 0.5, 0)
    Speed.BackgroundColor3 = Color3.new(1, 1, 1)
    Speed.BackgroundTransparency = 1
    Speed.BorderSizePixel = 0
    Speed.BorderColor3 = Color3.new(0, 0, 0)
    Speed.Parent = LabelFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Position = UDim2.new(0.5, 0, 0, 10)
    Title.Size = UDim2.new(1, 0, 0, 10)
    Title.BackgroundColor3 = Color3.new(1, 1, 1)
    Title.BackgroundTransparency = 1
    Title.BorderSizePixel = 0
    Title.BorderColor3 = Color3.new(0, 0, 0)
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Text = "CURRENT SPEED"
    Title.TextColor3 = Color3.new(0.588235, 0.588235, 0.588235)
    Title.TextSize = 14
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Speed

    UI.BallStats.SpeedValue = Instance.new("TextLabel")
    UI.BallStats.SpeedValue.Name = "Value"
    UI.BallStats.SpeedValue.Position = UDim2.new(0.5, 0, 1, 0)
    UI.BallStats.SpeedValue.Size = UDim2.new(1, 0, 0, 20)
    UI.BallStats.SpeedValue.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.BallStats.SpeedValue.BackgroundTransparency = 1
    UI.BallStats.SpeedValue.BorderSizePixel = 0
    UI.BallStats.SpeedValue.BorderColor3 = Color3.new(0, 0, 0)
    UI.BallStats.SpeedValue.AnchorPoint = Vector2.new(0.5, 1)
    UI.BallStats.SpeedValue.Text = "0"
    UI.BallStats.SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    UI.BallStats.SpeedValue.TextSize = 20
    UI.BallStats.SpeedValue.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    UI.BallStats.SpeedValue.TextXAlignment = Enum.TextXAlignment.Left
    UI.BallStats.SpeedValue.Parent = Speed

    local PeakSpeed = Instance.new("Frame")
    PeakSpeed.Name = "PeakSpeed"
    PeakSpeed.Position = UDim2.new(0, 0, 0.5, 0)
    PeakSpeed.Size = UDim2.new(1, 0, 0.5, 0)
    PeakSpeed.BackgroundColor3 = Color3.new(1, 1, 1)
    PeakSpeed.BackgroundTransparency = 1
    PeakSpeed.BorderSizePixel = 0
    PeakSpeed.BorderColor3 = Color3.new(0, 0, 0)
    PeakSpeed.Parent = LabelFrame

    UI.BallStats.PeakSpeedValue = Instance.new("TextLabel")
    UI.BallStats.PeakSpeedValue.Name = "Value"
    UI.BallStats.PeakSpeedValue.Position = UDim2.new(0.5, 0, 1, 0)
    UI.BallStats.PeakSpeedValue.Size = UDim2.new(1, 0, 0, 20)
    UI.BallStats.PeakSpeedValue.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.BallStats.PeakSpeedValue.BackgroundTransparency = 1
    UI.BallStats.PeakSpeedValue.BorderSizePixel = 0
    UI.BallStats.PeakSpeedValue.BorderColor3 = Color3.new(0, 0, 0)
    UI.BallStats.PeakSpeedValue.AnchorPoint = Vector2.new(0.5, 1)
    UI.BallStats.PeakSpeedValue.Text = "0"
    UI.BallStats.PeakSpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    UI.BallStats.PeakSpeedValue.TextSize = 20
    UI.BallStats.PeakSpeedValue.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    UI.BallStats.PeakSpeedValue.TextXAlignment = Enum.TextXAlignment.Left
    UI.BallStats.PeakSpeedValue.Parent = PeakSpeed

    local Title2 = Instance.new("TextLabel")
    Title2.Name = "Title"
    Title2.Position = UDim2.new(0.5, 0, 0, 10)
    Title2.Size = UDim2.new(1, 0, 0, 10)
    Title2.BackgroundColor3 = Color3.new(1, 1, 1)
    Title2.BackgroundTransparency = 1
    Title2.BorderSizePixel = 0
    Title2.BorderColor3 = Color3.new(0, 0, 0)
    Title2.AnchorPoint = Vector2.new(0.5, 0.5)
    Title2.Text = "PEAK SPEED"
    Title2.TextColor3 = Color3.new(0.588235, 0.588235, 0.588235)
    Title2.TextSize = 14
    Title2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    Title2.TextXAlignment = Enum.TextXAlignment.Left
    Title2.Parent = PeakSpeed

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.Color = Color3.new(0, 0.0980392, 0.133333)
    UIStroke.Transparency = 0.85
    UIStroke.Parent = UI.BallStats.Handler

    MakeDraggable(UI.BallStats.Handler, UI.BallStats.Handler, 0.2)
end

do
    UI.StatsUI.ScreenGui = Instance.new("ScreenGui")
    UI.StatsUI.ScreenGui.Name = "StatsUI"
    UI.StatsUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.StatsUI.ScreenGui.ResetOnSpawn = false
    UI.StatsUI.ScreenGui.IgnoreGuiInset = true
    UI.StatsUI.ScreenGui.Enabled = false
    UI.StatsUI.ScreenGui.Parent = CoreGui

    NeverZen.ProtectGui(UI.StatsUI.ScreenGui)

    UI.StatsUI.Handler = Instance.new("CanvasGroup")
    UI.StatsUI.Handler.Name = "Handler"
    UI.StatsUI.Handler.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.StatsUI.Handler.Size = UDim2.new(0, 327, 0, 45)
    UI.StatsUI.Handler.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.Handler.BackgroundTransparency = 1
    UI.StatsUI.Handler.BorderSizePixel = 0
    UI.StatsUI.Handler.BorderColor3 = Color3.new(0, 0, 0)
    UI.StatsUI.Handler.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.StatsUI.Handler.ClipsDescendants = true
    UI.StatsUI.Handler.Active = true
    UI.StatsUI.Handler.Parent = UI.StatsUI.ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = UI.StatsUI.Handler

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.BackgroundColor3 = Color3.new(0.0470588, 0.0470588, 0.0470588)
    MainFrame.BackgroundTransparency = 0.10000000149011612
    MainFrame.BorderSizePixel = 0
    MainFrame.BorderColor3 = Color3.new(0, 0, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = UI.StatsUI.Handler

    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = "LabelFrame"
    LabelFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LabelFrame.Size = UDim2.new(1, -15, 1, -15)
    LabelFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.BorderSizePixel = 0
    LabelFrame.BorderColor3 = Color3.new(0, 0, 0)
    LabelFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LabelFrame.Parent = MainFrame

    local FPS = Instance.new("Frame")
    FPS.Name = "FPS"
    FPS.Position = UDim2.new(0, 0, 0.5, 0)
    FPS.Size = UDim2.new(0, 78, 1, 0)
    FPS.BackgroundColor3 = Color3.new(1, 1, 1)
    FPS.BackgroundTransparency = 1
    FPS.BorderSizePixel = 0
    FPS.BorderColor3 = Color3.new(0, 0, 0)
    FPS.AnchorPoint = Vector2.new(0, 0.5)
    FPS.Parent = LabelFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Position = UDim2.new(0.5, 0, 0, 0)
    Title.Size = UDim2.new(1, 0, 0, 10)
    Title.BackgroundColor3 = Color3.new(1, 1, 1)
    Title.BackgroundTransparency = 1
    Title.BorderSizePixel = 0
    Title.BorderColor3 = Color3.new(0, 0, 0)
    Title.AnchorPoint = Vector2.new(0.5, 0)
    Title.Text = "FPS"
    Title.TextColor3 = Color3.new(0.588235, 0.588235, 0.588235)
    Title.TextSize = 12
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = FPS

    UI.StatsUI.States.FPS = Instance.new("TextLabel")
    UI.StatsUI.States.FPS.Name = "Value"
    UI.StatsUI.States.FPS.Position = UDim2.new(0.5, 0, 1, 0)
    UI.StatsUI.States.FPS.Size = UDim2.new(1, 0, 0, 20)
    UI.StatsUI.States.FPS.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.FPS.BackgroundTransparency = 1
    UI.StatsUI.States.FPS.BorderSizePixel = 0
    UI.StatsUI.States.FPS.BorderColor3 = Color3.new(0, 0, 0)
    UI.StatsUI.States.FPS.AnchorPoint = Vector2.new(0.5, 1)
    UI.StatsUI.States.FPS.Text = "0"
    UI.StatsUI.States.FPS.TextColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.FPS.TextSize = 17
    UI.StatsUI.States.FPS.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    UI.StatsUI.States.FPS.TextXAlignment = Enum.TextXAlignment.Left
    UI.StatsUI.States.FPS.TextYAlignment = Enum.TextYAlignment.Bottom
    UI.StatsUI.States.FPS.Parent = FPS

    local PING = Instance.new("Frame")
    PING.Name = "PING"
    PING.Position = UDim2.new(0.5, 0, 0.5, 0)
    PING.Size = UDim2.new(0, 78, 1, 0)
    PING.BackgroundColor3 = Color3.new(1, 1, 1)
    PING.BackgroundTransparency = 1
    PING.BorderSizePixel = 0
    PING.BorderColor3 = Color3.new(0, 0, 0)
    PING.AnchorPoint = Vector2.new(0, 0.5)
    PING.Parent = LabelFrame

    local Title2 = Instance.new("TextLabel")
    Title2.Name = "Title"
    Title2.Position = UDim2.new(0.5, 0, 0, 0)
    Title2.Size = UDim2.new(1, 0, 0, 10)
    Title2.BackgroundColor3 = Color3.new(1, 1, 1)
    Title2.BackgroundTransparency = 1
    Title2.BorderSizePixel = 0
    Title2.BorderColor3 = Color3.new(0, 0, 0)
    Title2.AnchorPoint = Vector2.new(0.5, 0)
    Title2.Text = "PING"
    Title2.TextColor3 = Color3.new(0.588235, 0.588235, 0.588235)
    Title2.TextSize = 12
    Title2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    Title2.TextXAlignment = Enum.TextXAlignment.Left
    Title2.Parent = PING

    UI.StatsUI.States.PING = Instance.new("TextLabel")
    UI.StatsUI.States.PING.Name = "Value"
    UI.StatsUI.States.PING.Position = UDim2.new(0.5, 0, 1, 0)
    UI.StatsUI.States.PING.Size = UDim2.new(1, 0, 0, 20)
    UI.StatsUI.States.PING.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.PING.BackgroundTransparency = 1
    UI.StatsUI.States.PING.BorderSizePixel = 0
    UI.StatsUI.States.PING.BorderColor3 = Color3.new(0, 0, 0)
    UI.StatsUI.States.PING.AnchorPoint = Vector2.new(0.5, 1)
    UI.StatsUI.States.PING.Text = "0ms"
    UI.StatsUI.States.PING.TextColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.PING.TextSize = 17
    UI.StatsUI.States.PING.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    UI.StatsUI.States.PING.TextXAlignment = Enum.TextXAlignment.Left
    UI.StatsUI.States.PING.TextYAlignment = Enum.TextYAlignment.Bottom
    UI.StatsUI.States.PING.Parent = PING

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = LabelFrame

    local CPU = Instance.new("Frame")
    CPU.Name = "CPU"
    CPU.Position = UDim2.new(0, 0, 0.5, 0)
    CPU.Size = UDim2.new(0, 78, 1, 0)
    CPU.BackgroundColor3 = Color3.new(1, 1, 1)
    CPU.BackgroundTransparency = 1
    CPU.BorderSizePixel = 0
    CPU.BorderColor3 = Color3.new(0, 0, 0)
    CPU.AnchorPoint = Vector2.new(0, 0.5)
    CPU.Parent = LabelFrame

    local Title3 = Instance.new("TextLabel")
    Title3.Name = "Title"
    Title3.Position = UDim2.new(0.5, 0, 0, 0)
    Title3.Size = UDim2.new(1, 0, 0, 10)
    Title3.BackgroundColor3 = Color3.new(1, 1, 1)
    Title3.BackgroundTransparency = 1
    Title3.BorderSizePixel = 0
    Title3.BorderColor3 = Color3.new(0, 0, 0)
    Title3.AnchorPoint = Vector2.new(0.5, 0)
    Title3.Text = "CPU"
    Title3.TextColor3 = Color3.new(0.588235, 0.588235, 0.588235)
    Title3.TextSize = 12
    Title3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    Title3.TextXAlignment = Enum.TextXAlignment.Left
    Title3.Parent = CPU

    UI.StatsUI.States.CPU = Instance.new("TextLabel")
    UI.StatsUI.States.CPU.Name = "Value"
    UI.StatsUI.States.CPU.Position = UDim2.new(0.5, 0, 1, 0)
    UI.StatsUI.States.CPU.Size = UDim2.new(1, 0, 0, 20)
    UI.StatsUI.States.CPU.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.CPU.BackgroundTransparency = 1
    UI.StatsUI.States.CPU.BorderSizePixel = 0
    UI.StatsUI.States.CPU.BorderColor3 = Color3.new(0, 0, 0)
    UI.StatsUI.States.CPU.AnchorPoint = Vector2.new(0.5, 1)
    UI.StatsUI.States.CPU.Text = "0%"
    UI.StatsUI.States.CPU.TextColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.CPU.TextSize = 17
    UI.StatsUI.States.CPU.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    UI.StatsUI.States.CPU.TextXAlignment = Enum.TextXAlignment.Left
    UI.StatsUI.States.CPU.TextYAlignment = Enum.TextYAlignment.Bottom
    UI.StatsUI.States.CPU.Parent = CPU

    local MEMORY = Instance.new("Frame")
    MEMORY.Name = "MEMORY"
    MEMORY.Position = UDim2.new(0.5, 0, 0.5, 0)
    MEMORY.Size = UDim2.new(0, 78, 1, 0)
    MEMORY.BackgroundColor3 = Color3.new(1, 1, 1)
    MEMORY.BackgroundTransparency = 1
    MEMORY.BorderSizePixel = 0
    MEMORY.BorderColor3 = Color3.new(0, 0, 0)
    MEMORY.AnchorPoint = Vector2.new(0, 0.5)
    MEMORY.Parent = LabelFrame

    local Title4 = Instance.new("TextLabel")
    Title4.Name = "Title"
    Title4.Position = UDim2.new(0.5, 0, 0, 0)
    Title4.Size = UDim2.new(1, 0, 0, 10)
    Title4.BackgroundColor3 = Color3.new(1, 1, 1)
    Title4.BackgroundTransparency = 1
    Title4.BorderSizePixel = 0
    Title4.BorderColor3 = Color3.new(0, 0, 0)
    Title4.AnchorPoint = Vector2.new(0.5, 0)
    Title4.Text = "MEMORY"
    Title4.TextColor3 = Color3.new(0.588235, 0.588235, 0.588235)
    Title4.TextSize = 12
    Title4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    Title4.TextXAlignment = Enum.TextXAlignment.Left
    Title4.Parent = MEMORY

    UI.StatsUI.States.MEMORY = Instance.new("TextLabel")
    UI.StatsUI.States.MEMORY.Name = "Value"
    UI.StatsUI.States.MEMORY.Position = UDim2.new(0.5, 0, 1, 0)
    UI.StatsUI.States.MEMORY.Size = UDim2.new(1, 0, 0, 20)
    UI.StatsUI.States.MEMORY.BackgroundColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.MEMORY.BackgroundTransparency = 1
    UI.StatsUI.States.MEMORY.BorderSizePixel = 0
    UI.StatsUI.States.MEMORY.BorderColor3 = Color3.new(0, 0, 0)
    UI.StatsUI.States.MEMORY.AnchorPoint = Vector2.new(0.5, 1)
    UI.StatsUI.States.MEMORY.Text = "2300mb"
    UI.StatsUI.States.MEMORY.TextColor3 = Color3.new(1, 1, 1)
    UI.StatsUI.States.MEMORY.TextSize = 17
    UI.StatsUI.States.MEMORY.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    UI.StatsUI.States.MEMORY.TextXAlignment = Enum.TextXAlignment.Left
    UI.StatsUI.States.MEMORY.TextYAlignment = Enum.TextYAlignment.Bottom
    UI.StatsUI.States.MEMORY.Parent = MEMORY

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.Color = Color3.new(0, 0.0980392, 0.133333)
    UIStroke.Transparency = 0.85
    UIStroke.Parent = UI.StatsUI.Handler

    MakeDraggable(UI.StatsUI.Handler, UI.StatsUI.Handler, 0.2)
end

NeverZen:Track(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not input.UserInputType == Enum.UserInputType.Keyboard then return end
    if input.KeyCode == EryndorDATA.Config.AutoParry.Keybind then
        EryndorDATA.Config.AutoParry.Enabled = not EryndorDATA.Config.AutoParry.Enabled
        UI.AutoParryToggle:SetValue(EryndorDATA.Config.AutoParry.Enabled)
        SaveAllSettings()
    end
    if input.KeyCode == EryndorDATA.Config.ManualSpamParry.Keybind then
        EryndorDATA.Config.ManualSpamParry.Spamming = not EryndorDATA.Config.ManualSpamParry.Spamming
        UI.ManualSpamParryToggle:SetValue(EryndorDATA.Config.ManualSpamParry.Spamming)
        ManualSpamParryUIService:SetColor(EryndorDATA.Config.ManualSpamParry.Spamming)
        SaveAllSettings()
    end
    if input.KeyCode == EryndorDATA.Config.TriggerBot.Keybind then
        EryndorDATA.Config.TriggerBot.Enabled = not EryndorDATA.Config.TriggerBot.Enabled
        UI.TriggerBotToggle:SetValue(EryndorDATA.Config.TriggerBot.Enabled)
        TriggerBotUIService:SetColor(EryndorDATA.Config.TriggerBot.Enabled)
        SaveAllSettings()
    end
end))

do
    local DesyncTypes = {}

    NeverZen:Track(RunService.Heartbeat:Connect(function()
        if Immortality.Enabled and GetCharacter() and GetCharacter():FindFirstChild("HumanoidRootPart") then
            if Immortality.SpeedBypassEnabled then
                setfflag("S2PhysicsSenderRate", "1333335")
            end
            local hrp = GetCharacter().HumanoidRootPart
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.01, 0)
            DesyncTypes[1] = hrp.CFrame
            DesyncTypes[2] = hrp.AssemblyLinearVelocity

            local currentTime = tick()
            local CalculatedAngle = currentTime * math.pi * 2 * Immortality.Angle / 5
            local CalculatedCycle = math.floor(currentTime * 29) % 2
            local CalculatedYOffset = (CalculatedCycle == 0) and Immortality.Depth or Immortality.Height

            local Calculatedoffset = Vector3.new(
                math.cos(CalculatedAngle) * Immortality.SquareRadius,
                CalculatedYOffset,
                math.sin(CalculatedAngle) * Immortality.SquareRadius
            )

            local TargetCFrame = DesyncTypes[1] + Calculatedoffset

            hrp.CFrame = TargetCFrame
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

            RunService.RenderStepped:Wait()

            hrp.CFrame = DesyncTypes[1]
            hrp.AssemblyLinearVelocity = DesyncTypes[2]
        end
    end))

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if Immortality.Enabled and not checkcaller() then
            if key == "CFrame" and GetCharacter() and GetCharacter():FindFirstChild("HumanoidRootPart") then
                if self == GetCharacter().HumanoidRootPart then
                    return DesyncTypes[1] or CFrame.new()
                elseif self == GetCharacter():FindFirstChild("Head") then
                    return DesyncTypes[1] and DesyncTypes[1] + Vector3.new(0, GetCharacter().HumanoidRootPart.Size / 2 + 0.5, 0) or CFrame.new()
                end
            end
        end
        return oldIndex(self, key)
    end))
end

do
    do
        do
            local OriginalSetSword = EryndorASSETS.SwordController.SetSword
            EryndorASSETS.SwordController.SetSword = function(self, anim)
                if SkinChanger.Enabled and SkinChanger.Targets.SwordAnimation.Enabled and SkinChanger.Targets.SwordAnimation.AnimationName and SkinChanger.Targets.SwordAnimation.AnimationName ~= "" then
                    anim = SkinChanger.Targets.SwordAnimation.AnimationName
                end
                return OriginalSetSword(self, anim)
            end
        end
        do
            local OriginalEquipSwordTo = EryndorASSETS.swordInstances.EquipSwordTo
            SkinChanger.System.OriginalEquipSwordTo = OriginalEquipSwordTo
            EryndorASSETS.swordInstances.EquipSwordTo = function(self, char, swordName)
                if SkinChanger.Enabled and SkinChanger.Targets.SwordModel.Enabled and SkinChanger.Targets.SwordModel.ModelName and SkinChanger.Targets.SwordModel.ModelName ~= "" and char == GetCharacter() then
                    swordName = SkinChanger.Targets.SwordModel.ModelName
                end
                return OriginalEquipSwordTo(self, char, swordName)
            end
        end
    end

    NeverZen:Track(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(...)
        local args = {...}
        if tostring(args[4]) ~= EryndorDATA.Player.LocalPlayer.Name then
            SkinChanger.System.lastOtherParryTimestamp = tick()
        end
    end))
end

do
    NeverZen:Track(ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(_, value)
        EryndorDATA.Config.ParrySettings.Detections.DeathSlashBall.Flag = value
    end))

    NeverZen:Track(ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(_, value)
        EryndorDATA.Config.ParrySettings.Detections.InfinityBall.Flag = value
    end))

    NeverZen:Track(ReplicatedStorage.Remotes.TimeHoleHoldBall.OnClientEvent:Connect(function(_, value)
        EryndorDATA.Config.ParrySettings.Detections.TimeHole.Flag = value
    end))

    NeverZen:Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryActivate"].OnClientEvent:Connect(function(...)
        local args = {...}
        local player = args[1]

        if player == EryndorDATA.Player.LocalPlayer or player == EryndorDATA.Player.LocalPlayer.Name or (player and player.Name == EryndorDATA.Player.LocalPlayer.Name) then
            EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Flag = true
            EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Count = 0
        end
    end))

    NeverZen:Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryEnd"].OnClientEvent:Connect(function()
        EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Flag = false
        EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Count = 0
    end))

    NeverZen:Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryParry"].OnClientEvent:Connect(function()
        EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Count = EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Count + 1
    end))

    local _Det = EryndorDATA.Config.ParrySettings.Detections

    pcall(function()
        NeverZen:Track(ReplicatedStorage.Remotes.Phantom.OnClientEvent:Connect(function(a, b)
            if b and b.Name == EryndorDATA.Player.LocalPlayer.Name and _Det.Phantom then
                _Det.Phantom.Flag = true
                task.delay(2, function()
                    if _Det.Phantom then _Det.Phantom.Flag = false end
                end)
            end
        end))
    end)

    for _, remoteName in ipairs({"PlrPulled", "PlrPulsed"}) do
        pcall(function()
            local rem = ReplicatedStorage.Remotes:FindFirstChild(remoteName)
            if not rem then return end
            NeverZen:Track(rem.OnClientEvent:Connect(function(a, b)
                local flag
                if type(a) == "boolean" then
                    flag = a
                elseif type(b) == "boolean" then
                    flag = b
                else
                    flag = true
                    task.delay(1.5, function()
                        if _Det.Pull then _Det.Pull.Flag = false end
                        if _Det.Pulse then _Det.Pulse.Flag = false end
                    end)
                end
                if _Det.Pull then _Det.Pull.Flag = flag end
                if _Det.Pulse then _Det.Pulse.Flag = flag end
            end))
        end)
    end

    pcall(function()
        local hookConn
        NeverZen:Track(ReplicatedStorage.Remotes.PlrHellHooked.OnClientEvent:Connect(function(a, b)
            if b and b.Name == EryndorDATA.Player.LocalPlayer.Name and _Det.HellHook and _Det.HellHook.Enabled then
                _Det.HellHook.Flag = true
                local char = GetCharacter()
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local pos = char.HumanoidRootPart.CFrame
                if hookConn then hookConn:Disconnect() end
                hookConn = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local c = GetCharacter()
                        if c and c:FindFirstChild("HumanoidRootPart") then
                            c.HumanoidRootPart.CFrame = pos
                        end
                    end)
                end)
            end
        end))
        NeverZen:Track(ReplicatedStorage.Remotes.PlrHellHookCompleted.OnClientEvent:Connect(function()
            if _Det.HellHook then _Det.HellHook.Flag = false end
            if hookConn then
                task.wait(1)
                hookConn:Disconnect()
                hookConn = nil
            end
        end))
    end)

    task.spawn(function()
        local LP = EryndorDATA.Player.LocalPlayer
        local AbilityCD
        pcall(function()
            AbilityCD = LP.PlayerGui.Hotbar.Ability.Duration.Fill.UIGradient
        end)
        if not AbilityCD then return end

        local ABILITY_MAP = {
            ["Forcefield"]      = "Forcefield",
            ["Slashes of Fury"] = "SlashesofFury",
            ["Time Hole"]       = "TimeHole",
            ["Death Slash"]     = "DeathSlashBall",
            ["Infinity"]        = "InfinityBall",
            ["Dribble"]         = "Dribble",
        }
        local GENERIC_ABILITIES = {
            "Raging Deflection", "Rapture", "Calming Deflection",
            "Aerodynamic Slash", "Fracture", "Flash Counter", "Dragon Spirit",
        }

        NeverZen:Track(AbilityCD:GetPropertyChangedSignal("Offset"):Connect(function()
            local char = GetCharacter()
            if not char then
                _Det.AbilityActive.Flag = false
                return
            end
            local abilities = char:FindFirstChild("Abilities")
            if not abilities then
                _Det.AbilityActive.Flag = false
                return
            end

            local anyActive = false
            for abilityName, detKey in pairs(ABILITY_MAP) do
                local ab = abilities:FindFirstChild(abilityName)
                if ab and ab.Enabled and _Det[detKey] and _Det[detKey].Enabled then
                    anyActive = true
                    break
                end
            end
            if not anyActive and _Det.AbilityActive and _Det.AbilityActive.Enabled then
                for _, abilityName in ipairs(GENERIC_ABILITIES) do
                    local ab = abilities:FindFirstChild(abilityName)
                    if ab and ab.Enabled then
                        anyActive = true
                        break
                    end
                end
            end

            if _Det.AbilityActive then
                _Det.AbilityActive.Flag = anyActive
                if AbilityCD.Offset.Y >= 0.985 then
                    _Det.AbilityActive.Flag = false
                end
            end
        end))
    end)

    NeverZen:Track(RunService.PreSimulation:Connect(function()
        pcall(function()
            local LP = EryndorDATA.Player.LocalPlayer
            if _Det.Pulse and _Det.Pulse.Enabled then
                local red = LP.PlayerGui.Hotbar.Ability:FindFirstChild("Red")
                if red then _Det.Pulse.Flag = red.Visible end
            end
            if _Det.Singularity and _Det.Singularity.Enabled then
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                _Det.Singularity.Flag = (hrp and hrp:FindFirstChild("SingularityCape")) and true or false
            end
        end)
    end))

    NeverZen:Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryCatch"].OnClientEvent:Connect(function()
        task.spawn(function()
            while EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Flag and EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Count < EryndorDATA.Config.ParrySettings.SlashesofFuryDetectionMaxParryCount do
                if EryndorDATA.Config.ParrySettings.Detections.SlashesofFury.Enabled then
                    FireParry()
                    task.wait(EryndorDATA.Config.ParrySettings.SlashesofFuryDetectionParryDelay)
                else
                    break
                end
            end
        end)
    end))
end

do
    for _, v in getconnections(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent) do
        if v.Function and debug.getinfo(v.Function).name == "parrySuccessAll" then
            SkinChanger.System.parrySuccessAllConnection = v
            SkinChanger.System.playParryFunc = v.Function
            print("[BloodWork]:[DEBUG] Found parrySuccessAll connection (left enabled)")
            break
        end
    end

    for i,v in getconnections(ReplicatedStorage.Remotes.ParrySuccessClient.Event) do
        if v.Function and debug.getinfo(v.Function).name == "parrySuccessAll" then
            SkinChanger.System.parrySuccessClientConnection = v
            print("[BloodWork]:[DEBUG] Found parrySuccessClient connection (left enabled)")
        end
    end
end

NeverZen:Track(ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if EryndorDATA.Config.Animation.SpamAnimationParries < 5 then
        EryndorDATA.Config.Animation.SpamAnimationParries += 1
        task.delay(0.05, function()
            if EryndorDATA.Config.Animation.SpamAnimationParries > 0 then
                EryndorDATA.Config.Animation.SpamAnimationParries -= 1
            end
        end)
    end

    if EryndorDATA.Config.ParrySettings.VisualiserParries < 10 then
        EryndorDATA.Config.ParrySettings.VisualiserParries += 1
        task.delay(0.25, function()
            if EryndorDATA.Config.ParrySettings.VisualiserParries > 0 then
                EryndorDATA.Config.ParrySettings.VisualiserParries -= 1
            end
        end)
    end

    SpamAnimationFixBypass = true
    local humanoid = GetHumanoid()
    if humanoid and EryndorDATA.Config.ParrySettings.ParryMethod ~= "Legit" then
        for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
            if track.Name == "GrabParry" or track.Name == "Grab" then
                if not EryndorDATA.Config.Animation.AnimationSpammingMode and not AnimationFixService.FEMode then
                    track.TimePosition = 0
                end
                StopAnimation(track)
            end
        end
    end

    if Visuals.HitEffectEnabled then
        for _, Ball in pairs(Get_Balls()) do
            Visuals.HitEffectService:Emit(Ball, Ball.Position)
        end
    end
end))

local LastIteration = 0
local FrameUpdateTable = {}
local FpsStart = os.clock()

local function RefreshVM(deltaTime)
    EryndorDATA.Config.Animation.AnimationSpammingMode = EryndorDATA.Config.Animation.SpamAnimationParries > 1

    if Visuals.VisualisersEnabled then
        if GetCharacter() and GetCharacter():FindFirstChild("HumanoidRootPart") then
            local char = GetCharacter()
            local hrp = char.HumanoidRootPart
            local isclashing = EryndorDATA.Config.AutoSpamParry.Spamming or EryndorDATA.Config.ManualSpamParry.Spamming
            local color = isclashing and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
            local size = (isclashing and 40 + EryndorDATA.Config.ParrySettings.VisualiserParries or math.clamp(EryndorDATA.Global.AutoParryCurrentAccuracy, 10, 220))
            Visuals.VisualiserService:SetColor(color)
            Visuals.VisualiserService:Update(char, hrp.Position, size)
        end
    end

    if EryndorDATA.Config.BallStats.Enabled then
        local BallsList = Get_Balls()
        local BallSpeed = 0
        for _, Ball in pairs(BallsList) do
            if Ball then
                local CacheSpeed = Ball.AssemblyLinearVelocity.Magnitude
                BallSpeed = CacheSpeed
                if CacheSpeed > UI.BallStats.PeakSpeed then
                    UI.BallStats.PeakSpeed = CacheSpeed
                end
                break
            end
        end
        UI.BallStats.SpeedValue.Text = tostring(math.floor(BallSpeed))
        UI.BallStats.PeakSpeedValue.Text = tostring(math.floor(UI.BallStats.PeakSpeed))
    end

    if EryndorDATA.Config.ClientStats.Enabled then
        local Fps = 0
        local Ping = 0
        local Cpu = 0
        local Memory = 0

        do
            LastIteration = os.clock()
            for Index = #FrameUpdateTable, 1, -1 do
                FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
            end

            FrameUpdateTable[1] = LastIteration
            Fps = (math.floor(os.clock() - FpsStart >= 1 and #FrameUpdateTable or #FrameUpdateTable / (os.clock() - FpsStart)))
        end

        Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        Memory = Stats:GetTotalMemoryUsageMb()
        Cpu = math.clamp(Memory / 50, 1, 100)

        UI.StatsUI.States.FPS.Text = tostring(math.floor(Fps))
        UI.StatsUI.States.PING.Text = string.format("%sms", tostring(math.floor(Ping)))
        UI.StatsUI.States.CPU.Text = tostring(math.floor(Cpu)).. "%"
        UI.StatsUI.States.MEMORY.Text = string.format("%smb", tostring(math.floor(Memory)))
    end
end

local RequestSpamParry = function()
    do
        Debug.Spamming.RepeatedAmount += 1
        if tick() - Debug.Spamming.LastRepeat > 1 then
            Debug.Spamming.LastRepeat = tick()
            Debug.Spamming.Speed = Debug.Spamming.RepeatedAmount
            UI.SpamLoopRPSLabel:SetValue(string.format("Loop RPS: %d", Debug.Spamming.Speed))
            Debug.Spamming.RepeatedAmount = 0
        end
    end
    if EryndorDATA.Config.AutoSpamParry.Spamming or EryndorDATA.Config.ManualSpamParry.Spamming then
        FireParry()
        if (EryndorDATA.Config.AutoSpamParry.AnimationFix and EryndorDATA.Config.AutoSpamParry.Spamming) or (EryndorDATA.Config.ManualSpamParry.AnimationFix and EryndorDATA.Config.ManualSpamParry.Spamming) and EryndorDATA.Config.ParrySettings.ParryMethod ~= "Legit" then
            SpamParry_Animation()
        end
    end
end

local function LoopConnection(deltaTime)
    local ok, err = pcall(MainConnection)
    if not ok then
        warn("[BloodWork] MainConnection error:", err)
    end
    RefreshVM(deltaTime)
end

do
    local timeAccumulator = 0

    local function FireParryWithAnim()
        FireParry()
        if EryndorDATA.Config.ManualSpamParry.AnimationFix and EryndorDATA.Config.ParrySettings.ParryMethod ~= "Legit" then
            SpamParry_Animation()
        end
    end

    task.spawn(function()
        while true do
            if EryndorDATA.Config.AutoSpamParry.Spamming then
                local targetRPS = EryndorDATA.Config.ParrySettings.SpammingRPS
                local interval = 1 / math.min(targetRPS, 1000)
                RequestSpamParry()
                task.wait(interval)

            elseif EryndorDATA.Config.ManualSpamParry.Spamming then
                if EryndorDATA.Config.ManualSpamParry.SuperSpam then
                    local clicks = math.max(1, math.floor(EryndorDATA.Config.ManualSpamParry.SuperSpamClicks or 1))
                    for i = 1, clicks do
                        task.spawn(function()
                            FireParryWithAnim()
                            Debug.Spamming.RepeatedAmount += 1
                        end)
                    end
                    task.wait(0.01)
                else
                    local targetRPS = EryndorDATA.Config.ParrySettings.SpammingRPS
                    local interval = 1 / math.min(targetRPS, 1000)
                    RequestSpamParry()
                    task.wait(interval)
                end
            else
                task.wait(0.1)
            end
        end
    end)

    NeverZen:Track(RunService.RenderStepped:Connect(function(deltaTime)
        local TargetSpeed = EryndorDATA.Config.ParrySettings.SpammingRPS
        timeAccumulator += deltaTime
        UI.SpamAccumulatorLabel:SetValue(string.format("Accumulator: %.3f", timeAccumulator))
        if not EryndorDATA.Config.AutoSpamParry.Spamming and not EryndorDATA.Config.ManualSpamParry.Spamming then
            timeAccumulator = 0
        end
    end))

    ResetAccumulator = function()
        timeAccumulator = 0
    end
end

ApplyLoadedState = function()
    pcall(function()
        ManualSpamParryUIService:Visible(EryndorDATA.Config.ManualSpamParry.UI)
        TriggerBotUIService:Visible(EryndorDATA.Config.TriggerBot.UI)
        ImmortalityUIService:Visible(Immortality.UI)
        BallStatsUIService:Visible(EryndorDATA.Config.BallStats.Enabled)
        StatsUIService:Visible(EryndorDATA.Config.ClientStats.Enabled)
    end)

    pcall(function()
        ManualSpamParryUIService:SetColor(EryndorDATA.Config.ManualSpamParry.Spamming)
        TriggerBotUIService:SetColor(EryndorDATA.Config.TriggerBot.Enabled)
        ImmortalityUIService:SetColor(Immortality.Enabled)
    end)

    pcall(function()
        if UI.AutoParryToggle and UI.AutoParryToggle.SetValue then
            UI.AutoParryToggle:SetValue(EryndorDATA.Config.AutoParry.Enabled)
        end
        if UI.ManualSpamParryToggle and UI.ManualSpamParryToggle.SetValue then
            UI.ManualSpamParryToggle:SetValue(EryndorDATA.Config.ManualSpamParry.Spamming)
        end
        if UI.TriggerBotToggle and UI.TriggerBotToggle.SetValue then
            UI.TriggerBotToggle:SetValue(EryndorDATA.Config.TriggerBot.Enabled)
        end
        if UI.ImmortalityToggle and UI.ImmortalityToggle.SetValue then
            UI.ImmortalityToggle:SetValue(Immortality.Enabled)
        end
    end)
end

ApplyLoadedState()

NeverZen:Track(RunService.Heartbeat:Connect(LoopConnection))

ClearCache = function()
    AnimationFixService.Cache = {}
    NZNotification.new('BloodWork :[', 'Cleared internal caches.', 5)
end

UnloadEryndor = function()
    SaveAllSettings()
    NeverZen:Unload()
    local EryndorConfig = EryndorDATA.Config
    EryndorConfig.AutoParry.Enabled = false
    EryndorConfig.ManualSpamParry.Spamming = false
    EryndorConfig.TriggerBot.Enabled = false
    EryndorConfig.AutoSpamParry.Enabled = false
    Immortality.Enabled = false
    Visuals.VisualiserService:ClearAll()
    SkinChanger.Enabled = false
    if SkinChanger.System.parrySuccessAllConnection then
        pcall(function() SkinChanger.System.parrySuccessAllConnection:Enable() end)
    end
    if SkinChanger.System.parrySuccessClientConnection then
        pcall(function() SkinChanger.System.parrySuccessClientConnection:Enable() end)
    end
    UI.StatsUI.ScreenGui:Destroy()
    UI.BallStats.ScreenGui:Destroy()
    UI.SpamUI.ScreenGui:Destroy()
    UI.TriggerBotUI.ScreenGui:Destroy()
    UI.ImmortalityUI.ScreenGui:Destroy()

    NeverZen:Unload()
end

NeverZen:Track(EryndorDATA.Player.LocalPlayer.CharacterAdded:Connect(function()
    Visuals.VisualiserService:ClearAll()
    task.delay(1.5, function()
        if SkinChanger.Targets.SwordModel.Enabled and SkinChanger.Targets.SwordModel.ModelName and SkinChanger.Targets.SwordModel.ModelName ~= "" then
            SkinChanger.System.functions.setSword()
        end
    end)
end))

local loaded = EryndorDATA.Global.SettingsPreloaded

EryndorDATA.Config.ManualSpamParry.Spamming = false
EryndorDATA.Config.AutoSpamParry.Spamming = false
EryndorDATA.Global.AutoParryParried = false

for _, BallData in pairs(EryndorDATA.Parry) do
    if type(BallData) == "table" then
        BallData.LobbyParried = false
    end
end

ApplyLoadedState()

if loaded then
    NZNotification.new('BloodWork :[', 'Settings loaded successfully.', 3)
else
    NZNotification.new('BloodWork :[', 'No saved settings found, using defaults.', 3)
end

NZNotification.new('BloodWork :[', 'Loaded.', 10)