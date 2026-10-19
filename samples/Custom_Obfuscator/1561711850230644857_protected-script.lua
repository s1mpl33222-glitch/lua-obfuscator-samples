<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>raw.monload - protection</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,500;14..32,700&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">
<style>
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  body {
    min-height: 100vh;
    background: radial-gradient(circle at 20% 30%, #0b0b12, #030305);
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Inter', system-ui, -apple-system, sans-serif;
    position: relative;
    overflow-x: hidden;
  }

  body::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse at 40% 50%, rgba(255, 51, 102, 0.08), transparent 70%);
    pointer-events: none;
    animation: pulseGlow 6s infinite alternate;
  }

  @keyframes pulseGlow {
    0% { opacity: 0.4; }
    100% { opacity: 1; }
  }

  .container {
    position: relative;
    z-index: 2;
    text-align: center;
    padding: 2rem;
  }

  .link {
    display: inline-block;
    font-size: clamp(2rem, 8vw, 4.5rem);
    font-weight: 700;
    text-decoration: none;
    background: linear-gradient(135deg, #ff3366 0%, #ff6b4a 100%);
    background-clip: text;
    -webkit-background-clip: text;
    color: transparent;
    text-shadow: 0 0 20px rgba(255, 51, 102, 0.3);
    transition: all 0.3s cubic-bezier(0.2, 0.9, 0.4, 1.1);
    opacity: 0;
    transform: translateY(20px) scale(0.98);
    animation: elegantReveal 0.9s cubic-bezier(0.2, 0.9, 0.4, 1.1) 0.2s forwards;
    position: relative;
    letter-spacing: -0.03em;
  }

  .link::before {
    content: attr(data-text);
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, #ff3366 0%, #ff6b4a 100%);
    background-clip: text;
    -webkit-background-clip: text;
    color: transparent;
    filter: blur(12px);
    opacity: 0.4;
    z-index: -1;
    transition: opacity 0.3s;
    pointer-events: none;
  }

  .link:hover {
    transform: scale(1.02) translateY(-2px);
    text-shadow: 0 0 32px rgba(255, 51, 102, 0.6);
  }

  .glow-line {
    width: 60px;
    height: 2px;
    background: linear-gradient(90deg, transparent, #ff3366, #ff6b4a, transparent);
    margin: 1.5rem auto 0;
    border-radius: 2px;
    opacity: 0;
    animation: fadeWidth 0.8s ease 0.5s forwards;
  }

  .protection-message {
    margin-top: 2.5rem;
    opacity: 0;
    animation: fadeUp 0.7s ease 0.8s forwards;
  }

  .shield-text {
    font-family: 'JetBrains Mono', monospace;
    font-size: clamp(0.85rem, 4vw, 1.1rem);
    color: rgba(255, 255, 255, 0.7);
    letter-spacing: 0.5px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    flex-wrap: wrap;
  }

  .highlight {
    background: linear-gradient(135deg, #ff3366, #ff6b4a);
    background-clip: text;
    -webkit-background-clip: text;
    color: transparent;
    font-weight: 600;
  }

  .sub-message {
    margin-top: 1rem;
    font-size: 0.7rem;
    color: rgba(255, 255, 255, 0.3);
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  @keyframes elegantReveal {
    0% { opacity: 0; transform: translateY(20px) scale(0.98); }
    100% { opacity: 1; transform: translateY(0) scale(1); }
  }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: translateY(0); }
  }

  @keyframes fadeWidth {
    from { opacity: 0; width: 0; }
    to { opacity: 1; width: 60px; }
  }

  .particle {
    position: fixed;
    background: rgba(255, 51, 102, 0.2);
    border-radius: 50%;
    pointer-events: none;
    z-index: 0;
    filter: blur(40px);
  }

  .cursor-glow {
    position: fixed;
    width: 180px;
    height: 180px;
    background: radial-gradient(circle, rgba(255,51,102,0.12) 0%, rgba(255,51,102,0) 70%);
    border-radius: 50%;
    pointer-events: none;
    transform: translate(-50%, -50%);
    z-index: 1;
    opacity: 0;
  }
</style>
</head>
<body>

<div class="container">
  <a href="http://raw.monload.ru" class="link" data-text="raw.monload.ru">raw.monload.ru</a>
  <div class="glow-line"></div>
  
  <div class="protection-message">
    <div class="shield-text">
      <span>🔒</span>
      <span>This lua script is protected by the</span>
      <span class="highlight">raw.monload.ru</span>
      <span>website</span>
    </div>
    <div class="sub-message">
    </div>
  </div>
</div>

<div class="particle" style="width: 250px; height: 250px; bottom: -80px; left: -80px;"></div>
<div class="particle" style="width: 200px; height: 200px; top: -50px; right: -50px; background: rgba(255,107,74,0.12);"></div>
<div class="particle" style="width: 150px; height: 150px; bottom: 20%; right: 15%; background: rgba(255,51,102,0.08);"></div>

<script>
  if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    const glow = document.createElement('div');
    glow.className = 'cursor-glow';
    document.body.appendChild(glow);
    
    let mouseX = 0, mouseY = 0;
    let glowX = 0, glowY = 0;
    
    document.addEventListener('mousemove', (e) => {
      mouseX = e.clientX;
      mouseY = e.clientY;
      glow.style.opacity = '0.6';
    });
    
    function animateGlow() {
      glowX += (mouseX - glowX) * 0.1;
      glowY += (mouseY - glowY) * 0.1;
      glow.style.transform = `translate(${glowX}px, ${glowY}px)`;
      requestAnimationFrame(animateGlow);
    }
    
    animateGlow();
    
    document.addEventListener('mouseleave', () => {
      glow.style.opacity = '0';
    });
  }
</script>
</body>
</html>