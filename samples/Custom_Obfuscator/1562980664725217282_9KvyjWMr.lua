<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>test-obfuscated.lua</title>


    <script>
      window.registerPastefyPlugin = [
        {"config": {"name":"ads","frontend":{"folder":"frontend","entrypoint":"plugin.js"},"listed":false}, "entrypoint": "/assets/plugins/ads/plugin.js"},

      ]
    </script>

    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7136454966632869" crossorigin="anonymous"></script><script async src="https://www.googletagmanager.com/gtag/js?id=G-E3MH99413M"></script><script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'G-E3MH99413M');</script>

    <meta name="description" content="View &quot;test-obfuscated.lua&quot; on Pastefy." /><link rel="canonical" href="https://pastefy.app/9KvyjWMr" /><meta property="og:site_name" content="Pastefy" /><meta property="og:type" content="article" /><meta property="og:title" content="test-obfuscated.lua" /><meta property="og:description" content="View &quot;test-obfuscated.lua&quot; on Pastefy." /><meta property="og:url" content="https://pastefy.app/9KvyjWMr" /><meta property="og:image" content="https://pastefy.app/9KvyjWMr/thumbnail.png" /><meta name="twitter:card" content="summary_large_image" /><meta name="twitter:title" content="test-obfuscated.lua" /><meta name="twitter:description" content="View &quot;test-obfuscated.lua&quot; on Pastefy." /><meta name="twitter:url" content="https://pastefy.app/9KvyjWMr" /><meta name="twitter:image" content="https://pastefy.app/9KvyjWMr/thumbnail.png" />
    <script type="module" crossorigin src="/assets/index-xKWWSADt.js"></script>
    <link rel="stylesheet" crossorigin href="/assets/index-l0xM8UnQ.css">
  </head>
  <body>
    <div id="app"><main id="seo-content"><h1 title="paste-title">test-obfuscated.lua</h1><p>View and share code snippets on Pastefy.</p><pre><code>-- This file was protected using Luraph Obfuscator v15.1 [https://discord.gg/c3zkVFa9Zn]

return setmetatable({y=buffer.create(16),c=function(q,W,D,c,v,E,o,H,J,_,w)if H&lt;=55 then if H&lt;=54 then local d=q[126](v,_);return 128&lt;=d and 153 or 85,W,v,_,d,o;else return 54,W[1],v,_,w,o;end;elseif H&lt;=56 then o[J]=D;return 146,W,v,_,w,o;elseif H&lt;=57 then if _~=1 then return 27,W,w,E,c,o;else return 95,W,v,_,w,o;end;else local D=q[126](v,_);return 128&lt;=D and 7 or 113,W,v,_,w,D;end;end,[33]=function(q,W,W,W)return function(W)local D=W[1];local c=W[2];return function(W,v,E)local o,H=22;local J,_,w,d,g,P,X,F,C,k,K,A=W,v,E;while true do E=nil;if o&lt;=14 then if o&lt;=6 then if o&lt;=2 then if o&lt;=0 then o,w=6,w+1;elseif o&lt;=1 then W=q[126](C,w+1);o,F=W&lt;128 and 16 or 5,W;else v=q[126](C,w+3);o,X,w=8,(X-128)*128+(F-128)*16384+(k-128)+v%128*2097152+(v-v%128)*2097152,w+4;end;elseif o&lt;=4 then if o&lt;=3 then local W,v=P-1,1+0;local a={v,H,K-v,W+0,nil};o,H=24,a;else local W,v=89,95;E=(w+_)%256;local a,Y,m=q[97](P),w*16843009,P-P%4;local V,U=m-1,4+0;local i=0-U;local f={U,V+0,H,i,nil};o,H,_,X,F,C,k,K=23,f,E,W,v,a,Y,m;end;elseif o&lt;=5 then local W=q[126](C,w+2);o,k=W&lt;128 and 19 or 2,W;else local W=q[126](C,w);o,X=W&lt;128 and 14 or 1,W;end;elseif o&lt;=10 then if o&lt;=8 then if o&lt;=7 then o,P,g=4,P-128+X*128,g+2;else local W,v=q[126](C,w),w+1;q[42](d,g+P,W,X);o=18;end;elseif o&lt;=9 then o,P,w=6,P-128+X*128,w+2;else o,P,w=6,(P-128)*16384+(X-128)+F*128,w+3;end;elseif o&lt;=12 then if o&lt;=11 then local W=H[2];J[4]=q[14](J);local v,K,a=q:AB(J,C);local Y=q[126](C,a);o,H,J,_,w,P=Y&lt;128 and 0 or 20,W,v,K,a,Y;else E=(X*_+F)%256;q[83](C,P,(q[31](q[126](d,g+P),w,E)));o,_=24,E;end;elseif o&lt;=13 then o,P,g=4,(P-128)*16384+(X-128)+F*128,g+3;else o,w=8,w+1;end;elseif o&lt;=21 then if o&lt;=17 then if o&lt;=15 then local W=q[126](C,w+2);o,F=W&lt;128 and 10 or 27,W;elseif o&lt;=16 then o,X,w=8,X-128+F*128,w+2;else local W=q[126](d,g+3);o,P,g=4,(P-128)*128+(X-128)*16384+(F-128)+W%128*2097152+(W-W%128)*2097152,g+4;end;elseif o&lt;=19 then if o&lt;=18 then return J,_;else o,X,w=8,(X-128)*16384+(F-128)+k*128,w+3;end;elseif o&lt;=20 then local W=q[126](C,w+1);o,X=W&lt;128 and 9 or 15,W;else local W=H[3];o,H=3,W;end;elseif o&lt;=25 then if o&lt;=23 then if o&lt;=22 then local W,v=J[7][_],J[6];local J=W+1;W=q[126](v,J);o,d,g,P=W&lt;128 and 25 or 28,v,J,W;else local W,v,J=H[4],H[1],H[2];local K,a=W+v,v&lt;=0;v,W=K&gt;=J,K&lt;=J;J=a and v or not a and W;H[4]=K;if J then o,A=29,K;else o=21;end;end;elseif o&lt;=24 then local W,v,J=H[3],H[1],H[4];local K,a=W+v,v&lt;=0;v,W=K&gt;=J,K&lt;=J;J=a and v or not a and W;H[3]=K;if J then o,P=12,K;else o=11;end;else o,g=4,g+1;end;elseif o&lt;=27 then if o&lt;=26 then local W=q[126](d,g+2);o,F=W&lt;128 and 13 or 17,W;else local W=q[126](C,w+3);o,P,w=6,(P-128)*128+(X-128)*16384+(F-128)+W%128*2097152+(W-W%128)*2097152,w+4;end;elseif o&lt;=28 then local W=q[126](d,g+1);o,X=W&lt;128 and 7 or 26,W;else local W,v,H=q[113],q[63](d,g+A),D[5][D[4]][_];W(C,A,(q[31](v,H,k)));E=c[5][c[4]][_];o,_=23,E;end;end;end;end;end,[118]=table.concat,[126]=buffer.readu8,[63]=buffer.readu32,[46]=buffer.writebits,D=function(q,W,D,c,v,E,o,H,J,_,w,d)if v&lt;=1 then if v&lt;=0 then E[J]=w;return 26,D,o,W,_,c,H;else local E=q[126](d,o+1);return E&lt;128 and 12 or 104,D,o,W,_,E,H;end;elseif v&lt;=2 then return 40,D,o,q[126](d,o+1),_,c,H;elseif v&lt;=3 then local v=q[126](d,o+3);local E,J,w,d,g=(_-128)*128,(c-128)*16384,H-128,2097152*(v%128),v%128;local P=2097152*(v-g);v=d+w+(E+P)+J;return 103,D,4+o,W,v,c,H;else local v,E=q[71](H),1+0;local q=1-E;return 105,{E,D,nil,H+0,q},o,W,_,c,v;end;end,u=function(q,W,D,c,v,E,o,H,J,_,w)if o&lt;=39 then if o&lt;=37 then local d=q[126](D,1+W);if 128&gt;d then return 160,d,W,v,H,E;else return 108,D,W,d,H,E;end;elseif o&lt;=38 then return 145,D,W+1,v,H,E;else local q,d=(E-128)*16384,c-128;local c=J*128+d+q;return 56,D,3+W,v,H,c;end;elseif o&lt;=40 then return w&lt;128 and 17 or 22,D,W,v,H,E;elseif o&lt;=41 then local q,c,o=_[2],_[5],_[3];local J,w=q+c,c&lt;=0;q,c=J&gt;=o,J&lt;=o;o=w and q or not w and c;_[2]=J;if o then return 49,D,W,v,J,E;else return 98,D,W,v,H,E;end;else return 86,D,1+W,v,H,E;end;end,[34]=buffer.tostring,hB=function(q,W,D,c,v,E,o,H)if v&lt;=26 then local J,_=q[63</code></pre><h2>Tags</h2></main></div>

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
