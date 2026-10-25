<!doctype html>
<html lang="en" dir="ltr">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<script>
			// iOS-only: stops Safari auto-zooming on sub-16px inputs; pinch zoom
			// still works there, and Android (which never auto-zooms) is untouched.
			(function () {
				var iOS =
					/iPhone|iPad|iPod/.test(navigator.userAgent) ||
					(navigator.userAgent.indexOf('Mac') !== -1 && 'ontouchend' in document);
				if (!iOS) return;
				var v = document.querySelector('meta[name="viewport"]');
				if (v) v.setAttribute('content', v.getAttribute('content') + ', maximum-scale=1');
			})();
		</script>
		<link rel="icon" href="/favicon.ico" sizes="any" />
		<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
		<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
		<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
		<link rel="manifest" href="/manifest.webmanifest" />
		<script>
			(function () {
				function readCookie(name) {
					var m = document.cookie.match(new RegExp('(?:^|; )' + name + '=([^;]*)'));
					return m ? decodeURIComponent(m[1]) : null;
				}
				function isMode(v) { return v === 'light' || v === 'dark' || v === 'system'; }
				var mode = readCookie('theme');
				try {
					var ls = window.localStorage;
					if (!isMode(mode)) {
						mode = ls.getItem('theme');
						if (!isMode(mode)) {
							var legacy = ls.getItem('app-theme');
							if (legacy === 'light' || legacy === 'dark') {
								mode = legacy;
								ls.setItem('theme', mode);
								ls.removeItem('app-theme');
							} else {
								mode = 'system';
							}
						}
					}
				} catch (e) { /* private mode, etc. */ }
				if (!isMode(mode)) mode = 'system';
				var effective = mode;
				if (mode === 'system') {
					effective = (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ? 'dark' : 'light';
				}
				var root = document.documentElement;
				root.setAttribute('data-theme', effective);
				root.setAttribute('data-app-theme', effective);
			})();
		</script>
		<!--175vhok--><meta name="theme-color" content="#4287f5"/> <meta name="google-site-verification" content="vQuxUxYxP_RNLS3LHfKPGMFV_tNZWDTq3zWmxSjKaT4"/> <meta name="google-adsense-account" content="ca-pub-9868622448050774"/> <!----><script type="application/ld+json">{"@context":"https://schema.org","@type":"Organization","@id":"https://bot-hosting.net/#organization","name":"Bot-Hosting","alternateName":"Bot-Hosting.net","url":"https://bot-hosting.net","logo":{"@type":"ImageObject","url":"https://bot-hosting.net/assets/img/bothosting2.png","width":613,"height":613},"foundingDate":"2021","email":"contact@bot-hosting.net","contactPoint":{"@type":"ContactPoint","contactType":"customer support","email":"contact@bot-hosting.net","availableLanguage":["en","fr"]},"sameAs":["https://discord.gg/6FKKj4qEM6"]}</script><!----> <!----><script type="application/ld+json">{"@context":"https://schema.org","@type":"WebSite","@id":"https://bot-hosting.net/#website","name":"Bot-Hosting","alternateName":"Bot-Hosting.net","url":"https://bot-hosting.net","inLanguage":["en","fr","de","ar","es","hi","bn","th","ro","it","nl","pl","ja","da","pt-BR","pt-PT","tr","ru","ko","zh-Hans","zh-Hant","vi","sv","no","cs","fil","km"],"publisher":{"@id":"https://bot-hosting.net/#organization"}}</script><!----> <!----><script>
window.dataLayer = window.dataLayer || [];
function gtag() { dataLayer.push(arguments); }
gtag('consent', 'default', {
	ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied', analytics_storage: 'denied',
	region: ["AT","BE","BG","HR","CY","CZ","DK","EE","FI","FR","DE","GR","HU","IE","IT","LV","LT","LU","MT","NL","PL","PT","RO","SK","SI","ES","SE","IS","LI","NO","GB","CH"], wait_for_update: 500
});
gtag('js', new Date());
gtag('config', 'G-S0VHSF9NEZ');
(function () {
	var add = function () {
		var s = document.createElement('script');
		s.async = true;
		s.src = 'https://www.googletagmanager.com/gtag/js?id=G-S0VHSF9NEZ';
		document.head.appendChild(s);
	};
	if ('requestIdleCallback' in window) window.requestIdleCallback(add, { timeout: 3000 });
	else window.addEventListener('load', function () { setTimeout(add, 1500); }, { once: true });
})();
</script><!----><!----><!--1cnf6t8--><link rel="preload" href="/_app/immutable/assets/geist-latin-wght-normal.BgDaEnEv.woff2" as="font" type="font/woff2" crossorigin="anonymous"/> <!--[-1--><!--]--> <!----><style>@font-face{font-family:'Geist';font-style:normal;font-display:swap;font-weight:100 900;src:url(/_app/immutable/assets/geist-latin-wght-normal.BgDaEnEv.woff2) format('woff2');unicode-range:U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD}@font-face{font-family:'Geist';font-style:normal;font-display:swap;font-weight:100 900;src:url(/_app/immutable/assets/geist-latin-ext-wght-normal.DC-KSUi6.woff2) format('woff2');unicode-range:U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF}@font-face{font-family:'Geist Mono';font-style:normal;font-display:swap;font-weight:100 900;src:url(/_app/immutable/assets/geist-mono-latin-wght-normal.XN7g48iV.woff2) format('woff2');unicode-range:U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD}@font-face{font-family:'Geist Mono';font-style:normal;font-display:swap;font-weight:100 900;src:url(/_app/immutable/assets/geist-mono-latin-ext-wght-normal.Bwz-egvJ.woff2) format('woff2');unicode-range:U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF}</style><!----><!----><!--1tqushu--><meta name="description" content="Log in to the Bot-Hosting.net panel with Discord, GitHub or email, or create a free account to deploy and manage your bots, websites and databases."/> <!--[-1--><!--]--> <meta name="author" content="Bot-Hosting.net"/> <meta name="apple-mobile-web-app-title" content="Bot-Hosting.net Login: Sign In or Create an Account"/> <link rel="canonical" href="https://bot-hosting.net/login"/> <!--[--><link rel="alternate" hreflang="en" href="https://bot-hosting.net/login"/><link rel="alternate" hreflang="fr" href="https://bot-hosting.net/fr/login"/><link rel="alternate" hreflang="de" href="https://bot-hosting.net/de/login"/><link rel="alternate" hreflang="ar" href="https://bot-hosting.net/ar/login"/><link rel="alternate" hreflang="es" href="https://bot-hosting.net/es/login"/><link rel="alternate" hreflang="hi" href="https://bot-hosting.net/hi/login"/><link rel="alternate" hreflang="bn" href="https://bot-hosting.net/bn/login"/><link rel="alternate" hreflang="th" href="https://bot-hosting.net/th/login"/><link rel="alternate" hreflang="ro" href="https://bot-hosting.net/ro/login"/><link rel="alternate" hreflang="it" href="https://bot-hosting.net/it/login"/><link rel="alternate" hreflang="nl" href="https://bot-hosting.net/nl/login"/><link rel="alternate" hreflang="pl" href="https://bot-hosting.net/pl/login"/><link rel="alternate" hreflang="ja" href="https://bot-hosting.net/ja/login"/><link rel="alternate" hreflang="da" href="https://bot-hosting.net/da/login"/><link rel="alternate" hreflang="pt-BR" href="https://bot-hosting.net/pt-BR/login"/><link rel="alternate" hreflang="pt-PT" href="https://bot-hosting.net/pt-PT/login"/><link rel="alternate" hreflang="tr" href="https://bot-hosting.net/tr/login"/><link rel="alternate" hreflang="ru" href="https://bot-hosting.net/ru/login"/><link rel="alternate" hreflang="ko" href="https://bot-hosting.net/ko/login"/><link rel="alternate" hreflang="zh-Hans" href="https://bot-hosting.net/zh-Hans/login"/><link rel="alternate" hreflang="zh-Hant" href="https://bot-hosting.net/zh-Hant/login"/><link rel="alternate" hreflang="vi" href="https://bot-hosting.net/vi/login"/><link rel="alternate" hreflang="sv" href="https://bot-hosting.net/sv/login"/><link rel="alternate" hreflang="no" href="https://bot-hosting.net/no/login"/><link rel="alternate" hreflang="cs" href="https://bot-hosting.net/cs/login"/><link rel="alternate" hreflang="fil" href="https://bot-hosting.net/fil/login"/><link rel="alternate" hreflang="km" href="https://bot-hosting.net/km/login"/><link rel="alternate" hreflang="x-default" href="https://bot-hosting.net/login"/><!--]--> <meta name="robots" content="noindex, nofollow"/> <meta property="og:type" content="website"/> <meta property="og:site_name" content="Bot-Hosting.net | A Free Host For Discord Bots"/> <meta property="og:title" content="Bot-Hosting.net Login: Sign In or Create an Account"/> <meta property="og:description" content="Log in to the Bot-Hosting.net panel with Discord, GitHub or email, or create a free account to deploy and manage your bots, websites and databases."/> <meta property="og:url" content="https://bot-hosting.net/login"/> <meta property="og:image" content="https://bot-hosting.net/assets/img/bothosting2.png"/> <!--[0--><meta property="og:image:width" content="613"/> <meta property="og:image:height" content="613"/><!--]--> <meta property="og:image:alt" content="Bot-Hosting.net Login: Sign In or Create an Account"/> <meta property="og:locale" content="en_US"/> <!--[0--><!--[--><meta property="og:locale:alternate" content="fr_FR"/><meta property="og:locale:alternate" content="de_DE"/><meta property="og:locale:alternate" content="ar_SA"/><meta property="og:locale:alternate" content="es_ES"/><meta property="og:locale:alternate" content="hi_IN"/><meta property="og:locale:alternate" content="bn_BD"/><meta property="og:locale:alternate" content="th_TH"/><meta property="og:locale:alternate" content="ro_RO"/><meta property="og:locale:alternate" content="it_IT"/><meta property="og:locale:alternate" content="nl_NL"/><meta property="og:locale:alternate" content="pl_PL"/><meta property="og:locale:alternate" content="ja_JP"/><meta property="og:locale:alternate" content="da_DK"/><meta property="og:locale:alternate" content="pt_BR"/><meta property="og:locale:alternate" content="pt_PT"/><meta property="og:locale:alternate" content="tr_TR"/><meta property="og:locale:alternate" content="ru_RU"/><meta property="og:locale:alternate" content="ko_KR"/><meta property="og:locale:alternate" content="zh_CN"/><meta property="og:locale:alternate" content="zh_TW"/><meta property="og:locale:alternate" content="vi_VN"/><meta property="og:locale:alternate" content="sv_SE"/><meta property="og:locale:alternate" content="nb_NO"/><meta property="og:locale:alternate" content="cs_CZ"/><meta property="og:locale:alternate" content="fil_PH"/><meta property="og:locale:alternate" content="km_KH"/><!--]--><!--]--> <meta name="twitter:card" content="summary"/> <meta name="twitter:site" content="@bothosting"/> <meta name="twitter:title" content="Bot-Hosting.net Login: Sign In or Create an Account"/> <meta name="twitter:description" content="Log in to the Bot-Hosting.net panel with Discord, GitHub or email, or create a free account to deploy and manage your bots, websites and databases."/> <meta name="twitter:image" content="https://bot-hosting.net/assets/img/bothosting2.png"/> <!----><!----><!----><title>Bot-Hosting.net Login: Sign In or Create an Account</title>
		<link href="./_app/immutable/assets/SiteFonts.hrY_xjvg.css" rel="stylesheet">
		<link href="./_app/immutable/assets/gtag.DmLzytRx.css" rel="stylesheet">
		<link href="./_app/immutable/assets/BrandMark.yrNZMVBz.css" rel="stylesheet">
		<link href="./_app/immutable/assets/3.DkzTadXl.css" rel="stylesheet">
		<link href="./_app/immutable/assets/31.CAJLbmVx.css" rel="stylesheet">
		
	</head>
	<body data-sveltekit-preload-data="hover">
		<div style="display: contents"><!--[--><!--[0--><!--[--><!--[0--><!--[--><!----> <div class="site landing"><!----><a href="#main" class="skip svelte-175vhok">Skip to content</a> <!--[0--><header class="wrap" style="padding-top: 20px; padding-bottom: 20px; display: flex; justify-content: space-between; align-items: center"><a href="/" aria-label="Bot-Hosting home" style="display: flex; align-items: center; gap: 10px; color: var(--ink)"><!--[-1--><img class="bm sq svelte-3wdkl3" src="/assets/img/bothosting.png" alt="" width="28" height="28"/><!--]--><!----> <span style="font-weight: 600; font-size: 16px; letter-spacing: -0.01em">Bot-Hosting</span></a> <a href="/" class="muted-link" style="font-size: 14px; display: inline-flex; align-items: center; gap: 6px">Back to site</a></header><!--]--> <main id="main" style="flex: 1 1 auto; display: flex; flex-direction: column"><!--[-1--><!--[--><!----> <!--[-1--><div style="flex: 1 1 auto; display: flex; align-items: center; justify-content: center; padding: 32px 20px 96px; min-height: calc(100vh - 69px)"><div class="in" style="width: 100%; max-width: 400px; display: flex; flex-direction: column; gap: 28px; font-size: 15px"><div style="display: flex; flex-direction: column; gap: 8px; text-align: center; align-items: center"><h1 style="margin: 0; font-size: 28px; font-weight: 600; letter-spacing: -0.025em">Log in or create an account</h1> <p style="margin: 0; color: var(--ink-3)">One account for all your bots, sites and databases.</p></div> <!--[-1--><!--]--> <!--[-1--><div style="display: flex; flex-direction: column; gap: 10px"><a href="/login/discord?redirect=%2Fa%2Fd%2F5fb3fd36-8995-4890-9205-46f340cfab13" data-sveltekit-reload="" class="btn btn-secondary btn-lg svelte-36ejl7" style="font-size: 15px" aria-disabled="false" aria-busy="false"><svg width="18" height="18" viewBox="0 0 24 24" fill="var(--discord)" aria-hidden="true" style="flex: none"><!--[--><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"></path><!--]--></svg><!---->Continue with Discord <!--[-1--><!--]--></a> <a href="/login/github?redirect=%2Fa%2Fd%2F5fb3fd36-8995-4890-9205-46f340cfab13" data-sveltekit-reload="" class="btn btn-secondary btn-lg svelte-36ejl7" style="font-size: 15px" aria-disabled="false" aria-busy="false"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" style="flex: none"><!--[--><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"></path><!--]--></svg><!---->Continue with GitHub <!--[-1--><!--]--></a></div> <!--[0--><div style="display: flex; align-items: center; gap: 12px; color: var(--ink-3); font-size: 13px"><span style="flex: 1 1 auto; height: 1px; background: var(--line-2)"></span>or<span style="flex: 1 1 auto; height: 1px; background: var(--line-2)"></span></div> <form style="display: flex; flex-direction: column; gap: 12px"><label for="email" style="font-size: 14px; font-weight: 500">Email</label> <input id="email" class="field" type="email" autocomplete="email" placeholder="you@example.com" value=""/> <button type="submit" class="btn btn-primary btn-lg" style="font-size: 15px; margin-top: 4px">Continue with email</button></form><!--]--><!--]--> <p style="margin: 0; font-size: 13px; color: var(--ink-3); text-align: center; line-height: 1.6">By continuing, you agree to the <a href="/legal" class="link" style="font-weight: 400">Terms</a> and <a href="/legal#privacy" class="link" style="font-weight: 400">Privacy policy</a>.</p></div></div><!--]--><!--]--><!--]--><!----></main> <!--[-1--><!--]--> <!--[-1--><!--]--> <!--[-1--><!--]--><!----><!----></div><!--]--><!--]--><!----><!--]--><!--]--> <!--[-1--><!--]--><!--]-->
			
			<script>
				{
					__sveltekit_l5jr8c = {
						base: new URL(".", location).pathname.slice(0, -1),
						env: {"PUBLIC_DISCORD_CLIENT_ID":"884382422530158623","PUBLIC_DISCORD_REDIRECT_URI":"https://bot-hosting.net/login","PUBLIC_DASHBOARD_URL":"https://bot-hosting.net/a","PUBLIC_DISCORD_SUPPORT":"https://discord.gg/6FKKj4qEM6","PUBLIC_LANDING_URL":"https://bot-hosting.net","PUBLIC_API_URL":"https://bot-hosting.net/api","PUBLIC_TURNSTILE_SITE_KEY":"0x4AAAAAADQmbqPdInKayDXc","PUBLIC_APPS_DOMAIN":"apps.bot-hosting.cloud","PUBLIC_EDGE_INGRESS":"ingress.bot-hosting.cloud"}
					};

					const element = document.currentScript.parentElement;

					Promise.all([
						import("./_app/immutable/entry/start.Df9-JcDR.js"),
						import("./_app/immutable/entry/app.DvfApDaX.js")
					]).then(([kit, app]) => {
						kit.start(app, element, {
							node_ids: [0, 3, 31],
							data: [null,{type:"data",data:{isAuthed:false,simCountry:null},uses:{}},{type:"data",data:{emailAuth:true,ban:null},uses:{search_params:["error","code"]}}],
							form: null,
							error: null
						});
					});
				}
			</script>
		</div>
	</body>
</html>
