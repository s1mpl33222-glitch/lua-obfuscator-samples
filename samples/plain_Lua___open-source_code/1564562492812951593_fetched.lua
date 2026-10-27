local Library = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function GenerateSafeName(prefix)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local res = {}
    for i = 1, 8 do
        local r = math.random(1, #chars)
        table.insert(res, chars:sub(r, r))
    end
    local id = table.concat(res)
    return prefix and (tostring(prefix) .. "_" .. id) or id
end
Library.GenerateSafeName = GenerateSafeName

local function GetSafeParentGui()
    local success, hui = pcall(function()
        if gethui then return gethui() end
        if get_hidden_gui then return get_hidden_gui() end
    end)
    if success and hui then return hui end

    if syn and syn.protect_gui then
        local protectedFolder = nil
        pcall(function()
            protectedFolder = Instance.new("Folder")
            syn.protect_gui(protectedFolder)
            local cg = (cloneref and cloneref(CoreGui)) or CoreGui
            protectedFolder.Parent = cg
        end)
        if protectedFolder then return protectedFolder end
    elseif protectgui then
        local protectedFolder = nil
        pcall(function()
            protectedFolder = Instance.new("Folder")
            protectgui(protectedFolder)
            local cg = (cloneref and cloneref(CoreGui)) or CoreGui
            protectedFolder.Parent = cg
        end)
        if protectedFolder then return protectedFolder end
    end

    local cgSuccess, cg = pcall(function()
        return (cloneref and cloneref(CoreGui)) or CoreGui
    end)
    if cgSuccess and cg then
        local testOk = pcall(function()
            local t = Instance.new("Folder")
            t.Parent = cg
            t:Destroy()
        end)
        if testOk then return cg end
    end

    if LocalPlayer then
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:FindFirstChild("PlayerGui")
        if pg then return pg end
    end

    return CoreGui
end

local ParentGui = GetSafeParentGui()

local function ProtectGui(gui)
    if not gui then return end
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        elseif protectgui then
            protectgui(gui)
        end
    end)
end
local function ResolveParent(parent)
    if typeof(parent) == "Instance" then
        return parent
    end
    if type(parent) == "table" then
        local rawTarget = rawget(parent, "Frame") or rawget(parent, "Instance") or rawget(parent, "Container") or rawget(parent, "ContentFrame")
        if rawTarget and typeof(rawTarget) == "Instance" then
            return rawTarget
        end
        local function safeField(t, k)
            local ok, res = pcall(function() return t[k] end)
            return ok and res or nil
        end
        local f = safeField(parent, "Frame")
        if f and typeof(f) == "Instance" then return f end
        local c = safeField(parent, "Container")
        if c and typeof(c) == "Instance" then return c end
        local inst = safeField(parent, "Instance")
        if inst and typeof(inst) == "Instance" then return inst end
        local cf = safeField(parent, "ContentFrame")
        if cf and typeof(cf) == "Instance" then return cf end
    end
    return nil
end

local function IsInsideSection(instance)
    local resolved = ResolveParent(instance) or instance
    if typeof(resolved) ~= "Instance" then return false end
    local cur = resolved
    while cur do
        if cur:IsA("Frame") and cur.Name and cur.Name:find("SectionCard") then
            return true
        end
        cur = cur.Parent
    end
    return false
end
Library.IsInsideSection = IsInsideSection

Library.ActiveGuis = Library.ActiveGuis or {}

local _MontserratFamily = Font.fromEnum(Enum.Font.Montserrat).Family

local FontBold     = Font.new(_MontserratFamily, Enum.FontWeight.Bold,     Enum.FontStyle.Normal)
local FontSemiBold = Font.new(_MontserratFamily, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local FontMedium   = Font.new(_MontserratFamily, Enum.FontWeight.Medium,   Enum.FontStyle.Normal)
local FontRegular  = Font.new(_MontserratFamily, Enum.FontWeight.Regular,  Enum.FontStyle.Normal)
local FontLight    = Font.new(_MontserratFamily, Enum.FontWeight.Light,    Enum.FontStyle.Normal)

local FontTitle   = FontMedium
local FontTabBtn  = FontSemiBold
local FontFingerPaintBold = FontMedium
local FontFingerPaintRegular = FontRegular
local FontFingerPaintHeavy = FontMedium
local FontFingerPaintMedium = FontMedium

Library.FontBold = FontBold
Library.FontTitle = FontTitle
Library.FontTabBtn = FontTabBtn
Library.FontMedium = FontMedium
Library.FontRegular = FontRegular
Library.FontLight = FontLight

local FontSilkscreenRegular = Font.new("rbxassetid://12187371840", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FontSilkscreenBold = Font.new("rbxassetid://12187371840", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local FontScriptNameDefault = FontSemiBold
Library.ScriptNameFont = FontScriptNameDefault

local IconsRest = {
    ["a-arrow-down"] = "87834851353233", ["a-arrow-up"] = "89385437396694", ["a-large-small"] = "73183249747960", ["accessibility"] = "109960743825561",
    ["activity"] = "137527339160230", ["activity-square"] = "126953951117387", ["air-vent"] = "111625153433818", ["airplay"] = "92171397431531",
    ["alarm-check"] = "130501077167542", ["alarm-clock"] = "118636480109240", ["alarm-clock-check"] = "70976944787280", ["alarm-clock-minus"] = "70856300954858",
    ["alarm-clock-off"] = "110132709107464", ["alarm-clock-plus"] = "96736786697131", ["alarm-minus"] = "77271404005062", ["alarm-plus"] = "128528043300240",
    ["alarm-smoke"] = "76581519928624", ["album"] = "112445622428637", ["alert-circle"] = "74115333842618", ["alert-octagon"] = "138910404523272",
    ["alert-triangle"] = "112102474509324", ["align-center"] = "120408521883501", ["align-center-horizontal"] = "108597166812858", ["align-center-vertical"] = "121154206034694",
    ["align-end-horizontal"] = "99069601868832", ["align-end-vertical"] = "117942349521535", ["align-horizontal-distribute-center"] = "77482483036009", ["align-horizontal-distribute-end"] = "134639979863642",
    ["align-horizontal-distribute-start"] = "134435692726811", ["align-horizontal-justify-center"] = "92390581039957", ["align-horizontal-justify-end"] = "104340168067575", ["align-horizontal-justify-start"] = "78939447794797",
    ["align-horizontal-space-around"] = "80515421591545", ["align-horizontal-space-between"] = "114038806348167", ["align-justify"] = "92373371786861", ["align-left"] = "136554315335959",
    ["align-right"] = "135067010612236", ["align-start-horizontal"] = "96834758740744", ["align-start-vertical"] = "123458513293976", ["align-vertical-distribute-center"] = "90818078154247",
    ["align-vertical-distribute-end"] = "136782098795781", ["align-vertical-distribute-start"] = "134480830300767", ["align-vertical-justify-center"] = "130298876730417", ["align-vertical-justify-end"] = "100777246465864",
    ["align-vertical-justify-start"] = "123693071723398", ["align-vertical-space-around"] = "124225977511288", ["align-vertical-space-between"] = "81499787439793", ["ambulance"] = "103392162911629",
    ["ampersand"] = "76900943277226", ["ampersands"] = "86469233094518", ["anchor"] = "127378493192461", ["angry"] = "79345553086407",
    ["annoyed"] = "104846682265434", ["antenna"] = "112766612909532", ["anvil"] = "86432599455606", ["aperture"] = "139684165362622",
    ["app-window"] = "87635787215081", ["app-window-mac"] = "108549782746996", ["apple"] = "93203750625654", ["archive"] = "137249944163344",
    ["archive-restore"] = "96820254661076", ["archive-x"] = "134784309661522", ["area-chart"] = "107486186614989", ["armchair"] = "104852764227195",
    ["arrow-big-down"] = "134387593103194", ["arrow-big-down-dash"] = "125189777214718", ["arrow-big-left"] = "79012356613282", ["arrow-big-left-dash"] = "132879301629314",
    ["arrow-big-right"] = "90405262165720", ["arrow-big-right-dash"] = "121488142481379", ["arrow-big-up"] = "95689861013321", ["arrow-big-up-dash"] = "106976910180035",
    ["arrow-down"] = "134161790366779", ["arrow-down-0-1"] = "140381370510884", ["arrow-down-1-0"] = "130494621181478", ["arrow-down-a-z"] = "103554859233661",
    ["arrow-down-circle"] = "131404694292521", ["arrow-down-from-line"] = "81443516391691", ["arrow-down-left"] = "102509297349411", ["arrow-down-left-from-circle"] = "73012719459961",
    ["arrow-down-left-square"] = "90976696713068", ["arrow-down-narrow-wide"] = "71046418862578", ["arrow-down-right"] = "72764732196403", ["arrow-down-right-from-circle"] = "97668995487103",
    ["arrow-down-right-square"] = "128499661363473", ["arrow-down-square"] = "138838216140198", ["arrow-down-to-dot"] = "88868273845458", ["arrow-down-to-line"] = "137644743820952",
    ["arrow-down-up"] = "117405374619280", ["arrow-down-wide-narrow"] = "75826372885867", ["arrow-down-z-a"] = "118359795316087", ["arrow-left"] = "90293255250749",
    ["arrow-left-circle"] = "130847257582775", ["arrow-left-from-line"] = "77381869318221", ["arrow-left-right"] = "112517617090898", ["arrow-left-square"] = "135104418905606",
    ["arrow-left-to-line"] = "130252021035812", ["arrow-right"] = "134908902120212", ["arrow-right-circle"] = "94365145580321", ["arrow-right-from-line"] = "107378199607331",
    ["arrow-right-left"] = "111890422557630", ["arrow-right-square"] = "115337431423227", ["arrow-right-to-line"] = "103829994761864", ["arrow-up"] = "104406213770080",
    ["arrow-up-0-1"] = "139178256421912", ["arrow-up-1-0"] = "97298977768167", ["arrow-up-a-z"] = "97443044644659", ["arrow-up-circle"] = "75833692771331",
    ["arrow-up-down"] = "73746166761985", ["arrow-up-from-dot"] = "103317134268223", ["arrow-up-from-line"] = "101711387260955", ["arrow-up-left"] = "103783370700580",
    ["arrow-up-left-from-circle"] = "96382098119619", ["arrow-up-left-square"] = "101543880954604", ["arrow-up-narrow-wide"] = "122289869517959", ["arrow-up-right"] = "115214649052675",
    ["arrow-up-right-from-circle"] = "102906718956851", ["arrow-up-right-square"] = "113196521639031", ["arrow-up-square"] = "112280252781879", ["arrow-up-to-line"] = "135365442561417",
    ["arrow-up-wide-narrow"] = "79052928363256", ["arrow-up-z-a"] = "93443333447390", ["arrows-up-from-line"] = "140178313470659", ["asterisk"] = "107247711733329",
    ["at-sign"] = "94614469252449", ["atom"] = "119051552929078", ["audio-lines"] = "133487746892141", ["audio-waveform"] = "135412900878575",
    ["award"] = "82039875682356", ["axe"] = "84931585672806", ["axis-3d"] = "83328523632480", ["baby"] = "75683742350958",
    ["backpack"] = "76143965140765", ["badge"] = "78791133479661", ["badge-alert"] = "92904571921902", ["badge-cent"] = "110902979965426",
    ["badge-check"] = "76305757263548", ["badge-dollar-sign"] = "123225256208806", ["badge-euro"] = "82107326159074", ["badge-help"] = "83944903318576",
    ["badge-indian-rupee"] = "105958255216505", ["badge-info"] = "109792483526167", ["badge-japanese-yen"] = "96156476341857", ["badge-minus"] = "79191240000290",
    ["badge-percent"] = "129993801535784", ["badge-plus"] = "73308743105191", ["badge-pound-sterling"] = "104904198937382", ["badge-russian-ruble"] = "91738909980749",
    ["badge-swiss-franc"] = "102826901242684", ["badge-x"] = "117187082865205", ["baggage-claim"] = "119346910227968", ["ban"] = "109685306480139",
    ["banana"] = "128374499714074", ["banknote"] = "113703117675594", ["bar-chart"] = "121570259716677", ["bar-chart-2"] = "121452498735866",
    ["bar-chart-3"] = "130626786024244", ["bar-chart-4"] = "96221317327213", ["bar-chart-big"] = "119295298711810", ["bar-chart-horizontal"] = "109235174327898",
    ["bar-chart-horizontal-big"] = "139737497124066", ["barcode"] = "78580529416152", ["baseline"] = "116347038683714", ["bath"] = "89008182357290",
    ["battery"] = "102599812606554", ["battery-charging"] = "91402957855599", ["battery-full"] = "108407180588179", ["battery-low"] = "132416805088817",
    ["battery-medium"] = "139407584675024", ["battery-warning"] = "119084304752903", ["beaker"] = "100026072450383", ["bean"] = "108654318985558",
    ["bean-off"] = "75755103997845", ["bed"] = "71982795501399", ["bed-double"] = "97693190540435", ["bed-single"] = "80557330573152",
    ["beef"] = "93001452038647", ["beer"] = "71718925718592", ["beer-off"] = "135309228180602", ["bell"] = "84691420588185",
    ["bell-dot"] = "100564215426004", ["bell-electric"] = "120584905231603", ["bell-minus"] = "117849268875449", ["bell-off"] = "115540031372596",
    ["bell-plus"] = "85655293455454", ["bell-ring"] = "71006419366158", ["between-horizontal-end"] = "97454674221809", ["between-horizontal-start"] = "122308710081740",
    ["between-vertical-end"] = "73288142609772", ["between-vertical-start"] = "96319480553759", ["bike"] = "139392597724277", ["binary"] = "73887562333653",
    ["biohazard"] = "137351193301090", ["bird"] = "78301366757596", ["bitcoin"] = "87905951788220", ["blend"] = "99774242136996",
    ["blinds"] = "97128563480198", ["blocks"] = "116361302503360", ["bluetooth"] = "140648462080543", ["bluetooth-connected"] = "108047104997672",
    ["bluetooth-off"] = "85384277884353", ["bluetooth-searching"] = "88887842293685", ["bold"] = "114571598098097", ["bolt"] = "134172358414310",
    ["bomb"] = "85112456002145", ["bone"] = "110911138031483", ["book"] = "74111869099427", ["book-a"] = "130683776374615",
    ["book-audio"] = "84765914852101", ["book-check"] = "116693733550590", ["book-copy"] = "103556293898971", ["book-dashed"] = "90144560974060",
    ["book-down"] = "102612840928328", ["book-headphones"] = "101847018803943", ["book-heart"] = "79225550955168", ["book-image"] = "97175021450327",
    ["book-key"] = "78825638323167", ["book-lock"] = "136914298397858", ["book-marked"] = "130311722822005", ["book-minus"] = "111140800790677",
    ["book-open"] = "84762150530577", ["book-open-check"] = "100175521109916", ["book-open-text"] = "83251408532985", ["book-plus"] = "135397977794739",
    ["book-text"] = "96481772943887", ["book-type"] = "80135728169729", ["book-up"] = "92592832226795", ["book-up-2"] = "74123009075829",
    ["book-user"] = "80586093636888", ["book-x"] = "75485266769989", ["bookmark"] = "137439152875860", ["bookmark-check"] = "103743627936816",
    ["bookmark-minus"] = "106761186502279", ["bookmark-plus"] = "108572239011289", ["bookmark-x"] = "115354177404954", ["boom-box"] = "88874304172044",
    ["bot"] = "70979486241131", ["bot-message-square"] = "79709292282995", ["box"] = "117371753006597", ["box-select"] = "106969329058115",
    ["boxes"] = "95055252135506", ["braces"] = "92263187057993", ["brackets"] = "87406077670628", ["brain"] = "116902501990569",
    ["brain-circuit"] = "130830898675113", ["brain-cog"] = "76347059769903", ["brick-wall"] = "94677898150825", ["briefcase"] = "78701740878808",
    ["briefcase-business"] = "83989706459460", ["briefcase-medical"] = "101696204417639", ["bring-to-front"] = "105016868447258", ["brush"] = "113475652218451",
    ["bug"] = "75649814233484", ["bug-off"] = "72963988065933", ["bug-play"] = "109066688101101", ["building"] = "128630485814878",
    ["building-2"] = "97744948701888", ["bus"] = "115040051931434", ["bus-front"] = "89834398235413", ["cable"] = "122718774070506",
    ["cable-car"] = "75378206085314", ["cake"] = "88535465840262", ["cake-slice"] = "99501344714989", ["calculator"] = "107281102048400",
    ["calendar"] = "126460151885084", ["calendar-check"] = "116665691227418", ["calendar-check-2"] = "128139765113287", ["calendar-clock"] = "91678408267921",
    ["calendar-days"] = "83005303274935", ["calendar-fold"] = "120622111767156", ["calendar-heart"] = "101728896191412", ["calendar-minus"] = "97111317408323",
    ["calendar-minus-2"] = "114139960753026", ["calendar-off"] = "72690038281381", ["calendar-plus"] = "113126930241503", ["calendar-plus-2"] = "95708816339251",
    ["calendar-range"] = "85814519406070", ["calendar-search"] = "94105486063910", ["calendar-x"] = "117555084312063", ["calendar-x-2"] = "137455674513711",
    ["camera"] = "114084146151777", ["camera-off"] = "101456706369049", ["candlestick-chart"] = "99842864833044", ["candy"] = "113164012451432",
    ["candy-cane"] = "125416183674924", ["candy-off"] = "122702931937344", ["captions"] = "105023593632540", ["captions-off"] = "75480095441780",
    ["car"] = "91451724283877", ["car-front"] = "79993076477613", ["car-taxi-front"] = "75623233937291", ["caravan"] = "78521421981947",
    ["carrot"] = "71122235024925", ["case-lower"] = "95359311197985", ["case-sensitive"] = "133603526051277", ["case-upper"] = "77340278207531",
    ["cassette-tape"] = "113140472253110", ["cast"] = "119573692041871", ["castle"] = "104598700669384", ["cat"] = "118339348494810",
    ["cctv"] = "84978679477516", ["check"] = "86817768619372", ["check-check"] = "101885204738917", ["check-circle"] = "105979545056636",
    ["check-circle-2"] = "76928915955542", ["check-square"] = "135686334400788", ["check-square-2"] = "84113739446686", ["chef-hat"] = "94153362248387",
    ["cherry"] = "116326418543667", ["chevron-down"] = "71457658246709", ["chevron-down-circle"] = "130642617728982", ["chevron-down-square"] = "84683053234548",
    ["chevron-first"] = "70831710633364", ["chevron-last"] = "102556054621077", ["chevron-left"] = "102314312897830", ["chevron-left-circle"] = "70732746220332",
    ["chevron-left-square"] = "78492542000164", ["chevron-right"] = "101007429951147", ["chevron-right-circle"] = "87038574131735", ["chevron-right-square"] = "119136642030742",
    ["chevron-up"] = "98648581502859", ["chevron-up-circle"] = "111681831848531", ["chevrons-down"] = "84492998086101", ["chevrons-down-up"] = "82103880591342",
    ["chevrons-left"] = "87881912126351", ["chevrons-left-right"] = "132331219761704", ["chevrons-right"] = "134353805354361", ["chevrons-right-left"] = "96783734429291",
    ["chevrons-up"] = "88461690106632", ["chevrons-up-down"] = "71880540200693", ["circle-arrow-down"] = "129076838165145", ["circle-arrow-left"] = "88796613571531",
    ["circle-arrow-out-down-left"] = "107231337431973", ["circle-arrow-out-down-right"] = "70490689174861", ["circle-arrow-out-up-left"] = "79479678307645", ["circle-arrow-out-up-right"] = "127093834620465",
    ["circle-arrow-right"] = "97664127355280", ["circle-arrow-up"] = "72634350793509", ["circle-check"] = "88244323237265", ["circle-check-big"] = "105847305799404",
    ["circle-chevron-down"] = "88531529614731", ["circle-chevron-left"] = "109806050128867", ["circle-chevron-right"] = "130159833971034", ["circle-chevron-up"] = "126990996679640",
    ["circle-dashed"] = "122032109800866", ["circle-divide"] = "136980096833105", ["circle-dollar-sign"] = "102720278203768", ["circle-dot"] = "122878673716704",
    ["circle-dot-dashed"] = "107222591318022", ["circle-ellipsis"] = "72989868902667", ["circle-equal"] = "83415595687523", ["circle-fading-plus"] = "97734885169321",
    ["circle-gauge"] = "79712667314679", ["circle-help"] = "132353516577418", ["circle-minus"] = "98163850412523", ["circle-off"] = "95467094528299",
    ["circle-parking"] = "117482323268433", ["circle-parking-off"] = "80459013698184", ["circle-pause"] = "88794740338426", ["circle-percent"] = "125429815212970",
    ["circle-play"] = "84481789029543", ["circle-plus"] = "117262167984222", ["circle-power"] = "127349877206105", ["circle-slash"] = "98431785453122",
    ["circle-slash-2"] = "79541029224240", ["circle-stop"] = "109423106908446", ["circle-user"] = "87167719100614", ["circle-user-round"] = "113831490904568",
    ["circle-x"] = "106305483906363", ["circuit-board"] = "124136951218642", ["citrus"] = "79624448772527", ["clapperboard"] = "132343838416956",
    ["clipboard"] = "105021692319787", ["clipboard-check"] = "90432969741774", ["clipboard-copy"] = "85387882337161", ["clipboard-edit"] = "131193135046966",
    ["clipboard-list"] = "129402512748462", ["clipboard-minus"] = "94779294031183", ["clipboard-paste"] = "79192963603923", ["clipboard-pen"] = "99195778697194",
    ["clipboard-pen-line"] = "103555830963651", ["clipboard-plus"] = "74352366953056", ["clipboard-signature"] = "120750772696869", ["clipboard-type"] = "132835545998943",
    ["clipboard-x"] = "132658738057667", ["clock"] = "136533241128438", ["clock-1"] = "71498600757409", ["clock-10"] = "123641121766955",
    ["clock-11"] = "85845500811663", ["clock-12"] = "133878455420257", ["clock-2"] = "102975079908275", ["clock-3"] = "119663119982527",
    ["clock-4"] = "108792000100666", ["clock-5"] = "97840714155038", ["clock-6"] = "102025123837297", ["clock-7"] = "110824271252901",
    ["clock-8"] = "123515589399454", ["clock-9"] = "126662391246112", ["cloud"] = "136524873450824", ["cloud-cog"] = "108438517119798",
    ["cloud-download"] = "78768373704516", ["cloud-drizzle"] = "80789072164434", ["cloud-fog"] = "110403642693501", ["cloud-hail"] = "95998880244047",
    ["cloud-lightning"] = "118391347029403", ["cloud-moon"] = "120156057895579", ["cloud-moon-rain"] = "101513348432910", ["cloud-off"] = "111796785870393",
    ["cloud-rain"] = "130177212410873", ["cloud-rain-wind"] = "87893934921731", ["cloud-snow"] = "104971371973617", ["cloud-sun"] = "140109651313859",
    ["cloud-sun-rain"] = "132138781511885", ["cloud-upload"] = "86452290950086", ["cloudy"] = "132267475821363", ["clover"] = "128291338532394",
    ["club"] = "83110975306436", ["code"] = "75851496262862", ["code-2"] = "79541605299928", ["code-xml"] = "106124864132557",
    ["codepen"] = "131077252082543", ["codesandbox"] = "139298967633423", ["coffee"] = "125329933348791", ["cog"] = "123222732420633",
    ["coins"] = "117341212186115", ["columns"] = "96838631255058", ["columns-2"] = "110924811097991", ["columns-3"] = "88214025452433",
    ["columns-4"] = "100379574150921", ["combine"] = "103133480717944", ["command"] = "90385430770591", ["compass"] = "73836660434977",
    ["component"] = "106556990975641", ["computer"] = "72888027377165", ["concierge-bell"] = "134373387272639", ["cone"] = "80255197365555",
    ["construction"] = "77845797691565", ["contact"] = "102372888309353", ["contact-2"] = "100454539997812", ["contact-round"] = "117599766367773",
    ["container"] = "135116917100753", ["contrast"] = "71154426791470", ["cookie"] = "96083862569395", ["cooking-pot"] = "100393801714299",
    ["copy"] = "116378866141355", ["copy-check"] = "92397569046734", ["copy-minus"] = "75815893695780", ["copy-plus"] = "138173295478363",
    ["copy-slash"] = "74395410823283", ["copy-x"] = "98741265066436", ["copyleft"] = "103019482632984", ["copyright"] = "82044483134605",
    ["corner-down-left"] = "105689000447775", ["corner-down-right"] = "82061714010896", ["corner-left-down"] = "133517193053100", ["corner-left-up"] = "78035789940893",
    ["corner-right-down"] = "135390474501786", ["corner-right-up"] = "122661540167291", ["corner-up-left"] = "72973602941956", ["corner-up-right"] = "108297458644964",
    ["cpu"] = "105237370909681", ["creative-commons"] = "111243376462256", ["credit-card"] = "124946887228472", ["croissant"] = "77683374738482",
    ["crop"] = "121481502611712", ["cross"] = "93673591064028", ["crosshair"] = "83752373575368", ["crown"] = "92253403464658",
    ["cuboid"] = "117329818290748", ["cup-soda"] = "132120247880161", ["currency"] = "96706001818192", ["cylinder"] = "99158693669056",
    ["database"] = "99154172590159", ["diamond"] = "136889727768904", ["diamond-percent"] = "138695404542126", ["dice-1"] = "133629376866649",
    ["dice-2"] = "137517882571271", ["dice-3"] = "128612626459042", ["dice-4"] = "73117400593570", ["dice-5"] = "107643287892749",
    ["dice-6"] = "112067139297943", ["dices"] = "116678154854810", ["diff"] = "122850860032588", ["disc"] = "77318106935130",
    ["disc-2"] = "135460247355994", ["disc-3"] = "118087373340436", ["disc-album"] = "101298984360789", ["divide"] = "134571770296218",
    ["divide-circle"] = "115849848955050", ["divide-square"] = "78617148972524", ["dna"] = "131581201333424", ["dna-off"] = "90101733367858",
    ["dock"] = "96133720652582", ["dog"] = "123749328846346", ["dollar-sign"] = "74567340201672", ["donut"] = "123909563150383",
    ["door-closed"] = "118483980594708", ["door-open"] = "124230332524625", ["dot"] = "105006331197983", ["download"] = "109698732019071",
    ["download-cloud"] = "122841052352556", ["drafting-compass"] = "110585086142082", ["drama"] = "138828515077300", ["dribbble"] = "112906380564504",
    ["drill"] = "113833078477512", ["droplet"] = "91586468475195", ["droplets"] = "117720354071548", ["drum"] = "121019656655547",
    ["drumstick"] = "106711459328737", ["dumbbell"] = "130873531670678", ["ear"] = "92631431780796", ["ear-off"] = "81480882487332",
    ["earth"] = "75025349205767", ["earth-lock"] = "103673515494330", ["eclipse"] = "113566298471092", ["egg"] = "103880404435578",
    ["egg-fried"] = "137654273789326", ["egg-off"] = "99146230558760", ["ellipsis"] = "95127553964880", ["ellipsis-vertical"] = "95771045694204",
    ["equal"] = "79273099065269", ["eraser"] = "71210100060694", ["euro"] = "139202392240827", ["expand"] = "107643532357936",
    ["external-link"] = "78664150174274", ["eye"] = "127234874352422", ["eye-off"] = "85207295981701", ["facebook"] = "98822363427090",
    ["factory"] = "79319339232812", ["fan"] = "76323281744636", ["fast-forward"] = "131011550754955", ["feather"] = "103991922506350",
    ["fence"] = "90935998613863", ["ferris-wheel"] = "94538249337586", ["figma"] = "103020132259719", ["file"] = "108499043987115",
    ["file-archive"] = "78133118745021", ["file-audio"] = "101306436065858", ["file-audio-2"] = "103353018363480", ["file-axis-3d"] = "136107008496948",
    ["file-badge"] = "135829024450190", ["file-badge-2"] = "87916835926622", ["file-bar-chart"] = "92900624303400", ["file-bar-chart-2"] = "133337118425916",
    ["file-box"] = "102441183584476", ["file-check"] = "91719007832323", ["file-check-2"] = "120611252466724", ["file-clock"] = "101240345040794",
    ["file-code"] = "93918366472395", ["file-code-2"] = "77999709917415", ["file-cog"] = "130835463141181", ["file-diff"] = "132890714271689",
    ["file-digit"] = "108016195781167", ["file-down"] = "79495546108963", ["file-edit"] = "82156880342025", ["file-heart"] = "138364329637312",
    ["file-image"] = "83675710276234", ["file-input"] = "78561929224193", ["file-json"] = "98868866618869", ["file-json-2"] = "92610524789574",
    ["file-key"] = "83249504215614", ["file-key-2"] = "103006369640378", ["file-line-chart"] = "84182680444173", ["file-lock"] = "140186307068344",
    ["file-lock-2"] = "126656887901996", ["file-minus"] = "138371877961417", ["file-minus-2"] = "107551117550330", ["file-music"] = "107180630571772",
    ["file-output"] = "109566424197143", ["file-pen"] = "134577965177665", ["file-pen-line"] = "90852962587361", ["file-pie-chart"] = "94554256943610",
    ["file-plus"] = "74194167957081", ["file-plus-2"] = "111571245681686", ["file-question"] = "128415338385227", ["file-scan"] = "132590981389921",
    ["file-search"] = "131130928074464", ["file-search-2"] = "139930116408040", ["file-signature"] = "87096324580559", ["file-sliders"] = "133181135528313",
    ["file-spreadsheet"] = "117808207510717", ["file-stack"] = "132187715148899", ["file-symlink"] = "122206323516270", ["file-terminal"] = "91847143440556",
    ["file-text"] = "92774566080911", ["file-type"] = "139551268989315", ["file-type-2"] = "91173675777316", ["file-up"] = "99191463679083",
    ["file-video"] = "105252283775469", ["file-video-2"] = "130213998083954", ["file-volume"] = "119603558694315", ["file-volume-2"] = "139949156797892",
    ["file-warning"] = "89824347717079", ["file-x"] = "117124390222574", ["file-x-2"] = "136449417648465", ["files"] = "78685849153126",
    ["film"] = "120941801045330", ["filter"] = "100930784445785", ["filter-x"] = "85838104400923", ["fingerprint"] = "109514257830136",
    ["fire-extinguisher"] = "84862159260845", ["fish"] = "114555142566431", ["fish-off"] = "99443044829026", ["fish-symbol"] = "123702927226939",
    ["flag"] = "121835250831612", ["flag-off"] = "90046025355940", ["flag-triangle-left"] = "73117581559482", ["flag-triangle-right"] = "106524126597496",
    ["flame"] = "125012650497883", ["flame-kindling"] = "136834319064926", ["flashlight"] = "110881718712443", ["flashlight-off"] = "117038550056668",
    ["flask-conical"] = "115528123394259", ["flask-conical-off"] = "102385597737770", ["flask-round"] = "118701306736141", ["flip-horizontal"] = "76347241876815",
    ["flip-horizontal-2"] = "107329750779249", ["flip-vertical"] = "121575310281690", ["flip-vertical-2"] = "77578710261033", ["flower"] = "98459040977090",
    ["flower-2"] = "79478214327919", ["focus"] = "116191961683883", ["fold-horizontal"] = "133102230855922", ["fold-vertical"] = "128556601978376",
    ["folder"] = "77937190465422", ["folder-archive"] = "96956679126324", ["folder-check"] = "95477621394824", ["folder-clock"] = "137926892639070",
    ["folder-closed"] = "86427718056887", ["folder-cog"] = "127866486547434", ["folder-dot"] = "129773010201383", ["folder-down"] = "82793534945672",
    ["folder-edit"] = "102495189191583", ["folder-git"] = "104507928948019", ["folder-git-2"] = "85014883332248", ["folder-heart"] = "110088173047332",
    ["folder-input"] = "132837435930621", ["folder-kanban"] = "138103158509024", ["folder-key"] = "130401922270021", ["folder-lock"] = "111493727654155",
    ["folder-minus"] = "97790081587083", ["folder-open"] = "112237915867403", ["folder-open-dot"] = "90332268376865", ["folder-output"] = "125946013402264",
    ["folder-pen"] = "81838874164795", ["folder-plus"] = "71462957431660", ["folder-root"] = "80403663819762", ["folder-search"] = "109602276944932",
    ["folder-search-2"] = "74614286288240", ["folder-symlink"] = "89907141903257", ["folder-sync"] = "137088423628527", ["folder-tree"] = "78199416535568",
    ["folder-up"] = "85416900334449", ["folder-x"] = "103887939759350", ["folders"] = "97828544806816", ["footprints"] = "80792036653047",
    ["forklift"] = "117529645336183", ["form-input"] = "73368443063193", ["forward"] = "78301309129142", ["frame"] = "81913255681858",
    ["framer"] = "117525065607897", ["frown"] = "88589722723911", ["fuel"] = "112915457104961", ["fullscreen"] = "92176335589571",
    ["function-square"] = "77009803117016", ["gallery-horizontal"] = "113964455804231", ["gallery-horizontal-end"] = "125589356860308", ["gallery-thumbnails"] = "123093292028306",
    ["gallery-vertical"] = "109130466006021", ["gallery-vertical-end"] = "122352399696695", ["gamepad"] = "81482768981191", ["gamepad-2"] = "99293705721130",
    ["gantt-chart"] = "122456724985241", ["gantt-chart-square"] = "73571197135748", ["gauge"] = "128279962545721", ["gauge-circle"] = "110231832967256",
    ["gavel"] = "118993398179839", ["gem"] = "125353572203968", ["ghost"] = "132705178126217", ["gift"] = "87706885156127",
    ["git-branch"] = "101518089376526", ["git-branch-plus"] = "127909649257701", ["git-commit-horizontal"] = "91306319670540", ["git-commit-vertical"] = "101185915909200",
    ["git-compare"] = "134611228556653", ["git-compare-arrows"] = "134203912676625", ["git-fork"] = "138214272765755", ["git-graph"] = "126789259203618",
    ["git-merge"] = "118868315103570", ["git-pull-request"] = "117991178843732", ["git-pull-request-arrow"] = "133155768650667", ["git-pull-request-closed"] = "74188383635944",
    ["git-pull-request-create"] = "108540858735398", ["git-pull-request-create-arrow"] = "75317536980451", ["git-pull-request-draft"] = "127220095778670", ["github"] = "140138081031269",
    ["gitlab"] = "109316577965403", ["glass-water"] = "125170765146614", ["glasses"] = "77027406085123", ["globe"] = "125685532120024",
    ["globe-2"] = "112945472486319", ["globe-lock"] = "96469366281710", ["goal"] = "90015442702200", ["grab"] = "117741873625250",
    ["graduation-cap"] = "140187510907091", ["grape"] = "73195418744413", ["grid-2x2"] = "134599229810680", ["grid-3x3"] = "108197747587523",
    ["grip"] = "88188569450143", ["grip-horizontal"] = "72027364608348", ["grip-vertical"] = "136050395759142", ["group"] = "79946652686375",
    ["guitar"] = "135654565391445", ["ham"] = "134057117057030", ["hammer"] = "73956316105509", ["hand"] = "83088528355903",
    ["hand-coins"] = "85922324710029", ["hand-heart"] = "124155721578457", ["hand-helping"] = "95094264299544", ["hand-metal"] = "105555696144202",
    ["hand-platter"] = "101356141176839", ["handshake"] = "121760224402586", ["hard-drive"] = "115211376876196", ["hard-drive-download"] = "115854711953657",
    ["hard-drive-upload"] = "112990104477043", ["hard-hat"] = "105207891316460", ["hash"] = "128945191245705", ["haze"] = "86624380139587",
    ["hdmi-port"] = "123935181216786", ["heading"] = "115666667306834", ["heading-1"] = "82056941503516", ["heading-2"] = "109194333144049",
    ["heading-3"] = "86456694536830", ["heading-4"] = "108808532352504", ["heading-5"] = "84468448396475", ["heading-6"] = "70885434512827",
    ["headphones"] = "89990513082092", ["headset"] = "77155289443816", ["heart"] = "88525382655929", ["heart-crack"] = "78532998725036",
    ["heart-handshake"] = "88807882205984", ["heart-off"] = "121500734414824", ["heart-pulse"] = "101116623654468", ["heater"] = "75867015789217",
    ["help-circle"] = "71693802872044", ["helping-hand"] = "82838882533396", ["hexagon"] = "111932983587355", ["highlighter"] = "124195908160173",
    ["history"] = "70375455140492", ["home"] = "109841253338329", ["hop"] = "87886892027508", ["hop-off"] = "124047203843704",
    ["hospital"] = "100542468114469", ["hotel"] = "88463240253197", ["hourglass"] = "135654740495171", ["ice-cream"] = "95314536020685",
    ["ice-cream-2"] = "93935347717656", ["ice-cream-bowl"] = "116507918255217", ["ice-cream-cone"] = "72823870951577", ["image"] = "114022611279795",
    ["image-down"] = "91697762317652", ["image-minus"] = "111691180013117", ["image-off"] = "113890586559666", ["image-plus"] = "131640557457656",
    ["image-up"] = "95362531246536", ["images"] = "87539822715105", ["import"] = "87776530532335", ["inbox"] = "131993988107472",
    ["indent"] = "111431763044113", ["indent-decrease"] = "77902371540680", ["indent-increase"] = "116043459584133", ["indian-rupee"] = "121515804799242",
    ["infinity"] = "77975814002740", ["info"] = "120620848266512", ["inspection-panel"] = "93487140703578", ["instagram"] = "88504800931130",
    ["italic"] = "96844815325902", ["iteration-ccw"] = "114475186061127", ["iteration-cw"] = "130833288197698", ["japanese-yen"] = "108845518454015",
    ["joystick"] = "75024649968329", ["kanban"] = "132557744047883", ["kanban-square"] = "124564901729634", ["kanban-square-dashed"] = "134205902924289",
    ["key"] = "83474888140571", ["key-round"] = "116918931002434", ["key-square"] = "79693131186843", ["keyboard"] = "121978468376124",
    ["keyboard-music"] = "74763240290099", ["lamp"] = "123765123149989", ["lamp-ceiling"] = "120174084956571", ["lamp-desk"] = "125995036157694",
    ["lamp-floor"] = "102217348025530", ["lamp-wall-down"] = "134067530649420", ["lamp-wall-up"] = "101034120941267", ["land-plot"] = "114974071140535",
    ["landmark"] = "130189940998950", ["languages"] = "130065428637597", ["laptop"] = "103798905446648", ["laptop-2"] = "106021728338003",
    ["laptop-minimal"] = "91920768368168", ["lasso"] = "110262485516329", ["lasso-select"] = "112600066891219", ["laugh"] = "115974660887808",
    ["layers"] = "114499998778667", ["layers-2"] = "87219208863328", ["layers-3"] = "114549653986465", ["layout"] = "75056433029964",
    ["layout-dashboard"] = "70433574792490", ["layout-grid"] = "89644754139307", ["layout-list"] = "72384664085473", ["layout-panel-left"] = "117264898598467",
    ["layout-panel-top"] = "135570881026156", ["layout-template"] = "78078135578383", ["leaf"] = "70846801126940", ["leafy-green"] = "94770162749325",
    ["library"] = "114050057679028", ["library-big"] = "135791941822287", ["library-square"] = "132158761398954", ["life-buoy"] = "99147024142900",
    ["ligature"] = "75804099923602", ["lightbulb"] = "98419938500979", ["lightbulb-off"] = "126746194476977", ["line-chart"] = "115214641333880",
    ["link"] = "86131768436965", ["link-2"] = "107339085791087", ["link-2-off"] = "74994782779018", ["linkedin"] = "102928864661994",
    ["list"] = "101699539545687", ["list-checks"] = "133109875194066", ["list-collapse"] = "103651151660786", ["list-end"] = "116487672075047",
    ["list-filter"] = "83186010624431", ["list-minus"] = "119184210915074", ["list-music"] = "88988800995482", ["list-ordered"] = "100068475590931",
    ["list-plus"] = "124010335412192", ["list-restart"] = "91193864293753", ["list-start"] = "131366235513143", ["list-todo"] = "83287488939815",
    ["list-tree"] = "127759805921507", ["list-video"] = "117978552190904", ["list-x"] = "115746075160943", ["loader"] = "132295854994374",
    ["loader-2"] = "128780061297692", ["loader-circle"] = "71250150569964", ["locate"] = "106821189831430", ["locate-fixed"] = "80648116191645",
    ["locate-off"] = "121088730454886", ["lock"] = "119765975153029", ["lock-keyhole"] = "135504457058301", ["lock-keyhole-open"] = "132192657766903",
    ["lock-open"] = "71186154315213", ["log-in"] = "82241120685313", ["log-out"] = "140299936053191", ["lollipop"] = "102239398934579",
    ["luggage"] = "140614046877100", ["m-square"] = "97856747717836", ["magnet"] = "97474941633274", ["mail"] = "77537514051485",
    ["mail-check"] = "90824179551389", ["mail-minus"] = "104189493909738", ["mail-open"] = "74874447671108", ["mail-plus"] = "130540869833539",
    ["mail-question"] = "128924135790205", ["mail-search"] = "108269769085404", ["mail-warning"] = "126275145590627", ["mail-x"] = "97229750262408",
    ["mailbox"] = "104064071799815", ["mails"] = "120925930542398", ["map"] = "131325044235094", ["map-pin"] = "137091405832737",
    ["map-pin-off"] = "130126969919710", ["map-pinned"] = "78894827751778", ["martini"] = "108853683970464", ["maximize"] = "116546384863431",
    ["maximize-2"] = "130049637400171", ["medal"] = "97534791863003", ["megaphone"] = "139746713205639", ["megaphone-off"] = "130364738220291",
    ["meh"] = "117127044934876", ["memory-stick"] = "82464660673318", ["menu"] = "83047518441184", ["menu-square"] = "84168857053009",
    ["merge"] = "96640473379848", ["message-circle"] = "74163263000218", ["message-circle-code"] = "124462142601421", ["message-circle-dashed"] = "78559601215727",
    ["message-circle-heart"] = "122100978068245", ["message-circle-more"] = "72969556529414", ["message-circle-off"] = "106640802525475", ["message-circle-plus"] = "97202853233666",
    ["message-circle-question"] = "85003442346058", ["message-circle-reply"] = "96024981688039", ["message-circle-warning"] = "112239075926369", ["message-circle-x"] = "104081317224904",
    ["message-square"] = "86432989388834", ["message-square-code"] = "139338315973052", ["message-square-dashed"] = "127422492651127", ["message-square-diff"] = "120745701209397",
    ["message-square-dot"] = "131246995114947", ["message-square-heart"] = "137436561363370", ["message-square-more"] = "76812000893936", ["message-square-off"] = "97376166485199",
    ["message-square-plus"] = "77957118386462", ["message-square-quote"] = "97203851012575", ["message-square-reply"] = "138540430807955", ["message-square-share"] = "94526690702300",
    ["message-square-text"] = "128095657789286", ["message-square-warning"] = "83694786088101", ["message-square-x"] = "83972010967159", ["messages-square"] = "112345482432498",
    ["mic"] = "125870172276779", ["mic-2"] = "79774423165436", ["mic-off"] = "84064988822624", ["mic-vocal"] = "116345765074785",
    ["microscope"] = "134078584568005", ["microwave"] = "109575331253451", ["milestone"] = "88614752388873", ["milk"] = "119818923307142",
    ["milk-off"] = "72925919409773", ["minimize"] = "95555494586098", ["minimize-2"] = "96294437144715", ["minus"] = "95070996149109",
    ["minus-circle"] = "103303552772654", ["minus-square"] = "96983863580751", ["monitor"] = "70520152532392", ["monitor-check"] = "112341875921743",
    ["monitor-dot"] = "132673547251589", ["monitor-down"] = "132502390896673", ["monitor-off"] = "95048101284680", ["monitor-pause"] = "99458637542686",
    ["monitor-play"] = "107640137618506", ["monitor-smartphone"] = "81757216234228", ["monitor-speaker"] = "131099454095944", ["monitor-stop"] = "99235976282671",
    ["monitor-up"] = "116018518624879", ["monitor-x"] = "102604336229610", ["moon"] = "98353636264918", ["moon-star"] = "137086737657962",
    ["more-horizontal"] = "101330725759187", ["more-vertical"] = "76302166494262", ["mountain"] = "90592200130155", ["mountain-snow"] = "111710418991773",
    ["mouse"] = "122014945028597", ["mouse-pointer"] = "113428527051320", ["mouse-pointer-2"] = "84070353881242", ["mouse-pointer-click"] = "81854854241463",
    ["mouse-pointer-square"] = "112337311970951", ["mouse-pointer-square-dashed"] = "80677641664079", ["move"] = "77028714324861", ["move-3d"] = "82487420092874",
    ["move-diagonal"] = "111179404262244", ["move-diagonal-2"] = "128492050787735", ["move-down"] = "85099736811132", ["move-down-left"] = "138054515129112",
    ["move-down-right"] = "116621809745618", ["move-horizontal"] = "136107424781093", ["move-left"] = "89444723083105", ["move-right"] = "133586722586273",
    ["move-up"] = "76410952730524", ["move-up-left"] = "102293680652367", ["move-up-right"] = "88087592569369", ["move-vertical"] = "92087242547029",
    ["music"] = "132132095360900", ["music-2"] = "121112248614371", ["music-3"] = "75731760539974", ["music-4"] = "122935411241955",
    ["navigation"] = "76549947719521", ["navigation-2"] = "127270865325663", ["navigation-2-off"] = "74005663669130", ["navigation-off"] = "96787422854853",
    ["network"] = "110230147673946", ["newspaper"] = "115179113478597", ["nfc"] = "119131457808272", ["notebook"] = "93996170225525",
    ["notebook-pen"] = "70494109504383", ["notebook-tabs"] = "113749031276097", ["notebook-text"] = "86811328922423", ["notepad-text"] = "104957079697866",
    ["notepad-text-dashed"] = "113624610966525", ["nut"] = "77621843968987", ["nut-off"] = "84877157781266", ["octagon"] = "103646759535962",
    ["octagon-alert"] = "101226496664732", ["octagon-pause"] = "127095623629829", ["octagon-x"] = "103912968479362", ["option"] = "77581357923982",
    ["orbit"] = "79200159961573", ["outdent"] = "136657573552804", ["package"] = "106101842173393", ["package-2"] = "76736374924338",
    ["package-check"] = "100671298334773", ["package-minus"] = "72114807005321", ["package-open"] = "86470175749466", ["package-plus"] = "74357376952178",
    ["package-search"] = "108965513580143", ["package-x"] = "80178189812476", ["paint-bucket"] = "116536780343642", ["paint-roller"] = "76545833297923",
    ["paintbrush"] = "113234034461805", ["paintbrush-2"] = "116925836096427", ["palette"] = "127369887384101", ["palmtree"] = "85651135388680",
    ["panel-bottom"] = "86537618399617", ["panel-bottom-close"] = "91281796987492", ["panel-bottom-dashed"] = "130167117027190", ["panel-bottom-inactive"] = "97483023786802",
    ["panel-bottom-open"] = "86549932703136", ["panel-left"] = "125599129725759", ["panel-left-close"] = "106532774300164", ["panel-left-dashed"] = "115976249358122",
    ["panel-left-inactive"] = "102689057283340", ["panel-left-open"] = "126704485649345", ["panel-right"] = "83386566029978", ["panel-right-close"] = "133236216519470",
    ["panel-right-dashed"] = "138321632890167", ["panel-right-inactive"] = "95197732140314", ["panel-right-open"] = "107436518875633", ["panel-top"] = "80001561556081",
    ["panel-top-close"] = "124467779594157", ["panel-top-dashed"] = "79452019243803", ["panel-top-inactive"] = "135806161551683", ["panel-top-open"] = "88468571469051",
    ["panels-left-bottom"] = "100709335124708", ["panels-right-bottom"] = "118563843738058", ["panels-top-left"] = "119230493302275", ["paperclip"] = "101144735754292",
    ["parentheses"] = "117743859847736", ["parking-circle"] = "132958171449207", ["parking-circle-off"] = "90293787674695", ["parking-meter"] = "95540023655686",
    ["parking-square"] = "119709845027214", ["parking-square-off"] = "111516007201199", ["party-popper"] = "92886643958723", ["pause"] = "79610666871575",
    ["pause-circle"] = "121009275520669", ["pause-octagon"] = "75691149975017", ["paw-print"] = "97578437331341", ["pc-case"] = "134071343822649",
    ["pen"] = "101486948449510", ["pen-line"] = "108991407462745", ["pen-square"] = "124290018373176", ["pen-tool"] = "126917951709518",
    ["pencil"] = "113132794872298", ["pencil-line"] = "97622550721067", ["pencil-ruler"] = "83914055949508", ["pentagon"] = "133006808893408",
    ["percent"] = "138143948353522", ["percent-circle"] = "120133426400204", ["percent-diamond"] = "116484660741674", ["percent-square"] = "123104718284792",
    ["person-standing"] = "101118444346965", ["phone"] = "110402416146068", ["phone-call"] = "83844308787978", ["phone-forwarded"] = "121647613341736",
    ["phone-incoming"] = "80024725665109", ["phone-missed"] = "79555645036339", ["phone-off"] = "124218610436691", ["phone-outgoing"] = "107942094735434",
    ["pi"] = "94324814221349", ["pi-square"] = "104995627137456", ["piano"] = "119387553084830", ["pickaxe"] = "111300940329486",
    ["picture-in-picture"] = "131356651374909", ["picture-in-picture-2"] = "82685697007608", ["pie-chart"] = "102602815840153", ["piggy-bank"] = "137519559090410",
    ["pilcrow"] = "73426591830540", ["pilcrow-square"] = "104294263901485", ["pill"] = "102063979166015", ["pin"] = "84152083728286",
    ["pin-off"] = "79775551915820", ["pipette"] = "104047428948587", ["pizza"] = "137422469806542", ["plane"] = "123931033451986",
    ["plane-landing"] = "127564654216931", ["plane-takeoff"] = "71424495151201", ["play"] = "76386816441302", ["play-circle"] = "94679908148591",
    ["play-square"] = "88949301532557", ["plug"] = "92495517782055", ["plug-2"] = "90278231790155", ["plug-zap"] = "120081085677067",
    ["plug-zap-2"] = "114634662672913", ["plus"] = "101123124881873", ["plus-circle"] = "120968869021626", ["plus-square"] = "110356023190006",
    ["pocket"] = "84604104357709", ["pocket-knife"] = "75327579226876", ["podcast"] = "107827753005302", ["pointer"] = "98931495397575",
    ["pointer-off"] = "121208450103912", ["popcorn"] = "131831744800890", ["popsicle"] = "104185203372496", ["pound-sterling"] = "104324833143828",
    ["power"] = "89331085993646", ["power-circle"] = "116376776686511", ["power-off"] = "71082730746769", ["power-square"] = "119684962977179",
    ["presentation"] = "116401163910084", ["printer"] = "71465784501775", ["projector"] = "73231680903652", ["proportions"] = "78144579158638",
    ["puzzle"] = "117598556369229", ["pyramid"] = "132485249599747", ["qr-code"] = "113440393569209", ["quote"] = "131322529504476",
    ["rabbit"] = "114280087699339", ["radar"] = "132868138496209", ["radiation"] = "100877813176471", ["radical"] = "108409175619446",
    ["radio"] = "99420757373028", ["radio-receiver"] = "121282639721016", ["radio-tower"] = "88833838205757", ["radius"] = "74995747675698",
    ["rail-symbol"] = "97316226200213", ["rainbow"] = "103765621191575", ["rat"] = "87357329634876", ["ratio"] = "93282099315884",
    ["receipt"] = "92008292109070", ["receipt-cent"] = "112492211580771", ["receipt-euro"] = "133191175020669", ["receipt-indian-rupee"] = "133266746153788",
    ["receipt-japanese-yen"] = "124042872765776", ["receipt-pound-sterling"] = "100101322122623", ["receipt-russian-ruble"] = "121506664677675", ["receipt-swiss-franc"] = "99002246681862",
    ["receipt-text"] = "100006409297382", ["rectangle-ellipsis"] = "107119201863591", ["rectangle-horizontal"] = "138840515431449", ["rectangle-vertical"] = "105899574411289",
    ["recycle"] = "113939163175897", ["redo"] = "109330889951617", ["redo-2"] = "139377644547969", ["redo-dot"] = "103006780441917",
    ["refresh-ccw"] = "112330254035751", ["refresh-ccw-dot"] = "82338761134697", ["refresh-cw"] = "106497040962250", ["refresh-cw-off"] = "70915551154203",
    ["refrigerator"] = "112780018998815", ["regex"] = "134026857287988", ["remove-formatting"] = "138608399804923", ["repeat"] = "88751041821881",
    ["repeat-1"] = "83172378763568", ["repeat-2"] = "103267027937654", ["replace"] = "107047557421203", ["replace-all"] = "100838712445846",
    ["reply"] = "92729212112550", ["reply-all"] = "89383445888953", ["rewind"] = "112118266859844", ["ribbon"] = "138074895056157",
    ["rocket"] = "109537053598807", ["rocking-chair"] = "78801538856684", ["roller-coaster"] = "97027135474963", ["rotate-3d"] = "97818595741565",
    ["rotate-ccw"] = "75086444429266", ["rotate-ccw-square"] = "109860100695153", ["rotate-cw"] = "83145058297547", ["rotate-cw-square"] = "125618900116298",
    ["route"] = "92054788599928", ["route-off"] = "84281383994516", ["router"] = "137822323057124", ["rows"] = "137919453076186",
    ["rows-2"] = "95783038014917", ["rows-3"] = "120887473789104", ["rows-4"] = "116714271746099", ["rss"] = "133733106949535",
    ["ruler"] = "84633402845324", ["russian-ruble"] = "126835196314974", ["sailboat"] = "95990070790702", ["salad"] = "126822773594847",
    ["sandwich"] = "125331738014611", ["satellite"] = "76405829153460", ["satellite-dish"] = "80919601328215", ["save"] = "122894934359450",
    ["save-all"] = "130108174247404", ["scale"] = "104058148891720", ["scale-3d"] = "98514591753294", ["scaling"] = "101030566996452",
    ["scan"] = "125367266780285", ["scan-barcode"] = "97414347978098", ["scan-eye"] = "109514269737059", ["scan-face"] = "98379048258175",
    ["scan-line"] = "74491678843147", ["scan-search"] = "133304136560518", ["scan-text"] = "135056446730766", ["scatter-chart"] = "74267179296978",
    ["school"] = "127958337382355", ["school-2"] = "85807427737192", ["scissors"] = "105992192896067", ["scissors-line-dashed"] = "136613376152055",
    ["scissors-square"] = "74695197837525", ["scissors-square-dashed-bottom"] = "107920465612561", ["screen-share"] = "77511025094385", ["screen-share-off"] = "121685614490746",
    ["scroll"] = "120140373437385", ["scroll-text"] = "93551675076113", ["search"] = "72296609649861", ["search-check"] = "135876289053244",
    ["search-code"] = "96217854889522", ["search-slash"] = "103651057689299", ["search-x"] = "107116182495739", ["send"] = "94849431195865",
    ["send-horizontal"] = "71350661970492", ["send-to-back"] = "128357510439179", ["separator-horizontal"] = "138451510103519", ["separator-vertical"] = "136594330269338",
    ["server"] = "105706502741449", ["server-cog"] = "100022312079887", ["server-crash"] = "87758222542375", ["server-off"] = "80255747106695",
    ["settings"] = "106205298246017", ["settings-2"] = "109485777305919", ["shapes"] = "72318824907864", ["share"] = "78225483239202",
    ["share-2"] = "139712792470775", ["sheet"] = "74805372511449", ["shell"] = "103995324275618", ["shield"] = "106509993556171",
    ["shield-alert"] = "91754324662625", ["shield-ban"] = "124352578023288", ["shield-check"] = "71867984579031", ["shield-ellipsis"] = "93065391097116",
    ["shield-half"] = "123735656472960", ["shield-minus"] = "80388855203128", ["shield-off"] = "98525250043109", ["shield-plus"] = "121205118266112",
    ["shield-question"] = "114815120818758", ["shield-x"] = "75826463279777", ["ship"] = "98574156558498", ["ship-wheel"] = "130141263234416",
    ["shirt"] = "128162112866809", ["shopping-bag"] = "121389568871142", ["shopping-basket"] = "110161824939086", ["shopping-cart"] = "79435149356304",
    ["shovel"] = "96637119542790", ["shower-head"] = "114908638980660", ["shrink"] = "115135316516120", ["shrub"] = "79864992147519",
    ["shuffle"] = "103735725549548", ["sigma"] = "74383416855806", ["sigma-square"] = "132360260153111", ["signal"] = "126197135689656",
    ["signal-high"] = "93347669262895", ["signal-low"] = "84665611291998", ["signal-medium"] = "75062813653519", ["signal-zero"] = "109850227743382",
    ["signpost"] = "97962937781200", ["signpost-big"] = "87216549939239", ["siren"] = "81845882921662", ["skip-back"] = "137660494219613",
    ["skip-forward"] = "121822124041513", ["skull"] = "101060850237115", ["slack"] = "107723459729315", ["slash"] = "77878973734361",
    ["slice"] = "140518011325498", ["sliders"] = "105166722651208", ["sliders-horizontal"] = "125396339381135", ["sliders-vertical"] = "75780544616650",
    ["smartphone"] = "74962751233767", ["smartphone-charging"] = "86644420255103", ["smartphone-nfc"] = "121578015636822", ["smile"] = "129431925610335",
    ["smile-plus"] = "83315367165388", ["snail"] = "104438747965017", ["snowflake"] = "70879271596915", ["sofa"] = "87577807512220",
    ["soup"] = "123867447658880", ["space"] = "86056382889566", ["spade"] = "121221766194945", ["sparkle"] = "83114431765537",
    ["sparkles"] = "105634041692696", ["speaker"] = "117894179084666", ["speech"] = "86788645272110", ["spell-check"] = "139048235918692",
    ["spell-check-2"] = "77691901804556", ["spline"] = "127621289965723", ["split"] = "124184087776521", ["split-square-horizontal"] = "71187946462875",
    ["split-square-vertical"] = "77254227779817", ["spray-can"] = "97652569554326", ["sprout"] = "100976494216154", ["square"] = "135105418501265",
    ["square-activity"] = "123457120309378", ["square-arrow-down"] = "116832660638208", ["square-arrow-down-left"] = "90743878595626", ["square-arrow-down-right"] = "111115470362134",
    ["square-arrow-left"] = "118414350090559", ["square-arrow-out-down-left"] = "118423572451505", ["square-arrow-out-down-right"] = "82860326458804", ["square-arrow-out-up-left"] = "107517171610982",
    ["square-arrow-out-up-right"] = "96480170164917", ["square-arrow-right"] = "137471464720012", ["square-arrow-up"] = "130005030476582", ["square-arrow-up-left"] = "103366812234876",
    ["square-arrow-up-right"] = "80186154045078", ["square-asterisk"] = "85576779554554", ["square-bottom-dashed-scissors"] = "105977668655594", ["square-check"] = "122631573561562",
    ["square-check-big"] = "139404784607168", ["square-chevron-down"] = "120680078209607", ["square-chevron-left"] = "75397936728579", ["square-chevron-right"] = "76189118488226",
    ["square-chevron-up"] = "97181506287521", ["square-code"] = "76845656194464", ["square-dashed-bottom"] = "133040895929365", ["square-dashed-bottom-code"] = "103061363625640",
    ["square-dashed-kanban"] = "114545633956348", ["square-dashed-mouse-pointer"] = "123670726680392", ["square-divide"] = "107353979642451", ["square-dot"] = "110899495515389",
    ["square-equal"] = "124042600382551", ["square-function"] = "83985860709793", ["square-gantt-chart"] = "107284369076219", ["square-kanban"] = "97476877950543",
    ["square-library"] = "81887890003221", ["square-m"] = "135912337332436", ["square-menu"] = "135438142591878", ["square-minus"] = "78721357781624",
    ["square-mouse-pointer"] = "127552100194692", ["square-parking"] = "91463654971693", ["square-parking-off"] = "111927816549509", ["square-pen"] = "71257379947442",
    ["square-percent"] = "113289006657504", ["square-pi"] = "132511605174622", ["square-pilcrow"] = "87094629814766", ["square-play"] = "138697695062525",
    ["square-plus"] = "91942389112860", ["square-power"] = "120703265040347", ["square-radical"] = "134223878880054", ["square-scissors"] = "78779074277571",
    ["square-sigma"] = "94523643558062", ["square-slash"] = "78987954134223", ["square-split-horizontal"] = "125857047694996", ["square-split-vertical"] = "126418050285776",
    ["square-stack"] = "94687061933604", ["square-terminal"] = "75828907654568", ["square-user"] = "140235161621168", ["square-user-round"] = "81288587564855",
    ["square-x"] = "76206131996728", ["squircle"] = "99439828273252", ["squirrel"] = "120668151944533", ["stamp"] = "85130810524517",
    ["star"] = "72669221096319", ["star-half"] = "80822269649856", ["star-off"] = "120003686620511", ["step-back"] = "120706787286328",
    ["step-forward"] = "91046009066136", ["stethoscope"] = "78571774060105", ["sticker"] = "139865196874378", ["sticky-note"] = "98432110278865",
    ["stop-circle"] = "97489143368359", ["store"] = "121962391563311", ["stretch-horizontal"] = "78770748920269", ["stretch-vertical"] = "85907320465911",
    ["strikethrough"] = "90568214674515", ["subscript"] = "82653949184992", ["subtitles"] = "134234590631375", ["sun"] = "139232691165198",
    ["sun-dim"] = "131075444152110", ["sun-medium"] = "112704797109150", ["sun-moon"] = "121221641564933", ["sun-snow"] = "83004210487318",
    ["sunrise"] = "116733420530374", ["sunset"] = "101740056345650", ["superscript"] = "93191189359166", ["swatch-book"] = "70990631477660",
    ["swiss-franc"] = "72116456510352", ["switch-camera"] = "124033626341331", ["sword"] = "121406454377051", ["swords"] = "99199363807265",
    ["syringe"] = "86444160764731", ["table"] = "100826532869925", ["table-2"] = "129391889722576", ["table-cells-merge"] = "118490713113220",
    ["table-cells-split"] = "113945031629733", ["table-columns-split"] = "79195518284331", ["table-properties"] = "135976623395143", ["table-rows-split"] = "126696533672175",
    ["tablet"] = "90619723471983", ["tablet-smartphone"] = "78186066591210", ["tablets"] = "88043022962639", ["tag"] = "75425807137911",
    ["tags"] = "103166221753217", ["tally-1"] = "90000711698807", ["tally-2"] = "99935651880614", ["tally-3"] = "98958831676946",
    ["tally-4"] = "128656473677471", ["tally-5"] = "101955254503648", ["tangent"] = "103123484115035", ["target"] = "121091323240554",
    ["telescope"] = "103588488639070", ["tent"] = "91768489962137", ["tent-tree"] = "85050403463582", ["terminal"] = "102379915564176",
    ["terminal-square"] = "89706340938367", ["test-tube"] = "139701481278358", ["test-tube-2"] = "118913572969135", ["test-tube-diagonal"] = "121621592892259",
    ["test-tubes"] = "117323642962952", ["text"] = "99369759989955", ["text-cursor"] = "103697482936876", ["text-cursor-input"] = "84912489891242",
    ["text-quote"] = "102573021965795", ["text-search"] = "114489224126711", ["text-select"] = "99310852917353", ["theater"] = "89919220874053",
    ["thermometer"] = "90545345642681", ["thermometer-snowflake"] = "138010690931368", ["thermometer-sun"] = "82795165216031", ["thumbs-down"] = "73778874448741",
    ["thumbs-up"] = "96046658888813", ["ticket"] = "126875062984266", ["ticket-check"] = "117888043623314", ["ticket-minus"] = "89176175166723",
    ["ticket-percent"] = "88410626824232", ["ticket-plus"] = "83968600419805", ["ticket-slash"] = "79392492298521", ["ticket-x"] = "86658718829072",
    ["timer"] = "120164083411828", ["timer-off"] = "116991705734594", ["timer-reset"] = "79948324123231", ["toggle-left"] = "105639191695402",
    ["toggle-right"] = "129483325318573", ["tornado"] = "93796857097422", ["torus"] = "78822043673501", ["touchpad"] = "112333029100357",
    ["touchpad-off"] = "86546394503986", ["tower-control"] = "128131047012652", ["toy-brick"] = "81793486260595", ["tractor"] = "87948191954230",
    ["traffic-cone"] = "87190332091101", ["train-front"] = "91480038985820", ["train-front-tunnel"] = "77194453402235", ["train-track"] = "105798879242186",
    ["tram-front"] = "80023103356955", ["trash"] = "94712995845562", ["trash-2"] = "126010725826757", ["tree-deciduous"] = "109951315210525",
    ["tree-palm"] = "111070569131758", ["tree-pine"] = "71580980892868", ["trees"] = "79707751200645", ["trello"] = "90438659765426",
    ["trending-down"] = "122658819043338", ["trending-up"] = "86000419326493", ["triangle"] = "134878256295114", ["triangle-alert"] = "91165848022002",
    ["triangle-right"] = "105796120965583", ["trophy"] = "113055182645565", ["truck"] = "125468675952181", ["turtle"] = "73899487161474",
    ["tv"] = "130308429701946", ["tv-2"] = "129500347007411", ["twitch"] = "90697389361633", ["twitter"] = "90424880717042",
    ["type"] = "70694319369829", ["umbrella"] = "108749598923776", ["umbrella-off"] = "111820268638089", ["underline"] = "127096081441525",
    ["undo"] = "111464695038355", ["undo-2"] = "87358323292564", ["undo-dot"] = "102793353935041", ["unfold-horizontal"] = "85781955020909",
    ["unfold-vertical"] = "122887666597646", ["ungroup"] = "76318446818069", ["university"] = "102146636224428", ["unlink"] = "102194562745333",
    ["unlink-2"] = "108239607794680", ["unlock"] = "110263656507369", ["unlock-keyhole"] = "126931549237422", ["unplug"] = "123150141199349",
    ["upload"] = "118488857289315", ["upload-cloud"] = "121807815408739", ["usb"] = "75949167692936", ["user"] = "114567720540659",
    ["user-2"] = "92481398073007", ["user-check"] = "75620511859505", ["user-check-2"] = "73224920504446", ["user-circle"] = "111917761312899",
    ["user-circle-2"] = "96888447186214", ["user-cog"] = "87518742987519", ["user-cog-2"] = "115462370853742", ["user-minus"] = "94865546608687",
    ["user-minus-2"] = "93808234717021", ["user-plus"] = "101184880550364", ["user-plus-2"] = "104764183758140", ["user-round"] = "119713822992150",
    ["user-round-check"] = "99288072031664", ["user-round-cog"] = "127120627937146", ["user-round-minus"] = "129866427748569", ["user-round-plus"] = "101991526004413",
    ["user-round-search"] = "114857943818454", ["user-round-x"] = "89227016198055", ["user-search"] = "110388873642450", ["user-square"] = "136305896243658",
    ["user-square-2"] = "71391894371551", ["user-x"] = "138436637971548", ["user-x-2"] = "96976557144947", ["users"] = "85332511060401",
    ["users-2"] = "138651149526372", ["users-round"] = "103880524805720", ["utensils"] = "122537080261787", ["utensils-crossed"] = "100229317932246",
    ["utility-pole"] = "137834357386674", ["variable"] = "73932604072578", ["vault"] = "107415856993701", ["vegan"] = "127691293819852",
    ["venetian-mask"] = "84202958608655", ["vibrate"] = "140427675871522", ["vibrate-off"] = "102494346080496", ["video"] = "99411215690870",
    ["video-off"] = "81634790888002", ["videotape"] = "92799250697204", ["view"] = "102821349715124", ["voicemail"] = "121299677348672",
    ["volume"] = "127607149758269", ["volume-1"] = "115207748957226", ["volume-2"] = "129861259578431", ["volume-x"] = "106700331106145",
    ["vote"] = "137637654521705", ["wallet"] = "132318555862654", ["wallet-2"] = "120839431200970", ["wallet-cards"] = "86866924072285",
    ["wallet-minimal"] = "77655892701714", ["wallpaper"] = "76631821212930", ["wand"] = "95424916372879", ["wand-2"] = "84750107238092",
    ["wand-sparkles"] = "115623066336607", ["warehouse"] = "126757874656976", ["washing-machine"] = "72331434583186", ["watch"] = "103181426780078",
    ["waves"] = "98840358372718", ["waypoints"] = "101997233404191", ["webcam"] = "90027890284611", ["webhook"] = "110638252405523",
    ["webhook-off"] = "71995352392407", ["weight"] = "79312026690586", ["wheat"] = "115823998996262", ["wheat-off"] = "110571881208127",
    ["whole-word"] = "110504483563993", ["wifi"] = "104941258142372", ["wifi-off"] = "120795495190257", ["wind"] = "86165302601843",
    ["wine"] = "101623153529226", ["wine-off"] = "131814228138093", ["workflow"] = "78971198932745", ["worm"] = "98855303743824",
    ["wrap-text"] = "70866394776130", ["wrench"] = "85345725497834", ["x"] = "116396312853810", ["x-circle"] = "111132030834422",
    ["x-octagon"] = "105062643930018", ["x-square"] = "115678228554812", ["youtube"] = "134880265650906", ["zap"] = "109718589733073",
    ["zap-off"] = "115642996489807", ["zoom-in"] = "135570550221809", ["zoom-out"] = "100181096350591",
}


Library.Icons = IconsRest
local IconsCache = {}

function Library:GetIcon(iconName, asAssetUrl)
    if not iconName or iconName == "" then return nil end
    local nameStr = tostring(iconName)
    if nameStr:find("rbxassetid://") or nameStr:find("http://") or nameStr:find("https://") then
        return nameStr
    end
    if tonumber(nameStr) then
        return asAssetUrl ~= false and ("rbxassetid://" .. nameStr) or nameStr
    end
    
    local key = nameStr:lower():gsub("_", "-"):gsub("%s+", "-")
    if IconsCache[key] then
        local id = IconsCache[key]
        return asAssetUrl ~= false and ("rbxassetid://" .. id) or id
    end
    if IconsRest[key] then
        local id = IconsRest[key]
        return asAssetUrl ~= false and ("rbxassetid://" .. id) or id
    end
    if IconsRest[nameStr] then
        local id = IconsRest[nameStr]
        return asAssetUrl ~= false and ("rbxassetid://" .. id) or id
    end

    local kebab = nameStr:gsub("(%u)", "-%1"):lower():gsub("^-", "")
    if IconsRest[kebab] then
        local id = IconsRest[kebab]
        return asAssetUrl ~= false and ("rbxassetid://" .. id) or id
    end

    -- Online lookup from https://www.icons.rest/ if executor supports HTTP
    local fetchedId = nil
    pcall(function()
        local httpReq = (syn and syn.request) or (http and http.request) or http_request or request
        local body = nil
        if game and game.HttpGet then
            body = game:HttpGet("https://www.icons.rest/assets/index-2Z_ASbEf.js")
        elseif httpReq then
            local resp = httpReq({ Url = "https://www.icons.rest/assets/index-2Z_ASbEf.js", Method = "GET" })
            if resp and resp.Body then body = resp.Body end
        end
        if body then
            local pattern = 'name:"' .. key .. '",asset_id:"(%d+)"'
            local matchId = body:match(pattern)
            if matchId then
                fetchedId = matchId
                IconsCache[key] = matchId
                IconsRest[key] = matchId
            end
        end
    end)
    if fetchedId then
        return asAssetUrl ~= false and ("rbxassetid://" .. fetchedId) or fetchedId
    end

    return nil
end
Library.GetIcon = Library.GetIcon

Library.ThemePresets = {
    Dark = {
        Name = "Dark",
        MainBG = Color3.fromRGB(32, 34, 42),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(38, 41, 52),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(38, 41, 52),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(38, 41, 52),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(45, 48, 60),
            Color3.fromRGB(60, 64, 80),
            Color3.fromRGB(40, 42, 54)
        },
        MinGradient = {
            Color3.fromRGB(155, 160, 172),
            Color3.fromRGB(190, 195, 205),
            Color3.fromRGB(125, 130, 142)
        },
        Divider = Color3.fromRGB(65, 70, 88),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(180, 185, 200),
        CardBG = Color3.fromRGB(25, 27, 34),
        ButtonBG = Color3.fromRGB(155, 160, 172),
    },
    VeryDark = {
        Name = "Very Dark",
        MainBG = Color3.fromRGB(15, 16, 20),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(24, 26, 34),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(24, 26, 34),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(24, 26, 34),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(24, 26, 34),
            Color3.fromRGB(35, 38, 50),
            Color3.fromRGB(20, 22, 28)
        },
        MinGradient = {
            Color3.fromRGB(135, 140, 152),
            Color3.fromRGB(170, 175, 186),
            Color3.fromRGB(105, 110, 122)
        },
        Divider = Color3.fromRGB(40, 44, 58),
        Text = Color3.fromRGB(230, 235, 245),
        SubText = Color3.fromRGB(160, 165, 180),
        CardBG = Color3.fromRGB(10, 11, 14),
        ButtonBG = Color3.fromRGB(135, 140, 152),
    },
    Midnight = {
        Name = "Midnight",
        MainBG = Color3.fromRGB(11, 15, 25),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(16, 22, 38),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(16, 22, 38),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(16, 22, 38),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(16, 22, 38),
            Color3.fromRGB(25, 35, 60),
            Color3.fromRGB(12, 17, 30)
        },
        MinGradient = {
            Color3.fromRGB(70, 130, 240),
            Color3.fromRGB(120, 170, 255),
            Color3.fromRGB(50, 95, 200)
        },
        Divider = Color3.fromRGB(35, 48, 80),
        Text = Color3.fromRGB(240, 245, 255),
        SubText = Color3.fromRGB(155, 175, 210),
        CardBG = Color3.fromRGB(8, 11, 18),
        ButtonBG = Color3.fromRGB(70, 130, 240),
    },
    Nord = {
        Name = "Nord",
        MainBG = Color3.fromRGB(46, 52, 64),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(59, 66, 82),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(59, 66, 82),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(59, 66, 82),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(59, 66, 82),
            Color3.fromRGB(67, 76, 94),
            Color3.fromRGB(46, 52, 64)
        },
        MinGradient = {
            Color3.fromRGB(136, 192, 208),
            Color3.fromRGB(129, 161, 193),
            Color3.fromRGB(94, 129, 172)
        },
        Divider = Color3.fromRGB(76, 86, 106),
        Text = Color3.fromRGB(236, 239, 244),
        SubText = Color3.fromRGB(175, 185, 205),
        CardBG = Color3.fromRGB(36, 41, 51),
        ButtonBG = Color3.fromRGB(136, 192, 208),
    },
    AMOLED = {
        Name = "AMOLED",
        MainBG = Color3.fromRGB(0, 0, 0),
        MainTrans = 0.15,
        AccentBG = Color3.fromRGB(12, 12, 12),
        AccentTrans = 0.25,
        TopBG = Color3.fromRGB(12, 12, 12),
        TopTrans = 0.25,
        BottomBG = Color3.fromRGB(12, 12, 12),
        BottomTrans = 0.25,
        BottomGradient = {
            Color3.fromRGB(15, 15, 15),
            Color3.fromRGB(30, 30, 30),
            Color3.fromRGB(5, 5, 5)
        },
        MinGradient = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(180, 180, 180),
            Color3.fromRGB(120, 120, 120)
        },
        Divider = Color3.fromRGB(45, 45, 45),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 160),
        CardBG = Color3.fromRGB(8, 8, 8),
        ButtonBG = Color3.fromRGB(240, 240, 240),
    },
    White = {
        Name = "White",
        MainBG = Color3.fromRGB(242, 244, 248),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(210, 215, 228),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(210, 215, 228),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(210, 215, 228),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(210, 215, 228),
            Color3.fromRGB(230, 235, 245),
            Color3.fromRGB(200, 205, 220)
        },
        MinGradient = {
            Color3.fromRGB(110, 115, 128),
            Color3.fromRGB(150, 155, 168),
            Color3.fromRGB(80, 85, 96)
        },
        Divider = Color3.fromRGB(180, 190, 210),
        Text = Color3.fromRGB(30, 32, 40),
        SubText = Color3.fromRGB(70, 75, 90),
        CardBG = Color3.fromRGB(255, 255, 255),
        ButtonBG = Color3.fromRGB(110, 115, 128),
    },
    Coffee = {
        Name = "Coffee",
        MainBG = Color3.fromRGB(43, 31, 26),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(54, 39, 32),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(54, 39, 32),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(54, 39, 32),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(54, 39, 32),
            Color3.fromRGB(75, 55, 45),
            Color3.fromRGB(35, 25, 20)
        },
        MinGradient = {
            Color3.fromRGB(198, 156, 109),
            Color3.fromRGB(230, 195, 150),
            Color3.fromRGB(150, 110, 75)
        },
        Divider = Color3.fromRGB(111, 78, 55),
        Text = Color3.fromRGB(243, 233, 220),
        SubText = Color3.fromRGB(190, 168, 148),
        CardBG = Color3.fromRGB(31, 22, 18),
        ButtonBG = Color3.fromRGB(198, 156, 109),
    },
    Dracula = {
        Name = "Dracula",
        MainBG = Color3.fromRGB(40, 42, 54),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(33, 34, 44),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(33, 34, 44),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(33, 34, 44),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(33, 34, 44),
            Color3.fromRGB(50, 52, 68),
            Color3.fromRGB(25, 26, 34)
        },
        MinGradient = {
            Color3.fromRGB(189, 147, 249),
            Color3.fromRGB(255, 121, 198),
            Color3.fromRGB(139, 233, 253)
        },
        Divider = Color3.fromRGB(98, 114, 164),
        Text = Color3.fromRGB(248, 248, 242),
        SubText = Color3.fromRGB(150, 160, 195),
        CardBG = Color3.fromRGB(30, 31, 41),
        ButtonBG = Color3.fromRGB(189, 147, 249),
    },
    Rose = {
        Name = "Rose",
        MainBG = Color3.fromRGB(35, 24, 30),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(48, 30, 40),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(48, 30, 40),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(48, 30, 40),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(48, 30, 40),
            Color3.fromRGB(68, 42, 58),
            Color3.fromRGB(28, 18, 24)
        },
        MinGradient = {
            Color3.fromRGB(235, 111, 146),
            Color3.fromRGB(246, 193, 119),
            Color3.fromRGB(196, 167, 231)
        },
        Divider = Color3.fromRGB(110, 60, 80),
        Text = Color3.fromRGB(250, 240, 245),
        SubText = Color3.fromRGB(200, 170, 185),
        CardBG = Color3.fromRGB(26, 18, 22),
        ButtonBG = Color3.fromRGB(235, 111, 146),
    },
    Mint = {
        Name = "Mint",
        MainBG = Color3.fromRGB(14, 42, 38),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(18, 55, 49),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(18, 55, 49),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(18, 55, 49),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(18, 55, 49),
            Color3.fromRGB(28, 80, 72),
            Color3.fromRGB(12, 36, 32)
        },
        MinGradient = {
            Color3.fromRGB(94, 234, 180),
            Color3.fromRGB(160, 245, 215),
            Color3.fromRGB(52, 190, 145)
        },
        Divider = Color3.fromRGB(45, 140, 115),
        Text = Color3.fromRGB(236, 253, 247),
        SubText = Color3.fromRGB(160, 215, 198),
        CardBG = Color3.fromRGB(10, 31, 28),
        ButtonBG = Color3.fromRGB(94, 234, 180),
    },
    Amethyst = {
        Name = "Amethyst",
        MainBG = Color3.fromRGB(45, 18, 75),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(68, 22, 105),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(68, 22, 105),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(68, 22, 105),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(68, 22, 105),
            Color3.fromRGB(100, 30, 160),
            Color3.fromRGB(50, 15, 80)
        },
        MinGradient = {
            Color3.fromRGB(168, 85, 247),
            Color3.fromRGB(216, 180, 254),
            Color3.fromRGB(147, 51, 234)
        },
        Divider = Color3.fromRGB(126, 34, 206),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(225, 200, 245),
        CardBG = Color3.fromRGB(32, 12, 55),
        ButtonBG = Color3.fromRGB(168, 85, 247),
    },
    Original = {
        Name = "Blue",
        MainBG = Color3.fromRGB(10, 55, 110),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(18, 85, 165),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(18, 85, 165),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(18, 85, 165),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(15, 90, 180),
            Color3.fromRGB(40, 140, 230),
            Color3.fromRGB(20, 110, 200)
        },
        MinGradient = {
            Color3.fromRGB(30, 140, 255),
            Color3.fromRGB(100, 190, 255),
            Color3.fromRGB(40, 155, 255)
        },
        Divider = Color3.fromRGB(45, 130, 220),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 225, 255),
        CardBG = Color3.fromRGB(8, 45, 95),
        ButtonBG = Color3.fromRGB(40, 140, 240),
    },
    Nature = {
        Name = "Green",
        MainBG = Color3.fromRGB(15, 60, 32),
        MainTrans = 0.12,
        AccentBG = Color3.fromRGB(20, 83, 45),
        AccentTrans = 0.12,
        TopBG = Color3.fromRGB(20, 83, 45),
        TopTrans = 0.12,
        BottomBG = Color3.fromRGB(20, 83, 45),
        BottomTrans = 0.12,
        BottomGradient = {
            Color3.fromRGB(20, 83, 45),
            Color3.fromRGB(34, 139, 74),
            Color3.fromRGB(15, 60, 32)
        },
        MinGradient = {
            Color3.fromRGB(34, 197, 94),
            Color3.fromRGB(134, 239, 172),
            Color3.fromRGB(22, 163, 74)
        },
        Divider = Color3.fromRGB(34, 139, 74),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 240, 215),
        CardBG = Color3.fromRGB(10, 45, 24),
        ButtonBG = Color3.fromRGB(46, 204, 113),
    }
}
Library.ThemePresets.Blue = Library.ThemePresets.Original
Library.ThemePresets.Green = Library.ThemePresets.Nature

local function ApplyCornerRadii(uiCorner, topLeft, topRight, bottomLeft, bottomRight)
    pcall(function()
        uiCorner.TopLeftRadius = UDim.new(0, topLeft)
        uiCorner.TopRightRadius = UDim.new(0, topRight)
        uiCorner.BottomLeftRadius = UDim.new(0, bottomLeft)
        uiCorner.BottomRightRadius = UDim.new(0, bottomRight)
    end)
end

Library.ShadowsEnabled = true
Library.ShadowIntensity = 1 / 1.8
Library.Shadows = {} -- maps shadow instance to original transparency

local function AddUIShadow(parentFrame, blurRadius, transparency, color)
    blurRadius = blurRadius or 20
    transparency = transparency or 0.5
    if typeof(color) ~= "Color3" then
        color = Color3.fromRGB(0, 0, 0)
    end

    local intensity = Library.ShadowIntensity or (1 / 1.8)
    local isSuppressed = false
    if parentFrame and parentFrame:IsA("GuiObject") then
        if parentFrame.BackgroundTransparency >= 0.99 then
            isSuppressed = true
        elseif IsInsideSection(parentFrame) and (Library.SectionsTransparent or (Library.CurrentWindow and Library.CurrentWindow.SectionsTransparent)) then
            isSuppressed = true
        end
    end
    local shouldShow = (Library.ShadowsEnabled and intensity > 0) and not isSuppressed
    local baseOpacity = 1 - transparency
    local curOpacity = math.clamp(baseOpacity * intensity, 0, 1)
    local curTrans = 1 - curOpacity

    local shadowNode = Instance.new("UIShadow")
    shadowNode.Name = GenerateSafeName("UIShadow")
    shadowNode.BlurRadius = UDim.new(0, blurRadius)
    shadowNode.Color = color
    shadowNode.Transparency = shouldShow and curTrans or 1
    shadowNode.ShowBehindParent = true
    pcall(function() shadowNode.Enabled = shouldShow end)
    pcall(function() shadowNode.Visible = shouldShow end)
    shadowNode.Parent = parentFrame

    Library.Shadows[shadowNode] = transparency
    return shadowNode
end

Library.ApplyCornerRadii = ApplyCornerRadii
Library.AddUIShadow = AddUIShadow
Library.ActiveWindows = {}

local function GetThemedDarkColor(theme)
    theme = theme or Library.CurrentTheme or (Library.ThemePresets and Library.ThemePresets.Dark)
    local cardBG = (theme and theme.CardBG) or Color3.fromRGB(30, 32, 40)
    local buttonBG = (theme and theme.ButtonBG) or Color3.fromRGB(155, 160, 172)
    local h, s, v = Color3.toHSV(cardBG)
    if v > 0.82 and s < 0.2 then
        return Color3.fromRGB(220, 225, 235)
    end
    if s < 0.15 and buttonBG then
        local bh, bs, bv = Color3.toHSV(buttonBG)
        return Color3.fromHSV(bh, math.clamp(bs * 0.45, 0.12, 0.55), math.clamp(bv * 0.20, 0.08, 0.18))
    end
    return Color3.fromHSV(h, math.clamp(s * 1.05, 0.15, 0.9), math.clamp(v * 0.45, 0.08, 0.22))
end

Library.GetThemedDarkColor = GetThemedDarkColor

local function GetOnAccent(bg)
    if typeof(bg) ~= "Color3" then return Color3.fromRGB(255, 255, 255) end
    local lum = 0.299 * bg.R + 0.587 * bg.G + 0.114 * bg.B
    return lum > 0.6 and Color3.fromRGB(20, 22, 28) or Color3.fromRGB(255, 255, 255)
end

Library.GetOnAccent = GetOnAccent

local function ResolveImage(v)
    if not v or v == "" then return nil end
    local s = tostring(v)
    if s:find("://") then return s end
    return Library:GetIcon(s)
end
Library.ResolveImage = ResolveImage

local function CreateMDImage(parent, p, theme)
    p = p or {}
    local curTheme = theme or Library.CurrentTheme or (Library.ThemePresets and Library.ThemePresets.Dark)
    local holder = Instance.new("Frame")
    holder.Size = p.Size or UDim2.new(1, 0, 1, 0)
    holder.Position = p.Position or UDim2.new()
    holder.BackgroundColor3 = GetThemedDarkColor(curTheme)
    holder.BackgroundTransparency = p.BackgroundTransparency or 0.35
    holder.BorderSizePixel = 0
    holder.ClipsDescendants = true
    holder.ZIndex = p.ZIndex or 12
    holder.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, p.CornerRadius or 8)
    c.Parent = holder

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.ScaleType = p.ScaleType or Enum.ScaleType.Crop
    img.ImageTransparency = 1
    img.ZIndex = holder.ZIndex + 1
    img.Parent = holder

    local src = ResolveImage(p.Image)
    if src then
        img.Image = src
        task.spawn(function()
            local t0 = os.clock()
            while img.Parent and not img.IsLoaded and os.clock() - t0 < 5 do
                task.wait(0.05)
            end
            if img.Parent then
                TweenService:Create(img, TweenInfo.new(0.25), {ImageTransparency = 0}):Play()
            end
        end)
    else
        img.Image = Library:GetIcon("image") or ""
        img.ScaleType = Enum.ScaleType.Fit
        img.Size = UDim2.new(0.5, 0, 0.5, 0)
        img.Position = UDim2.new(0.25, 0, 0.25, 0)
        img.ImageTransparency = 0.5
        img.ImageColor3 = (curTheme and curTheme.SubText) or Color3.fromRGB(150, 150, 165)
    end
    return holder, img
end
Library.CreateMDImage = CreateMDImage

function Library:RegisterTheme(name, data)
    if type(name) ~= "string" or type(data) ~= "table" then return end
    local defaultTheme = Library.ThemePresets.Dark
    local newTheme = {
        Name = data.Name or name,
        MainBG = data.MainBG or defaultTheme.MainBG,
        MainTrans = data.MainTrans or defaultTheme.MainTrans,
        AccentBG = data.AccentBG or defaultTheme.AccentBG,
        AccentTrans = data.AccentTrans or defaultTheme.AccentTrans,
        TopBG = data.TopBG or defaultTheme.TopBG,
        TopTrans = data.TopTrans or defaultTheme.TopTrans,
        BottomBG = data.BottomBG or defaultTheme.BottomBG,
        BottomTrans = data.BottomTrans or defaultTheme.BottomTrans,
        CardBG = data.CardBG or defaultTheme.CardBG,
        ButtonBG = data.ButtonBG or defaultTheme.ButtonBG,
        Text = data.Text or defaultTheme.Text,
        SubText = data.SubText or defaultTheme.SubText,
        Divider = data.Divider or defaultTheme.Divider,
        BottomGradient = data.BottomGradient or defaultTheme.BottomGradient,
        MinGradient = data.MinGradient or defaultTheme.MinGradient
    }
    Library.ThemePresets[name] = newTheme

    for _, win in ipairs(Library.ActiveWindows or {}) do
        if win and win.CreateThemeSwatch then
            pcall(function() win:CreateThemeSwatch(name, newTheme) end)
        elseif win and win.ThemeContainer and win.ThemePresetBtnMap and not win.ThemePresetBtnMap[name] then
            local btnData = win:CreateMDButtonLong(win.ThemeContainer, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), newTheme.Name, function()
                win:ApplyTheme(name)
            end)
            win.ThemePresetBtnMap[name] = btnData
            if win.SettingsTab and win.SettingsTab.ContentFrame and win.SettingsTab.Layout then
                win.SettingsTab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, win.SettingsTab.Layout.AbsoluteContentSize.Y + 20)
            end
        end
    end
    return newTheme
end
Library.RegisterTheme = Library.RegisterTheme

function Library:CreateWindow(arg1, arg2, arg3, arg4, arg5)
    Library.ShadowsEnabled = true
    local hubTitle, scriptName, authorText, discordLink, iconAsset
    local playerProfileEnabled = false
    local showDiscord = true
    local streamerMode = false

    local function GenerateMaskedUsername()
        return string.rep("*", math.random(7, 13))
    end
    local maskedUsername = GenerateMaskedUsername()

    if type(arg1) == "table" then
        hubTitle = arg1.Title or arg1.HubTitle or arg1.Name or arg1.hubTitle or arg1.ScriptName or "script name"
        scriptName = arg1.ScriptName or arg1.scriptName or hubTitle or "script name"
        authorText = arg1.Author or arg1.AuthorText or arg1.MadeBy or arg1.madeBy or arg1.Creator
        if arg1.Discord == false or arg1.ShowDiscord == false or arg1.DiscordLink == false or arg1.DiscordEnabled == false or arg1.Discord == "" then
            showDiscord = false
            discordLink = ""
        else
            discordLink = arg1.Discord or arg1.DiscordLink or arg1.DiscordServer or arg1.discord or arg1.Invite
        end
        iconAsset = arg1.Icon or arg1.IconAsset or arg1.Logo or arg1.IconId or arg1.icon
        playerProfileEnabled = (arg1.PlayerProfile == true or arg1.ShowPlayerProfile == true or arg1.UserAvatar == true or arg1.ShowUserAvatar == true or arg1.PlayerAvatar == true or arg1.UserInfo == true)
        streamerMode = (arg1.StreamerMode == true or arg1.Streamer == true)
    else
        hubTitle = arg1 or "script name"
        scriptName = arg2 or hubTitle or "script name"
        authorText = arg3
        if arg4 == false or arg4 == "" then
            showDiscord = false
            discordLink = ""
        else
            discordLink = arg4
        end
        iconAsset = arg5
    end

    if not authorText or authorText == "" then
        authorText = "Made by MorningDrift"
    elseif not authorText:lower():find("^made by") then
        authorText = "Made by " .. authorText
    end

    if showDiscord and (not discordLink or discordLink == "") then
        discordLink = "discord.gg/48jdqB8rAw"
    end

    local discordDisplay = (discordLink and tostring(discordLink):gsub("^https?://", "")) or ""
    local discordCopyUrl = (discordLink and discordLink ~= "") and (discordLink:find("^https?://") and discordLink or ("https://" .. discordDisplay)) or ""

    if not iconAsset or iconAsset == "" then
        iconAsset = "rbxassetid://78209859871518"
    elseif type(iconAsset) == "number" or tostring(iconAsset):match("^%d+$") then
        iconAsset = "rbxassetid://" .. tostring(iconAsset)
    end

    local minimizedIcon = (type(arg1) == "table" and (arg1.MinimizedIcon or arg1.MinimisedIcon or arg1.MiniIcon)) or iconAsset
    if not minimizedIcon or minimizedIcon == "" then
        minimizedIcon = "rbxassetid://78209859871518"
    elseif type(minimizedIcon) == "number" or tostring(minimizedIcon):match("^%d+$") then
        minimizedIcon = "rbxassetid://" .. tostring(minimizedIcon)
    end
    local autoSmallDividers = type(arg1) == "table" and (arg1.AutoSmallDividers == true or arg1.AutoDividers == true)

    local creditsConfig = {
        Enabled = true,
        Title = "Credits",
        Creator = "@wavhx / @morningdrift",
        Discord = discordLink or "discord.gg/48jdqB8rAw",
        DiscordLabel = "Discord server if you have any questions"
    }

    if type(arg1) == "table" then
        if arg1.Credits ~= nil then
            if type(arg1.Credits) == "boolean" then
                creditsConfig.Enabled = arg1.Credits
            elseif type(arg1.Credits) == "table" then
                if arg1.Credits.Enabled ~= nil then creditsConfig.Enabled = (arg1.Credits.Enabled == true) end
                if arg1.Credits.Show ~= nil then creditsConfig.Enabled = (arg1.Credits.Show == true) end
                if arg1.Credits.Visible ~= nil then creditsConfig.Enabled = (arg1.Credits.Visible == true) end
                if arg1.Credits.Title then creditsConfig.Title = tostring(arg1.Credits.Title) end
                if arg1.Credits.Creator then creditsConfig.Creator = tostring(arg1.Credits.Creator) end
                if arg1.Credits.Developer then creditsConfig.Creator = tostring(arg1.Credits.Developer) end
                if arg1.Credits.Discord then creditsConfig.Discord = tostring(arg1.Credits.Discord) end
                if arg1.Credits.DiscordLabel then creditsConfig.DiscordLabel = tostring(arg1.Credits.DiscordLabel) end
                if arg1.Credits.DiscordText then creditsConfig.DiscordLabel = tostring(arg1.Credits.DiscordText) end
            end
        elseif arg1.ShowCredits ~= nil then
            creditsConfig.Enabled = (arg1.ShowCredits == true)
        end
    end

    local languagesList = nil
    local currentLang = "English"
    local languageSelectorEnabled = false
    local translationsDict = {}

    if type(arg1) == "table" then
        if arg1.Languages and type(arg1.Languages) == "table" then
            languagesList = arg1.Languages
            languageSelectorEnabled = (arg1.LanguageSelector ~= false)
        elseif arg1.LanguageSelector == true or arg1.LanguageToggle == true then
            languageSelectorEnabled = true
            languagesList = { "English", "Russian" }
        end

        if arg1.Language or arg1.DefaultLanguage or arg1.CurrentLanguage then
            currentLang = tostring(arg1.Language or arg1.DefaultLanguage or arg1.CurrentLanguage)
        elseif languagesList and #languagesList > 0 then
            currentLang = languagesList[1]
        end

        if arg1.Translations and type(arg1.Translations) == "table" then
            translationsDict = arg1.Translations
        end
    end

    if Library.ActiveGuis then
        for _, gui in ipairs(Library.ActiveGuis) do
            pcall(function()
                if gui and gui.Parent then gui:Destroy() end
            end)
        end
    end
    Library.ActiveGuis = {}

    local Window = {
        ScriptName = scriptName or hubTitle or "script name",
        ScriptNameFont = (type(arg1) == "table" and (arg1.ScriptNameFont or arg1.TitleFont or arg1.HeaderFont or arg1.Font)) or Library.ScriptNameFont or FontScriptNameDefault,
        FontTitle = FontTitle,
        FontTabBtn = FontTabBtn,
        FontRegular = FontRegular,
        FontLight = FontLight,
        CreditsConfig = creditsConfig,
        Languages = languagesList,
        CurrentLanguage = currentLang,
        LanguageSelectorEnabled = languageSelectorEnabled,
        Translations = translationsDict,
        RegisteredLocalizedElements = {},
        LanguageChangedCallbacks = {},
        ElementsTransparency = 0.33,
        TopBottomTransparency = 0.12,
        GetIcon = Library.GetIcon,
        AuthorText = authorText,
        DiscordLink = discordLink,
        ShowDiscord = showDiscord,
        PlayerProfileEnabled = playerProfileEnabled,
        StreamerMode = streamerMode,
        MaskedUsername = maskedUsername,
        WelcomeUpdateCallbacks = {},
        IconAsset = iconAsset,
        Icons = Library.Icons,
        MinimizedIcon = minimizedIcon,
        AutoSmallDividers = autoSmallDividers,
        CurrentTheme = Library.ThemePresets.Dark,
        CurrentThemeKey = "Dark",
        NotificationsEnabled = true,
        UISoundsEnabled = true,
        SoundVolume = 0.8,
        HoverSoundId = "88894490577328",
        ClickSoundId = "86313632275410",
        NotifSoundId = "97455084935031",
        ShadowIntensity = 1 / 1.8,
        BackgroundBlurEnabled = true,
        SpiderwebBGEnabled = false,
        CustomThemeColor = nil,
        CustomBGTransparency = 0.12,
        ShadowsEnabled = true,
        SectionsTransparent = false,
        ClickEffectsEnabled = true,
        ClickParticleType = "Theme default",
        CustomParticleAsset = "",
        NoiseEnabled = false,
        NoiseType = "Texture",
        NoiseSize = 128,
        NoiseTransparency = 0.88,
        Connections = {},
        ActiveNotifications = {},
        IconAsset = iconAsset,
        iconAsset = iconAsset,
        ApplyCornerRadii = ApplyCornerRadii,
        AddUIShadow = AddUIShadow,
        FontTitle = FontTitle,
        FontRegular = FontRegular,
        SidebarDividers = {},
        RegisteredMDButtons = {},
        RegisteredMDToggles = {},
        RegisteredMDSliders = {},
        RegisteredMobileButtons = {},
        RegisteredSections = {},
        RegisteredLabels = {},
        RegisteredDividers = {},
        MobileButtonsLocked = false,
        MobileButtonsLayout = {
            BaseOffsetX = 70,
            BaseOffsetY = 70,
            SpacingY = 56,
            SpacingX = 64,
            MaxButtonsPerColumn = 6
        },
        RegisteredToggles = {},
        RegisteredSliders = {},
        RegisteredTextboxes = {},
        RegisteredTextboxesList = {},
        RegisteredDropdowns = {},
        RegisteredDropdownsList = {},
        RegisteredNumberInputs = {},
        RegisteredNumberInputsList = {},
        RegisteredMultiDropdowns = {},
        RegisteredMultiDropdownsList = {},
        RegisteredColorPickers = {},
        RegisteredColorPickersList = {},
        RegisteredKeybindBadges = {},
        RegisteredCustom = {},
        ConfigLoadedCallbacks = {},
        ConfigSavedCallbacks = {},
        SidebarCollapsed = false,
        SidebarWidth = 175,
        CollapsedSidebarWidth = 56,
        KeybindMap = {},
        SearchableItems = {},
        ThemePresetBtnMap = {},
        Tabs = {},
        ActiveTab = nil
    }
    table.insert(Library.ActiveWindows, Window)

    -- Load split modules (config, credits, localization, notifications, mobile, theme)
    pcall(function()
        local _loaderSrc = game:HttpGet(
            "https://raw.githubusercontent.com/rilorfakesilly/scripts/refs/heads/main/modules/loader.lua"
        )
        local _loaderFn = loadstring(_loaderSrc)
        if _loaderFn then
            local _loader = _loaderFn()
            if _loader then _loader(Library, Window) end
        end
    end)


    function Window:OnConfigLoaded(fn)
        if type(fn) == "function" then
            table.insert(Window.ConfigLoadedCallbacks, fn)
        end
    end

    function Window:OnConfigSaved(fn)
        if type(fn) == "function" then
            table.insert(Window.ConfigSavedCallbacks, fn)
        end
    end

    function Window:RegisterTheme(name, data)
        return Library:RegisterTheme(name, data)
    end

    function Window:GetSettingsTab()
        return Window.SettingsTab
    end

    local ScriptUi = nil
    local MinimisedUI = nil
    local NotificationUI = nil
    local MainContainer = nil
    local MainContentFrame = nil
    local UIScaleConstraint = nil
    local GetTargetViewportScale = nil

    -- Responsive scaling: everything is designed for a 1920x1080 reference (1x) screen
    -- and grows/shrinks with the real viewport. Library.UIScaleMultiplier is a user tweak.
    local UI_REF_W, UI_REF_H = 1920, 1080
    local UI_BASE_WIN_W, UI_BASE_WIN_H = 760, 470
    local HUD_UIScales = {}

    local function GetViewportSizeSafe()
        local cam = workspace.CurrentCamera or Camera
        local vp = cam and cam.ViewportSize
        if not vp or vp.X <= 0 or vp.Y <= 0 then return Vector2.new(UI_REF_W, UI_REF_H) end
        return vp
    end

    -- scale for small floating pieces (notifications, minimized icon, mobile buttons, loader)
    local function GetHUDScale()
        local vp = GetViewportSizeSafe()
        local s = math.min(vp.X / UI_REF_W, vp.Y / UI_REF_H) * (Library.UIScaleMultiplier or 1)
        return math.clamp(s, 0.7, 2.5)
    end

    local function RegisterHUDScale(guiObject)
        local sc = Instance.new("UIScale")
        sc.Name = "HUDScale"
        sc.Scale = GetHUDScale()
        sc.Parent = guiObject
        table.insert(HUD_UIScales, sc)
        return sc
    end
    Window.RegisterHUDScale = RegisterHUDScale
    Library.RegisterHUDScale = RegisterHUDScale
    Window.GetHUDScale = GetHUDScale
    Library.GetHUDScale = GetHUDScale

    local function RefreshHUDScales()
        local s = GetHUDScale()
        for i = #HUD_UIScales, 1, -1 do
            local sc = HUD_UIScales[i]
            if sc and sc.Parent then sc.Scale = s else table.remove(HUD_UIScales, i) end
        end
    end
    local AttachUniversalDrag = nil

    local function TrackConn(conn)
        if conn then
            table.insert(Window.Connections, conn)
        end
        return conn
    end

    -- Audio SFX controller
    local SoundFolder = Instance.new("Folder")
    SoundFolder.Name = GenerateSafeName("Sounds")
    SoundFolder.Parent = ParentGui

    local function FormatSoundId(id)
        if not id or id == "" then return "" end
        local str = tostring(id):gsub("%s+", "")
        if str:find("://") then return str end
        local num = str:match("%d+")
        if num then return "rbxassetid://" .. num end
        return str
    end

    local HoverSoundTemplate = Instance.new("Sound")
    HoverSoundTemplate.Name = GenerateSafeName("HoverSound")
    HoverSoundTemplate.SoundId = FormatSoundId(Window.HoverSoundId or "88894490577328")
    HoverSoundTemplate.Volume = 0.4
    HoverSoundTemplate.Parent = SoundFolder

    local ClickSoundTemplate = Instance.new("Sound")
    ClickSoundTemplate.Name = GenerateSafeName("ClickSound")
    ClickSoundTemplate.SoundId = FormatSoundId(Window.ClickSoundId or "86313632275410")
    ClickSoundTemplate.Volume = 0.5
    ClickSoundTemplate.Parent = SoundFolder

    local NotifSoundTemplate = Instance.new("Sound")
    NotifSoundTemplate.Name = GenerateSafeName("NotifSound")
    NotifSoundTemplate.SoundId = FormatSoundId(Window.NotifSoundId or "97455084935031")
    NotifSoundTemplate.Volume = 0.5
    NotifSoundTemplate.Parent = SoundFolder

    local function PlayHoverSFX()
        if not Window or not Window.UISoundsEnabled then return end
        pcall(function()
            local vol = (Window.SoundVolume ~= nil) and Window.SoundVolume or 0.8
            local snd = HoverSoundTemplate:Clone()
            snd.Volume = 0.35 * vol
            snd.Parent = SoundFolder
            snd:Play()
            Debris:AddItem(snd, 1.5)
        end)
    end

    local function PlayClickSFX()
        if not Window or not Window.UISoundsEnabled then return end
        pcall(function()
            local vol = (Window.SoundVolume ~= nil) and Window.SoundVolume or 0.8
            local snd = ClickSoundTemplate:Clone()
            snd.Volume = 0.45 * vol
            snd.Parent = SoundFolder
            snd:Play()
            Debris:AddItem(snd, 1.5)
        end)
    end

    local function PlayNotifSFX()
        if not Window or not Window.UISoundsEnabled then return end
        pcall(function()
            local vol = (Window.SoundVolume ~= nil) and Window.SoundVolume or 0.8
            local snd = NotifSoundTemplate:Clone()
            snd.Volume = 0.5 * vol
            snd.Parent = SoundFolder
            snd:Play()
            Debris:AddItem(snd, 2.0)
        end)
    end

    Window.TrackConn = TrackConn
    Window.PlayHoverSFX = PlayHoverSFX
    Window.PlayClickSFX = PlayClickSFX
    Window.PlayNotifSFX = PlayNotifSFX

    Window._I = Window._I or {}
    Window._I.GenerateSafeName = GenerateSafeName
    Window._I.FontFingerPaintRegular = FontFingerPaintRegular or FontRegular
    Window._I.FontTitle = FontTitle
    Window._I.FontRegular = FontRegular
    Window._I.ApplyCornerRadii = ApplyCornerRadii
    Window._I.AddUIShadow = AddUIShadow
    Window._I.RegisterHUDScale = RegisterHUDScale
    Window._I.GetHUDScale = GetHUDScale
    Window._I.TrackConn = TrackConn
    Window._I.PlayHoverSFX = PlayHoverSFX
    Window._I.PlayClickSFX = PlayClickSFX
    Window._I.PlayNotifSFX = PlayNotifSFX

    function Window:SetHoverSound(id)
        local formatted = FormatSoundId(id)
        if formatted and formatted ~= "" then
            Window.HoverSoundId = formatted
            if HoverSoundTemplate then HoverSoundTemplate.SoundId = formatted end
        end
    end

    function Window:SetClickSound(id)
        local formatted = FormatSoundId(id)
        if formatted and formatted ~= "" then
            Window.ClickSoundId = formatted
            if ClickSoundTemplate then ClickSoundTemplate.SoundId = formatted end
        end
    end

    function Window:SetNotificationSound(id)
        local formatted = FormatSoundId(id)
        if formatted and formatted ~= "" then
            Window.NotifSoundId = formatted
            if NotifSoundTemplate then NotifSoundTemplate.SoundId = formatted end
        end
    end

    -- Control registries and config persistence


    function Window:CreateMDTextbox(parent, position, size, title, placeholder, defaultText, onSubmit, boxOptions)
        parent = ResolveParent(parent)
        size = size or UDim2.new(1, -10, 0, 50)
        position = position or UDim2.new(0, 0, 0, 0)

        local isNarrow = (size and size.X.Scale and size.X.Scale <= 0.55) or (type(boxOptions) == "table" and (boxOptions.Narrow or boxOptions.SizeFraction and boxOptions.SizeFraction <= 0.55))
        local boxWidth = isNarrow and 95 or 150
        local titleWidth = nil
        if type(boxOptions) == "table" then
            boxWidth = boxOptions.BoxWidth or boxOptions.InputWidth or boxOptions.boxWidth or boxWidth
            titleWidth = boxOptions.TitleWidth or boxOptions.titleWidth
        elseif type(boxOptions) == "number" then
            boxWidth = boxOptions
        end

        local inSection = IsInsideSection(parent)
        local BoxFrame = Instance.new("Frame")
        BoxFrame.Name = GenerateSafeName("TextboxFrame")
        BoxFrame:SetAttribute("MDCard", true)
        BoxFrame.Size = size
        BoxFrame.Position = position
        BoxFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        BoxFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
        BoxFrame.BorderSizePixel = 0
        BoxFrame.ZIndex = 10
        BoxFrame.Parent = parent

        local connectMode = type(boxOptions) == "table" and (boxOptions.Connect or boxOptions.Connected or boxOptions.connectMode or boxOptions.PositionInGroup)
        local Corner = Instance.new("UICorner")
        if connectMode == "Top" or connectMode == "First" then
            ApplyCornerRadii(Corner, 12, 12, 0, 0)
        elseif connectMode == "Middle" then
            ApplyCornerRadii(Corner, 0, 0, 0, 0)
        elseif connectMode == "Bottom" or connectMode == "Last" then
            ApplyCornerRadii(Corner, 0, 0, 12, 12)
        elseif connectMode == "Left" then
            ApplyCornerRadii(Corner, 12, 0, 0, 12)
        elseif connectMode == "Right" then
            ApplyCornerRadii(Corner, 0, 12, 12, 0)
        else
            Corner.CornerRadius = UDim.new(0, 12)
        end
        Corner.Parent = BoxFrame

        if not connectMode then
            local shadow = AddUIShadow(BoxFrame, 20, 0.5)
            if inSection and Window.SectionsTransparent and shadow then
                pcall(function() shadow.Visible = false end)
            end
        end

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = GenerateSafeName("TitleLabel")
        TitleLabel.Size = titleWidth and UDim2.new(0, titleWidth, 1, 0) or (isNarrow and UDim2.new(0.48, -10, 1, 0) or UDim2.new(1, -(boxWidth + 22), 1, 0))
        TitleLabel.Position = UDim2.new(0, 12, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.FontFace = FontFingerPaintBold
        TitleLabel.Text = title or "Input"
        TitleLabel.TextColor3 = Window.CurrentTheme.Text
        TitleLabel.TextSize = isNarrow and 11 or 12
        TitleLabel.TextWrapped = true
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
        TitleLabel.ZIndex = 11
        TitleLabel.Parent = BoxFrame

        local InputBox = Instance.new("TextBox")
        InputBox.Name = GenerateSafeName("InputBox")
        InputBox.AnchorPoint = Vector2.new(1, 0.5)
        InputBox.Size = isNarrow and UDim2.new(0.52, -8, 0, 26) or ((size and size.Y.Offset <= 44) and UDim2.new(0, boxWidth, 0, 26) or UDim2.new(0, boxWidth, 0, 28))
        InputBox.Position = UDim2.new(1, -10, 0.5, 0)
        InputBox.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
        InputBox.BackgroundTransparency = 0.2
        InputBox.BorderSizePixel = 0
        InputBox.FontFace = FontFingerPaintRegular
        InputBox.PlaceholderText = placeholder or "Type here..."
        InputBox.PlaceholderColor3 = Window.CurrentTheme.SubText
        InputBox.Text = defaultText or ""
        InputBox.TextColor3 = Window.CurrentTheme.Text
        InputBox.TextSize = 12
        InputBox.TextWrapped = true
        InputBox.ClipsDescendants = true
        InputBox.ClearTextOnFocus = false
        InputBox.ZIndex = 12
        InputBox.Parent = BoxFrame

        local function UpdateTextboxResponsiveLayout()
            local totalW = BoxFrame.AbsoluteSize.X
            if totalW <= 0 then
                totalW = (size and size.X.Offset > 0) and size.X.Offset or 280
            end
            if totalW < 260 then
                InputBox.Size = UDim2.new(0.48, -10, 0, 26)
                TitleLabel.Size = UDim2.new(0.52, -14, 1, 0)
                TitleLabel.TextSize = 11
            elseif totalW < 360 then
                local bw = math.clamp(math.floor(totalW * 0.40), 85, 125)
                InputBox.Size = UDim2.new(0, bw, 0, 26)
                TitleLabel.Size = UDim2.new(1, -(bw + 22), 1, 0)
                TitleLabel.TextSize = 12
            else
                local bw = math.clamp(boxWidth, 95, 150)
                InputBox.Size = UDim2.new(0, bw, 0, 28)
                TitleLabel.Size = UDim2.new(1, -(bw + 24), 1, 0)
                TitleLabel.TextSize = 12
            end
        end

        TrackConn(BoxFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateTextboxResponsiveLayout))
        task.defer(UpdateTextboxResponsiveLayout)

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 8)
        InputCorner.Parent = InputBox

        local InputStroke = Instance.new("UIStroke")
        InputStroke.Thickness = 1
        InputStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(60, 65, 80)
        InputStroke.Transparency = 0.5
        InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        InputStroke.Parent = InputBox

        TrackConn(InputBox.Focused:Connect(function()
            TweenService:Create(InputStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Color = Window.CurrentTheme.ButtonBG,
                Transparency = 0,
                Thickness = 1.5
            }):Play()
        end))

        TrackConn(BoxFrame.MouseEnter:Connect(function()
            local inSec = IsInsideSection(BoxFrame)
            if not (inSec and Window.SectionsTransparent) then
                TweenService:Create(BoxFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = math.max(0, (Window.ElementsTransparency or 0.33) - 0.12)
                }):Play()
            end
        end))

        TrackConn(BoxFrame.MouseLeave:Connect(function()
            local inSec = IsInsideSection(BoxFrame)
            if not (inSec and Window.SectionsTransparent) then
                TweenService:Create(BoxFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                }):Play()
            end
        end))

        local boxObj = {
            Frame = BoxFrame,
            TitleLabel = TitleLabel,
            InputBox = InputBox,
            InputStroke = InputStroke,
            GetText = function() return InputBox.Text end,
            SetText = function(txt, triggerCallback)
                InputBox.Text = txt or ""
                if triggerCallback and onSubmit then onSubmit(InputBox.Text) end
            end,
            SetBoxWidth = function(newWidth)
                boxWidth = newWidth or boxWidth
                InputBox.Size = UDim2.new(0, boxWidth, 0, 30)
                if not titleWidth then
                    TitleLabel.Size = UDim2.new(1, -(boxWidth + 24), 1, 0)
                end
            end,
            RefreshTheme = function(theme)
                local inSec = IsInsideSection(BoxFrame)
                BoxFrame.BackgroundColor3 = theme.CardBG
                BoxFrame.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                TitleLabel.TextColor3 = theme.Text
                InputBox.TextColor3 = theme.Text
                InputBox.PlaceholderColor3 = theme.SubText
                InputBox.BackgroundColor3 = GetThemedDarkColor(theme)
                if InputStroke then
                    InputStroke.Color = theme.Divider or Color3.fromRGB(60, 65, 80)
                end
            end
        }

        boxObj.WithCallback = function(self, cb)
            onSubmit = cb
            return self
        end
        boxObj.WithTooltip = function(self, tt)
            if Window.AttachTooltip and BoxFrame then
                Window:AttachTooltip(BoxFrame, tt)
            end
            return self
        end
        boxObj.WithSaveKey = function(self, key)
            if key and key ~= "" then
                self.SaveKey = key
                Window.RegisteredTextboxes[key] = self
            end
            return self
        end
        boxObj.WithText = function(self, txt)
            self.SetText(txt)
            return self
        end
        boxObj.WithPlaceholder = function(self, ph)
            if InputBox then InputBox.PlaceholderText = ph end
            return self
        end

        TrackConn(InputBox.FocusLost:Connect(function(enterPressed)
            PlayClickSFX()
            TweenService:Create(InputStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Color = Window.CurrentTheme.Divider or Color3.fromRGB(60, 65, 80),
                Transparency = 0.5,
                Thickness = 1
            }):Play()
            if onSubmit then onSubmit(InputBox.Text, enterPressed) end
        end))

        local boxName = (boxOptions and type(boxOptions) == "table" and (boxOptions.SaveKey or boxOptions.saveKey or boxOptions.Identifier or boxOptions.identifier or boxOptions.Id or boxOptions.id)) or (title and title ~= "" and title) or ("Textbox_" .. (#Window.RegisteredTextboxesList + 1))
        boxObj.Name = boxName
        boxObj.SaveKey = boxName
        Window.RegisteredTextboxes[boxName] = boxObj
        if title and title ~= "" and not Window.RegisteredTextboxes[title] then
            Window.RegisteredTextboxes[title] = boxObj
        end
        if boxOptions and type(boxOptions) == "table" then
            local altId = boxOptions.Id or boxOptions.id or boxOptions.Identifier or boxOptions.identifier or boxOptions.SaveKey or boxOptions.saveKey
            if altId and not Window.RegisteredTextboxes[altId] then
                Window.RegisteredTextboxes[altId] = boxObj
            end
        end
        table.insert(Window.RegisteredTextboxesList, boxObj)

        if boxOptions and type(boxOptions) == "table" and (boxOptions.Tooltip or boxOptions.tooltip) then
            boxObj:WithTooltip(boxOptions.Tooltip or boxOptions.tooltip)
        end
        if boxOptions and type(boxOptions) == "table" and (boxOptions.SaveKey or boxOptions.saveKey or boxOptions.Id or boxOptions.id) then
            boxObj:WithSaveKey(boxOptions.SaveKey or boxOptions.saveKey or boxOptions.Id or boxOptions.id)
        end

        return boxObj
    end

    local function BuildGenericDropdown(isMulti, parent, position, size, title, options, defaultVal, onSelect, dropConfig)
        parent = ResolveParent(parent)
        local inSection = IsInsideSection(parent)
        local defaultCardH = inSection and 42 or 44
        size = size or UDim2.new(1, -10, 0, defaultCardH)
        position = position or UDim2.new(0, 0, 0, 0)
        
        dropConfig = (type(dropConfig) == "table") and dropConfig or {}
        if (not options or #options == 0) then
            options = dropConfig.Options or dropConfig.options or dropConfig.Values or dropConfig.values or dropConfig.List or options
        end
        options = options or {}

        local isPriority = (isMulti == "priority") or (dropConfig and (dropConfig.Priority == true or dropConfig.isPriority == true))
        if isPriority then
            isMulti = true
        end
        local maxSelected = dropConfig and (dropConfig.MaxSelected or dropConfig.maxSelected or dropConfig.Max or dropConfig.max)
        local selectedOption = nil
        local selectedMap = {}
        local selectedOrder = {}
        local lastContentH = 28

        local function SetOptionSelected(optStr, state)
            if state and not selectedMap[optStr] then
                if maxSelected and #selectedOrder >= maxSelected then return false end
                selectedMap[optStr] = true
                table.insert(selectedOrder, optStr)
            elseif not state and selectedMap[optStr] then
                selectedMap[optStr] = nil
                local i = table.find(selectedOrder, optStr)
                if i then table.remove(selectedOrder, i) end
            end
            return true
        end

        if isMulti then
            local defSels = defaultVal
            if defSels == nil then
                defSels = dropConfig.Default or dropConfig.default or dropConfig.Selections or {}
            end
            if type(defSels) == "table" then
                for k, v in pairs(defSels) do
                    if type(k) == "number" then
                        local vStr = tostring(v)
                        if not selectedMap[vStr] then
                            selectedMap[vStr] = true
                            table.insert(selectedOrder, vStr)
                        end
                    elseif v == true then
                        local kStr = tostring(k)
                        if not selectedMap[kStr] then
                            selectedMap[kStr] = true
                            table.insert(selectedOrder, kStr)
                        end
                    end
                end
            elseif type(defSels) == "string" then
                local sStr = tostring(defSels)
                selectedMap[sStr] = true
                table.insert(selectedOrder, sStr)
            end
        else
            selectedOption = defaultVal
            if selectedOption == nil then
                selectedOption = dropConfig.Default or dropConfig.default or options[1] or "Select..."
            end
        end

        local function GetSelectedList()
            if isPriority then
                local list = {}
                for _, opt in ipairs(selectedOrder) do
                    table.insert(list, opt)
                end
                return list
            end
            local list = {}
            for _, opt in ipairs(options) do
                local optStr = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                if selectedMap[optStr] then
                    table.insert(list, opt)
                end
            end
            return list
        end

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = GenerateSafeName(isMulti and "MultiDropdown" or "Dropdown")
        DropdownFrame:SetAttribute("MDCard", true)
        DropdownFrame.Size = size
        DropdownFrame.Position = position
        DropdownFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        DropdownFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ZIndex = 10
        DropdownFrame.ClipsDescendants = false
        DropdownFrame.Parent = parent

        local connectMode = dropConfig.Connect or dropConfig.Connected or dropConfig.connectMode or dropConfig.PositionInGroup
        local Corner = Instance.new("UICorner")
        Corner.Parent = DropdownFrame -- parent first so the first ApplyCardCorner call works
        local function ApplyCardCorner(open)
            if not Corner then return end
            if open then
                if connectMode == "Left" then
                    ApplyCornerRadii(Corner, 12, 0, 0, 0)
                elseif connectMode == "Right" then
                    ApplyCornerRadii(Corner, 0, 12, 0, 0)
                elseif connectMode == "Middle" or connectMode == "Bottom" or connectMode == "Last" then
                    ApplyCornerRadii(Corner, 0, 0, 0, 0)
                else
                    ApplyCornerRadii(Corner, 12, 12, 0, 0)
                end
            else
                if connectMode == "Top" or connectMode == "First" then
                    ApplyCornerRadii(Corner, 12, 12, 0, 0)
                elseif connectMode == "Middle" then
                    ApplyCornerRadii(Corner, 0, 0, 0, 0)
                elseif connectMode == "Bottom" or connectMode == "Last" then
                    ApplyCornerRadii(Corner, 0, 0, 12, 12)
                elseif connectMode == "Left" then
                    ApplyCornerRadii(Corner, 12, 0, 0, 12)
                elseif connectMode == "Right" then
                    ApplyCornerRadii(Corner, 0, 12, 12, 0)
                else
                    Corner.CornerRadius = UDim.new(0, 12)
                end
            end
        end
        ApplyCardCorner(false)

        if not connectMode then
            local shadow = AddUIShadow(DropdownFrame, 20, 0.5)
            if inSection and Window.SectionsTransparent and shadow then
                pcall(function() shadow.Visible = false end)
            end
        end

        local TitleText = Instance.new("TextLabel")
        TitleText.Name = "DropdownTitle"
        TitleText.Size = UDim2.new(1, -60, 1, 0)
        TitleText.Position = UDim2.new(0, 14, 0, 0)
        TitleText.BackgroundTransparency = 1
        TitleText.FontFace = FontFingerPaintRegular
        TitleText.TextColor3 = Window.CurrentTheme.Text
        TitleText.TextSize = 14
        TitleText.TextTruncate = Enum.TextTruncate.AtEnd
        TitleText.TextXAlignment = Enum.TextXAlignment.Left
        TitleText.TextYAlignment = Enum.TextYAlignment.Center
        TitleText.ZIndex = 11
        TitleText.Parent = DropdownFrame

        -- Icon shown in closed header when HasIcons (single selection or 1 item selected in multi)
        local HeaderIcon = nil
        local hasIconsMode = dropConfig and (dropConfig.HasIcons or dropConfig.hasIcons)
        if hasIconsMode then
            HeaderIcon = Instance.new("ImageLabel")
            HeaderIcon.Name = "HeaderIcon"
            HeaderIcon.Size = UDim2.new(0, 20, 0, 20)
            HeaderIcon.Position = UDim2.new(0, 10, 0.5, -10)
            HeaderIcon.BackgroundTransparency = 1
            HeaderIcon.ScaleType = Enum.ScaleType.Crop
            HeaderIcon.ZIndex = 12
            HeaderIcon.Visible = false
            local hicCorner = Instance.new("UICorner")
            hicCorner.CornerRadius = UDim.new(0, 4)
            hicCorner.Parent = HeaderIcon
            HeaderIcon.Parent = DropdownFrame
            -- Shift TitleText right to make room
            TitleText.Position = UDim2.new(0, 36, 0, 0)
            TitleText.Size = UDim2.new(1, -72, 1, 0)
        end

        local function GetOptionIcon(optStr)
            if not hasIconsMode then return nil end
            for _, opt in ipairs(options) do
                local oStr = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                if oStr == optStr then
                    local ic = (type(opt) == "table") and (opt.Icon or opt.Image) or nil
                    if ic then
                        local s = tostring(ic)
                        return s:find("://") and s or ("rbxassetid://" .. s)
                    end
                end
            end
            local di = dropConfig.OptionIcons and dropConfig.OptionIcons[optStr]
            if di then
                local s = tostring(di)
                return s:find("://") and s or ("rbxassetid://" .. s)
            end
            return nil
        end

        local function UpdateTitleDisplay()
            if isPriority then
                local count = #selectedOrder
                if count == 0 then
                    TitleText.Text = (title and title ~= "") and (title .. ": None") or "None"
                elseif count == 1 then
                    TitleText.Text = (title and title ~= "") and (title .. ": " .. tostring(selectedOrder[1])) or tostring(selectedOrder[1])
                else
                    local orderSummary = table.concat(selectedOrder, " > ")
                    if #orderSummary > 28 then
                        TitleText.Text = (title and title ~= "") and (title .. ": " .. orderSummary:sub(1, 24) .. "... (" .. tostring(count) .. ")") or (orderSummary:sub(1, 24) .. "... (" .. tostring(count) .. ")")
                    else
                        TitleText.Text = (title and title ~= "") and (title .. ": " .. orderSummary) or orderSummary
                    end
                end
                if HeaderIcon then
                    local firstSel = selectedOrder[1]
                    local ic = firstSel and GetOptionIcon(firstSel)
                    if ic then
                        HeaderIcon.Image = ic
                        HeaderIcon.Visible = true
                    else
                        HeaderIcon.Visible = false
                    end
                end
            elseif isMulti then
                local sels = GetSelectedList()
                local count = #sels
                if count == 0 then
                    TitleText.Text = (title and title ~= "") and (title .. ": None") or "None"
                elseif count == 1 then
                    local s1 = sels[1]
                    local s1Str = (type(s1) == "table") and tostring(s1.Name or s1.Text or s1[1]) or tostring(s1)
                    TitleText.Text = (title and title ~= "") and (title .. ": " .. s1Str) or s1Str
                else
                    TitleText.Text = (title and title ~= "") and (title .. ": (" .. tostring(count) .. " Selected)") or ("(" .. tostring(count) .. " Selected)")
                end
                if HeaderIcon then
                    local s1 = sels[1]
                    local s1Str = s1 and ((type(s1) == "table") and tostring(s1.Name or s1.Text or s1[1]) or tostring(s1))
                    local ic = (count == 1 and s1Str) and GetOptionIcon(s1Str) or nil
                    if ic then
                        HeaderIcon.Image = ic
                        HeaderIcon.Visible = true
                    else
                        HeaderIcon.Visible = false
                    end
                end
            else
                local optStr = (type(selectedOption) == "table") and tostring(selectedOption.Name or selectedOption.Text or selectedOption[1]) or tostring(selectedOption or "")
                TitleText.Text = (title and title ~= "") and (title .. ": " .. optStr) or optStr
                -- Update header icon for single dropdown with HasIcons
                if HeaderIcon then
                    local ic = GetOptionIcon(optStr)
                    if ic then
                        HeaderIcon.Image = ic
                        HeaderIcon.Visible = true
                    else
                        HeaderIcon.Visible = false
                    end
                end
            end
        end
        UpdateTitleDisplay()

        local ArrowIcon = Instance.new("ImageLabel")
        ArrowIcon.Name = "ArrowIcon"
        ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
        ArrowIcon.Position = UDim2.new(1, -26, 0.5, -7)
        ArrowIcon.BackgroundTransparency = 1
        ArrowIcon.Image = "rbxassetid://11552476728"
        ArrowIcon.ImageColor3 = Window.CurrentTheme.Text
        ArrowIcon.ZIndex = 11
        ArrowIcon.Parent = DropdownFrame

        local HeaderTrigger = Instance.new("TextButton")
        HeaderTrigger.Name = GenerateSafeName("Trigger")
        HeaderTrigger.Size = UDim2.new(1, 0, 1, 0)
        HeaderTrigger.BackgroundTransparency = 1
        HeaderTrigger.Text = ""
        HeaderTrigger.ZIndex = 12
        HeaderTrigger.Parent = DropdownFrame

        -- Dropdown Content overlay menu
        local DropdownContent = Instance.new("Frame")
        DropdownContent.Name = GenerateSafeName("DropdownContent")
        DropdownContent.Size = UDim2.new(0, 0, 0, 0)
        DropdownContent.Position = UDim2.new(0, 0, 0, 0)
        DropdownContent.BackgroundColor3 = DropdownFrame.BackgroundColor3
        DropdownContent.BackgroundTransparency = (inSection and Window.SectionsTransparent) and (Window.ElementsTransparency or 0.33) or DropdownFrame.BackgroundTransparency
        DropdownContent.BorderSizePixel = 0
        DropdownContent.ClipsDescendants = true
        DropdownContent.Visible = false
        DropdownContent.ZIndex = 501
        DropdownContent.Parent = Window.DropdownOverlay or MainContainer

        local ContentCorner = Instance.new("UICorner")
        ApplyCornerRadii(ContentCorner, 0, 0, 12, 12)
        ContentCorner.Parent = DropdownContent

        local HeaderDivider = Instance.new("Frame")
        HeaderDivider.Name = "HeaderDivider"
        HeaderDivider.Size = UDim2.new(1, -20, 0, 1)
        HeaderDivider.Position = UDim2.new(0, 10, 0, 0)
        HeaderDivider.BackgroundColor3 = Window.CurrentTheme.Divider or Color3.fromRGB(80, 85, 100)
        HeaderDivider.BackgroundTransparency = 0.65
        HeaderDivider.BorderSizePixel = 0
        HeaderDivider.ZIndex = 502
        HeaderDivider.Parent = DropdownContent

        -- Auto-enable search for long lists
        local isSearchable = (dropConfig.Searchable == true or dropConfig.Search == true or dropConfig.searchable == true) or (#options > 8)

        local topOffset = 5
        local SearchContainer = nil
        local SearchInput = nil

        if isSearchable then
            SearchContainer = Instance.new("Frame")
            SearchContainer.Name = "SearchContainer"
            SearchContainer.Size = UDim2.new(1, -10, 0, 26)
            SearchContainer.Position = UDim2.new(0, 5, 0, topOffset)
            SearchContainer.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
            SearchContainer.BackgroundTransparency = 0.1
            SearchContainer.BorderSizePixel = 0
            SearchContainer.ZIndex = 502
            SearchContainer.Parent = DropdownContent

            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 6)
            sCorner.Parent = SearchContainer

            local sIcon = Instance.new("ImageLabel")
            sIcon.Size = UDim2.new(0, 14, 0, 14)
            sIcon.Position = UDim2.new(0, 6, 0.5, -7)
            sIcon.BackgroundTransparency = 1
            sIcon.Image = "rbxassetid://6031154871"
            sIcon.ImageColor3 = Window.CurrentTheme.SubText
            sIcon.ZIndex = 503
            sIcon.Parent = SearchContainer

            SearchInput = Instance.new("TextBox")
            SearchInput.Size = UDim2.new(1, -26, 1, 0)
            SearchInput.Position = UDim2.new(0, 24, 0, 0)
            SearchInput.BackgroundTransparency = 1
            SearchInput.FontFace = FontFingerPaintRegular
            SearchInput.PlaceholderText = "Search..."
            SearchInput.PlaceholderColor3 = Window.CurrentTheme.SubText
            SearchInput.Text = ""
            SearchInput.TextColor3 = Window.CurrentTheme.Text
            SearchInput.TextSize = 11
            SearchInput.TextXAlignment = Enum.TextXAlignment.Left
            SearchInput.ClearTextOnFocus = false
            SearchInput.ZIndex = 503
            SearchInput.Parent = SearchContainer

            topOffset = topOffset + 26 + 4
        end

        local ActionsBar = nil
        local SelectAllBtn = nil
        local ClearBtn = nil

        if isMulti then
            ActionsBar = Instance.new("Frame")
            ActionsBar.Name = "ActionsBar"
            ActionsBar.Size = UDim2.new(1, -10, 0, 20)
            ActionsBar.Position = UDim2.new(0, 5, 0, topOffset)
            ActionsBar.BackgroundTransparency = 1
            ActionsBar.BorderSizePixel = 0
            ActionsBar.ZIndex = 502
            ActionsBar.Parent = DropdownContent

            SelectAllBtn = Instance.new("TextButton")
            SelectAllBtn.Name = "SelectAllBtn"
            SelectAllBtn.Size = UDim2.new(0.5, -3, 1, 0)
            SelectAllBtn.Position = UDim2.new(0, 0, 0, 0)
            SelectAllBtn.BackgroundTransparency = 1
            SelectAllBtn.FontFace = FontFingerPaintRegular
            SelectAllBtn.Text = "Select all"
            SelectAllBtn.TextColor3 = Window.CurrentTheme.SubText
            SelectAllBtn.TextSize = 11
            SelectAllBtn.TextXAlignment = Enum.TextXAlignment.Left
            SelectAllBtn.ZIndex = 503
            SelectAllBtn.Parent = ActionsBar

            ClearBtn = Instance.new("TextButton")
            ClearBtn.Name = "ClearBtn"
            ClearBtn.Size = UDim2.new(0.5, -3, 1, 0)
            ClearBtn.Position = UDim2.new(0.5, 3, 0, 0)
            ClearBtn.BackgroundTransparency = 1
            ClearBtn.FontFace = FontFingerPaintRegular
            ClearBtn.Text = "Clear"
            ClearBtn.TextColor3 = Window.CurrentTheme.SubText
            ClearBtn.TextSize = 11
            ClearBtn.TextXAlignment = Enum.TextXAlignment.Right
            ClearBtn.ZIndex = 503
            ClearBtn.Parent = ActionsBar

            TrackConn(SelectAllBtn.MouseEnter:Connect(function()
                TweenService:Create(SelectAllBtn, TweenInfo.new(0.15), {TextColor3 = Window.CurrentTheme.Text}):Play()
            end))
            TrackConn(SelectAllBtn.MouseLeave:Connect(function()
                TweenService:Create(SelectAllBtn, TweenInfo.new(0.15), {TextColor3 = Window.CurrentTheme.SubText}):Play()
            end))
            TrackConn(ClearBtn.MouseEnter:Connect(function()
                TweenService:Create(ClearBtn, TweenInfo.new(0.15), {TextColor3 = Window.CurrentTheme.Text}):Play()
            end))
            TrackConn(ClearBtn.MouseLeave:Connect(function()
                TweenService:Create(ClearBtn, TweenInfo.new(0.15), {TextColor3 = Window.CurrentTheme.SubText}):Play()
            end))

            topOffset = topOffset + 20 + 4
        end

        local InnerScroll = Instance.new("ScrollingFrame")
        InnerScroll.Name = "InnerScroll"
        InnerScroll.Position = UDim2.new(0, 5, 0, topOffset)
        InnerScroll.Size = UDim2.new(1, -10, 1, -(topOffset + 5))
        InnerScroll.BackgroundTransparency = 1
        InnerScroll.BorderSizePixel = 0
        InnerScroll.ScrollBarThickness = 0
        InnerScroll.ZIndex = 502
        InnerScroll.Parent = DropdownContent

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 3)
        ListLayout.Parent = InnerScroll

        local NoResultsLabel = Instance.new("TextLabel")
        NoResultsLabel.Name = "NoResults"
        NoResultsLabel.Size = UDim2.new(1, 0, 0, 28)
        NoResultsLabel.BackgroundTransparency = 1
        NoResultsLabel.FontFace = FontFingerPaintRegular
        NoResultsLabel.Text = "No results"
        NoResultsLabel.TextColor3 = Window.CurrentTheme.SubText
        NoResultsLabel.TextSize = 12
        NoResultsLabel.TextXAlignment = Enum.TextXAlignment.Center
        NoResultsLabel.TextYAlignment = Enum.TextYAlignment.Center
        NoResultsLabel.Visible = false
        NoResultsLabel.ZIndex = 503
        NoResultsLabel.Parent = InnerScroll

        local ROW_HEIGHT = (dropConfig and (dropConfig.HasIcons or dropConfig.hasIcons)) and 34 or 28
        local itemRows = {}
        local visibleItems = {}
        local highlightIndex = nil
        local isExpanded = false
        local dropObj = nil
        local currentFilter = ""
        local keyboardConn = nil

        local function UpdateRowVisuals(optStr, animate)
            local row = itemRows[optStr]
            if not row then return end
            local twInfo = animate and TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or nil

            if isMulti then
                local isSel = (selectedMap[optStr] == true)
                local targetBg = Window.CurrentTheme.AccentBG
                local targetTrans = isSel and 0.45 or 0.85
                local boxBg = isSel and Window.CurrentTheme.ButtonBG or GetThemedDarkColor(Window.CurrentTheme)
                local boxTrans = isSel and 0 or 0.2
                local iconTrans = isSel and 0 or 1
                local textCol = isSel and Window.CurrentTheme.Text or Window.CurrentTheme.SubText

                if animate then
                    TweenService:Create(row.Button, twInfo, { BackgroundColor3 = targetBg, BackgroundTransparency = targetTrans }):Play()
                    TweenService:Create(row.BoxOuter, twInfo, { BackgroundColor3 = boxBg, BackgroundTransparency = boxTrans }):Play()
                    TweenService:Create(row.CheckIcon, twInfo, { ImageTransparency = iconTrans }):Play()
                    TweenService:Create(row.Label, twInfo, { TextColor3 = textCol }):Play()
                else
                    row.Button.BackgroundColor3 = targetBg
                    row.Button.BackgroundTransparency = targetTrans
                    row.BoxOuter.BackgroundColor3 = boxBg
                    row.BoxOuter.BackgroundTransparency = boxTrans
                    row.CheckIcon.ImageTransparency = iconTrans
                    row.Label.TextColor3 = textCol
                end
            else
                local isSel = (tostring(optStr) == tostring(selectedOption))
                local targetBg = isSel and Window.CurrentTheme.ButtonBG or Window.CurrentTheme.AccentBG
                local targetTrans = isSel and 0.15 or 0.65
                local textCol = isSel and GetOnAccent(Window.CurrentTheme.ButtonBG) or Window.CurrentTheme.Text

                if animate then
                    TweenService:Create(row.Button, twInfo, { BackgroundColor3 = targetBg, BackgroundTransparency = targetTrans }):Play()
                    if row.Label then
                        TweenService:Create(row.Label, twInfo, { TextColor3 = textCol }):Play()
                    else
                        TweenService:Create(row.Button, twInfo, { TextColor3 = textCol }):Play()
                    end
                else
                    row.Button.BackgroundColor3 = targetBg
                    row.Button.BackgroundTransparency = targetTrans
                    if row.Label then
                        row.Label.TextColor3 = textCol
                    else
                        row.Button.TextColor3 = textCol
                    end
                end
            end
        end

        local function UpdateHighlightVisuals()
            for idx, item in ipairs(visibleItems) do
                local isHl = (idx == highlightIndex)
                if item.HighlightStroke then
                    item.HighlightStroke.Transparency = isHl and 0.2 or 1
                end
            end
        end

        local function CloseDropdown()
            if not isExpanded then return end
            isExpanded = false
            if keyboardConn then
                keyboardConn:Disconnect()
                keyboardConn = nil
            end
            if Window.ActiveDropdown == dropObj then
                Window.ActiveDropdown = nil
            end
            highlightIndex = nil
            UpdateHighlightVisuals()

            TweenService:Create(ArrowIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
            local scale = (UIScaleConstraint and UIScaleConstraint.Scale > 0) and UIScaleConstraint.Scale or 1
            local curWidth = DropdownContent.AbsoluteSize.X / scale
            local t = TweenService:Create(DropdownContent, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, curWidth, 0, 0)
            })
            t:Play()
            t.Completed:Connect(function()
                if not isExpanded then
                    DropdownContent.Visible = false
                    ApplyCardCorner(false)
                end
            end)
        end

        local function RebuildItemRows(filterText)
            if filterText ~= nil then
                currentFilter = tostring(filterText):lower()
            end

            if isPriority then
                for _, child in ipairs(InnerScroll:GetChildren()) do
                    if child:IsA("TextButton") or child:IsA("Frame") or (child:IsA("TextLabel") and child ~= NoResultsLabel) then
                        child:Destroy()
                    end
                end
                itemRows = {}
                visibleItems = {}
                highlightIndex = nil

                local currentOrder = 1

                -- Section 1: Active
                local activeHeader = Instance.new("TextLabel")
                activeHeader.Name = "ActiveHeader"
                activeHeader.Size = UDim2.new(1, 0, 0, 20)
                activeHeader.BackgroundTransparency = 1
                activeHeader.FontFace = FontFingerPaintRegular
                activeHeader.Text = "ACTIVE (" .. tostring(#selectedOrder) .. (maxSelected and ("/" .. tostring(maxSelected)) or "") .. ")"
                activeHeader.TextColor3 = Window.CurrentTheme.SubText
                activeHeader.TextSize = 11
                activeHeader.TextXAlignment = Enum.TextXAlignment.Left
                activeHeader.LayoutOrder = currentOrder
                currentOrder = currentOrder + 1
                activeHeader.ZIndex = 503
                activeHeader.Parent = InnerScroll

                if #selectedOrder == 0 then
                    local emptyLbl = Instance.new("TextLabel")
                    emptyLbl.Name = "EmptyActive"
                    emptyLbl.Size = UDim2.new(1, 0, 0, 22)
                    emptyLbl.BackgroundTransparency = 1
                    emptyLbl.FontFace = FontFingerPaintRegular
                    emptyLbl.Text = "None selected (click below to add)"
                    emptyLbl.TextColor3 = Window.CurrentTheme.SubText
                    emptyLbl.TextTransparency = 0.4
                    emptyLbl.TextSize = 11
                    emptyLbl.TextXAlignment = Enum.TextXAlignment.Center
                    emptyLbl.LayoutOrder = currentOrder
                    currentOrder = currentOrder + 1
                    emptyLbl.ZIndex = 503
                    emptyLbl.Parent = InnerScroll
                else
                    for pIdx, optStr in ipairs(selectedOrder) do
                        local ItemBtn = Instance.new("Frame")
                        ItemBtn.Name = "Active_" .. optStr
                        ItemBtn.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
                        ItemBtn.BackgroundColor3 = Window.CurrentTheme.AccentBG
                        ItemBtn.BackgroundTransparency = 0.5
                        ItemBtn.BorderSizePixel = 0
                        ItemBtn.LayoutOrder = currentOrder
                        currentOrder = currentOrder + 1
                        ItemBtn.ZIndex = 503
                        ItemBtn.Parent = InnerScroll

                        local itemCorner = Instance.new("UICorner")
                        itemCorner.CornerRadius = UDim.new(0, 6)
                        itemCorner.Parent = ItemBtn

                        -- Grip icon (left, 40% opacity)
                        local GripIcon = Instance.new("ImageLabel")
                        GripIcon.Name = "Grip"
                        GripIcon.Size = UDim2.new(0, 12, 0, 18)
                        GripIcon.Position = UDim2.new(0, 3, 0.5, -9)
                        GripIcon.BackgroundTransparency = 1
                        GripIcon.Image = "rbxassetid://136050395759142"
                        GripIcon.ImageTransparency = 0.6
                        GripIcon.ZIndex = 504
                        GripIcon.Parent = ItemBtn

                        -- Badge (rank number, rank 1 = full opacity, others = 0.35 opacity)
                        local Badge = Instance.new("TextLabel")
                        Badge.Name = "Badge"
                        Badge.Size = UDim2.new(0, 18, 0, 18)
                        Badge.Position = UDim2.new(0, 17, 0.5, -9)
                        Badge.BackgroundColor3 = Window.CurrentTheme.ButtonBG
                        Badge.BorderSizePixel = 0
                        Badge.FontFace = FontFingerPaintRegular
                        Badge.Text = tostring(pIdx)
                        Badge.TextColor3 = GetOnAccent(Window.CurrentTheme.ButtonBG)
                        Badge.TextSize = 11
                        Badge.ZIndex = 504
                        Badge.BackgroundTransparency = (pIdx == 1) and 0 or 0.65
                        Badge.TextTransparency = (pIdx == 1) and 0 or 0.35
                        Badge.Parent = ItemBtn

                        local bCorner = Instance.new("UICorner")
                        bCorner.CornerRadius = UDim.new(0, 4)
                        bCorner.Parent = Badge

                        -- Label (shifted right to make room for grip + badge)
                        local ItemLabel = Instance.new("TextLabel")
                        ItemLabel.Name = "Label"
                        ItemLabel.Size = UDim2.new(1, -105, 1, 0)
                        ItemLabel.Position = UDim2.new(0, 38, 0, 0)
                        ItemLabel.BackgroundTransparency = 1
                        ItemLabel.FontFace = FontFingerPaintRegular
                        ItemLabel.Text = optStr
                        ItemLabel.TextColor3 = Window.CurrentTheme.Text
                        ItemLabel.TextSize = 12
                        ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
                        ItemLabel.TextTruncate = Enum.TextTruncate.AtEnd
                        ItemLabel.ZIndex = 504
                        ItemLabel.Parent = ItemBtn

                        local function FlashRow(frame)
                            task.spawn(function()
                                for _ = 1, 2 do
                                    TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
                                    task.wait(0.09)
                                    TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5}):Play()
                                    task.wait(0.11)
                                end
                            end)
                        end

                        -- Move Up Button (chevron-up Lucide icon)
                        if pIdx > 1 then
                            local UpBtn = Instance.new("ImageButton")
                            UpBtn.Name = "UpBtn"
                            UpBtn.Size = UDim2.new(0, 18, 0, 18)
                            UpBtn.Position = UDim2.new(1, -66, 0.5, -9)
                            UpBtn.BackgroundTransparency = 1
                            UpBtn.Image = "rbxassetid://98648581502859"
                            UpBtn.ImageColor3 = Window.CurrentTheme.SubText
                            UpBtn.ZIndex = 505
                            UpBtn.Parent = ItemBtn

                            UpBtn.MouseButton1Click:Connect(function()
                                PlayClickSFX()
                                local temp = selectedOrder[pIdx]
                                selectedOrder[pIdx] = selectedOrder[pIdx - 1]
                                selectedOrder[pIdx - 1] = temp
                                UpdateTitleDisplay()
                                RebuildItemRows(currentFilter)
                                UpdateDropdownHeight()
                                if onSelect then pcall(onSelect, GetSelectedList()) end
                            end)
                        end

                        -- Move Down Button (chevron-down Lucide icon)
                        if pIdx < #selectedOrder then
                            local DownBtn = Instance.new("ImageButton")
                            DownBtn.Name = "DownBtn"
                            DownBtn.Size = UDim2.new(0, 18, 0, 18)
                            DownBtn.Position = UDim2.new(1, -44, 0.5, -9)
                            DownBtn.BackgroundTransparency = 1
                            DownBtn.Image = "rbxassetid://71457658246709"
                            DownBtn.ImageColor3 = Window.CurrentTheme.SubText
                            DownBtn.ZIndex = 505
                            DownBtn.Parent = ItemBtn

                            DownBtn.MouseButton1Click:Connect(function()
                                PlayClickSFX()
                                local temp = selectedOrder[pIdx]
                                selectedOrder[pIdx] = selectedOrder[pIdx + 1]
                                selectedOrder[pIdx + 1] = temp
                                UpdateTitleDisplay()
                                RebuildItemRows(currentFilter)
                                UpdateDropdownHeight()
                                if onSelect then pcall(onSelect, GetSelectedList()) end
                            end)
                        end

                        -- Remove Button (x Lucide icon via GetIcon)
                        local RemBtn = Instance.new("ImageButton")
                        RemBtn.Name = "RemBtn"
                        RemBtn.Size = UDim2.new(0, 16, 0, 16)
                        RemBtn.Position = UDim2.new(1, -22, 0.5, -8)
                        RemBtn.BackgroundTransparency = 1
                        local xIconId = Library:GetIcon("x") or "11502849"
                        RemBtn.Image = tostring(xIconId):find("://") and tostring(xIconId) or ("rbxassetid://" .. tostring(xIconId))
                        RemBtn.ImageColor3 = Color3.fromRGB(255, 90, 90)
                        RemBtn.ZIndex = 505
                        RemBtn.Parent = ItemBtn

                        RemBtn.MouseButton1Click:Connect(function()
                            PlayClickSFX()
                            SetOptionSelected(optStr, false)
                            UpdateTitleDisplay()
                            RebuildItemRows(currentFilter)
                            UpdateDropdownHeight()
                            if onSelect then pcall(onSelect, GetSelectedList()) end
                        end)

                        -- Flash on first render when newly moved (tracked by attribute)
                        if ItemBtn:GetAttribute("JustMoved") then
                            ItemBtn:SetAttribute("JustMoved", nil)
                            FlashRow(ItemBtn)
                        end
                    end
                end

                -- Section 2: Available
                local availHeader = Instance.new("TextLabel")
                availHeader.Name = "AvailHeader"
                availHeader.Size = UDim2.new(1, 0, 0, 20)
                availHeader.BackgroundTransparency = 1
                availHeader.FontFace = FontFingerPaintRegular
                availHeader.Text = "AVAILABLE"
                availHeader.TextColor3 = Window.CurrentTheme.SubText
                availHeader.TextSize = 11
                availHeader.TextXAlignment = Enum.TextXAlignment.Left
                availHeader.LayoutOrder = currentOrder
                currentOrder = currentOrder + 1
                availHeader.ZIndex = 503
                availHeader.Parent = InnerScroll

                local availCount = 0
                for _, opt in ipairs(options) do
                    local optStr = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                    local optIcon = (type(opt) == "table") and (opt.Icon or opt.Image) or (dropConfig.OptionIcons and dropConfig.OptionIcons[optStr])
                    if not selectedMap[optStr] then
                        local matches = (currentFilter == "" or optStr:lower():find(currentFilter, 1, true))
                        if matches then
                            availCount = availCount + 1
                            local ItemBtn = Instance.new("TextButton")
                            ItemBtn.Name = "Avail_" .. optStr
                            ItemBtn.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
                            ItemBtn.BackgroundColor3 = Window.CurrentTheme.AccentBG
                            ItemBtn.BackgroundTransparency = 0.8
                            ItemBtn.BorderSizePixel = 0
                            ItemBtn.LayoutOrder = currentOrder
                            currentOrder = currentOrder + 1
                            ItemBtn.ZIndex = 503
                            ItemBtn.Parent = InnerScroll

                            local itemCorner = Instance.new("UICorner")
                            itemCorner.CornerRadius = UDim.new(0, 6)
                            itemCorner.Parent = ItemBtn

                            local xOff = 8
                            if optIcon then
                                local IconImg = Instance.new("ImageLabel")
                                IconImg.Size = UDim2.new(0, 16, 0, 16)
                                IconImg.Position = UDim2.new(0, xOff, 0.5, -8)
                                IconImg.BackgroundTransparency = 1
                                IconImg.Image = tostring(optIcon):find("://") and tostring(optIcon) or ("rbxassetid://" .. tostring(optIcon))
                                IconImg.ScaleType = Enum.ScaleType.Fit
                                IconImg.ZIndex = 504
                                IconImg.Parent = ItemBtn
                                xOff = xOff + 22
                            end

                            local ItemLabel = Instance.new("TextLabel")
                            ItemLabel.Name = "Label"
                            ItemLabel.Size = UDim2.new(1, -(xOff + 26), 1, 0)
                            ItemLabel.Position = UDim2.new(0, xOff, 0, 0)
                            ItemLabel.BackgroundTransparency = 1
                            ItemLabel.FontFace = FontFingerPaintRegular
                            ItemLabel.Text = optStr
                            ItemLabel.TextColor3 = Window.CurrentTheme.Text
                            ItemLabel.TextSize = 12
                            ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
                            ItemLabel.TextTruncate = Enum.TextTruncate.AtEnd
                            ItemLabel.ZIndex = 504
                            ItemLabel.Parent = ItemBtn

                            local AddIcon = Instance.new("TextLabel")
                            AddIcon.Name = "Add"
                            AddIcon.Size = UDim2.new(0, 20, 1, 0)
                            AddIcon.Position = UDim2.new(1, -22, 0, 0)
                            AddIcon.BackgroundTransparency = 1
                            AddIcon.FontFace = FontFingerPaintRegular
                            AddIcon.Text = "+"
                            AddIcon.TextColor3 = Window.CurrentTheme.SubText
                            AddIcon.TextSize = 14
                            AddIcon.ZIndex = 504
                            AddIcon.Parent = ItemBtn

                            ItemBtn.MouseButton1Click:Connect(function()
                                PlayClickSFX()
                                if SetOptionSelected(optStr, true) then
                                    UpdateTitleDisplay()
                                    RebuildItemRows(currentFilter)
                                    UpdateDropdownHeight()
                                    if onSelect then pcall(onSelect, GetSelectedList()) end
                                end
                            end)
                        end
                    end
                end

                if availCount == 0 then
                    local noAvail = Instance.new("TextLabel")
                    noAvail.Name = "NoAvail"
                    noAvail.Size = UDim2.new(1, 0, 0, 22)
                    noAvail.BackgroundTransparency = 1
                    noAvail.FontFace = FontFingerPaintRegular
                    noAvail.Text = "All items active"
                    noAvail.TextColor3 = Window.CurrentTheme.SubText
                    noAvail.TextTransparency = 0.5
                    noAvail.TextSize = 11
                    noAvail.TextXAlignment = Enum.TextXAlignment.Center
                    noAvail.LayoutOrder = currentOrder
                    currentOrder = currentOrder + 1
                    noAvail.ZIndex = 503
                    noAvail.Parent = InnerScroll
                end

                NoResultsLabel.Visible = false
                -- Compute accurate height: 2 headers (20px each) + rows + empty-state labels + spacing
                local rowCount = #selectedOrder + availCount
                local emptyActiveH = (#selectedOrder == 0) and (22 + 3) or 0
                local emptyAvailH = (availCount == 0) and (22 + 3) or 0
                local totalContentY = 20 + 3 + emptyActiveH + (#selectedOrder * (ROW_HEIGHT + 3)) + 20 + 3 + emptyAvailH + (availCount * (ROW_HEIGHT + 3))
                totalContentY = math.max(totalContentY - 3, 28)
                lastContentH = totalContentY
                InnerScroll.CanvasSize = UDim2.new(0, 0, 0, totalContentY)
                return rowCount
            end

            for _, child in ipairs(InnerScroll:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            itemRows = {}
            visibleItems = {}
            highlightIndex = nil

            local _checkIconId = Library:GetIcon("check") or "86817768619372"
            local iconAsset = tostring(_checkIconId):find("://") and tostring(_checkIconId) or ("rbxassetid://" .. tostring(_checkIconId))

            for idx, opt in ipairs(options) do
                local optStr = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                local optIcon = (type(opt) == "table") and (opt.Icon or opt.Image) or (dropConfig.OptionIcons and dropConfig.OptionIcons[optStr])
                local matches = (currentFilter == "" or optStr:lower():find(currentFilter, 1, true))

                if matches then
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.Name = "Item_" .. optStr
                    ItemBtn.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
                    ItemBtn.BorderSizePixel = 0
                    ItemBtn.ZIndex = 503
                    ItemBtn.Parent = InnerScroll

                    local itemCorner = Instance.new("UICorner")
                    itemCorner.CornerRadius = UDim.new(0, 6)
                    itemCorner.Parent = ItemBtn

                    local hlStroke = Instance.new("UIStroke")
                    hlStroke.Name = "HighlightStroke"
                    hlStroke.Thickness = 1.2
                    hlStroke.Color = Window.CurrentTheme.Text
                    hlStroke.Transparency = 1
                    hlStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    hlStroke.Parent = ItemBtn

                    local rowData = {
                        Button = ItemBtn,
                        HighlightStroke = hlStroke,
                        Opt = opt,
                        Index = #visibleItems + 1
                    }

                    if isMulti then
                        ItemBtn.Text = ""

                        local BoxOuter = Instance.new("Frame")
                        BoxOuter.Name = "CheckBox"
                        BoxOuter.Size = UDim2.new(0, 16, 0, 16)
                        BoxOuter.Position = UDim2.new(0, 6, 0.5, -8)
                        BoxOuter.BorderSizePixel = 0
                        BoxOuter.ZIndex = 504
                        BoxOuter.Parent = ItemBtn

                        local bCorner = Instance.new("UICorner")
                        bCorner.CornerRadius = UDim.new(0, 4)
                        bCorner.Parent = BoxOuter

                        local bStroke = Instance.new("UIStroke")
                        bStroke.Thickness = 1
                        bStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(80, 85, 100)
                        bStroke.Transparency = 0.4
                        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        bStroke.Parent = BoxOuter

                        local CheckIcon = Instance.new("ImageLabel")
                        CheckIcon.Name = "CheckIcon"
                        CheckIcon.Size = UDim2.new(0, 12, 0, 12)
                        CheckIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                        CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                        CheckIcon.BackgroundTransparency = 1
                        CheckIcon.Image = iconAsset
                        CheckIcon.ImageColor3 = GetOnAccent(Window.CurrentTheme.ButtonBG)
                        CheckIcon.ZIndex = 505
                        CheckIcon.Parent = BoxOuter

                        local labelX = 28
                        if optIcon then
                            local iconSz = ROW_HEIGHT == 34 and 22 or 16
                            local iconOff = (ROW_HEIGHT - iconSz) / 2
                            local IconImg = Instance.new("ImageLabel")
                            IconImg.Name = "Icon"
                            IconImg.Size = UDim2.new(0, iconSz, 0, iconSz)
                            IconImg.Position = UDim2.new(0, 26, 0, iconOff)
                            IconImg.BackgroundTransparency = 1
                            local s = tostring(optIcon)
                            IconImg.Image = s:find("://") and s or ("rbxassetid://" .. s)
                            IconImg.ScaleType = Enum.ScaleType.Crop
                            local icCorner = Instance.new("UICorner")
                            icCorner.CornerRadius = UDim.new(0, 4)
                            icCorner.Parent = IconImg
                            IconImg.ZIndex = 505
                            IconImg.Parent = ItemBtn
                            labelX = 26 + iconSz + 6
                        end

                        local ItemLabel = Instance.new("TextLabel")
                        ItemLabel.Name = "Label"
                        ItemLabel.Size = UDim2.new(1, -(labelX + 6), 1, 0)
                        ItemLabel.Position = UDim2.new(0, labelX, 0, 0)
                        ItemLabel.BackgroundTransparency = 1
                        ItemLabel.FontFace = FontFingerPaintRegular
                        ItemLabel.Text = optStr
                        ItemLabel.TextSize = 12
                        ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
                        ItemLabel.TextTruncate = Enum.TextTruncate.AtEnd
                        ItemLabel.ZIndex = 504
                        ItemLabel.Parent = ItemBtn

                        rowData.BoxOuter = BoxOuter
                        rowData.CheckIcon = CheckIcon
                        rowData.Label = ItemLabel

                        ItemBtn.MouseButton1Click:Connect(function()
                            PlayClickSFX()
                            local newState = not selectedMap[optStr]
                            SetOptionSelected(optStr, newState)
                            UpdateRowVisuals(optStr, true)
                            UpdateTitleDisplay()
                            if onSelect then
                                pcall(onSelect, GetSelectedList(), opt, selectedMap[optStr])
                            end
                        end)
                    else
                        ItemBtn.Text = ""

                        local labelX = 8
                        if optIcon then
                            local iconSz = ROW_HEIGHT == 34 and 22 or 16
                            local iconOff = (ROW_HEIGHT - iconSz) / 2
                            local IconImg = Instance.new("ImageLabel")
                            IconImg.Name = "Icon"
                            IconImg.Size = UDim2.new(0, iconSz, 0, iconSz)
                            IconImg.Position = UDim2.new(0, 8, 0, iconOff)
                            IconImg.BackgroundTransparency = 1
                            local s = tostring(optIcon)
                            IconImg.Image = s:find("://") and s or ("rbxassetid://" .. s)
                            IconImg.ScaleType = Enum.ScaleType.Crop
                            local icCorner = Instance.new("UICorner")
                            icCorner.CornerRadius = UDim.new(0, 4)
                            icCorner.Parent = IconImg
                            IconImg.ZIndex = 505
                            IconImg.Parent = ItemBtn
                            labelX = 8 + iconSz + 8
                        end

                        local ItemLabel = Instance.new("TextLabel")
                        ItemLabel.Name = "Label"
                        ItemLabel.Size = UDim2.new(1, -(labelX + 8), 1, 0)
                        ItemLabel.Position = UDim2.new(0, labelX, 0, 0)
                        ItemLabel.BackgroundTransparency = 1
                        ItemLabel.FontFace = FontFingerPaintRegular
                        ItemLabel.Text = optStr
                        ItemLabel.TextSize = 12
                        ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
                        ItemLabel.TextTruncate = Enum.TextTruncate.AtEnd
                        ItemLabel.ZIndex = 504
                        ItemLabel.Parent = ItemBtn

                        rowData.Label = ItemLabel

                        ItemBtn.MouseButton1Click:Connect(function()
                            PlayClickSFX()
                            selectedOption = optStr
                            UpdateTitleDisplay()
                            UpdateRowVisuals(optStr, true)
                            CloseDropdown()
                            if onSelect then
                                pcall(onSelect, opt)
                            end
                        end)
                    end

                    itemRows[optStr] = rowData
                    table.insert(visibleItems, rowData)
                    UpdateRowVisuals(optStr, false)
                end
            end

            local visibleCount = #visibleItems
            NoResultsLabel.Visible = (visibleCount == 0)
            local totalContentY = (visibleCount > 0) and ((visibleCount * ROW_HEIGHT) + ((visibleCount - 1) * 3)) or 28
            InnerScroll.CanvasSize = UDim2.new(0, 0, 0, totalContentY)
            return visibleCount
        end

        local function UpdateDropdownPos()
            if not DropdownFrame or not DropdownFrame.Parent then return end
            local overlay = Window.DropdownOverlay or MainContainer
            if not overlay then return end

            local scale = (UIScaleConstraint and UIScaleConstraint.Scale > 0) and UIScaleConstraint.Scale or 1
            local fPos = DropdownFrame.AbsolutePosition
            local oPos = overlay.AbsolutePosition
            local fSize = DropdownFrame.AbsoluteSize

            local relX = (fPos.X - oPos.X) / scale
            local relY = ((fPos.Y - oPos.Y) / scale) + (fSize.Y / scale)
            local width = fSize.X / scale

            DropdownContent.Position = UDim2.new(0, relX, 0, relY)
            return width
        end

        local function GetContentHeight()
            if isPriority then return lastContentH end
            local n = #visibleItems
            return n > 0 and (n * ROW_HEIGHT + (n - 1) * 3) or 28
        end

        local function UpdateDropdownHeight()
            if not isExpanded then return end
            local contentH = GetContentHeight()
            local neededH = topOffset + contentH + 5
            local maxH = 220
            local targetHeight = math.clamp(neededH, topOffset + 32, maxH)

            local scale = (UIScaleConstraint and UIScaleConstraint.Scale > 0) and UIScaleConstraint.Scale or 1
            local curWidth = DropdownContent.AbsoluteSize.X / scale
            TweenService:Create(DropdownContent, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, curWidth, 0, targetHeight)
            }):Play()
        end

        if SearchInput then
            TrackConn(SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
                RebuildItemRows(SearchInput.Text)
                UpdateDropdownHeight()
            end))
        end

        if SelectAllBtn then
            TrackConn(SelectAllBtn.MouseButton1Click:Connect(function()
                PlayClickSFX()
                for _, opt in ipairs(options) do
                    local s = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                    SetOptionSelected(s, true)
                end
                for k in pairs(itemRows) do
                    UpdateRowVisuals(k, true)
                end
                UpdateTitleDisplay()
                if isPriority then
                    RebuildItemRows(currentFilter)
                    UpdateDropdownHeight()
                end
                if onSelect then
                    pcall(onSelect, GetSelectedList(), nil, true)
                end
            end))
        end

        if ClearBtn then
            TrackConn(ClearBtn.MouseButton1Click:Connect(function()
                PlayClickSFX()
                selectedMap = {}
                selectedOrder = {}
                for k in pairs(itemRows) do
                    UpdateRowVisuals(k, true)
                end
                UpdateTitleDisplay()
                if isPriority then
                    RebuildItemRows(currentFilter)
                    UpdateDropdownHeight()
                end
                if onSelect then
                    pcall(onSelect, GetSelectedList(), nil, false)
                end
            end))
        end

        local function ConnectKeyboard()
            if keyboardConn then keyboardConn:Disconnect() keyboardConn = nil end
            highlightIndex = nil
            keyboardConn = UserInputService.InputBegan:Connect(function(input, gpe)
                if not isExpanded then return end
                if input.KeyCode == Enum.KeyCode.Escape then
                    if SearchInput and SearchInput:IsFocused() then SearchInput:ReleaseFocus() end
                    CloseDropdown()
                elseif input.KeyCode == Enum.KeyCode.Down then
                    if #visibleItems == 0 then return end
                    highlightIndex = (highlightIndex == nil) and 1 or math.min(#visibleItems, highlightIndex + 1)
                    UpdateHighlightVisuals()
                    local targetCanvasY = math.clamp((highlightIndex - 1) * (ROW_HEIGHT + 3) - 10, 0, 9999)
                    InnerScroll.CanvasPosition = Vector2.new(0, targetCanvasY)
                elseif input.KeyCode == Enum.KeyCode.Up then
                    if #visibleItems == 0 then return end
                    highlightIndex = (highlightIndex == nil) and #visibleItems or math.max(1, highlightIndex - 1)
                    UpdateHighlightVisuals()
                    local targetCanvasY = math.clamp((highlightIndex - 1) * (ROW_HEIGHT + 3) - 10, 0, 9999)
                    InnerScroll.CanvasPosition = Vector2.new(0, targetCanvasY)
                elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
                    if SearchInput and SearchInput:IsFocused() then SearchInput:ReleaseFocus() end
                    if highlightIndex and visibleItems[highlightIndex] then
                        local targetItem = visibleItems[highlightIndex]
                        if isMulti then
                            local optStr = tostring(targetItem.Opt)
                            selectedMap[optStr] = not selectedMap[optStr]
                            UpdateRowVisuals(optStr, true)
                            UpdateTitleDisplay()
                            if onSelect then
                                pcall(onSelect, GetSelectedList(), targetItem.Opt, selectedMap[optStr])
                            end
                        else
                            selectedOption = targetItem.Opt
                            UpdateTitleDisplay()
                            UpdateRowVisuals(tostring(selectedOption), true)
                            CloseDropdown()
                            if onSelect then
                                pcall(onSelect, selectedOption)
                            end
                        end
                    end
                end
            end)
        end

        local function OpenDropdown()
            if Window.ActiveDropdown and Window.ActiveDropdown ~= dropObj then
                pcall(function() Window.ActiveDropdown.Close() end)
            end
            Window.ActiveDropdown = dropObj
            isExpanded = true

            local overlay = Window.DropdownOverlay or MainContainer
            if DropdownContent.Parent ~= overlay then
                DropdownContent.Parent = overlay
            end

            if SearchInput then
                SearchInput.Text = ""
            end
            if type(dropConfig) == "table" and type(dropConfig.GetOptions) == "function" then
                local dynamicOpts = dropConfig.GetOptions()
                if type(dynamicOpts) == "table" then
                    options = dynamicOpts
                end
            end

            ApplyCardCorner(true)
            DropdownContent.BackgroundColor3 = DropdownFrame.BackgroundColor3
            DropdownContent.BackgroundTransparency = (inSection and Window.SectionsTransparent) and (Window.ElementsTransparency or 0.33) or DropdownFrame.BackgroundTransparency

            RebuildItemRows("")
            local scale = (UIScaleConstraint and UIScaleConstraint.Scale > 0) and UIScaleConstraint.Scale or 1
            local width = UpdateDropdownPos() or (DropdownFrame.AbsoluteSize.X / scale)

            local contentH = GetContentHeight()
            local neededH = topOffset + contentH + 5
            local targetHeight = math.clamp(neededH, topOffset + 32, 220)

            DropdownContent.Size = UDim2.new(0, width, 0, 0)
            DropdownContent.Visible = true

            TweenService:Create(ArrowIcon, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = 180}):Play()
            TweenService:Create(DropdownContent, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, width, 0, targetHeight)
            }):Play()

            -- Fade items in smoothly
            for _, item in ipairs(visibleItems) do
                local btn = item.Button
                local isSel = isMulti and (selectedMap[tostring(item.Opt)] == true) or (tostring(item.Opt) == tostring(selectedOption))
                local targetBgTrans = isMulti and (isSel and 0.45 or 0.85) or (isSel and 0.15 or 0.65)
                btn.BackgroundTransparency = 1
                if not isMulti then
                    btn.TextTransparency = 1
                    TweenService:Create(btn, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = targetBgTrans,
                        TextTransparency = 0
                    }):Play()
                else
                    if item.Label then
                        item.Label.TextTransparency = 1
                        TweenService:Create(item.Label, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
                    end
                    if item.BoxOuter then
                        item.BoxOuter.BackgroundTransparency = 1
                        local boxTarget = isSel and 0 or 0.2
                        TweenService:Create(item.BoxOuter, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = boxTarget }):Play()
                    end
                    TweenService:Create(btn, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = targetBgTrans }):Play()
                end
            end

            ConnectKeyboard()
        end

        TrackConn(HeaderTrigger.MouseEnter:Connect(function()
            PlayHoverSFX()
            local inSec = IsInsideSection(DropdownFrame)
            if not (inSec and Window.SectionsTransparent) then
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = math.max(0, (Window.ElementsTransparency or 0.33) - 0.12)
                }):Play()
            end
        end))

        TrackConn(HeaderTrigger.MouseLeave:Connect(function()
            local inSec = IsInsideSection(DropdownFrame)
            if not (inSec and Window.SectionsTransparent) then
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                }):Play()
            end
        end))

        TrackConn(HeaderTrigger.MouseButton1Click:Connect(function()
            PlayClickSFX()
            if isExpanded then
                CloseDropdown()
            else
                OpenDropdown()
            end
        end))

        -- Auto close when scrolling the tab
        local scrollParent = parent
        while scrollParent and not scrollParent:IsA("ScrollingFrame") and scrollParent ~= MainContainer do
            scrollParent = scrollParent.Parent
        end
        if scrollParent and scrollParent:IsA("ScrollingFrame") then
            TrackConn(scrollParent:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                if isExpanded then
                    CloseDropdown()
                end
            end))
        end

        TrackConn(DropdownFrame.AncestryChanged:Connect(function(_, newParent)
            if not newParent then
                if keyboardConn then keyboardConn:Disconnect() keyboardConn = nil end
                pcall(function() DropdownContent:Destroy() end)
            end
        end))

        dropObj = {
            Frame = DropdownFrame,
            CardFrame = DropdownFrame,
            Content = DropdownContent,
            Menu = DropdownContent,
            InnerScroll = InnerScroll,
            TitleText = TitleText,
            TitleLabel = TitleText,
            ArrowIcon = ArrowIcon,
            Close = CloseDropdown,
            SetTitle = function(selfOrTitle, maybeTitle)
                local newT = (maybeTitle ~= nil) and maybeTitle or selfOrTitle
                if type(newT) == "table" then
                    newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Title or newT.Name or newT.Text or newT[1] or ""
                end
                if type(newT) ~= "string" and type(newT) ~= "number" then
                    newT = ""
                end
                title = tostring(newT)
                UpdateTitleDisplay()
                return dropObj
            end,
            SetText = function(selfOrTitle, maybeTitle)
                return dropObj.SetTitle(selfOrTitle, maybeTitle)
            end,

            -- Single dropdown methods
            GetSelected = function() return selectedOption end,
            GetValue = function() return isMulti and GetSelectedList() or selectedOption end,
            SetSelected = function(selfOrOpt, maybeOpt, maybeTrigger)
                local opt, trigger
                if selfOrOpt == dropObj then opt = maybeOpt trigger = maybeTrigger
                else opt = selfOrOpt trigger = maybeOpt end
                selectedOption = opt
                UpdateTitleDisplay()
                for k in pairs(itemRows) do
                    UpdateRowVisuals(k, true)
                end
                if trigger and onSelect then onSelect(selectedOption) end
            end,
            SetValue = function(selfOrOpt, maybeOpt, maybeTrigger)
                return dropObj.SetSelected(selfOrOpt, maybeOpt, maybeTrigger)
            end,

            -- Multi dropdown methods
            GetSelections = GetSelectedList,
            GetSelectedList = GetSelectedList,
            SetSelections = function(selfOrSels, maybeSels, maybeTrigger)
                local sels, trigger
                if selfOrSels == dropObj then sels = maybeSels trigger = maybeTrigger
                else sels = selfOrSels trigger = maybeSels end
                selectedMap = {}
                selectedOrder = {}
                if type(sels) == "table" then
                    for k, v in pairs(sels) do
                        if type(k) == "number" then
                            local vStr = tostring(v)
                            if not selectedMap[vStr] then
                                selectedMap[vStr] = true
                                table.insert(selectedOrder, vStr)
                            end
                        elseif v == true then
                            local kStr = tostring(k)
                            if not selectedMap[kStr] then
                                selectedMap[kStr] = true
                                table.insert(selectedOrder, kStr)
                            end
                        end
                    end
                elseif type(sels) == "string" then
                    local sStr = tostring(sels)
                    selectedMap[sStr] = true
                    table.insert(selectedOrder, sStr)
                end
                UpdateTitleDisplay()
                for k in pairs(itemRows) do
                    UpdateRowVisuals(k, true)
                end
                if isPriority then
                    RebuildItemRows(currentFilter)
                end
                if trigger and onSelect then
                    pcall(onSelect, GetSelectedList(), nil, nil)
                end
            end,
            Clear = function(selfOrTrigger, maybeTrigger)
                local trigger = (selfOrTrigger == dropObj) and maybeTrigger or selfOrTrigger
                selectedMap = {}
                selectedOrder = {}
                UpdateTitleDisplay()
                for k in pairs(itemRows) do
                    UpdateRowVisuals(k, true)
                end
                if isPriority then
                    RebuildItemRows(currentFilter)
                end
                if trigger and onSelect then
                    pcall(onSelect, GetSelectedList())
                end
            end,
            Select = function(selfOrOpt, maybeOpt, maybeTrigger)
                local opt, trigger
                if selfOrOpt == dropObj then opt = maybeOpt trigger = maybeTrigger
                else opt = selfOrOpt trigger = maybeOpt end
                if opt then
                    local s = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                    SetOptionSelected(s, true)
                    UpdateTitleDisplay()
                    UpdateRowVisuals(s, true)
                    if isPriority then RebuildItemRows(currentFilter) UpdateDropdownHeight() end
                    if trigger and onSelect then pcall(onSelect, GetSelectedList(), opt, true) end
                end
            end,
            Deselect = function(selfOrOpt, maybeOpt, maybeTrigger)
                local opt, trigger
                if selfOrOpt == dropObj then opt = maybeOpt trigger = maybeTrigger
                else opt = selfOrOpt trigger = maybeOpt end
                if opt then
                    local s = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                    SetOptionSelected(s, false)
                    UpdateTitleDisplay()
                    UpdateRowVisuals(s, true)
                    if isPriority then RebuildItemRows(currentFilter) UpdateDropdownHeight() end
                    if trigger and onSelect then pcall(onSelect, GetSelectedList(), opt, false) end
                end
            end,
            Toggle = function(selfOrOpt, maybeOpt, maybeTrigger)
                local opt, trigger
                if selfOrOpt == dropObj then opt = maybeOpt trigger = maybeTrigger
                else opt = selfOrOpt trigger = maybeOpt end
                if opt then
                    local s = (type(opt) == "table") and tostring(opt.Name or opt.Text or opt[1]) or tostring(opt)
                    local cur = selectedMap[s] == true
                    SetOptionSelected(s, not cur)
                    UpdateTitleDisplay()
                    UpdateRowVisuals(s, true)
                    if isPriority then RebuildItemRows(currentFilter) UpdateDropdownHeight() end
                    if trigger and onSelect then pcall(onSelect, GetSelectedList(), opt, not cur) end
                end
            end,

            -- Shared options manipulation
            RefreshOptions = function(selfOrOpts, maybeOpts)
                local newOpts = (type(selfOrOpts) == "table" and selfOrOpts ~= dropObj) and selfOrOpts or maybeOpts or options
                options = newOpts
                RebuildItemRows(currentFilter)
                UpdateDropdownHeight()
            end,
            SetOptions = function(selfOrOpts, maybeOpts)
                local newOpts = (type(selfOrOpts) == "table" and selfOrOpts ~= dropObj) and selfOrOpts or maybeOpts or {}
                options = newOpts
                RebuildItemRows(currentFilter)
                UpdateDropdownHeight()
                return dropObj
            end,
            GetOptions = function() return options end,
            SetValues = function(selfOrOpts, maybeOpts) return dropObj.SetOptions(selfOrOpts, maybeOpts) end,
            GetValues = function() return options end,
            AddOption = function(selfOrOpt, maybeOpt)
                local newOpt = (type(selfOrOpt) == "string" or type(selfOrOpt) == "number") and selfOrOpt or maybeOpt
                if newOpt then
                    table.insert(options, tostring(newOpt))
                    RebuildItemRows(currentFilter)
                    UpdateDropdownHeight()
                end
                return dropObj
            end,
            RemoveOption = function(selfOrOpt, maybeOpt)
                local optToRemove = (type(selfOrOpt) == "string" or type(selfOrOpt) == "number") and tostring(selfOrOpt) or tostring(maybeOpt or "")
                for i, v in ipairs(options) do
                    if tostring(v) == optToRemove then
                        table.remove(options, i)
                        break
                    end
                end
                selectedMap[optToRemove] = nil
                if tostring(selectedOption) == optToRemove then
                    selectedOption = options[1] or ""
                    UpdateTitleDisplay()
                end
                RebuildItemRows(currentFilter)
                UpdateDropdownHeight()
                return dropObj
            end,
            ClearOptions = function()
                options = {}
                selectedOption = ""
                selectedMap = {}
                selectedOrder = {}
                UpdateTitleDisplay()
                RebuildItemRows(currentFilter)
                UpdateDropdownHeight()
                return dropObj
            end,

            SearchContainer = SearchContainer,
            SearchInput = SearchInput,
            WithSearch = function(self, enabled)
                isSearchable = (enabled ~= false)
                if SearchContainer then
                    SearchContainer.Visible = isSearchable
                end
                return dropObj
            end,
            RefreshTheme = function(theme)
                local inSec = IsInsideSection(DropdownFrame)
                DropdownFrame.BackgroundColor3 = theme.CardBG
                DropdownFrame.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                TitleText.TextColor3 = theme.Text
                ArrowIcon.ImageColor3 = theme.Text
                DropdownContent.BackgroundColor3 = theme.CardBG
                DropdownContent.BackgroundTransparency = (inSec and Window.SectionsTransparent) and (Window.ElementsTransparency or 0.33) or DropdownFrame.BackgroundTransparency
                if HeaderDivider then
                    HeaderDivider.BackgroundColor3 = theme.Divider or Color3.fromRGB(80, 85, 100)
                end
                if SearchContainer then
                    SearchContainer.BackgroundColor3 = GetThemedDarkColor(theme)
                end
                if SearchInput then
                    SearchInput.TextColor3 = theme.Text
                    SearchInput.PlaceholderColor3 = theme.SubText
                end
                for k in pairs(itemRows) do
                    UpdateRowVisuals(k, false)
                end
            end
        }

        dropObj.WithCallback = function(self, cb)
            onSelect = cb
            return self
        end
        dropObj.WithTooltip = function(self, tt)
            if Window.AttachTooltip and DropdownFrame then
                Window:AttachTooltip(DropdownFrame, tt)
            end
            return self
        end
        dropObj.WithSaveKey = function(self, key)
            if key and key ~= "" then
                self.SaveKey = key
                if isMulti then
                    Window.RegisteredMultiDropdowns[key] = self
                else
                    Window.RegisteredDropdowns[key] = self
                end
            end
            return self
        end
        dropObj.WithSelected = function(self, opt, triggerCb)
            self.SetSelected(opt, triggerCb)
            return self
        end
        dropObj.WithSelections = function(self, sels, triggerCb)
            self:SetSelections(sels, triggerCb)
            return self
        end
        dropObj.WithOptions = function(self, newOpts)
            return self.SetOptions(newOpts)
        end

        local saveKey = (dropConfig and type(dropConfig) == "table" and (dropConfig.SaveKey or dropConfig.saveKey or dropConfig.Identifier or dropConfig.identifier or dropConfig.Id or dropConfig.id)) or (title and title ~= "" and title) or ((isMulti and "MultiDropdown_" or "Dropdown_") .. (isMulti and (#Window.RegisteredMultiDropdownsList + 1) or (#Window.RegisteredDropdownsList + 1)))
        dropObj.SaveKey = saveKey
        dropObj.Name = saveKey

        if isMulti then
            if saveKey and saveKey ~= "" then
                Window.RegisteredMultiDropdowns[saveKey] = dropObj
            end
            if title and title ~= "" and not Window.RegisteredMultiDropdowns[title] then
                Window.RegisteredMultiDropdowns[title] = dropObj
            end
            if dropConfig and type(dropConfig) == "table" then
                local altId = dropConfig.Id or dropConfig.id or dropConfig.Identifier or dropConfig.identifier or dropConfig.SaveKey or dropConfig.saveKey
                if altId and not Window.RegisteredMultiDropdowns[altId] then
                    Window.RegisteredMultiDropdowns[altId] = dropObj
                end
            end
            table.insert(Window.RegisteredMultiDropdownsList, dropObj)
        else
            if saveKey and saveKey ~= "" then
                Window.RegisteredDropdowns[saveKey] = dropObj
            end
            if title and title ~= "" and not Window.RegisteredDropdowns[title] then
                Window.RegisteredDropdowns[title] = dropObj
            end
            if dropConfig and type(dropConfig) == "table" then
                local altId = dropConfig.Id or dropConfig.id or dropConfig.Identifier or dropConfig.identifier or dropConfig.SaveKey or dropConfig.saveKey
                if altId and not Window.RegisteredDropdowns[altId] then
                    Window.RegisteredDropdowns[altId] = dropObj
                end
            end
            table.insert(Window.RegisteredDropdownsList, dropObj)
        end

        if dropConfig and type(dropConfig) == "table" and (dropConfig.Tooltip or dropConfig.tooltip) then
            dropObj:WithTooltip(dropConfig.Tooltip or dropConfig.tooltip)
        end

        dropObj.DefaultOption = defaultVal
        dropObj.InitialOptions = (type(options) == "table") and table.clone(options) or {}

        RebuildItemRows("")
        return dropObj
    end

    function Window:CreateMDDropdown(parent, position, size, title, options, defaultOption, onSelect, dropConfig)
        return BuildGenericDropdown(false, parent, position, size, title, options, defaultOption, onSelect, dropConfig)
    end

    function Window:CreateMDMultiDropdown(parent, position, size, title, options, defaultSelections, onSelect, multiConfig)
        return BuildGenericDropdown(true, parent, position, size, title, options, defaultSelections, onSelect, multiConfig)
    end

    function Window:CreateMDPriorityDropdown(parent, position, size, title, options, defaultOrder, onSelect, dropConfig)
        dropConfig = (type(dropConfig) == "table") and table.clone(dropConfig) or {}
        dropConfig.Priority = true
        return BuildGenericDropdown("priority", parent, position, size, title, options, defaultOrder, onSelect, dropConfig)
    end

    function Window:CreateMDImageDropdown(parent, position, size, title, options, defaultOption, onSelect, dropConfig)
        dropConfig = (type(dropConfig) == "table") and table.clone(dropConfig) or {}
        dropConfig.HasIcons = true
        return BuildGenericDropdown(false, parent, position, size, title, options, defaultOption, onSelect, dropConfig)
    end

    function Window:CreateMDDropdownHalf(parent, position, size, title, options, defaultOption, onSelect)
        size = size or UDim2.new(0, 309, 0, 62)
        return Window:CreateMDDropdown(parent, position, size, title, options, defaultOption, onSelect)
    end

    function Window:CreateMDStatGrid(parent, position, size, config)
        parent = ResolveParent(parent)
        config = (type(config) == "table") and config or {}
        local inSection = IsInsideSection(parent)
        local columns = math.clamp(tonumber(config.Columns or config.columns) or 2, 1, 6)
        local stats = config.Stats or config.stats or {}
        local title = config.Title or config.title or ""

        local CardFrame = Instance.new("Frame")
        CardFrame.Name = GenerateSafeName("StatGrid")
        CardFrame:SetAttribute("MDCard", true)
        CardFrame.Size = size or UDim2.new(1, inSection and 0 or -10, 0, 0)
        CardFrame.AutomaticSize = Enum.AutomaticSize.Y
        CardFrame.Position = position or UDim2.new(0, 0, 0, 0)
        CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        CardFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
        CardFrame.BorderSizePixel = 0
        CardFrame.ZIndex = 10
        CardFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = CardFrame

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.Parent = CardFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 8)
        listLayout.Parent = CardFrame

        local TitleLabel = nil
        if title and title ~= "" then
            TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "StatGridTitle"
            TitleLabel.Size = UDim2.new(1, 0, 0, 18)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.FontFace = FontFingerPaintRegular
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Window.CurrentTheme.Text
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.ZIndex = 11
            TitleLabel.LayoutOrder = 1
            TitleLabel.Parent = CardFrame
        end

        local GridContainer = Instance.new("Frame")
        GridContainer.Name = "GridContainer"
        GridContainer.Size = UDim2.new(1, 0, 0, 0)
        GridContainer.AutomaticSize = Enum.AutomaticSize.Y
        GridContainer.BackgroundTransparency = 1
        GridContainer.BorderSizePixel = 0
        GridContainer.ZIndex = 11
        GridContainer.LayoutOrder = 2
        GridContainer.Parent = CardFrame

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
        gridLayout.CellSize = UDim2.new(1 / columns, -math.floor(6 * (columns - 1) / columns), 0, 56)
        gridLayout.Parent = GridContainer

        local statTiles = {}
        local statValues = {}

        local function CreateTile(statDef, idx)
            local sName = (type(statDef) == "table") and (statDef.Name or statDef.Title or statDef[1]) or tostring(statDef)
            local sVal = (type(statDef) == "table") and (statDef.Value or statDef.val or statDef[2]) or "0"
            local hasCustomColor = (type(statDef) == "table") and (statDef.Color ~= nil or statDef.color ~= nil)
            local accentColor = hasCustomColor and (statDef.Color or statDef.color) or Window.CurrentTheme.ButtonBG

            local Tile = Instance.new("Frame")
            Tile.Name = "Tile_" .. sName
            Tile.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
            Tile.BackgroundTransparency = 0.4
            Tile.BorderSizePixel = 0
            Tile.ZIndex = 12
            Tile.LayoutOrder = idx or (#GridContainer:GetChildren() + 1)
            Tile.ClipsDescendants = true
            Tile.Parent = GridContainer

            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(0, 8)
            tCorner.Parent = Tile

            local tStroke = Instance.new("UIStroke")
            tStroke.Thickness = 1
            tStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(60, 65, 80)
            tStroke.Transparency = 0.7
            tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            tStroke.Parent = Tile

            local showAccent = (hasCustomColor or config.ShowAccent == true or config.Accent == true or (type(statDef) == "table" and (statDef.Accent == true or statDef.ShowAccent == true)))

            local AccentBar = nil
            if showAccent then
                AccentBar = Instance.new("Frame")
                AccentBar.Name = "Accent"
                AccentBar.Size = UDim2.new(0, 3, 1, 0)
                AccentBar.Position = UDim2.new(0, 0, 0, 0)
                AccentBar.BackgroundColor3 = accentColor
                AccentBar.BackgroundTransparency = 0.2
                AccentBar.BorderSizePixel = 0
                AccentBar.ZIndex = 13
                AccentBar.Parent = Tile
            end

            local tPad = Instance.new("UIPadding")
            tPad.PaddingLeft = showAccent and UDim.new(0, 11) or UDim.new(0, 12)
            tPad.PaddingRight = UDim.new(0, 8)
            tPad.PaddingTop = UDim.new(0, 6)
            tPad.PaddingBottom = UDim.new(0, 6)
            tPad.Parent = Tile

            local NameText = Instance.new("TextLabel")
            NameText.Name = "Label"
            NameText.Size = UDim2.new(1, 0, 0, 14)
            NameText.Position = UDim2.new(0, 0, 0, 0)
            NameText.BackgroundTransparency = 1
            NameText.FontFace = FontFingerPaintRegular
            NameText.Text = sName
            NameText.TextColor3 = Window.CurrentTheme.SubText
            NameText.TextSize = 11
            NameText.TextTruncate = Enum.TextTruncate.AtEnd
            NameText.TextXAlignment = Enum.TextXAlignment.Left
            NameText.ZIndex = 13
            NameText.Parent = Tile

            local ValText = Instance.new("TextLabel")
            ValText.Name = "Value"
            ValText.Size = UDim2.new(1, 0, 0, 22)
            ValText.Position = UDim2.new(0, 0, 1, -26)
            ValText.BackgroundTransparency = 1
            ValText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            ValText.Text = tostring(sVal)
            ValText.TextColor3 = Window.CurrentTheme.Text
            ValText.TextSize = 17
            ValText.TextTruncate = Enum.TextTruncate.AtEnd
            ValText.TextXAlignment = Enum.TextXAlignment.Left
            ValText.ZIndex = 13
            ValText.Parent = Tile

            statTiles[sName] = {
                Tile = Tile,
                Stroke = tStroke,
                AccentBar = AccentBar,
                NameText = NameText,
                ValText = ValText,
                AccentColor = accentColor,
                HasCustomColor = hasCustomColor
            }
            statValues[sName] = sVal
        end

        for i, s in ipairs(stats) do
            CreateTile(s, i)
        end

        local gridObj
        gridObj = {
            Card = CardFrame,
            Set = function(selfOrName, maybeNameOrVal, maybeVal)
                local sName, sVal
                if type(selfOrName) == "string" then
                    sName = selfOrName
                    sVal = maybeNameOrVal
                else
                    sName = maybeNameOrVal
                    sVal = maybeVal
                end
                statValues[sName] = sVal
                local t = statTiles[sName]
                if t then
                    -- Numeric count-up tween
                    local newStr = tostring(sVal)
                    local numNew = tonumber(newStr:match("^(%d+%.?%d*)"))
                    local numOld = tonumber(t.ValText.Text:match("^(%d+%.?%d*)"))
                    if numNew and numOld and math.abs(numNew - numOld) > 0 and math.abs(numNew - numOld) < 50000 then
                        local suffix = newStr:match("^%d+%.?%d*(.*)") or ""
                        local steps = math.min(12, math.max(4, math.floor(math.abs(numNew - numOld) / 2)))
                        local inc = (numNew - numOld) / steps
                        local cur = numOld
                        task.spawn(function()
                            for _ = 1, steps do
                                cur = cur + inc
                                t.ValText.Text = (math.floor(cur + 0.5)) .. suffix
                                task.wait(0.016)
                            end
                            t.ValText.Text = newStr
                        end)
                    else
                        t.ValText.Text = newStr
                    end
                else
                    CreateTile({ Name = sName, Value = sVal }, #GridContainer:GetChildren() + 1)
                end
                return CardFrame
            end,
            Update = function(selfOrTbl, maybeTbl)
                local tbl = (type(selfOrTbl) == "table" and selfOrTbl ~= gridObj) and selfOrTbl or maybeTbl
                if type(tbl) == "table" then
                    for k, v in pairs(tbl) do
                        gridObj.Set(k, v)
                    end
                end
                return CardFrame
            end,
            Get = function(selfOrName, maybeName)
                local sName = (type(selfOrName) == "string") and selfOrName or maybeName
                return statValues[sName]
            end,
            RefreshTheme = function(theme)
                CardFrame.BackgroundColor3 = theme.CardBG
                if TitleLabel then TitleLabel.TextColor3 = theme.Text end
                for _, t in pairs(statTiles) do
                    t.Tile.BackgroundColor3 = GetThemedDarkColor(theme)
                    t.Stroke.Color = theme.Divider or Color3.fromRGB(60, 65, 80)
                    t.NameText.TextColor3 = theme.SubText
                    t.ValText.TextColor3 = theme.Text
                    if t.AccentBar then
                        t.AccentBar.BackgroundColor3 = t.HasCustomColor and t.AccentColor or theme.ButtonBG
                    end
                end
            end
        }
        table.insert(Window.RegisteredCustom, gridObj)
        return gridObj
    end

    function Window:CreateMDImageGrid(parent, position, size, config)
        parent = ResolveParent(parent)
        config = (type(config) == "table") and config or {}
        local inSection = IsInsideSection(parent)
        local title = config.Title or config.title or "Gallery"
        local items = config.Items or config.items or {}
        local columns = math.clamp(tonumber(config.Columns or config.columns) or 3, 1, 6)
        local isMulti = (config.Multi == true or config.multi == true)
        local callback = config.Callback or config.callback

        local CardFrame = Instance.new("Frame")
        CardFrame.Name = GenerateSafeName("ImageGrid")
        CardFrame:SetAttribute("MDCard", true)
        CardFrame.Size = size or UDim2.new(1, inSection and 0 or -10, 0, 0)
        CardFrame.AutomaticSize = Enum.AutomaticSize.Y
        CardFrame.Position = position or UDim2.new(0, 0, 0, 0)
        CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        CardFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
        CardFrame.BorderSizePixel = 0
        CardFrame.ZIndex = 10
        CardFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = CardFrame

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.Parent = CardFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 8)
        listLayout.Parent = CardFrame

        local HeaderFrame = Instance.new("Frame")
        HeaderFrame.Name = "Header"
        HeaderFrame.Size = UDim2.new(1, 0, 0, 20)
        HeaderFrame.BackgroundTransparency = 1
        HeaderFrame.ZIndex = 11
        HeaderFrame.LayoutOrder = 1
        HeaderFrame.Parent = CardFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.FontFace = FontFingerPaintRegular
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Window.CurrentTheme.Text
        TitleLabel.TextSize = 13
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 12
        TitleLabel.Parent = HeaderFrame

        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Name = "Status"
        StatusLabel.Size = UDim2.new(0.4, 0, 1, 0)
        StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.FontFace = FontFingerPaintRegular
        StatusLabel.Text = ""
        StatusLabel.TextColor3 = Window.CurrentTheme.SubText
        StatusLabel.TextSize = 11
        StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
        StatusLabel.ZIndex = 12
        StatusLabel.Parent = HeaderFrame

        local GridContainer = Instance.new("Frame")
        GridContainer.Name = "Grid"
        GridContainer.Size = UDim2.new(1, 0, 0, 0)
        GridContainer.AutomaticSize = Enum.AutomaticSize.Y
        GridContainer.BackgroundTransparency = 1
        GridContainer.BorderSizePixel = 0
        GridContainer.ZIndex = 11
        GridContainer.LayoutOrder = 2
        GridContainer.Parent = CardFrame

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
        gridLayout.CellSize = UDim2.new(1 / columns, -math.floor(6 * (columns - 1) / columns), 0, 92)
        gridLayout.Parent = GridContainer

        local selectedMap = {}
        local selectedOrder = {}
        local itemTiles = {}

        local def = config.Default or config.default
        if def then
            if type(def) == "table" then
                for _, v in pairs(def) do
                    local vStr = tostring(v)
                    selectedMap[vStr] = true
                    table.insert(selectedOrder, vStr)
                end
            else
                local vStr = tostring(def)
                selectedMap[vStr] = true
                table.insert(selectedOrder, vStr)
            end
        end

        local function UpdateVisuals()
            for name, tile in pairs(itemTiles) do
                local isSel = selectedMap[name] == true
                tile.Stroke.Color = isSel and Window.CurrentTheme.ButtonBG or (Window.CurrentTheme.Divider or Color3.fromRGB(60, 65, 80))
                tile.Stroke.Transparency = isSel and 0.1 or 0.7
                tile.Stroke.Thickness = isSel and 2 or 1
                tile.CheckBadge.Visible = isSel
                tile.NameLabel.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Window.CurrentTheme.SubText
                tile.NameLabel.FontFace = isSel and Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal) or FontFingerPaintRegular
            end
            if isMulti then
                local count = #selectedOrder
                StatusLabel.Text = (count > 0) and ("(" .. count .. " selected)") or "None"
            else
                StatusLabel.Text = selectedOrder[1] or "None"
            end
        end

        local function BuildTiles()
            for _, child in ipairs(GridContainer:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            itemTiles = {}
            for i, it in ipairs(items) do
                local itName = (type(it) == "table") and (it.Name or it.Title or it.Text or it[1]) or tostring(it)
                local itImg = (type(it) == "table") and (it.Image or it.Icon or it[2]) or ""
                local itImgStr = tostring(itImg)
                local imgAsset = (itImgStr ~= "" and not itImgStr:find("://")) and ("rbxassetid://" .. itImgStr) or itImgStr

                local Tile = Instance.new("TextButton")
                Tile.Name = "Tile_" .. itName
                Tile.Text = ""
                Tile.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
                Tile.BackgroundTransparency = 0.4
                Tile.BorderSizePixel = 0
                Tile.ZIndex = 12
                Tile.ClipsDescendants = false
                Tile.LayoutOrder = i
                Tile.Parent = GridContainer

                local tCorner = Instance.new("UICorner")
                tCorner.CornerRadius = UDim.new(0, 8)
                tCorner.Parent = Tile

                local tStroke = Instance.new("UIStroke")
                tStroke.Thickness = 1
                tStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(60, 65, 80)
                tStroke.Transparency = 0.7
                tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                tStroke.Parent = Tile

                -- Full-bleed image with matching UICorner
                local Img = Instance.new("ImageLabel")
                Img.Name = "Thumb"
                Img.Size = UDim2.new(1, 0, 1, 0)
                Img.Position = UDim2.new(0, 0, 0, 0)
                Img.BackgroundTransparency = 1
                Img.ImageTransparency = 0
                Img.Image = imgAsset
                Img.ScaleType = Enum.ScaleType.Crop
                Img.ZIndex = 13
                Img.Parent = Tile

                local imgCorner = Instance.new("UICorner")
                imgCorner.CornerRadius = UDim.new(0, 8)
                imgCorner.Parent = Img

                -- Separate overlay frame for bottom gradient fade
                local GradOverlay = Instance.new("Frame")
                GradOverlay.Name = "GradientOverlay"
                GradOverlay.Size = UDim2.new(1, 0, 0, 36)
                GradOverlay.Position = UDim2.new(0, 0, 1, -36)
                GradOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                GradOverlay.BackgroundTransparency = 0
                GradOverlay.BorderSizePixel = 0
                GradOverlay.ZIndex = 14
                GradOverlay.Parent = Tile

                local oCorner = Instance.new("UICorner")
                oCorner.CornerRadius = UDim.new(0, 8)
                oCorner.Parent = GradOverlay

                local Grad = Instance.new("UIGradient")
                Grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                })
                Grad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.3, 0.7),
                    NumberSequenceKeypoint.new(1, 0.2)
                })
                Grad.Rotation = 90
                Grad.Parent = GradOverlay

                -- Name label over gradient
                local NameLbl = Instance.new("TextLabel")
                NameLbl.Name = "Name"
                NameLbl.Size = UDim2.new(1, -8, 0, 18)
                NameLbl.Position = UDim2.new(0, 4, 1, -22)
                NameLbl.BackgroundTransparency = 1
                NameLbl.FontFace = FontFingerPaintRegular
                NameLbl.Text = itName
                NameLbl.TextColor3 = Window.CurrentTheme.SubText
                NameLbl.TextSize = 11
                NameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                NameLbl.TextXAlignment = Enum.TextXAlignment.Center
                NameLbl.ZIndex = 15
                NameLbl.Parent = Tile

                -- Selection check badge (top-right circle)
                local CheckBadge = Instance.new("Frame")
                CheckBadge.Name = "CheckBadge"
                CheckBadge.Size = UDim2.new(0, 16, 0, 16)
                CheckBadge.Position = UDim2.new(1, -20, 0, 4)
                CheckBadge.BackgroundColor3 = Window.CurrentTheme.ButtonBG
                CheckBadge.BorderSizePixel = 0
                CheckBadge.ZIndex = 16
                CheckBadge.Visible = false
                CheckBadge.Parent = Tile
                local cbCorner = Instance.new("UICorner")
                cbCorner.CornerRadius = UDim.new(0.5, 0)
                cbCorner.Parent = CheckBadge
                local checkIconId = Library:GetIcon("check") or "86817768619372"
                local checkIcon = Instance.new("ImageLabel")
                checkIcon.Size = UDim2.new(0, 10, 0, 10)
                checkIcon.Position = UDim2.new(0.5, -5, 0.5, -5)
                checkIcon.BackgroundTransparency = 1
                checkIcon.Image = tostring(checkIconId):find("://") and tostring(checkIconId) or ("rbxassetid://" .. tostring(checkIconId))
                checkIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                checkIcon.ZIndex = 17
                checkIcon.Parent = CheckBadge

                -- Hover scale effect
                local scaleObj = Instance.new("UIScale")
                scaleObj.Scale = 1
                scaleObj.Parent = Tile
                Tile.MouseEnter:Connect(function()
                    TweenService:Create(scaleObj, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.03}):Play()
                end)
                Tile.MouseLeave:Connect(function()
                    TweenService:Create(scaleObj, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
                end)

                itemTiles[itName] = {
                    Tile = Tile,
                    Stroke = tStroke,
                    Img = Img,
                    NameLabel = NameLbl,
                    CheckBadge = CheckBadge,
                    Item = it
                }

                Tile.MouseButton1Click:Connect(function()
                    PlayClickSFX()
                    if isMulti then
                        if selectedMap[itName] then
                            selectedMap[itName] = nil
                            for idx, v in ipairs(selectedOrder) do
                                if v == itName then table.remove(selectedOrder, idx) break end
                            end
                        else
                            selectedMap[itName] = true
                            table.insert(selectedOrder, itName)
                        end
                    else
                        selectedMap = { [itName] = true }
                        selectedOrder = { itName }
                    end
                    UpdateVisuals()
                    if callback then
                        if isMulti then
                            local selItems = {}
                            for _, v in ipairs(selectedOrder) do
                                table.insert(selItems, itemTiles[v] and itemTiles[v].Item or v)
                            end
                            pcall(callback, selItems, it)
                        else
                            pcall(callback, it)
                        end
                    end
                end)
            end
            UpdateVisuals()
        end

        BuildTiles()

        local galleryObj
        galleryObj = {
            Card = CardFrame,
            GetSelected = function()
                if isMulti then
                    local res = {}
                    for _, v in ipairs(selectedOrder) do
                        table.insert(res, itemTiles[v] and itemTiles[v].Item or v)
                    end
                    return res
                else
                    local s = selectedOrder[1]
                    return s and (itemTiles[s] and itemTiles[s].Item or s) or nil
                end
            end,
            SetSelected = function(selfOrSel, maybeSel, trigger)
                local sel, trig
                if type(selfOrSel) == "table" and (selfOrSel.GetSelected or selfOrSel.Card) then
                    sel = maybeSel trig = trigger
                else
                    sel = selfOrSel trig = maybeSel
                end
                selectedMap = {}
                selectedOrder = {}
                if isMulti and type(sel) == "table" then
                    for _, v in pairs(sel) do
                        local s = (type(v) == "table") and (v.Name or v.Title or v[1]) or tostring(v)
                        selectedMap[s] = true
                        table.insert(selectedOrder, s)
                    end
                elseif sel then
                    local s = (type(sel) == "table") and (sel.Name or sel.Title or sel[1]) or tostring(sel)
                    selectedMap[s] = true
                    table.insert(selectedOrder, s)
                end
                UpdateVisuals()
                if trig and callback then pcall(callback, galleryObj.GetSelected()) end
            end,
            SetItems = function(selfOrItems, maybeItems)
                local newItems = (type(selfOrItems) == "table" and (selfOrItems.GetSelected or selfOrItems.Card)) and maybeItems or selfOrItems
                items = newItems or {}
                BuildTiles()
            end,
            RefreshTheme = function(theme)
                CardFrame.BackgroundColor3 = theme.CardBG
                TitleLabel.TextColor3 = theme.Text
                UpdateVisuals()
            end
        }
        table.insert(Window.RegisteredCustom, galleryObj)
        return galleryObj
    end



    function Window:CreateMDPreview(parent, position, size, config)
        config = (type(config) == "table") and config or {}
        local title = config.Title or config.title or "Preview"
        local modalWidth = tonumber(config.Width or config.width) or 260
        local modalHeight = tonumber(config.Height or config.height)

        local modalParent = Window.MainContainer or MainContainer or ResolveParent(parent) or ScriptUi
        local targetPos = position or UDim2.new(1, 10, 0, 0)
        local targetSize = size or (modalHeight and UDim2.new(0, modalWidth, 0, modalHeight) or UDim2.new(0, modalWidth, 1, 0))

        local ModalFrame = Instance.new("Frame")
        ModalFrame.Name = GenerateSafeName("MDPreviewModal")
        ModalFrame:SetAttribute("MDCard", true)
        ModalFrame.Size = targetSize
        ModalFrame.Position = targetPos
        ModalFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        ModalFrame.BackgroundTransparency = Window.ElementsTransparency or 0.08
        ModalFrame.BorderSizePixel = 0
        ModalFrame.ClipsDescendants = false
        ModalFrame.ZIndex = 50
        ModalFrame.Visible = (config.DefaultOpen == true or config.Open == true or config.Visible == true)
        ModalFrame.Parent = modalParent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = ModalFrame

        local ModalStroke = Instance.new("UIStroke")
        ModalStroke.Thickness = 1
        ModalStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(50, 55, 70)
        ModalStroke.Transparency = 0.5
        ModalStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ModalStroke.Parent = ModalFrame

        AddUIShadow(ModalFrame, 22, 0.5)

        -- Header Bar
        local HeaderBar = Instance.new("Frame")
        HeaderBar.Name = "HeaderBar"
        HeaderBar.Size = UDim2.new(1, 0, 0, 36)
        HeaderBar.Position = UDim2.new(0, 0, 0, 0)
        HeaderBar.BackgroundTransparency = 1
        HeaderBar.BorderSizePixel = 0
        HeaderBar.ZIndex = 51
        HeaderBar.Parent = ModalFrame

        local HeaderEye = Instance.new("ImageLabel")
        HeaderEye.Name = "HeaderEye"
        HeaderEye.Size = UDim2.new(0, 16, 0, 16)
        HeaderEye.Position = UDim2.new(0, 12, 0.5, -8)
        HeaderEye.BackgroundTransparency = 1
        HeaderEye.Image = Library:GetIcon("eye") or "rbxassetid://127234874352422"
        HeaderEye.ImageColor3 = Window.CurrentTheme.ButtonBG
        HeaderEye.ZIndex = 52
        HeaderEye.Parent = HeaderBar

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "PreviewTitle"
        TitleLabel.Size = UDim2.new(1, -68, 1, 0)
        TitleLabel.Position = UDim2.new(0, 34, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.FontFace = FontFingerPaintRegular
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Window.CurrentTheme.Text
        TitleLabel.TextSize = 13
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 52
        TitleLabel.Parent = HeaderBar

        local CloseBtn = Instance.new("ImageButton")
        CloseBtn.Name = "CloseBtn"
        CloseBtn.Size = UDim2.new(0, 22, 0, 22)
        CloseBtn.Position = UDim2.new(1, -30, 0.5, -11)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Image = "rbxassetid://132261474823036"
        CloseBtn.ImageColor3 = Window.CurrentTheme.TextSecondary or Color3.fromRGB(160, 165, 180)
        CloseBtn.ZIndex = 52
        CloseBtn.Parent = HeaderBar

        local Sep = Instance.new("Frame")
        Sep.Name = "HeaderDivider"
        Sep.Size = UDim2.new(1, 0, 0, 1)
        Sep.Position = UDim2.new(0, 0, 0, 36)
        Sep.BackgroundColor3 = Window.CurrentTheme.Divider or Color3.fromRGB(45, 50, 65)
        Sep.BackgroundTransparency = 0.6
        Sep.BorderSizePixel = 0
        Sep.ZIndex = 51
        Sep.Parent = ModalFrame

        if AttachUniversalDrag and modalParent == (Window.MainContainer or MainContainer) then
            AttachUniversalDrag(HeaderBar, modalParent)
        end

        -- Content Canvas (100% EMPTY by default for the script maker)
        local CanvasFrame = Instance.new("Frame")
        CanvasFrame.Name = "Canvas"
        CanvasFrame.Size = UDim2.new(1, -16, 1, -46)
        CanvasFrame.Position = UDim2.new(0, 8, 0, 40)
        CanvasFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
        CanvasFrame.BackgroundTransparency = 0.25
        CanvasFrame.BorderSizePixel = 0
        CanvasFrame.ClipsDescendants = true
        CanvasFrame.ZIndex = 51
        CanvasFrame.Parent = ModalFrame

        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 8)
        cCorner.Parent = CanvasFrame

        local CanvasStroke = Instance.new("UIStroke")
        CanvasStroke.Thickness = 1
        CanvasStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(50, 55, 70)
        CanvasStroke.Transparency = 0.7
        CanvasStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        CanvasStroke.Parent = CanvasFrame

        local isOpen = ModalFrame.Visible
        local isAnimating = false
        local triggerCallbacks = {}
        local updateFn = config.Update or config.update

        local function NotifyTriggers(state)
            for _, fn in ipairs(triggerCallbacks) do
                pcall(fn, state)
            end
        end

        local previewObj = {
            Modal = ModalFrame,
            Card = ModalFrame,
            Frame = ModalFrame,
            Canvas = CanvasFrame,
            Content = CanvasFrame,
            Container = CanvasFrame,
            IsOpen = function() return isOpen end,
            GetCanvas = function() return CanvasFrame end,
            GetContainer = function() return CanvasFrame end,
            GetContent = function() return CanvasFrame end,
            AttachTrigger = function(selfOrFn, maybeFn)
                local fn = (type(selfOrFn) == "function") and selfOrFn or maybeFn
                if type(fn) == "function" then
                    table.insert(triggerCallbacks, fn)
                    pcall(fn, isOpen)
                end
            end,
            Show = function(self)
                if isAnimating then return end
                if Window.ActivePreviewModal and Window.ActivePreviewModal ~= previewObj then
                    pcall(function() Window.ActivePreviewModal:Hide() end)
                end
                Window.ActivePreviewModal = previewObj
                isOpen = true
                ModalFrame.Visible = true
                isAnimating = true
                local closedPos = UDim2.new(1, 0, targetPos.Y.Scale, targetPos.Y.Offset)
                ModalFrame.Position = closedPos
                local showTween = TweenService:Create(ModalFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = targetPos
                })
                showTween.Completed:Connect(function()
                    isAnimating = false
                end)
                showTween:Play()
                NotifyTriggers(true)
                if config.OnOpen then pcall(config.OnOpen, CanvasFrame) end
            end,
            Hide = function(self)
                if isAnimating then return end
                if Window.ActivePreviewModal == previewObj then
                    Window.ActivePreviewModal = nil
                end
                isOpen = false
                isAnimating = true
                local closedPos = UDim2.new(1, 0, targetPos.Y.Scale, targetPos.Y.Offset)
                local hideTween = TweenService:Create(ModalFrame, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                    Position = closedPos
                })
                hideTween.Completed:Connect(function()
                    if not isOpen then
                        ModalFrame.Visible = false
                    end
                    isAnimating = false
                end)
                hideTween:Play()
                NotifyTriggers(false)
                if config.OnClose then pcall(config.OnClose, CanvasFrame) end
            end,
            Toggle = function(self)
                if isOpen then
                    self:Hide()
                else
                    self:Show()
                end
            end,
            SetTitle = function(selfOrTitle, maybeTitle)
                local newT = (type(selfOrTitle) == "string") and selfOrTitle or maybeTitle
                if newT then TitleLabel.Text = tostring(newT) end
            end,
            SetSize = function(selfOrW, maybeW, maybeH)
                local w = (type(selfOrW) == "number") and selfOrW or maybeW
                local h = (type(selfOrW) == "number") and maybeW or maybeH
                if w and h then
                    targetSize = UDim2.new(0, w, 0, h)
                elseif w then
                    targetSize = UDim2.new(0, w, 1, 0)
                end
                ModalFrame.Size = targetSize
            end,
            Clear = function(self)
                for _, child in ipairs(CanvasFrame:GetChildren()) do
                    if child ~= cCorner and child ~= CanvasStroke then
                        child:Destroy()
                    end
                end
            end,
            SetUpdate = function(selfOrFn, maybeFn)
                local fn = (type(selfOrFn) == "function") and selfOrFn or maybeFn
                updateFn = fn
            end,
            Update = function(selfOrData, ...)
                if updateFn then
                    pcall(updateFn, CanvasFrame, selfOrData, ...)
                end
            end,
            CreateMockPlayer = function(self, opts)
                opts = (type(opts) == "table") and opts or {}
                local dummy = Instance.new("Frame")
                dummy.Name = "MockPlayer"
                dummy.Size = UDim2.new(0, 48, 0, 96)
                dummy.Position = opts.Position or UDim2.new(0.5, -24, 0.5, -48)
                dummy.BackgroundTransparency = 1
                dummy.ZIndex = 53
                dummy.Parent = CanvasFrame

                local torso = Instance.new("Frame")
                torso.Name = "Torso"
                torso.Size = UDim2.new(0, 24, 0, 36)
                torso.Position = UDim2.new(0.5, -12, 0, 20)
                torso.BackgroundColor3 = opts.ChamsColor or Color3.fromRGB(90, 100, 120)
                torso.BorderSizePixel = 0
                torso.ZIndex = 54
                torso.Parent = dummy

                local head = Instance.new("Frame")
                head.Name = "Head"
                head.Size = UDim2.new(0, 16, 0, 16)
                head.Position = UDim2.new(0.5, -8, 0, 2)
                head.BackgroundColor3 = opts.ChamsColor or Color3.fromRGB(110, 120, 140)
                head.BorderSizePixel = 0
                head.ZIndex = 54
                head.Parent = dummy
                local hCorner = Instance.new("UICorner")
                hCorner.CornerRadius = UDim.new(0.5, 0)
                hCorner.Parent = head

                local leftArm = Instance.new("Frame")
                leftArm.Name = "LeftArm"
                leftArm.Size = UDim2.new(0, 8, 0, 34)
                leftArm.Position = UDim2.new(0.5, -22, 0, 20)
                leftArm.BackgroundColor3 = opts.ChamsColor or Color3.fromRGB(80, 90, 110)
                leftArm.BorderSizePixel = 0
                leftArm.ZIndex = 54
                leftArm.Parent = dummy

                local rightArm = Instance.new("Frame")
                rightArm.Name = "RightArm"
                rightArm.Size = UDim2.new(0, 8, 0, 34)
                rightArm.Position = UDim2.new(0.5, 14, 0, 20)
                rightArm.BackgroundColor3 = opts.ChamsColor or Color3.fromRGB(80, 90, 110)
                rightArm.BorderSizePixel = 0
                rightArm.ZIndex = 54
                rightArm.Parent = dummy

                local leftLeg = Instance.new("Frame")
                leftLeg.Name = "LeftLeg"
                leftLeg.Size = UDim2.new(0, 10, 0, 38)
                leftLeg.Position = UDim2.new(0.5, -11, 0, 58)
                leftLeg.BackgroundColor3 = opts.ChamsColor or Color3.fromRGB(70, 80, 100)
                leftLeg.BorderSizePixel = 0
                leftLeg.ZIndex = 54
                leftLeg.Parent = dummy

                local rightLeg = Instance.new("Frame")
                rightLeg.Name = "RightLeg"
                rightLeg.Size = UDim2.new(0, 10, 0, 38)
                rightLeg.Position = UDim2.new(0.5, 1, 0, 58)
                rightLeg.BackgroundColor3 = opts.ChamsColor or Color3.fromRGB(70, 80, 100)
                rightLeg.BorderSizePixel = 0
                rightLeg.ZIndex = 54
                rightLeg.Parent = dummy

                local boxOutline = Instance.new("Frame")
                boxOutline.Name = "ESPBox"
                boxOutline.Size = UDim2.new(1, 12, 1, 10)
                boxOutline.Position = UDim2.new(0, -6, 0, -5)
                boxOutline.BackgroundTransparency = 1
                boxOutline.ZIndex = 55
                boxOutline.Parent = dummy

                local boxStroke = Instance.new("UIStroke")
                boxStroke.Thickness = 1.5
                boxStroke.Color = opts.BoxColor or Color3.fromRGB(255, 60, 60)
                boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                boxStroke.Parent = boxOutline

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "ESPName"
                nameLbl.Size = UDim2.new(0, 140, 0, 14)
                nameLbl.Position = UDim2.new(0.5, 0, 0, -22)
                nameLbl.AnchorPoint = Vector2.new(0.5, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.FontFace = FontFingerPaintRegular
                nameLbl.Text = opts.Name or "TargetPlayer [100m]"
                nameLbl.TextColor3 = opts.NameColor or Color3.fromRGB(255, 255, 255)
                nameLbl.TextSize = 11
                nameLbl.ZIndex = 55
                nameLbl.Parent = dummy

                local hbBg = Instance.new("Frame")
                hbBg.Name = "HealthbarBg"
                hbBg.Size = UDim2.new(0, 3, 1, 10)
                hbBg.Position = UDim2.new(0, -12, 0, -5)
                hbBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                hbBg.BorderSizePixel = 0
                hbBg.ZIndex = 55
                hbBg.Parent = dummy

                local hbFill = Instance.new("Frame")
                hbFill.Name = "HealthbarFill"
                hbFill.Size = UDim2.new(1, 0, opts.Health and (opts.Health / 100) or 1, 0)
                hbFill.Position = UDim2.new(0, 0, 1 - (opts.Health and (opts.Health / 100) or 1), 0)
                hbFill.BackgroundColor3 = opts.HealthColor or Color3.fromRGB(50, 230, 110)
                hbFill.BorderSizePixel = 0
                hbFill.ZIndex = 56
                hbFill.Parent = hbBg

                return {
                    Dummy = dummy,
                    Torso = torso,
                    Head = head,
                    LeftArm = leftArm,
                    RightArm = rightArm,
                    LeftLeg = leftLeg,
                    RightLeg = rightLeg,
                    Box = boxOutline,
                    BoxStroke = boxStroke,
                    Name = nameLbl,
                    HealthbarBg = hbBg,
                    HealthbarFill = hbFill
                }
            end,
            RefreshTheme = function(theme)
                ModalFrame.BackgroundColor3 = theme.CardBG
                TitleLabel.TextColor3 = theme.Text
                HeaderEye.ImageColor3 = theme.ButtonBG
                ModalStroke.Color = theme.Divider or Color3.fromRGB(50, 55, 70)
                CanvasStroke.Color = theme.Divider or Color3.fromRGB(50, 55, 70)
                CloseBtn.ImageColor3 = theme.TextSecondary or Color3.fromRGB(160, 165, 180)
                Sep.BackgroundColor3 = theme.Divider or Color3.fromRGB(45, 50, 65)
            end
        }

        CloseBtn.MouseEnter:Connect(function()
            PlayHoverSFX()
            TweenService:Create(CloseBtn, TweenInfo.new(0.12), { ImageColor3 = Window.CurrentTheme.Text }):Play()
        end)
        CloseBtn.MouseLeave:Connect(function()
            TweenService:Create(CloseBtn, TweenInfo.new(0.12), { ImageColor3 = Window.CurrentTheme.TextSecondary or Color3.fromRGB(160, 165, 180) }):Play()
        end)
        CloseBtn.MouseButton1Click:Connect(function()
            PlayClickSFX()
            previewObj:Hide()
        end)

        if updateFn then
            pcall(updateFn, CanvasFrame)
        end
        table.insert(Window.RegisteredCustom, previewObj)
        return previewObj
    end

    function Window:CreateMDPreviewButton(parent, position, size, previewObjOrConfig, buttonTitle)
        parent = ResolveParent(parent)
        local inSection = IsInsideSection(parent)
        local title = buttonTitle or (type(previewObjOrConfig) == "table" and previewObjOrConfig.Title) or "Live Preview"
        local preview = nil
        if type(previewObjOrConfig) == "table" and (previewObjOrConfig.Toggle or previewObjOrConfig.Show) then
            preview = previewObjOrConfig
        else
            preview = Window:CreateMDPreview(nil, nil, nil, (type(previewObjOrConfig) == "table") and previewObjOrConfig or { Title = title })
        end

        local CardFrame = Instance.new("Frame")
        CardFrame.Name = GenerateSafeName("PreviewTriggerCard")
        CardFrame:SetAttribute("MDCard", true)
        CardFrame.Size = size or UDim2.new(1, inSection and 0 or -10, 0, 44)
        CardFrame.Position = position or UDim2.new(0, 0, 0, 0)
        CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        CardFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
        CardFrame.BorderSizePixel = 0
        CardFrame.ZIndex = 10
        CardFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = CardFrame

        if not inSection or not Window.SectionsTransparent then
            AddUIShadow(CardFrame, 20, 0.5)
        end

        local EyeIcon = Instance.new("ImageLabel")
        EyeIcon.Name = "TriggerEye"
        EyeIcon.Size = UDim2.new(0, 18, 0, 18)
        EyeIcon.Position = UDim2.new(0, 12, 0.5, -9)
        EyeIcon.BackgroundTransparency = 1
        EyeIcon.Image = Library:GetIcon("eye") or "rbxassetid://127234874352422"
        EyeIcon.ImageColor3 = Window.CurrentTheme.ButtonBG
        EyeIcon.ZIndex = 11
        EyeIcon.Parent = CardFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Size = UDim2.new(1, -110, 1, 0)
        TitleLabel.Position = UDim2.new(0, 36, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.FontFace = FontFingerPaintRegular
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Window.CurrentTheme.Text
        TitleLabel.TextSize = 13
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 11
        TitleLabel.Parent = CardFrame

        local TriggerPill = Instance.new("TextButton")
        TriggerPill.Name = "OpenPreviewPill"
        TriggerPill.Size = UDim2.new(0, 60, 0, 24)
        TriggerPill.Position = UDim2.new(1, -70, 0.5, -12)
        TriggerPill.BackgroundColor3 = Window.CurrentTheme.Divider or Color3.fromRGB(45, 50, 65)
        TriggerPill.BackgroundTransparency = 0.4
        TriggerPill.FontFace = FontFingerPaintRegular
        TriggerPill.Text = "View"
        TriggerPill.TextColor3 = Window.CurrentTheme.TextSecondary or Color3.fromRGB(200, 205, 220)
        TriggerPill.TextSize = 12
        TriggerPill.ZIndex = 12
        TriggerPill.Parent = CardFrame

        local pillCorner = Instance.new("UICorner")
        pillCorner.CornerRadius = UDim.new(0, 8)
        pillCorner.Parent = TriggerPill

        local function UpdateVisuals(isOpen)
            if isOpen then
                TriggerPill.BackgroundColor3 = Window.CurrentTheme.ButtonBG
                TriggerPill.BackgroundTransparency = 0.1
                TriggerPill.TextColor3 = GetOnAccent(Window.CurrentTheme.ButtonBG)
                TriggerPill.Text = "Close"
                EyeIcon.ImageColor3 = Window.CurrentTheme.ButtonBG
            else
                TriggerPill.BackgroundColor3 = Window.CurrentTheme.Divider or Color3.fromRGB(45, 50, 65)
                TriggerPill.BackgroundTransparency = 0.4
                TriggerPill.TextColor3 = Window.CurrentTheme.TextSecondary or Color3.fromRGB(200, 205, 220)
                TriggerPill.Text = "View"
                EyeIcon.ImageColor3 = Window.CurrentTheme.ButtonBG
            end
        end

        TriggerPill.MouseButton1Click:Connect(function()
            PlayClickSFX()
            preview:Toggle()
        end)

        local ClickDetector = Instance.new("TextButton")
        ClickDetector.Name = "CardClick"
        ClickDetector.Size = UDim2.new(1, -75, 1, 0)
        ClickDetector.Position = UDim2.new(0, 0, 0, 0)
        ClickDetector.BackgroundTransparency = 1
        ClickDetector.Text = ""
        ClickDetector.ZIndex = 11
        ClickDetector.Parent = CardFrame
        ClickDetector.MouseButton1Click:Connect(function()
            PlayClickSFX()
            preview:Toggle()
        end)

        if preview.AttachTrigger then
            preview:AttachTrigger(function(isOpen)
                UpdateVisuals(isOpen)
            end)
        end

        local triggerObj = {
            Card = CardFrame,
            Preview = preview,
            RefreshTheme = function(theme)
                CardFrame.BackgroundColor3 = theme.CardBG
                TitleLabel.TextColor3 = theme.Text
                EyeIcon.ImageColor3 = theme.ButtonBG
                UpdateVisuals(preview:IsOpen())
            end
        }
        table.insert(Window.RegisteredCustom, triggerObj)
        return triggerObj, preview
    end

    function Window:CreateMDSubTabs(parentTab, tabNamesOrConfig, defaultSubTab)
        local tabsList = {}
        local defaultTabName = nil
        local iconsMap = {}
        if type(tabNamesOrConfig) == "table" then
            if tabNamesOrConfig.Tabs or tabNamesOrConfig.tabs then
                tabsList = tabNamesOrConfig.Tabs or tabNamesOrConfig.tabs or {}
                defaultTabName = tabNamesOrConfig.Default or tabNamesOrConfig.default or tabsList[1]
                iconsMap = tabNamesOrConfig.Icons or tabNamesOrConfig.icons or {}
            else
                tabsList = tabNamesOrConfig
                defaultTabName = defaultSubTab or tabsList[1]
            end
        end

        local ContentFrame = parentTab.Content or parentTab.ContentFrame or parentTab.Container or parentTab.ItemContainer or parentTab
        local hasSubTabs = (tabsList and #tabsList > 0)

        if hasSubTabs then
            parentTab.HasSubTabs = true
            ContentFrame.Position = UDim2.new(0, 0, 0, 34)
            ContentFrame.Size = UDim2.new(1, 0, 1, -34)
        end

        local SubTabBar = Instance.new("Frame")
        SubTabBar.Name = "SubTabBar_" .. tostring(parentTab.Name or "Tab")
        SubTabBar.Size = UDim2.new(1, 0, 0, 34)
        SubTabBar.Position = UDim2.new(0, 0, 0, 0)
        SubTabBar.BackgroundColor3 = Window.CurrentTheme.MainBG
        SubTabBar.BackgroundTransparency = 1
        SubTabBar.BorderSizePixel = 0
        SubTabBar.ZIndex = 5
        SubTabBar.Visible = (Window.ActiveTab == parentTab.Name and hasSubTabs)
        SubTabBar.Parent = MainContentFrame or parentTab.Container or ContentFrame.Parent
        parentTab.SubTabBar = SubTabBar

        local TabsHolder = Instance.new("Frame")
        TabsHolder.Name = "TabsHolder"
        TabsHolder.Size = UDim2.new(1, -12, 1, -8)
        TabsHolder.Position = UDim2.new(0, 6, 0, 4)
        TabsHolder.BackgroundTransparency = 1
        TabsHolder.BorderSizePixel = 0
        TabsHolder.ZIndex = 6
        TabsHolder.Parent = SubTabBar

        -- Moving indicator pill that glides behind the active subtab
        local SUBTAB_FRAME_TRANSPARENCY = 0.4

        local ActiveIndicator = Instance.new("Frame")
        ActiveIndicator.Name = "ActiveIndicator"
        ActiveIndicator.Size = UDim2.new(0, 0, 1, 0)
        ActiveIndicator.Position = UDim2.new(0, 0, 0, 0)
        ActiveIndicator.BackgroundColor3 = Window.CurrentTheme.ButtonBG
        ActiveIndicator.BackgroundTransparency = SUBTAB_FRAME_TRANSPARENCY
        ActiveIndicator.BorderSizePixel = 0
        ActiveIndicator.ZIndex = 6
        ActiveIndicator.Parent = TabsHolder

        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 6)
        IndicatorCorner.Parent = ActiveIndicator

        -- Isolated container for buttons to avoid UIListLayout interfering with indicator
        local ButtonsContainer = Instance.new("Frame")
        ButtonsContainer.Name = "ButtonsContainer"
        ButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
        ButtonsContainer.Position = UDim2.new(0, 0, 0, 0)
        ButtonsContainer.BackgroundTransparency = 1
        ButtonsContainer.BorderSizePixel = 0
        ButtonsContainer.ZIndex = 7
        ButtonsContainer.Parent = TabsHolder

        local pillList = Instance.new("UIListLayout")
        pillList.FillDirection = Enum.FillDirection.Horizontal
        pillList.SortOrder = Enum.SortOrder.LayoutOrder
        pillList.Padding = UDim.new(0, 6)
        pillList.Parent = ButtonsContainer

        local activeTab = defaultTabName or (tabsList[1] and tostring(tabsList[1])) or "Tab"
        local pillButtons = {}
        local tabOrder = {}
        local subContainers = {}
        local subObjects = {}
        local pillCount = math.max(#tabsList, 1)
        local pillGap = 6

        local function UpdateIndicator(animated)
            local btn = pillButtons[activeTab]
            local idx = (btn and tabOrder[activeTab]) or tabOrder[activeTab] or 1

            local wScale = 1 / pillCount
            local wOffset = -math.floor(pillGap * (pillCount - 1) / pillCount)

            local targetPos = UDim2.new((idx - 1) * wScale, (idx - 1) * (wOffset + pillGap), 0, 0)
            local targetSize = UDim2.new(wScale, wOffset, 1, 0)

            local curTheme = Window.CurrentTheme or Library.CurrentTheme
            local targetBg = curTheme.ButtonBG

            if animated then
                TweenService:Create(ActiveIndicator, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = targetPos,
                    Size = targetSize,
                    BackgroundColor3 = targetBg
                }):Play()
            else
                ActiveIndicator.Position = targetPos
                ActiveIndicator.Size = targetSize
                ActiveIndicator.BackgroundColor3 = targetBg
            end
        end

        parentTab.UpdateSubTabIndicator = UpdateIndicator

        local function SwitchSubTab(targetTab, animated)
            if animated == nil then animated = true end
            activeTab = targetTab
            local curTheme = Window.CurrentTheme or Library.CurrentTheme
            local onAccent = GetOnAccent(curTheme.ButtonBG)
            local subText = curTheme.SubText

            for tName, btn in pairs(pillButtons) do
                local isActive = (tName == activeTab)
                local textCol = isActive and onAccent or subText
                btn.BackgroundTransparency = 1
                if animated then
                    TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextColor3 = textCol
                    }):Play()
                else
                    btn.TextColor3 = textCol
                end
            end

            for tName, cFrame in pairs(subContainers) do
                cFrame.Visible = (tName == activeTab)
            end

            UpdateIndicator(animated)
        end

        local function CreateSubTabContainer(tName, order)
            local SubFrame = Instance.new("Frame")
            SubFrame.Name = "SubTab_" .. tName
            SubFrame.Size = UDim2.new(1, 0, 0, 0)
            SubFrame.AutomaticSize = Enum.AutomaticSize.Y
            SubFrame.BackgroundTransparency = 1
            SubFrame.BorderSizePixel = 0
            SubFrame.ZIndex = 11
            SubFrame.LayoutOrder = order or 1
            SubFrame.Visible = (tName == activeTab)
            SubFrame.Parent = ContentFrame

            local subLayout = Instance.new("UIListLayout")
            subLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subLayout.Padding = UDim.new(0, 8)
            subLayout.Parent = SubFrame

            local subObj = {
                Name = tName,
                Container = SubFrame,
                ItemContainer = SubFrame,
                CurrentSectionContainer = SubFrame,
            }

            local current = SubFrame
            setmetatable(subObj, {
                __index = function(tbl, key)
                    local member = parentTab[key]
                    if type(member) == "function" and key:sub(1, 3) == "Add" then
                        return function(self, ...)
                            local prevC = parentTab.CurrentSectionContainer
                            local prevH = parentTab._sectionHost
                            parentTab.CurrentSectionContainer = current
                            parentTab._sectionHost = SubFrame
                            local ok, r1, r2, r3 = pcall(member, parentTab, ...)
                            if key == "AddSection" and ok then
                                current = parentTab.CurrentSectionContainer
                            end
                            parentTab.CurrentSectionContainer = prevC
                            parentTab._sectionHost = prevH
                            if not ok then error(r1, 2) end
                            return r1, r2, r3
                        end
                    end
                    return member
                end
            })

            subContainers[tName] = SubFrame
            subObjects[tName] = subObj
            return subObj
        end

        for i, tNameRaw in ipairs(tabsList) do
            local tName = tostring(tNameRaw)
            tabOrder[tName] = i

            local PillBtn = Instance.new("TextButton")
            PillBtn.Name = "Pill_" .. tName
            PillBtn.Size = UDim2.new(1 / pillCount, -math.floor(pillGap * (pillCount - 1) / pillCount), 1, 0)
            PillBtn.BackgroundTransparency = 1
            PillBtn.BorderSizePixel = 0
            PillBtn.FontFace = FontBold
            PillBtn.Text = tName
            PillBtn.TextColor3 = (tName == activeTab) and GetOnAccent(Window.CurrentTheme.ButtonBG) or Window.CurrentTheme.SubText
            PillBtn.TextSize = 12
            PillBtn.ZIndex = 14
            PillBtn.LayoutOrder = i
            PillBtn.Parent = ButtonsContainer

            local pillCorner = Instance.new("UICorner")
            pillCorner.CornerRadius = UDim.new(0, 6)
            pillCorner.Parent = PillBtn

            pillButtons[tName] = PillBtn
            CreateSubTabContainer(tName, i)

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(PillBtn, tNameRaw, function(newText)
                    if type(newText) == "table" then
                        newText = newText[Window.CurrentLanguage or "English"] or newText["English"] or newText[1] or tName
                    end
                    PillBtn.Text = tostring(newText or tName)
                end)
            end

            PillBtn.MouseButton1Click:Connect(function()
                PlayClickSFX()
                SwitchSubTab(tName, true)
            end)
        end

        ButtonsContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            UpdateIndicator(false)
        end)

        task.defer(function()
            if ButtonsContainer and ButtonsContainer.Parent then
                SwitchSubTab(activeTab, false)
            end
        end)

        local stObj = {
            Container = ContentFrame,
            SubTabBar = SubTabBar,
            PillBar = SubTabBar,
            ActiveIndicator = ActiveIndicator,
            Get = function(selfOrName, maybeName)
                local name = (type(selfOrName) == "string") and selfOrName or maybeName
                return subObjects[name]
            end,
            GetSubTab = function(selfOrName, maybeName)
                local name = (type(selfOrName) == "string") and selfOrName or maybeName
                return subObjects[name]
            end,
            Select = function(selfOrName, maybeName)
                local name = (type(selfOrName) == "string") and selfOrName or maybeName
                SwitchSubTab(name, true)
            end,
            GetCurrent = function()
                return activeTab
            end,
            RefreshTheme = function(theme, animated)
                local barBg = theme.MainBG
                if animated then
                    local twInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    TweenService:Create(SubTabBar, twInfo, { BackgroundColor3 = barBg, BackgroundTransparency = 1 }):Play()
                    TweenService:Create(ActiveIndicator, twInfo, { BackgroundColor3 = theme.ButtonBG }):Play()
                else
                    SubTabBar.BackgroundColor3 = barBg
                    SubTabBar.BackgroundTransparency = 1
                    ActiveIndicator.BackgroundColor3 = theme.ButtonBG
                    ActiveIndicator.BackgroundTransparency = SUBTAB_FRAME_TRANSPARENCY
                end
                SwitchSubTab(activeTab, animated)
            end
        }

        Window.RegisteredSubTabs = Window.RegisteredSubTabs or {}
        table.insert(Window.RegisteredSubTabs, stObj)

        return stObj
    end

    -- ==========================================
    -- Localization / Multi-Language System
    -- ==========================================

    local BuiltinLibraryTranslations = {
        Russian = {
            ["Settings"] = "Настройки",
            ["Language"] = "Язык",
            ["Interface language"] = "Язык интерфейса",
            ["Audio & Notifications"] = "Звуки и уведомления",
            ["Enable notifications"] = "Включить уведомления",
            ["Notifications enabled"] = "Уведомления включены",
            ["Enable UI sounds"] = "Включить звуки интерфейса",
            ["UI sounds enabled"] = "Звуки UI включены",
            ["UI sound volume"] = "Громкость звуков UI",
            ["Hover sound ID"] = "ID звука наведения",
            ["Click sound ID"] = "ID звука клика",
            ["Notification sound ID"] = "ID звука уведомления",
            ["Appearance & Visuals"] = "Внешний вид и визуалы",
            ["Spiderweb background"] = "Фоновая паутинка",
            ["Background blur"] = "Размытие фона",
            ["UI shadows"] = "Тени интерфейса",
            ["Section backgrounds"] = "Фон секций",
            ["Background noise"] = "Шумовой фон",
            ["Streamer mode"] = "Режим стримера",
            ["Noise tile size"] = "Размер зерна шума",
            ["Background transparency"] = "Прозрачность фона",
            ["UI elements transparency"] = "Прозрачность элементов",
            ["Top, left & bottom frames transparency"] = "Прозрачность панелей",
            ["Blur intensity"] = "Интенсивность размытия",
            ["Shadow intensity"] = "Интенсивность теней",
            ["Click Effects & Particles"] = "Эффекты и частицы клика",
            ["Enable click effects"] = "Включить эффекты клика",
            ["Particle style"] = "Стиль частиц",
            ["Theme default"] = "По умолчанию темы",
            ["Custom image"] = "Своё изображение",
            ["Custom image ID"] = "ID своего изображения",
            ["Themes"] = "Темы",
            ["Custom theme color"] = "Кастомный цвет темы",
            ["Configurations"] = "Конфигурации",
            ["Config name"] = "Название конфига",
            ["Create config"] = "Создать конфиг",
            ["Delete config"] = "Удалить конфиг",
            ["Save config"] = "Сохранить конфиг",
            ["Load config"] = "Загрузить конфиг",
            ["Export config"] = "Экспорт конфига",
            ["Import config"] = "Импорт конфига",
            ["Autoload config"] = "Автозагрузка конфига",
            ["Autoload config: None"] = "Автозагрузка: Нет",
            ["Delete Config"] = "Удалить конфигурацию",
            ["Credits"] = "Создатели",
            ["Creator and developer"] = "Создатель и разработчик",
            ["Discord server if you have any questions"] = "Сервер Discord, если у вас есть вопросы",
            ["Copy link"] = "Копировать ссылку",
            ["Link copied!"] = "Ссылка скопирована!"
        }
    }

    -- Merge built-in translations into Window.Translations
    Window.Translations = Window.Translations or {}
    for bLang, bDict in pairs(BuiltinLibraryTranslations) do
        Window.Translations[bLang] = Window.Translations[bLang] or {}
        for bKey, bVal in pairs(bDict) do
            if Window.Translations[bLang][bKey] == nil then
                Window.Translations[bLang][bKey] = bVal
            end
        end
    end





    -- Loading screen engine
    if Library.ActiveLoadingUI and Library.ActiveLoadingUI.Parent then
        pcall(function() Library.ActiveLoadingUI:Destroy() end)
    end

    local LoadingUI = Instance.new("ScreenGui")
    LoadingUI.Name = GenerateSafeName("UI")
    LoadingUI.ResetOnSpawn = false
    LoadingUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadingUI.DisplayOrder = 100
    ProtectGui(LoadingUI)
    LoadingUI.Parent = ParentGui
    Library.ActiveLoadingUI = LoadingUI
    table.insert(Library.ActiveGuis, LoadingUI)

    local LoadCenterFrame = Instance.new("Frame")
    LoadCenterFrame.Name = GenerateSafeName("Center")
    LoadCenterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadCenterFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadCenterFrame.Size = UDim2.new(0, 360, 0, 140)
    LoadCenterFrame.BackgroundTransparency = 1
    LoadCenterFrame.ClipsDescendants = false
    LoadCenterFrame.ZIndex = 100
    LoadCenterFrame.Parent = LoadingUI

    local LoadScale = Instance.new("UIScale")
    LoadScale.Name = GenerateSafeName("Scale")
    LoadScale.Scale = GetHUDScale()
    LoadScale.Parent = LoadCenterFrame
    table.insert(HUD_UIScales, LoadScale)

    local Loadbarempty = Instance.new("Frame")
    Loadbarempty.Name = GenerateSafeName("BarEmpty")
    Loadbarempty.Size = UDim2.new(0, 326, 0, 23)
    Loadbarempty.Position = UDim2.new(0.5, -163, 0.5, -5)
    Loadbarempty.BackgroundColor3 = Color3.fromRGB(106, 106, 106)
    Loadbarempty.BackgroundTransparency = 0.15
    Loadbarempty.BorderSizePixel = 0
    Loadbarempty.ClipsDescendants = true
    Loadbarempty.ZIndex = 101
    Loadbarempty.Parent = LoadCenterFrame

    local LoadbaremptyCorner = Instance.new("UICorner")
    LoadbaremptyCorner.CornerRadius = UDim.new(0, 8)
    LoadbaremptyCorner.Parent = Loadbarempty

    local LoadbaremptyStroke = Instance.new("UIStroke")
    LoadbaremptyStroke.Name = GenerateSafeName("Stroke")
    LoadbaremptyStroke.Color = Color3.fromRGB(179, 179, 179)
    LoadbaremptyStroke.Thickness = 1.5
    LoadbaremptyStroke.Transparency = 0
    LoadbaremptyStroke.Parent = Loadbarempty

    
    AddUIShadow(Loadbarempty, 20, 0.5, Color3.fromRGB(255, 255, 255))

    local Loadbar = Instance.new("Frame")
    Loadbar.Name = GenerateSafeName("Bar")
    Loadbar.Size = UDim2.new(0, 0, 1, 0)
    Loadbar.Position = UDim2.new(0, 0, 0, 0)
    Loadbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Loadbar.BackgroundTransparency = 0.15
    Loadbar.BorderSizePixel = 0
    Loadbar.ClipsDescendants = true
    Loadbar.ZIndex = 102
    Loadbar.Parent = Loadbarempty

    local LoadbarCorner = Instance.new("UICorner")
    LoadbarCorner.CornerRadius = UDim.new(0, 8)
    LoadbarCorner.Parent = Loadbar

    local Loadingtext = Instance.new("TextLabel")
    Loadingtext.Name = GenerateSafeName("LoadingText")
    Loadingtext.Size = UDim2.new(0, 180, 0, 33)
    Loadingtext.Position = UDim2.new(0.5, -163, 0.5, 18)
    Loadingtext.BackgroundTransparency = 1
    Loadingtext.FontFace = FontFingerPaintRegular
    Loadingtext.Text = "Loading..."
    Loadingtext.TextColor3 = Color3.fromRGB(255, 255, 255)
    Loadingtext.TextSize = 24
    Loadingtext.TextWrapped = true
    Loadingtext.TextXAlignment = Enum.TextXAlignment.Left
    Loadingtext.ZIndex = 102
    Loadingtext.Parent = LoadCenterFrame

    local percloaded = Instance.new("TextLabel")
    percloaded.Name = GenerateSafeName("PercLoaded")
    percloaded.Size = UDim2.new(0, 131, 0, 33)
    percloaded.Position = UDim2.new(0.5, 32, 0.5, -35)
    percloaded.BackgroundTransparency = 1
    percloaded.FontFace = FontFingerPaintRegular
    percloaded.Text = "0 %"
    percloaded.TextColor3 = Color3.fromRGB(255, 255, 255)
    percloaded.TextSize = 22
    percloaded.TextWrapped = true
    percloaded.TextXAlignment = Enum.TextXAlignment.Right
    percloaded.ZIndex = 102
    percloaded.Parent = LoadCenterFrame

    local isFinishedLoading = false

    function Window:UpdateLoadingProgress(pct, statusText)
        if isFinishedLoading then return end
        pct = math.clamp(pct or 0, 0, 100)
        percloaded.Text = string.format("%d %%", math.floor(pct))
        if statusText then
            Loadingtext.Text = statusText
        end
        local targetWidth = math.floor(326 * (pct / 100))
        TweenService:Create(Loadbar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetWidth, 1, 0)
        }):Play()
    end

    function Window:FinishLoading()
        if isFinishedLoading then return end
        isFinishedLoading = true

        Window:UpdateLoadingProgress(100, "Loaded!")
        task.wait(0.25)
        if LoadScale and LoadScale.Parent then
            local shrinkTween = TweenService:Create(LoadScale, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Scale = 0
            })
            shrinkTween:Play()
            pcall(function() shrinkTween.Completed:Wait() end)
        end
        if LoadingUI and LoadingUI.Parent then
            LoadingUI:Destroy()
        end
        if ScriptUi then
            ScriptUi.Enabled = true
        end

        if UIScaleConstraint and MainContainer then
            local targetScale = (GetTargetViewportScale and GetTargetViewportScale()) or 1.0
            UIScaleConstraint.Scale = targetScale * 0.92
            TweenService:Create(UIScaleConstraint, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Scale = targetScale
            }):Play()
        end

        -- Snapshot default config state after full initialization
        if not DefaultConfigMemoryData then
            DefaultConfigMemoryData = Window:GetConfigSaveData()
        end

        -- Trigger Autoload Config if set
        task.spawn(function()
            task.wait(0.2)
            local autoloadConfig = Window:GetAutoloadConfig()
            if autoloadConfig and autoloadConfig ~= "" and autoloadConfig:upper() ~= "NONE" then
                Window:LoadConfig(autoloadConfig)
            end
        end)

        task.delay(1.5, function()
            if Window and ScriptUi and ScriptUi.Enabled then
                Window:SetBackgroundBlur(Window.BackgroundBlurEnabled)
            end
        end)
    end



    AttachUniversalDrag = function(dragHandleFrame, targetContainer)
        local isDragging = false
        local dragStartPos = nil
        local frameStartPos = nil

        local function GetContainerScale()
            if targetContainer == MainContainer or (UIScaleConstraint and targetContainer:IsDescendantOf(MainContainer)) then
                local s = (UIScaleConstraint and UIScaleConstraint.Scale) or 1
                return (s > 0) and s or 1
            end
            local sObj = targetContainer:FindFirstChildOfClass("UIScale")
            if sObj and sObj.Scale > 0 then
                return sObj.Scale
            end
            return 1
        end

        TrackConn(dragHandleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStartPos = input.Position
                frameStartPos = targetContainer.Position
            end
        end))

        TrackConn(UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local scale = GetContainerScale()
                local deltaX = (input.Position.X - dragStartPos.X) / scale
                local deltaY = (input.Position.Y - dragStartPos.Y) / scale

                local vp = (Camera and Camera.ViewportSize) or (ScriptUi and ScriptUi.AbsoluteSize) or Vector2.new(1920, 1080)
                local vpW = vp.X
                local vpH = vp.Y
                local inset = GuiService:GetGuiInset()
                local topInset = (ScriptUi and ScriptUi.IgnoreGuiInset) and 0 or inset.Y

                local winW = targetContainer.AbsoluteSize.X
                local winH = targetContainer.AbsoluteSize.Y
                if winW <= 0 then winW = targetContainer.Size.X.Offset * scale end
                if winH <= 0 then winH = targetContainer.Size.Y.Offset * scale end

                local anchor = targetContainer.AnchorPoint
                local unconstrainedOffsetX = frameStartPos.X.Offset + deltaX
                local unconstrainedOffsetY = frameStartPos.Y.Offset + deltaY

                local screenLeft = (vpW * frameStartPos.X.Scale) + (unconstrainedOffsetX * scale) - (anchor.X * winW)
                local screenTop = (vpH * frameStartPos.Y.Scale) + (unconstrainedOffsetY * scale) - (anchor.Y * winH)

                local minL = math.min(0, vpW - winW)
                local maxL = math.max(0, vpW - winW)
                local minT = math.min(topInset, vpH - winH)
                local maxT = math.max(topInset, vpH - winH)

                local clampedScreenLeft = math.clamp(screenLeft, minL, maxL)
                local clampedScreenTop = math.clamp(screenTop, minT, maxT)

                local finalOffsetX = (clampedScreenLeft + (anchor.X * winW) - (vpW * frameStartPos.X.Scale)) / scale
                local finalOffsetY = (clampedScreenTop + (anchor.Y * winH) - (vpH * frameStartPos.Y.Scale)) / scale

                targetContainer.Position = UDim2.new(
                    frameStartPos.X.Scale, finalOffsetX,
                    frameStartPos.Y.Scale, finalOffsetY
                )
            end
        end))

        TrackConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end))

        TrackConn(UserInputService.WindowFocusReleased:Connect(function()
            isDragging = false
        end))
    end

    local function BrightenColor(col, factor)
        if not col then return col end
        local h, s, v = col:ToHSV()
        return Color3.fromHSV(h, math.clamp(s * 0.96, 0, 1), math.clamp(v * (factor or 1.05), 0, 1))
    end

    local BUTTON_ARROW_ICON = "rbxassetid://101007429951147"

    local function GetButtonArrowColor(theme, isHovered)
        local textCol = (theme and theme.Text) or Color3.fromRGB(255, 255, 255)
        if isHovered then
            return textCol
        end
        local lum = 0.299 * textCol.R + 0.587 * textCol.G + 0.114 * textCol.B
        if lum > 0.5 then
            -- Light text on dark bg: barely darker than white
            return Color3.fromRGB(228, 230, 236)
        else
            -- Dark text on light bg: barely lighter than black
            return Color3.fromRGB(55, 58, 65)
        end
    end

    -- Builds the card-style content: [icon] text ........ arrow
    local function BuildMDButtonContent(BtnFrame, text, iconName, isSmall, showArrow, z, textName)
        local theme = Window.CurrentTheme
        BtnFrame.BackgroundColor3 = GetThemedDarkColor(theme)
        BtnFrame.BackgroundTransparency = 0.2

        local Stroke = Instance.new("UIStroke")
        Stroke.Thickness = 1
        Stroke.Color = theme.Divider or Color3.fromRGB(65, 70, 88)
        Stroke.Transparency = 0.6
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Parent = BtnFrame

        local padX      = isSmall and 8 or 12
        local iconSize  = isSmall and 14 or 18
        local arrowSize = isSmall and 12 or 16
        local gap       = isSmall and 6 or 8

        local iconAsset = (iconName and iconName ~= "") and ResolveImage(iconName) or nil

        local Icon = nil
        if iconAsset then
            Icon = Instance.new("ImageLabel")
            Icon.Name = "BtnIcon"
            Icon.Size = UDim2.new(0, iconSize, 0, iconSize)
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.Position = UDim2.new(0, padX, 0.5, 0)
            Icon.BackgroundTransparency = 1
            Icon.Image = iconAsset
            Icon.ImageColor3 = theme.Text
            Icon.ZIndex = z
            Icon.Parent = BtnFrame
        end

        local Arrow = nil
        if showArrow then
            Arrow = Instance.new("ImageLabel")
            Arrow.Name = GenerateSafeName("Arrow")
            Arrow.Size = UDim2.new(0, arrowSize, 0, arrowSize)
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.Position = UDim2.new(1, -padX, 0.5, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = BUTTON_ARROW_ICON
            Arrow.ImageColor3 = GetButtonArrowColor(theme, false)
            Arrow.ZIndex = z
            Arrow.Parent = BtnFrame

            -- fallback if the asset fails to load: rotated chevron
            task.delay(3, function()
                if Arrow and Arrow.Parent and not Arrow.IsLoaded then
                    Arrow.Image = "rbxassetid://101007429951147"
                end
            end)
        end

        local textX = padX + (Icon and (iconSize + gap) or 0)
        local rightReserve = Arrow and (padX + arrowSize + 6) or padX

        local TextFolder = Instance.new("Folder")
        TextFolder.Name = GenerateSafeName("Text")
        TextFolder.Parent = BtnFrame

        local textYOffset = isSmall and -1 or -2

        local Label = Instance.new("TextLabel")
        Label.Name = textName or "btntext"
        Label.Size = UDim2.new(1, -(textX + rightReserve), 1, 0)
        Label.Position = UDim2.new(0, textX, 0, textYOffset)
        Label.BackgroundTransparency = 1
        Label.FontFace = FontTabBtn
        Label.RichText = true
        Label.Text = text or "Button"
        Label.TextColor3 = theme.Text
        Label.TextSize = isSmall and 11 or 13
        Label.TextWrapped = false
        Label.TextTruncate = Enum.TextTruncate.AtEnd
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Center
        Label.ZIndex = z
        Label.Parent = TextFolder

        return {
            Text = Label, Icon = Icon, Arrow = Arrow, Stroke = Stroke,
            PadX = padX, IconSize = iconSize, ArrowSize = arrowSize, Gap = gap,
            TextYOffset = textYOffset,
        }
    end

    local function RefreshMDButtonContent(parts, frame, theme)
        if not (frame and frame.Parent) then return end
        frame.BackgroundColor3 = GetThemedDarkColor(theme)
        parts.Text.TextColor3 = theme.Text
        if parts.Icon then parts.Icon.ImageColor3 = theme.Text end
        if parts.Arrow then parts.Arrow.ImageColor3 = GetButtonArrowColor(theme, false) end
        parts.Stroke.Color = theme.Divider or Color3.fromRGB(65, 70, 88)
    end

    -- Adds/changes the icon later and re-flows the text
    local function SetMDButtonIcon(parts, newIcon)
        local asset = (newIcon and newIcon ~= "") and ResolveImage(newIcon) or nil
        if asset and not parts.Icon then
            local parentFrame = parts.Text.Parent.Parent
            local ic = Instance.new("ImageLabel")
            ic.Name = "BtnIcon"
            ic.Size = UDim2.new(0, parts.IconSize, 0, parts.IconSize)
            ic.AnchorPoint = Vector2.new(0, 0.5)
            ic.Position = UDim2.new(0, parts.PadX, 0.5, 0)
            ic.BackgroundTransparency = 1
            ic.ImageColor3 = Window.CurrentTheme.Text
            ic.ZIndex = parts.Text.ZIndex
            ic.Parent = parentFrame
            parts.Icon = ic
        end
        if parts.Icon then
            if asset then
                parts.Icon.Image = asset
                parts.Icon.Visible = true
            else
                parts.Icon.Visible = false
            end
        end
        local hasIcon = parts.Icon and parts.Icon.Visible
        local textX = parts.PadX + (hasIcon and (parts.IconSize + parts.Gap) or 0)
        local rightReserve = parts.Arrow and (parts.PadX + parts.ArrowSize + 6) or parts.PadX
        local textYOffset = parts.TextYOffset or -2
        parts.Text.Position = UDim2.new(0, textX, 0, textYOffset)
        parts.Text.Size = UDim2.new(1, -(textX + rightReserve), 1, 0)
    end

    -- Interactive button component with scale and stroke feedback
    function Window:CreateMDButton(parent, size, position, text, onClick, showArrow, icon)
        parent = ResolveParent(parent)
        size = size or UDim2.new(0, 260, 0, 62)
        position = position or UDim2.new(0, 0, 0, 0)
        local isSmall = size.Y.Offset > 0 and size.Y.Offset <= 28

        local BtnFrame = Instance.new("Frame")
        BtnFrame.Name = GenerateSafeName("BtnFrame")
        BtnFrame.Size = size
        BtnFrame.BorderSizePixel = 0
        BtnFrame.ZIndex = 10
        BtnFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = BtnFrame

        AddUIShadow(BtnFrame, 20, 0.5)

        BtnFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        BtnFrame.Position = UDim2.new(
            position.X.Scale + 0.5 * size.X.Scale,
            position.X.Offset + math.floor(size.X.Offset * 0.5),
            position.Y.Scale + 0.5 * size.Y.Scale,
            position.Y.Offset + math.floor(size.Y.Offset * 0.5)
        )

        local BtnScale = Instance.new("UIScale")
        BtnScale.Scale = 1.0
        BtnScale.Parent = BtnFrame

        -- arrow is on by default for every button; pass showArrow=false to hide it
        local parts = BuildMDButtonContent(BtnFrame, text, icon, isSmall, showArrow ~= false, 11, GenerateSafeName("btnTitle"))

        local ClickBtn = Instance.new("TextButton")
        ClickBtn.Name = GenerateSafeName("Trigger")
        ClickBtn.Size = UDim2.new(1, 0, 1, 0)
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Text = ""
        ClickBtn.ZIndex = 12
        ClickBtn.Parent = BtnFrame

        local _hoverActive = false
        local _pressActive = false
        local quart = Enum.EasingStyle.Quart

        TrackConn(ClickBtn.MouseEnter:Connect(function()
            _hoverActive = true
            PlayHoverSFX()
            TweenService:Create(BtnScale, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {Scale = 1.02}):Play()
            TweenService:Create(BtnFrame, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
            if parts.Arrow then
                TweenService:Create(parts.Arrow, TweenInfo.new(0.18), {ImageColor3 = GetButtonArrowColor(Window.CurrentTheme, true)}):Play()
            end
        end))

        TrackConn(ClickBtn.MouseLeave:Connect(function()
            _hoverActive = false
            _pressActive = false
            TweenService:Create(BtnScale, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {Scale = 1.0}):Play()
            TweenService:Create(BtnFrame, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
            if parts.Arrow then
                TweenService:Create(parts.Arrow, TweenInfo.new(0.18), {ImageColor3 = GetButtonArrowColor(Window.CurrentTheme, false)}):Play()
            end
        end))

        TrackConn(ClickBtn.MouseButton1Down:Connect(function()
            _pressActive = true
            PlayClickSFX()
            TweenService:Create(BtnScale, TweenInfo.new(0.09, quart, Enum.EasingDirection.Out), {Scale = 0.95}):Play()
        end))

        TrackConn(ClickBtn.MouseButton1Up:Connect(function()
            if not _pressActive then return end
            _pressActive = false
            TweenService:Create(BtnScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = _hoverActive and 1.02 or 1.0}):Play()
            if onClick then pcall(onClick) end
        end))

        local btnData = {
            Frame = BtnFrame,
            TextLabel = parts.Text,
            ArrowIcon = parts.Arrow,
            IconImage = parts.Icon,
            Trigger = ClickBtn,
            BaseSize = size,
            SetText = function(self, t) parts.Text.Text = tostring(t or "") end,
            SetIcon = function(self, ic) SetMDButtonIcon(parts, ic) end,
            RefreshTheme = function(theme) RefreshMDButtonContent(parts, BtnFrame, theme) end,
        }
        btnData.WithCallback = function(self, cb) onClick = cb; return self end
        btnData.WithTooltip = function(self, tt)
            if Window.AttachTooltip and BtnFrame then Window:AttachTooltip(BtnFrame, tt) end
            return self
        end
        btnData.WithSaveKey = function(self, key)
            if key and key ~= "" then self.SaveKey = key end
            return self
        end
        btnData.WithText = function(self, txt) self:SetText(txt); return self end
        btnData.WithIcon = function(self, ic) self:SetIcon(ic); return self end

        table.insert(Window.RegisteredMDButtons, btnData)

        return btnData
    end

    -- Keybind badge and toggle binder
    local ActiveListeningBadge = nil

    local function ParseKeyCode(input)
        if not input or input == "..." or input == "" or input == false then
            return nil
        end
        if typeof(input) == "EnumItem" and input.EnumType == Enum.KeyCode then
            return input
        end
        if type(input) == "string" then
            local trimmed = input:gsub("%s+", "")
            if trimmed == "..." or trimmed == "" or trimmed:lower() == "none" or trimmed:lower() == "nil" then
                return nil
            end
            for _, code in ipairs(Enum.KeyCode:GetEnumItems()) do
                if code.Name:lower() == trimmed:lower() then
                    return code
                end
            end
        end
        return nil
    end

    local function GetKeyDisplayName(keyCode)
        if not keyCode or keyCode == Enum.KeyCode.Unknown then
            return "..."
        end
        local name = keyCode.Name
        if name:find("^Keypad") then
            name = name:gsub("^Keypad", "Num")
        elseif name == "LeftShift" then
            name = "LShift"
        elseif name == "RightShift" then
            name = "RShift"
        elseif name == "LeftControl" then
            name = "LCtrl"
        elseif name == "RightControl" then
            name = "RCtrl"
        elseif name == "LeftAlt" then
            name = "LAlt"
        elseif name == "RightAlt" then
            name = "RAlt"
        end
        return name
    end

    function Window:CreateKeybindBadge(parent, position, size, initialBind, onTrigger, identifier)
        size = size or UDim2.new(0, 36, 0, 22)
        position = position or UDim2.new(0, 0, 0, 0)

        local initialKey = ParseKeyCode(initialBind)

        local BadgeContainer = Instance.new("Frame")
        BadgeContainer.Name = GenerateSafeName("Badge")
        BadgeContainer.Size = size
        BadgeContainer.Position = position
        BadgeContainer.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
        BadgeContainer.BackgroundTransparency = 0.15
        BadgeContainer.BorderSizePixel = 0
        BadgeContainer.ZIndex = 15
        BadgeContainer.ClipsDescendants = false
        BadgeContainer.Parent = parent

        local BadgeCorner = Instance.new("UICorner")
        BadgeCorner.CornerRadius = UDim.new(0, 8)
        BadgeCorner.Parent = BadgeContainer

        local BadgeStroke = Instance.new("UIStroke")
        BadgeStroke.Name = GenerateSafeName("Stroke")
        BadgeStroke.Thickness = 1.1
        BadgeStroke.Color = Color3.fromRGB(255, 255, 255)
        BadgeStroke.Transparency = 1
        BadgeStroke.Parent = BadgeContainer

        local BadgeText = Instance.new("TextLabel")
        BadgeText.Name = GenerateSafeName("KeyLabel")
        BadgeText.Size = UDim2.new(1, -6, 1, 0)
        BadgeText.Position = UDim2.new(0, 3, 0, 0)
        BadgeText.BackgroundTransparency = 1
        BadgeText.FontFace = FontFingerPaintRegular
        BadgeText.Text = GetKeyDisplayName(initialKey)
        BadgeText.TextColor3 = Window.CurrentTheme.Text
        BadgeText.TextSize = 10
        BadgeText.TextXAlignment = Enum.TextXAlignment.Center
        BadgeText.TextYAlignment = Enum.TextYAlignment.Center
        BadgeText.ZIndex = 16
        BadgeText.Parent = BadgeContainer

        local TriggerBtn = Instance.new("TextButton")
        TriggerBtn.Name = GenerateSafeName("Trigger")
        TriggerBtn.Size = UDim2.new(1, 0, 1, 0)
        TriggerBtn.BackgroundTransparency = 1
        TriggerBtn.Text = ""
        TriggerBtn.ZIndex = 17
        TriggerBtn.Parent = BadgeContainer

        -- Close icon that appears when editing to delete/clear bind
        local DeleteBtn = Instance.new("ImageButton")
        DeleteBtn.Name = GenerateSafeName("Delete")
        DeleteBtn.Size = UDim2.new(0, 14, 0, 14)
        DeleteBtn.Position = UDim2.new(1, -15, 0.5, -7)
        DeleteBtn.BackgroundTransparency = 1
        DeleteBtn.Image = "rbxassetid://132261474823036"
        DeleteBtn.ImageColor3 = Window.CurrentTheme.Text
        DeleteBtn.ZIndex = 18
        DeleteBtn.Visible = false
        DeleteBtn.Parent = BadgeContainer

        local badgeData = {
            Container = BadgeContainer,
            Badge = BadgeContainer,
            Frame = BadgeContainer,
            Label = BadgeText,
            Stroke = BadgeStroke,
            DeleteBtn = DeleteBtn,
            CurrentKey = initialKey,
            OnTrigger = onTrigger,
            Identifier = identifier or "Toggle",
            IsListening = false
        }

        local function UpdateUI()
            BadgeText.Text = GetKeyDisplayName(badgeData.CurrentKey)
            if badgeData.IsListening then
                BadgeText.Text = "..."
                BadgeText.Size = UDim2.new(1, -18, 1, 0)
                BadgeText.Position = UDim2.new(0, 2, 0, 0)
                BadgeStroke.Thickness = 1.6
                BadgeStroke.Color = Window.CurrentTheme.Text
                BadgeStroke.Transparency = 0.2
                DeleteBtn.Visible = true
            else
                BadgeText.Size = UDim2.new(1, -6, 1, 0)
                BadgeText.Position = UDim2.new(0, 3, 0, 0)
                BadgeStroke.Thickness = 1.1
                BadgeStroke.Color = Color3.fromRGB(255, 255, 255)
                BadgeStroke.Transparency = 0.75
                DeleteBtn.Visible = false
            end
        end

        function badgeData.SetKey(newKeyCode, isUserEdit)
            if badgeData.CurrentKey and Window.KeybindMap[badgeData.CurrentKey] == badgeData then
                Window.KeybindMap[badgeData.CurrentKey] = nil
            end

            if newKeyCode and newKeyCode ~= Enum.KeyCode.Unknown then
                -- Conflict check: if another toggle used this key, clear it
                local existing = Window.KeybindMap[newKeyCode]
                if existing and existing ~= badgeData then
                    existing.ClearKey(false)
                    if isUserEdit then
                        Window:Notify("Keybind", "Reassigned " .. newKeyCode.Name .. " (cleared from " .. (existing.Identifier or "toggle") .. ")", 2.5)
                    end
                end
                Window.KeybindMap[newKeyCode] = badgeData
                badgeData.CurrentKey = newKeyCode
            else
                badgeData.CurrentKey = nil
            end

            UpdateUI()
        end

        function badgeData.ClearKey(notify)
            if badgeData.CurrentKey and Window.KeybindMap[badgeData.CurrentKey] == badgeData then
                Window.KeybindMap[badgeData.CurrentKey] = nil
            end
            badgeData.CurrentKey = nil
            badgeData.IsListening = false
            UpdateUI()
            if notify then
                Window:Notify("Keybind", "Cleared bind for " .. (badgeData.Identifier or "toggle"), 2)
            end
        end

        function badgeData.StartListening()
            if ActiveListeningBadge and ActiveListeningBadge ~= badgeData then
                ActiveListeningBadge.StopListening()
            end
            badgeData.IsListening = true
            ActiveListeningBadge = badgeData
            PlayClickSFX()
            UpdateUI()
        end

        function badgeData.StopListening()
            badgeData.IsListening = false
            if ActiveListeningBadge == badgeData then
                ActiveListeningBadge = nil
            end
            UpdateUI()
        end

        TrackConn(TriggerBtn.MouseButton1Click:Connect(function()
            if badgeData.IsListening then
                badgeData.StopListening()
            else
                badgeData.StartListening()
            end
        end))

        TrackConn(DeleteBtn.MouseButton1Click:Connect(function()
            PlayClickSFX()
            badgeData.ClearKey(true)
            badgeData.StopListening()
        end))

        if initialKey then
            badgeData.SetKey(initialKey, false)
        end

        table.insert(Window.RegisteredKeybindBadges, badgeData)
        return badgeData
    end

    function Window:CreateMDToggle(parent, position, size, initialState, onToggle, identifier, keybindConfig)
        parent = ResolveParent(parent)
        size = size or UDim2.new(0, 56, 0, 26)

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = GenerateSafeName("Toggle")
        ToggleFrame.Size = size
        ToggleFrame.Position = position or UDim2.new(0, 0, 0, 0)
        ToggleFrame.BackgroundColor3 = initialState and Window.CurrentTheme.ButtonBG or GetThemedDarkColor(Window.CurrentTheme)
        ToggleFrame.BackgroundTransparency = 0.05
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.ClipsDescendants = false
        ToggleFrame.ZIndex = 10
        ToggleFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 33)
        Corner.Parent = ToggleFrame

        AddUIShadow(ToggleFrame, 20, 0.5)

        local KnobFrame = Instance.new("Frame")
        KnobFrame.Name = GenerateSafeName("Knob")
        KnobFrame.Size = UDim2.new(0, 22, 0, 22)
        KnobFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        KnobFrame.Position = initialState and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 13, 0.5, 0)
        KnobFrame.Rotation = initialState and 0 or 225
        KnobFrame.BackgroundTransparency = 1
        KnobFrame.ZIndex = 11
        KnobFrame.Parent = ToggleFrame

        local BaseCircle = Instance.new("ImageLabel")
        BaseCircle.Name = GenerateSafeName("Knob")
        BaseCircle.Size = UDim2.new(1, 0, 1, 0)
        BaseCircle.BackgroundTransparency = 1
        BaseCircle.Image = "rbxassetid://118376432250064"
        BaseCircle.ImageColor3 = initialState and GetOnAccent(Window.CurrentTheme.ButtonBG) or Window.CurrentTheme.ButtonBG
        BaseCircle.ZIndex = 11
        BaseCircle.Parent = KnobFrame

        local OverlayCircle = Instance.new("ImageLabel")
        OverlayCircle.Name = GenerateSafeName("Overlay")
        OverlayCircle.Size = UDim2.new(1, 0, 1, 0)
        OverlayCircle.BackgroundTransparency = 1
        OverlayCircle.Image = "rbxassetid://100354746235648"
        OverlayCircle.ImageColor3 = initialState and Window.CurrentTheme.ButtonBG or Color3.fromRGB(255, 255, 255)
        OverlayCircle.ZIndex = 12
        OverlayCircle.Parent = KnobFrame

        local ClickBtn = Instance.new("TextButton")
        ClickBtn.Name = GenerateSafeName("Trigger")
        ClickBtn.Size = UDim2.new(1, 0, 1, 0)
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Text = ""
        ClickBtn.ZIndex = 13
        ClickBtn.Parent = ToggleFrame

        local isToggled = initialState

        local function PerformToggle(newState, triggerCallback)
            isToggled = (newState == true)
            local targetKnobPos = isToggled and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 13, 0.5, 0)
            local targetRotation = isToggled and 0 or 225
            local targetBG = isToggled and Window.CurrentTheme.ButtonBG or GetThemedDarkColor(Window.CurrentTheme)
            local targetBaseColor = isToggled and GetOnAccent(Window.CurrentTheme.ButtonBG) or Window.CurrentTheme.ButtonBG
            local targetOverlayColor = isToggled and Window.CurrentTheme.ButtonBG or Color3.fromRGB(255, 255, 255)

            TweenService:Create(KnobFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = targetKnobPos,
                Rotation = targetRotation
            }):Play()
            TweenService:Create(BaseCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = targetBaseColor}):Play()
            TweenService:Create(OverlayCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = targetOverlayColor}):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetBG}):Play()

            if triggerCallback and onToggle then
                pcall(onToggle, isToggled)
            end
        end

        TrackConn(ClickBtn.MouseButton1Click:Connect(function()
            PlayClickSFX()
            PerformToggle(not isToggled, true)
        end))

        local saveKey = (type(keybindConfig) == "table" and (keybindConfig.SaveKey or keybindConfig.saveKey or keybindConfig.Identifier or keybindConfig.identifier or keybindConfig.Id or keybindConfig.id)) or identifier or ("Toggle_" .. (#Window.RegisteredMDToggles + 1))
        local toggleName = saveKey
        local toggleData = {
            Name = toggleName,
            SaveKey = saveKey,
            Frame = ToggleFrame,
            Knob = KnobFrame,
            BaseCircle = BaseCircle,
            Overlay = OverlayCircle,
            GetState = function() return isToggled end,
            SetState = function(state, triggerCallback)
                PerformToggle(state, triggerCallback)
            end,
            RefreshTheme = function(theme, animated)
                local isTog = isToggled
                local targetBG = isTog and theme.ButtonBG or ((theme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(200, 205, 215) or Color3.fromRGB(35, 38, 48))
                local targetBaseColor = isTog and GetOnAccent(theme.ButtonBG) or theme.ButtonBG
                local targetOverlayColor = isTog and theme.ButtonBG or Color3.fromRGB(255, 255, 255)

                if animated then
                    local tw = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    TweenService:Create(ToggleFrame, tw, {BackgroundColor3 = targetBG}):Play()
                    TweenService:Create(BaseCircle, tw, {ImageColor3 = targetBaseColor}):Play()
                    TweenService:Create(OverlayCircle, tw, {ImageColor3 = targetOverlayColor}):Play()
                else
                    ToggleFrame.BackgroundColor3 = targetBG
                    BaseCircle.ImageColor3 = targetBaseColor
                    OverlayCircle.ImageColor3 = targetOverlayColor
                end

                if toggleData.Keybind and toggleData.Keybind.Container then
                    toggleData.Keybind.Container.BackgroundColor3 = (theme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(225, 230, 240) or Color3.fromRGB(24, 26, 34)
                    if toggleData.Keybind.Label then toggleData.Keybind.Label.TextColor3 = theme.Text end
                    if toggleData.Keybind.DeleteBtn then toggleData.Keybind.DeleteBtn.ImageColor3 = theme.Text end
                end
            end
        }

        local keybindProp = nil
        if type(keybindConfig) == "table" then
            keybindProp = keybindConfig.Bind or keybindConfig.Keybind or keybindConfig.DefaultBind or keybindConfig.Key or keybindConfig.KeyBind or keybindConfig.DefaultKey
            if keybindProp == nil and keybindConfig.Default ~= nil and typeof(keybindConfig.Default) ~= "boolean" then
                keybindProp = keybindConfig.Default
            end
        elseif keybindConfig ~= nil and keybindConfig ~= false and keybindConfig ~= true then
            keybindProp = keybindConfig
        end

        if keybindProp then
            local defaultKey = keybindProp
            local pos = position or UDim2.new(0, 0, 0, 0)
            local badgePos = UDim2.new(pos.X.Scale, pos.X.Offset - 42, pos.Y.Scale, pos.Y.Offset + 2)
            toggleData.Keybind = Window:CreateKeybindBadge(parent, badgePos, UDim2.new(0, 36, 0, 22), defaultKey, function()
                toggleData.SetState(not isToggled, true)
            end, toggleName)
        end

        Window.RegisteredToggles[toggleName] = toggleData
        if identifier and identifier ~= "" and not Window.RegisteredToggles[identifier] then
            Window.RegisteredToggles[identifier] = toggleData
        end
        if type(keybindConfig) == "table" then
            local altId = keybindConfig.Id or keybindConfig.id or keybindConfig.Identifier or keybindConfig.identifier or keybindConfig.SaveKey or keybindConfig.saveKey
            if altId and not Window.RegisteredToggles[altId] then
                Window.RegisteredToggles[altId] = toggleData
            end
        end
        table.insert(Window.RegisteredMDToggles, toggleData)
        return toggleData
    end

    function Window:CreateMDSlider(parent, position, size, minVal, maxVal, defaultVal, onValueChange, identifier, sliderOptions)
        parent = ResolveParent(parent)
        size = size or UDim2.new(0, 210, 0, 14)
        minVal = minVal or 0
        maxVal = maxVal or 100

        local showValue = false
        local valueFormat = "number"
        local suffix = ""
        local prefix = ""
        local increment = 1
        local precision = 0

        local function GetDecimalPlaces(num)
            local s = tostring(num)
            local dot = s:find("%.")
            if dot then return #s - dot end
            return 0
        end

        if type(sliderOptions) == "table" then
            showValue = (sliderOptions.ShowValue ~= false)
            valueFormat = sliderOptions.ValueFormat or (sliderOptions.IsPercent and "percent") or (sliderOptions.Suffix == "%" and "percent") or "number"
            suffix = sliderOptions.Suffix or (valueFormat == "percent" and "%" or "")
            prefix = sliderOptions.Prefix or ""
            increment = tonumber(sliderOptions.Increment or sliderOptions.increment or sliderOptions.Step or sliderOptions.step or sliderOptions.StepAmount or sliderOptions.IncrementAmount) or 1
            if increment <= 0 then increment = 1 end
            precision = tonumber(sliderOptions.Precision or sliderOptions.precision or sliderOptions.Decimals or sliderOptions.decimals) or GetDecimalPlaces(increment)
        elseif type(sliderOptions) == "number" then
            increment = sliderOptions > 0 and sliderOptions or 1
            precision = GetDecimalPlaces(increment)
        elseif type(sliderOptions) == "string" then
            showValue = true
            suffix = sliderOptions
            if suffix == "%" then valueFormat = "percent" end
        elseif sliderOptions == true then
            showValue = true
        end

        local function RoundToPrecision(val, prec)
            if (prec or 0) <= 0 then
                return math.floor(val + 0.5)
            else
                local mult = 10 ^ prec
                return math.floor((val * mult) + 0.5) / mult
            end
        end

        local function SnapToIncrement(val)
            if increment and increment > 0 then
                local steps = math.floor(((val - minVal) / increment) + 0.5)
                local snapped = minVal + (steps * increment)
                snapped = math.clamp(snapped, minVal, maxVal)
                return RoundToPrecision(snapped, precision)
            end
            return RoundToPrecision(val, precision)
        end

        defaultVal = SnapToIncrement(math.clamp(defaultVal or minVal or 0, minVal, maxVal))

        local TrackFrame = Instance.new("Frame")
        TrackFrame.Name = GenerateSafeName("Track")
        TrackFrame.Size = size
        TrackFrame.Position = position or UDim2.new(0, 0, 0, 0)
        TrackFrame.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
        TrackFrame.BackgroundTransparency = 0.05
        TrackFrame.BorderSizePixel = 0
        TrackFrame.ZIndex = 10
        TrackFrame.ClipsDescendants = false
        TrackFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 33)
        Corner.Parent = TrackFrame

        AddUIShadow(TrackFrame, 20, 0.5)

        local initialPct = (maxVal > minVal) and math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1) or 0
        local knobSize = (type(sliderOptions) == "table" and sliderOptions.KnobSize) or 22

        local function GetFormattedValue(val, pct)
            if valueFormat == "percent" or valueFormat == "%" or suffix == "%" then
                local pctVal = (precision > 0) and RoundToPrecision(pct * 100, precision) or math.floor(pct * 100 + 0.5)
                local strPct = (precision > 0) and string.format("%." .. precision .. "f", pctVal) or tostring(pctVal)
                return prefix .. strPct .. "%"
            else
                local strVal = (precision > 0) and string.format("%." .. precision .. "f", val) or tostring(val)
                return prefix .. strVal .. suffix
            end
        end

        local ValueLabel = nil
        if showValue then
            ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "ValueLabel"
            ValueLabel.Size = UDim2.new(0, 95, 0, 16)
            ValueLabel.Position = UDim2.new(1, -98, 0, -18)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.FontFace = FontFingerPaintRegular
            ValueLabel.TextColor3 = Window.CurrentTheme.Text
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.TextYAlignment = Enum.TextYAlignment.Center
            ValueLabel.Text = GetFormattedValue(defaultVal, initialPct)
            ValueLabel.ZIndex = 14
            ValueLabel.Parent = TrackFrame
        end

        local FilledPart = Instance.new("Frame")
        FilledPart.Name = "Filledpart"
        FilledPart.Size = UDim2.new(initialPct, 0, 1, 0)
        FilledPart.BackgroundColor3 = Window.CurrentTheme.ButtonBG
        FilledPart.BorderSizePixel = 0
        FilledPart.ZIndex = 11
        FilledPart.Parent = TrackFrame

        local FilledCorner = Instance.new("UICorner")
        FilledCorner.CornerRadius = UDim.new(0, 33)
        FilledCorner.Parent = FilledPart

        local HandleFrame = Instance.new("Frame")
        HandleFrame.Name = "SliderHandle"
        HandleFrame.Size = UDim2.new(0, knobSize, 0, knobSize)
        HandleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        HandleFrame.Position = UDim2.new(initialPct, 0, 0.5, 0)
        HandleFrame.BackgroundTransparency = 1
        HandleFrame.ZIndex = 12
        HandleFrame.Parent = TrackFrame

        local BaseCircle = Instance.new("ImageLabel")
        BaseCircle.Name = GenerateSafeName("Knob")
        BaseCircle.Size = UDim2.new(1, 0, 1, 0)
        BaseCircle.BackgroundTransparency = 1
        BaseCircle.Image = "rbxassetid://118376432250064"
        BaseCircle.ZIndex = 12
        BaseCircle.Parent = HandleFrame

        local OverlayCircle = Instance.new("ImageLabel")
        OverlayCircle.Name = GenerateSafeName("Overlay")
        OverlayCircle.Size = UDim2.new(1, 0, 1, 0)
        OverlayCircle.BackgroundTransparency = 1
        OverlayCircle.Image = "rbxassetid://100354746235648"
        OverlayCircle.ImageColor3 = Window.CurrentTheme.ButtonBG
        OverlayCircle.ZIndex = 13
        OverlayCircle.Parent = HandleFrame

        local Trigger = Instance.new("TextButton")
        Trigger.Name = "SliderTrigger"
        Trigger.Size = UDim2.new(1, 24, 1, 28)
        Trigger.Position = UDim2.new(0, -12, 0, -14)
        Trigger.BackgroundTransparency = 1
        Trigger.Text = ""
        Trigger.ZIndex = 14
        Trigger.Parent = TrackFrame

        local onRelease = (type(sliderOptions) == "table" and (sliderOptions.OnRelease or sliderOptions.onRelease or sliderOptions.ReleaseCallback or sliderOptions.releaseCallback)) or nil
        local triggerOnRelease = (type(sliderOptions) == "table" and (sliderOptions.TriggerOnRelease == true or sliderOptions.OnlyOnRelease == true)) or false

        if triggerOnRelease and not onRelease and onValueChange then
            onRelease = onValueChange
        end

        local isDragging = false
        local currentVal = defaultVal
        local displayedVal = defaultVal
        local counterThread = nil
        local sliderData = nil

        local function AnimateValueLabel(targetVal, targetPct)
            local lbl = (sliderData and sliderData.ValueLabel) or ValueLabel
            if not lbl then return end
            if counterThread then
                task.cancel(counterThread)
                counterThread = nil
            end
            counterThread = task.spawn(function()
                local startVal = displayedVal
                local diff = targetVal - startVal
                if math.abs(diff) <= (0.01 * increment) then
                    displayedVal = targetVal
                    lbl.Text = GetFormattedValue(targetVal, targetPct)
                    return
                end
                local duration = 0.12
                local startTime = os.clock()
                while true do
                    local elapsed = os.clock() - startTime
                    local alpha = math.clamp(elapsed / duration, 0, 1)
                    local eased = 1 - math.pow(1 - alpha, 3)
                    displayedVal = SnapToIncrement(startVal + (diff * eased))
                    local curPct = (maxVal > minVal) and ((displayedVal - minVal) / (maxVal - minVal)) or 0
                    lbl.Text = GetFormattedValue(displayedVal, curPct)
                    if alpha >= 1 then break end
                    task.wait()
                end
                displayedVal = targetVal
                lbl.Text = GetFormattedValue(targetVal, targetPct)
            end)
        end

        local function UpdateSlider(inputPos, isFirstClick)
            local trackAbsPos = TrackFrame.AbsolutePosition.X
            local trackAbsSize = TrackFrame.AbsoluteSize.X
            if trackAbsSize <= 0 then return end
            local rawPct = math.clamp((inputPos - trackAbsPos) / trackAbsSize, 0, 1)
            local rawVal = minVal + (rawPct * (maxVal - minVal))
            local snappedVal = SnapToIncrement(rawVal)
            local pct = (maxVal > minVal) and math.clamp((snappedVal - minVal) / (maxVal - minVal), 0, 1) or 0

            FilledPart.Size = UDim2.new(pct, 0, 1, 0)
            HandleFrame.Position = UDim2.new(pct, 0, 0.5, 0)

            if snappedVal ~= currentVal or isFirstClick then
                currentVal = snappedVal
                AnimateValueLabel(currentVal, pct)
                if onValueChange and not triggerOnRelease then
                    pcall(onValueChange, currentVal, pct)
                end
            end
        end

        local function FireRelease()
            local pct = (maxVal > minVal) and math.clamp((currentVal - minVal) / (maxVal - minVal), 0, 1) or 0
            if onRelease then
                pcall(onRelease, currentVal, pct)
            end
            if triggerOnRelease and onValueChange and onValueChange ~= onRelease then
                pcall(onValueChange, currentVal, pct)
            end
        end

        local disabledScrollFrames = {}

        local function LockParentScroll()
            disabledScrollFrames = {}
            local cur = TrackFrame and TrackFrame.Parent
            while cur and cur ~= game and cur ~= ParentGui do
                if cur:IsA("ScrollingFrame") and cur.ScrollingEnabled then
                    cur.ScrollingEnabled = false
                    table.insert(disabledScrollFrames, cur)
                end
                cur = cur.Parent
            end
        end

        local function UnlockParentScroll()
            for _, sf in ipairs(disabledScrollFrames) do
                if sf and sf.Parent then
                    sf.ScrollingEnabled = true
                end
            end
            disabledScrollFrames = {}
        end

        local function StopDragging()
            if not isDragging then return end
            isDragging = false
            UnlockParentScroll()
            TweenService:Create(HandleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, knobSize, 0, knobSize)
            }):Play()
            FireRelease()
        end

        TrackConn(Trigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                LockParentScroll()
                TweenService:Create(HandleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, knobSize + 4, 0, knobSize + 4)
                }):Play()
                UpdateSlider(input.Position.X, true)
            end
        end))

        TrackConn(UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input.Position.X, false)
            end
        end))

        TrackConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                StopDragging()
            end
        end))

        TrackConn(UserInputService.WindowFocusReleased:Connect(function()
            if isDragging then
                StopDragging()
            end
        end))

        TrackConn(TrackFrame.AncestryChanged:Connect(function(_, newParent)
            if not newParent and isDragging then
                StopDragging()
            end
        end))

        local sliderName = identifier or ("Slider_" .. (#Window.RegisteredMDSliders + 1))
        sliderData = {
            Name = sliderName,
            Track = TrackFrame,
            FilledPart = FilledPart,
            Overlay = OverlayCircle,
            ValueLabel = ValueLabel,
            GetValue = function() return currentVal end,
            GetFormattedValue = function(val, pct)
                val = val or currentVal
                pct = pct or ((maxVal > minVal) and ((val - minVal) / (maxVal - minVal)) or 0)
                return GetFormattedValue(val, pct)
            end,
            GetIncrement = function() return increment end,
            SetIncrement = function(newInc, newPrec)
                increment = tonumber(newInc) or increment
                if increment <= 0 then increment = 1 end
                if newPrec ~= nil then
                    precision = tonumber(newPrec) or 0
                else
                    precision = GetDecimalPlaces(increment)
                end
                sliderData.SetValue(currentVal, false)
            end,
            SetValue = function(selfOrVal, maybeVal, maybeTrigger)
                local val, triggerCallback
                if type(selfOrVal) == "table" and selfOrVal == sliderData then
                    val = maybeVal
                    triggerCallback = maybeTrigger
                else
                    val = selfOrVal
                    triggerCallback = maybeVal
                end
                val = tonumber(val) or minVal
                val = SnapToIncrement(math.clamp(val, minVal, maxVal))
                currentVal = val
                local pct = (maxVal > minVal) and math.clamp((val - minVal) / (maxVal - minVal), 0, 1) or 0
                FilledPart.Size = UDim2.new(pct, 0, 1, 0)
                HandleFrame.Position = UDim2.new(pct, 0, 0.5, 0)
                AnimateValueLabel(currentVal, pct)
                if triggerCallback then
                    if onValueChange and not triggerOnRelease then
                        pcall(onValueChange, currentVal, pct)
                    end
                    if onRelease then
                        pcall(onRelease, currentVal, pct)
                    elseif triggerOnRelease and onValueChange then
                        pcall(onValueChange, currentVal, pct)
                    end
                end
            end,
            FireRelease = FireRelease,
            SetOnRelease = function(cb)
                onRelease = cb
            end,
            GetOnRelease = function()
                return onRelease
            end,
            SetSuffix = function(newSuffix)
                suffix = tostring(newSuffix or "")
                if suffix == "%" then
                    valueFormat = "percent"
                elseif valueFormat == "percent" and suffix ~= "%" then
                    valueFormat = "number"
                end
                local pct = (maxVal > minVal) and ((currentVal - minVal) / (maxVal - minVal)) or 0
                if ValueLabel then
                    ValueLabel.Text = GetFormattedValue(currentVal, pct)
                end
            end,
            GetSuffix = function()
                return suffix
            end,
            SetPrefix = function(newPrefix)
                prefix = tostring(newPrefix or "")
                local pct = (maxVal > minVal) and ((currentVal - minVal) / (maxVal - minVal)) or 0
                if ValueLabel then
                    ValueLabel.Text = GetFormattedValue(currentVal, pct)
                end
            end,
            GetPrefix = function()
                return prefix
            end,
            SetPrecision = function(newPrec)
                precision = tonumber(newPrec) or precision
                local pct = (maxVal > minVal) and ((currentVal - minVal) / (maxVal - minVal)) or 0
                if ValueLabel then
                    ValueLabel.Text = GetFormattedValue(currentVal, pct)
                end
            end,
            GetPrecision = function()
                return precision
            end,
            SetValueFormat = function(format, newSuffix, newPrefix)
                valueFormat = format or valueFormat
                if newSuffix ~= nil then suffix = tostring(newSuffix) end
                if newPrefix ~= nil then prefix = tostring(newPrefix) end
                local pct = (maxVal > minVal) and ((currentVal - minVal) / (maxVal - minVal)) or 0
                if ValueLabel then
                    ValueLabel.Text = GetFormattedValue(currentVal, pct)
                end
            end,
            RefreshTheme = function(theme)
                TrackFrame.BackgroundColor3 = GetThemedDarkColor(theme)
                FilledPart.BackgroundColor3 = theme.ButtonBG
                OverlayCircle.ImageColor3 = theme.ButtonBG
                if ValueLabel then
                    ValueLabel.TextColor3 = theme.Text
                end
            end,
            WithCallback = function(self, cb)
                onValueChange = cb
                return self
            end,
            WithTooltip = function(self, tt)
                if Window.AttachTooltip and TrackFrame then
                    Window:AttachTooltip(TrackFrame, tt)
                end
                return self
            end,
            WithSaveKey = function(self, key)
                if key and key ~= "" then
                    Window.RegisteredSliders[key] = self
                end
                return self
            end,
            WithValue = function(self, val)
                self.SetValue(val, true)
                return self
            end
        }
        local actualSliderKey = (type(sliderOptions) == "table" and (sliderOptions.SaveKey or sliderOptions.saveKey or sliderOptions.Id or sliderOptions.id or sliderOptions.Identifier or sliderOptions.identifier)) or (identifier and identifier ~= "" and identifier) or sliderName or ("Slider_" .. (#Window.RegisteredMDSliders + 1))
        sliderData.Name = actualSliderKey
        sliderData.SaveKey = actualSliderKey
        Window.RegisteredSliders[actualSliderKey] = sliderData
        if sliderName and sliderName ~= "" and not Window.RegisteredSliders[sliderName] then
            Window.RegisteredSliders[sliderName] = sliderData
        end
        if identifier and identifier ~= "" and not Window.RegisteredSliders[identifier] then
            Window.RegisteredSliders[identifier] = sliderData
        end
        if type(sliderOptions) == "table" then
            local altId = sliderOptions.Id or sliderOptions.id or sliderOptions.Identifier or sliderOptions.identifier or sliderOptions.SaveKey or sliderOptions.saveKey
            if altId and not Window.RegisteredSliders[altId] then
                Window.RegisteredSliders[altId] = sliderData
            end
            if sliderOptions.Title and sliderOptions.Title ~= "" and not Window.RegisteredSliders[sliderOptions.Title] then
                Window.RegisteredSliders[sliderOptions.Title] = sliderData
            end
        end
        table.insert(Window.RegisteredMDSliders, sliderData)
        return sliderData
    end

    -- Color picker modal and widget generator
    local ActiveColorPickerModal = nil
    local ActiveColorPickerCleanup = nil

    function Window:OpenColorPicker(title, initialColor, onColorSelected)
        if ActiveColorPickerCleanup then
            pcall(ActiveColorPickerCleanup)
            ActiveColorPickerCleanup = nil
        end
        if ActiveColorPickerModal and ActiveColorPickerModal.Parent then
            ActiveColorPickerModal:Destroy()
            ActiveColorPickerModal = nil
        end

        initialColor = initialColor or Color3.fromRGB(255, 255, 255)
        local curH, curS, curV = initialColor:ToHSV()
        local selectedColor = initialColor

        local ModalBackdrop = Instance.new("Frame")
        ModalBackdrop.Name = GenerateSafeName("Backdrop")
        ModalBackdrop.Size = UDim2.new(1, 0, 1, 0)
        ModalBackdrop.Position = UDim2.new(0, 0, 0, 0)
        ModalBackdrop.BackgroundTransparency = 1
        ModalBackdrop.BorderSizePixel = 0
        ModalBackdrop.Active = false
        ModalBackdrop.ZIndex = 80
        ModalBackdrop.Parent = ScriptUi

        ActiveColorPickerModal = ModalBackdrop

        local modalConns = {}
        local function TrackModalConn(conn)
            table.insert(modalConns, conn)
            TrackConn(conn)
            return conn
        end

        local function DisconnectModalConns()
            for _, conn in ipairs(modalConns) do
                pcall(function()
                    if conn and conn.Disconnect then
                        conn:Disconnect()
                    end
                end)
            end
            table.clear(modalConns)
        end

        ActiveColorPickerCleanup = DisconnectModalConns

        local ModalCard = Instance.new("Frame")
        ModalCard.Name = "ColorPickerModal"
        ModalCard.Size = UDim2.new(0, 290, 0, 310)
        ModalCard.AnchorPoint = Vector2.new(0.5, 0.5)
        ModalCard.Position = UDim2.new(0.5, 0, 0.5, 20)
        ModalCard.BackgroundColor3 = Window.CurrentTheme.CardBG
        ModalCard.BackgroundTransparency = 0.02
        ModalCard.BorderSizePixel = 0
        ModalCard.ZIndex = 81
        ModalCard.Parent = ModalBackdrop

        local ModalCorner = Instance.new("UICorner")
        ModalCorner.CornerRadius = UDim.new(0, 12)
        ModalCorner.Parent = ModalCard

        local ModalStroke = Instance.new("UIStroke")
        ModalStroke.Thickness = 1.4
        ModalStroke.Color = Color3.fromRGB(255, 255, 255)
        ModalStroke.Transparency = 1
        ModalStroke.Parent = ModalCard

        AddUIShadow(ModalCard, 28, 0.6)

        local HeaderLabel = Instance.new("TextLabel")
        HeaderLabel.Name = "HeaderTitle"
        HeaderLabel.Size = UDim2.new(1, -50, 0, 32)
        HeaderLabel.Position = UDim2.new(0, 14, 0, 4)
        HeaderLabel.BackgroundTransparency = 1
        HeaderLabel.FontFace = FontFingerPaintBold
        HeaderLabel.Text = title or "Select color"
        HeaderLabel.TextColor3 = Window.CurrentTheme.Text
        HeaderLabel.TextSize = 12
        HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
        HeaderLabel.Active = true
        HeaderLabel.ZIndex = 82
        HeaderLabel.Parent = ModalCard

        AttachUniversalDrag(HeaderLabel, ModalCard)

        local CloseModalBtn = Instance.new("ImageButton")
        CloseModalBtn.Name = "CloseBtn"
        CloseModalBtn.Size = UDim2.new(0, 22, 0, 22)
        CloseModalBtn.Position = UDim2.new(1, -30, 0, 8)
        CloseModalBtn.BackgroundTransparency = 1
        CloseModalBtn.Image = "rbxassetid://132261474823036"
        CloseModalBtn.ImageColor3 = Window.CurrentTheme.Text or Color3.fromRGB(245, 245, 250)
        CloseModalBtn.ZIndex = 83
        CloseModalBtn.Parent = ModalCard

        TrackModalConn(CloseModalBtn.MouseEnter:Connect(PlayHoverSFX))

        local SVBox = Instance.new("Frame")
        SVBox.Name = "SVBox"
        SVBox.Size = UDim2.new(1, -28, 0, 125)
        SVBox.Position = UDim2.new(0, 14, 0, 38)
        SVBox.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)
        SVBox.BorderSizePixel = 0
        SVBox.ClipsDescendants = false
        SVBox.ZIndex = 82
        SVBox.Parent = ModalCard

        local SVCorner = Instance.new("UICorner")
        SVCorner.CornerRadius = UDim.new(0, 6)
        SVCorner.Parent = SVBox

        local WhiteGradFrame = Instance.new("Frame")
        WhiteGradFrame.Size = UDim2.new(1, 0, 1, 0)
        WhiteGradFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        WhiteGradFrame.BorderSizePixel = 0
        WhiteGradFrame.ZIndex = 82
        WhiteGradFrame.Parent = SVBox

        local WhiteGradCorner = Instance.new("UICorner")
        WhiteGradCorner.CornerRadius = UDim.new(0, 6)
        WhiteGradCorner.Parent = WhiteGradFrame

        local WhiteGrad = Instance.new("UIGradient")
        WhiteGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
        WhiteGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        WhiteGrad.Rotation = 0
        WhiteGrad.Parent = WhiteGradFrame

        local BlackGradFrame = Instance.new("Frame")
        BlackGradFrame.Size = UDim2.new(1, 0, 1, 0)
        BlackGradFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        BlackGradFrame.BorderSizePixel = 0
        BlackGradFrame.ZIndex = 83
        BlackGradFrame.Parent = SVBox

        local BlackGradCorner = Instance.new("UICorner")
        BlackGradCorner.CornerRadius = UDim.new(0, 6)
        BlackGradCorner.Parent = BlackGradFrame

        local BlackGrad = Instance.new("UIGradient")
        BlackGrad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
        BlackGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        })
        BlackGrad.Rotation = 90
        BlackGrad.Parent = BlackGradFrame

        local SVHandle = Instance.new("Frame")
        SVHandle.Name = "SVHandle"
        SVHandle.Size = UDim2.new(0, 14, 0, 14)
        SVHandle.AnchorPoint = Vector2.new(0.5, 0.5)
        SVHandle.Position = UDim2.new(curS, 0, 1 - curV, 0)
        SVHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SVHandle.BorderSizePixel = 0
        SVHandle.ZIndex = 85
        SVHandle.Parent = SVBox

        local SVHandleCorner = Instance.new("UICorner")
        SVHandleCorner.CornerRadius = UDim.new(1, 0)
        SVHandleCorner.Parent = SVHandle

        local SVHandleStroke = Instance.new("UIStroke")
        SVHandleStroke.Thickness = 1.5
        SVHandleStroke.Color = Color3.fromRGB(0, 0, 0)
        SVHandleStroke.Parent = SVHandle

        local SVTrigger = Instance.new("TextButton")
        SVTrigger.Name = "SVTrigger"
        SVTrigger.Size = UDim2.new(1, 0, 1, 0)
        SVTrigger.BackgroundTransparency = 1
        SVTrigger.Text = ""
        SVTrigger.ZIndex = 86
        SVTrigger.Parent = SVBox

        local HueBar = Instance.new("Frame")
        HueBar.Name = "HueBar"
        HueBar.Size = UDim2.new(1, -28, 0, 14)
        HueBar.Position = UDim2.new(0, 14, 0, 172)
        HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HueBar.BorderSizePixel = 0
        HueBar.ClipsDescendants = false
        HueBar.ZIndex = 82
        HueBar.Parent = ModalCard

        local HueCorner = Instance.new("UICorner")
        HueCorner.CornerRadius = UDim.new(0, 7)
        HueCorner.Parent = HueBar

        local HueGrad = Instance.new("UIGradient")
        HueGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
        })
        HueGrad.Parent = HueBar

        local HueHandle = Instance.new("Frame")
        HueHandle.Name = "HueHandle"
        HueHandle.Size = UDim2.new(0, 16, 0, 16)
        HueHandle.AnchorPoint = Vector2.new(0.5, 0.5)
        HueHandle.Position = UDim2.new(curH, 0, 0.5, 0)
        HueHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HueHandle.BorderSizePixel = 0
        HueHandle.ZIndex = 85
        HueHandle.Parent = HueBar

        local HueHandleCorner = Instance.new("UICorner")
        HueHandleCorner.CornerRadius = UDim.new(1, 0)
        HueHandleCorner.Parent = HueHandle

        local HueHandleStroke = Instance.new("UIStroke")
        HueHandleStroke.Thickness = 1.5
        HueHandleStroke.Color = Color3.fromRGB(0, 0, 0)
        HueHandleStroke.Parent = HueHandle

        local HueTrigger = Instance.new("TextButton")
        HueTrigger.Name = "HueTrigger"
        HueTrigger.Size = UDim2.new(1, 0, 1, 0)
        HueTrigger.BackgroundTransparency = 1
        HueTrigger.Text = ""
        HueTrigger.ZIndex = 86
        HueTrigger.Parent = HueBar

        local PreviewSwatch = Instance.new("Frame")
        PreviewSwatch.Name = "PreviewSwatch"
        PreviewSwatch.Size = UDim2.new(0, 36, 0, 26)
        PreviewSwatch.Position = UDim2.new(0, 14, 0, 196)
        PreviewSwatch.BackgroundColor3 = initialColor
        PreviewSwatch.BorderSizePixel = 0
        PreviewSwatch.ZIndex = 82
        PreviewSwatch.Parent = ModalCard

        local SwatchCorner = Instance.new("UICorner")
        SwatchCorner.CornerRadius = UDim.new(0, 6)
        SwatchCorner.Parent = PreviewSwatch

        local SwatchStroke = Instance.new("UIStroke")
        SwatchStroke.Thickness = 1.2
        SwatchStroke.Color = Color3.fromRGB(255, 255, 255)
        SwatchStroke.Transparency = 0.5
        SwatchStroke.Parent = PreviewSwatch

        local HexContainer = Instance.new("Frame")
        HexContainer.Name = "HexContainer"
        HexContainer.Size = UDim2.new(1, -62, 0, 26)
        HexContainer.Position = UDim2.new(0, 56, 0, 196)
        HexContainer.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
        HexContainer.BorderSizePixel = 0
        HexContainer.ZIndex = 82
        HexContainer.Parent = ModalCard

        local HexCorner = Instance.new("UICorner")
        HexCorner.CornerRadius = UDim.new(0, 6)
        HexCorner.Parent = HexContainer

        local HexBox = Instance.new("TextBox")
        HexBox.Name = "HexBox"
        HexBox.Size = UDim2.new(1, -12, 1, 0)
        HexBox.Position = UDim2.new(0, 6, 0, 0)
        HexBox.BackgroundTransparency = 1
        HexBox.FontFace = FontFingerPaintRegular
        HexBox.PlaceholderText = "#FFFFFF"
        HexBox.PlaceholderColor3 = Window.CurrentTheme.SubText
        HexBox.Text = "#" .. initialColor:ToHex():upper()
        HexBox.TextColor3 = Window.CurrentTheme.Text
        HexBox.TextSize = 11
        HexBox.ClearTextOnFocus = false
        HexBox.ZIndex = 83
        HexBox.Parent = HexContainer

        local PresetsRow = Instance.new("Frame")
        PresetsRow.Name = "PresetsRow"
        PresetsRow.Size = UDim2.new(1, -28, 0, 22)
        PresetsRow.Position = UDim2.new(0, 14, 0, 230)
        PresetsRow.BackgroundTransparency = 1
        PresetsRow.ZIndex = 82
        PresetsRow.Parent = ModalCard

        local PresetsLayout = Instance.new("UIListLayout")
        PresetsLayout.FillDirection = Enum.FillDirection.Horizontal
        PresetsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PresetsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        PresetsLayout.Padding = UDim.new(0, 6)
        PresetsLayout.Parent = PresetsRow

        local presetColors = {
            Color3.fromRGB(255, 60, 60),
            Color3.fromRGB(255, 145, 0),
            Color3.fromRGB(255, 225, 0),
            Color3.fromRGB(60, 220, 90),
            Color3.fromRGB(0, 210, 255),
            Color3.fromRGB(60, 120, 255),
            Color3.fromRGB(180, 80, 255),
            Color3.fromRGB(255, 255, 255)
        }

        local ApplyBtn = Instance.new("TextButton")
        ApplyBtn.Name = "ApplyButton"
        ApplyBtn.Size = UDim2.new(1, -28, 0, 32)
        ApplyBtn.Position = UDim2.new(0, 14, 0, 262)
        ApplyBtn.BackgroundColor3 = Window.CurrentTheme.ButtonBG
        ApplyBtn.BorderSizePixel = 0
        ApplyBtn.FontFace = FontTabBtn
        ApplyBtn.Text = "Apply color"
        ApplyBtn.TextColor3 = GetOnAccent(Window.CurrentTheme.ButtonBG)
        ApplyBtn.TextSize = 12
        ApplyBtn.ZIndex = 83
        ApplyBtn.Parent = ModalCard

        local ApplyCorner = Instance.new("UICorner")
        ApplyCorner.CornerRadius = UDim.new(0, 8)
        ApplyCorner.Parent = ApplyBtn

        local isDraggingSV = false
        local isDraggingHue = false

        local function RefreshAll(source)
            curH = math.clamp(curH, 0, 1)
            curS = math.clamp(curS, 0, 1)
            curV = math.clamp(curV, 0, 1)

            selectedColor = Color3.fromHSV(curH, curS, curV)
            SVBox.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)
            SVHandle.Position = UDim2.new(curS, 0, 1 - curV, 0)
            HueHandle.Position = UDim2.new(curH, 0, 0.5, 0)
            PreviewSwatch.BackgroundColor3 = selectedColor

            if source ~= "hex" then
                HexBox.Text = "#" .. selectedColor:ToHex():upper()
            end
        end

        local function UpdateSV(inputX, inputY)
            local absPos = SVBox.AbsolutePosition
            local absSize = SVBox.AbsoluteSize
            if absSize.X <= 0 or absSize.Y <= 0 then return end
            curS = math.clamp((inputX - absPos.X) / absSize.X, 0, 1)
            curV = math.clamp(1 - ((inputY - absPos.Y) / absSize.Y), 0, 1)
            RefreshAll("sv")
        end

        local function UpdateHue(inputX)
            local absPos = HueBar.AbsolutePosition
            local absSize = HueBar.AbsoluteSize
            if absSize.X <= 0 then return end
            curH = math.clamp((inputX - absPos.X) / absSize.X, 0, 1)
            RefreshAll("hue")
        end

        TrackModalConn(SVTrigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingSV = true
                UpdateSV(input.Position.X, input.Position.Y)
            end
        end))

        TrackModalConn(HueTrigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingHue = true
                UpdateHue(input.Position.X)
            end
        end))

        TrackModalConn(UserInputService.InputChanged:Connect(function(input)
            if isDraggingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSV(input.Position.X, input.Position.Y)
            elseif isDraggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateHue(input.Position.X)
            end
        end))

        TrackModalConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingSV = false
                isDraggingHue = false
            end
        end))

        TrackModalConn(HexBox.FocusLost:Connect(function()
            local raw = HexBox.Text:gsub("#", ""):gsub("%s+", "")
            local success, col = pcall(function() return Color3.fromHex(raw) end)
            if success and col then
                curH, curS, curV = col:ToHSV()
                RefreshAll("hex")
            else
                HexBox.Text = "#" .. selectedColor:ToHex():upper()
            end
        end))

        for _, col in ipairs(presetColors) do
            local dot = Instance.new("TextButton")
            dot.Size = UDim2.new(0, 20, 0, 20)
            dot.BackgroundColor3 = col
            dot.Text = ""
            dot.BorderSizePixel = 0
            dot.ZIndex = 83
            dot.Parent = PresetsRow

            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dot

            local dotStroke = Instance.new("UIStroke")
            dotStroke.Thickness = 1.2
            dotStroke.Color = Color3.fromRGB(255, 255, 255)
            dotStroke.Transparency = 1
            dotStroke.Parent = dot

            TrackModalConn(dot.MouseButton1Click:Connect(function()
                PlayClickSFX()
                curH, curS, curV = col:ToHSV()
                RefreshAll("preset")
            end))
        end

        local function CloseModal()
            PlayClickSFX()
            DisconnectModalConns()
            if ActiveColorPickerCleanup == DisconnectModalConns then
                ActiveColorPickerCleanup = nil
            end
            local t = TweenService:Create(ModalCard, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0.5, 40),
                Size = UDim2.new(0, 270, 0, 290)
            })
            t:Play()
            t.Completed:Connect(function()
                if ModalBackdrop and ModalBackdrop.Parent then
                    ModalBackdrop:Destroy()
                end
                if ActiveColorPickerModal == ModalBackdrop then
                    ActiveColorPickerModal = nil
                end
            end)
        end

        TrackModalConn(CloseModalBtn.MouseButton1Click:Connect(CloseModal))


        TrackModalConn(ApplyBtn.MouseButton1Click:Connect(function()
            PlayClickSFX()
            if onColorSelected then
                pcall(onColorSelected, selectedColor)
            end
            CloseModal()
        end))

        -- Animate In 
        ModalBackdrop.BackgroundTransparency = 1
        TweenService:Create(ModalCard, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 290, 0, 310)
        }):Play()

        RefreshAll("init")
    end

    -- Confirmation modal 
    function Window:Confirm(titleOrOptions, message, onYes, onNo)
        local title, desc, yesText, noText
        if type(titleOrOptions) == "table" then
            title = titleOrOptions.Title or titleOrOptions.title or "Confirm"
            desc = titleOrOptions.Message or titleOrOptions.Description or titleOrOptions.text or message or "Are you sure?"
            yesText = titleOrOptions.ConfirmText or titleOrOptions.YesText or "Confirm"
            noText = titleOrOptions.CancelText or titleOrOptions.NoText or "Cancel"
            onYes = titleOrOptions.OnConfirm or titleOrOptions.onConfirm or onYes
            onNo = titleOrOptions.OnCancel or titleOrOptions.onCancel or onNo
        else
            title = titleOrOptions or "Confirm"
            desc = message or "Are you sure?"
            yesText = "Confirm"
            noText = "Cancel"
        end

        local ConfirmBackdrop = Instance.new("Frame")
        ConfirmBackdrop.Name = GenerateSafeName("Backdrop")
        ConfirmBackdrop.Size = UDim2.new(1, 0, 1, 0)
        ConfirmBackdrop.Position = UDim2.new(0, 0, 0, 0)
        ConfirmBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ConfirmBackdrop.BackgroundTransparency = 1
        ConfirmBackdrop.BorderSizePixel = 0
        ConfirmBackdrop.Active = false
        ConfirmBackdrop.ZIndex = 120
        ConfirmBackdrop.Parent = ScriptUi

        local ModalCard = Instance.new("Frame")
        ModalCard.Name = "ConfirmModal"
        ModalCard.Size = UDim2.new(0, 320, 0, 150)
        ModalCard.AnchorPoint = Vector2.new(0.5, 0.5)
        ModalCard.Position = UDim2.new(0.5, 0, 0.5, 20)
        ModalCard.BackgroundColor3 = Window.CurrentTheme.CardBG
        ModalCard.BackgroundTransparency = 0.02
        ModalCard.BorderSizePixel = 0
        ModalCard.ZIndex = 121
        ModalCard.Parent = ConfirmBackdrop

        local ModalCorner = Instance.new("UICorner")
        ModalCorner.CornerRadius = UDim.new(0, 10)
        ModalCorner.Parent = ModalCard

        AddUIShadow(ModalCard, 24, 0.55)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -24, 0, 26)
        TitleLabel.Position = UDim2.new(0, 12, 0, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.FontFace = FontFingerPaintBold
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Window.CurrentTheme.Text
        TitleLabel.TextSize = 13
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 122
        TitleLabel.Parent = ModalCard

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -24, 0, 52)
        DescLabel.Position = UDim2.new(0, 12, 0, 38)
        DescLabel.BackgroundTransparency = 1
        DescLabel.FontFace = FontFingerPaintRegular
        DescLabel.Text = desc
        DescLabel.TextColor3 = Window.CurrentTheme.SubText
        DescLabel.TextSize = 11
        DescLabel.TextWrapped = true
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.ZIndex = 122
        DescLabel.Parent = ModalCard

        local BtnRow = Instance.new("Frame")
        BtnRow.Size = UDim2.new(1, -24, 0, 32)
        BtnRow.Position = UDim2.new(0, 12, 1, -42)
        BtnRow.BackgroundTransparency = 1
        BtnRow.ZIndex = 122
        BtnRow.Parent = ModalCard

        local CancelBtn = Instance.new("TextButton")
        CancelBtn.Size = UDim2.new(0.48, 0, 1, 0)
        CancelBtn.Position = UDim2.new(0, 0, 0, 0)
        CancelBtn.BackgroundColor3 = (Window.CurrentTheme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(220, 225, 235) or Color3.fromRGB(35, 38, 48)
        CancelBtn.BorderSizePixel = 0
        CancelBtn.FontFace = FontFingerPaintRegular
        CancelBtn.Text = noText
        CancelBtn.TextColor3 = Window.CurrentTheme.Text
        CancelBtn.TextSize = 11
        CancelBtn.ZIndex = 123
        CancelBtn.Parent = BtnRow

        local CancelCorner = Instance.new("UICorner")
        CancelCorner.CornerRadius = UDim.new(0, 8)
        CancelCorner.Parent = CancelBtn

        local YesBtn = Instance.new("TextButton")
        YesBtn.Size = UDim2.new(0.48, 0, 1, 0)
        YesBtn.Position = UDim2.new(0.52, 0, 0, 0)
        YesBtn.BackgroundColor3 = Window.CurrentTheme.ButtonBG
        YesBtn.BorderSizePixel = 0
        YesBtn.FontFace = FontTabBtn
        YesBtn.Text = yesText
        YesBtn.TextColor3 = GetOnAccent(Window.CurrentTheme.ButtonBG)
        YesBtn.TextSize = 11
        YesBtn.ZIndex = 123
        YesBtn.Parent = BtnRow

        local YesCorner = Instance.new("UICorner")
        YesCorner.CornerRadius = UDim.new(0, 8)
        YesCorner.Parent = YesBtn

        local function Close()
            PlayClickSFX()
            TweenService:Create(ModalCard, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0.5, 20),
                Size = UDim2.new(0, 300, 0, 130)
            }):Play()
            task.delay(0.18, function()
                if ConfirmBackdrop and ConfirmBackdrop.Parent then
                    ConfirmBackdrop:Destroy()
                end
            end)
        end

        CancelBtn.MouseButton1Click:Connect(function()
            Close()
            if onNo then pcall(onNo) end
        end)

        YesBtn.MouseButton1Click:Connect(function()
            Close()
            if onYes then pcall(onYes) end
        end)

        TweenService:Create(ModalCard, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 320, 0, 150)
        }):Play()
    end
    Window.PromptConfirm = Window.Confirm

    function Window:CreateMDColorPicker(parent, position, size, title, defaultColor, onColorChanged, identifier, colorConfig)
        parent = ResolveParent(parent)
        size = size or UDim2.new(1, 0, 0, 44)
        position = position or UDim2.new(0, 0, 0, 0)
        defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)

        local inSection = IsInsideSection(parent)
        local CardFrame = Instance.new("Frame")
        CardFrame.Name = "ColorPickerCard"
        CardFrame:SetAttribute("MDCard", true)
        CardFrame.Size = size
        CardFrame.Position = position
        CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        CardFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
        CardFrame.BorderSizePixel = 0
        CardFrame.ZIndex = 10
        CardFrame.Parent = parent

        local connectMode = nil
        if type(colorConfig) == "table" then
            connectMode = colorConfig.Connect or colorConfig.Connected or colorConfig.connectMode or colorConfig.PositionInGroup
        elseif type(identifier) == "table" then
            connectMode = identifier.Connect or identifier.Connected or identifier.connectMode or identifier.PositionInGroup
        end

        local Corner = Instance.new("UICorner")
        if connectMode == "Top" or connectMode == "First" then
            ApplyCornerRadii(Corner, 12, 12, 0, 0)
        elseif connectMode == "Middle" then
            ApplyCornerRadii(Corner, 0, 0, 0, 0)
        elseif connectMode == "Bottom" or connectMode == "Last" then
            ApplyCornerRadii(Corner, 0, 0, 12, 12)
        elseif connectMode == "Left" then
            ApplyCornerRadii(Corner, 12, 0, 0, 12)
        elseif connectMode == "Right" then
            ApplyCornerRadii(Corner, 0, 12, 12, 0)
        else
            Corner.CornerRadius = UDim.new(0, 12)
        end
        Corner.Parent = CardFrame

        if not connectMode then
            local shadow = AddUIShadow(CardFrame, 20, 0.5)
            if inSection and Window.SectionsTransparent and shadow then
                pcall(function() shadow.Visible = false end)
            end
        end

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "TitleLabel"
        TitleLabel.Size = UDim2.new(1, -65, 1, 0)
        TitleLabel.Position = UDim2.new(0, 14, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.FontFace = FontFingerPaintRegular
        TitleLabel.Text = title or "Color"
        TitleLabel.TextColor3 = Window.CurrentTheme.Text
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
        TitleLabel.ZIndex = 11
        TitleLabel.Parent = CardFrame

        local SwatchButton = Instance.new("TextButton")
        SwatchButton.Name = "SwatchButton"
        SwatchButton.Size = UDim2.new(0, 36, 0, 24)
        SwatchButton.Position = UDim2.new(1, -48, 0.5, -12)
        SwatchButton.BackgroundColor3 = defaultColor
        SwatchButton.BorderSizePixel = 0
        SwatchButton.Text = ""
        SwatchButton.ZIndex = 12
        SwatchButton.Parent = CardFrame

        local SwatchCorner = Instance.new("UICorner")
        SwatchCorner.CornerRadius = UDim.new(0, 6)
        SwatchCorner.Parent = SwatchButton

        local SwatchStroke = Instance.new("UIStroke")
        SwatchStroke.Thickness = 1.2
        SwatchStroke.Color = Color3.fromRGB(255, 255, 255)
        SwatchStroke.Transparency = 0.4
        SwatchStroke.Parent = SwatchButton

        local currentColor = defaultColor

        local colorPickerName = (colorConfig and type(colorConfig) == "table" and (colorConfig.SaveKey or colorConfig.saveKey or colorConfig.Identifier or colorConfig.identifier or colorConfig.Id or colorConfig.id)) or identifier or (title and title ~= "" and title) or ("ColorPicker_" .. (#Window.RegisteredColorPickersList + 1))
        local colorPickerData = {
            Name = colorPickerName,
            SaveKey = colorPickerName,
            Frame = CardFrame,
            Swatch = SwatchButton,
            GetColor = function() return currentColor end,
            SetColor = function(col, triggerCallback)
                currentColor = col
                SwatchButton.BackgroundColor3 = col
                if triggerCallback and onColorChanged then
                    pcall(onColorChanged, col)
                end
            end,
            RefreshTheme = function(theme)
                local inSec = IsInsideSection(CardFrame)
                CardFrame.BackgroundColor3 = theme.CardBG
                CardFrame.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                TitleLabel.TextColor3 = theme.Text
            end
        }

        colorPickerData.WithCallback = function(self, cb)
            onColorChanged = cb
            return self
        end
        colorPickerData.WithTooltip = function(self, tt)
            if Window.AttachTooltip and CardFrame then
                Window:AttachTooltip(CardFrame, tt)
            end
            return self
        end
        colorPickerData.WithSaveKey = function(self, key)
            if key and key ~= "" then
                self.SaveKey = key
                Window.RegisteredColorPickers[key] = self
            end
            return self
        end
        colorPickerData.WithColor = function(self, col, triggerCb)
            self.SetColor(col, triggerCb)
            return self
        end

        TrackConn(SwatchButton.MouseButton1Click:Connect(function()
            PlayClickSFX()
            Window:OpenColorPicker(title, currentColor, function(newCol)
                colorPickerData.SetColor(newCol, true)
            end)
        end))

        Window.RegisteredColorPickers[colorPickerName] = colorPickerData
        if identifier and identifier ~= colorPickerName then
            Window.RegisteredColorPickers[identifier] = colorPickerData
        end
        if title and title ~= "" and not Window.RegisteredColorPickers[title] then
            Window.RegisteredColorPickers[title] = colorPickerData
        end
        if colorConfig and type(colorConfig) == "table" then
            local altId = colorConfig.Id or colorConfig.id or colorConfig.Identifier or colorConfig.identifier or colorConfig.SaveKey or colorConfig.saveKey
            if altId and not Window.RegisteredColorPickers[altId] then
                Window.RegisteredColorPickers[altId] = colorPickerData
            end
        end
        table.insert(Window.RegisteredColorPickersList, colorPickerData)
        return colorPickerData
    end

    -- Size fractions and row width engine
    local function ResolveSizeFraction(sizeInput, defaultFraction)
        if sizeInput == nil then
            return defaultFraction or 1.0, nil
        end
        if typeof(sizeInput) == "UDim2" then
            return nil, sizeInput
        end
        if type(sizeInput) == "number" then
            return math.clamp(sizeInput, 0.05, 1.0), nil
        end
        if type(sizeInput) == "string" then
            local lower = sizeInput:lower():gsub("%s+", "")
            if lower == "1" or lower == "full" or lower == "100%" or lower == "1/1" or lower == "single" then
                return 1.0, nil
            elseif lower == "1/2" or lower == "half" or lower == "50%" or lower == "0.5" or lower == "dual" then
                return 0.5, nil
            elseif lower == "1/3" or lower == "third" or lower == "33%" or lower == "0.33" or lower == "0.333" or lower == "triple" then
                return 1/3, nil
            elseif lower == "2/3" or lower == "two-thirds" or lower == "66%" or lower == "0.66" or lower == "0.666" or lower == "0.67" then
                return 2/3, nil
            elseif lower == "1/4" or lower == "quarter" or lower == "fourth" or lower == "25%" or lower == "0.25" or lower == "quad" then
                return 0.25, nil
            elseif lower == "3/4" or lower == "three-fourths" or lower == "75%" or lower == "0.75" then
                return 0.75, nil
            else
                local num = tonumber(lower)
                if num then
                    return math.clamp(num, 0.05, 1.0), nil
                end
            end
        end
        return defaultFraction or 1.0, nil
    end

    local function ComputeRowItemWidth(fraction, height)
        height = height or 31
        if not fraction or fraction >= 0.98 then
            return UDim2.new(1, 0, 0, height)
        elseif fraction >= 0.48 and fraction <= 0.52 then
            return UDim2.new(0.5, -4, 0, height)
        elseif fraction >= 0.31 and fraction <= 0.35 then
            return UDim2.new(0.3333, -5, 0, height)
        elseif fraction >= 0.64 and fraction <= 0.68 then
            return UDim2.new(0.6666, -5, 0, height)
        elseif fraction >= 0.23 and fraction <= 0.27 then
            return UDim2.new(0.25, -6, 0, height)
        elseif fraction >= 0.73 and fraction <= 0.77 then
            return UDim2.new(0.75, -6, 0, height)
        else
            local items = math.max(1, math.floor((1 / fraction) + 0.5))
            local gapSub = math.floor(((items - 1) * 8 / items) + 0.5)
            return UDim2.new(fraction, -gapSub, 0, height)
        end
    end

    function Window:CreateMDButtonLong(parent, position, size, text, onClick, icon, showArrow)
        local btnText, callback, btnSize, btnPos, targetParent, btnIcon, btnArrow

        if type(parent) == "table" and not parent.IsA and not parent.Frame and not parent.Instance then
            targetParent = parent.Parent or parent.parent or parent.Row or parent[1]
            btnPos = parent.Position or parent.pos or UDim2.new(0, 0, 0, 0)
            btnSize = parent.Size or parent.size or parent.Fraction or parent[2]
            btnText = parent.Text or parent.text or parent.Title or parent.Name or parent[3] or "Button"
            callback = parent.Callback or parent.callback or parent.OnClick or parent[4]
            btnIcon = parent.Icon or parent.icon or parent.IconAsset
            btnArrow = parent.ShowArrow
        else
            targetParent = parent
            btnPos = position or UDim2.new(0, 0, 0, 0)
            btnSize = size
            btnText = text or "Function"
            callback = onClick
            btnIcon = icon
            btnArrow = showArrow
        end

        local fraction, explicitUDim = ResolveSizeFraction(btnSize, nil)
        if explicitUDim then
            size = explicitUDim
        elseif fraction then
            size = ComputeRowItemWidth(fraction, 31)
        else
            size = UDim2.new(1, 0, 0, 31)
        end
        position = btnPos or UDim2.new(0, 0, 0, 0)
        text = btnText or "Function"
        onClick = callback

        local resolvedParent = ResolveParent(targetParent or parent)
        local inRow = resolvedParent and (resolvedParent.Name == "RowFrame" or resolvedParent:FindFirstChildOfClass("UIListLayout") ~= nil)
        local isSmall = (size and size.Y.Offset <= 28) or inRow

        local BtnFrame = Instance.new("Frame")
        BtnFrame.Name = "MDButtonCard"
        BtnFrame.Size = size
        BtnFrame.AnchorPoint = inRow and Vector2.new(0, 0) or Vector2.new(0.5, 0.5)
        if inRow then
            BtnFrame.Position = position or UDim2.new(0, 0, 0, 0)
        else
            BtnFrame.Position = UDim2.new(
                position.X.Scale + 0.5 * size.X.Scale,
                position.X.Offset + math.floor(size.X.Offset * 0.5),
                position.Y.Scale + 0.5 * size.Y.Scale,
                position.Y.Offset + math.floor(size.Y.Offset * 0.5)
            )
        end
        BtnFrame.BorderSizePixel = 0
        BtnFrame.ZIndex = inRow and 12 or 10
        BtnFrame.Parent = resolvedParent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = BtnFrame

        AddUIShadow(BtnFrame, isSmall and 8 or 20, 0.45)

        local BtnScale = Instance.new("UIScale")
        BtnScale.Scale = 1.0
        BtnScale.Parent = BtnFrame

        local parts = BuildMDButtonContent(BtnFrame, text, btnIcon, isSmall, btnArrow ~= false, inRow and 13 or 11, "btntext")

        local ClickBtn = Instance.new("TextButton")
        ClickBtn.Name = GenerateSafeName("Trigger")
        ClickBtn.Size = UDim2.new(1, 0, 1, 0)
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Text = ""
        ClickBtn.ZIndex = inRow and 14 or 12
        ClickBtn.Parent = BtnFrame

        local _hoverActive = false
        local _pressActive = false
        local quart = Enum.EasingStyle.Quart

        TrackConn(ClickBtn.MouseEnter:Connect(function()
            _hoverActive = true
            PlayHoverSFX()
            TweenService:Create(BtnScale, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {Scale = 1.02}):Play()
            TweenService:Create(BtnFrame, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
            if parts.Arrow then
                TweenService:Create(parts.Arrow, TweenInfo.new(0.18), {ImageColor3 = GetButtonArrowColor(Window.CurrentTheme, true)}):Play()
            end
        end))

        TrackConn(ClickBtn.MouseLeave:Connect(function()
            _hoverActive = false
            _pressActive = false
            TweenService:Create(BtnScale, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {Scale = 1.0}):Play()
            TweenService:Create(BtnFrame, TweenInfo.new(0.18, quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
            if parts.Arrow then
                TweenService:Create(parts.Arrow, TweenInfo.new(0.18), {ImageColor3 = GetButtonArrowColor(Window.CurrentTheme, false)}):Play()
            end
        end))

        TrackConn(ClickBtn.MouseButton1Down:Connect(function()
            _pressActive = true
            PlayClickSFX()
            TweenService:Create(BtnScale, TweenInfo.new(0.09, quart, Enum.EasingDirection.Out), {Scale = 0.95}):Play()
        end))

        TrackConn(ClickBtn.MouseButton1Up:Connect(function()
            if not _pressActive then return end
            _pressActive = false
            local targetScale = _hoverActive and 1.02 or 1.0
            TweenService:Create(BtnScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = targetScale}):Play()
            if onClick then
                pcall(onClick)
            end
        end))

        local btnData = {
            Frame = BtnFrame,
            TextLabel = parts.Text,
            ArrowIcon = parts.Arrow,
            IconImage = parts.Icon,
            Trigger = ClickBtn,
            BaseSize = size,
            SetText = function(self, newTxt)
                parts.Text.Text = tostring(newTxt or "")
            end,
            SetIcon = function(self, ic) SetMDButtonIcon(parts, ic) end,
            RefreshTheme = function(theme) RefreshMDButtonContent(parts, BtnFrame, theme) end,
        }

        btnData.WithCallback = function(self, cb)
            onClick = cb
            return self
        end
        btnData.WithTooltip = function(self, tt)
            if Window.AttachTooltip and BtnFrame then
                Window:AttachTooltip(BtnFrame, tt)
            end
            return self
        end
        btnData.WithSaveKey = function(self, key)
            if key and key ~= "" then
                self.SaveKey = key
            end
            return self
        end
        btnData.WithText = function(self, txt)
            self:SetText(txt)
            return self
        end
        btnData.WithIcon = function(self, ic) self:SetIcon(ic); return self end

        table.insert(Window.RegisteredMDButtons, btnData)

        return btnData
    end

    function Window:CreateMDToggleHalf(parent, position, size, text, initialState, onToggle, keybindConfig, connectMode)
        parent = ResolveParent(parent)
        size = size or UDim2.new(0, 260, 0, 44)
        position = position or UDim2.new(0, 0, 0, 0)

        local inSection = IsInsideSection(parent)
        local CardFrame = Instance.new("Frame")
        CardFrame.Name = GenerateSafeName("Card")
        CardFrame:SetAttribute("MDCard", true)
        CardFrame.Size = size
        CardFrame.Position = position
        CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
        CardFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
        CardFrame.BorderSizePixel = 0
        CardFrame.ZIndex = 10
        CardFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        if connectMode == "Top" or connectMode == "First" then
            ApplyCornerRadii(Corner, 12, 12, 0, 0)
        elseif connectMode == "Middle" then
            ApplyCornerRadii(Corner, 0, 0, 0, 0)
        elseif connectMode == "Bottom" or connectMode == "Last" then
            ApplyCornerRadii(Corner, 0, 0, 12, 12)
        elseif connectMode == "Left" then
            ApplyCornerRadii(Corner, 12, 0, 0, 12)
        elseif connectMode == "Right" then
            ApplyCornerRadii(Corner, 0, 12, 12, 0)
        else
            Corner.CornerRadius = UDim.new(0, 12)
        end
        Corner.Parent = CardFrame

        if not connectMode then
            local shadow = AddUIShadow(CardFrame, 20, 0.5)
            if inSection and Window.SectionsTransparent and shadow then
                pcall(function() shadow.Visible = false end)
            end
        end

        local MDTextFolder = Instance.new("Folder")
        MDTextFolder.Name = "Text"
        MDTextFolder.Parent = CardFrame

        local bgImageOn = nil
        local bgImageOff = nil
        if type(keybindConfig) == "table" then
            bgImageOn = keybindConfig.BackgroundImageOn or keybindConfig.OnImage or keybindConfig.BackgroundImage or keybindConfig.Background
            bgImageOff = keybindConfig.BackgroundImageOff or keybindConfig.OffImage or keybindConfig.BackgroundImage or keybindConfig.Background
        end

        local isToggled = (initialState == true)
        local CardBgImage = nil
        local function UpdateCardBgImage()
            local targetImg = isToggled and (bgImageOn or bgImageOff) or (bgImageOff or bgImageOn)
            if targetImg and targetImg ~= "" then
                if type(targetImg) == "number" or tostring(targetImg):match("^%d+$") then
                    targetImg = "rbxassetid://" .. tostring(targetImg)
                end
                if not CardBgImage then
                    CardBgImage = Instance.new("ImageLabel")
                    CardBgImage.Name = "CardBgImage"
                    CardBgImage.Size = UDim2.new(1, 0, 1, 0)
                    CardBgImage.Position = UDim2.new(0, 0, 0, 0)
                    CardBgImage.BackgroundTransparency = 1
                    CardBgImage.ImageTransparency = 0.25
                    CardBgImage.ScaleType = Enum.ScaleType.Crop
                    CardBgImage.ZIndex = 10
                    CardBgImage.Parent = CardFrame

                    local imgCorner = Corner:Clone()
                    imgCorner.Parent = CardBgImage
                end
                CardBgImage.Image = targetImg
                CardBgImage.Visible = true
            elseif CardBgImage then
                CardBgImage.Visible = false
            end
        end

        local keybindProp = nil
        if type(keybindConfig) == "table" then
            keybindProp = keybindConfig.Bind or keybindConfig.Keybind or keybindConfig.DefaultBind or keybindConfig.Key or keybindConfig.KeyBind or keybindConfig.DefaultKey
            if keybindProp == nil and keybindConfig.Default ~= nil and typeof(keybindConfig.Default) ~= "boolean" then
                keybindProp = keybindConfig.Default
            end
        elseif keybindConfig ~= nil and keybindConfig ~= false and keybindConfig ~= true then
            keybindProp = keybindConfig
        end

        local previewProp = nil
        if type(keybindConfig) == "table" then
            previewProp = keybindConfig.Preview or keybindConfig.preview
        end

        local hasKeybind = (keybindProp ~= nil and keybindProp ~= false and keybindProp ~= "")

        local TitleText = Instance.new("TextLabel")
        TitleText.Name = "btntext"
        TitleText.Size = hasKeybind and UDim2.new(1, -104, 1, 0) or UDim2.new(1, -65, 1, 0)
        TitleText.Position = UDim2.new(0, 14, 0, 0)
        TitleText.BackgroundTransparency = 1
        TitleText.FontFace = FontFingerPaintRegular
        TitleText.RichText = true
        TitleText.Text = text or "Function"
        TitleText.TextColor3 = Window.CurrentTheme.Text
        TitleText.TextSize = 14
        TitleText.TextWrapped = true
        TitleText.TextXAlignment = Enum.TextXAlignment.Left
        TitleText.TextYAlignment = Enum.TextYAlignment.Center
        TitleText.ZIndex = 11
        TitleText.Parent = MDTextFolder

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = "TogglePill"
        ToggleFrame.Size = UDim2.new(0, 44, 0, 24)
        ToggleFrame.Position = UDim2.new(1, -54, 0.5, -12)
        ToggleFrame.BackgroundColor3 = initialState and Window.CurrentTheme.ButtonBG or ((Window.CurrentTheme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(200, 205, 215) or Color3.fromRGB(35, 38, 48))
        ToggleFrame.BackgroundTransparency = 0.05
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.ClipsDescendants = false
        ToggleFrame.ZIndex = 11
        ToggleFrame.Parent = CardFrame

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 12)
        ToggleCorner.Parent = ToggleFrame

        AddUIShadow(ToggleFrame, 20, 0.5)

        local KnobFolder = Instance.new("Folder")
        KnobFolder.Name = "Knob"
        KnobFolder.Parent = ToggleFrame

        if bgImageOn or bgImageOff then
            UpdateCardBgImage()
        end

        local BaseCircle = Instance.new("ImageLabel")
        BaseCircle.Name = GenerateSafeName("Knob")
        BaseCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        BaseCircle.Size = UDim2.new(0, 18, 0, 18)
        BaseCircle.Position = isToggled and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
        BaseCircle.Rotation = isToggled and 0 or 225
        BaseCircle.BackgroundTransparency = 1
        BaseCircle.Image = "rbxassetid://118376432250064"
        BaseCircle.ImageColor3 = isToggled and GetOnAccent(Window.CurrentTheme.ButtonBG) or Window.CurrentTheme.ButtonBG
        BaseCircle.ZIndex = 12
        BaseCircle.Parent = KnobFolder

        local OverlayCircle = Instance.new("ImageLabel")
        OverlayCircle.Name = GenerateSafeName("Overlay")
        OverlayCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        OverlayCircle.Size = UDim2.new(0, 18, 0, 18)
        OverlayCircle.Position = isToggled and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
        OverlayCircle.Rotation = isToggled and 0 or 225
        OverlayCircle.BackgroundTransparency = 1
        OverlayCircle.Image = "rbxassetid://100354746235648"
        OverlayCircle.ImageColor3 = isToggled and Window.CurrentTheme.ButtonBG or Color3.fromRGB(255, 255, 255)
        OverlayCircle.ZIndex = 13
        OverlayCircle.Parent = KnobFolder

        local ClickBtn = Instance.new("TextButton")
        ClickBtn.Name = "ClickTrigger"
        -- Only cover the toggle pill area (right side), not the whole card
        ClickBtn.Size = UDim2.new(0, 56, 0, 36)
        ClickBtn.Position = UDim2.new(1, -58, 0.5, -18)
        ClickBtn.AnchorPoint = Vector2.new(0, 0)
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Text = ""
        ClickBtn.ZIndex = 14
        ClickBtn.Parent = CardFrame

        local function PerformToggle(newState, triggerCallback)
            isToggled = (newState == true)
            local targetKnobPos = isToggled and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
            local targetRotation = isToggled and 0 or 225
            local targetBG = isToggled and Window.CurrentTheme.ButtonBG or GetThemedDarkColor(Window.CurrentTheme)
            local targetBaseColor = isToggled and GetOnAccent(Window.CurrentTheme.ButtonBG) or Window.CurrentTheme.ButtonBG
            local targetOverlayColor = isToggled and Window.CurrentTheme.ButtonBG or Color3.fromRGB(255, 255, 255)

            TweenService:Create(BaseCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = targetKnobPos,
                Rotation = targetRotation,
                ImageColor3 = targetBaseColor
            }):Play()
            TweenService:Create(OverlayCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = targetKnobPos,
                Rotation = targetRotation,
                ImageColor3 = targetOverlayColor
            }):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetBG}):Play()
            UpdateCardBgImage()

            if triggerCallback and onToggle then
                pcall(onToggle, isToggled)
            end
        end

        TrackConn(ClickBtn.MouseButton1Click:Connect(function()
            PlayClickSFX()
            PerformToggle(not isToggled, true)
        end))

        TrackConn(CardFrame.MouseEnter:Connect(function()
            local isST = inSection and Window.SectionsTransparent
            if not isST then
                TweenService:Create(CardFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = math.max(0, (Window.ElementsTransparency or 0.33) - 0.12)
                }):Play()
            end
        end))

        TrackConn(CardFrame.MouseLeave:Connect(function()
            local isST = inSection and Window.SectionsTransparent
            if not isST then
                TweenService:Create(CardFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                }):Play()
            end
        end))

        local saveKey = (type(keybindConfig) == "table" and (keybindConfig.SaveKey or keybindConfig.saveKey or keybindConfig.Identifier or keybindConfig.identifier or keybindConfig.Id or keybindConfig.id)) or (text and text ~= "" and text) or ("ToggleHalf_" .. (#Window.RegisteredMDToggles + 1))
        local toggleName = saveKey
        local toggleData = {
            Name = toggleName,
            SaveKey = saveKey,
            CardFrame = CardFrame,
            Frame = CardFrame,
            ToggleFrame = ToggleFrame,
            TitleText = TitleText,
            BaseCircle = BaseCircle,
            Overlay = OverlayCircle,
            Corner = Corner,
            CardBgImage = CardBgImage,
            GetState = function() return isToggled end,
            SetState = function(state, triggerCallback)
                PerformToggle(state, triggerCallback)
            end,
            SetTitle = function(selfOrTitle, maybeTitle)
                local newT = (maybeTitle ~= nil) and maybeTitle or selfOrTitle
                if type(newT) == "table" then
                    newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Title or newT.Name or newT.Text or newT[1] or ""
                end
                if type(newT) ~= "string" and type(newT) ~= "number" then
                    newT = ""
                end
                TitleText.Text = tostring(newT)
                return toggleData
            end,
            SetText = function(selfOrTitle, maybeTitle)
                return toggleData.SetTitle(selfOrTitle, maybeTitle)
            end,
            SetBackgroundImage = function(self, onImg, offImg)
                bgImageOn = onImg
                bgImageOff = offImg or onImg
                UpdateCardBgImage()
            end,
            SetToggleImages = function(self, onImg, offImg)
                bgImageOn = onImg
                bgImageOff = offImg or onImg
                UpdateCardBgImage()
            end,
            RefreshTheme = function(theme, animated)
                local inSec = IsInsideSection(CardFrame)
                CardFrame.BackgroundColor3 = theme.CardBG
                CardFrame.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                TitleText.TextColor3 = theme.Text
                local isTog = isToggled
                local targetBG = isTog and theme.ButtonBG or GetThemedDarkColor(theme)
                local targetBaseColor = isTog and GetOnAccent(theme.ButtonBG) or theme.ButtonBG
                local targetOverlayColor = isTog and theme.ButtonBG or Color3.fromRGB(255, 255, 255)

                if animated then
                    local tw = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    TweenService:Create(ToggleFrame, tw, {BackgroundColor3 = targetBG}):Play()
                    TweenService:Create(BaseCircle, tw, {ImageColor3 = targetBaseColor}):Play()
                    TweenService:Create(OverlayCircle, tw, {ImageColor3 = targetOverlayColor}):Play()
                else
                    ToggleFrame.BackgroundColor3 = targetBG
                    BaseCircle.ImageColor3 = targetBaseColor
                    OverlayCircle.ImageColor3 = targetOverlayColor
                end

                if toggleData.ConnectedSlider and toggleData.ConnectedSlider.RefreshTheme then
                    toggleData.ConnectedSlider.RefreshTheme(theme, animated)
                end
                if toggleData.ValueLabel then
                    toggleData.ValueLabel.TextColor3 = theme.Text
                end
                if toggleData.Keybind and toggleData.Keybind.Container then
                    toggleData.Keybind.Container.BackgroundColor3 = (theme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(225, 230, 240) or Color3.fromRGB(24, 26, 34)
                    if toggleData.Keybind.Label then toggleData.Keybind.Label.TextColor3 = theme.Text end
                    if toggleData.Keybind.DeleteBtn then toggleData.Keybind.DeleteBtn.ImageColor3 = theme.Text end
                end
                if toggleData.PreviewButton then
                    toggleData.PreviewButton.BackgroundColor3 = (theme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(225, 230, 240) or Color3.fromRGB(45, 50, 65)
                    if toggleData._EyeStroke then
                        toggleData._EyeStroke.Color = theme.Divider or Color3.fromRGB(60, 65, 80)
                    end
                    if toggleData._SyncEyeVisuals then
                        toggleData._SyncEyeVisuals()
                    end
                end
            end
        }

        toggleData.AddSlider = function(self, sliderConfig)
            sliderConfig = sliderConfig or {}
            local minVal = sliderConfig.Min or sliderConfig.min or 0
            local maxVal = sliderConfig.Max or sliderConfig.max or 100
            local defVal = sliderConfig.Default or sliderConfig.default or minVal
            local cb = sliderConfig.Callback or sliderConfig.callback or sliderConfig.OnChanged
            local suffix = sliderConfig.Suffix or (sliderConfig.ValueFormat == "percent" and "%") or ""
            local prefix = sliderConfig.Prefix or ""
            local showVal = sliderConfig.ShowValue ~= false
            local inc = sliderConfig.Increment or sliderConfig.increment or sliderConfig.Step or sliderConfig.step or 1
            local prec = sliderConfig.Precision or sliderConfig.precision or sliderConfig.Decimals or sliderConfig.decimals

            -- Expand card to contain slider underneath: Row 1 = Title + Toggle; Row 2 = Slider + Value
            CardFrame.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 74)
            TitleText.Size = hasKeybind and UDim2.new(1, -100, 0, 36) or UDim2.new(1, -58, 0, 36)
            TitleText.Position = UDim2.new(0, 12, 0, 4)
            TitleText.TextSize = 13
            TitleText.TextWrapped = true
            ToggleFrame.Position = UDim2.new(1, -52, 0, 6)
            if ClickBtn then
                ClickBtn.Position = UDim2.new(1, -58, 0, 0)
                ClickBtn.Size = UDim2.new(0, 56, 0, 36)
            end
            local kbObj = self.Keybind or toggleData.Keybind
            if kbObj then
                local kb = kbObj.Container or kbObj.Badge or kbObj.Frame or (kbObj.IsA and kbObj:IsA("GuiObject") and kbObj)
                if kb then
                    kb.Position = UDim2.new(1, -94, 0, 8)
                end
            end

            local ValueLabel = nil
            if showVal then
                ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "ValueLabel"
                ValueLabel.Size = UDim2.new(0, 75, 0, 18)
                ValueLabel.Position = UDim2.new(1, -10, 0, 52)
                ValueLabel.AnchorPoint = Vector2.new(1, 0.5)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.FontFace = FontFingerPaintRegular
                ValueLabel.TextColor3 = Window.CurrentTheme.Text
                ValueLabel.TextSize = 11
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.TextYAlignment = Enum.TextYAlignment.Center
                ValueLabel.ZIndex = 11
                ValueLabel.Parent = CardFrame
            end

            local sliderKey = (type(sliderConfig) == "table" and (sliderConfig.SaveKey or sliderConfig.saveKey or sliderConfig.Id or sliderConfig.id or sliderConfig.Identifier or sliderConfig.identifier)) or (toggleName .. "_Slider")
            local sliderOpts = {}
            if type(sliderConfig) == "table" then
                for k, v in pairs(sliderConfig) do sliderOpts[k] = v end
            end
            sliderOpts.SaveKey = sliderKey
            sliderOpts.Id = sliderKey
            sliderOpts.Identifier = sliderKey
            sliderOpts.ShowValue = false
            sliderOpts.Increment = inc
            sliderOpts.Precision = prec
            sliderOpts.Suffix = suffix
            sliderOpts.Prefix = prefix
            sliderOpts.ValueFormat = sliderConfig.ValueFormat or (suffix == "%" and "percent") or "number"

            local userCb = cb
            local userOnRelease = type(sliderConfig) == "table" and (sliderConfig.OnRelease or sliderConfig.onRelease or sliderConfig.ReleaseCallback or sliderConfig.releaseCallback)
            local isTriggerOnRelease = type(sliderConfig) == "table" and (sliderConfig.TriggerOnRelease == true or sliderConfig.OnlyOnRelease == true)

            if isTriggerOnRelease and not userOnRelease and userCb then
                sliderOpts.OnRelease = userCb
            elseif userOnRelease then
                sliderOpts.OnRelease = userOnRelease
            end
            sliderOpts.TriggerOnRelease = false

            local sliderTrack
            sliderTrack = Window:CreateMDSlider(CardFrame, UDim2.new(0, 12, 0, 46), UDim2.new(1, -95, 0, 12), minVal, maxVal, defVal, function(val, pct)
                if ValueLabel then
                    ValueLabel.Text = sliderTrack and sliderTrack.GetFormattedValue(val, pct) or (prefix .. tostring(val) .. suffix)
                end
                if userCb and not isTriggerOnRelease then userCb(val, pct) end
            end, sliderKey, sliderOpts)

            sliderTrack.SaveKey = sliderKey
            sliderTrack.Name = sliderKey
            sliderTrack.ConnectedToggle = toggleData
            toggleData.ConnectedSlider = sliderTrack

            Window.RegisteredSliders[sliderKey] = sliderTrack
            Window.RegisteredSliders[toggleName .. "_Slider"] = sliderTrack
            if toggleData.SaveKey and toggleData.SaveKey ~= "" then
                Window.RegisteredSliders[toggleData.SaveKey .. "_Slider"] = sliderTrack
                Window.RegisteredSliders[toggleData.SaveKey .. "Volume"] = sliderTrack
                Window.RegisteredSliders[toggleData.SaveKey .. "Slider"] = sliderTrack
            end
            if text and text ~= "" then
                Window.RegisteredSliders[text .. "_Slider"] = sliderTrack
            end
            if type(sliderConfig) == "table" and sliderConfig.Title and sliderConfig.Title ~= "" then
                Window.RegisteredSliders[sliderConfig.Title] = sliderTrack
            end

            if ValueLabel then
                ValueLabel.Text = sliderTrack.GetFormattedValue(defVal)
                sliderTrack.ValueLabel = ValueLabel
            end

            local oldSetSuffix = sliderTrack.SetSuffix
            sliderTrack.SetSuffix = function(newSuffix)
                if oldSetSuffix then oldSetSuffix(newSuffix) end
                if ValueLabel then ValueLabel.Text = sliderTrack.GetFormattedValue() end
            end
            local oldSetPrefix = sliderTrack.SetPrefix
            sliderTrack.SetPrefix = function(newPrefix)
                if oldSetPrefix then oldSetPrefix(newPrefix) end
                if ValueLabel then ValueLabel.Text = sliderTrack.GetFormattedValue() end
            end
            local oldSetValueFormat = sliderTrack.SetValueFormat
            sliderTrack.SetValueFormat = function(format, newSuffix, newPrefix)
                if oldSetValueFormat then oldSetValueFormat(format, newSuffix, newPrefix) end
                if ValueLabel then ValueLabel.Text = sliderTrack.GetFormattedValue() end
            end
            local oldSetValue = sliderTrack.SetValue
            sliderTrack.SetValue = function(val, triggerCallback)
                if oldSetValue then oldSetValue(val, triggerCallback) end
                if ValueLabel then ValueLabel.Text = sliderTrack.GetFormattedValue() end
            end
            local oldSetIncrement = sliderTrack.SetIncrement
            sliderTrack.SetIncrement = function(newInc, newPrec)
                if oldSetIncrement then oldSetIncrement(newInc, newPrec) end
                if ValueLabel then ValueLabel.Text = sliderTrack.GetFormattedValue() end
            end
            local oldSetPrecision = sliderTrack.SetPrecision
            sliderTrack.SetPrecision = function(newPrec)
                if oldSetPrecision then oldSetPrecision(newPrec) end
                if ValueLabel then ValueLabel.Text = sliderTrack.GetFormattedValue() end
            end

            toggleData.ConnectedSlider = sliderTrack
            toggleData.ValueLabel = ValueLabel
            return sliderTrack
        end

        local function UpdateLayoutBadges()
            local isConnectedSlider = (toggleData.ConnectedSlider ~= nil or CardFrame.Size.Y.Offset > 50)
            local rightPadding = 65
            if toggleData.Keybind then
                local kbPos = isConnectedSlider and UDim2.new(1, -96, 0, 11) or UDim2.new(1, -96, 0.5, -11)
                if toggleData.Keybind.Badge then
                    toggleData.Keybind.Badge.Position = kbPos
                end
                rightPadding = rightPadding + 39
            end
            if toggleData.PreviewButton then
                local eyePos = (toggleData.Keybind)
                    and (isConnectedSlider and UDim2.new(1, -124, 0, 11) or UDim2.new(1, -124, 0.5, -11))
                    or (isConnectedSlider and UDim2.new(1, -82, 0, 11) or UDim2.new(1, -82, 0.5, -11))
                toggleData.PreviewButton.Position = eyePos
                rightPadding = rightPadding + 28
            end
            TitleText.Size = UDim2.new(1, -rightPadding, 1, 0)
        end

        toggleData.WithKeybind = function(self, keyOrConfig, cb)
            if not self.Keybind then
                local kbProp = nil
                if type(keyOrConfig) == "table" then
                    kbProp = keyOrConfig.Bind or keyOrConfig.Keybind or keyOrConfig.DefaultBind or keyOrConfig.Key or keyOrConfig.KeyBind or keyOrConfig.DefaultKey
                    if kbProp == nil and keyOrConfig.Default ~= nil and typeof(keyOrConfig.Default) ~= "boolean" then
                        kbProp = keyOrConfig.Default
                    end
                elseif keyOrConfig ~= nil and keyOrConfig ~= false and keyOrConfig ~= true then
                    kbProp = keyOrConfig
                end
                local defaultKey = kbProp
                local keyPos = (self.ConnectedSlider or CardFrame.Size.Y.Offset > 50) and UDim2.new(1, -96, 0, 11) or UDim2.new(1, -96, 0.5, -11)
                self.Keybind = Window:CreateKeybindBadge(CardFrame, keyPos, UDim2.new(0, 36, 0, 22), defaultKey, function()
                    self.SetState(not isToggled, true)
                    if cb then pcall(cb, isToggled) end
                end, toggleName)
                UpdateLayoutBadges()
            end
            return self
        end
        toggleData.WithPreview = function(self, previewObjOrConfig)
            if not self.PreviewButton then
                local pObj = nil
                if type(previewObjOrConfig) == "table" and previewObjOrConfig.Canvas and (previewObjOrConfig.Toggle or previewObjOrConfig.Show) then
                    pObj = previewObjOrConfig
                elseif type(previewObjOrConfig) == "table" then
                    local cfg = table.clone(previewObjOrConfig)
                    cfg.Title = cfg.Title or cfg.title or (text .. " Preview")
                    pObj = Window:CreateMDPreview(nil, nil, nil, cfg)
                else
                    pObj = Window:CreateMDPreview(nil, nil, nil, { Title = text .. " Preview" })
                end

                local EyeBtn = Instance.new("ImageButton")
                EyeBtn.Name = "PreviewEyeBtn"
                EyeBtn.Size = UDim2.new(0, 22, 0, 22)
                EyeBtn.BackgroundColor3 = Window.CurrentTheme.Divider or Color3.fromRGB(45, 50, 65)
                EyeBtn.BackgroundTransparency = 0.5
                EyeBtn.AutoButtonColor = false
                EyeBtn.ZIndex = 12
                EyeBtn.Parent = CardFrame

                local ebCorner = Instance.new("UICorner")
                ebCorner.CornerRadius = UDim.new(0, 6)
                ebCorner.Parent = EyeBtn

                local ebStroke = Instance.new("UIStroke")
                ebStroke.Thickness = 1
                ebStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(60, 65, 80)
                ebStroke.Transparency = 0.6
                ebStroke.Parent = EyeBtn

                local EyeIcon = Instance.new("ImageLabel")
                EyeIcon.Name = "EyeIcon"
                EyeIcon.Size = UDim2.new(0, 14, 0, 14)
                EyeIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
                EyeIcon.BackgroundTransparency = 1
                EyeIcon.Image = Library:GetIcon("eye") or "rbxassetid://127234874352422"
                EyeIcon.ImageColor3 = Window.CurrentTheme.TextSecondary or Color3.fromRGB(160, 165, 180)
                EyeIcon.ZIndex = 13
                EyeIcon.Parent = EyeBtn

                if Window.AttachTooltip then
                    Window:AttachTooltip(EyeBtn, "Toggle Preview")
                end

                local function SyncEyeVisuals(isOpen)
                    if isOpen == nil then
                        isOpen = pObj and pObj:IsOpen()
                    end
                    if isOpen then
                        EyeIcon.ImageColor3 = Window.CurrentTheme.ButtonBG
                        EyeBtn.BackgroundColor3 = Window.CurrentTheme.ButtonBG
                        EyeBtn.BackgroundTransparency = 0.8
                        ebStroke.Color = Window.CurrentTheme.ButtonBG
                    else
                        EyeIcon.ImageColor3 = Window.CurrentTheme.TextSecondary or Color3.fromRGB(160, 165, 180)
                        EyeBtn.BackgroundColor3 = Window.CurrentTheme.Divider or Color3.fromRGB(45, 50, 65)
                        EyeBtn.BackgroundTransparency = 0.5
                        ebStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(60, 65, 80)
                    end
                end

                EyeBtn.MouseEnter:Connect(function()
                    if not (pObj and pObj:IsOpen()) then
                        TweenService:Create(EyeIcon, TweenInfo.new(0.12), { ImageColor3 = Window.CurrentTheme.Text }):Play()
                    end
                end)
                EyeBtn.MouseLeave:Connect(function()
                    SyncEyeVisuals()
                end)
                EyeBtn.MouseButton1Click:Connect(function()
                    PlayClickSFX()
                    if pObj then
                        pObj:Toggle()
                    end
                    SyncEyeVisuals()
                end)

                if pObj and pObj.AttachTrigger then
                    pObj:AttachTrigger(function(isOpen)
                        SyncEyeVisuals(isOpen)
                    end)
                end

                self.Preview = pObj
                self.PreviewButton = EyeBtn
                self._EyeIcon = EyeIcon
                self._EyeStroke = ebStroke
                self._SyncEyeVisuals = SyncEyeVisuals

                UpdateLayoutBadges()
            end
            return self
        end
        toggleData.AddPreviewButton = toggleData.WithPreview
        toggleData.WithSlider = function(self, sliderConfig, cb)
            if type(sliderConfig) == "table" then
                if cb and not sliderConfig.Callback then
                    sliderConfig.Callback = cb
                end
                self:AddSlider(sliderConfig)
                UpdateLayoutBadges()
            end
            return self
        end
        toggleData.WithCallback = function(self, cb)
            onToggle = cb
            return self
        end
        toggleData.WithTooltip = function(self, tt)
            if Window.AttachTooltip and CardFrame then
                Window:AttachTooltip(CardFrame, tt)
            end
            return self
        end
        toggleData.WithSaveKey = function(self, key)
            if key and key ~= "" then
                Window.RegisteredToggles[key] = self
            end
            return self
        end
        toggleData.WithState = function(self, state)
            self.SetState(state, true)
            return self
        end
        toggleData.WithImages = function(self, onImg, offImg)
            self:SetBackgroundImage(onImg, offImg)
            return self
        end

        if hasKeybind then
            local defaultKey = keybindProp
            local keyPos = (toggleData.ConnectedSlider or CardFrame.Size.Y.Offset > 50) and UDim2.new(1, -96, 0, 11) or UDim2.new(1, -96, 0.5, -11)
            toggleData.Keybind = Window:CreateKeybindBadge(CardFrame, keyPos, UDim2.new(0, 36, 0, 22), defaultKey, function()
                toggleData.SetState(not isToggled, true)
            end, toggleName)
        end

        if previewProp then
            toggleData:WithPreview(previewProp)
        else
            UpdateLayoutBadges()
        end

        Window.RegisteredToggles[toggleName] = toggleData
        if saveKey and not Window.RegisteredToggles[saveKey] then
            Window.RegisteredToggles[saveKey] = toggleData
        end
        if text and text ~= "" and not Window.RegisteredToggles[text] then
            Window.RegisteredToggles[text] = toggleData
        end
        if type(keybindConfig) == "table" then
            local altId = keybindConfig.Id or keybindConfig.id or keybindConfig.Identifier or keybindConfig.identifier or keybindConfig.SaveKey or keybindConfig.saveKey
            if altId and not Window.RegisteredToggles[altId] then
                Window.RegisteredToggles[altId] = toggleData
            end
        end
        table.insert(Window.RegisteredMDToggles, toggleData)

        return toggleData
    end


    ScriptUi = Instance.new("ScreenGui")
    ScriptUi.Name = GenerateSafeName("UI")
    ScriptUi.ResetOnSpawn = false
    ScriptUi.Enabled = false
    ScriptUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScriptUi.DisplayOrder = 10
    ProtectGui(ScriptUi)
    ScriptUi.Parent = ParentGui
    table.insert(Library.ActiveGuis, ScriptUi)

    MinimisedUI = Instance.new("ScreenGui")
    MinimisedUI.Name = GenerateSafeName("UI")
    MinimisedUI.ResetOnSpawn = false
    MinimisedUI.Enabled = false
    MinimisedUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MinimisedUI.DisplayOrder = 25
    ProtectGui(MinimisedUI)
    MinimisedUI.Parent = ParentGui
    table.insert(Library.ActiveGuis, MinimisedUI)

    NotificationUI = Instance.new("ScreenGui")
    NotificationUI.Name = GenerateSafeName("UI")
    NotificationUI.ResetOnSpawn = false
    NotificationUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationUI.DisplayOrder = 30
    ProtectGui(NotificationUI)
    NotificationUI.Parent = ParentGui
    table.insert(Library.ActiveGuis, NotificationUI)
    Window.NotificationUI = NotificationUI

    local MobileUI = Instance.new("ScreenGui")
    MobileUI.Name = GenerateSafeName("UI")
    MobileUI.ResetOnSpawn = false
    MobileUI.Enabled = false
    MobileUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MobileUI.DisplayOrder = 22
    ProtectGui(MobileUI)
    MobileUI.Parent = ParentGui
    table.insert(Library.ActiveGuis, MobileUI)
    Window.MobileUI = MobileUI


    MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 760, 0, 470)
    MainContainer.Position = UDim2.new(0.5, -380, 0.5, -235)
    MainContainer.BackgroundTransparency = 1
    MainContainer.ClipsDescendants = false
    MainContainer.Parent = ScriptUi
    Window.MainContainer = MainContainer

    UIScaleConstraint = Instance.new("UIScale")
    UIScaleConstraint.Name = "MainUIScale"
    UIScaleConstraint.Parent = MainContainer

    local DropdownOverlay = Instance.new("Frame")
    DropdownOverlay.Name = "DropdownOverlay"
    DropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
    DropdownOverlay.Position = UDim2.new(0, 0, 0, 0)
    DropdownOverlay.BackgroundTransparency = 1
    DropdownOverlay.BorderSizePixel = 0
    DropdownOverlay.ClipsDescendants = false
    DropdownOverlay.ZIndex = 500
    DropdownOverlay.Parent = MainContainer
    Window.DropdownOverlay = DropdownOverlay

    -- Global listener to close active dropdown on outside click
    TrackConn(UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local active = Window.ActiveDropdown
        if not active or not active.Content or not active.Frame then return end
        local p = input.Position
        local function inside(gui)
            if not gui or not gui.Parent then return false end
            local a, s = gui.AbsolutePosition, gui.AbsoluteSize
            return p.X >= a.X and p.X <= a.X + s.X and p.Y >= a.Y and p.Y <= a.Y + s.Y
        end
        if not inside(active.Content) and not inside(active.Frame) then
            pcall(function() active.Close() end)
        end
    end))

    -- Global floating tooltip engine
    local TooltipFrame = Instance.new("Frame")
    TooltipFrame.Name = GenerateSafeName("Tooltip")
    TooltipFrame.Size = UDim2.new(0, 100, 0, 26)
    TooltipFrame.BackgroundColor3 = (Window.CurrentTheme and Window.CurrentTheme.CardBG) or Color3.fromRGB(24, 26, 34)
    TooltipFrame.BackgroundTransparency = 0.05
    TooltipFrame.BorderSizePixel = 0
    TooltipFrame.ZIndex = 10000
    TooltipFrame.Visible = false
    TooltipFrame.Parent = ScriptUi

    local TooltipCorner = Instance.new("UICorner")
    TooltipCorner.CornerRadius = UDim.new(0, 8)
    TooltipCorner.Parent = TooltipFrame

    local TooltipStroke = Instance.new("UIStroke")
    TooltipStroke.Thickness = 1
    TooltipStroke.Color = (Window.CurrentTheme and Window.CurrentTheme.Divider) or Color3.fromRGB(65, 70, 88)
    TooltipStroke.Transparency = 1
    TooltipStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TooltipStroke.Parent = TooltipFrame

    local TooltipShadow = AddUIShadow(TooltipFrame, 12, 0.45)
    TooltipFrame.BackgroundTransparency = 1
    if TooltipShadow then TooltipShadow.Transparency = 1 end

    local TooltipPadding = Instance.new("UIPadding")
    TooltipPadding.PaddingLeft = UDim.new(0, 10)
    TooltipPadding.PaddingRight = UDim.new(0, 10)
    TooltipPadding.PaddingTop = UDim.new(0, 5)
    TooltipPadding.PaddingBottom = UDim.new(0, 5)
    TooltipPadding.Parent = TooltipFrame

    local TooltipText = Instance.new("TextLabel")
    TooltipText.Name = "TooltipText"
    TooltipText.Size = UDim2.new(1, 0, 1, 0)
    TooltipText.BackgroundTransparency = 1
    TooltipText.FontFace = FontRegular
    TooltipText.Text = ""
    TooltipText.TextColor3 = Color3.fromRGB(240, 240, 245)
    TooltipText.TextSize = 12
    TooltipText.TextXAlignment = Enum.TextXAlignment.Center
    TooltipText.TextYAlignment = Enum.TextYAlignment.Center
    TooltipText.TextTransparency = 1
    TooltipText.ZIndex = 10001
    TooltipText.Parent = TooltipFrame

    Window.TooltipFrame = TooltipFrame
    Window.TooltipStroke = TooltipStroke
    Window.TooltipShadow = TooltipShadow
    Window.TooltipText = TooltipText

    local activeTooltipTarget = nil
    local tooltipTween = nil
    local tooltipContentMap = Window._TooltipContentMap or setmetatable({}, {__mode = "k"})
    Window._TooltipContentMap = tooltipContentMap

    -- Local background blur engine
    local Lighting = game:GetService("Lighting")
    for _, item in ipairs(Lighting:GetChildren()) do
        if item.Name == "ScriptHubBlur" or item.Name == "ScriptHubDOF" or item.Name == "MDScriptHubBlur" or item.Name == "MDScriptHubDOF" then
            pcall(function() item:Destroy() end)
        end
    end
    for _, item in ipairs(Camera:GetChildren()) do
        if item.Name == "ScriptHubBlur" or item.Name == "ScriptHubBlurCam" or item.Name == "ScriptHubDOF" or item.Name == "LocalUIBlurPart" or item.Name == "MDScriptHubBlur" or item.Name == "MDScriptHubBlurCam" or item.Name == "MDScriptHubDOF" or item.Name == "MD_LocalUIBlurPart" then
            pcall(function() item:Destroy() end)
        end
    end
    for _, item in ipairs(workspace:GetChildren()) do
        if item.Name == "LocalUIBlurPart" or item.Name == "MD_LocalUIBlurPart" then
            pcall(function() item:Destroy() end)
        end
    end

    local BackgroundDOF = Instance.new("DepthOfFieldEffect")
    BackgroundDOF.Name = "ScriptHubDOF"
    BackgroundDOF.FocusDistance = 2.5
    BackgroundDOF.InFocusRadius = 0
    BackgroundDOF.NearIntensity = 1.0
    BackgroundDOF.FarIntensity = 0.0
    BackgroundDOF.Enabled = false -- Disabled during loading screen
    BackgroundDOF.Parent = Lighting

    local LocalUIBlurPart = Instance.new("Part")
    LocalUIBlurPart.Name = "LocalUIBlurPart"
    LocalUIBlurPart.Material = Enum.Material.Glass
    LocalUIBlurPart.Transparency = 1 -- Fully transparent during loading screen
    LocalUIBlurPart.Color = Color3.fromRGB(255, 255, 255)
    LocalUIBlurPart.CastShadow = false
    LocalUIBlurPart.CanCollide = false
    LocalUIBlurPart.CanTouch = false
    LocalUIBlurPart.CanQuery = false
    LocalUIBlurPart.Archivable = false
    LocalUIBlurPart.Anchored = true
    LocalUIBlurPart.Size = Vector3.new(1, 1, 0.01)
    LocalUIBlurPart.CFrame = CFrame.new(0, 999999, 0)
    LocalUIBlurPart.Parent = workspace

    Window.BackgroundDOF = BackgroundDOF
    Window.LocalUIBlurPart = LocalUIBlurPart

    local GuiService = game:GetService("GuiService")
    local function UpdateLocalUIBlur()
        if not Window.BackgroundBlurEnabled or not ScriptUi or not ScriptUi.Enabled or not MainContainer or not MainContainer.Parent or not LocalUIBlurPart or not LocalUIBlurPart.Parent then
            if LocalUIBlurPart and LocalUIBlurPart.Parent then
                LocalUIBlurPart.Transparency = 1
                LocalUIBlurPart.CFrame = CFrame.new(0, 999999, 0)
            end
            if BackgroundDOF and BackgroundDOF.Parent then
                BackgroundDOF.Enabled = false
            end
            return
        end

        local Camera = workspace.CurrentCamera
        if not Camera or not Camera.FieldOfView then
            if LocalUIBlurPart and LocalUIBlurPart.Parent then
                LocalUIBlurPart.Transparency = 1
                LocalUIBlurPart.CFrame = CFrame.new(0, 999999, 0)
            end
            if BackgroundDOF and BackgroundDOF.Parent then
                BackgroundDOF.Enabled = false
            end
            return
        end

        local absPos = MainContainer.AbsolutePosition
        local absSize = MainContainer.AbsoluteSize
        if not absPos or not absSize or absSize.X <= 30 or absSize.Y <= 30 then
            LocalUIBlurPart.Transparency = 1
            LocalUIBlurPart.CFrame = CFrame.new(0, 999999, 0)
            if BackgroundDOF and BackgroundDOF.Parent then
                BackgroundDOF.Enabled = false
            end
            return
        end

        local viewW = Camera.ViewportSize.X
        local viewH = Camera.ViewportSize.Y
        if viewW <= 0 or viewH <= 0 then return end

        local camCF = Camera.CFrame
        local camPos = camCF.Position
        local _, _, _, r00, r01, r02, r10, r11, r12, r20, r21, r22 = camCF:GetComponents()

        local vecR = Vector3.new(r00, r10, r20)
        local vecU = Vector3.new(r01, r11, r21)
        local vecL = -Vector3.new(r02, r12, r22)

        local sx = vecR.Magnitude
        if sx < 0.0001 then sx = 1 end

        local sy = vecU.Magnitude
        if sy < 0.0001 then sy = 1 end

        local sz = vecL.Magnitude
        if sz < 0.0001 then sz = 1 end

        local uR = vecR / sx
        local uU = vecU / sy
        local uL = vecL / sz

        local depth = 1.0
        local tanHalfFov = math.tan(math.rad(Camera.FieldOfView or 70) * 0.5)
        local scaleFactor = (2 * depth * tanHalfFov) / math.max(viewH, 1)

        local inset = GuiService:GetGuiInset()
        local insetX = ScriptUi.IgnoreGuiInset and 0 or inset.X
        local insetY = ScriptUi.IgnoreGuiInset and 0 or inset.Y

        local padX = 10
        local padY = 4

        local minX = absPos.X + insetX + padX
        local minY = absPos.Y + insetY + padY
        local uiW = math.max(absSize.X - (padX * 2), 1)
        local uiH = math.max(absSize.Y - (padY * 2), 1)

        local midX = minX + (uiW * 0.5)
        local midY = minY + (uiH * 0.5)

        local partW = (uiW * scaleFactor) / sx
        local partH = (uiH * scaleFactor) / sy

        local cX = ((midX - (viewW * 0.5)) * scaleFactor) / sx
        local cY = (((viewH * 0.5) - midY) * scaleFactor) / sy

        local pCenter = camPos + (uR * cX) + (uU * cY) + (uL * depth)

        LocalUIBlurPart.Size = Vector3.new(partW, partH, 0.01)
        LocalUIBlurPart.CFrame = CFrame.fromMatrix(pCenter, uR, uU, -uL)
        LocalUIBlurPart.Transparency = 0.98
        if BackgroundDOF and BackgroundDOF.Parent then
            BackgroundDOF.Enabled = true
        end
    end

    TrackConn(RunService.RenderStepped:Connect(function()
        UpdateLocalUIBlur()
    end))

    -- Spiderweb background engine
    local GuiService = game:GetService("GuiService")
    local function InitSpiderwebBackground(container, screenGui)
        local WebCanvas = Instance.new("Frame")
        WebCanvas.Name = "SpiderwebCanvas"
        WebCanvas.Size = UDim2.new(1, 0, 1, 0)
        WebCanvas.Position = UDim2.new(0, 0, 0, 0)
        WebCanvas.BackgroundTransparency = 1
        WebCanvas.ClipsDescendants = true
        WebCanvas.ZIndex = 2
        WebCanvas.Parent = container

        local WebCorner = Instance.new("UICorner")
        WebCorner.CornerRadius = UDim.new(0, 10)
        WebCorner.Parent = WebCanvas

        local nodes = {}
        local linePool = {}
        local maxLines = 110

        for i = 1, maxLines do
            local line = Instance.new("Frame")
            line.Name = "WebLine_" .. i
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BorderSizePixel = 0
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 1
            line.ZIndex = 2
            line.Visible = false
            line.Parent = WebCanvas
            table.insert(linePool, line)
        end

        local function GetBrighterThemeColor()
            local base = Window.CurrentTheme.Divider or Window.CurrentTheme.ButtonBG or Color3.fromRGB(180, 180, 200)
            local h, s, v = Color3.toHSV(base)
            return Color3.fromHSV(h, math.clamp(s * 0.85, 0.35, 1), math.clamp(v * 1.4, 0.75, 1))
        end

        local function ResetNodes()
            nodes = {}
            local absSize = WebCanvas.AbsoluteSize
            local w = (absSize.X > 100) and absSize.X or 660
            local h = (absSize.Y > 100) and absSize.Y or 440

            local cols, rows = 7, 5
            local cellW = w / cols
            local cellH = h / rows

            for r = 1, rows do
                for c = 1, cols do
                    local bx = math.floor((c - 0.5) * cellW + math.random(-cellW * 0.35, cellW * 0.35))
                    local by = math.floor((r - 0.5) * cellH + math.random(-cellH * 0.35, cellH * 0.35))
                    bx = math.clamp(bx, 15, w - 15)
                    by = math.clamp(by, 15, h - 15)
                    table.insert(nodes, {
                        base = Vector2.new(bx, by),
                        current = Vector2.new(bx, by),
                        vel = Vector2.new(0, 0)
                    })
                end
            end
        end

        ResetNodes()
        local _webResizeDebounce = nil
        TrackConn(WebCanvas:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if _webResizeDebounce then task.cancel(_webResizeDebounce) end
            _webResizeDebounce = task.delay(0.2, function()
                _webResizeDebounce = nil
                ResetNodes()
            end)
        end))

        TrackConn(RunService.RenderStepped:Connect(function(dt)
            if not WebCanvas or not WebCanvas.Parent or not screenGui.Enabled then return end
            dt = dt or (1 / 60)

            if not Window.SpiderwebBGEnabled then
                for k = 1, maxLines do
                    linePool[k].Visible = false
                end
                return
            end

            local rawMouse = UserInputService:GetMouseLocation()
            local guiInset = GuiService:GetGuiInset()
            local canvasPos = WebCanvas.AbsolutePosition
            local scale = (UIScaleConstraint and UIScaleConstraint.Scale > 0) and UIScaleConstraint.Scale or 1.0

            local relMouse = Vector2.new(
                (rawMouse.X - canvasPos.X) / scale,
                (rawMouse.Y - canvasPos.Y - guiInset.Y) / scale
            )

            local mouseRadius = 200
            local maxConnectDist = 125
            local brightColor = GetBrighterThemeColor()

            local stepDt = math.min(dt, 0.05)
            local dampFactor = math.exp(-14.0 * stepDt)
            local pullStrength = 850.0
            local springStiffness = 32.0
            local maxSpeed = 300.0

            for _, node in ipairs(nodes) do
                local toMouse = relMouse - node.current
                local distMouse = toMouse.Magnitude

                if distMouse < mouseRadius and distMouse > 1 then
                    local normDist = distMouse / mouseRadius
                    local pullFactor = 1 - (normDist * normDist)
                    local pullAccel = pullStrength * pullFactor
                    node.vel = node.vel + (toMouse.Unit * (pullAccel * stepDt))
                end

                local toBase = node.base - node.current
                node.vel = node.vel + (toBase * (springStiffness * stepDt))
                node.vel = node.vel * dampFactor

                local currentSpeed = node.vel.Magnitude
                if currentSpeed > maxSpeed then
                    node.vel = (node.vel / currentSpeed) * maxSpeed
                end

                local absCanvas = WebCanvas.AbsoluteSize
                local maxW = (absCanvas.X > 50) and (absCanvas.X - 12) or 648
                local maxH = (absCanvas.Y > 50) and (absCanvas.Y - 12) or 428
                local nextX = math.clamp(node.current.X + (node.vel.X * stepDt), 12, maxW)
                local nextY = math.clamp(node.current.Y + (node.vel.Y * stepDt), 12, maxH)
                node.current = Vector2.new(nextX, nextY)
            end

            local lineIdx = 1

            for i = 1, #nodes do
                for j = i + 1, #nodes do
                    if lineIdx > maxLines then break end

                    local n1 = nodes[i]
                    local n2 = nodes[j]

                    local dNodes = (n2.current - n1.current).Magnitude
                    if dNodes < maxConnectDist then
                        local midPoint = (n1.current + n2.current) / 2
                        local distToMouse = (relMouse - midPoint).Magnitude

                        if distToMouse < mouseRadius then
                            local alpha = math.clamp(distToMouse / mouseRadius, 0, 1)
                            local transparency = 0.05 + (alpha * 0.85)

                            local line = linePool[lineIdx]
                            local dir = n2.current - n1.current
                            local angle = math.deg(math.atan2(dir.Y, dir.X))

                            line.Size = UDim2.new(0, dNodes, 0, 1.5)
                            line.Position = UDim2.new(0, midPoint.X, 0, midPoint.Y)
                            line.Rotation = angle
                            line.BackgroundColor3 = brightColor
                            line.BackgroundTransparency = transparency
                            line.Visible = true

                            lineIdx = lineIdx + 1
                        end
                    end
                end
            end

            for k = lineIdx, maxLines do
                linePool[k].Visible = false
            end
        end))
    end

    local function MakeNoiseContent(size)
        local ok, content = pcall(function()
            local AssetService = game:GetService("AssetService")
            local img = AssetService:CreateEditableImage({ Size = Vector2.new(size, size) })
            local buf = buffer.create(size * size * 4)
            for i = 0, size * size - 1 do
                local v = math.random(120, 255)
                buffer.writeu8(buf, i * 4, v)
                buffer.writeu8(buf, i * 4 + 1, v)
                buffer.writeu8(buf, i * 4 + 2, v)
                buffer.writeu8(buf, i * 4 + 3, math.random(0, 28)) -- low alpha = faint grain
            end
            img:WritePixelsBuffer(Vector2.zero, Vector2.new(size, size), buf)
            return Content.fromObject(img)
        end)
        return ok and content or nil
    end

    Window.NoiseOverlays = {}

    local function AddNoise(targetFrame, options)
        options = options or {}
        local size = options.Size or Window.NoiseSize or 128
        local enabled = (options.Enabled ~= nil) and options.Enabled or (Window.NoiseEnabled == true)

        local noise = Instance.new("ImageLabel")
        noise.Name = "NoiseOverlay"
        noise.Size = UDim2.new(1, 0, 1, 0)
        noise.Position = UDim2.new(0, 0, 0, 0)
        noise.BackgroundTransparency = 1
        noise.BorderSizePixel = 0
        noise.ScaleType = Enum.ScaleType.Tile
        noise.TileSize = UDim2.new(0, size, 0, size)
        noise.ImageTransparency = options.Transparency or Window.NoiseTransparency or 0.88
        noise.Visible = enabled
        noise.ZIndex = 2

        if options.CornerRadii then
            local nc = Instance.new("UICorner")
            ApplyCornerRadii(nc, unpack(options.CornerRadii))
            nc.Parent = noise
        end

        noise.Parent = targetFrame

        table.insert(Window.NoiseOverlays, noise)
        Window.NoiseOverlay = noise
        return noise
    end

    local function UpdateNoise()
        local enabled = (Window.NoiseEnabled == true)
        local curSize = Window.NoiseSize or 128
        local trans = Window.NoiseTransparency or 0.88
        local content = nil
        if enabled then
            content = MakeNoiseContent(curSize)
        end

        for _, n in ipairs(Window.NoiseOverlays or {}) do
            if n and n.Parent then
                n.TileSize = UDim2.new(0, curSize, 0, curSize)
                n.ImageTransparency = trans
                n.Visible = enabled
                if enabled and content then
                    n.Image = ""
                    pcall(function() n.ImageContent = content end)
                else
                    pcall(function() n.ImageContent = nil end)
                    n.Image = ""
                end
            end
        end
    end

    Window.AddNoise = AddNoise
    Library.AddNoise = AddNoise
    Window.MakeNoiseContent = MakeNoiseContent
    Library.MakeNoiseContent = MakeNoiseContent
    Window._NoiseUpdateFunc = UpdateNoise

    GetTargetViewportScale = function()
        local vp = GetViewportSizeSafe()
        local mult = Library.UIScaleMultiplier or 1
        local wanted = math.clamp(math.min(vp.X / UI_REF_W, vp.Y / UI_REF_H), 0.3, 3) * mult
        -- never let the window be bigger than the screen
        local fit = math.min((vp.X - 24) / UI_BASE_WIN_W, (vp.Y - 24) / UI_BASE_WIN_H)
        return math.max(0.3, math.min(wanted, fit))
    end

    local function UpdateScreenScaling()
        -- don't fight the minimize/restore tween while the window is hidden
        if ScriptUi and ScriptUi.Enabled then
            UIScaleConstraint.Scale = GetTargetViewportScale()
        end
        RefreshHUDScales()
    end

    local function HookViewportSignal()
        local cam = workspace.CurrentCamera or Camera
        if cam then
            TrackConn(cam:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScreenScaling))
        end
    end
    HookViewportSignal()
    TrackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        HookViewportSignal()
        UpdateScreenScaling()
    end))
    UIScaleConstraint.Scale = GetTargetViewportScale()
    RefreshHUDScales()

    -- Window:SetUIScaleMultiplier(1.2) makes everything 20% bigger on top of the auto scale
    function Window:SetUIScaleMultiplier(m)
        Library.UIScaleMultiplier = math.clamp(tonumber(m) or 1, 0.5, 2)
        UpdateScreenScaling()
    end
    function Window:GetUIScaleMultiplier()
        return Library.UIScaleMultiplier or 1
    end

    local LastWindowSize = MainContainer.Size
    local LastWindowPos = MainContainer.Position

    local SwitchTab = nil

    local TopFrame = Instance.new("Frame")
    TopFrame.Name = "TopFrame"
    TopFrame.Size = UDim2.new(1, 0, 0, 42)
    TopFrame.Position = UDim2.new(0, 0, 0, 0)
    TopFrame.BackgroundColor3 = Window.CurrentTheme.MainBG
    TopFrame.BackgroundTransparency = Window.TopBottomTransparency or Window.CurrentTheme.TopTrans or 0.12
    TopFrame.BorderSizePixel = 0
    TopFrame.ZIndex = 20
    TopFrame.Parent = MainContainer

    local TopCorner = Instance.new("UICorner")
    ApplyCornerRadii(TopCorner, 8, 8, 0, 0)
    TopCorner.Parent = TopFrame

    local TopFrameNoise = AddNoise(TopFrame, { CornerRadii = {8, 8, 0, 0} })

    local MDTextFolder = Instance.new("Folder")
    MDTextFolder.Name = "Text"
    MDTextFolder.Parent = TopFrame

    local MDHUBNAME = Instance.new("TextLabel")
    MDHUBNAME.Name = "HubName"
    MDHUBNAME.Size = UDim2.new(0, 190, 0, 24)
    MDHUBNAME.AnchorPoint = Vector2.new(0, 0.5)
    MDHUBNAME.Position = UDim2.new(0, 16, 0.5, 0)
    MDHUBNAME.BackgroundTransparency = 1
    MDHUBNAME.FontFace = Window.ScriptNameFont or FontScriptNameDefault
    MDHUBNAME.Text = Window.ScriptName or hubTitle or "script name"
    MDHUBNAME.TextColor3 = Window.CurrentTheme.Text
    MDHUBNAME.TextSize = 16
    MDHUBNAME.TextTruncate = Enum.TextTruncate.AtEnd
    MDHUBNAME.TextXAlignment = Enum.TextXAlignment.Left
    MDHUBNAME.TextYAlignment = Enum.TextYAlignment.Center
    MDHUBNAME.Visible = Window.PlayerProfileEnabled == true
    MDHUBNAME.ZIndex = 6
    MDHUBNAME.Parent = MDTextFolder

    function Window:SetScriptNameFont(newFont)
        if typeof(newFont) == "Font" then
            Window.ScriptNameFont = newFont
        elseif type(newFont) == "string" or type(newFont) == "number" then
            local assetStr = tostring(newFont)
            if not assetStr:find("://") then
                assetStr = "rbxassetid://" .. assetStr
            end
            Window.ScriptNameFont = Font.new(assetStr, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        end
        if MDHUBNAME then
            MDHUBNAME.FontFace = Window.ScriptNameFont
        end
    end

    -- Topbar Search Bar
    local SearchBarContainer = Instance.new("Frame")
    SearchBarContainer.Name = "SearchBarContainer"
    SearchBarContainer.Size = UDim2.new(0, 230, 0, 26)
    SearchBarContainer.Position = UDim2.new(0.5, -115, 0.5, -13)
    SearchBarContainer.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
    SearchBarContainer.BackgroundTransparency = 0.1
    SearchBarContainer.BorderSizePixel = 0
    SearchBarContainer.ZIndex = 6
    SearchBarContainer.Parent = TopFrame

    -- Responsive search bar width (42% of TopFrame, clamped 160-320px)
    local function UpdateSearchBarWidth()
        local topW = TopFrame.AbsoluteSize.X
        if topW <= 0 then return end
        local barW = math.clamp(math.floor(topW * 0.42), 160, 320)
        SearchBarContainer.Size = UDim2.new(0, barW, 0, 26)
        SearchBarContainer.Position = UDim2.new(0.5, -math.floor(barW / 2), 0.5, -13)
        if SearchResultsOverlay then
            SearchResultsOverlay.Size = UDim2.new(0, barW, 0, SearchResultsOverlay.Size.Y.Offset)
            SearchResultsOverlay.Position = UDim2.new(0.5, -math.floor(barW / 2), 0, 36)
        end
    end
    TrackConn(TopFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSearchBarWidth))

    local SearchCorner = Instance.new("UICorner")
    ApplyCornerRadii(SearchCorner, 13, 13, 13, 13)
    SearchCorner.Parent = SearchBarContainer

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Size = UDim2.new(0, 14, 0, 14)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -7)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://6031154871"
    SearchIcon.ImageColor3 = Window.CurrentTheme.SubText
    SearchIcon.ZIndex = 7
    SearchIcon.Parent = SearchBarContainer

    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "SearchInput"
    SearchInput.Size = UDim2.new(1, -48, 1, 0)
    SearchInput.Position = UDim2.new(0, 26, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.FontFace = FontFingerPaintRegular
    SearchInput.PlaceholderText = "Search in script..."
    SearchInput.PlaceholderColor3 = Window.CurrentTheme.SubText
    SearchInput.Text = ""
    SearchInput.TextColor3 = Window.CurrentTheme.Text
    SearchInput.TextSize = 11
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.ZIndex = 7
    SearchInput.Parent = SearchBarContainer

    local _xIconId = Library:GetIcon("x") or "116396312853810"
    local ClearSearchBtn = Instance.new("ImageButton")
    ClearSearchBtn.Name = "ClearSearchBtn"
    ClearSearchBtn.Size = UDim2.new(0, 14, 0, 14)
    ClearSearchBtn.Position = UDim2.new(1, -21, 0.5, -7)
    ClearSearchBtn.BackgroundTransparency = 1
    ClearSearchBtn.Image = tostring(_xIconId):find("://") and tostring(_xIconId) or ("rbxassetid://" .. tostring(_xIconId))
    ClearSearchBtn.ImageColor3 = Window.CurrentTheme.SubText
    ClearSearchBtn.Visible = false
    ClearSearchBtn.ZIndex = 8
    ClearSearchBtn.Parent = SearchBarContainer

    -- Search Results Dropdown Overlay (Floats on MainContainer)
    local SearchResultsOverlay = Instance.new("Frame")
    SearchResultsOverlay.Name = "SearchResultsOverlay"
    SearchResultsOverlay.Size = UDim2.new(0, 230, 0, 0)
    SearchResultsOverlay.Position = UDim2.new(0.5, -115, 0, 36)
    SearchResultsOverlay.BackgroundColor3 = Window.CurrentTheme.CardBG
    SearchResultsOverlay.BackgroundTransparency = 1
    SearchResultsOverlay.BorderSizePixel = 0
    SearchResultsOverlay.ClipsDescendants = true
    SearchResultsOverlay.ZIndex = 50
    SearchResultsOverlay.Visible = false
    SearchResultsOverlay.Parent = MainContainer

    local ResultsCorner = Instance.new("UICorner")
    ResultsCorner.CornerRadius = UDim.new(0, 12)
    ResultsCorner.Parent = SearchResultsOverlay

    AddUIShadow(SearchResultsOverlay, 20, 0.5)

    local ResultsScroll = Instance.new("ScrollingFrame")
    ResultsScroll.Name = "ResultsScroll"
    ResultsScroll.Size = UDim2.new(1, 0, 1, 0)
    ResultsScroll.Position = UDim2.new(0, 0, 0, 0)
    ResultsScroll.BackgroundTransparency = 1
    ResultsScroll.BorderSizePixel = 0
    ResultsScroll.ScrollBarThickness = 0
    ResultsScroll.ScrollBarImageTransparency = 1
    ResultsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ResultsScroll.ZIndex = 51
    ResultsScroll.Parent = SearchResultsOverlay

    local ResultsPadding = Instance.new("UIPadding")
    ResultsPadding.PaddingTop = UDim.new(0, 5)
    ResultsPadding.PaddingBottom = UDim.new(0, 5)
    ResultsPadding.PaddingLeft = UDim.new(0, 4)
    ResultsPadding.PaddingRight = UDim.new(0, 4)
    ResultsPadding.Parent = ResultsScroll

    local ResultsLayout = Instance.new("UIListLayout")
    ResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ResultsLayout.Padding = UDim.new(0, 3)
    ResultsLayout.Parent = ResultsScroll

    -- Sync width once layout is ready
    task.defer(UpdateSearchBarWidth)

    local function PerformSearch(rawText)
        local query = rawText:gsub("^%s+", ""):gsub("%s+$", ""):lower()
        local barW = SearchBarContainer.Size.X.Offset
        if query == "" then
            ClearSearchBtn.Visible = false
            SearchResultsOverlay.Visible = false
            SearchResultsOverlay.Size = UDim2.new(0, barW, 0, 0)
            SearchResultsOverlay.Position = UDim2.new(0.5, -math.floor(barW / 2), 0, 36)
            for _, item in ipairs(Window.SearchableItems) do
                if item.Instance and item.Instance.Parent then
                    item.Instance.Visible = true
                end
            end
            return
        end

        ClearSearchBtn.Visible = true

        for _, item in ipairs(Window.SearchableItems) do
            if item.TabName == Window.ActiveTab and item.Instance and item.Instance.Parent then
                local match = item.Name:lower():find(query, 1, true)
                    or (item.Id and item.Id:lower():find(query, 1, true))
                    or item.Desc:lower():find(query, 1, true)
                item.Instance.Visible = (match ~= nil)
            end
        end

        for _, child in ipairs(ResultsScroll:GetChildren()) do
            if child:IsA("GuiObject") then child:Destroy() end
        end

        local matches = {}
        for _, item in ipairs(Window.SearchableItems) do
            local nameMatch = item.Name:lower():find(query, 1, true)
            local idMatch = item.Id and item.Id:lower():find(query, 1, true)
            local descMatch = item.Desc:lower():find(query, 1, true)
            local tabMatch = item.TabName:lower():find(query, 1, true)
            if nameMatch or idMatch or descMatch or tabMatch then
                table.insert(matches, item)
            end
        end

        if #matches == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Size = UDim2.new(1, 0, 0, 28)
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.FontFace = FontFingerPaintRegular
            emptyLabel.Text = "No results found"
            emptyLabel.TextColor3 = Window.CurrentTheme.SubText
            emptyLabel.TextSize = 13
            emptyLabel.ZIndex = 52
            emptyLabel.Parent = ResultsScroll

            SearchResultsOverlay.Visible = true
            SearchResultsOverlay.Position = UDim2.new(0.5, -math.floor(barW / 2), 0, 36)
            TweenService:Create(SearchResultsOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, barW, 0, 38)
            }):Play()
            return
        end

        local maxToShow = math.min(#matches, 6)
        for i = 1, maxToShow do
            local item = matches[i]
            local rowBtn = Instance.new("TextButton")
            rowBtn.Name = "SearchResult"
            rowBtn.Size = UDim2.new(1, -4, 0, 30)
            rowBtn.BackgroundColor3 = GetThemedDarkColor(Window.CurrentTheme)
            rowBtn.BackgroundTransparency = 0
            rowBtn.Text = ""
            rowBtn.ZIndex = 52
            rowBtn.Parent = ResultsScroll

            local rowCorner = Instance.new("UICorner")
            if maxToShow == 1 then
                rowCorner.CornerRadius = UDim.new(0, 6)
            elseif i == 1 then
                ApplyCornerRadii(rowCorner, 6, 6, 0, 0)
            elseif i == maxToShow then
                ApplyCornerRadii(rowCorner, 0, 0, 6, 6)
            else
                ApplyCornerRadii(rowCorner, 0, 0, 0, 0)
            end
            rowCorner.Parent = rowBtn

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -12, 0, 15)
            titleLbl.Position = UDim2.new(0, 8, 0, 1)
            titleLbl.BackgroundTransparency = 1
            titleLbl.FontFace = FontFingerPaintBold
            titleLbl.Text = item.Name
            titleLbl.TextColor3 = Window.CurrentTheme.Text
            titleLbl.TextSize = 13
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
            titleLbl.ZIndex = 53
            titleLbl.Parent = rowBtn

            local subTabName = nil
            if item.Instance and item.Instance.Parent then
                local current = item.Instance.Parent
                while current and current ~= game do
                    if current.Name and current.Name:sub(1, 7) == "SubTab_" then
                        subTabName = current.Name:sub(8)
                        break
                    end
                    current = current.Parent
                end
            end

            local subLbl = Instance.new("TextLabel")
            subLbl.Size = UDim2.new(1, -12, 0, 12)
            subLbl.Position = UDim2.new(0, 8, 0, 15)
            subLbl.BackgroundTransparency = 1
            subLbl.FontFace = FontFingerPaintRegular
            subLbl.Text = subTabName and (item.TabName .. " > " .. subTabName) or item.TabName
            subLbl.TextColor3 = Window.CurrentTheme.SubText
            subLbl.TextSize = 10
            subLbl.TextXAlignment = Enum.TextXAlignment.Left
            subLbl.TextTruncate = Enum.TextTruncate.AtEnd
            subLbl.ZIndex = 53
            subLbl.Parent = rowBtn

            rowBtn.MouseEnter:Connect(function()
                TweenService:Create(rowBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
            end)
            rowBtn.MouseLeave:Connect(function()
                TweenService:Create(rowBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
            end)

            rowBtn.MouseButton1Click:Connect(function()
                PlayClickSFX()
                if SwitchTab then
                    SwitchTab(item.TabName)
                end

                if subTabName and Window.RegisteredSubTabs then
                    for _, st in ipairs(Window.RegisteredSubTabs) do
                        if st.Select then
                            pcall(function()
                                st:Select(subTabName)
                            end)
                        end
                    end
                end

                SearchResultsOverlay.Visible = false
                SearchResultsOverlay.Size = UDim2.new(0, barW, 0, 0)
                for _, it in ipairs(Window.SearchableItems) do
                    if it.Instance and it.Instance.Parent then
                        it.Instance.Visible = true
                    end
                end
                if item.Instance and item.Instance.Parent then
                    task.defer(function()
                        local targetCard = item.Instance
                        if not targetCard or not targetCard.Parent then return end

                        local scrollFrame = (Window.Tabs[item.TabName] and Window.Tabs[item.TabName].ContentFrame) or targetCard:FindFirstAncestorWhichIsA("ScrollingFrame")
                        if scrollFrame then
                            local relY = (targetCard.AbsolutePosition.Y - scrollFrame.AbsolutePosition.Y) + scrollFrame.CanvasPosition.Y - 25
                            local maxCanvasY = math.max(0, scrollFrame.AbsoluteCanvasSize.Y - scrollFrame.AbsoluteWindowSize.Y)
                            local targetCanvasY = math.clamp(relY, 0, maxCanvasY)
                            TweenService:Create(scrollFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                CanvasPosition = Vector2.new(0, targetCanvasY)
                            }):Play()
                        end

                        local origZIndex = targetCard.ZIndex
                        targetCard.ZIndex = math.max(origZIndex, 10) + 10

                        local origAnchor = targetCard.AnchorPoint
                        local origPos = targetCard.Position
                        local hasListLayout = targetCard.Parent and targetCard.Parent:FindFirstChildWhichIsA("UIListLayout")

                        if not hasListLayout and origAnchor == Vector2.new(0, 0) then
                            targetCard.AnchorPoint = Vector2.new(0.5, 0.5)
                            targetCard.Position = UDim2.new(
                                origPos.X.Scale,
                                origPos.X.Offset + math.floor(targetCard.AbsoluteSize.X * 0.5),
                                origPos.Y.Scale,
                                origPos.Y.Offset + math.floor(targetCard.AbsoluteSize.Y * 0.5)
                            )
                        elseif hasListLayout then
                            targetCard.AnchorPoint = Vector2.new(0.5, 0.5)
                        end

                        local uiScale = targetCard:FindFirstChild("SearchHighlightScale")
                        if not uiScale then
                            uiScale = Instance.new("UIScale")
                            uiScale.Name = "SearchHighlightScale"
                            uiScale.Scale = 1.0
                            uiScale.Parent = targetCard
                        end

                        local origBg = targetCard.BackgroundColor3
                        local brightBg = Color3.new(
                            math.min(1, origBg.R * 1.35 + 0.15),
                            math.min(1, origBg.G * 1.35 + 0.15),
                            math.min(1, origBg.B * 1.35 + 0.15)
                        )

                        local highlightStroke = targetCard:FindFirstChild("SearchHighlightStroke")
                        if not highlightStroke then
                            highlightStroke = Instance.new("UIStroke")
                            highlightStroke.Name = "SearchHighlightStroke"
                            highlightStroke.Thickness = 2.0
                            highlightStroke.Color = Color3.fromRGB(255, 255, 255)
                            highlightStroke.Transparency = 1
                            highlightStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            highlightStroke.Parent = targetCard
                        end

                        TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Scale = 1.04
                        }):Play()
                        TweenService:Create(targetCard, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            BackgroundColor3 = brightBg
                        }):Play()
                        TweenService:Create(highlightStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Transparency = 0.0
                        }):Play()

                        task.delay(1.2, function()
                            if targetCard and targetCard.Parent then
                                local backTween = TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    Scale = 1.0
                                })
                                local colorTween = TweenService:Create(targetCard, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    BackgroundColor3 = origBg
                                })
                                local strokeTween = TweenService:Create(highlightStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    Transparency = 1.0
                                })
                                backTween:Play()
                                colorTween:Play()
                                strokeTween:Play()

                                colorTween.Completed:Connect(function()
                                    if uiScale and uiScale.Parent then uiScale:Destroy() end
                                    if highlightStroke and highlightStroke.Parent then highlightStroke:Destroy() end
                                    if targetCard and targetCard.Parent then
                                        targetCard.AnchorPoint = origAnchor
                                        if not hasListLayout then
                                            targetCard.Position = origPos
                                        end
                                        targetCard.ZIndex = origZIndex
                                    end
                                end)
                            end
                        end)
                    end)
                end
            end)
        end

        -- Exact snug fit: each row 30px + 3px layout spacing + 10px vertical padding (5 top + 5 bottom)
        local targetHeight = (maxToShow * 30) + math.max(0, (maxToShow - 1) * 3) + 10
        SearchResultsOverlay.Visible = true
        SearchResultsOverlay.Position = UDim2.new(0.5, -math.floor(barW / 2), 0, 36)
        TweenService:Create(SearchResultsOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, barW, 0, targetHeight)
        }):Play()
    end

    TrackConn(SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        PerformSearch(SearchInput.Text)
    end))

    TrackConn(ClearSearchBtn.MouseButton1Click:Connect(function()
        PlayClickSFX()
        SearchInput.Text = ""
        PerformSearch("")
    end))


    local TopRightFolder = Instance.new("Folder")
    TopRightFolder.Name = "toprightbuttons"
    TopRightFolder.Parent = TopFrame

    local MinimiseBtnFrame = Instance.new("Frame")
    MinimiseBtnFrame.Size = UDim2.new(0, 30, 0, 30)
    MinimiseBtnFrame.Position = UDim2.new(0.877, 0, 0.14, 0)
    MinimiseBtnFrame.BackgroundTransparency = 1
    MinimiseBtnFrame.ZIndex = 5
    MinimiseBtnFrame.Parent = TopRightFolder

    local MinimiseBtn = Instance.new("ImageButton")
    MinimiseBtn.Size = UDim2.new(1, 0, 1, 0)
    MinimiseBtn.BackgroundTransparency = 1
    MinimiseBtn.ZIndex = 5
    MinimiseBtn.Parent = MinimiseBtnFrame

    local MinimiseIcon = Instance.new("ImageLabel")
    MinimiseIcon.Size = UDim2.new(0, 20, 0, 20)
    MinimiseIcon.Position = UDim2.new(0.168, 0, 0.168, 0)
    MinimiseIcon.BackgroundTransparency = 1
    MinimiseIcon.Image = "rbxassetid://15396333997"
    MinimiseIcon.ZIndex = 6
    MinimiseIcon.Parent = MinimiseBtn

    TrackConn(MinimiseBtn.MouseEnter:Connect(PlayHoverSFX))

    local CloseBtnFrame = Instance.new("Frame")
    CloseBtnFrame.Size = UDim2.new(0, 30, 0, 30)
    CloseBtnFrame.Position = UDim2.new(0.939, 0, 0.14, 0)
    CloseBtnFrame.BackgroundTransparency = 1
    CloseBtnFrame.ZIndex = 5
    CloseBtnFrame.Parent = TopRightFolder

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(1, 0, 1, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.ZIndex = 5
    CloseBtn.Parent = CloseBtnFrame

    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Size = UDim2.new(0, 27, 0, 27)
    CloseIcon.Position = UDim2.new(0.05, 0, 0.05, 0)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = "rbxassetid://132261474823036"
    CloseIcon.ZIndex = 6
    CloseIcon.Parent = CloseBtn

    TrackConn(CloseBtn.MouseEnter:Connect(PlayHoverSFX))

    -- Sidebar panel background
    local LeftFrame = Instance.new("Frame")
    LeftFrame.Name = "LeftFrame"
    LeftFrame.Size = UDim2.new(0, 175, 1, -94)
    LeftFrame.Position = UDim2.new(0, 0, 0, 42)
    LeftFrame.BackgroundColor3 = Window.CurrentTheme.MainBG
    LeftFrame.BackgroundTransparency = Window.TopBottomTransparency or Window.CurrentTheme.TopTrans or 0.12
    LeftFrame.BorderSizePixel = 0
    LeftFrame.ZIndex = 20
    LeftFrame.Parent = MainContainer

    local LeftFrameNoise = AddNoise(LeftFrame)

    -- Main content panel background
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, -175, 1, -94)
    MainFrame.Position = UDim2.new(0, 175, 0, 42)
    MainFrame.BackgroundColor3 = Window.CurrentTheme.TopBG or Window.CurrentTheme.AccentBG
    MainFrame.BackgroundTransparency = Window.CustomBGTransparency or Window.CurrentTheme.MainTrans or 0.12
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 1
    MainFrame.Parent = MainContainer

    -- Optional Noise Overlay on MainFrame
    local MainFrameNoise = AddNoise(MainFrame)

    -- Init Spiderweb Background at ZIndex 2 (Above LeftFrame & MainFrame panel backgrounds, below UI contents)
    InitSpiderwebBackground(MainContainer, ScriptUi)

    -- Content Overlay Layer (ZIndex 21 for all UI controls, cards, tab buttons, dividers, and text)
    local ContentOverlay = Instance.new("Frame")
    ContentOverlay.Name = "ContentOverlay"
    ContentOverlay.Size = UDim2.new(1, 0, 1, -94)
    ContentOverlay.Position = UDim2.new(0, 0, 0, 42)
    ContentOverlay.BackgroundTransparency = 1
    ContentOverlay.BorderSizePixel = 0
    ContentOverlay.ClipsDescendants = false
    ContentOverlay.ZIndex = 21
    ContentOverlay.Parent = MainContainer

    local SidebarIndicatorLayer = Instance.new("Frame")
    SidebarIndicatorLayer.Name = "SidebarIndicatorLayer"
    SidebarIndicatorLayer.Size = UDim2.new(0, 175, 1, 0)
    SidebarIndicatorLayer.Position = UDim2.new(0, 0, 0, 0)
    SidebarIndicatorLayer.BackgroundTransparency = 1
    SidebarIndicatorLayer.BorderSizePixel = 0
    SidebarIndicatorLayer.ClipsDescendants = true
    SidebarIndicatorLayer.ZIndex = 3
    SidebarIndicatorLayer.Parent = ContentOverlay

    local ActiveTabGlow = Instance.new("Frame")
    ActiveTabGlow.Name = "ActiveTabGlow"
    ActiveTabGlow.Size = UDim2.new(0, 155, 0, 30)
    ActiveTabGlow.Position = UDim2.new(0, 10, 0, 0)
    ActiveTabGlow.BackgroundColor3 = Color3.fromRGB(220, 225, 235)
    ActiveTabGlow.BackgroundTransparency = 1
    ActiveTabGlow.BorderSizePixel = 0
    ActiveTabGlow.ZIndex = 3
    ActiveTabGlow.Visible = false
    ActiveTabGlow.Parent = SidebarIndicatorLayer

    local ActiveCorner = Instance.new("UICorner")
    ActiveCorner.CornerRadius = UDim.new(0, 6)
    ActiveCorner.Parent = ActiveTabGlow

    Window.SidebarIndicatorLayer = SidebarIndicatorLayer
    Window.ActiveTabGlow = ActiveTabGlow

    local function UpdateActiveTabIndicator(instant)
        if not Window.ActiveTab then return end
        local curTab = Window.Tabs[Window.ActiveTab]
        if not curTab or not curTab.Container or not curTab.Container.Parent then return end
        local container = curTab.Container
        local scale = (UIScaleConstraint and UIScaleConstraint.Scale) or 1
        if scale <= 0 then scale = 1 end
        
        local targetY = (container.AbsolutePosition.Y - SidebarIndicatorLayer.AbsolutePosition.Y) / scale
        local targetX = (container.AbsolutePosition.X - SidebarIndicatorLayer.AbsolutePosition.X) / scale
        local targetW = (container.AbsoluteSize.X / scale) - 10
        local targetH = (container.AbsoluteSize.Y / scale) - 4
        if targetW <= 0 or targetH <= 0 then return end

        local targetPos = UDim2.new(0, targetX + 5, 0, targetY + 2)
        local targetSize = UDim2.new(0, targetW, 0, targetH)

        if not ActiveTabGlow.Visible or instant then
            ActiveTabGlow.Position = targetPos
            ActiveTabGlow.Size = targetSize
            ActiveTabGlow.Visible = true
            if instant and ActiveTabGlow.BackgroundTransparency > 0.88 then
                TweenService:Create(ActiveTabGlow, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.88
                }):Play()
            else
                ActiveTabGlow.BackgroundTransparency = 0.88
            end
        else
            TweenService:Create(ActiveTabGlow, TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = targetPos,
                Size = targetSize,
                BackgroundTransparency = 0.88
            }):Play()
        end
    end
    Window.UpdateActiveTabIndicator = UpdateActiveTabIndicator

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Name = "ScrollingFrame"
    SidebarScroll.Size = UDim2.new(0, 175, 1, 0)
    SidebarScroll.Position = UDim2.new(0, 0, 0, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.ScrollBarImageTransparency = 1
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.ClipsDescendants = true
    SidebarScroll.ZIndex = 4
    SidebarScroll.Parent = ContentOverlay

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Name = "UIListLayout"
    SidebarLayout.FillDirection = Enum.FillDirection.Vertical
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    SidebarLayout.Padding = UDim.new(0, 3)
    SidebarLayout.Parent = SidebarScroll

    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)
    end)

    SidebarScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if ActiveTabGlow and ActiveTabGlow.Visible and Window.ActiveTab then
            local curTab = Window.Tabs[Window.ActiveTab]
            if curTab and curTab.Container then
                local scale = (UIScaleConstraint and UIScaleConstraint.Scale) or 1
                if scale <= 0 then scale = 1 end
                local targetY = (curTab.Container.AbsolutePosition.Y - SidebarIndicatorLayer.AbsolutePosition.Y) / scale
                local targetX = (curTab.Container.AbsolutePosition.X - SidebarIndicatorLayer.AbsolutePosition.X) / scale
                local targetW = (curTab.Container.AbsoluteSize.X / scale) - 10
                local targetH = (curTab.Container.AbsoluteSize.Y / scale) - 4
                if targetW > 0 and targetH > 0 then
                    ActiveTabGlow.Position = UDim2.new(0, targetX + 5, 0, targetY + 2)
                    ActiveTabGlow.Size = UDim2.new(0, targetW, 0, targetH)
                end
            end
        end
    end)

    local IsAnimatingMinimize = false
    if UIScaleConstraint then
        TrackConn(UIScaleConstraint:GetPropertyChangedSignal("Scale"):Connect(function()
            if ActiveTabGlow and ActiveTabGlow.Visible and Window.ActiveTab and ScriptUi.Enabled and not IsAnimatingMinimize then
                UpdateActiveTabIndicator(true)
            end
        end))
    end

    local SidebarCollapseBtn = Instance.new("ImageButton")
    SidebarCollapseBtn.Name = "SidebarCollapseBtn"
    SidebarCollapseBtn.Size = UDim2.new(0, 20, 0, 20)
    SidebarCollapseBtn.BackgroundTransparency = 1
    SidebarCollapseBtn.Image = "rbxassetid://6031091004"
    SidebarCollapseBtn.ImageColor3 = Window.CurrentTheme.Text
    SidebarCollapseBtn.LayoutOrder = 9999
    SidebarCollapseBtn.ZIndex = 5
    SidebarCollapseBtn.Parent = SidebarScroll

    TrackConn(SidebarCollapseBtn.MouseButton1Click:Connect(function()
        PlayClickSFX()
        Window:ToggleSidebar()
    end))
    Window.SidebarCollapseBtn = SidebarCollapseBtn

    MainContentFrame = Instance.new("Frame")
    MainContentFrame.Name = "MainContentFrame"
    MainContentFrame.Size = UDim2.new(1, -175, 1, 0)
    MainContentFrame.Position = UDim2.new(0, 175, 0, 0)
    MainContentFrame.BackgroundTransparency = 1
    MainContentFrame.BorderSizePixel = 0
    MainContentFrame.ClipsDescendants = true
    MainContentFrame.ZIndex = 4
    MainContentFrame.Parent = ContentOverlay

    local BottomFrame = Instance.new("Frame")
    BottomFrame.Name = "BottomFrame"
    BottomFrame.Size = UDim2.new(1, 0, 0, 52)
    BottomFrame.Position = UDim2.new(0, 0, 1, -52)
    BottomFrame.BackgroundColor3 = Window.CurrentTheme.MainBG
    BottomFrame.BackgroundTransparency = Window.TopBottomTransparency or Window.CurrentTheme.TopTrans or 0.12
    BottomFrame.BorderSizePixel = 0
    BottomFrame.ZIndex = 20
    BottomFrame.Parent = MainContainer

    local BottomCorner = Instance.new("UICorner")
    ApplyCornerRadii(BottomCorner, 0, 0, 8, 8)
    BottomCorner.Parent = BottomFrame

    local BottomFrameNoise = AddNoise(BottomFrame, { CornerRadii = {0, 0, 8, 8} })

    local lp = LocalPlayer or Players.LocalPlayer
    local uId = lp and lp.UserId or 0
    local playerAvatarUrl = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uId) .. "&w=150&h=150"

    local function GetIconColorForTheme(theme)
        local bg = theme.MainBG or Color3.fromRGB(30, 30, 30)
        local _, s, v = Color3.toHSV(bg)

        -- black themes (AMOLED, Very Dark, custom black) -> white icon
        if s < 0.3 and v < 0.1 then
            return Color3.fromRGB(255, 255, 255)
        end
        -- white themes (White, custom white) -> black icon
        if s < 0.15 and v > 0.85 then
            return Color3.fromRGB(0, 0, 0)
        end

        -- everything else follows the theme accent
        return theme.ButtonBG or theme.Text or Color3.fromRGB(255, 255, 255)
    end
    Window.GetIconColorForTheme = GetIconColorForTheme
    Library.GetIconColorForTheme = GetIconColorForTheme
    if Window._I then Window._I.GetIconColorForTheme = GetIconColorForTheme end

    local MDicon = Instance.new("ImageLabel")
    MDicon.Name = "Icon"
    MDicon.Size = UDim2.new(0, 44, 0, 44)
    MDicon.AnchorPoint = Vector2.new(0, 0.5)
    MDicon.Position = UDim2.new(0, 10, 0.5, 0)
    MDicon.BackgroundTransparency = 1
    MDicon.Image = playerProfileEnabled and playerAvatarUrl or iconAsset
    MDicon.ImageColor3 = playerProfileEnabled and Color3.fromRGB(255, 255, 255) or GetIconColorForTheme(Window.CurrentTheme)
    MDicon.ZIndex = 6
    MDicon.Parent = BottomFrame

    Window._MDicon = MDicon

    local MDiconCorner = Instance.new("UICorner")
    MDiconCorner.CornerRadius = playerProfileEnabled and UDim.new(1, 0) or UDim.new(0, 8)
    MDiconCorner.Parent = MDicon
    Window._MDiconCorner = MDiconCorner

    AddUIShadow(MDicon, 20, 0.5)

    local MadebyText = Instance.new("TextLabel")
    MadebyText.Name = "MadebyText"
    MadebyText.Size = UDim2.new(0, 220, 0, 22)
    MadebyText.AnchorPoint = Vector2.new(0, 0)
    MadebyText.Position = showDiscord and UDim2.new(0, 64, 0, 7) or UDim2.new(0, 64, 0.5, -11)
    MadebyText.BackgroundTransparency = 1
    MadebyText.FontFace = FontRegular
    local rawPlayerName = lp and lp.Name or "Player"
    local initialPlayerDisplay = streamerMode and (Window.MaskedUsername or maskedUsername) or rawPlayerName
    MadebyText.Text = playerProfileEnabled and initialPlayerDisplay or ((scriptName and scriptName ~= "" and scriptName) or (hubTitle and hubTitle ~= "" and hubTitle) or (Window.ScriptName and Window.ScriptName ~= "" and Window.ScriptName) or "script name")
    MadebyText.TextColor3 = Window.CurrentTheme.Text
    MadebyText.TextSize = 14
    MadebyText.TextXAlignment = Enum.TextXAlignment.Left
    MadebyText.ZIndex = 6
    MadebyText.Parent = BottomFrame

    Window._MadebyText = MadebyText

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Name = "DiscordServerLink"
    DiscordBtn.Size = UDim2.new(0, 220, 0, 18)
    DiscordBtn.AnchorPoint = Vector2.new(0, 0)
    DiscordBtn.Position = UDim2.new(0, 64, 0, 28)
    DiscordBtn.BackgroundTransparency = 1
    DiscordBtn.FontFace = FontRegular
    DiscordBtn.Text = discordDisplay
    DiscordBtn.TextColor3 = Window.CurrentTheme.SubText
    DiscordBtn.TextSize = 11
    DiscordBtn.TextXAlignment = Enum.TextXAlignment.Left
    DiscordBtn.Visible = showDiscord
    DiscordBtn.ZIndex = 7
    DiscordBtn.Parent = BottomFrame

    -- Attach tooltip once so its internal MouseEnter fires on the first hover
    Window:AttachTooltip(DiscordBtn, "Click to copy")

    TrackConn(DiscordBtn.MouseEnter:Connect(function()
        PlayHoverSFX()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {TextColor3 = Window.CurrentTheme.Text}):Play()
    end))

    TrackConn(DiscordBtn.MouseLeave:Connect(function()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {TextColor3 = Window.CurrentTheme.SubText}):Play()
    end))

    TrackConn(DiscordBtn.MouseButton1Click:Connect(function()
        PlayClickSFX()
        pcall(function()
            if setclipboard then
                setclipboard(discordCopyUrl)
            end
        end)
        Window:Notify("Discord server", "Copied invite link to clipboard:\n" .. discordCopyUrl, 3)
    end))

    local LocalTime = Instance.new("TextLabel")
    LocalTime.Name = "LocalTime"
    LocalTime.Size = UDim2.new(0, 240, 1, 0)
    LocalTime.AnchorPoint = Vector2.new(1, 0.5)
    LocalTime.Position = UDim2.new(1, -26, 0.5, 0)
    LocalTime.BackgroundTransparency = 1
    LocalTime.FontFace = FontFingerPaintRegular
    LocalTime.Text = os.date("%b %d, %Y • %I:%M %p")
    LocalTime.TextColor3 = Window.CurrentTheme.Text
    LocalTime.TextSize = 11
    LocalTime.TextXAlignment = Enum.TextXAlignment.Right
    LocalTime.TextYAlignment = Enum.TextYAlignment.Center
    LocalTime.ZIndex = 6
    LocalTime.Parent = BottomFrame

    -- Concentric Rounded Corner Resize Arc
    local THICK, GAP = 4, 4
    local RADIUS = 8 + GAP -- window corner radius + gap, so the arc is concentric

    local ArcHolder = Instance.new("Frame")
    ArcHolder.Name = "ResizeArc"
    ArcHolder.AnchorPoint = Vector2.new(1, 1)
    ArcHolder.Size = UDim2.new(0, 15, 0, 15)
    ArcHolder.Position = UDim2.new(1, GAP + THICK, 1, GAP + THICK)
    ArcHolder.BackgroundTransparency = 1
    ArcHolder.ClipsDescendants = true
    ArcHolder.BorderSizePixel = 0
    ArcHolder.ZIndex = 30
    ArcHolder.Parent = MainContainer

    local Ring = Instance.new("Frame")
    Ring.Name = "Ring"
    Ring.AnchorPoint = Vector2.new(1, 1)
    Ring.Size = UDim2.new(0, 80, 0, 80) -- much bigger than the holder, so only one corner shows
    Ring.Position = UDim2.new(1, -THICK, 1, -THICK)
    Ring.BackgroundTransparency = 1
    Ring.BorderSizePixel = 0
    Ring.ZIndex = 30
    Ring.Parent = ArcHolder

    local RingCorner = Instance.new("UICorner")
    RingCorner.CornerRadius = UDim.new(0, RADIUS)
    RingCorner.Parent = Ring

    local ArcStroke = Instance.new("UIStroke")
    ArcStroke.Thickness = THICK
    ArcStroke.Color = Window.CurrentTheme.Text
    ArcStroke.Transparency = 0.35
    ArcStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ArcStroke.Parent = Ring

    local ResizeBtn = Instance.new("TextButton")
    ResizeBtn.Name = "ResizeHit"
    ResizeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    ResizeBtn.Size = UDim2.new(0, 28, 0, 28)
    ResizeBtn.Position = UDim2.new(1, 4, 1, 4)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Text = ""
    ResizeBtn.Active = true
    ResizeBtn.ZIndex = 35
    ResizeBtn.Parent = MainContainer

    local strokeTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    TrackConn(ResizeBtn.MouseEnter:Connect(function()
        PlayHoverSFX()
        TweenService:Create(ArcStroke, strokeTweenInfo, {Transparency = 0}):Play()
    end))

    TrackConn(ResizeBtn.MouseLeave:Connect(function()
        TweenService:Create(ArcStroke, strokeTweenInfo, {Transparency = 0.35}):Play()
    end))

    Window.ResizeArcHolder = ArcHolder
    Window.ResizeArcStroke = ArcStroke

    AttachUniversalDrag(TopFrame, MainContainer)
    AttachUniversalDrag(LeftFrame, MainContainer)
    AttachUniversalDrag(MainFrame, MainContainer)
    AttachUniversalDrag(BottomFrame, MainContainer)

    local FillFrame = Instance.new("Frame")
    FillFrame.Name = "FILLFRAME"
    FillFrame.Size = UDim2.new(0, 140, 0, 8)
    FillFrame.Position = UDim2.new(0.2628, 0, 0, 0)
    FillFrame.BackgroundTransparency = 1
    FillFrame.BorderSizePixel = 0
    FillFrame.LayoutOrder = 0
    FillFrame.ZIndex = 2
    FillFrame.Parent = SidebarScroll

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 8)
    FillCorner.Parent = FillFrame

    -- Minimized Icon Elements (100% Draggable, DisplayOrder 25)
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Size = UDim2.new(0, 52, 0, 52)
    MinimizedFrame.AnchorPoint = Vector2.new(0.5, 0)
    MinimizedFrame.Position = UDim2.new(0.5, 0, 0, 15)
    MinimizedFrame.BackgroundTransparency = 1
    MinimizedFrame.ClipsDescendants = false
    MinimizedFrame.ZIndex = 100
    MinimizedFrame.Parent = MinimisedUI
    RegisterHUDScale(MinimizedFrame)

    -- Minimized icon: 5 ring layers (all slightly oversized) + logo on top + invisible click button
    local MINI_LAYERS = {
        { id = "rbxassetid://71566486083442",  rotSpeed = 0,   size = 1.30, name = "MiniBase"   }, -- static base
        { id = "rbxassetid://106889071350453", rotSpeed = 0,   size = 1.25, name = "MiniCircle" }, -- static circle
        { id = "rbxassetid://134453120904821", rotSpeed = 18,  size = 1.20, name = "MiniRune"   }, -- CW slow
        { id = "rbxassetid://85631176447485",  rotSpeed = -32, size = 1.15, name = "MiniArc"    }, -- CCW faster
        { id = "rbxassetid://114710542476505", rotSpeed = 0,   size = 1.10, name = "MiniBlades" }, -- static blades
    }

    local _miniGrad = Window.CurrentTheme.MinGradient or Window.CurrentTheme.BottomGradient
    local miniThemeColor = (_miniGrad and _miniGrad[1]) or Window.CurrentTheme.AccentBG or Window.CurrentTheme.Text or Color3.fromRGB(255, 255, 255)
    local miniLayerImages = {}

    for i, layerDef in ipairs(MINI_LAYERS) do
        local s = layerDef.size
        local img = Instance.new("ImageLabel")
        img.Name = layerDef.name
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.Size = UDim2.new(s, 0, s, 0)
        img.BackgroundTransparency = 1
        img.Image = layerDef.id
        img.ImageColor3 = miniThemeColor
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 100 + i
        img.Parent = MinimizedFrame
        miniLayerImages[i] = img
    end

    -- Logo icon on top of rings, below click button
    local MiniLogoIcon = Instance.new("ImageLabel")
    MiniLogoIcon.Name = "MiniLogo"
    MiniLogoIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MiniLogoIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MiniLogoIcon.Size = UDim2.new(1.05, 0, 1.05, 0)
    MiniLogoIcon.BackgroundTransparency = 1
    MiniLogoIcon.Image = Window.MinimizedIcon or minimizedIcon or "rbxassetid://78209859871518"
    MiniLogoIcon.ImageColor3 = miniThemeColor
    MiniLogoIcon.ScaleType = Enum.ScaleType.Fit
    MiniLogoIcon.ZIndex = 105
    MiniLogoIcon.Parent = MinimizedFrame
    miniLayerImages[6] = MiniLogoIcon    Window.MiniLogoIcon = MiniLogoIcon

    -- Invisible click button on top of everything
    local MinimizedImage = Instance.new("ImageButton")
    MinimizedImage.Name = "MinimizedImage"
    MinimizedImage.AnchorPoint = Vector2.new(0.5, 0.5)
    MinimizedImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinimizedImage.Size = UDim2.new(1, 0, 1, 0)
    MinimizedImage.BackgroundTransparency = 1
    MinimizedImage.Image = ""
    MinimizedImage.ZIndex = 110
    MinimizedImage.Parent = MinimizedFrame

    local MinimizedImageCorner = Instance.new("UICorner")
    MinimizedImageCorner.CornerRadius = UDim.new(1, 0)
    MinimizedImageCorner.Parent = MinimizedImage

    Window.MinimizedImage     = MinimizedImage
    Window.MinimizedImageGrad = nil    Window.MinimizedLayers    = miniLayerImages

    -- Heartbeat: rotate animated ring layers
    local miniRotConn
    miniRotConn = RunService.Heartbeat:Connect(function(dt)
        if not MinimizedFrame or not MinimizedFrame.Parent then
            miniRotConn:Disconnect(); return
        end
        for i, layerDef in ipairs(MINI_LAYERS) do
            if layerDef.rotSpeed ~= 0 then
                local img = miniLayerImages[i]
                if img and img.Parent then
                    img.Rotation = img.Rotation + layerDef.rotSpeed * dt
                end
            end
        end
    end)
    TrackConn(miniRotConn)

    local function TriggerCircleSpinBurst() end
    Window.TriggerCircleSpinBurst = TriggerCircleSpinBurst

    AttachUniversalDrag(MinimizedFrame, MinimizedFrame)
    AttachUniversalDrag(MinimizedImage, MinimizedFrame)


    function Window:SetAuthor(newAuthor)
        Window.AuthorText = tostring(newAuthor or "")
    end

    function Window:SetScriptName(newName)
        Window.ScriptName = tostring(newName or "script name")
        if MDHUBNAME then
            MDHUBNAME.Text = Window.ScriptName
        end
        if not Window.PlayerProfileEnabled and MadebyText then
            MadebyText.Text = Window.ScriptName
        end
    end

    function Window:SetTitle(newTitle)
        Window.Title = tostring(newTitle or "script name")
        Window.ScriptName = Window.Title
        if MDHUBNAME then
            MDHUBNAME.Text = Window.Title
        end
        if not Window.PlayerProfileEnabled and MadebyText then
            MadebyText.Text = Window.Title
        end
    end

    function Window:SetPlayerProfile(enabled)
        Window.PlayerProfileEnabled = (enabled == true)
        local pl = LocalPlayer or Players.LocalPlayer
        if Window.PlayerProfileEnabled then
            local uId = pl and pl.UserId or 0
            local avatarUrl = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uId) .. "&w=150&h=150"
            if Window._MDicon then
                Window._MDicon.Image = avatarUrl
                Window._MDicon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            if Window._MDiconCorner then
                Window._MDiconCorner.CornerRadius = UDim.new(1, 0)
            end
            if Window._MadebyText then
                if Window.StreamerMode then
                    Window._MadebyText.Text = Window.MaskedUsername or string.rep("*", math.random(7, 12))
                else
                    Window._MadebyText.Text = pl and pl.Name or "Player"
                end
            end
            if Window.MDHUBNAME then
                Window.MDHUBNAME.Text = Window.ScriptName or hubTitle or "script name"
                Window.MDHUBNAME.Visible = true
            end
        else
            if Window._MDicon then
                Window._MDicon.Image = Window.IconAsset or iconAsset
                Window._MDicon.ImageColor3 = GetIconColorForTheme(Window.CurrentTheme)
            end
            if Window._MDiconCorner then
                Window._MDiconCorner.CornerRadius = UDim.new(0, 8)
            end
            if Window._MadebyText then
                Window._MadebyText.Text = (Window.ScriptName and Window.ScriptName ~= "" and Window.ScriptName) or (hubTitle and hubTitle ~= "" and hubTitle) or "script name"
            end
            if Window.MDHUBNAME then
                Window.MDHUBNAME.Visible = false
            end
        end
    end

    function Window:SetStreamerMode(enabled)
        Window.StreamerMode = (enabled == true)
        if Window.StreamerMode then
            Window.MaskedUsername = string.rep("*", math.random(7, 13))
        end
        if Window.PlayerProfileEnabled and Window._MadebyText then
            if Window.StreamerMode then
                Window._MadebyText.Text = Window.MaskedUsername
            else
                local pl = LocalPlayer or Players.LocalPlayer
                Window._MadebyText.Text = pl and pl.Name or "Player"
            end
        end
        if Window.WelcomeUpdateCallbacks then
            for _, cb in ipairs(Window.WelcomeUpdateCallbacks) do
                pcall(cb)
            end
        end
    end

    function Window:SetDiscordVisible(visible)
        Window.ShowDiscord = (visible == true)
        if DiscordBtn then
            DiscordBtn.Visible = Window.ShowDiscord
        end
        if MadebyText then
            MadebyText.Position = Window.ShowDiscord and UDim2.new(0, 64, 0, 7) or UDim2.new(0, 64, 0.5, -11)
        end
    end

    function Window:SetDiscord(newDiscord)
        if newDiscord == false then
            Window:SetDiscordVisible(false)
            return
        end
        Window:SetDiscordVisible(true)
        if not newDiscord or newDiscord == "" or newDiscord == true then
            newDiscord = "discord.gg/48jdqB8rAw"
        end
        Window.DiscordLink = tostring(newDiscord)
        discordDisplay = Window.DiscordLink:gsub("^https?://", "")
        discordCopyUrl = Window.DiscordLink:find("^https?://") and Window.DiscordLink or ("https://" .. discordDisplay)
        if DiscordBtn then
            DiscordBtn.Text = discordDisplay
        end
    end

    function Window:SetIcon(newIcon)
        if not newIcon or newIcon == "" then
            newIcon = "rbxassetid://77044087750639"
        elseif type(newIcon) == "number" or tostring(newIcon):match("^%d+$") then
            newIcon = "rbxassetid://" .. tostring(newIcon)
        else
            newIcon = tostring(newIcon)
        end
        Window.IconAsset = newIcon
        if MDicon and not Window.PlayerProfileEnabled then
            MDicon.Image = newIcon
        end
    end

    function Window:SetMinimizedIcon(newIcon)
        if not newIcon or newIcon == "" then
            newIcon = "rbxassetid://77044087750639"
        elseif type(newIcon) == "number" or tostring(newIcon):match("^%d+$") then
            newIcon = "rbxassetid://" .. tostring(newIcon)
        else
            newIcon = tostring(newIcon)
        end
        Window.MinimizedIcon = newIcon
        if Window.MiniLogoIcon and Window.MiniLogoIcon.Parent then
            Window.MiniLogoIcon.Image = newIcon
        end
        if MinimizedImage then
            MinimizedImage.Image = ""
        end
    end

    local CurrentTabSwitchToken = 0

    -- Smooth Tab Switch Transition Engine
    SwitchTab = function(tabName)
        if Window.ActiveDropdown then
            pcall(function() Window.ActiveDropdown.Close() end)
        end
        if Window.ActiveTab == tabName then return end

        local oldTab = Window.Tabs[Window.ActiveTab]
        local newTab = Window.Tabs[tabName]
        Window.ActiveTab = tabName

        if Window.UpdateActiveTabIndicator then
            Window.UpdateActiveTabIndicator(false)
        end

        -- Animate sidebar tab buttons
        local oldTargetSize = Window.SidebarCollapsed and 11 or 15
        local newTargetSize = Window.SidebarCollapsed and 11 or 16

        if oldTab and oldTab.Button then
            TweenService:Create(oldTab.Button, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                TextSize = oldTargetSize,
                TextColor3 = Window.CurrentTheme.SubText
            }):Play()
            oldTab.Button.FontFace = FontTabBtn
            if oldTab.HoverGlow then
                TweenService:Create(oldTab.HoverGlow, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
            end
            if oldTab.Icon then
                TweenService:Create(oldTab.Icon, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    ImageColor3 = Window.CurrentTheme.SubText
                }):Play()
            end
        end

        if newTab and newTab.Button then
            TweenService:Create(newTab.Button, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                TextSize = newTargetSize,
                TextColor3 = Window.CurrentTheme.Text
            }):Play()
            newTab.Button.FontFace = FontBold
            if newTab.HoverGlow then
                TweenService:Create(newTab.HoverGlow, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
            end
            if newTab.Icon then
                TweenService:Create(newTab.Icon, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    ImageColor3 = Window.CurrentTheme.Text
                }):Play()
            end
        end

        -- Hide inactive tab containers
        for name, tabObj in pairs(Window.Tabs) do
            if name ~= tabName and tabObj then
                if tabObj.ContentFrame then
                    tabObj.ContentFrame.Visible = false
                    local baseY = tabObj.HasSubTabs and 34 or 0
                    tabObj.ContentFrame.Position = UDim2.new(0, 0, 0, baseY)
                end
                if tabObj.SubTabBar then
                    tabObj.SubTabBar.Visible = false
                end
            end
        end

        -- Animate active tab into view
        if newTab then
            if newTab.SubTabBar then
                newTab.SubTabBar.Visible = (newTab.HasSubTabs == true)
                task.defer(function()
                    if newTab.UpdateSubTabIndicator then
                        newTab.UpdateSubTabIndicator(false)
                    end
                end)
            end
            if newTab.ContentFrame then
                local grad = newTab.ContentFrame:FindFirstChild("TabFadeGradient")
                if grad then
                    grad.Transparency = NumberSequence.new(1.0)
                end
                newTab.ContentFrame.CanvasPosition = Vector2.new(0, 0)
                local targetY = newTab.HasSubTabs and 34 or 0
                newTab.ContentFrame.Position = UDim2.new(0, 0, 0, targetY + 10)
                newTab.ContentFrame.Visible = true
                TweenService:Create(newTab.ContentFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, targetY)
                }):Play()
            if grad then
                task.spawn(function()
                    local start = tick()
                    local dur = 0.20
                    while true do
                        local elapsed = tick() - start
                        local alpha = math.clamp(elapsed / dur, 0, 1)
                        local eased = 1 - (1 - alpha)^4
                        grad.Transparency = NumberSequence.new(1 - eased)
                        if alpha >= 1 then break end
                        RunService.RenderStepped:Wait()
                    end
                    grad.Transparency = NumberSequence.new(0)
                end)
            end
        end
    end
    end

    function Window:AddSidebarBigDivider(layoutOrder)
        local dummy = Instance.new("Frame")
        dummy.Visible = false
        return dummy
    end

    function Window:AddSidebarSmallDivider(layoutOrder)
        local dummy = Instance.new("Frame")
        dummy.Visible = false
        return dummy
    end

    function Window:SetSidebarWidth(width)
        Window.SidebarWidth = math.max(width or 175, 40)
        if not Window.SidebarCollapsed then
            local w = Window.SidebarWidth
            LeftFrame.Size = UDim2.new(0, w, 1, -94)
            MainFrame.Size = UDim2.new(1, -w, 1, -94)
            MainFrame.Position = UDim2.new(0, w, 0, 42)
            SidebarIndicatorLayer.Size = UDim2.new(0, w, 1, 0)
            SidebarScroll.Size = UDim2.new(0, w, 1, 0)
            MainContentFrame.Size = UDim2.new(1, -w, 1, 0)
            MainContentFrame.Position = UDim2.new(0, w, 0, 0)
            if Window.UpdateActiveTabIndicator then
                task.defer(function() Window.UpdateActiveTabIndicator(true) end)
            end
        end
    end

    function Window:SetSidebarCollapsed(collapsed)
        Window.SidebarCollapsed = (collapsed == true)
        local targetW = Window.SidebarCollapsed and (Window.CollapsedSidebarWidth or 48) or (Window.SidebarWidth or 175)
        local animTime = 0.22
        local ease = TweenInfo.new(animTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        TweenService:Create(LeftFrame, ease, {Size = UDim2.new(0, targetW, 1, -94)}):Play()
        TweenService:Create(MainFrame, ease, {Size = UDim2.new(1, -targetW, 1, -94), Position = UDim2.new(0, targetW, 0, 42)}):Play()
        TweenService:Create(SidebarIndicatorLayer, ease, {Size = UDim2.new(0, targetW, 1, 0)}):Play()
        TweenService:Create(SidebarScroll, ease, {Size = UDim2.new(0, targetW, 1, 0)}):Play()
        TweenService:Create(MainContentFrame, ease, {Size = UDim2.new(1, -targetW, 1, 0), Position = UDim2.new(0, targetW, 0, 0)}):Play()

        task.delay(animTime, function()
            if Window.UpdateActiveTabIndicator then
                Window.UpdateActiveTabIndicator(false)
            end
        end)

        for name, tab in pairs(Window.Tabs) do
            if tab.Container then
                TweenService:Create(tab.Container, ease, {Size = UDim2.new(0, targetW - 8, 0, 34)}):Play()
            end
            if tab.Button then
                local fullTabName = tostring(tab.Name or name)
                if Window.SidebarCollapsed then
                    tab.Button.Visible = true
                    tab.Button.Size = UDim2.new(1, 0, 1, 0)
                    tab.Button.Position = UDim2.new(0, 0, 0, 0)
                    tab.Button.ZIndex = 4
                    if tab.Icon then
                        tab.Icon.Visible = true
                        tab.Button.Text = ""
                        TweenService:Create(tab.Icon, ease, {Position = UDim2.new(0.5, -9, 0.5, -9)}):Play()
                    else
                        tab.Button.TextXAlignment = Enum.TextXAlignment.Center
                        tab.Button.TextSize = 11
                        tab.Button.Text = (string.len(fullTabName) > 4) and (string.sub(fullTabName, 1, 4) .. ".") or fullTabName
                    end
                else
                    tab.Button.Visible = true
                    if tab.Icon then
                        tab.Icon.Visible = true
                        TweenService:Create(tab.Icon, ease, {Position = UDim2.new(0, 12, 0.5, -9)}):Play()
                        tab.Button.Position = UDim2.new(0, 36, 0, 0)
                        tab.Button.Size = UDim2.new(1, -44, 1, 0)
                        tab.Button.TextXAlignment = Enum.TextXAlignment.Left
                    else
                        tab.Button.Position = UDim2.new(0, 14, 0, 0)
                        tab.Button.Size = UDim2.new(1, -20, 1, 0)
                        tab.Button.TextXAlignment = Enum.TextXAlignment.Left
                    end
                    tab.Button.Text = fullTabName
                    tab.Button.TextSize = (Window.ActiveTab == name or Window.ActiveTab == tab.Name) and 16 or 15
                    tab.Button.ZIndex = 4
                end
            end
        end

        for _, div in ipairs(Window.SidebarDividers) do
            if div and div.Parent then
                local divW = Window.SidebarCollapsed and (targetW - 14) or 140
                TweenService:Create(div, ease, {Size = UDim2.new(0, divW, 0, div.Size.Y.Offset)}):Play()
            end
        end
    end

    function Window:ToggleSidebar()
        Window:SetSidebarCollapsed(not Window.SidebarCollapsed)
    end

    function Window:CreateTab(arg1, arg2, arg3, arg4)
        local tabName, layoutOrder, tabIcon, autoDivider
        if type(arg1) == "table" then
            tabName = arg1.Name or arg1.Title or arg1.TabName or arg1[1] or "Tab"
            layoutOrder = arg1.LayoutOrder or arg1.Order or arg1[2]
            tabIcon = arg1.Icon or arg1.IconAsset or arg1[3]
            autoDivider = arg1.AutoSmallDivider or arg1.Divider or arg1[4]
        else
            tabName = arg1 or "Tab"
            layoutOrder = arg2
            tabIcon = arg3
            autoDivider = arg4
        end

        if not tabIcon and tabName and tostring(tabName):lower():find("setting") then
            tabIcon = "settings"
        end

        if tabName and tostring(tabName):lower() == "settings" and Window.SettingsTab then
            return Window.SettingsTab
        end

        local totalTabs = 0
        for _ in pairs(Window.Tabs) do
            totalTabs = totalTabs + 1
        end

        Window._FirstTabCreated = true

        local TabContainer = Instance.new("Frame")
        TabContainer.Name = tabName
        TabContainer.Size = UDim2.new(0, 165, 0, 34)
        TabContainer.BackgroundTransparency = 1
        TabContainer.LayoutOrder = layoutOrder or (totalTabs + 1)
        TabContainer.Parent = SidebarScroll

        local HoverGlow = Instance.new("Frame")
        HoverGlow.Name = "HoverGlow"
        HoverGlow.Size = UDim2.new(1, -10, 1, -4)
        HoverGlow.Position = UDim2.new(0, 5, 0, 2)
        HoverGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HoverGlow.BackgroundTransparency = 1
        HoverGlow.BorderSizePixel = 0
        HoverGlow.ZIndex = 1
        HoverGlow.Parent = TabContainer

        local HoverCorner = Instance.new("UICorner")
        HoverCorner.CornerRadius = UDim.new(0, 6)
        HoverCorner.Parent = HoverGlow

        local HoverGradient = Instance.new("UIGradient")
        HoverGradient.Name = "HoverGradient"
        HoverGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.0, 1.0),
            NumberSequenceKeypoint.new(0.2, 0.90),
            NumberSequenceKeypoint.new(0.8, 0.90),
            NumberSequenceKeypoint.new(1.0, 1.0)
        })
        HoverGradient.Parent = HoverGlow

        local TabIcon = nil
        if tabIcon and tabIcon ~= "" and tabIcon ~= false then
            local resolvedIcon = Library:GetIcon(tabIcon)
            if resolvedIcon then
                tabIcon = resolvedIcon
            elseif Library.Icons and Library.Icons[tabIcon] then
                tabIcon = Library.Icons[tabIcon]
            elseif Window.Icons and Window.Icons[tabIcon] then
                tabIcon = Window.Icons[tabIcon]
            end
            if type(tabIcon) == "number" or tostring(tabIcon):match("^%d+$") then
                tabIcon = "rbxassetid://" .. tostring(tabIcon)
            end
            TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "TabIcon"
            TabIcon.Size = UDim2.new(0, 18, 0, 18)
            TabIcon.Position = Window.SidebarCollapsed and UDim2.new(0.5, -9, 0.5, -9) or UDim2.new(0, 12, 0.5, -9)
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = tabIcon
            TabIcon.ImageColor3 = Window.CurrentTheme.SubText
            TabIcon.Visible = true
            TabIcon.ZIndex = 5
            TabIcon.Parent = TabContainer

            TrackConn(TabIcon.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    PlayClickSFX()
                    SwitchTab(tabName)
                end
            end))
        end

        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TextButton"
        if Window.SidebarCollapsed then
            TabButton.Size = UDim2.new(1, 0, 1, 0)
            TabButton.Position = UDim2.new(0, 0, 0, 0)
            TabButton.TextXAlignment = Enum.TextXAlignment.Center
            TabButton.Text = TabIcon and "" or ((string.len(tabName) > 4) and (string.sub(tabName, 1, 4) .. ".") or tabName)
        else
            if TabIcon then
                TabButton.Size = UDim2.new(1, -44, 1, 0)
                TabButton.Position = UDim2.new(0, 36, 0, 0)
                TabButton.TextXAlignment = Enum.TextXAlignment.Left
            else
                TabButton.Size = UDim2.new(1, -20, 1, 0)
                TabButton.Position = UDim2.new(0, 14, 0, 0)
                TabButton.TextXAlignment = Enum.TextXAlignment.Left
            end
            TabButton.Text = tabName
        end
        TabButton.BackgroundTransparency = 1
        TabButton.FontFace = FontTabBtn
        TabButton.TextColor3 = Window.CurrentTheme.SubText
        TabButton.TextSize = 15
        TabButton.TextYAlignment = Enum.TextYAlignment.Center
        TabButton.ZIndex = 4
        TabButton.Parent = TabContainer

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.Position = UDim2.new(0, 0, 0, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.ScrollBarThickness = 0
        ContentFrame.ScrollBarImageTransparency = 1
        ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ContentFrame.ClipsDescendants = true
        ContentFrame.Visible = false
        ContentFrame.ZIndex = 2
        ContentFrame.Parent = MainContentFrame or MainFrame

        local TabFadeGradient = Instance.new("UIGradient")
        TabFadeGradient.Name = "TabFadeGradient"
        TabFadeGradient.Transparency = NumberSequence.new(0)
        TabFadeGradient.Parent = ContentFrame

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingTop = UDim.new(0, 8)
        ContentPadding.PaddingBottom = UDim.new(0, 14)
        ContentPadding.Parent = ContentFrame

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = ContentFrame

        local _tabItemOrder = 0
        ContentFrame.ChildAdded:Connect(function(child)
            if child:IsA("GuiObject") and child.LayoutOrder == 0 then
                _tabItemOrder = _tabItemOrder + 1
                child.LayoutOrder = _tabItemOrder
            end
        end)

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)
        end)

        local TabObj = {
            Name = tabName,
            Container = TabContainer,
            Button = TabButton,
            HoverGlow = HoverGlow,
            HoverGradient = HoverGradient,
            Icon = TabIcon,
            ContentFrame = ContentFrame,
            Layout = ContentLayout
        }

        function TabObj:AddWelcomeHeader()
            local MainHeaderFrame = Instance.new("Frame")
            MainHeaderFrame.Name = "MainHeaderFrame"
            MainHeaderFrame.Size = UDim2.new(1, -10, 0, 90)
            MainHeaderFrame.BackgroundTransparency = 1
            MainHeaderFrame.BorderSizePixel = 0
            MainHeaderFrame.ZIndex = 3
            MainHeaderFrame.Parent = ContentFrame

            local UserAvatar = Instance.new("ImageLabel")
            UserAvatar.Name = "USERCHARACTERIMAGE"
            UserAvatar.Size = UDim2.new(0, 68, 0, 68)
            UserAvatar.Position = UDim2.new(0.0217, 0, 0.0286, 0)
            UserAvatar.BackgroundTransparency = 1
            UserAvatar.BorderSizePixel = 0
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            if LocalPlayer then
                UserAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
            end
            UserAvatar.ZIndex = 4
            UserAvatar.Parent = MainHeaderFrame

            local AvatarCorner = Instance.new("UICorner")
            AvatarCorner.CornerRadius = UDim.new(0, 11)
            AvatarCorner.Parent = UserAvatar
            AddUIShadow(UserAvatar, 20, 0.5)

            local function GetGreeting()
                local hour = tonumber(os.date("%H"))
                if hour >= 5 and hour < 12 then
                    return "Good morning"
                elseif hour >= 12 and hour < 17 then
                    return "Good afternoon"
                elseif hour >= 17 and hour < 21 then
                    return "Good evening"
                else
                    return "Night"
                end
            end

            local pName = "User"
            if LocalPlayer then
                local dn = LocalPlayer.DisplayName
                local n  = LocalPlayer.Name
                if dn and dn ~= "" then
                    pName = dn
                elseif n and n ~= "" then
                    pName = n
                end
            end

            local function GetGreetingDisplayName()
                if Window.StreamerMode then
                    return Window.MaskedUsername or string.rep("*", math.random(7, 12))
                end
                return pName
            end

            local WelcomeMsg = Instance.new("TextLabel")
            WelcomeMsg.Name = "Welcomemsg"
            WelcomeMsg.Size = UDim2.new(0, 360, 0, 45)
            WelcomeMsg.Position = UDim2.new(0.2, 0, 0.11198, 0)
            WelcomeMsg.BackgroundTransparency = 1
            WelcomeMsg.BorderSizePixel = 0
            WelcomeMsg.FontFace = FontFingerPaintBold
            WelcomeMsg.Text = GetGreeting() .. ", " .. GetGreetingDisplayName()
            WelcomeMsg.TextColor3 = Window.CurrentTheme.Text
            WelcomeMsg.TextSize = 28
            WelcomeMsg.TextWrapped = true
            WelcomeMsg.TextXAlignment = Enum.TextXAlignment.Left
            WelcomeMsg.TextYAlignment = Enum.TextYAlignment.Center
            WelcomeMsg.ZIndex = 4
            WelcomeMsg.Parent = MainHeaderFrame

            local function UpdateWelcomeText()
                if WelcomeMsg and WelcomeMsg.Parent then
                    WelcomeMsg.Text = GetGreeting() .. ", " .. GetGreetingDisplayName()
                end
            end

            Window.WelcomeUpdateCallbacks = Window.WelcomeUpdateCallbacks or {}
            table.insert(Window.WelcomeUpdateCallbacks, UpdateWelcomeText)

            Window.WelcomeMsg = WelcomeMsg
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return MainHeaderFrame
        end

        function TabObj:AddButton(title, desc, callback, parentRow)
            local btnTitle, btnDesc, btnCb, btnOpts
            if type(title) == "table" and not title.IsA then
                btnTitle = title.Title or title.Name or title.Text or title[1] or "Button"
                btnDesc = title.Desc or title.Description or title[2] or ""
                btnCb = title.Callback or title.OnClick or title.callback or title[3]
                btnOpts = title
                if typeof(desc) == "Instance" or (type(desc) == "table" and (desc.Frame or desc.Instance or desc.Container)) then
                    parentRow = desc
                end
                parentRow = title.Parent or title.Row or title.parentRow or parentRow
            else
                btnTitle = title or "Button"
                if type(desc) == "function" then
                    btnDesc = ""
                    btnCb = desc
                    parentRow = callback or parentRow
                else
                    btnDesc = desc or ""
                    btnCb = callback
                    if typeof(callback) == "Instance" or (type(callback) == "table" and (callback.Frame or callback.Instance or callback.Container)) then
                        parentRow = callback
                        btnCb = nil
                    end
                end
                btnOpts = {}
            end

            local targetParent = ResolveParent(parentRow) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame)
            local hasDesc = btnDesc and btnDesc ~= ""

            local CardFrame = Instance.new("Frame")
            CardFrame.Name = "MDButton_CardFrame"
            CardFrame:SetAttribute("MDCard", true)
            CardFrame.Size = isInside and UDim2.new(1, 0, 0, hasDesc and 60 or 44) or UDim2.new(1, -10, 0, 60)
            CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
            CardFrame.BackgroundTransparency = (isInside and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
            CardFrame.BorderSizePixel = 0
            CardFrame.Parent = targetParent

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 6)
            CardCorner.Parent = CardFrame

            local hasDesc = btnDesc and btnDesc ~= ""

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.FontFace = FontFingerPaintBold
            TitleLabel.Text = btnTitle
            TitleLabel.TextColor3 = Window.CurrentTheme.Text
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = CardFrame

            if hasDesc then
                TitleLabel.Size = UDim2.new(1, -125, 0, 22)
                TitleLabel.Position = UDim2.new(0, 12, 0, 7)
                TitleLabel.TextSize = 14
                TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
            else
                TitleLabel.Size = UDim2.new(1, -125, 1, 0)
                TitleLabel.Position = UDim2.new(0, 12, 0, 0)
                TitleLabel.TextSize = 14
                TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
            end

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Size = UDim2.new(1, -125, 0, 22)
            DescLabel.Position = UDim2.new(0, 12, 0, 29)
            DescLabel.BackgroundTransparency = 1
            DescLabel.FontFace = FontFingerPaintRegular
            DescLabel.Text = hasDesc and btnDesc or ""
            DescLabel.TextColor3 = Window.CurrentTheme.SubText
            DescLabel.TextSize = 11
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Visible = hasDesc
            DescLabel.Parent = CardFrame

            local function ExecuteAction()
                Window:Notify("Executing", "Running " .. btnTitle .. "...", 2.5)
                task.spawn(function()
                    if type(btnCb) == "function" then
                        pcall(btnCb)
                    elseif type(btnCb) == "string" then
                        pcall(function() loadstring(btnCb)() end)
                    end
                end)
            end

            local ActionBtn = Window:CreateMDButton(CardFrame, UDim2.new(0, 110, 0, 30), UDim2.new(1, -120, 0.5, -15), (btnOpts and btnOpts.ButtonText) or "Execute", ExecuteAction, true, btnOpts and (btnOpts.Icon or btnOpts.icon))

            local buttonData = {
                CardFrame = CardFrame,
                TitleLabel = TitleLabel,
                DescLabel = DescLabel,
                Button = ActionBtn,
                SetText = function(selfOrTitle, maybeTitle)
                    local newT = (maybeTitle ~= nil) and maybeTitle or selfOrTitle
                    if type(newT) == "table" then
                        newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Title or newT.Name or newT.Text or newT[1] or ""
                    end
                    btnTitle = tostring(newT or "")
                    TitleLabel.Text = btnTitle
                end,
                SetDescription = function(selfOrDesc, maybeDesc)
                    local newD = (maybeDesc ~= nil) and maybeDesc or selfOrDesc
                    if type(newD) == "table" then
                        newD = newD[Window.CurrentLanguage or "English"] or newD["English"] or newD.Desc or newD.Description or newD[1] or ""
                    end
                    btnDesc = tostring(newD or "")
                    local hd = btnDesc ~= ""
                    DescLabel.Text = btnDesc
                    DescLabel.Visible = hd
                    if hd then
                        TitleLabel.Size = UDim2.new(1, -125, 0, 22)
                        TitleLabel.Position = UDim2.new(0, 12, 0, 7)
                        TitleLabel.TextSize = 14
                    else
                        TitleLabel.Size = UDim2.new(1, -125, 1, 0)
                        TitleLabel.Position = UDim2.new(0, 12, 0, 0)
                        TitleLabel.TextSize = 14
                    end
                end,
                RefreshTheme = function(theme)
                    CardFrame.BackgroundColor3 = theme.CardBG
                    CardFrame.BackgroundTransparency = (isInside and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                    TitleLabel.TextColor3 = theme.Text
                    DescLabel.TextColor3 = theme.SubText
                end
            }

            buttonData.WithCallback = function(self, cb)
                btnCb = cb
                return self
            end
            buttonData.WithTooltip = function(self, tt)
                if Window.AttachTooltip and CardFrame then
                    Window:AttachTooltip(CardFrame, tt)
                end
                return self
            end
            buttonData.WithSaveKey = function(self, key)
                if key and key ~= "" then
                    self.SaveKey = key
                end
                return self
            end
            buttonData.WithText = function(self, txt)
                self:SetText(txt)
                return self
            end
            buttonData.WithDescription = function(self, d)
                self:SetDescription(d)
                return self
            end

            if btnOpts and type(btnOpts) == "table" and (btnOpts.Tooltip or btnOpts.tooltip) then
                buttonData:WithTooltip(btnOpts.Tooltip or btnOpts.tooltip)
            end
            if btnOpts and type(btnOpts) == "table" and (btnOpts.SaveKey or btnOpts.saveKey) then
                buttonData:WithSaveKey(btnOpts.SaveKey or btnOpts.saveKey)
            end

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            table.insert(Window.SearchableItems, {
                Type = "Button",
                Name = btnTitle or "Button",
                Desc = btnDesc or "",
                TabName = tabName,
                Instance = CardFrame,
                Callback = btnCb
            })

            table.insert(Window.RegisteredMDButtons, buttonData)

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(buttonData, btnTitle, function(newText)
                    buttonData:SetText(newText)
                end, (btnDesc and btnDesc ~= "") and btnDesc or nil, function(newDesc)
                    buttonData:SetDescription(newDesc)
                end)
            end

            return buttonData
        end

        function TabObj:AddCard(configOrTitle, desc, parentContainer)
            local cardTitle, cardDesc, cardOpts
            if type(configOrTitle) == "table" and not configOrTitle.IsA then
                cardTitle = configOrTitle.Title or configOrTitle.Name or configOrTitle.Text or configOrTitle[1] or "Card"
                cardDesc = configOrTitle.Desc or configOrTitle.Description or configOrTitle[2] or ""
                cardOpts = configOrTitle
                parentContainer = configOrTitle.Parent or configOrTitle.Row or configOrTitle.parentRow or parentContainer
            else
                cardTitle = tostring(configOrTitle or "Card")
                cardDesc = desc or ""
                cardOpts = {}
            end

            local targetParent = ResolveParent(parentContainer) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame)
            local hasDesc = cardDesc and cardDesc ~= ""
            local cardH = cardOpts.Height or (hasDesc and 56 or 44)

            local CardFrame = Instance.new("Frame")
            CardFrame.Name = "MDCard_" .. cardTitle:gsub("%s+", "_")
            CardFrame:SetAttribute("MDCard", true)
            CardFrame.Size = isInside and UDim2.new(1, 0, 0, cardH) or UDim2.new(1, -10, 0, cardH)
            CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
            CardFrame.BackgroundTransparency = (isInside and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
            CardFrame.BorderSizePixel = 0
            CardFrame.ZIndex = 10
            CardFrame.Parent = targetParent

            local CardCorner = Instance.new("UICorner")
            local connectMode = cardOpts.Connect or cardOpts.Connected or cardOpts.connectMode or cardOpts.PositionInGroup
            if connectMode == "Top" or connectMode == "First" then
                ApplyCornerRadii(CardCorner, 12, 12, 0, 0)
            elseif connectMode == "Middle" then
                ApplyCornerRadii(CardCorner, 0, 0, 0, 0)
            elseif connectMode == "Bottom" or connectMode == "Last" then
                ApplyCornerRadii(CardCorner, 0, 0, 12, 12)
            elseif connectMode == "Left" then
                ApplyCornerRadii(CardCorner, 12, 0, 0, 12)
            elseif connectMode == "Right" then
                ApplyCornerRadii(CardCorner, 0, 12, 12, 0)
            else
                CardCorner.CornerRadius = UDim.new(0, 12)
            end
            CardCorner.Parent = CardFrame

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(80, 85, 100)
            CardStroke.Thickness = 1
            CardStroke.Transparency = (isInside and Window.SectionsTransparent) and 1 or 0.8
            CardStroke.Parent = CardFrame

            AddUIShadow(CardFrame, 8, 0.4)

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = hasDesc and UDim2.new(1, -24, 0, 20) or UDim2.new(1, -24, 1, 0)
            TitleLabel.Position = hasDesc and UDim2.new(0, 12, 0, 8) or UDim2.new(0, 12, 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamMedium
            TitleLabel.Text = cardTitle
            TitleLabel.TextColor3 = Window.CurrentTheme.Text
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.ZIndex = 11
            TitleLabel.Parent = CardFrame

            local DescLabel
            if hasDesc then
                DescLabel = Instance.new("TextLabel")
                DescLabel.Name = "Desc"
                DescLabel.Size = UDim2.new(1, -24, 0, 16)
                DescLabel.Position = UDim2.new(0, 12, 0, 28)
                DescLabel.BackgroundTransparency = 1
                DescLabel.Font = Enum.Font.Gotham
                DescLabel.Text = cardDesc
                DescLabel.TextColor3 = Window.CurrentTheme.SubText
                DescLabel.TextSize = 11
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.ZIndex = 11
                DescLabel.Parent = CardFrame
            end

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            local cardObj = {
                Frame = CardFrame,
                Instance = CardFrame,
                SetTitle = function(selfOrTitle, maybeTitle)
                    local newT = (maybeTitle ~= nil) and maybeTitle or selfOrTitle
                    if type(newT) == "table" then
                        newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Title or newT.Name or newT.Text or newT[1] or ""
                    end
                    TitleLabel.Text = tostring(newT or "")
                end,
                SetText = function(selfOrTitle, maybeTitle)
                    return cardObj.SetTitle(selfOrTitle, maybeTitle)
                end,
                SetDesc = function(selfOrDesc, maybeDesc)
                    local newD = (maybeDesc ~= nil) and maybeDesc or selfOrDesc
                    if type(newD) == "table" then
                        newD = newD[Window.CurrentLanguage or "English"] or newD["English"] or newD.Desc or newD.Description or newD[1] or ""
                    end
                    if DescLabel then
                        DescLabel.Text = tostring(newD or "")
                    end
                end,
            }

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(cardObj, cardTitle, function(newText)
                    cardObj:SetTitle(newText)
                end, (hasDesc and cardDesc) or nil, function(newDesc)
                    cardObj:SetDesc(newDesc)
                end)
            end

            return cardObj
        end

        function TabObj:AddLabel(textOrConfig, options, parentContainer)
            local labelText, descText, textColor, labelOptions
            if type(textOrConfig) == "table" and not textOrConfig.IsA then
                labelText = textOrConfig.Text or textOrConfig.Title or textOrConfig.Name or textOrConfig[1] or "Section Header"
                descText = textOrConfig.Desc or textOrConfig.Description or textOrConfig.SubText or textOrConfig[2]
                textColor = textOrConfig.Color or textOrConfig.TextColor
                labelOptions = textOrConfig
                parentContainer = textOrConfig.Parent or textOrConfig.Container or textOrConfig.Row or parentContainer
            else
                labelText = tostring(textOrConfig or "Section Header")
                if type(options) == "table" then
                    descText = options.Desc or options.Description or options.SubText
                    textColor = options.Color or options.TextColor
                    labelOptions = options
                    parentContainer = options.Parent or options.Container or options.Row or parentContainer
                elseif type(options) == "string" then
                    descText = options
                end
            end

            local hasDesc = descText and descText ~= ""
            local frameHeight = hasDesc and 40 or 26

            local targetParent = ResolveParent(parentContainer) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame)

            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "MDLabelFrame_" .. labelText:gsub("%s+", "_")
            LabelFrame.Size = isInside and UDim2.new(1, 0, 0, frameHeight) or UDim2.new(1, -10, 0, frameHeight)
            LabelFrame.AutomaticSize = Enum.AutomaticSize.Y
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.BorderSizePixel = 0
            LabelFrame.ZIndex = 3
            LabelFrame.Parent = targetParent

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "LabelTitle"
            TitleLabel.Size = UDim2.new(1, -12, 0, 20)
            TitleLabel.Position = UDim2.new(0, 6, 0, 2)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.FontFace = FontFingerPaintBold
            TitleLabel.Text = labelText
            TitleLabel.TextColor3 = textColor or Window.CurrentTheme.Text
            TitleLabel.TextSize = 14
            TitleLabel.TextWrapped = true
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
            TitleLabel.ZIndex = 4
            TitleLabel.Parent = LabelFrame

            local DescLabel = nil
            if hasDesc then
                DescLabel = Instance.new("TextLabel")
                DescLabel.Name = "LabelDesc"
                DescLabel.Size = UDim2.new(1, -12, 0, 16)
                DescLabel.Position = UDim2.new(0, 6, 0, 22)
                DescLabel.BackgroundTransparency = 1
                DescLabel.FontFace = FontFingerPaintRegular
                DescLabel.Text = descText
                DescLabel.TextColor3 = Window.CurrentTheme.SubText
                DescLabel.TextSize = 11
                DescLabel.TextWrapped = true
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.TextYAlignment = Enum.TextYAlignment.Center
                DescLabel.ZIndex = 4
                DescLabel.Parent = LabelFrame
            end

            local labelObj = {
                Frame = LabelFrame,
                TitleLabel = TitleLabel,
                SetText = function(selfOrText, maybeText)
                    local newT = (maybeText ~= nil) and maybeText or selfOrText
                    if type(newT) == "table" then
                        newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Text or newT.Title or newT.Name or newT[1] or ""
                    end
                    TitleLabel.Text = tostring(newT or "")
                end,
                SetDescription = function(selfOrDesc, maybeDesc)
                    local newD = (maybeDesc ~= nil) and maybeDesc or selfOrDesc
                    if type(newD) == "table" then
                        newD = newD[Window.CurrentLanguage or "English"] or newD["English"] or newD.Desc or newD.Description or newD[1] or ""
                    end
                    if DescLabel then
                        DescLabel.Text = tostring(newD or "")
                    end
                end,
                SetColor = function(self, newCol)
                    if newCol then
                        TitleLabel.TextColor3 = newCol
                    end
                end,
                RefreshTheme = function(theme)
                    if not textColor then
                        TitleLabel.TextColor3 = theme.Text
                    end
                    if DescLabel then
                        DescLabel.TextColor3 = theme.SubText
                    end
                end
            }

            labelObj.WithTooltip = function(self, tt)
                if Window.AttachTooltip and LabelFrame then
                    Window:AttachTooltip(LabelFrame, tt)
                end
                return self
            end
            labelObj.WithText = function(self, txt)
                self:SetText(txt)
                return self
            end
            labelObj.WithColor = function(self, col)
                self:SetColor(col)
                return self
            end

            if labelOptions and type(labelOptions) == "table" and (labelOptions.Tooltip or labelOptions.tooltip) then
                labelObj:WithTooltip(labelOptions.Tooltip or labelOptions.tooltip)
            end

            Window.RegisteredLabels = Window.RegisteredLabels or {}
            table.insert(Window.RegisteredLabels, labelObj)

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(labelObj, labelText, function(newText)
                    labelObj:SetText(newText)
                end, (hasDesc and descText) or nil, function(newDesc)
                    labelObj:SetDescription(newDesc)
                end)
            end

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return labelObj
        end

        function TabObj:AddDivider(options, parentRow)
            local divHeight = (type(options) == "table" and (options.Height or options.height)) or (type(options) == "number" and options) or 8
            local divThickness = (type(options) == "table" and (options.Thickness or options.thickness)) or 1.2
            local divColor = type(options) == "table" and (options.Color or options.color) or nil

            local targetParent = ResolveParent(parentRow) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame)

            local DividerContainer = Instance.new("Frame")
            DividerContainer.Name = "MDContentDivider"
            DividerContainer.Size = isInside and UDim2.new(1, 0, 0, divHeight) or UDim2.new(1, -10, 0, divHeight)
            DividerContainer.BackgroundTransparency = 1
            DividerContainer.BorderSizePixel = 0
            DividerContainer.ZIndex = 3
            DividerContainer.Parent = targetParent

            local Line = Instance.new("ImageLabel")
            Line.Name = "Line"
            local lineH = math.max(divThickness, 5)
            Line.Size = UDim2.new(1, -16, 0, lineH)
            Line.Position = UDim2.new(0, 8, 0.5, 0)
            Line.AnchorPoint = Vector2.new(0, 0.5)
            Line.BackgroundTransparency = 1
            Line.Image = "rbxassetid://133887791984569"
            Line.ImageColor3 = divColor or Window.CurrentTheme.Divider or Window.CurrentTheme.CardBG
            Line.ScaleType = Enum.ScaleType.Stretch
            Line.BorderSizePixel = 0
            Line.ZIndex = 4
            Line.Parent = DividerContainer

            local dividerObj = {
                Frame = DividerContainer,
                Line = Line,
                SetVisible = function(self, vis)
                    DividerContainer.Visible = (vis ~= false)
                end,
                SetColor = function(self, col)
                    Line.ImageColor3 = col
                end,
                RefreshTheme = function(theme, anim)
                    if not divColor and Line and Line.Parent then
                        local targetCol = theme.Divider or theme.CardBG
                        if anim then
                            game:GetService("TweenService"):Create(Line, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                ImageColor3 = targetCol
                            }):Play()
                        else
                            Line.ImageColor3 = targetCol
                        end
                    end
                end
            }

            dividerObj.WithVisible = function(self, vis)
                self:SetVisible(vis)
                return self
            end

            Window.RegisteredDividers = Window.RegisteredDividers or {}
            table.insert(Window.RegisteredDividers, dividerObj)

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return dividerObj
        end

        function TabObj:AddNumberInput(titleOrConfig, options, callback, parentRow, position, sizeFraction)
            local title, minVal, maxVal, defaultVal, stepVal, cb, inputOpts
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Number Input"
                minVal = titleOrConfig.Min or titleOrConfig.min or 0
                maxVal = titleOrConfig.Max or titleOrConfig.max or 100
                defaultVal = titleOrConfig.Default or titleOrConfig.default or minVal
                stepVal = titleOrConfig.Step or titleOrConfig.step or 1
                cb = titleOrConfig.Callback or titleOrConfig.callback or titleOrConfig.OnChanged or titleOrConfig[2]
                inputOpts = titleOrConfig
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
            else
                title = tostring(titleOrConfig or "Number Input")
                if type(options) == "table" then
                    minVal = options.Min or options.min or 0
                    maxVal = options.Max or options.max or 100
                    defaultVal = options.Default or options.default or minVal
                    stepVal = options.Step or options.step or 1
                    cb = options.Callback or options.callback or callback
                    inputOpts = options
                else
                    minVal = 0
                    maxVal = 100
                    defaultVal = tonumber(options) or 0
                    stepVal = 1
                    cb = callback
                    inputOpts = {}
                end
            end

            local targetParent = parentRow or ContentFrame
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, parentRow and 0.5 or 1.0)
            local cardSize = explicitUDim or (parentRow and ComputeRowItemWidth(fraction or 0.5, 52) or UDim2.new(1, -10, 0, 52))
            local pos = position or UDim2.new(0, 0, 0, 0)
            local suffix = (inputOpts and inputOpts.Suffix) or ""

            local currentValue = math.clamp(tonumber(defaultVal) or minVal, minVal, maxVal)

            local inSection = IsInsideSection(targetParent)
            local CardFrame = Instance.new("Frame")
            CardFrame.Name = "MDNumberInputCard_" .. title:gsub("%s+", "_")
            CardFrame:SetAttribute("MDCard", true)
            CardFrame.Size = cardSize
            CardFrame.Position = pos
            CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
            CardFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
            CardFrame.BorderSizePixel = 0
            CardFrame.ZIndex = 10
            CardFrame.Parent = targetParent

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 8)
            CardCorner.Parent = CardFrame

            local shadow = AddUIShadow(CardFrame, 20, 0.5)
            if inSection and Window.SectionsTransparent and shadow then
                pcall(function() shadow.Visible = false end)
            end

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "TitleLabel"
            TitleLabel.Size = UDim2.new(1, -145, 1, 0)
            TitleLabel.Position = UDim2.new(0, 14, 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.FontFace = FontFingerPaintRegular
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Window.CurrentTheme.Text
            TitleLabel.TextSize = 13
            TitleLabel.TextWrapped = true
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
            TitleLabel.ZIndex = 11
            TitleLabel.Parent = CardFrame

            local ControlBox = Instance.new("Frame")
            ControlBox.Name = "ControlBox"
            ControlBox.Size = UDim2.new(0, 126, 0, 32)
            ControlBox.Position = UDim2.new(1, -136, 0.5, -16)
            ControlBox.BackgroundColor3 = (Window.CurrentTheme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(230, 234, 242) or Color3.fromRGB(20, 22, 28)
            ControlBox.BackgroundTransparency = 0.1
            ControlBox.BorderSizePixel = 0
            ControlBox.ZIndex = 11
            ControlBox.Parent = CardFrame

            local ControlCorner = Instance.new("UICorner")
            ControlCorner.CornerRadius = UDim.new(0, 6)
            ControlCorner.Parent = ControlBox

            local ControlStroke = Instance.new("UIStroke")
            ControlStroke.Thickness = 1.0
            ControlStroke.Color = Color3.fromRGB(255, 255, 255)
            ControlStroke.Transparency = 0.8
            ControlStroke.Parent = ControlBox

            local MinusBtn = Instance.new("TextButton")
            MinusBtn.Name = "MinusBtn"
            MinusBtn.Size = UDim2.new(0, 30, 1, 0)
            MinusBtn.Position = UDim2.new(0, 0, 0, 0)
            MinusBtn.BackgroundColor3 = Window.CurrentTheme.ButtonBG
            MinusBtn.BackgroundTransparency = 0.2
            MinusBtn.BorderSizePixel = 0
            MinusBtn.FontFace = FontTabBtn
            MinusBtn.Text = "-"
            MinusBtn.TextColor3 = Window.CurrentTheme.Text
            MinusBtn.TextSize = 16
            MinusBtn.ZIndex = 12
            MinusBtn.Parent = ControlBox

            local MinusCorner = Instance.new("UICorner")
            MinusCorner.CornerRadius = UDim.new(0, 6)
            MinusCorner.Parent = MinusBtn

            local PlusBtn = Instance.new("TextButton")
            PlusBtn.Name = "PlusBtn"
            PlusBtn.Size = UDim2.new(0, 30, 1, 0)
            PlusBtn.Position = UDim2.new(1, -30, 0, 0)
            PlusBtn.BackgroundColor3 = Window.CurrentTheme.ButtonBG
            PlusBtn.BackgroundTransparency = 0.2
            PlusBtn.BorderSizePixel = 0
            PlusBtn.FontFace = FontTabBtn
            PlusBtn.Text = "+"
            PlusBtn.TextColor3 = Window.CurrentTheme.Text
            PlusBtn.TextSize = 15
            PlusBtn.ZIndex = 12
            PlusBtn.Parent = ControlBox

            local PlusCorner = Instance.new("UICorner")
            PlusCorner.CornerRadius = UDim.new(0, 6)
            PlusCorner.Parent = PlusBtn

            local NumberBox = Instance.new("TextBox")
            NumberBox.Name = "NumberBox"
            NumberBox.Size = UDim2.new(1, -64, 1, 0)
            NumberBox.Position = UDim2.new(0, 32, 0, 0)
            NumberBox.BackgroundTransparency = 1
            NumberBox.FontFace = FontFingerPaintRegular
            NumberBox.Text = tostring(currentValue) .. suffix
            NumberBox.TextColor3 = Window.CurrentTheme.Text
            NumberBox.TextSize = 12
            NumberBox.TextXAlignment = Enum.TextXAlignment.Center
            NumberBox.ClearTextOnFocus = false
            NumberBox.ZIndex = 12
            NumberBox.Parent = ControlBox

            local function FormatDisplay(val)
                return tostring(val) .. suffix
            end

            local saveKey = (inputOpts and (inputOpts.SaveKey or inputOpts.saveKey or inputOpts.Identifier or inputOpts.identifier or inputOpts.Id or inputOpts.id)) or title
            local numberObj = {
                Name = saveKey,
                SaveKey = saveKey,
                TabName = tabName,
                CardFrame = CardFrame,
                TitleLabel = TitleLabel,
                ControlBox = ControlBox,
                NumberBox = NumberBox,
                MinusBtn = MinusBtn,
                PlusBtn = PlusBtn,
                GetValue = function() return currentValue end,
                SetValue = function(self, newVal, triggerCb)
                    local parsed = tonumber(newVal)
                    if parsed then
                        currentValue = math.clamp(parsed, minVal, maxVal)
                        if stepVal >= 1 and math.floor(stepVal) == stepVal then
                            currentValue = math.floor(currentValue + 0.5)
                        end
                    end
                    NumberBox.Text = FormatDisplay(currentValue)
                    if triggerCb and cb then
                        pcall(cb, currentValue)
                    end
                end,
                RefreshTheme = function(theme)
                    local inSec = IsInsideSection(CardFrame)
                    CardFrame.BackgroundColor3 = theme.CardBG
                    CardFrame.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                    TitleLabel.TextColor3 = theme.Text
                    ControlBox.BackgroundColor3 = (theme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(230, 234, 242) or Color3.fromRGB(20, 22, 28)
                    MinusBtn.BackgroundColor3 = theme.ButtonBG
                    MinusBtn.TextColor3 = theme.Text
                    PlusBtn.BackgroundColor3 = theme.ButtonBG
                    PlusBtn.TextColor3 = theme.Text
                    NumberBox.TextColor3 = theme.Text
                end
            }

            local function StepValue(delta)
                PlayClickSFX()
                local newVal = math.clamp(currentValue + delta, minVal, maxVal)
                if stepVal >= 1 and math.floor(stepVal) == stepVal then
                    newVal = math.floor(newVal + 0.5)
                end
                currentValue = newVal
                NumberBox.Text = FormatDisplay(currentValue)
                if cb then
                    pcall(cb, currentValue)
                end
            end

            TrackConn(MinusBtn.MouseButton1Click:Connect(function()
                StepValue(-stepVal)
            end))

            TrackConn(PlusBtn.MouseButton1Click:Connect(function()
                StepValue(stepVal)
            end))

            TrackConn(NumberBox.FocusLost:Connect(function()
                local cleanText = NumberBox.Text:gsub("[^%-%d%.]", "")
                local parsed = tonumber(cleanText)
                if parsed then
                    currentValue = math.clamp(parsed, minVal, maxVal)
                    if stepVal >= 1 and math.floor(stepVal) == stepVal then
                        currentValue = math.floor(currentValue + 0.5)
                    end
                end
                NumberBox.Text = FormatDisplay(currentValue)
                if cb then
                    pcall(cb, currentValue)
                end
            end))

            numberObj.WithCallback = function(self, fn)
                cb = fn
                return self
            end
            numberObj.WithTooltip = function(self, tt)
                if Window.AttachTooltip and CardFrame then
                    Window:AttachTooltip(CardFrame, tt)
                end
                return self
            end
            numberObj.WithSaveKey = function(self, key)
                if key and key ~= "" then
                    self.SaveKey = key
                    Window.RegisteredNumberInputs[key] = self
                end
                return self
            end
            numberObj.WithValue = function(self, v, triggerCb)
                self:SetValue(v, triggerCb)
                return self
            end
            numberObj.WithMin = function(self, mn)
                minVal = mn
                return self
            end
            numberObj.WithMax = function(self, mx)
                maxVal = mx
                return self
            end
            numberObj.WithStep = function(self, st)
                stepVal = st
                return self
            end

            if inputOpts and type(inputOpts) == "table" and (inputOpts.Tooltip or inputOpts.tooltip) then
                numberObj:WithTooltip(inputOpts.Tooltip or inputOpts.tooltip)
            end
            if inputOpts and type(inputOpts) == "table" and (inputOpts.SaveKey or inputOpts.saveKey) then
                numberObj:WithSaveKey(inputOpts.SaveKey or inputOpts.saveKey)
            end

            if saveKey and saveKey ~= "" then
                Window.RegisteredNumberInputs[saveKey] = numberObj
            end
            if title and title ~= "" and not Window.RegisteredNumberInputs[title] then
                Window.RegisteredNumberInputs[title] = numberObj
            end
            if inputOpts and type(inputOpts) == "table" then
                local altId = inputOpts.Id or inputOpts.id or inputOpts.Identifier or inputOpts.identifier or inputOpts.SaveKey or inputOpts.saveKey
                if altId and not Window.RegisteredNumberInputs[altId] then
                    Window.RegisteredNumberInputs[altId] = numberObj
                end
            end
            table.insert(Window.RegisteredNumberInputsList, numberObj)

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            table.insert(Window.SearchableItems, {
                Type = "NumberInput",
                Name = title or "NumberInput",
                Desc = "",
                TabName = tabName,
                Instance = CardFrame
            })

            return numberObj
        end
        TabObj.AddSpinbox = TabObj.AddNumberInput

        function TabObj:AddMultiDropdown(titleOrConfig, options, defaultSelections, onSelect, parentRow, position, sizeFraction)
            local title, dropOpts, defSels, cb, multiOpts
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Select Options"
                dropOpts = titleOrConfig.Options or titleOrConfig.options or titleOrConfig.Values or titleOrConfig.values or titleOrConfig.List or titleOrConfig[2] or {}
                defSels = titleOrConfig.Default or titleOrConfig.default or titleOrConfig.Selections or titleOrConfig[3] or {}
                cb = titleOrConfig.Callback or titleOrConfig.OnSelect or titleOrConfig.callback or titleOrConfig[4]
                multiOpts = titleOrConfig
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
            else
                title = tostring(titleOrConfig or "Select Options")
                dropOpts = options or {}
                defSels = defaultSelections or {}
                cb = onSelect
                multiOpts = {}
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = isGroup and 38 or (parentRow and 42) or 44
            local cardSize = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)

            local multiDropData = Window:CreateMDMultiDropdown(targetParent, pos, cardSize, title, dropOpts, defSels, cb, multiOpts)

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            table.insert(Window.SearchableItems, {
                Type = "MultiDropdown",
                Name = title or "MultiDropdown",
                Desc = "",
                TabName = tabName,
                Instance = multiDropData.Frame
            })

            return multiDropData
        end

        function TabObj:AddPriorityDropdown(titleOrConfig, options, defaultOrder, onSelect, parentRow, position, sizeFraction)
            local title, dropOpts, defOrder, cb, dropConfig
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Target Priority"
                dropOpts = titleOrConfig.Options or titleOrConfig.options or titleOrConfig.Values or titleOrConfig.values or titleOrConfig.List or titleOrConfig[2] or {}
                defOrder = titleOrConfig.Default or titleOrConfig.default or titleOrConfig.Order or titleOrConfig[3] or {}
                cb = titleOrConfig.Callback or titleOrConfig.OnSelect or titleOrConfig.callback or titleOrConfig[4]
                dropConfig = titleOrConfig
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
            else
                title = tostring(titleOrConfig or "Target Priority")
                dropOpts = options or {}
                defOrder = defaultOrder or {}
                cb = onSelect
                dropConfig = {}
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = isGroup and 38 or (parentRow and 42) or 44
            local cardSize = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)

            local dropData = Window:CreateMDPriorityDropdown(targetParent, pos, cardSize, title, dropOpts, defOrder, cb, dropConfig)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            table.insert(Window.SearchableItems, {
                Type = "PriorityDropdown",
                Name = title or "PriorityDropdown",
                Desc = "",
                TabName = tabName,
                Instance = dropData.Frame
            })
            return dropData
        end

        function TabObj:AddImageDropdown(titleOrConfig, options, defaultOption, onSelect, parentRow, position, sizeFraction)
            local title, dropOpts, defOpt, cb, dropConfig
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Select Option"
                dropOpts = titleOrConfig.Options or titleOrConfig.options or titleOrConfig.Values or titleOrConfig.values or titleOrConfig.List or titleOrConfig[2] or {}
                defOpt = titleOrConfig.Default or titleOrConfig.default or titleOrConfig[3]
                cb = titleOrConfig.Callback or titleOrConfig.OnSelect or titleOrConfig.callback or titleOrConfig[4]
                dropConfig = titleOrConfig
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
            else
                title = tostring(titleOrConfig or "Select Option")
                dropOpts = options or {}
                defOpt = defaultOption
                cb = onSelect
                dropConfig = {}
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = isGroup and 38 or (parentRow and 42) or 44
            local cardSize = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)

            local dropData = Window:CreateMDImageDropdown(targetParent, pos, cardSize, title, dropOpts, defOpt, cb, dropConfig)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            table.insert(Window.SearchableItems, {
                Type = "ImageDropdown",
                Name = title or "ImageDropdown",
                Desc = "",
                TabName = tabName,
                Instance = dropData.Frame
            })
            return dropData
        end

        function TabObj:AddStatGrid(configOrStats, parentContainer)
            local cfg = (type(configOrStats) == "table" and not configOrStats.IsA) and configOrStats or { Stats = configOrStats }
            local targetParent = ResolveParent(parentContainer) or cfg.Parent or TabObj.CurrentSectionContainer or ContentFrame
            local statGrid = Window:CreateMDStatGrid(targetParent, nil, nil, cfg)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return statGrid
        end
        TabObj.AddStatCard = function(self, config, parentContainer)
            local cfg = (type(config) == "table" and not config.IsA) and config or { Title = config }
            cfg.Columns = 1
            cfg.Stats = { cfg }
            return self:AddStatGrid(cfg, parentContainer)
        end

        function TabObj:AddImageGrid(config, parentContainer)
            local cfg = (type(config) == "table" and not config.IsA) and config or {}
            local targetParent = ResolveParent(parentContainer) or cfg.Parent or TabObj.CurrentSectionContainer or ContentFrame
            local imgGrid = Window:CreateMDImageGrid(targetParent, nil, nil, cfg)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return imgGrid
        end
        TabObj.AddGallery = TabObj.AddImageGrid

        function TabObj:AddPreview(config, parentContainer)
            local cfg = (type(config) == "table" and not config.IsA) and config or {}
            local targetParent = ResolveParent(parentContainer) or cfg.Parent or TabObj.CurrentSectionContainer or ContentFrame
            local preview = Window:CreateMDPreview(nil, nil, nil, cfg)
            if cfg.Inline ~= false and cfg.NoCard ~= true and cfg.Standalone ~= true then
                local triggerCard = Window:CreateMDPreviewButton(targetParent, nil, nil, preview, cfg.Title or cfg.title or "Preview")
                preview.TriggerCard = triggerCard
            end
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return preview
        end

        function TabObj:AddPreviewButton(previewOrConfig, titleOrConfig, parentContainer)
            local targetParent = ResolveParent(parentContainer) or TabObj.CurrentSectionContainer or ContentFrame
            local previewObj = (type(previewOrConfig) == "table" and (previewOrConfig.Toggle or previewOrConfig.Show)) and previewOrConfig or nil
            local title = type(titleOrConfig) == "string" and titleOrConfig or (type(previewOrConfig) == "string" and previewOrConfig) or (type(previewOrConfig) == "table" and (previewOrConfig.Title or previewOrConfig.title)) or "Preview"
            if not previewObj then
                local cfg = (type(previewOrConfig) == "table") and previewOrConfig or { Title = title }
                previewObj = Window:CreateMDPreview(nil, nil, nil, cfg)
            end
            local triggerCard = Window:CreateMDPreviewButton(targetParent, nil, nil, previewObj, title)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return triggerCard, previewObj
        end

        function TabObj:AddSubTabs(tabNamesOrConfig, defaultSubTab)
            return Window:CreateMDSubTabs(TabObj, tabNamesOrConfig, defaultSubTab)
        end

        function TabObj:AddProgressBar(titleOrConfig, options, parentContainer)
            local title, initialPct, statusText, cardOpts
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Progress"
                initialPct = titleOrConfig.Progress or titleOrConfig.Value or titleOrConfig.Default or titleOrConfig[2] or 0
                statusText = titleOrConfig.Status or titleOrConfig.Desc or titleOrConfig[3] or ""
                cardOpts = titleOrConfig
                parentContainer = titleOrConfig.Parent or titleOrConfig.Container or titleOrConfig.Row or parentContainer
            else
                title = tostring(titleOrConfig or "Progress")
                if type(options) == "table" then
                    initialPct = options.Progress or options.Value or options.Default or 0
                    statusText = options.Status or options.Desc or ""
                    cardOpts = options
                    parentContainer = options.Parent or options.Container or options.Row or parentContainer
                elseif type(options) == "number" then
                    initialPct = options
                    statusText = ""
                    cardOpts = {}
                else
                    initialPct = 0
                    statusText = tostring(options or "")
                    cardOpts = {}
                end
            end

            if initialPct > 1 then initialPct = initialPct / 100 end
            initialPct = math.clamp(initialPct, 0, 1)

            local targetParent = ResolveParent(parentContainer) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame) or IsInsideSection(targetParent)

            local CardFrame = Instance.new("Frame")
            CardFrame.Name = "MDProgressBarCard_" .. title:gsub("%s+", "_")
            CardFrame:SetAttribute("MDCard", true)
            CardFrame.Size = isInside and UDim2.new(1, 0, 0, 52) or UDim2.new(1, -10, 0, 52)
            CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
            CardFrame.BackgroundTransparency = (isInside and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
            CardFrame.BorderSizePixel = 0
            CardFrame.ZIndex = 10
            CardFrame.Parent = targetParent

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 8)
            CardCorner.Parent = CardFrame

            local shadow = AddUIShadow(CardFrame, 20, 0.5)
            if isInside and Window.SectionsTransparent and shadow then
                pcall(function() shadow.Visible = false end)
            end

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "ProgressTitle"
            TitleLabel.Size = UDim2.new(1, -120, 0, 20)
            TitleLabel.Position = UDim2.new(0, 14, 0, 7)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.FontFace = FontFingerPaintRegular
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Window.CurrentTheme.Text
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
            TitleLabel.ZIndex = 11
            TitleLabel.Parent = CardFrame

            local StatusLabel = Instance.new("TextLabel")
            StatusLabel.Name = "ProgressStatus"
            StatusLabel.Size = UDim2.new(0, 100, 0, 20)
            StatusLabel.Position = UDim2.new(1, -14, 0, 7)
            StatusLabel.AnchorPoint = Vector2.new(1, 0)
            StatusLabel.BackgroundTransparency = 1
            StatusLabel.FontFace = FontFingerPaintRegular
            StatusLabel.Text = (statusText ~= "" and statusText) or (tostring(math.floor(initialPct * 100)) .. "%")
            StatusLabel.TextColor3 = Window.CurrentTheme.SubText
            StatusLabel.TextSize = 12
            StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
            StatusLabel.TextYAlignment = Enum.TextYAlignment.Center
            StatusLabel.ZIndex = 11
            StatusLabel.Parent = CardFrame

            local TrackFrame = Instance.new("Frame")
            TrackFrame.Name = "TrackFrame"
            TrackFrame.Size = UDim2.new(1, -28, 0, 8)
            TrackFrame.Position = UDim2.new(0, 14, 0, 32)
            TrackFrame.BackgroundColor3 = (Window.CurrentTheme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(220, 225, 235) or Color3.fromRGB(25, 28, 36)
            TrackFrame.BackgroundTransparency = 0.2
            TrackFrame.BorderSizePixel = 0
            TrackFrame.ClipsDescendants = true
            TrackFrame.ZIndex = 11
            TrackFrame.Parent = CardFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = TrackFrame

            local FillBar = Instance.new("Frame")
            FillBar.Name = "FillBar"
            FillBar.Size = UDim2.new(initialPct, 0, 1, 0)
            FillBar.Position = UDim2.new(0, 0, 0, 0)
            FillBar.BackgroundColor3 = (cardOpts and cardOpts.Color) or Window.CurrentTheme.Divider or Window.CurrentTheme.AccentBG
            FillBar.BorderSizePixel = 0
            FillBar.ZIndex = 12
            FillBar.Parent = TrackFrame

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = FillBar

            local currentProgress = initialPct

            local progressObj = {
                CardFrame = CardFrame,
                TitleLabel = TitleLabel,
                StatusLabel = StatusLabel,
                Track = TrackFrame,
                Fill = FillBar,
                GetProgress = function() return currentProgress end,
                SetProgress = function(self, pct, newStatus, animated)
                    if pct > 1 then pct = pct / 100 end
                    currentProgress = math.clamp(pct, 0, 1)
                    local targetSize = UDim2.new(currentProgress, 0, 1, 0)
                    if animated ~= false then
                        TweenService:Create(FillBar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = targetSize
                        }):Play()
                    else
                        FillBar.Size = targetSize
                    end
                    if newStatus ~= nil then
                        StatusLabel.Text = tostring(newStatus)
                    else
                        StatusLabel.Text = tostring(math.floor(currentProgress * 100)) .. "%"
                    end
                end,
                SetStatus = function(self, newStatus)
                    StatusLabel.Text = tostring(newStatus or "")
                end,
                SetTitle = function(self, newTitle)
                    TitleLabel.Text = tostring(newTitle or "")
                end,
                SetColor = function(self, col)
                    FillBar.BackgroundColor3 = col
                end,
                RefreshTheme = function(theme)
                    local inSec = IsInsideSection(CardFrame)
                    CardFrame.BackgroundColor3 = theme.CardBG
                    CardFrame.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                    TitleLabel.TextColor3 = theme.Text
                    StatusLabel.TextColor3 = theme.SubText
                    TrackFrame.BackgroundColor3 = (theme.CardBG == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(220, 225, 235) or Color3.fromRGB(25, 28, 36)
                    if not (cardOpts and cardOpts.Color) then
                        FillBar.BackgroundColor3 = theme.Divider or theme.AccentBG
                    end
                end
            }

            progressObj.WithProgress = function(self, pct, stat, anim)
                self:SetProgress(pct, stat, anim)
                return self
            end
            progressObj.WithStatus = function(self, stat)
                self:SetStatus(stat)
                return self
            end
            progressObj.WithTooltip = function(self, tt)
                if Window.AttachTooltip and CardFrame then
                    Window:AttachTooltip(CardFrame, tt)
                end
                return self
            end

            if cardOpts and type(cardOpts) == "table" and (cardOpts.Tooltip or cardOpts.tooltip) then
                progressObj:WithTooltip(cardOpts.Tooltip or cardOpts.tooltip)
            end

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            table.insert(Window.SearchableItems, {
                Type = "ProgressBar",
                Name = title or "Progress",
                Desc = statusText,
                TabName = tabName,
                Instance = CardFrame
            })

            return progressObj
        end
        TabObj.AddStatusCard = TabObj.AddProgressBar

        function TabObj:AddItems(itemList)
            if type(itemList) ~= "table" then return {} end
            local created = {}
            for idx, item in ipairs(itemList) do
                if type(item) == "table" then
                    local iType = (item.Type or item.type or "Button"):lower()
                    local element = nil

                    if iType == "toggle" then
                        element = TabObj:AddToggle(item)
                    elseif iType == "slider" then
                        element = TabObj:AddSlider(item)
                    elseif iType == "button" then
                        element = TabObj:AddButton(item.Name or item.Title or item.Text or ("Button " .. idx), item.Desc or item.Description, item.Callback or item.OnClick)
                    elseif iType == "longbutton" then
                        element = TabObj:AddLongButton(item)
                    elseif iType == "dropdown" then
                        element = TabObj:AddDropdown(item.Title or item.Name or ("Dropdown " .. idx), item.Options or item.options or item.Values or item.values or {}, item.Default or item.default, item.Callback or item.OnSelect)
                    elseif iType == "multidropdown" or iType == "multiselect" then
                        element = TabObj:AddMultiDropdown(item)
                    elseif iType == "numberinput" or iType == "spinbox" or iType == "number" then
                        element = TabObj:AddNumberInput(item)
                    elseif iType == "textbox" or iType == "input" then
                        element = TabObj:AddTextbox(item)
                    elseif iType == "colorpicker" or iType == "color" then
                        element = TabObj:AddColorPicker(item.Title or item.Name or "Color", item.Default or item.Color or Color3.fromRGB(255, 255, 255), item.Callback)
                    elseif iType == "progressbar" or iType == "progress" or iType == "status" then
                        element = TabObj:AddProgressBar(item)
                    elseif iType == "label" or iType == "header" or iType == "section" then
                        element = TabObj:AddLabel(item)
                    elseif iType == "divider" or iType == "separator" then
                        element = TabObj:AddDivider(item)
                    elseif iType == "toggleslider" then
                        element = TabObj:AddToggleSlider(item)
                    elseif iType == "togglegroup" then
                        element = TabObj:AddToggleGroup(item.Toggles or item.List or item)
                    elseif iType == "mobilebutton" then
                        element = Window:CreateMobileButton(item)
                    end

                    if element then
                        table.insert(created, element)
                        local key = item.Name or item.Title or item.SaveKey or item.Text
                        if key and key ~= "" then
                            created[key] = element
                        end
                    end
                end
            end
            return created
        end
        TabObj.AddElements = TabObj.AddItems

        function TabObj:SaveConfig(configName)
            return Window:SaveTabConfig(tabName, configName)
        end
        function TabObj:LoadConfig(configName)
            return Window:LoadTabConfig(tabName, configName)
        end

        function TabObj:AddRow(height, padding, parentRow)
            height = height or 31
            padding = padding or 8
            local targetParent = ResolveParent(parentRow) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame)

            local RowFrame = Instance.new("Frame")
            RowFrame.Name = "RowFrame"
            RowFrame.Size = isInside and UDim2.new(1, 0, 0, height) or UDim2.new(1, -10, 0, height)
            RowFrame.BackgroundTransparency = 1
            RowFrame.BorderSizePixel = 0
            RowFrame.ZIndex = 8
            RowFrame.ClipsDescendants = false
            RowFrame.Parent = targetParent

            local RowLayout = Instance.new("UIListLayout")
            RowLayout.Name = "RowLayout"
            RowLayout.FillDirection = Enum.FillDirection.Horizontal
            RowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
            RowLayout.Padding = UDim.new(0, padding)
            RowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            RowLayout.Parent = RowFrame

            local _rowItemOrder = 0
            RowFrame.ChildAdded:Connect(function(child)
                if child:IsA("GuiObject") and child.LayoutOrder == 0 then
                    _rowItemOrder = _rowItemOrder + 1
                    child.LayoutOrder = _rowItemOrder
                end
            end)

            local RowObj = {
                Frame = RowFrame,
                Instance = RowFrame,
            }

            function RowObj:AddButton(text, callback, sizeFraction)
                if type(text) == "table" and not text.IsA then
                    return TabObj:AddLongButton(text, nil, sizeFraction or 0.5, RowFrame)
                end
                return TabObj:AddLongButton(text, callback, sizeFraction or 0.5, RowFrame)
            end
            function RowObj:AddLongButton(text, callback, sizeFraction)
                if type(text) == "table" and not text.IsA then
                    return TabObj:AddLongButton(text, nil, sizeFraction or 0.5, RowFrame)
                end
                return TabObj:AddLongButton(text, callback, sizeFraction or 0.5, RowFrame)
            end
            function RowObj:AddToggle(titleOrConfig, initialState, onToggle, sizeFraction)
                if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                    return TabObj:AddToggle(titleOrConfig, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddToggle(titleOrConfig, initialState, onToggle, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddCheckbox(titleOrConfig, initialState, onToggle, sizeFraction)
                if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                    return TabObj:AddCheckbox(titleOrConfig, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddCheckbox(titleOrConfig, initialState, onToggle, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddDropdown(title, options, defaultOption, onSelect, sizeFraction)
                if type(title) == "table" and not title.IsA then
                    return TabObj:AddDropdown(title, nil, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddDropdown(title, options, defaultOption, onSelect, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddMultiDropdown(titleOrConfig, options, defaultSelections, onSelect, sizeFraction)
                if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                    return TabObj:AddMultiDropdown(titleOrConfig, nil, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddMultiDropdown(titleOrConfig, options, defaultSelections, onSelect, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddPriorityDropdown(titleOrConfig, options, defaultOrder, onSelect, sizeFraction)
                if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                    return TabObj:AddPriorityDropdown(titleOrConfig, nil, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddPriorityDropdown(titleOrConfig, options, defaultOrder, onSelect, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddImageDropdown(titleOrConfig, options, defaultOption, onSelect, sizeFraction)
                if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                    return TabObj:AddImageDropdown(titleOrConfig, nil, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddImageDropdown(titleOrConfig, options, defaultOption, onSelect, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddNumberInput(titleOrConfig, options, callback, sizeFraction)
                if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                    return TabObj:AddNumberInput(titleOrConfig, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddNumberInput(titleOrConfig, options, callback, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddSpinbox(titleOrConfig, options, callback, sizeFraction)
                if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                    return TabObj:AddNumberInput(titleOrConfig, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddNumberInput(titleOrConfig, options, callback, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddTextInput(...)
                return self:AddTextbox(...)
            end

            function RowObj:AddTextbox(title, placeholder, defaultText, onSubmit, sizeFraction)
                if type(title) == "table" and not title.IsA then
                    return TabObj:AddTextbox(title, nil, nil, nil, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddTextbox(title, placeholder, defaultText, onSubmit, RowFrame, nil, sizeFraction or 0.5)
            end
            function RowObj:AddColorPicker(title, defaultColor, callback, sizeFraction, identifier)
                if type(title) == "table" and not title.IsA then
                    return TabObj:AddColorPicker(title, nil, nil, RowFrame, nil, sizeFraction or 0.5, identifier)
                end
                return TabObj:AddColorPicker(title, defaultColor, callback, RowFrame, nil, sizeFraction or 0.5, identifier)
            end
            function RowObj:AddSlider(title, min, max, default, callback, sizeFraction, options)
                if type(title) == "table" and not title.IsA then
                    return TabObj:AddSlider(title, RowFrame, nil, sizeFraction or 0.5)
                end
                return TabObj:AddSlider(title, min, max, default, callback, options, RowFrame, nil, sizeFraction or 0.5)
            end

            setmetatable(RowObj, {
                __index = function(t, k)
                    local s, v = pcall(function() return RowFrame[k] end)
                    if s then return v end
                    return nil
                end,
                __newindex = function(t, k, v)
                    pcall(function() RowFrame[k] = v end)
                end,
            })

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return RowObj
        end

        function TabObj:AddLongButton(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
            local text, callback, sizeInput, parentRow, position, icon, showArrow
            if type(arg1) == "table" and not arg1.IsA then
                text = arg1.Text or arg1.Title or arg1.Name or arg1[1] or "Button"
                callback = arg1.Callback or arg1.OnClick or arg1.callback or arg1[2]
                sizeInput = arg1.Size or arg1.Fraction or arg1.size or arg1[3]
                parentRow = arg1.Parent or arg1.Row or arg1.parentRow
                position = arg1.Position or arg1.pos
                icon = arg1.Icon or arg1.icon or arg1.IconAsset
                showArrow = arg1.ShowArrow
            else
                text = arg1 or "Button"
                callback = arg2
                if typeof(arg3) == "Instance" or (type(arg3) == "table" and (arg3.Frame or arg3.Instance)) then
                    parentRow = arg3
                    position = arg4
                else
                    sizeInput = arg3
                    parentRow = arg4
                    position = arg5
                end
                icon = arg6
                showArrow = arg7
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeInput, (parentRow and not isGroup) and 0.5 or 1.0)
            local targetParent = parentRow
            local finalSize

            if explicitUDim then
                finalSize = explicitUDim
                targetParent = targetParent or ContentFrame
            elseif targetParent then
                finalSize = ComputeRowItemWidth(fraction or 1.0, 31)
            else
                -- Auto-Flow Left-to-Right Sorting Engine
                if fraction and fraction < 0.98 then
                    local needsNewRow = false
                    if not TabObj.CurrentAutoRow or not TabObj.CurrentAutoRow.Parent or TabObj.CurrentAutoRow.Parent ~= ContentFrame then
                        needsNewRow = true
                    elseif (TabObj.CurrentAutoRowRemaining or 0) < (fraction - 0.02) then
                        needsNewRow = true
                    end

                    if needsNewRow then
                        TabObj.CurrentAutoRow = TabObj:AddRow(31, 8)
                        TabObj.CurrentAutoRowRemaining = 1.0
                    end

                    targetParent = TabObj.CurrentAutoRow
                    finalSize = ComputeRowItemWidth(fraction, 31)
                    TabObj.CurrentAutoRowRemaining = (TabObj.CurrentAutoRowRemaining or 1.0) - fraction
                    if TabObj.CurrentAutoRowRemaining <= 0.05 then
                        TabObj.CurrentAutoRow = nil
                    end
                else
                    TabObj.CurrentAutoRow = nil
                    TabObj.CurrentAutoRowRemaining = 0
                    targetParent = ContentFrame
                    finalSize = UDim2.new(1, -10, 0, 31)
                end
            end

            local pos = position or UDim2.new(0, 0, 0, 0)
            local btnData = Window:CreateMDButtonLong(targetParent, pos, finalSize, text, callback, icon, showArrow)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(btnData, text, function(newText)
                    if btnData.SetText then
                        btnData:SetText(newText)
                    end
                end)
            end

            table.insert(Window.SearchableItems, {
                Type = "Button",
                Name = text or "Button",
                Desc = "",
                TabName = tabName,
                Instance = btnData.Frame,
                Callback = callback
            })

            return btnData
        end

        function TabObj:AddButtonRow(buttonList, height, parentRow)
            local targetParent = ResolveParent(parentRow) or TabObj.CurrentSectionContainer or ContentFrame
            local isInsideSection = (targetParent ~= nil and targetParent ~= ContentFrame)
            height = height or (isInsideSection and 24 or 31)
            if isInsideSection and (height == 31 or height > 28) then
                height = 24
            end
            if type(buttonList) ~= "table" then return end

            local pad = isInsideSection and 6 or 8
            local row = TabObj:AddRow(height, pad, targetParent)
            local count = #buttonList
            local defaultFraction = count > 0 and (1 / count) or 0.5

            local results = {}
            for i, item in ipairs(buttonList) do
                local text, callback, sizeInput, icon
                if type(item) == "table" and not item.IsA then
                    text = item.Text or item.Title or item.Name or item[1] or "Button"
                    callback = item.Callback or item.OnClick or item.callback or item[2]
                    sizeInput = item.Size or item.Fraction or item[3] or defaultFraction
                    icon = item.Icon or item.icon or item.IconAsset
                else
                    text = tostring(item)
                    sizeInput = defaultFraction
                end

                local fraction, explicitUDim = ResolveSizeFraction(sizeInput, defaultFraction)
                local padTotal = pad * math.max(0, count - 1)
                local offsetSub = math.floor(padTotal / math.max(1, count))
                local itemSize = explicitUDim or UDim2.new(fraction or defaultFraction, -offsetSub, 0, height)
                local btn = Window:CreateMDButtonLong(row, UDim2.new(0, 0, 0, 0), itemSize, text, callback, icon)

                if Window.RegisterLocalizedElement then
                    Window:RegisterLocalizedElement(btn, text, function(newText)
                        if btn.SetText then
                            btn:SetText(newText)
                        end
                    end)
                end

                table.insert(Window.SearchableItems, {
                    Type = "Button",
                    Name = text,
                    Desc = "",
                    TabName = tabName,
                    Instance = btn.Frame,
                    Callback = callback
                })
                table.insert(results, btn)
            end

            return row, results
        end

        function TabObj:AddDropdown(titleOrConfig, options, defaultOption, onSelect, parentRow, position, sizeFraction, dropConfig)
            local title, dropOpts, defOpt, cb, cfg
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Dropdown"
                dropOpts = titleOrConfig.Options or titleOrConfig.options or titleOrConfig.Values or titleOrConfig.values or titleOrConfig.List or titleOrConfig[2] or {}
                defOpt = titleOrConfig.Default or titleOrConfig.default or titleOrConfig[3]
                cb = titleOrConfig.Callback or titleOrConfig.OnSelect or titleOrConfig.callback or titleOrConfig[4]
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
                cfg = titleOrConfig
            else
                title = titleOrConfig or "Dropdown"
                dropOpts = options or {}
                defOpt = defaultOption
                cb = onSelect
                cfg = dropConfig
            end
            if not defOpt and dropOpts and #dropOpts > 0 then
                defOpt = dropOpts[1]
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = isGroup and 38 or (parentRow and 42) or 44
            local size = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)
            local dropObj = Window:CreateMDDropdown(targetParent, pos, size, title, dropOpts, defOpt, cb, cfg)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            table.insert(Window.SearchableItems, {
                Type = "Dropdown",
                Name = title or "Dropdown",
                Desc = "",
                TabName = tabName,
                Instance = dropObj.Frame
            })

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(dropObj, title, function(newText)
                    if dropObj.SetTitle then
                        dropObj:SetTitle(newText)
                    end
                end)
            end

            return dropObj
        end

        function TabObj:AddTextInput(...)
            return self:AddTextbox(...)
        end
        TabObj.AddInput = TabObj.AddTextInput

        function TabObj:AddTextbox(titleOrConfig, placeholder, defaultText, onSubmit, parentRow, position, sizeFraction, boxOptions)
            local title, ph, def, cb, opts
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Input"
                ph = titleOrConfig.Placeholder or titleOrConfig.placeholder or titleOrConfig[2] or "Type here..."
                def = titleOrConfig.Default or titleOrConfig.default or titleOrConfig[3] or ""
                cb = titleOrConfig.Callback or titleOrConfig.OnSubmit or titleOrConfig.callback or titleOrConfig[4]
                opts = titleOrConfig
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
            else
                title = titleOrConfig or "Input"
                ph = placeholder or "Type here..."
                def = defaultText or ""
                cb = onSubmit
                opts = boxOptions
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = isGroup and 38 or (parentRow and 42) or 44
            local size = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)
            local boxObj = Window:CreateMDTextbox(targetParent, pos, size, title, ph, def, cb, opts)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            table.insert(Window.SearchableItems, {
                Type = "Textbox",
                Name = title or "Textbox",
                Desc = ph or "",
                TabName = tabName,
                Instance = boxObj.Frame
            })

            return boxObj
        end

        function TabObj:AddColorPicker(titleOrConfig, defaultColor, callback, parentRow, position, sizeFraction, idParam)
            local title, defColor, cb, id
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Color"
                defColor = titleOrConfig.Default or titleOrConfig.Color or titleOrConfig[2] or Color3.fromRGB(255, 255, 255)
                cb = titleOrConfig.Callback or titleOrConfig.OnChanged or titleOrConfig[3]
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
                id = titleOrConfig.SaveKey or titleOrConfig.saveKey or titleOrConfig.Id or titleOrConfig.id or titleOrConfig.Identifier or titleOrConfig.identifier or title
            else
                title = titleOrConfig or "Color"
                defColor = defaultColor or Color3.fromRGB(255, 255, 255)
                cb = callback
                id = idParam or title
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = isGroup and 38 or 44
            local size = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)
            local cpData = Window:CreateMDColorPicker(targetParent, pos, size, title, defColor, cb, id, titleOrConfig)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            table.insert(Window.SearchableItems, {
                Type = "Color picker",
                Name = title or "Color",
                Desc = "",
                TabName = tabName,
                Instance = cpData.Frame
            })

            return cpData
        end

        function TabObj:CreateConfigSection()
            return Window:CreateConfigSection(TabObj)
        end

        function TabObj:CreateCreditsSection()
            return Window:CreateCreditsSection(TabObj)
        end

        function TabObj:AddLanguageDropdown(titleOrConfig)
            local cfg = (type(titleOrConfig) == "table") and titleOrConfig or { Title = titleOrConfig }
            local title = cfg.Title or "Interface language"
            local options = cfg.Options or Window.Languages or { "English", "Russian" }
            local default = cfg.Default or Window.CurrentLanguage or options[1] or "English"
            local cb = cfg.Callback

            local langDrop = TabObj:AddDropdown({
                Title = title,
                Options = options,
                Default = default,
                Callback = function(selectedLang)
                    Window:SetLanguage(selectedLang)
                    if cb then pcall(cb, selectedLang) end
                end
            })
            Window.LanguageDropdown = langDrop
            Window.LanguageDropdowns = Window.LanguageDropdowns or {}
            table.insert(Window.LanguageDropdowns, langDrop)
            return langDrop
        end

        function TabObj:SetBackgroundImage(configOrImage, size, position, zIndex, color, transparency)
            local img, sz, pos, z, col, trans, scaleType
            if type(configOrImage) == "table" then
                img = configOrImage.Image or configOrImage.Asset or configOrImage.Texture or configOrImage[1]
                sz = configOrImage.Size or configOrImage.size
                pos = configOrImage.Position or configOrImage.position or (configOrImage.X and configOrImage.Y and UDim2.new(0, configOrImage.X, 0, configOrImage.Y))
                z = configOrImage.ZIndex or configOrImage.zIndex or configOrImage.Z
                col = configOrImage.Color or configOrImage.ImageColor3 or configOrImage.Color3
                trans = configOrImage.Transparency or configOrImage.ImageTransparency
                scaleType = configOrImage.ScaleType
            else
                img = configOrImage
                sz = size
                pos = position
                z = zIndex
                col = color
                trans = transparency
            end

            if not TabObj.BackgroundImage then
                local bgImg = Instance.new("ImageLabel")
                bgImg.Name = "TabBackgroundImage"
                bgImg.BackgroundTransparency = 1
                bgImg.BorderSizePixel = 0
                bgImg.ScaleType = scaleType or Enum.ScaleType.Stretch
                bgImg.Parent = ContentFrame
                TabObj.BackgroundImage = bgImg
            end

            local bg = TabObj.BackgroundImage
            if img ~= nil then
                bg.Image = tostring(img):find("://") and tostring(img) or ("rbxassetid://" .. tostring(img))
            end
            if sz ~= nil then bg.Size = sz else bg.Size = UDim2.new(1, 0, 1, 0) end
            if pos ~= nil then bg.Position = pos else bg.Position = UDim2.new(0, 0, 0, 0) end
            if z ~= nil then bg.ZIndex = z else bg.ZIndex = 1 end
            if col ~= nil then bg.ImageColor3 = col else bg.ImageColor3 = Color3.fromRGB(255, 255, 255) end
            if trans ~= nil then bg.ImageTransparency = trans else bg.ImageTransparency = 0 end
            if scaleType ~= nil then bg.ScaleType = scaleType end
            bg.Visible = (bg.Image ~= "")
            return bg
        end

        function TabObj:AddSection(titleOrConfig, isFullWidth)
            local title, fullWidth
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                title = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Section"
                fullWidth = titleOrConfig.FullWidth or titleOrConfig.fullWidth or isFullWidth
            else
                title = tostring(titleOrConfig or "Section")
                fullWidth = isFullWidth
            end

            local host = TabObj._sectionHost
            if host then fullWidth = true end

            -- Lazily create the dual-column wrapper on first non-fullWidth section
            if not fullWidth and not TabObj._columnWrapper then
                local ColumnWrapper = Instance.new("Frame")
                ColumnWrapper.Name = "SectionColumns"
                ColumnWrapper.Size = UDim2.new(1, -10, 0, 0)
                ColumnWrapper.AutomaticSize = Enum.AutomaticSize.Y
                ColumnWrapper.BackgroundTransparency = 1
                ColumnWrapper.BorderSizePixel = 0
                ColumnWrapper.ZIndex = 3
                ColumnWrapper.Parent = ContentFrame

                local ColLayout = Instance.new("UIListLayout")
                ColLayout.Name = "ColLayout"
                ColLayout.FillDirection = Enum.FillDirection.Horizontal
                ColLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                ColLayout.VerticalAlignment = Enum.VerticalAlignment.Top
                ColLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ColLayout.Padding = UDim.new(0, 8)
                ColLayout.Parent = ColumnWrapper

                local LeftCol = Instance.new("Frame")
                LeftCol.Name = "LeftColumn"
                LeftCol.Size = UDim2.new(0.5, -4, 0, 0)
                LeftCol.AutomaticSize = Enum.AutomaticSize.Y
                LeftCol.BackgroundTransparency = 1
                LeftCol.BorderSizePixel = 0
                LeftCol.LayoutOrder = 1
                LeftCol.Parent = ColumnWrapper

                local LeftLayout = Instance.new("UIListLayout")
                LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
                LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                LeftLayout.Padding = UDim.new(0, 8)
                LeftLayout.Parent = LeftCol

                local RightCol = Instance.new("Frame")
                RightCol.Name = "RightColumn"
                RightCol.Size = UDim2.new(0.5, -4, 0, 0)
                RightCol.AutomaticSize = Enum.AutomaticSize.Y
                RightCol.BackgroundTransparency = 1
                RightCol.BorderSizePixel = 0
                RightCol.LayoutOrder = 2
                RightCol.Parent = ColumnWrapper

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                RightLayout.Padding = UDim.new(0, 8)
                RightLayout.Parent = RightCol

                TabObj._columnWrapper = ColumnWrapper
                TabObj._leftColumn = LeftCol
                TabObj._rightColumn = RightCol
                TabObj._nextColumn = "left"
            end

            local targetColumn
            if fullWidth then
                targetColumn = host or ContentFrame
            else
                if TabObj._nextColumn == "left" then
                    targetColumn = TabObj._leftColumn
                    TabObj._nextColumn = "right"
                else
                    targetColumn = TabObj._rightColumn
                    TabObj._nextColumn = "left"
                end
            end

            local cardWidth = fullWidth and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 0, 0)
            local SectionCard = Instance.new("Frame")
            SectionCard.Name = "SectionCard_" .. title:gsub("%s+", "_")
            SectionCard.Size = cardWidth
            SectionCard.AutomaticSize = Enum.AutomaticSize.Y
            SectionCard.BackgroundColor3 = Window.CurrentTheme.CardBG
            SectionCard.BackgroundTransparency = Window.SectionsTransparent and 1 or (Window.ElementsTransparency or 0.33)
            SectionCard.BorderSizePixel = 0
            SectionCard.ClipsDescendants = false
            SectionCard.ZIndex = 4
            SectionCard.Parent = targetColumn

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 14)
            SectionCorner.Parent = SectionCard

            -- Animated gradient border (right-to-left shimmer between brighter/darker Divider tones)
            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Thickness = 1
            SectionStroke.Color = Window.CurrentTheme.Divider or Color3.fromRGB(65, 70, 88)
            SectionStroke.Transparency = Window.SectionsTransparent and 1 or 0.5
            SectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            SectionStroke.Parent = SectionCard

            local StrokeGradient = Instance.new("UIGradient")
            StrokeGradient.Rotation = 0  -- horizontal, animating offset
            StrokeGradient.Parent = SectionStroke

            local _strokeOffset = 0
            local function _buildStrokeSeq(base, offset)
                local h, s, v = Color3.toHSV(base)
                local bright = Color3.fromHSV(h, s, math.min(1, v + 0.18))
                local dark   = Color3.fromHSV(h, s, math.max(0, v - 0.12))
                local t = (math.sin(offset) + 1) * 0.5  -- 0..1
                -- gradient: bright at right side fading to dark on left
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, dark),
                    ColorSequenceKeypoint.new(math.clamp(0.5 - t * 0.4, 0.01, 0.99), base),
                    ColorSequenceKeypoint.new(1, bright),
                })
            end

            local _strokeBase = Window.CurrentTheme.Divider or Color3.fromRGB(65, 70, 88)
            StrokeGradient.Color = _buildStrokeSeq(_strokeBase, 0)

            local _lastStrokeUpdate = 0
            local _sConn = RunService.Heartbeat:Connect(function(dt)
                if not SectionCard or not SectionCard.Parent then return end
                if not ContentFrame.Visible or not ScriptUi.Enabled then return end
                local now = os.clock()
                if now - _lastStrokeUpdate < 0.033 then return end
                _lastStrokeUpdate = now
                _strokeOffset = _strokeOffset + dt * 0.8
                if StrokeGradient and StrokeGradient.Parent then
                    StrokeGradient.Color = _buildStrokeSeq(_strokeBase, _strokeOffset)
                    StrokeGradient.Rotation = (_strokeOffset * 20) % 360
                end
            end)
            TrackConn(_sConn)

            AddUIShadow(SectionCard, 10, 0.35)

            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingTop = UDim.new(0, 8)
            SectionPadding.PaddingBottom = UDim.new(0, 8)
            SectionPadding.PaddingLeft = UDim.new(0, 8)
            SectionPadding.PaddingRight = UDim.new(0, 8)
            SectionPadding.Parent = SectionCard

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionLayout.Padding = UDim.new(0, 6)
            SectionLayout.Parent = SectionCard

            local HeaderFrame = Instance.new("Frame")
            HeaderFrame.Name = "Header"
            HeaderFrame.Size = UDim2.new(1, 0, 0, 22)
            HeaderFrame.BackgroundTransparency = 1
            HeaderFrame.BorderSizePixel = 0
            HeaderFrame.LayoutOrder = 0
            HeaderFrame.ZIndex = 6
            HeaderFrame.Parent = SectionCard

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -30, 1, 0)
            TitleLabel.Position = UDim2.new(0, 6, 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.FontFace = FontFingerPaintBold
            TitleLabel.Text = title:upper()
            TitleLabel.TextColor3 = Window.CurrentTheme.Text
            TitleLabel.TextSize = 12
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.ZIndex = 7
            TitleLabel.Parent = HeaderFrame

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Name = "ArrowIcon"
            ArrowIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
            ArrowIcon.Position = UDim2.new(1, -8, 0.5, 0)
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Image = "rbxassetid://11552476728"
            ArrowIcon.ImageColor3 = Window.CurrentTheme.SubText
            ArrowIcon.Rotation = 180
            ArrowIcon.ZIndex = 7
            ArrowIcon.Parent = HeaderFrame

            local HeaderTrigger = Instance.new("TextButton")
            HeaderTrigger.Name = "HeaderTrigger"
            HeaderTrigger.Size = UDim2.new(1, 0, 1, 0)
            HeaderTrigger.BackgroundTransparency = 1
            HeaderTrigger.Text = ""
            HeaderTrigger.ZIndex = 8
            HeaderTrigger.Parent = HeaderFrame

            local HeaderLine = Instance.new("ImageLabel")
            HeaderLine.Name = "Divider"
            HeaderLine.Size = UDim2.new(1, 0, 0, 5)
            HeaderLine.BackgroundTransparency = 1
            HeaderLine.Image = "rbxassetid://133887791984569"
            HeaderLine.ImageColor3 = Window.CurrentTheme.Divider or Color3.fromRGB(65, 70, 88)
            HeaderLine.ScaleType = Enum.ScaleType.Stretch
            HeaderLine.BorderSizePixel = 0
            HeaderLine.LayoutOrder = 1
            HeaderLine.ZIndex = 6
            HeaderLine.Parent = SectionCard

            local ItemContainer = Instance.new("Frame")
            ItemContainer.Name = "VerticalGroup"
            ItemContainer.Size = UDim2.new(1, 0, 0, 0)
            ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
            ItemContainer.BackgroundTransparency = 1
            ItemContainer.BorderSizePixel = 0
            ItemContainer.ClipsDescendants = false
            ItemContainer.LayoutOrder = 2
            ItemContainer.ZIndex = 6
            ItemContainer.Parent = SectionCard

            local ItemLayout = Instance.new("UIListLayout")
            ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ItemLayout.Padding = UDim.new(0, 6)
            ItemLayout.Parent = ItemContainer

            -- Animated collapse / expand - tweens CARD height for smooth layout shift
            local isCollapsed = false
            local isAnimating = false
            local tweenInfo025 = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            -- collapsed height = header(22) + padding top(8) + padding bottom(8) = 38
            local collapsedH = 38

            local function ToggleCollapse(collapsed)
                if collapsed ~= nil then
                    if collapsed == isCollapsed then return end
                    isCollapsed = collapsed
                else
                    isCollapsed = not isCollapsed
                end
                if isAnimating then return end
                isAnimating = true

                local currentH = SectionCard.AbsoluteSize.Y
                SectionCard.ClipsDescendants = true
                ItemContainer.ClipsDescendants = true
                SectionCard.AutomaticSize = Enum.AutomaticSize.None
                SectionCard.Size = UDim2.new(SectionCard.Size.X.Scale, SectionCard.Size.X.Offset, 0, currentH)

                if isCollapsed then
                    TweenService:Create(ArrowIcon, tweenInfo025, {Rotation = 0, ImageColor3 = Window.CurrentTheme.SubText}):Play()
                    TweenService:Create(HeaderLine, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                    local tw = TweenService:Create(SectionCard, tweenInfo025, {
                        Size = UDim2.new(SectionCard.Size.X.Scale, SectionCard.Size.X.Offset, 0, collapsedH)
                    })
                    tw:Play()
                    tw.Completed:Connect(function()
                        ItemContainer.Visible = false
                        HeaderLine.Visible = false
                        SectionCard.ClipsDescendants = false
                        ItemContainer.ClipsDescendants = false
                        isAnimating = false
                        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
                    end)
                else
                    -- Expand section to target height
                    ItemContainer.Visible = true
                    HeaderLine.Visible = true
                    HeaderLine.ImageTransparency = 1
                    TweenService:Create(ArrowIcon, tweenInfo025, {Rotation = 180, ImageColor3 = Window.CurrentTheme.Text}):Play()
                    TweenService:Create(HeaderLine, TweenInfo.new(0.15), {ImageTransparency = 0}):Play()

                    SectionCard.AutomaticSize = Enum.AutomaticSize.Y
                    task.defer(function()
                        task.wait()
                        local targetH = SectionCard.AbsoluteSize.Y
                        if targetH <= collapsedH then targetH = collapsedH + 20 end
                        SectionCard.AutomaticSize = Enum.AutomaticSize.None
                        SectionCard.Size = UDim2.new(SectionCard.Size.X.Scale, SectionCard.Size.X.Offset, 0, collapsedH)
                        local tw = TweenService:Create(SectionCard, tweenInfo025, {
                            Size = UDim2.new(SectionCard.Size.X.Scale, SectionCard.Size.X.Offset, 0, targetH)
                        })
                        tw:Play()
                        tw.Completed:Connect(function()
                            SectionCard.AutomaticSize = Enum.AutomaticSize.Y
                            SectionCard.ClipsDescendants = false
                            ItemContainer.ClipsDescendants = false
                            isAnimating = false
                            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
                        end)
                    end)
                end
            end

            TrackConn(HeaderTrigger.MouseEnter:Connect(function()
                TweenService:Create(ArrowIcon, TweenInfo.new(0.15), {ImageColor3 = Window.CurrentTheme.Text}):Play()
            end))
            TrackConn(HeaderTrigger.MouseLeave:Connect(function()
                if isCollapsed then
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.15), {ImageColor3 = Window.CurrentTheme.SubText}):Play()
                end
            end))
            TrackConn(HeaderTrigger.MouseButton1Click:Connect(function()
                PlayClickSFX()
                ToggleCollapse()
            end))

            TabObj.CurrentSectionContainer = ItemContainer
            TabObj.CurrentSectionCard = SectionCard

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            local SectionObj = {
                Card = SectionCard,
                Container = ItemContainer,
                ItemContainer = ItemContainer,
                Title = title,
                Header = HeaderFrame,
                TitleLabel = TitleLabel,
                ArrowIcon = ArrowIcon,
                HeaderLine = HeaderLine,
                Stroke = SectionStroke,
                ToggleCollapse = ToggleCollapse,
                SetCollapsed = function(self, state)
                    ToggleCollapse(state)
                end,
                IsCollapsed = function(self)
                    return isCollapsed
                end,
                SetTitle = function(selfOrTitle, maybeTitle)
                    local newT = (maybeTitle ~= nil) and maybeTitle or selfOrTitle
                    if type(newT) == "table" then
                        newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Title or newT.Name or newT.Text or newT[1] or ""
                    end
                    local t = tostring(newT or "")
                    SectionObj.Title = t
                    TitleLabel.Text = t:upper()
                    return SectionObj
                end,
                SetText = function(selfOrTitle, maybeTitle)
                    return SectionObj.SetTitle(selfOrTitle, maybeTitle)
                end,
                RefreshTheme = function(self, theme, animated)
                    local twInfo = TweenInfo.new(animated and 0.35 or 0, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    local divColor = theme.Divider or Color3.fromRGB(65, 70, 88)
                    local isST = Window.SectionsTransparent
                    if animated then
                        TweenService:Create(SectionCard, twInfo, {
                            BackgroundColor3 = theme.CardBG,
                            BackgroundTransparency = isST and 1 or (Window.ElementsTransparency or 0.33)
                        }):Play()
                        if SectionStroke then
                            TweenService:Create(SectionStroke, twInfo, {Color = divColor, Transparency = isST and 1 or 0.5}):Play()
                        end
                        if HeaderLine then
                            TweenService:Create(HeaderLine, twInfo, {ImageColor3 = divColor, BackgroundTransparency = 1}):Play()
                        end
                        if TitleLabel then
                            TweenService:Create(TitleLabel, twInfo, {TextColor3 = theme.Text}):Play()
                        end
                        if ArrowIcon then
                            TweenService:Create(ArrowIcon, twInfo, {ImageColor3 = isCollapsed and theme.SubText or theme.Text}):Play()
                        end
                    else
                        SectionCard.BackgroundColor3 = theme.CardBG
                        SectionCard.BackgroundTransparency = isST and 1 or (Window.ElementsTransparency or 0.33)
                        if SectionStroke then SectionStroke.Color = divColor ; SectionStroke.Transparency = isST and 1 or 0.5 end
                        if HeaderLine then HeaderLine.ImageColor3 = divColor; HeaderLine.BackgroundTransparency = 1 end
                        if TitleLabel then TitleLabel.TextColor3 = theme.Text end
                        if ArrowIcon then ArrowIcon.ImageColor3 = isCollapsed and theme.SubText or theme.Text end
                    end
                end,
            }

            function SectionObj:AddToggle(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddToggle(cfg, arg2, arg3, ItemContainer, arg4, arg5, arg6)
                elseif type(arg4) == "table" or typeof(arg4) == "EnumItem" then
                    return TabObj:AddToggle(arg1, arg2, arg3, ItemContainer, arg5, arg6, arg4)
                else
                    return TabObj:AddToggle(arg1, arg2, arg3, ItemContainer, arg4, arg5, arg6)
                end
            end
            function SectionObj:AddCheckbox(arg1, arg2, arg3)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddCheckbox(cfg, arg2, arg3, ItemContainer)
                else
                    return TabObj:AddCheckbox(arg1, arg2, arg3, ItemContainer)
                end
            end
            function SectionObj:AddSlider(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddSlider(cfg, ItemContainer, arg2)
                elseif type(arg1) == "string" and type(arg2) == "table" then
                    local opts = table.clone(arg2)
                    if type(arg3) == "function" and not (opts.Callback or opts.callback or opts.OnChanged) then
                        opts.Callback = arg3
                    end
                    opts.Parent = opts.Parent or opts.Row or ItemContainer
                    return TabObj:AddSlider(arg1, opts, ItemContainer, arg4)
                elseif type(arg1) == "string" then
                    local opts = (type(arg6) == "table" and table.clone(arg6)) or {}
                    opts.Title = arg1
                    opts.Min = arg2
                    opts.Max = arg3
                    opts.Default = arg4
                    opts.Callback = arg5
                    opts.Parent = ItemContainer
                    return TabObj:AddSlider(opts, ItemContainer, arg7)
                elseif type(arg1) == "number" then
                    local opts = (type(arg5) == "table" and table.clone(arg5)) or {}
                    opts.Min = arg1
                    opts.Max = arg2
                    opts.Default = arg3
                    opts.Callback = arg4
                    opts.Parent = ItemContainer
                    return TabObj:AddSlider(opts, ItemContainer, arg6)
                else
                    return TabObj:AddSlider(arg1, ItemContainer, arg3)
                end
            end
            function SectionObj:AddDropdown(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddDropdown(cfg, arg2, arg3, arg4, ItemContainer, arg5, arg6, arg7)
                end
                return TabObj:AddDropdown(arg1, arg2, arg3, arg4, ItemContainer, arg5, arg6, arg7 or arg8)
            end
            function SectionObj:AddMultiDropdown(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddMultiDropdown(cfg, arg2, arg3, arg4, ItemContainer, arg5, arg6 or arg7)
                end
                return TabObj:AddMultiDropdown(arg1, arg2, arg3, arg4, ItemContainer, arg5, arg6 or arg7)
            end
            function SectionObj:AddPriorityDropdown(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddPriorityDropdown(cfg, arg2, arg3, arg4, ItemContainer, arg5, arg6 or arg7)
                end
                return TabObj:AddPriorityDropdown(arg1, arg2, arg3, arg4, ItemContainer, arg5, arg6 or arg7)
            end
            function SectionObj:AddImageDropdown(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddImageDropdown(cfg, arg2, arg3, arg4, ItemContainer, arg5, arg6 or arg7)
                end
                return TabObj:AddImageDropdown(arg1, arg2, arg3, arg4, ItemContainer, arg5, arg6 or arg7)
            end
            function SectionObj:AddStatGrid(configOrStats)
                return TabObj:AddStatGrid(configOrStats, ItemContainer)
            end
            SectionObj.AddStatCard = function(self, config)
                return TabObj:AddStatCard(config, ItemContainer)
            end
            function SectionObj:AddImageGrid(config)
                return TabObj:AddImageGrid(config, ItemContainer)
            end
            SectionObj.AddGallery = SectionObj.AddImageGrid
            function SectionObj:AddPreview(config)
                return TabObj:AddPreview(config, ItemContainer)
            end
            function SectionObj:AddPreviewButton(previewOrConfig, titleOrConfig)
                return TabObj:AddPreviewButton(previewOrConfig, titleOrConfig, ItemContainer)
            end
            function SectionObj:AddButton(arg1, arg2, arg3, arg4)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    if cfg.Desc or cfg.Description or cfg.ButtonText or cfg.desc then
                        return TabObj:AddButton(cfg, arg2, arg3, ItemContainer)
                    elseif cfg.Fraction or cfg.Size or cfg.fraction or cfg.size then
                        return TabObj:AddLongButton(cfg, arg2, arg3 or 1.0, ItemContainer)
                    else
                        return TabObj:AddButton(cfg, arg2, arg3, ItemContainer)
                    end
                elseif type(arg2) == "string" then
                    return TabObj:AddButton(arg1, arg2, arg3, ItemContainer)
                elseif type(arg3) == "number" then
                    return TabObj:AddLongButton(arg1, arg2, arg3, ItemContainer)
                else
                    return TabObj:AddButton(arg1, arg2, arg3, ItemContainer)
                end
            end
            function SectionObj:AddLongButton(arg1, arg2, arg3)
                return TabObj:AddLongButton(arg1, arg2, arg3 or 1.0, ItemContainer)
            end
            SectionObj.AddCardButton = SectionObj.AddButton
            function SectionObj:AddCard(configOrTitle, desc)
                return TabObj:AddCard(configOrTitle, desc, ItemContainer)
            end
            function SectionObj:AddButtonRow(buttonList, height)
                return TabObj:AddButtonRow(buttonList, height or 24, ItemContainer)
            end
            function SectionObj:AddColorPicker(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddColorPicker(cfg, arg2, arg3, ItemContainer, arg4, arg5, arg6 or arg7)
                elseif type(arg4) == "string" then
                    return TabObj:AddColorPicker(arg1, arg2, arg3, ItemContainer, arg5, arg6, arg4)
                else
                    return TabObj:AddColorPicker(arg1, arg2, arg3, ItemContainer, arg4, arg5, arg6 or arg7)
                end
            end
            function SectionObj:AddTextbox(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddTextbox(cfg, arg2, arg3, arg4, ItemContainer, arg5, arg6, arg7 or arg8)
                elseif type(arg5) == "table" then
                    return TabObj:AddTextbox(arg1, arg2, arg3, arg4, ItemContainer, nil, nil, arg5)
                else
                    return TabObj:AddTextbox(arg1, arg2, arg3, arg4, ItemContainer, arg5, arg6, arg7 or arg8)
                end
            end
            function SectionObj:AddTextInput(...)
                return self:AddTextbox(...)
            end
            function SectionObj:AddNumberInput(arg1, arg2, arg3, arg4)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddNumberInput(cfg, arg2, arg3, ItemContainer, nil, arg4)
                end
                return TabObj:AddNumberInput(arg1, arg2, arg3, ItemContainer, nil, arg4)
            end
            SectionObj.AddSpinbox = SectionObj.AddNumberInput
            function SectionObj:AddToggleGroup(toggleList)
                return TabObj:AddToggleGroup(toggleList, ItemContainer)
            end
            function SectionObj:AddGroup(itemList, direction)
                return TabObj:AddGroup(itemList, direction, ItemContainer)
            end
            function SectionObj:AddRow(height, padding)
                return TabObj:AddRow(height or 24, padding or 6, ItemContainer)
            end
            function SectionObj:AddLabel(arg1, arg2)
                return TabObj:AddLabel(arg1, arg2, ItemContainer)
            end
            function SectionObj:AddDivider(arg1)
                return TabObj:AddDivider(arg1, ItemContainer)
            end
            function SectionObj:AddProgressBar(arg1, arg2)
                if type(arg1) == "table" and not arg1.IsA then
                    local cfg = table.clone(arg1)
                    cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                    return TabObj:AddProgressBar(cfg, arg2, ItemContainer)
                end
                return TabObj:AddProgressBar(arg1, arg2, ItemContainer)
            end
            SectionObj.AddStatusCard = SectionObj.AddProgressBar
            SectionObj.AddLanguageDropdown = function(self, titleOrConfig)
                local cfg = (type(titleOrConfig) == "table") and table.clone(titleOrConfig) or { Title = titleOrConfig }
                cfg.Parent = cfg.Parent or cfg.Row or ItemContainer
                return TabObj:AddLanguageDropdown(cfg)
            end

            SectionObj.RefreshTheme = function(self, theme, anim)
                local RealTweenService = game:GetService("TweenService")
                local isST = Window.SectionsTransparent
                if SectionCard and SectionCard.Parent then
                    if anim then
                        RealTweenService:Create(SectionCard, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            BackgroundColor3 = theme.CardBG,
                            BackgroundTransparency = isST and 1 or (Window.ElementsTransparency or 0.33)
                        }):Play()
                    else
                        SectionCard.BackgroundColor3 = theme.CardBG
                        SectionCard.BackgroundTransparency = isST and 1 or (Window.ElementsTransparency or 0.33)
                    end
                end
                if TitleLabel and TitleLabel.Parent then
                    if anim then
                        RealTweenService:Create(TitleLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            TextColor3 = theme.Text
                        }):Play()
                    else
                        TitleLabel.TextColor3 = theme.Text
                    end
                end
                if ArrowIcon and ArrowIcon.Parent then
                    if anim then
                        RealTweenService:Create(ArrowIcon, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            ImageColor3 = theme.SubText
                        }):Play()
                    else
                        ArrowIcon.ImageColor3 = theme.SubText
                    end
                end
                if SectionStroke and SectionStroke.Parent then
                    local newBase = theme.Divider or Color3.fromRGB(65, 70, 88)
                    SectionStroke.Color = newBase
                    SectionStroke.Transparency = isST and 1 or 0.5
                    _strokeBase = newBase  -- gradient animation picks this up automatically
                end
                local newDivCol = theme.Divider or Color3.fromRGB(65, 70, 88)
                if HeaderLine and HeaderLine.Parent then
                    if anim then
                        RealTweenService:Create(HeaderLine, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            ImageColor3 = newDivCol
                        }):Play()
                    else
                        HeaderLine.ImageColor3 = newDivCol
                    end
                end
                if SectionCard and SectionCard.Parent then
                    for _, desc in ipairs(SectionCard:GetDescendants()) do
                        if desc:IsA("ImageLabel") and (desc.Name == "Divider" or desc.Name == "Line" or desc.Name == "MDContentDivider") then
                            if anim then
                                RealTweenService:Create(desc, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    ImageColor3 = newDivCol
                                }):Play()
                            else
                                desc.ImageColor3 = newDivCol
                            end
                        end
                    end
                end
                if ItemContainer and ItemContainer.Parent then
                    for _, desc in ipairs(ItemContainer:GetDescendants()) do
                        if desc:IsA("Frame") and desc.Parent then
                            local dName = desc.Name
                            local isButton = (dName == "MDButtonCard" or dName:find("BtnFrame") or dName == "Btn" or (desc:FindFirstChildOfClass("TextButton") and (dName:find("Btn") or dName:find("Button"))))
                            if not isButton then
                                local isCard = (desc:GetAttribute("MDCard") == true) or dName:find("Card") or dName:find("TextboxFrame") or dName:find("DropdownFrame") or dName:find("BoxFrame")
                                if not isCard and (desc.BackgroundColor3 == theme.CardBG) then
                                    isCard = true
                                end
                                if isCard then
                                    desc.BackgroundTransparency = isST and 1 or (Window.ElementsTransparency or 0.33)
                                    for _, child in ipairs(desc:GetChildren()) do
                                        if child.ClassName == "UIShadow" or child:IsA("UIShadow") or (child.Name and tostring(child.Name):sub(1, 8) == "UIShadow") then
                                            child.Visible = (not isST) and (Window.ShadowsEnabled and (Window.ShadowIntensity or 1) > 0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            Window.RegisteredSections = Window.RegisteredSections or {}
            table.insert(Window.RegisteredSections, SectionObj)

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(SectionObj, title, function(newText)
                    SectionObj:SetTitle(newText)
                end)
            end

            return SectionObj
        end


        function TabObj:AddToggle(titleOrConfig, initialState, onToggle, parentRow, position, sizeFraction, bindConfig)
            local targetParent = ResolveParent(parentRow) or TabObj.CurrentSectionContainer or ContentFrame
            local text, state, cb, bind, connectMode, sliderConfig

            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                text = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Toggle"
                state = titleOrConfig.Default or titleOrConfig.Value or titleOrConfig.State or titleOrConfig[2]
                cb = titleOrConfig.Callback or titleOrConfig.OnChanged or titleOrConfig.callback or titleOrConfig[3]
                bind = titleOrConfig
                connectMode = titleOrConfig.Connect or titleOrConfig.Connected or titleOrConfig.PositionInGroup
                sliderConfig = titleOrConfig.Slider or titleOrConfig.ConnectedSlider
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position = titleOrConfig.Position or position
            else
                text = tostring(titleOrConfig or "Toggle")
                state = initialState
                cb = onToggle
                bind = bindConfig
            end

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = sliderConfig and (isGroup and 68 or 76) or (isGroup and 38 or 44)
            local size = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)

            local toggleData = Window:CreateMDToggleHalf(targetParent, pos, size, text, state, cb, bind, connectMode)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

            if sliderConfig then
                toggleData:AddSlider(sliderConfig)
            end

            table.insert(Window.SearchableItems, {
                Type = "Toggle",
                Name = text or "Toggle",
                Desc = "",
                TabName = tabName,
                Instance = toggleData.Frame
            })

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(toggleData, text, function(newText)
                    if toggleData.SetTitle then
                        toggleData:SetTitle(newText)
                    elseif toggleData.TitleText then
                        if type(newText) == "table" then
                            newText = newText[Window.CurrentLanguage or "English"] or newText["English"] or newText.Title or newText[1] or ""
                        end
                        toggleData.TitleText.Text = tostring(newText or "")
                    end
                end)
            end

            return toggleData
        end

        function TabObj:AddCheckbox(titleOrConfig, initialState, onToggle, parentRow, position, sizeFraction)
            local text, state, cb
            local saveKey, identifier
            if type(titleOrConfig) == "table" and not titleOrConfig.IsA then
                text  = titleOrConfig.Title or titleOrConfig.Name or titleOrConfig.Text or titleOrConfig[1] or "Checkbox"
                state = titleOrConfig.Default or titleOrConfig.Value or titleOrConfig.State or titleOrConfig[2]
                cb    = titleOrConfig.Callback or titleOrConfig.OnChanged or titleOrConfig.callback or titleOrConfig[3]
                saveKey = titleOrConfig.SaveKey or titleOrConfig.saveKey or titleOrConfig.Id or titleOrConfig.Identifier
                identifier = titleOrConfig.Identifier or titleOrConfig.Id or titleOrConfig.Name
                parentRow = titleOrConfig.Parent or titleOrConfig.Row or parentRow
                position  = titleOrConfig.Position or position
                sizeFraction = titleOrConfig.Size or titleOrConfig.Fraction or sizeFraction
            else
                text  = tostring(titleOrConfig or "Checkbox")
                state = initialState
                cb    = onToggle
            end
            saveKey = saveKey or text
            identifier = identifier or text

            parentRow = ResolveParent(parentRow) or TabObj.CurrentSectionContainer
            local targetParent = parentRow or ContentFrame
            local isGroup = parentRow and (parentRow.Name == "ToggleGroup" or parentRow.Name == "VerticalGroup" or parentRow.Name == "HorizontalGroup")
            local fraction, explicitUDim = ResolveSizeFraction(sizeFraction, (parentRow and not isGroup) and 0.5 or 1.0)
            local defaultH = isGroup and 34 or 38
            local size = explicitUDim or (isGroup and UDim2.new(1, 0, 0, defaultH)) or (parentRow and ComputeRowItemWidth(fraction or 0.5, defaultH)) or UDim2.new(1, -10, 0, defaultH)
            local pos = position or UDim2.new(0, 0, 0, 0)

            local isChecked = (state == true)
            local CHECKBOX_SIZE = 18

            local inSection = IsInsideSection(targetParent)
            local CardFrame = Instance.new("Frame")
            CardFrame.Name = GenerateSafeName("CheckboxCard")
            CardFrame:SetAttribute("MDCard", true)
            CardFrame.Size = size
            CardFrame.Position = pos
            CardFrame.BackgroundColor3 = Window.CurrentTheme.CardBG
            CardFrame.BackgroundTransparency = (inSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
            CardFrame.BorderSizePixel = 0
            CardFrame.ZIndex = 10
            CardFrame.Parent = targetParent

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 12)
            CardCorner.Parent = CardFrame

            if not isGroup then
                local shadow = AddUIShadow(CardFrame, 20, 0.5)
                if inSection and Window.SectionsTransparent and shadow then
                    pcall(function() shadow.Visible = false end)
                end
            end

            local BoxOuter = Instance.new("Frame")
            BoxOuter.Name = "CheckBox"
            BoxOuter.Size = UDim2.new(0, CHECKBOX_SIZE, 0, CHECKBOX_SIZE)
            BoxOuter.Position = UDim2.new(1, -(CHECKBOX_SIZE + 12), 0.5, -(CHECKBOX_SIZE / 2))
            BoxOuter.BackgroundColor3 = isChecked and Window.CurrentTheme.ButtonBG or GetThemedDarkColor(Window.CurrentTheme)
            BoxOuter.BackgroundTransparency = 0.05
            BoxOuter.BorderSizePixel = 0
            BoxOuter.ZIndex = 12
            BoxOuter.Parent = CardFrame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 5)
            BoxCorner.Parent = BoxOuter

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Thickness = 1.5
            BoxStroke.Color = isChecked and Window.CurrentTheme.ButtonBG or (Window.CurrentTheme.Divider or Color3.fromRGB(80, 85, 100))
            BoxStroke.Transparency = 0.3
            BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BoxStroke.Parent = BoxOuter

            local _checkIconId = Library:GetIcon("check") or "86817768619372"
            local CheckIcon = Instance.new("ImageLabel")
            CheckIcon.Name = "CheckIcon"
            CheckIcon.Size = UDim2.new(0, CHECKBOX_SIZE - 4, 0, CHECKBOX_SIZE - 4)
            CheckIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            CheckIcon.BackgroundTransparency = 1
            CheckIcon.Image = tostring(_checkIconId):find("://") and tostring(_checkIconId) or ("rbxassetid://" .. tostring(_checkIconId))
            CheckIcon.ImageColor3 = GetOnAccent(Window.CurrentTheme.ButtonBG)
            CheckIcon.ImageTransparency = isChecked and 0 or 1
            CheckIcon.ZIndex = 13
            CheckIcon.Parent = BoxOuter

            local LabelText = Instance.new("TextLabel")
            LabelText.Name = "Label"
            LabelText.Size = UDim2.new(1, -(CHECKBOX_SIZE + 28), 1, 0)
            LabelText.Position = UDim2.new(0, 12, 0, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.FontFace = FontRegular
            LabelText.RichText = true
            LabelText.Text = text or "Checkbox"
            LabelText.TextColor3 = Window.CurrentTheme.Text
            LabelText.TextSize = 14
            LabelText.TextWrapped = true
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.TextYAlignment = Enum.TextYAlignment.Center
            LabelText.ZIndex = 11
            LabelText.Parent = CardFrame

            local HitArea = Instance.new("TextButton")
            HitArea.Size = UDim2.new(1, 0, 1, 0)
            HitArea.BackgroundTransparency = 1
            HitArea.Text = ""
            HitArea.ZIndex = 14
            HitArea.Parent = CardFrame

            local offBG  = GetThemedDarkColor(Window.CurrentTheme)
            local offStroke = Window.CurrentTheme.Divider or Color3.fromRGB(80, 85, 100)

            local function SetChecked(checked, silent)
                isChecked = checked
                local tweenI = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                if checked then
                    TweenService:Create(BoxOuter, tweenI, {BackgroundColor3 = Window.CurrentTheme.ButtonBG}):Play()
                    TweenService:Create(BoxStroke, tweenI, {Color = Window.CurrentTheme.ButtonBG, Transparency = 0}):Play()
                    TweenService:Create(CheckIcon, tweenI, {ImageTransparency = 0, ImageColor3 = GetOnAccent(Window.CurrentTheme.ButtonBG)}):Play()
                else
                    TweenService:Create(BoxOuter, tweenI, {BackgroundColor3 = offBG}):Play()
                    TweenService:Create(BoxStroke, tweenI, {Color = offStroke, Transparency = 0.3}):Play()
                    TweenService:Create(CheckIcon, tweenI, {ImageTransparency = 1}):Play()
                end
                if not silent and cb then
                    pcall(cb, checked)
                end
            end

            TrackConn(HitArea.MouseButton1Click:Connect(function()
                SetChecked(not isChecked)
            end))

            local checkboxObj = {
                Name       = text,
                SaveKey    = saveKey,
                Identifier = identifier,
                Frame      = CardFrame,
                BoxOuter   = BoxOuter,
                CheckIcon  = CheckIcon,
                Value      = isChecked,
                RefreshTheme = function(theme, animated)
                    if not theme or type(theme) ~= "table" then return end
                    local inSec = IsInsideSection(CardFrame)
                    CardFrame.BackgroundColor3 = theme.CardBG
                    CardFrame.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                    LabelText.TextColor3 = theme.Text
                    offBG     = GetThemedDarkColor(theme)
                    offStroke = theme.Divider or Color3.fromRGB(80,85,100)
                    local targetBG = isChecked and theme.ButtonBG or offBG
                    local targetStroke = isChecked and theme.ButtonBG or offStroke
                    local targetCheckColor = GetOnAccent(theme.ButtonBG)

                    if animated then
                        local tw = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                        TweenService:Create(BoxOuter, tw, {BackgroundColor3 = targetBG}):Play()
                        TweenService:Create(BoxStroke, tw, {Color = targetStroke}):Play()
                        TweenService:Create(CheckIcon, tw, {ImageColor3 = targetCheckColor}):Play()
                    else
                        BoxOuter.BackgroundColor3 = targetBG
                        BoxStroke.Color = targetStroke
                        CheckIcon.ImageColor3 = targetCheckColor
                    end
                end,
            }

            local function ApplyCheckboxState(selfOrVal, maybeVal, maybeTrigger)
                local val, trigger
                if type(selfOrVal) == "table" or selfOrVal == checkboxObj then
                    val = maybeVal
                    trigger = (maybeTrigger ~= false)
                else
                    val = selfOrVal
                    trigger = (maybeVal ~= false)
                end
                val = (val == true)
                local silent = not trigger
                SetChecked(val, silent)
                checkboxObj.Value = val
            end

            checkboxObj.SetState = ApplyCheckboxState
            checkboxObj.SetValue = ApplyCheckboxState
            checkboxObj.GetState = function() return isChecked end
            checkboxObj.GetValue = function() return isChecked end
            checkboxObj.Toggle   = function() ApplyCheckboxState(not isChecked, true) end
            checkboxObj.SetTitle = function(selfOrTitle, maybeTitle)
                local newT = (maybeTitle ~= nil) and maybeTitle or selfOrTitle
                if type(newT) == "table" then
                    newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Title or newT.Name or newT.Text or newT[1] or ""
                end
                LabelText.Text = tostring(newT or "")
                return checkboxObj
            end
            checkboxObj.SetText  = checkboxObj.SetTitle

            Window.RegisteredToggles = Window.RegisteredToggles or {}
            Window.RegisteredMDToggles = Window.RegisteredMDToggles or {}

            Window.RegisteredToggles[text] = checkboxObj
            if saveKey and not Window.RegisteredToggles[saveKey] then
                Window.RegisteredToggles[saveKey] = checkboxObj
            end
            if identifier and not Window.RegisteredToggles[identifier] then
                Window.RegisteredToggles[identifier] = checkboxObj
            end

            table.insert(Window.RegisteredMDToggles, checkboxObj)

            table.insert(Window.SearchableItems, {
                Type = "Checkbox",
                Name = text or "Checkbox",
                Desc = "",
                TabName = tabName,
                Instance = CardFrame
            })

            if Window.RegisterLocalizedElement then
                Window:RegisterLocalizedElement(checkboxObj, text, function(newText)
                    checkboxObj:SetTitle(newText)
                end)
            end

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return checkboxObj
        end


        function TabObj:AddMobileButton(arg1, arg2, arg3, arg4, arg5)
            return Window:CreateMobileButton(arg1, arg2, arg3, arg4, arg5)
        end
        TabObj.CreateMobileButton = TabObj.AddMobileButton


        function TabObj:AddToggleGroup(toggleList, parentRow)
            if type(toggleList) ~= "table" then return {} end
            local count = #toggleList
            if count == 0 then return {} end

            local targetParent = ResolveParent(parentRow) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame)

            local GroupFrame = Instance.new("Frame")
            GroupFrame.Name = "ToggleGroup"
            GroupFrame.Size = isInside and UDim2.new(1, 0, 0, 0) or UDim2.new(1, -10, 0, 0)
            GroupFrame.AutomaticSize = Enum.AutomaticSize.Y
            GroupFrame.BackgroundTransparency = 1
            GroupFrame.BorderSizePixel = 0
            GroupFrame.ZIndex = 10
            GroupFrame.Parent = targetParent

            if count > 1 then
                local GroupCorner = Instance.new("UICorner")
                GroupCorner.CornerRadius = UDim.new(0, 12)
                GroupCorner.Parent = GroupFrame
                AddUIShadow(GroupFrame, 20, 0.5)
            end

            local GroupLayout = Instance.new("UIListLayout")
            GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
            GroupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            GroupLayout.Padding = UDim.new(0, 0)
            GroupLayout.Parent = GroupFrame

            local results = {}
            for i, item in ipairs(toggleList) do
                local config
                if type(item) == "table" and not item.IsA then
                    config = item
                else
                    config = { Name = tostring(item) }
                end
                local connectMode
                if count == 1 then
                    connectMode = nil
                elseif i == 1 then
                    connectMode = "Top"
                elseif i == count then
                    connectMode = "Bottom"
                else
                    connectMode = "Middle"
                end
                config.Connect = config.Connect or connectMode
                config.Parent = GroupFrame
                local toggle = TabObj:AddToggle(config)
                table.insert(results, toggle)
            end
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return results
        end

        function TabObj:AddGroup(itemList, direction, parentRow)
            if type(itemList) ~= "table" then return {} end
            local count = #itemList
            if count == 0 then return {} end

            direction = direction or "Vertical"
            local isHorizontal = (direction == "Horizontal" or direction == "horizontal" or direction == "H" or direction == "h")

            local targetParent = ResolveParent(parentRow) or TabObj.CurrentSectionContainer or ContentFrame
            local isInside = (targetParent ~= ContentFrame)

            local GroupFrame = Instance.new("Frame")
            GroupFrame.Name = isHorizontal and "HorizontalGroup" or "VerticalGroup"
            GroupFrame.Size = isInside and UDim2.new(1, 0, 0, 0) or UDim2.new(1, -10, 0, 0)
            GroupFrame.AutomaticSize = Enum.AutomaticSize.Y
            GroupFrame.BackgroundTransparency = 1
            GroupFrame.BorderSizePixel = 0
            GroupFrame.ZIndex = 10
            GroupFrame.Parent = targetParent

            if count > 1 then
                local GroupCorner = Instance.new("UICorner")
                GroupCorner.CornerRadius = UDim.new(0, 12)
                GroupCorner.Parent = GroupFrame
                AddUIShadow(GroupFrame, 20, 0.5)
            end

            local GroupLayout
            if isHorizontal then
                GroupLayout = Instance.new("UIListLayout")
                GroupLayout.FillDirection = Enum.FillDirection.Horizontal
                GroupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
                GroupLayout.Padding = UDim.new(0, 0)
            else
                GroupLayout = Instance.new("UIListLayout")
                GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
                GroupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                GroupLayout.Padding = UDim.new(0, 0)
            end
            GroupLayout.Parent = GroupFrame

            local results = {}
            for i, item in ipairs(itemList) do
                if type(item) ~= "table" or item.IsA then
                    item = { Name = tostring(item), Type = "Toggle" }
                end

                local itemType = item.Type
                if not itemType then
                    if item.Options or item.Values or item.options or item.values or item.List then
                        itemType = "Dropdown"
                    elseif item.Color or (item.Default and typeof(item.Default) == "Color3") then
                        itemType = "ColorPicker"
                    elseif item.Min or item.Max then
                        itemType = "Slider"
                    elseif item.Placeholder then
                        itemType = "Input"
                    else
                        itemType = "Toggle"
                    end
                end

                local connectMode

                if count == 1 then
                    connectMode = nil
                elseif isHorizontal then
                    if i == 1 then
                        connectMode = "Left"
                    elseif i == count then
                        connectMode = "Right"
                    else
                        connectMode = "Middle"
                    end
                else
                    if i == 1 then
                        connectMode = "Top"
                    elseif i == count then
                        connectMode = "Bottom"
                    else
                        connectMode = "Middle"
                    end
                end

                item.Connect = item.Connect or connectMode
                item.Parent = GroupFrame

                if isHorizontal then
                    item.Size = item.Size or (1.0 / count)
                end

                local itLower = string.lower(tostring(itemType or ""))
                local resultItem
                if itLower == "toggle" then
                    resultItem = TabObj:AddToggle(item)
                elseif itLower == "button" then
                    resultItem = TabObj:AddButton(item)
                elseif itLower == "card" then
                    resultItem = TabObj:AddCard(item)
                elseif itLower == "slider" then
                    resultItem = TabObj:AddSlider(item)
                elseif itLower == "dropdown" then
                    resultItem = TabObj:AddDropdown(item)
                elseif itLower == "colorpicker" or itLower == "color" then
                    resultItem = TabObj:AddColorPicker(item)
                elseif itLower == "input" or itLower == "textbox" then
                    resultItem = TabObj:AddTextbox(item)
                end

                if resultItem then
                    table.insert(results, resultItem)
                end
            end

            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return results
        end


        function TabObj:AddToggleSlider(config)
            if type(config) ~= "table" then return end
            local toggle = TabObj:AddToggle({
                Name = config.Name or config.Title or "Toggle",
                Default = config.Default or config.ToggleDefault or false,
                Callback = config.Callback or config.ToggleCallback,
                Bind = config.Bind or config.Keybind or config.DefaultBind,
                Connect = config.Connect
            })
            local slider = toggle:AddSlider(config.Slider or config)
            return toggle, slider
        end

        function TabObj:AddHalfToggle(text, initialState, onToggle, parentRow, position)
            return TabObj:AddToggle(text, initialState, onToggle, parentRow, position)
        end

        function TabObj:AddSlider(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
            local targetParent = TabObj.CurrentSectionContainer or ContentFrame
            local pos = UDim2.new(0, 0, 0, 0)
            local sliderName = nil
            local minVal, maxVal, defaultVal, onValueChange, sliderOptions
            local customParent = false

            if type(arg1) == "string" then
                sliderName = arg1
                if type(arg2) == "table" then
                    minVal = arg2.Min or arg2.min or 0
                    maxVal = arg2.Max or arg2.max or 100
                    defaultVal = arg2.Default or arg2.default or minVal
                    onValueChange = arg2.Callback or arg2.callback or arg2.OnChanged
                    sliderOptions = arg2
                    if arg3 then targetParent = arg3 customParent = true end
                    pos = arg4 or pos
                else
                    minVal = arg2 or 0
                    maxVal = arg3 or 100
                    defaultVal = arg4 or minVal
                    onValueChange = arg5
                    sliderOptions = arg6
                    if typeof(arg6) == "Instance" then targetParent = arg6 customParent = true
                    elseif typeof(arg7) == "Instance" then targetParent = arg7 customParent = true end
                    pos = (typeof(arg7) == "UDim2" and arg7) or pos
                end
            elseif type(arg1) == "table" then
                sliderName = arg1.SaveKey or arg1.saveKey or arg1.Id or arg1.id or arg1.Identifier or arg1.identifier or arg1.Title or arg1.Name or arg1.Text
                minVal = arg1.Min or arg1.min or 0
                maxVal = arg1.Max or arg1.max or 100
                defaultVal = arg1.Default or arg1.default or minVal
                onValueChange = arg1.Callback or arg1.callback or arg1.OnChanged
                sliderOptions = arg1
                if arg2 then
                    targetParent = arg2
                    customParent = true
                elseif arg1.Parent or arg1.Row or arg1.parentRow then
                    targetParent = arg1.Parent or arg1.Row or arg1.parentRow
                    customParent = true
                end
                pos = arg3 or pos
            else
                minVal = arg1 or 0
                maxVal = arg2 or 100
                defaultVal = arg3 or minVal
                onValueChange = arg4
                sliderOptions = arg5
                if typeof(arg5) == "Instance" then targetParent = arg5 customParent = true
                elseif typeof(arg6) == "Instance" then targetParent = arg6 customParent = true end
                pos = (typeof(arg6) == "UDim2" and arg6) or (typeof(arg7) == "UDim2" and arg7) or pos
            end

            targetParent = ResolveParent(targetParent) or TabObj.CurrentSectionContainer or ContentFrame
            local suffix = (type(sliderOptions) == "table" and (sliderOptions.Suffix or (sliderOptions.ValueFormat == "percent" and "%") or ""))
                or (type(sliderOptions) == "string" and sliderOptions)
                or ""
            local isRow = targetParent and (targetParent.Name == "RowFrame" or targetParent.Name == "HorizontalGroup")
            local isGroup = targetParent and (targetParent.Name == "ToggleGroup" or targetParent.Name == "VerticalGroup" or targetParent.Name == "HorizontalGroup")
            local isCard = not customParent or targetParent == ContentFrame or (targetParent and (targetParent.Name == "RowFrame" or isGroup))

            if isCard and (type(sliderOptions) ~= "table" or sliderOptions.AsCard ~= false) then
                local isInSection = (customParent and targetParent ~= ContentFrame) or (targetParent == TabObj.CurrentSectionContainer) or IsInsideSection(targetParent)
                local sliderH = isGroup and (isInSection and 48 or 58) or (isInSection and 54 or 64)
                local cardSize = isGroup and UDim2.new(1, 0, 0, sliderH) or (isRow and UDim2.new(0.485, -4, 0, sliderH) or UDim2.new(1, -10, 0, sliderH))

                local SliderCard = Instance.new("Frame")
                SliderCard.Name = (sliderName or "Slider") .. "_Card"
                SliderCard:SetAttribute("MDCard", true)
                SliderCard.Size = cardSize
                SliderCard.Position = pos
                SliderCard.BackgroundColor3 = Window.CurrentTheme.CardBG
                SliderCard.BackgroundTransparency = (isInSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                SliderCard.BorderSizePixel = 0
                SliderCard.ZIndex = 10
                SliderCard.Parent = targetParent

                local connectMode = type(sliderOptions) == "table" and (sliderOptions.Connect or sliderOptions.Connected or sliderOptions.connectMode or sliderOptions.PositionInGroup)
                local CardCorner = Instance.new("UICorner")
                if connectMode == "Top" or connectMode == "First" then
                    ApplyCornerRadii(CardCorner, 12, 12, 0, 0)
                elseif connectMode == "Middle" then
                    ApplyCornerRadii(CardCorner, 0, 0, 0, 0)
                elseif connectMode == "Bottom" or connectMode == "Last" then
                    ApplyCornerRadii(CardCorner, 0, 0, 12, 12)
                elseif connectMode == "Left" then
                    ApplyCornerRadii(CardCorner, 12, 0, 0, 12)
                elseif connectMode == "Right" then
                    ApplyCornerRadii(CardCorner, 0, 12, 12, 0)
                else
                    CardCorner.CornerRadius = UDim.new(0, 12)
                end
                CardCorner.Parent = SliderCard

                if not connectMode then
                    local shadow = AddUIShadow(SliderCard, 20, 0.5)
                    if isInSection and Window.SectionsTransparent and shadow then
                        pcall(function() shadow.Visible = false end)
                    end
                end

                TrackConn(SliderCard.MouseEnter:Connect(function()
                    if not (isInSection and Window.SectionsTransparent) then
                        TweenService:Create(SliderCard, TweenInfo.new(0.2), {
                            BackgroundTransparency = math.max(0, (Window.ElementsTransparency or 0.33) - 0.12)
                        }):Play()
                    end
                end))

                TrackConn(SliderCard.MouseLeave:Connect(function()
                    if not (isInSection and Window.SectionsTransparent) then
                        TweenService:Create(SliderCard, TweenInfo.new(0.2), {
                            BackgroundTransparency = (isInSection and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                        }):Play()
                    end
                end))

                local displayTitle = (type(sliderOptions) == "table" and (sliderOptions.Title or sliderOptions.Text or sliderOptions.Name))
                    or (type(arg1) == "string" and (type(arg2) ~= "table" or not (arg2.Title or arg2.Text or arg2.Name)) and arg1)
                    or (type(arg1) == "table" and (arg1.Title or arg1.Text or arg1.Name))
                    or sliderName
                    or "Slider"

                local titleY = isGroup and (isInSection and 6 or 8) or (isInSection and 7 or 10)
                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Name = "SliderTitle"
                TitleLabel.Size = UDim2.new(1, -115, 0, 20)
                TitleLabel.Position = UDim2.new(0, 14, 0, titleY)
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.FontFace = FontFingerPaintRegular
                TitleLabel.Text = displayTitle
                TitleLabel.TextColor3 = Window.CurrentTheme.Text
                TitleLabel.TextSize = 14
                TitleLabel.TextWrapped = true
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
                TitleLabel.ZIndex = 11
                TitleLabel.Parent = SliderCard

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "ValueLabel"
                ValueLabel.Size = UDim2.new(0, 100, 0, 20)
                ValueLabel.Position = UDim2.new(1, -14, 0, titleY)
                ValueLabel.AnchorPoint = Vector2.new(1, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.FontFace = FontFingerPaintRegular
                ValueLabel.TextColor3 = Window.CurrentTheme.Text
                ValueLabel.TextSize = 13
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.TextYAlignment = Enum.TextYAlignment.Center
                ValueLabel.ZIndex = 11
                ValueLabel.Parent = SliderCard

                local effectiveOpts = {}
                if type(sliderOptions) == "table" then
                    for k, v in pairs(sliderOptions) do
                        effectiveOpts[k] = v
                    end
                elseif type(sliderOptions) == "string" then
                    effectiveOpts.Suffix = sliderOptions
                elseif type(sliderOptions) == "number" then
                    effectiveOpts.Increment = sliderOptions
                end
                effectiveOpts.ShowValue = false
                if isInSection then
                    effectiveOpts.KnobSize = 18
                end

                local userCallback = onValueChange
                local userOnRelease = type(sliderOptions) == "table" and (sliderOptions.OnRelease or sliderOptions.onRelease or sliderOptions.ReleaseCallback or sliderOptions.releaseCallback)
                local isTriggerOnRelease = type(sliderOptions) == "table" and (sliderOptions.TriggerOnRelease == true or sliderOptions.OnlyOnRelease == true)

                if isTriggerOnRelease and not userOnRelease and userCallback then
                    effectiveOpts.OnRelease = userCallback
                elseif userOnRelease then
                    effectiveOpts.OnRelease = userOnRelease
                end
                effectiveOpts.TriggerOnRelease = false

                local trackY = isGroup and (isInSection and 28 or 36) or (isInSection and 32 or 40)
                local trackH = isInSection and 10 or 12
                local trackPadX = isInSection and 26 or 28
                local sliderData
                sliderData = Window:CreateMDSlider(SliderCard, UDim2.new(0, 14, 0, trackY), UDim2.new(1, -trackPadX, 0, trackH), minVal, maxVal, defaultVal, function(val, pct)
                    ValueLabel.Text = sliderData and sliderData.GetFormattedValue(val, pct) or (tostring(val) .. suffix)
                    if userCallback and not isTriggerOnRelease then
                        pcall(userCallback, val, pct)
                    end
                end, sliderName, effectiveOpts)

                ValueLabel.Text = sliderData.GetFormattedValue(sliderData.GetValue())

                local effectiveSaveKey = (type(sliderOptions) == "table" and (sliderOptions.SaveKey or sliderOptions.saveKey or sliderOptions.Id or sliderOptions.id or sliderOptions.Identifier or sliderOptions.identifier)) or sliderName
                sliderData.SaveKey = effectiveSaveKey
                sliderData.Name = effectiveSaveKey
                if effectiveSaveKey and effectiveSaveKey ~= "" then
                    Window.RegisteredSliders[effectiveSaveKey] = sliderData
                end
                if type(sliderOptions) == "table" and sliderOptions.Title and sliderOptions.Title ~= "" and not Window.RegisteredSliders[sliderOptions.Title] then
                    Window.RegisteredSliders[sliderOptions.Title] = sliderData
                end

                sliderData.CardFrame = SliderCard
                sliderData.TitleLabel = TitleLabel
                sliderData.ValueLabel = ValueLabel

                local oldSetSuffix = sliderData.SetSuffix
                sliderData.SetSuffix = function(newSuffix)
                    if oldSetSuffix then oldSetSuffix(newSuffix) end
                    ValueLabel.Text = sliderData.GetFormattedValue()
                end

                local oldSetPrefix = sliderData.SetPrefix
                sliderData.SetPrefix = function(newPrefix)
                    if oldSetPrefix then oldSetPrefix(newPrefix) end
                    ValueLabel.Text = sliderData.GetFormattedValue()
                end

                local oldSetValueFormat = sliderData.SetValueFormat
                sliderData.SetValueFormat = function(format, newSuffix, newPrefix)
                    if oldSetValueFormat then oldSetValueFormat(format, newSuffix, newPrefix) end
                    ValueLabel.Text = sliderData.GetFormattedValue()
                end

                local oldSetValue = sliderData.SetValue
                sliderData.SetValue = function(selfOrVal, maybeVal, maybeTrigger)
                    if oldSetValue then oldSetValue(selfOrVal, maybeVal, maybeTrigger) end
                    ValueLabel.Text = sliderData.GetFormattedValue()
                end

                local oldSetIncrement = sliderData.SetIncrement
                sliderData.SetIncrement = function(newInc, newPrec)
                    if oldSetIncrement then oldSetIncrement(newInc, newPrec) end
                    ValueLabel.Text = sliderData.GetFormattedValue()
                end

                local oldRefresh = sliderData.RefreshTheme
                sliderData.RefreshTheme = function(theme)
                    if oldRefresh then oldRefresh(theme) end
                    local inSec = IsInsideSection(SliderCard)
                    SliderCard.BackgroundColor3 = theme.CardBG
                    SliderCard.BackgroundTransparency = (inSec and Window.SectionsTransparent) and 1 or (Window.ElementsTransparency or 0.33)
                    TitleLabel.TextColor3 = theme.Text
                    ValueLabel.TextColor3 = theme.Text
                end

                ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
                table.insert(Window.SearchableItems, {
                    Type = "Slider",
                    Name = displayTitle,
                    Id = effectiveSaveKey or sliderName,
                    Desc = "",
                    TabName = tabName,
                    Instance = SliderCard
                })
                sliderData.CardFrame = SliderCard
                sliderData.Frame = SliderCard
                sliderData.SetTitle = function(selfOrTitle, maybeTitle)
                    local newT = (maybeTitle ~= nil) and maybeTitle or selfOrTitle
                    if type(newT) == "table" then
                        newT = newT[Window.CurrentLanguage or "English"] or newT["English"] or newT.Title or newT.Name or newT.Text or newT[1] or ""
                    end
                    TitleLabel.Text = tostring(newT or "")
                    return sliderData
                end
                sliderData.SetText = sliderData.SetTitle

                if Window.RegisterLocalizedElement then
                    Window:RegisterLocalizedElement(sliderData, displayTitle, function(newText)
                        sliderData:SetTitle(newText)
                    end)
                end

                return sliderData
            else
                local size = (targetParent and targetParent.Name == "RowFrame") and UDim2.new(0.485, -4, 0, 14) or UDim2.new(1, -10, 0, 14)
                local sliderData = Window:CreateMDSlider(targetParent, pos, size, minVal, maxVal, defaultVal, onValueChange, sliderName, sliderOptions)
                ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

                local nonCardTitle = (type(sliderOptions) == "table" and (sliderOptions.Title or sliderOptions.Text or sliderOptions.Name))
                    or (type(arg1) == "string" and (type(arg2) ~= "table" or not (arg2.Title or arg2.Text or arg2.Name)) and arg1)
                    or (type(arg1) == "table" and (arg1.Title or arg1.Text or arg1.Name))
                    or sliderName
                    or "Slider"
                local nonCardSaveKey = (type(sliderOptions) == "table" and (sliderOptions.SaveKey or sliderOptions.saveKey or sliderOptions.Id or sliderOptions.id or sliderOptions.Identifier or sliderOptions.identifier)) or sliderName

                table.insert(Window.SearchableItems, {
                    Type = "Slider",
                    Name = nonCardTitle,
                    Id = nonCardSaveKey,
                    Desc = "",
                    TabName = tabName,
                    Instance = sliderData.Track
                })

                if Window.RegisterLocalizedElement and (sliderData.TitleLabel or sliderData.TitleText or sliderData.SetTitle) then
                    Window:RegisterLocalizedElement(sliderData, nonCardTitle, function(newText)
                        if sliderData.SetTitle then
                            sliderData:SetTitle(newText)
                        elseif sliderData.TitleLabel then
                            sliderData.TitleLabel.Text = tostring(newText)
                        end
                    end)
                end

                return sliderData
            end
        end

        TrackConn(TabButton.MouseEnter:Connect(function()
            PlayHoverSFX()
            if Window.ActiveTab ~= tabName then
                TweenService:Create(HoverGlow, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0
                }):Play()
                TweenService:Create(TabButton, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    TextColor3 = Window.CurrentTheme.Text
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        ImageColor3 = Window.CurrentTheme.Text
                    }):Play()
                end
            end
        end))

        TrackConn(TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tabName then
                TweenService:Create(HoverGlow, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
                TweenService:Create(TabButton, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    TextColor3 = Window.CurrentTheme.SubText
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        ImageColor3 = Window.CurrentTheme.SubText
                    }):Play()
                end
            end
        end))

        TrackConn(TabButton.MouseButton1Click:Connect(function()
            PlayClickSFX()
            SwitchTab(tabName)
        end))

        Window.Tabs[tabName] = TabObj
        if not Window.ActiveTab or (Window.ActiveTab == "Settings" and tabName ~= "Settings") then
            if Window.ActiveTab and Window.ActiveTab ~= tabName then
                local oldTabData = Window.Tabs[Window.ActiveTab]
                if oldTabData then
                    oldTabData.Button.TextColor3 = Window.CurrentTheme.SubText
                    oldTabData.Button.TextSize = 15
                    oldTabData.Button.FontFace = FontTabBtn
                    if oldTabData.HoverGlow then
                        oldTabData.HoverGlow.BackgroundTransparency = 1
                    end
                    local oldTarget = oldTabData.TabGroup or oldTabData.ContentFrame
                    if oldTarget then
                        oldTarget.Visible = false
                    end
                    if oldTabData.SubTabBar then
                        oldTabData.SubTabBar.Visible = false
                    end
                end
            end
            Window.ActiveTab = tabName
            -- Show first active tab with a gentle fade-in from slightly below
            local initTargetY = TabObj.HasSubTabs and 34 or 0
            ContentFrame.Position = UDim2.new(0, 0, 0, initTargetY + 8)
            ContentFrame.Visible = true
            TweenService:Create(ContentFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, initTargetY)
            }):Play()
            TabButton.TextColor3 = Window.CurrentTheme.Text
            TabButton.TextSize = 16
            TabButton.FontFace = FontFingerPaintBold
            HoverGlow.BackgroundTransparency = 1
            task.defer(function()
                if Window.UpdateActiveTabIndicator then
                    Window.UpdateActiveTabIndicator(true)
                end
            end)
        else
            ContentFrame.Visible = false
            ContentFrame.Position = UDim2.new(0, 0, 0, 0)
            TabButton.TextColor3 = Window.CurrentTheme.SubText
            TabButton.TextSize = 15
            TabButton.FontFace = FontTabBtn
            HoverGlow.BackgroundTransparency = 1
        end

        if Window.RegisterLocalizedElement then
            Window:RegisterLocalizedElement(TabObj, tabName, function(newText)
                if type(newText) == "table" then
                    newText = newText[Window.CurrentLanguage or "English"] or newText["English"] or newText[1] or ""
                end
                local sText = tostring(newText or "")
                TabObj.DisplayName = sText
                if not Window.SidebarCollapsed then
                    TabButton.Text = sText
                elseif not TabIcon then
                    TabButton.Text = (string.len(sText) > 4) and (string.sub(sText, 1, 4) .. ".") or sText
                end
            end)
        end

        return TabObj
    end

    -- Default built-in settings tab builder
    local function CreateDefaultSettingsTab()
        local SettingsTab = Window:CreateTab("Settings", 999, "settings")

        if Window.LanguageSelectorEnabled and Window.Languages and #Window.Languages > 1 then
            local langSection = SettingsTab:AddSection("Language", true)
            local langDrop = SettingsTab:AddDropdown({
                Title = "Interface language",
                Options = Window.Languages,
                Default = Window.CurrentLanguage or Window.Languages[1] or "English",
                Callback = function(selectedLang)
                    Window:SetLanguage(selectedLang)
                end
            })
            Window.LanguageDropdown = langDrop
            Window.LanguageDropdowns = Window.LanguageDropdowns or {}
            table.insert(Window.LanguageDropdowns, langDrop)
        end

        local audioSection = SettingsTab:AddSection("Audio & Notifications")
        local audioToggles = SettingsTab:AddToggleGroup({
            {
                Title = "Enable notifications",
                Default = Window.NotificationsEnabled,
                Callback = function(state)
                    Window.NotificationsEnabled = state
                    if state then Window:Notify("Settings", "Notifications enabled", 2) end
                end
            },
            {
                Title = "Enable UI sounds",
                Default = Window.UISoundsEnabled,
                Callback = function(state)
                    Window:SetUISounds(state)
                    if state then Window:Notify("Settings", "UI sounds enabled", 2) end
                end
            }
        })
        Window.RegisteredToggles["Notifications"] = audioToggles[1]
        Window.RegisteredToggles["UISounds"]       = audioToggles[2]

        local volSlider = SettingsTab:AddSlider({
            Title = "UI sound volume",
            Min = 0,
            Max = 100,
            Default = math.floor((Window.SoundVolume or 0.8) * 100),
            Suffix = "%",
            Callback = function(val, pct) Window:SetSoundVolume(pct) end
        })
        Window.RegisteredSliders["SoundVolume"] = volSlider

        local hoverSoundBox = SettingsTab:AddTextbox({
            Title = "Hover sound ID",
            Placeholder = "88894490577328",
            Default = Window.HoverSoundId or "88894490577328",
            Callback = function(val)
                Window:SetHoverSound(val)
            end
        })
        Window.RegisteredTextboxes["HoverSound"] = hoverSoundBox

        local clickSoundBox = SettingsTab:AddTextbox({
            Title = "Click sound ID",
            Placeholder = "86313632275410",
            Default = Window.ClickSoundId or "86313632275410",
            Callback = function(val)
                Window:SetClickSound(val)
            end
        })
        Window.RegisteredTextboxes["ClickSound"] = clickSoundBox

        local notifSoundBox = SettingsTab:AddTextbox({
            Title = "Notification sound ID",
            Placeholder = "97455084935031",
            Default = Window.NotifSoundId or "97455084935031",
            Callback = function(val)
                Window:SetNotificationSound(val)
            end
        })
        Window.RegisteredTextboxes["NotifSound"] = notifSoundBox

        local visualSection = SettingsTab:AddSection("Appearance & Visuals")
        local bgToggles = SettingsTab:AddToggleGroup({
            {
                Title = "Spiderweb background",
                Default = Window.SpiderwebBGEnabled,
                Callback = function(state)
                    Window:SetSpiderwebBackground(state)
                    Window:Notify("Settings", "Spiderweb background " .. (state and "enabled" or "disabled"), 2)
                end
            },
            {
                Title = "Background blur",
                Default = Window.BackgroundBlurEnabled,
                Callback = function(state)
                    Window:SetBackgroundBlur(state)
                    Window:Notify("Settings", "Background blur " .. (state and "enabled" or "disabled"), 2)
                end
            },
            {
                Title = "UI shadows",
                Default = Window.ShadowsEnabled,
                Callback = function(state)
                    Window:SetShadowsEnabled(state)
                    Window:Notify("Settings", "UI shadows " .. (state and "enabled" or "disabled"), 2)
                end
            },
            {
                Title = "Section backgrounds",
                Default = not Window.SectionsTransparent,
                Callback = function(state)
                    Window:SetSectionBGTransparent(not state)
                    Window:Notify("Settings", "Section backgrounds " .. (state and "shown" or "hidden"), 2)
                end
            },
            {
                Title = "Background noise",
                Default = Window.NoiseEnabled,
                Callback = function(state)
                    Window:SetNoiseEnabled(state)
                    Window:Notify("Settings", "Background noise " .. (state and "enabled" or "disabled"), 2)
                end
            },
            {
                Title = "Streamer mode",
                Default = Window.StreamerMode,
                Callback = function(state)
                    Window:SetStreamerMode(state)
                    Window:Notify("Settings", "Streamer mode " .. (state and "enabled" or "disabled"), 2)
                end
            }
        })
        Window.RegisteredToggles["SpiderwebBG"]           = bgToggles[1]
        Window.RegisteredToggles["BackgroundBlur"]        = bgToggles[2]
        Window.RegisteredToggles["Shadows"]               = bgToggles[3]
        Window.RegisteredToggles["SectionBGTransparent"]  = bgToggles[4]
        Window.RegisteredToggles["BackgroundNoise"]       = bgToggles[5]
        Window.RegisteredToggles["StreamerMode"]          = bgToggles[6]

        local noiseSizeSlider = SettingsTab:AddSlider({
            Title = "Noise tile size",
            Min = 32,
            Max = 512,
            Default = Window.NoiseSize or 128,
            Suffix = "px",
            Callback = function(val)
                Window:SetNoiseSize(val)
            end
        })
        Window.RegisteredSliders["NoiseSize"] = noiseSizeSlider

        local transSlider = SettingsTab:AddSlider({
            Title = "Background transparency",
            Min = 0,
            Max = 90,
            Default = math.floor((Window.CustomBGTransparency or 0.12) * 100),
            Suffix = "%",
            Callback = function(val, pct) Window:SetBackgroundTransparency(val / 100) end
        })
        Window.RegisteredSliders["BGTransparency"] = transSlider

        local elemTransSlider = SettingsTab:AddSlider({
            Title = "UI elements transparency",
            Min = 0,
            Max = 90,
            Default = math.floor((Window.ElementsTransparency or 0.33) * 100),
            Suffix = "%",
            Callback = function(val, pct) Window:SetElementsTransparency(val / 100) end
        })
        Window.RegisteredSliders["ElementsTransparency"] = elemTransSlider

        local topBottomTransSlider = SettingsTab:AddSlider({
            Title = "Top, left & bottom frames transparency",
            Min = 0,
            Max = 90,
            Default = math.floor((Window.TopBottomTransparency or (Window.CurrentTheme and Window.CurrentTheme.TopTrans) or 0.12) * 100),
            Suffix = "%",
            Callback = function(val, pct) Window:SetTopBottomTransparency(val / 100) end
        })
        Window.RegisteredSliders["TopBottomTransparency"] = topBottomTransSlider

        local blurIntensitySlider = SettingsTab:AddSlider({
            Title = "Blur intensity",
            Min = 0,
            Max = 100,
            Default = math.floor((Window.BlurIntensity or 0.5) * 100),
            Suffix = "%",
            Callback = function(val, pct) Window:SetBlurIntensity(val / 100) end
        })
        Window.RegisteredSliders["BlurIntensity"] = blurIntensitySlider

        local shadowIntensitySlider = SettingsTab:AddSlider({
            Title = "Shadow intensity",
            Min = 0,
            Max = 100,
            Default = math.floor((Window.ShadowIntensity or (1 / 1.8)) * 100),
            Suffix = "%",
            TriggerOnRelease = true,
            OnRelease = function(val, pct)
                Window:SetShadowIntensity(val)
            end,
            Callback = function(val, pct)
                Window:SetShadowIntensity(val)
            end
        })
        Window.RegisteredSliders["ShadowIntensity"] = shadowIntensitySlider

        local clickSection = SettingsTab:AddSection("Click Effects & Particles")
        local clickToggle = SettingsTab:AddToggle({
            Title = "Enable click effects",
            Default = Window.ClickEffectsEnabled,
            Callback = function(state)
                Window.ClickEffectsEnabled = state
                Window:Notify("Settings", "Click effects " .. (state and "enabled" or "disabled"), 2)
            end
        })
        Window.RegisteredToggles["ClickEffects"] = clickToggle

        local particleOptions = {"Theme default", "Leaves", "Gems", "Sparkles", "Rings", "Dots", "Custom image"}
        SettingsTab:AddDropdown({
            Title = "Particle style",
            Options = particleOptions,
            Default = Window.ClickParticleType or "Theme default",
            Callback = function(selected)
                Window.ClickParticleType = selected
                Window:Notify("Settings", "Particle style: " .. selected:lower(), 2)
            end
        })

        SettingsTab:AddTextbox({
            Title = "Custom image ID",
            Placeholder = "rbxassetid://...",
            Default = Window.CustomParticleAsset or "",
            Callback = function(entered)
                Window.CustomParticleAsset = entered
                if entered ~= "" then
                    Window:Notify("Settings", "Custom particle image updated", 2)
                end
            end
        })

        local themesSection = SettingsTab:AddSection("Themes", true)

        local SwatchContainer = Instance.new("Frame")
        SwatchContainer.Name = "SwatchContainer"
        SwatchContainer.Size = UDim2.new(1, -4, 0, 0)
        SwatchContainer.AutomaticSize = Enum.AutomaticSize.Y
        SwatchContainer.BackgroundTransparency = 1
        SwatchContainer.BorderSizePixel = 0
        SwatchContainer.ZIndex = 7
        SwatchContainer.Parent = themesSection.Container

        local SwatchGrid = Instance.new("UIGridLayout")
        SwatchGrid.Name = "SwatchGrid"
        SwatchGrid.CellSize = UDim2.new(0.315, 0, 0, 48)
        SwatchGrid.CellPadding = UDim2.new(0.027, 0, 0, 8)
        SwatchGrid.SortOrder = Enum.SortOrder.LayoutOrder
        SwatchGrid.Parent = SwatchContainer

        local ThemeSwatchMap = {}
        local orderedThemes = {
            "Dark", "VeryDark", "Midnight", "Nord", "AMOLED",
            "White", "Coffee",
            "Dracula", "Rose", "Mint", "Amethyst", "Blue", "Nature",
            "Custom"
        }

        local function BuildSwatchCard(themeKey, themeData, orderIndex)
            local card = Instance.new("Frame")
            card.Name = "Swatch_" .. themeKey
            card.Size = UDim2.new(1, 0, 1, 0)
            card.BackgroundColor3 = themeData.MainBG or Window.CurrentTheme.MainBG
            card.BackgroundTransparency = 0
            card.BorderSizePixel = 0
            card.ClipsDescendants = true
            card.LayoutOrder = orderIndex or 99
            card.ZIndex = 8
            card.Parent = SwatchContainer

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 8)
            cardCorner.Parent = card

            local cardScale = Instance.new("UIScale")
            cardScale.Scale = 1
            cardScale.Parent = card

            local isSelected = (Window.CurrentThemeKey == themeKey) or (themeKey == "Custom" and Window.IsCustomTheme)

            local stroke = Instance.new("UIStroke")
            stroke.Thickness = isSelected and 2 or 1
            stroke.Color = isSelected and Window.CurrentTheme.ButtonBG or (themeData.Divider or Window.CurrentTheme.Divider)
            stroke.Transparency = isSelected and 0 or 0.7
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            -- Dots preview: Dot1 (accent), Dot2 (button/accent), Dot3 (text)
            local dot1Color = (themeData.MinGradient and themeData.MinGradient[1]) or themeData.TopBG or themeData.ButtonBG
            local dot2Color = themeData.ButtonBG or Window.CurrentTheme.ButtonBG
            local dot3Color = themeData.Text or Window.CurrentTheme.Text

            local dotsRow = Instance.new("Frame")
            dotsRow.Name = "DotsRow"
            dotsRow.Size = UDim2.new(0, 32, 0, 7)
            dotsRow.Position = UDim2.new(0, 8, 0, 8)
            dotsRow.BackgroundTransparency = 1
            dotsRow.ZIndex = 9
            dotsRow.Parent = card

            local dot1 = Instance.new("Frame")
            dot1.Name = "Dot1"
            dot1.Size = UDim2.new(0, 7, 0, 7)
            dot1.Position = UDim2.new(0, 0, 0, 0)
            dot1.BackgroundColor3 = dot1Color
            dot1.BorderSizePixel = 0
            dot1.ZIndex = 9
            local d1Corner = Instance.new("UICorner")
            d1Corner.CornerRadius = UDim.new(1, 0)
            d1Corner.Parent = dot1
            dot1.Parent = dotsRow

            local dot2 = Instance.new("Frame")
            dot2.Name = "Dot2"
            dot2.Size = UDim2.new(0, 7, 0, 7)
            dot2.Position = UDim2.new(0, 11, 0, 0)
            dot2.BackgroundColor3 = dot2Color
            dot2.BorderSizePixel = 0
            dot2.ZIndex = 9
            local d2Corner = Instance.new("UICorner")
            d2Corner.CornerRadius = UDim.new(1, 0)
            d2Corner.Parent = dot2
            dot2.Parent = dotsRow

            local dot3 = Instance.new("Frame")
            dot3.Name = "Dot3"
            dot3.Size = UDim2.new(0, 7, 0, 7)
            dot3.Position = UDim2.new(0, 22, 0, 0)
            dot3.BackgroundColor3 = dot3Color
            dot3.BorderSizePixel = 0
            dot3.ZIndex = 9
            local d3Corner = Instance.new("UICorner")
            d3Corner.CornerRadius = UDim.new(1, 0)
            d3Corner.Parent = dot3
            dot3.Parent = dotsRow

            local checkIcon = Instance.new("ImageLabel")
            checkIcon.Name = "CheckIcon"
            checkIcon.Size = UDim2.new(0, 14, 0, 14)
            checkIcon.AnchorPoint = Vector2.new(1, 0)
            checkIcon.Position = UDim2.new(1, -7, 0, 5)
            checkIcon.BackgroundTransparency = 1
            checkIcon.Image = "rbxassetid://86817768619372"
            checkIcon.ImageColor3 = Window.CurrentTheme.ButtonBG
            checkIcon.Visible = isSelected
            checkIcon.ZIndex = 10
            checkIcon.Parent = card

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "ThemeName"
            nameLabel.Size = UDim2.new(1, -16, 0, 18)
            nameLabel.Position = UDim2.new(0, 8, 0, 23)
            nameLabel.BackgroundTransparency = 1
            nameLabel.FontFace = FontFingerPaintBold
            nameLabel.Text = themeData.Name or themeKey
            nameLabel.TextColor3 = themeData.Text or Window.CurrentTheme.Text
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.ZIndex = 9
            nameLabel.Parent = card

            local clickBtn = Instance.new("TextButton")
            clickBtn.Name = "Trigger"
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.ZIndex = 11
            clickBtn.Parent = card

            TrackConn(clickBtn.MouseEnter:Connect(function()
                PlayHoverSFX()
                local isCur = (Window.CurrentThemeKey == themeKey) or (themeKey == "Custom" and Window.IsCustomTheme)
                if not isCur then
                    TweenService:Create(stroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = 0.2,
                        Color = Window.CurrentTheme.ButtonBG
                    }):Play()
                    TweenService:Create(cardScale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Scale = 1.03
                    }):Play()
                end
            end))

            TrackConn(clickBtn.MouseLeave:Connect(function()
                local isCur = (Window.CurrentThemeKey == themeKey) or (themeKey == "Custom" and Window.IsCustomTheme)
                if not isCur then
                    local divColor = themeData.Divider or Window.CurrentTheme.Divider
                    TweenService:Create(stroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = 0.7,
                        Color = divColor
                    }):Play()
                    TweenService:Create(cardScale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Scale = 1.0
                    }):Play()
                end
            end))

            TrackConn(clickBtn.MouseButton1Click:Connect(function()
                PlayClickSFX()
                if themeKey == "Custom" then
                    Window:ApplyCustomTheme(Window.CustomThemeColor or Window.CurrentTheme.ButtonBG)
                else
                    Window:ApplyTheme(themeKey)
                end
            end))

            local swatchData = {
                Card = card,
                Stroke = stroke,
                CheckIcon = checkIcon,
                NameLabel = nameLabel,
                Dot1 = dot1,
                Dot2 = dot2,
                Dot3 = dot3,
                ThemeData = themeData
            }
            ThemeSwatchMap[themeKey] = swatchData
            return swatchData
        end

        for idx, key in ipairs(orderedThemes) do
            local tData = Library.ThemePresets[key]
            if not tData and key == "Custom" then
                tData = {
                    Name = "Custom",
                    MainBG = Color3.fromRGB(25, 27, 34),
                    TopBG = Color3.fromRGB(38, 41, 52),
                    CardBG = Color3.fromRGB(25, 27, 34),
                    ButtonBG = Window.CustomThemeColor or Window.CurrentTheme.ButtonBG,
                    Divider = Color3.fromRGB(65, 70, 88),
                    Text = Color3.fromRGB(240, 240, 245),
                    SubText = Color3.fromRGB(180, 185, 200),
                }
            end
            if tData then
                BuildSwatchCard(key, tData, idx)
            end
        end

        -- Support dynamically registered themes
        Window.CreateThemeSwatch = function(self, themeKey, themeData)
            if not ThemeSwatchMap[themeKey] then
                local swatch = BuildSwatchCard(themeKey, themeData, #orderedThemes + 1)
                Window:UpdateThemeSwatches()
                if SettingsTab and SettingsTab.ContentFrame and SettingsTab.Layout then
                    SettingsTab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, SettingsTab.Layout.AbsoluteContentSize.Y + 20)
                end
                return swatch
            end
        end

        Window.ThemeSwatchMap = ThemeSwatchMap
        Window.ThemePresetBtnMap = ThemeSwatchMap
        Window.ThemeContainer = SwatchContainer

        function Window:UpdateThemeSwatches()
            local curKey = Window.CurrentThemeKey or "Dark"
            for k, swatch in pairs(ThemeSwatchMap) do
                if swatch and swatch.Card and swatch.Stroke then
                    local isSelected = (curKey == k) or (k == "Custom" and Window.IsCustomTheme)
                    if isSelected then
                        swatch.Stroke.Thickness = 2
                        swatch.Stroke.Color = Window.CurrentTheme.ButtonBG
                        swatch.Stroke.Transparency = 0
                        if swatch.CheckIcon then
                            swatch.CheckIcon.Visible = true
                            swatch.CheckIcon.ImageColor3 = Window.CurrentTheme.ButtonBG
                        end
                        TweenService:Create(swatch.Card, TweenInfo.new(0.2), {Position = UDim2.new(0, 0, 0, 0)}):Play()
                    else
                        swatch.Stroke.Thickness = 1
                        swatch.Stroke.Color = (swatch.ThemeData and swatch.ThemeData.Divider) or Window.CurrentTheme.Divider
                        swatch.Stroke.Transparency = 0.7
                        if swatch.CheckIcon then
                            swatch.CheckIcon.Visible = false
                        end
                    end

                    if k == "Custom" then
                        local customCol = Window.CustomThemeColor or Window.CurrentTheme.ButtonBG
                        if swatch.Dot2 then swatch.Dot2.BackgroundColor3 = customCol end
                        if swatch.NameLabel then swatch.NameLabel.TextColor3 = Window.CurrentTheme.Text end
                    end
                end
            end
        end

        -- Custom color picker right under the swatch grid inside themesSection
        local customThemeCP = SettingsTab:AddColorPicker(
            "Custom theme color",
            Window.CustomThemeColor or Window.CurrentTheme.ButtonBG,
            function(newCol)
                Window:ApplyCustomTheme(newCol)
            end
        )
        Window.RegisteredColorPickers["CustomTheme"] = customThemeCP

        -- Reset current section container so ConfigSection sits cleanly on ContentFrame
        SettingsTab.CurrentSectionContainer = nil

        SettingsTab:CreateConfigSection()

        -- Reset current section container so CreditsSection sits cleanly on ContentFrame at the very bottom
        SettingsTab.CurrentSectionContainer = nil

        SettingsTab:CreateCreditsSection()

        SettingsTab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, SettingsTab.Layout.AbsoluteContentSize.Y + 20)
        Window.SettingsTab = SettingsTab
        return SettingsTab
    end

    CreateDefaultSettingsTab()

    -- Window resize handler
    local IsResizing, ResizeStartPos, StartWindowSize = false, nil, nil
    TrackConn(ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsResizing = true
            ResizeStartPos = input.Position
            StartWindowSize = MainContainer.Size
        end
    end))

    TrackConn(UserInputService.InputChanged:Connect(function(input)
        if IsResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local scale = (UIScaleConstraint and UIScaleConstraint.Scale) or 1
            if scale <= 0 then scale = 1 end
            local deltaX = (input.Position.X - ResizeStartPos.X) / scale
            local deltaY = (input.Position.Y - ResizeStartPos.Y) / scale
            local newWidth = math.clamp(StartWindowSize.X.Offset + deltaX, 500, 1000)
            local newHeight = math.clamp(StartWindowSize.Y.Offset + deltaY, 340, 700)
            MainContainer.Size = UDim2.new(0, newWidth, 0, newHeight)
            LastWindowSize = MainContainer.Size
        end
    end))

    TrackConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsResizing = false
        end
    end))

    -- Minimize and restore handler
    IsAnimatingMinimize = false
    local function MinimizeWindowAnimation()
        if IsAnimatingMinimize then return end
        if Window.ActiveDropdown then
            pcall(function() Window.ActiveDropdown.Close() end)
        end
        IsAnimatingMinimize = true
        PlayClickSFX()

        LocalUIBlurPart.Transparency = 1
        LocalUIBlurPart.CFrame = CFrame.new(0, 999999, 0)
        BackgroundDOF.Enabled = false

        LastWindowPos = MainContainer.Position
        local targetPos = MinimizedFrame.Position

        if Window.ActiveTabGlow then
            Window.ActiveTabGlow.Visible = false
        end

        MinimisedUI.Enabled = true
        TriggerCircleSpinBurst()
        MinimizedFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MinimizedFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 52, 0, 52)
        }):Play()

        MinimizedImage.Rotation = 0
        local spinTween = TweenService:Create(MinimizedImage, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Rotation = 360
        })
        spinTween:Play()

        task.delay(0.18, function()
            if IsAnimatingMinimize then
                ScriptUi.Enabled = false
            end
        end)

        local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local moveTween = TweenService:Create(MainContainer, tweenInfo, {Position = targetPos})
        local scaleTween = TweenService:Create(UIScaleConstraint, tweenInfo, {Scale = 0.05})

        moveTween:Play()
        scaleTween:Play()

        scaleTween.Completed:Wait()

        ScriptUi.Enabled = false
        MainContainer.Position = LastWindowPos
        UIScaleConstraint.Scale = GetTargetViewportScale()

        Window:Notify("Minimized", "Click icon to restore UI", 2)
        IsAnimatingMinimize = false
    end

    local function RestoreWindowAnimation()
        if IsAnimatingMinimize then return end
        IsAnimatingMinimize = true
        PlayClickSFX()

        BackgroundDOF.Enabled = Window.BackgroundBlurEnabled
        LocalUIBlurPart.Transparency = Window.BackgroundBlurEnabled and 0.98 or 1

        TriggerCircleSpinBurst()
        local iconTween = TweenService:Create(MinimizedFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        iconTween:Play()
        task.delay(0.30, function()
            if not ScriptUi.Enabled then return end
            MinimisedUI.Enabled = false
            MinimizedFrame.Size = UDim2.new(0, 52, 0, 52)
        end)
        MinimizedImage.Rotation = 0

        local targetScale = GetTargetViewportScale()
        MainContainer.Position = MinimizedFrame.Position
        UIScaleConstraint.Scale = 0.05
        ScriptUi.Enabled = true

        local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local moveTween = TweenService:Create(MainContainer, tweenInfo, {Position = LastWindowPos})
        local scaleTween = TweenService:Create(UIScaleConstraint, tweenInfo, {Scale = targetScale})

        moveTween:Play()
        scaleTween:Play()

        scaleTween.Completed:Wait()
        if Window.BackgroundBlurEnabled and UpdateLocalUIBlur then
            pcall(UpdateLocalUIBlur)
        end
        task.wait(0.04)
        if Window.UpdateActiveTabIndicator then
            pcall(function() Window.UpdateActiveTabIndicator(true) end)
        end
        IsAnimatingMinimize = false
    end

    TrackConn(MinimiseBtn.MouseButton1Click:Connect(function()
        MinimizeWindowAnimation()
    end))

    local minClick = 0
    local miniDragStart = nil
    local miniHasMoved = false

    TrackConn(MinimizedImage.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDragStart = input.Position
            miniHasMoved = false
        end
    end))

    TrackConn(UserInputService.InputChanged:Connect(function(input)
        if miniDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local dist = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(miniDragStart.X, miniDragStart.Y)).Magnitude
            if dist > 8 then
                miniHasMoved = true
            end
        end
    end))

    TrackConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if miniDragStart and not miniHasMoved then
                local dist = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(miniDragStart.X, miniDragStart.Y)).Magnitude
                if dist <= 8 then
                    if (os.clock() - minClick) > 0.25 then
                        minClick = os.clock()
                        RestoreWindowAnimation()
                    end
                end
            end
            miniDragStart = nil
            miniHasMoved = false
        end
    end))

    TrackConn(UserInputService.WindowFocusReleased:Connect(function()
        miniDragStart = nil
        miniHasMoved = false
    end))

    -- Click particle effects
    local ParticleLayer = Instance.new("Frame")
    ParticleLayer.Name = "ParticleLayer"
    ParticleLayer.Size = UDim2.new(1, 0, 1, 0)
    ParticleLayer.BackgroundTransparency = 1
    ParticleLayer.ZIndex = 60
    ParticleLayer.ClipsDescendants = false
    ParticleLayer.Parent = ScriptUi

    local ActiveParticleConns = {}

    TrackConn(CloseBtn.MouseButton1Click:Connect(function()
        PlayClickSFX()
        Window:Notify("Unloading", "Script hub closed.", 1.5)
        if UIScaleConstraint then
            local curScale = UIScaleConstraint.Scale
            local closeTween = TweenService:Create(UIScaleConstraint, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Scale = curScale * 0.90
            })
            closeTween:Play()
            task.wait(0.25)
        else
            task.wait(0.2)
        end
        for _, conn in ipairs(ActiveParticleConns) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        table.clear(ActiveParticleConns)
        for _, conn in ipairs(Window.Connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        if ParticleLayer and ParticleLayer.Parent then ParticleLayer:Destroy() end
        if LocalUIBlurPart and LocalUIBlurPart.Parent then LocalUIBlurPart:Destroy() end
        if BackgroundDOF and BackgroundDOF.Parent then BackgroundDOF:Destroy() end
        if MobileUI and MobileUI.Parent then MobileUI:Destroy() end
        if ScriptUi then ScriptUi:Destroy() end
        if MinimisedUI.Parent then MinimisedUI:Destroy() end
        if NotificationUI.Parent then NotificationUI:Destroy() end
        if SoundFolder.Parent then SoundFolder:Destroy() end
    end))

    TrackConn(RunService.Heartbeat:Connect(function()
        if ScriptUi and ScriptUi.Enabled then
            LocalTime.Text = os.date("%b %d, %Y • %I:%M %p")
        end
    end))

    local function SampleThemeColor()
        local cur = Window.CurrentTheme or Library.ThemePresets.Dark
        local palette = {
            cur.MainBG,
            cur.AccentBG,
            cur.ButtonBG,
            cur.Divider,
            cur.TopBG,
        }
        return palette[math.random(1, #palette)]
    end

    local function VaryBrightness(base)
        local factor = 0.75 + math.random() * 0.50
        return Color3.new(
            math.clamp(base.R * factor, 0, 1),
            math.clamp(base.G * factor, 0, 1),
            math.clamp(base.B * factor, 0, 1)
        )
    end

    local function SpawnClickParticles(screenX, screenY)
        if not Window.ClickEffectsEnabled or not ScriptUi or not ScriptUi.Enabled then return end
        local themeKey = Window.CurrentThemeKey or "Dark"
        local style = Window.ClickParticleType or "Theme default"

        if style == "Leaves" or (style == "Theme default" and themeKey == "Nature") then
            -- 8x8 Animated Flipbook Falling Leaves (109451333999691)
            local count = math.random(9, 14)
            for _ = 1, count do
                local size = math.random(20, 28)
                local greenColor = Color3.fromRGB(math.random(45, 80), math.random(190, 245), math.random(75, 115))
                local lifeT = 0.9 + math.random() * 0.5
                local vx = math.random(-70, 70)
                local vy = math.random(55, 90)
                local rotSpeed = math.random(-110, 110)
                local swaySeed = math.random() * 10
                local flipFrame = math.random(0, 63)

                local p = Instance.new("ImageLabel")
                p.Name = "LeafParticle"
                p.Size = UDim2.new(0, size, 0, size)
                p.Position = UDim2.new(0, screenX - size / 2, 0, screenY - size / 2)
                p.BackgroundTransparency = 1
                p.Image = "rbxassetid://109451333999691"
                p.ImageColor3 = greenColor
                p.ImageRectSize = Vector2.new(128, 128)
                p.ImageRectOffset = Vector2.new((flipFrame % 8) * 128, math.floor(flipFrame / 8) * 128)
                p.ZIndex = 61
                p.Parent = ParticleLayer

                local elapsed = 0
                local flipAccum = 0
                local flipInterval = 1 / 30
                local startX = screenX - size / 2
                local startY = screenY - size / 2
                local conn

                local function removeFromActive()
                    for i = #ActiveParticleConns, 1, -1 do
                        if ActiveParticleConns[i] == conn then
                            table.remove(ActiveParticleConns, i)
                            break
                        end
                    end
                end

                conn = RunService.RenderStepped:Connect(function(dt)
                    elapsed = elapsed + dt
                    flipAccum = flipAccum + dt
                    if not p or not p.Parent then
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end
                    if elapsed >= lifeT then
                        p:Destroy()
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end

                    if flipAccum >= flipInterval then
                        flipAccum = flipAccum - flipInterval
                        flipFrame = (flipFrame + 1) % 64
                        p.ImageRectOffset = Vector2.new((flipFrame % 8) * 128, math.floor(flipFrame / 8) * 128)
                    end

                    p.Rotation = p.Rotation + rotSpeed * dt
                    local t = elapsed / lifeT
                    local cx = startX + vx * elapsed + math.sin(elapsed * 3.5 + swaySeed) * 18
                    local cy = startY + vy * elapsed
                    p.Position = UDim2.new(0, cx, 0, cy)
                    p.ImageTransparency = math.clamp(t * 1.2, 0, 1)
                end)
                table.insert(ActiveParticleConns, conn)
            end

        elseif style == "Gems" or (style == "Theme default" and themeKey == "Amethyst") then
            -- Falling Gem Particles (138774461279155)
            local count = math.random(9, 13)
            for _ = 1, count do
                local size = math.random(10, 16)
                local purpleColor = Color3.fromRGB(math.random(180, 220), math.random(90, 140), 255)
                local lifeT = 0.75 + math.random() * 0.4
                local vx = math.random(-40, 40)
                local vy = math.random(55, 90)
                local rotSpeed = math.random(-100, 100)
                local swaySeed = math.random() * 10

                local p = Instance.new("ImageLabel")
                p.Name = "GemParticle"
                p.Size = UDim2.new(0, size, 0, size)
                p.Position = UDim2.new(0, screenX - size / 2, 0, screenY - size / 2)
                p.BackgroundTransparency = 1
                p.Image = "rbxassetid://138774461279155"
                p.ImageColor3 = purpleColor
                p.ZIndex = 61
                p.Parent = ParticleLayer

                local elapsed = 0
                local startX = screenX - size / 2
                local startY = screenY - size / 2
                local conn

                local function removeFromActive()
                    for i = #ActiveParticleConns, 1, -1 do
                        if ActiveParticleConns[i] == conn then
                            table.remove(ActiveParticleConns, i)
                            break
                        end
                    end
                end

                conn = RunService.RenderStepped:Connect(function(dt)
                    elapsed = elapsed + dt
                    if not p or not p.Parent then
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end
                    if elapsed >= lifeT then
                        p:Destroy()
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end

                    p.Rotation = p.Rotation + rotSpeed * dt
                    local t = elapsed / lifeT
                    local cx = startX + vx * elapsed + math.sin(elapsed * 4 + swaySeed) * 10
                    local cy = startY + vy * elapsed
                    p.Position = UDim2.new(0, cx, 0, cy)
                    p.ImageTransparency = math.clamp(t * 1.2, 0, 1)
                end)
                table.insert(ActiveParticleConns, conn)
            end

        elseif style == "Rings" then
            -- Expanding Pulsing Rings
            local count = math.random(3, 5)
            for i = 1, count do
                local initialSize = math.random(12, 18)
                local finalSize = initialSize + math.random(30, 50)
                local color = VaryBrightness(SampleThemeColor())
                local lifeT = 0.5 + math.random() * 0.3

                local p = Instance.new("ImageLabel")
                p.Name = "RingParticle"
                p.Size = UDim2.new(0, initialSize, 0, initialSize)
                p.Position = UDim2.new(0, screenX - initialSize / 2, 0, screenY - initialSize / 2)
                p.BackgroundTransparency = 1
                p.Image = "rbxassetid://118376432250064"
                p.ImageColor3 = color
                p.ZIndex = 61
                p.Parent = ParticleLayer

                local elapsed = 0
                local conn

                local function removeFromActive()
                    for idx = #ActiveParticleConns, 1, -1 do
                        if ActiveParticleConns[idx] == conn then
                            table.remove(ActiveParticleConns, idx)
                            break
                        end
                    end
                end

                conn = RunService.RenderStepped:Connect(function(dt)
                    elapsed = elapsed + dt
                    if not p or not p.Parent then
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end
                    if elapsed >= lifeT then
                        p:Destroy()
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end

                    local t = elapsed / lifeT
                    local curSz = initialSize + (finalSize - initialSize) * t
                    p.Size = UDim2.new(0, curSz, 0, curSz)
                    p.Position = UDim2.new(0, screenX - curSz / 2, 0, screenY - curSz / 2)
                    p.ImageTransparency = math.clamp(t * 1.3, 0, 1)
                end)
                table.insert(ActiveParticleConns, conn)
            end

        elseif style == "Dots" then
            -- Glowing Circle Burst
            local count = math.random(6, 10)
            for _ = 1, count do
                local size = math.random(6, 12)
                local color = VaryBrightness(SampleThemeColor())
                local lifeT = 0.6 + math.random() * 0.3
                local angle = math.random() * math.pi * 2
                local speed = math.random(40, 90)
                local vx = math.cos(angle) * speed
                local vy = math.sin(angle) * speed

                local p = Instance.new("Frame")
                p.Name = "DotParticle"
                p.Size = UDim2.new(0, size, 0, size)
                p.Position = UDim2.new(0, screenX - size / 2, 0, screenY - size / 2)
                p.BackgroundColor3 = color
                p.BorderSizePixel = 0
                p.ZIndex = 61
                p.Parent = ParticleLayer

                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(1, 0)
                c.Parent = p

                local elapsed = 0
                local startX = screenX - size / 2
                local startY = screenY - size / 2
                local conn

                local function removeFromActive()
                    for idx = #ActiveParticleConns, 1, -1 do
                        if ActiveParticleConns[idx] == conn then
                            table.remove(ActiveParticleConns, idx)
                            break
                        end
                    end
                end

                conn = RunService.RenderStepped:Connect(function(dt)
                    elapsed = elapsed + dt
                    if not p or not p.Parent then
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end
                    if elapsed >= lifeT then
                        p:Destroy()
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end

                    local t = elapsed / lifeT
                    local cx = startX + vx * elapsed
                    local cy = startY + vy * elapsed + (80 * elapsed * elapsed)
                    p.Position = UDim2.new(0, cx, 0, cy)
                    p.BackgroundTransparency = math.clamp(t * 1.2, 0, 1)
                end)
                table.insert(ActiveParticleConns, conn)
            end

        elseif style == "Sparkles" or style == "Custom image" then
            local count = math.random(6, 9)
            local customRaw = (style == "Custom image" and (Window.CustomParticleAsset or "")) or ""
            local customId = (customRaw:match("^%d+$") and ("rbxassetid://" .. customRaw)) or customRaw
            if customId == "" then
                customId = (style == "Sparkles" and "rbxassetid://15396333997") or "rbxassetid://80640700930724"
            end

            for _ = 1, count do
                local size = math.random(14, 22)
                local color = VaryBrightness(SampleThemeColor())
                local lifeT = 0.75 + math.random() * 0.4
                local vx = math.random(-60, 60)
                local vy = -(math.random(60, 120))
                local gravity = 350
                local rotSpeed = math.random(-120, 120)

                local p = Instance.new("ImageLabel")
                p.Name = "CustomParticle"
                p.Size = UDim2.new(0, size, 0, size)
                p.Position = UDim2.new(0, screenX - size / 2, 0, screenY - size / 2)
                p.BackgroundTransparency = 1
                p.Image = customId
                p.ImageColor3 = color
                p.ImageTransparency = 0
                p.ZIndex = 61
                p.Parent = ParticleLayer

                local elapsed = 0
                local startX = screenX - size / 2
                local startY = screenY - size / 2
                local conn

                local function removeFromActive()
                    for idx = #ActiveParticleConns, 1, -1 do
                        if ActiveParticleConns[idx] == conn then
                            table.remove(ActiveParticleConns, idx)
                            break
                        end
                    end
                end

                conn = RunService.RenderStepped:Connect(function(dt)
                    elapsed = elapsed + dt
                    if not p or not p.Parent then
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end
                    if elapsed >= lifeT then
                        p:Destroy()
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end

                    p.Rotation = p.Rotation + rotSpeed * dt
                    local t = elapsed / lifeT
                    local cx = startX + vx * elapsed
                    local cy = startY + vy * elapsed + 0.5 * gravity * elapsed * elapsed
                    p.Position = UDim2.new(0, cx, 0, cy)
                    p.ImageTransparency = math.clamp(t * 1.15, 0, 1)
                end)
                table.insert(ActiveParticleConns, conn)
            end

        else
            -- Default Flipbook burst
            local count = math.random(4, 5)
            local baseSize = math.random(20, 26)
            for _ = 1, count do
                local size = baseSize + math.random(-3, 3)
                local color = VaryBrightness(SampleThemeColor())
                local lifeT = 0.85 + math.random() * 0.4

                local angle = math.random() * math.pi * 2
                local speed = math.random(35, 75)
                local vx = math.cos(angle) * speed
                local vy = math.sin(angle) * speed + math.random(5, 20)
                local gravity = math.random(60, 100)
                local swaySeed = math.random() * 10
                local flipFrame = math.random(0, 15)

                local p = Instance.new("ImageLabel")
                p.Name = "FlipParticle"
                p.Size = UDim2.new(0, size, 0, size)
                p.Position = UDim2.new(0, screenX - size / 2, 0, screenY - size / 2)
                p.BackgroundTransparency = 1
                p.Image = "rbxassetid://8733226116"
                p.ImageColor3 = color
                p.ImageRectSize = Vector2.new(256, 256)
                p.ImageRectOffset = Vector2.new((flipFrame % 4) * 256, math.floor(flipFrame / 4) * 256)
                p.ZIndex = 61
                p.Parent = ParticleLayer

                local elapsed = 0
                local flipAccum = 0
                local flipInterval = 1 / 15
                local startX = screenX - size / 2
                local startY = screenY - size / 2
                local conn

                local function removeFromActive()
                    for idx = #ActiveParticleConns, 1, -1 do
                        if ActiveParticleConns[idx] == conn then
                            table.remove(ActiveParticleConns, idx)
                            break
                        end
                    end
                end

                conn = RunService.RenderStepped:Connect(function(dt)
                    elapsed = elapsed + dt
                    flipAccum = flipAccum + dt
                    if not p or not p.Parent then
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end
                    if elapsed >= lifeT then
                        p:Destroy()
                        if conn then conn:Disconnect() end
                        removeFromActive()
                        return
                    end

                    if flipAccum >= flipInterval then
                        flipAccum = flipAccum - flipInterval
                        flipFrame = (flipFrame + 1) % 16
                        p.ImageRectOffset = Vector2.new((flipFrame % 4) * 256, math.floor(flipFrame / 4) * 256)
                    end

                    local t = elapsed / lifeT
                    local cx = startX + vx * elapsed + math.sin(elapsed * 3 + swaySeed) * 10
                    local cy = startY + vy * elapsed + 0.5 * gravity * elapsed * elapsed
                    p.Position = UDim2.new(0, cx, 0, cy)
                    p.ImageTransparency = math.clamp(t * 1.15, 0, 1)
                end)
                table.insert(ActiveParticleConns, conn)
            end
        end
    end

    TrackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if ScriptUi and ScriptUi.Enabled then
                local pos = input.Position
                local mainAbs = MainContainer.AbsolutePosition
                local mainSz = MainContainer.AbsoluteSize
                if pos.X >= mainAbs.X and pos.X <= mainAbs.X + mainSz.X and pos.Y >= mainAbs.Y and pos.Y <= mainAbs.Y + mainSz.Y then
                    SpawnClickParticles(pos.X, pos.Y)
                end
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            if UserInputService:GetFocusedTextBox() then return end

            -- Check if a keybind badge is currently listening for input
            if ActiveListeningBadge then
                local b = ActiveListeningBadge
                if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Escape then
                    b.ClearKey(true)
                    b.StopListening()
                else
                    b.SetKey(input.KeyCode, true)
                    b.StopListening()
                end
                return
            end

            -- Trigger active keybinds
            local boundBadge = Window.KeybindMap and Window.KeybindMap[input.KeyCode]
            if boundBadge and boundBadge.OnTrigger then
                local now = os.clock()
                if (now - (boundBadge._lastTrigger or 0)) >= 0.22 then
                    boundBadge._lastTrigger = now
                    boundBadge.OnTrigger()
                end
            end
        end
    end))

    Window.SpawnClickParticles = SpawnClickParticles
    Window.ParticleLayer = ParticleLayer
    Window.ActiveParticleConns = ActiveParticleConns

    Window.ScriptUi = ScriptUi
    Window.MinimisedUI = MinimisedUI
    Window.NotificationUI = NotificationUI
    Window.MainContainer = MainContainer
    Window.TopFrame = TopFrame
    Window.LeftFrame = LeftFrame
    Window.MainFrame = MainFrame
    Window.MainContentFrame = MainContentFrame
    Window.BottomFrame = BottomFrame
    Window.BottomGradient = nil
    Window.MinGrad1 = MinGrad1
    Window.MinGrad2 = MinGrad2
    Window.MDHUBNAME = MDHUBNAME
    Window.MadebyText = MadebyText
    Window.DiscordBtn = DiscordBtn
    Window._MDiconCorner = MDiconCorner
    Window.LocalTime = LocalTime
    Window.SidebarScroll = SidebarScroll
    Window.UIScaleConstraint = UIScaleConstraint
    Window.PlayHoverSFX = PlayHoverSFX
    Window.PlayClickSFX = PlayClickSFX
    Window.ApplyCornerRadii = ApplyCornerRadii
    Window.AddUIShadow = AddUIShadow

    -- Asset preloader
    task.defer(function()
        Window:UpdateLoadingProgress(10, "Initializing...")

        if not game:IsLoaded() then
            Window:UpdateLoadingProgress(15, "Waiting for game...")
            pcall(function() game.Loaded:Wait() end)
        end

        local Players = game:GetService("Players")
        local ContentProvider = game:GetService("ContentProvider")

        local lp = Players.LocalPlayer
        while not lp do
            Window:UpdateLoadingProgress(25, "Waiting for player...")
            task.wait(0.1)
            lp = Players.LocalPlayer
        end

        Window:UpdateLoadingProgress(35, "Preparing assets...")

        local assetsToPreload = {
            "rbxassetid://88894490577328",
            "rbxassetid://86313632275410",
            "rbxassetid://97455084935031",
            "rbxassetid://77044087750639",
            "rbxassetid://15396333997",
            "rbxassetid://132261474823036",
            "rbxassetid://104249430704982",
            "rbxassetid://118376432250064",
            "rbxassetid://100354746235648",
            "rbxassetid://2418686949",
            "rbxassetid://5054663650",
            "rbxassetid://5054663737",
            "rbxassetid://6031094678",
            "rbxassetid://98226027552943",
            "rbxassetid://133887791984569"
        }

        if lp and lp.UserId then
            table.insert(assetsToPreload, "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=420&h=420")
        end

        if ScriptUi then
            for _, desc in ipairs(ScriptUi:GetDescendants()) do
                if desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
                    if desc.Image and desc.Image ~= "" and not table.find(assetsToPreload, desc.Image) then
                        table.insert(assetsToPreload, desc.Image)
                    end
                elseif desc:IsA("Sound") then
                    if desc.SoundId and desc.SoundId ~= "" and not table.find(assetsToPreload, desc.SoundId) then
                        table.insert(assetsToPreload, desc.SoundId)
                    end
                end
            end
        end

        local totalAssets = #assetsToPreload
        local loadedAssets = 0

        if totalAssets > 0 then
            pcall(function()
                ContentProvider:PreloadAsync(assetsToPreload, function(contentId, status)
                    loadedAssets = loadedAssets + 1
                    local pct = 40 + math.floor((loadedAssets / totalAssets) * 55)
                    Window:UpdateLoadingProgress(pct, string.format("Preloading assets (%d/%d)...", loadedAssets, totalAssets))
                end)
            end)
        end

        Window:UpdateLoadingProgress(100, "Loaded!")
        Window:FinishLoading()
    end)

    return Window
end

function Library:CreateMobileButton(config, arg2, arg3, arg4, arg5)
    local win = Library.ActiveWindows and Library.ActiveWindows[#Library.ActiveWindows]
    if win and win.CreateMobileButton then
        return win:CreateMobileButton(config, arg2, arg3, arg4, arg5)
    end
end
Library.AddMobileButton = Library.CreateMobileButton

return Library
