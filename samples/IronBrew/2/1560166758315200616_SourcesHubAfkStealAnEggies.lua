<!DOCTYPE html>
<html lang="en" dir="ltr" data-theme="dark" data-accent="purple">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex">
<title>Protected by Obscura | Obscura</title>
<link rel="icon" type="image/png" href="/assets/obscura_favicon.png?v=1">
<meta name="google" content="notranslate">

  <meta property="og:type" content="website">
  <meta property="og:site_name" content="Obscura">
  <meta property="og:title" content="Obscura - Luau Obfuscator">
  <meta property="og:description" content="Lock down your Code. Ship with confidence.">
  <meta property="og:url" content="https://obscuravm.com/blocked">
  <meta property="og:image" content="https://obscuravm.com/assets/og.png?v=4">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Obscura - Luau Obfuscator">
  <meta name="twitter:description" content="Lock down your Code. Ship with confidence.">
  <meta name="twitter:image" content="https://obscuravm.com/assets/og.png?v=4">
  <meta name="theme-color" content="#08090a">
  <script src="/js/cookie-consent.js?v=4" defer></script>
<script>(function(){try{
  if(!('scrollRestoration' in history)) return;
  var e=(performance.getEntriesByType&&performance.getEntriesByType('navigation')[0])||null;
  var t=e?e.type:((performance.navigation&&performance.navigation.type===2)?'back_forward':'');
  if(t!=='back_forward') history.scrollRestoration='manual';
}catch(err){}})();</script><script>window.__i18n=[];</script>
<script src="/js/i18n.js?v=9" defer></script>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=block">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap">
<style>@font-face{font-family:'Inter Fallback';src:local('Arial'),local('Helvetica Neue'),local('Helvetica');ascent-override:90.20%;descent-override:22.48%;line-gap-override:0%;size-adjust:107.40%}</style>
<style>
  :root{
    --bg:#000; --sb:#060606; --raise:rgba(255,255,255,.024); --raise-2:rgba(255,255,255,.06);
    --line:rgba(255,255,255,.08); --line-2:rgba(255,255,255,.14);
    --line-soft:rgba(255,255,255,.05); --line-strong:rgba(255,255,255,.16);
    --text:#fafafa; --text-2:#9a9aa2; --text-3:#86868f; --text-4:#74747d;
    --accent:#fafafa; --accent-rgb:255,255,255; --accent-hi:250,250,250; --accent-2:#e5e5e7;
    --panel:#0b0b0b; --panel-2:#111114;
    --cta-bg:#fafafa; --cta-bg-hi:#fff; --cta-fg:#000;
    --sans:'Geist','Inter','Inter Fallback',system-ui,-apple-system,'Segoe UI',sans-serif;
    --mono:'JetBrains Mono',ui-monospace,Menlo,Consolas,monospace;
    --maxw:1160px; --r:12px; --r-pill:100px;
    --ease:cubic-bezier(.22,.61,.36,1); --spring:cubic-bezier(.34,1.4,.5,1); --ease-entrance:cubic-bezier(.3,.15,.3,1); --dur-reveal:.75s;
    --dur-1:.16s; --dur-2:.26s; --dur-3:.4s;
  }
  html[data-theme="light"]{
    --bg:#f6f6f8; --sb:#fff; --raise:rgba(0,0,0,.02); --raise-2:rgba(0,0,0,.045);
    --line:rgba(17,17,20,.1); --line-2:rgba(17,17,20,.18); --line-soft:rgba(17,17,20,.07); --line-strong:rgba(17,17,20,.24);
    --text:#0f0f12; --text-2:#53535d; --text-3:#6b6b75; --text-4:#74747e;
    --accent:#141418; --accent-rgb:20,20,24; --panel:#fff; --panel-2:#f2f2f6;
    --cta-bg:#141418; --cta-bg-hi:#000; --cta-fg:#fff;
  }
  *{box-sizing:border-box;-webkit-tap-highlight-color:transparent}
  html{-webkit-text-size-adjust:100%; scroll-behavior:smooth}
  body{margin:0; background:var(--bg); color:var(--text); font-family:var(--sans); font-size:15px; line-height:1.55; letter-spacing:-.012em; -webkit-font-smoothing:antialiased; overflow-x:hidden; -webkit-user-select:none; -moz-user-select:none; user-select:none; -webkit-touch-callout:none}
  input,textarea,select,[contenteditable],.allow-select{-webkit-user-select:text; user-select:text; -webkit-touch-callout:default}
  a{color:inherit; text-decoration:none}
  h1,h2,h3,h4{margin:0; font-weight:800; letter-spacing:-.04em; text-wrap:balance}
  .mono{font-family:var(--mono); font-variant-numeric:tabular-nums}
  .wrap{max-width:var(--maxw); margin:0 auto; padding-left:28px; padding-right:28px}
  ::selection{background:rgba(255,255,255,.16); color:#fff}
  ::-webkit-scrollbar{width:12px; height:12px}::-webkit-scrollbar-track{background:transparent}::-webkit-scrollbar-thumb{background:rgba(255,255,255,.09); border-radius:10px; border:3px solid transparent; background-clip:content-box}::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,.2); background-clip:content-box} ::-webkit-scrollbar-button{display:none;width:0;height:0} ::-webkit-scrollbar-corner{background:transparent} html::-webkit-scrollbar{width:0;height:0}
  html{scrollbar-width:thin; scrollbar-color:rgba(255,255,255,.13) transparent}
  html.lenis,html.lenis body{height:auto}.lenis.lenis-smooth{scroll-behavior:auto!important}.lenis.lenis-smooth [data-lenis-prevent]{overscroll-behavior:contain}.lenis.lenis-stopped{overflow:hidden}
  #waves{position:fixed; inset:0; width:100%; height:100%; z-index:0; pointer-events:none}
  /* buttons */
  .btn{position:relative; display:inline-flex; align-items:center; justify-content:center; gap:9px; font-family:var(--sans); font-size:.87rem; font-weight:600; padding:10px 18px; border-radius:var(--r-pill); border:1px solid transparent; cursor:pointer; white-space:nowrap; transform:translateZ(0); transition:background .2s var(--ease),border-color .2s var(--ease),color .2s var(--ease),transform .12s var(--ease)}
  .btn svg{width:15px; height:15px}.btn .arw{display:inline-block; transition:transform .28s var(--ease)}.btn:hover .arw{transform:translateX(3px)}.btn:active{transform:scale(.97)}
  .btn-light,.btn-accent{background:#fafafa; color:#000}.btn-light:hover,.btn-accent:hover{background:#d8d8d8}
  .btn-dark{background:#141416; color:var(--text); border-color:var(--line)}.btn-dark:hover{border-color:var(--line-2); background:#191919}
  .btn-lg{padding:13px 24px; font-size:.94rem}
  :where(.btn,.nav-mid a,.nav-right .login,.lang-item,.foot-col a):focus-visible{outline:none; box-shadow:0 0 0 2px var(--bg),0 0 0 4px var(--line-2)}
  /* nav */
  header.nav{position:sticky; top:0; z-index:60; background:rgba(0,0,0,.55); backdrop-filter:blur(14px); -webkit-backdrop-filter:blur(14px); border-bottom:1px solid transparent; transition:border-color .26s var(--ease),background .26s var(--ease)}
  header.nav.scrolled{border-bottom-color:var(--line); background:rgba(0,0,0,.72)}
  .nav-in{display:flex; align-items:center; justify-content:space-between; height:60px; max-width:1440px}
  .brand{display:flex; align-items:center; gap:10px; flex:1 1 0; min-width:0; font-weight:700; font-size:1.08rem; letter-spacing:-.04em; color:var(--text)}
  .brand .mark{width:27px; height:27px; display:grid; place-items:center; color:var(--text); flex:0 0 auto}
  .brand img.mark{object-fit:contain; border-radius:7px}
  .brand .mark svg{width:22px; height:22px}
  .nav-mid{display:flex; align-items:center; gap:6px; flex:0 0 auto}
  .nav-mid a{position:relative; color:var(--text-3); font-size:.885rem; font-weight:500; padding:7px 12px; border-radius:9px; transition:color .16s var(--ease),background .16s var(--ease)}
  .nav-mid a:hover{color:var(--text); background:var(--raise-2)}
  .nav-right{display:flex; align-items:center; gap:10px; flex:1 1 0; justify-content:flex-end}
  @media (max-width:900px){.nav-mid{gap:2px}.nav-right{gap:9px}}
  .nav-right .login{color:var(--text-3); font-size:.885rem; font-weight:500; padding:7px 10px; border-radius:9px; transition:color .16s var(--ease),background .16s var(--ease)}.nav-right .login:hover{color:var(--text); background:var(--raise-2)}
  .nav-right .btn{padding:9px 16px; line-height:1.15}
  .nv-icon,.lang-btn{display:flex; align-items:center; gap:7px; height:34px; padding:0 11px; border:1px solid var(--line); border-radius:var(--r-pill); color:var(--text-2); font-size:.83rem; font-weight:500; cursor:pointer; background:none; font-family:var(--sans); transition:border-color .16s var(--ease),color .16s var(--ease)}
  .nv-icon{width:34px; padding:0; justify-content:center}.nv-icon.lang-btn{width:auto; padding:0 11px}
  .nv-icon:hover,.lang-btn:hover{border-color:var(--line-2); color:var(--text)}.nv-icon svg,.lang-btn svg{width:15px; height:15px}
  .lang-wrap{position:relative}.lang-btn .lang-code{font-size:.74rem; font-weight:700; letter-spacing:.03em}
  .lang-btn .lang-chev{width:14px; height:14px; color:var(--text-3); transition:transform .2s var(--ease)}.lang-wrap.open .lang-btn .lang-chev{transform:rotate(180deg)}
  .lang-pop{position:absolute; top:calc(100% + 8px); inset-inline-end:0; min-width:230px; max-width:calc(100vw - 30px); background:rgba(11,11,11,.985); backdrop-filter:blur(30px); -webkit-backdrop-filter:blur(30px); border:1px solid var(--line-2); border-radius:12px; box-shadow:0 24px 60px -20px rgba(0,0,0,.9); padding:6px; opacity:0; visibility:hidden; transform:translateY(6px); transition:opacity .18s var(--ease),transform .18s var(--ease),visibility .18s; z-index:70}
  .lang-wrap.open .lang-pop{opacity:1; visibility:visible; transform:none}
  .lang-item{display:flex; align-items:center; justify-content:space-between; gap:10px; width:100%; text-align:start; background:none; border:none; padding:8px 10px; border-radius:8px; color:var(--text-2); font-size:.86rem; cursor:pointer; font-family:var(--sans); transition:background .14s var(--ease),color .14s var(--ease)}
  .lang-item:hover{background:var(--raise-2); color:var(--text)}.lang-item.active{color:var(--text)}.lang-item.active .lang-en{color:var(--text-3)}
  .lang-item .lang-native{font-weight:500}.lang-item .lang-en{margin-left:auto; color:var(--text-4); font-size:.76rem}
  .lang-nm{display:flex; align-items:center; gap:10px; min-width:0}
  .nav-burger{display:none; flex-direction:column; align-items:center; justify-content:center; gap:5px; width:34px; height:34px; background:var(--raise); border:1px solid var(--line); border-radius:10px; cursor:pointer; padding:0}
  .nav-burger span{display:block; width:16px; height:1.7px; background:var(--text-2); border-radius:2px; transition:transform .26s var(--ease),opacity .16s var(--ease)}
  header.nav.menu-open .nav-burger span:nth-child(1){transform:translateY(6.7px) rotate(45deg)}header.nav.menu-open .nav-burger span:nth-child(2){opacity:0}header.nav.menu-open .nav-burger span:nth-child(3){transform:translateY(-6.7px) rotate(-45deg)}
  .nav-drawer{display:none}
  .auth-wait{visibility:hidden}
  .auth-out{display:inline-flex; align-items:center; gap:10px}
  @media (max-width:640px){
    .nav-in{height:56px}.nav-mid,.nav-right .login{display:none}
    .nav-right{gap:8px}.nav-right .btn{display:none}
    .nav-burger{display:flex}
    .nav-drawer{display:block; position:absolute; top:100%; left:0; right:0; z-index:59; overflow:hidden; max-height:0; background:#060606; border-bottom:1px solid transparent; box-shadow:0 24px 40px -24px rgba(0,0,0,.9); transition:max-height .26s var(--ease),border-color .26s var(--ease)}
    header.nav.menu-open .nav-drawer{max-height:340px; border-bottom-color:var(--line)}
    .nav-drawer a{display:block; padding:14px 18px; color:var(--text-2); font-size:.95rem; font-weight:500; border-bottom:1px solid var(--line)}
    .nav-drawer a:last-child{border-bottom:none}
    .nav-drawer a:hover{color:var(--text); background:var(--raise-2)}
    .brand{font-size:1.02rem}
  }
      body{ display:flex; flex-direction:column; min-height:100vh; }
  .nav-in{ max-width:1440px; }  /* match the landing's wider topbar */
  .pp-mid{ flex:1; display:grid; place-items:center; text-align:center; padding:72px 24px 104px; position:relative; overflow:hidden; }
  #globe{ position:absolute; top:50%; left:50%; transform:translate(-50%,-44%); width:min(860px,134vw); height:800px; z-index:0; pointer-events:none; -webkit-mask:linear-gradient(to bottom,#000 0,#000 26%,transparent 52%); mask:linear-gradient(to bottom,#000 0,#000 26%,transparent 52%); animation:globeIn .95s cubic-bezier(.16,1,.3,1) both; }
  @keyframes globeIn{ from{ opacity:0; transform:translate(-50%,-44%) translateY(40px); } to{ opacity:1; transform:translate(-50%,-44%); } }
  .pp-mid h1{ margin-top:0; font-size:clamp(2.7rem,6.3vw,4.8rem); font-weight:600; line-height:1.05; letter-spacing:-0.046em; text-wrap:balance; color:#fff; }
  .pp-desc{ margin:14px auto 0; max-width:470px; color:var(--text-2); font-size:1.02rem; line-height:1.62; }
  .pp-desc strong{ color:var(--text); font-weight:600; }
  .pp-actions{ margin-top:32px; display:flex; gap:12px; justify-content:center; flex-wrap:wrap; }
  .pp-foot{ padding:26px; text-align:center; font-size:0.82rem; color:var(--text-3); }
  .pp-foot a{ color:var(--text-2); } .pp-foot a:hover{ color:var(--text); }
  .pp-up{ animation:ppUp .6s var(--ease) both; position:relative; z-index:2; }
  @keyframes ppUp{ from{ opacity:0; transform:translateY(12px); } to{ opacity:1; transform:none; } }
  @media (prefers-reduced-motion:reduce){ .pp-up{ animation:none; } #globe{ opacity:.55; animation:none; } }
  @media (max-width:640px){ .pp-mid h1{ font-size:clamp(1.95rem,8.2vw,2.55rem); } }
</style>
</head>
<body>
<header class="nav" id="nav">
  <div class="wrap nav-in">
    <a class="brand" href="https://obscuravm.com/"><img class="mark" src="https://obscuravm.com/assets/logo.png?v=1" alt="Obscura" width="27" height="27">Obscura</a>
    <nav class="nav-mid" aria-label="Main navigation">
      <a href="https://obscuravm.com/#features">Features</a><a href="https://obscuravm.com/#pricing">Pricing</a><a href="https://obscuravm.com/docs">Docs</a>
    </nav>
    <div class="nav-right">
      <div class="lang-wrap" id="langWrap">
        <button type="button" class="nv-icon lang-btn" id="langBtn" aria-haspopup="true" aria-expanded="false" aria-label="Language">
          <span class="lang-code">EN</span><svg class="lang-chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>
        </button>
        <div class="lang-pop" id="langPop" role="menu">
                      <button type="button" class="lang-item active" data-lang="en" role="menuitem" disabled aria-disabled="true"><span class="lang-nm"><span class="lang-native">English</span></span><span class="lang-en">English</span></button>
                      <button type="button" class="lang-item" data-lang="es" role="menuitem"><span class="lang-nm"><span class="lang-native">Español</span></span><span class="lang-en">Spanish</span></button>
                      <button type="button" class="lang-item" data-lang="pt" role="menuitem"><span class="lang-nm"><span class="lang-native">Português</span></span><span class="lang-en">Portuguese</span></button>
                      <button type="button" class="lang-item" data-lang="fr" role="menuitem"><span class="lang-nm"><span class="lang-native">Français</span></span><span class="lang-en">French</span></button>
                      <button type="button" class="lang-item" data-lang="ru" role="menuitem"><span class="lang-nm"><span class="lang-native">Русский</span></span><span class="lang-en">Russian</span></button>
                      <button type="button" class="lang-item" data-lang="nl" role="menuitem"><span class="lang-nm"><span class="lang-native">Nederlands</span></span><span class="lang-en">Dutch</span></button>
                      <button type="button" class="lang-item" data-lang="pl" role="menuitem"><span class="lang-nm"><span class="lang-native">Polski</span></span><span class="lang-en">Polish</span></button>
                      <button type="button" class="lang-item" data-lang="de" role="menuitem"><span class="lang-nm"><span class="lang-native">Deutsch</span></span><span class="lang-en">German</span></button>
                      <button type="button" class="lang-item" data-lang="tr" role="menuitem"><span class="lang-nm"><span class="lang-native">Türkçe</span></span><span class="lang-en">Turkish</span></button>
                      <button type="button" class="lang-item" data-lang="id" role="menuitem"><span class="lang-nm"><span class="lang-native">Bahasa Indonesia</span></span><span class="lang-en">Indonesian</span></button>
                      <button type="button" class="lang-item" data-lang="ar" role="menuitem"><span class="lang-nm"><span class="lang-native">العربية</span></span><span class="lang-en">Arabic</span></button>
                  </div>
      </div>
      <span id="authOut" class="auth-out"><a class="login" href="https://obscuravm.com/login">Login</a><a class="btn btn-light" href="https://obscuravm.com/login?tab=register">Get started</a></span><a id="authIn" class="btn btn-light" href="https://obscuravm.com/dashboard" style="display:none">Dashboard</a>      <button type="button" class="nav-burger" id="navBurger" aria-label="Menu" aria-expanded="false"><span></span><span></span><span></span></button>
    </div>
  </div>
  <div class="nav-drawer" id="navDrawer">
    <a href="https://obscuravm.com/#features">Features</a><a href="https://obscuravm.com/#pricing">Pricing</a><a href="https://obscuravm.com/docs">Docs</a>
    <span id="authOutD" class=""><a href="https://obscuravm.com/login">Login</a><a href="https://obscuravm.com/login?tab=register">Get started</a></span><a id="authInD" href="https://obscuravm.com/dashboard" style="display:none">Dashboard</a>  </div>
</header>

    <main class="pp-mid">
  <canvas id="waves" aria-hidden="true"></canvas>
  <div class="pp-up">
    <h1>Protected by Obscura</h1>
    <p class="pp-desc" data-i18n-html="This is an Obscura-protected endpoint. It only responds to the script it belongs to at runtime and is served through the &lt;strong&gt;Obscura Protection API&lt;/strong&gt;. There is nothing to view here.">This is an Obscura-protected endpoint. It only responds to the script it belongs to at runtime and is served through the <strong>Obscura Protection API</strong>. There is nothing to view here.</p>
    <div class="pp-actions">
            <a href="https://obscuravm.com/" class="btn btn-light">Back to home</a>
      <a href="https://discord.gg/obscuravm" class="btn btn-dark" target="_blank" rel="noopener">Get help on Discord</a>
          </div>
  </div>
</main>
<footer class="pp-foot">&copy; 2026 Obscura</footer>
<script>  try{sessionStorage.removeItem('obsc_sbnav');}catch(e){}
  // Animated wave-line backdrop (same as the landing + dashboard chrome).
  (function(){
    var c=document.getElementById('waves'); if(!c) return; var x=c.getContext('2d'),W,H,dpr;
    var reduce=false; try{ reduce=matchMedia('(prefers-reduced-motion:reduce)').matches; }catch(e){}
    function size(){ dpr=Math.min(devicePixelRatio||1,2); W=c.width=innerWidth*dpr; H=c.height=innerHeight*dpr; c.style.width=innerWidth+'px'; c.style.height=innerHeight+'px'; }
    size(); addEventListener('resize',size);
    var lines=16,t=0;
    function draw(){ x.clearRect(0,0,W,H);
      for(var i=0;i<lines;i++){ var base=(H*0.10)+(H*0.85)*(i/(lines-1)); var amp=(18+(i%4)*10)*dpr, freq=0.0016/dpr*(1+(i%3)*0.18), phase=t*0.00022*(1+(i%5)*0.12)+i*0.7; x.beginPath();
        for(var px=0;px<=W;px+=8*dpr){ var y=base+Math.sin(px*freq+phase)*amp+Math.sin(px*freq*0.5+phase*1.7)*amp*0.4; px===0?x.moveTo(px,y):x.lineTo(px,y); }
        x.strokeStyle='rgba(255,255,255,'+(0.05-(i/lines)*0.018)+')'; x.lineWidth=1*dpr; x.stroke(); }
      if(!reduce){ t+=16; requestAnimationFrame(draw); } }
    draw();
  })();
  // Cross-origin login-state sync: on subdomains (protected.*) the apex session
  // cookie may not reach us, so ask the apex directly and swap Login/Get-started
  // for Dashboard when the visitor is actually logged in.
  (function(){
    var out=document.getElementById('authOut'); if(!out) return;
    var outD=document.getElementById('authOutD'), aIn=document.getElementById('authIn'), aInD=document.getElementById('authInD');
    function showOut(){ out.classList.remove('auth-wait'); if(outD) outD.classList.remove('auth-wait'); }
    function showIn(){ out.style.display='none'; if(outD) outD.style.display='none';
      if(aIn){ aIn.style.display=''; } if(aInD){ aInD.style.display=''; } }
    if(!/(^|\.)obscuravm\.com$/.test(location.hostname)){ showOut(); return; }
    var done=false;
    var to=setTimeout(function(){ if(!done){ done=true; showOut(); } }, 1500);
    try{
      fetch('https://obscuravm.com/authstate',{credentials:'include',cache:'no-store'})
        .then(function(r){ return r.ok ? r.json() : null; })
        .then(function(d){ if(done) return; done=true; clearTimeout(to); if(d&&d.in) showIn(); else showOut(); })
        .catch(function(){ if(!done){ done=true; clearTimeout(to); showOut(); } });
    }catch(e){ if(!done){ done=true; clearTimeout(to); showOut(); } }
  })();
  // language switcher (open/close; pick a language -> set cookie + translate in place)
  window.pubCloseMenus = function(except){
    ['langWrap'].forEach(function(id){
      var el=document.getElementById(id);
      if(el && el!==except && el.classList.contains('open')){
        el.classList.remove('open');
        var btn=el.querySelector('[aria-expanded]'); if(btn) btn.setAttribute('aria-expanded','false');
      }
    });
  };
  (function(){
    var w=document.getElementById('langWrap'), b=document.getElementById('langBtn'); if(!w||!b) return;
    b.addEventListener('click',function(e){ e.stopPropagation(); if(!w.classList.contains('open')) window.pubCloseMenus(w); var o=w.classList.toggle('open'); b.setAttribute('aria-expanded',o?'true':'false'); });
    document.addEventListener('click',function(e){ if(!w.contains(e.target)){ w.classList.remove('open'); b.setAttribute('aria-expanded','false'); } });
    document.addEventListener('keydown',function(e){ if(e.key==='Escape') w.classList.remove('open'); });
    w.querySelectorAll('.lang-item').forEach(function(it){ it.addEventListener('click',function(){
      var c=it.getAttribute('data-lang')||'en';
      if(it.disabled || it.classList.contains('active')) return;
      try{ (function(v){var d=location.hostname.match(/(^|\.)obscuravm\.com$/)?';domain=.obscuravm.com':'';document.cookie='obs_lang=;path=/;max-age=0;samesite=lax';document.cookie='obs_lang='+v+';path=/;max-age=31536000;samesite=lax'+d;})(c); }catch(e){}
      if(document.documentElement.hasAttribute('data-i18n-reload')){ location.reload(); return; }
      var fin=function(){
        w.querySelectorAll('.lang-item').forEach(function(x){
          var on=x.getAttribute('data-lang')===c;
          x.classList.toggle('active',on); x.disabled=on;
          if(on) x.setAttribute('aria-disabled','true'); else x.removeAttribute('aria-disabled');
        });
        var lc=w.querySelector('.lang-code'); if(lc) lc.textContent=c.toUpperCase();
        try{ document.documentElement.setAttribute('lang',c); }catch(e){}
        w.classList.remove('open'); b.setAttribute('aria-expanded','false');
      };
      if(!(window.Obscura&&window.Obscura.switchLang)){ location.reload(); return; }
      fetch('/langmap?lang='+encodeURIComponent(c),{credentials:'same-origin'})
        .then(function(r){ if(!r.ok) throw new Error('bad'); return r.json(); })
        .then(function(m){ window.Obscura.switchLang(m); fin(); })
        .catch(function(){ location.reload(); });
    }); });
  })();
  (function(){
    var b=document.getElementById('navBurger'), nav=document.getElementById('nav'), dr=document.getElementById('navDrawer');
    if(!b||!nav) return;
    function close(){ nav.classList.remove('menu-open'); b.setAttribute('aria-expanded','false'); }
    b.addEventListener('click',function(e){ e.stopPropagation(); var open=nav.classList.toggle('menu-open'); b.setAttribute('aria-expanded',open?'true':'false'); });
    if(dr) dr.addEventListener('click',function(e){ if(e.target.closest('a')) close(); });
    document.addEventListener('click',function(e){ if(!nav.contains(e.target)) close(); });
    document.addEventListener('keydown',function(e){ if(e.key==='Escape') close(); });
  })();
  (function(){ var n=document.getElementById('nav'); if(!n) return;
    addEventListener('scroll',function(){ n.classList.toggle('scrolled', scrollY>8); }, {passive:true}); })();
      
  (function(){
    var cv=document.getElementById('globe'); if(!cv) return;
    var reduce=false; try{ reduce=window.matchMedia&&window.matchMedia('(prefers-reduced-motion:reduce)').matches; }catch(e){}
    var ctx=cv.getContext('2d'), DPR=Math.min(devicePixelRatio||1,2), W,H;
    function size(){ W=cv.width=Math.max(1,cv.clientWidth)*DPR; H=cv.height=Math.max(1,cv.clientHeight)*DPR; }
    size(); addEventListener('resize',size);
    var TILT=0.5, ct=Math.cos(TILT), st=Math.sin(TILT), rot=0.0, pts=[];
    function uniformGrid(){
      var g=[], LAT=34;
      for(var i=1;i<LAT;i++){
        var phi=Math.PI*(i/LAT)-Math.PI/2, sy=Math.sin(phi), r=Math.cos(phi);
        var lonN=Math.max(4, Math.round(66*r));
        for(var j=0;j<lonN;j++){ var th=2*Math.PI*(j/lonN); g.push([Math.cos(th)*r, sy, Math.sin(th)*r]); }
      }
      return g;
    }
    function buildLand(countries){
      var MW=1000, MH=500;
      var off=document.createElement('canvas'); off.width=MW; off.height=MH;
      var o=off.getContext('2d'); o.scale(MW/2000, MH/1000); o.fillStyle='#fff';
      for(var c=0;c<countries.length;c++){ if(countries[c]&&countries[c].d){ try{ o.fill(new Path2D(countries[c].d)); }catch(e){} } }
      var d=o.getImageData(0,0,MW,MH).data;
      function land(lat,lng){
        var px=((lng+180)/360*MW)|0, py=((90-lat)/180*MH)|0;
        if(px<0)px=0; else if(px>=MW)px=MW-1;
        if(py<0)py=0; else if(py>=MH)py=MH-1;
        return d[(py*MW+px)*4+3] > 40;
      }
      var g=[], N=12000, GA=Math.PI*(3-Math.sqrt(5));
      for(var i=0;i<N;i++){
        var y=1-(i/(N-1))*2, r=Math.sqrt(Math.max(0,1-y*y)), th=i*GA;
        var x=Math.cos(th)*r, z=Math.sin(th)*r;
        if(land(Math.asin(y)*57.2958, Math.atan2(x,z)*57.2958)) g.push([x,y,z]);
      }
      return g.length>300 ? g : uniformGrid();
    }
    pts=uniformGrid();
    fetch('/assets/worldmap.json').then(function(r){return r.ok?r.json():null;}).then(function(j){
      if(Array.isArray(j)){ var g=buildLand(j); if(g.length>300) pts=g; }
    }).catch(function(){});
    function draw(){
      ctx.clearRect(0,0,W,H);
      var cx=W/2, cy=H*0.54, R=Math.min(W,H)*0.5;
      var cr=Math.cos(rot), sr=Math.sin(rot);
      var accent=getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb');
      for(var i=0;i<pts.length;i++){
        var p=pts[i];
        var x1=p[0]*cr - p[2]*sr, z1=p[0]*sr + p[2]*cr, y1=p[1];
        var y2=y1*ct - z1*st, z2=y1*st + z1*ct;
        if(z2 < -0.2) continue;
        var depth=(z2+1)/2, edge=1-Math.abs(z2);
        var sx=cx + x1*R, sy=cy - y2*R, sz=(0.5+depth*1.05)*DPR;
        var a=0.05 + depth*0.62;
        ctx.beginPath(); ctx.arc(sx,sy,sz,0,6.2832);
        ctx.fillStyle = edge>0.72 ? 'rgba('+accent+','+(a*1.4)+')' : 'rgba('+accent+','+(a*0.9)+')';
        ctx.fill();
      }
      if(!reduce) rot+=0.0016;
      requestAnimationFrame(draw);
    }
    draw();
  })();
</script>
<script>(function(){function c(){var b=a.contentDocument||(a.contentWindow&&a.contentWindow.document);if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'a4ac85097d3811d6',t:'MTc5MjA0MzE0Nw=='};var a=document.createElement('script');a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html>