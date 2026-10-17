-- This file was generated at discord.gg/syncrypt

return {
    protos = {
        [0] = {
            strings = {
                [0] = "Callback", -- x47
                [1] = "Team", -- x2
                [2] = "Name", -- x3
                [3] = "Marines", -- x3
                [4] = "Parent", -- x3
                [5] = "Instance", -- x4
                [6] = "new", -- x12
                [7] = "UIStroke",
                [8] = "Thickness",
                [9] = "Check_raid_chip",
                [10] = "Check_fruit_inventory",
                [11] = "checkmastery",
                [12] = "Character", -- x2
                [13] = "AddParagraph", -- x8
                [14] = "Same marks the farm hub uses",
                [15] = "Title", -- x62
                [16] = "Fruit on the ground, islands and chests, each with its own colour and the distance next to it. Just a label, no box: a box over a fruit lying on the floor helps nobody and fills the screen.",
                [17] = "Content", -- x8
                [18] = "Default", -- x43
                [19] = "AddButton", -- x4
                [20] = "AddTab", -- x6
                [21] = "Settings",
                [22] = "settings", -- x2
                [23] = "Icon", -- x47
                [24] = "AddSection", -- x12
                [25] = "master",
                [26] = "Master switch",
                [27] = "Why the bypass kills you",
                [28] = "SetLastSpawnPoint(name) does NOT move your respawn -- measured twice, once across all 16 islands of Sea 3 and again on this server: it returns ok and the value stays put, so it accepts the call and ignores the name. What does work is SetSpawnPoint() with no argument, which saves wherever the SERVER thinks you are. So the order has to be: travel first, save second, die last. Dying costs nothing in Blox Fruits -- no item and no fruit is lost.",
                [29] = "pvp",
                [30] = "What the switch does",
                [31] = "It locks the enemy closest to your aim on screen, and makes your skills and your gun shots leave in his direction -- through the game's own aim assist, so it lands where the lock is and not where your cursor is. It does NOT attack for you: you press what you want, when you want. Your camera is never moved. Your body turns toward the lock only on the frame you strike -- the game already turns it on every M1, toward your cursor; this only fixes the direction, and melee M1 needs it to land.",
                [32] = "AddToggle", -- x27
                [33] = "pvpAim",
                [34] = "PVP AIM",
                [35] = "crosshair", -- x4
                [36] = "Skills and gun shots follow the locked enemy",
                [37] = "Description", -- x25
                [38] = "SkillAuto",
                [39] = "SkillEspera",
                [40] = "SkillSoComAlvo",
                [41] = "EquiparAuto",
                [42] = "type", -- x6
                [43] = "_G", -- x37
                [44] = "__PVPKING_UNLOAD", -- x3
                [45] = "AddSlider", -- x11
                [46] = "fastRange",
                [47] = "Fast attack range",
                [48] = " studs", -- x6
                [49] = "Suffix", -- x10
                [50] = "espColor",
                [51] = "Enemy colour",
                [52] = "EspCor", -- x2
                [53] = "Get in past the barrier",
                [54] = "Values", -- x3
                [55] = "EspMostrarPulados",
                [56] = "MostrarFov", -- x2
                [57] = "Esp", -- x2
                [58] = "EspCaixa",
                [59] = "RenderStepped", -- x6
                [60] = "CoreGui",
                [61] = "Mouse",
                [62] = "__PVPKING_GEN", -- x3
                [63] = "FilterType", -- x3
                [64] = "pairs", -- x2
                [65] = "How the game switches side",
                [66] = "It is the same call the NPC makes: CommF_(\"SetTeam\", \"Pirates\" or \"Marines\"). Nothing else is touched -- no teleport, no respawn. The team only changes on the server, so the panel reads it back from Player.Team right after.",
                [67] = "Rounding", -- x11
                [68] = "AddColorPicker", -- x2
                [69] = "uiColor",
                [70] = "Lock FOV",
                [71] = " deg",
                [72] = "eye", -- x9
                [73] = "360 locks anyone around you, even behind your back",
                [74] = "Min", -- x11
                [75] = "Max", -- x11
                [76] = "AimFovGraus", -- x2
                [77] = "espChest",
                [78] = "Chest ESP",
                [79] = "ReplicatedStorage",
                [80] = "EspZonaSegura", -- x2
                [81] = "espAliado",
                [82] = "InputBegan", -- x3
                [83] = "aimRange",
                [84] = "Range -- ignores anyone past this",
                [85] = "__TSUO_", -- x2
                [86] = "SkillV",
                [87] = "SkillF",
                [88] = "AntiStun",
                [89] = "AutoBuso", -- x2
                [90] = "AutoObs", -- x2
                [91] = "AutoV3", -- x2
                [92] = "AutoV4", -- x2
                [93] = "StaminaInf", -- x2
                [94] = "Velocidade", -- x2
                [95] = "VelocidadeVal", -- x2
                [96] = "Pulo", -- x2
                [97] = "Movement",
                [98] = "bolt", -- x17
                [99] = "__TSUO_BOSS_LOCAL",
                [100] = "__TSUO_LocalDoBoss",
                [101] = "__TSUO_PegarMov", -- x2
                [102] = "spin",
                [103] = "Spin your character",
                [104] = "v4",
                [105] = "Auto race V4",
                [106] = "cf", -- x9
                [107] = "material", -- x3
                [108] = "tipo", -- x9
                [109] = "Hallow Essence",
                [110] = "Holy Torch",
                [111] = "God's Chalice",
                [112] = "Fist of Darkness",
                [113] = "Cursed Chalice",
                [114] = "Modules", -- x2
                [115] = "FindFirstChild", -- x7
                [116] = "Net",
                [117] = "Cake Queen",
                [118] = "nome", -- x11
                [119] = "pcall", -- x12
                [120] = "CharacterAdded", -- x2
                [121] = "FovModo", -- x2
                [122] = "Destroy", -- x8
                [123] = "protectgui", -- x2
                [124] = "function", -- x3
                [125] = "Aim", -- x2
                [126] = "globe", -- x10
                [127] = "EspBau", -- x2
                [128] = "espWorldDist",
                [129] = "World ESP distance",
                [130] = "RightUpperArm",
                [131] = "LeftUpperArm",
                [132] = "RightUpperLeg",
                [133] = "Heartbeat", -- x4
                [134] = "AddDropdown", -- x3
                [135] = "team",
                [136] = "Side",
                [137] = "AimAltura", -- x2
                [138] = "destinos",
                [139] = "Pirates", -- x2
                [140] = "Exclude", -- x3
                [141] = "IgnoreWater",
                [142] = "aimHeight",
                [143] = "Conjured Cocoa",
                [144] = "Ectoplasm",
                [145] = "Bones",
                [146] = "Microchip",
                [147] = "Special Microchip",
                [148] = "__TSUO_RAROS",
                [149] = "RE/RegisterHit",
                [150] = "GetPortal",
                [151] = "GetMouse",
                [152] = "__TSUO_Geracao",
                [153] = "About Mink speed",
                [154] = "Don Swan",
                [155] = "weapon", -- x4
                [156] = "Kilo Admiral",
                [157] = "DashDistancia", -- x2
                [158] = "ScreenGui",
                [159] = "Frame",
                [160] = "FovRing",
                [161] = "BackgroundTransparency",
                [162] = "BorderSizePixel",
                [163] = "Vector2",
                [164] = "Stepped", -- x3
                [165] = "getmetatable",
                [166] = "SEA1", -- x2
                [167] = "SEA2", -- x2
                [168] = " studs/s",
                [169] = "171 is what the server accepts. Higher does not travel further -- it just gets refused.",
                [170] = "Camera", -- x2
                [171] = "AimMaxStuds",
                [172] = "AimPrever",
                [173] = "AimSoVisivel",
                [174] = "AimAlcanceModo",
                [175] = "AimNpc",
                [176] = "estado",
                [177] = "ui",
                [178] = "tick",
                [179] = "Walk on the sea",
                [180] = "A platform of its own under you while you are over the sea",
                [181] = "AndarNaAgua", -- x2
                [182] = "AnchorPoint",
                [183] = "Visible",
                [184] = "ZIndex",
                [185] = "drops", -- x4
                [186] = "accessory", -- x2
                [187] = "Awakened Ice Admiral",
                [188] = "math",
                [189] = "pi",
                [190] = "Check_Inventory",
                [191] = "old_tp",
                [192] = "__TSUO_MOV", -- x2
                [193] = "ripindra",
                [194] = "elite",
                [195] = "factory",
                [196] = "boss",
                [197] = "virarParaAlvo",
                [198] = "Enum", -- x9
                [199] = "Teleport",
                [200] = "Misc",
                [201] = "This is the spin from our Universal hub",
                [202] = "Copied as is, including the one line that makes it work: AutoRotate off. In BloxStrike I had concluded a spin bot was impossible here -- I turned the root and the camera came with it, 46.9 degrees against 47.0. That conclusion was wrong. What dragged the body was the Humanoid re-aiming it at the camera every frame. With AutoRotate off the body spins and your camera stays where you left it.",
                [203] = "CreateWindow",
                [204] = "TSUO PVP KING", -- x2
                [205] = "blox fruits",
                [206] = "SubTitle",
                [207] = "KeyCode", -- x6
                [208] = "RightShift",
                [209] = "ToggleKey",
                [210] = "Dark",
                [211] = "Theme",
                [212] = "espSafe",
                [213] = "Players inside a safe zone",
                [214] = "shield", -- x5
                [215] = "Turn off and the bubble crowd disappears -- you cannot hit them anyway",
                [216] = "MiraSkillAlcance", -- x2
                [217] = "FastAttack", -- x2
                [218] = "FastAttackAlcance", -- x2
                [219] = "FastAttackRitmo",
                [220] = "UDim2", -- x2
                [221] = "fromOffset",
                [222] = "task", -- x6
                [223] = "PVP King",
                [224] = "SUBTITLE",
                [225] = "Tsuo Hub",
                [226] = "SLUG",
                [227] = "Tsuo PVP King",
                [228] = "BUILD",
                [229] = "v2.1",
                [230] = "VERSION",
                [231] = "maisPerto",
                [232] = "UICorner",
                [233] = "UDim",
                [234] = "CornerRadius",
                [235] = "PularZonaSegura",
                [236] = "PularNivelBaixo",
                [237] = "AimNaZonaSegura", -- x2
                [238] = "AimVirar",
                [239] = "Torso", -- x2
                [240] = "AimAlvo",
                [241] = "Travel to the island",
                [242] = "Turn on to go, turn off to stop where you are",
                [243] = "Stop travel",
                [244] = "Cancel",
                [245] = "ButtonText", -- x4
                [246] = "ghost", -- x3
                [247] = "Variant", -- x3
                [248] = "dashDist",
                [249] = "Dash distance",
                [250] = "It stops early if there is a wall in the way -- the dash does not go through anything",
                [251] = "table", -- x2
                [252] = "RunService",
                [253] = "spawn", -- x4
                [254] = "ondeEstaOWorker",
                [255] = "viajar",
                [256] = "cfg",
                [257] = "Distance",
                [258] = "Is_player_ready",
                [259] = "enemies",
                [260] = "islands",
                [261] = "This is our farm hub travel",
                [262] = "Same engine the Blox Fruits hub uses: it routes through a PORTAL past 3.000 studs, yields to whatever else wants to move your body, and handles the submerged island. A hand written tween has none of that, which is why the first version of this file was thrown away.",
                [263] = "TpAltura", -- x2
                [264] = "off",
                [265] = "gethui",
                [266] = "Combat",
                [267] = "rawget",
                [268] = "Hit", -- x2
                [269] = "rawset",
                [270] = "Loaded. RightShift hides and shows.",
                [271] = "success",
                [272] = "MiraSkill",
                [273] = "RightFoot",
                [274] = "LeftFoot",
                [275] = "profiles", -- x2
                [276] = "Section",
                [277] = "Captain Elephant",
                [278] = "Your crew (name only, blue)",
                [279] = "preso",
                [280] = "Puxar",
                [281] = "PuxarDistancia",
                [282] = "PuxarAltura",
                [283] = "SoTimeInimigo",
                [284] = "parte",
                [285] = "quando",
                [286] = "RaycastParams", -- x3
                [287] = "RaycastFilterType", -- x3
                [288] = "espFruit",
                [289] = "Same speed the game's own dash uses, held longer -- that is where the distance comes from",
                [290] = "Dash", -- x2
                [291] = "Beautiful Pirate",
                [292] = "__TSUO_MOTIVO_RARO",
                [293] = "__TSUO_BF_GEN",
                [294] = "general",
                [295] = "Spins your body fast. Hard to hit, and it flings whoever touches you",
                [296] = "Spin", -- x2
                [297] = "travel controls",
                [298] = " deg/s",
                [299] = "SpinVelocidade", -- x2
                [300] = "seta",
                [301] = "ficha",
                [302] = "icone",
                [303] = "jump",
                [304] = "Jump higher",
                [305] = "wait",
                [306] = "Color3",
                [307] = "fromRGB",
                [308] = "dono",
                [309] = "ate",
                [310] = "-",
                [311] = "Is_raiding",
                [312] = "espChams",
                [313] = "VirtualUser",
                [314] = "V",
                [315] = "F",
                [316] = "__PVPKING_SPIN",
                [317] = "UserInputService",
                [318] = "reaper",
                [319] = "yama",
                [320] = "tushita",
                [321] = "EspSoVisivel",
                [322] = "EspDist", -- x2
                [323] = "EspFicha",
                [324] = "__TSUO_Escalona", -- x2
                [325] = "workspace", -- x2
                [326] = "Enemies", -- x2
                [327] = "PlayerRemoving",
                [328] = "__index",
                [329] = "faction",
                [330] = "getTargetInfo", -- x2
                [331] = "loadstring",
                [332] = "Characters",
                [333] = "moving",
                [334] = "__TSUO_IrAte",
                [335] = "Master", -- x2
                [336] = "Darkbeard",
                [337] = "__TSUO_PRIORIDADE", -- x4
                [338] = "dash",
                [339] = "Super dash (press Q)",
                [340] = "ids",
                [341] = "ir", -- x2
                [342] = "PVPKING",
                [343] = "Accent",
                [344] = "tsuo_pvpking",
                [345] = "AutoSave",
                [346] = "SEA3", -- x2
                [347] = "Paint their whole body",
                [348] = "EspChams", -- x2
                [349] = "Z",
                [350] = "How fast",
                [351] = " ws",
                [352] = "16 is the game default. Above 150 is visible from far away",
                [353] = "limpar", -- x2
                [354] = "EspArma",
                [355] = "EspNivel",
                [356] = "EspHaki",
                [357] = "EspVidaTexto",
                [358] = "warn", -- x3
                [359] = "[PvpKing] could not download TSUO UI",
                [360] = "EspIlha", -- x2
                [361] = "EspMundoDist", -- x2
                [362] = "speedVal",
                [363] = "Draw distance",
                [364] = "Measured on a live server: enemies at 11.700 and 19.200 studs, so this goes high",
                [365] = "listar", -- x2
                [366] = "Cursed Captain",
                [367] = "fovModo",
                [368] = "FOV follows",
                [369] = "Canvander",
                [370] = "C",
                [371] = "TsuoPvpDraw", -- x2
                [372] = "ResetOnSpawn",
                [373] = "IgnoreGuiInset",
                [374] = "DisplayOrder",
                [375] = "vidaFundo",
                [376] = "vidaBarra",
                [377] = "tracer",
                [378] = "dist", -- x2
                [379] = "__TSUO_LargarMov",
                [380] = "spinSpeed",
                [381] = "Spin speed",
                [382] = "Switch side",
                [383] = "Apply",
                [384] = "CFrame", -- x2
                [385] = "Vector3",
                [386] = "entrada",
                [387] = "Twin Hooks",
                [388] = "[PvpKing] TSUO UI did not compile",
                [389] = "Dragon Scale",
                [390] = "Magma Ore",
                [391] = "Scrap Metal",
                [392] = "Mystic Droplet",
                [393] = "Vampire Fang",
                [394] = "LocalPlayer",
                [395] = "Workspace",
                [396] = "game", -- x6
                [397] = "PlaceId", -- x6
                [398] = "LeftUpperLeg",
                [399] = "RightHand",
                [400] = "LeftHand",
                [401] = "__TSUO_MinhaVez",
                [402] = "Island",
                [403] = "Read from the game itself, so updates show up on their own",
                [404] = "posicao",
                [405] = "EspAliado", -- x2
                [406] = "EspFruta", -- x2
                [407] = "CheckBackpack",
                [408] = "getdis",
                [409] = "EspNome",
                [410] = "EspVida",
                [411] = "EspDistancia",
                [412] = "EspTracer",
                [413] = "EspSeta", -- x2
                [414] = "passo",
                [415] = "Aim at the body, not the feet",
                [416] = "Uses the game's own height fix: a point resting on the floor is raised to chest level",
                [417] = "Swan Glasses",
                [418] = "dashVal",
                [419] = "Dash speed",
                [420] = "pontoConhecido",
                [421] = "jumpVal",
                [422] = "How high",
                [423] = "aimFov",
                [424] = "",
                [425] = "UpperTorso",
                [426] = "HumanoidRootPart",
                [427] = "Head",
                [428] = "LowerTorso",
                [429] = "Angles",
                [430] = "water",
                [431] = "_tp",
                [432] = "alvo", -- x2
                [433] = "StopTween",
                [434] = "aimSafe",
                [435] = "Aim while your PvP is off",
                [436] = "The game itself says when it is off -- safe zone, or you died recently. Off: nobody is a target until PvP is back.",
                [437] = "fast",
                [438] = "Fast attack",
                [439] = "IrAte",
                [440] = "Keeps energy topped up so dash and geppo never run out",
                [441] = "__newindex",
                [442] = "setmetatable",
                [443] = "haki and race",
                [444] = "buso",
                [445] = "Box, name, health, distance and what they are holding -- with the item icon from the game",
                [446] = "Reset everything",
                [447] = "Back to default",
                [448] = "Erases the saved profile. Run the script again afterwards",
                [449] = "TSUO PVP KING 2.1",
                [450] = "RightShift hides and shows the panel. No key system in this build yet. Nothing here fires an economy remote: it does not buy, sell or drop anything of yours.",
                [451] = "who shows up",
                [452] = "SkillZ",
                [453] = "SkillX",
                [454] = "SkillC",
                [455] = "SemColisao", -- x2
                [456] = "[PvpKing] TSUO UI did not load",
                [457] = "DashVal", -- x2
                [458] = "b1",
                [459] = "b2",
                [460] = "b3",
                [461] = "b4",
                [462] = "string",
                [463] = "__TSUO_NOTIFICADORES_ON",
                [464] = "cacar",
                [465] = "Hydra Leader",
                [466] = "matar",
                [467] = "esperarRenascer",
                [468] = "defer",
                [469] = "safemode",
                [470] = "protect",
                [471] = "fruta",
                [472] = "infJump",
                [473] = "Infinite jump",
                [474] = "speed",
                [475] = "Run faster",
                [476] = "Convert_To_CFrame",
                [477] = "destinosCache",
                [478] = "lidoEm",
                [479] = "tonumber",
                [480] = "SubmarineMaxPrice", -- x2
                [481] = "tplab",
                [482] = "chest",
                [483] = "tryluck",
                [484] = "sharkanchor",
                [485] = "seaentity",
                [486] = "ilha",
                [487] = "farm",
                [488] = "raid",
                [489] = "lawkak",
                [490] = "race",
                [491] = "seatravel",
                [492] = "X",
                [493] = "tpHeight",
                [494] = "__TSUO_MovOcupado",
                [495] = "v3",
                [496] = "Auto race V3",
                [497] = "Keep Buso haki on",
                [498] = "remote",
                [499] = "npc",
                [500] = "esp",
                [501] = "Enemy ESP",
                [502] = "obs",
                [503] = "Keep Observation on",
                [504] = "travel",
                [505] = "(no island found)",
                [506] = "Players",
                [507] = "Hits without waiting for the animation, on enemies in range. Off by default.",
                [508] = "AddProfileManager",
                [509] = "Turns everything off at once without losing your choices",
                [510] = "JumpRequest",
                [511] = "TweenService",
                [512] = "VirtualInputManager",
                [513] = "island",
                [514] = "__TSUO_BootT0",
                [515] = "So you can tell an ally apart from a bug: they never become a target",
                [516] = "world",
                [517] = "Mink is a RACE: what it gives you is a walk speed bonus. There is no remote to 'become Mink' without actually rerolling, and a reroll spends something that is yours -- so this writes the walk speed directly instead. Same result, nothing spent.",
                [518] = "seguidos",
                [519] = "janela",
                [520] = "stamina",
                [521] = "Energy never runs out",
                [522] = "espDist",
                [523] = "Panel color",
                [524] = "__TSUO_SoNaMao",
                [525] = "ipairs",
                [526] = "TemRaro",
                [527] = "LocalDoBoss",
                [528] = "BossVale",
                [529] = "MinhaVez",
                [530] = "MovOcupado",
                [531] = "ondeFicaAIlha",
                [532] = "pontoDe",
                [533] = "Stop this high above it",
                [534] = "How high above the island to stop. 36 is what the farm hub uses",
                [535] = "noclip",
                [536] = "Walk through walls",
                [537] = "Fruit ESP",
                [538] = "PuloVal", -- x2
                [539] = "PuloInfinito", -- x2
                [540] = "espIsland",
                [541] = "Island ESP",
                [542] = "extras",
                [543] = "__TSUO_TemRaro",
                [544] = "Save spawn and die",
                [545] = "For islands with a level barrier: travels there, saves the spawn on the spot and dies, so you come back past the wall",
                [546] = "Visuals",
                [547] = "Move",
                [548] = "fovRing",
                [549] = "Show the lock circle",
                [550] = "White = nothing locked. Purple = locked on someone.",
                [551] = "__TSUO_BossVale",
                [552] = "Every press of jump works, in the air too",
                [553] = "espArrow",
                [554] = "Arrow for who is off screen",
                [555] = "Camera: the cone starts where you look. Mouse: the circle walks with your pointer.",
                [556] = "RE/RegisterAttack",
                [557] = "Rengoku",
            },
            booleans = {
                [0] = false, -- x39
                [1] = true, -- x34
            },
            proto_references = {
                [0] = { proto = 1 },
                [1] = { proto = 2 },
                [2] = { proto = 3 },
                [3] = { proto = 4 },
                [4] = { proto = 5 },
                [5] = { proto = 6 },
                [6] = { proto = 7 },
                [7] = { proto = 8 },
                [8] = { proto = 9 },
                [9] = { proto = 10 },
                [10] = { proto = 11 },
                [11] = { proto = 12 },
                [12] = { proto = 13 },
                [13] = { proto = 14 },
                [14] = { proto = 15 },
                [15] = { proto = 16 },
                [16] = { proto = 17 },
                [17] = { proto = 18 },
                [18] = { proto = 19 },
                [19] = { proto = 20 },
                [20] = { proto = 21 },
                [21] = { proto = 22 },
                [22] = { proto = 23 },
                [23] = { proto = 24 },
                [24] = { proto = 25 },
                [25] = { proto = 26 },
                [26] = { proto = 27 },
                [27] = { proto = 28 },
                [28] = { proto = 29 },
                [29] = { proto = 30 },
                [30] = { proto = 31 },
                [31] = { proto = 32 },
                [32] = { proto = 33 },
                [33] = { proto = 34 },
                [34] = { proto = 35 },
                [35] = { proto = 36 },
                [36] = { proto = 37 },
                [37] = { proto = 38 },
                [38] = { proto = 39 },
                [39] = { proto = 40 },
                [40] = { proto = 41 },
                [41] = { proto = 42 },
                [42] = { proto = 43 },
                [43] = { proto = 44 },
                [44] = { proto = 45 },
                [45] = { proto = 46 },
                [46] = { proto = 47 },
                [47] = { proto = 48 },
                [48] = { proto = 49 },
                [49] = { proto = 50 },
                [50] = { proto = 51 },
                [51] = { proto = 52 },
                [52] = { proto = 53 },
                [53] = { proto = 54 },
                [54] = { proto = 55 },
                [55] = { proto = 56 },
                [56] = { proto = 57 },
                [57] = { proto = 58 },
                [58] = { proto = 59 },
                [59] = { proto = 60 },
                [60] = { proto = 61 },
                [61] = { proto = 62 },
                [62] = { proto = 63 },
                [63] = { proto = 64 },
                [64] = { proto = 65 },
                [65] = { proto = 66 },
                [66] = { proto = 67 },
                [67] = { proto = 68 },
                [68] = { proto = 69 },
                [69] = { proto = 70 },
                [70] = { proto = 71 },
                [71] = { proto = 72 },
                [72] = { proto = 73 },
                [73] = { proto = 74 },
                [74] = { proto = 75 },
                [75] = { proto = 76 },
                [76] = { proto = 77 },
                [77] = { proto = 78 },
                [78] = { proto = 79 },
                [79] = { proto = 80 },
                [80] = { proto = 81 },
                [81] = { proto = 82 },
                [82] = { proto = 83 },
                [83] = { proto = 84 },
                [84] = { proto = 85 },
                [85] = { proto = 86 },
                [86] = { proto = 87 },
                [87] = { proto = 88 },
                [88] = { proto = 89 },
                [89] = { proto = 90 },
                [90] = { proto = 91 },
                [91] = { proto = 92 },
                [92] = { proto = 93 },
                [93] = { proto = 94 },
                [94] = { proto = 95 },
                [95] = { proto = 96 },
                [96] = { proto = 97 },
                [97] = { proto = 98 },
                [98] = { proto = 99 },
                [99] = { proto = 100 },
                [100] = { proto = 101 },
                [101] = { proto = 102 },
                [102] = { proto = 103 },
                [103] = { proto = 104 },
                [104] = { proto = 105 },
                [105] = { proto = 106 },
                [106] = { proto = 107 },
                [107] = { proto = 108 },
                [108] = { proto = 109 },
                [109] = { proto = 110 },
                [110] = { proto = 111 },
                [111] = { proto = 112 },
                [112] = { proto = 113 },
                [113] = { proto = 114 },
                [114] = { proto = 115 },
                [115] = { proto = 116 },
                [116] = { proto = 117 },
                [117] = { proto = 118 },
                [118] = { proto = 119 },
                [119] = { proto = 120 },
                [120] = { proto = 121 },
                [121] = { proto = 122 },
                [122] = { proto = 123 },
                [123] = { proto = 124 },
                [124] = { proto = 125 },
                [125] = { proto = 126 },
                [126] = { proto = 127 },
                [127] = { proto = 128 },
                [128] = { proto = 129 },
                [129] = { proto = 130 },
                [130] = { proto = 131 },
                [131] = { proto = 132 },
                [132] = { proto = 133 },
                [133] = { proto = 134 },
                [134] = { proto = 135 },
                [135] = { proto = 136 },
                [136] = { proto = 137 },
                [137] = { proto = 138 },
                [138] = { proto = 139 },
                [139] = { proto = 140 },
                [140] = { proto = 141 },
                [141] = { proto = 142 },
                [142] = { proto = 143 },
                [143] = { proto = 144 },
                [144] = { proto = 145 },
                [145] = { proto = 146 },
                [146] = { proto = 147 },
                [147] = { proto = 148 },
                [148] = { proto = 149 },
                [149] = { proto = 150 },
                [150] = { proto = 151 },
                [151] = { proto = 152 },
                [152] = { proto = 153 },
                [153] = { proto = 154 },
                [154] = { proto = 155 },
                [155] = { proto = 156 },
                [156] = { proto = 157 },
                [157] = { proto = 158 },
                [158] = { proto = 159 },
                [159] = { proto = 160 },
                [160] = { proto = 161 },
                [161] = { proto = 162 },
                [162] = { proto = 163 },
                [163] = { proto = 164 },
                [164] = { proto = 165 },
                [165] = { proto = 166 },
                [166] = { proto = 167 },
                [167] = { proto = 168 },
                [168] = { proto = 169 },
                [169] = { proto = 170 },
                [170] = { proto = 171 },
                [171] = { proto = 172 },
                [172] = { proto = 173 },
                [173] = { proto = 174 },
                [174] = { proto = 175 },
                [175] = { proto = 176 },
                [176] = { proto = 177 },
                [177] = { proto = 178 },
                [178] = { proto = 179 },
                [179] = { proto = 180 },
                [180] = { proto = 181 },
                [181] = { proto = 182 },
                [182] = { proto = 183 },
                [183] = { proto = 184 },
                [184] = { proto = 185 },
                [185] = { proto = 186 },
                [186] = { proto = 187 },
                [187] = { proto = 188 },
                [188] = { proto = 189 },
                [189] = { proto = 190 },
                [190] = { proto = 191 },
                [191] = { proto = 192 },
                [192] = { proto = 193 },
                [193] = { proto = 194 },
                [194] = { proto = 195 },
                [195] = { proto = 196 },
                [196] = { proto = 197 },
                [197] = { proto = 198 },
                [198] = { proto = 199 },
                [199] = { proto = 200 },
                [200] = { proto = 201 },
                [201] = { proto = 202 },
                [202] = { proto = 203 },
                [203] = { proto = 204 },
                [204] = { proto = 205 },
                [205] = { proto = 206 },
                [206] = { proto = 207 },
                [207] = { proto = 208 },
                [208] = { proto = 209 },
                [209] = { proto = 210 },
            },
        },
        [1] = {
            parent = 0,
            strings = {
                [0] = "SemColisao",
            },
        },
        [2] = {
            parent = 0,
            strings = {
                [0] = "Backpack",
                [1] = "Character",
            },
            table_aliases = {
                [0] = { table_alias = 0 },
            },
        },
        [3] = {
            parent = 0,
            strings = {
                [0] = "Backpack",
                [1] = "Character",
            },
            table_aliases = {
                [0] = { table_alias = 1 },
            },
        },
        [4] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x2
                [1] = "HumanoidRootPart",
                [2] = "BodyClip",
                [3] = "PosMon",
                [4] = "Destroy",
            },
        },
        [5] = {
            parent = 0,
            strings = {
                [0] = "Died",
                [1] = "FindFirstChildOfClass",
                [2] = "Humanoid", -- x2
                [3] = "WaitForChild",
            },
            proto_references = {
                [0] = { proto = 211 },
            },
        },
        [6] = {
            parent = 0,
        },
        [7] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            booleans = {
                [0] = false,
            },
            proto_references = {
                [0] = { proto = 212 },
            },
        },
        [8] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 213 },
            },
        },
        [9] = {
            parent = 0,
            strings = {
                [0] = "Name",
                [1] = "IsA",
                [2] = "Tool",
                [3] = "pcall",
                [4] = "ToolTip",
                [5] = "ipairs",
                [6] = "Backpack",
                [7] = "GetChildren",
            },
            booleans = {
                [0] = true,
                [1] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 214 },
            },
        },
        [10] = {
            parent = 0,
            strings = {
                [0] = "game",
                [1] = "HttpGet",
                [2] = "https://raw.githubusercontent.com/Tsuo7/TsuoHub/refs/heads/main/tsuoui",
            },
        },
        [11] = {
            parent = 0,
            strings = {
                [0] = "EspCor",
            },
        },
        [12] = {
            parent = 0,
            strings = {
                [0] = "All", -- x2
                [1] = "type", -- x2
                [2] = "table", -- x2
                [3] = "pcall",
                [4] = "require",
                [5] = "FindFirstChild",
                [6] = "SpriteMap",
            },
        },
        [13] = {
            parent = 0,
            strings = {
                [0] = "Y",
                [1] = "ImageRectSize",
                [2] = "Image",
                [3] = "ipairs",
                [4] = "1",
                [5] = "",
                [6] = "2",
                [7] = "3",
                [8] = "ImageRectOffset",
                [9] = "type",
                [10] = "table",
                [11] = "pcall",
                [12] = "X",
            },
            booleans = {
                [0] = false,
            },
            proto_references = {
                [0] = { proto = 215 },
            },
        },
        [14] = {
            parent = 0,
            strings = {
                [0] = "virarParaAlvo",
                [1] = "os",
                [2] = "clock",
            },
        },
        [15] = {
            parent = 0,
            strings = {
                [0] = "HipHeight",
                [1] = "Size",
                [2] = "Y",
                [3] = "FindFirstChildOfClass",
                [4] = "Humanoid",
                [5] = "FindFirstChild",
                [6] = "HumanoidRootPart",
            },
        },
        [16] = {
            parent = 0,
            strings = {
                [0] = "FilterDescendantsInstances",
                [1] = "Raycast",
                [2] = "math",
                [3] = "min",
            },
        },
        [17] = {
            parent = 0,
            strings = {
                [0] = "Magnitude", -- x2
                [1] = "math",
                [2] = "clamp",
                [3] = "Position",
                [4] = "AimPrever",
                [5] = "AimAltura",
                [6] = "typeof",
                [7] = "Vector3",
                [8] = "pcall",
                [9] = "AssemblyLinearVelocity",
            },
        },
        [18] = {
            parent = 0,
            strings = {
                [0] = "EspMundoDist",
            },
        },
        [19] = {
            parent = 0,
            strings = {
                [0] = "EspIlha",
            },
        },
        [20] = {
            parent = 0,
            strings = {
                [0] = "EspZonaSegura",
            },
        },
        [21] = {
            parent = 0,
        },
        [22] = {
            parent = 0,
        },
        [23] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x5
                [1] = "SafeZone",
                [2] = "PvpDisabled",
                [3] = "safe zone",
                [4] = "BottomHUDList",
                [5] = "died recently",
                [6] = "Visible", -- x2
                [7] = "Main",
                [8] = "PlayerGui",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true, -- x2
            },
        },
        [24] = {
            parent = 0,
            strings = {
                [0] = "IsA",
                [1] = "BasePart",
                [2] = "Scale", -- x3
                [3] = "Z",
                [4] = "X",
                [5] = "Y",
                [6] = "FindFirstChild", -- x4
                [7] = "InSafeZone",
                [8] = "math",
                [9] = "max",
                [10] = "HumanoidRootPart",
                [11] = "Parent",
                [12] = "Position", -- x2
                [13] = "Value",
                [14] = "FindFirstChildOfClass", -- x2
                [15] = "ForceField",
                [16] = "_WorldOrigin",
                [17] = "Magnitude",
                [18] = "SafeZones",
                [19] = "SpecialMesh",
                [20] = "ipairs",
                [21] = "GetChildren",
            },
            booleans = {
                [0] = false, -- x4
                [1] = true, -- x3
            },
        },
        [25] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 216 },
            },
        },
        [26] = {
            parent = 0,
            strings = {
                [0] = "KeyCode",
                [1] = "AimVirar",
                [2] = "Master",
                [3] = "Aim",
                [4] = "Enum", -- x2
                [5] = "UserInputType", -- x3
                [6] = "Keyboard",
                [7] = "os",
                [8] = "clock",
                [9] = "virarParaAlvo",
                [10] = "MouseButton1",
            },
        },
        [27] = {
            parent = 0,
            strings = {
                [0] = "math",
                [1] = "random",
            },
        },
        [28] = {
            parent = 0,
            strings = {
                [0] = "nome",
                [1] = "ipairs",
                [2] = "_G",
                [3] = "__TSUO_BOSS_LOCAL",
            },
        },
        [29] = {
            parent = 0,
            strings = {
                [0] = "_G", -- x2
                [1] = "__TSUO_PRIORIDADE", -- x2
                [2] = "farm",
                [3] = "tostring",
            },
        },
        [30] = {
            parent = 0,
            strings = {
                [0] = "DashDistancia",
            },
        },
        [31] = {
            parent = 0,
            strings = {
                [0] = "CurrentCamera",
                [1] = "quando",
                [2] = "parte",
                [3] = "os",
                [4] = "clock",
            },
            booleans = {
                [0] = false, -- x3
                [1] = true,
            },
        },
        [32] = {
            parent = 0,
            strings = {
                [0] = "GetMouse",
            },
        },
        [33] = {
            parent = 0,
            strings = {
                [0] = "Spin",
            },
        },
        [34] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 217 },
            },
        },
        [35] = {
            parent = 0,
            strings = {
                [0] = "FovModo",
            },
        },
        [36] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 218 },
            },
        },
        [37] = {
            parent = 0,
            strings = {
                [0] = "Aim",
                [1] = "MiraSkill",
                [2] = "pcall",
                [3] = "AimVirar",
                [4] = "SkillAuto",
                [5] = "Puxar",
                [6] = "LocalPlayer",
            },
            booleans = {
                [0] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 219 },
            },
        },
        [38] = {
            parent = 0,
            strings = {
                [0] = "EspBau",
            },
        },
        [39] = {
            parent = 0,
            strings = {
                [0] = "AimAltura",
            },
        },
        [40] = {
            parent = 0,
            strings = {
                [0] = "buscando", -- x2
                [1] = "task",
                [2] = "spawn",
                [3] = "destinosCache", -- x3
                [4] = "tick",
                [5] = "lidoEm",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 220 },
            },
        },
        [41] = {
            parent = 0,
            strings = {
                [0] = "Position",
                [1] = "Magnitude",
                [2] = "FilterDescendantsInstances",
                [3] = "CFrame",
                [4] = "Raycast",
            },
            booleans = {
                [0] = true,
            },
        },
        [42] = {
            parent = 0,
            strings = {
                [0] = "GetMouseLocation",
                [1] = "Vector2",
                [2] = "new",
                [3] = "X",
                [4] = "Y",
            },
        },
        [43] = {
            parent = 0,
            strings = {
                [0] = "__TSUO_ChaoMantido", -- x2
                [1] = "_G", -- x7
                [2] = "AssemblyLinearVelocity",
                [3] = "math", -- x3
                [4] = "abs", -- x3
                [5] = "X",
                [6] = "IsA",
                [7] = "BasePart",
                [8] = "__TSUO_ParadoDesde", -- x4
                [9] = "tick", -- x2
                [10] = "Y",
                [11] = "Z",
                [12] = "CanCollide",
                [13] = "FindFirstChild",
                [14] = "HumanoidRootPart",
                [15] = "ipairs",
                [16] = "GetDescendants",
                [17] = "__TSUO_VOANDO",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false,
            },
        },
        [44] = {
            parent = 0,
            strings = {
                [0] = "Position",
                [1] = "Vector3",
                [2] = "zero",
                [3] = "math",
                [4] = "huge",
                [5] = "Magnitude",
                [6] = "typeof",
                [7] = "CFrame",
                [8] = "pairs",
            },
        },
        [45] = {
            parent = 0,
        },
        [46] = {
            parent = 0,
            strings = {
                [0] = "CanCollide", -- x2
                [1] = "Master",
                [2] = "ipairs",
                [3] = "GetDescendants",
                [4] = "SemColisao",
                [5] = "pcall",
                [6] = "IsA",
                [7] = "BasePart",
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 221 },
            },
        },
        [47] = {
            parent = 0,
            strings = {
                [0] = "game",
                [1] = "GetService",
                [2] = "type",
                [3] = "pcall",
                [4] = "cloneref", -- x2
                [5] = "function",
            },
        },
        [48] = {
            parent = 0,
            strings = {
                [0] = "FishmanSea1",
                [1] = "SkyArea2",
                [2] = "PathwayHouse",
                [3] = "EntrancePoint", -- x2
                [4] = "Sky2",
                [5] = "SkyArea1",
                [6] = "PathwayTemple",
                [7] = "ExitPoint",
                [8] = "Sky1",
                [9] = "TeleportSpawn",
            },
            proto_references = {
                [0] = { proto = 222 },
            },
        },
        [49] = {
            parent = 0,
            strings = {
                [0] = "CaFe",
                [1] = "GhostShip",
                [2] = "SwanRoom",
            },
            proto_references = {
                [0] = { proto = 223 },
            },
        },
        [50] = {
            parent = 0,
            strings = {
                [0] = "tp",
                [1] = "alvo",
                [2] = "pulados",
                [3] = "AimFovGraus",
                [4] = "fovGraus",
                [5] = "Esp",
                [6] = "ws",
                [7] = "type", -- x2
                [8] = "_G",
                [9] = "__TSUO_IrAte",
                [10] = "function", -- x2
                [11] = "not found",
                [12] = "pairs",
                [13] = "2.1",
                [14] = "versao",
                [15] = "vivo",
                [16] = "Aim",
                [17] = "aim",
                [18] = "WalkSpeed",
                [19] = "aimInfo",
                [20] = "jp",
                [21] = "JumpPower",
                [22] = "Name",
                [23] = "tostring",
                [24] = "Value",
                [25] = "=",
                [26] = "energia",
                [27] = "listar",
                [28] = "ilhas",
                [29] = "_tp",
                [30] = "esp",
                [31] = "EspDist",
                [32] = "espDist",
                [33] = "desenhados",
            },
            proto_references = {
                [0] = { proto = 224 },
            },
        },
        [51] = {
            parent = 0,
            strings = {
                [0] = "erro no Get", -- x2
                [1] = "pcall", -- x8
                [2] = "Set", -- x4
                [3] = "type", -- x2
                [4] = "number",
                [5] = "A", -- x2
                [6] = "Get", -- x4
                [7] = "Options",
                [8] = "ah",
                [9] = "tostring",
                [10] = "nao existe: ",
                [11] = "dZ",
                [12] = "boolean",
            },
            booleans = {
                [0] = true, -- x3
            },
        },
        [52] = {
            parent = 0,
            strings = {
                [0] = "table",
                [1] = "sort",
                [2] = "pairs",
                [3] = "Options",
            },
        },
        [53] = {
            parent = 0,
            strings = {
                [0] = "AimFovGraus",
            },
        },
        [54] = {
            parent = 0,
            strings = {
                [0] = "AndarNaAgua",
            },
        },
        [55] = {
            parent = 0,
            strings = {
                [0] = "Backpack",
                [1] = "FindFirstChild", -- x2
                [2] = "pairs",
                [3] = "Character",
            },
            booleans = {
                [0] = true,
            },
        },
        [56] = {
            parent = 0,
            strings = {
                [0] = "tonumber", -- x2
                [1] = "TransportationPrice",
                [2] = "seguidos", -- x6
                [3] = "janela", -- x2
                [4] = "alvo", -- x4
                [5] = "dist", -- x4
                [6] = "Character", -- x6
                [7] = "FindFirstChild", -- x13
                [8] = "HumanoidRootPart", -- x3
                [9] = "LastSpawnPoint", -- x2
                [10] = "_G", -- x25
                [11] = "string",
                [12] = "format",
                [13] = "%s (%s beli) as %s",
                [14] = "tostring", -- x2
                [15] = "Name", -- x8
                [16] = "os",
                [17] = "date",
                [18] = "%H:%M:%S",
                [19] = "__TSUO_SubOldTpDestino",
                [20] = "usou", -- x3
                [21] = "type",
                [22] = "number",
                [23] = "__TSUO_EmCombate", -- x4
                [24] = "perto", -- x3
                [25] = "cooldown", -- x3
                [26] = "raid", -- x3
                [27] = "chip", -- x3
                [28] = "fruta", -- x3
                [29] = "item", -- x3
                [30] = "semPasta", -- x3
                [31] = "semSpawn", -- x3
                [32] = "longeDoAlvo", -- x3
                [33] = "naoCompensa", -- x3
                [34] = "recusado", -- x3
                [35] = "combate", -- x3
                [36] = "SubmarineMaxPrice",
                [37] = "Position", -- x13
                [38] = "Y", -- x5
                [39] = "workspace", -- x2
                [40] = "WorldOrigin",
                [41] = "__TSUO_SubPorOldTp", -- x2
                [42] = "Data", -- x3
                [43] = "Beli",
                [44] = "maisPerto",
                [45] = "__TSUO_TemRaro", -- x2
                [46] = "TweenMonitor", -- x2
                [47] = "task",
                [48] = "spawn",
                [49] = "pcall", -- x3
                [50] = "GetPivot",
                [51] = "Magnitude", -- x6
                [52] = "tick", -- x7
                [53] = "__TSUO_SpawnRuim", -- x6
                [54] = "pairs",
                [55] = "Check_raid_chip", -- x2
                [56] = "__TSUO_AtalhoMotivo", -- x7
                [57] = "itemRaro", -- x2
                [58] = "math", -- x6
                [59] = "abs", -- x3
                [60] = "preso",
                [61] = "X", -- x2
                [62] = "Z", -- x2
                [63] = "CFrame", -- x4
                [64] = "Check_Inventory", -- x2
                [65] = "God's Chalice", -- x2
                [66] = "Red Key", -- x2
                [67] = "Apple", -- x2
                [68] = "Banana", -- x2
                [69] = "Pineapple", -- x2
                [70] = "Flower 1", -- x2
                [71] = "Flower 2", -- x2
                [72] = "Flower 3", -- x2
                [73] = "Sweet Chalice", -- x2
                [74] = "Is_player_ready",
                [75] = "Convert_To_CFrame",
                [76] = "SetLastSpawnPoint",
                [77] = "Value", -- x3
                [78] = "viajar",
                [79] = "PlayerSpawns", -- x2
                [80] = "Check_fruit_inventory", -- x2
                [81] = "FindFirstChildOfClass",
                [82] = "Humanoid",
                [83] = "clamp",
                [84] = "TweenSpeed",
                [85] = "Health",
                [86] = "table",
                [87] = "sort",
                [88] = "PlaybackState", -- x2
                [89] = "Enum", -- x2
                [90] = "Playing",
                [91] = "Part",
                [92] = "Team",
                [93] = "ceil",
                [94] = "huge",
                [95] = "Is_raiding", -- x2
                [96] = "Create",
                [97] = "TweenInfo",
                [98] = "new",
                [99] = "EasingStyle",
                [100] = "Linear",
                [101] = "Play",
                [102] = "__TSUO_VOANDO",
                [103] = "getgenv",
                [104] = "ipairs",
                [105] = "GetChildren",
                [106] = "_WorldOrigin",
            },
            booleans = {
                [0] = true, -- x4
                [1] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 225 },
                [1] = { proto = 226 },
                [2] = { proto = 227 },
                [3] = { proto = 228 },
                [4] = { proto = 229 },
            },
        },
        [57] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x2
                [1] = "Data",
                [2] = "nil",
                [3] = "", -- x2
                [4] = "CrewID",
                [5] = "tostring",
                [6] = "Value",
            },
        },
        [58] = {
            parent = 0,
            strings = {
                [0] = "Team", -- x2
                [1] = "Name",
            },
        },
        [59] = {
            parent = 0,
            strings = {
                [0] = "Marines", -- x2
                [1] = "Team", -- x2
                [2] = "Name",
            },
            booleans = {
                [0] = false,
                [1] = true, -- x2
            },
        },
        [60] = {
            parent = 0,
            strings = {
                [0] = "GetAttribute", -- x2
                [1] = "InSafeZone",
                [2] = "in safe zone",
                [3] = "PvpDisabled",
                [4] = "pvp off",
            },
            booleans = {
                [0] = true, -- x4
                [1] = false,
            },
        },
        [61] = {
            parent = 0,
            strings = {
                [0] = "PularZonaSegura", -- x2
                [1] = "dead",
                [2] = "AimNaZonaSegura",
                [3] = "no root",
                [4] = "low level",
                [5] = "safe zone",
                [6] = "you",
                [7] = "SoTimeInimigo",
                [8] = "same crew",
                [9] = "math",
                [10] = "floor",
                [11] = "no character",
                [12] = "PularNivelBaixo",
                [13] = "your pvp is off (",
                [14] = "tostring",
                [15] = ")",
                [16] = "Health",
            },
        },
        [62] = {
            parent = 0,
            strings = {
                [0] = "EspFruta",
            },
        },
        [63] = {
            parent = 0,
            strings = {
                [0] = "typeof",
                [1] = "Color3",
                [2] = "R",
                [3] = "G",
                [4] = "B",
            },
        },
        [64] = {
            parent = 0,
            strings = {
                [0] = "Dot",
                [1] = "Unit",
                [2] = "CFrame",
                [3] = "LookVector",
                [4] = "X",
                [5] = "Y",
                [6] = "Z",
                [7] = "Magnitude",
                [8] = "Position", -- x2
                [9] = "AimVirar",
                [10] = "os",
                [11] = "clock",
                [12] = "pcall",
            },
            proto_references = {
                [0] = { proto = 230 },
            },
        },
        [65] = {
            parent = 0,
            strings = {
                [0] = "IsA",
                [1] = "Tool",
                [2] = "ipairs",
                [3] = "GetChildren",
            },
        },
        [66] = {
            parent = 0,
            strings = {
                [0] = "Master",
                [1] = "pcall",
                [2] = "AntiStun",
            },
            proto_references = {
                [0] = { proto = 231 },
            },
        },
        [67] = {
            parent = 0,
            strings = {
                [0] = "SpinVelocidade",
            },
        },
        [68] = {
            parent = 0,
            strings = {
                [0] = "table",
                [1] = "type",
                [2] = "pontoDe",
                [3] = "pairs",
                [4] = "math",
                [5] = "huge",
                [6] = "Magnitude",
                [7] = "Name",
                [8] = "destinos",
            },
        },
        [69] = {
            parent = 0,
            strings = {
                [0] = "EspChams",
            },
        },
        [70] = {
            parent = 0,
            strings = {
                [0] = "Dash",
            },
        },
        [71] = {
            parent = 0,
            strings = {
                [0] = "pcall", -- x4
                [1] = "Travel", -- x5
                [2] = "Underwater island -- going by the submarine, not by air.",
                [3] = "Stopped.",
                [4] = ". Turn this off to stop.",
                [5] = "Heading to ",
                [6] = "error",
                [7] = "_G", -- x2
                [8] = "__TSUO_IrAteCancelar",
                [9] = "__TSUO_IrAteCancelarEm",
                [10] = "Island not found.",
                [11] = "posicao",
                [12] = " studs -- that is underwater or inside the map. Flying there drowns you, so I am not going.",
                [13] = " sits at ",
                [14] = "warning",
                [15] = "task", -- x2
                [16] = "spawn", -- x2
                [17] = "Y", -- x2
                [18] = "Submerged Island",
                [19] = "math",
                [20] = "floor",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 232 },
                [1] = { proto = 233 },
                [2] = { proto = 234 },
                [3] = { proto = 235 },
                [4] = { proto = 236 },
            },
        },
        [72] = {
            parent = 0,
            strings = {
                [0] = "Travel",
                [1] = "_G",
                [2] = "__TSUO_IrAteCancelar",
                [3] = "pcall",
                [4] = "Cancelled.",
                [5] = "warning",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 237 },
            },
        },
        [73] = {
            parent = 0,
            strings = {
                [0] = "Character", -- x2
                [1] = "FindFirstChild", -- x3
                [2] = "HumanoidRootPart", -- x3
                [3] = "pontoConhecido", -- x2
                [4] = "CFrame", -- x4
                [5] = "ondeEstaOWorker", -- x3
                [6] = "table",
                [7] = "npc", -- x2
                [8] = "type",
                [9] = "PrimaryPart", -- x2
                [10] = "remote",
                [11] = "pcall",
            },
            booleans = {
                [0] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 238 },
            },
        },
        [74] = {
            parent = 0,
        },
        [75] = {
            parent = 0,
            strings = {
                [0] = "Teleport",
                [1] = ").",
                [2] = "table",
                [3] = "find",
                [4] = "tostring", -- x2
                [5] = "|", -- x2
                [6] = "pcall",
                [7] = "Island list updated for this sea (",
                [8] = "_G",
                [9] = "__TSUO_Escalona",
                [10] = "listar",
            },
            proto_references = {
                [0] = { proto = 239 },
            },
        },
        [76] = {
            parent = 0,
            strings = {
                [0] = "Y", -- x2
                [1] = "math",
                [2] = "huge",
                [3] = "Character", -- x2
                [4] = "FindFirstChild",
                [5] = "HumanoidRootPart",
                [6] = "tick", -- x2
                [7] = "X", -- x2
                [8] = "Z", -- x2
                [9] = "Magnitude",
                [10] = "Position",
            },
        },
        [77] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x2
                [1] = "Humanoid", -- x2
                [2] = "Health",
                [3] = "Character",
                [4] = "HumanoidRootPart",
            },
        },
        [78] = {
            parent = 0,
            strings = {
                [0] = "tick",
                [1] = "_G",
                [2] = "__TSUO_Beacon",
                [3] = "tsuopvpking",
                [4] = "2.1",
            },
        },
        [79] = {
            parent = 0,
            strings = {
                [0] = "Phoenix",
                [1] = "Buddha",
                [2] = "Love",
                [3] = "Creation",
                [4] = "Spider",
                [5] = "Sound",
                [6] = "Quake",
                [7] = "Kitsune",
                [8] = "Yeti",
                [9] = "Gas",
                [10] = "Control",
                [11] = "http", -- x2
                [12] = "request", -- x4
                [13] = "Saber Expert", -- x2
                [14] = "rotulo", -- x14
                [15] = "Darkbeard",
                [16] = "nome", -- x14
                [17] = "Darkbeard (Barba Negra)",
                [18] = "Cursed Captain",
                [19] = "http_request",
                [20] = "syn", -- x2
                [21] = "Beautiful Pirate", -- x2
                [22] = "https://tsuoblox.com/api/notify/report",
                [23] = "API",
                [24] = "VARRER",
                [25] = "CARENCIA",
                [26] = "CARENCIA_MIRAGE",
                [27] = "snow white",
                [28] = "pure red",
                [29] = "winter sky",
                [30] = "aquamarine",
                [31] = "light pink",
                [32] = "ligar", -- x2
                [33] = "Spirit",
                [34] = "Leopard",
                [35] = "Dragon",
                [36] = "Portal",
                [37] = "Shizu", -- x2
                [38] = "Shisui", -- x2
                [39] = "Saishi", -- x2
                [40] = "Saddi", -- x2
                [41] = "Greybeard",
                [42] = "Greybeard (Barba Branca)",
                [43] = "close",
                [44] = "cancel",
                [45] = "yes",
                [46] = "no",
                [47] = "Tiki",
                [48] = "Tiki (evento)",
                [49] = "Oroshi", -- x2
                [50] = "T-Rex",
                [51] = "Mammoth",
                [52] = "Gravity",
                [53] = "Blizzard",
                [54] = "Pain",
                [55] = "Rumble",
                [56] = "rip_indra",
                [57] = "Rip Indra",
                [58] = "legendary sword dealer",
                [59] = "sword dealer",
                [60] = "dealer",
                [61] = "fluxus", -- x2
                [62] = "Wando", -- x2
                [63] = "interact",
                [64] = "e",
                [65] = "buy",
                [66] = "Cursed Captain (barco fantasma)",
                [67] = "Tide Keeper", -- x2
                [68] = "Awakened Ice Admiral", -- x2
                [69] = "Dough King", -- x2
                [70] = "game", -- x3
                [71] = "GetService", -- x3
                [72] = "Players",
                [73] = "Workspace",
                [74] = "Soul Reaper",
                [75] = "Soul Reaper (a foice, castelo assombrado)",
                [76] = "you found me!",
                [77] = "gone.",
                [78] = "Venom",
                [79] = "Shadow",
                [80] = "Dough",
                [81] = "Kilo Admiral", -- x2
                [82] = "Captain Elephant", -- x2
                [83] = "desligar",
                [84] = "press",
                [85] = "talk",
                [86] = "shop",
                [87] = "HttpService",
                [88] = "rip_indra True Form",
                [89] = "Rip Indra (True Form, raid)",
            },
            booleans = {
                [0] = true, -- x20
            },
            proto_references = {
                [0] = { proto = 240 },
                [1] = { proto = 241 },
                [2] = { proto = 242 },
                [3] = { proto = 243 },
                [4] = { proto = 244 },
                [5] = { proto = 245 },
                [6] = { proto = 246 },
                [7] = { proto = 247 },
                [8] = { proto = 248 },
                [9] = { proto = 249 },
                [10] = { proto = 250 },
                [11] = { proto = 251 },
                [12] = { proto = 252 },
                [13] = { proto = 253 },
            },
        },
        [80] = {
            parent = 0,
            strings = {
                [0] = "Master",
                [1] = "StaminaInf",
                [2] = "pcall", -- x3
                [3] = "Health",
                [4] = "Pulo",
                [5] = "Velocidade",
                [6] = "math",
                [7] = "abs",
                [8] = "WalkSpeed",
                [9] = "VelocidadeVal",
            },
            proto_references = {
                [0] = { proto = 254 },
                [1] = { proto = 255 },
                [2] = { proto = 256 },
            },
        },
        [81] = {
            parent = 0,
            strings = {
                [0] = "KeyCode", -- x2
                [1] = "Enum", -- x2
                [2] = "Q",
                [3] = "FilterDescendantsInstances",
                [4] = "DashDistancia",
                [5] = "Raycast",
                [6] = "Position", -- x3
                [7] = "CurrentCamera",
                [8] = "math",
                [9] = "max",
                [10] = "Magnitude", -- x2
                [11] = "task",
                [12] = "spawn",
                [13] = "os",
                [14] = "clock",
                [15] = "Master",
                [16] = "Unit",
                [17] = "RaycastParams",
                [18] = "new",
                [19] = "RaycastFilterType",
                [20] = "Dash",
                [21] = "Exclude",
                [22] = "FilterType",
                [23] = "CFrame",
                [24] = "LookVector",
                [25] = "X",
                [26] = "Z",
            },
            proto_references = {
                [0] = { proto = 257 },
            },
        },
        [82] = {
            parent = 0,
            strings = {
                [0] = "AutoObs",
            },
        },
        [83] = {
            parent = 0,
            strings = {
                [0] = "B",
                [1] = "R",
                [2] = "G",
                [3] = "Color3",
                [4] = "EspCor",
                [5] = "typeof",
            },
        },
        [84] = {
            parent = 0,
            strings = {
                [0] = "Position", -- x4
                [1] = "b4", -- x3
                [2] = "b1", -- x3
                [3] = "BackgroundColor3",
                [4] = "Visible",
                [5] = "b3", -- x3
                [6] = "Size", -- x4
                [7] = "b2", -- x3
                [8] = "ipairs",
                [9] = "EspCor",
            },
            booleans = {
                [0] = true,
            },
        },
        [85] = {
            parent = 0,
            strings = {
                [0] = "ir",
                [1] = "Bypass",
                [2] = "e_",
                [3] = "error",
            },
            proto_references = {
                [0] = { proto = 258 },
            },
        },
        [86] = {
            parent = 0,
            strings = {
                [0] = "Instance", -- x2
                [1] = "Position", -- x2
                [2] = "IsDescendantOf",
                [3] = "FindFirstChild", -- x3
                [4] = "FilterDescendantsInstances",
                [5] = "ipairs",
                [6] = "Boats",
                [7] = "IsA",
                [8] = "BasePart",
                [9] = "_WorldOrigin",
                [10] = "Raycast",
            },
        },
        [87] = {
            parent = 0,
            strings = {
                [0] = "EspHaki",
                [1] = "EspVidaTexto",
                [2] = "EspNome",
                [3] = "EspVida",
                [4] = "EspDistancia",
                [5] = "EspFicha",
                [6] = "EspArma",
                [7] = "EspNivel",
                [8] = "Esp",
                [9] = "EspCaixa",
            },
        },
        [88] = {
            parent = 0,
            strings = {
                [0] = "tick", -- x2
                [1] = "Health",
                [2] = "FindFirstChildOfClass",
                [3] = "Humanoid",
                [4] = "FindFirstChild",
                [5] = "HumanoidRootPart",
                [6] = "_G",
                [7] = "__TSUO_CharPronto",
                [8] = "type",
                [9] = "function",
                [10] = "IsDescendantOf",
                [11] = "workspace",
            },
        },
        [89] = {
            parent = 0,
        },
        [90] = {
            parent = 0,
            strings = {
                [0] = "SetAttribute",
                [1] = "AAIM",
            },
        },
        [91] = {
            parent = 0,
            strings = {
                [0] = "pcall",
                [1] = "pairs",
            },
            proto_references = {
                [0] = { proto = 259 },
            },
        },
        [92] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x3
                [1] = "Submerged Island",
                [2] = "pcall",
                [3] = "Locations",
                [4] = "workspace",
                [5] = "_WorldOrigin",
            },
            proto_references = {
                [0] = { proto = 260 },
            },
        },
        [93] = {
            parent = 0,
            strings = {
                [0] = "Character", -- x2
                [1] = "FindFirstChild",
                [2] = "HumanoidRootPart",
                [3] = "Position", -- x2
                [4] = "Y",
                [5] = "Magnitude",
                [6] = "ondeFicaAIlha",
            },
            booleans = {
                [0] = false, -- x2
            },
        },
        [94] = {
            parent = 0,
            strings = {
                [0] = "Parent", -- x2
                [1] = "Position", -- x2
                [2] = "origem",
                [3] = "Magnitude",
                [4] = "alvo", -- x2
                [5] = "os",
                [6] = "clock",
                [7] = "parte",
                [8] = "quando",
            },
        },
        [95] = {
            parent = 0,
            strings = {
                [0] = "Position", -- x14
                [1] = "Magnitude", -- x7
                [2] = "MiraSkillAlcance", -- x5
                [3] = "max",
                [4] = "math", -- x14
                [5] = "tan", -- x2
                [6] = "ViewportSize",
                [7] = "Y", -- x3
                [8] = "Z", -- x2
                [9] = "char", -- x4
                [10] = "AimFovGraus", -- x3
                [11] = "AimSoVisivel", -- x6
                [12] = "huge", -- x4
                [13] = "rad", -- x2
                [14] = "FieldOfView",
                [15] = "CFrame", -- x3
                [16] = "ipairs", -- x4
                [17] = "LookVector",
                [18] = "FovModo",
                [19] = "Mouse",
                [20] = "AimNpc", -- x2
                [21] = "acos",
                [22] = "clamp",
                [23] = "Dot",
                [24] = "Unit",
                [25] = "WorldToViewportPoint", -- x2
                [26] = "deg",
                [27] = "sqrt",
                [28] = "GetPlayers", -- x2
                [29] = "min",
                [30] = "X", -- x2
                [31] = "origem",
                [32] = "AimAlcanceModo",
            },
            booleans = {
                [0] = false, -- x3
            },
        },
        [96] = {
            parent = 0,
            strings = {
                [0] = "Spin",
                [1] = "_G", -- x2
                [2] = "__PVPKING_SPIN", -- x2
            },
        },
        [97] = {
            parent = 0,
            strings = {
                [0] = "seta", -- x3
                [1] = "TextSize",
                [2] = "b3",
                [3] = "b2",
                [4] = "Enum",
                [5] = "Font", -- x2
                [6] = "GothamBlack",
                [7] = "BackgroundColor3",
                [8] = "vidaFundo", -- x3
                [9] = "BackgroundTransparency",
                [10] = "vidaBarra",
                [11] = "ficha",
                [12] = "b1",
                [13] = "chams",
                [14] = "icone",
                [15] = "b4",
                [16] = "tracer",
                [17] = "nome",
                [18] = "dist",
            },
            proto_references = {
                [0] = { proto = 261 },
            },
        },
        [98] = {
            parent = 0,
            strings = {
                [0] = "ipairs",
                [1] = "chams", -- x2
                [2] = "Enabled",
                [3] = "Visible",
            },
            booleans = {
                [0] = false, -- x2
            },
        },
        [99] = {
            parent = 0,
            strings = {
                [0] = "chams",
                [1] = "pcall", -- x2
                [2] = "ipairs",
            },
            proto_references = {
                [0] = { proto = 262 },
                [1] = { proto = 263 },
            },
        },
        [100] = {
            parent = 0,
            strings = {
                [0] = "VelocidadeVal",
            },
        },
        [101] = {
            parent = 0,
        },
        [102] = {
            parent = 0,
            strings = {
                [0] = "pcall",
                [1] = "StartingRaid",
            },
            booleans = {
                [0] = true,
            },
            table_aliases = {
                [0] = { table_alias = 2 },
            },
        },
        [103] = {
            parent = 0,
            strings = {
                [0] = "Backpack",
                [1] = "Character",
            },
            table_aliases = {
                [0] = { table_alias = 3 },
            },
        },
        [104] = {
            parent = 0,
            strings = {
                [0] = "tick", -- x2
            },
        },
        [105] = {
            parent = 0,
            strings = {
                [0] = "Value", -- x2
                [1] = "FindFirstChild", -- x2
                [2] = "Stun",
                [3] = "Busy",
                [4] = "Sit",
            },
            booleans = {
                [0] = true, -- x3
                [1] = false,
            },
        },
        [106] = {
            parent = 0,
            strings = {
                [0] = "Position", -- x2
                [1] = "Magnitude",
                [2] = "ipairs",
                [3] = "GetPlayers",
            },
        },
        [107] = {
            parent = 0,
            strings = {
                [0] = "FastAttackAlcance",
                [1] = "4 args, %d target(s), token %q",
                [2] = "IsA",
                [3] = "Tool",
                [4] = "_G", -- x5
                [5] = "__TSUO_Escalona",
                [6] = "Master",
                [7] = "pcall", -- x2
                [8] = "string",
                [9] = "format",
                [10] = "__TSUO_PVP_FA_GOLPES", -- x2
                [11] = "FastAttackRitmo",
                [12] = "FastAttack",
                [13] = "__TSUO_PVP_HIT_DIZ",
                [14] = "__TSUO_PVP_COMBO",
                [15] = "tostring", -- x2
                [16] = "UserId",
                [17] = "sub", -- x2
                [18] = "coroutine",
                [19] = "running",
                [20] = "ipairs",
                [21] = "GetChildren",
            },
            proto_references = {
                [0] = { proto = 264 },
                [1] = { proto = 265 },
            },
        },
        [108] = {
            parent = 0,
            strings = {
                [0] = "type", -- x2
                [1] = "Cooldown", -- x2
                [2] = "table", -- x2
                [3] = "tool", -- x2
                [4] = "cds", -- x6
                [5] = "pcall",
                [6] = "Z",
                [7] = "X",
                [8] = "C",
                [9] = "V",
                [10] = "F",
                [11] = "next",
                [12] = "FindFirstChild",
                [13] = "Data",
            },
            proto_references = {
                [0] = { proto = 266 },
            },
        },
        [109] = {
            parent = 0,
        },
        [110] = {
            parent = 0,
            strings = {
                [0] = "math", -- x10
                [1] = "tan", -- x2
                [2] = "rad", -- x2
                [3] = "X", -- x4
                [4] = "clamp", -- x4
                [5] = "Y", -- x5
                [6] = "Position", -- x2
                [7] = "EspCor",
                [8] = "max",
                [9] = "Thickness",
                [10] = "CurrentCamera",
                [11] = "min",
                [12] = "FieldOfView",
                [13] = "Mouse",
                [14] = "MostrarFov",
                [15] = "Size",
                [16] = "FovModo",
                [17] = "Vector2",
                [18] = "new",
                [19] = "AimFovGraus",
                [20] = "Color",
                [21] = "Master",
                [22] = "Visible", -- x2
                [23] = "Transparency",
                [24] = "ViewportSize",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false,
            },
        },
        [111] = {
            parent = 0,
            strings = {
                [0] = "Connect",
            },
        },
        [112] = {
            parent = 0,
        },
        [113] = {
            parent = 0,
            strings = {
                [0] = "Position", -- x22
                [1] = "tracer", -- x6
                [2] = "math", -- x16
                [3] = "Name", -- x5
                [4] = "ipairs", -- x3
                [5] = "GetPlayers", -- x2
                [6] = "WorldToViewportPoint", -- x3
                [7] = "Y", -- x8
                [8] = "X", -- x6
                [9] = "Size", -- x9
                [10] = "ficha", -- x6
                [11] = "Visible", -- x9
                [12] = "pairs", -- x2
                [13] = "vidaFundo", -- x3
                [14] = "Text", -- x5
                [15] = "nome", -- x12
                [16] = "EspArma",
                [17] = "deg", -- x2
                [18] = "Rotation", -- x2
                [19] = "tostring",
                [20] = "Esp", -- x3
                [21] = "corpo", -- x4
                [22] = "clamp", -- x4
                [23] = "Health", -- x4
                [24] = "max",
                [25] = "MaxHealth",
                [26] = "EspChams",
                [27] = "DisplayName", -- x2
                [28] = "BackgroundColor3", -- x2
                [29] = "dist", -- x6
                [30] = "FindFirstChild", -- x2
                [31] = "Head", -- x2
                [32] = "maos vazias",
                [33] = "seta", -- x6
                [34] = "pcall", -- x4
                [35] = "passo",
                [36] = "CurrentCamera", -- x3
                [37] = "Z", -- x4
                [38] = "same crew",
                [39] = "TextColor3", -- x5
                [40] = "TextSize", -- x4
                [41] = "icone", -- x6
                [42] = "AnchorPoint",
                [43] = "GetAttribute", -- x2
                [44] = "KenActive", -- x2
                [45] = "OutlineColor",
                [46] = "chams", -- x9
                [47] = "Enabled", -- x2
                [48] = "Image", -- x2
                [49] = "ImageRectOffset", -- x2
                [50] = "EspNivel",
                [51] = "min",
                [52] = "EspNome",
                [53] = "vidaBarra", -- x4
                [54] = "Vector2",
                [55] = "new", -- x2
                [56] = "sin",
                [57] = "EspDistancia",
                [58] = "Magnitude", -- x2
                [59] = "EspDist", -- x2
                [60] = "EspCaixa",
                [61] = "IsA",
                [62] = "Tool",
                [63] = "string", -- x2
                [64] = "format", -- x2
                [65] = "%d hp",
                [66] = "EspVidaTexto",
                [67] = "CFrame", -- x3
                [68] = "PointToObjectSpace",
                [69] = "atan2", -- x2
                [70] = "EspZonaSegura",
                [71] = "EspSoVisivel",
                [72] = "%d studs",
                [73] = "  [team]",
                [74] = "ViewportSize",
                [75] = "lv ",
                [76] = "Adornee",
                [77] = "FillColor",
                [78] = "Master", -- x2
                [79] = "cos",
                [80] = "EspVida",
                [81] = "sqrt",
                [82] = "floor", -- x2
                [83] = "limpar",
                [84] = "OBS",
                [85] = "^",
                [86] = "GetChildren",
                [87] = "TsuoPvpChams",
                [88] = "FillTransparency",
                [89] = "Enum",
                [90] = "]",
                [91] = "  [",
                [92] = "EspSeta",
                [93] = "EspAliado", -- x2
                [94] = "EspTracer",
                [95] = "",
                [96] = "Instance",
                [97] = "Highlight",
                [98] = "  |  ",
                [99] = "table",
                [100] = "concat",
                [101] = "ImageRectSize", -- x2
                [102] = "EspHaki",
                [103] = "EspFicha",
                [104] = "EspMostrarPulados",
                [105] = "Parent", -- x2
                [106] = "HighlightDepthMode",
                [107] = "AlwaysOnTop",
                [108] = "DepthMode",
                [109] = "abs",
            },
            booleans = {
                [0] = true, -- x12
                [1] = false,
            },
            proto_references = {
                [0] = { proto = 267 },
            },
        },
        [114] = {
            parent = 0,
            strings = {
                [0] = "Hit",
                [1] = "type", -- x2
                [2] = "table",
                [3] = "function",
                [4] = "rawget",
                [5] = "__index",
            },
        },
        [115] = {
            parent = 0,
            strings = {
                [0] = "Hit",
                [1] = "rawset",
            },
        },
        [116] = {
            parent = 0,
            strings = {
                [0] = "Parent",
                [1] = "pairs",
                [2] = "pcall",
            },
            proto_references = {
                [0] = { proto = 268 },
            },
        },
        [117] = {
            parent = 0,
            strings = {
                [0] = "GetAttribute",
                [1] = "AAIM",
                [2] = "pcall", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 269 },
                [1] = { proto = 270 },
            },
        },
        [118] = {
            parent = 0,
            strings = {
                [0] = "Position", -- x2
                [1] = "parte", -- x3
                [2] = "CFrame",
                [3] = "CurrentCamera",
                [4] = "Parent",
                [5] = "os",
                [6] = "clock",
                [7] = "quando",
            },
        },
        [119] = {
            parent = 0,
            strings = {
                [0] = "CoreGui",
                [1] = "Parent",
            },
        },
        [120] = {
            parent = 0,
            strings = {
                [0] = "CFrame",
                [1] = "Part",
            },
        },
        [121] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 271 },
            },
        },
        [122] = {
            parent = 0,
            strings = {
                [0] = "ipairs",
                [1] = "GetChildren",
                [2] = "IsA",
                [3] = "Tool",
            },
        },
        [123] = {
            parent = 0,
            strings = {
                [0] = "Master",
                [1] = "CurrentCamera",
                [2] = "Position", -- x2
                [3] = "Aim",
                [4] = "CFrame",
            },
        },
        [124] = {
            parent = 0,
            strings = {
                [0] = "_G",
                [1] = "__TSUO_IrAte",
                [2] = "posicao",
                [3] = "TpAltura",
                [4] = "ilha",
                [5] = "island not found",
            },
            booleans = {
                [0] = false,
            },
            proto_references = {
                [0] = { proto = 272 },
            },
        },
        [125] = {
            parent = 0,
            strings = {
                [0] = "_G",
                [1] = "__PVPKING_GEN",
            },
        },
        [126] = {
            parent = 0,
            strings = {
                [0] = "Mansion",
                [1] = "Castle",
            },
        },
        [127] = {
            parent = 0,
            strings = {
                [0] = "gethui",
                [1] = "Parent",
            },
        },
        [128] = {
            parent = 0,
        },
        [129] = {
            parent = 0,
            strings = {
                [0] = "GetPropertyChangedSignal",
                [1] = "Value",
                [2] = "Connect",
                [3] = "Destroy",
                [4] = "Disconnect",
                [5] = "FindFirstChild",
                [6] = "MousePos",
            },
            proto_references = {
                [0] = { proto = 273 },
                [1] = { proto = 274 },
            },
        },
        [130] = {
            parent = 0,
            strings = {
                [0] = "DashVal",
            },
        },
        [131] = {
            parent = 0,
            strings = {
                [0] = "_G", -- x2
                [1] = "__TSUO_MOV", -- x2
                [2] = "dono", -- x2
                [3] = "coroutine",
                [4] = "running",
                [5] = "ate",
                [6] = "-",
                [7] = "nome",
            },
        },
        [132] = {
            parent = 0,
            strings = {
                [0] = "Remotes", -- x2
                [1] = "FindFirstChild", -- x2
                [2] = "CommF_",
                [3] = "task",
                [4] = "spawn",
                [5] = "error",
                [6] = "Team", -- x2
                [7] = "Name",
                [8] = "Faction",
                [9] = "CommF_ not found.",
            },
            proto_references = {
                [0] = { proto = 275 },
            },
        },
        [133] = {
            parent = 0,
            strings = {
                [0] = "Heartbeat",
                [1] = "Connect",
            },
            proto_references = {
                [0] = { proto = 276 },
            },
        },
        [134] = {
            parent = 0,
            strings = {
                [0] = "nome", -- x4
                [1] = "__TSUO_MOV_ULTIMO",
                [2] = "pcall",
                [3] = "dono", -- x3
                [4] = "coroutine", -- x2
                [5] = "running", -- x2
                [6] = "tick", -- x2
                [7] = "ate", -- x2
                [8] = "%s (andar %d) tomou de %s (andar %d)",
                [9] = "tostring", -- x2
                [10] = "_G", -- x3
                [11] = "__TSUO_MOV", -- x2
                [12] = "string",
                [13] = "format",
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
            proto_references = {
                [0] = { proto = 277 },
            },
        },
        [135] = {
            parent = 0,
            strings = {
                [0] = "TextBox",
                [1] = "Vector2", -- x5
                [2] = "new", -- x5
                [3] = "pt", -- x2
                [4] = "MouseButton1Click", -- x3
                [5] = "Connect", -- x4
                [6] = "Sibling",
                [7] = "ZIndexBehavior", -- x2
                [8] = "pcall", -- x5
                [9] = "Size", -- x16
                [10] = "Frame", -- x6
                [11] = "https://tsuoblox.com/api/script-keys",
                [12] = "API_BASE",
                [13] = "tick", -- x4
                [14] = "AnchorPoint", -- x5
                [15] = "Position", -- x14
                [16] = "UDim2", -- x4
                [17] = "fromScale", -- x4
                [18] = "", -- x5
                [19] = "type", -- x2
                [20] = "getgenv", -- x5
                [21] = "function", -- x2
                [22] = "Enum", -- x10
                [23] = "Font", -- x16
                [24] = "Gotham", -- x6
                [25] = "BackgroundColor3", -- x6
                [26] = "Text", -- x9
                [27] = "TextSize", -- x8
                [28] = "en", -- x2
                [29] = "Visible", -- x2
                [30] = "Parent", -- x16
                [31] = "TextLabel", -- x7
                [32] = "game", -- x2
                [33] = "GetService", -- x2
                [34] = "Players",
                [35] = "LocalPlayer", -- x3
                [36] = "Connecting to Tsuo servers...",
                [37] = "TSUO_LANG", -- x2
                [38] = "VERSION",
                [39] = "TsuoKeyUI",
                [40] = "Name",
                [41] = "ResetOnSpawn",
                [42] = "IgnoreGuiInset",
                [43] = "TextColor3", -- x8
                [44] = "rbxthumb://type=Asset&id=90690292624964&w=420&h=420",
                [45] = "ScreenGui",
                [46] = "TextYAlignment", -- x2
                [47] = "Top",
                [48] = "BackgroundTransparency", -- x11
                [49] = "TsuoHub_Key",
                [50] = "SLUG",
                [51] = "Tsuo Hub",
                [52] = "tostring", -- x2
                [53] = "UserId",
                [54] = "Autenticando sua key...",
                [55] = "Authenticating your key...",
                [56] = "DISCORD",
                [57] = "BorderSizePixel", -- x6
                [58] = "FocusLost",
                [59] = "PlaceholderColor3",
                [60] = "ClearTextOnFocus",
                [61] = "TextWrapped", -- x3
                [62] = "PEGAR KEY (Discord)",
                [63] = "GET KEY (Discord)",
                [64] = "TITLE",
                [65] = "TSUO HUB",
                [66] = "Conectando aos servidores Tsuo...",
                [67] = "Preparando o hub...",
                [68] = "Preparing your hub...",
                [69] = "SUBTITLE",
                [70] = "TSUO_KEY_BYPASS",
                [71] = "KEY_FILE",
                [72] = "ENVIAR KEY",
                [73] = "SUBMIT KEY",
                [74] = "FECHAR",
                [75] = "CLOSE",
                [76] = "GothamBold", -- x2
                [77] = "Key valida! Abrindo o hub...",
                [78] = "Key valid! Opening the hub...",
                [79] = "HttpService",
                [80] = "PEGAR SUA KEY",
                [81] = "GET YOUR KEY",
                [82] = "LOGO",
                [83] = "DisplayOrder",
                [84] = "task", -- x2
                [85] = "spawn", -- x2
                [86] = "gsub",
                [87] = " ",
                [88] = "%%20",
                [89] = "Paste key here...",
                [90] = "PlaceholderText",
                [91] = "https://discord.gg/tsuo",
                [92] = "ImageLabel", -- x2
                [93] = "Image", -- x2
                [94] = "Cole sua key e clique em Enviar.",
                [95] = "Paste your key and click Submit.",
                [96] = "BUILD",
                [97] = "Cole a key aqui...",
                [98] = "Cole sua key abaixo e clique em Enviar. Nao tem key? Pegue no nosso Discord.",
                [99] = "Paste your key below and click Submit. No key? Get one in our Discord.",
            },
            booleans = {
                [0] = true, -- x9
                [1] = false, -- x11
            },
            proto_references = {
                [0] = { proto = 278 },
                [1] = { proto = 279 },
                [2] = { proto = 280 },
                [3] = { proto = 281 },
                [4] = { proto = 282 },
                [5] = { proto = 283 },
                [6] = { proto = 284 },
                [7] = { proto = 285 },
                [8] = { proto = 286 },
                [9] = { proto = 287 },
                [10] = { proto = 288 },
                [11] = { proto = 289 },
                [12] = { proto = 290 },
                [13] = { proto = 291 },
                [14] = { proto = 292 },
                [15] = { proto = 293 },
                [16] = { proto = 294 },
                [17] = { proto = 295 },
                [18] = { proto = 296 },
                [19] = { proto = 297 },
                [20] = { proto = 298 },
                [21] = { proto = 299 },
                [22] = { proto = 300 },
                [23] = { proto = 301 },
                [24] = { proto = 302 },
                [25] = { proto = 303 },
                [26] = { proto = 304 },
                [27] = { proto = 305 },
                [28] = { proto = 306 },
                [29] = { proto = 307 },
                [30] = { proto = 308 },
                [31] = { proto = 309 },
            },
        },
        [136] = {
            parent = 0,
            strings = {
                [0] = "Name", -- x2
                [1] = "TsuoPvpChams",
                [2] = "TsuoPvpPiso",
                [3] = "__PVPKING_GEN", -- x2
                [4] = "pcall", -- x6
                [5] = "ipairs", -- x3
                [6] = "_G", -- x5
                [7] = "__PVPKING_UNLOAD",
                [8] = "PVPKING",
                [9] = "GetDescendants",
                [10] = "__TSUO_IrAteCancelar",
                [11] = "GetChildren",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 310 },
                [1] = { proto = 311 },
                [2] = { proto = 312 },
                [3] = { proto = 313 },
                [4] = { proto = 314 },
                [5] = { proto = 315 },
            },
        },
        [137] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 316 },
            },
        },
        [138] = {
            parent = 0,
            strings = {
                [0] = "pcall", -- x2
            },
            proto_references = {
                [0] = { proto = 317 },
                [1] = { proto = 318 },
            },
        },
        [139] = {
            parent = 0,
            strings = {
                [0] = "_G",
                [1] = "__TSUO_PegarMov",
            },
        },
        [140] = {
            parent = 0,
            strings = {
                [0] = "pcall",
                [1] = "type",
                [2] = "Name",
                [3] = "table",
            },
            booleans = {
                [0] = false,
            },
            proto_references = {
                [0] = { proto = 319 },
            },
        },
        [141] = {
            parent = 0,
            strings = {
                [0] = "ShootAttachment",
                [1] = "FindFirstChild", -- x3
                [2] = "ShootAttachment1",
                [3] = "WorldPosition",
                [4] = "GetAttribute",
                [5] = "CurrentShootAttachment",
                [6] = "Value",
                [7] = "LocalEquippedWeaponPointer",
                [8] = "Position", -- x2
                [9] = "IsA", -- x2
                [10] = "BasePart",
                [11] = "Attachment",
            },
            booleans = {
                [0] = true, -- x2
            },
        },
        [142] = {
            parent = 0,
            strings = {
                [0] = "__TSUO_PVP_HOLDING_SOLTO", -- x2
                [1] = "FindFirstChild",
                [2] = "Holding",
                [3] = "ipairs",
                [4] = "GetChildren",
                [5] = "os", -- x2
                [6] = "clock", -- x2
                [7] = "IsA",
                [8] = "Tool",
                [9] = "Value", -- x2
                [10] = "_G", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [143] = {
            parent = 0,
            strings = {
                [0] = "type",
                [1] = "table",
                [2] = "FindFirstChild",
                [3] = "Mouse",
                [4] = "pcall",
                [5] = "require",
                [6] = "Hit",
            },
        },
        [144] = {
            parent = 0,
        },
        [145] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x2
                [1] = "Enemies",
                [2] = "Characters",
            },
        },
        [146] = {
            parent = 0,
            strings = {
                [0] = "Name",
                [1] = "FindFirstChild",
                [2] = "HumanoidRootPart",
                [3] = "Health",
                [4] = "nome",
                [5] = "char",
                [6] = "ipairs",
                [7] = "GetChildren",
                [8] = "IsA",
                [9] = "Model",
                [10] = "FindFirstChildOfClass",
                [11] = "Humanoid",
            },
        },
        [147] = {
            parent = 0,
            strings = {
                [0] = "Name", -- x3
                [1] = "FindFirstChild", -- x2
                [2] = "Locations",
                [3] = "ipairs",
                [4] = "GetChildren",
                [5] = "table",
                [6] = "sort",
                [7] = "_WorldOrigin",
            },
            booleans = {
                [0] = true,
            },
        },
        [148] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x3
                [1] = "Locations",
                [2] = "IsA",
                [3] = "BasePart", -- x2
                [4] = "Position", -- x2
                [5] = "_WorldOrigin",
                [6] = "FindFirstChildWhichIsA",
            },
            booleans = {
                [0] = true,
            },
        },
        [149] = {
            parent = 0,
            strings = {
                [0] = "Backpack",
                [1] = "FindFirstChild", -- x2
                [2] = "Character", -- x2
            },
        },
        [150] = {
            parent = 0,
            strings = {
                [0] = "Character", -- x2
                [1] = "Position",
                [2] = "X",
                [3] = "FindFirstChild",
                [4] = "HumanoidRootPart",
                [5] = "Y",
                [6] = "Z",
                [7] = "Magnitude",
            },
        },
        [151] = {
            parent = 0,
            strings = {
                [0] = "EspSeta",
            },
        },
        [152] = {
            parent = 0,
            strings = {
                [0] = "BackgroundTransparency",
                [1] = "Enum",
                [2] = "Font", -- x2
                [3] = "Parent",
                [4] = "Instance",
                [5] = "new",
                [6] = "TextLabel",
                [7] = "GothamBold",
                [8] = "TextSize",
                [9] = "TextStrokeTransparency",
                [10] = "Visible",
            },
            booleans = {
                [0] = false,
            },
        },
        [153] = {
            parent = 0,
            strings = {
                [0] = "ipairs", -- x2
                [1] = "GetChildren",
                [2] = "pcall",
                [3] = "obj",
                [4] = "Demon Fruit",
                [5] = "IsA",
                [6] = "Tool",
                [7] = "tool",
                [8] = "Name", -- x3
                [9] = "find",
                [10] = "%-",
                [11] = "Blox Fruit",
                [12] = "tostring",
                [13] = "ToolTip",
                [14] = "Instance",
                [15] = "type",
                [16] = "table",
                [17] = "typeof",
                [18] = "",
            },
            proto_references = {
                [0] = { proto = 320 },
            },
        },
        [154] = {
            parent = 0,
            strings = {
                [0] = "ipairs",
                [1] = "Name", -- x2
                [2] = "find",
                [3] = "Chest",
                [4] = "GetChildren",
            },
        },
        [155] = {
            parent = 0,
            strings = {
                [0] = "Name", -- x3
                [1] = "FindFirstChild", -- x2
                [2] = "Locations",
                [3] = "_WorldOrigin",
                [4] = "ipairs",
                [5] = "GetChildren",
            },
            booleans = {
                [0] = true,
            },
        },
        [156] = {
            parent = 0,
            strings = {
                [0] = "typeof",
                [1] = "Instance",
                [2] = "pcall",
                [3] = "Position", -- x3
                [4] = "IsA", -- x2
                [5] = "BasePart", -- x2
                [6] = "Model",
                [7] = "FindFirstChildWhichIsA",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 321 },
            },
        },
        [157] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 322 },
            },
        },
        [158] = {
            parent = 0,
            strings = {
                [0] = "EspDist",
            },
        },
        [159] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChildOfClass",
                [1] = "Humanoid",
            },
        },
        [160] = {
            parent = 0,
            strings = {
                [0] = "Health",
            },
            booleans = {
                [0] = false,
            },
        },
        [161] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x3
                [1] = "Torso",
                [2] = "UpperTorso",
                [3] = "HumanoidRootPart",
            },
        },
        [162] = {
            parent = 0,
            strings = {
                [0] = "Pulo",
                [1] = "pcall",
            },
            proto_references = {
                [0] = { proto = 323 },
            },
        },
        [163] = {
            parent = 0,
            strings = {
                [0] = "X",
                [1] = "Z",
                [2] = "CFrame",
                [3] = "Position",
                [4] = "Y", -- x2
                [5] = "Master",
                [6] = "TsuoPvpPiso",
                [7] = "Name",
                [8] = "Anchored",
                [9] = "CanCollide",
                [10] = "AndarNaAgua",
                [11] = "Instance",
                [12] = "new",
                [13] = "Part",
                [14] = "Size",
                [15] = "Transparency",
                [16] = "Parent",
            },
            booleans = {
                [0] = true, -- x2
            },
        },
        [164] = {
            parent = 0,
            strings = {
                [0] = "AutoV4",
            },
        },
        [165] = {
            parent = 0,
            strings = {
                [0] = "%.0f studs to go",
                [1] = "typeof", -- x2
                [2] = "Vector3",
                [3] = "cancelado", -- x2
                [4] = "destino invalido",
                [5] = "_tp",
                [6] = "hub recarregado",
                [7] = "CFrame",
                [8] = "_G", -- x9
                [9] = "__TSUO_LargarMov", -- x2
                [10] = "chegou",
                [11] = "tick", -- x3
                [12] = "__TSUO_ViajandoAte", -- x2
                [13] = "Character",
                [14] = "no character",
                [15] = "__TSUO_BF_GEN", -- x2
                [16] = "FindFirstChild",
                [17] = "HumanoidRootPart",
                [18] = "ilha",
                [19] = "another feature took over",
                [20] = "string",
                [21] = "format",
                [22] = "__TSUO_IrAteCancelar", -- x2
                [23] = "Position", -- x2
                [24] = "Magnitude",
                [25] = "__TSUO_MinhaVez",
            },
            booleans = {
                [0] = false, -- x8
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 324 },
            },
        },
        [166] = {
            parent = 0,
            strings = {
                [0] = "PuloVal",
            },
        },
        [167] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x4
                [1] = "Torso", -- x2
                [2] = "math",
                [3] = "huge",
                [4] = "ipairs",
                [5] = "GetChildren",
                [6] = "AimAlvo", -- x2
                [7] = "Head", -- x2
                [8] = "Transparency",
                [9] = "IsA",
                [10] = "BasePart",
                [11] = "HumanoidRootPart",
                [12] = "X", -- x2
                [13] = "Y", -- x2
                [14] = "WorldToViewportPoint",
                [15] = "Position",
                [16] = "Z",
                [17] = "UpperTorso",
            },
        },
        [168] = {
            parent = 0,
            strings = {
                [0] = "__TSUO_VOANDO",
                [1] = "pcall",
                [2] = "Cancel",
                [3] = "_G",
            },
            booleans = {
                [0] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 325 },
            },
        },
        [169] = {
            parent = 0,
        },
        [170] = {
            parent = 0,
            strings = {
                [0] = "ipairs", -- x4
                [1] = "pairs",
                [2] = "Parent", -- x2
                [3] = "EspFruta",
                [4] = "X",
                [5] = "Y",
                [6] = "Position",
                [7] = "Size",
                [8] = "Visible", -- x2
                [9] = "math",
                [10] = "floor",
                [11] = "  ",
                [12] = "EspBau",
                [13] = "EspIlha",
                [14] = "Text",
                [15] = "TextColor3",
                [16] = "Z",
                [17] = "WorldToViewportPoint",
                [18] = "pcall",
                [19] = "Magnitude",
                [20] = "EspMundoDist",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false,
            },
            proto_references = {
                [0] = { proto = 326 },
            },
        },
        [171] = {
            parent = 0,
            strings = {
                [0] = "AimNaZonaSegura",
            },
        },
        [172] = {
            parent = 0,
            strings = {
                [0] = " (weapon has no MousePos)",
                [1] = "Speed", -- x4
                [2] = "math", -- x6
                [3] = "clamp", -- x2
                [4] = "Position", -- x6
                [5] = "Magnitude", -- x3
                [6] = "Vector3",
                [7] = "zero",
                [8] = "Range", -- x3
                [9] = "floor", -- x2
                [10] = " (no clear line -- something is in the way)",
                [11] = "string", -- x2
                [12] = "format", -- x2
                [13] = " (skill aim off: %d studs away)",
                [14] = "huge", -- x2
                [15] = " (no weapon in hand)",
                [16] = "no target in FOV",
                [17] = "MiraSkillAlcance", -- x2
                [18] = "locked on ",
                [19] = "WeaponType",
                [20] = "Gun",
                [21] = " (gun reaches %d studs, he is at %d)",
                [22] = "you are dead",
                [23] = "off",
                [24] = "MiraSkill",
                [25] = "AssemblyLinearVelocity",
                [26] = "Master",
                [27] = "FindFirstChild",
                [28] = "MousePos",
                [29] = "pcall",
                [30] = "ShootType",
                [31] = "Projectile",
                [32] = "Aim",
            },
            booleans = {
                [0] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 327 },
            },
        },
        [173] = {
            parent = 0,
            strings = {
                [0] = "StaminaInf",
            },
        },
        [174] = {
            parent = 0,
            strings = {
                [0] = "MiraSkillAlcance",
            },
        },
        [175] = {
            parent = 0,
            strings = {
                [0] = "Reset",
                [1] = "Profile erased. Run the script again.",
                [2] = "warning",
                [3] = "pcall",
            },
            proto_references = {
                [0] = { proto = 328 },
            },
        },
        [176] = {
            parent = 0,
            strings = {
                [0] = "AutoBuso",
            },
        },
        [177] = {
            parent = 0,
            strings = {
                [0] = "task",
                [1] = "delay",
                [2] = "pcall", -- x2
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
            proto_references = {
                [0] = { proto = 329 },
                [1] = { proto = 330 },
                [2] = { proto = 331 },
            },
        },
        [178] = {
            parent = 0,
            strings = {
                [0] = "tick", -- x2
            },
            booleans = {
                [0] = false, -- x2
                [1] = true,
            },
        },
        [179] = {
            parent = 0,
            strings = {
                [0] = "type", -- x2
                [1] = "table",
                [2] = "isfile", -- x2
                [3] = "function",
                [4] = "tsuo_pvpking_",
                [5] = "HttpService",
                [6] = "Padrao",
                [7] = "pcall", -- x3
                [8] = ".json",
            },
            proto_references = {
                [0] = { proto = 332 },
                [1] = { proto = 333 },
                [2] = { proto = 334 },
            },
        },
        [180] = {
            parent = 0,
            strings = {
                [0] = "CFrame",
                [1] = "typeof",
                [2] = "Vector3",
            },
        },
        [181] = {
            parent = 0,
            strings = {
                [0] = "Remotes",
                [1] = "CommF_",
                [2] = "InvokeServer",
            },
        },
        [182] = {
            parent = 0,
            strings = {
                [0] = "island not found",
                [1] = "you are dead",
                [2] = "posicao",
                [3] = "task",
                [4] = "spawn",
                [5] = "started",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 335 },
            },
        },
        [183] = {
            parent = 0,
            strings = {
                [0] = "_G",
                [1] = "__TSUO_MOV",
                [2] = "dono", -- x2
                [3] = "coroutine",
                [4] = "running",
                [5] = "tick",
                [6] = "ate",
            },
        },
        [184] = {
            parent = 0,
            strings = {
                [0] = "Character", -- x5
                [1] = "getdis", -- x3
                [2] = "_G", -- x21
                [3] = "__TSUO_SairDaSubmersa", -- x2
                [4] = "pcall", -- x5
                [5] = "__TSUO_BypassIlha", -- x2
                [6] = "tick", -- x9
                [7] = "string",
                [8] = "Modules",
                [9] = "Net",
                [10] = "Position", -- x17
                [11] = "Magnitude", -- x6
                [12] = "MoonlightMovementAutomationActive", -- x2
                [13] = "__TSUO_PortalRuim", -- x4
                [14] = "old_tp", -- x3
                [15] = "FindFirstChild", -- x3
                [16] = "HumanoidRootPart", -- x2
                [17] = "GetPortal",
                [18] = "CFrame", -- x2
                [19] = "SafeModeActive", -- x2
                [20] = "RF/SubmarineWorkerSpeak",
                [21] = "Y", -- x2
                [22] = "__TSUO_SemAtalho", -- x2
                [23] = "math", -- x3
                [24] = "abs",
                [25] = "__TSUO_UltPortal", -- x2
                [26] = "Vector3", -- x2
                [27] = "zero", -- x2
                [28] = "requestEntrance",
                [29] = "__TSUO_Geracao",
                [30] = "__TSUO_IrPelaCasa", -- x2
                [31] = "typeof",
                [32] = "dono", -- x2
                [33] = "coroutine",
                [34] = "running",
                [35] = "tostring",
                [36] = "__TSUO_MOV",
                [37] = "ate",
                [38] = "format",
                [39] = "portal descartado: %d -> %d studs",
                [40] = "floor", -- x2
                [41] = "__TSUO_PortalMotivo",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 336 },
                [1] = { proto = 337 },
            },
        },
        [185] = {
            parent = 0,
            strings = {
                [0] = "ipairs",
                [1] = "GetDescendants",
                [2] = "Name",
                [3] = "RF/SubmarineTransportation",
            },
        },
        [186] = {
            parent = 0,
            strings = {
                [0] = "FastAttack",
            },
        },
        [187] = {
            parent = 0,
            strings = {
                [0] = "Master",
            },
        },
        [188] = {
            parent = 0,
            strings = {
                [0] = "PuloInfinito",
                [1] = "os",
                [2] = "clock",
                [3] = "Master",
                [4] = "pcall",
            },
            proto_references = {
                [0] = { proto = 338 },
            },
        },
        [189] = {
            parent = 0,
            strings = {
                [0] = "Value",
                [1] = "AutoV4",
                [2] = "tick", -- x6
                [3] = "pcall", -- x4
                [4] = "FindFirstChild", -- x6
                [5] = "Remotes", -- x2
                [6] = "CommE",
                [7] = "_G",
                [8] = "__TSUO_Escalona",
                [9] = "HasBuso",
                [10] = "AutoObs",
                [11] = "KenDisabled",
                [12] = "GetAttribute", -- x2
                [13] = "Buso",
                [14] = "KenActive", -- x2
                [15] = "RaceEnergy",
                [16] = "AutoBuso",
                [17] = "AutoV3",
                [18] = "Master",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 339 },
                [1] = { proto = 340 },
                [2] = { proto = 341 },
                [3] = { proto = 342 },
            },
        },
        [190] = {
            parent = 0,
            strings = {
                [0] = "IsA", -- x3
                [1] = "IntConstrainedValue",
                [2] = "NumberValue",
                [3] = "ipairs",
                [4] = "GetChildren",
                [5] = "find", -- x2
                [6] = "stamina",
                [7] = "Name",
                [8] = "lower",
                [9] = "energy",
                [10] = "IntValue",
            },
        },
        [191] = {
            parent = 0,
            strings = {
                [0] = "AutoV3",
            },
        },
        [192] = {
            parent = 0,
            strings = {
                [0] = "EspAliado",
            },
        },
        [193] = {
            parent = 0,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 343 },
            },
        },
        [194] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x2
                [1] = "Submarine Worker2",
                [2] = "workspace",
                [3] = "NPCs",
            },
        },
        [195] = {
            parent = 0,
            strings = {
                [0] = "typeof",
                [1] = "CFrame",
                [2] = "Position",
                [3] = "EndLocation",
            },
        },
        [196] = {
            parent = 0,
        },
        [197] = {
            parent = 0,
            strings = {
                [0] = "TpAltura",
            },
        },
        [198] = {
            parent = 0,
            strings = {
                [0] = "_G", -- x4
                [1] = "Name", -- x2
                [2] = "__TSUO_MOTIVO_RARO", -- x2
                [3] = "GetChildren",
                [4] = "IsA",
                [5] = "Tool",
                [6] = "ipairs", -- x3
                [7] = "__TSUO_SoNaMao",
                [8] = "Character",
                [9] = "FindFirstChild",
                [10] = "Backpack",
                [11] = "__TSUO_RAROS",
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
        },
        [199] = {
            parent = 0,
            strings = {
                [0] = "task",
                [1] = "delay",
                [2] = "FindFirstChildOfClass",
                [3] = "Humanoid",
                [4] = "Character",
                [5] = "Sit",
                [6] = "Health",
                [7] = "ChangeState",
                [8] = "Enum",
                [9] = "HumanoidStateType",
                [10] = "Dead",
            },
            booleans = {
                [0] = false,
            },
            proto_references = {
                [0] = { proto = 344 },
            },
        },
        [200] = {
            parent = 0,
            strings = {
                [0] = "tonumber",
                [1] = "Value",
                [2] = "IsA",
                [3] = "Player",
                [4] = "type",
                [5] = "table",
                [6] = "FindFirstChild", -- x2
                [7] = "Bounty/Honor",
                [8] = "Instance",
                [9] = "leaderstats",
                [10] = "typeof",
            },
        },
        [201] = {
            parent = 0,
            strings = {
                [0] = "Name",
                [1] = "?",
                [2] = "typeof",
                [3] = "Instance",
                [4] = "nome",
                [5] = "none",
                [6] = "DisplayName",
                [7] = "%s: %d bounty",
                [8] = "_G",
                [9] = "string", -- x2
                [10] = "format", -- x2
                [11] = "__TSUO_PVP_BOUNTY_DIZ",
                [12] = "%s (%d)",
            },
        },
        [202] = {
            parent = 0,
            strings = {
                [0] = "char", -- x2
                [1] = "type",
                [2] = "table",
                [3] = "Character",
            },
        },
        [203] = {
            parent = 0,
            strings = {
                [0] = "FastAttackAlcance",
            },
        },
        [204] = {
            parent = 0,
            strings = {
                [0] = "MostrarFov",
            },
        },
        [205] = {
            parent = 0,
            strings = {
                [0] = "_G", -- x3
                [1] = "__TSUO_LocalDoBoss",
                [2] = "drops", -- x2
                [3] = "__TSUO_QuantoTem", -- x2
                [4] = "ipairs",
            },
            booleans = {
                [0] = true, -- x3
                [1] = false,
            },
        },
        [206] = {
            parent = 0,
            strings = {
                [0] = "PuloInfinito",
            },
        },
        [207] = {
            parent = 0,
            strings = {
                [0] = "Instance",
                [1] = "new",
                [2] = "Frame",
                [3] = "BorderSizePixel",
                [4] = "EspCor",
                [5] = "BackgroundColor3",
                [6] = "Visible",
                [7] = "Parent",
            },
            booleans = {
                [0] = false,
            },
        },
        [208] = {
            parent = 0,
            strings = {
                [0] = "Instance",
                [1] = "new", -- x2
                [2] = "TextLabel",
                [3] = "BackgroundTransparency",
                [4] = "Enum",
                [5] = "Font", -- x2
                [6] = "GothamBold",
                [7] = "Parent",
                [8] = "TextSize",
                [9] = "Color3",
                [10] = "TextColor3",
                [11] = "TextStrokeTransparency",
                [12] = "Visible",
            },
            booleans = {
                [0] = false,
            },
        },
        [209] = {
            parent = 0,
            strings = {
                [0] = "FindFirstChild", -- x3
                [1] = "AimAssist",
                [2] = "table",
                [3] = "type", -- x2
                [4] = "getTargetInfo",
                [5] = "function",
                [6] = "Controllers",
                [7] = "CombatController",
                [8] = "pcall",
                [9] = "require",
            },
        },
        [210] = {
            parent = 0,
            strings = {
                [0] = "pcall",
                [1] = "Velocidade",
            },
            proto_references = {
                [0] = { proto = 345 },
            },
        },
        [211] = {
            parent = 5,
        },
        [212] = {
            parent = 7,
            strings = {
                [0] = "FindFirstChild", -- x4
                [1] = "Name",
                [2] = "Cooldown",
                [3] = "PlayerGui",
                [4] = "Main",
                [5] = "Skills",
                [6] = "AbsoluteSize",
                [7] = "X",
            },
            booleans = {
                [0] = true, -- x3
            },
        },
        [213] = {
            parent = 8,
            strings = {
                [0] = "SendKeyEvent", -- x2
                [1] = "math",
                [2] = "random",
            },
            booleans = {
                [0] = true,
                [1] = false, -- x3
            },
        },
        [214] = {
            parent = 9,
            strings = {
                [0] = "EquipTool",
            },
        },
        [215] = {
            parent = 13,
        },
        [216] = {
            parent = 25,
            strings = {
                [0] = "tonumber",
                [1] = "Data",
                [2] = "Level",
                [3] = "Value",
            },
        },
        [217] = {
            parent = 34,
            strings = {
                [0] = "Destroy",
            },
        },
        [218] = {
            parent = 36,
            strings = {
                [0] = "rawset",
                [1] = "setmetatable",
                [2] = "Hit",
            },
        },
        [219] = {
            parent = 37,
            strings = {
                [0] = "SetAttribute",
                [1] = "AAIM",
            },
        },
        [220] = {
            parent = 40,
            strings = {
                [0] = "buscando",
                [1] = "remote",
                [2] = "table",
                [3] = "pcall",
                [4] = "tick",
                [5] = "destinosCache",
                [6] = "lidoEm",
                [7] = "type",
            },
            booleans = {
                [0] = false,
            },
            proto_references = {
                [0] = { proto = 346 },
            },
        },
        [221] = {
            parent = 46,
            strings = {
                [0] = "CanCollide",
            },
            booleans = {
                [0] = false,
            },
        },
        [222] = {
            parent = 48,
            strings = {
                [0] = "FindFirstChild",
                [1] = "ipairs",
                [2] = "Position",
                [3] = "_G",
                [4] = "__TSUO_NoMapa",
            },
        },
        [223] = {
            parent = 49,
            strings = {
                [0] = "FindFirstChild",
                [1] = "TeleportSpawn",
                [2] = "_G",
                [3] = "__TSUO_NoMapa",
                [4] = "GhostShipInterior",
                [5] = "Position",
            },
        },
        [224] = {
            parent = 50,
            strings = {
                [0] = " ",
                [1] = "GetPlayers",
                [2] = "table", -- x2
                [3] = "concat",
                [4] = "ipairs",
                [5] = "sort",
                [6] = "pairs",
                [7] = "serve de alvo",
                [8] = ", ",
            },
        },
        [225] = {
            parent = 56,
            strings = {
                [0] = "TweenMonitor", -- x2
                [1] = "tick", -- x2
                [2] = "Character", -- x3
                [3] = "_G",
                [4] = "__TSUO_Escalona",
                [5] = "Health",
                [6] = "PlaybackState", -- x2
                [7] = "Enum",
                [8] = "Playing",
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [226] = {
            parent = 56,
            strings = {
                [0] = "PivotTo",
                [1] = "CFrame",
            },
        },
        [227] = {
            parent = 56,
            strings = {
                [0] = "SetSpawnPoint",
            },
        },
        [228] = {
            parent = 56,
        },
        [229] = {
            parent = 56,
        },
        [230] = {
            parent = 64,
            strings = {
                [0] = "CFrame", -- x2
                [1] = "lookAt",
            },
        },
        [231] = {
            parent = 66,
            strings = {
                [0] = "Value", -- x2
                [1] = "FindFirstChild", -- x2
                [2] = "Stun",
                [3] = "Busy",
            },
            booleans = {
                [0] = false,
            },
        },
        [232] = {
            parent = 71,
            strings = {
                [0] = "Set", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [233] = {
            parent = 71,
            strings = {
                [0] = "tostring",
                [1] = "Travel",
                [2] = "_G", -- x2
                [3] = "__TSUO_IrAteCancelar",
                [4] = "success",
                [5] = "pcall",
                [6] = "warning",
                [7] = "__TSUO_IrAte",
                [8] = "TpAltura",
                [9] = "ilha",
                [10] = ".",
                [11] = "Arrived at ",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 347 },
                [1] = { proto = 348 },
            },
        },
        [234] = {
            parent = 71,
            strings = {
                [0] = "_G", -- x2
                [1] = "__TSUO_LargarMov", -- x2
            },
        },
        [235] = {
            parent = 71,
            strings = {
                [0] = "Set", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [236] = {
            parent = 71,
            strings = {
                [0] = "warning",
                [1] = "viajar",
                [2] = "Submerged Island",
                [3] = "Travel",
                [4] = "The submarine refused the trip.",
                [5] = "Arrived.",
                [6] = "pcall",
                [7] = "success",
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
            proto_references = {
                [0] = { proto = 349 },
            },
        },
        [237] = {
            parent = 72,
        },
        [238] = {
            parent = 73,
            strings = {
                [0] = "InvokeServer",
                [1] = "InitiateTeleport",
            },
        },
        [239] = {
            parent = 75,
            strings = {
                [0] = "SetValues", -- x2
            },
        },
        [240] = {
            parent = 79,
            strings = {
                [0] = "", -- x3
                [1] = "pcall", -- x2
                [2] = "hwid",
                [3] = "uid",
                [4] = "type", -- x2
                [5] = "string",
                [6] = "gethwid", -- x2
                [7] = "function",
            },
            proto_references = {
                [0] = { proto = 350 },
            },
        },
        [241] = {
            parent = 79,
            strings = {
                [0] = "Health",
                [1] = "FindFirstChildOfClass",
                [2] = "Humanoid",
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [242] = {
            parent = 79,
            strings = {
                [0] = "FindFirstChild", -- x3
                [1] = "Enemies",
            },
            booleans = {
                [0] = true,
            },
        },
        [243] = {
            parent = 79,
            strings = {
                [0] = "Name", -- x2
                [1] = "gsub", -- x4
                [2] = "%-.*",
                [3] = "find",
                [4] = "Fruit",
                [5] = "^%s+",
                [6] = "", -- x4
                [7] = "%s+$",
                [8] = "%s*Fruit%s*",
                [9] = "nome",
                [10] = "valor",
                [11] = "ipairs",
                [12] = "GetChildren",
                [13] = "FindFirstChild",
                [14] = "Handle",
            },
        },
        [244] = {
            parent = 79,
            strings = {
                [0] = "rotulo",
                [1] = "nome", -- x2
                [2] = "ipairs",
            },
        },
        [245] = {
            parent = 79,
            strings = {
                [0] = "Core",
                [1] = "GetChildren",
                [2] = "FindFirstChild", -- x4
                [3] = "Circle",
                [4] = "Castle Raid",
                [5] = "nome", -- x2
                [6] = "Boat Castle",
                [7] = "Map",
                [8] = "Factory",
                [9] = "Summoner",
            },
        },
        [246] = {
            parent = 79,
            strings = {
                [0] = "task",
                [1] = "spawn",
            },
            proto_references = {
                [0] = { proto = 351 },
            },
        },
        [247] = {
            parent = 79,
            strings = {
                [0] = "full_moon",
                [1] = "mirage",
                [2] = "fruit",
                [3] = "boss",
                [4] = "event",
                [5] = "triple_swords",
                [6] = "haki_legend",
            },
            proto_references = {
                [0] = { proto = 352 },
            },
        },
        [248] = {
            parent = 79,
            strings = {
                [0] = "A venda por $2.000.000 no vendedor de espadas",
                [1] = "detalhe", -- x2
                [2] = "Legendary Sword Dealer", -- x2
                [3] = "nome", -- x2
                [4] = "pcall",
                [5] = "FindFirstChild", -- x2
                [6] = "Legendary Sword Dealer ",
                [7] = "table",
                [8] = "concat",
                [9] = ", ",
                [10] = "Vendedor no servidor. Na tela: ",
                [11] = "Vendedor no servidor (nao consegui ler qual espada)",
            },
            booleans = {
                [0] = true, -- x2
            },
            proto_references = {
                [0] = { proto = 353 },
            },
        },
        [249] = {
            parent = 79,
            strings = {
                [0] = "FindFirstChild",
                [1] = "Barista Cousin",
                [2] = "pcall",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 354 },
            },
        },
        [250] = {
            parent = 79,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 355 },
            },
        },
        [251] = {
            parent = 79,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 356 },
            },
        },
        [252] = {
            parent = 79,
            strings = {
                [0] = "_G", -- x2
                [1] = "__TSUO_NOTIFICADORES_ON", -- x2
                [2] = "task",
                [3] = "spawn",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false,
            },
            proto_references = {
                [0] = { proto = 357 },
            },
        },
        [253] = {
            parent = 79,
            strings = {
                [0] = "_G",
                [1] = "__TSUO_NOTIFICADORES_ON",
            },
            booleans = {
                [0] = false,
            },
        },
        [254] = {
            parent = 80,
            strings = {
                [0] = "PuloVal", -- x2
                [1] = "JumpPower", -- x2
                [2] = "UseJumpPower",
                [3] = "math",
                [4] = "abs",
            },
            booleans = {
                [0] = true,
            },
        },
        [255] = {
            parent = 80,
            strings = {
                [0] = "VelocidadeVal",
                [1] = "WalkSpeed",
            },
        },
        [256] = {
            parent = 80,
            strings = {
                [0] = "Value", -- x2
                [1] = "MaxValue",
                [2] = "type",
                [3] = "number",
            },
        },
        [257] = {
            parent = 81,
            strings = {
                [0] = "Position", -- x4
                [1] = "Magnitude",
                [2] = "math", -- x2
                [3] = "max", -- x2
                [4] = "DashDistancia",
                [5] = "Raycast",
                [6] = "DashVal",
                [7] = "pcall",
            },
            proto_references = {
                [0] = { proto = 358 },
            },
        },
        [258] = {
            parent = 85,
            strings = {
                [0] = "info",
                [1] = "Bypass",
            },
        },
        [259] = {
            parent = 91,
            strings = {
                [0] = "Destroy",
            },
        },
        [260] = {
            parent = 92,
            strings = {
                [0] = "Position", -- x2
                [1] = "GetPivot",
                [2] = "IsA",
                [3] = "BasePart",
            },
        },
        [261] = {
            parent = 97,
            strings = {
                [0] = "Instance",
                [1] = "new",
                [2] = "ImageLabel",
                [3] = "BackgroundTransparency",
                [4] = "Visible",
                [5] = "Parent",
            },
            booleans = {
                [0] = false,
            },
        },
        [262] = {
            parent = 99,
            strings = {
                [0] = "chams",
                [1] = "Destroy",
            },
        },
        [263] = {
            parent = 99,
            strings = {
                [0] = "Destroy",
            },
        },
        [264] = {
            parent = 107,
            strings = {
                [0] = "FireServer",
            },
        },
        [265] = {
            parent = 107,
            strings = {
                [0] = "FireServer",
            },
        },
        [266] = {
            parent = 108,
            strings = {
                [0] = "require",
            },
        },
        [267] = {
            parent = 113,
            strings = {
                [0] = "Data",
                [1] = "Level",
                [2] = "Value",
            },
        },
        [268] = {
            parent = 116,
            strings = {
                [0] = "CanCollide",
            },
        },
        [269] = {
            parent = 117,
            strings = {
                [0] = "SetAttribute",
                [1] = "AAIM",
            },
            booleans = {
                [0] = true,
            },
        },
        [270] = {
            parent = 117,
            strings = {
                [0] = "SetAttribute",
                [1] = "AAIM",
            },
        },
        [271] = {
            parent = 121,
            strings = {
                [0] = "getTargetInfo",
            },
        },
        [272] = {
            parent = 124,
            booleans = {
                [0] = true,
            },
        },
        [273] = {
            parent = 129,
            strings = {
                [0] = "Value", -- x2
                [1] = "Magnitude",
            },
        },
        [274] = {
            parent = 129,
            strings = {
                [0] = "Disconnect",
            },
        },
        [275] = {
            parent = 132,
            strings = {
                [0] = "tick", -- x2
                [1] = "Team", -- x4
                [2] = " now.",
                [3] = "Name", -- x2
                [4] = "Faction", -- x3
                [5] = "tostring", -- x2
                [6] = " -- the game did not accept the switch.",
                [7] = "Still ",
                [8] = "You are ",
                [9] = "success",
                [10] = "pcall",
                [11] = "The game refused the call.",
                [12] = "error",
                [13] = "warning",
            },
            proto_references = {
                [0] = { proto = 359 },
            },
        },
        [276] = {
            parent = 133,
            strings = {
                [0] = "pcall", -- x2
                [1] = "Master",
                [2] = "Spin",
                [3] = "math", -- x2
                [4] = "pi",
                [5] = "rad",
                [6] = "SpinVelocidade",
            },
            proto_references = {
                [0] = { proto = 360 },
                [1] = { proto = 361 },
            },
        },
        [277] = {
            parent = 134,
        },
        [278] = {
            parent = 135,
            strings = {
                [0] = "gethui",
                [1] = "Parent",
            },
        },
        [279] = {
            parent = 135,
            strings = {
                [0] = "Sua key nao esta registrada ainda. Abra tsuoblox.com/account, faca login, registre esta key em 'Minhas Keys' e tente de novo.",
                [1] = "Your key isn't registered yet. Open tsuoblox.com/account, sign in, register this key under 'My Keys', then try again.",
                [2] = "message",
                [3] = "", -- x3
                [4] = "Enter your key first.",
                [5] = "pcall", -- x2
                [6] = "JSONDecode",
                [7] = "hwid",
                [8] = "legacyHwid",
                [9] = "Erro de conexao. Cheque a internet e tente de novo.",
                [10] = "Network error. Check your connection and try again.",
                [11] = "code",
                [12] = "gsub",
                [13] = "%s+",
                [14] = "upper",
                [15] = "tostring",
                [16] = "Verificando...",
                [17] = "Verifying...",
                [18] = "/validate",
                [19] = "key",
                [20] = "Key valida! Abrindo o hub...",
                [21] = "Key valid! Opening the hub...",
                [22] = "success",
                [23] = "scriptSlug",
                [24] = "Digite sua key primeiro.",
                [25] = "Key invalida.",
                [26] = "Invalid key.",
                [27] = "not_registered",
            },
            booleans = {
                [0] = true, -- x3
                [1] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 362 },
            },
        },
        [280] = {
            parent = 135,
            strings = {
                [0] = "...",
                [1] = "gsub",
                [2] = "^.-:%d+:%s*",
                [3] = "",
                [4] = "tostring", -- x2
                [5] = "sub",
                [6] = "pcall",
                [7] = "warn",
                [8] = "[TSUO KEY] erro na validacao: ",
                [9] = "Validation error: ",
            },
            booleans = {
                [0] = false,
            },
        },
        [281] = {
            parent = 135,
        },
        [282] = {
            parent = 135,
            strings = {
                [0] = "tostring",
                [1] = "UserId",
                [2] = "type", -- x2
                [3] = "string",
                [4] = "pcall",
                [5] = "gethwid", -- x2
                [6] = "function",
            },
        },
        [283] = {
            parent = 135,
            strings = {
                [0] = "Instance",
                [1] = "new",
                [2] = "pairs",
            },
        },
        [284] = {
            parent = 135,
            strings = {
                [0] = "pt", -- x2
                [1] = "RobloxLocaleId",
                [2] = "sub",
                [3] = "tostring",
                [4] = "game",
                [5] = "GetService",
                [6] = "LocalizationService",
            },
        },
        [285] = {
            parent = 135,
            strings = {
                [0] = "UICorner",
                [1] = "UDim",
                [2] = "new",
                [3] = "CornerRadius",
                [4] = "Parent",
            },
        },
        [286] = {
            parent = 135,
            strings = {
                [0] = "UIStroke",
                [1] = "Color",
                [2] = "Thickness",
                [3] = "Transparency",
                [4] = "Parent",
            },
        },
        [287] = {
            parent = 135,
            strings = {
                [0] = "ColorSequence",
                [1] = "new",
                [2] = "Color",
                [3] = "UIGradient",
                [4] = "Rotation",
                [5] = "Parent",
            },
        },
        [288] = {
            parent = 135,
            strings = {
                [0] = "Parent",
                [1] = "BackgroundColor3",
                [2] = "AutoButtonColor",
                [3] = "BorderSizePixel",
                [4] = "Enum",
                [5] = "Font", -- x2
                [6] = "GothamMedium",
                [7] = "Text",
                [8] = "TextSize",
                [9] = "TextColor3",
                [10] = "MouseEnter",
                [11] = "Connect", -- x2
                [12] = "Position",
                [13] = "TextButton",
                [14] = "Vector2",
                [15] = "new",
                [16] = "AnchorPoint",
                [17] = "MouseLeave",
                [18] = "Size",
            },
            booleans = {
                [0] = false,
            },
            proto_references = {
                [0] = { proto = 363 },
                [1] = { proto = 364 },
            },
        },
        [289] = {
            parent = 135,
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [290] = {
            parent = 135,
            strings = {
                [0] = "task",
                [1] = "spawn",
                [2] = "Text",
            },
        },
        [291] = {
            parent = 135,
            strings = {
                [0] = "task",
                [1] = "spawn",
                [2] = "Text",
            },
        },
        [292] = {
            parent = 135,
            strings = {
                [0] = "Parent",
                [1] = "game",
                [2] = "GetService",
                [3] = "CoreGui",
            },
        },
        [293] = {
            parent = 135,
            strings = {
                [0] = "pcall",
                [1] = "math",
                [2] = "clamp",
                [3] = "tonumber",
            },
            proto_references = {
                [0] = { proto = 365 },
            },
        },
        [294] = {
            parent = 135,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 366 },
            },
        },
        [295] = {
            parent = 135,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 367 },
            },
        },
        [296] = {
            parent = 135,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 368 },
            },
        },
        [297] = {
            parent = 135,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 369 },
            },
        },
        [298] = {
            parent = 135,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 370 },
            },
        },
        [299] = {
            parent = 135,
            strings = {
                [0] = "readfile", -- x2
                [1] = "type", -- x3
                [2] = "string",
                [3] = "gsub",
                [4] = "%s+",
                [5] = "",
                [6] = "Text",
                [7] = "isfile", -- x2
                [8] = "function", -- x2
            },
        },
        [300] = {
            parent = 135,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 371 },
            },
        },
        [301] = {
            parent = 135,
            strings = {
                [0] = "Discord link copied! Open it in your browser: ",
                [1] = "Link do Discord copiado! Abra no navegador: ",
                [2] = "pcall",
            },
            proto_references = {
                [0] = { proto = 372 },
            },
        },
        [302] = {
            parent = 135,
            strings = {
                [0] = "Url",
                [1] = "POST",
                [2] = "Method",
                [3] = "pcall",
                [4] = "application/json",
                [5] = "Content-Type",
                [6] = "Headers",
                [7] = "Body",
            },
            proto_references = {
                [0] = { proto = 373 },
            },
        },
        [303] = {
            parent = 135,
            strings = {
                [0] = "&legacyHwid=",
                [1] = "/check?hwid=",
                [2] = "valid",
                [3] = "&scriptSlug=",
                [4] = "pcall",
                [5] = "JSONDecode",
            },
            booleans = {
                [0] = true,
                [1] = false, -- x2
            },
        },
        [304] = {
            parent = 135,
            strings = {
                [0] = "task",
                [1] = "spawn",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 374 },
            },
        },
        [305] = {
            parent = 135,
            strings = {
                [0] = "Text",
            },
        },
        [306] = {
            parent = 135,
            strings = {
                [0] = "pcall", -- x4
                [1] = "http_request", -- x2
                [2] = "http", -- x3
                [3] = "request", -- x6
                [4] = "syn", -- x3
                [5] = "Body",
            },
        },
        [307] = {
            parent = 135,
            strings = {
                [0] = "Url",
                [1] = "GET",
                [2] = "Method",
            },
            proto_references = {
                [0] = { proto = 375 },
            },
        },
        [308] = {
            parent = 135,
            strings = {
                [0] = "WaitForChild",
                [1] = "PlayerGui",
                [2] = "Parent",
            },
        },
        [309] = {
            parent = 135,
            booleans = {
                [0] = true,
            },
        },
        [310] = {
            parent = 136,
            strings = {
                [0] = "WalkSpeed",
                [1] = "JumpPower",
            },
        },
        [311] = {
            parent = 136,
            strings = {
                [0] = "Destroy",
            },
        },
        [312] = {
            parent = 136,
            strings = {
                [0] = "Destroy",
            },
        },
        [313] = {
            parent = 136,
            strings = {
                [0] = "Destroy",
            },
        },
        [314] = {
            parent = 136,
            strings = {
                [0] = "type", -- x2
                [1] = "table",
                [2] = "Destroy", -- x3
                [3] = "Disconnect",
                [4] = "Instance",
                [5] = "function",
                [6] = "typeof", -- x2
                [7] = "RBXScriptConnection",
            },
        },
        [315] = {
            parent = 136,
        },
        [316] = {
            parent = 137,
            strings = {
                [0] = "Cancel",
            },
        },
        [317] = {
            parent = 138,
            strings = {
                [0] = "AutoRotate",
            },
            booleans = {
                [0] = true,
            },
        },
        [318] = {
            parent = 138,
            strings = {
                [0] = "Disconnect",
            },
        },
        [319] = {
            parent = 140,
            strings = {
                [0] = "require",
                [1] = "Modules",
                [2] = "CombatUtil",
                [3] = "GetWeaponData",
                [4] = "GetWeaponName",
            },
        },
        [320] = {
            parent = 153,
            strings = {
                [0] = "_G", -- x2
                [1] = "__TSUO_FrutasNoMapa", -- x2
            },
        },
        [321] = {
            parent = 156,
            strings = {
                [0] = "GetPivot",
            },
        },
        [322] = {
            parent = 157,
            strings = {
                [0] = "Title",
                [1] = "Content",
                [2] = "Notify",
                [3] = "info",
                [4] = "Kind",
                [5] = "Duration",
            },
        },
        [323] = {
            parent = 162,
            strings = {
                [0] = "JumpPower",
            },
        },
        [324] = {
            parent = 165,
            strings = {
                [0] = "Character", -- x2
                [1] = "FindFirstChild",
                [2] = "HumanoidRootPart",
                [3] = "Position", -- x2
                [4] = "Magnitude",
            },
        },
        [325] = {
            parent = 168,
            strings = {
                [0] = "getgenv",
                [1] = "TweenMonitor",
            },
            booleans = {
                [0] = false,
            },
        },
        [326] = {
            parent = 170,
            strings = {
                [0] = "Destroy",
            },
        },
        [327] = {
            parent = 172,
            strings = {
                [0] = "Value",
            },
        },
        [328] = {
            parent = 175,
            strings = {
                [0] = "GetActiveProfile",
                [1] = "type", -- x2
                [2] = "delfile", -- x2
                [3] = "function", -- x2
                [4] = "isfile", -- x2
                [5] = "ipairs",
                [6] = "tsuo_pvpking_meta.json",
                [7] = ".json",
                [8] = "tsuo_pvpking_",
                [9] = "Padrao",
            },
        },
        [329] = {
            parent = 177,
            strings = {
                [0] = "ChangeState",
                [1] = "Enum",
                [2] = "HumanoidStateType",
                [3] = "Dead",
            },
        },
        [330] = {
            parent = 177,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 376 },
            },
        },
        [331] = {
            parent = 177,
            strings = {
                [0] = "Health",
            },
        },
        [332] = {
            parent = 179,
            strings = {
                [0] = "JSONDecode",
                [1] = "readfile",
                [2] = "tsuo_pvpking_meta.json",
                [3] = "type",
                [4] = "active", -- x2
                [5] = "string",
            },
        },
        [333] = {
            parent = 179,
            strings = {
                [0] = "JSONDecode",
                [1] = "readfile",
            },
        },
        [334] = {
            parent = 179,
            strings = {
                [0] = "Options",
                [1] = "pairs",
                [2] = "pcall", -- x5
                [3] = "Get", -- x3
                [4] = "Set", -- x4
                [5] = "SetConfig",
                [6] = "type", -- x2
                [7] = "boolean",
                [8] = "number",
            },
            booleans = {
                [0] = true, -- x3
                [1] = false,
            },
        },
        [335] = {
            parent = 182,
            strings = {
                [0] = "ilha",
                [1] = "Saving spawn point here...",
                [2] = "info", -- x2
                [3] = "pcall",
                [4] = "string", -- x3
                [5] = "format", -- x3
                [6] = "Respawned at %s (%.0f studs).",
                [7] = "Respawn did not come back in time.",
                [8] = "error", -- x2
                [9] = "Dying to respawn past the barrier...",
                [10] = "warning", -- x3
                [11] = "success",
                [12] = "Position", -- x2
                [13] = "Magnitude", -- x2
                [14] = "...",
                [15] = "matar",
                [16] = "esperarRenascer",
                [17] = "The game refused to save the spawn point.",
                [18] = "Could not get close enough (%.0f studs away).",
                [19] = "Traveling to ",
                [20] = "_G",
                [21] = "__TSUO_IrAte",
                [22] = "Respawned %.0f studs from %s -- the spawn did not stick.",
            },
            proto_references = {
                [0] = { proto = 377 },
                [1] = { proto = 378 },
                [2] = { proto = 379 },
            },
        },
        [336] = {
            parent = 184,
            strings = {
                [0] = "RF/SubmarineWorkerSpeak", -- x2
                [1] = "InvokeServer", -- x2
                [2] = "TravelToSubmergedIsland",
                [3] = "AskKilledTikiBoss",
            },
        },
        [337] = {
            parent = 184,
            strings = {
                [0] = "FindFirstChild",
                [1] = "BodyClip",
                [2] = "Destroy",
            },
        },
        [338] = {
            parent = 188,
            strings = {
                [0] = "ChangeState",
                [1] = "Enum",
                [2] = "HumanoidStateType",
                [3] = "Jumping",
            },
        },
        [339] = {
            parent = 189,
            strings = {
                [0] = "SendKeyEvent", -- x2
                [1] = "Enum", -- x2
                [2] = "KeyCode", -- x2
                [3] = "E", -- x2
                [4] = "game", -- x2
            },
            booleans = {
                [0] = true,
                [1] = false, -- x3
            },
        },
        [340] = {
            parent = 189,
            strings = {
                [0] = "KeyCode", -- x2
                [1] = "Y", -- x2
                [2] = "SendKeyEvent", -- x2
                [3] = "Enum", -- x2
                [4] = "game", -- x2
            },
            booleans = {
                [0] = false, -- x3
                [1] = true,
            },
        },
        [341] = {
            parent = 189,
            strings = {
                [0] = "FireServer",
                [1] = "ActivateAbility",
            },
        },
        [342] = {
            parent = 189,
            strings = {
                [0] = "Buso",
            },
        },
        [343] = {
            parent = 193,
            strings = {
                [0] = "SetAccent",
            },
        },
        [344] = {
            parent = 199,
            strings = {
                [0] = "Health",
                [1] = "pcall",
                [2] = "Character",
                [3] = "Parent",
            },
            proto_references = {
                [0] = { proto = 380 },
            },
        },
        [345] = {
            parent = 210,
            strings = {
                [0] = "WalkSpeed",
            },
        },
        [346] = {
            parent = 220,
            strings = {
                [0] = "InvokeServer",
                [1] = "GetAvailableLocations",
            },
        },
        [347] = {
            parent = 233,
            strings = {
                [0] = "Set", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [348] = {
            parent = 233,
            booleans = {
                [0] = true,
            },
        },
        [349] = {
            parent = 236,
            strings = {
                [0] = "Set", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [350] = {
            parent = 240,
            strings = {
                [0] = "tostring",
                [1] = "LocalPlayer",
                [2] = "UserId",
            },
        },
        [351] = {
            parent = 246,
            strings = {
                [0] = "hwid",
                [1] = "x-tsuo-hwid",
                [2] = "uid",
                [3] = "x-tsuo-uid",
                [4] = "pcall",
                [5] = "API",
                [6] = "jobId",
                [7] = "game", -- x2
                [8] = "PlaceId",
                [9] = "placeId",
                [10] = "tostring",
                [11] = "_G",
                [12] = "__TSUO_HUB",
                [13] = "players",
                [14] = "MaxPlayers",
                [15] = "maxPlayers",
                [16] = "",
                [17] = "x-tsuo-hub",
                [18] = "Headers",
                [19] = "JSONEncode",
                [20] = "GetPlayers",
                [21] = "events",
                [22] = "Url",
                [23] = "POST",
                [24] = "Method",
                [25] = "application/json",
                [26] = "Content-Type",
                [27] = "Body",
                [28] = "JobId",
            },
        },
        [352] = {
            parent = 247,
            strings = {
                [0] = "tostring",
                [1] = "nome", -- x2
                [2] = "/",
                [3] = "tick",
                [4] = "mirage",
                [5] = "type",
                [6] = "name",
                [7] = "valor",
                [8] = "value",
                [9] = "detalhe",
                [10] = "detail",
                [11] = "ipairs",
                [12] = "CARENCIA_MIRAGE",
                [13] = "CARENCIA",
            },
        },
        [353] = {
            parent = 248,
            strings = {
                [0] = "Text", -- x3
                [1] = "IsA",
                [2] = "TextLabel",
                [3] = "lower", -- x3
                [4] = "find",
                [5] = "ipairs", -- x2
                [6] = "GetDescendants",
                [7] = "gsub", -- x2
                [8] = "^%s+",
                [9] = "", -- x2
                [10] = "%s+$",
            },
            booleans = {
                [0] = true,
            },
        },
        [354] = {
            parent = 249,
            strings = {
                [0] = "FindFirstChild", -- x2
                [1] = "CommF_",
                [2] = "lower",
                [3] = "pcall",
                [4] = "game",
                [5] = "GetService",
                [6] = "ReplicatedStorage",
                [7] = "Remotes",
                [8] = "tonumber",
                [9] = "type",
                [10] = "string",
                [11] = "nome",
                [12] = "Cor lendaria no Barista Cousin. Ele fica 20 min e sai.",
                [13] = "detalhe",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 381 },
            },
        },
        [355] = {
            parent = 250,
            strings = {
                [0] = "FindFirstChild", -- x7
                [1] = "MysticIsland",
                [2] = "Locations",
                [3] = "Mystic Island",
                [4] = "WorldOrigin",
                [5] = "Mirage Island", -- x2
                [6] = "nome",
                [7] = "A ilha esta no mapa agora",
                [8] = "detalhe",
                [9] = "_WorldOrigin",
                [10] = "Map",
            },
        },
        [356] = {
            parent = 251,
            strings = {
                [0] = "Full Moon",
                [1] = "nome",
                [2] = "Lua cheia neste servidor agora",
                [3] = "detalhe",
                [4] = "FindFirstChildOfClass",
                [5] = "Sky",
                [6] = "match", -- x2
                [7] = "id=(%d+)",
                [8] = "game",
                [9] = "GetService",
                [10] = "Lighting",
                [11] = "FindFirstChild",
                [12] = "9709149431",
                [13] = "",
                [14] = "(%d+)$",
                [15] = "tostring",
                [16] = "MoonTextureId",
                [17] = "FantasySky",
            },
        },
        [357] = {
            parent = 252,
            strings = {
                [0] = "_G",
                [1] = "__TSUO_NOTIFICADORES_ON",
                [2] = "pcall",
                [3] = "VARRER",
            },
        },
        [358] = {
            parent = 257,
            strings = {
                [0] = "EasingStyle",
                [1] = "Linear",
                [2] = "CFrame",
                [3] = "Play",
                [4] = "Cancel",
                [5] = "Create",
                [6] = "TweenInfo",
                [7] = "new",
                [8] = "Enum",
            },
        },
        [359] = {
            parent = 275,
            strings = {
                [0] = "InvokeServer",
                [1] = "SetTeam2",
            },
        },
        [360] = {
            parent = 276,
            strings = {
                [0] = "AutoRotate",
            },
            booleans = {
                [0] = false,
            },
        },
        [361] = {
            parent = 276,
            strings = {
                [0] = "CFrame", -- x2
                [1] = "Position",
                [2] = "Angles",
            },
        },
        [362] = {
            parent = 279,
            strings = {
                [0] = "type",
                [1] = "writefile", -- x2
                [2] = "function",
            },
        },
        [363] = {
            parent = 288,
            strings = {
                [0] = "BackgroundColor3",
                [1] = "Transparency",
            },
        },
        [364] = {
            parent = 288,
            strings = {
                [0] = "BackgroundColor3",
                [1] = "Transparency",
            },
        },
        [365] = {
            parent = 293,
            strings = {
                [0] = "Enum", -- x2
                [1] = "EasingDirection",
                [2] = "Out",
                [3] = "EasingStyle",
                [4] = "Quad",
                [5] = "TweenSize",
            },
            booleans = {
                [0] = true,
            },
        },
        [366] = {
            parent = 294,
            strings = {
                [0] = "TextColor3",
                [1] = "tostring",
                [2] = "",
                [3] = "Text",
            },
        },
        [367] = {
            parent = 295,
            strings = {
                [0] = "",
                [1] = "TextColor3",
                [2] = "tostring",
                [3] = "Text",
            },
        },
        [368] = {
            parent = 296,
            strings = {
                [0] = "Visible", -- x2
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
        },
        [369] = {
            parent = 297,
            strings = {
                [0] = "Visible", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [370] = {
            parent = 298,
            strings = {
                [0] = "Destroy",
            },
        },
        [371] = {
            parent = 300,
            strings = {
                [0] = "tostring",
                [1] = "Text",
                [2] = "",
            },
        },
        [372] = {
            parent = 301,
            strings = {
                [0] = "type",
                [1] = "setclipboard", -- x2
                [2] = "function",
            },
        },
        [373] = {
            parent = 302,
            strings = {
                [0] = "JSONEncode",
            },
        },
        [374] = {
            parent = 304,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 382 },
            },
        },
        [375] = {
            parent = 307,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 383 },
            },
        },
        [376] = {
            parent = 330,
            strings = {
                [0] = "BreakJoints",
            },
        },
        [377] = {
            parent = 335,
            strings = {
                [0] = "SetSpawnPoint",
            },
        },
        [378] = {
            parent = 335,
        },
        [379] = {
            parent = 335,
        },
        [380] = {
            parent = 344,
            strings = {
                [0] = "BreakJoints",
            },
        },
        [381] = {
            parent = 354,
            strings = {
                [0] = "1",
                [1] = "InvokeServer",
                [2] = "ColorsDealer",
            },
        },
        [382] = {
            parent = 374,
            strings = {
                [0] = "device",
                [1] = "tostring", -- x2
                [2] = "game", -- x3
                [3] = "PlaceId",
                [4] = "script",
                [5] = "key",
                [6] = "GetService",
                [7] = "UserInputService",
                [8] = "executor",
                [9] = "TouchEnabled",
                [10] = "KeyboardEnabled",
                [11] = "PC",
                [12] = "Mobile",
                [13] = "en-us",
                [14] = "pcall", -- x3
                [15] = "/execution",
                [16] = "hwid",
                [17] = "legacyHwid",
                [18] = "jobId",
                [19] = "gameName",
                [20] = "MembershipType", -- x2
                [21] = "Enum",
                [22] = "Premium",
                [23] = "premium",
                [24] = "locale",
                [25] = "Name",
                [26] = "username",
                [27] = "UserId",
                [28] = "userId",
                [29] = "scriptSlug",
                [30] = "placeId",
                [31] = "JobId",
                [32] = "Unknown",
            },
            proto_references = {
                [0] = { proto = 384 },
                [1] = { proto = 385 },
                [2] = { proto = 386 },
            },
        },
        [383] = {
            parent = 375,
            strings = {
                [0] = "game",
                [1] = "HttpGet",
            },
            booleans = {
                [0] = true,
            },
        },
        [384] = {
            parent = 382,
            strings = {
                [0] = "RobloxLocaleId",
                [1] = "game",
                [2] = "GetService",
                [3] = "LocalizationService",
            },
        },
        [385] = {
            parent = 382,
            strings = {
                [0] = "Name",
                [1] = "game", -- x2
                [2] = "GetService",
                [3] = "MarketplaceService",
                [4] = "GetProductInfo",
                [5] = "PlaceId",
            },
        },
        [386] = {
            parent = 382,
            strings = {
                [0] = "type",
                [1] = "identifyexecutor", -- x2
                [2] = "function",
                [3] = "tostring",
            },
        },
    },
}
