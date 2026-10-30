<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luavify | Protect Your Scripts</title>
    <meta name="description" content="The most advanced, secure, and reliable Lua obfuscation platform for Roblox developers. Stop leakers and keep your code safe.">
    <meta property="og:type" content="website">
    <meta property="og:title" content="Luavify | Protect Your Scripts">
    <meta property="og:description" content="The most advanced, secure, and reliable Lua obfuscation platform for Roblox developers. Stop leakers and keep your code safe.">
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="Luavify | Protect Your Scripts">
    <meta name="twitter:description" content="The most advanced, secure, and reliable Lua obfuscation platform for Roblox developers. Stop leakers and keep your code safe.">
    
    <link rel="icon" type="image/png" href="https://i.ibb.co/k2GbYLyX/logo.png">
    <meta name="theme-color" content="#ef4444">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-main: #030406; 
            --bg-sidebar: rgba(12, 14, 18, 0.95); 
            --bg-card: rgba(20, 24, 30, 0.6); 
            --border-color: rgba(255, 255, 255, 0.08);
            --text-main: #f3f4f6; 
            --text-muted: #9ca3af;
            --accent-red: #ef4444; 
            --accent-red-glow: rgba(239, 68, 68, 0.5);
            --font-main: 'Inter', sans-serif;
            --font-mono: 'JetBrains Mono', monospace;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body { 
            background-color: var(--bg-main); color: var(--text-main); font-family: var(--font-main); 
            min-height: 100vh; overflow-x: hidden;
            background-image: 
                radial-gradient(circle at 15% 50%, rgba(239, 68, 68, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 85% 30%, rgba(239, 68, 68, 0.05) 0%, transparent 50%);
            background-attachment: fixed;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            letter-spacing: -0.01em;
        }
        
        /* Animations */
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes slideOutRight { from { transform: translateX(0); opacity: 1; } to { transform: translateX(100%); opacity: 0; } }
        @keyframes popIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        @keyframes float { 0% { transform: translateY(0px); } 50% { transform: translateY(-5px); } 100% { transform: translateY(0px); } }
        @keyframes gradientShift { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }
        
        .hidden { display: none !important; }

        /* Custom Toast Notifications */
        #toast-container { position: fixed; top: 20px; right: 20px; z-index: 10000; display: flex; flex-direction: column; gap: 10px; }
        .toast { 
            background: rgba(20, 24, 30, 0.95); backdrop-filter: blur(10px); border: 1px solid var(--border-color); 
            padding: 15px 20px; border-radius: 12px; color: white; font-weight: 600; font-size: 0.9rem;
            display: flex; align-items: center; gap: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            animation: slideInRight 0.3s ease forwards; min-width: 250px;
        }
        .toast.error { border-left: 4px solid #ef4444; }
        .toast.success { border-left: 4px solid #4ade80; }
        .toast.info { border-left: 4px solid #3b82f6; }

        /* ================= LANDING PAGE ================= */
        html { scroll-behavior: smooth; }
        #landing-page { display: none; width: 100%; min-height: 100vh; flex-direction: column; position: relative; }
        #landing-page section[id] { scroll-margin-top: 84px; }

        /* scroll progress */
        .scroll-progress { position: fixed; top: 0; left: 0; height: 3px; width: 100%; z-index: 1100; transform-origin: 0 50%; transform: scaleX(0); background: linear-gradient(90deg, #b91c1c, #ef4444, #fca5a5); box-shadow: 0 0 12px var(--accent-red-glow); pointer-events: none; }

        /* animated backdrop */
        .bg-fx { position: fixed; inset: 0; z-index: 0; pointer-events: none; overflow: hidden; }
        .bg-grid { position: absolute; inset: 0; background-image: linear-gradient(rgba(255,255,255,0.035) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.035) 1px, transparent 1px); background-size: 56px 56px; -webkit-mask-image: radial-gradient(ellipse 70% 60% at 50% 30%, #000 20%, transparent 75%); mask-image: radial-gradient(ellipse 70% 60% at 50% 30%, #000 20%, transparent 75%); animation: gridDrift 30s linear infinite; }
        .orb { position: absolute; border-radius: 50%; filter: blur(90px); opacity: 0.5; will-change: transform; }
        .orb.o1 { width: 520px; height: 520px; background: rgba(239,68,68,0.28); top: -140px; left: -120px; animation: orbA 18s ease-in-out infinite; }
        .orb.o2 { width: 460px; height: 460px; background: rgba(185,28,28,0.25); top: 35%; right: -160px; animation: orbB 22s ease-in-out infinite; }
        .orb.o3 { width: 380px; height: 380px; background: rgba(248,113,113,0.14); bottom: -120px; left: 30%; animation: orbA 26s ease-in-out infinite reverse; }
        @keyframes gridDrift { to { background-position: 56px 56px, 56px 56px; } }
        @keyframes orbA { 0%,100% { transform: translate(0,0) scale(1); } 50% { transform: translate(70px, 50px) scale(1.12); } }
        @keyframes orbB { 0%,100% { transform: translate(0,0) scale(1); } 50% { transform: translate(-80px, -40px) scale(1.1); } }
        #landing-page > *:not(.bg-fx):not(.scroll-progress) { position: relative; z-index: 1; }

        /* nav */
        .landing-nav { display: flex; justify-content: space-between; align-items: center; padding: 18px 50px; position: fixed !important; width: 100%; top: 0; z-index: 1000 !important; background: rgba(3, 4, 6, 0.35); backdrop-filter: blur(14px); border-bottom: 1px solid transparent; transition: background 0.35s, padding 0.35s, border-color 0.35s; }
        .landing-nav.scrolled { background: rgba(3, 4, 6, 0.82); padding: 12px 50px; border-bottom-color: var(--border-color); }
        .landing-nav .brand { font-size: 1.5rem; font-weight: 800; display: flex; align-items: center; gap: 12px; letter-spacing: 0.5px; color: white; text-decoration: none; }
        .landing-nav .brand img { width: 35px; height: 35px; filter: drop-shadow(0 0 10px var(--accent-red)); transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .landing-nav .brand:hover img { transform: rotate(-12deg) scale(1.1); }
        .landing-nav-links { display: flex; gap: 6px; padding: 5px; border-radius: 14px; background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); }
        .landing-nav-links a { color: var(--text-muted); text-decoration: none; font-weight: 600; font-size: 0.92rem; padding: 8px 18px; border-radius: 10px; transition: color 0.25s, background 0.25s; position: relative; }
        .landing-nav-links a:hover { color: white; background: rgba(255,255,255,0.05); }
        .landing-nav-links a.active { color: white; background: rgba(239,68,68,0.16); box-shadow: inset 0 0 0 1px rgba(239,68,68,0.3); }

        .hero-btn { position: relative; overflow: hidden; padding: 18px 45px; font-size: 1.05rem; border-radius: 14px; font-weight: 800; text-decoration: none; color: white; background: linear-gradient(135deg, #ef4444, #dc2626); box-shadow: 0 10px 40px var(--accent-red-glow); transition: transform 0.3s, box-shadow 0.3s; display: inline-block; border: 1px solid rgba(255,255,255,0.12); cursor: pointer; font-family: var(--font-main); }
        .hero-btn::after { content: ''; position: absolute; top: 0; left: -80%; width: 50%; height: 100%; background: linear-gradient(120deg, transparent, rgba(255,255,255,0.35), transparent); transform: skewX(-20deg); animation: shine 4.5s ease-in-out infinite; }
        @keyframes shine { 0%, 60% { left: -80%; } 100% { left: 160%; } }
        .hero-btn:hover { transform: translateY(-3px) scale(1.03); box-shadow: 0 15px 50px var(--accent-red-glow); }
        .btn-ghost { display: inline-flex; align-items: center; gap: 8px; padding: 17px 34px; border-radius: 14px; font-weight: 700; font-size: 1.05rem; color: white; text-decoration: none; background: rgba(255,255,255,0.04); border: 1px solid var(--border-color); transition: 0.3s; }
        .btn-ghost:hover { background: rgba(255,255,255,0.09); transform: translateY(-3px); border-color: rgba(255,255,255,0.2); }
        .btn-ghost svg { width: 16px; height: 16px; transition: transform 0.3s; }
        .btn-ghost:hover svg { transform: translateY(3px); }

        /* hero */
        .hero { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; min-height: 100vh; padding: 130px 20px 70px; position: relative; }
        .hero-badge { display: inline-flex; align-items: center; gap: 10px; padding: 7px 16px; border-radius: 999px; background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.28); color: #fca5a5; font-size: 0.82rem; font-weight: 700; letter-spacing: 0.4px; margin-bottom: 28px; animation: fadeIn 0.8s ease-out both; }
        .hero-badge i { width: 8px; height: 8px; border-radius: 50%; background: #ef4444; box-shadow: 0 0 0 0 var(--accent-red-glow); animation: pulse 2s infinite; }
        @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(239,68,68,0.6); } 70% { box-shadow: 0 0 0 10px rgba(239,68,68,0); } 100% { box-shadow: 0 0 0 0 rgba(239,68,68,0); } }
        .hero h1 { font-size: 4.6rem; font-weight: 800; line-height: 1.06; margin-bottom: 24px; letter-spacing: -2.5px; animation: fadeIn 1s ease-out 0.1s both; background: none; -webkit-text-fill-color: initial; color: white; }
        .hero h1 span { background: linear-gradient(135deg, #fca5a5, #ef4444, #b91c1c, #ef4444); background-size: 250% 250%; -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent; animation: gradientShift 5s ease infinite; }
        .hero p { font-size: 1.2rem; color: var(--text-muted); max-width: 620px; margin-bottom: 40px; line-height: 1.65; animation: fadeIn 1.1s ease-out 0.2s both; }
        .hero-cta { display: flex; gap: 14px; flex-wrap: wrap; justify-content: center; animation: fadeIn 1.2s ease-out 0.3s both; }

        .code-window { width: 100%; max-width: 920px; margin-top: 70px; border-radius: 20px; background: rgba(12,14,18,0.78); backdrop-filter: blur(18px); border: 1px solid var(--border-color); box-shadow: 0 40px 90px rgba(0,0,0,0.55), 0 0 80px rgba(239,68,68,0.12); overflow: hidden; text-align: left; animation: fadeIn 1.3s ease-out 0.45s both, float 7s ease-in-out 2s infinite; }
        .cw-bar { display: flex; align-items: center; gap: 8px; padding: 14px 18px; border-bottom: 1px solid var(--border-color); background: rgba(255,255,255,0.02); }
        .cw-bar i { width: 11px; height: 11px; border-radius: 50%; background: #3a3f48; }
        .cw-bar i:nth-child(1) { background: #ef4444; } .cw-bar i:nth-child(2) { background: #f59e0b; } .cw-bar i:nth-child(3) { background: #4ade80; }
        .cw-bar span { margin-left: 10px; font-size: 0.78rem; color: var(--text-muted); font-weight: 600; }
        .cw-body { display: grid; grid-template-columns: 1fr 1fr; position: relative; }
        .cw-pane { padding: 22px 24px; font-family: var(--font-mono); font-size: 0.82rem; line-height: 1.8; min-height: 230px; }
        .cw-pane + .cw-pane { border-left: 1px solid var(--border-color); background: rgba(239,68,68,0.03); }
        .cw-label { display: block; font-family: var(--font-main); font-size: 0.68rem; font-weight: 800; letter-spacing: 1.2px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 12px; }
        .cw-pane + .cw-pane .cw-label { color: #f87171; }
        .tk-k { color: #f87171; } .tk-s { color: #86efac; } .tk-f { color: #93c5fd; } .tk-c { color: #6b7280; } .tk-n { color: #fcd34d; }
        .cw-obf { color: #9ca3af; word-break: break-all; opacity: 0.85; }
        .cw-scan { position: absolute; top: 0; bottom: 0; width: 2px; left: 0; background: linear-gradient(to bottom, transparent, #ef4444, transparent); box-shadow: 0 0 22px 4px var(--accent-red-glow); animation: scan 5s ease-in-out infinite; opacity: 0.8; }
        @keyframes scan { 0% { left: 0; opacity: 0; } 10% { opacity: 0.9; } 90% { opacity: 0.9; } 100% { left: 100%; opacity: 0; } }

        /* trust strip */
        .trust { display: flex; justify-content: center; flex-wrap: wrap; gap: 14px 46px; padding: 34px 20px; border-top: 1px solid var(--border-color); border-bottom: 1px solid var(--border-color); background: rgba(255,255,255,0.015); }
        .trust div { display: flex; align-items: center; gap: 10px; color: var(--text-muted); font-weight: 600; font-size: 0.92rem; }
        .trust svg { width: 18px; height: 18px; color: var(--accent-red); }

        /* section heads */
        .section-head { text-align: center; margin-bottom: 60px; }
        .eyebrow { display: inline-block; font-size: 0.75rem; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; color: var(--accent-red); margin-bottom: 14px; }
        .section-head h2 { font-size: 2.6rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 12px; }
        .section-head h2 span { color: var(--accent-red); }
        .section-head p { color: var(--text-muted); font-size: 1.08rem; max-width: 560px; margin: 0 auto; line-height: 1.6; }

        /* features */
        .features { padding: 120px 50px 60px; text-align: center; }
        .feature-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px; max-width: 1150px; margin: 0 auto; }
        .spot { --mx: 50%; --my: 50%; }
        .spot::before { content: ''; position: absolute; inset: 0; border-radius: inherit; background: radial-gradient(420px circle at var(--mx) var(--my), rgba(239,68,68,0.14), transparent 45%); opacity: 0; transition: opacity 0.35s; pointer-events: none; }
        .spot:hover::before { opacity: 1; }
        .feature-card { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); padding: 38px; border-radius: 24px; text-align: left; transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), border-color 0.3s, box-shadow 0.3s; position: relative; overflow: hidden; }
        .feature-card:hover { transform: translateY(-8px); border-color: rgba(239, 68, 68, 0.35); box-shadow: 0 24px 50px rgba(0,0,0,0.45); }
        .feature-icon { margin-bottom: 22px; background: rgba(239,68,68,0.1); width: 56px; height: 56px; display: flex; align-items: center; justify-content: center; border-radius: 16px; color: var(--accent-red); box-shadow: inset 0 0 20px rgba(239,68,68,0.1); transition: transform 0.4s; }
        .feature-icon svg { width: 26px; height: 26px; }
        .feature-card:hover .feature-icon { transform: scale(1.1) rotate(-6deg); }
        .feature-card h3 { font-size: 1.25rem; margin-bottom: 10px; font-weight: 700; position: relative; }
        .feature-card p { color: var(--text-muted); line-height: 1.65; font-size: 0.95rem; position: relative; }

        /* steps */
        .steps { padding: 90px 50px; }
        .steps-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 28px; max-width: 1050px; margin: 0 auto; position: relative; }
        .step { text-align: center; padding: 10px 20px; position: relative; }
        .step-num { width: 64px; height: 64px; margin: 0 auto 22px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; font-weight: 800; color: white; background: linear-gradient(135deg, #ef4444, #991b1b); box-shadow: 0 0 0 8px rgba(239,68,68,0.1), 0 10px 30px var(--accent-red-glow); }
        .step h3 { font-size: 1.2rem; margin-bottom: 8px; }
        .step p { color: var(--text-muted); line-height: 1.6; font-size: 0.95rem; }

        /* pricing */
        .pricing { padding: 100px 20px; text-align: center; }
        .pricing-grid { display: flex; gap: 30px; justify-content: center; flex-wrap: wrap; max-width: 1160px; margin: 0 auto; }
        .pricing-card { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); padding: 45px 40px; border-radius: 24px; width: 350px; text-align: left; position: relative; overflow: hidden; transition: transform 0.4s, box-shadow 0.4s, border-color 0.3s; }
        .pricing-card:hover { transform: translateY(-8px); border-color: rgba(255,255,255,0.18); }
        .pricing-card.popular { border-color: var(--accent-red); box-shadow: 0 0 50px rgba(239,68,68,0.2); }
        .pricing-card.popular:hover { box-shadow: 0 0 70px rgba(239,68,68,0.32); }
        .popular-badge { position: absolute; top: 18px; right: 22px; background: var(--accent-red); color: white; padding: 6px 16px; border-radius: 20px; font-weight: 800; font-size: 0.72rem; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 4px 15px var(--accent-red-glow); }
        .pricing-card h3 { font-size: 1.5rem; margin-bottom: 15px; position: relative; }
        .price { font-size: 3.5rem; font-weight: 800; margin-bottom: 25px; position: relative; }
        .price span { font-size: 1rem; color: var(--text-muted); font-weight: 500; }
        .pricing-features { list-style: none; margin-bottom: 35px; position: relative; }
        .pricing-features li { padding: 12px 0; color: var(--text-muted); display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .pricing-features li::before { content: "✓"; color: var(--accent-red); font-weight: 900; font-size: 1.2rem; }
        
        .billing-toggle { position: relative; display: inline-flex; padding: 6px; margin: 0 auto 44px; border-radius: 16px; background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); backdrop-filter: blur(12px); }
        .bt-thumb { position: absolute; top: 6px; bottom: 6px; left: 6px; width: calc((100% - 12px) / 3); border-radius: 11px; background: linear-gradient(135deg, #ef4444, #b91c1c); box-shadow: 0 6px 20px var(--accent-red-glow); transform: translateX(calc(var(--i, 0) * 100%)); transition: transform 0.4s cubic-bezier(0.22, 1, 0.36, 1); }
        .bt-btn { position: relative; z-index: 1; min-width: 120px; padding: 13px 22px; border: none; background: transparent; color: var(--text-muted); font-family: var(--font-main); font-weight: 700; font-size: 0.95rem; cursor: pointer; border-radius: 11px; transition: color 0.3s, transform 0.15s; }
        .bt-btn:hover { color: #fff; }
        .bt-btn:active { transform: scale(0.95); }
        .bt-btn.active { color: #fff; }
        .price .amt { display: inline-block; }
        .price .amt.swap { animation: priceSwap 0.4s cubic-bezier(0.22, 1, 0.36, 1); }
        @keyframes priceSwap { from { opacity: 0; transform: translateY(10px) scale(0.96); } to { opacity: 1; transform: none; } }
        @media (max-width: 768px) { .billing-toggle { width: 100%; max-width: 380px; } .bt-btn { min-width: 0; flex: 1; padding: 13px 8px; } }
        @media (prefers-reduced-motion: reduce) { .bt-thumb { transition: none; } .price .amt.swap { animation: none; } }
        .pricing-btn { position: relative; width: 100%; padding: 16px; border-radius: 12px; border: 1px solid var(--border-color); background: rgba(255,255,255,0.03); color: white; font-weight: 700; cursor: pointer; transition: 0.3s; text-decoration: none; display: block; text-align: center; font-size: 1rem; font-family: var(--font-main); }
        .pricing-card.popular .pricing-btn { background: linear-gradient(135deg, #ef4444, #b91c1c); border-color: transparent; box-shadow: 0 8px 25px var(--accent-red-glow); }
        .pricing-btn:hover { background: rgba(255,255,255,0.08); transform: translateY(-2px); }
        .pricing-card.popular .pricing-btn:hover { background: linear-gradient(135deg, #f05252, #c42020); box-shadow: 0 12px 30px var(--accent-red-glow); }

        /* legal (terms + privacy) */
        .legal { padding: 100px 50px 40px; }
        .legal-wrap { max-width: 1100px; margin: 0 auto; display: grid; grid-template-columns: 230px 1fr; gap: 50px; align-items: start; }
        .legal-toc { position: sticky; top: 100px; padding: 22px; border-radius: 18px; background: var(--bg-card); border: 1px solid var(--border-color); backdrop-filter: blur(16px); }
        .legal-toc h4 { font-size: 0.72rem; letter-spacing: 1.6px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 14px; }
        .legal-toc a { display: block; padding: 8px 12px; margin-bottom: 2px; font-size: 0.88rem; font-weight: 600; color: var(--text-muted); text-decoration: none; border-radius: 8px; border-left: 2px solid transparent; transition: 0.2s; }
        .legal-toc a:hover { color: white; background: rgba(255,255,255,0.04); }
        .legal-toc a.active { color: white; background: rgba(239,68,68,0.12); border-left-color: var(--accent-red); }
        .legal-toc .toc-sep { height: 1px; background: var(--border-color); margin: 12px 0; }
        .legal-doc { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 24px; padding: 48px 52px; backdrop-filter: blur(16px); margin-bottom: 40px; position: relative; overflow: hidden; }
        .legal-doc::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px; background: linear-gradient(90deg, transparent, var(--accent-red), transparent); }
        .legal-doc h2 { font-size: 2rem; font-weight: 800; letter-spacing: -0.5px; margin-bottom: 8px; }
        .legal-doc .lead { color: var(--text-muted); line-height: 1.7; margin-bottom: 8px; }
        .legal-doc .lead a, .legal-doc a.inline { color: #f87171; text-decoration: none; font-weight: 600; border-bottom: 1px solid rgba(248,113,113,0.35); transition: 0.2s; }
        .legal-doc .lead a:hover, .legal-doc a.inline:hover { color: #fca5a5; border-bottom-color: #fca5a5; }
        .legal-doc .meta { display: inline-block; margin: 6px 0 26px; font-size: 0.75rem; font-weight: 700; color: #fca5a5; background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.22); padding: 4px 12px; border-radius: 999px; }
        .legal-doc h3 { font-size: 1.12rem; font-weight: 700; margin: 30px 0 10px; display: flex; align-items: baseline; gap: 12px; }
        .legal-doc h3 .n { color: var(--accent-red); font-size: 0.85rem; font-weight: 800; min-width: 26px; }
        .legal-doc p { color: var(--text-muted); line-height: 1.75; font-size: 0.97rem; margin-bottom: 12px; }
        .legal-doc p.caps { color: #d1d5db; font-weight: 700; font-size: 0.88rem; letter-spacing: 0.3px; }
        .legal-doc ul { list-style: none; margin: 0 0 12px; }
        .legal-doc li { position: relative; padding: 6px 0 6px 26px; color: var(--text-muted); line-height: 1.7; font-size: 0.97rem; }
        .legal-doc li::before { content: ''; position: absolute; left: 4px; top: 15px; width: 7px; height: 7px; border-radius: 2px; background: var(--accent-red); transform: rotate(45deg); opacity: 0.85; }
        .legal-doc li strong { color: #e5e7eb; font-weight: 600; }
        .legal-doc ul.caps li { color: #d1d5db; font-weight: 700; font-size: 0.88rem; }
        .legal-sec { scroll-margin-top: 90px; }

        /* cta */
        .cta { padding: 60px 20px 40px; }
        .cta-box { max-width: 900px; margin: 0 auto; text-align: center; padding: 70px 30px; border-radius: 28px; background: radial-gradient(ellipse at 50% 0%, rgba(239,68,68,0.22), transparent 65%), var(--bg-card); border: 1px solid rgba(239,68,68,0.25); box-shadow: 0 0 80px rgba(239,68,68,0.1); }
        .cta-box h2 { font-size: 2.4rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 12px; }
        .cta-box p { color: var(--text-muted); margin-bottom: 30px; font-size: 1.05rem; }

        /* footer */
        .landing-footer { padding: 46px 20px; text-align: center; border-top: 1px solid var(--border-color); margin-top: 60px; background: rgba(0,0,0,0.3); }
        .landing-footer p { color: var(--text-muted); font-size: 0.95rem; }
        .landing-footer a { color: var(--text-muted); text-decoration: none; margin: 0 10px; transition: 0.2s; font-weight: 500; }
        .landing-footer a:hover { color: var(--accent-red); }

        /* reveal on scroll */
        .js .reveal { opacity: 0; transform: translateY(32px); transition: opacity 0.8s cubic-bezier(0.2, 0.7, 0.2, 1), transform 0.8s cubic-bezier(0.2, 0.7, 0.2, 1); transition-delay: var(--d, 0s); }
        .js .reveal.in { opacity: 1; transform: none; }
        .js .reveal.in.feature-card:hover, .js .reveal.in.pricing-card:hover { transition-delay: 0s; }

        @media (prefers-reduced-motion: reduce) {
            html { scroll-behavior: auto; }
            .bg-grid, .orb, .code-window, .cw-scan, .hero-btn::after, .hero-badge i { animation: none !important; }
            .js .reveal { opacity: 1; transform: none; transition: none; }
        }

        /* ================= DESKTOP SIDEBAR ================= */
        #app-dashboard { display: none; height: 100vh; width: 100vw; overflow: hidden; }
        #app-dashboard.active { display: flex; }
        
        .sidebar { 
            width: 80px; background: var(--bg-sidebar); backdrop-filter: blur(20px); border-right: 1px solid var(--border-color); 
            display: flex; flex-direction: column; align-items: center; position: fixed; height: 100vh; z-index: 1000; padding: 20px 0;
            transition: all 0.3s ease;
        }
        .brand-icon { width: 40px; height: 40px; margin-bottom: 30px; animation: float 4s ease-in-out infinite; }
        .brand-icon img { width: 100%; height: 100%; object-fit: contain; filter: drop-shadow(0 0 15px var(--accent-red)); }
        
        .nav-menu { flex: 1; display: flex; flex-direction: column; gap: 15px; width: 100%; align-items: center; }
        .nav-item { 
            width: 50px; height: 50px; display: flex; align-items: center; justify-content: center; color: var(--text-muted); 
            border-radius: 12px; transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); cursor: pointer; border: 1px solid transparent;
        }
        .nav-item svg { width: 22px; height: 22px; transition: 0.3s; }
        .nav-item:hover { background: rgba(255, 255, 255, 0.05); color: var(--text-main); transform: scale(1.1); }
        .nav-item.active { background: rgba(239, 68, 68, 0.15); color: var(--accent-red); border: 1px solid rgba(239, 68, 68, 0.3); box-shadow: 0 0 20px rgba(239, 68, 68, 0.2); }
        .nav-item.active svg { filter: drop-shadow(0 0 5px var(--accent-red)); }
        
        .sidebar-footer { margin-top: auto; display: flex; flex-direction: column; gap: 15px; align-items: center; padding-bottom: 20px; }
        .main-content { margin-left: 80px; flex: 1; padding: 40px 60px; height: 100vh; overflow-y: auto; scroll-behavior: smooth; }

        /* ================= MOBILE ================= */
        .mobile-header { display: none; background: var(--bg-sidebar); padding: 15px 20px; border-bottom: 1px solid var(--border-color); justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 900; backdrop-filter: blur(10px); }
        .mobile-menu-btn { background: rgba(255,255,255,0.05); border: 1px solid var(--border-color); border-radius: 10px; color: white; cursor: pointer; padding: 8px; display: flex; align-items: center; justify-content: center; transition: background 0.25s, border-color 0.25s, transform 0.15s; }
        .mobile-menu-btn:active { transform: scale(0.88); }
        .mobile-menu-btn.open { background: rgba(239,68,68,0.15); border-color: rgba(239,68,68,0.4); }
        .mobile-menu-btn svg { width: 24px; height: 24px; overflow: visible; }
        .mobile-menu-btn svg line { transform-origin: 12px 12px; transition: transform 0.3s cubic-bezier(.4,0,.2,1), opacity 0.2s; }
        .mobile-menu-btn.open svg line:nth-child(1) { transform: translateY(6px) rotate(45deg); }
        .mobile-menu-btn.open svg line:nth-child(2) { opacity: 0; }
        .mobile-menu-btn.open svg line:nth-child(3) { transform: translateY(-6px) rotate(-45deg); }
        
        .mobile-drawer { 
            display: none; position: fixed; top: 0; left: 0; width: 280px; height: 100%; background: var(--bg-sidebar); border-right: 1px solid var(--border-color); 
            z-index: 3000; flex-direction: column; padding: 20px; transform: translateX(-100%); transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .mobile-drawer.open { transform: translateX(0); display: flex; }
        .mobile-drawer .brand { display: flex; align-items: center; gap: 10px; font-size: 1.3rem; font-weight: 800; margin-bottom: 30px; }
        .mobile-drawer .nav-item { width: 100%; height: auto; padding: 15px 20px; justify-content: flex-start; gap: 15px; font-size: 1rem; margin-bottom: 10px; }
        .drawer-backdrop { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 2500; backdrop-filter: blur(3px); opacity: 0; pointer-events: none; transition: opacity 0.28s ease; }
        .drawer-backdrop.open { opacity: 1; pointer-events: auto; }

        /* ================= DESKTOP SIDEBAR TOGGLE ================= */
        #app-dashboard { --sidebar-w: 80px; --topbar-h: 60px; }
        #app-dashboard.sidebar-expanded { --sidebar-w: 260px; }
        .desktop-header { display: none; }
        .sidebar .nav-label, .sidebar .brand-text { display: none; }

        @media (min-width: 769px) {
            .desktop-header {
                display: flex; align-items: center; position: fixed; top: 0; right: 0; left: var(--sidebar-w); height: var(--topbar-h);
                padding: 0 18px; background: var(--bg-sidebar); backdrop-filter: blur(14px); border-bottom: 1px solid var(--border-color);
                z-index: 900; transition: left 0.38s cubic-bezier(0.22, 1, 0.36, 1);
            }
            .sidebar-toggle { padding: 9px; }
            .sidebar-toggle:hover { background: rgba(255,255,255,0.09); }
            .sidebar-toggle svg { transition: transform 0.3s ease; }
            .sidebar-toggle:hover svg { transform: scale(1.08); }

            .sidebar { width: var(--sidebar-w); overflow: hidden; transition: width 0.38s cubic-bezier(0.22, 1, 0.36, 1); }
            .main-content { margin-left: var(--sidebar-w); margin-top: var(--topbar-h); height: calc(100vh - var(--topbar-h)); transition: margin-left 0.38s cubic-bezier(0.22, 1, 0.36, 1); }

            .sidebar .brand-icon { width: auto; display: flex; align-items: center; gap: 12px; align-self: flex-start; margin-left: 20px; white-space: nowrap; }
            .sidebar .brand-icon img { width: 40px; height: 40px; flex-shrink: 0; }
            .sidebar .brand-text { display: block; font-size: 1.3rem; font-weight: 800; letter-spacing: 0.3px; color: white; opacity: 0; transform: translateX(-10px); transition: opacity 0.2s ease, transform 0.3s ease; }
            .sidebar-expanded .sidebar .brand-text { opacity: 1; transform: none; transition-delay: 0.1s; }

            .sidebar .nav-item {
                position: relative; overflow: hidden; white-space: nowrap; text-decoration: none; justify-content: flex-start; gap: 14px; padding: 0 0 0 14px;
                width: calc(var(--sidebar-w) - 30px);
                transition: width 0.38s cubic-bezier(0.22, 1, 0.36, 1), background 0.25s, color 0.25s, border-color 0.25s, box-shadow 0.25s, transform 0.2s cubic-bezier(0.22, 1, 0.36, 1);
            }
            .sidebar .nav-item svg { flex-shrink: 0; }
            .sidebar .nav-item:active { transform: scale(0.93); }
            .sidebar-expanded .sidebar .nav-item:hover { transform: translateX(3px); }
            .sidebar-expanded .sidebar .nav-item:active { transform: translateX(3px) scale(0.97); }

            .sidebar .nav-label { display: block; font-size: 0.95rem; font-weight: 600; opacity: 0; transform: translateX(-10px); transition: opacity 0.15s ease, transform 0.25s ease; pointer-events: none; }
            .sidebar-expanded .sidebar .nav-label { opacity: 1; transform: none; transition: opacity 0.3s ease, transform 0.35s cubic-bezier(0.22, 1, 0.36, 1); transition-delay: calc(0.08s + var(--i, 0) * 0.04s); }
            .sidebar .nav-menu .nav-item:nth-child(1) .nav-label { --i: 0; }
            .sidebar .nav-menu .nav-item:nth-child(2) .nav-label { --i: 1; }
            .sidebar .nav-menu .nav-item:nth-child(3) .nav-label { --i: 2; }
            .sidebar .nav-menu .nav-item:nth-child(4) .nav-label { --i: 3; }
            .sidebar .nav-menu .nav-item:nth-child(5) .nav-label { --i: 4; }
            .sidebar .sidebar-footer .nav-label { --i: 5; }

            .sidebar .nav-item::before { content: ''; position: absolute; left: 0; top: 50%; width: 3px; height: 0; border-radius: 0 4px 4px 0; background: var(--accent-red); transform: translateY(-50%); transition: height 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
            .sidebar .nav-item.active::before { height: 24px; }
            .sidebar .nav-item.active svg { animation: navIconPop 0.45s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        }
        @keyframes navIconPop { 0% { transform: scale(0.7) rotate(-12deg); } 60% { transform: scale(1.18) rotate(4deg); } 100% { transform: scale(1) rotate(0); } }

        .discord-btn { position: relative; overflow: hidden; transition: background 0.2s, transform 0.15s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.2s; }
        .discord-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 22px rgba(88,101,242,0.5) !important; }
        .discord-btn:active { transform: scale(0.97); }
        .discord-btn svg { transition: transform 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .discord-btn:hover svg { transform: rotate(-10deg) scale(1.12); }
        .discord-btn .ripple { position: absolute; border-radius: 50%; background: rgba(255,255,255,0.4); transform: scale(0); animation: btnRipple 0.65s ease-out forwards; pointer-events: none; }
        .discord-btn.is-loading { pointer-events: none; }
        .discord-btn.is-loading svg { display: none; }
        .discord-btn.is-loading::before { content: ''; width: 18px; height: 18px; border: 2px solid rgba(255,255,255,0.35); border-top-color: #fff; border-radius: 50%; animation: btnSpin 0.7s linear infinite; }
        @keyframes btnRipple { to { transform: scale(4); opacity: 0; } }
        @keyframes btnSpin { to { transform: rotate(360deg); } }
        @media (prefers-reduced-motion: reduce) {
            .desktop-header, .sidebar, .main-content, .sidebar .nav-item, .sidebar .nav-label, .sidebar .brand-text { transition: none !important; }
            .sidebar .nav-item.active svg, .discord-btn .ripple { animation: none !important; }
        }

        .community-link, .user-card { width: calc(var(--sidebar-w) - 30px); overflow: hidden; white-space: nowrap; flex-shrink: 0; }
        .community-link { display: flex; align-items: center; gap: 14px; height: 50px; padding-left: 14px; border-radius: 12px; color: var(--text-muted); text-decoration: none; border: 1px solid transparent; transition: width 0.38s cubic-bezier(0.22, 1, 0.36, 1), background 0.25s, color 0.25s, transform 0.2s; }
        .community-link:hover { background: rgba(88,101,242,0.12); color: #fff; }
        .community-link:active { transform: scale(0.96); }
        .community-link svg { width: 22px; height: 22px; flex-shrink: 0; transition: transform 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .community-link:hover svg { transform: rotate(-10deg) scale(1.12); color: #8b95ff; }
        .cl-text, .uc-text { display: flex; flex-direction: column; min-width: 0; line-height: 1.3; opacity: 0; transform: translateX(-10px); transition: opacity 0.15s ease, transform 0.25s ease; }
        .cl-text strong, .uc-text strong { font-size: 0.95rem; font-weight: 700; color: #fff; overflow: hidden; text-overflow: ellipsis; }
        .cl-text small, .uc-text small { font-size: 0.8rem; font-weight: 500; color: var(--text-muted); overflow: hidden; text-overflow: ellipsis; }
        .sidebar-expanded .cl-text, .sidebar-expanded .uc-text { opacity: 1; transform: none; transition: opacity 0.3s ease 0.12s, transform 0.35s cubic-bezier(0.22, 1, 0.36, 1) 0.12s; }

        .user-card { display: flex; align-items: center; gap: 12px; height: 50px; padding: 0 0 0 6px; border-radius: 14px; background: rgba(255,255,255,0.04); border: 1px solid var(--border-color); cursor: pointer; position: relative; outline: none;
            transition: width 0.38s cubic-bezier(0.22, 1, 0.36, 1), height 0.38s cubic-bezier(0.22, 1, 0.36, 1), padding 0.38s cubic-bezier(0.22, 1, 0.36, 1), background 0.25s, border-color 0.25s, box-shadow 0.25s, transform 0.2s cubic-bezier(0.22, 1, 0.36, 1); }
        .sidebar-expanded .user-card { height: 64px; padding-left: 10px; }
        .user-card:hover { background: rgba(255,255,255,0.08); border-color: rgba(255,255,255,0.16); }
        .user-card:focus-visible { border-color: rgba(239,68,68,0.6); }
        .user-card:active { transform: scale(0.96); }
        .user-card.active { background: rgba(239,68,68,0.12); border-color: rgba(239,68,68,0.35); box-shadow: 0 0 20px rgba(239,68,68,0.15); }
        .uc-avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; flex-shrink: 0; border: 2px solid rgba(255,255,255,0.1); transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), border-color 0.25s; }
        .user-card:hover .uc-avatar, .user-card.active .uc-avatar { border-color: var(--accent-red); transform: scale(1.06); }
        .uc-actions { margin-left: auto; display: flex; align-items: center; gap: 8px; padding-right: 12px; opacity: 0; pointer-events: none; transition: opacity 0.15s ease; }
        .sidebar-expanded .uc-actions { opacity: 1; pointer-events: auto; transition: opacity 0.3s ease 0.15s; }
        .uc-gear { width: 18px; height: 18px; color: var(--text-muted); transition: transform 0.5s cubic-bezier(0.22, 1, 0.36, 1), color 0.25s; }
        .user-card:hover .uc-gear, .user-card.active .uc-gear { transform: rotate(90deg); color: #fff; }
        .uc-logout { width: 30px; height: 30px; display: flex; align-items: center; justify-content: center; border: none; border-radius: 8px; background: rgba(239,68,68,0.15); color: #f87171; cursor: pointer; transition: background 0.2s, transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .uc-logout svg { width: 16px; height: 16px; }
        .uc-logout:hover { background: rgba(239,68,68,0.3); transform: scale(1.12); }
        .uc-logout:active { transform: scale(0.9); }
        @media (prefers-reduced-motion: reduce) {
            .community-link, .user-card, .uc-actions, .cl-text, .uc-text, .uc-avatar, .uc-gear { transition: none !important; }
        }

        /* ================= UI COMPONENTS ================= */
        h1 { font-size: 2.2rem; font-weight: 800; margin-bottom: 30px; letter-spacing: -1px; background: linear-gradient(to right, #fff, #9ca3af); -webkit-background-clip: text; -webkit-text-fill-color: transparent; animation: fadeIn 0.5s ease-out; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 24px; margin-bottom: 30px; animation: fadeIn 0.6s ease-out; }
        .stat-card { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); border-radius: 20px; padding: 28px; transition: 0.4s; position: relative; overflow: hidden; }
        .stat-card::after { content: ''; position: absolute; top: 0; right: 0; width: 100px; height: 100px; background: radial-gradient(circle, rgba(239,68,68,0.1) 0%, transparent 70%); border-radius: 50%; transform: translate(30%, -30%); }
        .stat-card:hover { transform: translateY(-5px); border-color: rgba(239, 68, 68, 0.3); box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .stat-header { color: var(--text-muted); font-size: 0.85rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 15px; }
        .activity-card { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); border-radius: 20px; padding: 28px; margin-bottom: 30px; animation: fadeIn 0.6s ease-out; }
        .activity-head { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; flex-wrap: wrap; margin-bottom: 18px; }
        .activity-head h3 { font-size: 1.25rem; font-weight: 700; margin-bottom: 6px; }
        .activity-head p { color: var(--text-muted); font-size: 0.9rem; }
        .activity-legend { display: flex; gap: 20px; flex-wrap: wrap; color: var(--text-muted); font-size: 0.95rem; }
        .activity-legend span { display: inline-flex; align-items: center; gap: 8px; }
        .activity-legend i { width: 11px; height: 11px; border-radius: 50%; display: inline-block; }
        .activity-range { display: flex; gap: 6px; background: rgba(255,255,255,0.04); border: 1px solid var(--border-color); border-radius: 10px; padding: 4px; }
        .activity-range button { background: transparent; border: 0; color: var(--text-muted); font-size: 0.82rem; font-weight: 600; padding: 7px 14px; border-radius: 7px; cursor: pointer; transition: 0.2s; }
        .activity-range button:hover { color: #fff; background: rgba(255,255,255,0.06); }
        .activity-range button.active { color: #fff; background: linear-gradient(135deg,#ef4444,#b91c1c); box-shadow: 0 4px 14px rgba(239,68,68,0.35); }
        .activity-chart { position: relative; width: 100%; }
        .activity-chart svg { width: 100%; height: auto; display: block; overflow: visible; }
        .activity-chart path { transition: filter 0.25s, stroke-width 0.25s; }
        .activity-chart:hover path[stroke="#3b82f6"] { filter: drop-shadow(0 0 6px rgba(59,130,246,0.65)); stroke-width: 3.5; }
        .activity-chart circle { transition: r 0.15s ease; }
        .activity-tip { position: absolute; pointer-events: none; min-width: 190px; padding: 14px 16px; border-radius: 14px; background: rgba(22,24,28,0.96); border: 1px solid rgba(255,255,255,0.12); box-shadow: 0 10px 30px rgba(0,0,0,0.5); opacity: 0; transition: opacity 0.12s; z-index: 5; font-size: 0.9rem; }
        .activity-tip .tip-date { color: var(--text-muted); margin-bottom: 8px; }
        .activity-tip .tip-row { display: flex; align-items: center; gap: 10px; margin-top: 6px; }
        .activity-tip .tip-row i { width: 9px; height: 9px; border-radius: 50%; display: inline-block; }
        .activity-tip .tip-row span { flex: 1; color: #d1d5db; }
        .activity-tip .tip-row b { color: #fff; }
        .stat-value { font-size: 3rem; font-weight: 800; margin-bottom: 5px; text-shadow: 0 0 20px rgba(255,255,255,0.1); }
        
        .panel { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); border-radius: 20px; padding: 35px; margin-bottom: 24px; animation: fadeIn 0.6s ease-out; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        
        .project-item { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); border-radius: 20px; margin-bottom: 24px; overflow: hidden; animation: fadeIn 0.6s ease-out; transition: 0.3s; }
        .project-item:hover { border-color: rgba(255,255,255,0.15); box-shadow: 0 10px 30px rgba(0,0,0,0.4); }
        .project-header-row { display: flex; justify-content: space-between; align-items: center; padding: 24px; border-bottom: 1px solid var(--border-color); flex-wrap: wrap; gap: 15px; }
        
        .script-table { width: 100%; border-collapse: collapse; text-align: left; min-width: 600px; }
        .script-table th { padding: 18px 24px; font-size: 0.75rem; color: var(--text-muted); font-weight: 800; text-transform: uppercase; letter-spacing: 1px; border-bottom: 1px solid var(--border-color); background: rgba(0,0,0,0.2); }
        .script-table td { padding: 18px 24px; border-bottom: 1px solid rgba(255,255,255,0.03); font-size: 0.9rem; }
        
        .btn { padding: 10px 20px; border-radius: 10px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275); display: inline-flex; align-items: center; justify-content: center; font-family: var(--font-main); }
        .btn-primary { background: linear-gradient(135deg, #ef4444, #b91c1c); color: white; box-shadow: 0 4px 15px var(--accent-red-glow); }
        .btn-primary:hover { transform: translateY(-3px) scale(1.02); box-shadow: 0 8px 25px var(--accent-red-glow); }
        .btn-outline { background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); color: white; }
        .btn-outline:hover { background: rgba(255,255,255,0.08); transform: translateY(-2px); }
        .text-red { color: #f87171; border-color: rgba(248, 113, 113, 0.3); }
        .text-red:hover { background: rgba(248, 113, 113, 0.1); }
        
        .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; animation: fadeIn 0.6s ease-out; }
        .avatar { width: 80px; height: 80px; border-radius: 50%; border: 3px solid var(--accent-red); box-shadow: 0 0 20px var(--accent-red-glow); object-fit: cover; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.85); backdrop-filter: blur(8px); z-index: 4000; align-items: center; justify-content: center; padding: 20px; opacity: 0; transition: opacity 0.3s; }
        .modal.active { display: flex; opacity: 1; }
        .modal-content { background: #0f1115; border: 1px solid var(--border-color); border-radius: 20px; padding: 30px; width: 100%; max-width: 500px; position: relative; animation: popIn 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.8); }
        .modal-input { width: 100%; padding: 14px; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); color: white; border-radius: 10px; margin-bottom: 15px; outline: none; transition: 0.3s; font-family: var(--font-main); }
        .modal-input:focus { border-color: var(--accent-red); box-shadow: 0 0 10px rgba(239,68,68,0.2); }
        .modal-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 25px; }
        
        .page { display: none; animation: fadeIn 0.4s ease-out; }
        .page.active { display: block; }
        
        .toggle-switch { width: 44px; height: 24px; background: rgba(255, 255, 255, 0.1); border-radius: 12px; position: relative; cursor: pointer; transition: background 0.3s; flex-shrink: 0; }
        .toggle-switch.active { background: var(--accent-red); box-shadow: 0 0 10px var(--accent-red-glow); }
        .toggle-knob { width: 18px; height: 18px; background: white; border-radius: 50%; position: absolute; top: 3px; left: 3px; transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .toggle-switch.active .toggle-knob { left: 23px; }
        
        .badge { padding: 6px 12px; border-radius: 8px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge-active { background: rgba(74, 222, 128, 0.15); color: #4ade80; border: 1px solid rgba(74, 222, 128, 0.2); }
        .badge-disabled { background: rgba(239, 68, 68, 0.15); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.2); }

        /* Hide number input arrows */
        input[type=number]::-webkit-inner-spin-button, 
        input[type=number]::-webkit-outer-spin-button { 
            -webkit-appearance: none; 
            margin: 0; 
        }
        input[type=number] {
            -moz-appearance: textfield;
            appearance: textfield;
        }

        select {
            width: 100%; padding: 12px; background: rgba(0,0,0,0.5); border: 1px solid var(--border-color); border-radius: 8px; color: white; outline: none; font-family: var(--font-main); appearance: none; -webkit-appearance: none; cursor: pointer;
            background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23FFFFFF%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E");
            background-repeat: no-repeat; background-position: right 12px top 50%; background-size: 10px auto;
        }
        select option { background: #0f1115; color: white; padding: 10px; }

        .cselect { position: relative; flex: 1 1 160px; min-width: 160px; }
        .cselect-native { display: none !important; }

        .cselect-trigger {
            width: 100%; padding: 12px 14px; display: flex; align-items: center; justify-content: space-between; gap: 10px;
            background: rgba(0,0,0,0.5); border: 1px solid var(--border-color); border-radius: 10px; color: white;
            font-family: var(--font-main); font-size: 0.95rem; font-weight: 500; cursor: pointer; outline: none;
            transition: border-color 0.25s, box-shadow 0.25s, background 0.25s;
        }
        .cselect-trigger:hover { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.18); }
        .cselect.open .cselect-trigger,
        .cselect-trigger:focus-visible { border-color: var(--accent-red); box-shadow: 0 0 0 3px rgba(239,68,68,0.15), 0 0 18px rgba(239,68,68,0.15); }

        .cselect-chevron { width: 16px; height: 16px; color: var(--text-muted); flex-shrink: 0; transition: transform 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275), color 0.25s; }
        .cselect.open .cselect-chevron { transform: rotate(180deg); color: var(--accent-red); }

        .cselect-menu {
            position: fixed; left: 0; top: 0; width: 200px; z-index: 100000;
            background: rgba(15, 17, 21, 0.97); backdrop-filter: blur(16px);
            border: 1px solid var(--border-color); border-radius: 12px; padding: 6px;
            max-height: 260px; overflow-y: auto;
            box-shadow: 0 20px 40px rgba(0,0,0,0.6), 0 0 0 1px rgba(239,68,68,0.06);
            opacity: 0; visibility: hidden; pointer-events: none;
            transform: translateY(-8px) scale(0.97); transform-origin: top center;
            transition: opacity 0.2s ease, transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), visibility 0.2s;
        }
        .cselect-menu.dropup { transform-origin: bottom center; transform: translateY(8px) scale(0.97); }
        .cselect-menu.open { opacity: 1; visibility: visible; pointer-events: auto; transform: translateY(0) scale(1); }

        .cselect-option {
            display: flex; align-items: center; justify-content: space-between; gap: 10px;
            padding: 10px 12px; border-radius: 8px; font-size: 0.92rem; color: var(--text-muted); cursor: pointer;
            opacity: 0; transform: translateX(-6px);
            transition: background 0.15s, color 0.15s, padding-left 0.2s;
        }
        .cselect-menu.open .cselect-option { opacity: 1; transform: translateX(0); transition: opacity 0.3s ease, transform 0.3s ease, background 0.15s, color 0.15s, padding-left 0.2s; }
        .cselect-option:hover, .cselect-option.focused { background: rgba(255,255,255,0.06); color: white; padding-left: 16px; }
        .cselect-option.selected { background: rgba(239,68,68,0.14); color: var(--accent-red); font-weight: 700; }
        .cselect-option svg { width: 14px; height: 14px; opacity: 0; transform: scale(0.5); transition: 0.25s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .cselect-option.selected svg { opacity: 1; transform: scale(1); }

        .cselect-menu::-webkit-scrollbar { width: 6px; }
        .cselect-menu::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.12); border-radius: 3px; }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .mobile-header { display: flex; }
            .main-content { margin-left: 0; padding: 20px 15px; padding-top: 80px; }
            h1 { font-size: 1.8rem; }
            .stats-grid { grid-template-columns: 1fr; }
            .profile-grid { grid-template-columns: 1fr; }
            .project-header-row { flex-direction: column; align-items: flex-start; }
            .script-table { min-width: 500px; }
            .landing-nav, .landing-nav.scrolled { padding: 12px 16px; }
            .landing-nav .brand { font-size: 1.2rem; }
            .landing-nav-links { display: none; }
            .hero h1 { font-size: 2.6rem; letter-spacing: -1.5px; }
            .hero { padding-top: 110px; }
            .cw-body { grid-template-columns: 1fr; }
            .cw-pane + .cw-pane { border-left: none; border-top: 1px solid var(--border-color); }
            .cw-scan { display: none; }
            .features, .steps, .legal { padding-left: 16px; padding-right: 16px; }
            .section-head h2 { font-size: 2rem; }
            .legal-wrap { grid-template-columns: 1fr; gap: 24px; }
            .legal-toc { display: none; }
            .legal-doc { padding: 30px 22px; }
            .cta-box h2 { font-size: 1.8rem; }
        }

        /* ===== Visual upgrade ===== */
        .preview { padding: 100px 24px 40px; position: relative; z-index: 1; }
        .mock { max-width: 1040px; margin: 0 auto; border-radius: 20px; background: rgba(12,14,18,0.85); border: 1px solid var(--border-color); box-shadow: 0 40px 100px rgba(0,0,0,0.6), 0 0 90px rgba(239,68,68,0.12); overflow: hidden; position: relative; }
        .mock::before { content: ''; position: absolute; inset: 0 0 auto 0; height: 1px; background: linear-gradient(90deg, transparent, rgba(239,68,68,0.7), transparent); }
        .mock-bar { display: flex; align-items: center; gap: 8px; padding: 14px 18px; border-bottom: 1px solid var(--border-color); background: rgba(255,255,255,0.02); }
        .mock-bar i { width: 11px; height: 11px; border-radius: 50%; background: #3a3f48; }
        .mock-bar i:nth-child(1) { background: #ef4444; } .mock-bar i:nth-child(2) { background: #f59e0b; } .mock-bar i:nth-child(3) { background: #22c55e; }
        .mock-bar span { margin: 0 auto; font-size: 0.78rem; color: var(--text-muted); background: rgba(0,0,0,0.35); padding: 5px 40px; border-radius: 8px; }
        .mock-body { display: flex; min-height: 380px; }
        .mock-side { width: 64px; border-right: 1px solid var(--border-color); display: flex; flex-direction: column; align-items: center; gap: 18px; padding: 24px 0; background: rgba(0,0,0,0.25); }
        .mock-side b { width: 30px; height: 30px; border-radius: 9px; background: rgba(255,255,255,0.06); }
        .mock-side b.on { background: rgba(239,68,68,0.18); box-shadow: inset 0 0 0 1px rgba(239,68,68,0.5); }
        .mock-main { flex: 1; padding: 28px 32px; min-width: 0; }
        .mock-title { font-size: 1.5rem; font-weight: 800; margin-bottom: 20px; }
        .mock-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 22px; }
        .mock-stat { padding: 18px 20px; border-radius: 14px; background: var(--bg-card); border: 1px solid var(--border-color); }
        .mock-stat small { display: block; font-size: 0.68rem; letter-spacing: 1px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; margin-bottom: 8px; }
        .mock-stat strong { font-size: 1.9rem; font-weight: 800; }
        .mock-row { display: flex; align-items: center; gap: 14px; padding: 14px 18px; border-radius: 14px; background: var(--bg-card); border: 1px solid var(--border-color); margin-bottom: 12px; }
        .mock-ico { width: 36px; height: 36px; border-radius: 10px; background: rgba(239,68,68,0.12); color: var(--accent-red); display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .mock-ico svg { width: 18px; height: 18px; }
        .mock-row div:nth-child(2) { flex: 1; min-width: 0; }
        .mock-row em { display: block; font-style: normal; font-weight: 700; font-size: 0.95rem; }
        .mock-row small { color: var(--text-muted); font-size: 0.78rem; }
        .mock-tag { font-size: 0.65rem; font-weight: 800; letter-spacing: 0.5px; text-transform: uppercase; padding: 5px 10px; border-radius: 7px; background: rgba(74,222,128,0.15); color: #4ade80; border: 1px solid rgba(74,222,128,0.2); }
        .mock-tag.off { background: rgba(239,68,68,0.15); color: #f87171; border-color: rgba(239,68,68,0.2); }

        .showcase { max-width: 1150px; margin: 0 auto; padding: 100px 24px; display: grid; grid-template-columns: 1fr 1fr; gap: 60px; align-items: center; position: relative; z-index: 1; }
        .showcase h2 { font-size: 2.6rem; font-weight: 800; letter-spacing: -1px; line-height: 1.12; margin-bottom: 18px; }
        .showcase h2 span { color: var(--accent-red); }
        .showcase p.lead { color: var(--text-muted); font-size: 1.08rem; line-height: 1.7; margin-bottom: 28px; }
        .check-list { list-style: none; display: grid; gap: 16px; }
        .check-list li { display: flex; gap: 14px; align-items: flex-start; color: var(--text-main); font-weight: 600; line-height: 1.5; }
        .check-list li svg { width: 24px; height: 24px; padding: 5px; border-radius: 50%; background: rgba(239,68,68,0.14); color: var(--accent-red); flex-shrink: 0; margin-top: 1px; }
        .showcase-art { border-radius: 24px; border: 1px solid var(--border-color); background: radial-gradient(ellipse at 50% 0%, rgba(239,68,68,0.14), transparent 70%), var(--bg-card); padding: 18px; box-shadow: 0 30px 80px rgba(0,0,0,0.5); }
        .showcase-art svg { width: 100%; height: auto; display: block; }
        .art-float { animation: artFloat 6s ease-in-out infinite; transform-origin: center; }
        @keyframes artFloat { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-6px); } }
        .feature-card { position: relative; }
        .feature-card::before { content: ''; position: absolute; inset: 0 24px auto 24px; height: 2px; border-radius: 2px; background: linear-gradient(90deg, transparent, rgba(239,68,68,0.8), transparent); opacity: 0.55; }
        @media (max-width: 900px) {
            .showcase { grid-template-columns: 1fr; gap: 40px; padding: 70px 16px; }
            .showcase h2 { font-size: 2rem; }
            .preview { padding: 70px 16px 20px; }
            .mock-side { display: none; }
            .mock-stats { grid-template-columns: 1fr; }
            .mock-main { padding: 20px; }
        }
        @media (prefers-reduced-motion: reduce) { .art-float { animation: none; } }
    
        .access-page .panel{background:var(--card-bg,rgba(255,255,255,.025));border:1px solid var(--border,rgba(255,255,255,.1));border-radius:14px;padding:20px;}
        .access-page input,.access-page select{background:var(--input-bg,#11141a);color:var(--text,#fff);border:1px solid var(--border,rgba(255,255,255,.15));border-radius:8px;padding:10px 12px;min-height:40px;}
        .access-page .access-script-select{min-height:44px;}
        .access-table-wrap{overflow-x:auto;width:100%;}
        .access-table{width:100%;border-collapse:collapse;min-width:560px;}
        .access-table th,.access-table td{text-align:left;padding:12px 10px;border-bottom:1px solid rgba(255,255,255,.09);font-size:.88rem;vertical-align:middle;overflow-wrap:anywhere;}
        .access-table th{color:var(--text-muted);font-weight:700;}
        .access-key-code{font-family:monospace;word-break:break-all;color:#86efac;}
        .access-empty{padding:24px 10px;color:var(--text-muted);text-align:center;}
        .access-result{padding:12px;border:1px solid rgba(74,222,128,.28);border-radius:9px;background:rgba(15,20,18,.72);word-break:break-word}.access-result .btn{margin-top:6px}.access-copy-btn{background:rgba(255,255,255,.04)!important;color:var(--text,#fff)!important;border:1px solid rgba(255,255,255,.14)!important;}
        @media(max-width:700px){.access-page .panel{padding:14px}.access-page label{width:100%}.access-page input{width:100%;box-sizing:border-box}}
        
        /* Bot Page CSS */
        .bot-page-wrap { max-width: 800px; margin: 0 auto; padding: 120px 24px 80px; position: relative; z-index: 1; }
        .bot-hero { text-align: center; margin-bottom: 50px; }
        .bot-hero h1 { font-size: 3rem; font-weight: 800; margin-bottom: 16px; letter-spacing: -1px; }
        .bot-hero p { font-size: 1.15rem; color: var(--text-muted); line-height: 1.6; max-width: 600px; margin: 0 auto 30px; }
        .bot-invite-btn { display: inline-flex; align-items: center; gap: 10px; background: #5865F2; color: #fff; font-size: 1.1rem; font-weight: 700; padding: 16px 32px; border-radius: 14px; text-decoration: none; transition: 0.3s; box-shadow: 0 10px 30px rgba(88,101,242,0.4); border: 1px solid rgba(255,255,255,0.15); }
        .bot-invite-btn:hover { transform: translateY(-3px); box-shadow: 0 15px 40px rgba(88,101,242,0.6); background: #4752C4; }
        .bot-invite-btn svg { width: 24px; height: 24px; }
        .bot-section { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 24px; padding: 40px; margin-bottom: 30px; backdrop-filter: blur(16px); }
        .bot-section h2 { font-size: 1.6rem; font-weight: 800; margin-bottom: 24px; border-bottom: 1px solid var(--border-color); padding-bottom: 16px; }
        .bot-step { display: flex; gap: 20px; margin-bottom: 24px; }
        .bot-step:last-child { margin-bottom: 0; }
        .bot-step-num { width: 36px; height: 36px; flex-shrink: 0; background: rgba(239,68,68,0.15); color: var(--accent-red); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; border: 1px solid rgba(239,68,68,0.3); }
        .bot-step-content h3 { font-size: 1.1rem; font-weight: 700; margin-bottom: 6px; margin-top: 6px; }
        .bot-step-content p { color: var(--text-muted); font-size: 0.95rem; line-height: 1.6; }
        .bot-step-content code { background: rgba(0,0,0,0.5); color: #fca5a5; padding: 3px 8px; border-radius: 6px; font-family: var(--font-mono); border: 1px solid rgba(255,255,255,0.1); }
        .bot-warning { background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.3); border-radius: 12px; padding: 20px; display: flex; gap: 16px; margin-top: 20px; }
        .bot-warning svg { width: 24px; height: 24px; color: var(--accent-red); flex-shrink: 0; }
        .bot-warning p { color: #fca5a5; font-size: 0.95rem; line-height: 1.6; }
        .bot-warning strong { color: #ef4444; }
        .bot-feature-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .bot-feature { display: flex; gap: 14px; }
        .bot-feature svg { width: 20px; height: 20px; color: var(--accent-red); flex-shrink: 0; margin-top: 4px; }
        .bot-feature h4 { font-size: 1rem; font-weight: 700; margin-bottom: 4px; }
        .bot-feature p { color: var(--text-muted); font-size: 0.88rem; line-height: 1.5; }
        @media (max-width: 600px) { .bot-hero h1 { font-size: 2.2rem; } .bot-section { padding: 24px; } .bot-feature-grid { grid-template-columns: 1fr; } }

        /* ================= DISCORD BOT PAGE ================= */
        .db-page { max-width: 1080px; }
        .db-page .db-sub { color: var(--text-muted); margin: 8px 0 26px; max-width: 640px; line-height: 1.6; }
        .db-card { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); border-radius: 18px; padding: 24px; margin-bottom: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); min-width: 0; }
        .db-card-head { display: flex; align-items: center; justify-content: space-between; gap: 14px; flex-wrap: wrap; margin-bottom: 18px; }
        .db-card-head h3 { font-size: 1.1rem; font-weight: 700; margin: 0; }
        .db-hint { color: var(--text-muted); font-size: 0.86rem; line-height: 1.5; margin-top: 4px; }
        .db-hint b { color: var(--text-main); font-weight: 600; }
        .db-ico { width: 18px; height: 18px; flex-shrink: 0; }
        .db-add { gap: 9px; padding: 12px 20px; text-decoration: none; }

        /* form controls */
        .db-field { display: flex; flex-direction: column; gap: 7px; min-width: 0; }
        .db-label { font-size: 0.74rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.7px; }
        .db-input, .db-textarea {
            width: 100%; padding: 12px 14px; background: rgba(0,0,0,0.5); border: 1px solid var(--border-color); border-radius: 10px;
            color: #fff; font-family: var(--font-main); font-size: 0.95rem; outline: none; min-width: 0;
            transition: border-color 0.25s, box-shadow 0.25s, background 0.25s;
        }
        .db-input::placeholder, .db-textarea::placeholder { color: rgba(156,163,175,0.55); }
        .db-input:hover, .db-textarea:hover { border-color: rgba(255,255,255,0.18); }
        .db-input:focus, .db-textarea:focus { border-color: var(--accent-red); box-shadow: 0 0 0 3px rgba(239,68,68,0.15); }
        .db-textarea { resize: vertical; min-height: 96px; line-height: 1.55; }
        .db-count { align-self: flex-end; font-size: 0.72rem; color: var(--text-muted); }
        .db-page .cselect { flex: none; width: 100%; min-width: 0; }
        .db-page .cselect-label { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; text-align: left; }
        .db-row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .db-color-wrap { display: flex; align-items: center; gap: 10px; }
        .db-color-input { -webkit-appearance: none; appearance: none; width: 52px; height: 46px; padding: 4px; background: rgba(0,0,0,0.5); border: 1px solid var(--border-color); border-radius: 10px; cursor: pointer; flex-shrink: 0; }
        .db-color-input::-webkit-color-swatch-wrapper { padding: 0; }
        .db-color-input::-webkit-color-swatch { border: none; border-radius: 6px; }
        .db-color-input::-moz-color-swatch { border: none; border-radius: 6px; }
        .db-color-hex { font-family: var(--font-mono); font-size: 0.85rem; color: var(--text-muted); }
        .db-stack { display: grid; gap: 16px; min-width: 0; }
        .db-actions { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 22px; }
        .db-inline { display: flex; gap: 14px; flex-wrap: wrap; align-items: flex-end; }
        .db-inline .db-field { flex: 1 1 200px; max-width: 320px; }

        /* server cards */
        .db-servers { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 12px; }
        .db-server { position: relative; display: flex; align-items: center; gap: 13px; padding: 14px 44px 14px 14px; border-radius: 14px; border: 1px solid var(--border-color); background: rgba(255,255,255,0.03); cursor: pointer; transition: border-color 0.2s, background 0.2s, box-shadow 0.2s, transform 0.2s; min-width: 0; outline: none; }
        .db-server:hover { background: rgba(255,255,255,0.06); border-color: rgba(255,255,255,0.18); transform: translateY(-2px); }
        .db-server:focus-visible { border-color: var(--accent-red); }
        .db-server.selected { border-color: rgba(239,68,68,0.6); background: rgba(239,68,68,0.09); box-shadow: 0 0 0 3px rgba(239,68,68,0.12), 0 8px 24px rgba(239,68,68,0.1); }
        .db-server.gone { opacity: 0.85; cursor: default; }
        .db-server.gone:hover { transform: none; }
        .db-avatar { position: relative; width: 46px; height: 46px; border-radius: 14px; flex-shrink: 0; overflow: hidden; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #2f3136, #1b1d21); border: 1px solid rgba(255,255,255,0.08); }
        .db-avatar b { font-size: 0.95rem; font-weight: 800; color: #dbdee1; letter-spacing: 0.5px; }
        .db-avatar img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }
        .db-server.selected .db-avatar { border-color: rgba(239,68,68,0.5); }
        .db-server-meta { min-width: 0; flex: 1; }
        .db-server-name { font-weight: 700; font-size: 0.97rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .db-server-sub { display: flex; align-items: center; gap: 6px; margin-top: 3px; font-size: 0.76rem; color: var(--text-muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .db-dot { width: 7px; height: 7px; border-radius: 50%; background: #4ade80; flex-shrink: 0; box-shadow: 0 0 8px rgba(74,222,128,0.6); }
        .db-server.gone .db-dot { background: #f87171; box-shadow: 0 0 8px rgba(248,113,113,0.6); }
        .db-server-x { position: absolute; top: 50%; right: 8px; transform: translateY(-50%); width: 30px; height: 30px; border-radius: 8px; border: none; background: transparent; color: var(--text-muted); cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background 0.2s, color 0.2s; }
        .db-server-x:hover { background: rgba(239,68,68,0.15); color: #f87171; }
        .db-server-x svg { width: 15px; height: 15px; }
        .db-server-readd { color: #f87171; font-weight: 700; text-decoration: none; }
        .db-server-readd:hover { text-decoration: underline; }
        .db-empty { grid-column: 1 / -1; text-align: center; padding: 34px 18px; border: 1px dashed rgba(255,255,255,0.14); border-radius: 16px; background: rgba(255,255,255,0.02); }
        .db-empty img { width: 52px; height: 52px; margin-bottom: 12px; opacity: 0.95; }
        .db-empty strong { display: block; font-size: 1.05rem; margin-bottom: 6px; }
        .db-empty p { color: var(--text-muted); font-size: 0.9rem; line-height: 1.55; max-width: 420px; margin: 0 auto 16px; }
        .db-skel { height: 76px; border-radius: 14px; background: linear-gradient(90deg, rgba(255,255,255,0.03), rgba(255,255,255,0.07), rgba(255,255,255,0.03)); background-size: 200% 100%; animation: dbShimmer 1.3s infinite linear; }
        @keyframes dbShimmer { from { background-position: 200% 0; } to { background-position: -200% 0; } }

        /* panel editor + preview */
        .db-panel-layout { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, 1.05fr); gap: 24px; align-items: start; }
        .db-preview-col { position: sticky; top: 8px; min-width: 0; }
        .db-preview-col .db-label { display: block; margin-bottom: 10px; }

        .dc-msg { background: #313338; border-radius: 12px; padding: 16px 14px 14px; color: #dbdee1; font-family: 'Noto Sans', 'Inter', system-ui, sans-serif; border: 1px solid rgba(255,255,255,0.05); min-width: 0; }
        .dc-head { display: flex; gap: 12px; align-items: flex-start; }
        .dc-av { width: 40px; height: 40px; border-radius: 50%; flex-shrink: 0; background: #1e1f22; object-fit: cover; }
        .dc-body { min-width: 0; flex: 1; }
        .dc-name { font-weight: 600; font-size: 1rem; color: #fff; line-height: 1.3; display: flex; align-items: center; flex-wrap: wrap; gap: 6px; }
        .dc-tag { background: #5865f2; color: #fff; font-size: 0.62rem; font-weight: 600; padding: 1px 5px; border-radius: 4px; line-height: 1.35; text-transform: uppercase; }
        .dc-time { color: #949ba4; font-size: 0.74rem; font-weight: 400; }
        .dc-embed { margin-top: 6px; background: #2b2d31; border-left: 4px solid var(--c, #ef4444); border-radius: 4px; padding: 8px 16px 12px 12px; max-width: 520px; border-top: 1px solid rgba(0,0,0,0.12); border-right: 1px solid rgba(0,0,0,0.12); border-bottom: 1px solid rgba(0,0,0,0.12); }
        .dc-author { font-size: 0.85rem; font-weight: 600; color: #fff; margin-top: 8px; overflow-wrap: anywhere; }
        .dc-title { font-size: 1rem; font-weight: 700; color: #fff; margin-top: 8px; overflow-wrap: anywhere; }
        .dc-desc { font-size: 0.875rem; line-height: 1.4; margin-top: 8px; white-space: pre-wrap; overflow-wrap: anywhere; }
        .dc-desc code { background: #1e1f22; padding: 1px 5px; border-radius: 4px; font-family: var(--font-mono); font-size: 0.82rem; }
        .dc-foot { font-size: 0.72rem; color: #b5bac1; margin-top: 10px; overflow-wrap: anywhere; }
        .dc-btnrow { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
        .dc-btn { display: inline-flex; align-items: center; gap: 6px; height: 32px; padding: 2px 14px; border-radius: 4px; font-size: 0.85rem; font-weight: 500; color: #fff; font-family: inherit; cursor: default; user-select: none; }
        .dc-btn.primary { background: #5865f2; } .dc-btn.secondary { background: #4e5058; } .dc-btn.success { background: #248046; }

        /* chips for manager roles */
        .db-chips { display: flex; flex-wrap: wrap; gap: 8px; }
        .db-chip { display: inline-flex; align-items: center; gap: 8px; padding: 8px 13px; border-radius: 999px; border: 1px solid var(--border-color); background: rgba(255,255,255,0.03); cursor: pointer; font-size: 0.88rem; font-weight: 600; color: var(--text-muted); transition: 0.2s; user-select: none; max-width: 100%; }
        .db-chip:hover { background: rgba(255,255,255,0.07); color: #fff; }
        .db-chip input { position: absolute; opacity: 0; pointer-events: none; width: 0; height: 0; }
        .db-chip .db-dot { box-shadow: none; background: var(--rc, #99aab5); }
        .db-chip span.n { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .db-chip:has(input:checked) { border-color: rgba(239,68,68,0.55); background: rgba(239,68,68,0.12); color: #fff; }
        .db-chip:has(input:focus-visible) { box-shadow: 0 0 0 3px rgba(239,68,68,0.25); }

        @media (max-width: 900px) {
            .db-panel-layout { grid-template-columns: 1fr; }
            .db-preview-col { position: static; }
        }
        @media (max-width: 600px) {
            .db-card { padding: 18px 16px; border-radius: 16px; }
            .db-row2 { grid-template-columns: 1fr; }
            .db-servers { grid-template-columns: 1fr; }
            .db-add { width: 100%; }
            .db-actions .btn { flex: 1 1 100%; }
            .db-inline .db-field { max-width: none; flex-basis: 100%; }
        }
    </style>
</head>
<body>

    <div id="toast-container"></div>

    <!-- LOGIN MODAL -->
    <div class="modal" id="loginModal" onclick="if(event.target===this)closeLoginModal()">
        <div class="modal-content" style="max-width: 420px;" role="dialog" aria-modal="true" aria-labelledby="login-title">
            <h2 id="login-title" style="font-size: 1.5rem; margin-bottom: 6px;">Sign in to Luavify</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 22px;">Use Discord, or paste the API key from your dashboard.</p>
            <a href="/auth/login" class="btn discord-btn" onclick="discordLoginClick(event, this)" style="width: 100%; padding: 14px; font-size: 1rem; text-decoration: none; gap: 10px; background: #5865F2; color: #fff; box-shadow: 0 4px 15px rgba(88,101,242,0.35);" onmouseover="this.style.background='#4752C4'" onmouseout="this.style.background='#5865F2'"><svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor" aria-hidden="true"><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>Continue with Discord</a>
            <div style="display: flex; align-items: center; gap: 12px; margin: 20px 0; color: var(--text-muted); font-size: 0.85rem;">
                <span style="flex: 1; height: 1px; background: var(--border-color);"></span>or<span style="flex: 1; height: 1px; background: var(--border-color);"></span>
            </div>
            <label for="login-apikey" style="display: block; font-size: 0.9rem; font-weight: 600; margin-bottom: 8px;">API key</label>
            <input id="login-apikey" type="password" autocomplete="off" spellcheck="false" placeholder="lua_..." style="width: 100%; padding: 13px 14px; border-radius: 10px; border: 1px solid var(--border-color); background: rgba(255,255,255,0.03); color: white; font-family: var(--font-main); font-size: 0.95rem; outline: none;" onfocus="this.style.borderColor='var(--accent-red)'" onblur="this.style.borderColor=''">
            <div id="login-error" role="alert" style="color: #fca5a5; font-size: 0.88rem; min-height: 20px; margin: 8px 0 12px;"></div>
            <button type="button" id="login-apikey-btn" class="btn btn-outline" style="width: 100%; padding: 13px;" onclick="submitApiKeyLogin()">Sign in with API key</button>
        </div>
    </div>

    <!-- LANDING PAGE -->
    <div id="landing-page">
        <div class="scroll-progress" id="scroll-progress"></div>
        <div class="bg-fx" aria-hidden="true"><div class="bg-grid"></div><div class="orb o1"></div><div class="orb o2"></div><div class="orb o3"></div></div>

        <nav class="landing-nav" id="landing-nav">
            <a href="#top" class="brand" data-scroll>
                <img src="https://i.ibb.co/k2GbYLyX/logo.png" alt="Luavify Logo" onerror="this.style.display='none'">
                Luavify
            </a>
            <div class="landing-nav-links">
                <a href="#features" data-scroll>Features</a>
                <a href="#pricing" data-scroll>Pricing</a>
                <a href="#terms" data-scroll>Terms</a>
                <a href="/#bot" data-scroll>Discord Bot</a>
            </div>
            <a href="/auth/login" class="hero-btn" style="padding: 10px 20px; font-size: 0.9rem; border-radius: 10px;">Get Started</a>
        </nav>

        <section class="hero" id="top">
            <div class="hero-badge"><i></i> Built for Roblox developers</div>
            <h1>Protect Your Scripts.<br><span>Obfuscate with Luavify.</span></h1>
            <p>The most advanced, secure, and reliable Lua obfuscation platform for Roblox developers. Stop leakers and keep your code safe.</p>
            <div class="hero-cta">
                <a href="/auth/login" class="hero-btn">Get Started for Free</a>
                <a href="#features" class="btn-ghost" data-scroll>Explore features
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><polyline points="19 12 12 19 5 12"/></svg>
                </a>
            </div>

            <div class="code-window" aria-hidden="true">
                <div class="cw-bar"><i></i><i></i><i></i><span>luavify — protect.lua</span></div>
                <div class="cw-body">
                    <div class="cw-pane">
                        <span class="cw-label">Your script</span>
<span class="tk-c">-- premium features</span><br>
<span class="tk-k">local</span> <span class="tk-f">key</span> = <span class="tk-s">"LUA-XXXX-XXXX"</span><br>
<span class="tk-k">if not</span> <span class="tk-f">validate</span>(key) <span class="tk-k">then</span><br>
&nbsp;&nbsp;<span class="tk-f">player</span>:<span class="tk-f">Kick</span>(<span class="tk-s">"Invalid key"</span>)<br>
<span class="tk-k">end</span><br>
<span class="tk-f">giveCoins</span>(<span class="tk-n">9999</span>)
                    </div>
                    <div class="cw-pane">
                        <span class="cw-label">Protected output</span>
                        <div class="cw-obf" id="cw-obf"></div>
                    </div>
                    <div class="cw-scan"></div>
                </div>
            </div>
        </section>

        <div class="trust reveal">
            <div><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>VM-based obfuscation</div>
            <div><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>Key &amp; device locks</div>
            <div><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 11.5a8.4 8.4 0 0 1-9 8.4 8.5 8.5 0 0 1-4-1L3 21l1.9-5.1A8.4 8.4 0 1 1 21 11.5z"/></svg>Discord login</div>
        </div>

        <section class="preview" id="preview">
            <div class="section-head reveal">
                <span class="eyebrow">Dashboard</span>
                <h2>Everything in <span>one place</span></h2>
                <p>Manage projects, loaders and access from a single, clean dashboard.</p>
            </div>
            <div class="mock reveal" aria-hidden="true">
                <div class="mock-bar"><i></i><i></i><i></i><span>Luavify — Dashboard</span></div>
                <div class="mock-body">
                    <div class="mock-side"><b class="on"></b><b></b><b></b><b></b></div>
                    <div class="mock-main">
                        <div class="mock-title">Dashboard</div>
                        <div class="mock-stats">
                            <div class="mock-stat"><small>Monthly obfuscations</small><strong>128</strong></div>
                            <div class="mock-stat"><small>Projects</small><strong>6</strong></div>
                            <div class="mock-stat"><small>Plan</small><strong>Premium</strong></div>
                        </div>
                        <div class="mock-row"><div class="mock-ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div><div><em>Speed Simulator</em><small>main.lua · protected</small></div><span class="mock-tag">Active</span></div>
                        <div class="mock-row"><div class="mock-ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div><div><em>Tycoon Hub</em><small>hub.lua · protected</small></div><span class="mock-tag">Active</span></div>
                        <div class="mock-row"><div class="mock-ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div><div><em>Admin Tools</em><small>tools.lua · protected</small></div><span class="mock-tag off">Disabled</span></div>
                    </div>
                </div>
            </div>
        </section>

        <section class="features" id="features">
            <div class="section-head reveal">
                <span class="eyebrow">Features</span>
                <h2>Why Choose <span>Luavify?</span></h2>
                <p>Everything you need to ship scripts without worrying about leaks.</p>
            </div>
            <div class="feature-grid">
                <div class="feature-card spot reveal" style="--d:0s">
                    <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/></svg></div>
                    <h3>Military-Grade Obfuscation</h3>
                    <p>Our proprietary VM protects your code from decompilers and reverse engineers.</p>
                </div>
                <div class="feature-card spot reveal" style="--d:0.1s">
                    <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg></div>
                    <h3>Lightning Fast Loaders</h3>
                    <p>Loaders are hosted on Cloudflare's global edge network for zero-latency execution.</p>
                </div>
                <div class="feature-card spot reveal" style="--d:0.2s">
                    <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
                    <h3>Owner Controls</h3>
                    <p>Instantly disable scripts or kick exploiters with our real-time dashboard controls.</p>
                </div>
            </div>
        </section>

        <section class="showcase" id="protection">
            <div class="reveal">
                <span class="eyebrow">Protection</span>
                <h2>Your logic, <span>unreadable</span> to everyone else.</h2>
                <p class="lead">Luavify wraps your script in a protected virtual machine, so what leaks is noise instead of your source code.</p>
                <ul class="check-list">
                    <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg><span>Protected VM output that resists decompilers and reverse engineering</span></li>
                    <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg><span>Instantly disable scripts or kick exploiters from the dashboard</span></li>
                    <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg><span>Sign in with Discord and ship your first loader in minutes</span></li>
                </ul>
            </div>
            <div class="showcase-art reveal" style="--d:0.12s">
                    <svg viewBox="0 0 520 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Readable Lua script transformed into protected output by the Luavify VM">
                        <defs>
                            <linearGradient id="vg-card" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1b1f27"/><stop offset="1" stop-color="#11141a"/></linearGradient>
                            <linearGradient id="vg-red" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#f87171"/><stop offset="1" stop-color="#b91c1c"/></linearGradient>
                            <radialGradient id="vg-glow"><stop offset="0" stop-color="#ef4444" stop-opacity="0.55"/><stop offset="1" stop-color="#ef4444" stop-opacity="0"/></radialGradient>
                        </defs>
                        <rect x="14" y="30" width="190" height="150" rx="14" fill="url(#vg-card)" stroke="#ffffff" stroke-opacity="0.1"/>
                        <text x="30" y="54" fill="#9ca3af" font-family="Inter,sans-serif" font-size="11" font-weight="700">YOUR SCRIPT</text>
                        <rect x="30" y="70" width="70" height="8" rx="4" fill="#ef4444" opacity="0.8"/><rect x="108" y="70" width="50" height="8" rx="4" fill="#ffffff" opacity="0.25"/>
                        <rect x="42" y="90" width="110" height="8" rx="4" fill="#ffffff" opacity="0.22"/>
                        <rect x="42" y="110" width="80" height="8" rx="4" fill="#ffffff" opacity="0.22"/><rect x="130" y="110" width="40" height="8" rx="4" fill="#ef4444" opacity="0.6"/>
                        <rect x="30" y="130" width="40" height="8" rx="4" fill="#ef4444" opacity="0.8"/>
                        <rect x="30" y="150" width="120" height="8" rx="4" fill="#ffffff" opacity="0.22"/>
                        <g class="art-float">
                            <circle cx="260" cy="190" r="92" fill="url(#vg-glow)"/>
                            <path d="M260 126l52 20v40c0 34-22 60-52 74-30-14-52-40-52-74v-40z" fill="url(#vg-red)" stroke="#fecaca" stroke-opacity="0.35" stroke-width="2"/>
                            <path d="M260 146l34 13v27c0 22-14 40-34 50-20-10-34-28-34-50v-27z" fill="#0b0d11" opacity="0.55"/>
                            <rect x="246" y="186" width="28" height="22" rx="5" fill="#fff"/><path d="M251 186v-7a9 9 0 0 1 18 0v7" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round"/>
                        </g>
                        <path d="M206 105 C236 105 236 125 250 135" fill="none" stroke="#ef4444" stroke-width="2" stroke-dasharray="5 6" opacity="0.7"/>
                        <path d="M270 262 C290 280 300 280 316 280" fill="none" stroke="#ef4444" stroke-width="2" stroke-dasharray="5 6" opacity="0.7"/>
                        <rect x="316" y="200" width="190" height="150" rx="14" fill="url(#vg-card)" stroke="#ef4444" stroke-opacity="0.35"/>
                        <text x="332" y="224" fill="#f87171" font-family="Inter,sans-serif" font-size="11" font-weight="700">PROTECTED OUTPUT</text>
                        <g font-family="'JetBrains Mono',monospace" font-size="10" fill="#9ca3af" opacity="0.85">
                            <text x="332" y="248">0x4F 0xA1 0x9C 0x3E 0xD2</text>
                            <text x="332" y="266">LPH~jx#9k$Qz!vV0..8mF</text>
                            <text x="332" y="284">0xB7 0x12 0xE0 0x5A 0x7C</text>
                            <text x="332" y="302">qR%e@Xo^2LdN*u1;y&amp;Tw</text>
                            <text x="332" y="320">0x61 0xFF 0x08 0xC4 0x90</text>
                            <text x="332" y="338">z~V#4kP!m0Ws9aG|Hb(</text>
                        </g>
                    </svg>
            </div>
        </section>

        <section class="steps" id="how">
            <div class="section-head reveal">
                <span class="eyebrow">How it works</span>
                <h2>Protected in <span>three steps</span></h2>
            </div>
            <div class="steps-grid">
                <div class="step reveal" style="--d:0s"><div class="step-num">1</div><h3>Upload</h3><p>Sign in with Discord and add your script to a project.</p></div>
                <div class="step reveal" style="--d:0.12s"><div class="step-num">2</div><h3>Obfuscate</h3><p>Luavify wraps it in a protected VM in seconds.</p></div>
                <div class="step reveal" style="--d:0.24s"><div class="step-num">3</div><h3>Deploy</h3><p>Share one loader link. Manage everything from your dashboard.</p></div>
            </div>
        </section>

        <section class="pricing" id="pricing">
            <div class="section-head reveal">
                <span class="eyebrow">Pricing</span>
                <h2>Simple <span>pricing</span></h2>
                <p>Start free. Upgrade when you need more room.</p>
            </div>

            <div class="billing-toggle reveal" id="billing-toggle" role="group" aria-label="Billing period" style="--i:0">
                <span class="bt-thumb"></span>
                <button type="button" class="bt-btn active" data-period="month" onclick="setBilling('month')" aria-pressed="true">Monthly</button>
                <button type="button" class="bt-btn" data-period="year" onclick="setBilling('year')" aria-pressed="false">Yearly</button>
                <button type="button" class="bt-btn" data-period="life" onclick="setBilling('life')" aria-pressed="false">Lifetime</button>
            </div>

            <div class="pricing-grid">
                <div class="pricing-card spot reveal" style="--d:0s">
                    <h3>Basic</h3>
                    <div class="price">Free <span>forever</span></div>
                    <ul class="pricing-features">
                        <li>3 projects</li>
                        <li>3 scripts per project</li>
                        <li>30 obfuscations</li>
                        <li>Standard queue speed</li>
                        <li>Volt Obfuscations V7.7</li>
                    </ul>
                    <a href="/auth/login" class="pricing-btn">Get started</a>
                </div>

                <div class="pricing-card popular spot reveal" style="--d:0.15s">
                    <div class="popular-badge">Popular</div>
                    <h3>Premium</h3>
                    <div class="price"><b class="amt" data-month="$10" data-year="$99" data-life="$299">$10</b> <span class="per">/month</span></div>
                    <ul class="pricing-features">
                        <li>9 projects</li>
                        <li>3 scripts per project</li>
                        <li>Fast queue speed</li>
                        <li>Volt Obfuscations V7.7</li>
                        <li>Priority Support</li>
                    </ul>
                    <button onclick="openPremiumModal()" class="pricing-btn">Buy Keys</button>
                </div>

                <div class="pricing-card spot reveal" style="--d:0.3s">
                    <h3>Commercial</h3>
                    <div class="price"><b class="amt" data-month="$25" data-year="$199" data-life="$399">$25</b> <span class="per">/month</span></div>
                    <ul class="pricing-features">
                        <li>10 projects</li>
                        <li>10 scripts per project</li>
                        <li>100 obfuscations</li>
                        <li>Fast queue speed</li>
                        <li>Volt Obfuscations V7.7</li>
                        <li>Priority Support</li>
                    </ul>
                    <a href="https://discord.gg/MVCZjqwDgD" target="_blank" rel="noopener" class="pricing-btn" style="display: block; text-align: center; text-decoration: none;">Buy on Discord</a>
                </div>
            </div>
        </section>

        <!-- DISCORD BOT PAGE -->
        <section id="bot" class="bot-page-wrap">
            <div class="bot-hero reveal">
                <h1>Luavify Discord Bot</h1>
                <p>Let your users redeem keys, get the loader, and reset their HWID right inside your Discord server. No tickets needed.</p>
                <a href="https://discord.com/oauth2/authorize?client_id=1565360391280787547&permissions=268495872&integration_type=0&scope=bot+applications.commands" target="_blank" rel="noopener" class="bot-invite-btn">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>
                    Invite Bot
                </a>
                <p style="margin-top: 14px; font-size: 0.85rem; color: var(--text-muted);">Bot: Luavify Protector#4734 · ID: 1565360391280787547</p>
            </div>

            <div class="bot-section reveal">
                <h2>Setup</h2>
                <div class="bot-step">
                    <div class="bot-step-num">1</div>
                    <div class="bot-step-content">
                        <h3>Click "Invite Bot" above and add it to your server.</h3>
                    </div>
                </div>
                <div class="bot-step">
                    <div class="bot-step-num">2</div>
                    <div class="bot-step-content">
                        <h3>Open your Luavify settings, go to Profile and copy your API key.</h3>
                    </div>
                </div>
                <div class="bot-step">
                    <div class="bot-step-num">3</div>
                    <div class="bot-step-content">
                        <h3>In your server, run this command:</h3>
                        <p><code>/linkapi [YOUR API KEY]</code></p>
                    </div>
                </div>
                <div class="bot-warning">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <p><strong>Important:</strong> Your API key gives full access to your account through the bot. Never share it, and run <code>/linkapi</code> in a private channel. If it leaks, reset it from your Settings page.</p>
                </div>
            </div>

            <div class="bot-section reveal">
                <h2>What your users can do</h2>
                <p style="margin-bottom: 24px; color: var(--text-muted);">Everything is handled through buttons and dropdown menus, so there is nothing for users to type.</p>
                <div class="bot-feature-grid">
                    <div class="bot-feature">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="7.5" cy="15.5" r="5.5"/><path d="M21 2l-9.6 9.6"/><path d="M15.5 7.5l3 3L22 7l-3-3"/></svg>
                        <div>
                            <h4>Redeem key</h4>
                            <p>Link a key from your get-key page to their Discord account.</p>
                        </div>
                    </div>
                    <div class="bot-feature">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                        <div>
                            <h4>Get script</h4>
                            <p>Receive their personal loader with the key already filled in.</p>
                        </div>
                    </div>
                    <div class="bot-feature">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                        <div>
                            <h4>Check status</h4>
                            <p>See whether the key is active, expired or blacklisted, and when it ends.</p>
                        </div>
                    </div>
                    <div class="bot-feature">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2v6h-6"/><path d="M3 12a9 9 0 0 1 15-6.7L21 8"/><path d="M3 22v-6h6"/><path d="M21 12a9 9 0 0 1-15 6.7L3 16"/></svg>
                        <div>
                            <h4>Reset HWID</h4>
                            <p>Move the key to a new device, limited by the cooldown you set in the reward.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bot-section reveal">
                <h2>Data collection & privacy</h2>
                <p style="margin-bottom: 20px; color: var(--text-muted);">The bot collects very little data. This includes:</p>
                <ul class="check-list" style="margin-bottom: 24px;">
                    <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg><span>Your Discord ID and username, provided by Discord when a user clicks a button such as Reset HWID.</span></li>
                    <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg><span>Channel IDs, server IDs and message IDs (only for messages sent by the bot itself).</span></li>
                    <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg><span>Your API key, notes, dates, or anything else you type into command fields, the same as when you use the dashboard.</span></li>
                </ul>
                <div style="display: flex; flex-direction: column; gap: 12px; color: var(--text-muted); font-size: 0.95rem;">
                    <div style="display: flex; gap: 10px; align-items: center;"><span style="color: var(--accent-red); font-weight: bold; font-size: 1.2rem;">✗</span> The bot cannot see IP addresses.</div>
                    <div style="display: flex; gap: 10px; align-items: center;"><span style="color: var(--accent-red); font-weight: bold; font-size: 1.2rem;">✗</span> The bot does not read user messages.</div>
                    <div style="display: flex; gap: 10px; align-items: center;"><span style="color: var(--accent-red); font-weight: bold; font-size: 1.2rem;">✗</span> The bot never sends direct messages to any user.</div>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 50px;" class="reveal">
                <h3 style="font-size: 1.4rem; font-weight: 700; margin-bottom: 16px;">Need help?</h3>
                <p style="color: var(--text-muted); margin-bottom: 24px;">If the bot does not respond or you cannot invite it, ask in our Discord server.</p>
                <a href="https://discord.gg/MVCZjqwDgD" target="_blank" rel="noopener" class="hero-btn" style="padding: 14px 34px;">Join Discord</a>
            </div>
        </section>

        <!-- TERMS + PRIVACY -->
        <section class="legal" id="terms">
            <div class="section-head reveal">
                <span class="eyebrow">Legal</span>
                <h2>Terms &amp; <span>Privacy</span></h2>
                <p>The rules of the road for using Luavify, and how we handle your data.</p>
            </div>

            <div class="legal-wrap">
                <aside class="legal-toc reveal">
                    <h4>Terms of Service</h4>
                    <a href="#tos-1" data-scroll>1. Acceptance</a>
                    <a href="#tos-2" data-scroll>2. Updates</a>
                    <a href="#tos-3" data-scroll>3. Responsibilities</a>
                    <a href="#tos-4" data-scroll>4. Your content</a>
                    <a href="#tos-5" data-scroll>5. Keys &amp; devices</a>
                    <a href="#tos-6" data-scroll>6. Prohibited</a>
                    <a href="#tos-7" data-scroll>7. Enforcement</a>
                    <a href="#tos-8" data-scroll>8. Availability</a>
                    <a href="#tos-9" data-scroll>9. Liability</a>
                    <a href="#tos-10" data-scroll>10. Third parties</a>
                    <a href="#tos-11" data-scroll>11. Contact</a>
                    <div class="toc-sep"></div>
                    <h4>Privacy Policy</h4>
                    <a href="#privacy" data-scroll>Jump to Privacy</a>
                </aside>

                <div>
                    <article class="legal-doc reveal">
                        <h2>Terms of Service</h2>
                        <p class="lead">Scroll down or <a href="#privacy" data-scroll>click here</a> for the privacy policy.</p>
                        <span class="meta">By using this website, you accept these terms</span>
                        <p class="lead">Please read them carefully.</p>

                        <div class="legal-sec" id="tos-1">
                            <h3><span class="n">01</span>Your acceptance of this agreement</h3>
                            <p>These terms and conditions, together with any documents they expressly incorporate by reference (including our Privacy Policy below), form a legal agreement between you and Luavify ("we", "us").</p>
                            <p class="caps">BY USING OUR SERVICE, YOU:</p>
                            <ul class="caps">
                                <li>ACCEPT AND AGREE TO BE BOUND BY AND COMPLY WITH THIS AGREEMENT; AND</li>
                                <li>AGREE THAT IF YOU ACCESS THE WEBSITE FROM A JURISDICTION WHERE IT IS NOT PERMITTED, YOU DO SO AT YOUR OWN RISK.</li>
                            </ul>
                            <p>If you do not agree, do not use the service.</p>
                        </div>

                        <div class="legal-sec" id="tos-2">
                            <h3><span class="n">02</span>Updates to this agreement or the website</h3>
                            <p>We may change this agreement, the website, and its content at any time without notice. Changes take effect as soon as they are posted and apply to everyone who continues to use the website.</p>
                        </div>

                        <div class="legal-sec" id="tos-3">
                            <h3><span class="n">03</span>Your responsibilities</h3>
                            <p>You are responsible for making sure everyone who uses your account or your scripts knows about and follows this agreement. Information you give us must be accurate, current, and complete.</p>
                            <p>Your account, your keys, and any other credentials we give you are confidential. Do not share them. Tell us immediately if you notice any unauthorized access to your account. You are responsible for any misuse or unauthorized access that happens because of how you handled your credentials.</p>
                        </div>

                        <div class="legal-sec" id="tos-4">
                            <h3><span class="n">04</span>Your content (scripts)</h3>
                            <ul>
                                <li>You keep ownership of the scripts you upload. You give us permission to store, obfuscate, and deliver them as part of the service.</li>
                                <li>You must have the right to upload everything you submit.</li>
                                <li>You must not upload malicious code, including code that steals accounts, cookies, tokens, passwords, or personal data, or code that harms users' devices.</li>
                                <li>You are responsible for your scripts and for how your users use them. We are not responsible for any ban, loss, or damage caused by your scripts.</li>
                            </ul>
                        </div>

                        <div class="legal-sec" id="tos-5">
                            <h3><span class="n">05</span>Keys and devices</h3>
                            <ul>
                                <li>A key is locked to the first device that uses it. Do not try to share, resell, or transfer keys to get around this.</li>
                                <li>Keys expire after the time set by the script owner. Extending or renewing a key is up to the script owner's settings.</li>
                                <li>You must complete key checkpoints honestly. Using bypass tools or skipping steps is not allowed.</li>
                            </ul>
                        </div>

                        <div class="legal-sec" id="tos-6">
                            <h3><span class="n">06</span>Prohibited activities</h3>
                            <p>You are not allowed to bypass or break the security of our services, including but not limited to:</p>
                            <ul>
                                <li>flooding or spamming API endpoints;</li>
                                <li>interfering with the operation of the website or the servers it is hosted on;</li>
                                <li>running security scans against the website or any network or server it is connected to;</li>
                                <li>attempting to reverse engineer, decompile, disassemble, crack, modify, or otherwise degrade the function of scripts protected by Luavify, or running them outside the official loader;</li>
                                <li>bypassing or tampering with key checkpoints, key systems, or device locks;</li>
                                <li>helping or encouraging others to do any of the above;</li>
                                <li>attempting unauthorized access to the website or any connected network or server;</li>
                                <li>sending malicious packets or requests.</li>
                            </ul>
                        </div>

                        <div class="legal-sec" id="tos-7">
                            <h3><span class="n">07</span>What we may do if you break these rules</h3>
                            <p>If you carry out, or help someone else carry out, any prohibited activity, we may take any action we consider appropriate at our sole discretion, including but not limited to:</p>
                            <ul>
                                <li>suspending or ending your access to the service (ban);</li>
                                <li>deleting or disabling any scripts you created;</li>
                                <li>blacklisting your IP address from our network; and/or</li>
                                <li>pursuing any other remedy we consider appropriate.</li>
                            </ul>
                        </div>

                        <div class="legal-sec" id="tos-8">
                            <h3><span class="n">08</span>Service availability and disclaimer</h3>
                            <p>The service is provided "as is" and "as available", without warranties of any kind. We do not promise that it will always be online, error-free, or that obfuscation can never be broken. We may change, limit, or stop any part of the service at any time, including usage limits per account.</p>
                        </div>

                        <div class="legal-sec" id="tos-9">
                            <h3><span class="n">09</span>Limitation of liability</h3>
                            <p>To the maximum extent allowed by law, Luavify is not liable for any indirect, incidental, or consequential damages, or for any loss of data, scripts, profits, or accounts (including third-party accounts) that results from using or not being able to use the service.</p>
                        </div>

                        <div class="legal-sec" id="tos-10">
                            <h3><span class="n">10</span>Third parties</h3>
                            <p>Luavify is not affiliated with, endorsed by, or sponsored by Roblox Corporation, Discord, Linkvertise, or LootLabs. Their names belong to their owners. Your use of their services is subject to their own terms.</p>
                        </div>

                        <div class="legal-sec" id="tos-11">
                            <h3><span class="n">11</span>Contact</h3>
                            <p>Questions about these terms: <a class="inline" href="https://discord.gg/MVCZjqwDgD" target="_blank" rel="noopener">https://discord.gg/MVCZjqwDgD</a></p>
                        </div>
                    </article>

                    <article class="legal-doc reveal" id="privacy">
                        <h2>Privacy Policy</h2>
                        <p class="lead">This policy explains what data Luavify collects and how it is used.</p>

                        <div class="legal-sec">
                            <h3><span class="n">01</span>Information we collect</h3>
                            <ul>
                                <li><strong>Account info:</strong> when you log in with Discord, we receive your Discord ID, username, and avatar. We do not receive your email or password.</li>
                                <li><strong>Your content:</strong> the scripts you upload (stored in obfuscated form), project, script, reward, and checkpoint settings.</li>
                                <li><strong>Usage info:</strong> monthly counts of executions and obfuscations, and the last time you were active on the dashboard.</li>
                                <li><strong>Technical info when a script is run:</strong> your IP address, device identifier (HWID), and the key used, so we can enforce key and device locks and prevent abuse.</li>
                                <li><strong>Key system info:</strong> an anonymous visitor ID (stored in a cookie) that tracks checkpoint progress and the keys issued to that browser.</li>
                            </ul>
                        </div>

                        <div class="legal-sec">
                            <h3><span class="n">02</span>How we use it</h3>
                            <ul>
                                <li>To run the service: log you in, store your scripts, deliver them through the loader, and issue keys.</li>
                                <li>To protect the service: detect abuse, bypasses, cracking attempts, and enforce bans.</li>
                                <li>To show you usage statistics on your dashboard.</li>
                            </ul>
                            <p>We do not sell your personal data.</p>
                        </div>

                        <div class="legal-sec">
                            <h3><span class="n">03</span>Cookies</h3>
                            <p>We use only essential cookies: a signed session cookie to keep you logged in (7 days), a temporary cookie used during Discord login, and a visitor cookie for the key system (up to 1 year). We do not use advertising or tracking cookies of our own.</p>
                        </div>

                        <div class="legal-sec">
                            <h3><span class="n">04</span>Third-party services</h3>
                            <p>To work, the service relies on third parties that receive some data under their own policies: Discord (login), Cloudflare (security, bot checks, and delivery), and Linkvertise and LootLabs (key checkpoints; they may show ads and collect their own data).</p>
                        </div>

                        <div class="legal-sec">
                            <h3><span class="n">05</span>How long we keep data</h3>
                            <p>Account data and scripts are kept until you delete them or ask us to. Short-lived security tokens are deleted automatically within minutes. Delivery and abuse logs (IP, device identifier, key) are kept as long as needed to prevent abuse.</p>
                        </div>

                        <div class="legal-sec">
                            <h3><span class="n">06</span>Your choices</h3>
                            <p>You can delete your scripts and rewards at any time from the dashboard. To request deletion of your account data, contact us on Discord (link above).</p>
                        </div>

                        <div class="legal-sec">
                            <h3><span class="n">07</span>Security</h3>
                            <p>We use reasonable measures to protect your data, but no system is 100% secure and we cannot guarantee absolute security.</p>
                        </div>

                        <div class="legal-sec">
                            <h3><span class="n">08</span>Changes to this policy</h3>
                            <p>We may update this policy at any time. Changes take effect when posted on this page. Continuing to use the service means you accept the updated policy.</p>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <section class="cta">
            <div class="cta-box reveal">
                <h2>Ready to protect your scripts?</h2>
                <p>Sign in with Discord and obfuscate your first script in under a minute.</p>
                <a href="/auth/login" class="hero-btn">Get Started for Free</a>
            </div>
        </section>

        <footer class="landing-footer">
            <p>
                © 2026 Luavify
                · <a href="https://luavify-protector.itskevin.workers.dev/faq" target="_blank">FAQ</a>
                · <a href="#terms" data-scroll>Terms</a>
                · <a href="#privacy" data-scroll>Privacy</a>
                · <a href="https://discord.gg/MVCZjqwDgD" target="_blank" rel="noopener">Discord</a>
            </p>
        </footer>
    </div>

    <!-- Mobile Header -->
    <div class="mobile-header" id="mobile-header" style="display: none;">
        <div class="brand" style="font-size: 1.2rem; font-weight: 800; display: flex; align-items: center; gap: 10px;">
            <img src="https://i.ibb.co/k2GbYLyX/logo.png" style="width: 28px; height: 28px;">
            Luavify
        </div>
        <button class="mobile-menu-btn" id="mobile-menu-btn" onclick="toggleDrawer()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
        </button>
    </div>

    <!-- Mobile Drawer -->
    <div class="drawer-backdrop" id="drawer-backdrop" onclick="toggleDrawer()"></div>
    <div class="mobile-drawer" id="mobile-drawer">
        <div class="brand">
            <img src="https://i.ibb.co/k2GbYLyX/logo.png" style="width: 30px; height: 30px;">
            Luavify
        </div>
        <a class="nav-item active" onclick="navigate('projects', this); toggleDrawer();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg>
            <span class="nav-label" data-i18n="nav_projects">Projects</span>
        </a>
        <a class="nav-item" onclick="navigate('dashboard', this); toggleDrawer();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
            <span class="nav-label" data-i18n="nav_dashboard">Dashboard</span>
        </a>
        <!-- FIXED: Added missing mobile nav items -->
        <a class="nav-item" onclick="navigate('key-system', this); accessCategory='keys'; renderAccessCategory(); toggleDrawer();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="15" r="5"></circle><path d="M11.5 11.5 21 2l1 1-2 2 2 2-3 3-2-2-3.5 3.5"></path></svg>
            Key System
        </a>
        <a class="nav-item" onclick="navigate('whitelist', this); accessCategory='whitelist'; renderAccessCategory(); toggleDrawer();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 6 9 17l-5-5"></path><circle cx="12" cy="12" r="10"></circle></svg>
            Whitelist
        </a>
        <a class="nav-item" onclick="navigate('blacklist', this); accessCategory='blacklist'; renderAccessCategory(); toggleDrawer();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="m5 5 14 14"></path></svg>
            Blacklist
        </a>
        <a class="nav-item" onclick="navigate('discordbot', this); toggleDrawer();">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor" aria-hidden="true"><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>
            Discord Bot
        </a>
        
        <a class="nav-item hidden" id="mobile-admin-tab" onclick="navigate('admin', this); toggleDrawer(); loadAdminData();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
            <span class="nav-label" data-i18n="nav_admin">Admin Panel</span>
        </a>
        <a class="nav-item" onclick="navigate('settings', this); toggleDrawer();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
            <span class="nav-label" data-i18n="nav_settings">Settings</span>
        </a>
        <div style="margin-top: auto;">
            <a class="nav-item" href="https://discord.gg/MVCZjqwDgD" target="_blank" rel="noopener" style="text-decoration: none; color: inherit;">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor" aria-hidden="true"><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>
                Community
            </a>
            <button onclick="logout()" class="nav-item" style="background: transparent; width: 100%; text-align: left;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                <span class="nav-label" data-i18n="nav_logout">Log out</span>
            </button>
        </div>
    </div>

    <div id="app-dashboard">
        <header class="desktop-header" id="desktop-header">
            <button type="button" class="mobile-menu-btn sidebar-toggle" id="sidebar-toggle" onclick="toggleSidebar()" aria-label="Toggle sidebar" aria-expanded="false" title="Toggle sidebar">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
            </button>
        </header>
        <aside class="sidebar">
            <div class="brand-icon">
                <img src="https://i.ibb.co/k2GbYLyX/logo.png" alt="Luavify Logo">
                <span class="brand-text">Luavify</span>
            </div>
            <nav class="nav-menu">
                <a href="#" class="nav-item active" onclick="navigate('projects', this); return false;" title="Projects">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg><span class="nav-label" data-i18n="nav_projects">Projects</span>
                </a>
                <a href="#" class="nav-item" onclick="navigate('key-system', this); accessCategory='keys'; renderAccessCategory(); return false;" title="Key System">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="15" r="5"></circle><path d="M11.5 11.5 21 2l1 1-2 2 2 2-3 3-2-2-3.5 3.5"></path></svg><span class="nav-label">Key System</span>
                </a>
                <a href="#" class="nav-item" onclick="navigate('whitelist', this); accessCategory='whitelist'; renderAccessCategory(); return false;" title="Whitelist">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 6 9 17l-5-5"></path><circle cx="12" cy="12" r="10"></circle></svg><span class="nav-label">Whitelist</span>
                </a>
                <a href="#" class="nav-item" onclick="navigate('blacklist', this); accessCategory='blacklist'; renderAccessCategory(); return false;" title="Blacklist">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="m5 5 14 14"></path></svg><span class="nav-label">Blacklist</span>
                </a>
                <a href="#" class="nav-item" onclick="navigate('discordbot', this); return false;" title="Discord Bot">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor" aria-hidden="true"><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg><span class="nav-label">Discord Bot</span>
                </a>
                <a href="#" class="nav-item" onclick="navigate('dashboard', this); return false;" title="Dashboard">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg><span class="nav-label" data-i18n="nav_dashboard">Dashboard</span>
                </a>
                <a href="#" class="nav-item hidden" id="admin-tab" onclick="navigate('admin', this); loadAdminData(); return false;" title="Admin Panel">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg><span class="nav-label" data-i18n="nav_admin">Admin Panel</span>
                </a>
            </nav>
            <div class="sidebar-footer">
                <a class="community-link" href="https://discord.gg/MVCZjqwDgD" target="_blank" rel="noopener" title="Community">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor" aria-hidden="true"><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>
                    <span class="cl-text"><strong>Community</strong><small>discord.gg/MVCZjqwDgD</small></span>
                </a>
                <div class="user-card" id="user-card" role="link" tabindex="0" title="Settings" onclick="navigate('settings', this)" onkeydown="if(event.key==='Enter'||event.key===' '){event.preventDefault();navigate('settings', this);}">
                    <img id="sb-avatar" class="uc-avatar" src="https://cdn.discordapp.com/embed/avatars/0.png" alt="">
                    <span class="uc-text"><strong id="sb-username">...</strong><small data-i18n="nav_settings">Settings</small></span>
                    <span class="uc-actions">
                        <svg class="uc-gear" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                        <button type="button" class="uc-logout" title="Log out" aria-label="Log out" onclick="event.stopPropagation(); logout();"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></button>
                    </span>
                </div>
            </div>
        </aside>

        <main class="main-content">
            <div id="dashboard" class="page">
                <h1 data-i18n="title_dashboard">Dashboard</h1>
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-header" data-i18n="stat_obfs">Monthly obfuscations</div><div class="stat-value" id="dash-obfuscations">0</div></div>
                    <div class="stat-card"><div class="stat-header" data-i18n="stat_projects">Projects</div><div class="stat-value" id="dash-project-count">0</div></div>
                    <div class="stat-card"><div class="stat-header" data-i18n="stat_scripts">Scripts</div><div class="stat-value" id="dash-scripts">0</div></div>
                    <div class="stat-card"><div class="stat-header" data-i18n="stat_execs">Executions</div><div class="stat-value" id="dash-executions">0</div></div>
                </div>
                <div class="activity-card">
                    <div class="activity-head">
                        <div><h3>Activity</h3><p id="activity-sub">Script executions per day, last 30 days</p></div>
                        <div class="activity-range" id="activity-range">
                            <button data-range="7" onclick="setActivityRange(7)">7D</button>
                            <button data-range="30" class="active" onclick="setActivityRange(30)">30D</button>
                            <button data-range="90" onclick="setActivityRange(90)">90D</button>
                        </div>
                    </div>
                    <div class="activity-chart" id="activity-chart"></div>
                </div>
            </div>

            <div id="projects" class="page active">
                <h1 data-i18n="title_projects">Projects</h1>
                <div id="lock-banner" style="display:none;"></div>
                <div id="projects-container"></div>
                <div style="display: flex; flex-direction: column; align-items: center; margin-top: 40px; gap: 10px;">
                    <button class="btn btn-primary" id="create-project-btn" onclick="openProjectModal()" style="padding: 14px 28px;" data-i18n="btn_create">Create New Project</button>
                    <p class="hint" id="project-limit-hint" style="font-size: 0.85rem; color: var(--text-muted);">0/3 projects used</p>
                </div>
            </div>

            <div id="key-system" class="page access-page">
                <h1>Key System</h1>
                <p style="color:var(--text-muted);margin:8px 0 22px;">Generate single-use keys, check redemption status, and delete keys for your scripts.</p>
                <div class="panel" style="margin-bottom:18px;">
                    <label for="access-script-keys" style="display:block;margin-bottom:8px;font-weight:700;">Select script</label>
                    <select id="access-script-keys" class="access-script-select" onchange="renderAccessCategory()" style="width:100%;max-width:560px;"></select>
                    <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:16px;align-items:end;">
                        <label>Expiry in days (0 = never)<input id="access-key-days" type="number" min="0" max="3650" value="0" style="display:block;margin-top:6px;max-width:200px;"></label>
                        <label>Max redemptions<input id="access-key-uses" type="number" min="1" max="10000" value="1" style="display:block;margin-top:6px;max-width:200px;"></label>
                        <button class="btn btn-primary" onclick="createDashboardAccessKey()">＋ Generate Key</button>
                        <button class="btn btn-outline" onclick="renderAccessCategory()">Refresh</button>
                    </div>
                    <div id="access-key-created" style="display:none;margin-top:14px;"></div>
                </div>
                <div class="panel"><h3 style="margin-bottom:14px;">Generated keys</h3><div id="access-key-list" class="access-table-wrap">Select a script to load keys.</div></div>
            </div>
            <div id="whitelist" class="page access-page">
                <h1>Whitelist</h1><p style="color:var(--text-muted);margin:8px 0 22px;">Allow a Discord user to access a script. A random key is generated for each whitelist entry.</p>
                <div class="panel" style="margin-bottom:18px;">
                    <label for="access-script-whitelist" style="display:block;margin-bottom:8px;font-weight:700;">Select script</label><select id="access-script-whitelist" class="access-script-select" onchange="renderAccessCategory()" style="width:100%;max-width:560px;"></select>
                    <div style="display:flex;gap:10px;flex-wrap:wrap;align-items:end;margin-top:16px;"><label>Discord user ID<input id="access-wl-user" placeholder="123456789012345678" style="display:block;margin-top:6px;"></label><label>Expiry in days (0 = never)<input id="access-wl-days" type="number" min="0" max="3650" value="0" style="display:block;margin-top:6px;"></label><button class="btn btn-primary" onclick="addDashboardAccessUser('whitelist')">＋ Whitelist User</button><button class="btn btn-outline" onclick="renderAccessCategory()">Refresh</button></div><div id="access-wl-created" style="display:none;margin-top:14px;"></div>
                </div><div class="panel"><h3 style="margin-bottom:14px;">Whitelisted users</h3><div id="access-whitelist-list" class="access-table-wrap">Select a script to load users.</div></div>
            </div>
            <div id="blacklist" class="page access-page">
                <h1>Blacklist</h1><p style="color:var(--text-muted);margin:8px 0 22px;">Block a Discord user from accessing a script. Blacklisted users' runtime access is revoked.</p>
                <div class="panel" style="margin-bottom:18px;">
                    <label for="access-script-blacklist" style="display:block;margin-bottom:8px;font-weight:700;">Select script</label><select id="access-script-blacklist" class="access-script-select" onchange="renderAccessCategory()" style="width:100%;max-width:560px;"></select>
                    <div style="display:flex;gap:10px;flex-wrap:wrap;align-items:end;margin-top:16px;"><label>Discord user ID<input id="access-bl-user" placeholder="123456789012345678" style="display:block;margin-top:6px;"></label><label>Expiry in days (0 = never)<input id="access-bl-days" type="number" min="0" max="3650" value="0" style="display:block;margin-top:6px;"></label><label>Reason (optional)<input id="access-bl-reason" placeholder="Reason" style="display:block;margin-top:6px;"></label><button class="btn btn-primary" onclick="addDashboardAccessUser('blacklist')">＋ Blacklist User</button><button class="btn btn-outline" onclick="renderAccessCategory()">Refresh</button></div>
                </div><div class="panel"><h3 style="margin-bottom:14px;">Blacklisted users</h3><div id="access-blacklist-list" class="access-table-wrap">Select a script to load users.</div></div>
            </div>

            <div id="discordbot" class="page db-page">
                <h1>Discord Bot</h1>
                <p class="db-sub">Add the bot to your server, then post a buyer panel, set the buyer role, cap self-service HWID resets and choose who can manage the bot — all from here.</p>

                <section class="db-card">
                    <div class="db-card-head">
                        <div>
                            <h3>Your servers</h3>
                            <p class="db-hint">Press <b>Add bot</b>, pick a server you manage, and it appears here automatically.</p>
                        </div>
                        <a class="btn btn-primary db-add" href="/auth/bot-add">
                            <svg class="db-ico" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>
                            Add bot
                        </a>
                    </div>
                    <div id="db-servers-list" class="db-servers" aria-live="polite"><div class="db-skel"></div><div class="db-skel"></div></div>
                </section>

                <div id="db-server-detail" style="display:none;">
                    <section class="db-card">
                        <div class="db-card-head" style="margin-bottom:14px;">
                            <div>
                                <h3>Script</h3>
                                <p class="db-hint">Panel, buyer role and HWID limit are saved per script.</p>
                            </div>
                        </div>
                        <div class="db-field" style="max-width:520px;"><select id="db-script-select" onchange="dbOnScriptChange()"></select></div>
                    </section>

                    <section class="db-card">
                        <div class="db-card-head">
                            <div>
                                <h3>Buyer panel</h3>
                                <p class="db-hint" id="db-detail-sub">Posting to <b>your server</b></p>
                            </div>
                        </div>
                        <div class="db-panel-layout">
                            <div class="db-stack">
                                <div class="db-field"><span class="db-label">Channel</span><select id="db-channel-select"></select></div>
                                <label class="db-field"><span class="db-label">Title</span><input id="db-panel-title" class="db-input" maxlength="256" placeholder="Buyer Control Panel" oninput="dbRenderPreview()"></label>
                                <div class="db-row2">
                                    <label class="db-field"><span class="db-label">Top line (above the title)</span><input id="db-panel-topline" class="db-input" maxlength="256" placeholder="Luavify" oninput="dbRenderPreview()"></label>
                                    <div class="db-field"><span class="db-label">Accent color</span>
                                        <div class="db-color-wrap"><input id="db-panel-color" class="db-color-input" type="color" value="#ef4444" oninput="dbRenderPreview()" aria-label="Accent color"><span class="db-color-hex" id="db-color-hex">#ef4444</span></div>
                                    </div>
                                </div>
                                <label class="db-field"><span class="db-label">Description</span><textarea id="db-panel-desc" class="db-textarea" rows="4" maxlength="4000" placeholder="Use the buttons below to redeem a key, reset your HWID, get your loadstring, or view your info." oninput="dbRenderPreview()"></textarea></label>
                                <label class="db-field"><span class="db-label">Footer</span><input id="db-panel-footer" class="db-input" maxlength="2048" placeholder="Luavify" oninput="dbRenderPreview()"></label>
                            </div>
                            <div class="db-preview-col">
                                <span class="db-label">Live preview</span>
                                <div class="dc-msg" id="db-preview" aria-label="Preview of the panel as it will look in Discord"></div>
                                <p class="db-hint" style="margin-top:10px;">This is how the panel will look in Discord. Supports <b>**bold**</b>, <b>*italic*</b> and <b>`code`</b> in the description.</p>
                            </div>
                        </div>
                        <div class="db-actions">
                            <button class="btn btn-primary" id="db-post-btn" onclick="dbPostPanel()">Post panel to channel</button>
                        </div>
                    </section>

                    <section class="db-card">
                        <div class="db-card-head" style="margin-bottom:14px;"><div><h3>Buyer role</h3><p class="db-hint">Granted automatically when someone redeems a key from the panel.</p></div></div>
                        <div class="db-inline">
                            <div class="db-field"><select id="db-buyerrole-select"></select></div>
                            <button class="btn btn-outline" onclick="dbSaveBuyerRole()">Save buyer role</button>
                        </div>
                    </section>

                    <section class="db-card">
                        <div class="db-card-head" style="margin-bottom:14px;"><div><h3>Self-service HWID resets</h3><p class="db-hint">Applies per Discord user on this script's Reset HWID button. Set resets to 0 to turn it off.</p></div></div>
                        <div class="db-inline">
                            <label class="db-field"><span class="db-label">Resets allowed</span><input id="db-hwid-resets" class="db-input" type="number" inputmode="numeric" min="0" max="1000" value="1"></label>
                            <label class="db-field"><span class="db-label">Per how many days</span><input id="db-hwid-days" class="db-input" type="number" inputmode="numeric" min="1" max="365" value="5"></label>
                            <button class="btn btn-outline" onclick="dbSaveHwidLimit()">Save</button>
                        </div>
                    </section>

                    <section class="db-card">
                        <div class="db-card-head" style="margin-bottom:14px;"><div><h3>Who can manage this server's bot</h3><p class="db-hint">Members with a selected role can use /whitelist, /blacklist, /generatekey and /resethwid here without linking their own API key.</p></div></div>
                        <div id="db-manager-roles-box" class="db-chips"></div>
                        <div class="db-actions" style="margin-top:16px;"><button class="btn btn-outline" onclick="dbSaveManagerRoles()">Save manager roles</button></div>
                    </section>
                </div>
            </div>

            <div id="admin" class="page">
                <h1 data-i18n="title_admin">Admin Panel</h1>
                
                <div class="panel">
                    <h3 style="font-size: 1.1rem; margin-bottom: 15px;" data-i18n="lbl_gen_key">Generate License Key</h3>
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <select id="key-duration">
                            <option value="1d">1 Day</option>
                            <option value="7d">7 Days</option>
                            <option value="30d">30 Days</option>
                            <option value="lifetime">Lifetime</option>
                        </select>
                        <button class="btn btn-primary" onclick="generateKey()" data-i18n="btn_gen">Generate</button>
                    </div>
                    <div id="generated-key-result" class="hidden" style="margin-top: 15px; padding: 15px; background: rgba(74,222,128,0.08); border: 1px solid rgba(74,222,128,0.3); border-radius: 8px;">
                        <div style="font-family: var(--font-mono); font-size: 1.2rem; color: #4ade80;" id="new-key-text"></div>
                    </div>
                </div>

                <div class="panel">
                    <h3 style="font-size: 1.1rem; margin-bottom: 15px;" data-i18n="lbl_manage">Manage User Premium</h3>
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <input type="text" id="manage-user-id" placeholder="Enter Discord ID" style="flex: 1; min-width: 200px; padding: 12px; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); border-radius: 8px; color: white; outline: none; font-family: var(--font-mono);">
                        <select id="manage-duration">
                            <option value="1">1 Day</option>
                            <option value="7">7 Days</option>
                            <option value="30">30 Days</option>
                            <option value="lifetime">Lifetime</option>
                        </select>
                        <button class="btn btn-primary" onclick="managePremium(false)" data-i18n="btn_give">Give</button>
                        <button class="btn btn-outline text-red" onclick="managePremium(true)" style="border-color: rgba(239,68,68,0.3);" data-i18n="btn_remove">Remove</button>
                    </div>
                </div>

                <div class="panel">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;">
                        <h3 style="font-size: 1.1rem; margin: 0;" data-i18n="lbl_users">Users</h3>
                        <input type="text" id="admin-search" onkeyup="filterAdminUsers()" placeholder="Search..." style="padding: 10px 15px; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); border-radius: 8px; color: white; outline: none; width: 250px;">
                    </div>
                    <div style="overflow-x: auto;">
                        <table class="script-table">
                            <thead>
                                <tr><th>User</th><th>ID</th><th>Key</th><th>Joined</th></tr>
                            </thead>
                            <tbody id="admin-users-table">
                                <tr><td colspan="4" style="text-align:center; padding: 20px;">Loading...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div id="settings" class="page">
                <h1 data-i18n="title_settings">Settings</h1>
                <div class="profile-grid">
                    <div class="panel">
                        <div class="user-header" style="display: flex; gap: 15px; align-items: center; margin-bottom: 20px;">
                            <img id="p-avatar" class="avatar" src="https://cdn.discordapp.com/embed/avatars/0.png" alt="Avatar">
                            <div><h2 id="p-username" style="font-size: 1.3rem; font-weight: 700;">Loading...</h2><p id="p-discord-id" style="color: var(--text-muted); font-size: 0.85rem;">...</p></div>
                        </div>
                        <ul style="list-style: none; padding: 0;">
                            <li style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.05);"><span style="color: var(--text-muted);" data-i18n="lbl_discord">Discord ID</span> <span id="p-id-val" style="font-family: var(--font-mono);">...</span></li>
                            <li style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.05);"><span style="color: var(--text-muted);" data-i18n="lbl_plan">Plan</span> <span id="p-plan" style="color: #fbbf24; font-weight: 700;">Basic</span></li>
                            <li style="display: flex; justify-content: space-between; padding: 12px 0;"><span style="color: var(--text-muted);" data-i18n="lbl_joined">Joined</span> <span id="p-joined">...</span></li>
                        </ul>
                    </div>
                    
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <div class="panel">
                            <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 10px;" data-i18n="lbl_redeem">Redeem Key</h3>
                            <div style="display: flex; gap: 10px;">
                                <input type="text" id="redeem-key-input" placeholder="Enter key..." style="flex: 1; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); color: white; padding: 12px; border-radius: 8px; outline: none; font-family: var(--font-mono);">
                                <button class="btn btn-primary" onclick="redeemKey()" data-i18n="btn_redeem">Redeem</button>
                            </div>
                        </div>

                        <div class="panel">
                            <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 10px;" data-i18n="lbl_api">API Key</h3>
                            <input type="password" id="p-api-key" value="Loading..." readonly style="width: 100%; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); color: white; padding: 12px; border-radius: 8px; margin-bottom: 15px; font-family: var(--font-mono);">
                            <div style="display: flex; gap: 10px;">
                                <button class="btn btn-outline" onclick="toggleApiKey()" data-i18n="btn_show">Show</button>
                                <button class="btn btn-primary" onclick="copyApiKey()" data-i18n="btn_copy">Copy</button>
                                <button class="btn btn-outline" style="margin-left: auto; color: #fca5a5; border-color: rgba(239,68,68,0.35);" onclick="resetApiKey()">Reset API key</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel" style="margin-top: 24px;">
                    <h3 style="font-size: 1.1rem; margin-bottom: 10px;" data-i18n="lbl_lang">Language</h3>
                    <p style="font-size: 0.9rem; color: var(--text-muted); margin-bottom: 20px;" data-i18n="lbl_lang_desc">Select your preferred language.</p>
                    <select id="language-select" onchange="changeLanguage()">
                        <option value="en">English</option>
                        <option value="es">Español</option>
                        <option value="fr">Français</option>
                        <option value="de">Deutsch</option>
                        <option value="zh">中文</option>
                        <option value="ja">日本語</option>
                        <option value="ru">Русский</option>
                        <option value="pt">Português</option>
                        <option value="vi">Tiếng Việt</option>
                    </select>
                </div>
                <div style="margin-top: 24px;">
                    <button type="button" class="btn btn-outline" style="color: #fca5a5; border-color: rgba(239,68,68,0.35);" onclick="logout()" data-i18n="nav_logout">Log out</button>
                </div>
            </div>
        </main>
    </div>

    <!-- Premium expired: choose which projects to lock -->
    <div id="lockModal" class="modal">
        <div class="modal-content" style="max-width: 520px;">
            <span style="position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.2rem; color: var(--text-muted);" onclick="closeLockModal()">&times;</span>
            <h2 id="lock-modal-title" style="font-size: 1.4rem; margin-bottom: 10px;">Premium expired</h2>
            <p id="lock-modal-desc" style="color: var(--text-muted); font-size: 0.9rem; line-height: 1.5; margin-bottom: 16px;"></p>
            <div id="lock-modal-list" style="display: flex; flex-direction: column; gap: 8px; max-height: 280px; overflow-y: auto; padding-right: 4px;"></div>
            <p id="lock-modal-count" style="margin-top: 14px; font-size: 0.85rem; color: var(--text-muted);"></p>
            <div class="modal-actions" style="justify-content: space-between; flex-wrap: wrap;">
                <a href="https://discord.gg/MVCZjqwDgD" target="_blank" class="btn btn-outline">Rebuy on Discord</a>
                <button class="btn btn-primary" id="lock-confirm-btn" onclick="submitLockChoice()" disabled style="opacity: 0.5;">Lock selected projects</button>
            </div>
        </div>
    </div>

    <!-- Custom Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content" style="max-width: 400px;">
            <h2 id="confirm-title" style="font-size: 1.3rem; margin-bottom: 15px;">Are you sure?</h2>
            <p id="confirm-msg" style="color: var(--text-muted); font-size: 0.95rem; line-height: 1.5;">Are you sure you want to delete this?</p>
            <div class="modal-actions">
                <button class="btn btn-outline" onclick="closeConfirmModal()">Cancel</button>
                <button class="btn btn-primary" id="confirm-btn-yes" style="background: #ef4444;">Yes, Delete</button>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <div id="projectModal" class="modal">
        <div class="modal-content">
            <h2 style="font-size: 1.3rem; margin-bottom: 15px;">Create Project</h2>
            <input type="text" id="new-project-name" class="modal-input" placeholder="Project name...">
            <div class="modal-actions">
                <button class="btn btn-outline" onclick="closeProjectModal()">Cancel</button>
                <button class="btn btn-primary" onclick="createProject()">Create</button>
            </div>
        </div>
    </div>

    <div id="scriptModal" class="modal">
        <div class="modal-content">
            <h2 style="font-size: 1.3rem; margin-bottom: 15px;">Upload Script</h2>
            <input type="text" id="script-name-input" class="modal-input" placeholder="Script name...">
            <div style="border: 2px dashed rgba(255,255,255,0.15); padding: 40px 20px; text-align: center; border-radius: 12px; cursor: pointer; margin-bottom: 15px; transition: 0.3s;" id="drop-area" onclick="document.getElementById('file-input').click()">
                <input type="file" id="file-input" accept=".lua,.luau,.txt" hidden>
                <div id="file-msg" style="color: var(--text-muted); font-size: 0.9rem;">Click to browse</div>
            </div>
            <div class="modal-actions">
                <button class="btn btn-outline" onclick="closeScriptModal()">Cancel</button>
                <button class="btn btn-primary" id="upload-btn" onclick="uploadScript()" disabled style="opacity: 0.5;">Upload</button>
            </div>
        </div>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content" style="max-width: 900px; height: 85vh; display: flex; flex-direction: column; padding: 0;">
            <div style="padding: 20px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap;">
                <h2 id="edit-modal-title" style="font-size: 1.2rem; margin: 0;">Edit Script</h2>
                <div style="display: flex; gap: 6px; background: rgba(255,255,255,0.05); padding: 4px; border-radius: 10px;">
                    <button class="btn" id="edit-tab-original" onclick="setEditTab('original')" style="padding: 6px 14px; font-size: 0.8rem;">Original</button>
                    <button class="btn" id="edit-tab-obfuscated" onclick="setEditTab('obfuscated')" style="padding: 6px 14px; font-size: 0.8rem;">Obfuscated</button>
                </div>
            </div>
            <div style="flex: 1; background: #000; min-height: 0;">
                <textarea id="edit-code-area" spellcheck="false" style="width: 100%; height: 100%; background: transparent; border: none; color: #a7f3d0; padding: 20px; font-family: var(--font-mono); font-size: 1rem; resize: none; outline: none;"></textarea>
                <textarea id="edit-obf-area" readonly spellcheck="false" style="display: none; width: 100%; height: 100%; background: transparent; border: none; color: #fca5a5; padding: 20px; font-family: var(--font-mono); font-size: 0.85rem; resize: none; outline: none; word-break: break-all;"></textarea>
            </div>
            <div style="padding: 15px 20px; border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; gap: 10px;">
                <span id="edit-hint" style="font-size: 0.8rem; color: var(--text-muted);"></span>
                <div style="display: flex; gap: 10px;">
                    <button class="btn btn-outline" onclick="closeEditModal()">Close</button>
                    <button class="btn btn-outline" id="edit-copy-obf" onclick="copyObfuscated()" style="display: none;">Copy obfuscated</button>
                    <button class="btn btn-primary" id="edit-save-btn" onclick="saveEditedCode()">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div id="premiumModal" class="modal">
        <div class="modal-content" style="max-width: 450px;">
            <span style="position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.2rem; color: var(--text-muted);" onclick="closePremiumModal()">&times;</span>
            <h2 style="font-size: 1.4rem; margin-bottom: 20px;">Premium</h2>
            <ul style="list-style: none; padding: 0; display: flex; flex-direction: column; gap: 15px; font-size: 0.9rem; color: var(--text-muted);">
                <li>• Invite codes give 30 days access.</li>
                <li>• You can stack multiple codes.</li>
                <li>• Codes have no expiry.</li>
                <li>• Contact <strong>@k3v1ndev</strong> for support.</li>
            </ul>
            <a href="https://discord.gg/MVCZjqwDgD" target="_blank" class="btn btn-primary" style="width: 100%; margin-top: 25px; justify-content: center;">Join Discord</a>
        </div>
    </div>

    <script>
        let currentUser = null;
        let projects = [];
        let projectIdCounter = 1;
        let currentProjectTarget = null;
        let selectedFile = null;
        let currentEditTarget = { projectId: null, scriptId: null };
        let adminUsersCache = []; 

        // --- LOGIN MODAL (Discord or API key) ---
        function openLoginModal() {
            document.getElementById('login-error').textContent = '';
            document.getElementById('loginModal').classList.add('active');
            setTimeout(() => document.getElementById('login-apikey').focus(), 50);
        }
        function closeLoginModal() {
            document.getElementById('loginModal').classList.remove('active');
        }
        async function submitApiKeyLogin() {
            const input = document.getElementById('login-apikey');
            const errEl = document.getElementById('login-error');
            const btn = document.getElementById('login-apikey-btn');
            const key = input.value.trim();
            if (!key) { errEl.textContent = 'Enter your API key.'; return; }
            btn.disabled = true; errEl.textContent = '';
            try {
                const res = await fetch('/auth/apikey', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ apiKey: key })
                });
                if (res.ok) { window.location.href = '/'; return; }
                errEl.textContent = 'That API key is not valid. Sign in with Discord first if you have not generated one yet.';
            } catch (e) {
                errEl.textContent = 'Could not reach the server. Try again.';
            }
            btn.disabled = false;
        }
        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('#landing-page a[href="/auth/login"]').forEach(a => {
                a.addEventListener('click', e => { e.preventDefault(); openLoginModal(); });
            });
            document.getElementById('login-apikey').addEventListener('keydown', e => {
                if (e.key === 'Enter') submitApiKeyLogin();
            });
            document.addEventListener('keydown', e => { if (e.key === 'Escape') closeLoginModal(); });
        });

        // --- LOGOUT FUNCTION ---
        function refreshPageTitle() {
            const app = document.getElementById('app-dashboard');
            if (!app || !app.classList.contains('active')) return;
            const page = app.querySelector('.page.active');
            const h1 = page && page.querySelector('h1');
            const name = h1 && h1.textContent.trim();
            if (name) document.title = name + ' | Luavify';
        }

        function logout() {
            window.location.href = "/auth/logout";
        }

        // --- CONFIRMATION MODAL LOGIC ---
        function showConfirm(msg, callback, opts) {
            document.getElementById('confirm-title').innerText = (opts && opts.title) || 'Are you sure?';
            document.getElementById('confirm-msg').innerText = msg;
            document.getElementById('confirmModal').classList.add('active');
            
            const yesBtn = document.getElementById('confirm-btn-yes');
            const newYesBtn = yesBtn.cloneNode(true);
            newYesBtn.innerText = (opts && opts.yes) || 'Yes, Delete';
            yesBtn.parentNode.replaceChild(newYesBtn, yesBtn);
            
            newYesBtn.addEventListener('click', () => {
                closeConfirmModal();
                callback();
            });
        }

        function closeConfirmModal() {
            document.getElementById('confirmModal').classList.remove('active');
        }

        // --- CUSTOM NOTIFICATIONS ---
        function showToast(message, type = 'info') {
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            let icon = '';
            if (type === 'error') icon = '❌';
            else if (type === 'success') icon = '✅';
            else icon = 'ℹ️';

            toast.innerHTML = `<span>${icon}</span> <span>${message}</span>`;
            container.appendChild(toast);

            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        // --- TRANSLATIONS ---
        const translations = {
            en: {
                nav_dashboard: "Dashboard", nav_projects: "Projects", nav_profile: "Profile", nav_admin: "Admin Panel", nav_settings: "Settings", nav_logout: "Log out",
                title_dashboard: "Dashboard", title_projects: "Projects", title_profile: "Profile", title_admin: "Admin Panel", title_settings: "Settings",
                stat_obfs: "Monthly obfuscations", stat_projects: "Projects", stat_execs: "Executions", stat_scripts: "Scripts",
                lbl_discord: "Discord ID", lbl_plan: "Plan", lbl_joined: "Joined",
                lbl_redeem: "Redeem Key", lbl_api: "API Key", btn_redeem: "Redeem", btn_show: "Show", btn_copy: "Copy",
                btn_create: "Create New Project", lbl_gen_key: "Generate License Key", btn_gen: "Generate",
                lbl_manage: "Manage User Premium", btn_give: "Give", btn_remove: "Remove", lbl_users: "Users",
                lbl_lang: "Language", lbl_lang_desc: "Select your preferred language."
            },
            vi: {
                nav_dashboard: "Bảng điều khiển", nav_projects: "Dự án", nav_profile: "Hồ sơ", nav_admin: "Quản trị", nav_settings: "Cài đặt", nav_logout: "Đăng xuất",
                title_dashboard: "Bảng điều khiển", title_projects: "Dự án", title_profile: "Hồ sơ", title_admin: "Bảng Quản Trị", title_settings: "Cài đặt",
                stat_obfs: "Số lần xáo trộn tháng này", stat_projects: "Dự án", stat_execs: "Lượt thực thi", stat_scripts: "Tập lệnh",
                lbl_discord: "ID Discord", lbl_plan: "Gói", lbl_joined: "Ngày tham gia",
                lbl_redeem: "Nhập Key", lbl_api: "Mã API", btn_redeem: "Nhập", btn_show: "Hiện", btn_copy: "Sao chép",
                btn_create: "Tạo Dự Án Mới", lbl_gen_key: "Tạo Key Bản Quyền", btn_gen: "Tạo",
                lbl_manage: "Quản Lý Premium", btn_give: "Cấp", btn_remove: "Thu hồi", lbl_users: "Người dùng",
                lbl_lang: "Ngôn ngữ", lbl_lang_desc: "Chọn ngôn ngữ của bạn."
            },
            es: {
                nav_dashboard: "Panel", nav_projects: "Proyectos", nav_profile: "Perfil", nav_admin: "Admin", nav_settings: "Ajustes", nav_logout: "Cerrar sesión",
                title_dashboard: "Panel", title_projects: "Proyectos", title_profile: "Perfil", title_admin: "Panel de Admin", title_settings: "Ajustes",
                stat_obfs: "Ofuscaciones mensuales", stat_projects: "Proyectos", stat_execs: "Ejecuciones", stat_scripts: "Scripts",
                lbl_discord: "ID de Discord", lbl_plan: "Plan", lbl_joined: "Se unió",
                lbl_redeem: "Canjear clave", lbl_api: "Clave API", btn_redeem: "Canjear", btn_show: "Mostrar", btn_copy: "Copiar",
                btn_create: "Crear Nuevo Proyecto", lbl_gen_key: "Generar Clave", btn_gen: "Generar",
                lbl_manage: "Gestionar Premium", btn_give: "Dar", btn_remove: "Quitar", lbl_users: "Usuarios",
                lbl_lang: "Idioma", lbl_lang_desc: "Selecciona tu idioma."
            },
            fr: {
                nav_dashboard: "Tableau", nav_projects: "Projets", nav_profile: "Profil", nav_admin: "Admin", nav_settings: "Paramètres", nav_logout: "Déconnexion",
                title_dashboard: "Tableau de bord", title_projects: "Projets", title_profile: "Profil", title_admin: "Panneau Admin", title_settings: "Paramètres",
                stat_obfs: "Obfuscations mensuelles", stat_projects: "Projets", stat_execs: "Exécutions", stat_scripts: "Scripts",
                lbl_discord: "ID Discord", lbl_plan: "Plan", lbl_joined: "Inscrit le",
                lbl_redeem: "Clé d'activation", lbl_api: "Clé API", btn_redeem: "Activer", btn_show: "Voir", btn_copy: "Copier",
                btn_create: "Créer un Projet", lbl_gen_key: "Générer une Clé", btn_gen: "Générer",
                lbl_manage: "Gérer Premium", btn_give: "Donner", btn_remove: "Retirer", lbl_users: "Utilisateurs",
                lbl_lang: "Langue", lbl_lang_desc: "Sélectionnez votre langue."
            },
            de: {
                nav_dashboard: "Dashboard", nav_projects: "Projekte", nav_profile: "Profil", nav_admin: "Admin", nav_settings: "Einstellungen", nav_logout: "Abmelden",
                title_dashboard: "Dashboard", title_projects: "Projekte", title_profile: "Profil", title_admin: "Admin Panel", title_settings: "Einstellungen",
                stat_obfs: "Monatliche Obfuskationen", stat_projects: "Projekte", stat_execs: "Ausführungen", stat_scripts: "Skripte",
                lbl_discord: "Discord ID", lbl_plan: "Plan", lbl_joined: "Beigetreten",
                lbl_redeem: "Schlüssel einlösen", lbl_api: "API-Schlüssel", btn_redeem: "Einlösen", btn_show: "Zeigen", btn_copy: "Kopieren",
                btn_create: "Neues Projekt", lbl_gen_key: "Schlüssel generieren", btn_gen: "Generieren",
                lbl_manage: "Premium verwalten", btn_give: "Geben", btn_remove: "Entfernen", lbl_users: "Benutzer",
                lbl_lang: "Sprache", lbl_lang_desc: "Wählen Sie Ihre Sprache."
            },
            zh: {
                nav_dashboard: "仪表板", nav_projects: "项目", nav_profile: "个人资料", nav_admin: "管理员", nav_settings: "设置", nav_logout: "登出",
                title_dashboard: "仪表板", title_projects: "项目", title_profile: "个人资料", title_admin: "管理员面板", title_settings: "设置",
                stat_obfs: "每月混淆次数", stat_projects: "项目", stat_execs: "执行次数", stat_scripts: "脚本",
                lbl_discord: "Discord ID", lbl_plan: "计划", lbl_joined: "加入时间",
                lbl_redeem: "兑换密钥", lbl_api: "API 密钥", btn_redeem: "兑换", btn_show: "显示", btn_copy: "复制",
                btn_create: "创建新项目", lbl_gen_key: "生成许可证密钥", btn_gen: "生成",
                lbl_manage: "管理高级版", btn_give: "给予", btn_remove: "移除", lbl_users: "用户",
                lbl_lang: "语言", lbl_lang_desc: "选择您的首选语言。"
            },
            ja: {
                nav_dashboard: "ダッシュボード", nav_projects: "プロジェクト", nav_profile: "プロフィール", nav_admin: "管理者", nav_settings: "設定", nav_logout: "ログアウト",
                title_dashboard: "ダッシュボード", title_projects: "プロジェクト", title_profile: "プロフィール", title_admin: "管理者パネル", title_settings: "設定",
                stat_obfs: "毎月の難読化", stat_projects: "プロジェクト", stat_execs: "実行回数", stat_scripts: "スクリプト",
                lbl_discord: "Discord ID", lbl_plan: "プラン", lbl_joined: "参加日",
                lbl_redeem: "キーを引き換える", lbl_api: "APIキー", btn_redeem: "引き換える", btn_show: "表示", btn_copy: "コピー",
                btn_create: "新しいプロジェクト", lbl_gen_key: "ライセンスキーを生成", btn_gen: "生成",
                lbl_manage: "プレミアム管理", btn_give: "付与", btn_remove: "削除", lbl_users: "ユーザー",
                lbl_lang: "言語", lbl_lang_desc: "言語を選択してください。"
            },
            ru: {
                nav_dashboard: "Панель", nav_projects: "Проекты", nav_profile: "Профиль", nav_admin: "Админ", nav_settings: "Настройки", nav_logout: "Выйти",
                title_dashboard: "Панель", title_projects: "Проекты", title_profile: "Профиль", title_admin: "Админ Панель", title_settings: "Настройки",
                stat_obfs: "Обфускаций в месяц", stat_projects: "Проекты", stat_execs: "Запуски", stat_scripts: "Скрипты",
                lbl_discord: "Discord ID", lbl_plan: "План", lbl_joined: "Дата входа",
                lbl_redeem: "Активировать ключ", lbl_api: "API Ключ", btn_redeem: "Активировать", btn_show: "Показать", btn_copy: "Копировать",
                btn_create: "Создать Проект", lbl_gen_key: "Генерация Ключа", btn_gen: "Генерировать",
                lbl_manage: "Управление Premium", btn_give: "Выдать", btn_remove: "Убрать", lbl_users: "Пользователи",
                lbl_lang: "Язык", lbl_lang_desc: "Выберите язык."
            },
            pt: {
                nav_dashboard: "Painel", nav_projects: "Projetos", nav_profile: "Perfil", nav_admin: "Admin", nav_settings: "Configurações", nav_logout: "Sair",
                title_dashboard: "Painel", title_projects: "Projetos", title_profile: "Perfil", title_admin: "Painel Admin", title_settings: "Configurações",
                stat_obfs: "Ofuscações mensais", stat_projects: "Projetos", stat_execs: "Execuções", stat_scripts: "Scripts",
                lbl_discord: "ID do Discord", lbl_plan: "Plano", lbl_joined: "Entrou em",
                lbl_redeem: "Resgatar Chave", lbl_api: "Chave API", btn_redeem: "Resgatar", btn_show: "Mostrar", btn_copy: "Copiar",
                btn_create: "Criar Projeto", lbl_gen_key: "Gerar Chave", btn_gen: "Gerar",
                lbl_manage: "Gerenciar Premium", btn_give: "Dar", btn_remove: "Remover", lbl_users: "Usuários",
                lbl_lang: "Idioma", lbl_lang_desc: "Selecione seu idioma."
            }
        };

        function toggleDrawer() {
            document.getElementById('mobile-drawer').classList.toggle('open');
            document.getElementById('drawer-backdrop').classList.toggle('open');
            const btn = document.getElementById('mobile-menu-btn');
            if (btn) btn.classList.toggle('open');
        }

        function openPremiumModal() { document.getElementById('premiumModal').classList.add('active'); }
        function closePremiumModal() { document.getElementById('premiumModal').classList.remove('active'); }

        function changeLanguage() {
            const lang = document.getElementById('language-select').value;
            localStorage.setItem('luavify_lang', lang);
            applyLanguage();
        }

        function applyLanguage() {
            let lang = localStorage.getItem('luavify_lang') || 'en';
            if (!translations[lang]) lang = 'en';
            
            document.getElementById('language-select').value = lang;
            document.getElementById('language-select').syncCustom?.();
            const dict = translations[lang];

            document.querySelectorAll('[data-i18n]').forEach(el => {
                const key = el.getAttribute('data-i18n');
                if (dict[key]) el.innerText = dict[key];
            });
            refreshPageTitle();
        }

        async function redeemKey() {
            const key = document.getElementById('redeem-key-input').value.trim();
            if (!key) return showToast("Please enter a key.", "error");
            
            try {
                const res = await fetch('/api/redeem', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ key })
                });
                
                const data = await res.json();
                
                if (res.ok && data.success) {
                    showToast("Key redeemed successfully! You are now Premium.", "success");
                    document.getElementById('redeem-key-input').value = '';
                    await refreshState();
                } else {
                    showToast(data.error || "Invalid key.", "error");
                }
            } catch (e) {
                showToast("Error connecting to server.", "error");
            }
        }

        async function generateKey() {
            const duration = document.getElementById('key-duration').value;
            
            try {
                const res = await fetch('/api/generate-key', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ duration })
                });
                
                const data = await res.json();
                
                if (res.ok && data.key) {
                    document.getElementById('new-key-text').innerText = `${data.key} (${duration})`;
                    document.getElementById('generated-key-result').classList.remove('hidden');
                    showToast("License key generated!", "success");
                } else {
                    showToast("Failed to generate key.", "error");
                }
            } catch (e) {
                showToast("Error connecting to server.", "error");
            }
        }

        async function managePremium(remove) {
            const targetId = document.getElementById('manage-user-id').value.trim();
            const days = document.getElementById('manage-duration').value;
            
            if (!targetId) return showToast("Please enter a Discord ID.", "error");
            
            try {
                const res = await fetch('/api/admin/update-plan', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ targetUserId: targetId, days, remove })
                });
                
                if (res.ok) {
                    showToast(remove ? "Premium removed!" : "Premium granted!", "success");
                    document.getElementById('manage-user-id').value = '';
                } else {
                    showToast("Failed. Are they registered?", "error");
                }
            } catch (e) {
                showToast("Error connecting to server.", "error");
            }
        }

        /* ===== Landing page: smooth scroll, reveal, scroll-spy, effects ===== */
        document.documentElement.classList.add('js');
        (function initLanding() {
            const landing = document.getElementById('landing-page');
            const nav = document.getElementById('landing-nav');
            const bar = document.getElementById('scroll-progress');
            const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
            const behavior = reduce ? 'auto' : 'smooth';
            const isVisible = () => landing && getComputedStyle(landing).display !== 'none';

            function scrollToId(id, push) {
                const el = id === 'top' ? document.body : document.getElementById(id);
                if (!el) return;
                const y = id === 'top' ? 0 : el.getBoundingClientRect().top + window.scrollY - 84;
                window.scrollTo({ top: Math.max(0, y), behavior });
                if (push) history.pushState(null, '', '#' + id);
            }

            document.addEventListener('click', (e) => {
                const a = e.target.closest('a[data-scroll]');
                if (!a || !isVisible()) return;
                const href = a.getAttribute('href');
                if (href && href.startsWith('/#')) {
                    e.preventDefault();
                    const id = href.replace('/#', '');
                    scrollToId(id, true);
                    return;
                }
                e.preventDefault();
                scrollToId(href.slice(1), true);
            });

            window.__landingScrollToHash = () => {
                const id = location.hash.slice(1);
                if (id && document.getElementById(id) && isVisible()) setTimeout(() => scrollToId(id, false), 150);
            };
            window.addEventListener('hashchange', window.__landingScrollToHash);

            const revealEls = document.querySelectorAll('#landing-page .reveal');
            if ('IntersectionObserver' in window) {
                const io = new IntersectionObserver((entries) => {
                    entries.forEach(en => { if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); } });
                }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
                revealEls.forEach(el => io.observe(el));
            } else { revealEls.forEach(el => el.classList.add('in')); }

            const navLinks = [...document.querySelectorAll('.landing-nav-links a')];
            const sections = navLinks.map(a => document.getElementById(a.getAttribute('href').replace('/#', '')));
            const tocLinks = [...document.querySelectorAll('.legal-toc a[href^="#tos-"]')];
            const tocTargets = tocLinks.map(a => document.getElementById(a.getAttribute('href').slice(1)));
            let ticking = false;
            function onScroll() {
                if (!isVisible()) return;
                const y = window.scrollY, max = document.documentElement.scrollHeight - innerHeight;
                nav.classList.toggle('scrolled', y > 30);
                bar.style.transform = 'scaleX(' + (max > 0 ? y / max : 0) + ')';
                const mark = y + innerHeight * 0.35;
                let cur = -1;
                sections.forEach((s, i) => { if (s && s.offsetTop <= mark) cur = i; });
                navLinks.forEach((a, i) => a.classList.toggle('active', i === cur));
                let t = -1;
                tocTargets.forEach((s, i) => { if (s && s.getBoundingClientRect().top + y <= mark) t = i; });
                const privacy = document.getElementById('privacy');
                const inPrivacy = privacy && privacy.getBoundingClientRect().top + y <= mark;
                tocLinks.forEach((a, i) => a.classList.toggle('active', !inPrivacy && i === t));
                const pl = document.querySelector('.legal-toc a[href="#privacy"]');
                if (pl) pl.classList.toggle('active', !!inPrivacy);
                ticking = false;
            }
            window.addEventListener('scroll', () => { if (!ticking) { ticking = true; requestAnimationFrame(onScroll); } }, { passive: true });
            window.addEventListener('resize', onScroll);

            document.querySelectorAll('.spot').forEach(card => {
                card.addEventListener('pointermove', (e) => {
                    const r = card.getBoundingClientRect();
                    card.style.setProperty('--mx', (e.clientX - r.left) + 'px');
                    card.style.setProperty('--my', (e.clientY - r.top) + 'px');
                });
            });

            const obf = document.getElementById('cw-obf');
            if (obf) {
                const chars = 'abcdef0123456789xXzZ_|\\/=+-~';
                const gen = () => { let s = ''; for (let i = 0; i < 230; i++) s += chars[Math.floor(Math.random() * chars.length)] + (i % 17 === 16 ? ' ' : ''); return 'return(function(...)local v=' + s + ' end)(...)'; };
                obf.textContent = gen();
                if (!reduce) setInterval(() => { obf.textContent = gen(); }, 2600);
            }
            onScroll();
        })();

        async function checkAuth() {
            try {
                const res = await fetch('/api/me');
                const data = await res.json();
                
                if (!data.loggedIn) {
                    document.getElementById('landing-page').style.display = 'flex';
                    if (window.__landingScrollToHash) window.__landingScrollToHash();
                    document.getElementById('app-dashboard').classList.remove('active');
                    document.getElementById('mobile-header').style.display = 'none';
                    return; 
                }

                document.getElementById('landing-page').style.display = 'none';
                document.getElementById('app-dashboard').classList.add('active');
                document.getElementById('mobile-header').style.display = window.innerWidth <= 768 ? 'flex' : 'none';
                
                currentUser = data.user;
                
                document.getElementById('p-username').innerText = currentUser.username;
                document.getElementById('p-discord-id').innerText = currentUser.id;
                document.getElementById('p-id-val').innerText = currentUser.id;
                document.getElementById('p-api-key').value = currentUser.apiKey;
                document.getElementById('p-joined').innerText = new Date(currentUser.joinedAt).toLocaleDateString();
                document.getElementById('p-plan').innerText = currentUser.plan || 'Basic'; 
                document.getElementById('sb-username').innerText = currentUser.username;

                if (currentUser.avatar) {
                    document.getElementById('p-avatar').src = `https://cdn.discordapp.com/avatars/${currentUser.id}/${currentUser.avatar}.png`;
                    document.getElementById('sb-avatar').src = `https://cdn.discordapp.com/avatars/${currentUser.id}/${currentUser.avatar}.png`;
                }

                if (currentUser.isAdmin) {
                    document.getElementById('admin-tab').classList.remove('hidden');
                    document.getElementById('mobile-admin-tab').classList.remove('hidden');
                }

                await loadData(); renderProjects(); updateCounts(); applyLanguage(); updateCounts();
                maybeShowLockModal();
                loadActivity();

                let path = window.location.pathname.replace('/', '') || 'projects';
                if (path === 'profile') path = 'settings';
                if (document.getElementById(path)) {
                    document.querySelectorAll('.nav-item').forEach(nav => {
                        if (nav.getAttribute('onclick')?.includes(`'${path}'`)) {
                            navigate(path, nav);
                        }
                    });
                }

            } catch (e) {
                console.error("Auth check failed", e);
            }
        }

        function renderAdminTable(users) {
            const tbody = document.getElementById('admin-users-table');
            tbody.innerHTML = '';
            
            if (users.length === 0) {
                tbody.innerHTML = `<tr><td colspan="4" style="text-align:center; padding: 20px;">No users found.</td></tr>`;
                return;
            }

            users.forEach(u => {
                const tr = document.createElement('tr');
                tr.setAttribute('data-user-row', u.id);
                const hasAvatar = u.avatar && u.avatar !== '0';
                const avatarSrc = hasAvatar ? `https://cdn.discordapp.com/avatars/${u.id}/${u.avatar}.png` : `https://cdn.discordapp.com/embed/avatars/0.png`;
                tr.innerHTML = `
                    <td><div style="display:flex; align-items:center; gap:10px;"><img class="access-user-avatar" src="${avatarSrc}" style="width:32px;height:32px;border-radius:50%;" onerror="this.src='https://cdn.discordapp.com/embed/avatars/0.png'"> <span class="access-user-name" style="font-weight:600;">${u.username}</span></div></td>
                    <td style="font-family:var(--font-mono); color:var(--text-muted);">${u.id}</td>
                    <td style="font-family:var(--font-mono); color:var(--accent-red);">${u.apiKey}</td>
                    <td style="color:var(--text-muted);">${new Date(u.joinedAt).toLocaleDateString()}</td>
                `;
                tbody.appendChild(tr);
            });
            // The stored "username" can go stale (people rename on Discord); refresh from Discord live.
            resolveDiscordUsersInBox(tbody, users.map(u => u.id));
        }

        function filterAdminUsers() {
            const query = document.getElementById('admin-search').value.toLowerCase().trim();
            if (!query) { renderAdminTable(adminUsersCache); return; }
            const filtered = adminUsersCache.filter(u => u.username.toLowerCase().includes(query) || u.id.includes(query));
            renderAdminTable(filtered);
        }

        async function loadAdminData() {
            const tbody = document.getElementById('admin-users-table');
            tbody.innerHTML = `<tr><td colspan="4" style="text-align:center; padding: 20px;">Loading...</td></tr>`;
            document.getElementById('admin-search').value = ''; 
            
            try {
                const res = await fetch('/api/admin/users');
                if (!res.ok) throw new Error("Failed");
                const data = await res.json();
                adminUsersCache = data.users; 
                renderAdminTable(adminUsersCache); 
            } catch (e) {
                tbody.innerHTML = `<tr><td colspan="4" style="text-align:center; color: #f87171; padding: 20px;">Failed to load users.</td></tr>`;
            }
        }

        function resetApiKey() {
            showConfirm("This creates a new API key. The old key stops working and every other device is logged out. You stay logged in here.", async () => {
                try {
                    const res = await fetch('/api/apikey/reset', { method: 'POST' });
                    const data = await res.json().catch(() => ({}));
                    if (!res.ok || !data.apiKey) { showToast(data.error || 'Could not reset the API key.', 'error'); return; }
                    currentUser.apiKey = data.apiKey;
                    const input = document.getElementById('p-api-key');
                    input.value = data.apiKey; input.type = 'text';
                    showToast('API key reset. Copy your new key now.', 'success');
                } catch (e) {
                    showToast('Could not reach the server.', 'error');
                }
            }, { title: 'Reset API key?', yes: 'Yes, reset' });
        }
        function toggleApiKey() { const input = document.getElementById('p-api-key'); input.type = input.type === 'password' ? 'text' : 'password'; }
        function copyApiKey() { navigator.clipboard.writeText(document.getElementById('p-api-key').value); showToast("API Key copied!", "success"); }

        function navigate(pageId, element) {
            document.querySelectorAll('.page').forEach(page => page.classList.remove('active'));
            document.getElementById(pageId).classList.add('active');
            
            if (element) {
                document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
                if(element.classList.contains('nav-item')) element.classList.add('active');
            }

            document.querySelectorAll('.user-card').forEach(c => c.classList.toggle('active', pageId === 'settings'));
            window.history.pushState({}, '', `/${pageId}`);
            refreshPageTitle();
            document.querySelector('.main-content').scrollTop = 0;
            if (pageId === 'dashboard' && currentUser) loadActivity();
            if (pageId === 'discordbot' && currentUser) renderDiscordBotPage();
        }

        let activityRange = 30;
        function setActivityRange(days) {
            activityRange = days;
            document.querySelectorAll('#activity-range button').forEach(b => b.classList.toggle('active', Number(b.dataset.range) === days));
            const sub = document.getElementById('activity-sub');
            if (sub) sub.textContent = `Script executions per day, last ${days} days`;
            loadActivity();
        }

        async function loadActivity() {
            try {
                const res = await fetch(`/api/stats?range=${activityRange}`);
                if (!res.ok) return;
                const data = await res.json();
                renderActivityChart(data.days || []);
            } catch (e) {}
        }

        function renderActivityChart(days) {
            const box = document.getElementById('activity-chart');
            if (!box || !days.length) return;
            const W = 1000, H = 340, L = 54, R = 16, T = 16, B = 38;
            const iw = W - L - R, ih = H - T - B;
            const maxVal = Math.max(1, ...days.map(d => d.executions));
            const niceStep = (v) => { const e = Math.pow(10, Math.floor(Math.log10(v))); const f = v / e; return (f <= 1 ? 1 : f <= 2 ? 2 : f <= 5 ? 5 : 10) * e; };
            const step = niceStep(Math.max(1, maxVal / 4));
            const top = Math.max(step * 2, step * Math.ceil(maxVal / step));
            const x = (i) => L + (days.length === 1 ? iw / 2 : (i / (days.length - 1)) * iw);
            const y = (v) => T + ih - (v / top) * ih;

            const smooth = (key) => {
                let d = `M${x(0)},${y(days[0][key])}`;
                for (let i = 1; i < days.length; i++) {
                    const mx = (x(i - 1) + x(i)) / 2;
                    d += ` C${mx},${y(days[i - 1][key])} ${mx},${y(days[i][key])} ${x(i)},${y(days[i][key])}`;
                }
                return d;
            };
            const fmtDate = (iso) => new Date(iso + 'T00:00:00Z').toLocaleDateString('en-US', { month: 'short', day: 'numeric', timeZone: 'UTC' });

            let grid = '';
            for (let v = 0; v <= top; v += step) {
                grid += `<line x1="${L}" x2="${W - R}" y1="${y(v)}" y2="${y(v)}" stroke="rgba(255,255,255,${v === 0 ? 0.12 : 0.07})"/>`;
                grid += `<text x="${L - 14}" y="${y(v) + 5}" text-anchor="end" fill="#6b7280" font-size="15" font-family="var(--font-mono)">${v}</text>`;
            }
            let labels = '';
            const labelEvery = days.length <= 10 ? 1 : days.length <= 31 ? 3 : Math.ceil(days.length / 10);
            days.forEach((d, i) => {
                if ((days.length - 1 - i) % labelEvery === 0) {
                    labels += `<text x="${x(i)}" y="${H - 10}" text-anchor="${i === days.length - 1 ? 'end' : 'middle'}" fill="#6b7280" font-size="15" font-family="var(--font-mono)">${fmtDate(d.date)}</text>`;
                }
            });
            const area = `${smooth('executions')} L${x(days.length - 1)},${y(0)} L${x(0)},${y(0)} Z`;

            box.innerHTML = `
                <svg viewBox="0 0 ${W} ${H}" preserveAspectRatio="xMidYMid meet">
                    <defs><linearGradient id="execFill" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#3b82f6" stop-opacity="0.22"/><stop offset="100%" stop-color="#3b82f6" stop-opacity="0"/></linearGradient></defs>
                    ${grid}${labels}
                    <path d="${area}" fill="url(#execFill)"/>
                    <path d="${smooth('executions')}" fill="none" stroke="#3b82f6" stroke-width="3" stroke-linecap="round"/>
                    <line id="act-cursor" y1="${T}" y2="${T + ih}" stroke="rgba(255,255,255,0.25)" stroke-dasharray="4 4" style="display:none"/>
                    <circle id="act-dot-e" r="6" fill="#3b82f6" stroke="#fff" stroke-width="2.5" style="display:none"/>
                    <rect id="act-hit" x="${L}" y="${T}" width="${iw}" height="${ih}" fill="transparent"/>
                </svg>
                <div class="activity-tip" id="act-tip"></div>`;

            const svg = box.querySelector('svg'), tip = box.querySelector('#act-tip');
            const cursor = box.querySelector('#act-cursor'), dotE = box.querySelector('#act-dot-e');
            const hide = () => { tip.style.opacity = 0; cursor.style.display = dotE.style.display = 'none'; };
            const move = (clientX) => {
                const rect = svg.getBoundingClientRect();
                const px = ((clientX - rect.left) / rect.width) * W;
                const i = Math.max(0, Math.min(days.length - 1, Math.round(((px - L) / iw) * (days.length - 1))));
                const d = days[i], cx = x(i);
                cursor.setAttribute('x1', cx); cursor.setAttribute('x2', cx); cursor.style.display = '';
                dotE.setAttribute('cx', cx); dotE.setAttribute('cy', y(d.executions)); dotE.style.display = '';
                dotE.setAttribute('r', 7);
                tip.innerHTML = `<div class="tip-date">${fmtDate(d.date)}</div>
                    <div class="tip-row"><i style="background:#3b82f6"></i><span>Executions</span><b>${d.executions.toLocaleString()}</b></div>`;
                const sx = (cx / W) * rect.width;
                const tw = tip.offsetWidth || 200;
                let left = sx + 18; if (left + tw > rect.width) left = sx - tw - 18;
                tip.style.left = Math.max(0, left) + 'px';
                const th = tip.offsetHeight || 100;
                const wantTop = (y(d.executions) / H) * rect.height - 20;
                tip.style.top = Math.max(0, Math.min(wantTop, rect.height - th - (B / H) * rect.height - 16)) + 'px';
                tip.style.opacity = 1;
            };
            const hit = box.querySelector('#act-hit');
            hit.addEventListener('mousemove', (e) => move(e.clientX));
            hit.addEventListener('touchmove', (e) => { move(e.touches[0].clientX); }, { passive: true });
            hit.addEventListener('mouseleave', hide);
            hit.addEventListener('touchend', hide);
        }

        let dataLoaded = false;
        let saveChain = Promise.resolve(true);
        const pendingDeletes = { projects: [], scripts: [] };
        const REBUY_URL = 'https://discord.gg/MVCZjqwDgD';

        function esc(v) { return String(v == null ? '' : v).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])); }
        function lockSig() { return currentUser && currentUser.lock ? JSON.stringify([currentUser.lock.lockedIds, currentUser.lock.pending, currentUser.lock.required]) : ''; }
        function applyLock(lock) { if (currentUser && lock) currentUser.lock = lock; }
        function isLocked(id) { return !!(currentUser && currentUser.lock && (currentUser.lock.lockedIds || []).includes(id)); }
        function projectLockedToast() { showToast("This project is locked. Rebuy Premium on Discord to unlock it.", "error"); }

        async function reloadProjects() {
            try {
                const res = await fetch('/api/projects');
                if (!res.ok) return false;
                const data = await res.json();
                projects = data.projects || [];
                projectIdCounter = data.projectIdCounter || 1;
                applyLock(data.lock);
                dataLoaded = true;
                renderProjects(); updateCounts();
                return true;
            } catch (e) { return false; }
        }

        async function loadData() {
            projects = []; projectIdCounter = 1; dataLoaded = false;
            let serverReachable = false, existsOnServer = false;
            try {
                const res = await fetch('/api/projects');
                if (res.ok) {
                    const data = await res.json();
                    serverReachable = true;
                    existsOnServer = !!data.exists;
                    if (data.exists) {
                        projects = data.projects || [];
                        projectIdCounter = data.projectIdCounter || 1;
                        applyLock(data.lock);
                    }
                }
            } catch (e) {}
            if (!serverReachable) { showToast("Could not load your projects. Reload the page.", "error"); return; }
            dataLoaded = true;
            if (existsOnServer) return;

            const key = `luavify_data_${currentUser.id}`;
            const saved = localStorage.getItem(key);
            if (saved) {
                try {
                    const old = JSON.parse(saved);
                    projects = old.projects || [];
                    projectIdCounter = old.projectIdCounter || 1;
                } catch (e) {}
                if (projects.length) {
                    const ok = await saveData();
                    if (ok) localStorage.removeItem(key);
                    await reloadProjects();
                }
            }
        }

        function saveData() {
            if (!dataLoaded) return Promise.resolve(false);
            saveChain = saveChain.then(async () => {
                const sent = { p: pendingDeletes.projects.slice(), s: pendingDeletes.scripts.slice() };
                try {
                    const res = await fetch('/api/projects', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ projects, projectIdCounter, deletedProjectIds: sent.p, deletedScriptHashes: sent.s })
                    });
                    const data = await res.json().catch(() => ({}));
                    if (!res.ok) {
                        showToast(data.error || "Could not save changes.", "error");
                        await reloadProjects();
                        return false;
                    }
                    pendingDeletes.projects = pendingDeletes.projects.filter(x => !sent.p.includes(x));
                    pendingDeletes.scripts = pendingDeletes.scripts.filter(x => !sent.s.includes(x));
                    const before = lockSig();
                    applyLock(data.lock);
                    if (lockSig() !== before) { renderProjects(); updateCounts(); }
                    return true;
                } catch (e) {
                    showToast("Could not save changes. Check your connection.", "error");
                    return false;
                }
            });
            return saveChain;
        }

        async function refreshState() {
            try {
                const res = await fetch('/api/me');
                const data = await res.json();
                if (data.loggedIn) {
                    currentUser = data.user;
                    document.getElementById('p-plan').innerText = currentUser.plan || 'Basic';
                }
            } catch (e) {}
            await reloadProjects();
            maybeShowLockModal();
        }

        let lockSelection = new Set();
        const plural = (n, w) => `${n} ${w}${n === 1 ? '' : 's'}`;

        function renderLockBanner() {
            const el = document.getElementById('lock-banner');
            const lock = currentUser && currentUser.lock;
            if (!lock || !lock.required) { el.style.display = 'none'; el.innerHTML = ''; return; }
            const why = lock.expired ? 'Your Premium has expired.' : 'Your plan only includes ' + plural(lock.keep, 'project') + '.';
            let html;
            if (lock.pending) {
                html = `<div style="font-weight:700;margin-bottom:6px;">⚠️ ${why}</div>
                    <div style="color:var(--text-muted);font-size:0.9rem;margin-bottom:12px;">Choose ${plural(lock.required, 'project')} to lock, or rebuy Premium on Discord to keep everything. Until you choose, your newest projects stay locked.</div>
                    <div style="display:flex;gap:10px;flex-wrap:wrap;">
                        <button class="btn btn-primary" onclick="openLockModal()" style="padding:8px 16px;font-size:0.85rem;">Choose projects to lock</button>
                        <a class="btn btn-outline" href="${REBUY_URL}" target="_blank" style="padding:8px 16px;font-size:0.85rem;">Rebuy on Discord</a>
                    </div>`;
            } else {
                html = `<div style="font-weight:700;margin-bottom:6px;">🔒 ${plural(lock.lockedIds.length, 'project')} locked</div>
                    <div style="color:var(--text-muted);font-size:0.9rem;margin-bottom:12px;">${why} Locked projects can't be edited and their loaders are disabled. Rebuy Premium on Discord and they unlock as soon as you reload.</div>
                    <a class="btn btn-primary" href="${REBUY_URL}" target="_blank" style="padding:8px 16px;font-size:0.85rem;">Rebuy on Discord</a>`;
            }
            el.style.cssText = 'display:block;margin:0 0 24px;padding:18px 20px;border-radius:14px;border:1px solid rgba(239,68,68,0.35);background:rgba(239,68,68,0.08);';
            el.innerHTML = html;
        }

        function maybeShowLockModal() {
            const lock = currentUser && currentUser.lock;
            if (lock && lock.pending && lock.required > 0) openLockModal();
        }

        function openLockModal() {
            const lock = currentUser && currentUser.lock;
            if (!lock || !lock.pending) return;
            lockSelection = new Set();
            const why = lock.expired ? 'Your Premium has expired.' : 'Your plan only includes ' + plural(lock.keep, 'project') + '.';
            document.getElementById('lock-modal-title').innerText = lock.expired ? 'Premium expired' : 'Project limit';
            document.getElementById('lock-modal-desc').innerText = `${why} The free plan keeps ${plural(lock.keep, 'project')} active. Choose ${plural(lock.required, 'project')} to lock, or rebuy Premium on Discord and keep them all. Locked projects stay in your account, but they can't be edited and their loaders kick the player ("ask the owner to rebuy").`;
            const list = document.getElementById('lock-modal-list');
            list.innerHTML = '';
            projects.forEach(p => {
                const row = document.createElement('label');
                row.style.cssText = 'display:flex;align-items:center;gap:12px;padding:12px 14px;border:1px solid var(--border-color);border-radius:10px;cursor:pointer;background:rgba(255,255,255,0.02);';
                row.innerHTML = `<input type="checkbox" data-id="${p.id}" style="width:18px;height:18px;accent-color:#ef4444;"><span style="flex:1;font-weight:600;">${esc(p.name)}</span><span style="font-size:0.75rem;color:var(--text-muted);">${plural(p.scripts.length, 'script')}</span>`;
                row.querySelector('input').addEventListener('change', (e) => {
                    const id = Number(e.target.dataset.id);
                    if (e.target.checked) lockSelection.add(id); else lockSelection.delete(id);
                    updateLockModal();
                });
                list.appendChild(row);
            });
            updateLockModal();
            document.getElementById('lockModal').classList.add('active');
        }

        function updateLockModal() {
            const lock = currentUser.lock;
            const n = lockSelection.size;
            const full = n >= lock.required;
            document.querySelectorAll('#lock-modal-list input').forEach(cb => { cb.disabled = full && !cb.checked; cb.parentElement.style.opacity = (cb.disabled ? '0.45' : '1'); });
            document.getElementById('lock-modal-count').innerText = `Selected ${n}/${lock.required} to lock`;
            const btn = document.getElementById('lock-confirm-btn');
            btn.disabled = n !== lock.required;
            btn.style.opacity = n === lock.required ? '1' : '0.5';
        }

        function closeLockModal() { document.getElementById('lockModal').classList.remove('active'); }

        function submitLockChoice() {
            const lock = currentUser.lock;
            if (lockSelection.size !== lock.required) return;
            showConfirm(`Lock ${plural(lock.required, 'project')}? You can only unlock them again by rebuying Premium.`, async () => {
                try {
                    const res = await fetch('/api/projects/lock-choice', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ lockIds: Array.from(lockSelection) })
                    });
                    const data = await res.json().catch(() => ({}));
                    if (!res.ok) return showToast(data.error || "Could not lock projects.", "error");
                    applyLock(data.lock);
                    closeLockModal(); renderProjects(); updateCounts();
                    showToast("Projects locked. Rebuy Premium on Discord to unlock them.", "info");
                } catch (e) { showToast("Error connecting to server.", "error"); }
            }, { title: 'Lock projects', yes: 'Lock them' });
        }

        const PLAN_LIMITS = {
            Basic:   { projects: 3, scriptsPerProject: 3, monthlyObfuscations: 30 },
            Premium: { projects: 9, scriptsPerProject: 3, monthlyObfuscations: 30 }
        };
        function getLimits() {
            if (currentUser && currentUser.limits) return currentUser.limits;
            return PLAN_LIMITS[currentUser && currentUser.plan === 'Premium' ? 'Premium' : 'Basic'];
        }
        function setPlan(plan) { if (currentUser) { currentUser.plan = plan; currentUser.limits = PLAN_LIMITS[plan === 'Premium' ? 'Premium' : 'Basic']; } }

        function updateCounts() {
            const count = projects.length;
            const lockedCount = projects.filter(p => isLocked(p.id)).length;
            const active = count - lockedCount;
            const lim = getLimits();
            const isAdmin = !!(currentUser && currentUser.isAdmin);
            const used = (currentUser && currentUser.monthlyObfuscations) || 0;
            const of = (n, max) => isAdmin ? `${n}` : `${n}<span style="font-size:1.4rem;color:var(--text-muted);font-weight:700;">/${max}</span>`;
            document.getElementById('dash-project-count').innerHTML = of(active, lim.projects);
            document.getElementById('dash-obfuscations').innerHTML = of(used, lim.monthlyObfuscations);
            const scEl = document.getElementById('dash-scripts');
            if (scEl) scEl.innerText = projects.reduce((n, p) => n + ((p.scripts || []).length), 0).toLocaleString();
            document.getElementById('dash-executions').innerText = ((currentUser && currentUser.totalExecutions) || 0).toLocaleString();
            document.getElementById('project-limit-hint').innerText = `${active}/${lim.projects} projects used` + (lockedCount ? ` · ${lockedCount} locked` : '');

            const btn = document.getElementById('create-project-btn');
            if (isAdmin) {
                btn.disabled = false; btn.style.opacity = '1';
                btn.innerText = "Create New Project";
                document.getElementById('project-limit-hint').innerText = `${count} projects (Admin)`;
            } else {
                const full = active >= lim.projects;
                btn.disabled = full; btn.style.opacity = full ? '0.5' : '1';
                btn.innerText = full ? "Limit Reached" : "Create New Project";
            }
            renderLockBanner();
        }

        let accessCategory = 'keys';
        let accessCache = null;
        function allAccessScripts() {
            const out=[];
            (projects||[]).forEach(project => (project.scripts||[]).forEach(script => {
                if (script.hash) out.push({hash:script.hash,name:script.name||'Untitled script',projectName:project.name||'Project'});
            }));
            return out;
        }
        function selectedAccessScript() {
            const id = accessCategory==='whitelist'?'access-script-whitelist':accessCategory==='blacklist'?'access-script-blacklist':'access-script-keys';
            return document.getElementById(id)?.value || '';
        }
        function escapeAccessText(value) { return String(value??'').replace(/[&<>"']/g, c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])); }
        function fillAccessScriptSelects() {
            const scripts=allAccessScripts();
            ['access-script-keys','access-script-whitelist','access-script-blacklist'].forEach(id=>{
                const el=document.getElementById(id); if(!el)return;
                const previous=el.value;
                el.innerHTML=scripts.length?scripts.map(sc=>`<option value="${escapeAccessText(sc.hash)}">${escapeAccessText(sc.projectName)} / ${escapeAccessText(sc.name)}</option>`).join(''):'<option value="">Create a project and script first</option>';
                if(scripts.some(sc=>sc.hash===previous))el.value=previous;
                if (typeof el.syncCustom === 'function') el.syncCustom();
            });
        }
        async function accessApi(path, method='GET', body=null) {
            const opts={method,headers:{'Content-Type':'application/json'}}; if(body)opts.body=JSON.stringify(body);
            const res=await fetch(path,opts); const data=await res.json().catch(()=>({}));
            if(!res.ok)throw new Error(data.error||`Request failed (${res.status})`); return data;
        }
        async function renderAccessCategory() {
            try { if (currentUser) { await loadData(); renderProjects(); updateCounts(); } } catch (_) {}
            fillAccessScriptSelects();
            const hash=selectedAccessScript();
            const target=accessCategory==='whitelist'?'access-whitelist-list':accessCategory==='blacklist'?'access-blacklist-list':'access-key-list';
            const box=document.getElementById(target); if(!box)return;
            if(!hash){box.innerHTML='<div class="access-empty">Create a project and add a script first.</div>';return;}
            box.innerHTML='<div class="access-empty">Loading access data…</div>';
            try {
                const data=await accessApi(`/api/access?hash=${encodeURIComponent(hash)}`); accessCache=data;
                if(accessCategory==='keys') {
                    box.innerHTML=data.keys.length?`<table class="access-table"><thead><tr><th>Status</th><th>Redemptions</th><th>Expires</th><th>Actions</th></tr></thead><tbody>${data.keys.map(k=>`<tr><td><span class="access-key-code">${escapeAccessText(k.status)}</span><br><small>${escapeAccessText(k.id)}</small></td><td>${(k.redeemedBy||[]).length}/${k.maxRedemptions}</td><td>${k.expiresAt?escapeAccessText(new Date(k.expiresAt).toLocaleString()):'Never'}</td><td><button class="btn btn-outline text-red" onclick="deleteDashboardAccessKey('${escapeAccessText(k.id)}')">Delete</button></td></tr>`).join('')}</tbody></table>`:'<div class="access-empty">No keys yet. Generate one above.</div>';
                } else {
                    const list=accessCategory==='whitelist'?data.whitelist:data.blacklist;
                    box.innerHTML=list.length?`<table class="access-table"><thead><tr><th>User</th><th>Added</th><th>Expires</th><th>Reason</th></tr></thead><tbody>${list.map(u=>`<tr data-user-row="${escapeAccessText(u.discordUserId)}"><td><div style="display:flex;align-items:center;gap:8px;"><img class="access-user-avatar" src="https://cdn.discordapp.com/embed/avatars/0.png" style="width:24px;height:24px;border-radius:50%;"><div><div class="access-user-name" style="font-weight:600;">${escapeAccessText(u.discordUserId)}</div><small style="color:var(--text-muted);">ID: ${escapeAccessText(u.discordUserId)}</small></div></div></td><td>${u.createdAt?escapeAccessText(new Date(u.createdAt).toLocaleString()):'—'}</td><td>${u.expiresAt?escapeAccessText(new Date(u.expiresAt).toLocaleString()):'Never'}</td><td>${escapeAccessText(u.reason||'—')}</td></tr>`).join('')}</tbody></table>`:`<div class="access-empty">No ${accessCategory==='whitelist'?'whitelisted':'blacklisted'} users for this script.</div>`;
                    resolveDiscordUsersInBox(box, list.map(u=>u.discordUserId));
                }
            } catch(e){box.innerHTML=`<div class="access-empty">${escapeAccessText(e.message||'Could not load access data.')}</div>`;}
        }

        // Batch-resolves real Discord usernames/avatars for a rendered table and fills them in once known.
        async function resolveDiscordUsersInBox(box, ids) {
            const unique = [...new Set((ids||[]).filter(Boolean))];
            if (!unique.length) return;
            try {
                const res = await fetch('/api/discord/resolve-users', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ ids: unique }) });
                const data = await res.json().catch(()=>({}));
                const users = data.users || {};
                unique.forEach(id => {
                    const info = users[id]; if (!info) return;
                    const row = box.querySelector(`tr[data-user-row="${CSS.escape(id)}"]`); if (!row) return;
                    const img = row.querySelector('.access-user-avatar'); if (img) img.src = info.avatar;
                    const name = row.querySelector('.access-user-name'); if (name) name.textContent = info.username;
                });
            } catch (_) { /* avatars/usernames are a nice-to-have; IDs still show */ }
        }

        // ===================== Discord Bot settings page =====================
        let dbServers = [];
        let dbSelectedGuild = null;
        let dbGuildInfo = { channels: [], roles: [] };
        let dbLoadPromise = null;
        let dbPendingGuild = null;
        // Read once at load: navigate() rewrites the URL (dropping ?botadd=...) before this page renders.
        let dbReturnParams = new URLSearchParams(window.location.search);
        const DB_LOGO = 'https://i.ibb.co/k2GbYLyX/logo.png';
        const DB_DEFAULT_DESC = 'Use the buttons below to redeem a key, reset your HWID, get your loadstring, or view your info.';

        function dbSelectedScript() { return document.getElementById('db-script-select')?.value || ''; }

        // The custom <select> wrapper renders its own menu, so it has to be told after options change —
        // otherwise it keeps showing whatever it had when the page first loaded (blank).
        function dbSetSelect(id, items, selected) {
            const el = document.getElementById(id); if (!el) return;
            el.innerHTML = items.map(i => `<option value="${escapeAccessText(i.value)}">${escapeAccessText(i.label)}</option>`).join('');
            if (selected != null && items.some(i => i.value === selected)) el.value = selected;
            el.syncCustom?.();
        }

        function dbFillScriptSelect() {
            const scripts = allAccessScripts();
            const el = document.getElementById('db-script-select'); if (!el) return;
            const previous = el.value;
            dbSetSelect('db-script-select',
                scripts.length ? scripts.map(sc => ({ value: sc.hash, label: `${sc.projectName} / ${sc.name}` })) : [{ value: '', label: 'Create a project and script first' }],
                previous);
        }

        function dbInitials(name) {
            const words = String(name || '?').replace(/[^\p{L}\p{N}\s]/gu, ' ').trim().split(/\s+/).filter(Boolean);
            const t = words.length > 1 ? words.map(w => Array.from(w)[0]).join('').slice(0, 3) : Array.from(words[0] || '?').slice(0, 2).join('');
            return t.toUpperCase();
        }

        // Same size/shape for every server: the icon sits on top of an initials tile, so a server
        // without an icon (or one that fails to load) still looks like the others.
        function dbAvatarHtml(s) {
            const ini = escapeAccessText(s.unreachable ? '?' : dbInitials(s.name));
            const img = s.icon ? `<img src="${escapeAccessText(s.icon)}" alt="" loading="lazy" referrerpolicy="no-referrer" onerror="this.remove()">` : '';
            return `<span class="db-avatar"><b>${ini}</b>${img}</span>`;
        }

        function dbHandleReturn() {
            const params = dbReturnParams; dbReturnParams = new URLSearchParams();
            const status = params.get('botadd');
            if (!status) return;
            const guild = params.get('guild');
            const msgs = {
                ok: ['Bot added — the server is now linked to your account.', 'success'],
                cancelled: ['Adding the bot was cancelled.', 'info'],
                noperm: ['You need the Manage Server permission in that server to link it.', 'error'],
                mismatch: ['That Discord account is not the one you are logged in with.', 'error'],
            };
            const [text, type] = msgs[status] || ['Could not finish adding the bot. Please try again.', 'error'];
            showToast(text, type);
            if (status === 'ok' && /^\d{15,22}$/.test(guild || '')) dbPendingGuild = guild;
        }

        function renderDiscordBotPage() {
            if (dbLoadPromise) return dbLoadPromise;
            dbLoadPromise = (async () => {
                try {
                    try { if (currentUser) { await loadData(); renderProjects(); } } catch (_) {}
                    dbFillScriptSelect();
                    dbHandleReturn();
                    await dbLoadServers();
                    dbRenderPreview();
                } finally { dbLoadPromise = null; }
            })();
            return dbLoadPromise;
        }

        function dbOnScriptChange() {
            if (dbSelectedGuild) { dbLoadPanelStyle(); dbLoadBuyerRole(); dbLoadHwidLimit(); }
        }

        function dbMarkSelected() {
            document.querySelectorAll('#db-servers-list .db-server').forEach(r => r.classList.toggle('selected', r.dataset.id === dbSelectedGuild));
        }

        async function dbLoadServers() {
            const box = document.getElementById('db-servers-list'); if (!box) return;
            try {
                const res = await fetch('/api/discordbot/servers'); const data = await res.json().catch(() => ({}));
                dbServers = data.servers || [];
            } catch (e) { box.innerHTML = `<div class="db-empty"><strong>Could not load your servers</strong><p>Check your connection and reopen this page.</p></div>`; return; }

            if (!dbServers.length) {
                dbSelectedGuild = null;
                document.getElementById('db-server-detail').style.display = 'none';
                box.innerHTML = `<div class="db-empty">
                    <img src="${DB_LOGO}" alt="">
                    <strong>No servers yet</strong>
                    <p>Add the bot to a server you manage. Once you approve it on Discord you'll land back here with the server already linked.</p>
                    <a class="btn btn-primary db-add" href="/auth/bot-add" style="display:inline-flex;width:auto;">Add bot</a>
                </div>`;
                return;
            }

            box.innerHTML = dbServers.map(s => `
                <div class="db-server${s.unreachable ? ' gone' : ''}" data-id="${escapeAccessText(s.id)}" role="button" tabindex="0"
                     onclick="dbSelectServer('${escapeAccessText(s.id)}')" onkeydown="if(event.key==='Enter'||event.key===' '){event.preventDefault();dbSelectServer('${escapeAccessText(s.id)}');}">
                    ${dbAvatarHtml(s)}
                    <div class="db-server-meta">
                        <div class="db-server-name">${escapeAccessText(s.unreachable ? 'Bot was removed' : s.name)}</div>
                        <div class="db-server-sub"><i class="db-dot"></i>${s.unreachable
                            ? `<a class="db-server-readd" href="/auth/bot-add" onclick="event.stopPropagation()">Add the bot again</a>`
                            : `<span>${escapeAccessText(s.id)}</span>`}</div>
                    </div>
                    <button type="button" class="db-server-x" title="Remove from my account" aria-label="Remove server" onclick="dbRemoveServer('${escapeAccessText(s.id)}', event)">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                    </button>
                </div>`).join('');

            const usable = dbServers.filter(s => !s.unreachable);
            const wanted = dbPendingGuild || dbSelectedGuild;
            dbPendingGuild = null;
            const pick = usable.find(s => s.id === wanted) || usable[0];
            if (pick) await dbSelectServer(pick.id);
            else { dbSelectedGuild = null; document.getElementById('db-server-detail').style.display = 'none'; }
        }

        function dbRemoveServer(guildId, ev) {
            ev?.stopPropagation();
            const s = dbServers.find(x => x.id === guildId);
            showConfirm(`Remove ${s && !s.unreachable ? s.name : 'this server'} from your account? The bot stays in the server; you can add it again any time.`, async () => {
                try {
                    const res = await fetch('/api/discordbot/remove-server', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ guildId }) });
                    if (!res.ok) { const d = await res.json().catch(() => ({})); return showToast(d.error || 'Could not remove the server.', 'error'); }
                    if (dbSelectedGuild === guildId) dbSelectedGuild = null;
                    showToast('Server removed.', 'success');
                    await dbLoadServers();
                } catch (e) { showToast('Could not reach the server.', 'error'); }
            }, { title: 'Remove server?', yes: 'Remove' });
        }

        async function dbSelectServer(guildId) {
            const srv = dbServers.find(s => s.id === guildId);
            if (srv?.unreachable) return showToast('The bot is no longer in that server. Press "Add the bot again".', 'error');
            dbSelectedGuild = guildId;
            document.getElementById('db-server-detail').style.display = 'block';
            dbMarkSelected();
            const sub = document.getElementById('db-detail-sub');
            if (sub) sub.innerHTML = `Posting to <b>${escapeAccessText(srv?.name || guildId)}</b>`;

            try {
                const res = await fetch(`/api/discordbot/guild-info?guildId=${encodeURIComponent(guildId)}`);
                const data = await res.json().catch(() => ({}));
                dbGuildInfo = { channels: data.channels || [], roles: data.roles || [] };
            } catch (e) { dbGuildInfo = { channels: [], roles: [] }; }
            if (dbSelectedGuild !== guildId) return; // user switched servers while this was loading

            dbSetSelect('db-channel-select', dbGuildInfo.channels.length
                ? dbGuildInfo.channels.map(c => ({ value: c.id, label: `#${c.name}` }))
                : [{ value: '', label: 'No text channels found' }]);
            dbSetSelect('db-buyerrole-select', [{ value: '', label: 'None' }, ...dbGuildInfo.roles.map(r => ({ value: r.id, label: `@${r.name}` }))]);

            const mgrBox = document.getElementById('db-manager-roles-box');
            mgrBox.innerHTML = dbGuildInfo.roles.length ? dbGuildInfo.roles.map(r => {
                const col = r.color ? '#' + Number(r.color).toString(16).padStart(6, '0') : '#99aab5';
                return `<label class="db-chip" style="--rc:${col}"><input type="checkbox" value="${escapeAccessText(r.id)}" class="db-mgr-role-cb"><i class="db-dot"></i><span class="n">${escapeAccessText(r.name)}</span></label>`;
            }).join('') : '<div class="db-hint">No roles found in this server.</div>';

            await Promise.all([dbLoadPanelStyle(), dbLoadBuyerRole(), dbLoadHwidLimit(), dbLoadManagerRoles()]);
            dbRenderPreview();
        }

        async function dbLoadPanelStyle() {
            const hash = dbSelectedScript(); if (!hash || !dbSelectedGuild) return;
            let data = {};
            try {
                const res = await fetch(`/api/discordbot/panel-style?scriptHash=${encodeURIComponent(hash)}&guildId=${encodeURIComponent(dbSelectedGuild)}`);
                data = await res.json().catch(() => ({}));
            } catch (_) {}
            document.getElementById('db-panel-title').value = data.title || '';
            document.getElementById('db-panel-desc').value = data.description && data.description !== DB_DEFAULT_DESC ? data.description : '';
            document.getElementById('db-panel-topline').value = data.style?.topLine || '';
            document.getElementById('db-panel-footer').value = data.style?.footer || '';
            document.getElementById('db-panel-color').value = /^#[0-9a-f]{6}$/i.test(data.style?.color || '') ? data.style.color : '#ef4444';
            if (data.channelId && dbGuildInfo.channels.some(c => c.id === data.channelId)) {
                document.getElementById('db-channel-select').value = data.channelId;
                document.getElementById('db-channel-select').syncCustom?.();
            }
            document.getElementById('db-post-btn').textContent = data.messageId ? 'Update panel' : 'Post panel to channel';
            dbRenderPreview();
        }

        async function dbLoadBuyerRole() {
            const hash = dbSelectedScript(); if (!hash || !dbSelectedGuild) return;
            const sel = document.getElementById('db-buyerrole-select');
            try {
                const res = await fetch(`/api/bot/buyer-role?guildId=${encodeURIComponent(dbSelectedGuild)}&scriptHash=${encodeURIComponent(hash)}`);
                const data = await res.json().catch(() => ({}));
                sel.value = data.roleId && dbGuildInfo.roles.some(r => r.id === data.roleId) ? data.roleId : '';
            } catch (_) { sel.value = ''; }
            sel.syncCustom?.();
        }

        async function dbLoadHwidLimit() {
            const hash = dbSelectedScript(); if (!hash) return;
            try {
                const res = await fetch(`/api/discordbot/hwid-limit?scriptHash=${encodeURIComponent(hash)}`);
                const data = await res.json().catch(() => ({}));
                document.getElementById('db-hwid-resets').value = data.resets ?? 1;
                document.getElementById('db-hwid-days').value = data.days ?? 5;
            } catch (_) {}
        }

        async function dbLoadManagerRoles() {
            if (!dbSelectedGuild) return;
            try {
                const res = await fetch(`/api/discordbot/manager-roles?guildId=${encodeURIComponent(dbSelectedGuild)}`);
                const data = await res.json().catch(() => ({}));
                const ids = data.roleIds || [];
                document.querySelectorAll('.db-mgr-role-cb').forEach(cb => cb.checked = ids.includes(cb.value));
            } catch (_) {}
        }

        // ---- live preview (mirrors buildPanelPayload in the worker) ----
        function dbMd(text) {
            return escapeAccessText(text)
                .replace(/\*\*([^*\n][^]*?)\*\*/g, '<strong>$1</strong>')
                .replace(/(^|[^*])\*([^*\n]+)\*(?!\*)/g, '$1<em>$2</em>')
                .replace(/`([^`\n]+)`/g, '<code>$1</code>');
        }

        function dbRenderPreview() {
            const box = document.getElementById('db-preview'); if (!box) return;
            const val = id => document.getElementById(id)?.value || '';
            const color = /^#[0-9a-f]{6}$/i.test(val('db-panel-color')) ? val('db-panel-color') : '#ef4444';
            const hex = document.getElementById('db-color-hex'); if (hex) hex.textContent = color.toLowerCase();
            const title = val('db-panel-title').trim() || 'Buyer Control Panel';
            const desc = val('db-panel-desc').trim() || DB_DEFAULT_DESC;
            const top = val('db-panel-topline').trim();
            const footer = val('db-panel-footer').trim() || 'Luavify';
            const time = new Date().toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
            const btn = (cls, emoji, label) => `<span class="dc-btn ${cls}"><span>${emoji}</span>${label}</span>`;
            box.innerHTML = `
                <div class="dc-head">
                    <img class="dc-av" src="${DB_LOGO}" alt="">
                    <div class="dc-body">
                        <div class="dc-name">Luavify Protector <span class="dc-tag">App</span><span class="dc-time">Today at ${escapeAccessText(time)}</span></div>
                        <div class="dc-embed" style="--c:${color}">
                            ${top ? `<div class="dc-author">${escapeAccessText(top)}</div>` : ''}
                            <div class="dc-title">${escapeAccessText(title)}</div>
                            <div class="dc-desc">${dbMd(desc)}</div>
                            <div class="dc-foot">${escapeAccessText(footer)} • Today at ${escapeAccessText(time)}</div>
                        </div>
                        <div class="dc-btnrow">${btn('primary', '🔑', 'Redeem Key')}${btn('secondary', '🔄', 'Reset HWID')}${btn('secondary', '📜', 'Get Loadstring')}</div>
                        <div class="dc-btnrow">${btn('success', '🏷️', 'Buyer Role')}${btn('secondary', 'ℹ️', 'Key Info')}</div>
                    </div>
                </div>`;
        }

        async function dbPostPanel() {
            const hash = dbSelectedScript(); if (!hash) return showToast('Select a script first.', 'error');
            if (!dbSelectedGuild) return showToast('Add the bot to a server first.', 'error');
            const channelId = document.getElementById('db-channel-select').value;
            if (!channelId) return showToast('Select a channel.', 'error');
            const btn = document.getElementById('db-post-btn');
            const label = btn.textContent; btn.disabled = true; btn.textContent = 'Posting…';
            try {
                const res = await fetch('/api/discordbot/post-panel', {
                    method: 'POST', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        scriptHash: hash, guildId: dbSelectedGuild, channelId,
                        title: document.getElementById('db-panel-title').value,
                        description: document.getElementById('db-panel-desc').value,
                        topLine: document.getElementById('db-panel-topline').value,
                        footer: document.getElementById('db-panel-footer').value,
                        color: document.getElementById('db-panel-color').value,
                    }),
                });
                const data = await res.json().catch(() => ({}));
                if (!res.ok) { btn.textContent = label; return showToast(data.error || 'Could not post the panel.', 'error'); }
                showToast(data.updated ? 'Panel updated in Discord.' : 'Panel posted.', 'success');
                btn.textContent = 'Update panel';
            } catch (e) { btn.textContent = label; showToast('Could not reach the server.', 'error'); }
            finally { btn.disabled = false; }
        }

        async function dbSaveBuyerRole() {
            const hash = dbSelectedScript(); if (!hash || !dbSelectedGuild) return showToast('Select a script and server first.', 'error');
            const roleId = document.getElementById('db-buyerrole-select').value;
            try {
                const res = await fetch('/api/discordbot/set-buyer-role', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ scriptHash: hash, guildId: dbSelectedGuild, roleId }) });
                if (!res.ok) { const d = await res.json().catch(() => ({})); return showToast(d.error || 'Could not save.', 'error'); }
                showToast('Buyer role saved.', 'success');
            } catch (e) { showToast('Could not reach the server.', 'error'); }
        }

        async function dbSaveHwidLimit() {
            const hash = dbSelectedScript(); if (!hash) return showToast('Select a script first.', 'error');
            const resets = Number(document.getElementById('db-hwid-resets').value) || 0;
            const days = Number(document.getElementById('db-hwid-days').value) || 5;
            try {
                const res = await fetch('/api/discordbot/hwid-limit', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ scriptHash: hash, resets, days }) });
                if (!res.ok) { const d = await res.json().catch(() => ({})); return showToast(d.error || 'Could not save.', 'error'); }
                showToast('HWID reset limit saved.', 'success');
            } catch (e) { showToast('Could not reach the server.', 'error'); }
        }

        async function dbSaveManagerRoles() {
            if (!dbSelectedGuild) return;
            const roleIds = [...document.querySelectorAll('.db-mgr-role-cb:checked')].map(cb => cb.value);
            try {
                const res = await fetch('/api/discordbot/manager-roles', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ guildId: dbSelectedGuild, roleIds }) });
                if (!res.ok) { const d = await res.json().catch(() => ({})); return showToast(d.error || 'Could not save.', 'error'); }
                showToast('Manager roles saved.', 'success');
            } catch (e) { showToast('Could not reach the server.', 'error'); }
        }
        async function copyAccessKey(button) {
            const value = button?.dataset?.key || '';
            if (!value) return showToast('No key to copy.', 'error');
            try {
                if (navigator.clipboard && window.isSecureContext) await navigator.clipboard.writeText(value);
                else {
                    const field = document.createElement('textarea'); field.value = value;
                    field.style.position = 'fixed'; field.style.opacity = '0'; document.body.appendChild(field);
                    field.select(); const ok = document.execCommand('copy'); field.remove();
                    if (!ok) throw new Error('Clipboard unavailable');
                }
                showToast('Key copied.', 'success');
            } catch (_) { showToast('Could not copy automatically. Select and copy the key above.', 'error'); }
        }

        async function createDashboardAccessKey() {
            const hash=selectedAccessScript(); if(!hash)return showToast('Create a script first.','error');
            const days=Math.max(0,Math.min(3650,Number(document.getElementById('access-key-days').value)||0));
            const maxRedemptions=Math.max(1,Math.min(10000,Number(document.getElementById('access-key-uses').value)||1));
            try {
                const data=await accessApi('/api/access/key','POST',{hash,days,maxRedemptions});
                const out=document.getElementById('access-key-created'); out.style.display='block'; out.innerHTML=`<div class="access-result"><strong>Key generated — copy it now:</strong><p class="access-key-code" style="margin:8px 0;">${escapeAccessText(data.key)}</p><button class="btn btn-outline access-copy-btn" onclick="copyAccessKey(this)" data-key="${escapeAccessText(data.key)}">Copy key</button></div>`;
                showToast('Key generated successfully.','success'); await renderAccessCategory();
            } catch(e){showToast(e.message||'Could not generate key.','error');}
        }
        async function addDashboardAccessUser(kind) {
            const hash=selectedAccessScript(); if(!hash)return showToast('Create a script first.','error');
            const userId=(document.getElementById(kind==='whitelist'?'access-wl-user':'access-bl-user').value||'').trim();
            if(!/^\d{15,22}$/.test(userId))return showToast('Enter a valid Discord user ID (15–22 digits).','error');
            const days=Math.max(0,Math.min(3650,Number(document.getElementById(kind==='whitelist'?'access-wl-days':'access-bl-days').value)||0));
            const reason=kind==='blacklist'?(document.getElementById('access-bl-reason').value||'').trim():'';
            try {
                const data=await accessApi(`/api/access/${kind}`,'POST',{hash,discordId:userId,days,reason});
                if(kind==='whitelist'&&data.key){const out=document.getElementById('access-wl-created');out.style.display='block';out.innerHTML=`<div class="access-result"><strong>User whitelisted. Give them this generated key:</strong><p class="access-key-code" style="margin:8px 0;">${escapeAccessText(data.key)}</p><button class="btn btn-outline access-copy-btn" onclick="copyAccessKey(this)" data-key="${escapeAccessText(data.key)}">Copy key</button></div>`;}
                document.getElementById(kind==='whitelist'?'access-wl-user':'access-bl-user').value='';
                showToast(kind==='whitelist'?'User whitelisted; a random key was generated.':'User blacklisted and access revoked.','success'); await renderAccessCategory();
            } catch(e){showToast(e.message||`Could not update ${kind}.`,'error');}
        }
        async function deleteDashboardAccessKey(id) {
            if(!confirm('Delete this key permanently?'))return;
            try { await accessApi('/api/access/key/delete','POST',{hash:selectedAccessScript(),id}); showToast('Key deleted.','success'); await renderAccessCategory(); }
            catch(e){showToast(e.message||'Could not delete key.','error');}
        }

        async function manageScriptAccess(hash, scriptName = "Selected script") {
            const call = async (path, method='GET', body=null) => {
                const options = { method, headers: { 'Content-Type': 'application/json' } };
                if (body) options.body = JSON.stringify(body);
                const response = await fetch(path, options);
                const data = await response.json().catch(() => ({}));
                if (!response.ok) throw new Error(data.error || `Request failed (${response.status})`);
                return data;
            };
            try {
                const current = await call(`/api/access?hash=${encodeURIComponent(hash)}`);
                const summary = `Access manager — ${scriptName}\n\nKeys: ${current.keys.length}\nWhitelisted users: ${current.whitelist.length}\nBlacklisted users: ${current.blacklist.length}\n\n1 = Generate key\n2 = Whitelist Discord user (automatically creates a key)\n3 = Blacklist Discord user\n4 = Delete a key\n5 = Refresh/list keys`;
                const action = prompt(summary, '1');
                if (!action) return;
                if (action === '1') {
                    const daysRaw = prompt('Key expiry in days (0 = never):', '0'); if (daysRaw === null) return;
                    const days = Math.max(0, Math.min(3650, Number(daysRaw) || 0));
                    const data = await call('/api/access/key', 'POST', { hash, days, maxRedemptions: 1 });
                    prompt('Copy this key now. It is only shown once:', data.key);
                    showToast('Key generated.', 'success');
                } else if (action === '2' || action === '3') {
                    const discordId = (prompt('Discord user ID:') || '').trim(); if (!discordId) return;
                    const daysRaw = prompt('Expiry in days (0 = never):', '0'); if (daysRaw === null) return;
                    const reason = prompt('Reason (optional):', '') || '';
                    const endpoint = action === '2' ? '/api/access/whitelist' : '/api/access/blacklist';
                    const data = await call(endpoint, 'POST', { hash, discordId, days: Math.max(0, Math.min(3650, Number(daysRaw) || 0)), reason });
                    if (data.key) prompt('User whitelist saved. Send this generated key to the user:', data.key);
                    showToast(action === '2' ? 'User whitelisted and a key generated.' : 'User blacklisted.', 'success');
                } else if (action === '4') {
                    if (!current.keys.length) return showToast('There are no keys to delete.', 'error');
                    const choices = current.keys.map(k => `${k.id} — ${k.status}, uses ${(k.redeemedBy||[]).length}/${k.maxRedemptions}`).join('\n');
                    const id = (prompt('Enter the key ID to delete:\n' + choices) || '').trim(); if (!id) return;
                    await call('/api/access/key/delete', 'POST', { hash, id });
                    showToast('Key deleted.', 'success');
                } else if (action === '5') {
                    const keys = current.keys.map(k => `${k.id} | ${k.status} | ${(k.redeemedBy||[]).length}/${k.maxRedemptions} uses | expires: ${k.expiresAt || 'never'}`).join('\n') || 'No keys';
                    alert(`Keys for ${scriptName}:\n\n${keys}\n\nWhitelisted: ${current.whitelist.map(x=>x.discordUserId).join(', ') || 'none'}\nBlacklisted: ${current.blacklist.map(x=>x.discordUserId).join(', ') || 'none'}`);
                } else return;
            } catch (error) { showToast(error.message || 'Access management failed.', 'error'); }
        }

        function renderProjects() {
            const container = document.getElementById('projects-container'); container.innerHTML = '';
            if (projects.length === 0) { container.innerHTML = `<div style="padding: 40px 0; text-align: center; color: var(--text-muted);">No projects yet. Create one to get started.</div>`; return; }
            const dis = 'opacity:0.4;cursor:not-allowed;pointer-events:none;';
            projects.forEach(proj => {
                const locked = isLocked(proj.id);
                const projectHTML = `
                    <div class="project-item" style="${locked ? 'border-color: rgba(239,68,68,0.35);' : ''}">
                        <div class="project-header-row">
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div style="width: 40px; height: 40px; border-radius: 10px; background: rgba(239, 68, 68, 0.1); color: var(--accent-red); display: flex; align-items: center; justify-content: center;"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg></div>
                                <div><h4 style="font-size: 1rem; margin-bottom: 2px;">${esc(proj.name)}${locked ? ' <span class="badge badge-disabled" style="margin-left:8px;">🔒 Locked</span>' : ''}</h4><p style="font-size: 0.75rem; color: var(--text-muted); font-family: var(--font-mono);">${esc(proj.hash)}</p></div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span style="font-size: 0.8rem; color: var(--text-muted);">${proj.scripts.length}/${getLimits().scriptsPerProject} scripts</span>
                                ${locked ? `<a class="btn btn-primary" href="${REBUY_URL}" target="_blank" style="padding: 6px 12px; font-size: 0.8rem;">Rebuy on Discord</a>` : ''}
                                <button class="btn btn-outline" ${locked ? 'disabled' : ''} onclick="confirmDeleteProject(${proj.id})" style="padding: 6px 12px; font-size: 0.8rem; ${locked ? dis : ''}">Delete</button>
                                <button class="btn btn-primary" ${locked ? 'disabled' : ''} onclick="openScriptModal(${proj.id})" style="padding: 6px 12px; font-size: 0.8rem; ${locked ? dis : ''}">+ Add</button>
                            </div>
                        </div>
                        ${locked ? `<div style="padding: 10px 20px; font-size: 0.82rem; color: #f87171;">This project is locked. Rebuy Premium on Discord to unlock it. Its loaders kick players until then.</div>` : ''}
                        ${proj.scripts.length > 0 ? `
                        <div style="overflow-x: auto;">
                            <table class="script-table">
                                <thead><tr><th>Script</th><th>Status</th><th>Keyless</th><th>Actions</th></tr></thead>
                                <tbody>
                                    ${proj.scripts.map(script => `
                                        <tr style="${locked ? 'opacity:0.6;' : ''}">
                                            <td><div style="display: flex; align-items: center; gap: 10px;"><div class="toggle-switch ${script.active ? 'active' : ''}" ${locked ? '' : `onclick="toggleScript(${proj.id}, ${script.id}, 'active')"`} style="width: 36px; height: 20px; ${locked ? dis : ''}"><div class="toggle-knob" style="width: 14px; height: 14px; ${script.active ? 'left: 19px;' : ''}"></div></div><div><div style="font-weight: 600; font-size: 0.9rem;">${esc(script.name)}</div><div style="font-size: 0.7rem; color: var(--text-muted); font-family: var(--font-mono);">${esc(script.hash.substring(0, 10))}...</div></div></div></td>
                                            <td><span class="badge ${locked ? 'badge-disabled' : (script.active ? 'badge-active' : 'badge-disabled')}">${locked ? 'Locked' : (script.active ? 'Active' : 'Disabled')}</span></td>
                                            <td><div class="toggle-switch ${script.keyless ? 'active' : ''}" ${locked ? '' : `onclick="toggleScript(${proj.id}, ${script.id}, 'keyless')"`} style="width: 36px; height: 20px; ${locked ? dis : ''}"><div class="toggle-knob" style="width: 14px; height: 14px; ${script.keyless ? 'left: 19px;' : ''}"></div></div></td>
                                            <td><div style="display: flex; gap: 8px;"><button class="btn btn-outline" ${locked ? 'disabled' : ''} onclick="copyLoader(${proj.id}, ${script.id}, event)" style="padding: 6px 10px; font-size: 0.75rem; color: #4ade80; border-color: rgba(74,222,128,0.3); ${locked ? dis : ''}">Loader</button><button class="btn btn-outline" ${locked ? 'disabled' : ''} onclick="openEditModal(${proj.id}, ${script.id})" style="padding: 6px 10px; font-size: 0.75rem; ${locked ? dis : ''}">Edit</button><button class="btn btn-outline text-red" ${locked ? 'disabled' : ''} onclick="confirmDeleteScript(${proj.id}, ${script.id})" style="padding: 6px 10px; font-size: 0.75rem; ${locked ? dis : ''}">Delete</button></div></td>
                                        </tr>
                                    `).join('')}
                                </tbody>
                            </table>
                        </div>
                        ` : `<div style="padding: 30px; text-align: center; color: var(--text-muted); font-size: 0.9rem;">No scripts uploaded yet.</div>`}
                    </div>
                `;
                container.insertAdjacentHTML('beforeend', projectHTML);
            });
        }

        function confirmDeleteProject(id) {
            if (isLocked(id)) return projectLockedToast();
            showConfirm("Are you sure you want to delete this project? All scripts inside will be lost.", () => {
                pendingDeletes.projects.push(id);
                projects = projects.filter(p => p.id !== id); 
                renderProjects(); updateCounts(); saveData(); 
                showToast("Project deleted.", "info");
            });
        }

        function confirmDeleteScript(projectId, scriptId) {
            if (isLocked(projectId)) return projectLockedToast();
            showConfirm("Are you sure you want to delete this script?", async () => {
                const proj = projects.find(p => p.id === projectId); 
                const script = proj.scripts.find(s => s.id === scriptId);
                try {
                    const res = await fetch('/delete-script', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ hash: script.hash })
                    });
                    if (res.status === 403) {
                        const d = await res.json().catch(() => ({}));
                        if (d.locked) { await reloadProjects(); return projectLockedToast(); }
                        return showToast("You can't delete this script.", "error");
                    }
                } catch (e) {}
                pendingDeletes.scripts.push(script.hash);
                proj.scripts = proj.scripts.filter(s => s.id !== scriptId); 
                renderProjects(); updateCounts(); saveData(); 
                showToast("Script deleted.", "info");
            });
        }

        function openProjectModal() { 
            if(!currentUser.isAdmin && projects.filter(p => !isLocked(p.id)).length >= getLimits().projects) return showToast(`Project limit reached (${getLimits().projects} max).`, "error");
            document.getElementById('new-project-name').value = ''; 
            document.getElementById('projectModal').classList.add('active'); 
        }
        function closeProjectModal() { document.getElementById('projectModal').classList.remove('active'); }
        function createProject() {
            const name = document.getElementById('new-project-name').value.trim();
            if (!name) return showToast("Please enter a project name.", "error");
            projects.push({ id: projectIdCounter++, name: name, hash: generateHash(), scripts: [] });
            closeProjectModal(); renderProjects(); updateCounts(); saveData();
            showToast("Project created!", "success");
        }

        function generateHash() {
            const arr = new Uint8Array(16);
            crypto.getRandomValues(arr);
            return Array.from(arr).map(b => b.toString(16).padStart(2, '0')).join('');
        }

        async function toggleScript(projectId, scriptId, type) {
            if (isLocked(projectId)) return projectLockedToast();
            const script = projects.find(p => p.id === projectId).scripts.find(s => s.id === scriptId);
            
            if (type === 'active') {
                const next = !script.active;
                try {
                    const res = await fetch('/toggle', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ hash: script.hash, active: next })
                    });
                    if (!res.ok) {
                        const d = await res.json().catch(() => ({}));
                        if (d.locked) { await reloadProjects(); return projectLockedToast(); }
                        return showToast(d.error || "Could not update script.", "error");
                    }
                } catch (e) { return showToast("Error connecting to server.", "error"); }
                script.active = next;
            }
            if (type === 'keyless') {
                script.keyless = !script.keyless;
                showToast(script.keyless
                    ? 'Keyless ON — anyone can run this loader without a script key or HWID lock.'
                    : 'Keyless OFF — key system / whitelist can require a script key again.', 'info');
            }
            
            renderProjects(); saveData();
        }

        function copyLoader(projectId, scriptId, event) {
            if (isLocked(projectId)) return projectLockedToast();
            const script = projects.find(p => p.id === projectId).scripts.find(s => s.id === scriptId);
            const loaderString = `loadstring(game:HttpGet("https://luavify-protector.itskevin.workers.dev/files/v4/loaders/${script.hash}.lua"))()`;
            navigator.clipboard.writeText(loaderString).then(() => { 
                const btn = event.target; const original = btn.innerText; 
                btn.innerText = 'Copied!'; btn.style.color = '#4ade80'; 
                showToast("Loader copied to clipboard!", "success");
                setTimeout(() => { btn.innerText = original; btn.style.color = ''; }, 1500); 
            });
        }

        async function openEditModal(projectId, scriptId) {
            if (isLocked(projectId)) return projectLockedToast();
            const script = projects.find(p => p.id === projectId).scripts.find(s => s.id === scriptId);
            currentEditTarget = { projectId, scriptId };
            document.getElementById('edit-modal-title').innerText = `Editing: ${script.name}`;
            document.getElementById('edit-code-area').value = "Loading...";
            document.getElementById('edit-obf-area').value = "Loading...";
            setEditTab('original');
            document.getElementById('editModal').classList.add('active');

            const load = async (path, fallback) => {
                try {
                    const res = await fetch(`${path}/${script.hash}`);
                    return res.ok ? await res.text() : fallback;
                } catch (e) { return fallback; }
            };
            const [orig, obf] = await Promise.all([
                load('/get-original', "// Failed to load code"),
                load('/get-obfuscated', "-- Failed to load obfuscated code")
            ]);
            document.getElementById('edit-code-area').value = orig;
            document.getElementById('edit-obf-area').value = obf;
        }
        function setEditTab(tab) {
            const obf = tab === 'obfuscated';
            document.getElementById('edit-code-area').style.display = obf ? 'none' : 'block';
            document.getElementById('edit-obf-area').style.display = obf ? 'block' : 'none';
            document.getElementById('edit-save-btn').style.display = obf ? 'none' : '';
            document.getElementById('edit-copy-obf').style.display = obf ? '' : 'none';
            document.getElementById('edit-hint').innerText = obf ? 'This is what players receive. It is read-only and rebuilt every time you save.' : '';
            const on = 'background: var(--accent-red); color: #fff;', off = 'background: transparent; color: var(--text-muted);';
            document.getElementById('edit-tab-original').style.cssText = 'padding: 6px 14px; font-size: 0.8rem; ' + (obf ? off : on);
            document.getElementById('edit-tab-obfuscated').style.cssText = 'padding: 6px 14px; font-size: 0.8rem; ' + (obf ? on : off);
        }
        function copyObfuscated() {
            navigator.clipboard.writeText(document.getElementById('edit-obf-area').value).then(() => showToast("Obfuscated code copied!", "success"));
        }
        function closeEditModal() { document.getElementById('editModal').classList.remove('active'); }
        
        async function saveEditedCode() {
            if (!currentEditTarget.projectId) return;
            const script = projects.find(p => p.id === currentEditTarget.projectId).scripts.find(s => s.id === currentEditTarget.scriptId);
            const newCode = document.getElementById('edit-code-area').value;
            const btn = document.getElementById('edit-save-btn');
            
            // Show loading state
            const origText = btn.innerText;
            btn.innerText = "Obfuscating...";
            btn.disabled = true;
            btn.style.opacity = '0.7';

            try {
                const res = await fetch('/edit-script', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ hash: script.hash, originalCode: newCode })
                });
                
                if (!res.ok) {
                    const d = await res.json().catch(() => ({}));
                    if (d.locked) { closeEditModal(); await reloadProjects(); return projectLockedToast(); }
                    throw new Error(d.error || "Failed to save");
                }
                
                btn.innerText = "Saved!";
                btn.style.background = "#4ade80";
                btn.style.boxShadow = "none";
                
                showToast("Script updated and re-obfuscated!", "success");
                
                setTimeout(() => {
                    closeEditModal();
                    btn.innerText = origText;
                    btn.style.background = "";
                    btn.style.boxShadow = "";
                    btn.disabled = false;
                    btn.style.opacity = '1';
                }, 1000);

                if (currentUser) { currentUser.monthlyObfuscations = (currentUser.monthlyObfuscations || 0) + 1; updateCounts(); }
            } catch (e) {
                showToast(e.message && e.message !== "Failed to save" ? e.message : "Failed to save changes.", "error");
                btn.innerText = origText;
                btn.disabled = false;
                btn.style.opacity = '1';
            }
        }

        function openScriptModal(projectId) {
            const proj = projects.find(p => p.id === projectId);
            if (isLocked(projectId)) return projectLockedToast();
            if (proj.scripts.length >= getLimits().scriptsPerProject) return showToast(`Maximum ${getLimits().scriptsPerProject} scripts per project.`, "error");
            currentProjectTarget = projectId; 
            document.getElementById('scriptModal').classList.add('active');
            
            document.getElementById('script-name-input').value = '';
            selectedFile = null; 
            document.getElementById('file-input').value = '';
            document.getElementById('file-msg').innerHTML = `Click to browse`;
            const btn = document.getElementById('upload-btn'); btn.disabled = true; btn.style.opacity = '0.5'; btn.innerText = "Upload";
        }
        function closeScriptModal() { document.getElementById('scriptModal').classList.remove('active'); }

        document.getElementById('file-input').addEventListener('change', (e) => { 
            if (e.target.files.length) {
                const file = e.target.files[0];
                selectedFile = file;
                document.getElementById('file-msg').innerHTML = `<span style="color: white;">${file.name}</span>`;
                const btn = document.getElementById('upload-btn'); btn.disabled = false; btn.style.opacity = '1';
            }
        });

        async function uploadScript() {
            if (!selectedFile || !currentProjectTarget) return;
            
            let customName = document.getElementById('script-name-input').value.trim();
            if (!customName) customName = selectedFile.name;

            const btn = document.getElementById('upload-btn'); btn.innerText = "Obfuscating..."; btn.disabled = true;
            const reader = new FileReader();
            
            reader.onload = async function(e) {
                const originalCode = e.target.result;
                try {
                    await saveChain; 
                    const obfRes = await fetch('/obfuscate', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ code: originalCode })
                    });
                    
                    const obfData = await obfRes.json();
                    if (!obfRes.ok) throw new Error(obfData.error || "Obfuscation failed");

                    const response = await fetch(`/upload`, { 
                        method: 'POST', 
                        headers: { 'Content-Type': 'application/json' }, 
                        body: JSON.stringify({ 
                            originalCode: originalCode,
                            obfuscatedCode: obfData.obfuscated,
                            projectId: currentProjectTarget
                        }) 
                    });
                    
                    if (!response.ok) {
                        const d = await response.json().catch(() => ({}));
                        if (d.locked) { closeScriptModal(); await reloadProjects(); }
                        throw new Error(d.error || "Upload failed");
                    }
                    const data = await response.json();
                    
                    const proj = projects.find(p => p.id === currentProjectTarget);
                    proj.scripts.push({ 
                        id: Date.now(), 
                        name: customName, 
                        hash: data.hash, 
                        active: true, 
                        keyless: false
                    });
                    
                    if (currentUser) currentUser.monthlyObfuscations = (currentUser.monthlyObfuscations || 0) + 1;
                    renderProjects(); updateCounts(); saveData(); closeScriptModal();
                    btn.innerText = "Upload"; btn.disabled = false; btn.style.opacity = "1";
                    showToast("Script uploaded successfully!", "success");
                } catch (err) {
                    showToast("Upload failed: " + err.message, "error");
                    btn.innerText = "Upload"; btn.disabled = false; btn.style.opacity = "1";
                }
            };
            reader.readAsText(selectedFile);
        }

        window.addEventListener('resize', () => {
            if (currentUser) {
                document.getElementById('mobile-header').style.display = window.innerWidth <= 768 ? 'flex' : 'none';
            }
        });

        function setBilling(period) {
            const order = ['month', 'year', 'life'];
            const unit = { month: '/month', year: '/year', life: '/lifetime' };
            const toggle = document.getElementById('billing-toggle');
            if (!toggle) return;
            toggle.style.setProperty('--i', Math.max(0, order.indexOf(period)));
            toggle.querySelectorAll('.bt-btn').forEach(b => {
                const on = b.dataset.period === period;
                b.classList.toggle('active', on);
                b.setAttribute('aria-pressed', String(on));
            });
            document.querySelectorAll('.price .amt').forEach(el => {
                el.textContent = el.dataset[period];
                const per = el.parentElement.querySelector('.per');
                if (per) per.textContent = unit[period];
                el.classList.remove('swap'); void el.offsetWidth; el.classList.add('swap');
            });
        }

        function setSidebarExpanded(expanded, persist) {
            const app = document.getElementById('app-dashboard');
            const btn = document.getElementById('sidebar-toggle');
            if (!app) return;
            app.classList.toggle('sidebar-expanded', expanded);
            if (btn) { btn.classList.toggle('open', expanded); btn.setAttribute('aria-expanded', String(expanded)); }
            if (persist) { try { localStorage.setItem('luavify_sidebar', expanded ? '1' : '0'); } catch (e) {} }
        }
        function toggleSidebar() {
            setSidebarExpanded(!document.getElementById('app-dashboard').classList.contains('sidebar-expanded'), true);
        }
        (function () {
            let saved = null;
            try { saved = localStorage.getItem('luavify_sidebar'); } catch (e) {}
            if (saved === '1') setSidebarExpanded(true, false);
        })();

        function discordLoginClick(e, el) {
            if (e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
            e.preventDefault();
            if (el.classList.contains('is-loading')) return;
            const r = el.getBoundingClientRect();
            const size = Math.max(r.width, r.height);
            const x = e.detail === 0 ? r.width / 2 : e.clientX - r.left;
            const y = e.detail === 0 ? r.height / 2 : e.clientY - r.top;
            const dot = document.createElement('span');
            dot.className = 'ripple';
            dot.style.cssText = `width:${size}px;height:${size}px;left:${x - size / 2}px;top:${y - size / 2}px;`;
            el.appendChild(dot);
            setTimeout(() => el.classList.add('is-loading'), 120);
            setTimeout(() => { window.location.href = el.href; }, 520);
        }

        function buildCustomSelect(select) {
            if (select.dataset.enhanced) return;
            select.dataset.enhanced = '1';

            const wrap = document.createElement('div');
            wrap.className = 'cselect';
            select.parentNode.insertBefore(wrap, select);
            wrap.appendChild(select);
            select.classList.add('cselect-native');

            const trigger = document.createElement('button');
            trigger.type = 'button';
            trigger.className = 'cselect-trigger';
            trigger.setAttribute('aria-haspopup', 'listbox');
            trigger.innerHTML = `<span class="cselect-label"></span>
                <svg class="cselect-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>`;

            const menu = document.createElement('div');
            menu.className = 'cselect-menu';
            menu.setAttribute('role', 'listbox');

            wrap.appendChild(trigger);
            document.body.appendChild(menu);

            const checkSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>`;
            let focusedIndex = -1;

            function render() {
                menu.innerHTML = '';
                Array.from(select.options).forEach((opt, i) => {
                    const item = document.createElement('div');
                    item.className = 'cselect-option' + (i === select.selectedIndex ? ' selected' : '');
                    item.setAttribute('role', 'option');
                    item.style.transitionDelay = `${i * 25}ms`;
                    const lbl = document.createElement('span'); lbl.textContent = opt.text; item.appendChild(lbl); item.insertAdjacentHTML('beforeend', checkSvg);
                    item.addEventListener('click', () => choose(i));
                    menu.appendChild(item);
                });
                const cur = select.options[select.selectedIndex];
                trigger.querySelector('.cselect-label').textContent = cur ? cur.text : '';
            }

            function choose(i) {
                const changed = select.selectedIndex !== i;
                select.selectedIndex = i;
                render();
                close();
                if (changed) select.dispatchEvent(new Event('change', { bubbles: true }));
            }

            function setFocus(i) {
                const items = menu.querySelectorAll('.cselect-option');
                items.forEach(el => el.classList.remove('focused'));
                focusedIndex = (i + items.length) % items.length;
                items[focusedIndex].classList.add('focused');
                items[focusedIndex].scrollIntoView({ block: 'nearest' });
            }

            function place() {
                const rect = trigger.getBoundingClientRect();
                const spaceBelow = window.innerHeight - rect.bottom - 16;
                const spaceAbove = rect.top - 16;
                const up = spaceBelow < 240 && spaceAbove > spaceBelow;
                const maxH = Math.max(120, Math.min(260, up ? spaceAbove : spaceBelow));
                menu.style.width = rect.width + 'px';
                menu.style.left = rect.left + 'px';
                menu.style.maxHeight = maxH + 'px';
                menu.classList.toggle('dropup', up);
                if (up) { menu.style.top = 'auto'; menu.style.bottom = (window.innerHeight - rect.top + 8) + 'px'; }
                else { menu.style.bottom = 'auto'; menu.style.top = (rect.bottom + 8) + 'px'; }
            }
            function open() {
                document.querySelectorAll('.cselect.open').forEach(c => c.classList.remove('open'));
                document.querySelectorAll('.cselect-menu.open').forEach(m => m.classList.remove('open'));
                place();
                wrap.classList.add('open');
                menu.classList.add('open');
                setFocus(select.selectedIndex);
            }
            function close() { wrap.classList.remove('open'); menu.classList.remove('open'); focusedIndex = -1; }
            window.addEventListener('resize', () => { if (wrap.classList.contains('open')) place(); });
            document.addEventListener('scroll', (e) => { if (wrap.classList.contains('open') && !menu.contains(e.target)) place(); }, true);

            trigger.addEventListener('click', () => wrap.classList.contains('open') ? close() : open());
            trigger.addEventListener('keydown', (e) => {
                const isOpen = wrap.classList.contains('open');
                if (e.key === 'ArrowDown') { e.preventDefault(); isOpen ? setFocus(focusedIndex + 1) : open(); }
                else if (e.key === 'ArrowUp') { e.preventDefault(); isOpen ? setFocus(focusedIndex - 1) : open(); }
                else if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); isOpen ? choose(focusedIndex) : open(); }
                else if (e.key === 'Escape') close();
            });
            document.addEventListener('click', (e) => { if (!wrap.contains(e.target) && !menu.contains(e.target)) close(); });

            select.syncCustom = render; 
            render();
        }

        function initCustomSelects() { document.querySelectorAll('select').forEach(buildCustomSelect); }

        initCustomSelects();
        checkAuth();
    </script>
</body>
</html>
