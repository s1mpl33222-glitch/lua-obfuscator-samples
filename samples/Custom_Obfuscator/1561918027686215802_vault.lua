<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>VoidedX // SECURED</title>
    <link rel="icon" type="image/png" sizes="240x240" href="/voidedx-favicon.png?v=2">
    <link rel="shortcut icon" type="image/png" href="/voidedx-favicon.png?v=2">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1505057249528749" crossorigin="anonymous"></script>
</head>
<body>
    <div class="shell">
        <div class="promo-banner">
            <i class="fa-solid fa-rocket promo-icon"></i>
            <span><strong>VoidedX Script Vault</strong> — Fast, Free & Secure Roblox Script Hosting & Key System! Share your scripts safely.</span>
            <a href="/" class="btn-promo"><i class="fa-solid fa-plus"></i> Create a Vault</a>
        </div>
        <header class="top-nav">
            <a href="/" class="brand-unit brand-unit-link">
                <img src="logo.png" alt="VoidedX" class="brand-icon-img">
                <div class="brand-titles">
                    <span class="brand-name">VOIDEDX</span>
                    <span class="brand-tag">FREE</span>
                </div>
            </a>
        </header>

        <div class="flex-center">
        <div class="vault-visitor-stack">

            <!-- Loading -->
            <div id="loading-state" class="secured-card">
                <div class="shield-badge"><i class="fa-solid fa-spinner fa-spin text-cyan"></i></div>
                <h2>Checking vault…</h2>
                <p>Verifying this link against VoidedX Cloud.</p>
            </div>

            <!-- Not found -->
            <div id="error-state" class="secured-card hidden">
                <div class="shield-badge"><i class="fa-solid fa-triangle-exclamation text-red"></i></div>
                <h2>Vault Not Found</h2>
                <p id="error-message">This vault ID doesn't exist or may have been deleted.</p>
            </div>

            <!-- Key required -->
            <div id="keyprompt-state" class="secured-card hidden">
                <div class="shield-badge"><i class="fa-solid fa-key text-cyan"></i></div>
                <h2>Key Required</h2>
                <p id="keyprompt-title">This vault is protected by a key.</p>
                <div class="panel-group">
                    <label class="panel-label">ENTER KEY</label>
                    <input type="text" id="key-input" class="input-field" placeholder="Enter access key">
                    <span class="field-error hidden" id="key-error"></span>
                </div>
                <button id="key-submit-btn" class="btn-primary"><i class="fa-solid fa-unlock"></i> Unlock</button>
                <a id="get-key-link" href="#" class="btn-ghost key-open-link"><i class="fa-solid fa-key"></i> Don't have a key? Get one here</a>
            </div>

            <!-- Secured / verified -->
            <div id="secured-state" class="secured-card hidden">
                <div class="shield-badge">
                    <i class="fa-solid fa-shield-halved text-cyan"></i>
                </div>
                <h2>SECURED!</h2>
                <p id="secured-title">This script is protected by <strong>VoidedX Vault</strong>.</p>

                <div class="protection-tags">
                    <span><i class="fa-solid fa-eye-slash"></i> Source Hidden</span>
                    <span><i class="fa-solid fa-database"></i> Vault</span>
                    <span id="key-tag" class="hidden"><i class="fa-solid fa-key"></i> Key Verified</span>
                    <span id="key-expiry-tag" class="hidden"><i class="fa-solid fa-clock"></i> --</span>
                </div>

                <div class="loadstring-box">
                    <label>Copy Loadstring:</label>
                    <div class="copy-input">
                        <input type="text" id="loadstring-input" readonly>
                        <button id="copy-ls-btn" class="btn-accent"><i class="fa-solid fa-copy"></i> Copy</button>
                    </div>
                </div>
            </div>
        </div>
        </div>
    </div>

    <div id="toast-container" class="toast-container" aria-live="polite"></div>

    <script type="module">


        const loadingState = document.getElementById('loading-state');
        const errorState = document.getElementById('error-state');
        const errorMessage = document.getElementById('error-message');
        const keypromptState = document.getElementById('keyprompt-state');
        const keypromptTitle = document.getElementById('keyprompt-title');
        const keyInput = document.getElementById('key-input');
        const keyError = document.getElementById('key-error');
        const keySubmitBtn = document.getElementById('key-submit-btn');
        const securedState = document.getElementById('secured-state');
        const securedTitle = document.getElementById('secured-title');
        const keyTag = document.getElementById('key-tag');
        const keyExpiryTag = document.getElementById('key-expiry-tag');
        const loadstringInput = document.getElementById('loadstring-input');
        const copyBtn = document.getElementById('copy-ls-btn');

        function showOnly(el) {
            [loadingState, errorState, keypromptState, securedState].forEach(s => s.classList.add('hidden'));
            el.classList.remove('hidden');
        }

        function showToast(message, type = 'info', duration = 4000) {
            const container = document.getElementById('toast-container');
            const icons = { success: 'fa-circle-check', error: 'fa-circle-exclamation', info: 'fa-circle-info' };
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            toast.innerHTML = `<i class="fa-solid ${icons[type]} toast-icon"></i><span>${message}</span><button class="toast-close" aria-label="Dismiss"><i class="fa-solid fa-xmark"></i></button>`;
            const remove = () => { toast.classList.add('leaving'); setTimeout(() => toast.remove(), 200); };
            toast.querySelector('.toast-close').addEventListener('click', remove);
            container.appendChild(toast);
            if (duration > 0) setTimeout(remove, duration);
        }

        const urlParams = new URLSearchParams(window.location.search);
        const vaultId = urlParams.get('id');
        let providedKey = urlParams.get('key') || '';
        let vaultData = null;

        function buildLoadstring(id, key) {
            const keyParam = key ? `&key=${encodeURIComponent(key)}` : '';
            return `loadstring(game:HttpGet("${window.location.origin}/api/raw?id=${encodeURIComponent(id)}${keyParam}"))()`;
        }

        async function fetchInfo(key) {
            const r = await fetch(`/api/vaultinfo?id=${encodeURIComponent(vaultId)}${key ? `&key=${encodeURIComponent(key)}` : ''}`);
            return r.json();
        }

        function showSecured(data, key) {
            securedTitle.innerHTML = `<strong>${escapeHtml(data.title || 'Untitled Vault')}</strong> is protected by <strong>VoidedX Vault</strong>.`;
            keyTag.classList.toggle('hidden', !data.requireKey);
            loadstringInput.value = buildLoadstring(vaultId, key);

            if (data.expiresAt) {
                const msLeft = data.expiresAt - Date.now();
                const d = Math.floor(msLeft / 86400000);
                const h = Math.floor((msLeft % 86400000) / 3600000);
                keyExpiryTag.textContent = `Expires in ${d}d ${h}h`;
                keyExpiryTag.classList.remove('hidden');
            } else {
                keyExpiryTag.classList.add('hidden');
            }
            showOnly(securedState);
        }

        function escapeHtml(str) {
            const div = document.createElement('div');
            div.textContent = str || '';
            return div.innerHTML;
        }

        async function loadVault() {
            if (!vaultId) {
                errorMessage.textContent = 'No vault ID was provided in the link.';
                showOnly(errorState);
                return;
            }
            try {
                const data = await fetchInfo(providedKey);
                if (!data.ok) {
                    errorMessage.textContent = data.message || 'This vault could not be loaded.';
                    showOnly(errorState);
                    return;
                }
                vaultData = data;
                if (!data.requireKey) { showSecured(data, providedKey); return; }
                if (data.keyStatus === 'ok') { showSecured(data, providedKey); return; }
                if (data.keyStatus === 'terminated' || data.keyStatus === 'expired') {
                    errorMessage.textContent = data.keyStatus === 'terminated' ? 'This key has been terminated by the owner.' : 'This key has expired.';
                    showOnly(errorState);
                    return;
                }
                keypromptTitle.innerHTML = `<strong>${escapeHtml(data.title || 'This vault')}</strong> is protected by a key.`;
                document.getElementById('get-key-link').href = `/key.html?id=${encodeURIComponent(vaultId)}`;
                showOnly(keypromptState);
            } catch (err) {
                errorMessage.textContent = 'Something went wrong checking this vault.';
                showOnly(errorState);
            }
        }

        keySubmitBtn.addEventListener('click', async () => {
            const entered = keyInput.value.trim();
            keyError.classList.add('hidden');
            keyInput.classList.remove('error');
            const fail = (msg) => { keyError.textContent = msg; keyError.classList.remove('hidden'); keyInput.classList.add('error'); };
            if (!entered) return fail('Enter the access key.');
            try {
                const data = await fetchInfo(entered);
                if (!data.ok || data.keyStatus !== 'ok') {
                    return fail(data.keyStatus === 'terminated' ? 'This key has been terminated.'
                        : data.keyStatus === 'expired' ? 'This key has expired.' : 'Incorrect key. Try again.');
                }
                providedKey = entered;
                showSecured(data, providedKey);
            } catch (e) { fail('Could not check the key. Try again.'); }
        });

        keyInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') { e.preventDefault(); keySubmitBtn.click(); }
        });

        copyBtn.addEventListener('click', () => {
            navigator.clipboard.writeText(loadstringInput.value);
            copyBtn.innerHTML = '<i class="fa-solid fa-check"></i> Copied!';
            showToast('Loadstring copied to clipboard.', 'success', 2000);
            setTimeout(() => copyBtn.innerHTML = '<i class="fa-solid fa-copy"></i> Copy', 2000);
        });

        loadVault();
    </script>
</body>
</html>
