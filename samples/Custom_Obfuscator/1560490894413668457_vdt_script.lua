<!DOCTYPE html>
<html lang="id" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VDT | Script Violence District</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Space+Grotesk:wght@400;500;600;700;900&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdn.tailwindcss.com"></script>
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                        heading: ['Space Grotesk', 'sans-serif'],
                    },
                    colors: {
                        dark: '#020205',
                        darkCard: 'rgba(8, 8, 12, 0.8)',
                        primary: '#00f0ff',
                        secondary: '#ff003c',
                        accent: '#7000ff',
                    },
                    animation: {
                        'glow': 'glow 3s ease-in-out infinite alternate',
                        'spin-slow': 'spin 15s linear infinite',
                        'float': 'float 6s ease-in-out infinite',
                        'pulse-glow': 'pulseGlow 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
                    },
                    keyframes: {
                        glow: {
                            '0%': { boxShadow: '0 0 15px rgba(0, 240, 255, 0.15)' },
                            '100%': { boxShadow: '0 0 30px rgba(0, 240, 255, 0.4)' },
                        },
                        float: {
                            '0%, 100%': { transform: 'translateY(0)' },
                            '50%': { transform: 'translateY(-8px)' },
                        },
                        pulseGlow: {
                            '0%, 100%': { opacity: 1, filter: 'brightness(1)', transform: 'scale(1)' },
                            '50%': { opacity: .8, filter: 'brightness(1.3)', transform: 'scale(1.05)' },
                        }
                    }
                }
            }
        }
    </script>

    <style>
        body {
            background-color: #020205;
            color: #f8fafc;
            overflow-x: hidden;
            background-image: radial-gradient(circle at 50% 0%, #120722 0%, #020205 60%);
        }

        /* Ambient Background Noise/Texture */
        .noise-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            pointer-events: none;
            z-index: 50;
            opacity: 0.02;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E");
        }

        /* Glassmorphism Premium */
        .glass-panel {
            background: rgba(10, 10, 15, 0.6);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        /* Futuristic Card Hover */
        .cyber-card {
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            position: relative;
        }
        
        .cyber-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            border-radius: inherit;
            padding: 1px;
            background: linear-gradient(135deg, rgba(255,255,255,0.08), rgba(255,255,255,0));
            -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
            z-index: -1;
            transition: all 0.4s ease;
        }

        .cyber-card:hover {
            transform: translateY(-4px);
        }
        
        .cyber-card:hover::before {
            background: linear-gradient(135deg, #00f0ff, #7000ff);
        }

        /* Advanced Glitch Effect for main Title */
        .glitch-text {
            position: relative;
            color: white;
            font-weight: 900;
            text-transform: uppercase;
            text-shadow: 0 0 8px rgba(255, 255, 255, 0.2);
        }
        .glitch-text::before, .glitch-text::after {
            content: attr(data-text);
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: transparent;
        }
        .glitch-text::before {
            left: 2px;
            text-shadow: -1px 0 #ff003c;
            clip: rect(24px, 550px, 90px, 0);
            animation: glitch-anim 3s infinite linear alternate-reverse;
        }
        .glitch-text::after {
            left: -2px;
            text-shadow: -1px 0 #00f0ff;
            clip: rect(85px, 550px, 140px, 0);
            animation: glitch-anim 2.5s infinite linear alternate-reverse;
        }
        @keyframes glitch-anim {
            0% { clip: rect(71px, 9999px, 95px, 0); }
            20% { clip: rect(29px, 9999px, 83px, 0); }
            40% { clip: rect(96px, 9999px, 39px, 0); }
            60% { clip: rect(3px, 9999px, 62px, 0); }
            80% { clip: rect(52px, 9999px, 14px, 0); }
            100% { clip: rect(82px, 9999px, 73px, 0); }
        }

        /* Particle Background System */
        .particles {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            z-index: -1;
            overflow: hidden;
        }
        .particle {
            position: absolute;
            background: radial-gradient(circle, #00f0ff 0%, transparent 70%);
            border-radius: 50%;
            opacity: 0.2;
            animation: rise linear infinite;
        }
        @keyframes rise {
            0% { transform: translateY(100vh) scale(0); opacity: 0; }
            50% { opacity: 0.3; }
            100% { transform: translateY(-10vh) scale(1); opacity: 0; }
        }

        /* Text Gradients */
        .text-gradient-cyan {
            background: linear-gradient(to right, #ffffff, #00f0ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .text-gradient-purple {
            background: linear-gradient(to right, #00f0ff, #7000ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Scroll Reveal Utility */
        .reveal {
            opacity: 0;
            transform: translateY(20px) scale(0.98);
            transition: all 0.6s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .reveal.active {
            opacity: 1;
            transform: translateY(0) scale(1);
        }

        /* Custom Loader */
        .loader {
            border: 2px solid rgba(255,255,255,0.1);
            border-radius: 50%;
            border-top: 2px solid #00f0ff;
            width: 14px;
            height: 14px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { 100% { transform: rotate(360deg); } }

        /* Glowing Button */
        .btn-glow {
            position: relative;
            z-index: 1;
        }
        .btn-glow::before {
            content: '';
            position: absolute;
            top: -2px; left: -2px; right: -2px; bottom: -2px;
            background: linear-gradient(45deg, #00f0ff, #7000ff, #ff003c, #00f0ff);
            background-size: 400%;
            border-radius: inherit;
            z-index: -1;
            filter: blur(6px);
            opacity: 0;
            transition: opacity 0.3s ease;
            animation: glowing 20s linear infinite;
        }
        .btn-glow:hover::before { opacity: 0.6; }
        @keyframes glowing { 0% { background-position: 0 0; } 50% { background-position: 400% 0; } 100% { background-position: 0 0; } }
    </style>
</head>
<body class="antialiased selection:bg-primary selection:text-dark text-gray-200">

    <div class="noise-bg"></div>
    
    <div class="fixed top-[-10%] left-[-5%] w-[45vw] h-[45vw] rounded-full bg-accent/15 blur-[100px] pointer-events-none z-[-2]"></div>
    <div class="fixed bottom-[-10%] right-[-5%] w-[35vw] h-[35vw] rounded-full bg-primary/8 blur-[80px] pointer-events-none z-[-2]"></div>

    <div class="particles" id="particles-container"></div>

    <nav class="fixed w-full z-50 transition-all duration-300 py-3" id="navbar">
        <div class="max-w-6xl mx-auto px-4">
            <div class="glass-panel rounded-xl px-5 py-2 flex justify-between items-center transition-all duration-300" id="nav-inner">
                <a href="#" class="font-heading font-bold text-lg md:text-xl tracking-widest text-white flex items-center gap-2">
                    <div class="relative flex items-center justify-center">
                        <span class="absolute w-3 h-3 rounded-full bg-primary/30 animate-ping"></span>
                        <span class="relative w-1.5 h-1.5 rounded-full bg-primary"></span>
                    </div>
                    VDT SCRIPT
                </a>
                
                <div class="hidden sm:flex gap-6 text-xs font-semibold uppercase tracking-wider text-gray-400">
                    <a href="#home" class="hover:text-primary transition-all">Hub</a>
                    <a href="#features" class="hover:text-primary transition-all">Features</a>
                    <a href="#network" class="hover:text-primary transition-all">Community</a>
                </div>

                <a href="#network" class="bg-white/5 hover:bg-white/10 border border-white/10 text-white px-4 py-1.5 rounded-lg text-xs font-semibold transition-all hover:border-primary/50 flex items-center gap-1.5">
                    <i class="fa-solid fa-code text-[10px] text-primary"></i> GET SCRIPT
                </a>
            </div>
        </div>
    </nav>

    <section id="home" class="relative pt-24 pb-12 px-4 flex flex-col justify-center items-center overflow-hidden">

        <div class="text-center z-10 max-w-4xl mx-auto flex flex-col items-center">
            <div class="mb-5 inline-flex items-center gap-1.5 px-3 py-1 rounded-full border border-primary/20 bg-primary/5 backdrop-blur-md text-primary text-[10px] font-mono tracking-widest uppercase animate-float shadow-[0_0_10px_rgba(0,240,255,0.05)]">
                <span class="w-1 h-1 rounded-full bg-primary animate-pulse"></span>
                Undetected Roblox Execution
            </div>

            <div class="mb-2 relative w-full overflow-hidden px-2">
                <h1 class="glitch-text font-heading text-3xl sm:text-5xl md:text-7xl lg:text-8xl tracking-tight mx-auto" data-text="VIOLENCE DISTRICT">VIOLENCE DISTRICT</h1>
            </div>
            
            <h2 class="text-sm md:text-lg font-light text-gray-400 mb-5 tracking-[0.25em] uppercase">
                OWNED BY <span class="text-gradient-cyan font-bold">TIO</span>
            </h2>
            
            <p class="text-gray-400 max-w-xl mx-auto mb-8 text-xs md:text-sm leading-relaxed font-light">
                Akses script Roblox overpowered. Dilengkapi fitur serbaguna dan lengkap, auto-farm, fitur free, dan fitur eksklusif untuk mendominasi pengalaman bermain.
            </p>

            <div class="flex flex-row justify-center gap-4 w-full sm:w-auto">
                <a href="https://discord.gg/AHEBP9gWgw" target="_blank" class="btn-glow relative px-5 py-3 bg-white text-dark font-heading font-bold text-xs rounded-lg overflow-hidden transition-transform hover:scale-105 flex items-center justify-center gap-2">
                    <i class="fa-brands fa-discord text-sm"></i>
                    <span>JOIN DISCORD</span>
                </a>
                
                <a href="#features" class="px-5 py-3 glass-panel text-white font-heading font-bold text-xs rounded-lg hover:bg-white/5 transition-all hover:scale-105 flex items-center justify-center gap-2 border border-white/10 hover:border-primary/50">
                    <span>VIEW FEATURES</span>
                    <i class="fa-solid fa-crosshairs text-[10px] text-primary"></i>
                </a>
            </div>
        </div>
    </section>

    <section id="features" class="py-12 px-4 relative z-10 max-w-4xl mx-auto">
        <div class="text-center mb-8 reveal">
            <p class="text-primary font-mono text-[10px] tracking-widest uppercase mb-1">01 // Modules</p>
            <h2 class="text-2xl md:text-3xl font-heading font-black text-white uppercase tracking-tight">Script <span class="text-gradient-cyan">Features</span></h2>
            <div class="w-8 h-0.5 bg-primary mx-auto mt-3 rounded-full shadow-[0_0_8px_#00f0ff]"></div>
        </div>

        <div class="glass-panel rounded-2xl overflow-hidden border border-white/10 shadow-2xl reveal">
            <div class="bg-dark/80 px-4 py-2.5 border-b border-white/5 flex items-center justify-between text-[11px] font-mono text-gray-500">
                <div class="flex items-center gap-1.5">
                    <span class="w-2.5 h-2.5 rounded-full bg-red-500/60 inline-block"></span>
                    <span class="w-2.5 h-2.5 rounded-full bg-yellow-500/60 inline-block"></span>
                    <span class="w-2.5 h-2.5 rounded-full bg-green-500/60 inline-block"></span>
                    <span class="ml-2 text-gray-400 font-semibold text-[10px]">vdt_script.lua</span>
                </div>
                <div class="flex items-center gap-3 text-gray-400">
                    <span class="flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></span> SYSTEM OK</span>
                    <span class="opacity-50">v2.1</span>
                </div>
            </div>

            <div class="divide-y divide-white/5 bg-black/30">
                
                <div>
                    <button onclick="toggleDropdown('premium-content', 'premium-chevron')" class="w-full flex items-center justify-between p-4 bg-white/[0.01] hover:bg-white/[0.04] transition-all text-left focus:outline-none group">
                        <div class="flex items-center gap-3">
                            <i class="fa-solid fa-crown text-secondary text-base group-hover:scale-110 transition-transform"></i>
                            <div>
                                <h3 class="font-heading font-bold text-sm text-white tracking-wide">Premium / VIP Features</h3>
                                <p class="text-[10px] text-gray-500">Fitur eksklusif</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-3">
                            <span class="text-[9px] font-mono bg-secondary/10 border border-secondary/30 text-secondary px-2 py-0.5 rounded uppercase font-semibold">EXCLUSIVE</span>
                            <i id="premium-chevron" class="fa-solid fa-chevron-down text-xs text-gray-400 transition-transform duration-300"></i>
                        </div>
                    </button>

                    <div id="premium-content" class="transition-all duration-300 border-t border-white/5 bg-black/20 p-4">
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-2 text-xs">
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-robot text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Auto Farm & Master</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-bolt text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Multi Generator</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-box-open text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Auto Drop Pallet</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-shield text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Auto Parry (V1/V2/Fake)</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-skull-crossbones text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Killer One/Spam Hit</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-ban text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Auto Block Vault</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-crosshairs text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Silent Aim (Pistol/Veil)</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.02] border border-white/[0.03] hover:border-secondary/20 transition-all">
                                <i class="fa-solid fa-user-ninja text-secondary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Copy Avatar</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div>
                    <button onclick="toggleDropdown('free-content', 'free-chevron')" class="w-full flex items-center justify-between p-4 bg-white/[0.01] hover:bg-white/[0.04] transition-all text-left focus:outline-none group">
                        <div class="flex items-center gap-3">
                            <i class="fa-solid fa-circle-check text-primary text-base group-hover:scale-110 transition-transform"></i>
                            <div>
                                <h3 class="font-heading font-bold text-sm text-white tracking-wide">Fitur OP Gratis</h3>
                                <p class="text-[10px] text-gray-500">Kumpulan fitur umum bebas pakai tanpa batasan</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-3">
                            <span class="text-[9px] font-mono bg-primary/10 border border-primary/30 text-primary px-2 py-0.5 rounded uppercase font-semibold">FREE</span>
                            <i id="free-chevron" class="fa-solid fa-chevron-down text-xs text-gray-400 transition-transform duration-300"></i>
                        </div>
                    </button>

                    <div id="free-content" class="hidden transition-all duration-300 border-t border-white/5 bg-black/20 p-4">
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-2 text-xs">
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-heart-pulse text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">God Mode & Heal</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-circle-play text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Auto Skill Check</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-running text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Perks Mod (Speed/Vault)</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-person-running text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Auto Flee</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-angles-right text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Infinite Lunge</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-hourglass-half text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Inf Abyssal (No CD)</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-gauge-high text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Walk/Break Modifier</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-eye text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">ESP Master</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-triangle-exclamation text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Killer Warn</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-bullseye text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Stun Indicator</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-location-dot text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Global Teleport</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-wind text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Aura Fling</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-ghost text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Noclip & Fly</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-user-secret text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Spoofer (Fake Stats)</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-coffee text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Anti-AFK</span>
                            </div>
                            <div class="flex items-center gap-2 p-2 rounded bg-white/[0.01] border border-white/[0.03] hover:border-primary/20 transition-all">
                                <i class="fa-solid fa-sun text-primary/70 text-[10px]"></i>
                                <span class="text-gray-300 font-medium text-[11px]">Potato & Fullbright</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <section id="network" class="py-12 px-4 relative z-10 max-w-5xl mx-auto">
        <div class="text-center mb-10 reveal">
            <p class="text-primary font-mono text-[10px] tracking-widest uppercase mb-1">02 // Connections</p>
            <h2 class="text-2xl md:text-3xl font-heading font-black text-white uppercase tracking-tight">VDT <span class="text-gradient-purple">Community</span></h2>
            <div class="w-8 h-0.5 bg-primary mx-auto mt-3 rounded-full shadow-[0_0_8px_#00f0ff]"></div>
        </div>

        <div class="grid md:grid-cols-2 gap-6 max-w-4xl mx-auto">
            
            <div class="cyber-card glass-panel rounded-2xl p-5 reveal flex flex-col justify-between h-full relative overflow-hidden group">
                <div class="absolute top-0 right-0 w-24 h-24 bg-[#5865F2]/10 rounded-full blur-2xl -mr-6 -mt-6 group-hover:bg-[#5865F2]/20 transition-all"></div>
                <div class="absolute top-2 right-4 text-white/5 font-heading text-5xl font-black pointer-events-none select-none">VDT</div>
                
                <div class="relative z-10">
                    <div class="w-10 h-10 bg-[#5865F2]/20 border border-[#5865F2]/30 rounded-lg flex items-center justify-center mb-4 text-[#5865F2] text-xl shadow-[0_0_12px_rgba(88,101,242,0.15)]">
                        <i class="fa-brands fa-discord"></i>
                    </div>
                    <h3 class="text-xl font-heading font-bold mb-1.5 text-white tracking-tight">Script Hub VDT</h3>
                    <p class="text-gray-400 mb-5 text-xs leading-relaxed">Pusat komunitas VDT. Dapatkan update script, config gratis, laporkan bug & informasi mengenai script.</p>
                    
                    <div class="bg-dark/80 rounded-xl p-3 border border-white/5 mb-5 shadow-inner relative overflow-hidden">
                        <div class="absolute left-0 top-0 w-0.5 h-full bg-gradient-to-b from-[#5865F2] to-transparent"></div>
                        
                        <div class="flex justify-between items-center text-xs">
                            <span class="text-gray-400 font-mono flex items-center gap-1.5 text-[11px]">
                                <span class="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse shadow-[0_0_6px_#4ade80]"></span> STATUS: ONLINE
                            </span>
                            <span id="discord-online" class="font-bold text-white font-mono text-[13px] flex items-center">
                                <div class="loader"></div>
                            </span>
                        </div>
                        <div class="w-full h-px bg-white/5 my-2"></div>
                        <div class="flex justify-between items-center text-xs">
                            <span class="text-gray-400 font-mono flex items-center gap-1.5 text-[11px]">
                                <i class="fa-solid fa-users text-[10px] opacity-50"></i> TOTAL MEMBERS
                            </span>
                            <span id="discord-total" class="font-bold text-white font-mono text-[13px] flex items-center">
                                <div class="loader"></div>
                            </span>
                        </div>
                    </div>
                </div>

                <a href="https://discord.gg/AHEBP9gWgw" target="_blank" class="relative z-10 w-full py-2.5 bg-[#5865F2] hover:bg-[#4752C4] text-white rounded-lg text-xs font-heading font-bold tracking-wide flex items-center justify-center gap-2 transition-all hover:shadow-[0_0_15px_rgba(88,101,242,0.3)]">
                    ACCESS SERVER <i class="fa-solid fa-arrow-right text-[10px]"></i>
                </a>
            </div>

            <div class="cyber-card glass-panel rounded-2xl p-5 reveal flex flex-col justify-between h-full relative overflow-hidden group">
                <div class="absolute top-0 right-0 w-24 h-24 bg-[#ff0050]/5 rounded-full blur-2xl -mr-6 -mt-6 group-hover:bg-[#ff0050]/15 transition-all"></div>
                <div class="absolute bottom-0 left-0 w-24 h-24 bg-[#00f2fe]/5 rounded-full blur-2xl -ml-6 -mb-6 group-hover:bg-[#00f2fe]/15 transition-all"></div>
                <div class="absolute top-2 right-4 text-white/5 font-heading text-5xl font-black pointer-events-none select-none">LOG</div>

                <div class="relative z-10">
                    <div class="w-10 h-10 bg-gradient-to-br from-[#00f2fe]/20 to-[#ff0050]/20 border border-white/10 rounded-lg flex items-center justify-center mb-4 text-white text-xl">
                        <i class="fa-brands fa-tiktok"></i>
                    </div>
                    <h3 class="text-xl font-heading font-bold mb-1.5 text-white tracking-tight">Showcase & Gameplay</h3>
                    <p class="text-gray-400 mb-5 text-xs leading-relaxed">Tonton langsung fungsionalitas dan demonstrasi script Violence District secara real-time sebelum melakukan eksekusi.</p>
                    
                    <div class="bg-dark/80 rounded-xl p-3 border border-white/5 mb-5 shadow-inner flex items-center gap-3">
                        <div class="relative">
                            <div class="absolute inset-0 bg-gradient-to-r from-[#00f2fe] to-[#ff0050] rounded-full animate-spin-slow opacity-50 blur-xs"></div>
                            <div class="w-10 h-10 rounded-full bg-gray-900 border border-dark relative z-10 flex items-center justify-center overflow-hidden">
                                <img src="https://placehold.co/100x100/1a1a24/ffffff?text=TIO" alt="Tio Avatar" class="w-full h-full object-cover">
                            </div>
                        </div>
                        <div>
                            <div class="flex items-center gap-1.5">
                                <h4 class="font-bold text-white text-sm font-heading tracking-wide">tiooxy</h4>
                                <i class="fa-solid fa-code text-[#00f2fe] text-[10px]" title="VDT Owner"></i>
                            </div>
                            <p class="text-[10px] text-gray-500 font-mono">@tiooxy // VDT Founder</p>
                        </div>
                    </div>
                </div>

                <a href="https://www.tiktok.com/@tiooxy" target="_blank" class="relative z-10 w-full py-2.5 bg-white text-dark hover:bg-gray-200 rounded-lg text-xs font-heading font-bold tracking-wide flex items-center justify-center gap-2 transition-all hover:shadow-[0_0_15px_rgba(255,255,255,0.2)]">
                    <span class="bg-clip-text text-transparent bg-gradient-to-r from-[#ff0050] to-[#00f2fe] font-black">WATCH SHOWCASE</span>
                    <i class="fa-solid fa-play text-[10px] text-dark"></i>
                </a>
            </div>

        </div>
    </section>

    <footer class="border-t border-white/5 bg-darkCard backdrop-blur-xl mt-12 relative z-10">
        <div class="absolute top-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-primary/20 to-transparent"></div>
        <div class="max-w-6xl mx-auto px-6 py-6">
            
            <div class="flex flex-col sm:flex-row justify-between items-center gap-4 mb-4">
                <div class="flex flex-col items-center sm:items-start">
                    <span class="font-heading font-bold text-lg tracking-widest text-white">VIOLENCE DISTRICT</span>
                    <span class="text-[9px] font-mono text-primary/60 tracking-widest uppercase">PREMIUM SCRIPT HUB BY TIO</span>
                </div>
                
                <div class="flex gap-3">
                    <a href="https://discord.gg/AHEBP9gWgw" target="_blank" class="w-8 h-8 rounded-lg bg-white/5 border border-white/10 flex items-center justify-center text-gray-400 hover:text-white hover:border-[#5865F2] hover:bg-[#5865F2]/10 transition-all text-sm">
                        <i class="fa-brands fa-discord"></i>
                    </a>
                    <a href="https://www.tiktok.com/@tiooxy" target="_blank" class="w-8 h-8 rounded-lg bg-white/5 border border-white/10 flex items-center justify-center text-gray-400 hover:text-white hover:border-[#ff0050] hover:bg-gradient-to-br hover:from-[#00f2fe]/10 hover:to-[#ff0050]/10 transition-all text-sm">
                        <i class="fa-brands fa-tiktok"></i>
                    </a>
                </div>
            </div>
            
            <div class="flex flex-col sm:flex-row justify-between items-center text-[10px] font-mono text-gray-600 border-t border-white/5 pt-4">
                <p>&copy; <span id="year"></span> VDT SCRIPT. ALL RIGHTS RESERVED.</p>
                <p class="mt-1 sm:mt-0 flex items-center gap-1.5">
                    <span class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></span>
                    API HOOK: SECURE
                </p>
            </div>
        </div>
    </footer>

    <script>
        document.getElementById('year').textContent = new Date().getFullYear();

        function toggleDropdown(contentId, iconId) {
            const content = document.getElementById(contentId);
            const icon = document.getElementById(iconId);
            
            if (content.classList.contains('hidden')) {
                content.classList.remove('hidden');
                icon.classList.add('rotate-180');
            } else {
                content.classList.add('hidden');
                icon.classList.remove('rotate-180');
            }
        }

        document.getElementById('premium-chevron').classList.add('rotate-180');

        const navbar = document.getElementById('navbar');
        const navInner = document.getElementById('nav-inner');
        window.addEventListener('scroll', () => {
            if (window.scrollY > 30) {
                navbar.classList.add('py-1');
                navbar.classList.remove('py-3');
                navInner.classList.add('bg-darkCard', 'border-b', 'border-white/5');
                navInner.classList.remove('glass-panel');
            } else {
                navbar.classList.add('py-3');
                navbar.classList.remove('py-1');
                navInner.classList.add('glass-panel');
                navInner.classList.remove('bg-darkCard', 'border-b', 'border-white/5');
            }
        });

        function reveal() {
            const reveals = document.querySelectorAll(".reveal");
            for (let i = 0; i < reveals.length; i++) {
                const windowHeight = window.innerHeight;
                const elementTop = reveals[i].getBoundingClientRect().top;
                const elementVisible = 40;
                
                if (elementTop < windowHeight - elementVisible) {
                    reveals[i].classList.add("active");
                }
            }
        }
        window.addEventListener("scroll", reveal);
        reveal();

        const particlesContainer = document.getElementById('particles-container');
        const particleCount = 12;

        for (let i = 0; i < particleCount; i++) {
            let particle = document.createElement('div');
            particle.classList.add('particle');
            
            let size = Math.random() * 4 + 2;
            let left = Math.random() * 100;
            let duration = Math.random() * 12 + 8;
            let delay = Math.random() * 8;

            particle.style.width = `${size}px`;
            particle.style.height = `${size}px`;
            particle.style.left = `${left}vw`;
            particle.style.animationDuration = `${duration}s`;
            particle.style.animationDelay = `${delay}s`;

            particlesContainer.appendChild(particle);
        }

        async function fetchDiscordStats() {
            const onlineEl = document.getElementById('discord-online');
            const totalEl = document.getElementById('discord-total');
            const inviteCode = 'AHEBP9gWgw';
            
            try {
                const response = await fetch(`https://discord.com/api/v9/invites/${inviteCode}?with_counts=true`);
                
                if (!response.ok) throw new Error('API Request Failed');
                
                const data = await response.json();
                
                const formatNum = (num) => {
                    let str = new Intl.NumberFormat('en-US').format(num);
                    return str.padStart(5, '0');
                };
                
                setTimeout(() => {
                    let counter = 0;
                    let interval = setInterval(() => {
                        onlineEl.innerHTML = String(Math.floor(Math.random() * 9999)).padStart(5, '0');
                        totalEl.innerHTML = String(Math.floor(Math.random() * 9999)).padStart(5, '0');
                        counter++;
                        if(counter > 8) {
                            clearInterval(interval);
                            onlineEl.innerHTML = formatNum(data.approximate_presence_count);
                            totalEl.innerHTML = formatNum(data.approximate_member_count);
                            onlineEl.classList.add('text-primary');
                        }
                    }, 40);
                }, 300);

            } catch (error) {
                console.error('API Error:', error);
                onlineEl.innerHTML = 'OFFLINE';
                totalEl.innerHTML = 'UNAVAILABLE';
            }
        }

        fetchDiscordStats();
    </script>
</body>
</html>