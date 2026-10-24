<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Profile Link - @thn.wtf</title>
  <meta name="description" content="@thn.wtf — developer profile with Discord presence." />
  <meta name="theme-color" content="#0b0d0e" id="meta-theme" />
  <meta property="og:type" content="website" />
  <meta property="og:title" content="@thn.wtf — Developer" />
  <meta property="og:description" content="Building things for the web. Discord presence, music archive & guestbook." />
  <meta property="og:image" content="./og.png" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="@thn.wtf — Developer" />
  <meta name="twitter:description" content="Building things for the web. Discord presence, music archive & guestbook." />
  <meta name="twitter:image" content="./og.png" />
  <link rel="icon" type="image/svg+xml" href="./favicon.svg" />
  <script>
    (function(){try{var t=localStorage.getItem("thn_theme");if(t==="light"){document.documentElement.classList.add("light-boot");}}catch(e){}})();
  </script>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link rel="preconnect" href="https://cdn.discordapp.com" />
  <link rel="preconnect" href="https://i.ytimg.com" />
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="./style.css" />
  <style>.social-icon svg{width:26px;height:26px;flex-shrink:0}html.light-boot body{background-color:#f3f4f6}</style>
  <script src="https://unpkg.com/lucide@0.462.0/dist/umd/lucide.min.js" defer></script>
  <script src="./script.js" defer></script>
</head>
<body class="locked">
  <a class="skip-link" href="#home">Skip to content</a>
  <div class="enter" id="enter" role="button" tabindex="0" aria-label="Click to enter">
    <span class="enter-text">click to enter</span>
  </div>
  <div class="loader" id="loader" aria-hidden="true">
    <div class="loader-inner">
      <span class="loader-logo">@thn.wtf</span>
      <span class="loader-bar"><span id="loader-fill"></span></span>
    </div>
  </div>
  <noscript><style>.loader{display:none}.enter{display:none}body.locked{overflow:auto}</style></noscript>
  <div class="bg-orbs" aria-hidden="true"><span></span><span></span></div>

  <nav class="navbar">
    <div class="navbar-inner">
      <a class="navbar-logo" href="#/home" data-route="home">@thn.wtf</a>
      <ul class="nav-links" id="nav-links">
        <li><a class="nav-link active" href="#/home" data-route="home"><i data-lucide="home"></i>Home</a></li>
        <li><a class="nav-link" href="#/music" data-route="music"><i data-lucide="music"></i>Music</a></li>
        <li><a class="nav-link" href="#/guestbook" data-route="guestbook"><i data-lucide="book-open"></i>Guestbook</a></li>
      </ul>
      <div class="navbar-actions">
        <button id="theme-btn" type="button" aria-label="Toggle light / dark theme"><i data-lucide="sun"></i></button>
        <button class="menu-btn" id="menu-btn" type="button" aria-label="Open menu" aria-expanded="false" aria-controls="nav-links">
          <i data-lucide="menu" class="icon-menu"></i>
          <i data-lucide="x" class="icon-close"></i>
        </button>
      </div>
    </div>
  </nav>

  <main class="standard-container">
    <div id="view-home" class="view">
    <section class="hero" id="home">
      <div class="hero-top">
        <div id="avatar-wrap" class="avatar-wrap is-loading">
          <img class="avatar" alt="@thn.wtf Discord avatar" />
          <div class="avatar-skeleton"></div>
          <span class="avatar-status" id="avatar-status"></span>
        </div>
        <div class="hero-info">
          <h1 class="username">@thn.wtf</h1>
          <span class="role">Developer</span>
          <p class="tagline"><span id="tagline-text">Building things for the web.</span><span class="caret" aria-hidden="true"></span></p>
          <p id="kv-desc" class="status is-loading">
            <span class="skeleton-bar"></span>
            <span class="skeleton-bar short"></span>
          </p>
          <div class="chips">
            <span class="chip"><i data-lucide="map-pin" class="chip-icon"></i>Vietnam</span>
            <span class="chip-dot"></span>
            <span class="chip chip-mono"><i data-lucide="clock" class="chip-icon"></i><span id="local-time-text">--:--:--</span></span>
          </div>
        </div>
      </div>
      <div id="now-line" class="now-line is-loading">
        <span class="skeleton-bar"></span>
      </div>
      <div id="rpc-slot"></div>
    </section>

    <section class="block" id="about">
      <div class="stats-divider"></div>
      <h2 class="stats-header">About</h2>
      <p class="about-lead reveal">Hi, I'm Thn~~.</p>
      <p class="about-text reveal">I build websites, Discord bots and useful tools for the web.</p>
      <ul class="facts">
        <li class="reveal"><i data-lucide="code"></i>Developer</li>
        <li class="reveal"><i data-lucide="map-pin"></i>Vietnam</li>
        <li class="reveal"><i data-lucide="globe"></i>Web Development</li>
        <li class="reveal"><i data-lucide="message-circle"></i>Discord</li>
        <li class="reveal"><i data-lucide="sparkles"></i>Currently learning</li>
      </ul>
    </section>

    <section class="block" id="socials">
      <div class="stats-divider"></div>
      <h2 class="stats-header">Socials</h2>
      <div class="capture-box">
        <span class="capture-text">Find me around the internet</span>
      </div>
      <div class="social-grid stagger" style="margin-top: 14px;">
        <a class="social-card reveal reveal-left" href="https://www.facebook.com/thien.huynh.ngoc.197335" target="_blank" rel="noopener">
          <span class="social-icon"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg></span>
          <span class="social-info">
            <span class="social-nick">Facebook</span>
            <span class="social-handle">@thn.wtf</span>
          </span>
        </a>
        <a class="social-card reveal reveal-right" href="https://discord.com/users/1102948425126920242" target="_blank" rel="noopener">
          <span class="social-icon"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.865-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.319 13.58.099 18.058a.082.082 0 0 0 .031.056 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028c.462-.63.873-1.295 1.226-1.994a.076.076 0 0 0-.042-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128c.126-.094.252-.192.372-.291a.074.074 0 0 1 .078-.01c3.928 1.793 8.18 1.793 12.061 0a.074.074 0 0 1 .079.009c.12.099.246.198.373.292a.077.077 0 0 1-.007.128c-.598.349-1.22.645-1.873.892a.077.077 0 0 0-.041.107c.36.698.772 1.363 1.225 1.993a.076.076 0 0 0 .084.029 19.84 19.84 0 0 0 6.002-3.03.077.077 0 0 0 .032-.055c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03ZM8.02 15.331c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418Zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418Z"/></svg></span>
          <span class="social-info">
            <span class="social-nick">Discord</span>
            <span class="social-handle">@thn.wtf</span>
          </span>
        </a>
        <a class="social-card reveal reveal-left" href="https://www.tiktok.com/@thn.wtf" target="_blank" rel="noopener">
          <span class="social-icon"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64 2.93 2.93 0 0 1 .88.13V9.4a6.84 6.84 0 0 0-1-.05A6.33 6.33 0 0 0 5 20.1a6.34 6.34 0 0 0 10.86-4.43v-7a8.16 8.16 0 0 0 4.77 1.52v-3.4a4.85 4.85 0 0 1-1-.1z"/></svg></span>
          <span class="social-info">
            <span class="social-nick">TikTok</span>
            <span class="social-handle">@thn.wtf</span>
          </span>
        </a>
        <a class="social-card reveal reveal-right" href="https://www.instagram.com/thn2k10/" target="_blank" rel="noopener">
          <span class="social-icon"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/></svg></span>
          <span class="social-info">
            <span class="social-nick">Instagram</span>
            <span class="social-handle">@thn2k10</span>
          </span>
        </a>
        <a class="social-card reveal reveal-left" href="http://dsc.gg/thncommunity" target="_blank" rel="noopener">
          <span class="social-icon"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.865-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.319 13.58.099 18.058a.082.082 0 0 0 .031.056 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028c.462-.63.873-1.295 1.226-1.994a.076.076 0 0 0-.042-.106 13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128c.126-.094.252-.192.372-.291a.074.074 0 0 1 .078-.01c3.928 1.793 8.18 1.793 12.061 0a.074.074 0 0 1 .079.009c.12.099.246.198.373.292a.077.077 0 0 1-.007.128c-.598.349-1.22.645-1.873.892a.077.077 0 0 0-.041.107c.36.698.772 1.363 1.225 1.993a.076.076 0 0 0 .084.029 19.84 19.84 0 0 0 6.002-3.03.077.077 0 0 0 .032-.055c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03ZM8.02 15.331c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418Zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418Z"/></svg></span>
          <span class="social-info">
            <span class="social-nick">Discord Server</span>
            <span class="social-handle">Thn Community</span>
          </span>
        </a>
        <a class="social-card reveal reveal-right" href="https://pastefy.app/zbtyoF10/raw" target="_blank" rel="noopener">
          <span class="social-icon"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M9.4 16.6 4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0 4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/></svg></span>
          <span class="social-info">
            <span class="social-nick">My Skills</span>
            <span class="social-handle">pastefy.app</span>
          </span>
        </a>
      </div>
    </section>

    <section class="block" id="skills">
      <div class="stats-divider"></div>
      <h2 class="stats-header">Tech Stack</h2>
      <ul class="stack stagger">
        <li class="reveal">HTML</li>
        <li class="reveal">CSS</li>
        <li class="reveal">JavaScript</li>
        <li class="reveal">Python</li>
      </ul>
    </section>
    </div>

    <div id="view-music" class="view" hidden>
      <section class="block" id="music">
        <div class="stats-divider"></div>
        <h2 class="stats-header">Music Archive</h2>
        <div class="capture-box">
          <span class="capture-text">Saved YouTube links</span>
        </div>
        <form class="music-add" id="yt-add-form" autocomplete="off">
          <div class="music-add-row">
            <input class="music-input" id="yt-url" type="url" placeholder="Paste a YouTube link… (watch / youtu.be / shorts)" required />
            <input class="music-input" id="yt-title" type="text" placeholder="Display name (optional)" maxlength="80" />
          </div>
          <div class="music-add-row" style="margin-top:8px">
            <input class="music-input" id="yt-cover" type="url" placeholder="Custom cover image link (optional) https://…" />
            <button class="music-add-btn" type="submit"><i data-lucide="plus"></i><span>Save</span></button>
          </div>
          <p class="music-hint" id="yt-hint">Click a card to open the YouTube link.</p>
        </form>
        <div class="music-grid" id="yt-grid"></div>
        <div class="music-empty" id="yt-empty">
          <i data-lucide="youtube"></i>
          <p>No links yet.</p>
        </div>
      </section>
    </div>
    <div id="view-guestbook" class="view" hidden>
      <section class="block" id="guestbook">
        <div class="stats-divider"></div>
        <h2 class="stats-header">Guestbook <span class="gb-count" id="gb-count"></span></h2>
        <div class="capture-box">
          <span class="capture-text">Leave a message</span>
        </div>
        <div id="gb-admin-bar" class="gb-admin-bar" hidden>
          <span class="gb-admin-badge"><i data-lucide="shield-check"></i> Chế độ quản trị tin nhắn</span>
          <div class="gb-admin-actions">
            <button id="gb-clear-all" type="button" class="gb-admin-btn-sm danger"><i data-lucide="trash-2"></i> Xóa tất cả</button>
            <button id="gb-admin-lock" type="button" class="gb-admin-btn-sm"><i data-lucide="lock"></i> Khóa</button>
          </div>
        </div>
        <form class="music-add gb-form" id="gb-form" autocomplete="off">
          <div class="music-add-row">
            <input class="music-input" id="gb-name" type="text" placeholder="Your name (optional)" maxlength="40" />
          </div>
          <div class="music-add-row" style="margin-top:8px">
            <textarea class="music-input" id="gb-msg" placeholder="Write something nice…" maxlength="300" required></textarea>
          </div>
          <div class="music-add-row" style="margin-top:8px">
            <button class="music-add-btn" type="submit"><i data-lucide="send"></i><span>Sign</span></button>
          </div>
          <p class="music-hint" id="gb-hint">Be kind — messages are public.</p>
        </form>
        <div class="gb-list" id="gb-list"></div>
        <div class="music-empty" id="gb-empty" hidden>
          <i data-lucide="book-open"></i>
          <p>No messages yet. Be the first!</p>
        </div>
      </section>
    </div>
  </main>
  <footer class="footer">
    <span class="footer-sub">@thn.wtf</span>
  </footer>
  <div class="music-player-embed" id="yt-embed" hidden>
    <div class="music-embed-box">
      <button class="music-embed-close" id="yt-embed-close" type="button" aria-label="Close player"><i data-lucide="x"></i></button>
      <div class="music-embed-frame"><iframe id="yt-embed-frame" allow="autoplay; encrypted-media; picture-in-picture" allowfullscreen title="YouTube player"></iframe></div>
      <p class="music-embed-title" id="yt-embed-title"></p>
    </div>
  </div>
  <div class="music-player-embed" id="music-admin-wrap" hidden>
    <div class="music-embed-box music-admin-box">
      <button class="music-embed-close" id="music-admin-close" type="button" aria-label="Close"><i data-lucide="x"></i></button>
      <p class="music-admin-title"><i data-lucide="lock"></i><span>Admin Manager</span></p>
      <div id="admin-login">
        <p class="music-hint">Khu vực quản trị.</p>
        <form class="music-add" id="admin-login-form" autocomplete="off">
          <div class="music-add-row">
            <input class="music-input" id="admin-pass" type="password" placeholder="Admin password…" autocomplete="current-password" />
            <button class="music-add-btn" type="submit"><i data-lucide="key-round"></i><span>Unlock</span></button>
          </div>
          <p class="music-hint" id="admin-login-hint"></p>
        </form>
      </div>
      <div id="admin-panel" hidden>
        <p class="music-hint">Đã mở khóa quản trị. Có thể thêm/sửa/xóa nhạc và quản lý tin nhắn Guestbook.</p>
        <p class="music-hint" style="margin-top:10px; font-weight:600; color:var(--text);"><i data-lucide="music" style="width:13px;height:13px;display:inline-block;vertical-align:middle;margin-right:4px;"></i>Music Archive</p>
        <div class="music-add-row" style="margin-top:6px">
          <button class="music-add-btn" id="admin-copy-json" type="button"><i data-lucide="copy"></i><span>Copy JSON</span></button>
          <button class="music-add-btn" id="admin-dl-json" type="button"><i data-lucide="download"></i><span>Download music.json</span></button>
        </div>
        <p class="music-hint" id="admin-export-hint"></p>
        <p class="music-hint" style="margin-top:14px; font-weight:600; color:var(--text);"><i data-lucide="book-open" style="width:13px;height:13px;display:inline-block;vertical-align:middle;margin-right:4px;"></i>Guestbook Messages</p>
        <p class="music-hint">Xóa từng tin nhắn trực tiếp tại tab Guestbook hoặc xóa toàn bộ bên dưới:</p>
        <div class="music-add-row" style="margin-top:6px">
          <button class="music-add-btn" id="admin-gb-clear" type="button" style="border-color:rgba(239,68,68,0.3); color:#ef4444;"><i data-lucide="trash-2"></i><span>Xóa tất cả tin nhắn Guestbook</span></button>
        </div>
        <p class="music-hint" style="margin-top:8px; font-size:0.7rem; color:var(--muted); line-height:1.4;">💡 Lưu ý Supabase: Nếu xóa tin nhắn mà máy chủ chưa mất, vào Supabase SQL Editor chạy: <code>CREATE POLICY "Allow delete" ON guestbook FOR DELETE USING (true);</code></p>
        <div class="music-admin-foot" style="margin-top:14px;">
          <button class="music-open" id="admin-lock" type="button"><i data-lucide="lock"></i><span>Khóa lại</span></button>
        </div>
      </div>
    </div>
  </div>
  <audio id="bg-audio" src="./nhac1.mp3" loop preload="auto"></audio>
  <button id="bg-music-btn" type="button" aria-label="Toggle music" hidden><i data-lucide="volume-x"></i></button>
</body>
</html>
