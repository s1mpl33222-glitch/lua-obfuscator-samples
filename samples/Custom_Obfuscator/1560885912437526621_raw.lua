<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>doitenroi.wispbyte.app — Web server offline</title>
    <meta name="robots" content="noindex, nofollow">
    <!-- Subdomain proxy 502 → Custom Page | https://wispbyte.com/subdomain-webserver-offline.html -->
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{height:100%}
        body{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px 16px;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;font-weight:500;color:#fff;background:#0A141D}
        .page-wrap{width:100%;max-width:440px;margin:0 auto}
        .check-box{width:100%;padding:32px 26px 26px;background:rgba(43,48,60,.17);border:1px solid rgba(255,255,255,.1);border-radius:12px;box-shadow:0 0 20px rgba(0,0,0,.6);backdrop-filter:blur(10px);text-align:center}
        .brand-row{display:flex;flex-direction:column;align-items:center;gap:6px;margin-bottom:26px}
        .brand-logo{width:44px;height:44px}
        .brand-name{font-size:20px;font-weight:600;text-shadow:0 2px 4px rgba(0,0,0,.7)}
        .brand-tagline{font-size:12px;font-weight:400;color:rgba(255,255,255,.45)}
        .check-title{font-size:18px;font-weight:600;margin-bottom:10px}
        .check-text{font-size:14px;font-weight:400;line-height:1.65;color:rgba(255,255,255,.75);margin-bottom:18px;max-width:360px;margin-left:auto;margin-right:auto}
        .steps-box{margin:0 auto 20px;padding:16px 18px;border-radius:8px;background:rgba(255,255,255,.03);outline:1px solid rgba(255,255,255,.08);text-align:left;max-width:360px}
        .steps-box ol{margin:0;padding-left:20px;font-size:13px;line-height:1.65;color:rgba(255,255,255,.72)}
        .steps-box li+li{margin-top:10px}
        .steps-box code{font-family:ui-monospace,Consolas,monospace;font-size:12px;color:rgba(147,197,253,.95);background:rgba(59,130,246,.12);padding:1px 6px;border-radius:4px;white-space:nowrap}
        .steps-box a{color:rgba(147,197,253,.95);text-decoration:none}
        .steps-box a:hover{color:#fff;text-decoration:underline}
        .check-meta{padding-top:16px;border-top:1px solid rgba(255,255,255,.08);font-size:11px;color:rgba(255,255,255,.35)}
        .check-foot{margin-top:18px;text-align:center;font-size:13px;color:rgba(255,255,255,.45)}
        .check-foot a{color:rgba(255,255,255,.65);text-decoration:none}
        .check-foot a:hover{color:#fff}
    </style>
</head>
<body>
    <div class="page-wrap">
        <div class="check-box">
            <div class="brand-row">
                <svg class="brand-logo" viewBox="0 0 1554.24 1555.09" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path fill="#3b82f6" d="M931.05,70.32h0c193.17,0,350,156.83,350,350v397h-291.77c-45.93,0-83.23-37.29-83.23-83.23V95.32c0-13.8,11.2-25,25-25Z" transform="translate(152.13 -267.91) rotate(15)"/><path fill="#3b82f6" d="M1386.01,299.26h0c13.8,0,25,11.2,25,25v638.77c0,45.93-37.29,83.23-83.23,83.23h-291.77v-397c0-193.17,156.83-350,350-350Z" transform="translate(2190.02 -334.94) rotate(105)"/><path fill="#3b82f6" d="M280.04,87.19h0c193.17,0,350,156.83,350,350v397h-291.77c-45.93,0-83.23-37.29-83.23-83.23V112.19c0-13.8,11.2-25,25-25Z" transform="translate(-116.99 768.92) rotate(-75)"/><path fill="#3b82f6" d="M833.98-42.77h0c13.8,0,25,11.2,25,25v638.77c0,45.93-37.29,83.23-83.23,83.23h-291.77v-397c0-193.17,156.83-350,350-350Z" transform="translate(108.48 -162.52) rotate(15)"/><path fill="#3b82f6" d="M298.19,737.77h0c193.17,0,350,156.83,350,350v397h-291.77c-45.93,0-83.23-37.29-83.23-83.23v-638.77c0-13.8,11.2-25,25-25Z" transform="translate(618.07 2303.91) rotate(-165)"/><path fill="#3b82f6" d="M493.23,508.83h0c13.8,0,25,11.2,25,25v638.77c0,45.93-37.29,83.23-83.23,83.23H143.23v-397c0-193.17,156.83-350,350-350Z" transform="translate(-607.14 973.42) rotate(-75)"/><path fill="#3b82f6" d="M949.2,720.9h0c193.17,0,350,156.83,350,350v397h-291.77c-45.93,0-83.23-37.29-83.23-83.23v-638.77c0-13.8,11.2-25,25-25Z" transform="translate(2456.54 303.83) rotate(105)"/><path fill="#3b82f6" d="M1045.26,850.86h0c13.8,0,25,11.2,25,25v638.77c0,45.93-37.29,83.23-83.23,83.23h-291.77v-397c0-193.17,156.83-350,350-350Z" transform="translate(1418.56 2635.48) rotate(-165)"/></svg>
                <div class="brand-name">Wispbyte</div>
                <div class="brand-tagline">Hosting your dreams</div>
            </div>
            <h1 class="check-title">Web server isn't running</h1>
            <p class="check-text">Your subdomain is set up, but nothing is listening on your server yet. Start your web app and bind it to all interfaces so we can reach it.</p>
            <div class="steps-box">
                <ol>
                    <li>Open your server in the <a href="https://wispbyte.com/client">Wispbyte client panel</a> and note the <strong>port</strong> shown on the server page.</li>
                    <li>Start your web server on <code>0.0.0.0:9823</code> — not <code>127.0.0.1</code> or <code>localhost</code>.</li>
                    <li>Make sure the server process stays running, then refresh this page.</li>
                </ol>
            </div>
            <div class="check-meta">Example: listen on <code>0.0.0.0:9823</code></div>
        </div>
        <p class="check-foot">Need help? Check <a href="https://wispbyte.com/support">support</a> or ask in our Discord.</p>
    </div>
</body>
</html>
