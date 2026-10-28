<!doctype html>
<html lang="th">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Key System — Admin</title>
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Cdefs%3E%3ClinearGradient id='g' x1='0' y1='0' x2='1' y2='1'%3E%3Cstop offset='0' stop-color='%233fb6ff'/%3E%3Cstop offset='1' stop-color='%23c04dff'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='100' height='100' rx='18' fill='%2305050f'/%3E%3Cpath fill='url(%23g)' fill-rule='evenodd' d='M20 12H68L88 24V50L72 61L86 88H64L52 65H38V88H20ZM38 29H61L66 35V43L61 48H38Z'/%3E%3C/svg%3E">
<style>
:root{
  --bg:#05050f; --panel:#0a0a1c; --panel2:#101028; --line:#1d2050; --line2:#15183a;
  --text:#e8ebff; --muted:#8a91c4; --accent:#2f7bff; --accent2:#8a3ffc; --cyan:#3fb6ff; --magenta:#c04dff;
  --ok:#3df0b0; --warn:#ffb020; --bad:#ff4d5a; --red:#e02020;
  --grad:linear-gradient(135deg,var(--accent),var(--accent2));
  --mono:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;
  /* ชุดเดียวกันทั้งหน้า: ความสูง/รัศมีของปุ่ม ช่อง select input */
  --h:40px; --hs:32px; --r:8px; --rc:12px;
  --s1:4px; --s2:8px; --s3:12px; --s4:16px; --s5:24px; --s6:32px;
  --side:248px; --top:60px; --bar:62px; --sub:48px;
}
*{box-sizing:border-box;scrollbar-width:none}
*::-webkit-scrollbar{display:none}
html{scroll-behavior:smooth}
body{margin:0;background:var(--bg);color:var(--text);overflow-x:hidden;font-size:14px;line-height:1.55;
     font-family:"Noto Sans Thai",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif}
body::before{content:'';position:fixed;inset:0;pointer-events:none;z-index:0;
  background:radial-gradient(800px 380px at 10% -8%, rgba(47,123,255,.16), transparent 62%),
    radial-gradient(700px 360px at 96% 0%, rgba(138,63,252,.16), transparent 62%),
    linear-gradient(rgba(63,182,255,.03) 1px, transparent 1px) 0 0/40px 40px,
    linear-gradient(90deg, rgba(138,63,252,.03) 1px, transparent 1px) 0 0/40px 40px}
.hide{display:none!important}
.muted{color:var(--muted)}
.grow{flex:1}
.mono,code{font-family:var(--mono)}
h1,h2,h3,h4,p{margin:0}

/* ---------- controls ---------- */
button,input,select,textarea{font:inherit;border-radius:var(--r)}
button{height:var(--h);padding:0 var(--s4);cursor:pointer;border:1px solid transparent;background:var(--grad);color:#fff;
       white-space:nowrap;display:inline-flex;align-items:center;justify-content:center;gap:var(--s2)}
button:hover{filter:brightness(1.15)}
button:focus-visible,a:focus-visible,input:focus-visible{outline:2px solid var(--cyan);outline-offset:2px}
button.ghost{background:var(--panel2);color:var(--text);border-color:var(--line)}
button.ghost:hover{border-color:var(--cyan);filter:none}
button.danger{background:rgba(224,32,32,.12);color:#ff7b84;border-color:rgba(224,32,32,.5)}
button.danger:hover{background:rgba(224,32,32,.25);filter:none}
button.sm{height:var(--hs);padding:0 var(--s3);font-size:13px}
button.plain{height:auto;background:none;border:0;padding:0;color:inherit;text-align:left;justify-content:flex-start;white-space:normal;border-radius:0}
button.plain:hover{filter:none}
input,select,textarea{background:#07071a;border:1px solid var(--line);color:var(--text);padding:0 var(--s3);width:100%;outline:none;min-width:0}
input,select{height:var(--h)}
select{appearance:none;-webkit-appearance:none;cursor:pointer;padding-right:34px;text-overflow:ellipsis;
  background:#07071a url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%233fb6ff' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E") no-repeat right 11px center/14px}
select.dd-open{border-color:var(--cyan);box-shadow:0 0 0 1px var(--cyan)}
select.sm{height:var(--hs);width:auto;font-size:13px;padding:0 30px 0 var(--s2);background-position:right 9px center;background-size:12px}
select.auto{width:auto}
textarea{padding:var(--s3);font-family:var(--mono);font-size:13px;min-height:280px;resize:vertical;line-height:1.5}
#edSource{min-height:420px;white-space:pre;overflow:auto;tab-size:2}
#edCode{border:1px solid var(--line);border-radius:var(--r);overflow:hidden}
#edCode:focus-within{border-color:var(--cyan);box-shadow:0 0 0 1px var(--cyan)}
#edCode .CodeMirror{height:420px;min-height:200px;resize:vertical;font-family:var(--mono);font-size:13px;line-height:1.5;background:#07071a}
#edCode .CodeMirror-gutters{background:#0a0a1c;border-right:1px solid var(--line)}
textarea.short{min-height:84px;font-family:inherit;font-size:14px}
input:focus,select:focus,textarea:focus{border-color:var(--cyan);box-shadow:0 0 0 1px var(--cyan)}
input[type=checkbox]{width:18px;height:18px;padding:0;accent-color:var(--accent2);flex:none;margin:0}
input[type=color]{padding:4px}
input[type=number]{-moz-appearance:textfield;appearance:textfield}
input[type=number]::-webkit-inner-spin-button,input[type=number]::-webkit-outer-spin-button{-webkit-appearance:none;margin:0;display:none}
.chk{display:inline-flex;align-items:center;gap:var(--s2);height:var(--h);padding:0 var(--s3);margin:0;background:#07071a;border:1px solid var(--line);
     border-radius:var(--r);color:var(--text);white-space:nowrap;cursor:pointer;font-size:14px}
label{display:block;color:var(--muted);font-size:13px;margin:0 0 6px}
.chk{margin:0}
.hint{color:var(--muted);font-size:12.5px;margin-top:6px;line-height:1.55}

/* ---------- ฟอร์ม: label / ช่อง / hint อยู่ระดับเดียวกันทุกคอลัมน์ (subgrid) ---------- */
.fgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(210px,1fr));column-gap:var(--s4);row-gap:0;align-items:start}
.fld{display:grid;grid-row:span 3;grid-template-rows:subgrid;min-width:0;padding-bottom:var(--s4)}
.fld > label{align-self:end;margin:0 0 6px}
.fld > .hint{margin-top:6px;align-self:start}
.fld.wide{grid-column:span 2}
.fld.btn > label{visibility:hidden}
@media (max-width:560px){ .fgrid{grid-template-columns:minmax(0,1fr)} .fld.wide{grid-column:auto} }
.fgrid.one{grid-template-columns:minmax(0,1fr)} .fgrid.one .fld.wide{grid-column:auto}

/* ---------- การ์ด / บาร์ ---------- */
.card{background:rgba(10,10,28,.88);border:1px solid var(--line);border-radius:var(--rc);padding:var(--s4);margin-bottom:var(--s4);min-width:0}
.card > h3,.ch{font-size:15px;font-weight:700;color:#fff;margin-bottom:2px;display:flex;align-items:center;gap:var(--s2);flex-wrap:wrap}
.card .why{color:var(--muted);font-size:13px;margin:0 0 var(--s4)}
.bar{display:flex;gap:var(--s2);align-items:center;flex-wrap:wrap;margin-bottom:var(--s3)}
.bar.end{margin:var(--s3) 0 0}
.pill{display:inline-flex;align-items:center;padding:1px 8px;border-radius:6px;font-size:12px;line-height:20px;border:1px solid var(--line);font-family:var(--mono);white-space:nowrap}
.pill.ok{color:var(--ok);border-color:#14604a;background:rgba(61,240,176,.08)}
.pill.bad{color:var(--bad);border-color:rgba(224,32,32,.6);background:rgba(224,32,32,.12)}
.pill.warn{color:var(--warn);border-color:#5a4318;background:rgba(255,176,32,.08)}
.pill.tag{color:#b9c7ff;border-color:#2c3178;background:rgba(47,123,255,.1)}
.dot{width:9px;height:9px;border-radius:50%;background:var(--ok);box-shadow:0 0 10px var(--ok);flex:none;display:inline-block}
.empty{text-align:center;color:var(--muted);padding:var(--s5) var(--s4)!important;white-space:normal}
.empty b{color:var(--text);display:block}

/* ---------- ตาราง ---------- */
.tw{overflow:auto;max-width:100%;border:1px solid var(--line);border-radius:var(--r)}
table{width:100%;border-collapse:collapse;min-width:640px}
th,td{text-align:left;padding:10px var(--s3);border-bottom:1px solid var(--line2);font-size:14px;vertical-align:middle}
tbody tr:last-child td{border-bottom:0}
th{color:var(--cyan);font-weight:600;font-size:12.5px;background:rgba(16,16,40,.7);white-space:nowrap}
tbody tr:hover{background:rgba(47,123,255,.07)}
td.nw{white-space:nowrap}
td.note{max-width:240px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
@media (max-width:700px){ table.cards td.note{max-width:none;white-space:normal} }
.keycell{display:flex;align-items:center;gap:var(--s2);white-space:nowrap}
.tags{display:flex;gap:4px;flex-wrap:wrap}

/* ---------- ต้องดูแล ---------- */
.attn{display:flex;flex-direction:column;gap:var(--s2)}
.attn-item{display:flex;align-items:center;gap:var(--s3);width:100%;padding:var(--s3) var(--s4);border:1px solid var(--line);
           border-radius:var(--r);background:var(--panel);border-left-width:3px;cursor:pointer;color:var(--text);text-align:left}
.attn-item:hover{background:rgba(47,123,255,.1);border-color:var(--cyan);filter:none}
.attn-item.warn{border-left-color:var(--warn)} .attn-item.bad{border-left-color:var(--red)} .attn-item.ok{border-left-color:var(--ok);cursor:default}
.attn-item .t{flex:1;min-width:0}
.attn-item .t b{color:#fff}
.attn-item .t small{display:block;color:var(--muted);font-size:13px}
.attn-item .go{color:var(--cyan);font-size:13px;white-space:nowrap}
.maintrow{display:flex;align-items:center;gap:var(--s3);flex-wrap:wrap;margin-top:var(--s3);padding-top:var(--s3);border-top:1px solid var(--line2)}
.maintrow .t{flex:1 1 220px;color:var(--muted);font-size:13px}

/* ---------- รายการ key: ตัวกรอง + แบ่งหน้า ---------- */
.filters{display:grid;grid-template-columns:minmax(0,1fr) 200px 190px;gap:var(--s2);margin-bottom:var(--s3)}
@media (max-width:760px){ .filters{grid-template-columns:minmax(0,1fr) minmax(0,1fr)} .filters #q{grid-column:1/-1} }
.chips{display:flex;gap:var(--s2);overflow-x:auto;flex-wrap:nowrap;margin-bottom:var(--s3);padding-bottom:2px}
.chip{flex:none;display:inline-flex;align-items:center;gap:6px;height:var(--hs);background:var(--panel);border:1px solid var(--line);border-radius:var(--r);
      padding:0 var(--s3);font-size:13px;cursor:pointer;white-space:nowrap}
.chip:hover{border-color:var(--cyan)}
.chip.on{border-color:transparent;color:#fff;background:var(--grad)}
.chip b{color:var(--cyan);font-family:var(--mono);font-weight:600}
.chip.on b{color:#fff}
.pager{display:flex;align-items:center;gap:var(--s3);flex-wrap:wrap;margin-top:var(--s3)}
.pager .info{color:var(--muted);font-size:13px;flex:1 1 180px}
.pager .pg{display:flex;gap:4px;flex-wrap:wrap;align-items:center}
.pager .pg button{height:var(--hs);min-width:var(--hs);padding:0 var(--s2);font-size:13px}
.pager .pg button.cur{background:var(--grad);border-color:transparent;color:#fff}
.pager .pg .gap{color:var(--muted);padding:0 4px}
.pager .pg button:disabled{opacity:.35;cursor:default;filter:none}
.pager .per{display:flex;align-items:center;gap:var(--s2);color:var(--muted);font-size:13px}
.pager .per select{height:var(--hs);width:auto;font-size:13px}

/* ---------- เลือกหมวด (popover ควบคุมความสูงเอง) ---------- */
.msel{position:relative}
.msel-btn{width:100%;justify-content:space-between;background:#07071a;border:1px solid var(--line);color:var(--text);font-weight:400;padding:0 var(--s3)}
.msel-btn:hover{border-color:var(--cyan);filter:none}
.msel-btn .lbl{overflow:hidden;text-overflow:ellipsis}
.msel-btn svg,.menubtn svg{width:16px;height:16px;flex:none;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;color:var(--muted)}
.msel.open .msel-btn{border-color:var(--cyan);box-shadow:0 0 0 1px var(--cyan)}
.msel-pop{position:fixed;left:0;top:0;width:280px;max-width:calc(100vw - 16px);z-index:90;box-sizing:border-box;background:var(--panel2);
          border:1px solid var(--cyan);border-radius:var(--rc);padding:var(--s2);box-shadow:0 12px 40px rgba(0,0,0,.6)}
.msel-pop input[type=search]{height:var(--hs);margin-bottom:var(--s2);font-size:13px}
/* ความสูงเท่ากับจำนวนแถวเต็ม ๆ (6 แถว) ไม่ตัดครึ่งบรรทัด */
.msel-list{max-height:calc(var(--h) * 6);overflow-y:auto;scroll-snap-type:y mandatory}
.msel-list label{display:flex;align-items:center;gap:var(--s3);height:var(--h);margin:0;padding:0 var(--s2);color:var(--text);font-size:14px;cursor:pointer;
                 border-radius:var(--r);scroll-snap-align:start}
.msel-list label:hover{background:rgba(47,123,255,.12)}
.msel-list label[hidden]{display:none}
.msel-list .none{height:var(--h);display:flex;align-items:center;padding:0 var(--s2);color:var(--muted)}
.msel-foot{display:flex;align-items:center;gap:var(--s2);margin-top:var(--s2);padding-top:var(--s2);border-top:1px solid var(--line)}
.msel-foot span{flex:1;color:var(--muted);font-size:13px}

/* ---------- เมนูลอย (จัดการหมู่ / จัดการ key) ---------- */
.fmenu{position:fixed;z-index:95;min-width:220px;max-width:calc(100vw - 16px);background:var(--panel2);border:1px solid var(--cyan);border-radius:var(--rc);
       padding:var(--s1);box-shadow:0 12px 40px rgba(0,0,0,.6)}
.fmenu button{width:100%;justify-content:flex-start;height:var(--h);background:none;border:0;border-radius:var(--r);color:var(--text);padding:0 var(--s3);font-size:14px}
.fmenu button:hover{background:rgba(47,123,255,.15);filter:none}
.fmenu button.danger{color:#ff7b84;background:none}
.fmenu button.danger:hover{background:rgba(224,32,32,.2)}
.fmenu hr{border:0;border-top:1px solid var(--line);margin:var(--s1) 0}
.fmenu .cap{padding:var(--s1) var(--s3);font-size:12px;color:var(--muted)}
.opts{position:relative}
.opts-pop{position:absolute;right:0;top:calc(100% + 6px);z-index:70;width:280px;max-width:calc(100vw - 24px);background:var(--panel2);border:1px solid var(--cyan);
          border-radius:var(--rc);padding:var(--s3);box-shadow:0 12px 40px rgba(0,0,0,.6);display:flex;flex-direction:column;gap:var(--s2)}
.opts-pop .chk{width:100%}
.opts-pop .row2{display:grid;grid-template-columns:1fr auto;gap:var(--s2);align-items:center}


/* ---------- เลือกหลายใบ (checkbox) + แถบจัดการ ---------- */
.tap th.chk,.tap td.chk{width:34px;padding-left:var(--s3);padding-right:0}
.tap input[type=checkbox].rowchk,.tap th.chk input{width:16px;height:16px;cursor:pointer;accent-color:var(--cyan)}
.tap tr.sel>td{background:rgba(34,211,238,.10);box-shadow:inset 0 1px 0 rgba(34,211,238,.35),inset 0 -1px 0 rgba(34,211,238,.35)}
.tap tr.sel>td:first-child{box-shadow:inset 3px 0 0 var(--cyan),inset 0 1px 0 rgba(34,211,238,.35),inset 0 -1px 0 rgba(34,211,238,.35)}
.selbar{position:sticky;top:8px;z-index:20;display:flex;align-items:center;gap:var(--s2);flex-wrap:wrap;margin-bottom:var(--s3);
        padding:var(--s2) var(--s3);background:var(--panel2);border:1px solid var(--cyan);border-radius:var(--rc);box-shadow:0 8px 28px rgba(0,0,0,.45)}
.selbar b{font-family:var(--mono);color:var(--cyan)}
.selbar .grow{flex:1}
.selbar button.danger{background:var(--bad);border-color:transparent;color:#fff}
#selModal{position:fixed;inset:0;z-index:200;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,.6);padding:16px}
#selModal .box{width:460px;max-width:100%;background:var(--panel);border:1px solid var(--line);border-radius:var(--rc);padding:var(--s4);box-shadow:0 20px 60px rgba(0,0,0,.7)}
#selModal .box.danger{border-color:var(--bad)}
#selModal ul{margin:var(--s2) 0;padding-left:20px;font-family:var(--mono);font-size:13px;color:var(--muted)}
#selModal .warnline{color:var(--bad);font-weight:600;margin:var(--s2) 0}
/* ชื่อผู้เล่น Roblox (ลิงก์โปรไฟล์) + ปุ่มเตือน key ที่ใช้หลายบัญชี */
a.rbx{color:var(--acc,#7aa8ff);text-decoration:none;font-weight:600;word-break:break-all}
a.rbx:hover{text-decoration:underline}
button.warnbtn{color:var(--warn);border-color:#5a4318}
/* ---------- log ---------- */
.log{font-family:var(--mono);font-size:12.5px;background:#04040c;border:1px solid var(--line);border-radius:var(--r);padding:var(--s1) var(--s3)}
.log{container-type:inline-size}
.lrow{display:grid;grid-template-columns:112px 84px minmax(0,1fr) minmax(0,1.2fr);grid-template-areas:"tm ev kv dt";gap:var(--s3);align-items:center;
      cursor:pointer;padding:7px 0;border-bottom:1px dashed var(--line2);min-width:0}
.lrow:last-child{border-bottom:0}
.lrow:hover{background:rgba(47,123,255,.06)}
.lrow > span{min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.lrow .tm{grid-area:tm;color:var(--muted)} .lrow .kv{grid-area:kv} .lrow .dt{grid-area:dt;color:var(--muted)}
.lrow .ev{grid-area:ev;font-weight:600}
.lrow.ok .ev{color:var(--ok)} .lrow.bad .ev{color:var(--bad)}
@container (max-width:560px){
  .lrow{grid-template-columns:minmax(0,1fr) auto;grid-template-areas:"kv ev" "dt tm";row-gap:0}
  .lrow .tm{text-align:right}
}


.sg{scroll-margin-top:calc(var(--top) + 40px);margin-bottom:var(--s5);display:grid;grid-template-columns:minmax(0,1fr);gap:0 var(--s4);align-items:start}
@container (min-width:960px){ .sg{grid-template-columns:repeat(2,minmax(0,1fr))} }
.sg > .sgh,.sg > .sgp{grid-column:1/-1}
.sg > .sgh{font-size:17px;font-weight:700;color:#fff;margin-bottom:2px}
.sg > .sgp{color:var(--muted);font-size:13px;margin-bottom:var(--s3)}
.jump{display:flex;gap:var(--s2);flex-wrap:wrap;margin-bottom:var(--s4)}
.jump a{display:inline-flex;align-items:center;height:var(--hs);padding:0 var(--s3);border:1px solid var(--line);border-radius:var(--r);color:var(--muted);
        text-decoration:none;font-size:13px;background:var(--panel)}
.jump a:hover{color:#fff;border-color:var(--cyan)}
.card .sub{font-size:15px;font-weight:700;color:#fff;margin:0 0 var(--s3)}
.savebar{position:sticky;bottom:var(--s3);z-index:20;display:flex;gap:var(--s2);align-items:center;flex-wrap:wrap;padding:var(--s3) var(--s4);
         background:rgba(10,10,28,.96);border:1px solid var(--accent);border-radius:var(--rc)}
.anchor{scroll-margin-top:calc(var(--top) + 64px)}

/* ---------- login / toast ---------- */
.center{position:relative;z-index:1;max-width:380px;margin:12vh auto;padding:0 var(--s4)}
.brandmark{text-align:center;margin-bottom:var(--s3)}
.brandmark .logo{width:76px;height:76px}
.logo{flex:none;filter:drop-shadow(0 0 8px rgba(47,123,255,.8))}
.toast{position:fixed;right:var(--s4);bottom:var(--s4);max-width:calc(100vw - 32px);background:var(--panel2);border:1px solid var(--cyan);padding:10px var(--s4);
       border-radius:var(--r);opacity:0;transition:.25s;pointer-events:none;z-index:99}
.toast.on{opacity:1}


/* ---------- dropdown ของเราเอง (แทนของเบราว์เซอร์) ---------- */
.dd{position:fixed;z-index:96;overflow:auto;max-height:min(320px,60dvh);background:var(--panel2);border:1px solid var(--cyan);border-radius:var(--rc);
    padding:var(--s1);box-shadow:0 10px 30px rgba(0,0,0,.6),0 0 16px rgba(47,123,255,.25);animation:ddin .12s ease-out}
@keyframes ddin{from{opacity:0;transform:translateY(-4px)}to{opacity:1;transform:none}}
.dd button{display:flex;width:100%;justify-content:flex-start;align-items:center;gap:var(--s2);height:var(--h);background:none;border:0;color:var(--text);
    padding:0 var(--s3);font-size:14px;text-align:left;border-radius:var(--r);white-space:normal}
.dd button:hover,.dd button:focus-visible{background:rgba(47,123,255,.18);filter:none;outline:none}
.dd button.on{color:#fff;background:rgba(47,123,255,.12)}
.dd button.on::after{content:'✓';margin-left:auto;color:var(--cyan)}
.dd button:disabled{opacity:.4}
.dd-bg{position:fixed;inset:0;z-index:95;background:rgba(0,0,0,.6)}
@media (max-width:800px){
  .dd.m{left:0 !important;right:0;top:auto !important;bottom:0;width:100%;max-height:70dvh;border-radius:var(--rc) var(--rc) 0 0;
        padding:var(--s2) var(--s2) calc(var(--s2) + env(safe-area-inset-bottom));animation:sheetUp .2s cubic-bezier(.16,1,.3,1)}
  .dd.m button{height:50px;font-size:15px}
}

/* ---------- หัวการ์ด: ชื่อ + ตัวนับ + เครื่องมือ (ทุกการ์ดใช้แบบเดียวกัน) ---------- */
.chead{display:flex;align-items:center;gap:var(--s2);flex-wrap:wrap;min-height:var(--hs);margin-bottom:var(--s3)}
.chead h3{font-size:15px;font-weight:700;color:#fff;display:flex;align-items:center;gap:var(--s2);margin:0}
.chead .tools{display:flex;gap:var(--s2);flex-wrap:wrap}
.chead .tools input{width:230px}
@media (max-width:560px){ .chead .tools{width:100%} .chead .tools input{flex:1;width:auto} }
.sm.muted,.muted.sm{font-size:13px}
input.sm{height:var(--hs);font-size:13px}
.empty-box{padding:var(--s5) var(--s3);text-align:center;color:var(--muted);border:1px dashed var(--line);border-radius:var(--r);
           display:flex;flex-direction:column;align-items:center;gap:var(--s3)}

/* ---------- ภาพรวม: ตัวเลข 6 ใบ ไม่มีใบโดด (2 / 3 / 6 คอลัมน์ ตามความกว้างพื้นที่เนื้อหา) ---------- */
.kpis{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:var(--s3);margin-bottom:var(--s4)}
@container (min-width:620px){ .kpis{grid-template-columns:repeat(3,minmax(0,1fr))} }
@container (min-width:1080px){ .kpis{grid-template-columns:repeat(6,minmax(0,1fr))} }
.kpi{position:relative;overflow:hidden;display:flex;flex-direction:column;align-items:flex-start;justify-content:flex-start;gap:2px;height:auto;min-height:116px;
     padding:var(--s3) var(--s4);background:rgba(10,10,28,.88);color:var(--text);border:1px solid var(--line);border-radius:var(--rc);text-align:left;white-space:normal}
.kpi::before{content:'';position:absolute;left:0;right:0;top:0;height:2px;background:var(--line)}
.kpi:hover{border-color:var(--cyan);filter:none;background:rgba(47,123,255,.08)}
.kpi .k{color:var(--muted);font-size:13px}
.kpi b{font:700 28px/1.2 var(--mono);color:#fff}
.kpi small{color:var(--muted);font-size:12px;margin-top:auto;line-height:1.4}
.kpi.ok::before{background:var(--ok)} .kpi.ok b{color:var(--ok)}
.kpi.warn::before{background:var(--warn)} .kpi.warn b{color:var(--warn)}
.kpi.bad::before{background:var(--bad)} .kpi.bad b{color:var(--bad)}

/* ---------- 2 คอลัมน์เท่ากัน (ยุบเป็นคอลัมน์เดียวเมื่อพื้นที่แคบ) การ์ดในแถวสูงเท่ากัน ---------- */
.cols{display:grid;grid-template-columns:minmax(0,1fr);gap:var(--s4);margin-bottom:var(--s4);align-items:stretch}
@container (min-width:900px){ .cols{grid-template-columns:repeat(2,minmax(0,1fr))} .cols.wide-first{grid-template-columns:minmax(0,1.7fr) minmax(0,1fr)} }
.cols > .card{margin:0;display:flex;flex-direction:column}

/* ---------- key ตามสคริปต์ (แท่ง) ---------- */
.bars{display:grid;grid-template-columns:minmax(0,1fr);gap:2px var(--s5)}
@container (min-width:900px){ .bars{grid-template-columns:repeat(2,minmax(0,1fr))} }
button.brow{display:grid;grid-template-columns:minmax(0,1fr) minmax(60px,1.1fr) 56px;align-items:center;gap:var(--s3);padding:7px var(--s2);border-radius:var(--r);width:100%}
button.brow:hover{background:rgba(47,123,255,.08)}
.brow .n{overflow:hidden;text-overflow:ellipsis;white-space:nowrap;display:flex;align-items:center;gap:6px}
.brow .b{height:8px;border-radius:4px;background:var(--line2);overflow:hidden}
.brow .b i{display:block;height:100%;background:var(--grad);border-radius:4px}
.brow > b{text-align:right;font-family:var(--mono);color:#fff}

/* ---------- คนที่กำลังใช้งาน ---------- */
.olist{display:flex;flex-direction:column;gap:var(--s2)}
.olist .more{align-self:flex-start}
.online{display:grid;grid-template-columns:repeat(auto-fill,minmax(min(100%,380px),1fr));gap:var(--s2)}
.orow{display:flex;flex-direction:column;gap:var(--s2);padding:var(--s3);border:1px solid var(--line);border-radius:var(--rc);min-width:0}
.orow .otop{display:flex;align-items:center;gap:var(--s3);min-width:0}
.ochips{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:var(--s2)}
@media (min-width:1180px){.ochips{grid-template-columns:repeat(4,minmax(0,1fr))}}
.oc{display:flex;flex-direction:column;gap:2px;min-width:0;padding:6px 8px;border-radius:8px;background:rgba(255,255,255,.03)}
.oc small{color:var(--muted);font-size:11px}.oc b{font-size:13px;font-weight:600;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.oc b small{display:block;font-weight:400;color:var(--muted);font-size:11px}
.orow .av{flex:none;width:32px;height:32px;border-radius:50%;display:grid;place-items:center;color:#fff;font-weight:700}
.orow .t{flex:1;min-width:0}.orow .t b,.orow .t small{display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.orow .t small{color:var(--muted);font-size:12px}

/* ===== C · แนะนำทีละขั้น: แถบไอคอนพับได้, การ์ดทางลัด, คำแนะนำบรรทัดเดียว ===== */
:root{ --r:10px; --rc:16px; --rail:76px }
/* โครงสร้าง: .shell (กว้างเต็มจอ) > .side (fixed ซ้าย) + .main (เว้นซ้ายเท่าความกว้าง side) > .container (กึ่งกลาง) > topbar + page */
.shell{--sw:var(--side);position:relative;z-index:1;display:block;width:100%;min-height:100vh}
.shell.rail{--sw:var(--rail)}
.side{position:fixed;top:0;left:0;bottom:0;width:var(--sw);transition:width .25s cubic-bezier(.4,0,.2,1);display:flex;flex-direction:column;padding:var(--s4) var(--s3);background:rgba(8,8,22,.94);border-right:1px solid var(--line);z-index:50}
.brand{display:flex;align-items:center;gap:var(--s3);padding:0 9px var(--s3);min-height:56px;transition:gap .25s}
.brand .logo{width:34px;height:34px}
.brand b{font:700 15px var(--mono);letter-spacing:.1em;text-transform:uppercase;color:#fff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:160px;transition:max-width .25s,opacity .15s}
.grp{font-size:12px;font-weight:600;color:var(--muted);padding:var(--s4) var(--s3) var(--s1);white-space:nowrap;overflow:hidden}
.nav{position:relative;display:flex;align-items:center;gap:var(--s3);width:100%;height:46px;padding:0 14px;transition:gap .25s,background .15s,border-color .15s;margin:2px 0;background:transparent;color:var(--muted);
     border:1px solid transparent;justify-content:flex-start;font-size:15px}
.nav:hover{color:#fff;filter:none;background:rgba(47,123,255,.1)}
.nav.on{color:#fff;background:rgba(47,123,255,.16);border-color:var(--accent);box-shadow:0 0 14px rgba(47,123,255,.25)}
.nav svg{width:22px;height:22px;flex:none;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.nav .lbl{overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:160px;transition:max-width .25s,opacity .15s}
.nav .badge{margin-left:auto;font:600 11px/18px var(--mono);padding:0 7px;border-radius:9px;color:#b9c7ff;background:rgba(47,123,255,.16);flex:none}
.nav .badge.ok{color:var(--ok);background:rgba(61,240,176,.12)} .nav .badge.bad{color:var(--bad);background:rgba(224,32,32,.16)}
.nav .badge:empty{display:none}
.shell.rail .nav .badge{position:absolute;top:7px;right:9px;width:8px;height:8px;padding:0;font-size:0;background:currentColor}
.railbtn{margin-top:auto}
.railbtn .chev{transition:transform .2s}
.shell.rail .railbtn .chev{transform:rotate(180deg)}
.shell.rail .brand,.shell.rail .nav{gap:0}
.shell.rail .brand b,.shell.rail .nav .lbl{max-width:0;opacity:0}
.shell.rail .grp{font-size:0;padding:var(--s3) 0 0;height:var(--s4);position:relative}
.shell.rail .grp::after{content:'';position:absolute;left:var(--s3);right:var(--s3);top:50%;border-top:1px solid var(--line)}
.shell.rail .nav[data-tip]:hover::after{content:attr(data-tip);position:absolute;left:calc(100% + 10px);top:50%;transform:translateY(-50%);background:var(--panel2);
   border:1px solid var(--cyan);color:#fff;padding:4px 12px;border-radius:var(--r);font-size:13px;white-space:nowrap;z-index:70;pointer-events:none}

.main{min-width:0;margin-left:var(--sw);padding:var(--s4) var(--s5) var(--s6);transition:margin-left .25s cubic-bezier(.4,0,.2,1)}
.container{width:100%;max-width:1440px;margin-inline:auto;container-type:inline-size}
.topbar{position:sticky;top:var(--s3);z-index:40;display:flex;align-items:center;gap:var(--s3);margin-bottom:var(--s5);padding:var(--s2) var(--s3) var(--s2) var(--s4);
        min-height:var(--top);border:1px solid var(--line);border-radius:var(--rc);background:rgba(10,10,28,.92);backdrop-filter:blur(6px)}
.toprailbtn{display:inline-flex;align-items:center;justify-content:center;width:var(--hs);height:var(--hs);padding:0;border-radius:var(--r);flex:none}
.toprail-ic{width:18px;height:18px;stroke:currentColor;fill:none}
.topbar h2{font:700 16px var(--mono);color:#fff;letter-spacing:.06em;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.topbar .dot,.topbar .opts,#refreshBtn{flex:none}
.pagehead{display:flex;align-items:flex-end;gap:var(--s3);flex-wrap:wrap;margin-bottom:var(--s4)}
.pagehead > div:first-child{flex:1 1 280px;min-width:0}
.pact{display:flex;gap:var(--s2);flex:none}
#refreshBtn.busy{opacity:.6;cursor:progress}
.pagehead h1{font-size:26px;font-weight:800;color:#fff}
.pagehead p{color:var(--muted);margin-top:2px}
.tip{display:flex;gap:var(--s3);align-items:center;margin-bottom:var(--s4);padding:var(--s2) var(--s2) var(--s2) var(--s4);border:1px solid #2c3178;border-left:3px solid var(--cyan);
     border-radius:var(--r);background:rgba(47,123,255,.07);font-size:14px}
.tip > span{flex:1;min-width:0}
.tip b{color:#fff}
.tip button{height:var(--hs);width:var(--hs);padding:0;background:none;border:0;color:var(--muted);font-size:18px}
.tip.gone{display:none}
.navs{display:flex;flex-direction:column;overflow-y:auto;min-height:0}
.sect{font:700 14px var(--mono);color:var(--cyan);letter-spacing:.08em;margin:var(--s5) 0 var(--s3)}
.sect:first-of-type{margin-top:0}
.actions{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:var(--s3)}
@media (max-width:1100px){ .actions{grid-template-columns:repeat(2,minmax(0,1fr))} }
.act{display:flex;flex-direction:column;align-items:flex-start;justify-content:flex-start;gap:var(--s2);height:auto;min-height:132px;padding:var(--s4);text-align:left;
     white-space:normal;background:rgba(10,10,28,.88);color:var(--text);border:1px solid var(--line);border-radius:var(--rc)}
.act:hover{border-color:var(--cyan);filter:none;background:rgba(47,123,255,.1)}
.act .ic{width:42px;height:42px;border-radius:var(--r);background:var(--grad);display:grid;place-items:center;flex:none}
.act .ic svg{width:22px;height:22px;stroke:#fff;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.act b{font-size:15px;color:#fff}
.act span{color:var(--muted);font-size:13px;line-height:1.5}
.card.attncard{border-color:rgba(255,176,32,.45)}

/* ---------- Backdrop & Mobile Drawer ---------- */
.mob-backdrop{
  position:fixed;inset:0;background:rgba(0,0,0,.65);
  backdrop-filter:blur(3px);-webkit-backdrop-filter:blur(3px);
  z-index:45;transition:opacity .2s ease;
}
.mob-backdrop.hide{display:none}
.mob-close-btn{display:none}

@media (max-width:800px){
  :root{--bar:0px}
  .shell,.shell.rail{position:static}
  .main{margin-left:0;transition:none}
  .side{
    position:fixed;top:0;left:0;bottom:0;width:280px;max-width:85vw;height:100vh;height:100dvh;z-index:50;
    background:#08081a !important;border-right:1px solid var(--line);box-shadow:6px 0 32px rgba(0,0,0,.9),0 0 20px rgba(47,123,255,.2);
    transform:translateX(-100%);transition:transform .25s cubic-bezier(0.16,1,0.3,1);padding:var(--s4) var(--s3);
    display:flex;flex-direction:column;overflow-y:auto;visibility:hidden;
  }
  body.mob-open .side{transform:translateX(0);visibility:visible}
  .brand{display:flex;align-items:center;padding:0 var(--s2) var(--s3);border-bottom:1px solid var(--line);margin-bottom:var(--s2)}
  .brand b{display:inline-block !important;font-size:15px;color:#fff}
  .brand .mob-close-btn{display:inline-flex;align-items:center;justify-content:center;width:32px;height:32px;font-size:18px;
        padding:0;border-radius:var(--r);margin-left:auto;color:var(--text);background:var(--panel2);border:1px solid var(--line);cursor:pointer}
  .brand .mob-close-btn:hover{color:#fff;border-color:var(--cyan)}
  .grp{display:block;font-size:12px;font-weight:600;color:var(--cyan);padding:var(--s3) var(--s3) var(--s1)}
  .nav,.shell.rail .nav{display:flex !important;width:100%;height:48px;flex-direction:row !important;justify-content:flex-start !important;
        align-items:center !important;gap:var(--s3);padding:0 var(--s3);font-size:14px;border-radius:var(--r);border:1px solid transparent;
        color:var(--text);background:transparent}
  button.railbtn{display:none !important}
  .nav:hover{background:rgba(47,123,255,.1);color:#fff}
  .nav.on{background:rgba(47,123,255,.18);border-color:var(--accent);color:#fff;box-shadow:0 0 12px rgba(47,123,255,.25)}
  .nav svg{width:22px;height:22px;flex:none;stroke:currentColor;fill:none}
  .shell .nav .lbl,.shell.rail .nav .lbl,.shell.rail .brand b{display:inline-block !important;max-width:none !important;opacity:1 !important;color:inherit;white-space:nowrap}
  .shell.rail .nav,.shell.rail .brand{gap:var(--s3)}
  .shell.rail .nav[data-tip]:hover::after{display:none}
  .main{padding:var(--s3) var(--s3) var(--s6)}
  .topbar{top:var(--s2);margin-bottom:var(--s4);padding:var(--s2) var(--s3)}
  .pagehead h1{font-size:22px}
}
@media (max-width:520px){
  .actions{grid-template-columns:1fr}
  .act{min-height:0;flex-direction:row;align-items:center;gap:var(--s3)}
  #clock{display:none}
  #refreshBtn .lbl{display:none}
  .pact{width:100%} .pact button{flex:1}
  .topbar{gap:var(--s2);padding-right:var(--s2)}
  .topbar .ghost:not(.toprailbtn){padding:0 10px}
}

.sub-off{display:none !important}

/* ----- แผ่นรายละเอียดแถว (bottom sheet) ----- */
.sheet{position:fixed;inset:0;z-index:85;display:flex;align-items:flex-end;justify-content:center}
.sheet-bg{position:absolute;inset:0;background:rgba(0,0,0,.65);backdrop-filter:blur(3px)}
.sheet-box{position:relative;width:100%;max-width:560px;max-height:85dvh;display:flex;flex-direction:column;background:var(--panel2);border:1px solid var(--cyan);
           border-radius:var(--rc) var(--rc) 0 0;box-shadow:0 -8px 40px rgba(0,0,0,.7),0 0 24px rgba(47,123,255,.25);animation:sheetUp .22s cubic-bezier(.16,1,.3,1)}
@keyframes sheetUp{from{transform:translateY(40px);opacity:0}to{transform:none;opacity:1}}
.sheet-h{display:flex;align-items:center;gap:var(--s3);padding:var(--s4);border-bottom:1px solid var(--line)}
.sheet-h b{flex:1;min-width:0;overflow-wrap:anywhere;color:#fff;font-size:16px}
.sheet-b{overflow:auto;padding:var(--s3) var(--s4)}
.sf{display:grid;grid-template-columns:110px minmax(0,1fr);gap:var(--s3);align-items:center;padding:var(--s2) 0;border-bottom:1px solid var(--line2)}
.sf:last-child{border-bottom:0}
.sf > span{color:var(--muted);font:11px var(--mono);text-transform:uppercase;letter-spacing:.06em}
.sf > div{min-width:0;overflow-wrap:anywhere}
.sheet-a{display:flex;flex-wrap:wrap;gap:var(--s2);padding:var(--s3) var(--s4) calc(var(--s4) + env(safe-area-inset-bottom));border-top:1px solid var(--line)}
.sheet-a button{flex:1 1 120px}
body.sheet-open{overflow:hidden}

/* ตารางที่กว้างไม่พอ (JS วัดจากความกว้างเนื้อหาจริง แล้วใส่ .tapped) -> เป็นกล่องแตะ แล้วเด้งฟอร์ม */
.tw:has(table.tap){border:0}
table.tap{border-collapse:separate;border-spacing:0;border:1px solid var(--line);border-radius:var(--r);overflow:hidden}
table.tap.tapped{min-width:0 !important;border:0;overflow:visible}
table.tap.tapped thead{display:none}
table.tap.tapped tbody tr{display:flex;align-items:center;gap:var(--s3);min-height:56px;padding:var(--s3) var(--s4);border:1px solid var(--line);border-radius:var(--rc);
   margin-bottom:var(--s2);background:rgba(10,10,28,.6);cursor:pointer;overflow:hidden}
table.tap.tapped tbody tr:active{border-color:var(--cyan);background:rgba(47,123,255,.1)}
table.tap.tapped tbody tr::after{content:'›';margin-left:auto;color:var(--muted);font-size:22px;line-height:1;flex:none}
table.tap.tapped tbody tr:has(td.empty){cursor:default}
table.tap.tapped tbody tr:has(td.empty)::after{display:none}
table.tap.tapped td{display:none;border:0;padding:0}
table.tap.tapped td:first-child,table.tap.tapped td.pri{display:block;min-width:0;overflow-wrap:anywhere}
table.tap.tapped td:first-child{font-weight:600;color:#fff;flex:1 1 auto}
table.tap.tapped td.pri{flex:none}
table.tap.tapped td.empty{display:block;width:100%;text-align:center}
table.tap.tapped .keycell{white-space:normal;flex-wrap:wrap}
</style>
</head>
<body>
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
  <linearGradient id="lg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#3fb6ff"/><stop offset=".5" stop-color="#2f7bff"/><stop offset="1" stop-color="#c04dff"/></linearGradient>
  <symbol id="logo" viewBox="0 0 100 100"><path fill="url(#lg)" fill-rule="evenodd" d="M20 12H68L88 24V50L72 61L86 88H64L52 65H38V88H20ZM38 29H61L66 35V43L61 48H38Z"/></symbol>
  <symbol id="i-home" viewBox="0 0 24 24"><path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/><path d="M10 20v-6h4v6"/></symbol>
  <symbol id="i-key" viewBox="0 0 24 24"><circle cx="8" cy="15" r="4"/><path d="M11 12l9-9"/><path d="M16 7l3 3"/><path d="M14 9l2 2"/></symbol>
  <symbol id="i-code" viewBox="0 0 24 24"><path d="M8 7l-5 5 5 5"/><path d="M16 7l5 5-5 5"/><path d="M14 4l-4 16"/></symbol>
  <symbol id="i-log" viewBox="0 0 24 24"><path d="M4 5h16M4 10h16M4 15h10M4 20h7"/></symbol>
  <symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M9 12l2 2 4-4"/></symbol>
  <symbol id="i-gear" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3M5 5l2 2M17 17l2 2M19 5l-2 2M7 17l-2 2"/></symbol>
  <symbol id="i-chev" viewBox="0 0 24 24"><path d="M15 6l-6 6 6 6"/></symbol>
  <symbol id="i-plus" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></symbol>
  <symbol id="i-pulse" viewBox="0 0 24 24"><path d="M3 12h4l3-8 4 16 3-8h4"/></symbol>
  <symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></symbol>
  <symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/></symbol>
  <symbol id="i-tool" viewBox="0 0 24 24"><path d="M14 6a4 4 0 005 5l-9 9a2.5 2.5 0 01-4-4l9-9z"/></symbol>
</defs></svg>

<!-- ============ LOGIN ============ -->
<div id="login" class="center">
  <div class="card" style="padding:var(--s5)">
    <div class="brandmark"><svg class="logo"><use href="#logo"/></svg></div>
    <h1 style="margin:0 0 4px;font:700 20px var(--mono)">&gt; เข้าสู่ระบบแอดมิน</h1>
    <p class="muted" style="margin:0 0 var(--s4)">ใส่รหัสผ่านแอดมิน</p>
    <input id="pw" type="password" placeholder="รหัสผ่าน" autocomplete="current-password">
    <div id="loginErr" style="margin:var(--s2) 0;color:var(--bad);min-height:20px"></div>
    <button style="width:100%" onclick="doLogin()">เข้าสู่ระบบ</button>
  </div>
</div>

<!-- ============ APP ============ -->
<!-- เมนูข้าง: หนึ่งรายการ = หนึ่งหน้า (ไม่มีแท็บย่อยในหน้า) จัดกลุ่มตามงานที่แอดมินทำ -->
<div id="app" class="shell hide">
  <div class="mob-backdrop hide" id="mobBackdrop" onclick="closeMobNav()"></div>
  <aside class="side" id="side">
    <div class="brand"><svg class="logo"><use href="#logo"/></svg><b id="brandSide">Key System</b><button class="ghost sm mob-close-btn" onclick="closeMobNav()" aria-label="ปิดเมนู">✕</button></div>
    <nav class="navs">
      <button class="nav on" data-tab="overview" data-tip="ภาพรวม" onclick="tab('overview')"><svg><use href="#i-home"/></svg><span class="lbl">ภาพรวม</span></button>

      <button class="nav" data-tab="summary" data-tip="สรุป" onclick="tab('summary')"><svg><use href="#i-log"/></svg><span class="lbl">สรุป</span></button>

      <div class="grp">Key ลูกค้า</div>
      <button class="nav" data-tab="create" data-tip="สร้าง key" onclick="tab('create')"><svg><use href="#i-plus"/></svg><span class="lbl">สร้าง key</span></button>
      <button class="nav" data-tab="keys" data-tip="รายการ key" onclick="tab('keys')"><svg><use href="#i-key"/></svg><span class="lbl">รายการ key</span><span class="badge" id="nbKeys"></span></button>
      <button class="nav" data-tab="online" data-tip="ใช้งานอยู่" onclick="tab('online')"><svg><use href="#i-pulse"/></svg><span class="lbl">ใช้งานอยู่</span><span class="badge ok" id="nbOnline"></span></button>

      <div class="grp">สคริปต์</div>
      <button class="nav" data-tab="scripts" data-tip="สคริปต์" onclick="tab('scripts')"><svg><use href="#i-code"/></svg><span class="lbl">สคริปต์</span><span class="badge" id="nbScripts"></span></button>

      <div class="grp">ความปลอดภัย</div>
      <button class="nav" data-tab="logs" data-tip="กิจกรรม" onclick="tab('logs')"><svg><use href="#i-log"/></svg><span class="lbl">กิจกรรม</span></button>
      <button class="nav" data-tab="blocks" data-tip="บล็อก / แบน" onclick="tab('blocks')"><svg><use href="#i-shield"/></svg><span class="lbl">บล็อก / แบน</span><span class="badge bad" id="nbBlocked"></span></button>
      <button class="nav" data-tab="watermark" data-tip="ตามหาคนปล่อยหลุด" onclick="tab('watermark')"><svg><use href="#i-search"/></svg><span class="lbl">ตามหาคนปล่อยหลุด</span></button>

      <div class="grp">ระบบ</div>
      <button class="nav" data-tab="settings" data-tip="ตั้งค่า" onclick="tab('settings')"><svg><use href="#i-gear"/></svg><span class="lbl">ตั้งค่า</span></button>
    </nav>
    <button class="nav railbtn" data-tip="ย่อ/ขยายเมนู" onclick="toggleRail()"><svg class="chev"><use href="#i-chev"/></svg><span class="lbl">ย่อเมนู</span></button>
  </aside>

  <div class="main">
   <div class="container">
    <div class="topbar">
      <button class="ghost toprailbtn" onclick="toggleRail()" aria-label="ย่อ/ขยายแถบเมนู" title="ย่อ/ขยายแถบเมนู"><svg class="toprail-ic" viewBox="0 0 24 24"><path d="M4 6h16M4 12h16M4 18h16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></button>
      <div class="dot" id="live"></div>
      <h2 id="brandTitle">Key System</h2>
      <span class="muted" id="clock" style="font-size:13px"></span>
      <span id="maintFlag" class="pill warn hide">ปิดปรับปรุง</span>
      <div class="grow"></div>
      <button class="ghost" id="refreshBtn" onclick="refresh(true)" title="ดึงข้อมูลล่าสุดจากฐานข้อมูล">↻ <span class="lbl">อัปเดต</span></button>
      <div class="opts">
        <button class="ghost" onclick="toggleOpts()" aria-label="ตัวเลือก">⋯</button>
        <div class="opts-pop hide" id="optsPop">
          <label class="chk"><input type="checkbox" id="autoOn" onchange="setAuto()"> รีเฟรชอัตโนมัติ</label>
          <div class="row2"><span class="muted">ทุก</span>
            <select id="autoSec" onchange="setAuto()"><option value="30">30 วินาที</option><option value="60" selected>1 นาที</option><option value="300">5 นาที</option></select></div>
          <button class="danger" onclick="logout()">ออกจากระบบ</button>
        </div>
      </div>
    </div>

    <!-- ---------- OVERVIEW (คำขอเดียว: /api/admin/overview) ---------- -->
    <section id="tab-overview" class="page">
      <div class="pagehead"><div><h1>ภาพรวม</h1><p>สถานะระบบตอนนี้ สิ่งที่ต้องดูแล และใครกำลังใช้งาน</p></div><div class="pact"><button onclick="tab('create')">+ สร้าง key</button></div></div>
      <div class="kpis" id="kpis"></div>

      <div class="card attncard">
        <div class="chead"><h3>ต้องดูแล</h3></div>
        <div class="attn" id="attn"></div>
        <div class="maintrow" id="maintRow"></div>
      </div>

      <div class="cols">
        <div class="card">
          <div class="chead"><h3>กำลังใช้งาน <span class="pill ok" id="ovOnlineN">0</span></h3><span class="muted sm">10 นาทีล่าสุด</span><div class="grow"></div><button class="ghost sm" onclick="tab('online')">ดูทั้งหมด ›</button></div>
          <div class="olist" id="ovOnline"></div>
        </div>
        <div class="card">
          <div class="chead"><h3>กิจกรรมล่าสุด</h3><div class="grow"></div><button class="ghost sm" onclick="tab('logs')">ดูทั้งหมด ›</button></div>
          <div class="log" id="logsMini"></div>
        </div>
      </div>

      <div class="card">
        <div class="chead"><h3>key ตามสคริปต์</h3><span class="muted sm" id="ovAny"></span><div class="grow"></div><button class="ghost sm" onclick="tab('scripts')">จัดการสคริปต์ ›</button></div>
        <div class="bars" id="ovScripts"></div>
      </div>
    </section>


    <!-- ---------- CREATE KEY ---------- -->
    <section id="tab-create" class="page hide">
      <div class="pagehead"><div><h1>สร้าง key</h1><p>ออก key ให้ลูกค้า ครั้งละหลายใบ กำหนดอายุ จำนวนเครื่อง และสคริปต์ที่ใช้ได้</p></div></div>
      <div class="tip" id="tip-create"><span>💡 ค่าเริ่มต้นของช่องเปลี่ยนได้ในหน้า <b>ตั้งค่า</b> → ค่าตั้งต้นตอนสร้าง key</span><button type="button" aria-label="ปิดคำแนะนำ" onclick="dismissTip('create')">×</button></div>
      <div class="card">
        <div class="chead"><h3>รายละเอียด key</h3></div>
        <div class="fgrid">
          <div class="fld"><label for="cCount">จำนวน</label><input id="cCount" type="number" value="1" min="1" max="100"></div>
          <div class="fld"><label for="cDays">อายุ (วัน)</label><input id="cDays" type="number" value="30" min="0"><div class="hint">0 = ตลอดชีพ</div></div>
          <div class="fld"><label for="cHwid">จำกัดเครื่อง</label><input id="cHwid" type="number" value="1" min="0"><div class="hint">0 = ไม่จำกัด</div></div>
          <div class="fld"><label for="cPrefix">คำนำหน้า</label><input id="cPrefix" placeholder="VIP"></div>
          <div class="fld"><label>ใช้กับสคริปต์</label>
            <div class="msel" id="cScopeWrap">
              <button type="button" class="ghost msel-btn" id="cScopeBtn" onclick="mselToggle()"><span class="lbl" id="cScopeLbl">ทุกสคริปต์</span><svg viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg></button>
              <div class="msel-pop hide" id="cScopePop">
                <input type="search" id="cScopeQ" placeholder="ค้นหาสคริปต์…" oninput="renderScopeBox()" autocomplete="off">
                <div class="msel-list" id="cScope"></div>
                <div class="msel-foot"><span id="cScopeCnt"></span><button type="button" class="ghost sm" onclick="mselAll()">ทุกสคริปต์</button><button type="button" class="sm" onclick="mselToggle(false)">เสร็จ</button></div>
              </div>
            </div>
            <div class="hint">ไม่เลือก = ใช้ได้ทุกสคริปต์</div></div>
          <div class="fld wide"><label for="cNote">หมายเหตุ</label><input id="cNote" placeholder="ชื่อลูกค้า / ช่องทางขาย"></div>
          <div class="fld btn"><label>&nbsp;</label><button onclick="createKeys()">+ สร้าง key</button></div>
        </div>
        <div id="newKeys" class="hide">
          <label>key ที่เพิ่งสร้าง</label>
          <textarea id="newKeysBox" style="min-height:96px" readonly></textarea>
          <div class="bar end"><button class="ghost sm" onclick="copyText(document.getElementById('newKeysBox').value)">คัดลอกทั้งหมด</button><button class="ghost sm" onclick="tab('keys')">ไปที่รายการ key ›</button></div>
        </div>
      </div>
    </section>

    <!-- ---------- KEY LIST ---------- -->
    <section id="tab-keys" class="page hide">
      <div class="pagehead"><div><h1>รายการ key</h1><p>ค้นหา ต่ออายุ ระงับ ล้าง HWID หรือลบ key</p></div><div class="pact"><button onclick="tab('create')">+ สร้าง key</button></div></div>
      <div class="tip" id="tip-keys"><span>💡 ปุ่ม “จัดการ” ท้ายแถวมี ต่ออายุ / ระงับ / ล้าง HWID / ลบ — แถบด้านบนกรองตามสคริปต์</span><button type="button" aria-label="ปิดคำแนะนำ" onclick="dismissTip('keys')">×</button></div>
      <div class="card" id="keys-list">
        <div class="chead">
          <div><h3>รายการ key <span class="pill tag" id="keyCount">0</span></h3>
            <div class="muted sm" id="scopeInfo"></div></div>
          <div class="grow"></div>
          <button class="ghost sm menubtn" data-menu onclick="bulkMenu(this)">เลือกหลายใบ <svg viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg></button>
        </div>
        <div class="chips" id="scriptChips"></div>
        <div class="filters">
          <input id="q" type="search" placeholder="ค้นหา key / หมายเหตุ / HWID / ชื่อหรือ ID Discord" oninput="debouncedFilter()" autocomplete="off">
          <select id="fScope" onchange="filterChanged()"><option value="">— ทุกหมวด —</option></select>
          <select id="fStatus" onchange="filterChanged()">
            <option value="">ทุกสถานะ</option><option value="active">ใช้ได้</option><option value="expiring">ใกล้หมดอายุ</option>
            <option value="expired">หมดอายุแล้ว</option><option value="disabled">ถูกระงับ</option>
            <option value="bound">ถูกจองแล้ว (มีเครื่องผูก)</option><option value="unused">ยังว่าง (ไม่มีเครื่องผูก)</option>
            <option value="pending">ยังไม่เริ่มนับ (รอใช้ครั้งแรก)</option>
            <option value="lifetime">ตลอดชีพ</option><option value="lifetime_used">ตลอดชีพ + มีคนใช้แล้ว</option>
            <option value="owned">ผูก Discord แล้ว</option>
            <option value="shop">key ร้านขาย (หมายเหตุขึ้นต้น “ร้าน”)</option><option value="manual">key เติมเอง / ทดสอบ</option>
          </select>
        </div>
        <div class="selbar hide" id="selBar"></div>
        <div class="tw">
          <table class="tap" style="min-width:900px">
            <thead><tr><th class="chk"><input type="checkbox" id="selAll" aria-label="เลือกทั้งหน้า" onchange="selPage(this.checked)"></th><th>KEY</th><th>สถานะ</th><th>หมวด</th><th>เครื่อง</th><th>หมดอายุ</th><th>ใช้ล่าสุด</th><th>หมายเหตุ</th><th></th></tr></thead>
            <tbody id="keyRows"></tbody>
          </table>
        </div>
        <div class="pager" id="pgKeys"></div>
      </div>
    </section>

    <!-- ---------- SCRIPTS ---------- -->
    <section id="tab-scripts" class="page hide">
      <div class="pagehead"><div><h1>สคริปต์</h1><p>โค้ด Lua ที่ลูกค้าได้รับเมื่อใช้ key และโค้ดเรียกใช้ (loadstring)</p></div><div class="pact"><button onclick="editScript(null)">+ เพิ่มสคริปต์</button></div></div>
      <div class="tip" id="tip-scripts"><span>💡 กด “คัดลอกโค้ดเรียกใช้” ส่งให้ลูกค้า — slug ใน URL ห้ามเปลี่ยนหลังแจกแล้ว</span><button type="button" aria-label="ปิดคำแนะนำ" onclick="dismissTip('scripts')">×</button></div>
      <div class="card">
        <div class="chead"><h3>สคริปต์ทั้งหมด <span class="pill tag" id="scriptCount">0</span></h3></div>
        <div class="tw">
          <table class="tap" style="min-width:760px">
            <thead><tr><th>ชื่อ</th><th>slug</th><th>เวอร์ชัน</th><th>ขนาด</th><th>key ในหมวด</th><th>สถานะ</th><th>โค้ดเรียกใช้</th><th></th></tr></thead>
            <tbody id="scriptRows"></tbody>
          </table>
        </div>
      </div>

      <div class="card hide anchor" id="editor">
        <div class="chead"><h3 id="edTitle">แก้ไขสคริปต์</h3> <span class="pill warn hide" id="edDirty">ยังไม่ได้บันทึก</span><div class="grow"></div>
          <button class="ghost sm" onclick="closeEditor()">ปิด</button></div>
        <div class="fgrid">
          <div class="fld"><label for="edName">ชื่อที่โชว์</label><input id="edName" placeholder="Blox Fruits Hub" oninput="markDirty()"></div>
          <div class="fld"><label for="edSlug">slug (ใช้ใน URL)</label><input id="edSlug" placeholder="bloxfruits" oninput="markDirty()"></div>
          <div class="fld"><label for="edEnabled">สถานะ</label>
            <select id="edEnabled" onchange="markDirty()"><option value="1">เปิดใช้งาน</option><option value="0">ปิดชั่วคราว</option></select></div>
        </div>
        <div class="fgrid" id="edVerBox">
          <div class="fld"><label for="edVersion">เลขเวอร์ชัน (x.x.x) <span class="muted" id="edVerCur"></span></label>
            <input id="edVersion" placeholder="เช่น 1.2.0" maxlength="14" autocomplete="off" oninput="markDirty()"></div>
          <div class="fld" style="grid-column:span 2"><label for="edNote">หมายเหตุเวอร์ชัน (ไม่บังคับ)</label>
            <input id="edNote" placeholder="เช่น แก้บั๊กวาร์ป / เพิ่มเมนูฟาร์ม" maxlength="300" autocomplete="off" oninput="markDirty()"></div>
        </div>
        <p class="muted" style="margin:0 0 8px" id="edVerHint">แก้ซอร์สแล้วบันทึก = ออกเวอร์ชันใหม่และ <b>มีผลกับลูกค้าทุกคนทันที</b> (ภายใน ~30 วินาที) แก้แค่ชื่อ/สถานะไม่ต้องใส่เลขเวอร์ชัน</p>
        <label for="edSource">ซอร์สโค้ด Lua</label>
        <textarea id="edSource" placeholder="print('hello')" wrap="off" spellcheck="false" autocomplete="off" autocapitalize="off" autocorrect="off" oninput="markDirty()"></textarea>
        <div class="bar end">
          <button onclick="saveScript()">บันทึก / เผยแพร่เวอร์ชัน <small class="muted">(⌘/Ctrl+S)</small></button>
          <button class="ghost" id="edHistBtn" onclick="openHistory(EDIT_ID)">ประวัติเวอร์ชัน</button>
          <input type="file" id="edFile" accept=".lua,.txt" style="display:none" onchange="loadFile(event)">
          <button class="ghost" onclick="document.getElementById('edFile').click()">อัปโหลดไฟล์ .lua</button>
          <span id="edMsg" class="muted"></span>
        </div>
      </div>

      <div class="card hide anchor" id="history">
        <div class="chead"><h3 id="hiTitle">ประวัติเวอร์ชัน</h3> <span class="pill tag" id="hiKeep"></span><div class="grow"></div>
          <button class="ghost sm" onclick="closeHistory()">ปิด</button></div>
        <div class="tw">
          <table class="tap" style="min-width:640px">
            <thead><tr><th>เวอร์ชัน</th><th>วันที่</th><th>หมายเหตุ</th><th>ขนาด</th><th></th></tr></thead>
            <tbody id="hiRows"></tbody>
          </table>
        </div>
        <div id="hiCodeBox" class="hide">
          <div class="bar"><b id="hiCodeTitle"></b><div class="grow"></div>
            <button class="ghost sm" onclick="copyText($('hiCode').textContent)">คัดลอก</button>
            <button class="ghost sm" onclick="$('hiCodeBox').classList.add('hide')">ซ่อน</button></div>
          <pre id="hiCode" class="mono" style="max-height:340px;overflow:auto;white-space:pre;margin:0;padding:10px;border:1px solid var(--line,#2a2a2a);border-radius:8px"></pre>
        </div>
      </div>
    </section>

    <!-- ---------- LOGS ---------- -->
    <section id="tab-logs" class="page hide">
      <div class="pagehead"><div><h1>กิจกรรม</h1><p>ใครใช้ key เมื่อไหร่ สำเร็จหรือไม่ — แตะที่แถวเพื่อดู IP / HWID</p></div></div>
      <div class="tip" id="tip-logs"><span>💡 สีเขียว = สำเร็จ สีแดง = ไม่สำเร็จ — เจอคนน่าสงสัยไปหน้า “บล็อก / แบน”</span><button type="button" aria-label="ปิดคำแนะนำ" onclick="dismissTip('logs')">×</button></div>
      <div class="card">
        <div class="chead">
          <h3>กิจกรรม <span class="pill tag" id="logCount"></span></h3><div class="grow"></div>
          <select id="logFilter" class="auto sm" onchange="logFilterChanged()">
            <option value="">ทั้งหมด</option><option value="1">สำเร็จ</option><option value="0">ไม่สำเร็จ</option>
          </select>
        </div>
        <div class="log" id="logs"></div>
        <div class="pager" id="pgLogs"></div>
      </div>
    </section>

    <!-- ---------- ONLINE ---------- -->
    <section id="tab-online" class="page hide">
      <div class="pagehead"><div><h1>ใช้งานอยู่</h1><p>คนที่เปิดสคริปต์เล่นอยู่ตอนนี้ (ติดตามต่อเนื่อง) ใครใช้สคริปต์ไหน กี่เครื่อง เห็นล่าสุดเมื่อไหร่</p></div></div>
      <div class="tip" id="tip-online"><span>💡 ติดตามจาก heartbeat ของสคริปต์ในเกม (ทุก ~5 นาที) — “ออนไลน์” = เห็นสัญญาณภายใน ~6 นาที; รุ่น loader เก่าจะเห็นเฉพาะตอนใช้ key</span><button type="button" aria-label="ปิดคำแนะนำ" onclick="dismissTip('online')">×</button></div>
      <div class="card">
        <div class="chead">
          <h3>กำลังใช้งาน <span class="pill ok" id="onlineCount">0</span></h3>
          <div class="grow"></div>
          <div class="tools">
          <input id="onlineQ" type="search" class="sm" placeholder="ค้นหาชื่อ / หมายเหตุ / key" oninput="renderOnline()" autocomplete="off">
          <select id="onlineWin" class="sm" onchange="loadOnline()">
            <option value="600">10 นาทีล่าสุด</option><option value="1800">30 นาทีล่าสุด</option><option value="3600">1 ชั่วโมงล่าสุด</option>
          </select>
          </div>
        </div>
        <div class="online" id="onlineList"><div class="muted">กำลังโหลด…</div></div>
      </div>
    </section>

    <!-- ---------- BLOCKS / BAN ---------- -->
    <section id="tab-blocks" class="page hide">
      <div class="pagehead"><div><h1>บล็อก / แบน</h1><p>IP และเครื่องที่ถูกบล็อกอยู่ และแบนถาวรด้วยมือ</p></div></div>
      <div class="cols wide-first">
        <div class="card">
          <div class="chead"><h3>IP / เครื่อง ที่ถูกบล็อกอยู่ <span class="pill bad" id="blockCount">0</span></h3></div>
          <div class="why">ระบบบล็อกอัตโนมัติเมื่อมีคนกรอก key ผิดถี่เกินกำหนด (ตั้งเกณฑ์ได้ในหน้าตั้งค่า)</div>
          <div class="tw">
            <table class="tap" style="min-width:560px">
              <thead><tr><th>ค่า</th><th>ประเภท</th><th>สาเหตุ</th><th>ปลดบล็อกเมื่อ</th><th></th></tr></thead>
              <tbody id="blockRows"></tbody>
            </table>
          </div>
        </div>
        <div class="card">
          <div class="chead"><h3>แบนถาวรด้วยมือ</h3></div>
          <div class="why">รู้ตัวคนทำผิดแล้ว วาง HWID หรือ IP เพื่อห้ามใช้ถาวร</div>
          <div class="fgrid one">
            <div class="fld"><label for="bKind">ประเภท</label>
              <select id="bKind"><option value="hwid">HWID</option><option value="ip">IP</option></select></div>
            <div class="fld"><label for="bValue">ค่า</label><input id="bValue" placeholder="วาง HWID หรือ IP ที่ต้องการแบน"></div>
            <div class="fld"><label for="bReason">เหตุผล</label><input id="bReason" placeholder="เช่น แชร์ key ต่อ"></div>
          </div>
          <button class="danger" style="width:100%" onclick="addBlock()">แบนถาวร</button>
          <div class="hint">HWID ดูได้จากหน้ากิจกรรม (แตะที่แถว) หรือให้ลูกค้ากดคัดลอก HWID ในเกม</div>
        </div>
      </div>
    </section>

    <!-- ---------- WATERMARK ---------- -->
    <section id="tab-watermark" class="page hide">
      <div class="pagehead"><div><h1>ตามหาคนปล่อยหลุด</h1><p>วางโค้ดที่หลุด ระบบบอกว่ามาจาก key และเครื่องไหน</p></div></div>
      <div class="card">
        <div class="chead"><h3>วางโค้ดที่หลุด</h3></div>
        <div class="why">ระบบจะอ่านลายน้ำที่ฝังไว้ว่าโค้ดชุดนี้ถูกดึงด้วย key ใบไหน จากเครื่องไหน เมื่อไหร่</div>
        <textarea id="wmText" class="short" placeholder="วางโค้ดที่เจอหลุดที่นี่..."></textarea>
        <div class="bar end">
          <button onclick="decodeWm()">ตรวจลายน้ำ</button>
          <span id="wmMsg" class="muted"></span>
        </div>
        <div id="wmResult"></div>
      </div>
    </section>

    <!-- ---------- SETTINGS ---------- -->
    <section id="tab-settings" class="page hide">
      <div class="pagehead"><div><h1>ตั้งค่า</h1><p>ปรับค่าระบบทั้งหมด แล้วกดบันทึกครั้งเดียวที่แถบด้านล่าง</p></div></div>
      <div class="jump" id="setJump">
        <a href="#set-general" onclick="return jumpTo(this)">ทั่วไป</a>
        <a href="#set-protect" onclick="return jumpTo(this)">ป้องกันซอร์ส / กันสุ่ม</a>
        <a href="#set-discord" onclick="return jumpTo(this)">Discord</a>
        <a href="#set-backup" onclick="return jumpTo(this)">สำรองข้อมูล</a>
        <a href="#set-system" onclick="return jumpTo(this)">ระบบ</a>
      </div>

      <div class="sg" id="set-general">
        <h3 class="sgh">ทั่วไป</h3><p class="sgp">หน้าตาในเกม ค่าตั้งต้นของ key และโหมดปิดปรับปรุง</p>
        <div class="card">
          <h4 class="sub">แบรนด์และหน้าต่างในเกม</h4>
          <div class="fgrid">
            <div class="fld wide"><label for="s_brand">ชื่อแบรนด์ / ชื่อฮับ</label><input id="s_brand">
              <div class="hint">โชว์บนหัวหน้าต่างกรอก key ในเกม และหน้า /key</div></div>
            <div class="fld"><label for="s_ui_accent">สีหลักในเกม</label><input id="s_ui_accent" type="color"></div>
            <div class="fld"><label for="s_ui_accent2">สีที่สอง (ไล่เฉด)</label><input id="s_ui_accent2" type="color"></div>
            <div class="fld wide"><label for="s_getkey_url">ลิงก์รับ/ซื้อ key</label><input id="s_getkey_url" placeholder="https://...">
              <div class="hint">ถ้าใส่ จะมีปุ่ม "คัดลอกลิงก์รับ Key" ในหน้าต่างในเกม</div></div>
            <div class="fld"><label for="s_token_ttl">อายุ token ดึงซอร์ส (วินาที)</label><input id="s_token_ttl" type="number" min="10">
              <div class="hint">ยิ่งสั้นยิ่งปลอดภัย ปกติ 60</div></div>
          </div>
          <label for="s_announcement">ประกาศถึงลูกค้า (โชว์ในหน้าต่างกรอก key)</label>
          <textarea id="s_announcement" class="short" placeholder="เช่น ต่ออายุ key ทักไลน์ @myshop"></textarea>
        </div>
        <div class="card">
          <h4 class="sub">ค่าตั้งต้นตอนสร้าง key</h4>
          <div class="fgrid">
            <div class="fld"><label for="s_default_days">อายุ (วัน)</label><input id="s_default_days" type="number" min="0"></div>
            <div class="fld"><label for="s_default_max_hwid">จำกัดเครื่อง</label><input id="s_default_max_hwid" type="number" min="0"></div>
            <div class="fld"><label for="s_default_prefix">คำนำหน้า key</label><input id="s_default_prefix" placeholder="VIP"></div>
          </div>
          <div class="hint" style="margin-top:0">ใช้เป็นค่าเริ่มต้นทั้งบนหน้าเว็บและคำสั่ง /genkey ใน Discord</div>
        </div>
        <div class="card">
          <h4 class="sub">โหมดปิดปรับปรุง</h4>
          <div class="fgrid">
            <div class="fld"><label for="s_maintenance">สถานะ</label>
              <select id="s_maintenance"><option value="0">เปิดให้ใช้งานปกติ</option><option value="1">ปิดปรับปรุง (ทุก key ใช้ไม่ได้)</option></select></div>
            <div class="fld wide"><label for="s_maintenance_msg">ข้อความที่ลูกค้าจะเห็น</label><input id="s_maintenance_msg"></div>
          </div>
        </div>
      </div>

      <div class="sg" id="set-protect">
        <h3 class="sgh">ความปลอดภัยซอร์ส / กันสุ่ม key</h3><p class="sgp">ป้องกันซอร์สหลุดและบล็อกคนที่กรอก key มั่ว</p>
        <div class="card">
          <h4 class="sub">ป้องกันซอร์สหลุด</h4>
          <div class="fgrid">
            <div class="fld"><label for="s_encrypt_source">เข้ารหัสซอร์สก่อนส่ง</label>
              <select id="s_encrypt_source"><option value="1">เปิด</option><option value="0">ปิด</option></select></div>
            <div class="fld"><label for="s_require_roblox">รับเฉพาะที่มาจาก Roblox</label>
              <select id="s_require_roblox"><option value="1">เปิด</option><option value="0">ปิด</option></select></div>
            <div class="fld"><label for="s_watermark">ฝังลายน้ำรายบุคคล</label>
              <select id="s_watermark"><option value="1">เปิด</option><option value="0">ปิด</option></select></div>
          </div>
          <div class="hint" style="margin-top:0">
            เข้ารหัส = เปิด /api/script ในเบราว์เซอร์จะเห็นแต่ตัวอักษรมั่ว ถอดได้เฉพาะเครื่องที่ขอ token นั้น ·
            รับเฉพาะ Roblox = curl หรือเบราว์เซอร์ดึงซอร์สไม่ได้ (ถ้า executor บางตัวมีปัญหาให้ปิดข้อนี้) ·
            ลายน้ำ = ฝัง key + HWID ไว้ในซอร์สของแต่ละคน ใช้ตามหาคนที่ปล่อยหลุดในหน้าความปลอดภัย
          </div>
        </div>
        <div class="card">
          <h4 class="sub">กันคนสุ่ม key</h4>
          <div class="fgrid">
            <div class="fld"><label for="s_rl_enabled">สถานะ</label>
              <select id="s_rl_enabled"><option value="1">เปิดใช้งาน</option><option value="0">ปิด</option></select></div>
            <div class="fld"><label for="s_rl_max_fail">กรอกผิดกี่ครั้งถึงบล็อก</label><input id="s_rl_max_fail" type="number" min="3"></div>
            <div class="fld"><label for="s_rl_window_min">นับย้อนหลัง (นาที)</label><input id="s_rl_window_min" type="number" min="1"></div>
            <div class="fld"><label for="s_rl_block_min">บล็อกนาน (นาที)</label><input id="s_rl_block_min" type="number" min="1"></div>
          </div>
          <div class="hint" style="margin-top:0">ค่าที่แนะนำ: ผิด 10 ครั้งใน 5 นาที = บล็อก 30 นาที และแจ้งเตือนเข้า Discord ทันที</div>
        </div>
      </div>

      <div class="sg" id="set-discord">
        <h3 class="sgh">Discord / แจ้งเตือน</h3><p class="sgp">Webhook แจ้งเตือน สรุป key ใกล้หมดอายุ และคำสั่งให้ลูกค้าจัดการเอง</p>
        <div class="card">
          <h4 class="sub">แจ้งเตือนเข้า Discord</h4>
          <div class="fgrid">
            <div class="fld wide"><label for="s_discord_webhook">Webhook URL</label><input id="s_discord_webhook" placeholder="https://discord.com/api/webhooks/...">
              <div class="hint">สร้างที่ห้องแชท → Edit Channel → Integrations → Webhooks</div></div>
            <div class="fld wide"><label for="s_webhook_events">ส่งเมื่อ</label>
              <select id="s_webhook_events">
                <option value="off">ไม่ส่ง</option>
                <option value="fail">เฉพาะที่ใช้ key ไม่สำเร็จ</option>
                <option value="all">ทุกครั้งที่มีคนใช้ key</option>
              </select></div>
          </div>
        </div>
        <div class="card">
          <h4 class="sub">แจ้งเตือน key ใกล้หมดอายุ</h4>
          <div class="fgrid">
            <div class="fld"><label for="s_expire_notify">ส่งสรุปรายวัน</label>
              <select id="s_expire_notify"><option value="1">ส่ง</option><option value="0">ไม่ส่ง</option></select></div>
            <div class="fld"><label for="s_expire_warn_days">เตือนล่วงหน้า (วัน)</label><input id="s_expire_warn_days" type="number" min="1"></div>
          </div>
          <div class="hint" style="margin-top:0">ส่งเข้า Discord webhook เดียวกับด้านบน วันละครั้ง</div>
        </div>
        <div class="card">
          <h4 class="sub">ให้ลูกค้าจัดการ key เองใน Discord</h4>
          <div class="fgrid">
            <div class="fld"><label for="s_self_service">สถานะ</label>
              <select id="s_self_service"><option value="1">เปิด</option><option value="0">ปิด</option></select></div>
            <div class="fld"><label for="s_self_reset_days">ล้าง HWID เองได้ทุกกี่วัน</label><input id="s_self_reset_days" type="number" min="0"></div>
          </div>
          <div class="hint" style="margin-top:0">คำสั่งของลูกค้า: /redeem ผูก key · /mykey ดูสถานะ · /myreset ล้างเครื่อง</div>
        </div>
      </div>

      <div class="sg" id="set-backup">
        <h3 class="sgh">สำรองข้อมูล</h3><p class="sgp">ส่งไฟล์สำรองอัตโนมัติ ดาวน์โหลดเอง หรือกู้คืนจากไฟล์</p>
        <div class="card">
          <div class="fgrid">
            <div class="fld"><label for="s_backup_enabled">ส่งไฟล์สำรองทุกคืน</label>
              <select id="s_backup_enabled"><option value="1">ส่ง</option><option value="0">ไม่ส่ง</option></select></div>
            <div class="fld wide"><label for="s_backup_webhook">Webhook สำหรับไฟล์สำรอง</label><input id="s_backup_webhook" placeholder="เว้นว่าง = ใช้ webhook เดียวกับแจ้งเตือน"></div>
          </div>
          <div class="bar end">
            <button class="ghost" onclick="doExport()">ดาวน์โหลดไฟล์สำรองตอนนี้</button>
            <input type="file" id="impFile" accept=".json" style="display:none" onchange="doImport(event)">
            <button class="ghost" onclick="document.getElementById('impFile').click()">กู้คืนจากไฟล์</button>
            <span class="muted" style="font-size:13px">กู้คืนจะเพิ่มเฉพาะข้อมูลที่หายไป ไม่ทับของเดิม</span>
          </div>
        </div>
      </div>

      <div class="sg" id="set-system">
        <h3 class="sgh">ระบบ</h3><p class="sgp">การเก็บ log และรหัสผ่านแอดมิน</p>
        <div class="card">
          <div class="fgrid">
            <div class="fld"><label for="s_log_retention_days">เก็บ log ย้อนหลัง (วัน)</label><input id="s_log_retention_days" type="number" min="1">
              <div class="hint">ยิ่งนานยิ่งใช้พื้นที่มาก</div></div>
            <div class="fld wide"><label for="s_newpw">เปลี่ยนรหัสผ่านแอดมิน</label><input id="s_newpw" type="password" placeholder="เว้นว่าง = ไม่เปลี่ยน" autocomplete="new-password">
              <div class="hint" id="pwState"></div></div>
            <div class="fld wide"><label for="s_newpw2">รหัสผ่านแอดมินที่ 2 (สิทธิ์เท่ารหัสหลัก)</label>
              <div style="display:flex;gap:8px;flex-wrap:wrap"><input id="s_newpw2" type="password" placeholder="เว้นว่าง = ไม่เปลี่ยน" autocomplete="new-password" style="flex:1;min-width:200px">
                <button class="ghost" id="pw2Del" type="button" onclick="removePw2()" hidden>ลบรหัสที่ 2</button></div>
              <div class="hint" id="pw2State"></div></div>
          </div>
        </div>
      </div>

      <div class="savebar">
        <button onclick="saveSettings()">บันทึกการตั้งค่า</button>
        <button class="ghost" onclick="loadSettings()">ยกเลิกการแก้</button>
        <span id="setMsg" class="muted"></span>
      </div>
    </section>

    <!-- ---------- SUMMARY (GET /api/admin/summary) ---------- -->
    <section id="tab-summary" class="page hide">
      <div class="pagehead"><div><h1>สรุป</h1><p>ภาพรวมระบบคีย์ การออก key รายวัน และสัดส่วนที่มีคนใช้จริง</p></div></div>
      <div class="tip" id="tip-summary"><span>💡 ยอดเงินจริงอยู่ในหลังบ้านของร้าน (/console) — หน้านี้นับจำนวน key ที่ออก/ถูกใช้</span><button type="button" aria-label="ปิดคำแนะนำ" onclick="dismissTip('summary')">×</button></div>
      <div class="kpis" id="sumKpis"></div>
      <div class="cols">
        <div class="card">
          <div class="chead"><h3>key ที่ออกต่อวัน</h3><span class="muted sm" id="sumDaysNote"></span></div>
          <div class="bars" id="sumDays"></div>
        </div>
        <div class="card">
          <div class="chead"><h3>สถานะ key ทั้งหมด</h3></div>
          <div class="bars" id="sumStates"></div>
        </div>
      </div>
      <div class="card">
        <div class="chead"><h3>สินค้าที่ร้านขาย (จากหมายเหตุ)</h3><span class="muted sm">ออก = key ที่ร้านสร้างให้ออเดอร์/สต็อก · ใช้แล้ว = มีคนเปิดใช้จริง</span></div>
        <div class="bars" id="sumProducts"></div>
      </div>
    </section>
   </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
window.PAGE_NAMES = {"overview":"ภาพรวม","summary":"สรุป","create":"สร้าง key","keys":"รายการ key","online":"ใช้งานอยู่","scripts":"สคริปต์","logs":"กิจกรรม","blocks":"บล็อก / แบน","watermark":"ตามหาคนปล่อยหลุด","settings":"ตั้งค่า"};
const LS = {
  get(k, d){ try { const v = localStorage.getItem(k); return v === null ? d : v; } catch { return d; } },
  set(k, v){ try { localStorage.setItem(k, v); } catch {} },
  del(k){ try { localStorage.removeItem(k); } catch {} },
};
let TOKEN = LS.get('ks_token', '');
let STATE = { scripts: [], blocks: [], stats: {}, settings: {} };
let CUR = 'overview';
let TIMER = null, LAST_OK = 0;
/* meta = ข้อมูลร่วมทุกหน้า (สถิติ สคริปต์ บล็อก ตั้งค่า) เก็บไว้ฝั่งเบราว์เซอร์ 60 วินาที
   หน้าไหนต้องการข้อมูลเพิ่ม ขอ meta แนบมาในคำขอเดียวกัน (?meta=1) -> เปิดหน้าใดก็เรียก Worker ไม่เกิน 1 ครั้ง */
let META_AT = 0;
const META_TTL = 60000;
const needMeta = (fresh) => fresh || Date.now() - META_AT > META_TTL;
const PAGES_WITH_DATA = { overview: 1, summary: 1, keys: 1, online: 1, logs: 1 };
const perInit = (k, d) => { const v = LS.get(k, String(d)); return v === 'all' ? d : (+v || d); };
let KEYS = { rows: [], page: 1, per: perInit('ks_per_keys', 50), total: 0, pages: 1 };
let LOGS = { rows: [], page: 1, per: perInit('ks_per_logs', 50), total: null, pages: null, has_next: false };
let SELECTED = new Set();   // key ที่ติ๊กเลือกไว้ (ข้ามหน้าได้) ใช้กับแถบจัดการหมู่
let COUNT = { sig: '', val: 0 };   // จำ total ของตัวกรองที่ต้อง COUNT (ค้นหา/สถานะ) ไว้ ไม่นับซ้ำตอนเปลี่ยนหน้า
const SET_KEYS = ['brand','ui_accent','ui_accent2','getkey_url','token_ttl','announcement','default_days',
  'default_max_hwid','default_prefix','maintenance','maintenance_msg','discord_webhook',
  'webhook_events','log_retention_days','rl_enabled','rl_max_fail','rl_window_min','rl_block_min',
  'expire_notify','expire_warn_days','self_service','self_reset_days','backup_enabled','backup_webhook',
  'encrypt_source','require_roblox','watermark'];

function $(id){ return document.getElementById(id); }
function toast(msg){ const t=$('toast'); t.textContent=msg; t.classList.add('on'); clearTimeout(toast.t); toast.t=setTimeout(()=>t.classList.remove('on'),2000); }
function esc(s){ return String(s??'').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])); }
function fmt(ts){ if(!ts) return '-'; const d=new Date(ts*1000);
  return d.toLocaleString('th-TH',{day:'2-digit',month:'short',hour:'2-digit',minute:'2-digit'}); }
function fmtDate(ts){ if(!ts) return '-'; return new Date(ts*1000).toLocaleDateString('th-TH',{day:'numeric',month:'short',year:'numeric'}); }
function num(n){ return Number(n||0).toLocaleString('th-TH'); }
function nameOf(slug){ const s = STATE.scripts.find(x=>x.slug===slug); return s ? s.name : slug; }
function copyText(t){
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(t).then(()=>toast('คัดลอกแล้ว')).catch(()=>fallbackCopy(t));
  } else {
    fallbackCopy(t);
  }
}
function fallbackCopy(t){
  try {
    const ta = document.createElement('textarea');
    ta.value = t; ta.style.position = 'fixed'; ta.style.opacity = '0';
    document.body.appendChild(ta); ta.select();
    document.execCommand('copy'); ta.remove();
    toast('คัดลอกแล้ว');
  } catch(_) { toast('คัดลอกไม่สำเร็จ'); }
}
function emptyRow(cols, title, sub){
  return '<tr><td colspan="'+cols+'" class="empty"><b>'+title+'</b>'+(sub||'')+'</td></tr>';
}

async function api(path, body){
  const r = await fetch(path, {
    method: body ? 'POST' : 'GET',
    headers: { 'content-type':'application/json', authorization: 'Bearer ' + TOKEN },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (r.status === 401){ logout(); throw new Error('หมดเวลาเข้าสู่ระบบ'); }
  return await r.json();
}

async function doLogin(){
  const r = await fetch('/api/admin/login', {
    method:'POST', headers:{'content-type':'application/json'},
    body: JSON.stringify({ password: $('pw').value })
  }).then(r=>r.json()).catch(()=>({ok:false,error:'ต่อเซิร์ฟเวอร์ไม่ได้'}));
  if (!r.ok){ $('loginErr').textContent = r.error || 'เข้าสู่ระบบไม่สำเร็จ'; return; }
  TOKEN = r.token; LS.set('ks_token', TOKEN); start();
}
function logout(){ TOKEN=''; LS.del('ks_token'); clearInterval(TIMER);
  $('app').classList.add('hide'); $('login').classList.remove('hide'); closeMenu(); }

function start(){
  $('login').classList.add('hide'); $('app').classList.remove('hide');
  $('autoOn').checked = LS.get('ks_auto', '0') === '1';
  $('autoSec').value = LS.get('ks_auto_sec', '60');
  if (!$('autoSec').value) $('autoSec').value = '60';
  tab(routeFromHash()); setAuto(true);
}

// ไม่ poll อัตโนมัติ: ดึงเมื่อกดอัพเดต/หลังทำรายการ; โหมดอัตโนมัติ (ปิดไว้เป็นค่าตั้งต้น) หยุดเมื่อแท็บถูกซ่อน
function setAuto(skipSave){
  clearInterval(TIMER); TIMER = null;
  if (skipSave !== true){ LS.set('ks_auto', $('autoOn').checked ? '1' : '0'); LS.set('ks_auto_sec', $('autoSec').value); }
  if (TOKEN && $('autoOn').checked && !document.hidden)
    TIMER = setInterval(() => refresh(false), (+$('autoSec').value || 60) * 1000);
}
document.addEventListener('visibilitychange', () => {
  setAuto(true);
  if (!document.hidden && TOKEN && $('autoOn').checked && Date.now() - LAST_OK > (+$('autoSec').value || 60) * 1000) refresh(false);
});

/* ================= ดึงข้อมูล =================
   refresh(true) = ปุ่มอัปเดต / หลังแก้ข้อมูล: ข้ามแคชทั้งฝั่งเบราว์เซอร์และ Worker (fresh=1)
   refresh(false) = เปลี่ยนหน้า / รีเฟรชอัตโนมัติ: ใช้แคชได้ หน้าที่ไม่มีข้อมูลเฉพาะและ meta ยังใหม่ = ไม่เรียกเลย */
let BUSY = 0;
async function refresh(fresh){
  if (!TOKEN) return;
  fresh = fresh === true;
  const page = CUR;
  if (!PAGES_WITH_DATA[page] && !needMeta(fresh)) return;
  BUSY++; $('refreshBtn').classList.add('busy');
  try {
    if (page === 'overview') await loadOverview(fresh);
    else if (page === 'keys') await loadKeys({ recount: fresh, fresh });
    else if (page === 'logs') await loadLogs({ recount: fresh, fresh });
    else if (page === 'online') await loadOnline(fresh);
    else if (page === 'summary') await loadSummary(fresh);
    else setMeta(await api('/api/admin/meta' + (fresh ? '?fresh=1' : '')));
    $('live').style.background = 'var(--ok)';
    LAST_OK = Date.now();
    $('clock').textContent = 'อัปเดต ' + new Date().toLocaleTimeString('th-TH');
  } catch(e){ $('live').style.background = 'var(--bad)'; }
  finally { if (--BUSY <= 0){ BUSY = 0; $('refreshBtn').classList.remove('busy'); } }
}
// query string สำหรับขอ meta แนบมาด้วย (เฉพาะเมื่อของเดิมเก่า)
function metaQ(fresh){ return (needMeta(fresh) ? '&meta=1' : '') + (fresh ? '&fresh=1' : ''); }
function setMeta(m){
  if (!m || !m.stats) return;
  const first = !META_AT;
  STATE = { ...STATE, stats: m.stats, scripts: m.scripts || [], blocks: m.blocks || [], settings: m.settings || {}, custom_password: !!m.custom_password, second_password: !!m.second_password };
  META_AT = Date.now();
  renderState();
  if (first) fillSettings();   // ไม่ทับฟอร์มที่กำลังแก้อยู่ตอนรีเฟรช
}
async function loadOverview(fresh){
  const r = await api('/api/admin/overview' + (fresh ? '?fresh=1' : ''));
  if (!r.ok) return;
  setMeta(r);
  OV = r; renderOverview();
}

/* ----- key ----- */
function readFilter(){
  return { q: $('q').value.trim(), scope: $('fScope').value, status: $('fStatus').value };
}
// total ที่รู้อยู่แล้วจาก stats (ไม่ต้อง COUNT เพิ่ม) — ถ้ารู้ไม่ได้คืน null ให้เซิร์ฟเวอร์นับ
function knownTotal(f){
  const s = STATE.stats || {};
  if (f.q) return null;
  if (['expiring','disabled','bound','unused','pending','lifetime','lifetime_used','owned','shop','manual'].includes(f.status)) return null;
  if (f.scope === '' && f.status === '') return s.keys_total ?? null;
  if (f.scope === '' && f.status === 'active') return s.keys_active ?? null;
  if (f.scope === '' && f.status === 'expired') return s.keys_expired ?? null;
  if (f.status === '') {
    if (f.scope === '*') return s.keys_any ?? null;
    const b = (s.by_script || []).find(x => x.slug === f.scope);
    return b ? b.keys : null;
  }
  return null;
}
async function loadKeys(o = {}){
  const f = readFilter(), sig = JSON.stringify(f);
  const known = knownTotal(f);
  const needCount = known === null && (o.recount || sig !== COUNT.sig);
  const per = KEYS.per;
  const qs = new URLSearchParams({
    page: KEYS.page, per: per === 0 ? 'all' : per, q: f.q, scope: f.scope,
    status: f.status === 'expiring' ? '' : f.status, expiring: f.status === 'expiring' ? '1' : '',
    count: needCount ? '1' : '0',
  });
  const r = await api('/api/admin/keys/list?' + qs + metaQ(o.fresh));
  if (!r.ok) return;
  if (r.meta) setMeta(r.meta);
  let total = known;
  if (total === null){
    if (r.total !== null){ COUNT = { sig, val: r.total }; }
    total = COUNT.sig === sig ? COUNT.val : r.keys.length;
  }
  KEYS.rows = r.keys; KEYS.total = total;
  KEYS.pages = per === 0 ? 1 : Math.max(Math.ceil(total / per), 1);
  if (KEYS.page > KEYS.pages && total > 0){ KEYS.page = KEYS.pages; return loadKeys({ recount: false }); }
  renderKeys();
}
let debounceT;
function debouncedFilter(){ clearTimeout(debounceT); debounceT = setTimeout(filterChanged, 300); }
function filterChanged(){ KEYS.page = 1; loadKeys({ recount: true }); }
function setScope(v){ $('fScope').value = v; filterChanged(); }
function goKeys(status, scope, q){
  $('q').value = q || ''; $('fStatus').value = status || ''; $('fScope').value = scope || '';
  KEYS.page = 1; tab('keys');
}

/* ----- log ----- */
async function loadLogs(o = {}){
  const ok = $('logFilter').value;
  const qs = new URLSearchParams({ page: LOGS.page, per: LOGS.per, ok, count: (o.recount || LOGS.page === 1) ? '1' : '0' });
  const r = await api('/api/admin/logs/list?' + qs + metaQ(o.fresh));
  if (!r.ok) return;
  if (r.meta) setMeta(r.meta);
  LOGS.rows = r.logs; LOGS.has_next = r.has_next;
  if (r.total !== null && r.total !== undefined){ LOGS.total = r.total; LOGS.pages = Math.max(Math.ceil(r.total / LOGS.per), 1); }
  else if (ok !== '') { LOGS.total = null; LOGS.pages = null; }
  if (LOGS.pages && LOGS.page > LOGS.pages){ LOGS.page = LOGS.pages; return loadLogs({ recount: false }); }
  renderLogs();
}
function logFilterChanged(){ LOGS.page = 1; LOGS.total = null; LOGS.pages = null; loadLogs({ recount: true }); }
function avatarColor(s){ let h = 0; for (const c of String(s)) h = (h * 31 + c.charCodeAt(0)) % 360; return 'hsl('+h+',55%,42%)'; }
function ago(ts){
  const d = Math.max(0, Math.floor(Date.now()/1000) - ts);
  return d < 60 ? d + ' วิ' : d < 3600 ? Math.floor(d/60) + ' นาที' : Math.floor(d/3600) + ' ชม.';
}
let ONLINE = [], OV = null, MINI = [];
async function loadOnline(fresh){
  const r = await api('/api/admin/online?window=' + ($('onlineWin').value || 600) + metaQ(fresh === true));
  if (!r.ok) return;
  if (r.meta) setMeta(r.meta);
  ONLINE = r.online; renderOnline();
  if (+r.window === 600) setBadge('nbOnline', ONLINE.length);
}
const CHECK_TH = { ok: 'ปกติ', key_expired: 'หมดอายุ', key_disabled: 'ถูกระงับ', hwid_not_bound: 'เครื่องถูกรีเซ็ต', fail: 'ผิดปกติ' };
// ชื่อผู้เล่น Roblox (DisplayName @Name) ลิงก์ไปโปรไฟล์ — ว่าง = loader เก่า/ยังไม่เคยเข้าเกมหลังเปิดระบบ
function rbxLabel(o){
  if (!o || !o.rbx_id) return '';
  const nm = (o.rbx_display && o.rbx_display !== o.rbx_name ? o.rbx_display + ' ' : '') + '@' + (o.rbx_name || o.rbx_id);
  return '<a class="rbx" target="_blank" rel="noopener" title="UserId '+esc(o.rbx_id)+' · เปิดโปรไฟล์ Roblox" href="https://www.roblox.com/users/'+encodeURIComponent(o.rbx_id)+'/profile">'+esc(nm)+'</a>';
}
function dur(sec){
  sec = Math.max(0, Math.floor(sec));
  if (sec < 60) return sec + ' วิ';
  if (sec < 3600) return Math.floor(sec/60) + ' นาที';
  return Math.floor(sec/3600) + ' ชม. ' + Math.floor(sec % 3600 / 60) + ' นาที';
}
function onlineRow(o){
  const who = o.rbx_display || o.rbx_name || o.discord_name || o.note || o.key_value;
  const nowTs = Math.floor(Date.now()/1000), live = nowTs - o.last_ts <= 360;
  const res = o.last_result || 'ok', good = res === 'ok';
  const streak = o.sess_start ? dur(o.last_ts - o.sess_start) : '-';
  const chip = (k, v) => '<span class="oc"><small>'+k+'</small><b>'+v+'</b></span>';
  return '<div class="orow"><div class="otop"><span class="av" style="background:'+avatarColor(o.key_value)+'">'+esc(String(who).trim().charAt(0).toUpperCase()||'?')+'</span>'
    + '<span class="t"><b title="'+esc(who)+'">'+esc(who)+'</b><small class="mono" title="'+esc(o.key_value)+'">'+esc(o.key_value)+'</small></span>'
    + '<span class="pill '+(live ? 'ok' : 'warn')+'">'+(live ? 'ออนไลน์' : 'เพิ่งหลุด')+'</span></div>'
    + '<div class="ochips">'
    + (o.rbx_id ? chip('ผู้เล่น Roblox', rbxLabel(o)) : '')
    + chip('สคริปต์ · ' + num(o.devices) + ' เครื่อง', esc(nameOf(o.script_slug) || 'ทุกสคริปต์'))
    + chip('ออนไลน์ต่อเนื่อง', esc(streak))
    + chip('เช็คล่าสุด', new Date(o.last_ts*1000).toLocaleTimeString('th-TH') + '<small>'+ago(o.last_ts)+'ที่แล้ว</small>')
    + chip('ผลเช็ค', '<span class="pill '+(good ? 'ok' : 'bad')+'">'+esc(CHECK_TH[res] || res)+'</span>')
    + '</div></div>';
}
function renderOnline(){
  const q = $('onlineQ').value.trim().toUpperCase();
  const list = !q ? ONLINE : ONLINE.filter(o => [o.discord_name, o.note, o.key_value, o.rbx_name, o.rbx_display, o.rbx_id].some(v => String(v||'').toUpperCase().includes(q)));
  $('onlineCount').textContent = num(list.length);
  $('onlineList').innerHTML = list.map(onlineRow).join('')
    || '<div class="empty-box">'+(q ? 'ไม่พบที่ตรงกับคำค้น' : 'ช่วงนี้ยังไม่มีใครใช้งาน')+'</div>';
}
function setBadge(id, n){ const b = $(id); if (b) b.textContent = n ? (n > 999 ? '999+' : String(n)) : ''; }

/* ----- หน้าภาพรวม ----- */
function renderOverview(){
  if (!OV) return;
  const s = STATE.stats || {}, cfg = STATE.settings || {};
  const online = OV.online || [];
  const devices = online.reduce((a, o) => a + (o.devices || 0), 0);
  setBadge('nbOnline', online.length);
  const warn = Number(cfg.expire_warn_days) || 3;
  const kpi = (tone, label, val, sub, go) =>
    '<button class="kpi '+tone+'" onclick="'+go+'"><span class="k">'+label+'</span><b>'+num(val)+'</b><small>'+sub+'</small></button>';
  $('kpis').innerHTML = [
    kpi('ok', 'กำลังใช้งาน', online.length, num(devices) + ' เครื่อง · 10 นาทีล่าสุด', "tab('online')"),
    kpi('', 'key ใช้งานได้', s.keys_active, 'จากทั้งหมด ' + num(s.keys_total) + ' ใบ', "goKeys('active')"),
    kpi('', 'เข้าใช้ 24 ชม.', s.redeem_24h, 'ครั้งที่ใช้ key สำเร็จ', "tab('logs')"),
    kpi(s.expiring_soon ? 'warn' : '', 'ใกล้หมดอายุ', s.expiring_soon, 'ภายใน ' + warn + ' วัน', "goKeys('expiring')"),
    kpi(s.keys_expired ? 'warn' : '', 'หมดอายุแล้ว', s.keys_expired, 'ต่ออายุหรือลบทิ้ง', "goKeys('expired')"),
    kpi(s.blocked ? 'bad' : '', 'ถูกบล็อก', s.blocked, 'IP / เครื่อง', "tab('blocks')"),
  ].join('');
  $('ovOnlineN').textContent = num(online.length);
  $('ovOnline').innerHTML = online.slice(0, 6).map(onlineRow).join('')
    + (online.length > 6 ? '<button class="ghost sm more" onclick="tab(\'online\')">อีก '+num(online.length - 6)+' คน ›</button>' : '')
    || '<div class="empty-box">ช่วงนี้ยังไม่มีใครใช้งาน</div>';
  const per = s.by_script || [], max = Math.max(1, ...per.map(x => x.keys));
  $('ovScripts').innerHTML = per.map(x => {
    const sc = STATE.scripts.find(y => y.slug === x.slug) || {};
    return '<button class="brow plain" onclick="goKeys(\'\',\''+esc(x.slug)+'\')"><span class="n">'+esc(x.name)
      + (sc.enabled === 0 ? ' <span class="pill bad">ปิด</span>' : '') + '</span>'
      + '<span class="b"><i style="width:'+Math.round(x.keys / max * 100)+'%"></i></span><b>'+num(x.keys)+'</b></button>';
  }).join('') || ('<div class="empty-box">ยังไม่มีสคริปต์ <button class="sm" onclick="tab(\'scripts\');editScript(null)">+ เพิ่มสคริปต์</button></div>');
  $('ovAny').textContent = s.keys_any ? 'รวม key ที่ใช้ได้ทุกสคริปต์ ' + num(s.keys_any) + ' ใบ ในทุกแถว' : '';
  MINI = OV.logs || [];
  $('logsMini').innerHTML = logLines(MINI, 'm');
}
const EVENT_TH = { redeem: 'ใช้ key', fetch_script: 'ดึงสคริปต์', blocked: 'บล็อก', admin_login: 'เข้าแอดมิน', settings: 'ตั้งค่า', restore: 'กู้คืน', bulk: 'จัดการหมู่', script_publish: 'เผยแพร่สคริปต์', script_rollback: 'ย้อนเวอร์ชัน' };
function logLines(list, src){
  return list.map((l,i)=>{
    return '<div class="lrow '+(l.ok?'ok':'bad')+'" data-src="'+src+'" data-i="'+i+'"><span class="tm">'+fmt(l.ts)+'</span>'
      + '<span class="ev">'+esc(EVENT_TH[l.event] || l.event)+'</span>'
      + '<span class="kv mono">'+esc(l.key_value||'-')+'</span>'
      + '<span class="dt">'+esc([nameOf(l.script_slug||''), l.detail||'', l.rbx_name ? '@' + l.rbx_name : ''].filter(Boolean).join(' · '))+'</span></div>';
  }).join('') || '<div class="empty-box">ยังไม่มีกิจกรรม</div>';
}

/* ================= หน้าสรุป ================= */
let SUM = null;
async function loadSummary(fresh){
  const r = await api('/api/admin/summary' + (fresh ? '?fresh=1' : '') + (needMeta(fresh) ? (fresh ? '&' : '?') + 'meta=1' : ''));
  if (!r.ok) return;
  if (r.meta) setMeta(r.meta);
  SUM = r; renderSummary();
}
function sumBars(rows, maxOf){
  const max = Math.max(1, ...rows.map(maxOf));
  return rows.map(x => '<div class="brow"><span class="n">'+x.label+'</span><span class="b"><i style="width:'+Math.round(maxOf(x) / max * 100)+'%"></i></span><b>'+x.val+'</b></div>').join('');
}
function renderSummary(){
  if (!SUM) return;
  const k = SUM.keys, pct = (a, b) => b ? Math.round(a / b * 100) + '%' : '—';
  const kpi = (tone, label, val, sub) => '<div class="kpi '+tone+'"><span class="k">'+label+'</span><b>'+val+'</b><small>'+sub+'</small></div>';
  $('sumKpis').innerHTML = [
    kpi('', 'key ทั้งหมด', num(k.total), 'ใช้ได้ ' + num(k.active) + ' · ระงับ ' + num(k.disabled)),
    kpi('ok', 'ออนไลน์ตอนนี้', num(SUM.online), 'เข้าใช้ 24 ชม. ' + num(SUM.redeem_24h) + ' ครั้ง'),
    kpi('', 'ร้านขาย', num(k.shop), 'มีคนใช้จริง ' + num(k.shop_used) + ' (' + pct(k.shop_used, k.shop) + ')'),
    kpi(k.pending ? 'warn' : '', 'ยังไม่เริ่มนับ', num(k.pending), 'รอลูกค้าใช้ครั้งแรก'),
    kpi(k.expiring ? 'warn' : '', 'ใกล้หมดอายุ', num(k.expiring), 'ภายใน ' + ((STATE.settings || {}).expire_warn_days || 3) + ' วัน'),
    kpi(k.lifetime_used ? 'warn' : '', 'ตลอดชีพ + ใช้แล้ว', num(k.lifetime_used), 'จากตลอดชีพทั้งหมด ' + num(k.lifetime)),
  ].join('');
  $('sumDaysNote').textContent = SUM.days + ' วันล่าสุด · เส้นสว่าง = ใช้แล้ว';
  $('sumDays').innerHTML = sumBars(SUM.per_day.map(d => ({ label: d.d.slice(5), val: num(d.issued) + ' <small class="muted">(ร้าน ' + num(d.shop) + ' · ใช้ ' + num(d.used) + ')</small>', issued: d.issued })), x => x.issued)
    || '<div class="empty-box">ยังไม่มี key ใหม่ในช่วงนี้</div>';
  const st = [['ใช้ได้', k.active], ['ยังไม่เริ่มนับ', k.pending], ['ใกล้หมดอายุ', k.expiring], ['หมดอายุแล้ว', k.expired], ['ถูกระงับ', k.disabled],
    ['มีเครื่องผูกแล้ว', SUM.bound], ['ยังว่าง (ไม่มีเครื่องผูก)', k.total - SUM.bound]];
  $('sumStates').innerHTML = sumBars(st.map(([label, v]) => ({ label, val: num(v), v })), x => x.v);
  $('sumProducts').innerHTML = SUM.products.length
    ? sumBars(SUM.products.map(p => ({ label: esc(p.note.replace(/^ร้าน\s*/, '')), val: num(p.issued) + ' <small class="muted">(ใช้ ' + num(p.used) + ')</small>', v: p.issued })), x => x.v)
    : '<div class="empty-box">ยังไม่มี key ที่ร้านออก</div>';
}
/* ================= แบ่งหน้า ================= */
function pageList(c, l){
  if (l <= 7) return Array.from({ length: l }, (_, i) => i + 1);
  const a = [...new Set([1, 2, l - 1, l, c - 1, c, c + 1].filter(n => n >= 1 && n <= l))].sort((x, y) => x - y);
  const out = [];
  a.forEach((n, i) => {
    if (i && n - a[i-1] > 1) out.push(n - a[i-1] === 2 ? n - 1 : '…');
    out.push(n);
  });
  return out;
}
function pagerHtml(kind, P, allOpt){
  const opts = [25, 50, 100].concat(allOpt ? [0] : []);
  const per = '<label class="per">ต่อหน้า <select onchange="setPer(\''+kind+'\', this.value)">'
    + opts.map(v => '<option value="'+v+'"'+(P.per===v?' selected':'')+'>'+(v===0?'ทั้งหมด':v)+'</option>').join('')
    + '</select></label>';
  let info, pg = '';
  const shown = P.rows.length;
  if (P.total === null){                       // ไม่รู้จำนวนรวม (log ที่กรองอยู่): ก่อนหน้า/ถัดไป
    info = shown ? 'หน้า ' + P.page + ' · ' + shown + ' รายการ' : 'ไม่มีรายการ';
    pg = '<button class="ghost" '+(P.page<=1?'disabled':'')+' onclick="goPage(\''+kind+'\','+(P.page-1)+')">‹ ก่อนหน้า</button>'
       + '<button class="ghost" '+(!P.has_next?'disabled':'')+' onclick="goPage(\''+kind+'\','+(P.page+1)+')">ถัดไป ›</button>';
  } else {
    const from = P.total ? (P.per === 0 ? 1 : (P.page - 1) * P.per + 1) : 0;
    info = P.total ? 'แสดง ' + num(from) + '–' + num(from + shown - 1) + ' จาก ' + num(P.total) + (kind==='logs' ? ' (โดยประมาณ)' : '') : 'ไม่มีรายการ';
    if (P.pages > 1){
      pg = '<button class="ghost" aria-label="หน้าแรก" '+(P.page<=1?'disabled':'')+' onclick="goPage(\''+kind+'\',1)">«</button>'
         + '<button class="ghost" aria-label="ก่อนหน้า" '+(P.page<=1?'disabled':'')+' onclick="goPage(\''+kind+'\','+(P.page-1)+')">‹</button>'
         + pageList(P.page, P.pages).map(n => n === '…' ? '<span class="gap">…</span>'
             : '<button class="'+(n===P.page?'cur':'ghost')+'" onclick="goPage(\''+kind+'\','+n+')">'+n+'</button>').join('')
         + '<button class="ghost" aria-label="ถัดไป" '+(P.page>=P.pages?'disabled':'')+' onclick="goPage(\''+kind+'\','+(P.page+1)+')">›</button>'
         + '<button class="ghost" aria-label="หน้าสุดท้าย" '+(P.page>=P.pages?'disabled':'')+' onclick="goPage(\''+kind+'\','+P.pages+')">»</button>';
    }
  }
  return '<div class="info">'+info+'</div><div class="pg">'+pg+'</div>'+per;
}
function goPage(kind, n){
  if (kind === 'keys'){ KEYS.page = Math.max(1, n); loadKeys({ recount: false }); }
  else { LOGS.page = Math.max(1, n); loadLogs({ recount: false }); }
  window.scrollTo({ top: 0, behavior: 'smooth' });
}
function setPer(kind, v){
  const P = kind === 'keys' ? KEYS : LOGS;
  v = +v;
  if (v === 0){
    if (!confirm('โหลด key ทั้งหมด ' + num(KEYS.total) + ' รายการในครั้งเดียว?\nอ่านข้อมูลจากฐานข้อมูลมากขึ้นทุกครั้งที่อัพเดต (ใช้เมื่อจำเป็นเท่านั้น)')){
      renderKeys(); return;
    }
  } else LS.set('ks_per_' + kind, String(v));    // "ทั้งหมด" ไม่จำไว้ ต้องกดเองทุกครั้ง
  P.per = v; P.page = 1;
  if (kind === 'keys') loadKeys({ recount: false }); else loadLogs({ recount: true });
}

/* ================= แสดงผล ================= */
function renderState(){
  const s = STATE.stats || {};
  const cfg = STATE.settings || {};
  if (cfg.brand) for (const id of ['brandTitle','brandSide']) if ($(id)) $(id).textContent = cfg.brand;
  $('maintFlag').classList.toggle('hide', cfg.maintenance !== '1');
  setBadge('nbBlocked', s.blocked); setBadge('nbKeys', s.keys_total); setBadge('nbScripts', s.scripts);
  $('blockCount').textContent = num((STATE.blocks||[]).length);
  $('scriptCount').textContent = num(STATE.scripts.length);

  renderAttention(s, cfg);

  // ตัวกรองหมวด (select + แถบ chip เลื่อนได้)
  const cur = $('fScope').value;
  $('scriptChips').innerHTML =
    '<div class="chip'+(cur===''?' on':'')+'" onclick="setScope(\'\')">ทุกหมวด<b>'+num(s.keys_total)+'</b></div>'
    + '<div class="chip'+(cur==='*'?' on':'')+'" onclick="setScope(\'*\')">ใช้ได้ทุกสคริปต์<b>'+num(s.keys_any)+'</b></div>'
    + (s.by_script||[]).map(x =>
        '<div class="chip'+(cur===x.slug?' on':'')+'" onclick="setScope(\''+esc(x.slug)+'\')">'+esc(x.name)+'<b>'+num(x.keys)+'</b></div>').join('');
  const optHtml = '<option value="">— ทุกหมวด —</option><option value="*">เฉพาะ key ที่ใช้ได้ทุกสคริปต์</option>'
    + STATE.scripts.map(x=>'<option value="'+esc(x.slug)+'">'+esc(x.name)+'</option>').join('');
  if ($('fScope').dataset.sig !== optHtml){ $('fScope').innerHTML = optHtml; $('fScope').value = cur; $('fScope').dataset.sig = optHtml; }

  renderScopeBox();

  const counts = Object.fromEntries((s.by_script||[]).map(x=>[x.slug, x.keys]));
  $('scriptRows').innerHTML = STATE.scripts.map(sc=>{
    const line = 'loadstring(game:HttpGet("'+location.origin+'/loader/'+sc.slug+'"))()';
    return '<tr><td>'+esc(sc.name)+'</td><td class="mono nm">'+esc(sc.slug)+'</td>'
      + '<td class="nw">'+(sc.version_label?'<span class="pill tag">v'+esc(sc.version_label)+'</span> <span class="muted">'+fmtDate(sc.released_at)+'</span>':'<span class="muted">-</span>')+'</td>'
      + '<td class="muted nw">'+((sc.size||0)/1024).toFixed(1)+' KB</td>'
      + '<td><span class="chip" onclick="goKeys(\'\',\''+esc(sc.slug)+'\')">'+num(counts[sc.slug]||0)+' key</span></td>'
      + '<td class="pri">'+(sc.enabled?'<span class="pill ok">เปิด</span>':'<span class="pill bad">ปิด</span>')+'</td>'
      + '<td><button class="ghost sm" onclick="copyText('+JSON.stringify(line).replace(/"/g,'&quot;')+')">คัดลอกโค้ดเรียกใช้</button></td>'
      + '<td class="nw"><button class="ghost sm" onclick="editScript(\''+sc.id+'\')">แก้ไข</button> '
      + '<button class="ghost sm" onclick="openHistory(\''+sc.id+'\')">ประวัติ</button> '
      + '<button class="danger sm" onclick="delScript(\''+sc.id+'\')">ลบ</button></td></tr>';
  }).join('') || emptyRow(8, 'ยังไม่มีสคริปต์', 'กด “+ เพิ่มสคริปต์” เพื่อเริ่มต้น');

  $('blockRows').innerHTML = (STATE.blocks||[]).map(b=>
    '<tr><td class="mono">'+esc(b.value)+'</td>'
    + '<td class="pri">'+(b.kind==='ip'?'IP':'HWID')+'</td>'
    + '<td class="muted">'+esc(b.reason||'')+'</td>'
    + '<td>'+(b.permanent?'<span class="pill bad">ถาวร</span>':fmt(b.until))+'</td>'
    + '<td><button class="ghost sm" onclick="unblockOne(\''+esc(b.id)+'\')">ปลดบล็อก</button></td></tr>'
  ).join('') || emptyRow(5, 'ยังไม่มีใครถูกบล็อก', 'ระบบจะบล็อกอัตโนมัติเมื่อมีคนกรอก key ผิดถี่เกินกำหนด');
  updateScopeInfo();
}

function renderAttention(s, cfg){
  const items = [];
  const mk = (tone, pill, html, sub, go) => items.push(
    '<button class="attn-item plain '+tone+'" onclick="'+go+'"><span class="pill '+tone+'">'+pill+'</span>'
    + '<span class="t">'+html+(sub?'<small>'+sub+'</small>':'')+'</span><span class="go">ดูรายการ ›</span></button>');
  if (s.keys_expired > 0) mk('warn', 'หมดอายุแล้ว', '<b>'+num(s.keys_expired)+' key</b> หมดอายุแล้ว', 'ลูกค้าใช้ไม่ได้ — ต่ออายุหรือลบทิ้ง', "goKeys('expired')");
  if (s.expiring_soon > 0) mk('warn', 'ใกล้หมดอายุ', '<b>'+num(s.expiring_soon)+' key</b> ใกล้หมดอายุ', 'ติดต่อลูกค้าเพื่อต่ออายุ', "goKeys('expiring')");
  if (s.blocked > 0) mk('bad', 'ถูกบล็อก', '<b>'+num(s.blocked)+' รายการ</b> ถูกบล็อกอยู่', 'ตรวจว่ามีใครโดนบล็อกผิด', "tab('blocks')");
  if (!(STATE.scripts||[]).length) mk('warn', 'ยังไม่มีสคริปต์', 'ยังไม่ได้เพิ่มสคริปต์', 'ลูกค้าจะใช้ key ไม่ได้จนกว่าจะมีสคริปต์', "tab('scripts');editScript(null)");
  const maint = cfg.maintenance === '1';
  if (maint) mk('warn', 'ปิดปรับปรุง', 'โหมดปิดปรับปรุงเปิดอยู่', 'ลูกค้าทุกคนใช้ key ไม่ได้จนกว่าจะเปิดกลับ', "toggleMaint()");
  $('attn').innerHTML = items.join('')
    || '<div class="attn-item ok"><span class="pill ok">ปกติ</span><span class="t">ไม่มีอะไรต้องดูแลตอนนี้<small>ระบบทำงานปกติ</small></span></div>';
  const mr = $('maintRow');
  if (mr) mr.innerHTML = '<span class="t">โหมดปิดปรับปรุง: <b style="color:'+(maint?'var(--warn)':'var(--ok)')+'">'+(maint?'เปิดอยู่':'ปิดอยู่')+'</b> — หยุดให้ทุก key ใช้งานชั่วคราว</span>'
    + '<button class="ghost sm" onclick="toggleMaint()">'+(maint?'เปิดให้ใช้งานปกติ':'เปิดโหมดปิดปรับปรุง')+'</button>';
}
async function toggleMaint(){
  const on = (STATE.settings||{}).maintenance === '1';
  if (!on && !confirm('เปิดโหมดปิดปรับปรุง? ลูกค้าทุกคนจะใช้ key ไม่ได้จนกว่าจะเปิดกลับ')) return;
  const r = await api('/api/admin/settings/save', { settings: { maintenance: on ? '0' : '1' } });
  if (!r.ok) return toast(r.error || 'บันทึกไม่สำเร็จ');
  toast(on ? 'เปิดให้ใช้งานปกติแล้ว' : 'เปิดโหมดปิดปรับปรุงแล้ว'); refresh(true);
}

function updateScopeInfo(){
  const f = $('fScope').value, st = $('fStatus').value;
  const stName = { active:'ใช้ได้', expiring:'ใกล้หมดอายุ', expired:'หมดอายุแล้ว', disabled:'ถูกระงับ' }[st];
  const sc = f === '' ? 'ทุกหมวด' : f === '*' ? 'เฉพาะที่ใช้ได้ทุกสคริปต์' : nameOf(f) + ' (รวมที่ใช้ได้ทุกสคริปต์)';
  $('scopeInfo').textContent = sc + (stName ? ' · ' + stName : '') + ($('q').value.trim() ? ' · ค้นหา “' + $('q').value.trim() + '”' : '');
}

function renderKeys(){
  const nowSec = Math.floor(Date.now()/1000);
  $('keyCount').textContent = num(KEYS.total);
  $('keyRows').innerHTML = KEYS.rows.map(k=>{
    const expired = k.expires_at && k.expires_at <= nowSec;
    const st = !k.enabled ? '<span class="pill bad">ระงับ</span>'
      : expired ? '<span class="pill warn">หมดอายุ</span>' : '<span class="pill ok">ใช้ได้</span>';
    const scope = k.scope === '*'
      ? '<span class="pill tag">ทุกสคริปต์</span>'
      : k.scope.split(',').map(sl=>'<span class="pill tag">'+esc(nameOf(sl))+'</span>').join('');
    const on = SELECTED.has(k.key_value);
    return '<tr class="'+(on?'sel':'')+'">'
      + '<td class="chk full"><input type="checkbox" class="rowchk" aria-label="เลือก '+esc(k.key_value)+'" data-v="'+esc(k.key_value)+'"'+(on?' checked':'')+' onchange="selToggle(this)"></td>'
      + '<td class="full" data-l="KEY"><div class="keycell"><span class="mono">'+esc(k.key_value)+'</span>'
      + '<button class="ghost sm" aria-label="คัดลอก key" onclick="copyText(\''+esc(k.key_value)+'\')">คัดลอก</button></div></td>'
      + '<td class="pri" data-l="สถานะ">'+st+'</td>'
      + '<td data-l="หมวด"><div class="tags">'+scope+'</div></td>'
      + '<td data-l="เครื่อง">'+k.devices+' / '+(k.max_hwid===0?'∞':k.max_hwid)
      + (k.hwid?'<div class="mono muted sm" title="HWID: '+esc(k.hwid)+(k.hwid_released?' (ล้างแล้ว '+fmt(k.hwid_released)+')':'')+'">'+esc(String(k.hwid).slice(0,14))+(String(k.hwid).length>14?'…':'')+(k.hwid_released?' <span class="pill tag">ล้างแล้ว</span>':'')+'</div>':'')
      + (k.rbx_id?'<div class="sm'+(k.hwid_released?' muted':'')+'">'+rbxLabel(k)+'</div>':'')
      + (k.rbx_accounts>1?'<button class="ghost sm warnbtn" title="key นี้เคยถูกใช้หลายบัญชี Roblox (อาจแชร์ key)" onclick="showPlayers(\''+esc(k.key_value)+'\')">'+k.rbx_accounts+' บัญชี</button>'
        :(k.rbx_accounts?'<button class="ghost sm" onclick="showPlayers(\''+esc(k.key_value)+'\')">ประวัติ</button>':''))+'</td>'
      + '<td class="nw" data-l="หมดอายุ">'+(k.expires_at?fmt(k.expires_at):(k.duration_days?'<span class="muted">ยังไม่เริ่มนับ ('+k.duration_days+' วัน)</span>':'<span class="muted">ตลอดชีพ</span>'))+'</td>'
      + '<td class="nw" data-l="ใช้ล่าสุด">'+fmt(k.last_used_at)+'</td>'
      + '<td class="muted full note" data-l="หมายเหตุ" title="'+esc(k.note||'')+'">'+esc(k.note||'-')+(k.discord_id?' <span class="pill tag" title="Discord ID: '+esc(k.discord_id)+'">'+esc(k.discord_name||'Discord')+'</span>':'')+'</td>'
      + '<td class="nw full"><button class="ghost sm menubtn" data-menu onclick="rowMenu(this,\''+k.id+'\',\''+esc(k.key_value)+'\','+(k.enabled?1:0)+')">จัดการ <svg viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg></button></td></tr>';
  }).join('') || emptyRow(9, 'ไม่มี key ตามตัวกรองนี้', 'ลองเปลี่ยนตัวกรอง/คำค้น หรือสร้าง key ใหม่');
  $('pgKeys').innerHTML = pagerHtml('keys', KEYS, true);
  renderSelBar();
  updateScopeInfo();
  const chips = $('scriptChips'); if (chips){
    const cur = $('fScope').value;
    [...chips.children].forEach((c, i) => {
      const v = i === 0 ? '' : i === 1 ? '*' : (STATE.stats.by_script||[])[i-2]?.slug;
      c.classList.toggle('on', v === cur);
    });
  }
}
function renderLogs(){
  $('logs').innerHTML = logLines(LOGS.rows, 'l');
  $('logCount').textContent = LOGS.total === null ? '' : '≈ ' + num(LOGS.total);
  $('pgLogs').innerHTML = pagerHtml('logs', LOGS, false);
}

/* ================= หมวดตอนสร้าง key (popover) ================= */
function renderScopeBox(){
  const box = $('cScope');
  const checked = new Set([...box.querySelectorAll('input:checked')].map(i=>i.value));
  const first = !box.dataset.init;
  const wantAll = first || checked.size === 0 || checked.has('*');
  const q = ($('cScopeQ').value || '').trim().toLowerCase();
  const rows = [{ v:'*', n:'ทุกสคริปต์' }].concat(STATE.scripts.map(x=>({ v:x.slug, n:x.name })));
  box.innerHTML = rows.map(r => {
    const on = r.v === '*' ? wantAll : checked.has(r.v);
    const hide = q && r.v !== '*' && !(r.n.toLowerCase().includes(q) || r.v.toLowerCase().includes(q));
    return '<label'+(hide?' hidden':'')+'><input type="checkbox" value="'+esc(r.v)+'"'+(on?' checked':'')
      + ' onchange="'+(r.v==='*'?'scopeAllToggle(this)':'scopeOneToggle()')+'"> '+esc(r.n)+'</label>';
  }).join('') + (q && rows.slice(1).every(r => !(r.n.toLowerCase().includes(q) || r.v.toLowerCase().includes(q)))
    ? '<div class="none">ไม่พบสคริปต์</div>' : '');
  box.dataset.init = '1';
  updateScopeLabel();
}
function scopeAllToggle(el){
  if (el.checked){ for (const i of $('cScope').querySelectorAll('input')) if (i.value !== '*') i.checked = false; }
  else el.checked = true;   // ต้องมีอย่างน้อยหนึ่งอย่าง: ไม่ติ๊กอะไรเลย = ทุกสคริปต์
  updateScopeLabel();
}
function scopeOneToggle(){
  const any = [...$('cScope').querySelectorAll('input')].some(i=>i.value!=='*' && i.checked);
  $('cScope').querySelector('input[value="*"]').checked = !any;
  updateScopeLabel();
}
function currentScope(){
  const picked = [...$('cScope').querySelectorAll('input:checked')].map(i=>i.value).filter(v=>v!=='*');
  return picked.length ? picked.join(',') : '*';
}
function updateScopeLabel(){
  const picked = currentScope();
  const list = picked === '*' ? [] : picked.split(',');
  $('cScopeLbl').textContent = !list.length ? 'ทุกสคริปต์' : list.length === 1 ? nameOf(list[0]) : 'เลือก ' + list.length + ' สคริปต์';
  $('cScopeCnt').textContent = !list.length ? 'ทุกสคริปต์' : 'เลือกแล้ว ' + list.length + ' จาก ' + STATE.scripts.length;
}
function mselAll(){
  for (const i of $('cScope').querySelectorAll('input')) i.checked = i.value === '*';
  updateScopeLabel();
}
function mselToggle(force){
  const w = $('cScopeWrap'), open = force === undefined ? !w.classList.contains('open') : force;
  w.classList.toggle('open', open); $('cScopePop').classList.toggle('hide', !open);
  if (open){ $('cScopeQ').value = ''; renderScopeBox(); placeMsel(); }
}
/* popup หมวด: fixed + คำนวณให้อยู่ในจอเสมอ (ไม่ชนขอบซ้าย/ขวา/ล่าง) */
function placeMsel(){
  const pop = $('cScopePop'); if (!pop || pop.classList.contains('hide')) return;
  const r = $('cScopeBtn').getBoundingClientRect();
  const w = Math.min(Math.max(r.width, 280), innerWidth - 16);
  pop.style.width = w + 'px';
  const h = pop.offsetHeight;
  pop.style.left = Math.max(8, Math.min(r.left, innerWidth - w - 8)) + 'px';
  pop.style.top = (r.bottom + 6 + h > innerHeight - 8 ? Math.max(8, r.top - h - 6) : r.bottom + 6) + 'px';
}
window.addEventListener('resize', placeMsel);
window.addEventListener('scroll', placeMsel, true);
document.addEventListener('mousedown', e => { if (!e.target.closest('#cScopeWrap')) mselToggle(false); });

/* ================= เมนูลอย ================= */
let MENU_BTN = null;
function closeMenu(){ const m = $('fmenu'); if (m) m.remove(); MENU_BTN = null; }
function openMenu(btn, items){
  if (MENU_BTN === btn){ closeMenu(); return; }
  closeMenu();
  const m = document.createElement('div'); m.className = 'fmenu'; m.id = 'fmenu';
  items.forEach(it => {
    if (it === '-'){ m.appendChild(document.createElement('hr')); return; }
    if (it.cap){ const c = document.createElement('div'); c.className = 'cap'; c.textContent = it.cap; m.appendChild(c); return; }
    const b = document.createElement('button'); b.textContent = it.label; if (it.danger) b.className = 'danger';
    b.onclick = () => { closeMenu(); closeSheet(); it.run(); }; m.appendChild(b);
  });
  document.body.appendChild(m); MENU_BTN = btn;
  const r = btn.getBoundingClientRect(), w = m.offsetWidth, h = m.offsetHeight;
  m.style.left = Math.max(8, Math.min(r.right - w, innerWidth - w - 8)) + 'px';
  m.style.top = (r.bottom + 6 + h > innerHeight ? Math.max(8, r.top - h - 6) : r.bottom + 6) + 'px';
}
document.addEventListener('mousedown', e => { if (!e.target.closest('#fmenu,[data-menu]')) closeMenu(); });
document.addEventListener('keydown', e => { if (e.key === 'Escape'){ closeMenu(); mselToggle(false); closeOpts(); if (window.closeSelModal) closeSelModal(); } });
window.addEventListener('scroll', closeMenu, { passive: true });
function rowMenu(btn, id, val, enabled){
  openMenu(btn, [
    { cap: 'ต่ออายุ' },
    { label: '+ 7 วัน', run: () => extendBy(id, 7) }, { label: '+ 30 วัน', run: () => extendBy(id, 30) },
    { label: '+ 90 วัน', run: () => extendBy(id, 90) }, { label: '+ 1 ปี', run: () => extendBy(id, 365) },
    '-',
    { label: enabled ? 'ระงับ key' : 'เปิดใช้ key', run: () => toggleKey(id, enabled ? 0 : 1) },
    { label: 'ล้าง HWID', run: () => resetKey(id) },
    '-',
    { label: 'ลบ key', danger: true, run: () => delKey(val) },
  ]);
}
function bulkMenu(btn){
  openMenu(btn, [
    { cap: 'เลือก key (ยังไม่ทำอะไรจนกว่าจะกดยืนยัน)' },
    { label: 'เลือกทั้งหน้านี้', run: () => selPage(true) },
    { label: 'เลือกทั้งหมดที่ตรงตัวกรอง', run: () => selMatching() },
    { label: 'เลือก key ที่หมดอายุทั้งหมด', run: () => selMatching('expired') },
    '-',
    { label: 'ยกเลิกการเลือก', run: () => selClear() },
  ]);
}

/* ================= ตัวเลือกบนแถบบน ================= */
function toggleOpts(){ $('optsPop').classList.toggle('hide'); }
function closeOpts(){ const p = $('optsPop'); if (p) p.classList.add('hide'); }
document.addEventListener('mousedown', e => { if (!e.target.closest('.opts')) closeOpts(); });

/* ================= นำทาง =================
   หนึ่งเมนู = หนึ่งหน้า (#/ชื่อหน้า ใน URL: กดย้อนกลับ/รีโหลดแล้วอยู่หน้าเดิม) */
const ALIAS = { security: 'blocks' };
function routeFromHash(){
  const h = (location.hash.match(/^#\/?([\w-]+)/) || [])[1] || CUR;
  const n = ALIAS[h] || h;
  return $('tab-' + n) ? n : 'overview';
}
function tab(name){
  name = ALIAS[name] || name;
  if (!$('tab-' + name)) name = 'overview';
  const changed = CUR !== name;
  CUR = name;
  for (const b of document.querySelectorAll('.nav[data-tab]')) b.classList.toggle('on', b.dataset.tab===name);
  for (const p of document.querySelectorAll('section.page')) p.classList.toggle('hide', p.id !== 'tab-'+name);
  if (location.hash !== '#/' + name) history.replaceState(null, '', '#/' + name);
  document.title = ((window.PAGE_NAMES||{})[name] || name) + ' · ' + ((STATE.settings||{}).brand || 'Key System');
  if (name === 'settings') fillSettings();
  if (name === 'create') renderScopeBox();
  closeMenu(); closeSheet(); closeDD(); fitSoon(); if (window.closeMobNav) window.closeMobNav();
  if (changed) window.scrollTo(0, 0);
  if (TOKEN) refresh(false);
}
window.addEventListener('hashchange', () => { const n = routeFromHash(); if (n !== CUR) tab(n); });
function jumpTo(a){
  const t = document.querySelector(a.getAttribute('href'));
  if (t) t.scrollIntoView({ behavior: 'smooth', block: 'start' });
  return false;
}

/* ตารางบนจอเล็ก: แตะกล่อง แล้วเด้งแผ่นรายละเอียด + ปุ่มจัดการ (ไม่ต้องเลื่อนซ้าย-ขวา) */
function closeSheet(){ const s = $('sheet'); if (s) s.remove(); document.body.classList.remove('sheet-open'); }
function buildSheet(title, fields, acts){
  closeSheet();
  const body = fields.map(f => '<div class="sf"><span>'+esc(f[0])+'</span><div>'+f[1]+'</div></div>').join('');
  const el = document.createElement('div'); el.id = 'sheet'; el.className = 'sheet';
  el.innerHTML = '<div class="sheet-bg" data-close></div><div class="sheet-box" role="dialog" aria-modal="true">'
    + '<div class="sheet-h"><b class="mono">'+esc(title)+'</b><button class="ghost sm" data-close aria-label="ปิด">✕</button></div>'
    + '<div class="sheet-b">'+body+'</div>' + (acts ? '<div class="sheet-a">'+acts+'</div>' : '') + '</div>';
  el.addEventListener('click', e => {
    if (e.target.closest('[data-close]')) return closeSheet();
    if (e.target.closest('button') && !e.target.closest('[data-menu]')) setTimeout(closeSheet, 0);
  });
  document.body.appendChild(el); document.body.classList.add('sheet-open');
}
function openRowSheet(tr){
  const ths = [...tr.closest('table').querySelectorAll('thead th')].map(t => t.textContent.trim());
  let title = '', acts = ''; const fields = [];
  [...tr.children].forEach((td, i) => {
    if (i === 0){
      const m = td.querySelector('.mono'); title = (m || td).textContent.trim();
      td.querySelectorAll('button').forEach(b => { acts += b.outerHTML; });
    }
    if (!ths[i]) { acts += td.innerHTML; return; }
    if (i === 0) return;
    fields.push([ths[i], td.innerHTML]);
  });
  buildSheet(title, fields, acts);
}
function openLogSheet(l){
  buildSheet(l.event || 'log', [
    ['เวลา', esc(fmt(l.ts))],
    ['ผลลัพธ์', l.ok ? '<span class="pill ok">สำเร็จ</span>' : '<span class="pill bad">ไม่สำเร็จ</span>'],
    ['KEY', '<span class="mono">'+esc(l.key_value||'-')+'</span>'],
    ['สคริปต์', esc(l.script_slug||'-')],
    ['รายละเอียด', esc(l.detail||'-')],
    ['IP', '<span class="mono">'+esc(l.ip||'-')+'</span>'],
    ['HWID', '<span class="mono">'+esc(l.hwid||'-')+'</span>'],
    ['ผู้เล่น Roblox', l.rbx_id ? rbxLabel({ rbx_id: l.rbx_id, rbx_name: l.rbx_name }) + ' <span class="muted mono">'+esc(l.rbx_id)+'</span>' : '-'],
  ], '');
}
function tapMode(table){ return table.classList.contains('tapped'); }
/* ตารางกว้างกว่ากล่อง (ต้องเลื่อนซ้าย-ขวา / ข้อความโดนตัด) -> สลับเป็นกล่องแตะอัตโนมัติ */
function fitTables(){
  for (const t of document.querySelectorAll('table.tap')){
    const w = t.closest('.tw'); if (!w || !w.offsetParent) continue;
    t.classList.remove('tapped');
    if (t.scrollWidth > w.clientWidth + 1) t.classList.add('tapped');
  }
}
var FIT = 0;
function fitSoon(){ cancelAnimationFrame(FIT); FIT = requestAnimationFrame(fitTables); }
new MutationObserver(fitSoon).observe(document.body, { childList: true, subtree: true });
window.addEventListener('resize', fitSoon);
if (window.ResizeObserver) new ResizeObserver(fitSoon).observe(document.body);
document.addEventListener('click', e => {
  if (e.target.closest('#sheet')) return;
  const lg = e.target.closest('.log div[data-i]');
  if (lg){ const l = (lg.dataset.src === 'm' ? MINI : LOGS.rows)[+lg.dataset.i]; if (l) openLogSheet(l); return; }
  if (e.target.closest('button,a,.chip,input,select,label')) return;
  const tr = e.target.closest('table.tap tbody tr');
  if (tr && !tr.querySelector('td.empty') && tapMode(tr.closest('table'))) openRowSheet(tr);
});
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeSheet(); });
window.addEventListener('resize', () => {
  fitTables(); if (![...document.querySelectorAll('table.tap')].some(t => t.offsetParent && tapMode(t))) closeSheet();
});

/* ================= dropdown ของเราเอง (แทน <select> ของเบราว์เซอร์) =================
   <select> เดิมยังอยู่ (เก็บค่า/ยิง change/onchange เหมือนเดิม) เราแค่ดักการเปิดแล้ววาดรายการเอง */
let DD = null;
function closeDD(){
  if (!DD) return;
  DD.el.remove(); if (DD.bg) DD.bg.remove(); DD.sel.classList.remove('dd-open'); DD = null;
}
function openDD(sel){
  if (DD && DD.sel === sel) return closeDD();
  closeDD();
  const el = document.createElement('div'); el.className = 'dd'; el.setAttribute('role', 'listbox');
  [...sel.options].forEach((o, i) => {
    const b = document.createElement('button'); b.type = 'button'; b.setAttribute('role', 'option');
    b.textContent = o.text; b.disabled = o.disabled; if (o.selected) b.className = 'on';
    b.onclick = () => {
      closeDD();
      if (sel.selectedIndex !== i){ sel.selectedIndex = i; sel.dispatchEvent(new Event('change', { bubbles: true })); }
      sel.focus({ preventScroll: true });
    };
    el.appendChild(b);
  });
  const mob = innerWidth <= 800;
  let bg = null;
  if (mob){ el.classList.add('m'); bg = document.createElement('div'); bg.className = 'dd-bg'; document.body.appendChild(bg); }
  document.body.appendChild(el); sel.classList.add('dd-open'); DD = { sel, el, bg };
  if (!mob){
    const r = sel.getBoundingClientRect();
    el.style.minWidth = r.width + 'px';
    const w = el.offsetWidth, h = el.offsetHeight;
    el.style.left = Math.max(8, Math.min(r.left, innerWidth - w - 8)) + 'px';
    el.style.top = (r.bottom + 4 + h > innerHeight ? Math.max(8, r.top - h - 4) : r.bottom + 4) + 'px';
  }
  (el.querySelector('.on') || el.querySelector('button'))?.focus({ preventScroll: true });
  el.querySelector('.on')?.scrollIntoView({ block: 'nearest' });
}
document.addEventListener('mousedown', e => {
  const sel = e.target.closest('select');
  if (sel && !sel.disabled){ e.preventDefault(); openDD(sel); return; }
  if (DD && !e.target.closest('.dd')) closeDD();
});
document.addEventListener('click', e => { const sel = e.target.closest('select'); if (sel) e.preventDefault(); });   // กัน picker ของมือถือ
document.addEventListener('keydown', e => {
  if (DD){
    const bs = [...DD.el.querySelectorAll('button:not(:disabled)')], i = bs.indexOf(document.activeElement);
    if (e.key === 'Escape'){ const s = DD.sel; closeDD(); s.focus(); e.stopPropagation(); }
    else if (e.key === 'ArrowDown'){ e.preventDefault(); bs[Math.min(bs.length - 1, i + 1)]?.focus(); }
    else if (e.key === 'ArrowUp'){ e.preventDefault(); bs[Math.max(0, i - 1)]?.focus(); }
    else if (e.key === 'Tab') closeDD();
    return;
  }
  if (e.target.matches && e.target.matches('select') && [' ', 'Enter', 'ArrowDown', 'ArrowUp'].includes(e.key)){ e.preventDefault(); openDD(e.target); }
}, true);
window.addEventListener('scroll', e => { if (DD && !DD.el.contains(e.target)) closeDD(); }, true);
window.addEventListener('resize', closeDD);

/* ================= การกระทำกับ key ================= */
async function createKeys(){
  const r = await api('/api/admin/keys/create', {
    count: +$('cCount').value, days: +$('cDays').value, max_hwid: +$('cHwid').value,
    scope: currentScope(), note: $('cNote').value, prefix: $('cPrefix').value,
  });
  if (!r.ok) return toast(r.error || 'สร้างไม่สำเร็จ');
  $('newKeys').classList.remove('hide');
  $('newKeysBox').value = r.keys.join('\n');
  toast('สร้าง ' + r.keys.length + ' key แล้ว');
  KEYS.page = 1; refresh(true);
}
async function delKey(v){ if(!confirm('ลบ key '+v+' ?')) return;
  let r = await api('/api/admin/keys/delete', { values:[v] });
  if (!r.ok && r.error === 'shop_stock') {
    if (!confirm(r.message + '\n\nยังจะลบจริงไหม?')) return;
    r = await api('/api/admin/keys/delete', { values:[v], force:true });
  }
  if (!r.ok) return toast(r.message || r.error || 'ลบไม่สำเร็จ');
  toast('ลบแล้ว'); refresh(true); }
async function toggleKey(id, enabled){ await api('/api/admin/keys/update', { id, patch:{ enabled } }); refresh(true); }
async function resetKey(id){ await api('/api/admin/keys/reset', { id }); toast('ล้าง HWID แล้ว'); refresh(true); }
/* ----- เลือกหลายใบ (checkbox) -----
   ไม่มีปุ่ม "ทำทั้งหมวด" อีกแล้ว: ต้องติ๊กเลือกเอง (หรือกด "เลือกทั้งหมดที่ตรงตัวกรอง") แล้วยืนยันในหน้าต่างเตือน */
function selToggle(cb){
  const v = cb.dataset.v;
  if (cb.checked) SELECTED.add(v); else SELECTED.delete(v);
  const tr = cb.closest('tr'); if (tr) tr.classList.toggle('sel', cb.checked);
  renderSelBar();
}
function selPage(on){
  for (const k of KEYS.rows){ if (on) SELECTED.add(k.key_value); else SELECTED.delete(k.key_value); }
  renderKeys();
}
function selClear(){ SELECTED.clear(); renderKeys(); }
async function selMatching(forceStatus){
  const f = readFilter();
  const qs = new URLSearchParams({ q: f.q, scope: f.scope,
    status: forceStatus || (f.status === 'expiring' ? '' : f.status), expiring: !forceStatus && f.status === 'expiring' ? '1' : '' });
  const r = await api('/api/admin/keys/values?' + qs);
  if (!r.ok) return toast(r.error || 'ดึงรายการไม่สำเร็จ');
  for (const v of r.values) SELECTED.add(v);
  renderKeys();
  toast('เลือก ' + num(r.values.length) + ' ใบ' + (r.capped ? ' (เพดาน 1,000 ใบต่อครั้ง)' : ''));
}
function renderSelBar(){
  const bar = $('selBar'), n = SELECTED.size;
  const all = $('selAll');
  if (all){
    const onPage = KEYS.rows.filter(k => SELECTED.has(k.key_value)).length;
    all.checked = KEYS.rows.length > 0 && onPage === KEYS.rows.length;
    all.indeterminate = onPage > 0 && onPage < KEYS.rows.length;
  }
  if (!bar) return;
  if (!n){ bar.classList.add('hide'); bar.innerHTML = ''; return; }
  bar.classList.remove('hide');
  bar.innerHTML = 'เลือกแล้ว <b>' + num(n) + '</b> ใบ<span class="grow"></span>'
    + '<button class="ghost sm" onclick="bulkSelected(\'disable\')">ระงับ</button>'
    + '<button class="ghost sm" onclick="bulkSelected(\'enable\')">เปิดใช้</button>'
    + '<button class="sm danger" onclick="bulkSelected(\'delete\')">ลบ</button>'
    + '<button class="ghost sm" onclick="selClear()">ยกเลิก</button>';
}
function closeSelModal(){ const m = $('selModal'); if (m) m.remove(); }
function bulkSelected(action){
  const values = [...SELECTED], n = values.length;
  if (!n) return;
  const isDel = action === 'delete';
  const word = isDel ? 'ลบ' : action === 'enable' ? 'เปิดใช้' : 'ระงับ';
  const eg = values.slice(0, 5).map(v => '<li>'+esc(v)+'</li>').join('') + (n > 5 ? '<li>… และอีก '+num(n - 5)+' ใบ</li>' : '');
  const consequence = isDel ? 'ลบถาวร ย้อนกลับไม่ได้ ลูกค้าที่ถือ key เหล่านี้จะใช้งานไม่ได้ทันที'
    : action === 'disable' ? 'ลูกค้าที่ถือ key เหล่านี้จะใช้งานไม่ได้จนกว่าจะเปิดใช้ใหม่' : 'key เหล่านี้จะกลับมาใช้งานได้ (ถ้ายังไม่หมดอายุ)';
  closeSelModal();
  const m = document.createElement('div'); m.id = 'selModal';
  m.innerHTML = '<div class="box'+(isDel?' danger':'')+'"><h3>'+word+' key '+num(n)+' ใบ?</h3>'
    + '<div class="warnline">'+esc(consequence)+'</div><div class="muted sm">ตัวอย่างที่เลือก</div><ul>'+eg+'</ul>'
    + (isDel ? '<div class="fld"><label for="selConfirm">พิมพ์ <b>ลบ '+num(n)+'</b> เพื่อยืนยัน</label><input id="selConfirm" autocomplete="off" oninput="selConfirmCheck('+n+')"></div>' : '')
    + '<div class="bar end"><button class="ghost" onclick="closeSelModal()">ยกเลิก</button>'
    + '<button id="selGo" class="'+(isDel?'danger':'')+'"'+(isDel?' disabled':'')+' onclick="doBulkSelected(\''+action+'\')">'+word+' '+num(n)+' ใบ</button></div></div>';
  m.addEventListener('mousedown', e => { if (e.target === m) closeSelModal(); });
  document.body.appendChild(m);
  const c = $('selConfirm'); if (c) c.focus();
}
function selConfirmCheck(n){ $('selGo').disabled = $('selConfirm').value.trim() !== 'ลบ ' + n; }
async function doBulkSelected(action){
  const values = [...SELECTED];
  closeSelModal();
  let r = await api('/api/admin/keys/bulk', { action, values });
  if (!r.ok && r.error === 'shop_stock') {
    if (!confirm(r.message + '\nตัวอย่าง: ' + (r.sample || []).join(', ') + '\n\nยังจะลบทั้ง ' + values.length + ' ใบจริงไหม?')) return;
    r = await api('/api/admin/keys/bulk', { action, values, force:true });
  }
  if (!r.ok) return toast(r.message || r.error || 'ทำไม่สำเร็จ');
  toast((action === 'delete' ? 'ลบ' : action === 'enable' ? 'เปิดใช้' : 'ระงับ') + ' ' + num(r.affected || 0) + ' key แล้ว');
  SELECTED.clear(); refresh(true);
}
async function extendBy(id, days){
  const r = await api('/api/admin/keys/extend', { id, days });
  if (!r.ok) return toast(r.error || 'ต่ออายุไม่สำเร็จ');
  toast('ต่ออายุ +' + days + ' วันแล้ว'); refresh(true);
}
async function unblockOne(id){
  await api('/api/admin/blocks/unblock', { id }); toast('ปลดบล็อกแล้ว'); refresh(true);
}
async function addBlock(){
  const value = $('bValue').value.trim();
  if (!value) return toast('ยังไม่ได้ใส่ค่า');
  const r = await api('/api/admin/blocks/add', { kind: $('bKind').value, value, reason: $('bReason').value });
  if (!r.ok) return toast(r.error);
  $('bValue').value=''; $('bReason').value='';
  toast('แบนถาวรแล้ว'); refresh(true);
}
async function decodeWm(){
  const text = $('wmText').value.trim();
  if (!text) return toast('ยังไม่ได้วางโค้ด');
  $('wmMsg').textContent = 'กำลังตรวจ...';
  const r = await api('/api/admin/watermark/decode', { text });
  $('wmMsg').textContent = '';
  if (!r.ok) return toast(r.error || 'ตรวจไม่สำเร็จ');
  if (!r.found.length){
    $('wmResult').innerHTML = '<div class="muted" style="margin-top:12px">ไม่พบลายน้ำ — อาจถูกลบออก หรือไฟล์นี้ไม่ได้มาจากระบบของคุณ</div>';
    return;
  }
  $('wmResult').innerHTML = '<div class="tw" style="margin-top:12px"><table class="tap"><thead><tr><th>KEY</th><th>HWID</th>'
    + '<th>โหลดเมื่อ</th><th>หมายเหตุ</th><th></th></tr></thead><tbody>'
    + r.found.map(f =>
        '<tr><td class="mono">'+esc(f.key_value)+(f.exists?'':' <span class="pill warn">ถูกลบไปแล้ว</span>')+'</td>'
        + '<td class="mono">'+esc(f.hwid)+'</td>'
        + '<td>'+fmt(f.at)+'</td>'
        + '<td class="muted">'+esc(f.note||'')+(f.discord?' · Discord '+esc(f.discord):'')+'</td>'
        + '<td class="nw">'
        + (f.exists?'<button class="danger sm" onclick="delKey(\''+esc(f.key_value)+'\')">ลบ key</button> ':'')
        + '<button class="danger sm" onclick="banHwid(\''+esc(f.hwid)+'\')">แบน HWID</button></td></tr>'
      ).join('') + '</tbody></table></div>';
}
async function banHwid(hwid){
  if (!confirm('แบน HWID นี้ถาวร?')) return;
  await api('/api/admin/blocks/add', { kind:'hwid', value: hwid, reason:'ปล่อยสคริปต์หลุด (จากลายน้ำ)' });
  toast('แบนแล้ว'); refresh(true);
}
async function doExport(){
  const res = await fetch('/api/admin/export', { headers: { authorization: 'Bearer ' + TOKEN } });
  if (!res.ok) return toast('ดาวน์โหลดไม่สำเร็จ');
  const blob = await res.blob();
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = 'keysystem-backup-' + new Date().toISOString().slice(0,10) + '.json';
  a.click(); URL.revokeObjectURL(a.href);
  toast('ดาวน์โหลดไฟล์สำรองแล้ว');
}
function doImport(e){
  const f = e.target.files[0]; if(!f) return;
  const rd = new FileReader();
  rd.onload = async () => {
    let data; try { data = JSON.parse(rd.result); } catch { return toast('ไฟล์ไม่ถูกต้อง'); }
    if (!confirm('กู้คืนข้อมูลจากไฟล์นี้? (เพิ่มเฉพาะที่ยังไม่มี ไม่ทับของเดิม)')) return;
    const r = await api('/api/admin/import', { data });
    if (!r.ok) return toast(r.error || 'กู้คืนไม่สำเร็จ');
    toast('กู้คืนแล้ว: key ' + r.keys + ' · สคริปต์ ' + r.scripts);
    refresh(true);
  };
  rd.readAsText(f);
  e.target.value = '';
}


// ประวัติบัญชี Roblox ที่เคยใช้ key (อยู่ต่อแม้ล้าง HWID) — หลายบัญชี = อาจแชร์ key
async function showPlayers(value){
  const r = await api('/api/admin/keys/info', { id: value });
  if (!r.ok) return toast(r.error || 'โหลดไม่สำเร็จ', 'bad');
  const ps = r.key.players || [];
  const bound = (r.key.devices || []).map(d => d.rbx_id).filter(Boolean);
  buildSheet(value, ps.length ? ps.map(p => [
    (bound.includes(p.rbx_id) ? '● ล่าสุด' : 'เคยใช้'),
    rbxLabel(p) + '<div class="muted sm">UserId '+esc(p.rbx_id)+' · ใช้ '+num(p.uses)+' ครั้ง · แรก '+fmt(p.first_seen)+' · ล่าสุด '+fmt(p.last_seen)+'</div>'
      + '<div class="mono muted sm">HWID '+esc(String(p.hwid||'-').slice(0,24))+'</div>',
  ]) : [['ผู้เล่น', '<span class="muted">ยังไม่มีข้อมูล (loader ส่งชื่อมาตั้งแต่อัปเดตนี้)</span>']], '');
}
/* ตัวแก้ซอร์ส Lua: CodeMirror 5 (วาดเฉพาะบรรทัดที่เห็น ไหวกับโค้ดหลายหมื่นบรรทัด) โหลดจาก cdnjs ตอนเปิดตัวแก้ไขครั้งแรก
   โหลดไม่ได้ = ใช้ <textarea id="edSource"> เดิมต่อ (edGet/edSet ครอบทั้งสองแบบไว้ที่เดียว) */
const CM_BASE = 'https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/';
let CM = null, CM_LOADING = null;
function cmLoadScript(src){
  return new Promise((ok, no) => { const s = document.createElement('script'); s.src = src; s.onload = ok; s.onerror = () => no(new Error('โหลด ' + src + ' ไม่ได้')); document.head.appendChild(s); });
}
function cmLoadCss(href){
  const l = document.createElement('link'); l.rel = 'stylesheet'; l.href = href; document.head.appendChild(l);
}
function edGet(){ return CM ? CM.getValue() : $('edSource').value; }
function edSet(v){
  v = String(v || '');
  if (CM) { CM.setValue(v); CM.clearHistory(); CM.scrollTo(0, 0); }   // clearHistory = undo ไม่ย้อนไปสคริปต์ก่อนหน้า
  else $('edSource').value = v;
}
async function ensureCodeEditor(){
  if (CM || CM_LOADING === false) return;
  if (!CM_LOADING) CM_LOADING = (async () => {
    try {
      cmLoadCss(CM_BASE + 'codemirror.min.css'); cmLoadCss(CM_BASE + 'theme/material-darker.min.css');
      await cmLoadScript(CM_BASE + 'codemirror.min.js');
      await cmLoadScript(CM_BASE + 'mode/lua/lua.min.js');
      const ta = $('edSource'), host = document.createElement('div');
      host.id = 'edCode'; ta.parentNode.insertBefore(host, ta);
      const cm = window.CodeMirror(host, {
        value: ta.value, mode: 'lua', theme: 'material-darker', lineNumbers: true, indentUnit: 4, tabSize: 4,
        indentWithTabs: true, lineWrapping: false, viewportMargin: 20, inputStyle: 'contenteditable',
      });
      cm.on('change', (_i, ch) => { if (ch.origin !== 'setValue') markDirty(); });
      ta.classList.add('hide');
      CM = cm;
      cm.refresh();
    } catch (e) {
      window.__edErr = String((e && e.message) || e);
      console.warn('CodeMirror โหลดไม่ได้ ใช้ช่องข้อความธรรมดาแทน', e);
      CM_LOADING = false;
    }
  })();
  await CM_LOADING;
}
/* ================= สคริปต์ ================= */
let EDIT_ID = null, DIRTY = false, EDITING = false;
let ED_ORIG = '', ED_CUR = '', VER_SUGGESTED = false; // ซอร์สตอนเปิด / เวอร์ชันที่ใช้อยู่ / เติมเลขแนะนำแล้วหรือยัง
function nextPatch(v){ const m = /^(\d+)\.(\d+)\.(\d+)$/.exec(v||''); return m ? m[1]+'.'+m[2]+'.'+(Number(m[3])+1) : '1.0.0'; }
function setVerBox(cur, isNew){
  ED_CUR = cur || ''; VER_SUGGESTED = false;
  $('edVersion').value = isNew ? '1.0.0' : ''; $('edNote').value = '';
  $('edVerCur').textContent = cur ? '(ใช้งานอยู่ v'+cur+')' : '';
  $('edHistBtn').classList.toggle('hide', !!isNew);
}
// ติดตามว่าแก้แล้วยังไม่บันทึก: ไม่ดึง/ทับ/ปิดเองจนกว่าผู้ใช้จะยืนยัน
function setDirty(v){
  DIRTY = v;
  $('edDirty').classList.toggle('hide', !v);
}
function markDirty(){
  if (!DIRTY) setDirty(true);
  if (!VER_SUGGESTED && EDIT_ID && !$('edVersion').value && edGet() !== ED_ORIG){
    VER_SUGGESTED = true; $('edVersion').value = nextPatch(ED_CUR);
  }
}
function confirmDiscard(){
  return !DIRTY || confirm('มีการแก้ที่ยังไม่ได้บันทึก — ทิ้งการแก้ไขนี้?');
}
function closeEditor(){
  if (!confirmDiscard()) return;
  setDirty(false); EDITING = false; EDIT_ID = null;
  $('editor').classList.add('hide');
}
async function editScript(id){
  ensureCodeEditor(); // เริ่มโหลดเงียบๆ ไม่รอ (โหลดเสร็จจะสลับมาใช้เอง)
  if (EDITING && EDIT_ID === id && id) { $('editor').scrollIntoView({ behavior:'smooth', block:'start' }); return; } // เปิดอยู่แล้ว ไม่โหลดทับ
  if (!confirmDiscard()) return;
  $('editor').classList.remove('hide');
  $('editor').scrollIntoView({ behavior:'smooth', block:'start' });
  $('edMsg').textContent = '';
  if (!id){
    EDIT_ID = null; EDITING = true;
    $('edTitle').textContent='เพิ่มสคริปต์ใหม่'; $('edName').value=''; $('edSlug').value='';
    edSet(''); ED_ORIG = ''; setVerBox('', true); $('edEnabled').value='1'; setDirty(false); return;
  }
  $('edMsg').textContent = 'กำลังโหลดซอร์ส...';
  const r = await api('/api/admin/scripts/get', { id });
  if (!r.ok) { $('edMsg').textContent = ''; return toast(r.error); }
  EDIT_ID = id; EDITING = true;
  $('edTitle').textContent = 'แก้ไข: ' + r.script.name;
  $('edName').value = r.script.name; $('edSlug').value = r.script.slug;
  edSet(r.script.source); ED_ORIG = r.script.source; setVerBox(r.script.version_label, false);
  $('edEnabled').value = String(r.script.enabled);
  $('edMsg').textContent = ''; setDirty(false);
}
let SAVING = false;
async function saveScript(){
  if (SAVING) return;
  const source = edGet();
  const isNew = !EDIT_ID, changed = isNew || source !== ED_ORIG;
  const version = $('edVersion').value.trim();
  if (changed){
    if (!/^\d{1,4}\.\d{1,4}\.\d{1,4}$/.test(version)){ $('edVersion').focus(); return toast('ใส่เลขเวอร์ชันเป็น x.x.x เช่น 1.2.0'); }
    if (!isNew && !confirm('เผยแพร่ v'+version+' ?\n\nลูกค้าทุกคนจะได้โค้ดเวอร์ชันนี้ทันที (ย้อนกลับได้จากปุ่ม “ประวัติเวอร์ชัน”)')) return;
  }
  SAVING = true; $('edMsg').textContent = 'กำลังบันทึก...';
  try {
    const r = await api('/api/admin/scripts/save', {
      id: EDIT_ID, name: $('edName').value, slug: $('edSlug').value || $('edName').value,
      source, enabled: $('edEnabled').value === '1',
      ...(changed ? { version, note: $('edNote').value.trim() } : {}),
    });
    if (!r.ok) { $('edMsg').textContent = ''; return toast(r.error || 'บันทึกไม่สำเร็จ (ยังไม่ได้บันทึก)'); }
    EDIT_ID = r.script.id; setDirty(false); ED_ORIG = source;
    setVerBox(r.script.version_label, false);
    $('edMsg').textContent = (r.script.versioned ? 'เผยแพร่ v'+r.script.version_label+' แล้ว ' : 'บันทึกแล้ว ') + new Date().toLocaleTimeString('th-TH');
    toast(r.script.versioned ? 'เผยแพร่ v'+r.script.version_label+' แล้ว' : 'บันทึกสคริปต์แล้ว'); refresh(true);
    if (!$('history').classList.contains('hide')) openHistory(EDIT_ID);
  } finally { SAVING = false; }
}
async function delScript(id){ if(!confirm('ลบสคริปต์นี้? (key ในหมวดนี้จะไม่ถูกลบ)')) return;
  await api('/api/admin/scripts/delete', { id }); toast('ลบแล้ว'); refresh(true); }
function loadFile(e){
  const f = e.target.files[0]; if(!f) return;
  const rd = new FileReader();
  rd.onload = () => { edSet(rd.result); markDirty();
    if (!$('edName').value) $('edName').value = f.name.replace(/\.lua$/,''); };
  rd.readAsText(f);
}


// ---------- ประวัติเวอร์ชัน / rollback ----------
let HIST_ID = null;
function closeHistory(){ HIST_ID = null; $('history').classList.add('hide'); }
async function openHistory(id){
  if (!id) return;
  const r = await api('/api/admin/scripts/versions', { id });
  if (!r.ok) return toast(r.error || 'โหลดประวัติไม่ได้');
  HIST_ID = id;
  $('history').classList.remove('hide');
  $('hiTitle').textContent = 'ประวัติเวอร์ชัน: ' + r.script.name;
  $('hiKeep').textContent = 'เก็บล่าสุด ' + r.keep + ' เวอร์ชัน';
  $('hiCodeBox').classList.add('hide');
  $('hiRows').innerHTML = r.versions.map(v =>
    '<tr><td class="nw"><b>v'+esc(v.label)+'</b> '+(v.live?'<span class="pill ok">ใช้งานอยู่</span>':'')+'</td>'
    + '<td class="muted nw">'+fmtDate(v.created_at)+' '+new Date(v.created_at*1000).toLocaleTimeString('th-TH',{hour:'2-digit',minute:'2-digit'})+'</td>'
    + '<td>'+esc(v.note||'')+'</td>'
    + '<td class="muted nw">'+((v.size||0)/1024).toFixed(1)+' KB</td>'
    + '<td class="nw"><button class="ghost sm" onclick="viewVersion(\''+esc(v.id)+'\',\''+esc(v.label)+'\')">ดูโค้ด</button> '
    + (v.live ? '' : '<button class="sm" onclick="useVersion(\''+esc(id)+'\',\''+esc(v.id)+'\',\''+esc(v.label)+'\')">ใช้เวอร์ชันนี้</button>')
    + '</td></tr>').join('') || emptyRow(5, 'ยังไม่มีประวัติ', 'จะเริ่มเก็บเมื่อเผยแพร่เวอร์ชันถัดไป');
  $('history').scrollIntoView({ behavior:'smooth', block:'start' });
}
async function viewVersion(vid, label){
  const r = await api('/api/admin/scripts/version/get', { id: vid });
  if (!r.ok) return toast(r.error || 'โหลดโค้ดไม่ได้');
  $('hiCodeTitle').textContent = 'โค้ด v' + label;
  $('hiCode').textContent = r.version.source;
  $('hiCodeBox').classList.remove('hide');
}
async function useVersion(id, vid, label){
  if (DIRTY && EDIT_ID === id && !confirm('ตัวแก้ไขมีการแก้ที่ยังไม่ได้บันทึก การเปลี่ยนเวอร์ชันจะทับที่เปิดอยู่ ทำต่อ?')) return;
  if (!confirm('ใช้ v'+label+' เป็นเวอร์ชันที่ลูกค้าทุกคนได้รับ?\n\nมีผลทันที (ภายใน ~30 วินาที) กับทุกคนที่โหลดสคริปต์ — ไม่ลบเวอร์ชันอื่น')) return;
  const r = await api('/api/admin/scripts/rollback', { id, version_id: vid });
  if (!r.ok) return toast(r.error || 'เปลี่ยนเวอร์ชันไม่สำเร็จ');
  toast('ตอนนี้ใช้ v' + r.to + ' แล้ว');
  if (EDITING && EDIT_ID === id){ setDirty(false); EDITING = false; $('editor').classList.add('hide'); }
  refresh(true); openHistory(id);
}

window.addEventListener('beforeunload', e => { if (DIRTY) { e.preventDefault(); e.returnValue = ''; } });
document.addEventListener('keydown', e => {
  if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 's' && EDITING && !$('editor').classList.contains('hide')) { e.preventDefault(); saveScript(); }
});
/* ================= ตั้งค่า (มาจาก meta ไม่ต้องเรียก API แยก) ================= */
function fillSettings(){
  const st = STATE.settings || {};
  if (!Object.keys(st).length) return;
  for (const k of SET_KEYS){
    const el = $('s_' + k);
    if (el) el.value = st[k] ?? '';
  }
  $('s_newpw').value = '';
  $('pwState').textContent = STATE.custom_password
    ? 'ตอนนี้ใช้รหัสที่ตั้งจากหน้านี้'
    : 'ตอนนี้ใช้รหัสจาก ADMIN_PASSWORD';
  $('s_newpw2').value = '';
  $('pw2State').textContent = STATE.second_password
    ? 'มีรหัสที่ 2 ใช้งานอยู่ (ใส่ใหม่เพื่อเปลี่ยน) · log ล็อกอินจะระบุว่าเข้าด้วยรหัสที่ 2'
    : 'ยังไม่มีรหัสที่ 2 (ใส่เพื่อเพิ่ม ใช้ควบคู่กับรหัสหลัก)';
  $('pw2Del').hidden = !STATE.second_password;
  $('cDays').value = st.default_days;
  $('cHwid').value = st.default_max_hwid;
  $('cPrefix').value = st.default_prefix;
  $('setMsg').textContent = '';
}
function loadSettings(){ fillSettings(); }
async function removePw2(){
  if (!confirm('ลบรหัสผ่านที่ 2? คนที่ใช้รหัสนี้จะเข้าไม่ได้ทันที')) return;
  const r = await api('/api/admin/settings/password2-reset', {});
  if (!r.ok) return toast(r.error || 'ลบไม่สำเร็จ');
  toast('ลบรหัสที่ 2 แล้ว');
  await refresh(true); fillSettings();
}
async function saveSettings(){
  const patch = {};
  for (const k of SET_KEYS){ const el = $('s_'+k); if (el) patch[k] = el.value; }
  const r = await api('/api/admin/settings/save', { settings: patch });
  if (!r.ok) return toast(r.error || 'บันทึกไม่สำเร็จ');
  const pw = $('s_newpw').value.trim();
  if (pw){
    const p = await api('/api/admin/settings/password', { password: pw });
    if (!p.ok){ toast(p.error || 'เปลี่ยนรหัสไม่สำเร็จ'); return; }
    $('s_newpw').value = '';
    toast('บันทึกแล้ว + เปลี่ยนรหัสผ่านแล้ว');
  } else {
    toast('บันทึกการตั้งค่าแล้ว');
  }
  const pw2 = $('s_newpw2').value.trim();
  if (pw2){
    const p2 = await api('/api/admin/settings/password2', { password: pw2 });
    if (!p2.ok){ toast(p2.error || 'ตั้งรหัสที่ 2 ไม่สำเร็จ'); return; }
    $('s_newpw2').value = '';
    toast('ตั้งรหัสผ่านที่ 2 แล้ว');
  }
  await refresh(true); fillSettings();
  $('setMsg').textContent = 'บันทึกล่าสุด ' + new Date().toLocaleTimeString('th-TH');
}

$('pw').addEventListener('keydown', e => { if (e.key === 'Enter') doLogin(); });

function toggleRail(){
  if (window.innerWidth <= 800) {
    toggleMobNav();
    return;
  }
  const on = $('app').classList.toggle('rail');
  LS.set('ks_rail', on ? '1' : '0');
}
function toggleMobNav(){
  const open = document.body.classList.toggle('mob-open');
  const b = $('mobBackdrop');
  if (b) b.classList.toggle('hide', !open);
}
function closeMobNav(){
  document.body.classList.remove('mob-open');
  const b = $('mobBackdrop');
  if (b) b.classList.add('hide');
}
window.closeMobNav = closeMobNav;
window.toggleMobNav = toggleMobNav;
if (window.innerWidth > 800 && LS.get('ks_rail', '0') === '1') $('app').classList.add('rail');
function dismissTip(id){ LS.set('ks_tip_' + id, '1'); const t = $('tip-' + id); if (t) t.classList.add('gone'); }
for (const t of document.querySelectorAll('.tip')) if (LS.get('ks_tip_' + t.id.slice(4), '0') === '1') t.classList.add('gone');
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeMobNav(); });

if (TOKEN) start();
</script>
</body>
</html>
