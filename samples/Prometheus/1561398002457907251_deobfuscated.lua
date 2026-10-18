-- This file was generated at discord.gg/syncrypt

loadstring([=[require 'lib.monetloader'
local imgui   = require 'mimgui'
local fa      = require('fAwesome6')
local ffi     = require 'ffi'
local bit     = require 'bit'
local inicfg  = require 'inicfg'
local memory  = require 'memory'
local SAMemory = require 'SAMemory'
local hook    = require 'monethook'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local sc      = pcall(require, 'supericon') and require('supericon')

SAMemory.require('CCamera')
local camera = SAMemory.camera
local gta = ffi.load('GTASA')
local BASE = MONET_GTASA_BASE

ffi.cdef[[
    extern float _ZN6CTimer12ms_fTimeStepE;
    void _Z12AND_OpenLinkPKc(const char* link);
    typedef struct CPed CPed;
    typedef struct CVector CVector;
    CPed _ZN4CCam17Process_AimWeaponERK7CVectorfff(CPed* Player, CVector* a2, float a3, float a4, float a5);
]]

local surtzy = {}
surtzy.dpi = MONET_DPI_SCALE or 1.0
surtzy.mds = (MONET_DPI_SCALE or 0.3) * 0.72
surtzy.novo = imgui.new
local v2 = function(x,y) return imgui.ImVec2(x,y) end
local v4 = function(r,g,b,a) return imgui.ImVec4(r,g,b,a) end
local cor = function(r,g,b,a) return imgui.ColorConvertFloat4ToU32(imgui.ImVec4(r,g,b,a)) end

local TEMAS = {
    { nome = "Cyan",       r=0.10, g=0.90, b=0.85 },
    { nome = "Verde",      r=0.20, g=0.85, b=0.35 },
    { nome = "Amarelo",    r=0.95, g=0.80, b=0.10 },
    { nome = "Vermelho",   r=0.90, g=0.25, b=0.25 },
    { nome = "Roxo",       r=0.60, g=0.35, b=0.95 },
    { nome = "Laranja",    r=0.95, g=0.55, b=0.15 },
    { nome = "Branco",     r=0.95, g=0.95, b=0.96 },
    { nome = "Preto",      r=0.22, g=0.22, b=0.24 },
    { nome = "Rosa",       r=0.95, g=0.35, b=0.65 },
    { nome = "Lima",       r=0.65, g=0.90, b=0.15 },
    { nome = "Turquesa",   r=0.15, g=0.75, b=0.65 },
    { nome = "Dourado",    r=0.85, g=0.70, b=0.25 },
}
local tmatual = surtzy.novo.int(0)

local PAL = {
    fundo      = v4(0.07,0.07,0.08,0.98),
    sidebar    = v4(0.045,0.045,0.05,1.0),
    campo      = v4(0.13,0.13,0.14,1.0),
    linha      = v4(1,1,1,0.06),
    branco     = v4(0.95,0.95,0.96,1.0),
    cinza      = v4(0.52,0.52,0.55,1.0),
    cinzaclaro = v4(0.72,0.72,0.75,1.0),
    vermelho   = v4(0.88,0.24,0.24,1.0),
    azul       = v4(0.30,0.42,0.90,1.0),
}

local function acento(a)
    a = a or 1.0
    local tm = TEMAS[tmatual[0]+1]
    return v4(tm.r, tm.g, tm.b, a)
end
local function acentoU32(a)
    return imgui.ColorConvertFloat4ToU32(acento(a))
end

local function execlink(link)
    if type(link) == 'string' then gta._Z12AND_OpenLinkPKc(link) end
end

local cfg = inicfg.load({
    ['Câmera Estática 4.0 - By SurtzyX'] = {
        sensibilidadecamera = 4.0,
        sensibilidadeveiculo = 3.0,
        smooth = 0.20,
        deadzone = 0.02,
        idioma = 0,
        cameraveh = false,
        tema = 0,
        semshake = false,
        fixarmira = false,
        looksback = false,
    }
}, 'Câmera Estática')

local S = cfg['Câmera Estática 4.0 - By SurtzyX']

local pinit = true
local suavH = 0
local suavV = 0

local camPC = false
local camFix = false
local angMira = {h = 0, v = 0}
local estMirando = false

local fsensibilidadecamera = surtzy.novo.float(S.sensibilidadecamera)
local fsensibilidadeveiculo = surtzy.novo.float(S.sensibilidadeveiculo)
local fsmooth = surtzy.novo.float(S.smooth)
local fDeadzone = surtzy.novo.float(S.deadzone)
local sidioma = surtzy.novo.int(S.idioma)
local chkcameraveh = surtzy.novo.bool(S.cameraveh)
local chksemshake = surtzy.novo.bool(S.semshake)
local chkfixarmira = surtzy.novo.bool(S.fixarmira)
local chklookback = surtzy.novo.bool(S.looksback)
tmatual[0] = S.tema or 0

local compatibilidade = "Armeabi-v7a (32-bit)"

local aimMult = 1.0

local function hookMiraFn(player, a2, a3, a4, a5)
    gta._ZN6CTimer12ms_fTimeStepE = aimMult
    return hookMiraFn(player, a2, a3, a4, a5)
end

hookMiraFn = hook.new(
    'void(*)(CPed* Player, CVector* a2, float a3, float a4, float a5)',
    hookMiraFn,
    ffi.cast('uintptr_t', ffi.cast('void*', gta._ZN4CCam17Process_AimWeaponERK7CVectorfff))
)

local function alterarsensibilidade()
    aimMult = 1.00 + ((fsensibilidadecamera[0] - 1.0) * 0.0)
    aimMult = 1.0
end

local function salvar()
    local S = cfg['Câmera Estática 4.0 - By SurtzyX']
    S.sensibilidadecamera = fsensibilidadecamera[0]
    S.sensibilidadeveiculo = fsensibilidadeveiculo[0]
    S.smooth = fsmooth[0]
    S.deadzone = fDeadzone[0]
    S.idioma = sidioma[0]
    S.cameraveh = chkcameraveh[0]
    S.tema = tmatual[0]
    S.semshake = chksemshake[0]
    S.fixarmira = chkfixarmira[0]
    S.looksback = chklookback[0]
    inicfg.save(cfg, 'Câmera Estática')
    alterarsensibilidade()
end

local PATCHES = {
    { addr = BASE + 0x003c2d50 + 0x0c68 },
    { addr = BASE + 0x003c2d50 + 0x1340 },
    { addr = BASE + 0x003c0250 + 0x1822 },
    { addr = BASE + 0x003c0250 + 0x1528 },
}

local VEICULOOFFSET = {
    { addr = BASE + 0x003e16c4 },
    { addr = BASE + 0x003d47ea },
    { addr = BASE + 0x003d4908 },
    { addr = BASE + 0x003d2498 },
}

local SHAKEOFFSET = {
    { addr = BASE + 0x003d6488 },
    { addr = BASE + 0x003e1bac },
    { addr = BASE + 0x003db2e8 },
    { addr = BASE + 0x003de65c },
    { addr = BASE + 0x003e2100 },
    { addr = BASE + 0x003e1be8 },
}

local LOOKBACKOFFSET = {
    { addr = BASE + 0x3FA52E },
    { addr = BASE + 0x3FA4FA },
}

local THECAMERA = 0x3C6D50

local ativo = false
local veiculosoffsetsa = false
local shakeoffsetsa = false
local aimfixativo = false
local lookbackativo = false

local function applyPatches()
    if ativo then return end
    for _, p in ipairs(PATCHES) do
        local ptr = ffi.cast('uint8_t*', p.addr)
        memory.unprotect(tonumber(ffi.cast('uintptr_t', ptr)), 4)
        if not p.orig then
            p.orig = { ptr[0], ptr[1], ptr[2], ptr[3] }
        end
        ptr[0] = 0x00; ptr[1] = 0xBF; ptr[2] = 0x00; ptr[3] = 0xBF
    end
    ativo = true
end

local function restorePatches()
    if not ativo then return end
    for _, p in ipairs(PATCHES) do
        if p.orig then
            local ptr = ffi.cast('uint8_t*', p.addr)
            ptr[0] = p.orig[1]; ptr[1] = p.orig[2]; ptr[2] = p.orig[3]; ptr[3] = p.orig[4]
        end
    end
    ativo = false
end

local function applyVehiclePatches()
    if veiculosoffsetsa then return end
    for _, p in ipairs(VEICULOOFFSET) do
        local ptr = ffi.cast('uint8_t*', p.addr)
        memory.unprotect(tonumber(ffi.cast('uintptr_t', ptr)), 4)
        if not p.orig then
            p.orig = { ptr[0], ptr[1], ptr[2], ptr[3] }
        end
        ptr[0] = 0x70; ptr[1] = 0x47; ptr[2] = 0x00; ptr[3] = 0xBF
    end
    veiculosoffsetsa = true
end

local function restoreVehiclePatches()
    if not veiculosoffsetsa then return end
    for _, p in ipairs(VEICULOOFFSET) do
        if p.orig then
            local ptr = ffi.cast('uint8_t*', p.addr)
            ptr[0] = p.orig[1]; ptr[1] = p.orig[2]; ptr[2] = p.orig[3]; ptr[3] = p.orig[4]
        end
    end
    veiculosoffsetsa = false
end

local function applyShakePatches()
    if shakeoffsetsa then return end
    for _, p in ipairs(SHAKEOFFSET) do
        local ptr = ffi.cast('uint8_t*', p.addr)
        memory.unprotect(tonumber(ffi.cast('uintptr_t', ptr)), 4)
        if not p.orig then
            p.orig = { ptr[0], ptr[1], ptr[2], ptr[3] }
        end
        ptr[0] = 0x70; ptr[1] = 0x47; ptr[2] = 0x00; ptr[3] = 0xBF
    end
    shakeoffsetsa = true
end

local function restoreShakePatches()
    if not shakeoffsetsa then return end
    for _, p in ipairs(SHAKEOFFSET) do
        if p.orig then
            local ptr = ffi.cast('uint8_t*', p.addr)
            ptr[0] = p.orig[1]; ptr[1] = p.orig[2]; ptr[2] = p.orig[3]; ptr[3] = p.orig[4]
        end
    end
    shakeoffsetsa = false
end

local function applyLookBackPatches()
    if lookbackativo then return end
    for _, p in ipairs(LOOKBACKOFFSET) do
        local ptr = ffi.cast('uint8_t*', p.addr)
        memory.unprotect(tonumber(ffi.cast('uintptr_t', ptr)), 4)
        if not p.orig then
            p.orig = { ptr[0], ptr[1], ptr[2], ptr[3] }
        end
        ptr[0] = 0x00; ptr[1] = 0x20; ptr[2] = 0x70; ptr[3] = 0x47
    end
    lookbackativo = true
end

local function restoreLookBackPatches()
    if not lookbackativo then return end
    for _, p in ipairs(LOOKBACKOFFSET) do
        if p.orig then
            local ptr = ffi.cast('uint8_t*', p.addr)
            ptr[0] = p.orig[1]; ptr[1] = p.orig[2]; ptr[2] = p.orig[3]; ptr[3] = p.orig[4]
        end
    end
    lookbackativo = false
end

local function applyAimFix()
    if aimfixativo then return end
    memory.setfloat(BASE + THECAMERA, 1.0, true)
    aimfixativo = true
end

local function restoreAimFix()
    if not aimfixativo then return end
    memory.setfloat(BASE + THECAMERA, 0.0, true)
    aimfixativo = false
end

local function restaurarTudo()
    restorePatches()
    restoreVehiclePatches()
    restoreShakePatches()
    restoreAimFix()
    if not chklookback[0] then
        restoreLookBackPatches()
    end
end

local function normalizar(a)
    while a > math.pi do a = a - (2 * math.pi) end
    while a < -math.pi do a = a + (2 * math.pi) end
    return a
end

local MODELOS_AERONAVE = {
    [417]=true,[465]=true,[487]=true,[488]=true,[497]=true,
    [563]=true,[577]=true,[579]=true,
    [460]=true,[476]=true,[511]=true,[512]=true,[513]=true,
    [519]=true,[520]=true,[553]=true,[593]=true,[425]=true,
    [447]=true,[469]=true,[548]=true,[564]=true
}

local function IsAeronaves()
    if not isCharInAnyCar(PLAYER_PED) then return false end
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    return MODELOS_AERONAVE[getCarModel(veh)] == true
end

local seveiculo = false

local function checarMira()
    if not doesCharExist(PLAYER_PED) then return false end
    if isCharInAnyCar(PLAYER_PED) then
        return isPlayerTargettingAnything(PLAYER_HANDLE)
    end
    return isPlayerTargettingChar(PLAYER_HANDLE, PLAYER_PED)
end

local function desativarColisaoCam()
    camera.bHeadBob = false
    local camAtiva = camera.aCams[camera.nActiveCam or 0]
    if camAtiva then camAtiva.bCollisionChecksOn = false end
end

local function cameraSendoMovida()
    for _, w in ipairs({175, 176, 177}) do
        local ok, dx, dy = isWidgetPressedEx(w, 0)
        if ok and (math.abs(dx) > 5 or math.abs(dy) > 5) then return true end
    end
    return false
end

local function aimforthecamera()
    if isCharInAnyCar(PLAYER_PED) then
        restoreAimFix()
        estMirando = false
        camPC = false
        camFix = false
        return
    end
    if not doesCharExist(PLAYER_PED) then return end

    local mira = checarMira()

    if mira then
        applyAimFix()
    else
        restoreAimFix()
    end

    if not chkfixarmira[0] then
        estMirando = false
        camPC = false
        camFix = false
        return
    end

    local camAtiva = camera.aCams[camera.nActiveCam or 0]
    if not camAtiva then return end

    if mira then
        if not estMirando then
            angMira.h = camAtiva.fHorizontalAngle
            angMira.v = camAtiva.fVerticalAngle
            estMirando = true
            camPC = false
            camFix = false
            desativarColisaoCam()
        end
        camAtiva.fHorizontalAngle = angMira.h
        camAtiva.fVerticalAngle = angMira.v
        camAtiva.fIdealAlpha = angMira.h
        camAtiva.fTrueAlpha = angMira.h
        camAtiva.fTrueBeta = angMira.v
    else
        if estMirando then
            camAtiva.fHorizontalAngle = angMira.h
            camAtiva.fVerticalAngle = angMira.v
            camPC = false
            camFix = false
            estMirando = false
        end
        if not camPC then
            camPC = true
            camFix = true
        end
        if camFix then
            if cameraSendoMovida() then
            else
                if not isWidgetPressedEx(0xAF, 0) then
                    camAtiva.fHorizontalAngle = angMira.h
                    camAtiva.fVerticalAngle = angMira.v
                end
            end
        end
    end
end

local fmveiculos = 8
local esperaVeiculo = 0

addEventHandler('onD3DPresent', function()
    local passo = gta._ZN6CTimer12ms_fTimeStepE

    if not doesCharExist(PLAYER_PED) then
        restaurarTudo()
        pinit = true
        seveiculo = false
        estMirando = false
        camPC = false
        camFix = false
        esperaVeiculo = 0
        return
    end

    if chklookback[0] then
        applyLookBackPatches()
    else
        restoreLookBackPatches()
    end

    local emVeiculo = isCharInAnyCar(PLAYER_PED)
    local emAeronave = IsAeronaves()
    local cameravehAtivo = chkcameraveh[0]

    if emVeiculo and not seveiculo then
        restoreVehiclePatches()
        esperaVeiculo = fmveiculos
        pinit = true
    end
    if not emVeiculo then
        esperaVeiculo = 0
    end
    seveiculo = emVeiculo

    if esperaVeiculo > 0 then
        esperaVeiculo = esperaVeiculo - 1
        if esperaVeiculo == 0 then
            pinit = true
        end
    end

    if chksemshake[0] then
        applyShakePatches()
    else
        restoreShakePatches()
    end

    local deveAtivar
    if emVeiculo and not emAeronave then
        deveAtivar = cameravehAtivo
    else
        deveAtivar = true
    end

    if not deveAtivar then
        restorePatches()
        restoreVehiclePatches()
        pinit = true
        return
    end

    applyPatches()

    if emVeiculo and not emAeronave and cameravehAtivo and esperaVeiculo == 0 then
        applyVehiclePatches()
    else
        restoreVehiclePatches()
    end

    aimforthecamera()

    local idxAtivo = tonumber(ffi.cast('uint8_t', camera.nActiveCam))

    if idxAtivo >= 0 and idxAtivo < 3 then
        local cam = camera.aCams[idxAtivo]
        camera.nWhoIsInControlOfTheCamera = 1
        cam.fAlphaSpeed, cam.fBetaSpeed = 0, 0

        if chkfixarmira[0] and not emVeiculo and checarMira() then
            cam.fHorizontalAngle = angMira.h
            cam.fVerticalAngle = angMira.v
            cam.fIdealAlpha = angMira.h
            cam.fTrueAlpha = angMira.h
            cam.fTrueBeta = angMira.v
            return
        end

        if pinit then
            suavH = cam.fHorizontalAngle
            suavV = cam.fVerticalAngle
            pinit = false
        end

        local pressionado, dx, dy = isWidgetPressedEx(0xAF, 0)

        if pressionado and dx and dy then
            if math.abs(dx) > fDeadzone[0] or math.abs(dy) > fDeadzone[0] then
                local valSens = emVeiculo and fsensibilidadeveiculo[0] or fsensibilidadecamera[0]
                local sens = valSens * 0.0005 * passo
                suavH = normalizar(suavH - (dx * sens))
                suavV = suavV - (dy * sens)
                if suavV > 1.5 then suavV = 1.5 end
                if suavV < -1.1 then suavV = -1.1 end
            end
        else
            suavH = cam.fHorizontalAngle
            suavV = cam.fVerticalAngle
        end

        local difH = normalizar(suavH - cam.fHorizontalAngle)
        local difV = suavV - cam.fVerticalAngle
        local lerp = fsmooth[0]

        if math.abs(difH) > 0.0001 then
            cam.fHorizontalAngle = normalizar(cam.fHorizontalAngle + (difH * lerp * passo))
        else
            cam.fHorizontalAngle = suavH
        end

        if math.abs(difV) > 0.0001 then
            cam.fVerticalAngle = cam.fVerticalAngle + (difV * lerp * passo)
        else
            cam.fVerticalAngle = suavV
        end

        if not chkfixarmira[0] or emVeiculo or not checarMira() then
            angMira.h = cam.fHorizontalAngle
            angMira.v = cam.fVerticalAngle
        end

        cam.fIdealAlpha = cam.fHorizontalAngle
        cam.fTrueAlpha  = cam.fHorizontalAngle
        cam.fTrueBeta   = cam.fVerticalAngle
    end
end)


addEventHandler('onScriptTerminate', function(scr)
    if scr == script.this then
        restorePatches()
        restoreVehiclePatches()
        restoreShakePatches()
        restoreAimFix()
        restoreLookBackPatches()
        salvar()
    end
end)

local idioma = {
    [0] = {
        titulo1 = "Câmera",
        titulo2 = "Estática",
        titulo3 = "PC",
        corinterface = "Cor da interface",
        geral = "Configs",
        sobre = "Creditos",
        ver = "Versão 4.0 Final",
        autores = "Autor: SurtzyX",
        yt = "YouTube",
        dc = "Discord",
        yturl = "https://youtube.com/@surtzyx07",
        dcurl = "https://discord.gg/gustax-mods-halloween-1225929838116864011",
        sensibilidadecamera = "Sensibilidade da Câmera",
        sensibilidadeveiculo = "Sensibilidade da Câmera (Veículos)",
        smooth = "Suavização (Smooth)",
        deadzone = "Ignorar Toques (Zona Morta)",
        cameraveh = "Câmera Estática em Veículos",
        semshake = "Desativar Shakes",
        fixarmira = "Fixar Câmera ao Mirar",
        changelogs = "Changelogs",
        baixarversoes = "Outras Versões",
        looksback = "Desativar Olhar Para Trás",
    },
    [1] = {
        titulo1 = "Static",
        titulo2 = "Camera",
        titulo3 = "PC",
        corinterface = "Interface color",
        geral = "Configs",
        sobre = "Credits",
        ver = "Version 4.0 Final",
        autores = "Author: SurtzyX",
        yt = "YouTube",
        dc = "Discord",
        yturl = "https://youtube.com/@surtzyx07",
        dcurl = "https://discord.gg/gustax-mods-halloween-1225929838116864011",
        sensibilidadecamera = "Camera Sensitivity",
        sensibilidadeveiculo = "Camera Sensitivity (Vehicles)",
        smooth = "Smooth",
        deadzone = "Ignore Touches (Dead zone)",
        cameraveh = "Static Camera in Vehicles",
        semshake = "Disable Shakes",
        fixarmira = "Lock Camera on Aim",
        changelogs = "Changelogs",
        baixarversoes = "Others Versions",
        looksback = "Disable Look Behind",
    },
    [2] = {
        titulo1 = "Cámara",
        titulo2 = "Estática",
        titulo3 = "PC",
        corinterface = "Color de interfaz",
        geral = "Configs",
        sobre = "Creditos",
        ver = "Versión 4.0 Final",
        autores = "Autor: SurtzyX",
        yt = "YouTube",
        dc = "Discord",
        yturl = "https://youtube.com/@surtzyx07",
        dcurl = "https://discord.gg/gustax-mods-halloween-1225929838116864011",
        sensibilidadecamera = "Sensibilidad de Cámara",
        sensibilidadeveiculo = "Sensibilidad de Cámara (Vehículos)",
        smooth = "Suavizado (Smooth)",
        deadzone = "Ignorar Toques",
        cameraveh = "Cámara Estática en Vehículos",
        semshake = "Desactivar Shakes",
        fixarmira = "Fijar Cámara al Apuntar",
        changelogs = "Registro de Cambios",
        baixarversoes = "Otras Versiones",
        looksback = "Desactivar Mirar Atrás",
    },
}

local function t(chave) return (idioma[sidioma[0]] and idioma[sidioma[0]][chave]) or chave end

local changelogs = {
    [0] = {
        {"4.0 Final", "(SurtzyX)", {
            {"[NEW]", "Interface totalmente refeita com nova UI"},
            {"[NEW]", "Adicionada nova mecânica de fixar a câmera na posição que mirar (a mecânica antiga da 2.0 tinha diversas falhas e causava tremores)"},
            {"[NEW]", "Adicionado sistema para desativar todos os shakes do jogo"},
            {"[NEW]", "Adicionada suavização (Smooth) para movimentos da câmera"},
            {"[NEW]", "Adicionada mecânica que corrige a câmera para apontar (mirar) para onde você olha (Aim for the Camera - P.E.I.X.E)"},
            {"[NEW]", "Adicionada mecânica que desabilita olhar para trás"},
            {"[FIX]", "Nova mecânica de câmera estática em veículos"},
            {"[FIX]", "Câmera estática adaptável para dispositivos com FPS baixo (antes tinha tremores em dispositivos com FPS menor que 35)"},
            {"[FIX]", "Corrigido bug da câmera de veículo prender em 1ª pessoa ao entrar no veículo"},
            {"[FIX]", "Corrigido bug de tremores (shakes) da câmera estática em alguns veículos"},
        }},
        {"3.0", "(SurtzyX)", {
            {"[NEW]", "Funcionalidade da câmera estática refeita do zero"},
            {"[NEW]", "Adicionado Deadzone (Zona Morta) para evitar movimentos indesejados"},
            {"[NEW]", "Adicionada sensibilidade da câmera (fora de veículos)"},
            {"[NEW]", "Adicionada sensibilidade da câmera (em veículos)"},
            {"[NEW]", "Adicionado checkbox para ativar/desativar câmera estática em veículos"},
            {"[FIX]", "Corrigidos os bugs de queda de FPS em alguns dispositivos fracos"},
            {"[FIX]", "Corrigido o bug da câmera estática dos veículos subir/descer ao detectar toques"},
            {"[FIX]", "Corrigido o bug de shake ao mover a tela"},
        }},
        {"2.1", "(SurtzyX, bekasuyy)", {
            {"[NEW]", "Adicionado checkbox para ativar/desativar a câmera estática em veículos"},
            {"[FIX]", "Corrigido o bug da câmera mudar de posição aleatoriamente em veículos"},
            {"[FIX]", "Corrigido o bug que fazia o mod crashar ao clicar nos links"},
        }},
        {"2.0", "(SurtzyX, bekasuyy)", {
            {"[NEW]", "Adicionada função Fixar Câmera ao Mirar"},
            {"[FIX]", "Corrigidos os tremores e vibrações da câmera estática"},
            {"[NEW]", "Adicionada câmera estática funcionando dentro de veículos"},
            {"[NEW]", "Adicionada sensibilidade da câmera em veículos"},
        }},
    },
    [1] = {
        {"4.0 Final", "(SurtzyX)", {
            {"[NEW]", "UI completely remade with new design"},
            {"[NEW]", "Added new mechanic to lock the camera in the aiming position (the old mechanic from 2.0 had several flaws and caused shaking)"},
            {"[NEW]", "Added system to disable all game shakes"},
            {"[NEW]", "Added smoothing (Smooth) for camera movements"},
            {"[NEW]", "Added mechanic that corrects the camera to aim where you look (Aim for the Camera - P.E.I.X.E)"},
            {"[NEW]", "Added mechanic to disable look behind"},
            {"[FIX]", "New static camera mechanic in vehicles"},
            {"[FIX]", "Static camera adapted for low FPS devices (previously had tremors on devices with FPS below 35)"},
            {"[FIX]", "Fixed vehicle camera getting stuck in first person when entering a vehicle"},
            {"[FIX]", "Fixed shaking (shakes) bug of the static camera in some vehicles"},
        }},
        {"3.0", "(SurtzyX)", {
            {"[NEW]", "Static camera functionality completely remade from scratch"},
            {"[NEW]", "Added Deadzone to prevent unwanted movements"},
            {"[NEW]", "Added camera sensitivity (outside vehicles)"},
            {"[NEW]", "Added camera sensitivity (inside vehicles)"},
            {"[NEW]", "Added checkbox to enable/disable static camera in vehicles"},
            {"[FIX]", "Fixed FPS drop issues on some low-end devices"},
            {"[FIX]", "Fixed static vehicle camera moving up/down when detecting touches"},
            {"[FIX]", "Fixed shake bug when moving the screen"},
        }},
        {"2.1", "(SurtzyX, bekasuyy)", {
            {"[NEW]", "Added checkbox to enable/disable static camera in vehicles"},
            {"[FIX]", "Fixed bug where camera randomly changed position inside vehicles"},
            {"[FIX]", "Fixed crash when clicking links"},
        }},
        {"2.0", "(SurtzyX, bekasuyy)", {
            {"[NEW]", "Added Lock Camera on Aim function"},
            {"[FIX]", "Fixed static camera shaking and vibration"},
            {"[NEW]", "Added static camera support inside vehicles"},
            {"[NEW]", "Added vehicle camera sensitivity"},
        }},
    },
    [2] = {
        {"4.0 Final", "(SurtzyX)", {
            {"[NEW]", "Interfaz completamente rehecha con nueva UI"},
            {"[NEW]", "Añadida nueva mecánica para fijar la cámara en la posición de puntería (la mecánica antigua de la 2.0 tenía varias fallas y causaba temblores)"},
            {"[NEW]", "Añadido sistema para desactivar todos los shakes del juego"},
            {"[NEW]", "Añadida suavización (Smooth) para movimientos de la cámara"},
            {"[NEW]", "Añadida mecánica que corrige la cámara para apuntar (mirar) hacia donde miras (Aim for the Camera - P.E.I.X.E)"},
            {"[NEW]", "Añadida mecánica para desactivar mirar atrás"},
            {"[FIX]", "Nueva mecánica de cámara estática en vehículos"},
            {"[FIX]", "Cámara estática adaptable para dispositivos con FPS bajo (antes tenía temblores en dispositivos con FPS menor a 35)"},
            {"[FIX]", "Corregido bug de la cámara del vehículo quedando en primera persona al entrar"},
            {"[FIX]", "Corregido bug de temblores (shakes) de la cámara estática en algunos vehículos"},
        }},
        {"3.0", "(SurtzyX)", {
            {"[NEW]", "Funcionalidad de cámara estática rehecha desde cero"},
            {"[NEW]", "Añadido Deadzone para evitar movimientos no deseados"},
            {"[NEW]", "Añadida sensibilidad de cámara (fuera de vehículos)"},
            {"[NEW]", "Añadida sensibilidad de cámara (en vehículos)"},
            {"[NEW]", "Añadido checkbox para activar/desactivar cámara estática en vehículos"},
            {"[FIX]", "Corregidos errores de caída de FPS en dispositivos de bajos recursos"},
            {"[FIX]", "Corregido error de la cámara de vehículos subiendo/bajando al detectar toques"},
            {"[FIX]", "Corregido error de temblor al mover la pantalla"},
        }},
        {"2.1", "(SurtzyX, bekasuyy)", {
            {"[NEW]", "Añadido checkbox para activar/desactivar cámara estática en vehículos"},
            {"[FIX]", "Corregido error donde la cámara cambiaba de posición aleatoriamente en vehículos"},
            {"[FIX]", "Corregido crash al hacer clic en los enlaces"},
        }},
        {"2.0", "(SurtzyX, bekasuyy)", {
            {"[NEW]", "Añadida función Fijar Cámara al Apuntar"},
            {"[FIX]", "Corregidos temblores y vibraciones de la cámara estática"},
            {"[NEW]", "Añadida cámara estática dentro de vehículos"},
            {"[NEW]", "Añadida sensibilidad de cámara en vehículos"},
        }},
    },
}

local function corTag(tag)
    if tag == "[NEW]" then return acento()
    elseif tag == "[FIX]" then return v4(1.0, 0.85, 0.0, 1.0)
    elseif tag == "[REMOVIDO]" or tag == "[REMOVED]" then return PAL.vermelho
    end
    return PAL.cinza
end

local Downloads = {
    {ver = "New Versions", url = "https://youtube.com/@surtzyx07"},
    {ver = "3.0.1", url = "https://seulink.net/camV3-1"},
    {ver = "3.0",   url = "https://seulink.net/camV3"},
    {ver = "2.1",   url = "https://seulink.net/camV2-1"},
    {ver = "2.0",   url = "https://seulink.net/camV2"},
}

surtzy.imguiscroll = {}
local function scrollbar(id, tam)
    local io = imgui.GetIO()
    if not io then return end
    local mp = io.MousePos
    if not surtzy.imguiscroll[id] then surtzy.imguiscroll[id] = {s=0, ativo=false, ly=0, vel=0, permitir=true} end
    local d = surtzy.imguiscroll[id]
    imgui.BeginChild(id, tam, false, bit.bor(imgui.WindowFlags.NoScrollbar, imgui.WindowFlags.NoScrollWithMouse, imgui.WindowFlags.NoMove))
    local sobrejanela = imgui.IsWindowHovered(imgui.HoveredFlags.ChildWindows)
    if d.permitir and sobrejanela and io.MouseDown[0] and not imgui.IsAnyItemActive() and not d.ativo then
        d.ativo = true
        d.ly = mp.y
        d.vel = 0
    end
    if not io.MouseDown[0] and d.ativo then d.ativo = false end
    local ms = imgui.GetScrollMaxY()
    if d.permitir and d.ativo then
        local dy = d.ly - mp.y
        d.ly = mp.y
        d.s = d.s + dy
        d.vel = dy
    elseif math.abs(d.vel) > 0.1 then
        d.s = d.s + d.vel
        d.vel = d.vel * 0.9
    else
        d.vel = 0
    end
    if d.s < 0 then d.s = 0 end
    if ms < d.s then d.s = ms end
    imgui.SetScrollY(d.s)
    d.permitir = true
end

local function rotulocampo(l)
    imgui.TextColored(PAL.cinza, l)
    imgui.Spacing()
end

local function sliderfloat(l, vv, mn, mx, fmt, idunico)
    fmt = fmt or "%.3f"
    rotulocampo(l)
    imgui.PushItemWidth(imgui.GetContentRegionAvail().x)
    local id = "##slf_" .. (idunico or l:gsub(" ", "_"))
    imgui.PushStyleColor(imgui.Col.FrameBg, PAL.campo)
    imgui.PushStyleColor(imgui.Col.FrameBgHovered, v4(0.16,0.16,0.17,1))
    imgui.PushStyleColor(imgui.Col.FrameBgActive, v4(0.18,0.18,0.19,1))
    imgui.PushStyleColor(imgui.Col.SliderGrab, acento())
    imgui.PushStyleColor(imgui.Col.SliderGrabActive, acento())
    if imgui.SliderFloat(id, vv, mn, mx, fmt) then salvar() end
    imgui.PopStyleColor(5)
    imgui.PopItemWidth()
    imgui.Dummy(v2(1, 14*surtzy.mds))
end

local function checkboxs(l, est, uid)
    local dl = imgui.GetWindowDrawList()
    local lado = 22*surtzy.mds
    local ts = imgui.CalcTextSize(l)
    local altural = math.max(lado, ts.y)
    local p = imgui.GetCursorScreenPos()
    local py = p.y + (altural-lado)*0.5

    local corborda = est and acentoU32(1) or cor(0.42,0.42,0.45,0.8)
    local corfundo = est and acentoU32(0.16) or cor(0,0,0,0)
    dl:AddRectFilled(v2(p.x,py), v2(p.x+lado,py+lado), corfundo, 5)
    dl:AddRect(v2(p.x,py), v2(p.x+lado,py+lado), corborda, 5, 15, 1.5)
    if est then
        local cc = acentoU32(1)
        dl:AddLine(v2(p.x+lado*0.24,py+lado*0.54), v2(p.x+lado*0.42,py+lado*0.74), cc, 2)
        dl:AddLine(v2(p.x+lado*0.42,py+lado*0.74), v2(p.x+lado*0.78,py+lado*0.28), cc, 2)
    end

    imgui.InvisibleButton("##chk"..uid, v2(lado, altural))
    local clicado = imgui.IsItemClicked()

    dl:AddText(v2(p.x+lado+10*surtzy.mds, p.y+(altural-ts.y)*0.5), imgui.ColorConvertFloat4ToU32(PAL.branco), l)

    if clicado then return not est end
    return est
end

local function botao(rotulo, id, largura, altura, corTexto)
    imgui.PushStyleColor(imgui.Col.Button, PAL.campo)
    imgui.PushStyleColor(imgui.Col.ButtonHovered, v4(0.17,0.17,0.18,1))
    imgui.PushStyleColor(imgui.Col.ButtonActive, v4(0.09,0.09,0.10,1))
    imgui.PushStyleColor(imgui.Col.Text, corTexto or PAL.branco)
    local clicado = imgui.Button(rotulo.."##"..id, v2(largura, altura))
    imgui.PopStyleColor(4)
    return clicado
end

local wdl = nil
local largjanela = 0
local altjanela = 0
local abaAtiva = surtzy.novo.int(1)
local yindicador = surtzy.novo.float(0)
surtzy.interface = surtzy.novo.bool(false)

local mostrarCred = false
local inicioCred = 0
local duracaoCred = 60.0
local spawnado = false

local LARG_SIDEBAR = 150

local function idIoma(wp, ws)
    local nomeslang = ffi.new("const char*[3]", {"BR","EN","ES"})
    local wsel = 68*surtzy.mds
    local hsel = 24*surtzy.mds
    local xsel = ws.x - wsel - 16*surtzy.mds
    local ysel = 12*surtzy.mds
    local est2 = imgui.GetStyle()
    local prr = est2.FrameRounding
    local prpr = est2.PopupRounding
    est2.FrameRounding = hsel*0.35
    est2.PopupRounding = 6
    imgui.PushStyleColor(imgui.Col.FrameBg, PAL.campo)
    imgui.PushStyleColor(imgui.Col.FrameBgHovered, v4(0.16,0.16,0.17,1))
    imgui.PushStyleColor(imgui.Col.FrameBgActive, v4(0.18,0.18,0.19,1))
    imgui.PushStyleColor(imgui.Col.Button, PAL.campo)
    imgui.PushStyleColor(imgui.Col.ButtonHovered, v4(0.16,0.16,0.17,1))
    imgui.PushStyleColor(imgui.Col.PopupBg, v4(0.09,0.09,0.10,0.98))
    imgui.PushStyleColor(imgui.Col.Header, acento(0.4))
    imgui.PushStyleColor(imgui.Col.HeaderHovered, acento(0.55))
    imgui.PushStyleColor(imgui.Col.Text, PAL.branco)
    imgui.SetCursorPos(v2(xsel, ysel))
    imgui.PushItemWidth(wsel)
    if imgui.Combo("##camstz2", sidioma, nomeslang, 3) then salvar() end
    imgui.PopItemWidth()
    imgui.PopStyleColor(9)
    est2.FrameRounding = prr
    est2.PopupRounding = prpr
end

local function painelesquerdo(wp, ws, topoy)
    local dl = wdl
    dl:AddRectFilled(v2(wp.x, wp.y+topoy), v2(wp.x+LARG_SIDEBAR*surtzy.mds, wp.y+ws.y), imgui.ColorConvertFloat4ToU32(PAL.sidebar), 0)
    dl:AddLine(v2(wp.x+LARG_SIDEBAR*surtzy.mds, wp.y+topoy), v2(wp.x+LARG_SIDEBAR*surtzy.mds, wp.y+ws.y), imgui.ColorConvertFloat4ToU32(PAL.linha), 1)

    local yT = wp.y+topoy+16*surtzy.mds
    local xT = wp.x+18*surtzy.mds
    local t1, t2, t3 = t("titulo1"), t("titulo2"), t("titulo3")
    dl:AddText(v2(xT, yT), imgui.ColorConvertFloat4ToU32(PAL.branco), t1.." ")
    xT = xT + imgui.CalcTextSize(t1.." ").x
    dl:AddText(v2(xT, yT), acentoU32(1), t2.." ")
    xT = xT + imgui.CalcTextSize(t2.." ").x
    dl:AddText(v2(xT, yT), imgui.ColorConvertFloat4ToU32(PAL.branco), t3)

    local versaoText = t("ver")
    local compatText = compatibilidade
    local versaoY = wp.y+topoy+34*surtzy.mds
    local compatY = wp.y+topoy+50*surtzy.mds
    
    dl:AddText(v2(wp.x+18*surtzy.mds, versaoY), imgui.ColorConvertFloat4ToU32(PAL.cinza), versaoText)
    dl:AddText(v2(wp.x+18*surtzy.mds, compatY), acentoU32(0.7), compatText)
    
    dl:AddLine(v2(wp.x+18*surtzy.mds, wp.y+topoy+64*surtzy.mds), v2(wp.x+LARG_SIDEBAR*surtzy.mds-18*surtzy.mds, wp.y+topoy+64*surtzy.mds), imgui.ColorConvertFloat4ToU32(PAL.linha), 1)

    local itens = {t("geral"), t("baixarversoes"), t("sobre")}
    local yitem = topoy + 80*surtzy.mds
    local hitem = 40*surtzy.mds
    local xitem = 10*surtzy.mds
    local witem = LARG_SIDEBAR*surtzy.mds - 20*surtzy.mds

    local dt = imgui.GetIO().DeltaTime or 0.016
    local k = 1.0 - math.exp(-dt*16.0)
    local alvoY = (abaAtiva[0]-1)*hitem
    yindicador[0] = yindicador[0] + (alvoY - yindicador[0]) * k

    dl:AddRectFilled(v2(wp.x+xitem, wp.y+yitem+yindicador[0]), v2(wp.x+xitem+witem, wp.y+yitem+yindicador[0]+hitem), imgui.ColorConvertFloat4ToU32(PAL.campo), 6)
    dl:AddRectFilled(v2(wp.x+xitem, wp.y+yitem+yindicador[0]+6*surtzy.mds), v2(wp.x+xitem+3*surtzy.mds, wp.y+yitem+yindicador[0]+hitem-6*surtzy.mds), acentoU32(1), 2)

    for i, nome in ipairs(itens) do
        local iy = yitem + (i-1)*hitem
        imgui.SetCursorScreenPos(v2(wp.x+xitem, wp.y+iy))
        if imgui.InvisibleButton("##nav"..i, v2(witem, hitem)) then abaAtiva[0] = i end
        local ts = imgui.CalcTextSize(nome)
        local corTx = (abaAtiva[0]==i) and imgui.ColorConvertFloat4ToU32(PAL.branco) or imgui.ColorConvertFloat4ToU32(PAL.cinza)
        dl:AddText(v2(wp.x+xitem+16*surtzy.mds, wp.y+iy+(hitem-ts.y)*0.5), corTx, nome)
    end

    local ytema = ws.y - 140*surtzy.mds
    dl:AddLine(v2(wp.x+18*surtzy.mds, wp.y+ytema), v2(wp.x+LARG_SIDEBAR*surtzy.mds-18*surtzy.mds, wp.y+ytema), imgui.ColorConvertFloat4ToU32(PAL.linha), 1)
    dl:AddText(v2(wp.x+18*surtzy.mds, wp.y+ytema+10*surtzy.mds), imgui.ColorConvertFloat4ToU32(PAL.cinza), t("corinterface"))

    local xbolinha = 18*surtzy.mds
    local ybolinha = ytema + 30*surtzy.mds
    local raiobolinha = 9*surtzy.mds
    local colunas = 4
    local espaco = (LARG_SIDEBAR*surtzy.mds - 20*surtzy.mds - (colunas * raiobolinha * 2)) / colunas
    if espaco < 10*surtzy.mds then espaco = 10*surtzy.mds end

    for i, tm in ipairs(TEMAS) do
        local col = (i - 1) % colunas
        local linha = math.floor((i - 1) / colunas)
        local cx = wp.x + 18*surtzy.mds + col * (raiobolinha * 2 + espaco) + raiobolinha
        local cy = wp.y + ybolinha + linha * (raiobolinha * 2 + 12*surtzy.mds) + raiobolinha
        imgui.SetCursorScreenPos(v2(cx-raiobolinha-4*surtzy.mds, cy-raiobolinha-4*surtzy.mds))
        if imgui.InvisibleButton("##tm"..i, v2((raiobolinha+4*surtzy.mds)*2, (raiobolinha+4*surtzy.mds)*2)) then
            tmatual[0] = i-1
            salvar()
        end
        dl:AddCircleFilled(v2(cx,cy), raiobolinha, cor(tm.r,tm.g,tm.b,1), 20)
        if tmatual[0] == i-1 then
            dl:AddCircle(v2(cx,cy), raiobolinha+3*surtzy.mds, imgui.ColorConvertFloat4ToU32(PAL.branco), 20, 1.6)
        end
    end
end

local function abadownload()
    imgui.TextColored(PAL.branco, t("baixarversoes"))
    imgui.Dummy(v2(1, 10*surtzy.mds))
    local cw = imgui.GetContentRegionAvail().x
    for i, item in ipairs(Downloads) do
        imgui.PushStyleColor(imgui.Col.Button, PAL.campo)
        imgui.PushStyleColor(imgui.Col.ButtonHovered, v4(0.17,0.17,0.18,1))
        imgui.PushStyleColor(imgui.Col.ButtonActive, v4(0.09,0.09,0.10,1))
        imgui.PushStyleColor(imgui.Col.Text, PAL.branco)
        if imgui.Button((sc and (fa.DOWNLOAD.."  ") or "").."v"..item.ver.."##dl"..i, v2(cw, 36*surtzy.mds)) then
            execlink(item.url)
        end
        imgui.PopStyleColor(4)
        imgui.Dummy(v2(1, 8*surtzy.mds))
    end
end

local function abasobre()
    imgui.TextColored(PAL.branco, t("sobre"))
    imgui.Dummy(v2(1, 6*surtzy.mds))
    imgui.TextColored(PAL.cinzaclaro, t("autores"))
    imgui.Dummy(v2(1, 14*surtzy.mds))

    local cw = imgui.GetContentRegionAvail().x
    local bh = 34*surtzy.mds
    local bw = (cw - 8*surtzy.mds) * 0.5

    local function botaocreditos(rotulo, icone, corIcone, url, largura)
        local dl = imgui.GetWindowDrawList()
        imgui.PushStyleColor(imgui.Col.Button, PAL.campo)
        imgui.PushStyleColor(imgui.Col.ButtonHovered, v4(0.17,0.17,0.18,1))
        imgui.PushStyleColor(imgui.Col.ButtonActive, v4(0.09,0.09,0.10,1))
        if sc and icone then
            local tamicone = imgui.CalcTextSize(icone)
            local tamtexto = imgui.CalcTextSize(rotulo)
            local largtot = tamicone.x + 6*surtzy.mds + tamtexto.x
            local clicado = imgui.Button("##btn_"..rotulo, v2(largura, bh))
            imgui.PopStyleColor(3)
            if clicado then execlink(url) end
            local bp = imgui.GetItemRectMin()
            local bsz = imgui.GetItemRectSize()
            local xini = bp.x + (bsz.x - largtot)*0.5
            local yicone = bp.y + (bsz.y - tamicone.y)*0.7
            local ytexto = bp.y + (bsz.y - tamtexto.y)*0.5
            dl:AddText(v2(xini, yicone), imgui.ColorConvertFloat4ToU32(corIcone), icone)
            dl:AddText(v2(xini+tamicone.x+6*surtzy.mds, ytexto), imgui.ColorConvertFloat4ToU32(PAL.branco), rotulo)
        else
            local clicado = imgui.Button(rotulo.."##btn_"..rotulo, v2(largura, bh))
            imgui.PopStyleColor(3)
            if clicado then execlink(url) end
        end
    end

    botaocreditos(t("yt"), sc and sc.YOUTUBE, PAL.vermelho, t("yturl"), bw)
    imgui.SameLine(nil, 8*surtzy.mds)
    botaocreditos(t("dc"), sc and sc.DISCORD, PAL.azul, t("dcurl"), bw)

    imgui.Dummy(v2(1, 18*surtzy.mds))
    imgui.TextColored(PAL.branco, t("changelogs"))
    imgui.Dummy(v2(1, 8*surtzy.mds))
    
    local larguraDisponivel = imgui.GetContentRegionAvail().x - 20 * surtzy.mds
    imgui.PushTextWrapPos(larguraDisponivel)
    
    local lista = changelogs[sidioma[0]] or changelogs[0]
    for _, blocoVersao in ipairs(lista) do
        local numVer = blocoVersao[1]
        local autoVer = blocoVersao[2]
        local itens = blocoVersao[3]
        imgui.TextColored(acento(), "v"..numVer.." "..autoVer)
        for _, item in ipairs(itens) do
            local tag = item[1]
            local texto = item[2]
            if tag then
                imgui.TextColored(corTag(tag), tag)
                imgui.SameLine()
                imgui.TextWrapped(texto)
            else
                imgui.TextWrapped(texto or "")
            end
        end
        imgui.Dummy(v2(1, 10*surtzy.mds))
    end
    
    imgui.PopTextWrapPos()
end

local function conttent(aba)
    if aba == 1 then
        imgui.TextColored(PAL.branco, t("geral"))
        imgui.Dummy(v2(1, 14*surtzy.mds))
        sliderfloat(t("sensibilidadecamera"), fsensibilidadecamera, 1.0, 10.0, "%.1f", "senscam")
        sliderfloat(t("smooth"), fsmooth, 0.01, 0.20, "%.2f", "smooth")
        
        imgui.Dummy(v2(1, 4*surtzy.mds))
        local vv = checkboxs(t("cameraveh"), chkcameraveh[0], "camveh")
        if vv ~= chkcameraveh[0] then chkcameraveh[0] = vv; salvar() end
        if chkcameraveh[0] then
            imgui.Dummy(v2(1, 16*surtzy.mds))
            sliderfloat(t("sensibilidadeveiculo"), fsensibilidadeveiculo, 1.0, 10.0, "%.1f", "sensveh")
            sliderfloat(t("deadzone"), fDeadzone, 0.00, 0.2, "%.3f", "deadzone")
        end
        imgui.Dummy(v2(1, 4*surtzy.mds))
        local ss = checkboxs(t("semshake"), chksemshake[0], "semshake")
        if ss ~= chksemshake[0] then chksemshake[0] = ss; salvar() end
        imgui.Dummy(v2(1, 4*surtzy.mds))
        local fm = checkboxs(t("fixarmira"), chkfixarmira[0], "fixarmira")
        if fm ~= chkfixarmira[0] then chkfixarmira[0] = fm; salvar() end
        imgui.Dummy(v2(1, 4*surtzy.mds))
        local lb = checkboxs(t("looksback"), chklookback[0], "looksback")
        if lb ~= chklookback[0] then chklookback[0] = lb; salvar() end
    elseif aba == 2 then
        abadownload()
    elseif aba == 3 then
        abasobre()
    end
end
imgui.OnFrame(function() return surtzy.interface[0] end, function()
    local rx, ry = getScreenResolution()
    if rx==0 or ry==0 then return end
    largjanela = 620 * surtzy.mds
    altjanela = 560 * surtzy.mds
    imgui.SetNextWindowPos(v2(rx/2, ry/2), imgui.Cond.FirstUseEver, v2(0.5, 0.5))
    imgui.SetNextWindowSize(v2(largjanela, altjanela), imgui.Cond.Always)
    if surtzy.fui then imgui.PushFont(surtzy.fui) else imgui.PushFont(imgui.GetIO().Fonts:AddFontDefault()) end
    local wf = imgui.WindowFlags
    if not imgui.Begin("##OMelhorSempre", nil, bit.bor(wf.NoCollapse, wf.NoResize, wf.NoTitleBar)) then
        imgui.PopFont(); imgui.End(); return
    end
    wdl = imgui.GetWindowDrawList()
    if not wdl then imgui.PopFont(); imgui.End(); return end
    local wp = imgui.GetWindowPos()
    local ws = imgui.GetWindowSize()
    wdl:AddRectFilled(wp, v2(wp.x+ws.x, wp.y+ws.y), imgui.ColorConvertFloat4ToU32(PAL.fundo), 6)

    local topoy = 0

    painelesquerdo(wp, ws, topoy)
    idIoma(wp, ws)

    local xconteudo = LARG_SIDEBAR*surtzy.mds + 20*surtzy.mds
    local yconteudo = 42*surtzy.mds
    local largconteudo = ws.x - xconteudo - 18*surtzy.mds
    local altfechar = 40*surtzy.mds
    local altconteudo = ws.y - yconteudo - altfechar - 14*surtzy.mds

    imgui.SetCursorPos(v2(xconteudo, yconteudo))
    imgui.PushStyleColor(imgui.Col.ChildBg, v4(0,0,0,0))
    scrollbar("main", v2(largconteudo, altconteudo))
    conttent(abaAtiva[0])
    imgui.Dummy(v2(1, 10*surtzy.mds))
    imgui.EndChild()
    imgui.PopStyleColor()

    wdl:AddLine(v2(wp.x+xconteudo, wp.y+ws.y-altfechar-8*surtzy.mds), v2(wp.x+xconteudo+largconteudo, wp.y+ws.y-altfechar-8*surtzy.mds), imgui.ColorConvertFloat4ToU32(PAL.linha), 1)

    local btnw = 120*surtzy.mds
    local btnh = altfechar - 10*surtzy.mds
    imgui.SetCursorPos(v2(xconteudo+largconteudo-btnw, ws.y - altfechar))
    if botao("Fechar", "fechar", btnw, btnh, PAL.cinzaclaro) then
        surtzy.interface[0] = false
    end

    imgui.PopFont()
    imgui.End()
end)
local function progresscircular(dl, valor, corcirc, centro, raio, espessura)
    if valor > 100.0 then valor = 100.0 elseif valor < 0.0 then valor = 0.0 end
    local angulo = (valor / 100.0) * 2 * math.pi
    local segs   = 60
    local passo2 = (2 * math.pi) / segs
    dl:AddCircleFilled(centro, raio+3, 0xAA0d0d0d, segs)
    dl:AddCircle(centro, raio+3, 0x55333333, segs, 2)
    for i = 0, segs do
        local a = passo2 * i
        if a <= angulo then
            local p1 = v2(centro.x - raio*math.sin(a),        centro.y - raio*math.cos(a))
            local p2 = v2(centro.x - raio*math.sin(a+passo2), centro.y - raio*math.cos(a+passo2))
            dl:AddLine(p1, p2, corcirc, espessura)
        end
    end
    dl:AddText(v2(centro.x-3, centro.y-13), corcirc, "i")
end

local function creditos()
    if not mostrarCred then return end
    local decorrido = os.clock() - inicioCred
    if decorrido > duracaoCred then mostrarCred = false; return end
    local sw, _ = getScreenResolution()
    local prog  = 100.0 - ((decorrido / duracaoCred) * 100.0)
    local larg  = 490
    local alt   = 190
    local px    = sw - larg - 20
    local py    = 50
    local acentcor = acentoU32(1)
    local fundo = imgui.ColorConvertFloat4ToU32(v4(0.06,0.06,0.07,0.96))
    local sec   = imgui.ColorConvertFloat4ToU32(PAL.cinzaclaro)
    local dl    = imgui.GetBackgroundDrawList()
    dl:AddRectFilled(v2(px,py), v2(px+larg,py+alt), fundo, 10)
    dl:AddRectFilled(v2(px,py), v2(px+8,py+alt), acentcor, 10, 1)
    local tY = py + 26
    if sc then dl:AddText(v2(px+40, tY), acentcor, fa.VIDEO) end
    dl:AddText(v2(px+85, tY), imgui.ColorConvertFloat4ToU32(PAL.branco), "CÂMERA ESTÁTICA PC 4.0 FINAL")
    progresscircular(dl, prog, acentcor, v2(px+larg-55, py+34), 16, 4)
    local cy  = py + 75
    local cx  = px + 35
    local dtx = 38
    if sc then dl:AddText(v2(cx, cy), acentcor, fa.USER) end
    dl:AddText(v2(cx+dtx, cy), sec, "Autor: ")
    dl:AddText(v2(cx+dtx + imgui.CalcTextSize("Autor: ").x, cy), acentcor, "SurtzyX")

    local function linkClic(y, icone, prefixo, usuario, linkUrl)
        if sc then dl:AddText(v2(cx, y), acentcor, icone) end
        dl:AddText(v2(cx+dtx, y), sec, prefixo)
        local nx = cx+dtx + imgui.CalcTextSize(prefixo).x
        dl:AddText(v2(nx, y), acentcor, usuario)
        local largTxt = imgui.CalcTextSize(prefixo..usuario).x
        local hover = (function(x,yy,w,h)
            local mx, my = imgui.GetMousePos().x, imgui.GetMousePos().y
            return mx >= x and mx <= x+w and my >= yy and my <= yy+h
        end)(cx+dtx, y, largTxt, 18)
        if hover then
            dl:AddLine(v2(cx+dtx,y+16), v2(cx+dtx+largTxt,y+16), acentcor, 1.5)
            if imgui.IsMouseClicked(0) then execlink(linkUrl) end
        end
    end

    linkClic(cy+38, fa.HEART, "YouTube: ",  "@SurtzyX07",    'https://youtube.com/@surtzyx07?si=q27yOKVnXgUsnTHY')
    linkClic(cy+68, fa.LINK,  "Discord: ",  "discord.gg/gustax", 'https://discord.gg/gustax-mods-halloween-1225929838116864011')
end

imgui.OnFrame(function() return mostrarCred end, function(self)
    self.HideCursor = false
    if isSampAvailable() and sampIsLocalPlayerSpawned() and not spawnado then
        spawnado = true
        mostrarCred = false
        return
    end
    creditos()
end)

imgui.OnInitialize(function()
    imgui.SwitchContext()
    surtzy.largtela, surtzy.alttela = getScreenResolution()
    local fio = imgui.GetIO().Fonts
    if not fio then return end
    fio:Clear()

    local pastafontes = getWorkingDirectory().."/resource/fonts/"
    local ttfui = pastafontes.."fontimgui.ttf"
    local tamui = math.floor(18 * surtzy.mds)

    if doesFileExist(ttfui) then
        surtzy.fui = fio:AddFontFromFileTTF(ttfui, tamui)
    else
        surtzy.fui = fio:AddFontDefault()
    end

    local cfgf = imgui.ImFontConfig(); cfgf.MergeMode = true; cfgf.PixelSnapH = true
    local farange = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    fio:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), tamui, cfgf, farange)

    if sc then
        local sccfg = imgui.ImFontConfig(); sccfg.MergeMode = true; sccfg.PixelSnapH = true
        local scrange = imgui.new.ImWchar[3](sc.min_range, sc.max_range, 0)
        fio:AddFontFromMemoryCompressedBase85TTF(sc.get_font_data_base85(), tamui, sccfg, scrange)
    end

    if doesFileExist(ttfui) then
        surtzy.ftexto = fio:AddFontFromFileTTF(ttfui, math.floor(13 * surtzy.mds))
    end
    if not surtzy.ftexto then surtzy.ftexto = surtzy.fui end

    local st = imgui.GetStyle()
    if not st then return end
    st:ScaleAllSizes(surtzy.dpi)
    st.WindowRounding = 6; st.ChildRounding = 4; st.FrameRounding = 4
    st.GrabRounding = 4; st.ScrollbarRounding = 4; st.PopupRounding = 4
    st.ScrollbarSize = 5
    st.AntiAliasedFill = true
    st.WindowPadding = imgui.ImVec2(0, 0)
    st.FramePadding = imgui.ImVec2(9*surtzy.mds, 6*surtzy.mds)
    st.ItemSpacing = imgui.ImVec2(8*surtzy.mds, 8*surtzy.mds)
    imgui.GetIO().IniFilename = nil
    local cl = imgui.Col
    local v4b = imgui.ImVec4
    st.Colors[cl.Text] = v4b(0.95,0.95,0.96,1)
    st.Colors[cl.WindowBg] = v4b(0.07,0.07,0.08,0.98)
    st.Colors[cl.ChildBg] = v4b(0,0,0,0)
    st.Colors[cl.Border] = v4b(1,1,1,0.06)
    st.Colors[cl.FrameBg] = v4b(0.13,0.13,0.14,1)
    st.Colors[cl.FrameBgHovered] = v4b(0.16,0.16,0.17,1)
    st.Colors[cl.FrameBgActive] = v4b(0.18,0.18,0.19,1)
    st.Colors[cl.Button] = v4b(0.13,0.13,0.14,1)
    st.Colors[cl.ButtonHovered] = v4b(0.17,0.17,0.18,1)
    st.Colors[cl.ButtonActive] = v4b(0.09,0.09,0.10,1)
    st.Colors[cl.Separator] = v4b(1,1,1,0.06)
    st.Colors[cl.ScrollbarBg] = v4b(0,0,0,0)
    st.Colors[cl.ScrollbarGrab] = v4b(0.30,0.30,0.32,0.6)
    st.Colors[cl.ScrollbarGrabHovered] = v4b(0.45,0.45,0.47,0.7)
    st.Colors[cl.ScrollbarGrabActive] = v4b(0.55,0.55,0.57,0.9)
    st.Colors[cl.PopupBg] = v4b(0.09,0.09,0.10,0.98)
end)

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end

    alterarsensibilidade()

    inicioCred = os.clock()
    mostrarCred = true

    local function args()
        surtzy.interface[0] = not surtzy.interface[0]
    end
    sampRegisterChatCommand("cam", args)
    sampRegisterChatCommand("campc", args)
    sampRegisterChatCommand("ccam", args)

    while true do wait(0) end
end

script_authors("SurtzyX")
script_name("Câmera Estática PC")
script_version("4.0 Final \nMoon Version: Monetloader 3.6.0-os \nCompatibility: Armeabi-v7a (32-bit)")
script_description("cmd: /cam")
script_url("https://youtube.com/@surtzyx07")]=])()
