-- Sasware Bootstrapper
-- Routes and loads scripts for games.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local GlobalEnv = (typeof(getgenv) == "function" and getgenv()) or _G

local function GetLanguageCode()
    local Ok, Locale = pcall(function()
        return LocalizationService.RobloxLocaleId or LocalPlayer.LocaleId or "en-us"
    end)
    local Loc = (Ok and Locale) and tostring(Locale):lower() or "en-us"
    return string.sub(Loc, 1, 2)
end

local function Create(ClassName, Properties)
    local Inst = Instance.new(ClassName)
    for Prop, Val in pairs(Properties) do
        if Prop ~= "Parent" then
            Inst[Prop] = Val
        end
    end
    if Properties.Parent then
        Inst.Parent = Properties.Parent
    end
    return Inst
end

local Translations = {
    en = { title = "Choose a version", prompt = "Which version would you like to use?", paid = "Paid", free = "Free", env_error_title = "Environment Unsupported", env_error_issues_title = "Issues:", env_error_recommendations = "Recommended alternatives for your device:", env_error_no_alternatives = "No alternative list available.", unsupported_title = "Unsupported Game", unsupported_heading = "This game is not supported yet.", unsupported_line1 = "Sasware only works in some games.", unsupported_line2 = "The game you are in right now is not on the supported list.", unsupported_what_you_can_do = "What you can do", unsupported_do_join = "Join one of the supported games below.", unsupported_do_ask = "Or ask Sasware staff to add this game.", unsupported_supported_games = "Supported games:", load_error = "Error loading script: " },
    es = { title = "Elige una versión", prompt = "¿Qué versión te gustaría usar?", paid = "De pago", free = "Gratis", env_error_title = "Entorno no compatible", env_error_issues_title = "Problemas:", env_error_recommendations = "Alternativas recomendadas para tu dispositivo:", env_error_no_alternatives = "No hay una lista de alternativas disponible.", unsupported_title = "Juego no compatible", unsupported_heading = "Este juego aún no es compatible.", unsupported_line1 = "Sasware solo funciona en algunos juegos.", unsupported_line2 = "El juego en el que estás ahora no está en la lista de compatibles.", unsupported_what_you_can_do = "Qué puedes hacer", unsupported_do_join = "Únete a uno de los juegos compatibles de abajo.", unsupported_do_ask = "O pide al equipo de Sasware que añada este juego.", unsupported_supported_games = "Juegos compatibles:", load_error = "Error al cargar el script: " },
    fr = { title = "Choisir une version", prompt = "Quelle version souhaitez-vous utiliser ?", paid = "Payante", free = "Gratuite", env_error_title = "Environnement non pris en charge", env_error_issues_title = "Problèmes :", env_error_recommendations = "Alternatives recommandées pour votre appareil :", env_error_no_alternatives = "Aucune liste d'alternatives disponible.", unsupported_title = "Jeu non pris en charge", unsupported_heading = "Ce jeu n'est pas encore pris en charge.", unsupported_line1 = "Sasware ne fonctionne que dans certains jeux.", unsupported_line2 = "Le jeu dans lequel vous êtes actuellement n'est pas dans la liste des jeux pris en charge.", unsupported_what_you_can_do = "Ce que vous pouvez faire", unsupported_do_join = "Rejoignez l'un des jeux pris en charge ci-dessous.", unsupported_do_ask = "Ou demandez à l'équipe Sasware d'ajouter ce jeu.", unsupported_supported_games = "Jeux pris en charge :", load_error = "Erreur de chargement du script : " },
    de = { title = "Version auswählen", prompt = "Welche Version möchten Sie verwenden?", paid = "Kostenpflichtig", free = "Kostenlos", env_error_title = "Umgebung wird nicht unterstützt", env_error_issues_title = "Probleme:", env_error_recommendations = "Empfohlene Alternativen für Ihr Gerät:", env_error_no_alternatives = "Keine Liste mit Alternativen verfügbar.", unsupported_title = "Nicht unterstütztes Spiel", unsupported_heading = "Dieses Spiel wird noch nicht unterstützt.", unsupported_line1 = "Sasware funktioniert nur in manchen Spielen.", unsupported_line2 = "Das Spiel, in dem Sie sich gerade befinden, steht nicht auf der Unterstützungsliste.", unsupported_what_you_can_do = "Was Sie tun können", unsupported_do_join = "Treten Sie einem der unten aufgeführten unterstützten Spiele bei.", unsupported_do_ask = "Oder bitten Sie das Sasware-Team, dieses Spiel hinzuzufügen.", unsupported_supported_games = "Unterstützte Spiele:", load_error = "Fehler beim Laden des Skripts: " },
    it = { title = "Scegli una versione", prompt = "Quale versione desideri usare?", paid = "A pagamento", free = "Gratis", env_error_title = "Ambiente non supportato", env_error_issues_title = "Problemi:", env_error_recommendations = "Alternative consigliate per il tuo dispositivo:", env_error_no_alternatives = "Nessun elenco di alternative disponibile.", unsupported_title = "Gioco non supportato", unsupported_heading = "Questo gioco non è ancora supportato.", unsupported_line1 = "Sasware funziona solo in alcuni giochi.", unsupported_line2 = "Il gioco in cui ti trovi ora non è nell'elenco di quelli supportati.", unsupported_what_you_can_do = "Cosa puoi fare", unsupported_do_join = "Unisciti a uno dei giochi supportati qui sotto.", unsupported_do_ask = "Oppure chiedi allo staff di Sasware di aggiungere questo gioco.", unsupported_supported_games = "Giochi supportati:", load_error = "Errore durante il caricamento dello script: " },
    pt = { title = "Escolha uma versão", prompt = "Qual versão você gostaria de usar?", paid = "Paga", free = "Grátis", env_error_title = "Ambiente não compatível", env_error_issues_title = "Problemas:", env_error_recommendations = "Alternativas recomendadas para o seu dispositivo:", env_error_no_alternatives = "Nenhuma lista de alternativas disponível.", unsupported_title = "Jogo não compatível", unsupported_heading = "Este jogo ainda não é compatível.", unsupported_line1 = "O Sasware funciona apenas em alguns jogos.", unsupported_line2 = "O jogo em que você está agora não está na lista de compatíveis.", unsupported_what_you_can_do = "O que você pode fazer", unsupported_do_join = "Entre em um dos jogos compatíveis abaixo.", unsupported_do_ask = "Ou peça à equipe do Sasware para adicionar este jogo.", unsupported_supported_games = "Jogos compatíveis:", load_error = "Erro ao carregar o script: " },
    ru = { title = "Выберите версию", prompt = "Какую версию вы хотите использовать?", paid = "Платная", free = "Бесплатная", env_error_title = "Среда не поддерживается", env_error_issues_title = "Проблемы:", env_error_recommendations = "Рекомендуемые альтернативы для вашего устройства:", env_error_no_alternatives = "Список альтернатив недоступен.", unsupported_title = "Игра не поддерживается", unsupported_heading = "Эта игра пока не поддерживается.", unsupported_line1 = "Sasware работает только в некоторых играх.", unsupported_line2 = "Игра, в которой вы сейчас находитесь, не входит в список поддерживаемых.", unsupported_what_you_can_do = "Что вы можете сделать", unsupported_do_join = "Присоединитесь к одной из поддерживаемых игр ниже.", unsupported_do_ask = "Или попросите команду Sasware добавить эту игру.", unsupported_supported_games = "Поддерживаемые игры:", load_error = "Ошибка загрузки скрипта: " },
    ja = { title = "バージョンを選択", prompt = "どのバージョンを使用しますか？", paid = "有料", free = "無料", env_error_title = "サポートされていない環境", env_error_issues_title = "問題:", env_error_recommendations = "お使いの端末に推奨される代替エグゼキュータ:", env_error_no_alternatives = "利用可能な代替リストはありません。", unsupported_title = "未対応のゲーム", unsupported_heading = "このゲームはまだサポートされていません。", unsupported_line1 = "Sasware は一部のゲームでのみ動作します。", unsupported_line2 = "現在プレイしているゲームはサポート対象に含まれていません。", unsupported_what_you_can_do = "できること", unsupported_do_join = "下のサポートされているゲームのいずれかに参加してください。", unsupported_do_ask = "または Sasware スタッフにこのゲームの追加を依頼してください。", unsupported_supported_games = "サポートされているゲーム:", load_error = "スクリプトの読み込みエラー: " },
    ko = { title = "버전 선택", prompt = "어떤 버전을 사용하시겠습니까?", paid = "유료", free = "무료", env_error_title = "지원되지 않는 환경", env_error_issues_title = "문제:", env_error_recommendations = "기기에 추천되는 대체 실행기:", env_error_no_alternatives = "사용 가능한 대체 목록이 없습니다.", unsupported_title = "지원되지 않는 게임", unsupported_heading = "이 게임은 아직 지원되지 않습니다.", unsupported_line1 = "Sasware는 일부 게임에서만 작동합니다.", unsupported_line2 = "현재 접속한 게임은 지원 목록에 없습니다.", unsupported_what_you_can_do = "할 수 있는 일", unsupported_do_join = "아래 지원되는 게임 중 하나에 접속하세요.", unsupported_do_ask = "또는 Sasware 팀에 이 게임 추가를 요청하세요.", unsupported_supported_games = "지원되는 게임:", load_error = "스크립트 로딩 오류: " },
    tr = { title = "Bir sürüm seçin", prompt = "Hangi sürümü kullanmak istersiniz?", paid = "Ücretli", free = "Ücretsiz", env_error_title = "Ortam desteklenmiyor", env_error_issues_title = "Sorunlar:", env_error_recommendations = "Cihazınız için önerilen alternatifler:", env_error_no_alternatives = "Kullanılabilir alternatif listesi yok.", unsupported_title = "Desteklenmeyen oyun", unsupported_heading = "Bu oyun henüz desteklenmiyor.", unsupported_line1 = "Sasware yalnızca bazı oyunlarda çalışır.", unsupported_line2 = "Şu anda bulunduğunuz oyun desteklenenler listesinde değil.", unsupported_what_you_can_do = "Ne yapabilirsiniz", unsupported_do_join = "Aşağıdaki desteklenen oyunlardan birine katılın.", unsupported_do_ask = "Veya Sasware ekibinden bu oyunu eklemesini isteyin.", unsupported_supported_games = "Desteklenen oyunlar:", load_error = "Komut dosyası yüklenirken hata: " },
    ar = { title = "اختر إصدارًا", prompt = "أي إصدار تريد استخدامه؟", paid = "مدفوع", free = "مجاني", env_error_title = "بيئة غير مدعومة", env_error_issues_title = "المشكلات:", env_error_recommendations = "البدائل الموصى بها لجهازك:", env_error_no_alternatives = "لا توجد قائمة بدائل متاحة.", unsupported_title = "لعبة غير مدعومة", unsupported_heading = "هذه اللعبة غير مدعومة بعد.", unsupported_line1 = "يعمل Sasware فقط في بعض الألعاب.", unsupported_line2 = "اللعبة التي تلعبها الآن غير موجودة في قائمة الألعاب المدعومة.", unsupported_what_you_can_do = "ما يمكنك فعله", unsupported_do_join = "انضم إلى إحدى الألعاب المدعومة في الأسفل.", unsupported_do_ask = "أو اطلب من فريق Sasware إضافة هذه اللعبة.", unsupported_supported_games = "الألعاب المدعومة:", load_error = "خطأ في تحميل السكربت: " },
    th = { title = "เลือกเวอร์ชัน", prompt = "คุณต้องการใช้เวอร์ชันใด?", paid = "เสียเงิน", free = "ฟรี", env_error_title = "สภาพแวดล้อมไม่รองรับ", env_error_issues_title = "ปัญหา:", env_error_recommendations = "ตัวเลือกอื่นที่แนะนำสำหรับอุปกรณ์ของคุณ:", env_error_no_alternatives = "ไม่มีรายการตัวเลือกอื่นให้ใช้.", unsupported_title = "เกมที่ไม่รองรับ", unsupported_heading = "เกมนี้ยังไม่รองรับ.", unsupported_line1 = "Sasware ใช้งานได้กับบางเกมเท่านั้น.", unsupported_line2 = "เกมที่คุณเล่นอยู่ตอนนี้ไม่ได้อยู่ในรายชื่อเกมที่รองรับ.", unsupported_what_you_can_do = "คุณทำอะไรได้บ้าง", unsupported_do_join = "เข้าร่วมหนึ่งในเกมที่รองรับด้านล่าง.", unsupported_do_ask = "หรือขอให้ทีม Sasware เพิ่มเกมนี้.", unsupported_supported_games = "เกมที่รองรับ:", load_error = "เกิดข้อผิดพลาดขณะโหลดสคริปต์: " },
    vi = { title = "Chọn phiên bản", prompt = "Bạn muốn sử dụng phiên bản nào?", paid = "Trả phí", free = "Miễn phí", env_error_title = "Môi trường không được hỗ trợ", env_error_issues_title = "Sự cố:", env_error_recommendations = "Trình thực thi thay thế được đề xuất cho thiết bị của bạn:", env_error_no_alternatives = "Không có danh sách lựa chọn thay thế.", unsupported_title = "Trò chơi không được hỗ trợ", unsupported_heading = "Trò chơi này hiện chưa được hỗ trợ.", unsupported_line1 = "Sasware chỉ hoạt động trong một số trò chơi.", unsupported_line2 = "Trò chơi bạn đang ở hiện không nằm trong danh sách được hỗ trợ.", unsupported_what_you_can_do = "Bạn có thể làm gì", unsupported_do_join = "Tham gia một trong các trò chơi được hỗ trợ bên dưới.", unsupported_do_ask = "Hoặc yêu cầu đội ngũ Sasware thêm trò chơi này.", unsupported_supported_games = "Trò chơi được hỗ trợ:", load_error = "Lỗi khi tải script: " },
    zh = { title = "选择版本", prompt = "您想使用哪个版本？", paid = "付费", free = "免费", env_error_title = "不支持的环境", env_error_issues_title = "问题：", env_error_recommendations = "适合您设备的推荐替代执行器：", env_error_no_alternatives = "没有可用的替代列表。", unsupported_title = "不支持的游戏", unsupported_heading = "此游戏尚未被支持。", unsupported_line1 = "Sasware 仅在部分游戏中可用。", unsupported_line2 = "您当前所在的游戏不在支持列表中。", unsupported_what_you_can_do = "您可以做什么", unsupported_do_join = "加入下方任意受支持的游戏。", unsupported_do_ask = "或联系 Sasware 团队请求添加此游戏。", unsupported_supported_games = "受支持的游戏：", load_error = "加载脚本时出错：" },
}

local function Translate(Key)
    local Lang = GetLanguageCode()
    local Pack = Translations[Lang] or Translations["en"]
    return (Pack and Pack[Key]) or Translations["en"][Key] or Key
end

local Games = {
    Blockspin = {
        PaidURL = "https://api.sasware.dev/script/_Blockspin_Paid_Loader.luau",
        FreeURL = "https://api.sasware.dev/script/_Blockspin.luau",
        PlaceIDs = {
            95898900045000,
            132247642420063,
            102036043572089,
            97556409405464,
            113269916962108,
            104715542330896
        },
        UniverseID = 6765805766
    },
    Crashouts = {
        PaidURL = "https://api.sasware.dev/script/_Crashouts_Paid_Loader.luau",
        FreeURL = "https://api.sasware.dev/script/_Crashouts.luau",
        PlaceIDs = {
            97809623078844,
            96753233087555,
            96977652362603
        },
        UniverseID = 7382457344
    },
    ["Tank Game"] = {
        PaidURL = "https://api.sasware.dev/script/_TankGame_Paid_Loader.luau",
        FreeURL = "https://api.sasware.dev/script/_TankGame.luau",
        UniverseID = 8520148363,
        PlaceIDs = {
            108294535684057,
            97923409031527,
            118272497248285,
            89048211727318,
            119789365111500,
            119015508627868,
            126472955083296
        }
    }
}

local Environment = (function()
    local Module = {}

    function Module.GetExecutorName()
        local Identify = rawget(GlobalEnv, "identifyexecutor")
        if typeof(Identify) == "function" then
            local Ok, Res = pcall(Identify)
            if Ok and Res and #tostring(Res) > 0 then
                return tostring(Res)
            end
        end
        local Markers = {
            syn = "Synapse",
            fluxus = "Fluxus",
            krnl = "KRNL",
            Krnl = "KRNL",
            scriptware = "ScriptWare",
            wave = "Wave",
            delta = "Delta",
            codex = "Codex",
            evon = "Evon",
            arceus = "Arceus",
            hydrogen = "Hydrogen",
            potassium = "Potassium",
            zenith = "Zenith",
            volcano = "Volcano",
        }
        for Key, Name in pairs(Markers) do
            if typeof(rawget(GlobalEnv, Key)) == "table" then
                return Name
            end
        end
        return "Unknown"
    end

    function Module.HasFunction(Name)
        return typeof(rawget(GlobalEnv, Name)) == "function"
    end

    function Module.HasTableKey(TableName, Key)
        local Table = rawget(GlobalEnv, TableName)
        if typeof(Table) ~= "table" then return false end
        return rawget(Table, Key) ~= nil
    end

    function Module.RunChecks(Checks)
        local Failures = {}
        for _, Check in ipairs(Checks) do
            if Check.type == "function" then
                if not Module.HasFunction(Check.name) then
                    table.insert(Failures, "Missing function '" .. Check.name .. "'")
                end
            elseif Check.type == "tableKey" then
                if not Module.HasTableKey(Check.table, Check.key) then
                    table.insert(Failures, "Missing key '" .. Check.key .. "' on table '" .. Check.table .. "'")
                end
            end
        end
        return #Failures == 0, Failures
    end

    return Module
end)()

local function IsMobileDevice()
    local Ok, Res = pcall(function()
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end)
    return Ok and Res or false
end

local function ShowEnvironmentError(ExecutorName, Issues, Alternatives)
    local ScreenGui = Create("ScreenGui", {
        Name = "SaswareEnvError", IgnoreGuiInset = true, ResetOnSpawn = false,
        DisplayOrder = 1_000_001, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui
    })

    Create("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1), ZIndex = 10, Parent = ScreenGui
    })

    local Container = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 460, 0, 260), BackgroundColor3 = Color3.fromRGB(38, 30, 30),
        BorderSizePixel = 0, ZIndex = 20, Parent = ScreenGui
    })

    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Container })
    Create("UIStroke", { Thickness = 1, Color = Color3.fromRGB(120, 45, 45), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Container })
    Create("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), Parent = Container })

    Create("TextLabel", {
        BackgroundTransparency = 1, Text = Translate("env_error_title"), Font = Enum.Font.GothamBold,
        TextSize = 20, TextColor3 = Color3.fromRGB(255, 220, 220), TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -8, 0, 26), ZIndex = 21, Parent = Container
    })

    local Body = Create("TextLabel", {
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.fromRGB(240, 200, 200),
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, RichText = true,
        ZIndex = 21, Position = UDim2.new(0, 0, 0, 34), AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
        Text = "<b>" .. Translate("env_error_title") .. "</b><br/><br/>" ..
            "Executor: <font weight=\"semibold\">" .. ExecutorName .. "</font><br/><br/><b>" .. Translate("env_error_issues_title") .. "</b><br/> • " .. table.concat(Issues, "<br/> • "),
        Parent = Container
    })

    local AltLabel = Create("TextLabel", {
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.fromRGB(255, 235, 235),
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 21,
        Position = UDim2.new(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
        TextWrapped = true, RichText = true,
        Text = (#Alternatives > 0) and ("<b>" .. Translate("env_error_recommendations") .. "</b><br/> • " .. table.concat(Alternatives, "<br/> • ")) or ("<b>" .. Translate("env_error_no_alternatives") .. "</b>"),
        Parent = Container
    })

    local ButtonHeight, SpacingBelowText, Gap = 40, 18, 10

    local CloseBtn = Create("TextButton", {
        Text = "Close", Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(255, 235, 235),
        AutoButtonColor = true, BackgroundColor3 = Color3.fromRGB(120, 50, 50), Size = UDim2.new(0, 120, 0, ButtonHeight),
        ZIndex = 22, Parent = Container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = CloseBtn })

    task.defer(function()
        AltLabel.Position = UDim2.new(0, 0, 0, Body.Position.Y.Offset + Body.AbsoluteSize.Y + Gap)
        local AltBottom = AltLabel.Position.Y.Offset + AltLabel.AbsoluteSize.Y
        CloseBtn.Position = UDim2.new(0.5, -60, 0, AltBottom + SpacingBelowText)
        local InnerHeight = CloseBtn.Position.Y.Offset + ButtonHeight + 28
        Container.Size = UDim2.new(0, Container.Size.X.Offset, 0, InnerHeight)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        pcall(function() ScreenGui:Destroy() end)
        pcall(function() getgenv().SaswareEnvErrorClosed = true end)
    end)
end

local function ShowUnsupportedGameError(PlaceId, UniverseId, SupportedNames)
    local ScreenGui = Create("ScreenGui", {
        Name = "SaswareUnsupportedGame", IgnoreGuiInset = true, ResetOnSpawn = false,
        DisplayOrder = 1_000_002, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui
    })

    Create("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1), ZIndex = 10, Parent = ScreenGui
    })

    local Container = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 480, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(32, 36, 50), BorderSizePixel = 0, ZIndex = 20, Parent = ScreenGui
    })

    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Container })
    Create("UIStroke", { Thickness = 1, Color = Color3.fromRGB(70, 90, 130), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Container })
    Create("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), Parent = Container })

    Create("TextLabel", {
        BackgroundTransparency = 1, Text = Translate("unsupported_title"), Font = Enum.Font.GothamBold,
        TextSize = 20, TextColor3 = Color3.fromRGB(225, 235, 255), TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -8, 0, 26), ZIndex = 21, Parent = Container
    })

    local Body = Create("TextLabel", {
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.fromRGB(200, 210, 230),
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, RichText = true,
        ZIndex = 21, Position = UDim2.new(0, 0, 0, 34), AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
        Text = "<b>" .. Translate("unsupported_heading") .. "</b><br/><br/>" ..
            Translate("unsupported_line1") .. "<br/>" .. Translate("unsupported_line2") .. "<br/><br/>" ..
            "<b>" .. Translate("unsupported_what_you_can_do") .. "</b><br/>" ..
            "• " .. Translate("unsupported_do_join") .. "<br/>" ..
            "• " .. Translate("unsupported_do_ask") .. "<br/><br/>" ..
            "<b>" .. Translate("unsupported_supported_games") .. "</b>",
        Parent = Container
    })

    local ListLabel = Create("TextLabel", {
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.fromRGB(215, 225, 245),
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, RichText = true,
        ZIndex = 21, Position = UDim2.new(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
        Text = " • " .. table.concat(SupportedNames, "<br/> • "),
        Parent = Container
    })

    local ButtonHeight, VerticalGap = 40, 12

    local CloseBtn = Create("TextButton", {
        Text = "Close", Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(230, 235, 245),
        AutoButtonColor = true, BackgroundColor3 = Color3.fromRGB(65, 85, 125), Size = UDim2.new(0, 120, 0, ButtonHeight),
        Position = UDim2.new(0.5, -60, 0, 0), ZIndex = 22, Parent = Container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = CloseBtn })

    task.defer(function()
        ListLabel.Position = UDim2.new(0, 0, 0, Body.Position.Y.Offset + Body.AbsoluteSize.Y + VerticalGap)
        CloseBtn.Position = UDim2.new(0.5, -60, 0, ListLabel.Position.Y.Offset + ListLabel.AbsoluteSize.Y + VerticalGap)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        pcall(function() ScreenGui:Destroy() end)
        pcall(function() getgenv().SaswareUnsupportedClosed = true end)
    end)
end

local function ResolveRequestFunction()
    for _, Name in ipairs({"request", "http_request", "httprequest"}) do
        local Fn = rawget(GlobalEnv, Name)
        if typeof(Fn) == "function" then return Fn end
    end
    for _, TableName in ipairs({"syn", "http", "krnl", "fluxus"}) do
        local T = rawget(GlobalEnv, TableName)
        if typeof(T) == "table" then
            if typeof(rawget(T, "request")) == "function" then return rawget(T, "request") end
            if TableName == "syn" and typeof(rawget(T, "http_request")) == "function" then return rawget(T, "http_request") end
        end
    end
    return nil
end

local HttpRequest = ResolveRequestFunction()

local function FetchUrl(Url, Retries)
    local Attempts = Retries or 3
    local DelayStep = 1
    local LastErr = nil

    if HttpRequest then
        for Attempt = 1, Attempts do
            local Ok, Response = pcall(function()
                return HttpRequest({
                    Url = Url,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "SaswareBootstrapper",
                    },
                })
            end)

            if Ok and Response then
                local Status = tonumber(Response.StatusCode or Response.Status)
                local Success = Response.Success
                local Body = Response.Body or Response.body
                local IsSuccessful = (Success == nil or Success == true) and (not Status or (Status >= 200 and Status < 400))

                if IsSuccessful and Body and #Body > 0 then
                    return Body
                end

                LastErr = string.format("Request HTTP error (%s)", tostring(Status or "unknown"))
            else
                LastErr = Response
            end

            task.wait(DelayStep * Attempt)
        end
    end

    for Attempt = 1, Attempts do
        local Ok, Result = pcall(function()
            return game:HttpGet(Url)
        end)

        if Ok and Result and #Result > 0 then
            return Result
        end

        LastErr = Ok and "HttpGet returned empty response" or Result
        task.wait(DelayStep * Attempt)
    end

    return nil, LastErr or "Failed to fetch URL"
end

local function GetAssetFromUrl(Url, LocalFileName)
    local GetAsset = getcustomasset or (typeof(getsynasset) == "function" and getsynasset) or nil
    local CanWrite = typeof(writefile) == "function" and typeof(isfile) == "function"
    local CanFolder = typeof(isfolder) == "function" and typeof(makefolder) == "function"
    if not GetAsset or not CanWrite then
        return nil
    end
    local Folder = "sasware_assets"
    if CanFolder then
        local OkFolder, _ = pcall(function()
            if not isfolder(Folder) then
                makefolder(Folder)
            end
        end)
        if not OkFolder then
            Folder = ""
        end
    else
        Folder = ""
    end
    local Path = (Folder ~= "" and (Folder .. "/" .. LocalFileName)) or LocalFileName
    local Content = nil
    do
        local Fetched = FetchUrl(Url)
        Content = Fetched
        if not Content then
            return nil
        end
    end
    if not Content or #Content == 0 then
        return nil
    end
    local OkWrite = pcall(function()
        writefile(Path, Content)
    end)
    if not OkWrite then
        return nil
    end
    local OkAsset, AssetId = pcall(function()
        return GetAsset(Path)
    end)
    if OkAsset and AssetId then
        return AssetId
    end
    return nil
end

-- ohhhhhhh its gptd sasware is a paster confirmed

local function PromptForMode()
    local SelectionEvent = Instance.new("BindableEvent")

    local ScreenGui = Create("ScreenGui", {
        Name = "SaswareModePrompt", IgnoreGuiInset = true, ResetOnSpawn = false,
        DisplayOrder = 1_000_000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui
    })

    Create("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.35, BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1), ZIndex = 10, Parent = ScreenGui
    })

    local Container = Create("Frame", {
        Name = "Container", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 380, 0, 200), BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BorderSizePixel = 0, ZIndex = 20, Parent = ScreenGui
    })

    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Container })
    Create("UIStroke", { Thickness = 1, Color = Color3.fromRGB(80, 80, 95), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Container })
    Create("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), Parent = Container })

    Create("TextLabel", {
        BackgroundTransparency = 1, Text = Translate("title"), Font = Enum.Font.GothamBold,
        TextSize = 20, TextColor3 = Color3.fromRGB(240, 240, 255), TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -8, 0, 26), ZIndex = 21, Parent = Container
    })

    Create("TextLabel", {
        BackgroundTransparency = 1, Text = Translate("prompt"), Font = Enum.Font.Gotham, TextWrapped = true,
        TextSize = 16, TextColor3 = Color3.fromRGB(200, 200, 220), TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, Position = UDim2.new(0, 0, 0, 34), Size = UDim2.new(1, 0, 0, 56),
        ZIndex = 21, Parent = Container
    })

    local ButtonsHolder = Create("Frame", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 1, -74), Size = UDim2.new(1, 0, 0, 60),
        ZIndex = 21, Parent = Container
    })

    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 12),
        HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = ButtonsHolder
    })

    local function StyleButton(Btn)
        Btn.AutoButtonColor = true
        Btn.TextScaled = false
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 16
        Btn.ZIndex = 22
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
        Create("UIStroke", { Color = Color3.fromRGB(60, 60, 80), Thickness = 1, Parent = Btn })
    end

    local FreeBtn = Create("TextButton", {
        Name = "FreeButton", Text = Translate("free"), TextColor3 = Color3.fromRGB(240, 240, 255),
        BackgroundColor3 = Color3.fromRGB(45, 45, 55), Size = UDim2.new(0, 160, 0, 44), Parent = ButtonsHolder
    })
    StyleButton(FreeBtn)

    local PaidBtn = Create("TextButton", {
        Name = "PaidButton", Text = "", TextColor3 = Color3.fromRGB(240, 240, 255),
        BackgroundColor3 = Color3.fromRGB(25, 115, 85), Size = UDim2.new(0, 160, 0, 44), Parent = ButtonsHolder
    })
    StyleButton(PaidBtn)

    local PaidContent = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = PaidBtn })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder, Parent = PaidContent
    })

    local DollarImage = Create("ImageLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(0, 20, 0, 20), ImageColor3 = Color3.fromRGB(255, 255, 255),
        LayoutOrder = 1
    })

    local DollarAsset = GetAssetFromUrl("https://raw.githubusercontent.com/twitter/twemoji/master/assets/72x72/1f4b5.png", "dollar.png")
    if DollarAsset then
        DollarImage.Image = DollarAsset
        DollarImage.Parent = PaidContent
    else
        Create("TextLabel", {
            BackgroundTransparency = 1, Text = "$", Font = Enum.Font.GothamBold, TextSize = 18,
            TextColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 18, 0, 20), LayoutOrder = 1, Parent = PaidContent
        })
    end

    Create("TextLabel", {
        BackgroundTransparency = 1, Text = Translate("paid"), Font = Enum.Font.Gotham, TextSize = 16,
        TextColor3 = Color3.fromRGB(240, 240, 255), Size = UDim2.new(0, 80, 0, 20), LayoutOrder = 2, Parent = PaidContent
    })

    Container.Size = UDim2.new(0, 380, 0, 0)
    TweenService:Create(Container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 380, 0, 200) }):Play()

    local Chosen, Debounce = nil, false
    local function Choose(Mode)
        if Debounce then return end
        Debounce = true
        Chosen = Mode
        SelectionEvent:Fire()
    end

    FreeBtn.MouseButton1Click:Connect(function() Choose("Free") end)
    PaidBtn.MouseButton1Click:Connect(function() Choose("Paid") end)

    task.delay(30, function() if not Chosen then Choose("Free") end end)
    SelectionEvent.Event:Wait()

    pcall(function() ScreenGui:Destroy(); SelectionEvent:Destroy() end)
    return Chosen or "Free"
end

-- Check if the game is supported

local RequiredChecks = {
    { type = "function", name = "loadstring" },
}

local OkRequired, RequiredIssues = Environment.RunChecks(RequiredChecks)

do
    local ForceError = rawget(GlobalEnv, "SaswareForceEnvError") or rawget(GlobalEnv, "DebugForceEnvError") or rawget(GlobalEnv, "SaswareTestMissing")
    if ForceError then
        OkRequired = false
        if #RequiredIssues == 0 then
            RequiredIssues = {
                "(Simulated) Missing function 'loadstring'",
                "(Simulated) Missing key 'request' on table 'syn'",
            }
        else
            table.insert(RequiredIssues, 1, "(Forced error mode enabled)")
        end
    end
end

if not OkRequired then
    local ExecName = Environment.GetExecutorName()
    local MobileAlts = { "Delta", "Codex" }
    local PcAlts = { "Wave", "Zenith", "Volcano", "Potassium" }
    local AltsSource = IsMobileDevice() and MobileAlts or PcAlts
    local Filtered = {}
    for _, Alt in ipairs(AltsSource) do
        if string.lower(Alt) ~= string.lower(ExecName) then
            table.insert(Filtered, Alt)
        end
    end
    ShowEnvironmentError(ExecName, RequiredIssues, Filtered)
    return
end

local IsSupportedGame = false
local SelectedGame = nil

local CurrentPlaceId = game.PlaceId
local CurrentUniverseId = tonumber(game.GameId) -- GameId corresponds to universe ID

local function MatchesGame(Data)
    -- Prefer explicit UniverseID / UniverseIDs if provided
    if Data.UniverseID and CurrentUniverseId == Data.UniverseID then
        return true
    end
    if Data.UniverseIDs then
        for _, UId in next, Data.UniverseIDs do
            if CurrentUniverseId == UId then
                return true
            end
        end
    end
    -- Fallback to PlaceIDs list for legacy definitions
    if Data.PlaceIDs then
        for _, PlaceId in next, Data.PlaceIDs do
            if CurrentPlaceId == PlaceId then
                return true
            end
        end
    end
    return false
end

for GameName, GameData in next, Games do
    if MatchesGame(GameData) then
        IsSupportedGame = true
        SelectedGame = GameData
        break
    end
end

-- Debug / testing override: allow forcing unsupported state to preview behavior
do
    local ForceUnsupported = rawget(GlobalEnv, "SaswareForceUnsupported") or rawget(GlobalEnv, "SaswareTestUnsupported")
    if ForceUnsupported then
        IsSupportedGame = false
        SelectedGame = nil
    end
end

if not IsSupportedGame then
    local SupportedNames = {}
    for Name in next, Games do
        table.insert(SupportedNames, Name)
    end
    table.sort(SupportedNames)
    ShowUnsupportedGameError(game.PlaceId, tonumber(game.GameId), SupportedNames)
    return
end

-- Prompt the user for mode if not already specified
if getgenv().Mode == nil then
    local ChosenMode = nil
    local Ok, Res = pcall(PromptForMode)
    if Ok and (Res == "Paid" or Res == "Free") then
        ChosenMode = Res
    else
        ChosenMode = "Free"
    end
    getgenv().Mode = ChosenMode
end

local ScriptUrl = nil
if getgenv().Mode == "Paid" then
    ScriptUrl = SelectedGame.PaidURL
else
    ScriptUrl = SelectedGame.FreeURL
end

local Success, Error = pcall(function()
    local ScriptContent, FetchErr = FetchUrl(ScriptUrl)
    assert(ScriptContent and #ScriptContent > 0, FetchErr or "Failed to fetch script content.")
    local ScriptClosure = loadstring(ScriptContent)
    assert(ScriptClosure, "Failed to load script.")
    ScriptClosure()
end)

if not Success then
    LocalPlayer:Kick(Translate("load_error") .. tostring(Error))
end