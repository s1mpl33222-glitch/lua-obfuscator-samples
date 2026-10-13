<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vault — Roomcord</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{
  --bg:#000;--surface:#000;
  --border:#b0b0b0;--border-hi:#b0b0b0;
  --ink:#b0b0b0;--ink-2:#b0b0b0;--ink-3:#b0b0b0;
  --r:6px;
  --sans:'Outfit',sans-serif;--mono:'JetBrains Mono',monospace;
}
[data-theme="light"]{
  --bg:#fff;--surface:#fff;
  --border:#111;--border-hi:#111;
  --ink:#111;--ink-2:#111;--ink-3:#111;
}
[data-theme="light"] textarea,
[data-theme="light"] input,
[data-theme="light"] .drop,
[data-theme="light"] .result,
[data-theme="light"] .result-chips,
[data-theme="light"] .tab,
[data-theme="light"] .tab.active,
[data-theme="light"] nav,
[data-theme="light"] body{background:#fff!important;color:#111!important;}
[data-theme="light"] textarea::placeholder,
[data-theme="light"] input::placeholder{color:#111!important;}
html{font-size:14px;-webkit-font-smoothing:antialiased}
body{background:var(--bg);color:var(--ink-2);font-family:var(--mono);min-height:100vh;transition:background 200ms,color 200ms}

/* NAV */
nav{
  position:fixed;top:0;left:0;right:0;z-index:100;
  height:52px;background:var(--bg);border-bottom:1px solid var(--border);
  display:flex;align-items:center;padding:0 20px;gap:0;
}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none}
.nav-logo{height:20px;width:auto;border-radius:4px}
.nav-name{font-family:var(--sans);font-size:15px;font-weight:800;color:var(--ink);letter-spacing:-.3px}
.nav-links{display:flex;margin-left:auto;gap:0}
.nav-link{
  font-family:var(--mono);font-size:11.5px;font-weight:500;
  color:var(--ink-2);text-decoration:none;
  padding:6px 12px;border:1px solid transparent;border-radius:var(--r);
  transition:color 120ms,border-color 120ms;
}
.nav-link:hover{color:var(--ink);border-color:var(--border)}
.nav-link.active{color:var(--ink);font-weight:700}
.theme-btn{
  margin-left:8px;width:32px;height:32px;border:1px solid var(--border);
  border-radius:var(--r);background:transparent;color:var(--ink-2);
  cursor:pointer;display:flex;align-items:center;justify-content:center;
  transition:color 120ms,border-color 120ms;
}
.theme-btn:hover{color:var(--ink);border-color:var(--border-hi)}

/* LAYOUT */
main{max-width:520px;margin:0 auto;padding:80px 20px 60px}

/* HERO */
.hero{margin-bottom:48px;padding-bottom:48px;border-bottom:1px solid var(--border)}
.hero-top{display:flex;align-items:center;gap:14px;margin-bottom:16px}
.hero-logo{height:40px;border-radius:8px}
.hero-title{font-family:var(--sans);font-size:32px;font-weight:800;letter-spacing:-.5px;line-height:1.05;color:var(--ink)}
.hero-desc{font-size:12px;color:var(--ink-2);line-height:1.7;max-width:400px}
.hero-desc strong{color:var(--ink);font-weight:500}

/* FORM SECTION */
.form-block{margin-bottom:32px}

/* TABS */
.tabs{display:flex;border:1px solid var(--border);border-radius:var(--r);overflow:hidden;margin-bottom:12px}
.tab{
  flex:1;padding:10px;font-family:var(--mono);font-size:11.5px;font-weight:500;
  cursor:pointer;background:transparent;border:none;color:var(--ink-2);
  border-right:1px solid var(--border);transition:color 120ms,background 120ms;
}
.tab:last-child{border-right:none}
.tab.active{background:var(--bg);color:var(--ink)}
.pane{display:none}.pane.active{display:block}

/* TEXTAREA */
textarea{
  width:100%;height:180px;resize:vertical;
  background:var(--bg);color:var(--ink);
  border:1px solid var(--border);border-radius:var(--r);
  padding:14px;font-family:var(--mono);font-size:12px;line-height:1.7;
  outline:none;transition:border-color 150ms;
}
textarea:focus{border-color:var(--border-hi)}
textarea::placeholder{color:var(--ink-3)}

/* DROP */
.drop{
  width:100%;height:180px;border:1px dashed var(--border);border-radius:var(--r);
  display:flex;flex-direction:column;align-items:center;justify-content:center;
  cursor:pointer;background:var(--bg);transition:border-color 150ms,background 150ms;
  text-align:center;gap:8px;
}
.drop:hover,.drop.drag{border-color:var(--border-hi);background:var(--bg)}
.drop-icon{color:var(--ink-3);transition:color 150ms}
.drop:hover .drop-icon,.drop.drag .drop-icon{color:var(--ink-2)}
.drop-label{font-size:12px;font-weight:500;color:var(--ink-2)}
.drop-sub{font-size:11px;color:var(--ink-3)}
.drop-file{font-size:11px;color:var(--pink);display:none}
#fi{display:none}

/* FIELD */
.field{margin-top:10px}
.field-label{font-size:11px;color:var(--ink-2);margin-bottom:5px;display:block;letter-spacing:.3px}
.input-wrap{position:relative}
.input-wrap input{
  width:100%;padding:10px 40px 10px 12px;
  border:1px solid var(--border);border-radius:var(--r);
  background:var(--bg);color:var(--ink);
  font-family:var(--mono);font-size:12.5px;outline:none;
  transition:border-color 150ms;
}
.input-wrap input:focus{border-color:var(--border-hi)}
.input-wrap input::placeholder{color:var(--ink-3)}
.eye{
  position:absolute;right:10px;top:50%;transform:translateY(-50%);
  background:none;border:none;cursor:pointer;color:var(--ink-3);
  padding:4px;line-height:0;transition:color 120ms;
}
.eye:hover{color:var(--ink-2)}
.eye svg{width:15px;height:15px;stroke:currentColor}

/* ACTIONS */
.actions{display:flex;gap:8px;margin-top:14px;flex-wrap:wrap}
.btn{
  padding:10px 20px;border-radius:var(--r);
  font-family:var(--mono);font-size:12px;font-weight:500;
  cursor:pointer;border:1px solid var(--border);
  background:transparent;color:var(--ink);
  transition:border-color 150ms,color 150ms,background 150ms;
  white-space:nowrap;
}
.btn:hover{border-color:var(--border-hi);color:var(--ink)}
.btn:disabled{opacity:.35;cursor:not-allowed;pointer-events:none}
.btn-pink{
  background:transparent;border-color:var(--border-hi);color:var(--ink);
}
.btn-pink:hover{border-color:var(--border-hi);color:var(--ink)}

/* TURNSTILE */
.ts-wrap{margin-top:12px}

/* RESULT */
.result{
  margin-top:14px;border:1px solid var(--border);border-radius:var(--r);
  overflow:hidden;display:none;
}
.result.show{display:block}
.result-row{padding:12px 14px;border-bottom:1px solid var(--border)}
.result-row:last-child{border-bottom:none}
.result-key{font-size:10px;color:var(--ink-3);margin-bottom:4px;letter-spacing:.5px}
.result-val{font-size:11.5px;color:var(--ink);word-break:break-all;line-height:1.5}
.result-val a{color:var(--ink);text-decoration:underline}
.result-val a:hover{text-decoration:underline}
.result-chips{
  padding:10px 14px;display:flex;gap:6px;flex-wrap:wrap;
  background:var(--bg);border-top:1px solid var(--border);
}
.chip{
  padding:5px 12px;border-radius:20px;font-family:var(--mono);
  font-size:11px;font-weight:500;border:1px solid var(--border);
  background:transparent;color:var(--ink-2);cursor:pointer;
  transition:color 120ms,border-color 120ms;
}
.chip:hover{color:var(--ink);border-color:var(--border-hi)}
.chip.ok{color:var(--ink);border-color:var(--border-hi)}
.chip-del{color:var(--ink-2);border-color:var(--border)}
.chip-del:hover{background:var(--bg);color:var(--ink);border-color:var(--border-hi)}
.result-msg{padding:14px;font-size:12px;color:var(--ink-2)}
.result-msg.err{color:#f87171}
.result-msg.ok{color:var(--ink)}

/* DIVIDER */
.divider{height:1px;background:var(--border);margin:40px 0}

/* DELETE SECTION */
.section-title{font-size:11px;color:var(--ink-3);margin-bottom:12px;letter-spacing:.5px}
.del-grid{display:flex;gap:8px;flex-wrap:wrap}
.del-grid .input-wrap{flex:1;min-width:130px}
.del-feedback{margin-top:8px;font-size:11.5px;font-family:var(--mono)}
.del-feedback.ok{color:var(--ink)}
.del-feedback.err{color:#f87171}

/* FOOTER */
footer{
  margin-top:60px;padding-top:20px;border-top:1px solid var(--border);
  display:flex;align-items:center;justify-content:space-between;
  font-size:11px;color:var(--ink-3);
}
footer a{color:var(--ink-3);text-decoration:none;transition:color 120ms}
footer a:hover{color:#888}
</style>
</head>
<body>

<nav>
  <a class="nav-brand" href="index.html">
    <img src="logo.png" class="nav-logo" alt="">
    <span class="nav-name">Roomcord</span>
  </a>
  <div class="nav-links">
    <a href="index.html" class="nav-link active">vault</a>
    <a href="obfuscator.html" class="nav-link">obfuscator</a>
    <button class="theme-btn" id="themeBtn" onclick="toggleTheme()" title="Toggle theme">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" id="themeIcon"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
    </button>
  </div>
</nav>

<main>
  <div class="hero">
    <div class="hero-top">
      <img src="logo.png" class="hero-logo" alt="Roomcord">
      <h1 class="hero-title">Vault</h1>
    </div>
    <p class="hero-desc">Upload your script and get a secure link. Browsers are blocked — only executors can fetch the raw content. Make sure to upload an obfuscated file to keep your script protected.</p>
  </div>

  <div class="form-block">
    <div class="tabs">
      <button class="tab active" id="tPaste" onclick="switchTab('paste')">paste</button>
      <button class="tab" id="tFile" onclick="switchTab('file')">upload file</button>
    </div>

    <div class="pane active" id="pPaste">
      <textarea id="code" placeholder="-- paste your script here"></textarea>
    </div>
    <div class="pane" id="pFile">
      <div class="drop" id="dz" onclick="document.getElementById('fi').click()">
        <div class="drop-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
        </div>
        <div class="drop-label">drop file or click to browse</div>
        <div class="drop-sub">.lua and .txt accepted</div>
        <div class="drop-file" id="dfn"></div>
      </div>
      <input type="file" id="fi" accept=".lua,.txt">
    </div>

    <div class="field">
      <label class="field-label" for="pk">passkey</label>
      <div class="input-wrap">
        <input type="password" id="pk" placeholder="set a passkey — needed to delete this link">
        <button class="eye" id="eyePk" onclick="toggleEye('pk','eyePk')" title="show/hide">
          <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
        </button>
      </div>
    </div>

    <div class="actions">
      <button class="btn btn-pink" id="saveBtn" onclick="saveScript()">generate link</button>
      <button class="btn" onclick="clearAll()">clear</button>
    </div>

    <!-- Turnstile widget — single embed, used for save & delete -->
    <div class="ts-wrap">
      <div class="cf-turnstile"
           id="tsWidget"
           data-sitekey="0x4AAAAAAFT5myo_ECEStdjN"
           data-theme="auto"
           data-callback="onTsSuccess"
           data-expired-callback="onTsExpire"
           data-error-callback="onTsError">
      </div>
    </div>

    <div class="result" id="result"></div>
  </div>

  <div class="divider"></div>

  <div>
    <div class="section-title">delete a link</div>
    <div class="del-grid">
      <div class="input-wrap">
        <input type="text" id="delId" placeholder="paste link or id">
      </div>
      <div class="input-wrap" style="max-width:160px">
        <input type="password" id="delPk" placeholder="passkey">
        <button class="eye" id="eyeDel" onclick="toggleEye('delPk','eyeDel')" title="show/hide">
          <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
        </button>
      </div>
      <button class="btn" onclick="deleteLink()">delete</button>
    </div>
    <div class="del-feedback" id="delFb"></div>
  </div>

  <footer>
    <span>roomcord vault</span>
    <a href="https://dsc.gg/rcord" target="_blank">discord</a>
  </footer>
</main>

<script>
const EYE_OPEN=`<svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="15" height="15" stroke="currentColor"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>`;
const EYE_CLOSED=`<svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="15" height="15" stroke="currentColor"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>`;
const SUN=`<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>`;
const MOON=`<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>`;

// ── Turnstile state ──────────────────────────────────────────────────────────
let _tsToken = null;

function onTsSuccess(token) { _tsToken = token; }
function onTsExpire()       { _tsToken = null; }
function onTsError()        { _tsToken = null; }

function getTsToken() { return _tsToken; }

function resetTs() {
  _tsToken = null;
  if (window.turnstile) turnstile.reset('#tsWidget');
}

// ── Theme ────────────────────────────────────────────────────────────────────
function toggleTheme(){
  const d=document.documentElement;
  const t=d.getAttribute('data-theme')==='dark'?'light':'dark';
  d.setAttribute('data-theme',t);
  localStorage.setItem('rc-t',t);
  document.getElementById('themeBtn').innerHTML=t==='dark'?SUN:MOON;
}
(function(){
  const t=localStorage.getItem('rc-t')||'dark';
  document.documentElement.setAttribute('data-theme',t);
  document.getElementById('themeBtn').innerHTML=t==='dark'?SUN:MOON;
})();

function toggleEye(iId,bId){
  const i=document.getElementById(iId),b=document.getElementById(bId);
  const h=i.type==='password';i.type=h?'text':'password';
  b.innerHTML=h?EYE_CLOSED:EYE_OPEN;
}

// ── Tabs ─────────────────────────────────────────────────────────────────────
let mode='paste',uf=null;
function switchTab(t){
  mode=t;
  document.getElementById('tPaste').className='tab'+(t==='paste'?' active':'');
  document.getElementById('tFile').className='tab'+(t==='file'?' active':'');
  document.getElementById('pPaste').className='pane'+(t==='paste'?' active':'');
  document.getElementById('pFile').className='pane'+(t==='file'?' active':'');
}

const dz=document.getElementById('dz'),fi=document.getElementById('fi');
fi.addEventListener('change',e=>{if(e.target.files[0])hf(e.target.files[0])});
dz.addEventListener('dragover',e=>{e.preventDefault();dz.classList.add('drag')});
dz.addEventListener('dragleave',()=>dz.classList.remove('drag'));
dz.addEventListener('drop',e=>{e.preventDefault();dz.classList.remove('drag');if(e.dataTransfer.files[0])hf(e.dataTransfer.files[0])});
function hf(f){uf=f;const el=document.getElementById('dfn');el.style.display='block';el.textContent=f.name+' · '+Math.round(f.size/1024)+'kb'}

function esc(s){return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')}

async function copy(btn,text){
  let ok=false;
  if(navigator.clipboard&&window.isSecureContext){try{await navigator.clipboard.writeText(text);ok=true}catch(e){}}
  if(!ok){try{const t=document.createElement('textarea');t.value=text;t.style.cssText='position:fixed;opacity:0';document.body.appendChild(t);t.focus();t.select();ok=document.execCommand('copy');document.body.removeChild(t)}catch(e){}}
  const o=btn.textContent;btn.textContent=ok?'copied':'failed';btn.classList.add('ok');
  setTimeout(()=>{btn.textContent=o;btn.classList.remove('ok')},1500);
}

function setMsg(box,type,msg){
  box.className='result show';
  box.innerHTML=`<div class="result-msg ${type}">${esc(msg)}</div>`;
}

function buildResult(box,rows,chips){
  box.innerHTML='';box.className='result show';
  rows.forEach(({k,html})=>{
    const d=document.createElement('div');d.className='result-row';
    d.innerHTML=`<div class="result-key">${k}</div><div class="result-val">${html}</div>`;
    box.appendChild(d);
  });
  const ra=document.createElement('div');ra.className='result-chips';
  chips.forEach(({label,cls,cb})=>{
    const b=document.createElement('button');b.className='chip'+(cls?' '+cls:'');b.textContent=label;b.onclick=()=>cb(b);ra.appendChild(b);
  });
  box.appendChild(ra);
}

// ── Save ─────────────────────────────────────────────────────────────────────
async function saveScript(){
  const box=document.getElementById('result');
  const pk=document.getElementById('pk').value.trim();
  const token=getTsToken();

  if(!token){setMsg(box,'err','Complete the verification first.');return}

  let code,filename;
  if(mode==='file'){
    if(!uf){setMsg(box,'err','No file selected.');return}
    code=await uf.text();filename=uf.name;
  }else{
    code=document.getElementById('code').value.trim();filename='script.lua';
    if(!code){setMsg(box,'err','Paste a script first.');return}
  }
  if(!pk||pk.length<3){setMsg(box,'err','Passkey must be at least 3 characters.');return}

  document.getElementById('saveBtn').disabled=true;
  setMsg(box,'','generating...');
  try{
    const r=await fetch('/api/save',{
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body:JSON.stringify({code,filename,passkey:pk,turnstileToken:token})
    });
    const d=await r.json();if(!r.ok)throw new Error(d.error||'Failed.');
    const ls=`loadstring(game:HttpGet("${d.url}"))()`;
    buildResult(box,[
      {k:'link',html:`<a href="${d.url}" target="_blank">${d.url}</a>`},
      {k:'loadstring',html:esc(ls)},
    ],[
      {label:'copy link',cb:b=>copy(b,d.url)},
      {label:'copy loadstring',cb:b=>copy(b,ls)},
      {label:'delete',cls:'chip-del',cb:()=>quickDel(d.url,pk,box)},
    ]);
  }catch(e){setMsg(box,'err',e.message);}
  document.getElementById('saveBtn').disabled=false;
  resetTs();
}

// ── Quick delete (from result chip) ─────────────────────────────────────────
async function quickDel(id,pk,box){
  if(!confirm('Delete this link?'))return;
  const token=getTsToken();
  if(!token){alert('Complete the verification first, then click delete again.');return}
  try{
    const r=await fetch('/api/delete',{
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body:JSON.stringify({id,passkey:pk,turnstileToken:token})
    });
    const d=await r.json();if(!r.ok)throw new Error(d.error||'Failed.');
    box.className='result show';box.innerHTML='<div class="result-msg ok">deleted.</div>';
  }catch(e){alert(e.message)}
  resetTs();
}

// ── Delete section ───────────────────────────────────────────────────────────
async function deleteLink(){
  const id=document.getElementById('delId').value.trim();
  const pk=document.getElementById('delPk').value.trim();
  const fb=document.getElementById('delFb');
  const token=getTsToken();

  if(!id){fb.textContent='paste a link or id first.';fb.className='del-feedback err';return}
  if(!pk||pk.length<3){fb.textContent='enter the passkey.';fb.className='del-feedback err';return}
  if(!token){fb.textContent='complete the verification first.';fb.className='del-feedback err';return}

  fb.textContent='deleting...';fb.className='del-feedback';
  try{
    const r=await fetch('/api/delete',{
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body:JSON.stringify({id,passkey:pk,turnstileToken:token})
    });
    const d=await r.json();if(!r.ok)throw new Error(d.error||'Failed.');
    fb.textContent='deleted.';fb.className='del-feedback ok';
    document.getElementById('delId').value='';document.getElementById('delPk').value='';
  }catch(e){fb.textContent=e.message;fb.className='del-feedback err'}
  resetTs();
}

// ── Clear ────────────────────────────────────────────────────────────────────
function clearAll(){
  document.getElementById('code').value='';
  document.getElementById('pk').value='';
  uf=null;document.getElementById('dfn').style.display='none';fi.value='';
  const b=document.getElementById('result');b.className='result';b.innerHTML='';
}
</script>
</body>
</html>
