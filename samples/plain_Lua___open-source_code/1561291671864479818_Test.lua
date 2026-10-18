local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Library = {
    Flags = {},
    Items = {},
    Registry = {},
    ActivePicker = nil,
    WatermarkObj = nil,
    NotifyContainer = nil,
    Preview = nil,
    ConfigFolder = "RedOnyx_Configs",
    ConfigExt = ".json",
    WatermarkSettings = {
        Enabled = true,
        Text = "RedOnyx"
    },
    GlobalSettings = {
        Animations = true
    },
    Icons = {
    ["a-arrow-down"] = 92867583610071,
    ["a-arrow-up"] = 132318504999733,
    ["a-large-small"] = 111491496660216,
    ["accessibility"] = 114029945302017,
    ["activity"] = 94212016861936,
    ["air-vent"] = 81517226012329,
    ["airplay"] = 115020759309179,
    ["alarm-clock-check"] = 76437352099157,
    ["alarm-clock-minus"] = 77364179863205,
    ["alarm-clock-off"] = 97904885874823,
    ["alarm-clock-plus"] = 80468822979214,
    ["alarm-clock"] = 126259032907535,
    ["alarm-smoke"] = 96965448419685,
    ["album"] = 127358331163602,
    ["align-center-horizontal"] = 81570549209434,
    ["align-center-vertical"] = 118470463752466,
    ["align-end-horizontal"] = 139502909745427,
    ["align-end-vertical"] = 96528869059554,
    ["align-horizontal-distribute-center"] = 97220086126656,
    ["align-horizontal-distribute-end"] = 106128590702022,
    ["align-horizontal-distribute-start"] = 76074660002997,
    ["align-horizontal-justify-center"] = 75732302772427,
    ["align-horizontal-justify-end"] = 129167626402283,
    ["align-horizontal-justify-start"] = 130161830325281,
    ["align-horizontal-space-around"] = 91646106782950,
    ["align-horizontal-space-between"] = 103886093046990,
    ["align-start-horizontal"] = 125674804697729,
    ["align-start-vertical"] = 105020230154823,
    ["align-vertical-distribute-center"] = 93791183635525,
    ["align-vertical-distribute-end"] = 139354223511433,
    ["align-vertical-distribute-start"] = 74961997822126,
    ["align-vertical-justify-center"] = 134754696166569,
    ["align-vertical-justify-end"] = 92569381441969,
    ["align-vertical-justify-start"] = 99692844572718,
    ["align-vertical-space-around"] = 96206012459190,
    ["align-vertical-space-between"] = 124998077349706,
    ["ambulance"] = 78599995190651,
    ["ampersand"] = 75272915739209,
    ["ampersands"] = 126947193455996,
    ["amphora"] = 137370389604364,
    ["anchor"] = 92181172123618,
    ["angry"] = 74237056000103,
    ["annoyed"] = 80064369052011,
    ["antenna"] = 99628923540956,
    ["anvil"] = 100203029845919,
    ["aperture"] = 83396154449972,
    ["app-window-mac"] = 79587216113811,
    ["app-window"] = 93142176757189,
    ["apple"] = 104349242902442,
    ["archive-restore"] = 78956681942188,
    ["archive-x"] = 75830115088395,
    ["archive"] = 122180020814574,
    ["armchair"] = 105384358373973,
    ["arrow-big-down-dash"] = 137987229582002,
    ["arrow-big-down"] = 81081164158885,
    ["arrow-big-left-dash"] = 97827621354677,
    ["arrow-big-left"] = 85973092492641,
    ["arrow-big-right-dash"] = 117825834972403,
    ["arrow-big-right"] = 82960676755590,
    ["arrow-big-up-dash"] = 99260194327483,
    ["arrow-big-up"] = 93136954756149,
    ["arrow-down-0-1"] = 120961896217875,
    ["arrow-down-1-0"] = 93474255891850,
    ["arrow-down-a-z"] = 99554596207900,
    ["arrow-down-from-line"] = 132045845807798,
    ["arrow-down-left"] = 102899325237364,
    ["arrow-down-narrow-wide"] = 129105261655061,
    ["arrow-down-right"] = 123109928624974,
    ["arrow-down-to-dot"] = 101675355931221,
    ["arrow-down-to-line"] = 87050478931254,
    ["arrow-down-up"] = 85780258549577,
    ["arrow-down-wide-narrow"] = 88461733425991,
    ["arrow-down-z-a"] = 76115279362232,
    ["arrow-down"] = 98764963621439,
    ["arrow-left-from-line"] = 87857914437603,
    ["arrow-left-right"] = 131324733048447,
    ["arrow-left-to-line"] = 118645136026970,
    ["arrow-left"] = 102531941843733,
    ["arrow-right-from-line"] = 74073639809355,
    ["arrow-right-left"] = 77015754304300,
    ["arrow-right-to-line"] = 78632510329852,
    ["arrow-right"] = 113692007244654,
    ["arrow-up-0-1"] = 105257823943016,
    ["arrow-up-1-0"] = 134175521693798,
    ["arrow-up-a-z"] = 77763416595160,
    ["arrow-up-down"] = 81019887641527,
    ["arrow-up-from-dot"] = 124408496673275,
    ["arrow-up-from-line"] = 95777664626453,
    ["arrow-up-left"] = 123490598231261,
    ["arrow-up-narrow-wide"] = 73006024672636,
    ["arrow-up-right"] = 129280608535523,
    ["arrow-up-to-line"] = 108818207813537,
    ["arrow-up-wide-narrow"] = 87437426951568,
    ["arrow-up-z-a"] = 107546173611884,
    ["arrow-up"] = 89282378235317,
    ["arrows-up-from-line"] = 133710016938621,
    ["asterisk"] = 88552752106723,
    ["at-sign"] = 79059152889146,
    ["atom"] = 73167696981648,
    ["audio-lines"] = 70930641819242,
    ["audio-waveform"] = 86462036665209,
    ["award"] = 132740088158419,
    ["axe"] = 132405197863294,
    ["axis-3d"] = 122438676546804,
    ["baby"] = 93472926933440,
    ["backpack"] = 140420225386018,
    ["badge-alert"] = 101829200081951,
    ["badge-cent"] = 133345018873154,
    ["badge-check"] = 76078495178149,
    ["badge-dollar-sign"] = 127139803581141,
    ["badge-euro"] = 120016477674659,
    ["badge-indian-rupee"] = 75659682309981,
    ["badge-info"] = 131995373201472,
    ["badge-japanese-yen"] = 99081574588615,
    ["badge-minus"] = 140321561183881,
    ["badge-percent"] = 121359224294885,
    ["badge-plus"] = 100325578561866,
    ["badge-pound-sterling"] = 119688217279444,
    ["badge-question-mark"] = 121464963737502,
    ["badge-russian-ruble"] = 108839463659864,
    ["badge-swiss-franc"] = 91447608372740,
    ["badge-turkish-lira"] = 137839965873529,
    ["badge-x"] = 122931434733842,
    ["badge"] = 116620312917084,
    ["baggage-claim"] = 86922213051957,
    ["ban"] = 90767043015246,
    ["banana"] = 140713420056179,
    ["bandage"] = 129660129590770,
    ["banknote-arrow-down"] = 139366449345199,
    ["banknote-arrow-up"] = 133758343082529,
    ["banknote-x"] = 95348701438065,
    ["banknote"] = 104840231536668,
    ["barcode"] = 118473018143689,
    ["barrel"] = 130647115622774,
    ["baseline"] = 124677132511270,
    ["bath"] = 76031400297942,
    ["battery-charging"] = 80139357470047,
    ["battery-full"] = 70906718268972,
    ["battery-low"] = 139659256984314,
    ["battery-medium"] = 105934079398915,
    ["battery-plus"] = 91931341486966,
    ["battery-warning"] = 115230083817257,
    ["battery"] = 70765800346189,
    ["beaker"] = 80902539995520,
    ["bean-off"] = 98164436608714,
    ["bean"] = 89491967076869,
    ["bed-double"] = 73820193212911,
    ["bed-single"] = 113423940880634,
    ["bed"] = 97726529032925,
    ["beef"] = 105850162318915,
    ["beer-off"] = 120333134736361,
    ["beer"] = 116404978807744,
    ["bell-dot"] = 93161277118810,
    ["bell-electric"] = 100277767266983,
    ["bell-minus"] = 126334890449727,
    ["bell-off"] = 78560046118930,
    ["bell-plus"] = 77014333795836,
    ["bell-ring"] = 94612128913941,
    ["bell"] = 97392696311902,
    ["between-horizontal-end"] = 81602774794322,
    ["between-horizontal-start"] = 76112384929846,
    ["between-vertical-end"] = 72817612571631,
    ["between-vertical-start"] = 85278312190301,
    ["biceps-flexed"] = 82004462003936,
    ["bike"] = 102930322246035,
    ["binary"] = 91751953950088,
    ["binoculars"] = 101460003267896,
    ["biohazard"] = 95956532900432,
    ["bird"] = 132284145117371,
    ["birdhouse"] = 83999157401433,
    ["bitcoin"] = 95459240442938,
    ["blend"] = 111679612185257,
    ["blinds"] = 71164165283925,
    ["blocks"] = 72212693357737,
    ["bluetooth-connected"] = 96315134002985,
    ["bluetooth-off"] = 80600044218117,
    ["bluetooth-searching"] = 100673019606426,
    ["bluetooth"] = 90506573139443,
    ["bold"] = 116141470019166,
    ["bolt"] = 102881251417484,
    ["bomb"] = 139223800924636,
    ["bone"] = 111242153474115,
    ["book-a"] = 104067275658465,
    ["book-alert"] = 124159928044853,
    ["book-audio"] = 109208148317037,
    ["book-check"] = 115999656081696,
    ["book-copy"] = 108543407492005,
    ["book-dashed"] = 127430784795958,
    ["book-down"] = 101011730128222,
    ["book-headphones"] = 108670200799574,
    ["book-heart"] = 112788845135284,
    ["book-image"] = 80808285757226,
    ["book-key"] = 116024426170705,
    ["book-lock"] = 118765061220571,
    ["book-marked"] = 73211024251780,
    ["book-minus"] = 112724962046282,
    ["book-open-check"] = 130848362492667,
    ["book-open-text"] = 100629528672195,
    ["book-open"] = 129845326810392,
    ["book-plus"] = 140267785051233,
    ["book-text"] = 94011772484232,
    ["book-type"] = 97817304725443,
    ["book-up-2"] = 130161620853665,
    ["book-up"] = 98640174079190,
    ["book-user"] = 128489189240523,
    ["book-x"] = 118754548186537,
    ["book"] = 125383279695672,
    ["bookmark-check"] = 93940443347986,
    ["bookmark-minus"] = 96807096039910,
    ["bookmark-plus"] = 121469724491615,
    ["bookmark-x"] = 112272342584706,
    ["bookmark"] = 121093149326239,
    ["boom-box"] = 99901322535868,
    ["bot-message-square"] = 96145330292478,
    ["bot-off"] = 140417690560013,
    ["bot"] = 80451686744860,
    ["bottle-wine"] = 131675403196921,
    ["bow-arrow"] = 124089655150375,
    ["box"] = 101768155599700,
    ["boxes"] = 136372617578355,
    ["braces"] = 117761094704041,
    ["brackets"] = 74368995728099,
    ["brain-circuit"] = 70547962410202,
    ["brain-cog"] = 132039205501538,
    ["brain"] = 92424107303177,
    ["brick-wall-fire"] = 92980588705520,
    ["brick-wall-shield"] = 75954432775071,
    ["brick-wall"] = 112878522258821,
    ["briefcase-business"] = 129135125207283,
    ["briefcase-conveyor-belt"] = 108665725653714,
    ["briefcase-medical"] = 119917756334087,
    ["briefcase"] = 96754188164225,
    ["bring-to-front"] = 132975903553748,
    ["brush-cleaning"] = 71728977448805,
    ["brush"] = 127035535799640,
    ["bubbles"] = 106183424168227,
    ["bug-off"] = 88020025049245,
    ["bug-play"] = 80107955888092,
    ["bug"] = 83626408925438,
    ["building-2"] = 77873775611951,
    ["building"] = 110616258983082,
    ["bus-front"] = 89863432456045,
    ["bus"] = 133798469717463,
    ["cable-car"] = 128643682205596,
    ["cable"] = 128449944504901,
    ["cake-slice"] = 136769828413242,
    ["cake"] = 103131590503275,
    ["calculator"] = 74915716529646,
    ["calendar-1"] = 98458364171044,
    ["calendar-arrow-down"] = 108415736543437,
    ["calendar-arrow-up"] = 70574654109118,
    ["calendar-check-2"] = 120231170248276,
    ["calendar-check"] = 71551019465748,
    ["calendar-clock"] = 119132152594595,
    ["calendar-cog"] = 122402172360287,
    ["calendar-days"] = 99072017568595,
    ["calendar-fold"] = 117368871270394,
    ["calendar-heart"] = 88839008103676,
    ["calendar-minus-2"] = 98846170279891,
    ["calendar-minus"] = 137354318924383,
    ["calendar-off"] = 109726151749217,
    ["calendar-plus-2"] = 112264562093883,
    ["calendar-plus"] = 125266115249843,
    ["calendar-range"] = 103641849247576,
    ["calendar-search"] = 92010083223634,
    ["calendar-sync"] = 78082218499697,
    ["calendar-x-2"] = 107518051061147,
    ["calendar-x"] = 106703374806500,
    ["calendar"] = 114792700814035,
    ["camera-off"] = 81057636835256,
    ["camera"] = 79950339943067,
    ["candy-cane"] = 71689468772492,
    ["candy-off"] = 110232752314832,
    ["candy"] = 107812129154678,
    ["cannabis"] = 98792006538601,
    ["captions-off"] = 105223545364193,
    ["captions"] = 104960225031445,
    ["car-front"] = 87380942739063,
    ["car-taxi-front"] = 122455403384057,
    ["car"] = 121065933462582,
    ["caravan"] = 120070979471783,
    ["card-sim"] = 134490550095771,
    ["carrot"] = 119118221444304,
    ["case-lower"] = 129303130603241,
    ["case-sensitive"] = 125410273293056,
    ["case-upper"] = 111633433531325,
    ["cassette-tape"] = 137065788934157,
    ["cast"] = 98202245922071,
    ["castle"] = 119275077187784,
    ["cat"] = 124252153404931,
    ["cctv"] = 99979894766624,
    ["chart-area"] = 123446436762366,
    ["chart-bar-big"] = 72336824986044,
    ["chart-bar-decreasing"] = 107217459044963,
    ["chart-bar-increasing"] = 88268905998571,
    ["chart-bar-stacked"] = 98478751113024,
    ["chart-bar"] = 105389816384108,
    ["chart-candlestick"] = 125676898615697,
    ["chart-column-big"] = 98598733210787,
    ["chart-column-decreasing"] = 73586137373563,
    ["chart-column-increasing"] = 120421615068601,
    ["chart-column-stacked"] = 86031449675105,
    ["chart-column"] = 97915995538580,
    ["chart-gantt"] = 88811660555940,
    ["chart-line"] = 101833156055618,
    ["chart-network"] = 104027882693561,
    ["chart-no-axes-column-decreasing"] = 123371717192542,
    ["chart-no-axes-column-increasing"] = 140383830943049,
    ["chart-no-axes-column"] = 94078751170351,
    ["chart-no-axes-combined"] = 121424233161912,
    ["chart-no-axes-gantt"] = 131936541106368,
    ["chart-pie"] = 113412261630136,
    ["chart-scatter"] = 108217585014571,
    ["chart-spline"] = 90307460742494,
    ["check-check"] = 95183312173858,
    ["check-line"] = 115122343485290,
    ["check"] = 93898873302694,
    ["chef-hat"] = 121744015002573,
    ["cherry"] = 139519182403183,
    ["chess-bishop"] = 121701705580238,
    ["chess-king"] = 90885687223462,
    ["chess-knight"] = 96467707042169,
    ["chess-pawn"] = 111318574652751,
    ["chess-queen"] = 98304702099749,
    ["chess-rook"] = 76223925830262,
    ["chevron-down"] = 134243273101015,
    ["chevron-first"] = 105243363790238,
    ["chevron-last"] = 89268452603731,
    ["chevron-left"] = 73780377692148,
    ["chevron-right"] = 92473583511724,
    ["chevron-up"] = 122444883127455,
    ["chevrons-down-up"] = 139404716013205,
    ["chevrons-down"] = 100524612205956,
    ["chevrons-left-right-ellipsis"] = 125035817741526,
    ["chevrons-left-right"] = 87910685945204,
    ["chevrons-left"] = 82617201744347,
    ["chevrons-right-left"] = 87149546686569,
    ["chevrons-right"] = 139121276490483,
    ["chevrons-up-down"] = 131833120209646,
    ["chevrons-up"] = 100463452364672,
    ["chromium"] = 128165143739006,
    ["church"] = 113714744350666,
    ["cigarette-off"] = 77797883078452,
    ["circle-alert"] = 83898160590116,
    ["circle-arrow-down"] = 95901860261344,
    ["circle-arrow-left"] = 102148876968988,
    ["circle-arrow-out-down-left"] = 140598097856694,
    ["circle-arrow-out-down-right"] = 119952801379305,
    ["circle-arrow-out-up-left"] = 132858212688303,
    ["circle-arrow-out-up-right"] = 81783743753173,
    ["circle-arrow-right"] = 70786767999559,
    ["circle-arrow-up"] = 84395128546494,
    ["circle-check-big"] = 93202927221730,
    ["circle-check"] = 85262178816537,
    ["circle-chevron-down"] = 137069490345718,
    ["circle-chevron-left"] = 130250009740827,
    ["circle-chevron-right"] = 125943696958495,
    ["circle-chevron-up"] = 111223574026321,
    ["circle-dashed"] = 126799443883746,
    ["circle-divide"] = 106398997754208,
    ["circle-dollar-sign"] = 91106238890387,
    ["circle-dot-dashed"] = 111451232827180,
    ["circle-dot"] = 82947033619201,
    ["circle-ellipsis"] = 91687150884779,
    ["circle-equal"] = 95133963751438,
    ["circle-fading-arrow-up"] = 104648212910336,
    ["circle-fading-plus"] = 91847890443490,
    ["circle-gauge"] = 108157549473765,
    ["circle-minus"] = 133556159576809,
    ["circle-off"] = 97923456918886,
    ["circle-parking-off"] = 128369410981252,
    ["circle-parking"] = 124034962915196,
    ["circle-pause"] = 139337739700879,
    ["circle-percent"] = 133311912860256,
    ["circle-play"] = 120408917249739,
    ["circle-plus"] = 113157136350384,
    ["circle-pound-sterling"] = 105476153083828,
    ["circle-power"] = 140676030155098,
    ["circle-question-mark"] = 97516698664325,
    ["circle-slash-2"] = 136766902186549,
    ["circle-slash"] = 125206439913049,
    ["circle-small"] = 73685402843600,
    ["circle-star"] = 120318414957104,
    ["circle-stop"] = 87400503942659,
    ["circle-user-round"] = 95489465399880,
    ["circle-user"] = 136220511671311,
    ["circle-x"] = 76821953846248,
    ["circle"] = 130359823580534,
    ["circuit-board"] = 107695264369312,
    ["citrus"] = 139018222976433,
    ["clapperboard"] = 132660667070200,
    ["clipboard-check"] = 92649798577170,
    ["clipboard-clock"] = 123957515687745,
    ["clipboard-copy"] = 125851897718493,
    ["clipboard-list"] = 96460215958908,
    ["clipboard-minus"] = 107968008485671,
    ["clipboard-paste"] = 74382068849983,
    ["clipboard-pen-line"] = 77711589791615,
    ["clipboard-pen"] = 75290966822953,
    ["clipboard-plus"] = 134285318675662,
    ["clipboard-type"] = 89949374318028,
    ["clipboard-x"] = 102222456890103,
    ["clipboard"] = 89601995828423,
    ["clock-1"] = 129363225422045,
    ["clock-10"] = 104332695855541,
    ["clock-11"] = 119023205186105,
    ["clock-12"] = 117789618723068,
    ["clock-2"] = 134710777209413,
    ["clock-3"] = 136385631189327,
    ["clock-4"] = 121808839832144,
    ["clock-5"] = 85082019959457,
    ["clock-6"] = 71009733505593,
    ["clock-7"] = 103111188546225,
    ["clock-8"] = 110059272125337,
    ["clock-9"] = 77610027126437,
    ["clock-alert"] = 97157344465162,
    ["clock-arrow-down"] = 92349314416042,
    ["clock-arrow-up"] = 111484286332629,
    ["clock-check"] = 85231630218857,
    ["clock-fading"] = 93205297285245,
    ["clock-plus"] = 93367709263150,
    ["clock"] = 121808839832144,
    ["closed-caption"] = 99832644030788,
    ["cloud-alert"] = 91967273658626,
    ["cloud-check"] = 97318598202432,
    ["cloud-cog"] = 96497764065749,
    ["cloud-download"] = 121435581993566,
    ["cloud-drizzle"] = 139525315752605,
    ["cloud-fog"] = 76650233148776,
    ["cloud-hail"] = 72320462748242,
    ["cloud-lightning"] = 133517088924849,
    ["cloud-moon-rain"] = 127667837827018,
    ["cloud-moon"] = 71938114737914,
    ["cloud-off"] = 131907154501444,
    ["cloud-rain-wind"] = 107414583736721,
    ["cloud-rain"] = 105547081967408,
    ["cloud-snow"] = 72307126270226,
    ["cloud-sun-rain"] = 99041604425705,
    ["cloud-sun"] = 86114208148727,
    ["cloud-upload"] = 93307473217005,
    ["cloud"] = 121226497050352,
    ["cloudy"] = 105360479023346,
    ["clover"] = 74925550436750,
    ["club"] = 108490365816628,
    ["code-xml"] = 130150477351734,
    ["code"] = 107380207681249,
    ["codepen"] = 135643965971885,
    ["codesandbox"] = 106911852964823,
    ["coffee"] = 106864403231093,
    ["cog"] = 116544501716299,
    ["coins"] = 116510979641930,
    ["columns-2"] = 113004100221850,
    ["columns-3-cog"] = 121589691981064,
    ["columns-3"] = 115223357399375,
    ["columns-4"] = 130807991968419,
    ["combine"] = 79908476334048,
    ["command"] = 93648221906330,
    ["compass"] = 115123411028382,
    ["component"] = 110027788875080,
    ["computer"] = 77480056459407,
    ["concierge-bell"] = 140384259310436,
    ["cone"] = 97759550688437,
    ["construction"] = 106539489968173,
    ["contact-round"] = 71907624112229,
    ["contact"] = 75868297719012,
    ["container"] = 91507237573499,
    ["contrast"] = 112796643981497,
    ["cookie"] = 73159504540002,
    ["cooking-pot"] = 94959783129799,
    ["copy-check"] = 91177247988892,
    ["copy-minus"] = 109524509933035,
    ["copy-plus"] = 113618379616952,
    ["copy-slash"] = 93805787810390,
    ["copy-x"] = 106557557978061,
    ["copy"] = 78979572434545,
    ["copyleft"] = 78559055698593,
    ["copyright"] = 129433635747111,
    ["corner-down-left"] = 90473561177832,
    ["corner-down-right"] = 86512767702085,
    ["corner-left-down"] = 139876989150630,
    ["corner-left-up"] = 126228268096099,
    ["corner-right-down"] = 89237035551302,
    ["corner-right-up"] = 112851237026705,
    ["corner-up-left"] = 84669279763024,
    ["corner-up-right"] = 115099889693145,
    ["cpu"] = 77549309870247,
    ["creative-commons"] = 90408210735312,
    ["credit-card"] = 99163352872346,
    ["croissant"] = 130710485559420,
    ["crop"] = 116344601101413,
    ["cross"] = 101833377863588,
    ["crosshair"] = 134242818164054,
    ["crown"] = 127843403295538,
    ["cuboid"] = 75618807946111,
    ["cup-soda"] = 121098640829562,
    ["currency"] = 90551250119972,
    ["cylinder"] = 90569677179169,
    ["dam"] = 76874486231393,
    ["database-backup"] = 103403210984699,
    ["database-zap"] = 131199921258418,
    ["database"] = 126791525623846,
    ["decimals-arrow-left"] = 120198500638749,
    ["decimals-arrow-right"] = 118263047146797,
    ["delete"] = 126279426372342,
    ["dessert"] = 71508133278830,
    ["diameter"] = 97429051503783,
    ["diamond-minus"] = 128989071438290,
    ["diamond-percent"] = 107717860105959,
    ["diamond-plus"] = 134701163723675,
    ["diamond"] = 105846996304890,
    ["dice-1"] = 112650149591038,
    ["dice-2"] = 112278274566793,
    ["dice-3"] = 118526270626312,
    ["dice-4"] = 113365650364004,
    ["dice-5"] = 72768312430593,
    ["dice-6"] = 85376239182543,
    ["dices"] = 81268120302865,
    ["diff"] = 135052708609715,
    ["disc-2"] = 91419420404185,
    ["disc-3"] = 135470554736048,
    ["disc-album"] = 74693460404344,
    ["disc"] = 101908120120777,
    ["divide"] = 136678191878278,
    ["dna-off"] = 89612426361540,
    ["dna"] = 74007982981741,
    ["dock"] = 121997427160252,
    ["dog"] = 71920105558570,
    ["dollar-sign"] = 127320961224019,
    ["donut"] = 72204922742657,
    ["door-closed-locked"] = 74027613267551,
    ["door-closed"] = 136249099949073,
    ["door-open"] = 91306356501736,
    ["dot"] = 137321056643916,
    ["download"] = 134814648082393,
    ["drafting-compass"] = 99701976182841,
    ["drama"] = 110297795801577,
    ["dribbble"] = 80231809663849,
    ["drill"] = 108644821412796,
    ["drone"] = 117299095794783,
    ["droplet-off"] = 119365002225172,
    ["droplet"] = 100597455015098,
    ["droplets"] = 140111846025180,
    ["drum"] = 136979060344890,
    ["drumstick"] = 104662462521709,
    ["dumbbell"] = 80277236776212,
    ["ear-off"] = 87421916192807,
    ["ear"] = 121894949934209,
    ["earth-lock"] = 88814147073745,
    ["earth"] = 76231597751076,
    ["eclipse"] = 114829622118222,
    ["egg-fried"] = 90622538210545,
    ["egg-off"] = 92288321309285,
    ["egg"] = 117851493400222,
    ["ellipsis-vertical"] = 117978708573781,
    ["ellipsis"] = 140019550645825,
    ["equal-approximately"] = 105382689698323,
    ["equal-not"] = 76864449458032,
    ["equal"] = 123467780715624,
    ["eraser"] = 133957773112410,
    ["ethernet-port"] = 75391715149314,
    ["euro"] = 72229646524456,
    ["ev-charger"] = 97906158859623,
    ["expand"] = 137492887754537,
    ["external-link"] = 129331830773832,
    ["eye-closed"] = 111063268625789,
    ["eye-off"] = 135928786788378,
    ["eye"] = 100033680381365,
    ["facebook"] = 72098528632192,
    ["factory"] = 102170024318039,
    ["fan"] = 78391400440696,
    ["fast-forward"] = 121615540167909,
    ["feather"] = 91872927606406,
    ["fence"] = 123451565578029,
    ["ferris-wheel"] = 79729205796176,
    ["figma"] = 134182122852301,
    ["file-archive"] = 77018106869967,
    ["file-axis-3d"] = 133912328009885,
    ["file-badge"] = 74564895394477,
    ["file-box"] = 119264004071690,
    ["file-braces-corner"] = 77253337986109,
    ["file-braces"] = 95314128621234,
    ["file-chart-column-increasing"] = 134449481172067,
    ["file-chart-column"] = 82048481252560,
    ["file-chart-line"] = 71954360551345,
    ["file-chart-pie"] = 81072193564497,
    ["file-check-corner"] = 76295552859171,
    ["file-check"] = 82604001452455,
    ["file-clock"] = 102325208830990,
    ["file-code-corner"] = 78293841184371,
    ["file-code"] = 130978036895504,
    ["file-cog"] = 101385347151368,
    ["file-diff"] = 96147216772241,
    ["file-digit"] = 89220220354580,
    ["file-down"] = 120650154178290,
    ["file-exclamation-point"] = 102821865889635,
    ["file-headphone"] = 100533735901986,
    ["file-heart"] = 132214916401696,
    ["file-image"] = 123334057511782,
    ["file-input"] = 124728604166044,
    ["file-key"] = 118790255921100,
    ["file-lock"] = 72170228691242,
    ["file-minus-corner"] = 119263271735124,
    ["file-minus"] = 111014798459222,
    ["file-music"] = 134948051536671,
    ["file-output"] = 92146832572911,
    ["file-pen-line"] = 104622936345006,
    ["file-pen"] = 79556179730240,
    ["file-play"] = 89006821567838,
    ["file-plus-corner"] = 76544604043974,
    ["file-plus"] = 78881710800060,
    ["file-question-mark"] = 127617422859576,
    ["file-scan"] = 129480105228213,
    ["file-search-corner"] = 90974165234008,
    ["file-search"] = 97780235974933,
    ["file-signal"] = 122070252538165,
    ["file-sliders"] = 85787771732439,
    ["file-spreadsheet"] = 134501869359270,
    ["file-stack"] = 138929929862605,
    ["file-symlink"] = 91865722036510,
    ["file-terminal"] = 116757454755476,
    ["file-text"] = 90496405707281,
    ["file-type-corner"] = 124902230275209,
    ["file-type"] = 115272552799361,
    ["file-up"] = 131173039312748,
    ["file-user"] = 99552018455009,
    ["file-video-camera"] = 81719056173960,
    ["file-volume"] = 111264764438958,
    ["file-x-corner"] = 87554136773609,
    ["file-x"] = 107333775515154,
    ["file"] = 74748492079329,
    ["files"] = 102806336233202,
    ["film"] = 120978945609706,
    ["fingerprint"] = 112173305232811,
    ["fire-extinguisher"] = 111643493006960,
    ["fish-off"] = 89756724887508,
    ["fish-symbol"] = 118475177681618,
    ["fish"] = 124360663785796,
    ["flag-off"] = 112944528856799,
    ["flag-triangle-left"] = 88045221285272,
    ["flag-triangle-right"] = 108292480304566,
    ["flag"] = 78183383236196,
    ["flame-kindling"] = 139728976917928,
    ["flame"] = 98218034436456,
    ["flashlight-off"] = 79780362871740,
    ["flashlight"] = 100286985600444,
    ["flask-conical-off"] = 112597970025298,
    ["flask-conical"] = 128406680901165,
    ["flask-round"] = 127508287324940,
    ["flip-horizontal-2"] = 103726993598186,
    ["flip-horizontal"] = 122937530107837,
    ["flip-vertical-2"] = 103836358956328,
    ["flip-vertical"] = 108003917346888,
    ["flower-2"] = 72934574245145,
    ["flower"] = 86129438272762,
    ["focus"] = 87493973153317,
    ["fold-horizontal"] = 92835712442240,
    ["fold-vertical"] = 108873727253656,
    ["folder-archive"] = 97312009460206,
    ["folder-check"] = 128492920904557,
    ["folder-clock"] = 111964836738545,
    ["folder-closed"] = 118286209350843,
    ["folder-code"] = 70624096349370,
    ["folder-cog"] = 85299519462846,
    ["folder-dot"] = 138687772725278,
    ["folder-down"] = 118044108459225,
    ["folder-git-2"] = 101394054141166,
    ["folder-git"] = 121885778095158,
    ["folder-heart"] = 79104747211105,
    ["folder-input"] = 90699920697871,
    ["folder-kanban"] = 78313285104072,
    ["folder-key"] = 85270407596791,
    ["folder-lock"] = 119201572260567,
    ["folder-minus"] = 85648718999010,
    ["folder-open-dot"] = 74741494767354,
    ["folder-open"] = 76018996254888,
    ["folder-output"] = 101532447937612,
    ["folder-pen"] = 112770491173911,
    ["folder-plus"] = 91865663406119,
    ["folder-root"] = 103333751154693,
    ["folder-search-2"] = 71276453442655,
    ["folder-search"] = 110568075123861,
    ["folder-symlink"] = 127485747227189,
    ["folder-sync"] = 91544602659796,
    ["folder-tree"] = 85577554337861,
    ["folder-up"] = 72008269765857,
    ["folder-x"] = 91699618247635,
    ["folder"] = 80846616596607,
    ["folders"] = 110351216219061,
    ["footprints"] = 139192589041315,
    ["forklift"] = 72030930983101,
    ["forward"] = 97545944739523,
    ["frame"] = 109080612832751,
    ["framer"] = 108384807262391,
    ["frown"] = 124407301067982,
    ["fuel"] = 106447647274511,
    ["fullscreen"] = 77793665526178,
    ["funnel-plus"] = 100780233821928,
    ["funnel-x"] = 70984385812555,
    ["funnel"] = 108829540827529,
    ["gallery-horizontal-end"] = 74672430161161,
    ["gallery-horizontal"] = 80004001442122,
    ["gallery-thumbnails"] = 136219289862706,
    ["gallery-vertical-end"] = 106461402088317,
    ["gallery-vertical"] = 119299431466725,
    ["gamepad-2"] = 92483947987410,
    ["gamepad-directional"] = 84342305212226,
    ["gamepad"] = 121607283959010,
    ["gauge"] = 110273524101447,
    ["gavel"] = 78952298198456,
    ["gem"] = 112904952151156,
    ["georgian-lari"] = 98084432591687,
    ["ghost"] = 113822048130017,
    ["gift"] = 109855212076373,
    ["git-branch-minus"] = 97385010649411,
    ["git-branch-plus"] = 125944221134316,
    ["git-branch"] = 90490195516649,
    ["git-commit-horizontal"] = 133646041800147,
    ["git-commit-vertical"] = 122098032990350,
    ["git-compare-arrows"] = 84874426520216,
    ["git-compare"] = 91945124438792,
    ["git-fork"] = 89954992404765,
    ["git-graph"] = 86166832019304,
    ["git-merge"] = 131833355158059,
    ["git-pull-request-arrow"] = 94507974577439,
    ["git-pull-request-closed"] = 78070600389091,
    ["git-pull-request-create-arrow"] = 127422677061091,
    ["git-pull-request-create"] = 105929577383926,
    ["git-pull-request-draft"] = 76173459869943,
    ["git-pull-request"] = 138463010991471,
    ["github"] = 120349554354380,
    ["gitlab"] = 114054627192933,
    ["glass-water"] = 115526102400988,
    ["glasses"] = 87936407455373,
    ["globe-lock"] = 134065526704402,
    ["globe"] = 114238209622913,
    ["goal"] = 120517954878160,
    ["gpu"] = 95577823614219,
    ["graduation-cap"] = 93771896340220,
    ["grape"] = 134760640415561,
    ["grid-2x2-check"] = 138468840220821,
    ["grid-2x2-plus"] = 91811610580247,
    ["grid-2x2-x"] = 72407303981388,
    ["grid-2x2"] = 99050491897640,
    ["grid-3x2"] = 95528684210010,
    ["grid-3x3"] = 70419024781206,
    ["grip-horizontal"] = 136255899715930,
    ["grip-vertical"] = 137183678565296,
    ["grip"] = 109058783556768,
    ["group"] = 107643418926671,
    ["guitar"] = 75915531867926,
    ["ham"] = 74465607934635,
    ["hamburger"] = 93086916815495,
    ["hammer"] = 83545120140895,
    ["hand-coins"] = 126990543175462,
    ["hand-fist"] = 83341608917591,
    ["hand-grab"] = 88867162163985,
    ["hand-heart"] = 117507367668412,
    ["hand-helping"] = 89897738419446,
    ["hand-metal"] = 113619498548713,
    ["hand-platter"] = 88594727743168,
    ["hand"] = 130703864968637,
    ["handbag"] = 135675846264061,
    ["handshake"] = 78442115255814,
    ["hard-drive-download"] = 73913801230614,
    ["hard-drive-upload"] = 85762133615118,
    ["hard-drive"] = 88183305858463,
    ["hard-hat"] = 128050846767382,
    ["hash"] = 82890331678520,
    ["hat-glasses"] = 101165538224815,
    ["haze"] = 108857561768901,
    ["hdmi-port"] = 103693661037020,
    ["heading-1"] = 118129315662110,
    ["heading-2"] = 110209069670094,
    ["heading-3"] = 90267885237062,
    ["heading-4"] = 129625620307602,
    ["heading-5"] = 120386663181267,
    ["heading-6"] = 90959079775093,
    ["heading"] = 129254312067735,
    ["headphone-off"] = 85038251615641,
    ["headphones"] = 118833729589183,
    ["headset"] = 129269236787694,
    ["heart-crack"] = 110987638564119,
    ["heart-handshake"] = 111483078692002,
    ["heart-minus"] = 96827380163326,
    ["heart-off"] = 89748414415617,
    ["heart-plus"] = 94877796283249,
    ["heart-pulse"] = 129352925579546,
    ["heart"] = 116559368303288,
    ["heater"] = 140478466880916,
    ["helicopter"] = 111557171735930,
    ["hexagon"] = 127592089339199,
    ["highlighter"] = 77411555641113,
    ["history"] = 123980022019922,
    ["hop-off"] = 103386036934034,
    ["hop"] = 82778923997672,
    ["hospital"] = 105868763850707,
    ["hotel"] = 132283390859718,
    ["hourglass"] = 86160434939203,
    ["house-heart"] = 136054771868597,
    ["house-plug"] = 71438263712075,
    ["house-plus"] = 118495165208309,
    ["house-wifi"] = 126495519725698,
    ["house"] = 98755624629571,
    ["ice-cream-bowl"] = 124867218454386,
    ["ice-cream-cone"] = 90751397288639,
    ["id-card-lanyard"] = 90761480469224,
    ["id-card"] = 75354294622640,
    ["image-down"] = 78972295741235,
    ["image-minus"] = 101066016918565,
    ["image-off"] = 81934811700938,
    ["image-play"] = 129501806784210,
    ["image-plus"] = 70391970623917,
    ["image-up"] = 126610009605241,
    ["image-upscale"] = 106963545024679,
    ["images"] = 79350649395557,
    ["import"] = 116545008906029,
    ["inbox"] = 112591360302868,
    ["indian-rupee"] = 113038778381805,
    ["infinity"] = 98083086936965,
    ["info"] = 124560466474914,
    ["inspection-panel"] = 70905313146088,
    ["instagram"] = 119864798614855,
    ["italic"] = 96220378864282,
    ["iteration-ccw"] = 140221832794083,
    ["iteration-cw"] = 95534489554662,
    ["japanese-yen"] = 106362863465813,
    ["joystick"] = 99416790224739,
    ["kanban"] = 125934100055431,
    ["kayak"] = 136107544609389,
    ["key-round"] = 83619031955390,
    ["key-square"] = 94621420033649,
    ["key"] = 96510194465420,
    ["keyboard-music"] = 121058541758636,
    ["keyboard-off"] = 92466375369772,
    ["keyboard"] = 121474456068237,
    ["lamp-ceiling"] = 80032758469141,
    ["lamp-desk"] = 85290686983238,
    ["lamp-floor"] = 104585881375892,
    ["lamp-wall-down"] = 91271394132073,
    ["lamp-wall-up"] = 132141464337445,
    ["lamp"] = 110730830653382,
    ["land-plot"] = 96449039620294,
    ["landmark"] = 76885079756393,
    ["languages"] = 90816903776498,
    ["laptop-minimal-check"] = 114352019833865,
    ["laptop-minimal"] = 136705765566068,
    ["laptop"] = 111387063244975,
    ["lasso-select"] = 105609719912753,
    ["lasso"] = 121072936884007,
    ["laugh"] = 104491311361166,
    ["layers-2"] = 70536710516357,
    ["layers"] = 81973586053257,
    ["layout-dashboard"] = 139929981863901,
    ["layout-grid"] = 81344910161871,
    ["layout-list"] = 87462136296578,
    ["layout-panel-left"] = 125092469751491,
    ["layout-panel-top"] = 91943941515944,
    ["layout-template"] = 115564446417985,
    ["leaf"] = 119951075637174,
    ["leafy-green"] = 105146290493154,
    ["lectern"] = 106166425183862,
    ["library-big"] = 106794530191412,
    ["library"] = 114334671982047,
    ["life-buoy"] = 81168450671956,
    ["ligature"] = 111397873269411,
    ["lightbulb-off"] = 83795722296178,
    ["lightbulb"] = 103871245626488,
    ["line-squiggle"] = 109555164424447,
    ["link-2-off"] = 76885956296867,
    ["link-2"] = 86072351557466,
    ["link"] = 131607023382430,
    ["linkedin"] = 132842789255788,
    ["list-check"] = 72374358471156,
    ["list-checks"] = 99809353635593,
    ["list-chevrons-down-up"] = 137409641500711,
    ["list-chevrons-up-down"] = 81825351389084,
    ["list-collapse"] = 124505247702401,
    ["list-end"] = 77650610048119,
    ["list-filter-plus"] = 96385120752336,
    ["list-filter"] = 103321376129527,
    ["list-indent-decrease"] = 137879979228193,
    ["list-indent-increase"] = 79051053161201,
    ["list-minus"] = 138507965142671,
    ["list-music"] = 126380635781840,
    ["list-ordered"] = 83212528113913,
    ["list-plus"] = 112384738137814,
    ["list-restart"] = 91703153577421,
    ["list-start"] = 84828348299727,
    ["list-todo"] = 132980603752108,
    ["list-tree"] = 97685396239010,
    ["list-video"] = 93648525452489,
    ["list-x"] = 113025303988861,
    ["list"] = 113179976918783,
    ["loader-circle"] = 116535712789945,
    ["loader-pinwheel"] = 108513357940900,
    ["loader"] = 78408734580845,
    ["locate-fixed"] = 137367361548433,
    ["locate-off"] = 73729216338137,
    ["locate"] = 84467676590391,
    ["lock-keyhole-open"] = 110863509313073,
    ["lock-keyhole"] = 78672912777756,
    ["lock-open"] = 93597915325122,
    ["lock"] = 134724289526879,
    ["log-in"] = 103768533135201,
    ["log-out"] = 84895399304975,
    ["logs"] = 89772091251787,
    ["lollipop"] = 84681611583044,
    ["luggage"] = 76619236486400,
    ["magnet"] = 135162361226972,
    ["mail-check"] = 86921536259917,
    ["mail-minus"] = 81989813236553,
    ["mail-open"] = 122785416858638,
    ["mail-plus"] = 104886401588341,
    ["mail-question-mark"] = 126540170949819,
    ["mail-search"] = 135616173775287,
    ["mail-warning"] = 81495303676089,
    ["mail-x"] = 74607841705644,
    ["mail"] = 103945161245599,
    ["mailbox"] = 82765503320335,
    ["mails"] = 90673453450080,
    ["map-minus"] = 129525760577747,
    ["map-pin-check-inside"] = 107130529843809,
    ["map-pin-check"] = 118110914690154,
    ["map-pin-house"] = 80546885029816,
    ["map-pin-minus-inside"] = 79005529692964,
    ["map-pin-minus"] = 74518762643623,
    ["map-pin-off"] = 82474689391020,
    ["map-pin-pen"] = 113515395277504,
    ["map-pin-plus-inside"] = 134639656514430,
    ["map-pin-plus"] = 91875228967029,
    ["map-pin-x-inside"] = 126235934252379,
    ["map-pin-x"] = 101085273547316,
    ["map-pin"] = 84279202219901,
    ["map-pinned"] = 103963788475034,
    ["map-plus"] = 129388826743495,
    ["map"] = 95107167260947,
    ["mars-stroke"] = 131973193186828,
    ["mars"] = 111287112372511,
    ["martini"] = 82977695401058,
    ["maximize-2"] = 73085922906397,
    ["maximize"] = 76045941763188,
    ["medal"] = 79016002264450,
    ["megaphone-off"] = 124280774193935,
    ["megaphone"] = 118759541854879,
    ["meh"] = 132197867028557,
    ["memory-stick"] = 93212591343119,
    ["menu"] = 77021539815611,
    ["merge"] = 126201866476775,
    ["message-circle-code"] = 112865244991651,
    ["message-circle-dashed"] = 81525157881897,
    ["message-circle-heart"] = 101990756073677,
    ["message-circle-more"] = 92856823884663,
    ["message-circle-off"] = 134955643890328,
    ["message-circle-plus"] = 106562979649273,
    ["message-circle-question-mark"] = 107700302759934,
    ["message-circle-reply"] = 137071749508334,
    ["message-circle-warning"] = 119020096067894,
    ["message-circle-x"] = 126843387725536,
    ["message-circle"] = 127255077587058,
    ["message-square-code"] = 110968863152123,
    ["message-square-dashed"] = 107653455516238,
    ["message-square-diff"] = 75472190472625,
    ["message-square-dot"] = 127806382463916,
    ["message-square-heart"] = 75612811742074,
    ["message-square-lock"] = 81268215619563,
    ["message-square-more"] = 120139782405970,
    ["message-square-off"] = 99961019005789,
    ["message-square-plus"] = 76934450256199,
    ["message-square-quote"] = 116670768629340,
    ["message-square-reply"] = 130985622754637,
    ["message-square-share"] = 131017005324026,
    ["message-square-text"] = 94899503194205,
    ["message-square-warning"] = 138432903962261,
    ["message-square-x"] = 137285463279462,
    ["message-square"] = 83881670383280,
    ["messages-square"] = 97532166733358,
    ["mic-off"] = 82123034444822,
    ["mic-vocal"] = 99082286164362,
    ["mic"] = 89640799126523,
    ["microchip"] = 73937907669903,
    ["microscope"] = 116875530102782,
    ["microwave"] = 108411735353008,
    ["milestone"] = 101618292325920,
    ["milk-off"] = 72388480962742,
    ["milk"] = 96221903896918,
    ["minimize-2"] = 116269596042539,
    ["minimize"] = 121304296213645,
    ["minus"] = 118026365011536,
    ["monitor-check"] = 86651948439229,
    ["monitor-cloud"] = 85931096038318,
    ["monitor-cog"] = 94345128715799,
    ["monitor-dot"] = 130394010063680,
    ["monitor-down"] = 97466933743423,
    ["monitor-off"] = 74395526657953,
    ["monitor-pause"] = 76002184067562,
    ["monitor-play"] = 133018824306217,
    ["monitor-smartphone"] = 84335680433378,
    ["monitor-speaker"] = 81744810060380,
    ["monitor-stop"] = 98708958984757,
    ["monitor-up"] = 96035360858377,
    ["monitor-x"] = 126265210441423,
    ["monitor"] = 72664649203050,
    ["moon-star"] = 82782200506348,
    ["moon"] = 83380517901735,
    ["motorbike"] = 94580787368233,
    ["mountain-snow"] = 105315495740588,
    ["mountain"] = 73269957566415,
    ["mouse-off"] = 75267871697595,
    ["mouse-pointer-2-off"] = 104701076865632,
    ["mouse-pointer-2"] = 117093892862228,
    ["mouse-pointer-ban"] = 106849413057133,
    ["mouse-pointer-click"] = 107150227368485,
    ["mouse-pointer"] = 72322454962935,
    ["mouse"] = 73096068864710,
    ["move-3d"] = 103365982054003,
    ["move-diagonal-2"] = 117298577948096,
    ["move-diagonal"] = 101433481954184,
    ["move-down-left"] = 102819433534567,
    ["move-down-right"] = 101479760041877,
    ["move-down"] = 70510115135583,
    ["move-horizontal"] = 88513523439149,
    ["move-left"] = 137614740247980,
    ["move-right"] = 132455779472989,
    ["move-up-left"] = 139079815540148,
    ["move-up-right"] = 105885140592646,
    ["move-up"] = 84505444262658,
    ["move-vertical"] = 86234730730899,
    ["move"] = 116138709011735,
    ["music-2"] = 134397426600888,
    ["music-3"] = 94466120066498,
    ["music-4"] = 132459323665838,
    ["music"] = 113343203848535,
    ["navigation-2-off"] = 116569611780763,
    ["navigation-2"] = 81889066747907,
    ["navigation-off"] = 87003270290777,
    ["navigation"] = 79308213542922,
    ["network"] = 127410729922644,
    ["newspaper"] = 123479530460544,
    ["nfc"] = 76822396542242,
    ["non-binary"] = 78442360386235,
    ["notebook-pen"] = 140380614761023,
    ["notebook-tabs"] = 127371085570083,
    ["notebook-text"] = 93061585217270,
    ["notebook"] = 136132108664987,
    ["notepad-text-dashed"] = 135793446376219,
    ["notepad-text"] = 93404682958966,
    ["nut-off"] = 78795397311573,
    ["nut"] = 127146410705656,
    ["octagon-alert"] = 140438367956051,
    ["octagon-minus"] = 74720436795421,
    ["octagon-pause"] = 103161463909039,
    ["octagon-x"] = 90498161006311,
    ["octagon"] = 120803515514852,
    ["omega"] = 70414080018786,
    ["option"] = 100776883894054,
    ["orbit"] = 108926136860562,
    ["origami"] = 136020626667101,
    ["package-2"] = 70394974762575,
    ["package-check"] = 102374216055130,
    ["package-minus"] = 114492858789692,
    ["package-open"] = 132890233237818,
    ["package-plus"] = 129261988138366,
    ["package-search"] = 95465120894145,
    ["package-x"] = 70818501607442,
    ["package"] = 97261141732706,
    ["paint-bucket"] = 124275586663284,
    ["paint-roller"] = 115248074358348,
    ["paintbrush-vertical"] = 105151296591292,
    ["paintbrush"] = 125572663700289,
    ["palette"] = 86350350950064,
    ["panda"] = 132509022802512,
    ["panel-bottom-close"] = 74287004071159,
    ["panel-bottom-dashed"] = 131084651621603,
    ["panel-bottom-open"] = 107768659586540,
    ["panel-bottom"] = 132127145048511,
    ["panel-left-close"] = 126579818823552,
    ["panel-left-dashed"] = 75536606374585,
    ["panel-left-open"] = 111075816195767,
    ["panel-left-right-dashed"] = 110100707973959,
    ["panel-left"] = 97419752870313,
    ["panel-right-close"] = 139528655524132,
    ["panel-right-dashed"] = 94959793877311,
    ["panel-right-open"] = 118114419142794,
    ["panel-right"] = 116365035443156,
    ["panel-top-bottom-dashed"] = 134737235653344,
    ["panel-top-close"] = 83578325777808,
    ["panel-top-dashed"] = 70522913169237,
    ["panel-top-open"] = 137959875507454,
    ["panel-top"] = 75838479462875,
    ["panels-left-bottom"] = 72996856149149,
    ["panels-right-bottom"] = 90659068960726,
    ["panels-top-left"] = 79858853850600,
    ["paperclip"] = 92088291163453,
    ["parentheses"] = 78950955173096,
    ["parking-meter"] = 84652733960568,
    ["party-popper"] = 111626795712193,
    ["pause"] = 74873705394436,
    ["paw-print"] = 112218825427601,
    ["pc-case"] = 122978648019101,
    ["pen-line"] = 109108135755303,
    ["pen-off"] = 84807123119438,
    ["pen-tool"] = 106145404953445,
    ["pen"] = 72037878096321,
    ["pencil-line"] = 88392917053533,
    ["pencil-off"] = 103330927652832,
    ["pencil-ruler"] = 110120288284597,
    ["pencil"] = 137986121120732,
    ["pentagon"] = 79184802179890,
    ["percent"] = 130155041032013,
    ["person-standing"] = 125020872044147,
    ["philippine-peso"] = 91173798254675,
    ["phone-call"] = 70555587592860,
    ["phone-forwarded"] = 113269614319737,
    ["phone-incoming"] = 82863576359288,
    ["phone-missed"] = 130156165198376,
    ["phone-off"] = 133318623553383,
    ["phone-outgoing"] = 104576478735825,
    ["phone"] = 128804946640049,
    ["pi"] = 74936036243146,
    ["piano"] = 85008880789520,
    ["pickaxe"] = 105888023317688,
    ["picture-in-picture-2"] = 112803319544468,
    ["picture-in-picture"] = 80579597835123,
    ["piggy-bank"] = 79498575790721,
    ["pilcrow-left"] = 103803000849583,
    ["pilcrow-right"] = 104881733911870,
    ["pilcrow"] = 139512780392871,
    ["pill-bottle"] = 118394692404597,
    ["pill"] = 73280534813448,
    ["pin-off"] = 127696372451750,
    ["pin"] = 120978111007514,
    ["pipette"] = 133167932934404,
    ["pizza"] = 126964453193501,
    ["plane-landing"] = 122555692211889,
    ["plane-takeoff"] = 117179478829575,
    ["plane"] = 126985561580989,
    ["play"] = 135609604299893,
    ["plug-2"] = 97912386476366,
    ["plug-zap"] = 74506269884055,
    ["plug"] = 99782373064495,
    ["plus"] = 111774323017047,
    ["pocket-knife"] = 134075428063965,
    ["pocket"] = 136686762542964,
    ["podcast"] = 109577075549215,
    ["pointer-off"] = 95488389312794,
    ["pointer"] = 92615117311099,
    ["popcorn"] = 139446511232750,
    ["popsicle"] = 112696318077073,
    ["pound-sterling"] = 127482649469130,
    ["power-off"] = 118768311012214,
    ["power"] = 96479131758775,
    ["presentation"] = 106134583757890,
    ["printer-check"] = 130273549443689,
    ["printer"] = 76080649734247,
    ["projector"] = 103281856385283,
    ["proportions"] = 130046855997237,
    ["puzzle"] = 136837798892463,
    ["pyramid"] = 107811442374127,
    ["qr-code"] = 105329945723350,
    ["quote"] = 103271711590001,
    ["rabbit"] = 98580518804206,
    ["radar"] = 138528222906635,
    ["radiation"] = 104499586848433,
    ["radical"] = 132758286926047,
    ["radio-receiver"] = 129598303378835,
    ["radio-tower"] = 93958663130054,
    ["radio"] = 85611589536956,
    ["radius"] = 89814505307129,
    ["rail-symbol"] = 134295386306962,
    ["rainbow"] = 132488862841895,
    ["rat"] = 127400975953159,
    ["ratio"] = 126369423897295,
    ["receipt-cent"] = 91557573925201,
    ["receipt-euro"] = 94015722210295,
    ["receipt-indian-rupee"] = 89718170439990,
    ["receipt-japanese-yen"] = 132472560758851,
    ["receipt-pound-sterling"] = 73934967569625,
    ["receipt-russian-ruble"] = 105164576936853,
    ["receipt-swiss-franc"] = 72503668620116,
    ["receipt-text"] = 138483536013737,
    ["receipt-turkish-lira"] = 91950765836342,
    ["receipt"] = 77877895901792,
    ["rectangle-circle"] = 100642423153903,
    ["rectangle-ellipsis"] = 112919953980965,
    ["rectangle-goggles"] = 98605436666727,
    ["rectangle-horizontal"] = 90224199814966,
    ["rectangle-vertical"] = 117277050590967,
    ["recycle"] = 140417023381961,
    ["redo-2"] = 70451039017914,
    ["redo-dot"] = 94252981719732,
    ["redo"] = 116150342119054,
    ["refresh-ccw-dot"] = 106702246753270,
    ["refresh-ccw"] = 117913330389477,
    ["refresh-cw-off"] = 140179498843054,
    ["refresh-cw"] = 138133190015277,
    ["refrigerator"] = 102614042652753,
    ["regex"] = 100727200791841,
    ["remove-formatting"] = 112833162022628,
    ["repeat-1"] = 130144534857095,
    ["repeat-2"] = 85927537182704,
    ["repeat"] = 121886242955173,
    ["replace-all"] = 127862728198635,
    ["replace"] = 128404082279430,
    ["reply-all"] = 71723137343562,
    ["reply"] = 109788633497028,
    ["rewind"] = 95205297521988,
    ["ribbon"] = 94265331526851,
    ["rocket"] = 87412317685854,
    ["rocking-chair"] = 110420269495360,
    ["roller-coaster"] = 112426178972099,
    ["rose"] = 126336840238769,
    ["rotate-3d"] = 76300551576392,
    ["rotate-ccw-key"] = 74976035240976,
    ["rotate-ccw-square"] = 90515853170424,
    ["rotate-ccw"] = 110116685948665,
    ["rotate-cw-square"] = 77095448159303,
    ["rotate-cw"] = 84183336178654,
    ["route-off"] = 106350402024079,
    ["route"] = 89968303228953,
    ["router"] = 102130331994471,
    ["rows-2"] = 112556185960101,
    ["rows-3"] = 117215586961375,
    ["rows-4"] = 125646021959055,
    ["rss"] = 131789058984793,
    ["ruler-dimension-line"] = 70673861371412,
    ["ruler"] = 81432445547423,
    ["russian-ruble"] = 126357936542156,
    ["sailboat"] = 87110567187540,
    ["salad"] = 128864507821603,
    ["sandwich"] = 104573187458917,
    ["satellite-dish"] = 136742443888305,
    ["satellite"] = 134967053164645,
    ["saudi-riyal"] = 102282769104635,
    ["save-all"] = 116946975799440,
    ["save-off"] = 87085435778560,
    ["save"] = 126116963775616,
    ["scale-3d"] = 72414199620352,
    ["scale"] = 108203682317477,
    ["scaling"] = 122360365318466,
    ["scan-barcode"] = 96889457154761,
    ["scan-eye"] = 99244790601968,
    ["scan-face"] = 109959345069668,
    ["scan-heart"] = 106280819776142,
    ["scan-line"] = 126544908146540,
    ["scan-qr-code"] = 105409149549927,
    ["scan-search"] = 80009010551347,
    ["scan-text"] = 73702396787766,
    ["scan"] = 123104789658180,
    ["school"] = 76351530290068,
    ["scissors-line-dashed"] = 122237447974173,
    ["scissors"] = 118665510911274,
    ["screen-share-off"] = 107677572669805,
    ["screen-share"] = 85137895705653,
    ["scroll-text"] = 97321022666868,
    ["scroll"] = 74072101474951,
    ["search-check"] = 75442076191356,
    ["search-code"] = 117114794592802,
    ["search-slash"] = 96483932261041,
    ["search-x"] = 137319957522951,
    ["search"] = 121018724060431,
    ["section"] = 91732188298948,
    ["send-horizontal"] = 111734392411664,
    ["send-to-back"] = 75340312862253,
    ["send"] = 127751956873796,
    ["separator-horizontal"] = 84864453699927,
    ["separator-vertical"] = 84031801478581,
    ["server-cog"] = 138470287250966,
    ["server-crash"] = 132810618000212,
    ["server-off"] = 114048751507723,
    ["server"] = 92188766517878,
    ["settings-2"] = 135684703553372,
    ["settings"] = 80758916183665,
    ["shapes"] = 129989433311409,
    ["share-2"] = 71210767962065,
    ["share"] = 87340985053299,
    ["sheet"] = 134902122480171,
    ["shell"] = 140212943563599,
    ["shield-alert"] = 114995877719925,
    ["shield-ban"] = 108765041044649,
    ["shield-check"] = 87354736164608,
    ["shield-ellipsis"] = 114794739892123,
    ["shield-half"] = 117842634172647,
    ["shield-minus"] = 89965059528921,
    ["shield-off"] = 133426959132690,
    ["shield-plus"] = 100664857995498,
    ["shield-question-mark"] = 135722075265150,
    ["shield-user"] = 124832775645347,
    ["shield-x"] = 73370117343811,
    ["shield"] = 110987169760162,
    ["ship-wheel"] = 130797795829448,
    ["ship"] = 83995100553930,
    ["shirt"] = 106579555405966,
    ["shopping-bag"] = 71885477293226,
    ["shopping-basket"] = 138646411956433,
    ["shopping-cart"] = 128420521375441,
    ["shovel"] = 102465000512056,
    ["shower-head"] = 75884944024117,
    ["shredder"] = 122125164414463,
    ["shrimp"] = 102625900815307,
    ["shrink"] = 90953687918880,
    ["shrub"] = 127326280714343,
    ["shuffle"] = 132382786975101,
    ["sigma"] = 126884244870899,
    ["signal-high"] = 130436670012270,
    ["signal-low"] = 73674683500458,
    ["signal-medium"] = 125003021367019,
    ["signal-zero"] = 130045332414754,
    ["signal"] = 78424889355261,
    ["signature"] = 114402748013000,
    ["signpost-big"] = 115780185675001,
    ["signpost"] = 106584743791433,
    ["siren"] = 134210267818039,
    ["skip-back"] = 70466132711334,
    ["skip-forward"] = 124844823753990,
    ["skull"] = 137726256442333,
    ["slack"] = 96089719516736,
    ["slash"] = 117792185664263,
    ["slice"] = 95810504278179,
    ["sliders-horizontal"] = 85538382643347,
    ["sliders-vertical"] = 101190569086853,
    ["smartphone-charging"] = 102837532613995,
    ["smartphone-nfc"] = 82326425754446,
    ["smartphone"] = 96623008834511,
    ["smile-plus"] = 131981881472144,
    ["smile"] = 105880397565283,
    ["snail"] = 70904536548363,
    ["snowflake"] = 101235206534566,
    ["soap-dispenser-droplet"] = 77258480479465,
    ["sofa"] = 114427687218324,
    ["solar-panel"] = 132448188047921,
    ["soup"] = 115092551871618,
    ["space"] = 87072088914178,
    ["spade"] = 131444449466462,
    ["sparkle"] = 111044800239623,
    ["sparkles"] = 138635884129147,
    ["speaker"] = 96227183003618,
    ["speech"] = 87013139446349,
    ["spell-check-2"] = 81556731785534,
    ["spell-check"] = 91913483031334,
    ["spline-pointer"] = 84842840956804,
    ["spline"] = 129406685807412,
    ["split"] = 105112438805988,
    ["spool"] = 124541981347743,
    ["spotlight"] = 77571742539344,
    ["spray-can"] = 128372039366326,
    ["sprout"] = 100091687832508,
    ["square-activity"] = 89496630185293,
    ["square-arrow-down-left"] = 108194680296901,
    ["square-arrow-down-right"] = 99403846801050,
    ["square-arrow-down"] = 135962519626588,
    ["square-arrow-left"] = 111671474549238,
    ["square-arrow-out-down-left"] = 125714881756353,
    ["square-arrow-out-down-right"] = 89971003001390,
    ["square-arrow-out-up-left"] = 103759986579087,
    ["square-arrow-out-up-right"] = 91221896066807,
    ["square-arrow-right"] = 113920471701361,
    ["square-arrow-up-left"] = 112424670290693,
    ["square-arrow-up-right"] = 76602291406940,
    ["square-arrow-up"] = 106998604646718,
    ["square-asterisk"] = 89186832353625,
    ["square-bottom-dashed-scissors"] = 79076980104803,
    ["square-chart-gantt"] = 104034017316411,
    ["square-check-big"] = 115320390907184,
    ["square-check"] = 134682053539509,
    ["square-chevron-down"] = 91032307924592,
    ["square-chevron-left"] = 73143404829510,
    ["square-chevron-right"] = 90612077729930,
    ["square-chevron-up"] = 85565910197337,
    ["square-code"] = 81604576616881,
    ["square-dashed-bottom-code"] = 100354801563230,
    ["square-dashed-bottom"] = 101102319625624,
    ["square-dashed-kanban"] = 90388067649847,
    ["square-dashed-mouse-pointer"] = 121016142178467,
    ["square-dashed-top-solid"] = 117157577548540,
    ["square-dashed"] = 136905537847606,
    ["square-divide"] = 99894657101970,
    ["square-dot"] = 116613421354866,
    ["square-equal"] = 110283363706707,
    ["square-function"] = 86075219551088,
    ["square-kanban"] = 114537101260131,
    ["square-library"] = 73810931222081,
    ["square-m"] = 117662700410577,
    ["square-menu"] = 104067089444415,
    ["square-minus"] = 116764432015770,
    ["square-mouse-pointer"] = 76141850603920,
    ["square-parking-off"] = 100857293535141,
    ["square-parking"] = 133116656122387,
    ["square-pause"] = 86608552787615,
    ["square-pen"] = 120239476110475,
    ["square-percent"] = 87111930314567,
    ["square-pi"] = 75383328781618,
    ["square-pilcrow"] = 131854284699367,
    ["square-play"] = 108186325238481,
    ["square-plus"] = 114713264461873,
    ["square-power"] = 129240437805187,
    ["square-radical"] = 132645931868292,
    ["square-round-corner"] = 104592745113567,
    ["square-scissors"] = 110601255612411,
    ["square-sigma"] = 113231244246816,
    ["square-slash"] = 105477013908757,
    ["square-split-horizontal"] = 76095370148660,
    ["square-split-vertical"] = 88589192032058,
    ["square-square"] = 136555087357875,
    ["square-stack"] = 100463396619394,
    ["square-star"] = 94506958703720,
    ["square-stop"] = 80018708472943,
    ["square-terminal"] = 83969264476798,
    ["square-user-round"] = 86484997229302,
    ["square-user"] = 70771214183445,
    ["square-x"] = 125136183850190,
    ["square"] = 86304921356806,
    ["squares-exclude"] = 102345385822324,
    ["squares-intersect"] = 120869602570119,
    ["squares-subtract"] = 131484650948795,
    ["squares-unite"] = 96673080107843,
    ["squircle-dashed"] = 129936702532522,
    ["squircle"] = 82426632573807,
    ["squirrel"] = 112864252085343,
    ["stamp"] = 92370779813368,
    ["star-half"] = 117449275562979,
    ["star-off"] = 75742832732503,
    ["star"] = 136141469398409,
    ["step-back"] = 108672750005121,
    ["step-forward"] = 126131872136145,
    ["stethoscope"] = 122331031702148,
    ["sticker"] = 79938203791608,
    ["sticky-note"] = 111894074643919,
    ["store"] = 90338129673705,
    ["stretch-horizontal"] = 87665042192343,
    ["stretch-vertical"] = 95265463417122,
    ["strikethrough"] = 103417324549613,
    ["subscript"] = 74553514785183,
    ["sun-dim"] = 129141645592715,
    ["sun-medium"] = 130278807964710,
    ["sun-moon"] = 75752898854559,
    ["sun-snow"] = 112791898014579,
    ["sun"] = 110150589884127,
    ["sunrise"] = 134705665494098,
    ["sunset"] = 75904872203588,
    ["superscript"] = 96887696590118,
    ["swatch-book"] = 126786244872453,
    ["swiss-franc"] = 113497920041625,
    ["switch-camera"] = 76841154349737,
    ["sword"] = 124448418211665,
    ["swords"] = 81872698913435,
    ["syringe"] = 123891270479254,
    ["table-2"] = 95751552281545,
    ["table-cells-merge"] = 95363715175258,
    ["table-cells-split"] = 114799086088649,
    ["table-columns-split"] = 111011625447949,
    ["table-of-contents"] = 135044763275414,
    ["table-properties"] = 125062886015372,
    ["table-rows-split"] = 96443733673997,
    ["table"] = 109109148250737,
    ["tablet-smartphone"] = 133680859813404,
    ["tablet"] = 128403991264386,
    ["tablets"] = 80835787970735,
    ["tag"] = 129104970103940,
    ["tags"] = 107179263080798,
    ["tally-1"] = 115301298241643,
    ["tally-2"] = 110363186864027,
    ["tally-3"] = 97655344572540,
    ["tally-4"] = 102633494371890,
    ["tally-5"] = 88031817475886,
    ["tangent"] = 123263132981724,
    ["target"] = 87563802520297,
    ["telescope"] = 91755049143647,
    ["tent-tree"] = 76698322463977,
    ["tent"] = 109779587826330,
    ["terminal"] = 106783148545356,
    ["test-tube-diagonal"] = 75662704378840,
    ["test-tube"] = 98801015650164,
    ["test-tubes"] = 92555361447433,
    ["text-align-center"] = 84051028246390,
    ["text-align-end"] = 130041738343555,
    ["text-align-justify"] = 80279880143030,
    ["text-align-start"] = 134489585487649,
    ["text-cursor-input"] = 107551944047171,
    ["text-cursor"] = 115984654447300,
    ["text-initial"] = 129458097472087,
    ["text-quote"] = 139278366448736,
    ["text-search"] = 92345384671606,
    ["text-select"] = 117087320884956,
    ["text-wrap"] = 114804318314018,
    ["theater"] = 108558145549163,
    ["thermometer-snowflake"] = 121876188028425,
    ["thermometer-sun"] = 106693240074310,
    ["thermometer"] = 106546011492311,
    ["thumbs-down"] = 87794009914015,
    ["thumbs-up"] = 111137070767020,
    ["ticket-check"] = 105428777212507,
    ["ticket-minus"] = 78966299769328,
    ["ticket-percent"] = 80834774406405,
    ["ticket-plus"] = 110086734392189,
    ["ticket-slash"] = 89045681172265,
    ["ticket-x"] = 88674114109926,
    ["ticket"] = 126527071492145,
    ["tickets-plane"] = 100367018248695,
    ["tickets"] = 135268612687833,
    ["timer-off"] = 110916370767271,
    ["timer-reset"] = 110052125369932,
    ["timer"] = 85473888890506,
    ["toggle-left"] = 85887872573050,
    ["toggle-right"] = 90411952142550,
    ["toilet"] = 80930782432931,
    ["tool-case"] = 87533537832522,
    ["tornado"] = 88358291515768,
    ["torus"] = 70855707283051,
    ["touchpad-off"] = 78784008075456,
    ["touchpad"] = 74882354908014,
    ["tower-control"] = 95937619060532,
    ["toy-brick"] = 86293483924633,
    ["tractor"] = 103376704722051,
    ["traffic-cone"] = 74110220470369,
    ["train-front-tunnel"] = 105194827005114,
    ["train-front"] = 125237934215370,
    ["train-track"] = 77451032453723,
    ["tram-front"] = 93315182364998,
    ["transgender"] = 135530817673639,
    ["trash-2"] = 109843431391323,
    ["trash"] = 106723740584310,
    ["tree-deciduous"] = 123124389219004,
    ["tree-palm"] = 103846705893963,
    ["tree-pine"] = 124662547202594,
    ["trees"] = 121203841375919,
    ["trello"] = 130987241149527,
    ["trending-down"] = 139309232226438,
    ["trending-up-down"] = 85083293981691,
    ["trending-up"] = 81819858538839,
    ["triangle-alert"] = 125920361880643,
    ["triangle-dashed"] = 124324079103935,
    ["triangle-right"] = 116930791412791,
    ["triangle"] = 126330486745540,
    ["trophy"] = 131545003268773,
    ["truck-electric"] = 111873446387359,
    ["truck"] = 86662707764771,
    ["turkish-lira"] = 114589876174070,
    ["turntable"] = 129870346487856,
    ["turtle"] = 118295081560334,
    ["tv-minimal-play"] = 99201833426972,
    ["tv-minimal"] = 100382201729427,
    ["tv"] = 135687724791776,
    ["twitch"] = 71383308134888,
    ["twitter"] = 88791703276842,
    ["type-outline"] = 80108627791690,
    ["type"] = 133543553793564,
    ["umbrella-off"] = 72395143739955,
    ["umbrella"] = 127502210274589,
    ["underline"] = 123709229216544,
    ["undo-2"] = 113885292059932,
    ["undo-dot"] = 132055277744844,
    ["undo"] = 111258459077271,
    ["unfold-horizontal"] = 117128358526398,
    ["unfold-vertical"] = 116593025265499,
    ["ungroup"] = 106674800451003,
    ["university"] = 84652528263642,
    ["unlink-2"] = 128131898892572,
    ["unlink"] = 139835795227752,
    ["unplug"] = 90171381619874,
    ["upload"] = 138212042425501,
    ["usb"] = 117230058949613,
    ["user-check"] = 81775205032725,
    ["user-cog"] = 92795491530865,
    ["user-lock"] = 78892639693821,
    ["user-minus"] = 126976941957511,
    ["user-pen"] = 87445472574836,
    ["user-plus"] = 118514469915884,
    ["user-round-check"] = 118794737621941,
    ["user-round-cog"] = 78239503290053,
    ["user-round-minus"] = 98944176636447,
    ["user-round-pen"] = 108155244324878,
    ["user-round-plus"] = 113301899567470,
    ["user-round-search"] = 71565774381870,
    ["user-round-x"] = 122367980560930,
    ["user-round"] = 136485052187963,
    ["user-search"] = 101335649828115,
    ["user-star"] = 98777846316000,
    ["user-x"] = 139748155894754,
    ["user"] = 81589895647169,
    ["users-round"] = 103005444008339,
    ["users"] = 115398113982385,
    ["utensils-crossed"] = 109520762270383,
    ["utensils"] = 139952569804235,
    ["utility-pole"] = 101965541238242,
    ["variable"] = 104743088438151,
    ["vault"] = 108049164599845,
    ["vector-square"] = 86713728565344,
    ["vegan"] = 119489190688082,
    ["venetian-mask"] = 102636443033920,
    ["venus-and-mars"] = 120227752103771,
    ["venus"] = 82891342220859,
    ["vibrate-off"] = 113446447326246,
    ["vibrate"] = 108330910738733,
    ["video-off"] = 132239189859305,
    ["video"] = 107587444636945,
    ["videotape"] = 114816894323398,
    ["view"] = 118717253976805,
    ["voicemail"] = 134313454010227,
    ["volleyball"] = 83889351124153,
    ["volume-1"] = 98514588731639,
    ["volume-2"] = 89344380902620,
    ["volume-off"] = 103047478058767,
    ["volume-x"] = 139252359189540,
    ["volume"] = 103236289817396,
    ["vote"] = 89409762851246,
    ["wallet-cards"] = 129728715308337,
    ["wallet-minimal"] = 137800448816116,
    ["wallet"] = 132331555762628,
    ["wallpaper"] = 74682121235494,
    ["wand-sparkles"] = 82546429942392,
    ["wand"] = 114580617777835,
    ["warehouse"] = 78388887451080,
    ["washing-machine"] = 104194127573858,
    ["watch"] = 130544621618405,
    ["waves-ladder"] = 101808619355514,
    ["waves"] = 96340135183647,
    ["waypoints"] = 102450133666017,
    ["webcam"] = 104148487911129,
    ["webhook-off"] = 96370548093471,
    ["webhook"] = 112812457747322,
    ["weight"] = 103860559844854,
    ["wheat-off"] = 133294844612307,
    ["wheat"] = 85261952080359,
    ["whole-word"] = 90111083954485,
    ["wifi-cog"] = 110500263326209,
    ["wifi-high"] = 81954601342139,
    ["wifi-low"] = 138217335635913,
    ["wifi-off"] = 74113634330106,
    ["wifi-pen"] = 91290205064712,
    ["wifi-sync"] = 84043971055177,
    ["wifi-zero"] = 124286465246123,
    ["wifi"] = 104669375183960,
    ["wind-arrow-down"] = 127753987414870,
    ["wind"] = 114551690399915,
    ["wine-off"] = 108294164302317,
    ["wine"] = 115743721332829,
    ["workflow"] = 99186544029189,
    ["worm"] = 115752311548091,
    ["wrench"] = 112148279212860,
    ["x"] = 110786993356448,
    ["youtube"] = 123663668456341,
    ["zap-off"] = 81385483183652,
    ["zap"] = 130551565616516,
    ["zoom-in"] = 127956924984803,
    ["zoom-out"] = 108334162607319
},
    Theme = {
        Background     = Color3.fromRGB(15, 15, 15),
        Sidebar        = Color3.fromRGB(20, 20, 20),
        Groupbox       = Color3.fromRGB(25, 25, 25),
        ItemBackground = Color3.fromRGB(35, 35, 35),
        Outline        = Color3.fromRGB(45, 45, 45),
        Accent         = Color3.fromRGB(255, 40, 40),
        Text           = Color3.fromRGB(235, 235, 235),
        TextDark       = Color3.fromRGB(140, 140, 140),
        Header         = Color3.fromRGB(100, 100, 100)
    },
    ThemePresets = {
        ["Default"] = {
            Background     = Color3.fromRGB(15, 15, 15),
            Sidebar        = Color3.fromRGB(20, 20, 20),
            Groupbox       = Color3.fromRGB(25, 25, 25),
            ItemBackground = Color3.fromRGB(35, 35, 35),
            Outline        = Color3.fromRGB(45, 45, 45),
            Accent         = Color3.fromRGB(255, 40, 40),
            Text           = Color3.fromRGB(235, 235, 235),
            TextDark       = Color3.fromRGB(140, 140, 140),
            Header         = Color3.fromRGB(100, 100, 100)
        },
        ["Light"] = {
            Background     = Color3.fromRGB(240, 240, 240),
            Sidebar        = Color3.fromRGB(225, 225, 225),
            Groupbox       = Color3.fromRGB(255, 255, 255),
            ItemBackground = Color3.fromRGB(245, 245, 245),
            Outline        = Color3.fromRGB(200, 200, 200),
            Accent         = Color3.fromRGB(0, 120, 215),
            Text           = Color3.fromRGB(20, 20, 20),
            TextDark       = Color3.fromRGB(100, 100, 100),
            Header         = Color3.fromRGB(80, 80, 80)
        },
        ["Midnight"] = {
            Background     = Color3.fromRGB(10, 10, 20),
            Sidebar        = Color3.fromRGB(15, 15, 30),
            Groupbox       = Color3.fromRGB(20, 20, 40),
            ItemBackground = Color3.fromRGB(25, 25, 50),
            Outline        = Color3.fromRGB(40, 40, 70),
            Accent         = Color3.fromRGB(80, 140, 255),
            Text           = Color3.fromRGB(220, 230, 255),
            TextDark       = Color3.fromRGB(120, 130, 160),
            Header         = Color3.fromRGB(90, 100, 130)
        },
        ["Forest"] = {
            Background     = Color3.fromRGB(15, 20, 15),
            Sidebar        = Color3.fromRGB(20, 25, 20),
            Groupbox       = Color3.fromRGB(25, 30, 25),
            ItemBackground = Color3.fromRGB(30, 35, 30),
            Outline        = Color3.fromRGB(45, 60, 45),
            Accent         = Color3.fromRGB(80, 200, 80),
            Text           = Color3.fromRGB(235, 245, 235),
            TextDark       = Color3.fromRGB(140, 160, 140),
            Header         = Color3.fromRGB(100, 120, 100)
        },
        ["Amethyst"] = {
            Background     = Color3.fromRGB(20, 15, 20),
            Sidebar        = Color3.fromRGB(25, 20, 25),
            Groupbox       = Color3.fromRGB(30, 25, 30),
            ItemBackground = Color3.fromRGB(40, 30, 40),
            Outline        = Color3.fromRGB(60, 45, 60),
            Accent         = Color3.fromRGB(180, 80, 255),
            Text           = Color3.fromRGB(245, 235, 245),
            TextDark       = Color3.fromRGB(160, 140, 160),
            Header         = Color3.fromRGB(120, 100, 120)
        },
        ["Sunset"] = {
            Background     = Color3.fromRGB(20, 15, 10),
            Sidebar        = Color3.fromRGB(30, 20, 15),
            Groupbox       = Color3.fromRGB(40, 25, 20),
            ItemBackground = Color3.fromRGB(50, 30, 25),
            Outline        = Color3.fromRGB(70, 45, 40),
            Accent         = Color3.fromRGB(255, 100, 50),
            Text           = Color3.fromRGB(255, 235, 220),
            TextDark       = Color3.fromRGB(180, 140, 120),
            Header         = Color3.fromRGB(150, 110, 90)
        },
        ["Ocean"] = {
            Background     = Color3.fromRGB(10, 15, 20),
            Sidebar        = Color3.fromRGB(15, 20, 30),
            Groupbox       = Color3.fromRGB(20, 25, 40),
            ItemBackground = Color3.fromRGB(25, 30, 50),
            Outline        = Color3.fromRGB(40, 50, 70),
            Accent         = Color3.fromRGB(0, 200, 255),
            Text           = Color3.fromRGB(220, 240, 255),
            TextDark       = Color3.fromRGB(120, 150, 180),
            Header         = Color3.fromRGB(90, 120, 150)
        },
        ["Crimson"] = {
            Background     = Color3.fromRGB(20, 10, 10),
            Sidebar        = Color3.fromRGB(30, 15, 15),
            Groupbox       = Color3.fromRGB(40, 20, 20),
            ItemBackground = Color3.fromRGB(50, 25, 25),
            Outline        = Color3.fromRGB(70, 35, 35),
            Accent         = Color3.fromRGB(220, 20, 60),
            Text           = Color3.fromRGB(255, 220, 220),
            TextDark       = Color3.fromRGB(180, 120, 120),
            Header         = Color3.fromRGB(150, 90, 90)
        },
        ["Terminal"] = {
            Background     = Color3.fromRGB(0, 10, 0),
            Sidebar        = Color3.fromRGB(0, 15, 0),
            Groupbox       = Color3.fromRGB(0, 20, 0),
            ItemBackground = Color3.fromRGB(0, 25, 0),
            Outline        = Color3.fromRGB(0, 40, 0),
            Accent         = Color3.fromRGB(0, 255, 0),
            Text           = Color3.fromRGB(200, 255, 200),
            TextDark       = Color3.fromRGB(0, 150, 0),
            Header         = Color3.fromRGB(0, 120, 0)
        },
        ["Royal Gold"] = {
            Background     = Color3.fromRGB(20, 15, 5),
            Sidebar        = Color3.fromRGB(30, 20, 10),
            Groupbox       = Color3.fromRGB(40, 25, 15),
            ItemBackground = Color3.fromRGB(50, 30, 20),
            Outline        = Color3.fromRGB(70, 45, 30),
            Accent         = Color3.fromRGB(255, 215, 0),
            Text           = Color3.fromRGB(255, 245, 200),
            TextDark       = Color3.fromRGB(180, 160, 100),
            Header         = Color3.fromRGB(150, 130, 70)
        },
        ["Arctic"] = {
            Background     = Color3.fromRGB(230, 240, 255),
            Sidebar        = Color3.fromRGB(210, 225, 245),
            Groupbox       = Color3.fromRGB(250, 250, 255),
            ItemBackground = Color3.fromRGB(240, 245, 255),
            Outline        = Color3.fromRGB(180, 200, 230),
            Accent         = Color3.fromRGB(0, 100, 200),
            Text           = Color3.fromRGB(10, 20, 40),
            TextDark       = Color3.fromRGB(100, 120, 150),
            Header         = Color3.fromRGB(70, 90, 120)
        }
    }
}

--// COLOR HELPERS //--
function Library:ToHex(Color)
    return string.format("#%02X%02X%02X", math.floor(Color.R * 255), math.floor(Color.G * 255), math.floor(Color.B * 255))
end

function Library:FromHex(Hex)
    Hex = Hex:gsub("#", "")
    local R = tonumber("0x" .. Hex:sub(1, 2))
    local G = tonumber("0x" .. Hex:sub(3, 4))
    local B = tonumber("0x" .. Hex:sub(5, 6))
    if R and G and B then
        return Color3.fromRGB(R, G, B)
    end
    return nil
end

local ThemeObjects = {}
function Library:RegisterTheme(Obj, Prop, Key)
    if not ThemeObjects[Key] then ThemeObjects[Key] = {} end
    table.insert(ThemeObjects[Key], {Obj = Obj, Prop = Prop})
    Obj[Prop] = Library.Theme[Key]
end

function Library:UpdateTheme(Key, Col)
    Library.Theme[Key] = Col
    if ThemeObjects[Key] then
        for _, D in pairs(ThemeObjects[Key]) do
            pcall(function() TweenService:Create(D.Obj, TweenInfo.new(0.2), {[D.Prop] = Col}):Play() end)
        end
    end
end

function Library:SetTheme(ThemeName)
    local Preset = Library.ThemePresets[ThemeName]
    if not Preset then 
        warn("Theme preset not found: "..tostring(ThemeName))
        return 
    end
    for Key, Color in pairs(Preset) do
        Library:UpdateTheme(Key, Color)
    end
end

function Library:FadeIn(Object, Time)
    if not Library.GlobalSettings.Animations then 
        if Object:IsA("CanvasGroup") then Object.GroupTransparency = 0 end
        Object.Visible = true 
        return 
    end
    
    Object.Visible = true
    if Object:IsA("CanvasGroup") then
        Object.GroupTransparency = 1
        TweenService:Create(Object, TweenInfo.new(Time or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            GroupTransparency = 0
        }):Play()
    else
        local t = Object.Transparency
        Object.BackgroundTransparency = 1
        TweenService:Create(Object, TweenInfo.new(Time or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        }):Play()
    end
end

local TooltipObj = nil
local function CreateTooltipSystem(ScreenGui)
    local Tooltip = Instance.new("TextLabel")
    Tooltip.Name = "Tooltip"
    Tooltip.Size = UDim2.new(0, 0, 0, 0)
    Tooltip.AutomaticSize = Enum.AutomaticSize.XY
    Tooltip.BackgroundColor3 = Library.Theme.ItemBackground 
    Tooltip.TextColor3 = Library.Theme.Text
    Tooltip.Font = Enum.Font.Gotham
    Tooltip.TextSize = 12
    Tooltip.TextWrapped = false
    Tooltip.Visible = false
    Tooltip.ZIndex = 1000
    Tooltip.Parent = ScreenGui

    Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 4)
    local TStroke = Instance.new("UIStroke", Tooltip)
    TStroke.Color = Library.Theme.Outline 
    TStroke.Thickness = 1
    Instance.new("UIPadding", Tooltip).PaddingLeft = UDim.new(0, 6)
    Instance.new("UIPadding", Tooltip).PaddingRight = UDim.new(0, 6)
    Instance.new("UIPadding", Tooltip).PaddingTop = UDim.new(0, 4)
    Instance.new("UIPadding", Tooltip).PaddingBottom = UDim.new(0, 4)

    Library:RegisterTheme(Tooltip, "BackgroundColor3", "ItemBackground")
    Library:RegisterTheme(Tooltip, "TextColor3", "Text")
    Library:RegisterTheme(TStroke, "Color", "Outline")

    RunService.RenderStepped:Connect(function()
        if Tooltip.Visible then
            local MPos = UserInputService:GetMouseLocation()
            Tooltip.Position = UDim2.new(0, MPos.X + 15, 0, MPos.Y + 15)
        end
    end)

    TooltipObj = Tooltip
end

local function AddTooltip(HoverObject, Text)
    if not Text or Text == "" or not TooltipObj then return end
    HoverObject.MouseEnter:Connect(function()
        TooltipObj.Text = Text
        TooltipObj.Visible = true
    end)
    HoverObject.MouseLeave:Connect(function()
        TooltipObj.Visible = false
    end)
end

function Library:InitNotifications(ScreenGui)
    local Holder = Instance.new("Frame")
    Holder.Name = "Notifications"
    Holder.Size = UDim2.new(0, 300, 1, -20)
    Holder.Position = UDim2.new(1, -310, 0, 10)
    Holder.AnchorPoint = Vector2.new(0, 0)
    Holder.BackgroundTransparency = 1
    Holder.ZIndex = 1000 
    Holder.Parent = ScreenGui

    local List = Instance.new("UIListLayout", Holder)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.VerticalAlignment = Enum.VerticalAlignment.Bottom
    List.Padding = UDim.new(0, 6)

    Library.NotifyContainer = Holder
end

function Library:Notify(Title, Content, Duration)
    if not Library.NotifyContainer then return end
    Duration = Duration or 3

    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "NotifyWrapper"
    Wrapper.Size = UDim2.new(1, 0, 0, 0)
    Wrapper.BackgroundTransparency = 1
    Wrapper.ClipsDescendants = true
    Wrapper.Parent = Library.NotifyContainer

    local Box = Instance.new("Frame")
    Box.Name = "Box"
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.Position = UDim2.new(1, 20, 0, 0)
    Box.BackgroundColor3 = Library.Theme.Background
    Box.Parent = Wrapper

    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Thickness = 1
    Stroke.Color = Library.Theme.Outline

    local Line = Instance.new("Frame", Box)
    Line.Size = UDim2.new(0, 2, 1, 0)
    Line.BackgroundColor3 = Library.Theme.Accent
    Instance.new("UICorner", Line).CornerRadius = UDim.new(0, 4)

    local TLab = Instance.new("TextLabel", Box)
    TLab.Size = UDim2.new(1, -15, 0, 20)
    TLab.Position = UDim2.new(0, 10, 0, 5)
    TLab.BackgroundTransparency = 1
    TLab.Text = Title
    TLab.Font = Enum.Font.GothamBold
    TLab.TextSize = 13
    TLab.TextColor3 = Library.Theme.Text
    TLab.TextXAlignment = Enum.TextXAlignment.Left

    local CLab = Instance.new("TextLabel", Box)
    CLab.Size = UDim2.new(1, -15, 0, 20)
    CLab.Position = UDim2.new(0, 10, 0, 25)
    CLab.BackgroundTransparency = 1
    CLab.Text = Content
    CLab.Font = Enum.Font.Gotham
    CLab.TextSize = 12
    CLab.TextColor3 = Library.Theme.TextDark
    CLab.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(Wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50)}):Play()
    TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(Duration, function()
        if not Box or not Wrapper then return end
        local OutTween = TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0)})
        OutTween:Play()
        OutTween.Completed:Wait()
        local ShrinkTween = TweenService:Create(Wrapper, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
        ShrinkTween:Play()
        ShrinkTween.Completed:Wait()
        Wrapper:Destroy()
    end)
end

function Library:InitConfig()
    if writefile and readfile and makefolder and listfiles then
        if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end
        return true
    end
    return false
end

function Library:SaveConfig(Name)
    if not Library:InitConfig() or not Name or Name == "" then return end
    local Encoded = HttpService:JSONEncode(Library.Flags)
    writefile(Library.ConfigFolder.."/"..Name..Library.ConfigExt, Encoded)
    Library:Notify("Config Saved", "Successfully saved: " .. Name, 3)
end

function Library:LoadConfig(Name)
    if not Library:InitConfig() or not Name then return end
    local Path = Library.ConfigFolder.."/"..Name..Library.ConfigExt
    if isfile(Path) then
        local Data = HttpService:JSONDecode(readfile(Path))
        if Data then
            for Flag, Value in pairs(Data) do
                if Library.Items[Flag] and Library.Items[Flag].Set then
                    Library.Items[Flag].Set(Value)
                end
            end
            Library:Notify("Config Loaded", "Loaded settings: " .. Name, 3)
        end
    end
end

function Library:DeleteConfig(Name)
    if not Library:InitConfig() or not Name then return end
    local Path = Library.ConfigFolder.."/"..Name..Library.ConfigExt
    if isfile(Path) then
        delfile(Path)
        Library:Notify("Config Deleted", "Deleted config: " .. Name, 3)
    end
end

function Library:GetConfigs()
    if not Library:InitConfig() then return {} end
    local Configs = {}
    if listfiles then
        for _, File in pairs(listfiles(Library.ConfigFolder)) do
            if File:sub(-#Library.ConfigExt) == Library.ConfigExt then
                local Name = File:match("([^/]+)"..Library.ConfigExt.."$") or File
                table.insert(Configs, Name)
            end
        end
    end
    return Configs
end

local function MakeDraggable(dragFrame, moveFrame)
    local dragging, dragInput, dragStart, startPos
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            moveFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:Watermark(Name)
    Library.WatermarkSettings.Text = Name
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Watermark"
    ScreenGui.ResetOnSpawn = false
    if RunService:IsStudio() then ScreenGui.Parent = Player:WaitForChild("PlayerGui") else pcall(function() ScreenGui.Parent = CoreGui end) end

    Library:InitNotifications(ScreenGui)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 0, 0, 22)
    Frame.Position = UDim2.new(0.01, 0, 0.01, 0)
    Frame.BackgroundColor3 = Library.Theme.Background
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    Library:RegisterTheme(Frame, "BackgroundColor3", "Background")

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 1
    Library:RegisterTheme(Stroke, "Color", "Outline")

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    TopLine.Parent = Frame
    Library:RegisterTheme(TopLine, "BackgroundColor3", "Accent")

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -10, 1, 0)
    Text.Position = UDim2.new(0, 5, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 12
    Text.Text = Name
    Text.Parent = Frame
    Library:RegisterTheme(Text, "TextColor3", "Text")

    RunService.RenderStepped:Connect(function()
        ScreenGui.Enabled = Library.WatermarkSettings.Enabled
        if ScreenGui.Enabled then
            local FPS = math.floor(1 / math.max(RunService.RenderStepped:Wait(), 0.001))
            local PingVal = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            local Ping = math.floor(PingVal:split(" ")[1] or 0)
            local CurrentName = Library.WatermarkSettings.Text
            Text.Text = string.format("%s | FPS: %d | Ping: %d | %s", CurrentName, FPS, Ping, os.date("%H:%M:%S"))
            Frame.Size = UDim2.new(0, Text.TextBounds.X + 14, 0, 24)
        end
    end)
    Library.WatermarkObj = ScreenGui
end

function Library:Window(TitleText, KeySettings)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedOnyx"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global 
    if RunService:IsStudio() then ScreenGui.Parent = Player:WaitForChild("PlayerGui") else pcall(function() ScreenGui.Parent = CoreGui end) end

    -- [KEY SYSTEM LOGIC]
    if KeySettings and KeySettings.Enabled then
        local ValidKey = KeySettings.Key or "Key"
        local Link = KeySettings.Link or "https://discord.gg/"
        local Site = KeySettings.SiteName or "Discord"
        local SaveKey = KeySettings.SaveKey or false
        local FileName = "RedOnyx_Key.txt"
        local Verified = false
        local SavedKey = ""
        if SaveKey and isfile and isfile(FileName) then SavedKey = readfile(FileName) end

        local KeyFrame = Instance.new("Frame", ScreenGui)
        KeyFrame.Size = UDim2.new(1, 0, 1, 0)
        KeyFrame.BackgroundTransparency = 1 -- NO BACKGROUND (Corrected)
        KeyFrame.ZIndex = 10000

        local KeyBox = Instance.new("Frame", KeyFrame)
        KeyBox.Size = UDim2.new(0, 380, 0, 210)
        KeyBox.AnchorPoint = Vector2.new(0.5, 0.5)
        KeyBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        KeyBox.BackgroundColor3 = Library.Theme.Background
        Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", KeyBox).Color = Library.Theme.Outline
        
        -- Shadow for KeyBox (since background is transparent)
        local Shadow = Instance.new("ImageLabel", KeyBox)
        Shadow.ZIndex = -1
        Shadow.BackgroundTransparency = 1
        Shadow.Image = "rbxassetid://6015897843"
        Shadow.ImageTransparency = 0.5
        Shadow.ImageColor3 = Color3.new(0,0,0)
        Shadow.Size = UDim2.new(1, 40, 1, 40)
        Shadow.Position = UDim2.new(0, -20, 0, -20)
        Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
        Shadow.ScaleType = Enum.ScaleType.Slice

        local KTitle = Instance.new("TextLabel", KeyBox)
        KTitle.Size = UDim2.new(1, 0, 0, 40)
        KTitle.BackgroundTransparency = 1
        KTitle.Text = "Authentication"
        KTitle.Font = Enum.Font.GothamBold
        KTitle.TextColor3 = Library.Theme.Accent
        KTitle.TextSize = 18
        
        local KDesc = Instance.new("TextLabel", KeyBox)
        KDesc.Size = UDim2.new(1, 0, 0, 20)
        KDesc.Position = UDim2.new(0, 0, 0, 35)
        KDesc.BackgroundTransparency = 1
        KDesc.Text = "Join " .. Site .. " to get key"
        KDesc.Font = Enum.Font.Gotham
        KDesc.TextColor3 = Library.Theme.TextDark
        KDesc.TextSize = 12

        local KInput = Instance.new("TextBox", KeyBox)
        KInput.Size = UDim2.new(0.85, 0, 0, 35)
        KInput.Position = UDim2.new(0.075, 0, 0.35, 0)
        KInput.BackgroundColor3 = Library.Theme.ItemBackground
        KInput.TextColor3 = Library.Theme.Text
        KInput.PlaceholderText = "Paste Key..."
        KInput.Text = SavedKey
        KInput.Font = Enum.Font.Gotham
        KInput.TextSize = 14
        Instance.new("UICorner", KInput).CornerRadius = UDim.new(0, 4)

        local RememberBtn = Instance.new("TextButton", KeyBox)
        RememberBtn.Size = UDim2.new(0, 100, 0, 20)
        RememberBtn.Position = UDim2.new(0.075, 0, 0.55, 0)
        RememberBtn.BackgroundTransparency = 1
        RememberBtn.Text = ""
        local RemBox = Instance.new("Frame", RememberBtn)
        RemBox.Size = UDim2.new(0, 14, 0, 14)
        RemBox.Position = UDim2.new(0,0,0.5,-7)
        RemBox.BackgroundColor3 = Library.Theme.ItemBackground
        Instance.new("UICorner", RemBox).CornerRadius = UDim.new(0,3)
        local RemCheck = Instance.new("Frame", RemBox)
        RemCheck.Size = UDim2.new(0,8,0,8)
        RemCheck.Position = UDim2.new(0.5,-4,0.5,-4)
        RemCheck.BackgroundColor3 = Library.Theme.Accent
        RemCheck.Visible = (SavedKey ~= "")
        Instance.new("UICorner", RemCheck).CornerRadius = UDim.new(0,2)
        local RemLabel = Instance.new("TextLabel", RememberBtn)
        RemLabel.Size = UDim2.new(1, -20, 1, 0)
        RemLabel.Position = UDim2.new(0, 20, 0, 0)
        RemLabel.BackgroundTransparency = 1
        RemLabel.Text = "Remember Key"
        RemLabel.TextColor3 = Library.Theme.TextDark
        RemLabel.TextXAlignment = Enum.TextXAlignment.Left
        RemLabel.Font = Enum.Font.Gotham
        RemLabel.TextSize = 12
        local IsRemembering = (SavedKey ~= "")
        RememberBtn.MouseButton1Click:Connect(function() IsRemembering = not IsRemembering RemCheck.Visible = IsRemembering end)

        local KCheck = Instance.new("TextButton", KeyBox)
        KCheck.Size = UDim2.new(0.4, 0, 0, 32)
        KCheck.Position = UDim2.new(0.075, 0, 0.7, 0)
        KCheck.BackgroundColor3 = Library.Theme.Accent
        KCheck.Text = "Login"
        KCheck.TextColor3 = Library.Theme.Text
        KCheck.Font = Enum.Font.GothamBold
        KCheck.TextSize = 13
        Instance.new("UICorner", KCheck).CornerRadius = UDim.new(0, 4)

        local KLink = Instance.new("TextButton", KeyBox)
        KLink.Size = UDim2.new(0.4, 0, 0, 32)
        KLink.Position = UDim2.new(0.525, 0, 0.7, 0)
        KLink.BackgroundColor3 = Library.Theme.Sidebar
        KLink.Text = "Get Key"
        KLink.TextColor3 = Library.Theme.Text
        KLink.Font = Enum.Font.GothamBold
        KLink.TextSize = 13
        Instance.new("UICorner", KLink).CornerRadius = UDim.new(0, 4)

        local KStatus = Instance.new("TextLabel", KeyBox)
        KStatus.Size = UDim2.new(1, 0, 0, 20)
        KStatus.Position = UDim2.new(0, 0, 0.9, 0)
        KStatus.BackgroundTransparency = 1
        KStatus.Text = ""
        KStatus.Font = Enum.Font.Gotham
        KStatus.TextSize = 12
        KStatus.TextColor3 = Library.Theme.TextDark

        KLink.MouseButton1Click:Connect(function() setclipboard(Link) KStatus.Text = "Copied to clipboard!" KStatus.TextColor3 = Color3.fromRGB(0, 255, 150) end)
        KCheck.MouseButton1Click:Connect(function()
            if KInput.Text == ValidKey then
                KStatus.Text = "Success!"
                KStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
                if IsRemembering and writefile then writefile(FileName, ValidKey) elseif writefile and isfile(FileName) then delfile(FileName) end
                wait(0.5)
                TweenService:Create(KeyBox, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1.5, 0)}):Play()
                wait(0.5)
                KeyFrame:Destroy()
                Verified = true
            else
                KStatus.Text = "Invalid Key"
                KStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
                KInput.Text = ""
            end
        end)
        repeat task.wait(0.1) until Verified
    end

    CreateTooltipSystem(ScreenGui)

    -- Auto-Size Logic
    local VP = workspace.CurrentCamera.ViewportSize
    local StartWidth = math.min(550, VP.X - 20)
    local StartHeight = math.min(400, VP.Y - 50)
    
    if StartWidth < 350 then StartWidth = 350 end
    if StartHeight < 250 then StartHeight = 250 end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, StartWidth, 0, StartHeight)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Library:RegisterTheme(MainFrame, "BackgroundColor3", "Background")

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local NewVP = workspace.CurrentCamera.ViewportSize
        local NewW = math.min(550, NewVP.X - 20)
        local NewH = math.min(400, NewVP.Y - 50)
        MainFrame.Size = UDim2.new(0, NewW, 0, NewH)
    end)
    
    
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Thickness = 1
    Library:RegisterTheme(MainStroke, "Color", "Outline")
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)
    
    --// RESIZER HANDLE //--
    local Resizer = Instance.new("TextButton")
    Resizer.Name = "Resizer"
    Resizer.Size = UDim2.new(0, 30, 0, 30)
    Resizer.AnchorPoint = Vector2.new(1, 1)
    Resizer.Position = UDim2.new(1, 0, 1, 0)
    Resizer.BackgroundTransparency = 1
    Resizer.Text = "◢"
    Resizer.TextSize = 16
    Resizer.TextXAlignment = Enum.TextXAlignment.Right
    Resizer.TextYAlignment = Enum.TextYAlignment.Bottom 
    Resizer.Font = Enum.Font.Gotham
    Resizer.Parent = MainFrame
    Resizer.ZIndex = 200 
    Library:RegisterTheme(Resizer, "TextColor3", "TextDark")
    AddTooltip(Resizer, "Resize")

    local draggingResize = false
    local dragStartResize = Vector2.new()
    local startSizeResize = UDim2.new()
    local dragInputResize = nil

    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingResize = true
            dragStartResize = input.Position
            startSizeResize = MainFrame.Size
            dragInputResize = input

            TweenService:Create(Resizer, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingResize = false
                    dragInputResize = nil
                    TweenService:Create(Resizer, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingResize and (input == dragInputResize or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStartResize
            local newX = startSizeResize.X.Offset + delta.X
            local newY = startSizeResize.Y.Offset + delta.Y
            
            if newX < 300 then newX = 300 end
            if newY < 200 then newY = 200 end
            
            MainFrame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.Parent = MainFrame
    Sidebar.ZIndex = 2 
    Library:RegisterTheme(Sidebar, "BackgroundColor3", "Sidebar")
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.BackgroundTransparency = 1
    Logo.Text = TitleText
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 22
    Logo.Parent = Sidebar
    Logo.ZIndex = 5 
    Library:RegisterTheme(Logo, "TextColor3", "Accent")

    local SearchBar = Instance.new("TextBox")
    SearchBar.Name = "SearchBar"
    SearchBar.Size = UDim2.new(1, -20, 0, 30)
    SearchBar.Position = UDim2.new(0, 10, 0, 55)
    SearchBar.BackgroundColor3 = Library.Theme.ItemBackground
    SearchBar.BorderSizePixel = 0
    SearchBar.PlaceholderText = "Search..."
    SearchBar.Text = ""
    SearchBar.TextColor3 = Library.Theme.Text
    SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.TextSize = 13
    SearchBar.Parent = Sidebar
    SearchBar.ZIndex = 5 
    Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 4)
    local SBStroke = Instance.new("UIStroke", SearchBar)
    SBStroke.Color = Library.Theme.Outline
    SBStroke.Thickness = 1
    SBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
   
    Library:RegisterTheme(SearchBar, "BackgroundColor3", "ItemBackground")

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -95)
    TabContainer.Position = UDim2.new(0, 0, 0, 95)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    TabContainer.ZIndex = 3 
    TabContainer.Visible = true 
    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.Padding = UDim.new(0, 2)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local SearchResults = Instance.new("ScrollingFrame")
    SearchResults.Name = "SearchResults"
    SearchResults.Size = UDim2.new(1, 0, 1, -95)
    SearchResults.Position = UDim2.new(0, 0, 0, 95)
    SearchResults.BackgroundTransparency = 1
    SearchResults.BackgroundColor3 = Library.Theme.Sidebar 
    SearchResults.ScrollBarThickness = 2
    SearchResults.ScrollBarImageColor3 = Library.Theme.Accent
    SearchResults.Visible = false 
    SearchResults.Parent = Sidebar
    SearchResults.ZIndex = 10 
    local SearchLayout = Instance.new("UIListLayout", SearchResults)
    SearchLayout.Padding = UDim.new(0, 2)
    SearchLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local PagesArea = Instance.new("Frame")
    PagesArea.Name = "PagesArea"
    PagesArea.Size = UDim2.new(1, -180, 1, 0)
    PagesArea.Position = UDim2.new(0, 180, 0, 0)
    PagesArea.BackgroundTransparency = 1
    PagesArea.Parent = MainFrame

    MakeDraggable(Sidebar, MainFrame)
    MakeDraggable(PagesArea, MainFrame)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    ToggleBtn.Text = "UI"
    ToggleBtn.TextColor3 = Library.Theme.Accent
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", ToggleBtn).Color = Library.Theme.Accent
    MakeDraggable(ToggleBtn, ToggleBtn)
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local DropdownHolder = Instance.new("Frame")
    DropdownHolder.Name = "DropdownHolder"
    DropdownHolder.Size = UDim2.new(1,0,1,0)
    DropdownHolder.BackgroundTransparency = 1
    DropdownHolder.Visible = false
    DropdownHolder.ZIndex = 100
    DropdownHolder.Parent = ScreenGui 

    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local Input = SearchBar.Text:lower()
        if #Input == 0 then
            TabContainer.Visible = true
            SearchResults.Visible = false
        else
            TabContainer.Visible = false
            SearchResults.Visible = true
            
            for _, v in pairs(SearchResults:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end

            for _, ItemData in pairs(Library.Registry) do
                if string.find(ItemData.Name:lower(), Input, 1, true) then
                    local ResBtn = Instance.new("TextButton")
                    ResBtn.Size = UDim2.new(1, 0, 0, 25)
                    ResBtn.BackgroundTransparency = 1
                    ResBtn.Text = "  " .. ItemData.Name
                    ResBtn.Font = Enum.Font.Gotham
                    ResBtn.TextSize = 12
                    ResBtn.TextColor3 = Library.Theme.TextDark
                    ResBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ResBtn.Parent = SearchResults
                    ResBtn.ZIndex = 11
                    
                    local P = Instance.new("UIPadding", ResBtn)
                    P.PaddingLeft = UDim.new(0, 15)

                    ResBtn.MouseButton1Click:Connect(function()
                        if ItemData.TabBtn then
                            for _, v in pairs(TabContainer:GetChildren()) do
                                if v:IsA("TextButton") then
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play()
                                    if v:FindFirstChild("ActiveIndicator") then v.ActiveIndicator.Visible = false end
                                end
                            end
                            for _, v in pairs(PagesArea:GetChildren()) do 
                                if v:IsA("CanvasGroup") then
                                    v.Visible = false 
                                    v.GroupTransparency = 1 
                                end
                            end
                            
                            TweenService:Create(ItemData.TabBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
                            if ItemData.TabBtn:FindFirstChild("ActiveIndicator") then ItemData.TabBtn.ActiveIndicator.Visible = true end
                            
                            local PageFrame = ItemData.TabBtn:FindFirstChild("PageRef") and ItemData.TabBtn.PageRef.Value
                            if PageFrame then Library:FadeIn(PageFrame) end
                        end

                        if ItemData.SubTabBtn and ItemData.SubPage then
                            for _, v in pairs(ItemData.SubPage.Parent:GetChildren()) do 
                                if v:IsA("CanvasGroup") then v.Visible = false v.GroupTransparency = 1 end 
                            end
                            for _, v in pairs(ItemData.SubTabBtn.Parent:GetChildren()) do 
                                if v:IsA("TextButton") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() 
                                end 
                            end
                            
                            Library:FadeIn(ItemData.SubPage)
                            TweenService:Create(ItemData.SubTabBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
                        end
                        
                        if ItemData.Object then
                            local OriginalColor = ItemData.Object.BackgroundColor3
                            local HighlightTween = TweenService:Create(ItemData.Object, TweenInfo.new(0.5), {BackgroundColor3 = Library.Theme.Accent})
                            local RestoreTween = TweenService:Create(ItemData.Object, TweenInfo.new(0.5), {BackgroundColor3 = OriginalColor})
                            HighlightTween:Play()
                            HighlightTween.Completed:Wait()
                            RestoreTween:Play()
                        end
                    end)
                end
            end
            SearchResults.CanvasSize = UDim2.new(0, 0, 0, SearchLayout.AbsoluteContentSize.Y)
        end
    end)


    local WindowFuncs = {}
    local FirstTab = true

    function WindowFuncs:Section(Text)
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1,0,0,25)
        L.BackgroundTransparency=1
        L.Text="  "..string.upper(Text)
        L.Font=Enum.Font.GothamBold
        L.TextSize=11
        L.TextXAlignment=Enum.TextXAlignment.Left
        L.Parent=TabContainer
        L.ZIndex = 5 
        Library:RegisterTheme(L, "TextColor3", "Header")
        local P=Instance.new("UIPadding",L)
        P.PaddingTop=UDim.new(0,10)
        P.PaddingLeft=UDim.new(0,15)
    end

    function WindowFuncs:Tab(Name, IconId)
        local Btn = Instance.new("TextButton")
        Btn.Name = Name
        Btn.Size = UDim2.new(1,0,0,32)
        Btn.BackgroundTransparency = 1
        Btn.Text = ""
        Btn.Parent = TabContainer
        Btn.ZIndex = 4
        
        local TextOffset = IconId and 45 or 20

        local Title = Instance.new("TextLabel", Btn)
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -TextOffset, 1, 0)
        Title.Position = UDim2.new(0, TextOffset, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = Name
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 5
        Library:RegisterTheme(Title, "TextColor3", "TextDark")

        local TabIcon
        if IconId then
            TabIcon = Instance.new("ImageLabel", Btn)
            TabIcon.Name = "Icon"
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Position = UDim2.new(0, 12, 0.5, -10) 
            TabIcon.BackgroundTransparency = 1
local RealIconId = Library.Icons[IconId] or IconId
TabIcon.Image = "rbxassetid://" .. tostring(RealIconId)
            TabIcon.ZIndex = 5 
            Library:RegisterTheme(TabIcon, "ImageColor3", "TextDark")
        end

        local Ind = Instance.new("Frame")
        Ind.Name = "ActiveIndicator" 
        Ind.Size = UDim2.new(0, 4, 0.6, 0)
        Ind.Position = UDim2.new(0, 0, 0.2, 0) 
        Ind.Visible = false
        Ind.Parent = Btn
        Ind.ZIndex = 5 
        Library:RegisterTheme(Ind, "BackgroundColor3", "Accent")

        local Page = Instance.new("CanvasGroup")
        Page.Name = Name.."_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.GroupTransparency = 1
        Page.Visible = false
        Page.Parent = PagesArea
        
        local PageRef = Instance.new("ObjectValue", Btn)
        PageRef.Name = "PageRef"
        PageRef.Value = Page

        local SubTabArea = Instance.new("ScrollingFrame")
        SubTabArea.Name = "SubTabArea"
        SubTabArea.Size = UDim2.new(1, -20, 0, 30)
        SubTabArea.Position = UDim2.new(0, 10, 0, 10)
        SubTabArea.BackgroundTransparency = 1
        SubTabArea.ScrollBarThickness = 0
        SubTabArea.CanvasSize = UDim2.new(0, 0, 0, 0)
        SubTabArea.AutomaticCanvasSize = Enum.AutomaticSize.X
        SubTabArea.ScrollingDirection = Enum.ScrollingDirection.X
        SubTabArea.Parent = Page
        
        local SubLayout = Instance.new("UIListLayout", SubTabArea)
        SubLayout.FillDirection = Enum.FillDirection.Horizontal
        SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SubLayout.Padding = UDim.new(0, 10)
        
        local ContentArea = Instance.new("Frame")
        ContentArea.Name = "ContentArea"
        ContentArea.Size = UDim2.new(1, 0, 1, -40)
        ContentArea.Position = UDim2.new(0, 0, 0, 40)
        ContentArea.BackgroundTransparency = 1
        ContentArea.Parent = Page

        local SubTabsList = {} 
        local CurrentSubTabIndex = 1

        local function SelectSubTab(Index)
            if Index < 1 or Index > #SubTabsList then return end
            CurrentSubTabIndex = Index
            local Target = SubTabsList[Index]

            for _, v in pairs(ContentArea:GetChildren()) do 
                if v:IsA("CanvasGroup") then v.Visible = false v.GroupTransparency = 1 end
            end
            for _, v in pairs(SubTabArea:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() 
                end 
            end
            
            Library:FadeIn(Target.Page)
            TweenService:Create(Target.Btn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
        end

        local SwipeStart = nil

        local function IsOverRightSide(InputPos)
            if not MainFrame or not MainFrame.Visible then return false end
            
            local MFPos = MainFrame.AbsolutePosition
            local MFSize = MainFrame.AbsoluteSize
            local SidebarWidth = 180
            
            return InputPos.X > (MFPos.X + SidebarWidth) 
               and InputPos.X < (MFPos.X + MFSize.X)
               and InputPos.Y > MFPos.Y 
               and InputPos.Y < (MFPos.Y + MFSize.Y)
        end

        UserInputService.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if Page.Visible and IsOverRightSide(input.Position) then
                    SwipeStart = input.Position
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if SwipeStart and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                local Delta = input.Position - SwipeStart
                SwipeStart = nil 
                
                local MinSwipeDist = 30
                
                if math.abs(Delta.X) > MinSwipeDist and math.abs(Delta.X) > math.abs(Delta.Y) then
                    if Delta.X < 0 then
                        SelectSubTab(CurrentSubTabIndex + 1)
                    else
                        SelectSubTab(CurrentSubTabIndex - 1)
                    end
                end
            end
        end)

        if FirstTab then
            FirstTab = false
            Title.TextColor3 = Library.Theme.Text
            if TabIcon then TabIcon.ImageColor3 = Library.Theme.Text end
            Ind.Visible = true
            Library:FadeIn(Page)
        end

        Btn.MouseButton1Click:Connect(function()
            for _,v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    local t = v:FindFirstChild("Title")
                    if t then TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() end
                    local ico = v:FindFirstChild("Icon")
                    if ico then TweenService:Create(ico, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.TextDark}):Play() end
                    if v:FindFirstChild("ActiveIndicator") then v.ActiveIndicator.Visible = false end
                end
            end
            for _,v in pairs(PagesArea:GetChildren()) do 
                if v:IsA("CanvasGroup") and v ~= Page then v.Visible = false v.GroupTransparency = 1 end
            end
            TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
            if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.Text}):Play() end
            Ind.Visible = true
            Library:FadeIn(Page)
        end)
        
        local TabFuncs = {}
        local FirstSubTab = true
        
        function TabFuncs:SubTab(SubName)
            local SBtn = Instance.new("TextButton")
            SBtn.Size = UDim2.new(0, 0, 1, 0)
            SBtn.AutomaticSize = Enum.AutomaticSize.X
            SBtn.BackgroundTransparency = 1
            SBtn.Text = SubName
            SBtn.Font = Enum.Font.GothamBold
            SBtn.TextSize = 13
            SBtn.Parent = SubTabArea
            Library:RegisterTheme(SBtn, "TextColor3", "TextDark")
            
            local SubPage = Instance.new("CanvasGroup")
            SubPage.Name = SubName.."_SubPage"
            SubPage.Size = UDim2.new(1,0,1,0)
            SubPage.BackgroundTransparency = 1
            SubPage.GroupTransparency = 1
            SubPage.Visible = false
            SubPage.Parent = ContentArea
            
            local MyIndex = #SubTabsList + 1
            table.insert(SubTabsList, {Btn = SBtn, Page = SubPage})

            local LCol = Instance.new("ScrollingFrame")
            LCol.Name = "LeftColumn"
            LCol.Size = UDim2.new(0.5, -10, 1, -10)
            LCol.Position = UDim2.new(0, 10, 0, 0)
            LCol.BackgroundTransparency = 1
            LCol.ScrollBarThickness = 2
            LCol.ScrollBarImageColor3 = Library.Theme.Accent
            LCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
            LCol.CanvasSize = UDim2.new(0, 0, 0, 0)
            LCol.Parent = SubPage
            Library:RegisterTheme(LCol, "ScrollBarImageColor3", "Accent")

            local RCol = Instance.new("ScrollingFrame")
            RCol.Name = "RightColumn"
            RCol.Size = UDim2.new(0.5, -10, 1, -10)
            RCol.Position = UDim2.new(0.5, 5, 0, 0)
            RCol.BackgroundTransparency = 1
            RCol.ScrollBarThickness = 2
            RCol.ScrollBarImageColor3 = Library.Theme.Accent
            RCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
            RCol.CanvasSize = UDim2.new(0, 0, 0, 0)
            RCol.Parent = SubPage
            Library:RegisterTheme(RCol, "ScrollBarImageColor3", "Accent")

            local function Setup(f)
                local l = Instance.new("UIListLayout", f)
                l.Padding = UDim.new(0, 12)
                l.SortOrder = Enum.SortOrder.LayoutOrder
                local p = Instance.new("UIPadding", f)
                p.PaddingBottom = UDim.new(0, 10)
                p.PaddingRight = UDim.new(0, 5)
            end
            Setup(LCol)
            Setup(RCol)

            if FirstSubTab then
                FirstSubTab = false
                SBtn.TextColor3 = Library.Theme.Accent
                Library:FadeIn(SubPage)
                table.insert(ThemeObjects["Accent"], {Obj = SBtn, Prop = "TextColor3", CustomCheck = function() return SubPage.Visible end})
            else
                table.insert(ThemeObjects["TextDark"], {Obj = SBtn, Prop = "TextColor3", CustomCheck = function() return not SubPage.Visible end})
            end

            SBtn.MouseButton1Click:Connect(function()
                SelectSubTab(MyIndex)
            end)

            local SubFuncs = {}
            
            function SubFuncs:Groupbox(Name, Side, IconId, Collapsible)
                local P = (Side=="Right") and RCol or LCol
                
                local Box = Instance.new("Frame", P)
                Box.Size = UDim2.new(1,0,0,100)
                -- ВАЖНО: Включаем обрезку содержимого, чтобы при сворачивании функции исчезали
                Box.ClipsDescendants = true 
                
                Library:RegisterTheme(Box,"BackgroundColor3","Groupbox")
                Instance.new("UICorner",Box).CornerRadius=UDim.new(0,4)
                
                local S=Instance.new("UIStroke",Box) 
                S.Thickness=1
                Library:RegisterTheme(S,"Color","Outline")
                
                Box.BackgroundTransparency = 1 
                TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                
                local HeaderOffset = 10
                if IconId then
                    HeaderOffset = 32
                    local GIcon = Instance.new("ImageLabel", Box)
                    GIcon.Size = UDim2.new(0, 16, 0, 16)
                    GIcon.Position = UDim2.new(0, 10, 0, 5)
                    GIcon.BackgroundTransparency = 1
                    local RealIconId = Library.Icons[IconId] or IconId
                    GIcon.Image = "rbxassetid://" .. tostring(RealIconId)
                    Library:RegisterTheme(GIcon, "ImageColor3", "Accent")
                end

                local H=Instance.new("TextLabel", Box)
                H.Size=UDim2.new(1,-20,0,25)
                H.Position=UDim2.new(0, HeaderOffset, 0, 0)
                H.BackgroundTransparency=1
                H.Text=Name
                H.Font=Enum.Font.GothamBold
                H.TextSize=13
                H.TextXAlignment=Enum.TextXAlignment.Left
                Library:RegisterTheme(H,"TextColor3","Accent")

                -- ЛОГИКА СВОРАЧИВАНИЯ
                local ContentHeight = 0
                local IsOpen = true
                
                local C=Instance.new("Frame", Box)
                C.Name = "MainContent"
                C.Size=UDim2.new(1,0,0,0)
                C.Position=UDim2.new(0,0,0,30)
                C.BackgroundTransparency=1
                
                if Collapsible then
                    local Arrow = Instance.new("ImageButton", Box)
                    Arrow.Size = UDim2.new(0, 14, 0, 14)
                    Arrow.Position = UDim2.new(1, -20, 0, 6)
                    Arrow.BackgroundTransparency = 1
                    Arrow.Image = "rbxassetid://122444883127455" -- Стрелка
                    Library:RegisterTheme(Arrow, "ImageColor3", "TextDark")
                    
                    Arrow.MouseButton1Click:Connect(function()
                        IsOpen = not IsOpen
                        if IsOpen then
                            -- РАЗВЕРНУТЬ: Возвращаем полный размер
                            TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0, ContentHeight + 45)}):Play()
                            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        else
                            -- СВЕРНУТЬ: Уменьшаем высоту до шапки (35px)
                            -- Благодаря ClipsDescendants = true, контент обрежется визуально
                            TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0, 35)}):Play()
                            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                        end
                    end)
                end

                local L=Instance.new("UIListLayout",C) 
                L.SortOrder=Enum.SortOrder.LayoutOrder 
                L.Padding=UDim.new(0,12)
                
                local Pa=Instance.new("UIPadding",C) 
                Pa.PaddingLeft=UDim.new(0,10) 
                Pa.PaddingRight=UDim.new(0,10) 
                Pa.PaddingBottom=UDim.new(0,10) 
                Pa.PaddingTop=UDim.new(0,5)
                
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    ContentHeight = L.AbsoluteContentSize.Y
                    -- Обновляем размер только если коробка открыта
                    if IsOpen then 
                        Box.Size=UDim2.new(1,0,0, ContentHeight + 45) 
                    end
                    C.Size = UDim2.new(1, 0, 0, ContentHeight + 10)
                end)
                
                local function RegisterItem(ItemName, ItemObj)
                    if not Btn or not SBtn or not SubPage then return end 
                    table.insert(Library.Registry, {
                        Name = ItemName,
                        Object = ItemObj,
                        TabBtn = Btn,
                        SubTabBtn = SBtn,
                        SubPage = SubPage
                    })
                end

                local ContainerStack = {C}
                local NextItemOpenVal = nil
                local function GetContainer() return ContainerStack[#ContainerStack] end

                local BoxFuncs = {}
                
                local function CheckActivePicker()
                    if Library.ActivePicker then
                        Library.ActivePicker.Visible = false
                        Library.ActivePicker = nil
                    end
                end

                function BoxFuncs:SetNextItemOpen(isOpen)
                    NextItemOpenVal = isOpen
                end
            
                function BoxFuncs:GetTreeNodeToLabelSpacing()
                    return 20
                end
            
                local function TreeNodeBehavior(Label, Flags)
                    local Parent = GetContainer()
                    local IsFramed = (Flags and Flags.Framed)
                    
                    local NodeFrame = Instance.new("Frame")
                    NodeFrame.Name = "TreeNode_" .. Label
                    NodeFrame.Size = UDim2.new(1, 0, 0, 0)
                    NodeFrame.AutomaticSize = Enum.AutomaticSize.Y
                    NodeFrame.BackgroundTransparency = IsFramed and 0 or 1
                    NodeFrame.BackgroundColor3 = IsFramed and Library.Theme.ItemBackground or Color3.new(0,0,0)
                    NodeFrame.Parent = Parent

                    if IsFramed then
                        Instance.new("UICorner", NodeFrame).CornerRadius = UDim.new(0, 4)
                        Library:RegisterTheme(NodeFrame, "BackgroundColor3", "ItemBackground")
                    end
            
                    local NodeLayout = Instance.new("UIListLayout", NodeFrame)
                    NodeLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    NodeLayout.Padding = UDim.new(0, 0)
            
                    local HeaderBtn = Instance.new("TextButton", NodeFrame)
                    HeaderBtn.Size = UDim2.new(1, 0, 0, IsFramed and 25 or 20)
                    HeaderBtn.BackgroundTransparency = 1
                    HeaderBtn.Text = ""
                    
                    local Arrow = Instance.new("TextLabel", HeaderBtn)
                    Arrow.Size = UDim2.new(0, 15, 1, 0)
                    Arrow.BackgroundTransparency = 1
                    Arrow.Text = ">"
                    Arrow.Font = Enum.Font.Code
                    Arrow.TextSize = 14
                    Arrow.TextColor3 = Library.Theme.TextDark
                    Arrow.Position = UDim2.new(0, IsFramed and 5 or 0, 0, 0)
                    
                    local Lb = Instance.new("TextLabel", HeaderBtn)
                    Lb.Size = UDim2.new(1, -20, 1, 0)
                    Lb.Position = UDim2.new(0, 20, 0, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Label
                    Lb.Font = Enum.Font.GothamBold
                    Lb.TextSize = 12
                    Lb.TextColor3 = Library.Theme.Text
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
            
                    local ChildContent = Instance.new("Frame", NodeFrame)
                    ChildContent.Name = "Content"
                    ChildContent.Size = UDim2.new(1, 0, 0, 0)
                    ChildContent.BackgroundTransparency = 1
                    ChildContent.Visible = false
                    
                    local ChildLayout = Instance.new("UIListLayout", ChildContent)
                    ChildLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    ChildLayout.Padding = UDim.new(0, 10)
                    
                    local ChildPadding = Instance.new("UIPadding", ChildContent)
                    ChildPadding.PaddingLeft = UDim.new(0, IsFramed and 10 or 15)
                    ChildPadding.PaddingTop = UDim.new(0, 5)
                    ChildPadding.PaddingBottom = UDim.new(0, 5)
            
                    ChildLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        ChildContent.Size = UDim2.new(1, 0, 0, ChildLayout.AbsoluteContentSize.Y + 10)
                    end)
            
                    local IsOpen = false
                    if NextItemOpenVal ~= nil then
                        IsOpen = NextItemOpenVal
                        NextItemOpenVal = nil
                    end
            
                    local function Toggle(v)
                        IsOpen = v
                        ChildContent.Visible = IsOpen
                        if IsOpen then
                            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 90, TextColor3 = Library.Theme.Accent}):Play()
                        else
                            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0, TextColor3 = Library.Theme.TextDark}):Play()
                        end
                    end
            
                    HeaderBtn.MouseButton1Click:Connect(function()
                        Toggle(not IsOpen)
                    end)
            
                    Toggle(IsOpen)
           
                    table.insert(ContainerStack, ChildContent)
                    
                    return true 
                end
            
                function BoxFuncs:TreePush()
                    local Parent = GetContainer()
                    local Indent = Instance.new("Frame", Parent)
                    Indent.Size = UDim2.new(1,0,0,0)
                    Indent.AutomaticSize = Enum.AutomaticSize.Y
                    Indent.BackgroundTransparency = 1
                    
                    local IL = Instance.new("UIListLayout", Indent)
                    IL.SortOrder = Enum.SortOrder.LayoutOrder
                    IL.Padding = UDim.new(0, 10)
                    
                    local IP = Instance.new("UIPadding", Indent)
                    IP.PaddingLeft = UDim.new(0, 20) 
                    
                    IL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                         Indent.Size = UDim2.new(1, 0, 0, IL.AbsoluteContentSize.Y)
                    end)
            
                    table.insert(ContainerStack, Indent)
                end
            
                function BoxFuncs:TreePop()
                    if #ContainerStack > 1 then
                        table.remove(ContainerStack)
                    end
                end
            
                function BoxFuncs:TreeNode(Label)
                    return TreeNodeBehavior(Label, {Framed = false})
                end
            
                function BoxFuncs:TreeNodeEx(Label, Flags)
                    return TreeNodeBehavior(Label, Flags or {})
                end
                
                function BoxFuncs:TreeNodeV(Label) return BoxFuncs:TreeNode(Label) end
                function BoxFuncs:TreeNodeExV(Label, Flags) return BoxFuncs:TreeNodeEx(Label, Flags) end
            
                function BoxFuncs:CollapsingHeader(Label)
                    return TreeNodeBehavior(Label, {Framed = true})
                end

                function BoxFuncs:AddLabel(Config)
                    local Text = type(Config) == "table" and Config.Title or Config
                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,15)
                    F.BackgroundTransparency=1
                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,0,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                end

                function BoxFuncs:AddTextUnformatted(Text)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 15)
                    F.BackgroundTransparency = 1
                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 1, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Code
                    Lb.TextSize = 12
                    Lb.TextColor3 = Color3.new(1,1,1) 
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                end

                function BoxFuncs:AddTextWrapped(Text)
                    local P = GetContainer()
                    local F = Instance.new("Frame", P)
                    F.BackgroundTransparency = 1
                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 1, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextColor3 = Library.Theme.Text
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Lb.TextWrapped = true
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local TextBounds = game:GetService("TextService"):GetTextSize(Text, 12, Enum.Font.Gotham, Vector2.new(P.AbsoluteSize.X - 20, 9999))
                    F.Size = UDim2.new(1, 0, 0, TextBounds.Y + 5)
                end

                function BoxFuncs:AddLabelText(Label, Value)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 15)
                    F.BackgroundTransparency = 1
                    local L1 = Instance.new("TextLabel", F)
                    L1.Size = UDim2.new(0.5, 0, 1, 0)
                    L1.BackgroundTransparency = 1
                    L1.Text = Label
                    L1.Font = Enum.Font.GothamBold
                    L1.TextSize = 12
                    L1.TextXAlignment = Enum.TextXAlignment.Left
                    L1.TextColor3 = Library.Theme.Text
                    Library:RegisterTheme(L1, "TextColor3", "Text")
                    local L2 = Instance.new("TextLabel", F)
                    L2.Size = UDim2.new(0.5, 0, 1, 0)
                    L2.Position = UDim2.new(0.5, 0, 0, 0)
                    L2.BackgroundTransparency = 1
                    L2.Text = tostring(Value)
                    L2.Font = Enum.Font.Gotham
                    L2.TextSize = 12
                    L2.TextXAlignment = Enum.TextXAlignment.Right
                    L2.TextColor3 = Library.Theme.Accent
                    Library:RegisterTheme(L2, "TextColor3", "Accent")
                end

                function BoxFuncs:AddBulletText(Text)
                    BoxFuncs:AddLabel(" • " .. Text)
                end

                function BoxFuncs:AddSeparator()
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 8) 
                    F.BackgroundTransparency = 1
                    local Line = Instance.new("Frame", F)
                    Line.Size = UDim2.new(1, 0, 0, 1)
                    Line.Position = UDim2.new(0, 0, 0.5, 0)
                    Line.BackgroundColor3 = Library.Theme.Outline
                    Line.BorderSizePixel = 0
                    Library:RegisterTheme(Line, "BackgroundColor3", "Outline")
                end

                function BoxFuncs:AddSpacing(Amount)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Amount or 10)
                    F.BackgroundTransparency = 1
                end

                function BoxFuncs:AddDummy(Height)
                    BoxFuncs:AddSpacing(Height)
                end

                function BoxFuncs:AddNewLine()
                    BoxFuncs:AddSpacing(5)
                end

                function BoxFuncs:AlignTextToFramePadding(Text)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 15)
                    F.BackgroundTransparency = 1
                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 1, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")
                    local P = Instance.new("UIPadding", F)
                    P.PaddingLeft = UDim.new(0, 5) 
                end
                
                function BoxFuncs:AddParagraph(Config)
                    local Head = Config.Title or "Paragraph"
                    local Cont = Config.Content or ""
                    local Wrapped = Config.TextWrapped ~= false 
                    local P = GetContainer()
                    
                    local F = Instance.new("Frame", P)
                    F.BackgroundTransparency = 1
                    F.Size = UDim2.new(1, 0, 0, 0)
                    
                    local H1 = Instance.new("TextLabel", F)
                    H1.Size = UDim2.new(1, 0, 0, 15)
                    H1.BackgroundTransparency = 1
                    H1.Text = Head
                    H1.Font = Enum.Font.GothamBold
                    H1.TextSize = 12
                    H1.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(H1, "TextColor3", "Text")
                    
                    local C1 = Instance.new("TextLabel", F)
                    C1.Position = UDim2.new(0, 0, 0, 20)
                    C1.BackgroundTransparency = 1
                    C1.Text = Cont
                    C1.Font = Enum.Font.Gotham
                    C1.TextSize = 11
                    C1.TextXAlignment = Enum.TextXAlignment.Left
                    C1.TextYAlignment = Enum.TextYAlignment.Top
                    C1.TextWrapped = Wrapped
                    Library:RegisterTheme(C1, "TextColor3", "TextDark")
                    
                    local WrapWidth = P.AbsoluteSize.X - 20
                    if WrapWidth < 50 then WrapWidth = 230 end
                    
                    local TextHeight = 15
                    if Wrapped then
                        local TextBounds = game:GetService("TextService"):GetTextSize(Cont, 11, Enum.Font.Gotham, Vector2.new(WrapWidth, 9999))
                        TextHeight = TextBounds.Y
                    end

                    C1.Size = UDim2.new(1, 0, 0, TextHeight)
                    F.Size = UDim2.new(1, 0, 0, TextHeight + 25)
                    
                    RegisterItem(Head, F)
                end

                function BoxFuncs:AddToggle(Config)
                    local Text = Config.Title or "Toggle"
                    local Default = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Risky = Config.Risky

                    local F=Instance.new("TextButton", GetContainer())
                    F.Size=UDim2.new(1,0,0,20)
                    F.BackgroundTransparency=1
                    F.Text=""
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,-45,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    if Risky then
                        Lb.TextColor3 = Color3.fromRGB(255, 80, 80)
                    else
                        Library:RegisterTheme(Lb,"TextColor3","Text")
                    end

                    local T=Instance.new("Frame",F)
                    T.Size=UDim2.new(0,34,0,18)
                    T.Position=UDim2.new(1,-34,0.5,-9)
                    T.BackgroundColor3=Default and Library.Theme.Accent or Library.Theme.ItemBackground
                    Library:RegisterTheme(T, "BackgroundColor3", Default and "Accent" or "ItemBackground")
                    
                    Instance.new("UICorner",T).CornerRadius=UDim.new(1,0)
                    local Cir=Instance.new("Frame",T)
                    Cir.Size=UDim2.new(0,14,0,14)
                    Cir.Position=Default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
                    Cir.BackgroundColor3=Library.Theme.Text
                    Instance.new("UICorner",Cir).CornerRadius=UDim.new(1,0)

                    local function Set(v)
                        Library.Flags[Flag]=v
                        TweenService:Create(Cir,TweenInfo.new(0.2, Enum.EasingStyle.Sine),{Position=v and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
                        if v then
                            TweenService:Create(T,TweenInfo.new(0.2, Enum.EasingStyle.Sine),{BackgroundColor3=Library.Theme.Accent}):Play()
                        else
                            TweenService:Create(T,TweenInfo.new(0.2, Enum.EasingStyle.Sine),{BackgroundColor3=Library.Theme.ItemBackground}):Play()
                        end
                        pcall(Callback,v)
                    end
                    Library.Items[Flag]={Set=Set}
                    F.MouseButton1Click:Connect(function() Set(not Library.Flags[Flag]) end)
                    Library.Flags[Flag]=Default

                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddCheckbox(Config)
                    local Text = Config.Title or "Checkbox"
                    local Default = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Risky = Config.Risky

                    local F = Instance.new("TextButton", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 20)
                    F.BackgroundTransparency = 1
                    F.Text = ""
                    if Desc then AddTooltip(F, Desc) end

                    local Box = Instance.new("Frame", F)
                    Box.Size = UDim2.new(0, 14, 0, 14)
                    Box.Position = UDim2.new(0, 0, 0.5, -8)
                    Box.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(Box, "BackgroundColor3", "ItemBackground") 
                    
                    local BoxStroke = Instance.new("UIStroke", Box)
                    BoxStroke.Color = Library.Theme.Outline
                    BoxStroke.Thickness = 1
                    Library:RegisterTheme(BoxStroke, "Color", "Outline")
                    
                    local Check = Instance.new("ImageLabel", Box)
                    Check.Size = UDim2.new(1, -2, 1, -2)
                    Check.Position = UDim2.new(0, 1, 0, 1)
                    Check.BackgroundTransparency = 1
                    Check.Image = "rbxassetid://3944680095" 
                    Check.ImageColor3 = Library.Theme.Accent
                    Library:RegisterTheme(Check, "ImageColor3", "Accent")
                    Check.Visible = Default

                    local Label = Instance.new("TextLabel", F)
                    Label.Size = UDim2.new(1, -25, 1, 0)
                    Label.Position = UDim2.new(0, 25, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = Text
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 13
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    
                    Label.TextColor3 = Default and Library.Theme.Text or Library.Theme.TextDark
                    if Default then
                        Library:RegisterTheme(Label, "TextColor3", "Text")
                    else
                        Library:RegisterTheme(Label, "TextColor3", "TextDark")
                    end

                    local function UpdateVisuals(IsHovering)
                        local targetColor = Library.Theme.ItemBackground
                        if IsHovering then
                            targetColor = Color3.fromRGB(
                                math.min(Library.Theme.ItemBackground.R * 255 + 20, 255),
                                math.min(Library.Theme.ItemBackground.G * 255 + 20, 255),
                                math.min(Library.Theme.ItemBackground.B * 255 + 20, 255)
                            )
                        end
                        TweenService:Create(Box, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = targetColor}):Play()
                        
                        if not Library.Flags[Flag] then
                             local txtColor = IsHovering and Library.Theme.Text or Library.Theme.TextDark
                             TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {TextColor3 = txtColor}):Play()
                        end
                    end

                    F.MouseEnter:Connect(function() UpdateVisuals(true) end)
                    F.MouseLeave:Connect(function() UpdateVisuals(false) end)

                    local function Set(v)
                        Library.Flags[Flag] = v
                        Check.Visible = v
                        
                        if v then
                            Label.TextColor3 = Library.Theme.Text
                        else
                            Label.TextColor3 = Library.Theme.TextDark
                        end
                        pcall(Callback, v)
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Default

                    F.MouseButton1Click:Connect(function() Set(not Library.Flags[Flag]) end)

                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddSlider(Config)
                    local Text = Config.Title or "Slider"
                    local Min = Config.Min or 0
                    local Max = Config.Max or 100
                    local Def = Config.Default or Min
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Rounding = Config.Rounding or 0
                    local Suffix = Config.Suffix or ""
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,38)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,0,0,15)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                    local Vl=Instance.new("TextLabel",F)
                    Vl.Size=UDim2.new(0,80,0,15)
                    Vl.Position=UDim2.new(1,-80,0,0)
                    Vl.BackgroundTransparency=1
                    Vl.Text=tostring(Def)..Suffix
                    Vl.Font=Enum.Font.Gotham
                    Vl.TextSize=12
                    Vl.TextXAlignment=Enum.TextXAlignment.Right
                    Library:RegisterTheme(Vl,"TextColor3","Accent")
                    local B=Instance.new("Frame",F)
                    B.Size=UDim2.new(1,0,0,5)
                    B.Position=UDim2.new(0,0,0,25)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)
                    local Fil=Instance.new("Frame",B)
                    Fil.Size=UDim2.new((Def-Min)/(Max-Min),0,1,0)
                    Library:RegisterTheme(Fil,"BackgroundColor3","Accent")
                    Instance.new("UICorner",Fil).CornerRadius=UDim.new(1,0)
                    local Btn=Instance.new("TextButton",F)
                    Btn.Size=UDim2.new(1,0,0,25)
                    Btn.Position=UDim2.new(0,0,0,15)
                    Btn.BackgroundTransparency=1
                    Btn.Text=""
                    
                    local function Set(v)
                        v=math.clamp(v,Min,Max)
                        if Rounding > 0 then
                            v = math.floor(v * (10^Rounding)) / (10^Rounding)
                        else
                            v = math.floor(v)
                        end
                        
                        Library.Flags[Flag]=v
                        Vl.Text=tostring(v)..Suffix
                        TweenService:Create(Fil,TweenInfo.new(0.1),{Size=UDim2.new((v-Min)/(Max-Min),0,1,0)}):Play()
                        pcall(Callback,v)
                    end
                    Library.Items[Flag]={Set=Set}
                    Library.Flags[Flag]=Def
                    local drag=false
                    local function Upd(i)
                        local x=math.clamp((i.Position.X-B.AbsolutePosition.X)/B.AbsoluteSize.X,0,1)
                        local newVal = ((Max-Min)*x)+Min
                        Set(newVal)
                    end
                    Btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true Upd(i) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
                    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Upd(i) end end)

                    RegisterItem(Text, F)
                end
                
                function BoxFuncs:AddColorPicker(Config)
                    local Text = Config.Title or "Color"
                    local Def = Config.Default or Color3.new(1,1,1)
                    local DefAlpha = Config.Transparency or 1
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 25)
                    F.BackgroundTransparency = 1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(0.6, 0, 1, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local P = Instance.new("TextButton", F)
                    P.Size = UDim2.new(0, 40, 0, 16)
                    P.Position = UDim2.new(1, -45, 0.5, -8)
                    P.BackgroundColor3 = Def
                    P.Text = ""
                    P.AutoButtonColor = false
                    Instance.new("UICorner", P).CornerRadius = UDim.new(0, 4)
                    
                    local PCheckers = Instance.new("ImageLabel", P)
                    PCheckers.Size = UDim2.new(1,0,1,0)
                    PCheckers.BackgroundTransparency = 1
                    PCheckers.Image = "rbxassetid://3887014957"
                    PCheckers.ImageTransparency = 0.5
                    PCheckers.ScaleType = Enum.ScaleType.Tile
                    PCheckers.TileSize = UDim2.new(0, 10, 0, 10)
                    PCheckers.ZIndex = 0

                    local Win = Instance.new("Frame", ScreenGui)
                    Win.Name = "ColorPickerWin"
                    Win.Size = UDim2.new(0, 220, 0, 230) -- КОМПАКТНЫЙ РАЗМЕР
                    Win.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    Win.Visible = false
                    Win.ZIndex = 200
                    Instance.new("UIStroke", Win).Color = Library.Theme.Outline
                    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 6)
                    
                    -- SV Square (100px height)
                    local SV = Instance.new("ImageButton", Win)
                    SV.Size = UDim2.new(1, -20, 0, 100)
                    SV.Position = UDim2.new(0, 10, 0, 10)
                    SV.BackgroundColor3 = Color3.fromHSV(0, 1, 1) 
                    SV.Image = "rbxassetid://4155801252"
                    SV.ZIndex = 205
                    Instance.new("UICorner", SV).CornerRadius = UDim.new(0, 4)

                    local PickerDot = Instance.new("Frame", SV)
                    PickerDot.Size = UDim2.new(0, 6, 0, 6)
                    PickerDot.BackgroundColor3 = Color3.new(1,1,1)
                    PickerDot.ZIndex = 206
                    PickerDot.AnchorPoint = Vector2.new(0.5, 0.5)
                    Instance.new("UICorner", PickerDot).CornerRadius = UDim.new(1,0)
                    Instance.new("UIStroke", PickerDot).Thickness = 1

                    -- Bars (10px height)
                    local HueFrame = Instance.new("ImageButton", Win)
                    HueFrame.Size = UDim2.new(1, -20, 0, 10)
                    HueFrame.Position = UDim2.new(0, 10, 0, 115)
                    HueFrame.BackgroundColor3 = Color3.new(1,1,1)
                    HueFrame.Image = ""
                    HueFrame.ZIndex = 205
                    Instance.new("UICorner", HueFrame).CornerRadius = UDim.new(0, 2)
                    local HueGrad = Instance.new("UIGradient", HueFrame)
                    HueGrad.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                    }
                    local HueSlide = Instance.new("Frame", HueFrame)
                    HueSlide.Size = UDim2.new(0, 3, 1, 0)
                    HueSlide.BackgroundColor3 = Color3.new(1,1,1)
                    HueSlide.BorderColor3 = Color3.new(0,0,0)
                    HueSlide.BorderSizePixel = 1
                    HueSlide.ZIndex = 206
                    HueSlide.AnchorPoint = Vector2.new(0.5, 0)

                    local AlphaFrame = Instance.new("ImageButton", Win)
                    AlphaFrame.Size = UDim2.new(1, -20, 0, 10)
                    AlphaFrame.Position = UDim2.new(0, 10, 0, 130)
                    AlphaFrame.BackgroundColor3 = Color3.new(1,1,1)
                    AlphaFrame.Image = ""
                    AlphaFrame.ZIndex = 205
                    Instance.new("UICorner", AlphaFrame).CornerRadius = UDim.new(0, 2)
                    local AlphaCheck = PCheckers:Clone()
                    AlphaCheck.Parent = AlphaFrame
                    AlphaCheck.ImageTransparency = 0
                    AlphaCheck.ZIndex = 204
                    local AlphaOverlay = Instance.new("Frame", AlphaFrame)
                    AlphaOverlay.Size = UDim2.new(1,0,1,0)
                    AlphaOverlay.BackgroundColor3 = Def
                    AlphaOverlay.BorderSizePixel = 0
                    AlphaOverlay.ZIndex = 205
                    Instance.new("UICorner", AlphaOverlay).CornerRadius = UDim.new(0, 2)
                    local AlphaGrad = Instance.new("UIGradient", AlphaOverlay)
                    AlphaGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                    local AlphaSlide = Instance.new("Frame", AlphaFrame)
                    AlphaSlide.Size = UDim2.new(0, 3, 1, 0)
                    AlphaSlide.BackgroundColor3 = Color3.new(1,1,1)
                    AlphaSlide.BorderColor3 = Color3.new(0,0,0)
                    AlphaSlide.BorderSizePixel = 1
                    AlphaSlide.ZIndex = 206
                    AlphaSlide.AnchorPoint = Vector2.new(0.5, 0)

                    -- Compact Inputs
                    local InputContainer = Instance.new("Frame", Win)
                    InputContainer.Size = UDim2.new(1, -20, 0, 75)
                    InputContainer.Position = UDim2.new(0, 10, 0, 150)
                    InputContainer.BackgroundTransparency = 1
                    InputContainer.ZIndex = 210

                    local HexBox = Instance.new("TextBox", InputContainer)
                    HexBox.Size = UDim2.new(1, 0, 0, 20)
                    HexBox.Position = UDim2.new(0, 0, 0, 0)
                    HexBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    HexBox.TextColor3 = Color3.new(1,1,1)
                    HexBox.Text = Library:ToHex(Def)
                    HexBox.Font = Enum.Font.Code
                    HexBox.TextSize = 12
                    HexBox.PlaceholderText = "#HEX"
                    HexBox.ZIndex = 211
                    Instance.new("UICorner", HexBox).CornerRadius = UDim.new(0, 4)
                    Instance.new("UIStroke", HexBox).Color = Color3.fromRGB(60,60,60)

                    local RBox, GBox, BBox, ABox
                    local function CreateBox(ID, XOffset)
                        local Box = Instance.new("TextBox", InputContainer)
                        Box.Size = UDim2.new(0.22, 0, 0, 20)
                        Box.Position = UDim2.new(XOffset, 0, 0, 25)
                        Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        Box.TextColor3 = Color3.new(1,1,1)
                        Box.Text = "0"
                        Box.Font = Enum.Font.Code
                        Box.TextSize = 12
                        Box.ZIndex = 211
                        Box.PlaceholderText = ID
                        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
                        Instance.new("UIStroke", Box).Color = Color3.fromRGB(60,60,60)
                        return Box
                    end
                    RBox = CreateBox("R", 0)
                    GBox = CreateBox("G", 0.26)
                    BBox = CreateBox("B", 0.52)
                    ABox = CreateBox("A", 0.78)
                    
                    -- Logic (копируем из предыдущего ответа, она рабочая)
                    local ColorH, ColorS, ColorV = Def:ToHSV()
                    local Alpha = DefAlpha
                    local Updating = false
                    
                    local function UpdateVisuals()
                        local CurrentColor = Color3.fromHSV(ColorH, ColorS, ColorV)
                        P.BackgroundColor3 = CurrentColor
                        P.BackgroundTransparency = 1 - Alpha
                        SV.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
                        AlphaOverlay.BackgroundColor3 = CurrentColor
                        PickerDot.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
                        HueSlide.Position = UDim2.new(ColorH, 0, 0, 0)
                        AlphaSlide.Position = UDim2.new(Alpha, 0, 0, 0)
                        if not Updating then
                            Updating = true
                            HexBox.Text = Library:ToHex(CurrentColor)
                            RBox.Text = tostring(math.floor(CurrentColor.R * 255))
                            GBox.Text = tostring(math.floor(CurrentColor.G * 255))
                            BBox.Text = tostring(math.floor(CurrentColor.B * 255))
                            ABox.Text = tostring(math.floor(Alpha * 255))
                            Updating = false
                        end
                        Library.Flags[Flag] = {R = CurrentColor.R, G = CurrentColor.G, B = CurrentColor.B, Alpha = Alpha, Hex = HexBox.Text}
                        pcall(Callback, CurrentColor, Alpha)
                    end
                    
                    -- ... (Event Handlers для Inputs и Drags - те же самые, что в прошлом ответе, просто скопируй)
                    local function UpdateFromInputs()
                        if Updating then return end
                        Updating = true
                        local R = math.clamp(tonumber(RBox.Text) or 0, 0, 255)
                        local G = math.clamp(tonumber(GBox.Text) or 0, 0, 255)
                        local B = math.clamp(tonumber(BBox.Text) or 0, 0, 255)
                        local A = math.clamp(tonumber(ABox.Text) or 255, 0, 255)
                        Alpha = A / 255
                        local NewCol = Color3.fromRGB(R, G, B)
                        ColorH, ColorS, ColorV = NewCol:ToHSV()
                        UpdateVisuals()
                        Updating = false
                    end

                    local function UpdateFromHex()
                        if Updating then return end
                        Updating = true
                        local NewCol = Library:FromHex(HexBox.Text)
                        if NewCol then
                            ColorH, ColorS, ColorV = NewCol:ToHSV()
                            UpdateVisuals()
                        end
                        Updating = false
                    end

                    RBox.FocusLost:Connect(UpdateFromInputs)
                    GBox.FocusLost:Connect(UpdateFromInputs)
                    BBox.FocusLost:Connect(UpdateFromInputs)
                    ABox.FocusLost:Connect(UpdateFromInputs)
                    HexBox.FocusLost:Connect(UpdateFromHex)

                    local function HandleInput(Input, Mode)
                        if Mode == "SV" then
                            local X = math.clamp((Input.Position.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1)
                            local Y = math.clamp((Input.Position.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1)
                            ColorS = X
                            ColorV = 1 - Y
                        elseif Mode == "Hue" then
                            local X = math.clamp((Input.Position.X - HueFrame.AbsolutePosition.X) / HueFrame.AbsoluteSize.X, 0, 1)
                            ColorH = X
                        elseif Mode == "Alpha" then
                            local X = math.clamp((Input.Position.X - AlphaFrame.AbsolutePosition.X) / AlphaFrame.AbsoluteSize.X, 0, 1)
                            Alpha = X
                        end
                        UpdateVisuals()
                    end

                    local Dragging = nil
                    local function InputBegan(Obj, Mode)
                        Obj.InputBegan:Connect(function(i) if i.UserInputType.Name:match("MouseButton1") or i.UserInputType.Name:match("Touch") then Dragging = Mode HandleInput(i, Mode) end end)
                    end
                    InputBegan(SV, "SV") InputBegan(HueFrame, "Hue") InputBegan(AlphaFrame, "Alpha")

                    UserInputService.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then HandleInput(i, Dragging) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:match("MouseButton1") or i.UserInputType.Name:match("Touch") then Dragging = nil end end)

                    P.MouseButton1Click:Connect(function()
                        if Win.Visible then Win.Visible = false Library.ActivePicker = nil else
                            if Library.ActivePicker then Library.ActivePicker.Visible = false end
                            Win.Visible = true
                            -- Smart pos
                            local Abs = P.AbsolutePosition
                            local WX, WY = Abs.X + 50, Abs.Y - 50
                            if WX + 220 > workspace.CurrentCamera.ViewportSize.X then WX = Abs.X - 230 end
                            if WY + 230 > workspace.CurrentCamera.ViewportSize.Y then WY = workspace.CurrentCamera.ViewportSize.Y - 240 end
                            if WY < 0 then WY = 10 end
                            Win.Position = UDim2.new(0, WX, 0, WY)
                            Library.ActivePicker = Win
                        end
                    end)

                    Library.Flags[Flag] = {R = Def.R, G = Def.G, B = Def.B, Alpha = DefAlpha, Hex = Library:ToHex(Def)}
                    UpdateVisuals()
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddDropdown(Config)
                    local Text = Config.Title or "Dropdown"
                    local Opt = Config.Values or {}
                    local Default = Config.Default
                    local Callback = Config.Callback or function() end
                    local Multi = Config.Multi or false
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,40)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,0,15)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(1,0,0,22)
                    B.Position=UDim2.new(0,0,0,18)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    B.TextColor3=Color3.fromRGB(200,200,200)
                    B.TextXAlignment=Enum.TextXAlignment.Left
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    
                    local List=Instance.new("ScrollingFrame",ScreenGui)
                    List.Visible=false
                    List.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(List, "BackgroundColor3", "ItemBackground")
                    List.BorderSizePixel=0
                    List.ZIndex=200 
                    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    Instance.new("UIStroke",List).Color=Library.Theme.Outline
                    local LL=Instance.new("UIListLayout",List)
                    LL.SortOrder=Enum.SortOrder.LayoutOrder

                    if not Multi then
                        B.Text = "  " .. (Default or "Select...")
                        local function Set(v)
                            B.Text="  "..v
                            Library.Flags[Flag]=v
                            pcall(Callback,v)
                            List.Visible=false
                            DropdownHolder.Visible=false
                            CheckActivePicker()
                        end
                        
                        Library.Items[Flag]={Set=Set, Refresh=function(New)
                            for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                            for _,v in pairs(New) do
                                local bt=Instance.new("TextButton",List)
                                bt.Size=UDim2.new(1,0,0,25)
                                bt.BackgroundTransparency=1
                                bt.Text=v
                                bt.TextColor3=Color3.fromRGB(200,200,200)
                                bt.Font=Enum.Font.Gotham
                                bt.TextSize=12
                                bt.ZIndex = 205
                                bt.MouseButton1Click:Connect(function() Set(v) end)
                            end
                        end}
                        Library.Items[Flag].Refresh(Opt)
                        if Default then Set(Default) end

                        B.MouseButton1Click:Connect(function()
                            if List.Visible then List.Visible=false DropdownHolder.Visible=false else
                                CheckActivePicker()
                                List.Position=UDim2.new(0,B.AbsolutePosition.X,0,B.AbsolutePosition.Y+25)
                                local ContentH = LL.AbsoluteContentSize.Y
                                List.Size=UDim2.new(0,B.AbsoluteSize.X,0,math.min(ContentH, 150))
                                List.CanvasSize=UDim2.new(0,0,0,ContentH)
                                List.Visible=true
                                DropdownHolder.Visible=true
                            end
                        end)

                    else
                        local Sel={}
                        if type(Default) == "table" then
                            for _, val in pairs(Default) do Sel[val] = true end
                        end
                        
                        Library.Flags[Flag]=Sel
                        
                        local function Upd()
                            local t={} for k,v in pairs(Sel) do if v then table.insert(t,k) end end
                            B.Text=#t==0 and "  None" or (#t==1 and "  "..t[1] or "  "..#t.." Selected")
                            pcall(Callback,Sel)
                        end
                        Upd()

                        for _,v in pairs(Opt) do
                            local bt=Instance.new("TextButton",List)
                            bt.Size=UDim2.new(1,0,0,25)
                            bt.BackgroundTransparency=1
                            bt.Text=v
                            bt.TextColor3=Color3.fromRGB(200,200,200)
                            bt.Font=Enum.Font.Gotham
                            bt.TextSize=12
                            bt.ZIndex = 205 
                            bt.MouseButton1Click:Connect(function()
                                Sel[v]=not Sel[v]
                                bt.TextColor3=Sel[v] and Library.Theme.Accent or Color3.fromRGB(200,200,200)
                                Upd()
                            end)
                            if Sel[v] then bt.TextColor3 = Library.Theme.Accent end
                        end
                        
                        B.MouseButton1Click:Connect(function()
                            if List.Visible then List.Visible=false DropdownHolder.Visible=false else
                                CheckActivePicker()
                                List.Position=UDim2.new(0,B.AbsolutePosition.X,0,B.AbsolutePosition.Y+25)
                                local ContentH = LL.AbsoluteContentSize.Y
                                List.Size=UDim2.new(0,B.AbsoluteSize.X,0,math.min(ContentH, 150))
                                List.CanvasSize=UDim2.new(0,0,0,ContentH)
                                List.Visible=true
                                DropdownHolder.Visible=true
                            end
                        end)
                    end

                    DropdownHolder.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then List.Visible=false DropdownHolder.Visible=false end end)
                    
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddKeybind(Config)
                    local Text = Config.Title or "Keybind"
                    local Def = Config.Default or Enum.KeyCode.RightShift
                    local Call = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,20)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,1,0)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(0,60,0,18)
                    B.Position=UDim2.new(1,-60,0.5,-9)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Text=Def.Name
                    B.Font=Enum.Font.Gotham
                    B.TextSize=11
                    B.TextColor3=Color3.fromRGB(200,200,200)
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    local bind=false
                    B.MouseButton1Click:Connect(function() bind=true B.Text="..." end)
                    UserInputService.InputBegan:Connect(function(i) if bind and i.UserInputType==Enum.UserInputType.Keyboard then bind=false B.Text=i.KeyCode.Name pcall(Call,i.KeyCode) end end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddTextbox(Config)
                    local Text = Config.Title or "Textbox"
                    local Ph = Config.Placeholder or ""
                    local Call = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Clear = Config.ClearOnFocus

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,40)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,0,15)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextBox",F)
                    B.Size=UDim2.new(1,0,0,20)
                    B.Position=UDim2.new(0,0,0,18)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Text=""
                    B.PlaceholderText=Ph
                    B.TextColor3=Color3.fromRGB(230,230,230)
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    B.ClearTextOnFocus = Clear or false
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    B.FocusLost:Connect(function() Library.Flags[Flag]=B.Text pcall(Call,B.Text) end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddButton(Config)
                    local Text = Config.Title or "Button"
                    local Call = Config.Callback or function() end
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,32)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end
                    
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(1,0,1,0)
                    B.BackgroundColor3=Library.Theme.ItemBackground 
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Text=Text
                    B.TextColor3=Library.Theme.Text
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    B.MouseButton1Click:Connect(function()
                        TweenService:Create(B,TweenInfo.new(0.1),{BackgroundColor3=Library.Theme.Accent}):Play()
                        wait(0.1)
                        TweenService:Create(B,TweenInfo.new(0.1),{BackgroundColor3=Library.Theme.ItemBackground}):Play()
                        pcall(Call)
                    end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddProgressBar(Config)
                    local Text = Config.Title or "Progress"
                    local Default = Config.Default or 0
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 35)
                    F.BackgroundTransparency = 1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local BarBack = Instance.new("Frame", F)
                    BarBack.Name = "BarBackground"
                    BarBack.Size = UDim2.new(1, 0, 0, 14)
                    BarBack.Position = UDim2.new(0, 0, 0, 20)
                    BarBack.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(BarBack, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", BarBack).CornerRadius = UDim.new(0, 4)

                    local BarFill = Instance.new("Frame", BarBack)
                    BarFill.Name = "BarFill"
                    BarFill.Size = UDim2.new(math.clamp(Default, 0, 1), 0, 1, 0)
                    BarFill.BackgroundColor3 = Library.Theme.Accent
                    BarFill.BorderSizePixel = 0
                    Library:RegisterTheme(BarFill, "BackgroundColor3", "Accent")
                    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 4)

                    local PercentText = Instance.new("TextLabel", BarBack)
                    PercentText.Size = UDim2.new(1, 0, 1, 0)
                    PercentText.BackgroundTransparency = 1
                    PercentText.Font = Enum.Font.GothamBold
                    PercentText.TextSize = 10
                    PercentText.Text = math.floor(math.clamp(Default, 0, 1) * 100) .. "%"
                    PercentText.TextColor3 = Library.Theme.Text
                    PercentText.ZIndex = 2
                    Library:RegisterTheme(PercentText, "TextColor3", "Text")

                    local function Set(val)
                        val = math.clamp(val, 0, 1)
                        Library.Flags[Flag] = val
                        PercentText.Text = math.floor(val * 100) .. "%"
                        TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(val, 0, 1, 0)}):Play()
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Default
                    
                    RegisterItem(Text, F)
                end

                -- [ImGui: Image]
                function BoxFuncs:AddImage(Config)
                    local ImageId = Config.Image or "" -- rbxassetid://...
                    local Size = Config.Size or UDim2.new(0, 100, 0, 100)
                    local Desc = Config.Description
                    
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Size.Y.Offset + 5)
                    F.BackgroundTransparency = 1
                    
                    local Img = Instance.new("ImageLabel", F)
                    Img.Size = Size
                    Img.Position = UDim2.new(0.5, -Size.X.Offset/2, 0, 0)
                    Img.BackgroundTransparency = 1
                    Img.Image = ImageId
                    if Desc then AddTooltip(Img, Desc) end
                    
                    RegisterItem("Image", F)
                end

                -- [ImGui: ImageButton]
                function BoxFuncs:AddImageButton(Config)
                    local ImageId = Config.Image or ""
                    local Callback = Config.Callback or function() end
                    local Size = Config.Size or UDim2.new(0, 50, 0, 50)
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Size.Y.Offset + 5)
                    F.BackgroundTransparency = 1

                    local Btn = Instance.new("ImageButton", F)
                    Btn.Size = Size
                    Btn.Position = UDim2.new(0.5, -Size.X.Offset/2, 0, 0)
                    Btn.BackgroundColor3 = Library.Theme.ItemBackground
                    Btn.Image = ImageId
                    Library:RegisterTheme(Btn, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                    
                    if Desc then AddTooltip(Btn, Desc) end

                    Btn.MouseButton1Click:Connect(function()
                        TweenService:Create(Btn, TweenInfo.new(0.1), {ImageColor3 = Library.Theme.Accent}):Play()
                        task.wait(0.1)
                        TweenService:Create(Btn, TweenInfo.new(0.1), {ImageColor3 = Color3.new(1,1,1)}):Play()
                        pcall(Callback)
                    end)

                    RegisterItem("ImageButton", F)
                end

                -- [ImGui: RadioButton]
                function BoxFuncs:AddRadioButton(Config)
                    local Text = Config.Title or "Radio Button"
                    local Options = Config.Options or {}
                    local Default = Config.Default or Options[1]
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 0)
                    F.AutomaticSize = Enum.AutomaticSize.Y
                    F.BackgroundTransparency = 1

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local OptionButtons = {}
                    local CurrentValue = Default

                    local OptContainer = Instance.new("Frame", F)
                    OptContainer.Size = UDim2.new(1, 0, 0, 0)
                    OptContainer.Position = UDim2.new(0, 0, 0, 20)
                    OptContainer.AutomaticSize = Enum.AutomaticSize.Y
                    OptContainer.BackgroundTransparency = 1
                    
                    local UIList = Instance.new("UIListLayout", OptContainer)
                    UIList.Padding = UDim.new(0, 5)

                    local function UpdateState(val)
                        CurrentValue = val
                        Library.Flags[Flag] = val
                        for _, btnData in pairs(OptionButtons) do
                            local isSelected = (btnData.Value == val)
                            local circleInner = btnData.Obj:FindFirstChild("InnerCircle", true)
                            if circleInner then
                                circleInner.Visible = isSelected
                            end
                            local txt = btnData.Obj:FindFirstChild("Label", true)
                            if txt then
                                TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = isSelected and Library.Theme.Text or Library.Theme.TextDark}):Play()
                            end
                        end
                        pcall(Callback, val)
                    end

                    for _, opt in ipairs(Options) do
                        local OptBtn = Instance.new("TextButton", OptContainer)
                        OptBtn.Size = UDim2.new(1, 0, 0, 20)
                        OptBtn.BackgroundTransparency = 1
                        OptBtn.Text = ""
                        
                        local OuterCircle = Instance.new("Frame", OptBtn)
                        OuterCircle.Size = UDim2.new(0, 14, 0, 14)
                        OuterCircle.Position = UDim2.new(0, 0, 0.5, -7)
                        OuterCircle.BackgroundColor3 = Library.Theme.ItemBackground
                        Instance.new("UICorner", OuterCircle).CornerRadius = UDim.new(1, 0)
                        Library:RegisterTheme(OuterCircle, "BackgroundColor3", "ItemBackground")
                        local Stroke = Instance.new("UIStroke", OuterCircle)
                        Stroke.Color = Library.Theme.Outline
                        Stroke.Thickness = 1
                        Library:RegisterTheme(Stroke, "Color", "Outline")

                        local InnerCircle = Instance.new("Frame", OuterCircle)
                        InnerCircle.Name = "InnerCircle"
                        InnerCircle.Size = UDim2.new(0, 8, 0, 8)
                        InnerCircle.Position = UDim2.new(0.5, -4, 0.5, -4)
                        InnerCircle.BackgroundColor3 = Library.Theme.Accent
                        InnerCircle.Visible = false
                        Instance.new("UICorner", InnerCircle).CornerRadius = UDim.new(1, 0)
                        Library:RegisterTheme(InnerCircle, "BackgroundColor3", "Accent")

                        local OptLabel = Instance.new("TextLabel", OptBtn)
                        OptLabel.Name = "Label"
                        OptLabel.Size = UDim2.new(1, -20, 1, 0)
                        OptLabel.Position = UDim2.new(0, 20, 0, 0)
                        OptLabel.BackgroundTransparency = 1
                        OptLabel.Text = tostring(opt)
                        OptLabel.Font = Enum.Font.Gotham
                        OptLabel.TextSize = 12
                        OptLabel.TextXAlignment = Enum.TextXAlignment.Left
                        OptLabel.TextColor3 = Library.Theme.TextDark
                        Library:RegisterTheme(OptLabel, "TextColor3", "TextDark")

                        OptBtn.MouseButton1Click:Connect(function()
                            UpdateState(opt)
                        end)

                        table.insert(OptionButtons, {Obj = OptBtn, Value = opt})
                    end
                    
                    UpdateState(Default)
                    Library.Items[Flag] = {Set = UpdateState}
                    
                    F.Size = UDim2.new(1, 0, 0, 25 + (#Options * 25))
                    RegisterItem(Text, F)
                end

                -- [ImGui: PlotHistogram]
                function BoxFuncs:AddGraph(Config)
                    local Text = Config.Title or "Graph"
                    local Values = Config.Values or {}
                    local Height = Config.Height or 60
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Height + 20)
                    F.BackgroundTransparency = 1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local GraphBox = Instance.new("Frame", F)
                    GraphBox.Size = UDim2.new(1, 0, 0, Height)
                    GraphBox.Position = UDim2.new(0, 0, 0, 20)
                    GraphBox.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(GraphBox, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", GraphBox).CornerRadius = UDim.new(0, 4)
                    local Stroke = Instance.new("UIStroke", GraphBox)
                    Stroke.Color = Library.Theme.Outline
                    Stroke.Thickness = 1
                    Library:RegisterTheme(Stroke, "Color", "Outline")

                    local GraphContainer = Instance.new("Frame", GraphBox)
                    GraphContainer.Size = UDim2.new(1, -4, 1, -4)
                    GraphContainer.Position = UDim2.new(0, 2, 0, 2)
                    GraphContainer.BackgroundTransparency = 1
                    
                    local Layout = Instance.new("UIListLayout", GraphContainer)
                    Layout.FillDirection = Enum.FillDirection.Horizontal
                    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                    Layout.Padding = UDim.new(0, 1)

                    local function UpdateGraph(NewValues)
                        for _, v in pairs(GraphContainer:GetChildren()) do
                            if v:IsA("Frame") then v:Destroy() end
                        end
                        
                        if #NewValues == 0 then return end
                        local BarWidth = (GraphContainer.AbsoluteSize.X / #NewValues) - 1
                        if BarWidth < 1 then BarWidth = 1 end

                        local MaxVal = 0
                        for _, v in ipairs(NewValues) do if v > MaxVal then MaxVal = v end end
                        if MaxVal == 0 then MaxVal = 1 end

                        for _, val in ipairs(NewValues) do
                            local Bar = Instance.new("Frame", GraphContainer)
                            Bar.Size = UDim2.new(0, BarWidth, val / MaxVal, 0)
                            Bar.BackgroundColor3 = Library.Theme.Accent
                            Bar.BorderSizePixel = 0
                            Library:RegisterTheme(Bar, "BackgroundColor3", "Accent")
                            
                            local ValTip = Instance.new("TextLabel", Bar)
                            ValTip.Visible = false
                            ValTip.Size = UDim2.new(0, 50, 0, 15)
                            ValTip.Position = UDim2.new(0.5, -25, 0, -15)
                            ValTip.BackgroundColor3 = Library.Theme.Background
                            ValTip.TextColor3 = Library.Theme.Text
                            ValTip.TextSize = 8
                            ValTip.Text = tostring(math.floor(val*10)/10)
                            
                            Bar.MouseEnter:Connect(function() 
                                TweenService:Create(Bar, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
                                ValTip.Visible = true 
                            end)
                            Bar.MouseLeave:Connect(function() 
                                TweenService:Create(Bar, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
                                ValTip.Visible = false 
                            end)
                        end
                    end

                    UpdateGraph(Values)
                    Library.Items[Text] = {Set = UpdateGraph}

                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddVerticalSlider(Config)
                    local Text = Config.Title or "V.Slider"
                    local Min = Config.Min or 0
                    local Max = Config.Max or 100
                    local Def = Config.Default or Min
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Height = Config.Height or 100
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Height + 25)
                    F.BackgroundTransparency = 1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Center
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local SliderBg = Instance.new("Frame", F)
                    SliderBg.Name = "SliderBackground"
                    SliderBg.Size = UDim2.new(0, 20, 0, Height)
                    SliderBg.Position = UDim2.new(0.5, -10, 0, 20)
                    SliderBg.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(SliderBg, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 4)

                    local SliderFill = Instance.new("Frame", SliderBg)
                    SliderFill.Name = "SliderFill"
                    SliderFill.AnchorPoint = Vector2.new(0, 1)
                    SliderFill.Position = UDim2.new(0, 0, 1, 0)
                    SliderFill.Size = UDim2.new(1, 0, (Def - Min) / (Max - Min), 0)
                    SliderFill.BackgroundColor3 = Library.Theme.Accent
                    SliderFill.BorderSizePixel = 0
                    Library:RegisterTheme(SliderFill, "BackgroundColor3", "Accent")
                    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 4)

                    local ValText = Instance.new("TextLabel", SliderBg)
                    ValText.Size = UDim2.new(2, 0, 1, 0)
                    ValText.Position = UDim2.new(-0.5, 0, 0, 0)
                    ValText.BackgroundTransparency = 1
                    ValText.Font = Enum.Font.GothamBold
                    ValText.TextSize = 10
                    ValText.Text = tostring(math.floor(Def * 100)/100)
                    ValText.TextColor3 = Library.Theme.Text
                    ValText.TextStrokeTransparency = 0.5
                    ValText.ZIndex = 3
                    
                    local Btn = Instance.new("TextButton", SliderBg)
                    Btn.Size = UDim2.new(1, 0, 1, 0)
                    Btn.BackgroundTransparency = 1
                    Btn.Text = ""

                    local function Set(v)
                        v = math.clamp(v, Min, Max)
                        v = math.floor(v * 100) / 100
                        
                        Library.Flags[Flag] = v
                        ValText.Text = tostring(v)
                        
                        local percent = (v - Min) / (Max - Min)
                        TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, percent, 0)}):Play()
                        
                        pcall(Callback, v)
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Def

                    local dragging = false
                    local function UpdateInput(input)
                        local bottomY = SliderBg.AbsolutePosition.Y + SliderBg.AbsoluteSize.Y
                        local mouseY = input.Position.Y
                        
                        local distFromBottom = bottomY - mouseY
                        local percent = math.clamp(distFromBottom / SliderBg.AbsoluteSize.Y, 0, 1)
                        
                        local newVal = Min + (Max - Min) * percent
                        Set(newVal)
                    end

                    Btn.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            UpdateInput(input)
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            UpdateInput(input)
                        end
                    end)

                    RegisterItem(Text, F)
                end
                
                --// EXTENSION: KEYBIND LIST //--
function Library:InitKeybindList()
    local ScreenGui = Library.WatermarkObj and Library.WatermarkObj.Parent or CoreGui
    
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = "KeybindList"
    KeybindFrame.Size = UDim2.new(0, 150, 0, 22)
    KeybindFrame.Position = UDim2.new(0.01, 0, 0.4, 0) -- Позиция слева
    KeybindFrame.BackgroundColor3 = Library.Theme.Background
    KeybindFrame.Visible = false -- Скрыто по умолчанию, пока нет активных биндов
    KeybindFrame.Parent = ScreenGui.Parent:FindFirstChild("RedOnyx") or ScreenGui
    
    Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 4)
    
    -- Обводка и шапка
    local Stroke = Instance.new("UIStroke", KeybindFrame)
    Stroke.Thickness = 1
    Stroke.Color = Library.Theme.Outline
    Library:RegisterTheme(Stroke, "Color", "Outline")
    Library:RegisterTheme(KeybindFrame, "BackgroundColor3", "Background")

    local TopLine = Instance.new("Frame", KeybindFrame)
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    TopLine.BackgroundColor3 = Library.Theme.Accent
    TopLine.Parent = KeybindFrame
    Library:RegisterTheme(TopLine, "BackgroundColor3", "Accent")

    local Title = Instance.new("TextLabel", KeybindFrame)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Keybinds"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextColor3 = Library.Theme.Text
    Title.Parent = KeybindFrame
    Library:RegisterTheme(Title, "TextColor3", "Text")

    -- Контейнер для списка
    local ListHolder = Instance.new("Frame", KeybindFrame)
    ListHolder.Name = "Holder"
    ListHolder.Size = UDim2.new(1, 0, 0, 0)
    ListHolder.Position = UDim2.new(0, 0, 1, 2)
    ListHolder.BackgroundTransparency = 1
    ListHolder.Parent = KeybindFrame

    local UIList = Instance.new("UIListLayout", ListHolder)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 2)

    -- Функция обновления списка (вызывать в RenderStepped)
    local function UpdateList()
        -- Очищаем старые
        for _, v in pairs(ListHolder:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end

        local ActiveCount = 0
        
        -- Проверяем все флаги
        for Flag, Value in pairs(Library.Flags) do
            -- Показываем, если это boolean true (Toggle) или если это зажатая клавиша (тут нужна доп. логика для Keybinds Held, но для Toggles сработает)
            if Value == true and Flag ~= "WatermarkToggle" and Flag ~= "MenuToggleKey" then
                ActiveCount = ActiveCount + 1
                
                local ItemFrame = Instance.new("Frame", ListHolder)
                ItemFrame.Size = UDim2.new(1, 0, 0, 18)
                ItemFrame.BackgroundColor3 = Library.Theme.Groupbox -- Немного светлее фона
                ItemFrame.BackgroundTransparency = 0.5
                Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 3)

                local Lb = Instance.new("TextLabel", ItemFrame)
                Lb.Size = UDim2.new(1, -10, 1, 0)
                Lb.Position = UDim2.new(0, 5, 0, 0)
                Lb.BackgroundTransparency = 1
                Lb.Text = tostring(Flag) -- Или искать красивое имя из Registry
                Lb.Font = Enum.Font.Gotham
                Lb.TextSize = 11
                Lb.TextColor3 = Library.Theme.Text
                Lb.TextXAlignment = Enum.TextXAlignment.Left
                
                local State = Instance.new("TextLabel", ItemFrame)
                State.Size = UDim2.new(1, -5, 1, 0)
                State.BackgroundTransparency = 1
                State.Text = "[ON]"
                State.Font = Enum.Font.GothamBold
                State.TextSize = 10
                State.TextColor3 = Library.Theme.Accent
                State.TextXAlignment = Enum.TextXAlignment.Right
            end
        end

        KeybindFrame.Visible = (ActiveCount > 0)
        -- Ресайз самого списка нет, но визуально это выглядит как выпадающий список
    end

    -- Перетаскивание
    local dragging, dragInput, dragStart, startPos
    KeybindFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = KeybindFrame.Position
        end
    end)
    KeybindFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            KeybindFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Запуск цикла обновления
    RunService.RenderStepped:Connect(UpdateList)
end

                -- [ImGui: Selectable]
                function BoxFuncs:AddSelectable(Config)
                    local Text = Config.Title or "Selectable"
                    local Selected = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F = Instance.new("TextButton", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 22)
                    F.BackgroundTransparency = Selected and 0 or 1
                    F.BackgroundColor3 = Library.Theme.Accent
                    F.Text = ""
                    F.AutoButtonColor = false
                    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
                    
                    if Desc then AddTooltip(F, Desc) end

                    Library:RegisterTheme(F, "BackgroundColor3", "Accent") 

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, -10, 1, 0)
                    Lb.Position = UDim2.new(0, 10, 0, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Lb.TextColor3 = Selected and Library.Theme.Text or Library.Theme.TextDark
                    
                    local function UpdateVisuals(isHovered, isSelected)
                        if isSelected then
                            TweenService:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
                            TweenService:Create(Lb, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
                        elseif isHovered then
                            TweenService:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
                            TweenService:Create(Lb, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
                        else
                            TweenService:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(Lb, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play()
                        end
                    end

                    F.MouseEnter:Connect(function() UpdateVisuals(true, Library.Flags[Flag]) end)
                    F.MouseLeave:Connect(function() UpdateVisuals(false, Library.Flags[Flag]) end)

                    local function Set(val)
                        Library.Flags[Flag] = val
                        UpdateVisuals(false, val)
                        pcall(Callback, val)
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Selected
                    
                    UpdateVisuals(false, Selected)

                    F.MouseButton1Click:Connect(function()
                        Set(not Library.Flags[Flag])
                    end)

                    RegisterItem(Text, F)
                end

                return BoxFuncs
            end
            return SubFuncs
        end
        return TabFuncs
    end
    return WindowFuncs
end

return Library
