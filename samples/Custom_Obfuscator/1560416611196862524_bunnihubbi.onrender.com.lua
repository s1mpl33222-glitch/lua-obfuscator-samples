<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bunny Hub | Get Access</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=Outfit:wght@400;500;600&family=Syne:wght@700;800&display=swap" rel="stylesheet">
    <style>
        :root { color-scheme: dark; --line: rgba(188,126,255,.28); --card: #14111a; --ink: #f7f2fb; --muted: #b7adc4; }
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; color: var(--ink); background: radial-gradient(circle at 70% 0, rgba(124,58,190,.28), transparent 32%), #07060a; font-family: Outfit, sans-serif; }
        a { color: inherit; text-decoration: none; }
        button, input { font: inherit; }
        .wrap { width: min(1080px, calc(100% - 32px)); margin: 0 auto; padding: 22px 0 64px; }
        .nav { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 28px; padding: 10px 14px; border: 1px solid var(--line); border-radius: 16px; background: rgba(16,12,22,.86); }
        .brand { display: flex; align-items: center; gap: 10px; font-family: Syne, sans-serif; font-weight: 800; }
        .brand img { width: 34px; height: 34px; object-fit: contain; }
        .nav-links { display: flex; align-items: center; gap: 16px; color: var(--muted); font-size: 14px; }
        .nav-links a.active { color: white; }
        .discord { padding: 8px 12px; border-radius: 10px; background: #5865f2; color: white; font-size: 13px; font-weight: 600; }
        .hero { display: grid; grid-template-columns: 1.1fr .9fr; gap: 22px; align-items: center; margin-bottom: 22px; }
        .banner { display: grid; min-height: 220px; place-items: center; overflow: hidden; border: 1px solid var(--line); border-radius: 18px; background: radial-gradient(circle at 50% 40%, rgba(168,85,247,.28), transparent 46%), #050505; }
        .banner img { width: min(100%, 280px); height: 220px; object-fit: contain; }
        h1 { margin: 8px 0 10px; font-family: Syne, sans-serif; font-size: clamp(36px, 5vw, 58px); line-height: .98; letter-spacing: -.045em; }
        .lead { max-width: 520px; margin: 0; color: var(--muted); line-height: 1.6; }
        .actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 18px; }
        .games-supported { display: block; width: min(100%, 280px); }
        .games-supported img { display: block; width: 100%; height: auto; filter: drop-shadow(0 10px 24px rgba(180,70,220,.35)); transition: transform .2s ease; }
        .games-supported:hover img { transform: translateY(-2px) scale(1.03); }
        .grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 14px; }
        .card { padding: 18px; border: 1px solid var(--line); border-radius: 16px; background: var(--card); }
        .tags { display: flex; gap: 6px; margin-bottom: 10px; }
        .tags span { padding: 3px 7px; border-radius: 999px; background: #241c30; color: #d8c6ee; font-size: 11px; }
        .card h2 { margin: 0 0 8px; font-size: 20px; }
        .card p { margin: 0; color: var(--muted); font-size: 14px; line-height: 1.5; }
        .card ul { margin: 14px 0 16px; padding: 0; list-style: none; }
        .card li { margin: 7px 0; color: #ddd4ea; font-size: 13px; }
        .card li::before { content: "✓ "; color: #c084fc; }
        .action { display: flex; min-height: 44px; align-items: center; justify-content: center; border-radius: 12px; background: linear-gradient(90deg, #7c3aed, #d946ef); font-weight: 700; }
        .action.disabled { background: #241c30; color: #9b90aa; }
        label { display: block; margin-top: 12px; }
        label span { display: block; margin-bottom: 6px; color: var(--muted); font-size: 12px; }
        input { width: 100%; min-height: 42px; padding: 0 12px; border: 1px solid var(--line); border-radius: 10px; color: white; background: #0c0a12; }
        .submit { width: 100%; margin-top: 14px; min-height: 44px; border: 0; border-radius: 12px; color: white; background: #241c30; cursor: pointer; }
        .message { min-height: 18px; margin: 10px 0 0; color: #f0a8a8; font-size: 12px; }
        details summary { color: var(--muted); cursor: pointer; }
        @media (max-width: 800px) { .hero, .grid { grid-template-columns: 1fr; } .nav-links span { display: none; } }
    </style>
    <script src="/portal.js" defer></script>
</head>
<body>
    <div class="wrap">
        <nav class="nav">
            <a class="brand" href="/"><img src="/images/bunny-logo.png" alt="">Bunny Hub</a>
            <div class="nav-links"><a class="active" href="/">Home</a><a href="/games">Games</a><a class="discord" href="https://discord.gg/NA6KcUmSk" target="_blank" rel="noopener noreferrer">Discord</a></div>
        </nav>
        <section class="hero">
            <div>
                <h1>Choose how to unlock your access.</h1>
                <p class="lead">Choose a checkpoint to get a Bunny Hub key valid for 24 hours.</p>
                <div class="actions">
                    <a class="games-supported" href="/games" aria-label="Games Supported"><img src="/images/games-supported.png" alt="Games Supported"></a>
                </div>
            </div>
            <div class="banner"><img src="/images/bunny-logo.png" alt="Bunny Hub"></div>
        </section>
        <section class="grid">
            <article class="card">
                <div class="tags"><span>TOP PICK</span><span>FREE</span></div>
                <h2>Linkvertise</h2>
                <p>Finish one checkpoint and your key is issued automatically.</p>
                <ul><li>One checkpoint</li><li>24-hour key</li><li>Mobile friendly</li></ul>
                <a class="action" href="/api/v1/user/checkpoint">Get your key</a>
            </article>
            <article class="card">
                <div class="tags"><span>FREE</span><span>WORK.INK</span></div>
                <h2>Work.ink</h2>
                <p>Complete a Work.ink key checkpoint and receive your Bunny Hub key.</p>
                <ul><li>One checkpoint</li><li>24-hour key</li><li>Mobile friendly</li></ul>
                <a class="action" href="/api/v1/user/workink-checkpoint">Get your key</a>
            </article>
            <article class="card">
                <div class="tags"><span>PREMIUM</span></div>
                <h2>Premium</h2>
                <p>Premium access is on the way.</p>
                <ul><li>No ads</li><li>Instant access</li><li>Long-term key</li></ul>
                <span class="action disabled">Coming soon</span>
                <details style="margin-top:18px">
                    <summary>Admin sign-in</summary>
                    <form id="admin-login" autocomplete="on">
                        <label for="username"><span>Admin username</span><input id="username" name="username" autocomplete="username" maxlength="100" required></label>
                        <label for="password"><span>Password</span><input id="password" name="password" type="password" autocomplete="current-password" maxlength="200" required></label>
                        <button class="submit" id="admin-submit" type="submit">Sign in as admin</button>
                    </form>
                    <p class="message" id="portal-message" role="status" aria-live="polite"></p>
                </details>
            </article>
        </section>
    </div>
</body>
</html>
