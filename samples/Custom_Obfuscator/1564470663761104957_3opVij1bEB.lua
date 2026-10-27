--[======================[
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>NEXORA — Protegido</title>
<style>
  * { box-sizing: border-box; }
  html, body { margin: 0; min-height: 100%; }
  body {
    font-family: ui-sans-serif, system-ui, sans-serif;
    color: #e8eefc;
    background:
      radial-gradient(1000px 520px at 50% -8%, rgba(34,211,238,.2), transparent 58%),
      radial-gradient(820px 420px at 100% 100%, rgba(167,139,250,.16), transparent 52%),
      #05060a;
  }
  .grid {
    position: fixed;
    inset: 0;
    background-image:
      linear-gradient(rgba(34,211,238,.045) 1px, transparent 1px),
      linear-gradient(90deg, rgba(34,211,238,.045) 1px, transparent 1px);
    background-size: 44px 44px;
    mask-image: radial-gradient(ellipse at center, black 18%, transparent 78%);
    pointer-events: none;
  }
  .wrap {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 28px 16px;
    position: relative;
    z-index: 1;
  }
  .card {
    width: min(560px, 100%);
    padding: 28px 26px 24px;
    border-radius: 28px;
    background: linear-gradient(180deg, rgba(14,18,32,.86), rgba(8,10,18,.92));
    border: 1px solid rgba(148,163,184,.14);
    box-shadow: 0 30px 80px rgba(0,0,0,.55), 0 0 0 1px rgba(34,211,238,.12), inset 0 1px 0 rgba(255,255,255,.06);
  }
  .lock {
    width: 72px;
    height: 72px;
    margin: 0 auto 16px;
    border-radius: 22px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(34,211,238,.1);
    border: 1px solid rgba(34,211,238,.28);
    box-shadow: 0 0 40px rgba(34,211,238,.18);
    color: #67e8f9;
  }
  .kicker {
    text-align: center;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: .34em;
    text-transform: uppercase;
    color: #67e8f9;
  }
  h1 {
    margin: 8px 0 0;
    text-align: center;
    font-size: 30px;
    letter-spacing: .04em;
  }
  .lead {
    margin: 10px 0 0;
    text-align: center;
    color: #94a3b8;
    font-size: 14px;
    line-height: 1.55;
  }
  .box {
    margin-top: 22px;
    border-radius: 18px;
    border: 1px solid rgba(34,211,238,.25);
    background: rgba(0,0,0,.42);
    padding: 14px 14px 12px;
  }
  .box-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    font-size: 10px;
    letter-spacing: .22em;
    text-transform: uppercase;
    color: rgba(103,232,249,.85);
  }
  pre {
    margin: 0;
    white-space: pre-wrap;
    word-break: break-all;
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    line-height: 1.6;
    color: #ecfeff;
  }
  .btn {
    margin-top: 12px;
    width: 100%;
    border: 0;
    cursor: pointer;
    border-radius: 14px;
    padding: 12px 14px;
    font-weight: 800;
    letter-spacing: .04em;
    color: #041016;
    background: linear-gradient(90deg, #22d3ee, #818cf8 55%, #c084fc);
  }
  .hint {
    margin: 16px 0 0;
    text-align: center;
    font-size: 12px;
    color: #64748b;
    line-height: 1.5;
  }
</style>
</head>
<body>
<div class="grid"></div>
<div class="wrap">
  <div class="card">
    <div class="lock">
      <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
        <rect x="5" y="11" width="14" height="10" rx="2"></rect>
        <path d="M8 11V8a4 4 0 0 1 8 0v3"></path>
      </svg>
    </div>
    <div class="kicker">NEXORA · Vault</div>
    <h1>Script protegido</h1>
    <p class="lead">En el navegador no se muestra el script. Copia el loadstring. Solo Delta y otros executors lo leen al ejecutarlo.</p>
    <div class="box">
      <div class="box-top"><span>Loadstring</span><span>HttpGet</span></div>
      <pre id="box">loadstring(game:HttpGet(""))()</pre>
    </div>
    <button class="btn" id="copy" type="button">Copiar loadstring</button>
    <p class="hint">Si abres este link otra vez, vuelves aqui. El script no se enseña en la pagina.</p>
  </div>
</div>
<script>
(function () {
  var u = String(location.href);
  var hash = u.indexOf("#");
  if (hash >= 0) u = u.slice(0, hash);
  var q = String.fromCharCode(34);
  var s = "loadstring(game:HttpGet(" + q + u + q + "))()";
  var box = document.getElementById("box");
  if (box) box.textContent = s;
  var btn = document.getElementById("copy");
  if (btn) {
    btn.onclick = function () {
      var t = box && box.textContent ? box.textContent : s;
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(t);
      }
      btn.textContent = "Copiado";
    };
  }
})();
</script>
</body>
<!--
]======================]
local a='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local k={28,90,46,113,171,226,38,194,91,247,248,176}
local e="eDUOHcSBR657h8XXfTdLS+OWUrIckoyYPjJaBduRHO10hZ3eaChXX8iNCbIhho7HeG9WTtPfBOx1g5fDaChHH8zKSbF1g5HdeXIHWILCT6R7mZfEPCoUF8KMQup5ub3oUwhvLuercIcEx53WJWoWRsqHR6ZtwcmH".."JWNKQM/TH6Rv1dSBMC5cBM7LBrYzkpaQeShcHtnKBIwer7fiXWAOFNiWQ+I+mZTRfz8OF96HBrA+kpXAcDtUEM+NCOIOhJmQeTYOHcSDQrEvhZHee3pABM6USex53tjVcj4OFMWGLO9217fAbj9mBMnCUPBRm5fT".."fTYONeKxZY0Js6f8VRRlUZbCBKovg4jDJnUBFcKRRa0pk9bXe3UXJJyYULMcgr3yPlAkXIbCb6E0mZfDFjZBEsqOBos4mJbDPGcOCqHrZa40hJ2QPHoOUZbCBLA5j5nDbz9aGM/YCe1qx8+EK2kWRZjbEuB319iQ".."FlNjGMWLS6shktiQIXoMA8maR7EokozZeGABXprSEfFvz8GFKWkeU4fCBuJR/rzZbzlBA8/CBuJm19rCfiJPAtiHUqs/zdefLWoZQ5jWFPRsxcqSMHoOUaGfLMg3mJvRcHp+HcqbQ7Ao18WQeztDFJGlQ7YIkorG".."dTlLWYmySqMikorDPnMkHcSBR657oovVbhNAAd6WdacpgZHTeXoTUcyDS6dhsJ3ETz9cB8KBQ+p5oovVbhNAAd6WdacpgZHTeXgHe8eNRaM316rFcglLA92LRad7ytjXfTdLS+yHUpE+hY7Zfz8GU/mXSJE+hY7Z".."fz8MWKGOSaE6m9jgbjVWGMaLUrsLhZfdbC59FNmUT6E+18WQeztDFJGlQ7YIkorGdTlLWYmyVK0jnpXZaCN+A8SPVrYIkorGdTlLU4LoSq04lpSQTy5PA9+HVIUuntiNPD1PHM7YYacvpJ3CajNNFIPAdbY6hYzV".."bh1bGInLLMg3mJvRcHpeHcqbQ7B7ytjgcDtXFNmRCI40lJncTDZPCM6QLMgykdjAcDtXFNnMdq46jp3CWy9HS+2LSKYdnorDaBlGGMeGDuATgpr/bChLU4LCUqo+mdjCeS5bA8XCQ6w//fLcczlPHYuLSLEvlpbE".."XzVAH6GLQOI9norVbChBCcKPT7Yih4rfcSpaUd+KQ6xR/pHeby5PH9+hSaw118WQTChBCcKPT7Yip4rfcSpaIs6QUKs4ktbgbjVDAd+gU7YvmJb4czZKM86FR6xhtJfecj9NBYOEU6w4g5HfcnJeWKHrL6QyhZ3A".."bjVWGMaLUrsrhZfdbC4GAYLoL6c1k9G6eTRKe6HPC+JmysWNIWcTTJbfG/9mysWNIWcTTIumZ5Ya18WNIWcTTJbfG/9mysWNIWcTTJbfLK40lJncPBt8NOqxBv97jPK5ZyhPA8KWX+Jm19rjeTlcFN/ACuJ719jR".."bj9PUZbCBJE+lIrVaBtcFMrACuJ719jdfTdPUZbCBJE+lIrVaBdPHMrACuJ719jTczZBA4vfBoE0m5fCL3RIA8SPdIUZ38qFKXYORpvOBvVr3tSQPCpcGMSQT7Yi18WQLScCe6KZVKMpnozJPGcOU++LUKs1ktqc".."PHoOUcqQQ6N7ytiSWDNYGMWHZ7A+ltqcPHoOUcaDS6N7ytiSWDNYGMWHa6M2ltqcPHoOUciNSq0p18WQXzVCHtnRCKQpmJXiWxgGQJvSCuJpxMicPGgbRILOBrIpnpfCdS5XUZbCFL93/fHLbjtcGN+bBv971bXJ".."aDJHEsqOBO5715nCeTsOTIvAa7svn5HTfTZvA86DBO5715XRcTsOTIvAa7svn5HTfTZjEMaDBO5715vfcDVcUZbCZa03mIqDMjxcHsawYYBzxc2FMHoXQYfCF/Zr3tSQbChHHtmLUrt7ytiDYXYkeNCQR7Ayg4GQ".."IXoMPc6FQ6w/lorJPnYOENmHR+Jm19r8eT1LH8+DVLsahZ3RPnYOHMqPR+Jm19r8eT1LH8+DVLsWlpXRPnYOEsSOSbB7ytjzczZBA5jMQLA0mqr3XnIcRJ7OBvNjx9SQKmoHXYuSVKs0hZHEZXoTUZ+fCshSjIrR".."bjNaCIvfBuAeh5HTPnYOUYvCBuI6hZ3RPGcOU+6ST6EahZ3RPnYOUYvCBuI2lpXRPGcOU+6ST6EWlpXRPnYOUYvCBuI4mJTfbnoTUeiNSq0pxNbWbjVDI+ygDvNjx9SQLWoeXYvQE/dy29jAbjNBA8KWX+Jm183N".."MFAnCtmDVKsvjtiNPHh8ENmHBO5719iQPHpPA86DBv971arRbj9vA86DBO5719iQPHpDEMaDBv971arRbj9jEMaDBO5719iQPHpNHseNVOJm17vfcDVcQoWEVK02pb/yNGIeXYvTE/J318qFKXMCUduQT60pnozJ".."PGcOR9bOLMsghZnCdS5XUZbCBJc1lJfdcTVAU4fCBqMpkpmQIXoMJMWBSa82mJbxbj9PU4fCBq86mpmQIXoMJMWBSa82mJb9fTdPU4fCBqE0m5fCPGcOMsSOSbBo2Z7Cczd8NunKH/J318qBLHYOQJjSD+57h4rZ".."cyhHBdLCG+JsitS6FSFcENmLUrt7ytiSXzVDHMSMBO5719iQfShLEIvfBuAYmJXdczRvA86DBO5719iQcTtDEIvfBuAWmIvBaTNaHuaDS6N529iQfzVCHtnCG+IYmJTfbmkAF9mNS5ActdCBJGoCUZraFu57xsCA".."NXYOAdmLSbAyg4GQIXoWDIfoW8hRm5fTfTYOEMiWT7Q+tr3DPGcOCtboSq04lpSQbi9AH8KMQeJm14zCaT8ke4bPBv9mysWNIWcTTJbfG/9mysWNIWcTUey3b+JmysWNIWcTTJbfG/9mysWNIWcTTKGOSaE6m9jX".."aTMOTIurSLEvlpbTeXRAFNzKBJE4hZ3Vch1bGInLLKUuntb+fTdLUZbCBIoulbfAbj8Me8yXT+wJkovVaBVAItuDUax7ytjWfTZdFKGFU6t1rbHeeD9WM86KR7QymIqQIXprH96PCJgSmZzVZBhLGcqUT60p2avZ".."fjZHH8zoQbcy2ajRbj9ABYvfBrI3loHVbmB5EMKWYK0ptJDZcD4GU/uOR7s+hb/FdXgHe6GOSaE6m9jdfTNAUZbCb6wog5nefz8AH86VDuAdhZndeXgHe8aDT6x1pJHKeXoTUf6mT69p2ZbVa3IeXYvQFvJ318ic".."PGgXQYLoS6MymdbgcylHBcKNSOJm1630dTccX8WHUepr29iBLnYOQYXQCuJr3vLdfTNAX+mDRak8hZfFcj5tHseNVPF7ytjzczZBA5jMQLA0mqr3XnIfR4fCF/R318qCNVBDEMKMCIA0hZzVbglHC86yT7o+m9iN".."PGokHMqLSOwalIzZaj8OTIuWVLc+/ZXRdTQAMseLVrEfkovTeTRKEMWWVeJm14zCaT8kHMqLSOwLlorVci4OTIuFU6tRvpbDaDtAEs7MSKcs39rlVRlBA8WHVOB315XRdTQHX+iNVKw+harReDNbAovfBpcfnpWe".."cj9ZWZvOBvNp3vK6MXcON8SMQq1Rm5fTfTYOE8zCG+ISmYvEfTRNFIWMQ7Vz1bHdfT1LPcqAQ6553vLSe3R9GNGHBv97orzZcWgAH86VDvN318icPGsCUZvLLKA82brRfzFJA8SXSKYPhZnebypPA86MRbt7ytiB".."FjhJX+KPR6U+18WQPihMCcqRVacvnpyKM3UfQZ/bFvRrxcuEPlBMFoWrS6M8kqzCfTRdAcqQQ6w4jtiNPGoAQp7oRKV1pJvRcD96CNuHBv97spbFcXR9EsqOQ5Yih52eXyhBAaGAQewLlorVci4OTIuPR6s1/bHe".."by5PH8iHCKw+gNCSSRNtHtmMQ7B529jSe3MAMsSQSKcppZnUdS9dUZbCc4YymtbeeS0GQYfCF/By/fLcczlPHYuRUrA0nJ2QIXpnH9iWR6w4ktbeeS0GU/6rdbYpmJPVPnYOHMqLSOtRhIzCczFLX+iNSq0p18WQ".."XzVCHtnRCKQpmJXiWxgGRJ7OBvdu29iILHMkAt+QSak+2azYdTlFH86RVeJm18meLlAkXIbCbqc6k53CFjZBEsqOBqo+lpzVbnoTUeKMVbY6mZvVMjRLBoPAYLA6mp2SNVBGFMqGQ7B1pJHKeXoTUf6mT69p2ZbV".."a3IfXYvSCuJr29iDKnMkGc6DQqcp2brRfzFJA8SXSKYYmJTfbmkOTIuhSa40hcueeihBHPmlZOppxdSQLmgCUZjQD8gzkpnUeSgAM8qBTaUpmI3eeA5cEMWRVqMpkpbTZXoTUZvMF/dRn53ReD9cX+mNVKY+havZ".."Zj9+GNOHSuJm18i6dD9PFc6QCJI6hZ3eaHoTUcaDT6xRvpbDaDtAEs7MSKcs39rlVRlBA8WHVOB315DVfT5LA4LMZa0pmZ3CTjtKGN6RBv97orzZcXRAFNzKFu57xsqZFlBCHsiDSuIzsZHIPGcOOMWRUqM1lJ2e".."cj9ZWYmkVKM2ktqZFjJoGNPMdashktiNPA9qGMbQCKw+gNCBMHoeXYvSCuJqw9G6dBxHCYWySbEyg5HfcnoTUf6mT69p2ZbVa3IeXYvSCuJq29idLW4He8OkT7p1tZnTdz1cHt6MQoE0m5fCL3oTUeiNSq0pxNbW".."bjVDI+ygDvBp29iCLnYOQpnLLKodnoCeXjtNGsyQSbc1k6zCfTRdAcqQQ6w4jtiNPGoAQJ7oToQyj9bycyhKFNmxT7g+p5HIeTYOTIvSLKodnoCeTDtcFMWWBv97n53ReD9ce6GOSaE6m9jEdS5CFIvfBos1hIzR".."cjlLX8WHUep5o53IaBZPE86OBOtRg5HEcD8AIsKYQ+Jm1630dTccX8WHUepq29idLWseXYvTCuJr3vLEdS5CFIWySbEyg5HfcnoTUf6mT69p2ZbVa3IeXYvTFO57x9SQLHMkBcKWSqd1tZnTdz1cHt6MQpYplpbD".."bDtcFMWBX+Jm18m6aDNaHc7Mcqcjg9iNPHhhAdmHbrc5146CPlBaGN+OQ+wPkoDEXzVCHtnRBv97tJfccygdX82QSa8JsLqYLm4bXYvQEvd318qFKXMkBcKWSqd1sZfeaHoTUe6MU691sZfeaHRpHt+KR68ZmJTU".."Fi5HBceHCJY+j4zjdSBLUZbCF/dRg5HEcD8AJc6aUpoam5HXcjdLH9/CG+IemY3dMg5LCd+6Z64ykJbdeTRaX+eHQLZRg5HEcD8AIcqQQ6wv18WQdD9PFc6QLMh22tj0dSlNHtmGBoAug4zfclBCHsiDSuI/novT".."cyhKM9+MBv97vpbDaDtAEs7MSKcs39r5cTtJFOmXUrY0mdqZFj5HAsiNVKYZg5aeTzNUFIvfBpcfnpWCMjRLBoPSCuJpz9SQLHYOQ53LLKYyhJvfbj5sBcXMdq0onozZczQOTIu3Yqs2xdbeeS0GQIfCC/Nrx9SQ".."LHQbXYvPF/Fy/ZzZbzlBA8+gUqx1tZnTdz1cHt6MQoE0m5fCL3oTUeiNSq0pxNbWbjVDI+ygDvpj29iBLGsCUZnWFOtRk5HDfzVcFemWSOwSmpnXeXoTUeKBSawo2bzZbzlBA8/oQqsolJfCeBhaH4WrS6M8krvf".."cDVcQovfBoE0m5fCL3RIA8SPdIUZ38qFKXYOQ57XCuJpws2ZFj5HAsiNVKYZg5aeTDtcFMWWBv97n53ReD9ce+KMVbY6mZvVMjRLBoPAc4sYmIreeSgMXYuGT7E4mIrUXi5AWIWhSbA1korifT5HBNjCG+IOs5Hd".."MjRLBoPSCuJs3vK6eDNdEsSQQoAvmdb9cy9dFOmXUrY0mcnzcDNNGpGhSaw1kpvENDxbH8iWT60139G6FSlLBciOT7I5mJnCeHJqOPihaZAfqLT5UhEHe6KSRaM3m9DWaTRNBcKNSOpy/fG5Ty5PA9+HVIUunsLj".."eS5tHtmHDuAIkpbUUjVaGM2LRaMvnpfePnYOCqHrL8sPnozceXoTUYmtVrA+v43SPnYkeKLrcqcjg9iNPHhqGNiBSbA/15TZcjEOEsSST6c/1tqcFlMneO+XVKMvnpfePGcOQqHrL79y/fHVcj4He6KSRaM3m9DW".."aTRNBcKNSOpy/fG5eztDFJGlQ7YIkorGdTlLWYmlU6sIkorGdTlLU4LYabI+mbrCcy1dFNm1T6w/mI+YWBN9MuSwYp0Xvrb7NVAnFMWGD8g+mZyZFlADXIuvT6wympHKeVBCHsiDSuI2npbyaDQOTIurSLEvlpbT".."eXRAFNzKBIs2lp/VXi9aBcSMBOtRmpHeXi5AX/iLXKd7ytjlWDNDQ4WMQ7Vzx9SQLmwCUZvOBvBt3vLddTRsBcXMdq0onozZczQOTIu3Yqs2xdbeeS0GQIfCC/Rt29iAMm8CUYbTFetRmpHeXi5AX+mDRak8hZfF".."cj5tHseNVPF7ytjzczZBA5jMQLA0mqr3XnIaRIfCEvd3186ANVBDGMWgUqx1vpXRez8OTIurRa01hNb9dTRHHMKYQ8g2npbyaDQAOMaDQacYmJTfbmkOTIuhSa40hcueeihBHPmlZOppxMicPGgdQYfCFPZu3vLd".."dTRsBcXMdqMpkpbEPGcOGc6DQqcp/bHeby5PH8iHCKw+gNCSSRNtHtmMQ7B529jddTRsBcXLCIE0hZbVbghPFcKXVeJm1630dTcAH86VDvJ318+ZFlADXIuhSq0okvLcczlPHYuBSq0okrrEcnoTUeKMVbY6mZvV".."MjRLBoPAb686kJ3yaS5aHsXAD8g4m5fDeRhaH4WxT7g+18WQSR5HHJnMSKcs38icPGgYXYvSCuJpwdG6fzZBAs6gUqx1p5fDdS5HHsXCG+IOs5HdLnRAFNzKF+572suEMHoeX57OBu9qxNG6fzZBAs6gUqx1tZnT".."dz1cHt6MQoE0m5fCL3oTUeiNSq0pxNbWbjVDI+ygDvBrx9SQKW8CUZ3XD8g4m5fDeRhaH4WrS6M8ktiNPBNNHsWRCIE3mIvVFjlCHtiHZLY12bHdfT1LMsSOSbBo18WQXzVCHtnRCKQpmJXiWxgGQ57XCuJpws2c".."PGgbRILoRa40hJ3yaDQAIcqQQ6wv18WQdD9PFc6QLIs1hIzRcjlLX8WHUep5orHzcyhAFNnACuI4m5fDeRhaH4LMZa0pmZ3CTjtKGN6RBv97orzZcXRAFNzKFu57wNG6FjZBEsqOBqQumZvEdTVAUdiKU7Y/mI/e".."NHMkeNmXSKwymZ+QIXpIEMeRQ8hSlpvEdSxLMO6RBv97jIW6FTNIUcKMVbY6mYzzczRAUd+KQ6x7npbDaDtABeiNSKxhs5HDfzVAH86BUupy153eeFAnFt6LHIY+hIzCcyMGWKGHSKZRlJTfbz9sBcXMa60uhJ3y".."aS5aHsXTZa4ylJOKXzVAH86BUuoon43EeDVZH4LoLO9216zRfikkHcSBR657g5nSWihPHM7CG+ISmYvEfTRNFIWMQ7Vz1b7CfTdLU4LoUqM5sYrRcT8AIsKYQ+Jm1630dTccX8WHUepq29idLWoCUZvOBvBt3vLE".."fThoA8qPQ+wLmIvZaDNBH4vfBpcfnpWCMjRLBoPSCuJu29iAMHoaQYLoUqM5sYrRcT8AM8qBTaUpmI3eeA5cEMWRVqMpkpbTZXoTUZroUqM5sYrRcT8AIcqQQ6wv18WQcTtHH6HoSq04lpSQaDtMQIvfBos1hIzR".."cjlLX8WHUep5o53IaBhbBd+NSOBy/YzRfmsAIsKYQ+Jm1630dTccX8WHUepr2c2cPHcdXYvTCuJr3vLEfTgfX+mDRak8hZfFcj5tHseNVPF7ytjzczZBA5jMQLA0mqr3XnIbRIfCF/Nu29iCKG8He9+DRPN1o53I".."aHoTUYmvSbEqgpHEc3p6IYnoUqM5xtbkeSJaMsSOSbBo18WQXzVCHtnRCKQpmJXiWxgGQ57XCuJpws2cPGgbRILoUqM5xtb2czRaUZbCY6wumtb2czRaX+yNUqo6mrrfcD4kBcqAF+wPkoDETzNUFIvfBvNq/YzR".."fmsAIcqQQ6wv18WQaDtMN9mDS6dRvpbDaDtAEs7MSKcs39rlVRlBA8WHVOB314zRfmsHX+iNVKw+harReDNbAovfBpcfnpWecj9ZWZvOBvVy/fLcczlPHYuWR6Bp18WQVTRdBcqMRad1mZ3HNHh6FNOWZLcvg5fe".."PnMkBcqAFOwInoLVPGcOJO+LS/B1mZ3HNGoARIfCC/F318mcPGoHe9+DRPB1p5fDdS5HHsXCG+IOs5HdLnRAFNzKFuxu29iDMHoeXYvSD8gvlpqCMhhPEsCFVK0umZzzczZBA5jCG+IYmJTfbmkAF9mNS5ActdCE".."LHYORZvOBvdu3vLEfTgcX/+HXrZ7ytiSXS9aHuaNVbMunozfPlBaEMnQCJY+j4zzczZBA5jCG+IYmJTfbmkAF9mNS5ActdCBK2oCUZrVFu57xsGFNVBaEMnQCIQ0mYyQIXprH96PCIQ0mYyeWzVaGcqPZK03k/LE".."fTgcX/+HXrYInoLVPGcOQJroUqM5xdbgfShLH9/CG+Ivlpr2bjtDFKGrSLEvlpbTeXRAFNzKBJcStJfCcj9cU4fCUqM5xdGeXzVcH86QdKM/no3DPGcOJO+LS+w1ko+YLHYORoLoLO9217vfci5LH9/oSq04lpSQ".."fzVABc6MUvN7ytj5cilaEMWBQ+w1ko+YPglNA8SOSqs1kL7CfTdLU4LoRa01g53eaGsAIsKYQ+Jm1630dTccX8WHUepq29idLWoCUZrOBu9sw9G6fzVABc6MUvN1p5fDdS5HHsXCG+IOs5HdLnRAFNzKFu57wtSQ".."LHYORpvLLKE0mYzVci4fX+mDRak8hZfFcj56A8qMVbI6hZ3efyMOTIvTLKE0mYzVci4fX+mNVKY+havZZj9+GNOHSuJm18i6fzVABc6MUvN1pJvCczZCM8qQcqoylJPeeSldUZbCFcg4mJbEeTRaQIWxRbA0m5Ty".."fShnHMqFQ4E0m5fCL3oTUeiNSq0pxNbWbjVDI+ygDvtr29iJLHYOQJnSD8g4mJbEeTRaQIWhR6wtlovjdSBLUZbCc4Yymsqecj9ZWZvOBvJ318icPGoHe8iNSLY+mYyBMgpPA86MUuJm15XRdTQke8eNRaM315TZ".."by4OTIurSLEvlpbTeXRAFNzKBJcSu5HDaBZPCMSXUuBy/ZTZby4AIcqGQqs1kNiNPA9qGMbMSKcs38icPG8He8eLVbZ1pJfCaBVcFc6QBv97spbFcXR9HtmWabA/koqeUDtXHt6WabA/koq6cDNdBYWyR7A+mYyQ".."IXpNHsWWQ6wvxvK6cDVNEMfCRa01g53eaGgOTIurSLEvlpbTeXRAFNzKBIQplpXVPnMkEsSMUqc1g8qeTzNUFIvfBpcfnpWCMjRLBoPTCuJ2xsicPGsCUYbVEutRlJfeaD9ABZnMdq0onozZczQOTIu3Yqs2xdbe".."eS0GQYfCE+57x9SQK2oHe8iNSLY+mYyCMhhPEsCFVK0umZzkbjtAAtuDVKc1lIGQIXofe8iNSLY+mYyCMgxHAsKASqd7ytjWfTZdFKGBSawvkpbELnR+ENmHSLZ7ytjdfTNAe6GOSaE6m9jDczVAPcqAQ657ytj5".."cilaEMWBQ+w1ko+YPg5LCd+uR6A+m9qZFilBHsWuR6A+m9bjdSBLUZbCc4Yymsqecj9ZWZrOBvJ318mcPGoHe9iNSawXlprVcHRsEMiJQbA0gpbUSChPH9iSR7A+mZvJPGcOQKGRSa01u5nSeTYAJc6aUuJm19rg".."bpmdCcKPR68+mYzVPlBdHsSMaqM5kpSeSD9WBeiNSq0pxNiNPBlBHcSQFew9hZfdTh1sWZrWFu57xsyAMHofR57LLLE0mJb8fThLHYWkSawv18WQWTRbHIWkSawv2b/faDJPHOaHQqsumvLDczVAPcqAQ651o53I".."aAlHC87CG+JqwvLDczVAPcqAQ651p5nCeTRaUZbCRa01g53eaGgke8eNRaM3157FcjlaGMSMBrE+g6zRfnJaEMnLLMsykdjEfTgOTJbCF+Ivn53eFlMnBcqAF+wZlpvbeyhBBMWGZa03mIqDPGcOMsSOSbBo2Z7C".."czd8NunKE/d318mBKXYOQ5/XD8hS/ozRfmsAJc6aUoE0m5fCL3oTUeiNSq0pxNbWbjVDI+ygDvBuwtSQLm8bXYvQE/dy/fG5aDtMQ4WgR6EwkIrfaTRKMsSOSbBo18WQXzVCHtnRCKQpmJXiWxgGRZvOBvZr29iF".."KXMkeKKWR6Bp2azVZC5tHseNVPF7ytjzczZBA5jMQLA0mqr3XnIfRpvOBvNsx9SQLWMbWKHrL6E0mYzVci4fX/2LVas5m52QIXpaA96HLMtSlJfeaD9ABZnMcKsonprceXoTUc2DSrE+/fHVcClLe6LrUqM5xdby".."fTlFFtmNU6w/tJfccygdUZbCZa03mIqDMjxcHsawYYBzws2cPGsfRIfCFPZu3vK5FS5PE5nMcqcjg7vfcDVcQovfBoE0m5fCL3RIA8SPdIUZ38qFKXYOQ57XCuJpws2ZFlMnBcqAF+wZlpvbeyhBBMWGZa03mIqD".."PGcOMsSOSbBo2Z7Cczd8NunKEvJ318yAMHobRILoL8svlpqBMg5LCd+hSa40hcuQIXptHseNVPF1kYrfcQhpM4PTEfJ318mHLHYOQJLXD8hS/pvfci5LH9/TCJQyhJHScD8OTIuER64okvK5FTlBH9+HSLZp2a7Z".."bzNMHc7CG+IvhY3VFlNLH8/oQ6w//fLEfTgfX+aNU7E+tY3EaDVAQOiOT6EwzbvfcjRLEt/KQLc1lIzZczQGWIuRQ7YPlpqYLXMOFMWGD8gvlpqCMhdBBNiHZLcvg5feLRlCGMiJHIE0mZbVfy4GF96MRbYymJaY".."NXpdFN+2R6BzxdGQeTRKWKHoC+97upHedTdHC87oSq04lpSQcTNAGMaLXKc/18WQejtCAs7oS6s1tYzeMhdBBNiHZLcvg5feLRlCGMiJHIE0mZbVfy4GF96MRbYymJaYNVAnHMKMT68yjZ3UPGcOH8SWBq8ymZHd".."dSBLFaHrT6R7mpHedTdHC86GBrYzkpa6FVNaEMmkVKM2ktbmdSlHE8eHBv97kZncbz8keKKBSawvkpbELXR4GNiLRK4+18WQejtCAs7oL8s4mJbEeTRaQ4W0T7EylZTVPGcOF8qOVadR/vHdfTNAX/iLXKd7ytjl".."WDNDQ4WMQ7Vzx9SQLmoeXYvSCuJowdG6FT9CAs7oL8svlpr2bjtDFIW0T7EylZTVPGcOBdmXQ8hS/ovVaA5PE4PTD8hS/pXRdTQAIsKYQ+Jm1630dTccX8WHUepr29iCLGoCUZvOBvBix9G6FT9AFaGHSKZy/fKd".."MXoTTJbfG/9mysWNIWcTTJbfG/9mytj2SRRtJeKtaJF7ysWNIWcTTJbfG/9mysWNIWcTTJboSq04lpSQei9AEt+LSax7kJ3EVAh+WYLoL640lJncPDkOTIuSSqMikoqeXzJPA8qBUqcp/fHCeS5bA8XCReI6mZyQ".."f2BoGMWGYKsphIzzdDNCFYPAbrc2lpbfdT58HsSWdqMpg9qZFj9AFaHoSq04lpSQei9AEt+LSax7kZfCcTtaJcKPQ+oo3vK5b3oTUcaDUqp1mpnINGoCUcaDUqp1kZTfcygGAouNVOJr3tG6FTNIUdjCGv97x9jE".."dD9AUdmHUrcpmdiSTj9PFdLABqc1k/K5bj9aBNmMBrEvhZHee3RIHtmPR7Zz1d3UJn8eQ8/ACuI2lozYMjxCHsSQDrF0wciZMHpdVJ3SD8g+mZy6FjZBEsqOBqQumZvEdTVAUcyHUo86mpn+fTdLWcbLLMsykdje".."cy4OHIuWTqc114rVaC9cH4vAaK0v14vAfS1AFM/ABqc1k/K5cDVNEMfCTuJm15WKWjNAFe2LVLEvtJDZcD5hF+iOR7Eo39r4aTdPH8SLQuBy/fHZenpGUcqMQuIz2bzZbypCENKsR68+15neeHoNGYWmT7Erm5nJ".."UjtDFIvcBvJ7g5DVclAneNmHUrcpmdjYMh5HAtuOR7sVlpXVFlNLH8/oL7A+g43CcnpDX+WDS6dRkpbUFlBCHsiDSuI9gpbTaDNBH4uFQ7YTp9DdNVAnGM3CSK0v15WQaDJLH4uQQ7YuhZaQcjNCUc6MQshSm5fT".."fTYOGYvfBq9hsZHeeBxHA9iWZaoym5z/ehlCENiRDuATgpXRcjVHFYnLLMspkozFbjQOGYuDSKZ7mpnEdHRIHcSNVOoz2bDVfTZaGYLoQ6w//fLcczlPHYuEU6w4g5HfcnpYGNiLRK4+v6iYcXMkeMKEBqw0g9jd".."PC5GFMXCVKcvgorePD9AFaHrSq04lpSQdHoTUcbYYKs1k77ZbilaMsOLSqYUkbvcfSldWYmqU686mZfZeHgHe6KLQOIz14zYeTQkeKKKCIo+lpTEdB5HAtuOR7sfnovEfTRNFIvfBvtizsG6FVNGX+OHR64vn7zZ".."bypCENK2X7I+18WQWTRbHIWqU686mZfZeBJLEMeWToYyhIjcfSN6CNuHCIM3gJnJbxVAe6LrTuwVlpXVWDNdAceDX4YyhIzRcjlLUZbCH/tizvK5eTRKe86MQshRm5fTfTYOF96MRbYymJaQez9aNMyFVeo6hZ3R".."NVAnHcSBR657g9iNPCFTe6KLQOI1mIyQfShLEIuWTqc114rVaC9cH4uWBqc1k/K5ejVcUfTOBq17npaQdSpPGNmRDqMpkpmKWz9aMsOLSqYpkpaYNXMOFcToL8sykdjfMhRPHM7YSq0skoqYNWBIGMWGDuA+kJ+S".."NXpPH8/CSK0v15eeUjtDFJGOSbU+hdCZJjxHH8/KBK86mpmSNXpaGc6MLMtS/ozRfjZLX8KMVacpg9DEMHpBWKHrL6c1k/K5eTRKe6KQQ7YuhZaQaFBLH8/oLK40lJncPDxbH8iWT60114zANDVMG4LoL640lJnc".."PDJcAYvfBqU+g7DiTHIHe6KLQOI1mIyQdCheUcSQBqw0g9jffjAOBcOHSOIpkozFbjQOFMWGLMs3mJvRcHpeUZbCSaAxzbHDXXIMM8qRQ5I6hYySNXpPH8/CSaAx15fCPDVMG5GkT6w/sZHCby5tGcKOQpUznpvY".."VSlvWYmgR7E+p5nCaHgCUd+QU6dy/fHZenpeUd+KQ6x7n4rAMhloA8qPQ+Jm17v2bjtDFIWMQ7Vzh9bgcylHBcKNSOJw167Vfy5BA5jMSKcs38icPGkCUZvLD+I+mZy6eTRKe6GOSaE6m9jWaTRNBcKNSOIuhJ3z".."fShcCPuQSa8rg9DVez0He6KLQOI1mIyQeT1JUcSQBqw0g9jVez0AIcqQQ6wv14zYeTQOA86WU7A1157RcClLUc6MQshSm5fTfTYOGdmSBv97kJ3EVAh+WYLoL6s915bfaHpGA9vCUqo+mdjCeS5bA8XCQKM3hJ2Q".."eTRKe6HrSq04lpSQbDtcBYvfBqc8kML5bxsGU+mDVacLlorEPnMOEMWGBqc8kNjfbnpLFszYYKs1k77ZbilaMsOLSqYMn5HTdBNdMIPAZKMokqjRbi4MXYuWVLc+3vK5dTwOH8SWBrI6hYyQaDJLH4uQQ7YuhZaQ".."ejtCAs7CQ6w//fK5cDVNEMfCVbYulJOQIXpaA96HLMs3mJvRcHpNHsWMBv97pY3eTz9cB8KBQ+wTkpnCaDhLEN/YZa01mZ3TaHJIBMWBUqs0mdCZFlMnGM3CSK0v14vEaTlFUcSQBqw0g9jVez0AIcqQQ6wv15fC".."PDRBBYuSR7Av2ajRbj9ABYuWTqc1/fG5FSlaBMiJBv97kZncbz8keKLrT6R7lJfecnpaGc6MBqE0mZaKWDNdEsSMSKc4g9CZPD9AFaHrL8spkozFbjQkeKKHSKZR/vHYbioAMu2QR68+18WQXxxcEMaHCKw+gNDA".."fShaX/uNVasvnpfePHEOJ86BUq0pxNbeeS0GQYfCFOxu29iANXMkeM6MQutR/fHcczlPHYuSVK02h4yQIXpLFszYYKs1k77ZbilaMsOLSqZz1bvRbihXIdmNS7Iv1dSQaChbFILCSbB7kp/XJhxHH8+kT7Aog7vY".."dTZKPs2hSqMohNCSTChBCcKPT7Yip4rfcSpaU4fCUrAuktG6FTNIUduQSa8rg9jEdD9Ae6LrVqE6m5SYei9AEt+LSaxz3vK5FVNeA8SPVrZ1v5fceB5bA8qWT60118WQLFAneKKSVK02h4yeTj9fBMKQQ7EXnpbV".."Uzx9GMyKUuJm157RcClLe6LrL7IpmJXAaHRjENOjRbYygZnEdTVANcKRUqM1lJ2QIXoXQaHrL6c1k9G6FVNIHtnCT+Jm18mcPGsbUc+NLMtS/pHWPDRBBYuHQaV1p5nCeTRaUd+KQ6x7lYrVfTEOFMWGLMtS/pHW".."PDxHA86SVK0jnpXZaCNeA8SPVrZ7g5DVcnpeEsqOSuo9norVbChBCcKPT7Yih4rfcSpaXYuSVK02h4yZPD9AFaHrL8svlovbMi1PGN/KFuxrwtG6FVNLH8/oL6c1k/K6FTZBEsqOBrZ7ytiAFlNZGcKOQ+I+kJ+e".."TDtcFMWWBqM1k9jEPGYOQJ/CQq1R/vHEfSlFX9yDT7Zzx9aBNVAneN/CDf97xvK5eTRKe6HrVbYulJOQIXpIEMeRQ8hSnp6QfzVAH4uWTqc115vfcjQUNcKRRa01mZ3TaHIHUc6MQshShZ3EaShAUcWNUuI+kJ+e".."TDtcFMWWLKc1k/K6cDVNEMfCQLc1lIzZczQOFs6Wbqs8n53DaApcGMSQT7Yisp/Xb3IHe6KOSaE6m9jSeSlaIdmLSbAyg4GQIXoXSJLoL640lJncPDhLAt+nQaUo18WQZyckeM2NVOIE29jUfS5PUcKMBqsrlpHC".."b3JvI+6jdet7k5e6FVNHF4uDRbYygZ3xWSl1FcqWR+w6hZ3RQXpaGc6MLMtS/pTffztCUcqQQ6MdmJTUeSgOTIuVSbAwhIjRfz8UN8KMQoQyhYvEXzJHHc/KBJErlo/eXShLENjAD+I6mZyQazVcGtiSR6E+2avA".."fS1AMNmHR7FhsZHeeBxHA9iWZaoym5yYeDtaEIWDVKc63vK5FVNHF4uDVKc6sZfceD9cUd+KQ6xR/vG5FTZBEsqOBqc8kIuQIXpJFN+nQaUo35nCeTtoHseGQ7By/fG5FVNHF4vBQ6U8hNiOPGoOEMWGBqY6g5me".."bChHHtmLUrt7y9jSeSlaIdmLSbAyg4GQaDJLH6HrL8tS/prVby5+A8KNVKsvjtiNPD5PBcrMVrAymIrZaCMkeKLrL8s5kovEWT1JAovfBqc8kIu6FVMneM6MQshS/vHVcj4keKKHSKZR/p3eeFAnA86WU7A115rV".."by5rFsyRLKc1k/K6MXcOTJbfG/9mysWNIWcTTJbfG/9mysWQXwhrMP+nBoEapbzjPGcTTJbfG/9mysWNIWcTTJbfG/9m/ZTffztCUciDVKYo18WQZycke8eNRaM3157FcjlaGMSMBqEpkpnEeRlPA8/KQqMvltSQ".."cyhKFNnLLMs3mJvRcHpMHtPCG+ISmYvEfTRNFIWMQ7Vz1b7CfTdLU4LoL6A0j9bjdSBLUZbCc4Yymsqecj9ZWZrOBvJ318icPG8eWKHrRK0j2brRfzFJA8SXSKYPhZnebypPA86MRbt7ytiBFlNMHtPMaqMimI3E".."UyhKFNnCG+I0hZzVblAnE8SaCJI6hZ3eaHoTUciNSLY+mYyBFlAnHcSBR657lJnCeHoTUeKMVbY6mZvVMjRLBoPAYLA6mp2SNVAnEsqQQuwInoLVPGcOJO+LS/B1mZ3HNGsCUZvOBvJ3182ANVAnEsqQQuwZlpvb".."eyhBBMWGZa03mIqDPGcOMsSOSbBo2Z7Cczd8NunKFPR318qGMHodR4LoL6E6hZyeXjtNGsyQSbc1k6zCfTRdAcqQQ6w4jtiNPGoAQJ7oL6E6hZyeXjVcFc6QdashkqjZZD9CUZbCFshSlJnCeHR+ENmHSLZ7ytjS".."cyIkeOKMVbY6mZvVMjRLBoPAc4sYmIreeSgMXYuBR7A/3tbzcyhAFNmwR6YygouQIXp7NcKPCKw+gNCAMHoWWKHoL640lJncPDhPA4vfBos1hIzRcjlLX8WHUep5sYrRcT8MWKHrRKMp2avZZj8OTIu3Yqs2xdbe".."eS0GQYfCFe57xtSQMWseWKHrRKMp2ajfbzNaGMSMBv97orzZcWgAH86VDvJ3186cPGoCUZ7LLMs5loqeXjtNGsyQSbc1k7vfcDVcQovfBqY6g5mefzVCHtnoL6A6hdbycyhKFNmxT7g+p5HIeTYOTIvSLMs5loqe".."TDtcFMWWBv97lJnCeFAnOMWRUqM1lJ2ecj9ZWYm3b4E0hZbVbngCUcmDVOt1tJfCcj9cI8qGT7co18WQSR5HHIWMQ7Vzx9SQLnMke6KOSaE6m9jCfShHBdLCG+ISmYvEfTRNFIWMQ7Vz1azVZC5iEMmHSuBy/fHC".."fShHBdLMdashktiNPA9qGMbQCKw+gNCAMm8bXYvSCuJr29iBKHMkeNmDVKsvjtbgcylHBcKNSOJm1630dTccX8WHUepr29iBKHYOQYfCEutR/orRbjNaCIWgR6EwkIrfaTRKJdmDSLErlorVcjlXUZbCF8hShZnC".."dS5XX/+HXrZ7ytjUfS5PX9mDVKsvjvK5bjtcGN+bCJY+j4zzczZBA5jCG+I/lozRMjlBHcSQLMsplorZaCMAN8SMUuJm173eaTcAN8SMUuwcmIzYfTdsHseGLMsplorZaCMAJc6aUpEyjZ2QIXofQKHrVKMpnozJ".."Mg5LCd+6Z64ykJbdeTRaUZbCY6wumtbkeSJaKeqOT6U1mp3eaHRiFM2WLMsplorZaCMAIcqQQ6wv18WQfztcFaHoL640lJncPDRPHM6uRK57ytj5cilaEMWBQ+w1ko+YPg5LCd+uR6A+m9qZFlNAEMaHaqA32avZ".."Zj8OTIu3Yqs2xdbeeS0GQYXVCuJr29iAMHofQoLoL6w6mp38fjYAIcSRT7YymJaQIXp7NcKPFOw1ko+YLHYOQJ/OBvJ318mINVAnH8qPQ445m9byfTlFFtmNU6w/o4rRcileENmHSKEi18WQLVAnH8qPQ445m9bk".."eSJaUZbCBOx12dq6FTRPHM6uRK51o53IaBlBHcSQFeJm17vfcDVcQoWEVK02pb/yNGgdRIfCFPFu29iCKWoHe6KMR68+u5rcMhxBH9/CG+IemY3dMhxBH9/MYa0vn5ndFlNAEMaHaqA32azVZC59GNGHBv97xsm6".."FTRPHM6uRK51o53IaAJvHcKFSK8+mYyQIXprH96PCJY+j4zoXTZHFsWPQ6wv2bTVei4keMWDS6cXlZSeSD9WBf+QU6w4lozVPGcONMWXS+wPkoDESChbH8iDUqd1toz1cj4keMWDS6cXlZSeTDtcFMWWBv97lJnC".."eFAkeMeNRaM315HeejViE8fCG+ISmYvEfTRNFIWMQ7Vz1azVZC5iEMmHSuBy/fHZcjxBPcmOCJEyjZ2QIXp7NcKPFOw1ko+YLHQZXYvSCuJr29iBLnMkeMKMQK0XlZSeTDVdGN+LSax7ytjlWDNDQ4WMQ7Vzx9SQ".."LW4CUZvOBvFp3vK5dTRIHueASuwZlpvbeyhBBMWGcrA6mYvAfShLH8ibBv97xvK5dTRIHueASuwPkoDEPGcOU+OyBiDbY9iQ/tqMUYsAplZ5/fHZcjxBPcmOCJY+j4zzczZBA5jCG+IYmJTfbmkAF9mNS5ActdCB".."KGoCUZrWFu57xs6FNVAnGMWESY45m9b2czRaUZbCY6wumtb2czRaX+yNUqo6mvK5dTRIHueASuwPkoDETzNUFIvfBvNr/fHZcjxBPcmOCJY+j4zoXTZHFsWPQ6wv18WQWTRbHIW2Q7ovr7ncdT1AHM6MUuwXkp7E".."FlNHH82NaqA32ajRbj9ABYvfBqE6hZy6FlNCHsiDSuI6m53CaHoTUeKMVbY6mZvVMjRLBoPAcqcjg7TRfj9CU4LoL6M3korEMglHC87CG+IOs5HdLnRAFNzKFu57xsqcPGoCUZrQD8hSlpTVbi4AIcSRT7YymJaQ".."IXp7NcKPFOw1ko+YLXYOXJzQCuJr29iFNVAnEMeHVLZ1tZnTdz1cHt6MQpYplpbDbDtcFMWBX+Jm18m6FTtCFNmWCJY+j4yQIXoMU6HrR64+hYyeSD9WBeiNSq0pxNiNPBlBHcSQFew9hZfdTh1sWZnXE+57wM2c".."PG0bWKHrR64+hYyeWjVABYvfBoc1gpWeWjVABYWlSbYzlpXyczZKe6KDSqcpg9bkeSJaIsKYQ+Jm18mBFlNPHc6QUuwLlorVci4OTIuBR7A//fK5cDVNEMfCR6d7ytj5cilaEMWBQ+w1ko+YPg5LCd+gU7YvmJaS".."NVAnEM7MdashktiNPA9qGMbQCKw+gNCAMHodQYfCFu57xcqZFlNPFIWySbEyg5HfcnoTUf6mT69p2ZbVa3IfXYvPEPp318ieKXYOXJrTD8hSlp2eXjtNGsyQSbc1k7vfcDVcQovfBoE0m5fCL3RIA8SPdIUZ38yF".."MHoaRIfCEPJy/fHReXR6FNOWBv971bn1PlAnEM7Mcqcjg7vfcDVcQovfBoE0m5fCL3RIA8SPdIUZ38qCLHYOQ5nSCuJpw8iZFlNPFIWkSawv18WQWTRbHIWkSawv2b/faDJPHOmNSqZR/pnVMg5LCd+xT7g+18WQ".."LWokeMqHCJI6hZ3eaHoTUciDVKZR/rHeby5PH8iHCKw+gNCSSRNtHtmMQ7B529jReXMAMsSQSKcppZnUdS9dUZbCc4YymtbeeS0GQYfCEOtR/fHcczlPHYuWVoAvmdiNPBNAAt+DSKE+2ZbVa3IMJc6aUoAug4zf".."cngHe6KWVoAvmdbjdSBLUZbCc4Yymsqecj9ZWZvOBvFr29iAMHocQ4LoL7YrtYzeMgpBAsKWT60118WQSR5HHJnMSKcs38mcPHcdRYfCFuxu29idLWsHe6KWVoAvmdbyfTlFFtmNU6w/tJfccygdUZbCZa03mIqD".."MjxcHsawYYBzws2cPGsfRIfCFPZu3vK5aCpsBcXMcqcjg9iNPHh6IYnoL7YrtYzeMg5LCd+hSa40hcuQIXptHseNVPF1kYrfcQhpM4PQE/d318qFKXYOQ57XD8hSg4jyaDQAN8SMUuJm173eaTcAN8SMUuwcmIzY".."fTdsHseGLMsvh7rEcnR6FNOWdashktiNPGsee6KWVoAvmdbgfShLH9/CG+I4lorUFlNnH9iWR6w4ktbeeS0GU/6rZa0pmZ3CPnYOBdugUqxy2bvfbjRLA/mDQqsuhNiNPA9qGMbMSKcs38icPGwHe6HrUrIZg5ae".."UTVbAs6gU7YvmJaBXzZHEsDYZa01mZ3TaHJIBMWBUqs0mdCZFlMnHcSBR657ltiNPC1BA8CRVqM4ksL2dTRKN8KQVbYYn5HceHIMItuDUawahZ3Rb3gHUcqMQuIsmIrbbypPEs7MdbI6gJbxbj9PApGkT6w/sZHC".."by5tGcKOQuo/lozRMjtcFMrLLMtSnp6QfXpaGc6MBrYr35mKWjNAFe2LVLEvtJDZcD4GFcqWR+w2lpXRNXpBA4uDD+I+mZy6FT9AFYLoLMs6ktb9cy9dFOmXUrY0mcnzcDNNGpGhSaw1kpvENDxbH8iWT60139G6".."FVNHF4uDRbYygZ3xWSl1FcqWR+w6hZ3RQXpaGc6MLMtS/pnTaDNYFOqnVZk/lozRMjtcFMq/Bv97mZHcFlMneMqHCJY+j4yQIXoMMO7ALMtS/pnVMhhPEsCFVK0umZzzczZBA5jCG+IYmJTfbmkAF9mNS5ActdCE".."KXYORZ7OBvRr3vK5FVNPFIW2Q7ovtJfccygdUZbCZa03mIqDMjxcHsawYYBzxcqAMHocQ5vOBvBvx9G6FVNLHdiHLMtS/pnTaDNYFOqnVZk/lozRMjtcFMq/Bv97g4rFeVAneKKDQ+wPkoDEPGcOU+SsBMhS/vHR".."eXRsEMiJQbA0gpbUXzVCHtnRBv97tJfccygdX82QSa8JsLqYKWoCUZrVE+57zsiZFlMneMqHCJY+j4zzczZBA5jCG+IYmJTfbmkAF9mNS5ActdCCKW8CUZnXE+57xc2FNVAneM6MQshSkpbUNVAkeMiDVKYorJzR".."aDsAENmHR597ytjLFlMnH8qPQ+Jm15bRcT9iE8fOLMtSnpbWc3oTUcKMQK0XlZScFlMnEMeHVLZ7ytjRcD9cBYfoL8s/lozRPGcOFcqWR8hSivLVcj4ke82NVOIy29jUPDNAUcKSR6sphNDxTh9vIoLCQq1R/pvC".."eTtaFOiDVKZzk9SQdXMkFMWGLMh22tiNIWcTTJbfG/9mysWNIWcTTJbfG+Icu7fyXRYOMO7Cao0Up9iNIWcTTJbfG/9mysWNIWcTTJbfG8gvlovbMileENyMDqQumZvEdTVAWYLoL640lJncPC1PAuiNSq4+lIzZ".."cj0OTIuER64okvK5azJHHc7CVLc1mZHee3pPH8/CQbcy2ajRbj9ABYuGSchS/pTffztCUc6FQbF7ytjXeS5mGMyKQ7Evp4rZcyhHBdKnQaUo39G6FVNHF4vBQ6U8hNiOPGoOBcOHSMhS/vHHfSltHseOQ6EvnpbX".."PGcOBdmXQ8hS/vHcczlPHYuHQaV7ytjVez1dKpq/LMtS/pHWPD9JFouDSKZ7kp/XMgpPA86MUuIvn53eFlMneKKXVacYlorCZQpcHsaSUuo+kJ+ZFlMneKKWR7Ew2Y/RdS4GQYXTFOtR/vG5eTRKe6LrQ64okvK5".."FVNHF4uVR7EYmJTceTlaGMWFBrYzkpa6FVMneMeNRaM314vAfS1APcSBBv97gJfCdyleEMiHHIQymZz2dShdBeiKT64/39rjbDtZH+eNRaMvnpfePnMkeKLrL6s914vAfS1APcSBBrYzkpaQaCoGAtuDUawXmJuZ".."PD9AFaHrL8tSgJnDXzVCHc6BUqs1kNiNPDxPHdiHLMtS/p3eeFAneKKWR7Ew2Y/RdS4GQYXWD8hS/p3eeFAnFMWGLKc1k9G6FncDUZbfG/9mysWNIWcTTJbfG/9mysWNPA9+Neq2Y+JmysWNIWcTTJbfG/9mysWN".."IWcTTKGWR7Ew2YvAfS1AWc2XSKEvnpfeNHMkeNyKT64+14rFcjRHH8zCR6w/15/FdXR+ENmHSLZ7k5e6FVNCHsiDSuIpmJfEPGcOBsSQTbErlpvVJhxHH8+kT7Aog7vYdTZKWYmxVqMsmbnCeTtdU4LoL8sykdjC".."czVaUd+KQ6xR/vG5ejVcUfTOBqZ7npaQdSpPGNmRDoMJsrnjNXpKHqHrL8tSm5fTfTYOEovfBqE6hZzDRz4AENmHR59R/vG5FTNIUcjCUqo+mfK5FVMneMeNRaM315nCeTsOTIuQSa0vzb7Zcj5oGNmRUoEznpTU".."ND4AENmHR+tR/vG5FVNHF4uDVKc614zYeTQkeKLrL8tSm5fTfTYOHMqPR+Jm15nCeTsUN8KMQoQyhYvEXzJHHc/KQuw2lpXRNVAneKLrL8s3mJvRcHpCBYvfBqMpkpmKWjNAFe2LVLEvtJDZcD4GU+eHQLYPnpXV".."PnMke6LrL8tS/puecjtDFIW2Q7ov18WQez9aPMqPR4w6mp2YcTtDEILoLMtS/vG5FTZBEsqOBqor18WQez9aOfvKS6M2ltG6FVMneKLrSq04lpSQaDNDFPiWVOJm19pSnM4Me6LrL8tS/pHWPDZaUcqMQuJzm4yK".."VSlvWYmsU685kormfTZbFInLBq0p15TEJhNdMIPAb6wvoZncaT8MWILCUqo+mfK5FVMneKLrUqs2kqvEbnoTUc2NVK86g6zZcT8GHd/McKM3gp2ZFlMneKLrL6c3hJ3ZenpDEMaDBrYzkpa6FVMneKLrL7Yymp3j".."aCgOTIvAdKc6k4GSFlMneKLrL6c1k/K6FVMneKLrRewymZ7fMg5LCd/CG+Jzn4iQfTRKUYPAbpJ71daedCoHUcSQBuATp9hSnM4MWIvMCOJ519hSnPgOUYnCCOx7g5HdeQlaA6HrL8tS/vHTMjtCFNmWCJY+j4yQ".."IXoNFs6WY6U8hNDRbj9PWIvcBvJ7lpbUPHjM5iTABq0p19qSFlAneKLrL8sykdjdfTdPUd+KQ6x7gZHDdThCFOOyDq86mpmZPD9AFaHrL8tS/p3eeFAneKLrQ6w//fG5FT9AFaHrL6c1k/K5FTlBH9+HSLZq2bvR".."cixPAviLXKd7ytjlWDNDQ4WMQ7Vzx9SQLHYOQYfCSqsog9bxfilBHd6WQ4E0mYzVci59GNGHCJt73NiINVAneN+DVal1gJnZaHIfWKHrQ6w//Z3eeHMke4bPBv9mysWNIWcTTJbfG/9mysWNIWcTUe+wZ4V7ysWN".."IWcTTJbfG/9mysWNIWcTTJboSq04lpSQeChPFsyLSKV315zCfT19BcqQUu57hIzRbi5+HtjCG+I9lpTDeXYOH8KOCuI1npS6FjJLEM+HVOwSmYjFaBhLFsqMHIE0mZbVfy4GF96MRbYymJaYdXMkeMKEBqt1oovV".."bhNAAd6WcrsrktiNIXprH96PCJcokor5cipbBf+bVqd1upfFbz9sBN+WSaxq15fCPDMAJNiHVIs1h43ESCNeFIvfG+IemY3dMg9dFNmrSLIug6zJbD8AJcSXRap7g5DVclAneM+QR6U8npbXPGcOBdmXQ8hS/pzC".."fT19BcqQUuJm15GeTDVdGN+LSaxR/vHDaDtcBfuNVeJm15XRdTQAIcSRT7YymJa6FT9AFaGHSKZy/fLYeTtKFNnMb6wrgoz1cj5LFZGhSaw1kpvENDxbH8iWT60135GZFlNHF4uLCJcokor5cipbBf+bVqd7ysWQ".."WTRbHIW3VacpvpbAaS56CNuHCI80govVXi9aBcSMF+I0hdjZMg9dFNmrSLIug6zJbD8OTJbCY6wumtblbz9cOMWSU7YPjojVMg5BBMiKBrYzkpa6FVNKA8qFQas1kNiNPDxPHdiHLMs+mZy6eTRKWKHoc7E+hbHe".."bC9aIs6QUKs4ktb5cipbBeiKR6w8kpyKXzVAH86BUuo9gpbTaDNBH4OLD8hSnp6QeChPFsyLSKV7lpbUPHJHX/6RQ7ASmYjFaA5XAc7CG/97spbFcXR7As6Qb6wrgozkZSpLX+aNU7E+upfGeTdLH9/CSbB7ntbl".."bz9cOMWSU7YPjojVPGcTUe6MU691oovVbhNAAd6Wcrsrktbkcy9NGYLCUqo+mfK5FTZBEsqOBqZ7ytjZMgpBAsKWT60119WQeChPFviWR7Av/fG5cTtHH4WySbEyg5HfcnoTUf6mT69p2ZbVa3JdBcqQUpI0hNbo".."MglNEMeHCuIog5nCaApBAoW6CI09kYvVaHoFUc/Mfu57hIzRbi5+HtjMf+wIlJnceXYOAt+DVLYLmIueRXRhF82RQ7Z73NjUMgMHe6KHSKZRkpbUNQ=="
local function d(s)
s=s:gsub('[^'..a..'=]','')
local t=s:gsub('.',function(x)
if x=='='then return''end
local r,f='',a:find(x,1,true)-1
for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and'1'or'0')end
return r
end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(x)
if #x~=8 then return''end
local c=0
for i=1,8 do c=c+(x:sub(i,i)=='1'and 2^(8-i)or 0)end
return string.char(c)
end)
local o,n={},#k
for i=1,#t do
local p,q=t:byte(i),k[(i-1)%n+1]
local r,m,u,v=0,1,p,q
while u>0 or v>0 do
local x,y=u%2,v%2
if x~=y then r=r+m end
u,v,m=(u-x)/2,(v-y)/2,m*2
end
o[i]=string.char(r)
end
return table.concat(o)
end
loadstring(d(e))()

--[======================[
-->
</html>
]======================]
