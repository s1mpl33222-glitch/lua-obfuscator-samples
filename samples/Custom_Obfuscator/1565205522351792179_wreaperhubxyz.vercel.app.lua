<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#03030c">
  <title> </title>
  <style>
    * { box-sizing: border-box; }
    html, body { width: 100%; height: 100%; margin: 0; overflow: hidden; background: #03030c; }
    body {
      position: relative;
      background:
        radial-gradient(ellipse at 15% 15%, rgba(64, 35, 130, .19), transparent 34%),
        radial-gradient(ellipse at 82% 78%, rgba(37, 42, 130, .16), transparent 37%),
        radial-gradient(ellipse at 52% 48%, rgba(8, 10, 32, .2), transparent 55%),
        #03030c;
    }
    .nebula {
      position: fixed; inset: -18%;
      pointer-events: none;
      background:
        radial-gradient(ellipse at 17% 24%, rgba(105, 56, 194, .16), transparent 17%),
        radial-gradient(ellipse at 78% 68%, rgba(53, 67, 190, .15), transparent 19%),
        radial-gradient(ellipse at 66% 18%, rgba(45, 32, 112, .10), transparent 14%),
        radial-gradient(ellipse at 35% 83%, rgba(73, 42, 155, .08), transparent 18%);
      filter: blur(28px);
      animation: drift 65s ease-in-out infinite alternate;
    }
    canvas { position: fixed; inset: 0; width: 100%; height: 100%; display: block; }
    @keyframes drift {
      from { transform: translate3d(-1.5%, -1%, 0) scale(1); }
      to { transform: translate3d(1.5%, 1%, 0) scale(1.06); }
    }
    @media (prefers-reduced-motion: reduce) { .nebula { animation: none; } }
  </style>
</head>
<body>
  <div class="nebula" aria-hidden="true"></div>
  <canvas id="sky" aria-hidden="true"></canvas>
  <script>
    (() => {
      const canvas = document.getElementById('sky');
      const ctx = canvas.getContext('2d');
      let w = 0, h = 0, stars = [], dpr = 1;
      const countFor = (width, height) => Math.min(420, Math.max(150, Math.floor(width * height / 3600)));

      function resize() {
        dpr = Math.min(window.devicePixelRatio || 1, 2);
        w = window.innerWidth;
        h = window.innerHeight;
        canvas.width = Math.floor(w * dpr);
        canvas.height = Math.floor(h * dpr);
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        stars = Array.from({ length: countFor(w, h) }, () => ({
          x: Math.random() * w,
          y: Math.random() * h,
          r: Math.random() * 1.25 + 0.2,
          a: Math.random() * 0.65 + 0.2,
          tw: Math.random() * 0.018 + 0.003,
          phase: Math.random() * Math.PI * 2,
          vx: (Math.random() - 0.5) * 0.08,
          vy: (Math.random() - 0.5) * 0.08,
          bright: Math.random() > 0.965
        }));
      }

      let last = 0;
      function draw(time) {
        const t = time || 0;
        ctx.clearRect(0, 0, w, h);
        for (const s of stars) {
          s.x += s.vx;
          s.y += s.vy;
          if (s.x < -2) s.x = w + 2;
          if (s.x > w + 2) s.x = -2;
          if (s.y < -2) s.y = h + 2;
          if (s.y > h + 2) s.y = -2;
          const alpha = Math.max(0.08, Math.min(1, s.a + Math.sin(t * s.tw + s.phase) * 0.22));
          ctx.beginPath();
          ctx.fillStyle = `rgba(${s.bright ? '190,190,255' : '220,226,255'},${alpha})`;
          ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
          ctx.fill();
          if (s.bright) {
            const glow = s.r * 5.5;
            const grad = ctx.createRadialGradient(s.x, s.y, 0, s.x, s.y, glow);
            grad.addColorStop(0, `rgba(132,143,255,${alpha * .32})`);
            grad.addColorStop(1, 'rgba(132,143,255,0)');
            ctx.fillStyle = grad;
            ctx.fillRect(s.x - glow, s.y - glow, glow * 2, glow * 2);
            ctx.strokeStyle = `rgba(180,190,255,${alpha * .45})`;
            ctx.lineWidth = .55;
            ctx.beginPath();
            ctx.moveTo(s.x - glow * 1.35, s.y);
            ctx.lineTo(s.x + glow * 1.35, s.y);
            ctx.moveTo(s.x, s.y - glow * 1.35);
            ctx.lineTo(s.x, s.y + glow * 1.35);
            ctx.stroke();
          }
        }
        requestAnimationFrame(draw);
      }
      window.addEventListener('resize', resize, { passive: true });
      resize();
      requestAnimationFrame(draw);
    })();
  </script>
</body>
</html>
