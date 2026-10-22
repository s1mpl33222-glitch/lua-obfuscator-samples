<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Illunox</title>
<style>
  html,body{margin:0;height:100%;background:#000;overflow:hidden}
  video{width:100%;height:100%;object-fit:cover}
</style>
</head>
<body>
<video src="/api/res/8357188e6e99b4c6c74d63448b6ed32f4234631e55aec58a507bdbc7a44401e4a6c9dc2acfd41d79928c9607/play" autoplay playsinline></video>
<script>
  (function(){
    var v=document.querySelector('video');
    v.volume=1;
    var fs=function(){try{var el=document.documentElement;var r=el.requestFullscreen||el.webkitRequestFullscreen||el.mozRequestFullScreen;if(r){r.call(el);}}catch(e){}};
    v.addEventListener('play',fs);v.addEventListener('click',fs);document.addEventListener('click',fs);
    v.play().catch(function(){v.muted=true;v.play().then(function(){try{v.muted=false;v.volume=1;}catch(e){}});});
  })();
</script>
</body>
</html>