<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0"><link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon-32.png"><link rel="icon" type="image/png" sizes="16x16" href="/assets/favicon-16.png"><link rel="apple-touch-icon" href="/assets/apple-touch-icon.png"><meta property="og:title" content="Plotmor"><meta property="og:image" content="/assets/og-image.png"><meta name="theme-color" content="#ffd60a">
<title>Plotmor — Lua Protection System</title>
<meta name="theme-color" content="#0a0908">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="icon" href="/favicon.ico">
<link rel="manifest" href="/site.webmanifest">
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500;600;700&family=Sora:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500;600;700&family=Sora:wght@400;500;600;700;800&display=swap');

:root{
  --bg:#070608;
  --bg2:#0b0a0d;
  --panel:#111016;
  --panel2:#17151d;
  --line:rgba(255,255,255,.08);
  --line2:rgba(255,255,255,.14);
  --gold:#ffd60a;
  --amber:#e0b400;
  --violet:#c7c7c7;
  --violet2:#e0e0e0;
  --cyan:#dcdcdc;
  --ink:#f8f6f2;
  --mute:#9b94a8;
  --mute2:#6b6478;
  --ok:#e6e6e6;
  --bad:#8a8a8a;
  --mono:'JetBrains Mono','Courier New',monospace;
  --radius:16px;
  --radius-lg:22px;
  --shadow-sm:0 2px 10px rgba(0,0,0,.25);
  --shadow-md:0 16px 48px rgba(0,0,0,.45);
  --shadow-glow:0 0 60px rgba(255,212,0,.18);
  --grad-gold:linear-gradient(135deg,#ffe14d 0%,#ffd60a 55%,#d9ac00 100%);
  --grad-violet:linear-gradient(135deg,#ededed 0%,#c7c7c7 55%,#a3a3a3 100%);
  --grad-mesh:radial-gradient(1200px 700px at 85% -10%,rgba(255,255,64,.14),transparent 55%),radial-gradient(900px 600px at -5% 20%,rgba(255,255,246,.12),transparent 55%),radial-gradient(700px 500px at 50% 110%,rgba(255,255,238,.06),transparent 60%);
}
*{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{
  font-family:'Inter','Sora','Segoe UI',system-ui,sans-serif;
  background:var(--bg);color:var(--ink);line-height:1.65;min-height:100vh;
  background-image:var(--grad-mesh);background-repeat:no-repeat;background-attachment:fixed;
  -webkit-font-smoothing:antialiased;letter-spacing:-.01em;
}
a{color:inherit;text-decoration:none}
button,input,textarea{font-family:inherit}
:focus-visible{outline:2px solid var(--gold);outline-offset:3px;border-radius:4px}
::selection{background:rgba(255,255,64,.3);color:#fff}
::-webkit-scrollbar{width:10px;height:10px}
::-webkit-scrollbar-track{background:var(--bg)}
::-webkit-scrollbar-thumb{background:var(--line2);border-radius:99px}
::-webkit-scrollbar-thumb:hover{background:var(--mute2)}
.wrap{width:min(1180px,calc(100% - 32px));margin:0 auto}

/* ===== NAV ===== */
.nav{position:sticky;top:0;z-index:50;background:rgba(7,6,8,.72);backdrop-filter:blur(20px) saturate(140%);border-bottom:1px solid var(--line)}
.nav-in{display:flex;align-items:center;gap:28px;height:68px}
.brand{display:flex;align-items:center;gap:11px;font-weight:800;font-size:19px;letter-spacing:-.4px;font-family:'Sora',sans-serif}
.brand i{width:34px;height:34px;border-radius:10px;display:grid;place-items:center;font-style:normal;font-size:17px;background:var(--grad-gold);color:#1a1100;box-shadow:0 4px 18px rgba(220,220,30,.35);font-weight:800}
.nav-links{display:flex;gap:2px;margin-left:8px;flex:1}
.nav-links a{padding:9px 15px;border-radius:10px;font-size:14px;color:var(--mute);font-weight:500;transition:color .18s,background .18s;position:relative}
.nav-links a:hover{color:var(--ink);background:rgba(255,255,255,.05)}
.nav-links a.on{color:var(--gold);background:rgba(255,255,64,.08)}
.nav-right{display:flex;align-items:center;gap:12px}
.avatar{width:33px;height:33px;border-radius:50%;border:2px solid var(--line2);box-shadow:0 2px 10px rgba(0,0,0,.3)}
.burger{display:none;background:none;border:1px solid var(--line2);color:var(--ink);width:40px;height:40px;border-radius:11px;font-size:18px;cursor:pointer;transition:border-color .15s}
.burger:hover{border-color:var(--gold)}
@media(max-width:860px){
 .burger{display:block;margin-left:auto}
 .nav-links{display:none;position:absolute;top:68px;left:0;right:0;flex-direction:column;background:var(--bg2);border-bottom:1px solid var(--line);padding:10px 16px 16px;margin:0;box-shadow:var(--shadow-md)}
 .nav-links.open{display:flex}
 .nav-right .uname{display:none}
 .nav-right{margin-left:0}
}

/* ===== BUTTONS ===== */
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:13px 22px;border-radius:12px;font-weight:700;font-size:14px;border:1px solid transparent;cursor:pointer;transition:transform .18s cubic-bezier(.2,.8,.2,1),filter .18s,background .18s,box-shadow .18s;white-space:nowrap;letter-spacing:-.1px}
.btn:hover{transform:translateY(-2px)}
.btn:active{transform:translateY(0)}
.btn:disabled{opacity:.5;cursor:not-allowed;transform:none}
.btn-gold{background:var(--grad-gold);color:#1a1100;box-shadow:0 10px 30px rgba(220,220,30,.28),inset 0 1px 0 rgba(255,255,255,.3)}
.btn-gold:hover{filter:brightness(1.07);box-shadow:0 14px 36px rgba(220,220,30,.4)}
.btn-ghost{background:rgba(255,255,255,.03);border-color:var(--line2);color:var(--ink);backdrop-filter:blur(8px)}
.btn-ghost:hover{background:rgba(255,255,255,.07);border-color:var(--gold)}
.btn-discord{background:#5865F2;color:#fff;box-shadow:0 10px 26px rgba(88,101,242,.3)}
.btn-discord:hover{filter:brightness(1.1)}
.btn-sm{padding:9px 15px;font-size:13px;border-radius:10px}
.btn-block{width:100%}
.badge{display:inline-flex;align-items:center;gap:6px;padding:5px 13px;border-radius:999px;font-size:12px;font-weight:700;letter-spacing:.1px}
.badge.prem{background:var(--grad-gold);color:#1a1100;box-shadow:0 4px 14px rgba(220,220,30,.3)}
.badge.free{background:rgba(255,255,255,.05);border:1px solid var(--line2);color:var(--mute)}

/* ===== HERO ===== */
.hero{padding:96px 0 72px;display:grid;grid-template-columns:1.05fr .95fr;gap:52px;align-items:center}
.hero h1{font-family:'Sora',sans-serif;font-size:clamp(36px,5.2vw,62px);line-height:1.06;letter-spacing:-2px;font-weight:800}
.hero h1 em{font-style:normal;background:var(--grad-gold);-webkit-background-clip:text;background-clip:text;color:transparent}
.hero p.lead{margin-top:22px;color:var(--mute);font-size:17.5px;max-width:530px;line-height:1.7}
.hero-cta{margin-top:32px;display:flex;gap:12px;flex-wrap:wrap}
.hero-stats{margin-top:42px;display:flex;gap:36px;flex-wrap:wrap}
.hero-stats b{display:block;font-size:28px;letter-spacing:-.8px;font-family:'Sora',sans-serif;background:linear-gradient(135deg,#fff,#c8c2d4);-webkit-background-clip:text;background-clip:text;color:transparent}
.hero-stats span{font-size:13px;color:var(--mute2);font-weight:500}
@media(max-width:860px){.hero{grid-template-columns:1fr;padding:52px 0 40px;gap:36px}}

.term{border:1px solid var(--line2);border-radius:var(--radius-lg);background:#0a090c;box-shadow:var(--shadow-md),0 0 0 1px rgba(255,255,64,.06),var(--shadow-glow);overflow:hidden;position:relative}
.term::before{content:"";position:absolute;inset:0;background:linear-gradient(160deg,rgba(255,255,64,.04),transparent 40%);pointer-events:none}
.term-bar{display:flex;align-items:center;gap:7px;padding:13px 17px;border-bottom:1px solid var(--line);background:var(--panel)}
.term-bar s{width:10px;height:10px;border-radius:50%;background:var(--line2);text-decoration:none}
.term-bar span{margin-left:8px;font-size:12px;color:var(--mute2);font-family:var(--mono)}
.term-body{padding:22px 19px;font-family:var(--mono);font-size:12.5px;line-height:2;overflow-x:auto}
.term-body .c{color:#5f5870}
.term-body .k{color:var(--gold)}
.term-body .s{color:#8fe3c4;white-space:pre-wrap;word-break:break-all}
.term-body .ok{color:var(--ok)}
.term-body .ln{display:block;opacity:0;animation:ln .4s forwards}
.term-body .ln:nth-child(1){animation-delay:.2s}.term-body .ln:nth-child(2){animation-delay:.5s}.term-body .ln:nth-child(3){animation-delay:.8s}
.term-body .ln:nth-child(4){animation-delay:1.3s}.term-body .ln:nth-child(5){animation-delay:1.7s}.term-body .ln:nth-child(6){animation-delay:2.1s}.term-body .ln:nth-child(7){animation-delay:2.5s}
@keyframes ln{to{opacity:1}}

.section{padding:80px 0;border-top:1px solid var(--line);position:relative}
.section h2{font-family:'Sora',sans-serif;font-size:clamp(28px,3.6vw,40px);letter-spacing:-1.2px;line-height:1.15;font-weight:800}
.section .sub{color:var(--mute);margin-top:14px;max-width:580px;font-size:15.5px}
.split{display:grid;grid-template-columns:.8fr 1.2fr;gap:60px}
@media(max-width:860px){.split{grid-template-columns:1fr;gap:28px}}
.rows>div{padding:22px 0;border-bottom:1px solid var(--line)}
.rows>div:first-child{padding-top:0}
.rows h3{font-size:16.5px;font-weight:700;display:flex;align-items:center;gap:10px}
.rows h3::before{content:"";width:6px;height:6px;border-radius:50%;background:var(--grad-gold);flex-shrink:0}
.rows p{color:var(--mute);font-size:14px;margin-top:6px;margin-left:16px}
.steps{display:grid;grid-template-columns:repeat(3,1fr);gap:22px;margin-top:40px;counter-reset:s}
.steps>div{padding:26px;border:1px solid var(--line);border-radius:var(--radius);background:var(--panel);counter-increment:s;transition:border-color .2s,transform .2s,box-shadow .2s;position:relative;overflow:hidden}
.steps>div:hover{border-color:rgba(255,255,64,.35);transform:translateY(-3px);box-shadow:var(--shadow-md)}
.steps>div::before{content:counter(s);display:grid;place-items:center;width:32px;height:32px;border-radius:10px;background:var(--grad-gold);color:#1a1100;font-weight:800;font-size:14px;margin-bottom:16px;box-shadow:0 6px 18px rgba(220,220,30,.3)}
.steps h3{font-size:16.5px;font-family:'Sora',sans-serif}.steps p{color:var(--mute);font-size:14px;margin-top:8px}
@media(max-width:860px){.steps{grid-template-columns:1fr}}
.cta-band{margin:0 0 80px;padding:48px 36px;border-radius:24px;border:1px solid rgba(255,255,64,.25);background:linear-gradient(135deg,rgba(255,255,64,.1),rgba(255,255,246,.05));display:flex;align-items:center;justify-content:space-between;gap:26px;flex-wrap:wrap;position:relative;overflow:hidden}
.cta-band::before{content:"";position:absolute;top:-50%;right:-10%;width:300px;height:300px;background:radial-gradient(circle,rgba(255,255,64,.15),transparent 70%);pointer-events:none}
.cta-band h2{font-family:'Sora',sans-serif;font-size:27px;letter-spacing:-.8px}
.cta-band p{color:var(--mute);margin-top:8px}

.page-head{padding:68px 0 30px}
.page-head h1{font-family:'Sora',sans-serif;font-size:clamp(32px,4.6vw,48px);letter-spacing:-1.6px;font-weight:800}
.page-head p{color:var(--mute);margin-top:12px;max-width:580px;font-size:15.5px}
.plans{display:grid;grid-template-columns:1fr 1fr;gap:22px;margin-top:30px}
@media(max-width:760px){.plans{grid-template-columns:1fr}}
.plan{padding:32px;border-radius:var(--radius-lg);border:1px solid var(--line);background:var(--panel);position:relative;transition:transform .2s,border-color .2s}
.plan:hover{transform:translateY(-3px)}
.plan.prem{border-color:rgba(255,255,64,.5);background:linear-gradient(165deg,#1d170d,#120f0f 60%);box-shadow:0 0 70px rgba(255,255,64,.1)}
.plan h3{font-size:21px;display:flex;align-items:center;gap:10px;font-family:'Sora',sans-serif}
.price{margin:16px 0 4px;font-size:36px;font-weight:800;letter-spacing:-1.2px;font-family:'Sora',sans-serif}
.price small{font-size:14px;color:var(--mute);font-weight:500;letter-spacing:0}
.plan .note{color:var(--mute);font-size:13px;min-height:20px}
.plan ul{list-style:none;margin:24px 0 28px}
.plan li{padding:10px 0 10px 28px;position:relative;font-size:14px;border-bottom:1px solid rgba(255,255,255,.04)}
.plan li:last-child{border-bottom:none}
.plan li::before{content:"✓";position:absolute;left:0;color:var(--ok);font-weight:800}
.plan li.no{color:var(--mute2)}
.plan li.no::before{content:"✕";color:var(--bad)}
.plan code{font-family:var(--mono);font-size:12px;background:rgba(255,255,64,.1);border:1px solid rgba(255,255,64,.22);color:var(--gold);padding:2px 7px;border-radius:6px}
.buy{margin-top:60px;display:grid;grid-template-columns:1fr 1fr;gap:22px}
@media(max-width:760px){.buy{grid-template-columns:1fr}}
.box{padding:28px;border:1px solid var(--line);border-radius:var(--radius-lg);background:var(--panel);transition:border-color .2s}
.box:hover{border-color:var(--line2)}
.box h3{font-size:17.5px;margin-bottom:14px;font-family:'Sora',sans-serif}
.box ol{padding-left:20px;color:var(--mute);font-size:14px}
.box ol li{padding:6px 0}
.box ol b{color:var(--ink)}
.faq details{border-bottom:1px solid var(--line);padding:17px 0}
.faq summary{cursor:pointer;font-weight:600;list-style:none;display:flex;justify-content:space-between;gap:12px;transition:color .15s}
.faq summary:hover{color:var(--gold)}
.faq summary::after{content:"+";color:var(--gold);font-size:20px;line-height:1;transition:transform .2s}
.faq details[open] summary::after{content:"–"}
.faq p{color:var(--mute);font-size:14px;margin-top:11px;max-width:680px}

.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px;margin:34px 0 8px}
.stat{padding:20px 22px;border:1px solid var(--line);border-radius:var(--radius);background:var(--panel);transition:border-color .18s,transform .18s,box-shadow .18s}
.stat:hover{border-color:var(--line2);transform:translateY(-2px);box-shadow:var(--shadow-sm)}
.stat b{display:block;font-size:27px;letter-spacing:-.7px;font-family:'Sora',sans-serif}
.stat span{font-size:13px;color:var(--mute2)}
.meter{height:6px;border-radius:99px;background:var(--line);margin-top:11px;overflow:hidden}
.meter i{display:block;height:100%;background:var(--grad-gold);border-radius:99px}
.h-row{display:flex;align-items:center;gap:14px;margin:48px 0 18px}
.h-row h2{font-size:20px;letter-spacing:-.5px;font-family:'Sora',sans-serif}
.h-row .ln{flex:1;height:1px;background:var(--line)}
.alert{padding:15px 19px;border-radius:14px;border:1px solid rgba(160,160,102,.3);background:rgba(160,160,102,.06);font-size:14px;margin-bottom:17px;display:flex;gap:12px;align-items:center;justify-content:space-between;flex-wrap:wrap}
.alert.gold{border-color:rgba(255,255,64,.3);background:rgba(255,255,64,.06)}
.form{padding:26px;border:1px solid var(--line);border-radius:var(--radius-lg);background:var(--panel);display:grid;grid-template-columns:1fr 1fr;gap:13px}
@media(max-width:700px){.form{grid-template-columns:1fr}}
input,textarea{width:100%;border:1px solid var(--line2);border-radius:11px;background:#0d0b0f;color:var(--ink);padding:14px 15px;font-size:14px;transition:border-color .15s,box-shadow .15s}
input:focus,textarea:focus{border-color:var(--gold);outline:none;box-shadow:0 0 0 3px rgba(255,255,64,.1)}
textarea{grid-column:1/-1;min-height:175px;resize:vertical;font-family:var(--mono);font-size:12.5px}
.file-row{display:flex;align-items:center;gap:12px;flex-wrap:wrap}
.file-row label{cursor:pointer}
.file-row span{color:var(--mute);font-size:13px}
.form .btn{grid-column:1/-1}
input[type=file]{display:none}
.scripts{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:15px}
.sc{position:relative;display:flex;align-items:center;justify-content:space-between;gap:10px;padding:18px;border:1px solid var(--line);border-radius:var(--radius);background:var(--panel);transition:border-color .18s,box-shadow .18s,transform .18s}
.sc:hover{border-color:var(--line2);transform:translateY(-2px);box-shadow:var(--shadow-sm)}
.sc-info{display:flex;align-items:center;gap:13px;min-width:0}
.sc-ic{width:44px;height:44px;border-radius:12px;display:grid;place-items:center;background:var(--grad-gold);font-size:20px;flex-shrink:0;box-shadow:0 6px 18px rgba(220,220,30,.28)}
.sc-name{font-weight:700;font-size:15px;max-width:170px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-family:'Sora',sans-serif}
.sc-st{font-size:12px;font-weight:600}
.sc-st.on{color:var(--ok)}.sc-st.off{color:var(--bad)}
.sc-up{font-size:11px;color:var(--mute2)}
.dots{width:36px;height:36px;border:1px solid var(--line2);border-radius:10px;background:transparent;color:var(--gold);font-size:20px;cursor:pointer;transition:background .15s}
.dots:hover{background:rgba(255,255,64,.08)}
.menu{display:none;position:absolute;right:12px;top:60px;z-index:20;width:200px;padding:6px;border:1px solid var(--line2);border-radius:var(--radius);background:var(--panel2);box-shadow:var(--shadow-md)}
.menu.show{display:block}
.menu button{display:block;width:100%;text-align:left;padding:11px 13px;border:none;border-radius:9px;background:transparent;color:var(--ink);font-size:13px;cursor:pointer;transition:background .15s,color .15s}
.menu button:hover{background:rgba(255,255,255,.06);color:var(--gold)}
.menu .del{color:var(--bad)}
.empty{padding:48px 20px;text-align:center;color:var(--mute);border:1px dashed var(--line2);border-radius:var(--radius-lg);font-size:14px}
.modal-bg{display:none;position:fixed;inset:0;z-index:200;background:rgba(5,4,6,.78);backdrop-filter:blur(6px);align-items:center;justify-content:center;padding:16px}
.modal-bg.show{display:flex}
.modal{width:100%;max-width:760px;max-height:90vh;overflow-y:auto;padding:28px;border:1px solid var(--line2);border-radius:var(--radius-lg);background:var(--panel);box-shadow:var(--shadow-md)}
.modal h3{font-size:18.5px;margin-bottom:17px;font-family:'Sora',sans-serif}
.modal label.l{display:block;font-size:12px;color:var(--mute);margin:12px 0 6px}
.modal textarea{min-height:300px}
.modal-act{display:flex;gap:10px;margin-top:17px}
.modal-act .btn{flex:1}

.center{min-height:calc(100vh - 68px);display:grid;place-items:center;padding:32px 0}
.card{width:min(460px,100%);padding:38px 32px;border:1px solid var(--line2);border-radius:var(--radius-lg);background:var(--panel);box-shadow:var(--shadow-md);position:relative;overflow:hidden}
.card::before{content:"";position:absolute;inset:0 0 auto 0;height:1px;background:linear-gradient(90deg,transparent,rgba(255,255,64,.5),transparent)}
.card::after{content:"";position:absolute;top:-30%;left:50%;transform:translateX(-50%);width:260px;height:260px;background:radial-gradient(circle,rgba(255,255,64,.08),transparent 70%);pointer-events:none}
.card h1{font-size:27px;letter-spacing:-1px;font-family:'Sora',sans-serif}
.card p{color:var(--mute);font-size:14px;margin-top:9px}
.card .stack{display:grid;gap:12px;margin-top:24px}
.kv{margin-top:20px;border:1px solid var(--line);border-radius:14px;overflow:hidden}
.kv div{display:flex;justify-content:space-between;gap:12px;padding:12px 15px;font-size:13px;border-bottom:1px solid var(--line)}
.kv div:last-child{border-bottom:none}
.kv span{color:var(--mute)}
.code{margin-top:17px;padding:15px;border:1px solid var(--line2);border-radius:13px;background:#0a090c;font-family:var(--mono);font-size:12.5px;color:var(--gold);white-space:pre-wrap;word-break:break-all;text-align:left}
.mono{font-family:var(--mono);letter-spacing:.5px}

.foot{border-top:1px solid var(--line);padding:38px 0;margin-top:24px}
.foot-in{display:flex;justify-content:space-between;align-items:center;gap:16px;flex-wrap:wrap;color:var(--mute2);font-size:13px}
.foot-in nav{display:flex;gap:20px}
.foot-in a:hover{color:var(--gold)}
.toast{position:fixed;left:50%;bottom:30px;transform:translate(-50%,24px);opacity:0;z-index:999;padding:13px 22px;border-radius:13px;font-size:14px;font-weight:600;background:var(--panel2);border:1px solid var(--line2);transition:all .3s cubic-bezier(.2,.8,.2,1);max-width:calc(100% - 32px);box-shadow:var(--shadow-md)}
.toast.show{opacity:1;transform:translate(-50%,0)}
.toast.ok{border-color:rgba(52,224,122,.5)}.toast.err{border-color:rgba(160,160,102,.5)}

@media(prefers-reduced-motion:reduce){*{animation:none!important;transition:none!important}.term-body .ln{opacity:1}}
  @keyframes pmRise{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}
  main>*{animation:pmRise .55s ease both}
  main>*:nth-child(2){animation-delay:.08s}main>*:nth-child(3){animation-delay:.16s}main>*:nth-child(4){animation-delay:.22s}
  .cards>div{transition:transform .25s ease,border-color .25s ease,box-shadow .25s ease}
  .cards>div:hover{transform:translateY(-4px);border-color:#454545;box-shadow:0 12px 36px rgba(0,0,0,.5)}
  header{position:sticky;top:0;z-index:50;background:rgba(7,7,10,.78);backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px)}
  .cta{transition:transform .2s ease,box-shadow .2s ease}
  .cta:hover{transform:translateY(-2px);box-shadow:0 8px 30px rgba(255,255,255,.08)}
  a{transition:color .2s ease}
  @media (prefers-reduced-motion:reduce){*{animation:none!important;transition:none!important}}
</style>
</head>
<body>
<header class="nav"><div class="wrap nav-in">
  <a class="brand" href="/"><img src="/assets/mark.png" alt="Plotmor" style="width:26px;height:26px;border-radius:8px">Plotmor</a>
  <button class="burger" onclick="toggleNav()" aria-label="Menu">☰</button>
  <nav class="nav-links" id="navLinks">
    <a href="/" class="on">Home</a>
    <a href="/#features">Features</a>
    
    <a href="/redeem">Redeem Key</a>
    
    <a href="/dashboard">Dashboard</a>
    <a href="/obf">Obfuscator</a>
    <a href="/badge">Badge</a>
    
    
    
  </nav>
  <div class="nav-right"><a class="btn btn-gold btn-sm" href="/login">Login</a></div>
</div></header>

<main class="wrap">
  <section class="hero">
    <div>
      <div class="badge free" style="margin-bottom:18px;border-color:rgba(255,255,64,.3);color:var(--gold)">⚡ Trusted by Roblox script sellers</div>
      <h1>Ship your Lua scripts behind a <em>key and a lock</em>.</h1>
      <p class="lead">Plotmor keeps your source on the server, hands it only to buyers with a valid key, and binds every key to one device. You manage it all from Discord.</p>
      <div class="hero-cta">
        <a class="btn btn-gold" href="/login">Get started free</a>
        <a class="btn btn-ghost" href="/pricing">See pricing</a>
        
      </div>
      <div class="hero-stats">
        <div><b>90</b><span>scripts protected</span></div>
        <div><b>62</b><span>developers</span></div>
        <div><b>500</b><span>keys issued</span></div>
        <div><b>306</b><span>Discord servers</span></div>
      </div>
    </div>
    <div class="term" aria-label="Example loader session">
      <div class="term-bar"><s></s><s></s><s></s><span>executor</span></div>
      <div class="term-body">
        <span class="ln"><span class="c">-- what your buyer runs</span></span>
        <span class="ln"><span class="k">script_key</span> = <span class="s">"YOUR_KEY"</span></span>
        <span class="ln"><span class="k">loadstring</span>(game:<span class="k">HttpGet</span>(<span class="s">"https://ghost.pages.dev/api/loader/3fa9…e1.lua"</span>))()</span>
        <span class="ln"><span class="c">-- server side</span></span>
        <span class="ln"><span class="ok">✓</span> key valid, not expired</span>
        <span class="ln"><span class="ok">✓</span> HWID matches the bound device</span>
        <span class="ln"><span class="ok">✓</span> source delivered, webhook sent</span>
      </div>
    </div>
  </section>

  <section class="section" id="features">
    <div class="split">
      <div>
        <h2>Everything a script seller needs, nothing they don't.</h2>
        <p class="sub">Upload once on the web, then sell and support from your Discord server.</p>
      </div>
      <div class="rows">
        <div><h3>Source stays on the server</h3><p>Buyers load your script through a protected loader. They never get the raw file.</p></div>
        <div><h3>Keys and HWID lock</h3><p>Every key binds to the first device that uses it. Wrong device, expired key, or no key and the player is kicked.</p></div>
        <div><h3>Discord control panel</h3><p>Post a panel with Redeem Key, Get Script, Get Role and Stats buttons. Whitelist users or whole roles with a slash command.</p></div>
        <div><h3>Execution webhooks</h3><p>Get a Discord message every time your script runs: who, which key, which device.</p></div>
        <div><h3>Blacklists and free mode</h3><p>Block abusers in one command. Premium can also blacklist roles or open a script to everyone for a launch.</p></div>
        <div><h3>Self-service HWID reset</h3><p>Buyers reset their own device with a cooldown, so you stop answering the same ticket.</p></div>
      </div>
    </div>
  </section>

  <section class="section">
    <h2>From upload to first sale</h2>
    <div class="steps">
      <div><h3>Upload your script</h3><p>Log in with Discord and paste or upload your .lua file. Free accounts can protect 3 scripts.</p></div>
      <div><h3>Set up your server</h3><p>Invite the bot, run <span class="mono">/setuppanel</span>, then whitelist buyers or generate keys.</p></div>
      <div><h3>Buyers run the loader</h3><p>They press Get Script on the panel, run the loader, and the key and device checks happen automatically.</p></div>
    </div>
  </section>

  <section class="section" style="border-top:none;padding-top:0">
    <div class="cta-band">
      <div><h2>Need more room?</h2><p>Premium gives you 10 scripts, 10 panels, free mode and more. Redeem a key in seconds.</p></div>
      <div class="hero-cta" style="margin:0"><a class="btn btn-gold" href="/pricing">Compare plans</a><a class="btn btn-ghost" href="/redeem">Redeem a key</a></div>
    </div>
  </section>
</main>
<footer class="foot"><div class="wrap foot-in">
  <span>Plotmor — Lua script protection</span>
  <nav><a href="/redeem">Redeem</a><a href="/my-keys">My Keys</a><a href="/badge">Badge</a></nav>
</div></footer>
<script>
function $(i){return document.getElementById(i);}
function toast(msg,type){var t=document.createElement('div');t.className='toast '+(type||'');t.textContent=msg;document.body.appendChild(t);setTimeout(function(){t.classList.add('show');},10);setTimeout(function(){t.classList.remove('show');setTimeout(function(){t.remove();},300);},3400);}
function toggleNav(){$('navLinks').classList.toggle('open');}
async function copyText(txt){try{await navigator.clipboard.writeText(txt);toast('Copied to clipboard','ok');}catch(e){toast('Copy failed','err');}}
</script>
</body>
</html>