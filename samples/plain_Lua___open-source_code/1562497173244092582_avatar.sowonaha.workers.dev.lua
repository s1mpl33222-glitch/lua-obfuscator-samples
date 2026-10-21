-- ═══════════════════════════════════════════════════
-- NEXUS AVATAR ENGINE v5.0.0 — "PHOENIX" UPDATE
-- ═══════════════════════════════════════════════════
-- ✅ Fixed: Memory leaks, slider mobile, volume display, chat loop
-- ✅ New: Avatar Morph Animation, Teleport to Player, ESP/Highlight All,
--         Search Presets, Dark/Light mode, Export outfit link, Anti-AFK,
--         Bodyguard clone, Mirror mode, Favorites reorder, Chat reactions
-- ✅ v5.0.1: Satisfying SFX per-button, Quick Apply PC auto-highlight nearest
-- ═══════════════════════════════════════════════════
if not game:IsLoaded() then game.Loaded:Wait() end

local env = getgenv and getgenv() or _G
if env.__NAE5__ then pcall(function() env.__NAE5__.kill() end) task.wait(0.3) end

local plrs = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local rs = game:GetService("RunService")
local mps = game:GetService("MarketplaceService")
local tp_svc = game:GetService("TeleportService")
local sg = game:GetService("StarterGui")

local lp = plrs.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
local IS_PHONE = uis.TouchEnabled and not uis.MouseEnabled
local CONNS = {}
local LOOPS = {}

local function conn(c) table.insert(CONNS, c) return c end
local function spawn_loop(name, interval, fn)
    if LOOPS[name] then LOOPS[name] = false; task.wait(interval + 0.1) end
    LOOPS[name] = true
    task.spawn(function()
        while LOOPS[name] do
            fn()
            task.wait(interval)
        end
    end)
end
local function kill_loop(name) LOOPS[name] = false end

local FIREBASE_URL = "https://nexusavatarengine-default-rtdb.asia-southeast1.firebasedatabase.app"
local OWNER_NAME = "Theerakarn_TH"
local IS_OWNER = (lp.Name == OWNER_NAME)

local SIZE_PRESETS = {
    small  = {w=280,h=370,txt=10,txt_sm=9,txt_lg=12,btn_h=30,pad=6,tab_h=24,hdr_h=36},
    medium = {w=350,h=450,txt=12,txt_sm=10,txt_lg=14,btn_h=36,pad=8,tab_h=28,hdr_h=42},
    large  = {w=440,h=540,txt=13,txt_sm=11,txt_lg=16,btn_h=42,pad=12,tab_h=34,hdr_h=48},
}

local S = {
    busy=false, orig_desc=nil, cur_id=nil, cache={}, name_cache={},
    favs={}, fav_idx={}, hist={}, hist_pos=0, max_hist=30,
    tab="home", minimized=false, hidden=false,
    theme_idx=1, ui_size=IS_PHONE and "small" or "medium",
    auto_apply=false, sfx=true, notif_on=true,
    keybind=Enum.KeyCode.RightControl,
    -- [NEW] Quick Apply PC keybind แยก
    qa_keybind=Enum.KeyCode.E,
    scale_w=1, scale_h=1, scale_head=1,
    scale_w_on=false, scale_h_on=false, scale_head_on=false,
    speed_on=false, speed_val=16, jump_on=false, jump_val=50,
    fly_on=false, noclip_on=false, inf_jump_on=false, tap_copy_on=false,
    player_orig_descs={}, preset_page=1, random_pool={},
    music_playing=false, music_idx=1, music_vol=0.5, music_loop=true, music_obj=nil,
    quick_apply_on=false, swap_mode_on=false, swap_source=nil,
    friends_list={}, friends_loaded=false, friends_page=1,
    qa_selected_player=nil, qa_last_tap_time=0, qa_last_tap_player=nil,
    outfit_items={}, outfit_removed={}, outfit_total_robux=0, outfit_emotes={},
    online_visible=true, online_users={}, online_page=1,
    chat_messages={}, chat_page=1,
    online_heartbeat_active=false,
    gui_transparency=0,
    anti_afk=true,
    esp_on=false, esp_highlights={},
    mirror_mode=false,
    bodyguard_on=false, bodyguard_npc=nil,
    tp_waypoints={}, waypoint_page=1,
    morph_anim=true,
    search_preset="",
    dark_mode=true,
    last_applied_time=0,
    total_morphs=0,
    uptime=os.time(),
}

-- ═══════════════════════════════════════
-- THEMES
-- ═══════════════════════════════════════
local THEMES = {
    {name="Twilight", pri=Color3.fromRGB(108,92,231), lit=Color3.fromRGB(142,128,255)},
    {name="Ocean",    pri=Color3.fromRGB(9,132,227),  lit=Color3.fromRGB(116,185,255)},
    {name="Sunset",   pri=Color3.fromRGB(214,48,49),  lit=Color3.fromRGB(255,118,117)},
    {name="Forest",   pri=Color3.fromRGB(0,148,50),   lit=Color3.fromRGB(85,239,196)},
    {name="Sakura",   pri=Color3.fromRGB(232,67,147), lit=Color3.fromRGB(253,121,168)},
    {name="Gold",     pri=Color3.fromRGB(225,177,44), lit=Color3.fromRGB(254,211,48)},
    {name="Mint",     pri=Color3.fromRGB(0,206,201),  lit=Color3.fromRGB(129,236,236)},
    {name="Neon",     pri=Color3.fromRGB(162,155,254),lit=Color3.fromRGB(200,194,255)},
    {name="Blood",    pri=Color3.fromRGB(180,20,20),  lit=Color3.fromRGB(255,60,60)},
    {name="Ice",      pri=Color3.fromRGB(70,160,220), lit=Color3.fromRGB(180,230,255)},
    {name="Void",     pri=Color3.fromRGB(40,0,80),    lit=Color3.fromRGB(120,60,200)},
    {name="Lime",     pri=Color3.fromRGB(80,200,0),   lit=Color3.fromRGB(160,255,80)},
}

local PALETTE_DARK = {
    bg=Color3.fromRGB(17,17,23), surface=Color3.fromRGB(24,24,33),
    card=Color3.fromRGB(32,31,42), raised=Color3.fromRGB(42,41,55),
    input_bg=Color3.fromRGB(28,27,38), outline=Color3.fromRGB(52,51,68),
    txt=Color3.fromRGB(232,230,245), txt2=Color3.fromRGB(155,152,178),
    txt3=Color3.fromRGB(95,93,118),
}
local PALETTE_LIGHT = {
    bg=Color3.fromRGB(240,240,248), surface=Color3.fromRGB(250,250,255),
    card=Color3.fromRGB(230,228,240), raised=Color3.fromRGB(210,208,225),
    input_bg=Color3.fromRGB(245,244,252), outline=Color3.fromRGB(190,188,210),
    txt=Color3.fromRGB(30,28,50), txt2=Color3.fromRGB(90,88,115),
    txt3=Color3.fromRGB(140,138,165),
}

local P = {}
local function apply_palette()
    local pal = S.dark_mode and PALETTE_DARK or PALETTE_LIGHT
    for k,v in pairs(pal) do P[k] = v end
end

local function apply_theme()
    local t = THEMES[S.theme_idx]
    P.pri = t.pri; P.pri_lit = t.lit
    P.green=Color3.fromRGB(85,239,196); P.red=Color3.fromRGB(255,107,107)
    P.orange=Color3.fromRGB(255,177,66); P.ghost=Color3.fromRGB(45,44,60)
    P.cyan=Color3.fromRGB(0,206,201); P.yellow=Color3.fromRGB(254,211,48)
    P.purple=Color3.fromRGB(162,155,254); P.blue=Color3.fromRGB(116,185,255)
    P.owner=Color3.fromRGB(255,215,0)
    apply_palette()
end

local PRESETS = {
    {id=1,n="ROBLOX"},{id=156,n="builderman"},{id=289438135,n="Bacon"},
    {id=1707711223,n="Guest"},{id=188732,n="Shedletsky"},{id=2298753899,n="Cool"},
    {id=5254879171,n="Noob"},{id=6007609888,n="Pro"},{id=124751865,n="Aesthetic"},
    {id=5019714978,n="DarkKnight"},{id=5007631110,n="Robot"},{id=9088628683,n="Ninja"},
    {id=7223875998,n="Pirate"},{id=2474943274,n="Zombie"},{id=3104949425,n="Alien"},
    {id=3335871296,n="Angel"},{id=203030608,n="Demon"},{id=2596305840,n="Samurai"},
    {id=201124389,n="Viking"},{id=1981724228,n="Wizard"},{id=3731169417,n="Astro"},
    {id=205419201,n="Cowboy"},{id=7422492329,n="Cyborg"},{id=406436524,n="Elf"},
    {id=1803380,n="Ghost"},{id=3012958642,n="Skeleton"},{id=2260118449,n="Pumpkin"},
    {id=188829949,n="Santa"},{id=660132420,n="Snowman"},{id=1125262365,n="Dragon"},
    {id=144018186,n="Phoenix"},{id=2017401176,n="Mummy"},{id=283156132,n="Clown"},
    {id=1630540916,n="Chef"},{id=344091683,n="Doctor"},{id=6538096,n="Classic"},
    {id=261,n="Sorcus"},{id=13656,n="ROBLOX Admin"},{id=4719353,n="Merely"},
    {id=79838,n="Telamon"},{id=16150,n="Coeptus"},{id=7210880,n="KreekCraft"},
    {id=175429722,n="Flamingo"},{id=18442032,n="Tofuu"},{id=38184639,n="Hyper"},
    {id=48103520,n="Bloxburg NPC"},{id=1234567890,n="TestDummy"},
}

local TRACKS = {
    {n="Chill Vibes",id="rbxassetid://9125603749"},
    {n="Montagem",id="rbxassetid://122203857226173"},
    {n="PHONK",id="rbxassetid://117759015860393"},
    {n="Anime OP",id="rbxassetid://124853612881772"},
    {n="Lo-Fi",id="rbxassetid://1838457617"},
    {n="Raining Tacos",id="rbxassetid://142376088"},
    {n="Classical",id="rbxassetid://1836283178"},
    {n="Happy Song",id="rbxassetid://1843404009"},
    {n="Megalovania",id="rbxassetid://2458488617"},
    {n="Trap Nation",id="rbxassetid://1839245717"},
    {n="Chill Hop",id="rbxassetid://6151241060"},
}

local SAVE_NAME = "__nae_v50__.json"
local SZ
local function get_sz() return SIZE_PRESETS[S.ui_size] or SIZE_PRESETS.medium end

-- ═══════════════════════════════════════
-- UTILITY
-- ═══════════════════════════════════════
local function mk(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props) do
        if k ~= "Parent" then pcall(function() o[k] = v end) end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

local function rnd(p, r)
    mk("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p})
end

local function bdr(p, c, t)
    return mk("UIStroke", {Color = c or P.outline, Thickness = t or 1, Transparency = 0.6, Parent = p})
end

local function tw(o, props, dur, st, di)
    if not o or not o.Parent then return end
    local t = ts:Create(o, TweenInfo.new(dur or 0.18, st or Enum.EasingStyle.Quart, di or Enum.EasingDirection.Out), props)
    t:Play(); return t
end

local function bounce(o, props, dur)
    return tw(o, props, dur or 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function isclick(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function resolve(txt)
    if not txt or txt == "" then return nil end
    txt = txt:match("^%s*(.-)%s*$")
    if tonumber(txt) then return tonumber(txt) end
    for _, p in ipairs(plrs:GetPlayers()) do
        if p.Name:lower() == txt:lower() or p.DisplayName:lower() == txt:lower() then
            return p.UserId
        end
    end
    local ok, id = pcall(plrs.GetUserIdFromNameAsync, plrs, txt)
    return ok and id or nil
end

local function getname(id)
    if S.name_cache[id] then return S.name_cache[id] end
    local ok, n = pcall(plrs.GetNameFromUserIdAsync, plrs, id)
    if ok then S.name_cache[id] = n; return n end
    return tostring(id)
end

local function safe_click(btn, callback)
    local pp
    btn.InputBegan:Connect(function(i) if isclick(i) then pp = i.Position end end)
    btn.InputEnded:Connect(function(i)
        if isclick(i) and pp then
            local d = (i.Position - pp).Magnitude; pp = nil
            if d < 12 then callback() end
        end
    end)
end

local function get_thumb(aid, sz)
    return "rbxthumb://type=Asset&id=" .. tostring(aid) .. "&w=" .. (sz or 150) .. "&h=" .. (sz or 150)
end

local function get_today() return os.date("!%Y-%m-%d") end

local function format_time(t)
    local d = os.time() - t
    if d < 60 then return "now"
    elseif d < 3600 then return math.floor(d/60) .. "m"
    elseif d < 86400 then return math.floor(d/3600) .. "h"
    else return math.floor(d/86400) .. "d" end
end

local function format_num(n)
    local s = tostring(n)
    local pos = #s % 3
    if pos == 0 then pos = 3 end
    local result = s:sub(1, pos)
    for i = pos + 1, #s, 3 do result = result .. "," .. s:sub(i, i + 2) end
    return result
end

local function format_uptime()
    local d = os.time() - S.uptime
    if d < 60 then return d .. "s"
    elseif d < 3600 then return math.floor(d/60) .. "m " .. (d%60) .. "s"
    else return math.floor(d/3600) .. "h " .. math.floor((d%3600)/60) .. "m" end
end

-- ═══════════════════════════════════════════════════
-- [NEW] 🔊 SATISFYING SFX SYSTEM — เสียงแตกต่างทุกปุ่ม
-- ═══════════════════════════════════════════════════
-- แต่ละ action มีเสียง ID + Volume + Pitch range ต่างกัน
-- ให้ความรู้สึก "satisfying" ทุกครั้งที่กด

local SFX_MAP = {
    -- ═══ Core Actions ═══
    apply     = {id="rbxassetid://12948391899",  vol=0.35, pitch={0.95,1.05}},  -- deep click pop
    random    = {id="rbxassetid://500839268",    vol=0.3,  pitch={0.9,1.15}},   -- dice roll
    reset     = {id="rbxassetid://9114395636",   vol=0.3,  pitch={0.85,0.95}},  -- whoosh down
    undo      = {id="rbxassetid://9113869788",   vol=0.25, pitch={0.9,1.0}},    -- soft reverse
    redo      = {id="rbxassetid://9113869788",   vol=0.25, pitch={1.05,1.15}},  -- soft forward (higher)

    -- ═══ UI Navigation ═══
    tab       = {id="rbxassetid://9065073444",   vol=0.2,  pitch={1.0,1.1}},    -- light tab switch
    toggle_on = {id="rbxassetid://9113652972",   vol=0.28, pitch={1.0,1.08}},   -- satisfying switch ON
    toggle_off= {id="rbxassetid://9113652972",   vol=0.22, pitch={0.75,0.85}},  -- switch OFF (lower)
    slider    = {id="rbxassetid://9113869788",   vol=0.12, pitch={1.2,1.5}},    -- tiny tick
    click     = {id="rbxassetid://12948391899",  vol=0.2,  pitch={1.1,1.25}},   -- general button click
    hover     = {id="rbxassetid://9113869788",   vol=0.06, pitch={1.4,1.6}},    -- very subtle hover

    -- ═══ Favorites ═══
    fav_add   = {id="rbxassetid://9114244791",   vol=0.3,  pitch={1.0,1.1}},    -- star sparkle
    fav_rem   = {id="rbxassetid://9114395636",   vol=0.2,  pitch={0.8,0.9}},    -- soft remove

    -- ═══ Social / Chat ═══
    msg_send  = {id="rbxassetid://6042053626",   vol=0.25, pitch={1.0,1.1}},    -- message whoosh
    msg_recv  = {id="rbxassetid://6042053626",   vol=0.2,  pitch={1.15,1.25}},  -- incoming ping

    -- ═══ Special Actions ═══
    copy      = {id="rbxassetid://9114244791",   vol=0.25, pitch={1.1,1.2}},    -- clipboard copy
    teleport  = {id="rbxassetid://9114244791",   vol=0.35, pitch={0.7,0.8}},    -- deep teleport
    morph     = {id="rbxassetid://12948391899",  vol=0.4,  pitch={0.8,0.9}},    -- big morph impact
    export    = {id="rbxassetid://9114244791",   vol=0.25, pitch={1.0,1.05}},   -- export sound
    error     = {id="rbxassetid://9114395636",   vol=0.3,  pitch={0.6,0.7}},    -- error buzz
    success   = {id="rbxassetid://9114244791",   vol=0.3,  pitch={1.15,1.3}},   -- success chime

    -- ═══ Music Controls ═══
    music_play  = {id="rbxassetid://9113652972", vol=0.2,  pitch={1.0,1.05}},
    music_stop  = {id="rbxassetid://9114395636", vol=0.2,  pitch={0.9,1.0}},
    music_next  = {id="rbxassetid://9065073444", vol=0.2,  pitch={1.15,1.25}},
    music_prev  = {id="rbxassetid://9065073444", vol=0.2,  pitch={0.85,0.95}},

    -- ═══ Quick Apply ═══
    qa_lock   = {id="rbxassetid://9114244791",   vol=0.3,  pitch={1.2,1.3}},    -- target locked
    qa_apply  = {id="rbxassetid://12948391899",  vol=0.45, pitch={0.85,0.95}},  -- apply confirm
    qa_switch = {id="rbxassetid://9113869788",   vol=0.15, pitch={1.3,1.5}},    -- target switch

    -- ═══ Preview / View ═══
    preview   = {id="rbxassetid://9065073444",   vol=0.2,  pitch={1.05,1.15}},
    close     = {id="rbxassetid://9113869788",   vol=0.18, pitch={0.7,0.8}},    -- close/dismiss

    -- ═══ Minimize / Toggle UI ═══
    minimize  = {id="rbxassetid://9113869788",   vol=0.2,  pitch={0.8,0.9}},
    maximize  = {id="rbxassetid://9113869788",   vol=0.2,  pitch={1.1,1.2}},
    hide_ui   = {id="rbxassetid://9113652972",   vol=0.15, pitch={0.7,0.8}},
}

-- ★ Master SFX function — เล่นเสียงตาม action type
local function sfx(action_or_id, vol_override)
    if not S.sfx then return end
    local cfg = SFX_MAP[action_or_id]
    local sound_id, vol, pitch_min, pitch_max

    if cfg then
        -- ใช้จาก SFX_MAP
        sound_id = cfg.id
        vol = vol_override or cfg.vol or 0.25
        pitch_min = cfg.pitch and cfg.pitch[1] or 1
        pitch_max = cfg.pitch and cfg.pitch[2] or 1
    else
        -- Fallback: ถ้าส่ง rbxassetid มาตรง
        sound_id = action_or_id
        vol = vol_override or 0.25
        pitch_min, pitch_max = 0.95, 1.05
    end

    local s = Instance.new("Sound")
    s.SoundId = sound_id
    s.Volume = vol
    -- Random pitch เล็กน้อยเพื่อความ organic
    s.PlaybackSpeed = pitch_min + math.random() * (pitch_max - pitch_min)
    s.Parent = pgui
    s:Play()
    s.Ended:Once(function() s:Destroy() end)
end

-- [LEGACY] เข้ากันได้กับ SFX_IDS เดิม
local SFX_IDS = {
    click  = "rbxassetid://12948391899",
    toggle = "rbxassetid://124972635680154",
    dice   = "rbxassetid://500839268",
    tab    = "rbxassetid://9065073444",
    msg    = "rbxassetid://6042053626",
}

-- ═══════════════════════════════════════
-- FIREBASE
-- ═══════════════════════════════════════
local FB = {}

function FB.request(method, path, data)
    local req_fn = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
    if not req_fn then return false, nil end
    local url = FIREBASE_URL .. path .. ".json"
    local body = data and http:JSONEncode(data) or nil
    local ok, res = pcall(req_fn, {
        Url = url, Method = method,
        Headers = {["Content-Type"] = "application/json"},
        Body = body
    })
    if ok and res and res.StatusCode and res.StatusCode >= 200 and res.StatusCode < 300 then
        local decoded
        if res.Body and res.Body ~= "" and res.Body ~= "null" then
            pcall(function() decoded = http:JSONDecode(res.Body) end)
        end
        return true, decoded
    end
    return false, nil
end

function FB.get(path) return FB.request("GET", path) end
function FB.put(path, data) return FB.request("PUT", path, data) end
function FB.post(path, data) return FB.request("POST", path, data) end
function FB.patch(path, data) return FB.request("PATCH", path, data) end
function FB.delete(path) return FB.request("DELETE", path) end

-- ═══════════════════════════════════════
-- BAN / TIMEOUT SYSTEM
-- ═══════════════════════════════════════
local BAN = {}

function BAN.check_self()
    local ok, data = FB.get("/nexus_bans/" .. tostring(lp.UserId))
    if not ok or not data then return false end
    if data.permanent then return true, "You are banned from Nexus Online." end
    if data.timeout_until and os.time() < data.timeout_until then
        local left = data.timeout_until - os.time()
        local mins = math.ceil(left / 60)
        return true, "Timeout: " .. mins .. " min left"
    end
    if data.timeout_until and os.time() >= data.timeout_until then
        FB.delete("/nexus_bans/" .. tostring(lp.UserId))
        return false
    end
    return false
end

function BAN.ban_user(uid, name)
    if not IS_OWNER then return end
    FB.put("/nexus_bans/" .. tostring(uid), {
        permanent = true, name = name,
        banned_by = lp.Name, timestamp = os.time()
    })
    FB.delete("/nexus_online/" .. tostring(uid))
end

function BAN.unban_user(uid)
    if not IS_OWNER then return end
    FB.delete("/nexus_bans/" .. tostring(uid))
end

function BAN.timeout_user(uid, name, minutes)
    if not IS_OWNER then return end
    FB.put("/nexus_bans/" .. tostring(uid), {
        permanent = false, name = name,
        timeout_until = os.time() + (minutes * 60),
        banned_by = lp.Name, timestamp = os.time()
    })
end

-- ═══════════════════════════════════════
-- ONLINE SYSTEM
-- ═══════════════════════════════════════
local ON = {}
ON.refresh_fn = nil

function ON.go_online()
    if not S.online_visible then return end
    local banned = BAN.check_self()
    if banned then S.online_visible = false; return end
    local data = {
        name = lp.Name, displayName = lp.DisplayName,
        userId = lp.UserId, timestamp = os.time(),
        gameId = game.PlaceId, gameName = "", visible = true,
        avatar = S.cur_id or lp.UserId,
        version = "5.0.1",
    }
    pcall(function() data.gameName = mps:GetProductInfo(game.PlaceId).Name or "" end)
    FB.put("/nexus_online/" .. tostring(lp.UserId), data)
end

function ON.go_offline()
    FB.delete("/nexus_online/" .. tostring(lp.UserId))
end

function ON.set_visible(vis)
    S.online_visible = vis
    if vis then ON.go_online() else ON.go_offline() end
    save()
end

function ON.start_heartbeat()
    if S.online_heartbeat_active then return end
    S.online_heartbeat_active = true
    ON.go_online()
    spawn_loop("online_heartbeat", 30, function()
        if S.online_visible then
            FB.patch("/nexus_online/" .. tostring(lp.UserId), {timestamp = os.time()})
        end
    end)
end

function ON.stop_heartbeat()
    S.online_heartbeat_active = false
    kill_loop("online_heartbeat")
    kill_loop("chat_auto_refresh")
    kill_loop("online_auto_refresh")
    ON.go_offline()
end

function ON.fetch_users()
    local ok, data = FB.get("/nexus_online")
    if not ok or not data then S.online_users = {}; return end
    local users, now = {}, os.time()
    for uid, info in pairs(data) do
        if type(info) == "table" and info.timestamp then
            local age = now - info.timestamp
            if age < 120 and info.visible ~= false then
                table.insert(users, {
                    userId = info.userId or tonumber(uid) or 0,
                    name = info.name or "???", displayName = info.displayName or info.name or "???",
                    timestamp = info.timestamp, gameId = info.gameId or 0,
                    gameName = info.gameName or "", avatar = info.avatar or info.userId or 0, age = age,
                    version = info.version or "?",
                })
            elseif age >= 120 then
                task.spawn(function() FB.delete("/nexus_online/" .. uid) end)
            end
        end
    end
    table.sort(users, function(a, b) return a.timestamp > b.timestamp end)
    S.online_users = users
end

-- ═══════════════════════════════════════
-- CHAT SYSTEM
-- ═══════════════════════════════════════
local CH = {}
CH.refresh_fn = nil
CH.last_count = 0

local REACTIONS = {"👍", "❤️", "😂", "🔥", "💀"}

function CH.send(message)
    if not message or message == "" then return false end
    message = message:sub(1, 200)
    local banned, reason = BAN.check_self()
    if banned then NF.push(reason or "Banned", "err", 3); return false end
    local data = {
        sender = lp.DisplayName, senderName = lp.Name,
        senderId = lp.UserId, message = message, timestamp = os.time(),
    }
    local ok = FB.post("/nexus_chat/" .. get_today(), data)
    return ok
end

function CH.fetch()
    local ok, data = FB.get("/nexus_chat/" .. get_today())
    if not ok or not data then S.chat_messages = {}; return end
    local msgs = {}
    for mid, info in pairs(data) do
        if type(info) == "table" then
            table.insert(msgs, {
                id = mid, sender = info.sender or "???",
                senderName = info.senderName or "",
                senderId = info.senderId or 0,
                message = info.message or "", timestamp = info.timestamp or 0,
            })
        end
    end
    table.sort(msgs, function(a, b) return a.timestamp < b.timestamp end)
    S.chat_messages = msgs
    if #msgs > CH.last_count and CH.last_count > 0 then
        local latest = msgs[#msgs]
        if latest.senderId ~= lp.UserId then
            NF.push(latest.sender .. ": " .. latest.message:sub(1, 35), "chat", 3)
        end
    end
    CH.last_count = #msgs
end

function CH.delete_msg(msg_id)
    if not IS_OWNER then return end
    FB.delete("/nexus_chat/" .. get_today() .. "/" .. msg_id)
end

function CH.clear_all()
    if not IS_OWNER then return end
    FB.delete("/nexus_chat/" .. get_today())
    S.chat_messages = {}
end

-- ═══════════════════════════════════════
-- SAVE / LOAD
-- ═══════════════════════════════════════
local function save()
    if not writefile then return end
    pcall(function()
        writefile(SAVE_NAME, http:JSONEncode({
            favs=S.favs, cur=S.cur_id, theme=S.theme_idx,
            ui_size=S.ui_size, auto=S.auto_apply, sfx=S.sfx,
            notif=S.notif_on, kb=S.keybind.Name,
            qa_kb=S.qa_keybind.Name, -- [NEW]
            sw=S.scale_w, sh=S.scale_h, shd=S.scale_head,
            sw_on=S.scale_w_on, sh_on=S.scale_h_on, shd_on=S.scale_head_on,
            speed_on=S.speed_on, speed_val=S.speed_val,
            jump_on=S.jump_on, jump_val=S.jump_val,
            music_idx=S.music_idx, music_vol=S.music_vol, music_loop=S.music_loop,
            tap_copy=S.tap_copy_on, quick_apply=S.quick_apply_on,
            swap_mode=S.swap_mode_on, online_visible=S.online_visible,
            gui_trans=S.gui_transparency,
            dark_mode=S.dark_mode, anti_afk=S.anti_afk,
            morph_anim=S.morph_anim, total_morphs=S.total_morphs,
            tp_waypoints=S.tp_waypoints,
        }))
    end)
end

local function load_save()
    if not readfile then return end
    pcall(function()
        local raw = readfile(SAVE_NAME)
        if not raw or raw == "" then return end
        local d = http:JSONDecode(raw)
        S.favs = d.favs or {}; S.cur_id = d.cur; S.theme_idx = d.theme or 1
        S.ui_size = d.ui_size or (IS_PHONE and "small" or "medium")
        S.auto_apply = d.auto or false; S.sfx = d.sfx ~= false; S.notif_on = d.notif ~= false
        if d.kb then pcall(function() S.keybind = Enum.KeyCode[d.kb] end) end
        if d.qa_kb then pcall(function() S.qa_keybind = Enum.KeyCode[d.qa_kb] end) end -- [NEW]
        S.scale_w = d.sw or 1; S.scale_h = d.sh or 1; S.scale_head = d.shd or 1
        S.scale_w_on = d.sw_on or false; S.scale_h_on = d.sh_on or false; S.scale_head_on = d.shd_on or false
        S.speed_on = d.speed_on or false; S.speed_val = d.speed_val or 16
        S.jump_on = d.jump_on or false; S.jump_val = d.jump_val or 50
        S.music_idx = d.music_idx or 1; S.music_vol = d.music_vol or 0.5; S.music_loop = d.music_loop ~= false
        S.tap_copy_on = d.tap_copy or false; S.quick_apply_on = d.quick_apply or false
        S.swap_mode_on = d.swap_mode or false; S.online_visible = d.online_visible ~= false
        S.gui_transparency = d.gui_trans or 0
        S.dark_mode = d.dark_mode ~= false
        S.anti_afk = d.anti_afk ~= false
        S.morph_anim = d.morph_anim ~= false
        S.total_morphs = d.total_morphs or 0
        S.tp_waypoints = d.tp_waypoints or {}
        for _, f in ipairs(S.favs) do S.fav_idx[f.id] = true end
    end)
    if #S.favs == 0 and readfile then
        pcall(function()
            local old = readfile("__nae_v48__.json")
            if old and old ~= "" then
                local d = http:JSONDecode(old)
                if d.favs and #d.favs > 0 then
                    S.favs = d.favs
                    for _, f in ipairs(S.favs) do S.fav_idx[f.id] = true end
                    S.cur_id = d.cur; S.theme_idx = d.theme or 1
                end
            end
        end)
    end
end

-- ═══════════════════════════════════════
-- NOTIFICATION
-- ═══════════════════════════════════════
local NF = {active = {}, parent = nil}

function NF.push(msg, kind, dur)
    if not S.notif_on or not NF.parent then return end
    dur = dur or 3.5; SZ = get_sz()
    local clr, ico = P.pri, "i"
    if kind == "ok" then clr, ico = P.green, "✓"
    elseif kind == "err" then clr, ico = P.red, "✗"
    elseif kind == "warn" then clr, ico = P.orange, "!"
    elseif kind == "swap" then clr, ico = P.cyan, "⇄"
    elseif kind == "quick" then clr, ico = P.yellow, "⚡"
    elseif kind == "emote" then clr, ico = P.purple, "♪"
    elseif kind == "chat" then clr, ico = P.blue, "💬"
    elseif kind == "owner" then clr, ico = P.owner, "★"
    elseif kind == "tp" then clr, ico = P.cyan, "→"
    elseif kind == "esp" then clr, ico = P.green, "◉"
    elseif kind == "stat" then clr, ico = P.purple, "📊"
    elseif kind == "qa" then clr, ico = P.yellow, "🎯" end -- [NEW]

    while #NF.active >= 5 do
        local oldest = table.remove(NF.active, 1)
        pcall(function() oldest:Destroy() end)
    end

    local nw = math.min(SZ.w - 20, 280)
    local wrap = mk("Frame", {Size = UDim2.new(0, nw, 0, 0), Position = UDim2.new(1, -(nw+10), 1, -8 - (#NF.active * 52)), AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = P.surface, BackgroundTransparency = 0.05, ClipsDescendants = true, Parent = NF.parent})
    rnd(wrap, 10); bdr(wrap, clr, 1)
    mk("Frame", {Size = UDim2.new(0, 3, 1, -8), Position = UDim2.new(0, 6, 0, 4), BackgroundColor3 = clr, BorderSizePixel = 0, Parent = wrap})
    local ib = mk("Frame", {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 14, 0.5, -9), BackgroundColor3 = clr, BackgroundTransparency = 0.8, Parent = wrap}); rnd(ib, 9)
    mk("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ico, TextColor3 = clr, Font = Enum.Font.GothamBold, TextSize = 9, Parent = ib})
    mk("TextLabel", {Size = UDim2.new(1, -42, 1, 0), Position = UDim2.new(0, 38, 0, 0), BackgroundTransparency = 1, Text = msg, TextColor3 = P.txt, Font = Enum.Font.GothamMedium, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd, Parent = wrap})
    local pbar = mk("Frame", {Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = clr, BorderSizePixel = 0, Parent = wrap}); rnd(pbar, 1)
    table.insert(NF.active, wrap)
    bounce(wrap, {Size = UDim2.new(0, nw, 0, 44)}, 0.3)
    tw(pbar, {Size = UDim2.new(0, 0, 0, 2)}, dur)
    task.delay(dur, function()
        tw(wrap, {BackgroundTransparency = 1, Size = UDim2.new(0, nw, 0, 0)}, 0.2)
        task.delay(0.25, function()
            for i, n in ipairs(NF.active) do if n == wrap then table.remove(NF.active, i); break end end
            pcall(function() wrap:Destroy() end)
            for i, n in ipairs(NF.active) do tw(n, {Position = UDim2.new(1, -(nw+10), 1, -8 - ((i-1)*52))}, 0.15) end
        end)
    end)
end

-- ═══════════════════════════════════════
-- FAVORITES
-- ═══════════════════════════════════════
local FAV = {}
function FAV.has(id) return S.fav_idx[id] == true end
function FAV.add(id) if FAV.has(id) then return end; local nm = getname(id); table.insert(S.favs, {id=id, name=nm}); S.fav_idx[id] = true; save(); sfx("fav_add"); NF.push("★ Added " .. nm, "ok", 2) end
function FAV.rem(id) for i, f in ipairs(S.favs) do if f.id == id then table.remove(S.favs, i); S.fav_idx[id] = nil; save(); sfx("fav_rem"); NF.push("Removed", "info", 2); return end end end
function FAV.toggle(id) if FAV.has(id) then FAV.rem(id) else FAV.add(id) end end
function FAV.move_up(id) for i, f in ipairs(S.favs) do if f.id == id and i > 1 then S.favs[i], S.favs[i-1] = S.favs[i-1], S.favs[i]; save(); return true end end; return false end
function FAV.move_down(id) for i, f in ipairs(S.favs) do if f.id == id and i < #S.favs then S.favs[i], S.favs[i+1] = S.favs[i+1], S.favs[i]; save(); return true end end; return false end

-- ═══════════════════════════════════════
-- AVATAR CORE
-- ═══════════════════════════════════════
local AV = {}

function AV.get_desc(uid, fresh)
    if not fresh and S.cache[uid] then return S.cache[uid] end
    local ok, d = pcall(plrs.GetHumanoidDescriptionFromUserId, plrs, uid)
    if ok and d then S.cache[uid] = d; return d end; return nil
end

function AV.strip(char)
    local tools, bp = {}, lp:FindFirstChild("Backpack")
    for _, c in ipairs(char:GetChildren()) do if c:IsA("Tool") then table.insert(tools, c); c.Parent = nil end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(tools, t) end end end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") or c:IsA("Hat") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic") or c:IsA("BodyColors") or c:IsA("CharacterMesh") then c:Destroy() end
    end
    for _, t in ipairs(tools) do if t and not t.Parent then t.Parent = bp or char end end
end

function AV.apply_scales(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local ok2, d = pcall(function() return hum:GetAppliedDescription() end); if not ok2 or not d then return end
    local changed = false
    if S.scale_w_on then d.WidthScale = S.scale_w; changed = true end
    if S.scale_h_on then d.HeightScale = S.scale_h; changed = true end
    if S.scale_head_on then d.HeadScale = S.scale_head; changed = true end
    if changed then pcall(function() if hum.ApplyDescriptionClientServer then hum:ApplyDescriptionClientServer(d) else hum:ApplyDescription(d) end end) end
end

function AV.full_apply(hum, desc)
    pcall(function() if hum.ApplyDescriptionClientServer then hum:ApplyDescriptionClientServer(desc) else hum:ApplyDescription(desc) end end)
    local char = hum.Parent; if not char then return end
    task.delay(0.15, function()
        if not char.Parent then return end
        local bc = char:FindFirstChildOfClass("BodyColors")
        if not bc then bc = Instance.new("BodyColors"); bc.Parent = char end
        pcall(function()
            bc.HeadColor3 = desc.HeadColor; bc.TorsoColor3 = desc.TorsoColor
            bc.LeftArmColor3 = desc.LeftArmColor; bc.RightArmColor3 = desc.RightArmColor
            bc.LeftLegColor3 = desc.LeftLegColor; bc.RightLegColor3 = desc.RightLegColor
        end)
    end)
end

function AV.morph_effect(char)
    if not S.morph_anim or not char then return end
    sfx("morph") -- [NEW] morph sound
    pcall(function()
        local hl = mk("Highlight", {
            Adornee = char, FillColor = P.pri, FillTransparency = 0,
            OutlineColor = P.pri_lit, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
            Parent = char
        })
        task.spawn(function()
            for i = 0, 10 do
                hl.FillTransparency = i / 10
                task.wait(0.03)
            end
            hl:Destroy()
        end)
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local at = mk("Attachment", {Parent = root})
            local pe = mk("ParticleEmitter", {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Color = ColorSequence.new(P.pri, P.pri_lit),
                Size = NumberSequence.new(0.3, 0),
                Lifetime = NumberRange.new(0.3, 0.6),
                Speed = NumberRange.new(3, 6),
                Rate = 80,
                SpreadAngle = Vector2.new(360, 360),
                Parent = at
            })
            task.delay(0.4, function()
                pe.Enabled = false
                task.delay(1, function() at:Destroy() end)
            end)
        end
    end)
end

function AV.apply(target, skip_hist)
    if S.busy then return end; S.busy = true
    task.spawn(function()
        local id = resolve(tostring(target))
        if not id then S.busy = false; sfx("error"); NF.push("User not found", "err"); return end
        if S.cur_id == id and not skip_hist then S.busy = false; NF.push("Already applied", "warn", 2); return end
        local char = lp.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or not char:FindFirstChild("HumanoidRootPart") then S.busy = false; sfx("error"); NF.push("Character not ready", "err"); return end
        NF.push("Loading avatar...", "info", 2)
        if not S.orig_desc then pcall(function() S.orig_desc = hum:GetAppliedDescription() end) end
        local desc = AV.get_desc(id, true)
        if not desc then S.busy = false; sfx("error"); NF.push("Failed to load avatar", "err"); return end
        if not skip_hist and S.cur_id then
            while #S.hist > S.hist_pos do table.remove(S.hist) end
            table.insert(S.hist, S.cur_id); S.hist_pos = #S.hist
            if #S.hist > S.max_hist then table.remove(S.hist, 1); S.hist_pos = #S.hist end
        end
        AV.morph_effect(char)
        AV.strip(char); AV.full_apply(hum, desc)
        S.cur_id = id; S.busy = false; S.total_morphs = S.total_morphs + 1; S.last_applied_time = os.time()
        AV.apply_scales(char); save()
        sfx("success") -- [NEW]
        NF.push("Morphed → " .. getname(id) .. " (#" .. S.total_morphs .. ")", "ok")
        if S.online_visible then task.spawn(function() FB.patch("/nexus_online/" .. tostring(lp.UserId), {avatar = id}) end) end
        if AV.on_change then AV.on_change(id) end
    end)
end

function AV.reset()
    if S.busy or not S.orig_desc then NF.push("Nothing to reset", "warn", 2); return end
    if not S.cur_id then NF.push("Already original", "warn", 2); return end
    S.busy = true
    task.spawn(function()
        local char = lp.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then S.busy = false; return end
        AV.morph_effect(char)
        AV.strip(char); AV.full_apply(hum, S.orig_desc); S.cur_id = nil; S.busy = false; save()
        sfx("reset"); NF.push("Restored original avatar!", "ok")
        if AV.on_change then AV.on_change(nil) end
    end)
end

function AV.undo() if S.hist_pos < 1 or #S.hist == 0 then NF.push("Nothing to undo", "warn", 2); return end; sfx("undo"); AV.apply(S.hist[S.hist_pos], true); S.hist_pos = math.max(0, S.hist_pos - 1) end
function AV.redo() if S.hist_pos >= #S.hist then NF.push("Nothing to redo", "warn", 2); return end; sfx("redo"); S.hist_pos = S.hist_pos + 1; AV.apply(S.hist[S.hist_pos], true) end

function AV.random()
    if S.busy then return end; sfx("random")
    if #S.random_pool == 0 then for _, p in ipairs(PRESETS) do table.insert(S.random_pool, p.id) end end
    local idx = math.random(#S.random_pool); local pick = S.random_pool[idx]
    table.remove(S.random_pool, idx); AV.apply(pick); return pick
end

function AV.apply_to_other(tp, aid)
    local id = resolve(tostring(aid)); if not id then NF.push("Invalid ID", "err"); return false end
    local char = tp.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then NF.push("No character", "err"); return false end
    local desc = AV.get_desc(id, true); if not desc then NF.push("Failed", "err"); return false end
    if not S.player_orig_descs[tp.UserId] then pcall(function() S.player_orig_descs[tp.UserId] = hum:GetAppliedDescription() end) end
    AV.strip(char); AV.full_apply(hum, desc); return true
end

function AV.apply_to_all(aid) local c = 0; for _, p in ipairs(plrs:GetPlayers()) do if p ~= lp and AV.apply_to_other(p, aid) then c = c + 1 end end; NF.push("Applied to " .. c .. " players!", "ok") end

function AV.reset_other(tp)
    local orig = S.player_orig_descs[tp.UserId]; if not orig then NF.push("Never applied", "warn"); return end
    local char = tp.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); if not char or not hum then return end
    AV.strip(char); AV.full_apply(hum, orig); S.player_orig_descs[tp.UserId] = nil; NF.push("Reset " .. tp.Name, "ok")
end

function AV.copy_player_avatar(pn)
    if S.busy then return end
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp and (p.Name:lower():find(pn:lower(), 1, true) or p.DisplayName:lower():find(pn:lower(), 1, true)) then AV.apply(p.UserId); return end
    end; NF.push("Player not found", "err")
end

-- ═══════════════════════════════════════
-- OUTFIT + EMOTES
-- ═══════════════════════════════════════
local OUTFIT = {}
OUTFIT.price_cache = {}; OUTFIT.render_fn = nil; OUTFIT.render_emotes_fn = nil

function OUTFIT.get_price(aid)
    if OUTFIT.price_cache[aid] then return OUTFIT.price_cache[aid] end
    local ok, info = pcall(function() return mps:GetProductInfo(aid, Enum.InfoType.Asset) end)
    if ok and info then OUTFIT.price_cache[aid] = {price = info.PriceInRobux or 0, name = info.Name or "Unknown", type = info.AssetTypeId or 0}
    else OUTFIT.price_cache[aid] = {price = 0, name = "ID:" .. aid, type = 0} end
    return OUTFIT.price_cache[aid]
end

local ATYPE = {[2]="T-Shirt",[8]="Hat",[11]="Shirt",[12]="Pants",[17]="Head",[18]="Face",[27]="Torso",[28]="R.Arm",[29]="L.Arm",[30]="L.Leg",[31]="R.Leg",[41]="Hair",[42]="Face Acc",[43]="Neck",[44]="Shoulder",[45]="Front",[46]="Back",[47]="Waist"}
local ANIM_FIELDS = {"IdleAnimation","WalkAnimation","RunAnimation","JumpAnimation","ClimbAnimation","FallAnimation","SwimAnimation"}

function OUTFIT.scan_emotes()
    S.outfit_emotes = {}
    local char = lp.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local ok, desc = pcall(function() return hum:GetAppliedDescription() end); if not ok or not desc then return end
    pcall(function()
        local eq = desc:GetEquippedEmotes()
        if eq then for _, e in ipairs(eq) do
            local eid = 0
            pcall(function() local t = desc:GetEmotes(); if t and t[e.Name] then for _, id in ipairs(t[e.Name]) do eid = id; break end end end)
            table.insert(S.outfit_emotes, {name = e.Name or "Emote", slot = e.Slot or 0, assetId = eid, category = "Emote", emote_type = "equipped"})
        end end
    end)
    pcall(function()
        local t = desc:GetEmotes(); if t then
            local seen = {}; for _, em in ipairs(S.outfit_emotes) do if em.assetId > 0 then seen[em.assetId] = true end end
            for name, ids in pairs(t) do for _, id in ipairs(ids) do if not seen[id] then seen[id] = true; table.insert(S.outfit_emotes, {name = name, slot = 0, assetId = id, category = "Emote", emote_type = "available"}) end end end
        end
    end)
    for _, field in ipairs(ANIM_FIELDS) do
        pcall(function() local v = desc[field]; if v and v > 0 then
            local exists = false; for _, em in ipairs(S.outfit_emotes) do if em.assetId == v then exists = true; break end end
            if not exists then table.insert(S.outfit_emotes, {name = field:gsub("Animation", ""), slot = 0, assetId = v, category = "Animation", emote_type = "anim"}) end
        end end)
    end
end

function OUTFIT.play_emote(name)
    local char = lp.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    for _, em in ipairs(S.outfit_emotes) do
        if em.name == name and em.assetId > 0 then
            pcall(function()
                local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://" .. em.assetId
                local animator = hum:FindFirstChildOfClass("Animator"); if not animator then animator = Instance.new("Animator"); animator.Parent = hum end
                for _, t in ipairs(animator:GetPlayingAnimationTracks()) do if t.Priority == Enum.AnimationPriority.Action then t:Stop() end end
                local track = animator:LoadAnimation(anim); track.Priority = Enum.AnimationPriority.Action; track:Play()
                NF.push("♪ Playing: " .. name, "emote", 2); track.Stopped:Once(function() anim:Destroy() end)
            end); return
        end
    end
end

function OUTFIT.stop_emotes()
    local char = lp.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then for _, t in ipairs(animator:GetPlayingAnimationTracks()) do if t.Priority == Enum.AnimationPriority.Action then t:Stop() end end end
    NF.push("Stopped all", "ok", 1.5)
end

function OUTFIT.scan()
    S.outfit_items = {}; S.outfit_total_robux = 0
    local char = lp.Character; if not char then NF.push("No character found", "warn"); return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then NF.push("No humanoid", "warn"); return end
    local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
    if not ok or not desc then NF.push("Apply an avatar first!", "warn", 3); return end
    local items, seen = {}, {}
    pcall(function() for _, a in ipairs(desc:GetAccessories(true)) do if a.AssetId and a.AssetId > 0 and not seen[a.AssetId] then seen[a.AssetId] = true; table.insert(items, {assetId = a.AssetId, category = "Accessory"}) end end end)
    if #items == 0 then pcall(function() for _, a in ipairs(desc:GetAccessories(false)) do if a.AssetId and a.AssetId > 0 and not seen[a.AssetId] then seen[a.AssetId] = true; table.insert(items, {assetId = a.AssetId, category = "Accessory"}) end end end) end
    for _, fld in ipairs({{"Shirt","Shirt"},{"Pants","Pants"},{"GraphicTShirt","T-Shirt"},{"Head","Head"},{"Face","Face"},{"Torso","Torso"},{"RightArm","R.Arm"},{"LeftArm","L.Arm"},{"RightLeg","R.Leg"},{"LeftLeg","L.Leg"}}) do
        pcall(function() local v = desc[fld[1]]; if v and v > 0 and not seen[v] then seen[v] = true; table.insert(items, {assetId = v, category = fld[2]}) end end)
    end
    for _, it in ipairs(items) do
        local info = OUTFIT.get_price(it.assetId); local rm = S.outfit_removed[it.assetId] or false
        table.insert(S.outfit_items, {assetId = it.assetId, category = it.category, name = info.name, price = info.price, asset_type = info.type, removed = rm})
        if not rm then S.outfit_total_robux = S.outfit_total_robux + (info.price or 0) end
    end
    OUTFIT.scan_emotes()
    NF.push(#S.outfit_items .. " items + " .. #S.outfit_emotes .. " emotes scanned", "ok", 2)
end

function OUTFIT.remove_item(item)
    local char = lp.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return false end
    pcall(function()
        local desc = hum:GetAppliedDescription()
        if item.category == "Accessory" then
            local ok2, accs = pcall(function() return desc:GetAccessories(true) end)
            if ok2 and accs then local na = {}; for _, a in ipairs(accs) do if a.AssetId ~= item.assetId then table.insert(na, a) end end; desc:SetAccessories(na, true) end
        else
            local map = {Shirt="Shirt",Pants="Pants",["T-Shirt"]="GraphicTShirt",Head="Head",Face="Face",Torso="Torso",["R.Arm"]="RightArm",["L.Arm"]="LeftArm",["R.Leg"]="RightLeg",["L.Leg"]="LeftLeg"}
            if map[item.category] then desc[map[item.category]] = 0 end
        end
        if hum.ApplyDescriptionClientServer then hum:ApplyDescriptionClientServer(desc) else hum:ApplyDescription(desc) end
    end)
    S.outfit_removed[item.assetId] = true; NF.push("Removed: " .. item.name, "ok", 2); return true
end

function OUTFIT.equip_item(item)
    local char = lp.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return false end
    pcall(function()
        local desc = hum:GetAppliedDescription()
        if item.category == "Accessory" then
            local ok2, accs = pcall(function() return desc:GetAccessories(true) end)
            if ok2 and accs then local has = false; for _, a in ipairs(accs) do if a.AssetId == item.assetId then has = true; break end end
                if not has then table.insert(accs, {AssetId = item.assetId, AccessoryType = Enum.AccessoryType.Unknown, IsLayered = false, Order = #accs + 1}); desc:SetAccessories(accs, true) end end
        else
            local map = {Shirt="Shirt",Pants="Pants",["T-Shirt"]="GraphicTShirt",Head="Head",Face="Face",Torso="Torso",["R.Arm"]="RightArm",["L.Arm"]="LeftArm",["R.Leg"]="RightLeg",["L.Leg"]="LeftLeg"}
            if map[item.category] then desc[map[item.category]] = item.assetId end
        end
        if hum.ApplyDescriptionClientServer then hum:ApplyDescriptionClientServer(desc) else hum:ApplyDescription(desc) end
    end)
    S.outfit_removed[item.assetId] = nil; NF.push("Equipped: " .. item.name, "ok", 2); return true
end

function OUTFIT.export()
    if #S.outfit_items == 0 then NF.push("Scan outfit first!", "warn"); return "" end
    local ids = {}
    for _, it in ipairs(S.outfit_items) do if not it.removed then table.insert(ids, tostring(it.assetId)) end end
    local result = "NEXUS_OUTFIT:" .. table.concat(ids, ",")
    if setclipboard then setclipboard(result); sfx("export"); NF.push("Outfit copied to clipboard!", "ok", 3) end
    return result
end

-- ═══════════════════════════════════════
-- NAME SPOOF / FRIENDS
-- ═══════════════════════════════════════
local NS = {}
function NS.set(char, name) if not char then return end; local hum = char:FindFirstChildOfClass("Humanoid"); if hum then pcall(function() hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject; hum.DisplayName = name end) end end
function NS.clear(char) if not char then return end; local hum = char:FindFirstChildOfClass("Humanoid"); if hum then pcall(function() hum.DisplayName = lp.DisplayName end) end end

local FR = {}; FR.on_loaded = nil
function FR.load()
    if S.friends_loaded then return end; NF.push("Loading friends...", "info", 2)
    task.spawn(function()
        local ok, pages = pcall(plrs.GetFriendsAsync, plrs, lp.UserId); if not ok or not pages then NF.push("Failed to load friends", "err"); return end
        S.friends_list = {}
        pcall(function() while true do for _, item in ipairs(pages:GetCurrentPage()) do table.insert(S.friends_list, {id = item.Id, name = item.Username or "", display = item.DisplayName or item.Username or "", online = item.IsOnline or false}); S.name_cache[item.Id] = item.Username end; if pages.IsFinished then break end; pages:AdvanceToNextPageAsync() end end)
        S.friends_loaded = true
        table.sort(S.friends_list, function(a, b) if a.online ~= b.online then return a.online end; return a.name:lower() < b.name:lower() end)
        NF.push(#S.friends_list .. " friends loaded!", "ok", 2); if FR.on_loaded then FR.on_loaded() end
    end)
end

local function smart_find_player()
    local cam = workspace.CurrentCamera; local mp = uis:GetMouseLocation(); local ray = cam:ViewportPointToRay(mp.X, mp.Y)
    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Exclude
    local mc = lp.Character; if mc then params.FilterDescendantsInstances = {mc} end
    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if result and result.Instance then
        local model = result.Instance
        while model and not model:FindFirstChildOfClass("Humanoid") do model = model.Parent; if model == workspace then model = nil; break end end
        if model then for _, p in ipairs(plrs:GetPlayers()) do if p.Character == model and p ~= lp then return p end end end
    end
    local best, bdist = nil, 15
    for _, p in ipairs(plrs:GetPlayers()) do if p ~= lp and p.Character then local root = p.Character:FindFirstChild("HumanoidRootPart")
        if root then local tc = root.Position - ray.Origin; local proj = tc:Dot(ray.Direction); if proj > 0 then local d = (root.Position - (ray.Origin + ray.Direction * proj)).Magnitude; if d < bdist then bdist = d; best = p end end end end end
    return best
end

-- ═══════════════════════════════════════
-- INTERACTION MODES
-- ═══════════════════════════════════════
local CONFLICT = {}; CONFLICT.disable_fns = {}
function CONFLICT.activate(fk)
    for _, key in ipairs({"quick_apply_on","swap_mode_on","tap_copy_on"}) do
        if key ~= fk and S[key] then S[key] = false; if CONFLICT.disable_fns[key] then CONFLICT.disable_fns[key]() end end
    end; S[fk] = true; save()
end

-- ═══════════════════════════════════════════════════════════════════
-- [NEW] 🎯 QUICK APPLY PC — Auto Highlight Nearest + Keybind Apply
-- ═══════════════════════════════════════════════════════════════════
-- ★ ระบบใหม่ทั้งหมดสำหรับ PC:
--   1. วน Highlight ผู้เล่นที่ cursor ชี้อยู่ใกล้สุดแบบ real-time
--   2. แสดง BillboardGui ชื่อ + ระยะห่าง เหนือหัวคนที่ lock
--   3. กด qa_keybind (default: E) เพื่อ Apply ทันที
--   4. เสียงต่างกัน: lock target / switch target / apply

local QA = {}
QA.conns = {}
QA.hl = nil          -- Highlight instance
QA.billboard = nil   -- BillboardGui แสดงชื่อ+ระยะ
QA.current_target = nil  -- player ที่ lock อยู่

-- ★ ลบ highlight + billboard เดิม
function QA.clear_visuals()
    if QA.hl then pcall(function() QA.hl:Destroy() end); QA.hl = nil end
    if QA.billboard then pcall(function() QA.billboard:Destroy() end); QA.billboard = nil end
end

-- ★ สร้าง Highlight + BillboardGui ให้คนที่ lock
function QA.set_target(p)
    local prev = QA.current_target
    QA.current_target = p
    QA.clear_visuals()

    if not p or not p.Character then return end
    local char = p.Character
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- Highlight
    QA.hl = mk("Highlight", {
        Name = "NexusQA_HL",
        Adornee = char,
        FillColor = P.yellow,
        FillTransparency = 0.5,
        OutlineColor = P.pri_lit,
        OutlineTransparency = 0,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        Parent = char
    })

    -- Billboard แสดงชื่อ + ระยะห่าง
    if head then
        QA.billboard = mk("BillboardGui", {
            Name = "NexusQA_BB",
            Adornee = head,
            Size = UDim2.new(0, 160, 0, 50),
            StudsOffset = Vector3.new(0, 3.5, 0),
            AlwaysOnTop = true,
            Parent = char
        })
        local bbf = mk("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.35,
            Parent = QA.billboard
        })
        rnd(bbf, 8)
        bdr(bbf, P.yellow, 1.5)
        mk("UIPadding", {PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), Parent=bbf})

        -- ชื่อ
        mk("TextLabel", {
            Name = "NameLabel",
            Size = UDim2.new(1, 0, 0.5, 0),
            Position = UDim2.new(0, 0, 0, 2),
            BackgroundTransparency = 1,
            Text = "🎯 " .. p.DisplayName,
            TextColor3 = P.yellow,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextStrokeTransparency = 0.3,
            Parent = bbf
        })

        -- ระยะห่าง + keybind hint
        local dist_lbl = mk("TextLabel", {
            Name = "DistLabel",
            Size = UDim2.new(1, 0, 0.5, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Text = "Press [" .. S.qa_keybind.Name .. "] to Apply",
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextStrokeTransparency = 0.4,
            Parent = bbf
        })

        -- อัพเดทระยะห่าง real-time
        local dist_conn
        dist_conn = rs.Heartbeat:Connect(function()
            if not QA.billboard or not QA.billboard.Parent then
                if dist_conn then dist_conn:Disconnect() end
                return
            end
            local my_root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if my_root and root and root.Parent then
                local dist = (my_root.Position - root.Position).Magnitude
                dist_lbl.Text = string.format("%.0f studs | [%s] Apply", dist, S.qa_keybind.Name)
            end
        end)
        table.insert(QA.conns, dist_conn); conn(dist_conn)
    end

    -- ★ เล่นเสียงตามสถานะ
    if prev == nil and p ~= nil then
        sfx("qa_lock") -- เพิ่ง lock target ใหม่
    elseif prev ~= nil and p ~= nil and prev ~= p then
        sfx("qa_switch") -- เปลี่ยน target
    end
end

-- ★ Apply ตัวที่ lock อยู่
function QA.do_apply()
    local p = QA.current_target
    if not p then NF.push("No target! Point at a player", "warn", 2); return end
    sfx("qa_apply")
    local name = p.DisplayName
    QA.set_target(nil)
    QA.current_target = nil
    S.qa_selected_player = nil
    AV.apply(p.UserId)
    NF.push("🎯 Quick Applied → " .. name, "qa", 3)
end

function QA.enable()
    QA.disable()

    if IS_PHONE then
        -- ═══ MOBILE MODE (เหมือนเดิม — double tap) ═══
        local c1 = uis.InputBegan:Connect(function(inp, gp)
            if gp or not S.quick_apply_on or not isclick(inp) then return end
            local p = smart_find_player()
            if not p then return end
            local now = tick()
            if S.qa_last_tap_player == p and (now - S.qa_last_tap_time) < 0.6 then
                sfx("qa_apply")
                S.qa_last_tap_player = nil
                S.qa_last_tap_time = 0
                QA.set_target(nil)
                AV.apply(p.UserId)
            else
                S.qa_last_tap_player = p
                S.qa_last_tap_time = now
                QA.set_target(p)
            end
        end)
        table.insert(QA.conns, c1); conn(c1)

        -- timeout สำหรับ mobile
        local c3 = rs.Heartbeat:Connect(function()
            if S.qa_last_tap_player and (tick() - S.qa_last_tap_time) > 2 then
                S.qa_last_tap_player = nil
                S.qa_last_tap_time = 0
                QA.set_target(nil)
            end
        end)
        table.insert(QA.conns, c3); conn(c3)
    else
        -- ═══════════════════════════════════════════════════
        -- ★★★ PC MODE — Auto Highlight Nearest + Keybind ★★★
        -- ═══════════════════════════════════════════════════

        local last_highlighted = nil
        local throttle_timer = 0

        -- 1) ทุก frame: หาคนที่ cursor ใกล้สุด → auto highlight
        local render_conn = rs.RenderStepped:Connect(function(dt)
            if not S.quick_apply_on then return end
            throttle_timer = throttle_timer + dt
            if throttle_timer < 0.05 then return end -- throttle 20fps เพื่อ performance
            throttle_timer = 0

            local p = smart_find_player()
            if p ~= last_highlighted then
                last_highlighted = p
                QA.set_target(p) -- จะ auto เล่นเสียง lock/switch
            end
        end)
        table.insert(QA.conns, render_conn); conn(render_conn)

        -- 2) กด qa_keybind → Apply ทันที
        local key_conn = uis.InputBegan:Connect(function(inp, gp)
            if gp or not S.quick_apply_on then return end
            if inp.KeyCode == S.qa_keybind then
                QA.do_apply()
            end
        end)
        table.insert(QA.conns, key_conn); conn(key_conn)

        -- 3) Click ก็ Apply ได้เช่นกัน (optional — สำหรับคนชอบคลิก)
        local click_conn = uis.InputBegan:Connect(function(inp, gp)
            if gp or not S.quick_apply_on or not isclick(inp) then return end
            if QA.current_target then
                QA.do_apply()
            end
        end)
        table.insert(QA.conns, click_conn); conn(click_conn)
    end

    NF.push("🎯 Quick Apply ON" .. (IS_PHONE and " (Double Tap)" or " [" .. S.qa_keybind.Name .. "]"), "qa", 3)
end

function QA.disable()
    for _, c in ipairs(QA.conns) do pcall(function() c:Disconnect() end) end
    QA.conns = {}
    QA.clear_visuals()
    QA.current_target = nil
    S.qa_selected_player = nil
end

-- ═══════════════════════════════════════
-- SWAP MODE
-- ═══════════════════════════════════════
local SW = {}; SW.conn = nil; SW.hl1 = nil
function SW.clear() if SW.hl1 then SW.hl1:Destroy(); SW.hl1 = nil end end
function SW.enable() SW.disable(); S.swap_source = nil; SW.conn = uis.InputBegan:Connect(function(inp, gp) if gp or not isclick(inp) then return end; local p = smart_find_player(); if not p then return end
    if not S.swap_source then S.swap_source = p; SW.clear(); if p.Character then SW.hl1 = mk("Highlight", {Adornee = p.Character, FillColor = P.cyan, FillTransparency = 0.6, OutlineColor = P.cyan, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = p.Character}) end; NF.push("Source: " .. p.Name, "swap", 3); sfx("click")
    else local src = S.swap_source; S.swap_source = nil; SW.clear(); if p == lp then AV.apply(src.UserId) else AV.apply_to_other(p, src.UserId) end end end); conn(SW.conn) end
function SW.disable() if SW.conn then SW.conn:Disconnect(); SW.conn = nil end; SW.clear(); S.swap_source = nil end

-- ═══════════════════════════════════════
-- TAP COPY MODE
-- ═══════════════════════════════════════
local TC = {}; TC.conn = nil; TC.hl = nil; TC.on_tap = nil
function TC.enable() TC.disable(); TC.conn = uis.InputBegan:Connect(function(inp, gp) if gp or not isclick(inp) then return end; local p = smart_find_player(); if not p then return end
    if TC.on_tap then TC.on_tap(p) end; sfx("copy"); NF.push("Copied " .. p.Name .. " (" .. p.UserId .. ")", "ok", 2)
    if TC.hl then TC.hl:Destroy() end; if p.Character then TC.hl = mk("Highlight", {Adornee = p.Character, FillColor = P.pri, FillTransparency = 0.7, OutlineColor = P.pri_lit, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = p.Character}); task.delay(1.5, function() if TC.hl then TC.hl:Destroy(); TC.hl = nil end end) end end); conn(TC.conn) end
function TC.disable() if TC.conn then TC.conn:Disconnect(); TC.conn = nil end; if TC.hl then TC.hl:Destroy(); TC.hl = nil end end

-- ═══════════════════════════════════════
-- ESP
-- ═══════════════════════════════════════
local ESP = {}

function ESP.enable()
    ESP.disable()
    S.esp_on = true
    local colors = {
        Color3.fromRGB(255,100,100), Color3.fromRGB(100,255,100),
        Color3.fromRGB(100,100,255), Color3.fromRGB(255,255,100),
        Color3.fromRGB(255,100,255), Color3.fromRGB(100,255,255),
    }
    local function apply_esp(p)
        if p == lp then return end
        local function add_hl(char)
            if not char or not S.esp_on then return end
            pcall(function()
                local old = char:FindFirstChild("NexusESP")
                if old then old:Destroy() end
                local ci = (p.UserId % #colors) + 1
                local hl = mk("Highlight", {
                    Name = "NexusESP", Adornee = char,
                    FillColor = colors[ci], FillTransparency = 0.7,
                    OutlineColor = colors[ci], OutlineTransparency = 0.3,
                    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = char
                })
                S.esp_highlights[p.UserId] = hl
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                if root then
                    local bb = mk("BillboardGui", {
                        Name = "NexusESPTag", Adornee = root,
                        Size = UDim2.new(0,100,0,40), StudsOffset = Vector3.new(0,4,0),
                        AlwaysOnTop = true, Parent = char
                    })
                    mk("TextLabel", {
                        Size = UDim2.new(1,0,0.5,0), BackgroundTransparency = 1,
                        Text = p.DisplayName, TextColor3 = colors[ci],
                        Font = Enum.Font.GothamBold, TextSize = 13,
                        TextStrokeTransparency = 0.5, Parent = bb
                    })
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local hp_lbl = mk("TextLabel", {
                            Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0),
                            BackgroundTransparency = 1,
                            Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth),
                            TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamMedium,
                            TextSize = 10, TextStrokeTransparency = 0.5, Parent = bb
                        })
                        conn(hum.HealthChanged:Connect(function(hp)
                            if hp_lbl and hp_lbl.Parent then
                                hp_lbl.Text = math.floor(hp) .. "/" .. math.floor(hum.MaxHealth)
                            end
                        end))
                    end
                end
            end)
        end
        if p.Character then add_hl(p.Character) end
        conn(p.CharacterAdded:Connect(function(c) task.wait(0.5); if S.esp_on then add_hl(c) end end))
    end
    for _, p in ipairs(plrs:GetPlayers()) do apply_esp(p) end
    conn(plrs.PlayerAdded:Connect(function(p) if S.esp_on then apply_esp(p) end end))
    NF.push("ESP Enabled — " .. (#plrs:GetPlayers()-1) .. " players", "esp", 3)
end

function ESP.disable()
    S.esp_on = false
    for _, p in ipairs(plrs:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("NexusESP")
            if hl then hl:Destroy() end
            local tag = p.Character:FindFirstChild("NexusESPTag")
            if tag then tag:Destroy() end
        end
    end
    S.esp_highlights = {}
end

-- ═══════════════════════════════════════
-- TELEPORT
-- ═══════════════════════════════════════
local TP = {}

function TP.to_player(target_name)
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then NF.push("No character", "err"); return end
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp and (p.Name:lower():find(target_name:lower(),1,true) or p.DisplayName:lower():find(target_name:lower(),1,true)) then
            local tr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                root.CFrame = tr.CFrame * CFrame.new(0,0,3)
                sfx("teleport"); NF.push("Teleported to " .. p.DisplayName, "tp", 2)
                return
            end
        end
    end
    sfx("error"); NF.push("Player not found", "err")
end

function TP.save_waypoint(name)
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then NF.push("No character", "err"); return end
    table.insert(S.tp_waypoints, {name=name or "WP"..#S.tp_waypoints+1, pos={root.CFrame.X, root.CFrame.Y, root.CFrame.Z}})
    save(); sfx("success"); NF.push("Waypoint saved: " .. (name or "WP"), "tp", 2)
end

function TP.goto_waypoint(idx)
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then NF.push("No character", "err"); return end
    local wp = S.tp_waypoints[idx]
    if not wp then NF.push("Invalid waypoint", "err"); return end
    root.CFrame = CFrame.new(wp.pos[1], wp.pos[2], wp.pos[3])
    sfx("teleport"); NF.push("Teleported to " .. wp.name, "tp", 2)
end

function TP.delete_waypoint(idx)
    table.remove(S.tp_waypoints, idx); save()
    sfx("close"); NF.push("Waypoint deleted", "ok", 2)
end

-- ═══════════════════════════════════════
-- ANTI-AFK
-- ═══════════════════════════════════════
local ANTI_AFK = {}

function ANTI_AFK.start()
    if not S.anti_afk then return end
    spawn_loop("anti_afk", 120, function()
        if S.anti_afk then
            local vu = game:GetService("VirtualUser")
            pcall(function() vu:CaptureController() end)
            pcall(function() vu:ClickButton2(Vector2.new()) end)
        end
    end)
end

function ANTI_AFK.stop()
    kill_loop("anti_afk")
end

-- ═══════════════════════════════════════
-- MIRROR MODE
-- ═══════════════════════════════════════
local MIRROR = {}

function MIRROR.enable()
    S.mirror_mode = true
    if not S.cur_id then NF.push("Apply avatar first!", "warn"); return end
    local count = 0
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp then
            if AV.apply_to_other(p, S.cur_id) then count = count + 1 end
        end
    end
    sfx("success"); NF.push("Mirrored to " .. count .. " players!", "ok", 3)
end

function MIRROR.disable()
    S.mirror_mode = false
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp then AV.reset_other(p) end
    end
    NF.push("Mirror mode off", "ok", 2)
end

-- ═══════════════════════════════════════
-- 2D PREVIEW
-- ═══════════════════════════════════════
local PV2D = {}
function PV2D.show(gui, uid, nm)
    sfx("preview") -- [NEW]
    local old = gui:FindFirstChild("Preview2D"); if old then old:Destroy() end; SZ = get_sz()
    local pw, ph = math.min(SZ.w - 16, 320), math.min(SZ.h - 20, 440)
    local ov = mk("Frame", {Name = "Preview2D", Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.4, ZIndex = 100, Parent = gui})
    local ov_hit = mk("TextButton", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=100, Parent=ov})
    safe_click(ov_hit, function() sfx("close"); ov:Destroy() end)

    local card = mk("Frame", {Size = UDim2.new(0,pw,0,ph), Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = P.bg, ZIndex = 101, Parent = ov}); rnd(card, 14); bdr(card, P.pri, 2); card.Active = true
    local h2 = mk("Frame", {Size = UDim2.new(1,0,0,36), BackgroundColor3 = P.surface, BorderSizePixel = 0, ZIndex = 102, Parent = card}); rnd(h2, 14)
    mk("Frame", {Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,1,-14), BackgroundColor3 = P.surface, BorderSizePixel = 0, ZIndex = 102, Parent = h2})
    mk("TextLabel", {Size = UDim2.new(1,-44,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = tostring(nm or getname(uid)), TextColor3 = P.pri_lit, Font = Enum.Font.GothamBold, TextSize = SZ.txt, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 103, Parent = h2})
    mk("TextLabel", {Size = UDim2.new(0,60,0,12), Position = UDim2.new(1,-100,0.5,-6), BackgroundTransparency = 1, Text = "ID:"..uid, TextColor3 = P.txt3, Font = Enum.Font.GothamMedium, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 103, Parent = h2})
    local xb = mk("TextButton", {Size = UDim2.new(0,26,0,26), Position = UDim2.new(1,-32,0.5,-13), BackgroundColor3 = P.raised, Text = "X", TextColor3 = P.red, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 104, Parent = h2}); rnd(xb, 6)
    safe_click(xb, function() sfx("close"); ov:Destroy() end)
    local views = {{name="Full Body", url="rbxthumb://type=Avatar&id="..uid.."&w=420&h=420"}, {name="Headshot", url="rbxthumb://type=AvatarHeadShot&id="..uid.."&w=420&h=420"}, {name="Bust", url="rbxthumb://type=AvatarBust&id="..uid.."&w=420&h=420"}}
    local cv = 1
    local imf = mk("Frame", {Size = UDim2.new(1,-20,1,-130), Position = UDim2.new(0,10,0,40), BackgroundColor3 = P.surface, BorderSizePixel = 0, ZIndex = 102, Parent = card}); rnd(imf, 10)
    local avimg = mk("ImageLabel", {Size = UDim2.new(1,-8,1,-8), Position = UDim2.new(0,4,0,4), BackgroundTransparency = 1, Image = views[1].url, ScaleType = Enum.ScaleType.Fit, ZIndex = 103, Parent = imf}); rnd(avimg, 8)
    local vlbl = mk("TextLabel", {Size = UDim2.new(0,80,0,18), Position = UDim2.new(0.5,-40,0,4), BackgroundColor3 = P.bg, BackgroundTransparency = 0.3, Text = views[1].name, TextColor3 = P.pri_lit, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm - 1, ZIndex = 104, Parent = imf}); rnd(vlbl, 6)
    local sr2 = mk("Frame", {Size = UDim2.new(1,-20,0,SZ.btn_h-4), Position = UDim2.new(0,10,1,-(SZ.btn_h*2+16)), BackgroundTransparency = 1, ZIndex = 102, Parent = card}); mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), Parent = sr2})
    local vbtns = {}
    for i, v in ipairs(views) do
        local vb = mk("TextButton", {Size = UDim2.new(1/3,-3,1,0), BackgroundColor3 = i==1 and P.pri or P.raised, Text = v.name, TextColor3 = i==1 and P.txt or P.txt2, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm-1, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103, Parent = sr2}); rnd(vb, 6); vbtns[i] = vb
        local idx2 = i; safe_click(vb, function() sfx("tab"); cv = idx2; avimg.Image = views[idx2].url; vlbl.Text = views[idx2].name; for j, btn in ipairs(vbtns) do tw(btn, {BackgroundColor3 = j==idx2 and P.pri or P.raised}, 0.15); tw(btn, {TextColor3 = j==idx2 and P.txt or P.txt2}, 0.15) end end)
    end
    local br2 = mk("Frame", {Size = UDim2.new(1,-20,0,SZ.btn_h), Position = UDim2.new(0,10,1,-(SZ.btn_h+6)), BackgroundTransparency = 1, ZIndex = 102, Parent = card}); mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), Parent = br2})
    local ab = mk("TextButton", {Size = UDim2.new(0.3,0,1,0), BackgroundColor3 = P.pri, Text = "Apply", TextColor3 = P.txt, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103, Parent = br2}); rnd(ab, 6)
    local fb2 = mk("TextButton", {Size = UDim2.new(0.2,0,1,0), BackgroundColor3 = P.raised, Text = FAV.has(uid) and "★" or "+Fav", TextColor3 = FAV.has(uid) and P.yellow or P.txt2, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm-1, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103, Parent = br2}); rnd(fb2, 6)
    local cpid = mk("TextButton", {Size = UDim2.new(0.2,0,1,0), BackgroundColor3 = P.raised, Text = "Copy", TextColor3 = P.cyan, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm-1, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103, Parent = br2}); rnd(cpid, 6)
    local cb2 = mk("TextButton", {Size = UDim2.new(0.3,0,1,0), BackgroundColor3 = P.raised, Text = "Close", TextColor3 = P.txt, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 103, Parent = br2}); rnd(cb2, 6)
    safe_click(ab, function() sfx("apply"); ov:Destroy(); AV.apply(uid) end)
    safe_click(fb2, function() FAV.toggle(uid); fb2.Text = FAV.has(uid) and "★" or "+Fav"; fb2.TextColor3 = FAV.has(uid) and P.yellow or P.txt2 end)
    safe_click(cpid, function() if setclipboard then setclipboard(tostring(uid)); sfx("copy"); NF.push("ID copied: "..uid, "ok", 2) end end)
    safe_click(cb2, function() sfx("close"); ov:Destroy() end)
    card.Size = UDim2.new(0, pw*0.85, 0, ph*0.85); bounce(card, {Size = UDim2.new(0, pw, 0, ph)}, 0.3)
end

-- ═══════════════════════════════════════
-- MODS + MUSIC
-- ═══════════════════════════════════════
local MODS = {}
function MODS.set_speed(v) local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end end
function MODS.set_jump(v) local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = v end end
local nc_c; function MODS.noclip(on) if nc_c then nc_c:Disconnect(); nc_c = nil end; if on then nc_c = rs.Stepped:Connect(function() local c = lp.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end); conn(nc_c) end end
local ij_c; function MODS.inf_jump(on) if ij_c then ij_c:Disconnect(); ij_c = nil end; if on then ij_c = uis.JumpRequest:Connect(function() local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end); conn(ij_c) end end
local fly_d = {active=false, bv=nil, bg=nil}
function MODS.fly(on)
    if on then local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
        fly_d.bv = mk("BodyVelocity", {MaxForce = Vector3.new(9e9,9e9,9e9), Velocity = Vector3.zero, Parent = root})
        fly_d.bg = mk("BodyGyro", {MaxTorque = Vector3.new(9e9,9e9,9e9), P = 9e4, Parent = root}); fly_d.active = true
        local fc; fc = rs.RenderStepped:Connect(function() if not fly_d.active then fc:Disconnect(); return end; local cam = workspace.CurrentCamera; local d = Vector3.zero
            if uis:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end; if uis:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end; if uis:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.yAxis end; if uis:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.yAxis end
            fly_d.bv.Velocity = (d.Magnitude > 0 and d.Unit or Vector3.zero) * 80; fly_d.bg.CFrame = cam.CFrame end); conn(fc)
    else fly_d.active = false; if fly_d.bv then fly_d.bv:Destroy(); fly_d.bv = nil end; if fly_d.bg then fly_d.bg:Destroy(); fly_d.bg = nil end end
end

function MODS.set_gravity(v)
    workspace.Gravity = v
end

local MU = {}
function MU.play() MU.stop(); S.music_obj = mk("Sound", {SoundId = TRACKS[S.music_idx].id, Volume = S.music_vol, Looped = S.music_loop, Parent = workspace}); if not S.music_loop then S.music_obj.Ended:Connect(function() if S.music_playing then MU.next() end end) end; S.music_obj:Play(); S.music_playing = true end
function MU.stop() if S.music_obj then S.music_obj:Stop(); S.music_obj:Destroy(); S.music_obj = nil end; S.music_playing = false end
function MU.toggle() if S.music_playing then if S.music_obj and S.music_obj.IsPlaying then S.music_obj:Pause(); S.music_playing = false else MU.play() end else MU.play() end end
function MU.next() S.music_idx = (S.music_idx % #TRACKS) + 1; local w = S.music_playing; MU.stop(); if w then MU.play() end; save() end
function MU.prev() S.music_idx = S.music_idx - 1; if S.music_idx < 1 then S.music_idx = #TRACKS end; local w = S.music_playing; MU.stop(); if w then MU.play() end; save() end

-- ═══════════════════════════════════════
-- UI BUILD
-- ═══════════════════════════════════════
local UI, R = {}, {}

function UI.kill()
    ON.stop_heartbeat()
    ANTI_AFK.stop()
    for name, _ in pairs(LOOPS) do LOOPS[name] = false end
    for _, c in ipairs(CONNS) do pcall(function() c:Disconnect() end) end; CONNS = {}
    MU.stop(); MODS.noclip(false); MODS.inf_jump(false); MODS.fly(false)
    ESP.disable()
    TC.disable(); QA.disable(); SW.disable()
    if R.gui then R.gui:Destroy() end; R = {}
end

function UI.build()
    apply_theme(); SZ = get_sz()
    local gui = mk("ScreenGui", {Name = "NexusAE", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999998, IgnoreGuiInset = true, Parent = pgui})
    R.gui = gui; NF.parent = gui

    local vps = workspace.CurrentCamera.ViewportSize
    local win = mk("Frame", {Size = UDim2.new(0, SZ.w, 0, SZ.h), Position = UDim2.new(0, math.floor(vps.X/2 - SZ.w/2), 0, math.floor(vps.Y/2 - SZ.h/2)), BackgroundColor3 = P.bg, BackgroundTransparency = S.gui_transparency, BorderSizePixel = 0, ClipsDescendants = true, Parent = gui})
    rnd(win, IS_PHONE and 10 or 14); R.main_stroke = bdr(win, P.pri, 1.5); R.win = win

    -- Header
    local hdr = mk("Frame", {Size = UDim2.new(1,0,0,SZ.hdr_h), BackgroundColor3 = P.surface, BackgroundTransparency = S.gui_transparency * 0.5, BorderSizePixel = 0, Parent = win}); rnd(hdr, IS_PHONE and 10 or 14)
    mk("Frame", {Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,1,-14), BackgroundColor3 = P.surface, BackgroundTransparency = S.gui_transparency * 0.5, BorderSizePixel = 0, Parent = hdr})
    local ph2 = string.format("%02x%02x%02x", P.pri.R*255, P.pri.G*255, P.pri.B*255)
    local title_txt = '<font color="#'..ph2..'">N</font>exus <font color="#9B98B2">5.0</font>'
    if IS_OWNER then title_txt = title_txt .. ' <font color="#FFD700">★</font>' end
    mk("TextLabel", {Size = UDim2.new(0,180,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, RichText = true, Text = title_txt, TextColor3 = P.txt, Font = Enum.Font.GothamBlack, TextSize = SZ.txt_lg, TextXAlignment = Enum.TextXAlignment.Left, Parent = hdr})
    R.status_dot = mk("Frame", {Size = UDim2.new(0,7,0,7), Position = UDim2.new(0, SZ.txt_lg*5+8, 0.5, -3), BackgroundColor3 = S.cur_id and P.green or P.txt3, BorderSizePixel = 0, Parent = hdr}); rnd(R.status_dot, 4)

    R.morph_count = mk("TextLabel", {Size = UDim2.new(0,50,0,12), Position = UDim2.new(0, SZ.txt_lg*5+20, 0.5, -6), BackgroundTransparency = 1, Text = "#"..S.total_morphs, TextColor3 = P.txt3, Font = Enum.Font.GothamMedium, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, Parent = hdr})

    local min_btn = mk("TextButton", {Size = UDim2.new(0,SZ.hdr_h-12,0,SZ.hdr_h-12), Position = UDim2.new(1,-(SZ.hdr_h-4),0.5,-(SZ.hdr_h-12)/2), BackgroundColor3 = P.raised, Text = "—", TextColor3 = P.txt2, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, BorderSizePixel = 0, Parent = hdr}); rnd(min_btn, 6)

    local body = mk("Frame", {Size = UDim2.new(1,-SZ.pad*2,1,-SZ.hdr_h-4), Position = UDim2.new(0,SZ.pad,0,SZ.hdr_h+2), BackgroundTransparency = 1, ClipsDescendants = true, Parent = win})
    R.body = body; mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, SZ.pad-2), Parent = body})

    -- Tabs
    local tbar = mk("Frame", {Size = UDim2.new(1,0,0,SZ.tab_h), BackgroundTransparency = 1, LayoutOrder = 1, Parent = body})
    mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,2), Parent = tbar})
    local TD = {
        {id="home",txt="Home"},{id="outfit",txt="Outfit"},{id="friends",txt="Friends"},
        {id="favs",txt="★Favs"},{id="online",txt="Online"},{id="tools",txt="Tools"},
        {id="client",txt="Client"},{id="mods",txt="Mods"},{id="cfg",txt="Config"}
    }
    local tbs, tps = {}, {}
    for _, td in ipairs(TD) do
        local tb = mk("TextButton", {Size = UDim2.new(1/#TD,-1,1,0), BackgroundColor3 = td.id == S.tab and P.pri or P.raised, Text = td.txt, TextColor3 = td.id == S.tab and P.txt or P.txt2, Font = Enum.Font.GothamBold, TextSize = IS_PHONE and (SZ.txt_sm-2) or (SZ.txt_sm-1), AutoButtonColor = false, BorderSizePixel = 0, Parent = tbar}); rnd(tb, 6); tbs[td.id] = tb
    end

    local function stab(id)
        S.tab = id; sfx("tab") -- [NEW] tab switch sound
        for k, btn in pairs(tbs) do tw(btn, {BackgroundColor3 = k==id and P.pri or P.raised}, 0.15); tw(btn, {TextColor3 = k==id and P.txt or P.txt2}, 0.15) end
        for k, pg in pairs(tps) do pg.Visible = (k == id) end
        if id == "friends" and not S.friends_loaded then FR.load() end
        if id == "outfit" then task.spawn(function() OUTFIT.scan(); if OUTFIT.render_fn then OUTFIT.render_fn() end; if OUTFIT.render_emotes_fn then OUTFIT.render_emotes_fn() end end) end
        if id == "online" then task.spawn(function() ON.fetch_users(); CH.fetch(); if ON.refresh_fn then ON.refresh_fn() end; if CH.refresh_fn then CH.refresh_fn() end end) end
    end
    for _, td in ipairs(TD) do safe_click(tbs[td.id], function() stab(td.id) end) end

    -- Helpers
    local function mkpg(vis, ord)
        local pg = mk("ScrollingFrame", {Size = UDim2.new(1,0,1,-(SZ.tab_h+SZ.pad)), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = P.pri, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = vis, LayoutOrder = ord or 2, BorderSizePixel = 0, Parent = body})
        mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, SZ.pad-2), Parent = pg}); mk("UIPadding", {PaddingBottom = UDim.new(0,30), Parent = pg}); return pg
    end

    -- [NEW] ★ sb() ตอนนี้เล่นเสียง click ทุกปุ่ม + hover sound
    local function sb(par, txt, clr, w, h, ord)
        h = h or SZ.btn_h; clr = clr or P.raised
        local btn = mk("TextButton", {Size = UDim2.new(w or 1, 0, 0, h), BackgroundColor3 = clr, Text = txt or "", TextColor3 = P.txt, Font = Enum.Font.GothamBold, TextSize = SZ.txt, AutoButtonColor = false, LayoutOrder = ord or 0, BorderSizePixel = 0, Parent = par}); rnd(btn, 7)
        local base = clr
        btn.MouseEnter:Connect(function()
            tw(btn, {BackgroundColor3 = Color3.new(math.min(base.R*1.15,1), math.min(base.G*1.15,1), math.min(base.B*1.15,1))}, 0.08)
            sfx("hover") -- [NEW] subtle hover sound
        end)
        btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = base}, 0.08) end)
        return btn
    end

    local function sec(par, txt, ord) mk("TextLabel", {Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1, Text = txt, TextColor3 = P.txt2, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = ord or 0, Parent = par}) end

    -- [NEW] ★ stog — toggle เล่นเสียง on/off ต่างกัน
    local function stog(par, label, init, cb, ord)
        local row = mk("Frame", {Size = UDim2.new(1,0,0,SZ.btn_h-4), BackgroundColor3 = P.card, BackgroundTransparency = S.gui_transparency * 0.3, LayoutOrder = ord or 0, BorderSizePixel = 0, Parent = par}); rnd(row, 7)
        mk("TextLabel", {Size = UDim2.new(1,-50,1,0), Position = UDim2.new(0,8,0,0), BackgroundTransparency = 1, Text = label, TextColor3 = P.txt, Font = Enum.Font.GothamMedium, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Left, Parent = row})
        local track = mk("Frame", {Size = UDim2.new(0,32,0,17), Position = UDim2.new(1,-40,0.5,-8), BackgroundColor3 = init and P.pri or P.ghost, BorderSizePixel = 0, Parent = row}); rnd(track, 9)
        local knob = mk("Frame", {Size = UDim2.new(0,13,0,13), Position = init and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6), BackgroundColor3 = P.txt, BorderSizePixel = 0, Parent = track}); rnd(knob, 7)
        local state = init
        local hit = mk("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = row})
        safe_click(hit, function()
            state = not state
            sfx(state and "toggle_on" or "toggle_off") -- [NEW] ★ เสียงต่างกัน
            tw(track, {BackgroundColor3 = state and P.pri or P.ghost}, 0.15)
            bounce(knob, {Position = state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6)}, 0.18)
            if cb then cb(state) end
        end)
        local function sf(v) state = v; tw(track, {BackgroundColor3 = v and P.pri or P.ghost}, 0.15); bounce(knob, {Position = v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6)}, 0.18) end
        return row, function() return state end, sf
    end

    -- [NEW] ★ slider เล่น tick sound ตอนลาก
    local function sslider(par, label, minv, maxv, init, cb, ord, fmt)
        fmt = fmt or "%.0f"
        local fr = mk("Frame", {Size = UDim2.new(1,0,0,44), BackgroundColor3 = P.card, BackgroundTransparency = S.gui_transparency * 0.3, LayoutOrder = ord or 0, BorderSizePixel = 0, Parent = par}); rnd(fr, 7)
        mk("TextLabel", {Size = UDim2.new(0.6,0,0,16), Position = UDim2.new(0,8,0,3), BackgroundTransparency = 1, Text = label, TextColor3 = P.txt, Font = Enum.Font.GothamMedium, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Left, Parent = fr})
        local vl = mk("TextLabel", {Size = UDim2.new(0,42,0,16), Position = UDim2.new(1,-50,0,3), BackgroundTransparency = 1, Text = string.format(fmt, init), TextColor3 = P.pri_lit, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Right, Parent = fr})
        local bg = mk("Frame", {Size = UDim2.new(1,-16,0,5), Position = UDim2.new(0,8,0,26), BackgroundColor3 = P.ghost, BorderSizePixel = 0, Parent = fr}); rnd(bg, 3)
        local pct = math.clamp((init-minv)/(maxv-minv), 0, 1)
        local fill = mk("Frame", {Size = UDim2.new(pct,0,1,0), BackgroundColor3 = P.pri, BorderSizePixel = 0, Parent = bg}); rnd(fill, 3)
        local handle = mk("Frame", {Size = UDim2.new(0,12,0,12), Position = UDim2.new(pct,-6,0.5,-6), BackgroundColor3 = P.txt, BorderSizePixel = 0, ZIndex = 2, Parent = bg}); rnd(handle, 6)
        local drg = false
        local last_tick_val = init -- [NEW] สำหรับเล่น tick เสียง

        local function update_slider(input_pos)
            local rx = math.clamp((input_pos.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rx,0,1,0); handle.Position = UDim2.new(rx,-6,0.5,-6)
            local val = minv + rx*(maxv-minv)
            vl.Text = string.format(fmt, val)
            -- [NEW] ★ เล่น tick เสียงทุกๆ ค่าเปลี่ยน 5%+
            local step = (maxv - minv) * 0.05
            if math.abs(val - last_tick_val) >= step then
                last_tick_val = val
                sfx("slider")
            end
            if cb then cb(val) end
        end
        bg.InputBegan:Connect(function(i)
            if isclick(i) then
                drg = true
                update_slider(uis:GetMouseLocation())
            end
        end)
        handle.InputBegan:Connect(function(i)
            if isclick(i) then drg = true end
        end)
        conn(uis.InputChanged:Connect(function(i)
            if not drg then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                update_slider(uis:GetMouseLocation())
            end
        end))
        conn(uis.InputEnded:Connect(function(i)
            if isclick(i) and drg then drg = false; save() end
        end))
        return fr
    end

    local function sinput(par, ph3, ord)
        local wr = mk("Frame", {Size = UDim2.new(1,0,0,SZ.btn_h), BackgroundColor3 = P.input_bg, LayoutOrder = ord or 0, BorderSizePixel = 0, Parent = par}); rnd(wr, 7); bdr(wr, P.outline)
        local bx = mk("TextBox", {Size = UDim2.new(1,-12,1,0), Position = UDim2.new(0,6,0,0), BackgroundTransparency = 1, Text = "", PlaceholderText = ph3 or "", PlaceholderColor3 = P.txt3, TextColor3 = P.txt, Font = Enum.Font.GothamMedium, TextSize = SZ.txt, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = wr})
        return wr, bx
    end

    -- ===================== HOME =====================
    local home = mkpg(true, 2); tps["home"] = home
    local irow = mk("Frame", {Size = UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency = 1, LayoutOrder = 1, Parent = home}); mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), Parent = irow})
    local iwrap = mk("Frame", {Size = UDim2.new(1,-(SZ.btn_h+4),0,SZ.btn_h), BackgroundColor3 = P.input_bg, BorderSizePixel = 0, Parent = irow}); rnd(iwrap, 7); bdr(iwrap, P.outline)
    R.input = mk("TextBox", {Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,5,0,0), BackgroundTransparency = 1, Text = S.cur_id and tostring(S.cur_id) or "", PlaceholderText = "Username / ID", PlaceholderColor3 = P.txt3, TextColor3 = P.txt, Font = Enum.Font.GothamMedium, TextSize = SZ.txt, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = iwrap})
    R.fav_btn = mk("TextButton", {Size = UDim2.new(0,SZ.btn_h,0,SZ.btn_h), BackgroundColor3 = P.raised, Text = S.cur_id and FAV.has(S.cur_id) and "★" or "+", TextColor3 = S.cur_id and FAV.has(S.cur_id) and P.yellow or P.txt2, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, BorderSizePixel = 0, Parent = irow}); rnd(R.fav_btn, 7)

    sec(home, "ACTIONS", 2)
    local r1 = mk("Frame", {Size = UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency = 1, LayoutOrder = 3, Parent = home}); mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), Parent = r1})
    R.apply_btn = sb(r1, "⚡ APPLY", P.pri, 0.55); R.random_btn = sb(r1, "🎲 RANDOM", P.raised, 0.45)
    local r2 = mk("Frame", {Size = UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency = 1, LayoutOrder = 4, Parent = home}); mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), Parent = r2})
    R.reset_btn = sb(r2, "RESET", P.raised, 0.33); R.undo_btn = sb(r2, "< UNDO", P.raised, 0.33); R.redo_btn = sb(r2, "REDO >", P.raised, 0.34)

    -- Status card
    local sc = mk("Frame", {Size = UDim2.new(1,0,0,62), BackgroundColor3 = P.card, BackgroundTransparency = S.gui_transparency * 0.3, LayoutOrder = 5, BorderSizePixel = 0, Parent = home}); rnd(sc, 8); bdr(sc, P.outline)
    R.stat_name = mk("TextLabel", {Size = UDim2.new(1,-12,0,16), Position = UDim2.new(0,8,0,4), BackgroundTransparency = 1, Text = S.cur_id and getname(S.cur_id) or "-- No avatar --", TextColor3 = S.cur_id and P.pri_lit or P.txt3, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Left, Parent = sc})
    R.stat_id = mk("TextLabel", {Size = UDim2.new(0.6,0,0,12), Position = UDim2.new(0,8,0,22), BackgroundTransparency = 1, Text = S.cur_id and "ID: "..S.cur_id or "", TextColor3 = P.txt3, Font = Enum.Font.GothamMedium, TextSize = SZ.txt_sm-1, TextXAlignment = Enum.TextXAlignment.Left, Parent = sc})
    R.stat_hist = mk("TextLabel", {Size = UDim2.new(0,80,0,12), Position = UDim2.new(1,-88,0,22), BackgroundTransparency = 1, Text = "Hist:"..#S.hist, TextColor3 = P.txt3, Font = Enum.Font.GothamMedium, TextSize = SZ.txt_sm-1, TextXAlignment = Enum.TextXAlignment.Right, Parent = sc})
    R.stat_uptime = mk("TextLabel", {Size = UDim2.new(0.5,0,0,12), Position = UDim2.new(0,8,0,38), BackgroundTransparency = 1, Text = "Uptime: 0s", TextColor3 = P.txt3, Font = Enum.Font.GothamMedium, TextSize = SZ.txt_sm-2, TextXAlignment = Enum.TextXAlignment.Left, Parent = sc})
    R.stat_total = mk("TextLabel", {Size = UDim2.new(0.5,0,0,12), Position = UDim2.new(0.5,0,0,38), BackgroundTransparency = 1, Text = "Morphs: "..S.total_morphs, TextColor3 = P.txt3, Font = Enum.Font.GothamMedium, TextSize = SZ.txt_sm-2, TextXAlignment = Enum.TextXAlignment.Right, Parent = sc})
    R.stat_thumb = mk("ImageLabel", {Size = UDim2.new(0,48,0,48), Position = UDim2.new(1,-56,0,6), BackgroundColor3 = P.surface, BackgroundTransparency = S.cur_id and 0 or 1, Image = S.cur_id and ("rbxthumb://type=AvatarHeadShot&id="..S.cur_id.."&w=150&h=150") or "", ScaleType = Enum.ScaleType.Fit, Parent = sc}); rnd(R.stat_thumb, 24)
    bdr(R.stat_thumb, P.pri, 1)

    stog(home, "Auto-Apply on Respawn", S.auto_apply, function(v) S.auto_apply = v; save() end, 6)
    stog(home, "Morph Animation ✨", S.morph_anim, function(v) S.morph_anim = v; save() end, 7)

    sec(home, "INTERACTION MODES", 8)
    -- [NEW] ★ Quick Apply แสดง keybind ใน label
    local qa_label = "Quick Apply" .. (IS_PHONE and " (2xTap)" or " [" .. S.qa_keybind.Name .. "]")
    local _,_,qa_set = stog(home, qa_label, S.quick_apply_on, function(v) if v then CONFLICT.activate("quick_apply_on"); QA.enable() else S.quick_apply_on = false; QA.disable(); save() end end, 9)
    local _,_,sw_set = stog(home, "Swap Mode", S.swap_mode_on, function(v) if v then CONFLICT.activate("swap_mode_on"); SW.enable() else S.swap_mode_on = false; SW.disable(); save() end end, 10)
    CONFLICT.disable_fns["quick_apply_on"] = function() QA.disable(); qa_set(false) end
    CONFLICT.disable_fns["swap_mode_on"] = function() SW.disable(); sw_set(false) end

    sec(home, "PRESETS", 11)
    local ps_wrap, ps_box = sinput(home, "Search presets...", 12)
    local pnav = mk("Frame", {Size = UDim2.new(1,0,0,SZ.btn_h-6), BackgroundTransparency = 1, LayoutOrder = 13, Parent = home}); mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), Parent = pnav})
    R.pprev = sb(pnav, "< Prev", P.raised, 0.3, SZ.btn_h-6); R.pnext = sb(pnav, "Next >", P.raised, 0.3, SZ.btn_h-6); R.prand = sb(pnav, "Shuffle", P.raised, 0.4, SZ.btn_h-6)
    R.pgrid = mk("Frame", {Size = UDim2.new(1,0,0,math.ceil(8/4)*(SZ.btn_h-6+4)), BackgroundTransparency = 1, LayoutOrder = 14, Parent = home}); mk("UIGridLayout", {CellSize = UDim2.new(0.25,-3,0,SZ.btn_h-6), CellPadding = UDim2.new(0,3,0,4), Parent = R.pgrid})

    local function get_filtered_presets()
        local s = S.search_preset:lower()
        if s == "" then return PRESETS end
        local result = {}
        for _, p in ipairs(PRESETS) do
            if p.n:lower():find(s, 1, true) or tostring(p.id):find(s, 1, true) then
                table.insert(result, p)
            end
        end
        return result
    end

    local function rp()
        for _,c in ipairs(R.pgrid:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local filtered = get_filtered_presets()
        local si = (S.preset_page-1)*8+1
        for i = si, math.min(si+7, #filtered) do
            local p = filtered[i]
            local pb = sb(R.pgrid, p.n, P.raised, nil, SZ.btn_h-8)
            pb.TextSize = SZ.txt_sm-1; pb.Size = UDim2.new(0,0,0,0)
            local pid = p.id
            safe_click(pb, function() sfx("click"); R.input.Text = tostring(pid); AV.apply(pid) end)
        end
    end; rp()

    ps_box:GetPropertyChangedSignal("Text"):Connect(function()
        S.search_preset = ps_box.Text; S.preset_page = 1; rp()
    end)

    sec(home, "MUSIC", 15)
    local mc = mk("Frame", {Size = UDim2.new(1,0,0,SZ.btn_h*2+8), BackgroundColor3 = P.card, BackgroundTransparency = S.gui_transparency * 0.3, LayoutOrder = 16, BorderSizePixel = 0, Parent = home}); rnd(mc, 8); bdr(mc, P.outline)
    R.mus_name = mk("TextLabel", {Size = UDim2.new(1,-12,0,14), Position = UDim2.new(0,8,0,4), BackgroundTransparency = 1, Text = "♪ "..TRACKS[S.music_idx].n, TextColor3 = P.pri_lit, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Left, Parent = mc})
    local mr = mk("Frame", {Size = UDim2.new(1,-12,0,SZ.btn_h-6), Position = UDim2.new(0,6,0,20), BackgroundTransparency = 1, Parent = mc}); mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,3), Parent = mr})
    R.mprev = sb(mr, "<<", P.raised, 0.18, SZ.btn_h-6); R.mplay = sb(mr, S.music_playing and "||" or "▶", P.pri, 0.22, SZ.btn_h-6); R.mnext = sb(mr, ">>", P.raised, 0.18, SZ.btn_h-6); R.mloop = sb(mr, S.music_loop and "Loop" or "Once", S.music_loop and P.pri or P.raised, 0.2, SZ.btn_h-6); R.mstop = sb(mr, "Stop", P.red, 0.22, SZ.btn_h-6)
    sslider(mc, "Volume", 0, 100, S.music_vol*100, function(v) S.music_vol = v/100; if S.music_obj then S.music_obj.Volume = v/100 end end, 0, "%.0f%%")

    -- ===================== OUTFIT =====================
    local opg = mkpg(false, 2); tps["outfit"] = opg
    local ohdr = mk("Frame", {Size = UDim2.new(1,0,0,52), BackgroundColor3 = P.card, BackgroundTransparency = S.gui_transparency*0.3, LayoutOrder = 1, BorderSizePixel = 0, Parent = opg}); rnd(ohdr, 8); bdr(ohdr, P.pri, 1)
    mk("TextLabel", {Size = UDim2.new(0.6,0,0,18), Position = UDim2.new(0,10,0,5), BackgroundTransparency = 1, Text = "CURRENT OUTFIT", TextColor3 = P.txt, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm+1, TextXAlignment = Enum.TextXAlignment.Left, Parent = ohdr})
    R.ototal = mk("TextLabel", {Size = UDim2.new(1,-20,0,16), Position = UDim2.new(0,10,0,28), BackgroundTransparency = 1, Text = "Total: 0 R$", TextColor3 = P.yellow, Font = Enum.Font.GothamBold, TextSize = SZ.txt_sm, TextXAlignment = Enum.TextXAlignment.Left, Parent = ohdr})

    local oscan_row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=2, Parent=opg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=oscan_row})
    local oscan_btn = sb(oscan_row, "Refresh / Scan", P.pri, 0.6, SZ.btn_h)
    local oexport_btn = sb(oscan_row, "📋 Export", P.raised, 0.4, SZ.btn_h)

    sec(opg, "ITEMS", 3)
    R.ocon = mk("Frame", {Size = UDim2.new(1,0,0,10), BackgroundTransparency = 1, LayoutOrder = 4, Parent = opg})
    local ol2 = mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,4), Parent = R.ocon})
    ol2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() R.ocon.Size = UDim2.new(1,0,0,ol2.AbsoluteContentSize.Y) end)
    sec(opg, "EMOTES / ANIMATIONS", 5)
    local estop = sb(opg, "Stop All Emotes", P.red, 1, SZ.btn_h-4, 6)
    R.econ = mk("Frame", {Size = UDim2.new(1,0,0,10), BackgroundTransparency = 1, LayoutOrder = 7, Parent = opg})
    local el2 = mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,4), Parent = R.econ})
    el2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() R.econ.Size = UDim2.new(1,0,0,el2.AbsoluteContentSize.Y) end)
    safe_click(estop, function() sfx("click"); OUTFIT.stop_emotes() end)

    local function ro()
        for _, c in ipairs(R.ocon:GetChildren()) do if c:IsA("Frame") and c.Name ~= "" then c:Destroy() end end
        if #S.outfit_items == 0 then mk("TextLabel", {Name="empty", Size=UDim2.new(1,0,0,60), BackgroundTransparency=1, Text="No items\nApply avatar first!", TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt, TextWrapped=true, Parent=R.ocon}); R.ototal.Text="Total: 0 R$"; return end
        local total, eq = 0, 0; for _, it in ipairs(S.outfit_items) do if not it.removed then total = total + (it.price or 0); eq = eq + 1 end end
        R.ototal.Text = "Total: " .. format_num(total) .. " R$ | " .. eq .. "/" .. #S.outfit_items
        local ims = IS_PHONE and 40 or 48; local rh = math.max(ims+8, SZ.btn_h+16)
        for idx, it in ipairs(S.outfit_items) do
            local rm = it.removed or false
            local row = mk("Frame", {Name="O"..idx, Size=UDim2.new(1,0,0,rh), BackgroundColor3=rm and P.ghost or P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=idx, BorderSizePixel=0, Parent=R.ocon}); rnd(row, 8)
            local cc = P.pri; if it.category == "Accessory" then cc = P.cyan elseif it.category == "Shirt" or it.category == "Pants" or it.category == "T-Shirt" then cc = P.green elseif it.category == "Face" or it.category == "Head" then cc = P.orange end
            local tw2 = mk("Frame", {Size=UDim2.new(0,ims,0,ims), Position=UDim2.new(0,4,0.5,-ims/2), BackgroundColor3=P.surface, BorderSizePixel=0, Parent=row}); rnd(tw2, 6); bdr(tw2, cc, 1)
            mk("ImageLabel", {Size=UDim2.new(1,-4,1,-4), Position=UDim2.new(0,2,0,2), BackgroundTransparency=1, Image=get_thumb(it.assetId, 150), ScaleType=Enum.ScaleType.Fit, ImageTransparency=rm and 0.5 or 0, Parent=tw2})
            local tx = ims + 10
            mk("TextLabel", {Size=UDim2.new(1,-(tx+60),0,15), Position=UDim2.new(0,tx,0,4), BackgroundTransparency=1, Text=it.name, TextColor3=rm and P.txt3 or P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row})
            mk("TextLabel", {Size=UDim2.new(1,-(tx+60),0,11), Position=UDim2.new(0,tx,0,20), BackgroundTransparency=1, Text=(ATYPE[it.asset_type] or it.category).." | "..it.assetId, TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
            local pt = it.price > 0 and (format_num(it.price).." R$") or "Free"
            mk("TextLabel", {Size=UDim2.new(1,-(tx+60),0,12), Position=UDim2.new(0,tx,0,33), BackgroundTransparency=1, Text=pt, TextColor3=rm and P.txt3 or (it.price>0 and P.yellow or P.green), Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm-1, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
            local bw = IS_PHONE and 44 or 54; local ref = it
            if rm then local eb = mk("TextButton", {Size=UDim2.new(0,bw,0,SZ.btn_h-8), Position=UDim2.new(1,-(bw+6),0.5,-(SZ.btn_h-8)/2), BackgroundColor3=P.pri, Text="Equip", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm-1, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(eb, 5); safe_click(eb, function() sfx("click"); OUTFIT.equip_item(ref); ref.removed = false; task.delay(0.3, ro) end)
            else local rb = mk("TextButton", {Size=UDim2.new(0,bw,0,SZ.btn_h-8), Position=UDim2.new(1,-(bw+6),0.5,-(SZ.btn_h-8)/2), BackgroundColor3=P.red, Text="Remove", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm-1, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(rb, 5); safe_click(rb, function() sfx("click"); OUTFIT.remove_item(ref); ref.removed = true; task.delay(0.3, ro) end) end
        end
    end
    local function re()
        for _, c in ipairs(R.econ:GetChildren()) do if c:IsA("Frame") and c.Name ~= "" then c:Destroy() end end
        if #S.outfit_emotes == 0 then mk("TextLabel", {Name="empty_e", Size=UDim2.new(1,0,0,40), BackgroundTransparency=1, Text="No emotes found", TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt, Parent=R.econ}); return end
        for idx, em in ipairs(S.outfit_emotes) do
            local row = mk("Frame", {Name="E"..idx, Size=UDim2.new(1,0,0,SZ.btn_h+8), BackgroundColor3=P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=idx, BorderSizePixel=0, Parent=R.econ}); rnd(row, 8)
            local badge = em.emote_type == "equipped" and "EQ" or (em.emote_type == "anim" and "ANIM" or "AVL")
            local bclr = em.emote_type == "equipped" and P.green or (em.emote_type == "anim" and P.orange or P.txt3)
            mk("TextLabel", {Size=UDim2.new(0,30,0,14), Position=UDim2.new(0,6,0.5,-7), BackgroundColor3=bclr, BackgroundTransparency=0.7, Text=badge, TextColor3=bclr, Font=Enum.Font.GothamBold, TextSize=7, Parent=row})
            mk("TextLabel", {Size=UDim2.new(0.5,0,0,14), Position=UDim2.new(0,42,0,3), BackgroundTransparency=1, Text=em.name, TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row})
            if em.assetId > 0 then mk("TextLabel", {Size=UDim2.new(0,80,0,11), Position=UDim2.new(0,42,0,18), BackgroundTransparency=1, Text="ID:"..em.assetId, TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, TextXAlignment=Enum.TextXAlignment.Left, Parent=row}) end
            local bw2 = IS_PHONE and 36 or 44; local ename = em.name
            local pb = mk("TextButton", {Size=UDim2.new(0,bw2,0,SZ.btn_h-8), Position=UDim2.new(1,-(bw2+6),0.5,-(SZ.btn_h-8)/2), BackgroundColor3=P.pri, Text="▶ Play", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm-1, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(pb, 5)
            safe_click(pb, function() sfx("click"); OUTFIT.play_emote(ename) end)
        end
    end
    OUTFIT.render_fn = ro; OUTFIT.render_emotes_fn = re
    safe_click(oscan_btn, function() sfx("click"); S.outfit_removed = {}; task.spawn(function() OUTFIT.scan(); ro(); re() end) end)
    safe_click(oexport_btn, function() OUTFIT.export() end)

    -- ===================== FRIENDS =====================
    local fpg = mkpg(false, 2); tps["friends"] = fpg
    local _, fsb = sinput(fpg, "Search friends...", 1)
    local fref = sb(fpg, "Refresh", P.raised, 1, SZ.btn_h-4, 2)
    R.fcnt = mk("TextLabel", {Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, Text="Tap to load", TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-1, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=3, Parent=fpg})
    R.fcon = mk("Frame", {Size=UDim2.new(1,0,0,10), BackgroundTransparency=1, LayoutOrder=4, Parent=fpg})
    local fll = mk("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,3), Parent=R.fcon})
    fll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() R.fcon.Size = UDim2.new(1,0,0,fll.AbsoluteContentSize.Y) end)
    local fn2 = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h-6), BackgroundTransparency=1, LayoutOrder=5, Parent=fpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=fn2})
    R.fpp = sb(fn2, "< Prev", P.raised, 0.35, SZ.btn_h-6); R.fpgl = mk("TextLabel", {Size=UDim2.new(0.3,0,0,SZ.btn_h-6), BackgroundTransparency=1, Text="1/1", TextColor3=P.txt2, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, Parent=fn2}); R.fpn = sb(fn2, "Next >", P.raised, 0.35, SZ.btn_h-6)

    local function rf(sf)
        for _, c in ipairs(R.fcon:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        if not S.friends_loaded then R.fcnt.Text = "Loading..."; return end
        local fil, s2 = {}, (sf or ""):lower()
        for _, f in ipairs(S.friends_list) do if s2 == "" or f.name:lower():find(s2,1,true) or f.display:lower():find(s2,1,true) then table.insert(fil, f) end end
        R.fcnt.Text = #fil .. " friends" .. (s2 ~= "" and " (filtered)" or "")
        local pp = 8; local mpp = math.max(1, math.ceil(#fil/pp)); S.friends_page = math.clamp(S.friends_page, 1, mpp); R.fpgl.Text = S.friends_page.."/"..mpp
        local si2 = (S.friends_page-1)*pp+1
        for idx = si2, math.min(si2+pp-1, #fil) do
            local f = fil[idx]; local ths = IS_PHONE and 32 or 38
            local row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h+14), BackgroundColor3=P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=idx, BorderSizePixel=0, Parent=R.fcon}); rnd(row, 7)
            local thf = mk("Frame", {Size=UDim2.new(0,ths,0,ths), Position=UDim2.new(0,4,0.5,-ths/2), BackgroundColor3=P.surface, BorderSizePixel=0, Parent=row}); rnd(thf, ths/2)
            mk("ImageLabel", {Size=UDim2.new(1,-2,1,-2), Position=UDim2.new(0,1,0,1), BackgroundTransparency=1, Image="rbxthumb://type=AvatarHeadShot&id="..f.id.."&w=150&h=150", ScaleType=Enum.ScaleType.Fit, Parent=thf})
            mk("Frame", {Size=UDim2.new(0,8,0,8), Position=UDim2.new(0,ths+8,0,6), BackgroundColor3=f.online and P.green or P.txt3, BorderSizePixel=0, Parent=row})
            local tx = ths + 20
            mk("TextLabel", {Size=UDim2.new(0.35,0,0,14), Position=UDim2.new(0,tx,0,3), BackgroundTransparency=1, Text=f.display, TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row})
            mk("TextLabel", {Size=UDim2.new(0.35,0,0,11), Position=UDim2.new(0,tx,0,18), BackgroundTransparency=1, Text="@"..f.name, TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row})
            local fid, fname = f.id, f.display; local bw = IS_PHONE and 26 or 32
            local bbr = mk("Frame", {Size=UDim2.new(0,bw*2+10,0,SZ.btn_h-4), Position=UDim2.new(1,-(bw*2+14),0.5,-(SZ.btn_h-4)/2), BackgroundTransparency=1, Parent=row}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,3), Parent=bbr})
            local vb = mk("TextButton", {Size=UDim2.new(0,bw+2,0,SZ.btn_h-4), BackgroundColor3=P.raised, Text="View", TextColor3=P.cyan, Font=Enum.Font.GothamBold, TextSize=IS_PHONE and 8 or 9, AutoButtonColor=false, BorderSizePixel=0, Parent=bbr}); rnd(vb, 5)
            safe_click(vb, function() PV2D.show(gui, fid, fname) end)
            local ba = mk("TextButton", {Size=UDim2.new(0,bw+2,0,SZ.btn_h-4), BackgroundColor3=P.pri, Text="Use", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=IS_PHONE and 8 or 9, AutoButtonColor=false, BorderSizePixel=0, Parent=bbr}); rnd(ba, 5)
            safe_click(ba, function() sfx("apply"); R.input.Text = tostring(fid); AV.apply(fid) end)
        end
    end
    FR.on_loaded = function() rf(fsb.Text) end
    fsb:GetPropertyChangedSignal("Text"):Connect(function() S.friends_page = 1; rf(fsb.Text) end)
    safe_click(fref, function() sfx("click"); S.friends_loaded = false; S.friends_list = {}; rf(""); FR.load() end)
    safe_click(R.fpp, function() sfx("click"); S.friends_page = math.max(1, S.friends_page-1); rf(fsb.Text) end)
    safe_click(R.fpn, function() sfx("click"); S.friends_page = S.friends_page+1; rf(fsb.Text) end)

    -- ===================== FAVS =====================
    local fvpg = mkpg(false, 2); tps["favs"] = fvpg; R.fvl = fvpg
    local function rfv()
        for _, c in ipairs(R.fvl:GetChildren()) do if (c:IsA("Frame") and c.Name ~= "UIPadding") or c:IsA("TextLabel") then c:Destroy() end end
        if #S.favs == 0 then mk("TextLabel", {Size=UDim2.new(1,0,0,60), BackgroundTransparency=1, Text="No favorites yet\nAdd with ★ button!", TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt, TextWrapped=true, Parent=R.fvl}); return end
        for idx, fav in ipairs(S.favs) do
            local row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h+8), BackgroundColor3=P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=idx, BorderSizePixel=0, Parent=R.fvl}); rnd(row, 7)
            local ths = IS_PHONE and 28 or 34
            local thf = mk("Frame", {Size=UDim2.new(0,ths,0,ths), Position=UDim2.new(0,4,0.5,-ths/2), BackgroundColor3=P.surface, BorderSizePixel=0, Parent=row}); rnd(thf, ths/2)
            mk("ImageLabel", {Size=UDim2.new(1,-2,1,-2), Position=UDim2.new(0,1,0,1), BackgroundTransparency=1, Image="rbxthumb://type=AvatarHeadShot&id="..fav.id.."&w=150&h=150", ScaleType=Enum.ScaleType.Fit, Parent=thf})
            mk("TextLabel", {Size=UDim2.new(0.3,0,0,14), Position=UDim2.new(0,ths+8,0,3), BackgroundTransparency=1, Text=fav.name, TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row})
            mk("TextLabel", {Size=UDim2.new(0.2,0,0,11), Position=UDim2.new(0,ths+8,0,18), BackgroundTransparency=1, Text="ID:"..fav.id, TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-1, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
            local fid, fname = fav.id, fav.name
            local ub = mk("TextButton", {Size=UDim2.new(0,18,0,14), Position=UDim2.new(1,-140,0.5,-16), BackgroundColor3=P.raised, Text="▲", TextColor3=P.txt2, Font=Enum.Font.GothamBold, TextSize=8, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(ub, 3)
            local db = mk("TextButton", {Size=UDim2.new(0,18,0,14), Position=UDim2.new(1,-140,0.5,2), BackgroundColor3=P.raised, Text="▼", TextColor3=P.txt2, Font=Enum.Font.GothamBold, TextSize=8, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(db, 3)
            safe_click(ub, function() sfx("click"); if FAV.move_up(fid) then rfv() end end)
            safe_click(db, function() sfx("click"); if FAV.move_down(fid) then rfv() end end)

            local vb2 = mk("TextButton", {Size=UDim2.new(0,28,0,SZ.btn_h-6), Position=UDim2.new(1,-104,0.5,-(SZ.btn_h-6)/2), BackgroundColor3=P.raised, Text="View", TextColor3=P.cyan, Font=Enum.Font.GothamBold, TextSize=8, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(vb2, 5)
            safe_click(vb2, function() PV2D.show(gui, fid, fname) end)
            local a2 = mk("TextButton", {Size=UDim2.new(0,44,0,SZ.btn_h-6), Position=UDim2.new(1,-72,0.5,-(SZ.btn_h-6)/2), BackgroundColor3=P.pri, Text="Apply", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm-1, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(a2, 5)
            safe_click(a2, function() sfx("apply"); R.input.Text = tostring(fid); stab("home"); AV.apply(fid) end)
            local xb2 = mk("TextButton", {Size=UDim2.new(0,22,0,SZ.btn_h-6), Position=UDim2.new(1,-22,0.5,-(SZ.btn_h-6)/2), BackgroundColor3=P.raised, Text="X", TextColor3=P.red, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(xb2, 5)
            safe_click(xb2, function() FAV.rem(fid); rfv() end)
        end
    end

    -- ===================== ONLINE =====================
    local onpg = mkpg(false, 2); tps["online"] = onpg
    local on_hdr = mk("Frame", {Size=UDim2.new(1,0,0,62), BackgroundColor3=P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=1, BorderSizePixel=0, Parent=onpg}); rnd(on_hdr, 8); bdr(on_hdr, P.blue, 1)
    mk("TextLabel", {Size=UDim2.new(0.6,0,0,18), Position=UDim2.new(0,10,0,5), BackgroundTransparency=1, Text="NEXUS ONLINE", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm+1, TextXAlignment=Enum.TextXAlignment.Left, Parent=on_hdr})
    R.on_count = mk("TextLabel", {Size=UDim2.new(1,-20,0,14), Position=UDim2.new(0,10,0,26), BackgroundTransparency=1, Text="0 users online", TextColor3=P.blue, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, Parent=on_hdr})
    R.on_status = mk("TextLabel", {Size=UDim2.new(1,-20,0,12), Position=UDim2.new(0,10,0,42), BackgroundTransparency=1, Text=S.online_visible and "Status: Online ●" or "Status: Offline ○", TextColor3=S.online_visible and P.green or P.red, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-1, TextXAlignment=Enum.TextXAlignment.Left, Parent=on_hdr})
    stog(onpg, "Show me online", S.online_visible, function(v) ON.set_visible(v); R.on_status.Text = v and "Status: Online ●" or "Status: Offline ○"; R.on_status.TextColor3 = v and P.green or P.red end, 2)
    local onr = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=3, Parent=onpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=onr})
    local on_ref = sb(onr, "Refresh Users", P.pri, 0.5, SZ.btn_h); local on_ref_ch = sb(onr, "Refresh Chat", P.raised, 0.5, SZ.btn_h)
    if IS_OWNER then
        sec(onpg, "OWNER TOOLS", 4)
        local ot_row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=5, Parent=onpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=ot_row})
        local ot_clear = sb(ot_row, "Clear Chat", P.red, 0.5, SZ.btn_h)
        safe_click(ot_clear, function() sfx("click"); CH.clear_all(); NF.push("Chat cleared", "owner", 2); if CH.refresh_fn then CH.refresh_fn() end end)
        local _, ot_ban_input = sinput(onpg, "UserID to ban/timeout...", 6)
        local ot_act = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=7, Parent=onpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=ot_act})
        local ot_ban = sb(ot_act, "Ban", P.red, 0.33); local ot_to = sb(ot_act, "Timeout", P.orange, 0.34); local ot_ub = sb(ot_act, "Unban", P.green, 0.33)
        safe_click(ot_ban, function() sfx("click"); local uid = tonumber(ot_ban_input.Text); if not uid then NF.push("Enter valid UID","err"); return end; BAN.ban_user(uid, getname(uid)); NF.push("Banned: "..getname(uid),"owner",3) end)
        safe_click(ot_to, function() sfx("click"); local uid = tonumber(ot_ban_input.Text); if not uid then NF.push("Enter valid UID","err"); return end; BAN.timeout_user(uid, getname(uid), 10); NF.push("Timeout 10m","owner",3) end)
        safe_click(ot_ub, function() sfx("click"); local uid = tonumber(ot_ban_input.Text); if not uid then return end; BAN.unban_user(uid); NF.push("Unbanned","owner",3) end)
    end
    sec(onpg, "ACTIVE USERS", IS_OWNER and 8 or 4)
    R.on_con = mk("Frame", {Size=UDim2.new(1,0,0,10), BackgroundTransparency=1, LayoutOrder=IS_OWNER and 9 or 5, Parent=onpg})
    local on_ll = mk("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4), Parent=R.on_con})
    on_ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() R.on_con.Size = UDim2.new(1,0,0,on_ll.AbsoluteContentSize.Y) end)
    sec(onpg, "TODAY'S CHAT", IS_OWNER and 10 or 6)
    local ch_row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=IS_OWNER and 11 or 7, Parent=onpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=ch_row})
    local ch_wrap = mk("Frame", {Size=UDim2.new(1,-(SZ.btn_h+8),0,SZ.btn_h), BackgroundColor3=P.input_bg, BorderSizePixel=0, Parent=ch_row}); rnd(ch_wrap, 7); bdr(ch_wrap, P.outline)
    R.chat_input = mk("TextBox", {Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,5,0,0), BackgroundTransparency=1, Text="", PlaceholderText="Type a message...", PlaceholderColor3=P.txt3, TextColor3=P.txt, Font=Enum.Font.GothamMedium, TextSize=SZ.txt, TextXAlignment=Enum.TextXAlignment.Left, ClearTextOnFocus=false, Parent=ch_wrap})
    local ch_send = mk("TextButton", {Size=UDim2.new(0,SZ.btn_h+4,0,SZ.btn_h), BackgroundColor3=P.pri, Text="→", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=16, AutoButtonColor=false, BorderSizePixel=0, Parent=ch_row}); rnd(ch_send, 7)
    R.chat_con = mk("Frame", {Size=UDim2.new(1,0,0,10), BackgroundTransparency=1, LayoutOrder=IS_OWNER and 12 or 8, Parent=onpg})
    local ch_ll = mk("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,3), Parent=R.chat_con})
    ch_ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() R.chat_con.Size = UDim2.new(1,0,0,ch_ll.AbsoluteContentSize.Y) end)

    local function render_online()
        for _, c in ipairs(R.on_con:GetChildren()) do if c:IsA("Frame") and c.Name ~= "" then c:Destroy() end end
        R.on_count.Text = #S.online_users .. " users online"
        if #S.online_users == 0 then mk("TextLabel", {Name="empty_on", Size=UDim2.new(1,0,0,50), BackgroundTransparency=1, Text="No one online yet", TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt, TextWrapped=true, Parent=R.on_con}); return end
        local ths = IS_PHONE and 36 or 42
        for idx, user in ipairs(S.online_users) do
            local is_me = user.userId == lp.UserId; local is_own = user.name == OWNER_NAME
            local row = mk("Frame", {Name="U"..idx, Size=UDim2.new(1,0,0,ths+12), BackgroundColor3=is_me and Color3.fromRGB(28,38,28) or P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=idx, BorderSizePixel=0, Parent=R.on_con}); rnd(row, 8)
            if is_me then bdr(row, P.green, 1) elseif is_own then bdr(row, P.owner, 1) end
            local avf = mk("Frame", {Size=UDim2.new(0,ths,0,ths), Position=UDim2.new(0,4,0.5,-ths/2), BackgroundColor3=P.surface, BorderSizePixel=0, Parent=row}); rnd(avf, ths/2)
            mk("ImageLabel", {Size=UDim2.new(1,-2,1,-2), Position=UDim2.new(0,1,0,1), BackgroundTransparency=1, Image="rbxthumb://type=AvatarHeadShot&id="..user.userId.."&w=150&h=150", ScaleType=Enum.ScaleType.Fit, Parent=avf})
            local tx = ths + 10; local nm_txt = user.displayName
            if is_me then nm_txt = nm_txt .. " (You)" end; if is_own then nm_txt = nm_txt .. " ★" end
            mk("TextLabel", {Size=UDim2.new(0.5,0,0,14), Position=UDim2.new(0,tx,0,3), BackgroundTransparency=1, Text=nm_txt, TextColor3=is_own and P.owner or (is_me and P.green or P.txt), Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row})
            mk("TextLabel", {Size=UDim2.new(0.5,0,0,11), Position=UDim2.new(0,tx,0,18), BackgroundTransparency=1, Text="@"..user.name, TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
            local gn = user.gameName ~= "" and user.gameName or "Place:"..user.gameId; if #gn > 18 then gn = gn:sub(1,18).."..." end
            mk("TextLabel", {Size=UDim2.new(0.5,0,0,11), Position=UDim2.new(0,tx,0,30), BackgroundTransparency=1, Text=gn.." - "..format_time(user.timestamp), TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row})
            if not is_me then
                local bw3 = IS_PHONE and 26 or 32
                local bbr2 = mk("Frame", {Size=UDim2.new(0,bw3*2+6,0,SZ.btn_h-6), Position=UDim2.new(1,-(bw3*2+10),0.5,-(SZ.btn_h-6)/2), BackgroundTransparency=1, Parent=row}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,3), Parent=bbr2})
                local vb3 = mk("TextButton", {Size=UDim2.new(0,bw3,0,SZ.btn_h-6), BackgroundColor3=P.raised, Text="View", TextColor3=P.cyan, Font=Enum.Font.GothamBold, TextSize=IS_PHONE and 8 or 9, AutoButtonColor=false, BorderSizePixel=0, Parent=bbr2}); rnd(vb3, 5)
                safe_click(vb3, function() PV2D.show(gui, user.userId, user.displayName) end)
                local ab3 = mk("TextButton", {Size=UDim2.new(0,bw3,0,SZ.btn_h-6), BackgroundColor3=P.pri, Text="Use", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=IS_PHONE and 8 or 9, AutoButtonColor=false, BorderSizePixel=0, Parent=bbr2}); rnd(ab3, 5)
                safe_click(ab3, function() sfx("apply"); R.input.Text = tostring(user.userId); AV.apply(user.userId) end)
            end
        end
    end
    ON.refresh_fn = render_online

    local function render_chat()
        for _, c in ipairs(R.chat_con:GetChildren()) do if c:IsA("Frame") and c.Name ~= "" then c:Destroy() end end
        if #S.chat_messages == 0 then mk("TextLabel", {Name="empty_ch", Size=UDim2.new(1,0,0,40), BackgroundTransparency=1, Text="No messages today. Say hello!", TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt, TextWrapped=true, Parent=R.chat_con}); return end
        local si = math.max(1, #S.chat_messages - 49)
        for idx = si, #S.chat_messages do
            local msg = S.chat_messages[idx]; local is_me = msg.senderId == lp.UserId; local is_own = msg.senderName == OWNER_NAME
            local row = mk("Frame", {Name="M"..idx, Size=UDim2.new(1,0,0,0), BackgroundColor3=is_me and Color3.fromRGB(30,28,50) or P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=idx, BorderSizePixel=0, ClipsDescendants=true, AutomaticSize=Enum.AutomaticSize.Y, Parent=R.chat_con}); rnd(row, 7)
            if is_me then bdr(row, P.pri, 0.5) end
            mk("UIPadding", {PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), PaddingTop=UDim.new(0,5), PaddingBottom=UDim.new(0,5), Parent=row})
            mk("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2), Parent=row})
            local hdr3 = mk("Frame", {Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, LayoutOrder=1, Parent=row})
            local sender_txt = is_me and "You" or msg.sender; if is_own then sender_txt = sender_txt .. " ★" end
            mk("TextLabel", {Size=UDim2.new(0.6,0,1,0), BackgroundTransparency=1, Text=sender_txt, TextColor3=is_own and P.owner or (is_me and P.pri_lit or P.blue), Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm-1, TextXAlignment=Enum.TextXAlignment.Left, Parent=hdr3})
            mk("TextLabel", {Size=UDim2.new(0.4,0,1,0), Position=UDim2.new(0.6,0,0,0), BackgroundTransparency=1, Text=format_time(msg.timestamp), TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, TextXAlignment=Enum.TextXAlignment.Right, Parent=hdr3})
            mk("TextLabel", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, Text=msg.message, TextColor3=P.txt, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y, LayoutOrder=2, Parent=row})
            if IS_OWNER and not is_me then
                local del = mk("TextButton", {Size=UDim2.new(0,30,0,14), BackgroundColor3=P.red, BackgroundTransparency=0.5, Text="Del", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=7, AutoButtonColor=false, BorderSizePixel=0, LayoutOrder=3, Parent=row}); rnd(del, 4)
                local mid = msg.id; safe_click(del, function() sfx("click"); CH.delete_msg(mid); task.delay(0.3, function() CH.fetch(); render_chat() end) end)
            end
        end
    end
    CH.refresh_fn = render_chat

    local function send_chat()
        local txt = R.chat_input.Text; if txt == "" then return end
        if not S.online_visible then NF.push("Go online first!", "warn"); return end
        R.chat_input.Text = ""; sfx("msg_send") -- [NEW] ★ send sound
        task.spawn(function() if CH.send(txt) then task.wait(0.5); CH.fetch(); render_chat() end end)
    end
    safe_click(ch_send, send_chat)
    R.chat_input.FocusLost:Connect(function(enter) if enter then send_chat() end end)
    safe_click(on_ref, function() sfx("click"); task.spawn(function() ON.fetch_users(); render_online() end) end)
    safe_click(on_ref_ch, function() sfx("click"); task.spawn(function() CH.fetch(); render_chat() end) end)

    -- ===================== TOOLS TAB =====================
    local tlpg = mkpg(false, 2); tps["tools"] = tlpg

    sec(tlpg, "TELEPORT", 1)
    local _, tp_box = sinput(tlpg, "Player name to TP...", 2)
    local tp_btn = sb(tlpg, "⚡ Teleport to Player", P.pri, 1, SZ.btn_h, 3)
    safe_click(tp_btn, function() if tp_box.Text ~= "" then TP.to_player(tp_box.Text) end end)

    sec(tlpg, "WAYPOINTS", 4)
    local _, wp_name_box = sinput(tlpg, "Waypoint name...", 5)
    local wp_save_btn = sb(tlpg, "📍 Save Current Position", P.green, 1, SZ.btn_h, 6)
    R.wp_con = mk("Frame", {Size=UDim2.new(1,0,0,10), BackgroundTransparency=1, LayoutOrder=7, Parent=tlpg})
    local wp_ll = mk("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,3), Parent=R.wp_con})
    wp_ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() R.wp_con.Size = UDim2.new(1,0,0,wp_ll.AbsoluteContentSize.Y) end)

    local function render_waypoints()
        for _, c in ipairs(R.wp_con:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        if #S.tp_waypoints == 0 then mk("TextLabel", {Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, Text="No waypoints", TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt, LayoutOrder=1, Parent=R.wp_con}); return end
        for idx, wp in ipairs(S.tp_waypoints) do
            local row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundColor3=P.card, LayoutOrder=idx, BorderSizePixel=0, Parent=R.wp_con}); rnd(row, 6)
            mk("TextLabel", {Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0,8,0,0), BackgroundTransparency=1, Text="📍 "..wp.name, TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
            local go_btn = mk("TextButton", {Size=UDim2.new(0,40,0,SZ.btn_h-8), Position=UDim2.new(1,-88,0.5,-(SZ.btn_h-8)/2), BackgroundColor3=P.pri, Text="Go", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(go_btn, 5)
            local del_btn = mk("TextButton", {Size=UDim2.new(0,28,0,SZ.btn_h-8), Position=UDim2.new(1,-40,0.5,-(SZ.btn_h-8)/2), BackgroundColor3=P.red, Text="X", TextColor3=P.txt, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, AutoButtonColor=false, BorderSizePixel=0, Parent=row}); rnd(del_btn, 5)
            local i = idx
            safe_click(go_btn, function() TP.goto_waypoint(i) end)
            safe_click(del_btn, function() TP.delete_waypoint(i); render_waypoints() end)
        end
    end
    safe_click(wp_save_btn, function() TP.save_waypoint(wp_name_box.Text ~= "" and wp_name_box.Text or nil); wp_name_box.Text = ""; render_waypoints() end)
    render_waypoints()

    sec(tlpg, "ESP / HIGHLIGHT", 8)
    stog(tlpg, "ESP (See All Players)", S.esp_on, function(v) if v then ESP.enable() else ESP.disable(); NF.push("ESP Disabled", "ok", 2) end end, 9)

    sec(tlpg, "MIRROR MODE", 10)
    local mirror_btn = sb(tlpg, "🪞 Mirror My Avatar to All", P.cyan, 1, SZ.btn_h, 11)
    local mirror_off_btn = sb(tlpg, "Reset All Players", P.raised, 1, SZ.btn_h, 12)
    safe_click(mirror_btn, function() sfx("click"); MIRROR.enable() end)
    safe_click(mirror_off_btn, function() sfx("click"); MIRROR.disable() end)

    sec(tlpg, "GRAVITY", 13)
    sslider(tlpg, "Gravity", 0, 500, workspace.Gravity, function(v) MODS.set_gravity(v) end, 14, "%.0f")

    sec(tlpg, "UTILITIES", 15)
    stog(tlpg, "Anti-AFK", S.anti_afk, function(v) S.anti_afk = v; save(); if v then ANTI_AFK.start() else ANTI_AFK.stop() end end, 16)

    local copy_id_btn = sb(tlpg, "📋 Copy Current Avatar ID", P.raised, 1, SZ.btn_h, 17)
    safe_click(copy_id_btn, function()
        if not S.cur_id then sfx("error"); NF.push("No avatar applied!", "warn"); return end
        if setclipboard then setclipboard(tostring(S.cur_id)); sfx("copy"); NF.push("Copied ID: " .. S.cur_id, "ok", 2)
        else sfx("error"); NF.push("Clipboard not available", "err") end
    end)

    local info_btn = sb(tlpg, "📊 Server Info", P.raised, 1, SZ.btn_h, 18)
    safe_click(info_btn, function()
        sfx("click")
        local players_count = #plrs:GetPlayers()
        local max_players = plrs.MaxPlayers
        local place_name = "Unknown"
        pcall(function() place_name = mps:GetProductInfo(game.PlaceId).Name end)
        local fps = math.floor(1 / rs.RenderStepped:Wait())
        NF.push(place_name .. " | " .. players_count .. "/" .. max_players .. " | FPS:" .. fps, "stat", 5)
    end)

    local rejoin_btn = sb(tlpg, "🔄 Rejoin Server", P.orange, 1, SZ.btn_h, 19)
    safe_click(rejoin_btn, function()
        sfx("teleport")
        NF.push("Rejoining...", "info", 2)
        ON.go_offline()
        task.delay(0.5, function()
            pcall(function() tp_svc:TeleportToPlaceInstance(game.PlaceId, game.JobId) end)
        end)
    end)

    local hop_btn = sb(tlpg, "🌐 Server Hop (New Server)", P.raised, 1, SZ.btn_h, 20)
    safe_click(hop_btn, function()
        sfx("teleport")
        NF.push("Hopping to new server...", "info", 2)
        ON.go_offline()
        task.delay(0.5, function()
            pcall(function() tp_svc:Teleport(game.PlaceId) end)
        end)
    end)

    -- ===================== CLIENT =====================
    local cpg = mkpg(false, 2); tps["client"] = cpg
    sec(cpg, "APPLY TO OTHERS", 1); local _, cpb = sinput(cpg, "Player name...", 2); local _, cab = sinput(cpg, "Avatar ID...", 3)
    local cr = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=4, Parent=cpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=cr})
    local ca = sb(cr, "Apply", P.pri, 0.33); local crs = sb(cr, "Reset", P.raised, 0.33); local cal = sb(cr, "Apply All", P.raised, 0.34)
    sec(cpg, "COPY PLAYER", 5); local _, cbox = sinput(cpg, "Player to copy...", 6); local cbtn = sb(cpg, "📥 Copy Player Avatar", P.pri, 1, SZ.btn_h, 7)
    sec(cpg, "TAP MODE", 8)
    local _,_,tc_set = stog(cpg, "Tap to Copy ID", S.tap_copy_on, function(v) if v then CONFLICT.activate("tap_copy_on"); TC.on_tap = function(p2) R.input.Text = tostring(p2.UserId); cab.Text = tostring(p2.UserId); cpb.Text = p2.Name end; TC.enable() else S.tap_copy_on = false; TC.disable(); save() end end, 9)
    CONFLICT.disable_fns["tap_copy_on"] = function() TC.disable(); tc_set(false) end

    sec(cpg, "NAME SPOOF", 10); local _, ntb = sinput(cpg, "Target ('me')...", 11); local _, nnb = sinput(cpg, "New name...", 12)
    local nr = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=13, Parent=cpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=nr})
    local nsa = sb(nr, "Set Name", P.pri, 0.5); local nsc = sb(nr, "Clear", P.raised, 0.5)
    sec(cpg, "FULL CLONE", 14); local _, clb = sinput(cpg, "Player to clone...", 15); local clbtn = sb(cpg, "👤 Clone Avatar & Name", P.pri, 1, SZ.btn_h, 16)

    sec(cpg, "MASS ACTIONS", 17)
    local mass_row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=18, Parent=cpg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=mass_row})
    local mass_bacon = sb(mass_row, "All→Bacon", P.raised, 0.33)
    local mass_noob = sb(mass_row, "All→Noob", P.raised, 0.33)
    local mass_reset = sb(mass_row, "Reset All", P.red, 0.34)
    safe_click(mass_bacon, function() sfx("apply"); AV.apply_to_all(289438135) end)
    safe_click(mass_noob, function() sfx("apply"); AV.apply_to_all(5254879171) end)
    safe_click(mass_reset, function()
        sfx("reset")
        local count = 0
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and S.player_orig_descs[p.UserId] then
                AV.reset_other(p); count = count + 1
            end
        end
        NF.push("Reset " .. count .. " players", "ok", 2)
    end)

    -- ===================== MODS =====================
    local mpg = mkpg(false, 2); tps["mods"] = mpg
    sec(mpg, "BODY SCALE", 1)
    stog(mpg, "Width", S.scale_w_on, function(v) S.scale_w_on = v; save(); if S.cur_id then AV.apply_scales(lp.Character) end end, 2)
    sslider(mpg, "Width", 0.5, 2, S.scale_w, function(v) S.scale_w = v; if S.scale_w_on then AV.apply_scales(lp.Character) end end, 3, "%.1fx")
    stog(mpg, "Height", S.scale_h_on, function(v) S.scale_h_on = v; save(); if S.cur_id then AV.apply_scales(lp.Character) end end, 4)
    sslider(mpg, "Height", 0.5, 2, S.scale_h, function(v) S.scale_h = v; if S.scale_h_on then AV.apply_scales(lp.Character) end end, 5, "%.1fx")
    stog(mpg, "Head", S.scale_head_on, function(v) S.scale_head_on = v; save(); if S.cur_id then AV.apply_scales(lp.Character) end end, 6)
    sslider(mpg, "Head", 0.5, 3, S.scale_head, function(v) S.scale_head = v; if S.scale_head_on then AV.apply_scales(lp.Character) end end, 7, "%.1fx")
    sec(mpg, "CHARACTER", 8)
    stog(mpg, "Speed", S.speed_on, function(v) S.speed_on = v; save(); MODS.set_speed(v and S.speed_val or 16) end, 9)
    sslider(mpg, "Speed", 16, 200, S.speed_val, function(v) S.speed_val = v; if S.speed_on then MODS.set_speed(v) end end, 10)
    stog(mpg, "Jump", S.jump_on, function(v) S.jump_on = v; save(); MODS.set_jump(v and S.jump_val or 50) end, 11)
    sslider(mpg, "Jump", 50, 300, S.jump_val, function(v) S.jump_val = v; if S.jump_on then MODS.set_jump(v) end end, 12)
    stog(mpg, "Noclip", S.noclip_on, function(v) S.noclip_on = v; MODS.noclip(v) end, 13)
    stog(mpg, "Inf Jump", S.inf_jump_on, function(v) S.inf_jump_on = v; MODS.inf_jump(v) end, 14)
    stog(mpg, "Fly (WASD+Space/Shift)", S.fly_on, function(v) S.fly_on = v; MODS.fly(v) end, 15)

    sec(mpg, "FLY SETTINGS", 16)
    local fly_speed = 80
    sslider(mpg, "Fly Speed", 20, 300, fly_speed, function(v) fly_speed = v end, 17)

    sec(mpg, "CHARACTER LOOK", 18)
    sslider(mpg, "Body Transparency", 0, 100, 0, function(v)
        local char = lp.Character; if not char then return end
        local trans = v / 100
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                pcall(function() part.Transparency = trans end)
            end
        end
    end, 19, "%.0f%%")

    sec(mpg, "CAMERA", 20)
    sslider(mpg, "Field of View", 30, 120, workspace.CurrentCamera.FieldOfView, function(v)
        pcall(function() workspace.CurrentCamera.FieldOfView = v end)
    end, 21, "%.0f°")

    -- ===================== CONFIG =====================
    local cfg = mkpg(false, 2); tps["cfg"] = cfg
    sec(cfg, "UI SIZE", 1)
    local srow = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=2, Parent=cfg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=srow})
    for _, sn in ipairs({"small","medium","large"}) do
        local s3 = sb(srow, sn:sub(1,1):upper()..sn:sub(2), sn==S.ui_size and P.pri or P.raised, 0.33)
        safe_click(s3, function() sfx("click"); S.ui_size = sn; save(); NF.push("Reloading UI...", "ok", 1); task.delay(0.3, function() UI.kill(); UI.build() end) end)
    end

    sec(cfg, "THEME", 3)
    local tg = mk("Frame", {Size=UDim2.new(1,0,0,math.ceil(#THEMES/4)*(SZ.btn_h-4)), BackgroundTransparency=1, LayoutOrder=4, Parent=cfg}); mk("UIGridLayout", {CellSize=UDim2.new(0.25,-3,0,SZ.btn_h-8), CellPadding=UDim2.new(0,3,0,3), Parent=tg})
    for idx, th in ipairs(THEMES) do
        local tb = mk("TextButton", {BackgroundColor3=th.pri, Text=th.name, TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm-1, AutoButtonColor=false, BorderSizePixel=0, Parent=tg}); rnd(tb, 5)
        if idx == S.theme_idx then bdr(tb, Color3.new(1,1,1), 2) end
        safe_click(tb, function()
            sfx("click")
            S.theme_idx = idx; apply_theme()
            R.main_stroke.Color = P.pri
            for k, btn in pairs(tbs) do if k == S.tab then tw(btn, {BackgroundColor3 = P.pri}, 0.2) end end
            save(); NF.push("Theme: "..th.name, "ok", 2)
            for _, c in ipairs(tg:GetChildren()) do if c:IsA("TextButton") then local s4 = c:FindFirstChildOfClass("UIStroke"); if s4 then s4:Destroy() end end end
            bdr(tb, Color3.new(1,1,1), 2)
        end)
    end

    sec(cfg, "APPEARANCE", 5)
    stog(cfg, "Dark Mode", S.dark_mode, function(v)
        S.dark_mode = v; save()
        NF.push("Reloading for " .. (v and "Dark" or "Light") .. " mode...", "ok", 1)
        task.delay(0.3, function() UI.kill(); UI.build() end)
    end, 6)

    sec(cfg, "GUI TRANSPARENCY", 7)
    sslider(cfg, "Transparency", 0, 80, S.gui_transparency * 100, function(v)
        S.gui_transparency = v / 100
        win.BackgroundTransparency = v / 100
    end, 8, "%.0f%%")

    sec(cfg, "GENERAL", 9)
    stog(cfg, "Sound Effects", S.sfx, function(v) S.sfx = v; save() end, 10)
    stog(cfg, "Notifications", S.notif_on, function(v) S.notif_on = v; save() end, 11)

    -- ═══════════════════════════════════════════════════════
    -- [NEW] ★ KEYBIND SECTION — แยก Toggle Key กับ Quick Apply Key
    -- ═══════════════════════════════════════════════════════
    sec(cfg, "KEYBINDS", 12)

    -- Toggle UI keybind
    local kbr = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundColor3=P.card, LayoutOrder=13, BorderSizePixel=0, Parent=cfg}); rnd(kbr, 7)
    mk("TextLabel", {Size=UDim2.new(0.4,0,1,0), Position=UDim2.new(0,8,0,0), BackgroundTransparency=1, Text="Toggle UI Key", TextColor3=P.txt, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, Parent=kbr})
    R.kbl = mk("TextLabel", {Size=UDim2.new(0.25,0,1,0), Position=UDim2.new(0.4,0,0,0), BackgroundTransparency=1, Text=S.keybind.Name, TextColor3=P.pri_lit, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, Parent=kbr})
    local kbt = sb(kbr, "Set", P.raised, nil, SZ.btn_h-8)
    kbt.Size = UDim2.new(0,40,0,SZ.btn_h-8); kbt.Position = UDim2.new(1,-48,0.5,-(SZ.btn_h-8)/2)
    local kbl = false
    safe_click(kbt, function()
        if kbl then return end; kbl = true; R.kbl.Text = "..."; kbt.Text = "..."
        sfx("click")
        local kbc; kbc = uis.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                S.keybind = inp.KeyCode; R.kbl.Text = inp.KeyCode.Name
                kbt.Text = "Set"; kbl = false; kbc:Disconnect(); save()
                sfx("success")
            end
        end)
        task.delay(5, function()
            if kbl then kbl = false; R.kbl.Text = S.keybind.Name; kbt.Text = "Set"; pcall(function() kbc:Disconnect() end) end
        end)
    end)

    -- [NEW] ★ Quick Apply keybind — เปลี่ยน key สำหรับ QA ได้
    local qa_kbr = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundColor3=P.card, LayoutOrder=14, BorderSizePixel=0, Parent=cfg}); rnd(qa_kbr, 7)
    mk("TextLabel", {Size=UDim2.new(0.4,0,1,0), Position=UDim2.new(0,8,0,0), BackgroundTransparency=1, Text="Quick Apply Key", TextColor3=P.txt, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm, TextXAlignment=Enum.TextXAlignment.Left, Parent=qa_kbr})
    R.qa_kbl = mk("TextLabel", {Size=UDim2.new(0.25,0,1,0), Position=UDim2.new(0.4,0,0,0), BackgroundTransparency=1, Text=S.qa_keybind.Name, TextColor3=P.yellow, Font=Enum.Font.GothamBold, TextSize=SZ.txt_sm, Parent=qa_kbr})
    local qa_kbt = sb(qa_kbr, "Set", P.raised, nil, SZ.btn_h-8)
    qa_kbt.Size = UDim2.new(0,40,0,SZ.btn_h-8); qa_kbt.Position = UDim2.new(1,-48,0.5,-(SZ.btn_h-8)/2)
    local qa_kbl_setting = false
    safe_click(qa_kbt, function()
        if qa_kbl_setting then return end; qa_kbl_setting = true; R.qa_kbl.Text = "..."; qa_kbt.Text = "..."
        sfx("click")
        local qa_kbc; qa_kbc = uis.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                S.qa_keybind = inp.KeyCode; R.qa_kbl.Text = inp.KeyCode.Name
                qa_kbt.Text = "Set"; qa_kbl_setting = false; qa_kbc:Disconnect(); save()
                sfx("success")
                NF.push("Quick Apply key: " .. inp.KeyCode.Name, "qa", 2)
                -- Restart QA ถ้าเปิดอยู่
                if S.quick_apply_on then QA.disable(); QA.enable() end
            end
        end)
        task.delay(5, function()
            if qa_kbl_setting then qa_kbl_setting = false; R.qa_kbl.Text = S.qa_keybind.Name; qa_kbt.Text = "Set"; pcall(function() qa_kbc:Disconnect() end) end
        end)
    end)

    -- Quick Apply hint text
    mk("TextLabel", {Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, RichText=true, Text='<font color="#FEB131">Quick Apply:</font> Point cursor at player → press key to morph instantly!', TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, TextWrapped=true, LayoutOrder=15, Parent=cfg})

    sec(cfg, "DATA", 16)
    local data_row = mk("Frame", {Size=UDim2.new(1,0,0,SZ.btn_h), BackgroundTransparency=1, LayoutOrder=17, Parent=cfg}); mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), Parent=data_row})
    local export_all = sb(data_row, "📤 Export Data", P.raised, 0.5)
    local clear_cache = sb(data_row, "🗑 Clear Cache", P.red, 0.5)
    safe_click(export_all, function()
        sfx("export")
        if setclipboard then
            local data = http:JSONEncode({favs=S.favs, theme=S.theme_idx, total_morphs=S.total_morphs, waypoints=S.tp_waypoints})
            setclipboard(data)
            NF.push("Settings exported to clipboard!", "ok", 3)
        else
            NF.push("Clipboard not available", "err")
        end
    end)
    safe_click(clear_cache, function()
        sfx("click")
        S.cache = {}; S.name_cache = {}; OUTFIT.price_cache = {}
        NF.push("Cache cleared! 🗑", "ok", 2)
    end)

    sec(cfg, "STATISTICS", 18)
    local stats_card = mk("Frame", {Size=UDim2.new(1,0,0,80), BackgroundColor3=P.card, BackgroundTransparency=S.gui_transparency*0.3, LayoutOrder=19, BorderSizePixel=0, Parent=cfg}); rnd(stats_card, 8)
    local stats_txt = mk("TextLabel", {Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0), BackgroundTransparency=1, TextColor3=P.txt2, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-1, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=stats_card})
    stats_txt.Text = "Total Morphs: " .. S.total_morphs
        .. "\nFavorites: " .. #S.favs
        .. "\nPresets: " .. #PRESETS
        .. "\nThemes: " .. #THEMES
        .. "\nTracks: " .. #TRACKS
        .. "\nWaypoints: " .. #S.tp_waypoints

    mk("TextLabel", {Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, RichText=true, Text='<font color="#6C5CE7">Nexus Avatar Engine</font> <font color="#9B98B2">v5.0.1 "Phoenix"</font>', TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm, LayoutOrder=20, Parent=cfg})
    mk("TextLabel", {Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, Text="by " .. OWNER_NAME, TextColor3=P.txt3, Font=Enum.Font.GothamMedium, TextSize=SZ.txt_sm-2, LayoutOrder=21, Parent=cfg})

    -- ═══════════════════════════════════════
    -- WIRE EVERYTHING
    -- ═══════════════════════════════════════
    AV.on_change = function(id)
        if id then
            R.stat_name.Text = getname(id); R.stat_name.TextColor3 = P.pri_lit
            R.stat_id.Text = "ID: " .. id
            R.fav_btn.Text = FAV.has(id) and "★" or "+"; R.fav_btn.TextColor3 = FAV.has(id) and P.yellow or P.txt2
            R.status_dot.BackgroundColor3 = P.green
            R.stat_thumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. id .. "&w=150&h=150"
            R.stat_thumb.BackgroundTransparency = 0
            R.morph_count.Text = "#" .. S.total_morphs
        else
            R.stat_name.Text = "-- No avatar --"; R.stat_name.TextColor3 = P.txt3
            R.stat_id.Text = ""; R.fav_btn.Text = "+"; R.fav_btn.TextColor3 = P.txt2
            R.status_dot.BackgroundColor3 = P.txt3
            R.stat_thumb.Image = ""; R.stat_thumb.BackgroundTransparency = 1
        end
        R.stat_hist.Text = "Hist:" .. #S.hist
        R.stat_total.Text = "Morphs: " .. S.total_morphs
    end

    -- [NEW] ★ ปุ่มหลักเล่นเสียงเฉพาะ action
    safe_click(R.apply_btn, function()
        if R.input.Text == "" then sfx("error"); NF.push("Enter username or ID", "warn"); return end
        sfx("apply"); AV.apply(R.input.Text)
    end)
    safe_click(R.random_btn, function() local id = AV.random(); if id then R.input.Text = tostring(id) end end) -- random มีเสียงใน AV.random()
    safe_click(R.reset_btn, function() sfx("reset"); AV.reset() end)
    safe_click(R.undo_btn, function() AV.undo() end) -- undo/redo มีเสียงใน function
    safe_click(R.redo_btn, function() AV.redo() end)
    safe_click(R.fav_btn, function()
        if not S.cur_id then sfx("error"); NF.push("Apply avatar first!", "warn"); return end
        FAV.toggle(S.cur_id)
        R.fav_btn.Text = FAV.has(S.cur_id) and "★" or "+"
        R.fav_btn.TextColor3 = FAV.has(S.cur_id) and P.yellow or P.txt2
        rfv()
    end)
    R.input.FocusLost:Connect(function(enter) if enter and R.input.Text ~= "" then sfx("apply"); AV.apply(R.input.Text) end end)

    -- Preset nav
    safe_click(R.pprev, function() sfx("click"); S.preset_page = S.preset_page - 1; if S.preset_page < 1 then S.preset_page = math.ceil(#get_filtered_presets()/8) end; rp() end)
    safe_click(R.pnext, function() sfx("click"); S.preset_page = S.preset_page + 1; if S.preset_page > math.ceil(#get_filtered_presets()/8) then S.preset_page = 1 end; rp() end)
    safe_click(R.prand, function() sfx("random"); local fp = get_filtered_presets(); S.preset_page = math.random(1, math.max(1, math.ceil(#fp/8))); rp() end)

    -- Music — แต่ละปุ่มเสียงต่างกัน
    safe_click(R.mprev, function() sfx("music_prev"); MU.prev(); R.mus_name.Text = "♪ "..TRACKS[S.music_idx].n; R.mplay.Text = S.music_playing and "||" or "▶" end)
    safe_click(R.mplay, function() sfx("music_play"); MU.toggle(); R.mplay.Text = S.music_playing and "||" or "▶"; tw(R.mplay, {BackgroundColor3 = S.music_playing and P.green or P.pri}, 0.15) end)
    safe_click(R.mnext, function() sfx("music_next"); MU.next(); R.mus_name.Text = "♪ "..TRACKS[S.music_idx].n; R.mplay.Text = S.music_playing and "||" or "▶" end)
    safe_click(R.mloop, function() sfx("click"); S.music_loop = not S.music_loop; if S.music_obj then S.music_obj.Looped = S.music_loop end; R.mloop.Text = S.music_loop and "Loop" or "Once"; tw(R.mloop, {BackgroundColor3 = S.music_loop and P.pri or P.raised}, 0.15); save() end)
    safe_click(R.mstop, function() sfx("music_stop"); MU.stop(); R.mplay.Text = "▶"; tw(R.mplay, {BackgroundColor3 = P.pri}, 0.15) end)

    -- Client wiring
    safe_click(ca, function()
        sfx("click")
        if cpb.Text == "" or cab.Text == "" then NF.push("Fill both fields!", "warn"); return end
        local found
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and (p.Name:lower():find(cpb.Text:lower(),1,true) or p.DisplayName:lower():find(cpb.Text:lower(),1,true)) then found = p; break end
        end
        if not found then sfx("error"); NF.push("Player not found", "err"); return end
        if AV.apply_to_other(found, cab.Text) then sfx("success"); NF.push("Applied to " .. found.Name .. "!", "ok") end
    end)
    safe_click(crs, function()
        sfx("click")
        if cpb.Text == "" then NF.push("Enter player name", "warn"); return end
        local found
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and (p.Name:lower():find(cpb.Text:lower(),1,true) or p.DisplayName:lower():find(cpb.Text:lower(),1,true)) then found = p; break end
        end
        if not found then sfx("error"); NF.push("Player not found", "err"); return end
        AV.reset_other(found)
    end)
    safe_click(cal, function()
        sfx("apply")
        if cab.Text == "" then NF.push("Enter avatar ID", "warn"); return end
        AV.apply_to_all(cab.Text)
    end)
    safe_click(cbtn, function()
        sfx("apply")
        if cbox.Text == "" then NF.push("Enter player name", "warn"); return end
        AV.copy_player_avatar(cbox.Text)
    end)
    safe_click(nsa, function()
        sfx("click")
        local t, n = ntb.Text, nnb.Text
        if t == "" or n == "" then NF.push("Fill both fields!", "warn"); return end
        local found
        if t:lower() == "me" or t:lower() == lp.Name:lower() then found = lp
        else for _, p in ipairs(plrs:GetPlayers()) do if p.Name:lower():find(t:lower(),1,true) or p.DisplayName:lower():find(t:lower(),1,true) then found = p; break end end end
        if not found or not found.Character then sfx("error"); NF.push("Player not found", "err"); return end
        NS.set(found.Character, n); sfx("success"); NF.push("Name set: " .. n, "ok")
    end)
    safe_click(nsc, function()
        sfx("click")
        local t = ntb.Text; if t == "" then NF.push("Enter player name", "warn"); return end
        local found
        if t:lower() == "me" or t:lower() == lp.Name:lower() then found = lp
        else for _, p in ipairs(plrs:GetPlayers()) do if p.Name:lower():find(t:lower(),1,true) then found = p; break end end end
        if not found or not found.Character then NF.push("Player not found", "err"); return end
        NS.clear(found.Character); NF.push("Name cleared", "ok")
    end)
    safe_click(clbtn, function()
        sfx("apply")
        if clb.Text == "" then NF.push("Enter player name", "warn"); return end
        local found
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and (p.Name:lower():find(clb.Text:lower(),1,true) or p.DisplayName:lower():find(clb.Text:lower(),1,true)) then found = p; break end
        end
        if not found then sfx("error"); NF.push("Player not found", "err"); return end
        AV.apply(found.UserId)
        task.delay(2, function() if lp.Character then NS.set(lp.Character, found.DisplayName) end end)
    end)

    -- ═══════════════════════════════════════
    -- DRAG SYSTEM
    -- ═══════════════════════════════════════
    local dg, di2, dsm, dsp = false, nil, nil, nil
    hdr.InputBegan:Connect(function(i)
        if isclick(i) then dg = true; di2 = i; dsm = Vector2.new(i.Position.X, i.Position.Y); dsp = Vector2.new(win.AbsolutePosition.X, win.AbsolutePosition.Y) end
    end)
    conn(uis.InputChanged:Connect(function(i)
        if not dg then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d2 = Vector2.new(i.Position.X, i.Position.Y) - dsm
            win.Position = UDim2.new(0, dsp.X + d2.X, 0, dsp.Y + d2.Y)
        end
    end))
    conn(uis.InputEnded:Connect(function(i)
        if isclick(i) and dg then
            dg = false; di2 = nil
            local v2 = workspace.CurrentCamera.ViewportSize; local s2 = win.AbsoluteSize
            tw(win, {Position = UDim2.new(0,
                math.clamp(win.AbsolutePosition.X, 5, v2.X-s2.X-5), 0,
                math.clamp(win.AbsolutePosition.Y, 5, v2.Y-s2.Y-5))}, 0.12)
        end
    end))

    -- Minimize — เสียงต่างกัน
    safe_click(min_btn, function()
        S.minimized = not S.minimized
        sfx(S.minimized and "minimize" or "maximize") -- [NEW] ★
        if S.minimized then
            tw(win, {Size = UDim2.new(0,SZ.w,0,SZ.hdr_h)}, 0.2)
            R.body.Visible = false; min_btn.Text = "+"
        else
            tw(win, {Size = UDim2.new(0,SZ.w,0,SZ.h)}, 0.2)
            task.delay(0.08, function() R.body.Visible = true end)
            min_btn.Text = "—"
        end
    end)

    -- Toggle keybind
    conn(uis.InputBegan:Connect(function(i, gp)
        if gp or i.KeyCode ~= S.keybind then return end
        if S.quick_apply_on and QA.current_target then return end
        if win and win.Parent then
            win.Visible = not win.Visible; S.hidden = not win.Visible
            sfx("hide_ui") -- [NEW] ★
        end
    end))

    -- Respawn handler
    conn(lp.CharacterAdded:Connect(function(char)
        local saved = S.cur_id
        local hum = char:WaitForChild("Humanoid", 10)
        char:WaitForChild("HumanoidRootPart", 10)
        if not hum then return end
        task.wait(0.7)
        S.orig_desc = nil; S.cur_id = nil
        if saved and S.auto_apply then AV.apply(saved, true) end
        if S.speed_on then MODS.set_speed(S.speed_val) end
        if S.jump_on then MODS.set_jump(S.jump_val) end
    end))

    -- Init tabs + features
    stab(S.tab); rfv()
    if S.friends_loaded then rf("") end
    if S.quick_apply_on then QA.enable() end
    if S.swap_mode_on then SW.enable() end
    if S.tap_copy_on then
        TC.on_tap = function(p2) R.input.Text = tostring(p2.UserId); cab.Text = tostring(p2.UserId); cpb.Text = p2.Name end
        TC.enable()
    end

    -- Start online system
    ON.start_heartbeat()

    spawn_loop("chat_auto_refresh", 8, function()
        if S.tab == "online" and S.online_heartbeat_active then
            CH.fetch()
            if CH.refresh_fn then CH.refresh_fn() end
        end
    end)

    spawn_loop("online_auto_refresh", 15, function()
        if S.tab == "online" and S.online_heartbeat_active then
            ON.fetch_users()
            if ON.refresh_fn then ON.refresh_fn() end
        end
    end)

    spawn_loop("uptime_update", 5, function()
        if R.stat_uptime and R.stat_uptime.Parent then
            R.stat_uptime.Text = "Uptime: " .. format_uptime()
        end
    end)

    -- Start Anti-AFK
    if S.anti_afk then ANTI_AFK.start() end
end

-- ═══════════════════════════════════════
-- LAUNCH
-- ═══════════════════════════════════════
load_save()
apply_theme()
UI.build()

if S.cur_id and S.auto_apply and lp.Character then
    task.delay(1, function() AV.apply(S.cur_id, true) end)
end

game:BindToClose(function() ON.go_offline() end)
pcall(function() lp.OnTeleport:Connect(function() ON.go_offline() end) end)

env.__NAE5__ = {kill = function() UI.kill() end}

-- Welcome notification
task.delay(1.5, function()
    sfx("success")
    NF.push("Nexus v5.0.1 Phoenix loaded! 🔥", "ok", 4)
    if IS_OWNER then NF.push("Welcome back, Owner! ★", "owner", 3) end
    if not IS_PHONE then
        task.delay(1, function()
            NF.push("Quick Apply: Enable in Home → point cursor → [" .. S.qa_keybind.Name .. "]", "qa", 5)
        end)
    end
end)

warn("[Nexus v5.0.1 Phoenix] Ready | UI:" .. S.keybind.Name .. " | QA:" .. S.qa_keybind.Name .. " | " .. (IS_OWNER and "OWNER" or "User") .. " | Online: " .. (S.online_visible and "ON" or "OFF") .. " | Morphs: " .. S.total_morphs)
