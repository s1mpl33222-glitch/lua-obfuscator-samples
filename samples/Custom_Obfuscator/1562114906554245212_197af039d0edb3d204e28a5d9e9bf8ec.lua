<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LuaGuard — Free Luau Obfuscator &amp; Script Protection for Roblox</title>
<meta name="description" content="LuaGuard is a free Luau obfuscator with its own native bytecode VM, plus an advanced multi-stage HWID-bound loader, license keys and live tamper alerts. Sign in with Discord and protect your Roblox scripts for free.">
<meta name="keywords" content="free Luau obfuscator, Roblox script protection, Lua obfuscator, Luau VM, bytecode virtualization, script loader, HWID lock, key system, anti-tamper">
<meta name="robots" content="index, follow, max-image-preview:large">
<meta name="author" content="LuaGuard">
<meta name="theme-color" content="#050810">
<link rel="canonical" href="https://luaprot.noic.fun/">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">

<meta property="og:type" content="website">
<meta property="og:site_name" content="LuaGuard">
<meta property="og:title" content="LuaGuard — Free Luau Obfuscator &amp; Script Protection">
<meta property="og:description" content="Native bytecode VM obfuscator and an advanced multi-stage loader. Free for Roblox developers.">
<meta property="og:url" content="https://luaprot.noic.fun/">
<meta property="og:image" content="https://luaprot.noic.fun/og.svg">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="LuaGuard — Free Luau Obfuscator &amp; Script Protection">
<meta name="twitter:description" content="Native bytecode VM obfuscator and an advanced multi-stage loader. Free for Roblox developers.">
<meta name="twitter:image" content="https://luaprot.noic.fun/og.svg">

<script type="application/ld+json">
{"@context":"https://schema.org","@graph":[
{"@type":"Organization","@id":"https://luaprot.noic.fun/#org","name":"LuaGuard","url":"https://luaprot.noic.fun/","logo":"https://luaprot.noic.fun/favicon.svg"},
{"@type":"WebSite","@id":"https://luaprot.noic.fun/#site","url":"https://luaprot.noic.fun/","name":"LuaGuard","publisher":{"@id":"https://luaprot.noic.fun/#org"}},
{"@type":"SoftwareApplication","name":"LuaGuard","applicationCategory":"DeveloperApplication","operatingSystem":"Web","description":"Free Luau obfuscator with a native bytecode VM and an advanced HWID-bound multi-stage loader for Roblox scripts.","url":"https://luaprot.noic.fun/","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}},
{"@type":"FAQPage","mainEntity":[
{"@type":"Question","name":"Is LuaGuard really free?","acceptedAnswer":{"@type":"Answer","text":"Yes. Signing in with Discord is free and there is no credit card. Members get a monthly allowance of protected builds at no cost."}},
{"@type":"Question","name":"Is the obfuscator a wrapper around another tool?","acceptedAnswer":{"@type":"Answer","text":"No. LuaGuard uses its own native obfuscator: it compiles Luau to bytecode, encodes the instructions, encrypts strings and constants, and runs them in its own interpreter."}},
{"@type":"Question","name":"What makes the loader advanced?","acceptedAnswer":{"@type":"Answer","text":"Scripts are delivered through a multi-stage chain with short-lived one-time tokens, per-token user-agent derivation, HWID binding, key delivery separate from the payload, token-reuse detection and decoy responses to scrapers."}},
{"@type":"Question","name":"Can protection be broken?","acceptedAnswer":{"@type":"Answer","text":"No client-side protection is unbreakable. LuaGuard raises the cost of reverse engineering and adds licensing, device binding and tamper alerts so you can detect and respond to abuse."}}
]}]}
</script>

<style>
:root{
  --bg:#050810;--bg2:#070b16;--panel:#0a1020;--panel2:#0e1730;--line:#16203a;--line2:#223056;
  --text:#e6ecf8;--muted:#7f8ba3;--blue:#3b82ff;--blue2:#6aa4ff;--blue3:#1f56d6;
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{margin:0;background:var(--bg);color:var(--text);
  font:16px/1.65 ui-sans-serif,system-ui,-apple-system,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
  -webkit-font-smoothing:antialiased;overflow-x:hidden}
a{color:inherit;text-decoration:none}
::selection{background:var(--blue);color:#fff}
.wrap{width:min(1080px,100% - 40px);margin-inline:auto}
.mono{font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace}

.bg{position:fixed;inset:0;z-index:-1;pointer-events:none;overflow:hidden}
.bg::before{content:"";position:absolute;inset:-64px 0 0 0;opacity:.5;
  background-image:linear-gradient(var(--line) 1px,transparent 1px),linear-gradient(90deg,var(--line) 1px,transparent 1px);
  background-size:64px 64px;animation:drift 18s linear infinite;
  -webkit-mask-image:radial-gradient(ellipse 80% 60% at 50% 0%,#000 20%,transparent 75%);
  mask-image:radial-gradient(ellipse 80% 60% at 50% 0%,#000 20%,transparent 75%)}
.bg::after{content:"";position:absolute;left:50%;top:-240px;width:900px;height:520px;transform:translateX(-50%);
  background:radial-gradient(closest-side,rgba(59,130,255,.28),transparent);filter:blur(30px);animation:breathe 7s ease-in-out infinite}
@keyframes drift{to{transform:translateY(64px)}}
@keyframes breathe{50%{opacity:.55;transform:translateX(-50%) scale(1.08)}}

header.nav{position:sticky;top:0;z-index:20;background:rgba(5,8,16,.8);backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);border-bottom:1px solid var(--line)}
.nav .wrap{display:flex;align-items:center;justify-content:space-between;height:62px;gap:16px}
.brand{display:flex;align-items:center;gap:10px;font-weight:700;font-size:18px;letter-spacing:-.01em}
.brand svg{width:26px;height:26px;flex:none}
.brand b{font-weight:700}.brand span{color:var(--blue2)}
.links{display:flex;gap:30px;color:var(--muted);font-size:14px}
.links a{position:relative;transition:color .2s}
.links a::after{content:"";position:absolute;left:0;bottom:-6px;height:1px;width:0;background:var(--blue);transition:width .25s}
.links a:hover{color:var(--text)}.links a:hover::after{width:100%}

.btn{display:inline-flex;align-items:center;justify-content:center;gap:10px;cursor:pointer;border:1px solid transparent;
  padding:12px 22px;border-radius:2px;font:inherit;font-weight:600;font-size:14.5px;letter-spacing:.01em;
  position:relative;overflow:hidden;transition:transform .15s,background .2s,border-color .2s,box-shadow .2s}
.btn:hover{transform:translateY(-1px)}
.btn.primary{background:var(--blue);color:#fff}
.btn.primary:hover{background:#4d90ff;box-shadow:0 8px 28px rgba(59,130,255,.35)}
.btn.primary::after{content:"";position:absolute;top:0;left:-120%;width:60%;height:100%;
  background:linear-gradient(100deg,transparent,rgba(255,255,255,.28),transparent);transform:skewX(-20deg);animation:sheen 4.5s ease-in-out infinite}
@keyframes sheen{0%,60%{left:-120%}100%{left:220%}}
.btn.ghost{background:transparent;border-color:var(--line2);color:var(--text)}
.btn.ghost:hover{border-color:var(--blue);background:rgba(59,130,255,.07)}
.btn.sm{padding:9px 16px;font-size:13.5px}
.arrow{transition:transform .2s}.btn:hover .arrow{transform:translateX(3px)}

.hero{padding:104px 0 56px}
.tag{display:inline-flex;align-items:center;gap:10px;padding:6px 12px;border:1px solid var(--line2);background:rgba(10,16,32,.7);
  border-radius:2px;font-size:12.5px;font-weight:600;color:var(--blue2);letter-spacing:.04em;text-transform:uppercase}
.tag i{width:6px;height:6px;background:var(--blue);animation:blink 1.6s steps(2) infinite}
@keyframes blink{50%{opacity:.25}}
h1{font-size:clamp(40px,7vw,78px);line-height:1.02;letter-spacing:-.04em;margin:24px 0 22px;font-weight:800;max-width:900px}
h1 em{font-style:normal;color:var(--blue)}
.lead{max-width:600px;color:var(--muted);font-size:clamp(16px,2vw,19px);margin:0 0 34px}
.cta{display:flex;gap:12px;flex-wrap:wrap}
.fine{margin-top:18px;color:var(--muted);font-size:13px}
.fine b{color:var(--text);font-weight:600}

.term{margin-top:68px;background:var(--panel);border:1px solid var(--line2);border-radius:2px;overflow:hidden;
  box-shadow:0 40px 90px rgba(0,0,0,.5),0 0 60px rgba(59,130,255,.07)}
.term-bar{display:flex;align-items:center;gap:8px;padding:11px 16px;background:var(--bg2);border-bottom:1px solid var(--line);font-size:12.5px;color:var(--muted)}
.term-bar b{width:9px;height:9px;background:var(--line2)}
.term-bar .st{margin-left:auto;color:var(--blue2);display:flex;gap:8px;align-items:center}
.term-bar .st i{width:6px;height:6px;background:var(--blue);animation:blink 1.2s steps(2) infinite}
.split{display:grid;grid-template-columns:1fr 1fr}
.pane{padding:22px 24px;font-size:13px;line-height:1.75;white-space:pre;overflow:hidden;min-height:250px}
.pane+.pane{border-left:1px solid var(--line);background:rgba(5,8,16,.55)}
.pane h6{margin:0 0 12px;font:600 11px/1 ui-sans-serif,system-ui;letter-spacing:.12em;text-transform:uppercase;color:var(--muted)}
.k{color:#8fb4ff}.s{color:#7fd4ff}.c{color:#4b5878}.n{color:#b69cff}.d{color:#5d6b8c}
#vm{color:#5d6b8c}#vm u{text-decoration:none;color:var(--blue2)}

section{padding:96px 0}
.eyebrow{display:flex;align-items:center;gap:12px;color:var(--blue2);font-weight:600;font-size:12.5px;letter-spacing:.14em;text-transform:uppercase}
.eyebrow::before{content:"";width:22px;height:1px;background:var(--blue)}
h2{font-size:clamp(28px,4vw,46px);line-height:1.08;letter-spacing:-.035em;margin:16px 0 16px;font-weight:800;max-width:720px}
.sub{color:var(--muted);max-width:620px;font-size:17px;margin:0}

.free{display:grid;grid-template-columns:1fr 1fr;border:1px solid var(--line2);background:var(--panel)}
.free>div{padding:44px}
.free>div+div{border-left:1px solid var(--line);background:linear-gradient(160deg,rgba(59,130,255,.1),transparent 60%)}
.price{font-size:88px;line-height:1;font-weight:800;letter-spacing:-.05em}
.price small{font-size:18px;color:var(--muted);font-weight:500;letter-spacing:0;margin-left:10px}
.ticks{list-style:none;margin:0;padding:0;display:grid;gap:14px}
.ticks li{display:flex;gap:14px;align-items:flex-start;color:var(--muted)}
.ticks li::before{content:"";flex:none;width:10px;height:10px;margin-top:8px;background:var(--blue)}
.ticks b{color:var(--text);font-weight:600}

.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:1px;background:var(--line);border:1px solid var(--line);margin-top:48px}
.cell{background:var(--bg);padding:30px 28px;position:relative;transition:background .25s}
.cell::before{content:"";position:absolute;left:0;top:0;height:2px;width:0;background:var(--blue);transition:width .35s}
.cell:hover{background:var(--panel)}.cell:hover::before{width:100%}
.cell .no{font:600 12px ui-monospace,Consolas,monospace;color:var(--blue2);letter-spacing:.1em}
.cell h3{margin:14px 0 8px;font-size:17.5px;letter-spacing:-.01em}
.cell p{margin:0;color:var(--muted);font-size:14.8px}

.pipe{margin-top:52px;display:grid;grid-template-columns:repeat(6,1fr);position:relative}
.pipe::before{content:"";position:absolute;left:8%;right:8%;top:22px;height:1px;background:var(--line2)}
.pipe::after{content:"";position:absolute;left:8%;top:21px;height:3px;width:56px;background:linear-gradient(90deg,transparent,var(--blue));animation:run 4.8s linear infinite}
@keyframes run{from{left:8%;opacity:0}8%{opacity:1}92%{opacity:1}to{left:calc(92% - 56px);opacity:0}}
.node{position:relative;text-align:center;padding:0 8px}
.node i{display:block;width:44px;height:44px;margin:0 auto 14px;background:var(--bg);border:1px solid var(--line2);
  font:600 13px/42px ui-monospace,Consolas,monospace;font-style:normal;color:var(--muted);animation:lit 4.8s linear infinite}
.node:nth-child(2) i{animation-delay:.8s}.node:nth-child(3) i{animation-delay:1.6s}
.node:nth-child(4) i{animation-delay:2.4s}.node:nth-child(5) i{animation-delay:3.2s}.node:nth-child(6) i{animation-delay:4s}
@keyframes lit{0%,12%{border-color:var(--blue);color:#fff;background:var(--blue3)}22%,100%{border-color:var(--line2);color:var(--muted);background:var(--bg)}}
.node b{display:block;font-size:14px;font-weight:600}
.node span{display:block;color:var(--muted);font-size:12.5px;margin-top:2px}

.two{display:grid;grid-template-columns:1fr 1fr;gap:56px;align-items:center}
.panel{background:var(--panel);border:1px solid var(--line2)}

.faq{margin-top:40px;border-top:1px solid var(--line);max-width:800px}
details{border-bottom:1px solid var(--line)}
summary{cursor:pointer;list-style:none;padding:22px 0;font-weight:600;display:flex;justify-content:space-between;gap:16px;transition:color .2s}
summary:hover{color:var(--blue2)}
summary::-webkit-details-marker{display:none}
summary::after{content:"+";color:var(--blue);font-size:22px;line-height:1;transition:transform .25s}
details[open] summary::after{transform:rotate(45deg)}
details p{margin:0 0 22px;color:var(--muted);max-width:680px}

.final{border:1px solid var(--line2);padding:72px 40px;position:relative;overflow:hidden;
  background:linear-gradient(135deg,rgba(59,130,255,.16),transparent 55%),var(--panel)}
.final h2{margin-top:0}

footer{border-top:1px solid var(--line);padding:34px 0;color:var(--muted);font-size:14px}
footer .wrap{display:flex;justify-content:space-between;gap:18px;flex-wrap:wrap;align-items:center}
footer nav{display:flex;gap:24px}footer a:hover{color:var(--text)}

.reveal{opacity:0;transform:translateY(18px);transition:opacity .7s cubic-bezier(.2,.7,.2,1),transform .7s cubic-bezier(.2,.7,.2,1)}
.reveal.in{opacity:1;transform:none}
.d1{transition-delay:.08s}.d2{transition-delay:.16s}.d3{transition-delay:.24s}

@media(max-width:900px){
  .links{display:none}
  .grid{grid-template-columns:1fr}
  .split,.two,.free{grid-template-columns:1fr}
  .free>div{padding:30px}.free>div+div{border-left:0;border-top:1px solid var(--line)}
  .pane+.pane{border-left:0;border-top:1px solid var(--line)}
  .pipe{grid-template-columns:1fr 1fr 1fr;row-gap:30px}.pipe::before,.pipe::after{display:none}
  .hero{padding-top:70px}.price{font-size:68px}.final{padding:44px 24px}
}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation:none!important;transition:none!important;scroll-behavior:auto!important}.reveal{opacity:1;transform:none}}
</style>
</head>
<body>
<div class="bg" aria-hidden="true"></div>

<header class="nav">
  <div class="wrap">
    <a class="brand" href="/" aria-label="LuaGuard home">
      <svg viewBox="0 0 48 48" fill="none" aria-hidden="true"><path d="M24 4.5 40 10v12.5c0 10.2-6.9 16.8-16 20-9.1-3.2-16-9.8-16-20V10z" stroke="#E6ECF8" stroke-width="2.6" stroke-linejoin="round"/><path d="M27.5 15a9.5 9.5 0 1 0 0 19 7.4 7.4 0 0 1 0-19z" fill="#3B82FF"/></svg>
      <b>Lua<span>Guard</span></b>
    </a>
    <nav class="links" aria-label="Primary">
      <a href="#free">Free</a>
      <a href="#obfuscator">Obfuscator</a>
      <a href="#loader">Loader</a>
      <a href="#faq">FAQ</a>
    </nav>
    <a class="btn primary sm js-cta" href="/auth/discord">Get started free</a>
  </div>
</header>

<main>
<section class="hero">
  <div class="wrap">
    <span class="tag reveal"><i></i> 100% free · Native VM obfuscator</span>
    <h1 class="reveal d1">Protect your Luau.<br><em>Free.</em> Properly.</h1>
    <p class="lead reveal d2">LuaGuard is a free Luau obfuscator with its own native bytecode VM, delivered through an advanced multi-stage loader with HWID binding, license keys and live tamper alerts.</p>
    <div class="cta reveal d3">
      <a class="btn primary js-cta" href="/auth/discord"><span class="js-cta-text">Continue with Discord</span> <span class="arrow">→</span></a>
      <a class="btn ghost" href="#obfuscator">How it works</a>
    </div>
    <p class="fine reveal d3"><b>No credit card.</b> No password. Your source stays yours.</p>

    <div class="term reveal" role="img" aria-label="Example of a Luau script before and after LuaGuard protection">
      <div class="term-bar"><b></b><b></b><b></b><span class="mono">script.luau</span><span class="st mono"><i></i>virtualizing</span></div>
      <div class="split mono">
        <div class="pane"><h6>Source</h6><span class="k">local</span> Players = game:GetService(<span class="s">"Players"</span>)

<span class="k">local function</span> grant(player)
  <span class="c">-- your premium logic</span>
  player:SetAttribute(<span class="s">"VIP"</span>, <span class="n">true</span>)
<span class="k">end</span>

Players.PlayerAdded:Connect(grant)</div>
        <div class="pane"><h6>Protected</h6><span id="vm" aria-hidden="true"></span></div>
      </div>
    </div>
  </div>
</section>

<section id="free">
  <div class="wrap">
    <div class="free reveal">
      <div>
        <span class="eyebrow">Pricing</span>
        <div class="price" style="margin-top:22px">$0<small>forever</small></div>
        <p class="sub" style="margin-top:18px">No trials, no paywalled presets. Every protection level, the full loader and the dashboard are included.</p>
        <p style="margin:28px 0 0"><a class="btn primary js-cta" href="/auth/discord"><span class="js-cta-text">Start for free</span> <span class="arrow">→</span></a></p>
      </div>
      <div>
        <ul class="ticks">
          <li><span><b>50 protected builds every month</b>, free for every member</span></li>
          <li><span><b>All presets unlocked.</b> Fast, balanced, strong and extra-strong</span></li>
          <li><span><b>License keys and HWID locks</b> included</span></li>
          <li><span><b>Live sessions, analytics</b> and Discord tamper alerts</span></li>
          <li><span><b>Sign in with Discord.</b> No card, no password</span></li>
        </ul>
      </div>
    </div>
  </div>
</section>

<section id="obfuscator">
  <div class="wrap">
    <span class="eyebrow reveal">Native obfuscator</span>
    <h2 class="reveal d1">Our own engine.<br>Not a wrapper.</h2>
    <p class="sub reveal d2">LuaGuard doesn’t re-skin another tool. It parses your script, rewrites it, compiles it with the real Luau compiler and runs it on a VM we built, so there is no readable source left to lift.</p>
    <div class="grid reveal">
      <article class="cell"><span class="no">01</span><h3>Bytecode virtualization</h3><p>Your script is compiled to Luau bytecode and executed by a bundled interpreter. It never rebuilds source text and never needs <span class="mono">loadstring</span> to run.</p></article>
      <article class="cell"><span class="no">02</span><h3>Encoded instructions</h3><p>Instruction words are encoded and decoded on demand, so the program doesn’t sit in memory as plain, readable bytecode.</p></article>
      <article class="cell"><span class="no">03</span><h3>Encrypted constants</h3><p>Strings and values are encrypted separately. URLs, keys and text are absent from the saved file.</p></article>
      <article class="cell"><span class="no">04</span><h3>Structural passes</h3><p>Parsed, AST-level rewriting: number transforms, expression rewriting, control-flow and function transforms, with scope-checked renaming.</p></article>
      <article class="cell"><span class="no">05</span><h3>Authenticated build</h3><p>Output is packed with integrity checks and verified against an Ed25519-signed manifest, so tampering with the file is detectable.</p></article>
      <article class="cell"><span class="no">06</span><h3>Four presets</h3><p>From <span class="mono">fast</span> to <span class="mono">extra-strong</span>. Trade speed for protection per script, with seeded, per-build randomness.</p></article>
    </div>
  </div>
</section>

<section id="loader" style="padding-top:40px">
  <div class="wrap">
    <span class="eyebrow reveal">Advanced loader</span>
    <h2 class="reveal d1">A loader that fights back.</h2>
    <p class="sub reveal d2">Your protected build is never offered as a download. It’s streamed through a multi-stage chain that checks the license, the device and the caller at every hop.</p>

    <div class="pipe reveal" aria-label="Loader stages">
      <div class="node"><i>01</i><b>Handshake</b><span>one-time token</span></div>
      <div class="node"><i>02</i><b>Stage 1</b><span>identity check</span></div>
      <div class="node"><i>03</i><b>Hop A</b><span>fresh token</span></div>
      <div class="node"><i>04</i><b>Hop B</b><span>fresh token</span></div>
      <div class="node"><i>05</i><b>Key</b><span>sent separately</span></div>
      <div class="node"><i>06</i><b>Payload</b><span>HWID verified</span></div>
    </div>

    <div class="grid reveal" style="margin-top:56px">
      <article class="cell"><span class="no">A</span><h3>Short-lived tokens</h3><p>Every hop issues a new one-time token that expires in seconds. Replaying or sharing one gets flagged and blocked.</p></article>
      <article class="cell"><span class="no">B</span><h3>HWID binding</h3><p>A license only runs on the device it was activated on. Revoke keys or ban devices from the dashboard instantly.</p></article>
      <article class="cell"><span class="no">C</span><h3>Split key delivery</h3><p>Payload chunks and their decryption key travel on separate requests, so no single capture is enough to unpack the script.</p></article>
      <article class="cell"><span class="no">D</span><h3>Decoys for scrapers</h3><p>Browsers, bots and wrong callers get a convincing decoy instead of an error, so probing teaches an attacker nothing.</p></article>
      <article class="cell"><span class="no">E</span><h3>Hook detection</h3><p>The loader reports when its HTTP or load channels have been hooked, and prefers unhooked channels when it finds one.</p></article>
      <article class="cell"><span class="no">F</span><h3>Place gating &amp; rate limits</h3><p>Lock a script to specific Roblox place IDs, rate-limit per IP and block abusive networks automatically.</p></article>
    </div>
  </div>
</section>

<section style="padding-top:20px">
  <div class="wrap two">
    <div class="reveal">
      <span class="eyebrow">Total visibility</span>
      <h2>Know the moment something’s off.</h2>
      <p class="sub">See who is running your script live, per-game usage and execution history. Tamper attempts, token reuse and wrong-game loads are logged and can be pushed straight to your Discord webhook.</p>
    </div>
    <div class="panel reveal d1">
      <div class="term-bar"><b></b><b></b><b></b><span class="mono">events</span></div>
      <div class="pane mono" style="min-height:0"><span class="d">12:04:11</span>  <span class="s">session.start</span>   hwid ok
<span class="d">12:04:52</span>  <span class="s">session.start</span>   hwid ok
<span class="d">12:06:03</span>  <span class="n">token.reuse</span>     blocked · ip flagged
<span class="d">12:06:40</span>  <span class="n">hook.detected</span>   request channel · alert sent
<span class="d">12:09:18</span>  <span class="s">license.revoke</span>  key revoked</div>
    </div>
  </div>
</section>

<section id="faq">
  <div class="wrap">
    <span class="eyebrow reveal">FAQ</span>
    <h2 class="reveal d1">Questions, answered.</h2>
    <div class="faq reveal">
      <details><summary>Is LuaGuard really free?</summary><p>Yes. Sign in with Discord and you get all presets, the loader, license keys and the dashboard at no cost, with a monthly allowance of 50 protected builds.</p></details>
      <details><summary>Is it a wrapper around another obfuscator?</summary><p>No. It’s a native engine that parses, transforms and compiles your script to bytecode and runs it in its own interpreter with encrypted strings and constants.</p></details>
      <details><summary>Is my source code safe?</summary><p>Your script is processed by LuaGuard’s own processing agent. The protected build is only delivered through your loader and is never offered as a file download.</p></details>
      <details><summary>Can protection be broken?</summary><p>No client-side protection is unbreakable, and we won’t claim otherwise. LuaGuard raises the cost of reverse engineering and adds licensing, device binding and tamper alerts so you can detect and respond to abuse.</p></details>
      <details><summary>What do I need to run a protected script?</summary><p>An executor with an HTTP request function. You can restrict each script to specific Roblox place IDs, or allow any game.</p></details>
    </div>
  </div>
</section>

<section style="padding-top:20px">
  <div class="wrap">
    <div class="final reveal">
      <h2>Lock down your scripts. It’s free.</h2>
      <p class="sub" style="margin-bottom:30px">Sign in with Discord and protect your first script in minutes.</p>
      <a class="btn primary js-cta" href="/auth/discord"><span class="js-cta-text">Get started free</span> <span class="arrow">→</span></a>
    </div>
  </div>
</section>
</main>

<footer>
  <div class="wrap">
    <div class="brand" style="font-size:16px"><b>Lua<span>Guard</span></b> <small style="color:var(--muted);font-weight:500">© <span id="y">2026</span></small></div>
    <nav aria-label="Footer"><a href="#free">Free</a><a href="#obfuscator">Obfuscator</a><a href="#faq">FAQ</a><a href="/dashboard">Dashboard</a></nav>
  </div>
</footer>

<script>
(function(){
  document.getElementById('y').textContent=new Date().getFullYear();

  var els=document.querySelectorAll('.reveal');
  if('IntersectionObserver' in window){
    var io=new IntersectionObserver(function(e){e.forEach(function(x){if(x.isIntersecting){x.target.classList.add('in');io.unobserve(x.target)}})},{threshold:.1});
    els.forEach(function(el){io.observe(el)});
  }else els.forEach(function(el){el.classList.add('in')});

  var vm=document.getElementById('vm');
  var reduce=window.matchMedia&&matchMedia('(prefers-reduced-motion: reduce)').matches;
  var HEX='0123456789abcdef',rows=8,cols=32,grid=[];
  for(var r=0;r<rows;r++){var row=[];for(var c=0;c<cols;c++)row.push(HEX[Math.random()*16|0]);grid.push(row)}
  function draw(){
    var out='local K=buffer.fromstring(\n';
    for(var r=0;r<rows;r++){var l=grid[r].join('');out+='  0x'+l.slice(0,8)+' '+l.slice(8,16)+' '+l.slice(16,24)+' '+l.slice(24)+'\n'}
    out+=')';
    vm.innerHTML=out.replace(/0x/g,'<u>0x</u>');
  }
  draw();
  if(!reduce)setInterval(function(){
    for(var i=0;i<6;i++)grid[Math.random()*rows|0][Math.random()*cols|0]=HEX[Math.random()*16|0];
    draw();
  },120);

  fetch('/api/me',{credentials:'same-origin'}).then(function(r){
    if(!r.ok)return;
    document.querySelectorAll('.js-cta').forEach(function(a){a.setAttribute('href','/dashboard')});
    document.querySelectorAll('.js-cta-text').forEach(function(t){t.textContent='Open dashboard'});
    var n=document.querySelector('header .js-cta');if(n)n.textContent='Open dashboard';
  }).catch(function(){});
})();
</script>
</body>
</html>
