<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>XYZ Scripts | Ultimate Roblox Key & Scripting Ecosystem</title>
  <meta name="description" content="Discover verified high-performance Roblox scripts, multi-hour instant key generation, and bypass solutions on XYZ Scripts.">
  <link rel="icon" type="image/svg+xml" href="/assets/logo.svg">
  <link rel="stylesheet" href="/css/home.css?v=1.3.0">
  <link rel="stylesheet" href="/css/style.css?v=2.1.0">
  <link rel="stylesheet" href="/css/halloween.css?v=1.0">
  <script src="/js/security.js?v=4.1"></script>
  <style>
    /* Pine Forest Theme & Glassmorphism Background */
    html, body {
      background: linear-gradient(180deg, #53687a 0%, #6f8596 55%, #8ea1af 100%) !important;
      color: #ffffff !important;
      min-height: 100vh;
      overflow-x: clip;
      font-family: 'Outfit', 'Inter', system-ui, -apple-system, sans-serif !important;
    }
    .scene {
      position: fixed;
      inset: 0;
      z-index: 0;
      overflow: hidden;
      pointer-events: none;
    }
    .scene-forest {
      position: absolute;
      inset: -2%;
      background: url('/assets/forest_bg.jpg') center bottom / cover no-repeat;
      transform: translate3d(var(--px, 0px), var(--py, 0px), 0) scale(1.04);
      transition: transform 0.35s ease-out;
      will-change: transform;
    }
    .scene::after {
      content: '';
      position: absolute;
      inset: 0;
      background:
        radial-gradient(ellipse at 50% 38%, rgba(22, 38, 50, 0.40) 0%, rgba(22, 38, 50, 0.1) 62%),
        linear-gradient(180deg, rgba(20, 32, 40, 0.5) 0%, rgba(20, 32, 40, 0.2) 35%, rgba(6, 22, 16, 0.55) 100%);
    }
    .mist {
      position: absolute;
      left: -30%;
      width: 160%;
      height: 38%;
      background:
        radial-gradient(ellipse 30% 55% at 20% 50%, rgba(214, 226, 234, 0.30), transparent 70%),
        radial-gradient(ellipse 28% 50% at 55% 55%, rgba(214, 226, 234, 0.24), transparent 70%),
        radial-gradient(ellipse 32% 55% at 85% 45%, rgba(214, 226, 234, 0.28), transparent 70%);
      filter: blur(22px);
      opacity: 0.8;
      pointer-events: none;
    }
    .mist-1 { bottom: 22%; animation: drift 46s linear infinite alternate; }
    .mist-2 { bottom: 8%;  animation: drift 64s linear infinite alternate-reverse; opacity: 0.6; }
    @keyframes drift {
      from { transform: translateX(-6%); }
      to   { transform: translateX(6%); }
    }
    .fireflies { position: absolute; inset: 0; pointer-events: none; }
    .firefly {
      position: absolute;
      bottom: 6%;
      width: 4px;
      height: 4px;
      border-radius: 50%;
      background: #bbf7d0;
      box-shadow: 0 0 10px 3px rgba(134, 239, 172, 0.7);
      opacity: 0;
      animation: float-up linear infinite;
    }
    @keyframes float-up {
      0%   { transform: translate(0, 0); opacity: 0; }
      15%  { opacity: 0.9; }
      85%  { opacity: 0.7; }
      100% { transform: translate(var(--dx, 30px), -55vh); opacity: 0; }
    }

    .app-container {
      position: relative;
      z-index: 5;
      padding-top: 110px;
      padding-bottom: 70px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      max-width: 1200px;
      margin: 0 auto;
    }
    .key-header {
      text-align: center;
      margin-bottom: 34px;
    }
    .hero-pill {
      display: inline-flex !important;
      align-items: center !important;
      gap: 8px !important;
      font-size: 0.78rem !important;
      font-weight: 700 !important;
      letter-spacing: 0.16em !important;
      text-transform: uppercase !important;
      color: #d1fae5 !important;
      padding: 7px 18px !important;
      background: rgba(10, 40, 28, 0.45) !important;
      border: 1px solid rgba(134, 239, 172, 0.35) !important;
      border-radius: 999px !important;
      backdrop-filter: blur(10px) !important;
      margin-bottom: 16px !important;
    }
    .hero-pill svg {
      color: #4ade80 !important;
    }
    .key-header .hero-title {
      font-size: clamp(2.4rem, 6vw, 3.8rem) !important;
      font-weight: 900 !important;
      letter-spacing: -0.025em !important;
      line-height: 1.1 !important;
      color: #ffffff !important;
      text-shadow: 0 4px 24px rgba(8, 24, 34, 0.45) !important;
      margin-bottom: 12px !important;
    }
    .key-header .hero-subtitle {
      font-size: 1.05rem !important;
      color: rgba(236, 244, 240, 0.82) !important;
      text-shadow: 0 2px 12px rgba(8, 24, 34, 0.5) !important;
      max-width: 620px !important;
      margin: 0 auto !important;
      line-height: 1.6 !important;
    }

    /* Key Cards Grid */
    .key-cards-grid {
      display: grid !important;
      grid-template-columns: repeat(3, 1fr) !important;
      gap: 24px !important;
      width: 100% !important;
      max-width: 1100px !important;
      padding: 0 20px !important;
      align-items: stretch !important;
    }
    @media (max-width: 960px) {
      .key-cards-grid { grid-template-columns: 1fr !important; max-width: 440px !important; }
    }

    .key-card {
      position: relative !important;
      display: flex !important;
      flex-direction: column !important;
      padding: 34px 28px !important;
      background: rgba(14, 30, 26, 0.65) !important;
      border: 1px solid rgba(255, 255, 255, 0.16) !important;
      border-radius: 22px !important;
      backdrop-filter: blur(20px) saturate(140%) !important;
      -webkit-backdrop-filter: blur(20px) saturate(140%) !important;
      box-shadow: 0 16px 45px rgba(6, 18, 14, 0.5) !important;
      transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease !important;
      text-align: center !important;
    }
    .key-card:hover {
      transform: translateY(-5px) !important;
      border-color: rgba(74, 222, 128, 0.45) !important;
      box-shadow: 0 24px 60px rgba(6, 18, 14, 0.65) !important;
    }
    .key-card.featured {
      border: 1.5px solid #4ade80 !important;
      box-shadow: 0 0 35px rgba(34, 197, 94, 0.28), 0 16px 45px rgba(6, 18, 14, 0.5) !important;
    }
    .card-badge-recommended {
      background: linear-gradient(135deg, #34d399, #16a34a) !important;
      color: #ffffff !important;
      font-size: 0.7rem !important;
      font-weight: 800 !important;
      letter-spacing: 0.1em !important;
      text-transform: uppercase !important;
      padding: 4px 14px !important;
      border-radius: 999px !important;
      margin: -6px auto 14px auto !important;
      display: inline-block !important;
      box-shadow: 0 2px 10px rgba(34, 197, 94, 0.4) !important;
    }
    .card-icon-wrapper {
      display: flex !important;
      justify-content: center !important;
      align-items: center !important;
      margin-bottom: 16px !important;
    }
    .card-icon-svg {
      height: 48px !important;
      width: auto !important;
      filter: drop-shadow(0 4px 12px rgba(34, 197, 94, 0.4)) !important;
    }
    .card-title {
      font-size: 1.45rem !important;
      font-weight: 800 !important;
      color: #ffffff !important;
      margin-bottom: 8px !important;
      letter-spacing: -0.01em !important;
    }
    .card-tagline {
      font-size: 0.88rem !important;
      color: rgba(226, 238, 232, 0.75) !important;
      line-height: 1.5 !important;
      margin-bottom: 24px !important;
      min-height: 40px !important;
    }
    .card-features {
      list-style: none !important;
      display: flex !important;
      flex-direction: column !important;
      gap: 12px !important;
      margin-bottom: 30px !important;
      text-align: left !important;
      flex-grow: 1 !important;
    }
    .card-features li {
      display: flex !important;
      align-items: center !important;
      gap: 10px !important;
      font-size: 0.92rem !important;
      color: #e2eee8 !important;
    }
    .card-features li .feature-arrow {
      color: #4ade80 !important;
      font-weight: 800 !important;
    }

    /* MODERN BUTTONS - NO MORE ORANGE, NO MORE DULL GREY BOXES! */
    .btn-claim-key {
      width: 100% !important;
      padding: 14px 24px !important;
      border-radius: 14px !important;
      font-family: 'Outfit', 'Inter', system-ui, sans-serif !important;
      font-size: 1rem !important;
      font-weight: 700 !important;
      display: inline-flex !important;
      align-items: center !important;
      justify-content: center !important;
      gap: 8px !important;
      color: #ffffff !important;
      border: 1px solid rgba(255, 255, 255, 0.22) !important;
      background: rgba(255, 255, 255, 0.08) !important;
      backdrop-filter: blur(14px) !important;
      -webkit-backdrop-filter: blur(14px) !important;
      cursor: pointer !important;
      transition: all 0.2s cubic-bezier(0.2, 0, 0, 1) !important;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.25) !important;
      text-decoration: none !important;
    }
    .btn-claim-key:hover {
      transform: translateY(-2px) !important;
      background: rgba(255, 255, 255, 0.16) !important;
      border-color: rgba(74, 222, 128, 0.5) !important;
      box-shadow: 0 10px 28px rgba(0, 0, 0, 0.4) !important;
    }
    /* Featured 6h Card: Glowing Emerald Gradient */
    .key-card.featured .btn-claim-key {
      background: linear-gradient(135deg, #34d399 0%, #16a34a 100%) !important;
      border: 1px solid rgba(187, 247, 208, 0.5) !important;
      color: #ffffff !important;
      box-shadow: 0 8px 30px rgba(34, 197, 94, 0.45) !important;
      font-weight: 800 !important;
    }
    .key-card.featured .btn-claim-key:hover {
      background: linear-gradient(135deg, #4ade80 0%, #15a34a 100%) !important;
      box-shadow: 0 14px 40px rgba(34, 197, 94, 0.65) !important;
      transform: translateY(-2px) !important;
    }

    /* Completely hide old floating dock bar */
    .dock-wrapper, #smoothDock {
      display: none !important;
      visibility: hidden !important;
      opacity: 0 !important;
      pointer-events: none !important;
    }

    /* Clean Footer matching index.html */
    .foot {
      position: fixed;
      left: 0; right: 0; bottom: 14px;
      z-index: 6;
      text-align: center;
      font-size: 0.82rem;
      color: rgba(236, 244, 240, 0.72);
      text-shadow: 0 1px 8px rgba(0, 0, 0, 0.5);
    }
    .bg-ambient { display: none !important; }

    /* Entry animations */
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(16px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }
    @keyframes scaleIn {
      from { opacity: 0; transform: scale(0.92); }
      to   { opacity: 1; transform: scale(1); }
    }
    .anim-fadeslideup { animation: fadeSlideUp 0.5s cubic-bezier(0.22,1,0.36,1) both; }
    .anim-fadein      { animation: fadeIn 0.4s ease both; }
    .anim-scalein     { animation: scaleIn 0.45s cubic-bezier(0.22,1,0.36,1) both; }
    .anim-d1 { animation-delay: 0.04s; }
    .anim-d2 { animation-delay: 0.12s; }
    .anim-d3 { animation-delay: 0.20s; }
    .anim-d4 { animation-delay: 0.28s; }
    .anim-d5 { animation-delay: 0.36s; }
    .anim-d6 { animation-delay: 0.44s; }

    /* Premium page styles matching screenshot */
    .premium-page { width: 100%; max-width: 920px; margin: 0 auto; padding: 20px 20px 80px; }
    .premium-hero-label {
      font-size: 0.76rem;
      font-weight: 800;
      letter-spacing: 0.18em;
      text-transform: uppercase;
      color: #10b981;
      margin-bottom: 12px;
      display: block;
    }
    .premium-hero-title {
      font-size: clamp(2.2rem, 5vw, 3.4rem);
      font-weight: 900;
      color: #fff;
      line-height: 1.1;
      margin-bottom: 12px;
      letter-spacing: -0.02em;
    }
    .premium-hero-sub {
      font-size: 1.05rem;
      color: #94a3b8;
      margin-bottom: 44px;
    }
    .premium-cards-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
      align-items: stretch;
    }
    @media (max-width: 720px) { .premium-cards-row { grid-template-columns: 1fr; } }
    .pricing-card {
      background: #0d0f17;
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 18px;
      padding: 34px 30px;
      position: relative;
      display: flex;
      flex-direction: column;
      transition: transform 0.2s, border-color 0.2s;
    }
    .pricing-card:hover { transform: translateY(-2px); }
    .pricing-card.featured {
      border: 1.5px solid #10b981;
      box-shadow: 0 0 35px rgba(16, 185, 129, 0.22);
    }
    .pricing-card.featured::before {
      content: 'MOST POPULAR';
      position: absolute;
      top: -13px;
      left: 50%;
      transform: translateX(-50%);
      background: #10b981;
      color: #ffffff;
      font-size: 0.68rem;
      font-weight: 900;
      letter-spacing: 0.12em;
      padding: 4px 14px;
      border-radius: 50px;
      box-shadow: 0 2px 10px rgba(16, 185, 129, 0.5);
    }
    .pricing-tier-label {
      font-size: 0.74rem;
      font-weight: 800;
      letter-spacing: 0.16em;
      text-transform: uppercase;
      color: #64748b;
      margin-bottom: 8px;
      display: block;
    }
    .pricing-price {
      font-size: 3.2rem;
      font-weight: 900;
      color: #fff;
      line-height: 1;
      margin-bottom: 4px;
      letter-spacing: -0.03em;
    }
    .pricing-period {
      font-size: 0.85rem;
      color: #64748b;
      margin-bottom: 28px;
    }
    .pricing-features {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-bottom: 32px;
      flex-grow: 1;
    }
    .pricing-features li {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 0.92rem;
      color: #cbd5e1;
    }
    .pricing-features li svg { color: #10b981; flex-shrink: 0; }
    .btn-pricing-free {
      width: 100%;
      padding: 14px;
      border-radius: 12px;
      border: 1px solid rgba(255, 255, 255, 0.12);
      background: rgba(255, 255, 255, 0.04);
      color: #fff;
      font-size: 0.92rem;
      font-weight: 700;
      font-family: var(--font-main);
      cursor: pointer;
      transition: background 0.2s, border-color 0.2s;
    }
    .btn-pricing-free:hover { background: rgba(255,255,255,0.08); border-color: rgba(255,255,255,0.25); }
    .btn-pricing-free:disabled {
      opacity: 0.6;
      cursor: default;
      pointer-events: none;
      background: rgba(255, 255, 255, 0.03);
      border-color: rgba(255, 255, 255, 0.1);
    }
    .btn-pricing-premium {
      width: 100%;
      padding: 14px;
      border-radius: 12px;
      border: none;
      background: linear-gradient(135deg, #10b981, #059669);
      color: #ffffff;
      font-size: 0.96rem;
      font-weight: 800;
      font-family: var(--font-main);
      cursor: pointer;
      transition: filter 0.2s, transform 0.15s, box-shadow 0.2s;
      box-shadow: 0 4px 20px rgba(16, 185, 129, 0.4);
    }
    .btn-pricing-premium:hover { filter: brightness(1.1); transform: translateY(-1px); box-shadow: 0 6px 25px rgba(16, 185, 129, 0.55); }

    /* 3 in a Row Games Grid Layout matching user screenshot */
    /* ========================================================================= */
    /* SUPPORTED GAMES UI (Matches Exact Modern Grid & Tile Screenshot)          */
    /* ========================================================================= */
    .supported-games-header {
      text-align: center;
      margin-top: 15px;
      margin-bottom: 22px;
    }
    .supported-games-main-title {
      font-size: 2.1rem;
      font-weight: 800;
      color: #ffffff;
      letter-spacing: -0.02em;
      margin: 0;
      text-shadow: 0 4px 18px rgba(0, 0, 0, 0.4);
    }
    .supported-games-toolbar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      max-width: 100%;
      margin: 0 auto 24px;
      flex-wrap: wrap;
    }
    .supported-search-box {
      flex: 1;
      min-width: 260px;
      position: relative;
      display: flex;
      align-items: center;
    }
    .supported-search-box .search-icon {
      position: absolute;
      left: 14px;
      color: #64748b;
      pointer-events: none;
    }
    .supported-search-input {
      width: 100%;
      background: #0f131a;
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 12px;
      padding: 12px 16px 12px 42px;
      color: #ffffff;
      font-size: 0.92rem;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
    }
    .supported-search-input:focus {
      border-color: rgba(59, 130, 246, 0.5);
      background: #121722;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
    }
    .supported-search-input::placeholder {
      color: #64748b;
    }
    .supported-filter-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .supported-filter-btn {
      background: rgba(255, 255, 255, 0.04);
      border: 1px solid rgba(255, 255, 255, 0.08);
      color: #94a3b8;
      border-radius: 20px;
      padding: 8px 18px;
      font-size: 0.85rem;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .supported-filter-btn:hover {
      background: rgba(255, 255, 255, 0.08);
      color: #ffffff;
      border-color: rgba(255, 255, 255, 0.18);
    }
    .supported-filter-btn.active {
      background: #1e293b;
      color: #ffffff;
      border-color: #3b82f6;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
    }
    .supported-filter-btn.btn-fetch {
      background: rgba(255, 255, 255, 0.05);
      color: #94a3b8;
    }
    .supported-filter-btn.btn-fetch:hover {
      color: #38bdf8;
      border-color: rgba(56, 189, 248, 0.4);
    }

    /* Grid Layout: 5 games in a row (compact & sleek) */
    .games-cards-grid {
      display: grid;
      grid-template-columns: repeat(5, minmax(0, 1fr));
      gap: 14px;
      width: 100%;
    }
    @media (max-width: 1240px) {
      .games-cards-grid {
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 12px;
      }
    }
    @media (max-width: 960px) {
      .games-cards-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
      }
    }
    @media (max-width: 680px) {
      .games-cards-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 10px;
      }
    }
    @media (max-width: 400px) {
      .games-cards-grid {
        grid-template-columns: 1fr;
        gap: 10px;
      }
    }

    /* Individual Game Tile (Compact 5-in-a-row) */
    .supported-game-card {
      position: relative;
      aspect-ratio: 1 / 1.05;
      border-radius: 14px;
      overflow: hidden;
      background: #0d1117;
      border: 1px solid rgba(255, 255, 255, 0.07);
      box-shadow: 0 6px 18px rgba(0, 0, 0, 0.4);
      cursor: pointer;
      transition: transform 0.25s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.25s, border-color 0.25s;
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
    }
    .supported-game-card:hover {
      transform: translateY(-5px) scale(1.02);
      border-color: rgba(255, 255, 255, 0.22);
      box-shadow: 0 16px 36px rgba(0, 0, 0, 0.65), 0 0 25px rgba(59, 130, 246, 0.15);
    }
    .game-cover-bg-wrap {
      position: absolute;
      inset: 0;
      width: 100%;
      height: 100%;
      z-index: 1;
      overflow: hidden;
    }
    .game-cover-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
      transition: transform 0.35s ease;
    }
    .supported-game-card:hover .game-cover-img {
      transform: scale(1.06);
    }
    .game-cover-gradient-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.12) 35%, rgba(10,12,18,0.78) 72%, rgba(10,12,18,0.96) 100%);
      pointer-events: none;
    }

    /* Badge on top-left of tile */
    .game-tile-badge {
      position: absolute;
      top: 12px;
      left: 12px;
      z-index: 3;
      padding: 3px 8px;
      border-radius: 8px;
      font-size: 0.68rem;
      font-weight: 800;
      letter-spacing: 0.04em;
      text-transform: uppercase;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
      backdrop-filter: blur(6px);
      pointer-events: none;
    }
    .game-tile-badge.fixed {
      background: #1d4ed8;
      color: #ffffff;
      border: 1px solid rgba(96, 165, 250, 0.4);
    }
    .game-tile-badge.unlock-all {
      background: #b45309;
      color: #ffffff;
      border: 1px solid rgba(251, 191, 36, 0.4);
    }
    .game-tile-badge.multiplier {
      background: #047857;
      color: #ffffff;
      border: 1px solid rgba(52, 211, 153, 0.4);
    }
    .game-tile-badge.generic {
      background: rgba(30, 41, 59, 0.85);
      color: #e2e8f0;
      border: 1px solid rgba(255, 255, 255, 0.15);
    }

    /* Bottom Info on tile */
    .game-card-bottom-info {
      position: relative;
      z-index: 3;
      padding: 14px 14px 12px;
      display: flex;
      flex-direction: column;
      gap: 3px;
    }
    .game-card-title {
      font-size: 1.02rem;
      font-weight: 800;
      color: #ffffff;
      margin: 0;
      line-height: 1.25;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.9);
    }
    .game-card-players-row {
      display: flex;
      align-items: center;
      gap: 5px;
      font-size: 0.78rem;
      font-weight: 600;
      color: #94a3b8;
    }
    .game-card-players-row .player-icon {
      color: #94a3b8;
      flex-shrink: 0;
    }
    .game-card-action-wrap {
      margin-top: 6px;
    }
    .btn-open-script {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 4px;
      padding: 5px 14px;
      border-radius: 20px;
      background: rgba(59, 130, 246, 0.22);
      border: 1px solid rgba(147, 197, 253, 0.32);
      color: #bfdbfe;
      font-size: 0.78rem;
      font-weight: 700;
      backdrop-filter: blur(8px);
      cursor: pointer;
      transition: all 0.2s ease;
    }
    .btn-open-script:hover {
      background: rgba(59, 130, 246, 0.45);
      color: #ffffff;
      border-color: rgba(147, 197, 253, 0.65);
      box-shadow: 0 2px 10px rgba(59, 130, 246, 0.3);
    }

    /* Empty state */
    .games-empty-state {
      grid-column: 1 / -1;
      text-align: center;
      padding: 80px 20px;
      color: #64748b;
    }
    .games-empty-state .empty-icon-wrap {
      width: 72px;
      height: 72px;
      border-radius: 20px;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.08);
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 16px;
      color: #475569;
    }
    .games-empty-state h3 {
      font-size: 1.15rem;
      font-weight: 700;
      color: #e2e8f0;
      margin-bottom: 6px;
    }
    .games-empty-state p {
      font-size: 0.88rem;
      color: #64748b;
      max-width: 420px;
      margin: 0 auto;
    }

    /* TUFFES EXECUTE LOADSTRING FENSTER (MODAL) */
    .execute-modal-box {
      background: #090c16;
      border: 1.5px solid rgba(16, 185, 129, 0.4);
      border-radius: 22px;
      padding: 28px 28px 24px;
      max-width: 600px;
      width: 100%;
      box-shadow: 0 0 50px rgba(16, 185, 129, 0.22), 0 25px 60px rgba(0, 0, 0, 0.85);
      position: relative;
      animation: scaleIn 0.35s cubic-bezier(0.16, 1, 0.3, 1) forwards;
      display: flex;
      flex-direction: column;
      gap: 18px;
    }
    .execute-modal-header {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    .execute-header-icon {
      width: 48px;
      height: 48px;
      border-radius: 14px;
      background: rgba(16, 185, 129, 0.15);
      border: 1px solid rgba(16, 185, 129, 0.35);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #10b981;
      flex-shrink: 0;
      box-shadow: 0 0 16px rgba(16, 185, 129, 0.25);
    }
    .execute-header-info {
      flex: 1;
      min-width: 0;
    }
    .execute-header-top {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 4px;
    }
    .execute-game-tag {
      font-size: 0.78rem;
      color: #94a3b8;
      font-weight: 600;
    }
    .execute-status-pill {
      font-size: 0.68rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      background: rgba(16, 185, 129, 0.12);
      color: #34d399;
      border: 1px solid rgba(16, 185, 129, 0.3);
      padding: 2px 8px;
      border-radius: 20px;
    }
    .execute-modal-title {
      font-size: 1.25rem;
      font-weight: 800;
      color: #ffffff;
      line-height: 1.2;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .execute-terminal-wrapper {
      background: #04060c;
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 14px;
      overflow: hidden;
    }
    .execute-terminal-bar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 14px;
      background: rgba(255, 255, 255, 0.03);
      border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }
    .terminal-dots {
      display: flex;
      gap: 6px;
    }
    .terminal-dots .dot {
      width: 10px;
      height: 10px;
      border-radius: 50%;
    }
    .dot-red { background: #ef4444; }
    .dot-yellow { background: #f59e0b; }
    .dot-green { background: #10b981; }
    .terminal-title {
      font-size: 0.74rem;
      color: #94a3b8;
      font-weight: 600;
      font-family: monospace;
    }
    .terminal-badge {
      font-size: 0.68rem;
      font-weight: 700;
      color: #38bdf8;
      background: rgba(56, 189, 248, 0.1);
      border: 1px solid rgba(56, 189, 248, 0.25);
      padding: 2px 8px;
      border-radius: 6px;
    }
    .execute-code-area {
      display: flex;
      align-items: flex-start;
      gap: 12px;
      padding: 16px;
      max-height: 160px;
      overflow-y: auto;
    }
    .code-line-prompt {
      color: #10b981;
      font-family: monospace;
      font-weight: 800;
      user-select: none;
    }
    .execute-code-content {
      font-family: monospace;
      font-size: 0.85rem;
      color: #38bdf8;
      margin: 0;
      white-space: pre-wrap;
      word-break: break-all;
      line-height: 1.5;
    }
    .execute-actions-row {
      display: flex;
      gap: 12px;
    }
    .btn-execute-copy {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      padding: 13px 20px;
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      border: none;
      border-radius: 12px;
      color: #ffffff;
      font-weight: 800;
      font-size: 0.95rem;
      cursor: pointer;
      transition: all 0.2s cubic-bezier(0.2, 0, 0, 1);
      box-shadow: 0 4px 20px rgba(16, 185, 129, 0.4);
    }
    .btn-execute-copy:hover {
      filter: brightness(1.12);
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(16, 185, 129, 0.55);
    }
    .btn-execute-copy:active {
      transform: scale(0.98);
    }
    .btn-execute-raw {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 13px 18px;
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 12px;
      color: #cbd5e1;
      font-size: 0.88rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-execute-raw:hover {
      background: rgba(255, 255, 255, 0.1);
      color: #fff;
      border-color: rgba(255, 255, 255, 0.25);
    }
    .executor-support-section {
      display: flex;
      flex-direction: column;
      gap: 8px;
      padding-top: 4px;
      border-top: 1px solid rgba(255, 255, 255, 0.06);
    }
    .executor-support-label {
      font-size: 0.72rem;
      font-weight: 700;
      color: #64748b;
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }
    .executor-badges-list {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
    }
    .exec-pill {
      font-size: 0.72rem;
      font-weight: 600;
      padding: 3px 9px;
      border-radius: 6px;
      background: rgba(255, 255, 255, 0.04);
      border: 1px solid rgba(255, 255, 255, 0.08);
      color: #94a3b8;
    }

    .game-script-card {
      background: #11141d;
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 14px;
      overflow: hidden;
      cursor: pointer;
      transition: transform 0.22s cubic-bezier(0.2, 0, 0, 1), border-color 0.22s, box-shadow 0.22s;
      display: flex;
      flex-direction: column;
      position: relative;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.35);
      animation: fadeSlideUp 0.5s cubic-bezier(0.22,1,0.36,1) both;
    }
    .game-script-card:hover {
      transform: translateY(-4px);
      border-color: rgba(255, 255, 255, 0.22);
      box-shadow: 0 14px 35px rgba(0, 0, 0, 0.55);
    }

    .game-card-thumb-wrap {
      position: relative;
      width: 100%;
      aspect-ratio: 16 / 9;
      background: #090b12;
      overflow: hidden;
    }
    .game-card-thumb-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
      transition: transform 0.35s ease;
    }
    .game-script-card:hover .game-card-thumb-img {
      transform: scale(1.04);
    }
    .game-card-thumb-placeholder {
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, #0e111d 0%, #131726 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--text-muted);
    }

    /* Badges pinned top-left on thumbnail */
    .game-card-badges {
      position: absolute;
      top: 10px;
      left: 10px;
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      z-index: 2;
      pointer-events: none;
    }
    .badge-pill-key {
      background: #b45309;
      color: #ffffff;
      font-size: 0.72rem;
      font-weight: 700;
      padding: 3px 8px;
      border-radius: 6px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.5);
      letter-spacing: 0.02em;
    }
    .badge-pill-mobile {
      background: #4d7c0f;
      color: #ffffff;
      font-size: 0.72rem;
      font-weight: 700;
      padding: 3px 8px;
      border-radius: 6px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.5);
      letter-spacing: 0.02em;
    }
    .badge-pill-custom {
      background: rgba(30, 41, 59, 0.85);
      color: #cbd5e1;
      font-size: 0.72rem;
      font-weight: 600;
      padding: 3px 8px;
      border-radius: 6px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.5);
      backdrop-filter: blur(4px);
      border: 1px solid rgba(255,255,255,0.1);
    }

    .game-card-main-body {
      padding: 14px 16px 16px;
      display: flex;
      flex-direction: column;
      flex: 1;
    }

    /* Row 1: Game name + views/favorites stats */
    .game-card-header-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      margin-bottom: 8px;
    }
    .game-card-game-title {
      font-size: 0.84rem;
      color: #94a3b8;
      font-weight: 500;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      flex: 1;
    }
    .game-card-stats {
      display: flex;
      align-items: center;
      gap: 10px;
      color: #94a3b8;
      font-size: 0.82rem;
      flex-shrink: 0;
    }
    .game-card-stat-item {
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }

    /* Row 2: Script Title */
    .game-card-script-title {
      font-size: 0.95rem;
      font-weight: 700;
      color: #ffffff;
      line-height: 1.35;
      margin-bottom: 6px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      min-height: 2.6em;
    }

    /* Row 3: Uploaded time ago */
    .game-card-time-ago {
      font-size: 0.78rem;
      color: #64748b;
      font-weight: 500;
      margin-bottom: 14px;
    }

    /* Row 4: Action Buttons */
    .game-card-actions {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-top: auto;
    }
    .btn-game-action-execute {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 7px 15px;
      background: rgba(255, 255, 255, 0.04);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 8px;
      color: #ffffff;
      font-size: 0.82rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      user-select: none;
    }
    .btn-game-action-execute:hover {
      background: rgba(16, 185, 129, 0.18);
      border-color: rgba(16, 185, 129, 0.45);
      color: #34d399;
      transform: translateY(-1px);
    }
    .btn-game-action-favorite {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 7px 14px;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 8px;
      color: #94a3b8;
      font-size: 0.82rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.2s;
      user-select: none;
    }
    .btn-game-action-favorite:hover {
      background: rgba(255, 255, 255, 0.06);
      color: #cbd5e1;
    }
    .btn-game-action-copy {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 34px;
      height: 34px;
      background: rgba(255, 255, 255, 0.04);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 8px;
      color: #94a3b8;
      cursor: pointer;
      margin-left: auto;
      transition: all 0.2s;
    }
    .btn-game-action-copy:hover {
      background: rgba(255, 255, 255, 0.12);
      border-color: rgba(255, 255, 255, 0.25);
      color: #ffffff;
      transform: translateY(-1px);
    }

    /* Game Detail Modal */
    .game-detail-modal {
      position: fixed;
      inset: 0;
      z-index: 1000;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
      background: rgba(0,0,0,0.7);
      backdrop-filter: blur(8px);
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.3s ease;
    }
    .game-detail-modal.active {
      opacity: 1;
      pointer-events: all;
    }
    .game-detail-box {
      background: #0d1020;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 20px;
      width: 100%;
      max-width: 820px;
      max-height: 90vh;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      transform: scale(0.92);
      transition: transform 0.3s cubic-bezier(0.22,1,0.36,1);
      box-shadow: 0 30px 80px rgba(0,0,0,0.6);
    }
    .game-detail-modal.active .game-detail-box {
      transform: scale(1);
    }
    .game-detail-inner {
      display: flex;
      flex-direction: row;
      gap: 0;
      overflow: hidden;
      flex: 1;
      min-height: 0;
    }
    @media (max-width: 640px) {
      .game-detail-inner { flex-direction: column; }
      .game-detail-img-col { width: 100% !important; height: 200px; min-height: 0; }
    }
    .game-detail-img-col {
      width: 300px;
      flex-shrink: 0;
      background: #08090f;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
    }
    .game-detail-img-col img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }
    .game-detail-img-placeholder {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 10px;
      color: rgba(255,255,255,0.2);
      width: 100%;
      height: 100%;
    }
    .game-detail-content {
      flex: 1;
      padding: 28px 28px 24px;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .game-detail-content::-webkit-scrollbar { width: 4px; }
    .game-detail-content::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }
    .game-detail-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 12px;
    }
    .game-detail-title {
      font-size: 1.45rem;
      font-weight: 800;
      color: #fff;
      line-height: 1.2;
      margin: 0;
    }
    .game-detail-close {
      background: rgba(255,255,255,0.06);
      border: 1px solid rgba(255,255,255,0.1);
      color: #94a3b8;
      border-radius: 8px;
      width: 32px;
      height: 32px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      font-size: 1.3rem;
      flex-shrink: 0;
      transition: background 0.2s, color 0.2s;
    }
    .game-detail-close:hover { background: rgba(255,255,255,0.12); color: #fff; }
    .game-detail-meta {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .game-meta-row {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 0.85rem;
      color: #94a3b8;
    }
    .game-meta-row strong { color: #cbd5e1; }
    .game-detail-desc {
      font-size: 0.9rem;
      color: #94a3b8;
      line-height: 1.6;
      background: rgba(255,255,255,0.03);
      border: 1px solid rgba(255,255,255,0.06);
      border-radius: 10px;
      padding: 12px 14px;
    }
    .game-detail-loadstring-wrap {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .game-detail-loadstring-label {
      font-size: 0.76rem;
      font-weight: 700;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: #10b981;
    }
    .game-detail-loadstring-box {
      background: #060810;
      border: 1px solid rgba(16,185,129,0.25);
      border-radius: 10px;
      padding: 12px 14px;
      font-family: 'Courier New', monospace;
      font-size: 0.8rem;
      color: #a5f3d0;
      word-break: break-all;
      line-height: 1.5;
      position: relative;
    }
    .game-detail-copy-btn {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 9px 16px;
      border-radius: 10px;
      border: none;
      background: linear-gradient(135deg, #10b981, #059669);
      color: #fff;
      font-size: 0.84rem;
      font-weight: 700;
      cursor: pointer;
      transition: filter 0.2s, transform 0.15s;
      align-self: flex-start;
    }
    .game-detail-copy-btn:hover { filter: brightness(1.1); transform: translateY(-1px); }
    .game-detail-locked {
      background: rgba(239,68,68,0.07);
      border: 1px solid rgba(239,68,68,0.2);
      border-radius: 10px;
      padding: 14px 16px;
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .game-detail-locked-title {
      font-size: 0.88rem;
      font-weight: 700;
      color: #f87171;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .game-detail-locked-sub {
      font-size: 0.8rem;
      color: #94a3b8;
    }
    .game-detail-status-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 0.73rem;
      font-weight: 700;
      padding: 4px 10px;
      border-radius: 20px;
      align-self: flex-start;
    }
  </style>
</head>
<body>

  <!-- Pine Forest Background Scene -->
  <div class="scene" aria-hidden="true">
    <div class="scene-forest" id="sceneForest"></div>
    <div class="mist mist-1"></div>
    <div class="mist mist-2"></div>
    <div class="fireflies" id="fireflies"></div>
  </div>

  <script>
    (function () {
      // Fireflies drifting up from the forest
      var box = document.getElementById('fireflies');
      if (box) {
        for (var i = 0; i < 22; i++) {
          var f = document.createElement('span');
          f.className = 'firefly';
          f.style.left = (Math.random() * 100) + '%';
          f.style.bottom = (Math.random() * 14 + 2) + '%';
          var s = (Math.random() * 2.5 + 2.5);
          f.style.width = s + 'px';
          f.style.height = s + 'px';
          var dur = (Math.random() * 10 + 12) + 's';
          var del = -(Math.random() * 18) + 's';
          f.style.animationDuration = dur;
          f.style.animationDelay = del;
          f.style.setProperty('--dx', ((Math.random() - 0.5) * 120) + 'px');
          box.appendChild(f);
        }
      }
      // Parallax on mouse
      var forest = document.getElementById('sceneForest');
      if (forest && window.matchMedia('(pointer: fine)').matches) {
        window.addEventListener('mousemove', function (e) {
          var cx = (e.clientX / window.innerWidth - 0.5) * -18;
          var cy = (e.clientY / window.innerHeight - 0.5) * -10;
          forest.style.setProperty('--px', cx.toFixed(1) + 'px');
          forest.style.setProperty('--py', cy.toFixed(1) + 'px');
        }, { passive: true });
      }
    })();
  </script>

  <!-- Main Content Wrapper -->
  <div class="app-container">

    <!-- Navigation -->
    <header class="nav" id="mainNav">
      <a href="/" class="nav-brand" id="navBrand">
        <img src="/assets/logo_transparent.png" alt="XYZ Scripts logo">
        <span>XYZ Scripts</span>
      </a>
      <nav class="nav-links" aria-label="Main navigation">
        <a href="/" class="nav-link" id="nav-home">Home</a>
        <a href="/key" class="nav-link active" id="nav-key">Get Key</a>
        <a href="/premium" class="nav-link" id="nav-premium">Premium</a>
        <a href="/dashboard" class="nav-link cta" id="nav-dashboard">Dashboard</a>
      </nav>
    </header>

    <!-- ===================================================================== -->
    <!-- VIEW 3: KEY SYSTEM VIEW (/key) - DIRECT & SMOOTH GENERATION           -->
    <!-- ===================================================================== -->
    <section class="page-view active" id="view-key">
      <div class="key-header">
        <h1 class="hero-title">Key System Portal</h1>
        <p class="hero-subtitle">Select your desired session duration below and generate your key with Luarmor hardware protection.</p>
      </div>

      <!-- Luarmor Hardware Device Identified Banner (active when URL has ?hwid=...) -->
      <div id="luarmorHwidBanner" style="display: none; max-width: 900px; margin: 0 auto 24px; padding: 14px 18px; background: rgba(16, 185, 129, 0.08); border: 1px solid rgba(16, 185, 129, 0.28); border-radius: 12px; align-items: center; justify-content: space-between; gap: 12px; animation: fadeSlideUp 0.3s ease;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="width: 10px; height: 10px; background: #10b981; border-radius: 50%; box-shadow: 0 0 10px #10b981; flex-shrink: 0;"></div>
          <div>
            <div style="font-size: 0.88rem; font-weight: 700; color: #fff;">Luarmor Hardware Device (HWID) Identified</div>
            <div style="font-size: 0.78rem; color: #a7f3d0; font-family: monospace;" id="luarmorDetectedHwidText">HWID: ...</div>
          </div>
        </div>
        <span style="font-size: 0.75rem; background: rgba(16, 185, 129, 0.2); color: #34d399; padding: 4px 12px; border-radius: 20px; font-weight: 700; white-space: nowrap; border: 1px solid rgba(16, 185, 129, 0.3);">🔒 Device Locked Key</span>
      </div>

      <!-- 3 Key Duration Cards Grid -->
      <div id="freeKeysContainer" class="key-cards-grid">
        <!-- Card 1: 2 Hour Key -->
        <article class="key-card" data-tier="2h" id="card-2h">
          <div class="card-ambient-glow"></div>
          <div class="card-icon-wrapper">
            <img src="/assets/logo.svg" alt="2 Hour Key" class="card-icon-svg">
          </div>
          <h2 class="card-title">2 Hour Key</h2>
          <p class="card-tagline">Quick session key with instant generation and immediate activation</p>
          
          <ul class="card-features">
            <li><span class="feature-arrow">&rarr;</span> Instant Generation</li>
            <li><span class="feature-arrow">&rarr;</span> Anti-HWID Spoof Protection</li>
            <li><span class="feature-arrow">&rarr;</span> Universal Executor Support</li>
          </ul>

          <button class="btn-claim-key" data-tier="2h" id="btn-claim-2h">
            <span>Claim Key</span>
            <svg class="btn-icon-ext" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
              <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
              <polyline points="15 3 21 3 21 9"></polyline>
              <line x1="10" y1="14" x2="21" y2="3"></line>
            </svg>
          </button>
        </article>

        <!-- Card 2: 6 Hour Key (Recommended) -->
        <article class="key-card featured" data-tier="6h" id="card-6h">
          <div class="card-ambient-glow"></div>
          <div class="card-icon-wrapper">
            <img src="/assets/logo.svg" alt="6 Hour Key" class="card-icon-svg">
          </div>
          <h2 class="card-title">6 Hour Key</h2>
          <span class="card-badge-recommended">Recommended</span>
          <p class="card-tagline">Optimal playtime duration for smooth, uninterrupted gaming sessions</p>
          
          <ul class="card-features">
            <li><span class="feature-arrow">&rarr;</span> Full 6 Hours Access</li>
            <li><span class="feature-arrow">&rarr;</span> Fast Multi-Server Sync</li>
            <li><span class="feature-arrow">&rarr;</span> Zero Downtime Cloud Infrastructure</li>
          </ul>

          <button class="btn-claim-key" data-tier="6h" id="btn-claim-6h">
            <span>Claim Key</span>
            <svg class="btn-icon-ext" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
              <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
              <polyline points="15 3 21 3 21 9"></polyline>
              <line x1="10" y1="14" x2="21" y2="3"></line>
            </svg>
          </button>
        </article>

        <!-- Card 3: 10 Hour Key -->
        <article class="key-card" data-tier="10h" id="card-10h">
          <div class="card-ambient-glow"></div>
          <div class="card-icon-wrapper">
            <img src="/assets/logo.svg" alt="10 Hour Key" class="card-icon-svg">
          </div>
          <h2 class="card-title">10 Hour Key</h2>
          <p class="card-tagline">Maximum uninterrupted access for extended sessions without re-keying</p>
          
          <ul class="card-features">
            <li><span class="feature-arrow">&rarr;</span> Longest 10h Duration</li>
            <li><span class="feature-arrow">&rarr;</span> High Priority Server Routing</li>
            <li><span class="feature-arrow">&rarr;</span> 1-Click Auto Copy & Loadstring</li>
          </ul>

          <button class="btn-claim-key" data-tier="10h" id="btn-claim-10h">
            <span>Claim Key</span>
            <svg class="btn-icon-ext" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
              <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
              <polyline points="15 3 21 3 21 9"></polyline>
              <line x1="10" y1="14" x2="21" y2="3"></line>
            </svg>
          </button>
        </article>
      </div>

      <!-- Need Help Trigger directly under Get Key cards -->
      <div class="getkey-help-container">
        <div class="getkey-help-card">
          <div class="getkey-help-left">
            <div class="getkey-help-icon-wrap">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
                <line x1="12" y1="17" x2="12.01" y2="17"></line>
              </svg>
            </div>
            <div class="getkey-help-text">
              <span class="getkey-help-title">Need Help?</span>
              <span class="getkey-help-sub">Problems getting your key, executor issues or questions? Open a ticket in our Discord!</span>
            </div>
          </div>
          <button type="button" class="btn-getkey-help" id="btnOpenDiscordHelpModal">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
              <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
            </svg>
            <span>Need Help</span>
          </button>
        </div>
      </div>
    </section>

    <!-- ===================================================================== -->
    <!-- VIEW: PREMIUM (/premium)                                               -->
    <!-- ===================================================================== -->
    <section class="page-view" id="view-premium">
      <div class="premium-page">
        <span class="premium-hero-label anim-fadeslideup anim-d1">Premium</span>
        <h1 class="premium-hero-title anim-fadeslideup anim-d2">upgrade your experience</h1>
        <p class="premium-hero-sub anim-fadeslideup anim-d3">Unlock exclusive scripts, priority support, and premium-only features.</p>

        <div class="premium-cards-row anim-fadeslideup anim-d4">
          <!-- Free Tier -->
          <div class="pricing-card">
            <span class="pricing-tier-label">Free</span>
            <div class="pricing-price">$0</div>
            <div class="pricing-period">forever free</div>
            <ul class="pricing-features">
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Basic scripts for all games</li>
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Auto-updates included</li>
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Community Discord access</li>
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Mobile support</li>
            </ul>
            <button class="btn-pricing-free" disabled>Owned</button>
          </div>

          <!-- Premium Tier -->
          <div class="pricing-card featured">
            <span class="pricing-tier-label">Premium</span>
            <div class="pricing-price">$3.00</div>
            <div class="pricing-period">one-time payment</div>
            <ul class="pricing-features">
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> No key system at all</li>
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Lifetime access forever</li>
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Early access to scripts</li>
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Priority support</li>
              <li><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> Exclusive Discord role</li>
            </ul>
            <button class="btn-pricing-premium" onclick="window.open('https://discord.gg/x7gd33fY8S','_blank')">get premium</button>
          </div>
        </div>
      </div>
    </section>
  </div>

  <!-- Modern Footer -->
  <footer class="foot">&copy; <span id="year"></span> XYZ Scripts</footer>

  <!-- ===================================================================== -->
  <!-- MODALS                                                                -->
  <!-- ===================================================================== -->

  <!-- Modal 1: Key Claim Result -->
  <div class="modal-overlay" id="claimModal">
    <div class="modal-box">
      <button class="modal-close-btn" id="closeClaimModal" aria-label="Close modal">&times;</button>
      
      <div class="modal-header">
        <div class="modal-header-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path>
          </svg>
        </div>
        <div>
          <h3 class="modal-title" id="claimModalTitle">Key Generated!</h3>
          <p class="modal-subtitle">Your secure key has been processed by the backend</p>
        </div>
      </div>

      <div class="key-result-container">
        <div class="key-code-row">
          <span class="key-code-text" id="claimedKeyCode">XYZ-XXXX-XXXX-XXXX</span>
          <button class="btn-copy-code" id="btnCopyClaimedKey">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
              <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
              <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
            </svg>
            <span>Copy Key</span>
          </button>
        </div>

        <div class="key-meta-grid">
          <div class="meta-item">
            <span class="meta-label">Duration</span>
            <span class="meta-value" id="claimedKeyTier">6 Hours</span>
          </div>
          <div class="meta-item">
            <span class="meta-label">Expires At</span>
            <span class="meta-value" id="claimedKeyExpiry">In 6 hours</span>
          </div>
        </div>
      </div>

      <!-- Roblox Executor Snippet -->
      <div class="roblox-box">
        <div class="roblox-box-header">
          <span class="roblox-box-title">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
            Roblox Executor Script Snippet
          </span>
          <button class="btn-copy-code" id="btnCopyRobloxSnippet" style="padding: 4px 10px; font-size: 0.75rem;">
            Copy Script
          </button>
        </div>
        <pre class="roblox-code-pre" id="robloxSnippetText">_G.XYZ_KEY = "XYZ-XXXX-XXXX-XXXX"</pre>
      </div>
    </div>
  </div>

  <!-- Modal 2: Key Verifier / Checker -->
  <div class="modal-overlay" id="verifyModal">
    <div class="modal-box">
      <button class="modal-close-btn" id="closeVerifyModal" aria-label="Close modal">&times;</button>
      
      <div class="modal-header">
        <div class="modal-header-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
        </div>
        <div>
          <h3 class="modal-title">Key Status Checker</h3>
          <p class="modal-subtitle">Verify remaining duration on any XYZ key</p>
        </div>
      </div>

      <div style="margin-bottom: 16px;">
        <input type="text" id="verifyInputKey" class="form-input" placeholder="Paste key code (e.g. XYZ-6H-...)" style="font-family: var(--font-mono); margin-bottom: 12px;">
        <button id="btnCheckKeyNow" class="btn-claim-key" style="background: var(--color-primary); color: #000; font-weight: 700;">
          Verify Key Status
        </button>
      </div>

      <div id="verifyResultArea" style="display: none;"></div>
    </div>
  </div>

  <!-- Modal 3: Script Upload (For Panel Users) -->
  <div class="modal-overlay" id="uploadScriptModal">
    <div class="modal-box">
      <button class="modal-close-btn" id="closeUploadModal" aria-label="Close modal">&times;</button>
      
      <div class="modal-header">
        <div class="modal-header-icon" style="background: rgba(139, 92, 246, 0.15); border-color: rgba(139, 92, 246, 0.35); color: #d8b4fe;">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
        </div>
        <div>
          <h3 class="modal-title">Upload Lua Script</h3>
          <p class="modal-subtitle">Publish a script to the public XYZ Scripts catalog</p>
        </div>
      </div>

      <!-- Auth Warning if not logged in -->
      <div id="uploadAuthWarning" style="display: none; background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); border-radius: 12px; padding: 14px; margin-bottom: 16px;">
        <p style="color: #f87171; font-size: 0.88rem; font-weight: 600; margin-bottom: 8px;">🔒 Panel Access Required</p>
        <p style="color: #cbd5e1; font-size: 0.82rem; margin-bottom: 12px;">Only authorized staff with the Discord webpanel role can publish scripts.</p>
        <a href="/api/auth/discord/login" class="btn-primary-cta" style="padding: 8px 16px; font-size: 0.85rem; width: 100%; justify-content: center;">Login via Discord</a>
      </div>

      <form id="uploadScriptForm">
        <div class="form-group">
          <label class="form-label" for="scriptNameInput">Script Name *</label>
          <input type="text" id="scriptNameInput" class="form-input" placeholder="e.g. Blox Fruits Auto Farm v4" required>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
          <div class="form-group">
            <label class="form-label" for="scriptGameInput">Game *</label>
            <input type="text" id="scriptGameInput" class="form-input" placeholder="e.g. Blox Fruits, Universal" required>
          </div>
          <div class="form-group">
            <label class="form-label" for="scriptVersionInput">Version</label>
            <input type="text" id="scriptVersionInput" class="form-input" placeholder="e.g. v2.1.0">
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="scriptLoadstringInput">Loadstring / Executable Code *</label>
          <textarea id="scriptLoadstringInput" class="form-textarea" placeholder="loadstring(game:HttpGet('...'))()" required></textarea>
        </div>

        <div class="form-group">
          <label class="form-label" for="scriptDescInput">Description</label>
          <input type="text" id="scriptDescInput" class="form-input" placeholder="Brief overview of features and capabilities">
        </div>

        <div class="form-group">
          <label class="form-label" for="scriptFeaturesInput">Feature Tags (comma separated)</label>
          <input type="text" id="scriptFeaturesInput" class="form-input" placeholder="e.g. ESP, Auto-Farm, No Recoil, God Mode">
        </div>

        <button type="submit" id="btnSubmitUploadScript" class="btn-claim-key" style="background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%); border: none; font-weight: 700; margin-top: 8px;">
          <span>Publish Script</span>
        </button>
      </form>
    </div>
  </div>

  <!-- Toast Notification Container -->
  <div class="toast-container" id="toastContainer"></div>

  <!-- Game Detail Modal -->
  <div class="game-detail-modal" id="gameDetailModal">
    <div class="game-detail-box">
      <div class="game-detail-inner">
        <!-- Left: Image & Badges -->
        <div class="game-detail-img-col" id="gameDetailImgCol">
          <div class="game-detail-img-placeholder" id="gameDetailImgPlaceholder">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2"><rect x="2" y="3" width="20" height="14" rx="2"></rect><polyline points="8 21 12 17 16 21"></polyline></svg>
            <span style="font-size:0.8rem;">No Image</span>
          </div>
          <img id="gameDetailImg" src="" alt="" style="display:none; width:100%; height:100%; object-fit:cover;">
          <div id="gameDetailBadges" class="game-card-badges" style="position: absolute; top: 12px; left: 12px;"></div>
        </div>
        <!-- Right: Info -->
        <div class="game-detail-content">
          <div class="game-detail-header">
            <div style="flex:1;">
              <div id="gameDetailGameName" style="font-size: 0.85rem; font-weight: 600; color: #94a3b8; margin-bottom: 4px;">Roblox Game</div>
              <h2 class="game-detail-title" id="gameDetailTitle">Script Title</h2>
              <div style="display: flex; align-items: center; gap: 10px; margin-top: 6px;">
                <span class="game-detail-status-badge" id="gameDetailStatusBadge">Active</span>
                <span id="gameDetailUploadTime" style="font-size: 0.78rem; color: #64748b;">5m ago</span>
                <span id="gameDetailStatsWrap" style="font-size: 0.78rem; color: #94a3b8; display: inline-flex; align-items: center; gap: 8px;"></span>
              </div>
            </div>
            <button class="game-detail-close" id="gameDetailClose" title="Close">&times;</button>
          </div>

          <div style="display: flex; flex-direction: column; gap: 6px;">
            <div style="font-size: 0.78rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.06em;">Description</div>
            <div class="game-detail-desc" id="gameDetailDesc" style="color: #cbd5e1; font-size: 0.88rem; line-height: 1.5; background: rgba(0,0,0,0.25); padding: 12px 14px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.06);">No description available.</div>
          </div>

          <!-- Loadstring section -->
          <div class="game-detail-loadstring-wrap" id="gameDetailLoadstringSection" style="display: flex; flex-direction: column; gap: 8px;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div class="game-detail-loadstring-label" style="font-size: 0.78rem; font-weight: 700; color: #38bdf8; text-transform: uppercase; letter-spacing: 0.06em; display: flex; align-items: center;">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor" style="margin-right:5px;"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
                Roblox Lua Loadstring
              </div>
            </div>
            <div class="game-detail-loadstring-box" id="gameDetailLoadstringCode" style="font-family: var(--font-mono); font-size: 0.8rem; background: #070911; padding: 12px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1); color: #38bdf8; overflow-x: auto; white-space: pre-wrap; word-break: break-all; max-height: 120px;"></div>
            
            <div style="display: flex; gap: 10px; margin-top: 4px;">
              <button class="btn-game-action-execute" id="gameDetailExecuteBtn" style="padding: 9px 18px; font-size: 0.88rem;">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
                Execute
              </button>
              <button class="game-detail-copy-btn" id="gameDetailCopyBtn" style="padding: 9px 18px; font-size: 0.88rem; background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.15); border-radius: 8px; color: #fff; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
                Copy Loadstring
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal: Tuffes Execute Loadstring Fenster -->
  <div class="modal-overlay" id="executeLoadstringModal">
    <div class="execute-modal-box">
      <button class="modal-close-btn" id="closeExecuteModal" aria-label="Close modal">&times;</button>
      
      <div class="execute-modal-header">
        <div class="execute-header-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
            <polygon points="5 3 19 12 5 21 5 3"></polygon>
          </svg>
        </div>
        <div class="execute-header-info">
          <div class="execute-header-top">
            <span class="execute-game-tag" id="execModalGameName">Roblox Game</span>
            <span class="execute-status-pill">Ready to Execute</span>
          </div>
          <h2 class="execute-modal-title" id="execModalScriptTitle">Script Title</h2>
        </div>
      </div>

      <!-- Terminal / Code Box -->
      <div class="execute-terminal-wrapper">
        <div class="execute-terminal-bar">
          <div class="terminal-dots">
            <span class="dot dot-red"></span>
            <span class="dot dot-yellow"></span>
            <span class="dot dot-green"></span>
          </div>
          <span class="terminal-title">Roblox Lua Executor Loadstring</span>
          <span class="terminal-badge">Universal</span>
        </div>

        <div class="execute-code-area">
          <div class="code-line-prompt">&gt;</div>
          <pre class="execute-code-content" id="execModalLoadstringCode">loadstring(game:HttpGet("..."))()</pre>
        </div>
      </div>

      <!-- Action Buttons Row -->
      <div class="execute-actions-row">
        <button class="btn-execute-copy" id="execModalCopyBtn">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
            <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
            <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
          </svg>
          <span id="execModalCopyText">Copy Loadstring</span>
        </button>
        <button class="btn-execute-raw" id="execModalRawBtn" title="Copy raw URL only">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path>
            <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path>
          </svg>
          <span>Copy URL</span>
        </button>
      </div>

      <!-- Executor Compatibility Badges -->
      <div class="executor-support-section">
        <span class="executor-support-label">Verified Compatible Executors:</span>
        <div class="executor-badges-list">
          <span class="exec-pill">Delta</span>
          <span class="exec-pill">Fluxus</span>
          <span class="exec-pill">Codex</span>
          <span class="exec-pill">Arceus X</span>
          <span class="exec-pill">Solara</span>
          <span class="exec-pill">Wave</span>
          <span class="exec-pill">Hydrogen</span>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal: Discord Profile & Ticket Help Fenster -->
  <div class="modal-overlay" id="discordHelpModal">
    <div class="discord-profile-modal-box">
      <!-- Close Button -->
      <button class="discord-modal-close-btn" id="closeDiscordHelpModal" aria-label="Close modal">&times;</button>
      
      <!-- Top Banner (Green Nature Lawn Banner provided by user) -->
      <div class="discord-profile-banner" style="background-image: url('/assets/discord_banner.png');"></div>

      <!-- Avatar & Custom Status Header Row -->
      <div class="discord-header-row">
        <div class="discord-avatar-container">
          <img src="/assets/discord_avatar.png" alt="StaatsAnwalt" class="discord-avatar-img">
          <!-- DND Red Status Badge -->
          <span class="discord-status-badge" title="Do Not Disturb"></span>
        </div>
        
        <!-- Status Pill: .gg/xyzscripts -->
        <a href="https://discord.gg/xyzscripts" target="_blank" rel="noopener" class="discord-custom-status-tag" title="Join Discord">
          <span>.gg/xyzscripts</span>
        </a>
      </div>

      <!-- Profile Details Area -->
      <div class="discord-profile-body">
        <!-- Display Name & Badges -->
        <div class="discord-names-wrap">
          <div class="discord-display-name">StaatsAnwalt</div>
          <div class="discord-username-line">
            <span class="discord-handle">staaatsanwalt</span>
            <span class="discord-badge-pill" title="XYZ Scripts">
              <span class="discord-badge-icon">⚡</span>
              <span class="discord-badge-text">xyz</span>
            </span>
          </div>
        </div>

        <!-- Bio / Description Area -->
        <div class="discord-bio-card">
          <a href="https://discord.gg/xyzscripts" target="_blank" rel="noopener" class="discord-server-link">
            <svg class="discord-icon-svg" width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
              <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.929 1.793 8.18 1.793 12.061 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.894.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.028zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
            </svg>
            <span>discord.gg/xyzscripts</span>
          </a>
          <div class="discord-bio-sub">
            <span class="bio-arrow">↳</span> Join For Best Scripts !
          </div>
        </div>

        <!-- Ticket Section -->
        <div class="discord-ticket-box">
          <div class="discord-ticket-header">
            <span class="ticket-tag">SUPPORT &amp; TICKETS</span>
            <h3 class="ticket-title">Need Help or have questions?</h3>
            <p class="ticket-desc">Open a ticket in our Discord community to get instant help with keys, execution, whitelist or errors.</p>
          </div>

          <div class="discord-ticket-actions">
            <a href="https://discord.gg/xyzscripts" target="_blank" rel="noopener" class="btn-discord-ticket" id="btnOpenTicketDiscord">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                <path d="M15 5v2"></path>
                <path d="M15 11v2"></path>
                <path d="M15 17v2"></path>
                <path d="M5 5h14a2 2 0 0 1 2 2v3a2 2 0 0 0 0 4v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-3a2 2 0 0 0 0-4V7a2 2 0 0 1 2-2z"></path>
              </svg>
              <span>Open Discord Ticket</span>
            </a>
            <button type="button" class="btn-discord-copy" id="btnCopyDiscordLink">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
              </svg>
              <span id="copyDiscordBtnText">Copy Link</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="/js/main.js?v=2.4.0"></script>
  <script>
    if (document.getElementById('year')) {
      document.getElementById('year').textContent = new Date().getFullYear();
    }
  </script>
  <script src="/js/halloween.js?v=1.0"></script>
</body>
</html>

