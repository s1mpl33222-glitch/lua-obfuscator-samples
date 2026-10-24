<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MultiHub</title>
  <meta name="description" content="Site oficial do MultiHub - Scripts e conteúdo exclusivo.">
  
  <!-- Fonte futurista -->
  <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500;700&display=swap" rel="stylesheet">

  <!-- Script do Google AdSense para verificação -->
  <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-5219015865806192"
     crossorigin="anonymous"></script>

  <style>
    :root {
      --neon: #ff0000;
      --neon-2: #ff3333;
      --bg1: #000000;
      --bg2: #111111;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: 'Orbitron', sans-serif;
      color: #ffffff;
      background-color: #000000;
      position: relative;
      overflow-x: hidden;
    }
    
    /* Canvas para partículas */
    #particles-js {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: -1;
    }
    
    header {
      position: sticky;
      top: 0;
      z-index: 10;
      background: rgba(0,0,0,0.8);
      backdrop-filter: blur(6px);
      padding: 0.75rem 1rem;
      border-bottom: 1px solid var(--neon);
    }
    nav {
      display: flex;
      flex-wrap: wrap;
      gap: 0.75rem;
      align-items: center;
      justify-content: center;
      max-width: 1100px;
      margin: 0 auto;
    }
    nav a {
      color: #ffffff;
      text-decoration: none;
      font-weight: 700;
      padding: 0.5rem 0.9rem;
      border: 1px solid var(--neon);
      border-radius: 999px;
      text-shadow: 0 0 5px var(--neon), 0 0 10px var(--neon);
      box-shadow: inset 0 0 8px rgba(255,0,0,0.35), 0 0 10px rgba(255,0,0,0.35);
      transition: transform 0.15s ease, box-shadow 0.15s ease, color 0.15s ease, border-color 0.15s;
    }
    nav a:hover {
      color: #ffffff;
      transform: translateY(-1px);
      border-color: rgba(255,255,255,0.7);
      box-shadow: inset 0 0 10px rgba(255,255,255,0.3), 0 0 16px rgba(255,255,255,0.4);
    }
    main {
      max-width: 1000px;
      margin: auto;
      padding: 1rem;
      text-align: center;
    }
    .logo-container {
      display: flex;
      justify-content: center;
      margin: 1rem 0;
    }
    .logo {
      max-width: 200px;
      height: auto;
      border-radius: 10px;
      box-shadow: 0 0 15px var(--neon);
    }
    h1 {
      margin: 1rem 0 0.5rem;
      text-shadow: 0 0 5px var(--neon), 0 0 10px var(--neon), 0 0 20px var(--neon);
      color: #ffffff;
    }
    h2 {
      color: #ffffff;
    }
    .ad-container {
      margin: 1.5rem auto 1rem;
      max-width: 728px;
    }
    .site-promo {
      background: rgba(255,0,0,0.1);
      border: 1px solid var(--neon);
      border-radius: 12px;
      padding: 1.5rem;
      margin: 1.5rem 0;
      box-shadow: 0 0 15px rgba(255,0,0,0.3);
    }
    .site-promo h3 {
      color: #ffffff;
      margin-top: 0;
      text-shadow: 0 0 5px var(--neon);
    }
    .site-promo p {
      color: #ffffff;
      margin-bottom: 1.5rem;
    }
    .site-promo a {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #000000;
      color: #ffffff;
      text-decoration: none;
      border: 1px solid var(--neon);
      border-radius: 8px;
      font-weight: bold;
      box-shadow: 0 0 10px var(--neon);
      transition: all 0.3s ease;
    }
    .site-promo a:hover {
      background: rgba(255,0,0,0.2);
      transform: translateY(-2px);
      box-shadow: 0 0 20px var(--neon);
    }
    textarea {
      width: min(90%, 820px);
      height: 4.2rem;
      margin: 1rem auto;
      display: block;
      font-size: 1rem;
      border: 1px solid var(--neon);
      border-radius: 10px;
      padding: 0.8rem;
      background: rgba(0,0,0,0.6);
      color: #ffffff;
      resize: none;
      box-shadow: 0 0 10px var(--neon-2), inset 0 0 10px rgba(255,0,0,0.25);
    }
    button {
      padding: 0.75rem 1.5rem;
      font-size: 1rem;
      border: 1px solid var(--neon);
      border-radius: 10px;
      background: #000000;
      color: #ffffff;
      font-weight: 800;
      cursor: pointer;
      box-shadow: 0 0 5px var(--neon), 0 0 10px var(--neon), 0 0 20px var(--neon);
      transition: transform 0.15s ease, box-shadow 0.15s ease;
    }
    button:hover {
      transform: translateY(-1px) scale(1.03);
      box-shadow: 0 0 10px var(--neon), 0 0 20px var(--neon), 0 0 40px var(--neon);
      background: rgba(255,0,0,0.1);
    }
    .discord-btn {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #000000;
      color: #ffffff;
      text-decoration: none;
      border: 1px solid var(--neon);
      border-radius: 8px;
      font-weight: bold;
      box-shadow: 0 0 10px var(--neon);
      transition: all 0.3s ease;
      margin-top: 0.5rem;
    }
    .discord-btn:hover {
      background: rgba(255,0,0,0.2);
      transform: translateY(-2px);
      box-shadow: 0 0 20px var(--neon);
    }
    section.card {
      background: rgba(0,0,0,0.7);
      padding: 1rem;
      margin-top: 1rem;
      border-radius: 12px;
      text-align: left;
      box-shadow: 0 0 10px rgba(255,0,0,0.3);
      border: 1px solid var(--neon);
    }
    section.card p {
      color: #ffffff;
    }
    section.card a {
      color: #ffffff;
      text-decoration: none;
      border-bottom: 1px solid var(--neon);
    }
    section.card a:hover {
      color: var(--neon);
    }
    /* Player do YouTube responsivo (16:9) */
    .video-wrap {
      position: relative;
      width: 100%;
      max-width: 900px;
      margin: 0.5rem auto 0;
      aspect-ratio: 16 / 9; /* fallback abaixo */
      background: rgba(0,0,0,0.35);
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 0 10px var(--neon);
    }
    /* Fallback para navegadores sem aspect-ratio */
    .video-fallback {
      position: relative;
      width: 100%;
      padding-top: 56.25%;
    }
    .video-fallback iframe {
      position: absolute;
      inset: 0;
      width: 100%;
      height: 100%;
      border: 0;
    }
    footer {
      background: rgba(0,0,0,0.8);
      padding: 1rem;
      text-align: center;
      font-size: 0.9rem;
      margin-top: 1rem;
      color: #ffffff;
      border-top: 1px solid var(--neon);
    }
  </style>
</head>
<body>
  <!-- Canvas para partículas -->
  <div id="particles-js"></div>
  
  <header>
    <nav>
      <a href="#home">Início</a>
      <a href="#sobre">Sobre</a>
      <a href="#youtube">YouTube</a>
      <a href="#contato">Contato</a>
      <a href="#privacidade">Privacidade</a>
      <a href="#termos">Termos</a>
      <a href="https://discord.gg/YJk6G8tzVB" target="_blank" rel="noopener">💬 Discord</a>
      <a href="https://www.youtube.com/@MultiHub07" target="_blank" rel="noopener">▶ YouTube</a>
    </nav>
  </header>

  <main id="home">
    <!-- Logo do site -->
    <div class="logo-container">
      <img src="https://i.ibb.co/bRzfWWtR/Logo.png" alt="MultiHub Logo" class="logo">
    </div>
    
    <h1>🚀Driving Empire Script 🚀</h1>

    <!-- Promoção do site principal -->
    <div class="site-promo">
      <h3>🚀 ACESSE NOSSO SITE COM MAIS SCRIPTS! 🚀</h3>
      <p>Descubra diversos scripts exclusivos, tutoriais e conteúdos premium em nosso site principal!</p>
      <a href="https://multihubpro.vercel.app/" target="_blank" rel="noopener">👉 ACESSAR MULTIHUB.SITE 👈</a>
    </div>

    <!-- Bloco de anúncio (opcional) -->
    <div class="ad-container">
      <ins class="adsbygoogle"
           style="display:block"
           data-ad-client="SEU-CODIGO-CLIENTE"
           data-ad-slot="SEU-CODIGO-SLOT"
           data-ad-format="auto"
           data-full-width-responsive="true"></ins>
      <script>
        (adsbygoogle = window.adsbygoogle || []).push({});
      </script>
    </div>

    <textarea id="code" readonly>⁨⁨loadstring(game:HttpGet("https://raw.githubusercontent.com/Breadido/Codecoat/main/looder.luau"))()</textarea>
    <button onclick="copyCode()">📋 Copy Loadstring</button>

    <section id="sobre" class="card">
      <h2>Sobre</h2>
      <p>Este site foi criado para compartilhar scripts e conteúdos exclusivos de forma segura e prática. Nosso objetivo é oferecer ferramentas de qualidade para a comunidade.</p>
    </section>

    <section id="youtube" class="card">
  <h2>Assista no YouTube</h2>
  <!-- Player responsivo com fallback -->
  <div class="video-wrap">
    <div class="video-fallback">
      <iframe
        src="https://www.youtube.com/embed/oaVaXQYDPHM"
        title="Script for Driving Empire - Auto Farm Cash, Infinite Nitro, Set Velocity - No Key!"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen
        loading="lazy">
      </iframe>
    </div>
  </div>
  <p style="margin-top:0.75rem">
    Inscreva-se no canal: 
    <a href="https://www.youtube.com/watch?v=oaVaXQYDPHM" target="_blank" rel="noopener">
      Script for Driving Empire - Auto Farm Cash, Infinite Nitro, Set Velocity - No Key!
    </a>
  </p>
</section>

    <section id="contato" class="card">
      <h2>Contato</h2>
      <p>Entre em contato conosco através do nosso servidor do Discord:</p>
      <a href="https://discord.gg/qfR6HbJqmY" target="_blank" rel="noopener" class="discord-btn">
        🎮 Entrar no Discord
      </a>
    </section>

    <section id="privacidade" class="card">
      <h2>Política de Privacidade</h2>
      <p>Coletamos apenas informações necessárias para melhorar a experiência do usuário. Não compartilhamos dados pessoais com terceiros sem consentimento.</p>
    </section>

    <section id="termos" class="card">
      <h2>Termos de Uso</h2>
      <p>Ao utilizar este site, você concorda em não reproduzir ou distribuir o conteúdo sem autorização. O uso indevido pode resultar em medidas legais.</p>
    </section>
  </main>

  <footer>
    &copy; 2025 MultiHub — Todos os direitos reservados.
  </footer>

  <!-- Script para partículas -->
  <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
  
  <!-- PROPELERADS MULTITAG - MESMA TAG DO SEU SITE PRINCIPAL -->
  <script src="https://fpyf8.com/88/tag.min.js" data-zone="179015" async data-cfasync="false"></script>

  <script>
    // Inicializar partículas
    particlesJS('particles-js', {
      particles: {
        number: {
          value: 80,
          density: {
            enable: true,
            value_area: 800
          }
        },
        color: {
          value: "#ff0000"
        },
        shape: {
          type: "circle",
          stroke: {
            width: 0,
            color: "#000000"
          }
        },
        opacity: {
          value: 0.5,
          random: true,
          anim: {
            enable: true,
            speed: 1,
            opacity_min: 0.1,
            sync: false
          }
        },
        size: {
          value: 3,
          random: true,
          anim: {
            enable: true,
            speed: 2,
            size_min: 0.1,
            sync: false
          }
        },
        line_linked: {
          enable: true,
          distance: 150,
          color: "#ff0000",
          opacity: 0.4,
          width: 1
        },
        move: {
          enable: true,
          speed: 2,
          direction: "none",
          random: true,
          straight: false,
          out_mode: "out",
          bounce: false,
          attract: {
            enable: false,
            rotateX: 600,
            rotateY: 1200
          }
        }
      },
      interactivity: {
        detect_on: "canvas",
        events: {
          onhover: {
            enable: true,
            mode: "repulse"
          },
          onclick: {
            enable: true,
            mode: "push"
          },
          resize: true
        },
        modes: {
          grab: {
            distance: 400,
            line_linked: {
              opacity: 1
            }
          },
          bubble: {
            distance: 400,
            size: 40,
            duration: 2,
            opacity: 8,
            speed: 3
          },
          repulse: {
            distance: 100,
            duration: 0.4
          },
          push: {
            particles_nb: 4
          },
          remove: {
            particles_nb: 2
          }
        }
      },
      retina_detect: true
    });

    function copyCode() {
      const txt = document.getElementById('code').value;
      navigator.clipboard.writeText(txt).then(
        () => alert('✅ Loadstring copiado!'),
        () => alert('❌ Falha ao copiar.')
      );
    }
  </script>
</body>
</html>
