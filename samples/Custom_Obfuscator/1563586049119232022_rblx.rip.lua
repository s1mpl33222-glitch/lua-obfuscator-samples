<!doctype html>
<html lang="en">
<head>
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-ERR8KRR3RR"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-ERR8KRR3RR');
</script>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<title>rblx.rip - Roblox script hub</title>
<meta name="description" content="rblx.rip is a keyless Roblox script hub made for the people, by the people.">
<link rel="canonical" href="https://rblx.rip/">
<meta property="og:type" content="website">
<meta property="og:site_name" content="rblx.rip">
<meta property="og:url" content="https://rblx.rip/">
<meta property="og:title" content="rblx.rip - Roblox script hub">
<meta property="og:description" content="rblx.rip is a keyless Roblox script hub made for the people, by the people.">
<meta property="og:image" content="https://rblx.rip/og.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="rblx.rip - free keyless Roblox script hub">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="rblx.rip - Roblox script hub">
<meta name="twitter:description" content="rblx.rip is a keyless Roblox script hub made for the people, by the people.">
<meta name="twitter:image" content="https://rblx.rip/og.png">
<meta name="theme-color" content="#0C0D0E">
<link rel="icon" href="/favicon.ico" sizes="any">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
<style>
/* Layout: one narrow column, just the loadstring. Tokens follow rblxscripts.net (globals.css); accent stays rblx.rip red. */
:root{
  color-scheme:dark;
  --bg-0:#0C0D0E; --bg-1:#121314; --bg-2:#151617; --bg-3:#212223;
  --text-main:#F8FAFC; --text-2:#D6DBE2; --text-3:#AEB4BD; --text-muted:#8B9098;
  --overlay-1:rgba(255,255,255,.03); --overlay-2:rgba(255,255,255,.05); --overlay-3:rgba(255,255,255,.08); --overlay-4:rgba(255,255,255,.12);
  --border-subtle:rgba(255,255,255,.06); --border:rgba(255,255,255,.08); --border-strong:rgba(255,255,255,.12);
  --accent:#FF2E3B; --accent-rgb:255,46,59; --accent-edge:#C41F2B;
  --success:#34D399; --success-rgb:52,211,153;
  --warning:#F59E0B; --warning-rgb:245,158,11;
  --danger:#FF4B4B; --danger-rgb:255,75,75;
  --code-fn:#7CC4FF; --code-str:#B5E48C;
  --glass-bg:rgba(18,19,20,.72);
  --font-sans:"Hanken Grotesk","Segoe UI",system-ui,sans-serif;
  --font-mono:"JetBrains Mono",ui-monospace,SFMono-Regular,Consolas,monospace;
  --header-h:56px;
}
*{box-sizing:border-box;margin:0;padding:0}
html{font-size:105%;-webkit-text-size-adjust:100%}
body{background:var(--bg-0);color:var(--text-main);font:400 1rem/1.55 var(--font-sans);-webkit-font-smoothing:antialiased;min-height:100vh}
body::before{content:"";position:fixed;inset:0 0 auto;height:env(safe-area-inset-top,0px);z-index:10;background:var(--glass-bg)}
a{color:inherit;text-decoration:none}
:focus-visible{outline:2px solid var(--accent);outline-offset:2px;border-radius:6px}

.wrap{max-width:760px;margin:0 auto;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px))}

/* header */
.top{position:sticky;top:env(safe-area-inset-top,0px);z-index:9;background:var(--glass-bg);backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);border-bottom:1px solid var(--border-subtle)}
.top .wrap{height:var(--header-h);display:flex;align-items:center;justify-content:space-between;gap:16px}
.logo{display:flex;align-items:baseline;gap:1px;font-weight:800;font-size:1.05rem;letter-spacing:-.02em}
.logo span{color:var(--text-muted);font-weight:600;transition:color .2s,text-shadow .2s}
.logo:hover span{color:var(--accent);text-shadow:0 0 12px rgba(var(--accent-rgb),.55)}
nav{display:flex;align-items:center;gap:4px}
nav a{font-size:.875rem;font-weight:500;color:var(--text-3);padding:6px 10px;border-radius:8px;transition:background .15s,color .15s}
nav a:hover{background:var(--overlay-2);color:var(--text-main)}

/* hero */
.hero{padding-block:56px 0;display:grid;gap:14px}
.hero>*{min-width:0}
h1{font-weight:800;font-size:clamp(2.1rem,6vw,3rem);line-height:1.05;letter-spacing:-.035em;text-wrap:balance}
h1 em{font-style:normal;color:var(--accent)}

/* loadstring */
.ls{margin-top:14px;display:flex;align-items:center;gap:12px;padding:10px 10px 10px 4px;background:var(--bg-1);border-radius:14px}
.ls-code{display:block;flex:1;min-width:0;border-radius:10px;text-align:left;cursor:pointer;background:none;border:0;color:var(--text-2);padding:10px 14px;font:400 .9rem/1.5 var(--font-mono);overflow-x:auto;white-space:nowrap;scrollbar-width:thin;transition:background .15s}
.ls-code:hover{background:var(--overlay-1)}
.t-fn{color:var(--code-fn)}.t-str{color:var(--code-str)}.t-kw{color:var(--accent)}
.copy{flex:none;font:700 .9375rem var(--font-sans);color:#fff;background:var(--accent);border:0;border-radius:10px;padding:10px 22px;min-width:116px;cursor:pointer;box-shadow:0 3px 0 var(--accent-edge);transition:transform .08s,box-shadow .08s,filter .15s}
.copy:hover{filter:brightness(1.08)}
.copy:active{transform:translateY(2px);box-shadow:0 1px 0 var(--accent-edge)}
.copy.done{background:var(--success);color:#062016;box-shadow:0 3px 0 #1F9C70}

/* supported games, driven by /manifest.json */
.games{margin-top:40px;display:grid;gap:14px}
.games h2{font-size:.8125rem;font-weight:600;letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted)}
.games ul{list-style:none;display:flex;flex-wrap:wrap;gap:12px}
.games .g{display:inline-flex;align-items:center;gap:14px;padding:10px 18px 10px 10px;border-radius:14px;background:var(--bg-1);color:var(--text-main);font-weight:700;font-size:1.125rem;letter-spacing:-.01em;transition:background .15s,transform .08s}
.games a.g:hover{background:var(--bg-3)}
.games a.g:active{transform:translateY(1px)}
.games .g img{width:52px;height:52px;border-radius:11px;background:var(--bg-3);object-fit:cover}
.games .g.soon{color:var(--text-3)}.games .g.soon img{filter:grayscale(1);opacity:.7}

footer{margin-top:64px;border-top:1px solid var(--border-subtle)}
footer .wrap{display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap;padding-block:24px 36px;color:var(--text-muted);font-size:.8125rem}

@media (max-width:560px){
  .hero{padding-block:36px 0}
  .copy{width:100%;padding:13px}
  .ls{flex-direction:column;align-items:stretch;padding:10px}
}
@media (prefers-reduced-motion:reduce){*{transition:none!important}}
</style>
</head>
<body>

<header class="top">
  <div class="wrap">
    <a class="logo" href="/">rblx<span>.rip</span></a>
    <nav>
      <a href="https://rblxscripts.net" target="_blank" rel="noopener">rblxscripts.net</a>
      <a href="https://www.youtube.com/@rblxscriptsreal" target="_blank" rel="noopener">YouTube</a>
    </nav>
  </div>
</header>

<main class="wrap">
  <section class="hero">
    <h1>Roblox rblx<em>.rip</em> script hub</h1>

    <div class="ls">
      <button class="ls-code" id="lsCode" type="button" aria-label="Copy loadstring"><span class="t-fn">loadstring</span>(<span class="t-kw">game</span>:<span class="t-fn">HttpGet</span>(<span class="t-str">"https://rblx.rip/loader"</span>))()</button>
      <button class="copy" id="copyBtn" type="button">Copy</button>
    </div>

    <section class="games">
      <h2>Supported games</h2>
      <ul id="games"><li><a class="g" href="https://www.roblox.com/games/107535308163741" target="_blank" rel="noopener"><img src="/icon/107535308163741" alt="" width="52" height="52" loading="lazy">Huss Valley</a></li></ul>
    </section>
  </section>

</main>

<footer>
  <div class="wrap">
    <span>© <span id="yr">2026</span> rblx.rip</span>
  </div>
</footer>

<script>
(() => {
  const LS = 'loadstring(game:HttpGet("https://rblx.rip/loader"))()';
  const $ = (id) => document.getElementById(id);
  $("yr").textContent = new Date().getFullYear();

  // Copy: button and the code line itself
  const btn = $("copyBtn");
  async function copy() {
    let ok = false;
    try { await navigator.clipboard.writeText(LS); ok = true; }
    catch {
      const ta = Object.assign(document.createElement("textarea"), { value: LS });
      ta.style.cssText = "position:fixed;opacity:0";
      document.body.appendChild(ta); ta.select();
      try { ok = document.execCommand("copy"); } catch {}
      ta.remove();
    }
    btn.textContent = ok ? "Copied ✓" : "Select & copy";
    btn.classList.toggle("done", ok);
    clearTimeout(copy.t);
    copy.t = setTimeout(() => { btn.textContent = "Copy"; btn.classList.remove("done"); }, 1800);
  }
  btn.addEventListener("click", copy);
  $("lsCode").addEventListener("click", copy);

  // Supported games from /manifest.json (the routing source of truth)
  fetch("/manifest.json", { cache: "no-cache" }).then(r => r.ok ? r.json() : null).then(m => {
    if (!m || !Array.isArray(m.games)) return;
    const games = m.games.filter(g => !g.universal && g.status !== "hidden");
    if (!games.length) return;
    const el = $("games");
    el.replaceChildren();
    for (const g of games) {
      const li = document.createElement("li");
      const pid = Array.isArray(g.placeIds) && g.placeIds[0];
      const s = document.createElement(pid ? "a" : "span");
      s.className = "g" + (g.status === "live" ? "" : " soon");
      if (pid) { s.href = "https://www.roblox.com/games/" + pid; s.target = "_blank"; s.rel = "noopener"; }
      li.append(s);
      if (pid) {
        const img = document.createElement("img");
        img.src = "/icon/" + pid; img.alt = ""; img.width = 52; img.height = 52; img.loading = "lazy";
        img.onerror = () => img.remove();
        s.append(img);
      }
      s.append(g.name + (g.status === "live" ? "" : " (soon)"));
      el.append(li);
    }
  }).catch(() => {});

})();
</script>
</body>
</html>
