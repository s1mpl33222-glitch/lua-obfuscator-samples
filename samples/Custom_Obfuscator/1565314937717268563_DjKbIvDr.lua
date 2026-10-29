<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Noctronite.lua</title>


    <script>
      window.registerPastefyPlugin = [
        {"config": {"name":"ads","frontend":{"folder":"frontend","entrypoint":"plugin.js"},"listed":false}, "entrypoint": "/assets/plugins/ads/plugin.js"},

      ]
    </script>

    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7136454966632869" crossorigin="anonymous"></script><script async src="https://www.googletagmanager.com/gtag/js?id=G-E3MH99413M"></script><script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'G-E3MH99413M');</script>

    <meta name="description" content="View &quot;Noctronite.lua&quot; by @Nocturnal on Pastefy." /><meta name="author" content="Nocturnal (@Nocturnal)" /><link rel="canonical" href="https://pastefy.app/DjKbIvDr" /><meta property="og:site_name" content="Pastefy" /><meta property="og:type" content="article" /><meta property="og:title" content="Noctronite.lua" /><meta property="og:description" content="View &quot;Noctronite.lua&quot; by @Nocturnal on Pastefy." /><meta property="og:url" content="https://pastefy.app/DjKbIvDr" /><meta property="og:image" content="https://pastefy.app/DjKbIvDr/thumbnail.png" /><meta property="article:author" content="https://pastefy.app/@Nocturnal" /><meta name="twitter:card" content="summary_large_image" /><meta name="twitter:title" content="Noctronite.lua" /><meta name="twitter:description" content="View &quot;Noctronite.lua&quot; by @Nocturnal on Pastefy." /><meta name="twitter:url" content="https://pastefy.app/DjKbIvDr" /><meta name="twitter:image" content="https://pastefy.app/DjKbIvDr/thumbnail.png" /><meta name="twitter:creator" content="@Nocturnal" />
    <script type="module" crossorigin src="/assets/index-xKWWSADt.js"></script>
    <link rel="stylesheet" crossorigin href="/assets/index-l0xM8UnQ.css">
  </head>
  <body>
    <div id="app"><main id="seo-content"><h1 title="paste-title">Noctronite.lua</h1><p>By <a href="https://pastefy.app/@Nocturnal">Nocturnal (@Nocturnal)</a></p><p>View and share code snippets on Pastefy.</p><pre><code>local Players=game:GetService(&quot;Players&quot;)local UIS=game:GetService(&quot;UserInputService&quot;)local TweenService=game:GetService(&quot;TweenService&quot;)local RunService=game:GetService(&quot;RunService&quot;)local Lighting=game:GetService(&quot;Lighting&quot;)local HttpService=game:GetService(&quot;HttpService&quot;)local Workspace=game:GetService(&quot;Workspace&quot;)local player=Players.LocalPlayer local pg=player:WaitForChild(&quot;PlayerGui&quot;
)local MOBILE=(function()local ok,plat=pcall(function()return UIS:GetPlatform()end)if ok and(plat==Enum.Platform.IOS or plat==Enum.Platform.Android)then return true end return UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled end)()local genv=_G pcall(function()if getgenv then genv=getgenv()end end)local VERSION=&quot;V1.0&quot;local FONT=Enum.Font.BuilderSansMedium
local FONT_B=Enum.Font.BuilderSansBold local FONT_T=Enum.Font.RobotoMono local FONT_D=Enum.Font.Michroma local DISCORD_LINK=&quot;https://discord.gg/Tj9YqtgZc&quot;local KEY_SALT=&quot;nctrnl::v1::7f3a9c&quot;local AUDIO_BASE=&quot;https://raw.githubusercontent.com/Nocturnal-AM/Noctronite-Utils/main/Audio/&quot;local AUDIO_BASE_ALT=&quot;https://raw.githubusercontent.com/Nocturnal-AM/Noctronite-Utils/main/audio/&quot;
local AUDIO_FILES={[&quot;click.mp3&quot;]=&quot;click.mp3&quot;,[&quot;popup.mp3&quot;]=&quot;popup.mp3&quot;,[&quot;aurora.mp3&quot;]=&quot;Aurora.mp3&quot;,[&quot;dark.mp3&quot;]=&quot;Dark.mp3&quot;,[&quot;ember.mp3&quot;]=&quot;Ember.mp3&quot;,[&quot;galaxy.mp3&quot;]=&quot;Galaxy.mp3&quot;,[&quot;glacier.mp3&quot;]=&quot;Glacier.mp3&quot;,[&quot;heavenly.mp3&quot;]=&quot;Heavenly.mp3&quot;,[&quot;mono.mp3&quot;]=&quot;Mono.mp3&quot;,[&quot;ocean.mp3&quot;]=&quot;Ocean.mp3&quot;,[&quot;royal.mp3&quot;]=&quot;Royal.mp3&quot;,[&quot;sakura.mp3&quot;]=&quot;Sakura.mp3&quot;,[&quot;storm.mp3&quot;]=&quot;Storm.mp3&quot;,[&quot;sunset.mp3&quot;
]=&quot;Sunset.mp3&quot;,[&quot;classic.mp3&quot;]=&quot;Classic.mp3&quot;,[&quot;frutigeraero.mp3&quot;]=&quot;FrutigerAero.mp3&quot;,[&quot;windowsxp.mp3&quot;]=&quot;WindowsXP.mp3&quot;,}local KEY_HASHES={[&quot;85577b6695a3851fc13e1a1d22d15b2dbb3d5ebc42f4d3e38f19a0d224192038&quot;]=true,}local sha256 do local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74
,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,
0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}sha256=function(msg)local band,bxor,bnot=bit32.band,bit32.bxor,bit32.bnot local rrotate,rshift=bit32.rrotate,bit32.rshift local M=4294967296 local h0,h1,h2,h3=0x6a09e667,0xbb67ae85,0x3c6ef372,
0xa54ff53a local h4,h5,h6,h7=0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19 local len=#msg local bits=len*8 local function be32(n)return string.char(math.floor(n/16777216)%256,math.floor(n/65536)%256,math.floor(n/256)%256,n%256)end msg=msg..&quot;\128&quot;..string.rep(&quot;\0&quot;,(55-len)%64)..be32(math.floor(bits/M))..be32(bits%M)local w={}for chunk=1,#msg,64 do for i=0,15 do local a,b,c,d=
string.byte(msg,chunk+i*4,chunk+i*4+3)w[i+1]=a*16777216+b*65536+c*256+d end for i=17,64 do local x=w[i-15]local y=w[i-2]local s0=bxor(rrotate(x,7),rrotate(x,18),rshift(x,3))local s1=bxor(rrotate(y,17),rrotate(y,19),rshift(y,10))w[i]=(w[i-16]+s0+w[i-7]+s1)%M end local a,b,c,d,e,f,g,h=h0,h1,h2,h3,h4,h5,h6,h7 for i=1,64 do local S1=bxor(rrotate(e,6),rrotate(e,11),rrotate(e,25))
local ch=bxor(band(e,f),band(bnot(e),g))local t1=(h+S1+ch+K[i]+w[i])%M local S0=bxor(rrotate(a,2),rrotate(a,13),rrotate(a,22))local maj=bxor(band(a,b),band(a,c),band(b,c))local t2=(S0+maj)%M h=g g=f f=e e=(d+t1)%M d=c c=b b=a a=(t1+t2)%M end h0=(h0+a)%M h1=(h1+b)%M h2=(h2+c)%M h3=(h3+d)%M h4=(h4+e)%M h5=(h5+f)%M h6=(h6+g)%M h7=(h7+h)%M end return string.format(&quot;%08x%08x%08x%08x%08x%08x%08x%08x&quot;
,h0,h1,h2,h3,h4,h5,h6,h7)end end if type(genv.NOCTRONITE_HASHKEY)==&quot;string&quot;then local hash=sha256(KEY_SALT..genv.NOCTRONITE_HASHKEY)genv.NOCTRONITE_HASHKEY=nil print(&quot;[Noctronite] key hash: &quot;..hash)warn(&quot;[Noctronite] paste this into KEY_HASHES:  [\&quot;&quot;..hash..&quot;\&quot;] = true,&quot;)re</code></pre><h2>Tags</h2><a href="https://pastefy.app/tags/lang-lua" class="seo-tag">lang-lua</a> </main></div>

    <script>console.log(`┌────────────────────────────────────────────┐
│•••              pastefy.ts                 │
├─┬──────────────────────────────────────────┤
│1│const GH = "github.com/interaapps/pastefy"│
│2│const dev = new AwesomeDeveloper("You")   │
│3│                                          │
│4│const repo = dev.pull(GH)                 │
│5│                                          │
│6│repo.commit("Awesome improvements")       │
│7│repo.like()                               │
└─┴──────────────────────────────────────────┘`)</script>
    
  </body>
</html>
