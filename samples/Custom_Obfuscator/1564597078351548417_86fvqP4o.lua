<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>uhhh</title>
<style>
*{box-sizing:border-box}
:root{--bg1:#080808;--bg2:#1c1c1c;--c1:#1a1a1a;--c2:#242424;--c3:#2a2a2a;--pn:#141414;--fg:#fff;--mut:#8a8a8a;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}
@media(prefers-color-scheme:light){:root{--bg1:#f2f2f2;--bg2:#e0e0e0;--c1:#e6e6e6;--c2:#d9d9d9;--c3:#cfcfcf;--pn:#fff;--fg:#111;--mut:#666}}
html{height:100%}
body{margin:0;min-height:100%;display:flex;align-items:center;justify-content:center;padding:20px;background:linear-gradient(135deg,var(--bg1) 0,var(--bg2) 100%);background-color:var(--bg1);color:var(--fg);font-family:Arial,sans-serif;overflow-x:hidden}
.dw{--u:clamp(54px,8vmin,72px);position:relative;display:flex;flex-direction:column;align-items:center}
.dd{display:flex;align-items:center;gap:calc(var(--u)*.18);height:var(--u);padding:0 calc(var(--u)*.35);border:0;border-radius:calc(var(--u)*.22);background:var(--c1);color:var(--fg);font:inherit;font-size:calc(var(--u)*.25);font-weight:500;cursor:pointer;-webkit-tap-highlight-color:transparent;transition:background .2s ease,transform .15s ease}
.dd:hover,.dd[aria-expanded="true"]{background:var(--c2)}
.dd:active{transform:scale(.97)}
.dd:focus-visible,.it:focus-visible{outline:2px solid var(--fg);outline-offset:2px}
.dd svg.ch{width:calc(var(--u)*.24);height:calc(var(--u)*.24);margin-left:calc(var(--u)*.04);transition:transform .22s cubic-bezier(.22,1,.36,1)}
.dd[aria-expanded="true"] svg.ch{transform:rotate(180deg)}
.mn{position:absolute;top:calc(100% + 8px);left:50%;width:min(300px,calc(100vw - 40px));display:flex;flex-direction:column;gap:.5em;padding:10px;border-radius:16px;background:var(--pn);border:1px solid var(--c3);box-shadow:0 16px 45px rgba(0,0,0,.35);font-size:15px;opacity:0;visibility:hidden;pointer-events:none;transform:translate(-50%,-8px) scale(.96);transform-origin:top center;transition:opacity .2s ease,transform .25s cubic-bezier(.22,1,.36,1),visibility 0s linear .25s;z-index:10}
.mn.op{opacity:1;visibility:visible;pointer-events:auto;transform:translate(-50%,0) scale(1);transition:opacity .2s ease,transform .25s cubic-bezier(.22,1,.36,1),visibility 0s}
.it{display:flex;align-items:center;gap:.85em;width:100%;padding:.8em .9em;border:0;border-radius:.8em;background:var(--c1);color:var(--fg);font:inherit;text-align:left;cursor:pointer;-webkit-tap-highlight-color:transparent;transition:background .15s ease,transform .15s ease,opacity .15s ease}
.it:hover{background:var(--c2)}
.it:active{transform:scale(.98)}
.it:disabled{opacity:.6;cursor:default}
.it:disabled img{filter:grayscale(1)}
.it:disabled:hover{background:var(--c1)}
.it:disabled:active{transform:none}
.it img{display:block;width:1.8em;height:1.8em;flex:0 0 1.8em;object-fit:contain}
.it .if{display:flex;flex-direction:column;gap:.4em;flex:1;min-width:0}
.it .nm{font-size:1em;font-weight:500;line-height:1}
.it .ds{font-size:.8em;color:var(--mut);line-height:1}
.nf{position:fixed;left:0;right:0;bottom:calc(24px + env(safe-area-inset-bottom,0px));display:flex;justify-content:center;pointer-events:none;z-index:20}
.no{padding:.85em 1.4em;border-radius:.85em;background:var(--c2);color:var(--fg);font-size:15px;font-weight:500;line-height:1;white-space:nowrap;max-width:calc(100vw - 40px);overflow:hidden;text-overflow:ellipsis;opacity:0;transform:translateY(60px);transition:opacity .25s ease,transform .35s cubic-bezier(.22,1,.36,1)}
.no.sh{opacity:1;transform:none}
@media(prefers-reduced-motion:reduce){*{transition-duration:.01ms!important}}
</style>
</head>
<body><a href="https://doitenroi.win/cdn-cgi/content?id=X6ULtqHwwkmFBHznOJ7fPLEej_kkQasUXeuJYtksDOI-1793099415.9466157-1.2.1.1-Lfjg4xU92pi4CAx83rwaJqwoe7O61dzB0_yf7WtHBhL6Nb82wFqYKEOEkyHLYqoZ" aria-hidden="true" rel="nofollow noopener" style="display: none !important; visibility: hidden !important"></a>
<div class="dw" id="dw">
  <button class="dd" id="dd" type="button" aria-haspopup="listbox" aria-expanded="false" aria-controls="mn">
    <span>Choose provider</span>
    <svg class="ch" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg>
  </button>
  <div class="mn" id="mn" role="listbox" aria-label="Providers"></div>
</div>
<div class="nf"><div class="no" id="no" role="status"></div></div>
<script>
const PROVIDERS=[
  {id:"linkvertise",name:"Linkvertise",desc:"Continue with Linkvertise",icon:"/icon/linkvertise.png",enabled:true},
  {id:"lootlabs",name:"LootLabs",desc:"Continue with LootLabs",icon:"/icon/lootlabs.png",enabled:true}
];
const dd=document.getElementById("dd"),mn=document.getElementById("mn"),no=document.getElementById("no");
let busy=false,tt;
const toast=t=>{no.textContent=t;no.classList.add("sh");clearTimeout(tt);tt=setTimeout(()=>no.classList.remove("sh"),1800)};
const setOpen=o=>{mn.classList.toggle("op",o);dd.setAttribute("aria-expanded",o)};
const code=window.location.pathname.split("/").filter(Boolean).pop();
PROVIDERS.forEach(p=>{
  const b=document.createElement("button");
  b.type="button";b.className="it";b.setAttribute("role","option");
  b.innerHTML='<img alt="" draggable="false"><div class="if"><div class="nm"></div><div class="ds"></div></div>';
  b.querySelector("img").src=p.icon;
  b.querySelector(".nm").textContent=p.name;
  b.querySelector(".ds").textContent=p.enabled?p.desc:"Unavailable";
  if(!p.enabled){b.disabled=true;b.setAttribute("aria-disabled","true")}
  b.addEventListener("click",()=>{
    if(busy||!p.enabled||!code)return;
    busy=true;
    mn.querySelectorAll(".it").forEach(x=>x.disabled=true);
    setOpen(false);
    toast("Redirecting via "+p.name);
    const url="/api/redsquare/"+encodeURIComponent(code)+"?provider="+encodeURIComponent(p.id);
    setTimeout(()=>{window.location.href=url},800);
  });
  mn.appendChild(b);
});
dd.addEventListener("click",e=>{e.stopPropagation();if(!busy)setOpen(!mn.classList.contains("op"))});
document.addEventListener("click",e=>{if(!e.target.closest("#dw"))setOpen(false)});
document.addEventListener("keydown",e=>{if(e.key==="Escape"){setOpen(false);dd.focus()}});
</script>
<script>window.__CF$cv$params={r:'a51140d5aa11d639',t:'MTc5MzA5OTQxNQ==',u:'01a17d0dc1a87429b251d4f40cd86853',ut:'D9lOKxH6oE9o5Li.j.3Vm5GKm8_VtXkaBqvuItMTUH0-1793099415-1.2.1.1-2uIAqanyNctEVDOjlCXUdMbNqYHHY5Oh.MNWF.TozL3EEb3n6JhyxiMq_MdrZYZaIOyWzhs2wqIL3QTNUBe6wO0wIy7YUg1Hf5aO3Xk3ags',i:60};(function(){if(!document.body)return;var s=document.createElement('script');s.src='/cdn-cgi/challenge-platform/scripts/precursor/main.js';document.head.appendChild(s);})();</script></body>
</html>