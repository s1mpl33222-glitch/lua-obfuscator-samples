<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VSO · Obfuscator</title>
    <link rel="icon" type="image/png" href="https://imgs.search.brave.com/OF6JXh9ugGDEM2lE1WPfkr1Pn73jc79XYsESokawyGw/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvcHQvdGh1bWIv/Ny83My9Ucm9sbGZh/Y2UucG5nLzI1MHB4/LVRyb2xsZmFjZS5w/bmc">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');

        /* ============================================
           RESET & BASE
        ============================================ */
        * { margin: 0; padding: 0; box-sizing: border-box; }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #000;
            color: #fff;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            overflow-x: hidden;
        }

        /* ============================================
           ANIMAÇÃO DE FUNDO (PARTÍCULAS/LUZ)
        ============================================ */
        .bg-glow {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
            background: radial-gradient(ellipse at 30% 20%, rgba(255,255,255,0.02) 0%, transparent 50%),
                        radial-gradient(ellipse at 70% 80%, rgba(255,255,255,0.01) 0%, transparent 50%);
        }

        .bg-glow::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 800px;
            height: 800px;
            transform: translate(-50%, -50%);
            background: radial-gradient(circle, rgba(255,255,255,0.02) 0%, transparent 70%);
            animation: pulseGlow 8s ease-in-out infinite alternate;
        }

        @keyframes pulseGlow {
            0% { transform: translate(-50%, -50%) scale(1); opacity: 0.3; }
            100% { transform: translate(-50%, -50%) scale(1.8); opacity: 1; }
        }

        /* ============================================
           CONTAINER PRINCIPAL
        ============================================ */
        .site-wrapper {
            position: relative;
            z-index: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 40px;
        }

        /* ============================================
           NAVBAR
        ============================================ */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 32px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            margin-bottom: 60px;
            animation: fadeDown 0.8s ease forwards;
            opacity: 0;
        }

        @keyframes fadeDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .navbar .logo {
            font-size: 20px;
            font-weight: 300;
            letter-spacing: 4px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.8);
        }

        .navbar .logo span {
            font-weight: 600;
            color: #fff;
        }

        .navbar .nav-links {
            display: flex;
            align-items: center;
            gap: 32px;
        }

        .navbar .nav-links a {
            color: rgba(255,255,255,0.3);
            text-decoration: none;
            font-size: 13px;
            font-weight: 400;
            letter-spacing: 1px;
            transition: color 0.3s ease;
            position: relative;
        }

        .navbar .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 0;
            height: 1px;
            background: #fff;
            transition: width 0.3s ease;
        }

        .navbar .nav-links a:hover {
            color: #fff;
        }

        .navbar .nav-links a:hover::after {
            width: 100%;
        }

        .navbar .btn-nav {
            padding: 10px 28px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 50px;
            color: #fff;
            font-size: 13px;
            font-weight: 400;
            letter-spacing: 0.5px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .navbar .btn-nav:hover {
            background: rgba(255,255,255,0.1);
            border-color: rgba(255,255,255,0.15);
        }

        /* ============================================
           HERO
        ============================================ */
        .hero {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            padding: 20px 0 80px 0;
            animation: fadeUp 1s ease 0.2s forwards;
            opacity: 0;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero-content {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .hero-content .badge {
            display: inline-block;
            padding: 6px 18px;
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 50px;
            font-size: 11px;
            font-weight: 400;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.2);
            width: fit-content;
        }

        .hero-content h1 {
            font-size: 56px;
            font-weight: 200;
            line-height: 1.1;
            letter-spacing: -1px;
        }

        .hero-content h1 strong {
            font-weight: 600;
            background: linear-gradient(135deg, #fff 60%, rgba(255,255,255,0.4));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-content p {
            font-size: 16px;
            font-weight: 300;
            line-height: 1.7;
            color: rgba(255,255,255,0.3);
            max-width: 420px;
        }

        .hero-content .btn-group {
            display: flex;
            gap: 16px;
            margin-top: 8px;
        }

        .btn-primary {
            padding: 14px 40px;
            background: #fff;
            color: #000;
            border: none;
            border-radius: 50px;
            font-size: 14px;
            font-weight: 500;
            letter-spacing: 0.5px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: rgba(255,255,255,0.85);
            transform: scale(1.02);
        }

        .btn-secondary {
            padding: 14px 40px;
            background: transparent;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 50px;
            color: #fff;
            font-size: 14px;
            font-weight: 400;
            letter-spacing: 0.5px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            border-color: rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.03);
        }

        .hero-stats {
            display: flex;
            gap: 48px;
            margin-top: 16px;
        }

        .hero-stats .stat {
            display: flex;
            flex-direction: column;
        }

        .hero-stats .stat .number {
            font-size: 28px;
            font-weight: 300;
            letter-spacing: 1px;
        }

        .hero-stats .stat .label {
            font-size: 12px;
            font-weight: 300;
            color: rgba(255,255,255,0.15);
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-top: 4px;
        }

        /* Hero Visual (lado direito) */
        .hero-visual {
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        .hero-visual .box {
            background: rgba(255,255,255,0.02);
            border: 1px solid rgba(255,255,255,0.04);
            border-radius: 24px;
            padding: 48px 40px;
            width: 100%;
            max-width: 420px;
            text-align: center;
            backdrop-filter: blur(10px);
            transition: all 0.5s ease;
        }

        .hero-visual .box:hover {
            border-color: rgba(255,255,255,0.08);
            transform: translateY(-4px);
        }

        .hero-visual .box .code-icon {
            font-size: 32px;
            color: rgba(255,255,255,0.1);
            margin-bottom: 16px;
            display: block;
            font-weight: 100;
        }

        .hero-visual .box .code-snippet {
            font-family: 'Inter', monospace;
            font-size: 13px;
            font-weight: 300;
            color: rgba(255,255,255,0.15);
            letter-spacing: 0.5px;
            line-height: 1.8;
            word-break: break-all;
        }

        .hero-visual .box .code-snippet span {
            color: rgba(255,255,255,0.4);
        }

        /* ============================================
           SEÇÃO "COMO FUNCIONA"
        ============================================ */
        .how-section {
            padding: 80px 0;
            border-top: 1px solid rgba(255,255,255,0.03);
            border-bottom: 1px solid rgba(255,255,255,0.03);
            animation: fadeUp 1s ease 0.4s forwards;
            opacity: 0;
        }

        .how-section .section-label {
            font-size: 11px;
            font-weight: 400;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.15);
            margin-bottom: 12px;
        }

        .how-section h2 {
            font-size: 32px;
            font-weight: 200;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
        }

        .how-section h2 strong {
            font-weight: 500;
        }

        .how-section .sub {
            color: rgba(255,255,255,0.2);
            font-size: 15px;
            font-weight: 300;
            margin-bottom: 48px;
        }

        .how-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
        }

        .how-card {
            background: rgba(255,255,255,0.02);
            border: 1px solid rgba(255,255,255,0.03);
            border-radius: 20px;
            padding: 32px 28px;
            transition: all 0.4s ease;
        }

        .how-card:hover {
            border-color: rgba(255,255,255,0.08);
            transform: translateY(-6px);
            background: rgba(255,255,255,0.03);
        }

        .how-card .step {
            font-size: 12px;
            font-weight: 400;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.1);
            margin-bottom: 12px;
        }

        .how-card h3 {
            font-size: 18px;
            font-weight: 400;
            margin-bottom: 8px;
        }

        .how-card p {
            font-size: 14px;
            font-weight: 300;
            line-height: 1.6;
            color: rgba(255,255,255,0.2);
        }

        /* ============================================
           RODAPÉ
        ============================================ */
        .footer {
            padding: 40px 0 48px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            border-top: 1px solid rgba(255,255,255,0.02);
            margin-top: 20px;
        }

        .footer .copy {
            font-size: 13px;
            font-weight: 300;
            color: rgba(255,255,255,0.1);
            letter-spacing: 0.5px;
        }

        .footer .copy span {
            color: rgba(255,255,255,0.2);
            font-weight: 400;
        }

        .footer .social {
            display: flex;
            gap: 24px;
        }

        .footer .social a {
            color: rgba(255,255,255,0.1);
            text-decoration: none;
            font-size: 13px;
            font-weight: 300;
            transition: color 0.3s ease;
            letter-spacing: 1px;
        }

        .footer .social a:hover {
            color: rgba(255,255,255,0.3);
        }

        /* ============================================
           RESPONSIVO
        ============================================ */
        @media (max-width: 992px) {
            .hero {
                grid-template-columns: 1fr;
                text-align: center;
                gap: 40px;
            }

            .hero-content p {
                max-width: 100%;
            }

            .hero-content .btn-group {
                justify-content: center;
            }

            .hero-stats {
                justify-content: center;
            }

            .hero-visual .box {
                max-width: 100%;
            }

            .how-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 640px) {
            .site-wrapper {
                padding: 0 20px;
            }

            .navbar {
                flex-direction: column;
                gap: 16px;
                padding: 20px 0;
            }

            .navbar .nav-links {
                gap: 20px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .hero-content h1 {
                font-size: 32px;
            }

            .hero-content .btn-group {
                flex-direction: column;
                align-items: center;
            }

            .hero-stats {
                gap: 24px;
                flex-wrap: wrap;
            }

            .how-grid {
                grid-template-columns: 1fr;
            }

            .footer {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<!-- ============================================
FUNDO
============================================ -->
<div class="bg-glow"></div>

<!-- ============================================
SITE
============================================ -->
<div class="site-wrapper">

    <!-- ============================================
    NAVBAR
    ============================================ -->
    <nav class="navbar">
        <div class="logo">VSO<span>.</span></div>
        <div class="nav-links">
            <a href="/">Início</a>
            <a href="/login" class="btn-nav">Entrar</a>
        </div>
    </nav>

    <!-- ============================================
    HERO
    ============================================ -->
    <section class="hero">
        <div class="hero-content">
            <span class="badge">Proteção avançada</span>
            <h1>
                Obfuscação<br>
                <strong>feita do jeito certo</strong>
            </h1>
            <p>
                Proteja seus scripts com a melhor tecnologia. Código seguro,
                rápido e confiável para seus projetos no Roblox.
            </p>
            <div class="btn-group">
                <a href="/auth/discord" class="btn-primary">Começar</a>
                <a href="#como-funciona" class="btn-secondary">Como funciona</a>
            </div>
            <div class="hero-stats">
                <div class="stat">
                    <span class="number" id="totalScripts">0</span>
                    <span class="label">Scripts protegidos</span>
                </div>
                <div class="stat">
                    <span class="number">24/7</span>
                    <span class="label">Disponível</span>
                </div>
            </div>
        </div>

        <div class="hero-visual">
            <div class="box">
                <span class="code-icon">‹/›</span>
                <div class="code-snippet">
                    <span>loadstring(game:HttpGet(</span><br>
                    <span>"https://vso-test.onrender.com/api/..."</span><br>
                    <span>))()</span>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================
    COMO FUNCIONA
    ============================================ -->
    <section class="how-section" id="como-funciona">
        <span class="section-label">Processo</span>
        <h2>Como funciona a <strong>proteção</strong></h2>
        <p class="sub">Três passos simples para proteger seu script</p>

        <div class="how-grid">
            <div class="how-card">
                <div class="step">01</div>
                <h3>Cole seu script</h3>
                <p>Insira o código que você deseja proteger na plataforma.</p>
            </div>
            <div class="how-card">
                <div class="step">02</div>
                <h3>Ofusque</h3>
                <p>Nosso sistema gera um link único e seguro para seu script.</p>
            </div>
            <div class="how-card">
                <div class="step">03</div>
                <h3>Use no Roblox</h3>
                <p>Execute o loadstring gerado e seu script estará protegido.</p>
            </div>
        </div>
    </section>

    <!-- ============================================
    RODAPÉ
    ============================================ -->
    <footer class="footer">
        <div class="copy">© 2025 <span>VSO Team</span></div>
        <div class="social">
            <a href="https://discord.gg/vHr2Z7tCXB" target="_blank">Discord</a>
            <a href="#">Twitter</a>
            <a href="#">GitHub</a>
        </div>
    </footer>

</div>

<!-- ============================================
SCRIPT
============================================ -->
<script>
    // Total de scripts
    fetch('/api/scripts')
        .then(r => r.json())
        .then(d => {
            document.getElementById('totalScripts').textContent = d.total || 0;
        })
        .catch(() => {
            document.getElementById('totalScripts').textContent = '0';
        });

    // Animação de entrada suave para os cards (Intersection Observer)
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.how-card');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry, index) => {
                if (entry.isIntersecting) {
                    setTimeout(() => {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }, index * 100);
                }
            });
        }, { threshold: 0.1 });

        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = `all 0.6s cubic-bezier(0.16, 1, 0.3, 1)`;
            observer.observe(card);
        });
    });
</script>

</body>
</html>
