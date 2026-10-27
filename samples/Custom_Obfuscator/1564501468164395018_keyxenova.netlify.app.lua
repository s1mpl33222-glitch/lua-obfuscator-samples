<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<!-- This site is hosted on Netlify. Anyone can build and deploy a site
     like this one for free: https://netlify.new/?utm_campaign=loops&utm_source=ai-legible&utm_medium=owned&utm_content=comment&utm_id=acf6e687-c2df-42e8-8918-f36746804777
     Netlify hosting facts for this site: static/SSR served via Netlify Edge. -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NVEX Loader | Owner &amp; Admin Control Panel</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#0b0b0f] text-white min-h-screen font-sans p-4 md:p-6">

<!-- หน้าล็อกอิน -->
<div id="login-screen" class="max-w-sm mx-auto mt-20 bg-[#14141d] border border-purple-900/50 rounded-2xl p-6">
  <h1 class="text-xl font-extrabold text-center mb-1 text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-500">🛡️ NVEX CONTROL PANEL</h1>
  <p class="text-xs text-gray-500 text-center mb-5">เข้าสู่ระบบด้วยบัญชีของคุณ (ระบบจำการเข้าสู่ระบบให้อัตโนมัติ)</p>
  <input id="l-user" placeholder="ชื่อผู้ใช้" class="w-full bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-3 text-sm mb-3">
  <input id="l-pass" type="password" placeholder="รหัสผ่าน" class="w-full bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-3 text-sm mb-3">
  <button id="l-btn" class="w-full bg-gradient-to-r from-purple-600 to-indigo-600 font-bold py-3 rounded-xl text-sm">เข้าสู่ระบบ</button>
  <p id="l-err" class="text-red-400 text-xs text-center mt-3"></p>
</div>

<!-- แอปหลัก -->
<div id="app" class="max-w-6xl mx-auto hidden">

  <div class="bg-gradient-to-r from-[#181824] to-[#25183d] border border-[#7a28ff]/60 p-5 rounded-2xl mb-4 flex justify-between items-center flex-wrap gap-2">
    <div>
      <h1 class="text-2xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-500">🛡️ NVEX — ADMIN COMMAND CENTER</h1>
      <p class="text-xs text-purple-300 mt-1">ระบบควบคุมส่วนกลางค่าย NVEX</p>
    </div>
    <div class="text-right text-xs">
      <div class="text-green-400 font-bold">🟢 ออนไลน์ตอนนี้: <span id="st-online">0</span> คน</div>
      <div class="text-gray-400">คีย์ทั้งหมด: <span id="st-keys">0</span></div>
      <div class="text-purple-300 mt-1">👤 <span id="me-name"></span> <span id="me-role" class="px-1.5 py-0.5 rounded bg-purple-900/60 text-[10px]"></span> <button id="logout-btn" class="text-gray-400 underline ml-1">ออกจากระบบ</button></div>
    </div>
  </div>

  <!-- แถบหมวดเมนู -->
  <div id="tabbar" class="flex flex-wrap gap-2 mb-5 bg-[#14141d] border border-gray-800 rounded-2xl p-2"></div>

  <!-- หมวด: เจนคีย์ -->
  <div data-tab="create" class="tab-panel">
    <div class="bg-[#14141d] border border-gray-800 p-5 rounded-2xl mb-5 grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <label class="block text-xs font-semibold text-purple-300 mb-2">1. จำนวนคนใช้สูงสุดต่อคีย์</label>
        <input id="max-uses" type="number" value="1" min="1" max="9999" class="w-full bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-3 text-sm">
      </div>
      <div>
        <label class="block text-xs font-semibold text-purple-300 mb-2">2. อายุคีย์</label>
        <select id="duration" class="w-full bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-3 text-sm">
          <option value="1">1 วัน</option><option value="2">2 วัน</option><option value="3">3 วัน</option>
          <option value="4">4 วัน</option><option value="5">5 วัน</option><option value="6">6 วัน</option>
          <option value="7">7 วัน</option><option value="30">1 เดือน</option><option value="60">2 เดือน</option>
          <option value="90">3 เดือน</option><option value="120">4 เดือน</option><option value="150">5 เดือน</option>
          <option value="365">1 ปี</option><option value="0">ถาวร (ตลอดชีพ)</option>
        </select>
      </div>
      <div>
        <label class="block text-xs font-semibold text-purple-300 mb-2">จำนวนคีย์ที่จะเจน / ชื่อโปรเจกต์</label>
        <div class="flex gap-2">
          <input id="count" type="number" value="1" min="1" max="50" class="w-20 bg-[#0c0c10] border border-gray-700 rounded-xl px-3 py-3 text-sm">
          <input id="name" placeholder="ชื่อโปรเจกต์ / ลูกค้า" class="flex-1 min-w-0 bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-3 text-sm">
        </div>
      </div>
      <div class="md:col-span-3">
        <label class="block text-xs font-semibold text-purple-300 mb-2">3. วางสคริปต์หลัก (Lua) — เก็บบนเซิร์ฟเวอร์ ส่งให้เฉพาะคนที่คีย์ผ่าน</label>
        <textarea id="script" rows="4" placeholder="print('NVEX Loader Connected!')" class="w-full bg-[#0c0c10] border border-gray-700 rounded-xl p-4 text-sm font-mono text-purple-300"></textarea>
      </div>
      <div class="md:col-span-3 grid grid-cols-1 md:grid-cols-3 gap-4 bg-[#0c0c10] border border-purple-900/50 rounded-xl p-4">
        <label class="flex items-center gap-2 text-sm"><input id="protect" type="checkbox" checked> 🛡️ ป้องกันหลายชั้น (เข้ารหัส 3 ชั้น + ตรวจจับ hook 4 จุด)</label>
        <label class="flex items-center gap-2 text-sm"><input id="kick" type="checkbox" checked> 🚪 เตะออกจากเกมเมื่อโดนจับได้</label>
        <div class="flex gap-2">
          <input id="sound" placeholder="Sound ID เสียงเตือน (ไม่ใส่ก็ได้)" class="flex-1 bg-[#14141d] border border-gray-700 rounded-lg px-3 py-2 text-sm">
          <button id="sound-test" type="button" class="bg-gray-700 px-3 py-2 rounded-lg text-xs whitespace-nowrap">🔊 ฟังตัวอย่าง</button>
        </div>
        <p class="md:col-span-3 text-xs text-gray-500">คนที่พยายาม hook/ดักสคริปต์ → ส่งรายงานเข้าแผง + คีย์ถูกระงับอัตโนมัติ + เล่นเสียง 4 วิ + เตะออก</p>
      </div>
      <button id="gen" class="md:col-span-3 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 font-bold py-4 rounded-xl text-sm">🚀 เจนคีย์ NVEX</button>
    </div>
  </div>

  <!-- หมวด: ประกาศ -->
  <div data-tab="announce" class="tab-panel">
    <div class="bg-gradient-to-br from-[#241a3d] to-[#14141d] border border-purple-500/50 p-5 rounded-2xl mb-5">
      <h2 class="text-lg font-bold text-purple-300 mb-1 flex items-center gap-2">📢 ส่งประกาศถึงลูกค้าทุกคนที่ออนไลน์</h2>
      <p class="text-xs text-gray-500 mb-4">ขึ้นเป็นการ์ดสวยๆ มุมบนจอ มีไอคอน ไล่สีม่วง-ชมพู พร้อมเลือกเสียงและเปิดให้ตอบกลับได้</p>
      <textarea id="announcement-text" rows="2" placeholder="เช่น อัปเดตสคริปต์เวอร์ชันใหม่แล้ว โหลดใหม่ได้เลย" class="w-full bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-3 text-sm mb-3"></textarea>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-3 mb-4">
        <label class="flex items-center gap-2 text-sm bg-[#0c0c10] border border-gray-700 rounded-xl px-3 py-2"><input id="ann-sound-on" type="checkbox"> 🔊 เล่นเสียงตอนประกาศขึ้น (แบบเสียงโดเนท)</label>
        <input id="ann-sound-id" placeholder="Sound ID (ใส่ถ้าเปิดเสียง)" class="bg-[#0c0c10] border border-gray-700 rounded-xl px-3 py-2 text-sm">
        <label class="flex items-center gap-2 text-sm bg-[#0c0c10] border border-gray-700 rounded-xl px-3 py-2"><input id="ann-reply-on" type="checkbox"> 💬 ให้ลูกค้าพิมพ์ตอบกลับได้</label>
      </div>
      <button id="announce-btn" class="w-full bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 px-6 py-3 rounded-xl text-sm font-bold">🚀 ส่งประกาศ</button>
    </div>
  </div>

  <!-- หมวด: ผู้เล่นออนไลน์ -->
  <div data-tab="players" class="tab-panel">
    <div class="bg-[#14141d] border border-gray-800 p-5 rounded-2xl mb-5">
      <h2 class="text-lg font-bold mb-3">👁️ ใครกำลังรันสคริปต์ NVEX อยู่ (เรียลไทม์ รีเฟรชทุก 5 วิ)</h2>
      <div class="overflow-x-auto"><table class="w-full text-left text-sm">
        <thead><tr class="border-b border-gray-800 text-gray-400 text-xs">
          <th class="py-2 px-3">สถานะ</th><th class="px-3">Username</th><th class="px-3">UserId</th><th class="px-3">PlaceId</th><th class="px-3">JobId</th><th class="px-3">คีย์</th><th class="px-3">เห็นล่าสุด</th><th class="px-3 text-center">วาร์ป</th></tr></thead>
        <tbody id="players"></tbody></table></div>
    </div>
  </div>

  <!-- หมวด: คีย์ทั้งหมด -->
  <div data-tab="keys" class="tab-panel">
    <div class="bg-[#14141d] border border-gray-800 p-5 rounded-2xl mb-5">
      <h2 class="text-lg font-bold mb-3">📋 รายการคีย์ทั้งหมดในระบบ NVEX</h2>
      <div class="overflow-x-auto"><table class="w-full text-left text-sm">
        <thead><tr class="border-b border-gray-800 text-gray-400 text-xs">
          <th class="py-2 px-3">Key Code</th><th class="px-3">โปรเจกต์</th><th class="px-3">อายุ / หมดเมื่อ</th><th class="px-3 text-center">ผู้ใช้</th><th class="px-3">สร้างโดย</th><th class="px-3 text-center">จัดการ</th></tr></thead>
        <tbody id="keys"></tbody></table></div>
    </div>
  </div>

  <!-- หมวด: ประวัติลูกค้า (ทุกคนเห็น) -->
  <div data-tab="custlog" class="tab-panel">
    <div class="bg-[#14141d] border border-gray-800 p-5 rounded-2xl mb-5">
      <h2 class="text-lg font-bold mb-3">🕑 ประวัติลูกค้า/คีย์ (ดูได้ทุกบัญชี)</h2>
      <p class="text-xs text-gray-500 mb-3">บันทึกการสร้าง/ลบ/ระงับ/รีเซ็ตคีย์ การตรวจจับการแกะสคริปต์ และคำตอบกลับประกาศจากลูกค้า</p>
      <div class="overflow-x-auto max-h-96 overflow-y-auto"><table class="w-full text-left text-xs">
        <thead><tr class="border-b border-gray-800 text-gray-400"><th class="py-2 px-2">เวลา</th><th class="px-2">ผู้ใช้</th><th class="px-2">การกระทำ</th><th class="px-2">รายละเอียด</th></tr></thead>
        <tbody id="cust-log-list"></tbody></table></div>
    </div>
  </div>

  <!-- หมวด: พูดคุยทีม + คีย์ส่วนรวม -->
  <div data-tab="chat" class="tab-panel">
    <div class="bg-[#14141d] border border-indigo-700/50 p-5 rounded-2xl mb-5">
      <h2 class="text-lg font-bold mb-3">💬 ห้องพูดคุยทีม (ทุกบัญชีคุยกันได้)</h2>
      <div id="chat-box" class="bg-[#0c0c10] border border-gray-800 rounded-xl p-3 h-72 overflow-y-auto mb-3 flex flex-col gap-3"></div>
      <div class="flex gap-2 items-end">
        <input id="chat-text" placeholder="พิมพ์ข้อความ..." class="flex-1 bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-2.5 text-sm">
        <label class="bg-gray-700 px-3 py-2.5 rounded-xl text-xs cursor-pointer whitespace-nowrap">📷 รูป<input id="chat-img" type="file" accept="image/*" class="hidden"></label>
        <button id="chat-send" class="bg-indigo-600 hover:bg-indigo-700 px-5 py-2.5 rounded-xl text-sm font-bold">ส่ง</button>
      </div>
      <p id="chat-img-name" class="text-xs text-gray-500 mt-1"></p>
    </div>

    <div class="bg-[#14141d] border border-yellow-700/40 p-5 rounded-2xl">
      <h2 class="text-lg font-bold mb-1 text-yellow-400">🔑 คีย์ส่วนรวมของห้องนี้</h2>
      <p class="text-xs text-gray-500 mb-3">คีย์ที่เจนจากช่องนี้เท่านั้นที่นับเป็นคีย์ส่วนรวม คีย์ที่เจนจากแท็บ "สร้างคีย์" ปกติจะไม่นับรวมที่นี่</p>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-3 mb-3">
        <input id="room-name" placeholder="ชื่อโปรเจกต์" class="bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-2.5 text-sm">
        <input id="room-maxuses" type="number" value="1" min="1" placeholder="จำนวนคนใช้สูงสุด" class="bg-[#0c0c10] border border-gray-700 rounded-xl px-4 py-2.5 text-sm">
      </div>
      <textarea id="room-script" rows="3" placeholder="วางสคริปต์สำหรับคีย์ส่วนรวม" class="w-full bg-[#0c0c10] border border-gray-700 rounded-xl p-3 text-sm font-mono text-purple-300 mb-3"></textarea>
      <button id="room-gen" class="bg-yellow-700 hover:bg-yellow-600 px-5 py-2.5 rounded-xl text-sm font-bold mb-4">➕ สร้างคีย์ส่วนรวม</button>
      <div class="overflow-x-auto"><table class="w-full text-left text-xs">
        <thead><tr class="border-b border-gray-800 text-gray-400"><th class="py-2 px-2">Key</th><th class="px-2">โปรเจกต์</th><th class="px-2">สร้างโดย</th><th class="px-2 text-center">ผู้ใช้</th></tr></thead>
        <tbody id="room-keys"></tbody></table></div>
    </div>
  </div>

  <!-- หมวด: บัญชีแอดมิน (เฉพาะ owner) -->
  <div data-tab="admins" class="tab-panel">
    <div class="bg-[#14141d] border border-red-500/40 p-5 rounded-2xl mb-5">
      <h2 class="text-lg font-bold mb-3 text-red-400">👑 [OWNER ONLY] จัดการบัญชีแอดมิน</h2>
      <div class="flex flex-wrap gap-2 mb-3">
        <input id="u-name" placeholder="ชื่อผู้ใช้ใหม่" class="flex-1 min-w-[140px] bg-[#0c0c10] border border-gray-700 rounded-lg px-3 py-2 text-sm">
        <input id="u-pass" placeholder="รหัสผ่าน (อย่างน้อย 4 ตัว)" class="flex-1 min-w-[140px] bg-[#0c0c10] border border-gray-700 rounded-lg px-3 py-2 text-sm">
        <button id="u-create" class="bg-red-700 px-4 py-2 rounded-lg text-sm font-bold">➕ สร้างบัญชีแอดมิน</button>
      </div>
      <div class="overflow-x-auto"><table class="w-full text-left text-sm">
        <thead><tr class="border-b border-gray-800 text-gray-400 text-xs"><th class="py-2 px-2">ชื่อผู้ใช้</th><th class="px-2">สิทธิ์</th><th class="px-2">สร้างเมื่อ</th><th class="px-2 text-center">จัดการ</th></tr></thead>
        <tbody id="u-list"></tbody></table></div>
    </div>
  </div>

  <!-- หมวด: ประวัติระบบทั้งหมด (เฉพาะ owner — ลึกกว่าของแอดมิน) -->
  <div data-tab="syslog" class="tab-panel">
    <div class="bg-[#14141d] border border-red-500/40 p-5 rounded-2xl">
      <h2 class="text-lg font-bold mb-3 text-red-400">🔒 [OWNER ONLY] ประวัติระบบทั้งหมด</h2>
      <p class="text-xs text-gray-500 mb-3">รวมทุกอย่าง: ล็อกอิน/ล็อกเอาท์ การสร้าง-ลบบัญชีแอดมิน และประวัติคีย์ทั้งหมด — ดูได้ลึกกว่าแอดมินทั่วไป</p>
      <div class="overflow-x-auto max-h-96 overflow-y-auto"><table class="w-full text-left text-xs">
        <thead><tr class="border-b border-gray-800 text-gray-400"><th class="py-2 px-2">เวลา</th><th class="px-2">ผู้ใช้</th><th class="px-2">การกระทำ</th><th class="px-2">รายละเอียด</th></tr></thead>
        <tbody id="audit-list"></tbody></table></div>
    </div>
  </div>

</div>

<script>
const $ = id => document.getElementById(id);
const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const fmt = t => t ? new Date(t).toLocaleString('th-TH') : '-';
let TOKEN = localStorage.getItem('nvex_token') || '';
let ME = { username: '', role: '' };
let DATA = { keys: [], now: Date.now(), onlineMs: 90000 };
let chatImageData = null;

const TABS = [
  { id: 'create', label: '🔑 สร้างคีย์', ownerOnly: false },
  { id: 'announce', label: '📢 ประกาศ', ownerOnly: false },
  { id: 'players', label: '👁️ ผู้เล่นออนไลน์', ownerOnly: false },
  { id: 'keys', label: '📋 คีย์ทั้งหมด', ownerOnly: false },
  { id: 'custlog', label: '🕑 ประวัติลูกค้า', ownerOnly: false },
  { id: 'chat', label: '💬 พูดคุย + คีย์ส่วนรวม', ownerOnly: false },
  { id: 'admins', label: '👑 บัญชีแอดมิน', ownerOnly: true },
  { id: 'syslog', label: '🔒 ประวัติระบบ', ownerOnly: true },
];

function buildTabs(isOwner) {
  $('tabbar').innerHTML = TABS.filter(t => !t.ownerOnly || isOwner).map(t =>
    `<button data-tab-btn="${t.id}" class="tab-btn px-4 py-2 rounded-xl text-sm font-bold bg-[#0c0c10] text-gray-400">${t.label}</button>`).join('');
  document.querySelectorAll('.tab-btn').forEach(b => b.onclick = () => switchTab(b.dataset.tabBtn));
  switchTab('create');
}
function switchTab(id) {
  document.querySelectorAll('.tab-panel').forEach(p => p.classList.toggle('hidden', p.dataset.tab !== id));
  document.querySelectorAll('.tab-btn').forEach(b => {
    const active = b.dataset.tabBtn === id;
    b.classList.toggle('bg-gradient-to-r', active); b.classList.toggle('from-purple-600', active); b.classList.toggle('to-indigo-600', active);
    b.classList.toggle('text-white', active); b.classList.toggle('bg-[#0c0c10]', !active); b.classList.toggle('text-gray-400', !active);
  });
  if (window.__chatPoll) { clearInterval(window.__chatPoll); window.__chatPoll = null; }
  if (id === 'custlog') refreshCustLog();
  if (id === 'admins') refreshUsers();
  if (id === 'syslog') refreshAudit();
  if (id === 'chat') { refreshChat(); window.__chatPoll = setInterval(refreshChat, 4000); }
}

async function api(p, body) {
  const r = await fetch('/api/admin/' + p, {
    method: body ? 'POST' : 'GET',
    headers: { 'x-session-token': TOKEN, 'content-type': 'application/json' },
    body: body ? JSON.stringify(body) : undefined
  });
  if (r.status === 401) { doLogout(false); return {}; }
  return r.json();
}

function showApp() { $('login-screen').classList.add('hidden'); $('app').classList.remove('hidden'); }
function showLogin(msg) { $('app').classList.add('hidden'); $('login-screen').classList.remove('hidden'); if (msg !== undefined) $('l-err').textContent = msg; }

function doLogout(callServer) {
  if (callServer) fetch('/api/auth/logout', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ token: TOKEN }) }).catch(() => {});
  TOKEN = ''; localStorage.removeItem('nvex_token'); showLogin('');
}

$('l-btn').onclick = async () => {
  $('l-err').textContent = '';
  const username = $('l-user').value.trim(), password = $('l-pass').value;
  if (!username || !password) return $('l-err').textContent = 'กรอกให้ครบ';
  const r = await fetch('/api/auth/login', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ username, password }) }).then(x => x.json());
  if (!r.ok) return $('l-err').textContent = r.msg || 'เข้าสู่ระบบไม่สำเร็จ';
  TOKEN = r.token; localStorage.setItem('nvex_token', TOKEN);
  ME = { username: r.username, role: r.role };
  afterLogin();
};
$('logout-btn').onclick = () => doLogout(true);

function afterLogin() {
  $('me-name').textContent = ME.username;
  $('me-role').textContent = ME.role === 'owner' ? 'เจ้าของระบบ' : 'แอดมิน';
  const isOwner = ME.role === 'owner';
  buildTabs(isOwner);
  showApp();
  refresh();
  if (window.__poll) clearInterval(window.__poll);
  window.__poll = setInterval(refresh, 5000);
}

// ---------- บัญชีแอดมิน (owner) ----------
async function refreshUsers() {
  const r = await api('users/list');
  if (!r.ok) return;
  $('u-list').innerHTML = r.users.map(u => `<tr class="border-b border-gray-800/50">
    <td class="py-2 px-2 font-bold">${esc(u.username)}</td>
    <td class="px-2">${u.role === 'owner' ? '👑 เจ้าของระบบ' : 'แอดมิน'}</td>
    <td class="px-2 text-gray-400">${fmt(u.createdAt)}</td>
    <td class="px-2 text-center">${u.role === 'owner' ? '-' : `<button data-u="${esc(u.username)}" class="u-del bg-red-700 px-2 py-1 text-xs rounded-lg">ลบ</button>`}</td></tr>`).join('') || '<tr><td colspan="4" class="py-3 text-center text-gray-500">ยังไม่มีบัญชีแอดมินเพิ่มเติม</td></tr>';
  document.querySelectorAll('.u-del').forEach(b => b.onclick = async () => {
    if (!confirm('ลบบัญชี ' + b.dataset.u + ' ?')) return;
    await api('users/delete', { username: b.dataset.u }); refreshUsers();
  });
}
$('u-create').onclick = async () => {
  const username = $('u-name').value.trim(), password = $('u-pass').value;
  const r = await api('users/create', { username, password });
  if (!r.ok) return alert(r.msg || 'ผิดพลาด');
  $('u-name').value = ''; $('u-pass').value = ''; alert('สร้างบัญชีแอดมินสำเร็จ'); refreshUsers();
};

// ---------- ประวัติลูกค้า (ทุกคน) กับ ประวัติระบบ (owner) ----------
async function refreshCustLog() {
  const r = await api('logs');
  if (!r.ok) return;
  $('cust-log-list').innerHTML = r.logs.map(l => `<tr class="border-b border-gray-800/40">
    <td class="py-1.5 px-2 text-gray-400">${fmt(l.t)}</td><td class="px-2 font-bold">${esc(l.user)}</td>
    <td class="px-2 text-purple-300">${esc(l.action)}</td><td class="px-2 text-gray-400">${esc(l.detail)}</td></tr>`).join('') || '<tr><td colspan="4" class="py-3 text-center text-gray-500">ยังไม่มีประวัติ</td></tr>';
}
async function refreshAudit() {
  const r = await api('audit');
  if (!r.ok) return;
  $('audit-list').innerHTML = r.logs.map(l => `<tr class="border-b border-gray-800/40">
    <td class="py-1.5 px-2 text-gray-400">${fmt(l.t)}</td><td class="px-2 font-bold">${esc(l.user)}</td>
    <td class="px-2 text-purple-300">${esc(l.action)}</td><td class="px-2 text-gray-400">${esc(l.detail)}</td></tr>`).join('') || '<tr><td colspan="4" class="py-3 text-center text-gray-500">ยังไม่มีประวัติ</td></tr>';
}

// ---------- แชททีม ----------
async function refreshChat() {
  const r = await api('chat/list');
  if (!r.ok) return;
  $('chat-box').innerHTML = r.messages.map(m => {
    const mine = m.user === ME.username;
    const readers = (m.readBy || []).filter(u => u !== m.user);
    return `<div class="flex flex-col ${mine ? 'items-end' : 'items-start'}">
      <div class="text-[10px] text-gray-500 mb-0.5">${esc(m.user)} • ${fmt(m.t)}</div>
      <div class="max-w-[80%] ${mine ? 'bg-indigo-700' : 'bg-[#1c1c28]'} rounded-xl px-3 py-2 text-sm">
        ${m.text ? `<div>${esc(m.text)}</div>` : ''}
        ${m.image ? `<img src="${m.image}" class="mt-1 rounded-lg max-h-48">` : ''}
      </div>
      <div class="text-[10px] text-gray-600 mt-0.5">${readers.length ? '✅ อ่านแล้วโดย ' + readers.map(esc).join(', ') : ''}</div>
    </div>`;
  }).join('') || '<div class="text-center text-gray-500 text-sm py-8">ยังไม่มีข้อความ เริ่มคุยกันได้เลย</div>';
  $('chat-box').scrollTop = $('chat-box').scrollHeight;
  refreshRoomKeys();
}
$('chat-img').onchange = () => {
  const file = $('chat-img').files[0];
  if (!file) { chatImageData = null; $('chat-img-name').textContent = ''; return; }
  if (file.size > 300000) { alert('รูปใหญ่เกินไป (ไม่เกิน ~300KB)'); $('chat-img').value = ''; return; }
  const reader = new FileReader();
  reader.onload = () => { chatImageData = reader.result; $('chat-img-name').textContent = '📎 แนบไฟล์: ' + file.name; };
  reader.readAsDataURL(file);
};
$('chat-send').onclick = async () => {
  const text = $('chat-text').value.trim();
  if (!text && !chatImageData) return alert('พิมพ์ข้อความหรือแนบรูปก่อน');
  const r = await api('chat/send', { text, image: chatImageData });
  if (!r.ok) return alert(r.msg || 'ส่งไม่สำเร็จ');
  $('chat-text').value = ''; chatImageData = null; $('chat-img').value = ''; $('chat-img-name').textContent = '';
  refreshChat();
};

// ---------- คีย์ส่วนรวมของห้องแชท ----------
function refreshRoomKeys() {
  const roomKeys = (DATA.keys || []).filter(k => k.room);
  $('room-keys').innerHTML = roomKeys.length ? roomKeys.map(k => `<tr class="border-b border-gray-800/40">
    <td class="py-1.5 px-2 font-mono text-yellow-400">${esc(k.key)}</td><td class="px-2 text-purple-300">${esc(k.name)}</td>
    <td class="px-2 text-gray-400">${esc(k.createdBy || '-')}</td><td class="px-2 text-center">${Object.keys(k.users || {}).length}/${k.maxUses}</td></tr>`).join('')
    : '<tr><td colspan="4" class="py-3 text-center text-gray-500">ยังไม่มีคีย์ส่วนรวมในห้องนี้</td></tr>';
}
$('room-gen').onclick = async () => {
  const script = $('room-script').value.trim();
  if (!script) return alert('วางสคริปต์ก่อน');
  const protectedScript = protect($('room-script').value, { sound: '', kick: true });
  const r = await api('create', {
    maxUses: $('room-maxuses').value, durationDays: '30', count: '1',
    name: $('room-name').value || 'คีย์ส่วนรวม', script: protectedScript, room: true
  });
  if (!r.ok) return alert(r.msg || 'ผิดพลาด');
  alert('🎉 สร้างคีย์ส่วนรวมสำเร็จ:\n' + r.keys.join('\n'));
  $('room-script').value = ''; $('room-name').value = '';
  refresh();
};

// ---------- ประกาศ ----------
$('announce-btn').onclick = async () => {
  const text = $('announcement-text').value.trim();
  if (!text) return alert('พิมพ์ข้อความก่อน');
  const soundOn = $('ann-sound-on').checked;
  const r = await api('announce', { text, sound: soundOn ? $('ann-sound-id').value : '', allowReply: $('ann-reply-on').checked });
  if (!r.ok) return alert(r.msg || 'ส่งไม่สำเร็จ');
  $('announcement-text').value = ''; alert('ส่งประกาศแล้ว');
};

// ---------- เสียงทดสอบ ----------
$('sound-test').onclick = () => {
  const id = $('sound').value.replace(/\D/g, '');
  if (!id) return alert('ใส่ Sound ID ก่อน (ตัวเลขจากลิงก์เสียงใน Roblox)');
  window.open('https://www.roblox.com/library/' + id, '_blank');
};

// ---------- ป้องกันสคริปต์หลายชั้น ----------
const rn = () => '_' + Math.random().toString(36).slice(2, 8);
const rk = () => Array.from({ length: 12 }, () => 1 + Math.floor(Math.random() * 254));
const enc = (txt, k) => { const b = new TextEncoder().encode(txt); let o = ''; for (let i = 0; i < b.length; i++) o += '\\' + String(b[i] ^ k[i % k.length]).padStart(3, '0'); return o; };

function protect(src, o) {
  const names = Array.from({ length: 10 }, rn);
  const [T, C, X, D, J1, J2] = names;
  const k1 = rk(), k2 = rk(), k3 = rk();
  const snd = o.sound ? `pcall(function() local s=Instance.new("Sound",workspace) s.SoundId="rbxassetid://${o.sound}" s.Volume=10 s.Looped=true s:Play() end)` : '';
  const kick = o.kick ? `pcall(function() game:GetService("Players").LocalPlayer:Kick("Tampering detected") end)` : '';
  const junk = `local ${J1}=0 for ${J2}=1,3 do ${J1}=${J1}+${J2} end`;
  const L3 = `local ${T},${C},${X}=...\n${C}()\n${junk}\n${src}`;
  const L2 = `local ${T},${C},${X},${D}=...\n${C}()\n${junk}\nlocal f=loadstring(${D}("${enc(L3, k3)}",{${k3}}))\n${C}()\nif f then f(${T},${C},${X}) end`;
  const L1 = `local ${T},${C},${X},${D}=...\n${C}()\nlocal f=loadstring(${D}("${enc(L2, k2)}",{${k2}}))\n${C}()\nif f then f(${T},${C},${X},${D}) end`;
  return `local ${X}=__X
local function ${D}(s,k) local b=(bit32 or bit).bxor local o={} for i=1,#s do o[i]=string.char(b(s:byte(i),k[(i-1)%#k+1])) end return table.concat(o) end
local function ${T}(why)
  pcall(function()
    if ${X} then
      local rq=(syn and syn.request) or (http and http.request) or http_request or request
      rq({Url=${X}.b.."/api/trap",Method="POST",Headers={["Content-Type"]="application/json"},Body=game:GetService("HttpService"):JSONEncode({key=${X}.k,hwid=${X}.h,username=game:GetService("Players").LocalPlayer.Name,reason=why})})
    end
  end)
  ${snd}
  task.wait(4)
  ${kick}
  while true do task.wait(1e3) end
end
local function ${C}()
  local bad=false
  pcall(function() if iscclosure and not iscclosure(loadstring) then bad=true end end)
  pcall(function() if checkcaller and not checkcaller() then bad=true end end)
  if bad then ${T}("hook") end
end
${C}()
local f=loadstring(${D}("${enc(L1, k1)}",{${k1}}))
${C}()
if f then f(${T},${C},${X},${D}) end
`;
}

function durLabel(d) {
  if (!d) return 'ถาวร';
  return ({30:'1 เดือน',60:'2 เดือน',90:'3 เดือน',120:'4 เดือน',150:'5 เดือน',365:'1 ปี'})[d] || d + ' วัน';
}

function render() {
  const { keys, now, onlineMs } = DATA;
  const rows = [];
  keys.forEach(k => Object.entries(k.users || {}).forEach(([h, u]) => rows.push({ k, h, u })));
  rows.sort((a, b) => b.u.lastSeen - a.u.lastSeen);
  const on = rows.filter(r => now - r.u.lastSeen < onlineMs).length;
  $('st-online').textContent = on; $('st-keys').textContent = keys.length;

  $('players').innerHTML = rows.length ? rows.map(({ k, h, u }) => {
    const online = now - u.lastSeen < onlineMs;
    return `<tr class="border-b border-gray-800/50">
      <td class="py-2 px-3">${online ? '<span class="text-green-400">🟢 ออนไลน์</span>' : '<span class="text-gray-500">⚫ ออฟไลน์</span>'}</td>
      <td class="px-3 font-bold">${esc(u.username)}</td><td class="px-3 text-gray-400">${esc(u.userId)}</td>
      <td class="px-3 text-gray-400">${esc(u.placeId)}</td><td class="px-3 text-gray-500 text-[10px] max-w-[90px] truncate" title="${esc(u.jobId)}">${esc(u.jobId)}</td>
      <td class="px-3 font-mono text-yellow-400 text-xs">${esc(k.key)}</td>
      <td class="px-3 text-gray-400 text-xs">${fmt(u.lastSeen)}</td>
      <td class="px-3 text-center"><button data-p="${esc(u.placeId)}" data-j="${esc(u.jobId)}" class="warp-btn bg-indigo-700 px-2 py-1 text-xs rounded-lg">📍 วาร์ป</button></td></tr>`;
  }).join('') : '<tr><td colspan="8" class="py-4 text-center text-gray-500">ยังไม่มีใครรัน NVEX Loader</td></tr>';

  document.querySelectorAll('.warp-btn').forEach(b => b.onclick = async () => {
    const code = `game:GetService("TeleportService"):TeleportToPlaceInstance(${b.dataset.p}, "${b.dataset.j}", game.Players.LocalPlayer)`;
    await navigator.clipboard.writeText(code);
    alert('คัดลอกสคริปต์วาร์ปแล้ว เอาไปรันในเกมของคุณเพื่อตามไปที่เซิร์ฟเวอร์เดียวกัน');
  });

  $('keys').innerHTML = keys.length ? keys.map(k => {
    const expired = k.expiresAt && now > k.expiresAt;
    const st = k.banned ? '<span class="text-red-400">ระงับ</span>' : expired ? '<span class="text-red-400">หมดอายุ</span>' : '';
    const alert_ = (k.tamper || []).length ? `<span class="text-red-400" title="${esc(k.tamper.map(t=>t.username+' '+t.reason).join(', '))}">🚨${k.tamper.length}</span>` : '';
    return `<tr class="border-b border-gray-800/50" data-k="${esc(k.key)}">
      <td class="py-2 px-3 font-mono text-yellow-400 font-bold">${esc(k.key)} ${st} ${alert_} ${k.room ? '<span class="text-indigo-400 text-[10px]">[ห้องแชท]</span>' : ''}</td>
      <td class="px-3 text-purple-300">${esc(k.name)}</td>
      <td class="px-3 text-gray-300 text-xs">${durLabel(k.durationDays)}<br><span class="text-gray-500">${k.activatedAt ? (k.expiresAt ? fmt(k.expiresAt) : 'ตลอดชีพ') : 'ยังไม่เริ่มใช้'}</span></td>
      <td class="px-3 text-center text-green-400 font-bold">${Object.keys(k.users).length} / ${k.maxUses}</td>
      <td class="px-3 text-gray-500 text-xs">${esc(k.createdBy || '-')}</td>
      <td class="px-3 text-center whitespace-nowrap">
        <button data-a="copy" class="bg-purple-600 px-2 py-1 text-xs rounded-lg">📋 โค้ด</button>
        <button data-a="reset" class="bg-gray-700 px-2 py-1 text-xs rounded-lg">รีเซ็ต</button>
        <button data-a="ban" class="bg-yellow-700 px-2 py-1 text-xs rounded-lg">${k.banned ? 'ปลด' : 'ระงับ'}</button>
        <button data-a="delete" class="bg-red-700 px-2 py-1 text-xs rounded-lg">ลบ</button></td></tr>`;
  }).join('') : '<tr><td colspan="6" class="py-4 text-center text-gray-500">ยังไม่มีคีย์ในระบบ NVEX</td></tr>';
}

async function refresh() {
  const r = await api('list');
  if (r.ok) { DATA = r; render(); if (!document.querySelector('[data-tab="chat"]').classList.contains('hidden')) refreshRoomKeys(); }
}

$('keys').addEventListener('click', async e => {
  const a = e.target.dataset.a; if (!a) return;
  const key = e.target.closest('tr').dataset.k;
  if (a === 'copy') {
    const code = `getgenv().Key = "${key}"\nloadstring(game:HttpGet("${location.origin}/api/loader"))()`;
    await navigator.clipboard.writeText(code); return alert('คัดลอกโค้ด NVEX Loader ให้ลูกค้าแล้ว');
  }
  if (a === 'delete' && !confirm('ลบคีย์นี้?')) return;
  if (a === 'reset' && !confirm('ล้างรายชื่อผู้ใช้ของคีย์นี้?')) return;
  await api(a, { key }); refresh();
});

$('gen').onclick = async () => {
  const rawScript = $('script').value;
  const finalScript = $('protect').checked && rawScript.trim()
    ? protect(rawScript, { sound: $('sound').value.replace(/\D/g, ''), kick: $('kick').checked })
    : rawScript;
  const r = await api('create', {
    maxUses: $('max-uses').value, durationDays: $('duration').value,
    count: $('count').value, name: $('name').value, script: finalScript
  });
  if (!r.ok) return alert(r.msg || 'ผิดพลาด');
  alert('🎉 สร้างคีย์ NVEX สำเร็จ:\n' + r.keys.join('\n'));
  refresh();
};

// ---------- เริ่มต้น ----------
if (TOKEN) {
  api('list').then(r => {
    if (r.ok) { ME = r.me; afterLogin(); } else { showLogin(''); }
  });
} else { showLogin(''); }
</script>
</body>
</html>
<script async src="/.netlify/scripts/hud?variant=public" data-nf-variant="public" data-netlify-site-id="acf6e687-c2df-42e8-8918-f36746804777" data-app-host="app.netlify.com" data-account-tier="free"></script>
