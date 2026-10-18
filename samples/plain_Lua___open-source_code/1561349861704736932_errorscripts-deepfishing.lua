-- ErrorScripts Universal 1.3.3 | Private source — configure links before distribution.
-- The embedded Vampauth gate runs before any gameplay adapter or the hub starts.
if not game:IsLoaded() then game.Loaded:Wait() end

local ErrorScriptsEnv = if type(getgenv) == "function" then getgenv() else {}
local ErrorScriptsConfig = {
	Discord = "", -- ErrorScripts invite, for example https://discord.gg/YOUR_INVITE
	KeyUrl = "https://vampauth.com/KIMI94ZFI2HH7LPK/flow", -- Public key flow for this Vampauth project.
	LoaderUrl = "", -- Optional URL of THIS protected hub, for reloading after teleports.
	Language = "en", -- English by default. The user can explicitly choose another language.
	Font = Enum.Font.BuilderSans,
	AutoLoad = true,
	GameKey = "Universal",
	GameName = "Universal",
	Style = {Accent = "Red", Animations = true, ReducedMotion = false, Glitch = true, Particles = true,
		RGB = false, Watermark = true, Scale = 1, Transparency = 0, MenuKey = "RightShift"},
}
if type(isfile) == "function" and type(readfile) == "function" then
	pcall(function()
		if not isfile("ErrorScripts/interface-v1.json") then return end
		local saved = game:GetService("HttpService"):JSONDecode(readfile("ErrorScripts/interface-v1.json"))
		if type(saved) ~= "table" then return end
		-- Ignore automatic locale choices from v1.0. Only restore an explicit v1.1 choice.
		if saved.LanguageVersion == 2 and (saved.Language == "en" or saved.Language == "pt" or saved.Language == "es" or saved.Language == "fr") then ErrorScriptsConfig.Language = saved.Language end
		if type(saved.AutoLoad) == "boolean" then ErrorScriptsConfig.AutoLoad = saved.AutoLoad end
		if type(saved.Style) ~= "table" then return end
		for key, default in pairs(ErrorScriptsConfig.Style) do
			local value = saved.Style[key]
			if type(value) == type(default) then
				if key == "Scale" then value = math.clamp(value, 0.65, 1.3)
				elseif key == "Transparency" then value = math.clamp(value, 0, 0.35)
				elseif key == "Accent" and not table.find({"Red", "Violet", "Blue", "Cyan"}, value) then continue
				elseif key == "MenuKey" and not Enum.KeyCode[value] then continue end
				ErrorScriptsConfig.Style[key] = value
			end
		end
	end)
end
local function ErrorScriptsGuiParent()
	-- Preserve normal input on mobile and avoid requiring CoreGui access.
	return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end


-- ERRORSCRIPTS / EMBEDDED VAMPAUTH / PRIVATE CONFIGURATION
-- ErrorScripts / mandatory embedded Vampauth validation
-- The public Project ID and project UUID are already configured.
-- This private build preserves the supplied Auth Secret. Do not publish it as raw source.
-- Never publish this source with a real Auth Secret in plain text.
local ErrorScriptsAuthConfig = {
	projectId = "KIMI94ZFI2HH7LPK",
	authSecret = "5b3ba55822d4b3d99160ce00b6d6145c757493de98831a36",
	projectUuid = "f89c74ad-ec8a-4bcc-8de7-8633426e353a",
}

local function ErrorScriptsVampauthClient()
	local HttpService = game:GetService("HttpService")

	local API_BASE = "https://vampauth.com/api"

	local PROJECT_ID = "your-project-id"
	local AUTH_SECRET = "your-48-hex-char-auth-secret"

	local Debug = false

	local function SetDebug(on)
		Debug = not not on
	end

	local function dbg(fmt, ...)
		if Debug then
			print("[vampauth] " .. string.format(fmt, ...))
		end
	end

	local function MaskKey(k)
		if type(k) ~= "string" or #k <= 8 then
			return tostring(k)
		end
		return k:sub(1, 8) .. "..."
	end

	local function Truncate(s, n)
		s = tostring(s or "")
		if #s <= n then
			return s
		end
		return s:sub(1, n) .. "...(" .. #s .. " bytes)"
	end

	local function IdentifyExecutor()
		local ok, name = pcall(function()
			return (identifyexecutor())
		end)
		if ok and type(name) == "string" and name ~= "" then
			return name
		end
		return "unknown"
	end

	local function HttpFetch(url, method, headers, body)
		local send = request or http_request or (syn and syn.request)
		if send then
			dbg("http: executor request global (%s)", IdentifyExecutor())
			local ok, res = pcall(send, { Url = url, Method = method, Headers = headers, Body = body })
			if ok and res then
				return res.StatusCode or res.statusCode or res.status_code or res.status or 0,
					res.Body or res.body or ""
			end
			dbg("http: executor request failed: %s", tostring(ok and "nil response" or tostring(res)))
		end

		dbg("http: falling back to HttpService:RequestAsync")
		local ok, res = pcall(function()
			return HttpService:RequestAsync({ Url = url, Method = method, Headers = headers, Body = body })
		end)
		if not ok or not res then
			dbg("http: RequestAsync failed: %s", tostring(res))
			return 0, ""
		end
		return res.StatusCode or res.statusCode or res.status_code or res.status or 0, res.Body or res.body or ""
	end

	local function JSONDecode(text)
		local ok, data = pcall(function()
			return HttpService:JSONDecode(text)
		end)
		if not ok then
			return nil
		end
		return data
	end

	local function JSONEncode(data)
		local ok, text = pcall(function()
			return HttpService:JSONEncode(data)
		end)
		if not ok then
			return "{}"
		end
		return text
	end

	local function NewNonce()
		return HttpService:GenerateGUID(false) .. HttpService:GenerateGUID(false)
	end

	local function AnalyticsClientId()
		local ok, id = pcall(function()
			return game:GetService("RbxAnalyticsService"):GetClientId()
		end)
		if ok and type(id) == "string" and id ~= "" then
			return id
		end
	end

	local function DefaultHWID()
		return AnalyticsClientId()
	end

	local H0, H1, H2, H3, H4 = 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0

	local function ToBytes(msg)
		local n = #msg
		local bytes = {}
		for i = 1, n do
			bytes[i] = string.byte(msg, i)
		end
		return bytes, n
	end

	local function SHA1(msg)
		local bytes, n = ToBytes(msg)
		bytes[n + 1] = 0x80
		local pad = (64 - ((n + 1 + 8) % 64)) % 64
		for i = n + 2, n + 1 + pad do
			bytes[i] = 0
		end
		local bits = n * 8
		local base = n + 1 + pad
		for i = 1, 8 do
			bytes[base + i] = math.floor(bits / 2 ^ ((8 - i) * 8)) % 256
		end

		local h0, h1, h2, h3, h4 = H0, H1, H2, H3, H4
		local w = {}
		for off = 0, base + 8 - 1, 64 do
			for i = 1, 16 do
				local j = off + (i - 1) * 4
				w[i] = bytes[j + 1] * 0x1000000 + bytes[j + 2] * 0x10000 + bytes[j + 3] * 0x100 + bytes[j + 4]
			end
			for i = 17, 80 do
				local v = bit32.bxor(bit32.bxor(w[i - 3], w[i - 8]), bit32.bxor(w[i - 14], w[i - 16]))
				w[i] = bit32.lrotate(v, 1)
			end
			local a, b, c, d, e = h0, h1, h2, h3, h4
			for i = 1, 80 do
				local f, k
				if i <= 20 then
					f = bit32.bxor(bit32.band(b, c), bit32.band(bit32.bnot(b), d))
					k = 0x5A827999
				elseif i <= 40 then
					f = bit32.bxor(bit32.bxor(b, c), d)
					k = 0x6ED9EBA1
				elseif i <= 60 then
					f = bit32.bxor(bit32.bxor(bit32.band(b, c), bit32.band(b, d)), bit32.band(c, d))
					k = 0x8F1BBCDC
				else
					f = bit32.bxor(bit32.bxor(b, c), d)
					k = 0xCA62C1D6
				end
				local temp = bit32.band(bit32.lrotate(a, 5) + f + e + k + w[i], 0xFFFFFFFF)
				e = d
				d = c
				c = bit32.lrotate(b, 30)
				b = a
				a = temp
			end
			h0 = bit32.band(h0 + a, 0xFFFFFFFF)
			h1 = bit32.band(h1 + b, 0xFFFFFFFF)
			h2 = bit32.band(h2 + c, 0xFFFFFFFF)
			h3 = bit32.band(h3 + d, 0xFFFFFFFF)
			h4 = bit32.band(h4 + e, 0xFFFFFFFF)
		end
		return string.format("%08x%08x%08x%08x%08x", h0, h1, h2, h3, h4)
	end

	local function ToRawBytes(hex)
		local out = {}
		for i = 1, #hex, 2 do
			out[#out + 1] = string.char(tonumber(hex:sub(i, i), 16) * 16 + tonumber(hex:sub(i + 1, i + 1), 16))
		end
		return table.concat(out)
	end

	local function Pack(bytes)
		local out = {}
		for i = 1, #bytes do
			out[i] = string.char(bytes[i])
		end
		return table.concat(out)
	end

	local function HMACSha1Hex(secret, message)
		local key = secret
		if #key > 64 then
			key = ToRawBytes(SHA1(key))
		end

		local keyBytes, keyLen = ToBytes(key)
		local ipad, opad = {}, {}
		for i = 1, 64 do
			local kb = i <= keyLen and keyBytes[i] or 0
			ipad[i] = bit32.bxor(kb, 0x36)
			opad[i] = bit32.bxor(kb, 0x5C)
		end

		return SHA1(Pack(opad) .. ToRawBytes(SHA1(Pack(ipad) .. message)))
	end

	local function SignRequest(secret, parts)
		return HMACSha1Hex(secret, table.concat(parts, "|"))
	end

	local function ExpirySeconds(iso)
		if not iso then
			return 0
		end
		local ok, dt = pcall(DateTime.fromIsoDate, iso)
		if not ok then
			return 0
		end
		return math.floor(dt.UnixTimestampMillis / 1000)
	end

	local Vampauth = {}
	Vampauth.__index = Vampauth

	function Vampauth.new(cfg)
		cfg = cfg or {}
		return setmetatable({
			baseUrl = cfg.baseUrl or API_BASE,
			projectId = cfg.projectId or PROJECT_ID,
			authSecret = cfg.authSecret or AUTH_SECRET,
			hwid = cfg.hwid or DefaultHWID(),
			debug = not not cfg.debug,
			state = nil,
		}, Vampauth)
	end

	function Vampauth:SetHWID(hwid)
		self.hwid = hwid
	end

	function Vampauth:SetDebug(on)
		self.debug = not not on
	end

	function Vampauth:State()
		return self.state
	end

	function Vampauth:Check(key, opts)
		opts = opts or {}
		self.state = nil
		local hwid = opts.hwid or self.hwid
		local nonce = NewNonce()
		SetDebug(self.debug)
		dbg("check: start (executor=%s, key=%s, hwid=%s)", IdentifyExecutor(), MaskKey(key), tostring(hwid))

		if not self.projectId or self.projectId == "your-project-id" then
			return false, "config missing: set projectId"
		end
		if not self.authSecret or self.authSecret == "your-48-hex-char-auth-secret" then
			return false, "config missing: set authSecret"
		end

		local signature = SignRequest(self.authSecret, { nonce, key, hwid })
		local executor = IdentifyExecutor()
		local url = self.baseUrl .. "/v1/key/check"
		dbg("request: POST %s", url)
		local payload = { project_id = self.projectId, key = key, hwid = hwid, nonce = nonce, signature = signature }
		if executor ~= "unknown" then
			payload.executor = executor
		end
		local status, text = HttpFetch(url, "POST", { ["Content-Type"] = "application/json" }, JSONEncode(payload))
		dbg("response: status=%s body=%s", tostring(status), Truncate(text, 200))

		local function fail(reason)
			if self.debug then
				return false, reason .. " [status=" .. tostring(status) .. " body=" .. Truncate(text, 200) .. "]"
			end
			return false, reason
		end

		if status == 0 and text == "" then
			return fail("request failed")
		end
		local data = JSONDecode(text)

		if status < 200 or status >= 300 then
			local reason = (data and data.error) or ("HTTP " .. tostring(status))
			if self.debug then
				reason = reason .. " [status=" .. tostring(status) .. " body=" .. Truncate(text, 200) .. "]"
			end
			return false, reason
		end
		if not data or data.nonce_echo ~= nonce or not data.signature or not data.project_id then
			local why = not data and "unparseable body"
				or data.nonce_echo ~= nonce and "nonce echo mismatch"
				or not data.signature and "missing signature"
				or "missing project_id"
			dbg("bad response: %s", why)
			return fail("bad response")
		end

		local okVerify, valid = pcall(function()
			local expected = HMACSha1Hex(
				self.authSecret,
				nonce
					.. "|"
					.. tostring(data.status)
					.. "|"
					.. tostring(ExpirySeconds(data.expires_at))
					.. "|"
					.. data.project_id
			)
			return expected == data.signature
		end)
		if not okVerify or not valid then
			dbg("verify: %s", okVerify and "signature invalid" or ("verify error: " .. tostring(valid)))
			return fail("signature invalid")
		end
		dbg("verify: signature ok")

		if data.expires_at then
			local okdt, dt = pcall(DateTime.fromIsoDate, data.expires_at)
			if okdt and dt.UnixTimestamp <= os.time() then
				dbg("expired: %s <= %s", tostring(dt.UnixTimestamp), tostring(os.time()))
				return fail("expired")
			end
		end

		dbg("check: PASSED (expires_at=%s)", tostring(data.expires_at))
		self.state = {
			VAMP_STATUS = data.status,
			VAMP_KEY = key,
			VAMP_HWID_BOUND = data.hwid_bound,
			VAMP_EXPIRES_AT = data.expires_at,
			VAMP_CREATED_AT = data.created_at,
			VAMP_DISCORD_ID = data.discord_id,
			VAMP_DISCORD_USERNAME = data.discord_username,
			VAMP_IS_PREMIUM = not not data.is_premium,
			VAMP_REASON = "Key validation",
		}
		return true, data
	end

	return Vampauth
end

local function ErrorScriptsAuthorize()
	local cfg = ErrorScriptsAuthConfig
	if cfg.projectId == "PASTE_PUBLIC_PROJECT_ID_HERE" or cfg.projectId == "" then
		warn("[ErrorScripts/Auth] The owner must configure the public Project ID.")
		return false
	end
	if type(cfg.authSecret) ~= "string" or #cfg.authSecret ~= 48 or not cfg.authSecret:match("^%x+$") then
		warn("[ErrorScripts/Auth] The owner must configure the Auth Secret privately.")
		return false
	end
	if type(getgenv) ~= "function" then
		warn("[ErrorScripts/Auth] This environment does not support the key loader.")
		return false
	end
	local env = getgenv()
	local licenseKey = env.script_key
	if type(licenseKey) ~= "string" or not licenseKey:find("%S") or licenseKey == "PASTE-YOUR-KEY-HERE" then
		warn("[ErrorScripts/Auth] Enter your license key using getgenv().script_key before running the loader.")
		return false
	end

	-- This mandatory gate does not use getgenv().config.DisableChecks.
	local ok, allowed, result = pcall(function()
		local Vampauth = ErrorScriptsVampauthClient()
		local client = Vampauth.new({
			projectId = cfg.projectId,
			authSecret = cfg.authSecret,
			debug = false,
		})
		return client:Check(licenseKey)
	end)
	if not ok or allowed ~= true or type(result) ~= "table" then
		warn("[ErrorScripts/Auth] Key validation failed. Check the key, its expiry, your device and your connection.")
		return false
	end
	-- Check uses a fresh nonce and verifies the server's response signature.
	-- Also require the expected project, an explicit valid result and HWID binding.
	if result.status ~= "valid" or result.project_id ~= cfg.projectUuid or result.key ~= licenseKey then
		warn("[ErrorScripts/Auth] The validation response does not match this script.")
		return false
	end
	if result.hwid_bound ~= true then
		warn("[ErrorScripts/Auth] This project requires an HWID-bound license. FFA keys are not accepted.")
		return false
	end
	if result.expires_at ~= nil then
		local validExpiry, expiry = pcall(DateTime.fromIsoDate, result.expires_at)
		if not validExpiry or not expiry or expiry.UnixTimestamp <= os.time() then
			warn("[ErrorScripts/Auth] The license has expired or has an invalid expiry.")
			return false
		end
	end
	return true
end

-- ErrorScripts display translations. English is the fallback language.
-- Keys are original UI text; do not replace control IDs or game object names.
-- Dropdown labels may be translated while their internal Values stay unchanged.
local ErrorScriptsTranslations = {
	en = {},
	pt = {
        ["Sell at fish count"] = "Vender ao atingir esta quantidade de peixes",
        ["0 = sell as soon as fish are available."] = "0 = vender assim que houver peixes.",
        ["A sale is already in progress."] = "Já está uma venda em curso.",
        ["Wait for fishing to finish before selling."] = "Espera que a pesca termine antes de vender.",
        ["Could not sell fish:"] = "Não foi possível vender os peixes:",
		["Auto Collect Eggs"] = "Recolher Eggs automaticamente",
		["Copy egg names"] = "Copiar nomes dos Eggs",
		["No egg names found in the game catalog."] = "Não foram encontrados nomes de Eggs no catálogo do jogo.",
		["Egg names copied from the game catalog."] = "Nomes dos Eggs copiados do catálogo do jogo.",
		["Egg names printed to the console."] = "Nomes dos Eggs escritos na consola.",
		["Start fishing and wait for the egg or find to appear."] = "Começa a pescar e espera que o Egg ou achado apareça.",
		["No catches visible. Try while the egg or find is on screen."] = "Não há capturas visíveis. Tenta enquanto o Egg ou achado está no ecrã.",
		["Active find names/types and egg classification copied."] = "Nomes, tipos e classificação de Eggs dos achados ativos copiados.",
		["Key link copied. Open it in your browser."] = "Ligação da key copiada. Abre-a no navegador.",
		["Open this link in your browser to get a key."] = "Abre esta ligação no navegador para obter uma key.",
		["The owner has not configured the key link."] = "O proprietário ainda não configurou a ligação da key.",
		["Dashboard"] = "Painel",
		["Library"] = "Biblioteca",
		["Games"] = "Jogos",
		["Settings"] = "Definições",
		["Appearance"] = "Aparência",
		["Language"] = "Idioma",
		["Português"] = "Português",
		["English"] = "English",
		["Español"] = "Español",
		["Français"] = "Français",
		["Animations"] = "Animações",
		["Reduced motion"] = "Movimento reduzido",
		["Glitch effects"] = "Efeitos de glitch",
		["RGB accent"] = "Cor RGB dinâmica",
		["Interface scale"] = "Escala da interface",
		["Interface transparency"] = "Transparência da interface",
		["Accent color"] = "Cor de destaque",
		["Red"] = "Vermelho",
		["Violet"] = "Violeta",
		["Blue"] = "Azul",
		["Cyan"] = "Ciano",
		["Save configuration"] = "Guardar configuração",
		["Load configuration"] = "Carregar configuração",
		["Reset appearance"] = "Repor aparência",
		["Copy Discord link"] = "Copiar ligação do Discord",
		["Rejoin server"] = "Voltar ao servidor",
		["Server hop"] = "Mudar de servidor",
		["Reconnect"] = "Voltar a ligar",
		["Unload UI"] = "Fechar a interface",
		["Configuration name"] = "Nome da configuração",
		["Restore defaults"] = "Repor valores padrão",
		["Pause automations"] = "Pausar automações",
		["Auto load current game"] = "Carregar o jogo atual automaticamente",
		["Open menu"] = "Abrir menu",
		["Launch"] = "Iniciar",
		["Current game"] = "Jogo atual",
		["Available"] = "Disponível",
		["Unsupported game"] = "Jogo não suportado",
		["Key required"] = "Chave necessária",
		["License key"] = "Chave de licença",
		["Validate key"] = "Validar chave",
		["Get key"] = "Obter chave",
		["Copy key link"] = "Copiar ligação da chave",
		["Waiting for a key."] = "A aguardar uma chave.",
		["Validating key..."] = "A validar a chave...",
		["Key validated."] = "Chave validada.",
		["Key validation failed."] = "Não foi possível validar a chave.",
		["Enter a valid key to continue."] = "Introduz uma chave válida para continuar.",
		["Close"] = "Fechar",
		["Supported games"] = "Jogos suportados",
		["Choose your targets and collection settings."] = "Escolhe os alvos e as opções de recolha.",
		["Customize your session."] = "Personaliza a tua sessão.",
		["Your license has been verified."] = "A tua licença foi verificada.",
		["Menu and session"] = "Menu e sessão",
		["Menu bind"] = "Tecla do menu",
		["Search options in this menu..."] = "Pesquisar opções neste menu...",
		["Main"] = "Principal",
		["Shop"] = "Loja",
		["Player"] = "Jogador",
		["Info"] = "Informações",
		["Fishing"] = "Pesca",
		["Finds"] = "Achados",
		["Rewards"] = "Recompensas",
		["Sell"] = "Vender",
		["Codes"] = "Códigos",
		["Bait"] = "Isco",
		["Movement"] = "Movimento",
		["Fly"] = "Voar",
		["Menu"] = "Menu",
		["User"] = "Utilizador",
		["Session"] = "Sessão",
		["Server"] = "Servidor",
		["Configuration"] = "Configuração",
		["Configurations"] = "Configurações",
		["Theme"] = "Tema",
		["Fishing automation"] = "Automação de pesca",
		["Finds and fragments"] = "Achados e fragmentos",
		["Sell fish"] = "Vender peixes",
		["Equipment"] = "Equipamento",
		["Flight"] = "Voo",
		["Your profile"] = "O teu perfil",
		["Current session"] = "Sessão atual",
		["Rods, bait and codes in one place."] = "Canas, iscos e códigos num só lugar.",
		["Adjust movement and player options."] = "Ajusta o movimento e as opções do jogador.",
		["Player and session information."] = "Informações do jogador e da sessão.",
		["Customize the menu and save your settings."] = "Personaliza o menu e guarda as tuas definições.",
		["The action failed. Check the console for details."] = "A ação falhou. Consulta a consola para mais detalhes.",
		["AUTO ACTIVE"] = "AUTO ATIVO",
		["AUTO PAUSED"] = "AUTO PAUSADO",
		[" AUTO ACTIVE"] = " AUTO ATIVO",
		[" · show / hide"] = " · mostrar / ocultar",
		["show / hide"] = "mostrar / ocultar",
		["RightShift · show / hide"] = "RightShift · mostrar / ocultar",
		["Select"] = "Selecionar",
		["Select  +"] = "Selecionar  +",
		["All / no filter"] = "Todos / sem filtro",
		["Filter options..."] = "Filtrar opções...",
		["Press a key"] = "Prime uma tecla",
		["Use ES to reopen the menu."] = "Usa ES para voltar a abrir o menu.",
		["File saving is unavailable. Use clipboard export instead."] = "Não é possível guardar ficheiros. Usa a exportação para a área de transferência.",
		["Configuration saved."] = "Configuração guardada.",
		["Use clipboard import to load a configuration."] = "Usa a importação da área de transferência para carregar uma configuração.",
		["Configuration loaded."] = "Configuração carregada.",
		["The default profile loads on startup."] = "O perfil padrão é carregado no arranque.",
		["Start fishing and wait for the fragment to appear."] = "Começa a pescar e aguarda que o fragmento apareça.",
		["No catches visible. Try while the fragment is on screen."] = "Não há capturas visíveis. Tenta quando o fragmento estiver no ecrã.",
		["Active find names/types and fragment classification copied."] = "Nomes e tipos dos achados ativos e classificação de fragmentos copiados.",
		["Active find names/types printed to the console."] = "Nomes e tipos dos achados ativos enviados para a consola.",
		["Bought best affordable rod"] = "Comprada a melhor cana disponível dentro do orçamento",
		["No affordable rod"] = "Nenhuma cana disponível dentro do orçamento",
		["Sold fish"] = "Peixes vendidos",
		["No fish to sell"] = "Não há peixes para vender",
		["Bought best affordable bait"] = "Comprado o melhor isco disponível dentro do orçamento",
		["No affordable bait"] = "Nenhum isco disponível dentro do orçamento",
		["Bait uses still remaining"] = "O isco ainda tem utilizações disponíveis",
		["Used "] = "Usado: ",
		["No bait in inventory"] = "Não há isco no inventário",
		["Bait not found"] = "Isco não encontrado",
		["ErrorScripts · custom interface"] = "ErrorScripts · interface personalizada",
		["Auto Perfect Fishing"] = "Pesca perfeita automática",
		["Auto Collect Fish"] = "Recolher peixes automaticamente",
		["Fast Fishing"] = "Pesca rápida",
		["Auto Stop When Empty"] = "Parar automaticamente quando vazio",
		["Collect Rarities"] = "Raridades a recolher",
		["Collect Mutations"] = "Mutações a recolher",
		["Auto Favourite"] = "Favoritos automáticos",
		["Auto Collect Finds"] = "Recolher achados automaticamente",
		["Auto Collect Fragments"] = "Recolher fragmentos automaticamente",
		["Copy active find names/types"] = "Copiar nomes e tipos dos achados ativos",
		["Find Types"] = "Tipos de achados",
		["Auto Claim Big Fish"] = "Recolher recompensas de peixes grandes automaticamente",
		["Auto Claim Free Rewards"] = "Recolher recompensas grátis automaticamente",
		["Auto Sell"] = "Vender automaticamente",
		["Sell All Fish"] = "Vender todos os peixes",
		["Auto Buy Best Bait"] = "Comprar o melhor isco automaticamente",
		["Buy Best Bait Now"] = "Comprar o melhor isco agora",
		["Auto Buy Best Rod"] = "Comprar a melhor cana automaticamente",
		["Buy Best Rod Now"] = "Comprar a melhor cana agora",
		["Upgrades"] = "Melhorias",
		["Auto Buy Upgrades"] = "Comprar melhorias automaticamente",
		["Code"] = "Código",
		["Enter code"] = "Introduz o código",
		["Redeem Code"] = "Resgatar código",
		["Auto Use Best Bait"] = "Usar o melhor isco automaticamente",
		["Use Best Bait Now"] = "Usar o melhor isco agora",
		["Selected"] = "Selecionado",
		["Auto Use Bait"] = "Usar isco automaticamente",
		["Use Bait"] = "Isco a usar",
		["Use Bait Now"] = "Usar isco agora",
		["UserId"] = "ID do utilizador",
		["Executor"] = "Executor",
		["Game"] = "Jogo",
		["Players"] = "Jogadores",
		["Job"] = "Instância",
		["Ping"] = "Latência",
		["Copy Username"] = "Copiar nome de utilizador",
		["Copied username"] = "Nome de utilizador copiado",
		["Copy Profile Link"] = "Copiar ligação do perfil",
		["Copied profile link"] = "Ligação do perfil copiada",
		["Rejoin Server"] = "Voltar ao servidor",
		["Copy Job ID"] = "Copiar ID da instância",
		["Copied Job ID"] = "ID da instância copiado",
		["Custom interface for Deep Fishing."] = "Interface personalizada para Deep Fishing.",
		["Drag ES to move it. Click to open."] = "Arrasta ES para o mover. Clica para abrir.",
		["Customize the menu in Settings."] = "Personaliza o menu nas Definições.",
		["WalkSpeed"] = "Velocidade de movimento",
		["WalkSpeed Amount"] = "Valor da velocidade de movimento",
		["Infinite Jump"] = "Salto infinito",
		["NoClip"] = "Atravessar objetos",
		["No Gameplay Paused"] = "Ocultar aviso de jogo em pausa",
		["Instant ProximityPrompt"] = "Interação de proximidade instantânea",
		["Fly Speed"] = "Velocidade de voo",
		["Anti-AFK"] = "Evitar inatividade",
		["AFK triggers: 0"] = "Ativações anti-inatividade: 0",
		["AFK triggers: "] = "Ativações anti-inatividade: ",
		["Menu keybind"] = "Tecla de atalho do menu",
		["Paste exported config here"] = "Cola aqui a configuração exportada",
		["Export Config to Clipboard"] = "Exportar configuração para a área de transferência",
		["Failed to encode the config"] = "Não foi possível codificar a configuração",
		["Your executor does not support copying to the clipboard"] = "O teu executor não permite copiar para a área de transferência",
		["Config copied to clipboard"] = "Configuração copiada para a área de transferência",
		["Import Config from Clipboard Text"] = "Importar configuração do texto copiado",
		["Paste an exported config into the box first"] = "Cola primeiro uma configuração exportada no campo",
		["That is not a valid exported config"] = "A configuração exportada não é válida",
		["No settings in that config matched this script"] = "Nenhuma definição dessa configuração corresponde a este script",
		["Imported %d setting%s"] = "Importado: %d ajuste%s",
		["Unknown"] = "Desconhecido",
		["Profile "] = "Perfil ",
		["Key link copied."] = "Ligação da chave copiada.",
		["Discord link copied."] = "Ligação do Discord copiada.",
		["Clipboard unavailable."] = "Área de transferência indisponível.",
		["Loading game..."] = "A carregar o jogo...",
		["Game loaded."] = "Jogo carregado.",
		["Game failed to load."] = "Não foi possível carregar o jogo.",
		["This game is not supported yet."] = "Este jogo ainda não é suportado.",
		["Launch this hub in a supported game."] = "Inicia este hub num jogo suportado.",
		["Automations paused."] = "Automações pausadas.",
		["Appearance restored."] = "Aparência reposta.",
		["Settings restored."] = "Definições repostas.",
		["Searching for another server..."] = "A procurar outro servidor...",
		["No available server was found."] = "Não foi encontrado outro servidor disponível.",
		["Reconnect failed."] = "Não foi possível voltar a ligar.",
		["Secure access"] = "Acesso seguro",
		["Ready"] = "Pronto",
		["Verified"] = "Verificado",
		["Connected"] = "Ligado",
		["Loading"] = "A carregar",
		["Welcome"] = "Bem-vindo",
		["Training"] = "Treino",
		["Idle"] = "Em espera",
		["Coins: 0"] = "Moedas: 0",
		["Strength level: 0"] = "Nível de força: 0",
		["Speed level: 0"] = "Nível de velocidade: 0",
		["Carrying: 0 / 0"] = "A transportar: 0 / 0",
		["Pyramids: 0"] = "Pirâmides: 0",
		["Blocks placed: 0"] = "Blocos colocados: 0",
		["Coins:"] = "Moedas:",
		["Coins: "] = "Moedas: ",
		["Strength level:"] = "Nível de força:",
		["Strength level: "] = "Nível de força: ",
		["Speed level:"] = "Nível de velocidade:",
		["Speed level: "] = "Nível de velocidade: ",
		["Carrying:"] = "A transportar:",
		["Carrying: "] = "A transportar: ",
		["Carrying: %d / %d"] = "A transportar: %d / %d",
		["Pyramids:"] = "Pirâmides:",
		["Pyramids: "] = "Pirâmides: ",
		["Blocks placed:"] = "Blocos colocados:",
		["Blocks placed: "] = "Blocos colocados: ",
		["Farm, train and upgrade in one menu."] = "Constrói, treina e melhora num só menu.",
		["Start automation from the farming tab."] = "Inicia a automação no separador de construção.",
		["Auto Farm"] = "Construção automática",
		["Return On Stop"] = "Voltar ao parar",
		["Place Distance"] = "Distância de colocação",
		["Spend Banked Blocks"] = "Usar blocos guardados",
		["Farm vs Training"] = "Construção e treino",
		["When Both Are On"] = "Quando ambos estão ativos",
		["Balanced"] = "Equilibrado",
		["Farm"] = "Construção",
		["Train"] = "Treino",
		["Alternate"] = "Alternar",
		["Payback Time (min)"] = "Tempo de retorno (min)",
		["Alternate Every (min)"] = "Alternar a cada (min)",
		["Balanced trains when the extra blocks pay it back."] = "O modo equilibrado treina quando os blocos adicionais compensam.",
		["Gym"] = "Ginásio",
		["Auto Train Strength"] = "Treinar força automaticamente",
		["Auto Train Speed"] = "Treinar velocidade automaticamente",
		["Bench Gym"] = "Ginásio de supino",
		["Treadmill Gym"] = "Ginásio de passadeira",
		["Best Unlocked"] = "Melhor desbloqueado",
		["Gym %s (x%d)"] = "Ginásio %s (x%d)",
		["Waters of Nu"] = "Águas de Nu",
		["Auto Join Pool"] = "Entrar na piscina automaticamente",
		["Go To Pool"] = "Ir para a piscina",
		["Auto Upgrade"] = "Melhorar automaticamente",
		["Buy Now"] = "Comprar agora",
		["Spending"] = "Despesas",
		["Order"] = "Ordem",
		["Best Value"] = "Melhor relação custo-benefício",
		["Cheapest First"] = "Mais barato primeiro",
		["In Order"] = "Pela ordem",
		["Keep Coins"] = "Reservar moedas",
		["Redeem All Codes"] = "Resgatar todos os códigos",
		["Claim Free Gift"] = "Recolher presente grátis",
		["Speed"] = "Velocidade",
		["Speed key"] = "Tecla de velocidade",
		["Walk Speed"] = "Velocidade de movimento",
		["Fly key"] = "Tecla de voo",
		["Noclip"] = "Atravessar objetos",
		["Noclip key"] = "Tecla de atravessar objetos",
		["Teleport"] = "Teletransporte",
		["Quarry"] = "Pedreira",
		["Pyramid"] = "Pirâmide",
		["Pool"] = "Piscina",
		["Go To Gym"] = "Ir para o ginásio",
		["Refresh Players"] = "Atualizar jogadores",
		["Go To Player"] = "Ir para o jogador",
		["Game session"] = "Sessão do jogo",
		["Anti AFK"] = "Evitar inatividade",
		["Auto Rejoin"] = "Voltar a ligar automaticamente",
		["Disable 3D Rendering"] = "Desativar renderização 3D",
		["FPS Boost"] = "Otimizar FPS",
		["Restore graphics"] = "Repor gráficos",
		["This feature needs a game update: "] = "Esta função precisa de uma atualização do jogo: ",
		["Picking up blocks"] = "A recolher blocos",
		["Placing on layer %d"] = "A colocar na camada %d",
		["Placing on layer "] = "A colocar na camada ",
		["Bench press x%d"] = "Supino x%d",
		["Bench press x"] = "Supino x",
		["Bench refused, retrying"] = "Supino recusado, a tentar novamente",
		["Treadmill x%d"] = "Passadeira x%d",
		["Treadmill x"] = "Passadeira x",
		["Training in the pool"] = "A treinar na piscina",
		["Waiting for the next pyramid"] = "A aguardar a próxima pirâmide",
		[", retrying"] = ", a tentar novamente",
		["Nothing to buy"] = "Nada para comprar",
		["Bought %s %d"] = "Comprado: %s %d",
		["Bought "] = "Comprado: ",
		[": redeemed"] = ": resgatado",
		["no reply"] = "sem resposta",
		["Codes done, %d new"] = "Códigos resgatados: %d novos",
		["Codes done, "] = "Códigos resgatados: ",
		[" new"] = " novos",
		["banked blocks"] = "blocos guardados",
		["banked time"] = "tempo guardado",
		[" spent"] = " usado",
		["none to spend"] = "nada para usar",
		["wait for the next pyramid"] = "aguarda a próxima pirâmide",
		["Free gift claimed"] = "Presente grátis recolhido",
		["Join the Janitors Studios group to claim the free gift"] = "Junta-te ao grupo Janitors Studios para recolher o presente grátis",
		["Free gift: "] = "Presente grátis: ",
		["Pool is not loaded yet, try again in a moment"] = "A piscina ainda não carregou; tenta novamente daqui a pouco",
		["Pool opens when a pyramid is completed"] = "A piscina abre quando uma pirâmide é concluída",
		["Player not found"] = "Jogador não encontrado",
		["Server list unavailable"] = "Lista de servidores indisponível",
		["No other server found"] = "Nenhum outro servidor encontrado",
		["FPS boost applied"] = "Otimização de FPS aplicada",
		[" stopped: "] = " parado: ",
		["None"] = "Nenhum",
		["Particles"] = "Partículas",
		["Watermark"] = "Marca de água",
		["Session controls"] = "Controlos da sessão",
		["The hub loads only the game you are playing."] = "O hub carrega apenas o jogo em que estás.",
		["Ready to launch."] = "Pronto para iniciar.",
		["Loading game module..."] = "A carregar o módulo do jogo...",
		["Game module loaded."] = "Módulo do jogo carregado.",
		["Game module failed to start. Check the console and run the hub again."] = "O módulo do jogo não iniciou. Consulta a consola e volta a executar o hub.",
		["Copied to clipboard."] = "Copiado para a área de transferência.",
		["Could not reconnect. Try again."] = "Não foi possível voltar a ligar. Tenta novamente.",
		["No other available server was found."] = "Não foi encontrado outro servidor disponível.",
		["Server search failed. Try again."] = "A procura de servidores falhou. Tenta novamente.",
		["SYSTEM ONLINE"] = "SISTEMA ONLINE",
		["ERROR // ACCESS"] = "ERROR // ACESSO",
		["Two games. One ErrorScripts menu."] = "Dois jogos. Um menu ErrorScripts.",
		["Choose your training and movement settings."] = "Escolhe as opções de treino e movimento.",
		["Run the hub again after teleporting."] = "Volta a executar o hub após o teletransporte.",
		-- Break and Steal an Egg display text. Engine IDs and player names remain unchanged.
		["Three games. One ErrorScripts menu."] = "Três jogos. Um menu ErrorScripts.",
		["Steal & Break"] = "Roubar e quebrar",
		["Base & Shop"] = "Base e loja",
		["Visuals"] = "Visuais",
		["Troll"] = "Troll",
		["Steal animals and break eggs."] = "Rouba animais e quebra ovos.",
		["Animals, upgrades and rewards."] = "Animais, melhorias e recompensas.",
		["See animals, eggs and players."] = "Vê animais, ovos e jogadores.",
		["Bat and player interactions."] = "Bastão e interações com jogadores.",
		["Status and all-in-one mode"] = "Estado e modo completo",
		["Status"] = "Estado",
		["Loading..."] = "A carregar...",
		["Kaitun"] = "Kaitun",
		["Kaitun (All-in-one)"] = "Kaitun (Tudo em um)",
		["Steals, breaks eggs, places, sells, upgrades and claims rewards by itself"] = "Rouba, quebra ovos, coloca animais, vende, compra melhorias e recebe recompensas automaticamente",
		["Discord"] = "Discord",
		["Copy Discord Link"] = "Copiar ligação do Discord",
		["Update Log"] = "Histórico de atualizações",
		["Farming"] = "Farm",
		["Steal animals and break eggs"] = "Rouba animais e quebra ovos",
		["Auto Steal"] = "Roubar automaticamente",
		["Grabs the most valuable animals on the map and brings them home instantly"] = "Recolhe os animais mais valiosos do mapa e leva-os para a base instantaneamente",
		["Take"] = "Recolher",
		["Upgrades Only = only animals that earn more than your weakest one"] = "Apenas melhorias = só animais que rendem mais do que o teu mais fraco",
		["Only Rarities"] = "Apenas estas raridades",
		["Empty = take everything"] = "Vazio = recolher tudo",
		["Min Cash/s"] = "Dinheiro/s mínimo",
		["Steal Best Now"] = "Roubar o melhor agora",
		["Bank Now"] = "Guardar na base agora",
		["Auto Break"] = "Quebrar automaticamente",
		["Auto Break Eggs"] = "Quebrar ovos automaticamente",
		["Breaks eggs in any zone at max speed and takes the animal home"] = "Quebra ovos em qualquer zona à velocidade máxima e leva o animal para a base",
		["Zone"] = "Zona",
		["Best = most worth for the time spent"] = "Melhor = maior retorno pelo tempo gasto",
		["Max Hits Per Egg"] = "Máximo de golpes por ovo",
		["Skips eggs that take longer than this"] = "Ignora ovos que precisem de mais golpes",
		["Rob Players"] = "Roubar jogadores",
		["Rob Carriers"] = "Roubar quem transporta animais",
		["Bats players carrying animals and takes what they drop"] = "Usa o bastão nos jogadores que transportam animais e recolhe o que deixam cair",
		["Progression"] = "Progresso",
		["Placing, selling, upgrades and rewards"] = "Colocação, vendas, melhorias e recompensas",
		["Animals"] = "Animais",
		["Auto Place Best"] = "Colocar os melhores automaticamente",
		["Keeps the best earners standing on your base"] = "Mantém os animais com maior rendimento na tua base",
		["Place Best Now"] = "Colocar os melhores agora",
		["Auto Sell Leftovers"] = "Vender os restantes automaticamente",
		["Sells animals in your backpack that did not fit on the base"] = "Vende os animais da mochila que não couberam na base",
		["Never Sell"] = "Nunca vender",
		["Sell All Now"] = "Vender todos agora",
		["Buys the picked upgrades as soon as you can pay"] = "Compra as melhorias selecionadas assim que tens dinheiro suficiente",
		["Upgrade"] = "Melhoria",
		["Pickaxe jumps to the best you can afford, Trail buys and wears the strongest"] = "A picareta passa para a melhor que podes pagar; o rasto compra e equipa o mais forte",
		["Upgrade Now"] = "Melhorar agora",
		["Keep Cash"] = "Dinheiro a reservar",
		["Upgrades never spend below this"] = "As melhorias nunca gastam o dinheiro reservado",
		["Eggs"] = "Ovos",
		["Auto Hatch Eggs"] = "Chocar ovos automaticamente",
		["Places eggs from your backpack on your base and hatches them when ready"] = "Coloca os ovos da mochila na base e choca-os quando estão prontos",
		["Hatch Eggs Now"] = "Chocar ovos agora",
		["Auto Claim"] = "Receber recompensas automaticamente",
		["Claims index, offline, group and community rewards, no joining needed"] = "Recebe recompensas do índice, offline, de grupo e da comunidade, sem precisares de aderir",
		["Claim Now"] = "Receber agora",
		["Movement and teleports"] = "Movimento e teletransportes",
		["Place"] = "Local",
		["See animals, eggs and players"] = "Vê animais, ovos e jogadores",
		["ESP"] = "ESP",
		["Name, rarity, weight and cash per second"] = "Nome, raridade, peso e dinheiro por segundo",
		["Min Rarity"] = "Raridade mínima",
		["Eggs & Players"] = "Ovos e jogadores",
		["HP and how many hits it takes"] = "Vida e número de golpes necessários",
		["Distance and what they carry"] = "Distância e o que transportam",
		["Bat other players"] = "Usar o bastão noutros jogadores",
		["Bat"] = "Bastão",
		["Target"] = "Alvo",
		["Loop Bat Target"] = "Bater no alvo repetidamente",
		["Follows the target and keeps knocking them over"] = "Segue o alvo e derruba-o repetidamente",
		["Bat Target Now"] = "Bater no alvo agora",
		["Bat Aura"] = "Aura do bastão",
		["Knocks over anyone who gets close"] = "Derruba quem se aproxima",
		["Stops the idle kick"] = "Evita a expulsão por inatividade",
		["Rejoins by itself after a disconnect"] = "Volta ao jogo automaticamente após perder a ligação",
		["Rejoin Now"] = "Voltar ao jogo agora",
		["Not available after a game update"] = "Indisponível após uma atualização do jogo",
		["Not available on this executor"] = "Indisponível neste executor",
		["Misc"] = "Diversos",
		["Upgrades Only"] = "Apenas melhorias",
		["Everything"] = "Tudo",
		["Pickaxe"] = "Picareta",
		["Base"] = "Base",
		["Trail"] = "Rasto",
		["Treadmill"] = "Passadeira",
		["Common"] = "Comum",
		["Uncommon"] = "Incomum",
		["Rare"] = "Raro",
		["Epic"] = "Épico",
		["Legendary"] = "Lendário",
		["Mythic"] = "Mítico",
		["Mythical"] = "Mítico",
		["Secret"] = "Secreto",
		["Divine"] = "Divino",
		["Cash:"] = "Dinheiro:",
		["Income/s:"] = "Rendimento/s:",
		["Pickaxe:"] = "Picareta:",
		["Damage:"] = "Dano:",
		["Base animals:"] = "Animais na base:",
		["Base level:"] = "Nível da base:",
		["Steals:"] = "Roubos:",
		["Eggs broken:"] = "Ovos quebrados:",
		["Animals banked:"] = "Animais guardados:",
		["Cash/min:"] = "Dinheiro/min:",
		["Status:"] = "Estado:",
		["Steal animals, break eggs and upgrade your base."] = "Rouba animais, quebra ovos e melhora a tua base.",
		["This feature needs a game update:"] = "Esta função precisa de uma atualização do jogo:",
		["Some features could not find their game dependencies."] = "Algumas funções não encontraram as dependências necessárias do jogo.",
		["Auto Steal key"] = "Tecla para roubar automaticamente",
		["Auto Break Eggs key"] = "Tecla para quebrar ovos automaticamente",
		["Auto Place Best key"] = "Tecla para colocar os melhores automaticamente",
		["Auto Sell Leftovers key"] = "Tecla para vender os restantes automaticamente",
		["Auto Upgrade key"] = "Tecla para melhorar automaticamente",
		["Auto Hatch Eggs key"] = "Tecla para chocar ovos automaticamente",
		["Auto Claim key"] = "Tecla para receber recompensas automaticamente",
		["Loop Bat Target key"] = "Tecla para bater no alvo repetidamente",
		["Bat Aura key"] = "Tecla da aura do bastão",
		["Kaitun (All-in-one) key"] = "Tecla de Kaitun (Tudo em um)",
		["Banking"] = "A guardar na base",
		["Stealing "] = "A roubar ",
		["No pickaxe"] = "Sem picareta",
		["Breaking %s (Zone %s)"] = "A quebrar %s (Zona %s)",
		["Breaking "] = "A quebrar ",
		[" (Zone "] = " (Zona ",
		["Robbing "] = "A roubar ",
		["Waiting for respawn"] = "A aguardar o respawn",
		["No egg beats your base yet"] = "Ainda nenhum ovo supera os animais da tua base",
		["Waiting for animals better than your base"] = "A aguardar animais melhores do que os da tua base",
		["Nothing to upgrade yet: not enough cash or already maxed"] = "Nada para melhorar: dinheiro insuficiente ou nível máximo atingido",
		["Sold %d animals"] = "Vendidos %d animais",
		["Eggs handled: %d"] = "Ovos processados: %d",
		["Sold "] = "Vendidos ",
		[" animals"] = " animais",
		["Eggs handled: "] = "Ovos processados: ",
		["%s stopped: %s"] = "%s parou: %s",
		["Some features can't find the game parts they need and are turned off."] = "Algumas funções foram desativadas por não encontrarem os componentes necessários do jogo.",
		["Loaded"] = "Carregado",
		["Cash %s · %s/s\n%s (%s dmg) · Carry %d/%d\nBase %s/%s animals · Level %s"] = "Dinheiro %s · %s/s\n%s (%s dano) · A transportar %d/%d\nBase %s/%s animais · Nível %s",
		["%s\nSteals %d · Eggs %d · Banked %d · +%s/min"] = "%s\nRoubos %d · Ovos %d · Guardados %d · +%s/min",
		["My Base"] = "A minha base",
		["Egg Machine"] = "Máquina de ovos",
		["Infinite Jump key"] = "Tecla de salto infinito",
	},
	es = {
        ["Sell at fish count"] = "Vender al alcanzar esta cantidad de peces",
        ["0 = sell as soon as fish are available."] = "0 = vender en cuanto haya peces.",
        ["A sale is already in progress."] = "Ya hay una venta en curso.",
        ["Wait for fishing to finish before selling."] = "Espera a que termine la pesca antes de vender.",
        ["Could not sell fish:"] = "No se pudieron vender los peces:",
		["Auto Collect Eggs"] = "Recoger Eggs automáticamente",
		["Copy egg names"] = "Copiar nombres de Eggs",
		["No egg names found in the game catalog."] = "No se encontraron nombres de Eggs en el catálogo del juego.",
		["Egg names copied from the game catalog."] = "Nombres de Eggs copiados del catálogo del juego.",
		["Egg names printed to the console."] = "Nombres de Eggs escritos en la consola.",
		["Start fishing and wait for the egg or find to appear."] = "Empieza a pescar y espera a que aparezca el Egg o hallazgo.",
		["No catches visible. Try while the egg or find is on screen."] = "No hay capturas visibles. Inténtalo mientras el Egg o hallazgo aparece en pantalla.",
		["Active find names/types and egg classification copied."] = "Nombres, tipos y clasificación de Eggs de hallazgos activos copiados.",
		["Key link copied. Open it in your browser."] = "Enlace de la clave copiado. Ábrelo en tu navegador.",
		["Open this link in your browser to get a key."] = "Abre este enlace en tu navegador para obtener una clave.",
		["The owner has not configured the key link."] = "El propietario aún no ha configurado el enlace de la clave.",
		["Dashboard"] = "Panel",
		["Library"] = "Biblioteca",
		["Games"] = "Juegos",
		["Settings"] = "Ajustes",
		["Appearance"] = "Apariencia",
		["Language"] = "Idioma",
		["Português"] = "Português",
		["English"] = "English",
		["Español"] = "Español",
		["Français"] = "Français",
		["Animations"] = "Animaciones",
		["Reduced motion"] = "Movimiento reducido",
		["Glitch effects"] = "Efectos glitch",
		["RGB accent"] = "Color RGB dinámico",
		["Interface scale"] = "Escala de la interfaz",
		["Interface transparency"] = "Transparencia de la interfaz",
		["Accent color"] = "Color de acento",
		["Red"] = "Rojo",
		["Violet"] = "Violeta",
		["Blue"] = "Azul",
		["Cyan"] = "Cian",
		["Save configuration"] = "Guardar configuración",
		["Load configuration"] = "Cargar configuración",
		["Reset appearance"] = "Restablecer apariencia",
		["Copy Discord link"] = "Copiar enlace de Discord",
		["Rejoin server"] = "Volver al servidor",
		["Server hop"] = "Cambiar de servidor",
		["Reconnect"] = "Reconectar",
		["Unload UI"] = "Cerrar la interfaz",
		["Configuration name"] = "Nombre de la configuración",
		["Restore defaults"] = "Restablecer valores predeterminados",
		["Pause automations"] = "Pausar automatizaciones",
		["Auto load current game"] = "Cargar el juego actual automáticamente",
		["Open menu"] = "Abrir menú",
		["Launch"] = "Iniciar",
		["Current game"] = "Juego actual",
		["Available"] = "Disponible",
		["Unsupported game"] = "Juego no compatible",
		["Key required"] = "Clave necesaria",
		["License key"] = "Clave de licencia",
		["Validate key"] = "Validar clave",
		["Get key"] = "Obtener clave",
		["Copy key link"] = "Copiar enlace de la clave",
		["Waiting for a key."] = "Esperando una clave.",
		["Validating key..."] = "Validando la clave...",
		["Key validated."] = "Clave validada.",
		["Key validation failed."] = "No se pudo validar la clave.",
		["Enter a valid key to continue."] = "Introduce una clave válida para continuar.",
		["Close"] = "Cerrar",
		["Supported games"] = "Juegos compatibles",
		["Choose your targets and collection settings."] = "Elige tus objetivos y opciones de recogida.",
		["Customize your session."] = "Personaliza tu sesión.",
		["Your license has been verified."] = "Tu licencia ha sido verificada.",
		["Menu and session"] = "Menú y sesión",
		["Menu bind"] = "Tecla del menú",
		["Search options in this menu..."] = "Buscar opciones en este menú...",
		["Main"] = "Principal",
		["Shop"] = "Tienda",
		["Player"] = "Jugador",
		["Info"] = "Información",
		["Fishing"] = "Pesca",
		["Finds"] = "Hallazgos",
		["Rewards"] = "Recompensas",
		["Sell"] = "Vender",
		["Codes"] = "Códigos",
		["Bait"] = "Cebo",
		["Movement"] = "Movimiento",
		["Fly"] = "Volar",
		["Menu"] = "Menú",
		["User"] = "Usuario",
		["Session"] = "Sesión",
		["Server"] = "Servidor",
		["Configuration"] = "Configuración",
		["Configurations"] = "Configuraciones",
		["Theme"] = "Tema",
		["Fishing automation"] = "Automatización de pesca",
		["Finds and fragments"] = "Hallazgos y fragmentos",
		["Sell fish"] = "Vender peces",
		["Equipment"] = "Equipo",
		["Flight"] = "Vuelo",
		["Your profile"] = "Tu perfil",
		["Current session"] = "Sesión actual",
		["Rods, bait and codes in one place."] = "Cañas, cebos y códigos en un solo lugar.",
		["Adjust movement and player options."] = "Ajusta el movimiento y las opciones del jugador.",
		["Player and session information."] = "Información del jugador y de la sesión.",
		["Customize the menu and save your settings."] = "Personaliza el menú y guarda tus ajustes.",
		["The action failed. Check the console for details."] = "La acción falló. Consulta la consola para más detalles.",
		["AUTO ACTIVE"] = "AUTO ACTIVO",
		["AUTO PAUSED"] = "AUTO PAUSADO",
		[" AUTO ACTIVE"] = " AUTO ACTIVO",
		[" · show / hide"] = " · mostrar / ocultar",
		["show / hide"] = "mostrar / ocultar",
		["RightShift · show / hide"] = "RightShift · mostrar / ocultar",
		["Select"] = "Seleccionar",
		["Select  +"] = "Seleccionar  +",
		["All / no filter"] = "Todos / sin filtro",
		["Filter options..."] = "Filtrar opciones...",
		["Press a key"] = "Pulsa una tecla",
		["Use ES to reopen the menu."] = "Usa ES para volver a abrir el menú.",
		["File saving is unavailable. Use clipboard export instead."] = "No se pueden guardar archivos. Usa la exportación al portapapeles.",
		["Configuration saved."] = "Configuración guardada.",
		["Use clipboard import to load a configuration."] = "Usa la importación del portapapeles para cargar una configuración.",
		["Configuration loaded."] = "Configuración cargada.",
		["The default profile loads on startup."] = "El perfil predeterminado se carga al iniciar.",
		["Start fishing and wait for the fragment to appear."] = "Empieza a pescar y espera a que aparezca el fragmento.",
		["No catches visible. Try while the fragment is on screen."] = "No hay capturas visibles. Prueba cuando el fragmento esté en pantalla.",
		["Active find names/types and fragment classification copied."] = "Nombres y tipos de hallazgos activos y clasificación de fragmentos copiados.",
		["Active find names/types printed to the console."] = "Nombres y tipos de hallazgos activos enviados a la consola.",
		["Bought best affordable rod"] = "Comprada la mejor caña disponible dentro del presupuesto",
		["No affordable rod"] = "Ninguna caña disponible dentro del presupuesto",
		["Sold fish"] = "Peces vendidos",
		["No fish to sell"] = "No hay peces para vender",
		["Bought best affordable bait"] = "Comprado el mejor cebo disponible dentro del presupuesto",
		["No affordable bait"] = "Ningún cebo disponible dentro del presupuesto",
		["Bait uses still remaining"] = "El cebo todavía tiene usos disponibles",
		["Used "] = "Usado: ",
		["No bait in inventory"] = "No hay cebo en el inventario",
		["Bait not found"] = "Cebo no encontrado",
		["ErrorScripts · custom interface"] = "ErrorScripts · interfaz personalizada",
		["Auto Perfect Fishing"] = "Pesca perfecta automática",
		["Auto Collect Fish"] = "Recoger peces automáticamente",
		["Fast Fishing"] = "Pesca rápida",
		["Auto Stop When Empty"] = "Parar automáticamente cuando esté vacío",
		["Collect Rarities"] = "Rarezas que recoger",
		["Collect Mutations"] = "Mutaciones que recoger",
		["Auto Favourite"] = "Favoritos automáticos",
		["Auto Collect Finds"] = "Recoger hallazgos automáticamente",
		["Auto Collect Fragments"] = "Recoger fragmentos automáticamente",
		["Copy active find names/types"] = "Copiar nombres y tipos de hallazgos activos",
		["Find Types"] = "Tipos de hallazgos",
		["Auto Claim Big Fish"] = "Recoger recompensas de peces grandes automáticamente",
		["Auto Claim Free Rewards"] = "Recoger recompensas gratis automáticamente",
		["Auto Sell"] = "Vender automáticamente",
		["Sell All Fish"] = "Vender todos los peces",
		["Auto Buy Best Bait"] = "Comprar el mejor cebo automáticamente",
		["Buy Best Bait Now"] = "Comprar el mejor cebo ahora",
		["Auto Buy Best Rod"] = "Comprar la mejor caña automáticamente",
		["Buy Best Rod Now"] = "Comprar la mejor caña ahora",
		["Upgrades"] = "Mejoras",
		["Auto Buy Upgrades"] = "Comprar mejoras automáticamente",
		["Code"] = "Código",
		["Enter code"] = "Introduce el código",
		["Redeem Code"] = "Canjear código",
		["Auto Use Best Bait"] = "Usar el mejor cebo automáticamente",
		["Use Best Bait Now"] = "Usar el mejor cebo ahora",
		["Selected"] = "Seleccionado",
		["Auto Use Bait"] = "Usar cebo automáticamente",
		["Use Bait"] = "Cebo que usar",
		["Use Bait Now"] = "Usar cebo ahora",
		["UserId"] = "ID de usuario",
		["Executor"] = "Ejecutor",
		["Game"] = "Juego",
		["Players"] = "Jugadores",
		["Job"] = "Instancia",
		["Ping"] = "Latencia",
		["Copy Username"] = "Copiar nombre de usuario",
		["Copied username"] = "Nombre de usuario copiado",
		["Copy Profile Link"] = "Copiar enlace del perfil",
		["Copied profile link"] = "Enlace del perfil copiado",
		["Rejoin Server"] = "Volver al servidor",
		["Copy Job ID"] = "Copiar ID de la instancia",
		["Copied Job ID"] = "ID de la instancia copiado",
		["Custom interface for Deep Fishing."] = "Interfaz personalizada para Deep Fishing.",
		["Drag ES to move it. Click to open."] = "Arrastra ES para moverlo. Haz clic para abrir.",
		["Customize the menu in Settings."] = "Personaliza el menú en Ajustes.",
		["WalkSpeed"] = "Velocidad de movimiento",
		["WalkSpeed Amount"] = "Valor de la velocidad de movimiento",
		["Infinite Jump"] = "Salto infinito",
		["NoClip"] = "Atravesar objetos",
		["No Gameplay Paused"] = "Ocultar aviso de juego en pausa",
		["Instant ProximityPrompt"] = "Interacción de proximidad instantánea",
		["Fly Speed"] = "Velocidad de vuelo",
		["Anti-AFK"] = "Evitar inactividad",
		["AFK triggers: 0"] = "Activaciones antiinactividad: 0",
		["AFK triggers: "] = "Activaciones antiinactividad: ",
		["Menu keybind"] = "Tecla de acceso al menú",
		["Paste exported config here"] = "Pega aquí la configuración exportada",
		["Export Config to Clipboard"] = "Exportar configuración al portapapeles",
		["Failed to encode the config"] = "No se pudo codificar la configuración",
		["Your executor does not support copying to the clipboard"] = "Tu ejecutor no permite copiar al portapapeles",
		["Config copied to clipboard"] = "Configuración copiada al portapapeles",
		["Import Config from Clipboard Text"] = "Importar configuración del texto copiado",
		["Paste an exported config into the box first"] = "Pega primero una configuración exportada en el campo",
		["That is not a valid exported config"] = "La configuración exportada no es válida",
		["No settings in that config matched this script"] = "Ningún ajuste de esa configuración corresponde a este script",
		["Imported %d setting%s"] = "Importado: %d ajuste%s",
		["Unknown"] = "Desconocido",
		["Profile "] = "Perfil ",
		["Key link copied."] = "Enlace de la clave copiado.",
		["Discord link copied."] = "Enlace de Discord copiado.",
		["Clipboard unavailable."] = "Portapapeles no disponible.",
		["Loading game..."] = "Cargando el juego...",
		["Game loaded."] = "Juego cargado.",
		["Game failed to load."] = "No se pudo cargar el juego.",
		["This game is not supported yet."] = "Este juego todavía no es compatible.",
		["Launch this hub in a supported game."] = "Inicia este hub en un juego compatible.",
		["Automations paused."] = "Automatizaciones pausadas.",
		["Appearance restored."] = "Apariencia restablecida.",
		["Settings restored."] = "Ajustes restablecidos.",
		["Searching for another server..."] = "Buscando otro servidor...",
		["No available server was found."] = "No se encontró otro servidor disponible.",
		["Reconnect failed."] = "No se pudo reconectar.",
		["Secure access"] = "Acceso seguro",
		["Ready"] = "Listo",
		["Verified"] = "Verificado",
		["Connected"] = "Conectado",
		["Loading"] = "Cargando",
		["Welcome"] = "Bienvenido",
		["Training"] = "Entrenamiento",
		["Idle"] = "En espera",
		["Coins: 0"] = "Monedas: 0",
		["Strength level: 0"] = "Nivel de fuerza: 0",
		["Speed level: 0"] = "Nivel de velocidad: 0",
		["Carrying: 0 / 0"] = "Transportando: 0 / 0",
		["Pyramids: 0"] = "Pirámides: 0",
		["Blocks placed: 0"] = "Bloques colocados: 0",
		["Coins:"] = "Monedas:",
		["Coins: "] = "Monedas: ",
		["Strength level:"] = "Nivel de fuerza:",
		["Strength level: "] = "Nivel de fuerza: ",
		["Speed level:"] = "Nivel de velocidad:",
		["Speed level: "] = "Nivel de velocidad: ",
		["Carrying:"] = "Transportando:",
		["Carrying: "] = "Transportando: ",
		["Carrying: %d / %d"] = "Transportando: %d / %d",
		["Pyramids:"] = "Pirámides:",
		["Pyramids: "] = "Pirámides: ",
		["Blocks placed:"] = "Bloques colocados:",
		["Blocks placed: "] = "Bloques colocados: ",
		["Farm, train and upgrade in one menu."] = "Construye, entrena y mejora en un solo menú.",
		["Start automation from the farming tab."] = "Inicia la automatización en la pestaña de construcción.",
		["Auto Farm"] = "Construcción automática",
		["Return On Stop"] = "Volver al parar",
		["Place Distance"] = "Distancia de colocación",
		["Spend Banked Blocks"] = "Usar bloques guardados",
		["Farm vs Training"] = "Construcción y entrenamiento",
		["When Both Are On"] = "Cuando ambos están activos",
		["Balanced"] = "Equilibrado",
		["Farm"] = "Construcción",
		["Train"] = "Entrenamiento",
		["Alternate"] = "Alternar",
		["Payback Time (min)"] = "Tiempo de retorno (min)",
		["Alternate Every (min)"] = "Alternar cada (min)",
		["Balanced trains when the extra blocks pay it back."] = "El modo equilibrado entrena cuando los bloques adicionales compensan.",
		["Gym"] = "Gimnasio",
		["Auto Train Strength"] = "Entrenar fuerza automáticamente",
		["Auto Train Speed"] = "Entrenar velocidad automáticamente",
		["Bench Gym"] = "Gimnasio de press de banca",
		["Treadmill Gym"] = "Gimnasio de cinta",
		["Best Unlocked"] = "Mejor desbloqueado",
		["Gym %s (x%d)"] = "Gimnasio %s (x%d)",
		["Waters of Nu"] = "Aguas de Nu",
		["Auto Join Pool"] = "Entrar en la piscina automáticamente",
		["Go To Pool"] = "Ir a la piscina",
		["Auto Upgrade"] = "Mejorar automáticamente",
		["Buy Now"] = "Comprar ahora",
		["Spending"] = "Gastos",
		["Order"] = "Orden",
		["Best Value"] = "Mejor relación calidad-precio",
		["Cheapest First"] = "Más barato primero",
		["In Order"] = "Por orden",
		["Keep Coins"] = "Reservar monedas",
		["Redeem All Codes"] = "Canjear todos los códigos",
		["Claim Free Gift"] = "Recoger regalo gratis",
		["Speed"] = "Velocidad",
		["Speed key"] = "Tecla de velocidad",
		["Walk Speed"] = "Velocidad de movimiento",
		["Fly key"] = "Tecla de vuelo",
		["Noclip"] = "Atravesar objetos",
		["Noclip key"] = "Tecla para atravesar objetos",
		["Teleport"] = "Teletransporte",
		["Quarry"] = "Cantera",
		["Pyramid"] = "Pirámide",
		["Pool"] = "Piscina",
		["Go To Gym"] = "Ir al gimnasio",
		["Refresh Players"] = "Actualizar jugadores",
		["Go To Player"] = "Ir al jugador",
		["Game session"] = "Sesión del juego",
		["Anti AFK"] = "Evitar inactividad",
		["Auto Rejoin"] = "Reconectar automáticamente",
		["Disable 3D Rendering"] = "Desactivar renderizado 3D",
		["FPS Boost"] = "Optimizar FPS",
		["Restore graphics"] = "Restablecer gráficos",
		["This feature needs a game update: "] = "Esta función necesita una actualización del juego: ",
		["Picking up blocks"] = "Recogiendo bloques",
		["Placing on layer %d"] = "Colocando en la capa %d",
		["Placing on layer "] = "Colocando en la capa ",
		["Bench press x%d"] = "Press de banca x%d",
		["Bench press x"] = "Press de banca x",
		["Bench refused, retrying"] = "Press de banca rechazado, reintentando",
		["Treadmill x%d"] = "Cinta x%d",
		["Treadmill x"] = "Cinta x",
		["Training in the pool"] = "Entrenando en la piscina",
		["Waiting for the next pyramid"] = "Esperando la próxima pirámide",
		[", retrying"] = ", reintentando",
		["Nothing to buy"] = "Nada que comprar",
		["Bought %s %d"] = "Comprado: %s %d",
		["Bought "] = "Comprado: ",
		[": redeemed"] = ": canjeado",
		["no reply"] = "sin respuesta",
		["Codes done, %d new"] = "Códigos canjeados: %d nuevos",
		["Codes done, "] = "Códigos canjeados: ",
		[" new"] = " nuevos",
		["banked blocks"] = "bloques guardados",
		["banked time"] = "tiempo guardado",
		[" spent"] = " usado",
		["none to spend"] = "nada que usar",
		["wait for the next pyramid"] = "espera la próxima pirámide",
		["Free gift claimed"] = "Regalo gratis recogido",
		["Join the Janitors Studios group to claim the free gift"] = "Únete al grupo Janitors Studios para recoger el regalo gratis",
		["Free gift: "] = "Regalo gratis: ",
		["Pool is not loaded yet, try again in a moment"] = "La piscina todavía no ha cargado; inténtalo de nuevo en un momento",
		["Pool opens when a pyramid is completed"] = "La piscina se abre al completar una pirámide",
		["Player not found"] = "Jugador no encontrado",
		["Server list unavailable"] = "Lista de servidores no disponible",
		["No other server found"] = "No se encontró otro servidor",
		["FPS boost applied"] = "Optimización de FPS aplicada",
		[" stopped: "] = " detenido: ",
		["None"] = "Ninguno",
		["Particles"] = "Partículas",
		["Watermark"] = "Marca de agua",
		["Session controls"] = "Controles de la sesión",
		["The hub loads only the game you are playing."] = "El hub carga únicamente el juego en el que estás.",
		["Ready to launch."] = "Listo para iniciar.",
		["Loading game module..."] = "Cargando el módulo del juego...",
		["Game module loaded."] = "Módulo del juego cargado.",
		["Game module failed to start. Check the console and run the hub again."] = "El módulo del juego no se inició. Consulta la consola y vuelve a ejecutar el hub.",
		["Copied to clipboard."] = "Copiado al portapapeles.",
		["Could not reconnect. Try again."] = "No se pudo reconectar. Inténtalo de nuevo.",
		["No other available server was found."] = "No se encontró otro servidor disponible.",
		["Server search failed. Try again."] = "La búsqueda de servidores falló. Inténtalo de nuevo.",
		["SYSTEM ONLINE"] = "SISTEMA EN LÍNEA",
		["ERROR // ACCESS"] = "ERROR // ACCESO",
		["Two games. One ErrorScripts menu."] = "Dos juegos. Un menú ErrorScripts.",
		["Choose your training and movement settings."] = "Elige las opciones de entrenamiento y movimiento.",
		["Run the hub again after teleporting."] = "Vuelve a ejecutar el hub después del teletransporte.",
		-- Break and Steal an Egg display text. Engine IDs and player names remain unchanged.
		["Three games. One ErrorScripts menu."] = "Tres juegos. Un menú ErrorScripts.",
		["Steal & Break"] = "Robar y romper",
		["Base & Shop"] = "Base y tienda",
		["Visuals"] = "Visuales",
		["Troll"] = "Troll",
		["Steal animals and break eggs."] = "Roba animales y rompe huevos.",
		["Animals, upgrades and rewards."] = "Animales, mejoras y recompensas.",
		["See animals, eggs and players."] = "Ve animales, huevos y jugadores.",
		["Bat and player interactions."] = "Bate e interacciones con jugadores.",
		["Status and all-in-one mode"] = "Estado y modo completo",
		["Status"] = "Estado",
		["Loading..."] = "Cargando...",
		["Kaitun"] = "Kaitun",
		["Kaitun (All-in-one)"] = "Kaitun (Todo en uno)",
		["Steals, breaks eggs, places, sells, upgrades and claims rewards by itself"] = "Roba, rompe huevos, coloca animales, vende, compra mejoras y recoge recompensas automáticamente",
		["Discord"] = "Discord",
		["Copy Discord Link"] = "Copiar enlace de Discord",
		["Update Log"] = "Historial de actualizaciones",
		["Farming"] = "Farm",
		["Steal animals and break eggs"] = "Roba animales y rompe huevos",
		["Auto Steal"] = "Robar automáticamente",
		["Grabs the most valuable animals on the map and brings them home instantly"] = "Recoge los animales más valiosos del mapa y los lleva a tu base al instante",
		["Take"] = "Recoger",
		["Upgrades Only = only animals that earn more than your weakest one"] = "Solo mejoras = solo animales que ganan más que el más débil de tu base",
		["Only Rarities"] = "Solo estas rarezas",
		["Empty = take everything"] = "Vacío = recoger todo",
		["Min Cash/s"] = "Dinero/s mínimo",
		["Steal Best Now"] = "Robar el mejor ahora",
		["Bank Now"] = "Guardar en la base ahora",
		["Auto Break"] = "Romper automáticamente",
		["Auto Break Eggs"] = "Romper huevos automáticamente",
		["Breaks eggs in any zone at max speed and takes the animal home"] = "Rompe huevos en cualquier zona a máxima velocidad y lleva el animal a tu base",
		["Zone"] = "Zona",
		["Best = most worth for the time spent"] = "Mejor = mayor beneficio por el tiempo invertido",
		["Max Hits Per Egg"] = "Máximo de golpes por huevo",
		["Skips eggs that take longer than this"] = "Omite huevos que necesiten más golpes",
		["Rob Players"] = "Robar a jugadores",
		["Rob Carriers"] = "Robar a quienes llevan animales",
		["Bats players carrying animals and takes what they drop"] = "Golpea con el bate a quienes llevan animales y recoge lo que sueltan",
		["Progression"] = "Progreso",
		["Placing, selling, upgrades and rewards"] = "Colocación, ventas, mejoras y recompensas",
		["Animals"] = "Animales",
		["Auto Place Best"] = "Colocar los mejores automáticamente",
		["Keeps the best earners standing on your base"] = "Mantiene los animales más rentables en tu base",
		["Place Best Now"] = "Colocar los mejores ahora",
		["Auto Sell Leftovers"] = "Vender los restantes automáticamente",
		["Sells animals in your backpack that did not fit on the base"] = "Vende los animales de tu mochila que no caben en la base",
		["Never Sell"] = "Nunca vender",
		["Sell All Now"] = "Vender todos ahora",
		["Buys the picked upgrades as soon as you can pay"] = "Compra las mejoras seleccionadas en cuanto tienes dinero suficiente",
		["Upgrade"] = "Mejora",
		["Pickaxe jumps to the best you can afford, Trail buys and wears the strongest"] = "El pico pasa al mejor que puedes pagar; la estela compra y equipa la más fuerte",
		["Upgrade Now"] = "Mejorar ahora",
		["Keep Cash"] = "Dinero a reservar",
		["Upgrades never spend below this"] = "Las mejoras nunca gastan el dinero reservado",
		["Eggs"] = "Huevos",
		["Auto Hatch Eggs"] = "Incubar huevos automáticamente",
		["Places eggs from your backpack on your base and hatches them when ready"] = "Coloca los huevos de tu mochila en la base y los incuba cuando están listos",
		["Hatch Eggs Now"] = "Incubar huevos ahora",
		["Auto Claim"] = "Recoger recompensas automáticamente",
		["Claims index, offline, group and community rewards, no joining needed"] = "Recoge recompensas del índice, offline, de grupo y de la comunidad, sin necesidad de unirte",
		["Claim Now"] = "Recoger ahora",
		["Movement and teleports"] = "Movimiento y teletransportes",
		["Place"] = "Lugar",
		["See animals, eggs and players"] = "Ve animales, huevos y jugadores",
		["ESP"] = "ESP",
		["Name, rarity, weight and cash per second"] = "Nombre, rareza, peso y dinero por segundo",
		["Min Rarity"] = "Rareza mínima",
		["Eggs & Players"] = "Huevos y jugadores",
		["HP and how many hits it takes"] = "Vida y número de golpes necesarios",
		["Distance and what they carry"] = "Distancia y lo que llevan",
		["Bat other players"] = "Usar el bate contra otros jugadores",
		["Bat"] = "Bate",
		["Target"] = "Objetivo",
		["Loop Bat Target"] = "Golpear al objetivo repetidamente",
		["Follows the target and keeps knocking them over"] = "Sigue al objetivo y lo derriba repetidamente",
		["Bat Target Now"] = "Golpear al objetivo ahora",
		["Bat Aura"] = "Aura del bate",
		["Knocks over anyone who gets close"] = "Derriba a quienes se acercan",
		["Stops the idle kick"] = "Evita la expulsión por inactividad",
		["Rejoins by itself after a disconnect"] = "Vuelve al juego automáticamente tras una desconexión",
		["Rejoin Now"] = "Volver al juego ahora",
		["Not available after a game update"] = "No disponible tras una actualización del juego",
		["Not available on this executor"] = "No disponible en este executor",
		["Misc"] = "Varios",
		["Upgrades Only"] = "Solo mejoras",
		["Everything"] = "Todo",
		["Pickaxe"] = "Pico",
		["Base"] = "Base",
		["Trail"] = "Estela",
		["Treadmill"] = "Cinta de correr",
		["Common"] = "Común",
		["Uncommon"] = "Poco común",
		["Rare"] = "Raro",
		["Epic"] = "Épico",
		["Legendary"] = "Legendario",
		["Mythic"] = "Mítico",
		["Mythical"] = "Mítico",
		["Secret"] = "Secreto",
		["Divine"] = "Divino",
		["Cash:"] = "Dinero:",
		["Income/s:"] = "Ingresos/s:",
		["Pickaxe:"] = "Pico:",
		["Damage:"] = "Daño:",
		["Base animals:"] = "Animales en la base:",
		["Base level:"] = "Nivel de la base:",
		["Steals:"] = "Robos:",
		["Eggs broken:"] = "Huevos rotos:",
		["Animals banked:"] = "Animales guardados:",
		["Cash/min:"] = "Dinero/min:",
		["Status:"] = "Estado:",
		["Steal animals, break eggs and upgrade your base."] = "Roba animales, rompe huevos y mejora tu base.",
		["This feature needs a game update:"] = "Esta función necesita una actualización del juego:",
		["Some features could not find their game dependencies."] = "Algunas funciones no encontraron las dependencias necesarias del juego.",
		["Auto Steal key"] = "Tecla para robar automáticamente",
		["Auto Break Eggs key"] = "Tecla para romper huevos automáticamente",
		["Auto Place Best key"] = "Tecla para colocar los mejores automáticamente",
		["Auto Sell Leftovers key"] = "Tecla para vender los restantes automáticamente",
		["Auto Upgrade key"] = "Tecla para mejorar automáticamente",
		["Auto Hatch Eggs key"] = "Tecla para incubar huevos automáticamente",
		["Auto Claim key"] = "Tecla para recoger recompensas automáticamente",
		["Loop Bat Target key"] = "Tecla para golpear al objetivo repetidamente",
		["Bat Aura key"] = "Tecla del aura del bate",
		["Kaitun (All-in-one) key"] = "Tecla de Kaitun (Todo en uno)",
		["Banking"] = "Guardando en la base",
		["Stealing "] = "Robando ",
		["No pickaxe"] = "Sin pico",
		["Breaking %s (Zone %s)"] = "Rompiendo %s (Zona %s)",
		["Breaking "] = "Rompiendo ",
		[" (Zone "] = " (Zona ",
		["Robbing "] = "Robando a ",
		["Waiting for respawn"] = "Esperando a reaparecer",
		["No egg beats your base yet"] = "Ningún huevo supera aún a los animales de tu base",
		["Waiting for animals better than your base"] = "Esperando animales mejores que los de tu base",
		["Nothing to upgrade yet: not enough cash or already maxed"] = "Nada que mejorar: dinero insuficiente o nivel máximo alcanzado",
		["Sold %d animals"] = "Vendidos %d animales",
		["Eggs handled: %d"] = "Huevos procesados: %d",
		["Sold "] = "Vendidos ",
		[" animals"] = " animales",
		["Eggs handled: "] = "Huevos procesados: ",
		["%s stopped: %s"] = "%s se detuvo: %s",
		["Some features can't find the game parts they need and are turned off."] = "Algunas funciones se desactivaron porque no encontraron los componentes necesarios del juego.",
		["Loaded"] = "Cargado",
		["Cash %s · %s/s\n%s (%s dmg) · Carry %d/%d\nBase %s/%s animals · Level %s"] = "Dinero %s · %s/s\n%s (%s daño) · Transportando %d/%d\nBase %s/%s animales · Nivel %s",
		["%s\nSteals %d · Eggs %d · Banked %d · +%s/min"] = "%s\nRobos %d · Huevos %d · Guardados %d · +%s/min",
		["My Base"] = "Mi base",
		["Egg Machine"] = "Máquina de huevos",
		["Infinite Jump key"] = "Tecla de salto infinito",
	},
	fr = {
        ["Sell at fish count"] = "Vendre à ce nombre de poissons",
        ["0 = sell as soon as fish are available."] = "0 = vendre dès que des poissons sont disponibles.",
        ["A sale is already in progress."] = "Une vente est déjà en cours.",
        ["Wait for fishing to finish before selling."] = "Attendez la fin de la pêche avant de vendre.",
        ["Could not sell fish:"] = "Impossible de vendre les poissons :",
		["Auto Collect Eggs"] = "Collecter les Eggs automatiquement",
		["Copy egg names"] = "Copier les noms des Eggs",
		["No egg names found in the game catalog."] = "Aucun nom d’Egg trouvé dans le catalogue du jeu.",
		["Egg names copied from the game catalog."] = "Noms des Eggs copiés depuis le catalogue du jeu.",
		["Egg names printed to the console."] = "Noms des Eggs affichés dans la console.",
		["Start fishing and wait for the egg or find to appear."] = "Commence à pêcher et attends que l’Egg ou l’objet apparaisse.",
		["No catches visible. Try while the egg or find is on screen."] = "Aucune capture visible. Réessaie quand l’Egg ou l’objet apparaît à l’écran.",
		["Active find names/types and egg classification copied."] = "Noms, types et classification des Eggs des objets actifs copiés.",
		["Key link copied. Open it in your browser."] = "Lien de la clé copié. Ouvrez-le dans votre navigateur.",
		["Open this link in your browser to get a key."] = "Ouvrez ce lien dans votre navigateur pour obtenir une clé.",
		["The owner has not configured the key link."] = "Le propriétaire n’a pas encore configuré le lien de la clé.",
		["Dashboard"] = "Tableau de bord",
		["Library"] = "Bibliothèque",
		["Games"] = "Jeux",
		["Settings"] = "Paramètres",
		["Appearance"] = "Apparence",
		["Language"] = "Langue",
		["Português"] = "Português",
		["English"] = "English",
		["Español"] = "Español",
		["Français"] = "Français",
		["Animations"] = "Animations",
		["Reduced motion"] = "Animations réduites",
		["Glitch effects"] = "Effets de glitch",
		["RGB accent"] = "Couleur RVB dynamique",
		["Interface scale"] = "Échelle de l’interface",
		["Interface transparency"] = "Transparence de l’interface",
		["Accent color"] = "Couleur d’accent",
		["Red"] = "Rouge",
		["Violet"] = "Violet",
		["Blue"] = "Bleu",
		["Cyan"] = "Cyan",
		["Save configuration"] = "Enregistrer la configuration",
		["Load configuration"] = "Charger la configuration",
		["Reset appearance"] = "Réinitialiser l’apparence",
		["Copy Discord link"] = "Copier le lien Discord",
		["Rejoin server"] = "Rejoindre le serveur",
		["Server hop"] = "Changer de serveur",
		["Reconnect"] = "Se reconnecter",
		["Unload UI"] = "Fermer l’interface",
		["Configuration name"] = "Nom de la configuration",
		["Restore defaults"] = "Rétablir les valeurs par défaut",
		["Pause automations"] = "Suspendre les automatismes",
		["Auto load current game"] = "Charger le jeu actuel automatiquement",
		["Open menu"] = "Ouvrir le menu",
		["Launch"] = "Lancer",
		["Current game"] = "Jeu actuel",
		["Available"] = "Disponible",
		["Unsupported game"] = "Jeu non pris en charge",
		["Key required"] = "Clé requise",
		["License key"] = "Clé de licence",
		["Validate key"] = "Valider la clé",
		["Get key"] = "Obtenir une clé",
		["Copy key link"] = "Copier le lien de la clé",
		["Waiting for a key."] = "En attente d’une clé.",
		["Validating key..."] = "Validation de la clé...",
		["Key validated."] = "Clé validée.",
		["Key validation failed."] = "La validation de la clé a échoué.",
		["Enter a valid key to continue."] = "Saisissez une clé valide pour continuer.",
		["Close"] = "Fermer",
		["Supported games"] = "Jeux pris en charge",
		["Choose your targets and collection settings."] = "Choisissez vos cibles et vos options de collecte.",
		["Customize your session."] = "Personnalisez votre session.",
		["Your license has been verified."] = "Votre licence a été vérifiée.",
		["Menu and session"] = "Menu et session",
		["Menu bind"] = "Touche du menu",
		["Search options in this menu..."] = "Rechercher des options dans ce menu...",
		["Main"] = "Principal",
		["Shop"] = "Boutique",
		["Player"] = "Joueur",
		["Info"] = "Informations",
		["Fishing"] = "Pêche",
		["Finds"] = "Trouvailles",
		["Rewards"] = "Récompenses",
		["Sell"] = "Vendre",
		["Codes"] = "Codes",
		["Bait"] = "Appât",
		["Movement"] = "Déplacement",
		["Fly"] = "Voler",
		["Menu"] = "Menu",
		["User"] = "Utilisateur",
		["Session"] = "Session",
		["Server"] = "Serveur",
		["Configuration"] = "Configuration",
		["Configurations"] = "Configurations",
		["Theme"] = "Thème",
		["Fishing automation"] = "Pêche automatique",
		["Finds and fragments"] = "Trouvailles et fragments",
		["Sell fish"] = "Vendre les poissons",
		["Equipment"] = "Équipement",
		["Flight"] = "Vol",
		["Your profile"] = "Votre profil",
		["Current session"] = "Session actuelle",
		["Rods, bait and codes in one place."] = "Cannes, appâts et codes au même endroit.",
		["Adjust movement and player options."] = "Réglez le déplacement et les options du joueur.",
		["Player and session information."] = "Informations sur le joueur et la session.",
		["Customize the menu and save your settings."] = "Personnalisez le menu et enregistrez vos paramètres.",
		["The action failed. Check the console for details."] = "L’action a échoué. Consultez la console pour plus de détails.",
		["AUTO ACTIVE"] = "AUTO ACTIF",
		["AUTO PAUSED"] = "AUTO EN PAUSE",
		[" AUTO ACTIVE"] = " AUTO ACTIF",
		[" · show / hide"] = " · afficher / masquer",
		["show / hide"] = "afficher / masquer",
		["RightShift · show / hide"] = "RightShift · afficher / masquer",
		["Select"] = "Sélectionner",
		["Select  +"] = "Sélectionner  +",
		["All / no filter"] = "Tous / aucun filtre",
		["Filter options..."] = "Filtrer les options...",
		["Press a key"] = "Appuyez sur une touche",
		["Use ES to reopen the menu."] = "Utilisez ES pour rouvrir le menu.",
		["File saving is unavailable. Use clipboard export instead."] = "L’enregistrement de fichiers est indisponible. Utilisez l’exportation vers le presse-papiers.",
		["Configuration saved."] = "Configuration enregistrée.",
		["Use clipboard import to load a configuration."] = "Utilisez l’importation du presse-papiers pour charger une configuration.",
		["Configuration loaded."] = "Configuration chargée.",
		["The default profile loads on startup."] = "Le profil par défaut est chargé au démarrage.",
		["Start fishing and wait for the fragment to appear."] = "Commencez à pêcher et attendez l’apparition du fragment.",
		["No catches visible. Try while the fragment is on screen."] = "Aucune prise visible. Réessayez lorsque le fragment est à l’écran.",
		["Active find names/types and fragment classification copied."] = "Noms et types des trouvailles actives et classification des fragments copiés.",
		["Active find names/types printed to the console."] = "Noms et types des trouvailles actives affichés dans la console.",
		["Bought best affordable rod"] = "Meilleure canne abordable achetée",
		["No affordable rod"] = "Aucune canne abordable",
		["Sold fish"] = "Poissons vendus",
		["No fish to sell"] = "Aucun poisson à vendre",
		["Bought best affordable bait"] = "Meilleur appât abordable acheté",
		["No affordable bait"] = "Aucun appât abordable",
		["Bait uses still remaining"] = "L’appât peut encore être utilisé",
		["Used "] = "Utilisé : ",
		["No bait in inventory"] = "Aucun appât dans l’inventaire",
		["Bait not found"] = "Appât introuvable",
		["ErrorScripts · custom interface"] = "ErrorScripts · interface personnalisée",
		["Auto Perfect Fishing"] = "Pêche parfaite automatique",
		["Auto Collect Fish"] = "Collecter les poissons automatiquement",
		["Fast Fishing"] = "Pêche rapide",
		["Auto Stop When Empty"] = "Arrêter automatiquement quand c’est vide",
		["Collect Rarities"] = "Raretés à collecter",
		["Collect Mutations"] = "Mutations à collecter",
		["Auto Favourite"] = "Favoris automatiques",
		["Auto Collect Finds"] = "Collecter les trouvailles automatiquement",
		["Auto Collect Fragments"] = "Collecter les fragments automatiquement",
		["Copy active find names/types"] = "Copier les noms et types des trouvailles actives",
		["Find Types"] = "Types de trouvailles",
		["Auto Claim Big Fish"] = "Réclamer les récompenses de gros poissons automatiquement",
		["Auto Claim Free Rewards"] = "Réclamer les récompenses gratuites automatiquement",
		["Auto Sell"] = "Vendre automatiquement",
		["Sell All Fish"] = "Vendre tous les poissons",
		["Auto Buy Best Bait"] = "Acheter le meilleur appât automatiquement",
		["Buy Best Bait Now"] = "Acheter le meilleur appât maintenant",
		["Auto Buy Best Rod"] = "Acheter la meilleure canne automatiquement",
		["Buy Best Rod Now"] = "Acheter la meilleure canne maintenant",
		["Upgrades"] = "Améliorations",
		["Auto Buy Upgrades"] = "Acheter les améliorations automatiquement",
		["Code"] = "Code",
		["Enter code"] = "Saisissez le code",
		["Redeem Code"] = "Utiliser le code",
		["Auto Use Best Bait"] = "Utiliser le meilleur appât automatiquement",
		["Use Best Bait Now"] = "Utiliser le meilleur appât maintenant",
		["Selected"] = "Sélectionné",
		["Auto Use Bait"] = "Utiliser l’appât automatiquement",
		["Use Bait"] = "Appât à utiliser",
		["Use Bait Now"] = "Utiliser l’appât maintenant",
		["UserId"] = "ID utilisateur",
		["Executor"] = "Exécuteur",
		["Game"] = "Jeu",
		["Players"] = "Joueurs",
		["Job"] = "Instance",
		["Ping"] = "Latence",
		["Copy Username"] = "Copier le nom d’utilisateur",
		["Copied username"] = "Nom d’utilisateur copié",
		["Copy Profile Link"] = "Copier le lien du profil",
		["Copied profile link"] = "Lien du profil copié",
		["Rejoin Server"] = "Rejoindre le serveur",
		["Copy Job ID"] = "Copier l’ID de l’instance",
		["Copied Job ID"] = "ID de l’instance copié",
		["Custom interface for Deep Fishing."] = "Interface personnalisée pour Deep Fishing.",
		["Drag ES to move it. Click to open."] = "Faites glisser ES pour le déplacer. Cliquez pour ouvrir.",
		["Customize the menu in Settings."] = "Personnalisez le menu dans les Paramètres.",
		["WalkSpeed"] = "Vitesse de déplacement",
		["WalkSpeed Amount"] = "Valeur de la vitesse de déplacement",
		["Infinite Jump"] = "Saut infini",
		["NoClip"] = "Traverser les objets",
		["No Gameplay Paused"] = "Masquer l’avis de jeu en pause",
		["Instant ProximityPrompt"] = "Interaction de proximité instantanée",
		["Fly Speed"] = "Vitesse de vol",
		["Anti-AFK"] = "Éviter l’inactivité",
		["AFK triggers: 0"] = "Déclenchements anti-inactivité : 0",
		["AFK triggers: "] = "Déclenchements anti-inactivité : ",
		["Menu keybind"] = "Raccourci du menu",
		["Paste exported config here"] = "Collez ici la configuration exportée",
		["Export Config to Clipboard"] = "Exporter la configuration vers le presse-papiers",
		["Failed to encode the config"] = "Impossible de coder la configuration",
		["Your executor does not support copying to the clipboard"] = "Votre exécuteur ne permet pas de copier dans le presse-papiers",
		["Config copied to clipboard"] = "Configuration copiée dans le presse-papiers",
		["Import Config from Clipboard Text"] = "Importer la configuration à partir du texte copié",
		["Paste an exported config into the box first"] = "Collez d’abord une configuration exportée dans le champ",
		["That is not a valid exported config"] = "La configuration exportée n’est pas valide",
		["No settings in that config matched this script"] = "Aucun paramètre de cette configuration ne correspond à ce script",
		["Imported %d setting%s"] = "Importation : %d réglage%s",
		["Unknown"] = "Inconnu",
		["Profile "] = "Profil ",
		["Key link copied."] = "Lien de la clé copié.",
		["Discord link copied."] = "Lien Discord copié.",
		["Clipboard unavailable."] = "Presse-papiers indisponible.",
		["Loading game..."] = "Chargement du jeu...",
		["Game loaded."] = "Jeu chargé.",
		["Game failed to load."] = "Impossible de charger le jeu.",
		["This game is not supported yet."] = "Ce jeu n’est pas encore pris en charge.",
		["Launch this hub in a supported game."] = "Lancez ce hub dans un jeu pris en charge.",
		["Automations paused."] = "Automatismes suspendus.",
		["Appearance restored."] = "Apparence réinitialisée.",
		["Settings restored."] = "Paramètres réinitialisés.",
		["Searching for another server..."] = "Recherche d’un autre serveur...",
		["No available server was found."] = "Aucun autre serveur disponible trouvé.",
		["Reconnect failed."] = "La reconnexion a échoué.",
		["Secure access"] = "Accès sécurisé",
		["Ready"] = "Prêt",
		["Verified"] = "Vérifié",
		["Connected"] = "Connecté",
		["Loading"] = "Chargement",
		["Welcome"] = "Bienvenue",
		["Training"] = "Entraînement",
		["Idle"] = "En attente",
		["Coins: 0"] = "Pièces : 0",
		["Strength level: 0"] = "Niveau de force : 0",
		["Speed level: 0"] = "Niveau de vitesse : 0",
		["Carrying: 0 / 0"] = "Transport : 0 / 0",
		["Pyramids: 0"] = "Pyramides : 0",
		["Blocks placed: 0"] = "Blocs placés : 0",
		["Coins:"] = "Pièces :",
		["Coins: "] = "Pièces : ",
		["Strength level:"] = "Niveau de force :",
		["Strength level: "] = "Niveau de force : ",
		["Speed level:"] = "Niveau de vitesse :",
		["Speed level: "] = "Niveau de vitesse : ",
		["Carrying:"] = "Transport :",
		["Carrying: "] = "Transport : ",
		["Carrying: %d / %d"] = "Transport : %d / %d",
		["Pyramids:"] = "Pyramides :",
		["Pyramids: "] = "Pyramides : ",
		["Blocks placed:"] = "Blocs placés :",
		["Blocks placed: "] = "Blocs placés : ",
		["Farm, train and upgrade in one menu."] = "Construisez, entraînez-vous et améliorez-vous dans un seul menu.",
		["Start automation from the farming tab."] = "Lancez l’automatisation depuis l’onglet de construction.",
		["Auto Farm"] = "Construction automatique",
		["Return On Stop"] = "Revenir à l’arrêt",
		["Place Distance"] = "Distance de placement",
		["Spend Banked Blocks"] = "Utiliser les blocs stockés",
		["Farm vs Training"] = "Construction et entraînement",
		["When Both Are On"] = "Lorsque les deux sont actifs",
		["Balanced"] = "Équilibré",
		["Farm"] = "Construction",
		["Train"] = "Entraînement",
		["Alternate"] = "Alterner",
		["Payback Time (min)"] = "Temps de rentabilité (min)",
		["Alternate Every (min)"] = "Alterner toutes les (min)",
		["Balanced trains when the extra blocks pay it back."] = "Le mode équilibré s’entraîne lorsque les blocs supplémentaires le rentabilisent.",
		["Gym"] = "Salle de sport",
		["Auto Train Strength"] = "Entraîner la force automatiquement",
		["Auto Train Speed"] = "Entraîner la vitesse automatiquement",
		["Bench Gym"] = "Salle de développé couché",
		["Treadmill Gym"] = "Salle de tapis de course",
		["Best Unlocked"] = "Meilleur débloqué",
		["Gym %s (x%d)"] = "Salle %s (x%d)",
		["Waters of Nu"] = "Eaux de Nu",
		["Auto Join Pool"] = "Rejoindre la piscine automatiquement",
		["Go To Pool"] = "Aller à la piscine",
		["Auto Upgrade"] = "Améliorer automatiquement",
		["Buy Now"] = "Acheter maintenant",
		["Spending"] = "Dépenses",
		["Order"] = "Ordre",
		["Best Value"] = "Meilleur rapport qualité-prix",
		["Cheapest First"] = "Moins cher d’abord",
		["In Order"] = "Dans l’ordre",
		["Keep Coins"] = "Réserver des pièces",
		["Redeem All Codes"] = "Utiliser tous les codes",
		["Claim Free Gift"] = "Réclamer le cadeau gratuit",
		["Speed"] = "Vitesse",
		["Speed key"] = "Touche de vitesse",
		["Walk Speed"] = "Vitesse de déplacement",
		["Fly key"] = "Touche de vol",
		["Noclip"] = "Traverser les objets",
		["Noclip key"] = "Touche pour traverser les objets",
		["Teleport"] = "Téléportation",
		["Quarry"] = "Carrière",
		["Pyramid"] = "Pyramide",
		["Pool"] = "Piscine",
		["Go To Gym"] = "Aller à la salle de sport",
		["Refresh Players"] = "Actualiser les joueurs",
		["Go To Player"] = "Aller vers le joueur",
		["Game session"] = "Session du jeu",
		["Anti AFK"] = "Éviter l’inactivité",
		["Auto Rejoin"] = "Se reconnecter automatiquement",
		["Disable 3D Rendering"] = "Désactiver le rendu 3D",
		["FPS Boost"] = "Optimiser les FPS",
		["Restore graphics"] = "Rétablir les graphismes",
		["This feature needs a game update: "] = "Cette fonction nécessite une mise à jour du jeu : ",
		["Picking up blocks"] = "Collecte de blocs",
		["Placing on layer %d"] = "Placement sur la couche %d",
		["Placing on layer "] = "Placement sur la couche ",
		["Bench press x%d"] = "Développé couché x%d",
		["Bench press x"] = "Développé couché x",
		["Bench refused, retrying"] = "Développé couché refusé, nouvel essai",
		["Treadmill x%d"] = "Tapis de course x%d",
		["Treadmill x"] = "Tapis de course x",
		["Training in the pool"] = "Entraînement dans la piscine",
		["Waiting for the next pyramid"] = "En attente de la prochaine pyramide",
		[", retrying"] = ", nouvel essai",
		["Nothing to buy"] = "Rien à acheter",
		["Bought %s %d"] = "Achat : %s %d",
		["Bought "] = "Achat : ",
		[": redeemed"] = " : utilisé",
		["no reply"] = "aucune réponse",
		["Codes done, %d new"] = "Codes utilisés : %d nouveaux",
		["Codes done, "] = "Codes utilisés : ",
		[" new"] = " nouveaux",
		["banked blocks"] = "blocs stockés",
		["banked time"] = "temps stocké",
		[" spent"] = " utilisé",
		["none to spend"] = "rien à utiliser",
		["wait for the next pyramid"] = "attendez la prochaine pyramide",
		["Free gift claimed"] = "Cadeau gratuit réclamé",
		["Join the Janitors Studios group to claim the free gift"] = "Rejoignez le groupe Janitors Studios pour réclamer le cadeau gratuit",
		["Free gift: "] = "Cadeau gratuit : ",
		["Pool is not loaded yet, try again in a moment"] = "La piscine n’est pas encore chargée ; réessayez dans un instant",
		["Pool opens when a pyramid is completed"] = "La piscine ouvre lorsqu’une pyramide est terminée",
		["Player not found"] = "Joueur introuvable",
		["Server list unavailable"] = "Liste des serveurs indisponible",
		["No other server found"] = "Aucun autre serveur trouvé",
		["FPS boost applied"] = "Optimisation des FPS appliquée",
		[" stopped: "] = " arrêté : ",
		["None"] = "Aucun",
		["Particles"] = "Particules",
		["Watermark"] = "Filigrane",
		["Session controls"] = "Commandes de session",
		["The hub loads only the game you are playing."] = "Le hub charge uniquement le jeu auquel vous jouez.",
		["Ready to launch."] = "Prêt à lancer.",
		["Loading game module..."] = "Chargement du module du jeu...",
		["Game module loaded."] = "Module du jeu chargé.",
		["Game module failed to start. Check the console and run the hub again."] = "Le module du jeu n’a pas démarré. Consultez la console et relancez le hub.",
		["Copied to clipboard."] = "Copié dans le presse-papiers.",
		["Could not reconnect. Try again."] = "Impossible de se reconnecter. Réessayez.",
		["No other available server was found."] = "Aucun autre serveur disponible trouvé.",
		["Server search failed. Try again."] = "La recherche de serveurs a échoué. Réessayez.",
		["SYSTEM ONLINE"] = "SYSTÈME EN LIGNE",
		["ERROR // ACCESS"] = "ERROR // ACCÈS",
		["Two games. One ErrorScripts menu."] = "Deux jeux. Un menu ErrorScripts.",
		["Choose your training and movement settings."] = "Choisissez vos options d’entraînement et de déplacement.",
		["Run the hub again after teleporting."] = "Relancez le hub après la téléportation.",
		-- Break and Steal an Egg display text. Engine IDs and player names remain unchanged.
		["Three games. One ErrorScripts menu."] = "Trois jeux. Un menu ErrorScripts.",
		["Steal & Break"] = "Voler et casser",
		["Base & Shop"] = "Base et boutique",
		["Visuals"] = "Affichage",
		["Troll"] = "Troll",
		["Steal animals and break eggs."] = "Volez des animaux et cassez des œufs.",
		["Animals, upgrades and rewards."] = "Animaux, améliorations et récompenses.",
		["See animals, eggs and players."] = "Repérez les animaux, les œufs et les joueurs.",
		["Bat and player interactions."] = "Batte et interactions avec les joueurs.",
		["Status and all-in-one mode"] = "État et mode complet",
		["Status"] = "État",
		["Loading..."] = "Chargement...",
		["Kaitun"] = "Kaitun",
		["Kaitun (All-in-one)"] = "Kaitun (Tout-en-un)",
		["Steals, breaks eggs, places, sells, upgrades and claims rewards by itself"] = "Vole, casse des œufs, place des animaux, vend, achète des améliorations et récupère les récompenses automatiquement",
		["Discord"] = "Discord",
		["Copy Discord Link"] = "Copier le lien Discord",
		["Update Log"] = "Historique des mises à jour",
		["Farming"] = "Farm",
		["Steal animals and break eggs"] = "Volez des animaux et cassez des œufs",
		["Auto Steal"] = "Vol automatique",
		["Grabs the most valuable animals on the map and brings them home instantly"] = "Récupère les animaux les plus précieux de la carte et les ramène instantanément à votre base",
		["Take"] = "Récupérer",
		["Upgrades Only = only animals that earn more than your weakest one"] = "Améliorations uniquement = seulement les animaux qui rapportent plus que le moins rentable de votre base",
		["Only Rarities"] = "Raretés sélectionnées",
		["Empty = take everything"] = "Aucune sélection = tout récupérer",
		["Min Cash/s"] = "Revenu/s minimum",
		["Steal Best Now"] = "Voler le meilleur maintenant",
		["Bank Now"] = "Déposer à la base maintenant",
		["Auto Break"] = "Cassage automatique",
		["Auto Break Eggs"] = "Casser les œufs automatiquement",
		["Breaks eggs in any zone at max speed and takes the animal home"] = "Casse les œufs dans n’importe quelle zone à vitesse maximale et ramène l’animal à votre base",
		["Zone"] = "Zone",
		["Best = most worth for the time spent"] = "Meilleur = meilleur rendement pour le temps consacré",
		["Max Hits Per Egg"] = "Nombre maximum de coups par œuf",
		["Skips eggs that take longer than this"] = "Ignore les œufs qui nécessitent davantage de coups",
		["Rob Players"] = "Voler aux joueurs",
		["Rob Carriers"] = "Voler aux joueurs qui transportent des animaux",
		["Bats players carrying animals and takes what they drop"] = "Frappe avec la batte les joueurs qui transportent des animaux et récupère ce qu’ils lâchent",
		["Progression"] = "Progression",
		["Placing, selling, upgrades and rewards"] = "Placement, ventes, améliorations et récompenses",
		["Animals"] = "Animaux",
		["Auto Place Best"] = "Placer les meilleurs automatiquement",
		["Keeps the best earners standing on your base"] = "Garde les animaux les plus rentables dans votre base",
		["Place Best Now"] = "Placer les meilleurs maintenant",
		["Auto Sell Leftovers"] = "Vendre les animaux restants automatiquement",
		["Sells animals in your backpack that did not fit on the base"] = "Vend les animaux de votre sac qui n’ont pas trouvé de place dans la base",
		["Never Sell"] = "Ne jamais vendre",
		["Sell All Now"] = "Tout vendre maintenant",
		["Buys the picked upgrades as soon as you can pay"] = "Achète les améliorations sélectionnées dès que vous avez assez d’argent",
		["Upgrade"] = "Amélioration",
		["Pickaxe jumps to the best you can afford, Trail buys and wears the strongest"] = "La pioche passe à la meilleure que vous pouvez acheter ; la traînée achète et équipe la plus puissante",
		["Upgrade Now"] = "Améliorer maintenant",
		["Keep Cash"] = "Argent à conserver",
		["Upgrades never spend below this"] = "Les améliorations ne dépensent jamais l’argent réservé",
		["Eggs"] = "Œufs",
		["Auto Hatch Eggs"] = "Faire éclore les œufs automatiquement",
		["Places eggs from your backpack on your base and hatches them when ready"] = "Place les œufs de votre sac dans la base et les fait éclore quand ils sont prêts",
		["Hatch Eggs Now"] = "Faire éclore les œufs maintenant",
		["Auto Claim"] = "Récupérer les récompenses automatiquement",
		["Claims index, offline, group and community rewards, no joining needed"] = "Récupère les récompenses de l’index, hors ligne, du groupe et de la communauté, sans devoir rejoindre le groupe",
		["Claim Now"] = "Récupérer maintenant",
		["Movement and teleports"] = "Déplacements et téléportations",
		["Place"] = "Lieu",
		["See animals, eggs and players"] = "Repérez les animaux, les œufs et les joueurs",
		["ESP"] = "ESP",
		["Name, rarity, weight and cash per second"] = "Nom, rareté, poids et revenu par seconde",
		["Min Rarity"] = "Rareté minimum",
		["Eggs & Players"] = "Œufs et joueurs",
		["HP and how many hits it takes"] = "Points de vie et nombre de coups nécessaires",
		["Distance and what they carry"] = "Distance et ce qu’ils transportent",
		["Bat other players"] = "Frapper les autres joueurs avec la batte",
		["Bat"] = "Batte",
		["Target"] = "Cible",
		["Loop Bat Target"] = "Frapper la cible en boucle",
		["Follows the target and keeps knocking them over"] = "Suit la cible et la renverse sans arrêt",
		["Bat Target Now"] = "Frapper la cible maintenant",
		["Bat Aura"] = "Aura de la batte",
		["Knocks over anyone who gets close"] = "Renverse quiconque s’approche",
		["Stops the idle kick"] = "Évite l’expulsion pour inactivité",
		["Rejoins by itself after a disconnect"] = "Rejoint le jeu automatiquement après une déconnexion",
		["Rejoin Now"] = "Rejoindre le jeu maintenant",
		["Not available after a game update"] = "Indisponible après une mise à jour du jeu",
		["Not available on this executor"] = "Indisponible avec cet exécuteur",
		["Misc"] = "Divers",
		["Upgrades Only"] = "Améliorations uniquement",
		["Everything"] = "Tout",
		["Pickaxe"] = "Pioche",
		["Base"] = "Base",
		["Trail"] = "Traînée",
		["Treadmill"] = "Tapis de course",
		["Common"] = "Commun",
		["Uncommon"] = "Peu commun",
		["Rare"] = "Rare",
		["Epic"] = "Épique",
		["Legendary"] = "Légendaire",
		["Mythic"] = "Mythique",
		["Mythical"] = "Mythique",
		["Secret"] = "Secret",
		["Divine"] = "Divin",
		["Cash:"] = "Argent :",
		["Income/s:"] = "Revenu/s :",
		["Pickaxe:"] = "Pioche :",
		["Damage:"] = "Dégâts :",
		["Base animals:"] = "Animaux dans la base :",
		["Base level:"] = "Niveau de la base :",
		["Steals:"] = "Vols :",
		["Eggs broken:"] = "Œufs cassés :",
		["Animals banked:"] = "Animaux déposés :",
		["Cash/min:"] = "Argent/min :",
		["Status:"] = "État :",
		["Steal animals, break eggs and upgrade your base."] = "Volez des animaux, cassez des œufs et améliorez votre base.",
		["This feature needs a game update:"] = "Cette fonction nécessite une mise à jour du jeu :",
		["Some features could not find their game dependencies."] = "Certaines fonctions n’ont pas trouvé les dépendances nécessaires du jeu.",
		["Auto Steal key"] = "Touche du vol automatique",
		["Auto Break Eggs key"] = "Touche du cassage automatique des œufs",
		["Auto Place Best key"] = "Touche du placement automatique des meilleurs",
		["Auto Sell Leftovers key"] = "Touche de vente automatique des animaux restants",
		["Auto Upgrade key"] = "Touche des améliorations automatiques",
		["Auto Hatch Eggs key"] = "Touche d’éclosion automatique des œufs",
		["Auto Claim key"] = "Touche de récupération automatique des récompenses",
		["Loop Bat Target key"] = "Touche pour frapper la cible en boucle",
		["Bat Aura key"] = "Touche de l’aura de la batte",
		["Kaitun (All-in-one) key"] = "Touche de Kaitun (Tout-en-un)",
		["Banking"] = "Dépôt à la base",
		["Stealing "] = "Vol de ",
		["No pickaxe"] = "Aucune pioche",
		["Breaking %s (Zone %s)"] = "Cassage de %s (Zone %s)",
		["Breaking "] = "Cassage de ",
		[" (Zone "] = " (Zone ",
		["Robbing "] = "Vol à ",
		["Waiting for respawn"] = "En attente de réapparition",
		["No egg beats your base yet"] = "Aucun œuf ne surpasse encore les animaux de votre base",
		["Waiting for animals better than your base"] = "En attente d’animaux meilleurs que ceux de votre base",
		["Nothing to upgrade yet: not enough cash or already maxed"] = "Rien à améliorer : argent insuffisant ou niveau maximum atteint",
		["Sold %d animals"] = "%d animaux vendus",
		["Eggs handled: %d"] = "Œufs traités : %d",
		["Sold "] = "Vente de ",
		[" animals"] = " animaux",
		["Eggs handled: "] = "Œufs traités : ",
		["%s stopped: %s"] = "%s s’est arrêté : %s",
		["Some features can't find the game parts they need and are turned off."] = "Certaines fonctions sont désactivées car elles ne trouvent pas les composants nécessaires du jeu.",
		["Loaded"] = "Chargé",
		["Cash %s · %s/s\n%s (%s dmg) · Carry %d/%d\nBase %s/%s animals · Level %s"] = "Argent %s · %s/s\n%s (%s dégâts) · Transport %d/%d\nBase %s/%s animaux · Niveau %s",
		["%s\nSteals %d · Eggs %d · Banked %d · +%s/min"] = "%s\nVols %d · Œufs %d · Déposés %d · +%s/min",
		["My Base"] = "Ma base",
		["Egg Machine"] = "Machine à œufs",
		["Infinite Jump key"] = "Touche de saut infini",
	},
}


local function ErrorScriptsKeyGate()
	local cfg = ErrorScriptsAuthConfig
	if type(cfg.authSecret) ~= "string" or #cfg.authSecret ~= 48 or not cfg.authSecret:match("^%x+$") then
		warn("[ErrorScripts/Auth] Configure the Auth Secret privately before distributing this source.")
		return false
	end
	local TweenService = game:GetService("TweenService")
	local UIS = game:GetService("UserInputService")
	local font = ErrorScriptsConfig.Font or Enum.Font.BuilderSans
	local language = ErrorScriptsConfig.Language
	local bindings, connections = {}, {}
	local function words(text) return (ErrorScriptsTranslations[language] or {})[text] or text end
	local function make(class, properties, parent)
		local node = Instance.new(class)
		for key, value in pairs(properties or {}) do node[key] = value end
		node.Parent = parent
		return node
	end
	local function bind(node, text, property, prefix)
		property = property or "Text"; prefix = prefix or ""; node[property] = prefix .. words(text)
		bindings[node] = bindings[node] or {}; bindings[node][property] = {Text = text, Prefix = prefix}
		return node
	end
	local function connect(signal, fn) connections[#connections + 1] = signal:Connect(fn) end
	local function corner(node, n) make("UICorner", {CornerRadius = UDim.new(0, n or 10)}, node) end
	local function animate(node, properties, seconds)
		if ErrorScriptsConfig.Style.Animations and not ErrorScriptsConfig.Style.ReducedMotion then TweenService:Create(node, TweenInfo.new(seconds or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties):Play()
		else for key, value in pairs(properties) do node[key] = value end end
	end
	local old = ErrorScriptsEnv.__ErrorScriptsKeyGui
	if old and old.Parent then old:Destroy() end
	local gui = make("ScreenGui", {Name = "ErrorScriptsKey", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 100}, ErrorScriptsGuiParent())
	ErrorScriptsEnv.__ErrorScriptsKeyGui = gui
	local panel = make("CanvasGroup", {Name = "KeyGate", BackgroundColor3 = Color3.fromRGB(16, 13, 27), BorderSizePixel = 0, Size = UDim2.fromOffset(430, 452), GroupTransparency = 1}, gui)
	corner(panel, 18)
	local border = make("UIStroke", {Color = Color3.fromRGB(255, 53, 100), Thickness = 1.5}, panel)
	local gradient = make("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 53, 100)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(155, 70, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 234, 255))})}, border)
	local scale = make("UIScale", {Scale = 1}, panel)
	local dragged, dragInput, dragStart, dragOrigin = false, nil, nil, nil
	local function viewport() return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720) end
	local function clampPosition(x, y)
		local view = viewport()
		panel.Position = UDim2.fromOffset(math.clamp(x, 0, math.max(0, view.X - 430 * scale.Scale)), math.clamp(y, 0, math.max(0, view.Y - 452 * scale.Scale)))
	end
	local function fit()
		local view = viewport()
		scale.Scale = math.max(0.2, math.min(1, (view.X - 28) / 430, (view.Y - 28) / 452))
		if dragged then clampPosition(panel.Position.X.Offset, panel.Position.Y.Offset)
		else panel.Position = UDim2.fromOffset((view.X - 430 * scale.Scale) / 2, (view.Y - 452 * scale.Scale) / 2) end
	end
	fit()
	if workspace.CurrentCamera then connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), fit) end
	local dragHeader = make("Frame", {Name = "KeyDragHeader", BackgroundTransparency = 1, Active = true, Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, -60, 0, 105)}, panel)
	local function beginDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input; dragStart = input.Position; dragOrigin = panel.AbsolutePosition
		end
	end
	connect(dragHeader.InputBegan, beginDrag)
	connect(UIS.InputChanged, function(input)
		if not dragInput then return end
		local mouse = dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
		local touch = dragInput.UserInputType == Enum.UserInputType.Touch and input == dragInput
		if mouse or touch then
			local delta = input.Position - dragStart
			if delta.Magnitude > 4 then dragged = true; clampPosition(dragOrigin.X + delta.X, dragOrigin.Y + delta.Y) end
		end
	end)
	connect(UIS.InputEnded, function(input)
		if dragInput and (input == dragInput or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1)) then dragInput = nil end
	end)
	local function label(text, size, y, height)
		return bind(make("TextLabel", {BackgroundTransparency = 1, Font = font, TextColor3 = Color3.fromRGB(239, 237, 255), TextSize = size, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(28, y), Size = UDim2.new(1, -56, 0, height or 22), TextWrapped = true}, panel), text)
	end
	local tag = label("ERROR // ACCESS", 11, 26); tag.TextColor3 = Color3.fromRGB(0, 234, 255)
	local brand = label("ERRORSCRIPTS", 31, 61, 40); brand.TextColor3 = Color3.fromRGB(255, 53, 100)
	connect(tag.InputBegan, beginDrag); connect(brand.InputBegan, beginDrag)
	local title = label("Key required", 17, 117, 28); title.Name = "KeyTitle"; bind(title, "Key required", "Text", "🔐 ")
	label("Enter a valid key to continue.", 12, 154, 38)
	local box = make("TextBox", {Name = "LicenseKey", Text = type(ErrorScriptsEnv.script_key) == "string" and ErrorScriptsEnv.script_key ~= "PASTE-YOUR-KEY-HERE" and ErrorScriptsEnv.script_key or "", PlaceholderText = words("License key"), BackgroundColor3 = Color3.fromRGB(31, 25, 44), BorderSizePixel = 0, ClearTextOnFocus = false, Font = font, TextSize = 13, TextColor3 = Color3.fromRGB(239, 237, 255), PlaceholderColor3 = Color3.fromRGB(146, 138, 163), Position = UDim2.fromOffset(28, 203), Size = UDim2.new(1, -56, 0, 43)}, panel)
	corner(box); make("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}, box); bind(box, "License key", "PlaceholderText")
	local validate = bind(make("TextButton", {Name = "ValidateKey", BackgroundColor3 = Color3.fromRGB(255, 53, 100), BorderSizePixel = 0, AutoButtonColor = false, Font = font, TextSize = 13, TextColor3 = Color3.new(1, 1, 1), Position = UDim2.fromOffset(28, 262), Size = UDim2.new(0.5, -33, 0, 43)}, panel), "Validate key", "Text", "✅ ")
	corner(validate)
	local status = label("Waiting for a key.", 11, 316, 35); status.TextColor3 = Color3.fromRGB(170, 159, 188)
	local linkBox = make("TextBox", {Name = "KeyLink", Visible = false, Text = ErrorScriptsConfig.KeyUrl, ClearTextOnFocus = false, Font = font, TextSize = 11, TextColor3 = Color3.fromRGB(0, 234, 255), BackgroundColor3 = Color3.fromRGB(31, 25, 44), BorderSizePixel = 0, Position = UDim2.fromOffset(28, 354), Size = UDim2.new(1, -56, 0, 26)}, panel)
	corner(linkBox, 6)
	local languages = {"en", "pt", "es", "fr"}
	for i, code in ipairs(languages) do
		local lang = make("TextButton", {Text = code:upper(), Font = font, TextSize = 11, TextColor3 = Color3.fromRGB(239, 237, 255), BackgroundColor3 = Color3.fromRGB(31, 25, 44), BorderSizePixel = 0, Size = UDim2.fromOffset(40, 28), Position = UDim2.fromOffset(28 + (i - 1) * 46, 392)}, panel)
		corner(lang, 7)
		connect(lang.Activated, function()
			language = code; ErrorScriptsConfig.Language = code
			for node, texts in pairs(bindings) do for property, text in pairs(texts) do node[property] = text.Prefix .. words(text.Text) end end
		end)
	end
	local key = bind(make("TextButton", {Name = "GetKey", Font = font, TextSize = 13, TextColor3 = Color3.fromRGB(0, 234, 255), BackgroundColor3 = Color3.fromRGB(31, 25, 44), BorderSizePixel = 0, AutoButtonColor = false, Position = UDim2.new(0.5, 5, 0, 262), Size = UDim2.new(0.5, -33, 0, 43)}, panel), "Get key", "Text", "🔑 ")
	corner(key)
	connect(key.Activated, function()
		if ErrorScriptsConfig.KeyUrl == "" then bind(status, "The owner has not configured the key link."); return end
		local copy = setclipboard or toclipboard
		if type(copy) == "function" and pcall(copy, ErrorScriptsConfig.KeyUrl) then linkBox.Visible = false; bind(status, "Key link copied. Open it in your browser.")
		else linkBox.Text = ErrorScriptsConfig.KeyUrl; linkBox.Visible = true; bind(status, "Open this link in your browser to get a key.") end
	end)
	local close = make("TextButton", {Text = "×", Font = font, TextSize = 20, TextColor3 = Color3.fromRGB(146, 138, 163), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(1, -49, 0, 16), Size = UDim2.fromOffset(30, 30)}, panel)
	local completed, authorized, busy = false, false, false
	local function submit()
		if busy or completed then return end
		local key = box.Text:match("^%s*(.-)%s*$")
		if key == "" or key == "PASTE-YOUR-KEY-HERE" then bind(status, "Enter a valid key to continue."); return end
		busy = true; validate.Active = false; bind(status, "Validating key..."); animate(validate, {BackgroundColor3 = Color3.fromRGB(124, 49, 86)}, 0.14)
		task.spawn(function()
			ErrorScriptsEnv.script_key = key
			local ok, allowed = pcall(ErrorScriptsAuthorize)
			if completed or not gui.Parent then return end
			busy = false; validate.Active = true
			if ok and allowed == true then authorized = true; completed = true; bind(status, "Key validated.")
			else bind(status, "Key validation failed."); animate(validate, {BackgroundColor3 = Color3.fromRGB(255, 53, 100)}, 0.18) end
		end)
	end
	connect(validate.Activated, submit)
	connect(box.FocusLost, function(enter) if enter then submit() end end)
	connect(close.Activated, function() completed = true end)
	connect(gui.AncestryChanged, function() if not gui.Parent then completed = true end end)
	local elapsed = 0
	connect(game:GetService("RunService").Heartbeat, function(dt)
		elapsed += dt
		if ErrorScriptsConfig.Style.Animations and not ErrorScriptsConfig.Style.ReducedMotion then gradient.Rotation = elapsed * 25 % 360 end
	end)
	animate(panel, {GroupTransparency = 0}, 0.3)
	if box.Text ~= "" then submit() end
	while not completed do task.wait(0.1) end
	for _, connection in ipairs(connections) do connection:Disconnect() end
	if authorized and gui.Parent then animate(panel, {GroupTransparency = 1}, 0.2); task.wait(0.22) end
	if gui.Parent then gui:Destroy() end
	if ErrorScriptsEnv.__ErrorScriptsKeyGui == gui then ErrorScriptsEnv.__ErrorScriptsKeyGui = nil end
	return authorized
end


local function ErrorScriptsInterface()
	local UIS = game:GetService("UserInputService")
	local JSON = game:GetService("HttpService")
	local Library =
		{ Toggles = {}, Options = {}, Unloaded = false, _connections = {}, _unload = {}, _groups = {}, _renders = {} }
	local colors = {
		bg = Color3.fromRGB(10, 10, 18),
		card = Color3.fromRGB(20, 18, 31),
		field = Color3.fromRGB(32, 26, 45),
		line = Color3.fromRGB(54, 41, 68),
		text = Color3.fromRGB(239, 241, 249),
		muted = Color3.fromRGB(145, 153, 173),
	}
	Library.Accent = Color3.fromRGB(255, 53, 100)
	local accentObjects = {}
	local gui, window, scale, nav, content, heading, subheading, activity, noticeStack, openButton
	local tabs, activeTab = {}, nil
	local descriptions = {
		Main = ErrorScriptsConfig.GameKey == "BreakStealEgg" and "Steal animals and break eggs." or "Choose your targets and collection settings.",
		Shop = ErrorScriptsConfig.GameKey == "BreakStealEgg" and "Animals, upgrades and rewards." or (ErrorScriptsConfig.GameKey == "BuildThePyramid" and "Upgrades and rewards in one place." or "Rods, bait and codes in one place."),
		Player = "Adjust movement and player options.",
		Info = "Player and session information.",
		Settings = "Customize the menu and save your settings.",
		Games = "Three games. One ErrorScripts menu.",
		Visuals = "See animals, eggs and players.",
		Troll = "Bat and player interactions.",
		Training = "Choose your training and movement settings.",
	}
	local titles = { Main = ErrorScriptsConfig.GameKey == "BuildThePyramid" and "Auto Farm" or (ErrorScriptsConfig.GameKey == "BreakStealEgg" and "Steal & Break" or "Fishing"), Training = "Training", Shop = ErrorScriptsConfig.GameKey == "BreakStealEgg" and "Base & Shop" or "Shop", Player = "Player", Info = "Dashboard", Visuals = "Visuals", Troll = "Troll", Settings = "Settings", Games = "Games" }
	local function words(text)
		if type(text) ~= "string" then return text end
		local dictionary = ErrorScriptsTranslations[Library.Language or ErrorScriptsConfig.Language] or {}
		if dictionary[text] then return dictionary[text] end
		-- Translate changing statistics without modifying item names or values.
		local prefix, suffix = text:match("^([^:]+:)(.*)$")
		if prefix and dictionary[prefix] then return dictionary[prefix] .. suffix end
		return text
	end
	local TweenService = game:GetService("TweenService")
	local textBindings = {}
	Library._cards = {}
	Library.AutomationIds = {}
	Library.Style = ErrorScriptsConfig.Style
	Library.Language = ErrorScriptsConfig.Language
	Library.GameName = ErrorScriptsConfig.GameName
	Library.GameKey = ErrorScriptsConfig.GameKey
	local function tween(node, properties, seconds)
		if not Library.Style.Animations or Library.Style.ReducedMotion then
			for key, value in pairs(properties) do node[key] = value end
			return
		end
		local animation = TweenService:Create(node, TweenInfo.new(seconds or 0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
		animation:Play()
	end
	local function bindText(node, source, property)
		property = property or "Text"
		node[property] = words(source)
		textBindings[node] = textBindings[node] or {}
		textBindings[node][property] = source
		return node
	end
	function Library:Translate(text) return words(text) end
	function Library:SetLanguage(code)
		if not ErrorScriptsTranslations[code] then return end
		self.Language = code; ErrorScriptsConfig.Language = code
		for node, bindings in pairs(textBindings) do
			if node.Parent then for property, source in pairs(bindings) do node[property] = words(source) end
			else textBindings[node] = nil end
		end
		for _, render in ipairs(self._renders) do render() end
		if self._refreshText then self._refreshText() end
		if self._fit then self._fit() end
		self:SavePreferences()
	end
	function Library:SavePreferences()
		if type(writefile) ~= "function" or type(makefolder) ~= "function" then return end
		pcall(function()
			if not isfolder or not isfolder("ErrorScripts") then pcall(makefolder, "ErrorScripts") end
			writefile("ErrorScripts/interface-v1.json", JSON:JSONEncode({Language = self.Language, LanguageVersion = 2, Style = self.Style, AutoLoad = ErrorScriptsConfig.AutoLoad}))
		end)
	end
	function Library:SetStyle(name, value)
		if name == "Scale" then value = math.clamp(tonumber(value) or 1, 0.65, 1.3)
		elseif name == "Transparency" then value = math.clamp(tonumber(value) or 0, 0, 0.35) end
		self.Style[name] = value
		if name == "Scale" and self._fit then self._fit() end
		if name == "Transparency" then
			if self.MainFrame then self.MainFrame.BackgroundTransparency = value end
			for _, card in ipairs(self._cards) do if card.Parent then card.BackgroundTransparency = value end end
		end
		if name == "Watermark" and self._watermark then self._watermark.Visible = value end
		if name == "RGB" and not value then self:ApplyAccentName(self.Style.Accent) end
		self:SavePreferences()
	end
	function Library:ApplyAccentName(name)
		local palette = {Red = Color3.fromRGB(255, 53, 100), Violet = Color3.fromRGB(157, 88, 255), Blue = Color3.fromRGB(70, 155, 255), Cyan = Color3.fromRGB(0, 234, 255)}
		if palette[name] then self.Style.Accent = name; self:SetAccent(palette[name]); self:SavePreferences() end
	end
	function Library:Copy(text)
		local copy = setclipboard or toclipboard
		if type(copy) == "function" and pcall(copy, text) then self:Notify("Copied to clipboard.")
		else self:Notify(text, 12) end
	end
	function Library:RegisterAutomation(id) self.AutomationIds[id] = true end
	function Library:PauseAutomations()
		-- Disable the all-in-one preset first, then stop every independent automation.
		local preset = self.Toggles.Kaitun
		if preset and preset.Value then preset:SetValue(false) end
		for id, toggle in pairs(self.Toggles) do
			if (self.AutomationIds[id] or id:sub(1, 4) == "Auto" or id:find("Farm", 1, true)) and toggle.Value then toggle:SetValue(false) end
		end
		self:Notify("Automations paused.")
	end
	function Library:Rejoin()
		local players = game:GetService("Players")
		local ok = pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, players.LocalPlayer) end)
		if not ok then self:Notify("Could not reconnect. Try again.") end
	end
	function Library:ServerHop()
		if self._hopping then return end
		self._hopping = true
		task.spawn(function()
			local ok, err = pcall(function()
				local cursor = ""
				for _ = 1, 8 do
					if self.Unloaded then return end
					local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
					if cursor ~= "" then url ..= "&cursor=" .. JSON:UrlEncode(cursor) end
					local data = JSON:JSONDecode(game:HttpGet(url))
					for _, server in ipairs(data.data or {}) do
						if server.id ~= game.JobId and tonumber(server.playing) and tonumber(server.maxPlayers) and server.playing < server.maxPlayers then
							game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, game:GetService("Players").LocalPlayer)
							return
						end
					end
					if not data.nextPageCursor then break end
					cursor = data.nextPageCursor; task.wait(0.3)
				end
				self:Notify("No other available server was found.")
			end)
			self._hopping = false
			if not ok and not self.Unloaded then self:Notify("Server search failed. Try again."); warn("[ErrorScripts/Servers] " .. tostring(err)) end
		end)
	end

	local function make(class, props, parent)
		local node = Instance.new(class)
		for key, value in pairs(props or {}) do
			node[key] = value
		end
		node.Parent = parent
		return node
	end
	local function corner(node, radius)
		make("UICorner", { CornerRadius = UDim.new(0, radius or 9) }, node)
	end
	local function stroke(node)
		make("UIStroke", { Color = colors.line, Thickness = 1 }, node)
	end
	local function pad(node, n)
		make("UIPadding", {
			PaddingTop = UDim.new(0, n),
			PaddingBottom = UDim.new(0, n),
			PaddingLeft = UDim.new(0, n),
			PaddingRight = UDim.new(0, n),
		}, node)
	end
	local function list(node, gap)
		make("UIListLayout", { Padding = UDim.new(0, gap or 8), SortOrder = Enum.SortOrder.LayoutOrder }, node)
	end
	local function label(parent, text, size, props)
		local defaults = {
			BackgroundTransparency = 1,
			Text = words(text) or "",
			Font = Enum.Font.BuilderSans,
			TextSize = size or 13,
			TextColor3 = colors.text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 24),
		}
		for k, v in pairs(props or {}) do
			defaults[k] = v
		end
		return bindText(make("TextLabel", defaults, parent), text or "")
	end
	local function accent(node, prop)
		accentObjects[#accentObjects + 1] = { node, prop }
		node[prop] = Library.Accent
	end
	local function connect(signal, callback)
		local connection = signal:Connect(callback)
		Library._connections[#Library._connections + 1] = connection
		return connection
	end
	local function safe(callback, ...)
		if type(callback) ~= "function" then
			return
		end
		local ok, err = pcall(callback, ...)
		if not ok and not Library.Unloaded then
			Library:Notify("The action failed. Check the console for details.")
			warn("[ErrorScripts] " .. tostring(err))
		end
	end
	local function button(parent, text, size)
		local node = make("TextButton", {
			Text = words(text),
			Font = Enum.Font.BuilderSans,
			TextSize = 12,
			TextColor3 = colors.text,
			BackgroundColor3 = colors.field,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Size = size or UDim2.new(1, 0, 0, 34),
		}, parent)
		corner(node, 7)
		connect(node.MouseEnter, function()
			tween(node, {BackgroundColor3 = colors.line}, 0.12)
		end)
		connect(node.MouseLeave, function()
			tween(node, {BackgroundColor3 = colors.field}, 0.18)
		end)
		bindText(node, text)
		connect(node.MouseButton1Down, function() tween(node, {TextTransparency = 0.35}, 0.08) end)
		connect(node.MouseButton1Up, function() tween(node, {TextTransparency = 0}, 0.12) end)
		connect(node.MouseLeave, function() tween(node, {TextTransparency = 0}, 0.12) end)
		return node
	end
	local function updateActivity()
		if not activity then
			return
		end
		local count = 0
		for _, toggle in pairs(Library.Toggles) do
			if toggle.Value and (Library.AutomationIds[toggle.ID] or toggle.ID:sub(1, 4) == "Auto") then
				count += 1
			end
		end
		activity.Text = if count > 0 then tostring(count) .. " " .. words("AUTO ACTIVE") else words("AUTO PAUSED")
	end
	function Library:SetAccent(color)
		self.Accent = color
		for _, item in ipairs(accentObjects) do
			if item[1].Parent then
				item[1][item[2]] = color
			end
		end
		for _, render in ipairs(self._renders) do
			render()
		end
	end
	function Library:Notify(message, duration)
		if self.Unloaded then
			return
		end
		if not noticeStack then
			warn("[ErrorScripts] " .. tostring(message))
			return
		end
		local toast = make("CanvasGroup", {
			GroupTransparency = 1,
			BackgroundColor3 = colors.card,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, noticeStack)
		corner(toast)
		stroke(toast)
		pad(toast, 14)
		label(toast, "ErrorScripts", 11, { TextColor3 = self.Accent, Size = UDim2.new(1, 0, 0, 18) })
		label(toast, tostring(message), 12, {
			Position = UDim2.fromOffset(0, 23),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
		})
		tween(toast, {GroupTransparency = 0}, 0.2)
		task.delay(duration or 5, function()
			if toast.Parent then
				tween(toast, {GroupTransparency = 1}, 0.18)
				task.delay(0.2, function() if toast.Parent then toast:Destroy() end end)
			end
		end)
	end
	function Library:OnUnload(callback)
		self._unload[#self._unload + 1] = callback
	end
	function Library:Unload()
		if self.Unloaded then
			return
		end
		self.Unloaded = true
		for _, callback in ipairs(self._unload) do
			pcall(callback)
		end
		for _, connection in ipairs(self._connections) do
			connection:Disconnect()
		end
		if ErrorScriptsEnv.__ErrorScriptsHub == self then ErrorScriptsEnv.__ErrorScriptsHub = nil end
		if gui then
			gui:Destroy()
		end
	end
	local function object(id, kind, config)
		local obj = {
			ID = id,
			Type = kind,
			Value = config.Default,
			Default = if type(config.Default) == "table" then table.clone(config.Default) else config.Default,
			Multi = config.Multi == true,
			Values = config.Values or {},
			_callbacks = {},
		}
		function obj:OnChanged(callback)
			self._callbacks[#self._callbacks + 1] = callback
			safe(callback, self.Value)
			return self
		end
		function obj:_emit()
			if self._render then
				self._render()
			end
			if self.ID == "MenuKeybind" and Library._bindHint then
				Library._bindHint.Text = tostring(self.Value) .. " · " .. words("show / hide")
			end
			safe(config.Callback, self.Value)
			for _, callback in ipairs(self._callbacks) do
				safe(callback, self.Value)
			end
			updateActivity()
		end
		function obj:SetValue(value)
			if self.Type == "Toggle" then
				value = value == true
			elseif self.Type == "Slider" then
				value = tonumber(value)
				if not value then
					return
				end
				local factor = 10 ^ (config.Rounding or 0)
				value = math.floor(math.clamp(value, config.Min, config.Max) * factor + 0.5) / factor
			elseif self.Type == "Dropdown" then
				if self.Multi then
					local chosen = {}
					if type(value) == "table" then
						for key, selected in pairs(value) do
							local candidate = if type(key) == "number" then selected else key
							if selected and table.find(self.Values, candidate) then
								chosen[candidate] = true
							end
						end
					end
					value = chosen
				else
					if type(value) == "number" then
						value = self.Values[value]
					end
					if value ~= nil and value ~= "" and not table.find(self.Values, value) then
						return
					end
				end
			elseif self.Type == "Input" then
				value = tostring(value or "")
			elseif self.Type == "KeyPicker" then
				if type(value) == "table" then
					self.Mode = value[2] or "Toggle"
					self.Modifiers = value[3]
					value = value[1]
				end
				if type(value) ~= "string" then
					return
				end
			end
			self.Value = value
			self:_emit()
		end
		function obj:Update()
			if self._render then
				self._render()
			end
		end
		function obj:SetValues(values)
			self.Values = values or {}
			if self._build then
				self._build()
			end
			self:SetValue(self.Value)
		end
		if kind == "Toggle" then
			Library.Toggles[id] = obj
		else
			Library.Options[id] = obj
		end
		return obj
	end
	local function filterSearch(query)
		query = string.lower(query)
		for _, group in ipairs(Library._groups) do
			local groupMatch = string.find(string.lower(group.Name), query, 1, true) ~= nil
			local any = false
			for _, entry in ipairs(group.Rows) do
				local visible = query == ""
					or groupMatch
					or string.find(string.lower(entry.text), query, 1, true) ~= nil
				or (entry.source and string.find(string.lower(words(entry.source)), query, 1, true) ~= nil)
				entry.node.Visible = visible
				any = any or visible
			end
			group.Frame.Visible = any or query == ""
		end
	end
	local function selectTab(tab)
		activeTab = tab
		for _, other in ipairs(tabs) do
			other.Page.Visible = other == tab
			tween(other.Button, {BackgroundTransparency = if other == tab then 0 else 1, TextColor3 = if other == tab then colors.text else colors.muted}, 0.17)
			other.Bar.Visible = other == tab
		end
		bindText(heading, titles[tab.Name] or tab.Name)
		bindText(subheading, descriptions[tab.Name] or "Customize your session.")
		if Library.Style.Animations and not Library.Style.ReducedMotion then
			tab.Page.Position = UDim2.fromOffset(0, 8)
			tween(tab.Page, {Position = UDim2.fromOffset(0, 0)}, 0.22)
		end
	end
	Library._refreshText = function()
		if activeTab then bindText(heading, titles[activeTab.Name] or activeTab.Name); bindText(subheading, descriptions[activeTab.Name] or "Customize your session.") end
		updateActivity()
		if Library._bindHint then Library._bindHint.Text = (Library.ToggleKeybind and Library.ToggleKeybind.Value or Library.Style.MenuKey) .. " · " .. words("show / hide") end
	end
	local Groups = {}
	Groups.__index = Groups
	function Groups:_row(text, height)
		local row = make(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height or 36), LayoutOrder = #self.Rows + 1 },
			self.Body
		)
		self.Rows[#self.Rows + 1] = { node = row, source = text, text = tostring(text or "") .. " " .. tostring(words(text) or "") }
		return row
	end
	function Groups:AddLabel(text)
		local row = self:_row(text, 26)
		local node = label(row, text, 12, { RichText = true, TextWrapped = true, Size = UDim2.new(1, 0, 1, 0) })
		local result = {}
		function result:SetText(value)
			bindText(node, tostring(value))
		end
		function result:AddKeyPicker(id, config)
			return Groups.AddKeyPicker({ Body = row, Rows = {} }, id, config)
		end
		return result
	end
	function Groups:AddPlayerInfo(id, config)
		local player = config.Player
		local row = self:_row("Profile " .. tostring(player.DisplayName or player.Name), 64)
		local avatar = make("ImageLabel", {
			Name = "PlayerAvatar",
			BackgroundColor3 = colors.field,
			BorderSizePixel = 0,
			Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150",
			Size = UDim2.fromOffset(54, 54),
			Position = UDim2.fromOffset(0, 5),
		}, row)
		corner(avatar, 12)
		local display = label(row, tostring(player.DisplayName or player.Name), 14, {
			Font = Enum.Font.BuilderSans,
			Position = UDim2.fromOffset(65, 10),
			Size = UDim2.new(1, -65, 0, 21),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local username = label(row, "@" .. tostring(player.Name), 11, {
			TextColor3 = colors.muted,
			Position = UDim2.fromOffset(65, 35),
			Size = UDim2.new(1, -65, 0, 18),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local result = { Frame = row }
		function result:SetPlayer(value)
			display.Text = tostring(value.DisplayName or value.Name)
			username.Text = "@" .. tostring(value.Name)
			avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(value.UserId) .. "&w=150&h=150"
		end
		Library.PlayerCards = Library.PlayerCards or {}
		Library.PlayerCards[id] = result
		return result
	end
	function Groups:AddDivider(text)
		if text == "Finds" and self.Title == "Fishing" and self.Tab then
			self._route = self.Tab:AddRightGroupbox("Finds")
			return
		end
		local row = self:_row(text or "", 24)
		if text then
			label(row, words(text), 10, { TextColor3 = colors.muted, Position = UDim2.fromOffset(0, 3) })
		else
			make("Frame", {
				BackgroundColor3 = colors.line,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 0.5, 0),
			}, row)
		end
	end
	function Groups:AddButton(config, callback)
		if self._route then
			return self._route:AddButton(config, callback)
		end
		if type(config) == "string" then
			config = { Text = config, Func = callback }
		end
		local row = self:_row(config.Text, 34)
		local node = button(row, config.Text)
		connect(node.Activated, function()
			safe(config.Func)
		end)
		return node
	end
	function Groups:AddButtonPair(leftText, rightText, leftAction, rightAction)
		local row = self:_row(leftText .. " " .. rightText, 34)
		local left = button(row, leftText, UDim2.new(0.5, -4, 0, 34))
		local right = button(row, rightText, UDim2.new(0.5, -4, 0, 34)); right.Position = UDim2.new(0.5, 4, 0, 0)
		connect(left.Activated, function() safe(leftAction) end)
		connect(right.Activated, function() safe(rightAction) end)
		return left, right
	end
	function Groups:AddToggle(id, config)
		if self._route then
			return self._route:AddToggle(id, config)
		end
		local obj = object(id, "Toggle", config)
		local row = self:_row(config.Text)
		label(row, config.Text, 12, { Size = UDim2.new(1, -56, 1, 0) })
		local switch = make("TextButton", {
			Text = "",
			BackgroundColor3 = colors.field,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Size = UDim2.fromOffset(38, 22),
			Position = UDim2.new(1, -38, 0.5, -11),
		}, row)
		corner(switch, 11)
		local knob = make("Frame", {
			BackgroundColor3 = colors.text,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.fromOffset(3, 3),
		}, switch)
		corner(knob, 8)
		obj._render = function()
			tween(switch, {BackgroundColor3 = if obj.Value then Library.Accent else colors.field}, 0.16)
			tween(knob, {Position = UDim2.fromOffset(if obj.Value then 19 else 3, 3)}, 0.18)
		end
		Library._renders[#Library._renders + 1] = obj._render
		connect(switch.Activated, function()
			obj:SetValue(not obj.Value)
		end)
		obj.Value = config.Default == true
		obj._render()
		updateActivity()
		return obj
	end
	function Groups:AddInput(id, config)
		local obj = object(id, "Input", config)
		local row = self:_row(config.Text, 64)
		label(row, config.Text, 12, { Size = UDim2.new(1, 0, 0, 20) })
		local box = make("TextBox", {
			Text = tostring(config.Default or ""),
			PlaceholderText = config.Placeholder or "",
			PlaceholderColor3 = colors.muted,
			Font = Enum.Font.BuilderSans,
			TextSize = 12,
			TextColor3 = colors.text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClearTextOnFocus = false,
			BackgroundColor3 = colors.field,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 34),
			Position = UDim2.fromOffset(0, 26),
		}, row)
		corner(box, 7)
		pad(box, 9)
		obj._render = function()
			if box.Text ~= obj.Value then
				box.Text = obj.Value
			end
		end
		obj.Value = tostring(config.Default or "")
		connect(box.FocusLost, function()
			obj:SetValue(box.Text)
		end)
		if not config.Finished then
			connect(box:GetPropertyChangedSignal("Text"), function()
				if obj.Value ~= box.Text then
					obj:SetValue(box.Text)
				end
			end)
		end
		return obj
	end
	function Groups:AddSlider(id, config)
		local obj = object(id, "Slider", config)
		local row = self:_row(config.Text, 55)
		label(row, config.Text, 12, { Size = UDim2.new(1, -70, 0, 22) })
		local valueLabel = label(row, tostring(config.Default), 12, {
			TextXAlignment = Enum.TextXAlignment.Right,
			Position = UDim2.new(1, -65, 0, 0),
			Size = UDim2.fromOffset(65, 22),
		})
		accent(valueLabel, "TextColor3")
		local track = make("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = colors.field,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 8),
			Position = UDim2.fromOffset(0, 35),
		}, row)
		corner(track, 4)
		local fill = make("Frame", { BorderSizePixel = 0, Size = UDim2.new(0, 0, 1, 0) }, track)
		corner(fill, 4)
		accent(fill, "BackgroundColor3")
		local dragging = false
		local function setX(x)
			if track.AbsoluteSize.X > 0 then
				obj:SetValue(
					config.Min
						+ (config.Max - config.Min)
							* math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				)
			end
		end
		obj._render = function()
			valueLabel.Text = tostring(obj.Value)
			tween(fill, {Size = UDim2.new((obj.Value - config.Min) / (config.Max - config.Min), 0, 1, 0)}, 0.08)
		end
		connect(track.InputBegan, function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = true
				setX(input.Position.X)
			end
		end)
		connect(UIS.InputChanged, function(input)
			if
				dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				setX(input.Position.X)
			end
		end)
		connect(UIS.InputEnded, function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = false
			end
		end)
		obj:SetValue(config.Default)
		return obj
	end
	function Groups:AddDropdown(id, config)
		if self._route then
			return self._route:AddDropdown(id, config)
		end
		local obj = object(id, "Dropdown", config)
		local row = self:_row(config.Text, 64)
		label(row, config.Text, 12, { Size = UDim2.new(1, 0, 0, 20) })
		local trigger = button(row, "Select  +", UDim2.new(1, 0, 0, 34))
		trigger.Position = UDim2.fromOffset(0, 26)
		trigger.TextXAlignment = Enum.TextXAlignment.Left
		pad(trigger, 9)
		local panel = make("Frame", {
			BackgroundColor3 = colors.field,
			BorderSizePixel = 0,
			Visible = false,
			Size = UDim2.new(1, 0, 0, 194),
			Position = UDim2.fromOffset(0, 67),
		}, row)
		corner(panel, 7)
		pad(panel, 8)
		local search = make("TextBox", {
			Text = "",
			PlaceholderText = "Filter options...",
			ClearTextOnFocus = false,
			Font = Enum.Font.BuilderSans,
			TextSize = 11,
			TextColor3 = colors.text,
			PlaceholderColor3 = colors.muted,
			BackgroundColor3 = colors.card,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 27),
		}, panel)
		corner(search, 5)
		pad(search, 6)
		local choices = make("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -36),
			Position = UDim2.fromOffset(0, 36),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Library.Accent,
		}, panel)
		list(choices, 4)
		local optionRows = {}
		local expanded = false
		local function expand(value)
			expanded = value
			panel.Visible = value
			row.Size = UDim2.new(1, 0, 0, if value then 269 else 64)
		end
		obj._render = function()
			local selected = {}
			if obj.Multi then
				for _, value in ipairs(obj.Values) do
					if obj.Value and obj.Value[value] then
						table.insert(selected, words(tostring(value)))
					end
				end
			elseif obj.Value ~= nil and obj.Value ~= "" then
				selected = { words(tostring(obj.Value)) }
			end
			local summary = if #selected == 0
				then (if obj.Multi then words("All / no filter") else words("Select"))
				else table.concat(selected, ", ")
			trigger.Text = summary .. "  +"
			trigger.TextTruncate = Enum.TextTruncate.AtEnd
			for _, entry in ipairs(optionRows) do
				local on = if obj.Multi then obj.Value and obj.Value[entry.value] else obj.Value == entry.value
				entry.node.Text = (if on then "✓  " else "    ") .. words(tostring(entry.value))
				entry.node.TextColor3 = if on then Library.Accent else colors.text
			end
		end
		obj._build = function()
			for _, entry in ipairs(optionRows) do
				entry.node:Destroy()
			end
			optionRows = {}
			for _, value in ipairs(obj.Values) do
				local node = button(choices, tostring(value), UDim2.new(1, -5, 0, 27))
				node.TextXAlignment = Enum.TextXAlignment.Left
				optionRows[#optionRows + 1] = { value = value, node = node }
				connect(node.Activated, function()
					if obj.Multi then
						local selected = table.clone(obj.Value)
						selected[value] = if selected[value] then nil else true
						obj:SetValue(selected)
					else
						obj:SetValue(value)
						expand(false)
					end
				end)
			end
		end
		connect(search:GetPropertyChangedSignal("Text"), function()
			for _, entry in ipairs(optionRows) do
				entry.node.Visible = string.find(
					string.lower(tostring(entry.value)),
					string.lower(search.Text),
					1,
					true
				) ~= nil
			end
		end)
		connect(trigger.Activated, function()
			expand(not expanded)
		end)
		Library._renders[#Library._renders + 1] = obj._render
		obj._build()
		obj:SetValue(config.Default)
		return obj
	end
	function Groups:AddKeyPicker(id, config)
		if Library.Options[id] then return Library.Options[id] end
		if id == "MenuKeybind" then config = table.clone(config); config.Default = Library.Style.MenuKey end
		local obj = object(id, "KeyPicker", config)
		obj.Mode = config.Mode or "Toggle"
		obj.Toggled = false
		local node = button(self.Body, if id == "MenuKeybind" then Library.Style.MenuKey else config.Default, UDim2.fromOffset(110, 25))
		node.Position = UDim2.new(1, -110, 0, 0)
		local capture = false
		obj._render = function()
			node.Text = if capture then words("Press a key") else tostring(obj.Value)
		end
		connect(node.Activated, function()
			capture = true
			Library._capturingKey = true
			obj._render()
		end)
		connect(UIS.InputBegan, function(input)
			if capture and input.KeyCode ~= Enum.KeyCode.Unknown then
				capture = false
				Library._capturingKey = false
				Library._skipToggle = true
				obj:SetValue(input.KeyCode.Name)
				task.defer(function()
					Library._skipToggle = false
				end)
			end
		end)
		Library._renders[#Library._renders + 1] = obj._render
		obj:SetValue(config.Default)
		return obj
	end
	local Window = {}
	Window.__index = Window
	local symbols = {Info = "📊", Main = "🎣", Training = "🏋️", Shop = "🛒", Player = "👤", Visuals = "👁️", Troll = "⚔️", Settings = "⚙️", Games = "🎮"}
	local tabOrder = {Info = 1, Main = 2, Training = 3, Shop = 4, Player = 5, Visuals = 6, Troll = 7, Settings = 8, Games = 9}
	local function tabSymbol(name)
		if name == "Main" and Library.GameKey == "BuildThePyramid" then return "🏗️" end
		if name == "Main" and Library.GameKey == "BreakStealEgg" then return "🥚" end
		return symbols[name] or "✨"
	end
	function Window:AddTab(name)
		if self.ByName[name] then return self.ByName[name] end
		local tab = {Name = name}
		tab.Button = button(nav, titles[name] or name, UDim2.new(1, 0, 0, 42))
		tab.Button.TextXAlignment = Enum.TextXAlignment.Left
		tab.Button.TextSize = 12
		tab.Padding = make("UIPadding", {PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14)}, tab.Button)
		tab.Button.LayoutOrder = tabOrder[name] or (100 + #tabs)
		tab.Bar = make("Frame", {BorderSizePixel = 0, Size = UDim2.new(0, 3, 0, 20), Position = UDim2.new(0, 0, 0.5, -10)}, tab.Button)
		corner(tab.Bar, 3)
		accent(tab.Bar, "BackgroundColor3")
		tab.Page = make("ScrollingFrame", {Name = name, BackgroundTransparency = 1, BorderSizePixel = 0,
			Visible = false, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3, ScrollBarImageColor3 = Library.Accent}, content)
		accent(tab.Page, "ScrollBarImageColor3")
		tab.Columns = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -7, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}, tab.Page)
		tab.Layout = make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder}, tab.Columns)
		tab.Left = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(0.5, -7, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1}, tab.Columns)
		tab.Right = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(0.5, -7, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2}, tab.Columns)
		list(tab.Left, 12); list(tab.Right, 12)
		local function group(which, title)
			if name == "Main" and Library.GameKey == "DeepFishing" and (title == "Shop" or title == "Codes" or title == "Bait") then
				local shop = Library.Window.ByName.Shop
				return (if title == "Bait" then shop.AddRightGroupbox else shop.AddLeftGroupbox)(shop, title)
			end
			local card = make("Frame", {BackgroundColor3 = colors.card, BackgroundTransparency = Library.Style.Transparency,
				BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}, which)
			Library._cards[#Library._cards + 1] = card
			corner(card, 12); stroke(card); pad(card, 14); list(card, 10)
			local translated = {Fishing = "Fishing automation", Finds = "Finds and fragments", Sell = "Sell fish", Shop = "Equipment",
				Fly = "Flight", Menu = "Menu and session", User = "Your profile", Session = "Current session", Socials = "ErrorScripts", Discord = "ErrorScripts", Theme = "Appearance", Configuration = "Configurations"}
			label(card, translated[title] or title, 13, {Font = Enum.Font.BuilderSans, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 0})
			local body = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1}, card)
			list(body, 9)
			local result = setmetatable({Name = (translated[title] or title) .. " " .. title, Frame = card, Body = body, Rows = {}, Title = title, Tab = tab}, Groups)
			Library._groups[#Library._groups + 1] = result
			return result
		end
		function tab:AddLeftGroupbox(title) return group(self.Left, title) end
		function tab:AddRightGroupbox(title) return group(self.Right, title) end
		function tab:Select() selectTab(self) end
		self.ByName[name] = tab
		tabs[#tabs + 1] = tab
		connect(tab.Button.Activated, function() selectTab(tab) end)
		if Library._fit then Library._fit() end
		if not activeTab then selectTab(tab) end
		return tab
	end
	function Library:CreateWindow(config)
		if self.Window then return self.Window end
		config = config or {}
		gui = make("ScreenGui", {Name = "ErrorScripts", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 80}, ErrorScriptsGuiParent())
		self.ScreenGui = gui
		window = make("CanvasGroup", {Name = "ErrorDashboard", Size = UDim2.fromOffset(900, 600), BackgroundColor3 = colors.bg,
			BackgroundTransparency = self.Style.Transparency, BorderSizePixel = 0, GroupTransparency = 1}, gui)
		self.MainFrame = window
		corner(window, 18)
		local border = make("UIStroke", {Color = self.Accent, Thickness = 1.5, Transparency = 0.2}, window)
		local borderGradient = make("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 53, 100)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(112, 66, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 234, 255))})}, border)
		scale = make("UIScale", {Scale = 1}, window)
		local sidebar = make("Frame", {Name = "Sidebar", BackgroundColor3 = colors.card, BorderSizePixel = 0, Size = UDim2.new(0, 185, 1, 0)}, window)
		corner(sidebar, 18)
		local brand = label(sidebar, "ERROR", 27, {Font = Enum.Font.BuilderSans, Position = UDim2.fromOffset(20, 22), Size = UDim2.fromOffset(152, 35)})
		accent(brand, "TextColor3")
		local brandShadow = label(sidebar, "ERROR", 27, {Font = Enum.Font.BuilderSans, TextColor3 = Color3.fromRGB(0, 234, 255), TextTransparency = 0.78, Position = UDim2.fromOffset(22, 23), Size = UDim2.fromOffset(152, 35), ZIndex = 0})
		local scripts = label(sidebar, "S C R I P T S", 10, {Font = Enum.Font.BuilderSans, TextColor3 = colors.muted, Position = UDim2.fromOffset(22, 59), Size = UDim2.fromOffset(150, 18)})
		nav = make("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(12, 111), Size = UDim2.new(1, -24, 1, -216)}, sidebar)
		list(nav, 7)
		local sidebarStatus = label(sidebar, "SYSTEM ONLINE", 10, {Font = Enum.Font.BuilderSans, TextColor3 = Color3.fromRGB(0, 234, 180), Position = UDim2.new(0, 20, 1, -85), Size = UDim2.fromOffset(155, 17)})
		local version = label(sidebar, "ES / UNIVERSAL 1.3.3", 9, {Font = Enum.Font.BuilderSans, TextColor3 = colors.muted, Position = UDim2.new(0, 20, 1, -62), Size = UDim2.fromOffset(155, 18)})
		local avatar = make("ImageLabel", {BackgroundColor3 = colors.field, BorderSizePixel = 0, Image = "rbxthumb://type=AvatarHeadShot&id=" .. game:GetService("Players").LocalPlayer.UserId .. "&w=150&h=150", Size = UDim2.fromOffset(26, 26), Position = UDim2.new(0, 20, 1, -36)}, sidebar)
		corner(avatar, 8)
		local username = label(sidebar, "@" .. game:GetService("Players").LocalPlayer.Name, 10, {TextColor3 = colors.muted, Position = UDim2.new(0, 52, 1, -34), Size = UDim2.new(1, -60, 0, 23), TextTruncate = Enum.TextTruncate.AtEnd})
		local header = make("Frame", {Name = "DragHeader", BackgroundTransparency = 1, Active = true, Position = UDim2.fromOffset(185, 0), Size = UDim2.new(1, -185, 0, 78)}, window)
		local path = label(header, "ERRORSCRIPTS  /  " .. self.GameName, 10, {Font = Enum.Font.BuilderSans, TextColor3 = colors.muted, Position = UDim2.fromOffset(22, 18), Size = UDim2.new(1, -103, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd})
		self._bindHint = label(header, "RightShift · show / hide", 10, {TextColor3 = colors.muted, Position = UDim2.fromOffset(22, 39), Size = UDim2.new(1, -103, 0, 17)})
		local hide = button(header, "—", UDim2.fromOffset(29, 29)); hide.Position = UDim2.new(1, -76, 0, 19)
		local close = button(header, "×", UDim2.fromOffset(29, 29)); close.Position = UDim2.new(1, -41, 0, 19)
		heading = label(window, "Dashboard", 24, {Font = Enum.Font.BuilderSans, Position = UDim2.fromOffset(207, 85), Size = UDim2.new(1, -245, 0, 31)})
		subheading = label(window, "Customize your session.", 11, {TextColor3 = colors.muted, Position = UDim2.fromOffset(208, 122), Size = UDim2.new(1, -240, 0, 31), TextWrapped = true})
		local search = make("TextBox", {Text = "", PlaceholderText = words("Search options in this menu..."), ClearTextOnFocus = false, Font = Enum.Font.BuilderSans, TextSize = 11, TextColor3 = colors.text, PlaceholderColor3 = colors.muted, BackgroundColor3 = colors.card, BorderSizePixel = 0, Position = UDim2.fromOffset(207, 166), Size = UDim2.new(1, -230, 0, 35)}, window)
		corner(search, 9); pad(search, 12); bindText(search, "Search options in this menu...", "PlaceholderText")
		connect(search:GetPropertyChangedSignal("Text"), function() filterSearch(search.Text) end)
		content = make("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(207, 215), Size = UDim2.new(1, -230, 1, -260)}, window)
		activity = label(window, "AUTO PAUSED", 9, {Font = Enum.Font.BuilderSans, TextColor3 = self.Accent, Position = UDim2.new(0, 208, 1, -30), Size = UDim2.new(1, -242, 0, 18)})
		accent(activity, "TextColor3")
		noticeStack = make("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.fromOffset(280, 0), AutomaticSize = Enum.AutomaticSize.Y}, gui)
		list(noticeStack, 8)
		openButton = button(gui, "[ E ]", UDim2.fromOffset(52, 46)); openButton.Name = "ErrorScriptsToggle"; openButton.Position = UDim2.new(0, 16, 1, -65); stroke(openButton); accent(openButton, "TextColor3")
		local watermark = label(gui, "ERRORSCRIPTS / " .. self.GameName, 11, {Font = Enum.Font.BuilderSans, TextColor3 = self.Accent, Position = UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(360, 20), Visible = self.Style.Watermark})
		self._watermark = watermark; accent(watermark, "TextColor3")
		local effects = make("Frame", {BackgroundTransparency = 1, ClipsDescendants = true, Size = UDim2.fromScale(1, 1), ZIndex = 0}, window)
		local scan = make("Frame", {BackgroundColor3 = self.Accent, BackgroundTransparency = 0.97, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 2), ZIndex = 0}, effects)
		accent(scan, "BackgroundColor3")
		local particles = {}
		for i = 1, 14 do
			particles[i] = make("TextLabel", {BackgroundTransparency = 1, Font = Enum.Font.BuilderSans, Text = if i % 3 == 0 then "ERROR" else (if i % 2 == 0 then "01" else "::"), TextSize = 9, TextColor3 = if i % 2 == 0 then self.Accent else Color3.fromRGB(0, 234, 255), TextTransparency = 0.89, Size = UDim2.fromOffset(50, 16), ZIndex = 0}, effects)
		end
		local width, height, side = 900, 600, 185
		local dragged = false
		self._fit = function()
			local view = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
			local portrait = view.X < 600 and view.Y > view.X
			width, height, side = if portrait then 440 else 900, if portrait then 730 else 600, if portrait then 66 else 185
			window.Size = UDim2.fromOffset(width, height)
			scale.Scale = math.max(0.15, math.min(self.Style.Scale, (view.X - 20) / width, (view.Y - 24) / height))
			sidebar.Size = UDim2.new(0, side, 1, 0)
			brand.Text = if portrait then "E" else "ERROR"; brand.Size = UDim2.fromOffset(side - 25, 35)
			brandShadow.Visible = not portrait; scripts.Visible = not portrait; sidebarStatus.Visible = not portrait; version.Visible = not portrait; username.Visible = not portrait
			header.Position = UDim2.fromOffset(side, 0); header.Size = UDim2.new(1, -side, 0, 78)
			heading.Position = UDim2.fromOffset(side + 22, 85); heading.Size = UDim2.new(1, -side - 44, 0, 31)
			subheading.Position = UDim2.fromOffset(side + 22, 122); subheading.Size = UDim2.new(1, -side - 44, 0, 31)
			search.Position = UDim2.fromOffset(side + 22, 166); search.Size = UDim2.new(1, -side - 44, 0, 35)
			content.Position = UDim2.fromOffset(side + 22, 215); content.Size = UDim2.new(1, -side - 44, 1, -260)
			activity.Position = UDim2.new(0, side + 22, 1, -30); activity.Size = UDim2.new(1, -side - 44, 0, 18)
			for _, tab in ipairs(tabs) do
				local symbol = tabSymbol(tab.Name)
				tab.Button.Text = if portrait then symbol else symbol .. "  " .. words(titles[tab.Name] or tab.Name)
				tab.Button.TextSize = if portrait then 18 else 12
				tab.Button.TextXAlignment = if portrait then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left
				tab.Padding.PaddingLeft = UDim.new(0, if portrait then 8 else 14)
				tab.Padding.PaddingRight = tab.Padding.PaddingLeft
				tab.Layout.FillDirection = if portrait then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
				tab.Left.Size = UDim2.new(if portrait then 1 else 0.5, if portrait then 0 else -7, 0, 0)
				tab.Right.Size = tab.Left.Size
			end
			if not dragged then window.Position = UDim2.fromOffset((view.X - width * scale.Scale) / 2, (view.Y - height * scale.Scale) / 2)
			else window.Position = UDim2.fromOffset(math.clamp(window.Position.X.Offset, 0, math.max(0, view.X - width * scale.Scale)), math.clamp(window.Position.Y.Offset, 0, math.max(0, view.Y - height * scale.Scale))) end
		end
		local cameraConnection
		local function watchCamera()
			if cameraConnection then cameraConnection:Disconnect() end
			if workspace.CurrentCamera then cameraConnection = connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), self._fit) end
			self._fit()
		end
		connect(workspace:GetPropertyChangedSignal("CurrentCamera"), watchCamera); watchCamera()
		function self:SetVisible(value)
			if self.Unloaded then return end
			self._visibilityToken = (self._visibilityToken or 0) + 1
			local token = self._visibilityToken
			if value then window.Visible = true; window.GroupTransparency = if self.Style.Animations and not self.Style.ReducedMotion then 1 else 0; tween(window, {GroupTransparency = 0}, 0.28)
			else
				tween(window, {GroupTransparency = 1}, 0.18)
				task.delay(if self.Style.Animations and not self.Style.ReducedMotion then 0.19 else 0, function() if not self.Unloaded and token == self._visibilityToken then window.Visible = false end end)
			end
		end
		local function toggle() self:SetVisible(not window.Visible) end
		connect(hide.Activated, function() self:SetVisible(false) end); connect(close.Activated, function() self:SetVisible(false) end)
		local inputDrag, dragStart, origin, dragTarget, moved, suppress = nil, nil, nil, nil, false, 0
		local function beginDrag(target, input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then inputDrag = input; dragStart = input.Position; origin = target.AbsolutePosition; dragTarget = target; moved = false end
		end
		connect(header.InputBegan, function(input) beginDrag(window, input) end)
		connect(openButton.InputBegan, function(input) beginDrag(openButton, input) end)
		connect(UIS.InputChanged, function(input)
			if inputDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input == inputDrag) then
				local delta = input.Position - dragStart
				if delta.Magnitude > 6 then moved = true end
				if moved then
					local view = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
					local extent = if dragTarget == window then Vector2.new(width * scale.Scale, height * scale.Scale) else Vector2.new(52, 46)
					dragTarget.Position = UDim2.fromOffset(math.clamp(origin.X + delta.X, 0, math.max(0, view.X - extent.X)), math.clamp(origin.Y + delta.Y, 0, math.max(0, view.Y - extent.Y)))
					if dragTarget == window then dragged = true end
				end
			end
		end)
		connect(UIS.InputEnded, function(input) if inputDrag and (input == inputDrag or input.UserInputType == Enum.UserInputType.MouseButton1) then if moved then suppress = os.clock() + 0.25 end; inputDrag = nil end end)
		connect(openButton.Activated, function() if not moved and os.clock() >= suppress then toggle() end end)
		connect(UIS.InputBegan, function(input, processed)
			if not processed and not self._capturingKey and not self._skipToggle and not UIS:GetFocusedTextBox() and input.KeyCode.Name == (self.ToggleKeybind and self.ToggleKeybind.Value or self.Style.MenuKey) then toggle() end
		end)
		local elapsed, accumulator = 0, 0
		connect(game:GetService("RunService").Heartbeat, function(dt)
			if not window.Visible then return end
			accumulator += dt; if accumulator < 1 / 20 then return end; elapsed += accumulator; accumulator = 0
			local motion = self.Style.Animations and not self.Style.ReducedMotion
			borderGradient.Rotation = if motion then elapsed * 24 % 360 else 0
			scan.Visible = motion and self.Style.Glitch; scan.Position = UDim2.fromScale(0, (elapsed * 0.14) % 1)
			brandShadow.Visible = motion and self.Style.Glitch and side > 66
			brandShadow.Position = UDim2.fromOffset(22 + math.sin(elapsed * 17) * 1.8, 23)
			for i, p in ipairs(particles) do
				p.Visible = motion and self.Style.Particles
				if p.Visible then p.Position = UDim2.fromScale((i * 0.137) % 1, (elapsed * (0.01 + (i % 3) * 0.007) + i * 0.083) % 1) end
			end
			if motion and self.Style.RGB then self:SetAccent(Color3.fromHSV(elapsed * 0.075 % 1, 0.8, 1)) end
		end)
		self.Window = setmetatable({ByName = {}}, Window)
		for _, name in ipairs({"Info", "Main", "Shop", "Player", "Settings", "Games"}) do self.Window:AddTab(name) end
		selectTab(self.Window.ByName.Main)
		self:SetVisible(config.AutoShow ~= false)
		return self.Window
	end


	local Theme = {}
	function Theme:SetLibrary(lib) self.Library = lib end
	function Theme:SetFolder(folder) self.Folder = folder end
	function Theme:SaveDefault() end
	function Theme:LoadDefault() Library:ApplyAccentName(Library.Style.Accent) end
	function Theme:ApplyToTab(tab)
		if self.Applied then return end
		self.Applied = true
		local style = Library.Style
		local appearance = tab:AddRightGroupbox("Theme")
		local codes = {["Português"] = "pt", English = "en", ["Español"] = "es", ["Français"] = "fr"}
		local names = {pt = "Português", en = "English", es = "Español", fr = "Français"}
		appearance:AddDropdown("ErrorScriptsLanguage", {Text = "Language", Values = {"Português", "English", "Español", "Français"}, Default = names[Library.Language], Callback = function(value) if codes[value] then Library:SetLanguage(codes[value]) end end})
		appearance:AddDropdown("ErrorScriptsAccent", {Text = "Accent color", Values = {"Red", "Violet", "Blue", "Cyan"}, Default = style.Accent, Callback = function(value) Library:ApplyAccentName(value) end})
		appearance:AddSlider("ErrorScriptsScale", {Text = "Interface scale", Min = 0.65, Max = 1.3, Rounding = 2, Default = style.Scale, Callback = function(value) Library:SetStyle("Scale", value) end})
		appearance:AddSlider("ErrorScriptsTransparency", {Text = "Interface transparency", Min = 0, Max = 0.35, Rounding = 2, Default = style.Transparency, Callback = function(value) Library:SetStyle("Transparency", value) end})
		local effects = tab:AddRightGroupbox("Animations")
		for _, setting in ipairs({{"Animations", "Animations"}, {"ReducedMotion", "Reduced motion"}, {"Glitch", "Glitch effects"}, {"Particles", "Particles"}, {"RGB", "RGB accent"}, {"Watermark", "Watermark"}}) do
			local key = setting[1]
			effects:AddToggle("ErrorScripts" .. key, {Text = setting[2], Default = style[key], Callback = function(value) Library:SetStyle(key, value) end})
		end
		appearance:AddButton("Reset appearance", function()
			Library.Options.ErrorScriptsAccent:SetValue("Red")
			Library.Options.ErrorScriptsScale:SetValue(1)
			Library.Options.ErrorScriptsTransparency:SetValue(0)
			for key, value in pairs({Animations = true, ReducedMotion = false, Glitch = true, Particles = true, RGB = false, Watermark = true}) do Library.Toggles["ErrorScripts" .. key]:SetValue(value) end
		end)
		local session = tab:AddLeftGroupbox("Session controls")
		if not Library.Options.MenuKeybind then session:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = style.MenuKey, Text = "Menu keybind"}) end
		Library.ToggleKeybind = Library.Options.MenuKeybind
		Library.Options.MenuKeybind:OnChanged(function(value) Library:SetStyle("MenuKey", value) end)
		if Library.GameKey == "BuildThePyramid" and ErrorScriptsConfig.LoaderUrl == "" then session:AddLabel("Run the hub again after teleporting.") end
		if ErrorScriptsConfig.Discord ~= "" then session:AddButton("Copy Discord link", function() Library:Copy(ErrorScriptsConfig.Discord) end) end
		session:AddButtonPair("Rejoin server", "Unload UI", function() Library:Rejoin() end, function() Library:Unload() end)
		session:AddButtonPair("Server hop", "Pause automations", function() Library:ServerHop() end, function() Library:PauseAutomations() end)
		appearance:AddLabel("Use ES to reopen the menu.")
	end

	local Save = { Ignore = {}, Folder = "ErrorScripts/" .. Library.GameKey }
	function Save:SetLibrary(lib)
		self.Library = lib
	end
	function Save:IgnoreThemeSettings() self.Ignore.MenuKeybind = true; for id in pairs(Library.Options) do if id:sub(1, 12) == "ErrorScripts" then self.Ignore[id] = true end end; for id in pairs(Library.Toggles) do if id:sub(1, 12) == "ErrorScripts" then self.Ignore[id] = true end end end
	function Save:SetIgnoreIndexes(indexes)
		for _, id in ipairs(indexes) do
			self.Ignore[id] = true
		end
	end
	function Save:SetFolder(folder)
		self.Folder = folder
	end
	function Save:_path(name)
		if type(name) ~= "string" or not name:match("^[%w_%-]+$") then
			error("Use letters, numbers, - or _ in the name.")
		end
		return self.Folder .. "/" .. name .. ".json"
	end
	function Save:Save(name)
		if not writefile or not makefolder then
			Library:Notify("File saving is unavailable. Use clipboard export instead.")
			return
		end
		local ok, err = pcall(function()
			local current = ""
			for piece in self.Folder:gmatch("[^/]+") do
				current = if current == "" then piece else current .. "/" .. piece
				if not isfolder or not isfolder(current) then
					pcall(makefolder, current)
				end
			end
			local data = {}
			for _, collection in ipairs({ Library.Toggles, Library.Options }) do
				for id, obj in pairs(collection) do
					if not self.Ignore[id] and id:sub(1, 12) ~= "ErrorScripts" then
						data[id] = obj.Value
					end
				end
			end
			writefile(self:_path(name), JSON:JSONEncode(data))
		end)
		Library:Notify(if ok then "Configuration saved." else tostring(err))
		return ok
	end
	function Save:Load(name, quiet)
		if not readfile or not isfile then
			if not quiet then
				Library:Notify("Use clipboard import to load a configuration.")
			end
			return
		end
		local ok, err = pcall(function()
			local path = self:_path(name)
			if not isfile(path) then
				if not quiet then
					error("Configuration not found.")
				end
				return
			end
			local data = JSON:JSONDecode(readfile(path))
			for id, value in pairs(data) do
				local obj = Library.Toggles[id] or Library.Options[id]
				if obj and not self.Ignore[id] and id:sub(1, 12) ~= "ErrorScripts" then
					obj:SetValue(value)
				end
			end
		end)
		if not quiet then
			Library:Notify(if ok then "Configuration loaded." else tostring(err))
		end
	end
	function Save:BuildConfigSection(tab)
		if self.Group then return self.Group end
		local group = tab:AddRightGroupbox("Configuration")
		self.Group = group
		group:AddInput("ErrorScriptsConfigName", { Text = "Configuration name", Default = "default", Finished = true })
		self.Ignore.ErrorScriptsConfigName = true
		group:AddButton("Save configuration", function()
			self:Save(Library.Options.ErrorScriptsConfigName.Value)
		end)
		group:AddButton("Load configuration", function()
			self:Load(Library.Options.ErrorScriptsConfigName.Value)
		end)
		group:AddLabel("The default profile loads on startup.")
		if Library.GameKey ~= "DeepFishing" then
			group:AddButton("Export configuration", function()
				local data = {}
				for _, collection in ipairs({Library.Toggles, Library.Options}) do for id, obj in pairs(collection) do if not self.Ignore[id] and id:sub(1, 12) ~= "ErrorScripts" then data[id] = obj.Value end end end
				Library:Copy(JSON:JSONEncode(data))
			end)
			group:AddInput("ErrorScriptsImport", {Text = "Import configuration", Default = "", Finished = true})
			group:AddButton("Import configuration", function()
				local ok, data = pcall(JSON.JSONDecode, JSON, Library.Options.ErrorScriptsImport.Value)
				if not ok or type(data) ~= "table" then Library:Notify("That is not a valid exported config."); return end
				for id, value in pairs(data) do local obj = Library.Toggles[id] or Library.Options[id]; if obj and not self.Ignore[id] and id:sub(1, 12) ~= "ErrorScripts" then obj:SetValue(value) end end
				Library:Notify("Configuration loaded.")
			end)
		end
		return group
	end
	function Save:LoadAutoloadConfig()
		if self._autoload then return end
		self._autoload = true
		self:Load("default", true)
	end
	return Library, Theme, Save
end

-- Game methods can require ordinary ModuleScripts lazily (for example HUD).
-- Keep those calls in the normal client context, and restore the caller even
-- when a method yields or fails. Never repeat a partially completed operation.
local function ErrorScriptsDeepClientCall(callback, ...)
    local environment = {}
    if type(getgenv) == "function" then
        local ok, value = pcall(getgenv)
        if ok and type(value) == "table" then environment = value end
    end
    local function firstFunction(...)
        for index = 1, select("#", ...) do
            local value = select(index, ...)
            if type(value) == "function" then return value end
        end
    end
    local getter = firstFunction(getthreadidentity, getidentity, syn and syn.get_thread_identity,
        environment.getthreadidentity, environment.getidentity,
        environment.syn and environment.syn.get_thread_identity)
    local setter = firstFunction(setthreadidentity, setidentity, syn and syn.set_thread_identity,
        environment.setthreadidentity, environment.setidentity,
        environment.syn and environment.syn.set_thread_identity)
    local arguments = table.pack(...)
    local previous = nil
    if type(getter) == "function" and type(setter) == "function" then
        local read, value = pcall(getter)
        if read and type(value) == "number" then previous = value end
    end

    local function restore()
        if previous == nil then return true end
        local restored, reason = pcall(setter, previous)
        if not restored then return false, tostring(reason) end
        local read, identity = pcall(getter)
        if not read or identity ~= previous then return false, "executor did not restore the calling context" end
        return true
    end

    if previous ~= nil and previous ~= 2 then
        local switched, reason = pcall(setter, 2)
        local read, identity = pcall(getter)
        if not switched or not read or identity ~= 2 then
            restore()
            error("Executor could not enter the game's client context: " .. tostring(reason or identity), 0)
        end
    end
    local result = table.pack(xpcall(function()
        return callback(table.unpack(arguments, 1, arguments.n))
    end, function(reason)
        if debug and type(debug.traceback) == "function" then
            return debug.traceback(tostring(reason), 2)
        end
        return tostring(reason)
    end))
    local restored, restoreReason = restore()
    if not restored then
        error(tostring(result[2] or "Client call completed") .. "\nContext restoration failed: " .. restoreReason, 0)
    end
    if not result[1] then error(result[2], 0) end
    return table.unpack(result, 2, result.n)
end


-- Keep auto casting on Fishing's native charge/release path. The current
-- controller checks inventory room, whereas the previous version checked bait.
local function ErrorScriptsCreateDeepCaster(context)
    local caster = { Busy = false }
    local generation = 0
    local busyGeneration = nil
    local nextAttempt = 0
    local sawActive = false
    local ownedCharge = nil
    local lastErrorAt = -math.huge
    local stage = "preparing"
    local clientDepth = 0
    local pendingReports = {}
    local now = context.Now or os.clock
    local spawn = context.Spawn or task.spawn
    local wait = context.Wait or task.wait
    local waitFrame = context.WaitFrame or function()
        game:GetService("RunService").RenderStepped:Wait()
    end

    local function enabled(token)
        return (token == nil or token == generation)
            and not (context.IsUnloaded and context.IsUnloaded())
            and context.IsEnabled()
    end

    local function driving(value)
        if context.SetDriving then context.SetDriving(value) end
    end

    local function delayAfterCast()
        return context.IsFast and context.IsFast() and 0.15 or 1
    end

    local function deliver(message)
        if context.Report then context.Report(message) else warn("[ErrorScripts] " .. message) end
    end

    local function report(reason)
        if now() - lastErrorAt < 5 then return end
        lastErrorAt = now()
        local message = "Deep Fishing auto cast: " .. tostring(reason)
        if clientDepth > 0 then
            pendingReports[#pendingReports + 1] = message
        else
            deliver(message)
        end
    end

    local function runClient(callback)
        if type(context.RunClient) ~= "function" then return callback() end
        clientDepth += 1
        local result = table.pack(pcall(context.RunClient, callback))
        clientDepth -= 1
        if clientDepth == 0 then
            local messages = pendingReports
            pendingReports = {}
            for _, message in ipairs(messages) do deliver(message) end
        end
        if not result[1] then error(result[2], 0) end
        return table.unpack(result, 2, result.n)
    end

    local function cinematicBusy(cinematic)
        return cinematic and (cinematic.Active == true or rawget(cinematic, "OutroToken") ~= nil)
    end

    local function bagRoom(cinematic)
        -- Check bag space directly; keep bait capacity as a compatibility fallback.
        if type(cinematic.GetBagRoom) == "function" then
            return cinematic:GetBagRoom()
        end
        if type(cinematic.GetBaitCapacity) == "function" then
            return cinematic:GetBaitCapacity()
        end
        error("Fishing capacity method is unavailable", 0)
    end

    local function isPerfect(fishing)
        local hookT = tonumber(fishing.HookT)
        if not hookT then return false end
        if type(fishing.TierAt) == "function" then
            return fishing:TierAt(hookT) == "Perfect"
        end
        local hud = type(fishing.HUD) == "function" and fishing:HUD()
        local steps = hud and type(hud.GetHookSteps) == "function" and hud:GetHookSteps()
        if type(steps) ~= "number" or steps < 2 then return false end
        local slot = 1 + hookT * (steps - 1)
        return slot >= 9 and slot < 12
    end

    local function abortCharge(record)
        record = record or ownedCharge
        if not record then return end
        if ownedCharge == record then ownedCharge = nil end
        local fishing, cinematic = record.Fishing, record.Cinematic
        if not fishing.Charging then return end
        -- A manually restarted charge has another meter connection.
        if record.Connection and fishing.HookConnection ~= record.Connection then return end
        local ok, reason = pcall(runClient, function()
        stage = "cancel charge"
        fishing.Charging = false
        if fishing.HookConnection then
            pcall(function() fishing.HookConnection:Disconnect() end)
            fishing.HookConnection = nil
        end
        pcall(function() fishing:HUD():HideHook() end)
        -- StopHook would fire the rod. EndImmediate cleans the charge without
        -- launching it, and restores the game's camera/character controls.
        if cinematic.Active and not cinematic.ThrowFired and type(cinematic.EndImmediate) == "function" then
            cinematic:EndImmediate()
        end
        end)
        if not ok then report(reason) end
    end

    function caster:AwaitPerfect(fishing, token)
        fishing = fishing or context.GetFishing()
        if not fishing or not fishing.Charging or not enabled(token) then return false end
        return runClient(function()
        local deadline = now() + 2
        while fishing.Charging and enabled(token) do
            stage = "Perfect meter"
            if isPerfect(fishing) then
                -- StopHook computes HookPower, scores the throw, and invokes
                -- ThrowCinematic:ReleaseCharge in the game controller itself.
                stage = "release hook"
                fishing:StopHook()
                if ownedCharge and ownedCharge.Fishing == fishing then ownedCharge = nil end
                return true
            end
            if now() >= deadline then
                -- Release the real meter position if a slow/stalled meter never
                -- enters the perfect band. Never fabricate HookT or ThrowTier.
                report("Hook meter did not reach the Perfect range; releasing the current charge.")
                stage = "release hook"
                fishing:StopHook()
                if ownedCharge and ownedCharge.Fishing == fishing then ownedCharge = nil end
                return true
            end
            waitFrame()
        end
        if not enabled(token) and ownedCharge and (token == nil or ownedCharge.Token == token) then
            abortCharge(ownedCharge)
        end
        return false
        end)
    end

    function caster:Stop()
        generation += 1
        busyGeneration = nil
        self.Busy = false
        sawActive = false
        abortCharge()
        driving(false)
    end

    local function prepareCast(fishing, cinematic, token)
        stage = "preparing"
        if not enabled(token) then return end
        if context.IsBlocked and context.IsBlocked() then return end
        if fishing.Charging then
            driving(true)
            caster:AwaitPerfect(fishing, token)
            return
        end
        if cinematicBusy(cinematic) then return end
        stage = "screen check"
        if type(fishing.UIOwnsScreen) == "function" and fishing:UIOwnsScreen() then return end

        if fishing.CanThrow == false and context.MoveToFishing then
            stage = "fishing area"
            context.MoveToFishing()
            wait(0.4)
            if not enabled(token) then return end
        end
        if context.ShouldUseBait and context.ShouldUseBait() and context.UseBait then
            stage = "use bait"
            context.UseBait()
            wait(0.15)
            if not enabled(token) then return end
        end
        for _ = 1, 5 do
            stage = "equip rod"
            if not enabled(token) or cinematicBusy(cinematic) then return end
            if context.IsBlocked and context.IsBlocked() then return end
            if context.EquipRod then context.EquipRod() end
            if type(fishing.IsRodHeld) ~= "function" or fishing:IsRodHeld() then break end
            wait(0.1)
        end
        if not enabled(token) or cinematicBusy(cinematic) then return end
        if type(fishing.IsRodHeld) == "function" and not fishing:IsRodHeld() then return end
        if type(fishing.UIOwnsScreen) == "function" and fishing:UIOwnsScreen() then return end
        stage = "cast check"
        if not fishing:CanStartThrow() then return end

        stage = "bag room"
        local room = bagRoom(cinematic)
        if type(room) ~= "number" then error("Fishing capacity returned an invalid value", 0) end
        if room <= 0 then
            if context.ShouldSell and context.ShouldSell() and context.Sell then
                stage = "sell fish"
                context.Sell()
                wait(0.25)
                if not enabled(token) then return end
                stage = "bag room"
                room = bagRoom(cinematic)
            end
            if type(room) ~= "number" or room <= 0 then return end
        end
        -- Selling/equipping can yield. Recheck the controller rather than bypass
        -- its area, swimming, boat, rod, cutscene, and active-cast restrictions.
        if not enabled(token) or cinematicBusy(cinematic) then return end
        if context.IsBlocked and context.IsBlocked() then return end
        if type(fishing.UIOwnsScreen) == "function" and fishing:UIOwnsScreen() then return end
        if not fishing:CanStartThrow() then return end
        driving(true)
        local record = { Fishing = fishing, Cinematic = cinematic, Token = token }
        ownedCharge = record
        stage = "start hook"
        fishing:StartHook()
        record.Connection = fishing.HookConnection
        if not enabled(token) then abortCharge(record); return end
        if fishing.Charging and enabled(token) then
            caster:AwaitPerfect(fishing, token)
        elseif ownedCharge == record then
            ownedCharge = nil
        end
    end

    function caster:Step()
        if not enabled() then
            if self.Busy or sawActive then self:Stop() else driving(false) end
            return
        end
        local fishing = context.GetFishing()
        local cinematic = context.GetCinematic()
        if not fishing or not cinematic then return end
        if context.IsBlocked and context.IsBlocked() then return end
        -- BeginCharge now sets Active immediately. A charging cast still needs
        -- AwaitPerfect; only flight/return/outro should block a new worker.
        if not fishing.Charging and cinematicBusy(cinematic) then
            sawActive = true
            driving(true)
            return
        end
        if sawActive then
            sawActive = false
            driving(false)
            nextAttempt = now() + delayAfterCast()
            return
        end
        if self.Busy or now() < nextAttempt then return end
        self.Busy = true
        local token = generation
        busyGeneration = token
        spawn(function()
            local ok, reason = xpcall(function()
                runClient(function() prepareCast(fishing, cinematic, token) end)
            end, function(err)
                local message = "[" .. stage .. "] " .. tostring(err)
                if debug and type(debug.traceback) == "function" then return debug.traceback(message, 2) end
                return message
            end)
            if busyGeneration ~= token then return end
            busyGeneration = nil
            caster.Busy = false
            if not ok then abortCharge() end
            if not enabled(token) or not cinematicBusy(cinematic) then driving(false) end
            nextAttempt = now() + (ok and delayAfterCast() or 1)
            if not ok and enabled(token) then report(reason) end
        end)
    end

    return caster
end


-- Share one sale transaction between the timer, manual button and full-bag cast.
local function ErrorScriptsCreateDeepSeller(context)
    local seller = { Busy = false }
    local generation = 0
    local owner = nil
    local nextAttempt = 0
    local lastErrorAt = -math.huge
    local now = context.Now or os.clock
    local spawn = context.Spawn or task.spawn

    local function unloaded()
        return context.IsUnloaded and context.IsUnloaded()
    end

    local function report(reason)
        if unloaded() or now() - lastErrorAt < 5 then return end
        lastErrorAt = now()
        local message = "Deep Fishing auto sell: " .. tostring(reason)
        if context.Report then
            local shown = pcall(context.Report, message)
            if not shown then warn("[ErrorScripts] " .. message) end
        else
            warn("[ErrorScripts] " .. message)
        end
    end

    local function release(record)
        if owner ~= record then return end
        owner = nil
        seller.Busy = false
    end

    local function reserve(automatic)
        local record = { Automatic = automatic, Token = generation, Started = false }
        owner = record
        seller.Busy = true
        return record
    end

    local function runClient(callback)
        if type(context.RunClient) == "function" then
            return context.RunClient(callback)
        end
        return callback()
    end

    local function thresholdReached()
        -- Contexts without the count controls keep their existing sale contract.
        if not context.GetFishCount or not context.GetThreshold then return true end
        local count = context.GetFishCount()
        if type(count) ~= "number" or count ~= count or count < 0 or count == math.huge then
            error("The backpack fish count is unavailable.")
        end
        local threshold = tonumber(context.GetThreshold()) or 2000
        if threshold ~= threshold then threshold = 2000 end
        threshold = math.floor(math.clamp(threshold, 0, 2500))
        -- Zero means any available fish, never a trip for an empty backpack.
        return count > 0 and count >= threshold
    end

    local function refusal(response, detail)
        if detail ~= nil then return tostring(detail) end
        if type(response) == "string" then return response end
        if type(response) == "table" then
            local reason = response.Reason or response.Error or response.Code or response.Message
            if reason ~= nil then return tostring(reason) end
            if type(response.Amount) == "number" and response.Amount <= 0 then
                return "The server did not sell any fish (Amount = " .. tostring(response.Amount) .. ")."
            end
        end
        return "The server did not confirm a fish sale."
    end

    local function perform(record)
        if owner ~= record then return false, "cancelled" end
        record.Started = true
        local function canContinue()
            return not unloaded() and (not record.Automatic
                or (record.Token == generation and context.IsEnabled() and thresholdReached()))
        end
        local result = table.pack(xpcall(function()
            return runClient(function()
                if unloaded() then return "blocked", "unloaded" end
                if record.Automatic and not thresholdReached() then return "blocked", "threshold" end
                if not canContinue() then return "blocked", "cancelled" end
                local fishing = context.GetFishing and context.GetFishing()
                local cinematic = context.GetCinematic and context.GetCinematic()
                if (fishing and fishing.Charging)
                    or (cinematic and (cinematic.Active or cinematic.AwaitingServer
                        or rawget(cinematic, "OutroToken") ~= nil)) then
                    return "blocked", "fishing"
                end
                return "invoked", context.Invoke(canContinue, record.Automatic)
            end)
        end, function(reason)
            if debug and type(debug.traceback) == "function" then
                return debug.traceback(tostring(reason), 2)
            end
            return tostring(reason)
        end))
        release(record)
        -- RunClient has returned and restored the caller before any UI report.
        if not result[1] then
            report(result[2])
            return false, "error", result[2]
        end
        if result[2] == "blocked" then return false, result[3] end
        local response = result[3]
        if type(response) == "table" and type(response.Amount) == "number" and response.Amount > 0 then
            return true
        end
        if result[4] == "cancelled" or result[4] == "empty" then return false, result[4] end
        if type(response) == "table" and response.Amount == 0 and result[4] == nil
            and not (response.Reason or response.Error or response.Code or response.Message) then
            return false, "empty"
        end
        local reason = refusal(response, result[4])
        report(reason)
        return false, "refused", reason
    end

    function seller:Request(automatic)
        if unloaded() then return false, "unloaded" end
        if self.Busy then return false, "busy" end
        return perform(reserve(automatic == true))
    end

    function seller:Step()
        if unloaded() then return false, "unloaded" end
        if not context.IsEnabled() then return false, "disabled" end
        if self.Busy then return false, "busy" end
        if context.IsCastPreparing and context.IsCastPreparing() then return false, "preparing" end
        local fishing = context.GetFishing and context.GetFishing()
        local cinematic = context.GetCinematic and context.GetCinematic()
        if (fishing and fishing.Charging)
            or (cinematic and (cinematic.Active or cinematic.AwaitingServer
                or rawget(cinematic, "OutroToken") ~= nil)) then return false, "fishing" end
        if now() < nextAttempt then return false, "cooldown" end
        local counted, ready = pcall(runClient, thresholdReached)
        if not counted then
            nextAttempt = now() + 2
            report(ready)
            return false, "error", ready
        end
        if not ready then
            return false, "threshold"
        end
        nextAttempt = now() + 2
        local record = reserve(true)
        local scheduled, reason = pcall(spawn, function() perform(record) end)
        if not scheduled then
            release(record)
            report(reason)
            return false, "error", reason
        end
        return true
    end

    function seller:Stop()
        generation += 1
        nextAttempt = 0
        -- A queued callback cannot invoke after Stop. An already running sale
        -- retains the mutex until its response, even if Auto Sell is disabled.
        if owner and owner.Automatic and not owner.Started then release(owner) end
    end

    return seller
end


-- Use the live world's NPC_Sell, never saved coordinates from another world.
local function ErrorScriptsDeepSellTrip(context, canContinue, automatic)
    if not canContinue() then return nil, "cancelled" end
    if context.IsFishingBusy() then return nil, "cancelled" end
    local inventory = context.GetInventory()
    local hasFish = false
    if type(inventory) == "table" then
        for _, item in pairs(inventory) do
            if type(item) == "table" and item.Type == "Fish"
                and not (context.IsLocked and context.IsLocked(item)) then
                hasFish = true
                break
            end
        end
    end
    if not hasFish then return nil, "empty" end

    local folders = context.WorldFolder
    if not folders or type(folders.Get) ~= "function" or type(folders.Interactable) ~= "function" then
        return nil, "The current world's fish seller could not be located."
    end
    local world = folders.Get()
    local npc = folders.Interactable("NPC_Sell")
    local anchor = npc and npc:FindFirstChild("HumanoidRootPart")
    if not world or not npc or not anchor or not anchor:IsA("BasePart") then
        return nil, "NPC_Sell is unavailable in the current world."
    end
    if not npc:IsDescendantOf(world) then return nil, "cancelled" end
    local root = context.GetRoot()
    if not root or not root.Parent then return nil, "Character is unavailable for selling." end
    local humanoid = context.GetHumanoid and context.GetHumanoid()
    if humanoid and (humanoid.SeatPart or humanoid.Sit) then
        return nil, "Leave your seat before selling fish."
    end
    if humanoid and type(humanoid.Health) == "number" and humanoid.Health <= 0 then
        return nil, "cancelled"
    end

    local origin = root.CFrame
    local destination = nil
    local moved = false
    local function sameCharacterAndWorld()
        return context.GetRoot() == root and root.Parent ~= nil and folders.Get() == world
    end
    local function ready()
        local currentHumanoid = context.GetHumanoid and context.GetHumanoid()
        local characterReady = not currentHumanoid or (not currentHumanoid.SeatPart and not currentHumanoid.Sit
            and (type(currentHumanoid.Health) ~= "number" or currentHumanoid.Health > 0))
        return canContinue() and sameCharacterAndWorld() and characterReady and not context.IsFishingBusy()
    end
    local result = table.pack(xpcall(function()
        if not ready() then return nil, "cancelled" end
        if (root.Position - anchor.Position).Magnitude > 4.5 then
            local forward = anchor.CFrame.LookVector * Vector3.new(1, 0, 1)
            if forward.Magnitude < 0.001 then forward = Vector3.new(0, 0, 1) else forward = forward.Unit end
            destination = anchor.Position + forward * 4
            moved = true
            root.CFrame = CFrame.lookAt(destination, anchor.Position)
            root.AssemblyLinearVelocity = Vector3.zero
            -- Give the server time to receive the character's new position.
            context.Wait(0.4)
        end
        if not ready() then return nil, "cancelled" end
        if not anchor.Parent or not npc:IsDescendantOf(world) then return nil, "cancelled" end
        if (root.Position - anchor.Position).Magnitude > 6 then
            return nil, "The character could not reach the fish seller."
        end
        return context.Invoke()
    end, function(reason)
        if debug and type(debug.traceback) == "function" then return debug.traceback(tostring(reason), 2) end
        return tostring(reason)
    end))

    -- Restore only a trip we still own. Respawns, world changes, manual travel,
    -- seating and a newly started manual cast must not restore an old position.
    local restored, restoreError = pcall(function()
        if not moved or not sameCharacterAndWorld() or context.IsFishingBusy() then return end
        local currentHumanoid = context.GetHumanoid and context.GetHumanoid()
        if currentHumanoid and (currentHumanoid.SeatPart or currentHumanoid.Sit
            or (type(currentHumanoid.Health) == "number" and currentHumanoid.Health <= 0)) then return end
        if destination and (root.Position - destination).Magnitude > 12 then return end
        root.CFrame = origin
        root.AssemblyLinearVelocity = Vector3.zero
    end)
    if not result[1] then
        error(tostring(result[2]) .. (if restored then "" else "\nReturn failed: " .. tostring(restoreError)), 0)
    end
    if not restored then error("Could not return from the fish seller: " .. tostring(restoreError), 0) end
    return table.unpack(result, 2, result.n)
end


-- Deep Fishing adapter: mechanics retained from the supplied ErrorScripts.
-- Called by the common hub only after successful key validation.
-- The shared interface supplies Library, ThemeManager, and SaveManager.
local function ErrorScriptsDeepFishing(ErrorScriptsInterface)
local Library, ErrorScriptsThemeManager, ErrorScriptsSaveManager = ErrorScriptsInterface()
if Library.Unloaded then return Library end
local Recovered
local Eq = {}
Recovered = nil
Eq[2] = nil
Eq[4] = nil
Eq[5] = nil
Eq[8] = nil
local tG
local r4
local sM
local tt
local rM
local st
local ta
local sS
local tz
local sz
local sg
local sY
local tF
local sF
local rF
local sm
local s3
local r3
local sL
local ts
local rL
local ss
local s9
local r9
local sR
local RunService
local rR
local sy
local tf
local sf
local sX
local rX
local sE
local rE
local tl
local s2
local sl
local r2
local sK
local rK
local sr
local s8
local tr
local r8
local sQ
local rQ
local sx
local te
local se
local sW
local rW
local sD
local tk
local rD
local sk
local s1
local r1
local sJ
local tD
local rJ
local sq
local s7
local r7
local sP
local Options
local rP
local sw
local td
local sd
local sV
local Toggles
local rV
local sC
local s0
local r0
local sI
local tp
local sp
local s6
local r6
local rI
local tv
local sO
local sv
local tc
local sc
local CollectionService
local tB
local sB
local rO
local si
local Workspace
local r_
local sH
local to
local so
local s5
local r5
local sN
local rN
local sb
local rT
local sA
local th
local tA
local sh
local rZ
Recovered = {
    ["OwnCollectionAim"] = function()
        if not Recovered.CollectionAim or Recovered.CollectionAim.ThrowId ~= sc.ThrowId then
            Recovered.CollectionAim = {
                Cinematic = sc,
                ThrowId = sc.ThrowId,
                Previous = sc.AimLocked,
            }
        end
        sc.AimLocked = true
    end,
    ["ReleaseCollectionAim"] = function()
        local ownership = Recovered.CollectionAim
        Recovered.CollectionAim = nil
        if not ownership then return end
        local cinematic = ownership.Cinematic
        if cinematic.ThrowId ~= ownership.ThrowId then return end
        if cinematic.AimLocked == true and not cinematic.ReelRequested
            and not cinematic.CatchWindowOver and not cinematic.Returning then
            cinematic.AimLocked = ownership.Previous
        end
    end,
	["CollectFastCatch"] = function(school, fish)
		if not rQ("FastFishing") or Library.Unloaded or not school or type(school.TryGrab) ~= "function" then
			return false
		end
		-- Try the normal grab handler immediately, with one target per frame.
		-- Rejected/pending targets have a retry delay; never fabricate catch results.
		local attempts = Recovered.FastCatchAttempts
		if not attempts then
			attempts = setmetatable({}, { __mode = "k" })
			Recovered.FastCatchAttempts = attempts
		end
		local now = os.clock()
		local pending = false
		for _, catch in pairs(fish) do
			if sV(catch) then
				pending = true
				if not attempts[catch] or now - attempts[catch] >= 0.15 then
					local part = catch.model.PrimaryPart
					attempts[catch] = now
					r0 = catch
					local ok = pcall(function()
                        local catchFrame = catch.catchCFrame or part.CFrame
                        local point = catchFrame.Position
                        if typeof(catch.catchOffset) == "Vector3" then
                            point = catchFrame:PointToWorldSpace(catch.catchOffset)
                        end
						school:TryGrab(point)
					end)
					if ok and (catch.caught or catch.fighting) then
						return true
					end
					-- Native TryGrab returns nil even when it rejects a target. Keep
                    -- normal tracking available until the catch state changes.
					return false
				end
			end
		end
		-- Do not bypass the retry delay through the original tracking path.
		return pending
	end,
	-- FishingObjects.RollKeyForCast identifies fragments by Key.Items[name].Kind.
	["FragmentsEnabled"] = function()
		return rQ("AutoCollectFragments")
	end,
	["FindTypeForFragments"] = function(find)
		if type(find) ~= "table" or type(find.name) ~= "string" then
			return nil
		end
		-- Uses the FishingObjects lookup already present in this script.
		local ok, findType = pcall(function()
			local definition = s6:Get(find.name, true)
			return definition and definition.Type
		end)
		if ok and type(findType) == "string" then
			return findType
		end
		return nil
	end,
	["MatchesFragment"] = function(find)
		if type(find) ~= "table" or not find.special or type(find.name) ~= "string" then
			return false
		end
		local ok, isFragment = pcall(function()
			local items = s6.Item.Key.Items
			if type(items) ~= "table" then
				return false
			end
			local definition = items[find.name]
			return type(definition) == "table" and definition.Kind == "Fragment"
		end)
		return ok and isFragment == true
	end,
	["EggsEnabled"] = function()
        return rQ("AutoCollectEggs")
    end,
    ["MatchesEgg"] = function(find)
        if type(find) ~= "table" or type(find.name) ~= "string" then return false end
        -- The supplied FishingObjects source explicitly uses Item.Egg.Items.
        -- Match catalog identity, never words embedded in an object's name.
        local ok, isEgg = pcall(function()
            local egg = s6.Item and s6.Item.Egg
            if egg and type(egg.Items) == "table" and egg.Items[find.name] ~= nil then return true end
            local definition = s6:Get(find.name, true)
            return definition and definition.Type == "Egg"
        end)
        return ok and isEgg == true
    end,
    ["CopyEggIdentifiers"] = function()
        local egg = s6.Item and s6.Item.Egg
        local items = egg and egg.Items
        local rows = {}
        if type(items) == "table" then
            for name in pairs(items) do
                if type(name) == "string" then rows[#rows + 1] = name end
            end
        end
        if #rows == 0 then
            Library:Notify("No egg names found in the game catalog.")
            return
        end
        table.sort(rows)
        local report = table.concat(rows, "\n")
        local copy = setclipboard or toclipboard
        if type(copy) == "function" then
            copy(report)
            Library:Notify("Egg names copied from the game catalog.")
        else
            print(report)
            Library:Notify("Egg names printed to the console.")
        end
    end,
    ["CopyActiveFindIdentifiers"] = function()
		local school = (sc and sc.Sub and sc.Sub.FishSchool) or rZ
		local fish = school and school.Fish
		if type(fish) ~= "table" then
			Library:Notify("Start fishing and wait for the egg or find to appear.")
			return
		end
		local rows, seen = {}, {}
		for _, find in pairs(fish) do
			if type(find) == "table" and type(find.name) == "string" then
				local findType = Recovered.FindTypeForFragments(find)
				local row = "name:"
					.. find.name
					.. " | type:"
					.. (findType or "unknown")
					.. " | special:"
					.. tostring(not not find.special)
					.. " | fragment:"
					.. tostring(Recovered.MatchesFragment(find))
                    .. " | egg:"
                    .. tostring(Recovered.MatchesEgg(find))
				if not seen[row] then
					seen[row] = true
					rows[#rows + 1] = row
				end
			end
		end
		if #rows == 0 then
			Library:Notify("No catches visible. Try while the egg or find is on screen.")
			return
		end
		table.sort(rows)
		local report = table.concat(rows, "\n")
		local copy = setclipboard or toclipboard
		if type(copy) == "function" then
			copy(report)
			Library:Notify("Active find names/types and egg classification copied.")
		else
			print(report)
			Library:Notify("Active find names/types printed to the console.")
		end
	end,

	["NumberRange"] = NumberRange,
	[16] = function()
		return r9("CollectFindTypes")
	end,
	["debug"] = debug,
	["task_spawn"] = task.spawn,
	[73] = function()
		local Ba, Bb, Bc = nil, nil, nil
		Ba = Options.CodeText
		if Ba then
			Ba = Options.CodeText.Value
		end
		Bb, Bc = sX(Ba)
		Library:Notify(Bc)
	end,
	[76] = function(bg, bh, ...)
		local u0, u1 = nil, nil
		u0 = tv.Client(bg)
		u1 = bh
		if not u1 then
			u1 = 5
		end
		return u0:Invoke(u1, ...)
	end,
	["Vector2"] = Vector2,
	[103] = function(find)
		if type(find) ~= "table" or not find.special then
			return false
		end
		if find.caught or find.escaped or find.fighting then
			return false
		end
		if not find.model or not find.model.Parent or not find.model.PrimaryPart then
			return false
		end
		if Recovered.EggsEnabled() and Recovered.MatchesEgg(find) then
            return true
        end
        if Recovered.FragmentsEnabled() and Recovered.MatchesFragment(find) then
			return true
		end
		if rQ("AutoCollectFinds") then
			return r3(find)
		end
		return rQ("AutoCollectFish") and not s1()
	end,
	[114] = function(b7)
		local vE = nil
		vE = (sQ(tD(b7)))
		if vE then
			vE = st(tc(b7))
		end
		return vE
	end,
	[120] = function()
		if not rQ("AutoBuyUpgrades") then
			return
		else
			if (os.clock() - sk) < 0.75 then
				return
			else
				sk = os.clock()
				r_()
			end
		end
	end,
	[122] = function(ar, as)
		local uK, uL, uP = nil, nil, nil
		uK = ar.Price
		uP = (if uK then 1 else 0)
		if not (uP == 1) then
			uK = 0
		end
		uL = as.Price
		if not uL then
			uL = 0
		end
		if uK ~= uL then
			uK = ar.Price
			if not uK then
				uK = 0
			end
			uL = as.Price
			if not uL then
				uL = 0
			end
			return (uK < uL)
		else
			return (ar.Name < as.Name)
		end
	end,
	[126] = function(optionName)
		local option = Options[optionName]
		local values = option and option.Value
		if type(values) ~= "table" then
			return nil
		end
		local selected = {}
		for name, enabled in pairs(values) do
			if type(name) == "string" and enabled == true then
				selected[name] = true
			end
		end
		-- Empty selection retains the original "all types" behavior.
		return next(selected) ~= nil and selected or nil
	end,
	[128] = function()
		local Bj, Bk = nil, nil
		while true do
			if not Library.Unloaded then
				Recovered[892](tp)
				Recovered[892](sK)
				Recovered[892](s2)
				Recovered[892](sI)
				Recovered[892](sp)
				Recovered[892](si)
				Bj = (rQ("AutoUseBait"))
				if not Bj then
					Bj = rQ("AutoUseBestBait")
				end
				Bk = Bj
				if Bk then
					Bk = (not rQ("AutoPerfectFishing"))
				end
				if Bk then
					Recovered[892](s5)
				end
				local Ev_cfg1 = Recovered.task.wait
				Recovered.task_wait(if rQ("FastFishing") and rQ("AutoPerfectFishing") then 0.05 else 0.15)
				continue
			else
				break
			end
		end
	end,
	[138] = function(g5)
		local zw, zA = nil, nil
		zA = (if type(g5) ~= "string" then 1 else 0)
		if zA == 1 then
			return false, "Enter a code first"
		else
			g5 = string.match(g5, "^%s*(.-)%s*$")
			if g5 == "" then
				return false, "Enter a code first"
			else
				if tB(g5) then
					return false, "Already redeemed"
				else
					zw = Recovered[892](sF, "Codes", g5)
					if not zw then
						return false, "Failed to send code"
					else
						return true, ("Sent " .. g5)
					end
				end
			end
		end
	end,
	[150] = function(bW)
		local vu = nil
		if type(bW) ~= "table" then
			return "None"
		else
			vu = (type(bW.mutation) == "string")
			if vu then
				vu = (bW.mutation ~= "")
			end
			if vu then
				return bW.mutation
			else
				vu = (type(bW.pendingMutation) == "string")
				if vu then
					vu = (bW.pendingMutation ~= "")
				end
				if vu then
					return bW.pendingMutation
				else
					return "None"
				end
			end
		end
	end,
	["Vector3"] = Vector3,
	["CFrame_lookAt"] = CFrame.lookAt,
	[195] = function(aR, aS)
		return string.format('<font color="%s">%s</font>', aS, aR)
	end,
	["Enum"] = Enum,
	[209] = function(c_)
		local En = math.max
		local v8, v9, wa, wb, wf = nil, nil, nil, nil, nil
		v8 = c_.model
		if v8 then
			v8 = c_.model.PrimaryPart
		end
		v9 = v8
		if not v9 then
			return rI, rI
		else
			v8 = sc.Sub
			if v8 then
				v8 = sc.Sub.FishSchool
			end
			wa = v8
			if not wa then
				wa = rZ
			end
			v8 = wa
			wa = v8
			if wa then
				wa = v8.CatchBandScale
			end
			v8 = wa
			if not v8 then
				v8 = 1
			end
			wa = v8
			wf = (if c_.catchHalf then 1 else 0)
			if wf == 1 then
				wb = (c_.catchHalf * wa)
			else
				wb = ((v9.Size * 0.5) * wa)
			end
			return En(wb.X, rI), En(wb.Y, rI)
		end
	end,
	[216] = function(d3)
		rV = d3
		if r6 then
			r6.DrivingThrow = d3
		end
	end,
	[236] = function(dY)
		local wN, wP, wQ, wR, wT = nil, nil, nil, nil, nil
		wN = 0
		if type(dY) ~= "table" then
			return 0
		else
			wQ = false
			for d_, d0 in dY do
				wR = d_
				wT = d0
				local wS = wR
				local wU = wT
				local wP = nil
				wP = 3
				if sV(wU) then
					wN += 1
				end
				if wQ then
					break
				end
			end
			return wN
		end
	end,
	[249] = function()
		if sC() then
			Library:Notify("Bought best affordable rod")
		else
			Library:Notify("No affordable rod")
		end
	end,
	[312] = function(aK, aL)
		if setclipboard then
			setclipboard(aK)
		else
			if toclipboard then
				toclipboard(aK)
			end
		end
		Library:Notify(aL)
	end,
	["Vector3_new"] = Vector3.new,
	[316] = function()
		local yz, yA, yB, yC, yD, yE, yI, yJ, yK, yL, yN = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		yz = sS()
		if not yz then
			return false
		else
			yA = yz.BaitShop
			yB = yA
			yI = (if yB then 1 else 0)
			if yI == 1 then
				yB = yA.Stock
			end
			yA = {}
			yC = yB
			if not yC then
				yC = yA
			end
			yA = yC
			yB = yz.Cash
			if not yB then
				yB = 0
			end
			yz = nil
			yC = yB
			yK = false
			for gi, gj in tl do
				yL = gi
				yN = gj
				local yM = yL
				local yO = yN
				local yJ = nil
				yJ = 14
				yB = (so(yA, yO.Name))
				if yB then
					yD = yO.Price
					if not yD then
						yD = 0
					end
					yB = (yD <= yC)
				end
				if yB then
					yB = not yz
					if not yB then
						yD = yO.Price
						if not yD then
							yD = 0
						end
						yE = yz.Price
						if not yE then
							yE = 0
						end
						yB = (yD > yE)
					end
					if yB then
					end
				end
				if yK then
					break
				end
			end
			if not yz then
				return false
			else
				return Recovered[892](sF, "BaitShop", "Buy", yz.Name)
			end
		end
	end,
	[323] = function(dD, dE)
		local wy, wz, wA, wB, wC, wD, wF, wG, wH, wJ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		wy = math.huge
		wz = nil
		wG = false
		for dH, dI in dD do
			wH = dH
			wJ = dI
			local wI = wH
			local wK = wJ
			local wF = nil
			wF = 8
			if sY(wK, dE) then
				wA = wK.model.PrimaryPart
				wB = wA.Position.Y
				wA, wC = rP(wK)
				wA = (dE <= ((wB + wC) + 1))
				wC = math.abs((wB - dE))
				wB = wK.markerScore
				if not wB then
					wB = 0
				end
				wD = (wC - (wB * 0.01))
				if not wA then
					wD += 100
				end
				if wD < wy then
					wy = wD
					wz = wK
				end
			end
			if wG then
				break
			end
		end
		return wz
	end,
	["NumberSequenceKeypoint_new"] = NumberSequenceKeypoint.new,
	[414] = function()
		local xy, xz, xA, xB, xF = nil, nil, nil, nil, nil
		xy = sS()
		if not xy then
			return false
		else
			xz = xy.PlaytimeGiftStage
			if not xz then
				xz = 0
			end
			xA = xz
			xz = sv.Stages
			if type(xz) ~= "table" then
				return false
			else
				xB = xz[xA]
				xF = (if xB then 1 else 0)
				if not (xF == 1) then
					xB = xz[tostring(xA)]
				end
				xz = xB
				if not xz then
					return false
				else
					xz = xy.PlaytimeGiftReadyAt
					if not xz then
						xz = 0
					end
					xA = xz
					xz = xy.Stats
					if xz then
						xz = xy.Stats.SecondsPlayed
					end
					xy = xz
					if not xy then
						xy = 0
					end
					xz = xy
					return (xz >= xA)
				end
			end
		end
	end,
	[459] = function()
        if Recovered.DeepSeller then Recovered.DeepSeller:Step() end
    end,
	[470] = function()
		local Az = nil
		if not rQ("AutoBuyBestRod") then
			return
		else
			Az = (if (os.clock() - sm) < 2 then 1 else 0)
			if Az == 1 then
				return
			else
				sm = os.clock()
				sC()
			end
		end
	end,
	[484] = function(j6)
		if Library.Unloaded then
			return
		else
			Recovered[892](ErrorScriptsDeepClientCall, rF, j6)
		end
	end,
	[490] = function()
		local uY, uZ = nil, nil
		uY = sP.Character
		uZ = uY
		if uZ then
			uZ = uY:FindFirstChild("HumanoidRootPart")
		end
		return uZ
	end,
	[492] = function(fZ, f_)
		local yt = nil
		yt = (type(fZ) ~= "table")
		if not yt then
			yt = (type(f_) ~= "string")
		end
		if yt then
			return 0
		else
			yt = fZ[f_]
			if type(yt) == "number" then
				return yt
			else
				yt = fZ[string.gsub(f_, " Bait$", " Orb")]
				if type(yt) == "number" then
					return yt
				else
					return 0
				end
			end
		end
	end,
	[534] = function()
		rD()
		r4()
	end,
	[536] = function()
		local x7, x8, x9, ya, yc, yd, ye, yg = nil, nil, nil, nil, nil, nil, nil, nil
		x7 = sS()
		x8 = x7
		if x8 then
			x8 = x7.Inventory
		end
		if not x8 then
			return nil
		else
			x8 = -1
			x9 = nil
			yd = false
			for fu, fv in x7.Inventory do
				ye = fu
				yg = fv
				local yf = ye
				local yh = yg
				local yc = nil
				yc = 6
				if yh.Type == "Bait" then
					x7 = yh.Data
					if x7 then
						x7 = yh.Data.Amount
					end
					ya = x7
					if not ya then
						ya = 1
					end
					x7 = ya
					if x7 > 0 then
						x7 = tk:Get(yh.Name, true)
						ya = x7
						if ya then
							ya = x7.Price
						end
						x7 = ya
						if not x7 then
							x7 = 0
						end
						ya = x7
						if ya > x8 then
							x9 = yh.Name
						end
					end
				end
				if yd then
					break
				end
			end
			return x9
		end
	end,
	["Vector2_new"] = Vector2.new,
	["Instance_fromExisting"] = Instance.fromExisting,
	[544] = function(f3, f4)
		local yv, yw, yx = nil, nil, nil
		if type(f3) ~= "table" then
			return true
		else
			yv = f3[f4]
			yw = f3[string.gsub(f4, " Bait$", " Orb")]
			yx = (type(yv) ~= "number")
			if yx then
				yx = (type(yw) ~= "number")
			end
			if yx then
				return true
			else
				return (sO(f3, f4) > 0)
			end
		end
	end,
	[545] = function()
        local sold, reason, detail = sw(false)
        if sold then Library:Notify("Sold fish")
        elseif reason == "busy" then Library:Notify("A sale is already in progress.")
        elseif reason == "fishing" then Library:Notify("Wait for fishing to finish before selling.")
        elseif reason == "empty" then Library:Notify("No fish to sell")
        elseif reason == "cancelled" or reason == "unloaded" then return
        else Library:Notify("Could not sell fish: " .. tostring(detail or reason):match("^[^\n]*")) end
    end,
	[546] = function(bE)
		local vi, vj = nil, nil
		vi = (type(bE) ~= "table")
		if not vi then
			vi = not bE.special
		end
		if vi then
			return nil
		else
			vi = s6:Get(bE.name, true)
			vj = vi
			if vj then
				vj = vi.Type
			end
			vi = vj
			if not vi then
				vi = nil
			end
			return vi
		end
	end,
	[556] = function()
		return tr:Get()
	end,
	["game"] = game,
	[585] = function(gY)
		local zt, zu = nil, nil
		zt = sS()
		zu = zt
		if zu then
			zu = zt.Codes
		end
		zt = zu
		if type(zt) ~= "table" then
			return false
		else
			zu = sD.Normalize(gY)
			return (zt[zu] == true)
		end
	end,
	[590] = -1,
	[649] = function(b3)
		local vB, vC = nil, nil
		vB = th()
		if not vB then
			return true
		else
			vC = b3
			if not vC then
				vC = "None"
			end
			return (vB[vC] == true)
		end
	end,
	[670] = function()
		local Ah, Ai, Aj, An, Aq = nil, nil, nil, nil, nil
		An = (if (os.clock() - r2) < 2 then 1 else 0)
		if An == 1 then
			return false
		else
			Ah = tf()
			Aq = (if not Ah then 1 else 0)
			if Aq == 1 then
				return false
			else
				Ai = rW()
				if not Ai then
					return false
				else
					Aj = ((Ah.Position - Ai.Position).Magnitude < 10)
					if Aj then
						Aj = sg.CanThrow
					end
					if Aj then
						return true
					else
						r2 = os.clock()
						Ah.CFrame = Ai
						Ah.AssemblyLinearVelocity = Recovered.Vector3.zero
						return true
					end
				end
			end
		end
	end,
	[675] = function()
		local xG, xH, xI = nil, nil, nil
		if (os.clock() - rO) < 1.25 then
			return
		else
			xG = sS()
			if not xG then
				return
			else
				xH = false
				xI = (rQ("AutoClaimBigFish"))
				if xI then
					xI = rJ()
				end
				if xI then
					sF("NextDayReward")
					xH = true
				end
				if rQ("AutoClaimFreeRewards") then
					xI = (xG.IsInGroup == true)
					if xI then
						xI = (xG.IsGroupRewardClaimed ~= true)
					end
					if xI then
						sF("GroupReward")
						xH = true
					end
					if te() then
						sF("PlaytimeGift", "Claim")
						xH = true
					end
				end
				if xH then
					rO = os.clock()
				end
			end
		end
	end,
	[677] = function()
		local yP, yQ, yR, yS, yT, yU, yY, yZ, y_, y0, y2 = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		yP = sS()
		yY = (if not yP then 1 else 0)
		if yY == 1 then
			return false
		else
			yQ = {}
			yR = yP.Rods
			if not yR then
				yR = yQ
			end
			yQ = yR
			yR = yP.Cash
			if not yR then
				yR = 0
			end
			yP = nil
			yS = yR
			y_ = false
			for gv, gw in sE do
				y0 = gv
				y2 = gw
				local y1 = y0
				local y3 = y2
				local yZ = nil
				yZ = 7
				yR = not yQ[y3.Name]
				if yR then
					yT = y3.Price
					if not yT then
						yT = 0
					end
					yR = (yT <= yS)
				end
				if yR then
					yR = not yP
					if not yR then
						yT = y3.Price
						if not yT then
							yT = 0
						end
						yU = yP.Price
						if not yU then
							yU = 0
						end
						yR = (yT > yU)
					end
					if yR then
					end
				end
				if y_ then
					break
				end
			end
			if not yP then
				return false
			else
				yQ = Recovered[892](sF, "RodShop", "Buy", yP.Name)
				if yQ then
					local EP_cfg1 = Recovered.task.wait
					Recovered.task_wait(0.2)
					Recovered[892](sF, "RodShop", "Equip", yP.Name)
					EP_cfg1 = Recovered.task.wait
					Recovered.task_wait(0.1)
					s9()
				end
				return yQ
			end
		end
	end,
	[742] = function(dg, dh)
		local wn, wo, wp, wt = nil, nil, nil, nil
		wt = (if not sV(dg) then 1 else 0)
		if wt == 1 then
			return false
		else
			wn = dg.model.PrimaryPart
			wo, wp = rP(dg)
			return (math.abs((dh - wn.Position.Y)) <= (wp + rN))
		end
	end,
	[758] = function()
		local uV, uW = nil, nil
		uV = sP.Character
		uW = uV
		if uW then
			uW = uV:FindFirstChildOfClass("Humanoid")
		end
		return uW
	end,
	[759] = function(automatic)
        if Recovered.DeepSeller then return Recovered.DeepSeller:Request(automatic == true) end
        return false, "unloaded"
    end,
	[762] = function(bK)
		local vl, vm, vq = nil, nil, nil
		vl = Eq[2]()
		if not vl then
			return true
		else
			vm = sz(bK)
			vq = (if type(vm) ~= "string" then 1 else 0)
			if vq == 1 then
				return false
			else
				return (vl[vm] == true)
			end
		end
	end,
	[773] = function()
		local xZ, x_, x1, x2, x3, x5 = nil, nil, nil, nil, nil, nil
		xZ = sS()
		x_ = xZ
		if x_ then
			x_ = xZ.ActiveBaits
		end
		xZ = x_
		if type(xZ) ~= "table" then
			return false
		else
			x2 = false
			for fm, fn in xZ do
				x3 = fm
				x5 = fn
				local x4 = x3
				local x6 = x5
				local x1 = nil
				x1 = 0
				xZ = (tonumber(x6))
				if not xZ then
					xZ = 0
				end
				if xZ > 0 then
					return true
				end
				if x2 then
					break
				end
			end
			return false
		end
	end,
	[789] = function()
		local AC, AD, AE, AI, AL = nil, nil, nil, nil, nil
		AI = (if not rQ("AutoUseBait") then 1 else 0)
		if AI == 1 then
			return
		else
			if (os.clock() - r8) < 0.75 then
				return
			else
				if sN() then
					return
				else
					AC = Options.UseBaitName
					AL = (if AC then 1 else 0)
					if AL == 1 then
						AC = Options.UseBaitName.Value
					end
					AD = AC
					AC = (AD == "")
					AE = (type(AD) ~= "string")
					if not AE then
						AE = AC
					end
					if AE then
						return
					else
						if rK(AD) then
							r8 = os.clock()
						end
					end
				end
			end
		end
	end,
	["pcall"] = pcall,
	[826] = function()
		local zX, zY, zZ, z_, z0, z2, z3, z4, z6, z8, z9, Aa, Ac, Ag =
			nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		zX = 0
		zY = 0
		zZ = nil
		z_ = nil
		z3 = false
		for hK, hL in CollectionService:GetTagged("Throw") do
			z4 = hK
			z6 = hL
			local z5 = z4
			local z7 = z6
			local z2 = nil
			z2 = 1
			if z7:IsDescendantOf(Workspace) then
				z9 = false
				for hM, hN in z7:GetDescendants() do
					Aa = hM
					Ac = hN
					local Ab = Aa
					local Ad = Ac
					local z8 = nil
					z8 = 7
					if Ad:IsA("BasePart") then
						if Ad.Size.Y <= 1 then
							z0 = (Ad.Size.X * Ad.Size.Z)
							if z0 > zY then
							end
						else
							z0 = ((Ad.Size.X * Ad.Size.Y) * Ad.Size.Z)
							if z0 > zX then
							end
						end
					end
					if z9 then
						break
					end
				end
			end
			if z3 then
				break
			end
		end
		zX = zZ
		if not zX then
			zX = z_
		end
		zY = zX
		Ag = (if not zY then 1 else 0)
		if Ag == 1 then
			zX = Workspace:FindFirstChild("Map")
			zZ = zX
			if zZ then
				zZ = zX:FindFirstChild("ThrowGuide")
			end
			zX = zZ
			zZ = zX
			if zZ then
				zZ = zX:IsA("BasePart")
			end
			if zZ then
				local EX_cfg3 = Recovered.CFrame.new
				return (zX.CFrame * Recovered.CFrame_new(0, 5, -25))
			else
				return nil
			end
		else
			local EV_cfg4 = Recovered.Vector3.new
			zX = (zY.Position + Recovered.Vector3_new(0, (math.max((zY.Size.Y * 0.5), 1) + 3), 0))
			zY = Workspace:FindFirstChild("Map")
			zZ = zY
			if zZ then
				zZ = zY:FindFirstChild("ThrowGuide")
			end
			zY = zZ
			zZ = zY
			if zZ then
				local EZ_cfg1 = Recovered.Vector3.new
				zZ = (zY.CFrame.LookVector * Recovered.Vector3_new(1, 0, 1))
			end
			zY = zZ
			if not zY then
				local EY_cfg2 = Recovered.Vector3.new
				zY = Recovered.Vector3_new(0, 0, -1)
			end
			zZ = zY
			Ag = (if zZ.Magnitude < 0.001 then 1 else 0)
			if Ag == 1 then
				zZ = Recovered.Vector3.new(0, 0, -1)
			else
				zZ = zZ.Unit
			end
			return Recovered.CFrame.lookAt(zX, (zX + zZ))
		end
	end,
	[836] = function()
		return rK(sd())
	end,
	["game_PlaceId"] = game.PlaceId,
	[854] = function()
		local xr, xs, xt, xx = nil, nil, nil, nil
		xr = sS()
		xs = not xr
		if not xs then
			xs = (xr.IsNextDayRewardClaimed == true)
		end
		if xs then
			return false
		else
			xs = xr.NextDayRewardAt
			if not xs then
				xs = 0
			end
			xr = xs
			xs = sB.WaitSeconds
			if not xs then
				xs = 0
			end
			xt = xs
			xx = (if xr == 0 then 1 else 0)
			if xx == 1 then
				return false
			else
				return (math.max((xt - (sq() - xr)), 0) <= 0)
			end
		end
	end,
	[861] = function()
		local zl, zn, zo, zp, zr = nil, nil, nil, nil, nil
		zl = false
		zo = false
		for gU, gV in tA() do
			zp = gU
			zr = gV
			local zq = zp
			local zs = zr
			local zn = nil
			zn = 1
			if sW(zs) then
				local E2_cfg1 = Recovered.task.wait
				Recovered.task_wait(0.15)
			end
			if zo then
				break
			end
		end
		return zl
	end,
	[867] = function()
		if not rQ("AutoUseBestBait") then
			return
		else
			if (os.clock() - r8) < 0.75 then
				return
			else
				if sN() then
					return
				else
					if s3() then
						r8 = os.clock()
					end
				end
			end
		end
	end,
	[892] = pcall,
	[895] = function()
		local A3, A4, A5 = nil, nil, nil
		A3 = Options.AutoFavourite
		if A3 then
			A3 = Options.AutoFavourite.Value
		end
		A4 = A3
		A3 = (A4 ~= "")
		A5 = (type(A4) == "string")
		if A5 then
			A5 = A3
		end
		if A5 then
			Recovered[892](sF, "Lock", "AutoLock", A4)
		end
	end,
	[909] = function(bd, ...)
		return tv.Client(bd):Fire(true, ...)
	end,
	[943] = function(bQ)
		local vr, vs = nil, nil
		if type(bQ) ~= "table" then
			return nil
		else
			vr = (type(bQ.rarity) == "string")
			if vr then
				vr = (bQ.rarity ~= "")
			end
			if vr then
				return bQ.rarity
			else
				if type(bQ.name) == "string" then
					vr = td:Get(bQ.name, true)
					vs = vr
					if vs then
						vs = (type(vr.Rarity) == "string")
					end
					if vs then
						bQ.rarity = vr.Rarity
						return vr.Rarity
					else
						return nil
					end
				else
					return nil
				end
			end
		end
	end,
	["CFrame_new"] = CFrame.new,
	[958] = function(ea)
		local Eo = math.abs
		local w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, xa, xe, xh, xk, xn, xq =
			nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		if not rR() then
            Recovered.ReleaseCollectionAim()
			if not sc.Active then
				r0 = nil
				sf(false)
			end
			return
		else
			xe = (if not sc.Active then 1 else 0)
			if xe == 1 then
                Recovered.ReleaseCollectionAim()
				r0 = nil
				sf(false)
				return
			else
				sf(true)
				w0 = sc.Sub
				xh = (if w0 then 1 else 0)
				if xh == 1 then
					w0 = sc.Sub.CatchMinigame
				end
				w1 = w0
				w0 = w1
				if w0 then
					w0 = w1.IsActive
				end
				if w0 then
					w0 = w1:IsActive()
				end
				xe = (if w0 then 1 else 0)
				if xe == 1 then
					return
				else
					w0 = not sc.Catchable
					if not w0 then
						w0 = sc.CatchWindowOver
					end
					xk = (if w0 then 1 else 0)
					if not (xk == 1) then
						w0 = sc.ReelRequested
					end
					if w0 then
						return
					else
						Recovered.OwnCollectionAim()
						w0 = sc.Sub
						if w0 then
							w0 = sc.Sub.FishSchool
						end
						w1 = w0
						if not w1 then
							w1 = rZ
						end
						w0 = w1
						w1 = w0
						if w1 then
							w1 = w0.Fish
						end
						w2 = w1
						w1 = sc.HangPoint
						w3 = sc.ActiveLanding
						w4 = w2
						if w4 then
							w4 = w1
						end
						w5 = w4
						if w5 then
							w5 = w3
						end
						xe = (if not w5 then 1 else 0)
						if xe == 1 then
							return
						else
							-- Updated StartAim handles hook/bag limits and finds past capacity.
                            -- Keep the old empty-capacity shortcut only on legacy controllers.
                            if type(sc.GetHookCapacity) ~= "function" and sc:GetBaitCapacity() <= 0 then
								sc:RequestReel()
								return
							else
								w4 = sH(w2)
								xq = (if w4 <= 0 then 1 else 0)
								if xq == 1 then
									w4 = (rQ("AutoStopWhenEmpty"))
									if w4 then
										w4 = (#w2 > 0)
									end
									xn = (if w4 then 1 else 0)
									if xn == 1 then
										sc.LastFishAboveAt = 0
										sc:RequestReel()
									end
									return
								else
									if rQ("FastFishing") and Recovered.CollectFastCatch(w0, w2) then
										return
									end
									r0 = Eq[8](w2, w1.Y)
									w2 = r0
									if not w2 then
										return
									else
										w4 = w2.model.PrimaryPart
										if not w4 then
											return
										else
											w5 = Workspace:FindFirstChild("Map")
											w6 = w5
											if w6 then
												w6 = w5:FindFirstChild("ThrowGuide")
											end
											w5 = w6
											w6 = w5
											if w6 then
												w6 = w5.CFrame.LookVector
											end
											w5 = w6
											if not w5 then
												local E8_cfg1 = Recovered.Vector3.new
												w5 = Recovered.Vector3_new(0, 0, -1)
											end
											w6 = w5
											w5 = s0(w2, ea)
											w7 = Eq[4](w5, w3, w6)
											w8 = sc.AimOffset
											if not w8 then
												w8 = 0
											end
											w9 = w8
											w8 = (w7 - w9)
											w7 = r1(w2, w1.Y)
											w2 = w7
											if not w2 then
												w2 = (Eo(w8) <= 4)
											end
											xa = w2
											if xa then
												xa = 1
											end
											w2 = xa
											if not w2 then
												w2 = if rQ("FastFishing") then 1 else math.clamp((ea * 34), 0, 1)
											end
											xa = w2
											sc.AimOffset = (w9 + (w8 * xa))
											w2 = (Eo((w1.Y - w5.Y)) <= (rN + 2))
											w1 = w7
											if not w1 then
												w1 = w2
											end
											if w1 then
												local E7_cfg2 = Recovered.Vector3.new
												w1 = (Recovered.Vector3_new(w3.X, w5.Y, w3.Z) + (w6 * sc.AimOffset))
												sc.HangPoint = w1
												sc.BaitTarget = w1
												sc.LastFishAboveAt = os.clock()
												w2 = sc.ActiveBait
												w3 = w2
												if w3 then
													w3 = w2.Parent
												end
												if w3 then
													w2.CFrame = Recovered.CFrame.new(w1)
													sc.LastBaitWrite = w1
												end
												ta(w0, w1)
												ta(w0, w5)
												ta(w0, w4.Position)
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
	end,
	[962] = function(aU, aV, aW)
		return string.format("<b>%s</b> %s %s", aU, sx("-", "#5a6070"), sx(aV, aW))
	end,
	[976] = function(ji)
		-- Navigation and branding are drawn by the ErrorScripts interface.
	end,
	["Color3"] = Color3,
	[998] = function()
		if rL() then
			Library:Notify("Bought best affordable bait")
		else
			Library:Notify("No affordable bait")
		end
	end,
	["task_wait"] = task.wait,
	[1037] = function(aZ)
		local uS, uT = nil, nil
		uS = Toggles[aZ]
		uT = (uS ~= nil)
		if uT then
			uT = (uS.Value == true)
		end
		return uT
	end,
	[1039] = function(hk)
		local zO, zP, zT = nil, nil, nil
		zO = sg:HUD()
		zP = zO
		if zP then
			zP = zO.GetHookSteps
		end
		zT = (if zP then 1 else 0)
		if zT == 1 then
			zP = zO:GetHookSteps()
		end
		zO = zP
		if not zO then
			zO = 21
		end
		zP = zO
		if zP < 2 then
			return false
		else
			zO = (1 + (hk * (zP - 1)))
			zP = (zO >= 9)
			if zP then
				zP = (zO < 12)
			end
			return zP
		end
	end,
	[1043] = function(b_)
		local vw, vA = nil, nil
		vw = to()
		if not vw then
			return true
		else
			vA = (if type(b_) ~= "string" then 1 else 0)
			if vA == 1 then
				return false
			else
				return (vw[b_] == true)
			end
		end
	end,
	[1050] = function()
        if Recovered.DeepCaster then Recovered.DeepCaster:Step() end
    end,
	[1053] = function(dv, dw)
		local wu, wv, ww = nil, nil, nil
		wu = dv.model.PrimaryPart
		wv = wu.Position
		wu = dv.dir
		ww = (typeof(wu) ~= "Vector3")
		if not ww then
			ww = (wu.Magnitude < 0.001)
		end
		if ww then
			return wv
		else
			ww = (math.clamp(dw, 0, 0.05) * 28)
			return (wv + (wu.Unit * ww))
		end
	end,
	[1067] = function()
		local yi, yj, yk, yl, yp = nil, nil, nil, nil, nil
		yi = sS()
		yj = yi
		if yj then
			yj = yi.RodEquipped
		end
		yi = yj
		if not yi then
			yi = "Wooden Rod"
		end
		yj = yi
		yi = sP.Character
		yk = yi
		if yk then
			yk = yi:FindFirstChildOfClass("Humanoid")
		end
		yl = yk
		if not yl then
			return false
		else
			yk = yi:FindFirstChildOfClass("Tool")
			yi = yk
			if yi then
				yi = (yk.Name == yj)
			end
			if yi then
				return true
			else
				yi = sP:FindFirstChild("Backpack")
				yk = yi
				if yk then
					yk = yi:FindFirstChild(yj)
				end
				yi = yk
				yj = yi
				yp = (if yj then 1 else 0)
				if yp == 1 then
					yj = yi:IsA("Tool")
				end
				if yj then
					yl:EquipTool(yi)
					return true
				else
					if r6 and type(r6.EquipRod) == "function" then
                        return r6:EquipRod()
                    end
                    return false
				end
			end
		end
	end,
	[1081] = function(co)
		local vI = nil
		vI = not co
		if not vI then
			vI = co.caught
		end
		if not vI then
			vI = co.escaped
		end
		if not vI then
			vI = co.fighting
		end
		if vI then
			return false
		else
			vI = not co.model
			if not vI then
				vI = not co.model.Parent
			end
			if not vI then
				vI = not co.model.PrimaryPart
			end
			if vI then
				return false
			else
				if Recovered.EggsEnabled() and Recovered.MatchesEgg(co) then
                    return true
                end
                if co.special then
                    return tF(co)
				else
					if not rQ("AutoCollectFish") then
						return false
					else
						return sb(co)
					end
				end
			end
		end
	end,
	[1082] = function()
		local Be = nil
		if sN() then
			Library:Notify("Bait uses still remaining")
			return
		else
			Be = sd()
			if rK(Be) then
				Library:Notify(("Used " .. tostring(Be)))
			else
				Library:Notify("No bait in inventory")
			end
		end
	end,
	[1090] = function()
		local zI, zJ, zN = nil, nil, nil
		zI = sg:HUD()
		zJ = zI
		if zJ then
			zJ = zI.GetHookSteps
		end
		if zJ then
			zJ = zI:GetHookSteps()
		end
		zI = zJ
		zN = (if zI then 1 else 0)
		if not (zN == 1) then
			zI = 21
		end
		zJ = zI
		if zJ < 2 then
			return 0.5
		else
			return math.clamp(((10.5 - 1) / (zJ - 1)), 0, 1)
		end
	end,
	[1102] = function()
		return r9("CollectRarities")
	end,
	[1115] = function(fR)
		local yq, yr = nil, nil
		yq = (fR == "")
		yr = (type(fR) ~= "string")
		if not yr then
			yr = yq
		end
		if yr then
			return false
		else
			yq = sc.Active
			if not yq then
				yq = sg.Charging
			end
			if yq then
				return false
			else
				yq = tt(fR)
				if not yq then
					return false
				else
					yr = Recovered[892](sF, "ConsumeBait", yq)
					if yr then
						s9()
					end
					return yr
				end
			end
		end
	end,
	[1116] = function(aH)
		if aH then
			ts[(#ts + 1)] = aH
		end
		return aH
	end,
	[1120] = function()
		sA:Unload()
	end,
	[1121] = function()
		local vg = nil
		vg = (to() ~= nil)
		if not vg then
			vg = (th() ~= nil)
		end
		return vg
	end,
	[1125] = function(ak, al)
		local uE, uF, uJ = nil, nil, nil
		uE = ak.Price
		if not uE then
			uE = 0
		end
		uF = al.Price
		if not uF then
			uF = 0
		end
		uJ = (if uE ~= uF then 1 else 0)
		if uJ == 1 then
			uE = ak.Price
			if not uE then
				uE = 0
			end
			uF = al.Price
			if not uF then
				uF = 0
			end
			return (uE < uF)
		else
			return (ak.Name < al.Name)
		end
	end,
	[1135] = function()
		return rQ("AutoCollectFish") or rQ("AutoCollectFinds") or Recovered.FragmentsEnabled() or Recovered.EggsEnabled()
	end,
	[1149] = function(fa)
		local xK, xL, xP, xQ, xR, xS, xU, xY = nil, nil, nil, nil, nil, nil, nil, nil
		xK = sS()
		xL = xK
		xP = (if xL then 1 else 0)
		if xP == 1 then
			xL = xK.Inventory
		end
		if not xL then
			return nil
		else
			xR = false
			for fe, ff in xK.Inventory do
				xS = fe
				xU = ff
				local xT = xS
				local xV = xU
				local xQ = nil
				xQ = 7
				xK = (xV.Type == "Bait")
				xY = (if xK then 1 else 0)
				if xY == 1 then
					xK = (xV.Name == fa)
				end
				if xK then
					return xT
				end
				if xR then
					break
				end
			end
			return nil
		end
	end,
	[1155] = function()
		return r9("CollectMutations")
	end,
	[1161] = function(c8, c9)
		local wg, wh, wi, wm = nil, nil, nil, nil
		if not sV(c8) then
			return false
		else
			wg = c8.model.PrimaryPart
			wh, wi = rP(c8)
			wh = wg.Position.Y
			if c9 <= ((wh + wi) + 1) then
				return true
			else
				wg = (wh < c9)
				wm = (if wg then 1 else 0)
				if wm == 1 then
					wg = ((c9 - wh) <= rT)
				end
				return wg
			end
		end
	end,
	[1175] = function()
		local Av = nil
		Av = (if not rQ("AutoBuyBait") then 1 else 0)
		if Av == 1 then
			return
		else
			if (os.clock() - sr) < 1 then
				return
			else
				sr = os.clock()
				rL()
			end
		end
	end,
	["CFrame"] = CFrame,
	[1228] = function()
        if Recovered.DeepCaster then return Recovered.DeepCaster:AwaitPerfect() end
    end,
	[1246] = function(school, point)
        if Library.Unloaded or not sl() then return ErrorScriptsDeepClientCall(tG, school, point) end
        if type(school.Fish) ~= "table" then return end
        local selected = {}
        for _, catch in ipairs(school.Fish) do
            if sV(catch) then selected[#selected + 1] = catch end
        end
        if #selected == 0 then return end
        -- Let the game's own TryGrab enforce pull phase, hook slots, bag room,
        -- boss timing and CatchMinigame. Forward writes from native methods to
        -- the real school, while leaving its complete Fish list untouched.
        local view = setmetatable({ Fish = selected }, {
            __index = school,
            __newindex = school,
        })
        return ErrorScriptsDeepClientCall(tG, view, point)
    end,
	[1257] = function()
		local collectFish = rQ("AutoCollectFish")
		local collectFinds = rQ("AutoCollectFinds") or Recovered.FragmentsEnabled() or Recovered.EggsEnabled()
        return collectFinds or (collectFish and s1()) or false
	end,
	[1263] = function()
		local Bg, Bh = nil, nil
		if sN() then
			Library:Notify("Bait uses still remaining")
			return
		else
			Bg = Options.UseBaitName
			if Bg then
				Bg = Options.UseBaitName.Value
			end
			Bh = Bg
			if rK(Bh) then
				Library:Notify(("Used " .. tostring(Bh)))
			else
				Library:Notify("Bait not found")
			end
		end
	end,
	[1266] = function(gH)
		local zd, ze, zf, zg, zk = nil, nil, nil, nil, nil
		zd = sS()
		zk = (if not zd then 1 else 0)
		if zk == 1 then
			return false
		else
			ze = sL[gH]
			if not ze then
				return false
			else
				zf = zd.Upgrades
				if zf then
					zf = zd.Upgrades[gH]
				end
				zg = zf
				if not zg then
					zg = 0
				end
				zf = zg
				zg = ze.MaxLevel
				if not zg then
					zg = 0
				end
				if zf >= zg then
					return false
				else
					ze = sL.GetPrice(gH, zf)
					zf = zd.Cash
					if not zf then
						zf = 0
					end
					zd = ze
					if not zd then
						zd = math.huge
					end
					if zf < zd then
						return false
					else
						return Recovered[892](sF, "Upgrades", "Buy", gH)
					end
				end
			end
		end
	end,
	[1271] = function()
		local y4, y5, y7, y8, y9, zb = nil, nil, nil, nil, nil, nil
		y4 = Options.BuyUpgrades
		if y4 then
			y4 = Options.BuyUpgrades.Value
		end
		y5 = y4
		if type(y5) ~= "table" then
			return sh
		else
			y4 = {}
			y8 = false
			for gE, gF in sh do
				y9 = gE
				zb = gF
				local za = y9
				local zc = zb
				local y7 = nil
				y7 = 0
				if y5[zc] then
					y4[(#y4 + 1)] = zc
				end
				if y8 then
					break
				end
			end
			return sh
		end
	end,
	[1282] = function()
		local Bn, Bo, Bp, Bq, Br, Bs, Bt, Bu, Bv, Bw, Bx, By, Bz, BA, BB, BC, BD, BE, BF, BG, BH, BI, BJ, BK, BL, BM, BN, BP, BQ, BR, BT =
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil
		Bn = (hookfunction ~= nil)
		Bo = (hookmetamethod ~= nil)
		Bp = (getrawmetatable ~= nil)
		Bq = (setrawmetatable ~= nil)
		Br = (getgc ~= nil)
		Bs = (getgenv ~= nil)
		Bt = (getreg ~= nil)
		Bu = (getconnections ~= nil)
		Bv = (firesignal ~= nil)
		Bw = (getcallbackvalue ~= nil)
		Bx = (setclipboard ~= nil)
		By = (getcustomasset ~= nil)
		Bz = (getnamecallmethod ~= nil)
		BA = (isexecutorclosure ~= nil)
		BB = (fireproximityprompt ~= nil)
		BC = (firetouchinterest ~= nil)
		BD = (WebSocket ~= nil)
		BE = (readfile ~= nil)
		BF = (writefile ~= nil)
		BG = request
		if not BG then
			BG = http_request
		end
		BH = (BG ~= nil)
		BI = Recovered.debug
		if BI then
			BI = Recovered.debug.getupvalues
		end
		BJ = (BI ~= nil)
		BK = Recovered.debug
		if BK then
			BK = Recovered.debug.setupvalue
		end
		BL = (BK ~= nil)
		BM = 0
		BN = { Bn, Bo, Bp, Bq, Br, Bs, Bt, Bu, Bv, Bw, Bx, By, Bz, BA, BB, BC, BD, BE, BF, BH, BJ, BL }
		BQ = false
		for kf, kg in BN do
			BR = kf
			BT = kg
			local BS = BR
			local BU = BT
			local BP = nil
			BP = 1
			if BU then
				BM += 1
			end
			if BQ then
				break
			end
		end
		Bn = (BM / #BN)
		if Bn >= 0.9 then
			return sx("Full Support", rM)
		else
			if Bn >= 0.6 then
				return sx("Half Support", rE)
			else
				return sx("Low Support", tz)
			end
		end
	end,
	["task"] = task,
	[1300] = function()
		Library:Notify("ErrorScripts · custom interface")
	end,
	[1302] = function(dq, dr, ds)
		local Fz = Recovered.Vector3.new
		return math.clamp((((dq - dr) * Recovered.Vector3_new(1, 0, 1))):Dot(ds), -50, 50)
	end,
}
rD = nil
rE = nil
rF = nil
Eq[5] = nil
rI = nil
rJ = nil
rK = nil
rL = nil
rM = nil
rN = nil
rO = nil
rP = nil
rQ = nil
rR = nil
rT = nil
rV = nil
rW = nil
rX = nil
rZ = nil
r_ = nil
r0 = nil
r1 = nil
r2 = nil
r3 = nil
r4 = nil
r5 = nil
r6 = nil
r7 = nil
r8 = nil
r9 = nil
sb = nil
sc = nil
sd = nil
se = nil
sf = nil
sg = nil
sh = nil
si = nil
sk = nil
sl = nil
sm = nil
Eq[8] = nil
so = nil
local Players, rH, rS, rY, sa, sj = nil, nil, nil, nil, nil, nil
sp = nil
sq = nil
sr = nil
ss = nil
st = nil
sv = nil
sw = nil
sx = nil
sy = nil
sz = nil
sA = nil
sB = nil
sC = nil
sD = nil
sE = nil
sF = nil
Eq[2] = nil
sH = nil
sI = nil
sJ = nil
sK = nil
sL = nil
sM = nil
sN = nil
sO = nil
sP = nil
sQ = nil
sR = nil
sS = nil
CollectionService = nil
sV = nil
sW = nil
sX = nil
sY = nil
Workspace = nil
s0 = nil
s1 = nil
s2 = nil
s3 = nil
s5 = nil
s6 = nil
s7 = nil
s8 = nil
s9 = nil
ta = nil
local su, sT, sZ, CoreGui, TeleportService = nil, nil, nil, nil, nil
tc = nil
td = nil
te = nil
tf = nil
th = nil
tk = nil
tl = nil
Eq[4] = nil
to = nil
tp = nil
tr = nil
ts = nil
tt = nil
tv = nil
Options = nil
RunService = nil
tz = nil
tA = nil
tB = nil
Toggles = nil
tD = nil
tF = nil
tG = nil
local tg, GuiService, HttpService, tm, VirtualUser, UserInputService, tx, tE, tH, tI
tg = nil
GuiService = nil
HttpService = nil
tm = nil
VirtualUser = nil
UserInputService = nil
tx = nil
tE = nil
tH = nil
tI = nil
Eq[34] = nil
Eq[26] = nil
Eq[16] = nil
Eq[6] = nil
Eq[55] = nil
Eq[46] = nil
Eq[37] = nil
Eq[28] = nil
Eq[19] = nil
Eq[10] = nil
Eq[58] = nil
Eq[49] = nil
Eq[40] = nil
Eq[30] = nil
Eq[22] = nil
Eq[13] = nil
Eq[61] = nil
local t8, ue
Eq[52] = nil
Eq[43] = nil
Eq[33] = nil
Eq[25] = nil
Eq[15] = nil
Eq[54] = nil
Eq[45] = nil
Eq[36] = nil
t8 = nil
Eq[18] = nil
Eq[9] = nil
Eq[48] = nil
ue = nil
Eq[21] = nil
Eq[12] = nil
Eq[51] = nil
Eq[32] = nil
Eq[14] = nil
Eq[53] = nil
Eq[35] = nil
Eq[17] = nil
Eq[56] = nil
Eq[38] = nil
Eq[20] = nil
Eq[59] = nil
Eq[41] = nil
Eq[3] = nil
Eq[3] = 139
-- Register cleanup before module waits, fishing hooks, or event subscriptions.
local ErrorScriptsCleanupDone = false
Library:OnUnload(function()
    if ErrorScriptsCleanupDone then return end
    ErrorScriptsCleanupDone = true
    if Recovered and Recovered.DeepSeller then Recovered.DeepSeller:Stop() end
    if Recovered and Recovered.DeepCaster then Recovered.DeepCaster:Stop() end
    if Recovered then Recovered.ReleaseCollectionAim() end
    if type(sZ) == "function" then pcall(sZ, false) end
    if type(sT) == "function" then pcall(sT) end
    if su then pcall(function() su:Disconnect() end) end
    if type(ts) == "table" then
        for _, connection in pairs(ts) do pcall(function() connection:Disconnect() end) end
        table.clear(ts)
    end
    if rZ and Recovered and rZ.TryGrab == Recovered[1246] and rZ._errorScriptsOriginalTryGrab then
        rZ.TryGrab = rZ._errorScriptsOriginalTryGrab
    end
    if r6 then r6.DrivingThrow = false end
    if type(tx) == "function" then
        local ok, humanoid = pcall(tx)
        if ok and humanoid then humanoid.PlatformStand = false; humanoid.WalkSpeed = 16 end
    end
    if getgenv and getgenv().__ErrorScriptsDeepFishingLib == Library then
        getgenv().__ErrorScriptsDeepFishingLib = nil
    end
end)
if Library.Unloaded then return Library end
Players, Eq[26], RunService, UserInputService, VirtualUser, HttpService, GuiService, TeleportService, CoreGui, Workspace, CollectionService, sP, sJ, Eq[34] =
	nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
Players = Recovered.game:GetService("Players")
Eq[26] = Recovered.game:GetService("ReplicatedStorage")
RunService = Recovered.game:GetService("RunService")
UserInputService = Recovered.game:GetService("UserInputService")
VirtualUser = Recovered.game:GetService("VirtualUser")
HttpService = Recovered.game:GetService("HttpService")
GuiService = Recovered.game:GetService("GuiService")
TeleportService = Recovered.game:GetService("TeleportService")
CoreGui = Recovered.game:GetService("CoreGui")
Workspace = Recovered.game:GetService("Workspace")
CollectionService = Recovered.game:GetService("CollectionService")
sP = Players.LocalPlayer
sJ = sP:WaitForChild("PlayerGui")
if Library.Unloaded then return Library end
if getgenv then
	sA, Eq[16], Eq[34] = nil, nil, nil
	Eq[6] = (vector.create(9, 11, 11))
	Eq[55] = (vector.create(6, 11, 8))
	sA = getgenv().__ErrorScriptsDeepFishingLib
	Eq[6] = (vector.create(2, 1, 16))
	Eq[55] = (vector.create(8, 9, 12))
	Eq[46] = (vector.create(3, 6, 2))
	Eq[16] = sA
	if Eq[16] then
		Eq[16] = sA.Unload
	end
	if Eq[16] then
		Recovered[892](Recovered[1120])
	end
end
-- Native game modules use ErrorScriptsDeepClientCall; never elevate the whole adapter.
sa, r5, rY, rS, rM, rH, rE, tE, tz, tv, tr, tk, Eq[37], td, s6, Eq[6], Eq[55], Eq[46], sL, sD, sB, sv, sq, Eq[34], sg, sc, r6, rZ, Eq[28], Eq[16] =
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil
sa = "Deep Fishing"
r5 = ""
rY = ""
rS = ""
rM = "#7fd47f"
rH = "#6ec1ff"
rE = "#e8a34d"
local Gu_cfg1 = bit32.rrotate(bit32.bxor(32768, string.byte(tostring(rZ))), 26)
tE = "#8b93a3"
tz = "#e05a5a"
tv = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Events)
tr = ErrorScriptsDeepClientCall(require, Eq[26].Shared.PlayerData)
tk = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Content.Item.Bait)
Eq[37] = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Content.Item.Rod)
local Gf_cfg2 = bit32.rrotate(bit32.bxor(3087007744, string.byte(tostring(rM))), 28)
td = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Content.Item.Fish)
s6 = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Content.FishingObjects)
Eq[6] = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Config.AutoDeleteConfig)
local Gt_cfg3 = bit32.rrotate(bit32.bxor(4416, string.byte(tostring(nil))), 28)
Eq[55] = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Modules.AutoDelete)
local Gi_cfg4 = bit32.rrotate(bit32.bxor(5632, string.byte(tostring(sB))), 21)
Eq[46] = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Modules.Lock)
sL = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Config.UpgradesConfig)
sD = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Config.CodesConfig)
sB = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Config.NextDayRewardConfig)
sv = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Config.PlaytimeGiftConfig)
sq = ErrorScriptsDeepClientCall(require, Eq[26].Shared.Utils.Common.TimeNow)
Eq[34] = sP.PlayerScripts:WaitForChild("Client"):WaitForChild("Controllers")
if Library.Unloaded then return Library end
sg = ErrorScriptsDeepClientCall(require, Eq[34]:WaitForChild("Fishing"))
sc = ErrorScriptsDeepClientCall(require, Eq[34]:WaitForChild("ThrowCinematic"))
r6 = sg.AutoFishing
rZ = ErrorScriptsDeepClientCall(require, Eq[34]:WaitForChild("ThrowCinematic"):WaitForChild("FishSchool"))
if Library.Unloaded then return Library end
Eq[28] = {}
Eq[18] = false
for Z, aa in Eq[6].Rarities do
	Eq[9] = Z
	Eq[48] = aa
	Eq[57] = Eq[9]
	Eq[39] = Eq[48]
	local t8 = nil
	t8 = 1
	Eq[28][(#Eq[28] + 1)] = Eq[39]
	if Eq[18] then
		break
	end
end
Eq[34] = { "None" }
Eq[21] = false
for ac, ad in Eq[55].MutationKeys() do
	Eq[12] = ac
	Eq[51] = ad
	Eq[60] = Eq[12]
	Eq[42] = Eq[51]
	local ue = nil
	ue = 2
	Eq[34][(#Eq[34] + 1)] = Eq[42]
	if Eq[21] then
		break
	end
end
Eq[55], Eq[6], tl, Eq[16], Eq[26] = nil, nil, nil, nil, nil
Eq[55] = {}
for _, itemType in ipairs(s6.ItemTypes or { "Scroll", "Chest", "Cage", "Junk", "Key" }) do
    if type(itemType) == "string" and not table.find(Eq[55], itemType) then
        Eq[55][#Eq[55] + 1] = itemType
    end
end
Eq[6] = Eq[46].Options()
tl = {}
Eq[16] = {}
Eq[21] = false
for ai, aj in tk:GetCollection() do
	Eq[32] = ai
	Eq[14] = aj
	Eq[24] = Eq[32]
	Eq[1] = Eq[14]
	local ue = nil
	ue = 0
	tl[(#tl + 1)] = Eq[1]
	if Eq[21] then
		break
	end
end
local Gr_cfg6 = bit32.rrotate(bit32.bxor(134217728, string.byte(tostring(2))), 13)
table.sort(tl, Recovered[1125])
Eq[21] = false
for am, an in tl do
	Eq[53] = am
	Eq[35] = an
	Eq[44] = Eq[53]
	Eq[27] = Eq[35]
	local ue = nil
	ue = 2
	Eq[16][(#Eq[16] + 1)] = Eq[27].Name
	if Eq[21] then
		break
	end
end
sE = {}
Eq[21] = false
for ap, aq in Eq[37]:GetCollection() do
	Eq[17] = ap
	Eq[56] = aq
	Eq[7] = Eq[17]
	Eq[47] = Eq[56]
	local ue = nil
	ue = 2
	sE[(#sE + 1)] = Eq[47]
	if Eq[21] then
		break
	end
end
table.sort(sE, Recovered[122])
sh = {}
Eq[21] = false
for av, aw in sL.Order do
	Eq[38] = av
	Eq[20] = aw
	Eq[29] = Eq[38]
	Eq[11] = Eq[20]
	local ue = nil
	ue = 1
	sh[(#sh + 1)] = Eq[11]
	if Eq[21] then
		break
	end
end
Eq[26], Eq[37], tI, Toggles, Options, Eq[46] = nil, nil, nil, nil, nil, nil
Eq[37], tI = ErrorScriptsThemeManager, ErrorScriptsSaveManager
Toggles = Library.Toggles
Options = Library.Options
if getgenv then
	getgenv().__ErrorScriptsDeepFishingLib = Library
end
ts, rT, rN, rI, Eq[46], tm, s7, sM, sx, sj, rQ, tx, tf, sS, sF, ss, r9, to, th, s1, Eq[2], sz, r3, tD, tc, sQ, st, sb, tF, sV, sl, Eq[26] =
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil
ts = {}
tm = Recovered[1116]
s7 = Recovered[312]
sM = Recovered[1300]
sx = Recovered[195]
sj = Recovered[962]
rQ = Recovered[1037]
tx = Recovered[758]
tf = Recovered[490]
Eq[10] = (vector.create(2, 11, 6))
Eq[58] = (vector.create(11, 6, 7))
local Ha_cfg10 = vector.cross(Eq[10], Eq[58])
sS = Recovered[556]
sF = Recovered[909]
ss = Recovered[76]
r9 = Recovered[126]
to = Recovered[1102]
th = Recovered[1155]
s1 = Recovered[1121]
Eq[2] = Recovered[16]
sz = Recovered[546]
r3 = Recovered[762]
tD = Recovered[943]
tc = Recovered[150]
local Gl_cfg12 = bit32.rrotate(bit32.bxor(933888, string.byte(tostring(ts))), 12)
sQ = Recovered[1043]
st = Recovered[649]
sb = Recovered[114]
tF = Recovered[103]
sV = Recovered[1081]
sl = Recovered[1257]
rT = 18
rN = 6
rI = 1.25
Eq[10] = (vector.create(3, 5, 12))
Eq[58] = (vector.create(4, 12, 10))
Eq[49] = (vector.create(9, 1, 7))
Eq[40] = (vector.create(3, 7, 7))
Eq[46] = rZ._errorScriptsOriginalTryGrab
if not Eq[46] then
	Eq[46] = rZ.TryGrab
end
tG, r0, rV, rO, sy, sr, sm, sk, se, r8, r2, sR, Eq[26], tH, rP, sY, r1, Eq[4], s0, Eq[8], ta, sH, sf, rR, rF, rJ, te, si, tt, sN, sd, s9, rK, s3, sO, so, rL, sC, tA, sW, r_, tB, sX, sw, r7, Eq[5], s8, rW, rX, tp, s2, sI, sp, r4, rD, s5, sK, Eq[10], Eq[19] =
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil
tG = Eq[46]
rZ._errorScriptsOriginalTryGrab = tG
rZ.TryGrab = Recovered[1246]
r0 = nil
Eq[49] = (vector.create(6, 4, 16))
Eq[40] = (vector.create(10, 6, 3))
Eq[30] = (vector.create(2, 2, 9))
if (math.abs((vector.angle(Eq[49], Eq[40], Eq[30]))) - math.abs((vector.angle(Eq[40], Eq[49], Eq[30])))) == 2 then
	r1 = false
	rV = Recovered[209]
	rP = Recovered[1161]
	sY = Recovered[742]
else
	rV = false
	rP = Recovered[209]
	sY = Recovered[1161]
	r1 = Recovered[742]
end
Eq[4] = Recovered[1302]
s0 = Recovered[1053]
Eq[8] = Recovered[323]
ta = function(dT, dU)
	local wL = nil
	wL = dT
	if wL then
		wL = dU
	end
	if not wL then
		return
	else
		Recovered[892](function()
			dT:TryGrab(dU)
		end)
	end
end
sH = Recovered[236]
sf = Recovered[216]
rR = Recovered[1135]
rF = Recovered[958]
rO = 0
rJ = Recovered[854]
te = Recovered[414]
si = Recovered[675]
tt = Recovered[1149]
sN = Recovered[773]
sd = Recovered[536]
local Hd_cfg14 = bit32.rrotate(bit32.bxor(2816, string.byte(tostring(rX))), 29)
s9 = Recovered[1067]
Eq[49] = (vector.create(9, 2, 8))
Eq[40] = (vector.create(6, 2, 2))
local Gm_cfg15 = vector.cross(Eq[49], Eq[40])
rK = Recovered[1115]
s3 = Recovered[836]
sO = Recovered[492]
so = Recovered[544]
rL = Recovered[316]
sC = Recovered[677]
local Gg_cfg17 = bit32.rrotate(bit32.bxor(20709376, string.byte(tostring(tt))), 13)
tA = Recovered[1271]
sW = Recovered[1266]
r_ = Recovered[861]
tB = Recovered[585]
sX = Recovered[138]
sw = Recovered[759]
r7 = Recovered[1090]
Eq[5] = Recovered[1039]
Eq[49] = (vector.create(8, 9, 9))
Eq[40] = (vector.create(4, 8, 9))
Eq[30] = (vector.create(2, 5, 4))
if (math.abs((vector.angle(Eq[49], Eq[40], Eq[30]))) - math.abs((vector.angle(Eq[40], Eq[49], Eq[30])))) == 0 then
	s8 = Recovered[1228]
	sy = 0
	sr = 0
	sm = 0
else
	sm = Recovered[1228]
	s8 = 0
	sy = 0
	sr = 0
end
sk = 0
se = 0
Eq[49] = (vector.create(7, 11, 1))
Eq[40] = (vector.create(5, 13, 10))
Eq[30] = (vector.create(9, 2, 15))
Eq[22] = (vector.create(3, 3, 5))
r8 = 0
r2 = 0
rW = Recovered[826]
rX = Recovered[670]
tp = Recovered[459]
s2 = Recovered[1175]
sI = Recovered[470]
sp = Recovered[120]
local Go_cfg18 = bit32.rrotate(bit32.bxor(4325376, string.byte(tostring(tA))), 18)
r4 = Recovered[867]
rD = Recovered[789]
s5 = Recovered[534]
sR = false
sK = Recovered[1050]
Recovered.DeepSeller = ErrorScriptsCreateDeepSeller({
    RunClient = function(callback) return ErrorScriptsDeepClientCall(callback) end,
    GetFishing = function() return sg end,
    GetCinematic = function() return sc end,
    IsEnabled = function() return rQ("AutoSell") end,
    GetThreshold = function()
        local option = Options.AutoSellFishCount
        return option and option.Value or 2000
    end,
    GetFishCount = function()
        local backpack = sg.Services and sg.Services.Backpack
        if backpack and type(backpack.GetCap) == "function" then
            local cap = backpack:GetCap()
            if type(cap) ~= "table" or type(cap.Count) ~= "number" then
                error("The backpack fish count is unavailable.")
            end
            return cap.Count
        end
        local data = sS()
        if not data or type(data.Inventory) ~= "table" then
            error("The backpack inventory is unavailable.")
        end
        local count = 0
        for _, item in pairs(data.Inventory) do
            if type(item) == "table" and item.Type == "Fish" then
                local counts
                if backpack and type(backpack.CountsTowardCap) == "function" then
                    counts = backpack:CountsTowardCap(item)
                else
                    local fish = sg.Content and sg.Content.Item and sg.Content.Item.Fish
                    local definition = fish and type(fish.Get) == "function" and fish:Get(item.Name, true)
                    counts = not (definition and type(definition.Relic) == "string")
                end
                if counts then count += 1 end
            end
        end
        return count
    end,
    IsUnloaded = function() return Library.Unloaded end,
    IsCastPreparing = function() return Recovered.DeepCaster and Recovered.DeepCaster.Busy end,
    Invoke = function(canContinue, automatic)
        return ErrorScriptsDeepSellTrip({
            WorldFolder = sg.Utils and sg.Utils.WorldFolder,
            GetRoot = function() return tf() end,
            GetHumanoid = function() return tx() end,
            GetInventory = function() local data = sS(); return data and data.Inventory end,
            IsLocked = function(item)
                local lock = sg.Modules and sg.Modules.Lock
                return lock and type(lock.IsLocked) == "function" and lock.IsLocked(item) == true
            end,
            IsFishingBusy = function()
                return sg.Charging or sc.Active or sc.AwaitingServer or rawget(sc, "OutroToken") ~= nil
            end,
            Invoke = function() return ss("SellAll", 5, "Fish") end,
            Wait = task.wait,
        }, canContinue, automatic)
    end,
    Report = function(message) warn("[ErrorScripts] " .. message) end,
})
Recovered.DeepCaster = ErrorScriptsCreateDeepCaster({
    IsBlocked = function() return Recovered.DeepSeller.Busy end,
    RunClient = function(callback) return ErrorScriptsDeepClientCall(callback) end,
    GetFishing = function() return sg end,
    GetCinematic = function() return sc end,
    IsEnabled = function() return rQ("AutoPerfectFishing") end,
    IsFast = function() return rQ("FastFishing") end,
    IsUnloaded = function() return Library.Unloaded end,
    ShouldUseBait = function() return rQ("AutoUseBait") end,
    UseBait = function() s5() end,
    EquipRod = function() return s9() end,
    MoveToFishing = function() rX() end,
    ShouldSell = function() return rQ("AutoSell") end,
    Sell = function() return sw(true) end,
    SetDriving = function(value) sf(value) end,
    WaitFrame = function() RunService.RenderStepped:Wait() end,
    Report = function(message)
        warn("[ErrorScripts] " .. message)
        if not Library.Unloaded then Library:Notify(message:match("^[^\n]*") or message) end
    end,
})
Eq[26] = Library:CreateWindow({
	["Title"] = "ErrorScripts",
	["Font"] = Recovered.Enum.Font.BuilderSans,
	["Footer"] = { { ["Text"] = r5, ["Copyable"] = true }, "|", sa },
	["Icon"] = nil,
	["NotifySide"] = "Right",
	["ShowCustomCursor"] = false,
	["CornerRadius"] = 0,
	["SidebarCompacted"] = true,
	["TabSwipeFrom"] = "bottom",
	["Animations"] = { ["TabSwitch"] = true },
})
Eq[49] = (vector.create(9, 9, 11))
local Gk_cfg19 = (vector.floor(Eq[49]) + vector.ceil((Eq[49] * Recovered[590])))
if vector.dot(Gk_cfg19, Gk_cfg19) == 5 then
	Eq[26] = {
		["Main"] = tH:AddTab("Main", "fish"),
		["Player"] = tH:AddTab("Player", "person-standing"),
		["Info"] = tH:AddTab("Info", "info"),
		["Settings"] = tH:AddTab("Settings", "settings"),
	}
else
	tH = {
		["Info"] = Eq[26]:AddTab("Info", "info"),
		["Main"] = Eq[26]:AddTab("Main", "fish"),
		["Player"] = Eq[26]:AddTab("Player", "person-standing"),
		["Settings"] = Eq[26]:AddTab("Settings", "settings"),
	}
end
Eq[10] = Recovered[976]
Eq[21] = false
for jl, jm in tH do
	Eq[59] = jl
	Eq[41] = jm
	Eq[50] = Eq[59]
	Eq[31] = Eq[41]
	local ue = nil
	ue = 0
	if Eq[50] ~= "Info" then
		Eq[10](Eq[31])
	end
	if Eq[21] then
		break
	end
end
Eq[46] = tH.Main:AddLeftGroupbox("Fishing", "fish")
Eq[46]:AddToggle("AutoPerfectFishing", { ["Text"] = "Auto Perfect Fishing", ["Default"] = false })
Toggles.AutoPerfectFishing:OnChanged(function()
    if not rQ("AutoPerfectFishing") and Recovered.DeepCaster then Recovered.DeepCaster:Stop() end
end)
Eq[46]:AddToggle("AutoCollectFish", { ["Text"] = "Auto Collect Fish", ["Default"] = false })
Eq[46]:AddToggle("FastFishing", { ["Text"] = "Fast Fishing", ["Default"] = true })
Eq[46]:AddToggle("AutoStopWhenEmpty", { ["Text"] = "Auto Stop When Empty", ["Default"] = true })
Eq[46]:AddDropdown("CollectRarities", {
	["Text"] = "Collect Rarities",
	["Values"] = Eq[28],
	["Multi"] = true,
	["Searchable"] = true,
	["AllowNull"] = true,
	["Default"] = {},
})
Eq[46]:AddDropdown("CollectMutations", {
	["Text"] = "Collect Mutations",
	["Values"] = Eq[34],
	["Multi"] = true,
	["Searchable"] = true,
	["AllowNull"] = true,
	["Default"] = {},
})
Eq[34] = (sS())
if Eq[34] then
	Eq[34] = sS().AutoLock
end
Eq[26] = Eq[34]
Eq[36] = (if Eq[26] then 1 else 0)
Eq[26] = Eq[26] or "None"
	Eq[40], Eq[49], Eq[19], Eq[34], Eq[61], sZ, sT, Eq[30], su, Eq[58], Eq[13], tg, Eq[28], Eq[52], Eq[22], Eq[10], Eq[43] =
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	Eq[46]:AddDropdown(
		"AutoFavourite",
		{ ["Text"] = "Auto Favourite", ["Values"] = Eq[6], ["Searchable"] = true, ["Default"] = Eq[26] }
	)
	Eq[46]:AddDivider("Finds")
	Eq[46]:AddToggle("AutoCollectFinds", { ["Text"] = "Auto Collect Finds", ["Default"] = false })
	Eq[46]:AddToggle("AutoCollectFragments", {
		["Text"] = "Auto Collect Fragments",
		["Default"] = false,
	})
    Eq[46]:AddToggle("AutoCollectEggs", {
        ["Text"] = "Auto Collect Eggs",
        ["Default"] = false,
    })
    Eq[46]:AddButton({
        ["Text"] = "Copy egg names",
        ["Func"] = Recovered.CopyEggIdentifiers,
    })
	Eq[46]:AddButton({
		["Text"] = "Copy active find names/types",
		["Func"] = Recovered.CopyActiveFindIdentifiers,
	})

    for _, id in ipairs({ "AutoCollectFish", "AutoCollectFinds", "AutoCollectFragments", "AutoCollectEggs" }) do
        Toggles[id]:OnChanged(function()
            if not rR() then Recovered.ReleaseCollectionAim() end
        end)
    end

	Eq[46]:AddDropdown("CollectFindTypes", {
		["Text"] = "Find Types",
		["Values"] = Eq[55],
		["Multi"] = true,
		["Searchable"] = true,
		["AllowNull"] = true,
		["Default"] = {},
	})
	Eq[13] = Recovered[895]
	Options.AutoFavourite:OnChanged(Eq[13])
	Eq[40] = tH.Main:AddLeftGroupbox("Rewards", "gift")
	Eq[40]:AddToggle("AutoClaimBigFish", { ["Text"] = "Auto Claim Big Fish", ["Default"] = false })
	Eq[40]:AddToggle("AutoClaimFreeRewards", { ["Text"] = "Auto Claim Free Rewards", ["Default"] = false })
	Eq[49] = tH.Main:AddLeftGroupbox("Sell", "circle-dollar-sign")
	Eq[49]:AddToggle("AutoSell", { ["Text"] = "Auto Sell", ["Default"] = false })
    Toggles.AutoSell:OnChanged(function()
        if not rQ("AutoSell") then Recovered.DeepSeller:Stop() end
    end)
	Eq[49]:AddSlider("AutoSellFishCount", {
        Text = "Sell at fish count", Default = 2000, Min = 0, Max = 2500, Rounding = 0,
    })
    Options.AutoSellFishCount:OnChanged(function() Recovered.DeepSeller:Stop() end)
    Eq[49]:AddLabel("0 = sell as soon as fish are available.")
	Eq[49]:AddButton({ ["Text"] = "Sell All Fish", ["Func"] = Recovered[545] })
	Eq[19] = tH.Main:AddRightGroupbox("Shop", "shopping-bag")
	Eq[19]:AddToggle("AutoBuyBait", { ["Text"] = "Auto Buy Best Bait", ["Default"] = false })
	Eq[19]:AddButton({ ["Text"] = "Buy Best Bait Now", ["Func"] = Recovered[998] })
	Eq[19]:AddToggle("AutoBuyBestRod", { ["Text"] = "Auto Buy Best Rod", ["Default"] = false })
	Eq[19]:AddButton({ ["Text"] = "Buy Best Rod Now", ["Func"] = Recovered[249] })
	Eq[19]:AddDivider("Upgrades")
	Eq[19]:AddToggle("AutoBuyUpgrades", { ["Text"] = "Auto Buy Upgrades", ["Default"] = false })
	Eq[19]:AddDropdown("BuyUpgrades", {
		["Text"] = "Upgrades",
		["Values"] = sh,
		["Multi"] = true,
		["Searchable"] = true,
		["AllowNull"] = true,
		["Default"] = {},
	})
	Eq[34] = tH.Main:AddRightGroupbox("Codes", "ticket")
	Eq[34]:AddInput(
		"CodeText",
		{ ["Text"] = "Code", ["Placeholder"] = "Enter code", ["Finished"] = true, ["AllowEmpty"] = true }
	)
	Eq[34]:AddButton({ ["Text"] = "Redeem Code", ["Func"] = Recovered[73] })
	Eq[61] = tH.Main:AddRightGroupbox("Bait", "package")
	Eq[61]:AddToggle("AutoUseBestBait", { ["Text"] = "Auto Use Best Bait", ["Default"] = false })
	Eq[61]:AddButton({ ["Text"] = "Use Best Bait Now", ["Func"] = Recovered[1082] })
	Eq[61]:AddDivider("Selected")
	Eq[61]:AddToggle("AutoUseBait", { ["Text"] = "Auto Use Bait", ["Default"] = false })
	Eq[61]:AddDropdown(
		"UseBaitName",
		{ ["Text"] = "Use Bait", ["Values"] = Eq[16], ["Searchable"] = true, ["AllowNull"] = true, ["Default"] = "" }
	)
	Eq[61]:AddButton({ ["Text"] = "Use Bait Now", ["Func"] = Recovered[1263] })
	local Ge_cfg22 = Recovered.task.spawn
	Recovered.task_spawn(Recovered[128])
	tm(RunService.RenderStepped:Connect(Recovered[484]))
	tg = Recovered[1282]
	Eq[28] = function()
		local Cc
		local B9
		B9 = nil
		Cc = nil
		local B8, Ca, Cb, Cd, Ce, Cf, Cg, Ch = nil, nil, nil, nil, nil, nil, nil, nil
		local Ci = nil
		Ci = 2
		B9 = "Unknown"
		Recovered[892](function()
			local BV, BW, BX, BY, B_, B0, B1 = nil, nil, nil, nil, nil, nil, nil
			local BZ = nil
			BZ = 8
			B1 = (if identifyexecutor then 1 else 0)
			if B1 == 1 then
				BW, BV = identifyexecutor()
				BX = (BW ~= "")
				BY = (type(BW) == "string")
				if BY then
					BY = BX
				end
				if BY then
					BX = (type(BV) == "string")
					if BX then
						BX = (BV ~= "")
					end
					if BX then
						BX = (BW .. (" " .. BV))
					end
					BV = BX
					if not BV then
						BV = BW
					end
					B9 = BV
				end
			end
		end)
		Cf = tg()
		Cc = os.clock()
		B8 = function()
			local Ep = string.format
			local B2 = nil
			local B3 = nil
			B3 = 2
			B2 = math.floor((os.clock() - Cc))
			if B2 < 60 then
				return (B2 .. "s")
			else
				if B2 < 3600 then
					return Ep("%dm %ds", (B2 // 60), (B2 % 60))
				else
					return Ep("%dh %dm", (B2 // 3600), ((B2 % 3600) // 60))
				end
			end
		end
		Cg = tH.Info:AddLeftGroupbox("User", "circle-user")
		Cg:AddPlayerInfo(
			"InfoUserCard",
			{ ["Player"] = sP, ["Title"] = "User", ["HeaderIcon"] = "user", ["Collapsible"] = false }
		)
		Cg:AddLabel(sj("UserId", tostring(sP.UserId), rH), true)
		Cg:AddLabel(sj("Executor", (B9 .. ("  " .. Cf)), rM), true)
		Cg:AddDivider()
		Cd = Cg:AddLabel(sj("Session", B8(), rE), true)
		Cg:AddDivider()
		Cg:AddButton({
			["Text"] = "Copy Username",
			["Func"] = function()
				s7(sP.Name, "Copied username")
			end,
		})
		Cg:AddButton({
			["Text"] = "Copy Profile Link",
			["Func"] = function()
				s7(("https://www.roblox.com/users/" .. (tostring(sP.UserId) .. "/profile")), "Copied profile link")
			end,
		})
		Cf = tH.Info:AddRightGroupbox("Session", "signal")
		Cf:AddDivider("Server")
		Cf:AddLabel(sj("Game", sa, rH), true)
		Cb = Cf:AddLabel(sj("Players", "0/0", rM), true)
		Ce = tostring(Recovered.game.JobId)
		Cg = (#Ce > 18)
		if Cg then
			Cg = (string.sub(Ce, 1, 18) .. "...")
		end
		Ch = Cg
		if not Ch then
			Ch = Ce
		end
		Cg = Ch
		Cf:AddLabel(sj("Job", Cg, tE), true)
		Ca = Cf:AddLabel(sj("Ping", "0 ms", rE), true)
		Cf:AddDivider()
		Cf:AddButton({
			["Text"] = "Rejoin Server",
			["Func"] = function()
				local FS = Recovered.game.PlaceId
				TeleportService:Teleport(Recovered.game_PlaceId, sP)
			end,
		})
		Cf:AddButton({
			["Text"] = "Copy Job ID",
			["Func"] = function()
				s7(Ce, "Copied Job ID")
			end,
		})
		local FT_cfg1 = Recovered.task.spawn
		Recovered.task_spawn(function()
			local B4, B5, B6 = nil, nil, nil
			local B7 = nil
			B7 = 7
			while true do
				local FU_cfg1 = Recovered.task.wait
				Recovered.task_wait(1)
				if Library.Unloaded then
					break
				else
					Cd:SetText(sj("Session", B8(), rE))
					Cb:SetText(sj("Players", ((#Players:GetPlayers()) .. ("/" .. tostring(Players.MaxPlayers))), rM))
					B4, B5 = Recovered[892](function()
						return math.floor(
							Recovered.game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
						)
					end)
					B6 = B4
					if B6 then
						B6 = (B5 .. " ms")
					end
					B4 = B6
					if not B4 then
						B4 = "n/a"
					end
					Ca:SetText(sj("Ping", B4, rE))
					continue
				end
			end
		end)
		Cf = tH.Info:AddRightGroupbox("ErrorScripts", "info")
		Cf:AddLabel("Custom interface for Deep Fishing.")
		Cf:AddLabel("Drag ES to move it. Click to open.")
		Cf:AddLabel("Customize the menu in Settings.")
	end
	Eq[28]()
	Eq[52] = function()
		local lE
		local lm = tH.Player:AddLeftGroupbox("Movement", "footprints")
		lm:AddToggle("WalkSpeedEnabled", { ["Text"] = "WalkSpeed", ["Default"] = false })
		lm:AddSlider(
			"WalkSpeed",
			{ ["Text"] = "WalkSpeed Amount", ["Default"] = 32, ["Min"] = 16, ["Max"] = 250, ["Rounding"] = 0 }
		)
		lm:AddToggle("InfJump", { ["Text"] = "Infinite Jump", ["Default"] = false })
		lm:AddToggle("NoClip", { ["Text"] = "NoClip", ["Default"] = false })
		lm:AddToggle("AntiGameplayPause", { ["Text"] = "No Gameplay Paused", ["Default"] = true })
		lm:AddToggle("InstantProximityPrompt", { ["Text"] = "Instant ProximityPrompt", ["Default"] = false })
		local ln = tH.Player:AddRightGroupbox("Fly", "feather")
		ln:AddToggle("Fly", { ["Text"] = "Fly", ["Default"] = false })
		ln:AddSlider(
			"FlySpeed",
			{ ["Text"] = "Fly Speed", ["Default"] = 60, ["Min"] = 10, ["Max"] = 400, ["Rounding"] = 0 }
		)
		local function lo(lp)
			local Cm = nil
			Cm = 0
			Recovered[892](function()
				GuiService:SetGameplayPausedNotificationEnabled(not lp)
			end)
			Recovered[892](function()
				local Cj = nil
				local Ck = nil
				Ck = 3
				Cj = CoreGui:FindFirstChild("RobloxNetworkPauseNotification")
				if Cj then
					Cj.Enabled = not lp
				end
			end)
			if not lp then
				return
			else
				Recovered[892](function()
					local Cl = nil
					Cl = 4
					if sethiddenproperty then
						sethiddenproperty(sP, "GameplayPaused", false)
					else
						sP.GameplayPaused = false
					end
				end)
			end
		end
		local function lC(lD)
			local Co, Cp, Cq = nil, nil, nil
			local Cn = nil
			Cn = 4
			Cq = (if not lD:IsA("ProximityPrompt") then 1 else 0)
			if Cq == 1 then
				return
			else
				lD.HoldDuration = 0
				lD.MaxActivationDistance = 50
				lD.RequiresLineOfSight = false
			end
		end
		lE = nil
		tm(RunService.Stepped:Connect(function()
			local Cr, Ct, Cu, Cv, Cx, Cz, CA, CB = nil, nil, nil, nil, nil, nil, nil, nil
			local Cs = nil
			Cs = 6
			if Library.Unloaded then
				return
			else
				Cr = Toggles.NoClip
				if Cr then
					Cr = Toggles.NoClip.Value
				end
				if Cr then
					Cr = sP.Character
					CB = (if Cr then 1 else 0)
					if CB == 1 then
						Cu = false
						for lO, lP in Cr:GetDescendants() do
							Cv = lO
							Cx = lP
							local Cw = Cv
							local Cy = Cx
							local Ct = nil
							Ct = 6
							Cr = (Cy:IsA("BasePart"))
							if Cr then
								Cr = Cy.CanCollide
							end
							if Cr then
								Cy.CanCollide = false
							end
							if Cu then
								break
							end
						end
					end
				end
			end
		end))
		tm(UserInputService.JumpRequest:Connect(function()
			local CC = nil
			local CD = nil
			CD = 0
			if Library.Unloaded then
				return
			else
				CC = Toggles.InfJump
				if CC then
					CC = Toggles.InfJump.Value
				end
				if CC then
					CC = tx()
					if CC then
						CC:ChangeState(Recovered.Enum.HumanoidStateType.Jumping)
					end
				end
			end
		end))
		local lZ = Workspace.CurrentCamera
		tm(RunService.RenderStepped:Connect(function(l_)
			local CE, CF, CG, CI, CJ, CK, CL, CM, CN = nil, nil, nil, nil, nil, nil, nil, nil, nil
			local CH = nil
			CH = 24
			if Library.Unloaded then
				return
			else
				CE = Toggles.WalkSpeedEnabled
				if CE then
					CE = Toggles.WalkSpeedEnabled.Value
				end
				if CE then
					CE = tx()
					if CE then
						CE.WalkSpeed = Options.WalkSpeed.Value
					end
				end
				CE = Toggles.Fly
				if CE then
					CE = Toggles.Fly.Value
				end
				if CE then
					CE = tf()
					CF = tx()
					CG = CE
					if CG then
						CG = CF
					end
					if CG then
						CF.PlatformStand = true
						CF = Recovered.Vector3.zero
						CK = (if UserInputService:IsKeyDown(Recovered.Enum.KeyCode.W) then 1 else 0)
						if CK == 1 then
							CF += lZ.CFrame.LookVector
						end
						if UserInputService:IsKeyDown(Recovered.Enum.KeyCode.S) then
							CF -= lZ.CFrame.LookVector
						end
						if UserInputService:IsKeyDown(Recovered.Enum.KeyCode.A) then
							CF -= lZ.CFrame.RightVector
						end
						if UserInputService:IsKeyDown(Recovered.Enum.KeyCode.D) then
							CF += lZ.CFrame.RightVector
						end
						if UserInputService:IsKeyDown(Recovered.Enum.KeyCode.Space) then
							local F3_cfg2 = Recovered.Vector3.new
							CF += Recovered.Vector3_new(0, 1, 0)
						end
						CN = (if UserInputService:IsKeyDown(Recovered.Enum.KeyCode.LeftControl) then 1 else 0)
						if CN == 1 then
							local F4_cfg1 = Recovered.Vector3.new
							CF -= Recovered.Vector3_new(0, 1, 0)
						end
						CE.AssemblyLinearVelocity = Recovered.Vector3.zero
						if CF.Magnitude > 0 then
							CE.CFrame = (CE.CFrame + ((CF.Unit * Options.FlySpeed.Value) * l_))
						end
					end
				end
			end
		end))
		Toggles.Fly:OnChanged(function()
			local CO = nil
			local CP = nil
			CP = 3
			if not Toggles.Fly.Value then
				CO = tx()
				if CO then
					CO.PlatformStand = false
				end
			end
		end)
		Toggles.WalkSpeedEnabled:OnChanged(function()
			local CQ, CS, CT, CU = nil, nil, nil, nil
			local CR = nil
			CR = 2
			CU = (if not Toggles.WalkSpeedEnabled.Value then 1 else 0)
			if CU == 1 then
				CQ = tx()
				if CQ then
					CQ.WalkSpeed = 16
				end
			end
		end)
		Toggles.AntiGameplayPause:OnChanged(function()
			lo(Toggles.AntiGameplayPause.Value)
		end)
		lo(true)
		Toggles.InstantProximityPrompt:OnChanged(function()
			local C_, C0, C1, C3 = nil, nil, nil, nil
			local CZ = nil
			CZ = 2
			if Toggles.InstantProximityPrompt.Value then
				C0 = false
				for mq, mr in Workspace:GetDescendants() do
					C1 = mq
					C3 = mr
					local C2 = C1
					local C4 = C3
					local C_ = nil
					C_ = 0
					Recovered[892](lC, C4)
					if C0 then
						break
					end
				end
				lE = Workspace.DescendantAdded:Connect(function(mt)
					local CW, CX, CY = nil, nil, nil
					local CV = nil
					CV = 0
					CY = (if Toggles.InstantProximityPrompt.Value then 1 else 0)
					if CY == 1 then
						Recovered[892](lC, mt)
					end
				end)
				tm(lE)
			else
				if lE then
					lE:Disconnect()
					lE = nil
				end
			end
		end)
		local F9 = Recovered.task.spawn
		Recovered.task_spawn(function()
			local C5 = nil
			C5 = 1
			while true do
				if not Library.Unloaded then
					local Ga_cfg1 = Recovered.task.wait
					Recovered.task_wait(1)
					if rQ("AntiGameplayPause") then
						lo(true)
					end
					continue
				else
					break
				end
			end
		end)
		return lo,
			function()
				local C7, C8, C9 = nil, nil, nil
				local C6 = nil
				C6 = 1
				C9 = (if lE then 1 else 0)
				if C9 == 1 then
					lE:Disconnect()
					lE = nil
				end
			end
	end
	sZ, sT = Eq[52]()
	Eq[22] = function(mF)
		local mG = 0
		local mH = tick()
		mF:AddToggle("AntiAfk", { ["Text"] = "Anti-AFK", ["Default"] = true })
		local mI = mF:AddLabel("AFK triggers: 0")
		local function mJ()
			local Da = nil
			local Db = nil
			Db = 3
			Da = Workspace.CurrentCamera
			if not Da then
				return
			else
				VirtualUser:CaptureController()
				local FE_cfg1 = Recovered.Vector2.new
				VirtualUser:ClickButton2(Recovered.Vector2_new(0, 0), Da.CFrame)
				mG += 1
				mH = tick()
				Recovered[892](function()
					mI:SetText(("AFK triggers: " .. mG))
				end)
			end
		end
		local mY = sP.Idled:Connect(function()
			local Dc = nil
			Dc = 3
			if rQ("AntiAfk") then
				Recovered[892](mJ)
			end
		end)
		local FG = Recovered.task.spawn
		Recovered.task_spawn(function()
			local Dd = nil
			local De = nil
			De = 4
			while true do
				if not Library.Unloaded then
					local FH_cfg1 = Recovered.task.wait
					Recovered.task_wait(2)
					Dd = (rQ("AntiAfk"))
					if Dd then
						Dd = ((tick() - mH) >= 60)
					end
					if Dd then
						Recovered[892](mJ)
					end
					continue
				else
					break
				end
			end
		end)
		mF:AddButton({
			["Text"] = "Unload UI",
			["Func"] = function()
				Library:Unload()
			end,
		})
		return mY
	end
	Eq[30] = tH.Settings:AddLeftGroupbox("Menu")
	Eq[30]
		:AddLabel("Menu bind")
		:AddKeyPicker("MenuKeybind", { ["Default"] = "RightShift", ["NoUI"] = true, ["Text"] = "Menu keybind" })
	Library.ToggleKeybind = Options.MenuKeybind
	su = Eq[22](Eq[30])
	Eq[37]:SetLibrary(Library)
	Eq[37]:SetFolder("ErrorScripts")
	Eq[37]:SaveDefault("Blue")
	Eq[37]:ApplyToTab(tH.Settings)
	Eq[37]:LoadDefault()
	tI:SetLibrary(Library)
	tI:IgnoreThemeSettings()
	tI:SetIgnoreIndexes({ "MenuKeybind", "SaveManager_ImportSource" })
	tI:SetFolder("ErrorScripts/DeepFishing")
	Eq[58] = tI:BuildConfigSection(tH.Settings)
	tI:LoadAutoloadConfig()
	Eq[13]()
	Eq[10] = function(m9)
		local function na(nb, nc)
			local Df, Dg, Dh, Dj, Dk, Dl = nil, nil, nil, nil, nil, nil
			local Di = nil
			Di = 1
			Df = (nb == "Toggle")
			if Df then
				Df = Toggles
			end
			Dg = Df
			if not Dg then
				Dg = Options
			end
			Df = Dg
			Dg = Df[nc]
			Df = (type(Dg) == "table")
			Dl = (if Df then 1 else 0)
			if Dl == 1 then
				Df = (Dg.Type == nb)
			end
			Dh = Df
			if Dh then
				Dh = Dg
			end
			Df = Dh
			if not Df then
				Df = nil
			end
			return Df
		end
		local function nk(nl, nm)
			local Dm, Dn, Dp, Dq, Dr, Ds, Dt, Du, Dv, Dw, Dx = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
			local Do = nil
			Do = 14
			Dm = nm.Type
			if Dm == "Toggle" then
				return { ["idx"] = nl, ["type"] = "Toggle", ["value"] = (nm.Value == true) }
			else
				if Dm == "Slider" then
					return { ["idx"] = nl, ["type"] = "Slider", ["value"] = tostring(nm.Value) }
				else
					if Dm == "Dropdown" then
						return {
							["idx"] = nl,
							["type"] = "Dropdown",
							["multi"] = (nm.Multi == true),
							["value"] = nm.Value,
						}
					else
						Dx = (if Dm == "Input" then 1 else 0)
						if Dx == 1 then
							Dn = nm.Value
							Dr = (if Dn then 1 else 0)
							if not (Dr == 1) then
								Dn = ""
							end
							return { ["idx"] = nl, ["type"] = "Input", ["text"] = tostring(Dn) }
						else
							Du = (if Dm == "ColorPicker" then 1 else 0)
							if Du == 1 then
								return {
									["idx"] = nl,
									["type"] = "ColorPicker",
									["value"] = nm.Value:ToHex(),
									["transparency"] = nm.Transparency,
								}
							else
								if Dm == "KeyPicker" then
									return {
										["idx"] = nl,
										["type"] = "KeyPicker",
										["mode"] = nm.Mode,
										["key"] = nm.Value,
										["modifiers"] = nm.Modifiers,
										["toggled"] = nm.Toggled,
									}
								else
									return nil
								end
							end
						end
					end
				end
			end
		end
		local function no()
			local Dz, DA, DC, DD, DE, DG, DI, DJ, DK, DM = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
			local DB = nil
			DB = 1
			Dz = {}
			DD = false
			for nq, nr in { Toggles, Options } do
				DE = nq
				DG = nr
				local DF = DE
				local DH = DG
				local DC = nil
				DC = 1
				DJ = false
				for ns, nt in DH do
					DK = ns
					DM = nt
					local DL = DK
					local DN = DM
					local DI = nil
					DI = 6
					DA = (type(DN) == "table")
					if DA then
						DA = (type(DN.Type) == "string")
					end
					if DA then
						DA = not tI.Ignore[DL]
					end
					if DA then
						DA = nk(DL, DN)
						if DA then
							Dz[(#Dz + 1)] = DA
						end
					end
					if DJ then
						break
					end
				end
				if DD then
					break
				end
			end
			table.sort(Dz, function(nw, nx)
				local Dy = nil
				Dy = 0
				if nw.type ~= nx.type then
					return (nw.type < nx.type)
				else
					return (nw.idx < nx.idx)
				end
			end)
			return { ["objects"] = Dz }
		end
		local function ny(nz)
			local DQ
			DQ = nil
			local DR = nil
			local DS = nil
			DS = 6
			DR = (type(nz) ~= "table")
			if not DR then
				DR = (type(nz.idx) ~= "string")
			end
			if not DR then
				DR = (type(nz.type) ~= "string")
			end
			if not DR then
				DR = tI.Ignore[nz.idx]
			end
			if DR then
				return false
			else
				DQ = na(nz.type, nz.idx)
				if not DQ then
					return false
				else
					DR = Recovered[892](function()
						local DO = nil
						local DP = nil
						DP = 13
						if nz.type == "Input" then
							if type(nz.text) ~= "string" then
								return
							else
								DQ:SetValue(nz.text)
							end
						else
							if nz.type == "ColorPicker" then
								DQ:SetValueRGB(Recovered.Color3.fromHex(nz.value), nz.transparency)
							else
								if nz.type == "KeyPicker" then
									DQ:SetValue({ nz.key, nz.mode, nz.modifiers })
									DO = (nz.mode == "Toggle")
									if DO then
										DO = (nz.toggled ~= nil)
									end
									if DO then
										DQ.Toggled = nz.toggled
										DQ:Update()
									end
								else
									DQ:SetValue(nz.value)
								end
							end
						end
					end)
					return DR
				end
			end
		end
		m9:AddDivider()
		m9:AddInput(
			"SaveManager_ImportSource",
			{ ["Text"] = "Paste exported config here", ["Finished"] = true, ["AllowEmpty"] = true }
		)
		m9:AddButton("Export Config to Clipboard", function()
			local DT, DU, DV, DX, DY, DZ = nil, nil, nil, nil, nil, nil
			local DW = nil
			DW = 8
			DT, DU = Recovered[892](HttpService.JSONEncode, HttpService, no())
			if not DT then
				Library:Notify("Failed to encode the config")
				return
			else
				DT = setclipboard
				if not DT then
					DT = toclipboard
				end
				DV = DT
				DT = (type(DV) ~= "function")
				DZ = (if DT then 1 else 0)
				if not (DZ == 1) then
					DT = (not Recovered[892](DV, DU))
				end
				if DT then
					Library:Notify("Your executor does not support copying to the clipboard")
					return
				else
					Library:Notify("Config copied to clipboard", 6)
				end
			end
		end)
		m9:AddButton("Import Config from Clipboard Text", function()
			local D_, D0, D1, D3, D4, D5, D7 = nil, nil, nil, nil, nil, nil, nil
			local D2 = nil
			D2 = 1
			D_ = Options.SaveManager_ImportSource.Value
			if not D_ then
				D_ = ""
			end
			D0 = tostring(D_):match("^%s*(.-)%s*$")
			if D0 == "" then
				Library:Notify("Paste an exported config into the box first")
				return
			else
				D_, D1 = Recovered[892](HttpService.JSONDecode, HttpService, D0)
				D0 = not D_
				if not D0 then
					D0 = (type(D1) ~= "table")
				end
				if not D0 then
					D0 = (type(D1.objects) ~= "table")
				end
				if D0 then
					Library:Notify("That is not a valid exported config")
					return
				else
					D_ = 0
					D4 = false
					for n_, n0 in D1.objects do
						D5 = n_
						D7 = n0
						local D6 = D5
						local D8 = D7
						local D3 = nil
						D3 = 2
						if ny(D8) then
							D_ += 1
						end
						if D4 then
							break
						end
					end
					if D_ == 0 then
						Library:Notify("No settings in that config matched this script")
						return
					else
						Options.SaveManager_ImportSource:SetValue("")
						D0 = (D_ == 1)
						if D0 then
							D0 = ""
						end
						D1 = D0
						if not D1 then
							D1 = "s"
						end
						Library:Notify(("Imported %d setting%s"):format(D_, D1), 6)
					end
				end
			end
		end)
	end
	Eq[10](Eq[58])

return Library
end


local function ErrorScriptsPyramid(Library, Theme, Save)
    -- Called by the hub only after successful Vampauth validation.
    if Library.Unloaded then return end
    if game.GameId ~= 10765012427 then error("Wrong universe for Build The Pyramid") end
    local pyramidJit = type(LPH_JIT) == "function" and LPH_JIT or function(fn) return fn end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local osClock = os.clock
local vector3New = Vector3.new

local xDTaraZ = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(self, key, type(value) == "function" and pyramidJit(value) or value)
    end,
})

xDTaraZ.Config = {
    SaveFolder = "ErrorScripts/BuildThePyramid",
    TickDelay = 0.1,
    LoadTimeout = 10,
    AlertTries = 20,
    AlertGap = 0.5,
    FailLimit = 5,
    FailWindow = 10,
    SettleDelay = 0.15,
    StreamWait = 2,
    StreamDistance = 200,
    CameraShieldJump = 100,
    PickupRetries = 3,
    PickupTimeout = 2,
    BenchBase = 3.75,
    LevelProbe = 1000,
    SmartRefresh = 2,
    RateSample = 15,
    SaveSeconds = 600,
    UpgradePriority = { "bulkPlace", "placementRange", "bulkPickup" },
    QuarryJitter = 0.35,
    RetryDelay = 1,
    RetryMax = 8,
    StallLimit = 120,
    PlaceTimeout = 3,
    PlaceRetries = 3,
    SlotSpacing = 2,
    SlotSearchCells = 150,
    EngineRadiusLimit = 15000,
    HoverHeight = 6,
    StandHeight = 3,
    QuarrySpot = vector3New(-234, -16, 38),
    BenchRange = 12,
    BenchRetry = 2,
    StandRadius = 4,
    UpgradeInterval = 2,
    UpgradeGap = 0.3,
    UpgradeBurst = 36,
    CodeGap = 1.1,
    ActivityInterval = 60,
    RateWindow = 60,
    RejoinDelay = 5,
    SlowRequests = { UpgradeNow = true, CodesNow = true, BankNow = true, GiftNow = true },
    ExtraCodes = { "SUNGOD", "SORRYFORUPDATEBUG", "FREECODE", "WELCOME", "DEADBYMELOL", "UPDATE15", "PYRAMID1500" },
}

xDTaraZ.State = {
    Alive = true,
    Connections = {},
    MoveConns = {},
    Requests = {},
    Running = {},
    Messages = {},
    Last = {},
    Stats = {},
    CoinLog = {},
    Fails = {},
    FailSince = {},
    Halted = {},
    HaltQueue = {},
    Status = "Idle",
    Task = "None",
    Placed = 0,
    FarmWait = 0,
    Opt = {
        AutoFarm = false,
        ReturnOnStop = false,
        PlaceReach = 30,
        BenchStation = "Best Unlocked",
        TreadmillStation = "Best Unlocked",
        AutoUpgrade = false,
        Upgrades = {},
        UpgradeOrder = "Best Value",
        KeepCoins = 0,
        AutoStrength = false,
        AutoSpeed = false,
        Priority = "Balanced",
        SmartMinutes = 30,
        AlternateMinutes = 5,
        AutoPool = false,
        SpeedOn = false,
        WalkSpeed = 100,
        Fly = false,
        FlySpeed = 60,
        Noclip = false,
        InfJump = false,
        AntiAfk = false,
        AutoRejoin = false,
        NoRender = false,
    },
}

local Config, State = xDTaraZ.Config, xDTaraZ.State
Library:OnUnload(function() State.Alive = false end)

xDTaraZ.Util = {}

---@return string?, string?  body, or nil and why every transport failed
function xDTaraZ.Util.HttpGet(url)
    local ok, body = pcall(game.HttpGet, game, url)
    if ok and type(body) == "string" then return body end
    local requester = request or http_request or (syn and syn.request) or (http and http.request)
    if not requester then return nil, "no http function" end

    local sent, reply = pcall(requester, { Url = url, Method = "GET" })
    if not sent or type(reply) ~= "table" then return nil, tostring(reply) end
    if reply.StatusCode ~= 200 or type(reply.Body) ~= "string" then return nil, "HTTP " .. tostring(reply.StatusCode) end
    return reply.Body
end

---@param detail any?  extra context for the console only
function xDTaraZ.Util.Alert(text, detail)
    warn("[ErrorScripts/BuildThePyramid]", text, detail or "")
    Library:Notify(text)
end

---@return boolean  fn finished without error
function xDTaraZ.Util.Try(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn("[BuildThePyramid] " .. label .. ":", err) end
    return ok
end

---@return boolean  the hub is queued to load again after the next teleport
function xDTaraZ.Util.QueueReload()
    local queue = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
    local source = Library.ReloadSource
    if not queue or type(source) ~= "string" or source == "" then return false end
    return (pcall(queue, source))
end

function xDTaraZ.Util.Copy(text)
    local copy = setclipboard or toclipboard
    if not copy then return false end
    return (pcall(copy, text))
end

local bootMissed = false

---@return Instance?  child, nil once Config.LoadTimeout runs out; no waiting after the first miss
local function Wait(parent, name)
    if not parent or not State.Alive or Library.Unloaded then return nil end
    if bootMissed then return parent:FindFirstChild(name) end
    local child = parent:WaitForChild(name, Config.LoadTimeout)
    if not State.Alive or Library.Unloaded then return nil end
    if not child then bootMissed = true end
    return child
end

---@return Instance?  Services folder of whichever knit version the game ships
local function FindKnitServices()
    local index = Wait(Wait(ReplicatedStorage, "Packages"), "_Index")
    if not index then return nil end
    local fallback
    for _, package in ipairs(index:GetChildren()) do
        if not package.Name:find("^sleitnick_knit") then continue end
        local knit = package:FindFirstChild("knit")
        local services = knit and knit:FindFirstChild("Services")
        if services then return services end
        fallback = fallback or knit
    end
    return Wait(fallback, "Services")
end

local Shared = Wait(ReplicatedStorage, "Shared")
local SharedConfig = Wait(Shared, "Config")
local KnitServices = FindKnitServices()

if not State.Alive or Library.Unloaded then return end

if not (SharedConfig and KnitServices) then
    xDTaraZ.Util.Alert("Build The Pyramid changed. The game adapter needs an update.",
        SharedConfig and "knit Services folder not found" or "Shared.Config not found")
    return
end

---@return Instance?  RF/RE under a Knit service, found by name when the service moved; nil if renamed
local function Remote(service, kind, name)
    local remote = Wait(Wait(Wait(KnitServices, service), kind), name)
    if remote then return remote end
    for _, node in ipairs(KnitServices:GetDescendants()) do
        if node.Name == name and node.Parent and node.Parent.Name == kind then return node end
    end
    return nil
end

xDTaraZ.GameLib = {}
local GameLib = xDTaraZ.GameLib

---@return boolean, any  ok and module, required from a fresh identity-2 thread
function GameLib.RequireAsGame(module)
    if GameLib.CanSwitch == false or not State.Alive or Library.Unloaded then return false, nil end

    local done, ok, loaded = false, false, nil
    task.spawn(function()
        if not State.Alive or Library.Unloaded then done = true return end
        local switched = pcall(setthreadidentity, 2)
        local read, identity = pcall(getthreadidentity)
        if switched and read and identity == 2 then
            ok, loaded = pcall(require, module)
        else
            GameLib.CanSwitch = false
        end
        done = true
    end)
    local deadline = osClock() + Config.LoadTimeout
    while not done and State.Alive and not Library.Unloaded and osClock() < deadline do task.wait() end
    if not State.Alive or Library.Unloaded then return false, nil end
    return ok, loaded
end

---@return any?  module, nil when it is missing or no identity can require it
function GameLib.Require(module)
    if not State.Alive or Library.Unloaded or not (module and module:IsA("ModuleScript")) then return nil end
    local ok, loaded = pcall(require, module)
    if not State.Alive or Library.Unloaded then return nil end
    if ok then return loaded end
    local retried, again = GameLib.RequireAsGame(module)
    if retried then return again end
    warn("[BuildThePyramid] require " .. module.Name .. ":", loaded)
    return nil
end

do
    local modules = {
        Pyramid = Wait(SharedConfig, "PyramidConfig"),
        Carry = Wait(SharedConfig, "CarryConfig"),
        Upgrades = Wait(SharedConfig, "UpgradeCatalog"),
        Gym = Wait(SharedConfig, "GymConfig"),
        Codes = Wait(SharedConfig, "CodesConfig"),
        Completion = Wait(SharedConfig, "PyramidCompletionConfig"),
        GymAccess = Wait(Wait(Shared, "Gym"), "GymAccess"),
        Runtime = Wait(Wait(Shared, "Placement"), "PyramidRuntime"),
        CarryState = Wait(Wait(Shared, "Books"), "CarryState"),
        Regions = Wait(Shared, "RegionRegistry"),
        Knit = Wait(Wait(ReplicatedStorage, "Packages"), "Knit"),
        Progression = Wait(Wait(Shared, "Stats"), "StatProgression"),
    }
    for key, module in pairs(modules) do
        GameLib[key] = GameLib.Require(module)
    end
end

if not State.Alive or Library.Unloaded then return end

GameLib.Pickup = Remote("BookService", "RF", "Pickup")
GameLib.Place = Remote("PyramidService", "RF", "Place")
GameLib.Purchase = Remote("DataService", "RF", "PurchaseUpgrade")
GameLib.StartBench = Remote("GymService", "RF", "StartBench")
GameLib.StopBench = Remote("GymService", "RF", "StopBench")
GameLib.Redeem = Remote("CodesService", "RF", "Redeem")
GameLib.Activity = Remote("AFKService", "RE", "Activity")
GameLib.SpendBlocks = Remote("PyramidService", "RF", "SpendBankedBlocks")
GameLib.SpendSeconds = Remote("PyramidService", "RF", "SpendBankedSeconds")
GameLib.GiftClaim = Remote("FreeGiftService", "RF", "Claim")
GameLib.GiftStep = Remote("FreeGiftService", "RF", "MarkStep")

if not State.Alive or Library.Unloaded then return end

xDTaraZ.UpgradeByName = {}
xDTaraZ.UpgradeNames = {}
do
    for _, upgrade in ipairs(GameLib.Upgrades and GameLib.Upgrades.Upgrades or {}) do
        xDTaraZ.UpgradeByName[upgrade.DisplayName] = upgrade
        table.insert(xDTaraZ.UpgradeNames, upgrade.DisplayName)
    end
end

xDTaraZ.CodeList = {}
do
    local seen = {}
    local function Add(code)
        if seen[code] then return end
        seen[code] = true
        xDTaraZ.CodeList[#xDTaraZ.CodeList + 1] = code
    end
    for code in pairs(GameLib.Codes and GameLib.Codes.Codes or {}) do Add(code) end
    for _, code in ipairs(Config.ExtraCodes) do Add(code) end
end

xDTaraZ.Gate = {
    Needs = {
        AutoFarm = { "Pyramid", "Carry", "CarryState", "Runtime", "Regions", "Upgrades", "Pickup", "Place" },
        AutoStrength = { "Gym", "GymAccess", "StartBench", "StopBench" },
        AutoSpeed = { "Gym", "GymAccess" },
        AutoPool = { "Pyramid", "Completion" },
        AutoUpgrade = { "Upgrades", "Purchase", "Knit" },
    },
}

---@return string?  first game module or remote the option needs that was not found
function xDTaraZ.Gate.Missing(idx)
    for _, key in ipairs(xDTaraZ.Gate.Needs[idx] or {}) do
        if GameLib[key] == nil then return key end
    end
    return nil
end

function xDTaraZ.Gate.Ready(idx)
    return xDTaraZ.Gate.Missing(idx) == nil
end

function xDTaraZ.Format(n)
    n = tonumber(n) or 0
    local units = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local i = 1
    while math.abs(n) >= 1000 and i < #units do
        n /= 1000
        i += 1
    end
    return (i == 1 and "%d%s" or "%.2f%s"):format(n, units[i])
end

function xDTaraZ:Notify(msg)
    table.insert(self.State.Messages, msg)
end

function xDTaraZ:Character()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp and hum.Health > 0) then return nil end
    return char, hum, hrp
end

function xDTaraZ:Invoke(remote, ...)
    if not remote then return false, "missing remote" end
    local packed = table.pack(pcall(remote.InvokeServer, remote, ...))
    if not packed[1] then
        warn("[BuildThePyramid]", remote.Name, packed[2])
        return false, packed[2]
    end
    return table.unpack(packed, 2, packed.n)
end

xDTaraZ.Game = {}

function xDTaraZ.Game.Attr(name)
    return LocalPlayer:GetAttribute(name)
end

function xDTaraZ.Game.UpgradeLevel(upgrade)
    return tonumber(LocalPlayer:GetAttribute(GameLib.Upgrades.AttributePrefix .. upgrade.Attribute)) or 0
end

function xDTaraZ.Game.Capacity()
    local base = GameLib.Carry and tonumber(GameLib.Carry.Capacity) or 0
    return base + (tonumber(xDTaraZ.Game.Attr("StrengthLevel")) or 0)
end

function xDTaraZ.Game.Carried()
    if State.Carry then return State.Carry end
    if GameLib.CarryState then
        local ok, state = pcall(GameLib.CarryState.read, LocalPlayer)
        local count = ok and type(state) == "table" and tonumber(state.count)
        if count then return count end
    end
    return tonumber(xDTaraZ.Game.Attr("CarriedCount")) or 0
end

function xDTaraZ.Game.Coins()
    return tonumber(State.Stats.Coins) or 0
end

function xDTaraZ.Game.Benching()
    if not GameLib.Gym then return nil end
    local station = xDTaraZ.Game.Attr(GameLib.Gym.BenchStationAttribute)
    return type(station) == "string" and station ~= "" and station or nil
end

function xDTaraZ.Game.Model()
    return Workspace:FindFirstChild(GameLib.Pyramid.ModelName)
end

---@return boolean  completion window running (pool is open)
function xDTaraZ.Game.Completed()
    local model = xDTaraZ.Game.Model()
    if not model then return false end
    if model:GetAttribute(GameLib.Pyramid.CompleteAttribute) == true then return true end
    local endsAt = tonumber(model:GetAttribute(GameLib.Completion.CompletionEndsAtAttribute)) or 0
    return endsAt > Workspace:GetServerTimeNow()
end

---@param carryState any  "revision:count:..." string from a Pickup/Place reply
---@return number?         blocks held, nil when the reply carries no state
function xDTaraZ.Game.ReadCarry(carryState)
    if type(carryState) ~= "string" then return nil end
    local ok, decoded = pcall(GameLib.CarryState.decode, carryState)
    return ok and type(decoded) == "table" and tonumber(decoded.count) or nil
end

function xDTaraZ.Game.WatchStats()
    local ok, err = pcall(function()
        GameLib.Knit.OnStart():await()
        if not State.Alive or Library.Unloaded then return end
        local prop = GameLib.Knit.GetService("DataService").StatValues
        local conn = prop:Observe(function(values)
            if type(values) ~= "table" then return end
            local before = tonumber(State.Stats.Coins)
            local now = tonumber(values.Coins)
            if before and now and now > before then table.insert(State.CoinLog, { osClock(), now - before }) end
            State.Stats = values
        end)
        table.insert(State.Connections, conn)
    end)
    if not ok then warn("[BuildThePyramid] stats:", err) end
end

xDTaraZ.Move = {}

---@param pos Vector3  streams the area in the background, gives up after Config.StreamWait
function xDTaraZ.Move.Stream(pos)
    local finished = false
    task.spawn(function()
        pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, pos, Config.StreamWait)
        finished = true
    end)
    local deadline = osClock() + Config.StreamWait
    while not finished and osClock() < deadline do task.wait() end
end

---Holds the camera script off for two frames so a long jump does not make the game's held-item shield query an out-of-range radius.
function xDTaraZ.Move.FreezeCamera()
    local camera = Workspace.CurrentCamera
    if not camera or camera.CameraType ~= Enum.CameraType.Custom then return end
    camera.CameraType = Enum.CameraType.Scriptable
    task.spawn(function()
        RunService.RenderStepped:Wait()
        RunService.RenderStepped:Wait()
        if camera.CameraType == Enum.CameraType.Scriptable then camera.CameraType = Enum.CameraType.Custom end
    end)
end

---@param stream boolean?  ask the engine to load the destination first (far targets only)
function xDTaraZ.Move.To(pos, stream)
    local _, _, hrp = xDTaraZ:Character()
    if not hrp then return false end
    if stream and (hrp.Position - pos).Magnitude > Config.StreamDistance then xDTaraZ.Move.Stream(pos) end
    hrp.AssemblyLinearVelocity = Vector3.zero
    local freezeCamera = (hrp.Position - pos).Magnitude > Config.CameraShieldJump
    if freezeCamera then xDTaraZ.Move.FreezeCamera() end
    hrp.CFrame = CFrame.new(pos) * hrp.CFrame.Rotation
    return true
end

function xDTaraZ.Move.Near(pos, radius)
    local _, _, hrp = xDTaraZ:Character()
    return hrp ~= nil and (hrp.Position - pos).Magnitude <= (radius or Config.StandRadius)
end

---@param jitter boolean?  pick a random spot inside the region instead of its centre
function xDTaraZ.Move.QuarrySpot(jitter)
    local region = GameLib.Regions.getPart("Quarry")
    if not (region and region:IsA("BasePart")) then return Config.QuarrySpot end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character, region, Workspace:FindFirstChild(GameLib.Pyramid.QuarryFolderName) }

    local top = region.Position + vector3New(0, region.Size.Y / 2, 0)
    if jitter then
        local spread = Config.QuarryJitter
        top += region.CFrame:VectorToWorldSpace(vector3New(
            (math.random() * 2 - 1) * region.Size.X * spread, 0, (math.random() * 2 - 1) * region.Size.Z * spread))
    end
    local hit = Workspace:Raycast(top, vector3New(0, -region.Size.Y - 50, 0), params)
    local spot = hit and hit.Position + vector3New(0, Config.StandHeight, 0)
    if spot and GameLib.Regions.isWithin("Quarry", spot) then return spot end
    return Config.QuarrySpot
end

function xDTaraZ.Move.GymPart(folder, model, part)
    local gym = Workspace:FindFirstChild(GameLib.Gym.GymFolderName)
    local station = gym and gym:FindFirstChild(folder)
    local machine = station and station:FindFirstChild(model)
    local found = machine and machine:FindFirstChild(part)
    return found and found:IsA("BasePart") and found or nil
end

function xDTaraZ.Move.PoolSpot()
    local display = Workspace:FindFirstChild(GameLib.Completion.CompletedDisplayName)
    local hitbox = display and display:FindFirstChild(GameLib.Completion.PoolHitboxName)
    return hitbox and hitbox:IsA("BasePart") and hitbox.Position or nil
end

function xDTaraZ.Move.Frame()
    local char, hum, hrp = xDTaraZ:Character()
    if not char then return end
    if State.Opt.SpeedOn and not State.Opt.Fly and hum.MoveDirection.Magnitude > 0 then
        local velocity = hrp.AssemblyLinearVelocity
        local speed = math.max(State.Opt.WalkSpeed, hum.WalkSpeed)
        hrp.AssemblyLinearVelocity = vector3New(hum.MoveDirection.X * speed, velocity.Y, hum.MoveDirection.Z * speed)
    end
    if State.Opt.Noclip then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                State.Collided[part] = true
                part.CanCollide = false
            end
        end
    end
    if not State.Opt.Fly then return end
    local cam = Workspace.CurrentCamera
    local dir = hum.MoveDirection
    local lift = cam and dir.Magnitude > 0 and cam.CFrame.LookVector.Y * dir.Magnitude or 0
    hum.PlatformStand = true
    hrp.AssemblyLinearVelocity = (dir + vector3New(0, lift, 0)) * State.Opt.FlySpeed
end

function xDTaraZ.Move.Refresh()
    local opt = State.Opt
    local want = opt.Fly or opt.Noclip or opt.SpeedOn
    if want and #State.MoveConns == 0 then
        State.Collided = State.Collided or {}
        table.insert(State.MoveConns, RunService.Stepped:Connect(xDTaraZ.Move.Frame))
    elseif not want then
        for _, conn in ipairs(State.MoveConns) do conn:Disconnect() end
        table.clear(State.MoveConns)
    end
    if not opt.Noclip and State.Collided then
        for part in pairs(State.Collided) do
            if part.Parent then part.CanCollide = true end
        end
        table.clear(State.Collided)
    end
    local _, hum = xDTaraZ:Character()
    if hum and not opt.Fly and hum.PlatformStand then hum.PlatformStand = false end
end

xDTaraZ.Farm = {}

function xDTaraZ.Farm.Progress()
    State.StallSince, State.Backoff = nil, nil
end

---@param reason string  shown while the farm waits; raised once the stall passes Config.StallLimit
---@return boolean       always false, so lower jobs get the character meanwhile
function xDTaraZ.Farm.Hold(reason)
    local now = osClock()
    State.StallSince = State.StallSince or now
    if now - State.StallSince > Config.StallLimit then
        State.Waiting = nil
        error(reason:lower() .. " for " .. Config.StallLimit .. "s", 0)
    end
    State.Backoff = State.Backoff and math.min(State.Backoff * 2, Config.RetryMax) or Config.RetryDelay
    State.FarmWait = now + State.Backoff
    State.Waiting = reason .. ", retrying"
    return false
end

---@return boolean  the server had you flagged AFK and was told you are back
function xDTaraZ.Farm.Wake()
    if xDTaraZ.Game.Attr("IsAFK") ~= true or not GameLib.Activity then return false end
    GameLib.Activity:FireServer()
    return true
end

function xDTaraZ.Farm.Park()
    if State.Parked then return end
    State.Parked = true
    xDTaraZ.Move.To(xDTaraZ.Move.QuarrySpot())
end

---@param calls number  pickups fired in the same frame; the server stops granting at capacity
---@return number       blocks carried after the batch
function xDTaraZ.Farm.GrabAll(region, calls)
    local pending, carried, granted = calls, xDTaraZ.Game.Carried(), false
    for _ = 1, calls do
        task.spawn(function()
            local ok, carryState = xDTaraZ:Invoke(GameLib.Pickup, region)
            if ok == true then
                granted = true
                carried = math.max(carried, xDTaraZ.Game.ReadCarry(carryState) or 0)
            end
            pending -= 1
        end)
    end
    local deadline = osClock() + Config.PickupTimeout
    while pending > 0 and osClock() < deadline do task.wait() end
    if granted then
        State.Carry = carried
        xDTaraZ.Farm.Progress()
    end
    return carried
end

---@return boolean, string?  holding at least one block, else why not
function xDTaraZ.Farm.Gather()
    if xDTaraZ.Game.Benching() then xDTaraZ:Invoke(GameLib.StopBench) end
    local cap = xDTaraZ.Game.Capacity()
    if xDTaraZ.Game.Carried() >= cap then return true end

    State.Status = "Picking up blocks"
    if not xDTaraZ.Move.To(xDTaraZ.Move.QuarrySpot(State.Backoff ~= nil)) then return false, "Character not ready" end
    task.wait(Config.SettleDelay)

    local region = GameLib.Regions.getPart("Quarry")
    local grant = 1 + xDTaraZ.Game.UpgradeLevel(GameLib.Upgrades.ById.bulkPickup)
    local carried = xDTaraZ.Farm.GrabAll(region, math.ceil((cap - xDTaraZ.Game.Carried()) / grant) + Config.PickupRetries)
    if carried > 0 then return true end

    State.Carry = nil
    if xDTaraZ.Game.Carried() > 0 then return true end
    if xDTaraZ.Farm.Wake() then return false, "Marked AFK, waking up" end
    return false, "Quarry refused blocks"
end

---@return table?  geometry of the tier being built, same one the slot resolver uses
function xDTaraZ.Farm.Geometry()
    local context = GameLib.Runtime.getContext(Workspace)
    return context and context.geometry
end

---@param cells number  ring count wanted
---@return number       ring count whose stud radius stays inside the engine's spatial query limit
function xDTaraZ.Farm.ClampCells(cells)
    return math.min(cells, math.floor(Config.EngineRadiusLimit / GameLib.Pyramid.BlockSize))
end

---@return number  rings that reach every cell of the current layer
function xDTaraZ.Farm.SearchCells()
    local geometry = xDTaraZ.Farm.Geometry()
    local layer = GameLib.Runtime.getCurrentLayer(Workspace)
    local side = geometry and layer and geometry.getLayerSide(layer) or Config.SlotSearchCells
    return xDTaraZ.Farm.ClampCells(math.min(side, Config.SlotSearchCells))
end

---@param from Vector3  used until the first block lands
---@return table?        free slot on the current layer, searched from the last placed block
function xDTaraZ.Farm.FirstSlot(from)
    return GameLib.Runtime.resolveNearestSlot(State.LastSlot or from, Workspace, nil, xDTaraZ.Farm.SearchCells())
end

---@param origin Vector3  where the character stands
---@param count number     slots wanted
---@return table[]         free slots in reach, far enough apart that bulk fills do not overlap
function xDTaraZ.Farm.Slots(origin, count, radius)
    local picked, cells, rejected = {}, {}, {}
    local geometry = xDTaraZ.Farm.Geometry()
    if not geometry then return picked end
    local function Skip(layer, index)
        if rejected[layer .. ":" .. index] then return true end
        local col, row = geometry.fromSlotIndex(layer, index)
        if not (col and row) then return false end
        for _, cell in ipairs(cells) do
            if cell.layer == layer and math.max(math.abs(cell.col - col), math.abs(cell.row - row)) < Config.SlotSpacing then
                return true
            end
        end
        return false
    end
    for _ = 1, count * 3 do
        if #picked >= count then break end
        local slot = GameLib.Runtime.resolveNearestSlot(origin, Workspace, Skip, xDTaraZ.Farm.ClampCells(radius))
        if not slot then break end
        local flat = vector3New(slot.position.X - origin.X, 0, slot.position.Z - origin.Z)
        local col, row = geometry.fromSlotIndex(slot.layer, slot.slotIndex)
        if col and row and flat.Magnitude <= State.Opt.PlaceReach then
            table.insert(cells, { layer = slot.layer, col = col, row = row })
            table.insert(picked, slot)
        else
            rejected[slot.layer .. ":" .. slot.slotIndex] = true
        end
    end
    return picked
end

---@return number  blocks still carried
function xDTaraZ.Farm.PlaceBatch(slots)
    local pending, left, known = #slots, xDTaraZ.Game.Carried(), false
    for _, slot in ipairs(slots) do
        task.spawn(function()
            local ok, carryState = xDTaraZ:Invoke(GameLib.Place, slot.layer, slot.slotIndex, slot.generation)
            if ok == true then
                State.Placed += 1
                State.LastSlot = slot.position
            end
            local count = xDTaraZ.Game.ReadCarry(carryState)
            if count then left, known = math.min(left, count), true end
            pending -= 1
        end)
    end

    local deadline = osClock() + Config.PlaceTimeout
    while pending > 0 and osClock() < deadline do task.wait() end
    State.Carry = known and left or nil
    return xDTaraZ.Game.Carried()
end

---@return boolean, string?  placed at least one block (or nothing left to place), else why not
function xDTaraZ.Farm.Deliver()
    local _, _, hrp = xDTaraZ:Character()
    if not hrp then return false, "Character not ready" end
    local perPlace = 1 + xDTaraZ.Game.UpgradeLevel(GameLib.Upgrades.ById.bulkPlace)
    local before, why = State.Placed, "Pyramid refused blocks"

    for _ = 1, Config.PlaceRetries do
        local carried = xDTaraZ.Game.Carried()
        if carried <= 0 or not State.Opt.AutoFarm then return true end
        local first = xDTaraZ.Farm.FirstSlot(hrp.Position)
        if not first then
            why = "No free slot on the pyramid"
            break
        end

        State.Status = ("Placing on layer %d"):format(first.layer)
        local stand = first.position + vector3New(0, Config.HoverHeight, 0)
        xDTaraZ.Move.To(stand)
        local arrived = osClock()

        local reach = math.ceil(State.Opt.PlaceReach / GameLib.Pyramid.BlockSize)
        local slots = xDTaraZ.Farm.Slots(stand, math.ceil(carried / perPlace), reach)
        local remaining = Config.SettleDelay - (osClock() - arrived)
        if remaining > 0 then task.wait(remaining) end
        if #slots == 0 then
            why = "No free slot on the pyramid"
            break
        end
        if xDTaraZ.Farm.PlaceBatch(slots) <= 0 then break end
    end

    if State.Placed == before then return false, why end
    xDTaraZ.Farm.Progress()
    return true
end

---@return boolean  did work this tick
function xDTaraZ.Farm.Step()
    if osClock() < State.FarmWait then return false end
    if not GameLib.Runtime.getCurrentLayer(Workspace) then
        xDTaraZ.Farm.Progress()
        State.Waiting = "Waiting for the next pyramid"
        xDTaraZ.Farm.Park()
        return false
    end

    State.Waiting, State.Parked = nil, false
    if not State.FarmOrigin then
        local _, _, hrp = xDTaraZ:Character()
        State.FarmOrigin = hrp and hrp.CFrame
    end
    local holding, why = xDTaraZ.Farm.Gather()
    if not holding then return xDTaraZ.Farm.Hold(why) end

    local placed, reason = xDTaraZ.Farm.Deliver()
    if placed then return true end
    return xDTaraZ.Farm.Hold(reason)
end

function xDTaraZ.Farm.Stop()
    local origin = State.FarmOrigin
    State.FarmOrigin, State.Waiting, State.Parked, State.FarmWait = nil, nil, false, 0
    xDTaraZ.Farm.Progress()
    if not (origin and State.Opt.ReturnOnStop) then return end
    local _, _, hrp = xDTaraZ:Character()
    if hrp then hrp.CFrame = origin end
end

xDTaraZ.Train = {}

function xDTaraZ.Train.HasAccess(folder)
    local access = GameLib.Gym.Access[folder]
    if not access then return false end
    local owned = GameLib.GymAccess.purchasedFromAttribute(xDTaraZ.Game.Attr(GameLib.Gym.GymUnlocksAttribute), folder)
        or GameLib.GymAccess.ownsGamePass(LocalPlayer, access.ProductKey)
    local done = tonumber(xDTaraZ.Game.Attr("Pyramids")) or 0
    return GameLib.GymAccess.hasAccess(access, done, owned)
end

---@param stations table  GymConfig station list
---@return string?        gym folder with the highest multiplier you can use
function xDTaraZ.Train.Best(stations, key)
    local best, bestMult
    for _, station in ipairs(stations) do
        if xDTaraZ.Train.HasAccess(station.GymFolder) and (not bestMult or station[key] > bestMult) then
            best, bestMult = station.GymFolder, station[key]
        end
    end
    return best, bestMult
end

---@param chosen string  dropdown value, "Best Unlocked" or a gym folder
---@return string?       the chosen gym when you can use it, else the best one you can
function xDTaraZ.Train.Pick(stations, key, chosen)
    for _, station in ipairs(stations) do
        if station.GymFolder == chosen and xDTaraZ.Train.HasAccess(station.GymFolder) then
            return station.GymFolder, station[key]
        end
    end
    return xDTaraZ.Train.Best(stations, key)
end

---@param value number  current Strength value
---@return number       value that reaches the next Strength level
function xDTaraZ.Train.NextLevelValue(value)
    local progression = GameLib.Progression
    local base = progression.levelForValue(value)
    local low, high = value, math.max(value * 2, value + Config.LevelProbe)
    while high - low > 1 do
        local mid = math.floor((low + high) / 2)
        if progression.levelForValue(mid) > base then high = mid else low = mid end
    end
    return high
end

---@return number?  Strength per second gained on the bench so far, nil until it has run long enough
function xDTaraZ.Train.MeasuredRate(value, now)
    if not xDTaraZ.Game.Benching() then
        State.BenchRef = nil
        return State.BenchRate
    end
    local ref = State.BenchRef
    if not ref then
        State.BenchRef = { at = now, value = value }
        return State.BenchRate
    end
    if now - ref.at >= Config.RateSample and value > ref.value then
        State.BenchRate = (value - ref.value) / (now - ref.at)
        State.BenchRef = { at = now, value = value }
    end
    return State.BenchRate
end

---@return boolean  the next Strength level pays back its training time inside the payback time
function xDTaraZ.Train.Worth()
    local now = osClock()
    local cached = State.SmartCache
    if cached and now - cached.at < Config.SmartRefresh then return cached.worth end

    local worth = false
    local value = tonumber(State.Stats.Strength)
    local _, mult = xDTaraZ.Train.Pick(GameLib.Gym.BenchpressStations, "StrengthMultiplier", State.Opt.BenchStation)
    if GameLib.Progression and value and mult then
        local rate = xDTaraZ.Train.MeasuredRate(value, now) or Config.BenchBase * mult
        local seconds = (xDTaraZ.Train.NextLevelValue(value) - value) / rate
        worth = seconds * xDTaraZ.Game.Capacity() < State.Opt.SmartMinutes * 60
    end
    State.SmartCache = { at = now, worth = worth }
    return worth
end

function xDTaraZ.Train.Strength()
    local folder, mult = xDTaraZ.Train.Pick(GameLib.Gym.BenchpressStations, "StrengthMultiplier", State.Opt.BenchStation)
    if not folder then return false end
    State.Status = ("Bench press x%d"):format(mult)
    local current = xDTaraZ.Game.Benching()
    if current == folder then return true end
    if current then xDTaraZ:Invoke(GameLib.StopBench) end

    if osClock() - (State.Last.BenchTry or 0) < Config.BenchRetry then return true end
    State.Last.BenchTry = osClock()

    local seat = xDTaraZ.Move.GymPart(folder, GameLib.Gym.BenchpressModelName, GameLib.Gym.AlignPartName)
    if not seat then return false end
    if not xDTaraZ.Move.Near(seat.Position, Config.BenchRange) then
        xDTaraZ.Move.To(seat.Position + vector3New(0, Config.StandHeight, 0))
        task.wait(Config.SettleDelay)
    end
    local ok = xDTaraZ:Invoke(GameLib.StartBench, folder)
    if not ok then State.Status = "Bench refused, retrying" end
    return true
end

function xDTaraZ.Train.Speed()
    local folder, mult = xDTaraZ.Train.Pick(GameLib.Gym.TreadmillStations, "SpeedMultiplier", State.Opt.TreadmillStation)
    local hitbox = folder and xDTaraZ.Move.GymPart(folder, GameLib.Gym.TreadmillModelName, GameLib.Gym.HitboxName)
    if not hitbox then return false end
    if xDTaraZ.Game.Benching() then xDTaraZ:Invoke(GameLib.StopBench) end
    State.Status = ("Treadmill x%d"):format(mult)
    if not xDTaraZ.Move.Near(hitbox.Position) then xDTaraZ.Move.To(hitbox.Position) end
    return true
end

function xDTaraZ.Train.Step()
    local opt = State.Opt
    if opt.Priority == "Balanced" and opt.AutoStrength then return xDTaraZ.Train.Strength() end
    if opt.AutoStrength and opt.AutoSpeed then
        local str = tonumber(xDTaraZ.Game.Attr("StrengthLevel")) or 0
        local spd = tonumber(xDTaraZ.Game.Attr("SpeedLevel")) or 0
        if spd < str then return xDTaraZ.Train.Speed() end
        return xDTaraZ.Train.Strength()
    end
    if opt.AutoStrength then return xDTaraZ.Train.Strength() end
    if opt.AutoSpeed then return xDTaraZ.Train.Speed() end
    return false
end

function xDTaraZ.Train.Leave()
    if xDTaraZ.Game.Benching() then xDTaraZ:Invoke(GameLib.StopBench) end
end

function xDTaraZ.Train.Pool()
    if not xDTaraZ.Game.Completed() then return false end
    local spot = xDTaraZ.Move.PoolSpot()
    if not spot then return false end
    if xDTaraZ.Game.Benching() then xDTaraZ:Invoke(GameLib.StopBench) end
    State.Status = "Training in the pool"
    if not xDTaraZ.Move.Near(spot) then xDTaraZ.Move.To(spot) end
    return true
end

xDTaraZ.Tasks = {}

function xDTaraZ.Tasks.Order()
    local opt = State.Opt
    local order = {}
    if opt.AutoPool then table.insert(order, "Pool") end
    local trainFirst = opt.Priority == "Train"
    if opt.Priority == "Balanced" then trainFirst = opt.AutoStrength and xDTaraZ.Train.Worth() end
    if opt.Priority == "Alternate" then
        local slice = math.floor(osClock() / (opt.AlternateMinutes * 60))
        trainFirst = slice % 2 == 1
    end
    if trainFirst then
        order[#order + 1] = "Train"
        order[#order + 1] = "Farm"
    else
        order[#order + 1] = "Farm"
        order[#order + 1] = "Train"
    end
    return order
end

xDTaraZ.Tasks.Jobs = {
    Pool = { On = function() return State.Opt.AutoPool end, Step = xDTaraZ.Train.Pool },
    Farm = { On = function() return State.Opt.AutoFarm end, Step = xDTaraZ.Farm.Step },
    Train = { On = function() return State.Opt.AutoStrength or State.Opt.AutoSpeed end, Step = xDTaraZ.Train.Step },
}

function xDTaraZ.Tasks.Step()
    for _, name in ipairs(xDTaraZ.Tasks.Order()) do
        local job = xDTaraZ.Tasks.Jobs[name]
        if not job.On() or State.Halted[name] then continue end
        local ok, worked = pcall(job.Step)
        if not ok then
            xDTaraZ.Scheduler.Fail(name, worked)
            return
        end
        State.Fails[name], State.FailSince[name] = nil, nil
        if worked then
            State.Task = name
            return
        end
    end
    State.Task = "None"
    State.Status = State.Opt.AutoFarm and State.Waiting or "Idle"
end

xDTaraZ.Upgrade = {}

---@param budget number  coins free to spend
---@return table?, number?, boolean?  best upgrade you can afford, its cost, true when waiting for a better one is faster
function xDTaraZ.Upgrade.PickByValue(budget)
    local income = State.CoinRate or 0
    for _, id in ipairs(Config.UpgradePriority) do
        for _, upgrade in pairs(xDTaraZ.UpgradeByName) do
            if upgrade.Id ~= id or not State.Opt.Upgrades[upgrade.DisplayName] then continue end
            local cost = upgrade.Costs[xDTaraZ.Game.UpgradeLevel(upgrade) + 1]
            if not cost then continue end
            if cost <= budget then return upgrade, cost end
            if income > 0 and (cost - budget) / income <= Config.SaveSeconds then return nil, nil, true end
        end
    end
    return nil
end

---@return table?, number?  wanted upgrade to buy next by the chosen order, and its cost
function xDTaraZ.Upgrade.Pick()
    local budget = xDTaraZ.Game.Coins() - State.Opt.KeepCoins
    if State.Opt.UpgradeOrder == "Best Value" then
        local upgrade, cost, saving = xDTaraZ.Upgrade.PickByValue(budget)
        if upgrade or saving then return upgrade, cost end
    end
    local pick, pickCost
    for _, name in ipairs(xDTaraZ.UpgradeNames) do
        local upgrade = xDTaraZ.UpgradeByName[name]
        if not State.Opt.Upgrades[name] then continue end
        local cost = upgrade.Costs[xDTaraZ.Game.UpgradeLevel(upgrade) + 1]
        if not cost or cost > budget then continue end
        if State.Opt.UpgradeOrder == "In Order" then return upgrade, cost end
        if not pickCost or cost < pickCost then pick, pickCost = upgrade, cost end
    end
    return pick, pickCost
end

function xDTaraZ.Upgrade.Buy(upgrade, cost)
    local level = xDTaraZ.Game.UpgradeLevel(upgrade) + 1
    local reply = xDTaraZ:Invoke(GameLib.Purchase, upgrade.Id)
    if not (type(reply) == "table" and reply.ok == true) then return false end
    xDTaraZ:Notify(("Bought %s %d"):format(upgrade.DisplayName, level))
    local coins = tonumber(State.Stats.Coins)
    if coins then State.Stats.Coins = tostring(coins - cost) end
    return true
end

function xDTaraZ.Upgrade.Step()
    local upgrade, cost = xDTaraZ.Upgrade.Pick()
    if upgrade then xDTaraZ.Upgrade.Buy(upgrade, cost) end
end

function xDTaraZ.Upgrade.Now()
    local bought = 0
    repeat
        local upgrade, cost = xDTaraZ.Upgrade.Pick()
        if not (upgrade and xDTaraZ.Upgrade.Buy(upgrade, cost)) then break end
        bought += 1
        task.wait(Config.UpgradeGap)
    until bought >= Config.UpgradeBurst
    if bought == 0 then xDTaraZ:Notify("Nothing to buy") end
end

xDTaraZ.Codes = {}

function xDTaraZ.Codes.RedeemAll()
    local got = 0
    for _, code in ipairs(xDTaraZ.CodeList) do
        local reply = xDTaraZ:Invoke(GameLib.Redeem, code)
        if type(reply) == "table" and reply.ok then
            got += 1
            xDTaraZ:Notify(code .. ": redeemed")
        else
            xDTaraZ:Notify(("%s: %s"):format(code, type(reply) == "table" and tostring(reply.reason) or "no reply"))
        end
        task.wait(Config.CodeGap)
    end
    xDTaraZ:Notify(("Codes done, %d new"):format(got))
end

xDTaraZ.Bank = {}

function xDTaraZ.Bank.Spend()
    local spent = 0
    for _, entry in ipairs({ { GameLib.SpendBlocks, "banked blocks" }, { GameLib.SpendSeconds, "banked time" } }) do
        local ok, reason = xDTaraZ:Invoke(entry[1])
        if ok == true then
            spent += 1
            xDTaraZ:Notify(entry[2] .. " spent")
        elseif reason == "NothingBanked" or reason == "PyramidComplete" then
            xDTaraZ:Notify(("%s: %s"):format(entry[2], reason == "NothingBanked" and "none to spend" or "wait for the next pyramid"))
        end
    end
    return spent
end

function xDTaraZ.Bank.FreeGift()
    for _, step in ipairs({ "liked", "favorited" }) do
        xDTaraZ:Invoke(GameLib.GiftStep, step)
    end
    local reply, reason = xDTaraZ:Invoke(GameLib.GiftClaim)
    if reply == true or (type(reply) == "table" and reply.ok) then
        xDTaraZ:Notify("Free gift claimed")
    else
        local text = type(reply) == "table" and tostring(reply.reason) or tostring(reason)
        xDTaraZ:Notify(text == "GroupRequired" and "Join the Janitors Studios group to claim the free gift" or ("Free gift: " .. text))
    end
end

xDTaraZ.Teleport = {}

function xDTaraZ.Teleport.Quarry()
    xDTaraZ.Move.To(xDTaraZ.Move.QuarrySpot())
end

function xDTaraZ.Teleport.Pyramid()
    local _, _, hrp = xDTaraZ:Character()
    if not hrp then return end
    local slot = xDTaraZ.Farm.FirstSlot(hrp.Position)
    if slot then
        xDTaraZ.Move.To(slot.position + vector3New(0, Config.HoverHeight, 0))
        return
    end
    local model = xDTaraZ.Game.Model()
    if model then xDTaraZ.Move.To(model:GetPivot().Position + vector3New(0, Config.HoverHeight, 0)) end
end

function xDTaraZ.Teleport.Pool()
    local spot = xDTaraZ.Move.PoolSpot()
    if not spot then
        xDTaraZ:Notify(xDTaraZ.Game.Completed() and "Pool is not loaded yet, try again in a moment" or "Pool opens when a pyramid is completed")
        return
    end
    xDTaraZ.Move.To(spot, true)
end

function xDTaraZ.Teleport.Gym()
    local folder = State.GymTarget
    local seat = folder and xDTaraZ.Move.GymPart(folder, GameLib.Gym.BenchpressModelName, GameLib.Gym.AlignPartName)
    local belt = folder and xDTaraZ.Move.GymPart(folder, GameLib.Gym.TreadmillModelName, GameLib.Gym.HitboxName)
    local target = seat or belt
    if target then xDTaraZ.Move.To(target.Position + vector3New(0, Config.StandHeight, 0)) end
end

function xDTaraZ.Teleport.Player()
    local target = State.PlayerTarget and Players:FindFirstChild(State.PlayerTarget)
    local root = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        xDTaraZ:Notify("Player not found")
        return
    end
    xDTaraZ.Move.To(root.Position + vector3New(0, Config.StandHeight, 0), true)
end

xDTaraZ.Server = {}

function xDTaraZ.Server.Rejoin()
    if #Players:GetPlayers() > 1 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    else
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

function xDTaraZ.Server.Hop()
    local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100"):format(game.PlaceId)
    local body = xDTaraZ.Util.HttpGet(url)
    local ok, page = pcall(HttpService.JSONDecode, HttpService, body or "")
    if not (ok and type(page) == "table" and page.data) then
        xDTaraZ:Notify("Server list unavailable")
        return
    end
    local options = {}
    for _, server in ipairs(page.data) do
        if server.id ~= game.JobId and (server.playing or 0) < (server.maxPlayers or 0) then
            table.insert(options, server.id)
        end
    end
    if #options == 0 then
        xDTaraZ:Notify("No other server found")
        return
    end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, options[math.random(#options)], LocalPlayer)
end

function xDTaraZ.Server.Boost()
    local saved = State.Boosted
    if not saved then
        saved = { Shadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd, Effects = {}, Materials = {} }
        State.Boosted = saved
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e6

    local plastic, smooth = Enum.Material.Plastic, Enum.Material.SmoothPlastic
    for _, inst in ipairs(Workspace:GetDescendants()) do
        if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke") or inst:IsA("Fire") then
            if not inst.Enabled then continue end
            saved.Effects[inst] = true
            inst.Enabled = false
        elseif inst:IsA("BasePart") and inst.Material ~= plastic and inst.Material ~= smooth then
            saved.Materials[inst] = inst.Material
            inst.Material = smooth
        end
    end
    xDTaraZ:Notify("FPS boost applied")
end

function xDTaraZ.Server.Unboost()
    local saved = State.Boosted
    if not saved then return end
    State.Boosted = nil
    Lighting.GlobalShadows, Lighting.FogEnd = saved.Shadows, saved.FogEnd
    for inst in pairs(saved.Effects) do
        if inst.Parent then inst.Enabled = true end
    end
    for part, material in pairs(saved.Materials) do
        if part.Parent then part.Material = material end
    end
end

xDTaraZ.Client = {}

function xDTaraZ.Client.Bind()
    table.insert(State.Connections, LocalPlayer.Idled:Connect(function()
        if not State.Opt.AntiAfk then return end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end))

    table.insert(State.Connections, UserInputService.JumpRequest:Connect(function()
        if not State.Opt.InfJump then return end
        local _, hum = xDTaraZ:Character()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end))

    table.insert(State.Connections, LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid", Config.LoadTimeout)
        if State.Collided then table.clear(State.Collided) end
    end))

    table.insert(State.Connections, GuiService.ErrorMessageChanged:Connect(function()
        if not State.Opt.AutoRejoin or State.Rejoining or GuiService:GetErrorMessage() == "" then return end
        State.Rejoining = true
        if not xDTaraZ.Util.QueueReload() then warn("[BuildThePyramid] auto rejoin: this executor cannot reload the hub after teleport") end
        task.wait(Config.RejoinDelay)
        if not State.Alive or Library.Unloaded then return end
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end))
end

xDTaraZ.Scheduler = {}

xDTaraZ.Scheduler.RequestHandlers = {
    Movement = xDTaraZ.Move.Refresh,
    FarmStop = xDTaraZ.Farm.Stop,
    TrainStop = xDTaraZ.Train.Leave,
    UpgradeNow = xDTaraZ.Upgrade.Now,
    CodesNow = xDTaraZ.Codes.RedeemAll,
    BankNow = xDTaraZ.Bank.Spend,
    GiftNow = xDTaraZ.Bank.FreeGift,
    TpQuarry = xDTaraZ.Teleport.Quarry,
    TpPyramid = xDTaraZ.Teleport.Pyramid,
    TpPool = xDTaraZ.Teleport.Pool,
    TpGym = xDTaraZ.Teleport.Gym,
    TpPlayer = xDTaraZ.Teleport.Player,
    Rejoin = xDTaraZ.Server.Rejoin,
    Hop = xDTaraZ.Server.Hop,
    Boost = xDTaraZ.Server.Boost,
}

xDTaraZ.Scheduler.Toggles = {
    Farm = { "AutoFarm" },
    Train = { "AutoStrength", "AutoSpeed" },
    Pool = { "AutoPool" },
    Upgrade = { "AutoUpgrade" },
    Activity = { "AntiAfk" },
    Summary = {},
}

---@param key string?  job name; repeated failures stop it and switch its toggles off
function xDTaraZ.Scheduler.Run(fn, key)
    if key and State.Halted[key] then return end
    local ok, err = pcall(fn)
    if ok then
        if key then State.Fails[key], State.FailSince[key] = nil, nil end
        return
    end
    if key then
        xDTaraZ.Scheduler.Fail(key, err)
    else
        warn("[BuildThePyramid]", err)
    end
end

---@return boolean  one of the job's toggles is on; core jobs have none
function xDTaraZ.Scheduler.Wanted(key)
    for _, idx in ipairs(xDTaraZ.Scheduler.Toggles[key] or {}) do
        if State.Opt[idx] == true then return true end
    end
    return false
end

function xDTaraZ.Scheduler.Fail(key, err)
    local fails = (State.Fails[key] or 0) + 1
    State.Fails[key] = fails
    State.FailSince[key] = State.FailSince[key] or osClock()
    if fails == 1 then warn("[BuildThePyramid] " .. key .. " failing:", err) end

    if fails < Config.FailLimit or osClock() - State.FailSince[key] < Config.FailWindow then return end
    if not xDTaraZ.Scheduler.Wanted(key) then return end
    State.Halted[key] = true
    for _, idx in ipairs(xDTaraZ.Scheduler.Toggles[key] or {}) do State.Opt[idx] = false end
    table.insert(State.HaltQueue, { key, tostring(err):match("^[^\n]*") })
end

function xDTaraZ.Scheduler.Resume(idx)
    for key, toggles in pairs(xDTaraZ.Scheduler.Toggles) do
        if table.find(toggles, idx) then
            State.Halted[key], State.Fails[key], State.FailSince[key] = nil, nil, nil
        end
    end
end

function xDTaraZ.Scheduler.RunOnce(name, fn)
    if State.Running[name] then return end
    State.Running[name] = true
    task.spawn(function()
        xDTaraZ.Scheduler.Run(fn)
        State.Running[name] = nil
    end)
end

function xDTaraZ.Scheduler.Every(key, interval, fn)
    if osClock() - (State.Last[key] or 0) < interval then return end
    State.Last[key] = osClock()
    xDTaraZ.Scheduler.Run(fn, key)
end

function xDTaraZ.Scheduler.Summarize()
    local cutoff = osClock() - Config.RateWindow
    local recent = 0
    for i = #State.CoinLog, 1, -1 do
        local entry = State.CoinLog[i]
        if entry[1] < cutoff then table.remove(State.CoinLog, i) else recent += entry[2] end
    end
    State.CoinRate = recent / Config.RateWindow
    local carried, cap = xDTaraZ.Game.Carried(), xDTaraZ.Game.Capacity()
    State.Summary = ("Coins %s · %s/min\nStrength Lv %s · Speed Lv %s · Carry %d/%d\nPyramids %s · Placed %d"):format(
        xDTaraZ.Format(State.Stats.Coins), xDTaraZ.Format(recent * 60 / Config.RateWindow),
        tostring(xDTaraZ.Game.Attr("StrengthLevel") or 0), tostring(xDTaraZ.Game.Attr("SpeedLevel") or 0),
        carried, cap, tostring(xDTaraZ.Game.Attr("Pyramids") or 0), State.Placed)
end

function xDTaraZ.Scheduler.Step()
    local opt = State.Opt
    xDTaraZ.Scheduler.Run(xDTaraZ.Scheduler.Summarize, "Summary")

    for name, handler in pairs(xDTaraZ.Scheduler.RequestHandlers) do
        if State.Requests[name] then
            State.Requests[name] = nil
            if Config.SlowRequests[name] then
                xDTaraZ.Scheduler.RunOnce(name, handler)
            else
                xDTaraZ.Scheduler.Run(handler)
            end
        end
    end

    if opt.AntiAfk and GameLib.Activity then
        xDTaraZ.Scheduler.Every("Activity", Config.ActivityInterval, function() GameLib.Activity:FireServer() end)
    end
    if opt.AutoUpgrade then xDTaraZ.Scheduler.Every("Upgrade", Config.UpgradeInterval, xDTaraZ.Upgrade.Step) end

    local _, hum = xDTaraZ:Character()
    if not hum then return end
    xDTaraZ.Scheduler.Run(xDTaraZ.Tasks.Step)
end

function xDTaraZ.Scheduler.Boot()
    if not State.Alive or Library.Unloaded then return end
    xDTaraZ.Client.Bind()
    task.defer(function()
        if not State.Alive or Library.Unloaded then return end
        xDTaraZ.Game.WatchStats()
        while State.Alive and not Library.Unloaded do
            xDTaraZ.Scheduler.Step()
            task.wait(Config.TickDelay)
        end
    end)
end

function xDTaraZ.Scheduler.Stop()
    State.Alive = false
    for _, conn in ipairs(State.Connections) do conn:Disconnect() end
    table.clear(State.Connections)
    local opt = State.Opt
    opt.AutoFarm, opt.AutoStrength, opt.AutoSpeed, opt.AutoPool, opt.AutoUpgrade = false, false, false, false, false
    opt.SpeedOn, opt.Fly, opt.Noclip = false, false, false
    xDTaraZ.Move.Refresh()
    RunService:Set3dRenderingEnabled(true)
    xDTaraZ.Util.Try("fps boost restore", xDTaraZ.Server.Unboost)
end

	if not State.Alive or Library.Unloaded then return end
	Library:OnUnload(xDTaraZ.Scheduler.Stop)
	Library:OnUnload(function()
		pcall(xDTaraZ.Farm.Stop)
		pcall(xDTaraZ.Train.Leave)
	end)

	-- Shared ErrorScripts controls. The engine above is copied from the owner's Mario Hub.
	local Window = Library:CreateWindow({ Title = "ErrorScripts", GameName = "Build The Pyramid" })
	local Tabs = {
		Info = Window:AddTab("Info"),
		Main = Window:AddTab("Main"),
		Training = Window:AddTab("Training"),
		Shop = Window:AddTab("Shop"),
		Player = Window:AddTab("Player"),
		Settings = Window:AddTab("Settings"),
	}
	local opt = State.Opt
	local function notify(text)
		Library:Notify(text)
	end
	local function request(name)
		return function()
			if State.Alive and not Library.Unloaded then State.Requests[name] = true end
		end
	end
	local function toggle(group, key, text, onChange)
		return group:AddToggle(key, {
			Text = text,
			Default = opt[key] == true,
			Callback = function(value)
				if value and not xDTaraZ.Gate.Ready(key) then
					opt[key] = false
					local control = Library.Toggles[key]
					if control and control.Value then control:SetValue(false) end
					notify("This feature needs a game update: " .. tostring(xDTaraZ.Gate.Missing(key)))
					return
				end
				opt[key] = value
				if value then xDTaraZ.Scheduler.Resume(key) end
				if onChange then onChange(value) end
			end,
		})
	end
	local function stationLabels(stations, multiplier)
		local result = { "Best Unlocked" }
		for _, station in ipairs(stations or {}) do
			result[#result + 1] = ("Gym %s (x%d)"):format(station.GymFolder, station[multiplier])
		end
		return result
	end
	local function stationPick(key)
		return function(value)
			opt[key] = value and value:match("^Gym (%S+)") or "Best Unlocked"
		end
	end
	local function playerNames()
		local result = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then result[#result + 1] = player.Name end
		end
		table.sort(result)
		return result
	end
	local profile = Tabs.Info:AddLeftGroupbox("User")
	profile:AddPlayerInfo("ErrorScriptsPyramidProfile", { Player = LocalPlayer })
	local status = Tabs.Info:AddLeftGroupbox("Session")
	local taskLabel = status:AddLabel("Idle")
	local coinsLabel = status:AddLabel("Coins: 0")
	local strengthLabel = status:AddLabel("Strength level: 0")
	local speedLabel = status:AddLabel("Speed level: 0")
	local carryLabel = status:AddLabel("Carrying: 0 / 0")
	local pyramidsLabel = status:AddLabel("Pyramids: 0")
	local placedLabel = status:AddLabel("Blocks placed: 0")
	local notes = Tabs.Info:AddRightGroupbox("Build The Pyramid")
	notes:AddLabel("Farm, train and upgrade in one menu.")
	notes:AddLabel("Start automation from the farming tab.")

	local farm = Tabs.Main:AddLeftGroupbox("Auto Farm")
	toggle(farm, "AutoFarm", "Auto Farm", function(value)
		if not value then State.Requests.FarmStop = true end
	end)
	toggle(farm, "ReturnOnStop", "Return On Stop")
	farm:AddSlider("PlaceReach", {
		Text = "Place Distance", Min = 16, Max = 36, Default = opt.PlaceReach, Rounding = 0,
		Callback = function(value) opt.PlaceReach = tonumber(value) or 30 end,
	})
	farm:AddButton("Spend Banked Blocks", request("BankNow"))
	local priority = Tabs.Main:AddRightGroupbox("Farm vs Training")
	priority:AddDropdown("Priority", {
		Text = "When Both Are On", Values = { "Balanced", "Farm", "Train", "Alternate" }, Default = "Balanced",
		Callback = function(value) opt.Priority = value or "Balanced" end,
	})
	priority:AddSlider("SmartMinutes", {
		Text = "Payback Time (min)", Min = 5, Max = 240, Default = opt.SmartMinutes, Rounding = 0,
		Callback = function(value) opt.SmartMinutes = tonumber(value) or 30 end,
	})
	priority:AddSlider("AlternateMinutes", {
		Text = "Alternate Every (min)", Min = 1, Max = 30, Default = opt.AlternateMinutes, Rounding = 0,
		Callback = function(value) opt.AlternateMinutes = tonumber(value) or 5 end,
	})
	priority:AddLabel("Balanced trains when the extra blocks pay it back.")

	local gym = Tabs.Training:AddLeftGroupbox("Gym")
	toggle(gym, "AutoStrength", "Auto Train Strength", function(value)
		if not value then State.Requests.TrainStop = true end
	end)
	toggle(gym, "AutoSpeed", "Auto Train Speed")
	local gymConfig = GameLib.Gym or {}
	gym:AddDropdown("BenchStationPick", {
		Text = "Bench Gym", Values = stationLabels(gymConfig.BenchpressStations, "StrengthMultiplier"),
		Default = "Best Unlocked", Callback = stationPick("BenchStation"),
	})
	gym:AddDropdown("TreadmillStationPick", {
		Text = "Treadmill Gym", Values = stationLabels(gymConfig.TreadmillStations, "SpeedMultiplier"),
		Default = "Best Unlocked", Callback = stationPick("TreadmillStation"),
	})
	local pool = Tabs.Training:AddRightGroupbox("Waters of Nu")
	toggle(pool, "AutoPool", "Auto Join Pool")
	pool:AddButton("Go To Pool", request("TpPool"))

	local upgrades = Tabs.Shop:AddLeftGroupbox("Upgrades")
	toggle(upgrades, "AutoUpgrade", "Auto Upgrade")
	opt.Upgrades = {}
	for _, name in ipairs(xDTaraZ.UpgradeNames) do opt.Upgrades[name] = true end
	upgrades:AddDropdown("Upgrades", {
		Text = "Upgrades", Values = xDTaraZ.UpgradeNames, Multi = true, Default = xDTaraZ.UpgradeNames,
		Callback = function(selected) opt.Upgrades = selected or {} end,
	})
	upgrades:AddButton("Buy Now", request("UpgradeNow"))
	local spending = Tabs.Shop:AddRightGroupbox("Spending")
	spending:AddDropdown("UpgradeOrder", {
		Text = "Order", Values = { "Best Value", "Cheapest First", "In Order" }, Default = "Best Value",
		Callback = function(value) opt.UpgradeOrder = value or "Best Value" end,
	})
	spending:AddSlider("KeepCoins", {
		Text = "Keep Coins", Min = 0, Max = 1000000, Default = 0, Rounding = 0,
		Callback = function(value) opt.KeepCoins = tonumber(value) or 0 end,
	})
	local codes = Tabs.Shop:AddRightGroupbox("Codes")
	codes:AddButton("Redeem All Codes", request("CodesNow"))
	codes:AddButton("Claim Free Gift", request("GiftNow"))

	local function movementKey(group, toggleId, optionId, text)
		local picker = group:AddLabel(text):AddKeyPicker(optionId, { Default = "None", Mode = "Toggle" })
		table.insert(State.Connections, UserInputService.InputBegan:Connect(function(input, processed)
			if processed or Library.Unloaded or Library._capturingKey or Library._skipToggle or UserInputService:GetFocusedTextBox() then return end
			if picker.Value == "None" or input.KeyCode == Enum.KeyCode.Unknown then return end
			if input.KeyCode.Name == picker.Value then
				local control = Library.Toggles[toggleId]
				if control then control:SetValue(not control.Value) end
			end
		end))
	end
	local movement = Tabs.Player:AddLeftGroupbox("Movement")
	toggle(movement, "SpeedOn", "Speed", request("Movement"))
	movementKey(movement, "SpeedOn", "SpeedOnKey", "Speed key")
	movement:AddSlider("WalkSpeed", {
		Text = "Walk Speed", Min = 16, Max = 200, Default = opt.WalkSpeed, Rounding = 0,
		Callback = function(value) opt.WalkSpeed = tonumber(value) or 100 end,
	})
	toggle(movement, "Fly", "Fly", request("Movement"))
	movementKey(movement, "Fly", "FlyKey", "Fly key")
	movement:AddSlider("FlySpeed", {
		Text = "Fly Speed", Min = 10, Max = 200, Default = opt.FlySpeed, Rounding = 0,
		Callback = function(value) opt.FlySpeed = tonumber(value) or 60 end,
	})
	toggle(movement, "Noclip", "Noclip", request("Movement"))
	movementKey(movement, "Noclip", "NoclipKey", "Noclip key")
	toggle(movement, "InfJump", "Infinite Jump")
	local teleport = Tabs.Player:AddRightGroupbox("Teleport")
	teleport:AddButton("Quarry", request("TpQuarry"))
	teleport:AddButton("Pyramid", request("TpPyramid"))
	teleport:AddButton("Pool", request("TpPool"))
	local gymValues = {}
	for _, station in ipairs(gymConfig.BenchpressStations or {}) do
		gymValues[#gymValues + 1] = ("Gym %s (x%d)"):format(station.GymFolder, station.StrengthMultiplier)
	end
	teleport:AddDropdown("GymTarget", {
		Text = "Gym", Values = gymValues, Default = gymValues[1],
		Callback = function(value) State.GymTarget = value and value:match("^Gym (%S+)") end,
	})
	teleport:AddButton("Go To Gym", request("TpGym"))
	local players = teleport:AddDropdown("PlayerTarget", {
		Text = "Player", Values = playerNames(), AllowNull = true,
		Callback = function(value) State.PlayerTarget = value end,
	})
	teleport:AddButton("Refresh Players", function() players:SetValues(playerNames()) end)
	teleport:AddButton("Go To Player", request("TpPlayer"))

	local session = Tabs.Settings:AddLeftGroupbox("Game session")
	toggle(session, "AntiAfk", "Anti AFK")
	toggle(session, "AutoRejoin", "Auto Rejoin")
	toggle(session, "NoRender", "Disable 3D Rendering", function(value)
		RunService:Set3dRenderingEnabled(not value)
	end)
	session:AddButton("FPS Boost", request("Boost"))
	session:AddButton("Restore graphics", function() xDTaraZ.Server.Unboost() end)
	Theme:SetLibrary(Library)
	Save:SetLibrary(Library)
	Save:SetFolder("ErrorScripts/BuildThePyramid")
	Theme:ApplyToTab(Tabs.Settings)
	Save:BuildConfigSection(Tabs.Settings)
	local function live()
		while State.Alive and not Library.Unloaded do
			while #State.Messages > 0 do notify(table.remove(State.Messages, 1)) end
			while #State.HaltQueue > 0 do
				local key, reason = table.unpack(table.remove(State.HaltQueue, 1))
				for _, id in ipairs(xDTaraZ.Scheduler.Toggles[key] or {}) do
					local control = Library.Toggles[id]
					if control and control.Value then control:SetValue(false) end
				end
				notify(key .. " stopped: " .. reason)
			end
			taskLabel:SetText(State.Task == "None" and State.Status or ("%s: %s"):format(State.Task, State.Status))
			coinsLabel:SetText("Coins: " .. xDTaraZ.Format(State.Stats.Coins) .. " | " .. xDTaraZ.Format((State.CoinRate or 0) * 60) .. "/min")
			strengthLabel:SetText("Strength level: " .. tostring(xDTaraZ.Game.Attr("StrengthLevel") or 0))
			speedLabel:SetText("Speed level: " .. tostring(xDTaraZ.Game.Attr("SpeedLevel") or 0))
			carryLabel:SetText(("Carrying: %d / %d"):format(xDTaraZ.Game.Carried(), xDTaraZ.Game.Capacity()))
			pyramidsLabel:SetText("Pyramids: " .. tostring(xDTaraZ.Game.Attr("Pyramids") or 0))
			placedLabel:SetText("Blocks placed: " .. tostring(State.Placed))
			task.wait(1)
		end
	end
	xDTaraZ.Util.Try("boot", xDTaraZ.Scheduler.Boot)
	task.spawn(function() xDTaraZ.Util.Try("live status", live) end)
	return { Window = Window, Settings = Tabs.Settings, State = State, Engine = xDTaraZ }
end


local function ErrorScriptsEgg(Library, Theme, Save)
    -- Called by the hub only after successful Vampauth validation.
    if Library.Unloaded then return end
    if game.GameId ~= 10765288803 then error("Wrong universe for Break and Steal an Egg") end
    local eggJit = type(LPH_JIT) == "function" and LPH_JIT or function(fn) return fn end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local osClock = os.clock
local vector3New, cframeNew = Vector3.new, CFrame.new

local xDTaraZ = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(self, key, type(value) == "function" and eggJit(value) or value)
    end,
})

xDTaraZ.Config = {
    SaveFolder = "ErrorScripts/BreakStealEgg",
    LoadTimeout = 30,
    RequireTimeout = 3,
    MaxFailures = 5,
    FailWindow = 10,
    AlertTries = 20,
    AlertDelay = 0.5,
    TickDelay = 0.05,
    TpSettle = 0.2,
    GrabTimeout = 2,
    CarryGrace = 2.5,
    StandRadius = 6,
    SpeedFallback = 120,
    SkipFor = 4,
    BankTimeout = 2.5,
    HitSlice = 1.2,
    TripCost = 1,
    EggOffset = vector3New(0, 3, 3.5),
    PromptMatch = 30,
    BreakPickupRadius = 40,
    EquipInterval = 2,
    BuyInterval = 1.5,
    ClaimInterval = 31,
    EggInterval = 5,
    EggSpacing = 8,
    SellInterval = 4,
    EspInterval = 0.4,
    BatRange = 15,
    BatGap = 0.72,
    RejoinDelay = 5,
}

xDTaraZ.State = {
    Alive = true,
    Connections = {},
    Requests = {},
    Messages = {},
    Failures = {},
    Halted = {},
    Last = {},
    Status = "Idle",
    Steals = 0,
    Broken = 0,
    Banked = 0,
    StartCash = nil,
    StartAt = osClock(),
    HitTokens = 3,
    HitStamp = osClock(),
    BreakSpot = nil,
    Opt = {
        AutoSteal = false,
        Take = "Upgrades Only",
        StealRarities = {},
        StealMinValue = 0,
        AutoBreak = false,
        BreakZone = "Best",
        MaxHits = 40,
        RobCarriers = false,
        AutoPlace = false,
        AutoSell = false,
        KeepRarities = {},
        AutoUpgrade = false,
        UpgradeTargets = { Pickaxe = true, Base = true, Trail = true, Treadmill = true },
        AutoBuyPickaxe = false,
        AutoUpgradePlot = false,
        AutoTrail = false,
        AutoTreadmill = false,
        CashReserve = 0,
        AutoClaim = false,
        AutoHatch = false,
        BatTarget = nil,
        BatLoop = false,
        BatAura = false,
        EspPickups = false,
        EspEggs = false,
        EspPlayers = false,
        EspMinRarity = "Common",
        SpeedOn = false,
        WalkSpeed = xDTaraZ.Config.SpeedFallback,
        InfJump = false,
        Noclip = false,
        AntiAfk = false,
        AutoRejoin = false,
    },
}

local Config, State = xDTaraZ.Config, xDTaraZ.State
-- Register cancellation and restoration before the first yielding dependency.
Library:OnUnload(function()
    State.Alive = false
    for prompt in pairs(State.HeldPrompts or {}) do pcall(prompt.InputHoldEnd, prompt) end
    State.HeldPrompts = nil
    if xDTaraZ.Scheduler and xDTaraZ.Scheduler.Stop then
        xDTaraZ.Util.Try("stop", xDTaraZ.Scheduler.Stop)
    end
end)
local function active() return State.Alive and not Library.Unloaded end
local Shared = ReplicatedStorage:WaitForChild("Shared", Config.LoadTimeout)
if not active() then return end

xDTaraZ.GameLib = {
    Remote = setmetatable({}, {
        __index = function(self, name)
            local remote = ReplicatedStorage:FindFirstChild(name)
            if not remote then
                local nested = ReplicatedStorage:FindFirstChild(name, true)
                remote = nested and (nested:IsA("BaseRemoteEvent") or nested:IsA("RemoteFunction")) and nested or nil
            end
            if remote then rawset(self, name, remote) end
            return remote
        end,
    }),
}

---@return boolean, any  ok + module, retried from an identity-2 thread when the executor can really switch
function xDTaraZ.GameLib.RequireAsGame(module)
    local done, ok, loaded = false, false, nil
    task.spawn(function()
        if not active() then done = true; return end
        pcall(setthreadidentity, 2)
        local read, identity = pcall(getthreadidentity)
        if read and identity == 2 then
            ok, loaded = pcall(require, module)
        end
        done = true
    end)
    local deadline = osClock() + Config.RequireTimeout
    while active() and not done and osClock() < deadline do
        task.wait()
    end
    if not active() then return false, nil end
    return ok, loaded
end

---@param name string  module under ReplicatedStorage.Shared
---@return table?      nil when it is missing or this executor can't require it
function xDTaraZ.GameLib.Require(name)
    if not active() then return nil end
    local module = Shared and Shared:FindFirstChild(name)
    if not module then
        local nested = Shared and Shared:FindFirstChild(name, true)
        module = nested and nested:IsA("ModuleScript") and nested or nil
    end
    if not module then
        warn("[BreakStealEgg] missing game module", name)
        return nil
    end
    local ok, loaded = pcall(require, module)
    if not active() then return nil end
    if ok then return loaded end
    local okAgain, again = xDTaraZ.GameLib.RequireAsGame(module)
    if okAgain then return again end
    warn("[BreakStealEgg] require", name, loaded)
    return nil
end

local GameLib = xDTaraZ.GameLib

do
    local modules = {
        Eggs = "EggConfig", Rewards = "EggRewards", Rarity = "EggRarity", Pickaxe = "PickaxeConfig", Zones = "ZonesConfig",
        Plot = "PlotUpgradeConfig", Treadmill = "TreadmillUpgradeConfig", Trails = "TrailsConfig", Bat = "BatConfig", Speed = "SpeedConfig",
    }
    for key, name in pairs(modules) do
        GameLib[key] = GameLib.Require(name)
        if not active() then return end
    end
    State.Opt.WalkSpeed = GameLib.Speed and GameLib.Speed.MaxWalkSpeed or Config.SpeedFallback
end

GameLib.Needs = {
    AutoSteal = { "Rewards" },
    AutoBreak = { "Pickaxe", "Eggs", "Rewards", "Remote.EggHitRequest" },
    RobCarriers = { "Bat", "Remote.BatHitRequest" },
    AutoPlace = { "Remote.PetsInventoryRemote" },
    AutoSell = { "Rewards", "Remote.BackpackSellRemote" },
    AutoClaim = { "Remote.IndexRemote", "Remote.OfflineRewardRemote" },
    AutoHatch = { "Remote.MergeMachineRemote" },
    AutoBuyPickaxe = { "Pickaxe" },
    AutoUpgradePlot = { "Plot" },
    AutoTrail = { "Trails" },
    AutoTreadmill = { "Treadmill" },
    SpeedOn = { "Speed" },
    EspEggs = { "Pickaxe" },
    BatLoop = { "Bat", "Remote.BatHitRequest" },
    BatAura = { "Bat", "Remote.BatHitRequest" },
}

---@return string?  first module ("Rewards") or remote ("Remote.EggHitRequest") the feature needs that is gone
function GameLib.Missing(idx)
    for _, key in ipairs(GameLib.Needs[idx] or {}) do
        local node = GameLib
        for part in key:gmatch("[^.]+") do
            node = type(node) == "table" and node[part] or nil
        end
        if node == nil then return key end
    end
    return nil
end

xDTaraZ.RarityLadder = GameLib.Rarity and GameLib.Rarity.Ladder() or {}
xDTaraZ.RarityRank = {}
do
    for i, name in ipairs(xDTaraZ.RarityLadder) do
        xDTaraZ.RarityRank[name] = i
    end
end

xDTaraZ.ZoneList = {}
do
    for index, zone in pairs(GameLib.Zones and GameLib.Zones.Zones or {}) do
        table.insert(xDTaraZ.ZoneList, { Index = index, Name = zone.Name or ("Zone" .. index), Rarity = zone.Rarity, Power = zone.RequiredPower or 0 })
    end
    table.sort(xDTaraZ.ZoneList, function(a, b) return a.Index < b.Index end)
end

xDTaraZ.ZonePool = {}
do
    for _, entry in ipairs(GameLib.Rewards and GameLib.Rewards.Pool or {}) do
        local zone = entry.Zone
        if not zone then continue end
        xDTaraZ.ZonePool[zone] = xDTaraZ.ZonePool[zone] or {}
        table.insert(xDTaraZ.ZonePool[zone], { Name = entry.Name, Chance = entry.Chance or 1 })
    end
end

function xDTaraZ.Format(n)
    n = tonumber(n) or 0
    local units = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }
    local i = 1
    while math.abs(n) >= 1000 and i < #units do
        n /= 1000
        i += 1
    end
    return (i == 1 and "%d%s" or "%.2f%s"):format(n, units[i])
end

function xDTaraZ:Notify(msg)
    if not active() then return end
    table.insert(State.Messages, msg)
end

xDTaraZ.Util = {}

function xDTaraZ.Util.Alert(text, detail)
    if not active() then return end
    warn("[ErrorScripts/BreakStealEgg]", text, detail or "")
    Library:Notify(text)
end

---@return boolean, any  pcall result, warns with the label when it fails
function xDTaraZ.Util.Try(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn("[BreakStealEgg] " .. label .. ":", err) end
    return ok, err
end

function xDTaraZ:Character()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp and hum.Health > 0) then return nil end
    return char, hum, hrp
end

function xDTaraZ:Connect(signal, handler)
    if not active() then return nil end
    local conn = signal:Connect(function(...)
        if active() then handler(...) end
    end)
    if not active() then conn:Disconnect(); return nil end
    table.insert(State.Connections, conn)
    return conn
end

function xDTaraZ:Fire(name, ...)
    if not active() then return end
    local remote = GameLib.Remote[name]
    if remote then remote:FireServer(...) end
end

function xDTaraZ.Attr(name, fallback)
    local value = LocalPlayer:GetAttribute(name)
    if value == nil then return fallback end
    return value
end

function xDTaraZ.Spendable()
    return xDTaraZ.Attr("Cash", 0) - (State.Opt.CashReserve or 0)
end

xDTaraZ.Move = {}

function xDTaraZ.Move.To(cf)
    if not active() then return false end
    local _, _, hrp = xDTaraZ:Character()
    if not hrp then return false end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.CFrame = cf
    return true
end

---@return number  speed the game itself gives the player now, never lower than what SpeedPower earns
function xDTaraZ.Move.NaturalSpeed()
    local earned = GameLib.Speed and GameLib.Speed.SpeedPowerToWalkSpeed(xDTaraZ.Attr("SpeedPower", 0)) or 0
    return math.max(State.NaturalSpeed or 0, earned)
end

function xDTaraZ.Move.ApplySpeed()
    local _, hum = xDTaraZ:Character()
    if not hum then return end
    if State.Opt.SpeedOn then
        if not State.SpeedWritten then State.NaturalSpeed = hum.WalkSpeed end
        State.SpeedWritten = math.max(State.Opt.WalkSpeed, xDTaraZ.Move.NaturalSpeed())
        hum.WalkSpeed = State.SpeedWritten
    elseif State.SpeedWritten then
        State.SpeedWritten = nil
        hum.WalkSpeed = xDTaraZ.Move.NaturalSpeed()
    end
end

function xDTaraZ.Move.HoldSpeed(hum)
    if not active() then return end
    if State.SpeedConn then State.SpeedConn:Disconnect(); State.SpeedConn = nil end
    local previous = State.SpeedHumanoid
    if previous and State.SpeedWritten then
        local natural = xDTaraZ.Move.NaturalSpeed()
        pcall(function() previous.WalkSpeed = natural end)
    end
    State.SpeedHumanoid = hum
    State.NaturalSpeed = hum.WalkSpeed
    State.SpeedWritten = nil
    State.SpeedConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if not active() or hum.WalkSpeed == State.SpeedWritten then return end
        State.NaturalSpeed = hum.WalkSpeed
        if State.Opt.SpeedOn then xDTaraZ.Move.ApplySpeed() end
    end)
end

function xDTaraZ.Move.SetNoclip(on)
    if not on then
        for part, value in pairs(State.NoclipParts or {}) do
            pcall(function() part.CanCollide = value end)
        end
        State.NoclipParts = nil
        return
    end
    if not active() then return end
    local char = LocalPlayer.Character
    if not char then return end
    State.NoclipParts = State.NoclipParts or {}
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.CanCollide then
            State.NoclipParts[part] = part.CanCollide
            part.CanCollide = false
        end
    end
end

xDTaraZ.Base = {}

function xDTaraZ.Base.Own()
    local cached = State.Plot
    if cached and cached.Parent and cached:GetAttribute("OwnerUserId") == LocalPlayer.UserId then return cached end
    local plots = Workspace:FindFirstChild("Plots")
    for _, plot in ipairs(plots and plots:GetChildren() or {}) do
        if plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            State.Plot = plot
            return plot
        end
    end
    return nil
end

function xDTaraZ.Base.Hitbox()
    local plot = xDTaraZ.Base.Own()
    if not plot then return nil end
    local cached = State.Hitbox
    if cached and cached[1] == plot and cached[2]:IsDescendantOf(plot) then return cached[2] end

    local hitbox = plot:FindFirstChild("Hitbox", true)
    State.Hitbox = hitbox and { plot, hitbox } or nil
    return hitbox
end

function xDTaraZ.Base.Home()
    local hitbox = xDTaraZ.Base.Hitbox()
    if hitbox then xDTaraZ.Move.To(hitbox.CFrame + vector3New(0, 2, 0)) end
end

---@return number  cash/s an animal must beat to be worth taking
function xDTaraZ.Base.Floor()
    if State.Opt.Take == "Everything" then return -1 end
    return xDTaraZ.Base.Weakest()
end

---@return number  weakest placed cash/s, 0 while slots are free
function xDTaraZ.Base.Weakest()
    local cached = State.FloorCache
    if cached and osClock() - cached[1] < 1 then return cached[2] end
    local plot = xDTaraZ.Base.Own()
    local placed = plot and plot:FindFirstChild("PlacedAnimals")
    local floor = 0
    if placed and #placed:GetChildren() >= (plot:GetAttribute("MaxAnimals") or math.huge) then
        floor = math.huge
        for _, animal in ipairs(placed:GetChildren()) do
            floor = math.min(floor, animal:GetAttribute("CashPerSecond") or 0)
        end
    end
    State.FloorCache = { osClock(), floor }
    return floor
end

function xDTaraZ.Base.Carry()
    return xDTaraZ.Attr("CarryCount", 0), xDTaraZ.Attr("SatchelCapacity", 1)
end

---@return boolean  true once everything carried is banked
function xDTaraZ.Base.Bank()
    if not active() then return false end
    local hitbox = xDTaraZ.Base.Hitbox()
    if not hitbox then return false end
    State.Status = "Banking"
    local before = xDTaraZ.Base.Carry()
    local deadline = osClock() + Config.BankTimeout
    repeat
        if not active() then return false end
        xDTaraZ.Move.To(hitbox.CFrame + vector3New(0, 2, 0))
        task.wait()
    until not active() or xDTaraZ.Base.Carry() == 0 or osClock() > deadline
    if not active() then return false end
    local done = xDTaraZ.Base.Carry() == 0
    if done then
        State.Banked += before
        State.BreakSpot = nil
        State.Last.Banked = osClock()
        State.Requests.Place = State.Opt.AutoPlace or nil
    end
    return done
end

xDTaraZ.Pickup = {}

---@return number  cash per second once placed
function xDTaraZ.Pickup.Value(model)
    local name = model:GetAttribute("AnimalName")
    if type(name) ~= "string" then return 0 end
    local ok, value = pcall(GameLib.Rewards.PlacedCashPerSecond, name, model:GetAttribute("SizeMult") or 1, model:GetAttribute("Mutation"), model:GetAttribute("WeightKg"), model:GetAttribute("Variant"))
    return ok and value or 0
end

function xDTaraZ.Pickup.PromptFor(model)
    local pos = model:GetPivot().Position
    local best, bestDist = nil, Config.PromptMatch
    for _, prompt in ipairs(CollectionService:GetTagged("SmartPrompt")) do
        local anchor = prompt.Name == "StealPrompt" and prompt.Parent
        if anchor and anchor:IsA("BasePart") then
            local dist = (anchor.Position - pos).Magnitude
            if dist < bestDist then best, bestDist = prompt, dist end
        end
    end
    return best
end

function xDTaraZ.Pickup.Allowed(model, value)
    local opt = State.Opt
    if next(opt.StealRarities) and not opt.StealRarities[model:GetAttribute("Rarity") or ""] then return false end
    return value >= (opt.StealMinValue or 0)
end

---@return Model?  best pickup to take next
function xDTaraZ.Pickup.Next()
    local opt = State.Opt
    local folder = Workspace:FindFirstChild("AnimalPickups")
    if not folder then return nil end
    local floor = xDTaraZ.Base.Floor()
    local best, bestValue = nil, floor
    for _, model in ipairs(folder:GetChildren()) do
        local value = xDTaraZ.Pickup.Value(model)
        if value <= bestValue or osClock() < (State.Skip and State.Skip[model] or 0) then continue end
        local fromBreak = State.BreakSpot and (model:GetPivot().Position - State.BreakSpot).Magnitude < Config.BreakPickupRadius
        if (opt.AutoSteal and xDTaraZ.Pickup.Allowed(model, value)) or (opt.AutoBreak and fromBreak) then
            best, bestValue = model, value
        end
    end
    return best
end

function xDTaraZ.Pickup.Trigger(prompt)
    if not active() then return end
    if type(fireproximityprompt) == "function" then
        fireproximityprompt(prompt)
        return
    end
    State.HeldPrompts = State.HeldPrompts or {}
    State.HeldPrompts[prompt] = true
    local ok, err = pcall(function()
        prompt:InputHoldBegin()
        local deadline = osClock() + math.max(prompt.HoldDuration or 0, 0)
        while active() and osClock() < deadline do task.wait() end
    end)
    pcall(prompt.InputHoldEnd, prompt)
    if State.HeldPrompts then State.HeldPrompts[prompt] = nil end
    if not ok and active() then error(err) end
end

---@return number  animals the other players carry right now
function xDTaraZ.Pickup.OthersCarrying()
    local total = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then total += player:GetAttribute("CarryCount") or 0 end
    end
    return total
end

---@param before number  CarryCount read before the prompt fired
---@param others number  OthersCarrying read before the prompt fired
---@return boolean       true once the satchel shows the animal; a pickup that vanished without it keeps waiting for the count unless another player picked it up
function xDTaraZ.Pickup.AwaitCarry(model, before, others)
    local fired = osClock()
    local goneAt
    repeat
        task.wait()
        if not active() then return false end
        if xDTaraZ.Base.Carry() > before then return true end
        if not model.Parent then
            goneAt = goneAt or osClock()
            if xDTaraZ.Pickup.OthersCarrying() > others then return false end
        end
    until not active() or osClock() > (goneAt and goneAt + Config.CarryGrace or fired + Config.GrabTimeout)
    return false
end

---@return boolean  true if it ended up in the satchel
function xDTaraZ.Pickup.Grab(model)
    if not active() then return false end
    local prompt = xDTaraZ.Pickup.PromptFor(model)
    State.Skip = State.Skip or setmetatable({}, { __mode = "k" })
    if not prompt then
        State.Skip[model] = osClock() + Config.SkipFor
        return false
    end
    State.Status = "Stealing " .. tostring(model:GetAttribute("AnimalName"))
    local before = xDTaraZ.Base.Carry()
    xDTaraZ.Move.To(cframeNew(prompt.Parent.Position + vector3New(0, 2, 0)))
    task.wait(Config.TpSettle)
    if not active() then return false end
    local others = xDTaraZ.Pickup.OthersCarrying()
    xDTaraZ.Pickup.Trigger(prompt)
    local got = xDTaraZ.Pickup.AwaitCarry(model, before, others)
    if not active() then return false end
    if got then State.Steals += 1 else State.Skip[model] = osClock() + Config.SkipFor end
    return got
end

xDTaraZ.Break = {}

function xDTaraZ.Break.Damage()
    return GameLib.Pickaxe.GetDamage(xDTaraZ.Attr("PickaxeTier", 1))
end

function xDTaraZ.Break.Alive(egg)
    return egg.Parent ~= nil and not egg:GetAttribute("Broken") and (egg:GetAttribute("Health") or 0) > 0
end

---@return number  average cash/s of what hatches from it
function xDTaraZ.Break.Expected(egg)
    State.EggWorth = State.EggWorth or setmetatable({}, { __mode = "k" })
    local cached = State.EggWorth[egg]
    if cached then return cached end
    local zone, weight = egg:GetAttribute("ZoneIndex"), egg:GetAttribute("WeightKg")
    local total, chances = 0, 0
    for _, entry in ipairs(xDTaraZ.ZonePool[zone] or {}) do
        local ok, value = pcall(GameLib.Rewards.PlacedCashPerSecond, entry.Name, nil, nil, weight)
        if ok then
            total += entry.Chance * value
            chances += entry.Chance
        end
    end
    local worth = chances > 0 and total / chances or 0
    State.EggWorth[egg] = worth
    return worth
end

---@return BasePart?  egg with the most cash per second spent that beats the base
function xDTaraZ.Break.Pick()
    local opt = State.Opt
    local damage = xDTaraZ.Break.Damage()
    local floor = xDTaraZ.Base.Floor()
    local burst, cooldown = GameLib.Eggs.HitBurst, GameLib.Eggs.HitCooldown
    local wantZone = opt.BreakZone ~= "Best" and tonumber(tostring(opt.BreakZone):match("%d+")) or nil
    local best, bestScore
    for _, egg in ipairs(CollectionService:GetTagged("BreakableEgg")) do
        if not xDTaraZ.Break.Alive(egg) then continue end
        if wantZone and egg:GetAttribute("ZoneIndex") ~= wantZone then continue end
        local hits = math.ceil(egg:GetAttribute("Health") / damage)
        if hits > opt.MaxHits then continue end
        local worth = xDTaraZ.Break.Expected(egg)
        if worth <= floor then continue end
        local score = worth / (math.max(hits - burst, 0) * cooldown + Config.TripCost)
        if not best or score > bestScore then best, bestScore = egg, score end
    end
    return best
end

function xDTaraZ.Break.EquipPickaxe()
    if not active() then return false end
    local char, hum = xDTaraZ:Character()
    if not char then return false end
    if char:FindFirstChild(GameLib.Pickaxe.ToolName) then return true end
    local tool = LocalPlayer.Backpack:FindFirstChild(GameLib.Pickaxe.ToolName)
    if not tool then return false end
    hum:EquipTool(tool)
    return true
end

function xDTaraZ.Break.TakeToken()
    local now = osClock()
    local cooldown = GameLib.Eggs.HitCooldown
    State.HitTokens = math.min(GameLib.Eggs.HitBurst, State.HitTokens + (now - State.HitStamp) / cooldown)
    State.HitStamp = now
    if State.HitTokens >= 1 then
        State.HitTokens -= 1
        return 0
    end
    return (1 - State.HitTokens) * cooldown
end

function xDTaraZ.Break.Hit(egg)
    if not xDTaraZ.Break.EquipPickaxe() then
        State.Status = "No pickaxe"
        return
    end
    State.Status = ("Breaking %s (Zone %s)"):format(tostring(egg:GetAttribute("EggType")), tostring(egg:GetAttribute("ZoneIndex")))
    State.BreakSpot = egg.Position
    local remote = GameLib.Remote.EggHitRequest
    local stop = osClock() + Config.HitSlice
    while active() and xDTaraZ.Break.Alive(egg) and State.Opt.AutoBreak and osClock() < stop do
        xDTaraZ.Move.To(cframeNew(egg.Position + Config.EggOffset, egg.Position))
        local waitFor
        repeat
            waitFor = xDTaraZ.Break.TakeToken()
            if waitFor > 0 then task.wait(waitFor) end
        until not active() or not State.Opt.AutoBreak or waitFor == 0
        if not active() or not State.Opt.AutoBreak then return end
        remote:FireServer(egg)
    end
    if active() and not xDTaraZ.Break.Alive(egg) then State.Broken += 1 end
end

xDTaraZ.Bat = {}

function xDTaraZ.Bat.Equip()
    if not active() then return false end
    local char, hum = xDTaraZ:Character()
    if not char then return false end
    if char:FindFirstChild(GameLib.Bat.ToolName) then return true end
    local tool = LocalPlayer.Backpack:FindFirstChild(GameLib.Bat.ToolName)
    if not tool then return false end
    hum:EquipTool(tool)
    return true
end

function xDTaraZ.Bat.RootOf(player)
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp and hum.Health > 0) then return nil end
    return hrp
end

---@return boolean  true if a swing went out
function xDTaraZ.Bat.Swing(player, approach)
    if not active() then return false end
    local target = xDTaraZ.Bat.RootOf(player)
    if not target then return false end
    if osClock() - (State.Last.Bat or 0) < Config.BatGap then return false end
    if not xDTaraZ.Bat.Equip() then return false end
    if approach then
        xDTaraZ.Move.To(target.CFrame * cframeNew(0, 0, 3))
        task.wait(Config.TpSettle)
    end
    if not active() then return false end
    State.Last.Bat = osClock()
    xDTaraZ:Fire("BatHitRequest", player)
    return true
end

function xDTaraZ.Bat.Carrier()
    local best, bestCount = nil, 0
    for _, player in ipairs(Players:GetPlayers()) do
        local count = player ~= LocalPlayer and (player:GetAttribute("CarryCount") or 0) or 0
        if count > bestCount and xDTaraZ.Bat.RootOf(player) then best, bestCount = player, count end
    end
    return best
end

function xDTaraZ.Bat.Aura()
    local _, _, hrp = xDTaraZ:Character()
    if not hrp then return end
    local range = Config.BatRange * (xDTaraZ.Attr("BatHitboxMultiplier", 1)) + GameLib.Bat.Targeting.HitTolerance
    for _, player in ipairs(Players:GetPlayers()) do
        local root = player ~= LocalPlayer and xDTaraZ.Bat.RootOf(player)
        if root and (root.Position - hrp.Position).Magnitude <= range then
            if xDTaraZ.Bat.Swing(player, false) then return end
        end
    end
end

xDTaraZ.Farm = {}

---Once every farm toggle is off: banks what is carried or walks back to where the farm picked the character up, then shows Idle.
function xDTaraZ.Farm.Stand()
    local origin = State.FarmOrigin
    if not origin then return end
    State.FarmOrigin = nil
    State.BreakSpot = nil
    local _, _, hrp = xDTaraZ:Character()
    if hrp and not (xDTaraZ.Base.Carry() > 0 and xDTaraZ.Base.Bank()) and (hrp.Position - origin.Position).Magnitude > Config.StandRadius then
        xDTaraZ.Move.To(origin)
    end
    State.Status = "Idle"
end

function xDTaraZ.Farm.Rest()
    local opt = State.Opt
    if not (opt.AutoSteal or opt.AutoBreak or opt.RobCarriers) then State.Status = "Idle" end
end

function xDTaraZ.Farm.Step()
    if not active() then return end
    local opt = State.Opt
    if not (opt.AutoSteal or opt.AutoBreak or opt.RobCarriers) then
        xDTaraZ.Farm.Stand()
        return
    end
    local _, _, hrp = xDTaraZ:Character()
    if not hrp then
        State.Status = "Waiting for respawn"
        return
    end
    State.FarmOrigin = State.FarmOrigin or hrp.CFrame

    local carry, cap = xDTaraZ.Base.Carry()
    local nextPickup = (carry < cap) and xDTaraZ.Pickup.Next() or nil
    if carry >= cap or (carry > 0 and not nextPickup) or xDTaraZ.Attr("BeingChased", false) and carry > 0 then
        xDTaraZ.Base.Bank()
        return
    end
    if nextPickup then
        xDTaraZ.Pickup.Grab(nextPickup)
        return
    end
    if opt.RobCarriers then
        local victim = xDTaraZ.Bat.Carrier()
        if victim then
            State.Status = "Robbing " .. victim.Name
            local root = xDTaraZ.Bat.RootOf(victim)
            if root then State.BreakSpot = root.Position end
            xDTaraZ.Bat.Swing(victim, true)
            return
        end
    end
    if opt.AutoBreak then
        local egg = xDTaraZ.Break.Pick()
        if egg then
            xDTaraZ.Break.Hit(egg)
            return
        end
        State.Status = "No egg beats your base yet"
        return
    end
    State.Status = "Waiting for animals better than your base"
end

xDTaraZ.Shop = {}

function xDTaraZ.Shop.Pickaxe()
    local tier = xDTaraZ.Attr("PickaxeTier", 1)
    local cash = xDTaraZ.Spendable()
    local best
    for nextTier = tier + 1, #GameLib.Pickaxe.Tiers do
        if GameLib.Pickaxe.GetPrice(nextTier) > cash then break end
        best = nextTier
    end
    if not best then return false end
    xDTaraZ:Fire("PickaxeShopRequest", "Buy", best)
    return true
end

function xDTaraZ.Shop.Plot()
    local plot = xDTaraZ.Base.Own()
    if not plot then return false end
    local cost = GameLib.Plot.UpgradeCost(plot:GetAttribute("PlotLevel") or 1)
    if not cost or cost > xDTaraZ.Spendable() then return false end
    xDTaraZ:Fire("UpgradePlotRequest")
    return true
end

function xDTaraZ.Shop.Trail()
    local owned = {}
    for id in tostring(xDTaraZ.Attr("OwnedTrails", "")):gmatch("%d+") do owned[tonumber(id)] = true end
    local pick
    for _, trail in ipairs(GameLib.Trails.Trails) do
        if not owned[trail.Id] and trail.Price <= xDTaraZ.Spendable() and (not pick or trail.Multiplier > pick.Multiplier) then pick = trail end
    end
    local equipped = xDTaraZ.Attr("EquippedTrail", 1)
    local bestOwned
    for _, trail in ipairs(GameLib.Trails.Trails) do
        if owned[trail.Id] and (not bestOwned or trail.Multiplier > bestOwned.Multiplier) then bestOwned = trail end
    end
    if pick then
        xDTaraZ:Fire("TrailShopRequest", "Buy", pick.Id)
        task.wait(0.3)
        if not active() then return false end
        xDTaraZ:Fire("TrailShopRequest", "Equip", pick.Id)
        return true
    end
    if bestOwned and bestOwned.Id ~= equipped then xDTaraZ:Fire("TrailShopRequest", "Equip", bestOwned.Id) end
    return false
end

function xDTaraZ.Shop.Treadmill()
    local plot = xDTaraZ.Base.Own()
    if not plot then return false end
    if not plot:GetAttribute("TreadmillUnlocked") then
        xDTaraZ:Fire("UnlockTreadmillRequest")
        return true
    end
    local level = plot:GetAttribute("TreadmillLevel") or 1
    if level >= GameLib.Treadmill.MaxLevel then return false end
    if GameLib.Treadmill.UpgradeCost(level) > xDTaraZ.Spendable() then return false end
    xDTaraZ:Fire("UpgradeTreadmillRequest")
    return true
end

---Dropdown entry -> the flag Shop.Step reads; order = menu order.
xDTaraZ.Shop.Targets = {
    { Key = "Pickaxe", Flag = "AutoBuyPickaxe" },
    { Key = "Base", Flag = "AutoUpgradePlot" },
    { Key = "Trail", Flag = "AutoTrail" },
    { Key = "Treadmill", Flag = "AutoTreadmill" },
}

---Turns the Auto Upgrade toggle + target dropdown into the per-shop flags; targets whose game module is missing stay off.
function xDTaraZ.Shop.Sync()
    local opt = State.Opt
    for _, target in ipairs(xDTaraZ.Shop.Targets) do
        opt[target.Flag] = opt.AutoUpgrade and opt.UpgradeTargets[target.Key] == true and not GameLib.Missing(target.Flag)
    end
end

---One pass over the picked targets, cheapest win first like Shop.Step; nil when nothing was affordable.
function xDTaraZ.Shop.Now()
    local picked = State.Opt.UpgradeTargets
    local bought = false
    if picked.Base and not GameLib.Missing("AutoUpgradePlot") and xDTaraZ.Shop.Plot() then bought = true end
    if picked.Pickaxe and not GameLib.Missing("AutoBuyPickaxe") and xDTaraZ.Shop.Pickaxe() then bought = true end
    if picked.Trail and not GameLib.Missing("AutoTrail") and xDTaraZ.Shop.Trail() then bought = true end
    if picked.Treadmill and not GameLib.Missing("AutoTreadmill") and xDTaraZ.Shop.Treadmill() then bought = true end
    if not bought then xDTaraZ:Notify("Nothing to upgrade yet: not enough cash or already maxed") end
end

function xDTaraZ.Shop.Step()
    local opt = State.Opt
    local plot = xDTaraZ.Base.Own()
    local plotCost = plot and GameLib.Plot and GameLib.Plot.UpgradeCost(plot:GetAttribute("PlotLevel") or 1) or math.huge
    local pickTier = xDTaraZ.Attr("PickaxeTier", 1)
    local pickaxes = GameLib.Pickaxe
    local pickCost = pickaxes and pickTier < #pickaxes.Tiers and pickaxes.GetPrice(pickTier + 1) or math.huge
    if opt.AutoUpgradePlot and plotCost <= pickCost and xDTaraZ.Shop.Plot() then return end
    if opt.AutoBuyPickaxe and xDTaraZ.Shop.Pickaxe() then return end
    if opt.AutoUpgradePlot and xDTaraZ.Shop.Plot() then return end
    if opt.AutoTrail and xDTaraZ.Shop.Trail() then return end
    if opt.AutoTreadmill then xDTaraZ.Shop.Treadmill() end
end

xDTaraZ.Pets = {}

function xDTaraZ.Pets.Tools()
    local list = {}
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and CollectionService:HasTag(tool, "AnimalTool") then list[#list + 1] = tool end
    end
    return list
end

function xDTaraZ.Pets.Place()
    if #xDTaraZ.Pets.Tools() == 0 then return end
    xDTaraZ:Fire("PetsInventoryRemote", "EquipBest", nil)
end

---@return number  tools sent to sell
function xDTaraZ.Pets.Sell()
    if not active() then return 0 end
    local keep = State.Opt.KeepRarities
    if State.Opt.AutoPlace and osClock() - (State.Last.Banked or 0) < Config.EquipInterval * 2 then return 0 end
    local floor = State.Opt.AutoPlace and xDTaraZ.Base.Weakest() or math.huge
    local batch = {}
    for _, tool in ipairs(xDTaraZ.Pets.Tools()) do
        if keep[tool:GetAttribute("Rarity") or ""] or xDTaraZ.Pickup.Value(tool) > floor then continue end
        batch[#batch + 1] = tool
    end
    if #batch == 0 then return 0 end
    local remote = GameLib.Remote.BackpackSellRemote
    if not remote then return 0 end
    local ok, err = pcall(remote.InvokeServer, remote, batch)
    if not ok then warn("[BreakStealEgg] sell:", err) end
    return ok and #batch or 0
end

xDTaraZ.Rewards = {}

function xDTaraZ.Rewards.Claim()
    xDTaraZ:Fire("IndexRemote", "ClaimAll", nil)
    xDTaraZ:Fire("OfflineRewardRemote", "Claim")
    if not State.GroupClaimed then
        xDTaraZ:Fire("GroupRewardRemote", "Joined")
        xDTaraZ:Fire("GroupRewardRemote", "Claim")
    end
    if not State.DiscordClaimed then xDTaraZ:Fire("DiscordRewardRemote", "Verify", LocalPlayer.Name) end
end

function xDTaraZ.Rewards.Watch()
    local function Track(remote, key)
        if not remote then return end
        xDTaraZ:Connect(remote.OnClientEvent, function(kind, info)
            if kind == "State" and type(info) == "table" and info.Claimed then State[key] = true end
        end)
        remote:FireServer("Get")
    end
    Track(GameLib.Remote.GroupRewardRemote, "GroupClaimed")
    Track(GameLib.Remote.DiscordRewardRemote, "DiscordClaimed")
end

xDTaraZ.Eggs = {}

function xDTaraZ.Eggs.Tools()
    local list = {}
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and CollectionService:HasTag(tool, "MergeEggTool") then list[#list + 1] = tool end
    end
    return list
end

---@return number  eggs that got placed or hatched
function xDTaraZ.Eggs.Step()
    if not active() then return 0 end
    local done = 0
    local now = Workspace:GetServerTimeNow()
    for _, egg in ipairs(CollectionService:GetTagged("MergeEggPlaced")) do
        if egg:GetAttribute("OwnerUserId") == LocalPlayer.UserId and (egg:GetAttribute("ReadyAtServerTime") or math.huge) <= now then
            xDTaraZ:Fire("MergeMachineRemote", "HatchEgg", egg:GetAttribute("EggId"))
            done += 1
        end
    end
    local tools = xDTaraZ.Eggs.Tools()
    local hitbox = #tools > 0 and xDTaraZ.Base.Hitbox()
    if not hitbox then return done end
    local _, hum = xDTaraZ:Character()
    for i, tool in ipairs(tools) do
        if not active() then return done end
        if hum then hum:EquipTool(tool) end
        local offset = vector3New((i % 3 - 1) * Config.EggSpacing, -hitbox.Size.Y / 2 + 0.5, math.floor(i / 3) * Config.EggSpacing)
        xDTaraZ:Fire("MergeMachineRemote", "PlaceEgg", tool, hitbox.Position + offset)
        done += 1
        task.wait(0.2)
    end
    return done
end

xDTaraZ.Teleport = {}

function xDTaraZ.Teleport.Zones()
    local names = {}
    for _, zone in ipairs(xDTaraZ.ZoneList) do names[#names + 1] = zone.Name end
    return names
end

function xDTaraZ.Teleport.Zone(name)
    local builds = Workspace:FindFirstChild("Build") and Workspace.Build:FindFirstChild("ZoneBuilds")
    local zone = builds and builds:FindFirstChild(name)
    if not zone then return end
    local eggs = zone:FindFirstChild("Eggs")
    local spot = eggs and eggs:FindFirstChildWhichIsA("BasePart", true)
    local pos = spot and spot.Position or zone:GetPivot().Position
    xDTaraZ.Move.To(cframeNew(pos + vector3New(0, 6, 0)))
end

function xDTaraZ.Teleport.Places()
    local list = { "My Base" }
    local booths = Workspace:FindFirstChild("Booths")
    if booths then
        for _, booth in ipairs(booths:GetChildren()) do list[#list + 1] = booth.Name end
    end
    if Workspace:FindFirstChild("EggMachine") then list[#list + 1] = "Egg Machine" end
    return list
end

function xDTaraZ.Teleport.Place(name)
    if name == "My Base" then
        xDTaraZ.Base.Home()
        return
    end
    local target = name == "Egg Machine" and Workspace:FindFirstChild("EggMachine") or (Workspace:FindFirstChild("Booths") and Workspace.Booths:FindFirstChild(name))
    if target then xDTaraZ.Move.To(cframeNew(target:GetPivot().Position + vector3New(0, 4, 6))) end
end

function xDTaraZ.Teleport.Player(name)
    local player = Players:FindFirstChild(name or "")
    local root = xDTaraZ.Bat.RootOf(player)
    if root then xDTaraZ.Move.To(root.CFrame * cframeNew(0, 0, 3)) end
end

xDTaraZ.Esp = { Tags = {} }

function xDTaraZ.Esp.Folder()
    if not active() then return nil end
    local folder = State.EspFolder
    if folder and folder.Parent then return folder end
    folder = Instance.new("Folder")
    folder.Name = "ErrorScriptsEggESP"
    State.EspFolder = folder
    local ok = pcall(function() folder.Parent = (gethui and gethui()) or CoreGui end)
    if not ok then
        local parent = LocalPlayer:WaitForChild("PlayerGui", Config.LoadTimeout)
        if not active() or not parent then folder:Destroy(); return nil end
        folder.Parent = parent
    end
    if not active() then folder:Destroy(); return nil end
    State.EspFolder = folder
    return folder
end

function xDTaraZ.Esp.Tag(adornee, text, color)
    if not active() then return nil end
    local folder = xDTaraZ.Esp.Folder()
    if not folder or not active() then return nil end
    local tag = xDTaraZ.Esp.Tags[adornee]
    if not tag then
        tag = Instance.new("BillboardGui")
        tag.AlwaysOnTop = true
        tag.Size = UDim2.fromOffset(200, 34)
        tag.StudsOffset = vector3New(0, 3, 0)
        tag.MaxDistance = 5000
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Font = Enum.Font.BuilderSans
        label.TextSize = 13
        label.TextStrokeTransparency = 0.3
        label.Parent = tag
        tag.Parent = folder
        xDTaraZ.Esp.Tags[adornee] = tag
    end
    tag.Adornee = adornee
    tag.TextLabel.Text = text
    tag.TextLabel.TextColor3 = color
    return tag
end

xDTaraZ.Esp.RarityColors = {
    Common = Color3.fromRGB(200, 200, 200), Uncommon = Color3.fromRGB(110, 230, 110), Rare = Color3.fromRGB(80, 170, 255),
    Epic = Color3.fromRGB(190, 110, 255), Legendary = Color3.fromRGB(255, 190, 60), Mythic = Color3.fromRGB(255, 80, 120),
}

function xDTaraZ.Esp.Step()
    if not active() then return end
    local opt = State.Opt
    local _, _, hrp = xDTaraZ:Character()
    local origin = hrp and hrp.Position or Vector3.zero
    local seen = {}
    local minRank = xDTaraZ.RarityRank[opt.EspMinRarity] or 1

    if opt.EspPickups and Workspace:FindFirstChild("AnimalPickups") then
        for _, model in ipairs(Workspace.AnimalPickups:GetChildren()) do
            local rarity = model:GetAttribute("Rarity") or "Common"
            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if part and (xDTaraZ.RarityRank[rarity] or 1) >= minRank then
                seen[part] = true
                xDTaraZ.Esp.Tag(part, ("%s [%s] %.0fkg\n$%s/s · %dm"):format(tostring(model:GetAttribute("AnimalName")), rarity, model:GetAttribute("WeightKg") or 0, xDTaraZ.Format(xDTaraZ.Pickup.Value(model)), (part.Position - origin).Magnitude), xDTaraZ.Esp.RarityColors[rarity] or Color3.fromRGB(255, 120, 255))
            end
        end
    end

    if opt.EspEggs then
        local damage = xDTaraZ.Break.Damage()
        for _, egg in ipairs(CollectionService:GetTagged("BreakableEgg")) do
            if xDTaraZ.Break.Alive(egg) then
                seen[egg] = true
                local hits = math.ceil(egg:GetAttribute("Health") / damage)
                xDTaraZ.Esp.Tag(egg, ("%s · Z%s\n%s HP · %d hits"):format(tostring(egg:GetAttribute("EggType")), tostring(egg:GetAttribute("ZoneIndex")), xDTaraZ.Format(egg:GetAttribute("Health")), hits), hits <= opt.MaxHits and Color3.fromRGB(120, 255, 140) or Color3.fromRGB(255, 120, 100))
            end
        end
    end

    if opt.EspPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            local root = player ~= LocalPlayer and xDTaraZ.Bat.RootOf(player)
            if root then
                seen[root] = true
                local carry = player:GetAttribute("CarryCount") or 0
                xDTaraZ.Esp.Tag(root, ("%s · %dm%s"):format(player.DisplayName, (root.Position - origin).Magnitude, carry > 0 and ("\nCarrying " .. tostring(player:GetAttribute("Carrying"))) or ""), carry > 0 and Color3.fromRGB(255, 200, 60) or Color3.fromRGB(255, 255, 255))
            end
        end
    end

    for adornee, tag in pairs(xDTaraZ.Esp.Tags) do
        if not seen[adornee] or not adornee.Parent then
            tag:Destroy()
            xDTaraZ.Esp.Tags[adornee] = nil
        end
    end
end

function xDTaraZ.Esp.Clear()
    for adornee, tag in pairs(xDTaraZ.Esp.Tags) do
        tag:Destroy()
        xDTaraZ.Esp.Tags[adornee] = nil
    end
end

xDTaraZ.Session = {}

function xDTaraZ.Session.Rejoin()
    if not active() then return end
    local queue = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
    local source = Library.ReloadSource
    if queue and type(source) == "string" and source ~= "" then pcall(queue, source) end
    if not active() then return end
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end

function xDTaraZ.Session.Bind()
    xDTaraZ:Connect(LocalPlayer.Idled, function()
        if not State.Opt.AntiAfk then return end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    xDTaraZ:Connect(UserInputService.JumpRequest, function()
        if not State.Opt.InfJump then return end
        local _, hum = xDTaraZ:Character()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
    xDTaraZ:Connect(RunService.Stepped, function()
        if State.Opt.Noclip then xDTaraZ.Move.SetNoclip(true) end
    end)
    xDTaraZ:Connect(LocalPlayer.CharacterAdded, function(char)
        xDTaraZ.Move.SetNoclip(false)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum or not active() or char ~= LocalPlayer.Character then return end
        xDTaraZ.Move.HoldSpeed(hum)
        if State.Opt.SpeedOn then State.Requests.Speed = true end
    end)
    local _, hum = xDTaraZ:Character()
    if hum then xDTaraZ.Move.HoldSpeed(hum) end
    local overlay = CoreGui:FindFirstChild("RobloxPromptGui")
    overlay = overlay and overlay:FindFirstChild("promptOverlay")
    if overlay then
        xDTaraZ:Connect(overlay.ChildAdded, function(child)
            if child.Name ~= "ErrorPrompt" or not State.Opt.AutoRejoin or State.Rejoining then return end
            State.Rejoining = true
            task.delay(Config.RejoinDelay, function()
                if not active() or not State.Opt.AutoRejoin then State.Rejoining = false; return end
                xDTaraZ.Session.Rejoin()
            end)
        end)
    end
end

xDTaraZ.Scheduler = {}

xDTaraZ.Scheduler.RequestHandlers = {
    Speed = xDTaraZ.Move.ApplySpeed,
    Place = xDTaraZ.Pets.Place,
    SellNow = function() xDTaraZ:Notify(Library:Translate("Sold %d animals"):format(xDTaraZ.Pets.Sell())) end,
    UpgradeNow = xDTaraZ.Shop.Now,
    ClaimNow = xDTaraZ.Rewards.Claim,
}

xDTaraZ.Scheduler.MoveHandlers = {
    StealNow = function()
        local folder = Workspace:FindFirstChild("AnimalPickups")
        local best, bestValue = nil, -1
        for _, model in ipairs(folder and folder:GetChildren() or {}) do
            local value = xDTaraZ.Pickup.Value(model)
            if value > bestValue then best, bestValue = model, value end
        end
        if best and xDTaraZ.Pickup.Grab(best) then xDTaraZ.Base.Bank() end
        xDTaraZ.Farm.Rest()
    end,
    BankNow = function()
        xDTaraZ.Base.Bank()
        xDTaraZ.Farm.Rest()
    end,
    HatchNow = function() xDTaraZ:Notify(Library:Translate("Eggs handled: %d"):format(xDTaraZ.Eggs.Step())) end,
    BatNow = function() xDTaraZ.Bat.Swing(Players:FindFirstChild(State.Opt.BatTarget or ""), true) end,
    Goto = function()
        local job = State.Goto
        State.Goto = nil
        if job then job() end
    end,
}

function xDTaraZ.Scheduler.Drain(handlers)
    if not active() then return end
    for name, handler in pairs(handlers) do
        if not active() then return end
        if State.Requests[name] then
            State.Requests[name] = nil
            xDTaraZ.Scheduler.Run(name, handler)
        end
    end
end

---Runs one round of a job, warning once per failure streak; toggles that keep failing for Config.FailWindow seconds are switched off and queued for the UI to report.
---@param key string|string[]  State.Opt flag(s) of the feature, or a plain label for jobs without one
function xDTaraZ.Scheduler.Run(key, fn)
    if not active() then return end
    local ok, err = pcall(fn)
    if not active() then return end
    local label = type(key) == "table" and key[1] or key
    local failures = State.Failures
    if ok then
        failures[label] = nil
        return
    end

    local streak = failures[label]
    if not streak then
        streak = { count = 0, since = osClock() }
        failures[label] = streak
        warn("[BreakStealEgg]", label, err)
    end
    streak.count += 1
    if streak.count < Config.MaxFailures or osClock() - streak.since < Config.FailWindow then return end

    local reason = tostring(err):match("[^\n]*")
    for _, flag in ipairs(type(key) == "table" and key or { key }) do
        if State.Opt[flag] ~= true then continue end
        failures[label] = nil
        State.Opt[flag] = false
        warn("[BreakStealEgg]", flag, "stopped:", reason)
        table.insert(State.Halted, { flag, reason })
    end
end

---@param stamp string  State.Last field holding the last run time
---@param key string|string[]  passed on to Run
function xDTaraZ.Scheduler.Every(stamp, key, interval, fn)
    if not active() then return end
    if osClock() - (State.Last[stamp] or 0) < interval then return end
    State.Last[stamp] = osClock()
    xDTaraZ.Scheduler.Run(key, fn)
end

xDTaraZ.Scheduler.ShopFlags = { "AutoUpgrade" }
xDTaraZ.Scheduler.EspFlags = { "EspPickups", "EspEggs", "EspPlayers" }
xDTaraZ.Scheduler.FarmFlags = { "AutoSteal", "AutoBreak", "RobCarriers" }

function xDTaraZ.Scheduler.Summarize()
    local cash = xDTaraZ.Attr("Cash", 0)
    State.StartCash = State.StartCash or cash
    local plot = xDTaraZ.Base.Own()
    local minutes = math.max((osClock() - State.StartAt) / 60, 1 / 60)
    local carry, cap = xDTaraZ.Base.Carry()
    local tier = xDTaraZ.Attr("PickaxeTier", 1)
    local pickaxe = GameLib.Pickaxe and GameLib.Pickaxe.Tiers[tier]
    State.Summary = ("Cash %s · %s/s\n%s (%s dmg) · Carry %d/%d\nBase %s/%s animals · Level %s"):format(
        xDTaraZ.Format(cash), xDTaraZ.Format(xDTaraZ.Attr("CashPerSecond", 0)),
        pickaxe and pickaxe.Name or "-", pickaxe and xDTaraZ.Format(xDTaraZ.Break.Damage()) or "-", carry, cap,
        tostring(plot and plot:GetAttribute("AnimalsPlaced") or "-"), tostring(plot and plot:GetAttribute("MaxAnimals") or "-"),
        tostring(plot and plot:GetAttribute("PlotLevel") or "-"))
    State.RunText = ("%s\nSteals %d · Eggs %d · Banked %d · +%s/min"):format(
        State.Status, State.Steals, State.Broken, State.Banked, xDTaraZ.Format((cash - State.StartCash) / minutes))
end

function xDTaraZ.Scheduler.Side()
    if not active() then return end
    local opt = State.Opt
    xDTaraZ.Scheduler.Every("Summary", "Summary", 0.5, xDTaraZ.Scheduler.Summarize)
    xDTaraZ.Scheduler.Drain(xDTaraZ.Scheduler.RequestHandlers)
    if opt.AutoPlace then xDTaraZ.Scheduler.Every("Place", "AutoPlace", Config.EquipInterval, xDTaraZ.Pets.Place) end
    if opt.AutoSell then xDTaraZ.Scheduler.Every("Sell", "AutoSell", Config.SellInterval, xDTaraZ.Pets.Sell) end
    if opt.AutoBuyPickaxe or opt.AutoUpgradePlot or opt.AutoTrail or opt.AutoTreadmill then xDTaraZ.Scheduler.Every("Shop", xDTaraZ.Scheduler.ShopFlags, Config.BuyInterval, xDTaraZ.Shop.Step) end
    if opt.AutoClaim then xDTaraZ.Scheduler.Every("Claim", "AutoClaim", Config.ClaimInterval, xDTaraZ.Rewards.Claim) end
    if opt.EspPickups or opt.EspEggs or opt.EspPlayers then
        xDTaraZ.Scheduler.Every("Esp", xDTaraZ.Scheduler.EspFlags, Config.EspInterval, xDTaraZ.Esp.Step)
    elseif next(xDTaraZ.Esp.Tags) then
        xDTaraZ.Esp.Clear()
    end
end

function xDTaraZ.Scheduler.Control()
    if not active() then return end
    local opt = State.Opt
    xDTaraZ.Scheduler.Drain(xDTaraZ.Scheduler.MoveHandlers)
    if opt.BatLoop and opt.BatTarget then
        xDTaraZ.Scheduler.Run("BatLoop", function() xDTaraZ.Bat.Swing(Players:FindFirstChild(opt.BatTarget), true) end)
        return
    end
    if opt.BatAura then xDTaraZ.Scheduler.Run("BatAura", xDTaraZ.Bat.Aura) end
    if opt.AutoHatch then xDTaraZ.Scheduler.Every("Eggs", "AutoHatch", Config.EggInterval, xDTaraZ.Eggs.Step) end
    xDTaraZ.Scheduler.Run(xDTaraZ.Scheduler.FarmFlags, xDTaraZ.Farm.Step)
end

function xDTaraZ.Scheduler.Boot()
    if not active() then return end
    xDTaraZ.Session.Bind()
    xDTaraZ.Scheduler.Run("Watch", xDTaraZ.Rewards.Watch)
    task.spawn(function()
        while active() do
            xDTaraZ.Scheduler.Side()
            task.wait(0.1)
        end
    end)
    task.spawn(function()
        while active() do
            xDTaraZ.Scheduler.Control()
            task.wait(Config.TickDelay)
        end
    end)
end

function xDTaraZ.Scheduler.Stop()
    State.Alive = false
    for _, conn in ipairs(State.Connections) do pcall(conn.Disconnect, conn) end
    table.clear(State.Connections)
    if State.SpeedConn then pcall(State.SpeedConn.Disconnect, State.SpeedConn); State.SpeedConn = nil end
    local read, natural = pcall(xDTaraZ.Move.NaturalSpeed)
    if not read then natural = State.NaturalSpeed or 16 end
    if State.SpeedWritten and State.SpeedHumanoid then
        pcall(function() State.SpeedHumanoid.WalkSpeed = natural end)
    end
    State.SpeedWritten, State.SpeedHumanoid = nil, nil
    for key, value in pairs(State.Opt) do if type(value) == "boolean" then State.Opt[key] = false end end
    table.clear(State.Requests)
    State.Goto = nil
    xDTaraZ.Move.SetNoclip(false)
    xDTaraZ.Esp.Clear()
    if State.EspFolder then State.EspFolder:Destroy(); State.EspFolder = nil end
end

local function BuildInterface()
    if not active() then return end
    local Window = Library:CreateWindow({ Title = "ErrorScripts", GameName = "Break and Steal an Egg" })
    local Options = setmetatable({}, { __index = function(_, key) return Library.Toggles[key] or Library.Options[key] end })
    local opt = State.Opt
    local names = {}

    local function Notify(text, kind)
        if active() then Library:Notify(text) end
    end

    local function Request(name)
        return function()
            if not active() then return end
            local gates = { StealNow = "AutoSteal", Place = "AutoPlace", SellNow = "AutoSell", HatchNow = "AutoHatch", ClaimNow = "AutoClaim", BatNow = "BatLoop" }
            local missing = gates[name] and GameLib.Missing(gates[name])
            if missing then Notify("This feature needs a game update: " .. missing); return end
            State.Requests[name] = true
        end
    end

    local function Toggle(group, key, info, onChange)
        names[key] = info.Text
        info.Default = false
        info.Callback = function(value)
            if not active() then return end
            local missing = value and GameLib.Missing(key)
            if missing then
                opt[key] = false
                local control = Library.Toggles[key]
                if control and control.Value then control:SetValue(false) end
                Notify("This feature needs a game update: " .. missing)
                return
            end
            opt[key] = value
            if onChange then onChange(value) end
        end
        return group:AddToggle(key, info)
    end

    ---@return table  toggle with an unbound key saved as <key>Key
    local function Feature(group, key, info, onChange)
        local control = Toggle(group, key, info, onChange)
        local picker = group:AddLabel(info.Text .. " key"):AddKeyPicker(key .. "Key", { Default = "None", Mode = "Toggle" })
        xDTaraZ:Connect(UserInputService.InputBegan, function(input, processed)
            if processed or Library._capturingKey or Library._skipToggle or UserInputService:GetFocusedTextBox() then return end
            if picker.Value == "None" or input.KeyCode == Enum.KeyCode.Unknown then return end
            if input.KeyCode.Name == picker.Value then control:SetValue(not control.Value) end
        end)
        return control
    end

    local function ToSet(selected)
        local set = {}
        if type(selected) ~= "table" then return set end
        for k, v in pairs(selected) do
            if v == true then set[k] = true elseif type(v) == "string" then set[v] = true end
        end
        return set
    end

    local function Goto(fn, arg)
        if not active() then return end
        State.Goto = function() fn(arg) end
        State.Requests.Goto = true
    end

    local function PlayerNames()
        local list = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then list[#list + 1] = player.Name end
        end
        table.sort(list)
        return list
    end

    local stats = {}
    local function BuildMain(window)
        local tab = window:AddTab("Info")
        local profile = tab:AddLeftGroupbox("User")
        profile:AddPlayerInfo("ErrorScriptsEggProfile", { Player = LocalPlayer })
        local session = tab:AddLeftGroupbox("Session")
        for _, entry in ipairs({
            { "Status", "Status: Idle" }, { "Cash", "Cash: 0" }, { "Income", "Income/s: 0" },
            { "Pickaxe", "Pickaxe: -" }, { "Damage", "Damage: 0" }, { "Carry", "Carrying: 0 / 0" },
            { "BaseAnimals", "Base animals: 0 / 0" }, { "BaseLevel", "Base level: 0" },
            { "Steals", "Steals: 0" }, { "Broken", "Eggs broken: 0" },
            { "Banked", "Animals banked: 0" }, { "CashRate", "Cash/min: 0" },
        }) do stats[entry[1]] = session:AddLabel(entry[2]) end
        local kaitun = tab:AddRightGroupbox("Kaitun")
        Feature(kaitun, "Kaitun", { Text = "Kaitun (All-in-one)", NoSave = true }, function(value)
            State.KaitunSet = State.KaitunSet or {}
            for _, key in ipairs({ "AutoSteal", "AutoBreak", "AutoPlace", "AutoSell", "AutoUpgrade", "AutoClaim", "AutoHatch", "AntiAfk" }) do
                local control = Options[key]
                if control then
                    if value and not opt[key] then
                        State.KaitunSet[key] = true
                        control:SetValue(true)
                    elseif not value and State.KaitunSet[key] then
                        State.KaitunSet[key] = nil
                        control:SetValue(false)
                    end
                end
            end
        end)
        local notes = tab:AddRightGroupbox("Break and Steal an Egg")
        notes:AddLabel("Steal animals, break eggs and upgrade your base.")
        notes:AddLabel("Start automation from the farming tab.")
    end

    local function BuildFarm(window)

        local tab = window:AddTab("Main")

        local stealBox = tab:AddLeftGroupbox("Auto Steal", "star")
        Feature(stealBox, "AutoSteal", { Text = "Auto Steal", Description = "Grabs the most valuable animals on the map and brings them home instantly" })
        stealBox:AddDropdown("Take", {
            Text = "Take",
            Description = "Upgrades Only = only animals that earn more than your weakest one",
            Values = { "Upgrades Only", "Everything" },
            Default = "Upgrades Only",
            Callback = function(value) if not active() then return end; opt.Take = value or "Upgrades Only" end,
        })
        stealBox:AddDropdown("StealRarities", {
            Text = "Only Rarities",
            Description = "Empty = take everything",
            Values = xDTaraZ.RarityLadder,
            Multi = true,
            Default = {},
            Callback = function(selected) if not active() then return end; opt.StealRarities = ToSet(selected) end,
        })
        stealBox:AddInput("StealMinValue", {
            Text = "Min Cash/s",
            Placeholder = "0", Default = "0", Finished = true,
            Numeric = true,
            Callback = function(value) if not active() then return end; opt.StealMinValue = tonumber(value) or 0 end,
        })
        stealBox:AddButton("Steal Best Now", Request("StealNow"))
        stealBox:AddButton("Bank Now", Request("BankNow"))

        local breakBox = tab:AddRightGroupbox("Auto Break", "qblock")
        Feature(breakBox, "AutoBreak", { Text = "Auto Break Eggs", Description = "Breaks eggs in any zone at max speed and takes the animal home" })
        local zoneChoices = { "Best" }
        for _, name in ipairs(xDTaraZ.Teleport.Zones()) do table.insert(zoneChoices, name) end
        breakBox:AddDropdown("BreakZone", {
            Text = "Zone",
            Description = "Best = most worth for the time spent",
            Values = zoneChoices,
            Default = "Best",
            Callback = function(value) if not active() then return end; opt.BreakZone = value or "Best" end,
        })
        breakBox:AddSlider("MaxHits", {
            Text = "Max Hits Per Egg",
            Description = "Skips eggs that take longer than this",
            Min = 1, Max = 200, Default = opt.MaxHits, Rounding = 0,
            Callback = function(value) if not active() then return end; opt.MaxHits = tonumber(value) or opt.MaxHits end,
        })

        local robBox = tab:AddRightGroupbox("Rob Players", "swords")
        Toggle(robBox, "RobCarriers", { Text = "Rob Carriers", Description = "Bats players carrying animals and takes what they drop", Risky = true })
    end

    local function BuildBase(window)

        local tab = window:AddTab("Shop")

        local placeBox = tab:AddLeftGroupbox("Animals", "mushroom")
        Feature(placeBox, "AutoPlace", { Text = "Auto Place Best", Description = "Keeps the best earners standing on your base" })
        placeBox:AddButton("Place Best Now", Request("Place"))

        local sellBox = tab:AddLeftGroupbox("Sell", "coin")
        Feature(sellBox, "AutoSell", { Text = "Auto Sell Leftovers", Description = "Sells animals in your backpack that did not fit on the base" })
        sellBox:AddDropdown("KeepRarities", {
            Text = "Never Sell",
            Values = xDTaraZ.RarityLadder,
            Multi = true,
            Default = {},
            Callback = function(selected) if not active() then return end; opt.KeepRarities = ToSet(selected) end,
        })
        sellBox:AddButton("Sell All Now", Request("SellNow"))

        local shopBox = tab:AddRightGroupbox("Upgrades", "coin")
        Feature(shopBox, "AutoUpgrade", { Text = "Auto Upgrade", Description = "Buys the picked upgrades as soon as you can pay" }, xDTaraZ.Shop.Sync)
        shopBox:AddDropdown("UpgradeTargets", {
            Text = "Upgrade",
            Description = "Pickaxe jumps to the best you can afford, Trail buys and wears the strongest",
            Values = { "Pickaxe", "Base", "Trail", "Treadmill" },
            Multi = true,
            Default = { "Pickaxe", "Base", "Trail", "Treadmill" },
            Callback = function(selected)
                if not active() then return end
                opt.UpgradeTargets = ToSet(selected)
                xDTaraZ.Shop.Sync()
            end,
        })
        shopBox:AddButton("Upgrade Now", Request("UpgradeNow"))
        shopBox:AddInput("CashReserve", {
            Text = "Keep Cash",
            Description = "Upgrades never spend below this",
            Placeholder = "0", Default = "0", Finished = true,
            Numeric = true,
            Callback = function(value) if not active() then return end; opt.CashReserve = tonumber(value) or 0 end,
        })

        local hatchBox = tab:AddLeftGroupbox("Eggs", "mushroom")
        Feature(hatchBox, "AutoHatch", { Text = "Auto Hatch Eggs", Description = "Places eggs from your backpack on your base and hatches them when ready" })
        hatchBox:AddButton("Hatch Eggs Now", Request("HatchNow"))

        local rewardBox = tab:AddRightGroupbox("Rewards", "star")
        Feature(rewardBox, "AutoClaim", { Text = "Auto Claim", Description = "Claims index, offline, group and community rewards, no joining needed" })
        rewardBox:AddButton("Claim Now", Request("ClaimNow"))
    end

    local function BuildPlayer(window)
        local tab = window:AddTab("Player", "user", "Movement and teleports")

        local moveBox = tab:AddLeftGroupbox("Movement", "star")
        Feature(moveBox, "SpeedOn", { Text = "Speed" }, Request("Speed"))
        moveBox:AddSlider("WalkSpeed", {
            Text = "Walk Speed",
            Min = 16, Max = 300, Default = opt.WalkSpeed, Rounding = 0,
            Callback = function(value)
                if not active() then return end
                opt.WalkSpeed = tonumber(value) or opt.WalkSpeed
                if opt.SpeedOn then State.Requests.Speed = true end
            end,
        })
        Feature(moveBox, "InfJump", { Text = "Infinite Jump" })
        Feature(moveBox, "Noclip", { Text = "Noclip" }, function(on) if not on then xDTaraZ.Move.SetNoclip(false) end end)

        local tpBox = tab:AddRightGroupbox("Teleport", "teleport")
        tpBox:AddDropdown("TpZone", {
            AllowNull = true,
            Text = "Zone",
            Values = xDTaraZ.Teleport.Zones(),
            Searchable = true,
            NoSave = true,
            Callback = function(value) if value then Goto(xDTaraZ.Teleport.Zone, value) end end,
        })
        tpBox:AddDropdown("TpPlace", {
            AllowNull = true,
            Text = "Place",
            Values = xDTaraZ.Teleport.Places(),
            NoSave = true,
            Callback = function(value) if value then Goto(xDTaraZ.Teleport.Place, value) end end,
        })
        local tpPlayer = tpBox:AddDropdown("TpPlayer", {
            AllowNull = true,
            Text = "Player",
            Values = PlayerNames(),
            Searchable = true,
            NoSave = true,
            Callback = function(value) if value then Goto(xDTaraZ.Teleport.Player, value) end end,
        })
        tpBox:AddButton("Refresh Players", function() tpPlayer:SetValues(PlayerNames()) end)
    end

    local function BuildVisuals(window)
        local tab = window:AddTab("Visuals", "eye", "See animals, eggs and players")
        local espBox = tab:AddLeftGroupbox("ESP", "eye")
        Toggle(espBox, "EspPickups", { Text = "Animals", Description = "Name, rarity, weight and cash per second" })
        espBox:AddDropdown("EspMinRarity", {
            Text = "Min Rarity",
            Values = xDTaraZ.RarityLadder,
            Default = xDTaraZ.RarityLadder[1] or "Common",
            Callback = function(value) if not active() then return end; opt.EspMinRarity = value or "Common" end,
        })

        local worldEspBox = tab:AddRightGroupbox("Eggs & Players", "eye")
        Toggle(worldEspBox, "EspEggs", { Text = "Eggs", Description = "HP and how many hits it takes" })
        Toggle(worldEspBox, "EspPlayers", { Text = "Players", Description = "Distance and what they carry" })
    end

    local function BuildTroll(window)
        local tab = window:AddTab("Troll", "troll", "Bat other players")
        local batBox = tab:AddLeftGroupbox("Bat", "swords")
        local batTarget = batBox:AddDropdown("BatTarget", {
            AllowNull = true,
            Text = "Target",
            Values = PlayerNames(),
            Searchable = true,
            NoSave = true,
            Callback = function(value) if not active() then return end; opt.BatTarget = value end,
        })
        batBox:AddButton("Refresh Players", function() batTarget:SetValues(PlayerNames()) end)
        Feature(batBox, "BatLoop", { Text = "Loop Bat Target", Description = "Follows the target and keeps knocking them over", Risky = true })
        batBox:AddButton("Bat Target Now", Request("BatNow"))

        local auraBox = tab:AddRightGroupbox("Bat Aura", "swords")
        Feature(auraBox, "BatAura", { Text = "Bat Aura", Description = "Knocks over anyone who gets close", Risky = true })
    end

    local function BuildSettings(window)
        local tab = window:AddTab("Settings")
        local session = tab:AddLeftGroupbox("Game session")
        Toggle(session, "AntiAfk", { Text = "Anti AFK" })
        Toggle(session, "AutoRejoin", { Text = "Auto Rejoin" })
        session:AddButton("Rejoin Now", xDTaraZ.Session.Rejoin)
        Theme:SetLibrary(Library)
        Save:SetLibrary(Library)
        Save:SetFolder(Config.SaveFolder)
        Save:SetIgnoreIndexes({ "Kaitun", "TpZone", "TpPlace", "TpPlayer", "BatTarget" })
        Theme:ApplyToTab(tab)
        Save:IgnoreThemeSettings()
        Save:BuildConfigSection(tab)
        return tab
    end

    BuildMain(Window)
    BuildFarm(Window)
    BuildBase(Window)
    BuildPlayer(Window)
    BuildVisuals(Window)
    BuildTroll(Window)
    local settings = BuildSettings(Window)
    for _, key in ipairs({ "Kaitun", "RobCarriers", "BatLoop", "BatAura" }) do
        if Library.RegisterAutomation then Library:RegisterAutomation(key) end
    end
    local missingCount = 0
    for key in pairs(GameLib.Needs) do
        if GameLib.Missing(key) then missingCount += 1 end
    end
    if missingCount > 0 then Notify("Some features could not find their game dependencies.") end
    local function statusText(source)
        local animal = source:match("^Stealing (.+)$")
        if animal then return Library:Translate("Stealing ") .. animal end
        local victim = source:match("^Robbing (.+)$")
        if victim then return Library:Translate("Robbing ") .. victim end
        local egg, zone = source:match("^Breaking (.+) %(Zone (.+)%)$")
        if egg then return Library:Translate("Breaking %s (Zone %s)"):format(egg, zone) end
        return Library:Translate(source)
    end
    local function live()
        while active() do
            for _, halt in ipairs(State.Halted) do
                local flag, reason = halt[1], halt[2]
                local control = Library.Toggles[flag]
                if control and control.Value then control:SetValue(false) end
                Notify(Library:Translate("%s stopped: %s"):format(Library:Translate(names[flag] or flag), reason))
            end
            table.clear(State.Halted)
            while active() and #State.Messages > 0 do Notify(table.remove(State.Messages, 1)) end
            if not active() then return end
            local cash = xDTaraZ.Attr("Cash", 0)
            local carry, capacity = xDTaraZ.Base.Carry()
            local plot = xDTaraZ.Base.Own()
            local tier = xDTaraZ.Attr("PickaxeTier", 1)
            local pickaxe = GameLib.Pickaxe and GameLib.Pickaxe.Tiers[tier]
            local minutes = math.max((osClock() - State.StartAt) / 60, 1 / 60)
            stats.Status:SetText(Library:Translate("Status:") .. " " .. statusText(State.Status))
            stats.Cash:SetText("Cash: " .. xDTaraZ.Format(cash))
            stats.Income:SetText("Income/s: " .. xDTaraZ.Format(xDTaraZ.Attr("CashPerSecond", 0)))
            stats.Pickaxe:SetText("Pickaxe: " .. (pickaxe and pickaxe.Name or "-"))
            stats.Damage:SetText("Damage: " .. (pickaxe and xDTaraZ.Format(xDTaraZ.Break.Damage()) or "-"))
            stats.Carry:SetText(("Carrying: %d / %d"):format(carry, capacity))
            stats.BaseAnimals:SetText(("Base animals: %s / %s"):format(
                tostring(plot and plot:GetAttribute("AnimalsPlaced") or "-"), tostring(plot and plot:GetAttribute("MaxAnimals") or "-")))
            stats.BaseLevel:SetText("Base level: " .. tostring(plot and plot:GetAttribute("PlotLevel") or "-"))
            stats.Steals:SetText("Steals: " .. tostring(State.Steals))
            stats.Broken:SetText("Eggs broken: " .. tostring(State.Broken))
            stats.Banked:SetText("Animals banked: " .. tostring(State.Banked))
            stats.CashRate:SetText("Cash/min: " .. xDTaraZ.Format((cash - (State.StartCash or cash)) / minutes))
            task.wait(0.5)
        end
    end
    if not active() then return end
    xDTaraZ.Scheduler.Boot()
    task.spawn(function() xDTaraZ.Util.Try("live status", live) end)
    return { Window = Window, Settings = settings, State = State, Engine = xDTaraZ }
end

if not active() then return end
return BuildInterface()
end


-- Registry uses Roblox universe IDs (game.GameId), rather than a single map's place ID.
local ErrorScriptsGames = {
	[10526853622] = {Key = "DeepFishing", Name = "Deep Fishing", Run = function(lib, theme, save) return ErrorScriptsDeepFishing(function() return lib, theme, save end) end},
	[10765012427] = {Key = "BuildThePyramid", Name = "Build The Pyramid", Run = ErrorScriptsPyramid},
	[10765288803] = {Key = "BreakStealEgg", Name = "Break and Steal an Egg", Run = ErrorScriptsEgg},
}

-- Key screen is the only UI permitted before successful server validation.
if not ErrorScriptsKeyGate() then return end

local current = ErrorScriptsGames[game.GameId]
ErrorScriptsConfig.GameKey = current and current.Key or "Universal"
ErrorScriptsConfig.GameName = current and current.Name or "Unsupported game"

-- A validated rerun stops the previous instance before creating the new hub.
local old = ErrorScriptsEnv.__ErrorScriptsHub
if type(old) == "table" and type(old.Unload) == "function" then pcall(old.Unload, old) end
local legacy = ErrorScriptsEnv.__ErrorScriptsDeepFishingLib
if type(legacy) == "table" and type(legacy.Unload) == "function" and legacy ~= old then pcall(legacy.Unload, legacy) end

local Library, Theme, Save = ErrorScriptsInterface()
ErrorScriptsEnv.__ErrorScriptsHub = Library
local Window = Library:CreateWindow({Title = "ErrorScripts", AutoShow = true})
Library:ApplyAccentName(Library.Style.Accent)
Save:SetFolder("ErrorScripts/" .. ErrorScriptsConfig.GameKey)

-- Auto rejoin may reload only this protected hub, if its owner configures LoaderUrl.
-- %q quotes the user's key; it is never placed in a URL or sent to a third-party loader.
if ErrorScriptsConfig.LoaderUrl:match("^https://") then
	Library.ReloadSource = ("getgenv().script_key=%q; loadstring(game:HttpGet(%q))()"):format(ErrorScriptsEnv.script_key, ErrorScriptsConfig.LoaderUrl)
end

local games = Window.ByName.Games
local libraryCard = games:AddLeftGroupbox("Supported games")
libraryCard:AddLabel("Deep Fishing")
libraryCard:AddLabel("Build The Pyramid")
libraryCard:AddLabel("Break and Steal an Egg")
libraryCard:AddDivider()
libraryCard:AddLabel("The hub loads only the game you are playing.")
local currentCard = games:AddRightGroupbox("Current game")
currentCard:AddLabel(current and current.Name or "Unsupported game")
local loadStatus = currentCard:AddLabel(current and "Ready to launch." or "This game is not supported yet.")
currentCard:AddToggle("ErrorScriptsAutoLoad", {Text = "Auto load current game", Default = ErrorScriptsConfig.AutoLoad, Callback = function(value) ErrorScriptsConfig.AutoLoad = value; Library:SavePreferences() end})

local launching, launched = false, false
local function launch()
	if not current or launching or launched or Library.Unloaded then return end
	launching = true
	loadStatus:SetText("Loading game module...")
	task.spawn(function()
		if Library.Unloaded then launching = false; return end
		local ok, result = xpcall(function() return current.Run(Library, Theme, Save) end, function(err) return debug.traceback(tostring(err), 2) end)
		launching = false
		if Library.Unloaded then return end
		if ok then
			launched = true; Library.GameLoaded = true; Library.GameAdapter = result
			Theme:ApplyToTab(Window.ByName.Settings)
			Save:BuildConfigSection(Window.ByName.Settings)
			Save:LoadAutoloadConfig()
			loadStatus:SetText("Game module loaded.")
			Library:SetLanguage(Library.Language)
			Window.ByName.Main:Select()
			Library:Notify("Your license has been verified.")
		else
			-- Partial gameplay initialization must not survive a failed boot or be duplicated by retry.
			warn("[ErrorScripts/" .. current.Key .. "] " .. tostring(result))
			Library:Unload()
			pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ErrorScripts", Text = Library:Translate("Game module failed to start. Check the console and run the hub again."), Duration = 10}) end)
		end
	end)
end
if current then currentCard:AddButton("Launch", launch) end

-- Settings remain available while a game's modules are still waiting for replication.
Theme:ApplyToTab(Window.ByName.Settings)
if not current then
	Save:BuildConfigSection(Window.ByName.Settings)
	Library:Notify("This game is not supported yet.")
	Window.ByName.Games:Select()
elseif ErrorScriptsConfig.AutoLoad then launch()
else Window.ByName.Games:Select() end
