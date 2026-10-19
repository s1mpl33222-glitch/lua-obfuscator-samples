<!DOCTYPE html><html lang="vi" class="dark"><head><meta charSet="utf-8"/><meta name="viewport" content="width=device-width, initial-scale=1"/><link rel="preload" as="image" href="/assets/raw-sculpture-B6Prp_Ip.jpg"/><link rel="stylesheet" href="/assets/styles-B-NylFl3.css" data-precedence="default"/><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600;700&amp;family=Space+Grotesk:wght@400;500;600;700&amp;display=swap" data-precedence="default"/><title>ThanhDuyHub Project Raw</title><meta name="description" content="Trang hiển thị Project Raw của ThanhDuyHub."/><meta property="og:title" content="ThanhDuyHub Project Raw"/><meta property="og:description" content="Trang hiển thị Project Raw của ThanhDuyHub."/><meta property="og:type" content="website"/><meta name="twitter:card" content="summary"/><meta name="robots" content="noindex, nofollow"/><link rel="modulepreload" href="/assets/index-DVkmltlL.js"/><link rel="modulepreload" href="/assets/jsx-runtime-Cltr0gcK.js"/><link rel="modulepreload" href="/assets/dist-Dtbnq9k_.js"/><link rel="modulepreload" href="/assets/not-found-DIgawKw1.js"/><link rel="modulepreload" href="/assets/link-D4iki_Ag.js"/><link rel="modulepreload" href="/assets/matchContext-D7fiU5TJ.js"/><link rel="modulepreload" href="/assets/auth-Kqu5l5GK.js"/><link rel="modulepreload" href="/assets/useSelector-DXalI5tR.js"/><link rel="modulepreload" href="/assets/useRouter-CwjitLz4.js"/><link rel="modulepreload" href="/assets/raw._token-Dfz6zlXQ.js"/><link rel="modulepreload" href="/assets/raw-sculpture-k_a1h3_R.js"/><link rel="modulepreload" href="/assets/shield-check-DxYS0T48.js"/><link rel="preconnect" href="https://fonts.googleapis.com"/><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/><link rel="icon" href="/favicon.ico" type="image/x-icon"/>
<style>
	#lovable-badge {
		--badge-bg: #1b1b1b;
		--badge-text: #c5c1b9;
		--badge-text-hover: #dcdad5;
		--badge-radius: 6px;
		--badge-padding: 8px;
		--badge-gap: 6px;
		--badge-shadow: 
			0 0 0 1px rgba(0, 0, 0, 0.88),
			0 1px 0 0 rgba(0, 0, 0, 0.04),
			0 2px 2px -1px rgba(0, 0, 0, 0.08),
			0 4px 4px -2px rgba(0, 0, 0, 0.08),
			0 8px 8px -4px rgba(0, 0, 0, 0.08),
			0 16px 16px -8px rgba(0, 0, 0, 0.08);
		--badge-transition-duration: 0.2s;
		--badge-transition-easing: cubic-bezier(0.16, 1, 0.32, 1);
		--focus-color: #575ECF;
		--focus-offset: 2px;
		--focus-width: 2px;
		
		position: fixed;
		bottom: 12px;
		right: 12px;
		height: 24px;
		display: flex;
		align-items: center;
		z-index: 1000000;
		background-color: var(--badge-bg) !important;
		color: var(--badge-text) !important;
		border-radius: var(--badge-radius);
		box-shadow: var(--badge-shadow) !important;
		font-size: 12px;
		font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
		font-weight: 400 !important;
		text-transform: none !important;
		font-feature-settings: normal !important;
		transform: translateZ(0);
		will-change: transform, opacity;
		transition: opacity var(--badge-transition-duration) var(--badge-transition-easing);
	}

	#lovable-badge.closing {
		opacity: 0;
		pointer-events: none;
	}

	#lovable-badge-cta {
		display: flex;
		align-items: baseline;
		gap: var(--badge-gap);
		box-sizing: border-box;
		padding: 4px var(--badge-padding) 0;
		height: 100%;
		color: inherit;
		text-decoration: none;
		white-space: nowrap;
		border-radius: var(--badge-radius) 0 0 var(--badge-radius);
		transition: 
			background-color var(--badge-transition-duration) ease,
			color var(--badge-transition-duration) ease,
			transform 0.1s ease;
	}

	#lovable-badge-cta:hover {
		background: rgba(255, 255, 255, 0.04);
		color: var(--badge-text-hover);
	}

	#lovable-badge-cta:active {
		transform: scale(0.98);
	}

	#lovable-badge-cta:focus {
		outline: none;
	}

	#lovable-badge-cta:focus-visible {
		outline: var(--focus-width) solid var(--focus-color);
		outline-offset: var(--focus-offset);
		z-index: 1;
	}

	#lovable-badge-text {
		line-height: 1;
	}

	/* The wordmark baseline sits at y=12 of the 16px logo; an empty 12px box
	   makes that the flex baseline so the text aligns to it on any system font. */
	#lovable-badge-logo {
		position: relative;
		display: block;
		width: 52px;
		height: 12px;
	}

	#lovable-badge-logo svg {
		position: absolute;
		top: 0;
		left: 0;
	}

	#lovable-badge-divider {
		width: 1px;
		height: 24px;
		background-color: rgba(255, 255, 255, 0.04);
		flex-shrink: 0;
	}

	#lovable-badge-close {
		width: 24px;
		height: 24px;
		min-width: 24px;
		min-height: 24px;
		cursor: pointer;
		background: none;
		border: none;
		padding: 0;
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 0 var(--badge-radius) var(--badge-radius) 0;
		flex-shrink: 0;
		transition: 
			background-color var(--badge-transition-duration) ease,
			transform 0.1s ease;
	}

	#lovable-badge-close:hover {
		background: rgba(255, 255, 255, 0.04);
	}

	#lovable-badge-close:active {
		transform: scale(0.92);
	}

	#lovable-badge-close:focus {
		outline: none;
	}

	#lovable-badge-close:focus-visible {
		outline: var(--focus-width) solid var(--focus-color);
		outline-offset: calc(var(--focus-offset) * -1);
		z-index: 1;
	}

	#lovable-badge-close svg path {
		fill: var(--badge-text);
		transition: fill var(--badge-transition-duration) ease;
	}

	#lovable-badge-close:hover svg path {
		fill: var(--badge-text-hover);
	}

	@media (prefers-reduced-motion: reduce) {
		#lovable-badge,
		#lovable-badge-cta,
		#lovable-badge-close,
		#lovable-badge-close svg path {
			transition: none;
		}
		
		#lovable-badge-cta:active,
		#lovable-badge-close:active {
			transform: none;
		}
	}

	@media (prefers-contrast: high) {
		#lovable-badge {
			--badge-bg: #000;
			--badge-text: #fff;
			--badge-text-hover: #fff;
			border: 2px solid currentColor;
		}
		
		#lovable-badge-cta:focus-visible,
		#lovable-badge-close:focus-visible {
			outline-width: 3px;
		}
	}
</style>
<script defer src="/~flock.js" data-proxy-url="/~api/analytics"></script><script defer src="/__l5e/events.124894084da8c432.js" data-artifact-kind="dwl_content_hash" data-artifact-id="e944c0930596de247a3076552d2690f0f22ad890c7897c9e00ccbb58999504ea" data-commit-sha="45b1a2802ba06b9ca4d1dfba7f120ef2e3971916" data-context-token="v1.eyJwcm9qZWN0X2lkIjoibG92cF8xZmh6cWJyNDNoOTZnOHZ5azRtMzkyMjd5dyIsImFydGlmYWN0X2tpbmQiOiJkd2xfY29udGVudF9oYXNoIiwiYXJ0aWZhY3RfaWQiOiJlOTQ0YzA5MzA1OTZkZTI0N2EzMDc2NTUyZDI2OTBmMGYyMmFkODkwYzc4OTdjOWUwMGNjYmI1ODk5OTUwNGVhIiwiY29tbWl0X3NoYSI6IjQ1YjFhMjgwMmJhMDZiOWNhNGQxZGZiYTdmMTIwZWYyZTM5NzE5MTYiLCJleHAiOjE3OTUwMDIwNjB9.4IrrvpCub-azyKodtIIFRxP9k1hrKr0gJ4V1NlorucU"></script><meta name="twitter:title" content="ThanhDuyHub Project Raw"><meta name="twitter:description" content="Trang hiển thị Project Raw của ThanhDuyHub."><meta property="og:image" content="https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/lovp_1fhzqbr43h96g8vyk4m39227yw/e6d0895a33f6f0e487ebbfcd6e738893_1792409081636.png"><meta name="twitter:image" content="https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/lovp_1fhzqbr43h96g8vyk4m39227yw/e6d0895a33f6f0e487ebbfcd6e738893_1792409081636.png"></head><body><!--$--><main class="relative flex min-h-screen flex-col overflow-hidden bg-background"><img src="/assets/raw-sculpture-B6Prp_Ip.jpg" alt="" width="1536" height="1024" class="absolute inset-0 h-full w-full object-cover opacity-50"/><div class="relative mx-auto flex w-full max-w-7xl flex-1 flex-col px-6 py-8 sm:px-12"><header class="flex justify-between border-b border-border pb-6"><span class="flex items-center gap-3 font-display font-bold"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-code-xml text-primary" aria-hidden="true"><path d="m18 16 4-4-4-4"></path><path d="m6 8-4 4 4 4"></path><path d="m14.5 4-5 16"></path></svg> TDH / PROJECT</span><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shield-check text-highlight" aria-hidden="true"><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"></path><path d="m9 12 2 2 4-4"></path></svg></header><section class="flex flex-1 flex-col justify-center py-16"><p class="font-mono text-xs uppercase text-highlight">Project / Raw</p><h1 class="mt-6 max-w-xl font-display text-5xl font-bold leading-tight sm:text-7xl">ThanhDuyHub<br/><span class="text-highlight">Project Raw</span></h1><div role="status" class="raw-loading mt-10 max-w-xs"><span class="font-mono text-xs text-muted-foreground">Loading raw…</span><div class="raw-loading-track mt-3 h-1 overflow-hidden bg-muted"><span class="block h-full w-full origin-left bg-primary"></span></div></div><p class="raw-ready mt-5 flex items-center gap-2 font-mono text-xs text-highlight"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shield-check size-4" aria-hidden="true"><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"></path><path d="m9 12 2 2 4-4"></path></svg> Project Raw</p></section><footer class="border-t border-border pt-5 font-mono text-xs text-muted-foreground">THANHDUYHUB / RAW</footer></div></main><script>(function(a,f){let l;try{l=JSON.parse(sessionStorage.getItem(a)||"{}")}catch{return}const n=l?.[f||history.state?.__TSR_key];let c=!1;for(const t in n){const e=n[t],o=e?.scrollX,s=e?.scrollY;if(Number.isFinite(o)&&Number.isFinite(s)){if(t==="window")scrollTo(o,s),c=!0;else if(t)try{const r=document.querySelector(t);r&&(r.scrollLeft=o,r.scrollTop=s)}catch{}}}if(c)return;const i=location.hash.slice(1);if(i){const t=history.state?.__hashScrollIntoViewOptions??!0;if(t){const e=document.getElementById(i);e&&e.scrollIntoView(t)}return}scrollTo(0,0)})("tsr-scroll-restoration-v1_3");document.currentScript.remove()</script><!--/$--><section aria-label="Notifications alt+T" tabindex="-1" aria-live="polite" aria-relevant="additions text" aria-atomic="false"></section><script data-tsr-stream-part="">(self.$R=self.$R||{})["tsr"]=[];self.$_TSR={h(){this.hydrated=!0,this.c()},e(){this.streamEnded=!0,this.c()},c(){this.hydrated&&this.streamEnded&&(delete self.$_TSR,delete self.$R.tsr)},p(e){this.initialized?e():this.buffer.push(e)},buffer:[]};$_TSR.router=($R=>$R[0]={manifest:$R[1]={routes:$R[2]={__root__:$R[3]={preloads:$R[4]=["/assets/index-DVkmltlL.js","/assets/jsx-runtime-Cltr0gcK.js","/assets/dist-Dtbnq9k_.js","/assets/not-found-DIgawKw1.js","/assets/link-D4iki_Ag.js","/assets/matchContext-D7fiU5TJ.js","/assets/auth-Kqu5l5GK.js","/assets/useSelector-DXalI5tR.js","/assets/useRouter-CwjitLz4.js"],scripts:$R[5]=[$R[6]={attrs:$R[7]={type:"module",async:!0,src:"/assets/index-DVkmltlL.js"}}]},"/raw/$token":$R[8]={preloads:$R[9]=["/assets/raw._token-Dfz6zlXQ.js","/assets/raw-sculpture-k_a1h3_R.js","/assets/shield-check-DxYS0T48.js"]}}},matches:$R[10]=[$R[11]={i:"__root__ ",u:1792410060915,s:"success",ssr:!0},$R[12]={i:" raw $token raw 4c6852463d0af8dcfd8c2cc107d58149",u:1792410060915,s:"success",ssr:!0}]})($R["tsr"]);$_TSR.e();{let s=document.currentScript,p;while((p=s.previousElementSibling)&&p.hasAttribute('data-tsr-stream-part'))p.remove();s.remove()}</script><script type="module" async="" src="/assets/index-DVkmltlL.js"></script><script>document.currentScript.remove();/*$tsr-stream-boundary*/</script>
<aside
	id="lovable-badge"
	role="complementary"
	dir="ltr"
	lang="en"
	aria-label="Edit with Lovable">
	<a
		id="lovable-badge-cta" 
		target="_blank" 
		href="https://lovable.dev/projects/lovp_1fhzqbr43h96g8vyk4m39227yw?utm_source=lovable-badge"
		rel="noopener nofollow"
		aria-label="Edit with Lovable">
		<span id="lovable-badge-text">Edit with</span>
		<span id="lovable-badge-logo"><svg xmlns="http://www.w3.org/2000/svg" width="52" height="16" fill="none" viewBox="0 0 52 16">
  <path fill="#FCFBF8" fill-rule="evenodd" d="M20.318 5.25c.643 0 1.206.14 1.69.418a2.81 2.81 0 0 1 1.118 1.191c.266.513.4 1.115.4 1.807s-.134 1.296-.4 1.812a2.81 2.81 0 0 1-1.118 1.193c-.484.278-1.047.418-1.69.418s-1.208-.14-1.695-.418a2.85 2.85 0 0 1-1.125-1.193c-.262-.516-.393-1.12-.393-1.812s.131-1.294.393-1.807a2.848 2.848 0 0 1 1.125-1.191c.487-.279 1.052-.418 1.695-.418Zm0 1.425c-.27 0-.504.076-.7.228-.193.147-.34.37-.443.67-.102.295-.153.66-.153 1.093 0 .435.05.801.153 1.1.102.3.25.524.443.676.196.147.43.22.7.22.27 0 .502-.073.694-.22.193-.152.341-.375.443-.67.103-.299.153-.667.153-1.106 0-.65-.112-1.145-.337-1.481a1.08 1.08 0 0 0-.953-.51ZM32.7 5.25c.61 0 1.127.1 1.549.3.422.197.74.48.953.849.217.368.325.809.325 1.32v2.704c0 .29.02.562.062.812.044.245.108.4.19.466V12h-1.935a5.895 5.895 0 0 1-.105-.684 7.745 7.745 0 0 1-.02-.228 2.293 2.293 0 0 1-.151.203c-.205.242-.47.437-.793.584-.32.143-.685.215-1.094.215-.406 0-.77-.08-1.094-.24a1.845 1.845 0 0 1-.756-.682 1.984 1.984 0 0 1-.27-1.045c0-.606.178-1.069.535-1.388.356-.324.87-.534 1.542-.633l1.125-.16c.225-.032.403-.074.534-.123a.622.622 0 0 0 .288-.196.549.549 0 0 0 .093-.327.65.65 0 0 0-.11-.367.702.702 0 0 0-.32-.27c-.14-.07-.31-.105-.51-.105-.32 0-.576.083-.768.251-.193.164-.298.39-.314.676h-1.923c.016-.434.147-.82.393-1.155.25-.34.596-.604 1.039-.792.442-.189.954-.283 1.535-.283Zm.99 3.498a.98.98 0 0 1-.215.14 2.49 2.49 0 0 1-.584.178l-.473.092c-.315.061-.553.156-.713.283-.155.127-.233.305-.233.534 0 .23.084.412.252.547.168.135.383.203.645.203s.494-.058.694-.173c.201-.118.355-.282.461-.49.11-.21.166-.448.166-.714v-.6Zm4.526-2.375c.065-.125.138-.243.221-.349.197-.25.437-.44.719-.571.282-.135.6-.203.952-.203.528 0 .988.138 1.377.412.389.275.688.67.896 1.186.21.512.314 1.12.314 1.824 0 .7-.107 1.309-.32 1.825-.213.512-.518.906-.915 1.18-.393.275-.854.412-1.383.412-.352 0-.667-.062-.946-.184a1.832 1.832 0 0 1-.7-.554 2.2 2.2 0 0 1-.234-.383V12h-1.843V3h1.862v3.373Zm1.284.296c-.274 0-.51.085-.707.253-.192.163-.338.397-.436.7a3.376 3.376 0 0 0-.148 1.05c0 .406.05.759.148 1.058.098.299.243.53.436.694.197.164.433.246.707.246.279 0 .512-.082.7-.246.193-.164.336-.395.43-.694.099-.3.148-.652.148-1.058 0-.405-.05-.757-.147-1.056-.095-.299-.238-.53-.43-.694a1.015 1.015 0 0 0-.7-.253Zm9.416-1.419c.602 0 1.136.131 1.604.393.466.262.829.643 1.086 1.143.263.5.394 1.097.394 1.794 0 .25-.002.449-.006.596H47.51c.018.288.071.538.164.75a1.3 1.3 0 0 0 .491.596c.214.13.465.196.757.196.319 0 .583-.082.792-.246.209-.167.34-.403.393-.706h1.862a2.48 2.48 0 0 1-.485 1.235 2.54 2.54 0 0 1-1.051.805c-.439.188-.949.283-1.53.283-.655 0-1.225-.125-1.708-.375a2.672 2.672 0 0 1-1.13-1.143c-.267-.508-.4-1.137-.4-1.887 0-.712.14-1.327.418-1.843a2.86 2.86 0 0 1 1.155-1.186c.491-.27 1.051-.405 1.678-.405Zm-.044 1.345c-.274 0-.516.068-.725.203a1.29 1.29 0 0 0-.479.59 2.045 2.045 0 0 0-.132.498h2.562a1.873 1.873 0 0 0-.138-.602 1.061 1.061 0 0 0-.418-.516 1.243 1.243 0 0 0-.67-.173Z" clip-rule="evenodd"/>
  <path fill="#FCFBF8" d="m26.605 9.995 1.342-4.566h1.924L27.628 12h-2.07l-2.33-6.57h1.98l1.397 4.565Zm-13.013.143h2.256c1.632 0 1.421 1.837 1.418 1.861h-5.603V3h1.93v7.138Zm31.516 1.861h-1.862V3h1.862v8.999Z"/>
  <path fill="url(#a)" fill-rule="evenodd" d="M2.7 3c1.492 0 2.7 1.192 2.7 2.663v1.012h.9c1.49 0 2.7 1.192 2.7 2.662S7.791 12 6.3 12H0V5.663C0 4.193 1.209 3 2.7 3Z" clip-rule="evenodd"/>
  <defs>
    <radialGradient id="a" cx="0" cy="0" r="1" gradientTransform="matrix(-1.54236 7.07838 -10.231 -2.15602 4.627 5.022)" gradientUnits="userSpaceOnUse">
      <stop offset=".106" stop-color="#FE7B02"/>
      <stop offset=".394" stop-color="#FE3F21"/>
      <stop offset=".608" stop-color="#F858BC"/>
      <stop offset=".929" stop-color="#575ECF"/>
    </radialGradient>
  </defs>
</svg>

</span>
	</a>
	
	<span id="lovable-badge-divider" aria-hidden="true"></span>
	
	<button 
		id="lovable-badge-close"
		aria-label="Dismiss"
		title="Dismiss"
		type="button">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" viewBox="0 0 16 16" aria-hidden="true">
			<path d="M10.646 4.646a.5.5 0 1 1 .707.708L8.707 8l2.646 2.646a.5.5 0 1 1-.707.707L8 8.707l-2.646 2.646a.5.5 0 1 1-.708-.707L7.293 8 4.646 5.354a.5.5 0 1 1 .708-.708L8 7.293l2.646-2.647Z"/>
		</svg>
	</button>
</aside>
<script>
	(() => {
		if (window.self !== window.top || navigator.userAgent.includes('puppeteer')) {
			const badge = document.querySelector('#lovable-badge');
			if (badge) {
				badge.style.display = 'none';
			}
			return;
		}

		const closeButton = document.querySelector('#lovable-badge-close');
		if (closeButton) {
			closeButton.addEventListener('click', function(event) {
				event.preventDefault();
				event.stopPropagation();
				const badge = document.querySelector('#lovable-badge');
				if (badge) {
					badge.classList.add('closing');
					setTimeout(function() {
						if (badge) {
							badge.style.display = 'none';
						}
					}, 240);
				}
			});
		}
	})();
</script>
</body></html>