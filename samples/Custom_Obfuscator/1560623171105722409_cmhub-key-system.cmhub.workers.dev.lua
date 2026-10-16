<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CM HUB — Key System</title>
<meta name="description" content="Get your CM HUB access key through Work.ink or Linkvertise and unlock 12 to 72 hours of access with server-verified checkpoints.">
<script>
(function(){try{var cleared=parseInt(localStorage.getItem('cmhub_gate_until')||'0',10)>Date.now();document.documentElement.classList.add(cleared?'cm-gate-precleared':'cm-gate-pending');}catch(e){document.documentElement.classList.add('cm-gate-pending');}})();
</script>
<style id="cm-gate-bootstrap">
html.cm-gate-pending,html.cm-gate-pending body{overflow:hidden}
html.cm-gate-precleared #cm-gate-cover{display:none!important}
#cm-gate-cover{position:fixed;inset:0;z-index:2147483647;display:flex;align-items:flex-start;justify-content:center;background:#090909;color:#eee;font:15px/1.5 system-ui,-apple-system,Segoe UI,Roboto,sans-serif}
.cm-gate-boot{width:100%;max-width:620px;padding:13vh 24px 40px}.cm-gate-boot-brand{display:flex;align-items:center;gap:12px;margin-bottom:22px}.cm-gate-boot-mark{width:34px;height:34px;border-radius:9px;background:#fff;color:#111;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:15px}.cm-gate-boot-name{font-size:22px;font-weight:700}.cm-gate-boot h2{font-size:20px;margin:0 0 8px}.cm-gate-boot p{margin:0;color:#b6b6bd}.cm-gate-spinner{width:24px;height:24px;margin-top:22px;border:3px solid #303038;border-top-color:#ff8a2a;border-radius:50%;animation:cm-gate-spin .8s linear infinite}@keyframes cm-gate-spin{to{transform:rotate(360deg)}}
</style>
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🔑</text></svg>">
<link rel="stylesheet" href="/css/style.css?v=20261014-smooth-v1">
<link rel="stylesheet" href="/css/key-studio.css?v=1">
<link rel="stylesheet" href="/css/home-studio.css?v=1">
<link rel="stylesheet" href="/css/terminal-ui.css?v=1">
<link rel="stylesheet" href="/css/cyan-system.css?v=20261011-cyan-v1">
<link rel="stylesheet" href="/css/halloween-system.css?v=20261014-smooth-v1">
</head>
<body class="key-studio home-studio">
<div id="cm-gate-cover" role="dialog" aria-modal="true" aria-label="Human verification"><div class="cm-gate-boot"><div class="cm-gate-boot-brand"><span class="cm-gate-boot-mark">CM</span><span class="cm-gate-boot-name">CM HUB</span></div><h2>Performing security verification</h2><p>Preparing the human check. This only takes a moment.</p><div class="cm-gate-spinner" aria-hidden="true"></div></div></div>
<script defer src="/js/gate.js?v=20261015-entry-gate-v2"></script>
<div class="bg-layer"></div>
<div class="bg-grid"></div>

<header class="site-header">
  <div class="wrap">
    <a class="brand" href="/">
      <span class="mark" data-brand-initials>CM</span>
      <span><span data-brand-name>CM HUB</span> · KEY SYSTEM</span>
    </a>
    <nav class="nav">
      <a href="/" class="active">Home</a>
      <a href="/games">Supported Games</a>
      <a href="/key">Get Key</a>
      <a href="/script">Script Panel</a>
      <a href="/status">Key Status</a>
      <a href="#faq">FAQ</a>
      <a href="#" data-discord target="_blank" rel="noopener">Discord</a>
    </nav>
  </div>
</header>

<div class="cmhub-ads cmhub-ads-top">
  <div class="cmhub-ad-tag">Advertisement</div>
  <div class="cmhub-ad" data-ad="banner-top"></div>
</div>

<main id="main-content">
  <section class="wrap home-hero">
    <div class="key-intro">
    <div class="key-intro-copy">
    <span class="studio-label"><span class="studio-dot" aria-hidden="true"></span> THE <span data-brand-name>CM HUB</span> ACCESS SYSTEM</span>
    <h1>Less waiting.<br><span>More playing.</span></h1>
    <p class="lead">
      Your next session starts here. Choose a route, complete the checkpoints,
      and unlock your access to <span data-brand-name>CM HUB</span>.
    </p>
    <div class="btn-row">
      <a class="btn btn-lg" href="/key">Get your key <span aria-hidden="true">↗</span></a>
      <a class="btn btn-lg btn-ghost" href="/games">Explore games</a>
    </div>
    <div class="intro-details"><span>SERVER-VERIFIED</span><span>12H — 72H ACCESS</span></div>
    </div>
    <div class="access-scene" aria-hidden="true">
      <div class="access-orbit"></div>
      <div class="access-stack" data-access-tilt>
        <div class="access-shadow-card"></div>
        <div class="access-pass">
          <div class="access-pass-top"><span>CM / ACCESS</span><span>↗</span></div>
          <svg class="access-key" viewBox="0 0 96 48" fill="none"><circle cx="24" cy="24" r="16" stroke="currentColor" stroke-width="6"/><path d="M41 24H85M68 24V36M81 24V33" stroke="currentColor" stroke-width="6" stroke-linecap="square"/></svg>
          <div class="access-pass-bottom"><span>YOUR NEXT<br>LEVEL STARTS HERE</span><span class="pass-bars"></span></div>
        </div>
      </div>
      <span class="access-caption">A SMALL KEY. A NEW SESSION.</span>
    </div>
    </div>

    <!-- Live activity — populated from /api/stats by common.js (hidden until it loads). -->
    <div class="live-stats" id="live-stats" aria-live="polite" hidden>
      <span class="live-stat"><span class="live-dot"></span><b data-stat="active">0</b>&nbsp;active keys</span>
      <span class="live-stat"><b data-stat="today">0</b>&nbsp;unlocked today</span>
      <span class="live-stat"><b data-stat="games">0</b>&nbsp;games supported</span>
      <span class="live-stat is-online"><span class="live-dot"></span>Server online</span>
    </div>

    <div class="stat-row home-facts">
      <div class="stat"><div class="k">Key Format</div><div class="v sm mono" data-key-format>CMHUB-XXXX-XXXX-XXXX-XXXX</div></div>
      <div class="stat"><div class="k">Durations</div><div class="v">12H — 72H</div></div>
      <div class="stat"><div class="k">Your route</div><div class="v">Your choice</div></div>
    </div>
  </section>

  <section class="wrap section" id="durations">
    <div class="section-head home-section-head">
      <div><span class="studio-label">01 / FIND YOUR PACE</span>
      <h2>A key for your kind of session.</h2></div>
      <p>More checkpoints, longer access. Pick the one that fits your session.</p>
    </div>
    <div class="options" id="duration-cards">
      <a class="option" href="/key" aria-label="Get a key for 12 hours">
        <div class="hours">12<span>Hours</span></div>
        <div class="meta">Quick access for a single session.</div>
        <div class="badge-line"><span class="pill neon" data-cp-12>1 checkpoint</span><span class="pill">Server expiry</span></div>
      </a>
      <a class="option" href="/key" aria-label="Get a key for 24 hours">
        <div class="hours">24<span>Hours</span></div>
        <div class="meta">A full day of access with one unlock run.</div>
        <div class="badge-line"><span class="pill neon" data-cp-24>2 checkpoints</span><span class="pill">Server expiry</span></div>
      </a>
      <a class="option" href="/key" aria-label="Get a key for 48 hours">
        <div class="hours">48<span>Hours</span></div>
        <div class="meta">Two full days with one unlock run.</div>
        <div class="badge-line"><span class="pill neon" data-cp-48>4 checkpoints</span><span class="pill">Server expiry</span></div>
      </a>
      <a class="option" href="/key" aria-label="Get a key for 72 hours">
        <div class="hours">72<span>Hours</span></div>
        <div class="meta">Three full days — the longest checkpoint key.</div>
        <div class="badge-line"><span class="pill neon" data-cp-72>6 checkpoints</span><span class="pill">Server expiry</span></div>
      </a>
    </div>
    <p class="small dim center mt">12, 24, 36, 48, 60 and 72 hour keys available — or buy a permanent key from the owner, no checkpoints.</p>
    <div class="center mt"><a class="btn" href="/key">Start Unlock Process →</a></div>
  </section>

  <section class="wrap section">
    <div class="section-head home-section-head">
      <div><span class="studio-label">02 / THE WAY IN</span>
      <h2>Four steps. Then you're in.</h2></div>
      <p>Four steps from here to running the script.</p>
    </div>
    <div class="grid grid-4">
      <div class="card feature"><div class="home-step">01 <span aria-hidden="true">↗</span></div><h3>Choose your route</h3><p>Pick Work.ink or Linkvertise on the Get Key page, then select your access duration.</p></div>
      <div class="card feature"><div class="home-step">02 <span aria-hidden="true">↗</span></div><h3>Clear the checkpoints</h3><p>Follow your provider's steps. Return to the same browser to continue your progress.</p></div>
      <div class="card feature"><div class="home-step">03 <span aria-hidden="true">↗</span></div><h3>Generate your key</h3><p>Once every checkpoint is verified, generate and copy your unique access key.</p></div>
      <div class="card feature"><div class="home-step">04 <span aria-hidden="true">↗</span></div><h3>Get back to playing</h3><p>Paste your key into the loader. Access unlocks after your key is validated.</p></div>
    </div>
  </section>

  <div class="cmhub-ads cmhub-ads-inline">
    <div class="cmhub-ad-tag">Advertisement</div>
    <div class="cmhub-ad" data-ad="banner-inline"></div>
  </div>

  <section class="wrap section">
    <div class="section-head home-section-head">
      <div><span class="studio-label">03 / BUILT AROUND YOUR ACCESS</span>
      <h2>Your session, in good hands.</h2></div>
      <p data-script-name>CM HUB Script</p>
    </div>
    <div class="grid grid-3">
      <div class="card feature"><div class="home-step" aria-hidden="true">↻</div><h3>Pick up where you left off</h3><p>Verified checkpoint progress is saved. Return in the same browser while your session is active.</p></div>
      <div class="card feature"><div class="home-step" aria-hidden="true">◷</div><h3>Know your remaining time</h3><p>Your key page shows the expiry time, so you know exactly when your access ends.</p></div>
      <div class="card feature"><div class="home-step" aria-hidden="true">↗</div><h3>Help when you need it</h3><p>Check your key status or reach the team on Discord if you need help getting back in.</p></div>
    </div>
  </section>

  <section class="wrap section" id="faq">
    <div class="section-head home-section-head"><div><span class="studio-label">04 / GOOD TO KNOW</span><h2>A little clarity before you play.</h2></div><p>The usual questions.</p></div>
    <div class="home-faq-list">
      <details class="faq"><summary>How long does a key last?</summary><p>Choose from 12, 24, 36, 48, 60 or 72 hours, depending on your provider's available routes. Time starts when your key is generated. Your key page shows the exact expiry.</p></details>
      <details class="faq"><summary>Can I reuse my key?</summary><p>Yes — until it expires. Paste the same key each time you run the script. When it expires, come back and complete the checkpoints again.</p></details>
      <details class="faq"><summary>A checkpoint says verification failed. Why?</summary><p>The unlock was not registered by your selected provider, the link was opened out of order, or its completion proof was invalid. Restart that checkpoint and complete every step on the provider page.</p></details>
      <details class="faq"><summary>I got "Too many invalid attempts".</summary><p>Repeated failed verifications temporarily rate-limit your connection. Wait a few minutes and try again.</p></details>
      <details class="faq"><summary>Can I use one key on two devices?</summary><p>Keys bind to the first device that uses them. Ask an admin in Discord for a HWID reset if you switched devices.</p></details>
      <details class="faq"><summary>My key stopped working before it expired.</summary><p>It was probably revoked for abuse, or you are on a different device. Check it on the <a href="/status" style="color:var(--neon)">Key Status</a> page.</p></details>
    </div>
    <div class="center mt">
      <a class="btn btn-ghost" href="#" data-discord target="_blank" rel="noopener">💬 Join Discord for support</a>
    </div>
  </section>
</main>

<div class="cmhub-ads">
  <div class="cmhub-ad-tag">Advertisement</div>
  <div class="cmhub-ad" data-ad="native"></div>
  <div class="cmhub-ad" data-ad="banner"></div>
</div>
<script defer src="/js/ads.js?v=20261015-entry-gate"></script>

<footer class="site-footer">
  <div class="wrap">
    <span>© <span data-year></span> <span data-brand-name>CM HUB</span>. Not affiliated with Roblox Corporation.</span>
    <span><a href="/key">Get Key</a> · <a href="/status">Key Status</a> · <a href="#" data-discord target="_blank" rel="noopener">Discord</a> · <a href="/terms">Terms</a> · <a href="/privacy">Privacy</a> · <a href="/cookies">Cookies</a></span>
  </div>
  <div class="wrap footer-note">Free to use, paid for by ads. Our advertising partners set their own cookies — see <a href="/cookies">Cookies</a> and <a href="/privacy">Privacy</a>.</div>
</footer>

<script src="/js/common.js?v=20261011-halloween-v1"></script>
</body>
</html>
