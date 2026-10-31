-- NAHUALHUB | UI-Source (solo la ventana de key) | Junkie
-- Pégalo en la sección "UI Source" de Junkie. El script principal (NahualHub_Unificado) va en la sección de script.
-- Esta ventana sale ANTES de todo; al validar la key deja todo listo en getgenv() y el script principal continúa solo.
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local genv = (getgenv and getgenv()) or _G

local KEY_CFG = {
    service = "NahualHub",
    identifier = "1223023",
    provider = "lootlabs 24h",
    carpeta = "NahualHub",
}
-- Duración de tus keys en horas (tu provider es de 24h). Se usa para mostrar el tiempo restante estimado.
local KEY_DURACION_HORAS = 24

-- true = la key se guarda y entra sin pedirla hasta que expire (entonces pide una nueva)
-- false = pide la key en cada ejecución
local AUTOLOGIN = true

-- Cambia TEMA a "Halloween" para la ventana naranja/morada. "Tinta" es blanco, negro y gris.
local TEMA = "Tinta"
local PALETAS = {
    Tinta = {
        accent = Color3.fromRGB(210, 210, 216), accent2 = Color3.fromRGB(120, 120, 132),
        fondo = Color3.fromRGB(8, 8, 10), fondo2 = Color3.fromRGB(36, 36, 42), panel2 = Color3.fromRGB(38, 38, 44),
        sub = Color3.fromRGB(150, 150, 158), rojo = Color3.fromRGB(225, 225, 230),
        verde = Color3.fromRGB(235, 235, 240), mono = true,
    },
    Halloween = {
        accent = Color3.fromRGB(255, 125, 25), accent2 = Color3.fromRGB(150, 70, 255),
        fondo = Color3.fromRGB(20, 5, 45), fondo2 = Color3.fromRGB(110, 30, 170), panel2 = Color3.fromRGB(44, 30, 56),
        sub = Color3.fromRGB(150, 150, 178), rojo = Color3.fromRGB(255, 85, 100),
        verde = Color3.fromRGB(90, 230, 120), mono = false,
    },
}
local T = PALETAS[TEMA] or PALETAS.Tinta
local BLANCO = Color3.new(1, 1, 1)
local VERDE = T.verde

local guiParent = (gethui and gethui()) or CoreGui
local idioma = genv.NahualIdioma or "es"
genv.NahualIdioma = idioma
local licencia = {key = nil, expira = nil, exacta = false}

local function new(clase, props, hijos)
    local o = Instance.new(clase)
    -- Evita que Roblox traduzca solo los textos (la letra "L" se convertía en "Izq")
    if clase == "TextLabel" or clase == "TextButton" or clase == "TextBox" then
        pcall(function() o.AutoLocalize = false end)
    end
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then o[k] = v end
    end
    for _, h in ipairs(hijos or {}) do h.Parent = o end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end

local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, math.min(r, 8))}) end
local function bubble(r) return new("UICorner", {CornerRadius = UDim.new(0, r)}) end
local function redondo() return new("UICorner", {CornerRadius = UDim.new(1, 0)}) end

local function stroke(color, grosor, transp)
    local s = Instance.new("UIStroke")
    s.Thickness = grosor or 1
    s.Transparency = transp or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color
    return s
end

local function arcoiris()
    if not T.mono then
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.34, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.84, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        })
    end
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(70, 70, 76)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(200, 200, 206)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(18, 18, 22)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(150, 150, 158)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
end

local function gradRGB(parent, rot, lista)
    local g = Instance.new("UIGradient")
    g.Color = arcoiris()
    g.Rotation = rot or 0
    g.Parent = parent
    lista[#lista + 1] = g
    return g
end

local function gradTema(parent, rot)
    local g = Instance.new("UIGradient")
    g.Rotation = rot or 0
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.accent),
        ColorSequenceKeypoint.new(0.5, T.accent2),
        ColorSequenceKeypoint.new(1, T.accent),
    })
    g.Parent = parent
    return g
end

local function brillo(parent, transp, margen)
    margen = margen or 16
    return new("Frame", {
        Size = UDim2.new(1, -margen * 2, 0, 2), Position = UDim2.new(0, margen, 0, 3), BackgroundColor3 = BLANCO,
        BackgroundTransparency = transp or 0.85, BorderSizePixel = 0, Parent = parent,
    }, {corner(1)})
end

local function tween(o, t, props)
    local tw = TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end
local function tweenEx(o, info, props)
    local tw = TweenService:Create(o, info, props)
    tw:Play()
    return tw
end

local function ripple(visual, x)
    if not visual.Parent then return end
    x = x or (visual.AbsolutePosition.X + visual.AbsoluteSize.X / 2)
    local rel = x - visual.AbsolutePosition.X
    local d = math.max(visual.AbsoluteSize.X, 40) * 1.8
    local c = new("Frame", {
        Size = UDim2.new(0, 0, 0, 0), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, rel, 0.5, 0), BackgroundColor3 = BLANCO,
        BackgroundTransparency = 0.8, BorderSizePixel = 0, Parent = visual,
    }, {redondo()})
    tweenEx(c, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, d, 0, d), BackgroundTransparency = 1,
    })
    task.delay(0.6, function() c:Destroy() end)
end

local function fmtFecha(ts)
    local ok, r = pcall(os.date, "%d/%m/%Y %H:%M", ts)
    return ok and r or tostring(ts)
end
local function fmtTiempo(s, en)
    if s <= 0 then return en and "Expired" or "Expirada" end
    local d = math.floor(s / 86400)
    local h = math.floor((s % 86400) / 3600)
    local m = math.floor((s % 3600) / 60)
    local sec = math.floor(s % 60)
    if d > 0 then return string.format("%dd %02dh %02dm", d, h, m) end
    return string.format("%02dh %02dm %02ds", h, m, sec)
end

-- Devuelve true si la key es válida (y la deja en getgenv().SCRIPT_KEY). Si el usuario cierra la ventana, devuelve false.
local function sistemaKey()
    local archivo = KEY_CFG.carpeta .. "/key.txt"
    local archivoInfo = KEY_CFG.carpeta .. "/keyinfo.json"
    local function K(es, en) return (idioma == "en") and en or es end

    local function configurado()
        for _, k in ipairs({"service", "identifier", "provider"}) do
            local v = tostring(KEY_CFG[k] or "")
            if v == "" or string.sub(v, 1, 3) == "TU_" then return false end
        end
        return true
    end

    -- Captura las respuestas HTTP de Junkie: así se lee la fecha REAL de expiración (expires_at) aunque el SDK no la entregue
    genv.NahualResp = genv.NahualResp or {}
    genv.NahualCaptura = false
    local function guardarResp(txt)
        if genv.NahualCaptura and type(txt) == "string" and #txt < 30000 and string.find(txt, "{") and (string.find(txt, "xpir") or string.find(txt, "alid")) then
            local r = genv.NahualResp
            r[#r + 1] = txt
            if #r > 12 then table.remove(r, 1) end
        end
    end
    if not genv.NahualHookResp then
        pcall(function()
            local env = (getgenv and getgenv()) or _G
            for _, n in ipairs({"request", "http_request"}) do
                local orig = env[n]
                if type(orig) == "function" then
                    env[n] = function(...)
                        local res = orig(...)
                        pcall(function() if type(res) == "table" then guardarResp(res.Body) end end)
                        return res
                    end
                end
            end
            if type(syn) == "table" and type(syn.request) == "function" then
                local orig = syn.request
                syn.request = function(...)
                    local res = orig(...)
                    pcall(function() if type(res) == "table" then guardarResp(res.Body) end end)
                    return res
                end
            end
            if hookmetamethod and getnamecallmethod then
                local oldNC
                oldNC = hookmetamethod(game, "__namecall", function(self, ...)
                    local m = getnamecallmethod()
                    if genv.NahualCaptura and (m == "HttpGet" or m == "HttpGetAsync" or m == "RequestAsync" or m == "GetAsync" or m == "PostAsync") then
                        local r = oldNC(self, ...)
                        pcall(function() guardarResp(type(r) == "table" and r.Body or r) end)
                        return r
                    end
                    return oldNC(self, ...)
                end)
            end
            genv.NahualHookResp = true
        end)
    end

    -- Cargar el SDK oficial de Junkie
    local Junkie
    local okSdk, lib = pcall(function() return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))() end)
    if okSdk and type(lib) == "table" then
        Junkie = lib
        Junkie.service = KEY_CFG.service
        Junkie.identifier = KEY_CFG.identifier
        Junkie.provider = KEY_CFG.provider
    end

    -- Busca en la respuesta del servidor la fecha REAL de expiración (si el servicio la devuelve)
    local ultimaExp = nil
    local CAMPOS_FECHA = {expiresat = 1, expireat = 1, expiry = 1, expirydate = 1, expires = 1, expiration = 1,
        expirationdate = 1, expiretime = 1, expireson = 1, expirestime = 1, validuntil = 1, validtill = 1,
        validto = 1, endtime = 1, endsat = 1, enddate = 1, keyexpiry = 1, keyexpiresat = 1}
    local CAMPOS_REST = {expiresin = 1, timeleft = 1, timeremaining = 1, remaining = 1, remainingtime = 1,
        remainingseconds = 1, secondsleft = 1, secondsremaining = 1, ttl = 1, expiresinseconds = 1}
    local function aTs(v, rel)
        local n = tonumber(v)
        if n then
            if rel then
                if n > 1e7 then n = n / 1000 end            -- milisegundos
                return (n > 0) and (os.time() + n) or nil   -- segundos que le quedan
            end
            if n > 1e12 then n = n / 1000 end               -- milisegundos
            if n > 1e9 then return n end
            return nil
        end
        if type(v) == "string" and not rel then
            local ok, dt = pcall(function() return DateTime.fromIsoDate(v) end)
            if ok and dt then return dt.UnixTimestamp end
            local y, mo, d, h, mi, sg = string.match(v, "^(%d%d%d%d)-(%d%d)-(%d%d)[T ](%d%d):(%d%d):?(%d*)")
            if y then
                local ok2, dt2 = pcall(function()
                    return DateTime.fromUniversalTime(tonumber(y), tonumber(mo), tonumber(d), tonumber(h), tonumber(mi), tonumber(sg) or 0)
                end)
                if ok2 and dt2 then return dt2.UnixTimestamp end
            end
        end
        return nil
    end
    local function buscarExpira(t, prof)
        if type(t) ~= "table" or prof > 3 then return nil end
        for k, v in pairs(t) do
            if type(v) ~= "table" then
                local nk = (string.gsub(string.lower(tostring(k)), "[^%w]", ""))
                local ts
                if CAMPOS_FECHA[nk] then ts = aTs(v, false) elseif CAMPOS_REST[nk] then ts = aTs(v, true) end
                if ts then return ts end
            end
        end
        for _, v in pairs(t) do
            if type(v) == "table" then
                local ts = buscarExpira(v, prof + 1)
                if ts then return ts end
            end
        end
        return nil
    end

    -- Búsqueda amplia: cualquier campo cuyo nombre insinúe expiración/restante, con fecha o segundos plausibles
    local function buscarAmplia(t, prof)
        if type(t) ~= "table" or prof > 3 then return nil end
        for k, v in pairs(t) do
            if type(v) ~= "table" then
                local nk = string.lower(tostring(k))
                local esRest = string.find(nk, "left") or string.find(nk, "remain") or string.find(nk, "ttl")
                    or string.find(nk, "expires_in") or string.find(nk, "expiresin")
                local esFecha = string.find(nk, "exp") or string.find(nk, "until") or string.find(nk, "valid_to")
                    or string.find(nk, "validto") or string.find(nk, "end")
                local ts
                if esRest then ts = aTs(v, true) elseif esFecha then ts = aTs(v, false) end
                if ts and ts > os.time() - 60 and ts < os.time() + 86400 * 3650 then return ts end
            end
        end
        for _, v in pairs(t) do
            if type(v) == "table" then
                local ts = buscarAmplia(v, prof + 1)
                if ts then return ts end
            end
        end
        return nil
    end
    -- Último recurso: variables globales y campos del propio SDK que dejó Junkie al validar
    local function buscarEnGlobales(key)
        local ts
        pcall(function()
            for _, tbl in ipairs({genv, _G}) do
                for k, v in pairs(tbl) do
                    local nk = string.lower(tostring(k))
                    if type(v) ~= "table" and type(v) ~= "function" and (string.find(nk, "jd_") == 1 or string.find(nk, "junkie") or string.find(nk, "expir")) then
                        if string.find(nk, "exp") or string.find(nk, "until") or string.find(nk, "end") then
                            local t2 = aTs(v, false)
                            if t2 and t2 > os.time() - 60 and t2 < os.time() + 86400 * 3650 then ts = ts or t2 end
                        end
                    end
                end
            end
        end)
        if ts then return ts end
        pcall(function() ts = buscarAmplia(Junkie, 1) end)
        if ts then return ts end
        -- funciones de consulta que algunos SDK exponen
        for _, nombre in ipairs({"get_key_info", "key_info", "get_info", "get_key_data", "get_key_details", "get_expiry", "get_expires_at", "key_details", "get_key"}) do
            local f = Junkie and Junkie[nombre]
            if type(f) == "function" then
                local ok, r = pcall(f, key)
                if not ok or r == nil then ok, r = pcall(f) end
                if ok then
                    if type(r) == "table" then ts = buscarExpira(r, 0) or buscarAmplia(r, 0)
                    elseif r ~= nil then ts = aTs(r, false) end
                    if ts then return ts end
                end
            end
        end
        return nil
    end
    local function nombresCampos(t, pre, acc, prof)
        for k, v in pairs(t) do
            if type(v) == "table" and prof < 2 then nombresCampos(v, pre .. tostring(k) .. ".", acc, prof + 1)
            elseif type(v) == "table" then acc[#acc + 1] = pre .. tostring(k) .. ":table"
            else acc[#acc + 1] = pre .. tostring(k) .. "=" .. string.sub(tostring(v), 1, 40) end
        end
    end
    -- Tiempo restante con segundos (se actualiza en vivo)
    local function fmtRestante(sg, en)
        if sg <= 0 then return en and "Expired" or "Expirada" end
        local d = math.floor(sg / 86400)
        local h = math.floor((sg % 86400) / 3600)
        local m = math.floor((sg % 3600) / 60)
        local sc = math.floor(sg % 60)
        if d > 0 then return string.format("%dd %02dh %02dm %02ds", d, h, m, sc) end
        return string.format("%02dh %02dm %02ds", h, m, sc)
    end

    -- Verifica una key con el SDK. Devuelve (valida, mensajeDeError)
    local function comprobar(key, esNueva)
        if not Junkie then return false, "SDK" end
        if not configurado() then return false, "CFG" end
        genv.NahualResp = {}
        genv.NahualCaptura = true
        local ok, res = pcall(function() return Junkie.check_key(key) end)
        task.wait(0.05)
        genv.NahualCaptura = false
        if not ok then return false, "EXC:" .. tostring(res) end
        if type(res) == "table" then
            ultimaExp = nil
            pcall(function()
                ultimaExp = buscarExpira(res, 0) or buscarAmplia(res, 0)
                local acc = {}
                nombresCampos(res, "", acc, 0)
                genv.NahualKeyDebug = table.concat(acc, ", ")   -- campos que devuelve el servidor (diagnóstico)
            end)
            do
                pcall(function()
                    local dbg = tostring(genv.NahualKeyDebug)
                    if not ultimaExp then warn("[NAHUALHUB] El servidor no envió la fecha de expiración. Campos recibidos: " .. dbg) end
                    if writefile then
                        if makefolder and isfolder and not isfolder(KEY_CFG.carpeta) then makefolder(KEY_CFG.carpeta) end
                        writefile(KEY_CFG.carpeta .. "/keydebug.txt", dbg)
                    end
                end)
            end
            -- fecha real en las respuestas HTTP capturadas (expires_at, o validity_minutes contados desde ahora)
            if not ultimaExp and res.valid == true then
                pcall(function()
                    local rs = genv.NahualResp or {}
                    for i = #rs, 1, -1 do
                        local okj, obj = pcall(function() return HttpService:JSONDecode(rs[i]) end)
                        if okj and type(obj) == "table" then
                            ultimaExp = buscarExpira(obj, 0) or buscarAmplia(obj, 0)
                            if not ultimaExp then
                                local function minutos(t, prof)
                                    if type(t) ~= "table" or prof > 3 then return nil end
                                    for k, v in pairs(t) do
                                        local nk = string.gsub(string.lower(tostring(k)), "[^%w]", "")
                                        if nk == "validityminutes" and tonumber(v) and tonumber(v) > 0 then return tonumber(v) end
                                    end
                                    for _, v in pairs(t) do
                                        if type(v) == "table" then local m = minutos(v, prof + 1) if m then return m end end
                                    end
                                    return nil
                                end
                                local mn = minutos(obj, 0)
                                if mn then ultimaExp = os.time() + mn * 60 end
                            end
                            if ultimaExp then break end
                        end
                    end
                    genv.NahualKeyDebug = tostring(genv.NahualKeyDebug) .. " | HTTP: " .. string.sub(table.concat(rs, " ; "), 1, 1500)
                    if writefile then
                        pcall(function() writefile(KEY_CFG.carpeta .. "/keydebug.txt", tostring(genv.NahualKeyDebug)) end)
                    end
                end)
            end
            -- OJO: las variables globales (JD_EXPIRES_AT, etc.) son de la key con la que entraste al script.
            -- Al RENOVAR con otra key no se usan, si no su tiempo se sumaría dos veces.
            if not ultimaExp and res.valid == true and not esNueva then ultimaExp = buscarEnGlobales(key) end
            return res.valid == true, res.error and tostring(res.error) or nil
        end
        return res == true, nil
    end

    local function traducirError(e)
        local s = string.lower(tostring(e or ""))
        if s == "sdk" then return K("No se pudo cargar el SDK de Junkie. Revisa tu conexión o que tu executor permita HttpGet.", "Could not load the Junkie SDK. Check your connection or that your executor allows HttpGet.") end
        if s == "cfg" then return K("Falta configurar KEY_CFG al inicio del script.", "KEY_CFG is not configured at the top of the script.") end
        if string.sub(s, 1, 4) == "exc:" then return K("Error al verificar. Inténtalo de nuevo.", "Verification error. Try again.") end
        if s == "" then return K("Key inválida.", "Invalid key.") end
        if string.find(s, "expire") then return K("Tu key expiró. Consigue una nueva.", "Your key expired. Get a new one.") end
        if string.find(s, "hwid") then return K("Esta key está vinculada a otro dispositivo.", "This key is bound to another device.") end
        if string.find(s, "used") then return K("Esta key de un solo uso ya fue utilizada.", "This one-time key was already used.") end
        if string.find(s, "disabled") or string.find(s, "invalidated") then return K("Esta key fue desactivada.", "This key was disabled.") end
        if string.find(s, "service") then return K("Esta key es de otro servicio.", "This key belongs to another service.") end
        if string.find(s, "not found") or string.find(s, "not_found") or string.find(s, "invalid") then return K("Key inválida o no encontrada.", "Invalid or unknown key.") end
        if string.find(s, "http 429") then return K("Demasiados intentos. Espera un momento.", "Too many attempts. Wait a moment.") end
        return K("Key inválida: ", "Invalid key: ") .. tostring(e)
    end

    local function guardarKey(k)
        pcall(function()
            if writefile then
                if makefolder and isfolder and not isfolder(KEY_CFG.carpeta) then makefolder(KEY_CFG.carpeta) end
                writefile(archivo, k)
            end
        end)
    end

    -- Info de primer uso (para estimar cuándo expira)
    local function leerInfo()
        local info
        pcall(function()
            if getgenv and getgenv().NahualKeyInfo then info = getgenv().NahualKeyInfo end
            if not info and isfile and readfile and isfile(archivoInfo) then
                info = HttpService:JSONDecode(readfile(archivoInfo))
            end
        end)
        return info
    end
    local function guardarInfo(info)
        pcall(function() if getgenv then getgenv().NahualKeyInfo = info end end)
        pcall(function()
            if writefile then
                if makefolder and isfolder and not isfolder(KEY_CFG.carpeta) then makefolder(KEY_CFG.carpeta) end
                writefile(archivoInfo, HttpService:JSONEncode(info))
            end
        end)
    end

    -- Fecha de expiración: primero la REAL que devuelve el servidor al validar la key;
    -- si no la envía, se estima: primer uso + KEY_DURACION_HORAS.
    local archivoStack = KEY_CFG.carpeta .. "/keystack.json"
    local durManual = nil   -- duración que el usuario escribió junto a la key (ej: "MIKEY 30d")
    local function aSegundosDur(tok)
        tok = string.lower(tostring(tok or ""))
        local n, u = string.match(tok, "^(%d+)(%a+)$")
        n = tonumber(n)
        if not n or n <= 0 then return nil end
        local f
        if u == "h" or u == "hr" or u == "hrs" or u == "hora" or u == "horas" or u == "hour" or u == "hours" then f = 3600
        elseif u == "d" or u == "dia" or u == "dias" or u == "day" or u == "days" then f = 86400
        elseif u == "w" or u == "sem" or u == "semana" or u == "semanas" or u == "week" or u == "weeks" then f = 7 * 86400
        elseif u == "mo" or u == "mes" or u == "meses" or u == "month" or u == "months" then f = 30 * 86400
        elseif u == "y" or u == "ano" or u == "anos" or u == "year" or u == "years" then f = 365 * 86400
        end
        return f and (n * f) or nil
    end
    local function leerStack()
        local st
        pcall(function()
            st = genv.NahualStack
            if not st and isfile and readfile and isfile(archivoStack) then
                st = HttpService:JSONDecode(readfile(archivoStack))
            end
        end)
        if type(st) ~= "table" or type(st.lista) ~= "table" then st = {lista = {}, total = 0, aprox = false} end
        return st
    end
    local function guardarStack(st)
        pcall(function() genv.NahualStack = st end)
        pcall(function()
            if writefile then
                if makefolder and isfolder and not isfolder(KEY_CFG.carpeta) then makefolder(KEY_CFG.carpeta) end
                writefile(archivoStack, HttpService:JSONEncode(st))
            end
        end)
    end

    local function registrarLicencia(key, esNueva)
        licencia.key = key
        licencia.avisado = false
        local ahora = os.time()
        -- duración de ESTA key: primero la fecha real del servidor; si no, la que escribió el usuario; si no, la deducida de la key
        local dur, aprox
        licencia.manual = false
        if ultimaExp then
            dur, aprox = ultimaExp - ahora, false
        else
            local ok, ts = pcall(function() return JD_EXPIRES_AT end)
            local h = genv.NahualKeyExp
            if not esNueva and ok and type(ts) == "number" then
                dur, aprox = ts - ahora, false
            elseif not esNueva and type(h) == "table" and h.key == key and h.exacta and type(h.expira) == "number" then
                dur, aprox = h.expira - ahora, false
            else
                -- Solo tiempo REAL: si Junkie no manda la fecha no se inventa nada
                dur, aprox = nil, false
            end
        end
        durManual = nil
        if dur and dur <= 0 then dur = nil end

        local st = leerStack()
        -- Solo "Renovar key" suma. Al entrar con una key que no estaba en la lista, se empieza de cero con esa key.
        if not esNueva then
            local presente = false
            for _, e in ipairs(st.lista) do if e.k == key then presente = true end end
            if not presente then st = {lista = {}, total = 0, aprox = false} end
        end
        local entrada
        for _, e in ipairs(st.lista) do if e.k == key then entrada = e break end end
        if not entrada then
            st.lista[#st.lista + 1] = {k = key, dur = dur, aprox = aprox, desde = ahora}
            if dur then
                local fresco = not (type(st.total) == "number" and st.total > ahora)
                local base = fresco and ahora or st.total
                st.total = base + dur
                local previa = false
                if not fresco and st.aprox then previa = true end
                st.aprox = previa or (aprox == true)
            end
        elseif not entrada.dur and dur then
            entrada.dur, entrada.aprox = dur, aprox
            local fresco = not (type(st.total) == "number" and st.total > ahora)
            st.total = (fresco and ahora or st.total) + dur
            st.aprox = ((not fresco) and st.aprox == true) or (aprox == true)
        elseif dur and aprox == false and #st.lista == 1 then
            st.total = ahora + dur          -- una sola key con fecha real del servidor: exacto
            st.aprox = false
        end
        guardarStack(st)

        local ent
        for _, e in ipairs(st.lista) do if e.k == key then ent = e end end
        local conocido = ent ~= nil and ent.dur ~= nil
        if type(st.total) == "number" and st.total > ahora and (conocido or esNueva) then
            licencia.expira = st.total
            licencia.exacta = not st.aprox
        else
            licencia.expira = nil           -- sin fecha real ni duración deducible: no se inventa
            licencia.exacta = false
        end
        -- se la pasa al script principal para que muestre el mismo tiempo
        genv.NahualKeyExp = {key = key, expira = licencia.expira, exacta = licencia.exacta}
    end

    local function expirada()
        return licencia.expira ~= nil and os.time() >= licencia.expira
    end
    -- Borra solo la key guardada (keyinfo se conserva para que una key vencida no vuelva a contar como nueva)
    local function borrarKeyGuardada()
        pcall(function() if isfile and delfile and isfile(archivo) then delfile(archivo) end end)
        genv.SCRIPT_KEY = nil
    end

    -- Auto-login con la key guardada (solo si AUTOLOGIN = true)
    if AUTOLOGIN then
        local guardada
        pcall(function()
            if isfile and readfile and isfile(archivo) then
                guardada = string.gsub(readfile(archivo), "%s", "")
            end
        end)
        if guardada and guardada ~= "" then
            local valida, errG = comprobar(guardada)
            local eg = string.lower(tostring(errG or ""))
            local fallaRed = (not valida) and (eg == "sdk" or eg == "cfg" or string.sub(eg, 1, 4) == "exc:")
            if valida then
                registrarLicencia(guardada)
                if not expirada() then
                    pcall(function() getgenv().SCRIPT_KEY = guardada end)
                    return true
                end
            end
            if not fallaRed then borrarKeyGuardada() end   -- inválida o expirada (un fallo de red no borra la key)
        end
    end

    local function kp(t, c) return ColorSequenceKeypoint.new(t, c) end
    local gradsAnim = {}
    local textos = {}
    local function reg(obj, prop, es, en)
        textos[#textos + 1] = {obj, prop, es, en}
        obj[prop] = (idioma == "en") and en or es
    end

    -- Si quedó una ventana vieja, se borra
    local viejo = guiParent:FindFirstChild("NahualKey")
    if viejo then viejo:Destroy() end

    local gui = new("ScreenGui", {
        Name = "NahualKey", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 200,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = guiParent,
    })
    local overlay = new("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = gui})
    tween(overlay, 0.5, {BackgroundTransparency = 0.35})

    -- Ventana
    local frame = new("Frame", {
        Size = UDim2.new(0, 440, 0, 340), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = BLANCO, BackgroundTransparency = 0.05, ClipsDescendants = true, Parent = gui,
    }, {bubble(28)})
    new("UIGradient", {Color = ColorSequence.new(T.fondo, T.fondo2), Rotation = 90, Parent = frame})
    local escala = new("UIScale", {Scale = 0.6, Parent = frame})
    tweenEx(escala, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})

    local borde = Instance.new("UIStroke")
    borde.Thickness = 3
    borde.Color = BLANCO
    borde.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    borde.Parent = frame
    local gBorde = Instance.new("UIGradient")
    gBorde.Color = ColorSequence.new({kp(0, T.accent), kp(0.5, T.accent2), kp(1, T.accent)})
    gBorde.Parent = borde

    -- Manchas de luz que se mueven dentro de la ventana
    local blobs = {}
    for i = 1, 2 do
        local col = (i == 1) and T.accent or T.accent2
        blobs[i] = new("Frame", {
            Size = UDim2.new(0, 200, 0, 200), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = col,
            BackgroundTransparency = 0.86, BorderSizePixel = 0, Parent = frame,
        }, {redondo()})
    end
    brillo(frame, 0.82, 36)

    -- Selector de idioma EN / ES (arriba a la izquierda)
    local selIdioma = new("Frame", {
        Size = UDim2.new(0, 88, 0, 30), Position = UDim2.new(0, 14, 0, 12), BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.45, Parent = frame,
    }, {redondo()})
    local selSt = stroke(BLANCO, 2, 0.05)
    selSt.Parent = selIdioma
    gradRGB(selSt, 0, gradsAnim)
    local indicador = new("Frame", {
        Size = UDim2.new(0.5, -4, 1, -6), Position = UDim2.new(0, 3, 0, 3), BackgroundColor3 = T.accent,
        BackgroundTransparency = 0.4, BorderSizePixel = 0, Parent = selIdioma,
    }, {redondo()})
    local bES = new("TextButton", {
        Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = "ES", Font = Enum.Font.GothamBlack, TextSize = 13,
        TextColor3 = BLANCO, AutoButtonColor = false, Parent = selIdioma,
    })
    local bEN = new("TextButton", {
        Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, Text = "EN",
        Font = Enum.Font.GothamBlack, TextSize = 13, TextColor3 = BLANCO, AutoButtonColor = false, Parent = selIdioma,
    })
    local function aplicarIdioma()
        genv.NahualIdioma = idioma
        for _, it in ipairs(textos) do
            pcall(function() it[1][it[2]] = (idioma == "en") and it[4] or it[3] end)
        end
        tween(indicador, 0.2, {Position = (idioma == "en") and UDim2.new(0.5, 1, 0, 3) or UDim2.new(0, 3, 0, 3)})
        bES.TextTransparency = (idioma == "en") and 0.45 or 0
        bEN.TextTransparency = (idioma == "en") and 0 or 0.45
    end
    bES.MouseButton1Click:Connect(function() idioma = "es"; aplicarIdioma() end)
    bEN.MouseButton1Click:Connect(function() idioma = "en"; aplicarIdioma() end)

    -- Título: letras en negrita (relleno + contorno), color fluyendo y efecto de ola
    local titulo = "NAHUALHUB"
    local anchoL = 37
    local totalW = anchoL * #titulo
    local contT = new("Frame", {Size = UDim2.new(0, totalW, 0, 54), Position = UDim2.new(0.5, -totalW / 2, 0, 38), BackgroundTransparency = 1, Parent = frame})
    local letras = {}
    for i = 1, #titulo do
        local l = new("TextLabel", {
            Size = UDim2.new(0, anchoL, 1, 0), Position = UDim2.new(0, (i - 1) * anchoL, 0, 0), BackgroundTransparency = 1,
            Text = string.sub(titulo, i, i), Font = Enum.Font.GothamBlack, TextSize = 38, TextColor3 = T.accent, TextTransparency = 1, Parent = contT,
        })
        local st = Instance.new("UIStroke")
        st.Color = T.accent
        st.Thickness = 2
        st.Transparency = 1
        st.Parent = l
        letras[i] = {l = l, st = st}
        task.delay(0.25 + i * 0.06, function()
            if l.Parent then
                tween(l, 0.35, {TextTransparency = 0})
                tween(st, 0.35, {Transparency = 0.1})
            end
        end)
    end

    local subLbl = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 96), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack, TextSize = 12, TextColor3 = T.accent2, Parent = frame,
    })
    reg(subLbl, "Text", "S I S T E M A    D E    K E Y", "K E Y    S Y S T E M")

    -- Barra RGB con brillo que se desliza
    local barra = new("Frame", {
        Size = UDim2.new(0, 170, 0, 4), Position = UDim2.new(0.5, -85, 0, 118), BackgroundColor3 = BLANCO, BorderSizePixel = 0, Parent = frame,
    }, {redondo()})
    local barraG = gradRGB(barra, 0, {})

    -- Campo de key (píldora burbuja)
    local cajaWrap = new("Frame", {
        Size = UDim2.new(1, -48, 0, 48), Position = UDim2.new(0, 24, 0, 134), BackgroundColor3 = T.panel2,
        BackgroundTransparency = 0.45, Parent = frame,
    }, {bubble(24)})
    local cajaSt = stroke(T.accent, 2.2, 0.2)
    cajaSt.Parent = cajaWrap
    brillo(cajaWrap, 0.88, 26)
    local caja = new("TextBox", {
        Size = UDim2.new(1, -36, 1, 0), Position = UDim2.new(0, 18, 0, 0), BackgroundTransparency = 1, Text = "",
        PlaceholderColor3 = T.sub, TextColor3 = BLANCO, ClearTextOnFocus = false,
        Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true, Parent = cajaWrap,
    })
    reg(caja, "PlaceholderText", "Pega tu key aquí", "Paste your key here")
    caja.Focused:Connect(function() tween(cajaSt, 0.2, {Transparency = 0, Color = T.accent2}) end)
    caja.FocusLost:Connect(function() tween(cajaSt, 0.2, {Transparency = 0.2, Color = T.accent}) end)

    -- Botones burbuja. rgb = true -> botón resaltado con degradado y marco RGB que giran
    local ancBtn = (440 - 48 - 12) / 2
    local yBtn = 196
    local function boton(x, w, rgb)
        local glow
        if rgb then
            glow = new("Frame", {
                Size = UDim2.new(0, w + 12, 0, 58), Position = UDim2.new(0, x - 6, 0, yBtn - 6), BackgroundColor3 = BLANCO,
                BackgroundTransparency = 0.7, BorderSizePixel = 0, Parent = frame,
            }, {bubble(29)})
            gradRGB(glow, 0, gradsAnim)
        end
        local b = new("TextButton", {
            Size = UDim2.new(0, w, 0, 46), Position = UDim2.new(0, x, 0, yBtn), BackgroundColor3 = BLANCO,
            BackgroundTransparency = rgb and 0.3 or 0.6, Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = frame,
        }, {bubble(23)})
        local st = stroke(BLANCO, rgb and 2.6 or 2, rgb and 0 or 0.15)
        st.Parent = b
        if rgb then
            gradRGB(b, 0, gradsAnim)
            gradRGB(st, 90, gradsAnim)
        else
            gradsAnim[#gradsAnim + 1] = gradTema(b, 0)
        end
        brillo(b, 0.65, 24)
        local lbl = new("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, TextSize = rgb and 16 or 15,
            TextColor3 = BLANCO, TextStrokeColor3 = Color3.new(0, 0, 0), TextStrokeTransparency = 0.4, Parent = b,
        })
        local sc = new("UIScale", {Scale = 1, Parent = b})
        local base = rgb and 0.3 or 0.6
        b.MouseEnter:Connect(function() tween(sc, 0.15, {Scale = 1.05}); tween(b, 0.15, {BackgroundTransparency = base - 0.15}) end)
        b.MouseLeave:Connect(function() tween(sc, 0.15, {Scale = 1}); tween(b, 0.15, {BackgroundTransparency = base}) end)
        b.MouseButton1Down:Connect(function(x2)
            tween(sc, 0.08, {Scale = 0.94})
            pcall(ripple, b, x2)
        end)
        b.MouseButton1Up:Connect(function() tween(sc, 0.15, {Scale = 1.05}) end)
        return b, lbl, glow
    end
    local bVerificar, lblVerificar = boton(24, ancBtn, false)
    local bObtener, lblObtener, glowObtener = boton(24 + ancBtn + 12, ancBtn, true)
    reg(lblVerificar, "Text", "VERIFICAR", "VERIFY")
    reg(lblObtener, "Text", "OBTENER KEY", "GET KEY")
    local function textoBtnVerificar() lblVerificar.Text = (idioma == "en") and "VERIFY" or "VERIFICAR" end
    local function textoBtnObtener() lblObtener.Text = (idioma == "en") and "GET KEY" or "OBTENER KEY" end

    local estadoLbl = new("TextLabel", {
        Size = UDim2.new(1, -48, 0, 58), Position = UDim2.new(0, 24, 0, 254), BackgroundTransparency = 1, Text = "",
        Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = T.sub, TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top, Parent = frame,
    })
    local function estado(txt, col) estadoLbl.Text = txt; estadoLbl.TextColor3 = col or T.sub end

    local pie = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -22), BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = T.sub, TextTransparency = 0.3, Parent = frame,
    })
    reg(pie, "Text", "Protegido con Junkie · key v3 (suma de tiempo)", "Protected by Junkie · key v3 (time stacking)")

    local cerrar = new("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -40, 0, 13), BackgroundColor3 = T.rojo, BackgroundTransparency = 0.5,
        Text = "X", TextColor3 = BLANCO, Font = Enum.Font.GothamBlack, TextSize = 12, AutoButtonColor = false, Parent = frame,
    }, {redondo(), stroke(T.rojo, 1.5, 0.15)})
    local scX = new("UIScale", {Scale = 1, Parent = cerrar})
    cerrar.MouseEnter:Connect(function() tween(scX, 0.12, {Scale = 1.12}); tween(cerrar, 0.12, {BackgroundTransparency = 0.25}) end)
    cerrar.MouseLeave:Connect(function() tween(scX, 0.12, {Scale = 1}); tween(cerrar, 0.12, {BackgroundTransparency = 0.5}) end)

    aplicarIdioma()

    -- Animación general
    local t0 = tick()
    local con = RunService.Heartbeat:Connect(function(dt)
        local t = tick() - t0
        gBorde.Rotation = (gBorde.Rotation + 90 * dt) % 360
        for _, g in ipairs(gradsAnim) do g.Rotation = (g.Rotation + 55 * dt) % 360 end
        barraG.Offset = Vector2.new(math.sin(t * 2) * 0.5, 0)
        glowObtener.BackgroundTransparency = 0.7 + math.sin(t * 4) * 0.15
        for i, L in ipairs(letras) do
            local ph = t * 3 + i * 0.55
            local col = T.accent:Lerp(T.accent2, (math.sin(t * 1.6 + i * 0.5) + 1) / 2)
            L.l.Position = UDim2.new(0, (i - 1) * anchoL, 0, math.sin(ph) * 4)
            L.l.TextColor3 = col
            L.st.Color = col
            L.st.Thickness = 2 + math.sin(ph) * 0.5
        end
        blobs[1].Position = UDim2.new(0.15 + math.sin(t * 0.7) * 0.08, 0, 0.2 + math.cos(t * 0.5) * 0.08, 0)
        blobs[2].Position = UDim2.new(0.85 + math.cos(t * 0.6) * 0.08, 0, 0.85 + math.sin(t * 0.8) * 0.08, 0)
    end)

    if not configurado() then
        estado(traducirError("cfg"), T.rojo)
    elseif not Junkie then
        estado(traducirError("sdk"), T.rojo)
    end

    local resultado = nil
    local ocupado = false

    -- Sacudida de la ventana cuando algo sale mal
    local function sacudir()
        task.spawn(function()
            for _, dx in ipairs({-12, 12, -9, 9, -5, 5, 0}) do
                frame.Position = UDim2.new(0.5, dx, 0.5, 0)
                task.wait(0.035)
            end
        end)
    end

    -- Explosión de burbujas cuando la key es correcta
    local function explosion()
        gBorde.Color = ColorSequence.new({kp(0, VERDE), kp(0.5, T.mono and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 255, 210)), kp(1, VERDE)})
        local cx, cy = frame.AbsolutePosition.X + frame.AbsoluteSize.X / 2, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y / 2
        for _ = 1, 28 do
            local sz = math.random(8, 20)
            local col = (math.random() > 0.5) and VERDE or T.accent
            local b = new("Frame", {
                Size = UDim2.new(0, sz, 0, sz), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, cx, 0, cy),
                BackgroundColor3 = col, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 10, Parent = gui,
            }, {redondo(), stroke(BLANCO, 1.2, 0.4)})
            local ang = math.random() * 6.283
            local dist = math.random(120, 320)
            tweenEx(b, TweenInfo.new(0.7 + math.random() * 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, cx + math.cos(ang) * dist, 0, cy + math.sin(ang) * dist),
                BackgroundTransparency = 1, Size = UDim2.new(0, sz + 14, 0, sz + 14),
            })
            task.delay(1.3, function() b:Destroy() end)
        end
    end

    local function verificar()
        if ocupado then return end
        local key = string.gsub(caja.Text, "^%s+", "")
        key = string.gsub(key, "%s+$", "")
        do   -- "MIKEY 30d": los días escritos al final se usan como duración (la key se valida sin ellos)
            local k2, tok = string.match(key, "^(%S+)[%s,;|]+(%S+)$")
            if k2 and aSegundosDur(tok) then key = k2; durManual = aSegundosDur(tok) end
        end
        if key == "" then estado(K("Escribe tu key primero.", "Type your key first."), T.rojo) sacudir() return end
        ocupado = true
        lblVerificar.Text = "..."
        task.spawn(function()
            local n = 0
            while ocupado do
                estado(K("Verificando", "Verifying") .. string.rep(".", n % 4), T.sub)
                n = n + 1
                task.wait(0.3)
            end
        end)
        local valida, err = comprobar(key)
        ocupado = false
        textoBtnVerificar()
        if valida then
            registrarLicencia(key)
            if expirada() then
                borrarKeyGuardada()
                estado(K("Tu key expiró. Consigue una nueva.", "Your key expired. Get a new one."), T.rojo)
                sacudir()
                return
            end
            guardarKey(key)
            pcall(function() getgenv().SCRIPT_KEY = key end)
            local en = (idioma == "en")
            -- Muestra la fecha real de expiración y el tiempo que queda, contando en vivo
            local function textoValida()
                local txt = K("¡Key válida!", "Valid key!")
                if licencia.expira and (licencia.exacta or licencia.manual) then
                    txt = txt .. "\n" .. K("Expira: ", "Expires: ") .. fmtFecha(licencia.expira)
                        .. "\n" .. K("Tiempo restante: ", "Time left: ") .. fmtRestante(licencia.expira - os.time(), en)
                end
                return txt
            end
            estado(textoValida(), VERDE)
            explosion()
            local fin = tick() + 2.4
            while tick() < fin do
                task.wait(0.25)
                estado(textoValida(), VERDE)
            end
            resultado = true
        else
            estado(traducirError(err), T.rojo)
            sacudir()
        end
    end
    bVerificar.MouseButton1Click:Connect(verificar)
    caja.FocusLost:Connect(function(enter) if enter then verificar() end end)

    local pidiendoLink = false
    bObtener.MouseButton1Click:Connect(function()
        if pidiendoLink then return end
        if not Junkie or not configurado() then estado(traducirError(Junkie and "cfg" or "sdk"), T.rojo) sacudir() return end
        pidiendoLink = true
        lblObtener.Text = "..."
        estado(K("Solicitando link...", "Requesting link..."), T.sub)
        local ok, link, err = pcall(Junkie.get_key_link)
        pidiendoLink = false
        textoBtnObtener()
        if ok and type(link) == "string" and link ~= "" then
            local copiar = setclipboard or toclipboard
            if copiar and pcall(copiar, link) then
                estado(K("Link copiado al portapapeles. Ábrelo en tu navegador para obtener tu key.", "Link copied to clipboard. Open it in your browser to get your key."), VERDE)
            else
                estado(K("Abre este link: ", "Open this link: ") .. link, VERDE)
                caja.Text = link
            end
        else
            local e = tostring(ok and err or link)
            if e == "RATE_LIMITTED" then
                estado(K("Demasiadas solicitudes. Espera un momento.", "Too many requests. Wait a moment."), T.rojo)
            else
                estado(K("No se pudo obtener el link: ", "Could not get the link: ") .. e, T.rojo)
            end
            sacudir()
        end
    end)

    cerrar.MouseButton1Click:Connect(function() if resultado == nil then resultado = false end end)

    -- Espera hasta que el usuario termine (o la ventana desaparezca)
    repeat task.wait() until resultado ~= nil or not gui.Parent
    con:Disconnect()
    tween(overlay, 0.25, {BackgroundTransparency = 1})
    tween(escala, 0.25, {Scale = 0.85})
    task.wait(0.25)
    gui:Destroy()
    return resultado == true
end

genv.SCRIPT_KEY = nil
genv.UI_CLOSED = false
genv.UI_CLOSED_T = nil

if not sistemaKey() then
    genv.UI_CLOSED = true
    genv.UI_CLOSED_T = os.time()
    return
end
-- Fin del UI-Source: el script protegido continúa con la key en getgenv().SCRIPT_KEY

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/9da49766625509bafafe45ba54cb2f889f6d6f01f52b0517cd3bb85dcbda1618?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end