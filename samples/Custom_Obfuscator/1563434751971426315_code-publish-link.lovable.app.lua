<!DOCTYPE html><html lang="en"><head><meta charSet="utf-8"/><meta name="viewport" content="width=device-width, initial-scale=1"/><link rel="stylesheet" href="/assets/styles-CbAvAvoS.css" data-precedence="default"/><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Arabic:wght@400;600;700&amp;family=Space+Grotesk:wght@700&amp;display=swap" data-precedence="default"/><title>HTML Publisher — انشر صفحتك فوراً</title><meta name="author" content="Lovable"/><meta name="twitter:site" content="@Lovable"/><meta name="description" content="الصق كود HTML، اختر اسم الرابط، وانشره على الإنترنت فوراً."/><meta property="og:title" content="HTML Publisher"/><meta property="og:description" content="الصق HTML واختر رابطك وانشر فوراً."/><meta property="og:type" content="website"/><meta name="twitter:card" content="summary"/><link rel="modulepreload" href="/assets/index-Cds5i_gb.js"/><link rel="modulepreload" href="/assets/routes-c5XdeloD.js"/><link rel="icon" href="/favicon.ico" type="image/x-icon"/>
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
<script defer src="/~flock.js" data-proxy-url="/~api/analytics"></script><script defer src="/__l5e/events.b21a279f52bb8621.js" data-artifact-kind="dwl_content_hash" data-artifact-id="05e12c230c87fa23f8f6a27e85b98b97d14d53e240052fa3ea4c3f3b444055bd" data-commit-sha="3e507aa40403b4640a4ed9c65864fccc697d89ea" data-context-token="v1.eyJwcm9qZWN0X2lkIjoibG92cF8yNjhtOWpzZzhmOTZiYnN6d3JjZzNybmtnbSIsImFydGlmYWN0X2tpbmQiOiJkd2xfY29udGVudF9oYXNoIiwiYXJ0aWZhY3RfaWQiOiIwNWUxMmMyMzBjODdmYTIzZjhmNmEyN2U4NWI5OGI5N2QxNGQ1M2UyNDAwNTJmYTNlYTRjM2YzYjQ0NDA1NWJkIiwiY29tbWl0X3NoYSI6IjNlNTA3YWE0MDQwM2I0NjQwYTRlZDljNjU4NjRmY2NjNjk3ZDg5ZWEiLCJleHAiOjE3OTU0MTQyOTd9.-lKSPpapF3bHgOTDK7b9LXL0Bdwc_LG_iwsgOUy1nfU"></script><meta name="twitter:title" content="HTML Publisher"><meta name="twitter:description" content="الصق HTML واختر رابطك وانشر فوراً."><meta property="og:image" content="https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/lovp_268m9jsg8f96bbszwrcg3rnkgm/24d08b2e588c92bf9d1111d9c5d028fb_1792568636292.png"><meta name="twitter:image" content="https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/lovp_268m9jsg8f96bbszwrcg3rnkgm/24d08b2e588c92bf9d1111d9c5d028fb_1792568636292.png"></head><body><!--$--><main dir="rtl" class="min-h-screen bg-background px-4 py-10 text-foreground"><div class="mx-auto max-w-5xl space-y-6"><h1 class="font-display text-4xl font-bold">HTML <span class="text-primary">Publisher</span></h1><div class="grid gap-4 lg:grid-cols-2"><textarea dir="ltr" aria-label="كود HTML" spellCheck="false" class="h-[420px] w-full resize-none rounded-xl border border-border bg-card p-4 font-mono text-sm outline-none focus:ring-2 focus:ring-ring">&lt;!doctype html&gt;
&lt;html lang=&quot;ar&quot; dir=&quot;rtl&quot;&gt;
&lt;head&gt;&lt;meta charset=&quot;utf-8&quot;&gt;&lt;title&gt;صفحتي&lt;/title&gt;&lt;/head&gt;
&lt;body style=&quot;font-family:sans-serif;text-align:center;padding:60px&quot;&gt;
  &lt;h1&gt;مرحباً بالعالم 👋&lt;/h1&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><iframe title="preview" srcDoc="&lt;!doctype html&gt;
&lt;html lang=&quot;ar&quot; dir=&quot;rtl&quot;&gt;
&lt;head&gt;&lt;meta charset=&quot;utf-8&quot;&gt;&lt;title&gt;صفحتي&lt;/title&gt;&lt;/head&gt;
&lt;body style=&quot;font-family:sans-serif;text-align:center;padding:60px&quot;&gt;
  &lt;h1&gt;مرحباً بالعالم 👋&lt;/h1&gt;
&lt;/body&gt;
&lt;/html&gt;" sandbox="allow-scripts" class="h-[420px] w-full rounded-xl border border-border bg-preview"></iframe></div><div class="flex flex-col gap-3 sm:flex-row"><div dir="ltr" class="flex flex-1 items-center overflow-hidden rounded-xl border border-border bg-card focus-within:ring-2 focus-within:ring-ring"><span class="px-3 text-sm text-muted-foreground">/s/</span><input aria-label="اسم الرابط" placeholder="ftx-ai" class="h-12 min-w-0 flex-1 bg-transparent pr-3 outline-none disabled:opacity-70" value=""/></div><button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm cursor-pointer focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 shadow hover:bg-primary/90 py-2 h-12 rounded-xl bg-primary px-8 font-semibold text-primary-foreground transition hover:opacity-90 disabled:opacity-50"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-upload" aria-hidden="true"><path d="M12 3v12"></path><path d="m17 8-5-5-5 5"></path><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path></svg>انشر</button><button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium cursor-pointer transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80 px-4 py-2 h-12"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-download" aria-hidden="true"><path d="M12 15V3"></path><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><path d="m7 10 5 5 5-5"></path></svg> تحميل الملف</button></div></div></main><script>(function(a,f){let l;try{l=JSON.parse(sessionStorage.getItem(a)||"{}")}catch{return}const n=l?.[f||history.state?.__TSR_key];let c=!1;for(const t in n){const e=n[t],o=e?.scrollX,s=e?.scrollY;if(Number.isFinite(o)&&Number.isFinite(s)){if(t==="window")scrollTo(o,s),c=!0;else if(t)try{const r=document.querySelector(t);r&&(r.scrollLeft=o,r.scrollTop=s)}catch{}}}if(c)return;const i=location.hash.slice(1);if(i){const t=history.state?.__hashScrollIntoViewOptions??!0;if(t){const e=document.getElementById(i);e&&e.scrollIntoView(t)}return}scrollTo(0,0)})("tsr-scroll-restoration-v1_3");document.currentScript.remove()</script><!--/$--><script data-tsr-stream-part="">(self.$R=self.$R||{})["tsr"]=[];self.$_TSR={h(){this.hydrated=!0,this.c()},e(){this.streamEnded=!0,this.c()},c(){this.hydrated&&this.streamEnded&&(delete self.$_TSR,delete self.$R.tsr)},p(e){this.initialized?e():this.buffer.push(e)},buffer:[]};$_TSR.router=($R=>$R[0]={manifest:$R[1]={routes:$R[2]={__root__:$R[3]={preloads:$R[4]=["/assets/index-Cds5i_gb.js"],scripts:$R[5]=[$R[6]={attrs:$R[7]={type:"module",async:!0,src:"/assets/index-Cds5i_gb.js"}}]},"/":$R[8]={preloads:$R[9]=["/assets/routes-c5XdeloD.js"]}}},matches:$R[10]=[$R[11]={i:"__root__ ",u:1792822297162,s:"success",ssr:!0},$R[12]={i:"  ",u:1792822297162,s:"success",ssr:!0}]})($R["tsr"]);$_TSR.e();{let s=document.currentScript,p;while((p=s.previousElementSibling)&&p.hasAttribute('data-tsr-stream-part'))p.remove();s.remove()}</script><script type="module" async="" src="/assets/index-Cds5i_gb.js"></script><script>document.currentScript.remove();/*$tsr-stream-boundary*/</script>
<aside
	id="lovable-badge"
	role="complementary"
	dir="ltr"
	lang="en"
	aria-label="Edit with Lovable">
	<a
		id="lovable-badge-cta" 
		target="_blank" 
		href="https://lovable.dev/projects/lovp_268m9jsg8f96bbszwrcg3rnkgm?utm_source=lovable-badge"
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