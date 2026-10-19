<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Project Sync — Advanced Roblox Automation Utility</title>
<meta name="description" content="Project Sync is an advanced Roblox automation utility for MM2 and Adopt Me. Auto-join servers, trade detection, real-time hit tracking and dashboard.">
<meta name="keywords" content="roblox automation, mm2 trader, adopt me automation, roblox utility, murder mystery 2, syncapp, roblox script, auto joiner">
<meta name="robots" content="index, follow">
<link rel="canonical" href="https://syncp.org/">
<meta property="og:type" content="website">
<meta property="og:url" content="https://syncp.org/">
<meta property="og:title" content="Project Sync — Advanced Roblox Automation Utility">
<meta property="og:description" content="Advanced Roblox automation utility for MM2 and Adopt Me. Auto-join servers, trade detection, real-time hit tracking and dashboard.">
<meta property="og:image" content="https://syncp.org/assets/images/ProjectSync.gif">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Project Sync — Advanced Roblox Automation Utility">
<meta name="twitter:description" content="Advanced Roblox automation utility for MM2 and Adopt Me. Auto-join servers, trade detection, real-time hit tracking and dashboard.">
<meta name="twitter:image" content="https://syncp.org/assets/images/ProjectSync.gif">
<link rel="icon" type="image/svg+xml" href='data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="%23ffffff" stroke-width="1.5"><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>'>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600&family=Geist+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/assets/css/index.css?t=1788189507">
</head>
<body>

<div class="page-bg" aria-hidden="true">
  <div class="pb-light"></div>
  <div class="pb-grid"></div>
  <div class="pb-glow-a"></div>
  <div class="pb-glow-b"></div>
</div>

<header class="hd">
  <div class="shell hd-in">
    <a href="/" class="bd">
      <span class="bd-mk">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.3 7 12 12 20.7 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg>
      </span>
      <span class="bd-nm">Project Sync</span>
    </a>
    <nav class="hd-nav">
      <a href="#games">Games</a>
      <a href="#start">Quick start</a>
      <a href="#support">Support</a>
    </nav>
    <div class="hd-r">
      <a href="https://t.me/+9yZ58HuGL0lmNmMy" class="ic" title="Telegram" aria-label="Telegram">
        <svg width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M21.94 4.3a1.2 1.2 0 0 0-1.27-.2L3.4 11.04c-.9.36-.86 1.66.06 1.96l4.34 1.4 1.66 5.06c.22.66 1.05.86 1.55.38l2.4-2.32 4.33 3.18c.55.4 1.34.1 1.49-.56l3.2-14.36a1.2 1.2 0 0 0-.5-1.2zM9.6 14.2l8.2-5.34-6.7 6.06c-.16.14-.27.35-.3.57l-.27 1.96-1-3.05a.5.5 0 0 1 .07-.2z"/></svg>
      </a>
      <a href="https://discord.gg/syncapp" class="ic" title="Discord" aria-label="Discord">
        <svg width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M19.27 5.33A16.5 16.5 0 0 0 15.2 4l-.2.4a12.5 12.5 0 0 1 3.6 1.84 14 14 0 0 0-12.2 0A12.5 12.5 0 0 1 10 4.4L9.8 4a16.5 16.5 0 0 0-4.07 1.33C3.13 9.2 2.42 12.98 2.77 16.7a16.6 16.6 0 0 0 5.05 2.55l.6-.97a10.8 10.8 0 0 1-1.7-.82l.42-.32a11.9 11.9 0 0 0 10.13 0l.42.32c-.54.32-1.11.6-1.7.82l.6.97a16.6 16.6 0 0 0 5.05-2.55c.42-4.32-.7-8.07-2.9-11.37zM9.18 14.53c-.97 0-1.77-.9-1.77-2s.78-2.01 1.77-2.01 1.78.9 1.77 2.01c0 1.1-.78 2-1.77 2zm5.64 0c-.97 0-1.77-.9-1.77-2s.78-2.01 1.77-2.01 1.78.9 1.77 2.01c0 1.1-.78 2-1.77 2z"/></svg>
      </a>
      <a href="/dashboard" class="btn btn-p">Open dashboard</a>
    </div>
  </div>
</header>

<section class="hero">
  <div class="shell hero-in">
    <div class="pill">
      <span class="ping"><i></i><b></b></span>
      <span>#1 Roblox Utility</span>
    </div>
    <h1>Project Sync</h1>
    <div class="hero-cta">
      <a href="/dashboard" class="btn btn-p btn-lg">Open dashboard</a>
      <a href="https://discord.gg/syncapp" class="btn btn-g btn-lg">Join Discord</a>
    </div>
  </div>
</section>

<main class="shell">

  <section class="sec">
    <div class="stats">
      <div class="st st-hits">
        <span class="st-ic"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg></span>
        <div class="st-body">
          <div class="st-vl">50,753</div>
          <div class="st-lb">Total hits</div>
        </div>
      </div>
      <div class="st st-users">
        <span class="st-ic"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></span>
        <div class="st-body">
          <div class="st-vl">1,006</div>
          <div class="st-lb">Active users</div>
        </div>
      </div>
      <div class="st st-earn">
        <span class="st-ic"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></span>
        <div class="st-body">
          <div class="st-vl">$30,589</div>
          <div class="st-lb">Total earned</div>
        </div>
      </div>
      <div class="st st-items">
        <span class="st-ic"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.3 7 12 12 20.7 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg></span>
        <div class="st-body">
          <div class="st-vl">77,817</div>
          <div class="st-lb">Total items</div>
        </div>
      </div>
    </div>
  </section>

  <section class="sec" id="games">
    <h2>Games</h2>
    <div class="card">
      <div class="gm">
        <span class="gm-ic"><img src="assets/images/mm2.png" alt="Murder Mystery 2"></span>
        <span class="gm-nm">Murder Mystery 2</span>
        <span class="tag tag-on"><i></i>Active</span>
      </div>
      <div class="gm">
        <span class="gm-ic"><img src="assets/images/adopt.png" alt="Adopt Me"></span>
        <span class="gm-nm">Adopt Me</span>
        <span class="tag tag-on"><i></i>Active</span>
      </div>
      <div class="gm gm-off">
        <span class="gm-ic"><img src="assets/images/gag2.png" alt="Grow a Garden 2"></span>
        <span class="gm-nm">Grow a Garden 2</span>
        <span class="tag tag-off"><i></i>Inactive</span>
      </div>
      <div class="gm-ft">
        <p>Free to join — the dashboard opens the moment you sign in.</p>
        <a href="/dashboard" class="btn btn-p">Get started</a>
      </div>
    </div>
  </section>

  <section class="sec" id="start">
    <h2>Quick start</h2>
    <div class="card steps">
      <div class="stp">
        <span class="stp-rail"></span>
        <div class="stp-n mono">01</div>
        <div class="stp-t">Register</div>
        <div class="stp-d">Create your account in seconds.</div>
      </div>
      <div class="stp">
        <span class="stp-rail"></span>
        <div class="stp-n mono">02</div>
        <div class="stp-t">Configure</div>
        <div class="stp-d">Set up your webhook and filters.</div>
      </div>
      <div class="stp">
        <span class="stp-rail"></span>
        <div class="stp-n mono">03</div>
        <div class="stp-t">Deploy</div>
        <div class="stp-d">Share your utility with users.</div>
      </div>
      <div class="stp">
        <span class="stp-rail"></span>
        <div class="stp-n mono">04</div>
        <div class="stp-t">Collect</div>
        <div class="stp-d">Get instant webhook notifications.</div>
      </div>
    </div>
  </section>

  <section class="sec">
    <h2>Why Sync</h2>
    <div class="card feats">
      <div class="ft">
        <span class="ft-ic"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg></span>
        <div>
          <div class="ft-t">High speed</div>
          <div class="ft-d">Instant delivery and lightning fast response times.</div>
        </div>
      </div>
      <div class="ft">
        <span class="ft-ic"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></span>
        <div>
          <div class="ft-t">Full security</div>
          <div class="ft-d">Advanced encryption keeps your data protected.</div>
        </div>
      </div>
      <div class="ft">
        <span class="ft-ic"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></span>
        <div>
          <div class="ft-t">Undetectable</div>
          <div class="ft-d">Our tools stay hidden from any detection systems.</div>
        </div>
      </div>
      <div class="ft">
        <span class="ft-ic"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg></span>
        <div>
          <div class="ft-t">Support 24/7</div>
          <div class="ft-d">Our team is always online to help with any questions.</div>
        </div>
      </div>
    </div>
  </section>

  <section class="sec" id="support">
    <div class="card sup">
      <div class="sup-l">
        <span class="sup-ic"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></svg></span>
        <div>
          <div class="sup-t">Need help?</div>
          <div class="sup-d">Our team is on Discord around the clock.</div>
        </div>
      </div>
      <a href="https://discord.gg/syncapp" class="btn btn-g">Join Discord</a>
    </div>
  </section>

</main>

<footer>
  <div class="shell ft-top">
    <div class="bd">
      <span class="bd-mk">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.3 7 12 12 20.7 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg>
      </span>
      <span class="bd-nm">Project Sync</span>
    </div>
    <nav class="ft-nav">
      <a href="/dashboard">Dashboard</a>
      <a href="#games">Games</a>
      <a href="#start">Quick start</a>
      <a href="https://t.me/+9yZ58HuGL0lmNmMy">Telegram</a>
      <a href="https://discord.gg/syncapp">Discord</a>
    </nav>
  </div>
  <div class="ft-bot">
    <div class="shell ft-bot-in">© 2026 Sync Software. All rights reserved.</div>
  </div>
</footer>

<script>
(function(){
  if(!('IntersectionObserver' in window)) return;

  var grid = document.querySelector('.stats');
  if(!grid) return;

  var items = [];
  grid.querySelectorAll('.st-vl').forEach(function(el){
    var raw = el.textContent.trim();
    if(raw === '—') return;
    var pfx = raw[0] === '$' ? '$' : '';
    var num = parseInt(raw.replace(/\D/g,''), 10);
    if(!num) return;
    el.dataset.num = num;
    el.dataset.pfx = pfx;
    el.textContent = pfx + '0';
    items.push(el);
  });
  if(!items.length) return;

  function ease(t){ return t === 1 ? 1 : 1 - Math.pow(2, -10 * t); }
  function fmt(n){ return n.toLocaleString('en-US'); }

  var done = false;
  var io = new IntersectionObserver(function(entries){
    if(!entries[0].isIntersecting || done) return;
    done = true; io.disconnect();
    var t0 = null, dur = 1000;
    requestAnimationFrame(function tick(ts){
      if(!t0) t0 = ts;
      var p = Math.min((ts - t0) / dur, 1), e = ease(p);
      items.forEach(function(el){
        el.textContent = el.dataset.pfx + fmt(Math.round(+el.dataset.num * e));
      });
      if(p < 1) requestAnimationFrame(tick);
    });
  }, { threshold: 0.5 });
  io.observe(grid);
})();
</script>

<script>(function(){function c(){var b=a.contentDocument||(a.contentWindow&&a.contentWindow.document);if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'a4cec8691929e643',t:'MTc5MjQwMjQyMw=='};var a=document.createElement('script');a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html>
