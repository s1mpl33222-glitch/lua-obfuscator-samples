<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MoneyScripts — LARP Apps</title>
<meta name="description" content="Fully disclosed fake app simulators, App Store style — Roblox, Cash App, Phantom, Exodus and more. No real items, money, or account changes, ever.">
<link rel="icon" href="favicon.ico">
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap');

:root{
  --bg:#07070c;
  --surface:#121219;
  --surface-2:#191922;
  --surface-3:#21212c;
  --border:rgba(255,255,255,.08);
  --border-hi:rgba(255,255,255,.16);
  --text:#f5f5f7;
  --text-dim:#92929e;
  --text-faint:#55555f;
  --blue:#0a84ff;
  --blue-hi:#3d9bff;
  --star:#ffb400;
  --warn:#ffc33d;
  --warn-bg:rgba(255,195,61,.09);
  --warn-border:rgba(255,195,61,.3);
  --glass-bg:rgba(255,255,255,.055);
  --glass-border:rgba(255,255,255,.14);
}
*{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{
  background:var(--bg);
  color:var(--text);
  font-family:-apple-system,BlinkMacSystemFont,'SF Pro Display','Inter',system-ui,sans-serif;
  -webkit-font-smoothing:antialiased;
  overflow-x:hidden;
  position:relative;
}
a{color:inherit;text-decoration:none}
.wrap{max-width:720px;margin:0 auto;padding:0 20px}

/* starfield */
.stars{
  position:fixed;inset:0;z-index:0;pointer-events:none;opacity:.5;
  background-image:
    radial-gradient(1.4px 1.4px at 10% 15%, #fff 0, transparent 60%),
    radial-gradient(1.2px 1.2px at 30% 45%, #fff 0, transparent 60%),
    radial-gradient(1.6px 1.6px at 55% 10%, #fff 0, transparent 60%),
    radial-gradient(1.2px 1.2px at 70% 60%, #fff 0, transparent 60%),
    radial-gradient(1.4px 1.4px at 85% 25%, #fff 0, transparent 60%),
    radial-gradient(1.2px 1.2px at 20% 75%, #fff 0, transparent 60%),
    radial-gradient(1.6px 1.6px at 45% 85%, #fff 0, transparent 60%),
    radial-gradient(1.2px 1.2px at 92% 70%, #fff 0, transparent 60%),
    radial-gradient(1.2px 1.2px at 5% 55%, #fff 0, transparent 60%),
    radial-gradient(1.4px 1.4px at 62% 35%, #fff 0, transparent 60%);
  background-size:100% 900px;
}

/* liquid-glass surface */
.glass{
  background:var(--glass-bg);
  -webkit-backdrop-filter:blur(26px) saturate(170%);
  backdrop-filter:blur(26px) saturate(170%);
  border:1px solid var(--glass-border);
  box-shadow:inset 0 1px 0 rgba(255,255,255,.22), inset 0 0 0 1px rgba(255,255,255,.03), 0 14px 34px -14px rgba(0,0,0,.5);
}

/* NAV */
.nav{position:sticky;top:0;z-index:100;background:rgba(7,7,12,.55);-webkit-backdrop-filter:blur(22px) saturate(170%);backdrop-filter:blur(22px) saturate(170%);border-bottom:1px solid var(--glass-border);box-shadow:inset 0 -1px 0 rgba(255,255,255,.05)}
.nav-inner{max-width:720px;margin:0 auto;padding:14px 20px;display:flex;align-items:center;gap:11px}
.nav-logo{width:38px;height:38px;border-radius:11px;overflow:hidden;background:linear-gradient(135deg,var(--blue),#7c3dff);flex-shrink:0;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:16px}
.nav-logo img{width:100%;height:100%;object-fit:cover;display:block}
.nav-names{display:flex;flex-direction:column;gap:1px}
.nav-word{font-weight:800;font-size:15px;letter-spacing:-.01em}
.nav-sub{font-size:10px;font-weight:700;color:var(--text-faint);letter-spacing:.08em}
.nav-right{margin-left:auto}
.nav-discord{
  width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#5865f2,#7983f5);
  display:flex;align-items:center;justify-content:center;transition:transform .15s;
}
.nav-discord:hover{transform:scale(1.06)}
.auth-user{display:flex;align-items:center;gap:7px;cursor:pointer;background:var(--surface);border:1px solid var(--border);border-radius:30px;padding:4px 12px 4px 4px;transition:border-color .15s}
.auth-user:hover{border-color:var(--border-hi)}
.auth-avatar{width:24px;height:24px;border-radius:50%;object-fit:cover;display:block}
.auth-name{font-size:12.5px;font-weight:600;max-width:90px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.auth-gate{text-align:center;padding:6px 0 2px}
.auth-gate p{font-size:12.5px;color:var(--text-dim);margin-bottom:14px}
.auth-gate-btn{display:flex;justify-content:center}

/* HERO */
.hero-shell{position:relative;overflow:hidden}
.hero-grid-bg{
  position:absolute;inset:0;z-index:0;pointer-events:none;
  background-image:
    repeating-linear-gradient(0deg, rgba(255,255,255,.055) 0 1px, transparent 1px 44px),
    repeating-linear-gradient(90deg, rgba(255,255,255,.055) 0 1px, transparent 1px 44px),
    radial-gradient(55% 48% at 50% 32%, rgba(10,132,255,.17), transparent 72%);
  -webkit-mask-image:radial-gradient(70% 62% at 50% 26%, #000 0%, transparent 85%);
  mask-image:radial-gradient(70% 62% at 50% 26%, #000 0%, transparent 85%);
}
.hero{position:relative;z-index:1;padding:44px 20px 30px;max-width:720px;margin:0 auto;text-align:center}
.hero-display{font-family:'JetBrains Mono',monospace;font-weight:700;font-size:clamp(38px,11vw,78px);letter-spacing:-.01em;color:#fff;text-shadow:0 0 30px rgba(255,255,255,.3),0 0 2px rgba(255,255,255,.5);font-variant-numeric:tabular-nums;margin:0 0 18px;animation:cardIn .6s cubic-bezier(.2,.8,.2,1) both}
.hero h1{font-size:clamp(26px,5.2vw,38px);font-weight:800;line-height:1.14;letter-spacing:-.02em;max-width:18ch;margin:0 auto;animation:cardIn .6s cubic-bezier(.2,.8,.2,1) .05s both}
.hero-sub{margin:16px auto 0;font-size:14.5px;line-height:1.6;color:var(--text-dim);max-width:44ch}
.hero-chips{display:flex;flex-wrap:wrap;justify-content:center;gap:9px;margin-top:20px}
.hero-chips span{font-size:11px;font-weight:600;color:var(--text-dim);background:var(--surface-2);border:1px solid var(--border);padding:6px 13px;border-radius:20px}
.hero-cta-row{display:flex;align-items:center;justify-content:center;gap:20px;margin-top:24px;flex-wrap:wrap}
.hero-cta-primary{display:inline-flex;align-items:center;gap:8px;background:var(--text);color:#07070c;font-weight:700;font-size:14.5px;padding:13px 22px;border-radius:30px;transition:transform .15s,box-shadow .15s}
.hero-cta-primary:hover{transform:translateY(-1px);box-shadow:0 10px 24px -10px rgba(255,255,255,.3)}
.hero-cta-secondary{font-weight:700;font-size:14.5px;color:var(--text-dim);display:inline-flex;align-items:center;gap:5px;transition:color .15s}
.hero-cta-secondary:hover{color:var(--text)}
.hero-note{display:flex;align-items:center;justify-content:center;gap:7px;margin-top:22px;font-size:12px;color:var(--text-faint)}
.hero-note b{color:var(--warn)}
.ic-warn{color:var(--warn);flex-shrink:0}

/* SEARCH */
.search-wrap{position:relative;z-index:1;max-width:720px;margin:0 auto;padding:0 20px 16px}
.search-row{display:flex;gap:10px}
.search-input{
  flex:1;background:var(--glass-bg);-webkit-backdrop-filter:blur(26px) saturate(170%);backdrop-filter:blur(26px) saturate(170%);
  border:1px solid var(--glass-border);border-radius:16px;box-shadow:inset 0 1px 0 rgba(255,255,255,.18);
  padding:14px 18px;color:var(--text);font-size:15px;outline:none;transition:border-color .15s;
}
.search-input::placeholder{color:var(--text-faint)}
.search-input:focus{border-color:var(--border-hi)}
.search-btn{
  width:52px;height:52px;flex-shrink:0;border-radius:16px;border:none;cursor:pointer;
  background:var(--blue);display:flex;align-items:center;justify-content:center;transition:background .15s;
}
.search-btn:hover{background:var(--blue-hi)}

/* PILLS */
.pills-wrap{position:relative;z-index:1;max-width:720px;margin:0 auto;padding:0 20px 30px;overflow-x:auto}
.pills-row{display:flex;gap:9px;width:max-content}
.pill{
  background:var(--glass-bg);-webkit-backdrop-filter:blur(20px) saturate(170%);backdrop-filter:blur(20px) saturate(170%);
  border:1px solid var(--glass-border);box-shadow:inset 0 1px 0 rgba(255,255,255,.15);color:var(--text-dim);
  font-size:13px;font-weight:600;padding:9px 16px;border-radius:30px;cursor:pointer;
  white-space:nowrap;transition:border-color .15s,color .15s,background .15s;
}
.pill:hover{color:var(--text);border-color:var(--border-hi)}
.pill.active{background:var(--text);color:#000;border-color:var(--text)}

/* HOW IT WORKS */
.how{position:relative;z-index:1;max-width:720px;margin:0 auto;padding:34px 20px 50px}
.how h2{font-size:19px;font-weight:800;margin-bottom:16px}
.how-steps{display:grid;grid-template-columns:1fr;gap:12px}
@media (min-width:640px){.how-steps{grid-template-columns:repeat(3,1fr)}}
.how-step{background:var(--glass-bg);-webkit-backdrop-filter:blur(20px) saturate(170%);backdrop-filter:blur(20px) saturate(170%);border:1px solid var(--glass-border);border-radius:18px;padding:20px}
.how-num{width:26px;height:26px;border-radius:50%;background:var(--blue);color:#fff;font-size:12.5px;font-weight:800;display:flex;align-items:center;justify-content:center;margin-bottom:12px;font-family:'JetBrains Mono',monospace}
.how-title{font-size:14.5px;font-weight:700;margin-bottom:6px}
.how-text{font-size:12.5px;color:var(--text-dim);line-height:1.55}

/* FEATURED */
.featured{position:relative;z-index:1;max-width:720px;margin:0 auto;padding:4px 20px 60px}
.featured h2{font-size:19px;font-weight:800;margin-bottom:16px}
.app-list{display:flex;flex-direction:column;gap:16px}

@keyframes cardIn{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
@keyframes iconPop{0%{transform:scale(.7);opacity:0}70%{transform:scale(1.08)}100%{transform:scale(1);opacity:1}}
.app-card{
  border-radius:24px;
  padding:20px;transition:border-color .15s,transform .15s,box-shadow .15s;
  animation:cardIn .5s cubic-bezier(.2,.8,.2,1) both;
}
.app-list .app-card:nth-child(1){animation-delay:.02s}
.app-list .app-card:nth-child(2){animation-delay:.08s}
.app-list .app-card:nth-child(3){animation-delay:.14s}
.app-list .app-card:nth-child(4){animation-delay:.2s}
.app-list .app-card:nth-child(5){animation-delay:.26s}
.app-list .app-card:nth-child(6){animation-delay:.32s}
.app-list .app-card:nth-child(7){animation-delay:.38s}
.app-card:hover{border-color:var(--border-hi);transform:translateY(-4px);box-shadow:0 14px 30px -14px rgba(0,0,0,.5)}
.app-card .app-icon{animation:iconPop .5s cubic-bezier(.2,.8,.2,1) both;animation-delay:inherit}
.app-top{display:flex;gap:13px;align-items:flex-start}
.app-icon{
  width:62px;height:62px;border-radius:16px;flex-shrink:0;display:flex;align-items:center;justify-content:center;
  background:var(--surface-3);overflow:hidden;
  box-shadow:inset 0 1px 0 rgba(255,255,255,.14);
}
.app-icon img{width:100%;height:100%;object-fit:cover;display:block}
.app-icon-stack{background:none;box-shadow:none;position:relative;overflow:visible}
.app-icon-stack img{position:absolute;width:38px;height:38px;border-radius:11px;box-shadow:0 0 0 3px var(--bg,#0a0a0f),0 4px 10px -4px rgba(0,0,0,.6);object-fit:cover}
.app-icon-stack img:nth-child(1){left:0;top:10px;z-index:4}
.app-icon-stack img:nth-child(2){left:16px;top:0;z-index:3}
.app-icon-stack img:nth-child(3){left:32px;top:10px;z-index:2}
.app-icon-stack-4 img{width:32px;height:32px;border-radius:9px}
.app-icon-stack-4 img:nth-child(1){left:0;top:16px;z-index:4}
.app-icon-stack-4 img:nth-child(2){left:14px;top:0;z-index:3}
.app-icon-stack-4 img:nth-child(3){left:28px;top:16px;z-index:2}
.app-icon-stack-4 img:nth-child(4){left:42px;top:0;z-index:1}
.app-meta{flex:1;min-width:0}
.app-name{font-size:16.5px;font-weight:800;display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.app-tagline{font-size:13px;color:var(--text-dim);margin-top:2px}
.larp-chip{
  display:inline-flex;align-items:center;gap:4px;color:var(--warn);background:var(--warn-bg);
  border:1px solid var(--warn-border);font-size:9.5px;font-weight:700;letter-spacing:.04em;
  padding:3px 8px;border-radius:7px;flex-shrink:0;
}
.app-desc{font-size:13.5px;color:var(--text-dim);line-height:1.55;margin-top:12px}

.app-buy-row{display:flex;align-items:center;gap:12px;margin-top:16px}
.app-price-lg{font-size:24px;font-weight:800;white-space:nowrap}
.app-price-lg span{font-size:13px;font-weight:600;color:var(--text-dim);margin-left:2px}
.app-cta{flex:1;background:var(--blue);color:#fff;border:none;border-radius:13px;padding:13px;font-size:14.5px;font-weight:700;cursor:pointer;transition:background .15s,transform .12s}
.app-cta:hover{background:var(--blue-hi)}
.app-cta:active{transform:scale(.96)}
.secure-line{display:flex;align-items:center;gap:6px;margin-top:10px;font-size:11.5px;color:var(--text-faint)}

.app-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:18px;padding-top:16px;border-top:1px solid var(--border)}
.stat-label{font-size:9.5px;font-weight:700;letter-spacing:.07em;color:var(--text-faint);margin-bottom:5px}
.stat-value{font-size:14px;font-weight:700;display:flex;align-items:center;gap:4px}
.stat-stars{display:flex;gap:1px;margin-top:4px}
.stat-sub{font-size:11.5px;color:var(--text-dim);margin-top:1px}

.shots-row{display:flex;gap:10px;margin-top:16px;overflow-x:auto}
.shot{
  width:118px;aspect-ratio:9/16;flex-shrink:0;border-radius:14px;position:relative;overflow:hidden;
  border:1px solid var(--border);display:flex;align-items:flex-end;padding:10px;
}
.shot img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.shot::before{content:"";position:absolute;inset:0;background:linear-gradient(0deg, rgba(0,0,0,.78), rgba(0,0,0,0) 55%);z-index:1}
.shot span{position:relative;z-index:2;font-size:11px;font-weight:700;color:#fff;line-height:1.3;text-shadow:0 1px 4px rgba(0,0,0,.6)}
.shot1{background:linear-gradient(160deg,#1c2c52,#0a84ff 140%)}
.shot2{background:linear-gradient(160deg,#2a1c4a,#7c3dff 140%)}
.shot3{background:linear-gradient(160deg,#1c3a2c,#17c26b 140%)}
.shot4{background:linear-gradient(160deg,#4a2a1c,#ff8a3d 140%)}
.shot5{background:linear-gradient(160deg,#3a1c2c,#ff5ca8 140%)}
.shot6{background:linear-gradient(160deg,#2c2c1c,#ffd43d 140%)}

/* REDEEM */
.redeem{position:relative;z-index:1;max-width:720px;margin:0 auto;padding:4px 20px 40px}
.redeem-inner{border-radius:24px;padding:26px 24px;background:var(--glass-bg);-webkit-backdrop-filter:blur(26px) saturate(170%);backdrop-filter:blur(26px) saturate(170%);border:1px solid var(--glass-border);box-shadow:inset 0 1px 0 rgba(255,255,255,.14)}
.redeem-inner h2{font-size:18px;font-weight:800}
.redeem-sub{margin-top:8px;font-size:13px;line-height:1.55;color:var(--text-dim);max-width:52ch}
.redeem-row{display:flex;gap:10px;margin-top:16px}
.redeem-input{flex:1;background:var(--surface-2);border:1px solid var(--border);border-radius:13px;padding:13px 16px;color:var(--text);font-size:15px;letter-spacing:.04em;outline:none;transition:border-color .15s;text-transform:uppercase}
.redeem-input::placeholder{color:var(--text-faint);text-transform:none;letter-spacing:normal}
.redeem-input:focus{border-color:var(--border-hi)}
.redeem-btn{flex:none;background:var(--blue);color:#fff;border:none;border-radius:13px;padding:13px 22px;font-size:14.5px;font-weight:700;cursor:pointer;transition:background .15s,transform .12s}
.redeem-btn:hover{background:var(--blue-hi)}
.redeem-btn:active{transform:scale(.96)}
.redeem-btn:disabled{opacity:.5;cursor:not-allowed}
.redeem-result{font-size:13px}
.redeem-result:not(:empty){margin-top:12px;min-height:16px}
.redeem-result.ok{color:#7fe08a}
.redeem-result.err{color:#ff8a8a}

/* FOOTER */
footer{position:relative;z-index:1;border-top:1px solid var(--border);padding:26px 20px;text-align:center}
footer p{font-size:11px;color:var(--text-faint);line-height:1.75;max-width:680px;margin:0 auto}
footer strong{color:#7a7a86}

/* MODAL */
.overlay{position:fixed;inset:0;z-index:300;background:rgba(2,2,4,.82);backdrop-filter:blur(10px);display:none;align-items:center;justify-content:center;padding:20px}
.overlay.open{display:flex}
.modal{width:100%;max-width:400px;background:#121219;-webkit-backdrop-filter:blur(30px) saturate(170%);backdrop-filter:blur(30px) saturate(170%);border:1px solid var(--glass-border);box-shadow:inset 0 1px 0 rgba(255,255,255,.1),0 20px 50px -14px rgba(0,0,0,.6);border-radius:24px;padding:26px;display:flex;flex-direction:column;gap:15px;position:relative}
.modal-close{position:absolute;top:16px;right:16px;width:28px;height:28px;border-radius:50%;background:var(--surface-2);border:1px solid var(--border);color:var(--text-dim);cursor:pointer;display:flex;align-items:center;justify-content:center}
.modal-close:hover{color:var(--text)}
.modal h3{font-size:18px;text-align:center;font-weight:800}
.modal-price{text-align:center;font-size:13px;color:var(--text-dim);font-weight:600;margin-top:-9px}
.warning-banner{display:flex;gap:9px;align-items:flex-start;font-size:12px;line-height:1.55;color:var(--text-dim);background:var(--warn-bg);border:1px solid var(--warn-border);border-radius:14px;padding:13px 14px}
.warning-banner b{color:var(--warn)}
.steps{display:flex;flex-direction:column;gap:8px}
.step{display:flex;gap:11px;align-items:center;background:var(--surface-2);border:1px solid var(--border);border-radius:12px;padding:11px 13px}
.step-num{width:22px;height:22px;border-radius:50%;background:var(--blue);color:#fff;font-size:11.5px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.step-text{font-size:13px;font-weight:600}
.step-text b{color:var(--blue-hi)}
.confirm-row{display:flex;gap:9px;align-items:flex-start}
.confirm-row input{margin-top:3px;width:16px;height:16px;flex-shrink:0;accent-color:var(--blue)}
.confirm-row label{font-size:12px;color:var(--text-dim);line-height:1.45;cursor:pointer}
.discord-btn{width:100%;justify-content:center;background:#5865f2;color:#fff;text-decoration:none;border-radius:13px;padding:14px;font-weight:700;font-size:14px;display:flex;align-items:center;gap:9px;transition:background .15s}
.discord-btn:hover{background:#4752d9}
.discord-btn[disabled]{opacity:.35;cursor:not-allowed;pointer-events:none}

.checkout-locked{text-align:center;font-size:12.5px;color:var(--text-faint);padding:10px 0}
.checkout-form-wrap{min-height:40px}
.checkout-form-wrap .app-cta[disabled]{opacity:.6;cursor:not-allowed}
.checkout-form-error{margin-top:10px;font-size:12.5px;color:#ff6b6b;background:rgba(255,107,107,.1);border:1px solid rgba(255,107,107,.3);border-radius:10px;padding:10px 12px}
.modal-support{text-align:center;font-size:11.5px;color:var(--text-faint);margin-top:2px}
.modal-support a{color:var(--blue-hi);font-weight:600}

.hidden{display:none !important}
</style>
<script src="/add-to-home.js"></script>
</head>
<body>
<div class="stars"></div>

<div class="nav">
  <div class="nav-inner">
    <div class="nav-logo"><img src="icon.png" alt="" onerror="this.parentElement.textContent='M'"></div>
    <div class="nav-names">
      <div class="nav-word">MoneyScripts</div>
      <div class="nav-sub">BY MONEYSCRIPTS.SHOP</div>
    </div>
    <div class="nav-right">
      <div id="authSignedOut"><div id="gSignInBtn"></div></div>
      <div id="authSignedIn" class="auth-user hidden" onclick="signOut()" title="Click to sign out">
        <img id="authAvatar" class="auth-avatar" src="" alt="">
        <span id="authName" class="auth-name"></span>
      </div>
    </div>
  </div>
</div>

<!-- HERO -->
<header class="hero-shell">
  <div class="hero-grid-bg" aria-hidden="true"></div>
  <div class="hero">
    <div class="hero-display" id="heroBalance">$0.00</div>
    <h1>Any balance. Any app. Zero dollars spent.</h1>
    <p class="hero-sub">Pixel-perfect fake screens for Cash App, Phantom, Exodus, PayPal and Roblox. Type in whatever number you want, screenshot it, post it. Nothing real ever moves.</p>
    <div class="hero-chips">
      <span>No real funds, ever</span>
      <span>Same exact UI as the real app</span>
      <span>Edit it whenever you want</span>
    </div>
    <div class="hero-cta-row">
      <a href="#featured" class="hero-cta-primary">Browse the apps</a>
      <a href="#how" class="hero-cta-secondary">How it works <span aria-hidden="true">→</span></a>
    </div>
    <div class="hero-note">
      <svg class="ic-warn" width="14" height="14" viewBox="0 0 24 24" fill="none"><path d="M12 3L2 20h20L12 3z" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/><path d="M12 10v4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><circle cx="12" cy="16.6" r="1" fill="currentColor"/></svg>
      <span>100% fake simulators — <b>no real money, items, or accounts, ever.</b></span>
    </div>
  </div>
</header>

<!-- SEARCH -->
<div class="search-wrap">
  <div class="search-row">
    <input class="search-input" id="searchInput" type="text" placeholder="Search in 7 larp apps" oninput="filterApps()">
    <button class="search-btn" aria-label="Search">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="7" stroke="white" stroke-width="2"/><path d="M21 21l-4.35-4.35" stroke="white" stroke-width="2" stroke-linecap="round"/></svg>
    </button>
  </div>
</div>

<!-- PILLS -->
<div class="pills-wrap">
  <div class="pills-row" id="pillsRow">
    <div class="pill active" data-filter="all" onclick="setFilter('all')">All</div>
    <div class="pill" data-filter="mobile" onclick="setFilter('mobile')">Mobile</div>
    <div class="pill" data-filter="avatar" onclick="setFilter('avatar')">Avatar</div>
    <div class="pill" data-filter="gifting" onclick="setFilter('gifting')">Gifting</div>
    <div class="pill" data-filter="bundle" onclick="setFilter('bundle')">Bundle</div>
  </div>
</div>

<!-- HOW IT WORKS -->
<section class="how" id="how">
  <h2>How it works</h2>
  <div class="how-steps">
    <div class="how-step">
      <div class="how-num">1</div>
      <div class="how-title">Pick an app</div>
      <div class="how-text">Cash App, Phantom, Exodus, PayPal, Roblox — or get all four finance apps with the Mega Pack.</div>
    </div>
    <div class="how-step">
      <div class="how-num">2</div>
      <div class="how-title">Set any balance</div>
      <div class="how-text">Type in whatever number you want. Cashtag, wallet address, avatar — all yours to edit too.</div>
    </div>
    <div class="how-step">
      <div class="how-num">3</div>
      <div class="how-title">Screenshot &amp; post</div>
      <div class="how-text">Same exact UI as the real app. Nothing real is ever touched — it's just pixels.</div>
    </div>
  </div>
</section>

<!-- FEATURED -->
<section class="featured" id="featured">
  <h2>Featured larp apps</h2>
  <div class="app-list">

    <article class="app-card glass" data-name="mega pack" data-tags="bundle mobile">
      <div class="app-top">
        <div class="app-icon app-icon-stack app-icon-stack-4">
          <img src="cashapp/apple-touch-icon.png" alt="Cash App">
          <img src="phantom/apple-touch-icon.png" alt="Phantom">
          <img src="walletui/apple-touch-icon.png" alt="Exodus">
          <img src="paypal/apple-touch-icon.png" alt="PayPal">
        </div>
        <div class="app-meta">
          <div class="app-name">
            Mega Pack
          </div>
          <div class="app-tagline">Cash App + Phantom + Exodus + PayPal, bundled</div>
        </div>
      </div>
      <div class="app-desc">One subscription unlocks all four fake finance-app LARPs — Cash App, Phantom, Exodus and PayPal — instead of paying for each separately. No real money, crypto, or accounts are ever touched.</div>

      <div class="app-buy-row">
        <div class="app-price-lg">$33<span>/mo</span></div>
        <button class="app-cta" id="buyBtn-megapack" data-product="megapack" data-name="Mega Pack" data-price="$33/month" data-label="Subscribe" onclick="handleAppCta(this)">Subscribe</button>
      </div>
      <div class="secure-line">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none"><rect x="5" y="10" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M8 10V7a4 4 0 018 0v3" stroke="currentColor" stroke-width="1.6"/></svg>
        Secure checkout · crypto or card
      </div>

      <div class="app-stats">
        <div class="stat">
          <div class="stat-stars">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">DEVELOPER</div>
          <div class="stat-value">@carlatosisback
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#0a84ff"><path d="M12 2l2.4 1.9 3-.5 1 2.9 2.9 1-.5 3L23 12l-1.9 2.4.5 3-2.9 1-1 2.9-3-.5L12 23l-2.4-1.9-3 .5-1-2.9-2.9-1 .5-3L1 12l1.9-2.4-.5-3 2.9-1 1-2.9 3 .5L12 2z"/><path d="M8.5 12.2l2.2 2.3 4.6-5" stroke="white" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">PLATFORM</div>
          <div class="stat-value">iOS &amp; Android</div>
          <div class="stat-sub">Mobile</div>
        </div>
      </div>
    </article>

    <article class="app-card glass" data-name="cash app" data-tags="mobile finance">
      <div class="app-top">
        <div class="app-icon">
          <img src="cashapp/apple-touch-icon.png" alt="Cash App">
        </div>
        <div class="app-meta">
          <div class="app-name">
            Cash App
          </div>
          <div class="app-tagline">Just LARP It — Money edition</div>
        </div>
      </div>
      <div class="app-desc">A fake Cash App balance screen you fully control — edit the balance, cashtag, card digits, savings, whatever you want. No real bank account, card, or money is ever connected.</div>

      <div class="app-buy-row">
        <div class="app-price-lg">$10<span>/mo</span></div>
        <button class="app-cta" id="buyBtn-cashapp" data-product="cashapp" data-name="Cash App" data-price="$10/month" data-label="Subscribe" onclick="handleAppCta(this)">Subscribe</button>
      </div>
      <div class="secure-line">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none"><rect x="5" y="10" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M8 10V7a4 4 0 018 0v3" stroke="currentColor" stroke-width="1.6"/></svg>
        Secure checkout · crypto or card
      </div>

      <div class="app-stats">
        <div class="stat">
          <div class="stat-stars">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">DEVELOPER</div>
          <div class="stat-value">@carlatosisback
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#0a84ff"><path d="M12 2l2.4 1.9 3-.5 1 2.9 2.9 1-.5 3L23 12l-1.9 2.4.5 3-2.9 1-1 2.9-3-.5L12 23l-2.4-1.9-3 .5-1-2.9-2.9-1 .5-3L1 12l1.9-2.4-.5-3 2.9-1 1-2.9 3 .5L12 2z"/><path d="M8.5 12.2l2.2 2.3 4.6-5" stroke="white" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">PLATFORM</div>
          <div class="stat-value">iOS &amp; Android</div>
          <div class="stat-sub">Mobile</div>
        </div>
      </div>

      <div class="shots-row">
        <div class="shot shot3"><img src="shot-ca-balance.jpg" alt=""><span>Your balance, your rules</span></div>
        <div class="shot shot1"><img src="shot-ca-edit.jpg" alt=""><span>Edit everything yourself</span></div>
        <div class="shot shot2"><img src="shot-ca-search.jpg" alt=""><span>Pay &amp; request anyone</span></div>
      </div>
    </article>

    <article class="app-card glass" data-name="phantom" data-tags="mobile crypto">
      <div class="app-top">
        <div class="app-icon">
          <img src="phantom/apple-touch-icon.png" alt="Phantom">
        </div>
        <div class="app-meta">
          <div class="app-name">
            Phantom
          </div>
          <div class="app-tagline">Just LARP It — Crypto edition</div>
        </div>
      </div>
      <div class="app-desc">A fake Phantom wallet with a balance and token list you set yourself — send, receive, and swap screens included. No real wallet, seed phrase, or crypto is ever connected or moved.</div>

      <div class="app-buy-row">
        <div class="app-price-lg">$10<span>/mo</span></div>
        <button class="app-cta" id="buyBtn-phantom" data-product="phantom" data-name="Phantom" data-price="$10/month" data-label="Subscribe" onclick="handleAppCta(this)">Subscribe</button>
      </div>
      <div class="secure-line">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none"><rect x="5" y="10" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M8 10V7a4 4 0 018 0v3" stroke="currentColor" stroke-width="1.6"/></svg>
        Secure checkout · crypto or card
      </div>

      <div class="app-stats">
        <div class="stat">
          <div class="stat-stars">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">DEVELOPER</div>
          <div class="stat-value">@carlatosisback
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#0a84ff"><path d="M12 2l2.4 1.9 3-.5 1 2.9 2.9 1-.5 3L23 12l-1.9 2.4.5 3-2.9 1-1 2.9-3-.5L12 23l-2.4-1.9-3 .5-1-2.9-2.9-1 .5-3L1 12l1.9-2.4-.5-3 2.9-1 1-2.9 3 .5L12 2z"/><path d="M8.5 12.2l2.2 2.3 4.6-5" stroke="white" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">PLATFORM</div>
          <div class="stat-value">iOS &amp; Android</div>
          <div class="stat-sub">Mobile</div>
        </div>
      </div>

      <div class="shots-row">
        <div class="shot shot2"><img src="shot-ph-balance.jpg" alt=""><span>Your balance, your tokens</span></div>
        <div class="shot shot1"><img src="shot-ph-send.jpg" alt=""><span>Send, receive, trade menu</span></div>
        <div class="shot shot3"><img src="shot-ph-card.jpg" alt=""><span>Phantom Cash card</span></div>
      </div>
    </article>

    <article class="app-card glass" data-name="exodus" data-tags="mobile crypto">
      <div class="app-top">
        <div class="app-icon">
          <img src="walletui/apple-touch-icon.png" alt="Exodus">
        </div>
        <div class="app-meta">
          <div class="app-name">
            Exodus
          </div>
          <div class="app-tagline">Just LARP It — Multi-chain edition</div>
        </div>
      </div>
      <div class="app-desc">A fake self-custodial multi-chain wallet — balances, send/receive/request flows, and a token list you set up yourself. No real wallet, crypto, or funds are ever connected or moved.</div>

      <div class="app-buy-row">
        <div class="app-price-lg">$10<span>/mo</span></div>
        <button class="app-cta" id="buyBtn-exodus" data-product="exodus" data-name="Exodus" data-price="$10/month" data-label="Subscribe" onclick="handleAppCta(this)">Subscribe</button>
      </div>
      <div class="secure-line">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none"><rect x="5" y="10" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M8 10V7a4 4 0 018 0v3" stroke="currentColor" stroke-width="1.6"/></svg>
        Secure checkout · crypto or card
      </div>

      <div class="app-stats">
        <div class="stat">
          <div class="stat-stars">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">DEVELOPER</div>
          <div class="stat-value">@carlatosisback
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#0a84ff"><path d="M12 2l2.4 1.9 3-.5 1 2.9 2.9 1-.5 3L23 12l-1.9 2.4.5 3-2.9 1-1 2.9-3-.5L12 23l-2.4-1.9-3 .5-1-2.9-2.9-1 .5-3L1 12l1.9-2.4-.5-3 2.9-1 1-2.9 3 .5L12 2z"/><path d="M8.5 12.2l2.2 2.3 4.6-5" stroke="white" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">PLATFORM</div>
          <div class="stat-value">iOS &amp; Android</div>
          <div class="stat-sub">Mobile</div>
        </div>
      </div>

      <div class="shots-row">
        <div class="shot shot1"><img src="shot-ex-wallet.jpg" alt=""><span>Multi-chain wallet balance</span></div>
        <div class="shot shot3"><img src="shot-ex-detail.jpg" alt=""><span>Token detail &amp; chart</span></div>
        <div class="shot shot2"><img src="shot-ex-swap.jpg" alt=""><span>Swap between tokens</span></div>
      </div>
    </article>

    <article class="app-card glass" data-name="paypal" data-tags="mobile finance">
      <div class="app-top">
        <div class="app-icon">
          <img src="paypal/apple-touch-icon.png" alt="PayPal">
        </div>
        <div class="app-meta">
          <div class="app-name">
            PayPal
          </div>
          <div class="app-tagline">Just LARP It — Send edition</div>
        </div>
      </div>
      <div class="app-desc">A fake PayPal send-money screen — pick a contact, type an amount, confirm. No real PayPal account, balance, or payment is ever connected or sent.</div>

      <div class="app-buy-row">
        <div class="app-price-lg">$10<span>/mo</span></div>
        <button class="app-cta" id="buyBtn-paypal" data-product="paypal" data-name="PayPal" data-price="$10/month" data-label="Subscribe" onclick="handleAppCta(this)">Subscribe</button>
      </div>
      <div class="secure-line">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none"><rect x="5" y="10" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M8 10V7a4 4 0 018 0v3" stroke="currentColor" stroke-width="1.6"/></svg>
        Secure checkout · crypto or card
      </div>

      <div class="app-stats">
        <div class="stat">
          <div class="stat-stars">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">DEVELOPER</div>
          <div class="stat-value">@carlatosisback
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#0a84ff"><path d="M12 2l2.4 1.9 3-.5 1 2.9 2.9 1-.5 3L23 12l-1.9 2.4.5 3-2.9 1-1 2.9-3-.5L12 23l-2.4-1.9-3 .5-1-2.9-2.9-1 .5-3L1 12l1.9-2.4-.5-3 2.9-1 1-2.9 3 .5L12 2z"/><path d="M8.5 12.2l2.2 2.3 4.6-5" stroke="white" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">PLATFORM</div>
          <div class="stat-value">iOS &amp; Android</div>
          <div class="stat-sub">Mobile</div>
        </div>
      </div>

      <div class="shots-row">
        <div class="shot shot1"><img src="shot-pp-send.jpg" alt=""><span>Send to anyone</span></div>
        <div class="shot shot3"><img src="shot-pp-request.jpg" alt=""><span>Request a payment</span></div>
      </div>
    </article>

    <article class="app-card glass" data-name="roblox mobile larp" data-tags="mobile avatar">
      <div class="app-top">
        <div class="app-icon">
          <img src="roblox-app-icon.png" alt="Roblox">
        </div>
        <div class="app-meta">
          <div class="app-name">
            Roblox Mobile LARP
          </div>
          <div class="app-tagline">Just LARP It</div>
        </div>
      </div>
      <div class="app-desc">A pixel-accurate fake mobile Roblox app shell — catalog, avatar editor, friends list and gifting flows, rebuilt for your phone. No real Roblox account is ever accessed.</div>

      <div class="app-buy-row">
        <div class="app-price-lg">$10<span>/mo</span></div>
        <button class="app-cta" id="buyBtn-mobile" data-product="mobile" data-name="Roblox Mobile LARP" data-price="$10/month" data-label="Subscribe" onclick="handleAppCta(this)">Subscribe</button>
      </div>
      <div class="secure-line">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none"><rect x="5" y="10" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M8 10V7a4 4 0 018 0v3" stroke="currentColor" stroke-width="1.6"/></svg>
        Checkout via Discord ticket · crypto or card
      </div>

      <div class="app-stats">
        <div class="stat">
          <div class="stat-stars">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">DEVELOPER</div>
          <div class="stat-value">@carlatosisback
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#0a84ff"><path d="M12 2l2.4 1.9 3-.5 1 2.9 2.9 1-.5 3L23 12l-1.9 2.4.5 3-2.9 1-1 2.9-3-.5L12 23l-2.4-1.9-3 .5-1-2.9-2.9-1 .5-3L1 12l1.9-2.4-.5-3 2.9-1 1-2.9 3 .5L12 2z"/><path d="M8.5 12.2l2.2 2.3 4.6-5" stroke="white" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">PLATFORM</div>
          <div class="stat-value">iOS &amp; Android</div>
          <div class="stat-sub">Mobile</div>
        </div>
      </div>

      <div class="shots-row">
        <div class="shot"><img src="shot-rm-marketplace.jpg" alt=""><span>Browse the marketplace</span></div>
        <div class="shot"><img src="shot-rm-buyitem.jpg" alt=""><span>Fake "buy item" flow</span></div>
        <div class="shot"><img src="shot-rm-customize.jpg" alt=""><span>Full avatar editor</span></div>
        <div class="shot"><img src="shot-rm-profile.jpg" alt=""><span>Browse any profile</span></div>
        <div class="shot"><img src="shot-rm-foryou.jpg" alt=""><span>Home feed, for you</span></div>
        <div class="shot"><img src="shot-rm-trending.jpg" alt=""><span>Trending games</span></div>
      </div>
    </article>

    <article class="app-card glass" data-name="headless gifter" data-tags="mobile gifting">
      <div class="app-top">
        <div class="app-icon">
          <img src="roblox-app-icon.png" alt="Roblox">
        </div>
        <div class="app-meta">
          <div class="app-name">
            Headless Gifter
          </div>
          <div class="app-tagline">Gift the Headless — the fake way</div>
        </div>
      </div>
      <div class="app-desc">Simulate gifting the Headless Horseman to any username, with a realistic catalog page and "sent!" confirmation. Pay once, keep forever. No real item is ever sent.</div>

      <div class="app-buy-row">
        <div class="app-price-lg">$20<span>one-time</span></div>
        <button class="app-cta" id="buyBtn-headless" data-product="headless" data-name="Headless Gifter" data-price="$20 one-time" data-label="Get" onclick="handleAppCta(this)">Get</button>
      </div>
      <div class="secure-line">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none"><rect x="5" y="10" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M8 10V7a4 4 0 018 0v3" stroke="currentColor" stroke-width="1.6"/></svg>
        Checkout via Discord ticket · crypto or card
      </div>

      <div class="app-stats">
        <div class="stat">
          <div class="stat-stars">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg><svg width="10" height="10" viewBox="0 0 24 24" fill="#ffb400"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6L12 2z"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">DEVELOPER</div>
          <div class="stat-value">@carlatosisback
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#0a84ff"><path d="M12 2l2.4 1.9 3-.5 1 2.9 2.9 1-.5 3L23 12l-1.9 2.4.5 3-2.9 1-1 2.9-3-.5L12 23l-2.4-1.9-3 .5-1-2.9-2.9-1 .5-3L1 12l1.9-2.4-.5-3 2.9-1 1-2.9 3 .5L12 2z"/><path d="M8.5 12.2l2.2 2.3 4.6-5" stroke="white" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>
        <div class="stat">
          <div class="stat-label">PLATFORM</div>
          <div class="stat-value">iOS &amp; Android</div>
          <div class="stat-sub">Mobile</div>
        </div>
      </div>

      <div class="shots-row">
        <div class="shot"><img src="shot-hg-marketplace.jpg?v=2" alt=""><span>Browse the marketplace</span></div>
        <div class="shot"><img src="shot-hg-gift.jpg?v=2" alt=""><span>Fake "gift with Plus" flow</span></div>
        <div class="shot"><img src="shot-hg-panel.jpg" alt=""><span>Equip items &amp; edit friends by ID</span></div>
      </div>
    </article>

  </div>
</section>

<!-- REDEEM -->
<section class="redeem" id="redeem">
  <div class="redeem-inner">
    <h2>Redeem a code</h2>
    <p class="redeem-sub">Got a code? Redeem it here.</p>

    <div id="redeemAuthGate" class="auth-gate hidden">
      <p>Sign in with Google first — this is how we know which account to grant access to.</p>
      <div class="auth-gate-btn"><div id="gSignInBtnRedeem"></div></div>
    </div>

    <div id="redeemAuthed">
      <div class="redeem-row">
        <input class="redeem-input" id="redeemCodeInput" type="text" placeholder="XXXXX-XXXXX" autocomplete="off" autocapitalize="characters" spellcheck="false">
        <button class="redeem-btn" id="redeemBtn" onclick="redeemCode()">Redeem</button>
      </div>
      <div id="redeemResult" class="redeem-result"></div>
    </div>
  </div>
</section>

<footer>
  <p>
    This website is a <strong>fan-made LARP / simulator</strong> and is not affiliated with, endorsed by, or associated with Roblox Corporation, Block Inc. (Cash App), Phantom Technologies Inc., Exodus Movement Inc., PayPal Holdings Inc., Apple Inc., or the App Store in any way. All related names, logos, images and trademarks are the property of their respective owners and are used here solely for illustrative purposes. <strong>Roblox Mobile LARP ($10/month)</strong>, <strong>Headless Gifter ($20 one-time)</strong>, <strong>Cash App ($10/month)</strong>, <strong>Phantom ($10/month)</strong>, <strong>Exodus ($10/month)</strong>, <strong>PayPal ($10/month)</strong> and the <strong>Mega Pack ($33/month)</strong> are all 100% fake simulators — no real Robux, items, money, crypto, wallets, bank accounts, or account changes of any kind are ever delivered, under any circumstance. <strong>moneyscripts.shop</strong>
  </p>
</footer>

<!-- CHECKOUT MODAL -->
<div class="overlay" id="checkoutOverlay">
  <div class="modal">
    <button class="modal-close" onclick="closeCheckout()">
      <svg width="13" height="13" viewBox="0 0 14 14" fill="none"><path d="M2 2l10 10M12 2L2 12" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
    </button>
    <h3 id="checkoutTitle">Get Access</h3>
    <div class="modal-price" id="checkoutPrice"></div>

    <div id="checkoutAuthGate" class="auth-gate hidden">
      <p>Sign in with Google first — this is how we know which account to grant access to.</p>
      <div class="auth-gate-btn"><div id="gSignInBtnModal"></div></div>
    </div>

    <div id="checkoutAuthed">
      <div class="warning-banner">
        <svg class="ic-warn" width="15" height="15" viewBox="0 0 24 24" fill="none"><path d="M12 3L2 20h20L12 3z" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/><path d="M12 10v4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><circle cx="12" cy="16.6" r="1" fill="currentColor"/></svg>
        <span><b>Please read before continuing:</b> this app is a <b>FAKE LARP / SIMULATOR</b> made for entertainment only. No real Robux, items, money, crypto, wallets, or account changes of any kind ever occur. You are paying only for access to the roleplay experience — not for anything real.</span>
      </div>
      <div class="confirm-row">
        <input type="checkbox" id="checkoutConfirm" onchange="onConfirmToggle(this.checked)">
        <label for="checkoutConfirm">I understand this is a fake LARP/simulator and no real items, Robux, or account changes are delivered.</label>
      </div>

      <div id="checkoutLocked" class="checkout-locked">Check the box above to continue to payment.</div>
      <div id="checkoutFormWrap" class="checkout-form-wrap hidden">
        <button class="app-cta" id="checkoutPayBtn" onclick="goToPayment()">Continue to secure payment</button>
        <div id="checkoutFormError" class="checkout-form-error hidden"></div>
      </div>
    </div>

    <div class="modal-support">
      Problem paying? <a href="https://discord.gg/moneyscripts" target="_blank">Ask on Discord</a>
    </div>
  </div>
</div>

<script>
// --- Config ---
var CHECKOUT_WORKER_URL = 'https://moneyscripts-stripe.pamelalunaescuela.workers.dev';
// TODO: replace with the real Google OAuth Client ID once created (safe to expose, it's public).
var GOOGLE_CLIENT_ID = '308338292645-4u30h18t29b9nacbdusd43fivcl2bf47.apps.googleusercontent.com';

var activeProduct = null;
var APP_URLS = {
  mobile: 'https://moneyscripts.shop/robloxapp/',
  headless: 'https://moneyscripts.shop/headless/',
  cashapp: 'https://moneyscripts.shop/cashapp/',
  phantom: 'https://moneyscripts.shop/phantom/',
  exodus: 'https://moneyscripts.shop/walletui/',
  paypal: 'https://moneyscripts.shop/paypal/',
};
var BUNDLE_PRODUCTS = ['megapack']; // owns no single URL — just unlocks other products
var ownedProducts = [];

// --- Google Sign-In ---
function getSessionToken(){ return localStorage.getItem('ms_session'); }
function getStoredUser(){
  try{ return JSON.parse(localStorage.getItem('ms_user') || 'null'); }catch(e){ return null; }
}

function initGoogleSignIn(){
  if(GOOGLE_CLIENT_ID.indexOf('REPLACE_ME') !== -1) return;
  if(typeof google === 'undefined' || !google.accounts) return;
  google.accounts.id.initialize({ client_id: GOOGLE_CLIENT_ID, callback: handleGoogleSignIn });
  var navBtn = document.getElementById('gSignInBtn');
  if(navBtn) google.accounts.id.renderButton(navBtn, { theme: 'filled_black', size: 'medium', shape: 'pill', text: 'signin' });
  var modalBtn = document.getElementById('gSignInBtnModal');
  if(modalBtn) google.accounts.id.renderButton(modalBtn, { theme: 'filled_black', size: 'medium', shape: 'pill', text: 'signin' });
  var redeemBtn = document.getElementById('gSignInBtnRedeem');
  if(redeemBtn) google.accounts.id.renderButton(redeemBtn, { theme: 'filled_black', size: 'medium', shape: 'pill', text: 'signin' });
  updateAuthUI();
}

async function handleGoogleSignIn(response){
  try{
    var res = await fetch(CHECKOUT_WORKER_URL + '/auth/google', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id_token: response.credential })
    });
    var data = await res.json();
    if(!res.ok || !data.session){
      alert(data.error || 'Could not sign in with Google. Try again.');
      return;
    }
    localStorage.setItem('ms_session', data.session);
    localStorage.setItem('ms_user', JSON.stringify({ email: data.email, name: data.name, picture: data.picture }));
    updateAuthUI();
  }catch(err){
    alert('Could not reach the sign-in server. Try again in a moment.');
  }
}

async function signOut(){
  if(!confirm('¿Quieres cerrar sesión?')) return;
  var token = getSessionToken();
  localStorage.removeItem('ms_session');
  localStorage.removeItem('ms_user');
  updateAuthUI();
  if(token){
    try{
      await fetch(CHECKOUT_WORKER_URL + '/auth/signout', {
        method: 'POST',
        headers: { 'Authorization': 'Bearer ' + token }
      });
    }catch(e){}
  }
}

function updateAuthUI(){
  var user = getStoredUser();
  var signedOut = document.getElementById('authSignedOut');
  var signedIn = document.getElementById('authSignedIn');
  if(user && getSessionToken()){
    signedOut.classList.add('hidden');
    signedIn.classList.remove('hidden');
    document.getElementById('authAvatar').src = user.picture || '';
    document.getElementById('authName').textContent = user.name || user.email || '';
  }else{
    signedOut.classList.remove('hidden');
    signedIn.classList.add('hidden');
  }
  refreshCheckoutAuthGate();
  refreshRedeemAuthGate();
  refreshOwnedProducts();
}

async function refreshOwnedProducts(){
  var token = getSessionToken();
  if(!token){ ownedProducts = []; applyOwnedButtons(); return; }
  try{
    var res = await fetch(CHECKOUT_WORKER_URL + '/me', { headers: { Authorization: 'Bearer ' + token } });
    if(!res.ok){ ownedProducts = []; applyOwnedButtons(); return; }
    var data = await res.json();
    ownedProducts = data.products || [];
  }catch(e){
    ownedProducts = [];
  }
  applyOwnedButtons();
}

function applyOwnedButtons(){
  document.querySelectorAll('[data-product]').forEach(function(btn){
    var product = btn.dataset.product;
    if(ownedProducts.indexOf(product) !== -1){
      btn.textContent = (BUNDLE_PRODUCTS.indexOf(product) !== -1) ? 'Active' : 'Open';
      btn.dataset.owned = '1';
    }else{
      btn.textContent = btn.dataset.label;
      btn.dataset.owned = '0';
    }
  });
}

function handleAppCta(btn){
  var product = btn.dataset.product;
  if(btn.dataset.owned === '1' && BUNDLE_PRODUCTS.indexOf(product) !== -1){
    return;
  }
  if(btn.dataset.owned === '1' && APP_URLS[product]){
    window.MS_REQUIRED_PRODUCT = product;
    if(typeof window.MS_showOnboarding === 'function'){
      window.MS_showOnboarding(function(){ window.location.href = APP_URLS[product]; });
    }else{
      window.location.href = APP_URLS[product];
    }
    return;
  }
  openCheckout(btn.dataset.name, btn.dataset.price, product);
}

function refreshCheckoutAuthGate(){
  var gate = document.getElementById('checkoutAuthGate');
  var authed = document.getElementById('checkoutAuthed');
  if(!gate || !authed) return;
  if(getSessionToken()){
    gate.classList.add('hidden');
    authed.classList.remove('hidden');
  }else{
    gate.classList.remove('hidden');
    authed.classList.add('hidden');
  }
}

function refreshRedeemAuthGate(){
  var gate = document.getElementById('redeemAuthGate');
  var authed = document.getElementById('redeemAuthed');
  if(!gate || !authed) return;
  if(getSessionToken()){
    gate.classList.add('hidden');
    authed.classList.remove('hidden');
  }else{
    gate.classList.remove('hidden');
    authed.classList.add('hidden');
  }
}

async function redeemCode(){
  var input = document.getElementById('redeemCodeInput');
  var result = document.getElementById('redeemResult');
  var btn = document.getElementById('redeemBtn');
  var code = input.value.trim();
  if(!code){ result.textContent = 'Enter a code first.'; result.className = 'redeem-result err'; return; }

  var token = getSessionToken();
  if(!token){ result.textContent = 'Sign in with Google first.'; result.className = 'redeem-result err'; return; }

  btn.disabled = true;
  result.textContent = 'Redeeming...';
  result.className = 'redeem-result';

  try{
    var res = await fetch(CHECKOUT_WORKER_URL + '/redeem', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token },
      body: JSON.stringify({ code: code })
    });
    var data = await res.json();
    if(!res.ok || !data.ok){
      result.textContent = data.error || 'Could not redeem that code.';
      result.className = 'redeem-result err';
      return;
    }
    result.textContent = 'Unlocked ' + data.product + ' for ' + data.hours + ' hour' + (data.hours == 1 ? '' : 's') + '!';
    result.className = 'redeem-result ok';
    input.value = '';
    refreshOwnedProducts();
  }catch(err){
    result.textContent = 'Could not reach the server. Try again in a moment.';
    result.className = 'redeem-result err';
  }finally{
    btn.disabled = false;
  }
}

function openCheckout(name, price, product){
  document.getElementById('checkoutTitle').textContent = 'Get ' + name;
  document.getElementById('checkoutPrice').textContent = price;
  activeProduct = product;

  var check = document.getElementById('checkoutConfirm');
  check.checked = false;
  document.getElementById('checkoutLocked').classList.remove('hidden');
  document.getElementById('checkoutFormWrap').classList.add('hidden');
  resetPayBtn();
  hideFormError();
  refreshCheckoutAuthGate();

  document.getElementById('checkoutOverlay').classList.add('open');
}
function closeCheckout(){ document.getElementById('checkoutOverlay').classList.remove('open'); }
document.getElementById('checkoutOverlay').addEventListener('click', function(e){
  if(e.target === document.getElementById('checkoutOverlay')) closeCheckout();
});

function onConfirmToggle(checked){
  if(!checked){
    document.getElementById('checkoutLocked').classList.remove('hidden');
    document.getElementById('checkoutFormWrap').classList.add('hidden');
    return;
  }
  document.getElementById('checkoutLocked').classList.add('hidden');
  document.getElementById('checkoutFormWrap').classList.remove('hidden');
}

function showFormError(msg){
  var el = document.getElementById('checkoutFormError');
  el.textContent = msg;
  el.classList.remove('hidden');
}
function hideFormError(){
  document.getElementById('checkoutFormError').classList.add('hidden');
}
function resetPayBtn(){
  var btn = document.getElementById('checkoutPayBtn');
  btn.disabled = false;
  btn.textContent = 'Continue to secure payment';
}

async function goToPayment(){
  if(CHECKOUT_WORKER_URL.indexOf('REPLACE-ME') !== -1){
    showFormError('Payments are not configured yet. Ask on Discord for now.');
    return;
  }
  hideFormError();
  var btn = document.getElementById('checkoutPayBtn');
  btn.disabled = true;
  btn.textContent = 'Loading…';
  try{
    var token = getSessionToken();
    if(!token){
      showFormError('Please sign in with Google first.');
      resetPayBtn();
      refreshCheckoutAuthGate();
      return;
    }
    var res = await fetch(CHECKOUT_WORKER_URL + '/create-checkout-session', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token },
      body: JSON.stringify({ product: activeProduct })
    });
    var data = await res.json();
    if(!res.ok || !data.url){
      showFormError(data.error || 'Could not start checkout. Try again in a moment.');
      resetPayBtn();
      return;
    }
    window.location.href = data.url;
  }catch(err){
    showFormError('Could not reach the payment server. Try again in a moment.');
    resetPayBtn();
  }
}

var activeFilter = 'all';
function setFilter(f){
  activeFilter = f;
  document.querySelectorAll('.pill').forEach(function(p){ p.classList.toggle('active', p.dataset.filter === f); });
  applyFilters();
}
function filterApps(){ applyFilters(); }
function applyFilters(){
  var q = document.getElementById('searchInput').value.trim().toLowerCase();
  document.querySelectorAll('.app-card').forEach(function(card){
    var matchesTag = activeFilter === 'all' || card.dataset.tags.split(' ').indexOf(activeFilter) !== -1;
    var matchesSearch = !q || card.dataset.name.indexOf(q) !== -1;
    card.classList.toggle('hidden', !(matchesTag && matchesSearch));
  });
}

// --- Hero balance display: never sits still. The cents keep ticking like a
// live counter, and every few seconds the whole number slot-flickers into a
// new absurd fake balance. Purely decorative.
var heroBalanceEl = document.getElementById('heroBalance');
var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
var heroRolling = false;
function formatHeroBalance(n){
  return '$' + n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
function rollHeroBalance(){
  if(!heroBalanceEl) return;
  var target = 800 + Math.floor(Math.random() * 4000000);
  var targetStr = formatHeroBalance(target);
  if(reduceMotion){ heroBalanceEl.textContent = targetStr; return; }
  heroRolling = true;
  var frame = 0, frames = 16;
  var iv = setInterval(function(){
    frame++;
    if(frame >= frames){
      clearInterval(iv);
      heroBalanceEl.textContent = targetStr;
      heroRolling = false;
      return;
    }
    heroBalanceEl.textContent = targetStr.replace(/[0-9]/g, function(){ return Math.floor(Math.random() * 10); });
  }, 45);
}
function tickHeroCents(){
  if(!heroBalanceEl || reduceMotion || heroRolling) return;
  heroBalanceEl.textContent = heroBalanceEl.textContent.replace(/(\d{2})$/, function(){
    return String(Math.floor(Math.random() * 100)).padStart(2, '0');
  });
}
rollHeroBalance();
if(!reduceMotion){
  setInterval(rollHeroBalance, 4000);
  setInterval(tickHeroCents, 150);
}

updateAuthUI();
</script>
<script src="https://accounts.google.com/gsi/client" async defer onload="initGoogleSignIn()"></script>
</body>
</html>
