<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>AirFlow</title>
<link rel="icon" href="assets/airflow-logo.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  html, body { background: #060608; color: #F2F2F4; font-family: 'Plus Jakarta Sans', sans-serif; min-height: 100vh; }
  body { -webkit-user-select: none; user-select: none; overflow-x: hidden; }
  img { -webkit-user-drag: none; user-drag: none; pointer-events: none; }
  ::selection { background: rgba(255,255,255,0.18); }
  a { color: inherit; text-decoration: none; }
  button { font-family: inherit; cursor: pointer; }

  @keyframes afGlide { 0%,100% { transform: translateY(0) rotate(-2.5deg); } 50% { transform: translateY(-7px) rotate(2.5deg); } }
  @keyframes afReveal { from { transform: translateY(22px) scale(0.99); opacity: 0; } to { transform: none; opacity: 1; } }
  @keyframes afFade { from { opacity: 0; } to { opacity: 1; } }
  @keyframes afPop { from { opacity: 0; transform: scale(0.95) translateY(8px); } to { opacity: 1; transform: none; } }
  @keyframes afSpin { to { transform: rotate(360deg); } }

  .root { position: relative; min-height: 100vh; display: flex; flex-direction: column; overflow: hidden; }
  #flow { position: absolute; inset: 0; width: 100%; height: 100%; z-index: 0; display: block; }
  .root::after { content: ''; position: absolute; left: 0; right: 0; bottom: 0; height: 13%; z-index: 1; pointer-events: none; background: linear-gradient(to top, #000 0%, transparent); }

  nav.hdr { position: relative; z-index: 3; display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; gap: 24px; max-width: 1180px; width: 100%; margin: 24px auto 0; padding: 0 26px; animation: afReveal .55s ease-out both; }
  .brand { justify-self: start; display: flex; align-items: center; gap: 11px; cursor: pointer; }
  .brand img { width: 30px; height: 30px; object-fit: contain; }
  .brand span { font-family: 'Sora', sans-serif; font-weight: 700; font-size: 19px; letter-spacing: -0.3px; color: #E2E0DC; }

  .tabs { justify-self: center; display: flex; align-items: center; gap: 2px; background: rgba(24,26,27,0.04); border: 1px solid rgba(48,52,54,0.07); border-radius: 13px; padding: 4px; backdrop-filter: blur(10px); }
  .tab { display: inline-flex; align-items: center; gap: 7px; font-size: 13.5px; font-weight: 600; white-space: nowrap; padding: 7px 12px; border-radius: 9px; cursor: pointer; transition: all .15s; color: #ABA499; background: transparent; border: none; }
  .tab:hover { background: rgba(255,255,255,0.06); }
  .tab.active { color: #E2E0DC; background: rgba(24,26,27,0.1); box-shadow: 0 1px 0 rgba(24,26,27,0.06) inset, 0 4px 12px rgba(0,0,0,0.3); }

  .discord-btn-hdr { justify-self: end; display: inline-flex; align-items: center; gap: 9px; padding: 9px 17px; border-radius: 11px; background: rgba(24,26,27,0.06); border: 1px solid rgba(48,52,54,0.12); color: #E0DEDA; font-weight: 600; font-size: 14px; cursor: pointer; transition: background .15s; }
  .discord-btn-hdr:hover { background: rgba(255,255,255,0.11); }

  main.body { position: relative; z-index: 3; flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; width: 100%; max-width: 1100px; margin: 0 auto; padding: 48px 26px 80px; }
  .view { display: none; width: 100%; }
  .view.active { display: block; }

  .home { display: flex; flex-direction: column; align-items: center; text-align: center; max-width: 760px; width: 100%; margin: 0 auto; }
  .home .logo-wrap { position: relative; margin-bottom: 34px; animation: afReveal .6s ease-out .08s both; }
  .home .logo-wrap img { width: 120px; height: 120px; object-fit: contain; animation: afGlide 8s ease-in-out infinite; }
  h1.title { font-family: 'Sora', sans-serif; font-weight: 800; font-size: clamp(56px, 10vw, 116px); line-height: 0.98; letter-spacing: -3px; background: linear-gradient(178deg, rgb(36,39,41) 0%, rgb(41,16,106) 36%, rgb(72,49,132) 66%, rgb(50,38,83) 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent; color: transparent; filter: drop-shadow(0 2px 13px rgba(124,97,196,0.32)); animation: afReveal .6s ease-out .16s both; }
  h1.page-title { font-family: 'Sora', sans-serif; font-weight: 800; font-size: clamp(32px, 4.6vw, 48px); letter-spacing: -1.5px; background: linear-gradient(178deg, rgb(36,39,41) 0%, rgb(41,16,106) 36%, rgb(72,49,132) 66%, rgb(50,38,83) 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent; color: transparent; filter: drop-shadow(0 3px 16px rgba(124,97,196,0.4)); animation: afReveal .55s ease-out .05s both; }
  .home .credit { display: flex; align-items: center; justify-content: center; gap: 10px; margin: 18px 0 0; font-size: 13.5px; font-weight: 500; letter-spacing: 0.4px; color: #7C7686; animation: afReveal .6s ease-out .24s both; }
  .home .credit b { color: #B299F0; font-weight: 600; }
  .home .credit .owner { display: inline-flex; align-items: center; gap: 7px; padding: 0; background: none; border: 0; font: inherit; letter-spacing: inherit; color: #B299F0; font-weight: 600; cursor: pointer; }
  .home .credit .owner img { width: 20px; height: 20px; border-radius: 50%; object-fit: cover; flex: none; }
  .home .credit .owner:hover span { text-decoration: underline; text-underline-offset: 3px; }
  .home .lead { font-size: 18px; line-height: 1.8; color: #A8A6B6; margin: 30px 0 0; max-width: 540px; letter-spacing: 0.1px; animation: afReveal .6s ease-out .32s both; }
  .home .lead em { color: #F0F0F2; font-weight: 600; font-style: normal; }
  .home .ctas { display: flex; flex-wrap: wrap; align-items: center; justify-content: center; gap: 10px; margin-top: 38px; animation: afReveal .6s ease-out .40s both; }

  .btn { display: inline-flex; align-items: center; gap: 10px; padding: 15px 24px; border-radius: 14px; font-weight: 700; font-size: 16px; border: 1px solid rgba(48,52,54,0.3); transition: all .18s ease; }
  .btn-dark { background: #1E2021; color: #D9D6D1; box-shadow: 0 10px 28px rgba(0,0,0,0.45), inset 0 1px 0 rgba(255,255,255,0.05); }
  .btn-dark:hover { background: #262829; transform: translateY(-3px); box-shadow: 0 16px 36px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.07); }
  .btn-primary { background: linear-gradient(135deg,#2B0F73,#574289); color: #E8E6E3; border-color: rgba(48,52,54,0.22); box-shadow: 0 12px 30px rgba(72,49,132,0.42), inset 0 1px 0 rgba(255,255,255,0.12); }
  .btn-primary:hover { filter: brightness(1.06); transform: translateY(-3px); box-shadow: 0 12px 28px rgba(124,97,196,0.3), inset 0 1px 0 rgba(255,255,255,0.2); }
  .btn-ghost { background: rgba(24,26,27,0.06); color: #D3CFE6; border-color: rgba(48,52,54,0.13); padding: 15px 22px; font-weight: 600; backdrop-filter: blur(8px); box-shadow: inset 0 1px 0 rgba(255,255,255,0.04); }
  .btn-ghost:hover { background: rgba(255,255,255,0.12); transform: translateY(-3px); }
  .btn:disabled { opacity: .65; cursor: not-allowed; transform: none !important; filter: none !important; }

  .page-head { width: 100%; text-align: center; }
  .page-head .icon { display: flex; justify-content: center; margin-bottom: 14px; animation: afReveal .55s ease-out both; }
  .page-head p { font-size: 16px; color: #9C97AE; margin: 12px 0 0; animation: afReveal .55s ease-out .12s both; }

  .games-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(196px, 1fr)); gap: 16px; margin: 30px 0 0; text-align: left; }
  .game-card { display: block; border-radius: 14px; overflow: hidden; background: rgba(24,26,27,0.02); border: 1px solid rgba(48,52,54,0.1); transition: transform .18s ease, border-color .18s ease; }
  .game-card:hover { transform: translateY(-2px); border-color: rgba(255,255,255,0.18); }
  .game-card .img-wrap { position: relative; width: 100%; aspect-ratio: 16/9; background: #0b0b0d; overflow: hidden; }
  .game-card img { width: 100%; height: 100%; object-fit: cover; display: block; }
  .game-card .meta { display: flex; align-items: center; justify-content: space-between; gap: 8px; padding: 12px 13px; }
  .game-card .name { font-size: 13.5px; font-weight: 600; color: #D9D6D1; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .game-card .tag { flex-shrink: 0; padding: 2px 7px; border-radius: 5px; background: rgba(91,217,154,0.1); border: 1px solid rgba(91,217,154,0.22); color: #5BD99A; font-size: 9.5px; font-weight: 700; letter-spacing: 0.4px; }

  .plans { display: grid; grid-template-columns: repeat(2, 1fr); gap: 18px; margin: 30px auto 0; max-width: 780px; text-align: left; }
  .plans.plans-3 { grid-template-columns: repeat(3, 1fr); max-width: 1120px; }
  .plans #lifetimePlan { order: 2; }
  .plans #freePlan { order: 3; }
  @media (max-width: 900px) { .plans.plans-3 { grid-template-columns: 1fr; max-width: 420px; } }
  .lootlabs-warn { margin-top: 12px; padding: 9px 12px; border-radius: 9px; background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.28); color: #fca5a5; font-size: 12px; line-height: 1.45; text-align: center; }
  .plan-btn:disabled { opacity: 0.55; cursor: not-allowed; }
  .plan-btn:disabled:hover { transform: none; }
  .plan { position: relative; display: flex; flex-direction: column; padding: 38px 26px 24px; border-radius: 18px; background: rgba(24,26,27,0.02); border: 1px solid rgba(48,52,54,0.08); box-shadow: 0 10px 34px rgba(0,0,0,0.35); transition: transform .18s ease, border-color .18s ease, box-shadow .18s ease; animation: afReveal .6s ease-out .26s both; }
  .plan:hover { transform: translateY(-3px); border-color: rgba(255,255,255,0.16); box-shadow: 0 20px 50px rgba(0,0,0,0.45); }
  .plan.featured { border-color: rgba(56,29,121,0.32); box-shadow: 0 12px 40px rgba(0,0,0,0.35), 0 0 32px rgba(72,49,132,0.12); animation-delay: .18s; }
  .plan.featured:hover { border-color: rgba(124,97,196,0.75); box-shadow: 0 26px 58px rgba(107,83,166,0.32), 0 0 46px rgba(124,97,196,0.18); }
  .plan-premium .plan-crown { display: flex; justify-content: center; margin-bottom: 6px; }
  .plan-premium .plan-crown svg { filter: drop-shadow(0 8px 22px rgba(124,97,196,0.55)); }
  .plan-premium .plan-name { margin-top: 14px; font-size: 22px; letter-spacing: -0.3px; }
  .plan-corner-badge { position: absolute; top: 12px; right: 12px; display: inline-flex; align-items: center; gap: 5px; padding: 4px 9px; border-radius: 7px; background: rgba(124,97,196,0.18); border: 1px solid rgba(124,97,196,0.42); color: #CBBDF6; font-size: 9.5px; font-weight: 700; letter-spacing: 0.7px; z-index: 2; }
  .plan-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
  .plan-head img { height: 40px; max-width: 120px; object-fit: contain; }
  .plan-icon img { height: 52px; max-width: 150px; object-fit: contain; }
  .free-logo-loader { height: 52px; min-width: 60px; display: flex; align-items: center; justify-content: center; }
  .recommended { display: inline-flex; align-items: center; gap: 5px; padding: 5px 11px; border-radius: 8px; background: rgba(124,97,196,0.2); border: 1px solid rgba(124,97,196,0.42); color: #CBBDF6; font-size: 10.5px; font-weight: 700; letter-spacing: 0.7px; }
  .plan-name { font-family: 'Sora', sans-serif; font-weight: 600; font-size: 19px; color: #F4F2FB; margin-top: 20px; text-align: center; }
  .plan-price { display: flex; align-items: baseline; gap: 8px; margin-top: 6px; justify-content: center; }
  .plan-icon { display: flex; justify-content: center; align-items: center; margin-bottom: 4px; min-height: 56px; }
  .plan-price .amount { font-family: 'Sora', sans-serif; font-weight: 800; font-size: 40px; color: #FFFFFF; }
  .plan-price .amount.free { color: #5BD99A; }
  .plan-price .was { font-size: 17px; color: #6B6680; font-weight: 600; text-decoration: line-through; letter-spacing: -0.2px; }
  .plan-price .period { font-size: 15px; color: #8C86A6; font-weight: 500; }
  .plan-save { display: inline-block; margin-top: 6px; padding: 3px 9px; border-radius: 6px; background: rgba(91,217,154,0.12); border: 1px solid rgba(91,217,154,0.3); color: #5BD99A; font-size: 10.5px; font-weight: 700; letter-spacing: 0.6px; }
  .plan-features { display: flex; flex-direction: column; gap: 10px; margin-top: 33px; }
  .feat { display: flex; align-items: center; gap: 11px; font-size: 14px; color: #D2CFDD; }
  .feat svg { flex-shrink: 0; }
  .plan-btn { margin-top: 24px; width: 100%; display: inline-flex; justify-content: center; align-items: center; gap: 9px; padding: 14px; border-radius: 12px; font-weight: 700; font-size: 15.5px; border: 1px solid rgba(48,52,54,0.13); transition: all .16s ease; }
  .plan-btn.primary { background: linear-gradient(135deg,#361D76,#554283); color: #fff; border-color: rgba(48,52,54,0.18); box-shadow: 0 8px 20px rgba(107,83,166,0.26); }
  .plan-btn.primary:hover { filter: brightness(1.08); transform: translateY(-2px); }
  .plan-btn.ghost { background: rgba(255,255,255,0.06); color: #F2F2F4; }
  .plan-btn.ghost:hover { background: rgba(255,255,255,0.11); transform: translateY(-2px); }

  .platforms-block { margin-top: 38px; text-align: center; animation: afReveal .6s ease-out .34s both; }
  .platforms-label { font-size: 12px; font-weight: 700; letter-spacing: 1.3px; color: #7E789A; text-align: center; }
  .pills { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; margin-top: 14px; }
  .pill { display: inline-flex; align-items: center; gap: 8px; padding: 9px 15px; border-radius: 11px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.09); font-size: 13px; font-weight: 600; color: #D6D4E0; }
  .pay-pills { display: flex; flex-wrap: wrap; justify-content: center; gap: 8px; margin-top: 14px; max-width: 760px; margin-left: auto; margin-right: auto; }
  .pay-pill { padding: 7px 12px; border-radius: 9px; background: rgba(255,255,255,0.04); border: 1px solid rgba(48,52,54,0.08); font-size: 12.5px; font-weight: 600; color: #C2C0CE; }

  .modal-bg { position: fixed; inset: 0; z-index: 60; display: none; align-items: center; justify-content: center; padding: 24px; background: rgba(0,0,0,0.72); backdrop-filter: blur(8px); animation: afFade .22s ease; }
  .modal-bg.open { display: flex; }
  .modal { position: relative; width: 100%; max-width: 540px; background: linear-gradient(180deg, #0d0d10 0%, #0a0a0c 100%); border: 1px solid rgba(124,97,196,0.22); border-radius: 20px; padding: 28px; box-shadow: 0 30px 80px rgba(0,0,0,0.7), 0 0 60px rgba(72,49,132,0.18), inset 0 1px 0 rgba(255,255,255,0.04); animation: afPop .32s cubic-bezier(0.34,1.32,0.5,1); }
  .modal-close { position: absolute; top: 14px; right: 14px; width: 30px; height: 30px; display: grid; place-items: center; border-radius: 8px; background: rgba(24,26,27,0.06); border: 1px solid rgba(48,52,54,0.2); color: #9C97AE; font-size: 17px; line-height: 1; }
  .modal-head { display: flex; align-items: center; gap: 14px; padding-right: 36px; }
  .modal-head img { width: 42px; height: 42px; object-fit: contain; flex-shrink: 0; filter: drop-shadow(0 4px 12px rgba(124,97,196,0.35)); }
  .modal-head-txt { display: flex; flex-direction: column; gap: 4px; }
  .modal-title { font-family: 'Sora', sans-serif; font-weight: 700; font-size: 20px; color: #F2F0F8; letter-spacing: -0.2px; }
  .modal-sub { font-size: 13.5px; color: #9C97AE; }
  .loadstring { margin-top: 18px; padding: 14px 16px; border-radius: 12px; background: #060608; border: 1px solid rgba(48,52,54,0.5); font-family: 'JetBrains Mono', Consolas, 'Courier New', monospace; font-size: 12.5px; line-height: 1.6; word-break: break-all; text-align: left; }
  .lua-kw { color: #C586C0; }
  .lua-id { color: #9CDCFE; }
  .lua-fn { color: #DCDCAA; }
  .lua-str { color: #CE9178; }
  .lua-punct { color: #D4D4D4; }
  .lua-op { color: #D4D4D4; }
  .modal-actions { display: flex; gap: 10px; margin-top: 18px; }
  .modal-btn { flex: 1; padding: 13px; border-radius: 12px; font-weight: 700; font-size: 15px; border: 1px solid rgba(48,52,54,0.22); transition: all .18s ease; display: inline-flex; align-items: center; justify-content: center; gap: 9px; }
  .modal-btn:hover { transform: translateY(-2px); }
  .modal-btn.primary { background: linear-gradient(135deg,#361D76,#554283); color: #E8E6E3; box-shadow: 0 8px 20px rgba(107,83,166,0.26); }
  .modal-btn.primary:hover { filter: brightness(1.08); }
  .modal-btn.primary.copied { background: linear-gradient(135deg,#2E7D52,#1F8A5B); }
  .modal-btn.ghost { background: rgba(24,26,27,0.06); border-color: rgba(48,52,54,0.13); color: #D9D6D1; }
  .modal-btn.ghost:hover { background: rgba(255,255,255,0.11); }

  .toast { position: fixed; top: 24px; left: 50%; transform: translateX(-50%); z-index: 100; display: none; align-items: center; gap: 9px; padding: 12px 18px; border-radius: 11px; background: #2a1215; border: 1px solid #5c2b2e; color: #ff8a80; font-size: 14px; font-weight: 600; animation: afPop .25s ease-out; box-shadow: 0 8px 24px rgba(0,0,0,0.4); }
  .toast.show { display: flex; }

  .root.key-mode nav.hdr { display: none; }
  .root.key-mode main.body { justify-content: center; padding-top: 80px; }
  .key-wrap { width: 100%; max-width: 480px; margin: 0 auto; }
  .key-card { background: rgba(11,11,13,0.85); backdrop-filter: blur(12px); border: 1px solid rgba(56,29,121,0.32); border-radius: 22px; padding: 32px; box-shadow: 0 30px 80px rgba(0,0,0,0.6), 0 0 50px rgba(72,49,132,0.18); animation: afPop .4s cubic-bezier(0.34,1.32,0.5,1); }
  .key-glow { position: absolute; width: 380px; height: 380px; border-radius: 50%; filter: blur(80px); pointer-events: none; z-index: 1; }
  .key-glow-1 { top: -100px; left: -100px; background: radial-gradient(circle, rgba(124,97,196,0.35), transparent 70%); }
  .key-glow-2 { bottom: -100px; right: -100px; background: radial-gradient(circle, rgba(56,29,121,0.32), transparent 70%); }
  .key-head { display: flex; align-items: center; gap: 14px; margin-bottom: 24px; }
  .key-logo { width: 48px; height: 48px; object-fit: contain; }
  .key-head-txt { flex: 1; }
  .key-title { font-family: 'Sora', sans-serif; font-weight: 700; font-size: 22px; color: #F2F0F8; letter-spacing: -0.3px; }
  .key-sub { font-size: 13.5px; color: #9C97AE; margin-top: 4px; }
  .key-progress { display: flex; align-items: center; gap: 10px; margin: 22px 0 18px; }
  .key-dot { width: 32px; height: 32px; border-radius: 50%; display: grid; place-items: center; background: rgba(255,255,255,0.06); border: 1px solid rgba(48,52,54,0.3); color: #6B6680; font-size: 13px; font-weight: 700; transition: all .3s ease; flex-shrink: 0; }
  .key-dot svg { width: 16px; height: 16px; }
  .key-dot.wait { background: rgba(124,97,196,0.2); border-color: rgba(124,97,196,0.5); color: #CBBDF6; }
  .key-dot.done { background: linear-gradient(135deg,#361D76,#554283); border-color: rgba(124,97,196,0.7); color: #fff; }
  .key-progress-line { flex: 1; height: 3px; background: rgba(255,255,255,0.06); border-radius: 2px; overflow: hidden; }
  .key-progress-fill { height: 100%; width: 0; background: linear-gradient(90deg,#361D76,#554283); transition: width .4s ease; }
  .key-progress-fill.done { width: 100%; }
  .key-warn { display: flex; align-items: center; gap: 9px; padding: 10px 14px; border-radius: 10px; background: rgba(220,38,38,0.12); border: 1px solid rgba(220,38,38,0.32); color: #FCA5A5; font-size: 13px; font-weight: 600; margin-bottom: 16px; animation: afPop .25s ease-out; }
  .key-warn svg { flex-shrink: 0; }
  .key-step { background: rgba(255,255,255,0.025); border: 1px solid rgba(48,52,54,0.2); border-radius: 14px; padding: 18px; transition: opacity .25s, filter .25s; }
  .key-step + .key-step { margin-top: 12px; }
  .key-step.hidden { display: none; }
  .key-step-label { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
  .key-step-num { padding: 3px 9px; border-radius: 6px; background: rgba(124,97,196,0.18); color: #CBBDF6; font-size: 10.5px; font-weight: 700; letter-spacing: 0.6px; }
  .key-step-desc { font-size: 13.5px; color: #C8C6D4; font-weight: 500; }
  .key-step-hint { font-size: 11.5px; color: #8B85A0; margin-bottom: 10px; margin-top: -4px; line-height: 1.5; }
  .key-step-hint a { color: #B299F0; text-decoration: underline; text-underline-offset: 2px; }
  .key-discord { width: 100%; display: inline-flex; align-items: center; justify-content: center; gap: 10px; padding: 14px; border-radius: 11px; background: linear-gradient(135deg,#5865F2,#4752C4); color: #fff; border: 1px solid rgba(88,101,242,0.4); font-weight: 700; font-size: 15px; cursor: pointer; transition: all .18s ease; box-shadow: 0 8px 20px rgba(88,101,242,0.32); }
  .key-discord:hover:not(:disabled) { filter: brightness(1.08); transform: translateY(-2px); box-shadow: 0 12px 26px rgba(88,101,242,0.44); }
  .key-discord:disabled { opacity: 0.8; cursor: not-allowed; }
  .key-discord.yt:not(.wait):not(.done) { background: linear-gradient(135deg,#FF2A3A,#CC0000); box-shadow: 0 8px 20px rgba(204,0,0,0.32); }
  .key-discord.yt:hover:not(:disabled) { box-shadow: 0 12px 26px rgba(204,0,0,0.44); }
  .key-discord.yt.wait { background: linear-gradient(135deg,#7A1A22,#541017); box-shadow: 0 8px 20px rgba(122,26,34,0.32); }
  .key-skip { margin-top: 12px; text-align: center; font-size: 12.5px; color: #7A7488; cursor: default; user-select: none; }
  .key-skip.ready { color: #B299F0; cursor: pointer; text-decoration: underline; }
  .key-skip.ready:hover { color: #CBBDF6; }
  .key-discord.wait { background: linear-gradient(135deg,#4A4D8A,#3A3D6B); box-shadow: 0 8px 20px rgba(74,77,138,0.32); }
  .key-discord.done { background: linear-gradient(135deg,#2E7D52,#1F8A5B); box-shadow: 0 8px 20px rgba(46,125,82,0.32); }
  .key-script { width: 100%; display: inline-flex; align-items: center; justify-content: center; gap: 10px; padding: 14px; border-radius: 11px; background: linear-gradient(135deg,#7C61C4,#4A3593); color: #fff; border: 1px solid rgba(178,153,240,0.4); font-weight: 700; font-size: 15px; cursor: pointer; transition: all .18s ease; box-shadow: 0 8px 20px rgba(124,97,196,0.32); }
  .key-script:hover:not(:disabled) { filter: brightness(1.08); transform: translateY(-2px); box-shadow: 0 12px 26px rgba(124,97,196,0.44); }
  .key-script:disabled { opacity: 0.8; cursor: not-allowed; }
  .key-script.wait { background: linear-gradient(135deg,#4A3D7A,#332855); box-shadow: 0 8px 20px rgba(74,61,122,0.32); }
  .key-script.done { background: linear-gradient(135deg,#2E7D52,#1F8A5B); box-shadow: 0 8px 20px rgba(46,125,82,0.32); }
  .key-script img { width: 20px; height: 20px; object-fit: contain; filter: drop-shadow(0 1px 2px rgba(0,0,0,0.4)); }
  .key-divider { height: 1px; background: rgba(48,52,54,0.3); margin: 18px 0; }
  .key-continue { width: 100%; display: inline-flex; align-items: center; justify-content: center; gap: 9px; padding: 14px; border-radius: 11px; background: rgba(255,255,255,0.04); border: 1px solid rgba(48,52,54,0.18); color: #6B6680; font-weight: 700; font-size: 14.5px; cursor: not-allowed; transition: all .2s ease; }
  .key-continue.go { background: linear-gradient(135deg,#361D76,#554283); color: #fff; border-color: rgba(124,97,196,0.5); cursor: pointer; box-shadow: 0 8px 20px rgba(107,83,166,0.32); }
  .key-spinner { width: 14px; height: 14px; border: 2px solid rgba(255,255,255,0.2); border-top-color: #fff; border-radius: 50%; animation: afSpin .8s linear infinite; }

  .script-card { max-width: 640px; margin: 30px auto 0; padding: 28px; background: rgba(11,11,13,0.85); backdrop-filter: blur(8px); border: 1px solid rgba(56,29,121,0.32); border-radius: 18px; box-shadow: 0 12px 40px rgba(0,0,0,0.35), 0 0 32px rgba(72,49,132,0.1); animation: afReveal .55s ease-out .18s both; }
  .script-card .loadstring { margin-top: 0; }
  .script-actions { display: flex; gap: 10px; margin-top: 18px; }
  .script-btn { flex: 1; padding: 13px; border-radius: 12px; font-weight: 700; font-size: 15px; border: 1px solid rgba(48,52,54,0.22); transition: all .18s ease; }
  .script-btn.primary { background: linear-gradient(135deg,#361D76,#554283); color: #E8E6E3; }
  .script-btn.primary:hover { filter: brightness(1.08); transform: translateY(-2px); }
  .script-btn.primary.copied { background: linear-gradient(135deg,#2E7D52,#1F8A5B); }
  .script-btn.ghost { background: rgba(24,26,27,0.06); border-color: rgba(48,52,54,0.13); color: #D9D6D1; }
  .script-btn.ghost:hover { background: rgba(255,255,255,0.11); transform: translateY(-2px); }

  .gw-card { max-width: 620px; margin: 30px auto 0; padding: 32px 30px 24px; border-radius: 20px; background: rgba(24,26,27,0.03); border: 1px solid rgba(48,52,54,0.1); box-shadow: 0 12px 40px rgba(0,0,0,0.35); display: flex; flex-direction: column; gap: 12px; animation: afReveal .55s ease-out .14s both; }
  .gw-step { display: flex; align-items: flex-start; gap: 15px; padding: 15px 16px; border-radius: 14px; background: rgba(255,255,255,0.02); border: 1px solid rgba(48,52,54,0.08); transition: transform .18s ease, border-color .18s ease, background .18s ease; }
  .gw-step:hover { border-color: rgba(124,97,196,0.32); background: rgba(255,255,255,0.035); transform: translateY(-1px); }
  .gw-num { flex-shrink: 0; width: 32px; height: 32px; border-radius: 10px; display: grid; place-items: center; font-family: 'Sora', sans-serif; font-weight: 700; font-size: 14px; color: #CBBDF6; background: linear-gradient(135deg, rgba(72,49,132,0.42), rgba(43,15,115,0.32)); border: 1px solid rgba(124,97,196,0.32); box-shadow: inset 0 1px 0 rgba(255,255,255,0.08); }
  .gw-body { display: flex; flex-direction: column; gap: 3px; min-width: 0; }
  .gw-title { font-family: 'Sora', sans-serif; font-weight: 600; font-size: 15px; letter-spacing: -0.2px; color: #E4E1E7; }
  .gw-desc { font-size: 13.5px; color: #8C8899; line-height: 1.55; }
  .gw-desc b { color: #CBBDF6; font-weight: 600; }
  .gw-warn { display: flex; align-items: center; gap: 10px; margin: 6px 2px 2px; padding: 11px 14px; border-radius: 12px; background: rgba(214,153,64,0.06); border: 1px solid rgba(214,153,64,0.22); color: #E6C48A; font-size: 12.8px; font-weight: 500; line-height: 1.5; letter-spacing: 0.1px; }
  .gw-warn svg { flex-shrink: 0; color: #E0A94A; }
  .gw-note { margin: 4px 4px 10px; font-size: 12.5px; color: #6E6879; line-height: 1.6; text-align: center; letter-spacing: 0.1px; }
  .gw-continue { align-self: center; margin-top: 10px; padding: 15px 34px; }

  @media (max-width: 720px) {
    nav.hdr { grid-template-columns: auto 1fr; gap: 12px; }
    nav.hdr .tabs { order: 3; grid-column: 1 / -1; justify-self: stretch; overflow-x: auto; }
    .discord-btn-hdr { padding: 8px 12px; font-size: 13px; }
    .plans { grid-template-columns: 1fr; }
    .gw-card { padding: 26px 20px 20px; }
  }
  /* ---------- checkout ---------- */
  .co-wrap { max-width: 980px; width: 100%; margin: 0 auto; padding: 0 26px; display: grid; grid-template-columns: 1fr 328px; gap: 18px; align-items: start; animation: afReveal .5s ease-out forwards; }
  .co-card { border-radius: 16px; background: rgba(24,26,27,0.035); border: 1px solid rgba(48,52,54,0.14); box-shadow: 0 10px 34px rgba(0,0,0,0.35); }

  .co-top { display: flex; align-items: center; gap: 13px; padding: 19px 22px; border-bottom: 1px solid rgba(48,52,54,0.14); }
  .co-top img { width: 38px; height: 38px; object-fit: contain; flex: none; }
  .co-top-name { font-family: 'Sora', sans-serif; font-weight: 700; font-size: 16px; letter-spacing: -0.3px; color: #EFEDEA; }
  .co-top-sub { font-size: 12.5px; color: #8B8595; margin-top: 2px; }

  .co-sec { padding: 18px 22px; border-bottom: 1px solid rgba(48,52,54,0.14); }
  .co-sec:last-child { border-bottom: none; }
  .co-label { display: block; font-size: 10.5px; font-weight: 700; letter-spacing: 0.9px; color: #6E6878; margin-bottom: 11px; }

  .co-plans { display: grid; gap: 8px; }
  .co-plan { display: flex; align-items: center; gap: 12px; padding: 13px 14px; border-radius: 12px; background: rgba(24,26,27,0.03); border: 1px solid rgba(48,52,54,0.16); cursor: pointer; transition: border-color .15s, background .15s, opacity .15s; }
  .co-plan:hover { border-color: rgba(255,255,255,0.2); }
  .co-plan.on { border-color: rgba(124,97,196,0.7); background: rgba(124,97,196,0.07); }
  .co-plan.locked { cursor: default; opacity: 0.45; }
  .co-plan.locked:hover { border-color: rgba(48,52,54,0.16); }
  .co-plan.locked.on { opacity: 1; }
  .co-plan svg { flex: none; opacity: 0.5; transition: opacity .15s; }
  .co-plan.on svg { opacity: 1; filter: drop-shadow(0 4px 12px rgba(124,97,196,0.5)); }
  .co-plan-body { flex: 1; min-width: 0; }
  .co-plan-name { font-weight: 600; font-size: 14.5px; color: #E6E4E0; display: flex; align-items: center; gap: 8px; }
  .co-plan-desc { font-size: 12px; color: #8B8595; margin-top: 2px; }
  .co-plan-price { font-family: 'Sora', sans-serif; font-weight: 700; font-size: 17px; color: #F2F2F4; white-space: nowrap; }
  .co-tag { padding: 2.5px 7px; border-radius: 6px; background: rgba(124,97,196,0.18); border: 1px solid rgba(124,97,196,0.4); color: #CBBDF6; font-size: 9px; font-weight: 700; letter-spacing: 0.6px; }

  .co-note { font-size: 12.5px; color: #8B8595; line-height: 1.55; }

  .co-input { width: 100%; padding: 11px 13px; border-radius: 10px; background: rgba(6,6,8,0.6); border: 1px solid rgba(48,52,54,0.24); color: #F2F2F4; font-family: inherit; font-size: 14px; outline: none; transition: border-color .15s; -webkit-user-select: text; user-select: text; }
  .co-input:focus { border-color: rgba(124,97,196,0.7); }
  .co-input::placeholder { color: #6E6878; }
  .co-input:disabled { opacity: 0.55; }

  .co-steps { display: grid; gap: 11px; counter-reset: costep; }
  .co-stepline { display: flex; gap: 11px; align-items: flex-start; font-size: 13px; color: #ABA499; line-height: 1.55; }
  .co-stepline::before { counter-increment: costep; content: counter(costep); flex: none; width: 20px; height: 20px; margin-top: 1px; border-radius: 6px; background: rgba(24,26,27,0.08); border: 1px solid rgba(48,52,54,0.2); color: #8B8595; font-size: 10.5px; font-weight: 700; display: flex; align-items: center; justify-content: center; }
  .co-stepline b { color: #E0DEDA; font-weight: 600; }

  .co-side { position: sticky; top: 20px; padding: 19px 21px; }
  .co-side-title { font-family: 'Sora', sans-serif; font-weight: 600; font-size: 11.5px; letter-spacing: 0.9px; color: #8B8595; padding-bottom: 13px; border-bottom: 1px solid rgba(48,52,54,0.16); }
  .co-line { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; padding: 10px 0; font-size: 13.5px; }
  .co-line span:first-child { color: #ABA499; }
  .co-line span:last-child { font-weight: 600; color: #E6E4E0; font-variant-numeric: tabular-nums; }
  .co-total { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; padding: 13px 0 2px; margin-top: 3px; border-top: 1px solid rgba(48,52,54,0.16); }
  .co-total span { font-size: 13.5px; color: #ABA499; }
  .co-total b { font-family: 'Sora', sans-serif; font-size: 25px; font-weight: 700; letter-spacing: -0.6px; color: #F2F2F4; }

  .co-btn { width: 100%; display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 12px 16px; border-radius: 11px; font-family: inherit; font-weight: 600; font-size: 13.5px; border: 1px solid transparent; transition: filter .15s, background .15s, border-color .15s; }
  .co-btn:disabled { opacity: 0.45; cursor: default; }
  .co-btn.primary { margin-top: 15px; background: linear-gradient(180deg, #7C61C4, #4E3A8C); color: #fff; box-shadow: 0 8px 22px rgba(124,97,196,0.28); }
  .co-btn.primary:hover:not(:disabled) { filter: brightness(1.1); }
  .co-btn.ghost { margin-top: 8px; background: rgba(24,26,27,0.06); border-color: rgba(48,52,54,0.24); color: #E0DEDA; }
  .co-btn.ghost:hover:not(:disabled) { background: rgba(255,255,255,0.07); border-color: rgba(255,255,255,0.2); }

  .co-ref { display: flex; align-items: center; justify-content: space-between; gap: 10px; margin-top: 13px; padding: 9px 11px; border-radius: 9px; background: rgba(124,97,196,0.07); border: 1px solid rgba(124,97,196,0.26); }
  .co-ref small { font-size: 9.5px; font-weight: 700; letter-spacing: 0.8px; color: #8B8595; }
  .co-ref b { font-family: 'JetBrains Mono', Consolas, monospace; font-size: 12.5px; font-weight: 500; color: #CBBDF6; -webkit-user-select: text; user-select: text; }


  .co-err { display: none; margin-top: 11px; padding: 10px 12px; border-radius: 10px; background: rgba(196,60,60,0.1); border: 1px solid rgba(196,60,60,0.34); color: #E79A9A; font-size: 12.5px; line-height: 1.5; }
  .co-err.show { display: block; }
  .co-spin { width: 14px; height: 14px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.28); border-top-color: #fff; animation: afSpin .7s linear infinite; }

  .co-modal { position: fixed; inset: 0; z-index: 70; display: none; align-items: center; justify-content: center; padding: 22px; background: rgba(0,0,0,0.74); backdrop-filter: blur(9px); animation: afFade .2s ease; }
  /* opacity is set here as well as in the keyframes: a tab backgrounded mid-fade
     freezes the animation, and without this the popup stays half transparent. */
  .co-modal.open { display: flex; opacity: 1; }
  .co-box { width: 100%; max-width: 430px; border-radius: 17px; background: #0C0C10; border: 1px solid rgba(48,52,54,0.3); box-shadow: 0 30px 80px rgba(0,0,0,0.7); animation: afPop .25s ease-out forwards; max-height: calc(100vh - 44px); overflow-y: auto; }
  .co-box-head { display: flex; align-items: center; gap: 11px; padding: 17px 20px; border-bottom: 1px solid rgba(48,52,54,0.2); }
  .co-box-title { font-family: 'Sora', sans-serif; font-weight: 600; font-size: 15.5px; color: #EFEDEA; }
  .co-box-x { margin-left: auto; width: 28px; height: 28px; border-radius: 8px; border: none; background: rgba(255,255,255,0.05); color: #8B8595; font-size: 17px; line-height: 1; display: flex; align-items: center; justify-content: center; }
  .co-box-x:hover { background: rgba(255,255,255,0.11); color: #F2F2F4; }
  .co-box-body { padding: 20px; }
  .co-code { width: 100%; padding: 14px; border-radius: 11px; background: #060608; border: 1px solid rgba(48,52,54,0.3); color: #F2F2F4; font-family: 'JetBrains Mono', Consolas, monospace; font-size: 17px; letter-spacing: 2.5px; text-align: center; outline: none; text-transform: uppercase; transition: border-color .15s; -webkit-user-select: text; user-select: text; }
  .co-code:focus { border-color: rgba(124,97,196,0.7); }
  .co-code::placeholder { color: #48434F; }

  .co-done-icon { width: 50px; height: 50px; margin: 2px auto 13px; border-radius: 50%; display: flex; align-items: center; justify-content: center; background: rgba(88,180,120,0.12); border: 1px solid rgba(88,180,120,0.4); }
  .co-done-title { text-align: center; font-family: 'Sora', sans-serif; font-weight: 600; font-size: 17px; color: #EFEDEA; }
  .co-done-sub { text-align: center; font-size: 12.5px; color: #8B8595; margin-top: 5px; line-height: 1.55; }
  .co-key { display: flex; align-items: center; gap: 10px; margin-top: 8px; padding: 11px 13px; border-radius: 10px; background: #060608; border: 1px solid rgba(48,52,54,0.26); }
  .co-key code { flex: 1; min-width: 0; font-family: 'JetBrains Mono', Consolas, monospace; font-size: 12.5px; line-height: 1.65; color: #C9C4D4; word-break: break-all; white-space: pre-wrap; -webkit-user-select: text; user-select: text; }
  .co-copy { flex: none; padding: 6px 11px; border-radius: 8px; background: rgba(255,255,255,0.06); border: 1px solid rgba(48,52,54,0.26); color: #E0DEDA; font-size: 11.5px; font-weight: 600; }
  .co-copy:hover { background: rgba(255,255,255,0.12); }
  .co-copy.copied { background: rgba(88,180,120,0.16); border-color: rgba(88,180,120,0.42); color: #8FD3A8; }

  .view[data-section="checkout"] { display: none; }
  .view[data-section="checkout"].active { display: flex; flex-direction: column; align-items: center; }
  .view[data-section="checkout"] .page-head { margin-bottom: 26px; }

  .co-fees { display: flex; gap: 9px; align-items: flex-start; margin-bottom: 15px; padding: 10px 12px; border-radius: 10px; background: rgba(196,150,60,0.08); border: 1px solid rgba(196,150,60,0.28); color: #E0C089; font-size: 12.5px; line-height: 1.55; }
  .co-fees svg { flex: none; margin-top: 1px; }
  .co-fees b { font-weight: 700; }
  .co-stepline a { color: #B299F0; font-weight: 600; text-decoration: underline; text-underline-offset: 2px; }
  .co-stepline a:hover { color: #CBBDF6; }
  .co-auto { display: flex; align-items: center; gap: 7px; margin-top: 14px; padding-top: 13px; border-top: 1px solid rgba(48,52,54,0.14); color: #8FD3A8; font-size: 12.5px; font-weight: 600; }

  .co-discord { display: flex; align-items: center; justify-content: center; gap: 9px; width: 100%; padding: 11px 16px; border-radius: 11px; background: #5865F2; border: 1px solid rgba(255,255,255,0.08); color: #fff; font-weight: 600; font-size: 13.5px; transition: filter .15s; }
  .co-discord:hover { filter: brightness(1.1); }
  .co-who { display: flex; align-items: center; gap: 11px; padding: 11px 13px; border-radius: 11px; background: rgba(88,101,242,0.08); border: 1px solid rgba(88,101,242,0.32); }
  .co-who img { width: 32px; height: 32px; border-radius: 50%; object-fit: cover; flex: none; }
  .co-who-body { flex: 1; min-width: 0; }
  .co-who-name { font-size: 13.5px; font-weight: 600; color: #E6E4E0; }
  .co-who-sub { font-size: 11.5px; color: #8B8595; margin-top: 1px; }
  .co-unlink { flex: none; padding: 5px 10px; border-radius: 8px; background: rgba(255,255,255,0.06); border: 1px solid rgba(48,52,54,0.26); color: #9A94AA; font-size: 11.5px; font-weight: 600; }
  .co-unlink:hover { background: rgba(255,255,255,0.12); color: #E0DEDA; }



  @media (max-width: 860px) {
    .co-wrap { grid-template-columns: 1fr; padding: 0 18px; }
    .co-side { position: static; }
  }

  /* ---------- sellers ---------- */
  .view[data-section="sellers"].active { margin-bottom: auto; }
  .view[data-section="sellers"] .page-head p { margin-top: 8px; }
  .sl-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 252px)); justify-content: center; gap: 16px; margin: 32px 0 0; }
  @media (max-width: 1100px) { .sl-grid { grid-template-columns: repeat(2, minmax(0, 284px)); } }
  .sl-card { position: relative; display: flex; flex-direction: column; padding: 8px; border-radius: 18px; background: #0E0E12; border: 1px solid rgba(255,255,255,0.07); box-shadow: 0 1px 0 rgba(255,255,255,0.04) inset, 0 18px 40px -18px rgba(0,0,0,0.8); transition: transform .3s cubic-bezier(.2,.8,.3,1), border-color .3s; animation: afReveal .5s ease-out both; }
  .sl-card:hover { transform: translateY(-4px); border-color: rgba(255,255,255,0.13); }
  .sl-card.official { border-color: rgba(178,153,240,0.42); animation: afReveal .5s ease-out both, slGlow 3.6s ease-in-out .5s infinite; }
  .sl-card.official:hover { border-color: rgba(178,153,240,0.7); }
  @keyframes slGlow {
    0%, 100% { box-shadow: 0 1px 0 rgba(255,255,255,0.04) inset, 0 18px 40px -18px rgba(0,0,0,0.8), 0 0 0 0 rgba(178,153,240,0), 0 0 22px -4px rgba(140,108,224,0.22); }
    50% { box-shadow: 0 1px 0 rgba(255,255,255,0.04) inset, 0 18px 40px -18px rgba(0,0,0,0.8), 0 0 0 3px rgba(178,153,240,0.07), 0 0 38px -2px rgba(140,108,224,0.36); }
  }
  .sl-media { position: relative; aspect-ratio: 5 / 4; border-radius: 12px; overflow: hidden; background: #08080B; }
  .sl-media img { width: 100%; height: 100%; object-fit: cover; display: block; transition: transform .5s cubic-bezier(.2,.8,.3,1); }
  .sl-media::after { content: ''; position: absolute; inset: 0; border-radius: inherit; box-shadow: inset 0 0 0 1px rgba(255,255,255,0.06); pointer-events: none; }
  .sl-card:hover .sl-media img { transform: scale(1.035); }
  .sl-badge { position: absolute; top: 10px; left: 10px; z-index: 1; display: inline-flex; align-items: center; gap: 6px; padding: 5px 9px 5px 7px; border-radius: 8px; background: rgba(12,11,17,0.72); border: 1px solid rgba(178,153,240,0.38); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); color: #D9CCFA; font-size: 11.5px; font-weight: 700; letter-spacing: 0.1px; }
  .sl-badge svg { width: 13px; height: 13px; color: #B299F0; }
  .sl-info { padding: 15px 8px 14px; }
  .sl-name { font-family: 'Sora', sans-serif; font-weight: 700; font-size: 19px; letter-spacing: -0.5px; line-height: 1.15; color: #F4F2F8; }
  .sl-sub { display: flex; align-items: center; gap: 7px; margin-top: 6px; font-size: 12.5px; font-weight: 500; color: #8B8597; }
  .sl-sub svg { width: 16px; height: 11px; flex: none; border-radius: 2px; }
  .sl-visit { display: flex; align-items: center; justify-content: space-between; height: 44px; padding: 0 14px 0 16px; border-radius: 11px; text-decoration: none; font-weight: 700; font-size: 13.5px; letter-spacing: -0.1px; color: #E9E7EF; background: rgba(255,255,255,0.045); border: 1px solid rgba(255,255,255,0.08); transition: background .2s, border-color .2s, color .2s; }
  .sl-visit:hover { background: rgba(255,255,255,0.08); border-color: rgba(255,255,255,0.14); }
  .sl-card.official .sl-visit { background: rgba(178,153,240,0.12); border-color: rgba(178,153,240,0.30); color: #E4DAFB; }
  .sl-card.official .sl-visit:hover { background: rgba(178,153,240,0.19); border-color: rgba(178,153,240,0.48); }
  .sl-visit .host { display: inline-flex; align-items: center; gap: 6px; font-weight: 500; font-size: 12px; opacity: 0.55; transition: opacity .2s; }
  .sl-visit:hover .host { opacity: 0.85; }
  .sl-visit svg { width: 12px; height: 12px; transition: transform .25s cubic-bezier(.2,.8,.3,1); }
  .sl-visit:hover svg { transform: translate(2px, -2px); }
  button.sl-visit { width: 100%; font: inherit; font-weight: 700; font-size: 13.5px; cursor: pointer; }
  .pl-modal { max-width: 420px; padding: 24px; }
  .pl-modal .modal-head img { width: 44px; height: 44px; border-radius: 11px; object-fit: cover; filter: none; }
  .pl-list { display: grid; gap: 10px; margin-top: 20px; }
  .pl-opt { display: flex; align-items: center; gap: 14px; padding: 15px 16px; border-radius: 13px; text-decoration: none; color: #F2F0F8; background: rgba(255,255,255,0.035); border: 1px solid rgba(255,255,255,0.08); transition: background .18s, border-color .18s; }
  .pl-opt:hover { background: rgba(178,153,240,0.09); border-color: rgba(178,153,240,0.38); }
  .pl-opt-txt { flex: 1; min-width: 0; }
  .pl-opt-name { font-family: 'Sora', sans-serif; font-weight: 700; font-size: 16px; letter-spacing: -0.3px; }
  .pl-opt-sub { margin-top: 3px; font-size: 12.5px; color: #8B8597; }
  .pl-opt svg { width: 14px; height: 14px; color: #8B8597; transition: transform .25s cubic-bezier(.2,.8,.3,1), color .18s; flex: none; }
  .pl-opt:hover svg { transform: translate(2px, -2px); color: #D9CCFA; }
  @media (max-width: 720px) { .sl-grid { grid-template-columns: minmax(0, 340px); margin-top: 26px; } }

</style>
</head>
<body>
<div class="root">
  <canvas id="flow"></canvas>

  <nav class="hdr">
    <div class="brand" data-view="home">
      <img src="assets/airflow-logo.png" alt="AirFlow">
      <span>AirFlow</span>
    </div>
    <div class="tabs" role="tablist">
      <button class="tab active" data-view="home">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10.5 12 4l9 6.5"/><path d="M5.5 9.5V20h13V9.5"/></svg>
        Home
      </button>
      <button class="tab" data-view="get-key">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M2.6 17.4A2 2 0 0 0 2 18.8V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.2a2 2 0 0 0 1.4-.6l.8-.8a6.5 6.5 0 1 0-4-4z"/><circle cx="16.5" cy="7.5" r="0.7" fill="currentColor" stroke="none"/></svg>
        Get Key
      </button>
      <button class="tab" data-view="games">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1.6"/><rect x="14" y="3" width="7" height="7" rx="1.6"/><rect x="3" y="14" width="7" height="7" rx="1.6"/><rect x="14" y="14" width="7" height="7" rx="1.6"/></svg>
        Games
      </button>
      <button class="tab" data-view="premium">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 8l4 4 4-6 4 6 4-4-1.6 10H5.6z"/></svg>
        Premium
      </button>
      <button class="tab" data-view="sellers">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 9.5 5.4 4h13.2L20 9.5"/><path d="M4 9.5a2.7 2.7 0 0 0 5.3 0 2.7 2.7 0 0 0 5.4 0 2.7 2.7 0 0 0 5.3 0"/><path d="M5.5 12.5V20h13v-7.5"/><path d="M10 20v-4.5h4V20"/></svg>
        Resellers
      </button>
    </div>
    <a href="https://discord.gg/AmhGaVf8Qg" target="_blank" rel="noopener" class="discord-btn-hdr">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M20.317 4.369a19.79 19.79 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028c.462-.63.874-1.295 1.226-1.994a.076.076 0 0 0-.041-.106 13.1 13.1 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.291.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.009c.12.099.246.198.373.292a.077.077 0 0 1-.006.127 12.3 12.3 0 0 1-1.873.891.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.84 19.84 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.331c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/></svg>
      Discord
    </a>
  </nav>

  <main class="body">

    <section class="view active" data-section="home">
      <div class="home">
        <div class="logo-wrap"><img src="assets/airflow-logo.png" alt="AirFlow"></div>
        <h1 class="title">AirFlow</h1>
        <div class="credit">Made by <button type="button" class="owner" id="ownerCredit"><span id="ownerName">ZNX</span></button></div>
        <p class="lead">
          If you're interested in seeing what games AirFlow supports, press
          <em>Games</em>. If you would like to get the script, press
          <em>Get Script</em>.
        </p>
        <div class="ctas">
          <button class="btn btn-dark" id="copyScriptBtn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="M7 10l5 5 5-5"/><path d="M12 15V3"/></svg>
            Copy Script
          </button>
          <button class="btn btn-primary" data-view="premium">
            <svg width="20" height="18" viewBox="0 0 24 24" fill="currentColor" style="filter:drop-shadow(0 2px 4px rgba(0,0,0,0.3));"><path d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/></svg>
            Premium
          </button>
          <button class="btn btn-ghost" data-view="games">
            <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 11h4"/><path d="M8 9v4"/><path d="M15 12h.01"/><path d="M18 10h.01"/><path d="M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 10.828 16h2.344a2 2 0 0 1 1.414.586L16 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.544-.604-6.584-.685-7.258A4 4 0 0 0 17.32 5z"/></svg>
            Games
          </button>
          <button class="btn btn-ghost" data-view="get-key">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"><path d="M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z"/><circle cx="16.5" cy="7.5" r=".6" fill="currentColor"/></svg>
            Get Key
          </button>
        </div>
      </div>
    </section>

    <section class="view" data-section="games">
      <div class="page-head">
        <div class="icon">
          <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#B9A6F2" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" style="filter:drop-shadow(0 0 12px rgba(124,97,196,0.35));"><rect x="3" y="3" width="7" height="7" rx="1.6"/><rect x="14" y="3" width="7" height="7" rx="1.6"/><rect x="3" y="14" width="7" height="7" rx="1.6"/><rect x="14" y="14" width="7" height="7" rx="1.6"/></svg>
        </div>
        <h1 class="page-title">Games</h1>
        <p>Every game AirFlow supports.</p>
      </div>
      <div class="games-grid" id="gamesGrid"></div>
    </section>

    <section class="view" data-section="get-key">
      <div class="page-head">
        <div class="icon">
          <svg width="46" height="46" viewBox="0 0 24 24" fill="none" stroke="#B9A6F2" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" style="filter:drop-shadow(0 6px 16px rgba(124,97,196,0.45));"><path d="M2.6 17.4A2 2 0 0 0 2 18.8V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.2a2 2 0 0 0 1.4-.6l.8-.8a6.5 6.5 0 1 0-4-4z"/><circle cx="16.5" cy="7.5" r="0.7" fill="#B9A6F2" stroke="none"/></svg>
        </div>
        <h1 class="page-title">Get your key</h1>
        <p>Choose a plan to access AirFlow scripts.</p>
      </div>

      <div class="plans" id="getKeyPlans">
        <div class="plan featured plan-premium">
          <span class="plan-corner-badge">
            <svg width="11" height="11" viewBox="0 0 24 24" fill="#CBBDF6"><path d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/></svg>
            RECOMMENDED
          </span>
          <div class="plan-crown">
            <svg width="64" height="56" viewBox="0 0 24 24">
              <defs>
                <linearGradient id="crownGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0" stop-color="#C7B5F5"/>
                  <stop offset="0.5" stop-color="#7C61C4"/>
                  <stop offset="1" stop-color="#36246A"/>
                </linearGradient>
              </defs>
              <path fill="url(#crownGrad)" d="M4 8l4 4 4-6 4 6 4-4-1.6 10H5.6z"/>
            </svg>
          </div>
          <div class="plan-name">Premium</div>
          <div class="plan-price"><span class="amount">€4.99</span><span class="was">€10</span></div>
          <div class="plan-features">
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Instant whitelist</div>
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>No key system</div>
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Keyless on all games we support</div>
          </div>
          <button class="plan-btn primary" id="getPremiumBtn">
            <svg width="20" height="18" viewBox="0 0 24 24" fill="currentColor" style="filter:drop-shadow(0 2px 4px rgba(0,0,0,0.3));"><path d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/></svg>
            Get Premium
          </button>
        </div>

        <div class="plan" id="freePlan">
          <div class="plan-icon">
            <div id="freeLogoWrap" class="free-logo-loader"><div class="key-spinner"></div></div>
          </div>
          <div class="plan-name" id="freeName">Loading...</div>
          <div class="plan-price">
            <span class="amount free">Free</span>
            <span class="period">with ads</span>
          </div>
          <div class="plan-features">
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#9A94AA" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Easy process</div>
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#9A94AA" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Secure links</div>
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#9A94AA" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Fast delivery</div>
          </div>
          <button class="plan-btn ghost" id="getFreeBtn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M2.6 17.4A2 2 0 0 0 2 18.8V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.2a2 2 0 0 0 1.4-.6l.8-.8a6.5 6.5 0 1 0-4-4z"/><circle cx="16.5" cy="7.5" r="0.7" fill="currentColor" stroke="none"/></svg>
            <span id="getFreeLabel">Get Free Key</span>
          </button>
          <div class="lootlabs-warn" id="lootlabsWarn" style="display:none;">
            LootLabs is currently down. When they're back up again, please check back.
          </div>
        </div>

        <div class="plan featured" id="lifetimePlan" style="display:none;">
          <span class="plan-corner-badge">BEST VALUE</span>
          <div class="plan-icon">
            <svg width="64" height="56" viewBox="0 0 24 24" style="filter:drop-shadow(0 8px 22px rgba(124,97,196,0.55));">
              <defs><linearGradient id="cgGetKeyLife" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#C7B5F5"/><stop offset="0.5" stop-color="#7C61C4"/><stop offset="1" stop-color="#36246A"/></linearGradient></defs>
              <path fill="url(#cgGetKeyLife)" d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/>
            </svg>
          </div>
          <div class="plan-name">Lifetime</div>
          <div class="plan-price">
            <span class="amount">€19.99</span>
            <span class="was">€25</span>
            <span class="period">one-time</span>
          </div>
          <div style="text-align:center;"><span class="plan-save">SAVE 20%</span></div>
          <div class="plan-features">
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Full AirFlow access</div>
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Fully keyless, all supported games</div>
            <div class="feat"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Instant delivery</div>
          </div>
          <button class="plan-btn primary" id="getLifetimeBtn">
            <svg width="20" height="18" viewBox="0 0 24 24" fill="currentColor" style="filter:drop-shadow(0 2px 4px rgba(0,0,0,0.3));"><path d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/></svg>
            Get Lifetime
          </button>
        </div>
      </div>
    </section>

    <section class="view" data-section="premium">
      <div class="page-head">
        <div class="icon">
          <svg width="56" height="50" viewBox="0 0 24 24" style="filter:drop-shadow(0 8px 20px rgba(124,97,196,0.5));">
            <defs><linearGradient id="cg1" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#6A57A0"/><stop offset="1" stop-color="#2F2750"/></linearGradient></defs>
            <path fill="url(#cg1)" d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/>
          </svg>
        </div>
        <h1 class="page-title">Premium</h1>
        <p>Pick the plan that works best for you.</p>
      </div>

      <div class="plans">
        <div class="plan">
          <div class="plan-icon">
            <svg width="64" height="56" viewBox="0 0 24 24" style="filter:drop-shadow(0 8px 22px rgba(124,97,196,0.55));">
              <defs><linearGradient id="cg2" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#C7B5F5"/><stop offset="0.5" stop-color="#7C61C4"/><stop offset="1" stop-color="#36246A"/></linearGradient></defs>
              <path fill="url(#cg2)" d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/>
            </svg>
          </div>
          <div class="plan-name">Monthly</div>
          <div class="plan-price">
            <span class="amount">€4.99</span>
            <span class="was">€10</span>
            <span class="period">/ month</span>
          </div>
          <div style="text-align:center;"><span class="plan-save">SAVE 50%</span></div>
          <div class="plan-features">
            <div class="feat"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9A94AA" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Full AirFlow access</div>
            <div class="feat"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9A94AA" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Fully keyless, all supported games</div>
            <div class="feat"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9A94AA" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Instant delivery</div>
          </div>
          <button class="plan-btn ghost" data-buy="monthly">
            <svg width="20" height="18" viewBox="0 0 24 24" fill="currentColor" style="filter:drop-shadow(0 2px 4px rgba(0,0,0,0.3));"><path d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/></svg>
            Get Monthly
          </button>
        </div>

        <div class="plan featured">
          <span class="plan-corner-badge">BEST VALUE</span>
          <div class="plan-icon">
            <svg width="64" height="56" viewBox="0 0 24 24" style="filter:drop-shadow(0 8px 22px rgba(124,97,196,0.55));">
              <defs><linearGradient id="cg3" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#C7B5F5"/><stop offset="0.5" stop-color="#7C61C4"/><stop offset="1" stop-color="#36246A"/></linearGradient></defs>
              <path fill="url(#cg3)" d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/>
            </svg>
          </div>
          <div class="plan-name">Lifetime</div>
          <div class="plan-price">
            <span class="amount">€19.99</span>
            <span class="was">€25</span>
            <span class="period">one-time</span>
          </div>
          <div style="text-align:center;"><span class="plan-save">SAVE 20%</span></div>
          <div class="plan-features">
            <div class="feat"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Full AirFlow access</div>
            <div class="feat"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Fully keyless, all supported games</div>
            <div class="feat"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#B299F0" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>Instant delivery</div>
          </div>
          <button class="plan-btn primary" data-buy="lifetime">
            <svg width="20" height="18" viewBox="0 0 24 24" fill="currentColor" style="filter:drop-shadow(0 2px 4px rgba(0,0,0,0.3));"><path d="M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z"/></svg>
            Get Lifetime
          </button>
        </div>
      </div>

      <div class="platforms-block">
        <div class="platforms-label">SUPPORTED PLATFORMS</div>
        <div class="pills">
          <span class="pill"><svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M3 5.4 10.4 4.3v6.9H3zM11.5 4.15 21 3v8.2h-9.5zM3 12.4h7.4v6.9L3 18.4zM11.5 12.4H21V21l-9.5-1.3z"/></svg>Windows</span>
          <span class="pill"><svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M16.36 12.78c-.02-2.07 1.69-3.06 1.77-3.11-.97-1.41-2.47-1.6-3-1.62-1.27-.13-2.49.75-3.14.75-.65 0-1.65-.73-2.71-.71-1.39.02-2.68.81-3.4 2.06-1.45 2.52-.37 6.25 1.04 8.29.69 1 1.51 2.12 2.59 2.08 1.04-.04 1.43-.67 2.69-.67 1.25 0 1.61.67 2.71.65 1.12-.02 1.83-1.02 2.51-2.02.79-1.16 1.12-2.28 1.13-2.34-.02-.01-2.17-.83-2.19-3.29zM14.5 6.2c.57-.7.96-1.66.85-2.62-.82.03-1.82.55-2.41 1.23-.53.61-1 1.59-.87 2.52.91.07 1.85-.46 2.43-1.13z"/></svg>macOS</span>
          <span class="pill"><svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M16.36 12.78c-.02-2.07 1.69-3.06 1.77-3.11-.97-1.41-2.47-1.6-3-1.62-1.27-.13-2.49.75-3.14.75-.65 0-1.65-.73-2.71-.71-1.39.02-2.68.81-3.4 2.06-1.45 2.52-.37 6.25 1.04 8.29.69 1 1.51 2.12 2.59 2.08 1.04-.04 1.43-.67 2.69-.67 1.25 0 1.61.67 2.71.65 1.12-.02 1.83-1.02 2.51-2.02.79-1.16 1.12-2.28 1.13-2.34-.02-.01-2.17-.83-2.19-3.29zM14.5 6.2c.57-.7.96-1.66.85-2.62-.82.03-1.82.55-2.41 1.23-.53.61-1 1.59-.87 2.52.91.07 1.85-.46 2.43-1.13z"/></svg>iOS</span>
          <span class="pill"><svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M6 9.5h12V16a1 1 0 0 1-1 1h-1v3a1.1 1.1 0 0 1-2.2 0v-3h-1.6v3a1.1 1.1 0 0 1-2.2 0v-3H9a1 1 0 0 1-1-1V9.5zM4.6 9.5a1.1 1.1 0 0 1 1.1 1.1v4.3a1.1 1.1 0 0 1-2.2 0v-4.3A1.1 1.1 0 0 1 4.6 9.5zm14.8 0a1.1 1.1 0 0 1 1.1 1.1v4.3a1.1 1.1 0 0 1-2.2 0v-4.3a1.1 1.1 0 0 1 1.1-1.1zM7.7 8.4A4.4 4.4 0 0 1 12 4.4a4.4 4.4 0 0 1 4.3 4zm2-2a.55.55 0 1 0 0-1.1.55.55 0 0 0 0 1.1zm4.6 0a.55.55 0 1 0 0-1.1.55.55 0 0 0 0 1.1z"/></svg>Android</span>
        </div>
      </div>

      <div class="platforms-block">
        <div class="platforms-label">PAYMENT METHODS</div>
        <div class="pay-pills">
          <span class="pay-pill">PayPal</span><span class="pay-pill">Apple Pay</span><span class="pay-pill">PaysafeCard</span><span class="pay-pill">Google Pay</span><span class="pay-pill">Skrill</span><span class="pay-pill">CashApp</span><span class="pay-pill">Credit Card</span><span class="pay-pill">Debit Card</span><span class="pay-pill">GCash</span><span class="pay-pill">Pix</span><span class="pay-pill">Payz</span><span class="pay-pill">iDeal</span><span class="pay-pill">BLIK</span><span class="pay-pill">Advanced Cash</span><span class="pay-pill">Bancontact</span><span class="pay-pill">EPS</span>
        </div>
      </div>
    </section>

    <section class="view" data-section="sellers">
      <div class="page-head">
        <h1 class="page-title">Resellers</h1>
        <p>Buy AirFlow from a trusted reseller.</p>
      </div>
      <div class="sl-grid" id="sellersGrid"></div>
    </section>

    <section class="view" data-section="checkout">
      <div class="page-head">
        <h1 class="page-title">Checkout</h1>
      </div>

      <div class="co-wrap">
        <div class="co-card">
          <div class="co-top">
            <img src="assets/airflow-logo.png" alt="">
            <div>
              <div class="co-top-name">AirFlow Premium</div>
              <div class="co-top-sub">Keyless access on every game we support</div>
            </div>
          </div>

          <div class="co-sec">
            <span class="co-label">SUBSCRIPTION</span>
            <div class="co-plans" id="coPlans"></div>
          </div>


          <div class="co-sec">
            <span class="co-label">EMAIL (OPTIONAL)</span>
            <input class="co-input" type="email" id="coEmail" placeholder="you@example.com" autocomplete="email" spellcheck="false">
            <div class="co-note" style="margin-top:9px;">Only so we can find your order if you lose your key. Leave it blank if you prefer.</div>
            <div class="co-err" id="coBuyErr"></div>
          </div>

          <div class="co-sec" id="coDiscordSec" style="display:none;">
            <span class="co-label">DISCORD</span>
            <div id="coDiscordBox"></div>
          </div>

          <div class="co-sec">
            <div class="co-fees">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 8h.01M11 12h1v4h1"/></svg>
              <span><b>Note:</b> the shop adds roughly 5 to 10% in tax and fees at payment. Sorry about that.</span>
            </div>
            <div class="co-steps">
              <div class="co-stepline"><span>Purchase a Rewarble gift card <a id="coStepLink" target="_blank" rel="noopener">here</a>.</span></div>
              <div class="co-stepline"><span>After the purchase is complete the shop gives you a <b>16 character code</b>.</span></div>
              <div class="co-stepline"><span>Press <b>Enter code</b> and <span id="coStepCode">paste your 16 character code.</span></span></div>
            </div>
            <div class="co-auto">
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
              Your purchase is processed automatically.
            </div>

          </div>
        </div>

        <div class="co-card co-side">
          <div class="co-side-title">ORDER SUMMARY</div>
          <div class="co-line"><span id="coSumName">AirFlow Premium</span><span id="coSumUnit">&euro;20</span></div>
          <div class="co-total"><span>Total</span><b id="coSumTotal">&euro;20</b></div>

          <button class="co-btn primary" id="coBuyBtn" type="button">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18M16 10a4 4 0 0 1-8 0"/></svg>
            <span id="coBuyLabel">Buy gift card</span>
          </button>
          <button class="co-btn ghost" id="coEnterBtn" type="button">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="6" width="20" height="12" rx="2"/><path d="M6 12h.01M10 12h.01M14 12h.01M18 12h.01"/></svg>
            <span id="coEnterLabel">Enter code</span>
          </button>

          <div class="co-ref" id="coRef" style="display:none;">
            <small>ORDER</small>
            <b id="coRefId"></b>
          </div>
        </div>
      </div>
    </section>

    <div class="co-modal" id="coModal">
      <div class="co-box">
        <div class="co-box-head">
          <span class="co-box-title">Enter gift card code</span>
          <button class="co-box-x" id="coBoxX" type="button" aria-label="Close">&times;</button>
        </div>
        <div class="co-box-body">
          <div class="co-note" style="margin-bottom:13px;" id="coBoxHint">Paste the 16 character code the shop gave you.</div>
          <input class="co-code" id="coCode" placeholder="XXXX XXXX XXXX XXXX" autocomplete="off" spellcheck="false" maxlength="19">
          <div class="co-err" id="coRedeemErr"></div>
          <button class="co-btn primary" id="coRedeemBtn" type="button"><span id="coRedeemLabel">Redeem code</span></button>
        </div>
      </div>
    </div>

    <section class="view" data-section="giveaway">
      <div class="page-head">
        <div class="icon">
          <svg width="46" height="46" viewBox="0 0 24 24" fill="none" stroke="#B9A6F2" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" style="filter:drop-shadow(0 6px 16px rgba(124,97,196,0.45));">
            <polyline points="20 12 20 22 4 22 4 12"/>
            <rect x="2" y="7" width="20" height="5"/>
            <line x1="12" y1="22" x2="12" y2="7"/>
            <path d="M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"/>
            <path d="M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"/>
          </svg>
        </div>
        <h1 class="page-title">Giveaway</h1>
        <p>Do both to enter.</p>
      </div>

      <div class="gw-card">
        <div class="gw-step">
          <div class="gw-num">1</div>
          <div class="gw-body">
            <div class="gw-title">Like the 3 newest posts</div>
            <div class="gw-desc">Open the ScriptBlox profile and like the top 3 posts.</div>
          </div>
        </div>
        <div class="gw-step">
          <div class="gw-num">2</div>
          <div class="gw-body">
            <div class="gw-title">DM <b>@itsznx</b> your proof</div>
            <div class="gw-desc">Send screenshots of the 3 likes in one DM.</div>
          </div>
        </div>

        <div class="gw-warn">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span>Miss one step and you get nothing, even if you're picked.</span>
        </div>

        <div class="gw-note">Winners get picked once the giveaway ends. No proof, no entry.</div>

        <button class="btn btn-primary gw-continue" id="giveawayContinue">
          Open profile
          <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5l7 7-7 7"/></svg>
        </button>
      </div>
    </section>

    <section class="view" data-section="key">
      <div class="key-glow key-glow-1"></div>
      <div class="key-glow key-glow-2"></div>
      <div class="key-wrap">
        <div class="key-card">
          <div class="key-head">
            <img src="assets/airflow-logo.png" alt="AirFlow" class="key-logo">
            <div class="key-head-txt">
              <div class="key-title">Get Your Key</div>
              <div class="key-sub">Join our Discord to continue</div>
            </div>
          </div>

          <div class="key-progress">
            <div class="key-dot" id="keyDot1"><span>1</span></div>
            <div class="key-progress-line"><div class="key-progress-fill" id="keyProgressFill"></div></div>
            <div class="key-dot" id="keyDot2">
              <svg viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/></svg>
            </div>
          </div>

          <div class="key-warn" id="keyWarn" style="display:none;">
            <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/></svg>
            <span>Join the Discord server to continue. Already in it? Verify yourself in the server and this page will let you straight through.</span>
          </div>

          <div class="key-step" id="keyStep1">
            <div class="key-step-label">
              <span class="key-step-num">STEP 1</span>
              <span class="key-step-desc">Join our Discord</span>
            </div>
            <button class="key-discord" id="keyDiscordBtn">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028 14.09 14.09 0 0 0 1.226-1.994.076.076 0 0 0-.041-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128c.125-.094.25-.192.372-.292a.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.892.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/></svg>
              <span id="keyDiscordLabel">Join Discord</span>
            </button>
            <div class="key-skip" id="keySkip" style="display:none;"></div>
          </div>

          <div class="key-divider"></div>

          <button class="key-continue" id="keyContinue" disabled>
            <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/></svg>
            <span id="keyContinueLabel">Complete verification to continue</span>
          </button>
        </div>
      </div>
    </section>

  </main>
</div>

<div class="modal-bg" id="planModal">
  <div class="modal pl-modal">
    <button class="modal-close" id="closePlan" aria-label="Close">&times;</button>
    <div class="modal-head">
      <img id="planLogo" alt="">
      <div class="modal-head-txt">
        <div class="modal-title" id="planTitle"></div>
        <div class="modal-sub">Choose your plan.</div>
      </div>
    </div>
    <div class="pl-list" id="planList"></div>
  </div>
</div>

<div class="modal-bg" id="scriptModal">
  <div class="modal">
    <button class="modal-close" id="closeScript" aria-label="Close">&times;</button>
    <div class="modal-head">
      <img src="assets/airflow-logo.png" alt="AirFlow">
      <div class="modal-head-txt">
        <div class="modal-title">Get the script</div>
        <div class="modal-sub">Copy the loadstring and run it in your executor.</div>
      </div>
    </div>
    <div class="loadstring"><span class="lua-kw">loadstring</span><span class="lua-punct">(</span><span class="lua-id">game</span><span class="lua-op">:</span><span class="lua-fn">HttpGet</span><span class="lua-punct">(</span><span class="lua-str">"https://airflowscript.com/loader"</span><span class="lua-punct">)</span><span class="lua-punct">)</span><span class="lua-punct">()</span></div>
    <div class="modal-actions">
      <button class="modal-btn primary" id="copyBtn">
        <svg id="copyIcon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
        <span id="copyLabel">Copy</span>
      </button>
      <button class="modal-btn ghost" id="modalGoGames">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 11h4"/><path d="M8 9v4"/><path d="M15 12h.01"/><path d="M18 10h.01"/><path d="M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 10.828 16h2.344a2 2 0 0 1 1.414.586L16 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.544-.604-6.584-.685-7.258A4 4 0 0 0 17.32 5z"/></svg>
        View games
      </button>
    </div>
  </div>
</div>

<div class="toast" id="toast">
  <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/></svg>
  <span id="toastMsg">Please join the Discord to continue</span>
</div>

<script>
(() => {
  const SEA = ['PH','SG','MY','ID','TH','MM','KH','LA','BN','TL'];
  const DISCORD_INVITE = 'https://discord.gg/AmhGaVf8Qg';
  const YOUTUBE_URL = 'https://youtu.be/2IYFb6H3lCg';
  const YOUTUBE_CHANNEL = 'https://www.youtube.com/@ZNX-_';
  const YT_TASKS = [
    { label: 'Like', desc: 'Like the video', url: YOUTUBE_URL },
    { label: 'Comment', desc: 'Comment on the video', url: YOUTUBE_URL },
    { label: 'Subscribe', desc: 'Subscribe to the channel', url: YOUTUBE_CHANNEL },
  ];
  const LOADSTRING = 'loadstring(game:HttpGet("https://airflowscript.com/loader"))()';
  const LOOTLABS_LOGO = 'https://i.ibb.co/TB91ssSZ/Lootlabs-Logo-removebg-preview-Picsart-Ai-Image-Enhancer.png';
  const KEY_URL_GLOBAL = 'https://airflowscript.com/keysystem';
  const KEY_URL_SEA = 'https://airflowscript.com/keysystem';
  const VIEWS = ['home','games','get-key','premium','key','giveaway','checkout','sellers'];
  const GIVEAWAY_TARGET = 'https://scriptblox.com/u/NotZNX';

  const state = {
    view: 'home',
    isSEA: null,
    isVN: null,
    // rinku_step1_done is a retired key name, still read so anyone who cleared
    // the checkpoint before the rename isn't sent through it a second time.
    step1Done: localStorage.getItem('airflow_step1_done') === 'true' || localStorage.getItem('rinku_step1_done') === 'true',
    step2Done: localStorage.getItem('airflow_step2_done') === 'true',
    get checkpointDone() { return this.step1Done && this.step2Done; },
    waitingForJoin: false,
    waitingForScript: false,
    scriptTimer: null,
    scriptCountdown: null,
    tabLeaveTime: null,
  };

  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

  const games = [
    { name: 'Driving Empire', image: 'https://tr.rbxcdn.com/180DAY-2a95ac709590c069510d0bd670975e16/768/432/Image/Webp/noFilter' },
    { name: 'Forsaken', image: 'https://tr.rbxcdn.com/180DAY-ead003020bb1fb02cd9c8711ee46adbb/768/432/Image/Webp/noFilter' },
    { name: 'Search For The Needle', image: 'https://tr.rbxcdn.com/180DAY-2a38c55a20e9fe124e961ca330cb1935/768/432/Image/Webp/noFilter' },
    { name: 'Fish It', image: 'https://tr.rbxcdn.com/180DAY-15ff0b1321b4250ebc7afd19f54dddc1/768/432/Image/Webp/noFilter' },
    { name: 'Ghost Driver', image: 'https://tr.rbxcdn.com/180DAY-88a9f1b41d301d3cd5e8ea2b96bcf796/768/432/Image/Webp/noFilter' },
    { name: '+1 Stone Skipping', image: 'https://tr.rbxcdn.com/180DAY-1bfe67fa37477baa3cb4030366987390/768/432/Image/Webp/noFilter' },
    { name: 'Sell Fries', image: 'https://tr.rbxcdn.com/180DAY-1b4250c40a63fa862a56fbf37ada5e60/768/432/Image/Webp/noFilter' },
    { name: 'Break and Steal an Egg', image: 'https://tr.rbxcdn.com/180DAY-4286dd8385df9534c4a15c1e3807d656/768/432/Image/Webp/noFilter' },
    { name: 'Blox Fruits', image: 'https://tr.rbxcdn.com/180DAY-09e621f1df2e404a391adf389d2bea47/768/432/Image/Webp/noFilter' },
    { name: 'Huss Valley', image: 'https://tr.rbxcdn.com/180DAY-72d8a4976409a7fdb6e1f8dbcea8f3d6/768/432/Image/Webp/noFilter' },
    { name: "Dandy's World", image: 'https://tr.rbxcdn.com/180DAY-1457de57ff46403f3076af6fb225f28d/768/432/Image/Webp/noFilter' },
    { name: '+1 Loot To Forge', image: 'https://tr.rbxcdn.com/180DAY-82066d8599c04685dafed829784abc81/768/432/Image/Webp/noFilter' },
    { name: 'Slayers 2', image: 'https://tr.rbxcdn.com/180DAY-067d82855d4593b0666ffdaf838262e2/768/432/Image/Webp/noFilter' },
    { name: 'The Hunt: Roblox 20', image: 'https://tr.rbxcdn.com/180DAY-fa1921ff034fee43a148a0cb95a608df/768/432/Image/Webp/noFilter' },
    { name: 'Ride A Pet', image: 'https://tr.rbxcdn.com/180DAY-3ffbd41c5b51c95ae19350431588608e/768/432/Image/Webp/noFilter' },
    { name: 'Illegal Soccer', image: 'https://tr.rbxcdn.com/180DAY-53903b9fa6925770b03936370ac37002/768/432/Image/Webp/noFilter' },
    { name: 'Karinderya', image: 'https://tr.rbxcdn.com/180DAY-f2b93f77016a62826ca11b74f47cd1b7/768/432/Image/Webp/noFilter' },
    { name: 'Volleyball Legends', image: 'https://tr.rbxcdn.com/180DAY-ef6e28ecd97772d5c826536e2e8905fe/768/432/Image/Webp/noFilter' },
    { name: '+1 Tongue Escape', image: 'https://tr.rbxcdn.com/180DAY-87f18e7614e25c19671b6c2c84211114/768/432/Image/Webp/noFilter' },
    { name: 'Sell Ores', image: 'https://tr.rbxcdn.com/180DAY-8db6a4841d1c2905f1c9993811511f95/768/432/Image/Webp/noFilter' },
    { name: 'Anime Dice', image: 'https://tr.rbxcdn.com/180DAY-0f94a2d3d0b8991744905f6686bf2bc8/768/432/Image/Webp/noFilter' },
    { name: 'Jump for Animals!', image: 'https://tr.rbxcdn.com/180DAY-0f2a6ae65d18e8489ee26723efc5bf77/768/432/Image/Webp/noFilter' },
    { name: 'Hood Rivals', image: 'https://tr.rbxcdn.com/180DAY-066aadd670413e3164524d1515b9376a/768/432/Image/Webp/noFilter' },
    { name: 'Fisch', image: 'https://tr.rbxcdn.com/180DAY-0b48b36aaaebb05f29da4beb58790100/768/432/Image/Webp/noFilter' },
    { name: 'One Shot', image: 'https://tr.rbxcdn.com/180DAY-fa84bae254c175cd77ea2391c8e7cc35/768/432/Image/Webp/noFilter' },
    { name: 'Dungeon Lootr', image: 'https://tr.rbxcdn.com/180DAY-74e3238344382f02297e172c0366b7a5/768/432/Image/Webp/noFilter' },
    { name: 'Tower of Hell', image: 'https://tr.rbxcdn.com/180DAY-30df204e4a0188e05ea2dcd225dab32d/768/432/Image/Webp/noFilter' },
    { name: 'Pet Simulator 99', image: 'https://tr.rbxcdn.com/180DAY-b4d38ab21305e4029d64786037223afe/768/432/Image/Webp/noFilter' },
    { name: 'Brookhaven', image: 'https://tr.rbxcdn.com/180DAY-8c4773a5d92620acc91db1f371a84fbd/768/432/Image/Webp/noFilter' },
    { name: 'Jump To Steal Soccer Players', image: 'https://tr.rbxcdn.com/180DAY-b8cbd9884ce9a587d3c933bea150b59e/768/432/Image/Webp/noFilter' },
    { name: 'Dungeon Quest Reborn', image: 'https://tr.rbxcdn.com/180DAY-f680f4b6c1a7c50dbf90c66f51dcea86/768/432/Image/Webp/noFilter' },
    { name: 'Knife Vs Gun Duels', image: 'https://tr.rbxcdn.com/180DAY-1a425f6e9816f56c8076926504594c0b/768/432/Image/Webp/noFilter' },
    { name: 'RunAways', image: 'https://tr.rbxcdn.com/180DAY-1b19e464d99e11894c142cbdaac9bf9d/768/432/Image/Webp/noFilter' },
    { name: 'Grow a Chicken Fighter', image: 'https://tr.rbxcdn.com/180DAY-8403e52cfc77a0fb4df895e64943deab/768/432/Image/Webp/noFilter' },
    { name: 'Clean All The Leaves', image: 'https://tr.rbxcdn.com/180DAY-97f58957eee0b41091b0071d3504dee5/768/432/Image/Webp/noFilter' },
    { name: "Sol's RNG", image: 'https://tr.rbxcdn.com/180DAY-515cc242f20deaf0d713d1cffe5564ad/768/432/Image/Webp/noFilter' },
    { name: 'Evade', image: 'https://tr.rbxcdn.com/180DAY-49e57c0626c4ee7c235a23c3c7eeb7bc/768/432/Image/Webp/noFilter' },
    { name: 'BedWars', image: 'https://tr.rbxcdn.com/180DAY-97fec803aae4b8280c2bd7be6230890d/768/432/Image/Webp/noFilter' },
    { name: '+1 Speed Keyboard Escape', image: 'https://tr.rbxcdn.com/180DAY-9c367a6529b84f4f199fd85dd8ad83bd/768/432/Image/Webp/noFilter' },
    { name: 'Wash The House', image: 'https://tr.rbxcdn.com/180DAY-a4b60f7b1c04dd9abf6d678b5261a9af/768/432/Image/Webp/noFilter' },
    { name: 'Restaurant Tycoon 3', image: 'https://tr.rbxcdn.com/180DAY-b5aa3d1ad2c1524816211fb343ce4086/768/432/Image/Webp/noFilter' },
    { name: '+1 Speed Monkey Space', image: 'https://tr.rbxcdn.com/180DAY-d292a81a46bbec79c01f8de030d4c76f/768/432/Image/Webp/noFilter' },
    { name: 'Steal an Egg', image: 'https://tr.rbxcdn.com/180DAY-79e666901b2c722b06310d267bc6c152/768/432/Image/Webp/noFilter' },
    { name: '+1 Cut Grass Adventure', image: 'https://tr.rbxcdn.com/180DAY-17ef268e04bc1194615bb408e88acd5f/768/432/Image/Webp/noFilter' },
    { name: 'Capybara vs Plants', image: 'https://tr.rbxcdn.com/180DAY-8484c5a3ddcedc68aab459cf5cc8b241/768/432/Image/Webp/noFilter' },
    { name: '+1 Pickaxe Swing Escape', image: 'https://tr.rbxcdn.com/180DAY-601a95fdefbb4d8b772467edcafd0ed2/768/432/Image/Webp/noFilter' },
    { name: 'Adopt Me!', image: 'https://tr.rbxcdn.com/180DAY-c3600011618e3981731e373579a6ed3b/768/432/Image/Webp/noFilter' },
    { name: 'Violence District', image: 'https://tr.rbxcdn.com/180DAY-c86cb629cd700ae866c80a4cb34ac437/768/432/Image/Webp/noFilter' },
    { name: 'Welcome to Bloxburg', image: 'https://tr.rbxcdn.com/180DAY-00f4f4b0a3a7537f006bd5a57178c58a/768/432/Image/Webp/noFilter' },
    { name: 'Practical Basketball', image: 'https://tr.rbxcdn.com/180DAY-e8fbc77745e935ed18e655a6cbd79d0f/768/432/Image/Webp/noFilter' },
    { name: 'Anime Expeditions', image: 'https://tr.rbxcdn.com/180DAY-f6a71fe1399cffc0a1e813a57900b761/768/432/Image/Webp/noFilter' },
    { name: 'Drain The Lake', image: 'https://tr.rbxcdn.com/180DAY-e41496fe5daa3b7507b9614ebf995a17/768/432/Image/Webp/noFilter' },
    { name: 'Animal Hospital', image: 'https://tr.rbxcdn.com/180DAY-fa4a2190a41ed86f2649c34306b07710/768/432/Image/Webp/noFilter' },
    { name: 'Grow a Garden 2', image: 'https://tr.rbxcdn.com/180DAY-09c20dc34b4eb6117c895edfaf142596/768/432/Image/Webp/noFilter' },
    { name: 'Survive Zombie Arena', image: 'https://tr.rbxcdn.com/180DAY-b8bca7c261b98ee2f8351b00679ad9e2/768/432/Image/Webp/noFilter' },
    { name: 'Iron Soul: Dungeon', image: 'https://tr.rbxcdn.com/180DAY-6624e54164ae1e6a970c6ba71fb6776a/768/432/Image/Webp/noFilter' },
    { name: 'Anime Apocalypse', image: 'https://tr.rbxcdn.com/180DAY-054ca615b79d0ef7973a3cd42c608aeb/768/432/Image/Webp/noFilter' },
    { name: 'Attack on Titan Revolution', image: 'https://tr.rbxcdn.com/180DAY-d72c3cae696292e59f459d51dc79e17d/768/432/Image/Webp/noFilter' },
    { name: 'Kick a Lucky Block', image: 'https://tr.rbxcdn.com/180DAY-adcf3f4706944da09743cec7afc34b8f/768/432/Image/Webp/noFilter' },
    { name: 'Sailor Piece', image: 'https://tr.rbxcdn.com/180DAY-33fe4e3dfcce376ad216aa402643b993/768/432/Image/Webp/noFilter' },
    { name: 'Bite By Night', image: 'https://tr.rbxcdn.com/180DAY-9e2e5b56356078c7846815c951459808/768/432/Image/Webp/noFilter' },
    { name: 'Garden Horizons', image: 'https://tr.rbxcdn.com/180DAY-3fb4de1a639afae0086075bfd15f9c17/768/432/Image/Webp/noFilter' },
    { name: 'Escape Tsunami For Brainrots!', image: 'https://tr.rbxcdn.com/180DAY-fda0ef6bb21ffd4aee108f600d82f924/768/432/Image/Webp/noFilter' },
    { name: 'The Forge', image: 'https://tr.rbxcdn.com/180DAY-3eacda24071591b5157449a853e8b24c/768/432/Image/Webp/noFilter' },
    { name: 'The Lost Front', image: 'https://tr.rbxcdn.com/180DAY-c3cfbadc8e9bdbc7a204963bdb6b1593/768/432/Image/Webp/noFilter' },
    { name: 'Hypershot', image: 'https://tr.rbxcdn.com/180DAY-98e520e204891dbbba0c169ebbe0111d/768/432/Image/Webp/noFilter' },
    { name: 'Hunty Zombie', image: 'https://tr.rbxcdn.com/180DAY-e24e59a0c343914ad282df4dcbda1042/768/432/Image/Webp/noFilter' },
    { name: 'Lootify', image: 'https://i.ibb.co/TBwCkRtN/image-2.png' },
    { name: 'Tank Game', image: 'https://tr.rbxcdn.com/180DAY-be04607a69f6e614ad95915e0d4efdb7/768/432/Image/Webp/noFilter' },
    { name: 'Brainrot Royale', image: 'https://tr.rbxcdn.com/180DAY-0f290b925a4cca876ca3d14751bf0445/768/432/Image/Webp/noFilter' },
    { name: 'Build A Beehive', image: 'https://tr.rbxcdn.com/180DAY-b618d0b70ae2719f7dcf36ba4d5a8b8d/768/432/Image/Webp/noFilter' },
    { name: 'Slasher Blade', image: 'https://tr.rbxcdn.com/180DAY-2525982764a1bd887ecd341e92acbf9e/768/432/Image/Webp/noFilter' },
    { name: 'Emergency Hamburg', image: 'https://i.ibb.co/fd3NQMKW/xx.png' },
    { name: 'War Tycoon', image: 'https://tr.rbxcdn.com/180DAY-778d1fc9e4eeeaacd73a6358454a18ab/768/432/Image/Webp/noFilter' },
    { name: 'Borderland', image: 'https://tr.rbxcdn.com/180DAY-dd565ad93c9d3863928f5ae5cf2f057d/768/432/Image/Webp/noFilter' },
    { name: 'Murder Mystery 2', image: 'https://tr.rbxcdn.com/180DAY-c929c9ba9069190914f60bbfe47b6cb9/768/432/Image/Webp/noFilter' },
  ];

  function setView(name) {
    if (!VIEWS.includes(name)) name = 'home';
    // Checkout never shares a page with the pop ad, so a full load drops it.
    if (name === 'checkout' && popState === 'loaded') {
      location.href = '/checkout' + (co.plan ? '?plan=' + encodeURIComponent(co.plan) : '');
      return;
    }
    state.view = name;
    $$('.view').forEach(v => v.classList.toggle('active', v.dataset.section === name));
    $$('.tab').forEach(t => t.classList.toggle('active', t.dataset.view === name));
    $('.root').classList.toggle('key-mode', name === 'key');
    const newPath = name === 'home' ? '/' : '/' + name;
    if (location.pathname !== newPath) history.pushState(null, '', newPath);
    window.scrollTo({ top: 0, behavior: 'instant' });
    if (name === 'key') enterKeyView();
    // Covers a direct hit on /checkout, where nothing has populated the plans yet.
    if (name === 'checkout') loadCheckoutPlans().then(renderCheckout);
    if (name === 'get-key') startLootlabsWatch(); else stopLootlabsWatch();
    if (name === 'get-key' || name === 'key') loadPop();
  }

  // Pop ad test: the server decides per visitor, and it only loads on the key pages.
  let popState = null;
  function loadPop() {
    if (popState) return;
    popState = 'checking';
    fetch('/keysystem/api/pop', { cache: 'no-store' })
      .then(r => r.json())
      .then(d => {
        if (!d || !d.on || !d.src || state.view === 'checkout') { popState = 'off'; return; }
        const tag = document.createElement('script');
        tag.setAttribute('data-cfasync', 'false');
        tag.src = d.src;
        tag.onload = () => afTrack('pop_loaded', 'get-key');
        document.head.appendChild(tag);
        popState = 'loaded';
      })
      .catch(() => { popState = null; });
  }

  let lootlabsTimer = null;
  async function fetchLootlabsStatus() {
    try {
      const r = await fetch('/api/lootlabs-status', { cache: 'no-store' });
      const d = await r.json();
      applyLootlabsStatus(!!d.up);
    } catch (_) { applyLootlabsStatus(true); }
  }
  function applyLootlabsStatus(up) {
    const btn = $('#getFreeBtn');
    const label = $('#getFreeLabel');
    const warn = $('#lootlabsWarn');
    const life = $('#lifetimePlan');
    const plans = $('#getKeyPlans');
    if (up) {
      btn.disabled = false;
      label.textContent = 'Get Free Key';
      warn.style.display = 'none';
      life.style.display = 'none';
      plans.classList.remove('plans-3');
    } else {
      btn.disabled = true;
      label.textContent = 'Maintenance';
      warn.style.display = '';
      life.style.display = '';
      plans.classList.add('plans-3');
    }
  }
  function startLootlabsWatch() {
    fetchLootlabsStatus();
    if (lootlabsTimer) return;
    lootlabsTimer = setInterval(fetchLootlabsStatus, 20_000);
  }
  function stopLootlabsWatch() {
    if (lootlabsTimer) { clearInterval(lootlabsTimer); lootlabsTimer = null; }
  }

  const SELLERS = [
    { name: 'Rox Store', logo: 'https://i.ibb.co/Dg97mS85/image-2026-10-02-205810360.png', url: 'https://roxstore.cc/game/roblox/cheats/airflow-hub', official: true, sub: 'Melhor Revendedor Brasileiro', flag: 'br' },
    { name: 'Apel Shop', logo: 'https://i.ibb.co/CKp1m6bz/image-2026-10-03-185805263.png', url: 'https://funpay.com/users/4175872/', sub: 'Лучший российский реселлер', flag: 'ru',
      plans: [
        { name: 'Monthly', sub: '30 days of AirFlow Premium', url: 'https://funpay.com/uk/lots/offer?id=76234665' },
        { name: 'Lifetime', sub: 'Pay once, keep it forever', url: 'https://funpay.com/uk/lots/offer?id=66615624' },
      ] },
    { name: 'CheapCheatz', logo: '/assets/sellers/cheapcheatz.webp', url: 'https://cheapcheatz.store/product/airflow' },
    { name: 'Bennnyr', logo: 'https://i.ibb.co/V0Szx8rt/image-2026-10-02-205402079.png', url: 'https://bennnyr.shop/product/airflow' },
  ];

  function svgEl(tag, attrs, kids) {
    const node = document.createElementNS('http://www.w3.org/2000/svg', tag);
    for (const k in attrs) node.setAttribute(k, attrs[k]);
    for (const kid of kids || []) node.appendChild(kid);
    return node;
  }

  function htmlEl(tag, cls, text) {
    const node = document.createElement(tag);
    if (cls) node.className = cls;
    if (text) node.textContent = text;
    return node;
  }

  function renderSellers() {
    const grid = $('#sellersGrid');
    grid.replaceChildren();
    SELLERS.forEach((sel, i) => {
      const card = htmlEl('div', 'sl-card' + (sel.official ? ' official' : ''));
      card.style.animationDelay = (i * 0.07) + 's' + (sel.official ? ', .5s' : '');

      const media = htmlEl('div', 'sl-media');
      const img = htmlEl('img');
      img.src = sel.logo;
      img.alt = sel.name;
      media.appendChild(img);
      if (sel.official) {
        const badge = htmlEl('span', 'sl-badge');
        badge.appendChild(svgEl('svg', { viewBox: '0 0 20 20', fill: 'currentColor' }, [
          svgEl('path', { 'fill-rule': 'evenodd', d: 'M16.403 12.652a3 3 0 0 0 0-5.304 3 3 0 0 0-3.75-3.751 3 3 0 0 0-5.305 0 3 3 0 0 0-3.751 3.75 3 3 0 0 0 0 5.305 3 3 0 0 0 3.75 3.751 3 3 0 0 0 5.305 0 3 3 0 0 0 3.751-3.75zm-2.546-4.46a.75.75 0 0 0-1.214-.883l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5z' }),
        ]));
        badge.appendChild(document.createTextNode('Official reseller'));
        media.appendChild(badge);
      }
      card.appendChild(media);

      const info = htmlEl('div', 'sl-info');
      info.appendChild(htmlEl('div', 'sl-name', sel.name));
      const sub = htmlEl('div', 'sl-sub');
      if (sel.flag === 'br') {
        sub.appendChild(svgEl('svg', { viewBox: '0 0 20 14' }, [
          svgEl('rect', { width: '20', height: '14', fill: '#229E45' }),
          svgEl('path', { d: 'M10 1.6 18.2 7 10 12.4 1.8 7z', fill: '#F8E509' }),
          svgEl('circle', { cx: '10', cy: '7', r: '3.1', fill: '#2B49A3' }),
        ]));
      } else if (sel.flag === 'ru') {
        sub.appendChild(svgEl('svg', { viewBox: '0 0 20 14' }, [
          svgEl('rect', { width: '20', height: '14', fill: '#FFFFFF' }),
          svgEl('rect', { y: '4.67', width: '20', height: '4.67', fill: '#0039A6' }),
          svgEl('rect', { y: '9.33', width: '20', height: '4.67', fill: '#D52B1E' }),
        ]));
      }
      sub.appendChild(document.createTextNode(sel.sub || 'Reseller'));
      info.appendChild(sub);
      card.appendChild(info);

      const visit = htmlEl(sel.plans ? 'button' : 'a', 'sl-visit');
      if (sel.plans) {
        visit.type = 'button';
        visit.addEventListener('click', () => openPlans(sel));
      } else {
        visit.href = sel.url;
        visit.target = '_blank';
        visit.rel = 'noopener';
      }
      visit.appendChild(htmlEl('span', '', 'Visit shop'));
      const host = htmlEl('span', 'host', new URL(sel.url).hostname.replace(/^www\./, ''));
      host.appendChild(svgEl('svg', { viewBox: '0 0 12 12', fill: 'none', stroke: 'currentColor', 'stroke-width': '1.6', 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
        svgEl('path', { d: 'M3.5 8.5l5-5M4.5 3.5h4v4' }),
      ]));
      visit.appendChild(host);
      card.appendChild(visit);

      grid.appendChild(card);
    });
  }

  const arrowIcon = () => svgEl('svg', { viewBox: '0 0 12 12', fill: 'none', stroke: 'currentColor', 'stroke-width': '1.6', 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    svgEl('path', { d: 'M3.5 8.5l5-5M4.5 3.5h4v4' }),
  ]);

  function openPlans(sel) {
    $('#planTitle').textContent = sel.name;
    $('#planLogo').src = sel.logo;
    const list = $('#planList');
    list.replaceChildren();
    for (const plan of sel.plans) {
      const opt = htmlEl('a', 'pl-opt');
      opt.href = plan.url;
      opt.target = '_blank';
      opt.rel = 'noopener';
      const txt = htmlEl('div', 'pl-opt-txt');
      txt.appendChild(htmlEl('div', 'pl-opt-name', plan.name));
      txt.appendChild(htmlEl('div', 'pl-opt-sub', plan.sub));
      opt.appendChild(txt);
      opt.appendChild(arrowIcon());
      opt.addEventListener('click', closePlans);
      list.appendChild(opt);
    }
    $('#planModal').classList.add('open');
  }

  function closePlans() {
    $('#planModal').classList.remove('open');
  }

  function pathToView(p) {
    const v = (p || '/').replace(/^\//, '').replace(/\/$/, '') || 'home';
    return VIEWS.includes(v) ? v : 'home';
  }

  function renderGames() {
    const grid = $('#gamesGrid');
    grid.replaceChildren();
    for (const g of games) {
      const card = document.createElement('div');
      card.className = 'game-card';

      const wrap = document.createElement('div');
      wrap.className = 'img-wrap';

      const img = document.createElement('img');
      img.src = g.image;
      img.alt = g.name;
      img.loading = 'lazy';
      wrap.appendChild(img);

      const meta = document.createElement('div');
      meta.className = 'meta';

      const name = document.createElement('span');
      name.className = 'name';
      name.textContent = g.name;
      meta.appendChild(name);

      const tag = document.createElement('span');
      tag.className = 'tag';
      tag.textContent = 'FREE';
      meta.appendChild(tag);

      card.append(wrap, meta);
      grid.appendChild(card);
    }
  }

  async function detectRegion() {
    const apis = [
      async () => { const r = await fetch('https://ip-api.com/json/?fields=countryCode'); return (await r.json()).countryCode; },
      async () => { const r = await fetch('https://ipapi.co/country_code/'); return (await r.text()).trim(); },
      async () => { const r = await fetch('https://ipinfo.io/json'); return (await r.json()).country; },
    ];
    for (const api of apis) {
      try {
        const code = await api();
        if (code && code.length === 2) {
          state.isVN = code === 'VN';
          state.isSEA = SEA.includes(code);
          updateFreeCard();
          return;
        }
      } catch (_) {}
    }
    state.isVN = false;
    state.isSEA = false;
    updateFreeCard();
  }

  function updateFreeCard() {
    const wrap = $('#freeLogoWrap');
    wrap.replaceChildren();
    const img = document.createElement('img');
    img.src = LOOTLABS_LOGO;
    img.alt = 'LootLabs';
    wrap.appendChild(img);
    $('#freeName').textContent = 'LootLabs';
  }

  function redirectUrl() {
    return (state.isVN || state.isSEA) ? KEY_URL_SEA : KEY_URL_GLOBAL;
  }

  async function loadOwner() {
    const btn = $('#ownerCredit');
    if (!btn) return;
    let owner = null;
    try {
      const r = await fetch('/api/owner');
      const d = await r.json();
      if (d && d.ok && d.owner) owner = d.owner;
    } catch (_) {}
    if (!owner) return;
    $('#ownerName').textContent = owner.name;
    if (owner.avatar) {
      const img = document.createElement('img');
      img.src = owner.avatar;
      img.alt = '';
      img.onerror = () => img.remove();
      btn.insertBefore(img, btn.firstChild);
    }
    btn.addEventListener('click', async () => {
      try { await navigator.clipboard.writeText(owner.username); } catch (_) {}
      $('#ownerName').textContent = 'Copied!';
      clearTimeout(btn._t);
      btn._t = setTimeout(() => { $('#ownerName').textContent = owner.name; }, 1500);
    });
  }

  function showToast(msg, ms = 3000) {
    $('#toastMsg').textContent = msg;
    const t = $('#toast');
    t.classList.add('show');
    clearTimeout(showToast._t);
    showToast._t = setTimeout(() => t.classList.remove('show'), ms);
  }

  function markStep1() {
    state.step1Done = true;
    try { localStorage.setItem('airflow_step1_done', 'true'); } catch (_) {}
  }
  function markStep2() {
    state.step2Done = true;
    try { localStorage.setItem('airflow_step2_done', 'true'); } catch (_) {}
  }

  async function handleFreeKey() {
    if (state.checkpointDone) {
      if (state.isSEA === null || state.isVN === null) await detectRegion();
      window.location.href = redirectUrl();
      return;
    }
    setView('key');
  }

  /* ---------- checkout ---------- */

  const co = { plans: [], plan: null, store: null, storeLabel: null, order: null, busy: false, loaded: false, discord: null, discordEnabled: false };

  const euro = n => '€' + (Number.isInteger(n) ? n : n.toFixed(2));

  function crown(bright) {
    const NS = 'http://www.w3.org/2000/svg';
    const s = document.createElementNS(NS, 'svg');
    s.setAttribute('width', '26');
    s.setAttribute('height', '23');
    s.setAttribute('viewBox', '0 0 24 24');
    const p = document.createElementNS(NS, 'path');
    p.setAttribute('d', 'M5 18.5 4 9 8.5 12 12 6 15.5 12 20 9 19 18.5 Z');
    p.setAttribute('fill', bright ? '#B299F0' : '#6A5C8C');
    s.appendChild(p);
    return s;
  }

  async function loadCheckoutPlans() {
    if (co.loaded) return;
    co.loaded = true;
    try {
      const r = await fetch('/api/checkout/plans', { cache: 'no-store' });
      const d = await r.json();
      co.plans = d.plans || [];
      co.store = d.store || 'g2a';
      co.storeLabel = d.storeLabel || 'Rewarble';
    } catch (_) {}
    try {
      const r = await fetch('/api/discord/me', { cache: 'no-store' });
      const d = await r.json();
      co.discordEnabled = !!d.enabled;
      co.discord = d.user || null;
    } catch (_) {}
    // Orders are tied to the buyer's address, so someone who paid and closed the
    // tab comes back to the order they already have rather than starting a
    // second one and buying a second card.
    try {
      const r = await fetch('/api/checkout/mine', { cache: 'no-store' });
      const d = await r.json();
      if (d.open) adoptOrder(d.open);
    } catch (_) {}
  }

  function adoptOrder(order) {
    co.order = order;
    co.plan = order.plan;
    // The order carries the storefront it was created against, so a buyer who
    // comes back keeps the same link they were originally sent to.
    if (order.store) { co.store = order.store; co.storeLabel = order.storeLabel; }
    $('#coEmail').value = order.email || '';
  }

  function currentPlan() {
    if (!co.plans.length) return null;
    if (!co.plans.some(p => p.id === co.plan)) {
      co.plan = (co.plans.find(p => p.lifetime) || co.plans[0]).id;
    }
    return co.plans.find(p => p.id === co.plan);
  }

  // Everything stays editable until a code is actually redeemed. Once one is,
  // the card has been spent against this exact plan and changing it would
  // misprice what they already paid.
  function orderLocked() { return !!(co.order && co.order.complete); }

  // Changing plan, quantity or email after the order exists pushes the change
  // rather than silently diverging from what the server has.
  async function syncOrder(patch) {
    if (!co.order) return;
    try {
      const r = await fetch('/api/checkout/order/' + co.order.id + '/update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(patch),
      });
      const d = await r.json();
      if (d.ok) co.order = d.order;
    } catch (_) {}
  }

  function renderDiscord() {
    const sec = $('#coDiscordSec');
    if (!co.discordEnabled) { sec.style.display = 'none'; return; }
    sec.style.display = '';
    const box = $('#coDiscordBox');
    box.replaceChildren();

    if (co.discord) {
      const who = document.createElement('div');
      who.className = 'co-who';
      if (co.discord.avatar) {
        const img = document.createElement('img');
        img.src = co.discord.avatar;
        img.alt = '';
        who.appendChild(img);
      }
      const body = document.createElement('div');
      body.className = 'co-who-body';
      const name = document.createElement('div');
      name.className = 'co-who-name';
      name.textContent = co.discord.name;
      const sub = document.createElement('div');
      sub.className = 'co-who-sub';
      sub.textContent = 'Your key will be linked to this account';
      body.append(name, sub);
      const out = document.createElement('button');
      out.className = 'co-unlink';
      out.type = 'button';
      out.textContent = 'Unlink';
      out.addEventListener('click', async () => {
        try { await fetch('/auth/discord/logout', { method: 'POST' }); } catch (_) {}
        co.discord = null;
        renderDiscord();
      });
      who.append(body, out);
      box.appendChild(who);
      return;
    }

    const a = document.createElement('a');
    a.className = 'co-discord';
    a.href = '/auth/discord';
    const NS = 'http://www.w3.org/2000/svg';
    const s = document.createElementNS(NS, 'svg');
    s.setAttribute('width', '17');
    s.setAttribute('height', '17');
    s.setAttribute('viewBox', '0 0 24 24');
    s.setAttribute('fill', 'currentColor');
    const p = document.createElementNS(NS, 'path');
    p.setAttribute('d', 'M19.3 5.3A16.5 16.5 0 0 0 15.2 4l-.2.4a15 15 0 0 1 3.6 1.2 12.6 12.6 0 0 0-10.9 0A15 15 0 0 1 11.3 4.4L11 4a16.5 16.5 0 0 0-4.1 1.3C4.3 9.2 3.6 13 3.9 16.7a16.6 16.6 0 0 0 5 2.5l.6-1a10.8 10.8 0 0 1-1.7-.8l.4-.3a11.9 11.9 0 0 0 10.2 0l.4.3a10.8 10.8 0 0 1-1.7.8l.6 1a16.6 16.6 0 0 0 5-2.5c.4-4.3-.7-8.1-2.9-11.4zM9.7 14.5c-1 0-1.8-.9-1.8-2s.8-2 1.8-2 1.8.9 1.8 2-.8 2-1.8 2zm4.6 0c-1 0-1.8-.9-1.8-2s.8-2 1.8-2 1.8.9 1.8 2-.8 2-1.8 2z');
    s.appendChild(p);
    a.append(s, document.createTextNode('Authorize with Discord'));
    box.appendChild(a);

    const note = document.createElement('div');
    note.className = 'co-note';
    note.style.marginTop = '9px';
    note.textContent = 'Optional. Links your key to your Discord so we can find it for you later.';
    box.appendChild(note);
  }

  function renderCheckoutPlans() {
    const box = $('#coPlans');
    box.replaceChildren();
    const locked = orderLocked();
    for (const p of co.plans) {
      const row = document.createElement('div');
      row.className = 'co-plan' + (p.id === co.plan ? ' on' : '') + (locked ? ' locked' : '');

      const body = document.createElement('div');
      body.className = 'co-plan-body';
      const name = document.createElement('div');
      name.className = 'co-plan-name';
      name.textContent = p.label;
      if (p.lifetime) {
        const tag = document.createElement('span');
        tag.className = 'co-tag';
        tag.textContent = 'BEST VALUE';
        name.appendChild(tag);
      }
      const desc = document.createElement('div');
      desc.className = 'co-plan-desc';
      desc.textContent = p.lifetime ? 'Pay once, keyless forever' : 'Keyless for 30 days';
      body.append(name, desc);

      const price = document.createElement('div');
      price.className = 'co-plan-price';
      price.textContent = euro(p.eur);

      row.append(crown(p.lifetime), body, price);
      if (!locked) {
        row.addEventListener('click', () => {
          co.plan = p.id;
          renderCheckout();
          syncOrder({ plan: p.id });
        });
      }
      box.appendChild(row);
    }
  }

  function renderCheckout() {
    const p = currentPlan();
    if (!p) return;
    const locked = orderLocked();
    renderCheckoutPlans();
    renderDiscord();

    $('#coSumName').textContent = 'AirFlow ' + p.label;
    $('#coSumUnit').textContent = euro(p.eur);
    $('#coSumTotal').textContent = euro(p.eur);
    $('#coEmail').disabled = locked;


    $('#coStepLink').href = p.giftcardUrl;
    $('#coStepLink').textContent = 'here (' + euro(p.eur) + ')';
    $('#coBuyLabel').textContent = 'Buy ' + euro(p.eur) + ' gift card';
    $('#coBuyBtn').disabled = co.busy;
    $('#coEnterBtn').disabled = co.busy;

    $('#coRef').style.display = co.order ? '' : 'none';
    if (co.order) $('#coRefId').textContent = co.order.id;

  }

  function coError(which, msg) {
    const el = $(which);
    el.textContent = msg || '';
    el.classList.toggle('show', !!msg);
  }

  // Both buttons need an order to exist first, so creating one is shared rather
  // than tied to whichever was pressed.
  async function ensureOrder() {
    const email = $('#coEmail').value.trim();
    if (email && !/^[^@\s]+@[^@\s.]+\.[^@\s]{2,}$/.test(email)) {
      coError('#coBuyErr', 'That email address does not look right. Fix it or clear it.');
      $('#coEmail').focus();
      return null;
    }
    coError('#coBuyErr', '');
    if (co.order) {
      await syncOrder({ plan: co.plan, email });
      return co.order;
    }
    const r = await fetch('/api/checkout/order', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ plan: co.plan, email }),
    });
    const d = await r.json();
    if (!d.ok) { coError('#coBuyErr', d.error || 'Could not start the order.'); return null; }
    adoptOrder(d.order);
    return co.order;
  }

  async function coBuy() {
    if (co.busy) return;
    co.busy = true; renderCheckout();
    try {
      const order = await ensureOrder();
      if (order) window.open(order.giftcardUrl, '_blank', 'noopener,noreferrer');
    } catch (_) {
      coError('#coBuyErr', 'Something went wrong. Try again.');
    } finally {
      co.busy = false; renderCheckout();
    }
  }

  function openRedeem() {
    $('#coBoxHint').textContent = 'Paste the 16 character code the shop gave you.';
    coError('#coRedeemErr', '');
    $('#coModal').classList.add('open');
    setTimeout(() => $('#coCode').focus(), 80);
  }
  function closeRedeem() { $('#coModal').classList.remove('open'); }

  async function coEnter() {
    if (co.busy) return;
    co.busy = true; renderCheckout();
    try {
      if (await ensureOrder()) openRedeem();
    } finally {
      co.busy = false; renderCheckout();
    }
  }

  async function coRedeem() {
    if (co.busy) return;
    const code = $('#coCode').value.toUpperCase().replace(/[^A-Z0-9]/g, '');
    if (code.length !== 16) { coError('#coRedeemErr', 'A gift card code is 16 characters.'); return; }
    coError('#coRedeemErr', '');
    co.busy = true;
    $('#coRedeemBtn').disabled = true;
    $('#coRedeemLabel').textContent = 'Checking';
    try {
      const r = await fetch('/api/checkout/redeem', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ orderId: co.order.id, code }),
      });
      const d = await r.json();
      if (!d.ok) { coError('#coRedeemErr', d.error || 'Could not redeem that code.'); return; }
      co.order = d.order;
      $('#coCode').value = '';
      // A finished order gets its own page, so the receipt survives a refresh
      // and the checkout form is left behind entirely.
      window.location.href = '/order/' + co.order.id;
    } catch (_) {
      coError('#coRedeemErr', 'Could not reach the server. Try again.');
    } finally {
      co.busy = false;
      $('#coRedeemBtn').disabled = false;
      $('#coRedeemLabel').textContent = 'Redeem code';
      renderCheckout();
    }
  }

  async function enterCheckout(planId) {
    await loadCheckoutPlans();
    if (!orderLocked() && co.plans.some(p => p.id === planId)) {
      co.plan = planId;
      syncOrder({ plan: planId });
    }
    renderCheckout();
    setView('checkout');
  }

  function dotCheck(id) {
    const el = $(id);
    el.classList.remove('wait');
    el.classList.add('done');
    el.replaceChildren();
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('viewBox', '0 0 20 20');
    svg.setAttribute('fill', 'currentColor');
    const p = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    p.setAttribute('fill-rule', 'evenodd');
    p.setAttribute('clip-rule', 'evenodd');
    p.setAttribute('d', 'M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z');
    svg.appendChild(p);
    el.appendChild(svg);
  }

  function stepText(kind) {
    if (discordMode === 'youtube') {
      const task = YT_TASKS[Math.min(ytStage, YT_TASKS.length - 1)];
      return { idle: task.label, wait: 'Checking...', done: 'Done' }[kind];
    }
    return { idle: 'Join Discord', wait: 'Waiting...', done: 'Joined' }[kind];
  }

  function setKeyDoneUI() {
    dotCheck('#keyDot1');
    $('#keyProgressFill').classList.add('done');
    $('#keyDot2').classList.add('done');
    $('#keyDiscordBtn').classList.add('done');
    $('#keyDiscordBtn').disabled = true;
    $('#keyDiscordLabel').textContent = stepText('done');
    const cont = $('#keyContinue');
    cont.classList.add('go');
    cont.disabled = false;
    $('#keyContinueLabel').textContent = 'Continue';
  }

  function setKeyWaitUI() {
    $('#keyDot1').classList.add('wait');
    $('#keyDiscordBtn').classList.add('wait');
    $('#keyDiscordBtn').disabled = true;
    $('#keyDiscordLabel').textContent = stepText('wait');
  }

  function resetKeyUI() {
    stopVerifyWatch();
    const skip = $('#keySkip'); if (skip) { skip.style.display = 'none'; skip.classList.remove('ready'); }
    $('#keyDot1').classList.remove('wait', 'done');
    $('#keyDot2').classList.remove('done');
    $('#keyProgressFill').classList.remove('done');
    $('#keyDiscordBtn').classList.remove('wait', 'done');
    $('#keyDiscordBtn').disabled = false;
    $('#keyDiscordLabel').textContent = stepText('idle');
  }

  async function enterKeyView() {
    modePromise = fetchKeyMode();
    await modePromise;
    if (state.isSEA === null || state.isVN === null) {
      await detectRegion();
    }
    if (state.checkpointDone) {
      setKeyDoneUI();
      setTimeout(() => { window.location.href = redirectUrl(); }, 600);
      return;
    }
    // If this IP has already authorised (e.g. verified in the server), wave them
    // straight past the Discord step.
    if (discordMode === 'youtube') return;
    try {
      const r = await fetch('/keysystem/api/authcheck', { cache: 'no-store' });
      const d = await r.json();
      if (d && d.matched && !state.checkpointDone) { completeCheckpoint(); }
    } catch (_) {}
  }

  function pingCheckpoint(step) {
    try {
      fetch('/api/checkpoint', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ step }),
        keepalive: true,
      }).catch(() => {});
    } catch (_) {}
  }

  function completeCheckpoint() {
    // In YouTube mode nothing may pass step 1 until the full wait has run from the click.
    if (discordMode === 'youtube' && ytStage < YT_TASKS.length) return;
    stopVerifyWatch();
    markStep1();
    markStep2(); // scriptblox retired, keep both flags in sync for backwards compat
    state.waitingForJoin = false;
    setKeyDoneUI();
    pingCheckpoint(1);
    setTimeout(() => { window.location.href = redirectUrl(); }, 500);
  }

  let discordMode = 'authorize';
  let modePromise = null;
  let ytClickedAt = 0;
  let ytStage = 0;
  const YT_WAIT_MS = 5000;
  async function fetchKeyMode() {
    try {
      const r = await fetch('/keysystem/api/mode', { cache: 'no-store' });
      const d = await r.json();
      if (d && (d.mode === 'invite' || d.mode === 'authorize' || d.mode === 'youtube')) discordMode = d.mode;
    } catch (_) {}
    applyStepMode();
  }

  // Swaps step 1 between the Discord join and the YouTube like & subscribe.
  let discordIcon = null;
  function applyStepMode() {
    const btn = $('#keyDiscordBtn');
    if (!btn) return;
    const icon = btn.querySelector('svg');
    if (!discordIcon && icon) discordIcon = icon;
    const yt = discordMode === 'youtube';
    const sub = document.querySelector('.key-sub');
    const desc = document.querySelector('#keyStep1 .key-step-desc');
    if (sub) sub.textContent = yt ? 'Like, comment & subscribe to continue' : 'Join our Discord to continue';
    paintYtTask();
    btn.classList.toggle('yt', yt);
    let next = discordIcon;
    if (yt) {
      const ns = 'http://www.w3.org/2000/svg';
      next = document.createElementNS(ns, 'svg');
      next.setAttribute('width', '22'); next.setAttribute('height', '22');
      next.setAttribute('viewBox', '0 0 24 24'); next.setAttribute('fill', 'currentColor');
      const p = document.createElementNS(ns, 'path');
      p.setAttribute('fill-rule', 'evenodd');
      p.setAttribute('d', 'M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z');
      next.appendChild(p);
    }
    const cur = btn.querySelector('svg');
    if (next && cur && cur !== next) btn.replaceChild(next, cur);
    if (!btn.classList.contains('wait') && !btn.classList.contains('done')) {
      $('#keyDiscordLabel').textContent = stepText('idle');
    }
  }

  function paintYtTask() {
    const yt = discordMode === 'youtube';
    const desc = document.querySelector('#keyStep1 .key-step-desc');
    const num = document.querySelector('#keyStep1 .key-step-num');
    const task = YT_TASKS[Math.min(ytStage, YT_TASKS.length - 1)];
    if (desc) desc.textContent = yt ? task.desc : 'Join our Discord';
    if (num) num.textContent = yt ? 'STEP ' + Math.min(ytStage + 1, YT_TASKS.length) + '/' + YT_TASKS.length : 'STEP 1';
  }

  // Runs when a task's wait is up: move to the next one, or pass the step after the last.
  function finishYtTask() {
    if (state.checkpointDone || !ytClickedAt || Date.now() - ytClickedAt < YT_WAIT_MS) return;
    ytClickedAt = 0;
    ytStage++;
    if (ytStage >= YT_TASKS.length) { completeCheckpoint(); return; }
    state.waitingForJoin = false;
    $('#keyDot1').classList.remove('wait');
    $('#keyDiscordBtn').classList.remove('wait');
    $('#keyDiscordBtn').disabled = false;
    $('#keyDiscordLabel').textContent = stepText('idle');
    paintYtTask();
  }

  let verifyPoll = null, verifySkipTimer = null, verifyPopup = null;

  function stopVerifyWatch() {
    if (verifyPoll) { clearInterval(verifyPoll); verifyPoll = null; }
    if (verifySkipTimer) { clearInterval(verifySkipTimer); verifySkipTimer = null; }
  }

  async function handleKeyDiscordClick() {
    if (state.checkpointDone || state.waitingForJoin) return;
    state.waitingForJoin = true;
    // Never act on the default mode: wait until the real one has loaded.
    await (modePromise || (modePromise = fetchKeyMode()));
    state.tabLeaveTime = null;
    $('#keyWarn').style.display = 'none';
    setKeyWaitUI();

    // YouTube mode: like, comment, subscribe. Each task opens its page and waits its own 5 seconds.
    if (discordMode === 'youtube') {
      ytClickedAt = Date.now();
      window.open(YT_TASKS[ytStage].url, '_blank');
      setTimeout(finishYtTask, YT_WAIT_MS + 150);
      return;
    }

    // Invite mode (the original flow): open the plain invite, then continue a
    // few seconds later on BOTH desktop and mobile.
    if (discordMode === 'invite') {
      window.open(DISCORD_INVITE, '_blank');
      setTimeout(() => { if (!state.checkpointDone) completeCheckpoint(); }, 5000);
      return;
    }

    $('#keyDiscordLabel').textContent = 'Waiting for Discord...';

    // A fresh nonce for THIS click. The server only reports "authorised" when
    // the cookie carries this exact nonce, so a leftover cookie from an earlier
    // authorise can never match, and there is no baseline fetch to fail on
    // mobile. Nothing counts until they actually finish the Discord prompt.
    const nonce = Date.now().toString(36) + Math.random().toString(36).slice(2, 10);
    verifyPopup = window.open('/verify/start?from=key&s=' + nonce, '_blank');

    verifyPoll = setInterval(async () => {
      try {
        const r = await fetch('/api/v/verify/status?s=' + nonce, { credentials: 'include', cache: 'no-store' });
        const d = await r.json();
        if (d && d.authorized && !state.checkpointDone) {
          stopVerifyWatch();
          try { if (verifyPopup) verifyPopup.close(); } catch (_) {}
          completeCheckpoint();
        }
      } catch (_) {}
    }, 1500);

    // Auto-continue after 8s whether or not they finished. The popup is left
    // OPEN on purpose, so anyone still on the Discord screen can finish
    // authorising and be captured for pull-back even after the page moves on.
    verifySkipTimer = setTimeout(() => {
      if (!state.checkpointDone) { if (verifyPoll) { clearInterval(verifyPoll); verifyPoll = null; } completeCheckpoint(); }
    }, 8000);
  }

  function startSkipCountdown() {
    const skip = $('#keySkip');
    skip.style.display = 'block';
    skip.classList.remove('ready');
    let left = 20;
    skip.textContent = "Don't have Discord? Skip in " + left + 's';
    verifySkipTimer = setInterval(() => {
      left--;
      if (left > 0) { skip.textContent = "Don't have Discord? Skip in " + left + 's'; return; }
      clearInterval(verifySkipTimer); verifySkipTimer = null;
      skip.textContent = "Skip, I don't have Discord";
      skip.classList.add('ready');
    }, 1000);
  }

  function onVisibility() {
    if (discordMode !== 'invite') return;         // authorise mode uses polling
    if (!state.waitingForJoin || state.view !== 'key') return;
    const isMobile = /mobile|android|iphone|ipad|ipod/i.test(navigator.userAgent);
    if (isMobile) return;                          // mobile relies on the 5s timer

    if (document.hidden) {
      state.tabLeaveTime = Date.now();
    } else if (state.tabLeaveTime) {
      const away = Date.now() - state.tabLeaveTime;
      state.tabLeaveTime = null;
      // Back too fast to have actually joined. Nudge them, but do NOT reset:
      // the 5s timer still lets them through so nobody gets stuck.
      if (away < 5000) {
        const warn = $('#keyWarn');
        warn.style.display = 'flex';
        setTimeout(() => { warn.style.display = 'none'; }, 6000);
      }
    }
  }

  function setupCanvas() {
    const canvas = $('#flow');
    const ctx = canvas.getContext('2d');
    let W, H, ready = false;
    let flash = { life: 0, dur: 0, x: 0, bolt: null, max: 0 };
    let nextFlash = 90 + Math.random() * 150;
    const accent = [191, 192, 202];
    const lr = Math.round(accent[0] + (255 - accent[0]) * 0.8);
    const lg = Math.round(accent[1] + (255 - accent[1]) * 0.8);
    const lb = Math.round(accent[2] + (255 - accent[2]) * 0.8);

    function resize() {
      const dpr = Math.min(window.devicePixelRatio || 1, 2);
      W = canvas.clientWidth; H = canvas.clientHeight;
      if (!W || !H) { requestAnimationFrame(resize); return; }
      canvas.width = W * dpr; canvas.height = H * dpr;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ready = true;
    }
    resize();
    window.addEventListener('resize', resize);

    function makeBolt(x0) {
      const segs = [];
      const main = [[x0, -12]];
      let x = x0, y = 0;
      while (y < H * 0.42) { y += 22 + Math.random() * 26; x += (Math.random() - 0.5) * W * 0.06; main.push([x, y]); }
      segs.push(main);
      if (Math.random() < 0.7 && main.length > 5) {
        const bi = 2 + Math.floor(Math.random() * (main.length - 4));
        let bx = main[bi][0], by = main[bi][1];
        const br = [[bx, by]];
        const n = 2 + Math.floor(Math.random() * 3);
        for (let k = 0; k < n; k++) { by += 22 + Math.random() * 30; bx += (Math.random() - 0.35) * W * 0.05; br.push([bx, by]); }
        segs.push(br);
      }
      return segs;
    }

    function triggerFlash() {
      const x = W * (0.22 + Math.random() * 0.56);
      flash = { life: 14 + Math.random() * 10, dur: 0, x, bolt: makeBolt(x), max: 0.12 + Math.random() * 0.09 };
      flash.dur = flash.life;
    }

    function draw() {
      ctx.globalCompositeOperation = 'source-over';
      ctx.fillStyle = '#060608';
      ctx.fillRect(0, 0, W, H);

      if (flash.life > 0) {
        const p = flash.life / flash.dur;
        const flick = flash.life > flash.dur * 0.55 ? (0.45 + 0.55 * Math.random()) : Math.pow(p, 1.4);
        const amt = flash.max * flick;

        ctx.globalCompositeOperation = 'lighter';
        const glow = ctx.createRadialGradient(flash.x, -H * 0.08, 0, flash.x, -H * 0.08, Math.max(W, H) * 0.5);
        glow.addColorStop(0, 'rgba(' + lr + ',' + lg + ',' + lb + ',' + amt + ')');
        glow.addColorStop(1, 'rgba(' + lr + ',' + lg + ',' + lb + ',0)');
        ctx.fillStyle = glow;
        ctx.fillRect(0, 0, W, H);

        if (flash.life > flash.dur * 0.5) {
          const ba = Math.min(0.85, amt * 2.2);
          ctx.strokeStyle = 'rgba(' + Math.min(255, lr+30) + ',' + Math.min(255, lg+30) + ',' + Math.min(255, lb+35) + ',' + ba + ')';
          ctx.lineWidth = 1.6;
          ctx.lineCap = 'round'; ctx.lineJoin = 'round';
          ctx.shadowColor = 'rgba(' + lr + ',' + lg + ',' + lb + ',' + ba + ')';
          ctx.shadowBlur = 12;
          for (const seg of flash.bolt) {
            ctx.beginPath();
            ctx.moveTo(seg[0][0], seg[0][1]);
            for (let i = 1; i < seg.length; i++) ctx.lineTo(seg[i][0], seg[i][1]);
            ctx.stroke();
          }
          ctx.shadowBlur = 0;
        }
        ctx.globalCompositeOperation = 'source-over';
      }
    }

    function tick() {
      if (!ready) { requestAnimationFrame(tick); return; }
      nextFlash -= 1;
      if (nextFlash <= 0 && flash.life <= 0) { triggerFlash(); nextFlash = 200 + Math.random() * 320; }
      if (flash.life > 0) flash.life -= 1;
      draw();
      requestAnimationFrame(tick);
    }
    requestAnimationFrame(tick);
  }

  function bindNav() {
    document.addEventListener('click', e => {
      const v = e.target.closest('[data-view]');
      if (v) { setView(v.dataset.view); return; }
      const h = e.target.closest('[data-href]');
      if (h) window.open(h.dataset.href, '_blank', 'noopener,noreferrer');
    });

    const modal = $('#scriptModal');
    const openModal = () => modal.classList.add('open');
    const closeModal = () => modal.classList.remove('open');

    $('#closePlan').addEventListener('click', closePlans);
    $('#planModal').addEventListener('click', e => { if (e.target === $('#planModal')) closePlans(); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') closePlans(); });

    $('#copyScriptBtn').addEventListener('click', openModal);
    $('#closeScript').addEventListener('click', closeModal);
    modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });
    $('#modalGoGames').addEventListener('click', () => { closeModal(); setView('games'); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape' && modal.classList.contains('open')) closeModal(); });

    $('#copyBtn').addEventListener('click', async () => {
      try { await navigator.clipboard.writeText(LOADSTRING); } catch (_) {}
      const btn = $('#copyBtn');
      btn.classList.add('copied');
      $('#copyLabel').textContent = 'Copied!';
      clearTimeout(btn._t);
      btn._t = setTimeout(() => { btn.classList.remove('copied'); $('#copyLabel').textContent = 'Copy'; }, 1800);
    });

    $('#getFreeBtn').addEventListener('click', handleFreeKey);
    loadOwner();
    $('#getPremiumBtn').addEventListener('click', () => { afTrack('premium_click', 'get-key'); enterCheckout('monthly'); });
    $('#getLifetimeBtn').addEventListener('click', () => { afTrack('premium_click', 'get-key'); enterCheckout('lifetime'); });
    for (const b of $$('[data-buy]')) b.addEventListener('click', () => {
      afTrack('premium_click', 'premium-page');
      enterCheckout(b.dataset.buy);
    });

    $('#coBuyBtn').addEventListener('click', coBuy);
    $('#coEnterBtn').addEventListener('click', coEnter);
    $('#coRedeemBtn').addEventListener('click', coRedeem);
    $('#coEmail').addEventListener('input', () => coError('#coBuyErr', ''));
    $('#coEmail').addEventListener('keydown', e => { if (e.key === 'Enter') coBuy(); });
    $('#coBoxX').addEventListener('click', closeRedeem);
    $('#coModal').addEventListener('click', e => { if (e.target === $('#coModal')) closeRedeem(); });
    document.addEventListener('keydown', e => {
      if (e.key === 'Escape' && $('#coModal').classList.contains('open')) closeRedeem();
    });
    // Grouped in fours as they type so a 16 character code stays readable, and
    // a pasted one keeps working whatever spacing or dashes came with it.
    $('#coCode').addEventListener('input', e => {
      const clean = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 16);
      e.target.value = clean.replace(/(.{4})/g, '$1 ').trim();
      coError('#coRedeemErr', '');
    });
    $('#coCode').addEventListener('keydown', e => { if (e.key === 'Enter') coRedeem(); });
    $('#keyDiscordBtn').addEventListener('click', handleKeyDiscordClick);
    $('#keyContinue').addEventListener('click', () => {
      if (state.checkpointDone) window.location.href = redirectUrl();
    });
    $('#keySkip').addEventListener('click', () => {
      if (!$('#keySkip').classList.contains('ready') || state.checkpointDone) return;
      completeCheckpoint();
    });
    $('#giveawayContinue').addEventListener('click', () => {
      window.location.href = GIVEAWAY_TARGET;
    });

    document.addEventListener('visibilitychange', onVisibility);

    window.addEventListener('popstate', () => {
      setView(pathToView(location.pathname));
    });
  }

  function heartbeat() {
    try {
      fetch('/api/presence', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ path: location.pathname }),
        keepalive: true,
      }).catch(() => {});
    } catch (_) {}
  }

  function init() {
    renderGames();
    renderSellers();
    bindNav();
    setupCanvas();
    detectRegion();
    const coPlan = new URLSearchParams(location.search).get('plan');
    if (coPlan && pathToView(location.pathname) === 'checkout') enterCheckout(coPlan);
    else setView(pathToView(location.pathname));
    heartbeat();
    setInterval(() => { if (!document.hidden) heartbeat(); }, 20000);
    window.addEventListener('pageshow', heartbeat);
    const origPush = history.pushState;
    history.pushState = function () { origPush.apply(this, arguments); heartbeat(); };
    window.addEventListener('popstate', heartbeat);
  }


  // keepalive so the beacon still goes out when the click navigates away
  function afTrack(event, where) {
    try {
      fetch('/api/track', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ event: event, where: where }),
        keepalive: true,
      }).catch(function () {});
    } catch (_) {}
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
</script>
</body>
</html>
