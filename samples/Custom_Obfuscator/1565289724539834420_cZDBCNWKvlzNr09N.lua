<!DOCTYPE html>
<html lang="en">
 <head>
  <meta charset="utf-8"/>
  <link href="https://media.base44.com/images/public/6a73115e1ce24ce5d8d006e3/b68bac646_logo.png/v1/fit/w_180,h_180/b68bac646_logo.png" rel="icon" type="image/svg+xml"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <link href="/manifest.json" rel="manifest"/>
  <title>
   LuaGuard
  </title>
  <script crossorigin="" src="/assets/index-BBOQ9fNP.js" type="module">
  </script>
  <link crossorigin="" href="/assets/index-BZEplDG2.css" rel="stylesheet"/>
  <script type="module">
   if (window.self === window.top) {
  let lastPath = "";
  function getPageNameFromPath(path) {
    const segments = path.split("/").filter(Boolean);
    return segments[0] || null;
  }
  function trackPageView() {
    const path = window.location.pathname;
    if (path === lastPath) return;
    lastPath = path;
    const pageName = getPageNameFromPath(path) || "home";
    const appId = "6a73115e1ce24ce5d8d006e3";
    if (!appId) return;
    fetch(`/api/app-logs/${appId}/log-user-in-app/${pageName}`, {
      method: "POST",
    }).catch(() => {});
  }
  const originalPushState = history.pushState.bind(history);
  history.pushState = function (...args) {
    originalPushState(...args);
    trackPageView();
  };
  const originalReplaceState = history.replaceState.bind(history);
  history.replaceState = function (...args) {
    originalReplaceState(...args);
    trackPageView();
  };
  window.addEventListener("popstate", trackPageView);
  trackPageView();
}
  </script>
  <meta content="yes" name="mobile-web-app-capable"/>
  <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
  <meta content="LuaGuard" name="apple-mobile-web-app-title"/>
  <script async="true" data-app-id="6a73115e1ce24ce5d8d006e3" data-platform-url="https://app.base44.com" src="/static/js/badge.js">
  </script>
 </head>
 <body>
  <div id="root">
  </div>
 </body>
</html>
