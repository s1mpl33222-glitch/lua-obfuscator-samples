<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Verifying — Rendex</title>
<link rel="icon" href="https://raw.githubusercontent.com/ImNotWhyLclc/Main/main/Icons/RendexHalloween-nobg.png">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Sora:wght@400;500;600;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="/styles.css">

<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>

<!-- Load the theme immediately so it doesn't flash white -->
<script>
(function(){
  const theme=localStorage.getItem("rendex-theme")||"dark";
  if(theme==="dark")document.documentElement.removeAttribute("data-theme");
  else document.documentElement.setAttribute("data-theme",theme);
})();
</script>

<style>
  body {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    padding: 24px;
  }

  .verify-card {
    position: relative;
    width: 100%;
    max-width: 440px;
    padding: 40px 32px;
    text-align: center;
    border: 1px solid var(--border);
    border-radius: 22px;
    background: var(--surface);
    box-shadow: var(--shadow);
    overflow: hidden;
    animation: heroIn 0.6s cubic-bezier(0.2, 0.8, 0.2, 1);
  }

  /* Subtle gradient border */
  .verify-card::before {
    content: "";
    position: absolute;
    inset: 0;
    border-radius: 22px;
    padding: 1px;
    background: linear-gradient(160deg, rgba(255,122,24,.3), transparent 40%, transparent 60%, rgba(168,85,247,.2));
    -webkit-mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
    -webkit-mask-composite: xor;
    mask-composite: exclude;
    pointer-events: none;
  }

  .verify-logo {
    width: 56px;
    height: 56px;
    object-fit: contain;
    display: block;
    margin: 0 auto 16px;
    filter: drop-shadow(0 4px 14px rgba(255,120,0,.25));
  }

  .verify-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 11px;
    border-radius: 999px;
    background: rgba(255,126,0,.1);
    border: 1px solid rgba(255,126,0,.25);
    color: #ff9b3d;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: .1em;
    text-transform: uppercase;
    margin-bottom: 16px;
  }

  .verify-badge span {
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: currentColor;
    box-shadow: 0 0 8px currentColor;
    animation: joinPulse 1.4s ease-in-out infinite;
  }

  @keyframes joinPulse {
    0%,100% { opacity: 1; }
    50% { opacity: 0.35; }
  }

  h1 {
    font-family: Sora, sans-serif;
    font-size: 24px;
    font-weight: 600;
    letter-spacing: -0.04em;
    margin-bottom: 10px;
  }

  p {
    color: var(--text-soft);
    font-size: 13.5px;
    margin-bottom: 24px;
    line-height: 1.6;
  }

  #turnstile-container {
    display: flex;
    justify-content: center;
    margin-bottom: 24px;
  }

  #verify-btn {
    width: 100%;
    height: 46px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 12px;
    border: 1px solid rgba(255,122,24,.2);
    background: linear-gradient(135deg, #ff7417, #ff9c32);
    color: #fff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    opacity: 0.5;
    pointer-events: none;
    transition: 0.2s ease;
    box-shadow: 0 8px 25px rgba(255,100,0,.14);
  }

  #verify-btn.enabled {
    opacity: 1;
    pointer-events: auto;
  }

  #verify-btn.enabled:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 30px rgba(255,100,0,.2);
  }
</style>
</head>
<body>

<div class="verify-card">
  <img class="verify-logo" src="https://raw.githubusercontent.com/ImNotWhyLclc/Main/main/Icons/RendexHalloween-nobg.png" alt="Rendex">
  
  <div class="verify-badge"><span></span>Security Check</div>

  <h1>Verifying your browser</h1>
  <p>We need to check your connection's safety before continuing to Rendex. Please solve this challenge.</p>
  
  <div id="turnstile-container"></div>

  <button id="verify-btn">Continue</button>
</div>

<script>
  const SITE_KEY = "0x4AAAAAAFlyft-b89IdyqoT";

  async function onTurnstileSuccess(token) {
    const btn = document.getElementById('verify-btn');
    btn.innerText = "Verifying...";

    try {
      const response = await fetch("/api/verify", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ token: token })
      });

      const data = await response.json();

      if (data.success) {
        btn.innerText = "Verified! Redirecting...";
        btn.classList.add('enabled');
        setTimeout(() => {
          window.location.href = "/";
        }, 800);
      } else {
        btn.innerText = "Verification failed. Try again.";
        btn.classList.remove('enabled');
        turnstile.reset();
      }
    } catch (err) {
      btn.innerText = "Error. Please try again.";
      btn.classList.remove('enabled');
      turnstile.reset();
    }
  }

  window.onload = function() {
    turnstile.render('#turnstile-container', {
      sitekey: SITE_KEY,
      callback: onTurnstileSuccess,
    });
  };
</script>
</body>
</html>