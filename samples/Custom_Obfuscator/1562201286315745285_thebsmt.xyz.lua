<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home · BSMT Hub</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
  *{margin:0;padding:0;box-sizing:border-box}
  :root{
    --bg:#07080a; --panel:#0d0f13; --panel-2:#11141a;
    --line:#1c2029; --line-hi:#2a3040;
    --cy:#00ffd5; --cy-dim:#06b39a; --cy-ink:#032b25;
    --text:#eef2f4; --dim:#9aa3b2; --muted:#5b6270;
    --ok:#2fe08a; --warn:#ffb454; --err:#ff5b6e;
  }
  html{scroll-behavior:smooth}
  body{font-family:'Inter',system-ui,sans-serif;background:var(--bg);color:var(--text);-webkit-font-smoothing:antialiased;min-height:100vh;overflow-x:hidden}
  a{color:inherit;text-decoration:none}
  .mono{font-family:'JetBrains Mono',ui-monospace,monospace}
  body::before{content:"";position:fixed;inset:0;z-index:0;pointer-events:none;
    background-image:linear-gradient(rgba(255,255,255,.022) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.022) 1px,transparent 1px);
    background-size:64px 64px;mask-image:radial-gradient(circle at 50% 0,#000 0,transparent 78%)}
  .wrap{position:relative;z-index:1;max-width:1120px;margin:0 auto;padding:104px 28px 90px}
  .wrap.narrow{max-width:560px}
  .wrap.mid{max-width:820px}
  /* header bits */
  .tag{display:inline-flex;align-items:center;gap:9px;padding:6px 12px;border:1px solid var(--line-hi);border-radius:6px;background:var(--panel);font-size:12px;font-weight:600;letter-spacing:.14em;text-transform:uppercase;color:var(--cy);margin-bottom:20px}
  .tag .pip{width:6px;height:6px;border-radius:50%;background:var(--cy);box-shadow:0 0 10px var(--cy)}
  .tag.ok .pip{background:var(--ok);box-shadow:0 0 10px var(--ok)}
  h1.big{font-size:clamp(2.2rem,6vw,3.4rem);font-weight:800;letter-spacing:-.03em;line-height:1.03;margin-bottom:14px}
  h1.big .u{color:var(--cy)}
  .lead{font-size:1.03rem;color:var(--dim);line-height:1.55;max-width:640px}
  .sec-head{display:flex;align-items:center;justify-content:space-between;gap:12px;margin:0 0 18px;flex-wrap:wrap}
  .sec-head .t{display:flex;align-items:center;gap:10px;font-size:1.15rem;font-weight:700}
  .sec-head .t i{color:var(--cy);font-size:.95rem}
  .sec-head .c{font-size:.8rem;color:var(--muted);font-family:'JetBrains Mono',monospace}
  /* buttons */
  .btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:11px 18px;border-radius:9px;font-size:.88rem;font-weight:700;cursor:pointer;transition:.15s;border:1px solid var(--line-hi);background:var(--panel-2);color:var(--text);font-family:inherit}
  .btn:hover{border-color:var(--cy);color:var(--cy)}
  .btn.primary{background:var(--cy);color:var(--cy-ink);border-color:var(--cy)}
  .btn.primary:hover{filter:brightness(1.08);color:var(--cy-ink)}
  .btn.ghost{background:transparent}
  .btn.block{width:100%}
  .btn.sm{padding:8px 13px;font-size:.8rem;border-radius:8px}
  .btn.danger{border-color:rgba(255,91,110,.4);color:#ffb3bb}
  .btn.danger:hover{border-color:var(--err);color:var(--err)}
  /* cards */
  .card{background:var(--panel);border:1px solid var(--line);border-radius:14px;padding:24px}
  .card.hi{background:var(--panel-2)}
  .grid{display:grid;gap:16px}
  .g2{grid-template-columns:repeat(2,1fr)}
  .g3{grid-template-columns:repeat(3,1fr)}
  .g4{grid-template-columns:repeat(4,1fr)}
  @media(max-width:820px){.g3,.g4{grid-template-columns:repeat(2,1fr)}}
  @media(max-width:560px){.g2,.g3,.g4{grid-template-columns:1fr}}
  /* form fields */
  .field{margin-bottom:15px}
  .field label{display:block;font-size:.78rem;color:var(--dim);margin:0 0 7px 2px;font-weight:600;letter-spacing:.02em}
  .inp{width:100%;padding:12px 14px;background:var(--bg);border:1px solid var(--line-hi);border-radius:10px;color:var(--text);font-size:.95rem;font-family:inherit;outline:none;transition:border .15s}
  .inp:focus{border-color:var(--cy)}
  textarea.inp{resize:vertical;min-height:96px}
  select.inp{cursor:pointer}
  /* badges + rows */
  .badge{display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:.72rem;font-weight:700}
  .badge .dot{width:6px;height:6px;border-radius:50%;background:currentColor}
  .badge.live{background:rgba(47,224,138,.14);border:1px solid rgba(47,224,138,.4);color:var(--ok)}
  .badge.warn{background:rgba(255,180,84,.14);border:1px solid rgba(255,180,84,.4);color:var(--warn)}
  .badge.err{background:rgba(255,91,110,.14);border:1px solid rgba(255,91,110,.4);color:var(--err)}
  .badge.cy{background:rgba(0,255,213,.12);border:1px solid rgba(0,255,213,.35);color:var(--cy)}
  .kv{display:flex;justify-content:space-between;align-items:center;gap:12px;padding:12px 0;border-bottom:1px solid var(--line)}
  .kv:last-child{border-bottom:none}
  .kv .k{color:var(--dim);font-size:.86rem}
  .kv .v{font-weight:700;font-size:.9rem;text-align:right;word-break:break-word}
  .chip{font-family:'JetBrains Mono',monospace;font-size:.7rem;color:var(--dim);background:var(--bg);border:1px solid var(--line);padding:4px 9px;border-radius:6px}
  /* code / key box */
  .codebox{position:relative;background:var(--bg);border:1px solid var(--line);border-radius:10px;padding:16px 18px;overflow-x:auto;font-family:'JetBrains Mono',monospace;font-size:.86rem;color:var(--cy);cursor:pointer}
  .codebox .lbl{position:absolute;top:-9px;left:14px;background:var(--panel);padding:0 8px;font-size:.66rem;letter-spacing:.12em;text-transform:uppercase;color:var(--muted)}
  .keybox{background:rgba(0,255,213,.06);border:1px solid rgba(0,255,213,.3);border-radius:12px;padding:16px;text-align:center;font-family:'JetBrains Mono',monospace;font-size:1rem;font-weight:700;color:var(--cy);word-break:break-all}
  /* alerts */
  .alert{display:flex;align-items:center;gap:10px;padding:13px 16px;border-radius:10px;font-size:.9rem;font-weight:500;margin-bottom:18px;line-height:1.45}
  .alert i{flex-shrink:0}
  .alert.err{border:1px solid rgba(255,91,110,.35);background:rgba(255,91,110,.08);color:#ffb3bb}
  .alert.err i{color:var(--err)}
  .alert.ok{border:1px solid rgba(47,224,138,.35);background:rgba(47,224,138,.08);color:#8ff0c0}
  .alert.ok i{color:var(--ok)}
  .alert.info{border:1px solid var(--line);border-left:2px solid var(--cy);background:var(--panel);color:var(--dim);border-radius:0 10px 10px 0}
  .alert.info i{color:var(--cy)}
  /* table */
  .tbl-wrap{overflow-x:auto;border:1px solid var(--line);border-radius:12px}
  table.tbl{width:100%;border-collapse:collapse;font-size:.86rem;min-width:520px}
  table.tbl th{text-align:left;padding:12px 14px;background:var(--panel-2);color:var(--dim);font-weight:600;font-size:.74rem;text-transform:uppercase;letter-spacing:.06em;border-bottom:1px solid var(--line)}
  table.tbl td{padding:12px 14px;border-bottom:1px solid var(--line);color:var(--text)}
  table.tbl tr:last-child td{border-bottom:none}
  table.tbl tr:hover td{background:rgba(255,255,255,.02)}
  /* misc */
  .muted{color:var(--muted)} .dim{color:var(--dim)}
  .center{text-align:center}
  .toast{position:fixed;top:80px;right:24px;display:flex;align-items:center;gap:10px;background:var(--panel-2);border:1px solid rgba(47,224,138,.4);color:var(--ok);padding:12px 18px;border-radius:11px;font-weight:600;font-size:.88rem;z-index:9999;transform:translateX(420px);transition:transform .35s cubic-bezier(.68,-.4,.26,1.4)}
  .toast.show{transform:none}
  .tfoot{position:relative;z-index:1;border-top:1px solid var(--line);margin-top:60px;padding:26px 28px;display:flex;justify-content:space-between;align-items:center;max-width:1120px;margin-left:auto;margin-right:auto;flex-wrap:wrap;gap:14px}
  .tfoot span{color:var(--muted);font-size:.82rem}
  .tfoot a.dc{display:inline-flex;align-items:center;justify-content:center;width:40px;height:40px;border:1px solid var(--line);border-radius:9px;color:var(--dim);transition:.15s}
  .tfoot a.dc:hover{color:var(--cy);border-color:var(--cy)}

        .home-wrap{max-width:1000px}
        .home-hero{text-align:center;padding:8px 0 44px;border-bottom:1px solid var(--line);margin-bottom:44px}
        .home-hero .tag{margin-inline:auto}
        .home-hero h1.big{margin:0 auto 16px;max-width:16ch}
        .home-hero .lead{margin:0 auto}
        .home-cta{display:flex;gap:12px;justify-content:center;flex-wrap:wrap;margin:28px 0 40px}
        .home-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;max-width:640px;margin:0 auto}
        .home-stats .hs{border:1px solid var(--line);background:var(--panel);border-radius:12px;padding:20px 14px}
        .home-stats .n{font-size:1.8rem;font-weight:800;color:var(--cy);line-height:1}
        .home-stats .l{font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.06em;margin-top:8px}
        @media(max-width:560px){.home-stats{grid-template-columns:1fr;max-width:320px}}
        .home-feats{margin-bottom:44px}
        .card.feat .fic{width:46px;height:46px;border-radius:12px;background:var(--panel-2);border:1px solid var(--line-hi);display:flex;align-items:center;justify-content:center;color:var(--cy);font-size:1.15rem;margin-bottom:16px}
        .card.feat h3{font-size:1.08rem;font-weight:700;margin-bottom:8px}
        .card.feat p{font-size:.9rem;color:var(--dim);line-height:1.55}
        .home-account{display:flex;align-items:center;justify-content:space-between;gap:22px;flex-wrap:wrap}
        .home-account h2{font-size:1.3rem;font-weight:800;margin-bottom:6px}
        .home-account .ha-cta{display:flex;gap:10px;flex-wrap:wrap}
        .pm-overlay{display:none;position:fixed;inset:0;z-index:9999;background:rgba(3,4,6,.8);backdrop-filter:blur(6px);align-items:center;justify-content:center;padding:20px}
        .pm-card{position:relative;background:var(--panel);border:1px solid var(--line-hi);border-radius:16px;padding:34px 28px;max-width:400px;width:100%;text-align:center;overflow:hidden}
        .pm-line{position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--cy),transparent)}
        .pm-ic{width:52px;height:52px;border-radius:13px;background:var(--panel-2);border:1px solid var(--line-hi);display:flex;align-items:center;justify-content:center;color:var(--cy);font-size:1.35rem;margin:0 auto 16px}
        .pm-card h3{font-size:1.3rem;font-weight:800;margin-bottom:8px}
        .pm-card p{font-size:.86rem;line-height:1.5;margin-bottom:22px}
        .pm-opts{display:flex;flex-direction:column;gap:10px}
      </style>

</head>
<body>
  
    <style>
      .hp-nav{position:fixed;top:0;left:0;width:100%;z-index:1000;display:flex;align-items:center;justify-content:space-between;padding:.85rem 1.5rem;background:rgba(10,10,15,.72);backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px);border-bottom:1px solid rgba(0,255,213,.15)}
      .hp-logo{display:flex;align-items:center;gap:.55rem;font-weight:900;font-size:1.15rem;color:#fff;text-decoration:none}
      .hp-logo i{color:#00ffd5}
      .hp-links{display:flex;align-items:center;gap:.35rem}
      .hp-link{display:inline-flex;align-items:center;gap:.45rem;padding:.55rem .9rem;border-radius:10px;color:#b8c1ec;text-decoration:none;font-weight:600;font-size:.9rem;transition:.15s;white-space:nowrap}
      .hp-link:hover{color:#fff;background:rgba(255,255,255,.06)}
      .hp-link.active{color:#00ffd5}
      .hp-link.hp-cta{background:linear-gradient(135deg,#00ffd5,#00d4b3);color:#06231e;font-weight:800}
      .hp-burger{display:none;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.12);color:#fff;width:42px;height:42px;border-radius:11px;font-size:1.15rem;cursor:pointer;align-items:center;justify-content:center}
      @media(max-width:820px){
        .hp-burger{display:flex}
        .hp-links{position:fixed;top:64px;left:0;right:0;flex-direction:column;align-items:stretch;gap:.3rem;padding:1rem 1.25rem 1.5rem;background:rgba(10,10,15,.97);backdrop-filter:blur(20px);border-bottom:1px solid rgba(0,255,213,.15);transform:translateY(-130%);transition:transform .28s ease;max-height:calc(100vh - 64px);overflow-y:auto}
        .hp-links.open{transform:translateY(0)}
        .hp-link{padding:.85rem 1rem;font-size:1rem;border-radius:12px;justify-content:flex-start}
        .hp-link.hp-cta{justify-content:center;margin-top:.4rem}
      }
    </style>
    <nav class="hp-nav">
      <a href="/" class="hp-logo"><i class="fas fa-cube"></i> BSMT Hub</a>
      <button class="hp-burger" id="hpBurger" aria-label="Toggle menu"><i class="fas fa-bars"></i></button>
      <div class="hp-links" id="hpLinks">
        <a href="/" class="hp-link active">Home</a>
        <a href="/key-info" class="hp-link">Key Info</a>
        <a href="/tools" class="hp-link">Tools</a>
        <a href="/buy" class="hp-link">Purchase</a>
        <a href="/tickets" class="hp-link"><i class="fas fa-bag-shopping"></i> Shop</a>
        <a href="/chat" class="hp-link"><i class="fas fa-comments"></i> Chat</a>
        <a href="/login" class="hp-link">Login</a><a href="/register" class="hp-link hp-cta"><i class="fas fa-user-plus"></i> Sign Up</a>
      </div>
    </nav>
    <script>(function(){var b=document.getElementById('hpBurger'),l=document.getElementById('hpLinks');if(b&&l)b.addEventListener('click',function(){l.classList.toggle('open');});})();</script>
  <div class="wrap home-wrap">
      <section class="home-hero">
        <span class="tag ok"><span class="pip"></span> Trusted by the community · 2+ years</span>
        <h1 class="big">Scripts &amp; externals,<br><span class="u">one key.</span></h1>
        <p class="lead">BSMT is a multi-game hub with hardware-locked key auth. Run the Lua script hub inside Roblox, or the native externals that sit outside the client &mdash; all on a single key.</p>
        <div class="home-cta">
          <button class="btn primary" onclick="openProviderModal()"><i class="fas fa-key"></i> Generate free key</button>
          <a href="/buy" class="btn"><i class="fas fa-cart-shopping"></i> View pricing</a>
          <a href="/tools" class="btn ghost"><i class="fas fa-toolbox"></i> Browse tools</a>
        </div>

        <div class="home-stats">
          <div class="hs"><div class="n mono">192</div><div class="l">Active keys</div></div>
          <div class="hs"><div class="n mono">99.97%</div><div class="l">Uptime</div></div>
          <div class="hs"><div class="n mono">26</div><div class="l">Keys today</div></div>
        </div>
      </section>

      <section class="home-feats grid g3">
        <div class="card feat">
          <div class="fic"><i class="fas fa-layer-group"></i></div>
          <h3>Two products, one login</h3>
          <p>The Roblox script hub and the native externals authenticate against the same key. Buy once, use both.</p>
        </div>
        <div class="card feat">
          <div class="fic"><i class="fas fa-fingerprint"></i></div>
          <h3>Hardware-locked auth</h3>
          <p>Encrypted handshake and per-device fingerprinting on every request &mdash; keys can't be shared around.</p>
        </div>
        <div class="card feat">
          <div class="fic"><i class="fas fa-bolt"></i></div>
          <h3>Instant &amp; battle-tested</h3>
          <p>Keys are delivered the second checkout clears. Two-plus years in production behind it.</p>
        </div>
      </section>

      <section class="card home-account">
        <div class="ha-txt"><h2>Create a free account</h2>
               <p class="dim">Run <b style="color:var(--cy)">.code</b> in our Discord for a signup code, then sync your key, get roles, and chat with the community.</p></div>
             <div class="ha-cta">
               <a href="/register" class="btn primary"><i class="fas fa-user-plus"></i> Create account</a>
               <a href="/login" class="btn"><i class="fas fa-right-to-bracket"></i> Login</a>
             </div>
      </section>

      <div id="providerModal" class="pm-overlay" onclick="if(event.target===this)closeProviderModal()">
        <div class="pm-card">
          <div class="pm-line"></div>
          <div class="pm-ic"><i class="fas fa-key"></i></div>
          <h3>Get your free key</h3>
          <p class="dim">Complete one quick verification to receive a free 24-hour key. (Externals need a paid key &mdash; <a href="/buy" style="color:var(--cy)">see pricing</a>.)</p>
          <div class="pm-opts">
            <a href="/start-flow?provider=linkvertise" class="btn primary block"><i class="fas fa-link"></i> Linkvertise</a>
            <a href="/start-flow?provider=workink" class="btn block"><i class="fas fa-pen-nib"></i> work.ink</a>
          </div>
          <button class="btn ghost sm" style="margin-top:14px" onclick="closeProviderModal()">Cancel</button>
        </div>
      </div>
    </div>
  <footer class="tfoot">
    <span class="mono">© 2026 BSMT Hub</span>
    <a class="dc" href="https://discord.gg/At5PrV2JYa" target="_blank" rel="noopener"><i class="fab fa-discord"></i></a>
  </footer>
  <script>
        function openProviderModal(){document.getElementById('providerModal').style.display='flex';document.body.style.overflow='hidden';}
        function closeProviderModal(){document.getElementById('providerModal').style.display='none';document.body.style.overflow='';}
        document.addEventListener('keydown',function(e){if(e.key==='Escape')closeProviderModal();});
      </script>
</body>
</html>