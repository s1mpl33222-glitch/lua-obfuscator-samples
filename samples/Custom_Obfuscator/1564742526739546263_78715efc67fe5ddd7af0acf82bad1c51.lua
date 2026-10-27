<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luavify — Protect Your Scripts</title>
    
    <link rel="icon" type="image/png" href="https://i.ibb.co/k2GbYLyX/logo.png">

    <meta property="og:type" content="website">
    <meta property="og:url" content="https://luavify-protector.itskevin.workers.dev/">
    <meta property="og:title" content="Luavify | Protect Your Scripts">
    <meta property="og:description" content="The most advanced, secure, and reliable Lua obfuscation platform for Roblox developers. Stop leakers and keep your code safe.">
    <meta property="og:image" content="https://i.ibb.co/4Rp8GwrJ/hero-image.png">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Luavify | Protect Your Scripts">
    <meta name="twitter:description" content="The most advanced, secure, and reliable Lua obfuscation platform for Roblox developers. Stop leakers and keep your code safe.">
    <meta name="twitter:image" content="https://i.ibb.co/4Rp8GwrJ/hero-image.png">
    <meta name="theme-color" content="#ef4444">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-main: #050608; --bg-sidebar: rgba(15, 17, 21, 0.7); 
            --bg-card: rgba(25, 28, 35, 0.6); --border-color: rgba(255, 255, 255, 0.08);
            --text-main: #f3f4f6; --text-muted: #9ca3af;
            --accent-red: #ef4444; --accent-red-glow: rgba(239, 68, 68, 0.4);
            --font-main: 'Inter', sans-serif;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            background-color: var(--bg-main); color: var(--text-main); font-family: var(--font-main); 
            min-height: 100vh; overflow-x: hidden;
            background-image: radial-gradient(circle at 10% 20%, rgba(239, 68, 68, 0.05) 0%, transparent 40%),
                              radial-gradient(circle at 90% 80%, rgba(239, 68, 68, 0.03) 0%, transparent 40%);
        }
        
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes popIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        
        .hidden { display: none !important; }

        /* ================= LANDING PAGE ================= */
        #landing-page { display: none; width: 100%; min-height: 100vh; }
        .landing-nav { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; position: fixed; width: 100%; top: 0; z-index: 1000; background: rgba(5, 6, 8, 0.8); backdrop-filter: blur(10px); border-bottom: 1px solid var(--border-color); }
        .landing-nav .brand { font-size: 1.5rem; font-weight: 800; display: flex; align-items: center; gap: 10px; letter-spacing: 1px; }
        .landing-nav .brand img { width: 30px; height: 30px; }
        .landing-nav-links { display: flex; gap: 30px; }
        .landing-nav-links a { color: var(--text-muted); text-decoration: none; font-weight: 500; transition: 0.2s; }
        .landing-nav-links a:hover { color: white; }
        .btn-primary { padding: 10px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; background: linear-gradient(135deg, #ef4444, #dc2626); color: white; box-shadow: 0 4px 15px var(--accent-red-glow); text-decoration: none; transition: 0.2s; border: none; font-family: var(--font-main); }
        .btn-primary:hover { transform: translateY(-2px); }
        .hero { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; min-height: 100vh; padding: 0 20px; }
        .hero h1 { font-size: 4.5rem; font-weight: 800; line-height: 1.1; margin-bottom: 20px; letter-spacing: -2px; }
        .hero h1 span { background: linear-gradient(135deg, #ef4444, #f87171); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .hero p { font-size: 1.2rem; color: var(--text-muted); max-width: 600px; margin-bottom: 40px; line-height: 1.6; }
        .hero-btn { padding: 16px 40px; font-size: 1.1rem; border-radius: 12px; font-weight: 700; text-decoration: none; color: white; background: linear-gradient(135deg, #ef4444, #dc2626); box-shadow: 0 10px 30px var(--accent-red-glow); transition: 0.3s; display: inline-block; }
        .hero-btn:hover { transform: translateY(-3px); box-shadow: 0 15px 40px var(--accent-red-glow); }
        .features { padding: 100px 50px; text-align: center; }
        .features h2 { font-size: 2.5rem; margin-bottom: 50px; font-weight: 800; }
        .feature-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; max-width: 1100px; margin: 0 auto; }
        .feature-card { background: var(--bg-card); backdrop-filter: blur(12px); border: 1px solid var(--border-color); padding: 40px; border-radius: 20px; text-align: left; transition: 0.3s; }
        .feature-card:hover { transform: translateY(-5px); border-color: rgba(239, 68, 68, 0.4); }
        .feature-icon { font-size: 2rem; margin-bottom: 20px; background: rgba(239,68,68,0.1); width: 50px; height: 50px; display: flex; align-items: center; justify-content: center; border-radius: 12px; color: var(--accent-red); }
        .feature-card h3 { font-size: 1.3rem; margin-bottom: 10px; font-weight: 700; }
        .feature-card p { color: var(--text-muted); line-height: 1.6; }

        /* ================= DASHBOARD ================= */
        #app-dashboard { display: none; height: 100vh; width: 100vw; overflow: hidden; }
        #app-dashboard.active { display: flex; }
        .sidebar { width: 260px; background: var(--bg-sidebar); backdrop-filter: blur(20px); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; position: fixed; height: 100vh; z-index: 100; transition: transform 0.3s; }
        .brand { padding: 30px 24px; display: flex; align-items: center; gap: 12px; font-size: 1.3rem; font-weight: 800; text-transform: uppercase; letter-spacing: 2px; }
        .brand-logo { width: 35px; height: 35px; object-fit: contain; filter: drop-shadow(0 0 8px var(--accent-red-glow)); }
        .nav-menu { flex: 1; padding: 0 16px; display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 14px; padding: 14px 18px; color: var(--text-muted); text-decoration: none; font-size: 0.95rem; font-weight: 600; border-radius: 12px; transition: all 0.2s ease; cursor: pointer; border: 1px solid transparent; }
        .nav-item svg { width: 20px; height: 20px; }
        .nav-item:hover { background: rgba(255, 255, 255, 0.03); color: var(--text-main); }
        .nav-item.active { background: linear-gradient(90deg, rgba(239, 68, 68, 0.15) 0%, rgba(239, 68, 68, 0.05) 100%); color: var(--text-main); border: 1px solid rgba(239, 68, 68, 0.3); border-left: 4px solid var(--accent-red); }
        .sidebar-footer { padding: 24px 16px; border-top: 1px solid var(--border-color); }
        .main-content { margin-left: 260px; flex: 1; padding: 50px; height: 100vh; overflow-y: auto; }
        h1 { font-size: 2.2rem; font-weight: 800; margin-bottom: 30px; letter-spacing: -1px; background: linear-gradient(to right, #fff, #9ca3af); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .mobile-header { display: none; background: var(--bg-sidebar); padding: 16px 20px; border-bottom: 1px solid var(--border-color); justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 90; }
        .mobile-menu-btn { background: none; border: none; color: var(--text-main); cursor: pointer; padding: 8px; }
        .mobile-menu-btn svg { width: 26px; height: 26px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 24px; margin-bottom: 30px; }
        .stats-grid.small { grid-template-columns: minmax(250px, 350px); }
        .stat-card { background: var(--bg-card); backdrop-filter: blur(12px); border: 1px solid var(--border-color); border-radius: 16px; padding: 24px; transition: 0.3s; }
        .stat-card:hover { transform: translateY(-5px); border-color: rgba(239, 68, 68, 0.4); }
        .stat-header { display: flex; align-items: center; gap: 10px; color: var(--text-muted); font-size: 0.9rem; font-weight: 600; text-transform: uppercase; margin-bottom: 20px; }
        .stat-value { font-size: 3rem; font-weight: 800; margin-bottom: 8px; }
        .stat-desc { font-size: 0.85rem; color: var(--text-muted); font-weight: 500; }
        .progress-bar { height: 6px; background: rgba(255, 255, 255, 0.05); border-radius: 3px; margin-top: 16px; overflow: hidden; }
        .progress { height: 100%; background: linear-gradient(90deg, #ef4444, #f87171); border-radius: 3px; transition: width 0.6s ease; }
        .project-item { background: var(--bg-card); backdrop-filter: blur(12px); border: 1px solid var(--border-color); border-radius: 16px; margin-top: 30px; overflow: hidden; margin-bottom: 30px; animation: slideUp 0.5s ease; }
        .project-header-row { display: flex; justify-content: space-between; align-items: center; padding: 24px; flex-wrap: wrap; gap: 15px; border-bottom: 1px solid var(--border-color); }
        .project-info { display: flex; align-items: center; gap: 18px; }
        .project-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; background: rgba(239, 68, 68, 0.1); color: var(--accent-red); border: 1px solid rgba(239, 68, 68, 0.2); }
        .project-info h4 { font-size: 1.1rem; margin-bottom: 4px; font-weight: 700; }
        .project-info p { font-size: 0.85rem; color: var(--text-muted); font-family: monospace; }
        .project-actions { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .script-count { font-size: 0.85rem; color: var(--text-muted); font-weight: 600; }
        .script-table-container { overflow-x: auto; }
        .script-table { width: 100%; border-collapse: collapse; text-align: left; min-width: 600px; }
        .script-table th { background: rgba(0, 0, 0, 0.2); padding: 16px 24px; font-size: 0.8rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        .script-table td { padding: 18px 24px; border-bottom: 1px solid rgba(255, 255, 255, 0.03); vertical-align: middle; font-size: 0.95rem; }
        .script-info { display: flex; align-items: center; gap: 16px; }
        .script-details { display: flex; flex-direction: column; }
        .script-name { font-weight: 700; margin-bottom: 2px; }
        .script-hash { font-size: 0.8rem; color: var(--text-muted); font-family: monospace; }
        .toggle-switch { width: 44px; height: 24px; background: rgba(255, 255, 255, 0.1); border-radius: 12px; position: relative; cursor: pointer; transition: background 0.3s; flex-shrink: 0; }
        .toggle-switch.active { background: var(--accent-red); }
        .toggle-knob { width: 18px; height: 18px; background: white; border-radius: 50%; position: absolute; top: 3px; left: 3px; transition: left 0.3s; }
        .toggle-switch.active .toggle-knob { left: 23px; }
        .badge { padding: 6px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .badge-active { background: rgba(74, 222, 128, 0.15); color: #4ade80; border: 1px solid rgba(74, 222, 128, 0.2); }
        .badge-disabled { background: rgba(239, 68, 68, 0.15); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.2); }
        .btn { padding: 10px 20px; border-radius: 8px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: none; font-family: var(--font-main); transition: all 0.2s ease; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; }
        .btn-outline { background: rgba(255, 255, 255, 0.03); color: var(--text-main); border: 1px solid var(--border-color); }
        .btn-outline:hover { background: rgba(255, 255, 255, 0.08); }
        .btn-sm { padding: 8px 14px; font-size: 0.8rem; }
        .text-green { color: #4ade80; border-color: rgba(74, 222, 128, 0.3); }
        .text-red { color: #f87171; border-color: rgba(248, 113, 113, 0.3); }
        .action-buttons { display: flex; gap: 10px; flex-wrap: wrap; }
        .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .panel { background: var(--bg-card); backdrop-filter: blur(12px); border: 1px solid var(--border-color); border-radius: 16px; padding: 30px; }
        .user-header { display: flex; align-items: center; gap: 20px; margin-bottom: 30px; }
        .avatar { width: 80px; height: 80px; border-radius: 50%; border: 3px solid var(--accent-red); }
        .user-details { list-style: none; }
        .user-details li { display: flex; justify-content: space-between; padding: 16px 0; border-bottom: 1px solid rgba(255, 255, 255, 0.05); font-size: 0.95rem; }
        .input-group input { width: 100%; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); color: var(--text-main); padding: 14px; border-radius: 8px; font-family: monospace; font-size: 1rem; margin-bottom: 20px; outline: none; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8); backdrop-filter: blur(8px); z-index: 1000; align-items: center; justify-content: center; opacity: 0; transition: opacity 0.3s ease; padding: 20px; }
        .modal.active { display: flex; opacity: 1; }
        .modal-content { background: #111318; border: 1px solid var(--border-color); border-radius: 16px; padding: 30px; width: 500px; max-width: 100%; animation: popIn 0.3s ease; }
        .modal-content h2 { font-size: 1.5rem; font-weight: 700; margin-bottom: 20px; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; }
        .modal-input { width: 100%; padding: 14px; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); color: white; border-radius: 8px; outline: none; font-size: 1rem; margin-bottom: 15px; }
        .code-modal { width: 900px; height: 85vh; display: flex; flex-direction: column; padding: 0; }
        .code-header { padding: 20px 24px; border-bottom: 1px solid var(--border-color); background: rgba(0,0,0,0.2); }
        .code-tools { display: flex; gap: 12px; padding: 16px 24px; background: rgba(0,0,0,0.1); border-bottom: 1px solid var(--border-color); flex-wrap: wrap; }
        .code-tools input { padding: 10px; background: rgba(0,0,0,0.4); border: 1px solid var(--border-color); border-radius: 6px; color: white; font-size: 0.9rem; outline: none; }
        .code-body { flex: 1; background: #000; overflow: hidden; }
        .code-textarea { width: 100%; height: 100%; background: transparent; border: none; color: #a7f3d0; padding: 24px; font-family: 'Courier New', monospace; font-size: 1rem; resize: none; outline: none; }
        .code-footer { padding: 20px 24px; border-top: 1px solid var(--border-color); display: flex; justify-content: flex-end; gap: 12px; background: rgba(0,0,0,0.2); }
        .menu-backdrop { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); backdrop-filter: blur(2px); z-index: 95; transition: opacity 0.3s; }
        .menu-backdrop.active { display: block; }

        .page { display: none; animation: fadeIn 0.4s ease-out; }
        .page.active { display: block; }

        @media (max-width: 768px) {
            .landing-nav { padding: 15px 20px; }
            .landing-nav-links { display: none; }
            .hero h1 { font-size: 2.8rem; }
            .features { padding: 50px 20px; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 24px; }
            .mobile-header { display: flex; }
            h1 { font-size: 1.8rem; }
            .stats-grid { grid-template-columns: 1fr; }
            .project-header-row { flex-direction: column; align-items: flex-start; }
            .project-actions { width: 100%; justify-content: space-between; margin-top: 15px; }
            .code-tools { flex-direction: column; }
            .code-tools input { width: 100%; }
            .profile-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <div id="landing-page">
        <nav class="landing-nav">
            <div class="brand">
                <img src="https://i.ibb.co/k2GbYLyX/logo.png" alt="Luavify Logo" onerror="this.style.display='none'">
                Luavify
            </div>
            <div class="landing-nav-links">
                <a href="#features">Features</a>
                <a href="#pricing">Pricing</a>
                <a href="#docs">Docs</a>
            </div>
            <a href="/auth/login" class="btn-primary">Get Started</a>
        </nav>

        <section class="hero">
            <h1>Protect Your Scripts.<br><span>Obfuscate with Luavify.</span></h1>
            <p>The most advanced, secure, and reliable Lua obfuscation platform for Roblox developers. Stop leakers and keep your code safe.</p>
            <a href="/auth/login" class="hero-btn">Get Started for Free</a>
        </section>

        <section class="features" id="features">
            <h2>Why Choose Luavify?</h2>
            <div class="feature-grid">
                <div class="feature-card">
                    <div class="feature-icon">🛡️</div>
                    <h3>Military-Grade Obfuscation</h3>
                    <p>Our proprietary VM protects your code from decompilers and reverse engineers.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">⚡</div>
                    <h3>Lightning Fast Loaders</h3>
                    <p>Loaders are hosted on Cloudflare's global edge network for zero-latency execution.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <h3>Owner Controls</h3>
                    <p>Instantly disable scripts or kick exploiters with our real-time dashboard controls.</p>
                </div>
            </div>
        </section>
    </div>

    <div id="app-dashboard">
        <div class="menu-backdrop" id="menu-backdrop" onclick="toggleSidebar()"></div>
        <aside class="sidebar" id="sidebar">
            <div class="brand">
                <img src="https://i.ibb.co/k2GbYLyX/logo.png" alt="Luavify Logo" class="brand-logo" onerror="this.style.display='none'">
                <span>Luavify</span>
            </div>
            <nav class="nav-menu">
                <a href="#" class="nav-item" onclick="navigate('dashboard', this); return false;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                    Dashboard
                </a>
                <a href="#" class="nav-item active" onclick="navigate('projects', this); return false;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    Projects
                </a>
                <a href="#" class="nav-item" onclick="navigate('profile', this); return false;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    Profile
                </a>
                <a href="#" class="nav-item hidden" id="admin-tab" onclick="navigate('admin', this); loadAdminData(); return false;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                    Admin Panel
                </a>
            </nav>
            <div class="sidebar-footer">
                <a href="/auth/logout" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                    Log out
                </a>
            </div>
        </aside>

        <div class="mobile-header">
            <div class="brand" style="padding: 0; font-size: 1.1rem;">
                <img src="https://i.ibb.co/k2GbYLyX/logo.png" alt="Luavify Logo" class="brand-logo" style="width: 28px; height: 28px;" onerror="this.style.display='none'">
                <span>Luavify</span>
            </div>
            <button class="mobile-menu-btn" onclick="toggleSidebar()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
            </button>
        </div>

        <main class="main-content">
            <div id="dashboard" class="page">
                <h1>Dashboard</h1>
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-header">Total executions</div><div class="stat-value" id="dash-total-execs">0</div><div class="stat-desc">All-time</div></div>
                    <div class="stat-card"><div class="stat-header">Monthly obfuscations</div><div class="stat-value" id="dash-obfuscations">0</div><div class="stat-desc">Resets monthly</div></div>
                    <div class="stat-card"><div class="stat-header">Projects</div><div class="stat-value" id="dash-project-count">0</div><div class="stat-desc" id="dash-project-desc">0 of 3 used</div><div class="progress-bar"><div class="progress" id="dash-project-progress" style="width: 0%;"></div></div></div>
                </div>
            </div>

            <div id="projects" class="page active">
                <h1>Projects</h1>
                <div class="stats-grid small">
                    <div class="stat-card"><div class="stat-header">Projects</div><div class="stat-value" id="proj-page-count">0</div><div class="stat-desc" id="proj-page-desc">0 of 3 used</div><div class="progress-bar"><div class="progress" id="proj-page-progress" style="width: 0%;"></div></div></div>
                </div>
                <div id="projects-container"></div>
                <div style="display: flex; flex-direction: column; align-items: center; margin-top: 50px; gap: 15px; padding-bottom: 50px;">
                    <button class="btn btn-primary" id="create-project-btn" onclick="openProjectModal()" style="padding: 14px 28px; font-size: 1rem;">Create New Project</button>
                    <p class="hint" id="project-limit-hint" style="font-size: 0.9rem; color: var(--text-muted); font-weight: 500;">0/3 projects used</p>
                </div>
            </div>

            <div id="profile" class="page">
                <h1>Profile</h1>
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-value" id="p-projects">0</div><div class="stat-desc">Projects Owned</div></div>
                    <div class="stat-card"><div class="stat-value" id="p-scripts">0</div><div class="stat-desc">Scripts Uploaded</div></div>
                </div>
                <div class="profile-grid">
                    <div class="panel">
                        <div class="user-header">
                            <img id="p-avatar" class="avatar" src="https://cdn.discordapp.com/embed/avatars/0.png" alt="Avatar">
                            <div><h2 id="p-username" style="font-size: 1.5rem; font-weight: 800;">Loading...</h2><p id="p-discord-id" style="color: var(--text-muted); font-size: 0.95rem;">...</p></div>
                        </div>
                        <ul class="user-details">
                            <li><span>Discord ID</span> <span id="p-id-val">...</span></li>
                            <li><span>Plan</span> <span style="color: #fbbf24;">Basic</span></li>
                            <li><span>Joined</span> <span id="p-joined">...</span></li>
                        </ul>
                    </div>
                    <div class="panel">
                        <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 8px;">API key</h3>
                        <p style="font-size: 0.9rem; color: var(--text-muted); margin: 0 0 20px 0;">Use it in the Discord bot with /apikey. Keep it secret.</p>
                        <div class="input-group"><input type="password" id="p-api-key" value="Loading..." readonly></div>
                        <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                            <button class="btn btn-outline" onclick="toggleApiKey()">Show Key</button>
                            <button class="btn btn-primary" onclick="copyApiKey()">Copy Key</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="admin" class="page">
                <h1>Admin Panel</h1>
                <div class="panel" style="margin-top: 10px;">
                    <h3 style="margin-bottom: 20px; font-size: 1.2rem;">Registered Discord Users</h3>
                    <div style="overflow-x: auto;">
                        <table class="script-table" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>Avatar</th>
                                    <th>Username</th>
                                    <th>Discord ID</th>
                                    <th>API Key</th>
                                    <th>Joined</th>
                                </tr>
                            </thead>
                            <tbody id="admin-users-table">
                                <tr><td colspan="5" style="text-align:center; padding: 20px;">Loading users...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <div id="projectModal" class="modal">
        <div class="modal-content">
            <h2>Create New Project</h2>
            <input type="text" id="new-project-name" class="modal-input" placeholder="Enter project name...">
            <div class="modal-actions">
                <button class="btn btn-outline" onclick="closeProjectModal()">Cancel</button>
                <button class="btn btn-primary" onclick="createProject()">Create</button>
            </div>
        </div>
    </div>

    <div id="scriptModal" class="modal">
        <div class="modal-content">
            <h2>Upload Script</h2>
            
            <input type="text" id="script-name-input" class="modal-input" placeholder="Script Name (e.g. Auto Farm)">
            
            <div class="file-drop-area" id="drop-area" style="border: 2px dashed rgba(255,255,255,0.2); padding: 40px 20px; text-align: center; border-radius: 12px; cursor: pointer; margin-top: 5px; transition: 0.2s;">
                <input type="file" id="file-input" accept=".lua,.luau,.txt" hidden>
                <div class="file-msg" id="file-msg" style="color: var(--text-muted); font-weight: 500;">Click or drag a .lua file here</div>
            </div>
            
            <div class="modal-actions">
                <button class="btn btn-outline" onclick="closeScriptModal()">Cancel</button>
                <button class="btn btn-primary" id="upload-btn" onclick="uploadScript()" disabled style="opacity: 0.5;">Upload</button>
            </div>
        </div>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content code-modal">
            <div class="code-header"><h2 id="edit-modal-title" style="margin: 0;">Edit Script</h2></div>
            <div class="code-tools">
                <input type="text" id="find-input" placeholder="Find..." style="flex: 1;">
                <input type="text" id="replace-input" placeholder="Replace with..." style="flex: 1;">
                <button class="btn btn-outline btn-sm" onclick="replaceText()">Replace All</button>
            </div>
            <div class="code-body"><textarea id="edit-code-area" class="code-textarea" spellcheck="false"></textarea></div>
            <div class="code-footer">
                <button class="btn btn-outline" onclick="closeEditModal()">Cancel</button>
                <button class="btn btn-primary" onclick="saveEditedCode()">Save Changes</button>
            </div>
        </div>
    </div>

    <script>
        let currentUser = null;
        let projects = [];
        let projectIdCounter = 1;
        let currentProjectTarget = null;
        let selectedFile = null;
        let currentEditTarget = { projectId: null, scriptId: null };

        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
            document.getElementById('menu-backdrop').classList.toggle('active');
        }

        async function checkAuth() {
            try {
                const res = await fetch('/api/me');
                const data = await res.json();
                
                if (!data.loggedIn) {
                    document.getElementById('landing-page').style.display = 'block';
                    document.getElementById('app-dashboard').classList.remove('active');
                    return; 
                }

                document.getElementById('landing-page').style.display = 'none';
                document.getElementById('app-dashboard').classList.add('active');
                
                currentUser = data.user;
                
                document.getElementById('p-username').innerText = currentUser.username;
                document.getElementById('p-discord-id').innerText = currentUser.id;
                document.getElementById('p-id-val').innerText = currentUser.id;
                document.getElementById('p-api-key').value = currentUser.apiKey;
                document.getElementById('p-joined').innerText = new Date(currentUser.joinedAt).toLocaleDateString();
                document.getElementById('dash-total-execs').innerText = currentUser.totalExecutions || 0;

                if (currentUser.avatar) {
                    document.getElementById('p-avatar').src = `https://cdn.discordapp.com/avatars/${currentUser.id}/${currentUser.avatar}.png`;
                }

                if (currentUser.isAdmin) {
                    document.getElementById('admin-tab').classList.remove('hidden');
                }

                loadData(); renderProjects(); updateCounts();

                const path = window.location.pathname.replace('/', '') || 'projects';
                if (document.getElementById(path)) {
                    const navItem = Array.from(document.querySelectorAll('.nav-item')).find(nav => nav.getAttribute('onclick')?.includes(`'${path}'`));
                    if (navItem) navigate(path, navItem);
                }

            } catch (e) {
                console.error("Auth check failed", e);
            }
        }

        async function loadAdminData() {
            const tbody = document.getElementById('admin-users-table');
            tbody.innerHTML = `<tr><td colspan="5" style="text-align:center; padding: 20px;">Loading...</td></tr>`;
            try {
                const res = await fetch('/api/admin/users');
                if (!res.ok) throw new Error("Failed");
                const data = await res.json();
                
                tbody.innerHTML = '';
                data.users.forEach(u => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td><img src="https://cdn.discordapp.com/avatars/${u.id}/${u.avatar}.png" style="width:32px;height:32px;border-radius:50%;" onerror="this.src='https://cdn.discordapp.com/embed/avatars/0.png'"></td>
                        <td style="font-weight:600;">${u.username}</td>
                        <td style="font-family:monospace; color:var(--text-muted);">${u.id}</td>
                        <td style="font-family:monospace; color:var(--accent-red);">${u.apiKey}</td>
                        <td style="color:var(--text-muted);">${new Date(u.joinedAt).toLocaleDateString()}</td>
                    `;
                    tbody.appendChild(tr);
                });
            } catch (e) {
                tbody.innerHTML = `<tr><td colspan="5" style="text-align:center; color: #f87171; padding: 20px;">Failed to load users.</td></tr>`;
            }
        }

        function toggleApiKey() { const input = document.getElementById('p-api-key'); input.type = input.type === 'password' ? 'text' : 'password'; }
        function copyApiKey() { navigator.clipboard.writeText(document.getElementById('p-api-key').value); alert("API Key copied!"); }

        function navigate(pageId, element) {
            document.querySelectorAll('.page').forEach(page => page.classList.remove('active'));
            document.getElementById(pageId).classList.add('active');
            
            if (element) {
                document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
                element.classList.add('active');
            }

            window.history.pushState({}, '', `/${pageId}`);
            if (window.innerWidth <= 768) toggleSidebar();
            document.querySelector('.main-content').scrollTop = 0;
        }

        function loadData() { const saved = localStorage.getItem(`luavify_data_${currentUser.id}`); if (saved) { try { const data = JSON.parse(saved); projects = data.projects || []; projectIdCounter = data.projectIdCounter || 1; } catch(e) {} } }
        function saveData() { localStorage.setItem(`luavify_data_${currentUser.id}`, JSON.stringify({ projects, projectIdCounter })); }

        function updateCounts() {
            const count = projects.length; const percent = (count / 3) * 100;
            document.getElementById('dash-project-count').innerText = count;
            document.getElementById('dash-project-desc').innerText = `${count} of 3 used`;
            document.getElementById('dash-project-progress').style.width = `${percent}%`;
            document.getElementById('dash-obfuscations').innerText = projects.reduce((acc, p) => acc + p.scripts.length, 0);
            document.getElementById('proj-page-count').innerText = count;
            document.getElementById('proj-page-desc').innerText = `${count} of 3 used`;
            document.getElementById('proj-page-progress').style.width = `${percent}%`;
            document.getElementById('project-limit-hint').innerText = `${count}/3 projects used`;
            document.getElementById('p-projects').innerText = count;
            document.getElementById('p-scripts').innerText = projects.reduce((acc, p) => acc + p.scripts.length, 0);
            
            const btn = document.getElementById('create-project-btn');
            if (currentUser.isAdmin) {
                btn.disabled = false; btn.style.opacity = '1';
                btn.innerText = "Create New Project";
                document.getElementById('project-limit-hint').innerText = `${count} projects (Admin Mode)`;
            } else {
                btn.disabled = count >= 3; btn.style.opacity = count >= 3 ? '0.5' : '1';
                btn.innerText = count >= 3 ? "Limit Reached" : "Create New Project";
            }
        }

        function renderProjects() {
            const container = document.getElementById('projects-container'); container.innerHTML = '';
            if (projects.length === 0) { container.innerHTML = `<div style="padding: 50px 0; text-align: center; color: var(--text-muted); font-size: 1.1rem;">No projects yet. Create one to get started.</div>`; return; }
            projects.forEach(proj => {
                const projectHTML = `
                    <div class="project-item">
                        <div class="project-header-row">
                            <div class="project-info">
                                <div class="project-icon"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg></div>
                                <div><h4>${proj.name}</h4><p>${proj.hash}</p></div>
                            </div>
                            <div class="project-actions">
                                <span class="script-count">${proj.scripts.length}/3 scripts</span>
                                <button class="btn btn-outline btn-sm" onclick="deleteProject(${proj.id})">Delete</button>
                                <button class="btn btn-primary btn-sm" onclick="openScriptModal(${proj.id})">+ Add Script</button>
                            </div>
                        </div>
                        ${proj.scripts.length > 0 ? `
                        <div class="script-table-container">
                            <table class="script-table">
                                <thead><tr><th>Script</th><th>Status</th><th>Keyless</th><th>Actions</th></tr></thead>
                                <tbody>
                                    ${proj.scripts.map(script => `
                                        <tr>
                                            <td><div class="script-info"><div class="toggle-switch ${script.active ? 'active' : ''}" onclick="toggleScript(${proj.id}, ${script.id}, 'active')"><div class="toggle-knob"></div></div><div class="script-details"><span class="script-name">${script.name}</span><span class="script-hash">${script.hash.substring(0, 16)}...</span></div></div></td>
                                            <td><span class="badge ${script.active ? 'badge-active' : 'badge-disabled'}">${script.active ? 'Active' : 'Disabled'}</span></td>
                                            <td><div class="toggle-switch ${script.keyless ? 'active' : ''}" onclick="toggleScript(${proj.id}, ${script.id}, 'keyless')"><div class="toggle-knob"></div></div></td>
                                            <td><div class="action-buttons"><button class="btn btn-outline btn-sm text-green" onclick="copyLoader(${proj.id}, ${script.id}, event)">Loader</button><button class="btn btn-outline btn-sm" onclick="openEditModal(${proj.id}, ${script.id})">Edit</button><button class="btn btn-outline btn-sm text-red" onclick="deleteScript(${proj.id}, ${script.id})">Delete</button></div></td>
                                        </tr>
                                    `).join('')}
                                </tbody>
                            </table>
                        </div>
                        ` : `<div style="padding: 40px; text-align: center; color: var(--text-muted); border-top: 1px solid rgba(255,255,255,0.05);">No scripts uploaded yet.</div>`}
                    </div>
                `;
                container.insertAdjacentHTML('beforeend', projectHTML);
            });
        }

        function openProjectModal() { 
            if(!currentUser.isAdmin && projects.length >= 3) return;
            document.getElementById('new-project-name').value = ''; 
            document.getElementById('projectModal').classList.add('active'); 
        }
        function closeProjectModal() { document.getElementById('projectModal').classList.remove('active'); }
        function createProject() {
            const name = document.getElementById('new-project-name').value.trim();
            if (!name) return alert("Enter a project name.");
            projects.push({ id: projectIdCounter++, name: name, hash: generateHash(), scripts: [] });
            closeProjectModal(); renderProjects(); updateCounts(); saveData();
        }
        function deleteProject(id) { if (confirm("Are you sure you want to delete this project?")) { projects = projects.filter(p => p.id !== id); renderProjects(); updateCounts(); saveData(); } }

        async function toggleScript(projectId, scriptId, type) {
            const script = projects.find(p => p.id === projectId).scripts.find(s => s.id === scriptId);
            
            if (type === 'active') {
                script.active = !script.active;
                await fetch('/toggle', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ hash: script.hash, active: script.active })
                });
            }
            if (type === 'keyless') script.keyless = !script.keyless;
            
            renderProjects(); saveData();
        }

        async function deleteScript(projectId, scriptId) { 
            if (confirm("Delete this script?")) { 
                const proj = projects.find(p => p.id === projectId); 
                const script = proj.scripts.find(s => s.id === scriptId);
                
                await fetch('/delete-script', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ hash: script.hash })
                });

                proj.scripts = proj.scripts.filter(s => s.id !== scriptId); 
                renderProjects(); updateCounts(); saveData(); 
            } 
        }
        
        function copyLoader(projectId, scriptId, event) {
            const script = projects.find(p => p.id === projectId).scripts.find(s => s.id === scriptId);
            // This now points to the HTML page to view
            const viewLink = `https://luavify-protector.itskevin.workers.dev/files/v4/loaders/${script.hash}.lua`;
            
            // Or copy the actual loader for Roblox
            const loaderString = `loadstring(game:HttpGet("https://luavify-protector.itskevin.workers.dev/download/${script.hash}.lua"))()`;
            
            navigator.clipboard.writeText(loaderString).then(() => { 
                const btn = event.target; const original = btn.innerText; 
                btn.innerText = 'Copied!'; btn.style.color = '#4ade80'; 
                setTimeout(() => { btn.innerText = original; btn.style.color = ''; }, 1500); 
            });
        }

        function openEditModal(projectId, scriptId) {
            const script = projects.find(p => p.id === projectId).scripts.find(s => s.id === scriptId);
            currentEditTarget = { projectId, scriptId };
            document.getElementById('edit-modal-title').innerText = `Editing: ${script.name}`;
            document.getElementById('edit-code-area').value = script.code || '';
            document.getElementById('editModal').classList.add('active');
        }
        function closeEditModal() { document.getElementById('editModal').classList.remove('active'); }
        function saveEditedCode() {
            if (!currentEditTarget.projectId) return;
            const script = projects.find(p => p.id === currentEditTarget.projectId).scripts.find(s => s.id === currentEditTarget.scriptId);
            script.code = document.getElementById('edit-code-area').value; saveData(); closeEditModal();
        }
        function replaceText() { const findText = document.getElementById('find-input').value; const replaceText = document.getElementById('replace-input').value; const textarea = document.getElementById('edit-code-area'); if (!findText) return; textarea.value = textarea.value.split(findText).join(replaceText); }

        function openScriptModal(projectId) {
            const proj = projects.find(p => p.id === projectId);
            if (proj.scripts.length >= 3) return alert("Maximum 3 scripts per project.");
            currentProjectTarget = projectId; 
            document.getElementById('scriptModal').classList.add('active');
            
            document.getElementById('script-name-input').value = '';
            selectedFile = null; 
            document.getElementById('file-input').value = '';
            document.getElementById('file-msg').innerHTML = `<span>Click or drag a .lua file here</span>`;
            const btn = document.getElementById('upload-btn'); btn.disabled = true; btn.style.opacity = '0.5'; btn.innerText = "Upload";
        }
        function closeScriptModal() { document.getElementById('scriptModal').classList.remove('active'); }

        const dropArea = document.getElementById('drop-area');
        const fileInput = document.getElementById('file-input');
        dropArea.addEventListener('click', () => fileInput.click());
        dropArea.addEventListener('dragover', (e) => { e.preventDefault(); dropArea.style.borderColor = 'var(--accent-red)'; });
        dropArea.addEventListener('dragleave', (e) => { e.preventDefault(); dropArea.style.borderColor = 'rgba(255,255,255,0.2)'; });
        dropArea.addEventListener('drop', (e) => { e.preventDefault(); dropArea.style.borderColor = 'rgba(255,255,255,0.2)'; if (e.dataTransfer.files.length) handleFile(e.dataTransfer.files[0]); });
        fileInput.addEventListener('change', (e) => { if (e.target.files.length) handleFile(e.target.files[0]); });

        function handleFile(file) {
            const allowedExtensions = /(\.lua|\.luau|\.txt)$/i;
            if (!allowedExtensions.exec(file.name)) return alert('Invalid file type. Please upload .lua, .luau, or .txt');
            selectedFile = file;
            document.getElementById('file-msg').innerHTML = `<span style="color: white;">${file.name}</span>`;
            const btn = document.getElementById('upload-btn'); btn.disabled = false; btn.style.opacity = '1';
        }

        // RELIABLE OBFUSCATION LOGIC (Base64)
        function obfuscateLua(code) {
            // Convert string to Base64 safely
            const bytes = new TextEncoder().encode(code);
            let binary = '';
            for (let i = 0; i < bytes.length; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            const base64 = btoa(binary);
            
            // Wrap in Lua loader using Base64 decoding
            return `local b = "${base64}" local function decode(data) local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end loadstring(decode(b))()`;
        }

        async function uploadScript() {
            if (!selectedFile || !currentProjectTarget) return;
            
            let customName = document.getElementById('script-name-input').value.trim();
            if (!customName) customName = selectedFile.name;

            const btn = document.getElementById('upload-btn'); btn.innerText = "Obfuscating..."; btn.disabled = true;
            const reader = new FileReader();
            
            reader.onload = async function(e) {
                const originalCode = e.target.result;
                try {
                    // 1. Obfuscate locally
                    const obfuscatedCode = obfuscateLua(originalCode);

                    // 2. Upload to Cloudflare
                    const response = await fetch(`/upload`, { 
                        method: 'POST', 
                        headers: { 'Content-Type': 'application/json' }, 
                        body: JSON.stringify({ code: obfuscatedCode }) 
                    });
                    
                    if (!response.ok) throw new Error("Upload failed");
                    const data = await response.json();
                    
                    const proj = projects.find(p => p.id === currentProjectTarget);
                    proj.scripts.push({ 
                        id: Date.now(), 
                        name: customName, 
                        hash: data.hash, 
                        active: true, 
                        keyless: false, 
                        code: obfuscatedCode 
                    });
                    
                    closeScriptModal(); renderProjects(); updateCounts(); saveData();
                } catch (error) { 
                    console.error(error);
                    alert("Failed to process script."); 
                    btn.innerText = "Upload"; btn.disabled = false; 
                }
            };
            reader.readAsText(selectedFile);
        }

        function generateHash() { return [...Array(32)].map(() => Math.floor(Math.random() * 16).toString(16)).join(''); }
        
        checkAuth();
    </script>
</body>
</html>
