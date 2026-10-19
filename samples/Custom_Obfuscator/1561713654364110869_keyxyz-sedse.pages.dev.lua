<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SEDSE Hub | Get Key</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        :root {
            --bg-base: #0f111a;
            --bg-surface: #161925;
            --bg-card: #1d2133;
            --border-color: rgba(255, 255, 255, 0.08);
            --border-focus: #5aabf2; 
            --text-main: #f3f4f6;
            --text-muted: #8b92a5;
            --btn-green: #22c55e;
            --btn-green-hover: #16a34a;
            --font-sans: 'Plus Jakarta Sans', sans-serif;
            --font-mono: 'JetBrains Mono', monospace;
        }

        body {
            font-family: var(--font-sans); background-color: var(--bg-base);
            background-image: radial-gradient(rgba(255, 255, 255, 0.05) 1.5px, transparent 1.5px);
            background-size: 24px 24px; color: var(--text-main);
            margin: 0; padding: 20px; min-height: 100vh;
            display: flex; justify-content: center; align-items: center; box-sizing: border-box;
            overflow-x: hidden;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 8px; height: 8px; }
        ::-webkit-scrollbar-track { background: var(--bg-base); }
        ::-webkit-scrollbar-thumb { background: #374151; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #4b5563; }

        .container { width: 100%; max-width: 900px; }

        /* Top Nav */
        .nav { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 8px; padding: 16px 24px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); }
        .nav-brand { font-weight: 700; font-size: 18px; display: flex; align-items: center; gap: 8px; }

        /* Progress Card */
        .task-card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 8px; padding: 24px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); flex-wrap: wrap; gap: 20px;}
        .task-info { flex: 1; min-width: 200px; }
        .task-title { font-weight: 700; font-size: 16px; margin-bottom: 4px; }
        .task-desc { color: var(--text-muted); font-size: 13px; font-weight: 600; text-transform: uppercase; }
        
        .task-progress-wrapper { flex: 2; min-width: 250px; }
        .progress-text { font-size: 13px; font-weight: 600; margin-bottom: 8px; display: flex; justify-content: space-between; }
        .progress-bar { width: 100%; height: 6px; background: rgba(0,0,0,0.5); border-radius: 4px; overflow: hidden; }
        .progress-fill { width: 0%; height: 100%; background: var(--btn-green); transition: width 0.3s; }

        /* Dropdown Select */
        .duration-select {
            background: rgba(0,0,0,0.3);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            padding: 8px 12px;
            border-radius: 6px;
            font-family: var(--font-sans);
            font-size: 12px;
            font-weight: 600;
            outline: none;
            margin-top: 10px;
            cursor: pointer;
            transition: 0.2s;
        }
        .duration-select:focus, .duration-select:hover { 
            border-color: var(--border-focus); 
        }
        .duration-select option {
            background: var(--bg-surface);
            color: var(--text-main);
        }

        .btn-start { background: var(--btn-green); color: #000; padding: 10px 24px; border-radius: 6px; font-weight: 700; font-size: 13px; text-transform: uppercase; text-decoration: none; display: flex; align-items: center; gap: 8px; border: none; cursor: pointer; transition: 0.2s; }
        .btn-start:hover { background: var(--btn-green-hover); transform: translateY(-2px); }

        /* Keys Table */
        .table-container { margin-top: 40px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { font-size: 11px; color: var(--text-muted); text-transform: uppercase; padding: 16px; border-bottom: 1px solid var(--border-color); font-weight: 700; }
        td { padding: 16px; border-bottom: 1px solid rgba(255,255,255,0.03); font-size: 14px; }
        .key-text { font-family: var(--font-mono); color: var(--border-focus); font-weight: 600; }
        .status-badge { background: rgba(34, 197, 94, 0.15); color: #4ade80; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: 700; border: 1px solid rgba(34, 197, 94, 0.3); display: inline-block;}
        .status-expired { background: rgba(239, 68, 68, 0.15); color: #f87171; border-color: rgba(239, 68, 68, 0.3); }

        .btn-outline { background: transparent; border: 1px solid var(--border-color); color: var(--text-main); padding: 8px 16px; border-radius: 6px; font-size: 12px; font-weight: 600; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 6px; }
        .btn-outline:hover { background: rgba(255,255,255,0.05); }

        /* Toast */
        #toast-container { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); z-index: 1000; display: flex; flex-direction: column; gap: 10px; }
        .toast { background: var(--bg-card); border-left: 4px solid var(--border-focus); color: #fff; padding: 12px 20px; border-radius: 6px; font-size: 14px; font-weight: 500; box-shadow: 0 10px 25px rgba(0,0,0,0.5); display: flex; align-items: center; gap: 10px; animation: toastEnter 0.3s forwards, toastExit 0.3s forwards 3s; }
        @keyframes toastEnter { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes toastExit { from { opacity: 1; } to { opacity: 0; transform: translateY(20px); } }
    </style>
</head>
<body>
    <div class="container">
        
        <div class="nav">
            <div class="nav-brand"><i data-lucide="shield-check"></i> SEDSE HUB</div>
            <i data-lucide="menu" style="color: var(--text-muted);"></i>
        </div>

        <div class="task-card" id="card-linkvertise">
            <div class="task-info">
                <div class="task-title">Linkvertise Hub Key</div>
                <div class="task-desc">Linkvertise • <span class="desc-duration">24 Hours</span></div>
                <select class="duration-select" onchange="updateDuration('linkvertise', this.value)">
                    <option value="24">24 Hours (1 Checkpoint)</option>
                    <option value="48">48 Hours (2 Checkpoints)</option>
                    <option value="72">72 Hours (3 Checkpoints)</option>
                </select>
            </div>
            <div class="task-progress-wrapper">
                <div class="progress-text"><span>Progress: 0/<span class="prog-total">1</span></span></div>
                <div class="progress-bar"><div class="progress-fill" style="width: 0%;"></div></div>
            </div>
            <a href="/v1/generate?action=start&provider=linkvertise&duration=24&step=1" class="btn-start" id="btn-linkvertise"><i data-lucide="external-link" style="width: 16px;"></i> Start</a>
        </div>

        <div class="task-card" id="card-workink">
            <div class="task-info">
                <div class="task-title">Work.ink Hub Key</div>
                <div class="task-desc">Work.ink • <span class="desc-duration">24 Hours</span></div>
                <select class="duration-select" onchange="updateDuration('workink', this.value)">
                    <option value="24">24 Hours (1 Checkpoint)</option>
                    <option value="48">48 Hours (2 Checkpoints)</option>
                    <option value="72">72 Hours (3 Checkpoints)</option>
                </select>
            </div>
            <div class="task-progress-wrapper">
                <div class="progress-text"><span>Progress: 0/<span class="prog-total">1</span></span></div>
                <div class="progress-bar"><div class="progress-fill" style="width: 0%;"></div></div>
            </div>
            <a href="/v1/generate?action=start&provider=workink&duration=24&step=1" class="btn-start" id="btn-workink"><i data-lucide="external-link" style="width: 16px;"></i> Start</a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Your Keys</th>
                        <th>Time Left</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="keysList">
                    <!-- Keys injected here -->
                </tbody>
            </table>
            <div style="display: flex; justify-content: center; margin-top: 24px;">
                <button class="btn-outline" onclick="window.scrollTo(0,0)"><i data-lucide="plus" style="width: 14px;"></i> GET A NEW KEY</button>
            </div>
        </div>

    </div>

    <div id="toast-container"></div>

    <script>
        lucide.createIcons();

        function updateDuration(provider, hours) {
            const card = document.getElementById('card-' + provider);
            
            // Calculate checkpoints based on hours selected
            let steps = 1;
            if (hours == '48') steps = 2;
            if (hours == '72') steps = 3;
            
            // Update UI text
            card.querySelector('.desc-duration').innerText = hours + ' Hours';
            card.querySelector('.prog-total').innerText = steps;
            
            // Update Start button URL to pass the duration and step 1 to backend
            const btn = document.getElementById('btn-' + provider);
            btn.href = `/v1/generate?action=start&provider=${provider}&duration=${hours}&step=1`;
        }

        function showToast(message, icon = "check-circle") {
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');
            toast.className = 'toast';
            toast.innerHTML = `<i data-lucide="${icon}" style="width:18px; color: var(--border-focus);"></i> ${message}`;
            container.appendChild(toast);
            lucide.createIcons();
            setTimeout(() => toast.remove(), 3300);
        }

        function copyCode(text) {
            navigator.clipboard.writeText(text);
            showToast("Key copied to clipboard!");
        }

        function formatTimeLeft(ms) {
            if (ms <= 0) return "Expired";
            const h = Math.floor(ms / (1000 * 60 * 60));
            const m = Math.floor((ms % (1000 * 60 * 60)) / (1000 * 60));
            const s = Math.floor((ms % (1000 * 60)) / 1000);
            return `${h}h ${m}m ${s}s`;
        }

        function renderKeys() {
            const tbody = document.getElementById('keysList');
            let keys = JSON.parse(localStorage.getItem('sedse_keys') || '[]');
            
            // SELF-CLEANING DEDUPLICATOR (Instantly clears duplicate keys)
            const uniqueKeys = [];
            const seen = new Set();
            keys.forEach(k => {
                if (!seen.has(k.key)) {
                    seen.add(k.key);
                    uniqueKeys.push(k);
                }
            });

            // Enforce hard limit of 3 in the dashboard UI
            if (uniqueKeys.length !== keys.length || uniqueKeys.length > 3) {
                if (uniqueKeys.length > 3) uniqueKeys.length = 3;
                localStorage.setItem('sedse_keys', JSON.stringify(uniqueKeys));
                keys = uniqueKeys;
            }
            
            if (keys.length === 0) {
                tbody.innerHTML = `<tr><td colspan="4" style="text-align:center; color: var(--text-muted); padding: 30px;">No keys found. Complete a task above to generate one.</td></tr>`;
                return;
            }

            tbody.innerHTML = '';
            keys.forEach(k => {
                const tr = document.createElement('tr');
                const timeLeftStr = formatTimeLeft(k.expiresAt - Date.now());
                const isExpired = Date.now() > k.expiresAt;
                
                tr.innerHTML = `
                    <td class="key-text">${k.key}</td>
                    <td class="time-left" data-expires="${k.expiresAt}">${timeLeftStr}</td>
                    <td><span class="status-badge ${isExpired ? 'status-expired' : ''}">${isExpired ? 'EXPIRED' : 'ACTIVE'}</span></td>
                    <td><button class="btn-outline" onclick="copyCode('${k.key}')"><i data-lucide="copy" style="width: 14px;"></i> Copy</button></td>
                `;
                tbody.appendChild(tr);
            });
            lucide.createIcons();
        }

        // Update timers every second
        setInterval(() => {
            document.querySelectorAll('.time-left').forEach(el => {
                const expires = parseInt(el.getAttribute('data-expires'));
                if(Date.now() > expires) {
                    el.innerText = "Expired";
                    el.nextElementSibling.innerHTML = `<span class="status-badge status-expired">EXPIRED</span>`;
                } else {
                    el.innerText = formatTimeLeft(expires - Date.now());
                }
            });
        }, 1000);

        renderKeys();
    </script>
</body>
</html>
