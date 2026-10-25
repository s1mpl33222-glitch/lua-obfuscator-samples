<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="color-scheme" content="dark">
<meta name="robots" content="noindex, nofollow">
<meta name="theme-color" content="#050508">
<title>loader</title>
<style>
  :root {
    --background: #050508;
    --foreground: #f0f0f5;
    --accent: #b9d0fa;
    --body-font: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    --mono: Consolas, Menlo, "SF Mono", "Courier New", monospace;
    color-scheme: dark;
  }
  *, *::before, *::after { box-sizing: border-box; }
  html { min-height: 100%; background: var(--background); }
  body {
    min-width: 280px;
    min-height: 100vh; min-height: 100svh;
    margin: 0;
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    padding: 24px;
    background: var(--background);
    color: var(--foreground);
    font-family: var(--body-font);
    -webkit-font-smoothing: antialiased;
    overflow-x: clip;
  }
  h1, p { margin: 0; }
  ::selection { color: #fff; background: #b9d0fa59; }
  .scene { position: fixed; inset: 0; z-index: 0; pointer-events: none; overflow: hidden; background: var(--background); }
  .scene-fallback {
    position: absolute; inset: -15%;
    background:
      radial-gradient(ellipse at 64% 40%, rgba(43, 55, 126, .30), transparent 40%),
      radial-gradient(ellipse at 38% 56%, rgba(54, 71, 144, .20), transparent 30%),
      radial-gradient(ellipse at 74% 24%, rgba(57, 57, 123, .16), transparent 26%);
    filter: blur(36px);
  }
  .scene-vignette { position: absolute; inset: 0; background: radial-gradient(ellipse at center, transparent 15%, var(--background) 70%); }
  .hero-glow {
    position: absolute; top: 46%; left: 50%;
    width: 560px; height: 240px; border-radius: 50%;
    transform: translate(-50%, -50%);
    background: rgba(185, 208, 250, .09);
    filter: blur(90px);
  }

  main { position: relative; z-index: 1; display: flex; flex-direction: column; align-items: center; width: 100%; }

  h1 {
    max-width: 980px;
    text-align: center;
    font-size: clamp(2.1rem, 6.6vw, 4.8rem);
    font-weight: 600;
    line-height: 1.1;
    letter-spacing: -.01em;
    color: #fff;
  }
  .word { display: inline-block; white-space: nowrap; }
  .letter {
    display: inline-block;
    text-shadow: 0 0 6px #b9d0fa47, 0 0 16px #b9d0fa24;
    opacity: 0; filter: blur(6px); transform: translateY(28px);
    animation: letter-in .75s cubic-bezier(.16, 1, .3, 1) forwards;
    animation-delay: var(--delay, 0s);
  }
  .wrap { position: relative; margin-top: 56px; max-width: 100%; opacity: 0; transform: translateY(14px); animation: hero-in .7s cubic-bezier(.16, 1, .3, 1) forwards 1.5s; }
  .halo {
    position: absolute; inset: -46px -90px; pointer-events: none;
    background: radial-gradient(closest-side, rgba(185, 208, 250, .20), rgba(120, 140, 230, .07) 55%, transparent);
    filter: blur(26px);
    animation: breathe 5s ease-in-out infinite alternate;
  }
  .box {
    position: relative; isolation: isolate; overflow: hidden;
    padding: 15px 24px;
    border: 1px solid rgba(185, 208, 250, .20);
    border-radius: 4px;
    background: rgba(185, 208, 250, .06);
    -webkit-backdrop-filter: blur(14px) saturate(160%);
    backdrop-filter: blur(14px) saturate(160%);
    box-shadow: 0 0 24px rgba(185, 208, 250, .07);
    color: rgba(255, 255, 255, .88);
    font-family: var(--mono);
    font-size: 15px;
    overflow-wrap: anywhere;
    cursor: pointer;
    white-space: pre-wrap;
    text-align: left;
    transition: border-color .2s, background .2s;
  }
  .box::before {
    content: ""; position: absolute; inset: 0; z-index: -1; pointer-events: none;
    background: linear-gradient(135deg, #ffffff2e 0%, #ffffff0a 38%, #ffffff00 62%);
    box-shadow: inset 0 1px 0 #ffffff33, inset 0 -1px 0 #ffffff0d;
  }
  .box::after {
    content: ""; position: absolute; inset: 0; pointer-events: none;
    background: linear-gradient(105deg, transparent 38%, #ffffff38 50%, transparent 62%);
    transform: translateX(-120%); animation: gloss-sweep 4.5s ease-in-out infinite;
  }
  .box:hover { border-color: rgba(185, 208, 250, .4); background: rgba(185, 208, 250, .1); }
  .box:focus-visible { outline: 2px solid var(--accent); outline-offset: 4px; }

  @keyframes letter-in { to { opacity: 1; filter: blur(0); transform: translateY(0); } }
  @keyframes hero-in { to { opacity: 1; transform: translateY(0); } }
  @keyframes gloss-sweep { 0%, 100% { transform: translateX(-120%); } 45% { transform: translateX(120%); } }
  @keyframes breathe { from { opacity: .55; } to { opacity: 1; } }

  @media (max-width: 560px) {
    .box { font-size: 12.5px; padding: 13px 16px; }
    .halo { inset: -36px -30px; }
    .hero-glow { width: 100%; }
  }
  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after { animation: none !important; transition: none !important; }
    .letter, .wrap { opacity: 1; filter: none; transform: none; }
    .box::after { display: none; }
  }
</style>
</head>
<body>
  <div class="scene" aria-hidden="true">
    <div class="scene-fallback"></div>
    <div class="hero-glow"></div>
    <div class="scene-vignette"></div>
  </div>

  <main>
    <h1 id="title">uhh get v10?</h1>
    <div class="wrap">
      <div class="halo" aria-hidden="true"></div>
      <div class="box" id="box" role="button" tabindex="0" aria-label="Copy loadstring"></div>
    </div>
  </main>

<script>
  var title = document.getElementById('title');
  var text = title.textContent;
  title.setAttribute('aria-label', text);
  title.textContent = '';
  var n = 0;
  text.split(' ').forEach(function (w, i, arr) {
    var word = document.createElement('span');
    word.className = 'word';
    word.setAttribute('aria-hidden', 'true');
    w.split('').forEach(function (ch) {
      var l = document.createElement('span');
      l.className = 'letter';
      l.style.setProperty('--delay', (n++ * 0.035).toFixed(3) + 's');
      l.textContent = ch;
      word.appendChild(l);
    });
    title.appendChild(word);
    if (i < arr.length - 1) title.appendChild(document.createTextNode(' '));
  });

  var line = 'getgenv().SCRIPT_KEY = ""\n' + "loadstring(game:HttpGet('" + location.origin + "/v10'))()";
  var box = document.getElementById('box');
  box.textContent = line;

  function copyLine() {
    if (!navigator.clipboard) return;
    navigator.clipboard.writeText(line).then(function () {
      box.textContent = 'Copied';
      setTimeout(function () { box.textContent = line; }, 1000);
    }).catch(function () {});
  }
  box.addEventListener('click', copyLine);
  box.addEventListener('keydown', function (e) {
    if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); copyLine(); }
  });
  document.addEventListener('copy', function (e) {
    if (!String(window.getSelection())) return;
    e.clipboardData.setData('text/plain', line);
    e.preventDefault();
  });
</script>
</body>
</html>
