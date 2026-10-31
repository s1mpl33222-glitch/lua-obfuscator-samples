<!doctype html>
<html lang="en">
<head>
 <meta charset="utf-8">
 <link rel="stylesheet" href="/interaction.css">
 <meta name="viewport" content="width=device-width,initial-scale=1">
 <meta name="theme-color" content="#0b0c0f">
 <title>OxKey | Free access</title>
 <style>
  :root{color-scheme:dark;--bg:#0b0c0f;--surface-1:#17181c;--surface-2:#1d1e23;--surface-well:#0d0e12;--text:#f2f2f4;--muted:#9899a2;--subtle:#64656e;--line:rgba(255,255,255,.075);--accent:#ff8500;--ok:#70d6af;--elev-1:inset 0 1px rgba(255,255,255,.06),0 1px 2px rgba(0,0,0,.45),0 6px 18px rgba(0,0,0,.16);--elev-2:inset 0 1px rgba(255,255,255,.075),0 2px 4px rgba(0,0,0,.48),0 16px 44px rgba(0,0,0,.25);--elev-3:inset 0 1px rgba(255,255,255,.09),0 3px 6px rgba(0,0,0,.55),0 30px 70px rgba(0,0,0,.32)}
  *{box-sizing:border-box}
  html,body{min-width:320px;min-height:100%}
  body{margin:0;min-height:100vh;overflow-x:hidden;color:var(--text);background:radial-gradient(44rem 32rem at 100% -8%,rgba(255,133,0,.12),transparent 72%),radial-gradient(38rem 30rem at -8% 104%,rgba(255,85,0,.08),transparent 72%),var(--bg);font-family:Inter,"SF Pro Text","Segoe UI",system-ui,sans-serif;-webkit-font-smoothing:antialiased}
  body:before{content:"";position:fixed;inset:0;pointer-events:none;opacity:.34;background-image:radial-gradient(circle,rgba(255,255,255,.09) 1px,transparent 1.2px);background-size:22px 22px;mask-image:linear-gradient(to bottom,#000,transparent 95%)}
  .page{position:relative;display:flex;min-height:100vh;flex-direction:column}
  .top{display:flex;width:min(720px,calc(100% - 32px));height:76px;align-items:center;justify-content:space-between;margin:0 auto}
  .brand{display:flex;align-items:center;gap:10px}.brand-mark{display:grid;width:32px;height:32px;place-items:center;border:1px solid rgba(255,255,255,.18);border-radius:50%;color:#111217;background:linear-gradient(#fff,#dbdce1);box-shadow:inset 0 1px #fff,0 4px 12px rgba(0,0,0,.32);font-size:13px;font-weight:850}.brand-copy{display:grid;line-height:1.05}.brand-copy strong{font-size:12px}.brand-copy span{margin-top:4px;color:var(--subtle);font-size:8px;font-weight:700;letter-spacing:.16em;text-transform:uppercase}.secure{display:flex;align-items:center;gap:7px;color:var(--muted);font-size:10px}.secure svg{color:var(--accent)}
  .stage{position:relative;display:grid;grid-template-columns:minmax(0,548px);flex:1;place-content:center;padding:32px 16px 70px}
  .ambient{position:absolute;inset:8% 12% 9%;pointer-events:none;border-radius:44px;background:radial-gradient(46% 52% at 18% 20%,rgba(255,133,0,.16),transparent 74%),radial-gradient(48% 55% at 86% 82%,rgba(255,85,0,.12),transparent 75%);filter:blur(28px)}
  .composition{position:relative;width:100%;min-width:0}
  .composition:before{content:"";position:absolute;inset:-34px -44px -30px;z-index:-1;border-radius:32px;background-image:radial-gradient(circle,rgba(255,255,255,.075) 1px,transparent 1.4px);background-size:16px 16px;mask-image:radial-gradient(ellipse at center,#000 25%,transparent 72%)}
  .surface{border:1px solid var(--line);border-top-color:rgba(255,255,255,.13);border-radius:22px;background:var(--surface-1);box-shadow:var(--elev-3)}
  .surface-head{display:flex;align-items:center;justify-content:space-between;gap:14px;padding:20px 22px 18px}
  .identity{display:flex;min-width:0;align-items:center;gap:12px}.avatar{display:grid;width:40px;height:40px;flex:none;place-items:center;border:1px solid rgba(255,255,255,.12);border-radius:50%;background:linear-gradient(145deg,#30323a,#1c1d22);box-shadow:var(--elev-1);font-size:13px;font-weight:750}.identity>span:last-child strong{display:block;font-size:13px}.identity>span:last-child>span{display:block;margin-top:3px;color:var(--muted);font-size:10px}.plan{flex:none;color:var(--muted);font-size:10px}.plan b{color:var(--text);font-weight:650}
  .surface-body{padding:0 22px 22px}
  .rule{height:1px;background:var(--line)}
  .intro{padding:24px 0 20px}.eyebrow{display:flex;align-items:center;gap:7px;color:var(--muted);font-size:9px;font-weight:700;letter-spacing:.14em;text-transform:uppercase}.eyebrow:before{content:"";width:5px;height:5px;border-radius:50%;background:var(--accent);box-shadow:0 0 12px rgba(255,133,0,.55)}
  h1{margin:10px 0 0;font-size:clamp(30px,7vw,40px);font-weight:560;line-height:1.04;letter-spacing:-.05em}.description{max-width:460px;margin:12px 0 0;color:var(--muted);font-size:12px;line-height:1.65;overflow-wrap:anywhere}
  .progress-label{display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;color:var(--muted);font-size:10px}.progress-label span:last-child{font-family:ui-monospace,"SFMono-Regular",Consolas,monospace;color:var(--subtle)}.progress{height:8px;overflow:hidden;border:1px solid rgba(255,255,255,.05);border-radius:999px;background:var(--surface-well);box-shadow:inset 0 1px 4px rgba(0,0,0,.72),inset 0 -1px rgba(255,255,255,.04)}.progress span{display:block;width:33.333%;height:100%;border-radius:inherit;background:linear-gradient(90deg,#ff6500,#ffb21f);box-shadow:0 0 14px rgba(255,133,0,.28)}
  .well{display:flex;align-items:center;gap:12px;margin-top:18px;padding:13px;border:1px solid rgba(255,255,255,.045);border-radius:13px;background:var(--surface-well);box-shadow:inset 0 1px 4px rgba(0,0,0,.72),inset 0 -1px rgba(255,255,255,.04)}.well-icon{display:grid;width:32px;height:32px;flex:none;place-items:center;border:1px solid rgba(255,255,255,.08);border-radius:9px;background:rgba(255,255,255,.035);color:var(--accent)}.well>span:last-child strong{display:block;font-size:11px}.well>span:last-child>span{display:block;margin-top:3px;color:var(--muted);font-size:9px;line-height:1.45}
  .actions{display:flex;align-items:center;gap:10px;margin-top:18px}.button{display:inline-flex;height:40px;align-items:center;justify-content:center;gap:8px;padding:0 17px;border:0;border-radius:999px;color:#121318;background:linear-gradient(#ffa51f,#ff6b00);box-shadow:inset 0 1px #fff,inset 0 -2px rgba(0,0,0,.1),0 0 0 1px rgba(255,255,255,.18),0 2px 4px rgba(0,0,0,.45);font-size:11px;font-weight:750;text-decoration:none;transition:translate .18s ease,filter .18s ease}.button:hover{translate:0 -1px;filter:brightness(1.04)}.button:active{translate:0 1px}.button[aria-disabled=true]{cursor:wait;opacity:.4;pointer-events:none}.button svg{transition:transform .18s ease}.button:hover svg{transform:translateX(2px)}.cancel{padding:10px 4px;color:var(--muted);font-size:10px;text-decoration:none}.cancel:hover{color:var(--text)}
  .meta{display:flex;align-items:center;gap:13px;margin-left:auto;color:var(--subtle);font-size:9px}.meta i{width:1px;height:12px;background:var(--line)}
  .support{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:14px}.support-card{min-width:0;padding:16px;border:1px solid var(--line);border-top-color:rgba(255,255,255,.12);border-radius:17px;background:linear-gradient(145deg,rgba(255,255,255,.052),rgba(255,255,255,.018));box-shadow:var(--elev-2);backdrop-filter:blur(16px) saturate(140%)}.support-card:nth-child(2){background:var(--surface-1)}.support-label{display:flex;align-items:center;gap:7px;color:var(--muted);font-size:10px}.support-label svg{color:var(--accent)}.support-card strong{display:block;margin-top:9px;font-size:12px;font-weight:650}.support-card p{margin:5px 0 0;color:var(--subtle);font-size:9px;line-height:1.5}
  .error .button{display:none}.error .progress span{width:0}.error .well{opacity:.5}.error .description{color:#d5a2a8}.error .cancel{color:#d5a2a8}.error .cancel:after{content:"Ask the workspace owner for a new link"}.error .cancel span{display:none}
  @media(max-width:560px){.top{height:68px}.secure span{display:none}.stage{display:block;padding-top:28px}.surface-head{padding:17px}.surface-body{padding:0 17px 18px}.intro{padding:21px 0 18px}h1{font-size:clamp(28px,9vw,36px)}.actions{align-items:stretch;flex-wrap:wrap}.button{width:100%;border-radius:12px}.cancel{display:none}.meta{width:100%;justify-content:center;margin:2px 0 0}.support{grid-template-columns:1fr;gap:10px}.support-card{padding:14px}.composition:before{inset:-20px}.ambient{inset:5% -10%}}
 </style>
</head>
<body>
 <div class="page">
  <header class="top">
   <div class="brand"><svg role="img" aria-label="OxKey" viewBox="450 160 1170 425" width="105" height="40"><defs><filter id="oxkey-wordmark" color-interpolation-filters="sRGB"><feColorMatrix type="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  1.5 0 0 0 -0.5"/></filter></defs><image href="/brand/oxkey-wordmark.png" width="2070" height="760" filter="url(#oxkey-wordmark)"/></svg><span class="brand-copy"><span>Free access</span></span></div>
   <div class="secure"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"><path d="M12 3 4.5 6v5c0 4.8 3 8.3 7.5 10 4.5-1.7 7.5-5.2 7.5-10V6L12 3Z"/><path d="m9 12 2 2 4-4"/></svg><span>Protected key delivery</span></div>
  </header>

  <main class="stage">
   <div class="ambient"></div>
   <div class="composition">
    <section class="surface" id="offer">
     <header class="surface-head">
      <div class="identity"><svg role="img" aria-label="OxKey" viewBox="545 265 465 455" width="40" height="40"><defs><filter id="oxkey-icon" color-interpolation-filters="sRGB"><feColorMatrix type="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  1.5 0 0 0 -0.5"/></filter></defs><image href="/brand/oxkey-icon.png" width="1536" height="1024" filter="url(#oxkey-icon)"/></svg><span><strong id="hubName">OxKey workspace</strong><span>Work.ink free access</span></span></div>
      <span class="plan"><b id="duration">Loading</b> access</span>
     </header>

     <div class="surface-body">
      <div class="rule"></div>
      <div class="intro">
       <div class="eyebrow">Temporary key</div>
       <h1 id="title">Complete Work.ink.</h1>
       <p class="description" id="description">Checking this workspace's free-key link&hellip;</p>
      </div>

      <div class="progress-label"><span>Access progress</span><span>1 / 3</span></div>
      <div class="progress" aria-label="One of three steps"><span></span></div>

      <div class="well">
       <span class="well-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"><path d="M5 12h14M13 6l6 6-6 6"/></svg></span>
       <span><strong>Finish every step on Work.ink</strong><span>Keep that page open. It sends you back when the key is ready.</span></span>
      </div>

      <div class="actions">
       <a id="continue" class="button" aria-disabled="true">Continue <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M5 12h14M13 6l6 6-6 6"/></svg></a>
       <a class="cancel" href="#"><span>Not now</span></a>
       <div class="meta"><span>1 device</span><i></i><span>Single use</span></div>
      </div>
     </div>
    </section>

    <div class="support">
     <section class="support-card"><div class="support-label"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M8 11V7a4 4 0 0 1 8 0v4"/><rect x="5" y="11" width="14" height="10" rx="2"/></svg>What you receive</div><strong>A temporary OxKey key</strong><p>Valid for this workspace on one device.</p></section>
     <section class="support-card"><div class="support-label"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M12 3 4.5 6v5c0 4.8 3 8.3 7.5 10 4.5-1.7 7.5-5.2 7.5-10V6L12 3Z"/><path d="m9 12 2 2 4-4"/></svg>Private by default</div><strong>No Roblox login</strong><p>The Work.ink token is checked once, then consumed.</p></section>
    </div>
   </div>
  </main>
 </div>

 <script>
  const hub=location.pathname.split('/').filter(Boolean).pop();
  const offer=document.getElementById('offer');
  const button=document.getElementById('continue');
  const description=document.getElementById('description');
  const duration=document.getElementById('duration');
  fetch('/api/workink/'+encodeURIComponent(hub),{credentials:'omit'}).then(async response=>{
   const data=await response.json();
   if(!response.ok)throw Error(data.error||'Offer unavailable');
   document.title='Complete Work.ink for '+data.hubName;
   document.getElementById('hubName').textContent=data.hubName;
   description.textContent='Open Work.ink and complete its sponsor steps. You will return automatically with a temporary key for this workspace.';
   duration.textContent=data.hours+' hour'+(data.hours===1?'':'s');
   button.href=data.linkUrl;
   button.removeAttribute('aria-disabled');
  }).catch(()=>{
   offer.classList.add('error');
   document.getElementById('title').textContent='This link is unavailable.';
   description.textContent='A new Work.ink link needs to be configured before you can continue.';
   duration.textContent='No';
  });
 </script>
</body>
</html>
