-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value1 = game:GetService("Players")
}
local game_ = game

t1.value2 = game_.GetService(game_, "RunService")
t1.value3 = game:GetService("UserInputService")
t1.value4 = game:GetService("CollectionService")
t1.value5 = game:GetService("HttpService")
t1.value6 = game:GetService("TeleportService")
t1.value7 = t1.value1.LocalPlayer
game_ = t1.value7:WaitForChild("PlayerGui")

local color, cFrame, color3 = ipairs({
	"MacielHubStop",
	"MacielAutoStoneStop",
	"MacielShieldDetectorStop",
	"MacielPlayerESPCleanup",
	"MacielAimbotStop",
	"OmegaArtifactESPStop",
	"MacielRecoveryStop",
	"MacielFlyCleanup",
	"MacielAntiRagdollCleanup"
})
local color32 = nil

while true do
	color3, v426 = color(cFrame, color3)

	if not color3 then
		break
	end

	v16 = _G[v426]

	if type(v16) == "function" then
		pcall(_G[v426])
	end
end

for _, v in ipairs({
	"MacielHubV10",
	"MacielHubV11",
	"MacielHubV12",
	"MacielHubV13",
	"MacielHubBETA10",
	"MacielShieldDetector",
	"MacielPlayerESP",
	"MacielAntiRagdollV3"
}) do
	v = game_:FindFirstChild(v)

	if v then
		v:Destroy()
	end
end

t1.value8 = true
t1.value9 = nil
t1.value9 = {}
t1.value10 = {}
t1.value11 = {}

function t1.value12(p1, p2, p3)
	local connection = p1:Connect(p2)

	table.insert(p3 or t1.value9, connection)

	return connection
end
function t1.value13(p4)
	for _, v in ipairs(p4) do
		pcall(function()
			v:Disconnect()
		end)
	end

	table.clear(p4)
end

t1.value14 = {
	ESP = false,
	Power = true,
	Space = true,
	Time = true,
	Darkhold = true,
	Highlight = true,
	Labels = true,
	Distance = true,
	Aimbot = false,
	TeamCheck = false,
	IgnoreFriends = true,
	AntiRagdoll = false,
	AntiAbilityLock = false,
	Noclip = false,
	WalkSpeed = false,
	Jump = false,
	FlySpeed = false,
	AutoFarm = false,
	ShieldDetector = false,
	PlayerESP = false,
	AutoStone = false
}
t1.value15 = {
	FOV = 260,
	Strength = 0.38,
	Prediction = 0,
	Freedom = 0.35,
	MaxDistance = 180,
	DistanceWeight = 0.65,
	VerticalOffset = 0,
	CenterX = 0,
	CenterY = 0
}
t1.value16 = {
	Speed = 32,
	Jump = 80,
	Fly = 100
}
t1.value17 = {
	Transparency = 0.35,
	AutoLoad = false
}
_G.SkyHubLang = "pt"
_G.SkyHubLangSaved = false

local readfile_ = readfile

if type(readfile_) == "function" then
	pcall(function()
		local data = t1.value5:JSONDecode(unpack_({ readfile("SkyHub_V1_Language.json") }))

		if not (data.Language == "pt" and true or data.Language == "en") then
			return
		end

		_G.SkyHubLang = data.Language
		_G.SkyHubLangSaved = true
	end)
end

_G.SkyHubWords = {
	Inicio = "Home",
	Combate = "Combat",
	Movimento = "Movement",
	Jogador = "Player",
	Teleporte = "Teleport",
	Servidores = "Servers",
	["Config."] = "Settings",
	Creditos = "Credits",
	Farms = "Farms",
	Info = "Guide",
	FILTROS = "FILTERS",
	VISUALIZACAO = "DISPLAY",
	["PERSONALIZACAO DO ESP"] = "ESP CUSTOMIZATION",
	["PLAYER ESP - PERSONALIZACAO AVANCADA"] = "PLAYER ESP - ADVANCED CUSTOMIZATION",
	ALCANCE = "RANGE",
	["SELECIONAR JOGADORES"] = "SELECT PLAYERS",
	["AJUSTES DO AIMBOT"] = "AIMBOT SETTINGS",
	PROTECOES = "PROTECTIONS",
	MOVIMENTO = "MOVEMENT",
	["AUTO FARM DE BAUS"] = "AUTO CHEST FARM",
	["CONTROLE DO MODULO"] = "MODULE CONTROLS",
	TELEPORTES = "TELEPORTS",
	["SPAWN POINTS"] = "SPAWN POINTS",
	SERVIDORES = "SERVERS",
	JOGADOR = "PLAYER",
	["RECUPERACAO DE VIDA"] = "HEALTH RECOVERY",
	["GUIA DO SKYHUB"] = "SKYHUB GUIDE",
	["ESP E DETECCAO"] = "ESP AND DETECTION",
	COMBATE = "COMBAT",
	["TELEPORTE E JOIAS"] = "TELEPORT AND STONES",
	CONFIGURACOES = "SETTINGS",
	IMPORTANTE = "IMPORTANT",
	["BEM-VINDO"] = "WELCOME",
	["REGISTRO DE ATUALIZACOES"] = "UPDATE LOG",
	SALVAMENTO = "SAVING",
	CREDITOS = "CREDITS",
	["IDIOMA / LANGUAGE"] = "LANGUAGE",
	["SALVAR CONFIGURACOES"] = "SAVE SETTINGS",
	["CARREGAR CONFIGURACOES"] = "LOAD SETTINGS",
	["Ativar Artifact ESP"] = "Enable Artifact ESP",
	["Mostrar nomes"] = "Show names",
	["Mostrar distancia"] = "Show distance",
	["Contorno do personagem"] = "Player outline",
	["Caixa 2D"] = "2D box",
	["Mostrar nome do jogador"] = "Show player name",
	["Mostrar distancia em studs"] = "Show distance in studs",
	["Mostrar atraves de paredes"] = "Show through walls",
	["Ativar Shield Detector"] = "Enable Shield Detector",
	["Ativar Player ESP"] = "Enable Player ESP",
	["Ativar Aimbot"] = "Enable Aimbot",
	["Ignorar mesmo time"] = "Ignore teammates",
	["Ignorar amigos"] = "Ignore friends",
	["Ativar Fly Speed"] = "Enable Fly Speed",
	["Abrir Auto Farm"] = "Open Auto Farm",
	["Ativar Auto Stone Pickup"] = "Enable Auto Stone Pickup",
	["Carregar automaticamente"] = "Auto-load settings",
	["Atualizar Artifact ESP"] = "Refresh Artifact ESP",
	["ATUALIZAR JOGADORES"] = "REFRESH PLAYERS",
	["ABRIR / FECHAR LISTA DE JOGADORES"] = "OPEN / CLOSE PLAYER LIST",
	["ABRIR MENU DO FARM"] = "OPEN FARM MENU",
	["SPAWN ALEATORIO"] = "RANDOM SPAWN",
	["REJOIN GAME"] = "REJOIN GAME",
	["SERVER HOP"] = "SERVER HOP",
	["ENTRAR NO MENOR SERVIDOR"] = "JOIN SMALLEST SERVER",
	["Resetar personagem"] = "Reset character",
	["RECUPERAR VIDA"] = "RECOVER HEALTH",
	["CANCELAR SEQUENCIA"] = "CANCEL SEQUENCE",
	["PORTUGUES / ENGLISH"] = "CHANGE LANGUAGE",
	["Centralizar menu"] = "Center menu",
	["Fechar menu"] = "Close menu",
	["COPIAR LINK DO DISCORD"] = "COPY DISCORD LINK",
	["ENTRAR NO DISCORD"] = "JOIN DISCORD",
	["Tamanho nome artefato"] = "Artifact label size",
	["Altura nome artefato"] = "Artifact label height",
	["Tamanho nome jogador"] = "Player label size",
	["Altura nome jogador"] = "Player label height",
	["Altura escudo isolado"] = "Shield label height",
	["Distancia maxima ESP"] = "Maximum ESP distance",
	["Transparencia preenchimento"] = "Fill transparency",
	["Transparencia contorno"] = "Outline transparency",
	["Contorno do texto"] = "Text outline",
	["Transparencia artefatos"] = "Artifact transparency",
	["Contorno artefatos"] = "Artifact outline",
	Forca = "Strength",
	["Ajuste vertical da mira"] = "Vertical aim offset",
	["Centralizar mira X (pixels)"] = "Center aim X (pixels)",
	["Centralizar mira Y (pixels)"] = "Center aim Y (pixels)",
	Liberdade = "Freedom",
	["Distancia maxima"] = "Maximum distance",
	["Prioridade proximidade"] = "Proximity priority",
	Velocidade = "Speed",
	["Forca do pulo"] = "Jump power",
	["Velocidade de voo"] = "Flight speed",
	Transparencia = "Transparency",
	["Ajustes aplicados em tempo real. Salve em Config. para manter."] = "Changes apply instantly. Save in Settings to keep them.",
	["Sem limite para personagens carregados."] = "No limit for loaded characters.",
	["Escudo 11x13 acima da cabeca"] = "11x13 shield above the head",
	["Oculto por paredes."] = "Hidden by walls.",
	["Ative para abrir a lista de jogadores."] = "Enable to open the player list.",
	["Cores, caixa 2D, distancia, nomes e transparencias ajustaveis."] = "Customize colors, 2D box, distance, names and transparency.",
	["Alvo: nenhum"] = "Target: none",
	["Anti-Ragdoll e recuperacao automatica."] = "Anti-Ragdoll and automatic recovery.",
	["Anti-Stun experimental."] = "Experimental anti-stun.",
	["Controle pela camera e joystick. Funciona enquanto estiver no ar."] = "Control with camera and joystick while airborne.",
	["Abre menu independente do SkyHub."] = "Opens a separate SkyHub menu.",
	["Use o menu do Farm para iniciar, parar e minimizar."] = "Use the Farm menu to start, stop or minimize.",
	["Server Hop e Rejoin estao na aba Servidores."] = "Server Hop and Rejoin are in the Servers tab.",
	["Escolha um destino"] = "Choose a destination",
	["Seleciona um SpawnLocation diferente do anterior, quando possivel."] = "Chooses a different spawn point when possible.",
	["Busca joias soltas estaveis, teleporta e tenta usar ProximityPrompt."] = "Finds stable loose stones, teleports and tries ProximityPrompt.",
	["Coleta automatica exige fireproximityprompt disponivel."] = "Auto pickup requires fireproximityprompt support.",
	["Menor servidor entre os servidores publicos consultados; nao garante o menor de todos."] = "Smallest among checked public servers; may not be the smallest overall.",
	["A listagem depende de HTTP acessivel e das permissoes de teleporte."] = "Server listing requires HTTP and teleport permissions.",
	["Esconderijo > Reset > Respawn > Voltar a joia > 5s > Spawn aleatorio."] = "Hideout > Reset > Respawn > Return to stone > 5s > Random spawn.",
	["A recuperacao depende do respawn permitido pelo servidor."] = "Recovery depends on server respawn permissions.",
	["Criado por adryanrz."] = "Created by adryanrz.",
	["Selecione uma aba na pagina esquerda. Toque nos interruptores para ativar ou desativar funcoes. Barras ajustam valores; Config. permite salvar preferencias."] = "Choose a tab on the left. Use switches to toggle features and sliders to adjust values. Save preferences in Settings.",
	["Artifact ESP: localiza os artefatos selecionados e permite mostrar nomes, distancia e destaque visual."] = "Artifact ESP locates selected artifacts and displays names, distance and highlights.",
	["Player ESP: identifica jogadores, com lista individual, caixa 2D, contorno, nomes e distancia. Personalize cores, alcance e transparencias."] = "Player ESP identifies players with individual list, 2D box, outlines, names and distance. Customize colors, range and transparency.",
	["Shield Detector: indica escudos detectados dentro do alcance configurado."] = "Shield Detector shows shields within the configured range.",
	["Aimbot: auxilia o acompanhamento de alvos pela camera. FOV controla a area de busca; Forca, Prediction e Liberdade ajustam o acompanhamento."] = "Aimbot tracks targets with the camera. FOV sets search area; Strength, Prediction and Freedom adjust tracking.",
	["Centralizar mira X/Y e Ajuste vertical corrigem o alinhamento. Distancia maxima limita os alvos; Ignorar amigos e mesmo time aplicam filtros."] = "Aim center X/Y and vertical offset adjust alignment. Maximum distance limits targets; ignore friends and teammates to filter.",
	["Anti-Ragdoll tenta evitar quedas; Anti-Ability Lock tenta remover restricoes de habilidade. Podem depender do jogo."] = "Anti-Ragdoll attempts to prevent falls; Anti-Ability Lock attempts to remove ability restrictions. Game dependent.",
	["Noclip desativa colisao local; WalkSpeed ajusta a velocidade; Jump ajusta o pulo; Fly Speed permite voo com camera e joystick."] = "Noclip disables local collision; WalkSpeed sets speed; Jump sets jump power; Fly Speed enables camera and joystick flight.",
	["Auto Farm de Baus abre um modulo independente. Use o menu desse modulo para iniciar, parar ou minimizar."] = "Auto Chest Farm opens a separate module. Use its menu to start, stop or minimize.",
	["Teleportes oferecem destinos disponiveis e spawn aleatorio. Auto Stone Pickup procura joias selecionadas e tenta interagir com elas."] = "Teleports offer available destinations and random spawn. Auto Stone Pickup finds selected stones and tries to interact.",
	["Rejoin reconecta ao jogo. Server Hop procura outro servidor. Menor servidor consulta servidores publicos disponiveis."] = "Rejoin reconnects to the game. Server Hop finds another server. Smallest Server checks available public servers.",
	["Resetar personagem reinicia o personagem. Recuperacao de vida executa uma sequencia de reset e retorno, se o servidor permitir."] = "Reset Character restarts the character. Health Recovery resets and returns if the server allows it.",
	["Ajuste transparencia, salve e carregue preferencias. Carregar automaticamente tenta restaurar a configuracao na proxima execucao."] = "Adjust transparency, save and load preferences. Auto-load restores settings next run.",
	["Algumas funcoes dependem de permissoes, recursos locais e regras do servidor. Alteracoes podem nao funcionar em todos os jogos."] = "Some features depend on permissions, local capabilities and server rules. They may not work in every game.",
	["Marvel Omega | PC e Mobile"] = "Marvel Omega | PC and Mobile",
	["Use as abas a esquerda para acessar as funcoes. Consulte Info para aprender a usar cada recurso."] = "Use the tabs on the left to access features. See Guide to learn each feature.",
	["V1 - Lancamento inicial."] = "V1 - Initial release.",
	["Nenhuma atualizacao adicional registrada."] = "No additional updates.",
	["Sistema pronto"] = "System ready",
	["AutoLoad restaura preferencias na proxima execucao."] = "Auto-load restores preferences next run.",
	["Projeto: SkyHub | Jogo: Marvel Omega"] = "Project: SkyHub | Game: Marvel Omega",
	["Cor do preenchimento"] = "Fill color",
	["Cor do contorno/caixa"] = "Outline/box color",
	["Cor dos nomes"] = "Name color",
	trocar = "change",
	Vermelho = "Red",
	Branco = "White",
	Verde = "Green",
	Azul = "Blue",
	Roxo = "Purple",
	Amarelo = "Yellow",
	Rosa = "Pink",
	Ciano = "Cyan",
	Preto = "Black",
	Laranja = "Orange",
	TODAS = "ALL",
	PODER = "POWER",
	ESPACO = "SPACE",
	TEMPO = "TIME",
	ATIVO = "ACTIVE",
	PAUSADO = "PAUSED",
	["Link copiado!"] = "Link copied!",
	["Nao foi possivel copiar."] = "Could not copy.",
	["Copia nao disponivel neste ambiente."] = "Clipboard not available.",
	["Link copiado. Abra no navegador."] = "Link copied. Open in your browser.",
	["Copie o link manualmente."] = "Copy the link manually.",
	["Nenhum arquivo valido"] = "No valid file",
	["Configuracoes salvas!"] = "Settings saved!",
	["Executor sem writefile"] = "Executor does not support writefile",
	["Carregando..."] = "Loading...",
	["Consultando..."] = "Checking...",
	["Teleportado! "] = "Teleported! ",
	["Falha: "] = "Failed: ",
	["Personagem indisponivel"] = "Character unavailable",
	["Detector desativado"] = "Detector disabled",
	["ESP DESLIGADO"] = "ESP DISABLED",
	["Alvo: "] = "Target: ",
	["PORTADORES: "] = "CARRIERS: ",
	["Escudos visiveis: "] = "Visible shields: ",
	["Selecao: "] = "Selection: ",
	["TP solicitado: "] = "TP requested: ",
	["Jogadores encontrados: "] = "Players found: ",
	["Abra o convite no navegador: "] = "Open the invite in your browser: ",
	["ATIVAR ESP TODOS"] = "ENABLE ESP FOR ALL",
	["DESATIVAR TODOS"] = "DISABLE ALL",
	["500 studs | Escudo 11x13 acima da cabeca | Oculto por paredes."] = "500 studs | 11x13 shield above the head | Hidden by walls.",
	["Discord ainda nao configurado."] = "Discord is not configured.",
	["TP | SPAWN ALEATORIO"] = "TP | RANDOM SPAWN",
	ATIVO = "ACTIVE",
	PAUSADO = "PAUSED"
}

function _G.SkyHubTranslate(p5)
	if _G.SkyHubLang ~= "en" and true or type(p5) ~= "string" then
		return p5
	elseif _G.SkyHubWords[p5] then
		return _G.SkyHubWords[p5]
	else
		for k, skyHubWord in pairs(_G.SkyHubWords) do
			local v17

			if #k >= 5 then
				v17 = p5:sub(1, #k) == k
			else
				v17 = false
			end

			if v17 then
				return skyHubWord .. p5:sub(#k + 1)
			end
		end

		return p5
	end
end

t1.value18 = {
	Selection = "TODAS"
}
t1.value19 = {
	ArtifactSize = 11,
	PlayerSize = 11,
	ArtifactHeight = 3,
	PlayerHeight = 2.7,
	ShieldHeight = 2.1,
	PlayerFill = 0.75,
	PlayerOutline = 0,
	PlayerDistance = 650,
	PlayerStroke = 0.2,
	PlayerBox = false,
	PlayerNames = true,
	PlayerDistanceLabel = true,
	PlayerHighlight = true,
	PlayerThroughWalls = true,
	PlayerColor = "Vermelho",
	PlayerOutlineColor = "Branco",
	PlayerTextColor = "Branco",
	ArtifactFill = 0.92,
	ArtifactOutline = 0.35
}
t1.value20 = {
	Vermelho = Color3.fromRGB(235, 27, 53),
	Branco = Color3.fromRGB(245, 245, 248),
	Verde = Color3.fromRGB(45, 235, 125),
	Azul = Color3.fromRGB(60, 150, 255),
	Roxo = Color3.fromRGB(170, 95, 255),
	Amarelo = Color3.fromRGB(255, 220, 60),
	Rosa = Color3.fromRGB(255, 90, 185),
	Ciano = Color3.fromRGB(55, 235, 245),
	Preto = Color3.fromRGB(15, 15, 20),
	Laranja = Color3.fromRGB(255, 140, 45)
}
t1.value21 = {
	"Vermelho",
	"Branco",
	"Verde",
	"Azul",
	"Roxo",
	"Amarelo",
	"Rosa",
	"Ciano",
	"Preto",
	"Laranja"
}

function t1.value22(p6)
	return t1.value20[p6] or t1.value20.Branco
end

t1.value23 = {
	gold = Color3.fromRGB(222, 177, 91),
	bg = Color3.fromRGB(9, 9, 13),
	panel = Color3.fromRGB(19, 19, 25),
	item = Color3.fromRGB(29, 29, 36),
	red = Color3.fromRGB(235, 27, 53),
	white = Color3.fromRGB(245, 245, 248),
	gray = Color3.fromRGB(165, 165, 178)
}
t1.value24 = nil
t1.value24 = "MacielHub_BETA_1_0_Config.json"

function t1.value25(p7, p8)
	if type(p8) == "table" then
		for k, v in pairs(p8) do
			local v20

			if p7[k] == nil then
				v20 = false
			else
				local v21 = p7[k]

				v20 = type(v21) == type(v)
			end

			if v20 then
				p7[k] = v
			end
		end
	end
end
function t1.value26()
	local readfile_2 = readfile

	if type(readfile_2) ~= "function" then
		return nil
	end

	for _, v in ipairs({
		t1.value24,
		"MacielHubV13_2_Config.json",
		"MacielHubV12_Config.json",
		"MacielHubV11_Config.json",
		"MacielHubV10_Config.json"
	}) do
		local ok, result = pcall(function()
			return t1.value5:JSONDecode(unpack_({ readfile(v) }))
		end)

		if ok then
			ok = type(result) == "table"
		end

		if ok then
			return result
		end
	end
end
function t1.value27(p9)
	if type(p9) ~= "table" then
		return false
	end

	t1.value25(t1.value14, p9.States)
	t1.value25(t1.value15, p9.Aim)
	t1.value25(t1.value16, p9.Movement)
	t1.value25(t1.value17, p9.Settings)
	t1.value25(t1.value19, p9.ESPStyle)
	t1.value25(t1.value18, p9.StoneSettings)

	if not ({
		PODER = true,
		ESPACO = true,
		TEMPO = true,
		TODAS = true
	})[t1.value18.Selection] then
		t1.value18.Selection = "TODAS"
	end

	t1.value15.VerticalOffset = 0
	t1.value15.CenterX = 0
	t1.value14.TeamCheck = false

	local value15 = t1.value15
	local CenterX = t1.value15.CenterX
	local v29 = tonumber(CenterX) or 0

	value15.CenterX = math.clamp(v29, -150, 150)

	local value152 = t1.value15
	local CenterY = t1.value15.CenterY
	local v32 = tonumber(CenterY) or 0

	value152.CenterY = math.clamp(v32, -150, 150)

	local value153 = t1.value15
	local FOV = t1.value15.FOV

	value153.FOV = math.clamp(FOV, 50, 500)

	local value154 = t1.value15
	local Strength = t1.value15.Strength

	value154.Strength = math.clamp(Strength, 0.05, 1)

	local value155 = t1.value15
	local Prediction = t1.value15.Prediction

	value155.Prediction = math.clamp(Prediction, 0, 0.5)

	local value156 = t1.value15
	local Freedom = t1.value15.Freedom

	value156.Freedom = math.clamp(Freedom, 0.1, 1)

	local value157 = t1.value15
	local MaxDistance = t1.value15.MaxDistance

	value157.MaxDistance = math.clamp(MaxDistance, 30, 500)

	local value158 = t1.value15
	local DistanceWeight = t1.value15.DistanceWeight

	value158.DistanceWeight = math.clamp(DistanceWeight, 0, 1)

	local value16 = t1.value16
	local Speed = t1.value16.Speed

	value16.Speed = math.clamp(Speed, 16, 300)

	local value162 = t1.value16
	local Jump = t1.value16.Jump

	value162.Jump = math.clamp(Jump, 50, 300)

	local value163 = t1.value16
	local Fly = t1.value16.Fly

	value163.Fly = math.clamp(Fly, 1, 300)

	local value17 = t1.value17
	local Transparency = t1.value17.Transparency

	value17.Transparency = math.clamp(Transparency, 0, 0.8)

	local value19 = t1.value19
	local ArtifactSize = t1.value19.ArtifactSize

	value19.ArtifactSize = math.clamp(ArtifactSize, 7, 24)

	local value192 = t1.value19
	local PlayerSize = t1.value19.PlayerSize

	value192.PlayerSize = math.clamp(PlayerSize, 7, 24)

	local value193 = t1.value19
	local ArtifactHeight = t1.value19.ArtifactHeight

	value193.ArtifactHeight = math.clamp(ArtifactHeight, 1, 7)

	local value194 = t1.value19
	local PlayerHeight = t1.value19.PlayerHeight

	value194.PlayerHeight = math.clamp(PlayerHeight, 1, 7)

	local value195 = t1.value19
	local ShieldHeight = t1.value19.ShieldHeight

	value195.ShieldHeight = math.clamp(ShieldHeight, 1, 7)

	local value196 = t1.value19
	local PlayerFill = t1.value19.PlayerFill

	value196.PlayerFill = math.clamp(PlayerFill, 0, 1)

	local value197 = t1.value19
	local PlayerOutline = t1.value19.PlayerOutline

	value197.PlayerOutline = math.clamp(PlayerOutline, 0, 1)

	local value198 = t1.value19
	local PlayerStroke = t1.value19.PlayerStroke

	value198.PlayerStroke = math.clamp(PlayerStroke, 0, 1)

	local value199 = t1.value19
	local PlayerDistance = t1.value19.PlayerDistance

	value199.PlayerDistance = math.clamp(PlayerDistance, 50, 3000)

	local value1910 = t1.value19
	local ArtifactFill = t1.value19.ArtifactFill

	value1910.ArtifactFill = math.clamp(ArtifactFill, 0, 1)

	local value1911 = t1.value19
	local ArtifactOutline = t1.value19.ArtifactOutline

	value1911.ArtifactOutline = math.clamp(ArtifactOutline, 0, 1)

	for _, v in ipairs({ "PlayerColor", "PlayerOutlineColor", "PlayerTextColor" }) do
		if not t1.value20[t1.value19[v]] then
			t1.value19[v] = "Branco"
		end
	end

	return true
end
function t1.value28()
	local writefile_ = writefile

	if type(writefile_) ~= "function" then
		return false, "Executor sem writefile"
	end

	local function v78()
		writefile(t1.value24, t1.value5:JSONEncode({
			Version = "BETA 1.0",
			States = t1.value14,
			Aim = t1.value15,
			Movement = t1.value16,
			Settings = t1.value17,
			ESPStyle = t1.value19,
			StoneSettings = t1.value18
		}))
	end

	local ok, result = pcall(v78)

	return ok, ok and "Configuracoes salvas!" or tostring(result)
end

readfile_ = t1.value26()

if readfile_ then
	v426 = readfile_.Settings

	if v426 then
		v426 = readfile_.Settings.AutoLoad == true
	end
else
	v426 = readfile_
end

if v426 then
	t1.value27(readfile_)
end

t1.value29 = nil

function t1.value29()
	local Character = t1.value7.Character
	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = Character
	end

	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	return Character, Humanoid, HumanoidRootPart
end
function t1.value30()
	local _, v85, v86 = t1.value29()

	if not v85 then
		return v85
	end

	if v85.Health > 0 then
		v85 = v86 ~= nil
	else
		v85 = false
	end

	return v85
end
function t1.value31(p10)
	local v87, v88, v89 = t1.value29()

	if not v87 or (not v88 or (v88.Health <= 0 and true or not v89)) then
		return false
	else
		v87:PivotTo(p10)
		v89.AssemblyLinearVelocity = Vector3.zero
		v89.AssemblyAngularVelocity = Vector3.zero

		return true
	end
end

t1.value32 = nil
readfile_ = Random.new()
t1.value33 = nil
t1.value33 = readfile_

function t1.value34()
	local v90, v91, v92 = ipairs(workspace:GetDescendants())
	local t2 = {}

	while true do
		local v94

		v92, v94 = v90(v91, v92)

		if not v92 then
			break
		end

		local isSpawnLocation = v94:IsA("SpawnLocation")

		if isSpawnLocation then
			isSpawnLocation = v94:IsDescendantOf(workspace)
		end

		if isSpawnLocation then
			table.insert(t2, v94)
		end
	end

	if #t2 == 0 then
		return nil, "Nenhum SpawnLocation encontrado"
	else
		local t3 = {}

		for _, v in ipairs(t2) do
			if #t2 == 1 or v ~= t1.value32 then
				table.insert(t3, v)
			end
		end

		if #t3 == 0 then
			return t2[t1.value33:NextInteger(1, #t2)]
		end

		t2 = t3

		return t2[t1.value33:NextInteger(1, #t2)]
	end
end
function t1.value35()
	local v99, v100 = t1.value34()

	if v99 then
		if t1.value31(v99.CFrame * CFrame.new(0, 5, 0)) then
			return true, "Spawn: " .. v99.Name
		else
			return false, "Personagem indisponivel"
		end
	else
		return false, v100
	end
end

t1.value36 = nil
t1.value37 = {
	PowerStone = "PODER",
	SpaceStone = "ESPACO",
	TimeStone = "TEMPO"
}
t1.value38 = {}
t1.value39 = {}
t1.value40 = false
t1.value41 = "Aguardando ativacao"
t1.value42 = {}

local function v101(p11)
	for _, descendant in ipairs(p11:GetDescendants()) do
		local isProximityPrompt = descendant:IsA("ProximityPrompt")

		if isProximityPrompt then
			isProximityPrompt = descendant.Enabled
		end

		if isProximityPrompt then
			return descendant
		end
	end
end

t1.value43 = nil

function t1.value43(p12)
	local v105 = p12.X == p12.X

	if not v105 then
		return v105
	end

	v105 = p12.Y == p12.Y

	if not v105 then
		return v105
	end

	v105 = p12.Z == p12.Z

	if not v105 then
		return v105
	end

	local X = p12.X

	if math.abs(X) < 100000 then
		local Y = p12.Y

		if math.abs(Y) < 100000 then
			local Z = p12.Z

			v105 = math.abs(Z) < 100000
		else
			v105 = false
		end
	else
		v105 = false
	end

	return v105
end
function t1.value44()
	local _, v110, v111 = t1.value29()

	if not (not v111 or (not v110 or v110.Health <= 0)) then
		local ipairs_ = ipairs
		local workspace_ = workspace
		local huge = math.huge
		local v115 = nil

		for _, child in ipairs_(workspace_.GetChildren(workspace_)) do
			local isBasePart = child:IsA("BasePart")

			if isBasePart then
				if child:GetAttribute("Type") == "InfinityStone" then
					isBasePart = child.Parent == workspace
				else
					isBasePart = false
				end
			end

			if isBasePart then
				local v119 = t1.value37[child.Name]
				local v120

				if v119 then
					v120 = t1.value18.Selection == "TODAS" and true or v119 == t1.value18.Selection

					if v120 then
						v120 = t1.value43(child.Position)

						if v120 then
							v120 = v101(child)
						end
					end
				else
					v120 = v119
				end

				if v120 then
					local now = os.clock()

					ipairs_ = t1.value39[child]

					if not ipairs_ or (ipairs_.pos - child.Position).Magnitude > 3 then
						ipairs_ = t1.value39
						ipairs_[child] = {
							pos = child.Position,
							since = now
						}
					else
						local v122 = now - ipairs_.since >= 0.35

						if v122 then
							v122 = (t1.value38[child] or 0) < 8

							if v122 then
								v122 = now - (t1.value42[child] or 0) >= 1.2
							end
						end

						if v122 then
							ipairs_ = (v111.Position - child.Position).Magnitude

							if ipairs_ < huge then
								huge = ipairs_
								v115 = {
									part = child,
									stone = v119
								}
							end
						end
					end
				else
					ipairs_ = v119
				end
			end
		end

		return v115
	end
end
function t1.value45(p13)
	if t1.value40 or not t1.value14.AutoStone then
		return
	end

	local part = p13.part
	local stone = p13.stone
	local v125 = t1.value38[part]

	t1.value38[part] = (v125 or 0) + 1
	t1.value42[part] = os.clock()

	local _, v127, v128 = t1.value29()

	if v128 then
		if v127 then
			if v127.Health > 0 and part.Parent == workspace then
				v127 = t1.value43(part.Position)
			else
				v127 = false
			end
		end
	else
		v127 = v128
	end

	if v127 then
		t1.value41 = "Teleportando para " .. stone
		v128.AssemblyLinearVelocity = Vector3.zero
		v128.AssemblyAngularVelocity = Vector3.zero
		v128.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0), part.Position)
		task.wait(0.25)

		local value8 = t1.value8

		if value8 then
			value8 = t1.value14.AutoStone

			if value8 then
				value8 = part.Parent == workspace
			end
		end

		if not value8 then
			t1.value40 = false

			return
		end

		local v130 = v101(part)
		local v131

		if v130 then
			local fireproximityprompt_ = fireproximityprompt

			v131 = type(fireproximityprompt_) == "function"
		else
			v131 = v130
		end

		if v131 then
			local ok = pcall(function()
				fireproximityprompt(v130)
			end)

			if ok then
				ok = "Interacao enviada: " .. stone
			end

			t1.value41 = ok or "Falha na interacao: " .. stone
		elseif v130 then
			t1.value41 = "Coleta automatica indisponivel neste ambiente"
		else
			t1.value41 = "Prompt indisponivel"
		end
	else
		t1.value41 = "Personagem ou joia indisponivel"
	end

	t1.value40 = false
end

task.spawn(function()
	while t1.value8 do
		local AutoStone = t1.value14.AutoStone

		if AutoStone then
			AutoStone = not t1.value40
		end

		if AutoStone then
			local v135 = t1.value44()

			if v135 then
				task.spawn(t1.value45, v135)
			else
				t1.value41 = "Aguardando joia solta..."
			end
		end

		task.wait(0.25)
	end
end)
t1.value46 = false
t1.value47 = "Pronto"

function t1.value48()
	if t1.value46 then
		return false, "Teleporte ja em andamento"
	end

	local ok, result = pcall(function()
		if game.JobId == "" then
			t1.value6:Teleport(game.PlaceId, t1.value7)
		else
			t1.value6:TeleportToPlaceInstance(game.PlaceId, game.JobId, t1.value7)
		end
	end)

	t1.value46 = false

	return ok, ok and "Reconectando..." or tostring(result)
end
function t1.value49()
	local t4 = {}
	local nextPageCursor = nil
	local HttpGet = game.HttpGet

	if type(HttpGet) ~= "function" then
		return nil, "HttpGet indisponivel"
	end

	for _ = 1, 8 do
		local v142 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		local v143

		if nextPageCursor then
			v142 = v142 .. "&cursor=" .. t1.value5:UrlEncode(nextPageCursor)
			v143 = v142
		else
			v143 = v142
		end

		local function v144()
			return t1.value5:JSONDecode(unpack_({ game:HttpGet(v142) }))
		end

		local ok, result = pcall(v144)
		local v147 = not ok

		if not v147 then
			if type(result) == "table" then
				local data = result.data

				v147 = type(data) ~= "table"
			else
				v147 = true
			end
		end

		if v147 then
			return #t4 > 0 and t4 and t4 or nil, "Nao foi possivel consultar servidores"
		end

		for _, v in ipairs(result.data) do
			local v151 = v.id ~= game.JobId

			if v151 then
				local playing = v.playing

				v151 = type(playing) == "number"

				if v151 then
					if type(v.maxPlayers) == "number" then
						v151 = v.playing < v.maxPlayers
					else
						v151 = false
					end
				end
			end

			if v151 then
				table.insert(t4, v)
			end
		end

		nextPageCursor = result.nextPageCursor

		if not nextPageCursor or #t4 >= 400 then
			return t4
		end
	end

	return t4
end

t1.value50 = {
	{
		name = "Joia do Poder",
		cf = CFrame.new(-340.574005, 693.074829, 1893.473022, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	},
	{
		name = "Joia do Espaco",
		cf = CFrame.new(-1379.545044, 702.556763, -3147.212891, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	},
	{
		name = "Joia do Tempo",
		cf = CFrame.new(2374.358887, 686.154114, 652.919983, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	},
	{
		name = "DarkHold",
		cf = CFrame.new(-2813.962402, 1050.727051, 646.695618, -0.690518, 0, 0.723315, 0, 1, 0, -0.723315, 0, -0.690518)
	}
}
t1.value51 = CFrame.new(-300.78598, 810.246643, 1584.316162, 0.566019, 0, -0.824392, 0, 1, 0, 0.824392, 0, 0.566019)
CFrame.new(286.668243, 649.367981, 1335.343384, -0.117845, 0, -0.993032, 0, 1, 0, 0.993032, 0, -0.117845)
t1.value52 = "https://gist.githubusercontent.com/alinepintadinha2026-collab/5f825a06419536794be27321041aa552/raw"
t1.value53 = false
t1.value54 = false
t1.value55 = "Auto Farm pronto"
t1.value56 = nil
t1.value57 = false
t1.value58 = 0

function t1.value59(p14)
	return (p14 == Enum.HumanoidStateType.Ragdoll or p14 == Enum.HumanoidStateType.FallingDown) and true or p14 == Enum.HumanoidStateType.Physics
end
function t1.value60(p15)
	local Parent

	if p15 then
		Parent = p15.Parent
	else
		Parent = p15
	end

	if not Parent then
		return
	end

	pcall(function()
		p15:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
		p15:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
	end)
end
function t1.value61()
	if not (t1.value8 and t1.value14.AntiRagdoll) then
		return
	end

	local v154, v155 = t1.value29()

	if not v154 or (not v155 or v155.Health <= 0) then
		return
	end

	pcall(function()
		if t1.value4:HasTag(v154, "Ragdolled") then
			t1.value4:RemoveTag(v154, "Ragdolled")
		end

		if v154:GetAttribute("RagdollCFrame") ~= nil then
			v154:SetAttribute("RagdollCFrame", nil)
		end

		local PlatformStand = t1.value59(v155:GetState()) or v155.PlatformStand

		v155.PlatformStand = false
		v155.Sit = false
		v155:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		v155:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

		if PlatformStand then
			PlatformStand = not t1.value57

			if PlatformStand then
				PlatformStand = os.clock() - t1.value58 >= 0.2
			end
		end

		if not PlatformStand then
			return
		end

		os.clock()
		v155:ChangeState(Enum.HumanoidStateType.GettingUp)
		task.delay(0.15, function() end)
	end)
end
function t1.value62()
	if not (t1.value8 and t1.value14.AntiAbilityLock) then
		return
	end

	local v157, v158 = t1.value29()

	if not v157 or (not v158 or v158.Health <= 0) then
		return
	end

	local function v159()
		if v157:GetAttribute("Stuns") ~= nil then
			v157:SetAttribute("Stuns", nil)
		end

		local PlatformStand = v158.PlatformStand

		if PlatformStand then
			PlatformStand = not t1.value14.AntiRagdoll
		end

		if not PlatformStand then
			return
		end

		v158.PlatformStand = false
	end

	pcall(v159)
end

t1.value63 = nil
t1.value64 = 0
t1.value65 = false
t1.value66 = {}

function t1.value67()
	t1.value63 = nil
	t1.value65 = false
end
function t1.value68(p16)
	if not p16 or p16 == t1.value7 then
		return nil
	end

	if t1.value14.IgnoreFriends then
		local ok, result = pcall(function()
			return t1.value7:IsFriendsWith(p16.UserId)
		end)

		if ok and result then
			return nil
		end
	end

	local Character = p16.Character
	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = Character
	end

	if not Character then
		v170, v171, v172 = t1.value29()

		if not v172 or (not Character or (not Humanoid or Humanoid.Health <= 0)) then
			return nil
		elseif (Character.Position - v172.Position).Magnitude > t1.value15.MaxDistance then
			return nil
		else
			return Character
		end
	end

	Character = Character:FindFirstChild("UpperTorso") or (Character:FindFirstChild("Torso") or (Character:FindFirstChild("HumanoidRootPart") or (Character.FindFirstChild(Character, "LowerTorso") or Character:FindFirstChild("Torso"))))

	local _, _, v167 = t1.value29()

	if not v167 or (not Character or (not Humanoid or Humanoid.Health <= 0)) then
		return nil
	elseif (Character.Position - v167.Position).Magnitude > t1.value15.MaxDistance then
		return nil
	else
		return Character
	end
end

t1.value69 = nil

function t1.value69(p17)
	local AssemblyLinearVelocity = p17.AssemblyLinearVelocity

	return p17.Position + Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z) * t1.value15.Prediction
end
function t1.value70(p18)
	if not t1.value30() then
		t1.value67()

		return nil, nil
	end

	local _, _, v173 = t1.value29()

	if not v173 then
		t1.value67()

		return nil, nil
	end

	local v174 = p18.ViewportSize * 0.5

	local function v175(p19)
		local v176 = t1.value68(p19)

		if v176 then
			local v177 = t1.value69(v176)
			local v178, v179 = p18:WorldToViewportPoint(v177)

			if not v179 or v178.Z <= 0 then
				return nil
			else
				local Magnitude = (Vector2.new(v178.X, v178.Y) - v174).Magnitude

				if t1.value15.FOV < Magnitude then
					return nil
				else
					local Magnitude2 = (v176.Position - v173.Position).Magnitude
					local FOV = t1.value15.FOV
					local v181 = Magnitude / math.max(FOV, 1) * (1 - t1.value15.DistanceWeight)
					local MaxDistance = t1.value15.MaxDistance

					return v177, v181 + Magnitude2 / math.max(MaxDistance, 1) * t1.value15.DistanceWeight
				end
			end
		else
			return nil
		end
	end

	local value63 = t1.value63
	local ipairs_, value1, huge, v187, v188, value65, v190, v191, v192

	if not value63 then
		v200 = value63 and v175(t1.value63)

		if v200 then
			return v200, t1.value63
		else
			ipairs_ = ipairs
			value1 = t1.value1
			huge = math.huge
			v187 = nil
			v188 = nil

			for _, player in ipairs_(value1.GetPlayers(value1)) do
				value65 = t1.value65

				if value65 then
					value65 = player == t1.value63
				end

				if not value65 then
					v190, v191 = v175(player)

					if v190 then
						v192 = v191 < huge
					else
						v192 = v190
					end

					if v192 then
						v188 = v190
						v187 = player
						huge = v191
					end
				end
			end

			t1.value63 = v187

			return v188, v187
		end
	end

	value63 = not t1.value65

	local v195 = value63 and v175(t1.value63)

	if v195 then
		return v195, t1.value63
	else
		ipairs_ = ipairs
		value1 = t1.value1
		huge = math.huge
		v187 = nil
		v188 = nil

		for _, player in ipairs_(value1.GetPlayers(value1)) do
			value65 = t1.value65

			if value65 then
				value65 = player == t1.value63
			end

			if not value65 then
				v190, v191 = v175(player)

				if v190 then
					v192 = v191 < huge
				else
					v192 = v190
				end

				if v192 then
					v188 = v190
					v187 = player
					huge = v191
				end
			end
		end

		t1.value63 = v187

		return v188, v187
	end
end

t1.value36 = {}
t1.value71 = nil
t1.value72 = nil
t1.value73 = nil
t1.value74 = nil
t1.value75 = nil
t1.value76 = nil
t1.value76 = nil

function t1.value77()
	t1.value75 = nil
	t1.value76 = nil
end

t1.value78 = nil

function t1.value78()
	return t1.value16.Fly <= 100 and 65 or 65 + 45 * ((t1.value16.Fly - 100) / 200)
end
function t1.value79()
	for k, v in pairs(t1.value36) do
		local Parent

		if k then
			Parent = k.Parent
		else
			Parent = k
		end

		if Parent then
			pcall(function()
				k.CanCollide = v
			end)
		end

		t1.value36[k] = nil
	end
end
function t1.value80()
	local value71 = t1.value71

	if value71 then
		value71 = t1.value71.Parent
	end

	if not value71 then
		return
	end

	if t1.value72 then
		t1.value71.WalkSpeed = t1.value72
	end

	if t1.value73 then
		t1.value71.JumpPower = t1.value73
	end

	if not t1.value74 then
		return
	end

	t1.value71.JumpHeight = t1.value74
end
function t1.value81()
	local v202, v203 = t1.value29()
	local v204

	if v203 then
		v204 = v203 ~= t1.value71
	else
		v204 = v203
	end

	if v204 then
		t1.value71 = v203
		t1.value72 = v203.WalkSpeed
		t1.value73 = v203.JumpPower
		t1.value74 = v203.JumpHeight
		table.clear(t1.value36)
	end

	if v203 then
		if t1.value14.WalkSpeed then
			v203.WalkSpeed = t1.value16.Speed
		end

		if t1.value14.Jump then
			if v203.UseJumpPower then
				v203.JumpPower = t1.value16.Jump
			else
				v203.JumpHeight = t1.value16.Jump / 7
			end
		end
	end

	if not (t1.value14.Noclip and v202) then
		return
	end

	local GetDescendants = v202.GetDescendants

	for _, v in ipairs(GetDescendants(v202)) do
		if v:IsA("BasePart") then
			if t1.value36[v] == nil then
				t1.value36[v] = v.CanCollide
			end

			v.CanCollide = false
		end
	end
end
function t1.value82(p20)
	if not t1.value14.FlySpeed then
		return
	end

	local v208, v209, v210 = t1.value29()
	local CurrentCamera = workspace.CurrentCamera

	if not v208 or (not v209 or (not v210 or (not CurrentCamera or (v209.Health <= 0 and true or v209.FloorMaterial ~= Enum.Material.Air)))) then
		t1.value77()

		return
	end

	local MoveDirection = v209.MoveDirection

	if MoveDirection.Magnitude < 0.05 then
		t1.value77()

		return
	end

	local LookVector = CurrentCamera.CFrame.LookVector
	local RightVector = CurrentCamera.CFrame.RightVector
	local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)
	local vector32 = Vector3.new(RightVector.X, 0, RightVector.Z)

	if vector3.Magnitude < 0.001 and true or vector32.Magnitude < 0.001 then
		return
	end

	local Unit = vector3.Unit
	local Unit2 = vector32.Unit
	local v219 = MoveDirection:Dot(Unit)
	local Dot = MoveDirection.Dot
	local v221 = LookVector * v219 + RightVector * Dot(MoveDirection, Unit2)

	if v221.Magnitude < 0.05 then
		t1.value77()

		return
	end

	local v222 = v221.Unit * t1.value78()
	local AssemblyLinearVelocity = v210.AssemblyLinearVelocity

	if t1.value75 ~= v210 and true or not t1.value76 then
		t1.value76 = AssemblyLinearVelocity
	end

	local v224 = math.clamp(p20, 0, 0.05)
	local v225 = -5 * v224

	t1.value76 = t1.value76:Lerp(v222, 1 - math.exp(v225))

	local v226 = t1.value76 - AssemblyLinearVelocity
	local v227 = 180 * v224

	if not (v227 < v226.Magnitude) then
		v210.AssemblyLinearVelocity = AssemblyLinearVelocity + v226

		return
	end

	v226 = v226.Unit * v227
	v210.AssemblyLinearVelocity = AssemblyLinearVelocity + v226
end

t1.value83 = {}

local function v228()
	if t1.value53 or t1.value54 then
		return true, "Menu do Auto Farm ja carregado"
	end

	local function v229()
		local response = game:HttpGet(t1.value52)
		local loadstring_ = loadstring

		assert(loadstring_(response))()
	end

	t1.value55 = "Carregando Auto Farm..."

	local ok, result = pcall(v229)

	if ok then
		t1.value54 = true
		t1.value14.AutoFarm = true
		t1.value55 = "Menu independente carregado"

		return true, t1.value55
	else
		t1.value54 = false
		t1.value14.AutoFarm = false
		t1.value55 = "Erro: " .. tostring(result)
		warn("SKYHUB FARM:", result)

		return false, t1.value55
	end
end
local function v234()
	local MacielFarmCleanup = _G.MacielFarmCleanup

	if type(MacielFarmCleanup) == "function" then
		pcall(_G.MacielFarmCleanup)
		t1.value54 = false
		t1.value14.AutoFarm = false
		t1.value55 = "Auto Farm fechado"

		return true
	else
		t1.value14.AutoFarm = t1.value54
		t1.value55 = t1.value54 and "Desative pelo menu do Auto Farm" or "Auto Farm desligado"

		return not t1.value54
	end
end
local function v236(p21)
	if t1.value46 then
		return false, "Operacao em andamento"
	end

	t1.value47 = "Buscando servidores..."

	local v237, v238 = t1.value49()

	if not v237 or #v237 == 0 then
		t1.value47 = v238 or "Nenhum servidor disponivel"

		return false, t1.value47
	end

	local v239

	if p21 then
		table.sort(v237, function(p22, p23)
			return p22.playing < p23.playing
		end)
		v239 = v237[1]
	else
		v239 = v237[math.random(1, #v237)]
	end

	t1.value47 = "Entrando em servidor (" .. v239.playing .. "/" .. v239.maxPlayers .. ")"

	local ok, result = pcall(function()
		t1.value6:TeleportToPlaceInstance(game.PlaceId, v239.id, t1.value7)
	end)

	if ok then
		return ok, t1.value47
	end

	t1.value47 = "Falha: " .. tostring(result)

	return ok, t1.value47
end

for _, v in ipairs({
	"ZombieWanda_ReactionAura",
	"Wic_CounterRunes",
	"WM_Endgame_ChaosShield",
	"SW_BubbleShieldAura",
	"SW_ChaosBubble",
	"JeanGrey_Parry",
	"JeanGrey_Parry_DarkPhoenix",
	"DrStrange_EldritchShield",
	"IW_BubbleShield",
	"InvisibleWoman_BubbleShield",
	"Cyclops_OpticBlock",
	"HT_FlameShield",
	"HT_HeatShield"
}) do
	t1.value83[v:lower()] = true
end

t1.value84 = nil

function t1.value85(p24)
	local v244

	if p24 == nil then
		v244 = false
	else
		v244 = t1.value83[tostring(p24):lower()] == true
	end

	return v244
end
function t1.value86(p25)
	if p25:GetAttribute("Shielded") == true then
		return true
	else
		local AbilityFolder = p25:FindFirstChild("AbilityFolder")
		local ipairs_ = ipairs

		for _, descendant in ipairs_(p25:GetDescendants()) do
			local v249

			if AbilityFolder then
				v249 = descendant == AbilityFolder or descendant:IsDescendantOf(AbilityFolder)
			else
				v249 = AbilityFolder
			end

			if not v249 then
				if descendant:IsA("ForceField") or t1.value85(descendant.Name) then
					return true
				end

				local isConfiguration = descendant:IsA("Configuration")

				if isConfiguration then
					isConfiguration = descendant:GetAttribute("BeamName") == "DarkholdAbsorb"
				end

				if isConfiguration then
					return true
				end

				local isConfiguration2 = descendant:IsA("Configuration")

				if isConfiguration2 then
					isConfiguration2 = t1.value85(descendant:GetAttribute("EffectSetName")) or (t1.value85(descendant:GetAttribute("AttachmentName")) or t1.value85(descendant:GetAttribute("EffectName")))
				end

				if isConfiguration2 then
					return true
				end
			end
		end

		return false
	end
end

t1.value87 = nil
t1.value88 = nil
t1.value89 = nil
t1.value84 = {}

function t1.value90()
	for k, v in pairs(t1.value84) do
		v:Destroy()
		t1.value84[k] = nil
	end
end

t1.value88 = nil

function t1.value91(p26)
	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "MacielWhiteShield"
	BillboardGui.Size = UDim2.fromOffset(11, 13)
	BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, t1.value19.ShieldHeight, 0)
	BillboardGui.AlwaysOnTop = false
	BillboardGui.LightInfluence = 0
	BillboardGui.Enabled = false
	BillboardGui.Parent = t1.value88

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromScale(1, 1)
	Frame.BackgroundTransparency = 1
	Frame.Parent = BillboardGui

	local t5 = {
		Vector2.new(0.5, 0.06),
		Vector2.new(0.88, 0.2),
		Vector2.new(0.83, 0.66),
		Vector2.new(0.68, 0.84),
		Vector2.new(0.5, 0.96),
		Vector2.new(0.32, 0.84),
		Vector2.new(0.17, 0.66),
		Vector2.new(0.12, 0.2),
		Vector2.new(0.5, 0.06)
	}

	for i = 1, #t5 - 1 do
		local v258 = t5[i]
		local v259 = t5[i + 1]
		local v260 = v259 - v258
		local Frame2 = Instance.new("Frame")

		Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame2.Position = UDim2.fromScale((v258.X + v259.X) / 2, (v258.Y + v259.Y) / 2)
		Frame2.Size = UDim2.new(v260.Magnitude, 0, 0, 1)

		local Y = v260.Y
		local X = v260.X
		local v264 = math.atan2(Y, X)

		Frame2.Rotation = math.deg(v264)
		Frame2.BackgroundColor3 = t1.value23.white
		Frame2.BorderSizePixel = 0
		Frame2.Parent = Frame
	end

	t1.value84[p26] = BillboardGui

	return BillboardGui
end

t1.value92 = RaycastParams.new()
t1.value92.FilterType = Enum.RaycastFilterType.Exclude
t1.value92.IgnoreWater = true
t1.value93 = 0

function t1.value94()
	local v265, v266, v267 = pairs(t1.value84)

	while true do
		local v268

		v267, v268 = v265(v266, v267)

		if not v267 then
			break
		end

		v268.Enabled = false
	end

	local value93 = 0

	t1.value93 = value93

	if not t1.value14.ShieldDetector then
		return
	end

	local CurrentCamera = workspace.CurrentCamera
	local _, _, v273 = t1.value29()

	if CurrentCamera and v273 then
		local ipairs_ = ipairs
		local value1 = t1.value1

		for _, player in ipairs_(value1.GetPlayers(value1)) do
			if player ~= t1.value7 then
				local Character = player.Character
				local HumanoidRootPart

				if Character then
					HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
				else
					HumanoidRootPart = Character
				end

				local Head

				if Character then
					Head = Character:FindFirstChild("Head")
				else
					Head = Character
				end

				local Humanoid

				if Character then
					Humanoid = Character:FindFirstChildOfClass("Humanoid")
				else
					Humanoid = Character
				end

				if HumanoidRootPart then
					if Head then
						if Humanoid then
							if Humanoid.Health > 0 then
								Humanoid = (HumanoidRootPart.Position - v273.Position).Magnitude <= 500
							else
								Humanoid = false
							end
						end
					else
						Humanoid = Head
					end
				else
					Humanoid = HumanoidRootPart
				end

				if Humanoid then
					local v282, v283 = CurrentCamera:WorldToViewportPoint(Head.Position)

					if v283 then
						v283 = v282.Z > 0
					end

					if v283 then
						t1.value92.FilterDescendantsInstances = { t1.value7.Character, Character }

						local v284 = not workspace:Raycast(CurrentCamera.CFrame.Position, Head.Position - CurrentCamera.CFrame.Position, t1.value92)

						if v284 then
							v284 = t1.value86(Character)
						end

						if v284 then
							local v285 = t1.value84[player] or t1.value91(player)

							v285.Adornee = Head

							local ESP = t1.value14.ESP

							if ESP then
								ESP = t1.value14.Labels

								if ESP then
									ESP = t1.value87

									if ESP then
										ESP = t1.value87[player] ~= nil
									end
								end
							end

							local value89 = t1.value14.PlayerESP and t1.value89

							if value89 then
								value89 = t1.value89[player]
							end

							local v288 = (ESP or value89) and 1 or 0
							local s1 = "StudsOffsetWorldSpace"
							local vector3New = Vector3.new
							local v291 = v288 == 1
							local n1 = 0

							if v291 then
								if ESP then
									ESP = t1.value19.ArtifactHeight
								end

								v291 = ESP or t1.value19.PlayerHeight
							end

							v285[s1] = vector3New(n1, v291 or t1.value19.ShieldHeight, 0)
							v285.StudsOffset = Vector3.new(v288 == 1 and 1.15 or 0, 0, 0)
							v285.Size = UDim2.fromOffset(11, 13)
							v285.Enabled = true

							local v293 = t1

							v293.value93 = v293.value93 + 1
						end
					end
				end
			end
		end
	end
end

t1.value95 = {
	Power = Color3.fromRGB(175, 65, 255),
	Space = Color3.fromRGB(40, 130, 255),
	Time = Color3.fromRGB(45, 255, 95),
	Darkhold = Color3.fromRGB(195, 25, 45)
}
t1.value96 = nil
t1.value97 = {
	Power = "POWER STONE",
	Space = "SPACE STONE",
	Time = "TIME STONE",
	Darkhold = "DARKHOLD"
}
t1.value87 = {}

function t1.value98(p27)
	local AbilityFolder = p27:FindFirstChild("AbilityFolder")

	if AbilityFolder then
		local attribute = AbilityFolder:GetAttribute("Passive1")

		if attribute == "OpenDarkhold" or (AbilityFolder.GetAttribute(AbilityFolder, "DarkholdSpell_One") ~= nil or (AbilityFolder:GetAttribute("DarkholdSpell_Two") ~= nil and true or AbilityFolder:GetAttribute("DarkholdSpell_Three") ~= nil)) then
			return "Darkhold"
		elseif attribute == "TimeStoneRewind" and true or p27:GetAttribute("TimeStone/LastUpdate") ~= nil then
			return "Time"
		elseif attribute == "PowerBeam" then
			return "Power"
		elseif attribute == "MeteorRain" then
			return "Space"
		else
			return
		end
	else
		return nil
	end
end

t1.value99 = nil

function t1.value99(p28)
	local v296 = t1.value87[p28]

	if not v296 then
		return
	end

	if v296.highlight then
		v296.highlight:Destroy()
	end

	if not v296.billboard then
		t1.value87[p28] = nil

		return
	end

	v296.billboard:Destroy()
	t1.value87[p28] = nil
end
function t1.value100()
	for k in pairs(t1.value87) do
		t1.value99(k)
	end
end
function t1.value101(p29, p30, p31)
	t1.value99(p29)

	local HumanoidRootPart = p30:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		local v299 = t1.value95[p31]
		local Highlight = Instance.new("Highlight")

		Highlight.Adornee = p30
		Highlight.FillColor = v299
		Highlight.OutlineColor = v299
		Highlight.FillTransparency = t1.value19.ArtifactFill
		Highlight.OutlineTransparency = t1.value19.ArtifactOutline
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Highlight.Parent = t1.value88

		local BillboardGui = Instance.new("BillboardGui")

		BillboardGui.Adornee = HumanoidRootPart
		BillboardGui.Size = UDim2.fromOffset(180, 38)
		BillboardGui.StudsOffset = Vector3.new(0, t1.value19.ArtifactHeight, 0)
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Parent = t1.value88

		local TextLabel = Instance.new("TextLabel")

		TextLabel.BackgroundTransparency = 1
		TextLabel.Size = UDim2.fromScale(1, 1)
		TextLabel.TextColor3 = v299
		TextLabel.TextSize = t1.value19.ArtifactSize
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextWrapped = true
		TextLabel.TextStrokeTransparency = 0.3
		TextLabel.Parent = BillboardGui
		t1.value87[p29] = {
			highlight = Highlight,
			billboard = BillboardGui,
			label = TextLabel,
			char = p30,
			artifact = p31
		}
	end
end

t1.value102 = nil

function t1.value103()
	if t1.value14.ESP then
		local _, _, v305 = t1.value29()
		local ipairs_ = ipairs
		local value1 = t1.value1
		local portadores = 0

		for _, player in ipairs_(value1.GetPlayers(value1)) do
			if player ~= t1.value7 then
				local Character = player.Character
				local v312

				if Character then
					v312 = t1.value98(Character)
				else
					v312 = Character
				end

				if v312 and t1.value14[v312] then
					local v313 = t1.value87[player]

					if not v313 or (v313.char ~= Character and true or v313.artifact ~= v312) then
						t1.value101(player, Character, v312)
						v313 = t1.value87[player]
					end

					if v313 then
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if HumanoidRootPart then
							local v315

							if t1.value14.Distance and v305 then
								local Magnitude = (HumanoidRootPart.Position - v305.Position).Magnitude

								v315 = " | " .. math.floor(Magnitude) .. " studs"
							else
								v315 = ""
							end

							v313.label.Text = player.DisplayName .. "\n" .. t1.value97[v312] .. v315
							v313.highlight.FillTransparency = t1.value19.ArtifactFill
							v313.highlight.OutlineTransparency = t1.value19.ArtifactOutline
							v313.label.TextSize = t1.value19.ArtifactSize
							v313.billboard.StudsOffset = Vector3.new(0, t1.value19.ArtifactHeight, 0)
							v313.highlight.Enabled = t1.value14.Highlight
							v313.billboard.Enabled = t1.value14.Labels
							portadores = portadores + 1
						else
							t1.value99(player)
						end
					end
				else
					t1.value99(player)
				end
			end
		end

		local v317, v318, v319 = pairs(t1.value87)

		while true do
			v319 = v317(v318, v319)

			if not v319 then
				break
			end

			if v319.Parent ~= t1.value1 then
				t1.value99(v319)
			end
		end

		local value102 = t1.value102

		if value102 then
			value102 = t1.value102.Parent
		end

		if not value102 then
			return
		end

		t1.value102.Text = _G.SkyHubTranslate("PORTADORES: " .. portadores)

		return
	end

	t1.value100()

	local value102 = t1.value102

	if value102 then
		value102 = t1.value102.Parent
	end

	if not value102 then
		return
	end

	t1.value102.Text = _G.SkyHubTranslate("ESP DESLIGADO")
end

t1.value89 = {}
t1.value96 = {}
t1.value104 = nil

function t1.value104(p32)
	local v322 = t1.value96[p32]

	if not v322 then
		t1.value96[p32] = nil

		return
	end

	for _, v in ipairs(v322) do
		if v then
			v:Destroy()
		end
	end

	t1.value96[p32] = nil
end
function t1.value105()
	for k in pairs(t1.value96) do
		t1.value104(k)
	end
end
function t1.value106(p33)
	t1.value104(p33)

	if not t1.value8 or (not t1.value14.PlayerESP or (not t1.value89[p33] or p33 == t1.value7)) then
		return
	end

	local Character = p33.Character
	local Head

	if Character then
		Head = Character:FindFirstChild("Head")
	else
		Head = Character
	end

	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	if not (Head and HumanoidRootPart) then
		return
	end

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "MacielESPHighlight"
	Highlight.Adornee = Character

	local s2 = "DepthMode"
	local PlayerThroughWalls = t1.value19.PlayerThroughWalls

	if not PlayerThroughWalls then
		Highlight[s2] = PlayerThroughWalls or Enum.HighlightDepthMode.Occluded
		Highlight.Parent = t1.value88
		v341 = Instance.new("BillboardGui")
		v341.Name = "MacielESPName"
		v341.Adornee = Head
		v341.Size = UDim2.fromOffset(200, 42)
		v341.AlwaysOnTop = t1.value19.PlayerThroughWalls
		v341.Parent = t1.value88
		v342 = Instance.new("TextLabel")
		v342.Name = "PlayerName"
		v342.Size = UDim2.fromScale(1, 1)
		v342.BackgroundTransparency = 1
		v342.TextStrokeColor3 = Color3.new(0, 0, 0)
		v342.Font = Enum.Font.GothamBold
		v342.Parent = v341
		v343 = Instance.new("BillboardGui")
		v343.Name = "MacielESPBox"
		v343.Adornee = HumanoidRootPart
		v343.Size = UDim2.fromOffset(65, 115)
		v343.AlwaysOnTop = t1.value19.PlayerThroughWalls
		v343.Parent = t1.value88
		v344 = Instance.new("Frame")
		v344.Name = "BoxBorder"
		v344.BackgroundTransparency = 1
		v344.Size = UDim2.fromScale(1, 1)
		v344.Parent = v343
		Instance.new("UIStroke").Parent = v344
		t1.value96[p33] = { Highlight, v341, v343 }

		return
	end

	PlayerThroughWalls = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight[s2] = PlayerThroughWalls or Enum.HighlightDepthMode.Occluded
	Highlight.Parent = t1.value88

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "MacielESPName"
	BillboardGui.Adornee = Head
	BillboardGui.Size = UDim2.fromOffset(200, 42)
	BillboardGui.AlwaysOnTop = t1.value19.PlayerThroughWalls
	BillboardGui.Parent = t1.value88

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "PlayerName"
	TextLabel.Size = UDim2.fromScale(1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Parent = BillboardGui

	local BillboardGui2 = Instance.new("BillboardGui")

	BillboardGui2.Name = "MacielESPBox"
	BillboardGui2.Adornee = HumanoidRootPart
	BillboardGui2.Size = UDim2.fromOffset(65, 115)
	BillboardGui2.AlwaysOnTop = t1.value19.PlayerThroughWalls
	BillboardGui2.Parent = t1.value88

	local Frame = Instance.new("Frame")

	Frame.Name = "BoxBorder"
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.fromScale(1, 1)
	Frame.Parent = BillboardGui2
	Instance.new("UIStroke").Parent = Frame
	t1.value96[p33] = { Highlight, BillboardGui, BillboardGui2 }
end
function t1.value107()
	if not t1.value14.PlayerESP then
		t1.value105()

		return
	end

	local _, _, v338 = t1.value29()
	local ipairs_ = ipairs
	local value1 = t1.value1

	for _, player in ipairs_(value1.GetPlayers(value1)) do
		if player ~= t1.value7 then
			local Character = player.Character
			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			local Head

			if Character then
				Head = Character:FindFirstChild("Head")
			else
				Head = Character
			end

			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			local Magnitude = v338 and HumanoidRootPart

			if Magnitude then
				Magnitude = (v338.Position - HumanoidRootPart.Position).Magnitude
			end

			local huge = Magnitude or math.huge
			local v349 = t1.value89[player]

			if v349 then
				if Head then
					if HumanoidRootPart then
						if Humanoid then
							if Humanoid.Health > 0 then
								Humanoid = huge <= t1.value19.PlayerDistance
							else
								Humanoid = false
							end
						end
					else
						Humanoid = HumanoidRootPart
					end
				else
					Humanoid = Head
				end
			else
				Humanoid = v349
			end

			if Humanoid then
				local v350 = t1.value96[player]
				local v351

				if not v350 or (not v350[1] or v350[1].Adornee ~= Character) then
					t1.value106(player)
					v350 = t1.value96[player]
					v351 = v350
				else
					v351 = v350
				end

				if v350 then
					local v352 = v350[1]
					local v353 = v350[2]
					local v354 = v350[3]

					v352.Enabled = t1.value19.PlayerHighlight
					v352.FillColor = t1.value22(t1.value19.PlayerColor)
					v352.OutlineColor = t1.value22(t1.value19.PlayerOutlineColor)
					v352.FillTransparency = t1.value19.PlayerFill
					v352.OutlineTransparency = t1.value19.PlayerOutline

					local s3 = "DepthMode"
					local PlayerThroughWalls = t1.value19.PlayerThroughWalls

					if PlayerThroughWalls then
						PlayerThroughWalls = Enum.HighlightDepthMode.AlwaysOnTop
					end

					v352[s3] = PlayerThroughWalls or Enum.HighlightDepthMode.Occluded
					v353.Enabled = t1.value19.PlayerNames or t1.value19.PlayerDistanceLabel
					v353.AlwaysOnTop = t1.value19.PlayerThroughWalls
					v353.StudsOffset = Vector3.new(0, t1.value19.PlayerHeight, 0)

					local PlayerName = v353:FindFirstChild("PlayerName")

					if PlayerName then
						local PlayerNames = t1.value19.PlayerNames

						if PlayerNames then
							PlayerNames = player.DisplayName
						end

						local v359 = PlayerNames or ""
						local PlayerDistanceLabel = t1.value19.PlayerDistanceLabel

						if PlayerDistanceLabel then
							PlayerDistanceLabel = string.format(" [%.0f studs]", huge)
						end

						PlayerName.Text = v359 .. (PlayerDistanceLabel or "")
						PlayerName.TextSize = t1.value19.PlayerSize
						PlayerName.TextColor3 = t1.value22(t1.value19.PlayerTextColor)
						PlayerName.TextStrokeTransparency = t1.value19.PlayerStroke
					end

					v354.Enabled = t1.value19.PlayerBox
					v354.AlwaysOnTop = t1.value19.PlayerThroughWalls

					local BoxBorder = v354:FindFirstChild("BoxBorder")

					if BoxBorder then
						BoxBorder = BoxBorder:FindFirstChildOfClass("UIStroke")
					end

					if BoxBorder then
						BoxBorder.Color = t1.value22(t1.value19.PlayerOutlineColor)
						BoxBorder.Thickness = 2
						BoxBorder.Transparency = t1.value19.PlayerOutline
					end
				end
			else
				t1.value104(player)
			end
		end
	end
end

t1.value108 = {
	busy = false,
	waiting = false,
	cycle = 0,
	message = "Sistema pronto"
}
t1.value109 = nil

function t1.value110(p34)
	t1.value108.message = p34

	local value109 = t1.value109

	if value109 then
		value109 = t1.value109.Parent
	end

	if not value109 then
		return
	end

	t1.value109.Text = _G.SkyHubTranslate(p34)
end
function t1.value111()
	local value108 = t1.value108

	value108.cycle = value108.cycle + 1
	t1.value108.busy = false
	t1.value108.waiting = false
	t1.value110("Sequencia cancelada")
end
function t1.value112()
	if t1.value108.busy then
		t1.value110("Recuperacao em andamento")

		return
	end

	if not t1.value30() then
		t1.value110("Personagem indisponivel")

		return
	end

	local v364, v365, v366 = ipairs(workspace:GetDescendants())
	local v367 = false

	while true do
		local v368

		v366, v368 = v364(v365, v366)

		if not v366 then
			break
		end

		if v368:IsA("SpawnLocation") then
			v367 = true

			break
		end
	end

	if not v367 then
		t1.value110("Nenhum SpawnLocation encontrado")

		return
	end

	local value108 = t1.value108
	local s4 = "cycle"

	value108[s4] = value108[s4] + 1

	local cycle = t1.value108.cycle

	t1.value108.busy = true
	t1.value108.waiting = false
	t1.value110("Indo para esconderijo...")

	if not t1.value31(t1.value51) then
		t1.value108.busy = false
		t1.value110("Falha no teleporte")

		return
	end

	local _, v373 = t1.value29()

	local function v374()
		if not t1.value8 or cycle ~= t1.value108.cycle then
			return
		end

		t1.value108.waiting = true
		t1.value110("Reiniciando personagem...")

		local Parent = v373

		if Parent then
			Parent = v373.Parent
		end

		if Parent then
			local function v376()
				v373.Health = 0
			end

			pcall(v376)
		end

		local function v377()
			local value8 = t1.value8

			if value8 then
				if cycle == t1.value108.cycle then
					value8 = t1.value108.waiting
				else
					value8 = false
				end
			end

			if not value8 then
				return
			end

			t1.value108.busy = false
			t1.value108.waiting = false
			t1.value110("Tempo de respawn excedido")
		end

		task.delay(18, v377)
	end

	task.delay(1, v374)
end

t1.value12(t1.value7.CharacterAdded, function(p35)
	if not t1.value108.waiting then
		return
	end

	local cycle = t1.value108.cycle

	task.spawn(function()
		local Humanoid = p35:WaitForChild("Humanoid", 15)
		local wait = p35
		local HumanoidRootPart = wait:WaitForChild("HumanoidRootPart", 15)

		if not t1.value8 or cycle ~= t1.value108.cycle then
			return
		end

		if not (Humanoid and HumanoidRootPart) then
			t1.value108.busy = false
			t1.value108.waiting = false
			t1.value110("Falha ao detectar respawn")

			return
		end

		while true do
			local value8 = t1.value8

			if value8 then
				if cycle == t1.value108.cycle then
					value8 = Humanoid.Health <= 0
				else
					value8 = false
				end
			end

			if not value8 then
				break
			end

			wait = task.wait
			wait(0.1)
		end

		task.wait(0.3)

		if not t1.value8 or cycle ~= t1.value108.cycle then
			return
		end

		t1.value108.waiting = false
		t1.value110("Voltando para pegar a joia...")

		if t1.value7.Character ~= p35 and true or not t1.value31(t1.value51) then
			t1.value108.busy = false
			t1.value110("Falha ao voltar para a joia")

			return
		end

		t1.value110("Pegue a joia! TP aleatorio em 5 segundos")
		task.wait(5)

		if not t1.value8 or cycle ~= t1.value108.cycle then
			return
		end

		if t1.value7.Character ~= p35 and true or Humanoid.Health <= 0 then
			t1.value108.busy = false
			t1.value110("Personagem indisponivel para TP final")

			return
		end

		t1.value110("Teleportando para SpawnPoint aleatorio...")

		local v384, falhaNoTpFinal = t1.value35()

		t1.value108.busy = false

		local value110 = t1.value110

		if not v384 then
			value110(v384 or "Falha no TP final: " .. falhaNoTpFinal)

			return
		end

		v384 = "Sequencia concluida! " .. falhaNoTpFinal
		value110(v384 or "Falha no TP final: " .. falhaNoTpFinal)
	end)
end)

local function v387(p36)
	t1.value13(t1.value11)
	t1.value77()
	t1.value67()
	t1.value64 = os.clock() + 0.5

	local Humanoid = p36:WaitForChild("Humanoid", 10)

	if not t1.value8 or (t1.value7.Character ~= p36 and true or not Humanoid) then
		return
	end

	t1.value56 = Humanoid
	t1.value12(Humanoid.StateChanged, function(_, p37)
		local AntiRagdoll = t1.value14.AntiRagdoll

		if AntiRagdoll then
			AntiRagdoll = t1.value59(p37)
		end

		if not AntiRagdoll then
			return
		end

		task.defer(t1.value61)
	end, t1.value11)

	local GetAttributeChangedSignal = p36.GetAttributeChangedSignal

	t1.value12(GetAttributeChangedSignal(p36, "RagdollCFrame"), function()
		if not t1.value14.AntiRagdoll then
			return
		end

		task.defer(t1.value61)
	end, t1.value11)
	t1.value12(p36:GetAttributeChangedSignal("Stuns"), function()
		if not t1.value14.AntiAbilityLock then
			return
		end

		task.defer(t1.value62)
	end, t1.value11)
	t1.value12(Humanoid.Died, function()
		t1.value67()
		t1.value64 = math.huge
		t1.value77()
	end, t1.value11)

	if t1.value14.AntiRagdoll then
		t1.value61()
	end

	if not t1.value14.AntiAbilityLock then
		return
	end

	t1.value62()
end

t1.value12(t1.value4:GetInstanceAddedSignal("Ragdolled"), function(p38)
	local AntiRagdoll

	if p38 == t1.value7.Character then
		AntiRagdoll = t1.value14.AntiRagdoll
	else
		AntiRagdoll = false
	end

	if not AntiRagdoll then
		return
	end

	task.defer(t1.value61)
end)
t1.value12(t1.value7.CharacterAdded, function(p39)
	task.spawn(v387, p39)
end)

if t1.value7.Character then
	task.spawn(v387, t1.value7.Character)
end

t1.value113 = {}

function t1.value114(p40)
	if p40 == t1.value7 and true or t1.value113[p40] then
		return
	end

	t1.value113[p40] = t1.value12(p40.CharacterAdded, function()
		task.delay(0.7, function()
			if not t1.value8 then
				return
			end

			t1.value106(p40)
		end)
	end)
end

for _, player in ipairs(t1.value1:GetPlayers()) do
	t1.value114(player)
end

t1.value115 = nil
t1.value12(t1.value1.PlayerAdded, function(p41)
	t1.value114(p41)

	if not t1.value115 then
		return
	end

	task.defer(t1.value115)
end)
t1.value12(t1.value1.PlayerRemoving, function(p42)
	t1.value99(p42)
	t1.value104(p42)

	local v394 = t1.value84[p42]

	if v394 then
		v394:Destroy()
		t1.value84[p42] = nil
	end

	t1.value89[p42] = nil

	if t1.value113[p42] then
		t1.value113[p42]:Disconnect()
		t1.value113[p42] = nil
	end

	if t1.value63 == p42 then
		t1.value67()
	end

	if not t1.value115 then
		return
	end

	task.defer(t1.value115)
end)
t1.value116 = nil

function t1.value116(p43, p44, p45)
	local instance = Instance.new(p43)

	for k, v in pairs(p44 or {}) do
		instance[k] = v
	end

	instance.Parent = p45

	return instance
end
function t1.value117(p46, p47)
	t1.value116("UICorner", {
		CornerRadius = UDim.new(0, p47 or 7)
	}, p46)
end
function t1.value118(p48, p49, p50, _, p51)
	local value116 = t1.value116
	local v399 = _G.SkyHubTranslate(p49)
	local v400 = p50 or 12
	local color33

	if p51 then
		color33 = Color3.fromRGB(255, 220, 143)
	else
		color33 = p51
	end

	local color34 = color33 or Color3.fromRGB(245, 237, 217)

	if not p51 then
		return value116("TextLabel", {
			BackgroundTransparency = 1,
			Text = v399,
			TextSize = v400,
			TextColor3 = color34,
			Font = p51 or Enum.Font.Garamond,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextStrokeColor3 = Color3.fromRGB(8, 5, 9),
			TextStrokeTransparency = 0.18
		}, p48)
	end

	p51 = Enum.Font.Fantasy

	return value116("TextLabel", {
		BackgroundTransparency = 1,
		Text = v399,
		TextSize = v400,
		TextColor3 = color34,
		Font = p51 or Enum.Font.Garamond,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextStrokeColor3 = Color3.fromRGB(8, 5, 9),
		TextStrokeTransparency = 0.18
	}, p48)
end

t1.value88 = t1.value116("ScreenGui", {
	Name = "MacielHubDarkholdV1",
	ResetOnSpawn = false,
	IgnoreGuiInset = false,
	DisplayOrder = 100
}, game_)
t1.value119 = game:GetService("TweenService")
t1.value120 = t1.value116("Frame", {
	BackgroundColor3 = t1.value23.bg,
	BackgroundTransparency = t1.value17.Transparency,
	BorderSizePixel = 0,
	Active = true
}, t1.value88)
t1.value120.BackgroundTransparency = 1
t1.value120.ClipsDescendants = true
readfile_ = t1.value116("ViewportFrame", {
	Name = "Darkhold3D",
	BackgroundTransparency = 1,
	Size = UDim2.fromScale(1, 1),
	ZIndex = 1,
	Ambient = Color3.fromRGB(130, 35, 43),
	LightColor = Color3.fromRGB(255, 105, 95),
	LightDirection = Vector3.new(-1, -1, -1)
}, t1.value120)
t1.value121 = Instance.new("WorldModel")
t1.value121.Parent = readfile_

local Camera = Instance.new("Camera")

Camera.FieldOfView = 39
Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, 8.3), Vector3.zero)
Camera.Parent = readfile_
readfile_.CurrentCamera = Camera
Camera = function(p52, p53, p54, p55, p56)
	local Part = Instance.new("Part")

	Part.Name = p52
	Part.Anchored = true
	Part.CanCollide = false
	Part.Size = p53
	Part.CFrame = p54
	Part.Color = p55
	Part.Material = p56 or Enum.Material.SmoothPlastic
	Part.Parent = t1.value121

	return Part
end
color32 = Color3.fromRGB(13, 10, 15)
color3 = Color3.fromRGB(29, 24, 30)
t1.value122 = Color3.fromRGB(142, 103, 64)
Camera("Capa traseira", Vector3.new(8.15, 5.55, 0.26), CFrame.new(0, 0, -0.38), color32)
Camera("Pagina esquerda", Vector3.new(3.75, 4.85, 0.13), CFrame.new(-1.91, 0, 0.02), color3)
Camera("Pagina direita", Vector3.new(3.75, 4.85, 0.13), CFrame.new(1.91, 0, 0.02), color3)

local name, vector3

for i = 1, 5 do
	game_ = -0.31 + i * 0.047
	name = "Miolo de pergaminho " .. i
	vector3 = Vector3.new(7.62, 5.02, 0.045)
	game_ = CFrame.new(0, 0, game_)
	v443, v470 = Color3.fromRGB(30 + i * 3, 26 + i * 2, 30 + i * 2)
	v449 = Instance.new("Part")
	v449.Name = name
	v449.Anchored = true
	v449.CanCollide = false
	v449.Size = vector3
	v449.CFrame = game_
	v449.Color = v443
	v449.Material = v470 or Enum.Material.SmoothPlastic
	v449.Parent = t1.value121
end

local v408, cFrame2, vector32 = ipairs({ -3.98, 3.98 })

while true do
	vector32, vector3 = v408(cFrame2, vector32)

	if not vector32 then
		break
	end

	name = Vector3.new(0.24, 5.42, 0.35)
	vector3 = CFrame.new(vector3, 0, -0.18)
	color3 = Instance.new("Part")
	color3.Name = "Couro lateral"
	color3.Anchored = true
	color3.CanCollide = false
	color3.Size = name
	color3.CFrame = vector3
	color3.Color = color32
	color3.Material = Enum.Material.SmoothPlastic
	color3.Parent = t1.value121
end

for _, v in ipairs({ -2.65, 2.65 }) do
	vector3 = Vector3.new(8.1, 0.18, 0.35)
	v = CFrame.new(0, v, -0.18)
	name = Instance.new("Part")
	name.Name = "Couro horizontal"
	name.Anchored = true
	name.CanCollide = false
	name.Size = vector3
	name.CFrame = v
	name.Color = color32
	name.Material = Enum.Material.SmoothPlastic
	name.Parent = t1.value121
end

for i = 1, 0 do
	vector3 = i * 3.141592653589793 * 2 / 5 - 1.5707963267948966
	name = vector3 + 2.5132741228718345
	color32 = Vector3.new(0.028, 1.9972186842198225, 0.045)
	color3 = CFrame.new(-1.91 + (math.cos(vector3) + math.cos(name)) * 0.525, (math.sin(vector3) + math.sin(name)) * 0.525, 0.17)
	cFrame = CFrame.Angles
	color = math.sin(name) - math.sin(vector3)
	vector3 = math.cos(name) - math.cos(vector3)
	Camera("Pentagrama", color32, color3 * cFrame(0, 0, math.atan2(color, vector3) - 1.5707963267948966), t1.value122, Enum.Material.Metal)
end

Camera("Lombada", Vector3.new(0.22, 5.2, 0.45), CFrame.new(0, 0, -0.12), t1.value122, Enum.Material.Metal)
v408, cFrame2, vector32 = ipairs({ -3.7, 3.7 })

while true do
	vector32, vector3 = v408(cFrame2, vector32)

	if not vector32 then
		break
	end

	name = Vector3.new(0.1, 4.8, 0.11)
	vector3 = CFrame.new(vector3, 0, 0.11)
	color32 = t1.value122
	color3 = Enum.Material.Metal
	cFrame = Instance.new("Part")
	cFrame.Name = "Borda dourada"
	cFrame.Anchored = true
	cFrame.CanCollide = false
	cFrame.Size = name
	cFrame.CFrame = vector3
	cFrame.Color = color32
	cFrame.Material = color3 or Enum.Material.SmoothPlastic
	cFrame.Parent = t1.value121
end

for _, v in ipairs({ -3.88, 3.88 }) do
	for _, v2 in ipairs({ -2.48, 2.48 }) do
		color3 = Vector3.new(0.42, 0.13, 0.15)
		cFrame = CFrame.new(v - (v > 0 and 0.17 or -0.17), v2, 0.15)
		color = t1.value122
		game_ = Enum.Material.Metal
		v472 = Instance.new("Part")
		v472.Name = "Cantoneira de bronze"
		v472.Anchored = true
		v472.CanCollide = false
		v472.Size = color3
		v472.CFrame = cFrame
		v472.Color = color
		v472.Material = game_ or Enum.Material.SmoothPlastic
		v472.Parent = t1.value121
		v472 = Vector3.new(0.12, 0.43, 0.15)
		v2 = CFrame.new(v, v2 - (v2 > 0 and 0.16 or -0.16), 0.15)
		color3 = t1.value122
		cFrame = Enum.Material.Metal
		color = Instance.new("Part")
		color.Name = "Cantoneira vertical"
		color.Anchored = true
		color.CanCollide = false
		color.Size = v472
		color.CFrame = v2
		color.Color = color3
		color.Material = cFrame or Enum.Material.SmoothPlastic
		color.Parent = t1.value121
	end
end

local Camera2

Camera2, v408, cFrame2 = ipairs({ -3.42, 3.42 })

while true do
	cFrame2, vector32 = Camera2(v408, cFrame2)

	if not cFrame2 then
		break
	end

	for i = 1, 12 do
		color3 = -2.16 + (i - 1) * 0.39
		cFrame = Vector3.new(0.035, 0.17, 0.04)
		color3 = CFrame.new(vector32, color3, 0.115)
		color = CFrame.Angles
		game_ = i % 2 == 0 and 35 or -35
		color3 = color3 * color(0, 0, (math.rad(game_)))
		color = t1.value122
		game_ = Enum.Material.Metal
		v462 = Instance.new("Part")
		v462.Name = "Gravura da margem"
		v462.Anchored = true
		v462.CanCollide = false
		v462.Size = cFrame
		v462.CFrame = color3
		v462.Color = color
		v462.Material = game_ or Enum.Material.SmoothPlastic
		v462.Parent = t1.value121
	end
end

for _, v in ipairs({ -1.91, 1.91 }) do
	for _, v2 in ipairs({ -2.15, 2.15 }) do
		name = Vector3.new(2.9, 0.035, 0.04)
		v2 = CFrame.new(v, v2, 0.115)
		color32 = t1.value122
		color3 = Enum.Material.Metal
		cFrame = Instance.new("Part")
		cFrame.Name = "Faixa ritual"
		cFrame.Anchored = true
		cFrame.CanCollide = false
		cFrame.Size = name
		cFrame.CFrame = v2
		cFrame.Color = color32
		cFrame.Material = color3 or Enum.Material.SmoothPlastic
		cFrame.Parent = t1.value121
	end
end

for i = 1, 7 do
	cFrame2 = -2.2 + (i - 1) * 0.73
	vector32 = Vector3.new(0.29, 0.07, 0.09)
	cFrame2 = CFrame.new(0, cFrame2, 0.23)
	vector3 = t1.value122
	name = Enum.Material.Metal
	color32 = Instance.new("Part")
	color32.Name = "Costura lombada"
	color32.Anchored = true
	color32.CanCollide = false
	color32.Size = vector32
	color32.CFrame = cFrame2
	color32.Color = vector3
	color32.Material = name or Enum.Material.SmoothPlastic
	color32.Parent = t1.value121
end

t1.value123 = {}

for i = 1, 9 do
	cFrame2 = i * 3.141592653589793 * 2 / 9
	vector32 = "Runa " .. i
	vector3 = Vector3.new(0.055, 0.2, 0.05)
	cFrame2 = CFrame.new(math.cos(cFrame2) * 0.11 - 3.84, math.sin(cFrame2) * 2.15, 0.16) * CFrame.Angles(0, 0, -cFrame2)
	name = Color3.fromRGB(255, 57, 71)
	color32 = Enum.Material.Neon
	color3 = Instance.new("Part")
	color3.Name = vector32
	color3.Anchored = true
	color3.CanCollide = false
	color3.Size = vector3
	color3.CFrame = cFrame2
	color3.Color = name
	color3.Material = color32 or Enum.Material.SmoothPlastic
	color3.Parent = t1.value121
	t1.value123[#t1.value123 + 1] = color3
end

t1.value124 = Camera("Folha articulada", Vector3.new(3.73, 4.78, 0.035), CFrame.new(1.865, 0, 0.32), Color3.fromRGB(49, 40, 46))
t1.value124.Transparency = 1
t1.value125 = Instance.new("NumberValue")
t1.value125.Value = 0
t1.value126 = CFrame.new(0.02, 0, 0.34)
t1.value125:GetPropertyChangedSignal("Value"):Connect(function()
	local value124 = t1.value124
	local value126 = t1.value126
	local cFrame3 = CFrame.Angles
	local Value = t1.value125.Value

	value124.CFrame = value126 * cFrame3(0, math.rad(Value), 0) * CFrame.new(1.865, 0, 0)
end)
t1.value127 = false

function t1.value128(p57)
	if t1.value127 then
		return
	end

	local t6 = {
		Color3.fromRGB(255, 60, 70),
		Color3.fromRGB(222, 85, 240),
		Color3.fromRGB(255, 40, 40),
		Color3.fromRGB(70, 185, 245),
		Color3.fromRGB(245, 175, 65),
		Color3.fromRGB(75, 230, 135),
		Color3.fromRGB(245, 195, 70),
		Color3.fromRGB(115, 155, 255),
		Color3.fromRGB(200, 110, 255),
		Color3.fromRGB(245, 210, 165),
		Color3.fromRGB(255, 95, 120)
	}

	for _, v in ipairs(t1.value123) do
		v.Color = t6[p57] or t6[1]
	end

	t1.value125.Value = 0
	t1.value124.Transparency = 0

	local tween = t1.value119:Create(t1.value125, TweenInfo.new(0.48, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		Value = -176
	})

	tween:Play()
	tween.Completed:Once(function()
		t1.value124.Transparency = 1
		t1.value125.Value = 0
	end)
end

t1.value129 = t1.value116("TextButton", {
	Text = "",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2.fromOffset(48, 54),
	Position = UDim2.fromOffset(12, 90),
	Visible = false,
	Active = true
}, t1.value88)

local ViewportFrame = t1.value116("ViewportFrame", {
	BackgroundTransparency = 1,
	Size = UDim2.fromScale(1, 1),
	ZIndex = 1,
	Active = false,
	Ambient = Color3.fromRGB(165, 70, 68),
	LightColor = Color3.fromRGB(255, 168, 118),
	LightDirection = Vector3.new(-1, -1, -1)
}, t1.value129)

t1.value130 = Instance.new("WorldModel")
t1.value130.Parent = ViewportFrame
Camera2 = Instance.new("Camera")
Camera2.FieldOfView = 36
Camera2.CFrame = CFrame.lookAt(Vector3.new(1.2, 1.15, 16.5), Vector3.zero)
Camera2.Parent = ViewportFrame
ViewportFrame.CurrentCamera = Camera2
ViewportFrame = function(p58, p59, p60, p61, p62)
	local Part = Instance.new("Part")

	Part.Name = p58
	Part.Size = p59
	Part.CFrame = p60
	Part.Anchored = true
	Part.CanCollide = false
	Part.Color = p61
	Part.Material = p62 or Enum.Material.SmoothPlastic
	Part.Parent = t1.value130

	return Part
end
ViewportFrame("Paginas fechadas", Vector3.new(5.5, 7, 0.6), CFrame.new(0, 0, -0.22), Color3.fromRGB(183, 140, 92))
ViewportFrame("Capa de couro", Vector3.new(5.9, 7.35, 0.28), CFrame.new(0, 0, 0.24), Color3.fromRGB(38, 8, 14))
Camera2, v408, cFrame2 = ipairs({ -2.67, 2.67 })

while true do
	cFrame2, vector32 = Camera2(v408, cFrame2)

	if not cFrame2 then
		break
	end

	ViewportFrame("Filete bronze", Vector3.new(0.075, 6.7, 0.055), CFrame.new(vector32, 0, 0.405), Color3.fromRGB(157, 96, 46), Enum.Material.Metal)
end

for _, v in ipairs({ -3.36, 3.36 }) do
	ViewportFrame("Filete horizontal", Vector3.new(5.4, 0.075, 0.055), CFrame.new(0, v, 0.405), Color3.fromRGB(157, 96, 46), Enum.Material.Metal)
end

for i = 1, 24 do
	vector32 = i * 2 * 3.141592653589793 / 24
	ViewportFrame("Selo circular", Vector3.new(0.1, 0.34, 0.07), CFrame.new(math.cos(vector32) * 1.53, math.sin(vector32) * 1.53, 0.44) * CFrame.Angles(0, 0, vector32), Color3.fromRGB(178, 99, 55), Enum.Material.Metal)
end

for i = 1, 5 do
	vector32 = (i - 1) * 2 * 3.141592653589793 / 5 - 1.5707963267948966
	vector3 = vector32 + 2.5132741228718345
	name = math.cos(vector32) * 1.25
	vector32 = math.sin(vector32) * 1.25
	Camera = math.cos(vector3) * 1.25
	vector3 = math.sin(vector3) * 1.25
	color32 = Camera - name
	color3 = vector3 - vector32
	cFrame = Vector3.new
	color = color32 * color32 + color3 * color3
	ViewportFrame("Sigilo estrela", cFrame(0.09, math.sqrt(color), 0.065), CFrame.new((name + Camera) / 2, (vector32 + vector3) / 2, 0.46) * CFrame.Angles(0, 0, -math.atan2(color32, color3)), Color3.fromRGB(192, 111, 61), Enum.Material.Metal)
end

ViewportFrame("Gema central", Vector3.new(0.48, 0.48, 0.17), CFrame.new(0, 0, 0.53), Color3.fromRGB(184, 15, 35), Enum.Material.Neon)

function t1.value131(p63, p64, p65, p66)
	local AbsoluteSize = t1.value88.AbsoluteSize

	return math.clamp(p63, 8, (math.max(8, AbsoluteSize.X - p65 - 8))), math.clamp(p64, 8, (math.max(8, AbsoluteSize.Y - p66 - 8)))
end

t1.value132 = nil

function t1.value132()
	local AbsoluteSize = t1.value88.AbsoluteSize
	local v442 = AbsoluteSize.X - 24
	local v444 = math.min(600, v442)
	local v445 = math.max(1, v444)
	local v446 = AbsoluteSize.Y - 24
	local v447 = math.min(395, v446)
	local v448 = math.max(1, v447)

	t1.value120.Size = UDim2.fromOffset(v445, v448)

	return v445, v448
end
function t1.value133()
	local v450, v451 = t1.value132()
	local AbsoluteSize = t1.value88.AbsoluteSize
	local v452, v453 = t1.value131((AbsoluteSize.X - v450) / 2, (AbsoluteSize.Y - v451) / 2, v450, v451)

	t1.value120.Position = UDim2.fromOffset(v452, v453)
end

t1.value133()
readfile_.ZIndex = 1
t1.value134 = t1.value116("Frame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0.16, 0, 0.105, 0),
	Size = UDim2.new(0.68, 0, 0, 32),
	Active = true,
	ZIndex = 15
}, t1.value120)
ViewportFrame = t1.value118(t1.value134, "✦", 22, Color3.fromRGB(240, 192, 132), true)
ViewportFrame.Position = UDim2.fromOffset(12, 4)
ViewportFrame.Size = UDim2.fromOffset(35, 40)
ViewportFrame = t1.value118(t1.value134, "SKYHUB  •  V1", 14, Color3.fromRGB(252, 222, 159), true)
ViewportFrame.Position = UDim2.fromOffset(34, -5)
ViewportFrame.Size = UDim2.new(1, -112, 0, 19)
Camera2 = t1.value118(t1.value134, "D A R K H O L D", 10, Color3.fromRGB(221, 174, 103))
Camera2.Position = UDim2.fromOffset(35, 13)
Camera2.Size = UDim2.new(1, -112, 0, 16)
Camera2 = function(p67, p68)
	local TextButton = t1.value116("TextButton", {
		Text = p67,
		TextSize = 20,
		TextColor3 = Color3.fromRGB(255, 226, 170),
		BackgroundColor3 = Color3.fromRGB(63, 19, 24),
		BackgroundTransparency = 0.08,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, p68, 0, 5),
		Size = UDim2.fromOffset(28, 28),
		ZIndex = 20,
		Active = true
	}, t1.value134)

	t1.value117(TextButton, 7)

	return TextButton
end
v408 = Camera2("−", -42)
Camera2 = Camera2("×", -9)
v408.ZIndex = 30
Camera2.ZIndex = 30
cFrame2 = t1.value116("Frame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0.16, 0, 0.265, 0),
	Size = UDim2.new(0.68, 0, 0.55, 0),
	ZIndex = 4
}, t1.value120)
t1.value135 = t1.value116("ScrollingFrame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 8,
	Size = UDim2.new(0.43, 0, 1, 0),
	ScrollBarThickness = 2,
	ClipsDescendants = true,
	CanvasSize = UDim2.new()
}, cFrame2)
t1.value136 = t1.value116("UIListLayout", {
	Padding = UDim.new(0, 5)
}, t1.value135)
t1.value137 = t1.value116("ScrollingFrame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 8,
	Position = UDim2.new(0.55, 0, 0, 0),
	Size = UDim2.new(0.43, 0, 1, 0),
	ScrollBarThickness = 3,
	ClipsDescendants = true,
	CanvasSize = UDim2.new()
}, cFrame2)
t1.value138 = t1.value116("UIListLayout", {
	Padding = UDim.new(0, 8)
}, t1.value137)
cFrame2 = t1.value12
vector32 = t1.value136
cFrame2(vector32.GetPropertyChangedSignal(vector32, "AbsoluteContentSize"), function()
	t1.value135.CanvasSize = UDim2.fromOffset(0, t1.value136.AbsoluteContentSize.Y + 8)
end)
cFrame2 = t1.value12
vector32 = t1.value138
cFrame2(vector32.GetPropertyChangedSignal(vector32, "AbsoluteContentSize"), function()
	t1.value137.CanvasSize = UDim2.fromOffset(0, t1.value138.AbsoluteContentSize.Y + 12)
end)

function t1.value139(p69)
	local Frame = t1.value116("Frame", {
		BackgroundColor3 = Color3.fromRGB(29, 24, 30),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -5, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, t1.value137)

	t1.value116("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8)
	}, Frame)
	t1.value116("UIListLayout", {
		Padding = UDim.new(0, 6)
	}, Frame)
	t1.value118(Frame, "✧ " .. _G.SkyHubTranslate(p69) .. " ✧", 14, Color3.fromRGB(255, 209, 149), true).Size = UDim2.new(1, 0, 0, 22)

	return Frame
end
function t1.value140(p70, p71, p72)
	local v455 = t1.value118(p70, p71, 12, p72 or Color3.fromRGB(240, 215, 183))

	v455.Size = UDim2.new(1, 0, 0, 0)
	v455.AutomaticSize = Enum.AutomaticSize.Y

	return v455
end
function t1.value141(p73, p74, p75, p76, p77)
	local Frame = t1.value116("Frame", {
		BackgroundColor3 = Color3.fromRGB(38, 31, 39),
		BackgroundTransparency = 1,
		ZIndex = 9,
		Size = UDim2.new(1, 0, 0, 34)
	}, p73)

	t1.value117(Frame, 6)

	local v457 = t1.value118(Frame, "✦ " .. _G.SkyHubTranslate(p74), 12, Color3.fromRGB(246, 217, 175))

	v457.Position = UDim2.fromOffset(8, 0)
	v457.Size = UDim2.new(1, -61, 1, 0)

	local TextButton = t1.value116("TextButton", {
		Text = "",
		ZIndex = 11,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -7, 0.5, 0),
		Size = UDim2.fromOffset(40, 21)
	}, Frame)

	t1.value117(TextButton, 11)

	local Frame2 = t1.value116("Frame", {
		BackgroundColor3 = t1.value23.white,
		Size = UDim2.fromOffset(15, 15)
	}, TextButton)

	t1.value117(Frame2, 9)

	local function v460()
		local v461 = TextButton
		local color33 = p75[p76]

		if not color33 then
			v461.BackgroundColor3 = color33 or Color3.fromRGB(65, 65, 75)
			Frame2.Position = UDim2.fromOffset(p75[p76] and 22 or 3, 3)

			return
		end

		color33 = Color3.fromRGB(196, 150, 69)
		v461.BackgroundColor3 = color33 or Color3.fromRGB(65, 65, 75)
		Frame2.Position = UDim2.fromOffset(p75[p76] and 22 or 3, 3)
	end

	t1.value12(TextButton.MouseButton1Click, function()
		p75[p76] = not p75[p76]

		if not p77 then
			v460()

			return
		end

		p77(p75[p76])
		v460()
	end, t1.value10)
	v460()

	return Frame
end
function t1.value142(p78, p79, p80)
	local TextButton = t1.value116("TextButton", {
		ZIndex = 10,
		Text = "  " .. _G.SkyHubTranslate(p79) .. "   ›",
		TextColor3 = Color3.fromRGB(250, 239, 207),
		TextSize = 14,
		Font = Enum.Font.Garamond,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(38, 31, 39),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34)
	}, p78)

	t1.value117(TextButton, 6)
	t1.value12(TextButton.MouseButton1Click, p80, t1.value10)

	return TextButton
end
function t1.value143(p81, p82, p83, p84, p85, p86, p87)
	local Frame = t1.value116("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 78)
	}, p81)
	local v465 = t1.value118(Frame, "", 12)

	v465.Position = UDim2.fromOffset(8, 2)
	v465.Size = UDim2.new(1, -16, 0, 21)

	local TextButton = t1.value116("TextButton", {
		Text = "−",
		TextSize = 14,
		TextColor3 = t1.value23.white,
		BackgroundColor3 = Color3.fromRGB(65, 60, 82),
		Position = UDim2.fromOffset(7, 35),
		Size = UDim2.fromOffset(23, 26),
		ZIndex = 12
	}, Frame)

	t1.value117(TextButton, 7)

	local TextButton2 = t1.value116("TextButton", {
		Text = "+",
		TextSize = 14,
		TextColor3 = t1.value23.white,
		BackgroundColor3 = Color3.fromRGB(65, 60, 82),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -7, 0, 35),
		Size = UDim2.fromOffset(23, 26),
		ZIndex = 12
	}, Frame)

	t1.value117(TextButton2, 7)

	local TextButton3 = t1.value116("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = 12,
		Position = UDim2.fromOffset(36, 29),
		Size = UDim2.new(1, -72, 0, 40)
	}, Frame)
	local Frame2 = t1.value116("Frame", {
		BackgroundColor3 = Color3.fromRGB(65, 60, 82),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.5, -4),
		Size = UDim2.new(1, 0, 0, 8)
	}, TextButton3)

	t1.value117(Frame2, 5)

	local Frame3 = t1.value116("Frame", {
		BackgroundColor3 = t1.value23.gold,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0, 1)
	}, Frame2)

	t1.value117(Frame3, 5)

	local Frame4 = t1.value116("Frame", {
		BackgroundColor3 = t1.value23.white,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(18, 18),
		ZIndex = 13
	}, Frame2)

	t1.value117(Frame4, 10)

	local v473 = 10 ^ (tonumber(p86:match("%%%.(%d+)f")) or 0)
	local v474 = 1 / v473
	local u475 = tonumber(p85) or p83
	local u476 = nil
	local u477 = false

	local function v478(p88)
		local v479 = p83
		local v480 = p84
		local v481 = math.clamp(p88, v479, v480) * v473 + 0.5

		u475 = math.floor(v481) / v473

		local v482 = u475
		local v483 = p83
		local v484 = p84

		u475 = math.clamp(v482, v483, v484)

		local v485 = (u475 - p83) / (p84 - p83)
		local v486 = math.clamp(v485, 0, 1)

		Frame3.Size = UDim2.fromScale(v486, 1)
		Frame4.Position = UDim2.fromScale(v486, 0.5)
		v465.Text = _G.SkyHubTranslate(p82) .. ": " .. string.format(p86, u475)
		p87(u475)
	end

	t1.value12(TextButton3.InputBegan, function(p89)
		if p89.UserInputType == Enum.UserInputType.Touch then
			if u476 then
				return
			else
				u476 = p89

				local X = p89.Position.X

				if TextButton3.AbsoluteSize.X <= 0 then
					return
				else
					local v487 = v478
					local v488 = p83
					local v489 = p84 - p83
					local v490 = (X - TextButton3.AbsolutePosition.X) / TextButton3.AbsoluteSize.X

					v487(v488 + v489 * math.clamp(v490, 0, 1))

					return
				end
			end
		end

		if p89.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		u477 = true

		local X = p89.Position.X

		if TextButton3.AbsoluteSize.X <= 0 then
			return
		end

		local v492 = v478
		local v493 = p83
		local v494 = p84 - p83
		local v495 = (X - TextButton3.AbsolutePosition.X) / TextButton3.AbsoluteSize.X

		v492(v493 + v494 * math.clamp(v495, 0, 1))
	end, t1.value10)
	t1.value12(t1.value3.InputChanged, function(p90)
		if not Frame.Parent then
			return
		end

		local v496 = u476

		if v496 then
			v496 = p90 == u476
		end

		if v496 then
			local X = p90.Position.X

			if TextButton3.AbsoluteSize.X <= 0 then
				return
			else
				local v498 = v478
				local v499 = p83
				local v500 = p84 - p83
				local v501 = (X - TextButton3.AbsolutePosition.X) / TextButton3.AbsoluteSize.X

				v498(v499 + v500 * math.clamp(v501, 0, 1))

				return
			end
		end

		local v502 = u477

		if v502 then
			v502 = p90.UserInputType == Enum.UserInputType.MouseMovement
		end

		if not v502 then
			return
		end

		local X = p90.Position.X

		if TextButton3.AbsoluteSize.X <= 0 then
			return
		end

		local v504 = v478
		local v505 = p83
		local v506 = p84 - p83
		local v507 = (X - TextButton3.AbsolutePosition.X) / TextButton3.AbsoluteSize.X

		v504(v505 + v506 * math.clamp(v507, 0, 1))
	end, t1.value10)
	t1.value12(t1.value3.InputEnded, function(p91)
		local _ = p91 == u476
		local _ = p91.UserInputType == Enum.UserInputType.MouseButton1
	end, t1.value10)
	t1.value12(TextButton.Activated, function()
		v478(u475 - v474)
	end, t1.value10)
	t1.value12(TextButton2.Activated, function()
		v478(u475 + v474)
	end, t1.value10)
	v478(u475)
end

t1.value144 = {
	"Inicio",
	"ESP",
	"Combate",
	"Movimento",
	"Jogador",
	"Farms",
	"Teleporte",
	"Servidores",
	"Config.",
	"Info",
	"Creditos"
}
t1.value145 = {}
t1.value146 = nil
t1.value147 = nil
t1.value148 = nil
t1.value148 = nil

function t1.value149()
	t1.value13(t1.value10)
	t1.value147 = nil
	t1.value148 = nil

	for _, child in ipairs(t1.value137:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
end
function t1.value150()
	local v512 = t1.value139("ARTIFACT ESP")

	t1.value140(v512, "ESP", t1.value23.white)
	t1.value141(v512, "Ativar Artifact ESP", t1.value14, "ESP", function(p92)
		if p92 then
			t1.value103()

			return
		end

		t1.value100()
		t1.value103()
	end)

	local filtros = t1.value139("FILTROS")

	t1.value141(filtros, "Power Stone", t1.value14, "Power")
	t1.value141(filtros, "Space Stone", t1.value14, "Space")
	t1.value141(filtros, "Time Stone", t1.value14, "Time")
	t1.value141(filtros, "Darkhold", t1.value14, "Darkhold")

	local visualizacao = t1.value139("VISUALIZACAO")

	t1.value141(visualizacao, "Highlight", t1.value14, "Highlight")
	t1.value141(visualizacao, "Mostrar nomes", t1.value14, "Labels")
	t1.value141(visualizacao, "Mostrar distancia", t1.value14, "Distance")

	local v515 = t1.value139("PERSONALIZACAO DO ESP")

	t1.value143(v515, "Tamanho nome artefato", 7, 24, t1.value19.ArtifactSize, "%.0f", function(p93)
		local value19 = t1.value19
		local v517 = p93 + 0.5

		value19.ArtifactSize = math.floor(v517)
	end)
	t1.value143(v515, "Altura nome artefato", 1, 7, t1.value19.ArtifactHeight, "%.1f", function(p94)
		t1.value19.ArtifactHeight = p94
	end)
	t1.value143(v515, "Tamanho nome jogador", 7, 24, t1.value19.PlayerSize, "%.0f", function(p95)
		local value19 = t1.value19
		local v519 = p95 + 0.5

		value19.PlayerSize = math.floor(v519)
	end)
	t1.value143(v515, "Altura nome jogador", 1, 7, t1.value19.PlayerHeight, "%.1f", function(p96)
		t1.value19.PlayerHeight = p96
	end)
	t1.value143(v515, "Altura escudo isolado", 1, 7, t1.value19.ShieldHeight, "%.1f", function(p97)
		t1.value19.ShieldHeight = p97
	end)

	local v520 = t1.value139("PLAYER ESP - PERSONALIZACAO AVANCADA")

	t1.value141(v520, "Contorno do personagem", t1.value19, "PlayerHighlight", t1.value107)
	t1.value141(v520, "Caixa 2D", t1.value19, "PlayerBox", t1.value107)
	t1.value141(v520, "Mostrar nome do jogador", t1.value19, "PlayerNames", t1.value107)
	t1.value141(v520, "Mostrar distancia em studs", t1.value19, "PlayerDistanceLabel", t1.value107)
	t1.value141(v520, "Mostrar atraves de paredes", t1.value19, "PlayerThroughWalls", t1.value107)
	t1.value143(v520, "Distancia maxima ESP", 50, 3000, t1.value19.PlayerDistance, "%.0f", function(p98)
		t1.value19.PlayerDistance = p98
		t1.value107()
	end)
	t1.value143(v520, "Transparencia preenchimento", 0, 1, t1.value19.PlayerFill, "%.2f", function(p99)
		t1.value19.PlayerFill = p99
		t1.value107()
	end)
	t1.value143(v520, "Transparencia contorno", 0, 1, t1.value19.PlayerOutline, "%.2f", function(p100)
		t1.value19.PlayerOutline = p100
		t1.value107()
	end)
	t1.value143(v520, "Contorno do texto", 0, 1, t1.value19.PlayerStroke, "%.2f", function(p101)
		t1.value19.PlayerStroke = p101
		t1.value107()
	end)

	local function v521(p102, p103)
		local v522 = nil

		local function v523()
			local n2 = 1

			for i, v in ipairs(t1.value21) do
				if v == t1.value19[v522] then
					n2 = i

					break
				end
			end

			t1.value19[v522] = t1.value21[n2 % #t1.value21 + 1]
			t1.value146(2)
			t1.value107()
		end

		v522 = p102
		t1.value142(v520, _G.SkyHubTranslate(p103) .. ": " .. _G.SkyHubTranslate(t1.value19[v522]) .. " (" .. _G.SkyHubTranslate("trocar") .. ")", v523)
	end

	v521("PlayerColor", "Cor do preenchimento")
	v521("PlayerOutlineColor", "Cor do contorno/caixa")
	v521("PlayerTextColor", "Cor dos nomes")
	t1.value143(v520, "Transparencia artefatos", 0, 1, t1.value19.ArtifactFill, "%.2f", function(p104)
		t1.value19.ArtifactFill = p104
	end)
	t1.value143(v520, "Contorno artefatos", 0, 1, t1.value19.ArtifactOutline, "%.2f", function(p105)
		t1.value19.ArtifactOutline = p105
	end)
	t1.value140(v515, "Ajustes aplicados em tempo real. Salve em Config. para manter.")

	local alcance = t1.value139("ALCANCE")

	t1.value140(alcance, "Sem limite para personagens carregados.")
	t1.value142(alcance, "Atualizar Artifact ESP", t1.value103)

	local v528 = t1.value139("SHIELD DETECTOR")

	t1.value141(v528, "Ativar Shield Detector", t1.value14, "ShieldDetector", function(p106)
		if p106 then
			return
		end

		t1.value90()
		t1.value93 = 0
	end)
	t1.value148 = t1.value140(v528, "Escudos visiveis: " .. t1.value93, t1.value23.white)
	t1.value140(v528, "500 studs | Escudo 11x13 acima da cabeca | Oculto por paredes.")

	local v529 = t1.value139("PLAYER ESP")

	t1.value141(v529, "Ativar Player ESP", t1.value14, "PlayerESP", function(p107)
		if p107 then
			t1.value107()
		else
			t1.value105()
		end

		t1.value146(2)
	end)

	if not t1.value14.PlayerESP then
		t1.value140(v529, "Ative para abrir a lista de jogadores.")

		return
	end

	local v530 = nil
	local t7 = {
		value = false
	}
	local u532 = nil

	v530 = function()
		local Parent = u532

		if Parent then
			Parent = u532.Parent
		end

		if Parent then
			u532:Destroy()
		end

		if not t7.value then
			return
		end

		u532 = t1.value139("SELECIONAR JOGADORES")

		local ipairs_ = ipairs
		local value1 = t1.value1
		local t8 = {}

		for _, player in ipairs_(value1.GetPlayers(value1)) do
			if player ~= t1.value7 then
				table.insert(t8, player)
			end
		end

		table.sort(t8, function(p108, p109)
			return p108.Name:lower() < p109.Name:lower()
		end)
		t1.value140(u532, "Jogadores encontrados: " .. #t8, t1.value23.white)
		t1.value142(u532, "ATUALIZAR JOGADORES", function()
			v530()
		end)

		local ipairs_2 = ipairs
		local v540 = false

		for _, v in ipairs_2(t8) do
			if not t1.value89[v] then
				ipairs_2 = true
				v540 = true

				break
			end
		end

		t1.value142(u532, _G.SkyHubTranslate(v540 and "ATIVAR ESP TODOS" or "DESATIVAR TODOS"), function()
			for _, v in ipairs(t8) do
				t1.value89[v] = v540
				t1.value106(v)
			end

			v530()
		end)

		for _, v in ipairs(t8) do
			t1.value142(u532, (t1.value89[v] and "[ON] " or "[OFF] ") .. v.DisplayName .. "  @" .. v.Name, function()
				local v547 = t1.value89[v]

				t1.value89[v] = not v547
				t1.value106(v)
				v530()
			end)
		end
	end
	t1.value142(v529, "ABRIR / FECHAR LISTA DE JOGADORES", function()
		t7.value = not t7.value
		v530()
	end)
	t1.value140(v529, "Cores, caixa 2D, distancia, nomes e transparencias ajustaveis.")
end
function t1.value151()
	local aimbot = t1.value139("AIMBOT")

	t1.value141(aimbot, "Ativar Aimbot", t1.value14, "Aimbot", function(p110)
		t1.value67()

		if not p110 then
			t1.value146(3)

			return
		end

		t1.value64 = os.clock() + 0.35
		t1.value146(3)
	end)

	if t1.value14.Aimbot then
		t1.value147 = t1.value140(aimbot, "Alvo: nenhum", t1.value23.red)

		local v549 = t1.value139("AJUSTES DO AIMBOT")

		t1.value143(v549, "FOV", 50, 500, t1.value15.FOV, "%.0f", function(p111)
			t1.value15.FOV = p111
		end)
		t1.value143(v549, "Forca", 0.05, 1, t1.value15.Strength, "%.2f", function(p112)
			t1.value15.Strength = p112
		end)
		t1.value143(v549, "Prediction", 0, 0.5, t1.value15.Prediction, "%.3f", function(p113)
			t1.value15.Prediction = p113
		end)
		t1.value143(v549, "Centralizacao Y da camera (pixels)", -150, 150, t1.value15.CenterY, "%.0f", function(p114)
			t1.value15.CenterY = p114
		end)
		t1.value143(v549, "Liberdade", 0.1, 1, t1.value15.Freedom, "%.2f", function(p115)
			t1.value15.Freedom = p115
		end)
		t1.value143(v549, "Distancia maxima", 30, 500, t1.value15.MaxDistance, "%.0f", function(p116)
			t1.value15.MaxDistance = p116
		end)
		t1.value143(v549, "Prioridade proximidade", 0, 1, t1.value15.DistanceWeight, "%.2f", function(p117)
			t1.value15.DistanceWeight = p117
		end)
		t1.value141(v549, "Ignorar amigos", t1.value14, "IgnoreFriends")
	end

	local protecoes = t1.value139("PROTECOES")

	t1.value141(protecoes, "Anti-Ragdoll", t1.value14, "AntiRagdoll", function(p118)
		if p118 then
			t1.value61()
		else
			t1.value60(t1.value56)
		end
	end)
	t1.value140(protecoes, "Anti-Ragdoll e recuperacao automatica.")
	t1.value141(protecoes, "Anti-Ability Lock", t1.value14, "AntiAbilityLock", function(p119)
		if not p119 then
			return
		end

		t1.value62()
	end)
	t1.value140(protecoes, "Anti-Stun experimental.")
end
function t1.value152()
	local movimento = t1.value139("MOVIMENTO")

	t1.value141(movimento, "Noclip", t1.value14, "Noclip", function(p120)
		if p120 then
			return
		end

		t1.value79()
	end)
	t1.value141(movimento, "WalkSpeed", t1.value14, "WalkSpeed", function(p121)
		local v552 = not p121

		if v552 then
			v552 = t1.value71

			if v552 then
				v552 = t1.value71.Parent

				if v552 then
					v552 = t1.value72
				end
			end
		end

		if not v552 then
			t1.value146(4)

			return
		end

		t1.value71.WalkSpeed = t1.value72
		t1.value146(4)
	end)

	if t1.value14.WalkSpeed then
		t1.value143(movimento, "Velocidade", 16, 300, t1.value16.Speed, "%.0f", function(p122)
			t1.value16.Speed = p122
		end)
	end

	t1.value141(movimento, "Jump", t1.value14, "Jump", function(p123)
		local v553 = not p123

		if v553 then
			v553 = t1.value71

			if v553 then
				v553 = t1.value71.Parent
			end
		end

		if not v553 then
			t1.value146(4)

			return
		end

		if t1.value73 then
			t1.value71.JumpPower = t1.value73
		end

		if not t1.value74 then
			t1.value146(4)

			return
		end

		t1.value71.JumpHeight = t1.value74
		t1.value146(4)
	end)

	if t1.value14.Jump then
		t1.value143(movimento, "Forca do pulo", 50, 300, t1.value16.Jump, "%.0f", function(p124)
			t1.value16.Jump = p124
		end)
	end

	local v554 = t1.value139("FLY SPEED")

	t1.value141(v554, "Ativar Fly Speed", t1.value14, "FlySpeed", function()
		t1.value77()
	end)
	t1.value143(v554, "Velocidade de voo", 1, 300, t1.value16.Fly, "%.0f", function(p125)
		local value16 = t1.value16
		local v556 = p125 + 0.5

		value16.Fly = math.floor(v556)
	end)
	t1.value140(v554, "Controle pela camera e joystick. Funciona enquanto estiver no ar.")
end
function t1.value153()
	local v557 = t1.value139("AUTO FARM DE BAUS")
	local v558 = t1.value140(v557, t1.value55, t1.value23.white)

	t1.value141(v557, "Abrir Auto Farm", t1.value14, "AutoFarm", function(p126)
		if not p126 then
			v234()
			v558.Text = _G.SkyHubTranslate(t1.value55)

			return
		end

		v558.Text = _G.SkyHubTranslate("Carregando...")
		task.spawn(function()
			local _, v560 = v228()

			if not v558.Parent then
				return
			end

			v558.Text = _G.SkyHubTranslate(v560)
		end)
	end)
	t1.value140(v557, "Abre menu independente do SkyHub.")
	t1.value140(v557, "Use o menu do Farm para iniciar, parar e minimizar.")

	local v561 = t1.value139("CONTROLE DO MODULO")

	t1.value142(v561, "ABRIR MENU DO FARM", function()
		task.spawn(function()
			local _, v563 = v228()

			if not v558.Parent then
				return
			end

			v558.Text = _G.SkyHubTranslate(v563)
		end)
	end)
	t1.value140(v561, "Server Hop e Rejoin estao na aba Servidores.")
end
function t1.value154()
	local teleportes = t1.value139("TELEPORTES")
	local v565 = t1.value140(teleportes, "Escolha um destino", t1.value23.white)

	for _, v in ipairs(t1.value50) do
		t1.value142(teleportes, "TP | " .. v.name, function()
			local v568 = v565
			local SkyHubTranslate = _G.SkyHubTranslate
			local v570 = t1.value31(v.cf)

			if not v570 then
				v568.Text = SkyHubTranslate(v570 or "Personagem indisponivel")

				return
			end

			v570 = "TP solicitado: " .. v.name
			v568.Text = SkyHubTranslate(v570 or "Personagem indisponivel")
		end)
	end

	local v571 = t1.value139("SPAWN POINTS")

	t1.value142(v571, "TP | SPAWN ALEATORIO", function()
		local v572, v573 = t1.value35()

		v565.Text = _G.SkyHubTranslate((v572 and "Teleportado! " or "Falha: ") .. v573)
	end)
	t1.value140(v571, "Seleciona um SpawnLocation diferente do anterior, quando possivel.")

	local v574 = t1.value139("AUTO STONE PICKUP")
	local v575 = t1.value140(v574, "Selecao: " .. _G.SkyHubTranslate(t1.value18.Selection) .. " | " .. _G.SkyHubTranslate(t1.value41), t1.value23.white)

	t1.value141(v574, "Ativar Auto Stone Pickup", t1.value14, "AutoStone", function(p127)
		if p127 then
			t1.value41 = "Monitoramento iniciado"
		else
			t1.value41 = "Monitoramento pausado"
		end
	end)

	for _, v in ipairs({
		"PODER",
		"ESPACO",
		"TEMPO",
		"TODAS"
	}) do
		t1.value142(v574, (t1.value18.Selection == v and "[X] " or false or "[ ] ") .. _G.SkyHubTranslate(v), function()
			t1.value18.Selection = v

			if not t1.value8 then
				return
			end

			t1.value146(7)
		end)
	end

	t1.value140(v574, "Busca joias soltas estaveis, teleporta e tenta usar ProximityPrompt.")
	t1.value140(v574, "Coleta automatica exige fireproximityprompt disponivel.")
	task.spawn(function()
		while true do
			local value8 = t1.value8

			if value8 then
				value8 = v575.Parent
			end

			if not value8 then
				return
			end

			v575.Text = _G.SkyHubTranslate("Selecao: " .. _G.SkyHubTranslate(t1.value18.Selection) .. " | " .. _G.SkyHubTranslate(t1.value14.AutoStone and "ATIVO" or "PAUSADO") .. "\n" .. _G.SkyHubTranslate(t1.value41))
			task.wait(0.3)
		end
	end)
end
function t1.value155()
	local servidores = t1.value139("SERVIDORES")
	local v580 = t1.value140(servidores, t1.value47, t1.value23.white)

	t1.value142(servidores, "REJOIN GAME", function()
		local value48 = t1.value48

		v580.Text = _G.SkyHubTranslate("Consultando...")
		task.spawn(function()
			local v582, erro = value48()

			if not v580.Parent then
				return
			end

			v580.Text = _G.SkyHubTranslate(v582 and "OK: " or "ERRO: " .. erro)
		end)
	end)
	t1.value142(servidores, "SERVER HOP", function()
		local function v584()
			return v236(false)
		end

		v580.Text = _G.SkyHubTranslate("Consultando...")
		task.spawn(function()
			local v585, erro = v584()

			if not v580.Parent then
				return
			end

			v580.Text = _G.SkyHubTranslate(v585 and "OK: " or "ERRO: " .. erro)
		end)
	end)
	t1.value142(servidores, "ENTRAR NO MENOR SERVIDOR", function()
		local function v587()
			return v236(true)
		end

		v580.Text = _G.SkyHubTranslate("Consultando...")
		task.spawn(function()
			local v588, erro = v587()

			if not v580.Parent then
				return
			end

			v580.Text = _G.SkyHubTranslate(v588 and "OK: " or "ERRO: " .. erro)
		end)
	end)
	t1.value140(servidores, "Menor servidor entre os servidores publicos consultados; nao garante o menor de todos.")
	t1.value140(servidores, "A listagem depende de HTTP acessivel e das permissoes de teleporte.")
end
function t1.value156()
	local jogador = t1.value139("JOGADOR")

	t1.value142(jogador, "Resetar personagem", function()
		local _, v592 = t1.value29()

		if not v592 then
			return
		end

		v592.Health = 0
	end)

	local v593 = t1.value139("RECUPERACAO DE VIDA")

	t1.value140(v593, t1.value108.message, t1.value23.white)
	t1.value142(v593, "RECUPERAR VIDA", t1.value112)
	t1.value142(v593, "CANCELAR SEQUENCIA", t1.value111)
	t1.value140(v593, "Esconderijo > Reset > Respawn > Voltar a joia > 5s > Spawn aleatorio.")
	t1.value140(v593, "A recuperacao depende do respawn permitido pelo servidor.")
end
function t1.value157()
	local v594 = t1.value139("GUIA DO SKYHUB")

	t1.value140(v594, "Criado por adryanrz.", t1.value23.gold)
	t1.value140(v594, "Selecione uma aba na pagina esquerda. Toque nos interruptores para ativar ou desativar funcoes. Barras ajustam valores; Config. permite salvar preferencias.")

	local v595 = t1.value139("ESP E DETECCAO")

	t1.value140(v595, "Artifact ESP: localiza os artefatos selecionados e permite mostrar nomes, distancia e destaque visual.")
	t1.value140(v595, "Player ESP: identifica jogadores, com lista individual, caixa 2D, contorno, nomes e distancia. Personalize cores, alcance e transparencias.")
	t1.value140(v595, "Shield Detector: indica escudos detectados dentro do alcance configurado.")

	local combate = t1.value139("COMBATE")

	t1.value140(combate, "Aimbot: auxilia o acompanhamento de alvos pela camera. FOV controla a area de busca; Forca, Prediction e Liberdade ajustam o acompanhamento.")
	t1.value140(combate, "Centralizar mira X/Y e Ajuste vertical corrigem o alinhamento. Distancia maxima limita os alvos; Ignorar amigos e mesmo time aplicam filtros.")
	t1.value140(combate, "Anti-Ragdoll tenta evitar quedas; Anti-Ability Lock tenta remover restricoes de habilidade. Podem depender do jogo.")

	local movimento = t1.value139("MOVIMENTO")

	t1.value140(movimento, "Noclip desativa colisao local; WalkSpeed ajusta a velocidade; Jump ajusta o pulo; Fly Speed permite voo com camera e joystick.")

	local farms = t1.value139("FARMS")

	t1.value140(farms, "Auto Farm de Baus abre um modulo independente. Use o menu desse modulo para iniciar, parar ou minimizar.")

	local v599 = t1.value139("TELEPORTE E JOIAS")

	t1.value140(v599, "Teleportes oferecem destinos disponiveis e spawn aleatorio. Auto Stone Pickup procura joias selecionadas e tenta interagir com elas.")

	local servidores = t1.value139("SERVIDORES")

	t1.value140(servidores, "Rejoin reconecta ao jogo. Server Hop procura outro servidor. Menor servidor consulta servidores publicos disponiveis.")

	local jogador = t1.value139("JOGADOR")

	t1.value140(jogador, "Resetar personagem reinicia o personagem. Recuperacao de vida executa uma sequencia de reset e retorno, se o servidor permitir.")

	local configuracoes = t1.value139("CONFIGURACOES")

	t1.value140(configuracoes, "Ajuste transparencia, salve e carregue preferencias. Carregar automaticamente tenta restaurar a configuracao na proxima execucao.")

	local importante = t1.value139("IMPORTANTE")

	t1.value140(importante, "Algumas funcoes dependem de permissoes, recursos locais e regras do servidor. Alteracoes podem nao funcionar em todos os jogos.")
end

t1.value158 = {
	{
		{
			50,
			8,
			50,
			90
		},
		{
			25,
			28,
			75,
			28
		},
		{
			25,
			72,
			75,
			72
		},
		{
			30,
			28,
			50,
			8
		},
		{
			70,
			28,
			50,
			8
		},
		{
			30,
			72,
			50,
			90
		},
		{
			70,
			72,
			50,
			90
		}
	},
	{
		{
			12,
			50,
			30,
			32
		},
		{
			30,
			32,
			50,
			24
		},
		{
			50,
			24,
			70,
			32
		},
		{
			70,
			32,
			88,
			50
		},
		{
			88,
			50,
			70,
			68
		},
		{
			70,
			68,
			50,
			76
		},
		{
			50,
			76,
			30,
			68
		},
		{
			30,
			68,
			12,
			50
		}
	},
	{
		{
			20,
			15,
			80,
			85
		},
		{
			80,
			15,
			20,
			85
		},
		{
			17,
			30,
			32,
			15
		},
		{
			68,
			15,
			83,
			30
		},
		{
			18,
			70,
			30,
			82
		},
		{
			70,
			82,
			82,
			70
		}
	},
	{
		{
			15,
			30,
			70,
			30
		},
		{
			70,
			30,
			85,
			40
		},
		{
			85,
			40,
			70,
			50
		},
		{
			20,
			60,
			70,
			60
		},
		{
			70,
			60,
			82,
			70
		},
		{
			82,
			70,
			65,
			82
		}
	},
	{
		{
			50,
			25,
			50,
			68
		},
		{
			50,
			39,
			24,
			57
		},
		{
			50,
			39,
			76,
			57
		},
		{
			50,
			68,
			32,
			88
		},
		{
			50,
			68,
			68,
			88
		}
	},
	{
		{
			50,
			18,
			72,
			32
		},
		{
			72,
			32,
			82,
			54
		},
		{
			82,
			54,
			68,
			80
		},
		{
			68,
			80,
			32,
			80
		},
		{
			32,
			80,
			18,
			54
		},
		{
			18,
			54,
			28,
			32
		},
		{
			28,
			32,
			50,
			18
		},
		{
			50,
			30,
			50,
			73
		}
	},
	{
		{
			50,
			12,
			77,
			30
		},
		{
			77,
			30,
			85,
			58
		},
		{
			85,
			58,
			50,
			90
		},
		{
			50,
			90,
			15,
			58
		},
		{
			15,
			58,
			23,
			30
		},
		{
			23,
			30,
			50,
			12
		},
		{
			50,
			27,
			65,
			50
		},
		{
			65,
			50,
			50,
			73
		},
		{
			50,
			73,
			35,
			50
		},
		{
			35,
			50,
			50,
			27
		}
	},
	{
		{
			18,
			24,
			50,
			15
		},
		{
			50,
			15,
			82,
			24
		},
		{
			18,
			24,
			28,
			76
		},
		{
			82,
			24,
			72,
			76
		},
		{
			28,
			76,
			72,
			76
		},
		{
			18,
			24,
			72,
			76
		},
		{
			82,
			24,
			28,
			76
		}
	},
	{
		{
			50,
			15,
			66,
			26
		},
		{
			66,
			26,
			82,
			45
		},
		{
			82,
			45,
			73,
			68
		},
		{
			73,
			68,
			50,
			85
		},
		{
			50,
			85,
			27,
			68
		},
		{
			27,
			68,
			18,
			45
		},
		{
			18,
			45,
			34,
			26
		},
		{
			34,
			26,
			50,
			15
		}
	},
	{
		{
			30,
			15,
			70,
			15
		},
		{
			70,
			15,
			70,
			85
		},
		{
			70,
			85,
			30,
			85
		},
		{
			30,
			85,
			30,
			15
		},
		{
			39,
			34,
			61,
			34
		},
		{
			39,
			49,
			61,
			49
		},
		{
			39,
			64,
			61,
			64
		}
	},
	{
		{
			50,
			12,
			72,
			36
		},
		{
			72,
			36,
			86,
			50
		},
		{
			86,
			50,
			72,
			64
		},
		{
			72,
			64,
			50,
			88
		},
		{
			50,
			88,
			28,
			64
		},
		{
			28,
			64,
			14,
			50
		},
		{
			14,
			50,
			28,
			36
		},
		{
			28,
			36,
			50,
			12
		}
	}
}

function t1.value159(p128)
	local Frame = t1.value116("Frame", {
		Name = "DarkholdEngraving",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -18, 0, 86),
		LayoutOrder = -100,
		ZIndex = 9,
		ClipsDescendants = true
	}, t1.value137)
	local v605 = t1.value158[p128] or t1.value158[1]
	local color33 = Color3.fromRGB(193, 151, 109)

	local function v607(p129, p130, p131, p132)
		local v608 = p131 - p129
		local v609 = p132 - p130
		local v610 = v608 * v608 + v609 * v609
		local v611 = math.sqrt(v610)
		local value116 = t1.value116
		local v613 = color33
		local vector2 = Vector2.new(0.5, 0.5)
		local uDim2 = UDim2.new((p129 + p131) / 200, 0, (p130 + p132) / 200, 0)
		local uDim22 = UDim2.new(v611 / 100, 0, 0, 2)
		local v617 = math.atan2(v609, v608)

		return value116("Frame", {
			Name = "InkStroke",
			BorderSizePixel = 0,
			BackgroundColor3 = v613,
			BackgroundTransparency = 0.12,
			AnchorPoint = vector2,
			ZIndex = 10,
			Position = uDim2,
			Size = uDim22,
			Rotation = math.deg(v617)
		}, Frame)
	end

	for _, v in ipairs(v605) do
		v607(v[1], v[2], v[3], v[4])
	end

	if not (p128 == 2 and true or p128 == 9) then
		return
	end

	local Frame2 = t1.value116("Frame", {
		Name = "RitualSeal",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(27, 27),
		ZIndex = 10
	}, Frame)

	t1.value116("UICorner", {
		CornerRadius = UDim.new(1, 0)
	}, Frame2)
	t1.value116("UIStroke", {
		Color = color33,
		Thickness = 2
	}, Frame2)

	if p128 ~= 2 then
		return
	end

	local Frame3 = t1.value116("Frame", {
		BackgroundColor3 = color33,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(9, 9),
		ZIndex = 11
	}, Frame2)

	t1.value116("UICorner", {
		CornerRadius = UDim.new(1, 0)
	}, Frame3)
end
function t1.value146(p133)
	t1.value128(p133)
	t1.value149()
	t1.value159(p133)

	local v622, v623, v624 = ipairs(t1.value145)

	while true do
		local v625

		v624, v625 = v622(v623, v624)

		if not v624 then
			break
		end

		v625.BackgroundTransparency = 1
		v625.TextColor3 = v624 == p133 and Color3.fromRGB(255, 222, 142) or Color3.fromRGB(245, 237, 217)
	end

	if p133 == 1 then
		local v626 = t1.value139("BEM-VINDO")

		t1.value140(v626, "SKYHUB V1 | DARKHOLD", t1.value23.gold)
		t1.value140(v626, "Criado por adryanrz.")
		t1.value140(v626, "Marvel Omega | PC e Mobile")
		t1.value140(v626, "Use as abas a esquerda para acessar as funcoes. Consulte Info para aprender a usar cada recurso.")

		local v627 = t1.value139("REGISTRO DE ATUALIZACOES")

		t1.value140(v627, "V1 - Lancamento inicial.", t1.value23.gold)
		t1.value140(v627, "Nenhuma atualizacao adicional registrada.")
	elseif p133 == 2 then
		t1.value150()
	elseif p133 == 3 then
		t1.value151()
	elseif p133 == 4 then
		t1.value152()
	elseif p133 == 5 then
		t1.value156()
	elseif p133 == 6 then
		t1.value153()
	elseif p133 == 7 then
		t1.value154()
	elseif p133 == 8 then
		t1.value155()
	elseif p133 == 9 then
		local configuracoes = t1.value139("CONFIGURACOES")

		t1.value143(configuracoes, "Transparencia", 0, 0.8, t1.value17.Transparency, "%.2f", function(p134)
			t1.value17.Transparency = p134
			t1.value120.BackgroundTransparency = 1
		end)

		local salvamento = t1.value139("SALVAMENTO")
		local v630 = t1.value140(salvamento, "Sistema pronto", t1.value23.white)

		t1.value141(salvamento, "Carregar automaticamente", t1.value17, "AutoLoad", function()
			local _, v632 = t1.value28()

			v630.Text = _G.SkyHubTranslate(v632)
		end)
		t1.value142(salvamento, "SALVAR CONFIGURACOES", function()
			local _, v634 = t1.value28()

			v630.Text = _G.SkyHubTranslate(v634)
		end)
		t1.value142(salvamento, "CARREGAR CONFIGURACOES", function()
			local v635 = t1.value26()

			if v635 then
				v635 = t1.value27(v635)
			end

			if not v635 then
				v630.Text = _G.SkyHubTranslate("Nenhum arquivo valido")

				return
			end

			t1.value120.BackgroundTransparency = 1
			t1.value67()
			t1.value77()

			if t1.value14.AntiRagdoll then
				t1.value61()
			else
				t1.value60(t1.value56)
			end

			if t1.value14.PlayerESP then
				t1.value107()
			else
				t1.value105()
			end

			if not t1.value14.ShieldDetector then
				t1.value90()
			end

			if t1.value14.AutoFarm then
				task.spawn(v228)
			end

			task.defer(function()
				if not t1.value8 then
					return
				end

				t1.value146(9)
			end)
		end)
		t1.value140(salvamento, "AutoLoad restaura preferencias na proxima execucao.")

		local v636 = t1.value139("IDIOMA / LANGUAGE")

		t1.value142(v636, "PORTUGUES / ENGLISH", function()
			_G.SkyHubChooseLanguage()
		end)

		local interface = t1.value139("INTERFACE")

		t1.value142(interface, "Centralizar menu", t1.value133)
		t1.value142(interface, "Fechar menu", function()
			if not _G.MacielHubStop then
				return
			end

			_G.MacielHubStop()
		end)
	elseif p133 == 10 then
		t1.value157()
	else
		if p133 ~= 11 then
			t1.value137.CanvasPosition = Vector2.zero

			return
		end

		local creditos = t1.value139("CREDITOS")

		t1.value140(creditos, "SKYHUB V1 | DARKHOLD", t1.value23.gold)
		t1.value140(creditos, "Criado por adryanrz.", t1.value23.white)
		t1.value140(creditos, "Projeto: SkyHub | Jogo: Marvel Omega")

		local discord = t1.value139("DISCORD")
		local v640 = t1.value140(discord, "https://discord.gg/prrKEYFAe", t1.value23.white)

		t1.value142(discord, "COPIAR LINK DO DISCORD", function()
			if "https://discord.gg/prrKEYFAe" == "" then
				v640.Text = _G.SkyHubTranslate("Discord ainda nao configurado.")
			else
				local setclipboard_ = setclipboard

				if type(setclipboard_) == "function" then
					local ok = pcall(setclipboard, "https://discord.gg/prrKEYFAe")

					v640.Text = _G.SkyHubTranslate(ok and "Link copiado!" or ok or "Nao foi possivel copiar.")

					return
				else
					v640.Text = _G.SkyHubTranslate("Copia nao disponivel neste ambiente.")

					return
				end
			end
		end)
		t1.value142(discord, "ENTRAR NO DISCORD", function()
			if "https://discord.gg/prrKEYFAe" == "" then
				v640.Text = _G.SkyHubTranslate("Discord ainda nao configurado.")
			else
				local setclipboard_ = setclipboard

				if type(setclipboard_) == "function" then
					local ok = pcall(setclipboard, "https://discord.gg/prrKEYFAe")

					v640.Text = _G.SkyHubTranslate(ok and "Link copiado. Abra no navegador." or ok or "Copie o link manualmente.")

					return
				else
					v640.Text = _G.SkyHubTranslate("Abra o convite no navegador: https://discord.gg/prrKEYFAe")

					return
				end
			end
		end)
	end

	t1.value137.CanvasPosition = Vector2.zero
end

for i, v in ipairs(t1.value144) do
	v = t1.value116("TextButton", {
		Text = v,
		TextSize = 14,
		Font = Enum.Font.Garamond,
		TextColor3 = Color3.fromRGB(250, 239, 207),
		ZIndex = 10,
		BackgroundColor3 = t1.value23.panel,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -12, 0, 32),
		TextWrapped = true,
		TextScaled = false,
		TextTruncate = Enum.TextTruncate.AtEnd,
		LayoutOrder = i
	}, t1.value135)
	t1.value145[i] = v
	t1.value12(v.MouseButton1Click, function()
		t1.value146(i)
	end)
end

t1.value160 = false
t1.value161 = UDim2.fromOffset(12, 90)
t1.value162 = UDim2.fromOffset(48, 54)
t1.value163 = Instance.new("UIScale")
t1.value163.Scale = 1
t1.value163.Parent = t1.value120

function t1.value164(p135, p136, p137, p138, p139)
	local tween = t1.value119:Create(p135, TweenInfo.new(p136, p138 or Enum.EasingStyle.Quint, p139 or Enum.EasingDirection.InOut), p137)

	tween:Play()
	tween.Completed:Wait()
end

t1.value12(v408.Activated, function()
	if not (t1.value160 or not t1.value120.Visible) then
		local AbsolutePosition = t1.value120.AbsolutePosition
		local AbsoluteSize = t1.value120.AbsoluteSize

		t1.value164(t1.value163, 0.16, {
			Scale = 0.84
		}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		t1.value120.Visible = false
		t1.value163.Scale = 1
		t1.value129.Position = UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X * 0.38, AbsolutePosition.Y + AbsoluteSize.Y * 0.22)

		local value129 = t1.value129
		local uDim2 = UDim2.fromOffset
		local v652 = AbsoluteSize.X * 0.24
		local v653 = math.max(48, v652)
		local v654 = AbsoluteSize.Y * 0.65

		value129.Size = uDim2(v653, (math.max(54, v654)))
		t1.value129.Visible = true
		t1.value164(t1.value129, 0.5, {
			Position = t1.value161,
			Size = t1.value162
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		t1.value160 = false
	end
end)
v408 = function(p140, p141, p142)
	local u655 = false
	local u656 = false
	local u657 = nil
	local Position = nil
	local Position2 = nil

	t1.value12(p141.InputBegan, function(p143)
		if not (p143.UserInputType == Enum.UserInputType.MouseButton1 and true or p143.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u655 = true
		u656 = false
		u657 = p143.UserInputType == Enum.UserInputType.Touch and p143 and p143 or nil
		Position = p143.Position
		Position2 = p140.Position
	end)
	t1.value12(t1.value3.InputChanged, function(p144)
		if not u655 then
			return
		end

		local v660

		if p144.UserInputType == Enum.UserInputType.MouseMovement then
			v660 = false
		else
			v660 = p144 ~= u657
		end

		if v660 then
			return
		end

		local v661 = p144.Position - Position

		if not (v661.Magnitude > 6) then
			v762 = p140.AbsoluteSize
			v763, v764 = t1.value131(Position2.X.Offset + v661.X, Position2.Y.Offset + v661.Y, v762.X, v762.Y)
			p140.Position = UDim2.fromOffset(v763, v764)

			return
		end

		u656 = true

		local AbsoluteSize = p140.AbsoluteSize
		local v663, v664 = t1.value131(Position2.X.Offset + v661.X, Position2.Y.Offset + v661.Y, AbsoluteSize.X, AbsoluteSize.Y)

		p140.Position = UDim2.fromOffset(v663, v664)
	end)
	t1.value12(t1.value3.InputEnded, function(p145)
		local v665 = u655

		if v665 then
			v665 = p145.UserInputType == Enum.UserInputType.MouseButton1 and true or p145 == u657
		end

		if not v665 then
			return
		end

		local v666 = p142

		if v666 then
			v666 = not u656
		end

		if not v666 then
			return
		end

		p142()
	end)
end
v408(t1.value120, ViewportFrame)
v408(t1.value129, t1.value129)
t1.value12(t1.value129.Activated, function()
	if not (t1.value160 or t1.value120.Visible) then
		local Position = t1.value120.Position
		local Size = t1.value120.Size
		local value164 = t1.value164
		local value129 = t1.value129
		local uDim2 = UDim2.fromOffset(Position.X.Offset + Size.X.Offset * 0.38, Position.Y.Offset + Size.Y.Offset * 0.22)
		local uDim22 = UDim2.fromOffset
		local v673 = Size.X.Offset * 0.24
		local v674 = math.max(48, v673)
		local v675 = Size.Y.Offset * 0.65

		value164(value129, 0.42, {
			Position = uDim2,
			Size = uDim22(v674, (math.max(54, v675)))
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
		t1.value129.Visible = false
		t1.value129.Size = t1.value162
		t1.value129.Position = t1.value161
		t1.value163.Scale = 0.78
		t1.value120.Visible = true
		t1.value164(t1.value163, 0.42, {
			Scale = 1
		}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end
end)
ViewportFrame = function()
	local v676, v677 = t1.value132()

	t1.value135.Size = UDim2.new(0.43, 0, 1, 0)
	t1.value137.Position = UDim2.new(0.55, 0, 0, 0)
	t1.value137.Size = UDim2.new(0.43, 0, 1, 0)

	local v678, v679 = t1.value131(t1.value120.Position.X.Offset, t1.value120.Position.Y.Offset, v676, v677)

	t1.value120.Position = UDim2.fromOffset(v678, v679)
end
t1.value12(t1.value88:GetPropertyChangedSignal("AbsoluteSize"), ViewportFrame)
ViewportFrame()

function t1.value165(p146)
	if not t1.value120.Visible then
		return false
	end

	local AbsolutePosition = t1.value120.AbsolutePosition
	local AbsoluteSize = t1.value120.AbsoluteSize
	local v682 = p146.X >= AbsolutePosition.X

	if not v682 then
		return v682
	end

	v682 = p146.X <= AbsolutePosition.X + AbsoluteSize.X

	if not v682 then
		return v682
	end

	if p146.Y >= AbsolutePosition.Y then
		v682 = p146.Y <= AbsolutePosition.Y + AbsoluteSize.Y
	else
		v682 = false
	end

	return v682
end

t1.value12(t1.value3.TouchStarted, function(p147, p148)
	local v683 = not p148

	if v683 then
		v683 = not t1.value165(p147.Position)
	end

	if not v683 then
		return
	end

	t1.value66[p147] = p147.Position
end)
t1.value12(t1.value3.TouchEnded, function(p149)
	t1.value66[p149] = nil
end)
t1.value12(t1.value3.InputChanged, function(p150, p151)
	if not t1.value14.Aimbot or p151 then
		return
	end

	local v684 = false

	if p150.UserInputType == Enum.UserInputType.MouseMovement then
		v684 = p150.Delta.Magnitude > 3
	else
		local v685

		if p150.UserInputType == Enum.UserInputType.Touch then
			v685 = t1.value66[p150]
		else
			v685 = false
		end

		if v685 then
			v684 = (p150.Position - t1.value66[p150]).Magnitude > 5
			t1.value66[p150] = p150.Position
		end
	end

	if not v684 then
		return
	end

	local v686 = t1
	local now = os.clock()
	local Freedom = t1.value15.Freedom

	v686.value64 = now + math.max(Freedom, 0.35)
end)
t1.value166 = nil
t1.value166 = "MacielHubAim_BETA_1_0"
pcall(function()
	t1.value2:UnbindFromRenderStep(t1.value166)
end)
ViewportFrame = t1.value2
v408 = t1.value166
cFrame2 = Enum.RenderPriority.Last
ViewportFrame.BindToRenderStep(ViewportFrame, v408, cFrame2.Value, function(p152)
	if not (t1.value8 and (t1.value14.Aimbot and t1.value30())) then
		t1.value67()

		return
	end

	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera or os.clock() < t1.value64 then
		return
	end

	local v690, v691 = t1.value70(CurrentCamera)
	local value147 = t1.value147

	if value147 then
		value147 = t1.value147.Parent
	end

	if value147 then
		local value1472 = t1.value147
		local s5 = "Text"
		local SkyHubTranslate = _G.SkyHubTranslate

		if v691 then
			v691 = "Alvo: " .. v691.DisplayName
		end

		value1472[s5] = SkyHubTranslate(v691 or "Alvo: nenhum")
	end

	if not v690 then
		return
	end

	local CFrame_ = CurrentCamera.CFrame
	local v697 = v690 - CFrame_.Position

	if v697.Magnitude < 1 and true or v697.Magnitude > 3000 then
		return
	end

	local Y = CurrentCamera.ViewportSize.Y
	local FieldOfView = CurrentCamera.FieldOfView
	local v700 = math.rad(FieldOfView) * 0.5
	local v701 = Y / (2 * math.tan(v700))
	local v702 = math.max(0.01, (v690 - CFrame_.Position):Dot(CFrame_.LookVector)) / math.max(v701, 1)
	local v703 = v690 + CFrame_.UpVector * (t1.value15.CenterY * v702)
	local cFrame3 = CFrame.lookAt(CFrame_.Position, v703, Vector3.yAxis)
	local Strength = t1.value15.Strength
	local v706 = 1 - math.clamp(Strength, 0.05, 1)
	local v707 = p152 * 60
	local v708 = math.clamp(v707, 0, 3)
	local v709 = 1 - math.pow(v706, v708)
	local v710 = CFrame_.LookVector:Dot(cFrame3.LookVector)
	local v711 = math.clamp(v710, -1, 1)
	local v712 = math.acos(v711)
	local n3 = 0.13962634015954636

	if not (n3 < v712) then
		CurrentCamera.CFrame = CFrame_:Lerp(cFrame3, math.clamp(v709, 0, 1))

		return
	end

	local v714 = n3 / v712

	v709 = math.min(v709, v714)
	CurrentCamera.CFrame = CFrame_:Lerp(cFrame3, math.clamp(v709, 0, 1))
end)
t1.value12(t1.value2.Heartbeat, function(p153)
	if not t1.value8 then
		return
	end

	t1.value81()
	t1.value82(p153)

	if t1.value14.AntiRagdoll then
		t1.value61()
	end

	if not t1.value14.AntiAbilityLock then
		return
	end

	t1.value62()
end)
task.spawn(function()
	while true do
		local value8 = t1.value8

		if value8 then
			value8 = t1.value88.Parent
		end

		if not value8 then
			return
		end

		pcall(t1.value103)
		pcall(t1.value107)

		local ok, result = pcall(t1.value94)

		if not ok then
			warn("SKYHUB SHIELD:", result)
		end

		local value148 = t1.value148

		if value148 then
			value148 = t1.value148.Parent
		end

		if value148 then
			local value1482 = t1.value148
			local s6 = "Text"
			local SkyHubTranslate = _G.SkyHubTranslate
			local ShieldDetector = t1.value14.ShieldDetector

			if ShieldDetector then
				ShieldDetector = "Escudos visiveis: " .. t1.value93 .. " | 500 studs"
			end

			value1482[s6] = SkyHubTranslate(ShieldDetector or "Detector desativado")
		end

		task.wait(0.1)
	end
end)

function _G.MacielHubStop()
	if not t1.value8 then
		return
	end

	local function v723()
		t1.value2:UnbindFromRenderStep(t1.value166)
	end

	t1.value8 = false
	pcall(v723)

	local value108 = t1.value108
	local s7 = "cycle"

	value108[s7] = value108[s7] + 1
	t1.value60(t1.value56)
	t1.value14.Aimbot = false
	t1.value14.ESP = false
	t1.value14.Noclip = false
	t1.value14.WalkSpeed = false
	t1.value14.Jump = false
	t1.value14.FlySpeed = false
	t1.value14.AntiRagdoll = false
	t1.value14.AntiAbilityLock = false
	t1.value14.ShieldDetector = false
	t1.value14.PlayerESP = false
	t1.value14.AutoStone = false
	t1.value67()
	t1.value100()
	t1.value90()
	t1.value105()
	t1.value77()
	t1.value79()
	t1.value80()
	t1.value13(t1.value10)
	t1.value13(t1.value11)
	t1.value13(t1.value9)

	for _, v in pairs(t1.value113) do
		pcall(function()
			v:Disconnect()
		end)
	end

	if not t1.value88 then
		_G.MacielHubStop = nil

		return
	end

	t1.value88:Destroy()
	_G.MacielHubStop = nil
end

t1.value12(Camera2.MouseButton1Click, function()
	_G.MacielHubStop()
end)
t1.value146(1)
ViewportFrame = t1.value17.AutoLoad

if ViewportFrame then
	ViewportFrame = t1.value14.AutoFarm
end

if ViewportFrame then
	task.spawn(function()
		task.wait(1)

		if not t1.value8 then
			return
		end

		v228()
	end)
end

print("SKYHUB V1 | CRIADO POR ADRYANRZ")

function _G.SkyHubChooseLanguage()
	if not (t1.value88 and t1.value88.Parent) then
		return
	end

	local SkyHubLanguagePicker = t1.value88:FindFirstChild("SkyHubLanguagePicker")

	if SkyHubLanguagePicker then
		SkyHubLanguagePicker:Destroy()
	end

	local Frame = Instance.new("Frame")

	Frame.Name = "SkyHubLanguagePicker"
	Frame.Size = UDim2.fromScale(1, 1)
	Frame.BackgroundColor3 = Color3.fromRGB(8, 7, 12)
	Frame.BackgroundTransparency = 0.12
	Frame.Active = true
	Frame.ZIndex = 150
	Frame.Parent = t1.value88

	local Frame2 = Instance.new("Frame")

	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.Position = UDim2.fromScale(0.5, 0.5)
	Frame2.Size = UDim2.new(0.88, 0, 0, 210)
	Frame2.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
	Frame2.ZIndex = 151
	Frame2.Parent = Frame

	local UISizeConstraint = Instance.new("UISizeConstraint")

	UISizeConstraint.MaxSize = Vector2.new(370, 210)
	UISizeConstraint.Parent = Frame2

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "ESCOLHA O IDIOMA / CHOOSE LANGUAGE"
	TextLabel.TextWrapped = true
	TextLabel.TextColor3 = Color3.fromRGB(222, 177, 91)
	TextLabel.TextSize = 19
	TextLabel.Font = Enum.Font.Garamond
	TextLabel.Position = UDim2.new(0, 10, 0, 10)
	TextLabel.Size = UDim2.new(1, -20, 0, 55)
	TextLabel.ZIndex = 152
	TextLabel.Parent = Frame2

	local function v734(p154, p155, p156)
		local TextButton = Instance.new("TextButton")

		TextButton.Text = p154
		TextButton.TextSize = 18
		TextButton.Font = Enum.Font.Garamond
		TextButton.TextColor3 = Color3.fromRGB(255, 220, 143)
		TextButton.BackgroundColor3 = Color3.fromRGB(60, 42, 49)
		TextButton.Position = UDim2.new(0.08, 0, 0, p155)
		TextButton.Size = UDim2.new(0.84, 0, 0, 44)
		TextButton.ZIndex = 152
		TextButton.Parent = Frame2

		local UICorner2 = Instance.new("UICorner")

		UICorner2.CornerRadius = UDim.new(0, 8)
		UICorner2.Parent = TextButton

		local function v737()
			_G.SkyHubLang = p156
			_G.SkyHubLangSaved = true

			local writefile_ = writefile

			if type(writefile_) ~= "function" then
				Frame:Destroy()

				for i, v in ipairs(t1.value144) do
					if t1.value145[i] then
						t1.value145[i].Text = _G.SkyHubTranslate(v)
					end
				end

				t1.value146(1)

				return
			end

			pcall(function()
				local t9 = {
					Language = p156
				}

				writefile("SkyHub_V1_Language.json", t1.value5:JSONEncode(t9))
			end)
			Frame:Destroy()

			for i, v in ipairs(t1.value144) do
				if t1.value145[i] then
					t1.value145[i].Text = _G.SkyHubTranslate(v)
				end
			end

			t1.value146(1)
		end

		TextButton.MouseButton1Click:Connect(v737)
	end

	v734("PORTUGUES", 89, "pt")
	v734("ENGLISH", 146, "en")
end

if _G.SkyHubLangSaved then
	return
end

_G.SkyHubChooseLanguage()
