<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MeowRobux</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #0b0e14;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .container {
            max-width: 820px;
            width: 100%;
            background: #141a22;
            border-radius: 0;
            box-shadow: 0 12px 40px rgba(0,0,0,0.6);
            padding: 2.5rem 2rem;
            border: 1px solid #2a313c;
        }
        h1 {
            font-size: 2.6rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: #f0f4fc;
            margin-bottom: 0.15rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }
        h1 span {
            background: #1f2630;
            font-size: 0.85rem;
            font-weight: 400;
            padding: 0.1rem 0.9rem;
            color: #8b9bb5;
            letter-spacing: 0.5px;
            border: 1px solid #2a313c;
        }
        .sub {
            color: #6b7d98;
            border-bottom: 2px solid #1f2630;
            padding-bottom: 1.2rem;
            margin-bottom: 2rem;
            font-size: 0.95rem;
        }
        .dropdown-group {
            margin-bottom: 1.5rem;
        }
        .dropdown-group label {
            display: block;
            color: #b0c4e0;
            font-weight: 500;
            font-size: 0.85rem;
            margin-bottom: 0.4rem;
            letter-spacing: 0.3px;
        }
        .dropdown-group select {
            width: 100%;
            padding: 0.7rem 1rem;
            background: #0b0e14;
            color: #e8edf5;
            border: 1px solid #2a313c;
            border-radius: 0;
            font-size: 1rem;
            font-family: inherit;
            cursor: pointer;
            outline: none;
            transition: border-color 0.2s;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%236b7d98' stroke-width='1.5' fill='none'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
        }
        .dropdown-group select:focus {
            border-color: #4a6a8f;
        }
        .loadstring-box {
            background: #0b0e14;
            border: 1px solid #2a313c;
            padding: 1rem 1.5rem;
            margin: 0.5rem 0 1.2rem;
            position: relative;
            font-family: "JetBrains Mono", "Fira Code", monospace;
            font-size: 0.9rem;
            color: #d4e0f0;
            overflow-x: auto;
            white-space: pre-wrap;
            word-break: break-all;
        }
        .loadstring-box .label {
            position: absolute;
            top: -0.6rem;
            left: 1rem;
            background: #141a22;
            padding: 0 0.4rem;
            font-size: 0.65rem;
            color: #6b7d98;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            font-family: -apple-system, sans-serif;
        }
        .row {
            display: flex;
            gap: 0.8rem;
            flex-wrap: wrap;
            align-items: center;
            margin-bottom: 1.8rem;
        }
        .copy-btn {
            background: #1f2630;
            border: 1px solid #2a313c;
            color: #b0c4e0;
            padding: 0.5rem 1.4rem;
            font-size: 0.85rem;
            cursor: pointer;
            transition: background 0.15s, border-color 0.15s;
            font-family: inherit;
            border-radius: 0;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }
        .copy-btn:hover {
            background: #2a313c;
            border-color: #4a6a8f;
        }
        .copy-btn.copied {
            background: #1a3a2a;
            border-color: #3a8a5a;
            color: #8fdeb0;
        }

        .executor-section {
            border-top: 2px solid #1f2630;
            padding-top: 1.8rem;
            margin-top: 0.5rem;
            display: none;
        }
        .executor-section.visible {
            display: block;
        }
        .executor-header {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            color: #6b7d98;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 0.6rem;
        }
        .executor-header .badge {
            background: #1a3a2a;
            color: #8fdeb0;
            padding: 0.1rem 0.7rem;
            border: 1px solid #2a5a3a;
            font-size: 0.7rem;
        }
        .source-box {
            background: #0b0e14;
            border: 1px solid #2a313c;
            padding: 1.2rem 1.5rem;
            font-family: "JetBrains Mono", "Fira Code", monospace;
            font-size: 0.85rem;
            color: #d4e0f0;
            overflow-x: auto;
            white-space: pre-wrap;
            word-break: break-all;
            max-height: 400px;
            overflow-y: auto;
        }
        .source-box .line {
            display: block;
        }

        .footer {
            margin-top: 2.5rem;
            border-top: 1px solid #1f2630;
            padding-top: 1.5rem;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 0.8rem;
            font-size: 0.8rem;
            color: #4a5a70;
        }
        .footer a {
            color: #6b8aaa;
            text-decoration: none;
            border-bottom: 1px solid transparent;
            transition: border-color 0.2s;
        }
        .footer a:hover {
            border-color: #6b8aaa;
        }

        @media (max-width: 600px) {
            .container { padding: 1.5rem 1rem; }
            h1 { font-size: 2rem; }
            .loadstring-box { font-size: 0.8rem; padding: 0.8rem 1rem; }
            .source-box { font-size: 0.75rem; padding: 0.8rem 1rem; }
            .copy-btn { width: 100%; justify-content: center; }
            .footer { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>
        MeowRobux
        <span>scripts</span>
    </h1>
    <div class="sub">Load & execute – choose your weapon</div>

    <div class="dropdown-group">
        <label for="scriptSelect">📜 Select script</label>
        <select id="scriptSelect">
            <option value="op">op.lua</option>
            <option value="autofarm">autofarm.lua</option>
            <option value="kiyori">kiyori.lua</option>
        </select>
    </div>

    <div class="loadstring-box">
        <span class="label">LOADSTRING</span>
        <code id="loadstringDisplay">loadstring(game:HttpGet("https://meowrobux.vercel.app/raw/op.lua"))()</code>
    </div>

    <div class="row">
        <button class="copy-btn" id="copyButton">📋 Copy</button>
    </div>

    <div class="executor-section" id="executorSection">
        <div class="executor-header">
            <span>⚡ EXECUTOR DETECTED</span>
            <span class="badge">LUA SOURCE VISIBLE</span>
        </div>
        <div class="source-box" id="sourceContent">-- Loading script source...</div>
    </div>

    <div class="footer">
        <span>© 2026 MeowRobux</span>
        <a href="/terms">Terms of Service</a>
    </div>
</div>

<script>
    (function() {
        var select = document.getElementById('scriptSelect');
        var display = document.getElementById('loadstringDisplay');
        var copyBtn = document.getElementById('copyButton');
        var executorSection = document.getElementById('executorSection');
        var sourceContent = document.getElementById('sourceContent');

        var baseUrl = 'https://meowrobux.vercel.app/raw/';
        var scripts = {
            op: baseUrl + 'op.lua',
            autofarm: baseUrl + 'autofarm.lua',
            kiyori: baseUrl + 'kiyori.lua'
        };

        function getLoadstring(url) {
            return 'loadstring(game:HttpGet("' + url + '"))()';
        }

        function updateDisplay() {
            var key = select.value;
            var url = scripts[key];
            display.textContent = getLoadstring(url);
            if (isRoblox) {
                fetchSource(url);
            }
        }

        function fetchSource(url) {
            sourceContent.textContent = '-- Loading...';
            fetch(url)
                .then(function(r) {
                    if (!r.ok) throw new Error('Not found');
                    return r.text();
                })
                .then(function(text) {
                    sourceContent.textContent = text;
                })
                .catch(function() {
                    sourceContent.textContent = '-- Error loading script source.';
                });
        }

        var isRoblox = false;
        try {
            if (typeof game !== 'undefined' && game !== null && typeof game.GetService === 'function') isRoblox = true;
        } catch (_) {}
        if (!isRoblox) {
            try {
                if (typeof Instance !== 'undefined' && typeof Instance.new === 'function') isRoblox = true;
            } catch (_) {}
        }
        if (!isRoblox) {
            try {
                if (navigator.userAgent.includes('Roblox')) isRoblox = true;
            } catch (_) {}
        }
        if (!isRoblox) {
            try {
                if (window.__LUAU__ || window.LUAU_EXECUTOR || window.ROBLOX_EXECUTOR) isRoblox = true;
            } catch (_) {}
        }

        if (isRoblox) {
            executorSection.classList.add('visible');
            var key = select.value;
            fetchSource(scripts[key]);
        }

        select.addEventListener('change', updateDisplay);

        copyBtn.addEventListener('click', function() {
            var text = display.textContent;
            navigator.clipboard.writeText(text).then(function() {
                copyBtn.textContent = '✅ Copied!';
                copyBtn.classList.add('copied');
                setTimeout(function() {
                    copyBtn.textContent = '📋 Copy';
                    copyBtn.classList.remove('copied');
                }, 2000);
            }).catch(function() {
                var range = document.createRange();
                range.selectNode(display);
                window.getSelection().removeAllRanges();
                window.getSelection().addRange(range);
                document.execCommand('copy');
                copyBtn.textContent = '✅ Copied!';
                copyBtn.classList.add('copied');
                setTimeout(function() {
                    copyBtn.textContent = '📋 Copy';
                    copyBtn.classList.remove('copied');
                }, 2000);
            });
        });
    })();
</script>
</body>
</html>
