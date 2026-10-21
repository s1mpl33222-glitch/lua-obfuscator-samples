<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>K V N | Hub Control Panel</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Cairo', sans-serif; background-color: #0b0f19; color: #e2e8f0; }
        .glow-effect { box-shadow: 0 0 20px rgba(99,102,241,0.2); }
    </style>
</head>
<body class="p-4 md:p-8">

<div id="login-box" class="max-w-md mx-auto mt-20 bg-[#111827] p-8 rounded-2xl border border-gray-800 glow-effect">
    <h2 class="text-2xl font-bold text-center mb-6 text-indigo-400 font-mono tracking-widest">K V N  H U B</h2>
    <div class="space-y-4">
        <input type="text" id="username" placeholder="اسم المستخدم" class="w-full p-3 bg-[#1f2937] border border-gray-700 rounded-xl text-white focus:outline-none focus:border-indigo-500">
        <input type="password" id="password" placeholder="كلمة المرور" class="w-full p-3 bg-[#1f2937] border border-gray-700 rounded-xl text-white focus:outline-none focus:border-indigo-500">
        <button onclick="login()" class="w-full bg-indigo-600 hover:bg-indigo-700 font-bold py-3 rounded-xl transition">دخول الأدمن</button>
    </div>
    <p id="login-error" class="hidden text-red-400 text-xs text-center mt-4"></p>
</div>

<script>
    const SERVER_URL = window.location.origin;

    // إذا كان عنده توكن صالح، نوديه مباشرة للداشبورد
    if (localStorage.getItem('adminToken')) {
        window.location.href = '/dashboard';
    }

    async function login() {
        const u = document.getElementById('username').value.trim();
        const p = document.getElementById('password').value;
        const errEl = document.getElementById('login-error');

        if (!u || !p) {
            errEl.textContent = 'أدخل اسم المستخدم وكلمة المرور';
            errEl.classList.remove('hidden');
            return;
        }

        try {
            const res = await fetch(`${SERVER_URL}/api/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username: u, password: p })
            });

            const data = await res.json();

            if (data.success) {
                localStorage.setItem('adminToken', data.token);
                localStorage.setItem('adminUsername', u);
                window.location.href = '/dashboard';
            } else {
                errEl.textContent = '❌ خطأ في الدخول!';
                errEl.classList.remove('hidden');
            }
        } catch (e) {
            errEl.textContent = '❌ فشل الاتصال بالسيرفر';
            errEl.classList.remove('hidden');
        }
    }

    document.addEventListener('keydown', e => {
        if (e.key === 'Enter') login();
    });
</script>
</body>
</html>
