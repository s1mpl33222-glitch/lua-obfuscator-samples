local s = game:GetService("StarterGui")

s:SetCore("SendNotification",{Title="Shade",Text="Loaded successfully",Duration=3})
task.wait(1)
s:SetCore("SendNotification",{Title="Credits",Text="Made by MortalExploits (YouTube)",Duration=5})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- ====== SKYBOXES ======
getgenv().Skyboxes = {
    Minecraft = {
        SkyboxBk = 'rbxassetid://1876545003',
        SkyboxDn = 'rbxassetid://1876544331',
        SkyboxFt = 'rbxassetid://1876542941',
        SkyboxLf = 'rbxassetid://1876543392',
        SkyboxRt = 'rbxassetid://1876543764',
        SkyboxUp = 'rbxassetid://1876544642',
    },
    PurpleDay = {
        SkyboxBk = 'rbxassetid://296908715',
        SkyboxDn = 'rbxassetid://296908724',
        SkyboxFt = 'rbxassetid://296908740',
        SkyboxLf = 'rbxassetid://296908755',
        SkyboxRt = 'rbxassetid://296908764',
        SkyboxUp = 'rbxassetid://296908769',
    },
    RedNight = {
        SkyboxBk = 'rbxassetid://401664839',
        SkyboxDn = 'rbxassetid://401664862',
        SkyboxFt = 'rbxassetid://401664960',
        SkyboxLf = 'rbxassetid://401664881',
        SkyboxRt = 'rbxassetid://401664901',
        SkyboxUp = 'rbxassetid://401664936',
    },
    Trollge = {
        SkyboxBk = 'rbxassetid://6155393905',
        SkyboxDn = 'rbxassetid://6155393905',
        SkyboxFt = 'rbxassetid://6155393905',
        SkyboxLf = 'rbxassetid://6155393905',
        SkyboxRt = 'rbxassetid://6155393905',
        SkyboxUp = 'rbxassetid://6155393905',
    },
    Night = {
        SkyboxBk = 'rbxassetid://48020371',
        SkyboxDn = 'rbxassetid://48020144',
        SkyboxFt = 'rbxassetid://48020234',
        SkyboxLf = 'rbxassetid://48020211',
        SkyboxRt = 'rbxassetid://48020254',
        SkyboxUp = 'rbxassetid://48020383',
    },
    Space = {
        SkyboxBk = 'rbxassetid://149397692',
        SkyboxDn = 'rbxassetid://149397686',
        SkyboxFt = 'rbxassetid://149397697',
        SkyboxLf = 'rbxassetid://149397684',
        SkyboxRt = 'rbxassetid://149397688',
        SkyboxUp = 'rbxassetid://149397702',
    },
    Default = {
        SkyboxBk = 'rbxassetid://6444884337',
        SkyboxDn = 'rbxassetid://6444884785',
        SkyboxFt = 'rbxassetid://6444884337',
        SkyboxLf = 'rbxassetid://6444884337',
        SkyboxRt = 'rbxassetid://6444884337',
        SkyboxUp = 'rbxassetid://6412503613',
    },
    VibeMorning = {
        SkyboxBk = 'rbxassetid://1417494030',
        SkyboxDn = 'rbxassetid://1417494146',
        SkyboxFt = 'rbxassetid://1417494253',
        SkyboxLf = 'rbxassetid://1417494402',
        SkyboxRt = 'rbxassetid://1417494499',
        SkyboxUp = 'rbxassetid://1417494643',
    },
    VibeNight = {
        SkyboxBk = 'rbxassetid://5084575798',
        SkyboxDn = 'rbxassetid://5084575916',
        SkyboxFt = 'rbxassetid://5103949679',
        SkyboxLf = 'rbxassetid://5103948542',
        SkyboxRt = 'rbxassetid://5103948784',
        SkyboxUp = 'rbxassetid://5084576400',
    },
    PurpleSplash = {
        SkyboxBk = 'rbxassetid://8539982183',
        SkyboxDn = 'rbxassetid://8539981943',
        SkyboxFt = 'rbxassetid://8539981721',
        SkyboxLf = 'rbxassetid://8539981424',
        SkyboxRt = 'rbxassetid://8539980766',
        SkyboxUp = 'rbxassetid://8539981085',
    },
    GreenSpace = {
        SkyboxBk = 'rbxassetid://159248188',
        SkyboxDn = 'rbxassetid://159248183',
        SkyboxFt = 'rbxassetid://159248187',
        SkyboxLf = 'rbxassetid://159248173',
        SkyboxRt = 'rbxassetid://159248192',
        SkyboxUp = 'rbxassetid://159248176',
    },
    Snowy = {
        SkyboxBk = 'rbxassetid://155657655',
        SkyboxDn = 'rbxassetid://155674246',
        SkyboxFt = 'rbxassetid://155657609',
        SkyboxLf = 'rbxassetid://155657671',
        SkyboxRt = 'rbxassetid://155657619',
        SkyboxUp = 'rbxassetid://155674931',
    },
    Spongebob = {
        SkyboxBk = 'rbxassetid://10287764626',
        SkyboxDn = 'rbxassetid://10287766382',
        SkyboxFt = 'rbxassetid://10287764626',
        SkyboxLf = 'rbxassetid://10287763421',
        SkyboxRt = 'rbxassetid://10287764626',
        SkyboxUp = 'rbxassetid://10287767597',
    },
    PinkDay = {
        SkyboxBk = 'rbxassetid://271042516',
        SkyboxDn = 'rbxassetid://271077243',
        SkyboxFt = 'rbxassetid://271042556',
        SkyboxLf = 'rbxassetid://271042310',
        SkyboxRt = 'rbxassetid://271042467',
        SkyboxUp = 'rbxassetid://271077958',
    },
    AlienRed = {
        SkyboxBk = 'rbxassetid://1012890',
        SkyboxDn = 'rbxassetid://1012891',
        SkyboxFt = 'rbxassetid://1012887',
        SkyboxLf = 'rbxassetid://1012889',
        SkyboxRt = 'rbxassetid://1012888',
        SkyboxUp = 'rbxassetid://1014449',
    },
    WallsOfAutumn = {
        SkyboxBk = 'rbxassetid://7123244709',
        SkyboxDn = 'rbxassetid://7123246497',
        SkyboxFt = 'rbxassetid://7123255895',
        SkyboxLf = 'rbxassetid://7123257992',
        SkyboxRt = 'rbxassetid://7123279103',
        SkyboxUp = 'rbxassetid://7123281828',
    },
    ColdWinterness = {
        SkyboxBk = 'rbxassetid://7123754562',
        SkyboxDn = 'rbxassetid://7123756028',
        SkyboxFt = 'rbxassetid://7123757422',
        SkyboxLf = 'rbxassetid://7123758897',
        SkyboxRt = 'rbxassetid://7123760563',
        SkyboxUp = 'rbxassetid://7123762364',
    },
    Oblivion = {
        SkyboxBk = 'rbxassetid://7123654189',
        SkyboxDn = 'rbxassetid://7123657455',
        SkyboxFt = 'rbxassetid://7123662047',
        SkyboxLf = 'rbxassetid://7123664533',
        SkyboxRt = 'rbxassetid://7123666598',
        SkyboxUp = 'rbxassetid://7123668994',
    },
    ClassicSky = {
        SkyboxBk = 'rbxassetid://672345740',
        SkyboxDn = 'rbxassetid://672345828',
        SkyboxFt = 'rbxassetid://672345879',
        SkyboxLf = 'rbxassetid://672345927',
        SkyboxRt = 'rbxassetid://672346006',
        SkyboxUp = 'rbxassetid://672346072',
    },
    PurpleNight = {
        SkyboxBk = 'rbxassetid://5084575798',
        SkyboxDn = 'rbxassetid://5084575916',
        SkyboxFt = 'rbxassetid://5103949679',
        SkyboxLf = 'rbxassetid://5103948542',
        SkyboxRt = 'rbxassetid://5103948784',
        SkyboxUp = 'rbxassetid://5084576400',
    },
    PurpleDayClear = {
        SkyboxBk = 'rbxassetid://6847607535',
        SkyboxDn = 'rbxassetid://6847607977',
        SkyboxFt = 'rbxassetid://6847608302',
        SkyboxLf = 'rbxassetid://6847608608',
        SkyboxRt = 'rbxassetid://6847608986',
        SkyboxUp = 'rbxassetid://6847609323',
    },
    YellowDay = {
        SkyboxBk = 'rbxassetid://2651432901',
        SkyboxDn = 'rbxassetid://2651434974',
        SkyboxFt = 'rbxassetid://2651435990',
        SkyboxLf = 'rbxassetid://2651436494',
        SkyboxRt = 'rbxassetid://2651436979',
        SkyboxUp = 'rbxassetid://2651437350',
    },
    MinecraftSky = {
        SkyboxBk = 'rbxassetid://8735166756',
        SkyboxDn = 'rbxassetid://8735166707',
        SkyboxFt = 'rbxassetid://8735231668',
        SkyboxLf = 'rbxassetid://8735166755',
        SkyboxRt = 'rbxassetid://8735166751',
        SkyboxUp = 'rbxassetid://8735166729',
    },
    Sunset = {
        SkyboxBk = 'rbxassetid://150939022',
        SkyboxDn = 'rbxassetid://150939038',
        SkyboxFt = 'rbxassetid://150939047',
        SkyboxLf = 'rbxassetid://150939056',
        SkyboxRt = 'rbxassetid://150939063',
        SkyboxUp = 'rbxassetid://150939082',
    },
    CartoonSky = {
        SkyboxBk = 'rbxassetid://6778646360',
        SkyboxDn = 'rbxassetid://6778658683',
        SkyboxFt = 'rbxassetid://6778648039',
        SkyboxLf = 'rbxassetid://6778649136',
        SkyboxRt = 'rbxassetid://6778650519',
        SkyboxUp = 'rbxassetid://6778658364',
    },
    Anime = {
        SkyboxBk = 'rbxassetid://7643700666',
        SkyboxDn = 'rbxassetid://7643743687',
        SkyboxFt = 'rbxassetid://7644304186',
        SkyboxLf = 'rbxassetid://7644288724',
        SkyboxRt = 'rbxassetid://7643700819',
        SkyboxUp = 'rbxassetid://7643757404',
    },
    HellSky = {
        SkyboxBk = 'rbxassetid://437430787',
        SkyboxDn = 'rbxassetid://437430804',
        SkyboxFt = 'rbxassetid://437430543',
        SkyboxLf = 'rbxassetid://437430732',
        SkyboxRt = 'rbxassetid://437430747',
        SkyboxUp = 'rbxassetid://437430771',
    },
    StarryNight = {
        SkyboxBk = 'rbxassetid://8291078911',
        SkyboxDn = 'rbxassetid://8291077403',
        SkyboxFt = 'rbxassetid://8291081613',
        SkyboxLf = 'rbxassetid://8291074004',
        SkyboxRt = 'rbxassetid://8291080353',
        SkyboxUp = 'rbxassetid://8291075054',
    },
    Omori = {
        SkyboxBk = 'rbxassetid://8767416629',
        SkyboxDn = 'rbxassetid://8767416629',
        SkyboxFt = 'rbxassetid://8767416629',
        SkyboxLf = 'rbxassetid://8767416629',
        SkyboxRt = 'rbxassetid://8767416629',
        SkyboxUp = 'rbxassetid://8767416629',
    },
    c00lkidd = {
        SkyboxBk = 'rbxassetid://433381097',
        SkyboxDn = 'rbxassetid://433381097',
        SkyboxFt = 'rbxassetid://433381097',
        SkyboxLf = 'rbxassetid://433381097',
        SkyboxRt = 'rbxassetid://433381097',
        SkyboxUp = 'rbxassetid://433381097',
    },
    ClearDay = {
        SkyboxBk = 'rbxassetid://591058823',
        SkyboxDn = 'rbxassetid://591059876',
        SkyboxFt = 'rbxassetid://591058104',
        SkyboxLf = 'rbxassetid://591057861',
        SkyboxRt = 'rbxassetid://591057625',
        SkyboxUp = 'rbxassetid://591059642',
    },
    Mountains = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=324014980',
        SkyboxDn = 'http://www.roblox.com/asset/?id=324015477',
        SkyboxFt = 'http://www.roblox.com/asset/?id=324014995',
        SkyboxLf = 'http://www.roblox.com/asset/?id=324014679',
        SkyboxRt = 'http://www.roblox.com/asset/?id=324015013',
        SkyboxUp = 'http://www.roblox.com/asset/?id=324015409',
    },
    Forest = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=70945545',
        SkyboxDn = 'http://www.roblox.com/asset/?id=70945449',
        SkyboxFt = 'http://www.roblox.com/asset/?id=70945487',
        SkyboxLf = 'http://www.roblox.com/asset/?id=70945523',
        SkyboxRt = 'http://www.roblox.com/asset/?id=70945508',
        SkyboxUp = 'http://www.roblox.com/asset/?id=70945531',
    },
    LargeForest = {
        SkyboxBk = 'rbxassetid://17428978603',
        SkyboxDn = 'rbxassetid://17428977445',
        SkyboxFt = 'rbxassetid://17428977114',
        SkyboxLf = 'rbxassetid://17428978399',
        SkyboxRt = 'rbxassetid://17428976828',
        SkyboxUp = 'rbxassetid://17428976669',
    },
    Crimson = {
        SkyboxBk = 'rbxassetid://15832429892',
        SkyboxDn = 'rbxassetid://15832430998',
        SkyboxFt = 'rbxassetid://15832430210',
        SkyboxLf = 'rbxassetid://15832430671',
        SkyboxRt = 'rbxassetid://15832431198',
        SkyboxUp = 'rbxassetid://15832429401',
    },
    PumpkinHill = {
        SkyboxBk = 'rbxassetid://11202510597',
        SkyboxDn = 'rbxassetid://11202510255',
        SkyboxFt = 'rbxassetid://11202509993',
        SkyboxLf = 'rbxassetid://11202510806',
        SkyboxRt = 'rbxassetid://11202511066',
        SkyboxUp = 'rbxassetid://11202509704',
    },
    AnimeIsland = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=14753804949',
        SkyboxDn = 'http://www.roblox.com/asset/?id=14753795573',
        SkyboxFt = 'http://www.roblox.com/asset/?id=14753807625',
        SkyboxLf = 'http://www.roblox.com/asset/?id=14753797417',
        SkyboxRt = 'http://www.roblox.com/asset/?id=14753799966',
        SkyboxUp = 'http://www.roblox.com/asset/?id=14753810287',
    },
    SnowyMountains = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=368385273',
        SkyboxDn = 'http://www.roblox.com/asset/?id=48015300',
        SkyboxFt = 'http://www.roblox.com/asset/?id=368388290',
        SkyboxLf = 'http://www.roblox.com/asset/?id=368390615',
        SkyboxRt = 'http://www.roblox.com/asset/?id=368385190',
        SkyboxUp = 'http://www.roblox.com/asset/?id=48015387',
    },
    Desert = {
        SkyboxBk = 'rbxassetid://161319957',
        SkyboxDn = 'rbxassetid://161319965',
        SkyboxFt = 'rbxassetid://161319970',
        SkyboxLf = 'rbxassetid://161319983',
        SkyboxRt = 'rbxassetid://161319989',
        SkyboxUp = 'rbxassetid://161319996',
    },
    Cloudy = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=225469345',
        SkyboxDn = 'http://www.roblox.com/asset/?id=225469349',
        SkyboxFt = 'http://www.roblox.com/asset/?id=225469359',
        SkyboxLf = 'http://www.roblox.com/asset/?id=225469364',
        SkyboxRt = 'http://www.roblox.com/asset/?id=225469372',
        SkyboxUp = 'http://www.roblox.com/asset/?id=225469380',
    },
    Island = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=319343577',
        SkyboxDn = 'http://www.roblox.com/asset/?id=319343653',
        SkyboxFt = 'http://www.roblox.com/asset/?id=319343666',
        SkyboxLf = 'http://www.roblox.com/asset/?id=319343686',
        SkyboxRt = 'http://www.roblox.com/asset/?id=319343631',
        SkyboxUp = 'http://www.roblox.com/asset/?id=319343614',
    },
    OrangeFog = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=458016711',
        SkyboxDn = 'http://www.roblox.com/asset/?id=458016826',
        SkyboxFt = 'http://www.roblox.com/asset/?id=458016532',
        SkyboxLf = 'http://www.roblox.com/asset/?id=458016655',
        SkyboxRt = 'http://www.roblox.com/asset/?id=458016782',
        SkyboxUp = 'http://www.roblox.com/asset/?id=458016792',
    },
    FadeNight = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=16888843486',
        SkyboxDn = 'http://www.roblox.com/asset/?id=16888845693',
        SkyboxFt = 'http://www.roblox.com/asset/?id=16888848245',
        SkyboxLf = 'http://www.roblox.com/asset/?id=16888850949',
        SkyboxRt = 'http://www.roblox.com/asset/?id=16888854243',
        SkyboxUp = 'http://www.roblox.com/asset/?id=16888857144',
    },
    Office = {
        SkyboxBk = 'rbxassetid://658623433',
        SkyboxDn = 'rbxassetid://316342560',
        SkyboxFt = 'rbxassetid://658625205',
        SkyboxLf = 'rbxassetid://658627155',
        SkyboxRt = 'rbxassetid://658628504',
        SkyboxUp = 'rbxassetid://658632701',
    },
    Spongebob2 = {
        SkyboxBk = 'rbxassetid://12049872454',
        SkyboxDn = 'rbxassetid://12049872284',
        SkyboxFt = 'rbxassetid://12049872181',
        SkyboxLf = 'rbxassetid://12049872074',
        SkyboxRt = 'rbxassetid://12049871884',
        SkyboxUp = 'rbxassetid://12049871774',
    },
    PurpleFog = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=17279854976',
        SkyboxDn = 'http://www.roblox.com/asset/?id=17279856318',
        SkyboxFt = 'http://www.roblox.com/asset/?id=17279858447',
        SkyboxLf = 'http://www.roblox.com/asset/?id=17279860360',
        SkyboxRt = 'http://www.roblox.com/asset/?id=17279862234',
        SkyboxUp = 'http://www.roblox.com/asset/?id=17279864507',
    },
    EarthSpace = {
        SkyboxBk = 'rbxassetid://15753305495',
        SkyboxDn = 'rbxassetid://15753362674',
        SkyboxFt = 'rbxassetid://15753305823',
        SkyboxLf = 'rbxassetid://15753310707',
        SkyboxRt = 'rbxassetid://15753304774',
        SkyboxUp = 'rbxassetid://15753304473',
    },
    GreenCloudy = {
        SkyboxBk = 'rbxassetid://921882045',
        SkyboxDn = 'rbxassetid://921881907',
        SkyboxFt = 'rbxassetid://921882121',
        SkyboxLf = 'rbxassetid://921881811',
        SkyboxRt = 'rbxassetid://921881989',
        SkyboxUp = 'rbxassetid://921882259',
    },
    SummerDay = {
        SkyboxBk = 'http://www.roblox.com/asset/?version=1&id=135483466',
        SkyboxDn = 'http://www.roblox.com/asset/?version=1&id=135483484',
        SkyboxFt = 'http://www.roblox.com/asset/?version=1&id=135483461',
        SkyboxLf = 'http://www.roblox.com/asset/?version=1&id=135483495',
        SkyboxRt = 'http://www.roblox.com/asset/?version=1&id=135483499',
        SkyboxUp = 'http://www.roblox.com/asset/?version=1&id=135483475',
    },
    SnowyPlains = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=155657655',
        SkyboxDn = 'http://www.roblox.com/asset/?id=155674246',
        SkyboxFt = 'http://www.roblox.com/asset/?id=155657609',
        SkyboxLf = 'http://www.roblox.com/asset/?id=155657671',
        SkyboxRt = 'http://www.roblox.com/asset/?id=155657619',
        SkyboxUp = 'http://www.roblox.com/asset/?id=155674931',
    },
    Underwater = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=227635868',
        SkyboxDn = 'http://www.roblox.com/asset/?id=227635921',
        SkyboxFt = 'http://www.roblox.com/asset/?id=227635954',
        SkyboxLf = 'http://www.roblox.com/asset/?id=227635974',
        SkyboxRt = 'http://www.roblox.com/asset/?id=227635990',
        SkyboxUp = 'http://www.roblox.com/asset/?id=227636031',
    },
    BlueAbyss = {
        SkyboxBk = 'rbxassetid://16269815885',
        SkyboxDn = 'rbxassetid://16269839652',
        SkyboxFt = 'rbxassetid://16269798011',
        SkyboxLf = 'rbxassetid://16269813852',
        SkyboxRt = 'rbxassetid://16269814948',
        SkyboxUp = 'rbxassetid://16269829700',
    },
    Poison = {
        SkyboxBk = 'rbxassetid://1370716695',
        SkyboxDn = 'rbxassetid://1370716766',
        SkyboxFt = 'rbxassetid://1370716833',
        SkyboxLf = 'rbxassetid://1370716898',
        SkyboxRt = 'rbxassetid://1370716955',
        SkyboxUp = 'rbxassetid://1370717024',
    },
    BlueSpace = {
        SkyboxBk = 'rbxassetid://1127563035',
        SkyboxDn = 'rbxassetid://1127563006',
        SkyboxFt = 'rbxassetid://1127563026',
        SkyboxLf = 'rbxassetid://1127563216',
        SkyboxRt = 'rbxassetid://1127563115',
        SkyboxUp = 'rbxassetid://1127562999',
    },
    AnimeMountains = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=12849370744',
        SkyboxDn = 'http://www.roblox.com/asset/?id=12849378890',
        SkyboxFt = 'http://www.roblox.com/asset/?id=12849390276',
        SkyboxLf = 'http://www.roblox.com/asset/?id=12849405549',
        SkyboxRt = 'http://www.roblox.com/asset/?id=12849398428',
        SkyboxUp = 'http://www.roblox.com/asset/?id=12849426002',
    },
    PinkGradient = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=5371541816',
        SkyboxDn = 'http://www.roblox.com/asset/?id=5371541154',
        SkyboxFt = 'http://www.roblox.com/asset/?id=5371541816',
        SkyboxLf = 'http://www.roblox.com/asset/?id=5371541816',
        SkyboxRt = 'http://www.roblox.com/asset/?id=5371541816',
        SkyboxUp = 'http://www.roblox.com/asset/?id=5371540604',
    },
    YellowGradient = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=159005370',
        SkyboxDn = 'rbxassetid://858422412',
        SkyboxFt = 'http://www.roblox.com/asset/?id=159005370',
        SkyboxLf = 'http://www.roblox.com/asset/?id=159005370',
        SkyboxRt = 'http://www.roblox.com/asset/?id=159005370',
        SkyboxUp = 'http://www.roblox.com/asset/?id=159006363',
    },
    BlueGradient = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=4628466090',
        SkyboxDn = 'http://www.roblox.com/asset/?id=4628471901',
        SkyboxFt = 'http://www.roblox.com/asset/?id=4628466090',
        SkyboxLf = 'http://www.roblox.com/asset/?id=4628466090',
        SkyboxRt = 'http://www.roblox.com/asset/?id=4628466090',
        SkyboxUp = 'http://www.roblox.com/asset/?id=4628472152',
    },
    GreenNebula = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=47974894',
        SkyboxDn = 'http://www.roblox.com/asset/?id=47974690',
        SkyboxFt = 'http://www.roblox.com/asset/?id=47974821',
        SkyboxLf = 'http://www.roblox.com/asset/?id=47974776',
        SkyboxRt = 'http://www.roblox.com/asset/?id=47974859',
        SkyboxUp = 'http://www.roblox.com/asset/?id=47974909',
    },
    OrangeGradient = {
        SkyboxBk = 'rbxassetid://6902754982',
        SkyboxDn = 'rbxassetid://6902795826',
        SkyboxFt = 'rbxassetid://6902754982',
        SkyboxLf = 'rbxassetid://6902754982',
        SkyboxRt = 'rbxassetid://6902754982',
        SkyboxUp = 'rbxassetid://6902796078',
    },
    GreenAurora = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=16563478983',
        SkyboxDn = 'http://www.roblox.com/asset/?id=16563481302',
        SkyboxFt = 'http://www.roblox.com/asset/?id=16563484084',
        SkyboxLf = 'http://www.roblox.com/asset/?id=16563485362',
        SkyboxRt = 'http://www.roblox.com/asset/?id=16563487078',
        SkyboxUp = 'http://www.roblox.com/asset/?id=16563489821',
    },
}

-- ====== GUI ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShadeGui"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main frame positioned next to topbar (top-left)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 270, 0, 70)
Frame.Position = UDim2.new(0, 8, 0, 8)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 15)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.7

-- Shade Icon
local Icon = Instance.new("ImageLabel")
Icon.Size = UDim2.new(0, 45, 0, 45)
Icon.Position = UDim2.new(0, 10, 0.5, -22)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://10639756312"
Icon.Parent = Frame

-- ====== Scrollable Buttons ======
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0, 180, 0, 40)
ScrollFrame.Position = UDim2.new(0, 70, 0.5, -20)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 0
ScrollFrame.ClipsDescendants = true
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

-- Scrollbar
local ScrollTrack = Instance.new("Frame")
ScrollTrack.Size = UDim2.new(1, 0, 0, 6)
ScrollTrack.Position = UDim2.new(0, 0, 1, -12)
ScrollTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ScrollTrack.BackgroundTransparency = 0.5
ScrollTrack.Parent = Frame
local TrackCorner = Instance.new("UICorner", ScrollTrack)
TrackCorner.CornerRadius = UDim.new(0, 3)

local ScrollHandle = Instance.new("Frame")
ScrollHandle.Size = UDim2.new(0.2, 0, 1, 0)
ScrollHandle.Position = UDim2.new(0, 0, 0, 0)
ScrollHandle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
ScrollHandle.BackgroundTransparency = 0.2
ScrollHandle.Parent = ScrollTrack
local HandleCorner = Instance.new("UICorner", ScrollHandle)
HandleCorner.CornerRadius = UDim.new(0, 3)

-- ====== Skybox Dropdown GUI ======
-- Parented to ScreenGui so Frame's ClipsDescendants doesn't cut it off
local SkyboxDropdownFrame = Instance.new("Frame")
SkyboxDropdownFrame.Size = UDim2.new(0, 200, 0, 30)
SkyboxDropdownFrame.Position = UDim2.new(0, 8, 0, 8) -- updated dynamically
SkyboxDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SkyboxDropdownFrame.BorderSizePixel = 0
SkyboxDropdownFrame.ClipsDescendants = false
SkyboxDropdownFrame.Visible = false
SkyboxDropdownFrame.ZIndex = 20
SkyboxDropdownFrame.Parent = ScreenGui
local SkyboxDropCorner = Instance.new("UICorner", SkyboxDropdownFrame)
SkyboxDropCorner.CornerRadius = UDim.new(0, 8)
local SkyboxDropStroke = Instance.new("UIStroke", SkyboxDropdownFrame)
SkyboxDropStroke.Color = Color3.fromRGB(255,255,255)
SkyboxDropStroke.Thickness = 1
SkyboxDropStroke.Transparency = 0.8

local SkyboxLabel = Instance.new("TextLabel")
SkyboxLabel.Size = UDim2.new(1, -30, 1, 0)
SkyboxLabel.Position = UDim2.new(0, 8, 0, 0)
SkyboxLabel.BackgroundTransparency = 1
SkyboxLabel.Text = "None"
SkyboxLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SkyboxLabel.Font = Enum.Font.GothamBold
SkyboxLabel.TextSize = 12
SkyboxLabel.TextXAlignment = Enum.TextXAlignment.Left
SkyboxLabel.ZIndex = 21
SkyboxLabel.Parent = SkyboxDropdownFrame

local SkyboxArrow = Instance.new("TextLabel")
SkyboxArrow.Size = UDim2.new(0, 20, 1, 0)
SkyboxArrow.Position = UDim2.new(1, -24, 0, 0)
SkyboxArrow.BackgroundTransparency = 1
SkyboxArrow.Text = "▼"
SkyboxArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
SkyboxArrow.Font = Enum.Font.Gotham
SkyboxArrow.TextSize = 10
SkyboxArrow.ZIndex = 21
SkyboxArrow.Parent = SkyboxDropdownFrame

-- Scrollable list for dropdown
local SkyboxListContainer = Instance.new("Frame")
SkyboxListContainer.Size = UDim2.new(1, 0, 0, 0)
SkyboxListContainer.Position = UDim2.new(0, 0, 1, 4)
SkyboxListContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SkyboxListContainer.BorderSizePixel = 0
SkyboxListContainer.ClipsDescendants = true
SkyboxListContainer.ZIndex = 20
SkyboxListContainer.Visible = false
SkyboxListContainer.Parent = SkyboxDropdownFrame
local ListContainerCorner = Instance.new("UICorner", SkyboxListContainer)
ListContainerCorner.CornerRadius = UDim.new(0, 8)
local ListContainerStroke = Instance.new("UIStroke", SkyboxListContainer)
ListContainerStroke.Color = Color3.fromRGB(255,255,255)
ListContainerStroke.Thickness = 1
ListContainerStroke.Transparency = 0.8

local SkyboxScrollList = Instance.new("ScrollingFrame")
SkyboxScrollList.Size = UDim2.new(1, 0, 1, 0)
SkyboxScrollList.BackgroundTransparency = 1
SkyboxScrollList.ScrollBarThickness = 3
SkyboxScrollList.ScrollBarImageColor3 = Color3.fromRGB(150,150,150)
SkyboxScrollList.CanvasSize = UDim2.new(0,0,0,0)
SkyboxScrollList.ZIndex = 21
SkyboxScrollList.Parent = SkyboxListContainer

local SkyboxListLayout = Instance.new("UIListLayout")
SkyboxListLayout.FillDirection = Enum.FillDirection.Vertical
SkyboxListLayout.SortOrder = Enum.SortOrder.Name
SkyboxListLayout.Padding = UDim.new(0, 2)
SkyboxListLayout.Parent = SkyboxScrollList

local SkyboxListPadding = Instance.new("UIPadding")
SkyboxListPadding.PaddingLeft = UDim.new(0, 4)
SkyboxListPadding.PaddingRight = UDim.new(0, 4)
SkyboxListPadding.PaddingTop = UDim.new(0, 4)
SkyboxListPadding.PaddingBottom = UDim.new(0, 4)
SkyboxListPadding.Parent = SkyboxScrollList

-- Auto-update canvas so scroll reaches every item
SkyboxListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SkyboxScrollList.CanvasSize = UDim2.new(0, 0, 0, SkyboxListLayout.AbsoluteContentSize.Y + 8)
end)

-- Dropdown open/close state
local dropdownOpen = false

local function closeSkyboxDropdown()
    dropdownOpen = false
    SkyboxArrow.Text = "▼"
    local tween = TweenService:Create(SkyboxListContainer, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        SkyboxListContainer.Visible = false
    end)
end

local DROPDOWN_HEIGHT = 200

local function openSkyboxDropdown()
    dropdownOpen = true
    SkyboxArrow.Text = "▲"
    -- Position dropdown just below the main Frame
    local frameAbsPos = Frame.AbsolutePosition
    local frameAbsSize = Frame.AbsoluteSize
    SkyboxDropdownFrame.Position = UDim2.new(0, frameAbsPos.X, 0, frameAbsPos.Y + frameAbsSize.Y + 4)
    SkyboxDropdownFrame.Visible = true
    SkyboxListContainer.Visible = true
    local tween = TweenService:Create(SkyboxListContainer, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, DROPDOWN_HEIGHT)})
    tween:Play()
end

-- ====== Lighting functions ======
local rainSound

local function clearSky()
    for _, sky in pairs(Lighting:GetChildren()) do
        if sky:IsA("Sky") then sky:Destroy() end
    end
    if rainSound then
        rainSound:Stop()
    end
    if Workspace:FindFirstChild("RainFolder") then
        Workspace.RainFolder:Destroy()
    end
    SkyboxLabel.Text = "None"
end

local function resetLightingToClearDay()
    Lighting.ClockTime = 14
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.FogColor = Color3.fromRGB(191, 191, 191)
    Lighting.FogEnd = 100000
    Lighting.ShadowSoftness = 0.2
    Lighting.ExposureCompensation = 0
end

-- Apply skybox: resets lighting to clear day then applies chosen skybox
local function applySkybox(name)
    local data = getgenv().Skyboxes[name]
    if not data then return end
    clearSky()
    resetLightingToClearDay()
    local sky = Instance.new("Sky")
    sky.SkyboxBk = data.SkyboxBk
    sky.SkyboxDn = data.SkyboxDn
    sky.SkyboxFt = data.SkyboxFt
    sky.SkyboxLf = data.SkyboxLf
    sky.SkyboxRt = data.SkyboxRt
    sky.SkyboxUp = data.SkyboxUp
    sky.Name = name .. "Skybox"
    sky.Parent = Lighting
    SkyboxLabel.Text = name
end

-- Populate dropdown list
for skyName, _ in pairs(getgenv().Skyboxes) do
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, 0, 0, 24)
    item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    item.BackgroundTransparency = 0.3
    item.TextColor3 = Color3.fromRGB(220, 220, 220)
    item.Text = skyName
    item.Font = Enum.Font.Gotham
    item.TextSize = 11
    item.BorderSizePixel = 0
    item.ZIndex = 22
    item.Parent = SkyboxScrollList
    local itemCorner = Instance.new("UICorner", item)
    itemCorner.CornerRadius = UDim.new(0, 6)

    item.MouseEnter:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    item.MouseLeave:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    item.MouseButton1Click:Connect(function()
        applySkybox(skyName)
        closeSkyboxDropdown()
    end)
end

-- Toggle dropdown on click
local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(1, 0, 1, 0)
dropBtn.BackgroundTransparency = 1
dropBtn.Text = ""
dropBtn.ZIndex = 22
dropBtn.Parent = SkyboxDropdownFrame

dropBtn.MouseButton1Click:Connect(function()
    if dropdownOpen then
        closeSkyboxDropdown()
    else
        openSkyboxDropdown()
    end
end)

-- ====== Buttons creation with click effect ======
local function createButton(text, bgColor, textColor, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 30)
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = textColor
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = ScrollFrame
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
        local tweenUp = TweenService:Create(btn, tweenInfo, {Size = UDim2.new(0, 70, 0, 35)})
        local tweenDown = TweenService:Create(btn, tweenInfo, {Size = UDim2.new(0, 60, 0, 30)})
        tweenUp:Play()
        tweenUp.Completed:Wait()
        tweenDown:Play()
        if onClick then onClick() end
    end)

    return btn
end

local function setSunlight()
    clearSky()
    Lighting.ClockTime = 7
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(200,200,255)
    Lighting.Ambient = Color3.fromRGB(255,210,160)
    Lighting.FogColor = Color3.fromRGB(255,170,100)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.FogEnd = 100000
    Lighting.ShadowSoftness = 0.2
    Lighting.ExposureCompensation = 0
    local sunSky = Instance.new("Sky")
    sunSky.SkyboxBk = "rbxassetid://541743453"
    sunSky.SkyboxDn = "rbxassetid://541743443"
    sunSky.SkyboxFt = "rbxassetid://541743446"
    sunSky.SkyboxLf = "rbxassetid://541743436"
    sunSky.SkyboxRt = "rbxassetid://541743435"
    sunSky.SkyboxUp = "rbxassetid://541743441"
    sunSky.Name = "SunSkybox"
    sunSky.Parent = Lighting
end

local function setMoonDay()
    clearSky()
    Lighting.ClockTime = 21
    Lighting.Brightness = 1
    Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    Lighting.Ambient = Color3.fromRGB(0,0,0)
    Lighting.FogColor = Color3.fromRGB(150,150,150)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.FogEnd = 100000
    Lighting.ShadowSoftness = 0.2
    Lighting.ExposureCompensation = 0
    local moonSky = Instance.new("Sky")
    moonSky.SkyboxBk = "rbxassetid://4498828382"
    moonSky.SkyboxDn = "rbxassetid://4498828812"
    moonSky.SkyboxFt = "rbxassetid://4498829917"
    moonSky.SkyboxLf = "rbxassetid://4498830911"
    moonSky.SkyboxRt = "rbxassetid://4498830417"
    moonSky.SkyboxUp = "rbxassetid://4498831746"
    moonSky.Name = "MoonSkybox"
    moonSky.Parent = Lighting
end

local function setMoonly()
    clearSky()
    Lighting.ClockTime = 19
    Lighting.Brightness = 0.02
    Lighting.Ambient = Color3.fromRGB(140,170,180)
    Lighting.OutdoorAmbient = Color3.fromRGB(180,200,210)
    Lighting.ColorShift_Bottom = Color3.fromRGB(100,120,130)
    Lighting.FogColor = Color3.fromRGB(180,200,210)
    Lighting.FogEnd = 3000
    Lighting.ShadowSoftness = 0.4
    Lighting.ExposureCompensation = 0.3
end

local function setRain()
    clearSky()
    Lighting.ClockTime = 21
    Lighting.Brightness = 1
    Lighting.OutdoorAmbient = Color3.fromRGB(100,100,120)
    Lighting.Ambient = Color3.fromRGB(50,50,60)
    Lighting.FogColor = Color3.fromRGB(100,100,120)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.FogEnd = 100000
    Lighting.ShadowSoftness = 0.2
    Lighting.ExposureCompensation = 0

    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://4498828382"
    sky.SkyboxDn = "rbxassetid://4498828812"
    sky.SkyboxFt = "rbxassetid://4498829917"
    sky.SkyboxLf = "rbxassetid://4498830911"
    sky.SkyboxRt = "rbxassetid://4498830417"
    sky.SkyboxUp = "rbxassetid://4498831746"
    sky.Parent = Lighting

    local RAIN_AREA   = 200
    local RAIN_HEIGHT = 50
    local RAIN_SPEED  = 120
    local RAIN_COUNT  = 50
    local DROP_SIZE   = Vector3.new(0.05, 3, 0.05)

    local RainFolder = Instance.new("Folder")
    RainFolder.Name = "RainFolder"
    RainFolder.Parent = Workspace

    -- Each drop stores a local offset (X/Z) and a Y value relative to player base
    local dropOffsets = {}  -- {x, z, y}  all relative to player
    for i = 1, RAIN_COUNT do
        dropOffsets[i] = {
            x = math.random(-RAIN_AREA/2, RAIN_AREA/2),
            z = math.random(-RAIN_AREA/2, RAIN_AREA/2),
            y = math.random(0, RAIN_HEIGHT),
        }
    end

    local raindrops = {}
    for i = 1, RAIN_COUNT do
        local drop = Instance.new("Part")
        drop.Size = DROP_SIZE
        drop.Anchored = true
        drop.CanCollide = false
        drop.CastShadow = false
        drop.Material = Enum.Material.SmoothPlastic
        drop.Color = Color3.fromRGB(160, 200, 255)
        drop.Transparency = 0.5
        drop.Position = Vector3.new(dropOffsets[i].x, dropOffsets[i].y, dropOffsets[i].z)
        drop.Parent = RainFolder
        raindrops[i] = drop
    end

    local connection
    connection = RunService.RenderStepped:Connect(function(deltaTime)
        if not Workspace:FindFirstChild("RainFolder") then
            connection:Disconnect()
            return
        end

        -- Get player root position so rain follows the player
        local rootPos = Vector3.new(0, 0, 0)
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                rootPos = root.Position
            end
        end

        for i, drop in ipairs(raindrops) do
            -- Move drop downward
            dropOffsets[i].y = dropOffsets[i].y - RAIN_SPEED * deltaTime

            -- Reset when it falls below ground level relative to player
            if dropOffsets[i].y < (rootPos.Y - 10) then
                dropOffsets[i].y  = rootPos.Y + RAIN_HEIGHT
                dropOffsets[i].x  = math.random(-RAIN_AREA/2, RAIN_AREA/2)
                dropOffsets[i].z  = math.random(-RAIN_AREA/2, RAIN_AREA/2)
            end

            drop.Position = Vector3.new(
                rootPos.X + dropOffsets[i].x,
                dropOffsets[i].y,
                rootPos.Z + dropOffsets[i].z
            )
        end
    end)

    rainSound = Instance.new("Sound")
    rainSound.Name = "RainAmbience"
    rainSound.SoundId = "rbxassetid://365362615"
    rainSound.Looped = true
    rainSound.Volume = 0.4
    rainSound.Parent = Workspace
    rainSound:Play()
end

local function setLateDay()
    clearSky()
    Lighting.ClockTime = 15
    Lighting.Brightness = 1.8
    Lighting.Ambient = Color3.fromRGB(180,140,100)
    Lighting.OutdoorAmbient = Color3.fromRGB(200,160,120)
    Lighting.ColorShift_Bottom = Color3.fromRGB(30,20,10)
    Lighting.FogColor = Color3.fromRGB(100,80,60)
    Lighting.FogEnd = 1000
    Lighting.ShadowSoftness = 0.2
    Lighting.ExposureCompensation = 0
end

-- ====== Button Assignments ======
local SunBtn     = createButton("Sun",     Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0),       setSunlight)
local MoonBtn    = createButton("Moon",    Color3.fromRGB(0,0,0),       Color3.fromRGB(255,255,255), setMoonDay)
local MoonlyBtn  = createButton("Moonly",  Color3.fromRGB(50,50,50),    Color3.fromRGB(200,200,255), setMoonly)
local RainBtn    = createButton("Rain",    Color3.fromRGB(0,0,128),     Color3.fromRGB(255,255,255), setRain)
local LateDayBtn = createButton("Lateday", Color3.fromRGB(255,165,0),   Color3.fromRGB(0,0,0),       setLateDay)

local SkyboxBtn  = createButton("Skybox",  Color3.fromRGB(80,40,120),   Color3.fromRGB(255,255,255), function()
    if dropdownOpen then
        closeSkyboxDropdown()
    else
        openSkyboxDropdown()
    end
end)

-- ====== Scroll behavior ======
RunService.RenderStepped:Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, 0)
    local maxCanvas = math.max(ScrollFrame.AbsoluteCanvasSize.X - ScrollFrame.AbsoluteSize.X, 1)
    local handleWidth = math.clamp(ScrollFrame.AbsoluteSize.X / (ScrollFrame.AbsoluteCanvasSize.X), 0.1, 1)
    ScrollHandle.Size = UDim2.new(handleWidth, 0, 1, 0)
    ScrollHandle.Position = UDim2.new(ScrollFrame.CanvasPosition.X / maxCanvas, 0, 0, 0)

    -- Keep dropdown anchored below Frame when dragging
    if SkyboxDropdownFrame.Visible then
        local frameAbsPos = Frame.AbsolutePosition
        local frameAbsSize = Frame.AbsoluteSize
        SkyboxDropdownFrame.Position = UDim2.new(0, frameAbsPos.X, 0, frameAbsPos.Y + frameAbsSize.Y + 4)
    end
end)

-- ====== Drag GUI ======
local draggingGUI = false
local dragStartPos, frameStartPos

local function startDrag(input)
    draggingGUI = true
    dragStartPos = input.Position
    frameStartPos = Frame.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            draggingGUI = false
        end
    end)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        local moveConnection
        moveConnection = input:GetPropertyChangedSignal("Position"):Connect(function()
            if draggingGUI then
                local delta = input.Position - dragStartPos
                Frame.Position = UDim2.new(
                    frameStartPos.X.Scale,
                    frameStartPos.X.Offset + delta.X,
                    frameStartPos.Y.Scale,
                    frameStartPos.Y.Offset + delta.Y
                )
            else
                moveConnection:Disconnect()
            end
        end)
    end
end)
