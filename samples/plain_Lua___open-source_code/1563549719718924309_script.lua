-- Ovaz Hub Thai by Zuwz - v2 (native UI text, no floating overlay)
-- Different from previous Ravz and Banana translations.
-- Only display text is translated; never renames monsters, tools or objects.
-- Note: third-party UI may still use TextButton.Text as a control key.
-- Stop: _G.OVAZ_ZUWZ_TH_V2.Stop()
-- Status: print(_G.OVAZ_ZUWZ_TH_V2.GetStatus())

local LOAD_URL = "https://raw.githubusercontent.com/bloxfruitsnokey/Redz-Hub/refs/heads/main/Ovaz/load.luau"
local CONFIG = {
    PollInterval = 1.00,
    TranslateKnownButtons = true,  -- exact display phrases only, never dropdown values
    LogDiagnostics = true,
}

local WORDS = {
    ["Info And Status"] = "ข้อมูลและสถานะ",
    ["Tab Info And Status"] = "ข้อมูลและสถานะ",
    ["Farm"] = "ฟาร์ม",
    ["Farming"] = "การฟาร์ม",
    ["Tab Farming"] = "เมนูฟาร์ม",
    ["Setting"] = "ตั้งค่า",
    ["Settings"] = "ตั้งค่า",
    ["Tab Setting"] = "เมนูตั้งค่า",
    ["Fishing"] = "ตกปลา",
    ["Tab Fishing"] = "เมนูตกปลา",
    ["Quest And Item"] = "เควสต์และไอเทม",
    ["Tab Quest And Item"] = "เมนูเควสต์และไอเทม",
    ["Sea Event"] = "กิจกรรมทะเล",
    ["Sea Events"] = "กิจกรรมทะเล",
    ["Tab Sea Event"] = "เมนูกิจกรรมทะเล",
    ["Mirage And Race"] = "มิราจและเผ่า",
    ["Tab Mirage And Race"] = "เมนูมิราจและเผ่า",
    ["Volcano Event"] = "กิจกรรมภูเขาไฟ",
    ["Tab Volcano Event"] = "เมนูภูเขาไฟ",
    ["Stats And Esp"] = "ค่าสเตตัสและ ESP",
    ["Stats And ESP"] = "ค่าสเตตัสและ ESP",
    ["Tab Stats And Esp"] = "เมนูสเตตัสและ ESP",
    ["Fruit And Raid"] = "ผลปีศาจและลงดัน",
    ["Tab Fruit And Raid"] = "เมนูผลปีศาจและลงดัน",
    ["Local Player"] = "ตัวละครของฉัน",
    ["Tab Local Player"] = "เมนูตัวละคร",
    ["Teleport"] = "วาร์ป",
    ["Tab Teleport"] = "เมนูวาร์ป",
    ["Main"] = "หน้าหลัก",
    ["Status"] = "สถานะ",
    ["Info"] = "ข้อมูล",
    ["Information"] = "ข้อมูล",
    ["General"] = "ทั่วไป",
    ["Misc"] = "อื่น ๆ",
    ["Miscellaneous"] = "อื่น ๆ",
    ["Player"] = "ผู้เล่น",
    ["Config"] = "ตั้งค่า",
    ["Configuration"] = "ตั้งค่าระบบ",
    ["Search"] = "ค้นหา",
    ["Search Settings"] = "ค้นหาการตั้งค่า",
    ["Search Settings..."] = "ค้นหาการตั้งค่า...",
    ["Search Options..."] = "ค้นหาฟังก์ชัน...",
    ["Refresh"] = "รีเฟรช",
    ["Auto Farm"] = "ฟาร์มอัตโนมัติ",
    ["Auto Farm Level"] = "เก็บเลเวลอัตโนมัติ",
    ["Auto Level"] = "เก็บเลเวลอัตโนมัติ",
    ["Auto Level Farm"] = "เก็บเลเวลอัตโนมัติ",
    ["Auto Farm Nearest"] = "ฟาร์มศัตรูใกล้สุดอัตโนมัติ",
    ["Auto Farm Quest"] = "ทำเควสต์ฟาร์มอัตโนมัติ",
    ["Auto Quest"] = "ทำเควสต์อัตโนมัติ",
    ["Auto Quest Farm"] = "ฟาร์มเควสต์อัตโนมัติ",
    ["Accept Quests"] = "รับเควสต์",
    ["Auto Accept Quest"] = "รับเควสต์อัตโนมัติ",
    ["Auto Farm Boss"] = "ฟาร์มบอสอัตโนมัติ",
    ["Auto Boss"] = "จัดการบอสอัตโนมัติ",
    ["Select Boss"] = "เลือกบอส",
    ["Choose Boss"] = "เลือกบอส",
    ["Select Weapon"] = "เลือกอาวุธ",
    ["Choose Weapon"] = "เลือกอาวุธ",
    ["Select Method"] = "เลือกวิธีฟาร์ม",
    ["Select Mode"] = "เลือกโหมด",
    ["Auto Equip Weapon"] = "ถืออาวุธอัตโนมัติ",
    ["Auto Haki"] = "เปิดฮาคิอัตโนมัติ",
    ["Auto Buso"] = "เปิดฮาคิอัตโนมัติ",
    ["Auto Ken"] = "เปิดฮาคิสังเกตอัตโนมัติ",
    ["Auto Armament"] = "เปิดฮาคิเกราะอัตโนมัติ",
    ["Bring Mob"] = "ดึงมอนมารวม",
    ["Bring Mobs"] = "ดึงมอนมารวม",
    ["Mob Aura"] = "โจมตีมอนรอบตัว",
    ["Kill Aura"] = "โจมตีรอบตัว",
    ["Fast Attack"] = "โจมตีเร็ว",
    ["Attack Speed"] = "ความเร็วการโจมตี",
    ["Auto Attack"] = "โจมตีอัตโนมัติ",
    ["Auto Farm Material"] = "ฟาร์มวัตถุดิบอัตโนมัติ",
    ["Select Material"] = "เลือกวัตถุดิบ",
    ["Choose Material"] = "เลือกวัตถุดิบ",
    ["Auto Materials"] = "ฟาร์มวัตถุดิบอัตโนมัติ",
    ["Auto Farm Ectoplasm"] = "ฟาร์ม Ectoplasm อัตโนมัติ",
    ["Auto Factory Raid"] = "ทำกิจกรรม Factory อัตโนมัติ",
    ["Auto Pirate Raid"] = "ทำกิจกรรมโจรสลัดอัตโนมัติ",
    ["Auto Chest"] = "เก็บหีบอัตโนมัติ",
    ["Auto Collect Chests"] = "เก็บหีบอัตโนมัติ",
    ["Auto Collect Chest"] = "เก็บหีบอัตโนมัติ",
    ["Auto Collect Berry"] = "เก็บ Berry อัตโนมัติ",
    ["Auto Farm Bone"] = "ฟาร์มกระดูกอัตโนมัติ",
    ["Auto Bones"] = "ฟาร์มกระดูกอัตโนมัติ",
    ["Auto Random Bones"] = "สุ่มของด้วยกระดูกอัตโนมัติ",
    ["Bones"] = "กระดูก",
    ["Farming Bone"] = "การฟาร์มกระดูก",
    ["Auto Soul Reaper"] = "เรียก Soul Reaper อัตโนมัติ",
    ["Auto Try Luck Gravestone"] = "ลองเสี่ยงโชคที่หลุมศพอัตโนมัติ",
    ["Auto Pray Gravestone"] = "สวดที่หลุมศพอัตโนมัติ",
    ["Auto Farm Mirror"] = "ฟาร์ม Mirror อัตโนมัติ",
    ["Auto Cake Prince"] = "ฟาร์ม Cake Prince อัตโนมัติ",
    ["Auto Summon Cake Prince"] = "เรียก Cake Prince อัตโนมัติ",
    ["Auto Farm Cake Prince"] = "ฟาร์ม Cake Prince อัตโนมัติ",
    ["Auto Dough King [Fully]"] = "ทำ Dough King ครบขั้นตอนอัตโนมัติ",
    ["Auto Farm Dough King"] = "ฟาร์ม Dough King อัตโนมัติ",
    ["Auto Farm Dough King + Hop"] = "ฟาร์ม Dough King และเปลี่ยนเซิร์ฟอัตโนมัติ",
    ["Auto Done Bartilo Quest"] = "ทำเควสต์ Bartilo อัตโนมัติ",
    ["Auto Done Citizen Quest"] = "ทำเควสต์ Citizen อัตโนมัติ",
    ["Auto Elite Hunter"] = "ทำเควสต์ Elite Hunter อัตโนมัติ",
    ["Auto Elite"] = "ฟาร์ม Elite อัตโนมัติ",
    ["Auto Yama"] = "ปลดล็อกดาบ Yama อัตโนมัติ",
    ["Auto Tushita"] = "ปลดล็อกดาบ Tushita อัตโนมัติ",
    ["Auto Cursed Dual Katana"] = "ทำดาบคู่ CDK อัตโนมัติ",
    ["Auto Saber"] = "ทำดาบ Saber อัตโนมัติ",
    ["Auto Soul Guitar"] = "ทำ Soul Guitar อัตโนมัติ",
    ["Auto Observation"] = "ฝึกฮาคิสังเกตอัตโนมัติ",
    ["Auto Farm Observation"] = "ฝึกฮาคิสังเกตอัตโนมัติ",
    ["Auto Observation V2"] = "ทำฮาคิสังเกต V2 อัตโนมัติ",
    ["Observation"] = "ฮาคิสังเกต",
    ["Instinct / Observation"] = "ฮาคิสังเกต",
    ["Auto Farm Mastery"] = "ฟาร์มมาสเตอรี่อัตโนมัติ",
    ["Mastery"] = "มาสเตอรี่",
    ["Auto Mastery Fruits"] = "ฟาร์มมาสเตอรี่ผลปีศาจอัตโนมัติ",
    ["Auto Mastery Fruit"] = "ฟาร์มมาสเตอรี่ผลปีศาจอัตโนมัติ",
    ["Auto Mastery Gun"] = "ฟาร์มมาสเตอรี่ปืนอัตโนมัติ",
    ["Auto Mastery Sword"] = "ฟาร์มมาสเตอรี่ดาบอัตโนมัติ",
    ["Auto Mastery All Sword"] = "ฟาร์มมาสเตอรี่ดาบทุกเล่มอัตโนมัติ",
    ["Auto Fishing"] = "ตกปลาอัตโนมัติ",
    ["Auto Fish"] = "ตกปลาอัตโนมัติ",
    ["Select Fishing Rod"] = "เลือกคันเบ็ด",
    ["Select Rod"] = "เลือกคันเบ็ด",
    ["Select Bait"] = "เลือกเหยื่อ",
    ["Auto Buy Bait"] = "ซื้อเหยื่ออัตโนมัติ",
    ["Auto Sell Fish"] = "ขายปลาอัตโนมัติ",
    ["Auto Catch Fish"] = "จับปลาอัตโนมัติ",
    ["Fishing Rod"] = "คันเบ็ด",
    ["Bait"] = "เหยื่อ",
    ["Auto Sea Event"] = "ทำกิจกรรมทะเลอัตโนมัติ",
    ["Auto Sea Beast"] = "ล่า Sea Beast อัตโนมัติ",
    ["Auto Shark"] = "ล่าฉลามอัตโนมัติ",
    ["Auto Terrorshark"] = "ล่า Terrorshark อัตโนมัติ",
    ["Auto Leviathan"] = "ทำ Leviathan อัตโนมัติ",
    ["Auto Shark Anchor"] = "ทำ Shark Anchor อัตโนมัติ",
    ["Select Boat"] = "เลือกเรือ",
    ["Auto Drive Boat"] = "ขับเรืออัตโนมัติ",
    ["Boat Speed"] = "ความเร็วเรือ",
    ["Auto Buy Boat"] = "ซื้อเรืออัตโนมัติ",
    ["Auto Ghost Ship"] = "ตีเรือผีอัตโนมัติ",
    ["Auto Kitsune Island"] = "หาเกาะ Kitsune อัตโนมัติ",
    ["Auto Azure Ember"] = "เก็บ Azure Ember อัตโนมัติ",
    ["Auto Find Mirage"] = "ค้นหาเกาะมิราจอัตโนมัติ",
    ["Find Mirage Island"] = "ค้นหาเกาะมิราจ",
    ["Mirage Island"] = "เกาะมิราจ",
    ["Auto Blue Gear"] = "หาเฟืองฟ้าอัตโนมัติ",
    ["Auto Race V4"] = "ทำเผ่า V4 อัตโนมัติ",
    ["Auto V4 Trials"] = "ทำบททดสอบ V4 อัตโนมัติ",
    ["Auto Trial"] = "ทำบททดสอบอัตโนมัติ",
    ["Auto Gear"] = "หาเฟืองอัตโนมัติ",
    ["Upgrade Races V3"] = "อัปเกรดเผ่า V3",
    ["Auto Upgrade Human V3"] = "ทำเผ่า Human V3 อัตโนมัติ",
    ["Auto Upgrade Mink V3"] = "ทำเผ่า Mink V3 อัตโนมัติ",
    ["Auto Upgrade Skypiea V3"] = "ทำเผ่า Skypiea V3 อัตโนมัติ",
    ["Auto Upgrade FishMan V3"] = "ทำเผ่า Fishman V3 อัตโนมัติ",
    ["Auto Ghoul"] = "ทำเผ่า Ghoul อัตโนมัติ",
    ["Auto Cyborg"] = "ทำเผ่า Cyborg อัตโนมัติ",
    ["Auto Find Prehistoric Island"] = "หาเกาะดึกดำบรรพ์อัตโนมัติ",
    ["Prehistoric Island"] = "เกาะดึกดำบรรพ์",
    ["Auto Patch Prehistoric Event"] = "ทำกิจกรรมภูเขาไฟอัตโนมัติ",
    ["Auto Collect Dino Bones"] = "เก็บกระดูกไดโนเสาร์อัตโนมัติ",
    ["Auto Collect Dragon Eggs"] = "เก็บไข่มังกรอัตโนมัติ",
    ["Auto Craft Volcanic Magnet"] = "คราฟต์ Volcanic Magnet อัตโนมัติ",
    ["Craft Volcanic Magnet"] = "คราฟต์ Volcanic Magnet",
    ["Auto Reset When Complete Volcano"] = "รีเซ็ตเมื่อจบกิจกรรมภูเขาไฟ",
    ["Auto Collect Fruits"] = "เก็บผลปีศาจอัตโนมัติ",
    ["Auto Collect Fruit"] = "เก็บผลปีศาจอัตโนมัติ",
    ["Auto Store Fruit"] = "เก็บผลปีศาจเข้าคลังอัตโนมัติ",
    ["Auto Buy Fruit"] = "ซื้อผลปีศาจอัตโนมัติ",
    ["Auto Random Fruit"] = "สุ่มผลปีศาจอัตโนมัติ",
    ["Fruit Stock"] = "รายการผลปีศาจในร้าน",
    ["Check Fruit Stock"] = "เช็กร้านขายผลปีศาจ",
    ["Fruit Sniper"] = "ซื้อผลปีศาจที่เลือกอัตโนมัติ",
    ["Auto Raid"] = "ลงดันอัตโนมัติ",
    ["Raid"] = "ลงดัน",
    ["Raids"] = "ลงดัน",
    ["Dungeon Event / Raiding"] = "กิจกรรมดันเจี้ยน / ลงดัน",
    ["Raiding Menu"] = "เมนูลงดัน",
    ["Select Dungeon Chip"] = "เลือกชิปลงดัน",
    ["Select Chip"] = "เลือกชิปลงดัน",
    ["Auto Select Dungeon Chip"] = "เลือกชิปลงดันอัตโนมัติ",
    ["Auto Start Raid"] = "เริ่มลงดันอัตโนมัติ",
    ["Auto Complete Raid [Safety]"] = "ลงดันให้เสร็จอัตโนมัติ [ปลอดภัย]",
    ["Auto Complete Raid"] = "ลงดันให้เสร็จอัตโนมัติ",
    ["Auto Buy Raid Chip"] = "ซื้อชิปลงดันอัตโนมัติ",
    ["Buy Dungeon Chips [Beli]"] = "ซื้อชิปลงดันด้วย Beli",
    ["Buy Dungeon Chips [Devil Fruit]"] = "ซื้อชิปลงดันด้วยผลปีศาจ",
    ["Teleport To Lab"] = "วาร์ปไปห้องแล็บ",
    ["Auto Next Island"] = "ไปเกาะถัดไปอัตโนมัติ",
    ["Auto Awakening"] = "ปลุกพลังอัตโนมัติ",
    ["Stats"] = "ค่าสเตตัส",
    ["Auto Stats"] = "อัปสเตตัสอัตโนมัติ",
    ["Select Stat"] = "เลือกค่าสเตตัส",
    ["Choose Stats"] = "เลือกค่าสเตตัส",
    ["Auto Upgrade Stats"] = "อัปค่าสเตตัสอัตโนมัติ",
    ["ESP"] = "ESP",
    ["ESP Player"] = "ESP ผู้เล่น",
    ["ESP Players"] = "ESP ผู้เล่น",
    ["ESP Fruit"] = "ESP ผลปีศาจ",
    ["ESP Fruits"] = "ESP ผลปีศาจ",
    ["ESP Chest"] = "ESP หีบ",
    ["ESP Chests"] = "ESP หีบ",
    ["ESP Boss"] = "ESP บอส",
    ["Auto Teleport"] = "วาร์ปอัตโนมัติ",
    ["Teleport To Island"] = "วาร์ปไปเกาะ",
    ["Select Island"] = "เลือกเกาะ",
    ["Choose Island"] = "เลือกเกาะ",
    ["Rejoin Server"] = "เข้าเซิร์ฟเดิมใหม่",
    ["Server Hop"] = "เปลี่ยนเซิร์ฟเวอร์",
    ["Auto Hop"] = "เปลี่ยนเซิร์ฟเวอร์อัตโนมัติ",
    ["Auto Rejoin"] = "เข้าเกมใหม่อัตโนมัติ",
    ["Anti AFK"] = "ป้องกันหลุด AFK",
    ["Noclip"] = "เดินทะลุสิ่งกีดขวาง",
    ["Infinite Jump"] = "กระโดดไม่จำกัด",
    ["Walk Speed"] = "ความเร็วเดิน",
    ["Fly Speed"] = "ความเร็วบิน",
    ["Tween Speed"] = "ความเร็วเคลื่อนที่",
    ["Low Graphics"] = "ลดกราฟิก",
    ["FPS Boost"] = "เพิ่ม FPS",
    ["Save Config"] = "บันทึกการตั้งค่า",
    ["Load Config"] = "โหลดการตั้งค่า",
    ["Reset Config"] = "รีเซ็ตการตั้งค่า",
    ["Auto Buy"] = "ซื้ออัตโนมัติ",
    ["Auto Claim"] = "รับรางวัลอัตโนมัติ",
    ["Select"] = "เลือก",
    ["Choose"] = "เลือก",
    ["None"] = "ไม่มี",
    ["Any"] = "ทั้งหมด",
    ["All"] = "ทั้งหมด",
    ["On"] = "เปิด",
    ["Off"] = "ปิด",
    ["Open"] = "เปิด",
    ["Closed"] = "ปิด",
    ["Idle"] = "รอทำงาน",
    ["Start"] = "เริ่ม",
    ["Stop"] = "หยุด",
    ["Buy"] = "ซื้อ",
    ["Sell"] = "ขาย",
    ["Equip"] = "สวมใส่",
    ["Update"] = "อัปเดต",
    ["Select Boss Shop Items"] = "เลือกของจากร้านบอส",
    ["Auto Buy Arena Shop"] = "ซื้อของร้านบอสอัตโนมัติ",
    ["Auto Boss Fight"] = "สู้บอสอัตโนมัติ",
    ["Prioritize Crystals"] = "โจมตีคริสตัลก่อน",
    ["Auto Claim Boss Mastery"] = "รับรางวัลมาสเตอรี่บอสอัตโนมัติ",
    ["Auto Enter Boss Event"] = "เข้ากิจกรรมบอสอัตโนมัติ",
    ["Auto Return to Lobby"] = "กลับล็อบบี้อัตโนมัติ",
}

-- These are visible labels from the user's Ovaz screenshot, NOT gameplay values.
WORDS["Select Weapon: Melee"] = "เลือกอาวุธ: Melee"
WORDS["UI Scale"] = "ขนาด UI"
WORDS["Chest"] = "หีบสมบัติ"
WORDS["Auto Farm Chest"] = "ฟาร์มหีบอัตโนมัติ"
WORDS["Auto Chest Bypass"] = "เก็บหีบแบบ Bypass อัตโนมัติ"
WORDS["Stop Items"] = "หยุดฟาร์มไอเทม"

-- Never translate dropdown choices, usernames, boss/NPC/enemy names or status values.
local NON_CONTROL_WORDS = {
    ["Melee"] = true, ["Sword"] = true, ["Gun"] = true,
    ["Blox Fruit"] = true, ["Normal"] = true,
    ["Combat"] = true, ["Bypass"] = true,
}
local CONTROL_WORDS = {
    ["Tab Info And Status"] = true, ["Tab Farming"] = true,
    ["Tab Setting"] = true, ["Tab Fishing"] = true,
    ["Tab Quest And Item"] = true, ["Tab Sea Event"] = true,
    ["Tab Mirage And Race"] = true, ["Tab Volcano Event"] = true,
    ["Tab Stats And Esp"] = true, ["Tab Fruit And Raid"] = true,
    ["Tab Local Player"] = true, ["Tab Teleport"] = true,
    ["Select Weapon"] = true, ["UI Scale"] = true,
    ["Auto Farm Level"] = true, ["Auto Farm Nearest"] = true,
    ["Auto Factory Raid"] = true, ["Auto Pirate Raid"] = true,
    ["Auto Farm Ectoplasm"] = true, ["Auto Farm Chest"] = true,
    ["Auto Chest Bypass"] = true, ["Stop Items"] = true,
}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local API_NAME = "OVAZ_ZUWZ_TH_V2"
local previous = rawget(_G, API_NAME)
if type(previous) == "table" and type(previous.Stop) == "function" then
    pcall(previous.Stop)
end

local api = {
    Running = true,
    Translated = 0,
    Scans = 0,
    FoundHub = false,
    LoaderStarted = false,
    LoaderReturned = false,
    LoaderError = nil,
}
_G[API_NAME] = api

local originals = setmetatable({}, {__mode = "k"})
local missing = {}
local credit
local targetGui
local titleObject

local function clean(s)
    if type(s) ~= "string" or #s > 350 then return "" end
    return (s:gsub("<[^>]->", ""):match("^%s*(.-)%s*$") or "")
end

local function isText(o)
    return o:IsA("TextLabel") or o:IsA("TextButton")
end

local function getRoots()
    local arr, seen = {}, {}
    local function add(obj)
        if typeof(obj) == "Instance" and not seen[obj] then
            arr[#arr + 1] = obj
            seen[obj] = true
        end
    end
    local player = Players.LocalPlayer
    if player then add(player:FindFirstChildOfClass("PlayerGui")) end
    add(CoreGui)
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok then add(result) end
    end
    return arr
end

local NAVIGATION = {
    ["Tab Info And Status"] = true, ["Tab Farming"] = true,
    ["Tab Setting"] = true, ["Tab Fishing"] = true,
    ["Tab Quest And Item"] = true, ["Tab Sea Event"] = true,
    ["Tab Mirage And Race"] = true, ["Tab Volcano Event"] = true,
    ["Tab Stats And Esp"] = true, ["Tab Fruit And Raid"] = true,
    ["Tab Local Player"] = true, ["Tab Teleport"] = true,
}

local function titleCandidate(txt)
    local s = clean(txt):lower()
    return (s:find("ovaz", 1, true) and s:find("hub", 1, true)) ~= nil
end

local function safeDescendants(obj)
    local ok, result = pcall(function() return obj:GetDescendants() end)
    return ok and result or {}
end

local function locateHub()
    -- Try the header first. It may be either a TextLabel or a TextButton.
    for _, root in ipairs(getRoots()) do
        local descendants = safeDescendants(root)
        for _, node in ipairs(descendants) do
            if isText(node) and titleCandidate(node.Text) then
                local screen = node:FindFirstAncestorOfClass("ScreenGui")
                if screen then return screen, node end
            end
        end
    end
    -- Fallback if the header is assembled from several text objects.
    -- Require at least 4 Ovaz-specific navigation items in one ScreenGui.
    for _, root in ipairs(getRoots()) do
        for _, node in ipairs(safeDescendants(root)) do
            if node:IsA("ScreenGui") then
                local count, title = 0, nil
                for _, child in ipairs(safeDescendants(node)) do
                    if isText(child) then
                        if NAVIGATION[clean(child.Text)] then count = count + 1 end
                        if titleCandidate(child.Text) then title = child end
                    end
                end
                if count >= 4 then return node, title end
            end
        end
    end
    return nil, nil
end

local function translate(o)
    if not isText(o) or o == titleObject or o == credit then return end
    if not o:IsDescendantOf(targetGui) then return end
    local value = o.Text
    if type(value) ~= "string" or #value < 2 or #value > 260 then return end
    if value:find("<", 1, true) or value:find("แปลโดย Zuwz", 1, true) then return end
    local oldEntry = originals[o]
    if oldEntry and value == oldEntry.translated then return end

    local key = clean(value)
    local label = WORDS[key]
    if not label or label == key or NON_CONTROL_WORDS[key] then
        if oldEntry then originals[o] = nil end
        if not label and #key >= 4 and #key <= 100 and key:find("%a") and not key:find("%d") then
            missing[key] = true
        end
        return
    end

    -- Most GUI text is TextLabel; TextButton text is changed ONLY for
    -- known navigation/buttons, never for dropdown values or user input.
    if o:IsA("TextButton") and (not CONFIG.TranslateKnownButtons or not CONTROL_WORDS[key]) then
        return
    end

    local prefix, suffix = value:match("^(%s*).-(%s*)$")
    local displayed = (prefix or "") .. label .. (suffix or "")
    local success = pcall(function() o.Text = displayed end)
    if success then
        originals[o] = {original = value, translated = displayed}
        api.Translated = api.Translated + 1
    end
end

local function chooseCreditParent(title)
    -- Use the UI's header hierarchy, but avoid UIListLayout/UIGridLayout parents.
    local parent = title.Parent
    for _ = 1, 4 do
        if not parent or not parent:IsA("GuiObject") then break end
        if parent.AbsoluteSize.X > 400
            and not parent:FindFirstChildOfClass("UIListLayout")
            and not parent:FindFirstChildOfClass("UIGridLayout") then
            return parent
        end
        parent = parent.Parent
    end
    return title.Parent
end

local function measure(o)
    local width = o.TextBounds.X
    if width and width > 1 then return width end
    local ok, result = pcall(function()
        return TextService:GetTextSize(clean(o.Text), o.TextSize, o.Font, Vector2.new(2000,100))
    end)
    return (ok and result and result.X) or o.AbsoluteSize.X
end

local function updateCredit()
    local title = titleObject
    if not title or not title.Parent then return end
    if not credit or not credit.Parent then
        credit = Instance.new("TextLabel")
        credit.Name = "Zuwz_OvazTranslationCredit"
        credit.Text = "แปลโดย Zuwz"
        credit.TextColor3 = title.TextColor3
        credit.FontFace = title.FontFace
        credit.TextSize = math.clamp(math.floor(title.TextSize * .60), 10, 15)
        credit.TextXAlignment = Enum.TextXAlignment.Left
        credit.TextYAlignment = Enum.TextYAlignment.Center
        credit.TextScaled = false
        credit.TextWrapped = false
        credit.BackgroundTransparency = 1
        credit.BorderSizePixel = 0
        credit.Active = false
        credit.Selectable = false
        pcall(function() credit.Interactable = false end)
        credit.ZIndex = title.ZIndex + 1
        credit.Size = UDim2.fromOffset(112,18)
        credit.Parent = chooseCreditParent(title)
    end
    local host = credit.Parent
    if not host then return end
    local x = title.AbsolutePosition.X + measure(title) + 16
    -- The author's label can be a separate sibling in this version of Ovaz.
    for _, sibling in ipairs(safeDescendants(host)) do
        if isText(sibling) and sibling ~= title and sibling ~= credit then
            local text = clean(sibling.Text):lower()
            if text:find("@ovaz", 1, true) and math.abs(sibling.AbsolutePosition.Y - title.AbsolutePosition.Y) < 20 then
                x = math.max(x, sibling.AbsolutePosition.X + measure(sibling) + 16)
            end
        end
    end
    local y = title.AbsolutePosition.Y + (title.AbsoluteSize.Y - credit.AbsoluteSize.Y) / 2
    credit.Position = UDim2.fromOffset(
        math.floor(x - host.AbsolutePosition.X),
        math.floor(y - host.AbsolutePosition.Y)
    )
end

function api.GetUntranslated()
    local out = {}
    for key in pairs(missing) do out[#out+1] = key end
    table.sort(out)
    return out
end

function api.GetStatus()
    return {
        FoundHub = api.FoundHub,
        Translated = api.Translated,
        Scans = api.Scans,
        LoaderStarted = api.LoaderStarted,
        LoaderReturned = api.LoaderReturned,
        LoaderError = api.LoaderError,
    }
end

function api.Stop()
    api.Running = false
    for o, record in pairs(originals) do
        pcall(function()
            if o.Parent and o.Text == record.translated then o.Text = record.original end
        end)
        originals[o] = nil
    end
    if credit then pcall(function() credit:Destroy() end) end
    credit = nil
end

-- Start the watcher BEFORE launching the original script, because some
-- versions of third-party loaders never return to their caller.
task.spawn(function()
    while api.Running do
        if not targetGui or not targetGui.Parent then
            targetGui, titleObject = locateHub()
        end
        api.FoundHub = targetGui ~= nil
        if targetGui then
            for _, obj in ipairs(safeDescendants(targetGui)) do
                if not api.Running then break end
                if isText(obj) then pcall(translate, obj) end
            end
            api.Scans = api.Scans + 1
            pcall(updateCredit)
        end
        task.wait(CONFIG.PollInterval)
    end
end)

-- Original loader, run once, with the original call semantics.
-- This stays on the invoking thread, and the watcher runs independently.
api.LoaderStarted = true
loadstring(game:HttpGet(LOAD_URL))()
api.LoaderReturned = true
