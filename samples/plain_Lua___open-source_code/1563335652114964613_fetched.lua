---------------------------------------------------------
-- Smooth Hub : Attack on Titan Revolution - หน้าเมนู (Lobby)
-- ฟังก์ชัน: Character Selection / Auto Join Lobby / Missions
-- ระบบเซฟ: ไฟล์เดียวต่อไอดี (SmoothHub/<UserId>/AOTR.json) เซฟอัตโนมัติทุกครั้งที่ค่าเปลี่ยน
---------------------------------------------------------
local MENU_PLACE_ID = 13379208636
local MIN_DELAY, MAX_DELAY = 5, 60 -- Join Delay (วินาที) ต่ำสุด/สูงสุด

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local IN_MENU = (game.PlaceId == MENU_PLACE_ID)

-- 🔒 ตารางส่วนตัวของสคริปต์ (ไม่ผูกกับ _G จึงสคริปต์อื่นมองไม่เห็นและเรียกใช้ไม่ได้)
-- DEV = false ตอนปล่อยจริง: print/warn เงียบ, ไม่เขียนไฟล์รายงาน, ไม่เปิดคำสั่งดีบักให้ executor
-- DEV = true เฉพาะตอนพัฒนาเอง: ได้ _G.SmoothHubFarm / _G.SmoothHubSpin และข้อความดีบักกลับมา
local SH = { DEV = false }
function SH.say(...) print("[Smooth Hub]", ...) end -- ข้อความถึงผู้ใช้ (ความคืบหน้าการโหลด)
function SH.dbg(...) if SH.DEV then print(...) end end -- ข้อความภายใน เห็นเฉพาะตอน DEV
SH.say("Loading Smooth Hub | Attack on Titan Revolution (" .. (IN_MENU and "Lobby" or "In-game") .. ") ...")

-- กันรันซ้ำ: ลูปเก่าหยุด + หน้าต่างเก่าถูกล้าง
if type(_G.SmoothHubCleanup) == "function" then pcall(_G.SmoothHubCleanup) end
local token = {}
_G.SmoothHubReplayToken = token
local function Alive() return _G.SmoothHubReplayToken == token end
local AppRef = nil
_G.SmoothHubCleanup = function()
    pcall(function() if AppRef and AppRef.Destroy then AppRef:Destroy() end end)
end

---------------------------------------------------------
-- 💾 จำการตั้งค่า (แยกตามไอดี)
---------------------------------------------------------
local Cfg = {
    Slot = 1,            -- 1=A 2=B 3=C
    AutoSelect = false,  -- เลือกตัวละครให้อัตโนมัติ
    AutoJoin = false,    -- กด Join Lobby ซ้ำตามเวลา
    JoinDelay = 10,      -- วินาที (5 - 60)
    AutoClaimMain = true,         -- Auto Claim Main Quests
    AutoClaimSide = true,         -- Auto Claim Side Quests
    AutoClaimAchievements = true, -- Auto Claim Achievements
    AutoClaimWeekly = true,       -- Auto Claim Weekly Quests
    AutoClaimDaily = true,        -- Auto Claim Daily Quests
    AutoOpenPages = true,         -- เปิดหน้า Achievements เองเมื่อเกมโชว์ป้าย ! (เหมือนผู้เล่นกดเอง)
    AutoUpgradeBlade = false,      -- Equipment: Auto Upgrade Gear (Blade)
    AutoUpgradeThunder = false,    -- Equipment: Auto Upgrade Gear (Thunder Spears)
    AutoEquipThunder = false,      -- Equipment: Auto Equip Thunder Spears
    AutoEquipBlade = false,        -- Equipment: Auto Equip Blades
    UseThunderSpears = false,      -- Auto Farm: ฟาร์มด้วยหอกสายฟ้าแทนดาบ
    MissionSelect = "Shiganshina", -- Missions: แมพที่เลือก
    MissionObjective = "Skirmish", -- Missions: Objective ที่เลือก
    MissionDifficulty = {},        -- Missions: ความยากที่เลือก (เลือกได้หลายอัน)
    MissionModifiers = {},         -- Missions: Modifiers ที่เลือก (เลือกได้หลายอัน)
    AutoBestGrade = false,         -- Missions: Auto Select Best Grade
    AutoBoostMission = false,      -- Missions: Auto Select Boost Mission
    AutoCreateMission = false,     -- Missions: Auto Create Mission (เซฟข้ามรอบ: เปิดค้างไว้ = คอยสร้างห้องให้เอง)
    AutoStartMission = false,      -- Missions: Auto Start Missions (เซฟข้ามรอบ: เปิดค้างไว้ = กด Start ให้เอง)
    MissionLevel = "Easy (E- Grade)", -- Missions: ความยากที่ใช้สร้างห้อง (เลือก 1 อย่าง)
    MissionJoinDelay = 10,         -- Missions: Join Delay (วินาที 5 - 60)
    RaidSelect = "Attack Titan",   -- Raid: Raid ที่เลือก
    RaidModifiers = {},            -- Raid: Modifiers ที่เลือก (เหมือนของ Mission)
    RaidLevel = "Hard",            -- Raid: ความยาก (Hard / Severe / Aberrant) Colossal บังคับ Aberrant
    AutoCreateRaid = false,        -- Raid: Auto Create Raid (เซฟข้ามรอบ)
    AutoStartRaid = false,         -- Raid: Auto Start Raid (เซฟข้ามรอบ)
    RaidJoinDelay = 10,            -- Raid: Join Delay (วินาที 5 - 60)
    AutoSpin = false,              -- Menu Lobby: Auto Spin (กด ROLL ที่หน้า Family)
    SpinStopRarity = "Epic",       -- Menu Lobby: หยุดสปินเมื่อได้ความหายากเท่านี้หรือสูงกว่า (กันทับของดี)
    SpinShowList = false,          -- Menu Lobby: โชว์รายชื่อ Family ที่สุ่มได้ (Rolled Families) | false = ซ่อนไว้ เปิดดูเมื่ออยากดู
    SpinListSize = 15,             -- Menu Lobby: โชว์ประวัติสุ่มล่าสุดกี่รายการ (5 - 100) ประวัติเต็มเก็บไว้ 300 รายการเสมอ ใช้ปุ่ม Copy เอาทั้งหมด
    SpinUseDelay = true,           -- Menu Lobby: true = รอตามค่า Spin Delay หลังสปินทุกครั้ง | false = ไม่ใช้ดีเลย์ รอจนผลใหม่ขึ้นหน้าจอแล้วไปต่อทันที
    SpinDelay = 3,                 -- Menu Lobby: รอหลังสปินแต่ละครั้งกี่วินาที (0.5 - 10 ปรับทีละ 0.5) ให้ผลออกครบก่อนอ่านค่า
    SpinOnKeep = "Stop",           -- Menu Lobby: เจอ Family ที่อยากเก็บแล้วทำอะไร (Stop = หยุดสปิน | Store = ฝาก Storage แล้วสปินต่อ | Ask = ถามก่อน)
    SpinFamilyRules = "",          -- Menu Lobby: กฎรายตัว เช่น "YEAGER=Keep;ARLERT=Keep;REISS=Skip" (Keep = เก็บเสมอ | Skip = ไม่เก็บเลย | Ask = ถามเสมอ)
    -- Auto Farm > Main
    AutoFarm = false,              -- Auto Farm [ Blades ]
    AutoFarmThunder = false,       -- Auto Farm [ Thunder Spears ]
    AutoReload = false,            -- Auto Reload
    AutoRefillsBlade = false,      -- Auto Refills [ Blade ]: ดาบหมดและชุดสำรองเหลือ 0 -> ไปเติมที่สถานี Refill
    AutoRefillsThunder = false,    -- Auto Refills [ Thunder Spears ]
    DamageMultiplier = false,      -- Damage Multiplier (x30)
    SafeTime = 32,                 -- Safe Time (วินาที)
    FailSafeAt = 20,               -- Fail Safe At
    AutoFailSafe = false,          -- Auto Fail Safe
    Streak = 0,                    -- Current Streak: ชนะติดกันกี่ด่านตอน Auto Farm ทำงาน (ตายแล้วรีเซ็ต / Fail Safe แพ้แล้วรีเซ็ต)
    NoClip = true,                 -- No Clip: ทะลุกำแพง/ไททันตอน Auto Farm ทำงาน
    HitAllParts = true,            -- Hit All Parts: ฟันทุกชิ้นส่วนของไททัน (Eyes / แขน / ขา / Nape) ไม่ใช่แค่ Nape
    FlySpeed = 600,                -- Tween Speed: ความเร็วที่ Auto Farm บินไปหาไททัน (studs/วินาที)
    StartDelay = 4,                -- Start Delay: รอกี่วินาทีหลังเปิดสคริปต์ / ตัวละครเกิดใหม่ ก่อนที่ออโต้จะขยับตัวละคร (0 = ไม่รอ) กันกล้องบัคบนมือถือ
    PartCooldown = 7,              -- Part Cooldown: แต่ละชิ้นส่วน (Eyes/แขน/ขา) ยิงซ้ำได้ทุกกี่วินาที (ต่ำสุด 4 กันยิงถี่จนเซิร์ฟเวอร์ค้าง)
    FlyHeight = 300,               -- Fly Height: ลอยสูงเหนือยอดหัวไททันกี่ studs (150 - 2000)
    AttackSpeed = 0,               -- Attack Speed: 0 = Auto, 1 = Safe, 2 = Fast, 3 = Turbo, 4 = Max
    -- Auto Farm > Game Options
    AutoOpenChestFree = false,     -- Raid: Auto Open Chest (Free) กดปุ่ม OPEN ของกล่องฟรีหลังจบ Raid
    AutoCannon = false,            -- Raid: Auto Cannon (Colossal Titan) ขึ้นปืนใหญ่บนกำแพงแล้วยิงไททัน 60 เมตร
    CannonFarmSmall = false,       -- Raid (Colossal): เฟส 1 ให้ Auto Farm ฟันไททันตัวเล็กระหว่างยิงปืนด้วย (ปิด = Auto Farm รอจนเข้าเฟส 2)
    AutoDefendEren = false,        -- Raid (Colossal): เฟส 1 ตอนปืนใหญ่ยิง ให้ Auto Farm ไปฆ่าไททันที่เข้าใกล้ Eren เพื่อป้องกัน Eren (ต้องเปิด Auto Farm)
    DefendErenRadius = 400,        -- Raid (Colossal): ไททันที่อยู่ใกล้ Eren ไม่เกินกี่ studs ถือว่าเป็นภัย (50 - 2000)
    AutoFinishChest = false,       -- Raid: Auto Finish (กดปุ่ม FINISH หลังเปิดกล่องครบ)
    AutoOpenChestPremium = false,  -- Raid: Auto Open Chest (Premium)
    AutoSkipCutscene = false,      -- Auto Skip Cutscene: กดปุ่ม SKIP [E] ของคัทซีนในด่าน/Raid ให้เอง (รอตัวละครโหลดเสร็จก่อน)
    AutoRetry = false,             -- Auto Retry
    AutoLeave = false,             -- Auto Leave
    RetryAmount = 3,               -- Retry Amount
    RetryDone = 0,                 -- จำนวนครั้งที่ Retry ไปแล้วในรอบนี้ (Current Retry) รีเซ็ตเมื่ออยู่ที่ล็อบบี้/ปิดสวิตช์
    AutoLeaveWhenRetryComplete = false, -- Auto Leave When Retry Complete
    -- Lobby > Skill Trees (Left > Regen VI ใช้งานได้แล้ว | สายอื่นรอ Remote จาก Cobalt)
    AutoUpgradeSkills = false,     -- Skill Trees: Auto Upgrade Skills (สวิตช์หลัก)
    SkillLeft = false,             -- Skill Trees: เปิดอัปสายซ้าย
    SkillMiddle = false,           -- Skill Trees: เปิดอัปสายกลาง
    SkillRight = false,            -- Skill Trees: เปิดอัปสายขวา
    SkillLeftPick = "Regen VI",    -- Skill Trees: ปลายทางสายซ้าย (Regen VI / Injury III)
    SkillMiddlePick = "Damage V",  -- Skill Trees: ปลายทางสายกลาง (Damage V / Crit Damage V)
    SkillRightPick = "Tank VIII",  -- Skill Trees: ปลายทางสายขวา (Tank VIII / Health XI)
    SkillLeftPriority = 1,         -- Skill Trees: ลำดับอัปสายซ้าย (1 - 3 เลขน้อยอัปก่อน)
    SkillMiddlePriority = 2,       -- Skill Trees: ลำดับอัปสายกลาง
    SkillRightPriority = 1,        -- Skill Trees: ลำดับอัปสายขวา
    -- Lobby > Perks (หน้าจอทำไว้ก่อน ฟังก์ชันยังไม่ทำงาน รอ Remote จาก Cobalt)
    AutoCraftPerks = false,        -- Perks: Auto Craft Perks (สวิตช์หลัก)
    CraftCommonRare = false,       -- Perks: คราฟ Common -> Rare
    CraftRareEpic = false,         -- Perks: คราฟ Rare -> Epic
    CraftEpicLegendary = false,    -- Perks: คราฟ Epic -> Legendary
    CraftLegendaryMythic = false,  -- Perks: คราฟ Legendary -> Mythic
    CraftChanceCommonRare = 100,   -- Perks: Chance ของ Common -> Rare (0 - 100)
    CraftChanceRareEpic = 100,
    CraftChanceEpicLegendary = 100,
    CraftChanceLegendaryMythic = 100,
    -- Lobby > Progression (หน้าจอทำไว้ก่อน ฟังก์ชันยังไม่ทำงาน รอ Remote จาก Cobalt)
    AutoPrestige = false,          -- Prestige: Auto Prestige
    PrestigeBoost1 = "Luck",       -- Prestige: Boost ที่เลือกตอน Prestige ครั้งที่ 1 (Luck / Gold / EXP)
    PrestigeBoost2 = "Luck",
    PrestigeBoost3 = "Luck",
    PrestigeBoost4 = "Luck",
    PrestigeBoost5 = "Luck",
    PrestigeStopAt = 3,            -- Prestige: หยุดที่ Prestige ครั้งที่เท่าไหร่
    -- Memories Priority: สร้างคีย์ Mem_<ชื่อ> ให้ทุกใบจากตาราง SH.Memories ด้านล่าง
}
-- ช่วงค่าของสไลเดอร์ในหมวด Auto Farm { ต่ำสุด, สูงสุด } (ปรับช่วงตรงนี้ที่เดียว)
local FARM_RANGES = {
    SafeTime = { 0, 300 },
    FailSafeAt = { 0, 100 },
    FlySpeed = { 100, 2000 },
    StartDelay = { 0, 60 },
    PartCooldown = { 4, 10 }, -- ต่ำสุด 4 วินาที (ต่ำกว่านี้ยิงทุกส่วนถี่เกินจนเซิร์ฟเวอร์ค้าง)
    FlyHeight = { 300, 2000 },
    AttackSpeed = { 0, 5 },
    RetryAmount = { 1, 50 },
    SpinListSize = { 5, 100 },
    DefendErenRadius = { 50, 2000 },
    SkillLeftPriority = { 1, 3 },
    SkillMiddlePriority = { 1, 3 },
    SkillRightPriority = { 1, 3 },
    CraftChanceCommonRare = { 0, 100 },
    CraftChanceRareEpic = { 0, 100 },
    CraftChanceEpicLegendary = { 0, 100 },
    CraftChanceLegendaryMythic = { 0, 100 },
    PrestigeStopAt = { 1, 5 },
    -- SpinDelay ไม่อยู่ในตารางนี้ เพราะตารางนี้ปัดเป็นจำนวนเต็ม (SpinDelay ปรับทีละ 0.5 จัดการแยกด้านล่าง)
}

-- 🧠 รายชื่อ Memories (การ์ด) ที่โชว์ในหน้า Progression > Memories Priority
-- เพิ่มการ์ดใหม่ = เพิ่มบรรทัดเดียวที่นี่ ระบบเซฟ/โหลด/รีเซ็ตทำให้เอง (คีย์ Mem_<Id>)
-- ข้อมูลทั้งหมดดึงมาจากโมดูล ReplicatedStorage.Modules.Storage.Memories ของเกม (33 ใบ)
-- Stars = ระดับดาว | Desc = คำอธิบายจากเกม | Priority 0 - 10 (ค่าเริ่มต้น 5)
SH.Memories = {
    { Id = "Thanatophobia", Name = "[Defense] Thanatophobia", Stars = 4, Desc = "When below 40.0% HEALTH: +25.0% DMG RED., +15.0% INJURY CHANCE RED. and heal an injury every 15s" },
    { Id = "Necromantic", Name = "[Defense] Necromantic", Stars = 4, Desc = "Upon ignoring death, gain +20.0% DMG, +25.0% HEALTH and +15.0% SPEED" },
    { Id = "SteelFrame", Name = "[Defense] Steel Frame", Stars = 3, Desc = "All explosions deal 25.0% less self DMG and grant immunity to any explosions for 5s" },
    { Id = "Resilience", Name = "[Defense] Resilience", Stars = 3, Desc = "Ignore up to 1 killing blows per match" },
    { Id = "Vengeflare", Name = "[Defense] Vengeflare", Stars = 3, Desc = "Reflect 50.0% of any incoming damage for the next 20s when Tough As Nails is active" },
    { Id = "Aegisurge", Name = "[Defense] Aegisurge", Stars = 2, Desc = "Gain a temporary shield that has 15.0% of your MAX HEALTH for 20s after a titan kill" },
    { Id = "Riposte", Name = "[Defense] Riposte", Stars = 2, Desc = "Successful counters instantly execute a titan" },
    { Id = "Guardian", Name = "[Defense] Guardian", Stars = 1, Desc = "Ignore up to 2 injuries per match" },
    { Id = "Deflectra", Name = "[Defense] Deflectra", Stars = 1, Desc = "5.0% chance to completely block incoming damage" },
    { Id = "Afterimages", Name = "[Offense] Afterimages", Stars = 4, Desc = "Explosions create a smaller explosion in their wake, doing 40.0% DMG (4s CD)" },
    { Id = "Overslash", Name = "[Offense] Overslash", Stars = 4, Desc = "30.0% of any excess DMG from a finishing blow applies to other titans in a 125m radius (4s CD)" },
    { Id = "Gambler", Name = "[Offense] Gambler", Stars = 4, Desc = "All DMG dealt fluctuates between 75.0% - 130.0% (Perfect Form makes this 85.0% - 140.0%)" },
    { Id = "Supernova", Name = "[Offense] Supernova", Stars = 3, Desc = "Increase TS DMG by 25.0%, but for every 100m away from your explosion, lose 2.5% TS DMG" },
    { Id = "Amputation", Name = "[Offense] Amputation", Stars = 3, Desc = "Critical hits dealt to non-boss type titans' limbs disables limb regeneration" },
    { Id = "Assassin", Name = "[Offense] Assassin", Stars = 3, Desc = "Blade skills deal 25.0% more DMG and have +15.0% SKILL CD REDUCTION" },
    { Id = "Quakestrike", Name = "[Offense] Quakestrike", Stars = 3, Desc = "Each kill increases DMG by 1.5%, resets after reloading" },
    { Id = "Furyforge", Name = "[Offense] Furyforge", Stars = 3, Desc = "Increase DMG by 0.4% for every 1.0% of HEALTH lost" },
    { Id = "Stormcharged", Name = "[Offense] Stormcharged", Stars = 2, Desc = "DMG increases by 3.0% for each shifter currently active in a match" },
    { Id = "Stalwart", Name = "[Offense] Stalwart", Stars = 2, Desc = "BLADE DURABILITY increases by 3.0% for every broken segment" },
    { Id = "Surgeshot", Name = "[Offense] Surgeshot", Stars = 1, Desc = "Holding your Spears M1 for longer increases the BLAST RADIUS" },
    { Id = "Swiftshot", Name = "[Offense] Swiftshot", Stars = 1, Desc = "Refilling your gas and blades is 25.0% faster" },
    { Id = "Crescendo", Name = "[Offense] Crescendo", Stars = 1, Desc = "Deal an additional 20.0% DMG to titans that are stunned" },
    { Id = "Blitzblade", Name = "[Offense] Blitzblade", Stars = 1, Desc = "Holding your Blades M1 for longer increases the total DMG" },
    { Id = "Bloodthief", Name = "[Support] Bloodthief", Stars = 4, Desc = "Being hooked onto an enemy titan recovers 3.0% HEALTH every 2s" },
    { Id = "Apotheosis", Name = "[Support] Apotheosis", Stars = 4, Desc = "Awakening Bar fills 15.0% faster, can shift at 60.0% bar and +1.25% DMG for every 10.0% of Bar filled" },
    { Id = "Tactician", Name = "[Support] Tactician", Stars = 3, Desc = "All support skill effects are multiplied by 1.15x" },
    { Id = "Omnirange", Name = "[Support] Omnirange", Stars = 3, Desc = "Any ranged skills now affect all players, regardless of range" },
    { Id = "Flashstep", Name = "[Support] Flashstep", Stars = 3, Desc = "Dashes/Flips now have I-Frames" },
    { Id = "GemFiend", Name = "[Support] Gem Fiend", Stars = 2, Desc = "Obtain +10.0% more Gems from AFK Zone/Mission Streak" },
    { Id = "Vitalize", Name = "[Support] Vitalize", Stars = 2, Desc = "Saving a teammate heals both of you for 10.0% HEALTH, each dealing 25.0% more DMG next hit" },
    { Id = "Lifefeed", Name = "[Support] Lifefeed", Stars = 2, Desc = "Gain 2.0% of your HEALTH back per titan kill" },
    { Id = "CooldownBlitz", Name = "[Support] Cooldown Blitz", Stars = 1, Desc = "SKILL COOLDOWN REDUCTION increases by 10.0%" },
    { Id = "Mendmaster", Name = "[Support] Mendmaster", Stars = 1, Desc = "Gain 1 extra bandage after refilling your gas and blades" },
}
for _, m in ipairs(SH.Memories) do
    m.Key = "Mem_" .. m.Id
    Cfg[m.Key] = 5
    FARM_RANGES[m.Key] = { 0, 10 }
end

---------------------------------------------------------
-- 🔄 ตัวช่วย Reset / รีเฟรชหน้าจอ (รวมไว้ในตารางเดียว กันตัวแปรท้องถิ่นเกิน 200)
-- Defaults  = ค่าเริ่มต้นของสคริปต์ (เก็บไว้ก่อนโหลดไฟล์เซฟ)
-- Refreshers = ฟังก์ชันที่ทำให้สวิตช์/สไลเดอร์บนหน้าจอตรงกับค่าใน Cfg / HubConfig
---------------------------------------------------------
local UiSync = { Defaults = { Cfg = {}, Hub = {} }, Refreshers = {} }
for key, value in pairs(Cfg) do
    if type(value) == "table" then
        local copy = {}
        for i, item in ipairs(value) do copy[i] = item end
        UiSync.Defaults.Cfg[key] = copy
    else
        UiSync.Defaults.Cfg[key] = value
    end
end

function UiSync.Add(fn)
    UiSync.Refreshers[#UiSync.Refreshers + 1] = fn
end

-- ผูกตัวควบคุมกับค่า tbl[key] แล้วคืนตัวควบคุมเดิมกลับ (ครอบตอนสร้างได้เลย)
function UiSync.Link(control, tbl, key, extra)
    UiSync.Add(function()
        local want = tbl[key]
        if control.Value ~= want then control.Value = want end
        if extra then extra(control, want) end
    end)
    return control
end

function UiSync.Refresh()
    for _, fn in ipairs(UiSync.Refreshers) do pcall(fn) end
end

local SAVE_DIR = "SmoothHub"
local LEGACY_PATH = SAVE_DIR .. "/AOTR_Menu_" .. tostring(LocalPlayer.UserId) .. ".json" -- ไฟล์เก่าของเวอร์ชันก่อน (ใช้ย้ายค่าให้ครั้งเดียว)
local canSave = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"

local function ClampDelay(v)
    v = tonumber(v) or 10
    return math.clamp(math.floor(v + 0.5), MIN_DELAY, MAX_DELAY)
end

-- ใส่ค่าที่อ่านจากไฟล์ลง Cfg (เช็กชนิดทุกค่า กันไฟล์เพี้ยนทำสคริปต์พัง)
local function ApplyCfgData(data)
    if type(data) ~= "table" then return end
    if type(data.Slot) == "number" and data.Slot >= 1 and data.Slot <= 3 then Cfg.Slot = math.floor(data.Slot) end
    if data.JoinDelay ~= nil then Cfg.JoinDelay = ClampDelay(data.JoinDelay) end
    if data.MissionJoinDelay ~= nil then Cfg.MissionJoinDelay = ClampDelay(data.MissionJoinDelay) end
    if data.RaidJoinDelay ~= nil then Cfg.RaidJoinDelay = ClampDelay(data.RaidJoinDelay) end
    for _, key in ipairs({
        "AutoSelect", "AutoJoin", "AutoSpin", "SpinUseDelay", "SpinShowList",
        "AutoClaimMain", "AutoClaimSide", "AutoClaimAchievements", "AutoClaimWeekly", "AutoClaimDaily", "AutoOpenPages",
        "AutoUpgradeBlade", "AutoUpgradeThunder", "AutoEquipThunder", "AutoEquipBlade",
        "AutoBestGrade", "AutoBoostMission", "AutoCreateMission", "AutoStartMission", "AutoCreateRaid", "AutoStartRaid",
        "AutoFarm", "AutoFarmThunder", "AutoReload", "AutoRefillsBlade", "AutoRefillsThunder", "DamageMultiplier", "AutoFailSafe", "NoClip", "HitAllParts",
        "AutoRetry", "AutoLeave", "AutoLeaveWhenRetryComplete", "AutoSkipCutscene", "AutoOpenChestFree", "AutoOpenChestPremium", "AutoFinishChest", "AutoCannon", "CannonFarmSmall", "AutoDefendEren", "UseThunderSpears",
        "AutoUpgradeSkills", "SkillLeft", "SkillMiddle", "SkillRight",
        "AutoCraftPerks", "CraftCommonRare", "CraftRareEpic", "CraftEpicLegendary", "CraftLegendaryMythic", "AutoPrestige",
    }) do
        if type(data[key]) == "boolean" then Cfg[key] = data[key] end
    end
    if type(data.RetryDone) == "number" and data.RetryDone == data.RetryDone and data.RetryDone >= 0 then
        Cfg.RetryDone = math.floor(data.RetryDone)
    end
    if type(data.Streak) == "number" and data.Streak == data.Streak and data.Streak >= 0 then
        Cfg.Streak = math.floor(data.Streak)
    end
    for key, range in pairs(FARM_RANGES) do
        if type(data[key]) == "number" and data[key] == data[key] then
            Cfg[key] = math.clamp(math.floor(data[key] + 0.5), range[1], range[2])
        end
    end
    if type(data.SpinDelay) == "number" and data.SpinDelay == data.SpinDelay then
        Cfg.SpinDelay = math.clamp(math.floor(data.SpinDelay * 2 + 0.5) / 2, 0.5, 10) -- ปัดทีละ 0.5
    end
    -- ไฟล์เก่าเคยจำสวิตช์ Mission ไว้ในชื่อ RememberAuto... (ย้ายค่ามาให้)
    if data.AutoCreateMission == nil and type(data.RememberAutoCreate) == "boolean" then Cfg.AutoCreateMission = data.RememberAutoCreate end
    if data.AutoStartMission == nil and type(data.RememberAutoStart) == "boolean" then Cfg.AutoStartMission = data.RememberAutoStart end
    for _, key in ipairs({ "MissionSelect", "MissionObjective", "MissionLevel", "RaidSelect", "RaidLevel", "SpinStopRarity", "SpinOnKeep", "SpinFamilyRules", "SkillLeftPick", "SkillMiddlePick", "SkillRightPick", "PrestigeBoost1", "PrestigeBoost2", "PrestigeBoost3", "PrestigeBoost4", "PrestigeBoost5" }) do
        if type(data[key]) == "string" then Cfg[key] = data[key] end
    end
    for _, key in ipairs({ "MissionDifficulty", "MissionModifiers", "RaidModifiers" }) do
        if type(data[key]) == "table" then
            local names = {}
            for _, v in ipairs(data[key]) do
                if type(v) == "string" then names[#names + 1] = v end
            end
            Cfg[key] = names
        end
    end
end

local function ReadLegacyCfg()
    if not canSave then return nil end
    local ok, data = pcall(function()
        if not isfile(LEGACY_PATH) then return nil end
        return HttpService:JSONDecode(readfile(LEGACY_PATH))
    end)
    if ok and type(data) == "table" then return data end
    return nil
end

-- Save() = "ค่าเปลี่ยนแล้ว ช่วยเซฟที" (รวมคำสั่งรัว ๆ เป็นครั้งเดียว)
-- ตัวเขียนไฟล์จริงคือระบบ Auto Save ตัวเดียว (ไฟล์ AOTR.json) ที่ผูกไว้ท้ายสคริปต์ผ่าน saveHook
local saveHook = nil
local saveQueued = false
local function Save()
    if saveQueued then return end
    saveQueued = true
    task.delay(0.4, function()
        saveQueued = false
        if saveHook then pcall(saveHook) end
    end)
end

---------------------------------------------------------
-- 📁 Config: ชุดตั้งค่าตั้งชื่อเองได้ (แยกตามไอดี)
-- config ที่กำลังใช้อยู่ (Active) จะเซฟทุกการเปลี่ยนแปลงลงตัวเองอัตโนมัติ จึงไม่ต้องมีปุ่ม Overwrite
-- Autoload = config ที่จะโหลดให้ทุกครั้งตอนรันสคริปต์
---------------------------------------------------------
---------------------------------------------------------
-- ⭐ Config ค่าเริ่มต้นที่ติดมากับสคริปต์
-- ชื่อนี้ลบ/แก้ไม่ได้ และถูกสร้างใหม่จากค่าเริ่มต้นของสคริปต์ทุกครั้งที่รัน
-- DEFAULT_LOOK = หน้าตาเริ่มต้น (ธีม Dark + Accent Pink) ส่วนสวิตช์ต่าง ๆ ใช้ค่าเริ่มต้นในตาราง Cfg / HubConfig
---------------------------------------------------------
-- (เก็บไว้ในตาราง ConfigStore เพื่อไม่ให้ตัวแปรท้องถิ่นระดับบนสุดเพิ่ม กันเกิน 200)
local ConfigStore = {
    DEFAULT_NAME = "Smooth Hub | Default",
    DEFAULT_LOOK = { Theme = "Dark", Accent = "Pink", UIBlur = false, Dropshadow = true, Keybind = "B" },
}
do
    local DEFAULT_CONFIG_NAME = ConfigStore.DEFAULT_NAME
    local DEFAULT_LOOK = ConfigStore.DEFAULT_LOOK
    local PATH = SAVE_DIR .. "/AOTR_Configs_" .. tostring(LocalPlayer.UserId) .. ".json"
    local data = { Autoload = nil, Active = nil, AutoSync = true, List = {} }
    local sigs = {} -- ลายเซ็นข้อมูลที่เขียนล่าสุดของแต่ละ config (กันเขียนไฟล์ซ้ำโดยไม่จำเป็น)
    local defaultSnap = nil -- config ค่าเริ่มต้น (สร้างจากโค้ด ไม่อ่านจากไฟล์)

    local function Flush()
        if not canSave then return false end
        return (pcall(function()
            if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder(SAVE_DIR) then
                makefolder(SAVE_DIR)
            end
            writefile(PATH, HttpService:JSONEncode(data))
        end))
    end

    local function CopyValue(v)
        if type(v) == "table" then
            local out = {}
            for _, item in ipairs(v) do
                if type(item) == "string" then out[#out + 1] = item end
            end
            return out
        end
        return v
    end

    function ConfigStore.Reload()
        data = { Autoload = nil, Active = nil, AutoSync = true, List = {} }
        sigs = {}
        if defaultSnap then data.List[DEFAULT_CONFIG_NAME] = defaultSnap end
        if not canSave then return end
        local ok, decoded = pcall(function()
            if not isfile(PATH) then return nil end
            return HttpService:JSONDecode(readfile(PATH))
        end)
        if ok and type(decoded) == "table" then
            if type(decoded.List) == "table" then
                for name, snap in pairs(decoded.List) do
                    if type(name) == "string" and type(snap) == "table" and name ~= DEFAULT_CONFIG_NAME then data.List[name] = snap end
                end
            end
            if type(decoded.Autoload) == "string" and data.List[decoded.Autoload] then data.Autoload = decoded.Autoload end
            if type(decoded.Active) == "string" and data.List[decoded.Active] then data.Active = decoded.Active end
            if decoded.AutoSync == false then data.AutoSync = false end
        end
    end

    function ConfigStore.Names()
        local names = {}
        for name in pairs(data.List) do names[#names + 1] = name end
        table.sort(names, function(a, b)
            if a == DEFAULT_CONFIG_NAME then return b ~= DEFAULT_CONFIG_NAME end -- ค่าเริ่มต้นอยู่บนสุดเสมอ
            if b == DEFAULT_CONFIG_NAME then return false end
            return a:lower() < b:lower()
        end)
        return names
    end
    function ConfigStore.IsDefault(name) return name == DEFAULT_CONFIG_NAME end
    function ConfigStore.Exists(name) return data.List[name] ~= nil end
    function ConfigStore.Get(name) return data.List[name] end
    function ConfigStore.Autoload() return data.Autoload end
    function ConfigStore.Active() return data.Active end
    function ConfigStore.AutoloadSnapshot() return data.Autoload and data.List[data.Autoload] or nil end

    -- เก็บสวิตช์/ตัวเลือกทั้งหมด (Cfg) + ค่าตั้งของหมวด Settings ที่เป็นตัวเลข/ข้อความ/สวิตช์ (hub)
    function ConfigStore.Snapshot(hub)
        local snap = { Cfg = {}, Hub = {} }
        for k, v in pairs(Cfg) do snap.Cfg[k] = CopyValue(v) end
        if hub then
            for k, v in pairs(hub) do
                local t = type(v)
                if t == "boolean" or t == "number" or t == "string" then snap.Hub[k] = v end
            end
        end
        -- หน้าตา (ธีม / Accent / เบลอ / เงา / ปุ่มลัด) ถ้ามีตัวอ่านค่า
        if ConfigStore.GetUI then
            local okUi, ui = pcall(ConfigStore.GetUI)
            if okUi and type(ui) == "table" then snap.UI = ui end
        end
        return snap
    end

    function ConfigStore.Put(name, snap)
        if name == DEFAULT_CONFIG_NAME then return false end -- ชื่อค่าเริ่มต้นเขียนทับไม่ได้
        data.List[name] = snap
        sigs[name] = nil
        return Flush()
    end
    function ConfigStore.Delete(name)
        if name == DEFAULT_CONFIG_NAME then return false end -- config ค่าเริ่มต้นลบไม่ได้
        data.List[name] = nil
        sigs[name] = nil
        if data.Autoload == name then data.Autoload = nil end
        if data.Active == name then data.Active = nil end
        return Flush()
    end
    function ConfigStore.SetAutoload(name)
        if name ~= nil and not data.List[name] then return false end
        data.Autoload = name
        return Flush()
    end
    function ConfigStore.SetActive(name)
        if name ~= nil and not data.List[name] then return false end
        if data.Active == name then return true end
        data.Active = name
        return Flush()
    end

    -- เซฟสถานะปัจจุบันลง config ที่กำลังใช้อยู่ (ถ้าไม่มี config ที่ใช้อยู่ = ไม่ทำอะไร)
    function ConfigStore.SyncActive(hub)
        if data.AutoSync == false then return false end -- โหมดเซฟเอง: ไม่เซฟให้อัตโนมัติ (ต้องกดปุ่ม Enter Save Config)
        local name = data.Active
        if not name or not data.List[name] then return false end
        if name == DEFAULT_CONFIG_NAME then return false end -- config ค่าเริ่มต้นเป็นแบบอ่านอย่างเดียว
        local snap = ConfigStore.Snapshot(hub)
        local okSig, sig = pcall(function() return HttpService:JSONEncode(snap) end)
        if not okSig or sigs[name] == sig then return false end
        data.List[name] = snap
        if Flush() then sigs[name] = sig return true end
        return false
    end

    -- โหมดเซฟ: true = config ที่ใช้อยู่เซฟทุกการเปลี่ยนแปลงเอง / false = เซฟเฉพาะตอนกดปุ่ม Enter Save Config
    function ConfigStore.AutoSync() return data.AutoSync ~= false end
    function ConfigStore.SetAutoSync(value)
        data.AutoSync = value and true or false
        return Flush()
    end

    -- เซฟสถานะปัจจุบันลง config ที่ใช้อยู่ "ทันที" (ปุ่ม Enter Save Config) คืน ok, ชื่อ config
    function ConfigStore.SaveActive(hub)
        local name = data.Active
        if not name or not data.List[name] then return false, nil end
        if name == DEFAULT_CONFIG_NAME then return false, name end -- config ค่าเริ่มต้นเป็นแบบอ่านอย่างเดียว
        local snap = ConfigStore.Snapshot(hub)
        data.List[name] = snap
        sigs[name] = nil
        local ok = Flush()
        if ok then
            local okSig, sig = pcall(function() return HttpService:JSONEncode(snap) end)
            if okSig then sigs[name] = sig end
        end
        return ok, name
    end

    -- เทียบเฉพาะคีย์ที่ config เก็บไว้แล้ว (คีย์ใหม่จากสคริปต์เวอร์ชันหลังไม่นับว่า "ยังไม่เซฟ")
    local function SameValue(x, y)
        if type(x) ~= type(y) then return false end
        if type(x) == "table" then
            if #x ~= #y then return false end
            for i = 1, #x do
                if x[i] ~= y[i] then return false end
            end
            return true
        end
        return x == y
    end
    local function SameMap(current, saved)
        if type(saved) ~= "table" then return true end
        for k, v in pairs(current) do
            if saved[k] ~= nil and not SameValue(v, saved[k]) then return false end
        end
        return true
    end

    -- ค่าตอนนี้ต่างจากที่เซฟไว้ใน config ที่ใช้อยู่ไหม (มีแก้แล้วยังไม่ได้เซฟ)
    function ConfigStore.IsDirty(hub)
        local name = data.Active
        local saved = name and data.List[name]
        if not saved then return false end
        local snap = ConfigStore.Snapshot(hub)
        return not (SameMap(snap.Cfg, saved.Cfg) and SameMap(snap.Hub, saved.Hub) and SameMap(snap.UI or {}, saved.UI))
    end

    function ConfigStore.ApplyCfg(snap)
        if type(snap) ~= "table" or type(snap.Cfg) ~= "table" then return end
        local saved = snap.Cfg
        for k, v in pairs(saved) do
            local cur = Cfg[k]
            if cur ~= nil and type(cur) == type(v) then
                if type(v) == "table" then
                    Cfg[k] = CopyValue(v)
                elseif k == "JoinDelay" or k == "MissionJoinDelay" or k == "RaidJoinDelay" then
                    Cfg[k] = ClampDelay(v)
                elseif k == "Slot" then
                    Cfg[k] = math.clamp(math.floor(v), 1, 3)
                elseif k == "SpinDelay" and v == v then
                    Cfg[k] = math.clamp(math.floor(v * 2 + 0.5) / 2, 0.5, 10)
                elseif FARM_RANGES[k] and v == v then
                    Cfg[k] = math.clamp(math.floor(v + 0.5), FARM_RANGES[k][1], FARM_RANGES[k][2])
                else
                    Cfg[k] = v
                end
            end
        end
        -- config เก่าจากเวอร์ชันก่อนจำสวิตช์ Mission ไว้ในชื่อ RememberAuto...
        if saved.AutoCreateMission == nil and type(saved.RememberAutoCreate) == "boolean" then Cfg.AutoCreateMission = saved.RememberAutoCreate end
        if saved.AutoStartMission == nil and type(saved.RememberAutoStart) == "boolean" then Cfg.AutoStartMission = saved.RememberAutoStart end
    end
    function ConfigStore.ApplyHub(hub, snap)
        if type(snap) ~= "table" or type(snap.Hub) ~= "table" then return end
        for k, v in pairs(snap.Hub) do
            if hub[k] ~= nil and type(hub[k]) == type(v) then hub[k] = v end
        end
    end

    function ConfigStore.ApplyUI(snap)
        if type(snap) ~= "table" or type(snap.UI) ~= "table" then return end
        if ConfigStore.UIApplier then pcall(ConfigStore.UIApplier, snap.UI) end
    end

    -- สร้าง config ค่าเริ่มต้นจากค่าเริ่มต้นของสคริปต์ (สวิตช์ Cfg + ค่า Hub + หน้าตา)
    -- เรียกครั้งแรกตอนเริ่ม (ยังไม่มี Hub) แล้วเรียกอีกครั้งหลังรู้ค่าเริ่มต้นของ Hub
    function ConfigStore.BuildDefault(hubDefaults)
        local snap = { Cfg = {}, Hub = {}, UI = {} }
        for k, v in pairs(UiSync.Defaults.Cfg) do snap.Cfg[k] = CopyValue(v) end
        if hubDefaults then
            for k, v in pairs(hubDefaults) do
                local t = type(v)
                if t == "boolean" or t == "number" or t == "string" then snap.Hub[k] = v end
            end
        end
        for k, v in pairs(DEFAULT_LOOK) do snap.UI[k] = v end
        defaultSnap = snap
        data.List[DEFAULT_CONFIG_NAME] = snap
        sigs[DEFAULT_CONFIG_NAME] = nil
    end

    ConfigStore.BuildDefault()
    ConfigStore.Reload()
end

---------------------------------------------------------
-- โหลด UI
---------------------------------------------------------
SH.say("Loading interface...")
local okLib, Cascade = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/smoothhubv1-prog/Cascade-UI-Library/refs/heads/main/Ui.luau"))()
end)
if not okLib or type(Cascade) ~= "table" then
    SH.say("Could not load the interface. Check your internet connection.")
    SH.dbg("[SmoothHub] โหลด UI ไม่สำเร็จ:", tostring(Cascade))
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Smooth Hub", Text = "โหลด UI ไม่สำเร็จ (เช็คเน็ต/ลิงก์ GitHub)", Duration = 8,
        })
    end)
    return
end

SH.say("Interface ready.")

local function Icon(...)
    for _, name in ipairs({ ... }) do
        if Cascade.Symbols[name] then return Cascade.Symbols[name] end
    end
    return Cascade.Symbols["boltFill"]
end

-- ผูกปุ่ม (กันกดซ้ำ 2 ครั้ง)
local function BindButton(btn, fn)
    local last = 0
    local function run()
        if os.clock() - last < 0.5 then return end
        last = os.clock()
        task.spawn(fn)
    end
    pcall(function()
        if btn.__instance then
            local obj = btn.__instance:FindFirstChildWhichIsA("TextButton", true) or btn.__instance
            obj.MouseButton1Click:Connect(run)
        end
    end)
    return run
end

---------------------------------------------------------
-- 💾 ระบบจำการตั้งค่าหมวด Settings (แยกตามไอดี)
-- เก็บไว้ที่ workspace/SmoothHub/<UserId>/AOTR.json
---------------------------------------------------------
local SettingsStore = {}
do
    local HttpService = game:GetService("HttpService")
    local owner = game:GetService("Players").LocalPlayer
    local ROOT = "SmoothHub"
    local DIR = ROOT .. "/" .. tostring(owner.UserId)

    local canSave = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
    local canFolder = type(makefolder) == "function" and type(isfolder) == "function"
    local flushers = {}

    function SettingsStore.Path(fileName)
        if canFolder then
            return DIR .. "/" .. fileName .. ".json"
        end
        -- executor ที่ไม่มี makefolder: ใช้ไฟล์เดี่ยว ใส่ UserId ไว้ในชื่อไฟล์แทน
        return ROOT .. "_" .. tostring(owner.UserId) .. "_" .. fileName .. ".json"
    end

    local function ensureFolder()
        if not canFolder then return end
        pcall(function()
            if not isfolder(ROOT) then makefolder(ROOT) end
            if not isfolder(DIR) then makefolder(DIR) end
        end)
    end

    local function copy(value)
        if type(value) ~= "table" then return value end
        local out = {}
        for k, v in pairs(value) do
            out[k] = copy(v)
        end
        return out
    end

    -- ทำให้เป็นข้อมูลที่ JSON เก็บได้ (ตัด function / Instance ทิ้ง)
    local function clean(value, depth)
        depth = depth or 0
        local kind = type(value)
        if kind == "string" or kind == "boolean" then return value end
        if kind == "number" then
            if value ~= value or value == math.huge or value == -math.huge then return nil end
            return value
        end
        if kind ~= "table" or depth > 6 then return nil end

        local count, isArray = 0, true
        for k in pairs(value) do
            count = count + 1
            if type(k) ~= "number" then isArray = false end
        end
        if isArray then
            for i = 1, count do
                if value[i] == nil then
                    isArray = false
                    break
                end
            end
        end

        local out = {}
        if isArray then
            for i = 1, count do
                local c = clean(value[i], depth + 1)
                if c ~= nil then table.insert(out, c) end
            end
        else
            for k, v in pairs(value) do
                local c = clean(v, depth + 1)
                if c ~= nil then out[tostring(k)] = c end
            end
        end
        return out
    end

    -- อ่านไฟล์ของไอดีนี้ (ไม่มีไฟล์ / อ่านไม่ได้ = ตารางว่าง = ใช้ค่าเริ่มต้น)
    function SettingsStore.Load(fileName)
        if not canSave then return {} end
        local ok, data = pcall(function()
            local path = SettingsStore.Path(fileName)
            if not isfile(path) then return nil end
            return HttpService:JSONDecode(readfile(path))
        end)
        if ok and type(data) == "table" then return data end
        return {}
    end

    function SettingsStore.Write(fileName, data)
        if not canSave then return false end
        ensureFolder()
        local ok = pcall(function()
            writefile(SettingsStore.Path(fileName), HttpService:JSONEncode(data))
        end)
        return ok
    end

    -- เอาค่าที่เซฟไว้ (saved) ใส่ลงตาราง target
    -- รับเฉพาะ key ที่มีอยู่ในค่าเริ่มต้น และชนิดข้อมูลต้องตรงกัน (กันไฟล์เก่า/ไฟล์เพี้ยนทำสคริปต์พัง)
    function SettingsStore.Restore(target, saved)
        if type(target) ~= "table" or type(saved) ~= "table" then return end
        for key, default in pairs(target) do
            local value = saved[key]
            if value ~= nil then
                if type(default) == "table" then
                    if type(value) == "table" then
                        if next(default) == nil then
                            -- ค่าเริ่มต้นเป็นตารางว่าง (เช่น รายการที่ติ๊กเลือก) ใช้ที่เซฟไว้ทั้งก้อน
                            target[key] = copy(value)
                        else
                            SettingsStore.Restore(default, value)
                        end
                    end
                elseif type(default) == type(value) then
                    target[key] = value
                end
            end
        end
    end

    function SettingsStore.IndexOf(options, name, fallback)
        return table.find(options, name) or fallback or 1
    end

    -- ตาราง { ชื่อ = true } -> รายการ index ของตัวเลือกที่ติ๊กไว้ (ใช้กับ PopUpButton)
    function SettingsStore.IndexesFromMap(options, map)
        local out = {}
        if type(map) == "table" then
            for i, name in ipairs(options) do
                if map[name] then table.insert(out, i) end
            end
        end
        return out
    end

    -- กรองรายการ index ให้เหลือเฉพาะเลขที่ใช้ได้ (ไม่ซ้ำ และอยู่ในช่วง 1..max) โดยคงลำดับเดิม
    function SettingsStore.ValidIndexes(list, max)
        local out, seen = {}, {}
        if type(list) == "table" then
            for _, index in ipairs(list) do
                if type(index) == "number" and index >= 1 and index <= max and index % 1 == 0 and not seen[index] then
                    seen[index] = true
                    table.insert(out, index)
                end
            end
        end
        return out
    end

    -- เริ่มบันทึกอัตโนมัติ: ตรวจทุก interval วินาที ถ้าค่าเปลี่ยนจะเขียนลงไฟล์
    function SettingsStore.StartAutoSave(fileName, getData, interval)
        if flushers[fileName] then return end
        local last = nil

        local function flush()
            local ok, snapshot = pcall(function()
                return clean(getData())
            end)
            if not ok or type(snapshot) ~= "table" then return end

            local okSig, signature = pcall(function()
                return HttpService:JSONEncode(snapshot)
            end)
            if not okSig or signature == last then return end

            snapshot.SavedAt = os.time()
            snapshot.Account = owner.Name
            if SettingsStore.Write(fileName, snapshot) then
                last = signature
                if SettingsStore.OnSaved then pcall(SettingsStore.OnSaved, snapshot.SavedAt) end
            end
        end

        flushers[fileName] = flush
        task.spawn(function()
            while true do
                task.wait(interval or 1.5)
                flush()
            end
        end)
    end

    -- สั่งเซฟทันที (ไม่ต้องรอรอบถัดไป)
    function SettingsStore.Flush(fileName)
        local flush = flushers[fileName]
        if flush then pcall(flush) end
    end
end

-- โหลดค่าที่จำไว้ของไอดีนี้ (ไม่เคยเซฟ = ใช้ค่าเริ่มต้น)
local SavedData = SettingsStore.Load("AOTR")
local SavedUi = type(SavedData.UI) == "table" and SavedData.UI or {}
do -- config ที่ตั้งเป็น Autoload เก็บหน้าตาไว้ด้วย: ใช้หน้าตาของมันตั้งแต่ตอนเริ่ม
    local autoSnap = ConfigStore.AutoloadSnapshot()
    if autoSnap and type(autoSnap.UI) == "table" then
        for k, v in pairs(autoSnap.UI) do SavedUi[k] = v end
    end
end

-- โหลดค่าสวิตช์/ตัวเลือกทั้งหมด: ไฟล์ใหม่ก่อน ถ้ายังไม่มีใช้ไฟล์เก่าของเวอร์ชันก่อน (ย้ายค่าให้อัตโนมัติ)
if type(SavedData.Cfg) == "table" then ApplyCfgData(SavedData.Cfg) else ApplyCfgData(ReadLegacyCfg()) end
-- มี Autoload ไว้ = ใช้ config นั้นทุกครั้งที่เริ่ม (และถือว่ากำลังใช้ config นั้นอยู่)
if ConfigStore.AutoloadSnapshot() then
    ConfigStore.ApplyCfg(ConfigStore.AutoloadSnapshot())
    ConfigStore.SetActive(ConfigStore.Autoload())
end
Cfg.JoinDelay = ClampDelay(Cfg.JoinDelay)
Cfg.MissionJoinDelay = ClampDelay(Cfg.MissionJoinDelay)
Cfg.RaidJoinDelay = ClampDelay(Cfg.RaidJoinDelay)

local AccentOrder
do
---------------------------------------------------------
-- 🎨 สีพื้นหลัง UI ที่เปลี่ยนตามสี Theme Color
-- แก้รหัสสี (hex) ตรงนี้ได้เลย
-- Background = พื้นหลังหน้าต่าง, View = การ์ดของแต่ละหมวด
-- Sidebar = แถบซ้าย, Titlebar = แถบบนสุด, Menu = เมนูดรอปดาวน์
---------------------------------------------------------
local WindowTints = {
    Blue     = { Background = "#0F1722", View = "#121C2A", Sidebar = "#111B29", Titlebar = "#1D2D45", Menu = "#182436" },
    Purple   = { Background = "#1A1226", View = "#1F1630", Sidebar = "#1C1429", Titlebar = "#33214D", Menu = "#261A38" },
    Pink     = { Background = "#25121A", View = "#2C161F", Sidebar = "#281420", Titlebar = "#4A2133", Menu = "#361B28" },
    Red      = { Background = "#241211", View = "#2B1615", Sidebar = "#271413", Titlebar = "#4A2220", Menu = "#351B1A" },
    Orange   = { Background = "#241A0F", View = "#2B1F12", Sidebar = "#271C10", Titlebar = "#4A3317", Menu = "#35261A" },
    Yellow   = { Background = "#222010", View = "#292611", Sidebar = "#252210", Titlebar = "#453D16", Menu = "#322E18" },
    Green    = { Background = "#0F2016", View = "#12271A", Sidebar = "#112318", Titlebar = "#1D4029", Menu = "#1A3022" },
    Graphite = { Background = "#1C1C1E", View = "#1F1F21", Sidebar = "#202023", Titlebar = "#363636", Menu = "#2C2C2E" },
}

for accentName, tint in pairs(WindowTints) do
    pcall(function()
        local dark = Cascade.Accents[accentName].Dark
        dark.Background = Color3.fromHex(tint.Background)
        dark.View = Color3.fromHex(tint.View)
        dark.Sidebar = Color3.fromHex(tint.Sidebar)
        dark.Titlebar = Color3.fromHex(tint.Titlebar)
        dark.MenuButton = { MenuBackground = Color3.fromHex(tint.Menu) }
    end)
end

---------------------------------------------------------
-- 🌈 สีเพิ่มเติม (สร้างสีหลัก + สีพื้นหลังให้อัตโนมัติจากรหัสสีเดียว)
-- อยากเพิ่มสีใหม่ แค่เติมบรรทัด { "ชื่อสี", "#รหัสสี" } ในตารางนี้
---------------------------------------------------------
local ExtraAccents = {
    -- โทนมืด: ใส่สีพื้นหลังกำหนดเองเป็นช่องที่ 3
    { "Black", "#9A9AA0", { Background = "#000000", View = "#090909", Sidebar = "#050505", Titlebar = "#141414", Menu = "#101010" } },
    { "Midnight", "#4C6EF5", { Background = "#05080F", View = "#0A0F1A", Sidebar = "#070B14", Titlebar = "#131C30", Menu = "#0E1524" } },
    { "Sky",        "#64D2FF" },
    { "Cyan",       "#00C7E6" },
    { "Teal",       "#30B0C7" },
    { "Turquoise",  "#40E0D0" },
    { "Aqua",       "#00E5FF" },
    { "Mint",       "#63E6BE" },
    { "Emerald",    "#10B981" },
    { "Forest",     "#2E8B57" },
    { "Lime",       "#A3E635" },
    { "Neon Green", "#39FF14" },
    { "Olive",      "#8A9A2B" },
    { "Gold",       "#FFC83D" },
    { "Amber",      "#FFA726" },
    { "Sand",       "#D9B97A" },
    { "Sunset",     "#FF7A45" },
    { "Peach",      "#FF9E80" },
    { "Coral",      "#FF6F61" },
    { "Cherry",     "#E0245E" },
    { "Crimson",    "#DC143C" },
    { "Maroon",     "#A52A2A" },
    { "Rose",       "#FF5C8A" },
    { "Hot Pink",   "#FF2E93" },
    { "Magenta",    "#E040FB" },
    { "Violet",     "#8B5CF6" },
    { "Lavender",   "#B39DDB" },
    { "Indigo",     "#5E5CE6" },
    { "Ocean",      "#1E88E5" },
    { "Navy",       "#3A5BA0" },
    { "Slate",      "#7C8DA6" },
    { "Silver",     "#B0B7C3" },
    { "Brown",      "#A2845E" },
}

local function MakeAccent(name, hex, customBg)
    local main = Color3.fromHex(hex)
    local h, s, val = main:ToHSV()

    local selection = Color3.fromHSV(h, math.min(s * 1.05, 1), math.min(val * 0.78, 0.72))
    local focused = Color3.fromHSV(h, s, math.min(val * 0.88, 0.80))
    local buttonBottom = Color3.fromHSV(h, math.min(s * 1.1, 1), math.min(val * 0.6, 0.55))
    local bgS = math.min(s * 0.6, 0.55)

    local function buildSet()
        return {
            SwitchAccent = main,
            Selection = selection,
            SelectionFocused = focused,
            Toggle = { SwitchOn = main },
            Button = { FillPrimary = ColorSequence.new(focused, buttonBottom) },
        }
    end

    local dark = buildSet()
    dark.Background = Color3.fromHSV(h, bgS, 0.13)
    dark.View = Color3.fromHSV(h, bgS, 0.16)
    dark.Sidebar = Color3.fromHSV(h, bgS * 0.95, 0.15)
    dark.Titlebar = Color3.fromHSV(h, bgS * 0.85, 0.28)
    dark.MenuButton = { MenuBackground = Color3.fromHSV(h, bgS * 0.8, 0.20) }

    if customBg then
        dark.Background = Color3.fromHex(customBg.Background)
        dark.View = Color3.fromHex(customBg.View)
        dark.Sidebar = Color3.fromHex(customBg.Sidebar)
        dark.Titlebar = Color3.fromHex(customBg.Titlebar)
        dark.MenuButton = { MenuBackground = Color3.fromHex(customBg.Menu) }
    end

    Cascade.Accents[name] = {
        _id = name,
        Dark = dark,
        Light = buildSet(),
    }
end

-- Dark แบบดั้งเดิมของ Cascade: สีปุ่มฟ้าเดิม + พื้นหลังเทาเข้มเดิม
-- ต้องใส่สีพื้นหลังเดิมทับให้ครบทุกช่อง เพราะ Cascade ไม่รีเซ็ตสีเก่าให้ตอนสลับสี
-- (ถ้าไม่ใส่ จะค้างโทนสีของสีก่อนหน้า)
do
    local originalSet = function()
        return {
            SwitchAccent = Color3.fromHex("#0A84FF"),
            Selection = Color3.fromHex("#007AFF"),
            SelectionFocused = Color3.fromHex("#0A82FF"),
            Toggle = { SwitchOn = Color3.fromHex("#0A84FF") },
            Button = {
                FillPrimary = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 148, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 110, 255)),
                }),
            },
        }
    end
    local darkSet = originalSet()
    darkSet.Background = Color3.fromHex("#1C1C1E") -- พื้นหลังหน้าต่าง
    darkSet.View = Color3.fromHex("#1F1F21")       -- การ์ดของแต่ละหมวด
    darkSet.Sidebar = Color3.fromHex("#202023")    -- แถบซ้าย
    darkSet.Titlebar = Color3.fromHex("#363636")   -- แถบบนสุด
    darkSet.MenuButton = { MenuBackground = Color3.fromHex("#2C2C2E") }

    Cascade.Accents.Dark = {
        _id = "Dark",
        Dark = darkSet,
        Light = originalSet(),
    }
end

-- ลำดับสีในเมนู: สีเดิม 8 สี, Dark แบบดั้งเดิม แล้วตามด้วยสีเพิ่มเติม
AccentOrder = { "Blue", "Purple", "Pink", "Red", "Orange", "Yellow", "Green", "Graphite", "Dark" }
for _, entry in ipairs(ExtraAccents) do
    pcall(MakeAccent, entry[1], entry[2], entry[3])
    if Cascade.Accents[entry[1]] then
        table.insert(AccentOrder, entry[1])
    end
end
end

local function StyleDropdown(btn)
    pcall(function()
        local indicator = btn.__instance:FindFirstChild("PullDownIndicator")
        local img = indicator and indicator:FindFirstChild("Indicators")
        if img then
            img.Image = "rbxassetid://115187614425058"
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Size = UDim2.fromOffset(18, 18)
            img.Position = UDim2.fromScale(0.5, 0.5)
            img.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    end)
end

local function CopyText(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif syn and syn.write_clipboard then syn.write_clipboard(text)
        elseif Clipboard and Clipboard.set then Clipboard.set(text) end
    end)
end

local App = Cascade.New({
    Name = "Smooth Hub AOTR",
    WindowPill = true,
    Theme = Cascade.Themes.Dark,
    -- สีเริ่มต้น = สีที่จำไว้ (ถ้าไม่เคยตั้ง ใช้ Pink เหมือนเดิม)
    Accent = (table.find(AccentOrder, SavedUi.Theme) and Cascade.Accents[SavedUi.Theme]) or Cascade.Accents[ConfigStore.DEFAULT_LOOK.Theme] or Cascade.Accents.Pink,
})
AppRef = App

-- 📱 จอเล็ก (มือถือ): ย่อหน้าต่างให้พอดีจอ (ปกติ 850x530 ใหญ่เกินจอมือถือ)
local WindowSize = UDim2.fromOffset(850, 530)
pcall(function()
    local cam = workspace.CurrentCamera
    if cam then
        local vp = cam.ViewportSize
        WindowSize = UDim2.fromOffset(math.clamp(vp.X - 30, 320, 850), math.clamp(vp.Y - 30, 240, 530))
    end
end)

local Window = App:Window({
    Title = "Attack on Titan Revolution",
    Subtitle = "Smooth Hub | Version 1",
    Size = WindowSize,
    Resizable = true,
    Draggable = true,
    UIBlur = false
})
UiSync.Defaults.UIBlur = false
UiSync.Defaults.Dropshadow = Window.Dropshadow

---------------------------------------------------------
-- Menu (หน้าเมนู / Lobby)
---------------------------------------------------------
local MenuCategory = Cascade.Components.Section(Window, {
    Title = "Menu",
    Disclosure = false
})

local CharTab = MenuCategory:Tab({
    Title = "Menu Lobby",
    Icon = Icon("houseDoorFill", "houseFill", "personCircleFill"), -- เปลี่ยนเป็นไอคอนรูปบ้าน/ล็อบบี้ให้เหมาะสม
})


-- ───────── Status ─────────
local StatusSection = CharTab:PageSection({
    Title = "📋 Status",
    Subtitle = IN_MENU and "You are in the menu place." or "Not in the menu place - menu features are idle."
})
local StatusForm = StatusSection:Form()
local StatusRow = StatusForm:Row()
StatusRow:Left():TitleStack({ Title = "Status", Subtitle = "What the script is doing right now." })
local StatusLabel = StatusRow:Right():Label({ Text = IN_MENU and "Idle" or "N/A" })
local function SetStatus(text)
    pcall(function() StatusLabel.Text = tostring(text) end)
end

---------------------------------------------------------
-- 🎭 Character Selection (ตรรกะ)
---------------------------------------------------------
local SLOT_LETTERS = { "A", "B", "C" }
local SlotOptions = { "Slot A", "Slot B", "Slot C" }

local function TextOf(o)
    local t = o.Text or ""
    t = t:gsub("<[^>]->", "")          -- ตัด RichText tag
    t = t:gsub("^%s+", ""):gsub("%s+$", "")
    return t:upper()
end

local function IsTextObj(o)
    return o:IsA("TextLabel") or o:IsA("TextButton")
end

-- เห็นอยู่บนหน้าจอจริงไหม (ทุกชั้นต้อง Visible/Enabled)
local function IsShown(obj)
    local cur = obj
    while cur and cur ~= PlayerGui do
        if cur:IsA("GuiObject") and not cur.Visible then return false end
        if cur:IsA("ScreenGui") and not cur.Enabled then return false end
        cur = cur.Parent
    end
    return obj:IsA("GuiObject") and obj.AbsoluteSize.X > 0 and obj.AbsoluteSize.Y > 0
end

local function ToButton(o)
    if o:IsA("GuiButton") then return o end
    local cur = o.Parent
    for _ = 1, 3 do
        if not cur then break end
        if cur:IsA("GuiButton") then return cur end
        cur = cur.Parent
    end
    local p = o.Parent
    if p then return p:FindFirstChildWhichIsA("GuiButton", true) end
    return nil
end

local function FindSelectIn(container)
    for _, d in ipairs(container:GetDescendants()) do
        if IsTextObj(d) and TextOf(d) == "SELECT" and IsShown(d) then
            local b = ToButton(d)
            if b then return b end
        end
    end
    return nil
end

-- หาปุ่ม SELECT ของช่องนั้น: หาป้าย "SLOT A" แล้วไต่ขึ้นไปหากรอบที่มีปุ่ม SELECT
local function FindSlotButton(letter)
    local want = "SLOT " .. letter
    for _, d in ipairs(PlayerGui:GetDescendants()) do
        if IsTextObj(d) and TextOf(d) == want and IsShown(d) then
            local cur = d.Parent
            for _ = 1, 6 do
                if not cur or cur == PlayerGui then break end
                local btn = FindSelectIn(cur)
                if btn then return btn end
                cur = cur.Parent
            end
        end
    end
    return nil
end

-- หน้าเลือกตัวละครยังโชว์อยู่ไหม
local function SlotScreenVisible()
    for _, d in ipairs(PlayerGui:GetDescendants()) do
        if IsTextObj(d) and TextOf(d) == "SLOT A" and IsShown(d) then return true end
    end
    return false
end

-- กดปุ่ม: ตั้ง SelectedObject (กรอบฟ้าเหมือนกด \) แล้วส่ง Enter
-- ถ้าปุ่มยังอยู่ = Enter ไม่ติด ค่อยยิง signal ตรง ๆ เป็นตัวสำรอง
local function ActivateButton(btn)
    pcall(function() GuiService.SelectedObject = btn end)
    task.wait(0.15)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end)
    task.wait(1.0)
    if btn.Parent and IsShown(btn) then
        pcall(function()
            if type(firesignal) == "function" then
                firesignal(btn.MouseButton1Click)
                firesignal(btn.Activated)
            end
        end)
    end
    pcall(function()
        if GuiService.SelectedObject == btn then GuiService.SelectedObject = nil end
    end)
end

local selecting = false
local function SelectCharacter()
    if selecting then return false end
    if not IN_MENU then SetStatus("N/A") return false end
    selecting = true
    local letter = SLOT_LETTERS[Cfg.Slot] or "A"
    local btn = FindSlotButton(letter)
    local result = false
    if btn then
        SetStatus("Selecting Slot " .. letter .. "...")
        ActivateButton(btn)
        SetStatus("Selected Slot " .. letter)
        result = true
    else
        SetStatus("Slot " .. letter .. " UI not found")
    end
    selecting = false
    return result
end

---------------------------------------------------------
-- 🎭 Character Selection (UI)
---------------------------------------------------------
local CharSection = CharTab:PageSection({
    Title = "🎭 Character Selection",
    Subtitle = "Pick one slot. The script presses its SELECT button for you."
})
local CharForm = CharSection:Form()

local SlotRow = CharForm:Row()
SlotRow:Left():TitleStack({ Title = "Slot", Subtitle = "Choose which character slot to use (one at a time)." })
UiSync.Slot = SlotRow:Right():PullDownButton({
    Label = SlotOptions[Cfg.Slot],
    Options = SlotOptions,
    Value = Cfg.Slot,
    ValueChanged = function(self, index)
        if type(index) == "table" then index = index[1] end
        if type(index) ~= "number" or not SlotOptions[index] then return end
        Cfg.Slot = index
        self.Label = SlotOptions[index]
        Save()
    end
})
UiSync.Add(function()
    local i = SlotOptions[Cfg.Slot] and Cfg.Slot or 1
    UiSync.Slot.Value = i
    UiSync.Slot.Label = SlotOptions[i]
end)

local AutoSelRow = CharForm:Row()
AutoSelRow:Left():TitleStack({
    Title = "Auto Select Character",
    Subtitle = "Automatically press SELECT on the chosen slot when the screen shows up."
})
UiSync.Link(AutoSelRow:Right():Toggle({
    Value = Cfg.AutoSelect,
    ValueChanged = function(self, value)
        Cfg.AutoSelect = value and true or false
        Save()
    end
}), Cfg, "AutoSelect")

local SelNowRow = CharForm:Row()
SelNowRow:Left():TitleStack({ Title = "Select Now", Subtitle = "Press SELECT on the chosen slot once." })
local SelNowBtn = SelNowRow:Right():Button({
    Label = "Select",
    Callback = function() end
})
BindButton(SelNowBtn, SelectCharacter)

---------------------------------------------------------
-- 🚪 Auto Join Lobby (ตรรกะ)
---------------------------------------------------------
local function GetLobbyRemote()
    local ok, remote = pcall(function()
        local assets = ReplicatedStorage:WaitForChild("Assets", 5)
        local remotes = assets and assets:WaitForChild("Remotes", 5)
        return remotes and remotes:WaitForChild("GET", 5)
    end)
    return ok and remote or nil
end

local cachedRemote = nil
local lastRequestAt = 0
-- ยิงคำขอในเธรดแยก ไม่บล็อกตัวนับเวลา (InvokeServer อาจค้างรอเซิร์ฟเวอร์นาน)
local function JoinLobby()
    if not IN_MENU then SetStatus("N/A") return end
    if os.clock() - lastRequestAt < 3 then return end
    lastRequestAt = os.clock()
    task.spawn(function()
        local remote = cachedRemote
        if not remote or not remote.Parent then
            remote = GetLobbyRemote()
            cachedRemote = remote
        end
        if not remote then SetStatus("Lobby remote not found") return end
        SetStatus("Joining lobby...")
        local ok, err = pcall(function()
            return remote:InvokeServer("Functions", "Teleport", "Lobby", nil)
        end)
        SetStatus(ok and "Join request sent" or ("Join failed: " .. tostring(err)))
    end)
end

---------------------------------------------------------
-- 🚪 Auto Join Lobby (UI)
---------------------------------------------------------
local JoinSection = CharTab:PageSection({
    Title = "🚪 Auto Join Lobby",
    Subtitle = "Repeatedly requests the lobby. Delay is " .. MIN_DELAY .. " - " .. MAX_DELAY .. " seconds."
})
local JoinForm = JoinSection:Form()

local AutoJoinRow = JoinForm:Row()
AutoJoinRow:Left():TitleStack({
    Title = "Auto Join Lobby",
    Subtitle = "Send the join-lobby request every Join Delay seconds."
})
UiSync.Link(AutoJoinRow:Right():Toggle({
    Value = Cfg.AutoJoin,
    ValueChanged = function(self, value)
        Cfg.AutoJoin = value and true or false
        Save()
    end
}), Cfg, "AutoJoin")

local DelayRow = JoinForm:Row()
DelayRow:Left():TitleStack({
    Title = "Join Delay",
    Subtitle = "Seconds between requests (" .. MIN_DELAY .. " - " .. MAX_DELAY .. "). Minimum is " .. MIN_DELAY .. "s so it can't spam by accident."
})
local DelayRight = DelayRow:Right()
local DelayLabel = DelayRight:Label({ Text = Cfg.JoinDelay .. "s" })
UiSync.Link(DelayRight:Slider({
    Minimum = MIN_DELAY,
    Maximum = MAX_DELAY,
    Value = Cfg.JoinDelay,
    ValueChanged = function(self, value)
        Cfg.JoinDelay = ClampDelay(value)
        pcall(function() DelayLabel.Text = Cfg.JoinDelay .. "s" end)
        Save()
    end
}), Cfg, "JoinDelay", function(_, want)
    pcall(function() DelayLabel.Text = want .. "s" end)
end)

local CountdownRow = JoinForm:Row()
CountdownRow:Left():TitleStack({
    Title = "Next Join",
    Subtitle = "Countdown until the next join-lobby request."
})
local CountdownLabel = CountdownRow:Right():Label({ Text = "Off" })
local lastCountdownText = nil
local function SetCountdown(text)
    if text == lastCountdownText then return end
    lastCountdownText = text
    pcall(function() CountdownLabel.Text = text end)
end

local JoinNowRow = JoinForm:Row()
JoinNowRow:Left():TitleStack({ Title = "Join Now", Subtitle = "Send the join-lobby request once." })
local JoinNowBtn = JoinNowRow:Right():Button({
    Label = "Join",
    Callback = function() end
})
BindButton(JoinNowBtn, JoinLobby)

---------------------------------------------------------
-- 🎰 Auto Spin (หน้า Family: กดปุ่ม ROLL)
-- กดด้วยวิธีเดียวกับ Character Selection: ตั้งกรอบฟ้า (GuiService.SelectedObject) ที่ปุ่ม ROLL แล้วส่ง Enter
-- ไม่ยิง Remote เอง ให้เกมส่งคำสั่งตามปุ่มที่กดตามปกติ
-- กันทับของดี: ก่อนสปินทุกครั้งอ่าน "ชื่อ (ความหายาก)" ของ Family ปัจจุบันจากหน้าจอ
--  • ถ้าความหายาก >= Stop At Rarity จะหยุดทันที (ไม่สปินทับ) และปิดสวิตช์ให้
--  • ถ้าอ่านค่าไม่ได้ (เช่น กำลังเล่นอนิเมชัน) จะไม่สปิน รออ่านได้ก่อน
--  • ถ้า ROLL เหลือ 0 จะหยุด
-- เปิดหน้า Family ให้เองอัตโนมัติ: กดปุ่ม CUSTOMIZATION ที่เมนูหลัก แล้วกดปุ่มไอคอน F (หาจากชื่อปุ่มที่มีคำว่า "family")
-- ถ้าหาปุ่มไอคอน F ไม่เจอ ให้รัน _G.SmoothHubSpin.DumpButtons() ตอนอยู่หน้าแต่งตัว แล้วส่งรายการปุ่มมา
---------------------------------------------------------
do
    local RANK = { COMMON = 1, UNCOMMON = 2, RARE = 3, EPIC = 4, LEGENDARY = 5, MYTHIC = 6, SECRET = 7, EXCLUSIVE = 8 }
    local STOP_OPTIONS = { "Rare", "Epic", "Legendary", "Mythic", "Off" } -- Off = ไม่หยุดตามความหายากเลย (หยุดเฉพาะตระกูลที่ตั้ง Always Keep / ROLL หมด)

    if not table.find(STOP_OPTIONS, Cfg.SpinStopRarity) then Cfg.SpinStopRarity = "Epic" end

    -- ───── เจอ Family ที่อยากเก็บแล้วทำอะไร ─────
    local KEEP_ACTIONS = { "Stop", "Store", "Ask" }
    local KEEP_LABELS = { "Stop spinning", "Store & keep spinning", "Ask me" }
    if not table.find(KEEP_ACTIONS, Cfg.SpinOnKeep) then Cfg.SpinOnKeep = "Stop" end

    -- ตารางตระกูล -> ความหายาก (ชื่อตัวพิมพ์ใหญ่) ใช้เป็นรายชื่อให้เลือกตั้งกฎล่วงหน้า
    -- ตอนสปินจริงใช้ความหายากที่เกมแสดงบนหน้าจอเป็นหลัก ตระกูลที่ไม่อยู่ในตารางก็ตั้งกฎผ่านคอนฟิกได้
    local FAMILY_RARITY = {
        HELOS = "MYTHIC", FRITZ = "MYTHIC",
        YEAGER = "LEGENDARY", ACKERMAN = "LEGENDARY", REISS = "LEGENDARY",
        GALLIARD = "EPIC", ZOE = "EPIC", LEONHART = "EPIC", TYBUR = "EPIC",
        KSAVER = "EPIC", BRAUN = "EPIC", FINGER = "EPIC", ARLERT = "EPIC",
        BRAUS = "RARE", KRUGER = "RARE", AZUMABITO = "RARE", SMITH = "RARE",
        GRICE = "RARE", SPRINGER = "RARE", KIRSTEIN = "RARE",
    }

    local function Cap(s)
        return (tostring(s):lower():gsub("^%l", string.upper))
    end
    local function Pretty(name)
        return (tostring(name):lower():gsub("(%a)([%w_']*)", function(a, b) return a:upper() .. b end))
    end

    local FAMILY_LIST, FAMILY_LABELS = {}, {}
    for key, rar in pairs(FAMILY_RARITY) do FAMILY_LIST[#FAMILY_LIST + 1] = { key = key, rarity = rar } end
    table.sort(FAMILY_LIST, function(a, b)
        if RANK[a.rarity] ~= RANK[b.rarity] then return RANK[a.rarity] > RANK[b.rarity] end
        return a.key < b.key
    end)
    for i, f in ipairs(FAMILY_LIST) do FAMILY_LABELS[i] = Pretty(f.key) .. " (" .. Cap(f.rarity) .. ")" end

    -- Cfg.SpinFamilyRules เก็บเป็นสตริง "YEAGER=Keep;REISS=Skip" (เซฟ/โหลด/รีเซ็ตผ่านระบบ Config เดิมได้เลย)
    local rulesSrc, rulesCache = nil, {}
    local function Rules()
        if rulesSrc ~= Cfg.SpinFamilyRules then
            rulesSrc = Cfg.SpinFamilyRules
            rulesCache = {}
            for key, rule in tostring(rulesSrc):gmatch("([^=;]+)=(%a+)") do
                if rule == "Keep" or rule == "Skip" or rule == "Ask" then rulesCache[key:upper()] = rule end
            end
        end
        return rulesCache
    end
    local function WriteRules(map) -- map: ชื่อตัวพิมพ์ใหญ่ -> "Keep" | "Skip" | "Ask" (nil = Default)
        local parts = {}
        for k, v in pairs(map) do parts[#parts + 1] = k .. "=" .. v end
        table.sort(parts)
        Cfg.SpinFamilyRules = table.concat(parts, ";")
        Save()
    end
    local function SetRule(name, rule) -- ตั้งทีละตัว (rule = nil คือ Default) เรียกจาก executor ได้
        local copy = {}
        for k, v in pairs(Rules()) do copy[k] = v end
        copy[tostring(name):upper()] = rule
        WriteRules(copy)
    end
    local function RulesSummary()
        local keep, skip, ask = {}, {}, {}
        for key, rule in pairs(Rules()) do
            local list = (rule == "Keep" and keep) or (rule == "Skip" and skip) or ask
            list[#list + 1] = Pretty(key)
        end
        local function J(l)
            table.sort(l)
            return #l > 0 and table.concat(l, ", ") or "-"
        end
        return ("Always keep: %s | Never keep: %s | Always ask: %s"):format(J(keep), J(skip), J(ask))
    end

    -- ตัดสินใจกับ Family ตัวนี้: "roll" (สปินต่อ) | "stop" | "store" | "ask"
    local function Decide(name, rarity)
        local rule = Rules()[tostring(name):upper()]
        if rule == "Skip" then return "roll" end
        if rule == "Ask" then return "ask" end
        local stopRank = Cfg.SpinStopRarity == "Off" and math.huge or (RANK[Cfg.SpinStopRarity:upper()] or RANK.EPIC)
        local keeper = rule == "Keep" or (RANK[tostring(rarity):upper()] or 0) >= stopRank
        if not keeper then return "roll" end
        if Cfg.SpinOnKeep == "Store" then return "store" end
        if Cfg.SpinOnKeep == "Ask" then return "ask" end
        return "stop"
    end
    SH.Spin = SH.Spin or {}
    SH.Spin.Decide = Decide
    SH.Spin.SetRule = SetRule

    -- 3 หมวด: Roll Family (สั่งสุ่ม/สถานะ) | Settings Roll (กฎเก็บตระกูล) | Show Roll (ประวัติการสุ่ม)
    local SpinForm = CharTab:PageSection({
        Title = "🎰 Roll Family",
        Subtitle = "Auto roll your family."
    }):Form()
    local RuleForm = CharTab:PageSection({
        Title = "⚙️ Settings Roll",
        Subtitle = "Choose which families to keep."
    }):Form()
    local ShowForm = CharTab:PageSection({
        Title = "📜 Show Roll",
        Subtitle = "Your roll history."
    }):Form()

    local spinToggle
    local spinRow = SpinForm:Row()
    spinRow:Left():TitleStack({
        Title = "Auto Spin [ Lucky999+ ]",
        Subtitle = "Keeps pressing ROLL for you."
    })
    spinToggle = UiSync.Link(spinRow:Right():Toggle({
        Value = Cfg.AutoSpin,
        ValueChanged = function(self, value)
            Cfg.AutoSpin = value and true or false
            Save()
        end
    }), Cfg, "AutoSpin")

    -- Spin Status
    local statusRow = SpinForm:Row()
    statusRow:Left():TitleStack({ Title = "Spin Status", Subtitle = "What Auto Spin is doing now." })
    local statusLabel = statusRow:Right():Label({ Text = "Off" })
    local lastStatus = nil
    local function Status(text)
        text = tostring(text)
        if text == lastStatus then return end
        lastStatus = text
        pcall(function() statusLabel.Text = text end)
    end

    -- Last Roll
    local lastRow = SpinForm:Row()
    local lastStack = lastRow:Left():TitleStack({ Title = "Last Roll", Subtitle = "No rolls yet." })
    local lastLabel = lastRow:Right():Label({ Text = "-" })

    -- Stop At Rarity
    local stopRow = RuleForm:Row()
    stopRow:Left():TitleStack({
        Title = "Keep Rarity",
        Subtitle = "Keep this rarity or higher. Off = never stop for rarity."
    })
    local function StopIndex()
        return table.find(STOP_OPTIONS, Cfg.SpinStopRarity) or 2
    end
    local stopDrop = stopRow:Right():PullDownButton({
        Label = STOP_OPTIONS[StopIndex()],
        Options = STOP_OPTIONS,
        Value = StopIndex(),
        ValueChanged = function(self, index)
            if type(index) == "table" then index = index[1] end
            if type(index) ~= "number" or not STOP_OPTIONS[index] then return end
            Cfg.SpinStopRarity = STOP_OPTIONS[index]
            self.Label = STOP_OPTIONS[index]
            Save()
        end
    })
    UiSync.Add(function()
        local i = StopIndex()
        stopDrop.Value = i
        stopDrop.Label = STOP_OPTIONS[i]
    end)

    -- When I Get A Keeper
    local keepRow = RuleForm:Row()
    keepRow:Left():TitleStack({
        Title = "When I Get A Keeper",
        Subtitle = "Stop, store it and keep rolling, or ask me."
    })
    local function KeepIndex()
        return table.find(KEEP_ACTIONS, Cfg.SpinOnKeep) or 1
    end
    local keepDrop = keepRow:Right():PullDownButton({
        Label = KEEP_LABELS[KeepIndex()],
        Options = KEEP_LABELS,
        Value = KeepIndex(),
        ValueChanged = function(self, index)
            if type(index) == "table" then index = index[1] end
            if type(index) ~= "number" or not KEEP_ACTIONS[index] then return end
            Cfg.SpinOnKeep = KEEP_ACTIONS[index]
            self.Label = KEEP_LABELS[index]
            Save()
        end
    })

    -- Family Rules: ติ๊กได้หลายตระกูลในแต่ละกลุ่ม (ตั้งไว้ล่วงหน้า) ตระกูลหนึ่งอยู่ได้แค่กลุ่มเดียว
    -- ติ๊กตระกูลที่เคยอยู่อีกกลุ่ม = ย้ายมากลุ่มนี้ให้เอง / ตระกูลที่ไม่ได้ติ๊กไว้ในกลุ่มไหน = ใช้ Keep Rarity ตามปกติ
    local rulePickers, syncingRules, rulesStack = {}, false, nil
    local function PickedIndexes(rule)
        local picked = {}
        for i, f in ipairs(FAMILY_LIST) do
            if Rules()[f.key] == rule then picked[#picked + 1] = i end
        end
        return picked
    end
    local function RefreshRulePickers()
        if rulesStack then pcall(function() rulesStack.Subtitle = RulesSummary() end) end
        syncingRules = true
        for rule, p in pairs(rulePickers) do
            if p.multi then pcall(function() p.btn.Value = PickedIndexes(rule) end) end
        end
        syncingRules = false
    end
    local function ApplyPicked(rule, indexes) -- indexes = ตระกูลที่ติ๊กอยู่ในกลุ่มนี้ตอนนี้
        local picked = {}
        for _, i in ipairs(SettingsStore.ValidIndexes(indexes, #FAMILY_LIST)) do picked[FAMILY_LIST[i].key] = true end
        local copy = {}
        for k, v in pairs(Rules()) do copy[k] = v end
        for _, f in ipairs(FAMILY_LIST) do
            if picked[f.key] then
                copy[f.key] = rule
            elseif copy[f.key] == rule then
                copy[f.key] = nil
            end
        end
        WriteRules(copy)
        RefreshRulePickers()
    end
    local function AddRulePicker(title, subtitle, rule)
        local row = RuleForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        local ok, btn = pcall(function()
            return row:Right():PopUpButton({
                Options = FAMILY_LABELS,
                Maximum = #FAMILY_LABELS, -- ต้องกำหนดเกิน 1 ไลบรารีถึงจะติ๊กได้หลายอัน
                Value = PickedIndexes(rule),
                ValueChanged = function(self, value)
                    if syncingRules then return end
                    ApplyPicked(rule, type(value) == "table" and value or { value })
                end
            })
        end)
        if ok and btn then
            rulePickers[rule] = { btn = btn, multi = true }
        else
            -- ไลบรารีไม่รองรับติ๊กหลายอัน: กดเลือกตระกูล = เพิ่ม/เอาออกจากกลุ่มนี้ทีละตัว
            btn = row:Right():PullDownButton({
                Label = "Tap a family to add / remove",
                Options = FAMILY_LABELS,
                Value = 1,
                ValueChanged = function(self, index)
                    if syncingRules then return end
                    if type(index) == "table" then index = index[1] end
                    if type(index) ~= "number" or not FAMILY_LIST[index] then return end
                    local picked = PickedIndexes(rule)
                    local at = table.find(picked, index)
                    if at then table.remove(picked, at) else picked[#picked + 1] = index end
                    ApplyPicked(rule, picked)
                    self.Label = (at and "Removed " or "Added ") .. FAMILY_LABELS[index]
                end
            })
            rulePickers[rule] = { btn = btn, multi = false }
        end
        StyleDropdown(btn)
    end
    AddRulePicker("Always Keep Families",
        "Always keep these, even below Keep Rarity.", "Keep")
    AddRulePicker("Always Ask Families",
        "Ask me every time these roll.", "Ask")
    AddRulePicker("Never Keep Families",
        "Never keep these, even above Keep Rarity.", "Skip")
    local rulesRow = RuleForm:Row()
    rulesStack = rulesRow:Left():TitleStack({ Title = "Saved Rules", Subtitle = RulesSummary() })
    UiSync.Add(function()
        local i = KeepIndex()
        keepDrop.Value = i
        keepDrop.Label = KEEP_LABELS[i]
        RefreshRulePickers()
    end)

    -- Use Spin Delay (เปิด = รอตามเวลาที่ตั้ง | ปิด = ไม่ใช้ดีเลย์ รอจนผลใหม่ขึ้นแล้วไปต่อทันที)
    local useDelayRow = SpinForm:Row()
    useDelayRow:Left():TitleStack({
        Title = "Use Spin Delay",
        Subtitle = "On: wait after every roll. Off: go on as soon as the result shows."
    })
    UiSync.Link(useDelayRow:Right():Toggle({
        Value = Cfg.SpinUseDelay ~= false,
        ValueChanged = function(self, value)
            Cfg.SpinUseDelay = value and true or false
            Save()
        end
    }), Cfg, "SpinUseDelay")

    -- Spin Delay
    local delayRow = SpinForm:Row()
    delayRow:Left():TitleStack({
        Title = "Spin Delay",
        Subtitle = "Seconds to wait after each roll (0.5 - 10)."
    })
    local delayRight = delayRow:Right()
    local delayLabel = delayRight:Label({ Text = Cfg.SpinDelay .. "s" })
    UiSync.Link(delayRight:Slider({
        Minimum = 0.5,
        Maximum = 10,
        Value = Cfg.SpinDelay,
        ValueChanged = function(self, value)
            Cfg.SpinDelay = math.clamp(math.floor((tonumber(value) or 3) * 2 + 0.5) / 2, 0.5, 10) -- ปัดทีละ 0.5
            pcall(function() delayLabel.Text = Cfg.SpinDelay .. "s" end)
            Save()
        end
    }), Cfg, "SpinDelay", function(_, want)
        pcall(function() delayLabel.Text = want .. "s" end)
    end)


    -- ───── ผลสปิน: ได้ Family อะไรบ้าง ─────
    local history, stats = {}, { rolls = 0, byRarity = {} }
    SH.Spin.History = history
    local RARITY_ORDER = { "EXCLUSIVE", "SECRET", "MYTHIC", "LEGENDARY", "EPIC", "UNCOMMON", "RARE", "COMMON" }


    -- สวิตช์ซ่อน/โชว์รายชื่อตระกูลที่สุ่มได้ + เลือกจำนวนที่โชว์
    -- (ประกาศ RefreshList ไว้ก่อน ตัวจริงใส่ทีหลังด้านล่าง เพราะสวิตช์ตรงนี้เรียกใช้)
    local RefreshList = function() end
    local showListRow = ShowForm:Row()
    showListRow:Left():TitleStack({
        Title = "Show Rolled Families",
        Subtitle = "Show or hide the list."
    })
    UiSync.Link(showListRow:Right():Toggle({
        Value = Cfg.SpinShowList == true,
        ValueChanged = function(self, value)
            Cfg.SpinShowList = value and true or false
            Save()
            RefreshList()
        end
    }), Cfg, "SpinShowList", function() RefreshList() end)

    local sizeRow = ShowForm:Row()
    sizeRow:Left():TitleStack({
        Title = "List Size",
        Subtitle = "Recent rolls to show (5 - 100)."
    })
    local sizeRight = sizeRow:Right()
    local sizeLabel = sizeRight:Label({ Text = tostring(Cfg.SpinListSize) })
    UiSync.Link(sizeRight:Slider({
        Minimum = 5,
        Maximum = 100,
        Value = Cfg.SpinListSize,
        ValueChanged = function(self, value)
            Cfg.SpinListSize = math.clamp(math.floor((tonumber(value) or 15) + 0.5), 5, 100)
            pcall(function() sizeLabel.Text = tostring(Cfg.SpinListSize) end)
            Save()
            RefreshList()
        end
    }), Cfg, "SpinListSize", function(_, want)
        pcall(function() sizeLabel.Text = tostring(want) end)
        RefreshList()
    end)

    -- รายชื่อตระกูลที่สุ่มได้ (ใหม่สุดอยู่บนสุด โชว์ตามจำนวนที่ตั้งใน List Size)
    local listRow = ShowForm:Row()
    local listStack = listRow:Left():TitleStack({ Title = "Rolled Families", Subtitle = "Nothing rolled yet." })
    local function ListText()
        local lines = {}
        for i = #history, math.max(1, #history - (math.clamp(tonumber(Cfg.SpinListSize) or 15, 5, 100) - 1)), -1 do
            local e = history[i]
            lines[#lines + 1] = (e.n == 0 and "Start" or ("#" .. e.n)) .. "   " .. e.name .. " (" .. e.rarity .. ")"
        end
        return #lines > 0 and table.concat(lines, "\n") or "Nothing rolled yet."
    end

    local function SummaryText()
        local parts = {}
        for _, r in ipairs(RARITY_ORDER) do
            local n = stats.byRarity[r]
            if n and n > 0 then parts[#parts + 1] = Cap(r) .. " " .. n end
        end
        return ("%d rolls%s"):format(stats.rolls, #parts > 0 and (" | " .. table.concat(parts, " · ")) or "")
    end

    RefreshList = function()
        pcall(function()
            if Cfg.SpinShowList then
                listStack.Subtitle = ListText()
            elseif #history > 0 then
                listStack.Subtitle = "Hidden | " .. SummaryText()
            else
                listStack.Subtitle = "Hidden. Turn on 'Show Rolled Families'."
            end
        end)
    end
    RefreshList() -- ตั้งข้อความเริ่มต้นตามสวิตช์ (ซ่อน/โชว์)

    local function LogResult(name, rarity, isStart)
        if not isStart then
            stats.rolls += 1
            stats.byRarity[rarity] = (stats.byRarity[rarity] or 0) + 1
        end
        local stamp = ""
        pcall(function() stamp = os.date("%H:%M:%S") end)
        local entry = { n = isStart and 0 or stats.rolls, name = Pretty(name), rarity = Cap(rarity), time = stamp }
        history[#history + 1] = entry
        if #history > 300 then table.remove(history, 1) end
        SH.dbg(("[SmoothHub] Spin %s: %s (%s)"):format(isStart and "(start)" or ("#" .. entry.n), entry.name, entry.rarity))
        pcall(function()
            lastLabel.Text = entry.name .. " (" .. entry.rarity .. ")"
            lastStack.Subtitle = (isStart and "Current family when you started" or ("Roll #" .. entry.n)) .. " | " .. SummaryText()
        end)
        RefreshList()
    end

    local function HistoryText()
        local lines = {}
        for _, e in ipairs(history) do
            lines[#lines + 1] = ("%s  %s  %s (%s)"):format(e.n == 0 and "start" or ("#" .. e.n), e.time, e.name, e.rarity)
        end
        lines[#lines + 1] = "--- " .. SummaryText()
        return table.concat(lines, "\n")
    end
    function SH.Spin.PrintHistory() SH.dbg(HistoryText()) end
    function SH.Spin.Clear()
        for i = #history, 1, -1 do history[i] = nil end
        stats.rolls, stats.byRarity = 0, {}
        pcall(function() lastLabel.Text = "-" lastStack.Subtitle = "No rolls yet." end)
        RefreshList()
    end

    local copyRow = ShowForm:Row()
    copyRow:Left():TitleStack({ Title = "Spin Log", Subtitle = "Copy all rolls to the clipboard." })
    local copyBtn = copyRow:Right():Button({ Label = "Copy", Callback = function() end })
    BindButton(copyBtn, function()
        local text = HistoryText()
        pcall(function()
            if type(setclipboard) == "function" then setclipboard(text) elseif type(toclipboard) == "function" then toclipboard(text) end
        end)
        SH.dbg(text)
    end)

    -- ───── อ่านหน้าจอ ─────
    -- ปุ่ม ROLL (ข้อความขึ้นต้นด้วย ROLL เช่น "ROLL (148)") จำตำแหน่งไว้ ไม่ค้นทั้งหน้าจอทุกรอบ
    local rollObj, rollScanAt = nil, 0
    local function FindRoll()
        if rollObj and rollObj.Parent and IsShown(rollObj) then return rollObj end
        rollObj = nil
        if os.clock() - rollScanAt < 1 then return nil end
        rollScanAt = os.clock()
        local n = 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if IsTextObj(d) and TextOf(d):match("^ROLL") and IsShown(d) then
                rollObj = d
                return d
            end
        end
        return nil
    end

    local function RollCount(obj)
        return tonumber(TextOf(obj):match("%((%d+)%)"))
    end

    -- Family ปัจจุบัน: ข้อความรูปแบบ "PIKALE (Common)" -> ชื่อ, ความหายาก (ตัวพิมพ์ใหญ่)
    local famObj, famScanAt = nil, 0
    local function ParseFamily(o)
        local name, rarity = TextOf(o):match("^(.-)%s*%((%a+)%)$")
        if name and RANK[rarity] then return name, rarity end
        return nil
    end
    local function ReadFamily()
        if famObj and famObj.Parent and IsShown(famObj) then
            local n, r = ParseFamily(famObj)
            if n then return n, r end
        end
        famObj = nil
        if os.clock() - famScanAt < 0.4 then return nil end
        famScanAt = os.clock()
        local n = 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if IsTextObj(d) and IsShown(d) then
                local name, rarity = ParseFamily(d)
                if name then
                    famObj = d
                    return name, rarity
                end
            end
        end
        return nil
    end

    -- รอจน Family ที่แสดงเปลี่ยนเป็นตัวใหม่ และค่านิ่งอยู่ >= 0.3 วิ (กันอ่านกลางแอนิเมชันสปิน) คืน true ถ้าได้ผลใหม่
    -- ผลซ้ำตัวเดิมจะไม่เปลี่ยนค่า ก็จะรอจนครบ maxWait แล้วไปต่อ (รอบถัดไปอ่านค่าใหม่ก่อนตัดสินใจเสมอ)
    local function WaitForNewFamily(nameBefore, rarityBefore, maxWait)
        local t0 = os.clock()
        local seenKey, seenAt = nil, 0
        while os.clock() - t0 < maxWait do
            if not Alive() or not Cfg.AutoSpin then return false end
            local n, r = ReadFamily()
            if n and (n ~= nameBefore or r ~= rarityBefore) then
                local key = n .. "|" .. r
                if key ~= seenKey then
                    seenKey, seenAt = key, os.clock()
                elseif os.clock() - seenAt >= 0.3 then
                    return true
                end
            else
                seenKey = nil
            end
            task.wait(0.05)
        end
        return false
    end

    -- ───── Last Roll แบบเรียลไทม์ ─────
    -- โชว์ Family ที่ใส่อยู่ตอนนี้ทันที และอัปเดตทุกครั้งที่ผลบนหน้าจอเปลี่ยน (ไม่ต้องเปิด Auto Spin / ไม่ต้องรอดีเลย์)
    -- อ่านได้เฉพาะตอนเปิดหน้า Family อยู่ (ป้ายชื่ออยู่ในหน้านั้น)
    task.spawn(function()
        local lastKey, scanAt, hinted = nil, 0, false
        while Alive() do
            task.wait(0.15)
            local n, r
            if famObj and famObj.Parent and IsShown(famObj) then
                n, r = ParseFamily(famObj)
            elseif IN_MENU and os.clock() - scanAt >= 3 then
                scanAt = os.clock() -- สแกนหาป้ายใหม่ทุก 3 วิเท่านั้น (สแกนหนัก) และเฉพาะตอนอยู่ล็อบบี้ ไม่หน่วงเกมตอนฟาร์ม
                n, r = ReadFamily()
            end
            if n then
                hinted = false
                local key = n .. "|" .. r
                if key ~= lastKey then
                    lastKey = key
                    pcall(function()
                        lastLabel.Text = Pretty(n) .. " (" .. Cap(r) .. ")"
                        lastStack.Subtitle = "Live - your current family | " .. SummaryText()
                    end)
                end
            elseif not hinted and lastKey == nil and #history == 0 then
                hinted = true
                pcall(function() lastStack.Subtitle = "Open the Family page to see your current family live." end)
            end
        end
    end)

    -- วิธีกดปุ่ม ROLL: ลองทีละวิธี วิธีแรกคือกรอบฟ้า + Enter (เหมือน Character Selection)
    -- ถ้ากดแล้วจำนวน ROLL ไม่ลด รอบถัดไปจะเปลี่ยนไปลองวิธีถัดไป วิธีไหนติดจะจำไว้ใช้ต่อ (วิธีที่ executor ไม่รองรับจะข้ามไปเอง)
    local pressPref = 1
    local PRESS_METHODS = {
        { name = "Enter", run = function(btn)
            pcall(function() GuiService.SelectedObject = btn end)
            task.wait(0.1)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end)
            return true
        end },
        { name = "Activated signal", run = function(btn)
            if type(firesignal) ~= "function" then return false end
            return (pcall(firesignal, btn.Activated))
        end },
        { name = "Click signal", run = function(btn)
            if type(firesignal) ~= "function" then return false end
            return (pcall(firesignal, btn.MouseButton1Click))
        end },
        { name = "Mouse click", run = function(btn)
            local gui = btn:FindFirstAncestorOfClass("ScreenGui")
            local inset = (gui and gui.IgnoreGuiInset) and Vector2.zero or GuiService:GetGuiInset()
            local pos = btn.AbsolutePosition + btn.AbsoluteSize / 2 + inset
            return (pcall(function()
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
            end))
        end },
        { name = "Gamepad A", run = function(btn)
            pcall(function() GuiService.SelectedObject = btn end)
            task.wait(0.1)
            return (pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.ButtonA, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.ButtonA, false, game)
            end))
        end },
    }

    -- กด ROLL 1 ครั้งด้วยวิธีที่ attempt-th (attempt = 0 ใช้วิธีที่จำไว้) คืน (เลขวิธี, ชื่อวิธี) หรือ nil ถ้าไม่มีวิธีที่ใช้ได้
    local function PressRoll(obj, attempt)
        local btn = ToButton(obj)
        if not btn then return nil end
        local count = #PRESS_METHODS
        for step = 0, count - 1 do
            local idx = ((pressPref - 1 + (attempt or 0) + step) % count) + 1
            local m = PRESS_METHODS[idx]
            if m.run(btn) then return idx, m.name end
        end
        return nil
    end

    -- รอจนจำนวน ROLL ลดลง (= เกมรับคำสั่งแล้ว) คืน true ถ้าลดลง
    -- หรือ Family ที่แสดงเปลี่ยนไปจากเดิม (ผลสปินออกแล้ว แม้ตัวเลขยังไม่อัปเดต)
    local function WaitCountDrop(obj, before, maxWait, nameBefore, rarityBefore)
        local t0 = os.clock()
        while os.clock() - t0 < maxWait do
            if not (obj.Parent) then return true end -- ปุ่มถูกสร้างใหม่ = หน้าอัปเดตแล้ว
            local now = RollCount(obj)
            if now ~= nil and now < before then return true end
            if nameBefore and famObj and famObj.Parent then
                local n, r = ParseFamily(famObj)
                if n and (n ~= nameBefore or r ~= rarityBefore) then return true end
            end
            task.wait(0.1)
        end
        return false
    end

    -- กดปุ่มใด ๆ ด้วยกรอบฟ้า + Enter
    local function PressButton(btn)
        pcall(function() GuiService.SelectedObject = btn end)
        task.wait(0.1)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end)
    end

    local function FindShownButton(match)
        local n = 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if d:IsA("GuiButton") and IsShown(d) and match(d) then return d end
        end
        return nil
    end

    -- เปิดหน้า Family เอง: (1) ถ้าอยู่หน้าแต่งตัวและเห็นปุ่มไอคอน F -> กดมัน (2) ถ้าอยู่เมนูหลัก -> กด CUSTOMIZATION
    -- กดห่างกันอย่างน้อย 2.5 วินาที และลองไม่เกิน 8 ครั้ง (ถ้าเปิดไม่ได้ จะบอกให้เปิดเอง ไม่วนกดไปเรื่อย ๆ)
    -- หาไอคอน F จาก "ตำแหน่งบนจอ" เมื่อหาจากชื่อไม่เจอ:
    -- หน้าแต่งตัวมีไอคอนกลมเรียงเป็นโค้งทางซ้าย (ประตู, ผม, หน้า, ไม้แขวนเสื้อ, F) ไอคอน F อยู่ล่างสุด
    -- เลือกปุ่มสี่เหลี่ยมจัตุรัสขนาด 40-220px ที่อยู่ซีกซ้ายของจอ ต้องเจออย่างน้อย 4 ปุ่ม (กันไปกดผิดที่) แล้วเอาปุ่มล่างสุด
    local function FindBottomIcon()
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local cands, n = {}, 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if d:IsA("GuiButton") and IsShown(d) then
                local s = d.AbsoluteSize
                if s.X >= 40 and s.X <= 220 and s.Y >= 40 and s.Y <= 220 and math.abs(s.X / s.Y - 1) <= 0.2 then
                    local c = d.AbsolutePosition + s / 2
                    if c.X < vp.X * 0.3 then cands[#cands + 1] = { btn = d, y = c.Y } end
                end
            end
        end
        if #cands < 4 then return nil end
        table.sort(cands, function(a, b) return a.y > b.y end)
        return cands[1].btn
    end

    -- หาตัวปุ่มที่กดได้ของข้อความหนึ่ง: (1) ตัวมันเองเป็นปุ่ม (2) ปุ่มที่ครอบอยู่ (3) ปุ่มโปร่งใสที่วางทับตำแหน่งข้อความ
    -- (ไม่ใช้ "ปุ่มแรกในกรอบเดียวกัน" เพราะเมนูหลักมีหลายปุ่มในกรอบเดียว จะไปกดผิดเป็น PLAY)
    local function ClickableFor(o)
        if o:IsA("GuiButton") then return o end
        local cur = o.Parent
        for _ = 1, 3 do
            if not cur or cur == PlayerGui then break end
            if cur:IsA("GuiButton") then return cur end
            cur = cur.Parent
        end
        local c = o.AbsolutePosition + o.AbsoluteSize / 2
        local best, bestArea = nil, math.huge
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            if d:IsA("GuiButton") and IsShown(d) then
                local pos, size = d.AbsolutePosition, d.AbsoluteSize
                if c.X >= pos.X and c.X <= pos.X + size.X and c.Y >= pos.Y and c.Y <= pos.Y + size.Y then
                    local area = size.X * size.Y
                    if area < bestArea then best, bestArea = d, area end
                end
            end
        end
        return best
    end

    -- ปุ่ม CUSTOMIZATION ที่เมนูหลัก: ต้องเห็น PLAY และ CODES อยู่ด้วย (ยืนยันว่าเป็นเมนูหลัก ไม่ใช่ป้ายหัวข้อ
    -- "CUSTOMIZATION" ของหน้าแต่งตัว ที่ไม่ใช่ปุ่มและมีปุ่มสีผิวอยู่ข้าง ๆ)
    local function FindMainMenuCustomize()
        local custObj, hasPlay, hasCodes = nil, false, false
        local n = 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if IsTextObj(d) and IsShown(d) then
                local t = TextOf(d)
                if t == "CUSTOMIZATION" then custObj = d
                elseif t == "PLAY" then hasPlay = true
                elseif t == "CODES" then hasCodes = true end
            end
        end
        if custObj and hasPlay and hasCodes then return ClickableFor(custObj) end
        return nil
    end

    local navAt, navTries = 0, 0
    local function OpenFamilyPage()
        if os.clock() - navAt < 2.5 then return end
        navAt = os.clock()
        if navTries >= 8 then
            Status("Couldn't open the Family page - open it once yourself")
            return
        end
        local famBtn = FindShownButton(function(d)
            if not d.Name:lower():find("family", 1, true) then return false end
            local t = d:IsA("TextButton") and TextOf(d) or ""
            return not t:find("X2", 1, true) and t ~= "BACK" -- ไม่ใช่ป้าย "X2 FAMILY" / ปุ่ม BACK
        end)
        if famBtn then
            navTries += 1
            Status("Opening the Family page...")
            PressButton(famBtn)
            return
        end
        local iconBtn = FindBottomIcon()
        if iconBtn then
            navTries += 1
            Status("Opening the Family page (F icon)...")
            PressButton(iconBtn)
            return
        end
        local custBtn = FindMainMenuCustomize()
        if custBtn then
            navTries += 1
            Status("Opening Customization...")
            PressButton(custBtn)
            return
        end
        Status("Open the Family page (menu buttons not found)")
    end

    -- ไว้หาชื่อปุ่มไอคอน F: รันตอนอยู่หน้าแต่งตัว _G.SmoothHubSpin.DumpButtons() (ก๊อปลงคลิปบอร์ด + เซฟไฟล์ SmoothHub_buttons.txt)
    SH.Spin = SH.Spin or {}
    function SH.Spin.DumpButtons()
        local lines = { "=== visible buttons (path | class | text | image) ===" }
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            if d:IsA("GuiButton") and IsShown(d) then
                local path = d:GetFullName():gsub("^Players%.[^%.]+%.PlayerGui%.", "")
                local t = d:IsA("TextButton") and (d.Text or "") or ""
                local img = d:IsA("ImageButton") and tostring(d.Image) or ""
                lines[#lines + 1] = path .. " | " .. d.ClassName .. " | " .. t .. " | " .. img
            end
        end
        local text = table.concat(lines, "\n")
        pcall(function()
            if type(setclipboard) == "function" then setclipboard(text) elseif type(toclipboard) == "function" then toclipboard(text) end
        end)
        pcall(function() if type(writefile) == "function" then writefile("SmoothHub_buttons.txt", text) end end)
        SH.dbg(text)
        return #lines - 1
    end

    local function Notify(text)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Smooth Hub - Auto Spin", Text = text, Duration = 8,
            })
        end)
    end

    -- ยิง Remote GET พร้อมกันค้าง (รอไม่เกิน 8 วินาที)
    local getRemote = nil
    local function InvokeGet(...)
        if not getRemote or not getRemote.Parent then getRemote = GetLobbyRemote() end
        if not getRemote then return false, "remote not found" end
        local remote, args = getRemote, table.pack(...)
        local done, ok, res = false, false, nil
        task.spawn(function()
            ok, res = pcall(function() return remote:InvokeServer(table.unpack(args, 1, args.n)) end)
            done = true
        end)
        local t0 = os.clock()
        while not done and os.clock() - t0 < 8 do task.wait(0.05) end
        if not done then return false, "timeout" end
        return ok, res
    end

    -- ฝาก Family ปัจจุบันลง Storage: GET:InvokeServer("Family", "Store")
    -- ยืนยันว่าสำเร็จจากหน้าจอ: ชื่อ/ความหายากของ Family ปัจจุบันต้องเปลี่ยนไป (หรืออ่านไม่ได้เพราะช่องว่าง)
    -- ถ้าไม่เปลี่ยน = ไม่แน่ใจว่าฝากได้ไหม -> คืน false (ผู้เรียกจะหยุดสปิน กันสปินทับของดี)
    local function StoreCurrent(name, rarity)
        Status(("Storing %s..."):format(Pretty(name)))
        local ok, res = InvokeGet("Family", "Store")
        SH.dbg("[SmoothHub] Auto Spin: Store ->", ok, res)
        if not ok then return false, tostring(res) end
        local t0 = os.clock()
        while os.clock() - t0 < 4 do
            task.wait(0.4)
            if not Alive() or not Cfg.AutoSpin then return false, "stopped" end
            local n2, r2 = ReadFamily()
            if n2 == nil or n2 ~= name or r2 ~= rarity then return true end
        end
        return false, "your family didn't change after Store"
    end

    -- กล่องถามในจอ: "ได้ Yeager (Legendary) จะเก็บไหม?" คืน "stop" | "store" | "roll" | nil (ปิดสปินระหว่างรอ / สร้างกล่องไม่ได้)
    -- ไม่ใส่วงเล็บ "(ชื่อ)" ในข้อความ กันตัวอ่านหน้าจอของ Auto Spin เข้าใจผิดว่าเป็น Family
    local function AskUser(name, rarity)
        local gui = Instance.new("ScreenGui")
        gui.Name = "SmoothHubSpinAsk"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 10000
        gui.IgnoreGuiInset = true
        local parented = false
        for _, getParent in ipairs({
            function() return type(gethui) == "function" and gethui() or nil end,
            function() return game:GetService("CoreGui") end,
            function() return PlayerGui end,
        }) do
            local okP, parent = pcall(getParent)
            if okP and parent and pcall(function() gui.Parent = parent end) and gui.Parent then
                parented = true
                break
            end
        end
        if not parented then gui:Destroy() return nil end

        local frame = Instance.new("Frame")
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.fromScale(0.5, 0.35)
        frame.Size = UDim2.fromOffset(400, 200)
        frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        frame.Parent = gui
        local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 12) corner.Parent = frame
        local stroke = Instance.new("UIStroke") stroke.Color = Color3.fromRGB(70, 70, 80) stroke.Thickness = 1 stroke.Parent = frame

        local function Label(text, y, h, size, color, bold)
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Position = UDim2.fromOffset(16, y)
            l.Size = UDim2.new(1, -32, 0, h)
            l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
            l.TextSize = size
            l.TextColor3 = color
            l.Text = text
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = frame
            return l
        end
        Label("You rolled a family", 14, 20, 14, Color3.fromRGB(160, 160, 170), false)
        Label(Pretty(name) .. "  -  " .. Cap(rarity), 36, 34, 24, Color3.fromRGB(255, 255, 255), true)
        Label("Do you want to keep it?", 76, 20, 14, Color3.fromRGB(200, 200, 210), false)

        local choice = nil
        local function Button(text, x, w, color, value)
            local b = Instance.new("TextButton")
            b.Position = UDim2.fromOffset(x, 118)
            b.Size = UDim2.fromOffset(w, 52)
            b.BackgroundColor3 = color
            b.AutoButtonColor = true
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.TextWrapped = true
            b.Text = text
            b.Parent = frame
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = b
            b.MouseButton1Click:Connect(function() choice = value end)
        end
        Button("Keep it and stop", 16, 116, Color3.fromRGB(46, 125, 80), "stop")
        Button("Store it and keep spinning", 142, 116, Color3.fromRGB(45, 95, 170), "store")
        Button("Discard and roll again", 268, 116, Color3.fromRGB(150, 60, 60), "roll")

        while choice == nil and Alive() and Cfg.AutoSpin do task.wait(0.1) end
        gui:Destroy()
        return choice
    end

    local function StopSpin(message)
        Cfg.AutoSpin = false
        Save()
        pcall(function() spinToggle.Value = false end)
        Status(message)
        SH.dbg("[SmoothHub] Auto Spin:", message)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Smooth Hub - Auto Spin", Text = message, Duration = 10,
            })
        end)
    end

    task.spawn(function()
        local fails = 0
        local pendingLog, startLogged = false, false
        local emptySlotOk, storesSinceRoll = false, 0
        while Alive() do
            task.wait(0.4)
            if not Cfg.AutoSpin then
                fails, pendingLog, startLogged, emptySlotOk, storesSinceRoll = 0, false, false, false, 0
                Status("Off")
            else
                local roll = FindRoll()
                if not roll then
                    OpenFamilyPage()
                else
                    navTries = 0
                    local rolls = RollCount(roll)
                    local name, rarity = ReadFamily()
                    if name then
                        if not startLogged then
                            startLogged = true
                            LogResult(name, rarity, true)
                        elseif pendingLog then
                            pendingLog = false
                            LogResult(name, rarity, false)
                        end
                    end

                    local canRoll = false
                    if not name then
                        if emptySlotOk then
                            canRoll = true -- เพิ่งฝาก Family ลง Storage ช่องว่าง ไม่มีของให้สปินทับ
                        else
                            Status("Can't read your current family yet...")
                        end
                    else
                        emptySlotOk = false
                        local label = ("%s (%s)"):format(Pretty(name), Cap(rarity))
                        local action = Decide(name, rarity)
                        if action == "ask" then
                            Status("Waiting for your choice: " .. label)
                            Notify("You rolled " .. label .. " - keep it? Answer in the box on screen.")
                            local choice = AskUser(name, rarity)
                            action = choice or "wait" -- nil = ปิดสปินระหว่างรอ / สร้างกล่องไม่ได้
                            if choice == nil and Cfg.AutoSpin then
                                StopSpin("Stopped: couldn't show the question box, so you keep " .. label)
                                action = "wait"
                            end
                        end
                        if action == "stop" then
                            StopSpin("Stopped: you have " .. label)
                        elseif action == "store" then
                            if storesSinceRoll >= 2 then
                                StopSpin("Stopped: Store doesn't clear your family slot, so you keep " .. label)
                            else
                                local ok, why = StoreCurrent(name, rarity)
                                if ok then
                                    storesSinceRoll += 1
                                    emptySlotOk = true
                                    SH.dbg("[SmoothHub] Auto Spin: stored " .. label)
                                    Notify("Stored " .. label)
                                elseif why ~= "stopped" then
                                    StopSpin(("Stopped: couldn't store %s (%s)"):format(label, why))
                                end
                            end
                        elseif action == "roll" then
                            canRoll = true
                        end
                    end

                    if canRoll then
                        if rolls ~= nil and rolls <= 0 then
                            StopSpin("Stopped: no rolls left")
                        else
                            Status(("Rolling... (%s left)"):format(rolls ~= nil and tostring(rolls) or "?"))
                            local before = rolls
                            local idx, used = PressRoll(roll, fails)
                            local registered = true
                            if idx == nil then
                                registered, used = false, "no usable press method"
                            elseif before ~= nil then
                                registered = WaitCountDrop(roll, before, 4, name, rarity)
                            end
                            if not registered then
                                fails += 1
                                SH.dbg(("[SmoothHub] Auto Spin: roll didn't register (%d/%d) via %s"):format(fails, #PRESS_METHODS, tostring(used)))
                                Status(("Roll didn't register (%d/%d) via %s"):format(fails, #PRESS_METHODS, tostring(used)))
                                if fails >= #PRESS_METHODS then StopSpin("Stopped: ROLL button doesn't respond (tried every press method)") end
                            else
                                if idx then pressPref = idx end
                                fails = 0
                                pendingLog = true
                                emptySlotOk, storesSinceRoll = false, 0
                                -- รอให้ผลออกครบ แล้วรอบถัดไปอ่าน Family ใหม่ก่อนตัดสินใจ (อ่านไม่ได้ = ไม่สปินต่อ)
                                if Cfg.SpinUseDelay ~= false then
                                    for _ = 1, math.floor(Cfg.SpinDelay * 10) do
                                        if not Alive() or not Cfg.AutoSpin then break end
                                        task.wait(0.1)
                                    end
                                else
                                    -- ไม่ใช้ดีเลย์: รอจนผลใหม่ขึ้นหน้าจอและนิ่ง แล้วไปต่อทันที (สูงสุด 2.5 วิ)
                                    WaitForNewFamily(name, rarity, 2.5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

---------------------------------------------------------
-- 📊 Account Overview (เช็คสถานะบัญชี)
---------------------------------------------------------
local ReplicatedStorageSvc = game:GetService("ReplicatedStorage")

local StatusCategory = Cascade.Components.Section(Window, {
    Title = "Status",
    Disclosure = false
})
local AccountTab = StatusCategory:Tab({
    Title = "Account",
    Icon = Icon("bookmarkFill", "bookmark"),
    Selected = true -- เปิดหน้า Account Overview เป็นหน้าแรกตอนรันสคริปต์
})
local OverviewTab = AccountTab -- ใส่ Overview ในแท็บ Account ของหมวด Status
local OverviewSection = OverviewTab:PageSection({
    Title = "📊 Account Overview",
    Subtitle = "Read from your player data. N/A = this value was not found."
})
local OverviewForm = OverviewSection:Form()

-- หา Instance ใน PlayerGui ตาม path เช่น "Interface.Topbar.Main.Currencies.Gold.Amount"
local function FindGui(path)
    local cur = PlayerGui
    for seg in path:gmatch("[^%.]+") do
        cur = cur and cur:FindFirstChild(seg)
        if not cur then return nil end
    end
    return cur
end

-- รวมจำนวนไอเทมที่ชื่อมีคำว่า "Shard" ในหน้า Inventory (เช่น "400 - Female Shard" ช่อง Quantity)
-- ถ้ายังไม่มี Inventory ใน GUI (ยังไม่เคยเปิดหน้านั้น) จะคืน nil = N/A
local function CountShards()
    local items = FindGui("Interface.Inventory.Main.Holder.Items")
    if not items then return nil end
    local total = 0
    for _, c in ipairs(items:GetChildren()) do
        if c.Name:lower():find("shard", 1, true) then
            local q = 1
            local label = c:FindFirstChild("Quantity", true)
            if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
                q = tonumber((label.Text:gsub("[^%d]", ""))) or 1
            end
            total += q
        end
    end
    return total
end

-- Family ที่ใส่อยู่ จากหน้า Inventory ใน GUI
-- รูปแบบชื่อไอเทมคือ "<id> - <ชื่อ>" เช่น "502 - Leonhart" / "802 - Bozado"
-- ไอเทมประเภท Family ลงท้าย id ด้วย 02 (ดูจากรายการที่มี: 502, 802) และตัวที่ใส่อยู่จะมีกรอบ Main.Equipped เปิดอยู่
local function CurrentFamily()
    local items = FindGui("Interface.Inventory.Main.Holder.Items")
    if not items then return nil end
    for _, c in ipairs(items:GetChildren()) do
        local id, name = c.Name:match("^(%d+)%s*%-%s*(.+)$")
        if id and tonumber(id) % 100 == 2 then
            local main = c:FindFirstChild("Main")
            local eq = main and main:FindFirstChild("Equipped")
            if eq and eq:IsA("GuiObject") and eq.Visible then
                local check = eq:FindFirstChild("Checkmark")
                local on = true
                if check and check:IsA("ImageLabel") and check.ImageTransparency >= 1 then on = false end
                if on then return name end
            end
        end
    end
    return "None"
end

-- ───────── ตรวจร่องรอย Shadow Ban (แบบอ่านอย่างเดียว ไม่ยิง Remote ไม่ส่งของ) ─────────
-- เกมไม่ได้บอกตรง ๆ ว่าโดน Shadow Ban จึงดูแค่ "ร่องรอย" 2 อย่าง:
--  1) Attribute Blacklisted / Exploiter บนตัวเรา
--  2) ป้ายข้อความ (แม้ซ่อนอยู่) ใน PlayerGui ที่มีคำว่า exploiter / shadow ban
local function AttrTrue(v)
    if type(v) == "boolean" then return v end
    if type(v) == "number" then return v ~= 0 end
    if type(v) == "string" then
        local x = v:lower()
        return x == "true" or x == "yes" or x == "1"
    end
    return false
end

local hiddenLabelCache, hiddenLabelAt = nil, 0
local function FindWarningLabel()
    if os.clock() - hiddenLabelAt < 15 then return hiddenLabelCache end
    hiddenLabelAt = os.clock()
    hiddenLabelCache = false
    local n = 0
    for _, d in ipairs(PlayerGui:GetDescendants()) do
        n += 1
        if n % 600 == 0 then task.wait() end
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local t = (d.Text or ""):lower()
            if t:find("exploiter", 1, true) or t:find("shadow ban", 1, true) or t:find("shadowban", 1, true) then
                hiddenLabelCache = d:GetFullName():gsub("^Players%.[^%.]+%.PlayerGui%.", "")
                break
            end
        end
    end
    return hiddenLabelCache
end

-- ✅ = พบร่องรอยว่าโดน Shadow Ban / ❌ = ยังไม่พบ
-- (ใช้ ✅ แทน ✔️ เพราะ ✔️ เป็นสัญลักษณ์ธรรมดา ฟอนต์ของ Roblox วาดเป็นสีเทาตามสีข้อความ)
local function ShadowStatus()
    if FindWarningLabel() then return "✅" end
    if AttrTrue(LocalPlayer:GetAttribute("Exploiter")) or AttrTrue(LocalPlayer:GetAttribute("Blacklisted")) then
        return "✅"
    end
    return "❌"
end

-- เทียบกับผู้เล่นคนอื่นในเซิร์ฟ: ถ้าทุกคนมีธงเหมือนกัน แปลว่าเป็นค่าปกติของเกม ไม่ได้หมายถึงเราโดนแบน
local function FlagCompare()
    local others, flagged = 0, 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            others += 1
            if AttrTrue(plr:GetAttribute("Exploiter")) or AttrTrue(plr:GetAttribute("Blacklisted")) then
                flagged += 1
            end
        end
    end
    local mine = (AttrTrue(LocalPlayer:GetAttribute("Exploiter")) or AttrTrue(LocalPlayer:GetAttribute("Blacklisted"))) and "flagged" or "clear"
    return ("You: %s | Others flagged: %d/%d"):format(mine, flagged, others)
end

-- aliases = ชื่อที่เป็นไปได้ของค่านี้ในเกม (เทียบแบบตัวพิมพ์เล็ก ไม่สนช่องว่าง/ขีด)
local FIELDS = {
    { key = "ShadowBan", title = "🛠️ Shadow Ban", raw = true, aliases = {}, calc = ShadowStatus,
      colors = { ["✅"] = Color3.fromRGB(80, 200, 120), ["❌"] = Color3.fromRGB(235, 87, 87) } },
    { key = "FlagCompare", title = "🔍 Flag Compare", raw = true, aliases = {}, calc = FlagCompare },
    { key = "Blacklisted", title = "🚫 Blacklisted", flag = true, aliases = { "blacklisted" } },
    { key = "Exploiter", title = "⚠️ Exploiter Flag", flag = true, aliases = { "exploiter" } },
    { key = "Level",     title = "▶️ Level",    aliases = { "level", "lvl", "playerlevel" } },
    { key = "XP",        title = "📈 XP",       aliases = {}, strip = "^XP:%s*",
      gui = "Interface.Gear_Up.XP.Percentage" },
    { key = "Prestige",  title = "🔺 Prestige", aliases = { "prestige", "prestigelevel" } },
    { key = "Gold",      title = "💰 Gold",     aliases = { "gold", "coins", "money" },
      gui = "Interface.Topbar.Main.Currencies.Gold.Amount" },
    { key = "Gems",      title = "💎 Gems",     aliases = { "gems", "gem" },
      gui = "Interface.Topbar.Main.Currencies.Gems.Amount" },
    { key = "Family",    title = "⚡ Family",   aliases = { "family", "familyname", "clan" }, calc = CurrentFamily },
    { key = "Title",     title = "🏷️ Title",    aliases = { "title" }, pretty = true },
    { key = "Shards",    title = "✨ Shards",   aliases = { "shards", "shard" }, calc = CountShards },
}

for _, f in ipairs(FIELDS) do
    local row = OverviewForm:Row()
    row:Left():TitleStack({ Title = f.title })
    f.label = row:Right():Label({ Text = "..." })
    f.last = nil
end

local function NormName(s)
    return (tostring(s):lower():gsub("[^%w]", ""))
end

local function Fmt(v)
    if type(v) == "number" then
        if v ~= math.floor(v) then return string.format("%.2f", v) end
        local s = tostring(math.floor(v))
        local neg = s:sub(1, 1) == "-"
        if neg then s = s:sub(2) end
        s = s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        return (neg and "-" or "") .. s
    end
    return tostring(v)
end

local function Truthy(v)
    if type(v) == "boolean" then return v end
    if type(v) == "number" then return v ~= 0 end
    if type(v) == "string" then
        local s = v:lower()
        return s == "true" or s == "yes" or s == "1"
    end
    return false
end

-- แหล่งข้อมูลผู้เล่น: ตัว Player เอง + โฟลเดอร์ใน ReplicatedStorage ที่ชื่อ = ชื่อ/ไอดีเรา
local dataRoots = { LocalPlayer }
local lastRootScan = 0
local function ScanRoots(force)
    if not force and os.clock() - lastRootScan < 15 then return end
    lastRootScan = os.clock()
    local roots = { LocalPlayer }
    local uid = tostring(LocalPlayer.UserId)
    local n = 0
    for _, d in ipairs(ReplicatedStorageSvc:GetDescendants()) do
        n += 1
        if n % 500 == 0 then task.wait() end
        if d.Name == LocalPlayer.Name or d.Name == uid then
            table.insert(roots, d)
        end
    end
    dataRoots = roots
end

local SKIP_NAMES = { PlayerGui = true, PlayerScripts = true }

local function CollectEntries()
    local entries = {}
    local function keep(v)
        local t = type(v)
        return t == "number" or t == "string" or t == "boolean"
    end
    local function walk(inst, depth)
        pcall(function()
            for k, v in pairs(inst:GetAttributes()) do
                if keep(v) then
                    entries[#entries + 1] = { name = k, value = v, path = inst:GetFullName() .. " @" .. k }
                end
            end
            if inst:IsA("ValueBase") then
                local ok, v = pcall(function() return inst.Value end)
                if ok and keep(v) then
                    entries[#entries + 1] = { name = inst.Name, value = v, path = inst:GetFullName() }
                end
            end
        end)
        if depth >= 6 then return end
        for _, c in ipairs(inst:GetChildren()) do
            if not SKIP_NAMES[c.Name] then walk(c, depth + 1) end
        end
    end
    for _, root in ipairs(dataRoots) do
        if root and root.Parent then walk(root, 0) end
    end
    return entries
end

-- ค่าใต้ Boosts / Gamepasses ไม่ใช่ค่าบัญชี (เช่น Boosts.Gold = เวลาบัฟ) ข้ามไป
local function IsExcludedPath(path)
    return path:find("%.Boosts") ~= nil or path:find("%.Gamepasses") ~= nil
end

local function LookupField(entries, field)
    for _, alias in ipairs(field.aliases) do
        for _, e in ipairs(entries) do
            if NormName(e.name) == alias and not IsExcludedPath(e.path) then
                return e.value
            end
        end
    end
    return nil
end

-- อ่านข้อความจาก PlayerGui ตาม path เช่น "Interface.Topbar.Main.Currencies.Gold.Amount"
local function ReadGui(path)
    local cur = FindGui(path)
    if cur and (cur:IsA("TextLabel") or cur:IsA("TextButton")) then
        local t = (cur.Text or ""):gsub("<[^>]->", "")
        t = t:gsub("^%s+", ""):gsub("%s+$", "")
        if t ~= "" then return t end
    end
    return nil
end

-- หา TextLabel จริงข้างใน Label ของไลบรารี เพื่อตั้งสีข้อความ
local function LabelObject(label)
    local inst = label and label.__instance
    if not inst then return nil end
    if inst:IsA("TextLabel") then return inst end
    return inst:FindFirstChildWhichIsA("TextLabel", true)
end

local lastEntries = {}
local function RefreshOverview()
    ScanRoots(false)
    local entries = CollectEntries()
    lastEntries = entries
    for _, f in ipairs(FIELDS) do
        -- ช่องที่มี gui = อ่านจากตัวเลขบนจอก่อน ถ้าไม่เจอค่อยหาจาก Attribute/Value
        local v
        if f.calc then
            local okC, r = pcall(f.calc)
            if okC then v = r end
        end
        if v == nil and f.gui then v = ReadGui(f.gui) end
        if v == nil then v = LookupField(entries, f) end
        local text
        if v == nil then
            text = "N/A"
        elseif f.raw then
            text = tostring(v)
        elseif f.flag then
            text = Truthy(v) and "⚠️ Yes" or "✅ No"
        elseif f.strip then
            text = (tostring(v):gsub(f.strip, ""))
        elseif f.pretty then
            text = (tostring(v):gsub("_", " "))
        else
            text = Fmt(v)
        end
        if text ~= f.last then
            f.last = text
            pcall(function() f.label.Text = text end)
            if f.colors and f.colors[text] then
                pcall(function()
                    local obj = LabelObject(f.label)
                    if obj then obj.TextColor3 = f.colors[text] end
                end)
            end
        end
    end
end

task.spawn(function()
    while Alive() do
        pcall(RefreshOverview)
        for _ = 1, 12 do
            if not Alive() then return end
            task.wait(0.25)
        end
    end
end)

---------------------------------------------------------
-- ลูปทำงานเบื้องหลัง
---------------------------------------------------------
-- Auto Select: เจอหน้าเลือกตัวละครเมื่อไหร่ กดช่องที่เลือก (เว้น 4 วิกันกดรัว)
task.spawn(function()
    while Alive() do
        if IN_MENU and Cfg.AutoSelect and not selecting then
            if SelectCharacter() then
                for _ = 1, 16 do
                    if not Alive() then return end
                    task.wait(0.25)
                end
            end
        end
        task.wait(1)
    end
end)

-- Auto Join: ยิงทุก JoinDelay วินาที (บังคับ 5-60 ทุกรอบ) และแสดงเวลาที่เหลือ
-- นับจากเวลาที่ยิงจริง ปรับสไลเดอร์ระหว่างรอได้ทันที
-- ถ้าเปิด Auto Select อยู่และหน้าเลือกตัวละครยังโชว์ จะรอก่อน ไม่ยิง
task.spawn(function()
    local lastFire = nil
    local slotVisible, slotCheckAt = false, 0
    while Alive() do
        if not IN_MENU then
            lastFire = nil
            SetCountdown("N/A")
        elseif not Cfg.AutoJoin then
            lastFire = nil
            SetCountdown("Off")
        else
            local now = os.clock()
            if Cfg.AutoSelect then
                if now >= slotCheckAt then
                    slotVisible = SlotScreenVisible()
                    slotCheckAt = now + 1
                end
            else
                slotVisible = false
            end

            if slotVisible then
                lastFire = nil
                SetCountdown("Waiting for character select")
            else
                local delay = ClampDelay(Cfg.JoinDelay)
                -- เริ่มนับใหม่ทุกครั้ง (เพิ่งเปิดสวิตช์ / หน้าเลือกตัวละครเพิ่งหายไป) = รอให้ครบ Delay ก่อนค่อยยิง
                if not lastFire then lastFire = now end
                local remaining = lastFire + delay - now
                if remaining <= 0 then
                    SetCountdown("Joining now...")
                    lastFire = os.clock()
                    JoinLobby()
                else
                    SetCountdown(("Next join in %ds"):format(math.ceil(remaining)))
                end
            end
        end
        task.wait(0.25)
    end
end)

---------------------------------------------------------
-- In-Game (ไว้ใส่ภายหลัง)
---------------------------------------------------------
local MainCategory = Cascade.Components.Section(Window, {
    Title = "In-Game",
    Disclosure = false
})
local FarmTab = MainCategory:Tab({
    Title = "Auto Farm",
    Icon = Icon("boltFill"),
})

---------------------------------------------------------
-- 🌾 Auto Farm : ฟังก์ชันเปล่า (ใส่คำสั่งภายหลัง)
-- ทุกสวิตช์ / สไลเดอร์ / ปุ่ม จะเรียกฟังก์ชันใน Farm.* ด้านล่างเมื่อค่าเปลี่ยน
--   • สวิตช์   -> Farm.OnXxx(on)        on = true/false
--   • สไลเดอร์ -> Farm.OnXxx(value)     value = ตัวเลข (ปัดเป็นจำนวนเต็มแล้ว)
--   • ปุ่ม Refresh -> Farm.RefreshStreak() / Farm.RefreshRetry()
-- ค่าปัจจุบันอ่านได้จาก Cfg.AutoFarm, Cfg.SafeTime ฯลฯ (เซฟ/โหลด/Reset ให้อัตโนมัติ)
-- อัปเดตตัวเลขบนหน้าจอด้วย Farm.SetStreak(n) / Farm.SetRetry(n)
---------------------------------------------------------
local Farm = {}
SH.Farm = Farm

-- ───── Main ─────
-- Farm.OnAutoFarm(on)                         -- Auto Farm [ Blades ]: ทำจริงแล้ว ดูส่วน "⚔️ Auto Farm [ Blades ]" ด้านล่าง
-- Farm.OnAutoFarmThunder(on)                  -- Auto Farm [ Thunder Spears ]: ทำจริงแล้ว ดูส่วน "⚔️ Auto Farm [ Blades ]" ด้านล่าง (ใช้ลูปบินร่วมกับ Blades)
-- Farm.OnAutoReload(on)                       -- Auto Reload: ทำจริงแล้ว ดูส่วน "🔪 Auto Reload" ด้านล่าง
-- Farm.OnAutoRefillsBlade(on)                 -- Auto Refills [ Blade ]: ทำจริงแล้ว ดูส่วน "⛽ Auto Refills" ด้านล่าง
-- Farm.OnAutoRefillsThunder(on)               -- Auto Refills [ Thunder Spears ]: ทำจริงแล้ว ดูส่วน "⛽ Auto Refills" ด้านล่าง
-- Farm.OnDamageMultiplier(on)                 -- Damage Multiplier (x30): ทำจริงแล้ว ดู DAMAGE_MULT ในส่วน "⚔️ Auto Farm [ Blades ]" (อ่านค่า Cfg.DamageMultiplier ตอนยิง)
-- Farm.OnSafeTime(seconds)                    -- Safe Time: ทำจริงแล้ว ดู Farm.ApplySafeTime ด้านล่าง (อ่านค่าจาก Cfg.SafeTime ตอนทำงาน)
-- Farm.OnFailSafeAt / OnAutoFailSafe / RefreshStreak: ทำจริงแล้ว ดูส่วน "🛟 Fail Safe" ด้านล่าง (อ่านค่าจาก Cfg ตอนทำงาน)

-- ───── Game Options ─────
-- Farm.OnAutoRetry(on) / Farm.RefreshRetry()    -- Auto Retry: ทำจริงแล้ว ดูส่วน "🔁 Auto Retry" ด้านล่าง
-- Farm.OnAutoLeave(on)                          -- Auto Leave: ทำจริงแล้ว ดูส่วน "🔁 Auto Retry / Leave" ด้านล่าง
function Farm.OnRetryAmount(amount) end          -- Retry Amount
-- Farm.OnAutoLeaveWhenRetryComplete(on)         -- Auto Leave After X Matches: ทำจริงแล้ว

-- เรียกฟังก์ชันแบบปลอดภัย (error ในฟังก์ชันของคุณจะไม่ทำให้หน้าต่าง UI พัง)
function Farm.Fire(name, ...)
    local fn = Farm[name]
    if type(fn) == "function" then
        local ok, err = pcall(fn, ...)
        if not ok then SH.dbg("[SmoothHub] Farm." .. tostring(name) .. ":", err) end
    end
end

do -- แท็บ Auto Farm (หมวด Main / After the Match / Safety)
    if Cfg.AutoLeave and Cfg.AutoLeaveWhenRetryComplete then Cfg.AutoLeave = false end
    -- ⚔️ Auto Farm: สร้างก่อนหมวดอื่น เพื่อให้อยู่บนสุดของแท็บ
    local MainForm = FarmTab:PageSection({
        Title = "⚔️ Auto Farm",
        Subtitle = "The essentials - turn these on and go",
    }):Form()
    local OptionsForm = FarmTab:PageSection({
        Title = "⚙️ After the Match",
        Subtitle = "What to do when a mission ends",
    }):Form()
    local function AddFarmToggle(form, title, subtitle, key, handler)
        local row = form:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        Farm.Toggles = Farm.Toggles or {}
        Farm.Toggles[key] = UiSync.Link(row:Right():Toggle({
            Value = Cfg[key],
            ValueChanged = function(self, value)
                Cfg[key] = value and true or false
                Save()
                Farm.Fire(handler, Cfg[key])
            end
        }), Cfg, key)
    end
    local function AddFarmSlider(form, titleFor, subtitle, key, handler)
        local range = FARM_RANGES[key]
        local row = form:Row()
        local stack = row:Left():TitleStack({ Title = titleFor(Cfg[key]), Subtitle = subtitle })
        UiSync.Link(row:Right():Slider({
            Minimum = range[1],
            Maximum = range[2],
            Value = Cfg[key],
            ValueChanged = function(self, value)
                local v = math.clamp(math.floor(value + 0.5), range[1], range[2])
                Cfg[key] = v
                pcall(function() stack.Title = titleFor(v) end)
                Save()
                Farm.Fire(handler, v)
            end
        }), Cfg, key, function(_, want)
            pcall(function() stack.Title = titleFor(want) end)
        end)
    end
    local function AddCounterRow(form, titleFor, refreshHandler)
        local row = form:Row()
        local stack = row:Left():TitleStack({ Title = titleFor(0) })
        local run
        local btn = row:Right():Button({
            Label = "Refresh",
            Callback = function() if run then run() end end
        })
        run = BindButton(btn, function() Farm.Fire(refreshHandler) end)
        return function(n)
            pcall(function() stack.Title = titleFor(n) end)
        end
    end

    AddFarmToggle(MainForm, "Auto Farm [ Blades ]", "Automatically completes missions with Blades.", "AutoFarm", "OnAutoFarm")
    AddFarmToggle(MainForm, "Auto Farm [ Thunder Spears ]", "Automatically completes missions with Thunder Spears.", "AutoFarmThunder", "OnAutoFarmThunder")
    AddFarmToggle(MainForm, "Auto Reload", "Automatically reloads your blades when depleted.", "AutoReload", "OnAutoReload")
    AddFarmToggle(MainForm, "Auto Refills [ Blade ]", "Refills at the station when your blades are out and no spare blades are left.", "AutoRefillsBlade", "OnAutoRefillsBlade")
    AddFarmToggle(MainForm, "Auto Refills [ Thunder Spears ]", "Refills at the station when your Thunder Spears run out.", "AutoRefillsThunder", "OnAutoRefillsThunder")
    AddFarmToggle(MainForm, "Damage Multiplier ( x30 )", "Attacking Titan with 30 times the damage carries", "DamageMultiplier", "OnDamageMultiplier")
    -- 📱 Set Start Farm: รอก่อนเริ่มฟาร์มทุกครั้งที่ตัวละครเกิดใหม่ (เข้าด่านใหม่ / รีสปอน / เพิ่งรันสคริปต์)
    -- ให้เครื่องที่ไม่แรง (มือถือ) มีเวลาโหลดแมพ/ไททันก่อน แล้วค่อยบินไปฟัน (ใช้ค่า Cfg.StartDelay ตัวเดียวกับระบบเดิม)
    AddFarmSlider(MainForm, function(v) return "Set Start Farm ( " .. v .. "s )" end,
        "Wait this long after the character spawns before farming, so slower devices (mobile) can finish loading. 0 = start right away.", "StartDelay", "OnStartDelay")

    AddFarmToggle(OptionsForm, "Auto Retry", "Automatically Retry when completed.", "AutoRetry", "OnAutoRetry")
    AddFarmToggle(OptionsForm, "Auto Leave", "Leave to the lobby right when the match ends.", "AutoLeave", "OnAutoLeave")
    AddFarmToggle(OptionsForm, "Auto Leave After X Matches",
        "Retry up to the Retry Amount, then leave (needs Auto Retry). Not together with Auto Leave.",
        "AutoLeaveWhenRetryComplete", "OnAutoLeaveWhenRetryComplete")
    AddFarmSlider(OptionsForm, function(v) return "Retry Amount ( " .. v .. " )" end,
        "Matches to retry before leaving (used by Auto Leave After X Matches).", "RetryAmount", "OnRetryAmount")
    Farm.SetRetry = AddCounterRow(OptionsForm, function(n) return "Current Retry ( " .. tostring(n) .. " )" end, "RefreshRetry")

    -- 🛟 Safety: หน้าตาเหมือนเดิม แต่ตอนนี้ยังไม่มีโค้ดทำงาน (ต้องรอระบบ Auto Farm ใหม่) ค่าที่ตั้งจะถูกเซฟไว้ให้
    local SafetyForm = FarmTab:PageSection({
        Title = "🛟 Safety",
        Subtitle = "Keep missions from finishing too fast and break long win streaks",
    }):Form()
    AddFarmSlider(SafetyForm, function(v) return "Safe Time ( " .. v .. "s )" end,
        "A mission can't finish sooner than this. 0 = off.", "SafeTime", "OnSafeTime")
    AddFarmSlider(SafetyForm, function(v) return "Fail Safe At [ " .. v .. " ]" end,
        "Lose on purpose after this many wins in a row. 0 = never.", "FailSafeAt", "OnFailSafeAt")
    Farm.SetStreak = AddCounterRow(SafetyForm, function(n) return "Current Streak ( " .. tostring(n) .. " )" end, "RefreshStreak")
    function Farm.RefreshStreak()
        if Farm.SetStreak then Farm.SetStreak(Cfg.Streak) end
    end
    task.defer(Farm.RefreshStreak)
    AddFarmToggle(SafetyForm, "Auto Fail Safe", "When the streak is reached, fly to a titan and let it kill you.", "AutoFailSafe", "OnAutoFailSafe")
end
---------------------------------------------------------
-- ใช้ร่วมกับ Colossal Auto Cannon / Delete Map / Auto Retry (โค้ด Auto Farm ถูกลบออกหมดแล้ว เหลือแค่ 2 อย่างนี้)
---------------------------------------------------------
Farm.Debug = false -- true = พิมพ์ผล Retry / Leave ใน console (เฉพาะ DEV)
function Farm.CanUseHere()
    return not IN_MENU and game.PlaceId ~= 14916516914
end

---------------------------------------------------------
-- ⚔️ Auto Farm [ Blades ]
-- Remote (จาก Cobalt) ทั้งหมดผ่าน ReplicatedStorage.Assets.Remotes.POST:FireServer(...)
--   1) ("Attacks", "Slash", true)                                     = เริ่มฟัน
--   2) ("Hitboxes", "Register", <ชิ้นส่วนไททัน>, <ตัวเลข A>, <ตัวเลข B>)   = ลงดาเมจที่ชิ้นส่วนนั้น
--   3) ("Attacks", "Slash", false)                                    = จบการฟัน
-- ไททันอยู่ที่ workspace.Titans[<GUID>] ชิ้นส่วนอยู่ที่ .Hitboxes.Hit.{Nape, Eyes, LeftArm, RightArm, LeftLeg, RightLeg}
-- ตัวเลข A/B ในล็อกเปลี่ยนทุกครั้ง (A = 143~298, B = 0.26~0.51) ยังไม่รู้ความหมายแน่ชัด จึงสุ่มในช่วงเดียวกับล็อก
-- หอกสายฟ้า (Auto Farm [ Thunder Spears ]) ใช้ลูปบินเดียวกัน ต่างกันที่การยิง:
--   1) GET:InvokeServer("Spears", "S_Fire", "<จำนวนหอกที่เหลือ เช่น 8,7,6>")   = ยิงหอก
--   2) POST:FireServer("Spears", "S_Explode", <Vector3 จุดระเบิด>, <ตัวเลข 0.10~0.19>)  = หอกระเบิดที่ตำแหน่งนั้น
-- ค่าที่ใช้ปรับ (มีอยู่ใน Cfg แล้ว): FlySpeed, FlyHeight, NoClip, HitAllParts, PartCooldown, AttackSpeed, StartDelay
---------------------------------------------------------
do
    local RunService = game:GetService("RunService")
    local ATTACK_GAP = { [0] = 0.4, [1] = 0.8, [2] = 0.3, [3] = 0.2, [4] = 0.12, [5] = 0.08 } -- Attack Speed: 0=Auto 1=Safe 2=Fast 3=Turbo 4=Max
    local OTHER_PARTS = { "Eyes", "LeftArm", "RightArm", "LeftLeg", "RightLeg" }
    local ARRIVE_DIST = 12 -- เข้าใกล้จุดลอยเท่านี้ถึงเริ่มฟัน (ใช้เป็นสถานะ "Attacking" และตอนวนรอบหัว)
    local ATTACK_BEFORE_ARRIVE = true -- true = เริ่มฟัน/ยิงหอกทันทีที่มีเป้าหมาย ไม่ต้องรอบินไปถึงหัวไททันก่อน | false = รอถึงหัวก่อนเหมือนเดิม
    local ORBIT_ON = true      -- วนรอบหัวไททันตอนฟัน (ไม่ลอยนิ่ง) false = ลอยนิ่งเหมือนเดิม
    local ORBIT_RADIUS = 14    -- รัศมีวงที่วนรอบ Nape (studs) ยิ่งน้อยยิ่งอยู่ใกล้หัว
    local ORBIT_SPEED = 1.6    -- ความเร็วในการวน (เรเดียนต่อวินาที) 1.6 = ประมาณ 4 วินาทีต่อรอบ
    local ORBIT_BOB = 5        -- ลอยขึ้นลงเบาๆ (studs) 0 = ไม่ขึ้นลง
    local HIT_COUNT = 9    -- ฟันกี่ตัวพร้อมกันต่อ 1 ครั้ง (เกมฆ่าได้สูงสุด 9 ตัวต่อฟัน) 1 = ฟันตัวเดียว
    -- Damage Multiplier (x30): ตอนเปิดสวิตช์ ส่ง Register / S_Explode ซ้ำ DAMAGE_MULT ครั้งต่อ 1 การโจมตี "ของไททันทุกตัวที่ฟันพร้อมกัน (HIT_COUNT ตัว)"
    -- เป้าหลักที่เรายืนอยู่บนหัวได้ x30 ตัวอื่นได้ OTHER_MULT (ยิง Remote = DAMAGE_MULT + (HIT_COUNT-1) x OTHER_MULT ครั้งต่อฟัน)
    local DAMAGE_MULT = 30       -- ตัวคูณของไททันที่เรายืนอยู่บนหัว (เป้าหลัก) ได้เต็มที่สุด
    local OTHER_MULT = 10        -- ตัวคูณของไททันตัวอื่นที่ฟันพ่วง (น้อยกว่าเป้าหลัก ลดจำนวน Remote ด้วย)
    local RAID_SMALL = 3         -- ตอนมีบอส 60 เมตร: แบ่งไปฟันไททันเล็กแค่กี่ตัว (รวมตัวที่เรายืนอยู่เหนือหัว) ที่เหลือทุ่มให้บอส
    local BOSS_ALWAYS = true     -- Raid Colossal: ไททัน 60 เมตร (Colossal_Titan) ถูกรวมในชุดที่ฟันเสมอ และได้ตัวคูณเต็ม (DAMAGE_MULT) ส่วนไททันเล็กได้ OTHER_MULT
    local PRIORITY = {}          -- [ชิ้นส่วน Nape] = true ถ้าได้ตัวคูณเต็ม (เป้าหลัก + บอส) ตั้งใหม่ทุกครั้งใน NapesAround
    local BOSS_NORMAL_HP = 0.20  -- ตอนมีบอส: เลือดบอสเหลือเท่านี้หรือน้อยกว่า (0.20 = 20%) ปิดตัวคูณทั้งหมดให้ฟันปกติ
    local BOSS_SMALL_MULT = 1    -- ตอนมีบอส (เลือดเกิน BOSS_NORMAL_HP): ไททันเล็กได้ตัวคูณเท่านี้ 1 = ปกติ (x30 ทุ่มให้บอสอย่างเดียว)
    local MultState = { full = DAMAGE_MULT, other = OTHER_MULT } -- NapesAround ตั้งค่าใหม่ทุกครั้งที่ฟัน
    local function Mult() return Cfg.DamageMultiplier and MultState.full or 1 end
    local function OtherMult() return Cfg.DamageMultiplier and math.min(MultState.other, MultState.full) or 1 end

    local B = { Target = nil, Hits = 0, Status = "Idle" }
    Farm.Blades = B

    local post = nil
    local function Post()
        if not post or not post.Parent then
            local ok, r = pcall(function()
                return game:GetService("ReplicatedStorage").Assets.Remotes:WaitForChild("POST", 5)
            end)
            post = ok and r or nil
        end
        return post
    end

    local function MyRoot()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if char and hum and root and hum.Health > 0 then return root, char end
        return nil
    end

    local function HitParts(titan)
        local hb = titan:FindFirstChild("Hitboxes")
        return hb and hb:FindFirstChild("Hit")
    end

    local function NapeOf(titan)
        local hit = HitParts(titan)
        local nape = hit and hit:FindFirstChild("Nape")
        if nape and nape:IsA("BasePart") then return nape end
        return nil
    end

    local function TitanAlive(titan)
        local hum = titan and titan.Parent and titan:FindFirstChildOfClass("Humanoid")
        return hum ~= nil and hum.Health > 0
    end

    -- 🛡️ Defend Eren (Raid Colossal) ───────────────────────────
    -- หา Eren ในแมพ (โมเดลที่ชื่อมีคำว่า "Eren" ไม่ใช่ผู้เล่น/ไททัน) แล้วนับไททันเล็กที่เข้าใกล้ Eren
    Farm.DefendErenActive = false
    function Farm.ErenRoot()
        local c = Farm.ErenCache
        if c and c.Parent then return c end
        Farm.ErenCache = nil
        Farm.ErenModel = nil
        if os.clock() < (Farm.ErenSearchAt or 0) then return nil end
        Farm.ErenSearchAt = os.clock() + 3 -- ไม่เจอ: ค้นใหม่ทุก 3 วินาที (กันหน่วง)
        local chars = workspace:FindFirstChild("Characters")
        local titans = workspace:FindFirstChild("Titans")
        local exact, loose = nil, nil
        for _, d in ipairs(workspace:GetDescendants()) do
            if d:IsA("Model") and not (chars and d:IsDescendantOf(chars)) and not (titans and d:IsDescendantOf(titans)) then
                local n = d.Name:lower()
                if n:find("eren", 1, true) then
                    if n == "eren" or n == "eren_yeager" or n == "eren yeager" or n == "erenyeager" then
                        exact = exact or d
                    else
                        loose = loose or d
                    end
                end
            end
        end
        local m = exact or loose
        if not m then return nil end
        local part = m.PrimaryPart or m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart", true)
        if not part then return nil end
        Farm.ErenCache = part
        Farm.ErenModel = m
        return part
    end

    -- คืน (จำนวนไททันเล็กที่อยู่ใกล้ Eren ภายในรัศมี, ชิ้นส่วนของ Eren) ไม่นับ Colossal_Titan
    function Farm.ErenThreats()
        local eren = Farm.ErenRoot()
        if not eren then return 0, nil end
        local folder = workspace:FindFirstChild("Titans")
        local radius = Cfg.DefendErenRadius or 400
        local n = 0
        for _, t in ipairs(folder and folder:GetChildren() or {}) do
            if t:IsA("Model") and t.Name ~= "Colossal_Titan" and TitanAlive(t) then
                local nape = NapeOf(t)
                if nape and (nape.Position - eren.Position).Magnitude <= radius then n = n + 1 end
            end
        end
        return n, eren
    end

    local function PickTitan(root)
        local folder = workspace:FindFirstChild("Titans")
        if not folder then return nil end
        -- โหมดป้องกัน Eren: เลือกไททันเล็กที่ใกล้ Eren ที่สุด (ภายในรัศมี) แทนตัวที่ใกล้เรา
        local erenPart = Farm.DefendErenActive and Farm.ErenRoot() or nil
        local radius = Cfg.DefendErenRadius or 400
        local best, bestDist = nil, math.huge
        for _, t in ipairs(folder:GetChildren()) do
            if t:IsA("Model") and TitanAlive(t) and not (erenPart and t.Name == "Colossal_Titan") then
                local nape = NapeOf(t)
                if nape then
                    local d
                    if erenPart then
                        d = (nape.Position - erenPart.Position).Magnitude
                        if d > radius then d = nil end
                    else
                        d = (nape.Position - root.Position).Magnitude
                    end
                    if d and d < bestDist then best, bestDist = t, d end
                end
            end
        end
        return best
    end

    local function Running()
        if not (Cfg.AutoFarm or Cfg.AutoFarmThunder) or not Farm.CanUseHere() then return false end
        if Farm.Refilling then return false end -- กำลังไปเติมที่สถานี Refill
        if Farm.PauseUntil and Farm.PauseUntil > os.clock() then return false end
        return true
    end

    -- ฟัน 1 ครั้ง = Slash true -> Register ชิ้นส่วน -> Slash false (ลำดับเดียวกับในล็อก Cobalt)
    local function Slash(parts)
        local remote = Post()
        if not remote then return false end
        if typeof(parts) == "Instance" then parts = { parts } end
        local ok = pcall(function()
            remote:FireServer("Attacks", "Slash", true)
            -- สลับยิงทีละรอบ: รอบละ 1 ครั้งต่อไททันทุกตัว (ไม่ยิงตัวแรกครบ 30 ก่อนแล้วค่อยตัวถัดไป)
            -- ทุกตัวจึงได้ดาเมจเท่ากัน แม้เซิร์ฟเวอร์ตัด Remote ที่ถี่เกินกลางชุด
            -- เป้าหลัก (ลำดับ 1 = ตัวที่เรายืนอยู่บนหัว) ยิงทุกรอบ ตัวอื่นยิงแค่ OTHER_MULT รอบแรก
            for r = 1, Mult() do
                for i, part in ipairs(parts) do
                    if PRIORITY[part] or r <= OtherMult() then
                        remote:FireServer("Hitboxes", "Register", part, 143 + math.random() * 10, 0.26 + math.random() * 0.25)
                    end
                end
            end
            remote:FireServer("Attacks", "Slash", false)
        end)
        if ok then B.Hits = B.Hits + #parts end
        return ok
    end

    -- Nape ของไททัน HIT_COUNT ตัวที่อยู่ใกล้เป้าหลักที่สุด (เป้าหลักมาก่อนเสมอ)
    local function NapesAround(main)
        local mainNape = NapeOf(main)
        if not mainNape then return {} end
        local folder = workspace:FindFirstChild("Titans")

        -- หาบอส 60 เมตร (Colossal_Titan) ที่ยังมีชีวิต
        local boss, bossNape = nil, nil
        if BOSS_ALWAYS and folder then
            local c = folder:FindFirstChild("Colossal_Titan")
            if c and c:IsA("Model") and TitanAlive(c) then
                bossNape = NapeOf(c)
                if bossNape then boss = c end
            end
        end

        -- ไททันเล็กรอบเป้าหลัก เรียงจากใกล้ไปไกล (ไม่รวมบอส)
        local others = {}
        for _, t in ipairs(folder and folder:GetChildren() or {}) do
            if t ~= main and t ~= boss and t:IsA("Model") and TitanAlive(t) then
                local n = NapeOf(t)
                if n then
                    others[#others + 1] = { part = n, d = (n.Position - mainNape.Position).Magnitude }
                end
            end
        end
        table.sort(others, function(a, b) return a.d < b.d end)

        local list = {}
        if boss then
            -- โหมดบอส: บอสมาก่อนเสมอ (ลำดับ 1 = ตัวคูณเต็ม) แล้วแบ่งไปฟันไททันเล็กแค่ RAID_SMALL ตัว
            -- ตัวที่เรายืนอยู่เหนือหัว (ถ้าไม่ใช่บอส) นับเป็นไททันเล็กตัวแรก ได้ตัวคูณแค่ OTHER_MULT
            PRIORITY = { [bossNape] = true }
            list[1] = bossNape
            -- x30 ใส่แค่บอส ไททันเล็กฟันปกติ พอเลือดบอสเหลือ BOSS_NORMAL_HP ปิดตัวคูณทั้งหมด
            local hum = boss:FindFirstChildOfClass("Humanoid")
            local ratio = hum and (hum.Health / math.max(hum.MaxHealth, 1)) or 1
            if ratio <= BOSS_NORMAL_HP then
                MultState.full, MultState.other = 1, 1
            else
                MultState.full, MultState.other = DAMAGE_MULT, BOSS_SMALL_MULT
            end
            local smallLeft = math.min(RAID_SMALL, HIT_COUNT - 1)
            if main ~= boss and smallLeft > 0 then
                list[#list + 1] = mainNape
                smallLeft = smallLeft - 1
            end
            for i = 1, math.min(smallLeft, #others) do
                list[#list + 1] = others[i].part
            end
        else
            -- ไม่มีบอส: เป้าหลักได้ตัวคูณเต็ม ตัวอื่น (ใกล้สุด HIT_COUNT - 1 ตัว) ได้ OTHER_MULT
            MultState.full, MultState.other = DAMAGE_MULT, OTHER_MULT
            PRIORITY = { [mainNape] = true }
            list[1] = mainNape
            for i = 1, math.min(HIT_COUNT - 1, #others) do
                list[#list + 1] = others[i].part
            end
        end
        return list
    end

    -- Blades กับ Thunder Spears เปิดพร้อมกันไม่ได้ (เปิดอันไหน อีกอันถูกปิดให้เอง)
    local function TurnOffOther(key)
        if Cfg[key] then
            Cfg[key] = false
            Save()
            local ctl = Farm.Toggles and Farm.Toggles[key]
            if ctl then pcall(function() ctl.Value = false end) end
        end
    end
    local function Stopped()
        if Cfg.AutoFarm or Cfg.AutoFarmThunder then return end
        B.Target = nil
        B.Status = "Idle"
        local root = MyRoot()
        if root then pcall(function() root.AssemblyLinearVelocity = Vector3.zero end) end
    end
    function Farm.OnAutoFarm(on)
        if on then TurnOffOther("AutoFarmThunder") end
        Stopped()
    end
    function Farm.OnAutoFarmThunder(on)
        if on then TurnOffOther("AutoFarm") end
        Stopped()
    end

    -- ยิงหอก: S_Fire (GET) แล้วรอแป๊บ -> S_Explode (POST) ที่ Nape ของไททันหลายตัวพร้อมกัน
    local getRemote = nil
    local function Get()
        if not getRemote or not getRemote.Parent then
            local ok, r = pcall(function()
                return game:GetService("ReplicatedStorage").Assets.Remotes:WaitForChild("GET", 5)
            end)
            getRemote = ok and r or nil
        end
        return getRemote
    end

    -- หอกสายฟ้า (จาก BladeDump):
    --   ตัวละครมี Attribute "Spears" = จำนวนหอกที่เหลือ (12 -> 0)
    --   หอกที่เห็นบนแขนคือ Rig_<ชื่อ>.RightLowerArm.Spears.<id> และ LeftLowerArm.Spears.<id> (id 1-8) ใบที่ใช้แล้วมี Attribute "Used"
    --   เลขที่ส่งไปกับ S_Fire = id ของหอกที่ยิง: ตอนหอก > 8 ใช้ 8 / 7 สลับ หลังจากนั้นใช้ id ที่ยังไม่ Used (ตามล็อก Cobalt และ BladeDump)
    local function SpearsLeft()
        local char = LocalPlayer.Character
        local n = char and char:GetAttribute("Spears")
        if type(n) == "number" then return n end
        return nil
    end
    Farm.SpearsLeft = SpearsLeft

    -- เซิร์ฟเวอร์จำ id ของหอกที่ยิงไปแล้ว (หลังหอก <= 8 ห้ามใช้ id ซ้ำ ไม่งั้นยิงไม่ออกแต่ตัวเลขหอกไม่ลด
    -- ทำให้เกมโชว์ว่ายังเหลือ 1-2 นัดทั้งที่หมดจริง) จึงต้องจำ id ที่ยิงไปเองด้วย
    local lastSide, lastCount = 8, nil
    local usedIds = {}
    local stuck, stuckCount = 0, nil -- ยิงแล้วจำนวนหอกไม่ลดติดกันกี่ครั้ง (ต้อง 4 ครั้งถึงถือว่าค้าง) / ตอนนั้นเหลือเท่าไร

    local function NextSpearId(count)
        if lastCount ~= nil and count ~= nil and count > lastCount then usedIds = {} end -- เติมหอกแล้ว เริ่ม id ใหม่
        lastCount = count
        if count == nil or count > 8 then
            usedIds = {}
            lastSide = (lastSide == 8) and 7 or 8
            return lastSide
        end
        local char = LocalPlayer.Character
        local rig = char and char:FindFirstChild("Rig_" .. LocalPlayer.Name)
        local gameUsed = {}
        for _, armName in ipairs({ "RightLowerArm", "LeftLowerArm" }) do
            local arm = rig and rig:FindFirstChild(armName)
            local folder = arm and arm:FindFirstChild("Spears")
            for _, d in ipairs(folder and folder:GetChildren() or {}) do
                if d.Name:match("^%d+$") and d:GetAttribute("Used") then gameUsed[tonumber(d.Name)] = true end
            end
        end
        local free = {}
        for id = 1, 8 do
            if not usedIds[id] and not gameUsed[id] then free[#free + 1] = id end
        end
        if #free == 0 then return nil end -- ไม่มี id ว่างเหลือ = หอกหมดจริง
        local pick = free[math.random(1, #free)]
        usedIds[pick] = true
        return pick
    end

    -- หอกค้าง: ยิงแล้วจำนวนไม่ลดติดกัน 3 ครั้ง (หรือไม่มี id ว่างเหลือ) และจำนวนยังเท่าตอนนั้น = หมดจริงแม้เกมโชว์ว่าเหลือ
    function Farm.SpearStuck()
        return stuck >= 4 and SpearsLeft() == stuckCount
    end

    local function Spear(parts)
        local get, remote = Get(), Post()
        if not get or not remote then return false end
        local left = SpearsLeft()
        if left ~= nil and left <= 0 then return false end -- หอกหมด ยิงไม่ได้
        -- จำนวนหอกเปลี่ยนไปจากตอนที่ค้างแล้ว = ไม่ค้างอีก (กันค้างถาวรเพราะจำนวนวนกลับมาเท่าเดิม)
        if stuck > 0 and left ~= stuckCount then stuck = 0 end
        if Farm.SpearStuck() then return false end         -- หอกค้าง รอเติม
        local id = NextSpearId(left)
        if id == nil then
            -- id ว่างหมดทั้งที่ตัวเลขหอกยังไม่ 0: ล้างความจำ id แล้วลองใหม่ ไม่ตัดสินว่าค้างทันที
            usedIds = {}
            stuck, stuckCount = stuck + 1, left
            return false
        end
        local done = false
        task.spawn(function()
            pcall(function() get:InvokeServer("Spears", "S_Fire", tostring(id)) end)
            done = true
        end)
        local t0 = os.clock()
        while not done and os.clock() - t0 < 1.5 do task.wait(0.03) end
        task.wait(0.35)
        local after = SpearsLeft()
        if left ~= nil and after ~= nil and after >= left then
            -- ยิงไม่ออก (จำนวนหอกไม่ลด) ไม่ต้องสั่งระเบิด และคืน id นี้ให้ใช้ใหม่ได้ (ไม่นับว่าใช้ไปแล้ว)
            usedIds[id] = nil
            stuck, stuckCount = stuck + 1, left
            if stuck == 4 then print("[SmoothHub][Thunder] S_Fire not accepted 4 times in a row, spears left =", tostring(left), "id =", tostring(id)) end
            return false
        end
        stuck = 0
        for r = 1, Mult() do
            for i, part in ipairs(parts) do
                if part and part.Parent and (PRIORITY[part] or r <= OtherMult()) then
                    pcall(function()
                        remote:FireServer("Spears", "S_Explode", part.Position, 0.10 + math.random() * 0.09)
                    end)
                end
            end
        end
        for _, part in ipairs(parts) do
            if part and part.Parent then B.Hits = B.Hits + 1 end
        end
        return true
    end

    local lastChar, readyAt = nil, 0

    -- 1) บินไปลอยเหนือ Nape ของไททัน (ขยับทีละก้าวตาม Fly Speed ไม่วาร์ปทีเดียว)
    task.spawn(function()
        local lastPick = 0
        local orbitAngle = 0
        while Alive() do
            local dt = RunService.Heartbeat:Wait()
            orbitAngle = (orbitAngle + ORBIT_SPEED * dt) % (math.pi * 2)
            local root, char = MyRoot()
            if char ~= lastChar then
                lastChar = char
                readyAt = os.clock() + (Cfg.StartDelay or 0)
            end
            if not Running() then
                B.Target = nil
                if Cfg.AutoFarm or Cfg.AutoFarmThunder then B.Status = "Paused" else B.Status = "Idle" end
            elseif not root then
                B.Target = nil
                B.Status = "Waiting for character"
            elseif os.clock() < readyAt then
                B.Status = "Start delay"
            else
                if B.Target and not TitanAlive(B.Target) then
                    B.Target = nil
                    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
                end
                if not B.Target and os.clock() - lastPick > 0.4 then
                    lastPick = os.clock()
                    B.Target = PickTitan(root)
                end
                local nape = B.Target and NapeOf(B.Target)
                if nape then
                    local offset = Vector3.new(0, math.max(Cfg.FlyHeight or 150, 0), 0)
                    if ORBIT_ON then
                        -- วนเป็นวงกลมรอบ Nape เหนือหัวไททัน + ลอยขึ้นลงเบาๆ (ทวีนต่อเนื่องไม่กระชาก)
                        offset = offset + Vector3.new(
                            math.cos(orbitAngle) * ORBIT_RADIUS,
                            math.sin(orbitAngle * 2) * ORBIT_BOB,
                            math.sin(orbitAngle) * ORBIT_RADIUS
                        )
                    end
                    local goal = nape.Position + offset
                    local diff = goal - root.Position
                    local dist = diff.Magnitude
                    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
                    if dist > 1 then
                        local step = math.min((Cfg.FlySpeed or 600) * dt, dist)
                        local newPos = root.Position + diff.Unit * step
                        if ORBIT_ON and dist <= ARRIVE_DIST then
                            -- หันหน้าเข้าหาไททันตอนวน (หันแนวนอนอย่างเดียว ตัวไม่เอียง)
                            root.CFrame = CFrame.lookAt(newPos, Vector3.new(nape.Position.X, newPos.Y, nape.Position.Z))
                        else
                            root.CFrame = CFrame.new(newPos)
                        end
                    end
                    B.Status = (dist <= ARRIVE_DIST) and "Attacking" or "Flying to titan"
                else
                    B.Target = nil
                    B.Status = "Searching for titans"
                end
            end
        end
    end)

    -- 2) ฟัน Nape ตามความเร็วที่เลือก (+ ชิ้นส่วนอื่นเมื่อเปิด Hit All Parts ตาม Part Cooldown)
    task.spawn(function()
        local partLast = {} -- [ชิ้นส่วน] = เวลาที่ยิงล่าสุด
        while Alive() do
            local gap = ATTACK_GAP[Cfg.AttackSpeed or 0] or 0.4
            task.wait(gap)
            local target = B.Target
            local root = MyRoot()
            if Cfg.AutoFarm and Running() and root and target and TitanAlive(target) and (B.Status == "Attacking" or (ATTACK_BEFORE_ARRIVE and B.Status == "Flying to titan")) then
                local nape = NapeOf(target)
                if nape then
                    Slash(NapesAround(target))
                    if Cfg.HitAllParts then
                        local hit = HitParts(target)
                        local cd = math.max(Cfg.PartCooldown or 7, 4)
                        for _, name in ipairs(OTHER_PARTS) do
                            local part = hit and hit:FindFirstChild(name)
                            if part and part:IsA("BasePart") and os.clock() - (partLast[part] or 0) >= cd then
                                partLast[part] = os.clock()
                                Slash(part)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- 2.5) ยิงหอกสายฟ้าใส่ Nape (ไททันใกล้เป้าหลัก HIT_COUNT ตัว) รอบละหนึ่งนัด ห่างกันอย่างน้อย 0.6 วินาที
    task.spawn(function()
        while Alive() do
            task.wait(math.max(ATTACK_GAP[Cfg.AttackSpeed or 0] or 0.4, 0.6))
            local target = B.Target
            local root = MyRoot()
            if Cfg.AutoFarmThunder and Running() and root and target and TitanAlive(target) and (B.Status == "Attacking" or (ATTACK_BEFORE_ARRIVE and B.Status == "Flying to titan")) then
                Spear(NapesAround(target))
            end
        end
    end)

    -- 3) No Clip ตอนฟาร์ม (ทะลุกำแพง/ไททัน)
    RunService.Stepped:Connect(function()
        if not Alive() or not Cfg.NoClip or not Running() then return end
        local _, char = MyRoot()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end)
end

---------------------------------------------------------
-- 🔪 Auto Reload
-- Remote (จาก Cobalt): ReplicatedStorage.Assets.Remotes.GET:InvokeServer("Blades", "Reload")
-- อ่านสถานะดาบจาก BladeDump:
--   Workspace.Characters.<ชื่อ>.Rig_<ชื่อ>.RightHand / LeftHand มีชิ้น Blade_1 .. Blade_7
--   ใบไหนหักจะมี Attribute "Broken" = true  (Blade_7 หักก่อน ... Blade_1 หักสุดท้าย)
--   หักครบทุกใบ = ดาบหมด -> เกมรีโหลดเองประมาณ 1 วินาทีหลังใบสุดท้ายหัก
-- สคริปต์จึงยิง Reload เฉพาะตอน "หักครบทุกใบ" และเกมยังไม่ได้รีโหลดเองภายใน RELOAD_WAIT วินาที
---------------------------------------------------------
do
    local RELOAD_WAIT = 1.5  -- ดาบหมดแล้วรอให้เกมรีโหลดเองก่อนเท่านี้ ถ้ายังไม่ได้ค่อยยิง
    local RELOAD_RETRY = 3   -- ยิงแล้วดาบยังหมดอยู่ ลองซ้ำได้อีกทุกกี่วินาที
    local remote = nil
    Farm.LastReload = nil

    local function BladeParts()
        local char = LocalPlayer.Character
        local rig = char and char:FindFirstChild("Rig_" .. LocalPlayer.Name)
        local list = {}
        for _, handName in ipairs({ "RightHand", "LeftHand" }) do
            local hand = rig and rig:FindFirstChild(handName)
            for _, d in ipairs(hand and hand:GetChildren() or {}) do
                if d.Name:match("^Blade_%d+$") then list[#list + 1] = d end
            end
        end
        return list
    end

    -- ดาบหมด = มีชิ้นดาบอยู่ และทุกชิ้นถูกมาร์ก Broken
    local function AllBroken()
        local parts = BladeParts()
        if #parts == 0 then return false end
        for _, p in ipairs(parts) do
            if not p:GetAttribute("Broken") then return false end
        end
        return true
    end
    Farm.BladesEmpty = AllBroken

    task.spawn(function()
        local brokenSince, lastFire = nil, 0
        while Alive() do
            task.wait(0.25)
            if Cfg.AutoReload and Farm.CanUseHere() and AllBroken() then
                brokenSince = brokenSince or os.clock()
                if os.clock() - brokenSince >= RELOAD_WAIT and os.clock() - lastFire >= RELOAD_RETRY then
                    lastFire = os.clock()
                    if not remote or not remote.Parent then
                        local ok, r = pcall(function()
                            return game:GetService("ReplicatedStorage").Assets.Remotes:WaitForChild("GET", 5)
                        end)
                        remote = ok and r or nil
                    end
                    if remote then
                        local ok, res = pcall(function() return remote:InvokeServer("Blades", "Reload") end)
                        Farm.LastReload = ok and res or ("error: " .. tostring(res))
                        if Farm.Debug then SH.dbg("[SmoothHub] Auto Reload ->", tostring(Farm.LastReload)) end
                    end
                end
            else
                brokenSince = nil
            end
        end
    end)
end

---------------------------------------------------------
-- ⛽ Auto Refills [ Blade ] / [ Thunder Spears ]
-- Remote (จากไฟล์ Remote Auto Refill): ReplicatedStorage.Assets.Remotes.POST:FireServer("Attacks", "Reload", <สถานี Refill>)
-- (ดาบกับหอกสายฟ้าใช้ Remote เดียวกัน เติมที่สถานี Refill เหมือนกัน เกมหักตัวเลข Attribute "Refills" ของผู้เล่นทีละ 1 ต่อครั้ง)
-- สถานี Refill อยู่ในแมพ (ชื่อ "Refill") แต่ละด่านอยู่คนละโฟลเดอร์ (ตาราง REFILL_PLACES) ไม่ใช้เลขลำดับ GetChildren()[N] เพราะเปลี่ยนได้
-- เงื่อนไข (อ่านจาก BladeDump):
--   [ Blade ]          1) ดาบหักครบทุกใบ (Farm.BladesEmpty)  และ
--                      2) ชุดดาบสำรองเหลือ 0 : Rig_<ชื่อ>.LowerTorso.Left_1 .. Left_N แต่ละชุดมี Attribute "Used" = true เมื่อใช้แล้ว
--   [ Thunder Spears ] หอกเหลือ 0 : Attribute "Spears" บนตัวละครเป็น 0 (ปกติ 8 นัด / ถ้าใส่ Perk = 12) หรือหอกค้าง (เกมโชว์ว่าเหลือแต่ยิงไม่ออก)
--   ทั้งสองแบบต้องค้างอยู่นาน EMPTY_WAIT วินาที และผู้เล่นต้องยังมี Refills เหลือ (Attribute "Refills" ของผู้เล่น > 0)
-- ทำ: ยิง Remote ใส่สถานี Refill ที่ใกล้ที่สุดจากระยะไกลได้เลย (ไม่ต้องวาร์ป ไม่ต้องหยุดฟาร์ม) -> เช็กว่าของกลับมา -> ไม่กลับมาลองซ้ำ
---------------------------------------------------------
do
    local REFILL_PLACES = {
        [13379349730]     = { "Unclimbable", "Props", "HQ" },              -- Shiganshina
        [14012874501]     = { "Unclimbable", "Props", "HQ" },              -- Trost
        [13904207646]     = { "Climbable", "_Walls", "Gate" },             -- Outskirts
        [14638336319]     = { "Unclimbable", "Camps", "Camp" },            -- Forest
        [15220308770]     = { "Climbable", "Utgard" },                     -- Utgard
        [17688739434]     = { "Unclimbable", "World", "Buildings", "Hanger" }, -- Docks
        [15824912319]     = { "Unclimbable", "Props", "HQ" },              -- Stohess
        [126678335159530] = { "Unclimbable", "Reloads" },                  -- Chapel
    }
    local EMPTY_WAIT = 1.5   -- ดาบหมดและสำรอง 0 ค้างเท่านี้ถึงจะไปเติม (กันจังหวะที่เกมกำลังรีโหลดเอง)
    local TRIES = 2          -- ลองเติมสูงสุดกี่รอบต่อครั้ง (แต่ละรอบหัก Refills 1 ครั้ง จึงไม่ยิงถี่)
    local CHECK_WAIT = 3     -- ยิงแล้วรอเท่านี้ให้ตัวเลขอัปเดตก่อนตัดสินว่าไม่สำเร็จ
    local COOLDOWN = 15      -- เติมเสร็จแล้วพักอย่างน้อยเท่านี้ก่อนเติมรอบใหม่
    local lastRefill = -999
    local function Log(...) print("[SmoothHub][Refill]", ...) end -- พิมพ์ใน F9 ทุกครั้งที่ยิง จะได้รู้ว่ายิงเพราะอะไร
    local Status = "Idle"
    Farm.RefillStatus = function() return Status end

    local stations = nil
    local function Collect(container)
        local list = {}
        for _, d in ipairs(container:GetDescendants()) do
            if d.Name == "Refill" then list[#list + 1] = d end
        end
        return list
    end

    local function PosOf(inst)
        local ok, pos = pcall(function()
            if inst:IsA("BasePart") then return inst.Position end
            if inst:IsA("Model") then return inst:GetPivot().Position end
            local part = inst:FindFirstChildWhichIsA("BasePart", true)
            return part and part.Position or nil
        end)
        return ok and pos or nil
    end

    local function NearestStation(root)
        -- แคชไว้ ถ้าสถานีถูกลบ/ยังไม่เคยหา ค่อยหาใหม่
        local valid = stations and #stations > 0
        if valid then
            for _, st in ipairs(stations) do
                if not st.Parent then valid = false break end
            end
        end
        if not valid then
            local container = workspace
            local path = REFILL_PLACES[game.PlaceId]
            if path then
                local cur = workspace
                for _, name in ipairs(path) do cur = cur and cur:FindFirstChild(name) end
                if cur then container = cur end
            end
            stations = Collect(container)
            if #stations == 0 and container ~= workspace then stations = Collect(workspace) end
        end
        local best, bestDist = nil, math.huge
        for _, st in ipairs(stations) do
            local pos = PosOf(st)
            if pos then
                local d = (pos - root.Position).Magnitude
                if d < bestDist then best, bestDist = st, d end
            end
        end
        return best
    end

    local function Rig()
        local char = LocalPlayer.Character
        return char and char:FindFirstChild("Rig_" .. LocalPlayer.Name)
    end

    -- จำนวนชุดดาบสำรองที่ยังไม่ถูกใช้ (nil = หาชุดสำรองในตัวละครไม่เจอ ไม่รู้สถานะ จะไม่เติมให้)
    local function SpareLeft()
        local rig = Rig()
        local torso = rig and rig:FindFirstChild("LowerTorso")
        if not torso then return nil end
        local total, left = 0, 0
        for _, d in ipairs(torso:GetChildren()) do
            if d.Name:match("^Left_%d+$") then
                total = total + 1
                if not d:GetAttribute("Used") then left = left + 1 end
            end
        end
        if total == 0 then return nil end
        return left
    end
    Farm.BladeSpare = SpareLeft

    local function NeedBlade()
        return Cfg.AutoRefillsBlade and Farm.BladesEmpty and Farm.BladesEmpty() and SpareLeft() == 0
    end
    local function NeedThunder()
        if not Cfg.AutoRefillsThunder then return false end
        local n = Farm.SpearsLeft and Farm.SpearsLeft()
        if n ~= nil and n <= 0 then return true end
        -- เกมโชว์ว่าเหลือ 1-2 นัดแต่ยิงไม่ออกแล้ว (หอกค้าง) ก็ถือว่าหมด
        return Farm.SpearStuck ~= nil and Farm.SpearStuck() == true
    end
    local function RefillsLeft()
        local n = LocalPlayer:GetAttribute("Refills")
        if type(n) == "number" then return n end
        return nil -- ไม่รู้ = ลองเติมได้
    end

    local function DoRefill()
        local ok0, post = pcall(function()
            return game:GetService("ReplicatedStorage").Assets.Remotes:WaitForChild("POST", 5)
        end)
        if not ok0 or not post then Status = "POST remote not found" return end
        for attempt = 1, TRIES do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not (root and hum and hum.Health > 0) then break end
            local station = NearestStation(root)
            if not station then Status = "Refill station not found" break end
            Status = "Refilling (" .. attempt .. "/" .. TRIES .. ")"
            -- เติมระยะไกลได้ ไม่ต้องวาร์ปไปที่สถานี ยิง Remote ทิ้งไว้เลย
            Log(string.format("fire #%d | blade=%s thunder=%s | BladesEmpty=%s Spare=%s Spears=%s Stuck=%s Refills=%s | %s",
                attempt, tostring(Cfg.AutoRefillsBlade), tostring(Cfg.AutoRefillsThunder),
                tostring(Farm.BladesEmpty and Farm.BladesEmpty()), tostring(SpareLeft()),
                tostring(Farm.SpearsLeft and Farm.SpearsLeft()), tostring(Farm.SpearStuck and Farm.SpearStuck()),
                tostring(LocalPlayer:GetAttribute("Refills")), station:GetFullName()))
            pcall(function() post:FireServer("Attacks", "Reload", station) end)
            local t1 = os.clock()
            while os.clock() - t1 < CHECK_WAIT and (NeedBlade() or NeedThunder()) do task.wait(0.2) end
            if not (NeedBlade() or NeedThunder()) then
                Status = "Refilled"
                break
            end
            Status = "Refill failed, retrying"
        end
    end

    task.spawn(function()
        local since = nil
        while Alive() do
            task.wait(0.4)
            if Farm.CanUseHere() and (NeedBlade() or NeedThunder()) then
                since = since or os.clock()
                if os.clock() - since >= EMPTY_WAIT and os.clock() - lastRefill >= COOLDOWN then
                    local left = RefillsLeft()
                    if left ~= nil and left <= 0 then
                        Status = "No Refills left"
                        since = os.clock() + 30 -- ไม่มี Refills เหลือ รอ 30 วินาทีค่อยเช็กใหม่ ไม่ต้องวาร์ปไปเปล่า ๆ
                    else
                        DoRefill()
                        lastRefill = os.clock()
                        since = nil
                    end
                end
            else
                since = nil
                if Status ~= "Idle" and not Farm.Refilling then Status = "Idle" end
            end
        end
    end)
end

---------------------------------------------------------
-- 🔁 Auto Retry / 🚪 Auto Leave   (ทำงานบนหน้า MISSION COMPLETED)
-- Remote (จาก Remote Spy):
--   Retry : ReplicatedStorage.Assets.Remotes.GET:InvokeServer("Functions", "Retry", "Add")   = โหวต RETRY
--   Leave : ReplicatedStorage.Assets.Remotes.POST:FireServer("Functions", "Teleport")        = กลับล็อบบี้
-- ออกแบบให้ยิง Remote น้อยที่สุด:
--  • ระหว่างเล่นไม่ยิงอะไรเลย แค่อ่านหน้าจอในเครื่อง
--  • ยิงเมื่อ "เห็นหน้า MISSION COMPLETED ค้างอยู่" และเห็นปุ่มที่ต้องกดจริง (RETRY / LEAVE) เท่านั้น
--  • รอบละ 1 ครั้งต่อหนึ่งหน้า ถ้าหน้ายังค้างหลังรอ ค่อยลองซ้ำได้อีก 1 ครั้งแล้วหยุด
-- ลำดับความสำคัญเมื่อด่านจบ:
--  1) Auto Leave เปิด            -> ออกทันที (ไม่ Retry)
--  2) Auto Retry เปิด            -> Retry ต่อเรื่อยๆ ไม่จำกัดจำนวน
--     ถ้าเปิด Auto Leave After X Matches ด้วย -> Retry จนครบ Retry Amount แล้วออกไปล็อบบี้
--  Auto Leave กับ Auto Leave After X Matches เปิดพร้อมกันไม่ได้ (เปิดอันหนึ่ง อีกอันจะปิดเอง)
---------------------------------------------------------
do
    local LOBBY_PLACE_ID = 14916516914
    local CHECK_INTERVAL = 1.0     -- เช็คหน้าจอทุกกี่วินาที (ไม่มี Remote)
    local SCAN_INTERVAL = 2.0      -- ถ้ายังไม่รู้ว่าป้ายอยู่ตรงไหน ค้นหน้าจอใหม่ไม่ถี่กว่านี้
    local CONFIRM_TIME = 1.5       -- หน้า MISSION COMPLETED ต้องค้างโชว์ต่อเนื่องก่อนยิง (ให้ปุ่มพร้อม)
    local GONE_TIME = 3.0          -- หน้าหายไปนานเท่านี้ = ด่านใหม่เริ่มแล้ว รีเซ็ตสถานะของหน้า
    local MAX_RETRY_TRIES = 2      -- Retry สูงสุดกี่ครั้งต่อหนึ่งหน้า
    local RETRY_GAP = 10           -- ยิง Retry แล้วหน้ายังค้าง รอเท่านี้ก่อนลองซ้ำ
    local MAX_LEAVE_TRIES = 2      -- Leave สูงสุดกี่ครั้งต่อหนึ่งหน้า
    local LEAVE_GAP = 12           -- ยิง Leave แล้วหน้ายังค้าง รอเท่านี้ก่อนลองซ้ำ (เผื่อเทเลพอร์ตช้า)
    local CALL_TIMEOUT = 8

    local function Status(text)
        if Farm.SetRetryStatus then Farm.SetRetryStatus(text) end
    end

    local function CanUseHere()
        return not IN_MENU and game.PlaceId ~= LOBBY_PLACE_ID
    end

    local function CleanText(o)
        local t = (o.Text or ""):gsub("<[^>]->", "")
        t = t:gsub("^%s+", ""):gsub("%s+$", "")
        return t
    end

    local function IsShownGui(obj)
        local cur = obj
        while cur and cur ~= PlayerGui do
            if cur:IsA("GuiObject") and not cur.Visible then return false end
            if cur:IsA("ScreenGui") and not cur.Enabled then return false end
            cur = cur.Parent
        end
        return obj:IsA("GuiObject") and obj.AbsoluteSize.X > 0 and obj.AbsoluteSize.Y > 0
    end

    -- หาป้าย "MISSION COMPLETED" (จำตำแหน่งไว้ ไม่ต้องค้นทั้งหน้าจอทุกวินาที)
    local titleLabel, scanAt = nil, 0
    local function FindCompleteTitle()
        if titleLabel and titleLabel.Parent then
            return IsShownGui(titleLabel) and titleLabel or nil
        end
        titleLabel = nil
        if os.clock() - scanAt < SCAN_INTERVAL then return nil end
        scanAt = os.clock()
        local n = 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and CleanText(d):upper() == "MISSION COMPLETED" then
                titleLabel = d
                return IsShownGui(d) and d or nil
            end
        end
        return nil
    end
    Farm.CompleteScreenShown = function() return FindCompleteTitle() ~= nil end -- ใช้นับ "ชนะติดกัน" ของ Fail Safe

    -- หาข้อความปุ่มในหน้าเดียวกับป้าย (ไต่ขึ้นไปหากรอบที่มีข้อความขึ้นต้นตาม pattern เช่น "^RETRY" / "^LEAVE")
    local function FindButtonText(title, pattern)
        local cur = title.Parent
        for _ = 1, 8 do
            if not cur or cur == PlayerGui then break end
            for _, d in ipairs(cur:GetDescendants()) do
                if (d:IsA("TextLabel") or d:IsA("TextButton")) and CleanText(d):upper():match(pattern) and IsShownGui(d) then
                    return d
                end
            end
            cur = cur.Parent
        end
        return nil
    end

    local getRemote = nil
    local function FireRetry()
        if not getRemote or not getRemote.Parent then getRemote = GetLobbyRemote() end
        if not getRemote then return false, "remote not found" end
        local rem = getRemote
        local done, ok, res = false, false, nil
        task.spawn(function()
            ok, res = pcall(function() return rem:InvokeServer("Functions", "Retry", "Add") end)
            done = true
        end)
        local t0 = os.clock()
        while not done and os.clock() - t0 < CALL_TIMEOUT do task.wait(0.1) end
        if not done then return false, "timeout" end
        return ok, res
    end

    -- Leave ใช้ RemoteEvent (POST) ยิงแล้วไม่รอคำตอบ
    local postRemote = nil
    local function FireLeave()
        if not postRemote or not postRemote.Parent then
            local ok, r = pcall(function()
                return game:GetService("ReplicatedStorage").Assets.Remotes:WaitForChild("POST", 5)
            end)
            postRemote = ok and r or nil
        end
        if not postRemote then return false, "remote not found" end
        return pcall(function() postRemote:FireServer("Functions", "Teleport") end)
    end

    function Farm.RefreshRetry()
        if Farm.SetRetry then Farm.SetRetry(Cfg.RetryDone) end
    end

    function Farm.ResetRetry()
        Cfg.RetryDone = 0
        Save()
        Farm.RefreshRetry()
    end

    -- ปิดสวิตช์ Auto Retry = จบรอบ รีเซ็ตตัวนับ (ตอนเริ่มสคริปต์ที่เซฟไว้เป็นปิดอยู่แล้วไม่กระทบค่าเดิม)
    function Farm.OnAutoRetry(on)
        if not on and Cfg.RetryDone ~= 0 then Farm.ResetRetry() end
    end

    -- Auto Leave กับ Auto Leave After X Matches เปิดพร้อมกันไม่ได้: เปิดอันไหน อีกอันถูกปิดให้เอง
    local function TurnOffOther(key)
        if Cfg[key] then
            Cfg[key] = false
            Save()
            local ctl = Farm.Toggles and Farm.Toggles[key]
            if ctl then pcall(function() ctl.Value = false end) end
        end
    end
    function Farm.OnAutoLeave(on)
        if on then TurnOffOther("AutoLeaveWhenRetryComplete") end
    end
    function Farm.OnAutoLeaveWhenRetryComplete(on)
        if on then TurnOffOther("AutoLeave") end
    end

    -- อยู่ล็อบบี้/เมนู = จบสาย Retry แล้ว
    if not CanUseHere() and Cfg.RetryDone ~= 0 then
        Cfg.RetryDone = 0
        Save()
    end
    Farm.RefreshRetry()

    task.spawn(function()
        local seenSince, goneSince = nil, nil
        local tries, lastTry, counted = 0, 0, false
        local leaveTries, lastLeave = 0, 0
        local screenMode = nil -- "leave" = หน้านี้ตัดสินใจจะออกแล้ว ห้าม Retry ซ้ำบนหน้านี้

        local function ResetScreenState()
            seenSince, goneSince = nil, nil
            tries, lastTry, counted = 0, 0, false
            leaveTries, lastLeave = 0, 0
            screenMode = nil
        end

        local function DoLeave(title, why)
            screenMode = "leave"
            if leaveTries >= MAX_LEAVE_TRIES or (leaveTries > 0 and os.clock() - lastLeave < LEAVE_GAP) then
                Status("Leave sent - waiting for the game")
                return
            end
            if not FindButtonText(title, "^LEAVE") then
                Status("Leave button not found")
                return
            end
            leaveTries += 1
            lastLeave = os.clock()
            Status("Leaving... (" .. why .. ")")
            local ok, err = FireLeave()
            if Farm.Debug then SH.dbg("[SmoothHub] Leave fired:", ok, err) end
            if ok then
                Status("Leave sent (" .. why .. ")")
                if Cfg.RetryDone ~= 0 then Farm.ResetRetry() end -- จบสาย Retry แล้ว
            else
                Status("Leave failed: " .. tostring(err))
            end
        end

        -- ข้อความนับรอบ: เปิด Auto Leave After X Matches = นับ x/จำนวนที่ตั้ง, ไม่เปิด = เล่นต่อไม่จำกัด
        local function Progress(done)
            if Cfg.AutoLeaveWhenRetryComplete then
                return ("%d/%d"):format(done, Cfg.RetryAmount)
            end
            return tostring(done) .. " / endless"
        end

        local function DoRetry(title)
            if tries >= MAX_RETRY_TRIES or (tries > 0 and os.clock() - lastTry < RETRY_GAP) then
                Status("Retry sent - waiting for the game")
                return
            end
            local btn = FindButtonText(title, "^RETRY")
            if not btn then
                Status("Retry button not found")
                return
            end
            local have, need = CleanText(btn):match("(%d+)%s*/%s*(%d+)")
            have, need = tonumber(have), tonumber(need)
            if have and need and have >= need then
                Status("Retry vote already in")
                tries = MAX_RETRY_TRIES -- โหวตครบแล้ว ไม่ยิงอีก
                return
            end
            tries += 1
            lastTry = os.clock()
            Status("Retrying... (" .. Progress(Cfg.RetryDone + (counted and 0 or 1)) .. ")")
            local ok, r = FireRetry()
            if Farm.Debug then SH.dbg("[SmoothHub] Retry fired:", ok, r) end
            if ok then
                if not counted then
                    counted = true
                    Cfg.RetryDone += 1
                    Save()
                    Farm.RefreshRetry()
                end
                Status("Retry sent (" .. Progress(Cfg.RetryDone) .. ")")
            else
                Status("Retry failed: " .. tostring(r))
            end
        end

        while Alive() do
            task.wait(CHECK_INTERVAL)

            if not (Cfg.AutoRetry or Cfg.AutoLeave or Cfg.AutoLeaveWhenRetryComplete) then
                ResetScreenState()
                Status("Off")
            elseif not CanUseHere() then
                ResetScreenState()
                Status("Not available in the lobby / menu")
            else
                local title = FindCompleteTitle()
                if not title then
                    -- ไม่เห็นหน้า MISSION COMPLETED: รอให้หายนานพอค่อยรีเซ็ต (กันป้ายกะพริบ)
                    goneSince = goneSince or os.clock()
                    if os.clock() - goneSince >= GONE_TIME then ResetScreenState() end
                    if not seenSince then
                        if Cfg.AutoRetry then
                            Status("Waiting for the mission to finish (" .. Progress(Cfg.RetryDone) .. ")")
                        else
                            Status("Waiting for the mission to finish")
                        end
                    end
                else
                    goneSince = nil
                    seenSince = seenSince or os.clock()
                    if os.clock() - seenSince < CONFIRM_TIME then
                        Status("Mission completed - preparing")
                    elseif screenMode == "leave" or Cfg.AutoLeave then
                        DoLeave(title, "Auto Leave")
                    elseif Cfg.AutoRetry then
                        -- จำกัดจำนวนรอบเฉพาะตอนเปิด Auto Leave After X Matches เท่านั้น ไม่งั้น Retry ต่อไปเรื่อยๆ
                        if Cfg.AutoLeaveWhenRetryComplete and Cfg.RetryDone >= Cfg.RetryAmount then
                            DoLeave(title, ("after %d matches"):format(Cfg.RetryAmount))
                        else
                            DoRetry(title)
                        end
                    else
                        Status("Auto Leave After X Matches needs Auto Retry")
                    end
                end
            end
        end
    end)
end

local AutoQuestTab = MainCategory:Tab({
    Title = "Auto Quest",
    Icon = Icon("scrollFill", "checklist"),
})
local AutoQuestSection = AutoQuestTab:PageSection({
    Title = "🛠️ Auto Quest",
    Subtitle = "Core features and settings"
})

---------------------------------------------------------
-- Lobby (Lobby / Progression / Skill Trees / Perks)
---------------------------------------------------------
local LobbyCategory = Cascade.Components.Section(Window, {
    Title = "Lobby",
    Disclosure = false
})

local LobbyTab = LobbyCategory:Tab({
    Title = "Lobby",
    Icon = Icon("cubeFill", "shippingboxFill", "cube"),
})
-- ───────── Auto Claim ─────────
-- อ่านจากหน้า Quests / Achievements ของเกมเอง: ปุ่ม Claim ที่เกม "โชว์ขึ้นมา" = เกมถือว่ารับได้แล้วจริง ๆ
-- (เกมซ่อนข้อมูลผู้เล่นไว้ executor เอื้อมไม่ถึง แต่หน้าจอ UI อ่านได้)
-- เจอปุ่ม Claim ที่โชว์อยู่ -> ยิง Remote ตัวเดียวกับที่ปุ่มของเกมใช้ ไม่เดา tag/id เอง
-- ข้อจำกัด: หน้า UI จะอัปเดตตอนที่ "เปิดหน้า/เลือกหมวด" ในเกมเท่านั้น
do
    local ClaimSection = LobbyTab:PageSection({
        Title = "🎁 Auto Claim",
        Subtitle = "Claims rewards the game shows as ready. Open the Quests / Achievements page to refresh them."
    })
    local ClaimForm = ClaimSection:Form()

    local ClaimStatusRow = ClaimForm:Row()
    ClaimStatusRow:Left():TitleStack({ Title = "Claim Status", Subtitle = "Rewards claimed since the script started." })
    local ClaimStatusLabel = ClaimStatusRow:Right():Label({ Text = "Idle" })
    local function SetClaimStatus(text)
        pcall(function() ClaimStatusLabel.Text = tostring(text) end)
    end

    local function AddClaimToggle(title, subtitle, key)
        local row = ClaimForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        UiSync.Link(row:Right():Toggle({
            Value = Cfg[key],
            ValueChanged = function(self, value)
                Cfg[key] = value and true or false
                Save()
            end
        }), Cfg, key)
    end

    AddClaimToggle("Auto Claim Main Quests", "Automatically claim the main quests.", "AutoClaimMain")
    AddClaimToggle("Auto Claim Side Quests", "Automatically claim the side quests.", "AutoClaimSide")
    AddClaimToggle("Auto Claim Achievements", "Automatically claim achievements.", "AutoClaimAchievements")
    AddClaimToggle("Auto Claim Weekly Quests", "Automatically claim the weekly quests.", "AutoClaimWeekly")
    AddClaimToggle("Auto Claim Daily Quests", "Automatically claim the daily quests.", "AutoClaimDaily")
    AddClaimToggle("Auto Open Pages", "When the game shows the red ! on the Achievements icon, open that page, claim, then close it (like a player).", "AutoOpenPages")

    local SCAN_INTERVAL = 5       -- อ่านหน้าจอทุกกี่วินาที (อ่านอย่างเดียว เบามาก)
    local CLAIM_RETRY = 300       -- ปุ่มเดิมที่ยิงไปแล้ว (สำเร็จหรือไม่) รอกี่วินาทีค่อยยิงซ้ำ
    local CLAIM_GAP = 1.2         -- เว้นช่วงระหว่างแต่ละคำขอ
    local CLAIM_MAX_PER_RUN = 25  -- รับได้สูงสุดกี่รายการต่อรอบ
    local BLIND_DAILY_INTERVAL = 300 -- Daily แบบไม่ดูหน้าจอ ยิงได้ทุกกี่วินาที

    local claimRemote = nil
    local function GetClaimRemote()
        if claimRemote and claimRemote.Parent then return claimRemote end
        claimRemote = GetLobbyRemote()
        return claimRemote
    end

    -- หมวดของเควสต์ -> สวิตช์ที่คุมมัน (หมวดอื่น เช่น Spears / Battlepass / Regiment ไม่แตะ)
    local QUEST_TOGGLE = {
        Main = "AutoClaimMain",
        Side = "AutoClaimSide",
        Weekly = "AutoClaimWeekly",
        Daily = "AutoClaimDaily",
    }

    local function Interface()
        return PlayerGui:FindFirstChild("Interface")
    end

    -- ───── อ่านปุ่ม Claim ในหน้า Quests ─────
    -- โค้ดเกม: การ์ดเควสต์ -> Inner.Claim (โชว์เมื่อรับได้) -> Button ที่ตั้ง Attribute Tag/Category ไว้
    -- (ตั้งเฉพาะการ์ดที่ Claim.Visible = true จึงตรงกับ "เสร็จแล้วแต่ยังไม่รับ" ตามที่เกมตัดสิน)
    local function ScanQuestCards()
        local out = {}
        local quests = Interface() and Interface():FindFirstChild("Quests")
        if not quests then return out end
        for _, d in ipairs(quests:GetDescendants()) do
            if d.Name == "Button" and d:IsA("GuiObject") then
                local ok, info = pcall(function()
                    local claim = d.Parent
                    if not (claim and claim.Name == "Claim" and claim.Visible) then return nil end
                    local tag, category = d:GetAttribute("Tag"), d:GetAttribute("Category")
                    if tag == nil or category == nil then return nil end
                    return { tag = tostring(tag), category = tostring(category), inst = d }
                end)
                if ok and info then out[#out + 1] = info end
            end
        end
        return out
    end

    -- ───── อ่านปุ่ม CLAIM ในหน้า Achievements ─────
    -- โค้ดเกม: List.Inner -> รายการชื่อ = index -> Inner.A_State (โชว์เมื่อรับ/ใส่ได้) ข้อความ "CLAIM" = ยังไม่รับ
    local function ScanAchievementItems()
        local out = {}
        local iface = Interface()
        local ach = iface and iface:FindFirstChild("Achievements")
        local list = ach and ach:FindFirstChild("List")
        list = list and list:FindFirstChild("Inner")
        if not list then return out end
        for _, item in ipairs(list:GetChildren()) do
            local ok, info = pcall(function()
                local id = tonumber(item.Name)
                if not id or id == 99 then return nil end -- 99 = รางวัลเสร็จครบหมวด (ไม่ทำ)
                local inner = item:FindFirstChild("Inner")
                local state = inner and inner:FindFirstChild("A_State")
                local title = state and state:FindFirstChild("Title")
                if state and state.Visible and title and title.Text == "CLAIM" then
                    return { id = id, inst = item }
                end
                return nil
            end)
            if ok and info then out[#out + 1] = info end
        end
        return out
    end

    -- ───── ยิงคำขอรับรางวัล ─────
    -- จำปุ่มที่ยิงไปแล้ว (key = ตัวปุ่มใน UI) เกมสร้างการ์ดใหม่ทุกครั้งที่เปิดหน้า ปุ่มใหม่จึงยิงได้ทันที
    local lastTry = setmetatable({}, { __mode = "k" })
    local function Due(inst)
        return os.clock() - (lastTry[inst] or -math.huge) >= CLAIM_RETRY
    end

    -- คืน true ถ้าเซิร์ฟเวอร์ตอบรับ (ค่าแรกที่ตอบกลับไม่ใช่ nil)
    local function ClaimOne(inst, ...)
        lastTry[inst] = os.clock()
        local remote = GetClaimRemote()
        if not remote then return false end
        local args = table.pack(...)
        local ok, r1 = pcall(function()
            return remote:InvokeServer(table.unpack(args, 1, args.n))
        end)
        return ok and r1 ~= nil
    end

    local totals = { Main = 0, Side = 0, Weekly = 0, Daily = 0, Ach = 0 }
    local function RefreshClaimStatus()
        SetClaimStatus(("Main %d · Side %d · Weekly %d · Daily %d · Ach %d"):format(
            totals.Main, totals.Side, totals.Weekly, totals.Daily, totals.Ach))
    end

    local function RunScan()
        if not Interface() then SetClaimStatus("Waiting for the game UI...") return end
        local done, tried = 0, 0

        -- เควสต์
        local wantQuests = Cfg.AutoClaimMain or Cfg.AutoClaimSide or Cfg.AutoClaimWeekly or Cfg.AutoClaimDaily
        if wantQuests then
            for _, c in ipairs(ScanQuestCards()) do
                local toggle = QUEST_TOGGLE[c.category]
                if toggle and Cfg[toggle] and Alive() and tried < CLAIM_MAX_PER_RUN and Due(c.inst) then
                    tried += 1
                    if ClaimOne(c.inst, "Functions", "Quest", c.tag, c.category) then
                        totals[c.category] += 1
                        done += 1
                    end
                    task.wait(CLAIM_GAP)
                end
            end
        end

        -- Achievements
        if Cfg.AutoClaimAchievements then
            for _, a in ipairs(ScanAchievementItems()) do
                if Cfg.AutoClaimAchievements and Alive() and tried < CLAIM_MAX_PER_RUN and Due(a.inst) then
                    tried += 1
                    if ClaimOne(a.inst, "S_Achievements", "Claim", a.id) then
                        totals.Ach += 1
                        done += 1
                    end
                    task.wait(CLAIM_GAP)
                end
            end
        end

        if done > 0 or tried > 0 then RefreshClaimStatus() end
    end

    -- Daily แบบไม่ดูหน้าจอ (pattern จาก Remote Spy: "Daily 1..3") ยิงไม่บ่อย และเซิร์ฟเวอร์เป็นคนตัดสินเอง
    local lastBlindDaily = -math.huge
    local function RunBlindDaily()
        if not Cfg.AutoClaimDaily then return end
        if os.clock() - lastBlindDaily < BLIND_DAILY_INTERVAL then return end
        lastBlindDaily = os.clock()
        local remote = GetClaimRemote()
        if not remote then return end
        for i = 1, 3 do
            if not (Alive() and Cfg.AutoClaimDaily) then return end
            local ok, r1 = pcall(function()
                return remote:InvokeServer("Functions", "Quest", "Daily " .. i, "Daily")
            end)
            if ok and r1 ~= nil then totals.Daily += 1 end
            task.wait(CLAIM_GAP)
        end
        RefreshClaimStatus()
    end


    -- ───── เปิดหน้าเองเมื่อเกมโชว์ป้าย (เหมือนผู้เล่นกดเอง) ─────
    -- Achievements: ป้าย Topbar.Main.Icons.Achievements.New (เกมอัปเดตเอง ไม่ต้องเปิดหน้า)
    -- Quests: ป้าย New บนการ์ดหมวด (Quests.Main.Quests.<การ์ด>.Inner.Title.New) การ์ดมีอยู่แม้หน้าปิด
    -- ป้ายอาจค้างอยู่ได้ (แค่ "ของใหม่ที่ยังไม่ได้ดู") จึงเปิดเฉพาะตอนป้าย "เพิ่งขึ้น" ป้ายดับแล้วค่อยรีเซ็ต
    local OPEN_COOLDOWN = 60
    local opening = false
    local lastAchOpen, lastQuestOpen = -math.huge, -math.huge
    local handledAch = {} -- หมวด Achievement ที่จัดการไปแล้ว (ป้ายของหมวดดับแล้วค่อยรีเซ็ต)
    local handledCards = {}
    -- การ์ดหมวดเควสต์ -> หมวดที่คุมด้วยสวิตช์ (Q_1 = MAIN QUESTS ยืนยันจากหน้าจอ) ตัวอื่นยังไม่รู้
    local CARD_CATEGORY = { Q_1 = "Main", Q_2 = "Side" } -- Q_1 ยืนยันแล้ว, Q_2 = Side (อนุมานจากป้ายที่ขึ้นหลังเล่นจบ ยังรอยืนยัน)

    local function WantQuests()
        return Cfg.AutoClaimMain or Cfg.AutoClaimSide or Cfg.AutoClaimWeekly or Cfg.AutoClaimDaily
    end

    local function OnScreen(obj)
        local cam = workspace.CurrentCamera
        if not cam then return true end
        local c = obj.AbsolutePosition + obj.AbsoluteSize / 2
        local v = cam.ViewportSize
        return c.X >= 0 and c.Y >= 0 and c.X <= v.X and c.Y <= v.Y
    end

    -- หน้าเปิดอยู่ไหม (Visible + โปร่งใสไม่เต็ม + อยู่ในจอ) ดูผลจริงได้ที่ปุ่ม Copy Claim Debug
    local function PageOpen(page)
        if not page then return false end
        local ok, res = pcall(function()
            if not IsShown(page) then return false end
            if page:IsA("CanvasGroup") and page.GroupTransparency >= 0.95 then return false end
            return OnScreen(page)
        end)
        return ok and res or false
    end

    local function AchPage()
        local iface = Interface()
        return iface and iface:FindFirstChild("Achievements")
    end
    local function QuestsPage()
        local iface = Interface()
        return iface and iface:FindFirstChild("Quests")
    end
    local function AchOpen() return PageOpen(AchPage()) end
    local function QuestsOpen() return PageOpen(QuestsPage()) end

    local function AchBadgeOn()
        local b = FindGui("Interface.Topbar.Main.Icons.Achievements.New")
        return b ~= nil and b:IsA("GuiObject") and b.Visible
    end

    -- การ์ดหมวดเควสต์ + ป้าย New + ปุ่ม Interact
    local function QuestCategoryCards()
        local out = {}
        local q = QuestsPage()
        local main = q and q:FindFirstChild("Main")
        local cats = main and main:FindFirstChild("Quests")
        if not cats then return out end
        for _, c in ipairs(cats:GetChildren()) do
            if c:IsA("CanvasGroup") then
                local ok, info = pcall(function()
                    local inner = c:FindFirstChild("Inner")
                    local title = inner and inner:FindFirstChild("Title")
                    local flag = title and title:FindFirstChild("New")
                    return {
                        name = c.Name,
                        new = (flag ~= nil and flag:IsA("GuiObject") and flag.Visible) and true or false,
                        interact = inner and inner:FindFirstChild("Interact"),
                    }
                end)
                if ok and info then out[#out + 1] = info end
            end
        end
        return out
    end

    -- การ์ดเควสต์ย่อยที่เกมสร้างในแผง Details (เปลี่ยนเมื่อกดเลือกหมวดอื่น)
    local function DetailKey()
        local q = QuestsPage()
        local main = q and q:FindFirstChild("Main")
        local d = main and main:FindFirstChild("Details")
        local p = d and d:FindFirstChild("Quests")
        local n, first = 0, nil
        if p then
            for _, k in ipairs(p:GetChildren()) do
                if k:IsA("CanvasGroup") then
                    n += 1
                    first = first or k
                end
            end
        end
        return n, first
    end

    local function QuestsCloseButton()
        local q = QuestsPage()
        local c = q and q:FindFirstChild("Close")
        if not c then return nil end
        if c:IsA("GuiButton") then return c end
        return c:FindFirstChildWhichIsA("GuiButton", true)
    end

    -- กดปุ่มเหมือนผู้เล่น (กรอบฟ้า + Enter) แล้วเช็คผลทุก 0.25 วิ
    -- ไม่ติดค่อยยิง signal ให้ "ครั้งเดียว" (กันกดซ้ำจนหน้าเด้งเปิด-ปิด)
    local function PressUntil(btn, doneFn, timeout)
        pcall(function() GuiService.SelectedObject = btn end)
        task.wait(0.15)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end)
        local t0 = os.clock()
        local fired = false
        while os.clock() - t0 < (timeout or 3) do
            task.wait(0.25)
            if doneFn() then break end
            if not fired and os.clock() - t0 > 1.2 then
                fired = true
                pcall(function()
                    if type(firesignal) == "function" then
                        firesignal(btn.MouseButton1Click)
                        firesignal(btn.Activated)
                    end
                end)
            end
        end
        pcall(function()
            if GuiService.SelectedObject == btn then GuiService.SelectedObject = nil end
        end)
        return doneFn()
    end

    -- ───── Achievements 2 ชั้น: รายการหมวด (ชื่อข้อความ + Interact + Icon.New) -> รายการในหมวด (ชื่อเป็นเลข) ─────
    local function AchList()
        local ach = AchPage()
        local l = ach and ach:FindFirstChild("List")
        return l and l:FindFirstChild("Inner")
    end

    -- อยู่ในหมวดอยู่ไหม (มีรายการชื่อเป็นเลข = อยู่ชั้นใน)
    local function AchInCategoryView()
        local list = AchList()
        if not list then return false end
        for _, c in ipairs(list:GetChildren()) do
            if tonumber(c.Name) then return true end
        end
        return false
    end

    local function AchCategories()
        local out = {}
        local list = AchList()
        if not list then return out end
        for _, item in ipairs(list:GetChildren()) do
            if item:IsA("GuiObject") and not tonumber(item.Name) then
                local box = item:FindFirstChild("Inner")
                local icon = box and box:FindFirstChild("Icon")
                local nw = icon and icon:FindFirstChild("New")
                local interact = item:FindFirstChild("Interact")
                if box and icon and interact and interact:IsA("GuiButton") then
                    out[#out + 1] = {
                        name = item.Name,
                        new = (nw ~= nil and nw:IsA("GuiObject") and nw.Visible) and true or false,
                        interact = interact,
                    }
                end
            end
        end
        return out
    end

    -- ปุ่มลูกศรมุมขวาบน: ถอยออกจากหมวด (หรือปิดหน้า ถ้าอยู่ชั้นรายการหมวดแล้ว)
    local function AchBack(doneFn)
        local close = FindGui("Interface.Achievements.Top.Achievements_Close")
        if not (close and close:IsA("GuiButton")) then return false end
        PressUntil(close, doneFn, 3)
        return true
    end
    local function BackedOut() return (not AchOpen()) or (not AchInCategoryView()) end

    local function AutoOpenAchievements()
        if opening then return end
        if not (Cfg.AutoOpenPages and Cfg.AutoClaimAchievements) then return end
        if not AchBadgeOn() then handledAch = {} return end
        if AchOpen() and AchInCategoryView() then return end -- ผู้เล่นกำลังดูในหมวดอยู่ ไม่แย่งหน้าจอ

        local todo = 0
        for _, c in ipairs(AchCategories()) do
            if c.new then
                if not handledAch[c.name] then todo += 1 end
            else
                handledAch[c.name] = nil
            end
        end
        if todo == 0 then return end
        if os.clock() - lastAchOpen < OPEN_COOLDOWN then return end
        local icon = FindGui("Interface.Topbar.Main.Icons.Achievements")
        if not (icon and icon:IsA("GuiButton") and IsShown(icon)) then return end

        opening = true
        lastAchOpen = os.clock()
        local ok, err = pcall(function()
            local wasOpen = AchOpen()
            SetClaimStatus("Achievement badge! Opening page...")

            local function EnsureOpen()
                if not AchOpen() then PressUntil(icon, AchOpen, 3) end
                local t0 = os.clock()
                while os.clock() - t0 < 3 and #AchCategories() == 0 and not AchInCategoryView() do task.wait(0.3) end
                return AchOpen()
            end

            if not EnsureOpen() then
                SetClaimStatus("Achievements page did not open")
                return
            end

            for _ = 1, 5 do
                if not (Alive() and Cfg.AutoOpenPages and Cfg.AutoClaimAchievements) then break end
                -- เปิดมาแล้วอยู่ในหมวด (เกมจำหน้าล่าสุด) -> ถอยออกมาที่รายการหมวดก่อน
                if AchInCategoryView() then
                    AchBack(BackedOut)
                    task.wait(0.4)
                end
                if not EnsureOpen() then break end

                local nextCat = nil
                for _, c in ipairs(AchCategories()) do
                    if c.new and not handledAch[c.name] then nextCat = c break end
                end
                if not nextCat then break end

                handledAch[nextCat.name] = true
                PressUntil(nextCat.interact, AchInCategoryView, 3)
                task.wait(0.6)
                RunScan()
                AchBack(BackedOut)
                task.wait(0.4)
            end

            -- ปิดหน้ากลับ (เฉพาะกรณีที่สคริปต์เป็นคนเปิดเอง)
            if not wasOpen and AchOpen() then
                if AchInCategoryView() then
                    AchBack(BackedOut)
                    task.wait(0.4)
                end
                if AchOpen() then
                    AchBack(function() return not AchOpen() end)
                end
            end
        end)
        opening = false
        if not ok then SetClaimStatus("Auto open failed: " .. tostring(err)) end
    end

    local function AutoOpenQuests()
        if opening then return end
        if not (Cfg.AutoOpenPages and WantQuests()) then return end
        local todo = {}
        for _, c in ipairs(QuestCategoryCards()) do
            if c.new then
                local cat = CARD_CATEGORY[c.name]
                local wanted
                if cat then wanted = Cfg[QUEST_TOGGLE[cat]] else wanted = WantQuests() end
                if wanted and not handledCards[c.name] then todo[#todo + 1] = c end
            else
                handledCards[c.name] = nil
            end
        end
        if #todo == 0 then return end
        if os.clock() - lastQuestOpen < OPEN_COOLDOWN then return end
        local topBtn = FindGui("Interface.Topbar.Main.Categories.Quests.Interact")
        if not (topBtn and topBtn:IsA("GuiButton") and IsShown(topBtn)) then return end

        opening = true
        lastQuestOpen = os.clock()
        local ok, err = pcall(function()
            local wasOpen = QuestsOpen()
            SetClaimStatus("Quest badge! Opening page...")
            if not wasOpen then
                PressUntil(topBtn, QuestsOpen, 3)
            end
            if not QuestsOpen() then
                SetClaimStatus("Quests page did not open")
                return
            end
            task.wait(0.5)
            for _, c in ipairs(todo) do
                if not (Alive() and Cfg.AutoOpenPages) then break end
                handledCards[c.name] = true
                if c.interact and c.interact.Parent then
                    local n0, f0 = DetailKey()
                    PressUntil(c.interact, function()
                        local n1, f1 = DetailKey()
                        return n1 > 0 and (n1 ~= n0 or f1 ~= f0)
                    end, 3)
                    task.wait(0.6)
                    RunScan()
                end
            end
            if not wasOpen and QuestsOpen() then
                local close = QuestsCloseButton()
                if close then
                    PressUntil(close, function() return not QuestsOpen() end, 3)
                else
                    SetClaimStatus("Quests page left open (close button not found)")
                end
            end
        end)
        opening = false
        if not ok then SetClaimStatus("Auto open failed: " .. tostring(err)) end
    end

    task.spawn(function()
        while Alive() do
            pcall(RunScan) -- อ่านปุ่ม Claim ที่โชว์อยู่ก่อน (หน้าปิดอยู่ก็อาจมีปุ่มค้างจากรอบก่อน)
            pcall(AutoOpenAchievements)
            pcall(AutoOpenQuests)
            pcall(RunBlindDaily)
            task.wait(SCAN_INTERVAL)
        end
    end)

    -- 🔒 โหมดนักพัฒนา: ปุ่ม Copy Claim Debug ซ่อนไว้ (เปลี่ยนเป็น true เฉพาะตอนต้องดีบักเอง ก่อนปล่อยให้คนอื่นใช้ต้องเป็น false)
    local DEV_MODE = SH.DEV
    if DEV_MODE then
    -- ปุ่มดีบัก: อ่านอย่างเดียว ไม่ยิง Remote
    -- บอกว่าสคริปต์เห็นอะไรในหน้า Quests / Achievements บ้าง และโครงสร้างปุ่มหมวด (ไว้ทำเปิดหน้าอัตโนมัติ)
    local DebugRow = ClaimForm:Row()
    DebugRow:Left():TitleStack({
        Title = "Copy Claim Debug",
        Subtitle = "Open the Quests page and click through its categories, then Achievements, then press Copy."
    })
    local DebugBtn = DebugRow:Right():Button({ Label = "Copy", Callback = function() end })
    BindButton(DebugBtn, function()
        local lines = {}
        local function add(s) lines[#lines + 1] = tostring(s) end
        local function childNames(inst, limit)
            local parts = {}
            if inst then
                for _, c in ipairs(inst:GetChildren()) do parts[#parts + 1] = c.Name .. ":" .. c.ClassName end
            end
            table.sort(parts)
            if limit and #parts > limit then
                local n = #parts
                parts = { table.unpack(parts, 1, limit) }
                parts[#parts + 1] = ("...(+%d)"):format(n - limit)
            end
            return table.concat(parts, ", ")
        end

        local iface = Interface()
        add("Interface found: " .. tostring(iface ~= nil))
        if iface then
            add("Interface children: " .. childNames(iface, 60))

            local q = iface:FindFirstChild("Quests")
            add("Interface.Quests found: " .. tostring(q ~= nil))
            if q then
                add("Quests children: " .. childNames(q, 30))
                local main = q:FindFirstChild("Main")
                add("Quests.Main children: " .. childNames(main, 30))
                local cats = main and main:FindFirstChild("Quests")
                if cats then
                    for _, c in ipairs(cats:GetChildren()) do
                        if c:IsA("CanvasGroup") then
                            local newFlag = "?"
                            pcall(function() newFlag = tostring(c.Inner.Title.New.Visible) end)
                            local interact = c:FindFirstChild("Inner") and c.Inner:FindFirstChild("Interact")
                            add(("  category card %s | New(claimable)=%s | Interact=%s"):format(
                                c.Name, newFlag, interact and interact.ClassName or "none"))
                        end
                    end
                end
                local details = main and main:FindFirstChild("Details")
                local cardsParent = details and details:FindFirstChild("Quests")
                local nCards = 0
                if cardsParent then
                    for _, c in ipairs(cardsParent:GetChildren()) do
                        if c:IsA("CanvasGroup") then nCards += 1 end
                    end
                end
                add("Quest cards currently built: " .. nCards)
                local found = ScanQuestCards()
                add("Claim buttons showing in Quests: " .. #found)
                for _, c in ipairs(found) do add(("  tag=%s category=%s"):format(c.tag, c.category)) end
            end

            local ach = iface:FindFirstChild("Achievements")
            add("Interface.Achievements found: " .. tostring(ach ~= nil))
            if ach then
                add("Achievements children: " .. childNames(ach, 30))
                local list = ach:FindFirstChild("List") and ach.List:FindFirstChild("Inner")
                add("Achievement items built: " .. (list and #list:GetChildren() or 0))
                local items = ScanAchievementItems()
                add("CLAIM items showing in Achievements: " .. #items)
                for i = 1, math.min(#items, 15) do add("  id " .. items[i].id) end
            end

            local newIcon = FindGui("Interface.Topbar.Main.Icons.Achievements.New")
            add("Topbar Achievements 'New' flag: " .. (newIcon and tostring(newIcon.Visible) or "n/a"))

            -- ป้ายแจ้งเตือน "New" ทุกอันบนแถบบน (เกมอัปเดตเองโดยไม่ต้องเปิดหน้า) ไว้ใช้เป็นตัวบอกว่ามีของรอรับ
            local topbar = iface:FindFirstChild("Topbar")
            if topbar then
                add("Topbar children: " .. childNames(topbar, 20))
                local mainBar = topbar:FindFirstChild("Main")
                add("Topbar.Main children: " .. childNames(mainBar, 40))
                local icons = mainBar and mainBar:FindFirstChild("Icons")
                add("Topbar.Main.Icons children: " .. childNames(icons, 40))
                for _, d in ipairs(topbar:GetDescendants()) do
                    if d.Name == "New" and d:IsA("GuiObject") then
                        add(("  badge %s | Visible=%s"):format(d:GetFullName():gsub("^.-Interface%.", ""), tostring(d.Visible)))
                    end
                end
            end

            -- โครงสร้างด้านบนของหน้า Achievements (ปุ่มเลือกหมวด)
            local function tree(inst, depth, maxDepth, out, limit)
                if depth > maxDepth or #out >= limit then return end
                for _, c in ipairs(inst:GetChildren()) do
                    if #out >= limit then return end
                    out[#out + 1] = string.rep("  ", depth) .. c.Name .. ":" .. c.ClassName
                    tree(c, depth + 1, maxDepth, out, limit)
                end
            end
            if ach and ach:FindFirstChild("Top") then
                local out = {}
                tree(ach.Top, 1, 3, out, 60)
                add("Achievements.Top tree:")
                for _, l in ipairs(out) do add(l) end
            end
        end

        -- ───── ข้อมูลเพิ่มสำหรับทำ "เปิดหน้าเอง" (อ่านอย่างเดียว) ─────
        do
            local iface2 = Interface()
            if iface2 then
                add("Achievements page open (script's view): " .. tostring(AchOpen()))
                local ach2 = iface2:FindFirstChild("Achievements")
                if ach2 and ach2:IsA("CanvasGroup") then
                    add(("Achievements.Visible=%s GroupTransparency=%.2f"):format(tostring(ach2.Visible), ach2.GroupTransparency))
                end
                -- ปุ่มทั้งหมดบนแถบบน + ป้ายแจ้งเตือน
                local topbar2 = iface2:FindFirstChild("Topbar")
                if topbar2 then
                    add("Topbar buttons:")
                    for _, d in ipairs(topbar2:GetDescendants()) do
                        if d:IsA("GuiButton") then
                            add(("  %s | %s | shown=%s"):format(d:GetFullName():gsub("^.-Interface%.", ""), d.ClassName, tostring(IsShown(d))))
                        end
                    end
                    local cats = topbar2:FindFirstChild("Main") and topbar2.Main:FindFirstChild("Categories")
                    if cats then
                        add("Topbar.Main.Categories tree:")
                        local out2 = {}
                        local function walk(inst, depth)
                            if depth > 3 or #out2 >= 60 then return end
                            for _, c in ipairs(inst:GetChildren()) do
                                if #out2 >= 60 then return end
                                out2[#out2 + 1] = string.rep("  ", depth) .. c.Name .. ":" .. c.ClassName
                                walk(c, depth + 1)
                            end
                        end
                        walk(cats, 1)
                        for _, l in ipairs(out2) do add(l) end
                    end
                end
                -- ป้าย "New" ที่ "กำลังโชว์" อยู่ทั่ว Interface ตอนนี้ (ใช้หาว่าเควสต์/อย่างอื่นมีป้ายตรงไหน)
                add("Visible 'New' badges in Interface:")
                local nShown = 0
                for _, d in ipairs(iface2:GetDescendants()) do
                    if d.Name == "New" and d:IsA("GuiObject") and d.Visible and nShown < 40 then
                        nShown += 1
                        add("  " .. d:GetFullName():gsub("^.-Interface%.", ""))
                    end
                end
                if nShown == 0 then add("  (none)") end
            end
        end

        -- ───── รายละเอียดสถานะของแต่ละ Achievement + ปุ่มปิดหน้า Quests ─────
        do
            local iface3 = Interface()
            local ach3 = iface3 and iface3:FindFirstChild("Achievements")
            local list3 = ach3 and ach3:FindFirstChild("List")
            local inner3 = list3 and list3:FindFirstChild("Inner")
            if inner3 then
                add("Achievement items (name | A_State.Visible | A_State.Title | Icon.New):")
                local n = 0
                for _, item in ipairs(inner3:GetChildren()) do
                    if n >= 25 then break end
                    n += 1
                    local box = item:FindFirstChild("Inner")
                    local st = box and box:FindFirstChild("A_State")
                    local ttl = st and st:FindFirstChild("Title")
                    local icon = box and box:FindFirstChild("Icon")
                    local nw = icon and icon:FindFirstChild("New")
                    add(("  %s | state=%s | text=%s | new=%s"):format(
                        item.Name,
                        st and tostring(st.Visible) or "n/a",
                        ttl and tostring(ttl.Text) or "n/a",
                        nw and tostring(nw.Visible) or "n/a"))
                end
            end
            local q3 = iface3 and iface3:FindFirstChild("Quests")
            if q3 then
                add("Quests page open (script's view): " .. tostring(QuestsOpen()))
                add("Quests.Close tree:")
                local out3 = {}
                local function walk3(inst, depth)
                    if depth > 3 or #out3 >= 30 then return end
                    for _, c in ipairs(inst:GetChildren()) do
                        if #out3 >= 30 then return end
                        out3[#out3 + 1] = string.rep("  ", depth) .. c.Name .. ":" .. c.ClassName
                        walk3(c, depth + 1)
                    end
                end
                local closeF = q3:FindFirstChild("Close")
                if closeF then walk3(closeF, 1) end
                for _, l in ipairs(out3) do add(l) end
            end
        end

        -- ───── หน้า Achievements มี 2 ชั้น: รายการหมวด (ชื่อข้อความ) -> รายการในหมวด (ชื่อเป็นเลข) ─────
        -- ดูโครงสร้างของหมวดที่มีป้าย New เพื่อหาว่าต้องกดตรงไหนถึงเข้าหมวด
        pcall(function()
            local iface4 = Interface()
            local ach4 = iface4 and iface4:FindFirstChild("Achievements")
            if not ach4 then return end
            local top4 = ach4:FindFirstChild("Top")
            add("Achievements view (script's view): " .. (AchInCategoryView() and "inside a category" or "category list"))
            for _, nm in ipairs({ "Category", "Title" }) do
                local lbl = top4 and top4:FindFirstChild(nm)
                if lbl and lbl:IsA("TextLabel") then
                    add(("Achievements.Top.%s text: %s"):format(nm, lbl.Text))
                end
            end
            local lst4 = ach4:FindFirstChild("List")
            local list4 = lst4 and lst4:FindFirstChild("Inner")
            if not list4 then return end
            local shown = 0
            for _, item in ipairs(list4:GetChildren()) do
                local box = item:FindFirstChild("Inner")
                local icon = box and box:FindFirstChild("Icon")
                local nw = icon and icon:FindFirstChild("New")
                if nw and nw:IsA("GuiObject") and nw.Visible and shown < 2 then
                    shown += 1
                    add("Flagged achievement category tree: " .. item.Name)
                    local out4 = {}
                    local function walk4(inst, depth)
                        if depth > 3 or #out4 >= 40 then return end
                        for _, c in ipairs(inst:GetChildren()) do
                            if #out4 >= 40 then return end
                            out4[#out4 + 1] = string.rep("  ", depth) .. c.Name .. ":" .. c.ClassName
                                .. (c:IsA("GuiButton") and " [BUTTON]" or "")
                            walk4(c, depth + 1)
                        end
                    end
                    walk4(item, 1)
                    for _, l in ipairs(out4) do add(l) end
                end
            end
        end)

        local text = table.concat(lines, "\n")
        local copied = false
        if type(setclipboard) == "function" then copied = pcall(setclipboard, text)
        elseif type(toclipboard) == "function" then copied = pcall(toclipboard, text) end
        local saved = false
        if type(writefile) == "function" then saved = pcall(writefile, "SmoothHub_claimdebug.txt", text) end
        SetClaimStatus(copied and "Debug copied" or (saved and "Debug saved to file" or "Copy/save not supported"))
    end)
    end -- DEV_MODE
end

-- ───────── Equipment ─────────
-- ยิง Remote ตัวเดียวกับที่ปุ่มของเกมใช้ (ค่าที่ส่งมาจากที่คุณจับมาจากเกมเอง):
--   Upgrade All (Blade) : GET:InvokeServer("S_Equipment", "Upgrade", { Blade_Durability, ODM_*, Crit_* })
--   Upgrade All (TS)    : GET:InvokeServer("S_Equipment", "Upgrade", { Blast_Radius, TS_*, Crit_* })
--   Equip               : GET:InvokeServer("S_Equipment", "Weapon", "Spears" | "Blades")
do
    local BLADE_STATS = { "Blade_Durability", "ODM_Gas", "Crit_Damage", "ODM_Control", "ODM_Speed", "Crit_Chance", "ODM_Range", "ODM_Damage" }
    local THUNDER_STATS = { "Blast_Radius", "TS_Damage", "TS_Gas", "TS_Range", "TS_Control", "Crit_Chance", "Crit_Damage", "TS_Speed" }

    local UPGRADE_INTERVAL = 10   -- วินาที: กด Upgrade All ซ้ำทุกกี่วินาที (เซิร์ฟเวอร์เป็นคนตัดสินว่าจ่ายไหวไหม)
    local UPGRADE_GAP = 1.5       -- เว้นช่วงระหว่าง Blade กับ Thunder Spears ถ้าเปิดทั้งคู่
    local EQUIP_AFTER_SPAWN = 3   -- วินาทีที่รอหลังเกิดใหม่ก่อน Auto Equip
    local CALL_TIMEOUT = 8        -- รอเซิร์ฟเวอร์ตอบได้นานสุดกี่วินาที

    local EquipSection = LobbyTab:PageSection({
        Title = "⚔️ Equipment",
        Subtitle = "Automatically upgrade and equip your Blade, ODM gear and Thunder Spears."
    })
    local EquipForm = EquipSection:Form()

    -- แถวสถานะ
    local EquipStatusRow = EquipForm:Row()
    EquipStatusRow:Left():TitleStack({ Title = "Equipment Status", Subtitle = "Result of the last request." })
    local EquipStatusLabel = EquipStatusRow:Right():Label({ Text = "Idle" })
    local function SetEquipStatus(text)
        pcall(function() EquipStatusLabel.Text = tostring(text) end)
    end

    local equipRemote = nil
    local function GetEquipRemote()
        if equipRemote and equipRemote.Parent then return equipRemote end
        equipRemote = GetLobbyRemote()
        return equipRemote
    end

    -- ยิงคำขอในเธรดแยกและรอผลสูงสุด CALL_TIMEOUT วินาที (InvokeServer อาจค้างถ้าเซิร์ฟเวอร์ไม่ตอบ)
    local function Invoke(...)
        local remote = GetEquipRemote()
        if not remote then return false, "remote not found" end
        local args = table.pack(...)
        local done, ok, result = false, false, nil
        task.spawn(function()
            ok, result = pcall(function()
                return remote:InvokeServer(table.unpack(args, 1, args.n))
            end)
            done = true
        end)
        local t0 = os.clock()
        while not done and os.clock() - t0 < CALL_TIMEOUT do task.wait(0.1) end
        if not done then return false, "timeout" end
        return ok, result
    end

    local function UpgradeAll(statList, label)
        local ok, r = Invoke("S_Equipment", "Upgrade", table.clone(statList))
        SetEquipStatus(ok and (label .. " upgrade sent") or (label .. " upgrade failed: " .. tostring(r)))
        return ok
    end

    local function EquipWeapon(kind, label)
        local ok, r = Invoke("S_Equipment", "Weapon", kind)
        SetEquipStatus(ok and (label .. " equip sent") or (label .. " equip failed: " .. tostring(r)))
        return ok
    end

    -- สวิตช์ Equip Blade / Thunder Spears เลือกได้อย่างเดียว (ถ้าเปิดอันหนึ่ง อีกอันจะปิดเอง)
    local toggles = {}
    local function AddEquipToggle(title, subtitle, key, onChange)
        local row = EquipForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        toggles[key] = UiSync.Link(row:Right():Toggle({
            Value = Cfg[key],
            ValueChanged = function(self, value)
                Cfg[key] = value and true or false
                Save()
                if onChange then onChange(Cfg[key]) end
            end
        }), Cfg, key)
    end

    local function TurnOff(key)
        if Cfg[key] then
            Cfg[key] = false
            Save()
            pcall(function() toggles[key].Value = false end)
        end
    end

    AddEquipToggle("Auto Upgrade Gear ( Blade )", "Automatically upgrade BLADE & ODM.", "AutoUpgradeBlade", nil)
    AddEquipToggle("Auto Upgrade Gear ( Thunder Spears )", "Automatically upgrade thunder spears.", "AutoUpgradeThunder", nil)
    AddEquipToggle("Auto Equip Blade", "Automatically equip blades.", "AutoEquipBlade", function(on)
        if on then
            TurnOff("AutoEquipThunder")
            task.spawn(EquipWeapon, "Blades", "Blade")
        end
    end)
    AddEquipToggle("Auto Equip Thunder Spears", "Automatically equip thunder spears.", "AutoEquipThunder", function(on)
        if on then
            TurnOff("AutoEquipBlade")
            task.spawn(EquipWeapon, "Spears", "Thunder Spears")
        end
    end)

    -- Auto Upgrade: ยิง Upgrade All ทุก UPGRADE_INTERVAL วินาทีตอนสวิตช์เปิดอยู่
    task.spawn(function()
        local lastBlade, lastThunder = 0, 0
        while Alive() do
            if Cfg.AutoUpgradeBlade and os.clock() - lastBlade >= UPGRADE_INTERVAL then
                lastBlade = os.clock()
                UpgradeAll(BLADE_STATS, "Blade")
                task.wait(UPGRADE_GAP)
            end
            if Alive() and Cfg.AutoUpgradeThunder and os.clock() - lastThunder >= UPGRADE_INTERVAL then
                lastThunder = os.clock()
                UpgradeAll(THUNDER_STATS, "Thunder Spears")
                task.wait(UPGRADE_GAP)
            end
            task.wait(1)
        end
    end)

    -- Auto Equip: ยิงตอนเปิดสวิตช์ (ด้านบน) และหลังเกิดใหม่ทุกครั้ง ไม่ยิงซ้ำรัว ๆ
    -- (ไม่แน่ใจว่าเซิร์ฟเวอร์ตีความคำสั่ง Equip เป็น "ตั้งเป็นอันนี้" หรือ "สลับ" จึงไม่วนยิงซ้ำ)
    local spawnConn
    spawnConn = LocalPlayer.CharacterAdded:Connect(function()
        if not Alive() then spawnConn:Disconnect() return end
        task.delay(EQUIP_AFTER_SPAWN, function()
            if not Alive() then return end
            if Cfg.AutoEquipThunder then
                EquipWeapon("Spears", "Thunder Spears")
            elseif Cfg.AutoEquipBlade then
                EquipWeapon("Blades", "Blade")
            end
        end)
    end)
end

local ProgressionTab = LobbyCategory:Tab({
    Title = "Progression",
    Icon = Icon("chartBarFill", "chartBarXaxis", "chartLineUptrendXyaxis"),
})
do
    -- หน้าจอ Progression (ทำหน้าตาไว้ก่อน: ยังไม่ทำงานจริง ต้องรู้ Remote ของ Prestige / Memories ก่อน)
    -- ค่าทั้งหมดอยู่ใน Cfg (Prestige... / Mem_...) และเซฟ/โหลด/รีเซ็ตตามระบบเดิม
    local BOOSTS = { "Luck", "Gold", "EXP" }

    local function ProgToggle(form, title, subtitle, key)
        local row = form:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        UiSync.Link(row:Right():Toggle({
            Value = Cfg[key],
            ValueChanged = function(self, value)
                Cfg[key] = value and true or false
                Save()
                -- TODO: เรียกฟังก์ชัน Prestige ตรงนี้เมื่อรู้ Remote
            end
        }), Cfg, key)
    end

    local function ProgSlider(form, title, subtitle, key)
        local range = FARM_RANGES[key]
        local row = form:Row()
        local function titleFor(v) return title .. " ( " .. v .. " )" end
        local stack = row:Left():TitleStack({ Title = titleFor(Cfg[key]), Subtitle = subtitle })
        UiSync.Link(row:Right():Slider({
            Minimum = range[1],
            Maximum = range[2],
            Value = Cfg[key],
            ValueChanged = function(self, value)
                local v = math.clamp(math.floor(value + 0.5), range[1], range[2])
                Cfg[key] = v
                pcall(function() stack.Title = titleFor(v) end)
                Save()
            end
        }), Cfg, key, function(_, want)
            pcall(function() stack.Title = titleFor(want) end)
        end)
    end

    local function ProgPick(form, title, options, key)
        local row = form:Row()
        row:Left():TitleStack({ Title = title })
        local btn = row:Right():PullDownButton({
            Label = Cfg[key],
            Options = options,
            Value = table.find(options, Cfg[key]) or 1,
            ValueChanged = function(self, index)
                if options[index] then
                    Cfg[key] = options[index]
                    self.Label = options[index]
                    Save()
                end
            end
        })
        StyleDropdown(btn)
        UiSync.Add(function()
            local i = table.find(options, Cfg[key]) or 1
            btn.Value = i
            btn.Label = options[i]
        end)
    end

    -- 👑 Prestige Section
    local PrestigeSection = ProgressionTab:PageSection({
        Title = "👑 Prestige Section",
        Subtitle = "Automatically prestige and choose your boosts."
    })
    local PrestigeForm = PrestigeSection:Form()
    ProgToggle(PrestigeForm, "Auto Prestige", "Automatically prestige.", "AutoPrestige")
    for i = 1, 5 do
        ProgPick(PrestigeForm, "Prestige " .. i .. " Boost", BOOSTS, "PrestigeBoost" .. i)
    end
    ProgSlider(PrestigeForm, "Prestige Stop At", nil, "PrestigeStopAt")

    -- 🧠 Memories Priority
    local MemorySection = ProgressionTab:PageSection({
        Title = "🧠 Memories Priority",
        Subtitle = "Set a priority for each memory (0 - 10)."
    })
    local MemoryForm = MemorySection:Form()
    for _, m in ipairs(SH.Memories) do
        ProgSlider(MemoryForm, m.Name, string.rep("★", m.Stars) .. "  " .. m.Desc, m.Key)
    end
end

local SkillTreesTab = LobbyCategory:Tab({
    Title = "Skill Trees",
    Icon = Icon("bookPagesFill", "bookFill", "book"),
})
do
    -- Skill Trees
    -- Remote (จาก Cobalt): GET:InvokeServer("S_Equipment", "Unlock", { "<id>", ... })
    --   ส่งรายการ id ของโหนดทั้งสายตั้งแต่โหนดปลายทางลงมา (เซิร์ฟเวอร์เป็นคนตัดสินว่าแต้มพอปลดกี่โหนด)
    -- ค่าทั้งหมดอยู่ใน Cfg (Skill...) และเซฟ/โหลด/รีเซ็ตตามระบบเดิม
    local SKILL_INTERVAL = 10   -- วินาที: ยิงซ้ำทุกกี่วินาทีตอนสวิตช์เปิด
    local SKILL_GAP = 1.5       -- เว้นช่วงระหว่างสายที่ยิงติดกัน
    local SKILL_TIMEOUT = 8     -- รอเซิร์ฟเวอร์ตอบได้นานสุดกี่วินาที

    -- รายการ id ของแต่ละปลายทาง (ใส่เพิ่มเมื่อจับ Remote ของอันอื่นมาได้)
    -- ลำดับตัวเลขต้องเหมือนที่เกมส่งเป๊ะ ๆ (รวม "154" ที่แทรกอยู่กลางสาย)
    local SKILL_PATHS = {
        Left = {
            ["Regen VI"] = { "89", "88", "87", "86", "85", "84", "83", "82", "81", "80", "79", "78", "77", "76", "75", "154", "73", "72", "71", "70" },
            ["Injury III"] = { "98", "97", "96", "95", "94", "93", "92", "91", "90", "80", "79", "78", "77", "76", "75", "154", "73", "72", "71", "70" },
        },
        Middle = {
            ["Damage V"] = { "149", "148", "147", "146", "145", "144", "143", "142", "141", "140", "139", "138", "125", "124", "123", "122", "121", "120", "119", "118", "117", "116", "115", "114", "113" },
            ["Crit Damage V"] = { "137", "136", "135", "134", "133", "132", "131", "130", "129", "128", "127", "126", "125", "124", "123", "122", "121", "120", "119", "118", "117", "116", "115", "114", "113" },
        },
        Right = {
            ["Tank VIII"] = { "69", "68", "67", "66", "65", "64", "63", "62", "61", "60", "151", "58", "45", "44", "43", "42", "41", "150", "39", "38" },
            ["Health XI"] = { "57", "56", "55", "54", "53", "52", "51", "50", "49", "48", "47", "46", "45", "44", "43", "42", "41", "150", "39", "38" },
        },
    }
    local SkillSection = SkillTreesTab:PageSection({
        Title = "Skills",
        Subtitle = "Auto upgrade the skill tree."
    })
    local SkillForm = SkillSection:Form()

    local SkillStatusRow = SkillForm:Row()
    SkillStatusRow:Left():TitleStack({ Title = "Skill Status", Subtitle = "Result of the last request." })
    local SkillStatusLabel = SkillStatusRow:Right():Label({ Text = "Idle" })
    local function SetSkillStatus(text)
        pcall(function() SkillStatusLabel.Text = tostring(text) end)
    end

    local skillWake = false -- ตั้งเป็น true เพื่อให้ลูปด้านล่างยิงทันที ไม่ต้องรอรอบ

    local skillRemote = nil
    local function GetSkillRemote()
        if skillRemote and skillRemote.Parent then return skillRemote end
        skillRemote = GetLobbyRemote()
        return skillRemote
    end

    -- ยิงคำขอในเธรดแยกและรอผลสูงสุด SKILL_TIMEOUT วินาที
    local function SkillInvoke(...)
        local remote = GetSkillRemote()
        if not remote then return false, "remote not found" end
        local args = table.pack(...)
        local done, ok, result = false, false, nil
        task.spawn(function()
            ok, result = pcall(function()
                return remote:InvokeServer(table.unpack(args, 1, args.n))
            end)
            done = true
        end)
        local t0 = os.clock()
        while not done and os.clock() - t0 < SKILL_TIMEOUT do task.wait(0.1) end
        if not done then return false, "timeout" end
        return ok, result
    end

    local SKILL_LANES = {
        { Name = "Left",   On = "SkillLeft",   Pick = "SkillLeftPick",   Pri = "SkillLeftPriority" },
        { Name = "Middle", On = "SkillMiddle", Pick = "SkillMiddlePick", Pri = "SkillMiddlePriority" },
        { Name = "Right",  On = "SkillRight",  Pick = "SkillRightPick",  Pri = "SkillRightPriority" },
    }

    -- อัปสายที่เปิดอยู่ทั้งหมด เรียงตาม Priority (เลขน้อยก่อน เท่ากันเรียง Left > Middle > Right)
    local function UpgradeSkills()
        local lanes = {}
        for i, lane in ipairs(SKILL_LANES) do
            if Cfg[lane.On] then
                lanes[#lanes + 1] = { lane = lane, order = i }
            end
        end
        if #lanes == 0 then
            SetSkillStatus("No path enabled")
            return
        end
        table.sort(lanes, function(a, b)
            local pa, pb = Cfg[a.lane.Pri], Cfg[b.lane.Pri]
            if pa ~= pb then return pa < pb end
            return a.order < b.order
        end)

        for _, entry in ipairs(lanes) do
            if not Alive() or not Cfg.AutoUpgradeSkills then return end
            local lane = entry.lane
            local pick = Cfg[lane.Pick]
            local ids = SKILL_PATHS[lane.Name] and SKILL_PATHS[lane.Name][pick]
            if not ids then
                SetSkillStatus(lane.Name .. " ( " .. tostring(pick) .. " ): not supported yet")
            else
                local ok, r = SkillInvoke("S_Equipment", "Unlock", table.clone(ids))
                SetSkillStatus(ok and (lane.Name .. " ( " .. pick .. " ) sent: " .. tostring(r))
                    or (lane.Name .. " ( " .. pick .. " ) failed: " .. tostring(r)))
                task.wait(SKILL_GAP)
            end
        end
    end

    task.spawn(function()
        local last = 0
        while Alive() do
            if Cfg.AutoUpgradeSkills and (skillWake or os.clock() - last >= SKILL_INTERVAL) then
                skillWake = false
                last = os.clock()
                UpgradeSkills()
            end
            task.wait(1)
        end
    end)

    local function SkillToggle(form, title, subtitle, key)
        local row = form:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        UiSync.Link(row:Right():Toggle({
            Value = Cfg[key],
            ValueChanged = function(self, value)
                Cfg[key] = value and true or false
                Save()
                if value then skillWake = true end -- เปิดแล้วยิงรอบใหม่ทันที
            end
        }), Cfg, key)
    end

    local function SkillPick(form, title, options, key)
        local row = form:Row()
        row:Left():TitleStack({ Title = title })
        local btn = row:Right():PullDownButton({
            Label = Cfg[key],
            Options = options,
            Value = table.find(options, Cfg[key]) or 1,
            ValueChanged = function(self, index)
                if options[index] then
                    Cfg[key] = options[index]
                    self.Label = options[index]
                    Save()
                end
            end
        })
        StyleDropdown(btn)
        UiSync.Add(function()
            local i = table.find(options, Cfg[key]) or 1
            btn.Value = i
            btn.Label = options[i]
        end)
    end

    SkillToggle(SkillForm, "Auto Upgrade Skills", "Automatically upgrade skills tree.", "AutoUpgradeSkills")

    SkillToggle(SkillForm, "Left", "Upgrade the left path.", "SkillLeft")
    SkillPick(SkillForm, "Left Path", { "Regen VI", "Injury III" }, "SkillLeftPick")
    SkillToggle(SkillForm, "Middle", "Upgrade the middle path.", "SkillMiddle")
    SkillPick(SkillForm, "Middle Path", { "Damage V", "Crit Damage V" }, "SkillMiddlePick")
    SkillToggle(SkillForm, "Right", "Upgrade the right path.", "SkillRight")
    SkillPick(SkillForm, "Right Path", { "Tank VIII", "Health XI" }, "SkillRightPick")

    local PrioritySection = SkillTreesTab:PageSection({
        Title = "Upgrade Priority",
        Subtitle = "Adjust the upgrade priority to determine which path you want to upgrade first."
    })
    local PriorityForm = PrioritySection:Form()

    local function SkillPriority(title, key)
        local range = FARM_RANGES[key]
        local row = PriorityForm:Row()
        local function titleFor(v) return title .. " ( " .. v .. " )" end
        local stack = row:Left():TitleStack({ Title = titleFor(Cfg[key]) })
        UiSync.Link(row:Right():Slider({
            Minimum = range[1],
            Maximum = range[2],
            Value = Cfg[key],
            ValueChanged = function(self, value)
                local v = math.clamp(math.floor(value + 0.5), range[1], range[2])
                Cfg[key] = v
                pcall(function() stack.Title = titleFor(v) end)
                Save()
            end
        }), Cfg, key, function(_, want)
            pcall(function() stack.Title = titleFor(want) end)
        end)
    end

    SkillPriority("Left Priority", "SkillLeftPriority")
    SkillPriority("Middle Priority", "SkillMiddlePriority")
    SkillPriority("Right Priority", "SkillRightPriority")
end

local PerksTab = LobbyCategory:Tab({
    Title = "Perks",
    Icon = Icon("sparkles", "sparkle", "starFill"),
})
do
    -- หน้าจอ Perks (ทำหน้าตาไว้ก่อน: ยังไม่ทำงานจริง ต้องรู้ Remote ที่เกมใช้ตอนคราฟ Perk ก่อน)
    -- ค่าทั้งหมดอยู่ใน Cfg (Craft...) และเซฟ/โหลด/รีเซ็ตตามระบบเดิม
    local function PerkToggle(form, title, subtitle, key)
        local row = form:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        UiSync.Link(row:Right():Toggle({
            Value = Cfg[key],
            ValueChanged = function(self, value)
                Cfg[key] = value and true or false
                Save()
                -- TODO: เรียกฟังก์ชันคราฟ Perk ตรงนี้เมื่อรู้ Remote
            end
        }), Cfg, key)
    end

    local function PerkSlider(form, title, key)
        local range = FARM_RANGES[key]
        local row = form:Row()
        local function titleFor(v) return title .. " ( " .. v .. " )" end
        local stack = row:Left():TitleStack({ Title = titleFor(Cfg[key]) })
        UiSync.Link(row:Right():Slider({
            Minimum = range[1],
            Maximum = range[2],
            Value = Cfg[key],
            ValueChanged = function(self, value)
                local v = math.clamp(math.floor(value + 0.5), range[1], range[2])
                Cfg[key] = v
                pcall(function() stack.Title = titleFor(v) end)
                Save()
            end
        }), Cfg, key, function(_, want)
            pcall(function() stack.Title = titleFor(want) end)
        end)
    end

    -- 🔨 Crafting
    local CraftSection = PerksTab:PageSection({
        Title = "🔨 Crafting",
        Subtitle = "Automatically craft perks."
    })
    local CraftForm = CraftSection:Form()
    PerkToggle(CraftForm, "Auto Craft Perks", "Automatically craft perks.", "AutoCraftPerks")
    PerkToggle(CraftForm, "Common → Rare", nil, "CraftCommonRare")
    PerkSlider(CraftForm, "Common → Rare Chance", "CraftChanceCommonRare")
    PerkToggle(CraftForm, "Rare → Epic", nil, "CraftRareEpic")
    PerkSlider(CraftForm, "Rare → Epic Chance", "CraftChanceRareEpic")
    PerkToggle(CraftForm, "Epic → Legendary", nil, "CraftEpicLegendary")
    PerkSlider(CraftForm, "Epic → Legendary Chance", "CraftChanceEpicLegendary")
    PerkToggle(CraftForm, "Legendary → Mythic", nil, "CraftLegendaryMythic")
    PerkSlider(CraftForm, "Legendary → Mythic Chance", "CraftChanceLegendaryMythic")
end

---------------------------------------------------------
-- Game Mode (Missions / Wave Mode / Raid Mode)
---------------------------------------------------------
local GameModeCategory = Cascade.Components.Section(Window, {
    Title = "Game Mode",
    Disclosure = false
})

local MissionsTab = GameModeCategory:Tab({
    Title = "Missions",
    Icon = Icon("listClipboardFill", "clipboardFill", "checklist"),
})
local WaveModeTab = GameModeCategory:Tab({
    Title = "Wave Mode",
    Icon = Icon("waveformCircleFill", "waveform", "tornado"),
})
local RaidModeTab = GameModeCategory:Tab({
    Title = "Raid Mode",
    Icon = Icon("diamondFill", "shieldFill", "flameFill"),
})
-- ───────── Mission Settings ─────────
-- ตอนนี้เป็นตัวเลือก + สวิตช์ + เซฟค่าไว้ใน Cfg (ตรรกะเลือก/เข้าแมพจริง ยังไม่ได้ผูก)
-- ⚠️ รายชื่อตัวเลือกด้านล่างเป็นค่าตั้งต้นที่ผมใส่ให้ ยังไม่ได้ตรวจกับในเกม แก้ชื่อให้ตรงกับเกมได้ตรงนี้เลย
local MISSION_OPTIONS    = { "Shiganshina", "Trost", "Outskirts", "Forest", "Utgard", "Docks", "Stohess", "Chapel" }
local OBJECTIVE_OPTIONS  = { "Skirmish" } -- เว้นไว้ก่อน: ยังไม่ได้จับ Objective อื่นจากเกม
-- ชื่อที่โชว์ใน UI (ชื่อที่ส่งให้เซิร์ฟเวอร์ = คำแรก เช่น "Easy")
local DIFFICULTY_OPTIONS = { "Easy (E- Grade)", "Normal (E+ Grade)", "Hard (D+ Grade)", "Severe (B- Grade)", "Aberrant (A- Grade)" }
local MODIFIER_OPTIONS   = { "No Perks", "No Skills", "No Memories", "Nightmare", "Oddball", "Injury Prone", "Chronic Injuries", "Fog", "Glass Cannon", "Time Trial", "Boring", "Simple" }

do
    local MissionsSection = MissionsTab:PageSection({
        Title = "📜 Mission Settings",
        Subtitle = "Pick the mission, objective, difficulty and modifiers for your room."
    })
    local MissionForm = MissionsSection:Form()

    -- หมวดแยก: ปุ่มสร้าง/เริ่มห้องอัตโนมัติ (อยู่กลางระหว่าง Mission Settings กับ Advance Missions)
    local AutoMissionSection = MissionsTab:PageSection({
        Title = "🤖 Auto Mission",
        Subtitle = "Create your room first, then turn on Auto Start."
    })
    local AutoMissionForm = AutoMissionSection:Form()

    -- แถวแรกสุด: ดูสถานะล่าสุดได้ทันทีว่าสร้างห้องถูกหรือยัง
    local MissionStatusRow = MissionForm:Row()
    MissionStatusRow:Left():TitleStack({ Title = "Mission Status", Subtitle = "Current step and last result." })
    local MissionStatusLabel = MissionStatusRow:Right():Label({ Text = "Idle" })
    local STATUS_RED = Color3.fromRGB(255, 69, 58)
    local statusDefaultColor = nil
    pcall(function()
        local o = LabelObject(MissionStatusLabel)
        if o then statusDefaultColor = o.TextColor3 end
    end)
    -- isError = true -> ข้อความสีแดง (ข้อความปกติจะกลับเป็นสีเดิม)
    local function SetMissionStatus(text, isError)
        pcall(function() MissionStatusLabel.Text = tostring(text) end)
        pcall(function()
            local o = LabelObject(MissionStatusLabel)
            if not o then return end
            if isError then
                o.TextColor3 = STATUS_RED
            elseif statusDefaultColor then
                o.TextColor3 = statusDefaultColor
            end
        end)
    end

    -- ปิดสวิตช์ Auto Create (ใช้ตอนกด Leave หรือเปลี่ยนด่าน/ความยาก/Modifiers ที่ทำให้ห้องเดิมไม่ตรงแล้ว)
    -- สวิตช์ที่เปิดอยู่ระหว่างสร้างห้อง = ขั้นตอนถัดไปจะหยุดเอง
    local missionToggles = {}

    -- ตั้งสวิตช์บนหน้าจอด้วยโค้ด (ค่าใน Cfg เปลี่ยนตามเอง เพราะสวิตช์ผูกกับ Cfg อยู่แล้ว)
    local function SetMissionToggle(key, value)
        pcall(function() missionToggles[key].Value = value end)
    end

    -- ปิด Auto Create (ใช้เมื่อกด Leave / สร้างห้องไม่สำเร็จ / ความยากยังล็อกอยู่)
    local function ResetAutoCreate(reason, quiet)
        if not Cfg.AutoCreateMission then return end
        Cfg.AutoCreateMission = false
        Save()
        SetMissionToggle("AutoCreateMission", false)
        if not quiet and reason then SetMissionStatus("Auto Create off (" .. tostring(reason) .. ")") end
    end

    -- เปลี่ยนด่าน/ความยาก/Modifiers ตอน Auto Create เปิดอยู่ = สร้างห้องใหม่ให้ตรงค่าใหม่ (รอ 1.5 วิ กันกดรัว)
    local missionRecreateAt = nil
    local function RequestRecreate()
        if Cfg.AutoCreateMission then missionRecreateAt = os.clock() + 1.5 end
    end

    -- ───── ตรวจว่ามีห้องที่เราเป็นหัวหน้าอยู่จริงไหม (ใช้ล็อก Auto Start / Join Delay) ─────
    -- ห้องอยู่ที่ ReplicatedStorage.Missions (โค้ดเกมใช้ที่เดียวกัน) แต่ละห้องมีลูกชื่อ Leader ที่ .Value = ชื่อหัวหน้า
    -- และจำห้องที่สคริปต์เพิ่งสร้างไว้ด้วย (createdRoom) เผื่อโฟลเดอร์ไม่ตรง
    local createdRoom = nil
    local function MyRoomObject()
        local folder = ReplicatedStorage:FindFirstChild("Missions")
        if not folder then return nil end
        for _, room in ipairs(folder:GetChildren()) do
            local leader = room:FindFirstChild("Leader")
            if leader and leader:IsA("ValueBase") and leader.Value == LocalPlayer.Name then
                return room
            end
        end
        return nil
    end
    local function HasRoom()
        if createdRoom and createdRoom.Parent ~= nil then return true end
        return MyRoomObject() ~= nil
    end
    local missionStacks = {} -- key -> { stack = TitleStack, text = คำอธิบายเดิม } ใช้เปลี่ยนคำอธิบายเป็นสีแดง

    -- กันค่าที่เซฟไว้เพี้ยน (ชื่อที่ไม่มีในรายการ)
    local function KeepValid(options, value, fallback)
        return table.find(options, value) and value or fallback
    end
    local function KeepValidList(options, list)
        local out, seen = {}, {}
        if type(list) == "table" then
            for _, name in ipairs(list) do
                if table.find(options, name) and not seen[name] then
                    seen[name] = true
                    out[#out + 1] = name
                end
            end
        end
        return out
    end
    Cfg.MissionSelect = KeepValid(MISSION_OPTIONS, Cfg.MissionSelect, MISSION_OPTIONS[1])
    Cfg.MissionObjective = KeepValid(OBJECTIVE_OPTIONS, Cfg.MissionObjective, OBJECTIVE_OPTIONS[1])
    Cfg.MissionLevel = KeepValid(DIFFICULTY_OPTIONS, Cfg.MissionLevel, DIFFICULTY_OPTIONS[1])
    Cfg.MissionModifiers = KeepValidList(MODIFIER_OPTIONS, Cfg.MissionModifiers)

    -- เลือกได้ 1 อย่าง (Select Mission / Select Objective)
    local function AddSingleSelect(title, subtitle, options, key)
        local row = MissionForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        local btn = row:Right():PullDownButton({
            Label = Cfg[key],
            Options = options,
            Value = table.find(options, Cfg[key]) or 1,
            ValueChanged = function(self, index)
                if options[index] then
                    Cfg[key] = options[index]
                    self.Label = options[index]
                    Save()
                    RequestRecreate()
                end
            end
        })
        StyleDropdown(btn)
        UiSync.Add(function()
            local i = table.find(options, Cfg[key]) or 1
            btn.Value = i
            btn.Label = options[i]
        end)
    end

    -- เลือกได้หลายอย่าง (Select Difficulty / Select Modifiers)
    -- ใช้ PopUpButton (ติ๊กได้หลายข้อ) ถ้าไลบรารีไม่รองรับ จะถอยไปใช้แบบเลือกทีละอัน
    local function AddMultiSelect(title, subtitle, options, key)
        local row = MissionForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })

        local function apply(value)
            local indexes = type(value) == "table" and value or { value }
            local names = {}
            for _, index in ipairs(SettingsStore.ValidIndexes(indexes, #options)) do
                names[#names + 1] = options[index]
            end
            Cfg[key] = names
            Save()
            RequestRecreate()
        end

        local current = {}
        for i, name in ipairs(options) do
            if table.find(Cfg[key], name) then current[#current + 1] = i end
        end

        local ok, btn = pcall(function()
            return row:Right():PopUpButton({
                Options = options,
                Maximum = #options, -- ต้องกำหนดเกิน 1 ไลบรารีถึงจะเป็นโหมดติ๊กได้หลายอัน (ไม่ใส่ = เลือกได้ทีละอัน)
                Value = current,
                ValueChanged = function(self, value) apply(value) end
            })
        end)
        if not ok or not btn then
            btn = row:Right():PullDownButton({
                Label = Cfg[key][1] or "None",
                Options = options,
                Value = table.find(options, Cfg[key][1]) or 1,
                ValueChanged = function(self, index)
                    apply(index)
                    self.Label = options[index] or "None"
                end
            })
        end
        StyleDropdown(btn)
        UiSync.Add(function()
            if ok then
                local picked = {}
                for i, name in ipairs(options) do
                    if table.find(Cfg[key], name) then picked[#picked + 1] = i end
                end
                btn.Value = picked
            else
                local i = table.find(options, Cfg[key][1]) or 1
                btn.Value = i
                btn.Label = options[i]
            end
        end)
    end

    local function AddMissionToggle(title, subtitle, key, form, onChange)
        local row = (form or MissionForm):Row()
        missionStacks[key] = { stack = row:Left():TitleStack({ Title = title, Subtitle = subtitle }), text = subtitle }
        missionToggles[key] = UiSync.Link(row:Right():Toggle({
            Value = Cfg[key],
            ValueChanged = function(self, value)
                Cfg[key] = value and true or false
                Save()
                if onChange then onChange(Cfg[key]) end
            end
        }), Cfg, key)
    end

    -- สวิตช์ Auto Create / Auto Start เซฟลงไฟล์เหมือนสวิตช์อื่น แล้วเปิดค้างไว้ให้ตอนรันสคริปต์ใหม่ (ไม่ต้องกดซ้ำ)
    local initializing = true -- ช่วงสร้างหน้าจอ: ถ้าไลบรารียิง ValueChanged ตอนตั้งค่าเริ่มต้น จะไม่ไปสร้างห้องทับ
    local CreateRoomOnce -- (กำหนดค่าด้านล่าง)

    AddSingleSelect("Select Mission", "Choose the mission.", MISSION_OPTIONS, "MissionSelect")
    AddSingleSelect("Select Objective", "Only Skirmish for now.", OBJECTIVE_OPTIONS, "MissionObjective")
    AddSingleSelect("Select Difficulty", "Difficulty used when creating the room.", DIFFICULTY_OPTIONS, "MissionLevel")
    AddMultiSelect("Select Modifiers", "Tick the Modifiers to apply after creating.", MODIFIER_OPTIONS, "MissionModifiers")
    AddMissionToggle("Auto Create Mission", "Keeps a room ready with these settings. Remembered next time.", "AutoCreateMission", AutoMissionForm, function(on)
        if on then SetMissionToggle("AutoCreateRaid", false) end -- ห้องเดียวใช้ร่วมกัน: เปิดอันนี้ = ปิด Raid
        if on and not initializing then missionRecreateAt = os.clock() SH.autoPaused = false end
    end)
    AddMissionToggle("Auto Start Missions", "Starts the mission in your room. Remembered next time.", "AutoStartMission", AutoMissionForm, function(on)
        if on then SetMissionToggle("AutoStartRaid", false) end
    end)

    -- ───── Join Delay / สถานะ ─────
    local MissionDelayRow = AutoMissionForm:Row()
    local delaySubtitle = "Seconds between starts (" .. MIN_DELAY .. " - " .. MAX_DELAY .. ")."
    missionStacks.JoinDelay = {
        stack = MissionDelayRow:Left():TitleStack({ Title = "Join Delay", Subtitle = delaySubtitle }),
        text = delaySubtitle,
    }
    local MissionDelayRight = MissionDelayRow:Right()
    local MissionDelayLabel = MissionDelayRight:Label({ Text = Cfg.MissionJoinDelay .. "s" })
    UiSync.Link(MissionDelayRight:Slider({
        Minimum = MIN_DELAY,
        Maximum = MAX_DELAY,
        Value = Cfg.MissionJoinDelay,
        ValueChanged = function(self, value)
            Cfg.MissionJoinDelay = ClampDelay(value)
            pcall(function() MissionDelayLabel.Text = Cfg.MissionJoinDelay .. "s" end)
            Save()
        end
    }), Cfg, "MissionJoinDelay", function(_, want)
        pcall(function() MissionDelayLabel.Text = want .. "s" end)
    end)

    local MissionCountRow = AutoMissionForm:Row()
    MissionCountRow:Left():TitleStack({ Title = "Next Mission", Subtitle = "Countdown to the next start." })
    local MissionCountLabel = MissionCountRow:Right():Label({ Text = "Off" })
    local lastCountText = nil
    local function SetMissionCountdown(text)
        if text == lastCountText then return end
        lastCountText = text
        pcall(function() MissionCountLabel.Text = text end)
    end

    local function RefreshRoomGate() return HasRoom() end

    -- ───── ตรรกะ: สร้างห้อง (Create) แล้วเริ่ม (Start) ─────
    -- ค่าที่ส่งมาจาก Remote Spy ของคุณ:
    --   GET:InvokeServer("S_Missions", "Create", { Difficulty = "Easy", Type = "Missions", Objective = "Skirmish", Name = "Shiganshina" })
    --   GET:InvokeServer("S_Missions", "Start")
    local LOBBY_PLACE_ID = 14916516914
    local ON_LOBBY_PLACE = (game.PlaceId == LOBBY_PLACE_ID)
    local CALL_TIMEOUT = 8
    local START_GAP = 1.5 -- รอหลัง Create ก่อนสั่ง Start

    local missionRemote = nil
    local function MissionInvoke(...)
        if not missionRemote or not missionRemote.Parent then
            missionRemote = GetLobbyRemote()
        end
        if not missionRemote then return false, "remote not found" end
        local remote = missionRemote
        local args = table.pack(...)
        local done, ok, result = false, false, nil
        task.spawn(function()
            ok, result = pcall(function()
                return remote:InvokeServer(table.unpack(args, 1, args.n))
            end)
            done = true
        end)
        local t0 = os.clock()
        while not done and os.clock() - t0 < CALL_TIMEOUT do task.wait(0.1) end
        if not done then return false, "timeout" end
        return ok, result
    end

    local missionBusy = false
    local MODIFY_GAP = 0.17 -- เว้นช่วงระหว่าง Modify แต่ละอัน

    -- ออกจากห้อง (GET:InvokeServer("S_Missions", "Leave")) ใช้ตอนสร้างห้องผิด และก่อนสร้างห้องใหม่ทุกรอบ
    local function LeaveRoom(silent)
        if not ON_LOBBY_PLACE then
            if not silent then SetMissionStatus("Not in the lobby place") end
            return false
        end
        local ok, r = MissionInvoke("S_Missions", "Leave")
        if not silent then
            SetMissionStatus(ok and "Leave sent" or ("Leave failed: " .. tostring(r)))
        end
        return ok
    end

    -- จากโค้ดเกม (Missions.Create_Creation): Create ตอบกลับเป็น "วัตถุห้อง" (StringValue) ที่ .Value = ความยากที่เซิร์ฟเวอร์ตั้งให้จริง
    -- ถ้าเลือกความยากที่ยังไม่ปลดล็อก เซิร์ฟเวอร์จะลดให้เอง (เช่น เลือก Hard แต่ห้องได้ Normal) จึงเทียบ .Value กับที่เลือกได้เลย
    local function RoomServerDifficulty(room)
        if typeof(room) ~= "Instance" then return nil end
        local okV, value = pcall(function() return room.Value end)
        if okV and type(value) == "string" then return value end
        return nil
    end

    -- ชื่อแมพของห้องที่เกมคืนมา (room.Name = ชื่อแมพ) ใช้เช็กว่าได้แมพที่ขอจริงไหม
    local function RoomMapName(room)
        if typeof(room) ~= "Instance" then return nil end
        local okN, name = pcall(function() return room.Name end)
        if okN and type(name) == "string" then return name end
        return nil
    end

    -- ───── Auto Select Boost Mission / Auto Select Best Grade ─────
    -- ชื่อความยากแบบสั้น (คำแรกของตัวเลือก เช่น "Hard (D+ Grade)" -> "Hard") คือค่าที่เกมรับตอน Create
    local function DifficultyKey(label)
        return (label or ""):match("^(%S+)") or "Easy"
    end

    -- แมพที่กำลังมีบูสต์รางวัล: เกมเก็บไว้ที่ attribute ของ workspace (Boosted_Map = ชื่อแมพ, Boosted_Timer = วินาทีที่เหลือ)
    -- (จากโค้ดเกม Missions.Boost) ไม่มีบูสต์ / บูสต์ใกล้หมด / ไม่ใช่แมพในรายการของเรา = คืน nil
    -- คืน (ชื่อแมพ, วินาทีที่เหลือ|nil) ถ้าไม่มีบูสต์คืน nil
    -- ที่หลัก: workspace Boosted_Map / Boosted_Timer  | สำรอง: สแกน attribute ที่ชื่อมีคำว่า boost ใน workspace / ReplicatedStorage / ผู้เล่น
    -- (เผื่อเกมย้ายที่เก็บ) ค่าต้องเป็นชื่อแมพที่อยู่ในรายการของเราเท่านั้น
    local function BoostedMap()
        local function fromHolder(holder)
            local okA, attrs = pcall(function() return holder:GetAttributes() end)
            if not okA or type(attrs) ~= "table" then return nil end
            local name, left
            for k, v in pairs(attrs) do
                local lk = tostring(k):lower()
                if lk:find("boost") then
                    if type(v) == "string" and table.find(MISSION_OPTIONS, v) then name = v
                    elseif type(v) == "number" and (lk:find("time") or lk:find("left")) then left = v end
                end
            end
            return name, left
        end
        local name = workspace:GetAttribute("Boosted_Map")
        local left = workspace:GetAttribute("Boosted_Timer")
        if type(name) ~= "string" or not table.find(MISSION_OPTIONS, name) then
            name, left = nil, nil
            for _, holder in ipairs({ workspace, ReplicatedStorage, LocalPlayer }) do
                local n, l = fromHolder(holder)
                if n then name, left = n, l break end
            end
        end
        if not name then return nil end
        if type(left) == "number" and left <= 3 then return nil end
        return name, (type(left) == "number") and left or nil
    end

    -- ความยากสูงสุดที่เล่นได้: เซิร์ฟเวอร์เป็นคนตัดสิน (เลือกความยากที่ยังไม่ปลดล็อก มันจะลดให้เอง)
    -- จึงลองจากสูงสุดลงมาทีละขั้น จนห้องที่ได้ตรงกับที่ขอ ค่าที่ได้จำไว้ 10 นาที รอบถัดไปเริ่มจากค่านั้น (ลดจำนวนครั้งที่ยิง)
    local bestGradeCache = nil -- { key = "Hard", at = os.clock() }
    local BEST_CACHE_SECONDS = 600
    local function DifficultyCandidates()
        local list = {}
        for i = #DIFFICULTY_OPTIONS, 1, -1 do
            list[#list + 1] = DifficultyKey(DIFFICULTY_OPTIONS[i])
        end
        if bestGradeCache and os.clock() - bestGradeCache.at < BEST_CACHE_SECONDS then
            local start = table.find(list, bestGradeCache.key)
            if start then
                -- ลองสูงกว่าที่เคยได้ 1 ขั้นก่อนเสมอ: ถ้าเพิ่งปลดล็อกความยากใหม่ จะขยับขึ้นเองโดยไม่ต้องรอแคชหมดอายุ
                start = math.max(1, start - 1)
                local trimmed = {}
                for i = start, #list do trimmed[#trimmed + 1] = list[i] end
                return trimmed
            end
        end
        return list
    end

    -- Auto Create: สร้างห้องครั้งเดียวทันทีที่เปิดสวิตช์ (Leave > Create > Modify) ไม่ Start และไม่รอ Join Delay
    -- ปิดสวิตช์ระหว่างขั้นตอน = หยุดก่อนขั้นตอนถัดไป
    CreateRoomOnce = function(oneShot)
        if not ON_LOBBY_PLACE then SetMissionStatus("Not in the lobby place") return false end
        if missionBusy then SetMissionStatus("Busy - turn Auto Create off and on again") return false end
        missionBusy = true

        local function Off()
            if oneShot or Cfg.AutoCreateMission then return false end
            SetMissionStatus("Stopped (Auto Create turned off)")
            missionBusy = false
            return true
        end

        -- แมพที่จะลองตามลำดับ: เปิด Boost และมีแมพบูสต์ = ลองแมพนั้นก่อน แล้วถอยไปแมพที่เลือกไว้ (เผื่อแมพบูสต์ยังล็อกอยู่)
        local boosted = Cfg.AutoBoostMission and BoostedMap() or nil
        local maps = {}
        if boosted then maps[#maps + 1] = boosted end
        if boosted ~= Cfg.MissionSelect then maps[#maps + 1] = Cfg.MissionSelect end

        -- ความยาก: เปิด Best Grade = ลองสูงสุดลงมา / ไม่เปิด = ตามที่เลือกไว้
        local bestMode = Cfg.AutoBestGrade
        local fixedKey = DifficultyKey(Cfg.MissionLevel)

        local mapName, difficulty, room = nil, nil, nil
        local failMsg = nil

        for _, tryMap in ipairs(maps) do
            local keys = bestMode and DifficultyCandidates() or { fixedKey }
            local mapRejected = false
            for _, key in ipairs(keys) do
                -- ออกจากห้องเก่าก่อนทุกครั้ง (รวมห้องที่เพิ่งได้ความยากไม่ตรง) Modify เป็นการสลับ จึงไม่ควรยิงซ้ำในห้องเดิม
                SetMissionStatus(("Leaving old room... (%s)"):format(tryMap))
                LeaveRoom(true)
                task.wait(0.6)
                if Off() then return false end

                SetMissionStatus(("Creating %s (%s)%s%s..."):format(
                    tryMap, key, tryMap == boosted and " (boost)" or "", bestMode and " (best grade)" or ""))
                local ok, r = MissionInvoke("S_Missions", "Create", {
                    Difficulty = key,
                    Type = "Missions",
                    Objective = Cfg.MissionObjective,
                    Name = tryMap,
                })
                if not ok then
                    SetMissionStatus("Create failed: " .. tostring(r), true)
                    missionBusy = false
                    return false
                end
                if Off() then return false end

                -- เกมคืน nil เมื่อสร้างไม่สำเร็จ (Create_Creation: ถ้า nil จะไม่ทำอะไรต่อ)
                if r == nil or r == false then
                    failMsg = "Create refused (no room returned)"
                    mapRejected = true
                    break
                end

                -- ได้แมพอื่นกลับมา = แมพนี้ยังใช้ไม่ได้ (เช่นติด Prestige)
                local gotMap = RoomMapName(r)
                if gotMap and gotMap ~= tryMap then
                    failMsg = tryMap .. " is locked"
                    mapRejected = true
                    break
                end

                -- ความยากที่เซิร์ฟเวอร์ตั้งให้จริง ตรงที่ขอ = ใช้ได้ / ไม่ตรง = ยังไม่ปลดล็อก
                local gotKey = RoomServerDifficulty(r)
                if gotKey == nil or gotKey == key then
                    mapName, difficulty, room = tryMap, key, r
                    break
                end
                if not bestMode then
                    -- ความยากที่เลือกเองยังล็อกอยู่: แจ้งสีแดง ไม่แอบเปลี่ยนให้ และออกจากห้องที่ได้ความยากผิด (กัน Auto Start เริ่มผิดห้อง)
                    LeaveRoom(true)
                    ResetAutoCreate(nil, true)
                    SetMissionStatus(Cfg.MissionLevel .. " is locked", true)
                    missionBusy = false
                    return false
                end
                -- Best Grade: ความยากนี้ยังเล่นไม่ได้ ลองระดับที่ต่ำลงต่อ
            end
            if room then break end
            if not mapRejected then failMsg = failMsg or "No playable difficulty found" end
        end

        if not room then
            LeaveRoom(true)
            -- ไม่ปิด Auto Create ตรงนี้แล้ว: เพิ่งกลับมาล็อบบี้เซิร์ฟเวอร์อาจยังไม่พร้อมสร้างห้อง ให้ลูปด้านล่างลองใหม่เอง (ล้มเหลวหลายครั้งถึงจะหยุด)
            SetMissionStatus(failMsg or "Create refused (no room returned)", true)
            missionBusy = false
            return false
        end

        createdRoom = (typeof(room) == "Instance") and room or createdRoom
        if bestMode then bestGradeCache = { key = difficulty, at = os.clock() } end

        -- Modifiers: ยิง S_Missions / Modify / <ชื่อ> ทีละอันตามที่ติ๊กไว้ (ลำดับตามรายการ)
        local picked = {}
        for _, name in ipairs(MODIFIER_OPTIONS) do
            if table.find(Cfg.MissionModifiers, name) then picked[#picked + 1] = name end
        end
        for i, name in ipairs(picked) do
            SetMissionStatus(("Modifier %d/%d: %s"):format(i, #picked, name))
            local okM, rM = MissionInvoke("S_Missions", "Modify", name)
            if not okM then
                SetMissionStatus("Modify failed (" .. name .. "): " .. tostring(rM), true)
                missionBusy = false
                return false
            end
            task.wait(MODIFY_GAP)
            if Off() then return false end
        end

        SetMissionStatus(("Room created: %s%s / %s%s"):format(
            mapName, mapName == boosted and " (boost)" or "", difficulty, bestMode and " (best)" or ""))
        missionBusy = false
        return true
    end

    -- Auto Start: กด Start ในห้องที่อยู่ (ทำซ้ำทุก Join Delay ตราบที่เปิดสวิตช์)
    local function StartMission()
        if not ON_LOBBY_PLACE then SetMissionStatus("Not in the lobby place") return false end
        if missionBusy then return false end
        missionBusy = true
        SetMissionStatus("Starting mission...")
        local ok, r = MissionInvoke("S_Missions", "Start")
        SetMissionStatus(ok and "Start sent" or ("Start failed: " .. tostring(r)), not ok)
        missionBusy = false
        return ok
    end

    -- ปุ่ม Leave Room: ใช้เวลาสร้างห้องผิด
    local MissionLeaveRow = AutoMissionForm:Row()
    MissionLeaveRow:Left():TitleStack({ Title = "Leave Room", Subtitle = "Leave the current mission room." })
    local MissionLeaveBtn = MissionLeaveRow:Right():Button({ Label = "Leave", Callback = function() end })
    BindButton(MissionLeaveBtn, function()
        -- ออกจากห้อง = ห้องที่สร้างไว้ใช้ไม่ได้แล้ว: ปิด Auto Create (ถ้ากำลังสร้างอยู่จะหยุดเอง) แล้วค่อยออก
        ResetAutoCreate("left the room")
        SH.autoPaused = true -- กดออกจากห้องเอง = อย่าสร้างห้องใหม่ให้ทันที (จนกว่าจะสลับสวิตช์อีกครั้ง)
        task.spawn(function()
            local t0 = os.clock()
            while missionBusy and os.clock() - t0 < 10 do task.wait(0.1) end
            if missionBusy then SetMissionStatus("Busy - try again in a moment") return end
            LeaveRoom(false)
        end)
    end)

    -- ───── Auto Create: คอยดูแลให้มีห้องเสมอ (ตอนเปิดสวิตช์ / เปลี่ยนค่า / ห้องหาย / รันสคริปต์ใหม่) ─────
    task.spawn(function()
        local readyAt = os.clock() + 4 -- รอให้ล็อบบี้โหลดก่อน (ตอนรันสคริปต์ใหม่)
        local fails, nextTry = 0, 0
        while Alive() do
            task.wait(0.5)
            local now = os.clock()
            local bestOnly = (not Cfg.AutoCreateMission) and (Cfg.AutoBestGrade or Cfg.AutoBoostMission)
                and not Cfg.AutoCreateRaid and not Cfg.AutoStartRaid and not SH.autoPaused
            if ON_LOBBY_PLACE and (Cfg.AutoCreateMission or bestOnly) and not missionBusy and now >= readyAt then
                local need = false
                if missionRecreateAt and now >= missionRecreateAt then
                    missionRecreateAt = nil
                    need = true
                elseif now >= nextTry and not HasRoom() then
                    need = true
                end
                if need then
                    if CreateRoomOnce(bestOnly) then
                        fails = 0
                        nextTry = os.clock() + 20 -- กันสร้างซ้ำรัว ๆ ถ้าตรวจห้องไม่เจอ
                    elseif Cfg.AutoCreateMission or bestOnly then
                        fails += 1
                        nextTry = os.clock() + 6
                        if fails >= 5 then
                            fails = 0
                            if Cfg.AutoCreateMission then ResetAutoCreate(nil, true) else SH.autoPaused = true end
                            SetMissionStatus("Auto Create stopped (failed 5 times)", true)
                        end
                    end
                end
            end
        end
    end)

    -- ───── Auto Start: รอให้มีห้อง แล้วกด Start ทุก Join Delay (สวิตช์ไม่เด้งปิดเอง) ─────
    task.spawn(function()
        local lastFire = nil
        while Alive() do
            local hasRoom = HasRoom()
            if not ON_LOBBY_PLACE then
                lastFire = nil
                SetMissionCountdown("Wrong place")
            elseif not Cfg.AutoStartMission then
                lastFire = nil
                SetMissionCountdown("Off")
            elseif not hasRoom then
                lastFire = nil
                SetMissionCountdown("Waiting for room...")
            else
                local now = os.clock()
                local delay = ClampDelay(Cfg.MissionJoinDelay)
                if not lastFire then lastFire = now end
                local remaining = lastFire + delay - now
                if remaining <= 0 then
                    SetMissionCountdown("Starting now...")
                    StartMission()
                    lastFire = os.clock() -- แล้วค่อยเริ่มนับ Join Delay ใหม่จาก "ตอนจบรอบ"
                else
                    SetMissionCountdown(("Next mission in %ds"):format(math.ceil(remaining)))
                end
            end
            task.wait(0.25)
        end
    end)

    -- ───── Advance Missions (หมวดแยก อยู่ล่าง Mission Settings) ─────
    local AdvMissionsSection = MissionsTab:PageSection({
        Title = "🚀 Advance Missions",
        Subtitle = "Auto-pick the best grade or boost mission."
    })
    local AdvMissionsForm = AdvMissionsSection:Form()
    -- สลับสวิตช์ตอน Auto Create เปิดอยู่ = สร้างห้องใหม่ให้ตรงค่าใหม่ (RequestRecreate เช็กเองว่า Auto Create เปิดไหม)
    -- เปิด Best Grade / Boost เองโดยไม่ต้องเปิด Auto Create ก็ได้: สร้างห้องให้ 1 ครั้งทันที (ไม่ Start)
    local function OnAdvanceToggle(on)
        if initializing then return end
        SH.autoPaused = false
        bestGradeCache = nil -- เผื่อเพิ่งปลดล็อกความยากใหม่ ให้ลองจากสูงสุดอีกรอบ
        if Cfg.AutoCreateMission then
            RequestRecreate()
        elseif on then
            task.spawn(function()
                local t0 = os.clock()
                while missionBusy and os.clock() - t0 < 10 do task.wait(0.1) end
                CreateRoomOnce(true)
            end)
        end
    end
    AddMissionToggle("Auto Select Best Grade", "Creates the highest difficulty you can play.", "AutoBestGrade", AdvMissionsForm, OnAdvanceToggle)
    AddMissionToggle("Auto Select Boost Mission", "Creates the map that has the reward boost now.", "AutoBoostMission", AdvMissionsForm, OnAdvanceToggle)

    -- แถวแสดงผลสด: แมพบูสต์ตอนนี้ / ความยากสูงสุดที่เจอล่าสุด
    local BoostInfoRow = AdvMissionsForm:Row()
    BoostInfoRow:Left():TitleStack({ Title = "Boost Now", Subtitle = "Map with the reward boost right now." })
    local BoostInfoLabel = BoostInfoRow:Right():Label({ Text = "-" })
    local BestInfoRow = AdvMissionsForm:Row()
    BestInfoRow:Left():TitleStack({ Title = "Best Grade Found", Subtitle = "Highest difficulty the last room got." })
    local BestInfoLabel = BestInfoRow:Right():Label({ Text = "-" })
    task.spawn(function()
        local lastB, lastG
        while Alive() do
            local m, left = BoostedMap()
            local b = "No boost"
            if m then
                b = m
                if left then b = ("%s (%d:%02d)"):format(m, math.floor(left / 60), math.floor(left % 60)) end
            end
            local g = bestGradeCache and bestGradeCache.key or "-"
            if b ~= lastB then lastB = b pcall(function() BoostInfoLabel.Text = b end) end
            if g ~= lastG then lastG = g pcall(function() BestInfoLabel.Text = g end) end
            task.wait(1)
        end
    end)

    -- บูสต์เปลี่ยนไปแมพอื่น (เกมสลับเป็นช่วงๆ) = สร้างห้องใหม่ที่แมพบูสต์ตัวใหม่ (เฉพาะตอนเปิด Boost + Auto Create)
    pcall(function()
        workspace:GetAttributeChangedSignal("Boosted_Map"):Connect(function()
            if not Alive() or initializing or not Cfg.AutoBoostMission then return end
            RequestRecreate()
        end)
    end)

    -- ───── ตอนรันสคริปต์: สวิตช์ที่เคยเปิดไว้ยังเปิดค้างอยู่และทำงานต่อเอง ─────
    if not canSave then
        SetMissionStatus("Can't save settings (executor has no file access)", true)
    elseif Cfg.AutoCreateMission or Cfg.AutoStartMission then
        if ON_LOBBY_PLACE then
            SetMissionStatus("Resuming your saved Auto switches...")
        else
            SetMissionStatus("Saved Auto switches will run in the lobby place")
        end
    end

    -- ห่อโค้ด Raid ไว้ในฟังก์ชันของตัวเอง: Lua จำกัดตัวแปร local ได้ 200 ตัวต่อฟังก์ชัน ส่วนนี้จึงไม่ไปรวมกับของ Mission
    ;(function()
    -- ═════════════════════════════════════════════════════════
    -- ⚔️ RAID MODE: สร้าง/เริ่มห้อง Raid (ใช้ Remote เดียวกับ Mission: S_Missions Create / Start / Leave)
    -- ค่าที่ส่งมาจาก Remote Spy ของคุณ (Type = "Raids"):
    --   Attack Titan  -> Name "Trost"       | Hard ขึ้นไป
    --   Armored Titan -> Name "Shiganshina" | Hard ขึ้นไป
    --   Female Titan  -> Name "Stohess"     | Hard ขึ้นไป
    --   Colossal Titan-> Name "Shiganshina" | Aberrant เท่านั้น + Minimum = 3
    -- ═════════════════════════════════════════════════════════
    local RAIDS = {
        { name = "Attack Titan",   map = "Trost",       diffs = { "Hard", "Severe", "Aberrant" } },
        { name = "Armored Titan",  map = "Shiganshina", diffs = { "Hard", "Severe", "Aberrant" } },
        { name = "Female Titan",   map = "Stohess",     diffs = { "Hard", "Severe", "Aberrant" } },
        { name = "Colossal Titan", map = "Shiganshina", diffs = { "Aberrant" }, minimum = 3 },
    }
    local RAID_NAMES = {}
    for i, r in ipairs(RAIDS) do RAID_NAMES[i] = r.name end
    local RAID_DIFF_LABELS = { "Hard (C- Grade)", "Severe", "Aberrant (A Grade)" }

    local function RaidInfo(name)
        for _, r in ipairs(RAIDS) do if r.name == name then return r end end
        return RAIDS[1]
    end
    -- ความยากที่ใช้จริง: ค่าที่เลือก ถ้า Raid นี้ไม่รองรับ (เช่น Colossal) = ความยากแรกที่รองรับ
    local function RaidDifficulty()
        local info = RaidInfo(Cfg.RaidSelect)
        if table.find(info.diffs, Cfg.RaidLevel) then return Cfg.RaidLevel end
        return info.diffs[#info.diffs]
    end
    Cfg.RaidSelect = KeepValid(RAID_NAMES, Cfg.RaidSelect, RAID_NAMES[1])
    Cfg.RaidModifiers = KeepValidList(MODIFIER_OPTIONS, Cfg.RaidModifiers)
    if not table.find({ "Hard", "Severe", "Aberrant" }, Cfg.RaidLevel) then Cfg.RaidLevel = "Hard" end

    local RaidSection = RaidModeTab:PageSection({
        Title = "⚔️ Raid Settings",
        Subtitle = "Raids start at Hard. Colossal Titan is Aberrant only."
    })
    local RaidForm = RaidSection:Form()
    local RaidAutoSection = RaidModeTab:PageSection({
        Title = "🤖 Auto Raid",
        Subtitle = "Create your raid room first, then turn on Auto Start."
    })
    local RaidAutoForm = RaidAutoSection:Form()

    local RaidStatusRow = RaidForm:Row()
    RaidStatusRow:Left():TitleStack({ Title = "Raid Status", Subtitle = "Current step and last result." })
    local RaidStatusLabel = RaidStatusRow:Right():Label({ Text = "Idle" })
    local raidDefaultColor = nil
    pcall(function()
        local o = LabelObject(RaidStatusLabel)
        if o then raidDefaultColor = o.TextColor3 end
    end)
    local function SetRaidStatus(text, isError)
        pcall(function() RaidStatusLabel.Text = tostring(text) end)
        pcall(function()
            local o = LabelObject(RaidStatusLabel)
            if not o then return end
            if isError then o.TextColor3 = STATUS_RED
            elseif raidDefaultColor then o.TextColor3 = raidDefaultColor end
        end)
    end

    local raidRecreateAt = nil
    local function RequestRaidRecreate()
        if Cfg.AutoCreateRaid then raidRecreateAt = os.clock() + 1.5 end
    end
    local function ResetAutoCreateRaid(quiet)
        if not Cfg.AutoCreateRaid then return end
        Cfg.AutoCreateRaid = false
        Save()
        SetMissionToggle("AutoCreateRaid", false)
    end

    -- เลือก Raid (1 อย่าง) / ความยาก (1 อย่าง)
    local raidDiffNote
    local function AddRaidSelect(title, subtitle, options, getValue, setValue)
        local row = RaidForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        local btn = row:Right():PullDownButton({
            Label = getValue(),
            Options = options,
            Value = table.find(options, getValue()) or 1,
            ValueChanged = function(self, index)
                if options[index] then
                    setValue(options[index])
                    self.Label = options[index]
                    Save()
                    RequestRaidRecreate()
                end
            end
        })
        StyleDropdown(btn)
        local function refresh()
            local i = table.find(options, getValue()) or 1
            pcall(function() btn.Value = i btn.Label = options[i] end)
        end
        UiSync.Add(refresh)
        return refresh
    end
    local refreshRaidLevel = function() end
    AddRaidSelect("Select Raid", "Choose the raid boss.", RAID_NAMES,
        function() return Cfg.RaidSelect end,
        function(v) Cfg.RaidSelect = v task.defer(function() refreshRaidLevel() end) end)
    local function RaidLevelLabel()
        for i, k in ipairs({ "Hard", "Severe", "Aberrant" }) do
            if k == RaidDifficulty() then return RAID_DIFF_LABELS[i] end
        end
        return RAID_DIFF_LABELS[1]
    end
    refreshRaidLevel = AddRaidSelect("Select Difficulty", "Colossal Titan always uses Aberrant.", RAID_DIFF_LABELS,
        RaidLevelLabel,
        function(v) Cfg.RaidLevel = v:match("^(%S+)") or "Hard" end)

    -- Select Modifiers (ติ๊กได้หลายอัน) ชุดเดียวกับ Mission: ยิง S_Missions / Modify / <ชื่อ> หลังสร้างห้อง
    do
        local row = RaidForm:Row()
        row:Left():TitleStack({ Title = "Select Modifiers", Subtitle = "Tick the Modifiers to apply after creating." })
        local function apply(value)
            local indexes = type(value) == "table" and value or { value }
            local names = {}
            for _, index in ipairs(SettingsStore.ValidIndexes(indexes, #MODIFIER_OPTIONS)) do
                names[#names + 1] = MODIFIER_OPTIONS[index]
            end
            Cfg.RaidModifiers = names
            Save()
            RequestRaidRecreate()
        end
        local current = {}
        for i, name in ipairs(MODIFIER_OPTIONS) do
            if table.find(Cfg.RaidModifiers, name) then current[#current + 1] = i end
        end
        local ok, btn = pcall(function()
            return row:Right():PopUpButton({
                Options = MODIFIER_OPTIONS,
                Maximum = #MODIFIER_OPTIONS,
                Value = current,
                ValueChanged = function(self, value) apply(value) end
            })
        end)
        if not ok or not btn then
            btn = row:Right():PullDownButton({
                Label = Cfg.RaidModifiers[1] or "None",
                Options = MODIFIER_OPTIONS,
                Value = table.find(MODIFIER_OPTIONS, Cfg.RaidModifiers[1]) or 1,
                ValueChanged = function(self, index)
                    apply(index)
                    self.Label = MODIFIER_OPTIONS[index] or "None"
                end
            })
        end
        StyleDropdown(btn)
        UiSync.Add(function()
            if ok then
                local picked = {}
                for i, name in ipairs(MODIFIER_OPTIONS) do
                    if table.find(Cfg.RaidModifiers, name) then picked[#picked + 1] = i end
                end
                btn.Value = picked
            else
                local i = table.find(MODIFIER_OPTIONS, Cfg.RaidModifiers[1]) or 1
                btn.Value = i
                btn.Label = MODIFIER_OPTIONS[i]
            end
        end)
    end

    -- สร้างห้อง Raid 1 ครั้ง: Leave > Create (ไม่ Start) | oneShot = ไม่ผูกกับสวิตช์ Auto Create
    local function CreateRaidOnce(oneShot)
        if not ON_LOBBY_PLACE then SetRaidStatus("Not in the lobby place") return false end
        if missionBusy then SetRaidStatus("Busy - try again in a moment") return false end
        missionBusy = true

        local info = RaidInfo(Cfg.RaidSelect)
        local diff = RaidDifficulty()

        SetRaidStatus("Leaving old room...")
        LeaveRoom(true)
        task.wait(0.6)
        if not oneShot and not Cfg.AutoCreateRaid then
            SetRaidStatus("Stopped (Auto Create turned off)")
            missionBusy = false
            return false
        end

        SetRaidStatus(("Creating %s (%s)..."):format(info.name, diff))
        local args = { Difficulty = diff, Type = "Raids", Objective = info.name, Name = info.map }
        if info.minimum then args.Minimum = info.minimum end
        local ok, r = MissionInvoke("S_Missions", "Create", args)
        if not ok then
            SetRaidStatus("Create failed: " .. tostring(r), true)
            missionBusy = false
            return false
        end
        if r == nil or r == false then
            LeaveRoom(true)
            ResetAutoCreateRaid(true)
            SetRaidStatus("Create refused (locked or no room returned)", true)
            missionBusy = false
            return false
        end
        -- เซิร์ฟเวอร์ลดความยากให้เองถ้ายังไม่ปลดล็อก: ได้ความยากไม่ตรงที่ขอ = ใช้ไม่ได้
        local got = RoomServerDifficulty(r)
        if got ~= nil and got ~= diff then
            LeaveRoom(true)
            ResetAutoCreateRaid(true)
            SetRaidStatus(("%s (%s) is locked"):format(info.name, diff), true)
            missionBusy = false
            return false
        end
        createdRoom = (typeof(r) == "Instance") and r or createdRoom

        local picked = {}
        for _, name in ipairs(MODIFIER_OPTIONS) do
            if table.find(Cfg.RaidModifiers, name) then picked[#picked + 1] = name end
        end
        for i, name in ipairs(picked) do
            SetRaidStatus(("Modifier %d/%d: %s"):format(i, #picked, name))
            local okM, rM = MissionInvoke("S_Missions", "Modify", name)
            if not okM then
                SetRaidStatus("Modify failed (" .. name .. "): " .. tostring(rM), true)
                missionBusy = false
                return false
            end
            task.wait(MODIFY_GAP)
            if not oneShot and not Cfg.AutoCreateRaid then
                SetRaidStatus("Stopped (Auto Create turned off)")
                missionBusy = false
                return false
            end
        end
        SetRaidStatus(("Room created: %s / %s"):format(info.name, diff))
        missionBusy = false
        return true
    end

    local function StartRaid()
        if not ON_LOBBY_PLACE then SetRaidStatus("Not in the lobby place") return false end
        if missionBusy then return false end
        missionBusy = true
        SetRaidStatus("Starting raid...")
        local ok, r = MissionInvoke("S_Missions", "Start")
        local note = ""
        if ok and type(r) == "string" and r ~= "" then note = " (" .. r .. ")" end
        local info = RaidInfo(Cfg.RaidSelect)
        if ok and info.minimum then note = note .. " | needs " .. info.minimum .. "+ players" end
        SetRaidStatus(ok and ("Start sent" .. note) or ("Start failed: " .. tostring(r)), not ok)
        missionBusy = false
        return ok
    end

    -- สวิตช์ Auto Create / Auto Start ของ Raid (ห้องเดียวกับ Mission จึงเปิดคู่กันไม่ได้)
    AddMissionToggle("Auto Create Raid", "Keeps a raid room ready with these settings. Remembered next time.", "AutoCreateRaid", RaidAutoForm, function(on)
        if on then SetMissionToggle("AutoCreateMission", false) end
        if on and not initializing then raidRecreateAt = os.clock() end
    end)
    AddMissionToggle("Auto Start Raid", "Starts the raid in your room. Remembered next time.", "AutoStartRaid", RaidAutoForm, function(on)
        if on then SetMissionToggle("AutoStartMission", false) end
    end)

    local RaidDelayRow = RaidAutoForm:Row()
    RaidDelayRow:Left():TitleStack({ Title = "Join Delay", Subtitle = "Seconds between starts (" .. MIN_DELAY .. " - " .. MAX_DELAY .. ")." })
    local RaidDelayRight = RaidDelayRow:Right()
    local RaidDelayLabel = RaidDelayRight:Label({ Text = Cfg.RaidJoinDelay .. "s" })
    UiSync.Link(RaidDelayRight:Slider({
        Minimum = MIN_DELAY,
        Maximum = MAX_DELAY,
        Value = Cfg.RaidJoinDelay,
        ValueChanged = function(self, value)
            Cfg.RaidJoinDelay = ClampDelay(value)
            pcall(function() RaidDelayLabel.Text = Cfg.RaidJoinDelay .. "s" end)
            Save()
        end
    }), Cfg, "RaidJoinDelay", function(_, want)
        pcall(function() RaidDelayLabel.Text = want .. "s" end)
    end)

    local RaidCountRow = RaidAutoForm:Row()
    RaidCountRow:Left():TitleStack({ Title = "Next Raid", Subtitle = "Countdown to the next start." })
    local RaidCountLabel = RaidCountRow:Right():Label({ Text = "Off" })
    local lastRaidCount = nil
    local function SetRaidCountdown(text)
        if text == lastRaidCount then return end
        lastRaidCount = text
        pcall(function() RaidCountLabel.Text = text end)
    end

    local RaidLeaveRow = RaidAutoForm:Row()
    RaidLeaveRow:Left():TitleStack({ Title = "Leave Room", Subtitle = "Leave the current raid room." })
    local RaidLeaveBtn = RaidLeaveRow:Right():Button({ Label = "Leave", Callback = function() end })
    BindButton(RaidLeaveBtn, function()
        ResetAutoCreateRaid(true)
        task.spawn(function()
            local t0 = os.clock()
            while missionBusy and os.clock() - t0 < 10 do task.wait(0.1) end
            if missionBusy then SetRaidStatus("Busy - try again in a moment") return end
            local okL = LeaveRoom(true)
            SetRaidStatus(okL and "Leave sent" or "Leave failed", not okL)
        end)
    end)

    -- Auto Create Raid: คอยดูแลให้มีห้อง (เปิดสวิตช์ / เปลี่ยนค่า / ห้องหาย / รันใหม่)
    task.spawn(function()
        local readyAt = os.clock() + 4
        local fails, nextTry = 0, 0
        while Alive() do
            task.wait(0.5)
            local now = os.clock()
            if ON_LOBBY_PLACE and Cfg.AutoCreateRaid and not missionBusy and now >= readyAt then
                local need = false
                if raidRecreateAt and now >= raidRecreateAt then
                    raidRecreateAt = nil
                    need = true
                elseif now >= nextTry and not HasRoom() then
                    need = true
                end
                if need then
                    if CreateRaidOnce(false) then
                        fails = 0
                        nextTry = os.clock() + 20
                    elseif Cfg.AutoCreateRaid then
                        fails += 1
                        nextTry = os.clock() + 8
                        if fails >= 3 then
                            fails = 0
                            ResetAutoCreateRaid(true)
                            SetRaidStatus("Auto Create stopped (failed 3 times)", true)
                        end
                    end
                end
            end
        end
    end)

    -- Auto Start Raid: มีห้องแล้วกด Start ทุก Join Delay
    task.spawn(function()
        local lastFire = nil
        while Alive() do
            local hasRoom = HasRoom()
            if not ON_LOBBY_PLACE then
                lastFire = nil
                SetRaidCountdown("Wrong place")
            elseif not Cfg.AutoStartRaid then
                lastFire = nil
                SetRaidCountdown("Off")
            elseif not hasRoom then
                lastFire = nil
                SetRaidCountdown("Waiting for room...")
            else
                local now = os.clock()
                local delay = ClampDelay(Cfg.RaidJoinDelay)
                if not lastFire then lastFire = now end
                local remaining = lastFire + delay - now
                if remaining <= 0 then
                    SetRaidCountdown("Starting now...")
                    StartRaid()
                    lastFire = os.clock()
                else
                    SetRaidCountdown(("Next raid in %ds"):format(math.ceil(remaining)))
                end
            end
            task.wait(0.25)
        end
    end)


    -- ═════════════════════════════════════════════════════════
    -- 🎁 Raid Extras: Auto Skip Cutscene (ตัวลูปอยู่ในส่วน Farm) + Auto Open Chest (กดปุ่ม OPEN จริง ไม่ใช้ Remote)
    -- กดปุ่มบนหน้าจอเหมือนผู้เล่น จึงเห็นแอนิเมชันเปิดกล่องและของที่ได้ครบ
    -- ═════════════════════════════════════════════════════════
    ;(function()
        local ExtraForm = RaidModeTab:PageSection({
            Title = "🎁 Raid Extras",
            Subtitle = "Skip cutscenes and open the reward chest by pressing the real buttons."
        }):Form()

        AddMissionToggle("Auto Skip Cutscene", "Presses SKIP [E] on cutscenes once your character has loaded.", "AutoSkipCutscene", ExtraForm)
        do
            local row = ExtraForm:Row()
            row:Left():TitleStack({ Title = "Skip Cutscene Status", Subtitle = "What Auto Skip Cutscene is doing." })
            local label = row:Right():Label({ Text = "Off" })
            local last = nil
            function Farm.SetSkipStatus(text)
                text = tostring(text)
                if text == last then return end
                last = text
                pcall(function() label.Text = text end)
            end
        end

        AddMissionToggle("Auto Open Chest (Free)", "Presses OPEN on the Free chest when the chest screen shows.", "AutoOpenChestFree", ExtraForm)
        AddMissionToggle("Auto Open Chest (Premium)", "Presses OPEN on the Premium chest. Only turn on if you want to open it.", "AutoOpenChestPremium", ExtraForm)

        AddMissionToggle("Auto Finish Chest", "Presses FINISH after the chests you selected are opened.", "AutoFinishChest", ExtraForm)

        local chestLabel
        do
            local row = ExtraForm:Row()
            row:Left():TitleStack({ Title = "Chest Status", Subtitle = "What Auto Open Chest sees right now." })
            chestLabel = row:Right():Label({ Text = "Off" })
        end
        local lastChestText = nil
        local function SetChest(text)
            text = tostring(text)
            if text == lastChestText then return end
            lastChestText = text
            pcall(function() chestLabel.Text = text end)
        end

        -- ปุ่ม OPEN ที่เห็นอยู่ + ชนิดกล่อง (เดาจากชื่อชั้นบน ๆ ของปุ่ม ถ้าไม่มีคำว่า Premium / Free = ไม่รู้)
        local function PathOf(obj)
            local names, cur = {}, obj
            while cur and cur ~= PlayerGui and cur ~= game do
                table.insert(names, 1, cur.Name)
                cur = cur.Parent
            end
            return table.concat(names, ".")
        end
        local function ChestButtons()
            local found = {}
            for _, d in ipairs(PlayerGui:GetDescendants()) do
                if IsTextObj(d) and IsShown(d) and (function()
                    -- ป้ายปุ่มเปลี่ยนเป็น "OPEN (3)" หลังเปิดไปแล้ว (เลขคือจำนวนครั้งที่เหลือ) จึงรับทั้ง "OPEN" และ "OPEN (n)"
                    local t = TextOf(d)
                    return t == "OPEN" or t:match("^OPEN%s*%(%d+%)$") ~= nil
                end)() then
                    local btn = d
                    while btn and btn ~= PlayerGui and not btn:IsA("GuiButton") do btn = btn.Parent end
                    if btn and btn ~= PlayerGui then
                        local path = PathOf(btn):lower()
                        local kind = "Unknown"
                        if path:find("premium") then kind = "Premium" elseif path:find("free") then kind = "Free" end
                        -- "OPEN (n)": n = กุญแจที่เหลือ | n = 0 = กุญแจหมด กดไปก็ขึ้น "You're keyless."
                        local n = TextOf(d):match("%((%d+)%)")
                        found[#found + 1] = { btn = btn, kind = kind, path = PathOf(btn), empty = (n ~= nil and tonumber(n) == 0) }
                    end
                end
            end
            return found
        end

        local FinishButton -- (กำหนดค่าด้านล่าง)
        if SH.DEV then -- 🔒 ปุ่ม Copy Chest Debug: ซ่อนไว้ โชว์เฉพาะตอนพัฒนาเอง (SH.DEV = true)
            local copyRow = ExtraForm:Row()
            copyRow:Left():TitleStack({ Title = "Copy Chest Debug", Subtitle = "Copies the OPEN buttons it can see (send this if a chest is not opened)." })
            local copyBtn = copyRow:Right():Button({ Label = "Copy", Callback = function() end })
            BindButton(copyBtn, function()
                local lines = {}
                for _, b in ipairs(ChestButtons()) do lines[#lines + 1] = b.kind .. " | " .. b.path end
                local fb = FinishButton and FinishButton()
                lines[#lines + 1] = fb and ("FINISH | " .. PathOf(fb)) or "FINISH | not visible"
                local text = table.concat(lines, "\n")
                pcall(function() setclipboard(text) end)
                SetChest(#lines > 0 and ("Copied " .. #lines .. " button(s)") or "No visible OPEN button")
            end)
        end

        -- ปุ่ม FINISH (ปิดหน้ากล่อง) : ข้อความตรงตัว "FINISH" เท่านั้น
        FinishButton = function()
            for _, d in ipairs(PlayerGui:GetDescendants()) do
                if IsTextObj(d) and IsShown(d) and TextOf(d):match("^FINISH") then
                    local btn = d
                    while btn and btn ~= PlayerGui and not btn:IsA("GuiButton") do btn = btn.Parent end
                    if btn and btn ~= PlayerGui then return btn end
                end
            end
            return nil
        end

        task.spawn(function()
            local opened, lastPress = 0, {}
            local screenSince, lastAction = nil, 0 -- เวลาที่เห็นปุ่ม FINISH ครั้งแรกในหน้ากล่องนี้ / เวลาที่กดล่าสุด
            local GAP = 5          -- เว้นต่อกล่องเดียวกันอย่างน้อยกี่วินาที: ให้เห็นแอนิเมชันและของที่ได้
            local FINISH_WAIT = 4  -- ไม่มีปุ่ม OPEN ที่ต้องกดเหลือ และเว้นจากการกดล่าสุดนานเท่านี้ ค่อยกด FINISH
            while Alive() do
                task.wait(0.7)
                local wantFree, wantPremium, wantFinish = Cfg.AutoOpenChestFree, Cfg.AutoOpenChestPremium, Cfg.AutoFinishChest
                if not (wantFree or wantPremium) then
                    SetChest("Off")
                else
                    local all = ChestButtons()
                    -- ปุ่มที่กุญแจหมด (OPEN (0)) ไม่ต้องกดอีก ถือว่าจบกล่องนั้นแล้ว (ไปกด FINISH ต่อได้)
                    local list, emptyCount = {}, 0
                    for _, b in ipairs(all) do
                        if b.empty then emptyCount += 1 else list[#list + 1] = b end
                    end
                    local pressable = false -- มีปุ่ม OPEN ที่เลือกไว้และยังเหลืออยู่ไหม
                    for _, b in ipairs(list) do
                        if (b.kind == "Free" and wantFree) or (b.kind == "Premium" and wantPremium)
                            or (b.kind == "Unknown" and wantFree and wantPremium) then
                            pressable = true
                        end
                    end

                    if pressable then
                        for _, b in ipairs(list) do
                            local okKind = (b.kind == "Free" and wantFree) or (b.kind == "Premium" and wantPremium)
                                or (b.kind == "Unknown" and wantFree and wantPremium)
                            if okKind and os.clock() - (lastPress[b.kind] or 0) >= GAP then
                                lastPress[b.kind] = os.clock()
                                lastAction = os.clock()
                                SetChest("Opening " .. b.kind .. " chest...")
                                pcall(ActivateButton, b.btn)
                                opened += 1
                                break
                            end
                        end
                    else
                        local fin = FinishButton()
                        if fin and not screenSince then screenSince = os.clock() end
                        if not fin then
                            screenSince = nil
                            if #list == 0 and emptyCount > 0 then
                                SetChest("No keys left - nothing to open")
                            elseif #list == 0 then
                                SetChest(opened > 0 and ("Waiting for chest (opened " .. opened .. ")") or "Waiting for chest")
                            else
                                local unknown = false
                                for _, b in ipairs(list) do if b.kind == "Unknown" then unknown = true end end
                                SetChest(unknown and "OPEN found but can't tell Free / Premium (use Copy)" or "OPEN found (not selected)")
                            end
                        elseif not wantFinish then
                            SetChest(emptyCount > 0 and "No keys left - Auto Finish is off" or ("Chests done (opened %d) - Auto Finish is off"):format(opened))
                        elseif os.clock() - math.max(lastAction, screenSince or os.clock()) >= FINISH_WAIT then
                            SetChest("Finishing...")
                            lastAction = os.clock()
                            pcall(ActivateButton, fin)
                            -- ปุ่มยังอยู่ = Enter/กรอบฟ้าไม่ติด: ลองกดด้วยเมาส์จริงที่กลางปุ่มเป็นตัวสำรอง
                            task.wait(0.5)
                            if fin.Parent and IsShown(fin) then
                                pcall(function()
                                    local pos, size = fin.AbsolutePosition, fin.AbsoluteSize
                                    local inset = GuiService:GetGuiInset()
                                    local cx, cy = pos.X + size.X / 2, pos.Y + size.Y / 2 + inset.Y
                                    VirtualInputManager:SendMouseMoveEvent(cx, cy, game)
                                    VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
                                    task.wait(0.05)
                                    VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
                                end)
                            end
                        else
                            SetChest("Chests opened - finishing soon...")
                        end
                    end
                end
            end
        end)
    end)()

    -- ═════════════════════════════════════════════════════════
    -- 🏰 Colossal Titan (ไททัน 60 เมตร): ปืนใหญ่บนกำแพง  (เขียนใหม่ตามโค้ด phase 1 ของ Kira: ยังไม่ได้ทดสอบกับเกมจริง)
    --   1) ขึ้นปืน  GET:InvokeServer("Cannon","State", ปืน, true)
    --   2) ยิง      GET:InvokeServer("Cannon","Shoot", {BarrelWood = 40, Base = 0})   (มุมคงที่ เกมไม่ได้ใช้มุมนี้ตัดสินความเสียหาย)
    --   3) เซิร์ฟเวอร์ส่งอีเวนต์ POST.OnClientEvent("Skills","Impact", วัตถุลูกปืน) กลับมา
    --      -> ส่ง POST:FireServer("S_Skills","Impact", วัตถุลูกปืน, ตำแหน่งท้ายทอย Colossal) รัว 30 ครั้ง
    --   4) วนซ้ำทุก ~2.1 วินาที จนกว่า ReplicatedStorage.Objectives.Stall_Colossal_Titan.Value >= Requirement (Stall Bertholdt สำเร็จ)
    -- ไม่ต้องบินไปที่ปืน และไม่ล็อกตัวละคร: Auto Farm ฟันไททันตัวเล็กปกป้องฐานไปพร้อมกันได้ (Auto Farm ไม่แตะ Colossal ตอนเปิด Auto Cannon)
    -- ═════════════════════════════════════════════════════════
    ;(function()
        local SHOOT_ARGS = { BarrelWood = 40, Base = 0 }
        local IMPACT_BURST = 30

        local Form = RaidModeTab:PageSection({
            Title = "🏰 Colossal Titan",
            Subtitle = "Shoots the wall cannon at the Colossal Titan's nape."
        }):Form()

        AddMissionToggle("Auto Cannon (Colossal Titan)", "Phase 1: mounts the wall cannon and shoots the Colossal Titan until the cutscene (Stall Bertholdt complete). Phase 2: the cannon stops so you can kill the Colossal.", "AutoCannon", Form, function() end)

        AddMissionToggle("Auto Defend Eren", "Phase 1: while the cannon shoots, Auto Farm also kills the titans that get close to Eren. Needs Auto Farm on.", "AutoDefendEren", Form, function() end)
        do
            local range = FARM_RANGES.DefendErenRadius
            local function titleFor(v) return "Defend Radius ( " .. v .. " )" end
            local row = Form:Row()
            local stack = row:Left():TitleStack({ Title = titleFor(Cfg.DefendErenRadius), Subtitle = "Titans closer than this to Eren (studs) are killed first." })
            UiSync.Link(row:Right():Slider({
                Minimum = range[1],
                Maximum = range[2],
                Value = Cfg.DefendErenRadius,
                ValueChanged = function(self, value)
                    local v = math.clamp(math.floor(value + 0.5), range[1], range[2])
                    Cfg.DefendErenRadius = v
                    pcall(function() stack.Title = titleFor(v) end)
                    Save()
                end
            }), Cfg, "DefendErenRadius", function(_, want)
                pcall(function() stack.Title = titleFor(want) end)
            end)
        end
        local defendLabel
        do
            local row = Form:Row()
            row:Left():TitleStack({ Title = "Defend Eren Status", Subtitle = "What Auto Defend Eren is doing." })
            defendLabel = row:Right():Label({ Text = "Off" })
        end
        local lastDefendText = nil
        local function SetDefendStatus(text)
            text = tostring(text)
            if text == lastDefendText then return end
            lastDefendText = text
            pcall(function() defendLabel.Text = text end)
        end

        local statusLabel
        do
            local row = Form:Row()
            row:Left():TitleStack({ Title = "Cannon Status", Subtitle = "What Auto Cannon is doing." })
            statusLabel = row:Right():Label({ Text = "Off" })
        end
        local lastText = nil
        local function SetStatus(text)
            text = tostring(text)
            if text == lastText then return end
            lastText = text
            pcall(function() statusLabel.Text = text end)
        end

        local shots, impacts, events = 0, 0, 0
        local lastState, lastShoot = "-", "-"

        local function CannonModel()
            local climb = workspace:FindFirstChild("Climbable")
            for _, d in ipairs(climb and climb:GetDescendants() or {}) do
                if d.Name == "Cannons" and not d:IsA("BasePart") then
                    local m = d:FindFirstChildWhichIsA("Model")
                    if m then return m end
                end
            end
            return nil
        end
        local function ColossalAlive()
            local titans = workspace:FindFirstChild("Titans")
            local ct = titans and titans:FindFirstChild("Colossal_Titan")
            local hum = ct and ct:FindFirstChildOfClass("Humanoid")
            return (ct and hum and hum.Health > 0) and ct or nil
        end
        local function NapePos()
            local ct = ColossalAlive()
            if not ct then return nil end
            local hb = ct:FindFirstChild("Hitboxes")
            local hit = hb and hb:FindFirstChild("Hit")
            local nape = hit and hit:FindFirstChild("Nape")
            if nape and nape:IsA("BasePart") then return nape.Position end
            local fake = ct:FindFirstChild("Fake")
            local head = fake and fake:FindFirstChild("Head")
            return head and head:IsA("BasePart") and head.Position or nil
        end
        local function StallObjective()
            local o = ReplicatedStorage:FindFirstChild("Objectives")
            if not o then return nil end
            local names = { "Stall_Colossal_Titan", "Stall_Colossal", "Stall_Bertholdt", "Stall_Bertholdt_Titan" }
            for _, name in ipairs(names) do
                local obj = o:FindFirstChild(name)
                if obj then return obj end
            end
            return nil
        end
        local function StallProgress()
            local so = StallObjective()
            if not so then return nil, nil end
            return tonumber(so.Value) or 0, tonumber(so:GetAttribute("Requirement")) or 1
        end
        local function StallDone()
            local v, req = StallProgress()
            return v ~= nil and v >= req
        end

        -- ลำดับของ Raid Colossal Titan:
        --   เฟส 1 = ยิงปืนใหญ่จนเข้าคัทซีน (Stall Bertholdt สำเร็จ)  -> Auto Farm รอ (เว้นแต่เปิด Farm Small Titans)
        --   เฟส 2 = ฆ่า Colossal Titan                              -> ปืนหยุดยิง แล้วถึงคิว Auto Farm
        local phase2Latched, sawStallObjective = false, false
        local function Phase2()
            if not ColossalAlive() then
                phase2Latched, sawStallObjective = false, false -- ยังไม่มี/ตายแล้ว: เริ่มนับใหม่รอบหน้า
                return false
            end
            if phase2Latched then return true end

            local objective = StallObjective()
            if objective then
                sawStallObjective = true
            elseif sawStallObjective then
                phase2Latched = true -- objective หายหลังจากเคยเห็น = ผ่านเฟส 1 แล้ว
            end

            if StallDone() then
                phase2Latched = true
            end

            return phase2Latched
        end
        local function Phase1()
            return Cfg.AutoCannon and Farm.CanUseHere() and ColossalAlive() ~= nil and not Phase2()
        end

        -- พัก phase 1 แบบบังคับ: ห้าม Auto Farm ฟัน titan เล็กใด ๆ ระหว่างปืนใหญ่ยิง Colossal
        Farm.CannonFarmSmall = false
        Farm.ColossalPhase2 = Phase2
        Farm.ColossalPhase1 = Phase1
        local function PostRemote()
            local ok, r = pcall(function() return ReplicatedStorage.Assets.Remotes.POST end)
            return ok and r or nil
        end

        -- เฟส 1: ต้องหยุด Auto Farm เสมอ ไม่ให้ฟัน titan เล็กหรือเลื่อนไปโจมตีอะไรตอนปืนใหญ่ยิง
        -- เฉพาะ phase 2 ถึงค่อยให้ Auto Farm จัดการ Colossal เท่านั้น
        -- Auto Defend Eren: เฟส 1 ถ้ามีไททันเล็กเข้าใกล้ Eren -> ปล่อยให้ Auto Farm ทำงาน (PickTitan เลือกตัวที่ใกล้ Eren)
        -- พอไม่มีภัยแล้วหน่วง 1.5 วินาที (กันสลับไปมา) ค่อยกลับไปพัก Auto Farm ตามเดิม
        task.spawn(function()
            local calmSince = nil
            while Alive() do
                task.wait(0.25)
                local defend = false
                if not Cfg.AutoDefendEren then
                    SetDefendStatus("Off")
                    calmSince = nil
                elseif not (Cfg.AutoFarm or Cfg.AutoFarmThunder) then
                    SetDefendStatus("Turn on Auto Farm")
                    calmSince = nil
                elseif not (Cfg.AutoCannon and Phase1()) then
                    SetDefendStatus("Waiting for phase 1")
                    calmSince = nil
                else
                    local threats, eren = Farm.ErenThreats()
                    if not eren then
                        SetDefendStatus("Eren not found")
                    elseif threats > 0 then
                        defend = true
                        calmSince = nil
                        SetDefendStatus(("Defending Eren | %d titan(s) near"):format(threats))
                    else
                        calmSince = calmSince or os.clock()
                        if Farm.DefendErenActive and os.clock() - calmSince < 1.5 then defend = true end
                        SetDefendStatus("Eren is safe")
                    end
                end
                Farm.DefendErenActive = defend
                if defend then
                    Farm.PauseUntil = 0
                    Farm.MovePauseUntil = 0
                elseif Cfg.AutoCannon and Phase1() then
                    Farm.PauseUntil = os.clock() + 1.2
                    Farm.MovePauseUntil = os.clock() + 1.2
                elseif Farm.PauseUntil and Farm.PauseUntil > 0 then
                    Farm.PauseUntil = 0
                    Farm.MovePauseUntil = 0
                end
            end
        end)

        task.spawn(function()
            local conn, mounted = nil, nil
            local function Disconnect()
                if conn then pcall(function() conn:Disconnect() end) conn = nil end
            end
            while Alive() do
                task.wait(0.2)
                local ct = ColossalAlive()
                local want = Cfg.AutoCannon and Farm.CanUseHere() and ct ~= nil and not Phase2()
                if not want then
                    if mounted or conn then
                        Disconnect()
                        local c = mounted
                        mounted = nil
                        if c then pcall(MissionInvoke, "Cannon", "State", c, false, nil) end
                    end
                    if not Cfg.AutoCannon then
                        SetStatus("Off")
                    elseif ct and Phase2() then
                        SetStatus("Phase 2: cannon stopped - kill the Colossal")
                    else
                        SetStatus("Waiting for Colossal Titan")
                    end
                else
                    local cannon = CannonModel()
                    local post = PostRemote()
                    if not cannon then
                        SetStatus("No cannon found")
                    elseif not post then
                        SetStatus("POST remote not found")
                    else
                        if not conn then
                            conn = post.OnClientEvent:Connect(function(a1, a2, cannonObj)
                                if a1 ~= "Skills" or a2 ~= "Impact" then return end
                                if not Cfg.AutoCannon then return end
                                events += 1
                                local ref = cannonObj or workspace:FindFirstChild("Cannon")
                                if not ref then return end
                                for _ = 1, IMPACT_BURST do
                                    local pos = NapePos()
                                    if pos then
                                        pcall(function() post:FireServer("S_Skills", "Impact", ref, pos) end)
                                        impacts += 1
                                    end
                                end
                            end)
                        end
                        local okS, resS = MissionInvoke("Cannon", "State", cannon, true, nil)
                        lastState = ("ok=%s res=%s"):format(tostring(okS), type(resS) == "table" and "table" or tostring(resS))
                        mounted = cannon
                        task.wait(0.3)
                        for _ = 1, 3 do
                            local ok, res = MissionInvoke("Cannon", "Shoot", SHOOT_ARGS)
                            lastShoot = ("ok=%s res=%s"):format(tostring(ok), tostring(res))
                            if ok then shots += 1 break end
                            task.wait(0.1)
                        end
                        local v, req = StallProgress()
                        SetStatus(("Phase 1: shooting Colossal | stall %s/%s | shots %d | hits %d"):format(tostring(v), tostring(req), shots, events))
                        task.wait(1.8)
                    end
                end
            end
            Disconnect()
        end)
    end)()
    end)()

    task.delay(2, function() initializing = false end)
end

WaveModeTab:PageSection({
    Title = "🌊 Wave Mode",
    Subtitle = "Core features and settings"
})


---------------------------------------------------------
-- Misc (Webhook)
---------------------------------------------------------
local MiscCategory = Cascade.Components.Section(Window, {
    Title = "Misc",
    Disclosure = false
})

local WebhookTab = MiscCategory:Tab({
    Title = "Webhook",
    Icon = Icon("paperplaneFill", "paperplane", "bellFill"),
})
WebhookTab:PageSection({
    Title = "🔔 Webhook",
    Subtitle = "Core features and settings"
})


---------------------------------------------------------
-- Settings (Advanced / Server / Windows) - อยู่ล่างสุด
---------------------------------------------------------
do
local HOP_PLACE_ID = game.PlaceId
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

---------------------------------------------------------
-- ค่าตั้งของหมวด Settings
---------------------------------------------------------
local HubConfig = {
    InfiniteJump = false,
    AntiAFK = true,
    AutoRejoin = true,
    AntiAdmin = true,
    AutoExecute = false,
    EnableFPSLock = false,
    FPSLimit = 144,
    AutoDeleteMap = false,
}
for key, value in pairs(HubConfig) do UiSync.Defaults.Hub[key] = value end
ConfigStore.BuildDefault(UiSync.Defaults.Hub) -- config ค่าเริ่มต้นครบทุกค่าแล้ว
SettingsStore.Restore(HubConfig, SavedData.Hub)
ConfigStore.ApplyHub(HubConfig, ConfigStore.AutoloadSnapshot())
SH.say("Settings loaded.")

-- ───── Auto Execute: ให้สคริปต์รันต่อเองหลังเทเลพอร์ต (Server Hop / Rejoin / ย้ายแมพ) ─────
-- ใช้ queue_on_teleport ของ executor (ไม่ใช่ทุกตัวที่มี) คิวไว้ 1 ครั้งต่อการเทเลพอร์ต
-- สคริปต์ที่รันใหม่จะคิวต่อให้เองตอนเริ่ม (ถ้าสวิตช์ยังเปิดอยู่) จึงทำงานต่อเนื่อง
-- ตัวที่ถูกคิวไว้จะเช็กไฟล์เซฟก่อนรัน ถ้าปิดสวิตช์ไปแล้วจะไม่รัน
local AUTOEXEC_URL = "https://gist.githubusercontent.com/smoothhubv1-prog/5f0c61bc9b14ba14b2e5bca2e19aa209/raw"
local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

local AUTOEXEC_LOCK = "SmoothHub/AutoExec.lock" -- กันตัวที่คิวไว้รันซ้ำในเซิร์ฟเวอร์เดียวกัน
local AUTOEXEC_LOG = "SmoothHub/AutoExec.log" -- บันทึกสั้นๆ ว่าคิวทำงานไหม (ไว้ไล่หาสาเหตุถ้ารันต่อไม่ติด)
local function AutoExecLog(text)
    if not SH.DEV then return end -- ปล่อยจริง: ไม่เขียนไฟล์บันทึก
    pcall(function()
        if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("SmoothHub") then
            makefolder("SmoothHub")
        end
        local line = tostring(os.time()) .. " place=" .. tostring(game.PlaceId) .. " " .. text .. "\n"
        if type(appendfile) == "function" then
            appendfile(AUTOEXEC_LOG, line)
        elseif type(writefile) == "function" then
            writefile(AUTOEXEC_LOG, line)
        end
    end)
end

local function QueueAutoExecute()
    if type(queueTeleport) ~= "function" then
        AutoExecLog("queue_on_teleport not supported by this executor")
        return false
    end
    -- ตัวที่ถูกคิวไว้: รอเกมโหลด -> เช็กว่าสวิตช์ยังเปิดอยู่ -> โหลดสคริปต์ (ลองใหม่ได้ 5 ครั้ง) -> เขียนผลลงบันทึก
    local payload = string.format([[
        local LOG = %q
        local LOCK = %q
        local function log(text)
            if true then return end -- ปล่อยจริง: ไม่เขียนไฟล์บันทึก
            pcall(function()
                if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("SmoothHub") then makefolder("SmoothHub") end
                local line = tostring(os.time()) .. " place=" .. tostring(game.PlaceId) .. " [queued] " .. text .. "\n"
                if type(appendfile) == "function" then appendfile(LOG, line)
                elseif type(writefile) == "function" then writefile(LOG, line) end
            end)
        end
        log("started")
        if not game:IsLoaded() then game.Loaded:Wait() end
        local Players = game:GetService("Players")
        while not Players.LocalPlayer do task.wait() end

        local run = true
        pcall(function()
            if type(isfile) == "function" and isfile(%q) then
                local data = game:GetService("HttpService"):JSONDecode(readfile(%q))
                if type(data) == "table" and type(data.Hub) == "table" and data.Hub.AutoExecute == false then run = false end
            end
        end)
        if not run then log("skipped (Auto Execute is off)") return end

        -- กันรันซ้ำ: เซิร์ฟเวอร์เดิม (JobId เดียวกัน) ที่เพิ่งรันไปไม่ถึง 20 วินาที = ข้าม
        local jobId = tostring(game.JobId)
        pcall(function()
            if jobId ~= "" and type(isfile) == "function" and isfile(LOCK) then
                local id, t = tostring(readfile(LOCK)):match("^(.-)|(%%d+)$")
                if id == jobId and t and os.time() - tonumber(t) < 20 then run = false end
            end
        end)
        if not run then log("skipped (already started in this server)") return end
        pcall(function() writefile(LOCK, jobId .. "|" .. tostring(os.time())) end)

        local src, err
        for i = 1, 5 do
            local ok, res = pcall(function() return game:HttpGet(%q) end)
            if ok and type(res) == "string" and #res > 0 then src = res break end
            err = res
            task.wait(1)
        end
        if not src then log("download failed: " .. tostring(err)) return end
        local fn, cerr = loadstring(src)
        if not fn then log("compile failed: " .. tostring(cerr)) return end
        local ok, rerr = pcall(fn)
        log(ok and "script started" or ("script error: " .. tostring(rerr)))
    ]], AUTOEXEC_LOG, AUTOEXEC_LOCK, SettingsStore.Path("AOTR"), SettingsStore.Path("AOTR"), AUTOEXEC_URL)
    local ok, err = pcall(queueTeleport, payload)
    AutoExecLog(ok and "queued" or ("queue failed: " .. tostring(err)))
    return ok
end

local function ApplyAutoExecute(on)
    if on then
        SettingsStore.Flush("AOTR") -- เซฟค่าที่เปิดทันที ตัวที่คิวไว้จะอ่านไฟล์นี้ก่อนรัน
        QueueAutoExecute()
    elseif type(clear_teleport_queue) == "function" then
        pcall(clear_teleport_queue)
    end
end
if HubConfig.AutoExecute then QueueAutoExecute() end

-- คิวใหม่ทุกครั้งที่ "เริ่มเทเลพอร์ต" (รวมที่เกมสั่งจากเซิร์ฟเวอร์ เช่นตอนเข้าด่าน)
-- executor บางตัวล้างคิวเก่าตอนย้ายแมพ หรือไม่ยิงคิวที่ตั้งไว้ล่วงหน้า การคิวตอนเทเลพอร์ตเริ่มจะแก้ตรงนี้
if type(queueTeleport) == "function" then
    local lastQueuedAt = 0
    pcall(function()
        LocalPlayer.OnTeleport:Connect(function(state)
            if not Alive() or not HubConfig.AutoExecute then return end
            if os.clock() - lastQueuedAt < 5 then return end
            lastQueuedAt = os.clock()
            AutoExecLog("teleport started (" .. tostring(state) .. ") - re-queue")
            if type(clear_teleport_queue) == "function" then pcall(clear_teleport_queue) end
            QueueAutoExecute()
        end)
    end)
end

local function HopServer()
    pcall(function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. HOP_PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100")
        local body = HttpService:JSONDecode(req)
        if body and body.data then
            for _, sv in ipairs(body.data) do
                if type(sv) == "table" and sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    table.insert(servers, sv.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(HOP_PLACE_ID, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(HOP_PLACE_ID, LocalPlayer)
        end
    end)
end

---------------------------------------------------------
-- หมวด Settings : Advanced / Server / Windows
---------------------------------------------------------
local SettingsCategory = Cascade.Components.Section(Window, {
    Title = "Settings\u{200B}", -- อักขระไร้เสียงต่อท้าย กัน Roblox แปลเป็น "การตั้งค่า"
    Disclosure = false
})

-- ═════════ Advanced ═════════
local AdvancedTab, ServerTab, SettingsTab, ConfigTab -- (กำหนดค่าในบล็อกด้านล่าง เพื่อลดจำนวนตัวแปรท้องถิ่น)
do
AdvancedTab = SettingsCategory:Tab({
    Title = "Advanced",
    Icon = Icon("gearshapeFill", "gearshape")
})

local AdvSection = AdvancedTab:PageSection({
    Title = "⚙️ Advanced Settings",
    Subtitle = "Configure advanced player modifications and tools.",
})
local AdvForm = AdvSection:Form()

local function AddToggle(form, title, subtitle, key, onChange)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    UiSync.Link(row:Right():Toggle({
        Value = HubConfig[key],
        ValueChanged = function(self, value)
            HubConfig[key] = value and true or false
            if onChange then onChange(value) end
        end
    }), HubConfig, key)
end

AddToggle(AdvForm, "Infinite Jump", "Allow your character to jump infinitely in the air.", "InfiniteJump")
AddToggle(AdvForm, "Anti-AFK", "Prevent being kicked out of the game due to inactivity.", "AntiAFK")
AddToggle(AdvForm, "Auto Rejoin", "Automatically rejoin the game if disconnected or kicked.", "AutoRejoin")
AddToggle(AdvForm, "Anti Admin", "Automatically server hop if an admin joins the game.", "AntiAdmin")
AddToggle(AdvForm,
    "Auto Execute",
    type(queueTeleport) == "function" and "Run the script again after teleporting or rejoining a server."
        or "Not supported by your executor.",
    "AutoExecute",
    ApplyAutoExecute)

-- ───── FPS Lock : ล็อกเฟรมเรตให้ใช้งานได้จริง ─────
-- 1) ใช้ฟังก์ชันล็อก FPS ของ executor ถ้ามี (setfpscap / set_fps_cap / ...)
-- 2) ถ้า executor ไม่มี -> ใช้ตัวจำกัดในสคริปต์ (หน่วงท้ายทุกเฟรม) ล็อกได้ถึง 240 FPS
--    (ตัวนี้กิน CPU ระหว่างรอ แต่ทำให้เฟรมเรตไม่เกินค่าที่ตั้งได้จริง)
-- 3) แถว "Current FPS" แสดง FPS ที่วัดได้จริง ดูได้เลยว่าล็อกทำงานไหม
-- เรียกเองจาก executor ได้: _G.SmoothHubFarm.Fps.Apply() / .Measured / .Mode
local Fps = {}
Farm.Fps = Fps
do
    local RunService = game:GetService("RunService")
    local SOFT_MAX = 240 -- ตัวจำกัดในสคริปต์ใช้ได้ถึงค่านี้ (สูงกว่านี้ต้องพึ่ง executor)

    local candidates = {
        setfpscap, set_fps_cap, setfps,
        syn and syn.set_fps_cap, fluxus and fluxus.set_fps_cap,
    }
    local names = { "setfpscap", "set_fps_cap", "setfps", "syn.set_fps_cap", "fluxus.set_fps_cap" }
    local native, nativeName = nil, nil
    for i = 1, 5 do
        if type(candidates[i]) == "function" then native, nativeName = candidates[i], names[i] break end
    end
    Fps.Native = nativeName -- ชื่อฟังก์ชันที่ executor มี (nil = ไม่มี)

    local function DesiredOn() return HubConfig.EnableFPSLock and true or false end
    local function DesiredLimit() return math.clamp(math.floor(tonumber(HubConfig.FPSLimit) or 144), 1, 9999) end

    Fps.Mode = "off"      -- off | native | software | unsupported
    Fps.Measured = 0      -- FPS ที่วัดได้จริง
    local applied = { on = DesiredOn(), limit = DesiredLimit() }

    -- ตัวจำกัดในสคริปต์: รอให้ครบเวลาต่อเฟรมก่อนจบ RenderStepped
    local softConn = nil
    local function StopSoft()
        if softConn then softConn:Disconnect() softConn = nil end
    end
    local function StartSoft(limit)
        StopSoft()
        local frameTime = 1 / limit
        local last = os.clock()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not Alive() then conn:Disconnect() return end
            local target = last + frameTime
            while os.clock() < target do end
            last = os.clock()
        end)
        softConn = conn
    end

    function Fps.Apply()
        local on, limit = DesiredOn(), DesiredLimit()
        StopSoft()
        if on then
            if native then
                pcall(native, limit)
                Fps.Mode = "native"
            elseif limit >= 9999 then
                Fps.Mode = "off" -- Unlimited = ไม่ต้องจำกัด
            elseif limit <= SOFT_MAX then
                StartSoft(limit)
                Fps.Mode = "software"
            else
                Fps.Mode = "unsupported"
            end
        else
            if native then pcall(native, 9999) end
            Fps.Mode = "off"
        end
        applied.on, applied.limit = on, limit
    end

    -- เรียกทุกวินาที: ถ้าค่าถูกเปลี่ยน (เช่น สลับ Config) ให้ apply ใหม่ / ถ้าเกมรีเซ็ตเพดาน ให้ย้ำค่าเดิม
    function Fps.Reassert()
        local on, limit = DesiredOn(), DesiredLimit()
        if on ~= applied.on or limit ~= applied.limit then
            Fps.Apply()
        elseif on and Fps.Mode == "native" then
            pcall(native, limit)
        end
    end

    -- วัด FPS จริงทุก 0.5 วินาที
    local frames, lastT = 0, os.clock()
    local counter
    counter = RunService.RenderStepped:Connect(function()
        if not Alive() then counter:Disconnect() return end
        frames += 1
    end)
    task.spawn(function()
        while Alive() do
            task.wait(0.5)
            local now = os.clock()
            local dt = now - lastT
            if dt > 0 then Fps.Measured = frames / dt end
            frames, lastT = 0, now
            if Fps.OnUpdate then pcall(Fps.OnUpdate, Fps.Measured, Fps.Mode, Fps.Native) end
        end
    end)

    if DesiredOn() then Fps.Apply() end -- เปิดล็อกไว้ในไฟล์เซฟ = ใช้ทันทีตอนโหลด
end

local FpsSection = AdvancedTab:PageSection({
    Title = "🖥️ FPS",
    Subtitle = "Limit the frame rate of the game."
})
local FpsForm = FpsSection:Form()

AddToggle(FpsForm, "Enable FPS Lock", "Toggle frame rate limiting on or off.", "EnableFPSLock", function(value)
    Fps.Apply()
end)

local FpsMenuRow = FpsForm:Row()
FpsMenuRow:Left():TitleStack({
    Title = "FPS Limit Preset",
    Subtitle = "Choose target frame rate limit."
})
local fpsOptions = { "15 FPS", "30 FPS", "60 FPS", "120 FPS", "144 FPS", "240 FPS", "500 FPS", "1000 FPS", "9999 (Unlimited)" }
local fpsValues = { 15, 30, 60, 120, 144, 240, 500, 1000, 9999 }
local fpsDefaultIndex = table.find(fpsValues, HubConfig.FPSLimit) or 5

local FpsBtn = FpsMenuRow:Right():PullDownButton({
    Label = fpsOptions[fpsDefaultIndex],
    Options = fpsOptions,
    Value = fpsDefaultIndex,
    ValueChanged = function(self, index)
        local target = fpsValues[index]
        HubConfig.FPSLimit = target
        self.Label = fpsOptions[index]
        if HubConfig.EnableFPSLock then Fps.Apply() end
    end
})
StyleDropdown(FpsBtn)
UiSync.Add(function()
    local i = table.find(fpsValues, HubConfig.FPSLimit) or 5
    FpsBtn.Value = i
    FpsBtn.Label = fpsOptions[i]
end)

-- แถวแสดง FPS ที่วัดได้จริง + สถานะการล็อก
local FpsStatusRow = FpsForm:Row()
local FpsStatusStack = FpsStatusRow:Left():TitleStack({
    Title = "Current FPS ( -- )",
    Subtitle = "Measured live so you can see whether the lock is working."
})
Fps.OnUpdate = function(fps, mode, nativeName)
    local text
    if mode == "native" then
        text = "Locked at " .. tostring(HubConfig.FPSLimit) .. " FPS using " .. tostring(nativeName) .. "."
    elseif mode == "software" then
        text = "Locked at " .. tostring(HubConfig.FPSLimit) .. " FPS by the built-in limiter (your executor has no FPS cap function)."
    elseif mode == "unsupported" then
        text = "Can't lock above 240 FPS: your executor has no FPS cap function."
    else
        text = "Lock is off." .. (nativeName and (" Executor supports " .. nativeName .. ".") or " Executor has no FPS cap function (built-in limiter will be used up to 240 FPS).")
    end
    pcall(function()
        FpsStatusStack.Title = "Current FPS ( " .. tostring(math.floor(fps + 0.5)) .. " )"
        FpsStatusStack.Subtitle = text
    end)
end

-- ───── Delete Map : ลบสิ่งปลูกสร้าง/ต้นไม้/กำแพง "ในเครื่องเรา" ให้เครื่องเบาลง ─────
-- ลบเฉพาะฝั่งคุณ (เซิร์ฟเวอร์และคนอื่นไม่เห็นผล) Rejoin แล้วแมพกลับมาเหมือนเดิม
-- เก็บไว้: พื้น (ชิ้นที่ด้านบนไม่สูงเกินพื้น + 6 studs), Terrain, ไททัน, ตัวละครทุกคน, กล้อง, Debris, Spears,
--          จุด Refill, สิ่งที่มี ProximityPrompt/ClickDetector, SpawnLocation (และกล่อง/โฟลเดอร์ที่ใส่ของเหล่านี้)
-- นอกจากนั้นปิดเงา (GlobalShadows) และเอฟเฟกต์ภาพ (Bloom / Blur / SunRays / DepthOfField ฯลฯ)
-- เรียกเองได้จาก executor: _G.SmoothHubFarm.DeleteMap()
local MapCleaner = {}
Farm.MapCleaner = MapCleaner
do
    local KEEP_ABOVE = 6 -- เก็บชิ้นส่วนที่ด้านบนสูงไม่เกิน "ระดับพื้น + ค่านี้" (พื้น / ขอบถนน / ของเตี้ย ๆ)
    local busy = false

    -- ระดับพื้น: ยิงเรย์ลงจากตัวเรากับไททันบางตัว แล้วเอาจุดที่ต่ำสุด (กันไปโดนหลังคา)
    local function GroundY()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local titans = workspace:FindFirstChild("Titans")
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignore = {}
        if char then ignore[#ignore + 1] = char end
        if titans then ignore[#ignore + 1] = titans end
        params.FilterDescendantsInstances = ignore

        local best = nil
        local function sample(pos)
            local hit = workspace:Raycast(pos, Vector3.new(0, -3000, 0), params)
            if hit and (not best or hit.Position.Y < best) then best = hit.Position.Y end
        end
        if root then sample(root.Position) end
        if titans then
            local n = 0
            for _, t in ipairs(titans:GetChildren()) do
                local r = t:FindFirstChild("HumanoidRootPart")
                if r then
                    sample(r.Position)
                    n += 1
                    if n >= 6 then break end
                end
            end
        end
        return best
    end

    function MapCleaner.Run()
        if busy then return false, "Already running..." end
        busy = true
        local okCall, ok, text = pcall(function()
            local groundY = GroundY()
            if not groundY then return false, "Can't find the ground - stand on the map first" end
            local limit = groundY + KEEP_ABOVE

            local roots = {}
            roots[workspace.Terrain] = true
            if workspace.CurrentCamera then roots[workspace.CurrentCamera] = true end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then roots[plr.Character] = true end
            end
            for _, name in ipairs({ "Titans", "Debris" }) do
                local f = workspace:FindFirstChild(name)
                if f then roots[f] = true end
            end

            -- ต้องเก็บทั้งก้อน (รวมลูกทั้งหมด)
            local function Protected(node)
                if roots[node] then return true end
                local n = node.Name
                if n == "Refill" or n == "Spears" then return true end
                if node:IsA("SpawnLocation") or node:IsA("ProximityPrompt") or node:IsA("ClickDetector") or node:IsA("Humanoid") then return true end
                if node:IsA("Model") and node:FindFirstChildOfClass("Humanoid") then return true end
                return false
            end

            local visited, toDestroy = 0, {}
            -- คืน true = ต้องเก็บโหนดนี้ไว้ (ตัวมันเองหรือของข้างในต้องเก็บ) / false = ลบทั้งก้อนได้
            local function Plan(node)
                visited += 1
                if visited % 1500 == 0 then task.wait() end
                if Protected(node) then return true end
                local keepSelf = false
                if node:IsA("BasePart") then
                    keepSelf = (node.Position.Y + node.Size.Y / 2) <= limit
                end
                local children = node:GetChildren()
                local flags, anyKept = {}, false
                for i, c in ipairs(children) do
                    local f = Plan(c)
                    flags[i] = f
                    if f then anyKept = true end
                end
                if not (keepSelf or anyKept) then return false end
                for i, c in ipairs(children) do
                    if not flags[i] then toDestroy[#toDestroy + 1] = c end
                end
                return true
            end

            for _, child in ipairs(workspace:GetChildren()) do
                if not Plan(child) then toDestroy[#toDestroy + 1] = child end
            end
            for i, inst in ipairs(toDestroy) do
                pcall(function() inst:Destroy() end)
                if i % 200 == 0 then task.wait() end
            end

            -- ลดภาระกราฟิก: ปิดเงา + เอฟเฟกต์ภาพ
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                for _, e in ipairs(lighting:GetChildren()) do
                    if e:IsA("PostEffect") then e.Enabled = false end
                end
            end)
            return true, ("Deleted %d map objects (scanned %d). Rejoin to get the map back."):format(#toDestroy, visited)
        end)
        busy = false
        if not okCall then return false, "Error: " .. tostring(ok) end
        return ok, text
    end
end

function Farm.DeleteMap()
    task.spawn(function()
        if MapCleaner.OnResult then MapCleaner.OnResult("Deleting the map...") end
        local _, text = MapCleaner.Run()
        if MapCleaner.OnResult then MapCleaner.OnResult(text or "") end
    end)
end

-- ลบแมพเองอัตโนมัติเมื่อเปิดสวิตช์ Auto Delete Map: ตอนอยู่ในด่าน (รอโหลด 4 วิ) และกวาดซ้ำทุก 20 วิ (ส่วนที่โหลดเพิ่ม)
task.spawn(function()
    local since, lastDone = nil, 0
    while Alive() do
        task.wait(1)
        if HubConfig.AutoDeleteMap and Farm.CanUseHere and Farm.CanUseHere() then
            since = since or os.clock()
            if os.clock() - since >= 4 and os.clock() - lastDone >= 20 then
                lastDone = os.clock()
                Farm.DeleteMap()
            end
        else
            since = nil
        end
    end
end)

local DelMapRow = FpsForm:Row()
local DelMapStack = DelMapRow:Left():TitleStack({
    Title = "Delete Map",
    Subtitle = "Removes buildings, trees and walls on YOUR screen only, to cut lag. Rejoin to get the map back."
})
local DelMapRun
local DelMapBtn = DelMapRow:Right():Button({
    Label = "Delete",
    Callback = function() if DelMapRun then DelMapRun() end end
})
DelMapRun = BindButton(DelMapBtn, function() Farm.DeleteMap() end)
MapCleaner.OnResult = function(text)
    pcall(function() DelMapStack.Subtitle = text end)
end

AddToggle(FpsForm, "Auto Delete Map", "Deletes the map by itself every time you are in a mission.", "AutoDeleteMap")

end

-- ═════════ Server ═════════
do
ServerTab = SettingsCategory:Tab({
    Title = "Server",
    Icon = Icon("globe", "network")
})

local ServerInfoSection = ServerTab:PageSection({
    Title = "🌐 Server Information",
    Subtitle = "Display current server details and identifiers."
})
local ServerInfoForm = ServerInfoSection:Form()

local GameIdRow = ServerInfoForm:Row()
GameIdRow:Left():TitleStack({ Title = "GameId", Subtitle = "The unique ID of this game universe." })
GameIdRow:Right():Label({ Text = tostring(game.GameId) })

local PlaceIdRow = ServerInfoForm:Row()
PlaceIdRow:Left():TitleStack({ Title = "PlaceId", Subtitle = "The specific place ID of this server instance." })
PlaceIdRow:Right():Label({ Text = tostring(game.PlaceId) })

local ServerActionSection = ServerTab:PageSection({
    Title = "💾 Server Actions",
    Subtitle = "Quick tools to copy identifiers or switch servers."
})
local ServerActionForm = ServerActionSection:Form()

local function AddAction(form, title, subtitle, fn)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    local run
    local btn = row:Right():Button({
        Label = "Execute",
        Callback = function() if run then run() end end
    })
    run = BindButton(btn, fn)
end

AddAction(ServerActionForm, "Copy JobId", "Copy current JobId to clipboard for friends to join.", function()
    CopyText(tostring(game.JobId))
end)

AddAction(ServerActionForm, "Rejoin Server", "Go back to the main world (this map can't be rejoined directly).", function()
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            LocalPlayer:Kick("\nRejoining...")
            task.wait()
        end
        TeleportService:Teleport(HOP_PLACE_ID, LocalPlayer)
    end)
end)

AddAction(ServerActionForm, "Server Hop", "Teleport to a different server to find a new one.", HopServer)

end

-- ═════════ Windows ═════════
SettingsTab = SettingsCategory:Tab({
    Title = "Windows",
    Icon = Icon("macwindow", "sliderHorizontal3")
})

local ColorSection = SettingsTab:PageSection({
    Title = "🎨 Customs Color",
    Subtitle = "Customize the appearance and visual style of the interface."
})
local ColorForm = ColorSection:Form()
local ColorRow = ColorForm:Row()
ColorRow:Left():TitleStack({
    Title = "Theme Color",
    Subtitle = "The whole palette, not just light or dark."
})

local colorOptions = AccentOrder
local colorMaps = {}
for index, accentName in ipairs(colorOptions) do
    colorMaps[index] = Cascade.Accents[accentName]
end

local DEFAULT_ACCENT = ConfigStore.DEFAULT_LOOK.Theme -- ธีมเริ่มต้น
local FOLLOW_THEME = "Theme Default"
local CurrentThemeName = table.find(AccentOrder, SavedUi.Theme) and SavedUi.Theme or DEFAULT_ACCENT
local CurrentAccentName = (SavedUi.Accent == FOLLOW_THEME or table.find(AccentOrder, SavedUi.Accent)) and SavedUi.Accent or ConfigStore.DEFAULT_LOOK.Accent
local ACCENT_ONLY_KEYS = { "SwitchAccent", "Selection", "SelectionFocused", "Toggle", "Button" }

local function BuildFinalAccent()
    local base = Cascade.Accents[CurrentThemeName]
    if not base then return nil end
    if CurrentAccentName == FOLLOW_THEME then return base end

    local pick = Cascade.Accents[CurrentAccentName]
    if not pick then return base end

    local combined = { _id = "SmoothHubCustom" }
    for _, mode in ipairs({ "Dark", "Light" }) do
        local set = {}
        for key, value in pairs(base[mode] or {}) do
            set[key] = value
        end
        for _, key in ipairs(ACCENT_ONLY_KEYS) do
            if pick[mode] and pick[mode][key] ~= nil then
                set[key] = pick[mode][key]
            end
        end
        combined[mode] = set
    end

    Cascade.Accents.SmoothHubCustom = combined
    return combined
end

local function ApplyAppearance()
    local finalAccent = BuildFinalAccent()
    if not finalAccent then return end

    App.Accent = finalAccent
    pcall(function()
        if App.SetTheme then
            App:SetTheme(finalAccent)
        elseif Window.RefreshTheme then
            Window:RefreshTheme()
        end
    end)

    task.spawn(function()
        Window.Maximized = not Window.Maximized
        task.wait()
        Window.Maximized = not Window.Maximized

        for _, tab in ipairs({ CharTab, AccountTab, FarmTab, AutoQuestTab, LobbyTab, ProgressionTab, SkillTreesTab, PerksTab, MissionsTab, WaveModeTab, RaidModeTab, WebhookTab, AdvancedTab, ServerTab, SettingsTab, ConfigTab }) do
            if tab.Selected then
                tab.Selected = false
                task.wait()
                tab.Selected = true
                break
            end
        end
    end)
end

local ThemeColorBtn = ColorRow:Right():PullDownButton({
    Label = CurrentThemeName,
    Options = colorOptions,
    Value = table.find(colorOptions, CurrentThemeName) or 1,
    ValueChanged = function(self, index)
        if colorOptions[index] and colorMaps[index] then
            CurrentThemeName = colorOptions[index]
            self.Label = colorOptions[index]
            ApplyAppearance()
        end
    end
})
StyleDropdown(ThemeColorBtn)

local AccentRow = ColorForm:Row()
AccentRow:Left():TitleStack({
    Title = "Accent Color",
    Subtitle = "Only changes icons, switches and buttons. The background stays the same."
})
local accentOptions = { FOLLOW_THEME }
for _, accentName in ipairs(AccentOrder) do
    table.insert(accentOptions, accentName)
end
local AccentColorBtn = AccentRow:Right():PullDownButton({
    Label = CurrentAccentName,
    Options = accentOptions,
    Value = table.find(accentOptions, CurrentAccentName) or 1,
    ValueChanged = function(self, index)
        if accentOptions[index] then
            CurrentAccentName = accentOptions[index]
            self.Label = accentOptions[index]
            ApplyAppearance()
        end
    end
})
StyleDropdown(AccentColorBtn)

-- ถ้าเคยตั้ง Accent Color ไว้ ให้ใช้ทันที (สี Theme ถูกใช้ตั้งแต่ตอนสร้างหน้าต่างแล้ว)
if CurrentAccentName ~= FOLLOW_THEME then
    ApplyAppearance()
end

local BlurSection = SettingsTab:PageSection({
    Title = "✨ Windows Effects",
    Subtitle = "Manage special visual styles for your script window."
})
local BlurForm = BlurSection:Form()

-- ใช้ค่า Blur / Shadow ที่จำไว้ (ต้องตั้งก่อนสร้างสวิตช์ เพราะสวิตช์อ่านค่าจาก Window)
if type(SavedUi.UIBlur) == "boolean" then Window.UIBlur = SavedUi.UIBlur end
if type(SavedUi.Dropshadow) == "boolean" then Window.Dropshadow = SavedUi.Dropshadow end

local BlurRow = BlurForm:Row()
BlurRow:Left():TitleStack({
    Title = "Blur Effect",
    Subtitle = "Enable frosted glass blur effect behind the window."
})
UiSync.Blur = BlurRow:Right():Toggle({
    Value = Window.UIBlur,
    ValueChanged = function(self, value) Window.UIBlur = value end
})

local ShadowRow = BlurForm:Row()
ShadowRow:Left():TitleStack({
    Title = "Shadows Effect",
    Subtitle = "Enable smooth dropshadow around the script window."
})
UiSync.Shadow = ShadowRow:Right():Toggle({
    Value = Window.Dropshadow,
    ValueChanged = function(self, value) Window.Dropshadow = value end
})

local InputSection = SettingsTab:PageSection({
    Title = "⌨️ Input",
    Subtitle = "The shortcut that hides and shows the window."
})
local InputForm = InputSection:Form()
local HotkeyRow = InputForm:Row()
HotkeyRow:Left():TitleStack({
    Title = "Minimize Hotkey",
    Subtitle = "Press to hide or show the window."
})
local currentKeybind = Enum.KeyCode.LeftAlt
pcall(function() currentKeybind = Enum.KeyCode[ConfigStore.DEFAULT_LOOK.Keybind] or Enum.KeyCode.LeftAlt end)
if type(SavedUi.Keybind) == "string" then
    pcall(function()
        local savedKey = Enum.KeyCode[SavedUi.Keybind]
        if savedKey then currentKeybind = savedKey end
    end)
end

UiSync.Hotkey = HotkeyRow:Right():KeybindField({
    Value = currentKeybind,
    ValueChanged = function(self, newKey) currentKeybind = newKey end,
    BindPressed = function(self, key, inputComplete, gameProcessedEvent)
        if inputComplete and not gameProcessedEvent then
            Window.Minimized = not Window.Minimized
        end
    end
})

-- 🔘 ปุ่มโลโก้ลอย (วงกลม): แตะ/คลิกเพื่อพับ/เปิดหน้าต่าง ลากย้ายตำแหน่งได้ เหมาะกับมือถือที่ไม่มีคีย์บอร์ดกดพับ
task.spawn(function()
    -- ใส่โลโก้ของค่ายได้ 2 วิธี (เลือกอย่างใดอย่างหนึ่ง เว้นว่างทั้งคู่ = ขึ้นตัวอักษร S แทน)
    --   LOGO_URL      = ลิงก์รูป PNG/JPG ตรง ๆ เช่น "https://raw.githubusercontent.com/ชื่อ/repo/main/logo.png"
    --                   (ต้องใช้ executor ที่มี writefile + getcustomasset)
    --   LOGO_ASSET_ID = รูปที่อัปโหลดเข้า Roblox แล้ว เช่น "rbxassetid://1234567890" (หรือใส่เฉพาะตัวเลข)
    local LOGO_URL = "https://raw.githubusercontent.com/smoothhubv1-prog/-SmoothHub/refs/heads/main/smoothhub_logo.png"
    local LOGO_ASSET_ID = ""
    local LOGO_ON_PC = true -- true = โชว์ปุ่มบนคอมด้วย | false = โชว์เฉพาะอุปกรณ์สัมผัส (มือถือ/แท็บเล็ต)

    local UIS = game:GetService("UserInputService")
    if not UIS.TouchEnabled and not LOGO_ON_PC then return end

    -- หาที่อยู่รูปโลโก้ (ถ้าได้ไม่ครบ จะใช้ตัวอักษร S แทน ปุ่มยังใช้ได้ปกติ)
    local logoImage = ""
    do
        local id = tostring(LOGO_ASSET_ID or ""):gsub("%s", "")
        if id ~= "" then
            logoImage = id:match("^%d+$") and ("rbxassetid://" .. id) or id
        elseif tostring(LOGO_URL or "") ~= "" and type(writefile) == "function"
            and (type(getcustomasset) == "function" or type(getsynasset) == "function") then
            local file = "SmoothHub_logo.png"
            pcall(function()
                local data = game:HttpGet(LOGO_URL)
                if type(data) == "string" and #data > 100 then writefile(file, data) end -- ดาวน์โหลดไม่ได้ = ใช้ไฟล์เดิมที่เคยโหลดไว้
            end)
            local okAsset, asset = pcall(function() return (getcustomasset or getsynasset)(file) end)
            if okAsset and type(asset) == "string" and asset ~= "" then logoImage = asset end
        end
    end
    local parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
    pcall(function()
        local old = parent:FindFirstChild("SmoothHubToggle")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SmoothHubToggle"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999998
    local okParent = pcall(function() gui.Parent = parent end)
    if not okParent or not gui.Parent then gui.Parent = PlayerGui end

    local btn = Instance.new("ImageButton")
    btn.Name = "Toggle"
    btn.Size = UDim2.fromOffset(52, 52)
    btn.Position = UDim2.new(0, 14, 0.5, -26)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    btn.BackgroundTransparency = 0
    btn.AutoButtonColor = false
    btn.Image = logoImage
    btn.ScaleType = Enum.ScaleType.Crop -- รูปเต็มวงกลม (UICorner ด้านล่างตัดเป็นวงกลมให้)
    btn.Parent = gui
    if logoImage == "" then
        -- ไม่มีรูปโลโก้: ขึ้นตัวอักษร S แทน
        local letter = Instance.new("TextLabel")
        letter.Size = UDim2.fromScale(1, 1)
        letter.BackgroundTransparency = 1
        letter.Text = "S"
        letter.TextColor3 = Color3.fromRGB(255, 255, 255)
        letter.Font = Enum.Font.GothamBold
        letter.TextSize = 24
        letter.Parent = btn
    end
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local dragging, moved, dragStart, startPos = false, false, nil, nil
    local function isPress(input)
        return input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1
    end
    btn.InputBegan:Connect(function(input)
        if isPress(input) then
            dragging, moved = true, false
            dragStart, startPos = input.Position, btn.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - dragStart
            if d.Magnitude > 8 then moved = true end
            if moved then
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end)
    btn.InputEnded:Connect(function(input)
        if isPress(input) and dragging then
            dragging = false
            if not moved then Window.Minimized = not Window.Minimized end -- แตะเฉย ๆ = พับ/เปิด | ลาก = ย้ายปุ่ม
        end
    end)

    -- สคริปต์ถูกรันใหม่ (token เปลี่ยน) = ลบปุ่มเก่าทิ้ง
    while Alive() and gui.Parent do task.wait(1) end
    pcall(function() gui:Destroy() end)
end)

-- ═════════ Config ═════════
ConfigTab = SettingsCategory:Tab({
    Title = "Config",
    Icon = Icon("folderBadgeGearshape", "folderFill", "folder")
})

do
    local ConfigSection = ConfigTab:PageSection({
        Title = "📁 Configuration",
        Subtitle = "Save your settings under a name (e.g. FarmBoss)."
    })
    local ConfigForm = ConfigSection:Form()

    local typedName = ""
    local selectedName = nil
    local currentOptions = { "---" }
    local ListBtn
    local RefreshList

    local function AddRow(title, subtitle)
        local row = ConfigForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        return row:Right()
    end

    local function AddButtonRow(title, subtitle, label, fn, state)
        local right = AddRow(title, subtitle)
        local props = { Label = label, Callback = function() end }
        if state then props.State = state end
        local ok, btn = pcall(function() return right:Button(props) end)
        if not ok then
            props.State = nil
            btn = right:Button(props)
        end
        BindButton(btn, fn)
        return btn
    end

    local StatusLabel = AddRow("Status", "Result of the last action."):Label({
        Text = canSave and "Ready" or "Can't save files"
    })
    local function SetCfgStatus(text)
        pcall(function() StatusLabel.Text = tostring(text) end)
    end

    local ActiveLabel, AutoloadLabel
    local function UpdateActiveLabel()
        pcall(function()
            local name = ConfigStore.Active()
            if not name then ActiveLabel.Text = "none" return end
            local dirty = ConfigStore.IsDirty(HubConfig)
            if ConfigStore.IsDefault(name) then
                -- config ค่าเริ่มต้นเซฟทับไม่ได้ ถ้ามีการแก้จะขึ้น (modified) ให้ดูเฉย ๆ
                ActiveLabel.Text = dirty and (name .. "  (modified)") or name
            else
                -- โหมดเซฟเอง: ถ้ามีการแก้ที่ยังไม่ได้กด Enter Save Config จะมีคำว่า (unsaved) ต่อท้ายชื่อ
                ActiveLabel.Text = dirty and (name .. "  (unsaved)") or name
            end
        end)
    end
    local function UpdateAutoloadLabel()
        pcall(function() AutoloadLabel.Text = ConfigStore.Autoload() or "none" end)
    end

    -- ชื่อ config: ตัดอักขระต้องห้ามออก รองรับภาษาไทย ยาวสุด 40 ตัวอักษร (ตัดตามตัวอักษร ไม่ตัดกลางตัว)
    local function CleanName(text)
        local t = tostring(text or "")
        t = t:gsub('[%c/\\:*?"<>|]', "")
        t = t:gsub("^%s+", "")
        t = t:gsub("%s+$", "")
        if #t == 0 or not utf8.len(t) then return nil end
        if utf8.len(t) > 40 then t = t:sub(1, utf8.offset(t, 41) - 1) end
        return t
    end

    -- ใช้หน้าตาจาก config: ธีม / Accent / เบลอ / เงา / ปุ่มลัดซ่อนหน้าต่าง (ค่าที่ไม่มีหรือใช้ไม่ได้จะข้าม)
    local function ApplyLook(ui)
        if type(ui) ~= "table" then return end
        local lookChanged = false
        if table.find(AccentOrder, ui.Theme) and ui.Theme ~= CurrentThemeName then
            CurrentThemeName = ui.Theme
            lookChanged = true
        end
        if (ui.Accent == FOLLOW_THEME or table.find(AccentOrder, ui.Accent)) and ui.Accent ~= CurrentAccentName then
            CurrentAccentName = ui.Accent
            lookChanged = true
        end
        pcall(function()
            local ti = table.find(colorOptions, CurrentThemeName) or 1
            ThemeColorBtn.Value = ti
            ThemeColorBtn.Label = colorOptions[ti]
        end)
        pcall(function()
            local ai = table.find(accentOptions, CurrentAccentName) or 1
            AccentColorBtn.Value = ai
            AccentColorBtn.Label = accentOptions[ai]
        end)
        if lookChanged then pcall(ApplyAppearance) end
        if type(ui.UIBlur) == "boolean" then
            pcall(function()
                Window.UIBlur = ui.UIBlur
                UiSync.Blur.Value = ui.UIBlur
            end)
        end
        if type(ui.Dropshadow) == "boolean" then
            pcall(function()
                Window.Dropshadow = ui.Dropshadow
                UiSync.Shadow.Value = ui.Dropshadow
            end)
        end
        if type(ui.Keybind) == "string" then
            pcall(function()
                local key = Enum.KeyCode[ui.Keybind]
                if key then
                    currentKeybind = key
                    UiSync.Hotkey.Value = key
                end
            end)
        end
    end
    ConfigStore.UIApplier = ApplyLook
    ConfigStore.GetUI = function()
        return {
            Theme = CurrentThemeName,
            Accent = CurrentAccentName,
            UIBlur = Window.UIBlur and true or false,
            Dropshadow = Window.Dropshadow and true or false,
            Keybind = currentKeybind and currentKeybind.Name or "LeftAlt",
        }
    end

    -- ชื่อ config ที่ใช้อยู่ (เลือก/โหลด/สร้าง config แล้วชื่อจะขึ้นตรงนี้) + ปุ่มเซฟ
    ActiveLabel = AddRow("Config in use", "The config you picked or created. Your changes belong to this config."):Label({ Text = "none" })

    local AutoSyncToggle = AddRow("Auto-save into config", "ON: every change is saved into the config in use by itself. OFF: only when you press Enter Save Config."):Toggle({
        Value = ConfigStore.AutoSync(),
        ValueChanged = function(self, value)
            value = value and true or false
            if value == ConfigStore.AutoSync() then return end
            ConfigStore.SetAutoSync(value)
            if value then ConfigStore.SyncActive(HubConfig) end
            UpdateActiveLabel()
            SetCfgStatus(value and "Auto-save is ON" or "Auto-save is OFF - use Enter Save Config")
        end
    })

    AddButtonRow("Enter Save Config", "Save the current switches into the config in use.", "Save", function()
        local name = ConfigStore.Active()
        if not name then SetCfgStatus("No config in use - Create or Load one first") return end
        if ConfigStore.IsDefault(name) then SetCfgStatus("Default config is read-only - Create your own config") return end
        if not canSave then SetCfgStatus("Executor can't save files") return end
        local ok = ConfigStore.SaveActive(HubConfig)
        UpdateActiveLabel()
        SetCfgStatus(ok and ("Saved to: " .. name) or "Save failed")
    end)

    -- ชื่อ config
    AddRow("Config name", "Type a name, then press Create."):TextField({
        Placeholder = "Config name",
        Value = "",
        TextChanged = function(self, text) typedName = text end,
        ValueChanged = function(self, value) typedName = value end,
    })

    AddButtonRow("Create config", "Save the current switches under the name above and start using it.", "Create", function()
        local name = CleanName(typedName)
        if not name then SetCfgStatus("Type a config name first") return end
        if ConfigStore.Exists(name) then SetCfgStatus("That name already exists - pick another name") return end
        if not canSave then SetCfgStatus("Executor can't save files") return end
        ConfigStore.SyncActive(HubConfig) -- เซฟ config เดิมที่ใช้อยู่ให้เรียบร้อยก่อน
        local ok = ConfigStore.Put(name, ConfigStore.Snapshot(HubConfig))
        if ok then ConfigStore.SetActive(name) end
        RefreshList(name)
        UpdateActiveLabel()
        SetCfgStatus(ok and ("Created: " .. name) or "Save failed")
    end)

    -- รายการ config
    local ListRow = ConfigForm:Row()
    ListRow:Left():TitleStack({ Title = "Config list", Subtitle = "Choose a saved config." })
    ListBtn = ListRow:Right():PullDownButton({
        Label = "---",
        Options = currentOptions,
        Value = 1,
        ValueChanged = function(self, index)
            local name = currentOptions[index]
            selectedName = (index and index > 1) and name or nil
            self.Label = name or "---"
        end
    })
    StyleDropdown(ListBtn)

    RefreshList = function(keepName)
        local opts = { "---" }
        for _, n in ipairs(ConfigStore.Names()) do opts[#opts + 1] = n end
        currentOptions = opts
        local idx = (keepName and table.find(opts, keepName)) or 1
        selectedName = idx > 1 and opts[idx] or nil
        pcall(function()
            ListBtn.Options = opts
            ListBtn.Value = idx
            ListBtn.Label = opts[idx]
        end)
    end

    AddButtonRow("Load config", "Switch to the selected config and apply its switches.", "Load", function()
        if not selectedName then SetCfgStatus("Select a config first") return end
        local snap = ConfigStore.Get(selectedName)
        if not snap then SetCfgStatus("Config not found - press Refresh list") return end
        local dropped = ConfigStore.Active() ~= nil and not ConfigStore.AutoSync() and ConfigStore.IsDirty(HubConfig)
        ConfigStore.SyncActive(HubConfig) -- โหมดเซฟเอง = ไม่ทำอะไร / โหมดเซฟอัตโนมัติ = เซฟ config เดิมให้ก่อนสลับ
        ConfigStore.SetActive(selectedName)
        ConfigStore.ApplyCfg(snap)
        ConfigStore.ApplyHub(HubConfig, snap)
        Save()
        UiSync.Refresh() -- สวิตช์/สไลเดอร์บนหน้าจอเปลี่ยนตามทันที ไม่ต้องรันสคริปต์ใหม่
        ConfigStore.ApplyUI(snap) -- หน้าตา: ธีม / Accent / เบลอ / เงา / ปุ่มลัด
        UpdateActiveLabel()
        SetCfgStatus("Loaded: " .. selectedName .. (dropped and "  (unsaved changes dropped)" or ""))
    end)

    AddButtonRow("Delete config", "Delete the selected config.", "Delete", function()
        if not selectedName then SetCfgStatus("Select a config first") return end
        local name = selectedName
        if ConfigStore.IsDefault(name) then SetCfgStatus("The default config can't be deleted") return end
        ConfigStore.Delete(name)
        RefreshList(nil)
        UpdateActiveLabel()
        UpdateAutoloadLabel()
        SetCfgStatus("Deleted: " .. name)
    end)

    AddButtonRow("Refresh list", "Reload the saved configs from file.", "Refresh", function()
        ConfigStore.Reload()
        RefreshList(selectedName)
        UpdateActiveLabel()
        UpdateAutoloadLabel()
        pcall(function() AutoSyncToggle.Value = ConfigStore.AutoSync() end)
        SetCfgStatus("List refreshed")
    end)

    AddButtonRow("Set as autoload", "Load the selected config automatically every time the script starts.", "Set", function()
        if not selectedName then SetCfgStatus("Select a config first") return end
        local ok = ConfigStore.SetAutoload(selectedName)
        UpdateAutoloadLabel()
        SetCfgStatus(ok and ("Autoload: " .. selectedName) or "Save failed")
    end)

    AddButtonRow("Reset autoload", "Stop loading a config automatically.", "Reset", function()
        ConfigStore.SetAutoload(nil)
        UpdateAutoloadLabel()
        SetCfgStatus("Autoload reset")
    end)

    AutoloadLabel = AddRow("Current autoload config", "Loaded when the script starts."):Label({ Text = "none" })
    UpdateAutoloadLabel()
    UpdateActiveLabel()
    RefreshList(ConfigStore.Active())

    -- โหมดเซฟเอง: เช็คทุกวินาทีว่ามีการแก้ที่ยังไม่เซฟไหม แล้วอัปเดตป้ายชื่อ config
    task.spawn(function()
        while Alive() do
            if not ConfigStore.AutoSync() then UpdateActiveLabel() end
            task.wait(1)
        end
    end)

    -- รีเซ็ตทุกอย่างกลับเป็นค่าเริ่มต้นของสคริปต์ (config ที่เซฟไว้ไม่ถูกลบ)
    function UiSync.ResetAll()
        ConfigStore.SyncActive(HubConfig)
        ConfigStore.SetActive(nil) -- กัน Reset ไปทับ config ที่กำลังใช้อยู่
        UpdateActiveLabel()
        for key, value in pairs(UiSync.Defaults.Cfg) do
            if type(value) == "table" then
                local copy = {}
                for i, item in ipairs(value) do copy[i] = item end
                Cfg[key] = copy
            else
                Cfg[key] = value
            end
        end
        for key, value in pairs(UiSync.Defaults.Hub) do HubConfig[key] = value end
        Save()
        UiSync.Refresh()

        -- FPS: ใช้ค่าเริ่มต้นทันที (ปิดล็อก = ไม่จำกัด)
        pcall(Farm.Fps.Apply)

        -- หน้าตา: ธีม / สี / เบลอ / เงา / ปุ่มลัดซ่อนหน้าต่าง (ชุดเดียวกับ Config ค่าเริ่มต้น)
        ApplyLook(ConfigStore.DEFAULT_LOOK)
    end

    local resetArmedAt = 0
    AddButtonRow("Reset to defaults", "Set every switch, slider and the window look back to the default values (same as \"Smooth Hub | Default\"). Saved configs are NOT deleted.", "Reset", function()
        -- กดครั้งแรก = ขอยืนยัน กดอีกครั้งภายใน 5 วินาที = รีเซ็ตจริง
        if os.clock() - resetArmedAt > 5 then
            resetArmedAt = os.clock()
            SetCfgStatus("Press Reset again within 5s to confirm")
            return
        end
        resetArmedAt = 0
        UiSync.ResetAll()
        SetCfgStatus("Everything is back to the default values")
    end, "Destructive")


    -- ค่าเปลี่ยนเมื่อไหร่ ให้เซฟลง config ที่ใช้อยู่ด้วย (ตัวเซฟอัตโนมัติเรียกให้)
    SettingsStore.OnSaved = function()
        ConfigStore.SyncActive(HubConfig)
    end
end

---------------------------------------------------------
-- 💾 เริ่มบันทึกอัตโนมัติ: ค่าเปลี่ยนเมื่อไหร่ จะเซฟลงไฟล์ของไอดีนี้เอง
---------------------------------------------------------
SettingsStore.StartAutoSave("AOTR", function()
    return {
        Cfg = Cfg,
        Hub = HubConfig,
        UI = {
            Theme = CurrentThemeName,
            Accent = CurrentAccentName,
            UIBlur = Window.UIBlur,
            Dropshadow = Window.Dropshadow,
            Keybind = currentKeybind and currentKeybind.Name or "LeftAlt",
        },
    }
end)

-- Save() ทั่วสคริปต์ = สั่งให้ Auto Save เขียนไฟล์ทันที
saveHook = function()
    SettingsStore.Flush("AOTR")
    ConfigStore.SyncActive(HubConfig)
end

---------------------------------------------------------
-- ระบบเบื้องหลังของหมวด Settings
---------------------------------------------------------
-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Alive() and HubConfig.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Alive() and HubConfig.AntiAFK then
        pcall(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- Auto Rejoin (ตอนเด้งออก/โดนเตะ)
pcall(function()
    local errorPrompt = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui", true)
    if errorPrompt then
        errorPrompt.ChildAdded:Connect(function(child)
            if child.Name == "promptOverlay" then
                task.wait(1)
                if Alive() and HubConfig.AutoRejoin then
                    TeleportService:Teleport(HOP_PLACE_ID, LocalPlayer)
                end
            end
        end)
    end
end)

-- Anti Admin
local function CheckAdmin(player)
    if player == LocalPlayer or not HubConfig.AntiAdmin then return end
    pcall(function()
        if player:GetRankInGroup(game.CreatorId) >= 250 or player.UserId == game.CreatorId then
            HopServer()
        end
    end)
end
Players.PlayerAdded:Connect(function(player) if Alive() then CheckAdmin(player) end end)
task.spawn(function()
    while Alive() do
        task.wait(3)
        if HubConfig.AntiAdmin then
            for _, player in ipairs(Players:GetPlayers()) do
                CheckAdmin(player)
            end
        end
    end
end)

-- FPS Lock (ย้ำค่าเรื่อย ๆ เผื่อเกมรีเซ็ต)
task.spawn(function()
    while Alive() do
        pcall(Farm.Fps.Reassert)
        task.wait(1)
    end
end)
end

---------------------------------------------------------
-- 🏝️ แจ้งเตือนตอนโหลดสคริปต์เสร็จ (สไตล์ Dynamic Island แบบ Now Playing)
-- ไหลลงมาจากขอบจอ -> ขยายเป็นการ์ด -> เนื้อหาไล่ขึ้นทีละส่วน -> เก็บกลับแล้วเลื่อนขึ้นหายไป
---------------------------------------------------------
task.spawn(function()
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")

    -- 🖼️ โลโก้ค่าย: ใส่อย่างใดอย่างหนึ่ง (ไม่ใส่ทั้งคู่ = ใช้ตัว S แทน)
    --  1) LOGO_ASSET_ID = เลข ID ของรูป (ต้องเป็น Image ID ที่อัปโหลดบน Roblox แล้ว) เช่น 123456789
    --  2) LOGO_URL = ลิงก์ไฟล์รูป .png บน GitHub (ต้องใช้ executor ที่มี getcustomasset)
    --  3) (ค่าเริ่มต้น) โลโก้ค่ายฝังอยู่ในสคริปต์ LOGO_EMBED_B64 ด้านล่าง เขียนเป็นไฟล์แล้วโหลดด้วย getcustomasset
    --     ถ้า executor ไม่รองรับ writefile/getcustomasset จะกลับไปใช้ตัว S เหมือนเดิม
    local LOGO_ASSET_ID = nil
    local LOGO_URL = nil
    local LOGO_EMBED_B64 = [==[
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
]==]

    local function B64Decode(data)
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local lookup = {}
        for i = 1, 64 do lookup[chars:sub(i, i)] = i - 1 end
        data = data:gsub("[^%w%+/=]", "")
        local out, n = {}, 0
        for i = 1, #data, 4 do
            local a, b, c, d = data:sub(i, i), data:sub(i + 1, i + 1), data:sub(i + 2, i + 2), data:sub(i + 3, i + 3)
            local v = (lookup[a] or 0) * 262144 + (lookup[b] or 0) * 4096 + (lookup[c] or 0) * 64 + (lookup[d] or 0)
            n = n + 1
            out[n] = string.char(math.floor(v / 65536) % 256)
            if c ~= "=" and c ~= "" then n = n + 1 out[n] = string.char(math.floor(v / 256) % 256) end
            if d ~= "=" and d ~= "" then n = n + 1 out[n] = string.char(v % 256) end
        end
        return table.concat(out)
    end

    local function ResolveLogo()
        if LOGO_ASSET_ID then return "rbxassetid://" .. tostring(LOGO_ASSET_ID) end
        if LOGO_URL and type(getcustomasset) == "function" and type(writefile) == "function" then
            local ok, asset = pcall(function()
                local path = "SmoothHub/logo.png"
                if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("SmoothHub") then
                    makefolder("SmoothHub")
                end
                writefile(path, game:HttpGet(LOGO_URL))
                return getcustomasset(path)
            end)
            if ok and asset then return asset end
        end
        if LOGO_EMBED_B64 and type(getcustomasset) == "function" and type(writefile) == "function" then
            local ok, asset = pcall(function()
                if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("SmoothHub") then
                    makefolder("SmoothHub")
                end
                local path = "SmoothHub/logo_smooth.png"
                writefile(path, B64Decode(LOGO_EMBED_B64))
                return getcustomasset(path)
            end)
            if ok and asset then return asset end
        end
        return nil
    end
    local logoImage = ResolveLogo()

    pcall(function()
        local old = parent:FindFirstChild("SmoothHubIsland")
        if old then old:Destroy() end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "SmoothHubIsland"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local okParent = pcall(function() gui.Parent = parent end)
    if not okParent or not gui.Parent then gui.Parent = PlayerGui end

    local BLUE = Color3.fromHex("#0A84FF")
    local VIOLET = Color3.fromHex("#5E5CE6")
    local RED = Color3.fromHex("#FF3B30")      -- ขอบการ์ด (ตามโลโก้ค่าย)
    local DARK_RED = Color3.fromHex("#B3001B")
    local GRAY = Color3.fromRGB(150, 150, 158)

    -- ขนาด: จอแคบ (มือถือ) ให้การ์ดแคบลงและสูงขึ้นนิดหน่อย
    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
    local fullW = math.min(400, viewport.X - 24)
    local fullH = fullW < 380 and 132 or 118
    local smallW, smallH = 110, 32
    local TOP = 12

    local function tw(obj, time, props, style, dir)
        local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
        t:Play()
        return t
    end

    -- ───── ตัวแคปซูล ─────
    local pill = Instance.new("Frame")
    pill.Name = "Pill"
    pill.AnchorPoint = Vector2.new(0.5, 0)
    pill.Position = UDim2.new(0.5, 0, 0, -smallH - 8) -- เริ่มอยู่นอกจอด้านบน
    pill.Size = UDim2.fromOffset(smallW, smallH)
    pill.BackgroundColor3 = Color3.new(0, 0, 0)
    pill.BackgroundTransparency = 1
    pill.BorderSizePixel = 0
    pill.ClipsDescendants = true
    pill.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, smallH / 2)
    corner.Parent = pill

    -- ขอบเรืองแสงไล่สีแดง (หมุนช้าๆ ตอนแสดง)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Transparency = 1
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = pill
    local strokeGrad = Instance.new("UIGradient")
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, RED),
        ColorSequenceKeypoint.new(0.5, DARK_RED),
        ColorSequenceKeypoint.new(1, RED),
    })
    strokeGrad.Parent = stroke

    local function newGroup(name)
        local g = Instance.new("CanvasGroup")
        g.Name = name
        g.BackgroundTransparency = 1
        g.Size = UDim2.fromOffset(fullW, fullH)
        g.Position = UDim2.fromOffset(0, 10)
        g.GroupTransparency = 1
        g.Parent = pill
        return g
    end
    local headGroup = newGroup("Head")
    local barGroup = newGroup("Bar")

    -- ───── ส่วนบน: ไอคอน + ชื่อ + ข้อความ + คลื่นเสียง ─────
    local icon = Instance.new("Frame")
    icon.Size = UDim2.fromOffset(52, 52)
    icon.Position = UDim2.fromOffset(18, 16)
    icon.BackgroundColor3 = BLUE
    icon.BorderSizePixel = 0
    icon.Parent = headGroup
    do
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 13) c.Parent = icon
        if logoImage then
            -- โลโก้ค่าย: เต็มช่องไอคอน มุมมนตามกรอบ
            icon.BackgroundTransparency = 1
            local img = Instance.new("ImageLabel")
            img.BackgroundTransparency = 1
            img.Size = UDim2.fromScale(1, 1)
            img.Image = logoImage
            img.ScaleType = Enum.ScaleType.Fit
            img.Parent = icon
            local ic = Instance.new("UICorner") ic.CornerRadius = UDim.new(0, 13) ic.Parent = img
        else
            local g = Instance.new("UIGradient")
            g.Color = ColorSequence.new(BLUE, VIOLET)
            g.Rotation = 45
            g.Parent = icon
            local letter = Instance.new("TextLabel")
            letter.BackgroundTransparency = 1
            letter.Size = UDim2.fromScale(1, 1)
            letter.Font = Enum.Font.GothamBlack
            letter.Text = "S"
            letter.TextSize = 28
            letter.TextColor3 = Color3.new(1, 1, 1)
            letter.Parent = icon
        end
    end
    local iconScale = Instance.new("UIScale")
    iconScale.Scale = 0.5
    iconScale.Parent = icon

    local textW = fullW - 82 - 70
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(82, 17)
    title.Size = UDim2.fromOffset(textW, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = "Smooth Hub"
    title.TextSize = 17
    title.TextColor3 = BLUE
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = headGroup

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.fromOffset(82, 39)
    sub.Size = UDim2.fromOffset(textW, 36)
    sub.Font = Enum.Font.GothamMedium
    sub.RichText = true
    sub.TextWrapped = true
    sub.TextSize = 13
    sub.TextColor3 = Color3.fromRGB(215, 215, 222)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextYAlignment = Enum.TextYAlignment.Top
    -- แดง = ชื่อสคริปต์, เขียว = ชื่อค่าย
    sub.Text = 'Loaded <font color="#FF453A">Attack on Titan script</font> by <font color="#30D158">Smooth Hub</font> successfully'
    sub.Parent = headGroup

    local wave = Instance.new("Frame")
    wave.BackgroundTransparency = 1
    wave.Size = UDim2.fromOffset(34, 28)
    wave.Position = UDim2.fromOffset(fullW - 20 - 34, 24)
    wave.Parent = headGroup
    local bars = {}
    for i = 1, 5 do
        local b = Instance.new("Frame")
        b.AnchorPoint = Vector2.new(0.5, 0.5)
        b.Position = UDim2.fromOffset(3 + (i - 1) * 7, 14)
        b.Size = UDim2.fromOffset(3, 8)
        b.BackgroundColor3 = BLUE
        b.BorderSizePixel = 0
        b.Parent = wave
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = b
        bars[i] = b
    end

    -- ───── ส่วนล่าง: แถบความคืบหน้า + แถวสถานะ ─────
    local trackY = fullH - 40
    local track = Instance.new("Frame")
    track.Position = UDim2.fromOffset(18, trackY)
    track.Size = UDim2.fromOffset(fullW - 36, 4)
    track.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
    track.BorderSizePixel = 0
    track.Parent = barGroup
    do
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = track
    end
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(0, 1)
    fill.BackgroundColor3 = Color3.new(1, 1, 1)
    fill.BorderSizePixel = 0
    fill.Parent = track
    do
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = fill
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(BLUE, VIOLET)
        g.Parent = fill
    end

    local footL = Instance.new("TextLabel")
    footL.BackgroundTransparency = 1
    footL.Position = UDim2.fromOffset(18, trackY + 10)
    footL.Size = UDim2.fromOffset((fullW - 36) * 0.7, 16)
    footL.Font = Enum.Font.Gotham
    footL.Text = "Attack on Titan Revolution"
    footL.TextSize = 11
    footL.TextColor3 = GRAY
    footL.TextXAlignment = Enum.TextXAlignment.Left
    footL.Parent = barGroup

    local footR = Instance.new("TextLabel")
    footR.BackgroundTransparency = 1
    footR.AnchorPoint = Vector2.new(1, 0)
    footR.Position = UDim2.fromOffset(fullW - 18, trackY + 10)
    footR.Size = UDim2.fromOffset((fullW - 36) * 0.3, 16)
    footR.Font = Enum.Font.GothamBold
    footR.Text = "Ready"
    footR.TextSize = 11
    footR.TextColor3 = Color3.fromHex("#30D158")
    footR.TextXAlignment = Enum.TextXAlignment.Right
    footR.Parent = barGroup

    -- ───── ลูปเอฟเฟกต์ที่เคลื่อนไหวตลอดตอนแสดง (คลื่นเสียง + ขอบหมุน) ─────
    local running = true
    local loopConn
    loopConn = RunService.Heartbeat:Connect(function()
        if not running or not gui.Parent then
            if loopConn then loopConn:Disconnect() end
            return
        end
        local t = os.clock()
        for i, b in ipairs(bars) do
            local h = 6 + 18 * (0.5 + 0.5 * math.sin(t * 6.5 + i * 1.35))
            b.Size = UDim2.fromOffset(3, h)
        end
        strokeGrad.Rotation = (t * 70) % 360
    end)

    local function finish()
        running = false
        pcall(function() if loopConn then loopConn:Disconnect() end end)
        pcall(function() gui:Destroy() end)
    end

    -- ───── เริ่มโชว์ ─────
    -- 1) แคปซูลเล็กไหลลงมาจากขอบจอ
    tw(pill, 0.6, { Position = UDim2.new(0.5, 0, 0, TOP), BackgroundTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tw(stroke, 0.6, { Transparency = 0.6 })
    task.wait(0.55)
    if not Alive() then finish() return end

    -- 2) ขยายเป็นการ์ด (มุมโค้งเปลี่ยนจากแคปซูลเป็นการ์ดพร้อมกัน)
    tw(pill, 0.8, { Size = UDim2.fromOffset(fullW, fullH) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tw(corner, 0.8, { CornerRadius = UDim.new(0, 34) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tw(stroke, 0.8, { Transparency = 0.15 })

    -- 3) เนื้อหาไล่ขึ้นทีละส่วน
    task.wait(0.3)
    tw(headGroup, 0.55, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tw(iconScale, 0.6, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.wait(0.2)
    tw(barGroup, 0.55, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tw(fill, 1.7, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

    -- 4) ค้างไว้ให้อ่าน
    task.wait(3.2)

    -- 5) เก็บกลับ: เนื้อหาจางลงก่อน -> การ์ดหุบเป็นแคปซูล -> เลื่อนขึ้นหายไปนอกจอ
    tw(barGroup, 0.3, { GroupTransparency = 1, Position = UDim2.fromOffset(0, 6) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.wait(0.08)
    tw(headGroup, 0.3, { GroupTransparency = 1, Position = UDim2.fromOffset(0, 6) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    tw(iconScale, 0.3, { Scale = 0.6 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.wait(0.28)
    tw(pill, 0.7, { Size = UDim2.fromOffset(smallW, smallH) }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    tw(corner, 0.7, { CornerRadius = UDim.new(0, smallH / 2) }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    tw(stroke, 0.7, { Transparency = 0.6 })
    task.wait(0.75)
    tw(pill, 0.5, { Position = UDim2.new(0.5, 0, 0, -smallH - 8), BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    tw(stroke, 0.4, { Transparency = 1 })
    task.wait(0.55)
    finish()
end)

-- DEV เท่านั้น: เปิดตารางภายในให้เรียกจาก executor
if SH.DEV then
    _G.SmoothHubFarm = SH.Farm
    _G.SmoothHubSpin = SH.Spin
end
SH.say("Loaded successfully (" .. (IN_MENU and "Lobby" or "In-game") .. ").")