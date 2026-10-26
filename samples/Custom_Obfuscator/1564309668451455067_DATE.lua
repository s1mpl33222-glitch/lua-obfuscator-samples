<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>DATE | نظام تسليم الطلبات</title>
<style>
:root{--bg:#08090b;--panel:#111318;--panel2:#171a20;--line:#292d36;--text:#f5f6f8;--muted:#9da3af;--red:#f04452;--red2:#a90e25;--ok:#38c793;--warn:#ffcc66}
*{box-sizing:border-box}body{margin:0;background:radial-gradient(ellipse at top,#191b22 0,#08090b 48%);color:var(--text);font-family:system-ui,-apple-system,"Segoe UI",Tahoma,Arial,sans-serif;min-height:100vh}
button,input,textarea,select{font:inherit}button{cursor:pointer;border:0}a{color:inherit}
.wrap{width:min(1120px,calc(100% - 32px));margin:auto}.top{display:flex;justify-content:space-between;align-items:center;padding:22px 0;border-bottom:1px solid #ffffff12}
.brand{font-weight:950;font-size:24px;letter-spacing:3px}.brand span{color:var(--red)}.tag{font-size:12px;color:var(--muted);margin-top:3px}
.pill{border:1px solid var(--line);background:#ffffff08;color:#d9dce3;border-radius:999px;padding:8px 12px;font-size:12px}
main{padding:34px 0 64px}.hero{text-align:center;margin:24px auto 30px;max-width:620px}.eyebrow{color:#ff7a84;font-size:12px;letter-spacing:2px;font-weight:800}.hero h1{font-size:clamp(28px,5vw,44px);line-height:1.2;margin:10px 0}.hero p{color:var(--muted);line-height:1.9;margin:0}
.card{background:linear-gradient(145deg,#15171d,#0f1014);border:1px solid var(--line);border-radius:20px;padding:24px;box-shadow:0 18px 60px #0005}
.auth{max-width:460px;margin:auto}.tabs{display:grid;grid-template-columns:1fr 1fr;gap:8px;background:#090a0d;border:1px solid var(--line);border-radius:12px;padding:5px;margin-bottom:22px}.tab{padding:11px;border-radius:8px;color:var(--muted);background:transparent}.tab.active{background:#242730;color:white}
.field{display:block;margin:14px 0}.field span{display:block;font-size:13px;color:#c8cbd3;margin-bottom:8px}.field input,.field textarea,.field select{width:100%;border:1px solid #30343e;background:#090a0d;color:white;border-radius:11px;padding:13px 14px;outline:none}.field input:focus,.field textarea:focus{border-color:#e83e50;box-shadow:0 0 0 3px #e83e501c}
.btn{border-radius:11px;padding:13px 16px;font-weight:800;transition:.15s}.primary{background:linear-gradient(120deg,var(--red),var(--red2));color:white;width:100%;box-shadow:0 7px 24px #d91d3630}.primary:hover{filter:brightness(1.08);transform:translateY(-1px)}.secondary{background:#22252d;color:white;border:1px solid #373b46}.linkbtn{background:transparent;color:#ff7b85;padding:10px}.muted{color:var(--muted)}.small{font-size:12px;line-height:1.8}.hidden{display:none!important}
.note{padding:12px 14px;border:1px solid #5d4b23;background:#2a2110;color:#f5d89a;border-radius:12px;font-size:12px;line-height:1.8;margin-top:15px}
.msg{padding:12px 14px;border-radius:11px;margin:12px 0;font-size:13px;line-height:1.7}.msg.error{background:#39171d;border:1px solid #6e2631;color:#ffb6bd}.msg.success{background:#102b22;border:1px solid #205c48;color:#a5f2d2}
.dashhead{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:20px}.dashhead h2{margin:0}.grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px;margin:18px 0}.stat{background:#12141a;border:1px solid var(--line);border-radius:15px;padding:17px}.stat .label{color:var(--muted);font-size:12px}.stat .num{font-size:26px;font-weight:900;margin-top:7px;word-break:break-word}.layout{display:grid;grid-template-columns:1.1fr .9fr;gap:16px}.section-title{font-size:16px;margin:0 0 16px}.codebox{border:1px dashed #545a68;background:#090a0d;padding:13px;border-radius:12px;display:flex;align-items:center;justify-content:space-between;gap:8px;direction:ltr}.code{font-weight:900;letter-spacing:1px;color:#ff8089;overflow-wrap:anywhere}.row{display:flex;align-items:center;gap:10px;flex-wrap:wrap}.invoice-result{border:1px solid #2b654f;background:#10251e;padding:16px;border-radius:14px;margin-top:16px}.invoice-result h3{margin:0 0 8px}.product-content{white-space:pre-wrap;overflow-wrap:anywhere;line-height:1.9}.list{display:grid;gap:9px}.item{background:#0c0d11;border:1px solid #292d36;border-radius:12px;padding:13px}.itemtop{display:flex;justify-content:space-between;gap:8px;align-items:start}.badge{font-size:11px;padding:5px 8px;border-radius:999px;background:#282b34;color:#cdd0d9;white-space:nowrap}.badge.ok{background:#103628;color:#93f1c9}.badge.off{background:#40171d;color:#ffb8bf}.item p{margin:8px 0 0;color:var(--muted);font-size:12px;line-height:1.7}.item-actions{display:flex;gap:7px;flex-wrap:wrap;margin-top:10px}.item-actions button{font-size:12px;padding:7px 9px;border-radius:8px}
.footer{text-align:center;color:#747a86;font-size:11px;padding:24px 0;border-top:1px solid #ffffff10}
.admin-banner{border:1px solid #7a2633;background:linear-gradient(120deg,#30151b,#171116);padding:14px;border-radius:13px;margin-bottom:16px;color:#ffc3c8;font-size:13px;line-height:1.8}
.notice{padding:14px;border:1px solid var(--line);border-radius:12px;background:#0b0c10;line-height:1.8;color:#c8cbd3;font-size:13px}
@media(max-width:760px){.grid{grid-template-columns:repeat(2,minmax(0,1fr))}.layout{grid-template-columns:1fr}.card{padding:18px}.hero{margin-top:18px}.top{padding:17px 0}}

/* DATE PORTAL neon-red visual upgrade */
:root{
  --red:#ff294f;
  --red2:#b80f31;
  --line:#3a2029;
}
body{
  background:
    radial-gradient(ellipse at 50% -12%,#5a0b20 0%,#220b14 22%,transparent 53%),
    radial-gradient(circle at 0% 45%,#28081455 0,transparent 35%),
    radial-gradient(circle at 100% 72%,#3d071855 0,transparent 34%),
    #07070b;
  background-attachment:fixed;
}
body:before{
  content:"";
  position:fixed;inset:0;pointer-events:none;z-index:-1;
  background:linear-gradient(115deg,transparent 20%,#ff244708 48%,transparent 75%);
  animation:dateGlowSweep 10s ease-in-out infinite alternate;
}
@keyframes dateGlowSweep{
  from{opacity:.35;transform:translateX(-1%)}
  to{opacity:1;transform:translateX(1%)}
}
.top{border-bottom-color:#ff294f30}
.brand{
  text-shadow:0 0 8px #ff294f65,0 0 25px #ff294f38;
}
.brand span{
  color:#ff3158;
  text-shadow:0 0 7px #ff3158,0 0 20px #ff3158a8,0 0 42px #ff315866;
}
.pill{
  border-color:#ff294f48;
  box-shadow:0 0 18px #ff294f0d,inset 0 0 12px #ff294f08;
}
.hero .eyebrow{
  color:#ff8095;
  text-shadow:0 0 14px #ff294f70;
}
.hero h1{
  text-shadow:0 0 25px #ff294f25;
}
.card{
  position:relative;
  overflow:hidden;
  border-color:#54212f;
  background:linear-gradient(145deg,#171117f5,#0d0c12f5 68%,#130a10f5);
  box-shadow:0 18px 60px #0008,0 0 0 1px #ff294f08,0 0 32px #ff294f13;
}
.card:before{
  content:"";
  position:absolute;top:0;right:12%;left:12%;height:1px;
  background:linear-gradient(90deg,transparent,#ff365e,transparent);
  box-shadow:0 0 15px #ff294f;
  opacity:.8;
}
.tabs{border-color:#48202c;background:#0a080d}
.tab.active{
  background:linear-gradient(120deg,#6e142b,#35101d);
  box-shadow:inset 0 0 0 1px #ff486a50,0 0 18px #ff294f16;
  color:#fff;
}
.field input,.field textarea,.field select{
  border-color:#3d2831;
  transition:border-color .18s,box-shadow .18s,background .18s;
}
.field input:focus,.field textarea:focus,.field select:focus{
  border-color:#ff365d;
  background:#0e080d;
  box-shadow:0 0 0 3px #ff294f20,0 0 20px #ff294f12;
}
.primary{
  background:linear-gradient(110deg,#ff3158 0%,#d81740 55%,#9e0b2a 100%);
  box-shadow:0 7px 24px #ff214333,0 0 0 1px #ff8ba01c inset;
  transition:transform .18s,filter .18s,box-shadow .18s;
}
.primary:hover{
  filter:brightness(1.14);
  transform:translateY(-2px);
  box-shadow:0 9px 30px #ff214355,0 0 24px #ff294f25;
}
.secondary{border-color:#55303b}
.linkbtn{text-shadow:0 0 12px #ff294f50}
.stat{
  border-color:#42212b;
  background:linear-gradient(145deg,#171219,#0e0c12);
  box-shadow:inset 0 1px #ff294f0b,0 8px 22px #0002;
  transition:transform .18s,border-color .18s,box-shadow .18s;
}
.stat:hover{
  transform:translateY(-3px);
  border-color:#a32b48;
  box-shadow:0 10px 28px #0004,0 0 20px #ff294f12;
}
.stat .num{text-shadow:0 0 18px #ff294f1c}
.item{
  border-color:#34212a;
  background:linear-gradient(135deg,#111015,#0b0a0e);
  transition:border-color .18s,transform .18s;
}
.item:hover{border-color:#7b2a40;transform:translateY(-1px)}
.codebox{
  border-color:#8b3048;
  background:#10090f;
  box-shadow:inset 0 0 18px #ff294f0a;
}
.code{color:#ff8298;text-shadow:0 0 12px #ff294f50}
.admin-banner{
  border-color:#a72b47;
  background:linear-gradient(115deg,#3a101e,#1a0d15);
  box-shadow:0 0 22px #ff294f12,inset 0 1px #ffb1c015;
}
.badge.off{background:#45121f;color:#ffb7c5}
.footer{border-top-color:#ff294f20}
::selection{background:#ff294f55;color:#fff}
@media(prefers-reduced-motion:reduce){
  *,*:before,*:after{animation:none!important;transition:none!important;scroll-behavior:auto!important}
}

</style>
</head>
<body>
<div class="wrap">
<header class="top">
  <div><div class="brand">D<span>A</span>TE</div><div class="tag">نظام تسليم الطلبات</div></div>
  <div class="pill" id="topStatus">● النظام يعمل</div>
</header>
<main>
<section id="authScreen">
  <div class="hero"><div class="eyebrow">DATE CUSTOMER PORTAL</div><h1>طلباتك في مكان واحد</h1><p>سجّل دخولك لمتابعة طلباتك واستلام المنتجات باستخدام كود الفاتورة الخاص بك</p></div>
  <div class="card auth">
    <div class="tabs"><button class="tab active" id="loginTab" onclick="showAuth('login')">تسجيل الدخول</button><button class="tab" id="signupTab" onclick="showAuth('signup')">إنشاء حساب</button></div>
    <form id="loginForm">
      <label class="field"><span>اسم المستخدم</span><input id="loginName" autocomplete="username" required placeholder="اكتب اسم المستخدم"></label>
      <label class="field"><span>كلمة المرور</span><input id="loginPass" type="password" autocomplete="current-password" required placeholder="اكتب كلمة المرور"></label>
      <button class="btn primary" type="submit">تسجيل الدخول</button>
    </form>
    <form id="signupForm" class="hidden">
      <label class="field"><span>اسم المستخدم</span><input id="signupName" autocomplete="username" minlength="3" maxlength="30" required placeholder="3 أحرف على الأقل"></label>
      <label class="field"><span>كلمة المرور</span><input id="signupPass" type="password" autocomplete="new-password" minlength="8" required placeholder="8 أحرف على الأقل"></label>
      <label class="field"><span>تأكيد كلمة المرور</span><input id="signupConfirm" type="password" autocomplete="new-password" minlength="8" required placeholder="أعد كتابة كلمة المرور"></label>
      <button class="btn primary" type="submit">إنشاء حساب</button>
    </form>
    <div id="authMessage"></div>
    <div class="divider"></div>
    <button class="btn linkbtn" type="button" style="width:100%;margin-top:12px" onclick="showAdminLogin()">هل لديك تصريح؟</button>
    <div id="adminLogin" class="hidden">
      <form id="adminForm">
        <label class="field"><span>كود الإدارة</span><input id="adminCode" autocomplete="off" required placeholder="أدخل كود التصريح"></label>
        <button class="btn primary" type="submit">دخول الإدارة</button>
      </form>
    </div>
    </div>
    <div class="note">نسخة تجريبية للتصميم وتجربة الوظائف داخل هذا المتصفح فقط. لا تستخدم بيانات حقيقية أو كلمات مرور مهمة هنا. تحتاج النسخة المنشورة إلى خادم وقاعدة بيانات لتأمين الحسابات والفواتير فعليًا.</div>
  </div>
</section>

<section id="maintenanceScreen" class="hidden">
  <div class="hero"><div class="eyebrow">DATE SYSTEM</div><h1>الموقع تحت الصيانة</h1><p>نعمل على تحسين الخدمة حاليًا، يرجى المحاولة لاحقًا</p></div>
  <div class="card" style="max-width:500px;margin:auto;text-align:center"><icon></icon><p class="muted">تم تفعيل وضع الصيانة من الإدارة</p><button class="btn secondary" onclick="showAdminLogin()">دخول الإدارة</button><div id="maintAdmin" class="hidden"><button class="btn primary" onclick="showOnly('authScreen');showAuth('login')">العودة إلى تسجيل الدخول</button></div></div>
</section>

<section id="customerScreen" class="hidden">
  <div class="dashhead"><div><div class="eyebrow">لوحة العميل</div><h2 id="welcomeName">أهلًا بك</h2></div><button class="btn secondary" onclick="logout()">تسجيل الخروج</button></div>
  <div class="grid">
    <div class="stat"><div class="label">نقاط الولاء</div><div class="num" id="myPoints">0.00 ر.س</div></div>
    <div class="stat"><div class="label">طلباتي المستلمة</div><div class="num" id="myDelivered">0</div></div>
    <div class="stat"><div class="label">الفواتير المتاحة لي</div><div class="num" id="myAvailable">0</div></div>
    <div class="stat"><div class="label">حالة الحساب</div><div class="num" style="font-size:18px;color:var(--ok)">نشط</div></div>
  </div>
  <div class="layout">
    <div class="card">
      <h3 class="section-title">استلام طلبك</h3>
      <p class="muted small">أدخل كود الفاتورة الذي زودتك به الإدارة. إذا كانت الفاتورة مرتبطة بحساب آخر فلن تتمكن من استلامها.</p>
      <form id="redeemForm"><label class="field"><span>رقم الفاتورة أو كود المنتج</span><input id="invoiceCode" required placeholder="مثال DATE-58321"></label><button class="btn primary" type="submit">تأكيد واستلام المنتج</button></form>
      <div id="redeemMessage"></div><div id="productResult"></div>
    </div>
    <div class="card">
      <h3 class="section-title">كود حسابك التعريفي</h3>
      <p class="muted small">هذا المعرّف مرتبط بحسابك داخل النظام. لا تشارك كلمة مرورك مع أي شخص.</p>
      <div class="codebox"><span class="code" id="myIdCode">DATE-USER</span><button class="btn secondary" onclick="copyMyId()">نسخ</button></div>
      <h3 class="section-title" style="margin-top:22px">سجل استلاماتي</h3><div id="myHistory" class="list"><div class="muted small">ما عندك طلبات مستلمة حتى الآن</div></div>
    </div>
  </div>
</section>

<section id="adminScreen" class="hidden">
  <div class="dashhead"><div><div class="eyebrow">ADMIN CONTROL</div><h2>لوحة الإدارة</h2></div><div class="row"><button class="btn secondary" onclick="renderAdmin()">تحديث البيانات</button><button class="btn secondary" onclick="logout()">خروج</button></div></div>
  <div class="admin-banner">وضع تجريبي: بيانات الموقع محفوظة في هذا المتصفح فقط. أكواد الإدارة في هذا النموذج تجريبية فقط وليست وسيلة حماية صالحة للنشر.</div>
  <div class="grid">
    <div class="stat"><div class="label">الزيارات المسجلة بهذا المتصفح</div><div class="num" id="statVisits">0</div></div>
    <div class="stat"><div class="label">الحسابات المسجلة</div><div class="num" id="statUsers">0</div></div>
    <div class="stat"><div class="label">عدد الفواتير</div><div class="num" id="statInvoices">0</div></div>
    <div class="stat"><div class="label">تم التسليم</div><div class="num" id="statDelivered">0</div></div>
  </div>
  <div class="layout">
    <div class="card">
      <h3 class="section-title">إنشاء فاتورة جديدة</h3>
      <form id="createInvoiceForm">
        <label class="field"><span>كود الفاتورة (اتركه فارغًا للتوليد تلقائيًا)</span><input id="newInvoiceCode" placeholder="DATE-58321"></label>
        <label class="field"><span>ربط الفاتورة بحساب محدد</span><select id="invoiceOwner"><option value="">أي عميل مسجل (غير مربوطة)</option></select></label>
        <label class="field"><span>عنوان المنتج</span><input id="newProductTitle" required placeholder="مثال: اشتراك شهر"></label>
        <label class="field"><span>محتوى التسليم أو الرابط</span><textarea id="newProductContent" rows="4" required placeholder="اكتب النص أو رابط المنتج هنا"></textarea></label>
        <label class="field"><span>قيمة الشراء بالريال (لحساب الكاش باك)</span><input id="purchaseAmount" type="number" min="0" step="0.01" value="5" required></label>
        <button class="btn primary" type="submit">إنشاء الفاتورة</button>
      </form><div id="createInvoiceMessage"></div>
    </div>
    <div class="card">
      <h3 class="section-title">إعدادات النظام</h3>
      <div class="notice">تشغيل الصيانة يمنع العملاء من تسجيل الدخول أو إنشاء حسابات في هذا النموذج. تبقى الإدارة قادرة على الدخول من شاشة الصيانة.</div>
      <div class="row" style="margin-top:14px"><button class="btn primary" style="width:auto" id="maintenanceToggle" onclick="toggleMaintenance()">تفعيل الصيانة</button><span id="maintenanceLabel" class="badge">الصيانة متوقفة</span></div>
      <h3 class="section-title" style="margin-top:24px">الفواتير</h3><div id="invoiceList" class="list"></div>
    </div>
  </div>
  <div class="card" style="margin-top:16px">
    <h3 class="section-title">إدارة الحسابات</h3><div class="muted small" style="margin-bottom:12px">كلمات المرور لا تظهر هنا. النظام الحقيقي يجب أن يخزن تجزئات كلمات المرور فقط.</div>
    <label class="field"><span>البحث عن حساب بالمعرّف أو اسم المستخدم</span><input id="userSearch" type="search" placeholder="اكتب المعرّف مثل USER-ABC123 أو اسم المستخدم" autocomplete="off"></label>
    <div id="userSearchCount" class="muted small" style="margin-bottom:10px"></div>
    <div id="userList" class="list"></div>
  </div>
</section>
</main>
<footer class="footer">DATE · نظام تسليم الطلبات — نموذج أولي غير مخصص للإنتاج</footer>
</div>
<script>
const ADMIN_DEMO_CODES = ["DATE-7445829","DATE-4682110","DATE-9274482"]; // نموذج أولي فقط: لا تضع أسرار الإدارة في الواجهة عند النشر.
const $ = id => document.getElementById(id);
const getDB = () => { try { return JSON.parse(localStorage.getItem("datePortalDB")) || {users:[],invoices:[],visits:0,maintenance:false}; } catch { return {users:[],invoices:[],visits:0,maintenance:false}; } };
const saveDB = db => localStorage.setItem("datePortalDB", JSON.stringify(db));
window.addEventListener("storage",e=>{if(e.key==="datePortalDB"&&currentUser&&!isAdmin){renderCustomer()}});
let currentUser = null, isAdmin = false;
function uid(prefix="U"){return prefix+"-"+Math.random().toString(36).slice(2,8).toUpperCase()+Date.now().toString(36).slice(-3).toUpperCase()}
function money(n){return Number(n||0).toFixed(2)+" ر.س"}
function msg(id,text,type="error"){ $(id).innerHTML = text ? `<div class="msg ${type}">${escapeHTML(text)}</div>` : ""; }
function escapeHTML(s){return String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));}
function showOnly(id){["authScreen","maintenanceScreen","customerScreen","adminScreen"].forEach(x=>$(x).classList.toggle("hidden",x!==id))}
function showAuth(mode){$("loginForm").classList.toggle("hidden",mode!=="login");$("signupForm").classList.toggle("hidden",mode!=="signup");$("loginTab").classList.toggle("active",mode==="login");$("signupTab").classList.toggle("active",mode==="signup");msg("authMessage","");}
function showAdminLogin(){showOnly("authScreen");showAuth("login");$("adminLogin").classList.remove("hidden");$("adminCode").focus();}
function adminEnter(code){const val=String(code||"").trim();if(!ADMIN_DEMO_CODES.includes(val)){msg("authMessage","كود الإدارة غير صحيح");return false}isAdmin=true;currentUser=null;renderAdmin();showOnly("adminScreen");return true}
$("adminForm").addEventListener("submit",e=>{e.preventDefault();adminEnter($("adminCode").value)});
function logout(){currentUser=null;isAdmin=false;const db=getDB();$("topStatus").textContent=db.maintenance?"● الموقع تحت الصيانة":"● النظام يعمل";if(db.maintenance){showOnly("maintenanceScreen")}else{showOnly("authScreen");showAuth("login")}}
function updateStatus(){const db=getDB();$("topStatus").textContent=db.maintenance?"● الموقع تحت الصيانة":"● النظام يعمل";if(db.maintenance&&!isAdmin&&!currentUser)showOnly("maintenanceScreen")}
$("loginName").addEventListener("input",()=>{const adminCode=ADMIN_DEMO_CODES.includes($("loginName").value.trim());$("loginPass").closest(".field").classList.toggle("hidden",adminCode);$("loginPass").required=!adminCode;if(adminCode)$("loginPass").value=""});
$("loginForm").addEventListener("submit",e=>{e.preventDefault();const db=getDB();const rawName=$("loginName").value.trim();if(ADMIN_DEMO_CODES.includes(rawName)){adminEnter(rawName);return}if(db.maintenance){showOnly("maintenanceScreen");return}const name=rawName.toLowerCase(),pass=$("loginPass").value;const u=db.users.find(x=>x.name.toLowerCase()===name&&x.pass===pass);if(!u){msg("authMessage","اسم المستخدم أو كلمة المرور غير صحيحة");return}if(u.deleted){msg("authMessage","تم حذف حسابك من الإدارة");return}if(u.disabled){msg("authMessage",u.notice||"حسابك موقف من الإدارة — يرجى التواصل مع الدعم الفني");return}currentUser=u.id;renderCustomer();showOnly("customerScreen")});
$("signupForm").addEventListener("submit",e=>{e.preventDefault();const db=getDB();if(db.maintenance){showOnly("maintenanceScreen");return}const name=$("signupName").value.trim(),pass=$("signupPass").value,confirm=$("signupConfirm").value;if(pass!==confirm){msg("authMessage","كلمتا المرور غير متطابقتين");return}if(name.length<3||pass.length<8){msg("authMessage","تأكد من الاسم وأن كلمة المرور 8 أحرف على الأقل");return}if(db.users.some(x=>x.name.toLowerCase()===name.toLowerCase())){msg("authMessage","اسم المستخدم مستخدم مسبقًا");return}const u={id:uid("USER"),name,pass,points:0,disabled:false,deleted:false,notice:"",created:new Date().toISOString()};db.users.push(u);saveDB(db);currentUser=u.id;isAdmin=false;renderCustomer();showOnly("customerScreen");msg("authMessage","تم إنشاء الحساب بنجاح","success")});
function activeUser(){const db=getDB();return db.users.find(x=>x.id===currentUser&&!x.deleted)}
function renderCustomer(){const db=getDB(),u=activeUser();if(!u){logout();return}if(u.disabled){msg("authMessage",u.notice||"حسابك موقف من الإدارة");logout();return}$("welcomeName").textContent="أهلًا، "+u.name;$("myPoints").textContent=money(u.points);$("myIdCode").textContent=u.id;$("myDelivered").textContent=db.invoices.filter(i=>i.deliveredBy===u.id).length;$("myAvailable").textContent=db.invoices.filter(i=>!i.delivered&&(!i.ownerId||i.ownerId===u.id)).length;const hist=db.invoices.filter(i=>i.deliveredBy===u.id);$("myHistory").innerHTML=hist.length?hist.map(i=>`<div class="item"><div class="itemtop"><strong>${escapeHTML(i.title)}</strong><span class="badge ok">تم التسليم</span></div><p>الكود: ${escapeHTML(i.code)} · المكافأة: ${money(i.reward||0)}</p></div>`).join(""):'<div class="muted small">ما عندك طلبات مستلمة حتى الآن</div>'}
$("redeemForm").addEventListener("submit",e=>{e.preventDefault();const db=getDB(),u=activeUser(),code=$("invoiceCode").value.trim().toUpperCase();$("productResult").innerHTML="";if(!u||u.disabled||u.deleted){msg("redeemMessage","حسابك غير متاح");return}const inv=db.invoices.find(i=>i.code.toUpperCase()===code);if(!inv){msg("redeemMessage","كود الفاتورة غير صحيح");return}if(inv.disabled){msg("redeemMessage","هذا الكود معطل من الإدارة");return}if(inv.delivered){msg("redeemMessage","تم استلام هذه الفاتورة مسبقًا ولا يمكن استلامها مرة أخرى");return}if(inv.ownerId&&inv.ownerId!==u.id){msg("redeemMessage","هذه الفاتورة مرتبطة بحساب آخر");return}inv.delivered=true;inv.deliveredBy=u.id;inv.deliveredAt=new Date().toISOString();let reward=0;if(!inv.rewarded){reward=rewardFor(Number(inv.purchaseAmount)||0);u.points=Math.round((Number(u.points)||0)*100)/100;u.points=Math.round((u.points+reward)*100)/100;inv.reward=reward;inv.rewarded=true}saveDB(db);msg("redeemMessage","تم التحقق من الفاتورة بنجاح","success");$("productResult").innerHTML=`<div class="invoice-result"><h3>${escapeHTML(inv.title)}</h3><div class="product-content">${escapeHTML(inv.content)}</div><p class="small" style="color:#a5f2d2;margin-bottom:0">مكافأة هذه الفاتورة: ${money(reward)}</p></div>`;renderCustomer()});
function rewardFor(amount){
  // مكافأة عشوائية لكل فاتورة مستلمة من 0.01 إلى 0.30 ريال
  if(!Number.isFinite(amount)||amount<=0)return 0;
  return Math.round((0.01+Math.random()*0.29)*100)/100;
}
function copyMyId(){const text=$("myIdCode").textContent;navigator.clipboard?.writeText(text).then(()=>alert("تم نسخ الكود")).catch(()=>prompt("انسخ الكود",text))}
$("createInvoiceForm").addEventListener("submit",e=>{e.preventDefault();const db=getDB();let code=$("newInvoiceCode").value.trim().toUpperCase()||uid("DATE");if(db.invoices.some(i=>i.code.toUpperCase()===code)){msg("createInvoiceMessage","كود الفاتورة موجود مسبقًا");return}const ownerId=$("invoiceOwner").value;db.invoices.push({id:uid("INV"),code,title:$("newProductTitle").value.trim(),content:$("newProductContent").value.trim(),purchaseAmount:Number($("purchaseAmount").value)||0,ownerId:ownerId||null,delivered:false,deliveredBy:null,rewarded:false,reward:0,created:new Date().toISOString()});saveDB(db);$("createInvoiceForm").reset();$("purchaseAmount").value=5;msg("createInvoiceMessage","تم إنشاء الفاتورة: "+code,"success");renderAdmin()});
function renderAdmin(){const db=getDB();$("statVisits").textContent=db.visits;$("statUsers").textContent=db.users.filter(u=>!u.deleted).length;$("statInvoices").textContent=db.invoices.length;$("statDelivered").textContent=db.invoices.filter(i=>i.delivered).length;$("maintenanceLabel").textContent=db.maintenance?"الصيانة مفعلة":"الصيانة متوقفة";$("maintenanceToggle").textContent=db.maintenance?"إيقاف الصيانة":"تفعيل الصيانة";$("invoiceOwner").innerHTML='<option value="">أي عميل مسجل (غير مربوطة)</option>'+db.users.filter(u=>!u.deleted).map(u=>`<option value="${u.id}">${escapeHTML(u.name)} (${u.id})</option>`).join("");$("invoiceList").innerHTML=db.invoices.length?db.invoices.slice().reverse().map(i=>`<div class="item"><div class="itemtop"><div><strong>${escapeHTML(i.title)}</strong><p>الكود: <span class="code">${escapeHTML(i.code)}</span></p></div><span class="badge ${i.delivered?"ok":""}">${i.delivered?"تم التسليم":"غير مسلّمة"}</span></div><p>العميل: ${escapeHTML(db.users.find(u=>u.id===i.ownerId)?.name||"غير محدد")} · القيمة: ${money(i.purchaseAmount)}</p><div class="item-actions"><button class="secondary" onclick="copyInvoice('${i.id}')">نسخ الكود</button><button class="secondary" onclick="toggleInvoice('${i.id}')">${i.disabled?"إعادة تفعيل":"تعطيل الكود"}</button><button class="secondary" onclick="deleteInvoice('${i.id}')">حذف</button></div></div>`).join(""):'<div class="muted small">لا توجد فواتير حتى الآن</div>';renderUserList()}
function renderUserList(){const db=getDB(),query=($("userSearch")?.value||"").trim().toLocaleLowerCase();const users=db.users.filter(u=>!u.deleted);const filtered=users.filter(u=>!query||String(u.id||"").toLocaleLowerCase().includes(query)||String(u.name||"").toLocaleLowerCase().includes(query));$("userSearchCount").textContent=query?`تم العثور على ${filtered.length} من ${users.length} حساب`:`عدد الحسابات: ${users.length}`;$("userList").innerHTML=filtered.length?filtered.map(u=>`<div class="item"><div class="itemtop"><div><strong>${escapeHTML(u.name)}</strong><p>المعرّف: <span class="code">${escapeHTML(u.id)}</span> · النقاط: ${money(u.points)}</p></div><span class="badge ${u.disabled?"off":"ok"}">${u.disabled?"موقوف":"نشط"}</span></div><div class="item-actions"><button class="secondary" onclick="adjustPoints('${u.id}',1)">إضافة نقاط</button><button class="secondary" onclick="adjustPoints('${u.id}',-1)">خصم نقاط</button><button class="secondary" onclick="zeroPoints('${u.id}')">تصفير</button><button class="secondary" onclick="toggleUser('${u.id}')">${u.disabled?"تفعيل الحساب":"إيقاف الحساب"}</button><button class="secondary" onclick="setNotice('${u.id}')">رسالة للعميل</button><button class="secondary" onclick="deleteUser('${u.id}')">حذف الحساب</button></div></div>`).join(""):'<div class="muted small">'+(query?'ما لقينا حساب يطابق البحث':'لا توجد حسابات مسجلة')+'</div>'}
$("userSearch").addEventListener("input",renderUserList);
function copyInvoice(id){const i=getDB().invoices.find(x=>x.id===id);if(i){navigator.clipboard?.writeText(i.code).then(()=>alert("تم نسخ "+i.code)).catch(()=>prompt("انسخ الكود",i.code))}}
function toggleInvoice(id){const db=getDB(),i=db.invoices.find(x=>x.id===id);if(i){i.disabled=!i.disabled;saveDB(db);renderAdmin()}}
function deleteInvoice(id){if(!confirm("متأكد من حذف الفاتورة؟"))return;const db=getDB();db.invoices=db.invoices.filter(i=>i.id!==id);saveDB(db);renderAdmin()}
function adjustPoints(id,dir){const v=prompt(dir>0?"كم نقطة تبي تضيف؟":"كم نقطة تبي تخصم؟","0.50");if(v===null)return;const n=Number(v);if(!Number.isFinite(n)||n<0){alert("أدخل رقمًا صحيحًا");return}const db=getDB(),u=db.users.find(x=>x.id===id);if(u){u.points=Math.max(0,Math.round((u.points+dir*n)*100)/100);saveDB(db);renderAdmin()}}
function zeroPoints(id){if(!confirm("تصفير نقاط هذا الحساب؟"))return;const db=getDB(),u=db.users.find(x=>x.id===id);if(u){u.points=0;saveDB(db);renderAdmin()}}
function toggleUser(id){const db=getDB(),u=db.users.find(x=>x.id===id);if(u){u.disabled=!u.disabled;if(u.disabled)u.notice="حسابك موقف من الإدارة — يرجى التواصل مع الدعم الفني";saveDB(db);renderAdmin()}}
function setNotice(id){const db=getDB(),u=db.users.find(x=>x.id===id);if(!u)return;const n=prompt("اكتب الرسالة التي تظهر للعميل",u.notice||"");if(n!==null){u.notice=n;saveDB(db);renderAdmin()}}
function deleteUser(id){if(!confirm("سيتم حذف الحساب من العرض وتعطيل دخوله. متابعة؟"))return;const db=getDB(),u=db.users.find(x=>x.id===id);if(u){u.deleted=true;u.disabled=true;u.notice="تم حذف حسابك من الإدارة";saveDB(db);renderAdmin()}}
function toggleMaintenance(){const db=getDB();db.maintenance=!db.maintenance;saveDB(db);renderAdmin();updateStatus()}
(function init(){const db=getDB();db.visits=(db.visits||0)+1;saveDB(db);updateStatus();if(db.maintenance)showOnly("maintenanceScreen")})();
</script>
</body>
</html>
