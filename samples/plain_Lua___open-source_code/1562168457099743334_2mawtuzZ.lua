-- ═══════════════════════════════════════════════════════════════════
--  Luxt1 — full MM2 port (register-limit FIXED + toggles + screen buttons)
-- ═══════════════════════════════════════════════════════════════════
print("[Luxt1] file loaded")

-- ВСЁ живёт в таблице Luxt1 (фикс "Out of local registers")
local Luxt1 = {}

-- ═══════════════════════════════════════════════════════════════════════════
--  i18n SYSTEM — fully working language switcher
--  T(key)        → looks up EN/RU translation; falls back to the key itself.
--  Luxt1.uiReg   → registry of UI elements that should be re-translated live.
--  Luxt1.reapplyLang() → walks uiReg and updates .Text fields for the current language.
-- ═══════════════════════════════════════════════════════════════════════════
Luxt1.Language = "EN"
Luxt1.uiReg = {}        -- list of { inst = Instance, key = string, kind = "Text"|"PlaceholderText" }
Luxt1._pendingReg = true  -- while true, api builders register refs into uiReg


function Luxt1.T(key)
    if key == nil then return "" end
    local lang = Luxt1.Language or "EN"
    if lang == "RU" then
        local t = Luxt1.LANG and Luxt1.LANG.RU and Luxt1.LANG.RU[key]
        if t ~= nil and t ~= "" then return t end
    end
    return key
end

local T = Luxt1.T  -- local shortcut for use inside builders

function Luxt1.reapplyLang()
    pcall(function()
        local reg = Luxt1.uiReg or {}
        for _, entry in ipairs(reg) do
            local inst = entry.inst
            if inst and inst.Parent then
                local k = entry.key
                if k ~= nil then
                    if entry.kind == "PlaceholderText" then
                        inst.PlaceholderText = Luxt1.T(k)
                    else
                        inst.Text = Luxt1.T(k)
                    end
                end
            end
        end
    end)
    -- Also refresh toggle state buttons (ON/OFF labels)
    for _, ref in pairs(Luxt1.uiRefs or {}) do
        if type(ref) == "table" and ref._stateBtn and ref._state and ref._render then
            ref._render()
        end
    end
end

-- Register a UI instance for live re-translation. Returns the instance back.
local function regText(inst, key, kind)
    if inst == nil or key == nil then return inst end
    if not Luxt1.uiReg then Luxt1.uiReg = {} end
    table.insert(Luxt1.uiReg, { inst = inst, key = key, kind = kind or "Text" })
    return inst
end
Luxt1._regText = regText

Luxt1.LANG = {
    -- English is the identity language (T returns the key when no RU translation exists).
    EN = {
        -- intentionally sparse; T() returns the key itself when not found.
    },
    RU = {
        [" added"] = " добавлена",
        [" applied!"] = " применён!",
        [" off"] = " выкл",
        [" on!"] = " вкл!",
        [" removed"] = " убрана",
        ["%.0f HP"] = "%.0f HP",
        ["%s @%s\\nDist: %.1f | Pos: %.0f, %.0f, %.0f\\nRole: %s"] = "%s @%s\\nДист: %.1f | Поз: %.0f, %.0f, %.0f\\nРоль: %s",
        ["%s | Role: %s"] = "%s | Роль: %s",
        ["(empty)"] = "(пусто)",
        ["-- fps"] = "-- fps",
        ["-- ms"] = "-- ms",
        ["Actions"] = "Действия",
        ["Aimlock"] = "Аимлок",
        ["Animation Pack"] = "Пак анимаций",
        ["Animations"] = "Анимации",
        ["Anime sprite at the menu corner. Requires getcustomasset."] = "Аниме-спрайт у угла меню. Требует getcustomasset.",
        ["AntiAim"] = "AntiAim",
        ["AntiCoin"] = "Анти-монеты",
        ["AntiFling"] = "Анти-флинг",
        ["AspectRatio"] = "Соотношение сторон",
        ["Aura Color"] = "Цвет ауры",
        ["Aura cleared!"] = "Аура сброшена!",
        ["Auras"] = "Ауры",
        ["Auto Farm"] = "Авто-ферма",
        ["Auto Knife Throw"] = "Авто-бросок ножа",
        ["Auto Reset"] = "Авто-респавн",
        ["Auto-Offer"] = "Авто-оффер",
        ["Auto-get Dropped Gun"] = "Авто-подбор выброшенного оружия",
        ["Auto-gun"] = "Авто-оружие",
        ["Auto-offer DefaultGun"] = "Авто-оффер DefaultGun",
        ["Auto-shoot"] = "Авто-выстрел",
        ["AutoFarm"] = "Авто-ферма",
        ["Avoid Murder"] = "Избегать убийцу",
        ["Beam"] = "Луч",
        ["Bind"] = "Бинд",
        ["Bind SilentShoot key"] = "Назначить клавишу SilentShoot",
        ["Blink (freeze)"] = "Заморозка (freeze)",
        ["Box"] = "Бокс",
        ["Box ESP (имя+дист)"] = "Box ESP (имя+дист)",
        ["Bullet Tracer"] = "Трассер пуль",
        ["Button: "] = "Кнопка: ",
        ["CTRL+Click TP"] = "CTRL+Клик ТП",
        ["Character not ready!"] = "Персонаж не готов!",
        ["China Hat"] = "Китайская шляпа",
        ["Clear Aura"] = "Сбросить ауру",
        ["Client Ghost"] = "Клиентский призрак",
        ["Close"] = "Закрыть",
        ["Coin Limit"] = "Лимит монет",
        ["Coins hidden"] = "Монеты скрыты",
        ["Coins restored"] = "Монеты вернулись",
        ["Config Name"] = "Имя конфига",
        ["Configs"] = "Конфиги",
        ["Copied"] = "Скопировано",
        ["Copy Murderer Name"] = "Скопировать имя убийцы",
        ["Copy Sheriff Name"] = "Скопировать имя шерифа",
        ["Cosmetics"] = "Косметика",
        ["Custom Sounds"] = "Свои звуки",
        ["Custom Time"] = "Своё время",
        ["Dead"] = "Мёртвый",
        ["Disable Sound"] = "Звук выключения",
        ["Disabled (death)"] = "Отключён (смерть)",
        ["Dist: %.1f | Pos: %.0f, %.0f, %.0f\\nRole: %s"] = "Дист: %.1f | Поз: %.0f, %.0f, %.0f\\nРоль: %s",
        ["Done"] = "Готово",
        ["ESP"] = "ESP",
        ["Effects"] = "Эффекты",
        ["Emote"] = "Эмоция",
        ["Emote not found"] = "Эмоция не найдена",
        ["Emotes"] = "Эмоции",
        ["Enable Sound"] = "Звук включения",
        ["English"] = "Английский",
        ["Error"] = "Ошибка",
        ["FOV"] = "Угол обзора",
        ["FOV set"] = "Угол обзора установлен",
        ["FPS Boost"] = "Буст FPS",
        ["FPS Boost applied!"] = "FPS Boost применён!",
        ["FPS/Ping HUD"] = "FPS/Ping HUD",
        ["FadeDisabler"] = "Отключить фейды",
        ["Fades hidden"] = "Фейды скрыты",
        ["Fades restored"] = "Фейды вернулись",
        ["Failed to load "] = "Не загрузился ",
        ["Farm Mode"] = "Режим фермы",
        ["File corrupted!"] = "Файл повреждён!",
        ["File not found!"] = "Файл не найден!",
        ["Fling"] = "Флинг",
        ["Fling Murderer"] = "Флинг убийцы",
        ["Fling Sheriff"] = "Флинг шерифа",
        ["Fly  [WASD + Space/Ctrl]"] = "Полёт  [WASD + Пробел/Ctrl]",
        ["Fly Speed"] = "Скорость полёта",
        ["ForceShoot (по клику)"] = "ForceShoot (по клику)",
        ["Found"] = "Найдено",
        ["Friend Check (зелёный)"] = "Проверка друзей (зелёный)",
        ["Fun"] = "Фан",
        ["General"] = "Основное",
        ["Get Ping"] = "Показать пинг",
        ["Gun"] = "Оружие",
        ["Gun Beam"] = "Луч оружия",
        ["Gun ESP (выброшенное)"] = "Gun ESP (выброшенное)",
        ["Gun Model"] = "Модель оружия",
        ["Gun dropped!"] = "Оружие выброшено!",
        ["Gun picked up!"] = "Оружие подобрано!",
        ["GunKill Sound"] = "Звук GunKill",
        ["Gunshot Sound"] = "Звук выстрела",
        ["HUD"] = "HUD",
        ["Hero"] = "Герой",
        ["Hide Skins (DisplayRef)"] = "Скрыть скины (DisplayRef)",
        ["Hit Effects"] = "Эффекты попадания",
        ["Hit Particles"] = "Частицы попадания",
        ["Hit Sound"] = "Звук попадания",
        ["Hit Sound Mode"] = "Режим звука попадания",
        ["Infinite Void"] = "Бесконечная пустота",
        ["Info"] = "Инфо",
        ["Innocent"] = "Невиновный",
        ["Items"] = "Предметы",
        ["Jerk"] = "Дёрганье",
        ["Jump Circle"] = "Круг прыжка",
        ["Key: "] = "Клавиша: ",
        ["Kill (as Murderer)"] = "Убить (как убийца)",
        ["Kill Everyone"] = "Убить всех",
        ["Kill Nearest"] = "Убить ближайшего",
        ["Kill done"] = "Kill выполнен",
        ["KillAura"] = "KillAura",
        ["Knife"] = "Нож",
        ["Knife Kill Sound"] = "Звук убийства ножом",
        ["Knife Throw to Nearest"] = "Бросок ножа в ближайшего",
        ["Knife without Handle!"] = "Нож без Handle!",
        ["Korblox (Right Leg)"] = "Korblox (правая нога)",
        ["LMB on player → sound + stars"] = "ЛКМ по игроку → звук + звёздочки",
        ["Language"] = "Язык",
        ["List Pads"] = "Список падов",
        ["Load Config"] = "Загрузить конфиг",
        ["Loaded: "] = "Загружен: ",
        ["Loading..."] = "Загрузка...",
        ["Locked"] = "Заблокировано",
        ["Luxt1"] = "Luxt1",
        ["Luxt1 · MM2 port"] = "Luxt1 · MM2 порт",
        ["MM2"] = "MM2",
        ["Magic Aura"] = "Магическая аура",
        ["Max Distance"] = "Макс. дистанция",
        ["Meow"] = "Meow",
        ["Meow Overlay"] = "Meow-оверлей",
        ["Misc"] = "Разное",
        ["Movement"] = "Движение",
        ["Murderer"] = "Убийца",
        ["No"] = "Нет",
        ["No character"] = "Нет персонажа",
        ["No gun"] = "Нет оружия",
        ["No knife"] = "Нет ножа",
        ["No knife!"] = "Нет ножа!",
        ["No map!"] = "Нет карты!",
        ["No murderer"] = "Нет убийцы",
        ["No murderer!"] = "Нет убийцы!",
        ["No player selected"] = "Игрок не выбран",
        ["No player!"] = "Нет игрока!",
        ["No players!"] = "Нет игроков!",
        ["No sheriff"] = "Нет шерифа",
        ["No sheriff!"] = "Нет шерифа!",
        ["No trade state received yet"] = "Стейт трейда ещё не получен",
        ["Noclip"] = "Noclip",
        ["Noclip / Blink"] = "Noclip / Заморозка",
        ["Not found"] = "Не найдено",
        ["OFF"] = "ВЫКЛ",
        ["ON"] = "ВКЛ",
        ["Off"] = "Выкл",
        ["OffDamageWater"] = "Отключить урон от воды",
        ["Offer Category"] = "Категория оффера",
        ["Offer DefaultGun"] = "Оффернуть DefaultGun",
        ["Offer Interval (s)"] = "Интервал оффера (с)",
        ["Offer Item"] = "Предмет оффера",
        ["OfferItem not found"] = "OfferItem не найден",
        ["Offered: "] = "Предложено: ",
        ["On"] = "Вкл",
        ["Pick a language to start"] = "Выбери язык для старта",
        ["Pick a target first!"] = "Сначала выбери цель!",
        ["Pickup Method"] = "Метод подбора",
        ["Ping"] = "Пинг",
        ["Player"] = "Игрок",
        ["Player Name"] = "Имя игрока",
        ["Player not found"] = "Игрок не найден",
        ["Player..."] = "Игрок...",
        ["Players"] = "Игроки",
        ["Players ESP"] = "ESP игроков",
        ["Preparing interface"] = "Подготовка интерфейса",
        ["Press a key..."] = "Нажми клавишу...",
        ["Quick Select"] = "Быстрый выбор",
        ["RTX"] = "RTX",
        ["RTX off"] = "RTX выключен",
        ["RTX on"] = "RTX включён",
        ["Read error!"] = "Ошибка чтения!",
        ["Refresh Values"] = "Обновить значения",
        ["Rejoin"] = "Перезаход",
        ["Rejoining..."] = "Перезаход...",
        ["Reload Values"] = "Перезагрузить значения",
        ["Remove Sky"] = "Убрать небо",
        ["Reset Animation"] = "Сброс анимации",
        ["Reset."] = "Сброс.",
        ["Russian"] = "Русский",
        ["S.Aim Offset"] = "Отступ S.Aim",
        ["Save Config"] = "Сохранить конфиг",
        ["Save error!"] = "Ошибка сохранения!",
        ["Saved: "] = "Сохранён: ",
        ["Screen Btn"] = "Экранная кнопка",
        ["Screen Buttons"] = "Экранные кнопки",
        ["Script executed"] = "Скрипт выполнен",
        ["Search players..."] = "Поиск игроков...",
        ["Select Murderer"] = "Выбрать убийцу",
        ["Select Nearest"] = "Выбрать ближайшего",
        ["Select Sheriff"] = "Выбрать шерифа",
        ["Selected"] = "Выбрано",
        ["Selected: "] = "Выбран: ",
        ["Settings"] = "Настройки",
        ["Sheriff"] = "Шериф",
        ["Shoot (клавиша ниже)"] = "Стрелять (клавиша ниже)",
        ["Shoot Murderer"] = "Выстрелить в убийцу",
        ["Shoot Offset"] = "Отступ выстрела",
        ["Shot"] = "Выстрел",
        ["Shot!"] = "Выстрел!",
        ["Shows item values and totals in trade."] = "Показывает ценность предметов в трейде и Total.",
        ["Shutup GunReload"] = "Заглушить GunReload",
        ["SilentAim"] = "SilentAim",
        ["SilentShoot: "] = "SilentShoot: ",
        ["Sky not found"] = "Sky не найден",
        ["Sky removed!"] = "Небо убрано!",
        ["Skybox"] = "Скайбокс",
        ["Skybox Manager"] = "Менеджер скайбоксов",
        ["Sound"] = "Звук",
        ["Spin"] = "Вращение",
        ["Spin Speed"] = "Скорость вращения",
        ["Stop Emote"] = "Остановить эмоцию",
        ["Stopped."] = "Остановлено.",
        ["Switched to English"] = "Переключено на английский",
        ["Switched to Russian"] = "Переключено на русский",
        ["TP"] = "ТП",
        ["TP to Dropped Gun"] = "ТП к выброшенному оружию",
        ["TP to Lobby"] = "ТП в лобби",
        ["TP to Random Spawn"] = "ТП на случайный спавн",
        ["Target"] = "Цель",
        ["Target ESP (уголки)"] = "Target ESP (уголки)",
        ["Target HUD"] = "Target HUD",
        ["Teleport"] = "Телепорт",
        ["Teleport To"] = "Телепорт к",
        ["Test UI Sound"] = "Тест звука UI",
        ["Them: "] = "Они: ",
        ["Thrown at "] = "Брошен в ",
        ["Time Lock"] = "Фиксация времени",
        ["To "] = "К ",
        ["Tools"] = "Инструменты",
        ["Tracer Color"] = "Цвет трассера",
        ["Trade"] = "Трейд",
        ["Trade Helper"] = "Помощник трейда",
        ["Trade Helper (Value Pills)"] = "Помощник трейда (Value Pills)",
        ["Trade Helper on"] = "Trade Helper включён",
        ["Trade Status"] = "Статус трейда",
        ["Trade remote not found"] = "Trade remote не найден",
        ["Trail Style"] = "Стиль трейла",
        ["Trails"] = "Трейлы",
        ["Traps ESP"] = "Traps ESP",
        ["Tween Speed"] = "Скорость твина",
        ["UI Sounds"] = "Звуки интерфейса",
        ["UI Sounds Enabled"] = "Звуки интерфейса вкл.",
        ["Underground Offset"] = "Подземный отступ",
        ["Unload All"] = "Выгрузить всё",
        ["Unloaded"] = "Выгружено",
        ["Values API empty"] = "API значений пуст",
        ["Values API unreachable"] = "API значений недоступен",
        ["Values loaded: "] = "Значения загружены: ",
        ["Values updated"] = "Значения обновлены",
        ["Values: "] = "Значения: ",
        ["Visuals"] = "Визуалы",
        ["Vote Duper"] = "Накрутка голоса",
        ["Vote Pad"] = "Пад голосования",
        ["WalkFling"] = "WalkFling",
        ["Walkspeed"] = "Скорость ходьбы",
        ["Walkspeed set"] = "Скорость ходьбы установлена",
        ["Water"] = "Вода",
        ["Water damage OFF"] = "Урон от воды ВЫКЛ",
        ["Water damage ON"] = "Урон от воды ВКЛ",
        ["Weather"] = "Погода",
        ["What's your language?"] = "Какой у тебя язык?",
        ["World"] = "Мир",
        ["Yes"] = "Да",
        ["You are not the murderer"] = "Ты не убийца",
        ["You are not the sheriff"] = "Ты не шериф",
        ["You are the murderer!"] = "Ты убийца!",
        ["You: "] = "Вы: ",
        ["Your executor does not support files!"] = "Твой executor не поддерживает файлы!",
        ["items"] = "шт",
        ["name"] = "название",
        ["no value"] = "нет значения",
    },
}

Luxt1.HARDCODED_VALUES = {
    ["Alienbeam"] = 2050,
    ["Amerilaser"] = 22,
    ["Australis"] = 140,
    ["Bat"] = 125,
    ["Battleaxe"] = 12,
    ["Battleaxe II"] = 17,
    ["battleaxeii"] = 17, -- normalized
    ["Batwing"] = 42,
    ["Bauble"] = 675,
    ["Beachy"] = 90,
    ["Bioblade"] = 8,
    ["Blaster"] = 17,
    ["Blizzard"] = 305,
    ["Bloom"] = 400,
    ["Blossom"] = 1370,
    ["Blue Seer"] = 3,
    ["blueseer"] = 3, -- normalized
    ["Boneblade"] = 7,
    ["Borealis"] = 145,
    ["C. Traveler's Gun"] = 145000,
    ["ctravelersgun"] = 145000, -- normalized
    ["Candleflame"] = 33,
    ["Candy"] = 80,
    ["Celestial"] = 2250,
    ["Chill"] = 10,
    ["Chroma Alienbeam"] = 24000,
    ["chromaalienbeam"] = 24000, -- normalized
    ["Chroma Bauble"] = 33000,
    ["chromabauble"] = 33000, -- normalized
    ["Chroma Beachy"] = 1200,
    ["chromabeachy"] = 1200, -- normalized
    ["Chroma Blizzard"] = 5500,
    ["chromablizzard"] = 5500, -- normalized
    ["Chroma Boneblade"] = 22,
    ["chromaboneblade"] = 22, -- normalized
    ["Chroma Candleflame"] = 40,
    ["chromacandleflame"] = 40, -- normalized
    ["Chroma Constellation"] = 30000,
    ["chromaconstellation"] = 30000, -- normalized
    ["Chroma Cookiecane"] = 32,
    ["chromacookiecane"] = 32, -- normalized
    ["Chroma Darkbringer"] = 65,
    ["chromadarkbringer"] = 65, -- normalized
    ["Chroma Deathshard"] = 35,
    ["chromadeathshard"] = 35, -- normalized
    ["Chroma Elderwood Blade"] = 37,
    ["chromaelderwoodblade"] = 37, -- normalized
    ["Chroma Evergreen"] = 41000,
    ["chromaevergreen"] = 41000, -- normalized
    ["Chroma Evergun"] = 56000,
    ["chromaevergun"] = 56000, -- normalized
    ["Chroma Fang"] = 32,
    ["chromafang"] = 32, -- normalized
    ["Chroma Gemstone"] = 32,
    ["chromagemstone"] = 32, -- normalized
    ["Chroma Gingerblade"] = 27,
    ["chromagingerblade"] = 27, -- normalized
    ["Chroma Heart Wand"] = 4200,
    ["chromaheartwand"] = 4200, -- normalized
    ["Chroma Heat"] = 28,
    ["chromaheat"] = 28, -- normalized
    ["Chroma Icecream"] = 1700,
    ["chromaicecream"] = 1700, -- normalized
    ["Chroma Laser"] = 40,
    ["chromalaser"] = 40, -- normalized
    ["Chroma Lightbringer"] = 60,
    ["chromalightbringer"] = 60, -- normalized
    ["Chroma Luger"] = 50,
    ["chromaluger"] = 50, -- normalized
    ["Chroma Ornament"] = 1825,
    ["chromaornament"] = 1825, -- normalized
    ["Chroma Raygun"] = 14000,
    ["chromaraygun"] = 14000, -- normalized
    ["Chroma Sands"] = 1250,
    ["chromasands"] = 1250, -- normalized
    ["Chroma Saw"] = 23,
    ["chromasaw"] = 23, -- normalized
    ["Chroma Seer"] = 28,
    ["chromaseer"] = 28, -- normalized
    ["Chroma Shark"] = 32,
    ["chromashark"] = 32, -- normalized
    ["Chroma Slasher"] = 32,
    ["chromaslasher"] = 32, -- normalized
    ["Chroma Snow Dagger"] = 2350,
    ["chromasnowdagger"] = 2350, -- normalized
    ["Chroma Snowcannon"] = 7750,
    ["chromasnowcannon"] = 7750, -- normalized
    ["Chroma Snowstorm"] = 4250,
    ["chromasnowstorm"] = 4250, -- normalized
    ["Chroma Sunrise"] = 10750,
    ["chromasunrise"] = 10750, -- normalized
    ["Chroma Sunset"] = 7750,
    ["chromasunset"] = 7750, -- normalized
    ["Chroma Sweet"] = 1725,
    ["chromasweet"] = 1725, -- normalized
    ["Chroma Swirly Gun"] = 35,
    ["chromaswirlygun"] = 35, -- normalized
    ["Chroma Tides"] = 27,
    ["chromatides"] = 27, -- normalized
    ["Chroma Treat"] = 1775,
    ["chromatreat"] = 1775, -- normalized
    ["Chroma Vampires Gun"] = 29000,
    ["chromavampiresgun"] = 29000, -- normalized
    ["Chroma Watergun"] = 2500,
    ["chromawatergun"] = 2500, -- normalized
    ["Clockwork"] = 10,
    ["Constellation"] = 2700,
    ["Cookieblade"] = 3,
    ["Cookiecane"] = 13,
    ["Darkbringer"] = 33,
    ["Darkshot"] = 1800,
    ["Darksword"] = 1775,
    ["Deathshard"] = 13,
    ["Eggblade"] = 5,
    ["Elderwood Blade"] = 33,
    ["elderwoodblade"] = 33, -- normalized
    ["Elderwood Revolver"] = 33,
    ["elderwoodrevolver"] = 33, -- normalized
    ["Elderwood Scythe"] = 38,
    ["elderwoodscythe"] = 38, -- normalized
    ["Eternal"] = 7,
    ["Eternal II"] = 7,
    ["eternalii"] = 7, -- normalized
    ["Eternal III"] = 8,
    ["eternaliii"] = 8, -- normalized
    ["Eternal IV"] = 8,
    ["eternaliv"] = 8, -- normalized
    ["Eternalcane"] = 13,
    ["Evergreen"] = 2525,
    ["Evergun"] = 3450,
    ["Fang"] = 10,
    ["Flames"] = 5,
    ["Flora"] = 410,
    ["Flowerwood"] = 255,
    ["Flowerwood Gun"] = 260,
    ["flowerwoodgun"] = 260, -- normalized
    ["Frostbite"] = 7,
    ["Frostsaber"] = 10,
    ["Gemstone"] = 15,
    ["Ghostblade"] = 7,
    ["Ginger Luger"] = 17,
    ["gingerluger"] = 17, -- normalized
    ["Gingerblade"] = 13,
    ["Gingermint"] = 12,
    ["Gingerscope"] = 16250,
    ["Green Luger"] = 23,
    ["greenluger"] = 23, -- normalized
    ["Hallow's Blade"] = 8,
    ["hallowsblade"] = 8, -- normalized
    ["Hallow's Edge"] = 8,
    ["hallowsedge"] = 8, -- normalized
    ["Hallowgun"] = 20,
    ["Hallowscythe"] = 30,
    ["Handsaw"] = 8,
    ["Harvester"] = 250,
    ["Heart Wand"] = 340,
    ["heartwand"] = 340, -- normalized
    ["Heartblade"] = 65,
    ["Heat"] = 10,
    ["Ice Dragon"] = 7,
    ["icedragon"] = 7, -- normalized
    ["Ice Shard"] = 7,
    ["iceshard"] = 7, -- normalized
    ["Icebeam"] = 18,
    ["Iceblaster"] = 33,
    ["Icebreaker"] = 65,
    ["Icecream"] = 155,
    ["Iceflake"] = 15,
    ["Icepiercer"] = 160,
    ["Icewing"] = 13,
    ["Jinglegun"] = 13,
    ["Laser"] = 22,
    ["Lightbringer"] = 32,
    ["Logchopper"] = 18,
    ["Luger"] = 18,
    ["Lugercane"] = 13,
    ["Makeshift"] = 33,
    ["Minty"] = 13,
    ["Nebula"] = 13,
    ["Nightblade"] = 20,
    ["Ocean"] = 285,
    ["Old Glory"] = 15,
    ["oldglory"] = 15, -- normalized
    ["Orange Seer"] = 2,
    ["orangeseer"] = 2, -- normalized
    ["Ornament"] = 75,
    ["Pearl"] = 75,
    ["Pearlshine"] = 80,
    ["Peppermint"] = 4,
    ["Phantom"] = 35,
    ["Pixel"] = 17,
    ["Plasmabeam"] = 18,
    ["Plasmablade"] = 15,
    ["Prismatic"] = 7,
    ["Pumpking"] = 7,
    ["Purple Seer"] = 3,
    ["purpleseer"] = 3, -- normalized
    ["Rainbow"] = 410,
    ["Rainbow Gun"] = 420,
    ["rainbowgun"] = 420, -- normalized
    ["Raygun"] = 1900,
    ["Red Luger"] = 35,
    ["redluger"] = 35, -- normalized
    ["Red Seer"] = 3,
    ["redseer"] = 3, -- normalized
    ["Sakura"] = 1360,
    ["Sands"] = 90,
    ["Saw"] = 7,
    ["Seer"] = 3,
    ["Shark"] = 20,
    ["Slasher"] = 15,
    ["Snow Dagger"] = 175,
    ["snowdagger"] = 175, -- normalized
    ["Snowcannon"] = 675,
    ["Snowflake"] = 5,
    ["Snowstorm"] = 305,
    ["Soul"] = 655,
    ["Spectre"] = 35,
    ["Spider"] = 10,
    ["Spirit"] = 645,
    ["Sugar"] = 32,
    ["Sunrise"] = 1075,
    ["Sunset"] = 650,
    ["Sweet"] = 150,
    ["Swirly Axe"] = 38,
    ["swirlyaxe"] = 38, -- normalized
    ["Swirly Blade"] = 12,
    ["swirlyblade"] = 12, -- normalized
    ["Swirly Gun"] = 18,
    ["swirlygun"] = 18, -- normalized
    ["Tides"] = 10,
    ["Traveler's Axe"] = 8000,
    ["travelersaxe"] = 8000, -- normalized
    ["Traveler's Gun"] = 5200,
    ["travelersgun"] = 5200, -- normalized
    ["Treat"] = 155,
    ["Turkey"] = 2050,
    ["Vampire's Axe"] = 1600,
    ["vampiresaxe"] = 1600, -- normalized
    ["Vampire's Edge"] = 15,
    ["vampiresedge"] = 15, -- normalized
    ["Vampire's Gun"] = 1875,
    ["vampiresgun"] = 1875, -- normalized
    ["Virtual"] = 13,
    ["Watergun"] = 160,
    ["Waves"] = 280,
    ["Winter's Edge"] = 5,
    ["wintersedge"] = 5, -- normalized
    ["Xenoknife"] = 405,
    ["Xenoshot"] = 405,
    ["Xmas"] = 7,
    ["Yellow Seer"] = 2,
    ["yellowseer"] = 2, -- normalized
}



local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local SoundService     = game:GetService("SoundService")
local ContentProvider  = game:GetService("ContentProvider")
local Lighting         = game:GetService("Lighting")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local Stats            = game:GetService("Stats")
local LocalPlayer      = Players.LocalPlayer
local mouse            = LocalPlayer:GetMouse()

local ASSETS = { logo="90791694090379", shadow="6105530152", snowflake="6035047409", searchIcon="6031154871" }
local SOUNDS = { ["Enable 1"]="rbxassetid://100772509583336", Sparkle="rbxassetid://110241936966089",
    ["Laser Click"]="rbxassetid://18913006341", ["Enable 2"]="rbxassetid://84626036868067", Notify="rbxassetid://103421304020039" }
local CUSTOM_SOUNDS = {
    ["Rust Headshot"]="138750331387064", Neverlose="110168723447153", Bubble="6534947588", Steve="4965083997",
    ["Call of Duty"]="5952120301", ["TF2 Critical"]="296102734", Saber="8415678813", Bameware="3124331820",
    Money="13956013041", Shutter="10066921516", RIFK7="9102080552", LazerBeam="130791043",
    TF2Hitsound="3455144981", BowHit="1053296915", OSU="7147454322", TF2Pan="3431749479", Mario="5709456554",
    Bell="6534947240", Vine="5332680810", Bruh="4578740568", Skeet="5633695679", Fatality="6534947869",
    Bonk="5766898159", Minecraft="5869422451", Gamesense="4817809188", Weeb="6442965016", Beep="8177256015",
    Click="8053704437", Ding="7149516994", Snow="6455527632", TF2="2868331684", ["Among Us"]="5700183626",
    UwU="8679659744", ["Default Sound"]="330595293",
}
local SOUND_NAMES = { "Default" }
for k in pairs(CUSTOM_SOUNDS) do table.insert(SOUND_NAMES, k) end
table.sort(SOUND_NAMES, function(a,b)
    if a=="Default" then return true elseif b=="Default" then return false end
    return a:lower()<b:lower()
end)
local function soundId(name) return name=="Default" and nil or ("rbxassetid://"..(CUSTOM_SOUNDS[name] or "")) end

local ICON_FONT
pcall(function()
    ICON_FONT = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end)

local GLYPH = { burst="burst", crosshairs="crosshairs", eye="eye", person="person", star="star",
    jumping="person-jumping", folder="folder", gear="gear", speaker="speaker",
    sword="sword", search="magnifying-glass" }
local TAB_GLYPHS = { general=GLYPH.gear, mm2=GLYPH.burst, esp=GLYPH.crosshairs, target=GLYPH.person,
    visual=GLYPH.eye, trade=GLYPH.star, fun=GLYPH.jumping, sound=GLYPH.speaker, main=GLYPH.folder }

local ACCENT        = Color3.fromRGB(139, 124, 255)
local ACCENT_BRIGHT = Color3.fromRGB(167, 139, 255)
local BG_MAIN       = Color3.fromRGB(14, 13, 20)
local BG_SIDE       = Color3.fromRGB(18, 17, 26)
local BG_ITEM       = Color3.fromRGB(26, 25, 36)
local BG_ITEM_HOVER = Color3.fromRGB(36, 34, 48)
local BG_TAB_ACTIVE = Color3.fromRGB(45, 40, 72)
local TEXT          = Color3.fromRGB(235, 232, 245)
local TEXT_DIM      = Color3.fromRGB(150, 148, 165)
local OUTLINE       = Color3.fromRGB(55, 50, 90)
local FONT      = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold

-- ═══ Helpers ═══
local function tween(obj, props, t, style, dir)
    if not obj or not obj.Parent then return end
    pcall(function() TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play() end)
end
local function corner(parent, r)
    if not parent then return end
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = parent; return c
end
local function stroke(parent, color, thick, trans)
    if not parent then return end
    local s = Instance.new("UIStroke"); s.Color = color or OUTLINE; s.Thickness = thick or 1
    s.Transparency = trans or 0.62; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent; return s
end
local function img(id)
    if not id or id == "" then return "" end
    id = tostring(id)
    if tonumber(id) then return "rbxassetid://"..id end
    return id
end
local function makeIcon(parent, glyphName, fallbackId, size, color)
    size = size or 20; color = color or TEXT_DIM
    if ICON_FONT then
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency=1; lbl.Size=UDim2.fromOffset(size,size); lbl.FontFace=ICON_FONT
        lbl.Text=glyphName; lbl.TextColor3=color; lbl.TextSize=size
        lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.TextYAlignment=Enum.TextYAlignment.Center
        lbl.ZIndex=parent.ZIndex+1; lbl.Parent=parent
        return lbl, "glyph"
    else
        local i = Instance.new("ImageLabel")
        i.BackgroundTransparency=1; i.Size=UDim2.fromOffset(size,size); i.Image=img(fallbackId or ASSETS.searchIcon)
        i.ImageColor3=color; i.ScaleType=Enum.ScaleType.Fit; i.ZIndex=parent.ZIndex+1; i.Parent=parent
        return i, "image"
    end
end

-- ═══ Sound ═══
local SoundModule = {}
SoundModule.enabled = true
SoundModule.enableSound = "Enable 1"
SoundModule.disableSound = "Enable 1"
function SoundModule.play(id)
    if not SoundModule.enabled or not id then return end
    pcall(function()
        local s = Instance.new("Sound"); s.SoundId=id; s.Volume=0.6; s.Parent=SoundService
        s:Play(); game:GetService("Debris"):AddItem(s, 5)
    end)
end
function SoundModule.enable() SoundModule.play(SOUNDS[SoundModule.enableSound]) end
function SoundModule.disable() SoundModule.play(SOUNDS[SoundModule.disableSound]) end
task.spawn(function()
    local ids = {}
    for _, v in pairs(SOUNDS) do table.insert(ids, v) end
    for _, v in pairs(CUSTOM_SOUNDS) do table.insert(ids, "rbxassetid://"..v) end
    pcall(function() ContentProvider:PreloadAsync(ids) end)
end)

-- ═══ Notifications ═══
local notifGui, notifHolder
local function ensureNotif()
    if notifHolder and notifHolder.Parent then return end
    notifGui = Instance.new("ScreenGui")
    notifGui.Name="Luxt1_Notify"; notifGui.ResetOnSpawn=false; notifGui.IgnoreGuiInset=true; notifGui.DisplayOrder=9999
    local ok = pcall(function() notifGui.Parent = gethui and gethui() or game:GetService("CoreGui") end)
    if not ok or not notifGui.Parent then notifGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    notifHolder = Instance.new("Frame")
    notifHolder.BackgroundTransparency=1
    notifHolder.Position=UDim2.new(0,15,0,55); notifHolder.Size=UDim2.new(0,0,1,-55)
    notifHolder.AutomaticSize=Enum.AutomaticSize.X; notifHolder.Parent=notifGui
    local l = Instance.new("UIListLayout"); l.Padding=UDim.new(0,10); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=notifHolder
end
function Luxt1.notify(title, content, dur)
    ensureNotif()
    SoundModule.play(SOUNDS.Notify)
    -- auto-translate title/content if they exactly match a known key
    if type(title) == "string" then title = Luxt1.T(title) end
    if type(content) == "string" then content = Luxt1.T(content) end
    local n = Instance.new("Frame")
    n.BackgroundColor3=BG_ITEM; n.BackgroundTransparency=1; n.BorderSizePixel=0
    n.AutomaticSize=Enum.AutomaticSize.XY; n.ZIndex=50; n.Parent=notifHolder
    corner(n, 8); stroke(n, ACCENT, 1, 0.55)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency=1; t.Font=FONT_BOLD; t.Text=tostring(title); t.TextColor3=TEXT
    t.TextSize=13; t.TextXAlignment=Enum.TextXAlignment.Left; t.AutomaticSize=Enum.AutomaticSize.XY
    t.Size=UDim2.new(0,0,0,14); t.ZIndex=51; t.Parent=n
    local d = Instance.new("TextLabel")
    d.BackgroundTransparency=1; d.Font=FONT; d.Text=tostring(content); d.TextColor3=TEXT_DIM
    d.TextSize=12; d.TextWrapped=true; d.TextXAlignment=Enum.TextXAlignment.Left
    d.AutomaticSize=Enum.AutomaticSize.XY; d.Size=UDim2.new(0,220,0,14); d.Position=UDim2.new(0,0,0,17)
    d.ZIndex=51; d.Parent=n
    local pad = Instance.new("UIPadding")
    pad.PaddingTop=UDim.new(0,6); pad.PaddingBottom=UDim.new(0,8); pad.PaddingLeft=UDim.new(0,8); pad.PaddingRight=UDim.new(0,8)
    pad.Parent=n
    task.spawn(function()
        local size = n.AbsoluteSize
        n.Size = UDim2.fromOffset(0,0)
        tween(n, {BackgroundTransparency=0.08, Size=UDim2.fromOffset(size.X, size.Y)}, 0.22, Enum.EasingStyle.Quart)
        tween(t, {TextTransparency=0}, 0.2); tween(d, {TextTransparency=0}, 0.2)
        task.wait(dur or 3)
        tween(n, {BackgroundTransparency=1, Size=UDim2.fromOffset(0,0)}, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        tween(t, {TextTransparency=1}, 0.2); tween(d, {TextTransparency=1}, 0.2)
        task.wait(0.3); pcall(function() n:Destroy() end)
    end)
end
local notify = Luxt1.notify

-- ═══ STATE ═══
local F = {
    fly=false, flySpeed=50, ws=16, fov=70, ctrlTP=false,
    noclip=false, blink=false,
    spin=false, spinSpeed=240, jerk=false, walkFling=false, antiAim=false,
    antiFling=false, ghost=false, aspect=false, aspectScale=0.65,
    playersESP=false, gunESP=false, trapsESP=false, targetESP=false, targetHUD=false, boxESP=false,
    autoShoot=false, shootOff=1, silent=false, silentKey="E", forceShoot=false, saimOff=2.8,
    autoGetGun=false, pickup="Remote", water=false, antiCoin=false, fadeOff=false,
    autoKnife=false, killAura=false, vote=false, votePad=2,
    farm={enabled=false, mode="Underground", tweenSpeed=25, autoReset=false, avoidMurder=false, ugOffset=4, maxDist=600, coinLimit=40},
    trail={on=false, style="Solid", color=Color3.fromRGB(170,90,255)},
    tracer={on=false, color=Color3.fromRGB(0,255,140), custom=false},
    magicAura=false, rtx=false, timeLock="Off", timeVal=14, weather="Off",
    gunModel="None", beamType="Default", beamColor=Color3.fromRGB(0,240,255),
    chinaHat=false, jumpCircle=false, korblox=false, hideSkins=false, meow="None",
    gunKill="Default", gunshot="Default", knifeKill="Default", noReload=false,
    trade=false, friendCheck=false,
    hitParts=false, hitSound=false, hitSoundMode=1,
    statsHud=true, aimlock=false,
}
local AURA_COLOR = Color3.fromRGB(255,255,255)

local function getChar()
    local c = LocalPlayer.Character
    if not c then return nil end
    return c, c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

-- ═══ MM2 CORE ═══
local MM2 = { roles={}, murd="", sher="", hero="" }
function MM2.refresh()
    local rf = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    if not rf then return end
    local ok, res = pcall(function() return rf:InvokeServer() end)
    if not ok or type(res) ~= "table" then return end
    MM2.roles = res
    MM2.murd, MM2.sher, MM2.hero = "", "", ""
    for k, v in pairs(res) do
        if type(v) == "table" then
            if v.Role == "Murderer" or v.Role == "Team1" then MM2.murd = k
            elseif v.Role == "Sheriff" or v.Role == "Team2" then MM2.sher = k
            elseif v.Role == "Hero" then MM2.hero = k end
        end
    end
end
function MM2.alive(plr)
    local name = typeof(plr) == "Instance" and plr.Name or plr
    local r = MM2.roles[name]
    if not r then return false end
    if r.Killed or r.Dead or r.Role == "Died" or r.Role == "Dead" then return false end
    return true
end
function MM2.norm(plr)
    local name = typeof(plr) == "Instance" and plr.Name or plr
    local r = MM2.roles[name]
    if not r then return nil end
    if r.Role == "Team1" then return "Murderer" end
    if r.Role == "Team2" then return "Sheriff" end
    if r.Role == "Died" or r.Role == "Dead" then return "Dead" end
    return r.Role
end
function MM2.myRole() local r = MM2.roles[LocalPlayer.Name] return r and r.Role or nil end
local function findTool(plr, name)
    local bp = plr:FindFirstChild("Backpack")
    local ch = plr.Character
    return bp and bp:FindFirstChild(name) or ch and ch:FindFirstChild(name)
end
function MM2.getMurd()
    for _, plr in ipairs(Players:GetPlayers()) do
        if findTool(plr, "Knife") then return plr end
    end
    return MM2.murd ~= "" and Players:FindFirstChild(MM2.murd) or nil
end
function MM2.getSher()
    for _, plr in ipairs(Players:GetPlayers()) do
        if findTool(plr, "Gun") then return plr end
    end
    return MM2.sher ~= "" and Players:FindFirstChild(MM2.sher) or nil
end
function MM2.amIMurd() return MM2.getMurd() == LocalPlayer or findTool(LocalPlayer, "Knife") ~= nil end
function MM2.nearest()
    local _, hrp = getChar()
    if not hrp then return nil end
    local best, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local p = plr.Character:FindFirstChild("HumanoidRootPart")
            if p then
                local d = (p.Position - hrp.Position).Magnitude
                if d < dist then best, dist = plr, d end
            end
        end
    end
    return best
end
local BULLET_SPEED, GRAVITY = 300, workspace.Gravity
function MM2.predict(plr, offset)
    if not plr or not plr.Character then return Vector3.zero end
    local _, myHRP = getChar()
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("UpperTorso")
    if not tHRP or not myHRP then return tHRP and tHRP.Position or Vector3.zero end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    local pos = tHRP.Position
    local t = (pos - myHRP.Position).Magnitude / BULLET_SPEED + LocalPlayer:GetNetworkPing() + (offset or 1) * 0.01
    local vel = tHRP.AssemblyLinearVelocity
    local y = pos.Y
    if hum then
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
            y = pos.Y + vel.Y * t - 0.5 * GRAVITY * t * t
        else
            y = pos.Y + vel.Y * 0.05
        end
    end
    return Vector3.new(pos.X + vel.X * t, y, pos.Z + vel.Z * t)
end
function MM2.silentPredict(plr, offset)
    local ch = plr and plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return hrp and hrp.Position end
    return hrp.Position + hrp.AssemblyLinearVelocity * Vector3.new(0.75, 0.5, 0.75) * offset / 15 + hum.MoveDirection * offset
end
function MM2.shootTarget()
    local my = MM2.myRole()
    if my == "Team1" or my == "Team2" then
        local want = my == "Team1" and "Team2" or "Team1"
        local _, hrp = getChar()
        local best, dist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and MM2.roles[plr.Name] and MM2.roles[plr.Name].Role == want and MM2.alive(plr) and plr.Character then
                local p = plr.Character:FindFirstChild("HumanoidRootPart")
                if p then
                    local d = hrp and (hrp.Position - p.Position).Magnitude or 0
                    if d < dist then best, dist = plr, d end
                end
            end
        end
        return best
    end
    return nil
end

-- ═══ connections ═══
local conns = {}
local function track(c) table.insert(conns, c) return c end
local function killConn(c) if c then pcall(function() c:Disconnect() end) end end

-- ═══ FLY ═══
function Luxt1.flyMovers(make)
    local _, hrp = getChar()
    if not hrp then return end
    if Luxt1.flyBV then pcall(function() Luxt1.flyBV:Destroy() end) Luxt1.flyBV = nil end
    if Luxt1.flyBG then pcall(function() Luxt1.flyBG:Destroy() end) Luxt1.flyBG = nil end
    if make then
        Luxt1.flyBV = Instance.new("BodyVelocity")
        Luxt1.flyBV.MaxForce = Vector3.one * 1e9; Luxt1.flyBV.Velocity = Vector3.zero; Luxt1.flyBV.Parent = hrp
        Luxt1.flyBG = Instance.new("BodyGyro")
        Luxt1.flyBG.MaxTorque = Vector3.one * 1e9; Luxt1.flyBG.P = 9e4; Luxt1.flyBG.Parent = hrp
    end
end
function Luxt1.setFly(on)
    F.fly = on
    Luxt1.flyMovers(on)
    if on and not Luxt1.flyConn then
        Luxt1.flyConn = RunService.RenderStepped:Connect(function()
            local _, hrp = getChar()
            if not (hrp and Luxt1.flyBV and Luxt1.flyBV.Parent) then return end
            local cam = workspace.CurrentCamera
            local mv = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.yAxis end
            Luxt1.flyBV.Velocity = mv.Magnitude > 0 and mv.Unit * F.flySpeed or Vector3.zero
            Luxt1.flyBG.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        end)
        track(Luxt1.flyConn)
    elseif not on and Luxt1.flyConn then killConn(Luxt1.flyConn) Luxt1.flyConn = nil end
end

-- ═══ NOCLIP / BLINK / SPIN / JERK / WALKFLING ═══
function Luxt1.setNoclip(on)
    F.noclip = on
    if Luxt1.noclipConn then killConn(Luxt1.noclipConn) Luxt1.noclipConn = nil end
    if on then
        Luxt1.noclipConn = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character
            if not c then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end)
        track(Luxt1.noclipConn)
    end
end
function Luxt1.setBlink(on)
    F.blink = on
    local _, hrp = getChar()
    if hrp then hrp.Anchored = on end
end
function Luxt1.setSpin(on)
    F.spin = on
    if Luxt1.spinConn then killConn(Luxt1.spinConn) Luxt1.spinConn = nil end
    if on then
        Luxt1.spinConn = RunService.RenderStepped:Connect(function()
            local _, hrp = getChar()
            if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(F.spinSpeed), 0) end
        end)
        track(Luxt1.spinConn)
    end
end
function Luxt1.setJerk(on)
    F.jerk = on
    if Luxt1.jerkConn then killConn(Luxt1.jerkConn) Luxt1.jerkConn = nil end
    if on then
        Luxt1.jerkConn = RunService.Heartbeat:Connect(function()
            local _, hrp = getChar()
            if hrp then
                local dir = math.random() > 0.5 and 1 or -1
                hrp.CFrame += workspace.CurrentCamera.CFrame.RightVector * 1.2 * dir
            end
        end)
        track(Luxt1.jerkConn)
    end
end
function Luxt1.setWalkFling(on)
    F.walkFling = on
    if Luxt1.wfConn then killConn(Luxt1.wfConn) Luxt1.wfConn = nil end
    if on then
        Luxt1.wfConn = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if not (hrp and hum) then return end
            if hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = hrp.CFrame.LookVector * hum.WalkSpeed * 5 + Vector3.new(0, hrp.Velocity.Y, 0)
            end
        end)
        track(Luxt1.wfConn)
    end
end

-- ═══ ANTIAIM ═══
function Luxt1.antiAimStop()
    F.antiAim = false
    Luxt1.aaGen = (Luxt1.aaGen or 0) + 1
    if Luxt1.aaConn then killConn(Luxt1.aaConn) Luxt1.aaConn = nil end
    if Luxt1.aaDied then killConn(Luxt1.aaDied) Luxt1.aaDied = nil end
    local c = LocalPlayer.Character
    if c then
        for k, v in pairs(Luxt1.aaSaved or {}) do
            if k and k.Parent then pcall(function() k.CanCollide = v end) end
        end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then pcall(function()
            hrp.Velocity = Vector3.zero; hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero
        end) end
    end
    table.clear(Luxt1.aaSaved or {})
end
function Luxt1.antiAimStart()
    Luxt1.antiAimStop()
    F.antiAim = true
    Luxt1.aaGen = (Luxt1.aaGen or 0) + 1
    local gen = Luxt1.aaGen
    Luxt1.aaSaved = {}
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        Luxt1.aaDied = hum.Died:Connect(function()
            if Luxt1.aaGen ~= gen then return end
            Luxt1.antiAimStop()
            notify(T("AntiAim"), T("Disabled (death)"), 2)
            if Luxt1.uiRefs and Luxt1.uiRefs.antiAim then pcall(function() Luxt1.uiRefs.antiAim:Set(false) end) end
        end)
    end
    Luxt1.aaConn = RunService.Stepped:Connect(function()
        if not F.antiAim or Luxt1.aaGen ~= gen then return end
        local c = LocalPlayer.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if not c or not h or h.Health <= 0 then Luxt1.antiAimStop() return end
        for _, d in ipairs(c:GetDescendants()) do
            if d:IsA("BasePart") then
                if Luxt1.aaSaved[d] == nil then Luxt1.aaSaved[d] = d.CanCollide end
                d.CanCollide = false
            end
        end
    end)
    track(Luxt1.aaConn)
    task.spawn(function()
        local n = 0.1
        while F.antiAim and Luxt1.aaGen == gen do
            RunService.Heartbeat:Wait()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if c and h and h.Health > 0 and hrp then
                local vel = hrp.Velocity
                hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if F.antiAim and Luxt1.aaGen == gen and h.Health > 0 then hrp.Velocity = vel end
                RunService.Stepped:Wait()
                if F.antiAim and Luxt1.aaGen == gen and h.Health > 0 then
                    hrp.Velocity = vel + Vector3.new(0, n, 0)
                    n *= -1
                end
            end
        end
    end)
end

-- ═══ ANTIFLING / ASPECT / GHOST ═══
function Luxt1.setAntiFling(on)
    F.antiFling = on
    if Luxt1.afConn then killConn(Luxt1.afConn) Luxt1.afConn = nil end
    if on then
        Luxt1.afConn = RunService.Heartbeat:Connect(function()
            local _, hrp = getChar()
            if hrp and hrp.Velocity.Magnitude > 350 then
                hrp.Velocity = Vector3.zero
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end)
        track(Luxt1.afConn)
    end
end
function Luxt1.setAspect(on)
    F.aspect = on
    if Luxt1.arConn then killConn(Luxt1.arConn) Luxt1.arConn = nil end
    if on then
        getgenv().Resolution = F.aspectScale
        Luxt1.arConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if cam and F.aspect then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution or F.aspectScale, 0, 0, 0, 1)
            end
        end)
        track(Luxt1.arConn)
    end
end
function Luxt1.setGhost(on)
    F.ghost = on
    if Luxt1.ghostConn then killConn(Luxt1.ghostConn) Luxt1.ghostConn = nil end
    if not on then return end
    local clientVisuals = workspace:FindFirstChild("ClientVisuals") or Instance.new("Folder", workspace)
    clientVisuals.Name = "ClientVisuals"
    local ghost = { clone=nil, pairs={}, history={}, lastChar=nil }
    local function clear()
        if ghost.clone then pcall(function() ghost.clone:Destroy() end) end
        ghost.clone, ghost.pairs, ghost.history, ghost.lastChar = nil, {}, {}, nil
    end
    Luxt1.ghostConn = RunService.RenderStepped:Connect(function()
        if not F.ghost then clear() return end
        local c = LocalPlayer.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then return end
        if ghost.lastChar ~= c then clear() ghost.lastChar = c end
        if not ghost.clone or ghost.clone.Parent ~= clientVisuals then
            c.Archivable = true
            ghost.clone = c:Clone()
            ghost.clone.Name = "ClientGhost"; ghost.clone.Parent = clientVisuals
            ghost.pairs = {}
            local h = ghost.clone:FindFirstChildOfClass("Humanoid") if h then h:Destroy() end
            local rh = ghost.clone:FindFirstChild("HumanoidRootPart") if rh then rh:Destroy() end
            for _, d in ipairs(ghost.clone:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
                if d:IsA("BasePart") then d.Anchored=true; d.CanCollide=false; d.CanQuery=false; d.CanTouch=false; d.Massless=true end
            end
            for _, d in ipairs(c:GetDescendants()) do
                if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
                    local g = ghost.clone:FindFirstChild(d.Name)
                    if not g and d.Parent and d.Parent:IsA("Accessory") then
                        local acc = ghost.clone:FindFirstChild(d.Parent.Name)
                        g = acc and acc:FindFirstChild(d.Name)
                    end
                    if g and g:IsA("BasePart") then table.insert(ghost.pairs, { real = d, ghostP = g }) end
                end
            end
            for _, pr in ipairs(ghost.pairs) do
                pcall(function() pr.ghostP.Transparency = 0.5; pr.ghostP.Color = Color3.fromRGB(255, 100, 100) end)
            end
        end
        local snap = {}
        for _, pr in ipairs(ghost.pairs) do snap[pr.real] = pr.real.CFrame end
        table.insert(ghost.history, { t = tick(), parts = snap })
        while #ghost.history > 0 and tick() - ghost.history[1].t > 2 do table.remove(ghost.history, 1) end
        local ping = 0
        pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        local wantT = tick() - math.clamp(ping / 1000, 0, 2)
        local best = ghost.history[#ghost.history]
        for i = #ghost.history, 1, -1 do
            if ghost.history[i].t <= wantT then best = ghost.history[i] break end
        end
        if best then
            for _, pr in ipairs(ghost.pairs) do
                if best.parts[pr.real] then pr.ghostP.CFrame = best.parts[pr.real] end
            end
        end
    end)
    track(Luxt1.ghostConn)
end

-- ═══ TRAILS ═══
local function clearAuraTrail()
    for _, v in ipairs(Luxt1.auraTrail or {}) do pcall(function() v:Destroy() end) end
    Luxt1.auraTrail = {}
end
local function buildTrail(c)
    if Luxt1.trailObj then Luxt1.trailObj:Destroy() end
    if Luxt1.trailA0 then Luxt1.trailA0:Destroy() end
    if Luxt1.trailA1 then Luxt1.trailA1:Destroy() end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    Luxt1.trailA0 = Instance.new("Attachment", hrp); Luxt1.trailA0.Position = Vector3.new(0, 1, 0)
    Luxt1.trailA1 = Instance.new("Attachment", hrp); Luxt1.trailA1.Position = Vector3.new(0, -1, 0)
    Luxt1.trailObj = Instance.new("Trail")
    Luxt1.trailObj.Attachment0 = Luxt1.trailA0; Luxt1.trailObj.Attachment1 = Luxt1.trailA1
    Luxt1.trailObj.Lifetime = 0.8; Luxt1.trailObj.LightEmission = 0.5; Luxt1.trailObj.MinLength = 0.05
    Luxt1.trailObj.Parent = hrp
end
local function trailStyleApply()
    if not Luxt1.trailObj then return end
    Luxt1.trailObj.Color = ColorSequence.new(F.trail.color)
    if F.trail.style == "Fade" then
        Luxt1.trailObj.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(0.5,0.5), NumberSequenceKeypoint.new(1,1) })
    elseif F.trail.style == "Dotted" then
        local kp = {}
        for i = 0, 9 do table.insert(kp, NumberSequenceKeypoint.new(i/10, i % 2 == 0 and 0 or 1)) end
        table.insert(kp, NumberSequenceKeypoint.new(1, 0))
        Luxt1.trailObj.Transparency = NumberSequence.new(kp)
    else
        Luxt1.trailObj.Transparency = NumberSequence.new(0, 0.8)
    end
end
local function setupAuraTrailer(c)
    clearAuraTrail()
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local anchor = hrp:FindFirstChild("AuraTrailerAnchor") or Instance.new("Attachment", hrp)
    anchor.Name = "AuraTrailerAnchor"
    Luxt1.auraTrail = {}
    for _, part in ipairs(c:GetChildren()) do
        if part:IsA("BasePart") and part ~= hrp then
            local att = Instance.new("Attachment"); att.Name = "AuraTrailerP"; att.Parent = part
            local tr = Instance.new("Trail")
            tr.Name = "AuraTrailer"; tr.Texture = "rbxassetid://1390780157"
            tr.Attachment0 = att; tr.Attachment1 = anchor
            tr.LightEmission = 0.4; tr.MinLength = 0.05; tr.Parent = part
            table.insert(Luxt1.auraTrail, tr); table.insert(Luxt1.auraTrail, att)
        end
    end
end
track(RunService.RenderStepped:Connect(function()
    local c = LocalPlayer.Character
    if not c then return end
    if F.trail.on and F.trail.style == "Aura Trailer" then
        if Luxt1.trailObj then Luxt1.trailObj.Enabled = false end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not hrp:FindFirstChild("AuraTrailerAnchor") or #(Luxt1.auraTrail or {}) == 0 then setupAuraTrailer(c) end
        for _, v in ipairs(Luxt1.auraTrail or {}) do
            if v:IsA("Trail") then
                v.Color = ColorSequence.new(F.trail.color)
                v.Transparency = NumberSequence.new(0, 0.6); v.Lifetime = 0.8
            end
        end
    elseif F.trail.on then
        clearAuraTrail()
        if not Luxt1.trailObj or not Luxt1.trailObj.Parent then buildTrail(c) end
        trailStyleApply()
        if Luxt1.trailObj then Luxt1.trailObj.Enabled = true end
    else
        clearAuraTrail()
        if Luxt1.trailObj then Luxt1.trailObj.Enabled = false end
    end
end))

-- ═══ BULLET TRACER ═══
local function clearTracer()
    if Luxt1.tracerFx and Luxt1.tracerFx.folder then pcall(function() Luxt1.tracerFx.folder:Destroy() end) end
    Luxt1.tracerFx = nil
end
local function tracerTarget()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local loc = UserInputService:GetMouseLocation()
    local ray = cam:ViewportPointToRay(loc.X, loc.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = { LocalPlayer.Character }
    pcall(function()
        for _, v in ipairs(game:GetService("CollectionService"):GetTagged("WeaponPassthrough")) do table.insert(filter, v) end
    end)
    params.FilterDescendantsInstances = filter
    local hit
    while true do
        hit = workspace:Raycast(ray.Origin, ray.Direction * 500, params)
        if not hit then break end
        if hit.Instance and hit.Instance.Transparency == 1 then
            table.insert(filter, hit.Instance)
            params.FilterDescendantsInstances = filter
        else break end
    end
    if hit then return hit.Position end
    return ray.Origin + ray.Direction * 500
end
function Luxt1.spawnTracerFX(a, b)
    clearTracer()
    local folder = Instance.new("Folder"); folder.Name = "Luxt1_Tracer"; folder.Parent = workspace
    local function mkPart(pos)
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.2, 0.2, 0.2); p.Anchored = true; p.CanCollide = false
        p.CanTouch = false; p.CanQuery = false; p.Transparency = 1; p.CFrame = CFrame.new(pos); p.Parent = folder
        return p
    end
    local p0, p1 = mkPart(a), mkPart(b)
    local a0 = Instance.new("Attachment", p0); local a1 = Instance.new("Attachment", p1)
    local beams = {}
    local col = F.tracer.custom and F.tracer.color or nil
    local defs = {
        { Texture="rbxassetid://12251459424", Color=Color3.fromRGB(255,123,6) },
        { Texture="rbxassetid://84577820022939", Color=Color3.fromRGB(255,81,0) },
        { Texture="http://www.roblox.com/asset/?id=15253860988", Color=Color3.fromRGB(255,183,2) },
        { Texture="rbxassetid://18664874807", Color=Color3.fromRGB(255,0,0), TextureLength=3, TextureSpeed=3 },
    }
    for _, d in ipairs(defs) do
        local bm = Instance.new("Beam")
        bm.Texture = d.Texture; bm.Attachment0 = a0; bm.Attachment1 = a1
        bm.LightEmission = 1; bm.FaceCamera = true; bm.Width0 = 0.25; bm.Width1 = 0.25
        bm.Color = ColorSequence.new(col or d.Color)
        if d.TextureLength then bm.TextureLength = d.TextureLength end
        if d.TextureSpeed then bm.TextureSpeed = d.TextureSpeed end
        bm.Parent = p0
        table.insert(beams, bm)
    end
    Luxt1.tracerFx = { folder = folder, beams = beams, t0 = os.clock() }
end
track(RunService.RenderStepped:Connect(function()
    if Luxt1.tracerFx and Luxt1.tracerFx.beams and Luxt1.tracerFx.beams[1] and Luxt1.tracerFx.beams[1].Parent then
        local t = (os.clock() - Luxt1.tracerFx.t0) / 4
        if t >= 1 then clearTracer()
        else
            for _, bm in ipairs(Luxt1.tracerFx.beams) do
                pcall(function() bm.Transparency = NumberSequence.new(t) end)
            end
        end
    elseif Luxt1.tracerFx then clearTracer() end
end))
local hookedGuns = {}
local function hookGun(tool)
    if not tool or not tool:IsA("Tool") or hookedGuns[tool] then return end
    hookedGuns[tool] = true
    track(tool.Activated:Connect(function()
        if not F.tracer.on then return end
        local c = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local origin = nil
        local att = hrp and hrp:FindFirstChild("GunRaycastAttachment")
        if att then origin = att.WorldCFrame.Position end
        if not origin then
            for _, ch in ipairs(c:GetChildren()) do
                if ch:IsA("Tool") and ch:FindFirstChild("Handle") then origin = ch.Handle.Position break end
            end
        end
        if not origin then origin = hrp and hrp.Position end
        if origin then
            local tgt = tracerTarget()
            if tgt then Luxt1.tracerFx_pending = { origin = origin, target = tgt, t = os.clock() } end
        end
    end))
    local handle = tool:FindFirstChild("Handle")
    if handle then
        for _, d in ipairs(handle:GetDescendants()) do
            if d:IsA("Sound") and (d.Name == "Gunshot" or d.Name == "AltSound") and not hookedGuns[d] then
                hookedGuns[d] = true
                track(d.Played:Connect(function()
                    local p = Luxt1.tracerFx_pending
                    Luxt1.tracerFx_pending = nil
                    if not (F.tracer.on and p and os.clock() - p.t < 0.5) then return end
                    if os.clock() - (Luxt1.tracerLastSpawn or 0) < 0.15 then return end
                    Luxt1.tracerLastSpawn = os.clock()
                    Luxt1.spawnTracerFX(p.origin, p.target)
                end))
            end
        end
    end
end
local function hookGunContainer(c)
    if not c then return end
    for _, ch in ipairs(c:GetChildren()) do hookGun(ch) end
    track(c.ChildAdded:Connect(function(ch) task.wait(0.05) hookGun(ch) end))
end
if LocalPlayer.Character then hookGunContainer(LocalPlayer.Character) end
track(LocalPlayer.CharacterAdded:Connect(function(c) task.wait(1) hookGunContainer(c) end))
do
    local bp0 = LocalPlayer:FindFirstChild("Backpack")
    if bp0 then track(bp0.ChildAdded:Connect(function(ch) hookGun(ch) end)) end
end

-- ═══ MAGIC AURA ═══
local auraColors = { Color3.fromRGB(170,90,255), Color3.fromRGB(255,90,130), Color3.fromRGB(90,255,130),
    Color3.fromRGB(255,255,90), Color3.fromRGB(255,130,255), Color3.fromRGB(130,255,255) }
local magicParts = {}
track(RunService.RenderStepped:Connect(function()
    local _, hrp = getChar()
    if not hrp then return end
    if F.magicAura then
        while #magicParts < 6 do
            local p = Instance.new("Part")
            p.Anchored=true; p.CanCollide=false; p.Material=Enum.Material.Neon
            p.Shape=Enum.PartType.Ball; p.Size=Vector3.new(0.6,0.6,0.6); p.Transparency=0.3; p.Parent=workspace
            table.insert(magicParts, p)
        end
        local now = tick()
        for i, p in ipairs(magicParts) do
            local off = (i - 1) * 1.0472
            p.CFrame = CFrame.new(hrp.Position + Vector3.new(math.cos(now*1.5+off)*3, math.sin(now*2+off), math.sin(now*1.5+off)*3))
            p.Color = auraColors[i] or auraColors[1]
        end
    else
        for _, p in ipairs(magicParts) do pcall(function() p:Destroy() end) end
        magicParts = {}
    end
end))

-- ═══ RTX ═══
function Luxt1.rtxOn()
    if Luxt1.rtxApplied then return end
    Luxt1.rtxApplied = true; F.rtx = true
    Luxt1.rtxSaved = {}
    for _, prop in ipairs({ "Ambient","Brightness","ColorShift_Bottom","ColorShift_Top","EnvironmentDiffuseScale",
        "EnvironmentSpecularScale","GlobalShadows","OutdoorAmbient","ShadowSoftness","ClockTime","GeographicLatitude","ExposureCompensation" }) do
        pcall(function() Luxt1.rtxSaved[prop] = Lighting[prop] end)
    end
    Luxt1.rtxSavedChildren = {}
    for _, ch in ipairs(Lighting:GetChildren()) do
        if ch:IsA("PostEffect") or ch:IsA("Sky") or ch:IsA("Atmosphere") then
            ch.Parent = nil; table.insert(Luxt1.rtxSavedChildren, ch)
        end
    end
    local bloom = Instance.new("BloomEffect"); bloom.Intensity=0.35; bloom.Size=20; bloom.Threshold=0.85
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness=0.05; cc.Contrast=0.25; cc.Saturation=0.15; cc.TintColor=Color3.fromRGB(255,245,230)
    local sr = Instance.new("SunRaysEffect"); sr.Intensity=0.12; sr.Spread=0.8
    local sky = Instance.new("Sky")
    sky.SkyboxBk="http://www.roblox.com/asset/?id=151165214"; sky.SkyboxDn="http://www.roblox.com/asset/?id=151165197"
    sky.SkyboxFt="http://www.roblox.com/asset/?id=151165224"; sky.SkyboxLf="http://www.roblox.com/asset/?id=151165191"
    sky.SkyboxRt="http://www.roblox.com/asset/?id=151165206"; sky.SkyboxUp="http://www.roblox.com/asset/?id=151165227"
    sky.SunAngularSize = 11
    local atm = Instance.new("Atmosphere")
    atm.Density=0.3; atm.Offset=0.25; atm.Color=Color3.fromRGB(199,175,166)
    atm.Decay=Color3.fromRGB(44,39,33); atm.Glare=0.35; atm.Haze=1.2
    Luxt1.rtxAdded = { bloom, cc, sr, sky, atm }
    for _, v in ipairs(Luxt1.rtxAdded) do v.Parent = Lighting end
    pcall(function() Lighting.Technology = Enum.Technology.Future end)
    Lighting.Ambient=Color3.fromRGB(70,70,70); Lighting.Brightness=2
    Lighting.EnvironmentDiffuseScale=1; Lighting.EnvironmentSpecularScale=1
    Lighting.GlobalShadows=true; Lighting.OutdoorAmbient=Color3.fromRGB(100,100,100)
    Lighting.ShadowSoftness=0.15; Lighting.ClockTime=14; Lighting.GeographicLatitude=45
    Lighting.ExposureCompensation=0.1
    Luxt1.rtxVignette = Instance.new("ScreenGui")
    Luxt1.rtxVignette.Name="_AirflowVignette"; Luxt1.rtxVignette.IgnoreGuiInset=true; Luxt1.rtxVignette.ResetOnSpawn=false
    Luxt1.rtxVignette.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local im = Instance.new("ImageLabel", Luxt1.rtxVignette)
    im.AnchorPoint=Vector2.new(0.5,1); im.Position=UDim2.new(0.5,0,1,0); im.Size=UDim2.new(1,0,1.05,0)
    im.BackgroundTransparency=1; im.Image="rbxassetid://4576475446"; im.ImageTransparency=0.35; im.ZIndex=10
    notify(T("RTX"), T("RTX on"), 2)
end
function Luxt1.rtxOff()
    if not Luxt1.rtxApplied then return end
    Luxt1.rtxApplied = false; F.rtx = false
    for _, v in ipairs(Luxt1.rtxAdded or {}) do pcall(function() v:Destroy() end) end
    Luxt1.rtxAdded = {}
    for _, v in ipairs(Luxt1.rtxSavedChildren or {}) do pcall(function() v.Parent = Lighting end) end
    Luxt1.rtxSavedChildren = {}
    for k, v in pairs(Luxt1.rtxSaved or {}) do pcall(function() Lighting[k] = v end) end
    Luxt1.rtxSaved = {}
    if Luxt1.rtxVignette then pcall(function() Luxt1.rtxVignette:Destroy() end) Luxt1.rtxVignette = nil end
    notify(T("RTX"), T("RTX off"), 2)
end

-- ═══ TIME LOCK / WEATHER / SKYBOX ═══
track(RunService.Heartbeat:Connect(function()
    if F.timeLock ~= "Off" then
        local map = { Dawn=6, Day=12, Sunset=18, Night=21, Midnight=0 }
        local t = F.timeLock == "Custom" and F.timeVal or map[F.timeLock]
        if type(t) == "number" then pcall(function() Lighting.ClockTime = t end) end
    end
end))
local weatherState = { part=nil, emitter=nil, fogActive=false, orig={} }
local function weatherClear()
    if weatherState.emitter then pcall(function() weatherState.emitter:Destroy() end) weatherState.emitter = nil end
    if weatherState.part then pcall(function() weatherState.part:Destroy() end) weatherState.part = nil end
end
local function fogSet(on)
    if on and not weatherState.fogActive then
        weatherState.orig = { Start=Lighting.FogStart, End=Lighting.FogEnd, Color=Lighting.FogColor }
        weatherState.fogActive = true
        pcall(function() Lighting.FogStart=0; Lighting.FogEnd=80; Lighting.FogColor=Color3.fromRGB(180,180,190) end)
    elseif not on and weatherState.fogActive then
        weatherState.fogActive = false
        pcall(function()
            Lighting.FogStart = weatherState.orig.Start or 0
            Lighting.FogEnd = weatherState.orig.End or 100000
            Lighting.FogColor = weatherState.orig.Color or Color3.fromRGB(192,192,192)
        end)
    end
end
function Luxt1.weatherApply()
    weatherClear()
    if not F.weather or F.weather == "Off" then fogSet(false) return end
    if F.weather == "Fog" then fogSet(true) return end
    fogSet(false)
    weatherState.part = Instance.new("Part")
    weatherState.part.Name="_AirflowWeather"; weatherState.part.Size=Vector3.new(0.1,0.1,0.1)
    weatherState.part.Anchored=true; weatherState.part.CanCollide=false; weatherState.part.Transparency=1; weatherState.part.Parent=workspace
    weatherState.emitter = Instance.new("ParticleEmitter", weatherState.part)
    weatherState.emitter.LockedToPart=false; weatherState.emitter.Speed=NumberRange.new(0)
    if F.weather == "Rain" then
        weatherState.emitter.Texture="rbxassetid://241876428"
        weatherState.emitter.Lifetime=NumberRange.new(0.6,0.9); weatherState.emitter.Rate=600
        weatherState.emitter.Speed=NumberRange.new(120,140); weatherState.emitter.SpreadAngle=Vector2.new(2,2)
        weatherState.emitter.Acceleration=Vector3.new(0,-10,0); weatherState.emitter.Size=NumberSequence.new(0.4)
        weatherState.emitter.Transparency=NumberSequence.new(0.3)
        weatherState.emitter.Color=ColorSequence.new(Color3.fromRGB(180,200,240))
        weatherState.emitter.Orientation=Enum.ParticleOrientation.VelocityParallel
    elseif F.weather == "Snow" then
        weatherState.emitter.Texture="rbxassetid://241876428"
        weatherState.emitter.Lifetime=NumberRange.new(3,5); weatherState.emitter.Rate=250
        weatherState.emitter.Speed=NumberRange.new(8,14); weatherState.emitter.SpreadAngle=Vector2.new(20,20)
        weatherState.emitter.Acceleration=Vector3.new(0,-2,0); weatherState.emitter.RotSpeed=NumberRange.new(-30,30)
        weatherState.emitter.Size=NumberSequence.new(0.3)
        weatherState.emitter.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2), NumberSequenceKeypoint.new(1,0.6)})
        weatherState.emitter.Color=ColorSequence.new(Color3.fromRGB(255,255,255))
    end
    weatherState.emitter.EmissionDirection = Enum.NormalId.Bottom
end
track(RunService.RenderStepped:Connect(function()
    if not weatherState.part or not weatherState.part.Parent then return end
    local cam = workspace.CurrentCamera
    if cam then
        local p = cam.CFrame.Position
        weatherState.part.CFrame = CFrame.new(p.X, p.Y + 60, p.Z)
    end
end))
pcall(function()
    Lighting.FogStart = 9e9; Lighting.FogEnd = 9e9; Lighting.FogColor = Color3.new(1,1,1)
    for _, ch in ipairs(Lighting:GetChildren()) do
        if ch:IsA("Atmosphere") then pcall(function() ch.Density = 0 ch.Offset = 0 end) end
    end
end)
track(Lighting.ChildAdded:Connect(function(ch)
    if ch:IsA("Atmosphere") then pcall(function() ch.Density = 0 end) end
end))
function Luxt1.skyboxApply(id, name)
    task.spawn(function()
        local ok, res = pcall(function() return game:GetObjects("rbxassetid://"..tostring(id)) end)
        if not ok or not res or #res == 0 then notify(T("Skybox"), T("Failed to load ")..tostring(id), 3) return end
        local obj = res[1]
        local sky = obj:IsA("Sky") and obj or obj:FindFirstChildOfClass("Sky")
        if not sky then pcall(function() obj:Destroy() end) notify(T("Skybox"), T("Sky not found"), 3) return end
        local old = Lighting:FindFirstChildOfClass("Sky")
        if old then old:Destroy() end
        Lighting.ClockTime = 14; Lighting.Brightness = 0.5
        sky.Parent = Lighting
        if obj ~= sky then pcall(function() obj:Destroy() end) end
        notify(T("Skybox"), (name or "Skybox")..T(" applied!"), 2)
    end)
end
function Luxt1.skyboxRemove()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
    notify(T("Skybox"), T("Sky removed!"), 2)
end
local SKYBOXES = {
    { "Snow Skybox", 4604073339 }, { "Realistic Space", 136402262 }, { "Purple Nebula", 83555979203508 },
    { "Blue Nebula", 130093177270069 }, { "SpongeBob Sky", 114523453023009 }, { "Night Sky Vibe", 78613024128163 },
    { "Geoz Skybox", 97573261671957 }, { "Asteroid Space", 295604372 },
}

-- ═══ KORBLOX / CHINA HAT / JUMP CIRCLE ═══
function Luxt1.korbloxApply(c)
    local rul = c:FindFirstChild("RightUpperLeg")
    if not rul then return end
    Luxt1.korbloxSaved = Luxt1.korbloxSaved or {}
    if not Luxt1.korbloxSaved[rul] then
        Luxt1.korbloxSaved[rul] = { MeshId = rul:IsA("MeshPart") and rul.MeshId or nil, TextureId = rul:IsA("MeshPart") and rul.TextureId or nil, Trans = rul.Transparency }
    end
    pcall(function() rul.MeshId = "http://www.roblox.com/asset/?id=902942096" end)
    pcall(function() rul.TextureID = "http://www.roblox.com/asset/?id=902843398" end)
    local rll, rf = c:FindFirstChild("RightLowerLeg"), c:FindFirstChild("RightFoot")
    if rll then
        if not Luxt1.korbloxSaved[rll] then Luxt1.korbloxSaved[rll] = { Trans = rll.Transparency } end
        rll.Transparency = 1
    end
    if rf then
        if not Luxt1.korbloxSaved[rf] then Luxt1.korbloxSaved[rf] = { Trans = rf.Transparency } end
        rf.Transparency = 1
    end
end
function Luxt1.korbloxRestore()
    for k, v in pairs(Luxt1.korbloxSaved or {}) do
        if k and k.Parent then
            if v.MeshId then pcall(function() k.MeshId = v.MeshId end) end
            if v.TextureId then pcall(function() k.TextureId = v.TextureId end) end
            if v.Trans then pcall(function() k.Transparency = v.Trans end) end
        end
    end
    Luxt1.korbloxSaved = {}
end
function Luxt1.setKorblox(on)
    F.korblox = on
    if on then
        local c = LocalPlayer.Character
        if c then Luxt1.korbloxApply(c) end
    else Luxt1.korbloxRestore() end
end
function Luxt1.chinaHatRemove(c)
    local c = c or LocalPlayer.Character
    local hat = c and c:FindFirstChild("Luxt1_ChinaHat")
    if hat then hat:Destroy() end
end
function Luxt1.chinaHatCreate(c)
    local head = c and c:FindFirstChild("Head")
    if not head then return end
    Luxt1.chinaHatRemove(c)
    local p = Instance.new("Part")
    p.Name="Luxt1_ChinaHat"; p.Size=Vector3.one; p.Material=Enum.Material.Neon
    p.Transparency=0.2; p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.Massless=true
    p.Color=Color3.fromRGB(255,105,180)
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId="rbxassetid://1033714"
    mesh.Scale=Vector3.new(1.7,1.1,1.7); mesh.Parent=p
    local weld = Instance.new("Weld")
    weld.Part0=head; weld.Part1=p; weld.C0=CFrame.new(0,0.9,0); weld.Parent=p
    local light = Instance.new("PointLight")
    light.Color=Color3.fromRGB(255,105,180); light.Range=12; light.Parent=p
    p.Parent = c
end
function Luxt1.setChinaHat(on)
    F.chinaHat = on
    local c = LocalPlayer.Character
    if on then
        if c and not c:FindFirstChild("Head") then c:WaitForChild("Head", 5) end
        Luxt1.chinaHatCreate(c)
    else Luxt1.chinaHatRemove(c) end
end
function Luxt1.setJumpCircle(on)
    F.jumpCircle = on
    if Luxt1.jcConn then killConn(Luxt1.jcConn) Luxt1.jcConn = nil end
    if on then
        local c = LocalPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            Luxt1.jcConn = hum.StateChanged:Connect(function(_, new)
                if new == Enum.HumanoidStateType.Jumping and F.jumpCircle then
                    local p = Instance.new("Part")
                    p.Anchored=true; p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.CastShadow=false
                    p.Size=Vector3.new(0.5,0.05,0.5)
                    p.CFrame=CFrame.new(hrp.Position - Vector3.new(0,2.8,0) + Vector3.new(0,0.05,0))
                    p.Transparency=1; p.Parent=workspace
                    local sg = Instance.new("SurfaceGui")
                    sg.Face=Enum.NormalId.Top; sg.AlwaysOnTop=true; sg.LightInfluence=0
                    sg.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud=100; sg.Parent=p
                    local im = Instance.new("ImageLabel")
                    im.BackgroundTransparency=1; im.Size=UDim2.fromScale(1,1)
                    im.Image="rbxassetid://133238425773760"; im.ImageColor3=Color3.fromRGB(255,105,180); im.Parent=sg
                    local ti = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    TweenService:Create(p, ti, { Size=Vector3.new(7,0.05,7) }):Play()
                    TweenService:Create(im, ti, { ImageTransparency=1 }):Play()
                    game:GetService("Debris"):AddItem(p, 0.9)
                end
            end)
            track(Luxt1.jcConn)
        end
    end
end

-- ═══ HIDDEN SKINS ═══
function Luxt1.hsWatch(c)
    Luxt1.hiddenFolder = ReplicatedStorage:FindFirstChild("HiddenSkins") or Instance.new("Folder")
    Luxt1.hiddenFolder.Name = "HiddenSkins"; Luxt1.hiddenFolder.Parent = ReplicatedStorage
    Luxt1.hiddenStore = Luxt1.hiddenStore or {}
    local function grab(obj, parent)
        if not F.hideSkins then return end
        if obj.Name == "DisplayRefGun" or obj.Name == "DisplayRefKnife" then
            task.spawn(function()
                local val = nil
                if obj:IsA("ObjectValue") then
                    if not obj.Value then obj:GetPropertyChangedSignal("Value"):Wait() end
                    val = obj.Value
                end
                Luxt1.hiddenStore[obj] = { object=obj, objParent=parent, model=val, modelParent=val and val.Parent or nil }
                if val then val.Parent = Luxt1.hiddenFolder end
                obj.Parent = Luxt1.hiddenFolder
            end)
        end
    end
    for _, ch in ipairs(c:GetChildren()) do grab(ch, c) end
    track(c.ChildAdded:Connect(function(ch) grab(ch, c) end))
end
function Luxt1.hsRestore()
    for _, v in pairs(Luxt1.hiddenStore or {}) do
        if v.model and v.modelParent then v.model.Parent = v.modelParent end
        if v.object and v.objParent then v.object.Parent = v.objParent end
    end
    Luxt1.hiddenStore = {}
end
function Luxt1.setHideSkins(on)
    F.hideSkins = on
    if on then
        local c = LocalPlayer.Character
        if c then Luxt1.hsWatch(c) end
    else Luxt1.hsRestore() end
end
track(LocalPlayer.CharacterAdded:Connect(function(c)
    Luxt1.hiddenStore = {}
    if F.hideSkins then Luxt1.hsWatch(c) end
end))

-- ═══ WATER / ANTICOIN / FADEOFF ═══
local function isWater(i)
    if not i then return false end
    local n = i.Name:lower()
    if n:find("water") or n:find("river") or n:find("ocean") then return true end
    if i:FindFirstChild("Splash") or i:FindFirstChild("HitWater") then return true end
    return false
end
function Luxt1.setWater(on)
    F.water = on
    Luxt1.waterSaved = Luxt1.waterSaved or {}
    Luxt1.waterDisabled = Luxt1.waterDisabled or {}
    if on then
        for _, d in ipairs(workspace:GetDescendants()) do
            if d:IsA("BasePart") then
                local parent = d.Parent
                while parent and parent ~= workspace do
                    if isWater(parent) then
                        if not Luxt1.waterSaved[d] then Luxt1.waterSaved[d] = d.CanTouch end
                        d.CanTouch = false
                        if getconnections then
                            pcall(function()
                                for _, cc in ipairs(getconnections(d.Touched)) do
                                    cc:Disable(); table.insert(Luxt1.waterDisabled, cc)
                                end
                            end)
                        end
                        break
                    end
                    parent = parent.Parent
                end
            end
        end
        track(workspace.DescendantAdded:Connect(function(d)
            if not F.water or not d:IsA("BasePart") then return end
            task.wait()
            local parent = d.Parent
            while parent and parent ~= workspace do
                if isWater(parent) then
                    if not Luxt1.waterSaved[d] then Luxt1.waterSaved[d] = d.CanTouch end
                    d.CanTouch = false
                    break
                end
                parent = parent.Parent
            end
        end))
        notify(T("Water"), T("Water damage OFF"), 2)
    else
        for k, v in pairs(Luxt1.waterSaved) do
            if k and k.Parent then pcall(function() k.CanTouch = v end) end
        end
        Luxt1.waterSaved = {}
        for _, cc in ipairs(Luxt1.waterDisabled) do pcall(function() cc:Enable() end) end
        Luxt1.waterDisabled = {}
        notify(T("Water"), T("Water damage ON"), 2)
    end
end
function Luxt1.setAntiCoin(on)
    F.antiCoin = on
    Luxt1.coinSaved = Luxt1.coinSaved or {}
    if on then
        Luxt1.coinLoopOn = true
        task.spawn(function()
            while Luxt1.coinLoopOn do
                pcall(function()
                    local m2 = workspace:FindFirstChild("Mansion2")
                    m2 = m2 and m2:FindFirstChild("CoinContainer")
                    local function hide(p)
                        if not Luxt1.coinSaved[p] then Luxt1.coinSaved[p] = { Touch=p.CanTouch, Collide=p.CanCollide, Trans=p.Transparency } end
                        p.CanTouch=false; p.CanCollide=false; p.Transparency=1
                    end
                    if m2 then
                        for _, d in ipairs(m2:GetDescendants()) do
                            if d:IsA("BasePart") then hide(d) end
                        end
                    else
                        for _, d in ipairs(workspace:GetDescendants()) do
                            if d:IsA("Model") and d.Name:lower():find("coin") then
                                for _, d2 in ipairs(d:GetDescendants()) do
                                    if d2:IsA("BasePart") then hide(d2) end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
        notify(T("AntiCoin"), T("Coins hidden"), 2)
    else
        Luxt1.coinLoopOn = false
        for k, v in pairs(Luxt1.coinSaved) do
            if k and k.Parent then
                k.CanTouch=v.Touch; k.CanCollide=v.Collide; k.Transparency=v.Trans
            end
        end
        Luxt1.coinSaved = {}
        notify(T("AntiCoin"), T("Coins restored"), 2)
    end
end
function Luxt1.setFadeOff(on)
    F.fadeOff = on
    if on then
        Luxt1.fadeFolder = ReplicatedStorage:FindFirstChild("SavedFadeGuis") or Instance.new("Folder")
        Luxt1.fadeFolder.Name="SavedFadeGuis"; Luxt1.fadeFolder.Parent=ReplicatedStorage
        Luxt1.fadeSaved = Luxt1.fadeSaved or {}
        local function grab(d)
            if d:IsA("GuiObject") and (d.Name=="CameraFade" or d.Name=="Fade" or d.Name=="SpawnFade") then
                if not Luxt1.fadeSaved[d] then Luxt1.fadeSaved[d] = d.Parent end
                d.Parent = Luxt1.fadeFolder
            end
        end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, d in ipairs(pg:GetDescendants()) do grab(d) end
            if not Luxt1.fadeConn then Luxt1.fadeConn = pg.DescendantAdded:Connect(grab) track(Luxt1.fadeConn) end
        end
        notify(T("FadeDisabler"), T("Fades hidden"), 2)
    else
        if Luxt1.fadeConn then killConn(Luxt1.fadeConn) Luxt1.fadeConn = nil end
        for k, v in pairs(Luxt1.fadeSaved or {}) do
            if k and k.Parent == Luxt1.fadeFolder then
                if v and v:IsDescendantOf(game) then k.Parent = v
                else k.Parent = LocalPlayer:WaitForChild("PlayerGui") end
            end
        end
        Luxt1.fadeSaved = {}
        notify(T("FadeDisabler"), T("Fades restored"), 2)
    end
end

-- ═══ FPS BOOST / REJOIN / VOID ═══
function Luxt1.fpsBoost()
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize=0; terrain.WaterWaveSpeed=0; terrain.WaterReflectance=0
    end
    Lighting.GlobalShadows=false; Lighting.FogEnd=9e9
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    for _, d in pairs(game:GetDescendants()) do
        if d:IsA("BasePart") then d.Material=Enum.Material.Plastic; d.Reflectance=0
        elseif d:IsA("Decal") then d.Transparency=1
        elseif d:IsA("ParticleEmitter") or d:IsA("Trail") then d.Lifetime=NumberRange.new(0) end
    end
    for _, d in pairs(Lighting:GetDescendants()) do
        if d:IsA("BlurEffect") or d:IsA("SunRaysEffect") or d:IsA("ColorCorrectionEffect") or d:IsA("BloomEffect") then d.Enabled=false end
    end
    notify(T("Misc"), T("FPS Boost applied!"), 3)
end
function Luxt1.rejoin()
    local placeId, jobId = game.PlaceId, game.JobId
    notify(T("Rejoin"), T("Rejoining..."), 3)
    if #Players:GetPlayers() <= 1 then
        LocalPlayer:Kick("\nRejoining...")
        task.wait()
        TeleportService:Teleport(placeId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
    end
end
function Luxt1.infiniteVoid()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/InfiniteVoid"))()
    end)
    notify(T("Infinite Void"), T("Script executed"), 2)
end

-- ═══ CUSTOM GUN MODEL ═══
local GUN_MODELS = {
    AWP={id="4531395275", rot=CFrame.Angles(0,0,0), pos=CFrame.new(0,0,-0.5)},
    Pistol={id="5102714039", rot=CFrame.Angles(0,math.pi,0), pos=CFrame.new(0,0,0.5)},
    Shotgun={id="5294131243", rot=CFrame.Angles(0,math.pi,0), pos=CFrame.new(0,0,0.8)},
    RayGun={id="542699703", rot=CFrame.Angles(0,math.pi,0), pos=CFrame.new(0,0,0.2)},
    ["AK-47"]={id="127200798279812", rot=CFrame.Angles(math.pi/2,0,-math.pi/2), pos=CFrame.new(0,-0.3,0.3)},
    PinkGun={id="18610978709", rot=CFrame.Angles(0,0,0), pos=CFrame.new(0,0,-0.3)},
    FlameGun={id="10656806096", rot=CFrame.Angles(-math.pi/2,math.pi/2,math.pi/2), pos=CFrame.new(2.1,0,-0.3)},
    MiniBlackGun={id="62932622", rot=CFrame.Angles(math.pi/2,0,0), pos=CFrame.new(0,0,0)},
    BlueGun={id="87594143804300", rot=CFrame.Angles(-math.pi/2,math.pi/2,math.pi/2), pos=CFrame.new(0,-0.3,0.5)},
    ["BigUSP-S"]={id="12899296613", rot=CFrame.Angles(0,0,0), pos=CFrame.new(0,0,-1.3)},
    GreenGun={id="1297856838", rot=CFrame.Angles(math.pi/2,0,0), pos=CFrame.new(0,-0.3,0)},
}
local gunModelCache = {}
local function loadGunModel(id)
    local key = tostring(id)
    if gunModelCache[key] then return gunModelCache[key]:Clone() end
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://"..key) end)
    if ok and res and #res > 0 then gunModelCache[key] = res[1] return res[1]:Clone() end
    return nil
end
local function gunRestore(tool)
    local cm = tool and tool:FindFirstChild("CustomGunModel")
    if cm then cm:Destroy() end
    for _, d in ipairs(tool:GetDescendants()) do
        if d:IsA("BasePart") then d.Transparency = 0
        elseif d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 0 end
    end
end
local function gunApply(tool)
    if not tool or not tool:IsA("Tool") or tool.Name ~= "Gun" then return end
    if F.gunModel == "None" or not GUN_MODELS[F.gunModel] then gunRestore(tool) return end
    local c = LocalPlayer.Character
    if not c or tool.Parent ~= c then return end
    local hand = c:FindFirstChild("RightHand") or c:FindFirstChild("Right Arm")
    if not hand then return end
    local old = tool:FindFirstChild("CustomGunModel")
    if old then old:Destroy() end
    local def = GUN_MODELS[F.gunModel]
    local model = loadGunModel(def.id)
    if not model then return end
    model.Name = "CustomGunModel"
    for _, d in ipairs(tool:GetDescendants()) do
        if (d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture")) and not d:IsDescendantOf(model) then d.Transparency = 1 end
    end
    local base = model:IsA("BasePart") and model or model.PrimaryPart or model:FindFirstChild("Handle") or model:FindFirstChildWhichIsA("BasePart", true)
    if not base then model:Destroy() return end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then d.CanCollide=false; d.Anchored=false; d.Massless=true end
    end
    local r15 = c:FindFirstChild("UpperTorso") ~= nil
    local cf = hand.CFrame * (r15 and CFrame.new(0,-0.25,-0.1) or CFrame.new(0,-1,-0.1)) * CFrame.Angles(-math.pi/2,0,0) * def.rot * def.pos
    if model:IsA("Model") then model:PivotTo(cf) else model.CFrame = cf end
    local wc = Instance.new("WeldConstraint"); wc.Part0=hand; wc.Part1=base; wc.Parent=base
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and d ~= base then
            local w = Instance.new("WeldConstraint"); w.Part0=base; w.Part1=d; w.Parent=d
        end
    end
    model.Parent = tool
end
function Luxt1.gunApplyAll()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local g1 = bp and bp:FindFirstChild("Gun")
    local g2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")
    if g1 then if F.gunModel ~= "None" then gunApply(g1) else gunRestore(g1) end end
    if g2 then if F.gunModel ~= "None" then gunApply(g2) else gunRestore(g2) end end
end
local function gunWatch(container)
    if not container then return end
    local function setup(tool)
        tool.Equipped:Connect(function()
            if F.gunModel ~= "None" then task.wait(0.02) gunApply(tool) end
        end)
        tool.Unequipped:Connect(function()
            local cm = tool:FindFirstChild("CustomGunModel")
            if cm then cm:Destroy() end
        end)
        if F.gunModel ~= "None" and tool.Parent == LocalPlayer.Character then gunApply(tool) end
    end
    track(container.ChildAdded:Connect(function(ch)
        if ch:IsA("Tool") and ch.Name == "Gun" then task.wait(0.05) setup(ch) end
    end))
    local g = container:FindFirstChild("Gun")
    if g then setup(g) end
end
do
    local bp = LocalPlayer:WaitForChild("Backpack", 5)
    if bp then gunWatch(bp) end
    if LocalPlayer.Character then gunWatch(LocalPlayer.Character) end
    track(LocalPlayer.CharacterAdded:Connect(function(c) gunWatch(c) end))
end

-- ═══ GUN BEAMS ═══
local function beamLine(a, b, w, color)
    local m = (b - a).Magnitude
    if m < 1 then return end
    local p = Instance.new("Part")
    p.Anchored=true; p.CanCollide=false; p.Material=Enum.Material.Neon
    p.Color=color or F.beamColor; p.Shape=Enum.PartType.Cylinder
    p.Size=Vector3.new(m, w, w)
    p.CFrame=CFrame.lookAt(a, b) * CFrame.new(0,0,-m/2) * CFrame.Angles(0, math.pi/2, 0)
    p.Parent=workspace.Terrain
    TweenService:Create(p, TweenInfo.new(0.22, Enum.EasingStyle.Quad), { Size=Vector3.new(m,0,0), Transparency=1 }):Play()
    task.delay(0.25, function() p:Destroy() end)
end
local function beamTransform(bm)
    if not bm:IsA("Beam") or F.beamType == "Default" then return end
    local a0, a1 = bm.Attachment0, bm.Attachment1
    if not (a0 and a1) then return end
    local from, to = a0.WorldPosition, a1.WorldPosition
    if not (from and to) then return end
    if F.beamType == "Neon Fat" then
        bm.Width0=1.8; bm.Width1=1.2
        bm.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(0.2,F.beamColor), ColorSequenceKeypoint.new(1,F.beamColor)})
        beamLine(from, to, 1)
    elseif F.beamType == "Nuke" then
        bm.Width0=1.4; bm.Width1=0.8
        bm.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(0.1,F.beamColor), ColorSequenceKeypoint.new(1,F.beamColor)})
        beamLine(from, to, 0.8)
    elseif F.beamType == "Zigzag Light" then
        bm.Width0=0.1; bm.Width1=0.1
        local n = math.clamp(math.floor((to-from).Magnitude/6), 4, 12)
        local cur = from
        for i = 1, n do
            local nxt = from:Lerp(to, i/n)
            if i < n then nxt += Vector3.new(math.random(-2,2), math.random(-2,2), math.random(-2,2)) end
            beamLine(cur, nxt, 0.4, F.beamColor)
            cur = nxt
        end
    elseif F.beamType == "Rainbow RGB" then
        bm.Width0=1.8; bm.Width1=1.2
        bm.Color=ColorSequence.new({ ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(0.75,Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255)) })
        beamLine(from, to, 1, Color3.fromRGB(255,255,255))
    else
        bm.Color = ColorSequence.new(F.beamColor)
    end
end
track(workspace.DescendantAdded:Connect(function(d)
    if d:IsA("Beam") and F.beamType ~= "Default" then task.wait() pcall(beamTransform, d) end
end))

-- ═══ AURAS ═══
function Luxt1.auraClear()
    if Luxt1.activeAura then
        for _, v in ipairs(Luxt1.activeAura) do
            if v and v.Parent then pcall(function() v:Destroy() end) end
        end
        Luxt1.activeAura = nil; Luxt1.activeAuraName = nil
    end
end
local function tintSeq(seq)
    local kp = {}
    for _, key in ipairs(seq.Keypoints) do
        local v = key.Value
        table.insert(kp, ColorSequenceKeypoint.new(key.Time,
            Color3.new(v.R*AURA_COLOR.R, v.G*AURA_COLOR.G, v.B*AURA_COLOR.B)))
    end
    return ColorSequence.new(kp)
end
function Luxt1.auraApply(assetId, name, force)
    if not force and Luxt1.activeAuraName == name then
        Luxt1.auraClear(); Luxt1.pendingAura = nil
        notify(T("Auras"), name..T(" off"), 2)
        return
    end
    Luxt1.auraClear()
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://"..assetId) end)
    if not ok or #res == 0 then notify(T("Auras"), T("Failed to load ")..name, 3) return end
    local model = res[1]
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then d:Destroy()
        elseif d:IsA("ParticleEmitter") then d.LightEmission=1; d.Rate=math.clamp(d.Rate*0.35,1,40) end
    end
    local c = LocalPlayer.Character
    local torso = c and (c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso"))
    if not torso then notify(T("Auras"), T("Character not ready!"), 3) return end
    local list = {}
    local mult = name == "Red Shield" and 4 or 1
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ParticleEmitter") or d:IsA("Highlight") or d:IsA("Beam") or d:IsA("Trail") or d:IsA("Attachment") then
            local cl = d:Clone()
            if cl:IsA("ParticleEmitter") then
                local lt = cl.Lifetime
                cl.Lifetime = NumberRange.new(lt.Min*mult, lt.Max*mult)
                if name == "Red Shield" then cl.LockedToPart = true end
                pcall(function() cl.Color = tintSeq(cl.Color) end)
            elseif cl:IsA("Beam") or cl:IsA("Trail") then
                pcall(function() cl.Color = tintSeq(cl.Color) end)
            end
            cl.Parent = torso
            table.insert(list, cl)
        end
    end
    model:Destroy()
    Luxt1.activeAura = list; Luxt1.activeAuraName = name
    Luxt1.pendingAura = { assetId = assetId, name = name }
    notify(T("Auras"), name..T(" on!"), 2)
end
local AURAS = {
    { "Crimson King", "11955208820" }, { "Daemon of Cards", "10373359918" }, { "Angel Wings", "97658130917593" },
    { "Starlight", "134645216613107" }, { "Heavenly", "139300897520961" }, { "Ribbon", "132069507632161" },
    { "Wind", "80694081850877" }, { "Flow", "119913533725648" }, { "Star", "73754563740680" },
}

-- ═══ PLAYERS ESP ═══
local ESP_COLORS = {
    Murderer=Color3.fromRGB(225,45,45), Sheriff=Color3.fromRGB(55,130,255),
    Hero=Color3.fromRGB(255,215,55), Innocent=Color3.fromRGB(70,220,120), Dead=Color3.fromRGB(100,100,100),
    Friend=Color3.fromRGB(60,255,170),
}
function Luxt1.espColorOf(plr)
    if not MM2.alive(plr) then return ESP_COLORS.Dead end
    local role = MM2.norm(plr.Name)
    if role == "Murderer" then return ESP_COLORS.Murderer end
    if role == "Sheriff" then return ESP_COLORS.Sheriff end
    if role == "Hero" and MM2.sher == "" then return ESP_COLORS.Hero end
    if F.friendCheck then
        local ok, isF = pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
        if ok and isF then return ESP_COLORS.Friend end
    end
    return ESP_COLORS.Innocent
end
local nameTags = {}
local function espNameTag(plr, c)
    local head = c:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("Luxt1_PlayerName")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name="Luxt1_PlayerName"; bb.Adornee=head
    bb.Size=UDim2.fromOffset(220,24); bb.StudsOffset=Vector3.new(0,2.65,0)
    bb.AlwaysOnTop=true; bb.ResetOnSpawn=false; bb.Parent=head
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency=1; lbl.Size=UDim2.fromScale(1,1)
    lbl.Font=FONT; lbl.TextSize=12; lbl.Text=plr.DisplayName
    lbl.TextColor3=Color3.fromRGB(245,242,238)
    lbl.TextStrokeColor3=Color3.fromRGB(0,0,0); lbl.TextStrokeTransparency=0.65
    lbl.Parent=bb
    nameTags[plr] = { Billboard=bb, Label=lbl }
end
function Luxt1.setPlayersESP(on)
    F.playersESP = on
    if not on then
        for _, plr in ipairs(Players:GetPlayers()) do
            local c = plr.Character
            local hl = c and c:FindFirstChild("Highlight")
            if hl then hl:Destroy() end
            local head = c and c:FindFirstChild("Head")
            local tag = head and head:FindFirstChild("Luxt1_PlayerName")
            if tag then tag:Destroy() end
            nameTags[plr] = nil
        end
        return
    end
    if Luxt1.espLoopOn then return end
    Luxt1.espLoopOn = true
    task.spawn(function()
        while F.playersESP do
            MM2.refresh()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local c = plr.Character
                    local hl = c:FindFirstChild("Highlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name="Highlight"; hl.Parent=c
                    end
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillTransparency = 0.92; hl.OutlineTransparency = 0.04
                    hl.Enabled = true
                    local col = Luxt1.espColorOf(plr)
                    hl.FillColor = col; hl.OutlineColor = col
                    local head = c:FindFirstChild("Head")
                    local tag = head and head:FindFirstChild("Luxt1_PlayerName")
                    if not nameTags[plr] or not nameTags[plr].Billboard or not nameTags[plr].Billboard.Parent or not tag then
                        nameTags[plr] = nil
                        espNameTag(plr, c)
                    end
                end
            end
            task.wait(0.25)
        end
        Luxt1.espLoopOn = false
    end)
end
track(Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() nameTags[plr] = nil end)
end))

-- ═══ GUN ESP / TRAPS ═══
local function onGunDrop(descendant)
    if F.gunESP then
        local hl = descendant:FindFirstChild("Luxt1_GunHighlight")
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name="Luxt1_GunHighlight"; hl.Parent=descendant
        end
        hl.FillColor=Color3.fromRGB(255,215,55); hl.OutlineColor=Color3.fromRGB(255,215,55)
        hl.FillTransparency=0.92; hl.OutlineTransparency=0.04
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        notify(T("ESP"), T("Gun dropped!"), 3)
    end
    if F.autoGetGun then
        task.spawn(function()
            if MM2.amIMurd() then return end
            local c = LocalPlayer.Character
            if not c then return end
            local base = descendant:IsA("BasePart") and descendant or descendant:FindFirstChildWhichIsA("BasePart", true)
            for _ = 1, 20 do
                if not base then task.wait(0.05) base = descendant:IsA("BasePart") and descendant or descendant:FindFirstChildWhichIsA("BasePart", true)
                else break end
            end
            if not base then return end
            if F.pickup == "Remote" then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp and firetouchinterest then
                    task.wait(0.2)
                    pcall(function()
                        firetouchinterest(hrp, base, 0); task.wait(0.05); firetouchinterest(hrp, base, 1)
                    end)
                end
            else
                local pivot = c:GetPivot()
                c:PivotTo(base:GetPivot())
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then bp.ChildAdded:Wait() end
                c:PivotTo(pivot)
            end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then bp.ChildAdded:Wait() end
            notify(T("Auto-gun"), T("Gun picked up!"), 3)
        end)
    end
end
track(workspace.DescendantAdded:Connect(function(d)
    if d.Name == "GunDrop" then task.spawn(function() task.wait(0.05) onGunDrop(d) end) end
end))
function Luxt1.setTrapsESP(on)
    F.trapsESP = on
    if not on then
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name == "Luxt1_TrapHL" then d:Destroy() end
        end
        return
    end
    if Luxt1.trapsLoopOn then return end
    Luxt1.trapsLoopOn = true
    task.spawn(function()
        while F.trapsESP do
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("BasePart") and d.Name:lower():find("trap") and not d:FindFirstChild("Luxt1_TrapHL") then
                    local hl = Instance.new("Highlight")
                    hl.Name="Luxt1_TrapHL"; hl.FillColor=Color3.fromRGB(255,120,255)
                    hl.OutlineColor=Color3.fromRGB(255,120,255)
                    hl.FillTransparency=0.7; hl.OutlineTransparency=0.1
                    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent=d
                end
            end
            task.wait(0.5)
        end
        Luxt1.trapsLoopOn = false
    end)
end

-- ═══ TARGET ESP + HUD ═══
function Luxt1.getTarget()
    local c, hrp = getChar()
    if not (c and hrp) then return nil end
    local function valid(plr)
        if not plr or plr == LocalPlayer or not plr.Character then return false end
        local h = plr.Character:FindFirstChildOfClass("Humanoid")
        return h and h.Health > 0 and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil
    end
    local function dead(name)
        local r = MM2.roles[name]
        return r and (r.Killed or r.Dead) or false
    end
    if MM2.amIMurd() then
        if MM2.sher ~= "" then
            local p = Players:FindFirstChild(MM2.sher)
            if p and valid(p) and not dead(MM2.sher) then return p end
        end
        if MM2.hero ~= "" then
            local p = Players:FindFirstChild(MM2.hero)
            if p and valid(p) and not dead(MM2.hero) then return p end
        end
    else
        if MM2.murd ~= "" then
            local p = Players:FindFirstChild(MM2.murd)
            if p and valid(p) and not dead(MM2.murd) then return p end
        end
    end
    return MM2.nearest()
end
local targetUI = { espGui=nil, espFrame=nil, espCorners=nil, hudGui=nil, hudFrame=nil, HUD={},
    lastEspPlayer=nil, lastEspHp=nil, espDmgT=0, lastHudPlayer=nil, lastHudHp=nil, hudDmgT=0 }
local function createEspGui()
    if targetUI.espGui and targetUI.espGui.Parent then return end
    targetUI.espGui = Instance.new("ScreenGui")
    targetUI.espGui.Name="Luxt1_TargetESP"; targetUI.espGui.ResetOnSpawn=false; targetUI.espGui.IgnoreGuiInset=true
    pcall(function() targetUI.espGui.Parent = game:GetService("CoreGui") end)
    if not targetUI.espGui.Parent then targetUI.espGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    targetUI.espFrame = Instance.new("Frame")
    targetUI.espFrame.BackgroundTransparency=1; targetUI.espFrame.AnchorPoint=Vector2.new(0.5,0.5)
    targetUI.espFrame.Visible=false; targetUI.espFrame.Parent=targetUI.espGui
    local function mkCorner(pos)
        local holder = Instance.new("Frame", targetUI.espFrame)
        holder.Size=UDim2.new(0.3,0,0.3,0); holder.Position=pos; holder.BackgroundTransparency=1
        local h1 = Instance.new("Frame", holder)
        h1.BorderSizePixel=0; h1.ZIndex=6; h1.Size=UDim2.new(1,0,0,0)
        h1.Position = pos.Y.Scale > 0 and UDim2.new(0,0,1,0) or UDim2.new(0,0,0,0)
        local v1 = Instance.new("Frame", holder)
        v1.BorderSizePixel=0; v1.ZIndex=6; v1.Size=UDim2.new(0,0,1,0)
        v1.Position = pos.X.Scale > 0 and UDim2.new(1,0,0,0) or UDim2.new(0,0,0,0)
        local s1 = Instance.new("UIStroke", h1); s1.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        local s2 = Instance.new("UIStroke", v1); s2.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        return { s1, s2 }
    end
    targetUI.espCorners = { mkCorner(UDim2.new(0,0,0,0)), mkCorner(UDim2.new(0.7,0,0,0)), mkCorner(UDim2.new(0,0,0.7,0)), mkCorner(UDim2.new(0.7,0,0.7,0)) }
end
local function createHudGui()
    if targetUI.hudGui and targetUI.hudGui.Parent then return end
    targetUI.hudGui = Instance.new("ScreenGui")
    targetUI.hudGui.Name="Luxt1_TargetHUD"; targetUI.hudGui.ResetOnSpawn=false; targetUI.hudGui.IgnoreGuiInset=true
    pcall(function() targetUI.hudGui.Parent = game:GetService("CoreGui") end)
    if not targetUI.hudGui.Parent then targetUI.hudGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local fr = Instance.new("Frame", targetUI.hudGui)
    fr.Size=UDim2.new(0,235,0,75); fr.Position=UDim2.new(0.5,50,0.5,50)
    fr.BackgroundColor3=BG_MAIN; fr.BackgroundTransparency=0.15; fr.BorderSizePixel=0
    fr.Visible=false; fr.Active=true; fr.Draggable=true
    corner(fr, 10)
    stroke(fr, ACCENT, 1.2, 0.2)
    local glow = Instance.new("Frame", fr)
    glow.Size=UDim2.new(1,6,1,6); glow.Position=UDim2.new(0,-3,0,-3)
    glow.BackgroundColor3=ACCENT; glow.BackgroundTransparency=0.92; glow.ZIndex=fr.ZIndex-1
    corner(glow, 12)
    local logo = Instance.new("ImageLabel", fr)
    logo.Size=UDim2.new(0,18,0,18); logo.Position=UDim2.new(1,-24,0,6)
    logo.BackgroundTransparency=1; logo.Image=img(ASSETS.logo); logo.ZIndex=5
    local avBg = Instance.new("Frame", fr)
    avBg.Size=UDim2.new(0,56,0,56); avBg.Position=UDim2.new(0,9,0,9)
    avBg.BackgroundColor3=Color3.fromRGB(15,17,24); avBg.BackgroundTransparency=0.2; avBg.BorderSizePixel=0
    avBg.ClipsDescendants=true; corner(avBg, 8); stroke(avBg, ACCENT, 1, 0.6)
    local av = Instance.new("ImageLabel", avBg)
    av.Size=UDim2.new(1.1,0,1.1,0); av.Position=UDim2.new(-0.05,0,-0.05,0)
    av.BackgroundTransparency=1; av.ScaleType=Enum.ScaleType.Crop
    local nameL = Instance.new("TextLabel", fr)
    nameL.Size=UDim2.new(1,-100,0,18); nameL.Position=UDim2.new(0,72,0,8)
    nameL.BackgroundTransparency=1; nameL.TextColor3=TEXT; nameL.Font=FONT_BOLD
    nameL.TextSize=13; nameL.TextXAlignment=Enum.TextXAlignment.Left; nameL.TextTruncate=Enum.TextTruncate.AtEnd
    local roleL = Instance.new("TextLabel", fr)
    roleL.Size=UDim2.new(1,-110,0,14); roleL.Position=UDim2.new(0,72,0,27)
    roleL.BackgroundTransparency=1; roleL.TextColor3=TEXT_DIM; roleL.Font=FONT_BOLD
    roleL.TextSize=11; roleL.TextXAlignment=Enum.TextXAlignment.Left
    local hpL = Instance.new("TextLabel", fr)
    hpL.Size=UDim2.new(0,50,0,14); hpL.Position=UDim2.new(1,-58,0,27)
    hpL.BackgroundTransparency=1; hpL.TextColor3=TEXT_DIM; hpL.Font=FONT_BOLD
    hpL.TextSize=11; hpL.TextXAlignment=Enum.TextXAlignment.Right
    local barBg = Instance.new("Frame", fr)
    barBg.Size=UDim2.new(1,-80,0,8); barBg.Position=UDim2.new(0,72,0,48)
    barBg.BackgroundColor3=Color3.fromRGB(15,17,24); barBg.BorderSizePixel=0
    corner(barBg, 4); stroke(barBg, OUTLINE, 1, 0.5)
    local bar = Instance.new("Frame", barBg)
    bar.Size=UDim2.new(1,0,1,0); bar.BackgroundColor3=Color3.fromRGB(255,255,255); bar.BorderSizePixel=0
    corner(bar, 4)
    local grad = Instance.new("UIGradient", bar)
    grad.Color = ColorSequence.new(ACCENT, ACCENT_BRIGHT)
    targetUI.hudFrame = fr
    targetUI.HUD = { frame=fr, avatar=av, name=nameL, role=roleL, hp=hpL, bar=bar, grad=grad }
end
local function updateEsp(plr)
    if not targetUI.espFrame then return end
    local cam = workspace.CurrentCamera
    if not cam then targetUI.espFrame.Visible=false return end
    if not plr or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
        targetUI.espFrame.Visible=false; targetUI.lastEspPlayer=nil; return
    end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then targetUI.espFrame.Visible=false; targetUI.lastEspPlayer=nil; return end
    if targetUI.lastEspPlayer ~= plr.UserId then
        targetUI.lastEspPlayer = plr.UserId; targetUI.lastEspHp = hum.Health; targetUI.espDmgT = 0
    end
    if targetUI.lastEspHp and hum.Health < targetUI.lastEspHp then targetUI.espDmgT = tick() end
    targetUI.lastEspHp = hum.Health
    local pos, onScreen = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
    if not onScreen then targetUI.espFrame.Visible=false return end
    targetUI.espFrame.Visible = true
    local base = Color3.fromRGB(255,0,0)
    local dt = tick() - targetUI.espDmgT
    local col = dt < 0.6 and Color3.fromRGB(255,255,255):Lerp(base, dt/0.6) or base
    targetUI.espFrame.Position = UDim2.new(0, pos.X, 0, pos.Y)
    targetUI.espFrame.Size = UDim2.new(0, 45, 0, 45)
    targetUI.espFrame.Rotation = tick() * 60 % 360
    for _, cs in pairs(targetUI.espCorners) do
        cs[1].Thickness=2.5; cs[2].Thickness=2.5
        cs[1].Color=col; cs[2].Color=col
    end
end
local function updateHud(plr)
    if not targetUI.hudFrame then return end
    if not plr or not plr.Character then
        if targetUI.hudFrame.Visible then targetUI.hudFrame.Visible=false; targetUI.lastHudPlayer=nil end
        return
    end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then
        if targetUI.hudFrame.Visible then targetUI.hudFrame.Visible=false; targetUI.lastHudPlayer=nil end
        return
    end
    targetUI.hudFrame.Visible = true
    local HUD = targetUI.HUD
    if targetUI.lastHudPlayer ~= plr.UserId then
        targetUI.lastHudPlayer = plr.UserId
        HUD.name.Text = plr.DisplayName
        HUD.avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..plr.UserId.."&w=150&h=150"
    end
    local role = MM2.norm(plr.Name)
    local col, text = Color3.fromRGB(0,225,100), T("Innocent")
    if role == "Murderer" then col, text = Color3.fromRGB(255,50,50), T("Murderer")
    elseif role == "Sheriff" then col, text = Color3.fromRGB(50,150,255), T("Sheriff")
    elseif role == "Hero" then col, text = Color3.fromRGB(255,215,0), T("Hero")
    elseif role == "Dead" then col, text = Color3.fromRGB(130,130,130), T("Dead") end
    HUD.role.Text = text; HUD.role.TextColor3 = col
    if targetUI.lastHudHp and hum.Health < targetUI.lastHudHp then targetUI.hudDmgT = tick() end
    targetUI.lastHudHp = hum.Health
    local hp = math.clamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
    local dt = tick() - targetUI.hudDmgT
    local barCol = dt < 0.3 and Color3.fromRGB(255,255,255):Lerp(col, dt/0.3) or col
    HUD.grad.Color = ColorSequence.new(barCol:Lerp(Color3.fromRGB(0,0,0), 0.2), barCol)
    tween(HUD.bar, { Size = UDim2.new(hp, 0, 1, 0) }, 0.15, Enum.EasingStyle.Quart)
    HUD.hp.Text = string.format("%.0f HP", hum.Health)
end
track(RunService.RenderStepped:Connect(function()
    if not F.targetESP and not F.targetHUD then
        if targetUI.espFrame then targetUI.espFrame.Visible=false end
        if targetUI.hudFrame then targetUI.hudFrame.Visible=false end
        return
    end
    if not MM2._next or tick() >= MM2._next then
        MM2._next = tick() + 0.5
        MM2.refresh()
    end
    local target = Luxt1.getTarget()
    if F.targetHUD then createHudGui() updateHud(target) end
    if F.targetESP then createEspGui() updateEsp(target) end
end))

-- ═══ BOX ESP ═══
function Luxt1.setBoxESP(on)
    F.boxESP = on
    if not on then
        for _, v in pairs(Luxt1.boxUI or {}) do pcall(function() v.root:Destroy() end) end
        Luxt1.boxUI = {}
        return
    end
    if Luxt1.boxGui and Luxt1.boxGui.Parent then return end
    Luxt1.boxGui = Instance.new("ScreenGui")
    Luxt1.boxGui.Name="Luxt1_BoxESP"; Luxt1.boxGui.ResetOnSpawn=false; Luxt1.boxGui.IgnoreGuiInset=true
    pcall(function() Luxt1.boxGui.Parent = game:GetService("CoreGui") end)
    if not Luxt1.boxGui.Parent then Luxt1.boxGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    Luxt1.boxUI = {}
    local function mk(plr)
        local root = Instance.new("Frame", Luxt1.boxGui)
        root.BackgroundTransparency=1; root.Visible=false
        local box = Instance.new("Frame", root)
        box.BackgroundTransparency=0.75; box.BackgroundColor3=Color3.fromRGB(0,0,0); box.BorderSizePixel=0
        stroke(box, Color3.fromRGB(155,125,175), 1.4, 0.15)
        local nm = Instance.new("TextLabel", root)
        nm.BackgroundTransparency=1; nm.Size=UDim2.new(0,140,0,16); nm.AnchorPoint=Vector2.new(0.5,0)
        nm.Font=FONT_BOLD; nm.TextSize=11; nm.TextColor3=Color3.fromRGB(255,255,255)
        nm.TextStrokeTransparency=0.2
        local ds = Instance.new("TextLabel", root)
        ds.BackgroundTransparency=1; ds.Size=UDim2.new(0,140,0,14); ds.AnchorPoint=Vector2.new(0.5,1)
        ds.Position=UDim2.new(0.5,0,1,0); ds.Font=FONT; ds.TextSize=10
        ds.TextColor3=Color3.fromRGB(255,255,255); ds.TextStrokeTransparency=0.2
        Luxt1.boxUI[plr] = { root=root, box=box, name=nm, dist=ds }
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then mk(plr) end
    end
    track(Players.PlayerAdded:Connect(function(plr) if plr ~= LocalPlayer then mk(plr) end end))
    track(RunService.RenderStepped:Connect(function()
        if not F.boxESP then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        for plr, ui in pairs(Luxt1.boxUI or {}) do
            local c = plr.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = cam:WorldToScreenPoint(hrp.Position)
                local dist = (cam.CFrame.Position - hrp.Position).Magnitude
                if onScreen and dist <= 300 then
                    local h = hrp.Size.Y * cam.ViewportSize.Y / pos.Z * 2
                    local w = h * 0.62
                    ui.root.Visible = true
                    ui.root.Position = UDim2.fromOffset(pos.X - w/2, pos.Y - h/2)
                    ui.root.Size = UDim2.fromOffset(w, h)
                    ui.box.Size = UDim2.fromScale(1,1)
                    ui.name.Position = UDim2.new(0.5, 0, 0, -18)
                    ui.name.Text = plr.DisplayName .. " · " .. (MM2.norm(plr.Name) or "?")
                    ui.name.TextColor3 = Luxt1.espColorOf(plr)
                    ui.dist.Text = math.floor(dist) .. " studs"
                else ui.root.Visible = false end
            else ui.root.Visible = false end
        end
    end))
end

-- ═══ COMBAT ═══
function Luxt1.equipFromBP(name)
    local c = LocalPlayer.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local tool = c and c:FindFirstChild(name) or bp and bp:FindFirstChild(name)
    if tool and hum and tool.Parent ~= c then hum:EquipTool(tool) task.wait(0.05) end
    return c and c:FindFirstChild(name)
end
function Luxt1.slashTouch(plr)
    local c = LocalPlayer.Character
    local knife = c and c:FindFirstChild("Knife") or Luxt1.equipFromBP("Knife")
    if not (knife and c) then return false end
    local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp2 then return false end
    local knife2 = c:FindFirstChild("Knife")
    local handle = knife2 and knife2:FindFirstChild("Handle")
    if not handle then return false end
    pcall(function()
        if knife2:FindFirstChild("Stab") and knife2.Stab:IsA("RemoteEvent") then
            knife2.Stab:FireServer("Slash")
        else
            knife2:Activate()
        end
        firetouchinterest(handle, hrp2, 0)
        task.wait()
        firetouchinterest(handle, hrp2, 1)
    end)
    return true
end
function Luxt1.throwKnifeAt(plr)
    local c = LocalPlayer.Character
    if not c then return end
    local knife = c:FindFirstChild("Knife") or Luxt1.equipFromBP("Knife")
    if not knife then notify(T("Error"), T("No knife"), 3) return end
    if not plr or not plr.Character then notify(T("Error"), T("Player not found"), 3) return end
    pcall(function()
        local ev = knife.Events.KnifeThrown
        local origin = CFrame.new(c.RightHand.Position)
        local pred = CFrame.new(MM2.predict(plr, F.shootOff + 1))
        ev:FireServer(origin, pred)
    end)
    notify(T("Knife"), T("Thrown at ")..plr.Name, 3)
end
function Luxt1.silentShoot()
    local target = MM2.shootTarget()
    if not target then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and findTool(plr, "Knife") then target = plr break end
        end
    end
    if not target then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and MM2.norm(plr.Name) == "Murderer" and MM2.alive(plr) then target = plr break end
        end
    end
    if not target or not target.Character then return end
    local gun = Luxt1.equipFromBP("Gun")
    if not gun then return end
    local c = LocalPlayer.Character
    local myHRP = c:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local tChar = target.Character
    local aimPart = tChar:FindFirstChild("Head")
    if not aimPart then aimPart = tChar:FindFirstChild("UpperTorso") end
    if not aimPart then aimPart = tChar:FindFirstChild("Torso") end
    if not aimPart then aimPart = tChar:FindFirstChild("HumanoidRootPart") end
    if not aimPart then return end
    local tHRP = tChar:FindFirstChild("HumanoidRootPart")
    local vel = tHRP and tHRP.AssemblyLinearVelocity or Vector3.zero
    local from = c:FindFirstChild("RightHand") and c.RightHand.Position or myHRP.Position

    -- 3-shot prediction: direct + smart + medium lead
    local to1 = aimPart.Position
    local to2 = Luxt1.smartAim(target) or (aimPart.Position + vel * 0.08)
    local to3 = aimPart.Position + vel * 0.1

    if F.tracer.on then Luxt1.spawnTracerFX(from, to2) end
    pcall(function() gun.Shoot:FireServer(CFrame.new(from), CFrame.new(to1)) end)
    pcall(function() gun.Shoot:FireServer(CFrame.new(from), CFrame.new(to2)) end)
    pcall(function() gun.Shoot:FireServer(CFrame.new(from), CFrame.new(to3)) end)
end

-- ═══ SMART AIM PREDICTION (jump + movement) ═══
function Luxt1.smartAim(target)
    if not target or not target.Character then return nil end
    local tChar = target.Character
    local tHRP = tChar:FindFirstChild("HumanoidRootPart")
    local hum = tChar:FindFirstChildOfClass("Humanoid")
    local aimPart = tChar:FindFirstChild("Head")
    if not aimPart then aimPart = tChar:FindFirstChild("UpperTorso") end
    if not aimPart then aimPart = tChar:FindFirstChild("Torso") end
    if not aimPart then aimPart = tHRP end
    if not (aimPart and tHRP) then return nil end

    local pos = aimPart.Position
    local vel = tHRP.AssemblyLinearVelocity or Vector3.zero

    -- Travel time = network ping + 50ms server processing margin
    local ping = 0
    pcall(function() ping = LocalPlayer:GetNetworkPing() end)
    local t = ping + 0.05

    -- XZ prediction: target moves vel.X*t and vel.Z*t during travel
    local predX = pos.X + vel.X * t
    local predZ = pos.Z + vel.Z * t

    -- Y prediction: gravity parabola if target is in the air (jumping/freefall)
    local predY = pos.Y
    if hum then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Freefall or
           state == Enum.HumanoidStateType.Jumping then
            -- Parabolic: y = y0 + v_y*t - 0.5*g*t^2
            local g = workspace.Gravity or 196.2
            predY = pos.Y + vel.Y * t - 0.5 * g * t * t
        else
            -- On ground — small Y compensation for animation bobbing
            predY = pos.Y + vel.Y * 0.05
        end
    end

    return Vector3.new(predX, predY, predZ)
end

function Luxt1.shootMurd()
    local target = MM2.shootTarget() or MM2.getMurd()
    if not target or not target.Character then return end
    if not findTool(LocalPlayer, "Gun") then return end
    local c = LocalPlayer.Character
    local gun = Luxt1.equipFromBP("Gun")
    if not gun then return end
    local myHRP = c:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local tChar = target.Character
    local aimPart = tChar:FindFirstChild("Head")
    if not aimPart then aimPart = tChar:FindFirstChild("UpperTorso") end
    if not aimPart then aimPart = tChar:FindFirstChild("Torso") end
    if not aimPart then aimPart = tChar:FindFirstChild("HumanoidRootPart") end
    if not aimPart then return end
    local tHRP = tChar:FindFirstChild("HumanoidRootPart")
    local vel = tHRP and tHRP.AssemblyLinearVelocity or Vector3.zero
    local from = c:FindFirstChild("RightHand") and c.RightHand.Position or myHRP.Position

    -- Fire 3 shots at different predictions — one will hit regardless of movement state.
    -- Shot 1: direct hit (no lead) — works for stationary targets
    local to1 = aimPart.Position
    -- Shot 2: smart aim with gravity — works for jumping/moving targets
    local to2 = Luxt1.smartAim(target) or (aimPart.Position + vel * 0.08)
    -- Shot 3: medium lead (0.1s, no gravity) — middle ground for slow movers
    local to3 = aimPart.Position + vel * 0.1

    if F.tracer.on then Luxt1.spawnTracerFX(from, to2) end
    pcall(function() gun.Shoot:FireServer(CFrame.new(from), CFrame.new(to1)) end)
    pcall(function() gun.Shoot:FireServer(CFrame.new(from), CFrame.new(to2)) end)
    pcall(function() gun.Shoot:FireServer(CFrame.new(from), CFrame.new(to3)) end)
end
task.spawn(function()
    while true do
        task.wait(0.05)
        if F.autoShoot then pcall(Luxt1.shootMurd) end
    end
end)
local function forceShootAt(target, gun)
    local c = LocalPlayer.Character
    if not (target and target.Character and c and gun) then return end
    local tChar = target.Character
    local aimPart = tChar:FindFirstChild("Head")
    if not aimPart then aimPart = tChar:FindFirstChild("UpperTorso") end
    if not aimPart then aimPart = tChar:FindFirstChild("Torso") end
    if not aimPart then aimPart = tChar:FindFirstChild("HumanoidRootPart") end
    if not aimPart then return end
    local tHRP = tChar:FindFirstChild("HumanoidRootPart")
    local vel = tHRP and tHRP.AssemblyLinearVelocity or Vector3.zero
    local myHRP = c:FindFirstChild("HumanoidRootPart")
    local from = c:FindFirstChild("RightHand") and c.RightHand.Position or myHRP.Position
    local shoot = gun:FindFirstChild("Shoot") or gun:FindFirstChild("Events") and gun.Events:FindFirstChild("Shoot")
    if not shoot then return end

    -- 3-shot prediction: direct + smart + medium lead
    local to1 = aimPart.Position
    local to2 = Luxt1.smartAim(target) or (aimPart.Position + vel * 0.08)
    local to3 = aimPart.Position + vel * 0.1

    if F.tracer.on then Luxt1.spawnTracerFX(from, to2) end
    pcall(function() shoot:FireServer(CFrame.new(from), CFrame.new(to1)) end)
    pcall(function() shoot:FireServer(CFrame.new(from), CFrame.new(to2)) end)
    pcall(function() shoot:FireServer(CFrame.new(from), CFrame.new(to3)) end)
end
function Luxt1.forceShootNow()
    local target = MM2.shootTarget()
    if not target then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and MM2.norm(plr.Name) == "Murderer" and MM2.alive(plr) then target = plr break end
        end
    end
    if not target then return end
    local gun = Luxt1.equipFromBP("Gun")
    if gun then forceShootAt(target, gun) end
end
local function hookForceGun()
    local c = LocalPlayer.Character
    local gun = c and c:FindFirstChild("Gun")
    if gun and not gun:GetAttribute("FSHooked") then
        gun:SetAttribute("FSHooked", true)
        gun.Activated:Connect(function()
            if F.forceShoot then task.spawn(pcall, Luxt1.forceShootNow) end
        end)
    end
end
hookForceGun()
track(LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.5) hookForceGun()
end))
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if F.silent and F.silentKey and F.silentKey ~= "None" then
        local match = false
        if F.silentKey == "M1B" and input.UserInputType == Enum.UserInputType.MouseButton1 then match = true
        elseif F.silentKey == "M2B" and input.UserInputType == Enum.UserInputType.MouseButton2 then match = true
        elseif F.silentKey == input.KeyCode.Name then match = true end
        if match then
            local _, _, hum = getChar()
            if hum and hum.Health > 0 then pcall(Luxt1.silentShoot) end
        end
    end
end))
function Luxt1.setAutoKnife(on)
    F.autoKnife = on
    if Luxt1.autoKnifeThread then task.cancel(Luxt1.autoKnifeThread) Luxt1.autoKnifeThread = nil end
    if on then
        Luxt1.autoKnifeThread = task.spawn(function()
            while F.autoKnife do
                task.wait(1.4)
                pcall(function()
                    if not MM2.amIMurd() then return end
                    local target = MM2.nearest()
                    if target then Luxt1.throwKnifeAt(target) end
                end)
            end
        end)
    end
end
function Luxt1.killAuraStop()
    Luxt1.kaOn = false
    for _, c in ipairs(Luxt1.kaCons or {}) do pcall(function() c:Disconnect() end) end
    Luxt1.kaCons = {}; Luxt1.kaLastKnife = nil
end
function Luxt1.killAuraStart()
    Luxt1.killAuraStop()
    Luxt1.kaOn = true
    task.spawn(function()
        while Luxt1.kaOn do
            task.wait(0.2)
            if not Luxt1.kaOn then break end
            local c = LocalPlayer.Character
            local knife = c and c:FindFirstChild("Knife") or Luxt1.equipFromBP("Knife")
            if not knife then break end
            knife = c:FindFirstChild("Knife") or knife
            if knife ~= Luxt1.kaLastKnife then
                Luxt1.kaLastKnife = knife
                track(knife.Activated:Connect(function()
                    if Luxt1.kaOn then task.spawn(function()
                        local target = MM2.nearest()
                        if target then Luxt1.slashTouch(target) end
                    end) end
                end))
            end
            local target = MM2.nearest()
            if target then pcall(Luxt1.slashTouch, target) end
        end
    end)
end
function Luxt1.killEveryone()
    local c = LocalPlayer.Character
    if not c then return end
    local knife = c:FindFirstChild("Knife") or Luxt1.equipFromBP("Knife")
    if not knife then notify(T("Error"), T("No knife!"), 3) return end
    local handle = c:FindFirstChild("Knife") and c.Knife:FindFirstChild("Handle")
    if not handle then notify(T("Error"), T("Knife without Handle!"), 3) return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp2 = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum2 = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum2 and hum2.Health > 0 then
                pcall(function()
                    if c.Knife:FindFirstChild("Stab") then c.Knife.Stab:FireServer("Slash") else c.Knife:Activate() end
                    firetouchinterest(handle, hrp2, 0); task.wait(); firetouchinterest(handle, hrp2, 1)
                end)
            end
        end
    end
    notify(T("Done"), T("Kill done"), 3)
end

-- ═══ FLING ═══
function Luxt1.flingPlayer(plr)
    if not plr or not plr.Character then
        notify(T("Fling"), T("No character"), 3)
        return
    end
    local c = LocalPlayer.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local rootPart = hum and hum.RootPart
    if not (c and hum and rootPart) then return end
    local tc = plr.Character
    local thum = tc:FindFirstChildOfClass("Humanoid")
    local tRoot = thum and thum.RootPart
    if not (thum and tRoot) then
        notify(T("Fling"), T("No character"), 3)
        return
    end

    -- Save state for restoration
    local oldPos = rootPart.CFrame
    local oldFPDH = workspace.FallenPartsDestroyHeight

    -- Disable humanoid states that interfere with the fling spin
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end)

    -- Prevent our parts from being destroyed by the anti-fall-height check
    workspace.FallenPartsDestroyHeight = 0/0

    -- BodyVelocity: pushes outward on collision
    local bv = Instance.new("BodyVelocity")
    bv.Name = "Luxt1FlingVel"
    bv.MaxForce = Vector3.one * math.huge
    bv.Velocity = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = rootPart

    -- BodyAngularVelocity: spins our root part very fast for transfer-on-touch
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "Luxt1FlingAngVel"
    bav.MaxTorque = Vector3.one * math.huge
    bav.AngularVelocity = Vector3.new(9e9, 9e9, 9e9)
    bav.Parent = rootPart

    -- TIGHT spin loop via Heartbeat (faster than task.wait, no GC pauses)
    local startTime = tick()
    local conn
    local ang = 0
    conn = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed > 1.8 then
            pcall(function() conn:Disconnect() end)
            return
        end
        if not (rootPart.Parent and tRoot.Parent) then
            pcall(function() conn:Disconnect() end)
            return
        end
        ang = ang + 250  -- fast multi-axis rotation
        -- PREDICT target position: lead with velocity + gravity (for jumpers).
        -- Target runs INTO our spinning part instead of us chasing it.
        local pos = tRoot.Position
        local vel = tRoot.AssemblyLinearVelocity or Vector3.zero
        local ping = 0
        pcall(function() ping = LocalPlayer:GetNetworkPing() end)
        local leadT = ping + 0.1  -- 100ms collision-momentum lead
        local predX = pos.X + vel.X * leadT
        local predZ = pos.Z + vel.Z * leadT
        local predY = pos.Y
        if thum then
            local st = thum:GetState()
            if st == Enum.HumanoidStateType.Freefall or
               st == Enum.HumanoidStateType.Jumping then
                -- Parabolic Y: y0 + v_y*t - 0.5*g*t^2 (gravity pulls jumper down)
                local g = workspace.Gravity or 196.2
                predY = pos.Y + vel.Y * leadT - 0.5 * g * leadT * leadT
            else
                -- On ground — small Y lead to compensate animation bobbing
                predY = pos.Y + vel.Y * 0.05
            end
        end
        local targetPos = Vector3.new(predX, predY, predZ)
        rootPart.CFrame = CFrame.new(targetPos) * CFrame.new(0, 2, 0)
            * CFrame.Angles(math.rad(ang), math.rad(ang * 0.7), math.rad(ang * 0.3))
        rootPart.Velocity = Vector3.new(9e8, 9e8, 9e8)
        rootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end)

    -- Wait for the fling loop to complete
    task.wait(2.0)

    -- Cleanup helpers
    pcall(function() bv:Destroy() end)
    pcall(function() bav:Destroy() end)
    pcall(function() if conn then conn:Disconnect() end end)

    -- Re-enable humanoid states
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    end)

    -- Restore anti-fall height
    workspace.FallenPartsDestroyHeight = oldFPDH

    -- Reset ALL part velocities (including accessory Handles that the old code missed)
    pcall(function()
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Velocity = Vector3.zero
                p.RotVelocity = Vector3.zero
            end
        end
    end)

    -- Try to teleport back to our original position
    task.spawn(function()
        for _ = 1, 120 do
            if not rootPart.Parent then break end
            rootPart.CFrame = oldPos * CFrame.new(0, 0.5, 0)
            rootPart.Velocity = Vector3.zero
            rootPart.RotVelocity = Vector3.zero
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            if (rootPart.Position - oldPos.Position).Magnitude < 5 then break end
            task.wait()
        end
    end)

    -- Restore camera subject
    pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
end

-- ═══ VOTE DUPER ═══
local function voteGetPads()
    -- Simple digit-based pad search (matches VotePad1/2/3 by trailing digit).
    -- This way pads[1] = VotePad1 (whatever physical position), pads[2] = VotePad2, etc.
    -- Matches user expectations: pick "1" in dropdown → goes to VotePad1.
    local found = {}

    local function extractDigit(name)
        if not name then return nil end
        local d = name:match("(%d+)$")  -- trailing digit
        if d then return tonumber(d) end
        d = name:match("(%d+)")  -- any digit
        return d and tonumber(d)
    end

    -- Find VotePad1/2/3 anywhere in workspace (scan all descendants)
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Model") or d:IsA("Folder") then
            local name = d.Name or ""
            local lname = name:lower():gsub("[%s_]", "")
            -- Match: VotePad1, VotePad2, VotePad3 (or any prefix variant)
            if lname:find("votepad") then
                local hasPart = d:FindFirstChildWhichIsA("BasePart", true) ~= nil
                if hasPart then
                    local digit = extractDigit(name)
                    if digit and not found[digit] then
                        found[digit] = d
                    end
                end
            end
        end
    end

    -- Fallback: VotePads folder layout (older MM2)
    if not next(found) then
        local vp = workspace:FindFirstChild("VotePads", true)
        if vp then
            for _, ch in ipairs(vp:GetChildren()) do
                local digit = extractDigit(ch.Name)
                local hasPart = ch:FindFirstChildWhichIsA("BasePart", true) ~= nil
                if hasPart and digit and not found[digit] then
                    found[digit] = ch
                end
            end
        end
    end

    -- Build sorted pads array: pads[1] = VotePad1, pads[2] = VotePad2, etc.
    local pads = {}
    local digits = {}
    for d in pairs(found) do table.insert(digits, d) end
    table.sort(digits)
    for _, d in ipairs(digits) do table.insert(pads, found[d]) end
    return pads
end

-- Diagnostic: list all found pads with their index + name + position.
function Luxt1.listVotePads()
    local pads = voteGetPads()
    print("[Luxt1] Found "..#pads.." vote pads (indexed by trailing digit):")
    for i, p in ipairs(pads) do
        local pos = nil
        pcall(function() pos = p:GetPivot().Position end)
        if pos then
            print(string.format("  [%d] %s @ (%.1f, %.1f, %.1f)", i, p.Name or "?", pos.X, pos.Y, pos.Z))
        else
            print(string.format("  [%d] %s @ (no pos)", i, p.Name or "?"))
        end
    end
    return pads
end
local function voteUiVisible(pad)
    local gui = pad and pad:FindFirstChild("VoteInfoGui", true)
    if not gui then return false end
    local vis = false
    pcall(function()
        if gui:IsA("LayerCollector") then vis = gui.Enabled == true
        elseif gui:IsA("GuiObject") then vis = gui.Visible == true
        else vis = gui.Enabled == true end
    end)
    return vis
end
function Luxt1.setVote(on)
    F.vote = on
    Luxt1.voteGen = (Luxt1.voteGen or 0) + 1
    if Luxt1.voteThread then task.cancel(Luxt1.voteThread) Luxt1.voteThread = nil end
    if not on then return end
    local gen = Luxt1.voteGen
    Luxt1.voteThread = task.spawn(function()
        while F.vote and gen == Luxt1.voteGen do
            local pads = voteGetPads()
            local pad = pads[F.votePad]
            if not pad then task.wait(0.5) continue end
            if not voteUiVisible(pad) then
                repeat task.wait(0.5) until voteUiVisible(pad) or not F.vote or gen ~= Luxt1.voteGen
            end
            if not (F.vote and gen == Luxt1.voteGen) then break end
            local c = LocalPlayer.Character
            while not c and F.vote and gen == Luxt1.voteGen do task.wait(0.1) c = LocalPlayer.Character end
            local hum = c and c:WaitForChild("Humanoid", 5)
            if F.vote and gen == Luxt1.voteGen and voteUiVisible(pad) and c and hum and hum.Health > 0 then
                -- Robust pad-part lookup: try named "Pad" first, then any BasePart
                local padPart = pad:FindFirstChild("Pad", true)
                if not (padPart and padPart:IsA("BasePart")) then
                    -- Fallback: use any BasePart descendant (works even if MM2 renamed "Pad")
                    padPart = pad:FindFirstChildWhichIsA("BasePart", true)
                end
                if padPart and padPart:IsA("BasePart") then
                    pcall(function() c:PivotTo(padPart.CFrame * CFrame.new(0, 1.5, 0)) end)
                else
                    -- Ultimate fallback: use the pad's pivot position
                    pcall(function() c:PivotTo(pad:GetPivot() * CFrame.new(0, 1.5, 0)) end)
                end
                -- Notify user which pad was actually used (for verification)
                notify(T("Vote Pad"), tostring(F.votePad)..": "..(pad.Name or "?"), 2)
                task.wait(0.38)
                if F.vote and gen == Luxt1.voteGen and voteUiVisible(pad) and hum.Health > 0 then
                    hum.Health = 0
                    pcall(function() c:BreakJoints() end)
                    repeat task.wait(0.1) until LocalPlayer.Character or not F.vote or gen ~= Luxt1.voteGen
                    task.wait(0.05)
                end
            else
                task.wait(0.2)
            end
        end
    end)
end

-- ═══ AUTOFARM ═══
local AF = F.farm
local function afCoinCount()
    local ok, res = pcall(function()
        local mg = LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
        local g = mg and mg:FindFirstChild("Game")
        local cb = g and g:FindFirstChild("CoinBags")
        local cont = cb and cb:FindFirstChild("Container")
        local coin = cont and cont:FindFirstChild("Coin")
        local cf = coin and coin:FindFirstChild("CurrencyFrame")
        local icon = cf and cf:FindFirstChild("Icon")
        local coins = icon and icon:FindFirstChild("Coins")
        return coins and coins.Text or "0"
    end)
    return (ok and tonumber(res)) or 0
end
local function afVictory()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local v = pg and pg:FindFirstChild("Victory")
    if v then
        for _, ch in pairs(v:GetChildren()) do
            if ch:IsA("GuiObject") and ch.Visible then return true end
        end
    end
    return false
end
local function afMurdNear()
    if not AF.avoidMurder then return false end
    local _, hrp = getChar()
    if not hrp then return false end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local p = plr.Character:FindFirstChild("HumanoidRootPart")
            if p and (p.Position - hrp.Position).Magnitude <= 10 then
                if plr.Character:FindFirstChild("Knife") then return true end
                local bp = plr:FindFirstChild("Backpack")
                if bp and bp:FindFirstChild("Knife") then return true end
            end
        end
    end
    return false
end
local afState = { ignored={} }
local function afFindCoin(hrp)
    local cc = nil
    for _, d in pairs(workspace:GetDescendants()) do
        if d.Name == "CoinContainer" then cc = d break end
    end
    if not cc then return nil end
    local best, dist = nil, math.huge
    for _, ch in pairs(cc:GetChildren()) do
        if ch.Name == "Coin_Server" and ch:IsA("BasePart") and not afState.ignored[ch] then
            local m = (hrp.Position - ch.Position).Magnitude
            if m < dist and m <= AF.maxDist then best, dist = ch, m end
        end
    end
    return best
end
local function afKillMovers()
    local _, hrp = getChar()
    if hrp then
        local bv = hrp:FindFirstChild("FarmBV") if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("FarmBG") if bg then bg:Destroy() end
        if hrp.Anchored then hrp.Anchored = false end
    end
end
function Luxt1.setAutoFarm(on)
    AF.enabled = on
    if Luxt1.afThread then task.cancel(Luxt1.afThread) Luxt1.afThread = nil end
    afKillMovers()
    if not on then
        local c = LocalPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = false; hum.PlatformStand = false end
        return
    end
    Luxt1.afThread = task.spawn(function()
        while AF.enabled do
            task.wait()
            if afMurdNear() then
                afKillMovers()
                local c = LocalPlayer.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                if hum then hum.Sit = false end
                task.wait(1)
                continue
            end
            local c, hrp, hum = getChar()
            if not (c and hrp and hum and hum.Health > 0) then afKillMovers() task.wait(1) continue end
            if afVictory() then afKillMovers() if hum then hum.Sit=false end task.wait(1) continue end
            if AF.autoReset and AF.coinLimit <= afCoinCount() then
                hum.Health = 0; task.wait(5); continue
            end
            local coin = afFindCoin(hrp)
            if not coin then task.wait(0.3) continue end
            local target = coin.Position + Vector3.new(0, -AF.ugOffset, 0)
            if AF.mode == "Underground" then
                if not hrp:FindFirstChild("FarmBV") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Name="FarmBV"; bv.MaxForce=Vector3.one * math.huge; bv.Velocity=Vector3.zero; bv.Parent=hrp
                end
                if not hrp:FindFirstChild("FarmBG") then
                    local bg = Instance.new("BodyGyro")
                    bg.Name="FarmBG"; bg.MaxTorque=Vector3.one * math.huge; bg.P=50000; bg.Parent=hrp
                end
                hum.PlatformStand = true
                for _, d in pairs(c:GetDescendants()) do
                    if d:IsA("BasePart") and d.CanCollide then d.CanCollide = false end
                end
                local bg = hrp:FindFirstChild("FarmBG")
                if bg then bg.CFrame = CFrame.new(hrp.Position) end
                local bv = hrp:FindFirstChild("FarmBV")
                while AF.enabled and coin.Parent and (hrp.Position - target).Magnitude > 3 do
                    if bv then bv.Velocity = (target - hrp.Position).Unit * AF.tweenSpeed end
                    task.wait()
                    if not coin.Parent then break end
                end
                if coin.Parent then
                    pcall(function()
                        firetouchinterest(hrp, coin, 0); task.wait(0.05); firetouchinterest(hrp, coin, 1)
                    end)
                end
                afState.ignored[coin] = true
            else
                hum.Sit = true
                local dist = (hrp.Position - (coin.Position + Vector3.new(0,2,0))).Magnitude
                local tw = TweenService:Create(hrp, TweenInfo.new(dist / math.max(AF.tweenSpeed,1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = CFrame.new(coin.Position + Vector3.new(0,2,0)) })
                tw:Play()
                local t0 = tick()
                while tw.PlaybackState == Enum.PlaybackState.Playing and tick() - t0 < 30 and coin.Parent do task.wait(0.1) end
                pcall(function() tw:Cancel() end)
                hum.Sit = false
                afState.ignored[coin] = true
            end
        end
    end)
end

-- ═══ TRADE HELPER ═══
local TH = { On=false, values={}, numeric={}, loaded=false, loading=false,
           autoOffer=false, offerItem="DefaultGun", offerCat="Weapons", offerInterval=1.5 }
local function thNorm(s)
    if not s then return "" end
    return tostring(s):lower():gsub("[%s%_'%.-]", "")
end
local function thValue(name)
    if not name then return 0 end
    local v = TH.numeric[name] or TH.numeric[thNorm(name)]
    if v ~= nil then return v end
    local n = thNorm(name)
    return TH.numeric[n.."knife"] or TH.numeric[n.."gun"] or 0
end
local function thTierColor(v)
    if v >= 100000 then return Color3.fromRGB(255,70,70) end
    if v >= 10000 then return Color3.fromRGB(255,120,60) end
    if v >= 1000 then return Color3.fromRGB(255,215,90) end
    if v >= 100 then return Color3.fromRGB(55,220,145) end
    if v >= 10 then return Color3.fromRGB(90,205,255) end
    return Color3.fromRGB(205,210,220)
end
function Luxt1.thLoadValues()
    if TH.loading then return end
    TH.loading = true
    -- Always populate from the hardcoded table first — works even if API is down.
    local hardCount = 0
    if Luxt1.HARDCODED_VALUES then
        for name, num in pairs(Luxt1.HARDCODED_VALUES) do
            if type(num) == "number" then
                local val = tostring(num)
                -- Format with thousands separator for display (e.g., 16250 -> "16,250")
                local formatted = tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                TH.values[name] = formatted
                TH.values[thNorm(name)] = formatted
                TH.numeric[name] = num
                TH.numeric[thNorm(name)] = num
                hardCount = hardCount + 1
            end
        end
    end
    TH.loaded = hardCount > 0
    TH.valueCount = hardCount
    -- Try to overlay with live API values (optional — failures don't break anything)
    local ok, res = pcall(function() return game:HttpGet("http://78.154.103.50:9986/") end)
    local apiCount = 0
    if ok and type(res) == "string" then
        for line in res:gmatch("[^\r\n]+") do
            local n, v = line:match("^%s*(.-)%s*:%s*(.-)%s*$")
            if n and v and n ~= "" and v ~= "" then
                local name = tostring(n):gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
                local val = tostring(v):match("^%s*(.-)%s*$")
                if name and #name > 1 and val ~= "" then
                    local numStr = val:gsub(",", "")
                    local num = tonumber(numStr) or 0
                    if num == 0 then
                        local x = tonumber(val:match("^[xX](%d+)") or "1") or 1
                        local t = tonumber(val:match("[Tt](%d+)") or "1") or 1
                        if val:match("[Tt]%d+") then num = x * t * 0.2 end
                    end
                    TH.values[name] = val
                    TH.values[thNorm(name)] = val
                    TH.numeric[name] = num
                    TH.numeric[thNorm(name)] = num
                    apiCount = apiCount + 1
                end
            end
        end
        TH.loaded = (hardCount + apiCount) > 0
        TH.valueCount = hardCount + apiCount
    end
    if TH.On then
        if TH.valueCount > 0 then
            notify(T("Trade"), T("Values loaded: ")..tostring(TH.valueCount).." ("..tostring(hardCount).."+"..tostring(apiCount)..")", 2)
        else
            notify(T("Trade"), T("Values API empty"), 3)
        end
    end
    TH.loading = false
end
local function thScanTrade()
    if not TH.On then return end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    for _, guiName in ipairs({ "TradeGUI", "TradeGUI_Phone" }) do
        local gui = pg:FindFirstChild(guiName)
        if gui then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("GuiObject") and d:FindFirstChild("ItemName") and d:FindFirstChild("Container") then
                    local container = d:FindFirstChild("Container") or d
                    if not d.Visible then
                        local old = container:FindFirstChild("ValuePill")
                        if old then old:Destroy() end
                    else
                        local itemName = d:FindFirstChild("ItemName", true)
                        local name = nil
                        if itemName then
                            local lbl = itemName:IsA("TextLabel") and itemName or itemName:FindFirstChild("Label", true)
                            if lbl then
                                local t = tostring(lbl.Text or ""):gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
                                if t and t ~= "" and t ~= "Loading..." then name = t end
                            end
                        end
                        local txt = name and (TH.values[name] or TH.values[thNorm(name)])
                        if txt then
                            local old = container:FindFirstChild("ValuePill")
                            if old then old:Destroy() end
                            local fr = Instance.new("Frame")
                            fr.Name="ValuePill"; fr.Size=UDim2.new(0, 68, 0, 25)
                            fr.BackgroundColor3=Color3.fromRGB(36,36,36); fr.BackgroundTransparency=0.05
                            fr.BorderSizePixel=0; fr.ZIndex=1000; fr.Parent=container
                            corner(fr, 9); stroke(fr, Color3.fromRGB(92,92,92), 1, 0.05)
                            local ic = Instance.new("ImageLabel", fr)
                            ic.BackgroundTransparency=1; ic.Position=UDim2.new(0,5,0.5,-10)
                            ic.Size=UDim2.new(0,20,0,20); ic.Image=img("138817919764650")
                            ic.ImageColor3=thTierColor(thValue(name)); ic.ScaleType=Enum.ScaleType.Fit; ic.ZIndex=1001
                            local tl = Instance.new("TextLabel", fr)
                            tl.BackgroundTransparency=1; tl.Position=UDim2.new(0,25,0,0)
                            tl.Size=UDim2.new(1,-29,1,0); tl.Text=tostring(txt)
                            tl.TextColor3=thTierColor(thValue(name)); tl.Font=FONT_BOLD; tl.TextSize=14
                            tl.TextXAlignment=Enum.TextXAlignment.Left; tl.ZIndex=1001
                        end
                    end
                end
            end
            local trade = gui:FindFirstChild("Trade", true)
            if trade then
                for _, offerName in ipairs({ "YourOffer", "TheirOffer" }) do
                    local offer = trade:FindFirstChild(offerName)
                    local cont = offer and offer:FindFirstChild("Container")
                    if cont then
                        local total = 0
                        for _, ch in ipairs(cont:GetChildren()) do
                            if ch:IsA("GuiObject") and ch:FindFirstChild("ItemName") and ch:FindFirstChild("Container") and ch.Visible then
                                local itemName = ch:FindFirstChild("ItemName", true)
                                if itemName then
                                    local lbl = itemName:IsA("TextLabel") and itemName or itemName:FindFirstChild("Label", true)
                                    if lbl then
                                        local t = tostring(lbl.Text or ""):gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
                                        if t then total += thValue(t) end
                                    end
                                end
                            end
                        end
                        local totalPill = offer:FindFirstChild("TotalValuePill")
                        if not totalPill then
                            totalPill = Instance.new("Frame")
                            totalPill.Name="TotalValuePill"
                            totalPill.Position=UDim2.new(0,206,0,6.7)
                            totalPill.Size=UDim2.new(0,230,0,30)
                            totalPill.BackgroundColor3=Color3.fromRGB(36,36,36)
                            totalPill.BackgroundTransparency=0.05
                            totalPill.BorderSizePixel=0; totalPill.ZIndex=1000
                            totalPill.Parent=offer
                            corner(totalPill, 11)
                            stroke(totalPill, Color3.fromRGB(92,92,92), 1, 0.05)
                            local tl = Instance.new("TextLabel", totalPill)
                            tl.Name="TotalLabel"; tl.BackgroundTransparency=1
                            tl.Position=UDim2.new(0,8,0,0); tl.Size=UDim2.new(1,-14,1,0)
                            tl.Font=FONT_BOLD; tl.TextSize=16
                            tl.TextXAlignment=Enum.TextXAlignment.Left
                            tl.TextColor3=Color3.fromRGB(255,222,140); tl.ZIndex=1001
                        end
                        local lbl = totalPill:FindFirstChild("TotalLabel")
                        if lbl then
                            local s = string.format("%.2f", total):gsub("0+$",""):gsub("%.$","")
                            lbl.Text = offerName == "YourOffer" and (T("You: ")..s) or (T("Them: ")..s)
                        end
                    end
                end
            end
        end
    end
end

-- ═══ TRADE STATE LISTENER + OFFER (UpdateTrade remote) ═══
-- Listen to server → client state updates
local function thEnsureListener()
    if Luxt1.thListenConn then return end
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local trade = rs:WaitForChild("Trade", 5)
        if not trade then return end
        local upd = trade:WaitForChild("UpdateTrade", 5)
        if not upd then return end
        Luxt1.thListenConn = upd.OnClientEvent:Connect(function(state)
            TH.state = state or {}
            TH.lastUpdate = tick()
        end)
        track(Luxt1.thListenConn)
    end)
end

function Luxt1.offerTradeItem(itemName, category)
    itemName = itemName or "DefaultGun"
    category = category or "Weapons"
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local trade = rs:WaitForChild("Trade", 5)
        if not trade then
            notify(T("Trade"), T("Trade remote not found"), 3)
            return
        end
        local upd = trade:FindFirstChild("UpdateTrade")
        if upd and upd:IsA("RemoteEvent") then
            upd:FireServer(itemName, category)
            notify(T("Trade"), T("Offered: ")..itemName, 2)
            return
        end
        local offer = trade:FindFirstChild("OfferItem")
        if offer and offer:IsA("RemoteEvent") then
            offer:FireServer(itemName, category)
            notify(T("Trade"), T("Offered: ")..itemName, 2)
            return
        end
        notify(T("Trade"), T("OfferItem not found"), 3)
    end)
end

-- Build a human-readable summary of the current trade state.
local function thFormatState()
    if not TH.state then
        return T("No trade state received yet")
    end
    local lines = {}
    local valStatus = TH.loaded and (T("Values: ")..tostring(TH.valueCount or 0).." "..T("items")) or T("Values API unreachable")
    table.insert(lines, valStatus)
    if not TH.state then
        table.insert(lines, T("No trade state received yet"))
        return table.concat(lines, "\n")
    end
    local s = TH.state
    local function fmtOffer(offer)
        if not offer or #offer == 0 then return T("(empty)") end
        local parts = {}
        for _, item in ipairs(offer) do
            if type(item) == "table" then
                local name = tostring(item[1] or "?")
                local count = tonumber(item[2]) or 1
                local cat = tostring(item[3] or "?")
                local val = TH.values[name] or TH.values[thNorm(name)]
                local num = TH.numeric[name] or TH.numeric[thNorm(name)] or 0
                local valStr = val and ("  ["..tostring(val).."]") or ("  ["..T("no value").."]")
                table.insert(parts, string.format("%s x%d (%s)%s", name, count, cat, valStr))
            end
        end
        return table.concat(parts, "\n")
    end
    local function offerTotal(offer)
        local total = 0
        if offer then
            for _, item in ipairs(offer) do
                if type(item) == "table" then
                    local name = tostring(item[1] or "")
                    local count = tonumber(item[2]) or 1
                    local num = TH.numeric[name] or TH.numeric[thNorm(name)] or 0
                    total = total + (num * count)
                end
            end
        end
        return total
    end
    local p1 = s.Player1 or {}
    local p2 = s.Player2 or {}
    local p1n = (p1.Player and p1.Player.Name) or "?"
    local p2n = (p2.Player and p2.Player.Name) or "?"
    local p1Acc = p1.Accepted and "✓" or "✗"
    local p2Acc = p2.Accepted and "✓" or "✗"
    local p1Total = offerTotal(p1.Offer)
    local p2Total = offerTotal(p2.Offer)
    local lines = {}
    table.insert(lines, string.format("%s: %s", T("Locked"), s.Locked and T("Yes") or T("No")))
    table.insert(lines, string.format("P1 %s [%s] = %s", p1n, p1Acc, tostring(p1Total)))
    table.insert(lines, fmtOffer(p1.Offer))
    table.insert(lines, string.format("P2 %s [%s] = %s", p2n, p2Acc, tostring(p2Total)))
    table.insert(lines, fmtOffer(p2.Offer))
    return table.concat(lines, "\n")
end

-- Update the live trade-state label inside the Trade tab UI.
function Luxt1.thUpdateSummary()
    if not Luxt1.thStateLbl then return end
    pcall(function()
        Luxt1.thStateLbl.Text = thFormatState()
    end)
end

function Luxt1.setTrade(on)
    TH.On = on
    F.trade = on
    if Luxt1.thThread then task.cancel(Luxt1.thThread) Luxt1.thThread = nil end
    if on then
        task.spawn(Luxt1.thLoadValues)
        -- Hook UpdateTrade:OnClientEvent to receive authoritative state
        thEnsureListener()
        Luxt1.thThread = task.spawn(function()
            local offerAccum = 0
            while TH.On do
                task.wait(0.5)
                pcall(thScanTrade)
                pcall(Luxt1.thUpdateSummary)
                -- auto-fire UpdateTrade (or OfferItem as fallback) if enabled
                if TH.autoOffer then
                    offerAccum = offerAccum + 0.5
                    if offerAccum >= (TH.offerInterval or 1.5) then
                        offerAccum = 0
                        pcall(function()
                            local rs = game:GetService("ReplicatedStorage")
                            local trade = rs:FindFirstChild("Trade")
                            if not trade then return end
                            local remote = trade:FindFirstChild("UpdateTrade")
                            if not (remote and remote:IsA("RemoteEvent")) then
                                remote = trade:FindFirstChild("OfferItem")
                            end
                            if remote and remote:IsA("RemoteEvent") then
                                remote:FireServer(TH.offerItem or "DefaultGun", TH.offerCat or "Weapons")
                            end
                        end)
                    end
                end
            end
        end)
        notify(T("Trade Helper"), T("Trade Helper on"), 2)
    else
        -- disconnect the listener when disabled
        if Luxt1.thListenConn then killConn(Luxt1.thListenConn) Luxt1.thListenConn = nil end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, d in ipairs(pg:GetDescendants()) do
                if d.Name == "ValuePill" or d.Name == "TotalValuePill" then d:Destroy() end
            end
        end
    end
end

-- ═══ GAME SOUNDS REPLACEMENT ═══
local hookedSounds = {}
local function hookGameSound(s)
    if not s:IsA("Sound") or hookedSounds[s] then return end
    hookedSounds[s] = true
    s.Played:Connect(function()
        if s.Name == "GunKill" and F.gunKill ~= "Default" then
            local id = soundId(F.gunKill)
            if id and s.SoundId ~= id then s.SoundId=id; s.TimePosition=0; s:Play() end
        elseif (s.Name == "Gunshot" or s.Name == "AltSound") and F.gunshot ~= "Default" then
            local id = soundId(F.gunshot)
            if id and s.SoundId ~= id then s.SoundId=id; s.TimePosition=0; s:Play() end
        elseif s.Name == "Kill" and F.knifeKill ~= "Default" then
            local id = soundId(F.knifeKill)
            if id and s.SoundId ~= id then s.SoundId=id; s.TimePosition=0; s:Play() end
        elseif s.Name == "Reload" and F.noReload then
            s.Volume = 0; s:Stop()
        end
    end)
end
track(workspace.DescendantAdded:Connect(function(d)
    if d:IsA("Sound") and (d.Name=="GunKill" or d.Name=="Gunshot" or d.Name=="AltSound" or d.Name=="Kill" or d.Name=="Reload") then
        hookGameSound(d)
    end
end))
for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("Sound") and (d.Name=="GunKill" or d.Name=="Gunshot" or d.Name=="AltSound" or d.Name=="Kill" or d.Name=="Reload") then
        hookGameSound(d)
    end
end

-- ═══ HIT EFFECTS ═══
local HIT_SOUNDS = { "rbxassetid://140604838213617", "rbxassetid://130201387574815", "rbxassetid://135478009117226",
    "rbxassetid://96735711388006", "rbxassetid://126048302910782", "rbxassetid://7255642553" }
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not F.hitParts and not F.hitSound then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local loc = UserInputService:GetMouseLocation()
    local ray = cam:ViewportPointToRay(loc.X, loc.Y)
    local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000)
    if hit and hit.Instance then
        local model = hit.Instance:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChildOfClass("Humanoid") and model ~= LocalPlayer.Character then
            if F.hitSound then
                pcall(function()
                    local s = Instance.new("Sound", SoundService)
                    s.SoundId = HIT_SOUNDS[F.hitSoundMode] or HIT_SOUNDS[1]
                    s.Volume = 2; s:Play()
                    game:GetService("Debris"):AddItem(s, 1)
                end)
            end
            if F.hitParts then
                local gui = Instance.new("ScreenGui")
                pcall(function() gui.Parent = game:GetService("CoreGui") end)
                if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
                for _ = 1, 8 do
                    local bb = Instance.new("BillboardGui", gui)
                    bb.Size = UDim2.new(2,0,2,0); bb.AlwaysOnTop = true
                    local part = Instance.new("Part", workspace)
                    part.Size = Vector3.new(0.1,0.1,0.1); part.Transparency=1; part.CanCollide=false
                    part.Anchored=true; part.Position=hit.Position; bb.Adornee=part
                    local tl = Instance.new("TextLabel", bb)
                    tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency=1
                    tl.Text = "✦"; tl.TextScaled=true
                    tl.TextColor3=Color3.fromRGB(255,255,255)
                    local ti = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    TweenService:Create(part, ti, { Position = part.Position + Vector3.new(math.random(-8,8), math.random(-1,1), math.random(-8,8)) }):Play()
                    TweenService:Create(tl, ti, { TextTransparency=1, Rotation=math.random(-180,180) }):Play()
                    task.delay(0.6, function() part:Destroy() bb:Destroy() end)
                end
                task.delay(1, function() pcall(function() gui:Destroy() end) end)
            end
        end
    end
end))

-- ═══ ANIMATIONS + EMOTES ═══
local AnimURL = "http://www.roblox.com/asset/?id="
local ANIMATIONS = {
    Stylish={Idle=616136790,Idle2=616138447,Idle3=886888594,Walk=616146177,Run=616140816,Jump=616139451,Climb=616133594,Fall=616134815,Swim=616143378,SwimIdle=616144772},
    Zombie={Idle=616158929,Idle2=616160636,Idle3=885545458,Walk=616168032,Run=616163682,Jump=616161997,Climb=616156119,Fall=616157476,Swim=616165109,SwimIdle=616166655},
    Robot={Idle=616088211,Idle2=616089559,Idle3=885531463,Walk=616095330,Run=616091570,Jump=616090535,Climb=616086039,Fall=616087089,Swim=616092998,SwimIdle=616094091},
    Toy={Idle=782841498,Idle2=782845736,Idle3=980952228,Walk=782843345,Run=782842708,Jump=782847020,Climb=782843869,Fall=782846423,Swim=782844582,SwimIdle=782845186},
    Cartoony={Idle=742637544,Idle2=742638445,Idle3=885477856,Walk=742640026,Run=742638842,Jump=742637942,Climb=742636889,Fall=742637151,Swim=742639220,SwimIdle=742639812},
    Superhero={Idle=616111295,Idle2=616113536,Idle3=885535855,Walk=616122287,Run=616117076,Jump=616115533,Climb=616104706,Fall=616108001,Swim=616119360,SwimIdle=616120861},
    Mage={Idle=707742142,Idle2=707855907,Idle3=885508740,Walk=707897309,Run=707861613,Jump=707853694,Climb=707826056,Fall=707829716,Swim=707876443,SwimIdle=707894699},
    Levitation={Idle=616006778,Idle2=616008087,Idle3=886862142,Walk=616013216,Run=616010382,Jump=616008936,Climb=616003713,Fall=616005863,Swim=616011509,SwimIdle=616012453},
    Vampire={Idle=1083445855,Idle2=1083450166,Idle3=1088037547,Walk=1083473930,Run=1083462077,Jump=1083455352,Climb=1083439238,Fall=1083443587,Swim=1083464683,SwimIdle=1083467779},
    Elder={Idle=845397899,Idle2=845400520,Idle3=901160519,Walk=845403856,Run=845386501,Jump=845398858,Climb=845392038,Fall=845396048,Swim=845401742,SwimIdle=845403127},
    Werewolf={Idle=1083195517,Idle2=1083214717,Idle3=1099492820,Walk=1083178339,Run=1083216690,Jump=1083218792,Climb=1083182000,Fall=1083189019,Swim=1083222527,SwimIdle=1083225406},
    Knight={Idle=657595757,Idle2=657568135,Idle3=885499184,Walk=657552124,Run=657564596,Jump=658409194,Climb=658360781,Fall=657600338,Swim=657560551,SwimIdle=657557095},
    Bold={Idle=16738333868,Idle2=16738334710,Idle3=16738335517,Walk=16738340646,Run=16738337225,Jump=16738336650,Climb=16738332169,Fall=16738333171,Swim=16738339158,SwimIdle=16738339817},
    Astronaut={Idle=891621366,Idle2=891633237,Idle3=1047759695,Walk=891667138,Run=891636393,Jump=891627522,Climb=891609353,Fall=891617961,Swim=891639666,SwimIdle=891663592},
    Bubbly={Idle=910004836,Idle2=910009958,Idle3=1018536639,Walk=910034870,Run=910025107,Jump=910016857,Climb=909997997,Fall=910001910,Swim=910028158,SwimIdle=910030921},
    Pirate={Idle=750781874,Idle2=750782770,Idle3=885515365,Walk=750785693,Run=750783738,Jump=750782230,Climb=750779899,Fall=750780242,Swim=750784579,SwimIdle=750785176},
    Rthro={Idle=2510196951,Idle2=2510197257,Idle3=3711062489,Walk=2510202577,Run=2510198475,Jump=2510197830,Climb=2510192778,Fall=2510195892,Swim=2510199791,SwimIdle=2510201162},
    Ninja={Idle=656117400,Idle2=656118341,Idle3=886742569,Walk=656121766,Run=656118852,Jump=656117878,Climb=656114359,Fall=656115606,Swim=656119721,SwimIdle=656121397},
    Oldschool={Idle=5319828216,Idle2=5319831086,Idle3=5392107832,Walk=5319847204,Run=5319844329,Jump=5319841935,Climb=5319816685,Fall=5319839762,Swim=5319850266,SwimIdle=5319852613},
    Realistic={Idle=17172918855,Idle2=17173014241,Idle3=17173014241,Walk=11600249883,Run=11600211410,Jump=11600210487,Climb=11600205519,Fall=11600206437,Swim=11600212676,SwimIdle=11600213505},
    Princess={Idle=941003647,Idle2=941013098,Idle3=1159195712,Walk=941028902,Run=941015281,Jump=941008832,Climb=940996062,Fall=941000007,Swim=941018893,SwimIdle=941025398},
    Confident={Idle=1069977950,Idle2=1069987858,Idle3=1116160740,Walk=1070017263,Run=1070001516,Jump=1069984524,Climb=1069946257,Fall=1069973677,Swim=1070009914,SwimIdle=1070012133},
    Cowboy={Idle=1014390418,Idle2=1014398616,Idle3=1159487651,Walk=1014421541,Run=1014401683,Jump=1014394726,Climb=1014380606,Fall=1014384571,Swim=1014406523,SwimIdle=1014411816},
    R15={Idle=4211217646,Idle2=4211218409,Idle3=0,Walk=4211223236,Run=4211220381,Jump=4211219390,Climb=4211214992,Fall=4211216152,Swim=4211221314,SwimIdle=4374694239},
    Mocap={Idle=913367814,Idle2=913373430,Idle3=0,Walk=913402848,Run=913376220,Jump=913370268,Climb=913362637,Fall=913365531,Swim=913384386,SwimIdle=913389285},
}
local AnimationList = {}
for k in pairs(ANIMATIONS) do table.insert(AnimationList, k) end
table.sort(AnimationList, function(a,b) return a:lower() < b:lower() end)
local EMOTES = {
    Griddy=116065653184749, ["Gangnam Style"]=77205409178702, ["Hakari Dance"]=80270168146449,
    ["Miku Dance"]=117734400993750, Kazotsky=97629500912487, ["Default Dance"]=80877772569772,
    Skibidi=124828909173982, Split=98522218962476, ["Push-Up"]=117922227854118,
    Jumpstyle=99563839802389, HeadBanging=87447252507832, PROXIMA=81390693780805,
    ["Torture Dance"]=116099356619436, ["Michael Myers"]=88229016850146, ["Dio Pose"]=76736978166708,
    Garou=86200585395371, Sukuna=91839607010745, ["Honored One"]=121643381580730,
    Macarena=91274761264433, Helicopter=84555218084038, Conga=97547955535086,
    Barrel=84511772437190, RONALDO=97547486465713, ["Plug Walk"]=100359724990859,
    Slickback=103789826265487, ["Squat?"]=95441477641149, Insanity=129843344424281,
    Dropper=130358790702800, ["Be Not Afraid"]=70635223083942, ["Golden Freddy"]=122463450997235,
    Slenderman=81926508907412, Invisible=109899950448992, Paranoid=123407922818447,
    Thinking=124584711308900, Onion=113890289455724, Smeeze=131683926643291,
    Mesmerizer=92707348383277, ["24 Hour Cinderella"]=122972776209997,
    ["Stylish Float"]=97497383284399, ["Absolute Cinema"]=97258018304125, ["Become A Car"]=131544122623505,
    ["Aura Fly"]=78755795767408, Ballin=96293409369770, ["Die Lit"]=121001502815813,
    CaramellDansen=93105950995997, ["RAT DANCE"]=133461102795137, ["Belly Dancing"]=131939729732240,
    Xaviersobased=131763631172236, ["Take The L"]=123159156696507, ["Wally West"]=133948663586698,
    ["R15 Death (Accurate)"]=114899970878842, Chronoshift=92600655160976, ["Floating on Clouds"]=111426928948833,
    ["Jersey Joe"]=134149640725489, ["Virtual Insanity"]=83261816934732, ["Doodle Dance"]=107091254142209,
    ["Club Penguin"]=98099211500155, ["Subject 3"]=83732367439808, Teto=93031502567721,
    ["Hakari (FULL)"]=71056659089869, ["Strongest Stance"]=80146495484274, ["Locked In"]=110145155419199,
    ["Come At Me [ R6 ]"]=107758370940834, GOALL=78830825254717, ["Lethal Dance"]=77108921633993,
    ["At Ease"]=76993139936388, ["Aura Farm Boat"]=88042995626011, ["Prince Of Egypt"]=134063402217274,
    ["California Girl"]=132074413582912, ["Car Transformation"]=96887377943085, ["Family Guy"]=78459263478161,
}
local EmoteList = {}
for k in pairs(EMOTES) do table.insert(EmoteList, k) end
table.sort(EmoteList, function(a,b) return a:lower() < b:lower() end)
function Luxt1.PlayAnimationBody(idle, idle2, idle3, walk, run, jump, climb, fall, swim, swimIdle)
    local c = LocalPlayer.Character
    local a = c and c:FindFirstChild("Animate")
    if not a then return end
    if not getgenv().Luxt1OrigAnims then
        local t = {}
        pcall(function()
            t.idle1 = a.idle.Animation1.AnimationId
            t.idle2 = a.idle.Animation2.AnimationId
            t.walk = a.walk:FindFirstChildOfClass("Animation").AnimationId
            t.run = a.run:FindFirstChildOfClass("Animation").AnimationId
            t.jump = a.jump:FindFirstChildOfClass("Animation").AnimationId
            t.climb = a.climb:FindFirstChildOfClass("Animation").AnimationId
            t.fall = a.fall:FindFirstChildOfClass("Animation").AnimationId
            if a:FindFirstChild("swim") then
                t.swim = a.swim:FindFirstChildOfClass("Animation").AnimationId
                t.swimIdle = a.swimidle:FindFirstChildOfClass("Animation").AnimationId
            end
        end)
        getgenv().Luxt1OrigAnims = t
    end
    pcall(function()
        if a:FindFirstChild("idle") then
            a.idle.Animation1.AnimationId = AnimURL..idle
            a.idle.Animation2.AnimationId = AnimURL..idle2
        end
        if idle3 and idle3 ~= "None" and tonumber(idle3) and tonumber(idle3) > 0 and a:FindFirstChild("pose") then
            local pa = a.pose:FindFirstChildOfClass("Animation")
            if pa then pa.AnimationId = AnimURL..idle3 end
        end
        a.walk:FindFirstChildOfClass("Animation").AnimationId = AnimURL..walk
        a.run:FindFirstChildOfClass("Animation").AnimationId = AnimURL..run
        a.jump:FindFirstChildOfClass("Animation").AnimationId = AnimURL..jump
        a.climb:FindFirstChildOfClass("Animation").AnimationId = AnimURL..climb
        a.fall:FindFirstChildOfClass("Animation").AnimationId = AnimURL..fall
        if a:FindFirstChild("swim") then
            a.swim:FindFirstChildOfClass("Animation").AnimationId = AnimURL..swim
            a.swimidle:FindFirstChildOfClass("Animation").AnimationId = AnimURL..swimIdle
        end
    end)
end
function Luxt1.ResetAnimation()
    local t = getgenv().Luxt1OrigAnims
    local c = LocalPlayer.Character
    local a = c and c:FindFirstChild("Animate")
    if not (t and a) then return end
    pcall(function()
        a.idle.Animation1.AnimationId = t.idle1
        a.idle.Animation2.AnimationId = t.idle2
        a.walk:FindFirstChildOfClass("Animation").AnimationId = t.walk
        a.run:FindFirstChildOfClass("Animation").AnimationId = t.run
        a.jump:FindFirstChildOfClass("Animation").AnimationId = t.jump
        a.climb:FindFirstChildOfClass("Animation").AnimationId = t.climb
        a.fall:FindFirstChildOfClass("Animation").AnimationId = t.fall
        if a:FindFirstChild("swim") and t.swim then
            a.swim:FindFirstChildOfClass("Animation").AnimationId = t.swim
            a.swimidle:FindFirstChildOfClass("Animation").AnimationId = t.swimIdle
        end
    end)
end
function Luxt1.PlayEmote(name)
    local id = EMOTES[name]
    if not id then notify(T("Emotes"), T("Emote not found"), 2) return end
    Luxt1.StopEmotes()
    local c = LocalPlayer.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    local a = Instance.new("Animation")
    a.AnimationId = "rbxassetid://"..id
    Luxt1.emoteTrack = animator:LoadAnimation(a)
    Luxt1.emoteTrack.Looped = true
    Luxt1.emoteTrack:Play()
end
function Luxt1.StopEmotes()
    if Luxt1.emoteTrack then pcall(function() Luxt1.emoteTrack:Stop() end) Luxt1.emoteTrack = nil end
end

-- ═══ TARGET SELECT + AIMLOCK ═══
function Luxt1.setAimlock(on)
    F.aimlock = on
    if Luxt1.aimConn then killConn(Luxt1.aimConn) Luxt1.aimConn = nil end
    if on and Luxt1.SelectedPlayer then
        Luxt1.aimConn = RunService.RenderStepped:Connect(function()
            if Luxt1.SelectedPlayer and Luxt1.SelectedPlayer.Character then
                local hrp = Luxt1.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local cam = workspace.CurrentCamera
                    cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
                end
            end
        end)
        track(Luxt1.aimConn)
    end
end

-- ═══ FPS / PING HUD ═══
function Luxt1.statHudSet(on)
    F.statsHud = on
    if on then
        if not (Luxt1.statFrame and Luxt1.statFrame.Parent) then
            Luxt1.statGui = Instance.new("ScreenGui")
            Luxt1.statGui.Name="Luxt1_Stats"; Luxt1.statGui.ResetOnSpawn=false; Luxt1.statGui.IgnoreGuiInset=true; Luxt1.statGui.DisplayOrder=500
            pcall(function() Luxt1.statGui.Parent = game:GetService("CoreGui") end)
            if not Luxt1.statGui.Parent then Luxt1.statGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
            Luxt1.statFrame = Instance.new("Frame", Luxt1.statGui)
            Luxt1.statFrame.Size=UDim2.fromOffset(150,30)
            Luxt1.statFrame.Position=UDim2.new(0,10,0,10)
            Luxt1.statFrame.BackgroundColor3=BG_MAIN; Luxt1.statFrame.BackgroundTransparency=0.25
            Luxt1.statFrame.BorderSizePixel=0; Luxt1.statFrame.Active=true; Luxt1.statFrame.Draggable=true
            corner(Luxt1.statFrame, 8); stroke(Luxt1.statFrame, ACCENT, 1, 0.55)
            Luxt1.fpsLbl = Instance.new("TextLabel", Luxt1.statFrame)
            Luxt1.fpsLbl.BackgroundTransparency=1; Luxt1.fpsLbl.Size=UDim2.new(0.5,0,1,0)
            Luxt1.fpsLbl.Font=FONT_BOLD; Luxt1.fpsLbl.TextSize=12; Luxt1.fpsLbl.TextColor3=ACCENT_BRIGHT
            Luxt1.fpsLbl.Text="-- fps"
            Luxt1.msLbl = Instance.new("TextLabel", Luxt1.statFrame)
            Luxt1.msLbl.BackgroundTransparency=1; Luxt1.msLbl.Size=UDim2.new(0.5,0,1,0)
            Luxt1.msLbl.Position=UDim2.new(0.5,0,0,0)
            Luxt1.msLbl.Font=FONT_BOLD; Luxt1.msLbl.TextSize=12; Luxt1.msLbl.TextColor3=TEXT_DIM
            Luxt1.msLbl.Text="-- ms"
        end
        Luxt1.statGui.Enabled = true
    else
        if Luxt1.statGui then Luxt1.statGui.Enabled = false end
    end
end
task.spawn(function()
    while true do
        local frames = 0
        local conn = RunService.RenderStepped:Connect(function() frames += 1 end)
        task.wait(1)
        conn:Disconnect()
        local ping = 0
        pcall(function() ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if Luxt1.statFrame and Luxt1.statFrame.Parent and F.statsHud then
            Luxt1.fpsLbl.Text = tostring(frames).." fps"
            Luxt1.msLbl.Text = tostring(ping).." ms"
        end
    end
end)

-- ═══ MEOW OVERLAY ═══
local MEOW_DEFS = {
    Mimi = { url="https://raw.githubusercontent.com/Royal-Script-hub/mimka/main/mimka.png", cw=128, ch=160, gx=5, gy=5, frames=23, ox=-120, oy=-100, temp="temp_mimi_" },
    Furry = { url="https://raw.githubusercontent.com/Royal-Script-hub/mimka/main/furryan.png", cw=128, ch=128, gx=5, gy=4, frames=18, ox=-135, oy=-57, temp="temp_furry_" },
    Koti = { url="https://raw.githubusercontent.com/Royal-Script-hub/mimka/main/koti1.png", single=true, w=230, h=230, ox=-230, oy=-90, temp="temp_koti_" },
    ["Protogen Bongo"] = { url="https://raw.githubusercontent.com/Royal-Script-hub/mimka/main/protogen-bongo.png", proto=true, cw=128, ch=128, ox=-150, oy=-23, temp="temp_proto_" },
}
local meowState = { frame = 0, t = 0 }
local function meowEnsure()
    if Luxt1.meowGui and Luxt1.meowGui.Parent then return end
    Luxt1.meowGui = Instance.new("ScreenGui")
    Luxt1.meowGui.Name="Luxt1_Meow"; Luxt1.meowGui.IgnoreGuiInset=true
    Luxt1.meowGui.ZIndexBehavior=Enum.ZIndexBehavior.Global; Luxt1.meowGui.DisplayOrder=10000
    Luxt1.meowGui.ResetOnSpawn=false
    pcall(function() Luxt1.meowGui.Parent = gethui and gethui() or game:GetService("CoreGui") end)
    if not Luxt1.meowGui.Parent then Luxt1.meowGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    Luxt1.meowFrame = Instance.new("Frame", Luxt1.meowGui)
    Luxt1.meowFrame.BackgroundTransparency=1; Luxt1.meowFrame.ClipsDescendants=true; Luxt1.meowFrame.Visible=false; Luxt1.meowFrame.ZIndex=10000
    Luxt1.meowImg = Instance.new("ImageLabel", Luxt1.meowFrame)
    Luxt1.meowImg.BackgroundTransparency=1; Luxt1.meowImg.ZIndex=10001
end
track(RunService.RenderStepped:Connect(function()
    -- Meow overlay disabled (no external cat-art assets)
    if Luxt1.meowFrame then Luxt1.meowFrame.Visible = false end
end))

-- ═══ CTRL+CLICK TP ═══
track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not F.ctrlTP then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if mouse.Hit then
            local c = LocalPlayer.Character
            if c then c:PivotTo(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))) end
        end
    end
end))

-- ═══ SCREEN BUTTONS (быстрые кнопки на экране) ═══
Luxt1.ScreenToggles = {
    { name="Fly",       get=function() return F.fly end,       set=function(v) Luxt1.setFly(v) end },
    { name="Noclip",    get=function() return F.noclip end,    set=function(v) Luxt1.setNoclip(v) end },
    { name="ESP",       get=function() return F.playersESP end,set=function(v) Luxt1.setPlayersESP(v) end },
    { name="SilentAim", get=function() return F.silent end,    set=function(v) F.silent = v end },
    { name="AutoShoot", get=function() return F.autoShoot end, set=function(v) F.autoShoot = v end },
    { name="KillAura",  get=function() return Luxt1.kaOn end,  set=function(v) if v then Luxt1.killAuraStart() else Luxt1.killAuraStop() end end },
    { name="Spin",      get=function() return F.spin end,      set=function(v) Luxt1.setSpin(v) end },
    { name="WalkFling", get=function() return F.walkFling end, set=function(v) Luxt1.setWalkFling(v) end },
}
Luxt1.screenBtns = {}
local screenBtnGui
local function ensureScreenBtns()
    if screenBtnGui and screenBtnGui.Parent then return end
    screenBtnGui = Instance.new("ScreenGui")
    screenBtnGui.Name="Luxt1_ScreenBtns"; screenBtnGui.ResetOnSpawn=false
    screenBtnGui.IgnoreGuiInset=true; screenBtnGui.DisplayOrder=800
    pcall(function() screenBtnGui.Parent = gethui and gethui() or game:GetService("CoreGui") end)
    if not screenBtnGui.Parent then screenBtnGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end
function Luxt1.toggleScreenBtn(id)
    ensureScreenBtns()
    if Luxt1.screenBtns[id] then
        pcall(function() Luxt1.screenBtns[id].frame:Destroy() end)
        Luxt1.screenBtns[id] = nil
        return false
    end
    local def = nil
    for _, d in ipairs(Luxt1.ScreenToggles) do
        if d.name == id then def = d break end
    end
    if not def then return false end
    local idx = 0
    for _ in pairs(Luxt1.screenBtns) do idx += 1 end
    local frame = Instance.new("Frame", screenBtnGui)
    frame.Size = UDim2.fromOffset(120, 30)
    frame.Position = UDim2.new(0, 10, 0.5, -200 + 38 * idx)
    frame.BackgroundColor3 = BG_MAIN
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    corner(frame, 8)
    stroke(frame, ACCENT, 1, 0.5)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Font = FONT_BOLD
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.TextColor3 = TEXT
    btn.ZIndex = 5
    local function render()
        local on = false
        pcall(function() on = def.get() end)
        btn.Text = (on and "● " or "○ ") .. id
        btn.TextColor3 = on and Color3.fromRGB(90, 230, 130) or TEXT_DIM
    end
    render()
    btn.MouseButton1Click:Connect(function()
        local cur = false
        pcall(function() cur = def.get() end)
        def.set(not cur)
        render()
        SoundModule.play(SOUNDS["Laser Click"])
    end)
    task.spawn(function()
        while frame.Parent do
            task.wait(0.5)
            pcall(render)
        end
    end)
    Luxt1.screenBtns[id] = { frame = frame }
    return true
end

-- ═══ RESPAWN RESTORE ═══
track(LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    local cam = workspace.CurrentCamera
    local hum = c:FindFirstChildOfClass("Humanoid")
    if cam and hum then cam.CameraType = Enum.CameraType.Custom; cam.CameraSubject = hum end
    if hum then hum.WalkSpeed = F.ws end
    if F.blink then task.wait(0.2) local _, hrp = getChar() if hrp then hrp.Anchored = true end end
    if F.antiAim then Luxt1.antiAimStart() end
    if F.jumpCircle then task.delay(0.2, function() Luxt1.setJumpCircle(true) end) end
    if Luxt1.pendingAura then
        Luxt1.auraClear()
        task.wait(0.3)
        Luxt1.auraApply(Luxt1.pendingAura.assetId, Luxt1.pendingAura.name, true)
    end
    if F.water then Luxt1.setWater(true) end
    if F.jerk then Luxt1.setJerk(true) end
    if F.spin then Luxt1.setSpin(true) end
    if F.walkFling then Luxt1.setWalkFling(true) end
    if F.gunModel ~= "None" then task.wait(0.2) Luxt1.gunApplyAll() end
    if F.chinaHat then Luxt1.chinaHatCreate(c) end
    if F.korblox then Luxt1.korbloxApply(c) end
    if F.hideSkins then Luxt1.hsWatch(c) end
    if F.fly then Luxt1.flyMovers(true) end
    if F.aimlock and Luxt1.SelectedPlayer then Luxt1.setAimlock(true) end
end))

-- ═══ UNLOAD ═══
function Luxt1.unloadAll()
    Luxt1.setFly(false); Luxt1.setNoclip(false); Luxt1.setBlink(false); Luxt1.setSpin(false); Luxt1.setJerk(false)
    Luxt1.setWalkFling(false); Luxt1.antiAimStop(); Luxt1.setAntiFling(false); Luxt1.setGhost(false); Luxt1.setAspect(false)
    Luxt1.setPlayersESP(false); Luxt1.setTrapsESP(false); F.targetESP=false; F.targetHUD=false; Luxt1.setBoxESP(false)
    F.autoShoot=false; F.silent=false; F.forceShoot=false
    Luxt1.setAutoKnife(false); Luxt1.killAuraStop(); Luxt1.setVote(false); Luxt1.setAutoFarm(false)
    Luxt1.setWater(false); Luxt1.coinLoopOn=false; Luxt1.setFadeOff(false); Luxt1.setHideSkins(false)
    Luxt1.setKorblox(false); Luxt1.setChinaHat(false); Luxt1.setJumpCircle(false)
    Luxt1.rtxOff(); F.timeLock="Off"; F.weather="Off"; Luxt1.weatherApply(); Luxt1.skyboxRemove()
    F.magicAura=false; F.trail.on=false; F.tracer.on=false; Luxt1.setTrade(false)
    Luxt1.setAimlock(false); Luxt1.StopEmotes(); F.statsHud=false
    if targetUI.espGui then pcall(function() targetUI.espGui:Destroy() end) end
    if targetUI.hudGui then pcall(function() targetUI.hudGui:Destroy() end) end
    if Luxt1.boxGui then pcall(function() Luxt1.boxGui:Destroy() end) end
    if Luxt1.statGui then pcall(function() Luxt1.statGui:Destroy() end) end
    if screenBtnGui then pcall(function() screenBtnGui:Destroy() end) screenBtnGui = nil end
    Luxt1.screenBtns = {}
    for _, c in ipairs(conns) do killConn(c) end
    table.clear(conns)
    if Luxt1.MainGui then pcall(function() Luxt1.MainGui:Destroy() end) end
    if Luxt1.meowGui then pcall(function() Luxt1.meowGui:Destroy() end) end
    notify(T("Luxt1"), T("Unloaded"), 2)
end

-- ═══ SNOWFLAKES ═══
local function parentToCore(gui)
    local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not ok or not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end
local function spawnSnowflake(layer, config)
    config = config or {}
    local size = config.size or math.random(14, 26)
    local life = config.life or math.random(5, 9)
    local startPos = config.startPos or UDim2.fromScale(math.random(), -0.15)
    local endX = config.endX or (startPos.X.Scale + (math.random() - 0.5) * 0.35)
    local endY = config.endY or 1.15
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency=1; holder.AnchorPoint=Vector2.new(0.5,0.5)
    holder.Position=startPos; holder.Size=UDim2.fromOffset(size,size)
    holder.ZIndex=config.zIndex or 3; holder.Parent=layer
    local imgSnow = Instance.new("ImageLabel")
    imgSnow.BackgroundTransparency=1; imgSnow.Size=UDim2.fromScale(1,1)
    imgSnow.AnchorPoint=Vector2.new(0.5,0.5); imgSnow.Position=UDim2.fromScale(0.5,0.5)
    imgSnow.Image=img(ASSETS.snowflake); imgSnow.ImageColor3=Color3.fromRGB(255,255,255)
    imgSnow.ImageTransparency=0.45; imgSnow.ScaleType=Enum.ScaleType.Fit
    imgSnow.ZIndex=holder.ZIndex+1; imgSnow.Parent=holder
    tween(holder, { Position=UDim2.fromScale((startPos.X.Scale+endX)/2 + (math.random()-0.5)*0.1, (startPos.Y.Scale+endY)/2) },
        life*0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    task.delay(life*0.5, function()
        if holder and holder.Parent then
            tween(holder, { Position=UDim2.fromScale(endX, endY) }, life*0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        end
    end)
    task.delay(life+0.3, function() pcall(function() holder:Destroy() end) end)
end
local function burstSnow(layer)
    if not layer or not layer.Parent then return end
    for i = 1, 22 do
        task.delay(i*0.025, function()
            if not layer.Parent then return end
            local angle = math.random()*math.pi*2
            local dist = math.random(15,40)/100
            spawnSnowflake(layer, { size=math.random(16,26), life=math.random(3,5),
                startPos=UDim2.fromScale(0.5,0.5),
                endX=0.5+math.cos(angle)*dist, endY=0.5+math.sin(angle)*dist, zIndex=6 })
        end)
    end
end
local function startAmbient(layer)
    local running = true
    task.spawn(function()
        while running do
            if layer and layer.Parent then
                spawnSnowflake(layer, { size=math.random(12,26), life=math.random(6,11),
                    startPos=UDim2.fromScale(math.random(), -0.15), endX=math.random(), endY=1.15, zIndex=2 })
            else break end
            task.wait(math.random(250,500)/1000)
        end
    end)
    return function() running = false end
end
local function createScreenLayer()
    local gui = Instance.new("ScreenGui")
    gui.Name="Luxt1_Snowflakes"; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=5
    parentToCore(gui)
    local layer = Instance.new("Frame")
    layer.Name="Layer"; layer.BackgroundTransparency=1
    layer.Size=UDim2.fromScale(1,1); layer.ZIndex=0; layer.Parent=gui
    return gui, layer
end

-- ═══ PRELOADER ═══
local function createPreloader(onPick)
    local preGui, preLayer = createScreenLayer()
    preGui.Name = "Luxt1_Preloader"
    local backdrop = Instance.new("Frame")
    backdrop.BackgroundColor3=Color3.fromRGB(6,5,10); backdrop.BackgroundTransparency=1
    backdrop.BorderSizePixel=0; backdrop.Size=UDim2.fromScale(1,1); backdrop.ZIndex=1; backdrop.Parent=preGui
    local card = Instance.new("Frame")
    card.AnchorPoint=Vector2.new(0.5,0.5); card.Position=UDim2.fromScale(0.5,0.5)
    card.Size=UDim2.fromOffset(380,280); card.BackgroundColor3=BG_MAIN
    card.BackgroundTransparency=1; card.BorderSizePixel=0
    card.ClipsDescendants=true; card.ZIndex=5; card.Parent=preGui
    corner(card, 18)
    local cardStroke = stroke(card, ACCENT, 1.2, 1)
    local logoFrame = Instance.new("ImageLabel")
    logoFrame.BackgroundTransparency=1; logoFrame.AnchorPoint=Vector2.new(0.5,0)
    logoFrame.Position=UDim2.new(0.5,0,0,12); logoFrame.Size=UDim2.fromOffset(64,64)
    logoFrame.Image=img(ASSETS.logo); logoFrame.ScaleType=Enum.ScaleType.Fit
    logoFrame.ImageTransparency=1; logoFrame.ZIndex=7; logoFrame.Parent=card
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency=1; title.Position=UDim2.new(0,0,0,84)
    title.Size=UDim2.new(1,0,0,30); title.Font=FONT_BOLD
    title.Text=T("What's your language?"); title.TextColor3=TEXT
    title.TextSize=22; title.TextXAlignment=Enum.TextXAlignment.Center
    title.TextTransparency=1; title.ZIndex=7; title.Parent=card
    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency=1; sub.Position=UDim2.new(0,0,0,116)
    sub.Size=UDim2.new(1,0,0,22); sub.Font=FONT
    sub.Text=T("Pick a language to start"); sub.TextColor3=TEXT_DIM
    sub.TextSize=14; sub.TextXAlignment=Enum.TextXAlignment.Center
    sub.TextTransparency=1; sub.ZIndex=7; sub.Parent=card
    local btns = Instance.new("Frame")
    btns.BackgroundTransparency=1; btns.Position=UDim2.new(0,20,0,158)
    btns.Size=UDim2.new(1,-40,0,76); btns.ZIndex=7; btns.Parent=card
    local brL = Instance.new("UIListLayout")
    brL.FillDirection=Enum.FillDirection.Horizontal
    brL.HorizontalAlignment=Enum.HorizontalAlignment.Center
    brL.VerticalAlignment=Enum.VerticalAlignment.Center
    brL.Padding=UDim.new(0,14); brL.SortOrder=Enum.SortOrder.LayoutOrder; brL.Parent=btns
    local function makeLangBtn(order, flagText, labelText, code)
        local b = Instance.new("TextButton")
        b.LayoutOrder=order; b.BackgroundColor3=BG_ITEM; b.BackgroundTransparency=1
        b.BorderSizePixel=0; b.Size=UDim2.fromOffset(160,64); b.Text=""
        b.AutoButtonColor=false; b.ZIndex=8; b.Parent=btns
        corner(b, 12); local bs = stroke(b, OUTLINE, 1, 1)
        local flagLbl = Instance.new("TextLabel")
        flagLbl.BackgroundTransparency=1; flagLbl.Position=UDim2.new(0,12,0,0)
        flagLbl.Size=UDim2.new(0,50,1,0); flagLbl.Font=FONT_BOLD; flagLbl.Text=flagText
        flagLbl.TextColor3=TEXT; flagLbl.TextSize=24; flagLbl.TextTransparency=1; flagLbl.ZIndex=9; flagLbl.Parent=b
        local nameLbl = Instance.new("TextLabel")
        nameLbl.BackgroundTransparency=1; nameLbl.Position=UDim2.new(0,66,0,10)
        nameLbl.Size=UDim2.new(1,-72,0,22); nameLbl.Font=FONT_BOLD; nameLbl.Text=labelText
        nameLbl.TextColor3=TEXT; nameLbl.TextSize=15; nameLbl.TextXAlignment=Enum.TextXAlignment.Left
        nameLbl.TextTransparency=1; nameLbl.ZIndex=9; nameLbl.Parent=b
        local codeLbl = Instance.new("TextLabel")
        codeLbl.BackgroundTransparency=1; codeLbl.Position=UDim2.new(0,66,0,32)
        codeLbl.Size=UDim2.new(1,-72,0,20); codeLbl.Font=FONT; codeLbl.Text=code
        codeLbl.TextColor3=ACCENT_BRIGHT; codeLbl.TextSize=12; codeLbl.TextXAlignment=Enum.TextXAlignment.Left
        codeLbl.TextTransparency=1; codeLbl.ZIndex=9; codeLbl.Parent=b
        b.MouseEnter:Connect(function()
            tween(b, { BackgroundColor3=BG_ITEM_HOVER, BackgroundTransparency=0 }, 0.14)
            tween(bs, { Color=ACCENT, Transparency=0.3 }, 0.14)
            tween(nameLbl, { TextColor3=ACCENT_BRIGHT }, 0.14)
            SoundModule.play(SOUNDS["Laser Click"])
        end)
        b.MouseLeave:Connect(function()
            tween(b, { BackgroundColor3=BG_ITEM, BackgroundTransparency=0.15 }, 0.14)
            tween(bs, { Color=OUTLINE, Transparency=0.55 }, 0.14)
            tween(nameLbl, { TextColor3=TEXT }, 0.14)
        end)
        return b, flagLbl, nameLbl, codeLbl
    end
    local btnEN, enFlag, enName, enCode = makeLangBtn(1, "EN", "English", "EN")
    local btnRU, ruFlag, ruName, ruCode = makeLangBtn(2, "RU", "Русский", "RU")
    local loadingFrame = Instance.new("Frame")
    loadingFrame.BackgroundTransparency=1; loadingFrame.Position=UDim2.new(0,24,1,-40)
    loadingFrame.Size=UDim2.new(1,-48,0,26); loadingFrame.ZIndex=7
    loadingFrame.Visible=false; loadingFrame.Parent=card
    local barBg = Instance.new("Frame")
    barBg.BackgroundColor3=BG_ITEM; barBg.BorderSizePixel=0
    barBg.Position=UDim2.new(0,0,0,18); barBg.Size=UDim2.new(1,0,0,4)
    barBg.ZIndex=8; barBg.Parent=loadingFrame; corner(barBg, 3)
    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3=ACCENT; barFill.BorderSizePixel=0
    barFill.Size=UDim2.new(0,0,1,0); barFill.ZIndex=9; barFill.Parent=barBg; corner(barFill, 3)
    tween(backdrop, { BackgroundTransparency=0.3 }, 0.45)
    tween(card, { BackgroundTransparency=0, Size=UDim2.fromOffset(420,300) }, 0.55, Enum.EasingStyle.Back)
    tween(cardStroke, { Transparency=0.4 }, 0.6)
    tween(logoFrame, { ImageTransparency=0 }, 0.5)
    task.delay(0.2, function()
        tween(title, { TextTransparency=0 }, 0.4)
        tween(sub, { TextTransparency=0 }, 0.4)
    end)
    task.delay(0.35, function()
        for _, obj in ipairs({ btnEN, btnRU }) do tween(obj, { BackgroundTransparency=0.15 }, 0.4) end
        for _, obj in ipairs({ enFlag, ruFlag, enName, ruName, enCode, ruCode }) do tween(obj, { TextTransparency=0 }, 0.4) end
        for _, b in ipairs({ btnEN, btnRU }) do
            local s = b:FindFirstChildOfClass("UIStroke")
            if s then tween(s, { Transparency=0.55 }, 0.4) end
        end
    end)
    task.spawn(function()
        for _ = 1, 10 do
            spawnSnowflake(preLayer, { size=math.random(14,22), life=math.random(5,8),
                startPos=UDim2.fromScale(math.random(), -0.15), endX=math.random(), endY=1.15, zIndex=3 })
            task.wait(math.random(400,900)/1000)
        end
    end)
    local picked = false
    local function pick(lang)
        if picked then return end
        picked = true
        Luxt1.Language = lang
        SoundModule.enable()
        -- reapply translations on next frame so all UI is in the chosen language
        task.delay(0.05, function() pcall(Luxt1.reapplyLang) end)
        title.Text = T("Loading...")
        sub.Text = T("Preparing interface")
        tween(btnEN, { BackgroundTransparency=1 }, 0.2)
        tween(btnRU, { BackgroundTransparency=1 }, 0.2)
        for _, obj in ipairs({ enFlag, ruFlag, enName, ruName, enCode, ruCode }) do tween(obj, { TextTransparency=1 }, 0.2) end
        task.wait(0.25)
        btnEN.Visible=false; btnRU.Visible=false
        loadingFrame.Visible=true
        tween(barFill, { Size=UDim2.new(1,0,1,0) }, 0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        burstSnow(preLayer)
        task.delay(0.8, function()
            tween(card, { Size=UDim2.fromOffset(340,240), BackgroundTransparency=1 }, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            tween(cardStroke, { Transparency=1 }, 0.35)
            tween(title, { TextTransparency=1 }, 0.3)
            tween(sub, { TextTransparency=1 }, 0.3)
            tween(logoFrame, { ImageTransparency=1 }, 0.3)
            tween(backdrop, { BackgroundTransparency=1 }, 0.5)
            task.delay(0.5, function()
                pcall(function() preGui:Destroy() end)
                if onPick then onPick(lang) end
            end)
        end)
    end
    btnEN.MouseButton1Click:Connect(function() pick("EN") end)
    btnRU.MouseButton1Click:Connect(function() pick("RU") end)
end

-- ═══ WINDOW + ELEMENTS ═══
Luxt1.uiRefs = {}
function Luxt1.CreateWindow(libName)
    libName = libName or "Luxt1"
    local winW, winH = 640, 480
    local sidebarW = 172
    local parentGui = nil
    pcall(function()
        parentGui = (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if parentGui then
        local okProbe = pcall(function()
            local probe = Instance.new("Folder")
            probe.Parent = parentGui
            probe:Destroy()
        end)
        if not okProbe then parentGui = nil end
    end
    if not parentGui then
        parentGui = LocalPlayer:WaitForChild("PlayerGui")
    end
    local old = parentGui:FindFirstChild("LuxtLib" .. libName)
    if old then old:Destroy() end
    local LuxtLib = Instance.new("ScreenGui")
    LuxtLib.Name = "LuxtLib" .. libName
    LuxtLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LuxtLib.ResetOnSpawn = false
    LuxtLib.IgnoreGuiInset = true
    LuxtLib.Parent = parentGui
    Luxt1.MainGui = LuxtLib
    local particleGui, particleLayer = createScreenLayer()
    particleGui.Name = "Luxt1_Ambient"
    local MainFrame = Instance.new("Frame")
    MainFrame.Name="MainFrame"; MainFrame.Parent=LuxtLib
    MainFrame.BackgroundColor3=BG_MAIN; MainFrame.BackgroundTransparency=1
    MainFrame.BorderSizePixel=0; MainFrame.AnchorPoint=Vector2.new(0.5,0.5)
    MainFrame.Position=UDim2.fromScale(0.5,0.5)
    MainFrame.Size=UDim2.fromOffset(winW*0.5, winH*0.5)
    MainFrame.ClipsDescendants=true; MainFrame.ZIndex=1; MainFrame.Visible=true
    corner(MainFrame, 16)
    local mainStroke = stroke(MainFrame, OUTLINE, 1, 1)
    Luxt1.MainFrame = MainFrame
    local shadowImg = Instance.new("ImageLabel")
    shadowImg.BackgroundTransparency=1
    shadowImg.Image=img(ASSETS.shadow); shadowImg.ImageColor3=Color3.fromRGB(30,15,60)
    shadowImg.ImageTransparency=1; shadowImg.Size=UDim2.new(1,80,1,80)
    shadowImg.Position=UDim2.new(0,-40,0,-40); shadowImg.ZIndex=0
    shadowImg.ScaleType=Enum.ScaleType.Slice
    shadowImg.SliceCenter=Rect.new(Vector2.new(112,112), Vector2.new(147,147))
    shadowImg.SliceScale=0.6; shadowImg.Parent=MainFrame
    local contentRoot = Instance.new("Frame")
    contentRoot.BackgroundTransparency=1; contentRoot.Size=UDim2.fromScale(1,1)
    contentRoot.ZIndex=2; contentRoot.Parent=MainFrame
    local sideHeading = Instance.new("Frame")
    sideHeading.Parent=contentRoot; sideHeading.BackgroundColor3=BG_SIDE
    sideHeading.BackgroundTransparency=0.08; sideHeading.BorderSizePixel=0
    sideHeading.Size=UDim2.new(0,sidebarW,1,0); sideHeading.ZIndex=3
    corner(sideHeading, 16)
    local LOGO_SIZE = 40
    local hubLogo = Instance.new("ImageLabel")
    hubLogo.Parent=sideHeading; hubLogo.BackgroundTransparency=1
    hubLogo.Position=UDim2.new(0,14,0,14); hubLogo.Size=UDim2.fromOffset(LOGO_SIZE,LOGO_SIZE)
    hubLogo.ZIndex=4; hubLogo.Image=img(ASSETS.logo); hubLogo.ScaleType=Enum.ScaleType.Fit
    corner(hubLogo, 10)
    local hubName = Instance.new("TextLabel")
    hubName.Parent=sideHeading; hubName.BackgroundTransparency=1
    hubName.Position=UDim2.new(0,14+LOGO_SIZE+10,0,16); hubName.Size=UDim2.new(1,-(14+LOGO_SIZE+20),0,18)
    hubName.ZIndex=4; hubName.Font=FONT_BOLD; hubName.Text=libName
    hubName.TextColor3=TEXT; hubName.TextSize=15; hubName.TextXAlignment=Enum.TextXAlignment.Left
    local usename = Instance.new("TextLabel")
    usename.Parent=sideHeading; usename.BackgroundTransparency=1
    usename.Position=UDim2.new(0,14+LOGO_SIZE+10,0,36); usename.Size=UDim2.new(1,-(14+LOGO_SIZE+20),0,14)
    usename.ZIndex=4; usename.Font=FONT; usename.Text="@"..(LocalPlayer and LocalPlayer.Name or T("Player"))
    usename.TextColor3=TEXT_DIM; usename.TextSize=11
    usename.TextXAlignment=Enum.TextXAlignment.Left; usename.TextTruncate=Enum.TextTruncate.AtEnd
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Parent=sideHeading; tabFrame.BackgroundTransparency=1; tabFrame.BorderSizePixel=0
    tabFrame.Position=UDim2.new(0,10,0,14+LOGO_SIZE+22)
    tabFrame.Size=UDim2.new(1,-16,1,-(14+LOGO_SIZE+22+44))
    tabFrame.ZIndex=4; tabFrame.ScrollBarThickness=2; tabFrame.ScrollBarImageColor3=ACCENT
    tabFrame.CanvasSize=UDim2.new(0,0,0,0); tabFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local tabList = Instance.new("UIListLayout")
    tabList.Parent=tabFrame; tabList.SortOrder=Enum.SortOrder.LayoutOrder; tabList.Padding=UDim.new(0,3)
    local key1 = Instance.new("TextButton")
    key1.Parent=sideHeading; key1.BackgroundColor3=BG_ITEM
    key1.Position=UDim2.new(0,12,1,-34); key1.Size=UDim2.new(0,78,0,22)
    key1.ZIndex=4; key1.Font=FONT; key1.Text="LeftAlt"; key1.TextColor3=ACCENT
    key1.TextSize=11; key1.AutoButtonColor=false
    corner(key1, 8); stroke(key1, ACCENT, 1, 0.65)
    local keybindInfo1 = Instance.new("TextLabel")
    keybindInfo1.Parent=sideHeading; keybindInfo1.BackgroundTransparency=1
    keybindInfo1.Position=UDim2.new(0,96,1,-34); keybindInfo1.Size=UDim2.new(1,-108,0,22)
    keybindInfo1.ZIndex=4; keybindInfo1.Font=FONT; keybindInfo1.Text=T("Close")
    keybindInfo1.TextColor3=TEXT_DIM; keybindInfo1.TextSize=12
    keybindInfo1.TextXAlignment=Enum.TextXAlignment.Left
    Luxt1.ToggleKey = "LeftAlt"
    key1.MouseButton1Click:Connect(function()
        key1.Text = "..."
        local a = UserInputService.InputBegan:Wait()
        if a.KeyCode.Name ~= "Unknown" then
            key1.Text = a.KeyCode.Name
            Luxt1.ToggleKey = a.KeyCode.Name
        end
    end)
    local framesAll = Instance.new("Frame")
    framesAll.Parent=contentRoot; framesAll.BackgroundTransparency=1
    framesAll.BorderSizePixel=0; framesAll.Position=UDim2.new(0,sidebarW+10,0,10)
    framesAll.Size=UDim2.new(1,-(sidebarW+20),1,-20); framesAll.ZIndex=3
    local pageFolder = Instance.new("Folder")
    pageFolder.Name="pageFolder"; pageFolder.Parent=framesAll
    local currentHolder = nil
    local switching = false
    local function switchTo(holder)
        if switching or holder == currentHolder then return end
        switching = true
        for _, v in ipairs(pageFolder:GetChildren()) do
            if v ~= holder then v.Visible = false end
        end
        holder.Visible = true
        holder.GroupTransparency = 1
        tween(holder, { GroupTransparency=0 }, 0.25, Enum.EasingStyle.Quint)
        currentHolder = holder
        task.delay(0.25, function() switching = false end)
    end
    local dragging, dragStart, startPos
    sideHeading.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    local TabHandling = {}
    local allTabs = {}
    local function deactivateAll()
        for _, tab in ipairs(allTabs) do
            if tab.highlight then tab.highlight.Visible = false end
            if tab.icon then
                if tab.iconKind == "glyph" then tween(tab.icon, { TextColor3=TEXT_DIM }, 0.15)
                else tween(tab.icon, { ImageColor3=TEXT_DIM }, 0.15) end
            end
            if tab.btn then tween(tab.btn, { TextColor3=TEXT_DIM }, 0.15) end
        end
    end
    function TabHandling:Tab(tabText, tabKey)
        tabText = tabText or "Tab"
        tabKey = tabKey or "esp"
        local _origTabText = tabText
        local glyphName = TAB_GLYPHS[tabKey] or GLYPH.crosshairs
        local tabBtnFrame = Instance.new("Frame")
        tabBtnFrame.BackgroundTransparency=1; tabBtnFrame.Size=UDim2.new(1,0,0,34)
        tabBtnFrame.ZIndex=4; tabBtnFrame.Parent=tabFrame
        local tabHighlight = Instance.new("Frame")
        tabHighlight.Parent=tabBtnFrame; tabHighlight.BackgroundColor3=BG_TAB_ACTIVE
        tabHighlight.BackgroundTransparency=0.25; tabHighlight.Size=UDim2.new(1,-4,1,0)
        tabHighlight.Position=UDim2.new(0,2,0,0); tabHighlight.ZIndex=3
        tabHighlight.Visible=false; corner(tabHighlight, 9); stroke(tabHighlight, ACCENT, 1, 0.7)
        local iconHolder = Instance.new("Frame")
        iconHolder.BackgroundTransparency=1; iconHolder.Position=UDim2.new(0,6,0.5,-12)
        iconHolder.Size=UDim2.fromOffset(24,24); iconHolder.ZIndex=4; iconHolder.Parent=tabBtnFrame
        local iconObj, iconKind = makeIcon(iconHolder, glyphName, ASSETS.searchIcon, 20, TEXT_DIM)
        iconObj.AnchorPoint=Vector2.new(0.5,0.5); iconObj.Position=UDim2.fromScale(0.5,0.5)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Parent=tabBtnFrame; tabBtn.BackgroundTransparency=1
        tabBtn.Position=UDim2.new(0,38,0,0); tabBtn.Size=UDim2.new(1,-40,1,0)
        tabBtn.ZIndex=4; tabBtn.Font=FONT; tabBtn.Text=tabText
        tabBtn.TextColor3=TEXT_DIM; tabBtn.TextSize=13
        tabBtn.TextXAlignment=Enum.TextXAlignment.Left; tabBtn.AutoButtonColor=false
        Luxt1._regText(tabBtn, _origTabText, "Text")
        local pageHolder = Instance.new("CanvasGroup")
        pageHolder.Name="pageHolder_"..tabText; pageHolder.Parent=pageFolder
        pageHolder.BackgroundTransparency=1; pageHolder.BorderSizePixel=0
        pageHolder.Size=UDim2.fromScale(1,1); pageHolder.GroupTransparency=1
        pageHolder.Visible=false; pageHolder.ZIndex=3
        local placeholder = Instance.new("TextLabel")
        placeholder.Parent=pageHolder; placeholder.BackgroundTransparency=1
        placeholder.Size=UDim2.new(1,0,0,40); placeholder.Font=FONT_BOLD
        placeholder.Text=tabText; placeholder.TextColor3=TEXT
        placeholder.TextSize=20; placeholder.TextXAlignment=Enum.TextXAlignment.Left; placeholder.ZIndex=4
        Luxt1._regText(placeholder, _origTabText, "Text")
        local content = Instance.new("ScrollingFrame")
        content.Name="Content"; content.BackgroundTransparency=1; content.BorderSizePixel=0
        content.Position=UDim2.new(0,0,0,46); content.Size=UDim2.new(1,0,1,-46)
        content.ScrollBarThickness=3; content.ScrollBarImageColor3=ACCENT
        content.CanvasSize=UDim2.new(0,0,0,0); content.AutomaticCanvasSize=Enum.AutomaticSize.Y
        content.ZIndex=4; content.Parent=pageHolder
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft=UDim.new(0,2); pad.PaddingRight=UDim.new(0,10); pad.PaddingBottom=UDim.new(0,10)
        pad.Parent=content
        local list = Instance.new("UIListLayout")
        list.Padding=UDim.new(0,6); list.SortOrder=Enum.SortOrder.LayoutOrder; list.Parent=content
        local api = { Holder=pageHolder, Content=content }
        local order = 0
        local function newRow(h, class)
            order += 1
            local row = Instance.new(class or "Frame")
            row.LayoutOrder=order; row.BackgroundColor3=BG_ITEM
            row.BackgroundTransparency=0.15; row.BorderSizePixel=0
            row.Size=UDim2.new(1,0,0,h); row.ZIndex=5
            if class == "TextButton" then row.Text=""; row.AutoButtonColor=false end
            corner(row, 9); stroke(row, OUTLINE, 1, 0.7)
            row.Parent=content
            return row
        end
        local function hookHover(row)
            row.MouseEnter:Connect(function()
                tween(row, { BackgroundColor3=BG_ITEM_HOVER, BackgroundTransparency=0.05 }, 0.12)
            end)
            row.MouseLeave:Connect(function()
                tween(row, { BackgroundColor3=BG_ITEM, BackgroundTransparency=0.15 }, 0.12)
            end)
        end
        function api:Section(text)
            order += 1
            local row = Instance.new("TextLabel")
            Luxt1._regText(row, text, "Text")
            row.LayoutOrder=order; row.BackgroundTransparency=1
            row.Size=UDim2.new(1,0,0,20); row.Font=FONT_BOLD
            row.Text=text; row.TextColor3=ACCENT_BRIGHT; row.TextSize=12
            row.TextXAlignment=Enum.TextXAlignment.Left; row.ZIndex=5; row.Parent=content
            return row
        end
        function api:Label(text)
            order += 1
            local row = Instance.new("TextLabel")
            Luxt1._regText(row, text, "Text")
            row.LayoutOrder=order; row.BackgroundTransparency=1
            row.Size=UDim2.new(1,0,0,18); row.Font=FONT
            row.Text=text; row.TextColor3=TEXT_DIM; row.TextSize=12
            row.TextXAlignment=Enum.TextXAlignment.Left; row.TextWrapped=true
            row.ZIndex=5; row.Parent=content
            return row
        end
        function api:Button(text, callback)
            local row = newRow(34, "TextButton")
            hookHover(row)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency=1
            lbl.Position=UDim2.new(0,12,0,0)
            lbl.Size=UDim2.new(1,-24,1,0)
            lbl.Font=FONT; lbl.Text=text; lbl.TextColor3=TEXT
            Luxt1._regText(lbl, text, "Text")
            lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Left
            lbl.ZIndex=6; lbl.Parent=row
            row.MouseButton1Click:Connect(function()
                SoundModule.play(SOUNDS["Laser Click"])
                if callback then pcall(callback) end
            end)
            return lbl
        end
        function api:Toggle(text, default, callback)
            local state = default and true or false
            local row = newRow(34, "TextButton")
            hookHover(row)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency=1
            lbl.Position=UDim2.new(0,12,0,0)
            lbl.Size=UDim2.new(1,-80,1,0)
            lbl.Font=FONT; lbl.Text=text; lbl.TextColor3=TEXT
            lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Left
            lbl.ZIndex=6; lbl.Parent=row
            Luxt1._regText(lbl, text, "Text")
            -- явная кнопка ВКЛ/ВЫКЛ
            local stateBtn = Instance.new("TextButton")
            Luxt1._regText(stateBtn, state and "ON" or "OFF", "Text")
            stateBtn.AnchorPoint=Vector2.new(1,0.5)
            stateBtn.Position=UDim2.new(1,-10,0.5,0)
            stateBtn.Size=UDim2.fromOffset(52,22)
            stateBtn.Font=FONT_BOLD; stateBtn.TextSize=11
            stateBtn.TextColor3=TEXT; stateBtn.AutoButtonColor=false
            stateBtn.ZIndex=7
            corner(stateBtn, 7)
            local stateStroke = stroke(stateBtn, OUTLINE, 1, 0.6)
            stateBtn.Parent=row
            local function render()
                if state then
                    stateBtn.Text = T("ON")
                    stateBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 90)
                    stateStroke.Color = Color3.fromRGB(90, 230, 130)
                else
                    stateBtn.Text = T("OFF")
                    stateBtn.BackgroundColor3 = BG_ITEM_HOVER
                    stateStroke.Color = OUTLINE
                end
            end
            render()
            local function doToggle()
                state = not state
                render()
                if state then SoundModule.enable() else SoundModule.disable() end
                if callback then pcall(callback, state) end
            end
            row.MouseButton1Click:Connect(doToggle)
            stateBtn.MouseButton1Click:Connect(doToggle)
            return {
                Set = function(v) state = v and true or false; render() end,
                Get = function() return state end,
                _stateBtn = stateBtn, _state = function() return state end, _render = render,
            }
        end
        function api:Slider(text, min, max, default, callback, step)
            min, max = min or 0, max or 100
            step = step or 1
            local value = math.clamp(default or min, min, max)
            local row = newRow(46)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,12,0,6)
            lbl.Size=UDim2.new(1,-24,0,16); lbl.Font=FONT
            lbl.Text=text; lbl.TextColor3=TEXT; lbl.TextSize=13
            lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=6; lbl.Parent=row
            Luxt1._regText(lbl, text, "Text")
            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency=1; valLbl.Position=UDim2.new(0,12,0,6)
            valLbl.Size=UDim2.new(1,-24,0,16); valLbl.Font=FONT_BOLD
            valLbl.TextColor3=ACCENT_BRIGHT; valLbl.TextSize=12
            valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.ZIndex=6; valLbl.Parent=row
            local bar = Instance.new("Frame")
            bar.Position=UDim2.new(0,12,0,30); bar.Size=UDim2.new(1,-24,0,6)
            bar.BackgroundColor3=BG_ITEM_HOVER; bar.BorderSizePixel=0
            bar.ZIndex=6; corner(bar, 3); bar.Parent=row
            local fill = Instance.new("Frame")
            fill.BackgroundColor3=ACCENT; fill.BorderSizePixel=0
            fill.Size=UDim2.fromScale(0,1); fill.ZIndex=7
            corner(fill, 3); fill.Parent=bar
            local function fmt(v)
                if step < 1 then return string.format("%.1f", v) end
                return tostring(math.floor(v + 0.5))
            end
            local function render()
                fill.Size = UDim2.fromScale((value - min) / (max - min), 1)
                valLbl.Text = fmt(value)
            end
            local function quant(v)
                v = math.clamp(v, min, max)
                v = min + math.floor((v - min) / step + 0.5) * step
                return math.clamp(v, min, max)
            end
            render()
            local draggingS = false
            local function setFromX(x)
                local rel = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
                value = quant(min + (max - min) * rel)
                render()
                if callback then pcall(callback, value) end
            end
            bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    draggingS = true; setFromX(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if draggingS and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    setFromX(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    draggingS = false
                end
            end)
            return {
                Set = function(v) value = quant(v); render() end,
                Get = function() return value end,
            }
        end
        function api:Dropdown(text, values, default, callback)
            -- Push-down dropdown: opening grows the row height so the UIListLayout
            -- in `content` shifts following rows down (no overlay).
            local closedH = 38
            local optH = 26
            local optStart = 40  -- below the 38px header with a small gap
            local openH = closedH + (#values * optH) + 6  -- extra padding at bottom

            local row = newRow(closedH)
            row.ZIndex = 7
            row.ClipsDescendants = true  -- clip options when closed (they're below row bounds)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,12,0,0)
            lbl.Size=UDim2.new(1,-160,0,closedH); lbl.Font=FONT
            lbl.Text=text; lbl.TextColor3=TEXT; lbl.TextSize=13
            lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8; lbl.Parent=row
            Luxt1._regText(lbl, text, "Text")
            local btn = Instance.new("TextButton")
            btn.AnchorPoint=Vector2.new(1,0); btn.Position=UDim2.new(1,-10,0,7)
            btn.Size=UDim2.fromOffset(130,24); btn.BackgroundColor3=BG_ITEM_HOVER
            btn.Font=FONT; btn.TextSize=12; btn.TextColor3=ACCENT_BRIGHT
            btn.Text=default or "--"; btn.AutoButtonColor=false; btn.ZIndex=9
            corner(btn, 7); stroke(btn, OUTLINE, 1, 0.5); btn.Parent=row
            local caret = Instance.new("TextLabel")
            caret.BackgroundTransparency=1; caret.AnchorPoint=Vector2.new(1,0.5)
            caret.Position=UDim2.new(1,-6,0.5,0); caret.Size=UDim2.fromOffset(12,14)
            caret.Font=FONT_BOLD; caret.TextSize=10; caret.TextColor3=ACCENT_BRIGHT
            caret.Text="v"; caret.Rotation=0; caret.ZIndex=10; caret.Parent=btn

            local isOpen = false
            local opts = {}
            for i, v in ipairs(values) do
                local ob = Instance.new("TextButton")
                ob.Position = UDim2.new(0, 8, 0, optStart + (i-1)*optH)
                ob.Size = UDim2.new(1, -16, 0, optH)
                ob.BackgroundColor3 = BG_ITEM
                ob.BackgroundTransparency = 0.05
                ob.BorderSizePixel = 0
                ob.Font = FONT; ob.TextSize = 12; ob.TextColor3 = TEXT_DIM
                ob.Text = tostring(v)
                ob.TextXAlignment = Enum.TextXAlignment.Left
                ob.Visible = false; ob.ZIndex = 11
                ob.AutoButtonColor = false
                corner(ob, 6); stroke(ob, OUTLINE, 1, 0.75)
                ob.Parent = row
                table.insert(opts, ob)
                ob.MouseButton1Click:Connect(function()
                    btn.Text = tostring(v)
                    closeDD()
                    SoundModule.play(SOUNDS["Laser Click"])
                    if callback then pcall(callback, v) end
                end)
                ob.MouseEnter:Connect(function() tween(ob, { BackgroundColor3=BG_ITEM_HOVER, BackgroundTransparency=0.05, TextColor3=TEXT }, 0.1) end)
                ob.MouseLeave:Connect(function() tween(ob, { BackgroundColor3=BG_ITEM, BackgroundTransparency=0.05, TextColor3=TEXT_DIM }, 0.1) end)
            end

            local function closeDD()
                if not isOpen then return end
                isOpen = false
                for _, o in ipairs(opts) do o.Visible = false end
                tween(caret, { Rotation=0 }, 0.12)
                -- Shrink the row back to closed height (UIListLayout re-flows automatically)
                tween(row, { Size = UDim2.new(1, 0, 0, closedH) }, 0.12)
            end
            local function openDD()
                if isOpen then return end
                isOpen = true
                for _, o in ipairs(opts) do o.Visible = true end
                tween(caret, { Rotation=180 }, 0.12)
                -- Grow row to fit all options (UIListLayout pushes following rows down)
                tween(row, { Size = UDim2.new(1, 0, 0, openH) }, 0.12)
            end
            btn.MouseButton1Click:Connect(function()
                if isOpen then closeDD() else openDD() end
                SoundModule.play(SOUNDS["Laser Click"])
            end)

            local function pointIn(guiObj)
                if not (guiObj and guiObj.Parent and guiObj.Visible) then return false end
                local mp = UserInputService:GetMouseLocation()
                local abs, sz = guiObj.AbsolutePosition, guiObj.AbsoluteSize
                return mp.X >= abs.X and mp.X <= abs.X + sz.X and mp.Y >= abs.Y and mp.Y <= abs.Y + sz.Y
            end
            local outsideConn
            outsideConn = UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                if not isOpen then return end
                local inside = pointIn(btn)
                if not inside then
                    for _, o in ipairs(opts) do
                        if pointIn(o) then inside = true break end
                    end
                end
                if not inside then closeDD() end
            end)
            track(outsideConn)

            return {
                Set = function(v) btn.Text = tostring(v) end,
                Get = function() return btn.Text end,
            }
        end
        function api:TextInput(text, default, placeholder, callback)
            local row = newRow(44)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,12,0,5)
            lbl.Size=UDim2.new(1,-24,0,15); lbl.Font=FONT
            lbl.Text=text; lbl.TextColor3=TEXT; lbl.TextSize=13
            lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=6; lbl.Parent=row
            Luxt1._regText(lbl, text, "Text")
            local box = Instance.new("TextBox")
            box.Position=UDim2.new(0,12,0,22); box.Size=UDim2.new(1,-24,0,16)
            box.BackgroundColor3=BG_ITEM_HOVER; box.BorderSizePixel=0
            box.Font=FONT; box.TextSize=12; box.TextColor3=TEXT
            box.Text=default or ""; box.PlaceholderText=placeholder or "..."
            box.PlaceholderColor3=TEXT_DIM; box.TextXAlignment=Enum.TextXAlignment.Left
            box.ClearTextOnFocus=false; box.ZIndex=6
            Luxt1._regText(box, placeholder or "...", "PlaceholderText")
            corner(box, 6); box.Parent=row
            box.FocusLost:Connect(function(enter)
                if enter then
                    SoundModule.play(SOUNDS["Laser Click"])
                    if callback then pcall(callback, box.Text) end
                end
            end)
            return {
                Set = function(v) box.Text = tostring(v) end,
                Get = function() return box.Text end,
            }
        end
        local entry = { btn=tabBtn, highlight=tabHighlight, icon=iconObj, iconKind=iconKind, holder=pageHolder }
        table.insert(allTabs, entry)
        tabBtn.MouseButton1Click:Connect(function()
            deactivateAll()
            tabHighlight.Visible = true
            tween(tabBtn, { TextColor3=TEXT }, 0.15)
            if iconKind == "glyph" then tween(iconObj, { TextColor3=ACCENT }, 0.15)
            else tween(iconObj, { ImageColor3=ACCENT }, 0.15) end
            switchTo(pageHolder)
            SoundModule.play(SOUNDS["Laser Click"])
        end)
        if #pageFolder:GetChildren() == 1 then
            pageHolder.Visible = true
            pageHolder.GroupTransparency = 0
            currentHolder = pageHolder
            tabHighlight.Visible = true
            tween(tabBtn, { TextColor3=TEXT }, 0.15)
            if iconKind == "glyph" then tween(iconObj, { TextColor3=ACCENT }, 0.15)
            else tween(iconObj, { ImageColor3=ACCENT }, 0.15) end
        end
        return api
    end
    TabHandling.Gui = LuxtLib
    TabHandling.MainFrame = MainFrame
    function TabHandling:Reveal()
        MainFrame.Visible = true
        MainFrame.BackgroundTransparency = 1
        MainFrame.Size = UDim2.fromOffset(winW*0.5, winH*0.5)
        mainStroke.Transparency = 1
        shadowImg.ImageTransparency = 1
        contentRoot.Visible = false
        burstSnow(particleLayer)
        SoundModule.enable()
        tween(MainFrame, { BackgroundTransparency=0 }, 0.3)
        tween(MainFrame, { Size=UDim2.fromOffset(winW, winH) }, 0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tween(mainStroke, { Transparency=0.68 }, 0.75)
        tween(shadowImg, { ImageTransparency=0.4 }, 0.8)
        task.delay(0.25, function()
            contentRoot.Visible = true
            contentRoot.GroupTransparency = 1
            tween(contentRoot, { GroupTransparency=0 }, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
        TabHandling._stopAmbient = startAmbient(particleLayer)
    end
    return TabHandling
end

-- ═══ CONFIGS ═══
function Luxt1.saveConfig(name)
    if not writefile then notify(T("Config"), T("Your executor does not support files!"), 3) return end
    name = (name or "default"):gsub("%.json$", "")
    local data = {}
    local bools = { "fly","noclip","blink","ctrlTP","spin","jerk","walkFling","antiAim","antiFling","ghost",
        "aspect","playersESP","gunESP","trapsESP","targetESP","targetHUD","boxESP","autoShoot","silent",
        "forceShoot","autoGetGun","water","antiCoin","fadeOff","autoKnife","killAura","vote","trade",
        "magicAura","chinaHat","jumpCircle","korblox","hideSkins","noReload","friendCheck","hitParts","hitSound" }
    for _, k in ipairs(bools) do data[k] = F[k] end
    data.flySpeed=F.flySpeed; data.ws=F.ws; data.fov=F.fov
    data.spinSpeed=F.spinSpeed; data.shootOff=F.shootOff; data.saimOff=F.saimOff
    data.silentKey=F.silentKey; data.pickup=F.pickup; data.votePad=F.votePad
    data.gunModel=F.gunModel; data.beamType=F.beamType; data.weather=F.weather
    data.timeLock=F.timeLock; data.meow=F.meow; data.hitSoundMode=F.hitSoundMode
    data.gunKill=F.gunKill; data.gunshot=F.gunshot; data.knifeKill=F.knifeKill
    data.farm = AF
    local json = HttpService:JSONEncode(data)
    if makefolder and not isfolder("Luxt1") then pcall(makefolder, "Luxt1") end
    local ok = pcall(writefile, "Luxt1/"..name..".json", json)
    if ok then notify(T("Config"), T("Saved: ")..name, 2) else notify(T("Config"), T("Save error!"), 3) end
end
function Luxt1.loadConfig(name)
    if not readfile then notify(T("Config"), T("Your executor does not support files!"), 3) return end
    name = (name or "default"):gsub("%.json$", "")
    local path = "Luxt1/"..name..".json"
    if not isfile(path) then notify(T("Config"), T("File not found!"), 3) return end
    local ok, raw = pcall(readfile, path)
    if not ok then notify(T("Config"), T("Read error!"), 3) return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(data) ~= "table" then notify(T("Config"), T("File corrupted!"), 3) return end
    local bools = { "fly","noclip","blink","ctrlTP","spin","jerk","walkFling","antiAim","antiFling","ghost",
        "aspect","playersESP","gunESP","trapsESP","targetESP","targetHUD","boxESP","autoShoot","silent",
        "forceShoot","autoGetGun","water","antiCoin","fadeOff","autoKnife","killAura","vote","trade",
        "magicAura","chinaHat","jumpCircle","korblox","hideSkins","noReload","friendCheck","hitParts","hitSound" }
    for _, k in ipairs(bools) do
        if data[k] ~= nil then
            F[k] = data[k]
            if Luxt1.uiRefs[k] then pcall(function() Luxt1.uiRefs[k]:Set(data[k]) end) end
        end
    end
    if data.flySpeed then F.flySpeed = data.flySpeed end
    if data.farm then for k, v in pairs(data.farm) do AF[k] = v end end
    pcall(function()
        if F.fly then Luxt1.setFly(true) end
        if F.noclip then Luxt1.setNoclip(true) end
        if F.spin then Luxt1.setSpin(true) end
        if F.jerk then Luxt1.setJerk(true) end
        if F.walkFling then Luxt1.setWalkFling(true) end
        if F.antiAim then Luxt1.antiAimStart() end
        if F.autoKnife then Luxt1.setAutoKnife(true) end
        if F.killAura then Luxt1.killAuraStart() end
        if F.vote then Luxt1.setVote(true) end
        if F.farm.enabled then Luxt1.setAutoFarm(true) end
    end)
    notify(T("Config"), T("Loaded: ")..name, 2)
end

-- ═══ BOOT ═══
local _booted = false
local function boot(lang)
    if _booted then return end
    _booted = true
    Luxt1.Language = lang or "EN"
    local uiRefs = Luxt1.uiRefs
    local ok, UI = pcall(Luxt1.CreateWindow, "Luxt1")
    if not ok or not UI then
        warn("[Luxt1] CreateWindow failed:", UI)
        return
    end
    -- GENERAL
    local t = UI:Tab(T("General"), "general")
    t:Section(T("Fly"))
    uiRefs.fly = t:Toggle(T("Fly  [WASD + Space/Ctrl]"), F.fly, function(v) Luxt1.setFly(v) end)
    t:Slider(T("Fly Speed"), 10, 200, F.flySpeed, function(v) F.flySpeed = v end, 1)
    t:Section(T("Movement"))
    t:TextInput(T("Walkspeed"), tostring(F.ws), "16", function(v)
        F.ws = tonumber(v) or 16
        local _, _, hum = getChar()
        if hum then hum.WalkSpeed = F.ws end
        notify(T("Movement"), T("Walkspeed set"), 2)
    end)
    t:TextInput(T("FOV"), tostring(F.fov), "70", function(v)
        F.fov = tonumber(v) or 70
        local cam = workspace.CurrentCamera
        if cam then tween(cam, { FieldOfView = F.fov }, 0.5) end
        notify(T("Movement"), T("FOV set"), 2)
    end)
    uiRefs.ctrlTP = t:Toggle(T("CTRL+Click TP"), F.ctrlTP, function(v) F.ctrlTP = v end)
    t:Section(T("Noclip / Blink"))
    uiRefs.noclip = t:Toggle(T("Noclip"), F.noclip, function(v) Luxt1.setNoclip(v) end)
    uiRefs.blink = t:Toggle(T("Blink (freeze)"), F.blink, function(v) Luxt1.setBlink(v) end)
    t:Section(T("Fun"))
    uiRefs.spin = t:Toggle(T("Spin"), F.spin, function(v) Luxt1.setSpin(v) end)
    t:Slider(T("Spin Speed"), 20, 720, F.spinSpeed, function(v) F.spinSpeed = v end, 5)
    uiRefs.jerk = t:Toggle(T("Jerk"), F.jerk, function(v) Luxt1.setJerk(v) end)
    uiRefs.walkFling = t:Toggle(T("WalkFling"), F.walkFling, function(v) Luxt1.setWalkFling(v) end)
    uiRefs.aspect = t:Toggle(T("AspectRatio"), F.aspect, function(v) Luxt1.setAspect(v) end)
    t:Section(T("Misc"))
    t:Button(T("FPS Boost"), function() Luxt1.fpsBoost() end)
    t:Button(T("Get Ping"), function()
        notify("Ping", math.round(LocalPlayer:GetNetworkPing()*1000).."ms", 3)
    end)
    t:Button(T("Rejoin"), function() Luxt1.rejoin() end)
    t:Button(T("Infinite Void"), function() Luxt1.infiniteVoid() end)
    uiRefs.antiFling = t:Toggle(T("AntiFling"), F.antiFling, function(v) Luxt1.setAntiFling(v) end)
    uiRefs.ghost = t:Toggle(T("Client Ghost"), F.ghost, function(v) Luxt1.setGhost(v) end)
    uiRefs.antiCoin = t:Toggle(T("AntiCoin"), F.antiCoin, function(v) Luxt1.setAntiCoin(v) end)
    t:Section(T("Teleport"))
    t:TextInput(T("Player Name"), "", T("Player..."), function(v)
        v = (v or ""):lower()
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name:lower():sub(1, #v) == v or plr.DisplayName:lower():sub(1, #v) == v then target = plr break end
        end
        if not target or not target.Character then notify(T("Teleport"), T("Player not found"), 3) return end
        local _, hrp = getChar()
        if hrp then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
            notify(T("Teleport"), T("To ")..target.Name, 3)
        end
    end)
    -- MM2
    t = UI:Tab(T("MM2"), "mm2")
    t:Section(T("Sheriff"))
    t:Button(T("Shoot Murderer"), function()
        if MM2.shootTarget() then
            Luxt1.shootMurd()
            notify(T("Shot"), T("Shot!"), 3)
        else
            notify(T("Error"), T("You are not the sheriff"), 3)
        end
    end)
    uiRefs.autoShoot = t:Toggle(T("Auto-shoot"), F.autoShoot, function(v)
        F.autoShoot = v
        notify(T("Auto-shoot"), v and T("On") or T("Off"), 2)
    end)
    uiRefs.silent = t:Toggle(T("SilentAim"), F.silent, function(v)
        F.silent = v
        notify(T("SilentAim"), v and T("On") or T("Off"), 2)
    end)
    t:Button(T("Shoot (клавиша ниже)"), function() pcall(Luxt1.silentShoot) end)
    local silentKeyBtn = t:Button(T("Bind SilentShoot key"), function()
        silentKeyBtn.Text = T("Press a key...")
        local a = UserInputService.InputBegan:Wait()
        if a.KeyCode and a.KeyCode.Name ~= "Unknown" then
            F.silentKey = a.KeyCode.Name
            silentKeyBtn.Text = T("SilentShoot: ")..F.silentKey
            notify(T("Bind"), T("Key: ")..F.silentKey, 2)
        end
    end)
    silentKeyBtn.Text = T("SilentShoot: ")..F.silentKey
    uiRefs.forceShoot = t:Toggle(T("ForceShoot (по клику)"), F.forceShoot, function(v)
        F.forceShoot = v
        notify(T("ForceShoot"), v and T("On") or T("Off"), 2)
    end)
    t:TextInput(T("Shoot Offset"), tostring(F.shootOff), "1", function(v) F.shootOff = tonumber(v) or 1 end)
    t:TextInput(T("S.Aim Offset"), tostring(F.saimOff), "2.8", function(v) F.saimOff = tonumber(v) or 2.8 end)
    t:Section(T("Murderer"))
    t:Button(T("Knife Throw to Nearest"), function()
        if not MM2.amIMurd() then notify(T("Error"), T("You are not the murderer"), 3) return end
        Luxt1.throwKnifeAt(MM2.nearest())
    end)
    uiRefs.autoKnife = t:Toggle(T("Auto Knife Throw"), F.autoKnife, function(v) Luxt1.setAutoKnife(v) end)
    uiRefs.killAura = t:Toggle(T("KillAura"), F.killAura, function(v)
        if v then Luxt1.killAuraStart() else Luxt1.killAuraStop() end
    end)
    uiRefs.antiAim = t:Toggle(T("AntiAim"), F.antiAim, function(v)
        if v then Luxt1.antiAimStart() else Luxt1.antiAimStop() end
    end)
    t:Button(T("Kill Nearest"), function()
        if not MM2.amIMurd() then notify(T("Error"), T("You are not the murderer"), 3) return end
        local target = MM2.nearest()
        if target then Luxt1.slashTouch(target) end
    end)
    t:Button(T("Kill Everyone"), function()
        if not MM2.amIMurd() then notify(T("Error"), T("You are not the murderer"), 3) return end
        Luxt1.killEveryone()
    end)
    t:Section(T("Fling"))
    t:Button(T("Fling Sheriff"), function()
        local s = MM2.getSher()
        if not s then notify(T("Error"), T("No sheriff"), 3) return end
        task.spawn(Luxt1.flingPlayer, s)
    end)
    t:Button(T("Fling Murderer"), function()
        local m = MM2.getMurd()
        if not m then notify(T("Error"), T("No murderer"), 3) return end
        task.spawn(Luxt1.flingPlayer, m)
    end)
    t:Section(T("Vote Duper"))
    uiRefs.vote = t:Toggle(T("Vote Duper"), F.vote, function(v)
        Luxt1.setVote(v)
        notify(T("Vote Duper"), v and T("On") or T("Off"), 2)
    end)
    local _votePadBtn = t:Dropdown(T("Vote Pad"), { "1", "2", "3" }, tostring(F.votePad), function(v)
        F.votePad = tonumber(v) or 2
        -- Immediate feedback so user can verify the dropdown actually changed F.votePad
        notify(T("Vote Pad"), T("Selected")..": "..tostring(F.votePad), 2)
    end)
    -- Button to list all found pads in F9 (for debugging the layout)
    t:Button(T("List Pads"), function()
        local _pads = Luxt1.listVotePads and Luxt1.listVotePads() or {}
        notify(T("Vote Pad"), T("Found")..": "..#_pads, 2)
    end)
    -- Show count of found pads as a status check after script loads
    task.spawn(function()
        task.wait(0.5)
        local _pads = voteGetPads and voteGetPads() or {}
        if #_pads > 0 then
            notify(T("Vote Pad"), T("Found")..": "..#_pads, 2)
        else
            notify(T("Vote Pad"), T("Not found"), 3)
        end
    end)
    t:Section(T("Tools"))
    uiRefs.autoGetGun = t:Toggle(T("Auto-get Dropped Gun"), F.autoGetGun, function(v) F.autoGetGun = v end)
    t:Dropdown(T("Pickup Method"), { "Remote", "FastTP" }, F.pickup, function(v) F.pickup = v end)
    uiRefs.water = t:Toggle(T("OffDamageWater"), F.water, function(v) Luxt1.setWater(v) end)
    uiRefs.fadeOff = t:Toggle(T("FadeDisabler"), F.fadeOff, function(v) Luxt1.setFadeOff(v) end)
    t:Button(T("TP to Dropped Gun"), function()
        if MM2.amIMurd() then notify(T("Error"), T("You are the murderer!"), 3) return end
        local base = nil
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name == "GunDrop" then
                base = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart", true)
                if base then break end
            end
        end
        if not base then notify(T("Error"), T("No gun"), 3) return end
        local c = LocalPlayer.Character
        if not c then return end
        if F.pickup == "Remote" then
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if hrp and firetouchinterest then
                firetouchinterest(hrp, base, 0); task.wait(0.05); firetouchinterest(hrp, base, 1)
            end
        else
            local pivot = c:GetPivot()
            c:PivotTo(base:GetPivot())
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then bp.ChildAdded:Wait() end
            c:PivotTo(pivot)
        end
        notify(T("TP"), T("Gun picked up!"), 3)
    end)
    t:Button(T("TP to Lobby"), function()
        local _, hrp = getChar()
        if hrp then hrp.CFrame = CFrame.new(14.4, 504.6, -48.3) end
    end)
    t:Button(T("TP to Random Spawn"), function()
        local map = nil
        for _, ch in ipairs(workspace:GetChildren()) do
            if ch:FindFirstChild("CoinContainer") and ch:FindFirstChild("Spawns") then map = ch break end
        end
        if not map then notify(T("Error"), T("No map!"), 3) return end
        local children = map.Spawns:GetChildren()
        if #children > 0 then
            LocalPlayer.Character:MoveTo(children[math.random(1,#children)].Position)
        end
    end)
    t:Button(T("Copy Murderer Name"), function()
        local m = MM2.getMurd()
        if not m then notify(T("Error"), T("No murderer!"), 3) return end
        if setclipboard then setclipboard(m.Name) end
        notify("Copied", m.Name, 3)
    end)
    t:Button(T("Copy Sheriff Name"), function()
        local s = MM2.getSher()
        if not s then notify(T("Error"), T("No sheriff!"), 3) return end
        if setclipboard then setclipboard(s.Name) end
        notify("Copied", s.Name, 3)
    end)
    t:Section(T("AutoFarm"))
    uiRefs.farm = t:Toggle(T("Auto Farm"), AF.enabled, function(v) Luxt1.setAutoFarm(v) end)
    t:Dropdown(T("Farm Mode"), { "Underground", "Sit" }, AF.mode, function(v) AF.mode = v end)
    t:TextInput(T("Tween Speed"), tostring(AF.tweenSpeed), "25", function(v) AF.tweenSpeed = tonumber(v) or 25 end)
    t:Toggle(T("Auto Reset"), AF.autoReset, function(v) AF.autoReset = v end)
    t:Toggle(T("Avoid Murder"), AF.avoidMurder, function(v) AF.avoidMurder = v end)
    t:TextInput(T("Coin Limit"), tostring(AF.coinLimit), "40", function(v) AF.coinLimit = tonumber(v) or 40 end)
    t:TextInput(T("Max Distance"), tostring(AF.maxDist), "600", function(v) AF.maxDist = tonumber(v) or 600 end)
    t:TextInput(T("Underground Offset"), tostring(AF.ugOffset), "4", function(v) AF.ugOffset = tonumber(v) or 4 end)
    -- TARGET
    t = UI:Tab(T("Target"), "target")
    t:Section(T("Quick Select"))
    t:Button(T("Select Murderer"), function()
        local m = MM2.getMurd()
        if not m then notify(T("Players"), T("No murderer!"), 3) return end
        Luxt1.SelectedPlayer = m
        notify(T("Players"), T("Selected: ")..m.Name, 2)
    end)
    t:Button(T("Select Sheriff"), function()
        local s = MM2.getSher()
        if not s then notify(T("Players"), T("No sheriff!"), 3) return end
        Luxt1.SelectedPlayer = s
        notify(T("Players"), T("Selected: ")..s.Name, 2)
    end)
    t:Button(T("Select Nearest"), function()
        local n = MM2.nearest()
        if not n then notify(T("Players"), T("No players!"), 3) return end
        Luxt1.SelectedPlayer = n
        notify(T("Players"), T("Selected: ")..n.Name, 2)
    end)
    t:TextInput(T("Player Name"), "", T("Search players..."), function(v)
        v = (v or ""):lower()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (plr.Name:lower():sub(1, #v) == v or plr.DisplayName:lower():sub(1, #v) == v) then
                Luxt1.SelectedPlayer = plr
                notify(T("Players"), T("Selected: ")..plr.Name, 2)
                return
            end
        end
        notify(T("Players"), T("Not found"), 2)
    end)
    t:Section(T("Info"))
    local targetInfoLbl = t:Label(T("No player selected"))
    task.spawn(function()
        while true do
            task.wait(0.15)
            local p = Luxt1.SelectedPlayer
            if not p or not p.Parent then
                targetInfoLbl.Text = T("No player selected")
            else
                MM2.refresh()
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local role = MM2.norm(p.Name) or "Unknown"
                if hrp then
                    local pos = hrp.Position
                    targetInfoLbl.Text = string.format(T("%s @%s\nDist: %.1f | Pos: %.0f, %.0f, %.0f\nRole: %s"),
                        p.DisplayName, p.Name,
                        myhrp and (myhrp.Position - pos).Magnitude or 0,
                        pos.X, pos.Y, pos.Z, role)
                else
                    targetInfoLbl.Text = string.format(T("%s | Role: %s"), p.Name, role)
                end
            end
        end
    end)
    t:Section(T("Actions"))
    t:Button(T("Teleport To"), function()
        if not Luxt1.SelectedPlayer or not Luxt1.SelectedPlayer.Character then notify(T("Players"), T("No player!"), 3) return end
        local _, hrp = getChar()
        if hrp then
            hrp.CFrame = Luxt1.SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            notify(T("Teleport"), "→ "..Luxt1.SelectedPlayer.Name, 2)
        end
    end)
    t:Button(T("Fling"), function()
        if not Luxt1.SelectedPlayer then notify(T("Players"), T("No player!"), 3) return end
        task.spawn(Luxt1.flingPlayer, Luxt1.SelectedPlayer)
    end)
    t:Button(T("Kill (as Murderer)"), function()
        if not Luxt1.SelectedPlayer then notify(T("Players"), T("No player!"), 3) return end
        if not MM2.amIMurd() then notify(T("Error"), T("You are not the murderer"), 3) return end
        Luxt1.slashTouch(Luxt1.SelectedPlayer)
    end)
    uiRefs.aimlock = t:Toggle(T("Aimlock"), F.aimlock, function(v)
        if v and not Luxt1.SelectedPlayer then
            notify(T("Aimlock"), T("Pick a target first!"), 3)
            if uiRefs.aimlock then uiRefs.aimlock:Set(false) end
            return
        end
        Luxt1.setAimlock(v)
        notify(T("Aimlock"), v and T("On") or T("Off"), 2)
    end)
    -- ESP
    t = UI:Tab(T("ESP"), "esp")
    t:Section(T("Players"))
    uiRefs.playersESP = t:Toggle(T("Players ESP"), F.playersESP, function(v) Luxt1.setPlayersESP(v) end)
    t:Toggle(T("Friend Check (зелёный)"), F.friendCheck, function(v) F.friendCheck = v end)
    t:Section(T("Box"))
    uiRefs.boxESP = t:Toggle(T("Box ESP (имя+дист)"), F.boxESP, function(v) Luxt1.setBoxESP(v) end)
    t:Section(T("Target"))
    uiRefs.targetESP = t:Toggle(T("Target ESP (уголки)"), F.targetESP, function(v) F.targetESP = v end)
    uiRefs.targetHUD = t:Toggle(T("Target HUD"), F.targetHUD, function(v) F.targetHUD = v end)
    t:Section(T("Items"))
    uiRefs.gunESP = t:Toggle(T("Gun ESP (выброшенное)"), F.gunESP, function(v) F.gunESP = v end)
    uiRefs.trapsESP = t:Toggle(T("Traps ESP"), F.trapsESP, function(v) Luxt1.setTrapsESP(v) end)
    -- VISUALS
    t = UI:Tab(T("Visuals"), "visual")
    t:Section(T("World"))
    uiRefs.rtx = t:Toggle(T("RTX"), F.rtx, function(v) if v then Luxt1.rtxOn() else Luxt1.rtxOff() end end)
    t:Dropdown(T("Time Lock"), { "Off", "Dawn", "Day", "Sunset", "Night", "Midnight", "Custom" }, F.timeLock, function(v) F.timeLock = v end)
    t:TextInput(T("Custom Time"), tostring(F.timeVal), "14", function(v) F.timeVal = tonumber(v) or 14 end)
    t:Dropdown(T("Weather"), { "Off", "Fog", "Rain", "Snow" }, F.weather, function(v) F.weather = v Luxt1.weatherApply() end)
    t:Section(T("Skybox Manager"))
    for _, sb in ipairs(SKYBOXES) do
        t:Button(sb[1], function() Luxt1.skyboxApply(sb[2], sb[1]) end)
    end
    t:Button(T("Remove Sky"), function() Luxt1.skyboxRemove() end)
    t:Section(T("Effects"))
    uiRefs.trail = t:Toggle(T("Trails"), F.trail.on, function(v) F.trail.on = v end)
    t:Dropdown(T("Trail Style"), { "Solid", "Fade", "Dotted", "Aura Trailer" }, F.trail.style, function(v) F.trail.style = v end)
    uiRefs.tracer = t:Toggle(T("Bullet Tracer"), F.tracer.on, function(v) F.tracer.on = v end)
    t:Dropdown(T("Tracer Color"), { "Default", "Custom" }, F.tracer.custom and "Custom" or "Default", function(v) F.tracer.custom = (v == "Custom") end)
    uiRefs.magicAura = t:Toggle(T("Magic Aura"), F.magicAura, function(v) F.magicAura = v end)
    t:Section(T("Gun"))
    local gunNames = { "None" }
    for k in pairs(GUN_MODELS) do table.insert(gunNames, k) end
    t:Dropdown(T("Gun Model"), gunNames, F.gunModel, function(v)
        F.gunModel = v
        Luxt1.gunApplyAll()
        notify(T("Gun Model"), v, 2)
    end)
    t:Dropdown(T("Gun Beam"), { "Default", "Neon Fat", "Nuke", "Zigzag Light", "Rainbow RGB" }, F.beamType, function(v)
        F.beamType = v
        notify(T("Beam"), v, 2)
    end)
    t:Section(T("Cosmetics"))
    uiRefs.chinaHat = t:Toggle(T("China Hat"), F.chinaHat, function(v) Luxt1.setChinaHat(v) end)
    uiRefs.jumpCircle = t:Toggle(T("Jump Circle"), F.jumpCircle, function(v) Luxt1.setJumpCircle(v) end)
    uiRefs.korblox = t:Toggle(T("Korblox (Right Leg)"), F.korblox, function(v) Luxt1.setKorblox(v) end)
    uiRefs.hideSkins = t:Toggle(T("Hide Skins (DisplayRef)"), F.hideSkins, function(v) Luxt1.setHideSkins(v) end)
    t:Section(T("Auras"))
    t:Dropdown(T("Aura Color"), { "White", "Red", "Green", "Blue", "Purple", "Pink", "Cyan", "Gold" }, "White", function(v)
        AURA_COLOR = ({
            White=Color3.fromRGB(255,255,255), Red=Color3.fromRGB(255,60,60), Green=Color3.fromRGB(60,255,100),
            Blue=Color3.fromRGB(60,140,255), Purple=Color3.fromRGB(170,90,255), Pink=Color3.fromRGB(255,105,180),
            Cyan=Color3.fromRGB(80,230,255), Gold=Color3.fromRGB(255,215,0),
        })[v] or Color3.fromRGB(255,255,255)
        if Luxt1.pendingAura then
            local a, n = Luxt1.pendingAura.assetId, Luxt1.pendingAura.name
            Luxt1.auraClear()
            Luxt1.auraApply(a, n, true)
        end
    end)
    for _, au in ipairs(AURAS) do
        t:Button(au[1], function() Luxt1.auraApply(au[2], au[1]) end)
    end
    t:Button(T("Clear Aura"), function()
        Luxt1.auraClear()
        Luxt1.pendingAura = nil
        notify(T("Auras"), T("Aura cleared!"), 2)
    end)
    -- TRADE
    t = UI:Tab(T("Trade"), "trade")
    t:Section(T("Trade Helper"))
    uiRefs.trade = t:Toggle(T("Trade Helper (Value Pills)"), F.trade, function(v) Luxt1.setTrade(v) end)
    t:Label(T("Shows item values and totals in trade."))
    t:Button(T("Refresh Values"), function()
        TH.loaded = false
        task.spawn(Luxt1.thLoadValues)
        notify(T("Trade"), T("Values updated"), 2)
    end)
    t:Section(T("Auto-Offer"))
    t:Button(T("Offer DefaultGun"), function()
        Luxt1.offerTradeItem("DefaultGun", "Weapons")
    end)
    uiRefs.tradeAutoOffer = t:Toggle(T("Auto-offer DefaultGun"), TH.autoOffer or false, function(v)
        TH.autoOffer = v
        notify(T("Trade"), v and T("On") or T("Off"), 2)
    end)
    t:Dropdown(T("Offer Item"), { "DefaultGun", "DefaultKnife", "BattleAxe", "WarAxe" }, TH.offerItem or "DefaultGun", function(v)
        TH.offerItem = v
        notify(T("Trade"), T("Offered: ")..v, 2)
    end)
    t:Dropdown(T("Offer Category"), { "Weapons", "Pets", "Godlys", "Misc" }, TH.offerCat or "Weapons", function(v)
        TH.offerCat = v
    end)
    t:TextInput(T("Offer Interval (s)"), tostring(TH.offerInterval or 1.5), "1.5", function(v)
        TH.offerInterval = tonumber(v) or 1.5
    end)
    t:Section(T("Trade Status"))
    Luxt1.thStateLbl = t:Label(T("No trade state received yet"))
    t:Button(T("Reload Values"), function()
        TH.loaded = false
        TH.loading = false
        task.spawn(Luxt1.thLoadValues)
    end)
    -- FUN
    t = UI:Tab(T("Fun"), "fun")
    -- (Meow Overlay removed — no external cat-art assets)
    -- Placeholder: empty section so dropdown push-down layout still works
    t:Section(T("Hit Effects"))
    uiRefs.hitParts = t:Toggle(T("Hit Particles"), F.hitParts, function(v) F.hitParts = v end)
    uiRefs.hitSound = t:Toggle(T("Hit Sound"), F.hitSound, function(v) F.hitSound = v end)
    t:Dropdown(T("Hit Sound Mode"), { "1", "2", "3", "4", "5", "6" }, tostring(F.hitSoundMode), function(v) F.hitSoundMode = tonumber(v) or 1 end)
    t:Label(T("LMB on player → sound + stars"))
    t:Section(T("Animations"))
    t:Dropdown(T("Animation Pack"), AnimationList, "Default", function(v)
        local a = ANIMATIONS[v]
        if a then
            Luxt1.PlayAnimationBody(a.Idle, a.Idle2, a.Idle3, a.Walk, a.Run, a.Jump, a.Climb, a.Fall, a.Swim, a.SwimIdle)
            notify(T("Animations"), v, 2)
        end
    end)
    t:Button(T("Reset Animation"), function()
        Luxt1.ResetAnimation()
        notify(T("Animations"), T("Reset."), 2)
    end)
    t:Section(T("Emotes"))
    t:Dropdown(T("Emote"), EmoteList, "--", function(v)
        Luxt1.StopEmotes()
        Luxt1.PlayEmote(v)
        notify(T("Emotes"), v, 2)
    end)
    t:Button(T("Stop Emote"), function()
        Luxt1.StopEmotes()
        notify(T("Emotes"), T("Stopped."), 2)
    end)
    -- SOUND
    t = UI:Tab(T("Sound"), "sound")
    t:Section(T("UI Sounds"))
    t:Toggle(T("UI Sounds Enabled"), SoundModule.enabled, function(v) SoundModule.enabled = v end)
    t:Dropdown(T("Enable Sound"), { "Enable 1", "Sparkle", "Laser Click", "Enable 2", "Notify" }, SoundModule.enableSound, function(v)
        SoundModule.enableSound = v
        SoundModule.play(SOUNDS[v])
    end)
    t:Dropdown(T("Disable Sound"), { "Enable 1", "Sparkle", "Laser Click", "Enable 2", "Notify" }, SoundModule.disableSound, function(v)
        SoundModule.disableSound = v
        SoundModule.play(SOUNDS[v])
    end)
    t:Button(T("Test UI Sound"), function() SoundModule.play(SOUNDS[SoundModule.enableSound]) end)
    t:Section(T("Custom Sounds"))
    t:Dropdown(T("GunKill Sound"), SOUND_NAMES, F.gunKill, function(v) F.gunKill = v end)
    t:Dropdown(T("Gunshot Sound"), SOUND_NAMES, F.gunshot, function(v) F.gunshot = v end)
    t:Dropdown(T("Knife Kill Sound"), SOUND_NAMES, F.knifeKill, function(v) F.knifeKill = v end)
    t:Toggle(T("Shutup GunReload"), F.noReload, function(v) F.noReload = v end)
    -- SETTINGS
    t = UI:Tab(T("Settings"), "main")
    t:Section(T("HUD"))
    t:Toggle(T("FPS/Ping HUD"), F.statsHud, function(v) Luxt1.statHudSet(v) end)
    t:Section(T("Screen Buttons"))
    for _, def in ipairs(Luxt1.ScreenToggles) do
        t:Button(T("Button: ")..def.name, function()
            local added = Luxt1.toggleScreenBtn(def.name)
            notify(T("Screen Btn"), def.name..(added and T(" added") or T(" removed")), 2)
        end)
    end
    t:Section(T("Language"))
    t:Button(T("English"), function()
        Luxt1.Language = "EN"
        Luxt1.reapplyLang()
        notify(T("Language"), T("Switched to English"), 2)
    end)
    t:Button(T("Russian"), function()
        Luxt1.Language = "RU"
        Luxt1.reapplyLang()
        notify(T("Language"), T("Switched to Russian"), 2)
    end)

    t:Section(T("Configs"))

    local cfgName
    t:TextInput(T("Config Name"), "default", T("name"), function(v) cfgName = v end)
    t:Button(T("Save Config"), function() Luxt1.saveConfig(cfgName or "default") end)
    t:Button(T("Load Config"), function() Luxt1.loadConfig(cfgName or "default") end)
    t:Section(T("Info"))
    t:Label(T("Luxt1 · MM2 port"))
    t:Button(T("Unload All"), function() Luxt1.unloadAll() end)
    UI:Reveal()
    Luxt1.statHudSet(F.statsHud)
end

-- ═══ Toggle key ═══
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode.Name == (Luxt1.ToggleKey or "LeftAlt") then
        if Luxt1.MainFrame then
            Luxt1.MainFrame.Visible = not Luxt1.MainFrame.Visible
        end
    end
end)

-- ═══ Boot ═══
local preOk, preErr = pcall(function()
    createPreloader(function(lang) boot(lang) end)
end)
if not preOk then
    warn("[Luxt1] preloader failed:", preErr)
    boot("EN")
end
task.delay(20, function()
    if not _booted then boot("EN") end
end)

print("[Luxt1] GUI loaded")
return Luxt1