 
local PRIVATE_TESTER_BUILD_ACTIVATED=true
if not PRIVATE_TESTER_BUILD_ACTIVATED then warn("Cokeboys: tester build has not been published yet") return end
local PRIVATE_VARIANT="experimental"
local PRIVATE_SCRIPT_ID="42994397723806383201"
local PRIVATE_BRIDGE_PATH="/luaprot/experimental/resolve"
local PRIVATE_BRIDGE_URL="https://cokeboys-luaprot-pilot.cokeboysclient.workers.dev"
 
 
do
    local environment=getgenv()
    local pending=environment.__CokeboysLuaProtPendingStart
    if type(pending)=="table" and pending.JobId==tostring(game.JobId)
        and environment.__CokeboysLuaProtSession==nil then
        warn(pending.Failed and "Cokeboys: loading did not finish. Rejoin before trying again."
            or "Cokeboys: authentication is already starting. Please wait; do not execute again.")
        return
    end
end

 
local function installCokeboysAuthNotice()
    local environment=getgenv()
    local previous=environment.LP_CUSTOM_LOADER
     
     
    if type(environment.CokeboysGuiHidden)~="boolean" then
        local function readPreferences(file)
            if type(readfile)~="function" then return nil end
            local ok,value=pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(file)) end)
            return ok and type(value)=="table" and value or nil
        end
        local legacy=readPreferences("CokeboysConfig_v1.json")
        local store=readPreferences("CokeboysProfiles_v1.json")
        local profile
        if store and type(store.profiles)=="table" and type(store.order)=="table" then
            profile=store.profiles[tostring(store.active or "")]
            if type(profile)~="table" then
                for _,id in ipairs(store.order) do
                    if type(store.profiles[tostring(id)])=="table" then profile=store.profiles[tostring(id)] break end
                end
            end
        end
        local preferences=type(profile)=="table" and type(profile.config)=="table" and profile.config or legacy
        environment.CokeboysGuiHidden=type(preferences)=="table"
            and preferences.RememberGuiHidden==true and preferences.GuiHidden==true or false
    end
    local gui=Instance.new("ScreenGui")
    gui.Enabled=environment.CokeboysGuiHidden~=true
    gui.Name="CokeboysAuthLoading";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true
    gui.DisplayOrder=1009;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local card=Instance.new("Frame");card.Name="Card";card.Active=false;card.BorderSizePixel=0
    card.BackgroundColor3=Color3.fromRGB(18,18,23);card.Size=UDim2.fromOffset(math.min(390,math.max(160,viewport.X-32)),104)
    card.AnchorPoint=Vector2.new(0.5,0);card.Position=UDim2.new(0.5,0,0,math.min(82,math.max(8,viewport.Y-112)));card.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,9);corner.Parent=card
    local border=Instance.new("UIStroke");border.Color=Color3.fromRGB(64,62,68);border.Thickness=1;border.Parent=card
    local title=Instance.new("TextLabel");title.Name="Title";title.BackgroundTransparency=1
    title.Position=UDim2.fromOffset(14,10);title.Size=UDim2.new(1,-28,0,22)
    title.Font=Enum.Font.GothamBold;title.TextSize=17;title.TextXAlignment=Enum.TextXAlignment.Left
    title.TextColor3=Color3.fromRGB(255,212,55);title.Text="COKEBOYS";title.Parent=card
    local body=Instance.new("TextLabel");body.Name="Message";body.BackgroundTransparency=1
    body.Position=UDim2.fromOffset(14,35);body.Size=UDim2.new(1,-28,0,48)
    body.Font=Enum.Font.Gotham;body.TextSize=14;body.TextWrapped=true;body.TextXAlignment=Enum.TextXAlignment.Left
    body.TextColor3=Color3.fromRGB(240,240,245);body.Text="Wait like a good boy… checking your access.";body.Parent=card
    local track=Instance.new("Frame");track.BorderSizePixel=0;track.BackgroundColor3=Color3.fromRGB(45,44,50)
    track.Position=UDim2.new(0,14,1,-12);track.Size=UDim2.new(1,-28,0,3);track.Parent=card
    local bar=Instance.new("Frame");bar.BorderSizePixel=0;bar.BackgroundColor3=title.TextColor3
    bar.Size=UDim2.new(0.15,0,1,0);bar.Parent=track
    gui.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local closed,finished=false,false
    local callback,manager
    local function cleanup()
        if closed then return end;closed=true
        if environment.LP_CUSTOM_LOADER==callback then environment.LP_CUSTOM_LOADER=previous end
        if environment.__CokeboysAuthNotice==manager then environment.__CokeboysAuthNotice=nil end
        gui:Destroy()
    end
    local function finish()
        if closed or finished then return end;finished=true
        body.Text="Access confirmed. Starting Cokeboys…";bar.Size=UDim2.new(1,0,1,0)
        task.delay(3,cleanup)
    end
    callback=function(stepOrTime)
        if closed or finished then return end
        if stepOrTime==1 then
            body.Text="Wait like a good boy… checking your access.";bar.Size=UDim2.new(0.3,0,1,0)
        elseif stepOrTime==2 then
            body.Text="Connecting securely… almost there.";bar.Size=UDim2.new(0.65,0,1,0)
        elseif type(stepOrTime)=="number" then finish() end
    end
    environment.LP_CUSTOM_LOADER=callback
     
     
    task.delay(90,cleanup)
    manager={finish=finish,cleanup=cleanup,setVisible=function(visible)
        if not closed then gui.Enabled=visible==true end
    end,waiting=function(seconds)
        if closed or finished then return end
        body.Text="Lots of people are loading. Hang tight… retrying in "..tostring(seconds).."s."
    end,fail=function()
        if closed then return end;finished=true
        body.Text="Couldn’t finish loading. Please try again.";bar.BackgroundColor3=Color3.fromRGB(255,105,105)
        task.delay(5,cleanup)
    end}
    environment.__CokeboysAuthNotice=manager
    return manager
end

 
 
getgenv().__CokeboysPVPLaunchJobId=tostring(game.JobId)

 
 
 
 

 
 
 

local WORKER_URL    = "https://cokeboys-token.cokeboysclient.workers.dev"
local LINKVERTISE   = "https://linktr.ee/cokeboysclient"
local DISCORD_INVITE = "https://discord.gg/VfEn7Zywmd"
local KEY_FILE      = "cokeboys_tester_experimental_key.txt"
local SETTINGS_FILE = "CokeboysConfig_v1.json"
local LANGUAGE_FILE = "CokeboysLanguage_v1.json"
local LOADER_PREFERENCE_FILE = "CokeboysLoader_v1.json"
local KEY_PAGE_BACKGROUND_ASSET = "rbxassetid://88742259971314"
local GAME_NAME     = "bloxfruits"
local AUTH_REQUEST_TIMEOUT = 12
local AUTH_REQUEST_ATTEMPTS = 3
local AUTH_TRANSIENT_RETRY_BASE_DELAY = 1.25
local AUTH_TRANSIENT_RETRY_MAX_DELAY = 4

 
 
 
local function runHttpRequestBeforeDeadline(callback,deadline)
    if os.clock()>=deadline then return false,nil,true end
    local settled=false
    local callOk,result
    local thread=task.spawn(function()
        local ok,value=pcall(callback)
        if settled then return end
        callOk,result=ok,value
        settled=true
    end)
    while not settled do
        if os.clock()>=deadline then
            settled=true
            pcall(task.cancel,thread)
            return false,nil,true
        end
        task.wait(0.05)
    end
    return callOk,result,false
end

local function responseBodyFromRequest(result)
    if type(result)=="string" and result~="" then return result end
    if type(result)~="table" then return nil end
    local rawStatus=result.StatusCode
    if rawStatus==nil then rawStatus=result.status_code end
    if rawStatus==nil then rawStatus=result.Status end
    if rawStatus==nil then rawStatus=result.status end
    if rawStatus~=nil then
        local status=tonumber(rawStatus)
        if not status or status<200 or status>=300 then return nil end
    end
    local body=result.Body or result.body
    if type(body)=="string" and body~="" then return body end
    return nil
end

local function httpGet(url)
    local requestFunctions = {}
    local function addRequestFunction(fn)
        if type(fn) == "function" then
            table.insert(requestFunctions, fn)
        end
    end

    addRequestFunction(syn and syn.request)
    addRequestFunction(http and http.request)
    addRequestFunction(request)
    addRequestFunction(http_request)

    local deadline=os.clock()+AUTH_REQUEST_TIMEOUT
    for _, requestFunction in ipairs(requestFunctions) do
        local ok,res,timedOut=runHttpRequestBeforeDeadline(function()
            return requestFunction({Url=url,Method="GET"})
        end,deadline)
        if timedOut then return nil end
        if ok then
            local body=responseBodyFromRequest(res)
            if body then return body end
            if type(res)=="table" then
                local rawStatus=res.StatusCode
                if rawStatus==nil then rawStatus=res.status_code end
                if rawStatus==nil then rawStatus=res.Status end
                if rawStatus==nil then rawStatus=res.status end
                if rawStatus~=nil then return nil end
            end
        end
    end

    local ok,result=runHttpRequestBeforeDeadline(function()
        return game:GetService("HttpService"):GetAsync(url, true)
    end,deadline)
    if ok then return result end
    return nil
end

 
 
 
local function getPlayerInfo()
    local lp = game:GetService("Players").LocalPlayer
    local hwid
    local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if ok and id then
        hwid = id
    else
        hwid = tostring(lp.UserId)
    end
    local username = lp.Name
    return hwid, username
end

 
 
 
local function validateKey(key,hwid,username,gameName)
    local H=game:GetService("HttpService")
    local requestFunction=request or http_request or (syn and syn.request) or (http and http.request)
    if type(requestFunction)~="function" then return false,"Connection failed",nil,false end
    local ok,response
     
     
    local retryDeadline=os.clock()+75
    local waitingNotice
    while true do
        ok,response=runHttpRequestBeforeDeadline(function()
            return requestFunction({Url=PRIVATE_BRIDGE_URL..PRIVATE_BRIDGE_PATH,Method="POST",
                Headers={["Content-Type"]="application/json",["Cache-Control"]="no-store"},
                Body=H:JSONEncode({key=key,hwid=hwid,username=username})})
        end,math.min(retryDeadline,os.clock()+AUTH_REQUEST_TIMEOUT))
        local rawStatus=type(response)=="table" and tonumber(response.StatusCode or response.status_code or response.Status or response.status)
        local rawBody=type(response)=="table" and (response.Body or response.body)
        local retryOk,retryData=false,nil
        if rawStatus==503 and type(rawBody)=="string" and #rawBody<=8192 then
            retryOk,retryData=pcall(function() return H:JSONDecode(rawBody) end)
        end
        if not (ok and retryOk and type(retryData)=="table" and retryData.success==false and retryData.reason=="login-busy") then break end
        local seconds=tonumber(retryData.retry_after)
        if not seconds or seconds~=seconds or seconds<1 or seconds>60 then break end
        seconds=math.ceil(seconds)+math.random()*0.75
        if os.clock()+seconds+1>=retryDeadline then break end
        if not waitingNotice then
            local created,notice=pcall(installCokeboysAuthNotice)
            if created then waitingNotice=notice end
        end
        if waitingNotice then pcall(waitingNotice.waiting,math.ceil(seconds)) end
        task.wait(seconds)
    end
    if waitingNotice then pcall(waitingNotice.cleanup) end
    if not ok or type(response)~="table" then return false,"Connection failed",nil,false end
    local status=tonumber(response.StatusCode or response.status_code or response.Status or response.status)
    local body=response.Body or response.body
    if type(body)~="string" or #body>8192 then return false,"Invalid response",nil,false end
    local decoded,data=pcall(function() return H:JSONDecode(body) end)
    if not decoded or type(data)~="table" then return false,"Invalid response",nil,false end
    if status~=200 or data.success~=true then
        local completed=status==200 or status==400 or status==403
        local reasons={expired="Key has expired",banned="Access is banned",["wrong-device"]="Key is linked to another device",
            ["key-removed"]="Key is invalid or no longer available",["whitelist-removed"]="Your username is not whitelisted for this key"}
        local message=completed and (reasons[data.reason] or "Key is invalid or access was denied") or "Access service busy. Wait 60 seconds, then try again. Your key has not changed."
        return false,message,nil,completed
    end
    if data.script_id~=PRIVATE_SCRIPT_ID or type(data.provider_key)~="string"
        or not data.provider_key:match("^[0-9a-f]+$") or #data.provider_key<24 or #data.provider_key>128
        or type(data.legacy)~="table" or type(data.legacy.permanent)~="boolean" then
        return false,"Invalid response",nil,false
    end
    local expires=data.legacy.expires_at
    if not data.legacy.permanent and (type(expires)~="number" or expires%1~=0 or expires<=os.time()) then
        return false,"Key has expired",nil,true
    end
    return true,"Key valid",{success=true,permanent=data.legacy.permanent,
        expires_at=expires,provider_key=data.provider_key,script_id=data.script_id},true
end

 
 
 
local function readFile(path)
    local ok, data = pcall(readfile, path)
    if ok then return data end
    return nil
end

local function writeFile(path, data)
    if type(writefile)~="function" then return false end
    local writeOk,writeResult=pcall(writefile,path,data)
    return writeOk and writeResult~=false
end

local function clearSavedKeyFile()
    if type(delfile)=="function" then
        local exists=true
        if type(isfile)=="function" then
            local checked,result=pcall(isfile,KEY_FILE)
            if checked then exists=result==true end
        end
        if not exists then return true end
        local deleteOk,deleteResult=pcall(delfile,KEY_FILE)
        if deleteOk and deleteResult~=false then return true end
    end
     
     
    return writeFile(KEY_FILE,"")
end

local VALID_EXPERIENCE_IDS={lite=true,full=true}
local function readLoaderPreference()
    local raw=readFile(LOADER_PREFERENCE_FILE)
    if type(raw)~="string" or raw=="" then return nil,"missing" end
    local ok,data=pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
    if not ok or type(data)~="table" then return nil,"corrupt" end
    if data.version~=1 or type(data.rememberExperience)~="boolean"
        or not VALID_EXPERIENCE_IDS[data.experience] then return nil,"invalid" end
    return {version=1,rememberExperience=data.rememberExperience,experience=data.experience},nil
end
local function writeLoaderPreference(experience,rememberExperience)
    if not VALID_EXPERIENCE_IDS[experience] then return false end
    local encodedOk,encoded=pcall(function()
        return game:GetService("HttpService"):JSONEncode({
            version=1,rememberExperience=rememberExperience==true,experience=experience,
        })
    end)
    if not encodedOk then return false end
    local writeOk,writeResult=pcall(writefile,LOADER_PREFERENCE_FILE,encoded)
    return writeOk and writeResult~=false
end
local function bypassRememberedExperience()
    local held=false
    pcall(function()
        local input=game:GetService("UserInputService")
        held=input:IsKeyDown(Enum.KeyCode.LeftShift) or input:IsKeyDown(Enum.KeyCode.RightShift)
    end)
    return held
end

 
 
local LANGUAGE_OPTIONS = {
    {code="Auto",name="Auto Detect"},
    {code="English",name="English"},
    {code="Spanish",name="Español"},
    {code="Portuguese",name="Português (Brasil)"},
    {code="French",name="Français"},
    {code="Vietnamese",name="Tiếng Việt"},
    {code="Indonesian",name="Bahasa Indonesia"},
    {code="Filipino",name="Filipino"},
}
local LANGUAGE_NAMES={}
for _,entry in ipairs(LANGUAGE_OPTIONS) do LANGUAGE_NAMES[entry.code]=entry.name end

local TRANSLATIONS={
    Spanish={
        ["Select the experience you want to use."]="Selecciona la experiencia que quieres usar.",
        ["Enter your access key to continue"]="Introduce tu clave de acceso para continuar", ["Enter your access key to continue to Cokeboys."]="Introduce tu clave de acceso para continuar a Cokeboys.", ["Access key"]="Clave de acceso",
        ["Get Key"]="Obtener clave", ["Click Here to Get a Key"]="Haz clic aquí para obtener una clave", ["Join Discord"]="Únete a Discord", ["Language"]="Idioma", ["Close"]="Cerrar", ["Key accepted"]="Clave aceptada",
        ["Connection unavailable. Try again."]="Conexión no disponible. Inténtalo de nuevo.", ["Unable to verify key. Try again."]="No se pudo verificar la clave. Inténtalo de nuevo.",
        ["Preparing Cokeboys..."]="Preparando Cokeboys...", ["Clipboard unavailable"]="Portapapeles no disponible",
        ["<b>NEED ACCESS?</b>\nClick the key button to generate your own access key."]="<b>¿NECESITAS ACCESO?</b>\nPulsa el botón de clave para generar tu propia clave.",
        ["ACCESS KEY"]="CLAVE DE ACCESO", ["Validate Key"]="Validar clave",
        ["Get-key link copied!"]="¡Enlace de clave copiado!",
        ["Discord invite copied!"]="¡Invitación de Discord copiada!", ["Please enter a key"]="Introduce una clave",
        ["Beta key retired - use Get a Key below"]="La clave beta fue retirada; obtén una nueva abajo",
        ["Checking..."]="Comprobando...", ["Invalid key"]="Clave no válida",
        ["Home"]="Inicio", ["Movement"]="Movimiento", ["Glitches"]="Glitches", ["Aim"]="Apuntado", ["Visuals"]="Visuales",
        ["Combat"]="Combate", ["Blacklist"]="Lista negra", ["Exclude"]="Excluir", ["Misc"]="Varios", ["Macro"]="Macro",
        ["Mobile"]="Móvil", ["Buttons"]="Botones", ["Skin Changer"]="Cambiador de aspectos", ["Shop"]="Tienda", ["Client"]="Cliente", ["Key"]="Clave",
        ["Appearance"]="Apariencia", ["Settings"]="Ajustes", ["Keybinds"]="Teclas", ["CONTROLS"]="CONTROLES",
        ["ACTIONS"]="ACCIONES", ["VISIBILITY"]="VISIBILIDAD", ["MODE"]="MODO", ["RESET"]="RESTABLECER",
        ["Enable Skin Changer"]="Activar cambiador de aspectos", ["RGB Cycle"]="Ciclo RGB", ["Preset Color"]="Color predefinido",
        ["Indicator Color"]="Color del indicador", ["Button Color"]="Color del botón",
        ["Save"]="Guardar", ["Cancel"]="Cancelar", ["Pick a Color"]="Elegir un color", ["Selected: "]="Seleccionado: ",
    },
    Portuguese={
        ["Select the experience you want to use."]="Selecione a experiência que deseja usar.",
        ["Enter your access key to continue"]="Insira sua chave de acesso para continuar", ["Enter your access key to continue to Cokeboys."]="Digite sua chave de acesso para continuar no Cokeboys.", ["Access key"]="Chave de acesso",
        ["Get Key"]="Obter chave", ["Click Here to Get a Key"]="Clique aqui para obter uma chave", ["Join Discord"]="Entrar no Discord", ["Language"]="Idioma", ["Close"]="Fechar", ["Key accepted"]="Chave aceita",
        ["Connection unavailable. Try again."]="Conexão indisponível. Tente novamente.", ["Unable to verify key. Try again."]="Não foi possível verificar a chave. Tente novamente.",
        ["Preparing Cokeboys..."]="Preparando Cokeboys...", ["Clipboard unavailable"]="Área de transferência indisponível",
        ["<b>NEED ACCESS?</b>\nClick the key button to generate your own access key."]="<b>PRECISA DE ACESSO?</b>\nClique no botão de chave para gerar sua própria chave.",
        ["ACCESS KEY"]="CHAVE DE ACESSO", ["Validate Key"]="Validar chave",
        ["Get-key link copied!"]="Link da chave copiado!",
        ["Discord invite copied!"]="Convite do Discord copiado!", ["Please enter a key"]="Insira uma chave",
        ["Beta key retired - use Get a Key below"]="A chave beta foi removida; obtenha uma nova abaixo",
        ["Checking..."]="Verificando...", ["Invalid key"]="Chave inválida",
        ["Home"]="Início", ["Movement"]="Movimento", ["Glitches"]="Glitches", ["Aim"]="Mira", ["Visuals"]="Visuais",
        ["Combat"]="Combate", ["Blacklist"]="Lista negra", ["Exclude"]="Excluir", ["Misc"]="Diversos", ["Macro"]="Macro",
        ["Mobile"]="Celular", ["Buttons"]="Botões", ["Skin Changer"]="Alterador de skins", ["Shop"]="Loja", ["Client"]="Cliente", ["Key"]="Chave",
        ["Appearance"]="Aparência", ["Settings"]="Configurações", ["Keybinds"]="Teclas", ["CONTROLS"]="CONTROLES",
        ["ACTIONS"]="AÇÕES", ["VISIBILITY"]="VISIBILIDADE", ["MODE"]="MODO", ["RESET"]="REDEFINIR",
        ["Enable Skin Changer"]="Ativar alterador de skins", ["RGB Cycle"]="Ciclo RGB", ["Preset Color"]="Cor predefinida",
        ["Indicator Color"]="Cor do indicador", ["Button Color"]="Cor do botão",
        ["Save"]="Salvar", ["Cancel"]="Cancelar", ["Pick a Color"]="Escolha uma cor", ["Selected: "]="Selecionado: ",
    },
    French={
        ["Select the experience you want to use."]="Sélectionnez l’expérience que vous souhaitez utiliser.",
        ["Enter your access key to continue"]="Entrez votre clé d’accès pour continuer", ["Enter your access key to continue to Cokeboys."]="Entrez votre clé d’accès pour continuer vers Cokeboys.", ["Access key"]="Clé d’accès",
        ["Get Key"]="Obtenir une clé", ["Click Here to Get a Key"]="Cliquez ici pour obtenir une clé", ["Join Discord"]="Rejoindre Discord", ["Language"]="Langue", ["Close"]="Fermer", ["Key accepted"]="Clé acceptée",
        ["Connection unavailable. Try again."]="Connexion indisponible. Réessayez.", ["Unable to verify key. Try again."]="Impossible de vérifier la clé. Réessayez.",
        ["Preparing Cokeboys..."]="Préparation de Cokeboys...", ["Clipboard unavailable"]="Presse-papiers indisponible",
        ["<b>NEED ACCESS?</b>\nClick the key button to generate your own access key."]="<b>BESOIN D'ACCÈS ?</b>\nCliquez sur le bouton de clé pour générer votre clé.",
        ["ACCESS KEY"]="CLÉ D'ACCÈS", ["Validate Key"]="Valider la clé",
        ["Get-key link copied!"]="Lien de clé copié !",
        ["Discord invite copied!"]="Invitation Discord copiée !", ["Please enter a key"]="Veuillez entrer une clé",
        ["Beta key retired - use Get a Key below"]="La clé bêta a été retirée ; obtenez-en une nouvelle ci-dessous",
        ["Checking..."]="Vérification...", ["Invalid key"]="Clé invalide",
        ["Home"]="Accueil", ["Movement"]="Mouvement", ["Glitches"]="Glitches", ["Aim"]="Visée", ["Visuals"]="Visuels",
        ["Combat"]="Combat", ["Blacklist"]="Liste noire", ["Exclude"]="Exclure", ["Misc"]="Divers", ["Macro"]="Macro",
        ["Mobile"]="Mobile", ["Buttons"]="Boutons", ["Skin Changer"]="Changeur d'effets", ["Shop"]="Boutique", ["Client"]="Client", ["Key"]="Clé",
        ["Appearance"]="Apparence", ["Settings"]="Paramètres", ["Keybinds"]="Raccourcis", ["CONTROLS"]="COMMANDES",
        ["ACTIONS"]="ACTIONS", ["VISIBILITY"]="VISIBILITÉ", ["MODE"]="MODE", ["RESET"]="RÉINITIALISER",
        ["Enable Skin Changer"]="Activer le changeur d'effets", ["RGB Cycle"]="Cycle RGB", ["Preset Color"]="Couleur prédéfinie",
        ["Indicator Color"]="Couleur de l'indicateur", ["Button Color"]="Couleur du bouton",
        ["Save"]="Enregistrer", ["Cancel"]="Annuler", ["Pick a Color"]="Choisir une couleur", ["Selected: "]="Sélectionné : ",
    },
    Vietnamese={
        ["Select the experience you want to use."]="Chọn trải nghiệm bạn muốn sử dụng.",
        ["Enter your access key to continue"]="Nhập key truy cập để tiếp tục", ["Enter your access key to continue to Cokeboys."]="Nhập mã truy cập để tiếp tục đến Cokeboys.", ["Access key"]="Key truy cập",
        ["Get Key"]="Lấy key", ["Click Here to Get a Key"]="Nhấn vào đây để lấy key", ["Join Discord"]="Tham gia Discord", ["Language"]="Ngôn ngữ", ["Close"]="Đóng", ["Key accepted"]="Key được chấp nhận",
        ["Connection unavailable. Try again."]="Không thể kết nối. Hãy thử lại.", ["Unable to verify key. Try again."]="Không thể xác minh key. Hãy thử lại.",
        ["Preparing Cokeboys..."]="Đang chuẩn bị Cokeboys...", ["Clipboard unavailable"]="Không có bộ nhớ tạm",
        ["<b>NEED ACCESS?</b>\nClick the key button to generate your own access key."]="<b>CẦN QUYỀN TRUY CẬP?</b>\nNhấn nút key để tạo key truy cập của bạn.",
        ["ACCESS KEY"]="KEY TRUY CẬP", ["Validate Key"]="Xác thực key",
        ["Get-key link copied!"]="Đã sao chép liên kết lấy key!",
        ["Discord invite copied!"]="Đã sao chép lời mời Discord!", ["Please enter a key"]="Vui lòng nhập key",
        ["Beta key retired - use Get a Key below"]="Key beta đã bị gỡ; hãy lấy key mới bên dưới",
        ["Checking..."]="Đang kiểm tra...", ["Invalid key"]="Key không hợp lệ",
        ["Home"]="Trang chủ", ["Movement"]="Di chuyển", ["Glitches"]="Kỹ thuật", ["Aim"]="Ngắm", ["Visuals"]="Hiển thị",
        ["Combat"]="Chiến đấu", ["Blacklist"]="Danh sách đen", ["Exclude"]="Loại trừ", ["Misc"]="Khác", ["Macro"]="Macro",
        ["Mobile"]="Di động", ["Buttons"]="Nút", ["Skin Changer"]="Đổi hiệu ứng", ["Shop"]="Cửa hàng", ["Client"]="Máy khách", ["Key"]="Key",
        ["Appearance"]="Giao diện", ["Settings"]="Cài đặt", ["Keybinds"]="Phím tắt", ["CONTROLS"]="ĐIỀU KHIỂN",
        ["ACTIONS"]="THAO TÁC", ["VISIBILITY"]="HIỂN THỊ", ["MODE"]="CHẾ ĐỘ", ["RESET"]="ĐẶT LẠI",
        ["Enable Skin Changer"]="Bật đổi hiệu ứng", ["RGB Cycle"]="Chu kỳ RGB", ["Preset Color"]="Màu có sẵn",
        ["Indicator Color"]="Màu chỉ báo", ["Button Color"]="Màu nút",
        ["Save"]="Lưu", ["Cancel"]="Hủy", ["Pick a Color"]="Chọn màu", ["Selected: "]="Đã chọn: ",
    },
    Indonesian={
        ["Select the experience you want to use."]="Pilih pengalaman yang ingin Anda gunakan.",
        ["Enter your access key to continue"]="Masukkan key akses untuk melanjutkan", ["Enter your access key to continue to Cokeboys."]="Masukkan kunci akses untuk melanjutkan ke Cokeboys.", ["Access key"]="Key akses",
        ["Get Key"]="Dapatkan key", ["Click Here to Get a Key"]="Klik di sini untuk mendapatkan key", ["Join Discord"]="Gabung Discord", ["Language"]="Bahasa", ["Close"]="Tutup", ["Key accepted"]="Key diterima",
        ["Connection unavailable. Try again."]="Koneksi tidak tersedia. Coba lagi.", ["Unable to verify key. Try again."]="Key tidak dapat diverifikasi. Coba lagi.",
        ["Preparing Cokeboys..."]="Menyiapkan Cokeboys...", ["Clipboard unavailable"]="Papan klip tidak tersedia",
        ["<b>NEED ACCESS?</b>\nClick the key button to generate your own access key."]="<b>BUTUH AKSES?</b>\nKlik tombol key untuk membuat key akses milikmu.",
        ["ACCESS KEY"]="KEY AKSES", ["Validate Key"]="Validasi key",
        ["Get-key link copied!"]="Tautan key disalin!",
        ["Discord invite copied!"]="Undangan Discord disalin!", ["Please enter a key"]="Silakan masukkan key",
        ["Beta key retired - use Get a Key below"]="Key beta dihentikan; dapatkan key baru di bawah",
        ["Checking..."]="Memeriksa...", ["Invalid key"]="Key tidak valid",
        ["Home"]="Beranda", ["Movement"]="Gerakan", ["Glitches"]="Glitch", ["Aim"]="Bidikan", ["Visuals"]="Visual",
        ["Combat"]="Pertarungan", ["Blacklist"]="Daftar hitam", ["Exclude"]="Kecualikan", ["Misc"]="Lainnya", ["Macro"]="Makro",
        ["Mobile"]="Seluler", ["Buttons"]="Tombol", ["Skin Changer"]="Pengubah efek", ["Shop"]="Toko", ["Client"]="Klien", ["Key"]="Key",
        ["Appearance"]="Tampilan", ["Settings"]="Pengaturan", ["Keybinds"]="Tombol pintas", ["CONTROLS"]="KONTROL",
        ["ACTIONS"]="TINDAKAN", ["VISIBILITY"]="VISIBILITAS", ["MODE"]="MODE", ["RESET"]="ATUR ULANG",
        ["Enable Skin Changer"]="Aktifkan pengubah efek", ["RGB Cycle"]="Siklus RGB", ["Preset Color"]="Warna preset",
        ["Indicator Color"]="Warna indikator", ["Button Color"]="Warna tombol",
        ["Save"]="Simpan", ["Cancel"]="Batal", ["Pick a Color"]="Pilih warna", ["Selected: "]="Dipilih: ",
    },
    Filipino={
        ["Select the experience you want to use."]="Piliin ang experience na gusto mong gamitin.",
        ["Enter your access key to continue"]="Ilagay ang access key mo upang magpatuloy", ["Enter your access key to continue to Cokeboys."]="Ilagay ang iyong access key para magpatuloy sa Cokeboys.", ["Access key"]="Access key",
        ["Get Key"]="Kumuha ng key", ["Click Here to Get a Key"]="Mag-click dito para kumuha ng key", ["Join Discord"]="Sumali sa Discord", ["Language"]="Wika", ["Close"]="Isara", ["Key accepted"]="Tinanggap ang key",
        ["Connection unavailable. Try again."]="Walang koneksyon. Subukan muli.", ["Unable to verify key. Try again."]="Hindi ma-verify ang key. Subukan muli.",
        ["Preparing Cokeboys..."]="Inihahanda ang Cokeboys...", ["Clipboard unavailable"]="Hindi available ang clipboard",
        ["<b>NEED ACCESS?</b>\nClick the key button to generate your own access key."]="<b>KAILANGAN NG ACCESS?</b>\nI-click ang key button para gumawa ng sarili mong access key.",
        ["ACCESS KEY"]="ACCESS KEY", ["Validate Key"]="I-validate ang key",
        ["Get-key link copied!"]="Nakopya ang link para sa key!",
        ["Discord invite copied!"]="Nakopya ang Discord invite!", ["Please enter a key"]="Mangyaring maglagay ng key",
        ["Beta key retired - use Get a Key below"]="Itinigil na ang beta key; kumuha ng bagong key sa ibaba",
        ["Checking..."]="Sinusuri...", ["Invalid key"]="Hindi wastong key",
        ["Home"]="Home", ["Movement"]="Paggalaw", ["Glitches"]="Glitches", ["Aim"]="Pagpuntirya", ["Visuals"]="Mga Visual",
        ["Combat"]="Labanan", ["Blacklist"]="Blacklist", ["Exclude"]="Ibukod", ["Misc"]="Iba pa", ["Macro"]="Macro",
        ["Mobile"]="Mobile", ["Buttons"]="Mga Button", ["Skin Changer"]="Skin Changer", ["Shop"]="Tindahan", ["Client"]="Client", ["Key"]="Key",
        ["Appearance"]="Hitsura", ["Settings"]="Mga Setting", ["Keybinds"]="Mga Keybind", ["CONTROLS"]="MGA CONTROL",
        ["ACTIONS"]="MGA AKSYON", ["VISIBILITY"]="PAGKAKAKITA", ["MODE"]="MODE", ["RESET"]="I-RESET",
        ["Enable Skin Changer"]="I-enable ang Skin Changer", ["RGB Cycle"]="RGB Cycle", ["Preset Color"]="Preset na Kulay",
        ["Indicator Color"]="Kulay ng Indicator", ["Button Color"]="Kulay ng Button",
        ["Save"]="I-save", ["Cancel"]="Kanselahin", ["Pick a Color"]="Pumili ng Kulay", ["Selected: "]="Napili: ",
    },
}

local EXPERIENCE_SELECTOR_TRANSLATIONS={
    Spanish={
        ["Choose Your Cokeboys Experience"]="Elige tu experiencia Cokeboys",["Select the experience that fits how you play."]="Selecciona la experiencia que mejor se adapte a tu forma de jugar.",
        ["Full Experience"]="Experiencia Completa",["Core Experience"]="Experiencia Esencial",["The complete Cokeboys experience."]="La experiencia completa de Cokeboys.",["A simple, focused Cokeboys experience."]="Una experiencia Cokeboys sencilla y enfocada.",
        ["Classic Experience"]="Experiencia clásica",["Essential Features"]="Funciones esenciales",["Streamlined Interface"]="Interfaz optimizada",["Faster Setup"]="Configuración más rápida",["Launch Full"]="Iniciar Full",["Launch Core"]="Iniciar Core",
        ["Choose Your Experience"]="Elige tu experiencia",["You can change this again later."]="Podrás cambiar esto más adelante.",
        ["Lite"]="Lite",["Full"]="Full",["Recommended"]="Recomendado",["Core Features"]="Funciones principales",
        ["Simpler Interface"]="Interfaz más sencilla",["Easier to Use"]="Más fácil de usar",["All Features"]="Todas las funciones",
        ["Advanced Controls"]="Controles avanzados",["Full Customization"]="Personalización completa",["Load Lite"]="Cargar Lite",
        ["Load Full"]="Cargar Full",["Remember and skip this screen next time"]="Recordar y omitir esta pantalla la próxima vez",["Choose how you want Cokeboys to run. You can change this later in Settings."]="Elige cómo quieres usar Cokeboys. Puedes cambiarlo más tarde en Ajustes.",["Existing / Classic Experience"]="Experiencia existente / clásica",
        ["Preparing Lite..."]="Preparando Lite...",["Preparing Full..."]="Preparando Full...",["Preference could not be saved"]="No se pudo guardar la preferencia",
        ["Verifying key..."]="Verificando clave...",["Starting %s..."]="Iniciando %s...",["Cleanup could not be verified. Re-execute Cokeboys to continue."]="No se pudo verificar la limpieza. Vuelve a ejecutar Cokeboys para continuar.",
    },
    Portuguese={
        ["Choose Your Cokeboys Experience"]="Escolha sua experiência Cokeboys",["Select the experience that fits how you play."]="Selecione a experiência que combina com seu jeito de jogar.",
        ["Full Experience"]="Experiência Completa",["Core Experience"]="Experiência Essencial",["The complete Cokeboys experience."]="A experiência Cokeboys completa.",["A simple, focused Cokeboys experience."]="Uma experiência Cokeboys simples e focada.",
        ["Classic Experience"]="Experiência clássica",["Essential Features"]="Recursos essenciais",["Streamlined Interface"]="Interface otimizada",["Faster Setup"]="Configuração mais rápida",["Launch Full"]="Iniciar Full",["Launch Core"]="Iniciar Core",
        ["Choose Your Experience"]="Escolha sua experiência",["You can change this again later."]="Você poderá alterar isso mais tarde.",
        ["Lite"]="Lite",["Full"]="Full",["Recommended"]="Recomendado",["Core Features"]="Recursos principais",
        ["Simpler Interface"]="Interface mais simples",["Easier to Use"]="Mais fácil de usar",["All Features"]="Todos os recursos",
        ["Advanced Controls"]="Controles avançados",["Full Customization"]="Personalização completa",["Load Lite"]="Carregar Lite",
        ["Load Full"]="Carregar Full",["Remember and skip this screen next time"]="Lembrar e pular esta tela na próxima vez",["Choose how you want Cokeboys to run. You can change this later in Settings."]="Escolha como deseja usar o Cokeboys. Você pode alterar isso depois em Configurações.",["Existing / Classic Experience"]="Experiência existente / clássica",
        ["Preparing Lite..."]="Preparando Lite...",["Preparing Full..."]="Preparando Full...",["Preference could not be saved"]="Não foi possível salvar a preferência",
        ["Verifying key..."]="Verificando a chave...",["Starting %s..."]="Iniciando %s...",["Cleanup could not be verified. Re-execute Cokeboys to continue."]="Não foi possível verificar a limpeza. Execute o Cokeboys novamente para continuar.",
    },
    French={
        ["Choose Your Cokeboys Experience"]="Choisissez votre expérience Cokeboys",["Select the experience that fits how you play."]="Sélectionnez l’expérience adaptée à votre façon de jouer.",
        ["Full Experience"]="Expérience Complète",["Core Experience"]="Expérience Essentielle",["The complete Cokeboys experience."]="L’expérience Cokeboys complète.",["A simple, focused Cokeboys experience."]="Une expérience Cokeboys simple et ciblée.",
        ["Classic Experience"]="Expérience classique",["Essential Features"]="Fonctions essentielles",["Streamlined Interface"]="Interface optimisée",["Faster Setup"]="Configuration plus rapide",["Launch Full"]="Lancer Full",["Launch Core"]="Lancer Core",
        ["Choose Your Experience"]="Choisissez votre expérience",["You can change this again later."]="Vous pourrez modifier ce choix plus tard.",
        ["Lite"]="Lite",["Full"]="Full",["Recommended"]="Recommandé",["Core Features"]="Fonctions essentielles",
        ["Simpler Interface"]="Interface simplifiée",["Easier to Use"]="Plus facile à utiliser",["All Features"]="Toutes les fonctions",
        ["Advanced Controls"]="Contrôles avancés",["Full Customization"]="Personnalisation complète",["Load Lite"]="Charger Lite",
        ["Load Full"]="Charger Full",["Remember and skip this screen next time"]="Mémoriser et ignorer cet écran la prochaine fois",["Choose how you want Cokeboys to run. You can change this later in Settings."]="Choisissez comment utiliser Cokeboys. Vous pourrez modifier ce choix plus tard dans les paramètres.",["Existing / Classic Experience"]="Expérience existante / classique",
        ["Preparing Lite..."]="Préparation de Lite...",["Preparing Full..."]="Préparation de Full...",["Preference could not be saved"]="La préférence n'a pas pu être enregistrée",
        ["Verifying key..."]="Vérification de la clé...",["Starting %s..."]="Démarrage de %s...",["Cleanup could not be verified. Re-execute Cokeboys to continue."]="Le nettoyage n'a pas pu être vérifié. Relancez Cokeboys pour continuer.",
    },
    Vietnamese={
        ["Choose Your Cokeboys Experience"]="Chọn trải nghiệm Cokeboys của bạn",["Select the experience that fits how you play."]="Chọn trải nghiệm phù hợp với cách chơi của bạn.",
        ["Full Experience"]="Trải Nghiệm Đầy Đủ",["Core Experience"]="Trải Nghiệm Cốt Lõi",["The complete Cokeboys experience."]="Trải nghiệm Cokeboys hoàn chỉnh.",["A simple, focused Cokeboys experience."]="Trải nghiệm Cokeboys đơn giản và tập trung.",
        ["Classic Experience"]="Trải nghiệm cổ điển",["Essential Features"]="Tính năng thiết yếu",["Streamlined Interface"]="Giao diện tinh gọn",["Faster Setup"]="Thiết lập nhanh hơn",["Launch Full"]="Khởi chạy Full",["Launch Core"]="Khởi chạy Core",
        ["Choose Your Experience"]="Chọn trải nghiệm của bạn",["You can change this again later."]="Bạn có thể đổi lựa chọn này sau.",
        ["Lite"]="Lite",["Full"]="Full",["Recommended"]="Đề xuất",["Core Features"]="Tính năng cốt lõi",
        ["Simpler Interface"]="Giao diện đơn giản hơn",["Easier to Use"]="Dễ sử dụng hơn",["All Features"]="Tất cả tính năng",
        ["Advanced Controls"]="Điều khiển nâng cao",["Full Customization"]="Tùy chỉnh đầy đủ",["Load Lite"]="Tải Lite",
        ["Load Full"]="Tải Full",["Remember and skip this screen next time"]="Ghi nhớ và bỏ qua màn hình này lần sau",["Choose how you want Cokeboys to run. You can change this later in Settings."]="Chọn cách bạn muốn Cokeboys hoạt động. Bạn có thể thay đổi sau trong Cài đặt.",["Existing / Classic Experience"]="Trải nghiệm hiện có / cổ điển",
        ["Preparing Lite..."]="Đang chuẩn bị Lite...",["Preparing Full..."]="Đang chuẩn bị Full...",["Preference could not be saved"]="Không thể lưu tùy chọn",
        ["Verifying key..."]="Đang xác minh khóa...",["Starting %s..."]="Đang khởi động %s...",["Cleanup could not be verified. Re-execute Cokeboys to continue."]="Không thể xác minh việc dọn dẹp. Hãy chạy lại Cokeboys để tiếp tục.",
    },
    Indonesian={
        ["Choose Your Cokeboys Experience"]="Pilih pengalaman Cokeboys Anda",["Select the experience that fits how you play."]="Pilih pengalaman yang sesuai dengan cara bermain Anda.",
        ["Full Experience"]="Pengalaman Lengkap",["Core Experience"]="Pengalaman Inti",["The complete Cokeboys experience."]="Pengalaman Cokeboys lengkap.",["A simple, focused Cokeboys experience."]="Pengalaman Cokeboys yang sederhana dan terfokus.",
        ["Classic Experience"]="Pengalaman klasik",["Essential Features"]="Fitur penting",["Streamlined Interface"]="Antarmuka ringkas",["Faster Setup"]="Pengaturan lebih cepat",["Launch Full"]="Jalankan Full",["Launch Core"]="Jalankan Core",
        ["Choose Your Experience"]="Pilih pengalaman Anda",["You can change this again later."]="Anda dapat mengubah pilihan ini nanti.",
        ["Lite"]="Lite",["Full"]="Full",["Recommended"]="Disarankan",["Core Features"]="Fitur inti",
        ["Simpler Interface"]="Antarmuka lebih sederhana",["Easier to Use"]="Lebih mudah digunakan",["All Features"]="Semua fitur",
        ["Advanced Controls"]="Kontrol lanjutan",["Full Customization"]="Kustomisasi penuh",["Load Lite"]="Muat Lite",
        ["Load Full"]="Muat Full",["Remember and skip this screen next time"]="Ingat dan lewati layar ini lain kali",["Choose how you want Cokeboys to run. You can change this later in Settings."]="Pilih cara Cokeboys berjalan. Anda dapat mengubahnya nanti di Pengaturan.",["Existing / Classic Experience"]="Pengalaman lama / klasik",
        ["Preparing Lite..."]="Menyiapkan Lite...",["Preparing Full..."]="Menyiapkan Full...",["Preference could not be saved"]="Preferensi tidak dapat disimpan",
        ["Verifying key..."]="Memverifikasi kunci...",["Starting %s..."]="Memulai %s...",["Cleanup could not be verified. Re-execute Cokeboys to continue."]="Pembersihan tidak dapat diverifikasi. Jalankan ulang Cokeboys untuk melanjutkan.",
    },
    Filipino={
        ["Choose Your Cokeboys Experience"]="Piliin ang iyong Cokeboys experience",["Select the experience that fits how you play."]="Piliin ang experience na akma sa paraan ng paglalaro mo.",
        ["Full Experience"]="Full Experience",["Core Experience"]="Core Experience",["The complete Cokeboys experience."]="Ang kumpletong Cokeboys experience.",["A simple, focused Cokeboys experience."]="Isang simple at focused na Cokeboys experience.",
        ["Classic Experience"]="Classic experience",["Essential Features"]="Mahahalagang feature",["Streamlined Interface"]="Mas maayos na interface",["Faster Setup"]="Mas mabilis na setup",["Launch Full"]="Buksan ang Full",["Launch Core"]="Buksan ang Core",
        ["Choose Your Experience"]="Piliin ang iyong experience",["You can change this again later."]="Maaari mo itong baguhin sa susunod.",
        ["Lite"]="Lite",["Full"]="Full",["Recommended"]="Inirerekomenda",["Core Features"]="Mga pangunahing feature",
        ["Simpler Interface"]="Mas simpleng interface",["Easier to Use"]="Mas madaling gamitin",["All Features"]="Lahat ng feature",
        ["Advanced Controls"]="Advanced na controls",["Full Customization"]="Buong customization",["Load Lite"]="I-load ang Lite",
        ["Load Full"]="I-load ang Full",["Remember and skip this screen next time"]="Tandaan at laktawan ang screen na ito sa susunod",["Choose how you want Cokeboys to run. You can change this later in Settings."]="Piliin kung paano tatakbo ang Cokeboys. Maaari mo itong baguhin sa Settings.",["Existing / Classic Experience"]="Kasalukuyan / classic na experience",
        ["Preparing Lite..."]="Inihahanda ang Lite...",["Preparing Full..."]="Inihahanda ang Full...",["Preference could not be saved"]="Hindi na-save ang preference",
        ["Verifying key..."]="Vine-verify ang key...",["Starting %s..."]="Sinisimulan ang %s...",["Cleanup could not be verified. Re-execute Cokeboys to continue."]="Hindi ma-verify ang cleanup. I-execute ulit ang Cokeboys para magpatuloy.",
    },
}
for language,entries in pairs(EXPERIENCE_SELECTOR_TRANSLATIONS) do
    TRANSLATIONS[language]=TRANSLATIONS[language] or {}
    for source,translated in pairs(entries) do TRANSLATIONS[language][source]=translated end
end

local EXTRA_TRANSLATIONS={
    Spanish={
        ["LANGUAGE"]="IDIOMA", ["Select Language"]="Seleccionar idioma",
        ["Gold"]="Dorado", ["Red"]="Rojo", ["Green"]="Verde", ["Cyan"]="Cian", ["White"]="Blanco", ["Magenta"]="Magenta",
        ["Pink"]="Rosa", ["Purple"]="Morado", ["Blue"]="Azul", ["Black"]="Negro", ["Midnight"]="Medianoche", ["Custom RGB"]="RGB personalizado",
        ["Top Right"]="Arriba derecha", ["Top Left"]="Arriba izquierda", ["Bottom Right"]="Abajo derecha", ["Bottom Left"]="Abajo izquierda",
        ["Line"]="Línea", ["None"]="Ninguno", ["Tap"]="Tocar", ["Hold"]="Mantener", ["On"]="Activado", ["Off"]="Desactivado",
        ["Jumps After Skill"]="Saltos después de la habilidad", ["Jump"]="Salto", ["Jumps"]="Saltos",
        ["Skill Aimbot"]="Aimbot de habilidades", ["Soru Aimbot"]="Aimbot de Soru", ["Auto Prediction"]="Predicción automática",
        ["Safe Zone Filter"]="Filtro de zona segura", ["Target Mode"]="Modo de objetivo", ["Target Priority"]="Prioridad de objetivo",
        ["Target Switch Delay"]="Retraso de cambio de objetivo", ["360° Targeting"]="Objetivo 360°", ["Skill CamLock"]="CamLock de habilidades",
        ["Ability Range Check"]="Comprobación de alcance", ["Show FOV Circle"]="Mostrar círculo FOV", ["ESP Enabled"]="Activar ESP",
        ["Speed Boost"]="Aumento de velocidad", ["Dash Boost"]="Aumento de dash",
        ["Jump Boost"]="Aumento de salto", ["Walk on Water"]="Caminar sobre agua", ["Walk on Lava"]="Caminar sobre lava",
        ["Auto V3"]="V3 automático", ["Smart V3"]="V3 inteligente", ["Auto V4"]="V4 automático", ["Smart V4"]="V4 inteligente",
        ["Disable Notifications"]="Desactivar notificaciones", ["Streamer Mode"]="Modo streamer",
        ["Hide Control Fruit Effects"]="Ocultar efectos de la fruta Control",
        ["Locally hides Control's room visuals and pauses its heavy bubble animation"]="Oculta localmente los efectos de la sala de Control y pausa la pesada animación de la burbuja",
    },
    Portuguese={
        ["LANGUAGE"]="IDIOMA", ["Select Language"]="Selecionar idioma",
        ["Gold"]="Dourado", ["Red"]="Vermelho", ["Green"]="Verde", ["Cyan"]="Ciano", ["White"]="Branco", ["Magenta"]="Magenta",
        ["Pink"]="Rosa", ["Purple"]="Roxo", ["Blue"]="Azul", ["Black"]="Preto", ["Midnight"]="Meia-noite", ["Custom RGB"]="RGB personalizado",
        ["Top Right"]="Superior direito", ["Top Left"]="Superior esquerdo", ["Bottom Right"]="Inferior direito", ["Bottom Left"]="Inferior esquerdo",
        ["Line"]="Linha", ["None"]="Nenhum", ["Tap"]="Toque", ["Hold"]="Segurar", ["On"]="Ligado", ["Off"]="Desligado",
        ["Jumps After Skill"]="Saltos após a habilidade", ["Jump"]="Salto", ["Jumps"]="Saltos",
        ["Skill Aimbot"]="Aimbot de habilidades", ["Soru Aimbot"]="Aimbot de Soru", ["Auto Prediction"]="Predição automática",
        ["Safe Zone Filter"]="Filtro de zona segura", ["Target Mode"]="Modo de alvo", ["Target Priority"]="Prioridade do alvo",
        ["Target Switch Delay"]="Atraso para trocar alvo", ["360° Targeting"]="Alvo 360°", ["Skill CamLock"]="CamLock de habilidades",
        ["Ability Range Check"]="Verificação de alcance", ["Show FOV Circle"]="Mostrar círculo FOV", ["ESP Enabled"]="Ativar ESP",
        ["Speed Boost"]="Aumento de velocidade", ["Dash Boost"]="Aumento de dash",
        ["Jump Boost"]="Aumento de pulo", ["Walk on Water"]="Andar na água", ["Walk on Lava"]="Andar na lava",
        ["Auto V3"]="V3 automático", ["Smart V3"]="V3 inteligente", ["Auto V4"]="V4 automático", ["Smart V4"]="V4 inteligente",
        ["Disable Notifications"]="Desativar notificações", ["Streamer Mode"]="Modo streamer",
        ["Hide Control Fruit Effects"]="Ocultar efeitos da fruta Control",
        ["Locally hides Control's room visuals and pauses its heavy bubble animation"]="Oculta localmente os efeitos da sala do Control e pausa a animação pesada da bolha",
    },
    French={
        ["LANGUAGE"]="LANGUE", ["Select Language"]="Choisir la langue",
        ["Gold"]="Or", ["Red"]="Rouge", ["Green"]="Vert", ["Cyan"]="Cyan", ["White"]="Blanc", ["Magenta"]="Magenta",
        ["Pink"]="Rose", ["Purple"]="Violet", ["Blue"]="Bleu", ["Black"]="Noir", ["Midnight"]="Minuit", ["Custom RGB"]="RGB personnalisé",
        ["Top Right"]="En haut à droite", ["Top Left"]="En haut à gauche", ["Bottom Right"]="En bas à droite", ["Bottom Left"]="En bas à gauche",
        ["Line"]="Ligne", ["None"]="Aucun", ["Tap"]="Appui", ["Hold"]="Maintenir", ["On"]="Activé", ["Off"]="Désactivé",
        ["Jumps After Skill"]="Sauts après la compétence", ["Jump"]="Saut", ["Jumps"]="Sauts",
        ["Skill Aimbot"]="Aimbot de compétences", ["Soru Aimbot"]="Aimbot de Soru", ["Auto Prediction"]="Prédiction automatique",
        ["Safe Zone Filter"]="Filtre de zone sûre", ["Target Mode"]="Mode de ciblage", ["Target Priority"]="Priorité de cible",
        ["Target Switch Delay"]="Délai de changement de cible", ["360° Targeting"]="Ciblage à 360°", ["Skill CamLock"]="CamLock des compétences",
        ["Ability Range Check"]="Vérification de portée", ["Show FOV Circle"]="Afficher le cercle FOV", ["ESP Enabled"]="Activer l'ESP",
        ["Speed Boost"]="Boost de vitesse", ["Dash Boost"]="Boost de dash",
        ["Jump Boost"]="Boost de saut", ["Walk on Water"]="Marcher sur l'eau", ["Walk on Lava"]="Marcher sur la lave",
        ["Auto V3"]="V3 automatique", ["Smart V3"]="V3 intelligent", ["Auto V4"]="V4 automatique", ["Smart V4"]="V4 intelligent",
        ["Disable Notifications"]="Désactiver les notifications", ["Streamer Mode"]="Mode streamer",
        ["Hide Control Fruit Effects"]="Masquer les effets du fruit Control",
        ["Locally hides Control's room visuals and pauses its heavy bubble animation"]="Masque localement les effets de la salle de Control et met en pause la lourde animation de la bulle",
    },
    Vietnamese={
        ["LANGUAGE"]="NGÔN NGỮ", ["Select Language"]="Chọn ngôn ngữ",
        ["Gold"]="Vàng", ["Red"]="Đỏ", ["Green"]="Xanh lá", ["Cyan"]="Xanh ngọc", ["White"]="Trắng", ["Magenta"]="Hồng tím",
        ["Pink"]="Hồng", ["Purple"]="Tím", ["Blue"]="Xanh dương", ["Black"]="Đen", ["Midnight"]="Đêm", ["Custom RGB"]="RGB tùy chỉnh",
        ["Top Right"]="Trên phải", ["Top Left"]="Trên trái", ["Bottom Right"]="Dưới phải", ["Bottom Left"]="Dưới trái",
        ["Line"]="Đường", ["None"]="Không", ["Tap"]="Chạm", ["Hold"]="Giữ", ["On"]="Bật", ["Off"]="Tắt",
        ["Jumps After Skill"]="Nhảy sau kỹ năng", ["Jump"]="Lần nhảy", ["Jumps"]="Lần nhảy",
        ["Skill Aimbot"]="Aimbot kỹ năng", ["Soru Aimbot"]="Aimbot Soru", ["Auto Prediction"]="Dự đoán tự động",
        ["Safe Zone Filter"]="Lọc vùng an toàn", ["Target Mode"]="Chế độ mục tiêu", ["Target Priority"]="Ưu tiên mục tiêu",
        ["Target Switch Delay"]="Độ trễ đổi mục tiêu", ["360° Targeting"]="Nhắm mục tiêu 360°", ["Skill CamLock"]="CamLock kỹ năng",
        ["Ability Range Check"]="Kiểm tra tầm kỹ năng", ["Show FOV Circle"]="Hiện vòng FOV", ["ESP Enabled"]="Bật ESP",
        ["Speed Boost"]="Tăng tốc", ["Dash Boost"]="Tăng dash",
        ["Jump Boost"]="Tăng nhảy", ["Walk on Water"]="Đi trên nước", ["Walk on Lava"]="Đi trên dung nham",
        ["Auto V3"]="V3 tự động", ["Smart V3"]="V3 thông minh", ["Auto V4"]="V4 tự động", ["Smart V4"]="V4 thông minh",
        ["Disable Notifications"]="Tắt thông báo", ["Streamer Mode"]="Chế độ streamer",
        ["Hide Control Fruit Effects"]="Ẩn hiệu ứng trái Control",
        ["Locally hides Control's room visuals and pauses its heavy bubble animation"]="Ẩn cục bộ hiệu ứng phòng Control và tạm dừng hoạt ảnh bong bóng nặng",
    },
    Indonesian={
        ["LANGUAGE"]="BAHASA", ["Select Language"]="Pilih bahasa",
        ["Gold"]="Emas", ["Red"]="Merah", ["Green"]="Hijau", ["Cyan"]="Sian", ["White"]="Putih", ["Magenta"]="Magenta",
        ["Pink"]="Merah muda", ["Purple"]="Ungu", ["Blue"]="Biru", ["Black"]="Hitam", ["Midnight"]="Tengah malam", ["Custom RGB"]="RGB khusus",
        ["Top Right"]="Kanan atas", ["Top Left"]="Kiri atas", ["Bottom Right"]="Kanan bawah", ["Bottom Left"]="Kiri bawah",
        ["Line"]="Garis", ["None"]="Tidak ada", ["Tap"]="Ketuk", ["Hold"]="Tahan", ["On"]="Aktif", ["Off"]="Nonaktif",
        ["Jumps After Skill"]="Lompatan setelah skill", ["Jump"]="Lompatan", ["Jumps"]="Lompatan",
        ["Skill Aimbot"]="Aimbot skill", ["Soru Aimbot"]="Aimbot Soru", ["Auto Prediction"]="Prediksi otomatis",
        ["Safe Zone Filter"]="Filter zona aman", ["Target Mode"]="Mode target", ["Target Priority"]="Prioritas target",
        ["Target Switch Delay"]="Jeda pergantian target", ["360° Targeting"]="Penargetan 360°", ["Skill CamLock"]="CamLock skill",
        ["Ability Range Check"]="Pemeriksaan jangkauan", ["Show FOV Circle"]="Tampilkan lingkaran FOV", ["ESP Enabled"]="Aktifkan ESP",
        ["Speed Boost"]="Peningkat kecepatan", ["Dash Boost"]="Peningkat dash",
        ["Jump Boost"]="Peningkat lompatan", ["Walk on Water"]="Berjalan di air", ["Walk on Lava"]="Berjalan di lava",
        ["Auto V3"]="V3 otomatis", ["Smart V3"]="V3 pintar", ["Auto V4"]="V4 otomatis", ["Smart V4"]="V4 pintar",
        ["Disable Notifications"]="Matikan notifikasi", ["Streamer Mode"]="Mode streamer",
        ["Hide Control Fruit Effects"]="Sembunyikan efek buah Control",
        ["Locally hides Control's room visuals and pauses its heavy bubble animation"]="Menyembunyikan efek ruang Control secara lokal dan menjeda animasi gelembung yang berat",
    },
    Filipino={
        ["LANGUAGE"]="WIKA", ["Select Language"]="Pumili ng Wika",
        ["Gold"]="Ginto", ["Red"]="Pula", ["Green"]="Berde", ["Cyan"]="Cyan", ["White"]="Puti", ["Magenta"]="Magenta",
        ["Pink"]="Rosas", ["Purple"]="Lila", ["Blue"]="Asul", ["Black"]="Itim", ["Midnight"]="Hatinggabi", ["Custom RGB"]="Custom RGB",
        ["Top Right"]="Itaas Kanan", ["Top Left"]="Itaas Kaliwa", ["Bottom Right"]="Ibaba Kanan", ["Bottom Left"]="Ibaba Kaliwa",
        ["Line"]="Linya", ["None"]="Wala", ["Tap"]="I-tap", ["Hold"]="Hawakan", ["On"]="Bukas", ["Off"]="Patay",
        ["Jumps After Skill"]="Mga talon pagkatapos ng skill", ["Jump"]="Talon", ["Jumps"]="Mga talon",
        ["Skill Aimbot"]="Skill Aimbot", ["Soru Aimbot"]="Soru Aimbot", ["Auto Prediction"]="Awtomatikong Prediction",
        ["Safe Zone Filter"]="Safe Zone Filter", ["Target Mode"]="Target Mode", ["Target Priority"]="Prayoridad ng Target",
        ["Target Switch Delay"]="Delay sa Pagpalit ng Target", ["360° Targeting"]="360° Targeting", ["Skill CamLock"]="Skill CamLock",
        ["Ability Range Check"]="Pagsuri ng Abot ng Ability", ["Show FOV Circle"]="Ipakita ang FOV Circle", ["ESP Enabled"]="I-enable ang ESP",
        ["Speed Boost"]="Speed Boost", ["Dash Boost"]="Dash Boost",
        ["Jump Boost"]="Jump Boost", ["Walk on Water"]="Maglakad sa Tubig", ["Walk on Lava"]="Maglakad sa Lava",
        ["Auto V3"]="Auto V3", ["Smart V3"]="Smart V3", ["Auto V4"]="Auto V4", ["Smart V4"]="Smart V4",
        ["Disable Notifications"]="I-disable ang mga Notification", ["Streamer Mode"]="Streamer Mode",
        ["Hide Control Fruit Effects"]="Itago ang Control Fruit Effects",
        ["Locally hides Control's room visuals and pauses its heavy bubble animation"]="Lokal na itinatago ang mga visual ng Control room at pini-pause ang mabigat na bubble animation",
    },
}
for language,entries in pairs(EXTRA_TRANSLATIONS) do
    TRANSLATIONS[language]=TRANSLATIONS[language] or {}
    for source,translated in pairs(entries) do TRANSLATIONS[language][source]=translated end
end

 
 
local CORE_INTERFACE_TRANSLATIONS={
    Spanish={
        ["ON"]="ACTIVADO",["OFF"]="DESACTIVADO",["TAP"]="TOCAR",["HOLD"]="MANTENER",
        ["Enabled"]="Activado",["Disabled"]="Desactivado",["Melee"]="Combate",["Fruit"]="Fruta",
        ["Sword"]="Espada",["Gun"]="Arma",["Weapon"]="Arma",["Skill Key"]="Tecla de habilidad",
        ["Placement"]="Posición",["Count"]="Cantidad",["Attack"]="Ataque",["Attacks"]="Ataques",
        ["MELEE"]="COMBATE",["FRUIT"]="FRUTA",["SWORD"]="ESPADA",["GUN"]="ARMA",["ATTACK"]="ATAQUE",["ATTACKS"]="ATAQUES",
        ["BLOCK"]="BLOQUE",["BLOCKS"]="BLOQUES",["SLOTS"]="RANURAS",["Slot"]="Ranura",
        ["STOPPED"]="DETENIDO",["IDLE"]="INACTIVO",
        ["EXCLUDED"]="EXCLUIDO",["Clear"]="Borrar",["Add"]="Añadir",
    },
    Portuguese={
        ["ON"]="LIGADO",["OFF"]="DESLIGADO",["TAP"]="TOQUE",["HOLD"]="SEGURAR",
        ["Enabled"]="Ativado",["Disabled"]="Desativado",["Melee"]="Corpo a corpo",["Fruit"]="Fruta",
        ["Sword"]="Espada",["Gun"]="Arma",["Weapon"]="Arma",["Skill Key"]="Tecla da habilidade",
        ["Placement"]="Posição",["Count"]="Quantidade",["Attack"]="Ataque",["Attacks"]="Ataques",
        ["MELEE"]="CORPO A CORPO",["FRUIT"]="FRUTA",["SWORD"]="ESPADA",["GUN"]="ARMA",["ATTACK"]="ATAQUE",["ATTACKS"]="ATAQUES",
        ["BLOCK"]="BLOCO",["BLOCKS"]="BLOCOS",["SLOTS"]="ESPAÇOS",["Slot"]="Espaço",
        ["STOPPED"]="PARADO",["IDLE"]="INATIVO",
        ["EXCLUDED"]="EXCLUÍDO",["Clear"]="Limpar",["Add"]="Adicionar",
    },
    French={
        ["ON"]="ACTIVÉ",["OFF"]="DÉSACTIVÉ",["TAP"]="APPUYER",["HOLD"]="MAINTENIR",
        ["Enabled"]="Activé",["Disabled"]="Désactivé",["Melee"]="Mêlée",["Fruit"]="Fruit",
        ["Sword"]="Épée",["Gun"]="Arme",["Weapon"]="Arme",["Skill Key"]="Touche de compétence",
        ["Placement"]="Position",["Count"]="Nombre",["Attack"]="Attaque",["Attacks"]="Attaques",
        ["MELEE"]="MÊLÉE",["FRUIT"]="FRUIT",["SWORD"]="ÉPÉE",["GUN"]="ARME",["ATTACK"]="ATTAQUE",["ATTACKS"]="ATTAQUES",
        ["BLOCK"]="BLOC",["BLOCKS"]="BLOCS",["SLOTS"]="EMPLACEMENTS",["Slot"]="Emplacement",
        ["STOPPED"]="ARRÊTÉ",["IDLE"]="INACTIF",
        ["EXCLUDED"]="EXCLU",["Clear"]="Effacer",["Add"]="Ajouter",
    },
    Vietnamese={
        ["ON"]="BẬT",["OFF"]="TẮT",["TAP"]="CHẠM",["HOLD"]="GIỮ",
        ["Enabled"]="Đã bật",["Disabled"]="Đã tắt",["Melee"]="Cận chiến",["Fruit"]="Trái ác quỷ",
        ["Sword"]="Kiếm",["Gun"]="Súng",["Weapon"]="Vũ khí",["Skill Key"]="Phím kỹ năng",
        ["Placement"]="Vị trí",["Count"]="Số lần",["Attack"]="Đòn đánh",["Attacks"]="Đòn đánh",
        ["MELEE"]="CẬN CHIẾN",["FRUIT"]="TRÁI ÁC QUỶ",["SWORD"]="KIẾM",["GUN"]="SÚNG",["ATTACK"]="ĐÒN ĐÁNH",["ATTACKS"]="ĐÒN ĐÁNH",
        ["BLOCK"]="KHỐI",["BLOCKS"]="CÁC KHỐI",["SLOTS"]="Ô",["Slot"]="Ô",
        ["STOPPED"]="ĐÃ DỪNG",["IDLE"]="CHỜ",
        ["EXCLUDED"]="ĐÃ LOẠI TRỪ",["Clear"]="Xóa",["Add"]="Thêm",
    },
    Indonesian={
        ["ON"]="AKTIF",["OFF"]="NONAKTIF",["TAP"]="KETUK",["HOLD"]="TAHAN",
        ["Enabled"]="Aktif",["Disabled"]="Nonaktif",["Melee"]="Jarak dekat",["Fruit"]="Buah",
        ["Sword"]="Pedang",["Gun"]="Senjata",["Weapon"]="Senjata",["Skill Key"]="Tombol skill",
        ["Placement"]="Posisi",["Count"]="Jumlah",["Attack"]="Serangan",["Attacks"]="Serangan",
        ["MELEE"]="JARAK DEKAT",["FRUIT"]="BUAH",["SWORD"]="PEDANG",["GUN"]="SENJATA",["ATTACK"]="SERANGAN",["ATTACKS"]="SERANGAN",
        ["BLOCK"]="BLOK",["BLOCKS"]="BLOK",["SLOTS"]="SLOT",["Slot"]="Slot",
        ["STOPPED"]="BERHENTI",["IDLE"]="SIAGA",
        ["EXCLUDED"]="DIKECUALIKAN",["Clear"]="Bersihkan",["Add"]="Tambah",
    },
    Filipino={
        ["ON"]="BUKAS",["OFF"]="PATAY",["TAP"]="I-TAP",["HOLD"]="HAWAKAN",
        ["Enabled"]="Naka-enable",["Disabled"]="Naka-disable",["Melee"]="Melee",["Fruit"]="Fruit",
        ["Sword"]="Espada",["Gun"]="Baril",["Weapon"]="Sandata",["Skill Key"]="Skill Key",
        ["Placement"]="Posisyon",["Count"]="Bilang",["Attack"]="Atake",["Attacks"]="Mga Atake",
        ["MELEE"]="MELEE",["FRUIT"]="FRUIT",["SWORD"]="ESPADA",["GUN"]="BARIL",["ATTACK"]="ATAKE",["ATTACKS"]="ATAKE",
        ["BLOCK"]="BLOCK",["BLOCKS"]="MGA BLOCK",["SLOTS"]="MGA SLOT",["Slot"]="Slot",
        ["STOPPED"]="HUMINTO",["IDLE"]="NAKAHINTO",
        ["EXCLUDED"]="IBINUKOD",["Clear"]="Burahin",["Add"]="Idagdag",
    },
}
for language,entries in pairs(CORE_INTERFACE_TRANSLATIONS) do
    TRANSLATIONS[language]=TRANSLATIONS[language] or {}
    for source,translated in pairs(entries) do TRANSLATIONS[language][source]=translated end
end

local TRANSLATION_PATTERNS={}
local TRANSLATION_LANGUAGE_ORDER={"Spanish","Portuguese","French","Vietnamese","Indonesian","Filipino"}
local interfaceLanguage
local GENERATED_TRANSLATION_PACK=nil
local GENERATED_TRANSLATION_DICTIONARY={}
local GENERATED_TRANSLATION_SOURCES=nil
local function decodeTranslationRows(value)
    if type(value)=="table" then return value end
    if type(value)~="string" or value=="" then return nil end
    local ok,decoded=pcall(function()
        return game:GetService("HttpService"):JSONDecode(value)
    end)
    return ok and type(decoded)=="table" and decoded or nil
end
local function rebuildGeneratedTranslationDictionary(language)
    table.clear(GENERATED_TRANSLATION_DICTIONARY)
     
     
     
    if language==nil or language=="English" then return end
    local pack=GENERATED_TRANSLATION_PACK
    if not pack then return end
    local sources=GENERATED_TRANSLATION_SOURCES
        or decodeTranslationRows(pack.sourcesJson)
        or decodeTranslationRows(pack.sources)
    if sources and not GENERATED_TRANSLATION_SOURCES then
        GENERATED_TRANSLATION_SOURCES=sources
    end
    local translated=decodeTranslationRows(pack[language.."Json"])
        or decodeTranslationRows(pack[language])
    if type(sources)~="table" or type(translated)~="table" then return end
    for index,source in ipairs(sources) do
        local value=translated[index]
        if type(source)=="string" and type(value)=="string" then
            GENERATED_TRANSLATION_DICTIONARY[source]=value
        end
    end
end
_G.__CokeboysRegisterTranslationRows=function(rows)
    if type(rows)~="table" then return end
    for _,row in ipairs(rows) do
        local source=type(row)=="table" and row[1] or nil
        if type(source)=="string" then
            for index,language in ipairs(TRANSLATION_LANGUAGE_ORDER) do
                local translated=row[index+1]
                TRANSLATIONS[language]=TRANSLATIONS[language] or {}
                 
                if TRANSLATIONS[language][source]==nil and type(translated)=="string" then
                    TRANSLATIONS[language][source]=translated
                end
            end
        end
    end
end
_G.__CokeboysRegisterTranslationPack=function(pack)
    if pack==nil then
        GENERATED_TRANSLATION_PACK=nil
        GENERATED_TRANSLATION_SOURCES=nil
        table.clear(GENERATED_TRANSLATION_DICTIONARY)
        return
    end
    if type(pack)~="table" or (type(pack.sources)~="table" and type(pack.sourcesJson)~="string") then return end
    GENERATED_TRANSLATION_PACK=pack
    GENERATED_TRANSLATION_SOURCES=nil
    rebuildGeneratedTranslationDictionary(interfaceLanguage)
end
_G.__CokeboysRegisterTranslationPatterns=function(patterns)
    if type(patterns)~="table" then return end
    for language,entries in pairs(patterns) do
        if type(entries)=="table" then TRANSLATION_PATTERNS[language]=entries end
    end
end
_G.__CokeboysRegisterTranslationRows({
    {"FPS","FPS","FPS","FPS","FPS","FPS"},
    {"Ping","Latencia","Ping","Latence","Ping","Ping"},
    {"SERVER","SERVIDOR","SERVIDOR","SERVEUR","MÁY CHỦ","SERVER"},
    {"SESSION","SESIÓN","SESSÃO","SESSION","PHIÊN","SESI"},
    {"PLAYERS","JUGADORES","JOGADORES","JOUEURS","NGƯỜI CHƠI","PEMAIN"},
    {"BOUNTY","RECOMPENSA","RECOMPENSA","PRIME","TRUY NÃ","BOUNTY"},
    {"HONOR","HONOR","HONRA","HONNEUR","DANH DỰ","KEHORMATAN"},
    {"SYNCING","SINCRONIZANDO","SINCRONIZANDO","SYNCHRONISATION","ĐANG ĐỒNG BỘ","MENYINKRONKAN"},
    {"Keybind","tecla","atalho","raccourci","phím tắt","tombol pintas"},
    {"Press","Pulsa","Pressione","Appuyez","Nhấn","Tekan"},
    {"to switch to the next eligible target","para cambiar al siguiente objetivo válido","para mudar para o próximo alvo válido","pour passer à la prochaine cible valide","để chuyển sang mục tiêu hợp lệ tiếp theo","untuk beralih ke target valid berikutnya"},
    {"Restock in","Reposición en","Reabastece em","Réapprovisionnement dans","Có lại sau","Stok ulang dalam"},
    {"more","más","mais","de plus","nữa","lagi"},
    {"PRIMARY","PRINCIPAL","PRINCIPAL","PRINCIPAL","CHÍNH","UTAMA"},
    {"MARINE","MARINE","MARINE","MARINE","HẢI QUÂN","MARINE"},
    {"PIRATE","PIRATA","PIRATA","PIRATE","HẢI TẶC","BAJAK LAUT"},
    {"SELECTING TEAM","ELIGIENDO EQUIPO","ESCOLHENDO EQUIPE","CHOIX DE L'ÉQUIPE","ĐANG CHỌN ĐỘI","MEMILIH TIM"},
    {"INCLUDE","INCLUIR","INCLUIR","INCLURE","BAO GỒM","SERTAKAN"},
    {"EXCLUDE","EXCLUIR","EXCLUIR","EXCLURE","LOẠI TRỪ","KECUALIKAN"},
    {"Player","Jugador","Jogador","Joueur","Người chơi","Pemain"},
    {"Identity hidden","Identidad oculta","Identidade oculta","Identité masquée","Đã ẩn danh tính","Identitas disembunyikan"},
    {"AUTO","AUTO","AUTO","AUTO","TỰ ĐỘNG","OTOMATIS"},
    {"MANUAL","MANUAL","MANUAL","MANUEL","THỦ CÔNG","MANUAL"},
    {"Show Less","Mostrar menos","Mostrar menos","Afficher moins","Hiện ít hơn","Tampilkan lebih sedikit"},
    {"Show All Checks","Mostrar todas las comprobaciones","Mostrar todas as verificações","Afficher toutes les vérifications","Hiện tất cả kiểm tra","Tampilkan semua pemeriksaan"},
    {"Show All Skills","Mostrar todas las habilidades","Mostrar todas as habilidades","Afficher toutes les compétences","Hiện tất cả kỹ năng","Tampilkan semua kemampuan"},
    {"IN","DENTRO","DENTRO","À PORTÉE","TRONG TẦM","DALAM JANGKAUAN"},
    {"OUT","FUERA","FORA","HORS PORTÉE","NGOÀI TẦM","DI LUAR JANGKAUAN"},
    {"READY","LISTO","PRONTO","PRÊT","SẴN SÀNG","SIAP"},
    {"Ken Off","Ken desactivado","Ken desligado","Ken désactivé","Ken tắt","Ken mati"},
    {"PvP Off","PvP desactivado","PvP desligado","PvP désactivé","PvP tắt","PvP mati"},
    {"In Combat","En combate","Em combate","En combat","Đang giao tranh","Dalam pertarungan"},
    {"Safe Zone","Zona segura","Zona segura","Zone sûre","Khu an toàn","Zona aman"},
    {"PvP On","PvP activado","PvP ligado","PvP activé","PvP bật","PvP aktif"},
    {"Exclude All","Excluir a todos","Excluir todos","Tout exclure","Loại trừ tất cả","Kecualikan semua"},
    {"Clear All","Borrar todo","Limpar tudo","Tout effacer","Xóa tất cả","Bersihkan semua"},
    {"WAIT","ESPERA","AGUARDE","ATTENTE","CHỜ","TUNGGU"},
    {"STOP","PARAR","PARAR","ARRÊT","DỪNG","BERHENTI"},
    {"MACRO","MACRO","MACRO","MACRO","MACRO","MAKRO"},
    {"TAGGED","EN COMBATE","EM COMBATE","EN COMBAT","ĐANG GIAO TRANH","DALAM PERTARUNGAN"},
    {"COPY","COPIAR","COPIAR","COPIER","SAO CHÉP","SALIN"},
    {"PC ONLY","SOLO PC","SOMENTE PC","PC UNIQUEMENT","CHỈ PC","KHUSUS PC"},
    {"Press a key","Pulsa una tecla","Pressione uma tecla","Appuyez sur une touche","Nhấn một phím","Tekan sebuah tombol"},
    {"Esc to cancel","Esc para cancelar","Esc para cancelar","Échap pour annuler","Esc để hủy","Esc untuk batal"},
    {"Backspace to clear","Retroceso para borrar","Backspace para limpar","Retour arrière pour effacer","Backspace để xóa","Backspace untuk menghapus"},
    {"Shared with:","Compartida con:","Compartilhada com:","Partagée avec :","Dùng chung với:","Digunakan bersama:"},
    {"LANGUAGE","IDIOMA","IDIOMA","LANGUE","NGÔN NGỮ","BAHASA"},
    {"Language","Idioma","Idioma","Langue","Ngôn ngữ","Bahasa"},
    {"Auto Detect","Detección automática","Detecção automática","Détection automatique","Tự động phát hiện","Deteksi otomatis"},
    {"Changes every script label immediately and saves for future sessions.","Cambia inmediatamente todos los textos del script y guarda la selección para futuras sesiones.","Altera imediatamente todos os textos do script e salva a seleção para sessões futuras.","Modifie immédiatement tous les textes du script et enregistre le choix pour les prochaines sessions.","Thay đổi ngay toàn bộ văn bản của script và lưu lựa chọn cho những lần sau.","Langsung mengubah semua teks script dan menyimpan pilihan untuk sesi berikutnya."},
    {"Language Changed","Idioma cambiado","Idioma alterado","Langue modifiée","Đã đổi ngôn ngữ","Bahasa diubah"},
    {"The interface is now using your selected language.","La interfaz ahora usa el idioma seleccionado.","A interface agora usa o idioma selecionado.","L'interface utilise maintenant la langue sélectionnée.","Giao diện hiện đang dùng ngôn ngữ bạn đã chọn.","Antarmuka sekarang menggunakan bahasa pilihan Anda."},
    {"ON-SCREEN BUTTONS","BOTONES EN PANTALLA","BOTÕES NA TELA","BOUTONS À L'ÉCRAN","NÚT TRÊN MÀN HÌNH","TOMBOL DI LAYAR"},
    {"Choose which shortcuts appear over the game. These switches only show or hide buttons.","Elige qué atajos aparecen sobre el juego. Estos interruptores solo muestran u ocultan botones.","Escolha quais atalhos aparecem durante o jogo. Essas opções apenas mostram ou ocultam botões.","Choisissez les raccourcis qui apparaissent dans le jeu. Ces options affichent ou masquent uniquement les boutons.","Chọn các phím tắt xuất hiện trong trò chơi. Các công tắc này chỉ hiển thị hoặc ẩn nút.","Pilih pintasan yang muncul di game. Pengaturan ini hanya menampilkan atau menyembunyikan tombol."},
    {"Show Aimbot","Mostrar Aimbot","Mostrar Aimbot","Afficher l'Aimbot","Hiện Aimbot","Tampilkan Aimbot"},
    {"Show Macro","Mostrar Macro","Mostrar Macro","Afficher la Macro","Hiện Macro","Tampilkan Makro"},
    {"Show Target Lock","Mostrar bloqueo de objetivo","Mostrar bloqueio de alvo","Afficher le verrouillage de cible","Hiện Khóa mục tiêu","Tampilkan Kunci Target"},
    {"Show Fast Attack","Mostrar ataque rápido","Mostrar ataque rápido","Afficher l'attaque rapide","Hiện Tấn công nhanh","Tampilkan Serangan Cepat"},
    {"Show Soru Aim","Mostrar Soru Aim","Mostrar Mira Soru","Afficher Soru Aim","Hiện Soru Aim","Tampilkan Soru Aim"},
    {"Show Reset Character","Mostrar reinicio de personaje","Mostrar reinício de personagem","Afficher la réinitialisation du personnage","Hiện Đặt lại nhân vật","Tampilkan Reset Karakter"},
    {"Show Sang Z","Mostrar Sang Z","Mostrar Sang Z","Afficher Sang Z","Hiện Sang Z","Tampilkan Sang Z"},
    {"Show Ragdoll","Mostrar Ragdoll","Mostrar Ragdoll","Afficher Ragdoll","Hiện Ragdoll","Tampilkan Ragdoll"},
    {"Show Diamond Boost","Mostrar Diamond Boost","Mostrar Diamond Boost","Afficher Diamond Boost","Hiện Diamond Boost","Tampilkan Diamond Boost"},
    {"Shows a shortcut for turning Skill Aimbot on or off.","Muestra un atajo para activar o desactivar Skill Aimbot.","Mostra um atalho para ativar ou desativar o Skill Aimbot.","Affiche un raccourci pour activer ou désactiver Skill Aimbot.","Hiển thị phím tắt để bật hoặc tắt Skill Aimbot.","Menampilkan pintasan untuk mengaktifkan atau menonaktifkan Skill Aimbot."},
    {"Shows a shortcut for starting or stopping Smart Macro.","Muestra un atajo para iniciar o detener Smart Macro.","Mostra um atalho para iniciar ou parar o Smart Macro.","Affiche un raccourci pour démarrer ou arrêter Smart Macro.","Hiển thị phím tắt để bắt đầu hoặc dừng Smart Macro.","Menampilkan pintasan untuk memulai atau menghentikan Smart Macro."},
    {"Shows a shortcut for locking or releasing your current target.","Muestra un atajo para bloquear o liberar tu objetivo actual.","Mostra um atalho para bloquear ou liberar seu alvo atual.","Affiche un raccourci pour verrouiller ou libérer votre cible actuelle.","Hiển thị phím tắt để khóa hoặc thả mục tiêu hiện tại.","Menampilkan pintasan untuk mengunci atau melepaskan target saat ini."},
    {"Shows a shortcut for turning Fast Attack on or off.","Muestra un atajo para activar o desactivar Fast Attack.","Mostra um atalho para ativar ou desativar o Fast Attack.","Affiche un raccourci pour activer ou désactiver Fast Attack.","Hiển thị phím tắt để bật hoặc tắt Fast Attack.","Menampilkan pintasan untuk mengaktifkan atau menonaktifkan Fast Attack."},
    {"Shows a one-tap aimed Soru shortcut.","Muestra un atajo de Soru dirigido con un solo toque.","Mostra um atalho de Soru direcionado com um toque.","Affiche un raccourci Soru ciblé en un seul appui.","Hiển thị phím tắt Soru nhắm mục tiêu bằng một lần chạm.","Menampilkan pintasan Soru terarah dengan satu ketukan."},
    {"Shows a reset shortcut that only works outside combat.","Muestra un atajo de reinicio que solo funciona fuera del combate.","Mostra um atalho de reinício que funciona apenas fora do combate.","Affiche un raccourci de réinitialisation utilisable uniquement hors combat.","Hiển thị phím tắt đặt lại chỉ hoạt động ngoài chiến đấu.","Menampilkan pintasan reset yang hanya berfungsi di luar pertarungan."},
    {"Shows a shortcut for the Sanguine Z boost.","Muestra un atajo para el impulso Sanguine Z.","Mostra um atalho para o impulso Sanguine Z.","Affiche un raccourci pour le boost Sanguine Z.","Hiển thị phím tắt cho tăng cường Sanguine Z.","Menampilkan pintasan untuk peningkatan Sanguine Z."},
    {"Shows a shortcut for the ragdoll-after-skill feature.","Muestra un atajo para la función de ragdoll después de una habilidad.","Mostra um atalho para o recurso de ragdoll após uma habilidade.","Affiche un raccourci pour la fonction de ragdoll après une compétence.","Hiển thị phím tắt cho tính năng ragdoll sau kỹ năng.","Menampilkan pintasan untuk fitur ragdoll setelah skill."},
    {"Shows a shortcut for the Diamond M1 boost.","Muestra un atajo para el impulso Diamond M1.","Mostra um atalho para o impulso Diamond M1.","Affiche un raccourci pour le boost Diamond M1.","Hiển thị phím tắt cho tăng cường Diamond M1.","Menampilkan pintasan untuk peningkatan Diamond M1."},
    {"SMART MACRO VIDEO GUIDE","GUÍA EN VIDEO DE SMART MACRO","GUIA EM VÍDEO DO SMART MACRO","GUIDE VIDÉO DE SMART MACRO","VIDEO HƯỚNG DẪN SMART MACRO","PANDUAN VIDEO SMART MACRO","SMART MACRO VIDEO GUIDE"},
    {"Video guide link copied!","¡Enlace de la guía en video copiado!","Link do guia em vídeo copiado!","Lien du guide vidéo copié !","Đã sao chép liên kết video hướng dẫn!","Tautan panduan video disalin!","Nakopya ang link ng video guide!"},
})

 
 
 
local DYNAMIC_INTERFACE_TRANSLATIONS={
    {template="Target locking is unavailable in this experience."},
    {template="Target unlocked."},
    {template="Enable Skill Aimbot and acquire a target first."},
    {template="No current target to lock."},
    {template="That target is no longer eligible."},
    {template="Current target locked."},
    {template="Enable Skill Aimbot first."},
    {template="Lock the permanent CamLock first."},
    {template="Lock a target or enable Skill CamLock first."},
    {template="No eligible target is available."},
    {template="No other eligible target is available."},
    {template="Next eligible target"},
    {template="Permanent CamLock released."},
    {template="Permanent CamLock is already free."},
    {template="Choose Permanent in CamLock Mode first."},
    {template="No current target to CamLock."},
    {template="CamLock locked to current target."},
    {pattern="^CamLock locked to (.+)%.$",template="CamLock locked to %s."},
    {pattern="^(.+) locked%.$",template="%s locked."},
    {pattern="^RUNNING · (%d+) · (.+)$",template="RUNNING · %s · %s"},
    {pattern="^V3 AFTER MOVE · (.+)$",template="V3 AFTER MOVE · %s"},
}

local function detectInterfaceLanguage()
    local locales={}
    pcall(function()
        local service=game:GetService("LocalizationService")
        if type(service.RobloxLocaleId)=="string" then table.insert(locales,service.RobloxLocaleId) end
        if type(service.SystemLocaleId)=="string" then table.insert(locales,service.SystemLocaleId) end
    end)
    for _,localeValue in ipairs(locales) do
        local locale=tostring(localeValue):lower()
        if locale:match("^es") then return "Spanish" end
        if locale:match("^pt") then return "Portuguese" end
        if locale:match("^fr") then return "French" end
        if locale:match("^vi") then return "Vietnamese" end
        if locale:match("^id") then return "Indonesian" end
        if locale:match("^fil") or locale:match("^tl") then return "Filipino" end
    end
    return "English"
end

local function loadLanguagePreference()
    local raw=readFile(LANGUAGE_FILE)
    if raw then
        local ok,data=pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
        local choice=ok and type(data)=="table" and data.language or nil
        if LANGUAGE_NAMES[choice] then return choice end
    end
    return "Auto"
end

local languagePreference=loadLanguagePreference()
interfaceLanguage=languagePreference=="Auto" and detectInterfaceLanguage() or languagePreference
local languageChangeListeners={}
local function translateText(text)
    if type(text)~="string" or interfaceLanguage=="English" then return text end
    local dictionary=TRANSLATIONS[interfaceLanguage]
    if not dictionary then return text end
    local exact=dictionary[text]
    if exact then return exact end
     
     
    local m1Category,m1Count,m1Plural=text:match("^(%u+) M1%s+•%s+(%d+) (ATTACKS?)$")
    if not m1Category then m1Category=text:match("^(%u+) M1$") end
    if m1Category=="MELEE" or m1Category=="FRUIT" or m1Category=="SWORD" or m1Category=="GUN" then
        local title=m1Category:sub(1,1)..m1Category:sub(2):lower()
        local translatedCategory=dictionary[m1Category] or dictionary[title] or title
        if m1Count then
            local attackKey=m1Plural=="ATTACK" and "Attack" or "Attacks"
            local translatedAttack=dictionary[m1Plural] or dictionary[attackKey] or attackKey
            return translatedCategory.." M1  •  "..m1Count.." "..translatedAttack
        end
        return translatedCategory.." M1"
    end
    exact=GENERATED_TRANSLATION_DICTIONARY[text]
    if exact then return exact end
    local leading,core,trailing=text:match("^(%s*)(.-)(%s*)$")
    local translatedCore=core and (dictionary[core] or GENERATED_TRANSLATION_DICTIONARY[core])
    if translatedCore then return leading..translatedCore..trailing end
    for _,entry in ipairs(DYNAMIC_INTERFACE_TRANSLATIONS) do
        if entry.pattern then
            local values={text:match(entry.pattern)}
            if values[1] then
                local template=dictionary[entry.template] or GENERATED_TRANSLATION_DICTIONARY[entry.template]
                if template then
                    local ok,rendered=pcall(string.format,template,table.unpack(values))
                    if ok then return rendered end
                end
            end
        end
    end
    for _,entry in ipairs(TRANSLATION_PATTERNS[interfaceLanguage] or {}) do
        local pattern,replacement=entry[1],entry[2]
        if type(pattern)=="string" and type(replacement)=="string" then
            local translated,count=text:gsub(pattern,replacement)
            if count>0 then return translated end
        end
    end
    return text
end
local function saveLanguagePreference(choice)
    if not LANGUAGE_NAMES[choice] then return false end
    local previousPreference=languagePreference
    local previousLanguage=interfaceLanguage
    languagePreference=choice
    interfaceLanguage=choice=="Auto" and detectInterfaceLanguage() or choice
    local generatedPackLoader=_G.__CokeboysLoadGeneratedTranslationPack
    if type(generatedPackLoader)=="function" then
        generatedPackLoader(interfaceLanguage)
    else
        rebuildGeneratedTranslationDictionary(interfaceLanguage)
    end
    getgenv().__CokeboysLanguagePreference=languagePreference
    getgenv().__CokeboysInterfaceLanguage=interfaceLanguage
    writeFile(LANGUAGE_FILE,game:GetService("HttpService"):JSONEncode({language=languagePreference}))
    if previousPreference~=languagePreference or previousLanguage~=interfaceLanguage then
        for _,callback in ipairs(languageChangeListeners) do
            pcall(callback,interfaceLanguage,previousLanguage,languagePreference)
        end
    end
    return true
end
getgenv().__CokeboysLanguagePreference=languagePreference
getgenv().__CokeboysInterfaceLanguage=interfaceLanguage
_G.__CokeboysTranslate=translateText
_G.__CokeboysLanguageOptions=LANGUAGE_OPTIONS
_G.__CokeboysSetLanguagePreference=saveLanguagePreference
_G.__CokeboysOnLanguageChanged=function(callback)
    if type(callback)~="function" then return function() end end
    table.insert(languageChangeListeners,callback)
    local connected=true
    return function()
        if not connected then return end
        connected=false
        local index=table.find(languageChangeListeners,callback)
        if index then table.remove(languageChangeListeners,index) end
    end
end

 
 
local function cokeboysNotificationsEnabled()
    local runtimePreference = getgenv().__CokeboysNotificationsDisabled
    if runtimePreference ~= nil then
        return runtimePreference ~= true
    end

     
     
    local legacyRuntimePreference = getgenv().__CokeboysNotificationsEnabled
    if legacyRuntimePreference ~= nil then
        local disabled = legacyRuntimePreference == false
        getgenv().__CokeboysNotificationsDisabled = disabled
        getgenv().__CokeboysNotificationsEnabled = nil
        return not disabled
    end

    local raw = readFile(SETTINGS_FILE)
    if raw then
        local ok, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw)
        end)
        if ok and type(data) == "table" then
            local disabled = data.DisableNotifications == true
            if data.DisableNotifications == nil and data.NotificationsEnabled ~= nil then
                disabled = data.NotificationsEnabled == false
            end
            getgenv().__CokeboysNotificationsDisabled = disabled
            return not disabled
        end
    end

    getgenv().__CokeboysNotificationsDisabled = false
    return true
end

 
 
 
local bootstrapEnvironment=getgenv()
local existingLoaderController=bootstrapEnvironment.__CokeboysLoaderController

 
 
if bootstrapEnvironment.CokeboysScriptLoaded==true then
    local showExisting=_G.__CokeboysShowInterface
    if type(showExisting)=="function" then pcall(showExisting) end
    if cokeboysNotificationsEnabled() then pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title="Cokeboys",Text="Script is already running!",Duration=4,
        })
    end) end
    return
end

local ownershipNow=os.clock()
local existingIsCurrent=type(existingLoaderController)=="table"
    and existingLoaderController.disposed~=true
    and existingLoaderController.ownsLaunch==true
    and ownershipNow-(tonumber(existingLoaderController.updatedAt) or 0)<120
if existingIsCurrent then
    if type(existingLoaderController.focus)=="function" then pcall(existingLoaderController.focus,existingLoaderController) end
    return
end
if type(existingLoaderController)=="table" and type(existingLoaderController.dispose)=="function" then
    pcall(existingLoaderController.dispose,existingLoaderController,"stale launch replaced")
end

local loaderController={
    version=4,state="BOOT",purpose="launch",launchGeneration=(tonumber(bootstrapEnvironment.__CokeboysLoaderGeneration) or 0)+1,
    validationGeneration=0,monitorGeneration=0,selectionCommitted=false,initializationCommitted=false,
    resolvedExperience=nil,authenticatedKey=nil,cancelled=false,disposed=false,ownsLaunch=true,
    updatedAt=ownershipNow,gui=nil,blur=nil,loaderConnections={},activeKey=nil,
}
 
 
 
 
 
local loaderPublicOwner=(function()
    local lifecycleMeta={
        __index=function(_,field)
            if field=="version" or field=="state" or field=="ownsLaunch"
                or field=="updatedAt" or field=="disposed" then
                return loaderController[field]
            end
            return nil
        end,
    }
    local owner=table.freeze(setmetatable({
        focus=function() loaderController:focus() end,
        dispose=function(_,reason) loaderController:dispose(reason) end,
    },lifecycleMeta))
     
     
    lifecycleMeta.__metatable="Cokeboys loader lifecycle handle"
    table.freeze(lifecycleMeta)
    return owner
end)()
local authenticatedExperienceLaunch=nil
bootstrapEnvironment.__CokeboysLoaderGeneration=loaderController.launchGeneration
bootstrapEnvironment.__CokeboysLoaderController=loaderPublicOwner
 
bootstrapEnvironment.__CokeboysResolvedExperienceLaunch=nil
bootstrapEnvironment.__CokeboysKeyAccessState=nil
_G.__CokeboysMarkRuntimeReady=nil
bootstrapEnvironment.__CokeboysLaunchInProgress=true

local LOADER_TRANSITIONS={
    BOOT={AUTH=true,VALIDATING=true,CANCELLED=true,DISPOSED=true},
    AUTH={VALIDATING=true,CANCELLED=true,DISPOSED=true},
    AUTH_ERROR={VALIDATING=true,CANCELLED=true,DISPOSED=true},
    VALIDATING={AUTH_ERROR=true,MODE_SELECT=true,INITIALIZING=true,READY=true,CANCELLED=true,DISPOSED=true},
    MODE_SELECT={INITIALIZING=true,CANCELLED=true,DISPOSED=true},
    INITIALIZING={READY=true,CANCELLED=true,DISPOSED=true},
    READY={AUTH=true,SWITCHING=true,DISPOSED=true},
    SWITCHING={REVALIDATING=true,CANCELLED=true,DISPOSED=true},
    REVALIDATING={INITIALIZING=true,CANCELLED=true,DISPOSED=true},
    CANCELLED={DISPOSED=true},
    DISPOSED={},
}
local cancelCurrentAuthentication
function loaderController:isCurrent()
    return bootstrapEnvironment.__CokeboysLoaderController==loaderPublicOwner and self.disposed~=true
end
function loaderController:transition(nextState,expectedState)
    if not self:isCurrent() or self.cancelled or self.disposed then return false end
    if expectedState and self.state~=expectedState then return false end
    if not (LOADER_TRANSITIONS[self.state] and LOADER_TRANSITIONS[self.state][nextState]) then return false end
    self.state=nextState self.updatedAt=os.clock()
    return true
end
function loaderController:ownsAttempt(launchGeneration,validationGeneration,expectedState)
    return self:isCurrent() and not self.cancelled and not self.disposed
        and self.launchGeneration==launchGeneration and self.validationGeneration==validationGeneration
        and (expectedState==nil or self.state==expectedState)
end
function loaderController:releaseLaunchOwnership()
    self.ownsLaunch=false
    if bootstrapEnvironment.__CokeboysLoaderController==loaderPublicOwner then
        bootstrapEnvironment.__CokeboysLaunchInProgress=false
    end
end
function loaderController:focus()
    self.updatedAt=os.clock()
    if self.gui then pcall(function() self.gui.Enabled=true end) end
end
_G.__CokeboysCancelLoader=function()
    if loaderController:isCurrent() and type(cancelCurrentAuthentication)=="function" then
        cancelCurrentAuthentication("cancel requested")
    end
end

local activeKeyGui=nil
local activeKeyBlur=nil
 
 
local keyAccessState={valid=false,permanent=false,checkedAt=os.time()}
local keyExpiryBanner=nil
local function clearKeyExpiryBanner()
    local banner=keyExpiryBanner
    keyExpiryBanner=nil
    if banner then pcall(function() banner:Destroy() end) end
end
local function refreshKeyAccessState()
    local refresh=getgenv().__CokeboysRefreshHeaderKeyStatus
    if type(refresh)=="function" then pcall(refresh) end
end
local function clearKeyAccessState()
    clearKeyExpiryBanner()
    keyAccessState.valid=false
    keyAccessState.permanent=false
    keyAccessState.expiresAt=nil
    keyAccessState.checkedAt=os.time()
    refreshKeyAccessState()
end
local function publishKeyAccessState(data)
    keyAccessState.valid=true
    keyAccessState.permanent=data and data.permanent==true or false
    keyAccessState.expiresAt=data and tonumber(data.expires_at) or nil
    keyAccessState.checkedAt=os.time()
    refreshKeyAccessState()
end
local function disconnectLoaderConnections()
    for _,connection in ipairs(loaderController.loaderConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(loaderController.loaderConnections)
end
local function clearKeyArtifacts()
    loaderController.suppressDestroy=true
    disconnectLoaderConnections()
    if activeKeyGui then pcall(function() activeKeyGui:Destroy() end); activeKeyGui=nil end
    if activeKeyBlur then pcall(function() activeKeyBlur:Destroy() end); activeKeyBlur=nil end
    loaderController.gui=nil loaderController.blur=nil loaderController.suppressDestroy=false
end
local function spawnKeyTask(callback,...)
    local managed=_G.__CokeboysSpawnRuntimeTask
    if type(managed)=="function" then return managed(callback,...) end
    return task.spawn(callback,...)
end
local function disposeLoaderController(reason,removeArtifacts)
    if loaderController.disposed then return end
    clearKeyExpiryBanner()
    loaderController.validationGeneration+=1 loaderController.monitorGeneration+=1
    loaderController.cancelled=true
    if loaderController.state~="DISPOSED" then
        if loaderController.state~="CANCELLED" and LOADER_TRANSITIONS[loaderController.state].CANCELLED then
            loaderController.state="CANCELLED"
        end
        loaderController.state="DISPOSED"
    end
    loaderController.disposed=true loaderController.updatedAt=os.clock()
    if removeArtifacts~=false then clearKeyArtifacts() else disconnectLoaderConnections() end
    loaderController:releaseLaunchOwnership()
    if bootstrapEnvironment.__CokeboysLoaderController==loaderPublicOwner then
        bootstrapEnvironment.__CokeboysLoaderController=nil
    end
end
loaderController.dispose=function(_,reason) disposeLoaderController(reason,true) end
cancelCurrentAuthentication=function(reason)
    if not loaderController:isCurrent() or loaderController.disposed then return end
    loaderController.validationGeneration+=1
    clearKeyArtifacts()
    if loaderController.purpose=="replace-key" and bootstrapEnvironment.CokeboysScriptLoaded==true then
        loaderController.cancelled=false loaderController.state="READY" loaderController.purpose=nil
        loaderController.updatedAt=os.clock()
        return
    end
    loaderController.cancelled=true loaderController.state="CANCELLED"
    loaderController:releaseLaunchOwnership()
    loaderController.state="DISPOSED" loaderController.disposed=true
    if bootstrapEnvironment.__CokeboysLoaderController==loaderPublicOwner then
        bootstrapEnvironment.__CokeboysLoaderController=nil
    end
end
_G.__CokeboysKeyValidationCleanup=function()
    disposeLoaderController("runtime cleanup",true)
    clearKeyAccessState()
end
local function markRuntimeReady()
    if not loaderController:isCurrent() or loaderController.state~="INITIALIZING"
        or loaderController.selectionCommitted~=true or loaderController.initializationCommitted~=true
        or keyAccessState.valid~=true or loaderController.authenticatedKey==nil
        or type(authenticatedExperienceLaunch)~="table"
        or authenticatedExperienceLaunch.authenticated~=true
        or authenticatedExperienceLaunch.generation~=loaderController.launchGeneration
        or authenticatedExperienceLaunch.validationGeneration~=loaderController.authenticationGeneration
        or not VALID_EXPERIENCE_IDS[authenticatedExperienceLaunch.experience] then return false end
    if not loaderController:transition("READY","INITIALIZING") then return false end
    authenticatedExperienceLaunch=nil
    loaderController.purpose=nil
    loaderController:releaseLaunchOwnership()
    return true
end
 
 
 
 
 
 
local authenticFullUnload
local function endExpiredKeySession(message)
    disposeLoaderController("key expired",true)
    clearKeyAccessState()
    clearSavedKeyFile()

    local reason = message or "Your key has expired or been revoked."
    local unload = authenticFullUnload
    if type(unload) == "function" then
        pcall(unload)
    else
         
         
        getgenv().CokeboysScriptLoaded = false
    end

    if cokeboysNotificationsEnabled() then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Cokeboys Key Expired",
                Text = reason .. " Script features were disabled. Get a new key and re-execute to continue.",
                Duration = 8,
            })
        end)
    end
end

local function confirmKeyIsInvalid(key)
    local hwid, username = getPlayerInfo()
    local valid, message, data, completed = validateKey(key, hwid, username, GAME_NAME)
    if valid then return false, nil, data end
    if not completed then return false end

     
     
    task.wait(5)
    hwid, username = getPlayerInfo()
    local validAgain, messageAgain, dataAgain, completedAgain = validateKey(key, hwid, username, GAME_NAME)
    if validAgain then return false, nil, dataAgain end
    if not completedAgain then return false end
    return true, messageAgain or message
end

local function keyExpiryBannerPosition(width,height,viewport,obstacles)
    local x=math.floor((viewport.X-width)/2)
    local y=math.min(82,math.max(8,viewport.Y-height-8))
     
    for _=1,#obstacles+1 do
        local bottom=y
        for _,rect in ipairs(obstacles) do
            if x<rect.x+rect.w+8 and x+width>rect.x-8
                and y<rect.y+rect.h+8 and y+height>rect.y-8 then
                bottom=math.max(bottom,rect.y+rect.h+12)
            end
        end
        if bottom==y then return x,y end
        y=bottom
        if y+height>viewport.Y-8 then return nil,nil end
    end
    return nil,nil
end
local function positionKeyExpiryBanner()
    local banner=keyExpiryBanner
    if not banner or not banner.Parent then return end
    banner.Enabled=getgenv().CokeboysGuiHidden~=true
    local card=banner:FindFirstChild("WarningCard")
    local camera=workspace.CurrentCamera
    if not card or not camera then return end
    local viewport=camera.ViewportSize
    local title=card:FindFirstChild("ExpiryTitle")
    local expiry=keyAccessState.expiresAt
    if title and type(expiry)=="number" then
        local seconds=math.max(0,expiry-os.time())
        title.Text=string.format("KEY EXPIRES IN %dm %02ds",math.floor(seconds/60),seconds%60)
    end
    local obstacles={}
    local roots={game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"),game:GetService("CoreGui")}
    if type(gethui)=="function" then local ok,root=pcall(gethui);if ok and root then roots[#roots+1]=root end end
    local seen={}
    for _,root in ipairs(roots) do
        if root and not seen[root] then
            seen[root]=true
            for _,name in ipairs({"CokeboysSessionInfo","CokeboysActiveModules","CokeboysFPSPing","CokeboysStatus2"}) do
                local screen=root:FindFirstChild(name)
                if screen and screen.Enabled then
                    for _,object in ipairs(screen:GetChildren()) do
                        if object:IsA("GuiObject") and object.Visible then
                            local pos,size=object.AbsolutePosition,object.AbsoluteSize
                            if size.X>0 and size.Y>0 then obstacles[#obstacles+1]={x=pos.X,y=pos.Y,w=size.X,h=size.Y} end
                        end
                    end
                end
            end
        end
    end
    local width=math.min(440,math.max(180,viewport.X-24))
    local height=88
    local x,y=keyExpiryBannerPosition(width,height,viewport,obstacles)
    if not x then
         
        width=math.min(300,math.max(180,viewport.X-24));height=72
        x,y=keyExpiryBannerPosition(width,height,viewport,obstacles)
    end
    card.Visible=x~=nil
    if x then card.Size=UDim2.fromOffset(width,height);card.Position=UDim2.fromOffset(x,y) end
end
local function showKeyExpiryWarning(remaining)
    clearKeyExpiryBanner()
    local gui=Instance.new("ScreenGui")
    gui.Enabled=getgenv().CokeboysGuiHidden~=true
    gui.Name="CokeboysKeyExpiryWarning";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true
    gui.DisplayOrder=1010;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local card=Instance.new("Frame")
    card.Name="WarningCard";card.BackgroundColor3=Color3.fromRGB(20,20,25)
    card.BackgroundTransparency=0;card.BorderSizePixel=0;card.Active=false;card.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,10);corner.Parent=card
    local stroke=Instance.new("UIStroke");stroke.Thickness=2
    stroke.Color=remaining<=60 and Color3.fromRGB(255,105,105) or Color3.fromRGB(255,212,55);stroke.Parent=card
    local seconds=math.max(1,math.floor(remaining))
    local duration=string.format("%dm %02ds",math.floor(seconds/60),seconds%60)
    local title=Instance.new("TextLabel")
    title.Name="ExpiryTitle";title.BackgroundTransparency=1;title.Position=UDim2.fromOffset(12,8)
    title.Size=UDim2.new(1,-24,0,24);title.Font=Enum.Font.GothamBold;title.TextSize=18
    title.TextColor3=stroke.Color;title.Text="KEY EXPIRES IN "..duration;title.TextWrapped=true;title.Parent=card
    local text=Instance.new("TextLabel")
    text.Name="ExpiryMessage";text.BackgroundTransparency=1;text.Position=UDim2.fromOffset(12,34)
    text.Size=UDim2.new(1,-24,1,-40);text.Font=Enum.Font.GothamMedium;text.TextSize=14
    text.TextColor3=Color3.fromRGB(245,245,245);text.TextWrapped=true
    text.Text="Leave combat or renew your key. You may be disconnected when it expires.";text.Parent=card
    gui.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    keyExpiryBanner=gui
    positionKeyExpiryBanner()
    task.delay(12,function() if keyExpiryBanner==gui then clearKeyExpiryBanner() end end)
end
local function syncKeyExpiryVisibility(hidden)
    if keyExpiryBanner then
        keyExpiryBanner.Enabled=hidden~=true
        if not hidden then positionKeyExpiryBanner() end
    elseif not hidden and keyAccessState.valid and not keyAccessState.permanent
        and type(keyAccessState.expiresAt)=="number" then
        local remaining=keyAccessState.expiresAt-os.time()
        if remaining>0 and remaining<=300 then showKeyExpiryWarning(remaining) end
    end
end
local function startKeyValidationMonitor(key)
    loaderController.monitorGeneration+=1
    local monitorGeneration=loaderController.monitorGeneration
    loaderController.activeKey=key
     
     
    spawnKeyTask(function()
        local warned,warningExpiry={},nil
        local function warningStage(remaining)
            if remaining<=0 or remaining>300 then return nil end
            return math.ceil(remaining/30)*30
        end
        while loaderController:isCurrent() and monitorGeneration==loaderController.monitorGeneration do
            local expiry=keyAccessState.expiresAt
            if keyAccessState.valid and not keyAccessState.permanent and type(expiry)=="number" then
                if expiry~=warningExpiry then warned={} warningExpiry=expiry clearKeyExpiryBanner() end
                local remaining=expiry-os.time()
                local stage=warningStage(remaining)
                if stage and not warned[stage] then
                     
                     
                    local invalid,message,refreshed=confirmKeyIsInvalid(key)
                    if not loaderController:isCurrent() or monitorGeneration~=loaderController.monitorGeneration then return end
                    if invalid then endExpiredKeySession(message) return end
                    if refreshed then publishKeyAccessState(refreshed) end
                    expiry=keyAccessState.expiresAt
                    if expiry~=warningExpiry then warned={} warningExpiry=expiry clearKeyExpiryBanner() end
                    remaining=type(expiry)=="number" and expiry-os.time() or 0
                    stage=not keyAccessState.permanent and warningStage(remaining) or nil
                    if stage and not warned[stage] then
                         
                         
                        for threshold=stage,300,30 do warned[threshold]=true end
                        pcall(showKeyExpiryWarning,remaining)
                    end
                end
            end
            local remaining=type(keyAccessState.expiresAt)=="number" and keyAccessState.expiresAt-os.time() or math.huge
            if keyExpiryBanner then pcall(positionKeyExpiryBanner) end
            task.wait(remaining>300 and math.min(30,math.max(1,remaining-300)) or 1)
        end
    end)
    spawnKeyTask(function()
        while loaderController:isCurrent() and monitorGeneration==loaderController.monitorGeneration do
            task.wait(300)
            if not loaderController:isCurrent() or monitorGeneration~=loaderController.monitorGeneration then return end
            local invalid,msg,refreshedData=confirmKeyIsInvalid(key)
            if not loaderController:isCurrent() or monitorGeneration~=loaderController.monitorGeneration then return end
            if refreshedData then publishKeyAccessState(refreshedData) end
            if invalid then endExpiredKeySession(msg) return end
        end
    end)
end

local function runKeySystem(onSuccess,purpose)
    purpose=purpose=="replace-key" and "replace-key" or "launch"
    if not loaderController:isCurrent() then return false end
    if purpose=="replace-key" then
        if bootstrapEnvironment.CokeboysScriptLoaded~=true or loaderController.state~="READY" then
            loaderController:focus() return false
        end
        local reset=_G.__CokeboysRequestKeyReset
        if type(reset)~="function" then return false,"Key reset unavailable" end
        return reset()
    elseif loaderController.state=="BOOT" then
        if not loaderController:transition("AUTH","BOOT") then return false end
    elseif loaderController.state~="AUTH" and loaderController.state~="AUTH_ERROR" then
        loaderController:focus() return false
    end
    loaderController.purpose=purpose
    loaderController.validationGeneration+=1
    local sessionValidationGeneration=loaderController.validationGeneration
    local launchGeneration=loaderController.launchGeneration
    clearKeyArtifacts()
    local showExperienceSelector

    local function initializeAuthenticatedExperience(key,experience,rememberExperience,attemptGeneration,savePreference)
        if not VALID_EXPERIENCE_IDS[experience]
            or not loaderController:ownsAttempt(launchGeneration,attemptGeneration,nil)
            or (loaderController.state~="VALIDATING" and loaderController.state~="MODE_SELECT")
            or loaderController.authenticatedKey~=key
            or loaderController.authenticationGeneration~=attemptGeneration
            or keyAccessState.valid~=true
            or loaderController.selectionCommitted or loaderController.initializationCommitted then return false end
        local expectedState=loaderController.state
        if not loaderController:transition("INITIALIZING",expectedState) then return false end

         
         
        loaderController.selectionCommitted=true
        loaderController.initializationCommitted=true
        loaderController.resolvedExperience=experience
        loaderController.authenticatedKey=key
        authenticatedExperienceLaunch={
            authenticated=true,generation=launchGeneration,validationGeneration=attemptGeneration,experience=experience,
        }

        if savePreference and not writeLoaderPreference(experience,rememberExperience) then
            warn("Cokeboys loader preference could not be saved")
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title="Cokeboys",Text=translateText("Preference could not be saved"),Duration=5,
                })
            end)
        end

         
         
        task.defer(function()
            if not loaderController:ownsAttempt(launchGeneration,attemptGeneration,"INITIALIZING") then return end
            clearKeyArtifacts()
            local initialized,initializationError=pcall(onSuccess)
            if not initialized or loaderController.state~="READY" then
                warn("Cokeboys initialization failed: "..tostring(initializationError or "runtime did not report ready"))
                authenticatedExperienceLaunch=nil
                local unload=bootstrapEnvironment.CokeboysFullUnload
                if loaderController.fullUnloadInstalled==true and type(unload)=="function" then
                    pcall(unload)
                else
                    bootstrapEnvironment.CokeboysScriptLoaded=false
                end
                if loaderController:isCurrent() then disposeLoaderController("initialization failed",true) end
                return
            end
            startKeyValidationMonitor(key)
        end)
        return true
    end

    local function authenticatedContinuation(key,data,saveCandidate,attemptGeneration)
    if not loaderController:ownsAttempt(launchGeneration,attemptGeneration,"VALIDATING") then return false end
    if type(key)~="string" or key=="" or type(data)~="table" or data.success~=true
        or data.script_id~=PRIVATE_SCRIPT_ID or type(data.provider_key)~="string" then return false end
    local environment=getgenv()
    local pending
    if environment.__CokeboysLuaProtSession==nil then
        local existing=environment.__CokeboysLuaProtPendingStart
        if type(existing)=="table" and existing.JobId==tostring(game.JobId) then
            warn("Cokeboys: authentication is already starting; do not execute again")
            return false
        end
         
        pending={JobId=tostring(game.JobId),Variant=PRIVATE_VARIANT,Failed=false}
        environment.__CokeboysLuaProtPendingStart=pending
    end
     
    if saveCandidate then writeFile(KEY_FILE,key) end
    disposeLoaderController("private provider handoff",true)
    task.spawn(function()
        local environment=getgenv()
        local session=environment.__CokeboysLuaProtSession
        if type(session)=="table" then
            if session.Version~="cb-luaprot-bridge-session-v2" or session.Variant~=PRIVATE_VARIANT
                or session.JobId~=tostring(game.JobId) then
                warn("Cokeboys: rejoin before changing tester builds") return
            end
            if session.BridgeProviderKey~=data.provider_key then
                warn("Cokeboys: your tester access changed; rejoin before launching again") return
            end
            local ok,started=pcall(session.Reload,key)
            if not ok or started~=true then warn("Cokeboys: tester reload could not start") end
            return
        end
        environment.__CokeboysLuaProtLegacyHandoff={Key=key,Variant=PRIVATE_VARIANT,JobId=tostring(game.JobId)}
        environment.lp_key=data.provider_key
        local notice
        if type(installCokeboysAuthNotice)=="function" then
            local created,value=pcall(installCokeboysAuthNotice)
            if created then notice=value end
        end
        local startupJob=tostring(game.JobId)
        task.spawn(function()
             
             
            for _=1,300 do
                if tostring(game.JobId)~=startupJob then return end
                local startedSession=environment.__CokeboysLuaProtSession
                if type(startedSession)=="table" then
                    if startedSession.Version=="cb-luaprot-bridge-session-v2"
                        and startedSession.Variant==PRIVATE_VARIANT and startedSession.JobId==startupJob then
                        startedSession.BridgeProviderKey=data.provider_key
                        if environment.__CokeboysLuaProtPendingStart==pending then
                            environment.__CokeboysLuaProtPendingStart=nil
                        end
                        if notice then pcall(notice.finish) end
                    end
                    return
                end
                task.wait(0.1)
            end
        end)
        local ok=pcall(function()
            local source=game:HttpGet("https://luaprot.net/api/v3/loaders/get/"..PRIVATE_SCRIPT_ID)
            local loader=loadstring(source)
            if type(loader)~="function" then error("Invalid protected loader") end
            loader()
        end)
        environment.__CokeboysLuaProtLegacyHandoff=nil
        if not ok then
             
             
            if pending and environment.__CokeboysLuaProtPendingStart==pending then pending.Failed=true end
            if notice then pcall(notice.fail) end
            warn("Cokeboys: protected tester could not start; rejoin before trying again")
        end
    end)
    return true
end

    showExperienceSelector=function(key,attemptGeneration,preference)
        if not loaderController:ownsAttempt(launchGeneration,attemptGeneration,"MODE_SELECT") then return end
        local playerGui=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
         
         
         
        disconnectLoaderConnections()
        local gui=activeKeyGui
        if gui then
            local oldPage=gui:FindFirstChild("KeyPageLayout")
            if oldPage then oldPage:Destroy() end
        else
            gui=Instance.new("ScreenGui")
            gui.Name="CokeboysKeySystem"
            gui.ResetOnSpawn=false
            gui.IgnoreGuiInset=true
            gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
            gui.Parent=playerGui
            activeKeyGui=gui
            loaderController.gui=gui
        end

        local Blur=activeKeyBlur
        if not Blur then
            pcall(function()
                Blur=Instance.new("BlurEffect")
                Blur.Name="CokeboysKeyBlur"
                Blur.Size=14
                Blur.Parent=game:GetService("Lighting")
            end)
            activeKeyBlur=Blur
            loaderController.blur=Blur
        end
        local destroyingConnection=gui.Destroying:Connect(function()
            if activeKeyGui==gui then activeKeyGui=nil end
            if loaderController.gui==gui then loaderController.gui=nil end
            if Blur and activeKeyBlur==Blur then pcall(function() Blur:Destroy() end); activeKeyBlur=nil end
            if loaderController.blur==Blur then loaderController.blur=nil end
            if not loaderController.suppressDestroy then cancelCurrentAuthentication("experience selector destroyed") end
        end)
        table.insert(loaderController.loaderConnections,destroyingConnection)

        local Backdrop=gui:FindFirstChild("Backdrop")
        if not Backdrop then
            Backdrop=Instance.new("Frame")
            Backdrop.Name="Backdrop"
            Backdrop.Size=UDim2.fromScale(1,1)
            Backdrop.BackgroundColor3=Color3.fromRGB(4,4,7)
            Backdrop.BackgroundTransparency=0.32
            Backdrop.BorderSizePixel=0
            Backdrop.Parent=gui
        end

        local LayoutRoot=Instance.new("Frame")
        LayoutRoot.Name="ExperiencePageLayout"
        LayoutRoot.AnchorPoint=Vector2.new(0.5,0.5)
        LayoutRoot.Position=UDim2.fromScale(0.5,0.5)
        LayoutRoot.BackgroundTransparency=1
        LayoutRoot.BorderSizePixel=0
        LayoutRoot.Parent=gui
        local LayoutScale=Instance.new("UIScale")
        LayoutScale.Parent=LayoutRoot

        local Frame=Instance.new("Frame")
        Frame.Name="ExperienceSelectorCard"
        Frame.Size=UDim2.fromScale(1,1)
        Frame.BackgroundColor3=Color3.fromRGB(9,9,12)
        Frame.BorderSizePixel=0
        Frame.ClipsDescendants=true
        Frame.Parent=LayoutRoot
        local Corner=Instance.new("UICorner") Corner.CornerRadius=UDim.new(0,8) Corner.Parent=Frame
        local Stroke=Instance.new("UIStroke")
        Stroke.Name="ExperienceSelectorBorder" Stroke.Color=Color3.fromRGB(255,210,31)
        Stroke.Thickness=1.5 Stroke.Transparency=0.16 Stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border Stroke.Parent=Frame
        local OuterGlow=Instance.new("UIStroke")
        OuterGlow.Name="ExperienceSelectorBorderGlow" OuterGlow.Color=Color3.fromRGB(255,210,31)
        OuterGlow.Thickness=3 OuterGlow.Transparency=0.88 OuterGlow.ApplyStrokeMode=Enum.ApplyStrokeMode.Border OuterGlow.Parent=Frame

        local CloseBtn=Instance.new("TextButton")
        CloseBtn.Name="CloseButton" CloseBtn.Size=UDim2.fromOffset(32,32) CloseBtn.AnchorPoint=Vector2.new(1,0)
        CloseBtn.Position=UDim2.new(1,-18,0,13) CloseBtn.BackgroundColor3=Color3.fromRGB(17,17,20)
        CloseBtn.BorderSizePixel=0 CloseBtn.Text="×" CloseBtn.TextColor3=Color3.fromRGB(180,178,188)
        CloseBtn.AutoButtonColor=false
        CloseBtn.TextSize=20 CloseBtn.Font=Enum.Font.GothamBold CloseBtn.Parent=Frame
        local CloseCorner=Instance.new("UICorner") CloseCorner.CornerRadius=UDim.new(0,4) CloseCorner.Parent=CloseBtn
        local closeStroke=Instance.new("UIStroke") closeStroke.Color=Color3.fromRGB(31,31,35) closeStroke.Parent=CloseBtn

        local Title=Instance.new("TextLabel")
        local PikachuLogoFrame=Instance.new("Frame")
        PikachuLogoFrame.Name="CokeboysPikachuLogo" PikachuLogoFrame.Size=UDim2.fromOffset(32,32) PikachuLogoFrame.Position=UDim2.fromOffset(32,13)
        PikachuLogoFrame.BackgroundColor3=Color3.fromRGB(255,210,31) PikachuLogoFrame.BorderSizePixel=0 PikachuLogoFrame.Parent=Frame
        local logoCorner=Instance.new("UICorner") logoCorner.CornerRadius=UDim.new(0,7) logoCorner.Parent=PikachuLogoFrame
        local PikachuLogo=Instance.new("ImageLabel")
        PikachuLogo.Name="PikachuLogoImage" PikachuLogo.Size=UDim2.fromScale(1,1) PikachuLogo.BackgroundTransparency=1
        PikachuLogo.Image="rbxthumb://type=Asset&id=128335611339738&w=420&h=420" PikachuLogo.ScaleType=Enum.ScaleType.Crop PikachuLogo.Parent=PikachuLogoFrame
        for index,x in ipairs({5,23}) do
            local cheek=Instance.new("Frame") cheek.Name="CheekAccent"..index cheek.Size=UDim2.fromOffset(4,2)
            cheek.Position=UDim2.fromOffset(x,26) cheek.BackgroundColor3=Color3.fromRGB(166,55,63) cheek.BackgroundTransparency=0.18
            cheek.BorderSizePixel=0 cheek.ZIndex=3 cheek.Parent=PikachuLogoFrame
            local cheekCorner=Instance.new("UICorner") cheekCorner.CornerRadius=UDim.new(1,0) cheekCorner.Parent=cheek
        end

        Title.Name="Brand" Title.Size=UDim2.new(1,-128,0,22) Title.Position=UDim2.new(0,76,0,18)
        Title.BackgroundTransparency=1 Title.Text="COKEBOYS" Title.TextColor3=Color3.fromRGB(245,245,245)
        Title.TextSize=16 Title.Font=Enum.Font.GothamBold Title.TextXAlignment=Enum.TextXAlignment.Left Title.Parent=Frame
        local BoltAccent=Instance.new("TextLabel")
        BoltAccent.Name="BrandBoltAccent" BoltAccent.Size=UDim2.fromOffset(18,22) BoltAccent.Position=UDim2.fromOffset(91,0)
        BoltAccent.BackgroundTransparency=1 BoltAccent.Text="⚡" BoltAccent.TextColor3=Color3.fromRGB(255,210,31)
        BoltAccent.TextSize=15 BoltAccent.Font=Enum.Font.GothamBold BoltAccent.TextXAlignment=Enum.TextXAlignment.Left BoltAccent.Parent=Title
        local Heading=Instance.new("TextLabel")
        Heading.Name="SelectorHeading" Heading.Size=UDim2.new(1,-64,0,27) Heading.Position=UDim2.new(0,32,0,51)
        Heading.BackgroundTransparency=1 Heading.TextColor3=Color3.fromRGB(245,245,245) Heading.TextSize=22
        Heading.Font=Enum.Font.GothamBold Heading.TextWrapped=true Heading.TextXAlignment=Enum.TextXAlignment.Left Heading.Parent=Frame
        local Subtitle=Instance.new("TextLabel")
        Subtitle.Name="SelectorSubtitle" Subtitle.Size=UDim2.new(1,-64,0,18) Subtitle.Position=UDim2.new(0,32,0,80)
        Subtitle.BackgroundTransparency=1 Subtitle.TextColor3=Color3.fromRGB(155,155,163) Subtitle.TextSize=13
        Subtitle.Font=Enum.Font.Gotham Subtitle.TextWrapped=true Subtitle.TextXAlignment=Enum.TextXAlignment.Left
        Subtitle.TextYAlignment=Enum.TextYAlignment.Top Subtitle.Parent=Frame

        local function makeExperienceCard(id,recommended)
            local card=Instance.new("TextButton")
            card.Name=id=="lite" and "LiteExperienceCard" or "FullExperienceCard"
            card.Text="" card.AutoButtonColor=false card.BackgroundColor3=Color3.fromRGB(19,19,22) card.BorderSizePixel=0 card.Parent=Frame
            local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,6) corner.Parent=card
            local stroke=Instance.new("UIStroke") stroke.Color=Color3.fromRGB(58,58,66) stroke.Thickness=1 stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border stroke.Parent=card
            local glow=Instance.new("UIStroke") glow.Color=Color3.fromRGB(255,210,31) glow.Thickness=4 glow.Transparency=1 glow.ApplyStrokeMode=Enum.ApplyStrokeMode.Border glow.Parent=card
            local name=Instance.new("TextLabel")
            name.Name="ExperienceName" name.Size=UDim2.new(1,-74,0,22) name.Position=UDim2.new(0,18,0,20)
            name.BackgroundTransparency=1 name.TextColor3=Color3.fromRGB(245,245,245) name.TextSize=18 name.Font=Enum.Font.GothamBold
            name.TextXAlignment=Enum.TextXAlignment.Left name.Parent=card
            local badge=nil
            if recommended then
                badge=Instance.new("TextLabel") badge.Name="RecommendedBadge" badge.Size=UDim2.fromOffset(98,21)
                badge.Position=UDim2.new(0,18,0,-10) badge.BackgroundColor3=Color3.fromRGB(255,210,31)
                badge.TextColor3=Color3.fromRGB(17,15,5) badge.TextSize=10 badge.Font=Enum.Font.GothamBold badge.Parent=card
                local badgeCorner=Instance.new("UICorner") badgeCorner.CornerRadius=UDim.new(0,3) badgeCorner.Parent=badge
            end
            local tagline=Instance.new("TextLabel")
            tagline.Name="ExperienceTagline" tagline.Size=UDim2.new(1,-36,0,18) tagline.Position=UDim2.new(0,18,0,44)
            tagline.BackgroundTransparency=1 tagline.TextColor3=Color3.fromRGB(155,155,163)
            tagline.TextSize=12 tagline.Font=Enum.Font.Gotham tagline.TextWrapped=true tagline.TextXAlignment=Enum.TextXAlignment.Left
            tagline.TextYAlignment=Enum.TextYAlignment.Top tagline.Parent=card
            local description=Instance.new("TextLabel")
            description.Name="ExperienceDescription" description.Size=UDim2.new(1,-36,0,68) description.Position=UDim2.new(0,18,0,58)
            description.BackgroundTransparency=1 description.TextColor3=Color3.fromRGB(224,224,228) description.TextSize=12.5
            description.Font=Enum.Font.Gotham description.RichText=true description.TextWrapped=true description.TextXAlignment=Enum.TextXAlignment.Left
            description.TextYAlignment=Enum.TextYAlignment.Top description.LineHeight=1.3 description.Parent=card
            local selectedMark=Instance.new("TextLabel")
            selectedMark.Name="SelectionIndicator" selectedMark.Size=UDim2.fromOffset(18,18) selectedMark.AnchorPoint=Vector2.new(1,0)
            selectedMark.Position=UDim2.new(1,-15,0,14) selectedMark.BackgroundColor3=Color3.fromRGB(255,210,31)
            selectedMark.Text="✓" selectedMark.TextColor3=Color3.fromRGB(20,17,0) selectedMark.TextSize=11 selectedMark.Font=Enum.Font.GothamBold
            selectedMark.Visible=false selectedMark.Parent=card
            local selectedCorner=Instance.new("UICorner") selectedCorner.CornerRadius=UDim.new(1,0) selectedCorner.Parent=selectedMark
            return card,name,badge,tagline,description,stroke,glow,selectedMark
        end
        local FullCard,FullName,RecommendedBadge,FullTagline,FullDescription,FullCardStroke,FullGlow,FullSelectedMark=makeExperienceCard("full",true)
        local LiteCard,LiteName,_,LiteTagline,LiteDescription,LiteCardStroke,LiteGlow,LiteSelectedMark=makeExperienceCard("lite",false)

        local rememberExperience=false
        local RememberGroup=Instance.new("Frame")
        RememberGroup.Name="RememberExperienceGroup"
        RememberGroup.AnchorPoint=Vector2.new(0.5,0)
        RememberGroup.Size=UDim2.fromOffset(0,22)
        RememberGroup.AutomaticSize=Enum.AutomaticSize.X
        RememberGroup.BackgroundTransparency=1
        RememberGroup.Parent=Frame
        local RememberLayout=Instance.new("UIListLayout")
        RememberLayout.FillDirection=Enum.FillDirection.Horizontal
        RememberLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
        RememberLayout.VerticalAlignment=Enum.VerticalAlignment.Center
        RememberLayout.Padding=UDim.new(0,8)
        RememberLayout.Parent=RememberGroup
        local RememberButton=Instance.new("TextButton")
        RememberButton.Name="RememberExperienceToggle" RememberButton.Size=UDim2.fromOffset(15,15)
        RememberButton.BackgroundColor3=Color3.fromRGB(19,18,23) RememberButton.BorderSizePixel=0
        RememberButton.Text="" RememberButton.TextColor3=Color3.fromRGB(20,18,10) RememberButton.TextSize=10
        RememberButton.Font=Enum.Font.GothamBold RememberButton.Parent=RememberGroup
        local rememberCorner=Instance.new("UICorner") rememberCorner.CornerRadius=UDim.new(0,3) rememberCorner.Parent=RememberButton
        local rememberStroke=Instance.new("UIStroke") rememberStroke.Color=Color3.fromRGB(104,87,32) rememberStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border rememberStroke.Parent=RememberButton
        local RememberLabel=Instance.new("TextButton")
        RememberLabel.Name="RememberExperienceLabel" RememberLabel.Size=UDim2.fromOffset(0,22)
        RememberLabel.AutomaticSize=Enum.AutomaticSize.X
        RememberLabel.BackgroundTransparency=1 RememberLabel.TextColor3=Color3.fromRGB(198,195,207)
        RememberLabel.TextSize=12 RememberLabel.Font=Enum.Font.GothamMedium RememberLabel.TextXAlignment=Enum.TextXAlignment.Left
        RememberLabel.AutoButtonColor=false RememberLabel.Parent=RememberGroup

        local Divider=Instance.new("Frame")
        Divider.Name="FooterDivider" Divider.BackgroundColor3=Color3.fromRGB(31,31,35) Divider.BorderSizePixel=0 Divider.Parent=Frame
        local Status=Instance.new("TextLabel")
        Status.Name="SelectorStatus" Status.Size=UDim2.fromOffset(300,20) Status.AnchorPoint=Vector2.new(0.5,0) Status.BackgroundTransparency=1
        Status.Text="" Status.TextColor3=Color3.fromRGB(112,213,151) Status.TextSize=11 Status.Font=Enum.Font.GothamMedium
        Status.TextXAlignment=Enum.TextXAlignment.Center Status.Parent=Frame
        local LoadButton=Instance.new("TextButton")
        LoadButton.Name="LoadSelectedExperienceButton" LoadButton.Size=UDim2.fromOffset(260,38) LoadButton.AnchorPoint=Vector2.new(0.5,0)
        LoadButton.BackgroundColor3=Color3.fromRGB(255,210,31) LoadButton.BorderSizePixel=0 LoadButton.TextColor3=Color3.fromRGB(17,15,5)
        LoadButton.TextSize=12 LoadButton.Font=Enum.Font.GothamBold LoadButton.AutoButtonColor=false LoadButton.Visible=false LoadButton.Active=false LoadButton.Parent=Frame
        local loadCorner=Instance.new("UICorner") loadCorner.CornerRadius=UDim.new(0,4) loadCorner.Parent=LoadButton
        local loadStroke=Instance.new("UIStroke") loadStroke.Color=Color3.fromRGB(255,229,115) loadStroke.Thickness=1 loadStroke.Transparency=1 loadStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border loadStroke.Parent=LoadButton

        local selectedExperience=nil
        local updateSelectorLayout=nil
        local function refreshLoadButtonText()
            if selectedExperience=="full" then
                LoadButton.Text=string.upper(translateText("Launch Full"))
            elseif selectedExperience=="lite" then
                LoadButton.Text=string.upper(translateText("Launch Core"))
            else
                LoadButton.Text=""
            end
        end
        local function refreshFeatureDescriptions(fullSelected,liteSelected)
            local fullBullet="#ffd21f"
            local liteBullet=liteSelected and "#ffd21f" or "#b2b5be"
            local function bullet(color) return string.format("<font color=\"%s\">◆</font>  ",color) end
            FullDescription.Text=bullet(fullBullet)..translateText("All Features")..'\n'..bullet(fullBullet)..translateText("Advanced Controls")..'\n'..bullet(fullBullet)..translateText("Full Customization")..'\n'..bullet(fullBullet)..translateText("Classic Experience")
            LiteDescription.Text=bullet(liteBullet)..translateText("Essential Features")..'\n'..bullet(liteBullet)..translateText("Streamlined Interface")..'\n'..bullet(liteBullet)..translateText("Faster Setup")
        end
        local function setSelectedExperience(experience)
            if experience~="full" and experience~="lite" then experience=nil end
            selectedExperience=experience
            local fullSelected=experience=="full" local liteSelected=experience=="lite"
            FullCardStroke.Color=fullSelected and Color3.fromRGB(255,210,31) or Color3.fromRGB(58,58,66)
            LiteCardStroke.Color=liteSelected and Color3.fromRGB(255,210,31) or Color3.fromRGB(58,58,66)
            FullCardStroke.Thickness=fullSelected and 2 or 1 LiteCardStroke.Thickness=liteSelected and 2 or 1
            FullGlow.Transparency=fullSelected and 0.9 or 1 LiteGlow.Transparency=liteSelected and 0.9 or 1
            FullCard.BackgroundColor3=fullSelected and Color3.fromRGB(29,27,20) or Color3.fromRGB(19,19,22)
            LiteCard.BackgroundColor3=liteSelected and Color3.fromRGB(29,27,20) or Color3.fromRGB(19,19,22)
            FullName.TextColor3=Color3.fromRGB(245,245,245)
            LiteName.TextColor3=Color3.fromRGB(245,245,245)
            FullTagline.TextColor3=fullSelected and Color3.fromRGB(203,193,150) or Color3.fromRGB(162,162,171)
            LiteTagline.TextColor3=liteSelected and Color3.fromRGB(203,193,150) or Color3.fromRGB(172,172,181)
            FullDescription.TextColor3=fullSelected and Color3.fromRGB(240,238,225) or Color3.fromRGB(232,232,235)
            LiteDescription.TextColor3=liteSelected and Color3.fromRGB(240,238,225) or Color3.fromRGB(232,232,235)
            RecommendedBadge.BackgroundColor3=Color3.fromRGB(255,210,31)
            RecommendedBadge.TextColor3=Color3.fromRGB(17,15,5)
            FullSelectedMark.BackgroundColor3=Color3.fromRGB(255,210,31) LiteSelectedMark.BackgroundColor3=Color3.fromRGB(255,210,31)
            FullSelectedMark.TextColor3=Color3.fromRGB(20,17,0) LiteSelectedMark.TextColor3=Color3.fromRGB(20,17,0)
            FullSelectedMark.Visible=fullSelected LiteSelectedMark.Visible=liteSelected
            LoadButton.Visible=experience~=nil LoadButton.Active=experience~=nil
            refreshFeatureDescriptions(fullSelected,liteSelected)
            refreshLoadButtonText()
            if updateSelectorLayout then updateSelectorLayout() end
        end
        local function refreshSelectorLanguage()
            Heading.Text=translateText("Choose Your Experience")
            Subtitle.Text=translateText("Choose how you want Cokeboys to run. You can change this later in Settings.")
            FullName.Text=translateText("Full Experience")
            LiteName.Text=translateText("Core Experience")
            RecommendedBadge.Text=string.upper(translateText("Recommended"))
            FullTagline.Text=translateText("The complete Cokeboys experience.")
            LiteTagline.Text=translateText("A simple, focused Cokeboys experience.")
            refreshFeatureDescriptions(selectedExperience=="full",selectedExperience=="lite")
            RememberLabel.Text=translateText("Remember and skip this screen next time")
            refreshLoadButtonText()
        end
        local function setRemember(value)
            rememberExperience=value==true
            RememberButton.Text=rememberExperience and "✓" or ""
            RememberButton.BackgroundColor3=rememberExperience and Color3.fromRGB(255,210,31) or Color3.fromRGB(19,18,23)
        end
        setRemember(preference and preference.rememberExperience==true or false)
         
         
         
        setSelectedExperience("full")
        refreshSelectorLanguage()

        RememberButton.Activated:Connect(function() setRemember(not rememberExperience) end)
        RememberLabel.Activated:Connect(function() setRemember(not rememberExperience) end)

        local selectionLocked=false
        local function chooseExperience(experience)
            if selectionLocked or not loaderController:ownsAttempt(launchGeneration,attemptGeneration,"MODE_SELECT") then return end
            selectionLocked=true
            FullCard.Active=false LiteCard.Active=false LoadButton.Active=false RememberButton.Active=false RememberLabel.Active=false
            RememberButton.Visible=false RememberLabel.Visible=false
            Status.Text=translateText("Starting %s..."):format(translateText(experience=="lite" and "Core Experience" or "Full Experience"))
            initializeAuthenticatedExperience(key,experience,rememberExperience,attemptGeneration,true)
        end
        FullCard.Activated:Connect(function() if not selectionLocked then setSelectedExperience("full") end end)
        LiteCard.Activated:Connect(function() if not selectionLocked then setSelectedExperience("lite") end end)
        LoadButton.Activated:Connect(function() if selectedExperience then chooseExperience(selectedExperience) end end)
        FullCard.MouseEnter:Connect(function() if selectedExperience~="full" then FullCard.BackgroundColor3=Color3.fromRGB(24,24,28) end end)
        FullCard.MouseLeave:Connect(function() if selectedExperience~="full" then FullCard.BackgroundColor3=Color3.fromRGB(19,19,22) end end)
        LiteCard.MouseEnter:Connect(function() if selectedExperience~="lite" then LiteCard.BackgroundColor3=Color3.fromRGB(25,25,30) end end)
        LiteCard.MouseLeave:Connect(function() if selectedExperience~="lite" then LiteCard.BackgroundColor3=Color3.fromRGB(20,20,24) end end)
        LoadButton.MouseEnter:Connect(function() if LoadButton.Active then LoadButton.BackgroundColor3=Color3.fromRGB(255,222,75) end end)
        LoadButton.MouseLeave:Connect(function() LoadButton.BackgroundColor3=Color3.fromRGB(255,210,31) end)
        CloseBtn.Activated:Connect(function()
            if loaderController:isCurrent() then cancelCurrentAuthentication("experience selector close button") end
        end)
        CloseBtn.MouseEnter:Connect(function()
            CloseBtn.BackgroundColor3=Color3.fromRGB(190,48,57)
            CloseBtn.TextColor3=Color3.fromRGB(255,255,255)
            closeStroke.Color=Color3.fromRGB(235,81,90)
        end)
        CloseBtn.MouseLeave:Connect(function()
            CloseBtn.BackgroundColor3=Color3.fromRGB(17,17,20)
            CloseBtn.TextColor3=Color3.fromRGB(180,178,188)
            closeStroke.Color=Color3.fromRGB(31,31,35)
        end)

        local layoutConnection=nil
        updateSelectorLayout=function()
            if not LayoutRoot.Parent then return end
            local camera=workspace.CurrentCamera
            local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
            local safeWidth=math.max(1,viewport.X-24) local safeHeight=math.max(1,viewport.Y-24)
            local inputService=game:GetService("UserInputService")
            local mobile=inputService.TouchEnabled and not inputService.KeyboardEnabled
            if mobile then
                 
                 
                local portrait=viewport.X<viewport.Y
                local logicalWidth=portrait and 350 or 520
                local logicalHeight=portrait and 410 or 276
                 
                 
                gui.DisplayOrder=1005
                Backdrop.Active=true
                LayoutRoot.AnchorPoint=Vector2.new(0.5,0.5)
                LayoutRoot.Size=UDim2.fromOffset(logicalWidth,logicalHeight)
                local availableHeight=Backdrop.AbsoluteSize.Y
                if availableHeight<=0 then availableHeight=viewport.Y end
                LayoutScale.Scale=math.min(0.94,safeWidth/logicalWidth,math.max(1,availableHeight-24)/logicalHeight)
                LayoutRoot.Position=UDim2.fromScale(0.5,0.5)
                Heading.TextSize=18; Heading.Position=UDim2.fromOffset(18,45)
                Heading.Size=UDim2.new(1,-36,0,24)
                Subtitle.Position=UDim2.fromOffset(18,69)
                Subtitle.Size=UDim2.new(1,-36,0,portrait and 28 or 18)
                Subtitle.TextSize=10
                PikachuLogoFrame.Position=UDim2.fromOffset(18,10)
                PikachuLogoFrame.Size=UDim2.fromOffset(26,26)
                Title.Position=UDim2.fromOffset(56,12); Title.TextSize=14
                CloseBtn.Position=UDim2.new(1,-12,0,9)
                FullTagline.Visible=false; LiteTagline.Visible=false
                for _,name in ipairs({FullName,LiteName}) do
                    name.TextSize=14; name.Position=UDim2.fromOffset(12,12)
                    name.Size=UDim2.new(1,-46,0,20)
                end
                for _,description in ipairs({FullDescription,LiteDescription}) do
                    description.TextSize=11; description.LineHeight=1.12
                    description.Position=UDim2.fromOffset(12,36)
                    description.Size=UDim2.new(1,-24,0,56)
                end
                RecommendedBadge.TextSize=9; RecommendedBadge.Size=UDim2.fromOffset(88,18)
                RecommendedBadge.Position=UDim2.fromOffset(12,-8)
                local cardWidth=portrait and 314 or 232
                FullCard.Size=UDim2.fromOffset(cardWidth,100)
                LiteCard.Size=UDim2.fromOffset(cardWidth,100)
                FullCard.Position=UDim2.fromOffset(18,portrait and 106 or 96)
                LiteCard.Position=UDim2.fromOffset(portrait and 18 or 270,portrait and 216 or 96)
                local actionY=portrait and 326 or 206
                LoadButton.Size=UDim2.fromOffset(240,40)
                LoadButton.Position=UDim2.new(0.5,0,0,actionY)
                Divider.Visible=false
                RememberLabel.TextSize=10
                RememberGroup.Position=UDim2.new(0.5,0,0,actionY+43)
                Status.Position=RememberGroup.Position
                return
            end
            FullTagline.Visible=true; LiteTagline.Visible=true; Divider.Visible=true
            gui.DisplayOrder=0; Backdrop.Active=false
            LayoutRoot.AnchorPoint=Vector2.new(0.5,0.5)
            LayoutRoot.Position=UDim2.fromScale(0.5,0.5)
            PikachuLogoFrame.Size=UDim2.fromOffset(32,32); Title.TextSize=16
            CloseBtn.Position=UDim2.new(1,-18,0,13); Subtitle.TextSize=13
            Heading.Size=UDim2.new(1,-64,0,27); RememberLabel.TextSize=12
            LoadButton.Size=UDim2.fromOffset(260,38)
            for _,name in ipairs({FullName,LiteName}) do
                name.TextSize=18; name.Position=UDim2.fromOffset(18,20); name.Size=UDim2.new(1,-74,0,22)
            end
            for _,description in ipairs({FullDescription,LiteDescription}) do
                description.TextSize=12.5; description.LineHeight=1.3
                description.Position=UDim2.fromOffset(18,58); description.Size=UDim2.new(1,-36,0,68)
            end
            RecommendedBadge.TextSize=10; RecommendedBadge.Size=UDim2.fromOffset(98,21)
            RecommendedBadge.Position=UDim2.fromOffset(18,-10)
             
             
            local stacked=safeWidth<520
            local expanded=selectedExperience~=nil
            local logicalWidth=stacked and 350 or 590
            local logicalHeight=stacked and (expanded and 524 or 455) or (expanded and 350 or 310)
            LayoutRoot.Size=UDim2.fromOffset(logicalWidth,logicalHeight)
            LayoutScale.Scale=math.min(1,safeWidth/logicalWidth,safeHeight/logicalHeight)
            if stacked then
                Heading.TextSize=20
                PikachuLogoFrame.Position=UDim2.fromOffset(24,13) Title.Position=UDim2.new(0,68,0,18)
                Heading.Position=UDim2.new(0,24,0,52) Subtitle.Position=UDim2.new(0,24,0,81) Subtitle.Size=UDim2.fromOffset(302,32)
                FullCard.Size=UDim2.fromOffset(302,132) FullCard.Position=UDim2.fromOffset(24,119)
                LiteCard.Size=UDim2.fromOffset(302,132) LiteCard.Position=UDim2.fromOffset(24,266)
                LoadButton.Position=UDim2.new(0.5,0,0,414)
                Divider.Size=UDim2.fromOffset(302,1) Divider.Position=UDim2.fromOffset(24,expanded and 469 or 414)
                RememberGroup.Position=UDim2.new(0.5,0,0,expanded and 486 or 431)
                Status.Position=UDim2.new(0.5,0,0,expanded and 486 or 431)
            else
                Heading.TextSize=22
                PikachuLogoFrame.Position=UDim2.fromOffset(32,13) Title.Position=UDim2.new(0,76,0,18)
                Heading.Position=UDim2.new(0,32,0,52) Subtitle.Position=UDim2.new(0,32,0,81) Subtitle.Size=UDim2.new(1,-64,0,18)
                FullCard.Size=UDim2.fromOffset(260,132) FullCard.Position=UDim2.fromOffset(24,112)
                LiteCard.Size=UDim2.fromOffset(260,132) LiteCard.Position=UDim2.fromOffset(306,112)
                LoadButton.Position=UDim2.new(0.5,0,0,260)
                Divider.Size=UDim2.fromOffset(542,1) Divider.Position=UDim2.fromOffset(24,expanded and 315 or 260)
                RememberGroup.Position=UDim2.new(0.5,0,0,expanded and 328 or 277)
                Status.Position=UDim2.new(0.5,0,0,expanded and 328 or 277)
            end
        end
        local function bindSelectorCamera()
            if layoutConnection then layoutConnection:Disconnect(); layoutConnection=nil end
            local camera=workspace.CurrentCamera
            if camera then
                layoutConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSelectorLayout)
                table.insert(loaderController.loaderConnections,layoutConnection)
            end
            updateSelectorLayout()
        end
        local cameraReplacementConnection=workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindSelectorCamera)
        table.insert(loaderController.loaderConnections,cameraReplacementConnection)
        local selectorAreaConnection=Backdrop:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSelectorLayout)
        table.insert(loaderController.loaderConnections,selectorAreaConnection)
        bindSelectorCamera()
    end

    local function showExperienceSwitchStatus(statusKey)
        clearKeyArtifacts()
        local livePalette=type(C)=="table" and C or {}
        local function paletteColor(name,fallback)
            local value=livePalette[name]
            return typeof(value)=="Color3" and value or fallback
        end
        local backgroundColor=paletteColor("BG",Color3.fromRGB(13,13,16))
        local panelColor=paletteColor("PANEL",Color3.fromRGB(20,19,24))
        local rowColor=paletteColor("ROW2",Color3.fromRGB(34,32,39))
        local accentColor=paletteColor("ACCENT",Color3.fromRGB(238,190,40))
        local textColor=paletteColor("TEXT",Color3.fromRGB(245,243,236))
        local wallpaper=nil
        pcall(function()
            local custom=tostring(Settings.UIBackgroundCustomAsset or ""):match("^%s*(.-)%s*$") or ""
            local customId=custom:match("^rbxassetid://(%d+)$") or custom:match("^(%d+)$")
            if customId then
                wallpaper="rbxassetid://"..customId
            elseif type(_G.__CokeboysGetWallpaperPreview)=="function" then
                wallpaper=_G.__CokeboysGetWallpaperPreview(Settings.UIBackgroundPreset)
            end
        end)
        local gui=Instance.new("ScreenGui")
        gui.Name="CokeboysKeySystem" gui.ResetOnSpawn=false gui.IgnoreGuiInset=true
        gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        gui.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        activeKeyGui=gui loaderController.gui=gui
        if type(wallpaper)=="string" and wallpaper~="" then
            local background=Instance.new("ImageLabel")
            background.Name="ExperienceSwitchBackground" background.Size=UDim2.fromScale(1,1)
            background.BackgroundTransparency=1 background.BorderSizePixel=0 background.Image=wallpaper
            background.ImageTransparency=0.08 background.ScaleType=Enum.ScaleType.Crop background.Parent=gui
        end
        local backdrop=Instance.new("Frame")
        backdrop.Name="Backdrop" backdrop.Size=UDim2.fromScale(1,1) backdrop.BackgroundColor3=backgroundColor
        backdrop.BackgroundTransparency=wallpaper and 0.34 or 0.08 backdrop.BorderSizePixel=0 backdrop.Parent=gui
        local card=Instance.new("Frame")
        card.Name="ExperienceSwitchStatusCard" card.Size=UDim2.fromOffset(410,160) card.AnchorPoint=Vector2.new(0.5,0.5)
        card.Position=UDim2.fromScale(0.5,0.5) card.BackgroundColor3=panelColor card.BackgroundTransparency=wallpaper and 0.12 or 0
        card.BorderSizePixel=0 card.ClipsDescendants=true card.Parent=gui
        local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,10) corner.Parent=card
        local stroke=Instance.new("UIStroke") stroke.Color=accentColor stroke.Thickness=1.25 stroke.Transparency=0.25 stroke.Parent=card
        local brand=Instance.new("TextLabel")
        brand.Size=UDim2.new(1,-40,0,24) brand.Position=UDim2.fromOffset(20,22) brand.BackgroundTransparency=1
        brand.Text="COKEBOYS" brand.TextXAlignment=Enum.TextXAlignment.Left brand.TextColor3=accentColor
        brand.TextSize=18 brand.Font=Enum.Font.GothamBold brand.Parent=card
        local eyebrow=Instance.new("TextLabel")
        eyebrow.Size=UDim2.new(1,-40,0,18) eyebrow.Position=UDim2.fromOffset(20,48) eyebrow.BackgroundTransparency=1
        eyebrow.Text="SWITCHING EXPERIENCE" eyebrow.TextXAlignment=Enum.TextXAlignment.Left eyebrow.TextColor3=textColor
        eyebrow.TextTransparency=0.28 eyebrow.TextSize=10 eyebrow.Font=Enum.Font.GothamBold eyebrow.Parent=card
        local status=Instance.new("TextLabel")
        status.Name="ExperienceSwitchStatus" status.Size=UDim2.new(1,-40,0,34) status.Position=UDim2.fromOffset(20,75)
        status.BackgroundTransparency=1 status.TextColor3=textColor status.TextXAlignment=Enum.TextXAlignment.Left status.TextSize=14
        status.Font=Enum.Font.GothamMedium status.TextWrapped=true status.Parent=card
        local progressTrack=Instance.new("Frame")
        progressTrack.Name="ProgressTrack" progressTrack.Size=UDim2.new(1,-40,0,5) progressTrack.Position=UDim2.fromOffset(20,126)
        progressTrack.BackgroundColor3=rowColor progressTrack.BorderSizePixel=0 progressTrack.ClipsDescendants=true progressTrack.Parent=card
        local trackCorner=Instance.new("UICorner") trackCorner.CornerRadius=UDim.new(1,0) trackCorner.Parent=progressTrack
        local progress=Instance.new("Frame")
        progress.Name="Progress" progress.Size=UDim2.new(0.28,0,1,0) progress.Position=UDim2.new(-0.28,0,0,0)
        progress.BackgroundColor3=accentColor progress.BorderSizePixel=0 progress.Parent=progressTrack
        local progressCorner=Instance.new("UICorner") progressCorner.CornerRadius=UDim.new(1,0) progressCorner.Parent=progress
        local progressStartedAt=os.clock()
        local progressConnection=game:GetService("RunService").RenderStepped:Connect(function()
            if not progress.Parent then return end
            local phase=((os.clock()-progressStartedAt)/1.05)%1
            progress.Position=UDim2.new(-0.28+(phase*1.28),0,0,0)
        end)
        table.insert(loaderController.loaderConnections,progressConnection)
        local scale=Instance.new("UIScale") scale.Parent=card
        local function updateScale()
            local camera=workspace.CurrentCamera local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
            scale.Scale=math.max(0.78,math.min(1,(viewport.X-24)/410,(viewport.Y-24)/160))
        end
        updateScale()
        local function setStatus(key,raw)
            if status.Parent then status.Text=raw or translateText(key) end
        end
        setStatus(statusKey)
        return setStatus
    end

    local function runtimeCleanupState()
        if bootstrapEnvironment.CokeboysScriptLoaded==true then return false,"loaded flag" end
        if bootstrapEnvironment.__CokeboysCurrentExperience~=nil then return false,"current experience" end
        if bootstrapEnvironment.__CokeboysExperience~=nil then return false,"experience controller" end
        if #(bootstrapEnvironment.__CokeboysRuntimeTasks or {})>0 then return false,"runtime tasks" end
        if #(bootstrapEnvironment.__CokeboysRuntimeConnections or {})>0 then return false,"runtime connections" end
        if _G.__CokeboysAntiStunCleanup~=nil then return false,"anti-stun runtime" end
        if _G.__CokeboysUnbreakableSkillsCleanup~=nil then return false,"unbreakable runtime" end
        if _G.__CokeboysAntiComboCasting==true then return false,"anti-combo cast" end
        if bootstrapEnvironment.__CokeboysSmartMacroRunning==true then return false,"smart macro" end
        local remainingGui=nil
        local inspected=pcall(function()
            local playerGui=game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if playerGui then
                for _,child in ipairs(playerGui:GetChildren()) do
                    if child:IsA("ScreenGui") and tostring(child.Name):lower():find("cokeboys") then
                        remainingGui="PlayerGui/"..tostring(child.Name)
                        break
                    end
                end
            end
            if not remainingGui then
                for _,child in ipairs(game:GetService("CoreGui"):GetChildren()) do
                    if child:IsA("ScreenGui") and tostring(child.Name):lower():find("cokeboys") then
                        remainingGui="CoreGui/"..tostring(child.Name)
                        break
                    end
                end
            end
        end)
        if not inspected then return false,"GUI inspection" end
        if remainingGui then return false,remainingGui end
        return true,nil
    end

    local function runtimeCleanupVerified()
         
         
         
        local deadline=os.clock()+0.75
        local clean,reason=runtimeCleanupState()
        while not clean and os.clock()<deadline do
            task.wait(0.03)
            clean,reason=runtimeCleanupState()
        end
        return clean,reason
    end

    if purpose=="launch" then
        _G.__CokeboysRequestKeyReset=function()
            if not loaderController:isCurrent() or loaderController.state~="READY"
                or loaderController.switchInProgress==true then return false,"reset-unavailable" end
            local unload=authenticFullUnload
            if type(unload)~="function" or loaderController.fullUnloadInstalled~=true then return false,"cleanup-unavailable" end
            if not clearSavedKeyFile() then return false,"Could not clear saved key" end
             
            loaderController.switchInProgress=true
            loaderController.monitorGeneration+=1
            loaderController.validationGeneration+=1
            loaderController.launchGeneration+=1
            bootstrapEnvironment.__CokeboysLoaderGeneration=loaderController.launchGeneration
            clearKeyAccessState()
            local unloaded=pcall(unload)
            local clean=unloaded and runtimeCleanupVerified()
            loaderController.switchInProgress=false
            if not clean then
                disposeLoaderController("key reset cleanup uncertain",true)
                return false,"Cleanup could not be verified. Re-execute Cokeboys to continue."
            end
            loaderController.selectionCommitted=false
            loaderController.initializationCommitted=false
            loaderController.authenticatedKey=nil
            loaderController.authenticationGeneration=nil
            loaderController.resolvedExperience=nil
            loaderController.fullUnloadInstalled=false
            authenticatedExperienceLaunch=nil
            bootstrapEnvironment.__CokeboysLaunchInProgress=true
            if not loaderController:transition("AUTH","READY") then return false,"transition-failed" end
            return runKeySystem(onSuccess,"launch")
        end
        _G.__CokeboysRequestExperienceSwitch=function(destination,rememberExperience)
            destination=tostring(destination or ""):lower()
            if not VALID_EXPERIENCE_IDS[destination] then return false,"invalid-experience" end
            if not loaderController:isCurrent() or loaderController.state~="READY"
                or loaderController.switchInProgress==true then return false,"switch-unavailable" end
            if destination==bootstrapEnvironment.__CokeboysCurrentExperience then return false,"already-active" end
            local configIO=bootstrapEnvironment.__CokeboysConfigIO
            if type(configIO)~="table" or configIO.dirty==true then return false,"config-not-flushed" end
            local switchConfigPayload=nil
            pcall(function()
                local currentSettings=bootstrapEnvironment.CokeboysSettings
                if type(currentSettings)=="table" and type(configIO.buildPayload)=="function" then
                    switchConfigPayload=game:GetService("HttpService"):JSONEncode(configIO.buildPayload(currentSettings,true))
                end
            end)
            if type(switchConfigPayload)~="string" or switchConfigPayload=="" then
                return false,"config-not-flushed"
            end
            local unload=bootstrapEnvironment.CokeboysFullUnload
            if type(unload)~="function" or loaderController.fullUnloadInstalled~=true then
                return false,"cleanup-unavailable"
            end
             
             
            local savedKey=readFile(KEY_FILE)
            savedKey=type(savedKey)=="string" and savedKey:match("^%s*(.-)%s*$") or ""
            if savedKey=="" then return false,"key-unavailable" end
            if not loaderController:transition("SWITCHING","READY") then return false,"switch-unavailable" end

            loaderController.switchInProgress=true
            loaderController.switchTarget=destination
            loaderController.purpose="switch"
            loaderController.monitorGeneration+=1
            loaderController.validationGeneration+=1
            loaderController.launchGeneration+=1
            loaderController.selectionCommitted=true
            loaderController.initializationCommitted=false
            loaderController.resolvedExperience=nil
            loaderController.ownsLaunch=true
            bootstrapEnvironment.__CokeboysLoaderGeneration=loaderController.launchGeneration
            bootstrapEnvironment.__CokeboysLaunchInProgress=true
            local switchLaunchGeneration=loaderController.launchGeneration
            local switchValidationGeneration=loaderController.validationGeneration

            local unloaded,unloadError=pcall(unload)
            local cleanupVerified,cleanupReason=false,nil
            if unloaded then cleanupVerified,cleanupReason=runtimeCleanupVerified() end
            if not unloaded or not cleanupVerified then
                warn("Cokeboys experience switch cleanup could not be verified: "..tostring(unloadError or cleanupReason or "runtime ownership remains"))
                pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title="Cokeboys Switch Stopped",Text=translateText("Cleanup could not be verified. Re-execute Cokeboys to continue."),Duration=8,
                }) end)
                loaderController.switchInProgress=false
                disposeLoaderController("experience switch cleanup uncertain",true)
                return false,"cleanup-unverified"
            end

             
             
            bootstrapEnvironment.__CokeboysLaunchInProgress=true
            local setSwitchStatus=showExperienceSwitchStatus("Verifying key...")
            if not loaderController:transition("REVALIDATING","SWITCHING") then
                disposeLoaderController("experience switch transition failed",true)
                return false,"transition-failed"
            end
            spawnKeyTask(function()
                local hwid,username=getPlayerInfo()
                local valid,message,data,completed=validateKey(savedKey,hwid,username,GAME_NAME)
                if not loaderController:ownsAttempt(switchLaunchGeneration,switchValidationGeneration,"REVALIDATING") then return end
                if not valid then
                    clearKeyAccessState()
                    local reason=completed and tostring(message or translateText("Invalid key"))
                        or translateText("Connection unavailable. Try again.")
                    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title="Cokeboys Switch Stopped",Text=reason,Duration=8,
                    }) end)
                    loaderController.switchInProgress=false
                    disposeLoaderController("experience switch key rejected",true)
                    return
                end
                publishKeyAccessState(data)
                loaderController.authenticatedKey=savedKey
                loaderController.authenticationGeneration=switchValidationGeneration
                if not loaderController:transition("INITIALIZING","REVALIDATING") then return end
                loaderController.initializationCommitted=true
                loaderController.resolvedExperience=destination
                authenticatedExperienceLaunch={
                    authenticated=true,generation=switchLaunchGeneration,validationGeneration=switchValidationGeneration,experience=destination,
                }
                setSwitchStatus(nil,translateText("Starting %s..."):format(translateText(destination=="lite" and "Core Experience" or "Full Experience")))
                task.defer(function()
                    if not loaderController:ownsAttempt(switchLaunchGeneration,switchValidationGeneration,"INITIALIZING") then return end
                     
                     
                     
                     
                    bootstrapEnvironment.__CokeboysExperienceSwitchConfigPayload=switchConfigPayload
                    local initialized,initializationError=pcall(onSuccess)
                    if not initialized or loaderController.state~="READY" then
                        warn("Cokeboys switched experience failed to initialize: "..tostring(initializationError or "runtime did not report ready"))
                        authenticatedExperienceLaunch=nil
                        local failedUnload=bootstrapEnvironment.CokeboysFullUnload
                        if loaderController.fullUnloadInstalled==true and type(failedUnload)=="function" then pcall(failedUnload) end
                        loaderController.switchInProgress=false
                        if loaderController:isCurrent() then disposeLoaderController("switched runtime initialization failed",true) end
                        return
                    end
                    loaderController.switchInProgress=false
                    loaderController.switchTarget=nil
                    if not writeLoaderPreference(destination,rememberExperience==true) then
                        warn("Cokeboys switched experience preference could not be saved")
                    end
                    clearKeyArtifacts()
                    startKeyValidationMonitor(savedKey)
                end)
            end)
            return true
        end
    end

    spawnKeyTask(function()

         
        local savedKey = purpose=="launch" and readFile(KEY_FILE) or nil
        local loaderInitialStatusKey=nil
        local loaderInitialStatusRaw=nil
        local loaderInitialStatusColor=nil
        if savedKey and savedKey ~= "" then
            savedKey = savedKey:match("^%s*(.-)%s*$")
            if not loaderController:transition("VALIDATING",loaderController.state) then return end
            local attemptGeneration=loaderController.validationGeneration
            local hwid, username = getPlayerInfo()
            local valid, savedMessage, data, savedCompleted = validateKey(savedKey, hwid, username, GAME_NAME)
            if not loaderController:ownsAttempt(launchGeneration,attemptGeneration,"VALIDATING") then return end
            if valid then
                authenticatedContinuation(savedKey,data,false,attemptGeneration)
                return
            end
            loaderController:transition("AUTH_ERROR","VALIDATING")
            loaderInitialStatusColor=Color3.fromRGB(239,98,111)
            if savedCompleted then
                if not savedMessage or savedMessage=="Invalid key" or savedMessage=="Unknown error" then
                    loaderInitialStatusKey="Invalid key"
                else
                    loaderInitialStatusRaw=tostring(savedMessage)
                end
            elseif savedMessage=="Connection failed" then
                loaderInitialStatusKey="Connection unavailable. Try again."
            else
                loaderInitialStatusKey="Unable to verify key. Try again."
            end
             
             
        end

        if not loaderController:ownsAttempt(launchGeneration,sessionValidationGeneration,nil) then return end
        if loaderController.state=="AUTH_ERROR" then
             
             
        elseif loaderController.state~="AUTH" then
            return
        end

         
        local Players      = game:GetService("Players")
        local lp           = Players.LocalPlayer
        local playerGui    = lp:WaitForChild("PlayerGui")

        local gui = Instance.new("ScreenGui")
        gui.Name = "CokeboysKeySystem"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = playerGui
        activeKeyGui=gui
        loaderController.gui=gui

        local Blur=nil
        pcall(function()
            Blur = Instance.new("BlurEffect")
            Blur.Name = "CokeboysKeyBlur"
            Blur.Size = 14
            Blur.Parent = game:GetService("Lighting")
        end)
        activeKeyBlur=Blur
        loaderController.blur=Blur
        local destroyingConnection=gui.Destroying:Connect(function()
            if activeKeyGui==gui then activeKeyGui=nil end
            if loaderController.gui==gui then loaderController.gui=nil end
            if Blur and activeKeyBlur==Blur then
                pcall(function() Blur:Destroy() end)
                activeKeyBlur=nil
            end
            if loaderController.blur==Blur then loaderController.blur=nil end
            if not loaderController.suppressDestroy then
                cancelCurrentAuthentication("loader destroyed")
            end
        end)
        table.insert(loaderController.loaderConnections,destroyingConnection)

        local BackgroundImage=Instance.new("ImageLabel")
        BackgroundImage.Name="AuthenticationBackgroundImage"
        BackgroundImage.Size=UDim2.fromScale(1,1)
        BackgroundImage.Position=UDim2.fromScale(0,0)
        BackgroundImage.BackgroundTransparency=1
        BackgroundImage.BorderSizePixel=0
        BackgroundImage.Image=KEY_PAGE_BACKGROUND_ASSET
        BackgroundImage.ImageColor3=Color3.fromRGB(190,190,190)
        BackgroundImage.ImageTransparency=0.28
        BackgroundImage.ScaleType=Enum.ScaleType.Crop
        BackgroundImage.ZIndex=0
        BackgroundImage.Parent=gui

        local Backdrop = Instance.new("Frame")
        Backdrop.Name = "Backdrop"
        Backdrop.Size = UDim2.new(1, 0, 1, 0)
        Backdrop.BackgroundColor3 = Color3.fromRGB(4, 4, 7)
        Backdrop.BackgroundTransparency = 0.52
        Backdrop.BorderSizePixel = 0
        Backdrop.ZIndex = 1
        Backdrop.Parent = gui

        local LayoutRoot = Instance.new("Frame")
        LayoutRoot.Name = "KeyPageLayout"
        LayoutRoot.AnchorPoint = Vector2.new(0.5, 0.5)
        LayoutRoot.Position = UDim2.new(0.5, 0, 0.5, 0)
        LayoutRoot.Size = UDim2.new(0, 470, 0, 365)
        LayoutRoot.BackgroundTransparency = 1
        LayoutRoot.BorderSizePixel = 0
        LayoutRoot.ZIndex = 2
        LayoutRoot.Parent = gui

        local LayoutScale = Instance.new("UIScale")
        LayoutScale.Parent = LayoutRoot

        local Frame = Instance.new("Frame")
        Frame.Name = "AuthenticationCard"
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
        Frame.BackgroundTransparency = 0.06
        Frame.BorderSizePixel = 0
        Frame.ClipsDescendants = true
        Frame.Parent = LayoutRoot

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Frame

        local Stroke = Instance.new("UIStroke")
        Stroke.Name = "AuthenticationBorder"
        Stroke.Color = Color3.fromRGB(55, 55, 64)
        Stroke.Thickness = 1.25
        Stroke.Transparency = 0.08
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Parent = Frame
        local OuterGlow = Instance.new("UIStroke")
        OuterGlow.Name = "AuthenticationBorderGlow"
        OuterGlow.Color = Color3.fromRGB(78, 78, 88)
        OuterGlow.Thickness = 2
        OuterGlow.Transparency = 0.72
        OuterGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        OuterGlow.Parent = Frame

         
         
         
        local BrandUnderline = Instance.new("Frame")
        BrandUnderline.Name = "BrandUnderline"
        BrandUnderline.Size = UDim2.fromOffset(46, 3)
        BrandUnderline.Position = UDim2.fromOffset(76, 47)
        BrandUnderline.BackgroundColor3 = Color3.fromRGB(255, 210, 31)
        BrandUnderline.BorderSizePixel = 0
        BrandUnderline.Parent = Frame
        local BrandUnderlineCorner=Instance.new("UICorner")
        BrandUnderlineCorner.CornerRadius=UDim.new(1,0)
        BrandUnderlineCorner.Parent=BrandUnderline

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Name = "CloseButton"
        CloseBtn.Size = UDim2.new(0, 32, 0, 32)
        CloseBtn.Position = UDim2.new(1, -50, 0, 13)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
        CloseBtn.BackgroundTransparency = 0
        CloseBtn.BorderSizePixel = 0
        CloseBtn.AutoButtonColor = false
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = Color3.fromRGB(205, 202, 212)
        CloseBtn.TextSize = 12
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn:SetAttribute("AccessibilityText", "Close")
        CloseBtn.Parent = Frame
        local CloseCorner = Instance.new("UICorner")
        CloseCorner.CornerRadius = UDim.new(0, 4)
        CloseCorner.Parent = CloseBtn
        local CloseStroke = Instance.new("UIStroke")
        CloseStroke.Color=Color3.fromRGB(31,31,35)
        CloseStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        CloseStroke.Parent=CloseBtn

        local LogoFrame=Instance.new("Frame")
        LogoFrame.Name="CokeboysPikachuLogo" LogoFrame.Size=UDim2.fromOffset(32,32) LogoFrame.Position=UDim2.fromOffset(32,13)
        LogoFrame.BackgroundColor3=Color3.fromRGB(255,210,31) LogoFrame.BorderSizePixel=0 LogoFrame.Parent=Frame
        local LogoCorner=Instance.new("UICorner") LogoCorner.CornerRadius=UDim.new(0,7) LogoCorner.Parent=LogoFrame
        local LogoImage=Instance.new("ImageLabel")
        LogoImage.Size=UDim2.fromScale(1,1) LogoImage.BackgroundTransparency=1
        LogoImage.Image="rbxthumb://type=Asset&id=128335611339738&w=420&h=420" LogoImage.ScaleType=Enum.ScaleType.Crop LogoImage.Parent=LogoFrame
        for index,x in ipairs({5,23}) do
            local cheek=Instance.new("Frame") cheek.Name="CheekAccent"..index cheek.Size=UDim2.fromOffset(4,2)
            cheek.Position=UDim2.fromOffset(x,26) cheek.BackgroundColor3=Color3.fromRGB(166,55,63) cheek.BackgroundTransparency=0.18
            cheek.BorderSizePixel=0 cheek.ZIndex=3 cheek.Parent=LogoFrame
            local cheekCorner=Instance.new("UICorner") cheekCorner.CornerRadius=UDim.new(1,0) cheekCorner.Parent=cheek
        end

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0, 190, 0, 22)
        Title.Position = UDim2.new(0, 76, 0, 18)
        Title.BackgroundTransparency = 1
        Title.Text = "COKEBOYS"
        Title.TextColor3 = Color3.fromRGB(245, 245, 245)
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Frame
        local BoltAccent=Instance.new("TextLabel")
        BoltAccent.Name="BrandBoltAccent" BoltAccent.Size=UDim2.fromOffset(18,22) BoltAccent.Position=UDim2.fromOffset(91,0)
        BoltAccent.BackgroundTransparency=1 BoltAccent.Text="⚡" BoltAccent.TextColor3=Color3.fromRGB(255,210,31)
        BoltAccent.TextSize=15 BoltAccent.Font=Enum.Font.GothamBold BoltAccent.TextXAlignment=Enum.TextXAlignment.Left BoltAccent.Parent=Title

        local Heading=Instance.new("TextLabel")
        Heading.Name="AuthenticationHeading" Heading.Size=UDim2.new(1,-64,0,27) Heading.Position=UDim2.new(0,32,0,55)
        Heading.BackgroundTransparency=1 Heading.Text="Validate Key" Heading.TextColor3=Color3.fromRGB(245,245,245)
        Heading.TextSize=22 Heading.Font=Enum.Font.GothamBold Heading.TextXAlignment=Enum.TextXAlignment.Left Heading.Parent=Frame

        local Sub = Instance.new("TextLabel")
        Sub.Size = UDim2.new(1, -64, 0, 18)
        Sub.Position = UDim2.new(0, 32, 0, 84)
        Sub.BackgroundTransparency = 1
        Sub.Text = "Enter your access key to continue to Cokeboys."
        Sub.TextColor3 = Color3.fromRGB(174, 172, 184)
        Sub.TextSize = 12
        Sub.Font = Enum.Font.Gotham
        Sub.TextWrapped = true
        Sub.TextXAlignment=Enum.TextXAlignment.Left Sub.Parent = Frame

        local KeyLabel = Instance.new("TextLabel")
        KeyLabel.Size = UDim2.new(1, -64, 0, 16)
        KeyLabel.Position = UDim2.new(0, 32, 0, 112)
        KeyLabel.BackgroundTransparency = 1
        KeyLabel.Text = "Access key"
        KeyLabel.TextColor3 = Color3.fromRGB(194, 191, 202)
        KeyLabel.TextSize = 11
        KeyLabel.Font = Enum.Font.GothamMedium
        KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
        KeyLabel.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Name = "KeyInput"
        Input.Size = UDim2.new(1, -64, 0, 42)
        Input.Position = UDim2.new(0, 32, 0, 134)
        Input.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        Input.BorderSizePixel = 0
         
         
        Input.PlaceholderText = ""
        Input.PlaceholderColor3 = Color3.fromRGB(119, 117, 129)
        Input.Text = savedKey or ""
        Input.TextColor3 = Color3.fromRGB(245, 243, 248)
        Input.TextSize = 13
        Input.Font = Enum.Font.Gotham
        Input.TextXAlignment = Enum.TextXAlignment.Left
        Input.ClearTextOnFocus = false
        Input.Parent = Frame
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = Input
        local InputStroke = Instance.new("UIStroke")
        InputStroke.Color = Color3.fromRGB(62, 62, 70)
        InputStroke.Thickness = 1
        InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        InputStroke.Parent = Input
        local InputPadding = Instance.new("UIPadding")
        InputPadding.PaddingLeft = UDim.new(0, 13)
        InputPadding.PaddingRight = UDim.new(0, 13)
        InputPadding.Parent = Input
        local KeyPlaceholder=Instance.new("TextLabel")
        KeyPlaceholder.Name="KeyFormatPlaceholder"
        KeyPlaceholder.Size=UDim2.new(1,-26,1,0)
        KeyPlaceholder.Position=UDim2.new(0,13,0,0)
        KeyPlaceholder.BackgroundTransparency=1
        KeyPlaceholder.Text="COKEBOYS-XXXX-XXXX"
        KeyPlaceholder.TextColor3=Color3.fromRGB(119,117,129)
        KeyPlaceholder.TextSize=13
        KeyPlaceholder.Font=Enum.Font.Gotham
        KeyPlaceholder.TextXAlignment=Enum.TextXAlignment.Left
        KeyPlaceholder.Active=false
        KeyPlaceholder.ZIndex=Input.ZIndex+1
        KeyPlaceholder.Visible=Input.Text==""
        KeyPlaceholder.Parent=Input

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Name = "ValidateButton"
        SubmitBtn.Size = UDim2.new(1, -64, 0, 40)
        SubmitBtn.Position = UDim2.new(0, 32, 0, 205)
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 210, 31)
        SubmitBtn.BorderSizePixel = 0
        SubmitBtn.AutoButtonColor = false
        SubmitBtn.Text = "Validate Key"
        SubmitBtn.TextColor3 = Color3.fromRGB(20, 17, 0)
        SubmitBtn.TextSize = 13
        SubmitBtn.Font = Enum.Font.GothamBold
        SubmitBtn.Parent = Frame
        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UDim.new(0, 4)
        SubmitCorner.Parent = SubmitBtn
        local SubmitStroke = Instance.new("UIStroke")
        SubmitStroke.Color = Color3.fromRGB(255, 230, 109)
        SubmitStroke.Thickness = 1
        SubmitStroke.Transparency = 0.18
        SubmitStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        SubmitStroke.Parent = SubmitBtn

        local Status = Instance.new("TextLabel")
        Status.Name = "AuthenticationStatus"
        Status.Size = UDim2.new(1, -64, 0, 20)
        Status.Position = UDim2.new(0, 32, 0, 180)
        Status.BackgroundTransparency = 1
        Status.Text = loaderInitialStatusRaw or (loaderInitialStatusKey and translateText(loaderInitialStatusKey)) or ""
        Status.TextColor3 = loaderInitialStatusColor or Color3.fromRGB(174, 172, 184)
        Status.TextSize = 11
        Status.Font = Enum.Font.GothamMedium
        Status.TextWrapped = true
        Status.Parent = Frame

        local SecondaryActions = Instance.new("Frame")
        SecondaryActions.Name = "SecondaryActions"
        SecondaryActions.Size = UDim2.new(1, -64, 0, 38)
        SecondaryActions.Position = UDim2.new(0, 32, 0, 252)
        SecondaryActions.BackgroundTransparency = 1
        SecondaryActions.Parent = Frame

        local GetKeyBtn = Instance.new("TextButton")
        GetKeyBtn.Name = "GetKeyButton"
        GetKeyBtn.Size = UDim2.new(0.5, -6, 1, 0)
        GetKeyBtn.BackgroundColor3 = Color3.fromRGB(238, 67, 84)
        GetKeyBtn.BorderSizePixel = 0
        GetKeyBtn.AutoButtonColor = false
        GetKeyBtn.Text = "Click Here to Get a Key"
        GetKeyBtn.TextColor3 = Color3.fromRGB(245, 243, 248)
        GetKeyBtn.TextSize = 12
        GetKeyBtn.Font = Enum.Font.GothamBold
        GetKeyBtn.TextTruncate = Enum.TextTruncate.AtEnd
        GetKeyBtn.Parent = SecondaryActions
        local GetKeyCorner = Instance.new("UICorner")
        GetKeyCorner.CornerRadius = UDim.new(0, 5)
        GetKeyCorner.Parent = GetKeyBtn
        local GetKeyStroke = Instance.new("UIStroke")
        GetKeyStroke.Color = Color3.fromRGB(255, 105, 119)
        GetKeyStroke.Thickness = 1
        GetKeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        GetKeyStroke.Parent = GetKeyBtn

        local DiscordBtn = Instance.new("TextButton")
        DiscordBtn.Name = "DiscordButton"
        DiscordBtn.Size = UDim2.new(0.5, -6, 1, 0)
        DiscordBtn.Position = UDim2.new(0.5, 6, 0, 0)
        DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        DiscordBtn.BorderSizePixel = 0
        DiscordBtn.AutoButtonColor = false
        DiscordBtn.Text = "Join Discord"
        DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        DiscordBtn.TextSize = 12
        DiscordBtn.Font = Enum.Font.GothamBold
        DiscordBtn.TextTruncate = Enum.TextTruncate.AtEnd
        DiscordBtn.Parent = SecondaryActions
        local DiscordCorner = Instance.new("UICorner")
        DiscordCorner.CornerRadius = UDim.new(0, 5)
        DiscordCorner.Parent = DiscordBtn
        local DiscordStroke = Instance.new("UIStroke")
        DiscordStroke.Color = Color3.fromRGB(119, 132, 255)
        DiscordStroke.Thickness = 1
        DiscordStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        DiscordStroke.Parent = DiscordBtn

        local FooterDivider = Instance.new("Frame")
        FooterDivider.Size = UDim2.new(1, -64, 0, 1)
        FooterDivider.Position = UDim2.new(0, 32, 0, 301)
        FooterDivider.BackgroundColor3 = Color3.fromRGB(31, 31, 35)
        FooterDivider.BorderSizePixel = 0
        FooterDivider.Parent = Frame

        local LanguageBtn = Instance.new("TextButton")
        LanguageBtn.Name = "LanguageButton"
        LanguageBtn.Size = UDim2.new(1, -64, 0, 34)
        LanguageBtn.Position = UDim2.new(0, 32, 0, 310)
        LanguageBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        LanguageBtn.BorderSizePixel = 0
        LanguageBtn.AutoButtonColor = false
        LanguageBtn.TextColor3 = Color3.fromRGB(211, 208, 219)
        LanguageBtn.TextSize = 10
        LanguageBtn.Font = Enum.Font.GothamMedium
        LanguageBtn.TextTruncate = Enum.TextTruncate.AtEnd
        LanguageBtn.Parent = Frame
        local LanguageCorner = Instance.new("UICorner")
        LanguageCorner.CornerRadius = UDim.new(0, 5)
        LanguageCorner.Parent = LanguageBtn
        local LanguageStroke = Instance.new("UIStroke")
        LanguageStroke.Color = Color3.fromRGB(62, 62, 70)
        LanguageStroke.Thickness = 1
        LanguageStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        LanguageStroke.Parent = LanguageBtn

        local VersionBadge = Instance.new("TextLabel")
        VersionBadge.Name = "VersionBadge"
        VersionBadge.Size = UDim2.new(0, 58, 0, 24)
        VersionBadge.Position = UDim2.new(1, -116, 0, 17)
        VersionBadge.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
        VersionBadge.BorderSizePixel = 0
        VersionBadge.Text = "v2.2"
        VersionBadge.TextColor3 = Color3.fromRGB(255, 210, 31)
        VersionBadge.TextSize = 12
        VersionBadge.Font = Enum.Font.GothamBold
        VersionBadge.Parent = Frame
        local VersionCorner = Instance.new("UICorner")
        VersionCorner.CornerRadius = UDim.new(1, 0)
        VersionCorner.Parent = VersionBadge
        local VersionStroke=Instance.new("UIStroke")
        VersionStroke.Color=Color3.fromRGB(84,74,30)
        VersionStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        VersionStroke.Parent=VersionBadge

        local currentStatusKey=loaderInitialStatusKey
        local currentStatusRaw=loaderInitialStatusRaw
        local currentStatusColor=loaderInitialStatusColor or Color3.fromRGB(174,172,184)
        local validationPresentationKey="Validate Key"
        local function refreshAuthenticationStatus()
            Status.Text=currentStatusRaw or (currentStatusKey and translateText(currentStatusKey)) or ""
            Status.TextColor3=currentStatusColor
        end
        local function setAuthenticationStatus(key,color,raw)
            currentStatusKey=key
            currentStatusRaw=raw
            currentStatusColor=color or Color3.fromRGB(174,172,184)
            refreshAuthenticationStatus()
        end
        local function setValidationPresentation(isBusy,labelKey)
            validationPresentationKey=labelKey or "Validate Key"
            SubmitBtn.Active=not isBusy
            SubmitBtn.Selectable=not isBusy
            SubmitBtn.BackgroundColor3=isBusy and Color3.fromRGB(91,78,27) or Color3.fromRGB(255,210,31)
            SubmitBtn.TextTransparency=isBusy and 0.12 or 0
            SubmitBtn.Text=translateText(validationPresentationKey)
        end

        local function refreshKeyPageLanguage()
            Heading.Text=translateText("Validate Key")
            Sub.Text=translateText("Enter your access key to continue to Cokeboys.")
            KeyLabel.Text=translateText("Access key")
            SubmitBtn.Text=translateText(validationPresentationKey)
            GetKeyBtn.Text=translateText("Click Here to Get a Key")
            DiscordBtn.Text=translateText("Join Discord")
            CloseBtn:SetAttribute("AccessibilityText",translateText("Close"))
            refreshAuthenticationStatus()
            local shown=languagePreference=="Auto"
                and (LANGUAGE_NAMES.Auto.."  •  "..(LANGUAGE_NAMES[interfaceLanguage] or interfaceLanguage))
                or (LANGUAGE_NAMES[languagePreference] or languagePreference)
            LanguageBtn.Text="🌐  "..shown.."   ▼"
        end

        LanguageBtn.Activated:Connect(function()
            if gui:FindFirstChild("LanguagePicker") then return end
            local overlay=Instance.new("TextButton")
            overlay.Name="LanguagePicker"
            overlay.Size=UDim2.new(1,0,1,0)
            overlay.BackgroundColor3=Color3.new(0,0,0)
            overlay.BackgroundTransparency=0.3
            overlay.BorderSizePixel=0
            overlay.Text="" overlay.AutoButtonColor=false overlay.Active=true
            overlay.ZIndex=50
            overlay.Parent=gui

            local viewportSize=overlay.AbsoluteSize
            if viewportSize.X<=0 or viewportSize.Y<=0 then
                local camera=workspace.CurrentCamera
                viewportSize=camera and camera.ViewportSize or Vector2.new(1280,720)
            end
            local optionCount=math.max(1,#LANGUAGE_OPTIONS)
            local optionTop=48
            local optionGap=5
            local bottomPadding=11
            local normalRowHeight=32
            local desiredOptionsHeight=(optionCount*normalRowHeight)+(math.max(0,optionCount-1)*optionGap)
            local desiredPickerHeight=optionTop+desiredOptionsHeight+bottomPadding
            local pickerHeight=math.min(desiredPickerHeight,math.max(120,viewportSize.Y-12))
            local availableOptionsHeight=math.max(40,pickerHeight-optionTop-bottomPadding)
            local fittedRowHeight=math.floor((availableOptionsHeight-(math.max(0,optionCount-1)*optionGap))/optionCount)
            local scrollOptions=fittedRowHeight<26
            local optionRowHeight=scrollOptions and normalRowHeight or math.min(normalRowHeight,fittedRowHeight)
            local optionContentHeight=(optionCount*optionRowHeight)+(math.max(0,optionCount-1)*optionGap)

            local picker=Instance.new("Frame")
            picker.Size=UDim2.new(0,math.min(340,math.max(240,viewportSize.X-24)),0,pickerHeight)
            picker.AnchorPoint=Vector2.new(0.5,0.5)
            picker.Position=UDim2.new(0.5,0,0.5,0)
            picker.BackgroundColor3=Color3.fromRGB(16,16,21)
            picker.BorderSizePixel=0
            picker.Active=true
            picker.ClipsDescendants=true
            picker.ZIndex=51
            picker.Parent=overlay
            local pickerCorner=Instance.new("UICorner")
            pickerCorner.CornerRadius=UDim.new(0,11)
            pickerCorner.Parent=picker
            local pickerStroke=Instance.new("UIStroke")
            pickerStroke.Color=Color3.fromRGB(255,210,31)
            pickerStroke.Thickness=1.5
            pickerStroke.Parent=picker

            local heading=Instance.new("TextLabel")
            heading.Size=UDim2.new(1,-48,0,38)
            heading.Position=UDim2.new(0,16,0,8)
            heading.BackgroundTransparency=1
            heading.Text="🌐  "..translateText("Select Language")
            heading.TextColor3=Color3.fromRGB(245,245,248)
            heading.TextSize=15
            heading.Font=Enum.Font.GothamBold
            heading.TextXAlignment=Enum.TextXAlignment.Left
            heading.ZIndex=52
            heading.Parent=picker
            local close=Instance.new("TextButton")
            close.Size=UDim2.new(0,30,0,30)
            close.Position=UDim2.new(1,-39,0,9)
            close.BackgroundColor3=Color3.fromRGB(38,37,45)
            close.BorderSizePixel=0
            close.Text="×"
            close.TextColor3=Color3.fromRGB(235,235,242)
            close.TextSize=18
            close.Font=Enum.Font.GothamBold
            close.ZIndex=52
            close.Parent=picker
            local closeCorner=Instance.new("UICorner")
            closeCorner.CornerRadius=UDim.new(0,7)
            closeCorner.Parent=close
            close.Activated:Connect(function() overlay:Destroy() end)

            local optionList=Instance.new(scrollOptions and "ScrollingFrame" or "Frame")
            optionList.Size=UDim2.new(1,-32,0,availableOptionsHeight)
            optionList.Position=UDim2.new(0,16,0,optionTop)
            optionList.BackgroundTransparency=1
            optionList.BorderSizePixel=0
            optionList.ClipsDescendants=true
            optionList.ZIndex=52
            optionList.Parent=picker
            if scrollOptions then
                optionList.CanvasSize=UDim2.new(0,0,0,optionContentHeight)
                optionList.AutomaticCanvasSize=Enum.AutomaticSize.None
                optionList.ScrollingDirection=Enum.ScrollingDirection.Y
                optionList.ScrollBarThickness=3
                optionList.ScrollBarImageColor3=Color3.fromRGB(255,210,31)
                optionList.ElasticBehavior=Enum.ElasticBehavior.Never
            end

            for index,entry in ipairs(LANGUAGE_OPTIONS) do
                local selected=entry.code==languagePreference
                local button=Instance.new("TextButton")
                button.Size=UDim2.new(1,scrollOptions and -7 or 0,0,optionRowHeight)
                button.Position=UDim2.new(0,0,0,(index-1)*(optionRowHeight+optionGap))
                button.BackgroundColor3=selected and Color3.fromRGB(50,44,22) or Color3.fromRGB(27,26,32)
                button.BorderSizePixel=0
                button.Text=(selected and "✓  " or "    ")..entry.name
                if entry.code=="Auto" then button.Text=button.Text.."  •  "..(LANGUAGE_NAMES[detectInterfaceLanguage()] or "English") end
                button.TextColor3=selected and Color3.fromRGB(255,210,31) or Color3.fromRGB(240,240,244)
                button.TextSize=12
                button.Font=selected and Enum.Font.GothamBold or Enum.Font.GothamMedium
                button.TextXAlignment=Enum.TextXAlignment.Left
                button.ZIndex=52
                button.Parent=optionList
                local buttonCorner=Instance.new("UICorner")
                buttonCorner.CornerRadius=UDim.new(0,7)
                buttonCorner.Parent=button
                local buttonPadding=Instance.new("UIPadding")
                buttonPadding.PaddingLeft=UDim.new(0,12)
                buttonPadding.Parent=button
                button.Activated:Connect(function()
                    saveLanguagePreference(entry.code)
                    overlay:Destroy()
                    refreshKeyPageLanguage()
                end)
            end
            overlay.Activated:Connect(function() if overlay.Parent then overlay:Destroy() end end)
        end)
        refreshKeyPageLanguage()

        local layoutConnection
        local cameraReplacementConnection
        local function updateKeyPageLayout()
            if not LayoutRoot.Parent then return end
            local camera = workspace.CurrentCamera
            local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
            local safeWidth=math.max(1,viewport.X-24)
            local safeHeight=math.max(1,viewport.Y-24)
            local stackActions=safeWidth<406
            local logicalHeight=stackActions and 411 or 365
            LayoutRoot.Size=UDim2.new(0,470,0,logicalHeight)
            SecondaryActions.Size=UDim2.new(1,-64,0,stackActions and 82 or 38)
            GetKeyBtn.Size=stackActions and UDim2.new(1,0,0,38) or UDim2.new(0.5,-6,1,0)
            DiscordBtn.Size=stackActions and UDim2.new(1,0,0,38) or UDim2.new(0.5,-6,1,0)
            DiscordBtn.Position=stackActions and UDim2.new(0,0,0,44) or UDim2.new(0.5,6,0,0)
            FooterDivider.Position=UDim2.new(0,32,0,stackActions and 347 or 301)
            LanguageBtn.Position=UDim2.new(0,32,0,stackActions and 356 or 310)
             
             
             
            LayoutScale.Scale=math.min(1,safeWidth/470,safeHeight/logicalHeight)
        end

        local function bindKeyPageCamera()
            if layoutConnection then layoutConnection:Disconnect(); layoutConnection=nil end
            local camera=workspace.CurrentCamera
            if camera then
                layoutConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateKeyPageLayout)
                table.insert(loaderController.loaderConnections,layoutConnection)
            end
            updateKeyPageLayout()
        end
        cameraReplacementConnection=workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindKeyPageCamera)
        table.insert(loaderController.loaderConnections,cameraReplacementConnection)
        bindKeyPageCamera()

        CloseBtn.Activated:Connect(function()
            if loaderController:isCurrent() then
                cancelCurrentAuthentication("close button")
            end
        end)
        CloseBtn.MouseEnter:Connect(function()
            CloseBtn.BackgroundColor3=Color3.fromRGB(28,28,32)
            CloseBtn.TextColor3=Color3.fromRGB(245,242,248)
        end)
        CloseBtn.MouseLeave:Connect(function()
            CloseBtn.BackgroundColor3=Color3.fromRGB(17,17,20)
            CloseBtn.TextColor3=Color3.fromRGB(205,202,212)
        end)
        Input.Focused:Connect(function()
            KeyPlaceholder.Visible=false
            task.defer(function()
                if Input and Input.Parent and Input:IsFocused() then
                    Input.SelectionStart=-1
                    Input.CursorPosition=#Input.Text+1
                end
            end)
            InputStroke.Color=Color3.fromRGB(255,210,31)
            InputStroke.Thickness=1.5
        end)
        Input.FocusLost:Connect(function()
            KeyPlaceholder.Visible=Input.Text==""
            InputStroke.Color=Color3.fromRGB(62,62,70)
            InputStroke.Thickness=1
        end)
        Input:GetPropertyChangedSignal("Text"):Connect(function()
            KeyPlaceholder.Visible=Input.Text=="" and not Input:IsFocused()
        end)
        SubmitBtn.MouseEnter:Connect(function()
            if SubmitBtn.Active then SubmitBtn.BackgroundColor3=Color3.fromRGB(255,230,109) end
        end)
        SubmitBtn.MouseLeave:Connect(function()
            if SubmitBtn.Active then SubmitBtn.BackgroundColor3=Color3.fromRGB(255,210,31) end
        end)
        SubmitBtn.MouseButton1Down:Connect(function()
            if SubmitBtn.Active then SubmitBtn.BackgroundColor3=Color3.fromRGB(226,184,20) end
        end)
        SubmitBtn.MouseButton1Up:Connect(function()
            if SubmitBtn.Active then SubmitBtn.BackgroundColor3=Color3.fromRGB(255,230,109) end
        end)
        LanguageBtn.MouseEnter:Connect(function()
            LanguageBtn.BackgroundColor3=Color3.fromRGB(25,25,30) LanguageStroke.Color=Color3.fromRGB(112,91,20)
        end)
        LanguageBtn.MouseLeave:Connect(function()
            LanguageBtn.BackgroundColor3=Color3.fromRGB(18,18,22) LanguageStroke.Color=Color3.fromRGB(62,62,70)
        end)

         
         
        GetKeyBtn.Activated:Connect(function()
            local clipboardWriter=setclipboard or toclipboard
            local copied=type(clipboardWriter)=="function" and pcall(clipboardWriter,LINKVERTISE)
            GetKeyBtn.Text=copied and translateText("Get-key link copied!") or translateText("Clipboard unavailable")
            task.delay(3, function()
                if GetKeyBtn and GetKeyBtn.Parent then
                    GetKeyBtn.Text=translateText("Click Here to Get a Key")
                end
            end)
        end)

        GetKeyBtn.MouseEnter:Connect(function()
            GetKeyBtn.BackgroundColor3 = Color3.fromRGB(249, 82, 98)
            GetKeyStroke.Color = Color3.fromRGB(255,130,141)
        end)
        GetKeyBtn.MouseLeave:Connect(function()
            GetKeyBtn.BackgroundColor3 = Color3.fromRGB(238,67,84)
            GetKeyStroke.Color = Color3.fromRGB(255,105,119)
        end)
        GetKeyBtn.MouseButton1Down:Connect(function()
            GetKeyBtn.BackgroundColor3 = Color3.fromRGB(205, 50, 65)
        end)
        GetKeyBtn.MouseButton1Up:Connect(function()
            GetKeyBtn.BackgroundColor3 = Color3.fromRGB(249, 82, 98)
        end)

         
        DiscordBtn.Activated:Connect(function()
            local clipboardWriter=setclipboard or toclipboard
            local copied = type(clipboardWriter)=="function" and pcall(clipboardWriter, DISCORD_INVITE)
            DiscordBtn.Text = copied and translateText("Discord invite copied!") or "Discord: " .. DISCORD_INVITE
            task.delay(3, function()
                if DiscordBtn and DiscordBtn.Parent then
                    DiscordBtn.Text = translateText("Join Discord")
                end
            end)
        end)

        DiscordBtn.MouseEnter:Connect(function()
            DiscordBtn.BackgroundColor3 = Color3.fromRGB(108,120,255)
            DiscordStroke.Color = Color3.fromRGB(150,159,255)
        end)
        DiscordBtn.MouseLeave:Connect(function()
            DiscordBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
            DiscordStroke.Color = Color3.fromRGB(119,132,255)
        end)
        DiscordBtn.MouseButton1Down:Connect(function()
            DiscordBtn.BackgroundColor3 = Color3.fromRGB(67, 78, 198)
        end)
        DiscordBtn.MouseButton1Up:Connect(function()
            DiscordBtn.BackgroundColor3 = Color3.fromRGB(108, 120, 255)
        end)

         
        SubmitBtn.Activated:Connect(function()
            if not loaderController:isCurrent()
                or (loaderController.state~="AUTH" and loaderController.state~="AUTH_ERROR") then return end
            local key = Input.Text:match("^%s*(.-)%s*$")
            if key == "" then
                setAuthenticationStatus("Please enter a key",Color3.fromRGB(239,98,111))
                return
            end

            if string.upper(key) == "COKEBOYS-BETA-TEST" then
                setAuthenticationStatus("Beta key retired - use Get a Key below",Color3.fromRGB(239,98,111))
                return
            end

            local expectedState=loaderController.state
            if not loaderController:transition("VALIDATING",expectedState) then return end
            loaderController.validationGeneration+=1
            local enteredValidationGeneration=loaderController.validationGeneration
            local enteredLaunchGeneration=loaderController.launchGeneration
            setAuthenticationStatus("Checking...",Color3.fromRGB(198,195,207))
            setValidationPresentation(true,"Checking...")

            spawnKeyTask(function()
                local hwid, username = getPlayerInfo()
                local valid, msg, data, completed = validateKey(key, hwid, username, GAME_NAME)
                if not loaderController:ownsAttempt(enteredLaunchGeneration,enteredValidationGeneration,"VALIDATING") then return end

                if valid then
                    setAuthenticationStatus("Key accepted",Color3.fromRGB(112,213,151))
                    setValidationPresentation(true,"Preparing Cokeboys...")
                     
                     
                    task.defer(function()
                        if not loaderController:ownsAttempt(enteredLaunchGeneration,enteredValidationGeneration,"VALIDATING") then return end
                        local committed,commitError=authenticatedContinuation(key,data,true,enteredValidationGeneration)
                        if not committed and loaderController:isCurrent() and loaderController.state=="AUTH_ERROR" and gui.Parent then
                            local failure=tostring(commitError or translateText("Invalid key"))
                            setAuthenticationStatus(nil,Color3.fromRGB(239,98,111),failure)
                            setValidationPresentation(false,"Validate Key")
                        end
                    end)
                else
                    if not loaderController:transition("AUTH_ERROR","VALIDATING") then return end
                    if not gui.Parent then return end
                    if completed then
                        if not msg or msg=="Invalid key" or msg=="Unknown error" then
                            setAuthenticationStatus("Invalid key",Color3.fromRGB(239,98,111))
                        else
                            setAuthenticationStatus(nil,Color3.fromRGB(239,98,111),tostring(msg))
                        end
                    elseif msg=="Connection failed" then
                        setAuthenticationStatus("Connection unavailable. Try again.",Color3.fromRGB(239,165,93))
                    else
                        setAuthenticationStatus("Unable to verify key. Try again.",Color3.fromRGB(239,165,93))
                    end
                    setValidationPresentation(false,"Validate Key")
                end
            end)
        end)


    end)
end


runKeySystem(function() error("Private entry must hand off to the protected loader") end)
