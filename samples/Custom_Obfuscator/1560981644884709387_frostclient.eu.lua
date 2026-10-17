<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Frost | Minecraft Client</title>
<link rel="icon" type="image/x-icon" href="favicon.ico">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="Frost">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="theme-color" content="#000000">
<meta name="keywords" content="FrostClient, Frost, Frost Client, Minecraft Client"> 
<meta name="desciption" content="FrostClient | Minecraft PvP Client">
<link rel="stylesheet" href="theme.css">
<link rel="stylesheet" href="index.css">
</head>
<body>

<div id="gateScreen">
  <div class="gate-spinner"></div>
  <div class="gate-pending-text">Verifying you're not a robot...</div>
  <div class="gate-banned-content">
    <div class="gate-banned-title">You Have Been Banned</div>
    <p class="gate-banned-desc">Your access to Frost has been revoked. If you believe this is a mistake, contact us on Discord.</p>
    <div class="gate-banned-reason" id="gateBannedReason">Violation of TOS</div>
    <div class="gate-banned-id" id="gateBannedId"></div>
  </div>
</div>

<div class="topo-bg">
  <svg viewBox="0 0 1400 900" preserveAspectRatio="xMidYMid slice" xmlns="http://www.w3.org/2000/svg">
    <defs><style>.tline{fill:none;stroke:#4fc8f8;stroke-width:1.2;}</style></defs>
    <path class="tline" d="M-100,200 C100,180 250,240 400,200 S650,140 800,200 S1050,280 1200,220 S1400,160 1500,200"/>
    <path class="tline" d="M-100,270 C80,250 200,310 380,270 S600,190 760,265 S1000,340 1180,285 S1380,225 1500,265"/>
    <path class="tline" d="M-100,340 C60,320 180,380 360,340 S580,255 740,330 S980,400 1160,345 S1360,290 1500,335"/>
    <path class="tline" d="M-100,420 C40,400 160,460 340,420 S560,330 720,410 S960,470 1140,415 S1340,365 1500,415"/>
    <path class="tline" d="M-100,500 C20,480 140,540 320,500 S540,405 700,490 S940,545 1120,490 S1320,440 1500,490"/>
    <path class="tline" d="M-100,580 C0,558 120,618 300,580 S520,480 680,565 S920,625 1100,570 S1300,518 1500,568"/>
    <path class="tline" d="M-100,660 C-20,640 100,700 280,660 S500,560 660,645 S900,705 1080,650 S1280,598 1500,648"/>
    <path class="tline" d="M-100,740 C-40,720 80,780 260,740 S480,640 640,725 S880,785 1060,730 S1260,678 1500,728"/>
    <path class="tline" d="M200,100 C300,80 380,150 450,100 S600,40 700,110 S820,180 940,120 S1100,60 1200,100"/>
    <path class="tline" d="M150,160 C260,140 340,210 420,160 S570,95 670,165 S800,235 920,175 S1060,115 1160,160"/>
    <path class="tline" d="M250,820 C350,800 430,870 500,820 S650,755 750,825 S870,895 990,835 S1150,775 1250,820"/>
  </svg>
</div>
<canvas id="particles"></canvas>
<div id="cursor-glow"></div>
<div class="promo-toast" id="promoToast">
  <button class="promo-toast-close" id="promoToastClose" aria-label="Close">×</button>
  <div class="promo-toast-body">
    <div class="promo-toast-text"><strong>We're hiring:</strong> the FrostClient team has open positions — come help us build the new era!</div>
    <a href="team" class="promo-toast-cta">Join the Team →</a>
  </div>
</div>
<div class="poll-toast" id="pollToast">
  <button type="button" class="poll-toast-close" id="pollToastClose" aria-label="Close">×</button>
  <div class="poll-toast-body">
    <div class="poll-toast-text"><strong>Got 10 seconds?</strong> Answer one quick question.</div>
    <button type="button" class="poll-toast-cta" id="pollToastCta">Vote Now →</button>
  </div>
</div>
<nav>
<div class="nav-inner">
  <a class="nav-logo" href="#top"><img src="favicon.ico" alt="" class="nav-logo-icon"/><span>FROST</span></a>
  <ul class="nav-links">
    <li><a href="#features">Features</a></li>
    <li><a href="#mods">Mods</a></li>
    <li><a href="#performance">Performance</a></li>
    <li><a href="https://store.frostclient.eu" class="nav-link-store" data-spy="capes">Store</a></li>
    <li><a href="#reviews">Reviews</a></li>
    <li><a href="#download">Download</a></li>
    <li><a href="https://frostclient.eu/faq">FAQ</a></li>
    <li><a href="https://frostclient.eu/partner" class="nav-link-partner">Creators</a></li>
  </ul>
  <div class="nav-actions">
    <a href="https://store.frostclient.eu/lite" class="nav-cta nav-cta--lite js-lite-access-link">LITE</a>
    <button type="button" id="navDownloadBtn" class="nav-cta js-download-trigger">Download</button>
    <button type="button" class="nav-signin-btn js-site-auth-btn"><img src="icons/discord.webp" alt=""/><span class="js-site-auth-text">Sign in</span></button>
  </div>
</div>
<button class="nav-hamburger" id="navHamburger" type="button" aria-label="Menu" aria-expanded="false">
  <span></span><span></span><span></span>
</button>
<a class="nav-logo-mobile" href="#top">
  <img src="favicon.ico" alt="" class="nav-logo-icon"/><span>Frost</span>
</a>
<div id="scroll-progress">
    <div id="scroll-bar"></div>
</div>
</nav>
<div class="nav-mobile-menu" id="navMobileMenu">
  <a href="#features">Features</a>
  <a href="#mods">Mods</a>
  <a href="#performance">Performance</a>
  <a href="https://store.frostclient.eu" class="nav-link-store">Store</a>
  <a href="#reviews">Reviews</a>
  <a href="#download">Download</a>
  <a href="https://frostclient.eu/faq">FAQ</a>
  <a href="https://frostclient.eu/partner" class="nav-link-partner">Creators</a>
  <a href="https://store.frostclient.eu/lite" class="js-lite-access-link">LITE</a>
  <button type="button" class="js-download-trigger">Download</button>
  <button type="button" class="js-site-auth-btn">Sign in</button>
</div>
<div>
<section class="hero" id="top">
  <div class="hero-glow"></div>
  <div class="hero-badge">
    <span class="dot-wrap">
      <span class="dot"></span>
      <div class="online-tooltip">
        <div class="online-tooltip-row"><span>All-time peak</span><strong id="heroPeakOnline">—</strong></div>
        <div class="online-tooltip-row"><span>Avg. online (24h)</span><strong id="heroAvgOnline">—</strong></div>
      </div>
    </span>
    Online: <span id="heroOnlineCount">—</span>
  </div>
  <h1>
    <span class="frost-word">FROST</span>
    <span class="sub-word">Minecraft Client</span>
  </h1>
  <p class="hero-desc">
    A modern Minecraft Client built around speed, customization, and simplicity.
  </p>
  <div class="hero-actions">
    <button type="button" id="heroDownloadBtn" class="btn-primary js-download-trigger">
      <svg class="dl-os-icon active" data-os="win" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M0 3.449L9.75 2.1v9.451H0m10.949-9.602L24 0v11.4H10.949M0 12.6h9.75v9.451L0 20.699M10.949 12.6H24V24l-12.9-1.801" fill="currentColor"/></svg>
      <svg class="dl-os-icon" data-os="mac" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701" fill="currentColor"/></svg>
      <svg class="dl-os-icon" data-os="linux" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12.504 0c-.155 0-.315.008-.48.021-4.226.333-3.105 4.807-3.17 6.298-.076 1.092-.3 1.953-1.05 3.02-.885 1.051-2.127 2.75-2.716 4.521-.278.832-.41 1.684-.287 2.489a.424.424 0 00-.11.135c-.26.268-.45.6-.663.839-.199.199-.485.267-.797.4-.313.136-.658.269-.864.68-.09.189-.136.394-.132.602 0 .199.027.4.055.536.058.399.116.728.04.97-.249.68-.28 1.145-.106 1.484.174.334.535.47.94.601.81.2 1.91.135 2.774.6.926.466 1.866.67 2.616.47.526-.116.97-.464 1.208-.946.587-.003 1.23-.269 2.26-.334.699-.058 1.574.267 2.577.2.025.134.063.198.114.333l.003.003c.391.778 1.113 1.132 1.884 1.071.771-.06 1.592-.536 2.257-1.306.631-.765 1.683-1.084 2.378-1.503.348-.199.629-.469.649-.853.023-.4-.2-.811-.714-1.376v-.097l-.003-.003c-.17-.2-.25-.535-.338-.926-.085-.401-.182-.786-.492-1.046h-.003c-.059-.054-.123-.067-.188-.135a.357.357 0 00-.19-.064c.431-1.278.264-2.55-.173-3.694-.533-1.41-1.465-2.638-2.175-3.483-.796-1.005-1.576-1.957-1.56-3.368.026-2.152.236-6.133-3.544-6.139zm.529 3.405h.013c.213 0 .396.062.584.198.19.135.33.332.438.533.105.259.158.459.166.724 0-.02.006-.04.006-.06v.105a.086.086 0 01-.004-.021l-.004-.024a1.807 1.807 0 01-.15.706.953.953 0 01-.213.335.71.71 0 00-.088-.042c-.104-.045-.198-.064-.284-.133a1.312 1.312 0 00-.22-.066c.05-.06.146-.133.183-.198.053-.128.082-.264.088-.402v-.02a1.21 1.21 0 00-.061-.4c-.045-.134-.101-.2-.183-.333-.084-.066-.167-.132-.267-.132h-.016c-.093 0-.176.03-.262.132a.8.8 0 00-.205.334 1.18 1.18 0 00-.09.4v.019c.002.089.008.179.02.267-.193-.067-.438-.135-.607-.202a1.635 1.635 0 01-.018-.2v-.02a1.772 1.772 0 01.15-.768c.082-.22.232-.406.43-.533a.985.985 0 01.594-.2zm-2.962.059h.036c.142 0 .27.048.399.135.146.129.264.288.344.465.09.199.14.4.153.667v.004c.007.134.006.2-.002.266v.08c-.03.007-.056.018-.083.024-.152.055-.274.135-.393.2.012-.09.013-.18.003-.267v-.015c-.012-.133-.04-.2-.082-.333a.613.613 0 00-.166-.267.248.248 0 00-.183-.064h-.021c-.071.006-.13.04-.186.132a.552.552 0 00-.12.27.944.944 0 00-.023.33v.015c.012.135.037.2.08.334.046.134.098.2.166.268.01.009.02.018.034.024-.07.057-.117.07-.176.136a.304.304 0 01-.131.068 2.62 2.62 0 01-.275-.402 1.772 1.772 0 01-.155-.667 1.759 1.759 0 01.08-.668 1.43 1.43 0 01.283-.535c.128-.133.26-.2.418-.2zm1.37 1.706c.332 0 .733.065 1.216.399.293.2.523.269 1.052.468h.003c.255.136.405.266.478.399v-.131a.571.571 0 01.016.47c-.123.31-.516.643-1.063.842v.002c-.268.135-.501.333-.775.465-.276.135-.588.292-1.012.267a1.139 1.139 0 01-.448-.067 3.566 3.566 0 01-.322-.198c-.195-.135-.363-.332-.612-.465v-.005h-.005c-.4-.246-.616-.512-.686-.71-.07-.268-.005-.47.193-.6.224-.135.38-.271.483-.336.104-.074.143-.102.176-.131h.002v-.003c.169-.202.436-.47.839-.601.139-.036.294-.065.466-.065zm2.8 2.142c.358 1.417 1.196 3.475 1.735 4.473.286.534.855 1.659 1.102 3.024.156-.005.33.018.513.064.646-1.671-.546-3.467-1.089-3.966-.22-.2-.232-.335-.123-.335.59.534 1.365 1.572 1.646 2.757.13.535.16 1.104.021 1.67.067.028.135.06.205.067 1.032.534 1.413.938 1.23 1.537v-.043c-.06-.003-.12 0-.18 0h-.016c.151-.467-.182-.825-1.065-1.224-.915-.4-1.646-.336-1.77.465-.008.043-.013.066-.018.135-.068.023-.139.053-.209.064-.43.268-.662.669-.793 1.187-.13.533-.17 1.156-.205 1.869v.003c-.02.334-.17.838-.319 1.35-1.5 1.072-3.58 1.538-5.348.334a2.645 2.645 0 00-.402-.533 1.45 1.45 0 00-.275-.333c.182 0 .338-.03.465-.067a.615.615 0 00.314-.334c.108-.267 0-.697-.345-1.163-.345-.467-.931-.995-1.788-1.521-.63-.4-.986-.87-1.15-1.396-.165-.534-.143-1.085-.015-1.645.245-1.07.873-2.11 1.274-2.763.107-.065.037.135-.408.974-.396.751-1.14 2.497-.122 3.854a8.123 8.123 0 01.647-2.876c.564-1.278 1.743-3.504 1.836-5.268.048.036.217.135.289.202.218.133.38.333.59.465.21.201.477.335.876.335.039.003.075.006.11.006.412 0 .73-.134.997-.268.29-.134.52-.334.74-.4h.005c.467-.135.835-.402 1.044-.7zm2.185 8.958c.037.6.343 1.245.882 1.377.588.134 1.434-.333 1.791-.765l.211-.01c.315-.007.577.01.847.268l.003.003c.208.199.305.53.391.876.085.4.154.78.409 1.066.486.527.645.906.636 1.14l.003-.007v.018l-.003-.012c-.015.262-.185.396-.498.595-.63.401-1.746.712-2.457 1.57-.618.737-1.37 1.14-2.036 1.191-.664.053-1.237-.2-1.574-.898l-.005-.003c-.21-.4-.12-1.025.056-1.69.176-.668.428-1.344.463-1.897.037-.714.076-1.335.195-1.814.12-.465.308-.797.641-.984l.045-.022zm-10.814.049h.01c.053 0 .105.005.157.014.376.055.706.333 1.023.752l.91 1.664.003.003c.243.533.754 1.064 1.189 1.637.434.598.77 1.131.729 1.57v.006c-.057.744-.48 1.148-1.125 1.294-.645.135-1.52.002-2.395-.464-.968-.536-2.118-.469-2.857-.602-.369-.066-.61-.2-.723-.4-.11-.2-.113-.602.123-1.23v-.004l.002-.003c.117-.334.03-.752-.027-1.118-.055-.401-.083-.71.043-.94.16-.334.396-.4.69-.533.294-.135.64-.202.915-.47h.002v-.002c.256-.268.445-.601.668-.838.19-.201.38-.336.663-.336zm7.159-9.074c-.435.201-.945.535-1.488.535-.542 0-.97-.267-1.28-.466-.154-.134-.28-.268-.373-.335-.164-.134-.144-.333-.074-.333.109.016.129.134.199.2.096.066.215.2.36.333.292.2.68.467 1.167.467.485 0 1.053-.267 1.398-.466.195-.135.445-.334.648-.467.156-.136.149-.267.279-.267.128.016.034.134-.147.332a8.097 8.097 0 01-.69.468zm-1.082-1.583V5.64c-.006-.02.013-.042.029-.05.074-.043.18-.027.26.004.063 0 .16.067.15.135-.006.049-.085.066-.135.066-.055 0-.092-.043-.141-.068-.052-.018-.146-.008-.163-.065zm-.551 0c-.02.058-.113.049-.166.066-.047.025-.086.068-.14.068-.05 0-.13-.02-.136-.068-.01-.066.088-.133.15-.133.08-.031.184-.047.259-.005.019.009.036.03.03.05v.02h.003z" fill="currentColor"/></svg>
      <span id="heroDownloadLabel">Download for Windows</span>
    </button>
    <a href="#features" class="btn-secondary">Explore Features</a>
  </div>
  <p class="hero-version">Supports Minecraft 1.21+ · Free forever</p>
</section>
</div>
<div class="preview-screen">
<div class="preview-section">
  <div class="preview-frame reveal">
    <div class="preview-media" id="previewMedia">
      <div class="preview-slide preview-slide-image is-active" id="previewSlideFeatures1">
        <img src="ingame_features1.png" alt="Frost Client in-game features"/>
      </div>
      <div class="preview-slide preview-slide-image" id="previewSlideFeatures2">
        <img src="ingame_features2.png" alt="Frost Client in-game features"/>
      </div>
      <div class="preview-slide preview-slide-image" id="previewSlideImage">
        <img src="screenshot.png" alt="Frost Client Screenshot" id="heroImg"/>
      </div>
    </div>
    <button type="button" class="preview-nav preview-nav-next" id="previewNextBtn" aria-label="Next image">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
    </button>
    <button type="button" class="preview-nav preview-nav-prev" id="previewPrevBtn" aria-label="Previous image" hidden>
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
    </button>
    <div class="preview-glow"></div>
  </div>
</div>
<div class="stats-bar reveal-scale">
  <div class="stat-item">
    <div class="stat-num">50+</div>
    <div class="stat-label">Built-in Mods</div>
  </div>
  <div class="stat-item">
    <div class="stat-num">8×</div>
    <div class="stat-label">FPS Boost</div>
  </div>
  <div class="stat-item">
    <div class="stat-num">26.2</div>
    <div class="stat-label">Latest Version</div>
  </div>
  <div class="stat-item">
    <div class="stat-num">Free</div>
    <div class="stat-label">Always</div>
  </div>
</div>
</div>
<div>
<section class="features-section" id="features">
  <div class="features-header reveal">
    <div class="section-eyebrow">What's inside</div>
    <h2>Everything you use.<br/><span class="accent">Nothing you lose.</span></h2>
    <p class="section-desc">Frost ships with everything built in. No manual file installs, no mod manager chaos.</p>
  </div>
  <div class="features-grid">
    <div class="feature-card reveal reveal-delay-1">
      <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2 3 14h9l-1 8 10-12h-9l1-8Z"/></svg></div>
      <h3>FPS Boost</h3>
      <p>Sodium and VulkanMod baked in. Launch and play fast — no setup required.</p>
    </div>
    <div class="feature-card reveal reveal-delay-2">
      <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
      <h3>Frost Badges</h3>
      <p>See a live badge above every other Frost Client player nearby, plus their cloak, synced in real time.</p>
    </div>
    <div class="feature-card reveal reveal-delay-3">
      <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 3 1.9 4.5L18 9l-4.1 1.5L12 15l-1.9-4.5L6 9l4.1-1.5Z"/><path d="m19 15 .9 2.1L22 18l-2.1.9L19 21l-.9-2.1L16 18l2.1-.9Z"/></svg></div>
      <h3>Cosmetics</h3>
      <p>Free and unlockable cloaks built right in. Stand out without paying for a third-party service.</p>
    </div>
    <div class="feature-card reveal reveal-delay-1">
      <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a4 4 0 0 0-5.4 5.4L2 19v3h3l7.3-7.3a4 4 0 0 0 5.4-5.4l-2.8 2.8-2-2Z"/></svg></div>
      <h3>Mod Browser</h3>
      <p>Browse Modrinth mods and install extras in one click, right from Frost.</p>
    </div>
    <div class="feature-card reveal reveal-delay-2">
      <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h6v6"/><path d="M9 21H3v-6"/><path d="M21 3l-7 7"/><path d="M3 21l7-7"/></svg></div>
      <h3>Aspect Ratio</h3>
      <p>Change your aspect ratio in-game. No extra software required.</p>
    </div>
    <div class="feature-card reveal reveal-delay-3">
      <div class="feature-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg></div>
      <h3>50+ Built-in Mods</h3>
      <p>PvP tweaks, HUD customization, and more — all built in, all toggleable from one in-game menu.</p>
    </div>
  </div>
</section>
</div>
<div class="section-gap"></div>
<div>
<section id="mods">
<div class="split-section">
  <div class="split-text reveal-left">
    <div class="section-eyebrow">Mod Browser</div>
    <h2>Install mods<br/><span class="accent">in seconds.</span></h2>
    <p class="section-desc">Browse, enable, and configure mods directly inside Frost.</p>
  </div>
  <div class="split-visual reveal-right">
    <div class="visual-box">
      <div class="mock-row">
        <div class="mock-dot green"></div>
        <div class="mock-label">Vulkan</div>
        <div class="mock-badge green">Installed</div>
      </div>
      <div class="mock-row">
        <div class="mock-dot green"></div>
        <div class="mock-label">Beryl</div>
        <div class="mock-badge green">Installed</div>
      </div>
      <div class="mock-row">
        <div class="mock-dot blue"></div>
        <div class="mock-label">Fabric API</div>
        <div class="mock-badge">Required</div>
      </div>
      <div class="mock-row">
        <div class="mock-dot muted"></div>
        <div class="mock-label">ReScale (4:3)</div>
        <div class="mock-badge">+ Add</div>
      </div>
      <div class="mock-row">
        <div class="mock-dot muted"></div>
        <div class="mock-label">Xaero's Minimap</div>
        <div class="mock-badge">+ Add</div>
      </div>
    </div>
  </div>
</div>
</section>
</div>
<div class="section-gap"></div>
<div>
<section id="performance">
<div class="split-section reverse">
  <div class="split-text reveal-right">
    <div class="section-eyebrow">Performance</div>
    <h2>Faster than<br/><span class="accent">competition.</span></h2>
    <p class="section-desc">Frost ships with Vulkan by default. You get a performance boost the moment you press play — even on older hardware.</p>
  </div>
  <div class="split-visual reveal-left">
    <div class="visual-box">
      <div class="fps-entry">
        <div class="fps-row">
          <span class="fps-label">Vanilla Minecraft</span>
          <span class="fps-value">85 FPS</span>
        </div>
        <div class="fps-track">
          <div class="fps-fill fps-fill--muted" style="--w:8%; transition-delay:0.05s;"></div>
        </div>
      </div>
      <div class="fps-entry">
        <div class="fps-row">
          <span class="fps-label">Other PvP Clients</span>
          <span class="fps-value">250 FPS</span>
        </div>
        <div class="fps-track">
          <div class="fps-fill fps-fill--muted" style="--w:22%; transition-delay:0.2s;"></div>
        </div>
      </div>
      <div class="fps-entry">
        <div class="fps-row">
          <span class="fps-label is-frost">❄ Frost Client</span>
          <span class="fps-value is-frost">810 FPS</span>
        </div>
        <div class="fps-track">
          <div class="fps-fill fps-fill--frost" style="--w:72%; transition-delay:0.5s;"></div>
        </div>
      </div>
      <div class="fps-entry">
        <div class="fps-row">
          <span class="fps-label is-lite">✦ FrostClient Lite</span>
          <span class="fps-value is-lite">1130 FPS</span>
        </div>
        <div class="fps-track">
          <div class="fps-fill fps-fill--lite" style="--w:100%; transition-delay:0.65s;"></div>
        </div>
      </div>
      <p style="font-size:12px;color:var(--muted);margin-top:20px;">Tested on RTX 3060ti · 2160p · Render distance 20 chunks</p>
    </div>
  </div>
</div>
</section>
</div>
<div class="section-gap"></div>
<div>
<section class="lite-promo" id="lite">
  <div class="section-eyebrow reveal">Exclusive</div>
  <h2 class="reveal">Want even <span class="lite-accent">more?</span></h2>
  <p class="lite-promo-desc reveal">FrostClient <strong style="color:#ff73fa;">Lite</strong> is a special build built for our biggest supporters — up to <strong>+700 FPS</strong> over vanilla, exclusive cloaks, and priority support.</p>
  <div class="reveal">
    <a class="btn-lite-promo js-lite-access-link" href="https://store.frostclient.eu/lite">Get FrostClient Lite</a>
  </div>
</section>
</div>
<div class="section-gap"></div>
<div>
<section class="capes-showcase" id="capes">
  <div class="capes-showcase-header">
    <div class="section-eyebrow reveal">Cosmetics</div>
    <h2 class="reveal">Stand out with<br/><span class="accent">Frost cloaks.</span></h2>
    <p class="section-desc reveal">Every Frost Client player can see your cloak. Pick one in the store and equip it from the launcher.</p>
  </div>
  <div class="capes-showcase-grid reveal" id="capesShowcaseGrid"></div>
  <div class="capes-showcase-cta reveal">
    <a href="https://store.frostclient.eu" class="reviews-view-more">Browse all cloaks →</a>
  </div>
</section>
</div>
<div class="section-gap"></div>
<div>
<section class="partners-showcase" id="partners" hidden>
  <div class="partners-showcase-header">
    <div class="section-eyebrow reveal">Partners</div>
    <h2 class="reveal">Played by creators<br/><span class="accent">and servers we love.</span></h2>
  </div>
  <div class="partners-showcase-row reveal" id="partnersShowcaseRow"></div>
  <div class="capes-showcase-cta reveal">
    <a href="https://frostclient.eu/partners" class="reviews-view-more">See all partners →</a>
  </div>
</section>
</div>
<div class="section-gap"></div>
<div>
<section id="reviews">
<div class="reviews-teaser">
  <div class="reviews-teaser-header">
    <div class="section-eyebrow reveal" style="text-align:center;">Community</div>
    <h2 class="reveal" style="text-align:center;">What players<br/><span class="accent">are saying.</span></h2>
    <p class="section-desc reveal">Real reviews from FrostClient players on Discord.</p>
  </div>
  <div class="reviews-grid-teaser reveal" id="reviewsGridTeaser"></div>
  <div class="reviews-teaser-cta reveal">
    <a href="https://frostclient.eu/reviews" class="reviews-view-more">View More →</a>
  </div>
</div>
</section>
</div>
<div class="section-gap-small"></div>
<div>
<section class="cta-section" id="download">
  <div class="section-eyebrow reveal" style="text-align:center;">Free download</div>
  <h2 class="reveal">Ready to play<br/><span class="accent">differently?</span></h2>
  <p class="reveal">Download Frost for free and experience Minecraft the way it was meant to feel — fast, personal, and yours.</p>
<div class="hero-actions reveal reveal-delay-1">
  <button type="button" id="downloadBtn" class="btn-primary js-download-trigger" style="font-size:18px;padding:20px 56px;border-radius:20px;">
    <span class="btn-dl-icon">↓</span>
    <span>Download Frost</span>
  </button>
</div>
  <p class="hero-version reveal reveal-delay-2" style="margin-top:24px;">Windows · macOS · Linux</p>
</section>
</div>
<div>
<section class="partner-promo-section">
  <div class="partner-promo-card reveal-scale">
    <div class="section-eyebrow">Creators</div>
    <h2>Play. Post. <span class="partner-promo-accent">Get paid.</span></h2>
    <p class="partner-promo-desc">We're looking for TikTok and YouTube creators to team up with Frost — real payouts, not just a shoutout.</p>
    <a href="https://frostclient.eu/partner" class="btn-partner-promo">Read More →</a>
  </div>
</section>
</div>
<div class="modal-overlay" id="downloadChoiceModal">
  <div class="modal-box modal-box--download">
    <button type="button" class="modal-close" id="downloadChoiceCloseBtn" aria-label="Close">✕</button>
    <div class="modal-title" style="text-align:center;">Choose how you want to play</div>
    <div class="dl-choice-grid">
      <a href="https://bot.frostclient.eu/public_dl/Frost-Launcher-win.exe" id="dlLauncherTile" class="dl-choice-tile" rel="noopener">
        <svg class="dl-os-icon" data-os="win" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M0 3.449L9.75 2.1v9.451H0m10.949-9.602L24 0v11.4H10.949M0 12.6h9.75v9.451L0 20.699M10.949 12.6H24V24l-12.9-1.801" fill="currentColor"/></svg>
        <svg class="dl-os-icon" data-os="mac" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701" fill="currentColor"/></svg>
        <svg class="dl-os-icon" data-os="linux" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12.504 0c-.155 0-.315.008-.48.021-4.226.333-3.105 4.807-3.17 6.298-.076 1.092-.3 1.953-1.05 3.02-.885 1.051-2.127 2.75-2.716 4.521-.278.832-.41 1.684-.287 2.489a.424.424 0 00-.11.135c-.26.268-.45.6-.663.839-.199.199-.485.267-.797.4-.313.136-.658.269-.864.68-.09.189-.136.394-.132.602 0 .199.027.4.055.536.058.399.116.728.04.97-.249.68-.28 1.145-.106 1.484.174.334.535.47.94.601.81.2 1.91.135 2.774.6.926.466 1.866.67 2.616.47.526-.116.97-.464 1.208-.946.587-.003 1.23-.269 2.26-.334.699-.058 1.574.267 2.577.2.025.134.063.198.114.333l.003.003c.391.778 1.113 1.132 1.884 1.071.771-.06 1.592-.536 2.257-1.306.631-.765 1.683-1.084 2.378-1.503.348-.199.629-.469.649-.853.023-.4-.2-.811-.714-1.376v-.097l-.003-.003c-.17-.2-.25-.535-.338-.926-.085-.401-.182-.786-.492-1.046h-.003c-.059-.054-.123-.067-.188-.135a.357.357 0 00-.19-.064c.431-1.278.264-2.55-.173-3.694-.533-1.41-1.465-2.638-2.175-3.483-.796-1.005-1.576-1.957-1.56-3.368.026-2.152.236-6.133-3.544-6.139zm.529 3.405h.013c.213 0 .396.062.584.198.19.135.33.332.438.533.105.259.158.459.166.724 0-.02.006-.04.006-.06v.105a.086.086 0 01-.004-.021l-.004-.024a1.807 1.807 0 01-.15.706.953.953 0 01-.213.335.71.71 0 00-.088-.042c-.104-.045-.198-.064-.284-.133a1.312 1.312 0 00-.22-.066c.05-.06.146-.133.183-.198.053-.128.082-.264.088-.402v-.02a1.21 1.21 0 00-.061-.4c-.045-.134-.101-.2-.183-.333-.084-.066-.167-.132-.267-.132h-.016c-.093 0-.176.03-.262.132a.8.8 0 00-.205.334 1.18 1.18 0 00-.09.4v.019c.002.089.008.179.02.267-.193-.067-.438-.135-.607-.202a1.635 1.635 0 01-.018-.2v-.02a1.772 1.772 0 01.15-.768c.082-.22.232-.406.43-.533a.985.985 0 01.594-.2zm-2.962.059h.036c.142 0 .27.048.399.135.146.129.264.288.344.465.09.199.14.4.153.667v.004c.007.134.006.2-.002.266v.08c-.03.007-.056.018-.083.024-.152.055-.274.135-.393.2.012-.09.013-.18.003-.267v-.015c-.012-.133-.04-.2-.082-.333a.613.613 0 00-.166-.267.248.248 0 00-.183-.064h-.021c-.071.006-.13.04-.186.132a.552.552 0 00-.12.27.944.944 0 00-.023.33v.015c.012.135.037.2.08.334.046.134.098.2.166.268.01.009.02.018.034.024-.07.057-.117.07-.176.136a.304.304 0 01-.131.068 2.62 2.62 0 01-.275-.402 1.772 1.772 0 01-.155-.667 1.759 1.759 0 01.08-.668 1.43 1.43 0 01.283-.535c.128-.133.26-.2.418-.2zm1.37 1.706c.332 0 .733.065 1.216.399.293.2.523.269 1.052.468h.003c.255.136.405.266.478.399v-.131a.571.571 0 01.016.47c-.123.31-.516.643-1.063.842v.002c-.268.135-.501.333-.775.465-.276.135-.588.292-1.012.267a1.139 1.139 0 01-.448-.067 3.566 3.566 0 01-.322-.198c-.195-.135-.363-.332-.612-.465v-.005h-.005c-.4-.246-.616-.512-.686-.71-.07-.268-.005-.47.193-.6.224-.135.38-.271.483-.336.104-.074.143-.102.176-.131h.002v-.003c.169-.202.436-.47.839-.601.139-.036.294-.065.466-.065zm2.8 2.142c.358 1.417 1.196 3.475 1.735 4.473.286.534.855 1.659 1.102 3.024.156-.005.33.018.513.064.646-1.671-.546-3.467-1.089-3.966-.22-.2-.232-.335-.123-.335.59.534 1.365 1.572 1.646 2.757.13.535.16 1.104.021 1.67.067.028.135.06.205.067 1.032.534 1.413.938 1.23 1.537v-.043c-.06-.003-.12 0-.18 0h-.016c.151-.467-.182-.825-1.065-1.224-.915-.4-1.646-.336-1.77.465-.008.043-.013.066-.018.135-.068.023-.139.053-.209.064-.43.268-.662.669-.793 1.187-.13.533-.17 1.156-.205 1.869v.003c-.02.334-.17.838-.319 1.35-1.5 1.072-3.58 1.538-5.348.334a2.645 2.645 0 00-.402-.533 1.45 1.45 0 00-.275-.333c.182 0 .338-.03.465-.067a.615.615 0 00.314-.334c.108-.267 0-.697-.345-1.163-.345-.467-.931-.995-1.788-1.521-.63-.4-.986-.87-1.15-1.396-.165-.534-.143-1.085-.015-1.645.245-1.07.873-2.11 1.274-2.763.107-.065.037.135-.408.974-.396.751-1.14 2.497-.122 3.854a8.123 8.123 0 01.647-2.876c.564-1.278 1.743-3.504 1.836-5.268.048.036.217.135.289.202.218.133.38.333.59.465.21.201.477.335.876.335.039.003.075.006.11.006.412 0 .73-.134.997-.268.29-.134.52-.334.74-.4h.005c.467-.135.835-.402 1.044-.7zm2.185 8.958c.037.6.343 1.245.882 1.377.588.134 1.434-.333 1.791-.765l.211-.01c.315-.007.577.01.847.268l.003.003c.208.199.305.53.391.876.085.4.154.78.409 1.066.486.527.645.906.636 1.14l.003-.007v.018l-.003-.012c-.015.262-.185.396-.498.595-.63.401-1.746.712-2.457 1.57-.618.737-1.37 1.14-2.036 1.191-.664.053-1.237-.2-1.574-.898l-.005-.003c-.21-.4-.12-1.025.056-1.69.176-.668.428-1.344.463-1.897.037-.714.076-1.335.195-1.814.12-.465.308-.797.641-.984l.045-.022zm-10.814.049h.01c.053 0 .105.005.157.014.376.055.706.333 1.023.752l.91 1.664.003.003c.243.533.754 1.064 1.189 1.637.434.598.77 1.131.729 1.57v.006c-.057.744-.48 1.148-1.125 1.294-.645.135-1.52.002-2.395-.464-.968-.536-2.118-.469-2.857-.602-.369-.066-.61-.2-.723-.4-.11-.2-.113-.602.123-1.23v-.004l.002-.003c.117-.334.03-.752-.027-1.118-.055-.401-.083-.71.043-.94.16-.334.396-.4.69-.533.294-.135.64-.202.915-.47h.002v-.002c.256-.268.445-.601.668-.838.19-.201.38-.336.663-.336zm7.159-9.074c-.435.201-.945.535-1.488.535-.542 0-.97-.267-1.28-.466-.154-.134-.28-.268-.373-.335-.164-.134-.144-.333-.074-.333.109.016.129.134.199.2.096.066.215.2.36.333.292.2.68.467 1.167.467.485 0 1.053-.267 1.398-.466.195-.135.445-.334.648-.467.156-.136.149-.267.279-.267.128.016.034.134-.147.332a8.097 8.097 0 01-.69.468zm-1.082-1.583V5.64c-.006-.02.013-.042.029-.05.074-.043.18-.027.26.004.063 0 .16.067.15.135-.006.049-.085.066-.135.066-.055 0-.092-.043-.141-.068-.052-.018-.146-.008-.163-.065zm-.551 0c-.02.058-.113.049-.166.066-.047.025-.086.068-.14.068-.05 0-.13-.02-.136-.068-.01-.066.088-.133.15-.133.08-.031.184-.047.259-.005.019.009.036.03.03.05v.02h.003z" fill="currentColor"/></svg>
        <span>Launcher</span>
        <span class="dl-choice-tile-sub" id="dlLauncherTileSub">Windows</span>
        <span class="dl-choice-tile-alt" id="dlLauncherTileAlt"></span>
      </a>
      <button type="button" id="downloadModpackBtn" class="dl-choice-tile dl-choice-tile-outdated">
        <span class="dl-outdated-badge">Outdated</span>
        <svg viewBox="0 0 512 514" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M503.16 323.56C514.55 281.47 515.32 235.91 503.2 190.76C466.57 54.2299 326.04 -26.8001 189.33 9.77991C83.8101 38.0199 11.3899 128.07 0.689941 230.47H43.99C54.29 147.33 113.74 74.7298 199.75 51.7098C306.05 23.2598 415.13 80.6699 453.17 181.38L411.03 192.65C391.64 145.8 352.57 111.45 306.3 96.8198L298.56 140.66C335.09 154.13 364.72 184.5 375.56 224.91C391.36 283.8 361.94 344.14 308.56 369.17L320.09 412.16C390.25 383.21 432.4 310.3 422.43 235.14L464.41 223.91C468.91 252.62 467.35 281.16 460.55 308.07L503.16 323.56Z" fill="currentColor"/><path d="M321.99 504.22C185.27 540.8 44.7501 459.77 8.11011 323.24C3.84011 307.31 1.17 291.33 0 275.46H43.27C44.36 287.37 46.4699 299.35 49.6799 311.29C53.0399 323.8 57.45 335.75 62.79 347.07L101.38 323.92C98.1299 316.42 95.39 308.6 93.21 300.47C69.17 210.87 122.41 118.77 212.13 94.7601C229.13 90.2101 246.23 88.4401 262.93 89.1501L255.19 133C244.73 133.05 234.11 134.42 223.53 137.25C157.31 154.98 118.01 222.95 135.75 289.09C136.85 293.16 138.13 297.13 139.59 300.99L188.94 271.38L174.07 231.95L220.67 184.08L279.57 171.39L296.62 192.38L269.47 219.88L245.79 227.33L228.87 244.72L237.16 267.79C237.16 267.79 253.95 285.63 253.98 285.64L277.7 279.33L294.58 260.79L331.44 249.12L342.42 273.82L304.39 320.45L240.66 340.63L212.08 308.81L162.26 338.7C187.8 367.78 226.2 383.93 266.01 380.56L277.54 423.55C218.13 431.41 160.1 406.82 124.05 361.64L85.6399 384.68C136.25 451.17 223.84 484.11 309.61 461.16C371.35 444.64 419.4 402.56 445.42 349.38L488.06 364.88C457.17 431.16 398.22 483.82 321.99 504.22Z" fill="currentColor"/></svg>
        <span>Modpack</span>
        <span class="dl-choice-tile-sub">Windows, macOS, Linux</span>
      </button>
    </div>
    <a href="https://store.frostclient.eu/lite" class="dl-lite-row" id="dlLiteRow">
      <div class="dl-lite-main">
        <span class="dl-lite-name">FrostClient Lite <span class="dl-lite-badge">More FPS</span></span>
        <span class="dl-lite-desc"><strong>Maximum optimization</strong> &middot; <strong>~+700 FPS</strong> &middot; <strong>exclusive cloaks</strong> &middot; <strong>priority tickets</strong> &middot; 1&#8209;day free trial</span>
      </div>
      <span class="dl-lite-cta">See Lite &rarr;</span>
    </a>
    <div class="dl-alt-links" id="dlLauncherAltLinks"></div>
  </div>
</div>

<div class="modal-overlay" id="versionModal">
  <div class="modal-box" id="versionModalBox">
    <button type="button" class="modal-close" id="versionCloseBtn" aria-label="Close">✕</button>
    <div class="modal-title" style="text-align:center;">Choose Your Version</div>
    <p class="modal-desc" style="text-align:center;">Pick your renderer, then your Minecraft version.</p>

    <div class="version-choices">
      <button type="button" class="version-card version-card--vulkan" id="rendererVulkanBtn" data-renderer="vulkan">Vulkan</button>
      <button type="button" class="version-card version-card--opengl" id="rendererOpenglBtn" data-renderer="opengl">OpenGL</button>
    </div>
    <p class="version-perf-note" id="versionPerfNote">Vulkan offers the highest performance — if it crashes on startup, pick OpenGL instead.</p>

    <div class="version-select-wrap">
      <select class="version-select" id="versionSelect"></select>
    </div>

    <a href="#" target="_blank" id="finalDownloadBtn" class="btn-primary btn-version-download">
      <span class="btn-dl-icon">↓</span>
      <span id="finalDownloadLabel">Select a version</span>
    </a>
  </div>
</div>

<div class="modal-overlay" id="pollModal">
  <div class="modal-box modal-box--poll">
    <button type="button" class="modal-close" id="pollModalCloseBtn" aria-label="Close">✕</button>
    <div class="modal-title" style="text-align:center;">What's the best PvP right now?</div>
    <div class="poll-options" id="pollOptions">
      <button type="button" class="poll-option" data-answer="CRYSTAL">
        <img src="icons/crystal.png" alt="" class="poll-option-icon"/>
        <span class="poll-option-label">Crystal</span>
        <span class="poll-option-pct"></span>
        <div class="poll-option-bar">
            <div class="poll-option-bar-fill"></div>
        </div>
      </button>
      <button type="button" class="poll-option" data-answer="MACE">
        <img src="icons/mace.png" alt="" class="poll-option-icon"/>
        <span class="poll-option-label">Mace</span>
        <span class="poll-option-pct"></span>
        <div class="poll-option-bar">
            <div class="poll-option-bar-fill"></div>
        </div>
      </button>
      <button type="button" class="poll-option" data-answer="SMP">
        <img src="icons/smp.png" alt="" class="poll-option-icon"/>
        <span class="poll-option-label">SMP</span>
        <span class="poll-option-pct"></span>
        <div class="poll-option-bar">
            <div class="poll-option-bar-fill"></div>
        </div>
      </button>
      <button type="button" class="poll-option" data-answer="UHC">
        <img src="icons/uhc.png" alt="" class="poll-option-icon"/>
        <span class="poll-option-label">UHC</span>
        <span class="poll-option-pct"></span>
        <div class="poll-option-bar">
            <div class="poll-option-bar-fill"></div>
        </div>
      </button>
    </div>
    <div class="poll-note" id="pollNote">Your vote is final and can't be changed later — please answer honestly and think it over.</div>
    <button type="button" class="poll-submit-btn" id="pollSubmitBtn" disabled>Submit Vote</button>
    <div class="poll-thanks" id="pollThanks">Thank you for your answer.</div>
  </div>
</div>

<div class="section-gap"></div>
<footer>
  <div class="footer-inner">
    <div class="footer-brand">
      <div class="footer-logo">❄ FROST</div>
      <p class="footer-tagline">A fast, free Minecraft client<br/>built for players who care.</p>
    </div>
    <div class="footer-col">
      <h4>Product</h4>
      <a href="https://frostclient.eu/?openDownload">Download</a>
      <a href="https://frostclient.eu/reviews">Reviews</a>
      <a href="https://frostclient.eu/partner">Creator Program</a>
      <a href="https://store.frostclient.eu">Store</a>
    </div>
    <div class="footer-col">
      <h4>Account</h4>
      <button type="button" class="footer-link-btn js-site-auth-btn"><span class="js-site-auth-text">Sign in</span></button>
      <a href="https://store.frostclient.eu/lite">Frost Lite</a>
    </div>
    <div class="footer-col">
      <h4>Creator</h4>
      <a href="https://partner.frostclient.eu">Dashboard</a>
      <a href="https://partner.frostclient.eu/balance">Withdraw</a>
      <a href="https://partner.frostclient.eu/assets">Assets</a>
    </div>
    <div class="footer-col">
      <h4>Legal</h4>
      <a href="https://frostclient.eu/faq">FAQ</a>
      <a href="https://frostclient.eu/security">Security</a>
      <a href="https://frostclient.eu/privacy">Privacy Policy</a>
      <a href="https://frostclient.eu/terms">Terms of Service</a>
      <a href="https://frostclient.eu/imprint">Imprint</a>
    </div>
    <div class="footer-col">
      <h4>Community</h4>
      <a href="https://frostclient.eu/team">Join FrostClient</a>
      <a href="https://frostclient.eu/partners">Partners</a>
      <div class="footer-social-icons">
        <a href="https://discord.gg/Kn8ydsABU8" target="_blank" aria-label="Discord"><img src="icons/discord.webp" alt="Discord"/></a>
        <a href="https://www.youtube.com/@frost-client" target="_blank" aria-label="YouTube"><img src="icons/youtube.webp" alt="YouTube"/></a>
        <a href="https://www.tiktok.com/@frostclient.eu" target="_blank" aria-label="TikTok"><img src="icons/tiktok.webp" alt="TikTok"/></a>
      </div>
    </div>
  </div>
  <div class="footer-bottom">
    <span>© Frost 2026. All rights reserved.<br>
      Made by: Zipp
    </span>
    <span>Not affiliated with Minecraft or Mojang.</span>
  </div>
</footer>
<script src="index.js"></script>
<script src="capes-showcase.js"></script>
<script src="partners-showcase.js"></script>
<script src="site-auth.js"></script>
</body>
</html>
