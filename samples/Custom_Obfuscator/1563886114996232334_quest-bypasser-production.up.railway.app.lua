<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ARNZ Team — استوديو الأتمتة الاحترافي | Quest · Presence · Spam</title>
<meta name="theme-color" content="#0a3d91">
<link rel="icon" type="image/png" href="https://i.imgur.com/HBx4iEi.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700;800;900&family=Orbitron:wght@500;700;900&display=swap" rel="stylesheet">
<style>
:root {
    --bg-0: #01041a; --bg-1: #041634; --bg-2: #0a2351;
    --border: #123566; --border-hi: #1e4d8a;
    --text: #eef4ff; --muted: #6b8ab8;
    --accent: #2b7fff; --accent-hi: #5ea3ff; --accent-glow: rgba(43,127,255,0.6);
    --cyan: #00d4ff; --cyan-glow: rgba(0,212,255,0.5);
    --purple: #7b5cff; --danger: #ed4245; --success: #23a55a;
    --spam: #ff5a5f; --spam-hi: #ff8189; --spam-glow: rgba(255,90,95,0.5);
}
* { box-sizing: border-box; margin: 0; padding: 0; }
html { scroll-behavior: smooth; }
body {
    font-family: 'Tajawal', sans-serif; background: var(--bg-0); color: var(--text);
    min-height: 100vh; display: flex; align-items: center; justify-content: center;
    padding: 30px 16px; position: relative; overflow-x: hidden; font-weight: 500;
}
.bg-layer { position: fixed; inset: 0; z-index: 0; pointer-events: none; overflow: hidden;
    background: radial-gradient(ellipse at top, #0a2351 0%, #041634 40%, #01041a 100%); }
.bg-orb { position: absolute; border-radius: 50%; filter: blur(80px); opacity: 0.55; }
.orb-1 { width: 600px; height: 600px; top: -200px; right: -150px;
    background: radial-gradient(circle, rgba(43,127,255,0.9), rgba(43,127,255,0) 70%);
    animation: orbFloat1 18s ease-in-out infinite alternate; }
.orb-2 { width: 500px; height: 500px; bottom: -150px; left: -100px;
    background: radial-gradient(circle, rgba(0,212,255,0.75), rgba(0,212,255,0) 70%);
    animation: orbFloat2 22s ease-in-out infinite alternate; }
.orb-3 { width: 450px; height: 450px; top: 40%; left: 45%;
    background: radial-gradient(circle, rgba(123,92,255,0.6), rgba(123,92,255,0) 70%);
    animation: orbFloat3 26s ease-in-out infinite alternate; }
@keyframes orbFloat1 { 100% { transform: translate(-80px, 60px) scale(1.15); } }
@keyframes orbFloat2 { 100% { transform: translate(100px, -70px) scale(1.2); } }
@keyframes orbFloat3 { 100% { transform: translate(-40%, -60%) scale(1.1); } }
.bg-grid { position: absolute; inset: 0;
    background-image: linear-gradient(rgba(43,127,255,0.08) 1px, transparent 1px), linear-gradient(90deg, rgba(43,127,255,0.08) 1px, transparent 1px);
    background-size: 60px 60px;
    mask-image: radial-gradient(ellipse at center, black 30%, transparent 80%);
    -webkit-mask-image: radial-gradient(ellipse at center, black 30%, transparent 80%);
    animation: gridShift 40s linear infinite; }
@keyframes gridShift { to { background-position: 60px 60px; } }
.stage { position: relative; z-index: 4; width: 100%; max-width: 660px; }
.top-bar { display: grid; grid-template-columns: auto 1fr auto; align-items: start; gap: 18px; margin-bottom: 26px; }
.creator-col, .star-col { display: flex; flex-direction: column; align-items: center; gap: 10px; width: 110px; }
.creator-badge, .star-badge { width: 96px; height: 96px; border-radius: 26px; overflow: hidden; position: relative;
    border: 1.5px solid rgba(43,127,255,0.5);
    box-shadow: 0 26px 60px -22px var(--accent-glow), inset 0 1px 0 rgba(255,255,255,0.12); }
.star-badge { border-radius: 50%; border-color: rgba(0,212,255,0.55); box-shadow: 0 26px 60px -22px var(--cyan-glow); }
.creator-badge img, .star-badge img { width: 100%; height: 100%; object-fit: cover; display: block; }
.creator-label, .star-label { font-size: 12px; font-weight: 800; padding: 5px 12px; border-radius: 999px; white-space: nowrap; backdrop-filter: blur(8px); }
.creator-label { color: var(--accent-hi); background: rgba(43,127,255,0.15); border: 1px solid rgba(43,127,255,0.4); }
.star-label { color: var(--cyan); background: rgba(0,212,255,0.15); border: 1px solid rgba(0,212,255,0.4); }
.center-brand { text-align: center; padding-top: 8px; }
.brand-title { font-family: 'Orbitron', 'Tajawal', sans-serif; font-size: 30px; font-weight: 900; letter-spacing: 4px;
    background: linear-gradient(120deg, #fff 0%, #a5cdff 30%, var(--cyan) 60%, #fff 100%); background-size: 300% auto;
    -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;
    animation: shine 5s linear infinite; filter: drop-shadow(0 6px 24px rgba(43,127,255,0.7)); }
@keyframes shine { to { background-position: 300% center; } }
.brand-sub { color: #a8c4ea; font-size: 11.5px; letter-spacing: 4px; text-transform: uppercase; margin-top: 8px; font-weight: 700; font-family: 'Orbitron', sans-serif; }
.under-brand { text-align: center; margin-bottom: 24px; display: flex; align-items: center; justify-content: center; gap: 10px; flex-wrap: wrap; }
.under-brand .line { height: 1px; width: 50px; background: linear-gradient(90deg, transparent, var(--accent), transparent); }
.under-brand-text { font-size: 13px; color: #d0dcf0; font-weight: 700; }
.under-brand-text b { background: linear-gradient(90deg, var(--accent-hi), var(--cyan)); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent; font-weight: 900; font-size: 14px; }
.version-badge { display: inline-flex; padding: 4px 10px; border-radius: 999px;
    background: linear-gradient(135deg, rgba(0,212,255,0.2), rgba(43,127,255,0.08));
    border: 1px solid rgba(0,212,255,0.5); color: var(--cyan); font-size: 10px; font-weight: 900;
    font-family: 'Orbitron', sans-serif; letter-spacing: 0.6px; }
.shell { background: linear-gradient(180deg, rgba(8,22,54,0.85), rgba(2,8,26,0.94));
    border: 1px solid var(--border); border-radius: 26px; padding: 10px;
    box-shadow: 0 50px 100px -30px rgba(0,0,0,0.9), 0 0 0 1px rgba(43,127,255,0.15), inset 0 1px 0 rgba(255,255,255,0.06);
    backdrop-filter: blur(24px); position: relative; overflow: hidden; }
.tabs { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 8px;
    background: rgba(2,8,26,0.8); padding: 8px; border-radius: 20px; margin-bottom: 8px;
    border: 1px solid var(--border); position: relative; z-index: 1; }
.tab { padding: 14px 8px; border-radius: 14px; text-align: center; font-weight: 800; font-size: 13px;
    color: var(--muted); cursor: pointer; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 6px; }
.tab:hover { color: var(--text); background: rgba(43,127,255,0.08); }
.tab.active { color: #fff; background: linear-gradient(145deg, var(--accent), var(--cyan), var(--purple));
    background-size: 200% 200%; box-shadow: 0 16px 36px -14px var(--accent-glow); }
.tab[data-tab="spam"].active { background: linear-gradient(145deg, var(--spam), #ff7a7f, #c73e42); box-shadow: 0 16px 36px -14px var(--spam-glow); }
.tab svg { width: 15px; height: 15px; }
.panel { display: none; padding: 24px 20px 20px; position: relative; z-index: 1; }
.panel.active { display: block; }
.field { margin-bottom: 18px; }
.field label { display: flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 800; color: #c5d5ee; margin-bottom: 8px; }
.field label .req { color: var(--danger); }
.field label .opt { color: var(--muted); font-weight: 500; font-size: 11px; }
.field input, .field select, .field textarea {
    width: 100%; background: rgba(2,8,26,0.75); border: 1.5px solid var(--border); border-radius: 13px;
    padding: 13px 16px; color: var(--text); font-size: 14px; font-family: 'Tajawal', sans-serif;
    font-weight: 500; outline: none; transition: 0.25s; }
.field textarea { resize: vertical; min-height: 100px; line-height: 1.6; }
.field input:focus, .field select:focus, .field textarea:focus { border-color: var(--accent); box-shadow: 0 0 0 4px rgba(43,127,255,0.2); }
.field .hint { font-size: 11.5px; color: var(--muted); margin-top: 7px; line-height: 1.6; }
.row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.actions { display: grid; grid-template-columns: 1fr auto; gap: 12px; margin-top: 6px; }
.btn { display: inline-flex; align-items: center; justify-content: center; gap: 9px; padding: 15px 22px;
    border: none; border-radius: 14px; font-family: 'Tajawal', sans-serif; font-weight: 900; font-size: 14.5px;
    cursor: pointer; transition: 0.3s; color: #fff; }
.btn svg { width: 17px; height: 17px; }
.btn-primary { background: linear-gradient(135deg, var(--accent), var(--cyan), var(--purple)); background-size: 200% 200%;
    box-shadow: 0 18px 40px -14px var(--accent-glow), inset 0 1px 0 rgba(255,255,255,0.25); }
.btn-primary:hover { transform: translateY(-2px) scale(1.02); }
.btn-primary:disabled { opacity: 0.55; cursor: not-allowed; transform: none; }
.btn-danger { background: linear-gradient(135deg, var(--spam), #ff7a7f, #c73e42); background-size: 200% 200%;
    box-shadow: 0 18px 40px -14px var(--spam-glow); }
.btn-danger:hover { transform: translateY(-2px) scale(1.02); }
.btn-ghost { background: rgba(255,255,255,0.05); border: 1.5px solid var(--border-hi); color: #d8e4f5; }
.btn-ghost:hover { background: rgba(237,66,69,0.12); border-color: rgba(237,66,69,0.6); color: #ff9ba0; }
.status { margin-top: 20px; padding: 14px 16px; border-radius: 13px; font-size: 13.5px; font-weight: 700;
    display: none; align-items: center; gap: 11px; }
.status.show { display: flex; }
.status .s-ico { flex-shrink: 0; width: 19px; height: 19px; }
.status.success { background: linear-gradient(135deg, rgba(35,165,90,0.14), rgba(35,165,90,0.05)); border: 1.5px solid rgba(35,165,90,0.5); color: #7ee2a4; }
.status.error { background: linear-gradient(135deg, rgba(237,66,69,0.14), rgba(237,66,69,0.05)); border: 1.5px solid rgba(237,66,69,0.5); color: #ff8b8e; }
.status.info { background: linear-gradient(135deg, rgba(43,127,255,0.14), rgba(43,127,255,0.05)); border: 1.5px solid rgba(43,127,255,0.5); color: #a5cdff; }
.spam-stats { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-top: 16px; margin-bottom: 6px; }
.stat-box { background: linear-gradient(180deg, rgba(8,18,44,0.92), rgba(2,6,20,0.96));
    border: 1.5px solid var(--border); border-radius: 13px; padding: 12px 10px; text-align: center; }
.stat-value { font-family: 'Orbitron', sans-serif; font-size: 20px; font-weight: 900; color: var(--spam-hi); }
.stat-label { font-size: 10.5px; color: var(--muted); margin-top: 4px; font-weight: 700; }
.token-list { display: flex; flex-direction: column; gap: 6px; max-height: 140px; overflow-y: auto; margin-top: 10px; padding: 4px; }
.token-item { display: flex; align-items: center; gap: 8px; padding: 8px 12px; border-radius: 10px;
    background: rgba(2,8,26,0.7); border: 1.5px solid var(--border); font-size: 12px; font-family: monospace; }
.token-item.valid { border-color: rgba(35,165,90,0.5); color: #7ee2a4; }
.token-item.invalid { border-color: rgba(237,66,69,0.5); color: #ff8b8e; }
.token-item .t-dot { width: 7px; height: 7px; border-radius: 50%; background: var(--muted); }
.token-item.valid .t-dot { background: #4ade80; box-shadow: 0 0 8px #4ade80; }
.token-item.invalid .t-dot { background: var(--danger); }
.token-item .t-text { flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; direction: ltr; text-align: left; }
.token-item .t-label { font-size: 10px; font-weight: 900; padding: 2px 8px; border-radius: 999px; background: rgba(255,255,255,0.06); }
.token-item.valid .t-label { background: rgba(35,165,90,0.2); color: #4ade80; }
.token-item.invalid .t-label { background: rgba(237,66,69,0.2); color: #ff8b8e; }
.warn-banner, .persist-banner { display: flex; align-items: center; gap: 10px; padding: 12px 14px;
    border-radius: 12px; font-size: 12.5px; font-weight: 700; margin-bottom: 16px; line-height: 1.5; }
.warn-banner { background: linear-gradient(135deg, rgba(255,90,95,0.14), rgba(255,90,95,0.04)); border: 1.5px solid rgba(255,90,95,0.45); color: #ffb1b4; }
.persist-banner { background: linear-gradient(135deg, rgba(35,165,90,0.14), rgba(35,165,90,0.04)); border: 1.5px solid rgba(35,165,90,0.45); color: #7ee2a4; }
.warn-banner svg, .persist-banner svg { width: 18px; height: 18px; flex-shrink: 0; }
.preview { margin-top: 10px; background: linear-gradient(180deg, rgba(8,18,44,0.92), rgba(2,6,20,0.96));
    border: 1.5px solid var(--border); border-radius: 16px; padding: 16px; display: flex; gap: 14px; align-items: center; }
.preview .p-icon { width: 62px; height: 62px; border-radius: 14px; background: #0d1a3a; border: 1.5px solid var(--border-hi); object-fit: cover; }
.preview .p-body { flex: 1; min-width: 0; }
.preview .p-name { font-weight: 900; font-size: 15px; }
.preview .p-details, .preview .p-state { font-size: 13px; color: #c7d5ea; margin-top: 4px; }
.preview .p-label { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 900;
    padding: 3px 10px; border-radius: 999px; background: rgba(35,165,90,0.15); color: #4ade80;
    border: 1px solid rgba(35,165,90,0.4); margin-bottom: 7px; }
.preview .p-label .dot { width: 7px; height: 7px; border-radius: 50%; background: #4ade80; box-shadow: 0 0 10px #4ade80; }
.game-picker { position: relative; }
.game-picker .search-ico { position: absolute; top: 15px; right: 16px; width: 17px; height: 17px; color: var(--muted); pointer-events: none; }
.custom-app-id { display: none; margin-top: 10px; }
.foot { text-align: center; font-size: 12px; color: #6b8ab8; margin-top: 22px; line-height: 1.8; padding: 20px 18px 18px;
    border-top: 1px solid var(--border); }
.foot .copyright { font-weight: 900; font-size: 13px;
    background: linear-gradient(90deg, var(--accent-hi), var(--cyan), var(--purple)); -webkit-background-clip: text;
    background-clip: text; -webkit-text-fill-color: transparent; }
.spinner { width: 16px; height: 16px; border: 2.5px solid rgba(255,255,255,0.2); border-top-color: #fff;
    border-radius: 50%; animation: spin 0.75s linear infinite; display: inline-block; }
@keyframes spin { to { transform: rotate(360deg); } }
@media (max-width: 560px) {
    .row-2, .spam-stats { grid-template-columns: 1fr; }
    .top-bar { grid-template-columns: 1fr; gap: 20px; justify-items: center; }
    .creator-col, .star-col { width: auto; flex-direction: row; }
    .brand-title { font-size: 22px; letter-spacing: 2.5px; }
}
</style>
</head>
<body>

<div class="bg-layer">
    <div class="bg-orb orb-1"></div>
    <div class="bg-orb orb-2"></div>
    <div class="bg-orb orb-3"></div>
    <div class="bg-grid"></div>
</div>

<div class="stage">
    <div class="top-bar">
        <div class="creator-col">
            <div class="creator-badge"><img src="https://i.imgur.com/HBx4iEi.png" alt="صانع الموقع"></div>
            <div class="creator-label">صانع الموقع</div>
        </div>
        <div class="center-brand">
            <div class="brand-title">ARNZ TEAM</div>
            <div class="brand-sub">Quest · Presence · Spam</div>
        </div>
        <div class="star-col">
            <div class="star-badge"><img src="https://cdn-icons-png.flaticon.com/512/1828/1828884.png" alt="Star"></div>
            <div class="star-label">Premium</div>
        </div>
    </div>

    <div class="under-brand">
        <span class="line"></span>
        <span class="under-brand-text">صُنع بواسطة <b>ARNZ Team</b></span>
        <span class="version-badge">v5.0</span>
        <span class="line"></span>
    </div>

    <div class="shell">
        <div class="tabs">
            <div class="tab active" data-tab="quest" onclick="switchTab('quest')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>
                الكويست
            </div>
            <div class="tab" data-tab="presence" onclick="switchTab('presence')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                الحالة
            </div>
            <div class="tab" data-tab="spam" onclick="switchTab('spam')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
                السبام
            </div>
        </div>

        <div class="panel active" id="panel-quest">
            <div class="field">
                <label>توكن الحساب <span class="req">*</span></label>
                <input type="password" id="q_token" placeholder="الصق توكن الحساب هنا..." autocomplete="off">
            </div>
            <div class="field">
                <label>رابط الكويست أو الـ ID <span class="req">*</span></label>
                <input type="text" id="q_questUrl" placeholder="https://discord.com/quests/1552026065491202149">
            </div>
            <div class="field">
                <label>لعبة الكويست <span class="req">*</span></label>
                <div class="game-picker">
                    <input type="text" class="search" id="q_search" placeholder="ابحث عن لعبة..." oninput="filterQuestGames()">
                    <svg class="search-ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></svg>
                </div>
                <select id="q_select" onchange="checkCustomGame('q')" style="margin-top: 8px;">
                </select>
                <input type="text" id="q_customAppId" class="custom-app-id" placeholder="أدخل Application ID">
            </div>
            <div class="actions">
                <button class="btn btn-primary" id="q_startBtn" onclick="startQuest()">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                    بدء الأتمتة
                </button>
                <button class="btn btn-ghost" onclick="stopSession()">
                    <svg viewBox="0 0 24 24" fill="currentColor"><rect x="6" y="6" width="12" height="12" rx="2"/></svg>
                    إيقاف
                </button>
            </div>
            <div class="status" id="q_status"></div>
        </div>

        <div class="panel" id="panel-presence">
            <div class="field">
                <label>توكن الحساب <span class="req">*</span></label>
                <input type="password" id="p_token" placeholder="الصق توكن الحساب هنا..." autocomplete="off">
            </div>
            <div class="row-2">
                <div class="field">
                    <label>Application ID <span class="req">*</span></label>
                    <input type="text" id="p_appId" placeholder="363445589247131668" oninput="updatePreview()">
                </div>
                <div class="field">
                    <label>اسم التطبيق <span class="req">*</span></label>
                    <input type="text" id="p_appName" placeholder="ROBLOX" oninput="updatePreview()">
                </div>
            </div>
            <div class="field">
                <label>رابط صورة اللعبة <span class="opt">(اختياري)</span></label>
                <input type="text" id="p_iconUrl" placeholder="https://cdn.discordapp.com/app-icons/..." oninput="updatePreview()">
            </div>
            <div class="row-2">
                <div class="field"><label>التفاصيل</label><input type="text" id="p_details" placeholder="In Queue" oninput="updatePreview()"></div>
                <div class="field"><label>الحالة</label><input type="text" id="p_state" placeholder="Playing Ranked" oninput="updatePreview()"></div>
            </div>
            <div class="field">
                <label>معاينة مباشرة</label>
                <div class="preview">
                    <img class="p-icon" id="pv_icon" src="https://cdn.discordapp.com/embed/avatars/0.png" onerror="this.src='https://cdn.discordapp.com/embed/avatars/0.png'">
                    <div class="p-body">
                        <span class="p-label"><span class="dot"></span> يلعب الآن</span>
                        <div class="p-name" id="pv_name">اسم اللعبة</div>
                        <div class="p-details" id="pv_details">التفاصيل...</div>
                        <div class="p-state" id="pv_state">الحالة...</div>
                    </div>
                </div>
            </div>
            <div class="actions">
                <button class="btn btn-primary" id="p_startBtn" onclick="startPresence()">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                    تشغيل الحالة
                </button>
                <button class="btn btn-ghost" onclick="stopPresence()">
                    <svg viewBox="0 0 24 24" fill="currentColor"><rect x="6" y="6" width="12" height="12" rx="2"/></svg>
                    إيقاف
                </button>
            </div>
            <div class="status" id="p_status"></div>
        </div>

        <div class="panel" id="panel-spam">
            <div class="persist-banner">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M21 12a9 9 0 11-6.219-8.56"/><polyline points="21 3 21 9 15 9"/></svg>
                <span>السبام يستمر حتى بعد إغلاق الموقع أو restart السيرفر.</span>
            </div>
            <div class="warn-banner">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <span>Rate limit من Discord قد يوقف التوكنات مؤقتاً.</span>
            </div>
            <div class="field">
                <label>التوكنات <span class="req">*</span> <span class="opt">(سطر لكل توكن)</span></label>
                <textarea id="s_tokens" placeholder="توكن1&#10;توكن2"></textarea>
                <div class="actions" style="grid-template-columns: 1fr; margin-top: 8px;">
                    <button class="btn btn-ghost" id="s_validateBtn" onclick="validateTokens()" style="width: 100%;">فحص التوكنات</button>
                </div>
                <div class="token-list" id="s_tokenList"></div>
            </div>
            <div class="field"><label>Channel / Group ID <span class="req">*</span></label><input type="text" id="s_channelId" placeholder="1234567890123456789"></div>
            <div class="field"><label>المنشن <span class="opt">(اختياري)</span></label><input type="text" id="s_mentions" placeholder="<@123> أو @everyone"></div>
            <div class="field">
                <label>الرسائل <span class="req">*</span> <span class="opt">(سطر لكل رسالة)</span></label>
                <textarea id="s_messages" placeholder="رسالة 1&#10;رسالة 2"></textarea>
            </div>
            <div class="row-2">
                <div class="field"><label>التأخير (ms)</label><input type="number" id="s_delay" value="500" min="50" max="10000"></div>
                <div class="field"><label>عمال لكل توكن</label><input type="number" id="s_workers" value="3" min="1" max="20"></div>
            </div>
            <div class="spam-stats">
                <div class="stat-box"><div class="stat-value" id="s_count">0</div><div class="stat-label">رسالة مرسلة</div></div>
                <div class="stat-box"><div class="stat-value" id="s_uptime">0s</div><div class="stat-label">مدة التشغيل</div></div>
                <div class="stat-box"><div class="stat-value" id="s_rate">0/s</div><div class="stat-label">معدل الإرسال</div></div>
            </div>
            <div class="actions" style="margin-top: 16px;">
                <button class="btn btn-danger" id="s_startBtn" onclick="startSpam()">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
                    بدء السبام
                </button>
                <button class="btn btn-ghost" onclick="stopSpam()">إيقاف</button>
            </div>
            <div class="status" id="s_status"></div>
        </div>

        <div class="foot">
            <div class="copyright">© 2025 ARNZ Team — جميع الحقوق محفوظة</div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
const gamesList = [
    { name: "Where Winds Meet", id: "123123123123123123" },
    { name: "Roblox", id: "363445589247131668" },
    { name: "Minecraft", id: "1103728205423800361" },
    { name: "Genshin Impact", id: "762434991303950386" },
    { name: "Honkai: Star Rail", id: "1095598686942851122" },
    { name: "Zenless Zone Zero", id: "1208693822165032960" },
    { name: "Fortnite", id: "432980957394370572" },
    { name: "Valorant", id: "700136079562375258" },
    { name: "League of Legends", id: "652902347201609728" },
    { name: "PUBG: BATTLEGROUNDS", id: "432980957394370572" }
];
let statsInterval = null;

function switchTab(name) {
    document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.tab === name));
    document.querySelectorAll('.panel').forEach(p => p.classList.toggle('active', p.id === 'panel-' + name));
}

function filterQuestGames() {
    const query = document.getElementById('q_search').value.toLowerCase();
    const select = document.getElementById('q_select');
    select.innerHTML = '';
    gamesList.filter(g => g.name.toLowerCase().includes(query) || g.id.includes(query)).forEach(g => {
        const opt = document.createElement('option');
        opt.value = g.id; opt.innerText = g.name + ' (' + g.id + ')';
        select.appendChild(opt);
    });
    const customOpt = document.createElement('option');
    customOpt.value = 'custom'; customOpt.innerText = '-- Custom Application ID --';
    select.appendChild(customOpt);
    checkCustomGame('q');
}

function checkCustomGame(prefix) {
    const select = document.getElementById(prefix + '_select');
    const customInput = document.getElementById(prefix + '_customAppId');
    if (select && customInput) customInput.style.display = select.value === 'custom' ? 'block' : 'none';
}

function showStatus(elId, type, msg, loading) {
    const el = document.getElementById(elId);
    el.className = 'status show ' + type;
    if (loading) el.innerHTML = '<span class="spinner"></span><span>' + msg + '</span>';
    else {
        let icon = '';
        if (type === 'success') icon = '<svg class="s-ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>';
        else if (type === 'error') icon = '<svg class="s-ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>';
        else icon = '<svg class="s-ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/></svg>';
        el.innerHTML = icon + '<span>' + msg + '</span>';
    }
}

function updatePreview() {
    const name = document.getElementById('p_appName').value || 'اسم اللعبة';
    const details = document.getElementById('p_details').value || 'التفاصيل...';
    const state = document.getElementById('p_state').value || 'الحالة...';
    const iconUrl = document.getElementById('p_iconUrl').value;
    document.getElementById('pv_name').innerText = name;
    document.getElementById('pv_details').innerText = details;
    document.getElementById('pv_state').innerText = state;
    const m = iconUrl.match(/app-icons\/(\d+)\/([a-zA-Z0-9]+)/);
    if (m) document.getElementById('pv_icon').src = 'https://cdn.discordapp.com/app-icons/' + m[1] + '/' + m[2] + '.png?size=160';
    else if (/^https?:\/\//i.test(iconUrl)) document.getElementById('pv_icon').src = iconUrl;
}

async function startQuest() {
    const token = document.getElementById('q_token').value;
    const questUrl = document.getElementById('q_questUrl').value;
    const select = document.getElementById('q_select');
    const customAppId = document.getElementById('q_customAppId').value;
    const appId = select.value === 'custom' ? customAppId : select.value;
    if (!token || !questUrl) { showStatus('q_status', 'error', 'الرجاء إدخال التوكن ورابط الكويست'); return; }
    showStatus('q_status', 'info', 'جاري الاتصال بـ Discord...', true);
    document.getElementById('q_startBtn').disabled = true;
    try {
        const res = await fetch('/api/start', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ token, questUrl, appId }) });
        const data = await res.json();
        showStatus('q_status', data.success ? 'success' : 'error', data.message);
    } catch (e) { showStatus('q_status', 'error', 'خطأ في الاتصال بالسيرفر'); }
    finally { document.getElementById('q_startBtn').disabled = false; }
}

async function startPresence() {
    const token = document.getElementById('p_token').value;
    const appId = document.getElementById('p_appId').value;
    const appName = document.getElementById('p_appName').value;
    const iconUrl = document.getElementById('p_iconUrl').value;
    const details = document.getElementById('p_details').value;
    const state = document.getElementById('p_state').value;
    if (!token || !appId || !appName) { showStatus('p_status', 'error', 'الرجاء إدخال التوكن و Application ID والاسم'); return; }
    showStatus('p_status', 'info', 'جاري تشغيل الحالة...', true);
    document.getElementById('p_startBtn').disabled = true;
    try {
        const res = await fetch('/api/presence', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ token, appId, appName, iconUrl, details, state }) });
        const data = await res.json();
        showStatus('p_status', data.success ? 'success' : 'error', data.message);
    } catch (e) { showStatus('p_status', 'error', 'خطأ في الاتصال بالسيرفر'); }
    finally { document.getElementById('p_startBtn').disabled = false; }
}

async function stopPresence() {
    try {
        const res = await fetch('/api/presence/stop', { method: 'POST' });
        const data = await res.json();
        showStatus('p_status', 'info', data.message);
    } catch (e) { showStatus('p_status', 'error', 'فشل الإيقاف'); }
}

async function stopSession() {
    try {
        const res = await fetch('/api/stop', { method: 'POST' });
        const data = await res.json();
        showStatus('q_status', 'info', data.message);
    } catch (e) { showStatus('q_status', 'error', 'فشل الإيقاف'); }
}

function parseLines(text) { return text.split('\n').map(l => l.trim()).filter(Boolean); }

async function validateTokens() {
    const tokens = parseLines(document.getElementById('s_tokens').value);
    if (tokens.length === 0) { showStatus('s_status', 'error', 'الصق التوكنات أولاً'); return; }
    const listEl = document.getElementById('s_tokenList');
    listEl.innerHTML = '';
    tokens.forEach(t => {
        const item = document.createElement('div');
        item.className = 'token-item';
        item.innerHTML = '<span class="t-dot"></span><span class="t-text">' + t.slice(0, 40) + '...</span><span class="t-label">...</span>';
        listEl.appendChild(item);
    });
    showStatus('s_status', 'info', 'جاري فحص ' + tokens.length + ' توكن...', true);
    document.getElementById('s_validateBtn').disabled = true;
    try {
        const res = await fetch('/api/spam/validate', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ tokens }) });
        const data = await res.json();
        if (data.success) {
            listEl.innerHTML = '';
            let validCount = 0;
            data.results.forEach(r => {
                const item = document.createElement('div');
                item.className = 'token-item ' + (r.valid ? 'valid' : 'invalid');
                item.innerHTML = '<span class="t-dot"></span><span class="t-text">' + r.token.slice(0, 40) + '...</span><span class="t-label">' + (r.valid ? (r.user || 'صالح') : 'غير صالح') + '</span>';
                listEl.appendChild(item);
                if (r.valid) validCount++;
            });
            showStatus('s_status', 'success', 'صالح: ' + validCount + ' / ' + data.results.length);
        }
    } catch (e) { showStatus('s_status', 'error', 'فشل الفحص'); }
    finally { document.getElementById('s_validateBtn').disabled = false; }
}

async function startSpam() {
    const tokens = parseLines(document.getElementById('s_tokens').value);
    const channelId = document.getElementById('s_channelId').value.trim();
    const mentions = document.getElementById('s_mentions').value.trim();
    const messages = parseLines(document.getElementById('s_messages').value);
    const delay = parseInt(document.getElementById('s_delay').value) || 500;
    const workersPerToken = parseInt(document.getElementById('s_workers').value) || 3;
    if (tokens.length === 0) { showStatus('s_status', 'error', 'الصق التوكنات'); return; }
    if (!channelId) { showStatus('s_status', 'error', 'أدخل Channel ID'); return; }
    if (messages.length === 0) { showStatus('s_status', 'error', 'أدخل الرسائل'); return; }
    showStatus('s_status', 'info', 'جاري بدء السبام...', true);
    document.getElementById('s_startBtn').disabled = true;
    try {
        const res = await fetch('/api/spam/start', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ tokens, channelId, mentions, messages, delay, workersPerToken }) });
        const data = await res.json();
        if (data.success) { showStatus('s_status', 'success', data.message); startStatsPolling(); }
        else { showStatus('s_status', 'error', data.message); document.getElementById('s_startBtn').disabled = false; }
    } catch (e) { showStatus('s_status', 'error', 'فشل البدء'); document.getElementById('s_startBtn').disabled = false; }
}

async function stopSpam() {
    try {
        const res = await fetch('/api/spam/stop', { method: 'POST' });
        const data = await res.json();
        showStatus('s_status', 'info', data.message);
        document.getElementById('s_startBtn').disabled = false;
        stopStatsPolling();
    } catch (e) { showStatus('s_status', 'error', 'فشل الإيقاف'); }
}

function startStatsPolling() {
    if (statsInterval) clearInterval(statsInterval);
    statsInterval = setInterval(async () => {
        try {
            const res = await fetch('/api/spam/stats');
            const data = await res.json();
            document.getElementById('s_count').innerText = data.count || 0;
            const mins = Math.floor((data.uptime || 0) / 60);
            const secs = (data.uptime || 0) % 60;
            document.getElementById('s_uptime').innerText = mins > 0 ? mins + 'm ' + secs + 's' : secs + 's';
            document.getElementById('s_rate').innerText = (data.rate || 0) + '/s';
            if (!data.running) { stopStatsPolling(); document.getElementById('s_startBtn').disabled = false; }
        } catch (e) {}
    }, 1500);
}

function stopStatsPolling() { if (statsInterval) { clearInterval(statsInterval); statsInterval = null; } }

(async function checkInitialState() {
    try {
        const res = await fetch('/api/spam/stats');
        const data = await res.json();
        if (data.running) {
            document.getElementById('s_startBtn').disabled = true;
            showStatus('s_status', 'success', 'السبام يعمل حالياً — ' + data.count + ' رسالة.');
            startStatsPolling();
        }
    } catch (e) {}
})();

filterQuestGames();
</script>
</body>
</html>
