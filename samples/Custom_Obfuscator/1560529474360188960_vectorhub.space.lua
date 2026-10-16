<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vector Hub</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #020a02;
      color: rgb(0, 30, 255);
      font-family: 'SF Mono', 'Courier New', 'Monaco', monospace;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
    }
    .container {
      max-width: 600px;
      width: 100%;
      text-align: center;
      border: 1px solid rgb(0, 30, 255);
      border-radius: 16px;
      padding: 48px 32px;
      background: rgba(0, 0, 0, 0.65);
      box-shadow: 0 0 50px rgba(0, 8, 255, 0.337);
    }
    .lock-icon {
      font-size: 52px;
      margin-bottom: 16px;
      filter: drop-shadow(0 0 10px rgba(255, 255, 0, 0.4));
    }
    h1 {
      font-size: 36px;
      letter-spacing: 4px;
      margin-bottom: 6px;
      text-transform: uppercase;
      font-weight: 700;
    }
    .subtitle {
      color: rgb(255, 0, 0);
      font-size: 13px;
      margin-bottom: 36px;
      letter-spacing: 2px;
      text-transform: uppercase;
    }
    .message {
      font-size: 16px;
      line-height: 1.7;
      margin-bottom: 28px;
      color: rgb(255, 0, 0);
    }
    .code-box {
      background: #0141ffaf;
      border: 1px solid rgb(0, 30, 255);
      border-radius: 10px;
      padding: 20px;
      font-family: 'SF Mono', 'Courier New', 'Monaco', monospace;
      font-size: 15px;
      word-break: break-all;
      margin-bottom: 20px;
      text-align: center;
      color: hsl(0, 0%, 96%);
      box-shadow: inset 0 0 20px rgb(0, 0, 0);
    }
    .hint {
      font-size: 12px;
      color: #ff0202;
      margin-top: 28px;
      letter-spacing: 0.5px;
    }
    @media (max-width: 480px) {
      .container { padding: 32px 20px; }
      h1 { font-size: 28px; }
      .code-box { font-size: 13px; padding: 16px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="lock-icon">🔒</div>
    <h1>VECTOR HUB</h1>
    <div class="subtitle">???????????????</div>
    <p class="message">
      หน้านี้ไม่สามารถเปิดผ่านเว็บเบราว์เซอร์ได้<br>
      ให้นำโค้ดด้านล่างไปวางใน Executor ของ Roblox
    </p>
    <div class="code-box">loadstring(game:HttpGet('https://vectorhub.space'))()</div>
    <p class="hint">⚠ เปิดใน Roblox เท่านั้น · ไม่รองรับการเปิดผ่าน Browser</p>
  </div>
</body>
</html>`;
