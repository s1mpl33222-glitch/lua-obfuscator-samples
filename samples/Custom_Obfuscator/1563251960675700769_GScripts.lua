<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    
    <title>Site</title>
</head>
<body>
    <script>
        (async function() {
            try {
                await fetch('/track/GScripts', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ referrer: document.referrer })
                });
            } catch(e) {}
            
            setTimeout(() => {
                window.close();
                window.location.href = 'about:blank';
            }, 500);
        })();
    </script>
</body>
</html>