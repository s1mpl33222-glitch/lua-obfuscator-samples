--[[ ============================================================================

    D x C   ·   LOADER
    ------------------
    C'est le SEUL fichier que le joueur possede.

    Il ne contient aucun menu, aucune fonctionnalite, aucun secret. Il contient
    une adresse, de quoi demander poliment, et de quoi verifier la reponse.
    Quelqu'un qui l'ouvre n'y trouve rien a voler : c'est tout l'interet.

    Le code du menu, lui, n'arrive qu'apres verification de la cle et de la
    machine, brouille pour cette session-la. Une reponse enregistree et rejouee
    ailleurs, ou plus tard, ne donne rien.

    --------------------------------------------------------------------------
    DEUX REGLES QUI GOUVERNENT TOUT CE FICHIER
    --------------------------------------------------------------------------

    1.  ON NE SE TROMPE JAMAIS DU COTE PERMISSIF.
        Un doute, une reponse bizarre, une capacite manquante : on refuse.
        L'ancienne porte faisait l'inverse -- reseau coupe, tout le monde
        entrait -- et c'etait sa faille principale.

    2.  LE SILENCE N'EST PAS UNE REVOCATION.
        Si le serveur ne repond plus, le joueur honnete garde son menu. On ne
        s'arrete que sur un ordre SIGNE, verifiable, qui dit explicitement
        « cette cle est coupee ». Une panne d'hebergeur ne doit pas se
        transformer en punition collective au milieu d'une soiree.

        Ces deux regles se contredisent en apparence. Elles ne s'appliquent
        simplement pas au meme moment : la premiere gouverne l'ENTREE (avant
        d'avoir le code), la seconde gouverne la SORTIE (une fois qu'on joue).

============================================================================ ]]

-- ============================================================================
--  0.  LES REGLAGES  --  la seule partie a modifier
-- ============================================================================

local SERVEUR   = "https://dxc-lic.tarienaregarder.workers.dev"   -- l'adresse de ton Worker
local SCRIPT    = "trackfield"                          -- le nom court du script
--  ⛔ LE BOUTON GET KEY POINTE SUR TON SERVEUR, PLUS SUR LE LOCKER.
--
--  C'est /go qui fabrique le jeton du joueur, l'attache au lien LootLabs et
--  l'y envoie ; le deuxieme locker est la destination du premier, et le second
--  finit sur /free. Deux passages payes pour un seul parcours, comme avant.
--
--  Ce que ca change pour toi : le jour ou tu changes de locker, tu ne republies
--  PLUS les six loaders. Tu changes un champ dans /admin, et c'est tout. C'est
--  exactement le maillon qui avait deja coute une heure a la mise en service --
--  les cinq loaders en ligne envoyaient encore vers l'ancien Discord.
--
--  Mettre "" ici cache le bouton vert.
local LIEN_CLE  = "https://dxc-lic.tarienaregarder.workers.dev/go"
local FICHIER   = "DxC/key.txt"                       -- la cle retenue d'une fois sur l'autre
local VERSION   = 1                                   -- version du loader

-- ============================================================================
--  1.  PETITS OUTILS
-- ============================================================================

local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")
local Moi         = Players.LocalPlayer

local DEUX32 = 4294967296

local function propre(t)
    if type(t) ~= "string" then return "" end
    return (t:gsub("^%s+", ""):gsub("%s+$", ""))
end

--  ⛔ OUVRIR LE NAVIGATEUR, ET SINON COPIER. DANS CET ORDRE.
--
--  Roblox interdit a un script de joueur d ouvrir une adresse : la fonction
--  est reservee aux scripts du client. Les executeurs, eux, tournent a un
--  niveau ou elle passe souvent -- mais pas tous, et pas sur toutes les
--  plateformes. Sur telephone c est justement la que ca compte : copier une
--  adresse puis ouvrir un navigateur a la main fait abandonner la moitie des
--  gens en chemin.
--
--  ⚠ CHAQUE ESSAI DANS SON PROPRE pcall. Un executeur qui leve sur le
--  premier ne doit pas empecher le second : c est exactement ce qui fait
--  qu un bouton ne fait RIEN chez un joueur sur deux, sans message.
--  ⛔ ON NE TENTE PLUS D OUVRIR LE NAVIGATEUR. MESURE, PAS SUPPOSE.
--
--  Deux voies existaient et ont ete essayees en vrai le 20 aout 2026 :
--  `GuiService:OpenBrowserWindow` et le `MessageBusService` de Roblox. Ni sur
--  telephone ni sur ordinateur elles n ont ouvert quoi que ce soit -- et
--  aucune des deux ne leve, donc le code se croyait en succes et annoncait un
--  navigateur qui ne venait jamais. Roblox reserve l ouverture d une adresse
--  a ses propres scripts ; aucune fonction d executeur ne la propose non plus.
--
--  On les a retirees plutot que de les laisser dormir : du code qui ne sert a
--  rien est du code qu on relira un jour en croyant qu il compte.
--
--  ⚠ LE PRESSE-PAPIER N A PAS LE MEME NOM PARTOUT. Quatre noms circulent
--  selon l executeur. On n en essayait qu UN : chez qui porte un autre nom, le
--  bouton ne copiait RIEN et ne disait rien -- un bouton mort. Chacun dans son
--  pcall, et on s arrete au premier qui repond.
local function copierLien(url)
    local copie = false
    for _, poser in ipairs({
        function() setclipboard(url) end,
        function() toclipboard(url) end,
        function() set_clipboard(url) end,
        function() Clipboard.set(url) end,
    }) do
        if copie then break end
        pcall(function() poser(); copie = true end)
    end
    return copie
end

local function dire(texte, duree)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "D x C", Text = texte, Duration = duree or 6,
        })
    end)
end

-- ============================================================================
--  2.  LE RESEAU
-- ============================================================================
--  Trois pieges, tous rencontres en vrai :
--
--    - Les executeurs n'ont pas tous la meme fonction pour poster. On essaie
--      dans l'ordre et on retient celle qui marche.
--    - Les noms d'en-tetes changent de casse d'un executeur a l'autre. Chercher
--      "x-dxc-next" en dur echoue en silence chez la moitie d'entre eux : la
--      rotation du jeton ne se fait plus et le telechargement s'arrete a la
--      deuxieme part, sans erreur comprehensible.
--    - Rien ne garantit un delai maximum. Un executeur qui se pend, c'est le
--      jeu fige pour toujours. On met donc notre propre garde-fou.
--
--  Et surtout : tout le reseau passe par UNE SEULE file. Certains executeurs
--  cassent si on lance deux requetes en meme temps -- ce qui arriverait
--  fatalement entre le battement de coeur et le telechargement.

local poster = rawget(getfenv(0), "request")
    or rawget(getfenv(0), "http_request")
    or (rawget(getfenv(0), "syn") and syn.request)
    or (rawget(getfenv(0), "fluxus") and fluxus.request)

local fileReseau = {}
local fileOccupee = false

local function enFile(travail)
    table.insert(fileReseau, travail)
    if fileOccupee then return end
    fileOccupee = true
    task.spawn(function()
        while #fileReseau > 0 do
            local t = table.remove(fileReseau, 1)
            --  Chaque appel tourne dans son propre fil, et la file ne
            --  l'attend pas indefiniment.
            --
            --  Rien ne garantit qu'un executeur rende la main : certains
            --  restent pendus sur une requete pour toujours. Si la file
            --  attendait sagement, UN seul appel pendu condamnerait tous les
            --  suivants -- dont les battements de coeur. Le canal de
            --  revocation serait coupe en silence, et personne ne verrait
            --  jamais pourquoi.
            --
            --  Au bout d'une minute on abandonne l'appel sur place -- il finira
            --  ou pas, ce n'est plus notre affaire -- et on passe au suivant.
            local fini = false
            task.spawn(function() pcall(t) ; fini = true end)
            local debut = os.clock()
            while not fini and (os.clock() - debut) < 60 do task.wait(0.05) end
        end
        fileOccupee = false
    end)
end

--  Cherche un en-tete sans se soucier de la casse.
local function entete(reponse, nom)
    local h = reponse and (reponse.Headers or reponse.headers)
    if type(h) ~= "table" then return nil end
    local cible = nom:lower()
    for k, v in pairs(h) do
        if type(k) == "string" and k:lower() == cible then return v end
    end
    return nil
end

--  Un appel reseau, avec delai maximum applicatif. On rend TOUJOURS la main :
--  soit la reponse, soit nil et une raison. Jamais un blocage indefini.
local function appeler(opts, delaiMax)
    local fini, demarre, res, err = false, false, nil, nil
    enFile(function()
        demarre = os.clock()
        local ok, r = pcall(function()
            if poster then
                return poster(opts)
            end
            -- Repli : pas de POST disponible. On ne peut faire que du GET.
            if opts.Method == "GET" or opts.Method == nil then
                return { Body = game:HttpGet(opts.Url, true), StatusCode = 200, Headers = {} }
            end
            return nil
        end)
        if ok and r then res = r else err = tostring(r) end
        fini = true
    end)

    --  Le compte a rebours ne demarre QU'UNE FOIS l'appel reellement lance.
    --  Sinon un battement de coeur mis en file derriere un telechargement de
    --  quarante secondes expirerait sans jamais avoir ete tente -- et on
    --  croirait le serveur injoignable alors qu'on ne lui a rien demande.
    --  Le temps d'attente en file est plafonne separement, et largement.
    local misEnFile = os.clock()
    while not fini do
        if demarre then
            if os.clock() - demarre > (delaiMax or 25) then
                return nil, "delai depasse"
            end
        elseif os.clock() - misEnFile > 120 then
            return nil, "file d'attente saturee"
        end
        task.wait(0.05)
    end
    if not res then return nil, err or "pas de reponse" end
    return res
end

local function corpsDe(r) return r and (r.Body or r.body) end
local function statutDe(r) return r and (r.StatusCode or r.status_code or r.Status or 0) or 0 end

--  Encodage pour une adresse : tout ce qui n'est pas une lettre, un chiffre ou
--  l'un des quatre caracteres surs devient %XX. Sans ca, un nom d'executeur
--  avec un espace ou un accent casse l'adresse en silence.
local function urlEnc(v)
    return (tostring(v):gsub("[^%w%-%._~]", function(c)
        return ("%%%02X"):format(c:byte())
    end))
end

--  Envoie des champs au serveur et rend sa reponse decodee.
--
--  Deux chemins, selon ce que sait faire l'executeur :
--
--    - il sait POSTER  -> on poste, les champs voyagent dans le corps ;
--    - il ne sait PAS  -> les memes champs voyagent dans l'adresse, en GET.
--
--  Le second cas n'est pas exotique : beaucoup d'executeurs n'ont que
--  `game:HttpGet`, qui ne sait ni poster ni envoyer d'en-tetes. Sans ce repli,
--  ces joueurs-la ne peuvent tout simplement pas se connecter -- et le message
--  qu'ils voient ne leur apprend rien, puisque la requete n'est jamais partie.
local function postJson(chemin, table_)
    if poster then
        local r, e = appeler({
            Url = SERVEUR .. chemin,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(table_),
        })
        if not r then return nil, e end
        local ok, dec = pcall(function() return HttpService:JSONDecode(corpsDe(r) or "") end)
        if not ok then return nil, "reponse illisible" end
        return dec, nil, statutDe(r)
    end

    --  g=1 previent le serveur qu'on est en mode degrade : il renverra ses
    --  refus avec un code 200 et le motif dans le corps. Sans ca, `HttpGet`
    --  leve une erreur seche sur le moindre 4xx, sans nous donner le corps --
    --  et « cle refusee » deviendrait « serveur injoignable ».
    local morceaux = { "g=1" }
    for k, v in pairs(table_) do
        morceaux[#morceaux + 1] = urlEnc(k) .. "=" .. urlEnc(v)
    end
    local r, e = appeler({
        Url = SERVEUR .. chemin .. "?" .. table.concat(morceaux, "&"),
        Method = "GET",
    })
    if not r then return nil, e end
    local ok, dec = pcall(function() return HttpService:JSONDecode(corpsDe(r) or "") end)
    if not ok then return nil, "reponse illisible" end
    return dec, nil, statutDe(r)
end

-- ============================================================================
--  3.  CE QUE SAIT FAIRE CET EXECUTEUR
-- ============================================================================
--  On sonde les fonctions une par une, pour de vrai. Tester `type(buffer) ==
--  "table"` ne suffit pas : certaines versions exposent la table sans les
--  fonctions qu'on utilise.

local CAP = {}

CAP.loadstring = (type(loadstring) == "function")

--  ============================================================================
--  ANTI-DUMP  --  on ne bloque rien, on PREVIENT.
--  ----------------------------------------------------------------------------
--  On garde tot une reference a loadstring. Un dumpeur courant remplace
--  loadstring par une fonction Lua pour capturer le corps a l'instant ou on le
--  lance. On le repere de deux facons, toutes deux gardees pour ne JAMAIS
--  crier faux (un client legitime ne doit pas remonter comme suspect) :
--    - loadstring a change depuis ici (hook pose APRES notre demarrage) ;
--    - loadstring n'est pas une C-closure ALORS QUE l'executeur sait distinguer
--      (on teste d'abord `iscclosure(print)`, natif : si l'executeur voit deja
--      `print` comme non-natif, il ne distingue rien et on se tait).
--  Le motif part dans le battement ; le serveur l'affiche dans /admin. C'est la
--  marque par cle qui rattrape le pro qui passerait sous ce radar.
local LOADSTRING_REF = loadstring

local function detecterDump()
    local motif = nil
    pcall(function()
        if rawequal and type(LOADSTRING_REF) == "function"
           and not rawequal(loadstring, LOADSTRING_REF) then
            motif = "loadstring-remplace"
        end
    end)
    if not motif then
        pcall(function()
            if type(iscclosure) == "function"
               and iscclosure(print) == true
               and iscclosure(loadstring) == false then
                motif = "loadstring-non-natif"
            end
        end)
    end
    return motif   --  nil si rien de suspect (la cle absente du JSON)
end

--  On sonde CHAQUE fonction qu'on utilisera reellement, en la faisant tourner.
--  Verifier que la table `buffer` existe ne suffit pas : il suffirait qu'une
--  seule de ces fonctions manque pour que le script plante brutalement APRES
--  avoir telecharge un mega-octet et demande sa cle au joueur -- au pire
--  moment, avec un message incomprehensible.
CAP.buffer = (function()
    if type(buffer) ~= "table" and type(buffer) ~= "userdata" then return false end
    local ok = pcall(function()
        local b = buffer.create(8)
        buffer.writeu32(b, 0, 123456789)
        assert(buffer.readu32(b, 0) == 123456789)
        buffer.writeu8(b, 4, 200)
        assert(buffer.readu8(b, 4) == 200)
        assert(buffer.len(b) == 8)
        local c = buffer.create(4)
        buffer.copy(c, 0, b, 0, 4)
        assert(buffer.readu32(c, 0) == 123456789)
        assert(buffer.tostring(buffer.fromstring("ab")) == "ab")
    end)
    return ok
end)()

CAP.bit32 = (type(bit32) == "table" and type(bit32.bxor) == "function")

-- ============================================================================
--  4.  L'EMPREINTE  (SHA-256)
-- ============================================================================
--  Sert a prouver qu'on detient la cle, et a retrouver le masque de session.
--  Les entrees font quelques dizaines d'octets : le cout est negligeable.

local K256 = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
    0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
    0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
    0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
    0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
    0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

local function empreinte(texte)
    local h = { 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
                0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19 }
    local m = texte .. string.char(128)
    while (#m % 64) ~= 56 do m = m .. string.char(0) end
    local bits = #texte * 8
    m = m .. string.char(0, 0, 0, 0)
    for i = 3, 0, -1 do
        m = m .. string.char(math.floor(bits / 2 ^ (8 * i)) % 256)
    end

    local w = {}
    for bloc = 1, #m, 64 do
        for i = 0, 15 do
            local a, b, c, d = m:byte(bloc + i * 4, bloc + i * 4 + 3)
            w[i + 1] = ((a * 256 + b) * 256 + c) * 256 + d
        end
        for i = 17, 64 do
            local v15, v2 = w[i - 15], w[i - 2]
            local s0 = bit32.bxor(bit32.rrotate(v15, 7), bit32.rrotate(v15, 18), bit32.rshift(v15, 3))
            local s1 = bit32.bxor(bit32.rrotate(v2, 17), bit32.rrotate(v2, 19), bit32.rshift(v2, 10))
            w[i] = (w[i - 16] + s0 + w[i - 7] + s1) % DEUX32
        end
        local a, b, c, d = h[1], h[2], h[3], h[4]
        local e, f, g, hh = h[5], h[6], h[7], h[8]
        for i = 1, 64 do
            local S1 = bit32.bxor(bit32.rrotate(e, 6), bit32.rrotate(e, 11), bit32.rrotate(e, 25))
            local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
            local t1 = (hh + S1 + ch + K256[i] + w[i]) % DEUX32
            local S0 = bit32.bxor(bit32.rrotate(a, 2), bit32.rrotate(a, 13), bit32.rrotate(a, 22))
            local maj = bit32.bxor(bit32.band(a, b), bit32.band(a, c), bit32.band(b, c))
            local t2 = (S0 + maj) % DEUX32
            hh = g; g = f; f = e
            e = (d + t1) % DEUX32
            d = c; c = b; b = a
            a = (t1 + t2) % DEUX32
        end
        h[1] = (h[1] + a) % DEUX32; h[2] = (h[2] + b) % DEUX32
        h[3] = (h[3] + c) % DEUX32; h[4] = (h[4] + d) % DEUX32
        h[5] = (h[5] + e) % DEUX32; h[6] = (h[6] + f) % DEUX32
        h[7] = (h[7] + g) % DEUX32; h[8] = (h[8] + hh) % DEUX32
    end
    local s = {}
    for i = 1, 8 do s[i] = ("%08x"):format(h[i]) end
    return table.concat(s)
end

-- ============================================================================
--  5.  LE DEBROUILLAGE
-- ============================================================================
--  Doit produire exactement les memes octets que le serveur. Verifie hors du
--  jeu contre une implementation ecrite separement, et rejouable dans le jeu
--  avec outils\AUTOTEST.lua.
--
--  Le decoupage en tranches n'est pas une coquetterie : d'un seul tenant, 1,5
--  Mo bloquent le jeu assez longtemps pour que ca se voie. On rend donc la
--  main regulierement.

local function xoDemarrer(cle)         -- cle : table de 16 octets
    local function mot(o)
        return cle[o] + cle[o + 1] * 256 + cle[o + 2] * 65536 + cle[o + 3] * 16777216
    end
    local s = { mot(1), mot(5), mot(9), mot(13) }
    if s[1] == 0 and s[2] == 0 and s[3] == 0 and s[4] == 0 then s[1] = 0x9E3779B9 end
    local function suivant()
        local s0, s1, s2, s3 = s[1], s[2], s[3], s[4]
        local r = (bit32.lrotate((s1 * 5) % DEUX32, 7) * 9) % DEUX32
        local t = bit32.lshift(s1, 9)
        s2 = bit32.bxor(s2, s0); s3 = bit32.bxor(s3, s1)
        s1 = bit32.bxor(s1, s2); s0 = bit32.bxor(s0, s3)
        s2 = bit32.bxor(s2, t);  s3 = bit32.lrotate(s3, 11)
        s[1], s[2], s[3], s[4] = s0, s1, s2, s3
        return r
    end
    for _ = 1, 8 do suivant() end       -- echauffement
    return suivant
end

local function hexEnOctets(h)
    local t = {}
    for i = 1, #h, 2 do t[#t + 1] = tonumber(h:sub(i, i + 1), 16) end
    return t
end

--  Debrouille un buffer sur place, en rendant la main toutes les 6 ms.
local function debrouiller(buf, cle, surAvancement)
    local suivant = xoDemarrer(cle)
    local n = buffer.len(buf)
    local nfull = math.floor(n / 4)
    local i = 0
    local BUDGET = 0.006
    while i < nfull do
        local t0 = os.clock()
        while i < nfull and (os.clock() - t0) < BUDGET do
            local fin = math.min(nfull, i + 2048)
            while i < fin do
                local o = i * 4
                buffer.writeu32(buf, o, bit32.bxor(buffer.readu32(buf, o), suivant()))
                i = i + 1
            end
        end
        if surAvancement then surAvancement(i / nfull) end
        task.wait()
    end
    local reste = n % 4
    if reste > 0 then
        local w = suivant()
        for j = 0, reste - 1 do
            local o = nfull * 4 + j
            buffer.writeu8(buf, o, bit32.bxor(buffer.readu8(buf, o), bit32.band(bit32.rshift(w, 8 * j), 255)))
        end
    end
end

-- ============================================================================
--  6.  L'IDENTITE DE LA MACHINE
-- ============================================================================
--  ⛔ UNE SEULE SOURCE, LA MEILLEURE DISPONIBLE. JAMAIS UN COLLAGE.
--
--  L ancienne version collait bout a bout TOUT ce qui repondait :
--      identite = gethwid() .. "." .. GetClientId()
--  Il suffisait donc qu UNE source change -- ou reponde une fois et pas la
--  suivante, un pcall qui echoue, un service pas encore charge au lancement --
--  pour que l identite entiere devienne differente. Le joueur devenait une
--  machine neuve sans avoir rien fait, et voyait « cette cle est deja utilisee
--  sur 1 machine ». Signale le 22 aout 2026 par un joueur qui avait simplement
--  change de compte Roblox sur le meme PC.
--
--  ⚠ ET C EST LE COLLAGE LE VRAI DEFAUT, PAS LA SOURCE. Remplacer une source
--  par une autre n aurait rien regle : deux sources collees, c est deux fois
--  plus de chances que l identite bouge. On en prend UNE, la meilleure qui
--  reponde, et on s y tient.
--
--  L ordre va du plus lie au materiel au plus lie a la personne :
--    hw       l executeur lit le materiel. Meme PC = meme identite, quels que
--             soient le compte et le nombre de Roblox ouverts. C est le but.
--
--  ⚠ ET PAS DE FICHIER RANGE SUR LE DISQUE. L idee etait tentante : un
--  identifiant tire au hasard une fois, ecrit dans DxC/machine.txt, stable
--  pour toujours. Mais c est un fichier texte de trente caracteres : on le
--  copie sur une cle USB et deux PC partagent la meme cle. Ca aurait ete le
--  maillon le PLUS FAIBLE de la liste, et il n existait pas avant -- reparer
--  un probleme de robustesse en ouvrant un trou est un mauvais echange.
--
--  Ce qui remplace : le SERVEUR compte les changements d adresse IP par
--  machine. Le client ne peut pas mentir la-dessus, c est nous qui voyons.
--    client   l identifiant Roblox de l installation. Garde en dernier recours
--             parce qu il bougerait au redemarrage du PC d apres la communaute.
--    compte   le UserId. Change des qu on change de compte : c est exactement
--             le probleme qu on repare. On ne s en sert que si tout le reste a
--             echoue, et on le SIGNALE au serveur pour que ca se voie.
local SRC_MACHINE = "?"

local function identiteMachine()
    local function propreId(v)
        if type(v) ~= "string" then return nil end
        v = (v:gsub("[^%w]", "")):upper()
        if #v < 6 then return nil end
        return v:sub(1, 180)
    end

    for _, nom in ipairs({ "gethwid", "get_hwid", "gethardwareid" }) do
        local f = rawget(getfenv(0), nom)
        if type(f) == "function" then
            local ok, v = pcall(f)
            if ok then
                local p = propreId(tostring(v))
                if p then SRC_MACHINE = "hw"; return p end
            end
        end
    end


    local cid
    pcall(function()
        cid = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
    end)
    local p = propreId(cid)
    if p then SRC_MACHINE = "client"; return p end

    SRC_MACHINE = "compte"
    return "UID" .. tostring(Moi.UserId)
end

local function nomExecuteur()
    local n = "inconnu"
    pcall(function()
        if type(identifyexecutor) == "function" then n = tostring(identifyexecutor())
        elseif type(getexecutorname) == "function" then n = tostring(getexecutorname()) end
    end)
    return n:sub(1, 60)
end

-- ============================================================================
--  7.  LA CLE
-- ============================================================================

local function relireCle()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return nil end
    local ok, k = pcall(function()
        if isfile(FICHIER) then return readfile(FICHIER) end
        return nil
    end)
    if not ok or type(k) ~= "string" then return nil end
    return propre(k)
end

local function retenirCle(k)
    if type(writefile) ~= "function" then return end
    pcall(function()
        if type(makefolder) == "function" then pcall(makefolder, "DxC") end
        writefile(FICHIER, k)
    end)
end

local function oublierCle()
    if type(delfile) == "function" then pcall(delfile, FICHIER) end
end

--  La fenetre. Identique a celle que le joueur connait deja.
local function demanderCle(messageInitial)
    local decide, saisie = false, nil

    local ok = pcall(function()
        local parent
        if type(gethui) == "function" then
            local o, h = pcall(gethui)
            if o and h then parent = h end
        end
        parent = parent or Moi:FindFirstChildOfClass("PlayerGui") or Moi:WaitForChild("PlayerGui", 15)

        local ROUGE = Color3.fromRGB(198, 30, 42)
        local VERT  = Color3.fromRGB(46, 168, 84)
        local PALE  = Color3.fromRGB(150, 145, 150)
        local avecLien = (LIEN_CLE ~= "")
        local HAUT = avecLien and 282 or 146

        local ecran = Instance.new("ScreenGui")
        ecran.Name = "DxC_Key"; ecran.ResetOnSpawn = false
        ecran.IgnoreGuiInset = true; ecran.DisplayOrder = 999999
        ecran.Parent = parent

        local cadre = Instance.new("Frame")
        cadre.Size = UDim2.fromOffset(300, HAUT)
        --  ANCRE AU CENTRE plutot qu'un decalage calcule a la main.
        --  C'est ce qui permet de grandir ou retrecir la fenetre sans qu'elle
        --  se decale : elle grandit autour de son milieu, pas vers le bas et
        --  la droite.
        cadre.AnchorPoint = Vector2.new(0.5, 0.5)
        cadre.Position = UDim2.fromScale(0.5, 0.5)
        cadre.BackgroundColor3 = Color3.fromRGB(18, 11, 13)
        cadre.BorderSizePixel = 0; cadre.Active = true; cadre.Draggable = true
        cadre.Parent = ecran
        Instance.new("UICorner", cadre).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", cadre).Color = ROUGE

        -- ================================================================
        --  S'ADAPTER A L'ECRAN
        -- ================================================================
        --  La fenetre etait dessinee en pixels fixes : 300 de large, tout
        --  place au pixel pres. Sur un ordinateur c'est parfait. Sur un
        --  telephone d'entree de gamme, elle sort de l'ecran ou devient
        --  illisible, et le joueur ne voit meme pas le bouton OPEN.
        --
        --  Deux problemes distincts, deux reponses :
        --
        --  1. LA TAILLE. Un UIScale sur le cadre : tout ce qu'il y a dedans
        --     suit, sans avoir a retoucher une seule position. On vise une
        --     largeur confortable par rapport a l'ecran, jamais plus de
        --     neuf dixiemes de sa largeur ni de huit dixiemes de sa hauteur.
        --
        --  2. LE CLAVIER VIRTUEL. C'est LUI le vrai coupable sur telephone :
        --     des que le joueur touche la case, Roblox fait monter le clavier
        --     qui recouvre la moitie basse -- donc la case elle-meme et le
        --     bouton OPEN. Une fenetre centree est toujours cachee. On la
        --     remonte donc au tiers superieur sur ecran tactile.
        local echelleUI = Instance.new("UIScale")
        echelleUI.Parent = cadre

        --  Le reglage du joueur, entre 0.6 et 2.2. On s'en souvient d'une
        --  partie a l'autre quand l'executeur sait ecrire un fichier -- et
        --  s'il ne sait pas, ce n'est pas grave : on repart du calcul
        --  automatique, qui est deja bon.
        local FICHIER_TAILLE = "DxC_taille.txt"
        local reglageJoueur = nil
        if type(readfile) == "function" and type(isfile) == "function" then
            local okL, brut = pcall(function()
                if isfile(FICHIER_TAILLE) then return readfile(FICHIER_TAILLE) end
                return nil
            end)
            if okL and brut then reglageJoueur = tonumber(brut) end
        end

        local function ajusterEcran()
            local cam = workspace.CurrentCamera
            local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)

            --  Un ecran tactile etroit merite une fenetre plus grande EN
            --  PROPORTION : sur un telephone on tient l'appareil plus pres,
            --  mais les doigts sont plus gros que le curseur d'une souris.
            local vise = 300
            if vp.X < 700 then vise = math.min(vp.X * 0.9, 340) end

            local auto = vise / 300
            --  On ne depasse jamais l'ecran, quel que soit le reglage.
            local maxLarge = (vp.X * 0.92) / 300
            local maxHaut  = (vp.Y * 0.80) / HAUT
            local plafond  = math.min(maxLarge, maxHaut)

            local voulu = reglageJoueur or auto
            echelleUI.Scale = math.clamp(voulu, 0.6, math.max(0.6, plafond))

            --  Sur tactile, on remonte : le clavier virtuel mange le bas.
            local tactile = false
            local okT, sce = pcall(function() return game:GetService("UserInputService") end)
            if okT and sce then
                tactile = sce.TouchEnabled and not sce.KeyboardEnabled
            end

            --  ⛔ REMONTER, OUI. SORTIR DE L ECRAN, JAMAIS.
            --
            --  Le cadre est ancre en son MILIEU. Le poser a 0,32 de la hauteur
            --  remonte donc son milieu, et son haut monte deux fois plus vite.
            --  Tant qu il faisait 182 pixels ca passait ; a 282, sur un ecran
            --  tactile plus large que haut, le haut du cadre sortait -- avec la
            --  croix de fermeture et les boutons de taille, qui devenaient
            --  inatteignables. Le joueur se retrouvait devant une fenetre qu il
            --  ne pouvait ni fermer ni redimensionner.
            --
            --  On borne donc la position par la demi-hauteur REELLE (echelle
            --  comprise) : le cadre reste entier a l ecran quoi qu il arrive.
            local demi = ((HAUT * echelleUI.Scale) / 2) / math.max(1, vp.Y)
            local y = tactile and 0.32 or 0.5
            if demi < 0.48 then
                y = math.clamp(y, demi + 0.02, 1 - demi - 0.02)
            else
                y = 0.5
            end
            cadre.Position = UDim2.fromScale(0.5, y)
        end

        ajusterEcran()

        --  Le joueur tourne son telephone, ou change la taille de sa fenetre :
        --  on refait le calcul. Sans ca, l'ecran change et la fenetre reste
        --  posee de travers.
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                    pcall(ajusterEcran)
                end)
            end
        end)

        --  Les deux boutons de reglage, en haut a gauche. Discrets sur
        --  ordinateur, indispensables sur un telephone qu'on ne connait pas.
        local function boutonTaille(x, texte, pas)
            local b = Instance.new("TextButton")
            b.Position = UDim2.new(0, x, 0, 6); b.Size = UDim2.fromOffset(22, 22)
            b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold
            b.TextSize = 15; b.TextColor3 = PALE; b.Text = texte; b.Parent = cadre
            b.MouseButton1Click:Connect(function()
                reglageJoueur = math.clamp((reglageJoueur or echelleUI.Scale) + pas, 0.6, 2.2)
                ajusterEcran()
                if type(writefile) == "function" then
                    pcall(writefile, FICHIER_TAILLE, tostring(reglageJoueur))
                end
            end)
            return b
        end
        boutonTaille(6,  "-", -0.1)
        boutonTaille(28, "+",  0.1)

        local function label(x, y, w, h, txt, taille, couleur, police, gauche)
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Position = UDim2.new(0, x, 0, y); l.Size = UDim2.new(0, w, 0, h)
            l.Font = police or Enum.Font.Gotham; l.TextSize = taille
            l.TextColor3 = couleur; l.Text = txt
            if gauche then l.TextXAlignment = Enum.TextXAlignment.Left end
            l.Parent = cadre; return l
        end

        --  ================================================================
        --   LA FENETRE, VERSION « CLE GRATUITE EN AVANT »
        --  ================================================================
        --  ⛔ L ORDRE DES ELEMENTS EST UN CHOIX, PAS UNE MISE EN PAGE.
        --
        --  La quasi-totalite des gens qui voient cet ecran n ONT PAS de cle :
        --  c est leur premiere fois, ou celle d hier a expire. L ancienne
        --  version leur montrait d abord une case a remplir qu ils ne
        --  pouvaient pas remplir, et le bouton qui leur en donne une etait
        --  tout en bas. On inverse : le bouton d abord, la saisie ensuite.
        --
        --  Sans lien gratuit configure, on garde la forme courte d avant --
        --  il n y aurait rien a mettre en avant.
        local etat, boite, btn

        if avecLien then
            --  L anneau. Pas de police a glyphes ni d image : deux cadres et
            --  un trait. Ca s affiche partout, y compris sur les executeurs
            --  mobiles ou les caracteres speciaux rendent un carre vide.
            local rond = Instance.new("Frame")
            rond.Size = UDim2.fromOffset(40, 40); rond.Position = UDim2.new(0.5, -20, 0, 24)
            rond.BackgroundColor3 = Color3.fromRGB(13, 40, 24); rond.BorderSizePixel = 0
            rond.Parent = cadre
            Instance.new("UICorner", rond).CornerRadius = UDim.new(1, 0)
            local anneau = Instance.new("UIStroke", rond)
            anneau.Color = VERT; anneau.Thickness = 1

            local trou = Instance.new("Frame")
            trou.Size = UDim2.fromOffset(9, 9); trou.Position = UDim2.new(0.5, -4.5, 0, 11)
            trou.BackgroundColor3 = Color3.fromRGB(62, 207, 122); trou.BorderSizePixel = 0
            trou.Parent = rond
            Instance.new("UICorner", trou).CornerRadius = UDim.new(1, 0)

            local tige = Instance.new("Frame")
            tige.Size = UDim2.fromOffset(3, 10); tige.Position = UDim2.new(0.5, -1.5, 0, 19)
            tige.BackgroundColor3 = Color3.fromRGB(62, 207, 122); tige.BorderSizePixel = 0
            tige.Parent = rond

            label(0, 72, 300, 18, "Key required", 15, Color3.fromRGB(232, 230, 231), Enum.Font.GothamMedium)
            label(0, 92, 300, 14, "Free, takes about a minute", 11, PALE)

            local free = Instance.new("TextButton")
            free.Position = UDim2.new(0, 16, 0, 114); free.Size = UDim2.new(1, -32, 0, 34)
            free.BackgroundColor3 = VERT; free.BorderSizePixel = 0
            free.Font = Enum.Font.GothamBold; free.TextSize = 13
            free.TextColor3 = Color3.fromRGB(4, 36, 26); free.Text = "Get my key"
            free.Parent = cadre
            Instance.new("UICorner", free).CornerRadius = UDim.new(0, 8)

            local trait = Instance.new("Frame")
            trait.Position = UDim2.new(0, 16, 0, 162); trait.Size = UDim2.new(1, -32, 0, 1)
            trait.BackgroundColor3 = Color3.fromRGB(38, 32, 31); trait.BorderSizePixel = 0
            trait.Parent = cadre

            label(16, 170, 268, 13, "already have one?", 11, PALE, nil, true)

            boite = Instance.new("TextBox")
            boite.Position = UDim2.new(0, 16, 0, 188); boite.Size = UDim2.new(1, -32, 0, 30)
            boite.BackgroundColor3 = Color3.fromRGB(30, 26, 25); boite.BorderSizePixel = 0
            boite.Font = Enum.Font.Code; boite.TextSize = 14
            boite.TextColor3 = Color3.fromRGB(235, 235, 240)
            boite.PlaceholderText = "XXXXXX-XXXXXX-XXXXXX-XXXXXX"; boite.Text = ""
            boite.ClearTextOnFocus = false; boite.Parent = cadre
            Instance.new("UICorner", boite).CornerRadius = UDim.new(0, 6)

            etat = label(16, 221, 268, 13, messageInitial or "", 11, PALE, nil, true)

            btn = Instance.new("TextButton")
            btn.Position = UDim2.new(0, 16, 0, 238); btn.Size = UDim2.new(1, -32, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(30, 26, 25); btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamBold; btn.TextSize = 13
            btn.TextColor3 = Color3.fromRGB(232, 230, 231); btn.Text = "Open"; btn.Parent = cadre
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local bord = Instance.new("UIStroke", btn)
            bord.Color = Color3.fromRGB(58, 50, 48); bord.Thickness = 1

            free.MouseButton1Click:Connect(function()
                if copierLien(LIEN_CLE) then
                    etat.TextColor3 = VERT
                    etat.Text = "Link copied - paste it in your browser"
                else
                    --  Pas de presse-papier du tout. Un TextLabel de 268 pixels
                    --  ne se selectionne pas et ne se deroule pas : l adresse y
                    --  serait tronquee et illisible. On la met dans la CASE, qui
                    --  elle se selectionne -- le joueur la copie a la main.
                    boite.Text = LIEN_CLE
                    etat.TextColor3 = PALE
                    etat.Text = "Copy the link above and open it in your browser"
                end
            end)
        else
            label(0, 12, 300, 20, "DXC HUB", 15, Color3.fromRGB(232, 230, 231), Enum.Font.GothamBold)
            label(0, 33, 300, 14, "enter your key to open the menu", 11, PALE)

            boite = Instance.new("TextBox")
            boite.Position = UDim2.new(0, 16, 0, 52); boite.Size = UDim2.new(1, -32, 0, 30)
            boite.BackgroundColor3 = Color3.fromRGB(30, 26, 25); boite.BorderSizePixel = 0
            boite.Font = Enum.Font.Code; boite.TextSize = 14
            boite.TextColor3 = Color3.fromRGB(235, 235, 240)
            boite.PlaceholderText = "XXXXXX-XXXXXX-XXXXXX-XXXXXX"; boite.Text = ""
            boite.ClearTextOnFocus = false; boite.Parent = cadre
            Instance.new("UICorner", boite).CornerRadius = UDim.new(0, 6)

            etat = label(16, 85, 268, 13, messageInitial or "", 11, PALE, nil, true)

            btn = Instance.new("TextButton")
            btn.Position = UDim2.new(0, 16, 0, 100); btn.Size = UDim2.new(1, -32, 0, 30)
            btn.BackgroundColor3 = ROUGE; btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamBold; btn.TextSize = 13
            btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = "Open"; btn.Parent = cadre
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        end

        local fermer = Instance.new("TextButton")
        fermer.Position = UDim2.new(1, -28, 0, 6); fermer.Size = UDim2.fromOffset(22, 22)
        fermer.BackgroundTransparency = 1; fermer.Font = Enum.Font.GothamBold
        fermer.TextSize = 15; fermer.TextColor3 = PALE; fermer.Text = "X"; fermer.Parent = cadre

        local function valider()
            local k = propre(boite.Text)
            if #k < 4 then
                etat.TextColor3 = Color3.fromRGB(240, 90, 100)
                etat.Text = "key too short"
                return
            end
            saisie = k
            pcall(function() ecran:Destroy() end)
            decide = true
        end

        btn.MouseButton1Click:Connect(valider)
        boite.FocusLost:Connect(function(entree) if entree then valider() end end)
        fermer.MouseButton1Click:Connect(function()
            pcall(function() ecran:Destroy() end); saisie = nil; decide = true
        end)
    end)

    --  Si la fenetre n'a pas pu s'afficher, on REFUSE. L'ancienne porte
    --  laissait passer dans ce cas, et il suffisait donc de casser
    --  Instance.new pour entrer sans cle.
    if not ok then
        dire("could not show the key window - aborting", 8)
        return nil
    end

    local debut = os.clock()
    while not decide do
        task.wait(0.05)
        if os.clock() - debut > 300 then return nil end
    end
    return saisie
end

-- ============================================================================
--  8.  LE RUNTIME  --  ce qui permet d'arreter le script en pleine partie
-- ============================================================================
--  Couper une cle doit ejecter le joueur MAINTENANT, pas au prochain
--  lancement. Encore faut-il pouvoir vraiment tout arreter.
--
--  Cacher le menu ne suffit pas : les boucles de farm continueraient de tourner
--  sans interface pour les arreter -- c'est PIRE que de ne rien faire, le
--  joueur ne peut meme plus s'en debarrasser.
--
--  Le filet generique est simple : dans l'environnement du script protege,
--  `task.wait` leve une erreur des que la revocation tombe. Or toute boucle de
--  jeu attend, forcement, sinon elle gele le client. Donc toutes les boucles
--  meurent a leur prochaine attente, meme celles qu'on ne connait pas. On y
--  ajoute l'annulation directe des fils lances et la destruction des objets
--  crees.

local RT = {
    vivant = true,
    fils = {},
    --  Les liaisons que NOUS posons (pas celles du script). Une liaison qui
    --  survit a la revocation continue de tourner apres que tout le reste est
    --  arrete : c'est le genre de reste qui ne se voit pas et qui finit par
    --  peser. On les range pour pouvoir toutes les couper.
    liens = {},
    origine = {},
}

--  On releve l'etat du personnage AVANT que le script n'y touche. C'est la
--  seule facon de le rendre tel qu'il etait : une fois le menu lance, les
--  valeurs d'origine sont perdues et personne ne les a notees.
pcall(function()
    local perso = Moi.Character or Moi.CharacterAdded:Wait()
    local hum = perso and perso:FindFirstChildOfClass("Humanoid")
    if hum then
        RT.origine.walk = hum.WalkSpeed
        RT.origine.jump = hum.JumpPower
        RT.origine.useJump = hum.UseJumpPower
    end
    local cam = workspace.CurrentCamera
    if cam then RT.origine.fov = cam.FieldOfView end
end)

function RT.suivreFil(co) table.insert(RT.fils, co) end
function RT.suivreLien(c) table.insert(RT.liens, c) end

function RT.tuer(raison)
    if not RT.vivant then return end

    --  0. PREVENIR D'ABORD. Les menus de ces scripts ont tous une fonction de
    --     notification qui cesse de repondre des que le dechargement commence.
    --     On passe donc par la notification du jeu, qui ne depend de rien, et
    --     on le fait AVANT de casser quoi que ce soit.
    dire(raison or "access removed", 10)

    RT.vivant = false

    --  1. NEUTRALISER LES ACCROCHES AVANT TOUT LE RESTE.
    --     Certains scripts posent un hook sur __namecall, c'est-a-dire sur
    --     CHAQUE appel de methode du jeu -- des milliers par seconde. Ce hook
    --     ne se retire pas : la seule facon de l'eteindre est de baisser le
    --     drapeau qu'il consulte. L'oublier laisserait le joueur avec un hook
    --     actif sur tout le jeu pour le reste de sa session, longtemps apres
    --     que le menu a disparu.
    pcall(function()
        local g = getgenv()
        for _, nom in ipairs({ "DxC_AB", "DxC_Hook" }) do
            local t = rawget(g, nom)
            if type(t) == "table" then
                t.active = false
                --  On ne touche PAS a t.hooked : le remettre a faux ferait
                --  empiler une deuxieme couche de hook au prochain lancement.
                t.learn = nil       -- cette fermeture retenait tout le script en memoire
            end
        end
    end)

    --  2. Les arrets propres que le script expose lui-meme, s'il en a.
    --     Ordre impose : ne JAMAIS poser Library.Unloaded a la main avant
    --     d'appeler Unload. Sur au moins un des scripts, Unload commence par
    --     tester ce drapeau et sort immediatement s'il est deja leve : le menu
    --     paraitrait mort tout en continuant a peindre et a consommer.
    pcall(function()
        local g = getgenv()
        for _, nom in ipairs({ "DxC_FishBait", "DxC_Keyboard", "DxC_Gakuran",
                               "DxC_ChickenFarm", "DxC_Billionaire" }) do
            local t = rawget(g, nom)
            if type(t) == "table" and type(t.fermer) == "function" then pcall(t.fermer) end
        end

        --  L'arret complet que le script s'est ecrit pour lui-meme. Il en sait
        --  bien plus long que nous : il connait le nom tire au hasard de sa
        --  fenetre, les dessins qu'il a peints, les collisions qu'il a
        --  coupees. C'est l'epilogue ajoute en fin de script qui nous l'a
        --  tendu -- ces routines sont des variables locales, invisibles de
        --  l'exterieur, et c'est precisement pour ca que l'epilogue existe.
        if type(RT.arretPropre) == "function" then pcall(RT.arretPropre) end

        local lib = RT.bibliotheque
        if type(lib) ~= "table" then lib = rawget(g, "Library") end
        if type(lib) == "table" then
            if type(lib.Unload) == "function" then pcall(lib.Unload, lib) end
            lib.Unloaded = true          -- apres, jamais avant
        end
    end)

    --  3. LES LIAISONS DE RENDU. C'est le point le plus vicieux de tout
    --     l'arret, et celui qu'on oublie.
    --
    --     Le filet general du loader fait echouer toute ATTENTE : c'est ce qui
    --     tue les boucles de farm, qui attendent forcement. Mais une liaison de
    --     rendu n'attend jamais -- elle est rappelee par le moteur a chaque
    --     image. Elle survivrait donc entierement au filet.
    --
    --     Concretement, sans ces quatre lignes : le menu disparait, la vitesse
    --     revient a la normale, la notification s'affiche... et le personnage
    --     continue d'etre pilote a chaque image, les boites d'ESP continuent
    --     d'etre peintes, sans plus aucune interface pour les eteindre. C'est
    --     exactement le cas « pire que de ne rien faire » : le joueur ne peut
    --     meme plus s'en debarrasser autrement qu'en quittant la partie.
    --
    --     Les quatre noms sont releves dans les cinq scripts, pas devines.
    pcall(function()
        for _, nom in ipairs({ "DxC_pilote", "DxC_edit", "DxC_Camera", "DxC_Esp" }) do
            pcall(function() RunService:UnbindFromRenderStep(nom) end)
        end
    end)

    --  4. Les fils lances par le script.
    for _, co in ipairs(RT.fils) do
        pcall(function() task.cancel(co) end)
    end

    --  4 bis. Les liaisons que NOUS avons posees -- celle qui veille sur la
    --  taille du menu, notamment. Le script, lui, coupe les siennes tout seul
    --  a l'etape 2. Les notres n'appartiennent a personne d'autre : si on ne
    --  les coupe pas, elles restent branchees apres la revocation.
    for _, c in ipairs(RT.liens) do
        pcall(function() c:Disconnect() end)
    end

    --  4 ter. LE MODE FLUIDE. Si le joueur l'avait allume, on remet ses ombres,
    --  son eau et ses particules AVANT de partir. Le laisser avec un jeu tout
    --  plat apres une coupure, c'est lui faire croire qu'on a casse son jeu --
    --  et il n'aurait aucun moyen de le reparer, le bouton ayant disparu avec
    --  le reste.
    if type(RT.rendreLeJeu) == "function" then
        pcall(RT.rendreLeJeu)
    end

    --  5. Les interfaces. On ratisse tout ScreenGui dont le nom commence par
    --     DxC -- les etiquettes d'ESP notamment.
    --     A noter : le menu principal, lui, porte un nom TIRE AU HASARD -- on
    --     ne peut pas le retrouver par son nom, c'est Library:Unload() qui s'en
    --     charge a l'etape 2. D'ou l'importance de ne pas sauter cette etape.
    pcall(function()
        local endroits = { Moi:FindFirstChildOfClass("PlayerGui") }
        if type(gethui) == "function" then
            local o, h = pcall(gethui)
            if o and h then table.insert(endroits, h) end
        end
        for _, ou in ipairs(endroits) do
            if ou then
                for _, enfant in ipairs(ou:GetChildren()) do
                    if enfant:IsA("ScreenGui") and enfant.Name:sub(1, 3) == "DxC" then
                        enfant:Destroy()
                    end
                end
            end
        end
    end)

    --  6. Le personnage : on rend EXACTEMENT ce qu'on a pris.
    --
    --     Les scripts, eux, remettent des valeurs ecrites en dur (16 ici, 20
    --     la, 22 ailleurs) parce qu'ils sont chacun ecrits pour un seul jeu.
    --     Nous, on a releve les vraies valeurs avant de lancer quoi que ce
    --     soit : on rend celles-la.
    --
    --     Ce n'est pas de la coquetterie. Laisser un joueur avec une vitesse
    --     de course a 200 et un personnage qui traverse les murs, c'est le
    --     designer aupres du systeme anti-triche du jeu longtemps apres que le
    --     menu a disparu -- et il ne comprendrait meme pas pourquoi.
    pcall(function()
        local perso = Moi.Character
        local hum = perso and perso:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = RT.origine.walk or 16
            hum.JumpPower = RT.origine.jump or 50
            if RT.origine.useJump ~= nil then hum.UseJumpPower = RT.origine.useJump end
        end
        --  Le noclip : sans ca le joueur reste traversant.
        if perso then
            for _, part in ipairs(perso:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        --  Le champ de vision force chaque frame par certains ESP.
        local cam = workspace.CurrentCamera
        if cam and RT.origine.fov then cam.FieldOfView = RT.origine.fov end
    end)

    --  7. On efface nos traces dans les globales.
    --     `Toggles` et `Options` sont poses par la bibliotheque de menu et ne
    --     sont remis a nil par aucun des cinq scripts : ils resteraient en
    --     memoire jusqu'a la fermeture du jeu.
    pcall(function()
        local g = getgenv()
        for _, nom in ipairs({ "DxC_RT", "DxC_cles", "DxC_cleJoueur", "DxCKey",
                               "Toggles", "Options" }) do
            rawset(g, nom, nil)
        end
    end)
end

--  La preuve remise au script protege. Elle sert a une seule chose, mais une
--  chose utile : un fichier en clair, arrache par quelqu'un qui a dechiffre sa
--  session, ne demarre pas tout seul. Il faut d'abord lui retirer sa tete --
--  c'est faisable, mais ca demande de comprendre le code, pas juste de le
--  copier. C'est une couche de plus, pas une muraille, et elle est presentee
--  comme telle.
function RT.preuveDe(sel)
    if not RT.vivant then return "" end
    return "";      -- remplacee juste apres, une fois le masque connu
end

pcall(function() getgenv().DxC_RT = RT end)

-- ============================================================================
--  9.  LE DEROULEMENT
-- ============================================================================

local function echouer(message)
    dire(message, 10)
    --  On eteint le runtime AVANT de lever l'erreur. Sans ca, un abandon
    --  survenu apres le lancement du battement laisserait un fil qui continue
    --  d'interroger le serveur toutes les 45 secondes jusqu'a la fermeture du
    --  jeu -- pour une session qui n'existe plus. Invisible, et ca consomme le
    --  quota de tout le monde.
    RT.vivant = false
    error("[DxC] " .. message, 0)
end

--  9.1  Les capacites indispensables. On refuse tot et clairement plutot que
--       d'echouer plus tard avec un message incomprehensible.
if not CAP.loadstring then
    echouer("your executor has no loadstring - the script cannot run")
end
if not CAP.bit32 then
    echouer("your executor has no bit32 - the script cannot be decrypted")
end
if not CAP.buffer then
    echouer("your executor has no buffer library - decrypting would freeze the game")
end

--  9.2  La transparence binaire. Le code brouille ressemble a du bruit : plein
--       d'octets nuls, plein de sequences UTF-8 invalides. Certains executeurs
--       abiment ce genre de chaine sans prevenir. On pose la question en 256
--       octets plutot que de le decouvrir sur un joueur.
do
    local r, e = appeler({ Url = SERVEUR .. "/v1/probe", Method = "GET" }, 20)
    local corps = corpsDe(r)
    local statut = statutDe(r)

    if not corps then
        echouer("server unreachable (" .. tostring(e) .. ")")
    end
    --  On distingue « le serveur va mal » de « cet executeur abime les
    --  donnees ». Accuser l'executeur du joueur alors que c'est le serveur qui
    --  renvoie une page d'erreur, c'est l'envoyer chercher pendant une heure
    --  du cote ou il n'y a rien.
    if statut ~= 200 and statut ~= 0 then
        echouer("server error (code " .. tostring(statut) .. ")")
    end
    if #corps ~= 256 then
        echouer(("unexpected response size (%d bytes instead of 256). "):format(#corps)
            .. "If the server is fine, your executor is corrupting binary data.")
    end
    for i = 0, 255 do
        if corps:byte(i + 1) ~= i then
            echouer("your executor corrupts binary data (byte " .. i .. ")")
        end
    end
end

--  9.3  La cle : d'abord celle qu'on a retenue, sinon la fenetre.
local cle = nil
do
    local posee
    pcall(function()
        local g = getgenv()
        posee = propre(rawget(g, "DxC_cleJoueur") or rawget(g, "DxCKey") or "")
    end)
    if posee and #posee >= 4 then cle = posee end
    if not cle then
        local retenue = relireCle()
        if retenue and #retenue >= 4 then cle = retenue end
    end
    if not cle then
        cle = demanderCle("")
        if not cle then return end          -- fenetre fermee : on s'arrete, sans bruit
    end
end

--  9.4  La poignee de main. On peut y revenir si la cle est refusee.
local rep, otp
for essai = 1, 3 do
    local cn = ("%08x%08x"):format(math.random(0, 0xFFFFFFF), math.random(0, 0xFFFFFFF))
    local ts = os.time()
    local kid = empreinte("DxCid1|" .. cle):sub(1, 16)
    local khash = empreinte("DxC1|" .. cle)
    local auth = empreinte(table.concat({ "auth1", khash, cn, tostring(ts), SCRIPT }, "\31")):sub(1, 32)

    local hwid = identiteMachine()
    local reponse, err = postJson("/v1/session", {
        v = 1, lv = VERSION, kid = kid, sid = SCRIPT, hwid = hwid,
        --  D ou vient l identite : hw / fichier / client / compte. Sert au
        --  proprietaire dans /admin : un joueur identifie par son COMPTE
        --  changera de machine des qu il changera de compte, et c est la
        --  seule facon de le voir avant qu il ouvre un ticket.
        hwsrc = SRC_MACHINE,
        uid = Moi.UserId, pid = ("%d"):format(game.PlaceId),
        cn = cn, ts = ts, auth = auth, exe = nomExecuteur(),
    })

    if not reponse then
        echouer("server unreachable (" .. tostring(err) .. ")")
    end

    if reponse.ok then
        rep = reponse
        --  Le masque de session. Le serveur le calcule de son cote avec la
        --  meme recette : si les deux ne tombent pas d'accord, rien ne se
        --  dechiffre. C'est verifie par les vecteurs du banc.
        otp = empreinte(table.concat({ khash, hwid, cn, reponse.sn, SCRIPT,
                                       tostring(reponse.ts), reponse.jti }, "|"))
        retenirCle(cle)
        break
    end

    local err_ = tostring(reponse.err or "?")
    if err_ == "KEY_UNKNOWN" then
        oublierCle()
        if essai == 3 then echouer("key refused") end
        cle = demanderCle("wrong key")
        if not cle then return end
    elseif err_ == "KEY_REVOKED" then
        oublierCle(); echouer("this key has been revoked")
    elseif err_ == "KEY_EXPIRED" then
        oublierCle(); echouer("this key has expired")
    elseif err_ == "SLOTS_FULL" then
        echouer("this key is already used on " .. tostring(reponse.slots) ..
                " device(s). Ask for a reset.")
    elseif err_ == "WRONG_PLACE" then
        echouer("this script is not made for this game")
    elseif err_ == "CLOCK_SKEW" then
        echouer("your device clock is off - fix the date and time")
    elseif err_ == "MAINTENANCE" then
        echouer("maintenance in progress - try again in a moment")
    elseif err_ == "TOO_MANY_LOADS" then
        echouer("too many launches today with this key")
    elseif err_ == "LOADER_OLD" then
        echouer("this loader is outdated - get the latest line")
    else
        echouer("refused by the server (" .. err_ .. ")")
    end
end

if rep.motd and rep.motd ~= "" then dire(rep.motd, 10) end

--  ⛔ COMBIEN DE TEMPS IL LUI RESTE -- ET SEULEMENT A CELUI QUI A PAYE.
--
--  Une cle gratuite dure vingt-quatre heures et la page web le lui a deja dit
--  en clair. Le lui repeter a chaque lancement n apprend rien et transforme
--  une notification utile en bruit qu on cesse de lire.
--
--  Une cle nominative, elle, a ete achetee : son porteur veut savoir quand
--  elle finit, et il vaut mieux qu il l apprenne trois jours avant plutot que
--  le jour ou elle cesse de marcher.
--
--  ⚠ ON COMPTE AVEC L HORLOGE DU SERVEUR, PAS CELLE DU JOUEUR.
--  `rep.ts` vient de la meme reponse que `rep.expire` : la difference est donc
--  juste, meme si la machine du joueur est reglee de travers -- ce qui arrive.
if (rep.gratuite == 0 or rep.gratuite == nil)
   and type(rep.expire) == "number" and rep.expire > 0
   and type(rep.ts) == "number" then
    local reste = rep.expire - rep.ts
    if reste > 0 then
        local texte
        if reste >= 172800 then
            texte = math.floor(reste / 86400) .. " days left"
        elseif reste >= 3600 then
            texte = math.floor(reste / 3600) .. " h left"
        else
            texte = "less than an hour left"
        end
        dire("your key: " .. texte, 7)
    end
end

--  9.5  Le battement de coeur. Il part AVANT le telechargement : si la cle est
--       coupee pendant qu'on telecharge, on doit le savoir.
local BATTRE = { jeton = rep.beat, kbeat = otp:sub(33, 64), intervalle = rep.beat_interval or 45 }

--  Maintenant que le masque est connu, la preuve devient calculable. Le script
--  protege demandera la reponse a un sel qu'il est seul a connaitre.
function RT.preuveDe(sel)
    if not RT.vivant then return "" end
    return empreinte(otp .. "|payload|" .. tostring(sel)):sub(1, 32)
end

local function verifierOrdre(r)
    --  On ne croit un ordre d'arret que s'il est signe avec la cle de session.
    --  Sans ca, n'importe qui pourrait repondre « tu es coupe » et ejecter un
    --  joueur honnete. Le canon a une composition FIXE : six champs, toujours
    --  les six, sinon les deux cotes ne calculent pas la meme chose et l'ordre
    --  serait ignore alors qu'il est authentique.
    if type(r) ~= "table" or type(r.sig) ~= "string" then return nil end
    local canon = table.concat({
        "dxc1", rep.jti, r.live and "1" or "0",
        tostring(r.why or "none"), tostring(r.ts or ""), tostring(r.next or ""),
    }, "\31")
    local attendu = empreinte(BATTRE.kbeat .. "\31" .. canon .. "\31" .. BATTRE.kbeat):sub(1, 32)
    if attendu ~= r.sig then return nil end
    return r
end

local SOFT = rep.soft_warn or 180
local HARD = rep.hard_kill or 1800

--  ANTI-DUMP : ce que la detection a vu AU MOMENT ou le corps est expose (le
--  loadstring plus bas). C'est l'instant qui compte : un dumpeur accroche pour
--  capturer, puis se debranche parfois aussitot -- le battement, lui, ne passe
--  que toutes les cinq secondes et raterait ce hook fugace. On le fige ici, et
--  le battement le porte des qu'il tourne.
local alerteDump = nil

task.spawn(function()
    local dernierOk = os.clock()
    local prevenu = false

    while RT.vivant do
        task.wait(BATTRE.intervalle + math.random(-5, 5))
        if not RT.vivant then return end

        --  On glisse l'alerte anti-dump dans le battement. detecterDump() rend
        --  nil quand tout va bien : la cle n'apparait alors pas dans le JSON, et
        --  le serveur ne voit rien. Sinon le motif part et s'affiche dans /admin
        --  (le serveur dedoublonne par session, pas de flood).
        local r = postJson("/v1/beat", { beat = BATTRE.jeton, alerte = alerteDump or detecterDump() })
        local ordre = verifierOrdre(r)

        if ordre then
            dernierOk = os.clock()
            if prevenu then
                dire("connection restored", 5)
                prevenu = false
            end
            if ordre.next and ordre.next >= 10 then BATTRE.intervalle = ordre.next end
            if not ordre.live then
                RT.tuer(({
                    cle_revoquee  = "your key has been revoked",
                    cle_expiree   = "your key has expired",
                    cle_inconnue  = "unknown key",
                    session_close = "session ended",
                })[ordre.why] or "access removed")
                return
            end
        else
            --  Pas de reponse, ou reponse non signee. On ne conclut RIEN : le
            --  serveur peut etre tombe, le reseau peut hoqueter, quelqu'un peut
            --  avoir bloque le domaine. Aucun de ces cas ne prouve qu'une cle a
            --  ete coupee, et on ne punit pas un joueur honnete sur une
            --  supposition -- c'est la regle de ce fichier.
            --
            --  Mais la tolerance n'est pas infinie non plus, sinon il suffirait
            --  de bloquer le domaine pour jouer sans limite. On laisse donc une
            --  marge tres large -- assez pour traverser n'importe quelle panne
            --  reelle -- puis on s'arrete, en expliquant que c'est la connexion
            --  qui manque, pas la cle qui est mauvaise. La nuance compte : le
            --  joueur doit savoir qu'il lui suffit de relancer.
            local silence = os.clock() - dernierOk
            if silence > SOFT and not prevenu then
                prevenu = true
                dire(("server unreachable for %d min - the menu will stop in %d min")
                    :format(math.floor(silence / 60), math.max(1, math.floor((HARD - silence) / 60))), 10)
            end
            if silence > HARD then
                RT.tuer("server unreachable too long - relaunch when it responds")
                return
            end
        end
    end
end)

--  9.6  Le telechargement, part par part.
local jeton = rep.st
local morceaux = {}
for i = 0, rep.parts - 1 do
    local recu = nil
    for essai = 1, 3 do
        --  Le jeton passe par un en-tete quand c'est possible, et par
        --  l'adresse sinon : `game:HttpGet` n'accepte aucun en-tete, et sans
        --  ce repli le telechargement s'arreterait net sur ces executeurs.
        local url = SERVEUR .. "/v1/part?i=" .. i
        local entetes = { ["X-DxC-Session"] = jeton }
        if not poster then
            url = url .. "&g=1&st=" .. urlEnc(jeton)
            entetes = nil
        end
        local r = appeler({ Url = url, Method = "GET", Headers = entetes }, 40)
        local corps = corpsDe(r)
        if corps and #corps > 0 and statutDe(r) == 200 then
            local suivant = entete(r, "x-dxc-next")
            if suivant then jeton = suivant end
            recu = corps
            break
        end
        task.wait(1.5 * essai)
    end
    if not recu then
        echouer("download interrupted (part " .. i .. ")")
    end
    morceaux[#morceaux + 1] = recu
end

--  9.7  On remet les parts bout a bout, on retire la couche de session sur la
--       tete, puis on debrouille l'ensemble.
local chiffre = table.concat(morceaux)
morceaux = nil

if #chiffre ~= rep.total_len then
    echouer("unexpected size (" .. #chiffre .. " instead of " .. rep.total_len .. ")")
end

local buf = buffer.fromstring(chiffre)
chiffre = nil

do
    --  La tete d'abord : elle a ete rebrouillee pour cette session-la par le
    --  serveur. C'est ce qui rend inutile une reponse enregistree.
    local kh = {}
    do
        local recu = hexEnOctets(rep.khead or "")
        local masque = hexEnOctets(empreinte(otp .. "|h"):sub(1, 32))
        if #recu == 16 then
            for i = 1, 16 do kh[i] = bit32.bxor(recu[i], masque[i]) end
        end
    end
    if #kh == 16 then
        local nTete = math.min(rep.head_len or 8192, buffer.len(buf))
        local tete = buffer.create(nTete)
        buffer.copy(tete, 0, buf, 0, nTete)
        debrouiller(tete, kh)
        buffer.copy(buf, 0, tete, 0, nTete)
    end
end

local cleMasse = {}
do
    local masque = hexEnOctets(otp:sub(1, 32))
    local recu = hexEnOctets(rep.kbulk)
    for i = 1, 16 do cleMasse[i] = bit32.bxor(recu[i], masque[i]) end
end

debrouiller(buf, cleMasse)

local source = buffer.tostring(buf)
buf = nil

--  ANTI-DUMP : L'INSTANT CRITIQUE. `source` est maintenant le corps en clair,
--  sur le point d'etre passe a loadstring. C'est PILE ici qu'un dumpeur doit
--  avoir accroche loadstring pour capturer -- donc pile ici qu'on le voit, meme
--  s'il se rebranche apres. Le battement portera ce constat au serveur.
alerteDump = detecterDump() or alerteDump

--  9.8  On compile et on lance, dans un environnement ou `task.wait` refuse de
--       rendre la main une fois la revocation tombee. C'est ce qui garantit que
--       toutes les boucles s'arretent, y compris celles qu'on ne connait pas.
local f, err = loadstring(source, "=DxC/" .. SCRIPT)
source = nil
if not f then
    echouer("the received code does not compile (" .. tostring(err) .. ")")
end

do
    local env = getfenv(f)
    local vraiWait, vraiSpawn = task.wait, task.spawn
    local faux = setmetatable({
        task = setmetatable({
            wait = function(...)
                if not RT.vivant then error("[DxC] access removed", 0) end
                return vraiWait(...)
            end,
            spawn = function(fn, ...)
                local co = vraiSpawn(fn, ...)
                RT.suivreFil(co)
                return co
            end,
        }, { __index = task }),
        wait = function(...)
            if not RT.vivant then error("[DxC] access removed", 0) end
            return vraiWait(...)
        end,
    }, { __index = env })

    --  Si l'executeur ne sait pas remplacer l'environnement, on perd le filet
    --  general -- celui qui fait echouer toute attente et tue donc les boucles
    --  qu'on ne connait pas. On ne s'arrete pas pour autant : il reste l'arret
    --  propre du script (via l'epilogue), le retrait des liaisons de rendu, et
    --  le chien de garde du prelude. Mais on le NOTE, parce qu'un joueur chez
    --  qui la revocation est moins complete, c'est une information qui compte.
    RT.filetPose = (pcall(setfenv, f, faux) == true)
end

--  9.9  QUE LE MENU TIENNE DANS L'ECRAN, ET QUE LE JOUEUR EN SOIT MAITRE.
--
--  Les cinq scripts dessinent leur menu en pixels fixes : une largeur et une
--  hauteur pensees pour un ecran d'ordinateur. Sur un telephone d'entree de
--  gamme, le menu deborde des deux cotes -- categories coupees a gauche,
--  valeurs coupees a droite -- et le joueur ne peut rien regler.
--
--  POURQUOI C'EST FAIT ICI ET PAS DANS LES SCRIPTS.
--  Les cinq scripts font ensemble 1,7 Mo. Les retoucher un par un, c'est cinq
--  fois le risque de casser un menu qui marche, cinq re-obfuscations et cinq
--  republications. Le loader est UN fichier, il tourne avant eux, et une seule
--  correction couvre les cinq -- plus le sixieme le jour ou il arrivera.
--
--  COMMENT ON LES RECONNAIT SANS SE TROMPER.
--  Le menu porte un nom tire au hasard, mais les cinq le prefixent par « KE_ ».
--  Aucune interface de jeu ne s'appelle comme ca. On ne touche donc JAMAIS a
--  l'interface du jeu, seulement a celle qu'on a lancee nous-memes.
--
--  TROIS CHOSES, ET L'ORDRE COMPTE.
--  1. La mise a l'echelle automatique ne se fait QU'UNE FOIS, a l'ouverture.
--     Avant, elle se rejouait a chaque changement d'ecran et ecrasait le
--     reglage du joueur : il agrandissait, ca revenait tout seul.
--  2. Une POIGNEE en bas a droite, comme sur un ordinateur : on reste appuye
--     et on tire pour agrandir ou reduire. Le choix est retenu d'une partie a
--     l'autre.
--  3. Les barres de defilement font 3 a 6 pixels -- deux fois rien une fois le
--     menu retreci. Invisibles et impossibles a attraper au doigt. On les
--     epaissit sur ecran tactile, sans toucher a leur couleur : le script s'en
--     sert pour son reglage de transparence.
--
--  ON NE FAIT QUE RETRECIR au demarrage, jamais grandir. Sur un ordinateur le
--  calcul donne 1 et rien ne bouge, au pixel pres.
do
    local POSE    = "DxC_taille_menu"
    local FICHIER = "DxC_menu.txt"
    local UIS     = game:GetService("UserInputService")

    local tactile = false
    pcall(function() tactile = UIS.TouchEnabled and not UIS.KeyboardEnabled end)

    --  Le reglage du joueur, s'il en a deja pose un lors d'une partie
    --  precedente. Absent, on retombe sur le calcul automatique.
    local choix = nil
    pcall(function()
        if type(readfile) == "function" and type(isfile) == "function" and isfile(FICHIER) then
            choix = tonumber(readfile(FICHIER))
        end
    end)

    local function ecranDeJeu()
        local cam = workspace.CurrentCamera
        return (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    end

    --  Le plafond : ce qui rentre dans l'ecran. Il s'applique TOUJOURS, meme au
    --  choix du joueur -- sinon il agrandit, tourne son telephone, et le menu
    --  ressort de l'ecran sans qu'il comprenne pourquoi.
    local function plafondPour(l, h)
        local vp = ecranDeJeu()
        return math.min((vp.X * 0.96) / l, (vp.Y * 0.92) / h)
    end

    local function poserPoignee(cadre, ech, l, h)
        if cadre:FindFirstChild("DxC_poignee") then return end

        --  ON NE TIRE PLUS. ON TAPE.
        --
        --  Trois fois de suite, sur telephone, le menu a retreci alors que le
        --  joueur ne visait pas la poignee : une fois la barre de defilement
        --  (elle se terminait sous la poignee), une fois un slider (l etat
        --  "je tire" restait colle), une fois sans qu on sache. A chaque fois
        --  la reponse a ete de resserrer une condition ; a chaque fois c est
        --  revenu autrement.
        --
        --  La cause commune n est aucune des trois : c est le GESTE. Pour
        --  redimensionner en glissant, il faut ecouter TOUT l ecran
        --  (UserInputService.InputChanged) et retenir un etat entre le debut
        --  et la fin du geste. Or le menu est plein de glissements legitimes
        --  -- defilement, sliders, deplacement du panneau -- et au doigt ils
        --  commencent tous pareil. Un seul etat mal referme, et n importe quel
        --  glissement ailleurs redimensionne.
        --
        --  Deux boutons qu on TAPE n ont ni etat retenu ni ecoute globale.
        --  Roblox ne declenche Activated que si l appui ET le relachement ont
        --  lieu sur le bouton : un defilement qui passe par-dessus ne
        --  declenche rien. Il n y a plus rien a resserrer, et plus rien qui
        --  puisse rester colle.
        local t = tactile and 34 or 24

        local barre = Instance.new("Frame")
        barre.Name = "DxC_poignee"
        --  SOUS le coin bas-droit, alignee a droite : la rangee s etend vers
        --  la GAUCHE, donc elle reste dans la largeur du panneau. Posee a
        --  droite, elle sortait de l ecran des que le joueur collait son menu
        --  au bord.
        barre.AnchorPoint = Vector2.new(1, 0)
        barre.Position = UDim2.new(1, 0, 1, 6)
        barre.Size = UDim2.fromOffset(t * 2 + 4, t)
        barre.BackgroundTransparency = 1
        barre.ZIndex = 50
        barre.Parent = cadre

        local etiquette = Instance.new("TextLabel")
        etiquette.AnchorPoint = Vector2.new(1, 0.5)
        etiquette.Position = UDim2.new(0, -6, 0.5, 0)
        etiquette.Size = UDim2.fromOffset(54, t)
        etiquette.BackgroundTransparency = 1
        etiquette.Font = Enum.Font.Gotham
        etiquette.TextSize = 12
        etiquette.TextColor3 = Color3.fromRGB(210, 205, 210)
        etiquette.TextTransparency = 1
        etiquette.TextXAlignment = Enum.TextXAlignment.Right
        etiquette.Text = ""
        etiquette.ZIndex = 50
        etiquette.Parent = barre

        --  Le pourcentage s affiche une seconde puis s efface. Le jeton evite
        --  que l effacement d un tap eteigne l affichage du tap suivant.
        local jeton = 0
        local function annoncer()
            jeton = jeton + 1
            local mien = jeton
            etiquette.Text = tostring(math.floor(ech.Scale * 100 + 0.5)) .. "%"
            etiquette.TextTransparency = 0
            task.delay(1.1, function()
                for i = 0, 10 do
                    if mien ~= jeton then return end
                    etiquette.TextTransparency = i / 10
                    task.wait(0.03)
                end
            end)
        end

        local function bouton(signe, decalage)
            local b = Instance.new("TextButton")
            b.AnchorPoint = Vector2.new(1, 0)
            b.Position = UDim2.new(1, -decalage, 0, 0)
            b.Size = UDim2.fromOffset(t, t)
            b.BackgroundColor3 = Color3.fromRGB(34, 32, 36)
            b.BackgroundTransparency = 0.25
            b.BorderSizePixel = 0
            b.AutoButtonColor = true
            b.Font = Enum.Font.GothamBold
            b.TextSize = tactile and 18 or 15
            b.TextColor3 = Color3.fromRGB(215, 210, 215)
            b.Text = signe
            b.ZIndex = 50
            b.Parent = barre
            pcall(function()
                local coin = Instance.new("UICorner")
                coin.CornerRadius = UDim.new(0, 6)
                coin.Parent = b
            end)
            return b
        end

        local PAS = 0.1
        local function pousser(sens)
            --  On relit la taille du panneau au lieu de garder celle d il y a
            --  dix minutes : le script peut avoir redimensionne le sien.
            local lc, hc = cadre.Size.X.Offset, cadre.Size.Y.Offset
            if lc <= 0 then lc = l end
            if hc <= 0 then hc = h end
            local plafond = plafondPour(lc, hc)
            local vise = math.clamp(ech.Scale + sens * PAS, 0.45, math.max(0.45, plafond))
            --  Arrondi au centieme : sinon, apres un plafond a 0.87, les taps
            --  suivants donnent 0.97, 0.87, 0.77... et le joueur ne retombe
            --  jamais sur des valeurs rondes.
            vise = math.floor(vise * 100 + 0.5) / 100
            ech.Scale = vise
            choix = vise
            annoncer()
            if type(writefile) == "function" then
                pcall(writefile, FICHIER, tostring(vise))
            end
        end

        RT.suivreLien(bouton("-", t + 4).Activated:Connect(function() pousser(-1) end))
        RT.suivreLien(bouton("+", 0).Activated:Connect(function() pousser(1) end))
    end

    local function ajuster(cadre)
        --  Une taille en pixels, sinon on ne touche a rien : un cadre defini en
        --  proportion s'adapte deja, et le mettre a l'echelle le casserait.
        local l, h = cadre.Size.X.Offset, cadre.Size.Y.Offset
        if l <= 0 or h <= 0 then return end

        --  ⛔ SEULEMENT LE GRAND PANNEAU. PAS TOUT CE QUI TRAINE DANS L'ECRAN.
        --  On parcourt tous les enfants directs du ScreenGui du menu. Il n'y a
        --  pas que le panneau la-dedans : quand le joueur replie le menu, le
        --  script affiche une PILULE de 250 x 42 -- une petite barre avec un
        --  bouton rond qui sert justement a rouvrir.
        --
        --  Cette pilule recevait une poignee de redimensionnement comme les
        --  autres. Or la poignee est un TextButton pose en bas a droite, de
        --  40 x 40 au doigt, en ZIndex 50. Fais le calcul dans une pilule de
        --  250 x 42 : elle couvre x 207->247 et y -1->39. Le bouton rond, lui,
        --  occupe x 212->242 et y 6->36. IL EST ENTIEREMENT DESSOUS.
        --
        --  Et un bouton transparent reste cliquable : `BackgroundTransparency`
        --  ne desarme pas la detection, seul `Visible = false` le ferait. Le
        --  doigt tapait donc toujours la poignee, jamais la fleche, et le menu
        --  ne se rouvrait plus. Sur ordinateur la poignee ne fait que 26 px,
        --  elle laissait une mince bande vivante sur la gauche du bouton :
        --  d'ou l'impression que "ca marche sur PC" -- en visant bien.
        --
        --  Le panneau ne descend jamais sous 520 x 340 (miniL / miniH dans les
        --  six scripts), la pilule fait 250 x 42 : un seuil entre les deux les
        --  separe proprement, sans avoir a deviner leur nom.
        if l < 400 or h < 200 then return end

        local ech = cadre:FindFirstChild(POSE)
        local premiereFois = (ech == nil)
        if premiereFois then
            ech = Instance.new("UIScale")
            ech.Name = POSE
            ech.Parent = cadre
        end

        local plafond = plafondPour(l, h)
        if premiereFois then
            --  Le choix du joueur d'abord ; sinon on rentre dans l'ecran sans
            --  jamais grandir (1 sur un ordinateur, donc rien ne bouge).
            local vise = choix or math.min(1, plafond)
            ech.Scale = math.clamp(vise, 0.45, math.max(0.45, plafond))
            poserPoignee(cadre, ech, l, h)
        else
            --  REVERSIBLE. L ancienne version ne savait que RETRECIR : elle
            --  ramenait l echelle sous le plafond, et n y touchait plus
            --  jamais. Or sur telephone l ecran utile bouge tout le temps --
            --  barre du haut, clavier, rotation, encoche. Un plafond qui
            --  baissait une seconde gravait donc un menu plus petit POUR DE
            --  BON, et l evenement suivant le rapetissait encore. Le joueur
            --  voyait son menu fondre sans avoir rien touche : c est ca qu il
            --  signalait, pas la poignee.
            --
            --  On recalcule desormais depuis son SOUHAIT a chaque fois. Ecran
            --  retreci, le menu suit ; ecran revenu, le menu revient.
            local vise = choix or math.min(1, plafond)
            local cible = math.clamp(vise, 0.45, math.max(0.45, plafond))
            if math.abs(ech.Scale - cible) > 0.001 then ech.Scale = cible end
        end
    end

    --  Les barres de defilement, epaissies au doigt. On ne touche NI a la
    --  couleur NI a la transparence : le script s'en sert pour son reglage de
    --  transparence du menu, et deux mains sur le meme bouton finissent
    --  toujours par se gener.
    local function defilementAuDoigt(o)
        if not tactile then return end
        if not o:IsA("ScrollingFrame") then return end
        pcall(function()
            o.ScrollingEnabled = true
            o.Active = true
            if o.ScrollBarThickness < 10 then o.ScrollBarThickness = 10 end
            --  PAS de rebond elastique force. `Always` fait rebondir meme
            --  quand la liste tient entierement dans le cadre : au doigt, ca
            --  donne un clignotement permanent en haut et en bas de chaque
            --  categorie. `WhenScrollable` ne rebondit que s'il y a vraiment
            --  de quoi defiler -- c'est le comportement attendu.
            o.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
        end)
    end

    local function fouiller(o)
        pcall(function()
            for _, d in ipairs(o:GetDescendants()) do defilementAuDoigt(d) end
        end)
        RT.suivreLien(o.DescendantAdded:Connect(function(d)
            task.defer(function() pcall(defilementAuDoigt, d) end)
        end))
    end

    local function traiter(gui)
        if not gui:IsA("ScreenGui") then return end
        if gui.Name:sub(1, 3) ~= "KE_" then return end

        for _, enfant in ipairs(gui:GetChildren()) do
            if enfant:IsA("GuiObject") then pcall(ajuster, enfant) end
        end
        RT.suivreLien(gui.ChildAdded:Connect(function(enfant)
            if enfant:IsA("GuiObject") then
                task.defer(function() pcall(ajuster, enfant) end)
            end
        end))

        fouiller(gui)

        --  Le joueur tourne son telephone : on ne recalcule QUE si le menu ne
        --  rentre plus. Recalculer a chaque fois ecrasait son reglage.
        pcall(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            RT.suivreLien(cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                for _, enfant in ipairs(gui:GetChildren()) do
                    if enfant:IsA("GuiObject") then pcall(ajuster, enfant) end
                end
            end))
        end)
    end

    local endroits = {}
    pcall(function() if type(gethui) == "function" then endroits[#endroits + 1] = gethui() end end)
    pcall(function() endroits[#endroits + 1] = game:GetService("CoreGui") end)
    pcall(function() endroits[#endroits + 1] = Moi:FindFirstChildOfClass("PlayerGui") end)

    for _, ou in ipairs(endroits) do
        if ou then
            pcall(function()
                for _, enfant in ipairs(ou:GetChildren()) do pcall(traiter, enfant) end
            end)
            pcall(function()
                RT.suivreLien(ou.ChildAdded:Connect(function(enfant)
                    task.defer(function() pcall(traiter, enfant) end)
                end))
            end)
        end
    end
end

--  9.10  LE MODE FLUIDE, pour les vieux telephones.
--
--  Un telephone d'entree de gamme rame sur les jeux Roblox modernes : ombres,
--  particules, reflets de l'eau, qualite de rendu au maximum. Le joueur n'a
--  aucun moyen de baisser tout ca depuis le jeu.
--
--  ON REND EXACTEMENT CE QU'ON A PRIS. C'est la meme regle que pour le
--  personnage : on releve chaque valeur AVANT d'y toucher, et on la remet
--  telle quelle quand le joueur repasse en mode normal ou quand la cle est
--  coupee. Un joueur qui se retrouve avec un jeu sans eau ni ombres apres
--  avoir ferme le menu, c'est un joueur qui croit qu'on a casse son jeu.
--
--  POURQUOI UN BOUTON A NOUS ET PAS UNE LIGNE DANS TON MENU.
--  Les cinq scripts exposent `Toggles` et `Options` par getgenv(), mais PAS
--  `Library` -- la table qui sait fabriquer une option. Sans elle, impossible
--  d'ajouter une vraie ligne dans l'onglet Settings depuis ici. Le faire
--  proprement demanderait de modifier les cinq scripts, de les re-obfusquer et
--  de les republier. Le bouton ci-dessous marche sur les cinq tout de suite.
do
    local FICHIER = "DxC_fluide.txt"
    local Lumiere = game:GetService("Lighting")

    local avant, pose = {}, false
    local coupes = {}          -- ce qu'on a eteint, pour le rallumer

    local EFFETS = {
        ParticleEmitter = true, Trail = true, Smoke = true, Fire = true,
        Sparkles = true, Beam = true, Explosion = true,
    }

    local function relever()
        if avant.fait then return end
        avant.fait = true
        pcall(function()
            avant.ombres   = Lumiere.GlobalShadows
            avant.diffuse  = Lumiere.EnvironmentDiffuseScale
            avant.speculaire = Lumiere.EnvironmentSpecularScale
        end)
        pcall(function()
            local t = workspace.Terrain
            avant.vague   = t.WaterWaveSize
            avant.vitesse = t.WaterWaveSpeed
            avant.reflet  = t.WaterReflectance
        end)
        pcall(function()
            avant.qualite = settings().Rendering.QualityLevel
        end)
    end

    local function allumer()
        relever()
        pcall(function()
            Lumiere.GlobalShadows = false
            Lumiere.EnvironmentDiffuseScale = 0
            Lumiere.EnvironmentSpecularScale = 0
        end)
        pcall(function()
            local t = workspace.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
        end)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)

        --  Les effets, en rendant la main tres souvent : une grosse carte a des
        --  centaines de milliers d'objets, et un parcours d'un seul tenant
        --  gelerait le client -- exactement ce qu'on cherche a eviter.
        RT.suivreFil(task.spawn(function()
            local n = 0
            for _, o in ipairs(workspace:GetDescendants()) do
                if not RT.vivant or not pose then return end
                n = n + 1
                if n % 400 == 0 then task.wait() end
                local ok, cls = pcall(function() return o.ClassName end)
                if ok and EFFETS[cls] then
                    local okE, etait = pcall(function() return o.Enabled end)
                    if okE and etait then
                        coupes[#coupes + 1] = o
                        pcall(function() o.Enabled = false end)
                    end
                end
            end
        end))
    end

    local function eteindre()
        if not avant.fait then return end
        pcall(function()
            Lumiere.GlobalShadows = avant.ombres
            Lumiere.EnvironmentDiffuseScale = avant.diffuse
            Lumiere.EnvironmentSpecularScale = avant.speculaire
        end)
        pcall(function()
            local t = workspace.Terrain
            t.WaterWaveSize = avant.vague
            t.WaterWaveSpeed = avant.vitesse
            t.WaterReflectance = avant.reflet
        end)
        pcall(function()
            settings().Rendering.QualityLevel = avant.qualite
        end)
        for _, o in ipairs(coupes) do
            pcall(function() o.Enabled = true end)
        end
        coupes = {}
    end

    --  On l'expose pour que la coupure de la cle rende le jeu comme il etait.
    RT.rendreLeJeu = function() pose = false pcall(eteindre) end

    local function basculer(actif)
        pose = actif
        if actif then allumer() else eteindre() end
        if type(writefile) == "function" then
            pcall(writefile, FICHIER, actif and "1" or "0")
        end
    end

    --  LE BOUTON. Petit, deplacable, dans notre propre ecran : il ne touche a
    --  rien de ce que le jeu ou le script dessinent.
    pcall(function()
        local parent
        if type(gethui) == "function" then
            local o, h = pcall(gethui)
            if o and h then parent = h end
        end
        parent = parent or Moi:FindFirstChildOfClass("PlayerGui")
        if not parent then return end

        local ecran = Instance.new("ScreenGui")
        ecran.Name = "DxC_Fluide"; ecran.ResetOnSpawn = false
        ecran.IgnoreGuiInset = true; ecran.DisplayOrder = 999998
        ecran.Parent = parent

        local b = Instance.new("TextButton")
        --  Bord GAUCHE, a mi-hauteur : sur telephone, le bas-gauche porte le
        --  joystick et le bas-droit le bouton de saut. Le milieu du bord est
        --  la seule zone franchement libre.
        b.AnchorPoint = Vector2.new(0, 0.5)
        b.Position = UDim2.new(0, 6, 0.5, 0)
        b.Size = UDim2.fromOffset(52, 30)
        b.BackgroundColor3 = Color3.fromRGB(30, 20, 23)
        b.BackgroundTransparency = 0.25
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(150, 145, 150)
        b.Text = "FPS"
        b.Active = true
        b.Draggable = true
        b.Parent = ecran
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

        local function peindre()
            b.TextColor3 = pose and Color3.fromRGB(46, 168, 84)
                                or Color3.fromRGB(150, 145, 150)
            b.Text = pose and "FPS+" or "FPS"
        end

        --  Le choix de la partie precedente.
        pcall(function()
            if type(readfile) == "function" and type(isfile) == "function"
               and isfile(FICHIER) and readfile(FICHIER) == "1" then
                basculer(true)
            end
        end)
        peindre()

        RT.suivreLien(b.MouseButton1Click:Connect(function()
            basculer(not pose)
            peindre()
        end))
    end)
end

f()
