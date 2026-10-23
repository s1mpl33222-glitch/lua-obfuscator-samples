--[[ Made by Math :)
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
 <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>Hawk HUB | Free Script HUB</title>
    <meta name="description" content="Hawk HUB is a free, keyless powerful Roblox script hub." />
    <meta name="keywords" content="Hawk HUB, Roblox script hub, free roblox scripts, auto farm, ESP, aimbot, Hawk Softworks, script executor" />
    <meta name="author" content="Hawk Softworks" />
    <meta name="robots" content="index, follow" />
    <link rel="canonical" href="https://hawkhub.lol/" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://hawkhub.lol/" />
    <meta property="og:title" content="Hawk HUB | Free Script Hub" />
    <meta property="og:description" content="A free, powerful and keyless script!!!" />
    <meta property="og:image" content="https://cdn.hawkhub.lol/Hawk_Logo.png" />
    <meta property="og:site_name" content="Hawk HUB" />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:url" content="https://hawkhub.lol/" />
    <meta name="twitter:title" content="Hawk HUB | Free Script Hub" />
    <meta name="twitter:description" content="A free, powerful and keyless script!!!" />
    <meta name="twitter:image" content="https://cdn.hawkhub.lol/Hawk_Logo.png" />
    <meta name="theme-color" content="#FFFFFF" />
    <link rel="icon" type="image/png" href="https://cdn.hawkhub.lol/Hawk_Logo.png" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  html {
    scroll-behavior: smooth;
    overflow-x: hidden;
  }

  :root {
    --bg: #000000;
    --nav: #1c1c1e;
    --text: #f5f5f7;
    --text2: #86868b;
    --accent: #ff6b4a;
    --accent-dark: #d95536;
    --toggle-bg: #3a3a3c;
    --toggle-knob: #ffffff;
  }
  [data-theme="light"] {
    --bg: #ffffff;
    --nav: #f5f5f7;
    --text: #1d1d1f;
    --text2: #6e6e73;
    --toggle-bg: #d1d1d6;
    --toggle-knob: #1d1d1f;
  }
  [data-theme="light"] .nav-logo-img {
    filter: invert(1);
  }

  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    background: var(--bg);
    color: var(--text);
    font-family: 'DM Sans', -apple-system, sans-serif;
    min-height: 100vh;
    transition: background 0.3s, color 0.3s;
    overflow-x: hidden;
    max-width: 100%;
  }

  nav {
    position: fixed; top: 0; left: 0; right: 0; z-index: 100;
    height: 52px;
    background: var(--nav);
    display: flex; align-items: center; justify-content: space-between;
    padding: 0 28px;
    transition: background 0.3s;
  }

  .nav-logo {
    display: flex; align-items: center; gap: 9px;
    font-size: 15px;
    font-weight: 600;
    color: var(--text);
    letter-spacing: 0.2px;
    transition: color 0.3s;
  }

  .nav-logo-img {
    width: 26px;
    height: 26px;
    border-radius: 6px;
    object-fit: cover;
    flex-shrink: 0;
  }

  .nav-right {
    display: flex; align-items: center; gap: 10px;
  }

  .nav-links {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .nav-link {
    color: var(--text2);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    padding: 8px 12px;
    border-radius: 8px;
    transition: color 0.2s, background 0.2s;
  }

  .nav-link:hover {
    color: var(--text);
    background: #2c2c2e;
  }

  [data-theme="light"] .nav-link:hover {
    background: #e0e0e5;
  }

  .toggle-label {
    font-size: 13px;
    font-weight: 400;
    color: var(--text2);
    letter-spacing: 0.1px;
    transition: color 0.3s;
    user-select: none;
  }

  .toggle {
    width: 44px; height: 26px;
    background: var(--toggle-bg);
    border-radius: 100px;
    position: relative;
    cursor: pointer;
    transition: background 0.3s;
  }
  .toggle::after {
    content: '';
    position: absolute;
    top: 3px; left: 3px;
    width: 20px; height: 20px;
    border-radius: 50%;
    background: var(--toggle-knob);
    transform: translateX(0);
    transition: transform 0.3s, background 0.3s;
  }
  .toggle.active::after {
    transform: translateX(18px);
  }

  
  .mobile-menu-btn {
    display: none;
    background: transparent;
    border: none;
    color: var(--text);
    cursor: pointer;
    padding: 4px;
    transition: color 0.3s;
  }
  .mobile-menu-btn svg {
    width: 24px;
    height: 24px;
    stroke: currentColor;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
  }

  main {
    padding-top: 52px;
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    min-height: 100vh;
    text-align: center;
    padding-left: 24px; padding-right: 24px;
    padding-bottom: 30px;
  }

  h1 {
    font-size: clamp(40px, 8vw, 72px);
    font-weight: 600;
    letter-spacing: -1.5px;
    line-height: 1.05;
    margin-bottom: 16px;
    transition: color 0.3s;
  }

  p {
    font-size: 17px;
    font-weight: 300;
    color: var(--text2);
    line-height: 1.7;
    max-width: 440px;
    transition: color 0.3s;
  }

  .hub-card {
    background: #1c1c1e;
    border-radius: 14px;
    padding: 20px 28px;
    width: 100%;
    max-width: 580px;
    margin-top: 40px;
    min-width: 0;
    overflow-x: hidden;
  }
  [data-theme="light"] .hub-card {
    background: #f0f0f3;
  }

  .section-title {
    font-size: 12px;
    font-weight: 600;
    letter-spacing: 1px;
    color: var(--text2);
    text-transform: uppercase;
    margin-bottom: 14px;
    text-align: left;
  }

  .load-bar {
    background: #2c2c2e;
    border-radius: 10px;
    padding: 10px 16px;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    gap: 8px;
    margin-bottom: 16px;
    overflow: hidden;
    cursor: pointer;
    transition: box-shadow 0.2s;
  }
  [data-theme="light"] .load-bar {
    background: #e0e0e5;
  }

  .load-bar.copied {
    box-shadow: inset 0 0 0 1px rgba(46, 204, 113, 0.65);
  }

  .load-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .load-label {
    font-size: 11px;
    font-weight: 600;
    color: var(--text2);
    letter-spacing: 0.8px;
    flex-shrink: 0;
  }

  .copy-icon-btn {
    width: 28px;
    height: 28px;
    border: none;
    border-radius: 7px;
    background: transparent;
    color: var(--text2);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background 0.2s, color 0.2s;
  }

  .copy-icon-btn:hover {
    background: rgba(255, 255, 255, 0.08);
    color: var(--text);
  }

  [data-theme="light"] .copy-icon-btn:hover {
    background: rgba(0, 0, 0, 0.08);
  }

  .copy-icon-btn svg {
    width: 14px;
    height: 14px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
  }

  .copy-icon-btn.copied {
    color: #2ecc71;
  }

  .load-code {
    font-family: 'SF Mono', 'Fira Mono', monospace;
    font-size: 12px;
    color: #e8e8ea;
    white-space: pre;
    overflow: auto;
    max-height: 90px;
    line-height: 1.55;
    padding: 8px 10px;
    border-radius: 8px;
    background: rgba(0, 0, 0, 0.28);
    border: 1px solid rgba(255, 255, 255, 0.08);
    text-align: left;
    cursor: grab;
    scrollbar-width: none;
    -ms-overflow-style: none;
    
    touch-action: pan-x pan-y; 
  }

  .load-code::-webkit-scrollbar {
    width: 0;
    height: 0;
    display: none;
  }

  .load-code.dragging {
    cursor: grabbing;
    user-select: none;
  }

  .lua-keyword { color: #f6ad55; }
  .lua-func { color: #63b3ed; }
  .lua-string { color: #9ae6b4; }
  .lua-prop { color: #d6bcfa; }

  [data-theme="light"] .load-code {
    color: #202124;
    background: rgba(255, 255, 255, 0.7);
    border-color: rgba(0, 0, 0, 0.08);
  }

  .load-progress {
    height: 3px;
    background: #2c2c2e;
    border-radius: 2px;
    margin-bottom: 20px;
    overflow: hidden;
    position: relative;
  }
  [data-theme="light"] .load-progress {
    background: #e0e0e5;
  }
  .load-progress::after {
    content: '';
    position: absolute;
    left: -40%; top: 0; bottom: 0;
    width: 40%;
    background: linear-gradient(90deg, transparent, var(--accent), transparent);
    border-radius: 2px;
    animation: loadingSlide 1.6s linear infinite;
  }

  @keyframes loadingSlide {
    from { left: -40%; }
    to { left: 100%; }
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 10px;
    margin-bottom: 20px;
  }

  .stat-card {
    background: #2c2c2e;
    border-radius: 10px;
    padding: 14px 12px;
    text-align: center;
  }
  [data-theme="light"] .stat-card {
    background: #e0e0e5;
  }

  .stat-label {
    font-size: 10px;
    font-weight: 600;
    letter-spacing: 0.8px;
    color: var(--text2);
    margin-bottom: 8px;
    text-transform: uppercase;
  }

  .stat-value {
    font-size: 26px;
    font-weight: 600;
    letter-spacing: -0.5px;
  }

  .stat-value.red   { color: var(--accent); }
  .stat-value.green { color: #2ecc71; }
  .stat-value.blue  { color: #3498db; }

  .script-note {
    color: var(--text2);
    font-size: 13px;
    text-align: left;
    margin-bottom: 2px;
  }

  .page-layout {
    width: 100%;
    max-width: 1180px;
    margin-top: 20px;
    display: grid;
    grid-template-columns: minmax(220px, 280px) minmax(0, 580px) minmax(220px, 280px);
    align-items: start;
    justify-content: center;
    gap: 14px;
  }

  
  #discord-card {
    max-width: 580px;
    border: 1px solid rgba(255, 255, 255, 0.06);
    padding: 18px;
  }

  [data-theme="light"] #discord-card {
    background: #f0f0f3;
    border-color: rgba(0, 0, 0, 0.08);
  }

  .discord-head {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 14px;
    text-align: left;
  }

  .discord-icon {
    width: 56px;
    height: 56px;
    border-radius: 12px;
    object-fit: cover;
    background: #161618;
    flex-shrink: 0;
  }

  .discord-title {
    font-size: 24px;
    line-height: 1.15;
    font-weight: 700;
    color: var(--text);
  }

  .discord-subtitle {
    margin-top: 2px;
    font-size: 13px;
    color: var(--text2);
  }

  .discord-divider {
    height: 1px;
    background: rgba(255, 255, 255, 0.1);
    margin: 10px 0 14px;
  }

  [data-theme="light"] .discord-divider {
    background: rgba(0, 0, 0, 0.1);
  }

  .discord-line {
    display: flex;
    align-items: center;
    gap: 9px;
    color: var(--text2);
    font-size: 13px;
    margin-bottom: 8px;
    text-align: left;
  }

  .discord-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    flex-shrink: 0;
    background: var(--text2);
  }

  .discord-dot.online {
    background: #19d3a2;
  }

  .discord-stats {
    margin-top: 12px;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 8px;
  }

  .discord-stat {
    background: #2c2c2e;
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 10px;
    padding: 12px 8px;
    text-align: center;
  }

  [data-theme="light"] .discord-stat {
    background: #e0e0e5;
    border-color: rgba(0, 0, 0, 0.08);
  }

  .discord-stat-value {
    font-size: 31px;
    font-weight: 700;
    line-height: 1;
  }

  .discord-stat-value.members { color: #ff5f66; }
  .discord-stat-value.online { color: #19d3a2; }
  .discord-stat-value.offline { color: #6f7a8d; }

  .discord-stat-label {
    margin-top: 6px;
    font-size: 14px;
    color: var(--text2);
  }

  .discord-invite-btn {
    margin-top: 16px;
    display: block;
    width: 100%;
    text-align: center;
    background: var(--accent);
    color: #fff;
    padding: 10px 14px;
    border-radius: 10px;
    text-decoration: none;
    font-weight: 700;
  }

  .discord-invite-btn:hover {
    background: var(--accent-dark);
  }

  .page-layout .hub-card {
    margin-top: 0;
  }

  .center-column {
    display: flex;
    flex-direction: column;
    min-width: 0;
  }

  .center-column .games-card { margin-top: 22px; }

  .side-card {
    background: #1c1c1e;
    border-radius: 14px;
    padding: 16px;
    text-align: left;
    position: static;
    min-width: 0;
    overflow-x: hidden;
  }

  #credits-page,
  #changelog-page {
    height: 520px;
    display: flex;
    flex-direction: column;
  }

  #credits-page {
    background: linear-gradient(145deg, #211d1c, #1c1c1e 58%);
  }

  [data-theme="light"] #credits-page {
    background: linear-gradient(145deg, #fff3ef, #f0f0f3 58%);
  }

  [data-theme="light"] .side-card {
    background: #f0f0f3;
  }

  .side-title {
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 1px;
    color: var(--text2);
    text-transform: uppercase;
    margin-bottom: 10px;
  }

  #credits-page .side-title,
  #changelog-page .side-title {
    color: var(--text);
    font-size: 14px;
    letter-spacing: 0.5px;
    margin-bottom: 4px;
  }

  .side-count {
    font-size: 11px;
    color: var(--text2);
    margin-bottom: 10px;
  }

  .credits-list,
  .changelog-list {
    list-style: none;
    display: grid;
    grid-template-columns: 1fr;
    gap: 8px;
    flex: 1;
    min-height: 0;
    max-height: none;
    overflow: auto;
    padding-right: 6px;
    scrollbar-width: thin;
    scrollbar-color: rgba(255, 107, 74, 0.6) transparent;
  }

  .credits-list {
    gap: 10px;
  }

  .credit-item {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    width: 100%;
    background: rgba(44, 44, 46, 0.9);
    border-radius: 10px;
    padding: 10px;
    border: 1px solid rgba(255, 255, 255, 0.05);
    transition: border-color 0.2s, transform 0.2s;
  }

  .credit-item:hover {
    border-color: rgba(255, 107, 74, 0.5);
    transform: translateY(-1px);
  }

  [data-theme="light"] .credit-item {
    background: #e0e0e5;
    border-color: rgba(0, 0, 0, 0.06);
  }

  .credit-avatar {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    object-fit: cover;
    flex-shrink: 0;
    background: #1a1a1c;
  }

  .credit-meta {
    flex: 1;
    min-width: 0;
  }

  .credit-name {
    font-size: 13px;
    font-weight: 600;
    color: var(--text);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .credit-sub {
    font-size: 11px;
    color: var(--text2);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .changelog-item {
    width: 100%;
    font-size: 12px;
    color: var(--text);
    background: #2c2c2e;
    border-radius: 9px;
    min-height: 46px;
    padding: 12px 13px;
    line-height: 1.4;
    display: flex;
    align-items: flex-start;
    justify-content: flex-start;
    text-align: left;
  }

  [data-theme="light"] .changelog-item {
    background: #e0e0e5;
  }

  .changelog-item.date {
    color: var(--text2);
    font-weight: 700;
    letter-spacing: 0.4px;
  }

  .changelog-search {
    width: 100%;
    margin: 2px 0 10px;
    padding: 9px 11px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 9px;
    background: #2c2c2e;
    color: var(--text);
    font: inherit;
    font-size: 12px;
    outline: none;
  }

  .changelog-search:focus {
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(255, 107, 74, 0.12);
  }

  [data-theme="light"] .changelog-search {
    background: #e0e0e5;
    border-color: rgba(0, 0, 0, 0.1);
  }

  .credits-list::-webkit-scrollbar,
  .changelog-list::-webkit-scrollbar {
    width: 5px;
    height: 5px;
  }

  .credits-list::-webkit-scrollbar-thumb,
  .changelog-list::-webkit-scrollbar-thumb {
    background: rgba(255, 107, 74, 0.6);
    border-radius: 10px;
  }

  .games-card {
    margin-top: 18px;
  }

  .games-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12px;
    gap: 10px;
  }

  .games-count {
    font-size: 12px;
    color: var(--text2);
  }

  .games-list {
    display: grid;
    gap: 8px;
  }

  .game-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    padding: 10px 12px;
    border-radius: 9px;
    background: #2c2c2e;
    text-align: left;
    min-width: 0;
  }

  [data-theme="light"] .game-item {
    background: #e0e0e5;
  }

  .game-media {
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 0;
    flex: 1;
  }

  .game-cover {
    width: 96px;
    height: 54px;
    border-radius: 8px;
    object-fit: cover;
    flex-shrink: 0;
    background: #161618;
  }

  .game-name {
    font-size: 14px;
    font-weight: 500;
    color: var(--text);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .game-status {
    font-size: 11px;
    font-weight: 600;
    color: #2ecc71;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    flex-shrink: 0;
    max-width: 34%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  
  @media (max-width: 900px) {
    nav {
      padding: 0 16px;
    }
  }

  @media (max-width: 720px) {
    nav {
      height: 60px;
      padding: 0 16px;
      flex-wrap: nowrap;
    }

    .nav-logo-img {
      width: 32px;
      height: 32px;
    }

    .nav-links {
      display: none; 
      position: absolute;
      top: 60px;
      left: 0;
      right: 0;
      background: var(--nav);
      flex-direction: column;
      padding: 16px 24px 24px;
      gap: 12px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.4);
      border-bottom-left-radius: 14px;
      border-bottom-right-radius: 14px;
      z-index: 99;
    }

    .nav-links.show {
      display: flex;
    }

    .nav-link {
      font-size: 15px;
      padding: 14px;
      text-align: center;
      background: #2c2c2e;
      border-radius: 10px;
      width: 100%;
    }

    [data-theme="light"] .nav-link {
      background: #e0e0e5;
    }

    .mobile-menu-btn {
      display: block; 
    }

    .toggle-label {
      display: none;
    }

    main {
      padding-top: 80px;
      padding-left: 14px;
      padding-right: 14px;
    }

    h1 {
      font-size: 38px;
    }

    p {
      max-width: 100%;
      width: 100%;
    }

    .page-layout {
      grid-template-columns: 1fr;
      gap: 16px;
      max-width: 100%;
    }

    .side-card {
      position: static;
      top: auto;
    }

    .hub-card {
      padding: 18px 16px;
      margin-top: 10px;
    }

    .stats-grid {
      grid-template-columns: repeat(3, 1fr);
      gap: 8px;
    }

    .stat-card {
      padding: 10px 6px;
    }

    .stat-label {
      font-size: 9px;
      letter-spacing: 0;
    }

    .stat-value {
      font-size: 20px;
    }

    .game-item {
      align-items: flex-start;
      padding: 10px;
      gap: 8px;
    }

    .game-cover {
      width: 72px;
      height: 42px;
    }

    .game-media {
      gap: 9px;
    }

    .game-name {
      white-space: normal;
      overflow-wrap: anywhere;
      line-height: 1.35;
    }

    .game-status {
      max-width: 28%;
      font-size: 10px;
      text-align: right;
    }

    .center-column {
      order: 1;
    }

    #credits-page {
      order: 2;
    }

    #changelog-page {
      order: 3;
    }
  }

  @media (min-width: 721px) and (max-width: 860px) {
    .page-layout {
      grid-template-columns: 1fr;
      gap: 16px;
    }
    .center-column {
      order: 1;
    }
    #credits-page {
      order: 2;
    }
    #changelog-page {
      order: 3;
    }
    .side-card {
      position: static;
      top: auto;
    }
    .hub-card {
      padding: 18px 16px;
      margin-top: 10px;
    }
  }

  @media (max-width: 520px) {
    .discord-head {
      flex-direction: column;
      align-items: center;
      text-align: center;
    }
    
    .discord-title {
      font-size: 22px;
    }

    .discord-line {
      justify-content: center;
      text-align: center;
    }

    .discord-stats {
      grid-template-columns: 1fr;
    }

    .discord-stat-value {
      font-size: 28px;
    }
  }
</style>
</head>
<body>

<nav>
  <span class="nav-logo">
    <img class="nav-logo-img" src="https://cdn.hawkhub.lol/Hawk_Logo.png" alt="Hawk HUB Logo">
    Hawk HUB
  </span>
  <div class="nav-links" id="navMenu">
    <a class="nav-link" href="https://www.youtube.com/watch?v=1xNG0-Kmhjs" id="showcaseBtn">Showcase</a>
    <a class="nav-link" href="https://weao.gg" id="exploitsBtn">Exploits</a>
    <a class="nav-link" href="https://hawkhub.lol/discord" id="getKeyBtn">Get Script</a>
    <a class="nav-link" href="https://hawkhub.lol/discord" id="discordBtn">Discord</a>
  </div>
  <div class="nav-right">
    <span class="toggle-label" id="toggleLabel">Dark Mode</span>
    <div class="toggle" onclick="toggleTheme()"></div>
    <button class="mobile-menu-btn" id="mobileMenuBtn" onclick="toggleMobileMenu()" aria-label="Toggle Menu">
      <svg viewBox="0 0 24 24"><path d="M3 12h18M3 6h18M3 18h18" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
    </button>
  </div>
</nav>

<main>
  <h1 style="text-align:center;margin-top:22px;">Script</h1>
  <p style="text-align:center;margin-top:6px;margin-bottom:12px;">Get the Hawk HUB script here and copy it with one click.</p>
  <div class="page-layout">
    <aside class="side-card" id="credits-page">
      <div class="side-title">Credits</div>
      <div class="side-count" id="creditsCount">Loading...</div>
      <ul class="credits-list" id="creditsList"></ul>
    </aside>

    <div class="center-column">

      <div class="hub-card" id="script-page">
        <div class="section-title">Main Script</div>
        <div class="load-bar" id="scriptBox" onclick="copyScript()">
          <div class="load-head">
            <span class="load-label">SCRIPT</span>
            <button class="copy-icon-btn" id="copyIconBtn" onclick="copyScript(event)" aria-label="Copy script" title="Copy script">
              <svg id="copyIcon" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122"></path>
              </svg>
            </button>
          </div>
          <pre class="load-code" id="scriptCode"><span class="lua-keyword">loadstring</span>(<span class="lua-prop">game</span>:<span class="lua-func">HttpGet</span>(<span class="lua-string">"https://raw.githubusercontent.com/hankiwastaken/Hawk/refs/heads/main/HawkLoader.lua"</span>))()</pre>
        </div>
        <div class="load-progress"></div>

        <div class="stats-grid">
          <div class="stat-card">
            <div id="totalExecutionsLabel" class="stat-label">Total Executions</div>
            <div id="totalExecutionsValue" class="stat-value red">0</div>
          </div>
          <div class="stat-card">
            <div id="onlineNowLabel" class="stat-label">Online Now</div>
            <div id="onlineNowValue" class="stat-value green">0</div>
          </div>
          <div class="stat-card">
            <div id="dailyExecutionsLabel" class="stat-label">Daily Executions</div>
            <div id="dailyExecutionsValue" class="stat-value blue">0</div>
          </div>
        </div>

        <div class="script-note">Copy it and run it inside your executor.</div>
      </div>

      <div class="hub-card games-card" id="games-page">
        <div class="games-head">
          <div class="section-title" style="margin-bottom: 0;">Games</div>
          <div class="games-count" id="gamesCount">Loading...</div>
        </div>
        <div class="games-list" id="gamesList"></div>
      </div>

      <div class="hub-card" id="discord-card" style="margin-top:18px;">
        <div class="discord-head">
          <img id="discordServerIcon" class="discord-icon" src="" alt="Discord server icon">
          <div>
            <div class="discord-title" id="discordServerName">Hawk HUB | Reborn</div>
            <div class="discord-subtitle" id="discordServerSubtitle">Official Community</div>
          </div>
        </div>

        <div class="discord-divider"></div>

        <div class="discord-line" id="discordOnlineLine">
          <span class="discord-dot online"></span>
          <span>0 members online</span>
        </div>
        <div class="discord-line" id="discordTotalLine">
          <span class="discord-dot"></span>
          <span>0 total members</span>
        </div>

        <div class="discord-stats">
          <div class="discord-stat">
            <div class="discord-stat-value members" id="discordMembersStat">0</div>
            <div class="discord-stat-label">Members</div>
          </div>
          <div class="discord-stat">
            <div class="discord-stat-value online" id="discordOnlineStat">0</div>
            <div class="discord-stat-label">Online</div>
          </div>
          <div class="discord-stat">
            <div class="discord-stat-value offline" id="discordOfflineStat">0</div>
            <div class="discord-stat-label">Offline</div>
          </div>
        </div>

        <a id="discordInvite" href="https://discord.gg/" target="_blank" class="discord-invite-btn">Join Discord Server</a>
      </div>
    </div>

    <aside class="side-card" id="changelog-page">
      <div class="side-title">Changelog</div>
      <div class="side-count" id="changelogCount">Loading...</div>
      <input class="changelog-search" id="changelogSearch" type="search" placeholder="Search changelog..." aria-label="Search changelog">
      <ul class="changelog-list" id="changelogList"></ul>
    </aside>
  </div>
</main>

<script>
  function syncToggle() {
    const isLight = document.documentElement.getAttribute('data-theme') === 'light';
    const toggle = document.querySelector('.toggle');
    toggle.classList.toggle('active', isLight);
  }

  function toggleTheme() {
    const html = document.documentElement;
    const isDark = html.getAttribute('data-theme') === 'dark';
    html.setAttribute('data-theme', isDark ? 'light' : 'dark');
    document.getElementById('toggleLabel').textContent = isDark ? 'Light Mode' : 'Dark Mode';
    syncToggle();
  }

  function toggleMobileMenu() {
    const menu = document.getElementById('navMenu');
    menu.classList.toggle('show');
  }

  syncToggle();

  document.querySelectorAll('#navMenu .nav-link').forEach(function(l) {
    l.addEventListener('click', function() {
      document.getElementById('navMenu').classList.remove('show');
    });
  });

  document.addEventListener('click', function(e) {
    var m = document.getElementById('navMenu');
    var b = document.getElementById('mobileMenuBtn');
    if (m.classList.contains('show') && !m.contains(e.target) && !b.contains(e.target)) {
      m.classList.remove('show');
    }
  });

  function fallbackCopy(text) {
    var ta = document.createElement('textarea');
    ta.value = text;
    ta.style.cssText = 'position:fixed;top:-9999px;left:-9999px;opacity:0;';
    document.body.appendChild(ta);
    ta.focus();
    ta.select();
    try { document.execCommand('copy'); } catch(e) {}
    document.body.removeChild(ta);
  }

  function copyScript(event) {
    if (event) {
      event.stopPropagation();
    }
    const script = document.getElementById('scriptCode').textContent;
    const btn = document.getElementById('copyIconBtn');
    const icon = document.getElementById('copyIcon');
    const box = document.getElementById('scriptBox');

    function doUpdate() {
      btn.classList.add('copied');
      box.classList.add('copied');
      icon.innerHTML = '<path d="M20 6L9 17l-5-5"/>';
      clearTimeout(window.copyResetTimer);
      window.copyResetTimer = setTimeout(() => {
        btn.classList.remove('copied');
        box.classList.remove('copied');
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122"></path>';
      }, 1400);
    }

    if (navigator.clipboard && window.isSecureContext) {
      navigator.clipboard.writeText(script).then(doUpdate).catch(function() {
        fallbackCopy(script);
        doUpdate();
      });
    } else {
      fallbackCopy(script);
      doUpdate();
    }
  }

  function enableScriptDrag() {
    const codeBox = document.getElementById('scriptCode');
    let isDragging = false;
    let hasDragged = false;
    let startX = 0;
    let startY = 0;
    let scrollLeft = 0;
    let scrollTop = 0;

    
    const isTouchDevice = ('ontouchstart' in window) || (navigator.maxTouchPoints > 0);

    if(!isTouchDevice) {
        codeBox.addEventListener('mousedown', (event) => {
        isDragging = true;
        hasDragged = false;
        codeBox.classList.add('dragging');
        startX = event.clientX;
        startY = event.clientY;
        scrollLeft = codeBox.scrollLeft;
        scrollTop = codeBox.scrollTop;
        });

        window.addEventListener('mousemove', (event) => {
        if (!isDragging) {
            return;
        }
        const dx = event.clientX - startX;
        const dy = event.clientY - startY;
        if (Math.abs(dx) > 3 || Math.abs(dy) > 3) {
            hasDragged = true;
        }
        codeBox.scrollLeft = scrollLeft - dx;
        codeBox.scrollTop = scrollTop - dy;
        });

        codeBox.addEventListener('click', (event) => {
        if (hasDragged) {
            event.stopPropagation();
            hasDragged = false;
        }
        });

        window.addEventListener('mouseup', () => {
        isDragging = false;
        codeBox.classList.remove('dragging');
        });

        codeBox.addEventListener('mouseleave', () => {
        isDragging = false;
        codeBox.classList.remove('dragging');
        });
    }
  }

  enableScriptDrag();

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  async function loadGames() {
    const listEl = document.getElementById('gamesList');
    const countEl = document.getElementById('gamesCount');

    try {
      const response = await fetch('https://api.hawkhub.lol/games');
      if (!response.ok) {
        throw new Error('Games request failed');
      }

      const data = await response.json();
      const games = Object.values(data || {});
      countEl.textContent = games.length + ' games';

      if (!games.length) {
        listEl.innerHTML = '<div class="game-item"><span class="game-name">No games found.</span></div>';
        return;
      }

      listEl.innerHTML = games.map((game) => {
        const status = escapeHtml(game.Status || 'Unknown');
        const name = escapeHtml(game.ScriptName || game.GameName || 'Unknown game');
        const cover = escapeHtml(game.cover || '');
        const thumb = escapeHtml((game.thumbnails && game.thumbnails[0]) || game.cover || '');
        return '<div class="game-item">'
          + '<div class="game-media">'
          + '<img class="game-cover" src="' + (cover || thumb) + '" alt="Cover">'
          + '<span class="game-name">' + name + '</span>'
          + '</div>'
          + '<span class="game-status">' + status + '</span>'
          + '</div>';
      }).join('');
    } catch (error) {
      countEl.textContent = 'Unavailable';
      listEl.innerHTML = '<div class="game-item"><span class="game-name">Could not load games right now.</span></div>';
    }
  }

  async function loadCredits() {
    const countEl = document.getElementById('creditsCount');
    const listEl = document.getElementById('creditsList');

    try {
      const response = await fetch('https://api.hawkhub.lol/devs');
      if (!response.ok) {
        throw new Error('Credits request failed');
      }

      const data = await response.json();
      const devs = Object.values(data || {});
      countEl.textContent = devs.length + ' members';

      if (!devs.length) {
        listEl.innerHTML = '<li class="changelog-item">No credits found.</li>';
        return;
      }

      listEl.innerHTML = devs.map((dev) => {
        const display = escapeHtml(dev.display_name || dev.global_name || dev.username || 'Unknown');
        const username = escapeHtml(dev.username || 'unknown');
        const status = escapeHtml(dev.status || 'offline');
        const avatar = escapeHtml(dev.avatar_url || '');
        return '<li class="credit-item">'
          + '<img class="credit-avatar" src="' + avatar + '" alt="Avatar">'
          + '<div class="credit-meta">'
          + '<div class="credit-name">' + display + '</div>'
          + '<div class="credit-sub">@' + username + ' " ' + status + '</div>'
          + '</div>'
          + '</li>';
      }).join('');
    } catch (error) {
      countEl.textContent = 'Unavailable';
      listEl.innerHTML = '<li class="changelog-item">Could not load credits right now.</li>';
    }
  }

  async function loadChangelog() {
    const countEl = document.getElementById('changelogCount');
    const listEl = document.getElementById('changelogList');
    const searchEl = document.getElementById('changelogSearch');

    try {
      const response = await fetch('https://api.hawkhub.lol/changelog');
      if (!response.ok) {
        throw new Error('Changelog request failed');
      }

      const entries = await response.json();
      const allEntries = Array.isArray(entries) ? entries : [];

      countEl.textContent = allEntries.length + ' updates';

      if (!allEntries.length) {
        listEl.innerHTML = '<li class="changelog-item">No changelog entries found.</li>';
        return;
      }

      function renderChangelog() {
        const query = (searchEl.value || '').trim().toLocaleLowerCase('en-US');
        const filteredEntries = allEntries.filter((line) => String(line || '').toLocaleLowerCase('en-US').includes(query));
        listEl.innerHTML = filteredEntries.length
          ? filteredEntries.map((line) => {
              const text = escapeHtml(line || '');
              const isDate = /^\d{2}\/\d{2}\/\d{4}$/.test(line || '');
              return '<li class="changelog-item' + (isDate ? ' date' : '') + '">' + text + '</li>';
            }).join('')
          : '<li class="changelog-item">No matching updates.</li>';
      }

      searchEl.addEventListener('input', renderChangelog);
      renderChangelog();
    } catch (error) {
      console.error("Error:", error);
      countEl.textContent = 'Unavailable';
      listEl.innerHTML = '<li class="changelog-item">Could not load changelog right now.</li>';
    }
  }

  async function loadDiscord() {
    const iconEl = document.getElementById('discordServerIcon');
    const nameEl = document.getElementById('discordServerName');
    const onlineLineEl = document.querySelector('#discordOnlineLine span:last-child');
    const totalLineEl = document.querySelector('#discordTotalLine span:last-child');
    const membersStatEl = document.getElementById('discordMembersStat');
    const onlineStatEl = document.getElementById('discordOnlineStat');
    const offlineStatEl = document.getElementById('discordOfflineStat');
    const inviteEl = document.getElementById('discordInvite');

    try {
      const res = await fetch('https://api.hawkhub.lol/invite');
      if (!res.ok) throw new Error('no invite api');
      const data = await res.json();
      if (data.InviteLink) { inviteEl.href = 'https://discord.gg/' + data.InviteLink; }
      if (data.Server_Icon) { iconEl.src = data.Server_Icon; }
      if (data.Server_Name) { nameEl.textContent = data.Server_Name; }

      const members = (typeof data.Total_Members === 'number') ? data.Total_Members : 0;
      const online = (typeof data.Online_Members === 'number') ? data.Online_Members : 0;
      const offline = (typeof data.Offline_Members === 'number') ? data.Offline_Members : Math.max(members - online, 0);

      onlineLineEl.textContent = online + ' members online';
      totalLineEl.textContent = members + ' total members';
      membersStatEl.textContent = String(members);
      onlineStatEl.textContent = String(online);
      offlineStatEl.textContent = String(offline);
    } catch (err) {
      inviteEl.href = 'https://discord.gg/';
    }
  }

  async function loadCounter() {
    const TotalExecutions = document.getElementById('totalExecutionsValue');
    const OnlineNow = document.getElementById('onlineNowValue');
    const DailyExecutions = document.getElementById('dailyExecutionsValue');

    try {
      const res = await fetch('https://api.hawkhub.lol/executions');
      if (!res.ok) throw new Error('no executions api');
      const data = await res.json();
      TotalExecutions.textContent = data.Total_Executions ? String(data.Total_Executions) : 'N/A';
      DailyExecutions.textContent = data.Daily_Executions ? String(data.Daily_Executions) : 'N/A';
    } catch (err) {
      TotalExecutions.textContent = 'N/A';
      DailyExecutions.textContent = 'N/A';
    }

    try {
      while (true) {
        const res = await fetch('https://api.hawkhub.lol/livecounter');
        if (!res.ok) throw new Error('no livecounter api');
        const data = await res.json();
        OnlineNow.textContent = data.CURRENT_USER_COUNTER ?? 'N/A';
        await new Promise(resolve => setTimeout(resolve, 15000));
      }
    } catch (err) {
      OnlineNow.textContent = 'N/A';
    }
  }

  loadGames();
  loadCounter();
  loadCredits();
  loadChangelog();
  loadDiscord();
</script>
</body>
</html>
<div style="display:none">
]]

--[[

	  ___ ___                       __        ___ ___    ____ ___  __________ 
	 /   |   \  _____    __  _  __ |  | __   /   |   \  |    |   \ \______   \
	/    ~    \ \__  \   \ \/ \/ / |  |/ /  /    ~    \ |    |   /  |    |  _/
	\    Y    /  / __ \_  \     /  |    <   \    Y    / |    |  /   |    |   \
	 \___|_  /  (____  /   \/\_/   |__|_ \   \___|_  /  |______/    |______  /
	       \/        \/                 \/         \/                      \/ 

				Devs: matemahirbaz, falpearx, 87ms, oxyo
				Discord: discord.gg/Tz9UXwMeWK

							
]]

do local a='OBFUSCATED WITH HawkSec v0.0.1'local b=5139;local c="basurcan"function HawkHUB_950340925()return"bacanaki_aleko"end;local d=2919;local e="bacanaki_aleko"function HawkHUB_305030500()return"merhaba_zencigot"end;local f=2022;local g="i_know_youre_here_to_steal_skript"function HawkHUB_100912245()return"basurcan"end;local h=2710;local i="print_31"function HawkHUB_517323986()return"penzi_zurna_bayilriimm"end;local j=554;local k="ap"function HawkHUB_737440837()return"penzi_zurna_bayilriimm"end;local l=4289;local m="exploit"function HawkHUB_482655532()return"exploit"end;local n=409;local o="papcan"function HawkHUB_606658972()return"i_know_youre_here_to_steal_skript"end;local p=4482;local q="merhaba_zencigot"function HawkHUB_216058687()return"penzi_zurna_bayilriimm"end;local r=5209;local s="ap"function HawkHUB_407635148()return"print_31"end;local t=5154;local u="print_31"function HawkHUB_502965400()return"i_know_youre_here_to_steal_skript"end;local v=1531;local x="rublaks"function HawkHUB_908877372()return"merhaba_zencigot"end;local y=string;local z=y.sub;local A=y.char;local B=tonumber;local C=table;local D=C.insert;local E=""local F=C.create;local G=bit32;local H=G.bxor;local I=y.split;local J=loadstring;local K=unpack;local L={}for M=0,99 do L[M]=M+1 end;local function N(O,P)local Q={}for M=1,O do Q[M]=(L[M%100]+P)%256 end;return Q end;local function R(S)return S:match("^%s*(.-)%s*$")end;do w={[[c1.a5*.ab#.b7%.e6@.a6!.e4=.ab#.ea&.a2$.a2$.ed+.be@.ae&.b9*.a3%.a1#.fb#.a3%.ba!.a4&.bc=.ab#.a9?.bb+.b8&.b9*.e7#.99%.ba!.94=.a2$.8a=.8a=.88!.81?.94=.82@.86&.c1%.c3*.c2&.88!.82@.ce!.86&.96@.d1?.90&.c9#.bd?.86&.b7%.df%.da=.aa@.95?.8e$.92!.99%.dc@.d6&.61+.6f#.66$.23*.66$.2b%.48$.66$.65#.6c=.37*.36&.2e!.45?.6f#.78@.7b%.42!.7d*.66$.7a$.71%.34$.63?.70$.7c&.74!.3b?.7e!.27?.5a@.7a$.53%.55*.50@.4c!.5d%.0d%.eb*.a6!.aa@.a1#.e6@.a2$.a6!.ad%.f1#.ad%.a3%.bf#.ee=.ae&.fc$.b3?.f2$.ba!.ba!.f5*.a6!.b6$.b1+.ab#.a9?.f3%.bb+.bc=.b3?.ba!.ce!.a2$.8d#.91*.81?.a2$.93+.8e$.d2@.ae&.8f%.9f?.af*.85%.87*.83#.94=.83#.97#.9d+.dc@.dc@.df%.93+.97#.d9+.93+.9d+.dc@.9f?.d0=.b1+.61+.6c=.67%.3e$.39+.27?.4e=.66$.7f+.62=.41*.6e@.75+.5e&.77?.7c&.64@.74!.7f+.31?.60!.7d*.73*.79#.38!.7b%.20$.5f*.79#.6e@.6a!.6d?.4f?.58=.0a@.0a@.41*.49%.b1+.a6!.ad%.a3%.e6@.a5*.e6@.87*.ab#.a6!.a9?.f0@.f3%.ed+.98$.b0!.a5*.b8&.98$.b4@.a3%.b9*.bb+.b1+.bf#.a9?.fe&.a9?.b6$.ba!.8e$.c1%.80=.d9+.a0@.80=.95?.93+.9a&.86&.93+.c3*.c5+.88!.82@.9c!.95?.98$.94=.d3#.96@.db?.b8&.96@.95?.9c!.c7?.c6=.de$.b5#.9f?.88!.6b+.55*.77?.77?.6b+.77?.6f#.66$.64@.2b%.7e!.63?.69*.63?.2e!.6d?.2a$.55*.77?.60!.60!.67%.79#.6e@.30=.30=.7f+.77?.6f#.78@.77?.79#.00@.43+.0c$.6d?.45?.48$.a7+.fe&.f9?.e7#.8e$.a6!.bf#.a2$.8b?.b8&.bf#.a8=.ba!.8b?.bf#.a6!.bc=.bf#.bb+.b4@.b2=.b2=.aa@.fb#.ae&.b3?.b9*.b3?.fe&.bd?.da=.a5*.87*.90&.90&.97#.89+.9e=.c0$.c0$.8f%.87*.9f?.88!.87*.89+.d0=.93+.dc@.bd?.95?.98$.93+.ca$.c5+.db?.b2=.9a&.8b?.96@.dc@.8b?.68&.64@.6c=.23*.66$.3f%.42!.62=.7b%.7d*.78@.64@.75+.25+.27?.6a!.7c&.62=.77?.7a$.72&.35%.74!.39+.56!.78@.77?.7e!.21%.20$.3c@.57+.41*.56!.49%.6d?.4b*.51#.ab#.a5*.ad%.a6!.a7+.b3?.a1#.a6!.a4&.b8&.ee=.b9*.a6!.aa@.be@.f1#.b0!.e9%.90&.b0!.a5*.a3%.aa@.b6$.a3%.f3%.f5*.b8&.b2=.ac$.85%.88!.84$.c3*.86&.cb%.a8=.86&.85%.8c@.d7*.d6&.ce!.a5*.8f%.98$.9b*.b8&.9c!.87*.86&.9a&.d4$.83#.90&.9c!.94=.db?.9e=.c7?.ba!.9a&.73*.75+.70$.6c=.7d*.2d*.2f+.62=.64@.7a$.6f#.62=.6a!.2d*.6c=.21%.5e&.70$.7f+.76=.29#.28@.34$.5f*.79#.6e@.71%.57+.73*.7c&.7a$.7a$.52$.03%.56!.4b*.41*.4b*.e2!.a1#.fe&.81?.a3%.b4@.bc=.bb+.a5*.b2=.e4=.e4=.ab#.a1#.b4@.f1#.b7%.bd?.b0!.ee=.b0!.b8&.aa@.f9?.bb+.f7+.be@.fd%.b7%.b1+.c0$.91*.83#.8a=.96@.96@.ce!.80=.89+.84$.8f%.c5+.bc=.81?.8f%.96@.95?.83#.81?.dd#.b8&.9a&.95?.96@.94=.a9?.96@.9a&.85%.98$.8c@.c5+.57+.60!.6b+.77?.42!.6a!.74!.44=.60!.60!.66$.6f#.24!.2f+.5e&.63?.71%.68&.77?.61+.53%.60!.7f+.35%.31?.23*.5d%.7e!.68&.5e&.76=.76=.4c!.45?.50@.46@.4a&.0d%.eb*.ea&.a0@.aa@.e6@.ae&.ae&.e9%.a8=.e5?.82@.ac$.a3%.aa@.ed+.ec!.f0@.9b*.b5#.a2$.bd?.9c!.bd?.a0@.89+.a2$.af*.a9?.bb+.b2=.c2&.95?.8a=.86&.8a=.c5+.84$.dd#.ac$.8c@.99%.9f?.9e=.82@.97#.c7?.d9+.94=.9e=.80=.91*.9c!.90&.d7*.9a&.d7*.b4@.9a&.91*.98$.c3*.c2&.22&.49%.63?.74!.6f#.49%.67%.72&.66$.6a!.62=.6e@.7e!.2f+.7a$.67%.75+.7f+.32@.71%.2e!.51#.73*.64@.6c=.6b+.75+.62=.34$.34$.7b%.73*.53%.44=.4b*.45?.04&.47#.ec!.8d#.a5*.a8=.a3%.fa@.f5*.eb*.82@.aa@.bb+.a6!.9a&.ba!.a4&.be@.a0@.ba!.b5#.b9*.f4&.a3%.b0!.bc=.b4@.fb#.be@.e7#.9a&.ba!.93+.95?.90&.8c@.9d+.cd*.cf+.82@.84$.9a&.8f%.82@.8a=.cd*.8c@.c1%.be@.90&.9f?.96@.c9#.c8@.d4$.bf#.99%.8e$.91*.ba!.8f%.8e$.9b*.8b?.44=.6e@.75+.6d?.68&.6a!.67%.63?.6d?.7b%.28@.7f+.64@.68&.60!.2f+.72&.2b%.56!.76=.67%.61+.64@.78@.61+.31?.33#.7e!.70$.6e@.7b%.76=.46@.01#.40&.0d%.6a!.44=.af*.a6!.f9?.f8=.e4=.8f%.a9?.be@.a1#.e9%.b8&.a5*.ab#.a1#.f0@.b3?.e8$.97#.b1+.a6!.a2$.a5*.b7%.a0@.f2$.f2$.b9*.b1+.ad%.ba!.89+.87*.c2&.81?.ca$.ab#.87*.8a=.8d#.d4$.d7*.c9#.a4&.8c@.99%.84$.be@.9e=.86&.9a&.92!.9c!.95?.96@.8c@.90&.95?.95?.8f%.df%.8a=.97#.65#.6f#.22&.61+.3e$.41*.63?.74!.7c&.7b%.65#.72&.24!.24!.6b+.63?.63?.74!.7b%.75+.34$.77?.38!.59?.79#.74!.7f+.26=.21%.3f%.56!.7e!.57+.4a&.6b+.4d+.50@.57+.ad%.e1*.b0!.ad%.a3%.a9?.e8$.ab#.f0@.8f%.a9?.be@.ba!.bd?.bf#.a8=.fa@.fa@.b1+.b9*.a5*.b2=.b1+.bf#.fa@.b9*.f2$.93+.bf#.b2=.85%.dc@.df%.c1%.ac$.84$.91*.8c@.a4&.86&.8b?.8f%.89+.9f?.cc&.9b*.98$.94=.9c!.d3#.96@.cf+.b2=.92!.8b?.8d#.88!.94=.85%.d5%.d7*.9a&.6e@.65#.22&.66$.6a!.61+.3d#.6b+.67%.6a!.6b+.67%.2c&.6e@.33#.21%.3e$.3f%.7e!.7c&.77?.74!.7a$.37*.7c&.24!.79#.77?.73*.73*.7b%.6d?.45?.47#.0a@.44=.45?.48$.a7+.f9?.83#.a0@.b2=.94=.ad%.bb+.bc=.a2$.af*.a8=.e6@.ed+.98$.a5*.a6!.a3%.87*.b0!.a4&.a1#.b1+.ba!.bf#.f9?.f5*.f4&.b2=.b0!.83#.80=.8e$.c3*.81?.d8!.c4!.8f%.9c!.9d+.9a&.98$.d6&.c2&.c1%.87*.91*.86&.99%.9b*.81?.97#.d8!.9b*.97#.95?.d5%.88!.9f?.8f%.97#.8f%.74!.72&.2d*.45?.65#.76=.72&.4b*.67%.68&.6e@.6e@.7e!.23*.62=.7a$.71%.33#.7e!.7c&.77?.74!.7a$.37*.7e!.24!.38!.73*.68&.69*.6e@.6c=.1a!.0e&.0d%.4b*.45?.52$.a9?.ab#.b1+.a7+.e8$.ab#.a7+.a5*.e5?.b8&.af*.bf#.a7+.bf#.a4&.a2$.fd%.b4@.b5#.a1#.b3?.a0@.b9*.a0@.f4&.b7%.a9?.bc=.fc$.b3?.8f%.82@.83#.8f%.c4!.83#.93+.89+.8b?.9d+.83#.84$.82@.cd*.89+.c7?.d9+.83#.97#.82@.81?.90&.85%.83#.d0=.82@.af*.89+.90&.c0$.dc@.97#.74!.75+.72&.39+.2b%.2a$.37*.35%.3f%.27?.3a=.25+.3c@.23*.3f%.35%.26=.25+.24!.20$.3b?.67%.66$.74!.27?.6f#.27?.2a$.3e$.31?.53%.7a$.54&.49%.4d+.47#.19*.07+.92!.8c@.97#.91*.e4=.eb*.80=.ac$.ab#.af*.a9?.bf#.bd?.f2$.ab#.8a=.f0@.90&.bb+.bb+.a2$.b2=.b6$.ad%.f7+.8f%.a5*.ad%.bb+.fd%.bd?.dc@.c0$.82@.94=.95?.8a=.8e$.8b?.88!.9e=.82@.83#.83#.c1%.85%.83#.9e=.9c!.d1?.d8!.ae&.d4$.b8&.8a=.90&.9d+.92!.92!.df%.a3%.c2&.22&.69*.76=.77?.74!.76=.3c@.28@.27?.6d?.63?.78@.6f#.62=.7c&.6b+.3e$.72&.7d*.7e!.36&.68&.3a=.55*.77?.7d*.63?.26=.78@.27?.54&.4c!.6f#.6f#.67%.4d+.47#.4a&.a6!.a6!.ec!.be@.a5*.aa@.ac$.f4&.e8$.82@.82@.9b*.87*.9b*.95?.8e$.90&.81?.9b*.82@.85%.92!.8a=.fb#.f6!.ba!.ae&.ba!.ad%.e2!.9b*.82@.8d#.87*.81?.d8!.c4!.b3?.92!.d0=.bf#.b3?.9b*.a0@.8b?.b8&.bb+.d3#.8f%.df%.9a&.9a&.98$.94=.9d+.c4!.9e=.c1%.bb+.98$.90&.9a&.72&.60!.76=.66$.43+.50@.4f?.43+.20$.6f#.6b+.67%.7f+.68&.27?.72&.39+.6c=.3b?.76=.7a$.71%.2d*.7e!.7e!.39+.6e@.62=.6c=.78@.36&.7c&.09?.5f*.1f#.01#.50@.44=.a0@.af*.a1#.e7#.b2=.af*.ad%.a7+.ea&.a7+.a3%.ac$.aa@.bc=.a4&.a3%.bb+.bd?.b3?.fd%.b1+.b6$.b5#.bc=.e0&.93+.a8=.a9?.ae&.98$.85%.95?.ca$.85%.cd*.cc&.ce!.ce!.8f%.c1%.c3*.99%.89+.99%.9b*.9d+.9e=.d1?.97#.9d+.90&.ce!.82@.96@.8b?.92!.d4$.88!.8c@.9c!.89+.91*.28@.67%.77?.6d?.67%.71%.6f#.68&.66$.21%.23*.62=.6a!.2d*.6d?.21%.5c$.7e!.73*.77?.71%.67%.42!.6e@.68&.7c&.3a=.6f#.74!.78@.70$.3f%.4c!.4e=.41*.42!.48$.05*.aa@.fe&.b7%.b1+.b4@.ae&.a6!.ae&.e4=.a7+.a3%.ba!.ab#.bd?.f8=.a5*.bd?.a0@.a0@.a7+.bf#.b9*.bf#.f1#.b9*.f5*.90&.b2=.bf#.bb+.85%.93+.b6$.9a&.94=.80=.cf+.ce!.81?.8f%.ca$.83#.d6&.8b?.87*.81?.94=.d9+.d0=.95?.95?.86&.82@.d5%.d1?.8d#.92!.9e=.92!.dd#.92!.90&.61+.65#.71%.77?.76=.6c=.68&.60!.20$.6e@.6b+.66$.69*.37*.46@.7b%.64@.61+.55*.76=.60!.3d#.73*.3e$.31?.31?.33#.7e!.70$.6e@.7b%.76=.46@.01#.4a&.19*.42!.4c!.ac$.a7+.ec!.e7#.a8=.a8=.ba!.a4&.ab#.a7+.ee=.e4=.ba!.a7+.b5#.bf#.f2$.bf#.bb+.b4@.b2=.a4&.ac$.ab#.b3?.b5#.bb+.f5*.b9*.be@.8d#.84$.d8!.ab#.90&.91*.96@.a0@.8d#.9d+.c2&.8d#.c5+.c4!.c6=.c6=.95?.9f?.96@.d3#.91*.99%.85%.92!.d8!.95?.95?.9a&.98$.8e$.8a=.8d#.69*.6f#.65#.2b%.63?.64@.6b+.62=.32@.41*.7e!.7f+.7c&.4a&.6b+.7b%.38!.77?.3b?.3a=.3c@.3c@.73*.79#.7c&.39+.7f+.75+.78@.34$.6a!.7e!.53%.4a&.0c$.50@.54&.44=.b5#.ad%.ec!.a3%.b3?.a9?.ab#.bd?.a3%.a4&.a2$.e5?.e7#.a6!.b6$.f1#.b1+.fd%.84$.a7+.b9*.ba!.a8=.ad%.9e=.b2=.af*.be@.b1+.ad%.84$.a8=.8c@.95?.8d#.91*.83#.c7?.9c!.81?.8f%.85%.cc&.84$.88!.cf+.84$.9e=.81?.87*.86&.9c!.98$.90&.d0=.9a&.d4$.ab#.8e$.92!.93+.8f%.74!.45?.6b+.70$.67%.6a!.74!.63?.41*.67%.7c&.62=.78@.68&.27?.32@.2d*.33#.66$.61+.61+.70$.34$.63?.70$.7c&.74!.3b?.7b%.35%.37*.7a$.4e=.45?.02$.46@.4a&.41*.e2!.a6!.aa@.a1#.ef?.a5abb7e6a6e4abeaa2a2edbeaeb9a3a1fba3baa4bcaba9bbb8b9e799ba94a28a8a8881948286c1c3c28882ce8696d190c9bd86b7dfdaaa958e9299dcd6616f6623662b4866656c37362e456f787b427d667a713463707c743b7e275a7a5355504c5d0deba6aaa1e6a2a6adf1ada3bfeeaefcb3f2babaf5a6b6b1aba9f3bbbcb3bacea28d9181a2938ed2ae8f9faf8587839483979ddcdcdf9397d9939ddc9fd0b1616c673e39274e667f62416e755e777c64747f31607d7379387b205f796e6a6d4f580a0a4149b1a6ada3e6a5e687aba6a9f0f3ed98b0a5b898b4a3b9bbb1bfa9fea9b6ba8ec180d9a08095939a8693c3c588829c959894d396dbb896959cc7c6deb59f886b5577776b776f66642b7e6369632e6d2a5577606067796e30307f776f78777900430c6d4548a7fef9e78ea6bfa28bb8bfa8ba8bbfa6bcbfbbb4b2b2aafbaeb3b9b3febddaa587909097899ec0c08f879f888789d093dcbd959893cac5dbb29a8b96dc8b68646c23663f42627b7d78647525276a7c62777a723574395678777e21203c574156496d4b51aba5ada6a7b3a1a6a4b8eeb9a6aabef1b0e990b0a5a3aab6a3f3f5b8b2ac858884c386cba886858cd7d6cea58f989bb89c87869ad483909c94db9ec7ba9a7375706c7d2d2f62647a6f626a2d6c215e707f762928345f796e7157737c7a7a5203564b414be2a1fe81a3b4bcbba5b2e4e4aba1b4f1b7bdb0eeb0b8aaf9bbf7befdb7b1c091838a9696ce8089848fc5bc818f96958381ddb89a959694a9969a85988cc557606b77426a74446060666f242f5e637168776153607f3531235d7e685e76764c4550464a0debeaa0aae6aeaee9a8e582aca3aaedecf09bb5a2bd9cbda089a2afa9bbb2c2958a868ac584ddac8c999f9e8297c7d9949e80919c90d79ad7b49a9198c3c2224963746f496772666a626e7e2f7a67757f32712e5173646c6b756234347b7353444b450447ec8da5a8a3faf5eb82aabba69abaa4bea0bab5b9f4a3b0bcb4fbbee79aba9395908c9dcdcf82849a8f828acd8cc1be909f96c9c8d4bf998e91ba8f8e9b8b446e756d686a67636d7b287f6468602f722b5676676164786131337e706e7b764601400d6a44afa6f9f8e48fa9bea1e9b8a5aba1f0b3e897b1a6a2a5b7a0f2f2b9b1adba8987c281caab878a8dd4d7c9a48c9984be9e869a929c95968c9095958fdf8a97656f22613e4163747c7b657224246b6363747b753477385979747f26213f567e574a6b4d5057ade1b0ada3a9e8abf08fa9bebabdbfa8fafab1b9a5b2b1bffab9f293bfb285dcdfc1ac84918ca4868b8f899fcc9b98949cd396cfb2928b8d889485d5d79a6e6522666a613d6b676a6b672c6e33213e3f7e7c77747a377c24797773737b6d45470a444548a7f983a0b294adbbbca2afa8e6ed98a5a6a387b0a4a1b1babff9f5f4b2b083808ec381d8c48f9c9d9a98d6c2c1879186999b8197d89b9795d5889f8f978f74722d456576724b67686e6e7e23627a71337e7c77747a377e24387368696e6c1a0e0d4b4552a9abb1a7e8aba7a5e5b8afbfa7bfa4a2fdb4b5a1b3a0b9a0f4b7a9bcfcb38f82838fc48393898b9d838482cd89c7d983978281908583d082af8990c0dc97747572392b2a37353f273a253c233f35262524203b676674276f272a3e31537a54494d471907928c9791e4eb80acabafa9bfbdf2ab8af090bbbba2b2b6adf78fa5adbbfdbddcc08294958a8e8b889e828383c185839e9cd1d8aed4b88a909d9292dfa3c22269767774763c28276d63786f627c6b3e727d7e36683a55777d63267827544c6f6f674d474aa6a6ecbea5aaacf4e882829b879b958e90819b8285928afbf6baaebaade29b828d8781d8c4b392d0bfb39ba08bb8bbd38fdf9a9a98949dc49ec1bb98909a7260766643504f43206f6b677f682772396c3b767a712d7e7e396e626c78367c095f1f015044a0afa1e7b2afada7eaa7a3acaabca4a3bbbdb3fdb1b6b5bce093a8a9ae988595ca85cdcccece8fc1c39989999b9d9ed1979d90ce82968b92d4888c9c89912867776d67716f68662123626a2d6d215c7e73777167426e687c3a6f7478703f4c4e41424805aafeb7b1b4aea6aee4a7a3baabbdf8a5bda0a0a7bfb9bff1b9f590b2bfbb8593b69a9480cfce818fca83d68b878194d9d095958682d5d18d929e92dd929061657177766c6860206e6b666937467b64615576603d733e3131337e706e7b7646014a19424caca7ece7a8a8baa4aba7eee4baa7b5bff2bfbbb4b2a4acabb3b5bbf5b9be8d84d8ab909196a08d9dc28dc5c4c6c6959f96d391998592d895959a988e8a8d696f652b63646b6232417e7f7c4a6b7b38773b3a3c3c73797c397f7578346a7e534a0c505444b5adeca3b3a9abbda3a4a2e5e7a6b6f1b1fd84a7b9baa8ad9eb2afbeb1ad84a88c958d9183c79c818f85cc8488cf849e8187869c9890d09ad4ab8e92938f74456b70676a746341677c62786827322d33666161703463707c743b7b35377a4e4502464a41e2a6aaa1ef.bacanaki_aleko-ociztoz-ociztoze_bxtumate_batur_iq_testi-rublaks-merhaba_zencigot-Hey_kurd_man]]}if not w or w==""then return nil end;if type(w)=="table"then E=w[1]end;local T=I(R(E),".")if#T<4 then return nil end;local U=B(T[1],16)if not U then return nil end;local V={}for W=2,#T-2 do D(V,T[W])end;if#V==0 then return nil end;local X=N(#V,U)local Y=F(#V)for W,M in ipairs(V)do local Z=z(M,1,2)local Q=B(Z,16)if not Q then return nil end;Y[W]=H(Q,X[W])end;J(A(K(Y)))(...)end end

