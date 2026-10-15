<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied | APEX HUB</title>
    <style>
        :root {
            --bg: #050508;
            --card-bg: rgba(12, 12, 17, 0.78);
            --card-border: rgba(255, 255, 255, 0.055);
            --text-primary: #e6e6ea;
            --text-secondary: #6b6b76;
            --text-tertiary: #40404a;
            --accent: #ffffff;
            --button-primary-bg: rgba(255, 255, 255, 0.035);
            --button-primary-border: rgba(255, 255, 255, 0.07);
            --button-secondary-bg: transparent;
            --button-secondary-border: rgba(255, 255, 255, 0.045);
            --button-hover-bg: rgba(255, 255, 255, 0.06);
            --button-hover-border: rgba(255, 255, 255, 0.12);
            --icon-color: rgba(255, 255, 255, 0.16);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
            background-color: var(--bg);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 24px;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .card {
            background: var(--card-bg);
            backdrop-filter: blur(48px);
            -webkit-backdrop-filter: blur(48px);
            border-radius: 22px;
            padding: 56px 52px;
            border: 1px solid var(--card-border);
            max-width: 520px;
            width: 100%;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.55), 0 0 0 1px rgba(255, 255, 255, 0.02) inset;
            animation: cardFadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }

        @keyframes cardFadeIn {
            from { opacity: 0; transform: translateY(28px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        .icon-lock {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 52px;
            height: 52px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            margin: 0 auto 28px;
            color: var(--icon-color);
        }

        .icon-lock svg { width: 22px; height: 22px; opacity: 0.7; }

        .title {
            font-size: 28px;
            font-weight: 620;
            letter-spacing: -0.03em;
            color: var(--text-primary);
            margin-bottom: 10px;
            line-height: 1.2;
        }

        .subtitle {
            font-size: 14px;
            font-weight: 450;
            color: var(--text-secondary);
            margin-bottom: 36px;
            line-height: 1.6;
        }

        .subtitle strong { font-weight: 600; color: #d4d4d8; letter-spacing: -0.01em; }

        .separator {
            width: 100%;
            height: 1px;
            background: rgba(255, 255, 255, 0.045);
            margin: 0 0 32px 0;
        }

        .description {
            font-size: 13.5px;
            color: var(--text-secondary);
            line-height: 1.7;
            margin-bottom: 36px;
            padding: 0 8px;
        }

        .actions {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 36px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 14px 28px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.28s cubic-bezier(0.22, 1, 0.36, 1);
            cursor: pointer;
            letter-spacing: -0.01em;
            width: 100%;
            box-sizing: border-box;
        }

        .btn-primary {
            background: var(--button-primary-bg);
            border: 1px solid var(--button-primary-border);
            color: var(--text-primary);
        }

        .btn-primary:hover {
            background: var(--button-hover-bg);
            border-color: var(--button-hover-border);
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.3);
        }

        .btn-secondary {
            background: var(--button-secondary-bg);
            border: 1px solid var(--button-secondary-border);
            color: var(--text-secondary);
        }

        .btn-secondary:hover {
            background: var(--button-hover-bg);
            border-color: var(--button-hover-border);
            color: #c4c4cc;
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.2);
        }

        .footer {
            font-size: 10px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-tertiary);
            font-weight: 500;
        }

        @media (max-width: 600px) {
            .card { padding: 44px 28px; border-radius: 18px; }
            .title { font-size: 24px; }
            .subtitle { font-size: 13px; }
            .description { font-size: 12.5px; padding: 0; }
            .btn { padding: 13px 22px; font-size: 13.5px; }
            .icon-lock { width: 44px; height: 44px; margin-bottom: 24px; }
            .icon-lock svg { width: 19px; height: 19px; }
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon-lock">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                <circle cx="12" cy="16" r="1"></circle>
            </svg>
        </div>

        <h1 class="title">Access Denied</h1>
        <p class="subtitle">
            This Lua script is protected by <strong>APEX HUB</strong>
        </p>

        <div class="separator"></div>

        <p class="description">
            You don't have permission to access these files.<br>
            This script has been protected against unauthorized access, reverse engineering, and tampering.
        </p>

        <div class="actions">
            <a href="https://apexhubeditor.vercel.app/" class="btn btn-primary">Return Home</a>
            <a href="https://discord.gg/9wdU3rrGGw" target="_blank" rel="noopener noreferrer" class="btn btn-secondary">Discord</a>
        </div>

        <div class="footer">APEX HUB · Security Infrastructure</div>
    </div>
</body>
</html>