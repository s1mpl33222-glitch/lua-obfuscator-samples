<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Gankunz — Roblox Script Platform</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg-0:#0a0907;--bg-1:#12100d;--bg-2:#1a1713;
  --border-1:#2a2620;--border-2:#3a342a;--border-strong:#4a4235;
  --text-1:#f5f0e6;--text-2:#b8b0a0;--text-3:#7a7265;--text-4:#4a4438;
  --accent:#f59e0b;--accent-hover:#fbbf24;--accent-soft:rgba(245,158,11,0.1);
  --accent-border:rgba(245,158,11,0.3);
  --font-serif:'Fraunces',Georgia,serif;
  --font-sans:'Inter',sans-serif;
  --font-mono:'JetBrains Mono',monospace;
  --success:#4ade80;
}
html,body{background:var(--bg-0);color:var(--text-1);font-family:var(--font-sans);
  -webkit-font-smoothing:antialiased;overflow-x:hidden}
a{color:var(--accent);text-decoration:none}

/* NAV */
.nav{
  position:sticky;top:0;z-index:50;padding:16px 0;
  backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);
  background:rgba(10,9,7,0.75);border-bottom:1px solid rgba(42,38,32,0.5);
}
.nav-wrap{max-width:1180px;margin:0 auto;padding:0 24px;display:flex;
  align-items:center;justify-content:space-between}
.logo{display:flex;align-items:center;gap:10px;font-family:var(--font-serif);
  font-size:19px;font-weight:600;letter-spacing:-0.02em;color:var(--text-1)}
.logo-mark{width:30px;height:30px;border-radius:6px;background:var(--accent);
  color:var(--bg-0);display:flex;align-items:center;justify-content:center;
  font-family:var(--font-serif);font-weight:700;font-size:15px}
.nav-buttons{display:flex;gap:10px}
.btn-sm{padding:8px 16px;border-radius:6px;font-size:13px;font-weight:600;
  text-decoration:none;transition:0.15s;cursor:pointer;border:0;font-family:inherit;
  display:inline-flex;align-items:center;gap:6px}
.btn-ghost{background:transparent;color:var(--text-2);border:1px solid var(--border-2)}
.btn-ghost:hover{background:var(--bg-2);color:var(--text-1)}
.btn-accent{background:var(--accent);color:var(--bg-0)}
.btn-accent:hover{background:var(--accent-hover);transform:translateY(-1px);
  box-shadow:0 8px 20px rgba(245,158,11,0.3)}

/* HERO */
.hero{position:relative;padding:100px 24px 60px;max-width:1180px;margin:0 auto}
.hero::before{content:'';position:absolute;top:-200px;left:-200px;width:600px;
  height:600px;background:radial-gradient(circle,rgba(245,158,11,0.08) 0%,transparent 60%);
  pointer-events:none;z-index:-1}
.hero::after{content:'';position:absolute;bottom:-300px;right:-200px;width:500px;
  height:500px;background:radial-gradient(circle,rgba(245,158,11,0.05) 0%,transparent 60%);
  pointer-events:none;z-index:-1}
.badge-pill{
  display:inline-flex;align-items:center;gap:8px;padding:5px 12px;
  border-radius:100px;background:var(--accent-soft);border:1px solid var(--accent-border);
  color:var(--accent);font-family:var(--font-mono);font-size:11px;font-weight:600;
  letter-spacing:0.05em;margin-bottom:24px;
}
.pulse-dot{width:6px;height:6px;background:var(--accent);border-radius:50%;
  animation:pulseDot 1.5s ease-in-out infinite}
@keyframes pulseDot{0%,100%{opacity:1}50%{opacity:.4}}
h1{
  font-family:var(--font-serif);font-size:clamp(38px,6vw,68px);line-height:1.05;
  font-weight:600;letter-spacing:-0.035em;margin-bottom:22px;max-width:900px;
}
h1 em{font-style:italic;color:var(--accent);font-weight:500}
.hero-desc{font-size:16px;line-height:1.65;color:var(--text-2);
  margin-bottom:36px;max-width:580px}
.hero-buttons{display:flex;gap:12px;flex-wrap:wrap}
.btn-lg{padding:14px 26px;border-radius:8px;font-size:14px;font-weight:600;
  text-decoration:none;transition:0.2s;display:inline-flex;align-items:center;
  gap:8px;font-family:inherit;border:0;cursor:pointer}
.btn-primary-lg{background:var(--accent);color:var(--bg-0)}
.btn-primary-lg:hover{background:var(--accent-hover);transform:translateY(-2px);
  box-shadow:0 12px 30px rgba(245,158,11,0.35)}
.btn-outline-lg{background:transparent;color:var(--text-1);border:1px solid var(--border-2)}
.btn-outline-lg:hover{background:var(--bg-2);border-color:var(--border-strong);transform:translateY(-2px)}

/* STATS */
.stats{max-width:1180px;margin:0 auto;padding:40px 24px;
  display:grid;grid-template-columns:repeat(4,1fr);gap:20px}
.stat{padding:24px;background:var(--bg-1);border:1px solid var(--border-1);
  border-radius:12px;position:relative;transition:0.2s}
.stat:hover{border-color:var(--border-strong);transform:translateY(-2px)}
.stat-value{font-family:var(--font-serif);font-size:36px;font-weight:600;
  line-height:1;letter-spacing:-0.03em}
.stat-value.accent{color:var(--accent)}
.stat-label{font-family:var(--font-mono);font-size:10px;font-weight:600;
  color:var(--text-3);text-transform:uppercase;letter-spacing:0.1em;margin-top:10px}

/* FEATURES */
.features{max-width:1180px;margin:0 auto;padding:80px 24px}
.section-head{text-align:center;margin-bottom:60px}
.section-head h2{font-family:var(--font-serif);font-size:clamp(30px,4vw,44px);
  font-weight:600;letter-spacing:-0.03em;margin-bottom:14px}
.section-head p{color:var(--text-3);font-size:15px;max-width:520px;margin:0 auto}
.feature-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}
.feature{padding:28px;background:var(--bg-1);border:1px solid var(--border-1);
  border-radius:14px;transition:0.25s}
.feature:hover{border-color:var(--border-strong);transform:translateY(-4px);
  box-shadow:0 20px 40px rgba(0,0,0,0.3)}
.feature-icon{width:44px;height:44px;border-radius:11px;
  background:linear-gradient(135deg,rgba(245,158,11,0.15),rgba(245,158,11,0.05));
  border:1px solid var(--accent-border);display:flex;align-items:center;
  justify-content:center;font-size:20px;margin-bottom:18px;color:var(--accent)}
.feature h3{font-family:var(--font-serif);font-size:17px;font-weight:600;
  margin-bottom:8px;letter-spacing:-0.01em}
.feature p{font-size:13.5px;color:var(--text-2);line-height:1.6}

/* CTA */
.cta{max-width:900px;margin:40px auto 80px;padding:0 24px}
.cta-inner{padding:60px 40px;text-align:center;background:var(--bg-1);
  border:1px solid var(--border-2);border-radius:20px;position:relative;overflow:hidden}
.cta-inner::before{content:'';position:absolute;top:-50%;left:-50%;width:200%;
  height:200%;background:radial-gradient(circle,rgba(245,158,11,0.08) 0%,transparent 40%);
  animation:rotate 25s linear infinite;pointer-events:none}
@keyframes rotate{to{transform:rotate(360deg)}}
.cta h2{font-family:var(--font-serif);font-size:clamp(26px,3.5vw,36px);
  font-weight:600;letter-spacing:-0.03em;margin-bottom:14px;position:relative;z-index:1}
.cta p{color:var(--text-2);font-size:15px;margin-bottom:28px;position:relative;z-index:1}
.cta .btn-lg{position:relative;z-index:1}

/* FOOTER */
footer{padding:40px 24px;border-top:1px solid var(--border-1);
  text-align:center;color:var(--text-3);font-size:13px}
footer a{color:var(--text-2);margin:0 10px;transition:color 0.15s}
footer a:hover{color:var(--accent)}

@media (max-width:860px){
  .hero{padding:60px 20px 40px}
  .stats{grid-template-columns:repeat(2,1fr);padding:30px 20px}
  .feature-grid{grid-template-columns:1fr}
  .stat-value{font-size:28px}
  .nav-buttons .btn-sm{padding:7px 12px;font-size:12px}
}
</style>
</head>
<body>

<nav class="nav">
  <div class="nav-wrap">
    <a href="/" class="logo"><div class="logo-mark">G</div><span>Gankunz</span></a>

  </div>
</nav>

<section class="hero">
  <div class="badge-pill"><span class="pulse-dot"></span>0 USER ONLINE</div>
  <h1>Script Roblox yang <em>simpel</em>, cepat, dan aman.</h1>
  <p class="hero-desc">
    Sistem key modern dengan dashboard pribadi, reward harian, dan akses instan ke script favorit kamu.
    Ambil key, langsung main.
  </p>

</section>

<section class="stats">
  <div class="stat"><div class="stat-value accent">0</div><div class="stat-label">Total Users</div></div>
  <div class="stat"><div class="stat-value">5</div><div class="stat-label">Script Aktif</div></div>
  <div class="stat"><div class="stat-value accent">212</div><div class="stat-label">Total Execute</div></div>
  <div class="stat"><div class="stat-value">0</div><div class="stat-label">Online Now</div></div>
</section>

<section class="features">
  <div class="section-head">
    <h2>Kenapa Gankunz?</h2>
    <p>Dibikin buat yang pengen cepet, simpel, dan gak ribet.</p>
  </div>
  <div class="feature-grid">
    <div class="feature">
      <div class="feature-icon">⚡</div>
      <h3>Super Cepat</h3>
      <p>Loader ringan, UI smooth. Auto-login bikin kamu gak perlu masukin key tiap rejoin.</p>
    </div>
    <div class="feature">
      <div class="feature-icon">🔒</div>
      <h3>Aman Terlindungi</h3>
      <p>HWID lock per akun Roblox. Satu key satu akun, gak bisa dishare ke orang lain.</p>
    </div>
    <div class="feature">
      <div class="feature-icon">◆</div>
      <h3>Rewards & Poin</h3>
      <p>Kumpulin poin dari daily login & invite teman. Tukar dengan key premium dan title eksklusif.</p>
    </div>
    <div class="feature">
      <div class="feature-icon">⌘</div>
      <h3>Multi-Game</h3>
      <p>Satu platform, banyak game. Gak perlu pindah-pindah tools buat main favoritmu.</p>
    </div>
    <div class="feature">
      <div class="feature-icon">◷</div>
      <h3>Update Rutin</h3>
      <p>Script diupdate berkala, bug diperbaiki cepet. Ada channel khusus buat request script.</p>
    </div>
    <div class="feature">
      <div class="feature-icon">✦</div>
      <h3>Title System</h3>
      <p>Pajang title keren kamu di chat & leaderboard. Ada efek visual glow, fire, rainbow.</p>
    </div>
  </div>
</section>

<section class="cta">
  <div class="cta-inner">
    <h2>Siap mulai?</h2>
    <p>Gabung sekarang. Key siap dipakai, langsung main.</p>

  </div>
</section>

<footer>
  <p style="margin-bottom:10px">
    <a href="/">Home</a>

  </p>
  <p>© 2026 Gankunz · All rights reserved</p>
</footer>

</body>
</html>