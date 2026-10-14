<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Access Restricted</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
  
  body {
    margin: 0;
    min-height: 100vh;

    background: 
      radial-gradient(circle at center, rgba(0,0,0,0.7) 0%, rgba(2,6,23,0.9) 100%),
      url("https://raw.githubusercontent.com/ScriptObfuscator2/Website/refs/heads/main/Dark%20Theme%20With%20Light%20Bulb.jpeg");

    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;

    color: #e2e8f0;
    font-family: "Courier New", monospace;

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    padding: 40px;
    box-sizing: border-box;
  }

  .container {
    text-align: center;
    border: 1px solid #334155;
    padding: clamp(25px, 4vw, 50px);
    border-radius: 12px;
    background: rgba(15, 23, 42, 0.85);
    box-shadow: 0 0 40px rgba(0,0,0,0.8);
    width: min(90%, 520px);
  }

  h1 {
    color: #ef4444;
    font-size: clamp(20px, 2vw, 28px);
    margin-bottom: 5px;
  }

  p {
    font-size: clamp(12px, 1.2vw, 14px);
    color: #94a3b8;
    margin: 1px 1px;
  }

  .glitch {
    font-size: clamp(40px, 4vw, 60px);
    color: #ef4444;
    animation: glitch 1s infinite;
  }

  @keyframes glitch {
    0% { text-shadow: 2px 0 red; }
    20% { text-shadow: -2px 0 blue; }
    40% { text-shadow: 2px 2px red; }
    60% { text-shadow: -2px -2px blue; }
    80% { text-shadow: 2px -2px red; }
    100% { text-shadow: none; }
  }

  .footer-link {
    margin-top: 10px;
    font-size: 11px;
    color: #94a3b8;
    text-align: center;
  }

  .footer-link a {
    color: #38bdf8;
    text-decoration: none;
  }

  .footer-link a:hover {
    text-decoration: underline;
  }

  .date {
    position: fixed;
    bottom: 10px;
    left: 0;
    width: 100%;
    text-align: center;
    font-size: 10px;
    color: #64748b;
    pointer-events: none;
  }
  .top-fixed-banner{
    position:fixed;
    top:10px;
    left:50%;
    transform:translateX(-50%);
    z-index:9999;
    display:flex;
    justify-content:center;
    align-items:center;
  }
  .bottom-fixed-banner{
    width:100%;
    display:flex;
    justify-content:center;
    margin-top:25px;
  }
</style>
</head>

<body>


<!-- FIXED TOP BANNER -->
<div class="top-fixed-banner">
  <script>
    atOptions = {
      'key' : 'fcd076059604f8b969c86e85c0858db6',
      'format' : 'iframe',
      'height' : 90,
      'width' : 728,
      'params' : {}
    };
  </script>
  <script src="https://bauval.org/22/fcd076059604f8b969c86e85c0858db6"></script>
</div>


<!-- POPUNDER AD-->
<script data-cfasync="false" src="https://abscloud.org/1/57a03c69ddef36c8d53efb67bb56bdf1"></script>


<script>

// Get Script Data Function
async function GetScriptData(id) {
  let res = await fetch(`https://proxy.2677929.xyz/https://github.com/ScriptObfuscator2/Scripts/blob/main/${id}`);
  let text = await res.text();
  const startString = '"rawLines":["';
  const endString = '"],"stylingDirectives"';
  const startIndex = text.indexOf(startString);
  const endIndex = text.indexOf(endString);
  text = text.substring(startIndex + startString.length, endIndex);
  text = text.split("\\").join("");
  text = JSON.parse(text);
  return text;
}
  
(async () => {
  const params = new URLSearchParams(window.location.search);
  const id = params.get("Id");
  if (!id) return;

  try {
    const json = await GetScriptData(id);
    // 🔐 AUTH CHECK
    if (json && json.auth) {
      window.location.replace(`https://encrypt-x.pages.dev/Access?Id=${id}`);
    }
    // 📅 DATE DISPLAY
    if (json && json.Date) {
      const formatted = new Date(json.Date).toLocaleDateString("en-US", { month: "long", day: "numeric", year: "numeric" });
      document.querySelector(".date").innerText = `Published: ${formatted}`;
    }
  } catch (err) {
    console.log("ERROR:", err);
  }
})();
</script>

<div class="container">
  <div class="glitch">⚠</div>
  <h1>ACCESS DENIED</h1>

  <p>This script is protected by</p>
  <p>Encrypt X</p>
</div>

<div class="footer-link">
  <p>Do you want to obfuscate your script?</p>
  <a href="https://encrypt-x.pages.dev/" target="_blank">
    Click here
  </a>
</div>


<!-- BOTTOM BANNER -->
<div class="bottom-fixed-banner">
  <script>
    atOptions = {
      'key' : 'df503c7aa12efb03962a217b44ac5a2e',
      'format' : 'iframe',
      'height' : 250,
      'width' : 300,
      'params' : {}
    };
  </script>
  <script src="https://bauval.org/22/df503c7aa12efb03962a217b44ac5a2e"></script>
</div>


<div class="date">
  Published: NONE
</div>

</body>
</html>
