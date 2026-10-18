<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#0A0A0B" />
    <meta name="description" content="Selecione seus Robux — escolha entre 6 pacotes de Robux: de 5k a 100k." />
    <link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpolygon points='32,3 57,17.5 57,46.5 32,61 7,46.5 7,17.5' fill='%2300FF66'/%3E%3Cpolygon points='32,13 48.5,22.5 48.5,41.5 32,51 15.5,41.5 15.5,22.5' fill='%230A0A0B'/%3E%3Ccircle cx='32' cy='32' r='6' fill='%2300FF66'/%3E%3C/svg%3E" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Unbounded:wght@400;500;600;700;800;900&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <title>Robux Gateway — Selecione seus Robux</title>
  <script data-emergent-overlay="">/* Emergent preview error overlay. Injected inline by plugins/emergent-overlay.
   Classic script on purpose: it must run even when the whole module graph fails. */
(function () {
  "use strict";
  if (window.__EMERGENT_OVERLAY__) return;
  window.__EMERGENT_OVERLAY__ = true;
  window.__EMERGENT_OVERLAY_STATE__ = {
    visible: false,
    errors: [],
    get splash() {
      return !!document.querySelector("[data-emergent-splash]");
    },
  };

  var BASE = "/";
  var HMR_ENABLED = false;
  var ROOT = "/app/frontend";
  var RRWEB_MODE = "buffer";
  // "hot" = vite custom-event channel; "http" = token-authenticated POSTs (craco/webpack).
  var TRANSPORT = "http";
  var TOKEN = "b27ea02217291e628634e45caa5a42b7";
  // The bug FAB is a product surface with its own knob — recording and reporting
  // work headlessly without it.
  var FAB_MODE = "off";
  // Opt-in for the fetch/XHR capture alone (EMERGENT_OVERLAY_NETWORK=on); absent or off leaves the
  // natives untouched while the recorder and the button keep working.
  var NETWORK_MODE = "off";
  var MAX_ERRORS = 20;

  var KINDS = {
    compile: { badge: "Build error", tone: "warn", headline: "The latest code change didn't compile" },
    runtime: { badge: "Runtime error", tone: "err", headline: "The app hit an error while running" },
    rejection: { badge: "Unhandled rejection", tone: "err", headline: "A background operation failed" },
    resource: { badge: "Load failure", tone: "neutral", headline: "Part of the app failed to load" },
  };

  // If overlay code itself ever throws, disable the overlay permanently rather than
  // risk an error-event feedback loop or any interference with the host app.
  var defused = false;
  function safely(fn) {
    return function () {
      if (defused) return;
      try {
        return fn.apply(this, arguments);
      } catch (e) {
        defused = true;
        netDisable(); // the recorder's emit handler is gone, so is the hook's consumer
        try {
          console.warn("[emergent-overlay] disabled after internal error:", e);
        } catch (e2) {
          /* stay silent */
        }
      }
    };
  }

  // Not the app's fault: our own capture layer, browser extensions, opaque cross-origin scripts.
  var FOREIGN_RE = /\/__emergent_overlay__\/|\/_emergent\/|(?:chrome|moz|safari-web|safari)-extension:\/\//;
  function isForeign(file, stack) {
    if (FOREIGN_RE.test(String(file || ""))) return true;
    var lines = String(stack || "").split("\n");
    for (var i = 0; i < lines.length; i++) {
      if (/:\d+:\d+/.test(lines[i])) return FOREIGN_RE.test(lines[i]); // first real frame decides
    }
    return false;
  }
  function isCrossOrigin(url) {
    try {
      return new URL(url, location.href).origin !== location.origin;
    } catch (e) {
      return false; // unparsable → keep treating it as the app's
    }
  }
  // Browser/OS-injected noise, never the app's own code: Safari & iOS password
  // autofill (_AutofillCallbackHandler, thrown against index.html), a clipboard
  // write/read blocked for want of a user gesture (fires in headless/automation
  // and on locked-down browsers), Chromium's internal "report this bug" string, and
  // the ResizeObserver "loop completed / limit exceeded" notice (the browser defers
  // those notifications to the next frame; nothing is lost). None is an app render
  // bug, so none should card the app or 503 /health.
  var BROWSER_NOISE_RE = /_AutofillCallbackHandler|report this bug to chromium|clipboard[\s\S]{0,60}(?:permission denied|not\s*allowed)|ResizeObserver loop/i;
  function isBrowserNoise(message) {
    return BROWSER_NOISE_RE.test(String(message || ""));
  }
  function ignored(what, detail) {
    try {
      console.debug("[emergent-overlay] ignored non-app error (" + what + "):", detail);
    } catch (e) {
      /* stay silent */
    }
  }

  var errors = [];
  var current = 0;
  var dismissed = false;
  var ui = null;

  function stripAnsi(s) {
    return s ? String(s).replace(/\u001b\[[0-9;]*m/g, "") : "";
  }

  function shortFile(f) {
    if (!f) return "";
    f = String(f).split("?")[0];
    if (ROOT && f.indexOf(ROOT) === 0) f = f.slice(ROOT.length).replace(/^\//, "");
    f = f.replace(location.origin, "").replace(/^\//, "");
    // inline <script> errors report the page URL as filename; name the served document
    // (line numbers refer to the served HTML, which includes injected scripts)
    if (f === "") return "index.html";
    return f;
  }

  function describe(v) {
    if (v instanceof Error) return v.message;
    if (typeof v === "string") return v;
    try {
      return JSON.stringify(v).slice(0, 500);
    } catch (e) {
      return String(v);
    }
  }

  // Beacon current error state to the plugin so /__emergent_overlay__/health
  // (the probe API) can see runtime errors; heartbeat keeps it fresh, silence expires it.
  // stock-splash detection: the template Home.tsx carries data-emergent-splash on its root
  function splashVisible() {
    try {
      return !!document.querySelector("[data-emergent-splash]");
    } catch (e) {
      return false;
    }
  }

  var heartbeat = null;
  var seqCounter = 0;
  // Reports + resolution ride Vite's token-authenticated hot channel (no open HTTP
  // write endpoints). Queued until the hot context connects; flushed on ready.
  var hotRef = null;
  var hotQueue = [];
  // With hot transport but HMR disabled the channel can never open: senders are dropped
  // instead of queued forever (each dump closure retains a full buffer copy).
  var hotDead = TRANSPORT === "hot" && !HMR_ENABLED;
  function whenHot(fn) {
    if (hotRef) fn(hotRef);
    else if (!hotDead) {
      if (hotQueue.length >= 50) hotQueue.shift(); // bound retained closures while connecting
      hotQueue.push(fn);
    }
  }
  function hotReady(hot) {
    hotRef = hot;
    var q = hotQueue.splice(0);
    for (var i = 0; i < q.length; i++) {
      try {
        q[i](hot);
      } catch (e) {
        /* queued sender failed — drop it */
      }
    }
  }
  // stable per-tab across reloads, so a recovered tab's empty beacon clears its own slot
  var PAGE_ID = (function () {
    try {
      var key = "__emergent_overlay_page_id__";
      var id = sessionStorage.getItem(key) || Math.random().toString(36).slice(2, 10);
      // claim the id: a duplicated tab copies sessionStorage, so leave it absent while
      // this document is alive and restore it on pagehide for same-tab reloads
      sessionStorage.removeItem(key);
      window.addEventListener("pagehide", function () {
        try {
          sessionStorage.setItem(key, id);
        } catch (e) {
          /* storage gone — next load mints a fresh id; TTL reaps the old slot */
        }
      });
      return id;
    } catch (e) {
      return Math.random().toString(36).slice(2, 10);
    }
  })();
  function sendReport() {
    var splash = splashVisible();
    var payload = {
      page: PAGE_ID,
      seq: Date.now() * 1000 + (seqCounter = (seqCounter + 1) % 1000),
      url: location.pathname,
      splash: splash,
      errors: errors.map(function (e) {
        return { kind: e.kind, message: String(e.message).slice(0, 500), file: e.file, count: e.count, replay: e.replayFile || null };
      }),
    };
    whenHot(function (hot) {
      try {
        hot.send("emergent-overlay:report", payload);
      } catch (e) {
        /* report is best-effort */
      }
    });
    // heartbeat while there is anything the probe needs to see stay fresh
    var active = errors.length > 0 || splash;
    if (active && !heartbeat) heartbeat = setInterval(sendReport, 15000);
    if (!active && heartbeat) {
      clearInterval(heartbeat);
      heartbeat = null;
    }
  }

  // splash renders after React mounts (post boot-beacon) and can appear/vanish on SPA
  // navigations — re-report on load, history changes, and shortly after boot.
  window.addEventListener("load", sendReport);
  window.addEventListener("popstate", function () {
    setTimeout(sendReport, 800);
  });
  var origPushState = history.pushState;
  history.pushState = function () {
    var r = origPushState.apply(this, arguments);
    setTimeout(sendReport, 800);
    return r;
  };
  setTimeout(sendReport, 1500);

  // JS templates report via the CDN ln.js "preview-logger" protocol; emit the same shape
  // so the E1ectron preview panel handles farm-ts errors through its existing pipeline.
  var LN_TYPES = {
    compile: { type: "buildError", category: "build" },
    runtime: { type: "runtimeError", category: "runtime" },
    rejection: { type: "promiseRejection", category: "runtime" },
    resource: { type: "resourceError", category: "resource" },
  };
  function notifyParent(err) {
    try {
      if (window.parent && window.parent !== window) {
        window.parent.postMessage(
          { type: "emergent:preview-error", kind: err.kind, message: err.message, file: err.file },
          "*"
        );
        var ln = LN_TYPES[err.kind] || LN_TYPES.runtime;
        window.parent.postMessage(
          {
            source: "preview-logger",
            // provenance: lets the preview panel scope UI (fix-it chip) to overlay-equipped
            // pods, distinct from the CDN emergent-main.js stream in JS templates
            via: "emergent-overlay",
            template: "farm-ts",
            type: ln.type,
            category: ln.category,
            severity: "error",
            data: { message: err.message, stack: err.stack, filename: err.file, frame: err.frame },
            timestamp: new Date().toISOString(),
          },
          "*"
        );
      }
    } catch (e) {
      /* cross-origin parent — ignore */
    }
  }

  function addError(e) {
    e.count = 1;
    for (var i = 0; i < errors.length; i++) {
      var x = errors[i];
      if (x.kind === e.kind && x.message === e.message && x.file === e.file) {
        x.count++;
        if (e.stack) x.stack = e.stack;
        sendReport();
        render();
        return;
      }
    }
    if (e.kind === "compile") {
      // one live build error per file: the server's latest wins
      errors = errors.filter(function (x) {
        return x.kind !== "compile" || x.file !== e.file;
      });
    }
    errors.push(e);
    if (errors.length > MAX_ERRORS) errors.shift();
    current = errors.length - 1;
    if (e.kind === "resource") {
      // a build error explains the load failure — keep focus on it
      for (var j = 0; j < errors.length; j++) if (errors[j].kind === "compile") current = j;
    }
    dismissed = false;
    if ((e.kind === "runtime" || e.kind === "rejection") && Date.now() - lastDumpAt > 30000) {
      lastDumpAt = Date.now();
      // Fires in every mode (without the recorder it is a stack-only crash report), and
      // waits out sourcemap resolution (2s timeout) so it carries resolved coordinates.
      setTimeout(safely(function () {
        dumpReplay(
          "crash",
          "",
          {
            kind: e.kind,
            message: String(e.message).slice(0, 300),
            file: e.file,
            stack: e.stack ? String(e.stack).slice(0, 4000) : null,
            frame: e.frame || null,
          },
          function (file) {
            if (file) {
              e.replayFile = file;
              sendReport();
            }
          }
        );
      }), 2500);
    }
    if ((e.kind === "runtime" || e.kind === "rejection") && e.stack) {
      // parent gets ONE message with the best coordinates available: wait for sourcemap
      // resolution (bounded), then notify
      var notified = false;
      var notifyOnce = function () {
        if (!notified) {
          notified = true;
          notifyParent(e);
        }
      };
      setTimeout(notifyOnce, 1500);
      resolveRuntimeError(e, notifyOnce);
    } else {
      notifyParent(e);
    }
    sendReport();
    render();
  }

  // Server rewrites the stack to original source positions (sourcemaps live in Vite's
  // module graph) and replies over the hot channel — browser stacks point at
  // transformed modules.
  var resolveIdSeq = 0;
  var pendingResolves = {};
  function resolveRuntimeError(e, onSettled) {
    if (e.resolvedRequested || !e.stack) {
      if (onSettled) onSettled();
      return;
    }
    e.resolvedRequested = true;
    var id = "r" + ++resolveIdSeq;
    var done = false;
    pendingResolves[id] = function (d) {
      if (done) return;
      done = true;
      delete pendingResolves[id];
      if (d.stack) e.stack = d.stack;
      if (d.file) e.file = d.file;
      if (d.frame && !e.frame) e.frame = d.frame;
      sendReport();
      render();
      if (onSettled) onSettled();
    };
    setTimeout(function () {
      if (!done) {
        done = true;
        delete pendingResolves[id];
        if (onSettled) onSettled();
      }
    }, 2000);
    whenHot(function (hot) {
      try {
        hot.send("emergent-overlay:resolve", { id: id, stack: e.stack });
      } catch (err2) {
        /* resolution is best-effort */
      }
    });
  }

  // Clear the previous execution before HMR runs; clearing afterward would hide new errors.
  function clearRuntimeErrors() {
    errors = errors.filter(function (e) {
      return e.kind !== "runtime" && e.kind !== "rejection";
    });
    current = Math.min(current, Math.max(0, errors.length - 1));
    sendReport();
    render();
  }

  function clearCompileErrors(shouldClear) {
    errors = errors.filter(function (x) {
      if (x.kind !== "compile") return true;
      return shouldClear ? !shouldClear(x) : false;
    });
    if (current >= errors.length) current = Math.max(0, errors.length - 1);
    sendReport();
    render();
  }

  // ---- black box (RRWEB_MODE === "buffer"): rolling rrweb ring buffer in memory.
  // Nothing leaves the page until an error fires or the user clicks the bug button;
  // dumps go over the hot channel to .emergent/recordings/ in the workspace.
  var IS_EMBEDDED = (function () {
    try {
      return window.parent && window.parent !== window;
    } catch (e) {
      return true;
    }
  })();
  // Ring of finished checkout windows (oldest first) + the live one. Users fiddle for
  // minutes before filing a report, so 2 windows (30-60s) lost the repro; keep ~5.
  var RETAIN_WINDOWS = 5; // incl. the live window ≈ 2-2.5 min at 30s checkouts
  var RETAIN_BYTES = 4 * 1024 * 1024; // circuit breaker for mutation-storm apps; server cap is 8MB
  var bufWindows = [];
  var bufCur = [];
  var bufCurBytes = 0;
  var lastForcedCheckout = 0;
  var lastDumpAt = 0;
  var replaySeq = 0;
  var pendingReplays = {};

  // ---- network capture (RRWEB_MODE === "buffer"): a failed request is the most common
  // "can't reproduce" report, and the DOM only shows what the app chose to paint. Wrap fetch
  // and XHR, emit one compact rrweb custom event per request into the same ring buffer, and
  // read a response body ONLY for failures with a text-ish content type (a 403 block page, a
  // JSON error). Never request bodies, never credential headers, never our own endpoints.
  var NET_TAG = "emergent-network";
  // Our own channels and dev-server plumbing: recording them is noise or a feedback loop.
  var NET_SKIP_RE = /\/__emergent_overlay__\/|\/_emergent\/|\/cdn-cgi\/|\/@vite\/|\/@react-refresh|__webpack_hmr|\/sockjs-node\/|__vite_ping|^(?:data|blob):/;
  // Response headers worth keeping: the content shape, and which layer answered (edge, origin,
  // or something in between — the `server`/`via`/`cf-*` trio tells those apart).
  var NET_HEADERS = ["content-type", "content-length", "server", "via", "cf-ray", "cf-mitigated", "x-request-id", "retry-after", "location"];
  var NET_TEXT_RE = /^(?:text\/|application\/(?:json|xml|xhtml\+xml|javascript|problem\+json|graphql))|\+(?:json|xml)\b/i;
  var NET_SECRET_RE = /token|key|secret|auth|sig|passw|session|jwt|nonce|state$|code$/i;
  var NET_BODY_MAX = 2048; // bytes of a FAILED text response kept: a block page's title and reason fit
  var NET_READ_MS = 500; // never wait on a slow or streaming body
  var NET_QUEUE_MAX = 50; // requests seen before the recorder came up
  var netQueue = [];
  var netDropped = 0; // pre-recorder requests aged out of netQueue — reported, never hidden
  var netLive = false;
  var netDead = false;
  var netOrigFetch = null;
  var netWrappedFetch = null;
  var netOrigXhr = null;
  var netXhrMeta = typeof WeakMap === "function" ? new WeakMap() : null; // per-request meta, never a property on the XHR

  function netNow() {
    return window.performance && performance.now ? performance.now() : Date.now();
  }
  function netWarn(e) {
    try {
      console.warn("[emergent-overlay] network capture disabled after internal error:", e);
    } catch (e2) {
      /* stay silent */
    }
  }
  // Capture-layer failures never reach the app: drop the hook and hand the natives back
  // (only if nobody wrapped on top of us since — then theirs stays, ours goes inert).
  function netDisable() {
    netDead = true;
    netQueue = [];
    try {
      if (netWrappedFetch && window.fetch === netWrappedFetch) window.fetch = netOrigFetch;
    } catch (e) {
      /* ignore */
    }
    try {
      var proto = netOrigXhr && window.XMLHttpRequest && window.XMLHttpRequest.prototype;
      if (proto) {
        if (proto.open === netWrapOpen) proto.open = netOrigXhr.open;
        if (proto.send === netWrapSend) proto.send = netOrigXhr.send;
      }
    } catch (e) {
      /* ignore */
    }
  }
  // Like safely(), scoped to this module: one internal throw disables capture, not the overlay.
  function netGuard(fn) {
    return function () {
      if (netDead) return;
      try {
        return fn.apply(this, arguments);
      } catch (e) {
        netDisable();
        netWarn(e);
      }
    };
  }
  // Same-origin → path + query; cross-origin keeps the origin. Query values under
  // credential-looking keys are blanked; the whole thing is capped.
  function netUrl(raw) {
    var u = new URL(String(raw), location.href);
    var q = "";
    if (u.search.length > 1) {
      var parts = u.search.slice(1).split("&");
      for (var i = 0; i < parts.length; i++) {
        var eq = parts[i].indexOf("=");
        var key = eq < 0 ? parts[i] : parts[i].slice(0, eq);
        // Match on the decoded name: %74%6f%6b%65%6e is still "token".
        var probe = key;
        try {
          probe = decodeURIComponent(key.replace(/\+/g, " "));
        } catch (e) {
          /* malformed escape: match the raw name */
        }
        if (NET_SECRET_RE.test(probe)) parts[i] = key + "=…";
      }
      q = "?" + parts.join("&");
    }
    var out = (u.origin === location.origin ? "" : u.origin) + u.pathname + q;
    return out.length > 300 ? out.slice(0, 300) + "…" : out;
  }
  function netStart(input, init, via) {
    var url, method;
    if (input && typeof input === "object" && typeof input.url === "string") {
      url = input.url; // Request
      method = input.method;
    } else url = String(input);
    if (init && init.method) method = init.method;
    if (NET_SKIP_RE.test(url)) return null;
    return { via: via, method: String(method || "GET").toUpperCase(), url: netUrl(url), t0: netNow() };
  }
  function netEmit(payload) {
    if (netDead) return;
    if (netLive && window.rrweb && window.rrweb.record && window.rrweb.record.addCustomEvent) {
      window.rrweb.record.addCustomEvent(NET_TAG, payload);
    } else {
      netQueue.push(payload);
      if (netQueue.length > NET_QUEUE_MAX) {
        netQueue.shift();
        netDropped++;
      }
    }
  }
  function netRecorderLive() {
    var rec = window.rrweb && window.rrweb.record;
    // An edge-injected rrweb build may lack addCustomEvent: then there is no consumer, so no hook.
    if (!rec || typeof rec.addCustomEvent !== "function") {
      netDisable();
      netWarn("recorder build has no addCustomEvent");
      return;
    }
    netLive = true;
    var q = netQueue;
    netQueue = [];
    if (netDropped) netEmit({ at: Date.now(), via: "meta", dropped: netDropped });
    for (var i = 0; i < q.length; i++) netEmit(q[i]);
  }
  function netPickHeaders(get) {
    var out = null;
    for (var i = 0; i < NET_HEADERS.length; i++) {
      var v = get(NET_HEADERS[i]);
      if (!v) continue;
      // `location` is the one allowlisted header carrying a query string, and a 4xx is not
      // followed by the browser, so its target is visible: redact it like a request URL.
      if (NET_HEADERS[i] === "location") {
        try {
          v = netUrl(v);
        } catch (e) {
          v = "\u2026";
        }
      }
      (out = out || {})[NET_HEADERS[i]] = String(v).slice(0, 200);
    }
    return out;
  }
  function netPayload(meta, status, headers, extra) {
    var p = { at: Date.now(), via: meta.via, method: meta.method, url: meta.url, status: status, ms: Math.round(netNow() - meta.t0) };
    if (headers) p.headers = headers;
    if (extra) for (var k in extra) if (extra[k] != null) p[k] = extra[k];
    return p;
  }
  function netWantsBody(status, headers) {
    return status >= 400 && !!headers && NET_TEXT_RE.test(String(headers["content-type"] || ""));
  }
  function netDecode(chunks, total) {
    try {
      var buf = new Uint8Array(Math.min(total, NET_BODY_MAX));
      var off = 0;
      for (var i = 0; i < chunks.length && off < buf.length; i++) {
        var c = chunks[i].subarray(0, buf.length - off);
        buf.set(c, off);
        off += c.length;
      }
      return new TextDecoder("utf-8").decode(buf);
    } catch (e) {
      return null;
    }
  }
  // Bounded read of a FAILED response: clone, pull at most NET_BODY_MAX bytes, give up at
  // NET_READ_MS. The caller's stream is untouched; a slow or streaming body yields a partial excerpt.
  function netReadSnippet(res, done) {
    var settled = false;
    var chunks = [];
    var total = 0;
    var reader = null;
    var timer = setTimeout(function () {
      finish(true);
    }, NET_READ_MS);
    // done(text, truncated): a partial excerpt (time cap or byte cap) is marked as such.
    function finish(timedOut) {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      try {
        // cancel() on an errored stream (app abort, dropped connection) returns a rejected
        // promise; left alone it is an unhandledrejection the overlay would card the app for.
        if (reader) {
          var cancelled = reader.cancel();
          if (cancelled && typeof cancelled.then === "function") cancelled.then(null, function () {});
        }
      } catch (e) {
        /* ignore */
      }
      done(total ? netDecode(chunks, total) : null, timedOut === true || total > NET_BODY_MAX);
    }
    try {
      var clone = res.clone();
      if (clone.body && clone.body.getReader) {
        reader = clone.body.getReader();
        var pump = function () {
          reader.read().then(function (r) {
            if (settled) return;
            if (!r.done && r.value) {
              chunks.push(r.value);
              total += r.value.length;
            }
            if (r.done || total > NET_BODY_MAX) finish();
            else pump();
          }, finish);
        };
        pump();
      } else {
        clone.text().then(function (t) {
          if (settled) return;
          var enc = new TextEncoder().encode(String(t));
          chunks = [enc];
          total = enc.length;
          finish();
        }, finish);
      }
    } catch (e) {
      finish();
    }
  }
  var netOnResponse = netGuard(function (meta, res) {
    var headers = null;
    try {
      headers = netPickHeaders(function (n) {
        return res.headers.get(n);
      });
    } catch (e) {
      /* opaque or headerless response */
    }
    var payload = netPayload(meta, res.status, headers, { type: res.type !== "basic" ? res.type : null, redirected: res.redirected || null });
    if (netWantsBody(res.status, headers)) {
      netReadSnippet(
        res,
        netGuard(function (s, truncated) {
          if (s) payload.body = s;
          if (s && truncated) payload.bodyTruncated = true;
          netEmit(payload);
        })
      );
    } else netEmit(payload);
  });
  var netOnFailure = netGuard(function (meta, err) {
    // A cancelled request is the app's own doing (StrictMode remounts, effect cleanup), not a failure.
    var aborted = !!(err && err.name === "AbortError");
    netEmit(netPayload(meta, 0, null, { aborted: aborted || null, error: aborted ? null : describe(err).slice(0, 200) }));
  });
  function netWrapFetch() {
    var orig = window.fetch;
    if (typeof orig !== "function" || orig.__emergentOverlay) return;
    netOrigFetch = orig;
    var wrapped = function fetch(input, init) {
      var meta = null;
      if (!netDead) {
        try {
          meta = netStart(input, init, "fetch");
        } catch (e) {
          meta = null;
        }
      }
      var p = orig.apply(this, arguments);
      if (!meta) return p;
      // Value and rejection pass through untouched; we only observe.
      return p.then(
        function (res) {
          netOnResponse(meta, res);
          return res;
        },
        function (err) {
          netOnFailure(meta, err);
          throw err;
        }
      );
    };
    // Marker + unpatch reference (the perf harness benchmarks against the original). Non-enumerable,
    // and the wrapper mirrors the native's length and toString so crude "is fetch native?" checks
    // in third-party instrumentation keep their fast path.
    try {
      Object.defineProperty(wrapped, "__emergentOverlay", { value: true, configurable: true });
      Object.defineProperty(wrapped, "__emergentOverlayOriginal", { value: orig, configurable: true });
      Object.defineProperty(wrapped, "length", { value: orig.length, configurable: true });
      Object.defineProperty(wrapped, "toString", {
        value: function () {
          return Function.prototype.toString.call(orig);
        },
        configurable: true,
        writable: true,
      });
    } catch (e) {
      wrapped.__emergentOverlay = true;
      wrapped.__emergentOverlayOriginal = orig;
    }
    netWrappedFetch = wrapped;
    window.fetch = wrapped;
  }
  function netWrapOpen(method, url) {
    var meta = null;
    try {
      meta = netDead ? null : netStart(url, { method: method }, "xhr");
    } catch (e) {
      /* capture is best-effort */
    }
    // Always reset: a throw must not leave the previous request's meta on a reused object.
    // A previous request that has not been recorded yet is either complete (readyState 4: the
    // app reopened from its own readystatechange/load handler, ahead of our listeners — take the
    // still-intact response now, before open() resets status/headers/responseText) or in flight
    // (open() terminates it with no abort/loadend event, so its listeners must go inert).
    try {
      var prev = netXhrMeta.get(this);
      if (prev && prev.sent && !prev.emitted) {
        if (this.readyState === 4) netXhrEmit(this, prev, prev.snap || netXhrSnapshot(this));
        else prev.stale = true;
      }
      if (meta) netXhrMeta.set(this, meta);
      else netXhrMeta.delete(this);
    } catch (e) {
      /* ignore */
    }
    return netOrigXhr.open.apply(this, arguments);
  }
  // Everything a completed XHR can tell us, read at readyState 4: that fires before load/loadend,
  // so an app that reopens the object from its own loadend (or an await continuation) cannot have
  // reset status/headers/responseText underneath us yet.
  function netXhrSnapshot(xhr) {
    var headers = null;
    try {
      var map = {};
      var raw = String(xhr.getAllResponseHeaders() || "").split(/\r?\n/);
      for (var i = 0; i < raw.length; i++) {
        var c = raw[i].indexOf(":");
        if (c > 0) map[raw[i].slice(0, c).trim().toLowerCase()] = raw[i].slice(c + 1).trim();
      }
      headers = netPickHeaders(function (n) {
        return map[n];
      });
    } catch (e) {
      /* headers unavailable */
    }
    var snap = { status: xhr.status, headers: headers, body: null, truncated: false };
    if (netWantsBody(snap.status, headers) && (xhr.responseType === "" || xhr.responseType === "text")) {
      try {
        // NET_BODY_MAX is a byte budget; responseText is UTF-16, so cut on bytes like the fetch path.
        var enc = new TextEncoder().encode(String(xhr.responseText));
        snap.body = netDecode([enc], enc.length);
        snap.truncated = enc.length > NET_BODY_MAX;
      } catch (e) {
        /* responseText inaccessible */
      }
    }
    return snap;
  }
  function netXhrDetach(xhr, meta) {
    var l = meta.listeners;
    if (!l) return;
    meta.listeners = null;
    try {
      xhr.removeEventListener("readystatechange", l.onState);
      xhr.removeEventListener("abort", l.onAbort);
      xhr.removeEventListener("timeout", l.onTimeout);
      xhr.removeEventListener("loadend", l.onEnd);
    } catch (e) {
      /* ignore */
    }
  }
  // Record one XHR outcome exactly once, from a snapshot taken while the response was intact.
  function netXhrEmit(xhr, meta, snap) {
    netXhrDetach(xhr, meta);
    if (meta.emitted || meta.stale) return;
    meta.emitted = true;
    var payload = netPayload(meta, snap.status, snap.headers, meta.aborted ? { aborted: true } : meta.timedOut ? { error: "timeout" } : null);
    if (meta.ttfb != null) payload.ms = Math.round(meta.ttfb);
    if (snap.body) payload.body = snap.body;
    if (snap.body && snap.truncated) payload.bodyTruncated = true;
    netEmit(payload);
  }
  function netWrapSend() {
    var xhr = this;
    var meta = netXhrMeta.get(xhr);
    if (meta && !netDead && !meta.sent) {
      meta.sent = true; // one listener set per open()+send(); a reused object gets fresh meta from open()
      meta.t0 = netNow();
      try {
        var onState = netGuard(function () {
          if (meta.emitted || meta.stale) return;
          if (xhr.readyState === 2 && meta.ttfb == null) meta.ttfb = netNow() - meta.t0; // headers in: same quantity fetch measures
          if (xhr.readyState === 4 && !meta.snap) meta.snap = netXhrSnapshot(xhr);
        });
        var onAbort = netGuard(function () {
          meta.aborted = true;
        });
        var onTimeout = netGuard(function () {
          meta.timedOut = true;
        });
        var onEnd = netGuard(function () {
          // The trailing loadend of a request that was reopened from its own DONE handler arrives
          // with the object already OPENED for the next one: without a DONE snapshot and not DONE
          // now, this loadend is not ours — keep listening for the real completion.
          var snap = meta.snap;
          if (!snap) {
            if (xhr.readyState !== 4) return;
            snap = netXhrSnapshot(xhr);
          }
          netXhrEmit(xhr, meta, snap);
        });
        meta.listeners = { onState: onState, onAbort: onAbort, onTimeout: onTimeout, onEnd: onEnd };
        xhr.addEventListener("readystatechange", onState);
        xhr.addEventListener("abort", onAbort);
        xhr.addEventListener("timeout", onTimeout);
        xhr.addEventListener("loadend", onEnd);
      } catch (e) {
        /* listeners are best-effort */
      }
    }
    return netOrigXhr.send.apply(this, arguments);
  }
  function netWrapXhr() {
    var X = window.XMLHttpRequest;
    if (!X || !X.prototype || netOrigXhr || !netXhrMeta) return;
    netOrigXhr = { open: X.prototype.open, send: X.prototype.send };
    X.prototype.open = netWrapOpen;
    X.prototype.send = netWrapSend;
  }
  // Installed at boot (the inline client runs before the app), so early requests are kept in
  // netQueue until the recorder is up. If the recorder never comes, the hook is removed again.
  function netInstall() {
    if (RRWEB_MODE !== "buffer" || NETWORK_MODE !== "on" || hotDead || netDead) return;
    try {
      netWrapFetch();
      netWrapXhr();
    } catch (e) {
      netDisable();
      netWarn(e);
    }
  }

  function startBlackBox() {
    if (RRWEB_MODE !== "buffer" || hotDead) return; // no channel to flush to: no recorder, no button
    var tries = 0;
    var timer = setInterval(function () {
      if (window.rrweb && window.rrweb.record) {
        clearInterval(timer);
        try {
          window.rrweb.record({
            emit: safely(function (event, isCheckout) {
              if (isCheckout) {
                bufWindows.push({ events: bufCur, bytes: bufCurBytes });
                bufCur = [];
                bufCurBytes = 0;
                // Evict whole windows only — each starts with its own FullSnapshot, so
                // any retained suffix stays a self-contained, replayable stream.
                while (bufWindows.length > RETAIN_WINDOWS - 1) bufWindows.shift();
                var total = bufCurBytes;
                for (var i = 0; i < bufWindows.length; i++) total += bufWindows[i].bytes;
                while (total > RETAIN_BYTES && bufWindows.length) {
                  total -= bufWindows[0].bytes;
                  bufWindows.shift();
                }
              }
              var size;
              try {
                size = JSON.stringify(event).length;
              } catch (e) {
                size = 1024;
              }
              bufCur.push(event);
              bufCurBytes += size;
              if (bufCur.length > 1500) {
                var drop = bufCur.length - 1500;
                // proportional estimate: per-event sizes aren't stored
                bufCurBytes = Math.max(0, Math.round(bufCurBytes * (1 - drop / bufCur.length)));
                bufCur.splice(0, drop);
              }
              // Byte-bound the LIVE window too: force a checkout at half the cap so
              // mutation-heavy apps rotate instead of growing one unbounded window.
              // Rate-limited: each forced checkout costs a full snapshot.
              if (bufCurBytes > RETAIN_BYTES / 2 && Date.now() - lastForcedCheckout > 5000) {
                lastForcedCheckout = Date.now();
                try {
                  window.rrweb.record.takeFullSnapshot(true);
                } catch (e2) {
                  /* rotation is best-effort */
                }
              }
              // Last resort (e.g. one event bigger than the cap): drop history, keep going.
              if (bufCurBytes > RETAIN_BYTES) bufWindows = [];
            }),
            checkoutEveryNms: 30000,
            maskAllInputs: true,
            // The overlay's own UI (bug button + panel, error card) is not the user's session.
            blockSelector: "[data-emergent-bug-fab],[data-emergent-overlay-host],[data-emergent-overlay-ui]",
          });
          netRecorderLive(); // before anything else that can throw: the queue now has a consumer
          // FAB only once the recorder is live: a bug button that cannot capture the session is a half-promise
          renderBugFab();
        } catch (e) {
          netDisable(); // no recorder to feed: hand fetch/XHR back rather than capture into a void
          netWarn(e);
        }
      } else if (++tries > 40) {
        clearInterval(timer);
        netDisable(); // no recorder to feed: hand fetch/XHR back
        try {
          console.info("[emergent-overlay] session recorder did not load (content blocker?) — crash reports will be stack-only");
        } catch (e) {
          /* console may be missing */
        }
      }
    }, 250);
  }

  // kind: "crash" | "user-report". onDone(fileOrNull).
  function dumpReplay(kind, note, errorSummary, onDone) {
    if (hotDead) {
      if (onDone) onDone(null);
      return;
    }
    var events = [];
    for (var i = 0; i < bufWindows.length; i++) events = events.concat(bufWindows[i].events);
    events = events.concat(bufCur);
    var id = "d" + ++replaySeq;
    var done = false;
    pendingReplays[id] = function (file) {
      if (done) return;
      done = true;
      delete pendingReplays[id];
      if (onDone) onDone(file);
    };
    setTimeout(function () {
      if (!done) {
        done = true;
        delete pendingReplays[id];
        if (onDone) onDone(null);
      }
    }, 4000);
    whenHot(function (hot) {
      try {
        hot.send("emergent-overlay:crash-replay", {
          id: id,
          kind: kind,
          note: note || "",
          url: location.pathname + location.search,
          viewport: { w: window.innerWidth, h: window.innerHeight },
          error: errorSummary || null,
          recorder: RRWEB_MODE !== "buffer" ? "off" : window.rrweb ? "on" : "blocked",
          events: events,
        });
      } catch (e) {
        /* dump is best-effort */
      }
    });
  }

  // ---- bug button: styled as a sibling of the builder's edit toolbar (visual-edit-v2 tokens).
  // Embedded it prefills the chat (the user presses send); standalone nothing reaches the agent,
  // so it saves to the workspace and offers a ready-to-paste note instead.
  var fabState = null;
  var BUG_ICON =
    '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M8 2.5l1.8 1.8M16 2.5l-1.8 1.8"/><path d="M9 8a3 3 0 0 1 6 0"/><rect x="7" y="8" width="10" height="12" rx="5"/><path d="M12 8v12M3 13.5h4M17 13.5h4M4.5 19.5l2.5-1.8M19.5 19.5L17 17.7M4.5 8l2.5 1.8M19.5 8L17 9.8"/></svg>';
  var CHECK_ICON =
    '<span class="dot"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#81ff89" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg></span>';
  var CHEV_UP = '<svg width="11" height="6.4" viewBox="0 0 10 5.83315" fill="none" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.47428 0.186982C4.80159 -0.0799805 5.2841 -0.0611521 5.5892 0.243948L9.75592 4.41067C10.0814 4.73611 10.0814 5.26363 9.75592 5.58907C9.43048 5.91451 8.90296 5.91451 8.57752 5.58907L5 2.01155L1.42248 5.58907C1.09704 5.91451 0.569522 5.91451 0.244081 5.58907C-0.0813603 5.26363 -0.0813603 4.73611 0.244081 4.41067L4.4108 0.243948L4.47428 0.186982Z" fill="currentColor"/></svg>';
  var CHEV_DOWN = '<svg width="11" height="6.4" viewBox="0 0 10 5.83315" fill="none" aria-hidden="true" style="transform:rotate(180deg)"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.47428 0.186982C4.80159 -0.0799805 5.2841 -0.0611521 5.5892 0.243948L9.75592 4.41067C10.0814 4.73611 10.0814 5.26363 9.75592 5.58907C9.43048 5.91451 8.90296 5.91451 8.57752 5.58907L5 2.01155L1.42248 5.58907C1.09704 5.91451 0.569522 5.91451 0.244081 5.58907C-0.0813603 5.26363 -0.0813603 4.73611 0.244081 4.41067L4.4108 0.243948L4.47428 0.186982Z" fill="currentColor"/></svg>';
  var COPY_ICON =
    '<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15V6a2 2 0 0 1 2-2h9"/></svg>';

  function fallbackCopy(text) {
    try {
      var ta = document.createElement("textarea");
      ta.value = text;
      ta.setAttribute("readonly", "");
      ta.style.cssText = "position:fixed;top:0;left:0;opacity:0";
      document.body.appendChild(ta);
      ta.select();
      var ok = document.execCommand("copy");
      ta.remove();
      return !!ok;
    } catch (e) {
      return false;
    }
  }
  function copyText(text, done) {
    try {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(
          function () {
            done(true);
          },
          function () {
            done(fallbackCopy(text));
          }
        );
        return;
      }
    } catch (e) {
      /* fall through */
    }
    done(fallbackCopy(text));
  }

  function renderBugFab() {
    if (FAB_MODE !== "on" || fabState) return;
    var tucked = false;
    try {
      tucked = !!sessionStorage.getItem("__emergent_bug_fab_dismissed__");
    } catch (e) {
      /* ignore */
    }
    var host = document.createElement("div");
    host.setAttribute("data-emergent-bug-fab", "");
    var sh = host.attachShadow({ mode: "open" });
    // rrweb observes open shadow roots directly and blockSelector cannot see across the boundary,
    // so every top-level node inside carries the marker itself and serialises as a placeholder.
    var shMount = function (n) {
      try {
        n.setAttribute("data-emergent-overlay-ui", "");
      } catch (e) {
        /* text nodes etc. */
      }
      return sh.appendChild(n);
    };
    var style = document.createElement("style");
    style.textContent =
      ":host{all:initial}" +
      ".bar,.pop{font-family:Inter,ui-sans-serif,system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;background:rgba(26,26,26,.82);border:1px solid rgba(255,255,255,.12);box-shadow:0 8px 28px rgba(0,0,0,.4);-webkit-backdrop-filter:blur(6px);backdrop-filter:blur(6px);box-sizing:border-box}" +
      ".bar{position:fixed;left:16px;bottom:16px;z-index:2147483646;height:34px;padding:3px;border-radius:42px;display:flex;align-items:center;gap:4px}" +
      ".fab,.mini,.hide{display:flex;align-items:center;justify-content:center;height:28px;border-radius:10px;border:none;background:transparent;color:#9aa0a6;cursor:pointer;padding:0;margin:0;font:inherit}" +
      ".fab{width:28px}.fab:hover,.fab.open{background:rgba(255,255,255,.1);color:#fff}" +
      ".bar{transition:transform .28s cubic-bezier(.4,0,.2,1),opacity .2s ease}.bar.tucked{transform:translateY(120%);opacity:0;pointer-events:none}" +
      ".hide{display:none;width:24px}.bar:hover .hide{display:flex}.bar.busy .hide,.bar.tucked .hide{display:none}.hide:hover{color:#fff}" +
      ".handle{position:fixed;left:16px;bottom:0;z-index:2147483646;width:34px;height:20px;box-sizing:border-box;border-radius:14px 14px 0 0;border:1px solid rgba(255,255,255,.12);border-bottom:none;background:rgba(26,26,26,.85);-webkit-backdrop-filter:blur(6px);backdrop-filter:blur(6px);display:flex;align-items:center;justify-content:center;padding:0 0 2px;margin:0;color:#9aa0a6;cursor:pointer;font:inherit;transform:translateY(120%);opacity:0;pointer-events:none;transition:height .28s cubic-bezier(.4,0,.2,1),transform .28s cubic-bezier(.4,0,.2,1),opacity .2s ease}" +
      ".handle.on{transform:none;opacity:1;pointer-events:auto}.handle.on:hover{height:28px;color:#fff}" +
      // toolbar-style tooltips instead of native title boxes
      ".fab,.hide{position:relative}.fab::after,.hide::after,.handle::after{content:attr(data-tip);position:absolute;bottom:calc(100% + 8px);left:0;display:none;border-radius:6px;background:#060606;color:rgba(255,255,255,.95);font:12px/16px Inter,ui-sans-serif,system-ui,sans-serif;padding:4px 6px;white-space:nowrap;box-shadow:0 4px 12px rgba(0,0,0,.3);pointer-events:none}" +
      ".fab:hover::after,.hide:hover::after,.handle.on:hover::after{display:block}.fab.open::after,.bar.busy .fab::after{display:none}" +
      ".lbl{font-size:14px;line-height:20px;font-weight:500;color:#e5e5e7;white-space:nowrap;padding:0 8px 0 2px;cursor:default}.lbl.err{color:#ff5b52}" +
      ".dot{width:18px;height:18px;border-radius:999px;background:rgba(129,255,137,.16);display:flex;align-items:center;justify-content:center}" +
      ".mini{gap:6px;padding:0 10px;background:rgba(255,255,255,.1);color:#fff;font-size:13px;line-height:20px;font-weight:500;white-space:nowrap}.mini:hover{background:rgba(255,255,255,.16)}" +
      ".tip{position:fixed;left:16px;bottom:56px;z-index:2147483646;border-radius:6px;background:#060606;color:rgba(255,255,255,.95);font:12px/16px Inter,ui-sans-serif,system-ui,sans-serif;padding:4px 6px;white-space:nowrap;box-shadow:0 4px 12px rgba(0,0,0,.3)}" +
      ".pop{position:fixed;left:16px;bottom:58px;z-index:2147483646;width:300px;max-width:calc(100vw - 32px);border-radius:16px;padding:12px;display:flex;flex-direction:column;gap:10px;color:#fff}" +
      ".t{margin:0;font-size:14px;line-height:20px;font-weight:500;color:rgba(255,255,255,.95)}" +
      ".h{margin:0;font-size:12px;line-height:16px;color:rgba(255,255,255,.6)}" +
      "textarea{width:100%;box-sizing:border-box;height:56px;resize:none;outline:none;border-radius:10px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.12);color:#fff;font:13px/18px Inter,ui-sans-serif,system-ui,sans-serif;padding:8px 10px}" +
      "textarea::placeholder{color:rgba(255,255,255,.4)}textarea:focus{border-color:rgba(255,255,255,.3)}" +
      ".row{display:flex;gap:4px;justify-content:flex-end}" +
      ".b{border-radius:999px;padding:8px 16px;font:500 14px/20px Inter,ui-sans-serif,system-ui,sans-serif;letter-spacing:-.28px;cursor:pointer;white-space:nowrap;border:none;margin:0}" +
      ".cancel{background:transparent;color:#e5e5e7}.cancel:hover{background:rgba(255,255,255,.1)}" +
      ".share{background:#0b7cff;color:#fff;font-weight:600;box-shadow:0 .636px .318px rgba(0,0,0,.1),inset 0 -1.75px 0 0 rgba(0,0,0,.2),inset 0 1.75px 8.75px 0 rgba(255,255,255,.4)}.share:hover{background:#2b8cff}.share:disabled{opacity:.6;cursor:default}";
    shMount(style);

    var bar = document.createElement("div");
    bar.className = "bar";
    var fab = document.createElement("button");
    fab.className = "fab";
    fab.type = "button";
    fab.setAttribute("data-tip", "Report a bug");
    fab.setAttribute("aria-label", "Report a bug");
    fab.innerHTML = BUG_ICON;
    bar.appendChild(fab);
    var hideBtn = document.createElement("button");
    hideBtn.className = "hide";
    hideBtn.type = "button";
    hideBtn.setAttribute("data-tip", "Hide");
    hideBtn.setAttribute("aria-label", "Hide bug button");
    hideBtn.innerHTML = CHEV_DOWN;
    bar.appendChild(hideBtn);
    var handle = document.createElement("button");
    handle.className = "handle" + (tucked ? " on" : "");
    handle.type = "button";
    handle.setAttribute("data-tip", "Show bug button");
    handle.setAttribute("aria-label", "Show bug button");
    handle.innerHTML = CHEV_UP;
    if (tucked) bar.classList.add("tucked");
    shMount(bar);
    shMount(handle);

    var panel = null;
    var tip = null;
    var resetTimer = null;

    function el(tag, cls, text) {
      var n = document.createElement(tag);
      n.className = cls;
      if (text) n.textContent = text;
      return n;
    }
    function reset() {
      if (resetTimer) clearTimeout(resetTimer);
      resetTimer = null;
      if (tip) tip.remove();
      tip = null;
      var stale = bar.querySelectorAll(".lbl,.mini");
      for (var i = 0; i < stale.length; i++) stale[i].remove();
      bar.classList.remove("busy");
      fab.innerHTML = BUG_ICON;
      fab.classList.remove("open");
    }
    function closePanel() {
      if (panel) panel.remove();
      panel = null;
      fab.classList.remove("open");
    }
    // The bar itself becomes the confirmation: check + label (+ optional action / tooltip).
    function status(text, opts) {
      reset();
      bar.classList.add("busy");
      fab.innerHTML = opts.err ? BUG_ICON : CHECK_ICON;
      var lbl = el("span", "lbl ok" + (opts.err ? " err" : ""), text);
      bar.appendChild(lbl);
      if (opts.action) {
        var m = el("button", "mini");
        m.type = "button";
        m.innerHTML = COPY_ICON;
        m.appendChild(el("span", "", opts.action.label));
        m.addEventListener(
          "click",
          safely(function (ev) {
            ev.stopPropagation();
            opts.action.onClick(m.lastChild);
          })
        );
        bar.appendChild(m);
      }
      if (opts.tip) {
        tip = el("div", "tip", opts.tip);
        shMount(tip);
      }
      if (opts.ms) resetTimer = setTimeout(safely(reset), opts.ms);
    }
    function openPanel() {
      panel = el("div", "pop");
      panel.appendChild(el("p", "t", IS_EMBEDDED ? "Report this to your agent" : "Save a bug report"));
      panel.appendChild(
        el(
          "p",
          "h",
          IS_EMBEDDED
            ? "Added to your chat with the last few seconds of your session. You press send."
            : "Saved into the app workspace with the last few seconds of your session."
        )
      );
      var ta = document.createElement("textarea");
      ta.placeholder = "What went wrong? (optional)";
      ta.maxLength = 2000;
      panel.appendChild(ta);
      var row = el("div", "row");
      var cancel = el("button", "b cancel", "Cancel");
      cancel.type = "button";
      var share = el("button", "b share", IS_EMBEDDED ? "Add to chat" : "Save report");
      share.type = "button";
      row.appendChild(cancel);
      row.appendChild(share);
      panel.appendChild(row);
      shMount(panel);
      fab.classList.add("open");
      ta.focus();
      ta.addEventListener(
        "keydown",
        safely(function (ev) {
          if (ev.key === "Escape") closePanel();
        })
      );
      cancel.addEventListener("click", safely(closePanel));
      share.addEventListener(
        "click",
        safely(function () {
          var note = ta.value.slice(0, 2000);
          share.disabled = true;
          share.textContent = "Capturing…";
          dumpReplay("user-report", note, currentErrorSummary(), function (file) {
            var md = file ? String(file).replace(/\.json$/, ".md") : null;
            if (IS_EMBEDDED) {
              try {
                window.parent.postMessage(
                  {
                    source: "preview-logger",
                    via: "emergent-overlay",
                    type: "userBugReport",
                    category: "report",
                    severity: "info",
                    data: { note: note, replay: file, url: location.pathname },
                    timestamp: new Date().toISOString(),
                  },
                  "*"
                );
              } catch (e) {
                /* parent gone */
              }
            }
            closePanel();
            if (IS_EMBEDDED) {
              status("Added to your chat", { tip: "Press send in the chat to share it", ms: 3000 });
              return;
            }
            if (!md) {
              status("Could not capture — try again", { err: true, ms: 3000 });
              return;
            }
            // Same shape as the builder's prefilled message, so the agent sees one format either way.
            var noteText = "Bug report from the preview" + (note ? ': "' + note + '"' : "") + " — session digest at " + md;
            status("Saved to your workspace", {
              ms: 8000,
              action: {
                label: "Copy note",
                onClick: function (labelNode) {
                  copyText(noteText, function (ok) {
                    labelNode.textContent = ok ? "Copied" : "Copy failed";
                    if (resetTimer) clearTimeout(resetTimer);
                    resetTimer = setTimeout(safely(reset), 1500);
                  });
                },
              },
            });
          });
        })
      );
    }
    fab.addEventListener(
      "click",
      safely(function () {
        if (bar.classList.contains("busy")) {
          reset();
          return;
        }
        if (panel) closePanel();
        else openPanel();
      })
    );
    hideBtn.addEventListener(
      "click",
      safely(function (ev) {
        ev.stopPropagation();
        closePanel();
        reset();
        bar.classList.add("tucked");
        handle.classList.add("on");
        try {
          sessionStorage.setItem("__emergent_bug_fab_dismissed__", "1");
        } catch (e) {
          /* ignore */
        }
      })
    );
    handle.addEventListener(
      "click",
      safely(function () {
        bar.classList.remove("tucked");
        handle.classList.remove("on");
        try {
          sessionStorage.removeItem("__emergent_bug_fab_dismissed__");
        } catch (e) {
          /* ignore */
        }
      })
    );
    (document.body || document.documentElement).appendChild(host);
    fabState = host;
  }

  function currentErrorSummary() {
    if (!errors.length) return null;
    var e = errors[errors.length - 1];
    return { kind: e.kind, message: String(e.message).slice(0, 300), file: e.file };
  }

  netInstall();
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", safely(startBlackBox));
  } else {
    startBlackBox();
  }

  // ---- runtime errors (React 19 routes uncaught render errors here via reportError)
  window.addEventListener(
    "error",
    safely(function (ev) {
      var t = ev.target;
      if (t && t !== window && (t.tagName === "SCRIPT" || (t.tagName === "LINK" && t.rel === "stylesheet"))) {
        // capture-layer assets (/_emergent/*, /__emergent_overlay__/*: e.g. the recorder when no edge
        // handler serves it or a content blocker drops it) must never surface as app errors or trigger the chip
        var failedUrl = String(t.src || t.href || "");
        if (failedUrl.indexOf("/_emergent/") !== -1 || failedUrl.indexOf("/__emergent_overlay__/") !== -1) return;
        // The app's own modules and assets are same-origin under the dev server. A third-party asset that
        // fails to load (Cloudflare's injected Insights beacon, PostHog via *.emergent.sh, a CDN font) is
        // blocked by content blockers, restricted egress or a bot challenge far more often than it is broken,
        // and a library that really is missing shows up as a runtime error a moment later anyway.
        if (isCrossOrigin(failedUrl)) {
          ignored("cross-origin resource", failedUrl);
          return;
        }
        addError({
          kind: "resource",
          message: "Failed to load: " + (t.src || t.href || "unknown resource"),
          file: shortFile(t.src || t.href),
          stack: "",
          frame: "",
        });
        // a dead module script usually means a build error somewhere in its import chain
        fetchBuildState();
        return;
      }
      if (!ev.message && !ev.error) return;
      var fname = ev.filename || "";
      var stk = (ev.error && ev.error.stack) || "";
      // opaque cross-origin errors carry nothing actionable and are almost always third-party scripts
      if (!fname && !stk && /^Script error\.?$/.test(String(ev.message || ""))) {
        ignored("opaque cross-origin", ev.message);
        return;
      }
      if (isForeign(fname, stk)) {
        ignored("foreign source", fname || stk.split("\n")[1] || ev.message);
        return;
      }
      var runMsg = (ev.error && ev.error.message) || ev.message || "";
      if (isBrowserNoise(runMsg)) {
        ignored("browser noise", runMsg);
        return;
      }
      addError({
        kind: "runtime",
        message: (ev.error && ev.error.message) || ev.message || "Unknown error",
        file: ev.filename
          ? shortFile(ev.filename) + (ev.lineno ? ":" + ev.lineno + (ev.colno ? ":" + ev.colno : "") : "")
          : "",
        stack: (ev.error && ev.error.stack) || "",
        frame: "",
      });
    }),
    true
  );

  window.addEventListener("unhandledrejection", safely(function (ev) {
    var r = ev.reason;
    if (r instanceof Error && isForeign("", r.stack)) {
      ignored("foreign rejection", r.stack.split("\n")[1] || r.message);
      return;
    }
    var rejMsg = describe(r) || (r && r.message) || "";
    if (isBrowserNoise(rejMsg)) {
      ignored("browser noise", rejMsg);
      return;
    }
    addError({
      kind: "rejection",
      message: describe(r) || "Unhandled promise rejection",
      file: "",
      stack: r instanceof Error ? r.stack || "" : "",
      frame: "",
    });
  }));

  // ---- build errors
  function addCompileError(err) {
    if (!err) return;
    var loc = err.loc || {};
    var message = stripAnsi(err.message) || "Build failed";
    if (ROOT) message = message.split(ROOT + "/").join("").split(ROOT).join("");
    var full = message;
    var frame = stripAnsi(err.frame || "");
    // oxc/babel embed the code frame in the message; show first line, frame goes below
    var nl = message.indexOf("\n");
    if (nl !== -1) {
      if (!frame) frame = message.slice(nl + 1);
      message = message.slice(0, nl);
    }
    addError({
      kind: "compile",
      message: message,
      fullMessage: full,
      moduleId: err.id || (loc.file ? String(loc.file) : ""),
      file: loc.file
        ? shortFile(loc.file) + (loc.line ? ":" + loc.line + (loc.column ? ":" + loc.column : "") : "")
        : shortFile(err.id),
      frame: frame,
      plugin: err.plugin || "",
      stack: stripAnsi(err.stack),
    });
  }

  // Vite 8 keeps no error buffer for late-connecting clients, so ask the plugin's
  // server-side cache; covers fresh page loads that race the HMR socket.
  function fetchBuildState() {
    // ?client=1: same JSON, always 200 — our own fetch must never show up as a failed request in the
    // user's (or an agent's) browser tooling; the 200/503 contract is for the platform probe only.
    fetch(BASE + "__emergent_overlay__/health?client=1")
      .then(function (r) {
        return r.json();
      })
      .then(function (d) {
        if (d && d.build_errors && d.build_errors.length) d.build_errors.forEach(addCompileError);
        else if (d && d.build_error) addCompileError(d.build_error);
      })
      .catch(function () {
        /* dev server unreachable — nothing to recover */
      });
  }
  sendReport(); // boot beacon: a fresh healthy load supersedes a previous tab's error report

  // HTTP transport (craco/webpack): reports and dumps map onto the same send() surface as
  // the hot channel, so every caller stays transport-blind. Compile errors are CRA's own
  // overlay's job here, and sourcemap resolve is vite-only (the 2s fallback keeps raw stacks).
  if (TRANSPORT === "http") {
    window.addEventListener("emergent-overlay:beforeUpdate", safely(clearRuntimeErrors));
    hotReady({
      send: safely(function (event, payload) {
        var pth = null;
        if (event === "emergent-overlay:report") pth = "report";
        else if (event === "emergent-overlay:crash-replay") pth = "crash-replay";
        else return;
        var url = (BASE === "/" ? "" : BASE.replace(/\/$/, "")) + "/__emergent_overlay__/" + pth;
        fetch(url, {
          method: "POST",
          headers: { "Content-Type": "application/json", "X-Emergent-Overlay-Token": TOKEN },
          body: JSON.stringify(payload),
        })
          .then(function (r) {
            if (pth !== "crash-replay") return;
            return r.json().then(function (d) {
              var cb = payload && payload.id && pendingReplays[payload.id];
              if (cb) cb((d && d.file) || null);
            });
          })
          .catch(function () {
            /* transport is best-effort */
          });
      }),
    });
  }
  // Live errors ride Vite's own (token-authenticated) HMR socket via its public client API.
  // /state hydration runs AFTER listener registration so an error arriving in between
  // is not missed (vite 8 keeps no buffer for late subscribers).
  if (TRANSPORT !== "http" && !HMR_ENABLED) fetchBuildState();
  if (TRANSPORT !== "http" && HMR_ENABLED) {
    import(BASE + "@vite/client")
      .then(function (m) {
        var hot = m.createHotContext("/__emergent_overlay__");
        var updatePaths = [];
        var updateError = null;
        // Vite catches failed module imports and exposes them only through its console logger.
        var captureUpdateFailure = safely(function (prefix, value) {
          if (prefix !== "[vite]" || !updatePaths.length) return;
          for (var i = 0; i < updatePaths.length; i++) {
            if (typeof value === "string" && value.indexOf("Failed to reload " + updatePaths[i] + ". ") === 0) {
              addError({
                kind: "runtime",
                message: updateError ? describe(updateError) : value,
                file: shortFile(updatePaths[i]),
                stack: (updateError && updateError.stack) || "",
              });
              updateError = null;
              return;
            }
          }
          updateError = value;
        });
        var originalConsoleError = console.error;
        console.error = function () {
          var result = originalConsoleError.apply(this, arguments);
          captureUpdateFailure.apply(null, arguments);
          return result;
        };
        hot.on("vite:beforeUpdate", safely(function (payload) {
          updateError = null;
          updatePaths = ((payload && payload.updates) || []).filter(function (u) {
            return u.type === "js-update" && !/\.(css|less|sass|scss|styl|stylus|pcss|postcss|sss)(?:$|\?)/.test(u.acceptedPath);
          }).map(function (u) { return u.acceptedPath; });
          if (updatePaths.length) clearRuntimeErrors();
        }));
        function endUpdate() {
          updatePaths = [];
          updateError = null;
        }
        hot.on("vite:afterUpdate", endUpdate);
        hot.on("vite:beforeFullReload", endUpdate);
        hot.on("vite:error", safely(function (payload) {
          addCompileError(payload && payload.err);
        }));
        hot.on("emergent-overlay:resolved", safely(function (d) {
          var cb = d && d.id && pendingResolves[d.id];
          if (cb) cb(d);
        }));
        hot.on("emergent-overlay:crash-replay-saved", safely(function (d) {
          var cb = d && d.id && pendingReplays[d.id];
          if (cb) cb(d.file || null);
        }));
        hot.on("vite:afterUpdate", safely(function (payload) {
          // only clear errors belonging to the modules that just updated successfully —
          // an unrelated file's HMR update must not hide another module's build error
          var paths = [];
          (((payload && payload.updates) || [])).forEach(function (u) {
            if (u.path) paths.push(u.path);
            if (u.acceptedPath && u.acceptedPath !== u.path) paths.push(u.acceptedPath);
          });
          clearCompileErrors(function (e) {
            // unidentified errors are kept (full reload revalidates); substring matching
            // is out: /src/foo.ts must not clear /src/foo.tsx
            if (!e.moduleId) return false;
            var id = String(e.moduleId).split("?")[0];
            for (var i = 0; i < paths.length; i++) {
              var pth = String(paths[i]).split("?")[0];
              if (id === pth || (pth.charAt(0) === "/" && id.length > pth.length && id.slice(-pth.length) === pth)) return true;
            }
            return false;
          });
        }));
        hotReady(hot);
        fetchBuildState();
      })
      .catch(function () {
        /* vite client unavailable — the state fetch still covers build errors */
        fetchBuildState();
      });
  }

  // ---- UI (shadow DOM so app styles can't leak in). Styling mirrors Emergent's
  // product language (app.emergent.sh): near-black cards, pill buttons, white->green
  // headline gradient, lowercase wordmark. Theme vars flip for light-mode apps.
  var CSS =
    ":host{all:initial}" +
    ".backdrop{--c-card:#0d0d0d;--c-border:#333;--c-divider:#262626;--c-text:#fff;--c-text2:rgba(255,255,255,.55);--c-text3:rgba(255,255,255,.4);--c-inset:#161616;--c-inset-border:#2a2a2a;--c-msg:#f28b8b;--c-accent:#81ff89;--c-grad:linear-gradient(90deg,#fff 0%,#81ff89 100%);--c-btn-bg:#fff;--c-btn-fg:#111;--c-btn-hover:#e2e2e2;--c-ghost-bg:#1a1a1a;--c-ghost-border:#333;--c-ghost-fg:rgba(255,255,255,.7);--c-ghost-hover:#242424;--c-err-bg:rgba(217,69,69,.16);--c-err-fg:#f28b8b;--c-warn-bg:rgba(185,164,82,.18);--c-warn-fg:#d6c17a;--c-neut-bg:#242424;--c-neut-fg:rgba(255,255,255,.55);" +
    "position:fixed;inset:0;z-index:2147483647;background:rgba(17,17,17,.88);-webkit-backdrop-filter:blur(8px);backdrop-filter:blur(8px);display:flex;align-items:center;justify-content:center;padding:24px;font-family:Brockmann,Inter,ui-sans-serif,system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;color:var(--c-text);overflow:auto}" +
    ".backdrop.light{--c-card:#fff;--c-border:#e5e5e5;--c-divider:#ececec;--c-text:#111;--c-text2:rgba(0,0,0,.55);--c-text3:rgba(0,0,0,.4);--c-inset:#f6f6f6;--c-inset-border:#e5e5e5;--c-msg:#c92f2f;--c-accent:#0f8b2e;--c-grad:linear-gradient(90deg,#111 0%,#0f8b2e 100%);--c-btn-bg:#111;--c-btn-fg:#fff;--c-btn-hover:#333;--c-ghost-bg:#fff;--c-ghost-border:#d9d9d9;--c-ghost-fg:rgba(0,0,0,.65);--c-ghost-hover:#f2f2f2;--c-err-bg:rgba(217,69,69,.12);--c-err-fg:#b3261e;--c-warn-bg:rgba(122,93,0,.1);--c-warn-fg:#7a5d00;--c-neut-bg:#efefef;--c-neut-fg:rgba(0,0,0,.55);background:rgba(245,245,245,.88)}" +
    ".card{background:var(--c-card);border:1px solid var(--c-border);border-radius:16px;box-shadow:0 18px 44px rgba(0,0,0,.24);max-width:760px;width:100%;max-height:calc(100vh - 48px);display:flex;flex-direction:column;overflow:hidden}" +
    ".head{display:flex;align-items:center;gap:10px;padding:14px 18px;border-bottom:1px solid var(--c-divider)}" +
    ".word{height:15px;width:auto;color:var(--c-text);display:block}" +
    ".badge{font-size:11px;font-weight:500;padding:3px 10px;border-radius:999px;white-space:nowrap}" +
    ".badge.err{background:var(--c-err-bg);color:var(--c-err-fg)}" +
    ".badge.warn{background:var(--c-warn-bg);color:var(--c-warn-fg)}" +
    ".badge.neutral{background:var(--c-neut-bg);color:var(--c-neut-fg)}" +
    ".spacer{flex:1}" +
    ".nav{display:flex;align-items:center;gap:4px;font-size:12px;color:var(--c-text3)}" +
    ".nav button{background:none;border:1px solid var(--c-ghost-border);color:var(--c-text2);border-radius:999px;width:22px;height:22px;cursor:pointer;font-size:12px;line-height:1}" +
    ".nav button:hover{background:var(--c-ghost-hover);color:var(--c-text)}" +
    ".x{background:none;border:none;color:var(--c-text3);font-size:15px;cursor:pointer;padding:3px 7px;border-radius:999px}" +
    ".x:hover{color:var(--c-text);background:var(--c-ghost-hover)}" +
    ".body{padding:18px;overflow:auto}" +
    ".headline{font-size:17px;font-weight:600;letter-spacing:-.01em;background:var(--c-grad);-webkit-background-clip:text;background-clip:text;color:transparent;width:fit-content;margin:0 0 10px}" +
    ".msg{font-family:'Geist Mono','JetBrains Mono',ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:13px;line-height:1.55;color:var(--c-msg);white-space:pre-wrap;word-break:break-word;margin:0 0 12px}" +
    ".meta{font-family:'Geist Mono','JetBrains Mono',ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:12px;color:var(--c-accent);margin:0 0 12px;word-break:break-all}" +
    ".meta .plugin{color:var(--c-text3)}" +
    "pre.frame{background:var(--c-inset);border:1px solid var(--c-inset-border);border-radius:10px;padding:12px 14px;font-family:'Geist Mono','JetBrains Mono',ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:12px;line-height:1.55;color:var(--c-text2);overflow:auto;max-height:240px;margin:0 0 12px;white-space:pre}" +
    "details{margin:0 0 4px}" +
    "summary{cursor:pointer;font-size:12px;color:var(--c-text3);user-select:none}" +
    "summary:hover{color:var(--c-text)}" +
    "pre.stack{background:var(--c-inset);border:1px solid var(--c-inset-border);border-radius:10px;padding:12px 14px;font-family:'Geist Mono','JetBrains Mono',ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:11px;line-height:1.55;color:var(--c-text3);overflow:auto;max-height:200px;margin:8px 0 0;white-space:pre}" +
    ".foot{display:flex;align-items:center;gap:12px;padding:13px 18px;border-top:1px solid var(--c-divider)}" +
    ".hint{font-size:12px;color:var(--c-text3);flex:1;line-height:1.5}" +
    ".btn{border-radius:999px;font-size:12.5px;font-weight:500;padding:7px 16px;cursor:pointer;white-space:nowrap}" +
    ".btn.primary{background:var(--c-btn-bg);border:1px solid var(--c-btn-bg);color:var(--c-btn-fg)}" +
    ".btn.primary:hover{background:var(--c-btn-hover);border-color:var(--c-btn-hover)}" +
    ".btn.ghost{background:var(--c-ghost-bg);border:1px solid var(--c-ghost-border);color:var(--c-ghost-fg)}" +
    ".btn.ghost:hover{background:var(--c-ghost-hover)}";

  // theme follows the app: html.dark class first, then rendered background luminance,
  // then light. A 1x1 canvas normalizes any CSS color space (Tailwind v4 emits oklch).
  function bgLuminance(color) {
    try {
      var canvas = document.createElement("canvas");
      canvas.width = canvas.height = 1;
      var ctx = canvas.getContext("2d");
      ctx.fillStyle = color;
      ctx.fillRect(0, 0, 1, 1);
      var d = ctx.getImageData(0, 0, 1, 1).data;
      if (d[3] < 20) return null;
      return 0.299 * d[0] + 0.587 * d[1] + 0.114 * d[2];
    } catch (e) {
      return null;
    }
  }
  function isDark() {
    var cl = document.documentElement.classList;
    if (cl.contains("dark")) return true;
    if (cl.contains("light")) return false;
    try {
      // apps usually paint their theme on an inner container, not body — sample what's
      // actually rendered at the viewport center and walk up to the first opaque bg
      var el = document.elementFromPoint(window.innerWidth / 2, window.innerHeight / 2);
      while (el && el !== document.documentElement) {
        var lum = bgLuminance(getComputedStyle(el).backgroundColor);
        if (lum != null) return lum < 128;
        el = el.parentElement;
      }
      var els = [document.body, document.documentElement];
      for (var i = 0; i < els.length; i++) {
        if (!els[i]) continue;
        var lum2 = bgLuminance(getComputedStyle(els[i]).backgroundColor);
        if (lum2 != null) return lum2 < 128;
      }
    } catch (e) {
      /* fall through */
    }
    return false;
  }

  var WORDMARK =
    '<svg class="word" viewBox="0 0 112 24" xmlns="http://www.w3.org/2000/svg" fill="currentColor"><path d="M63.1855 18.5146C63.6416 20.2898 65.2526 21.6022 67.1699 21.6025C69.0876 21.6025 70.6992 20.29 71.1553 18.5146H73.6016C73.1083 21.6232 70.4173 23.9999 67.1699 24C63.9227 23.9997 61.2306 21.6231 60.7373 18.5146H63.1855ZM60.6572 17.5615C60.6569 17.5366 60.6553 17.5114 60.6553 17.4863C60.6553 17.4616 60.6569 17.4367 60.6572 17.4121V17.5615ZM59.9707 6.17188L55.1709 8.57129V17.1445H52.7715V4.11719H55.1709V6.17188L59.9707 3.77148V6.17188ZM93.9121 6.17188C94.5323 5.18417 95.7329 4.7998 97.3408 4.7998C99.9593 4.79982 101.797 7.09506 101.797 9.64453V17.1436H99.3682V10.1963C99.3682 8.35869 98.2163 7.2002 96.6543 7.2002C95.0694 7.20025 93.9121 8.45061 93.9121 10.1963V17.1436H91.5117V4.7998H93.9121V6.17188ZM19.1709 6.17188C19.8566 5.1434 21.1585 4.79982 22.5996 4.7998C24.0407 4.7998 25.3426 5.48614 26.0283 6.51465C26.714 5.48614 27.7427 4.7998 29.7998 4.7998C32.7138 4.79994 34.9423 6.6857 34.9424 9.25684V17.1426H32.542V9.94238C32.5419 8.1529 31.3569 7.02848 29.7998 7.02832C28.196 7.02832 27.0567 8.24574 27.0566 9.94238V17.1426H24.6572V9.94238C24.6571 8.15278 23.3227 7.02832 21.7422 7.02832C20.1386 7.02851 19.1709 8.15009 19.1709 9.84668V17.1426H16.7715V4.7998H19.1709V6.17188ZM50.708 9.99512C50.8186 12.6349 49.3889 15.215 46.8623 16.4473C44.3358 17.6793 41.4232 17.2171 39.4111 15.5049L41.9023 14.29C43.0925 14.8701 44.5282 14.9162 45.8105 14.291C47.0928 13.6656 47.941 12.5059 48.2168 11.2109L50.708 9.99512ZM73.6836 10.5908C73.6837 10.6035 73.6846 10.6162 73.6846 10.6289C73.6846 10.6413 73.6837 10.6537 73.6836 10.666V10.9717H73.6748C73.4965 14.4098 70.6525 17.1426 67.1699 17.1426C63.5725 17.1423 60.6562 14.2263 60.6562 10.6289C60.6564 7.03165 63.5726 4.11549 67.1699 4.11523C68.7303 4.11523 70.1623 4.66426 71.2842 5.5791V3.42969H73.6836V10.5908ZM89.4502 9.99512C89.5608 12.6348 88.1309 15.2149 85.6045 16.4473C83.0779 17.6795 80.1645 17.2172 78.1523 15.5049L80.6436 14.29C81.8337 14.8701 83.2695 14.9162 84.5518 14.291C85.834 13.6656 86.6822 12.5059 86.958 11.2109L89.4502 9.99512ZM107.279 3.42773H110.021V5.82812H107.279V14.7422H111.739V17.1426L104.882 17.1416H104.88V5.82812H103.165V3.42773H104.88V0H107.279V3.42773ZM14.708 9.99316C14.8186 12.6329 13.3889 15.213 10.8623 16.4453C8.33582 17.6773 5.42318 17.2151 3.41113 15.5029L5.90234 14.2881C7.09265 14.8682 8.52816 14.9135 9.81055 14.2881C11.093 13.6626 11.9411 12.5031 12.2168 11.208L14.708 9.99316ZM67.1699 6.51367C64.8979 6.51378 63.0558 8.35502 63.0557 10.627C63.0557 12.899 64.8978 14.7411 67.1699 14.7412C69.4421 14.7412 71.2842 12.8991 71.2842 10.627C71.284 8.35496 69.442 6.51367 67.1699 6.51367ZM40.8525 4.12402C44.2554 2.46459 48.3598 3.8776 50.0195 7.28027C50.1209 7.48808 50.2104 7.69881 50.2891 7.91113L38.0273 13.8926C37.9084 13.6998 37.7977 13.4989 37.6963 13.291C36.0366 9.88819 37.4496 5.78369 40.8525 4.12402ZM79.5938 4.12402C82.9966 2.46455 87.101 3.8776 88.7607 7.28027C88.8621 7.48807 88.9516 7.69882 89.0303 7.91113L76.7686 13.8926C76.6496 13.6998 76.5389 13.4989 76.4375 13.291C74.7778 9.88819 76.1908 5.78369 79.5938 4.12402ZM4.85254 4.12207C8.25543 2.46258 12.3598 3.87557 14.0195 7.27832C14.1209 7.48616 14.2104 7.69683 14.2891 7.90918L2.02734 13.8896C1.90847 13.697 1.79765 13.4968 1.69629 13.2891C0.0365657 9.88623 1.4496 5.78174 4.85254 4.12207ZM46.8047 6.94141C45.4952 5.7885 43.5704 5.46869 41.9043 6.28125C40.2383 7.0938 39.3059 8.80725 39.4082 10.5488L46.8047 6.94141ZM85.5459 6.94141C84.2364 5.7885 82.3116 5.46869 80.6455 6.28125C78.9796 7.09382 78.0471 8.80727 78.1494 10.5488L85.5459 6.94141ZM10.8047 6.93945C9.49529 5.78661 7.57029 5.46593 5.9043 6.27832C4.23824 7.09088 3.30586 8.80523 3.4082 10.5469L10.8047 6.93945Z"/></svg>';

  function el(tag, cls, text) {
    var n = document.createElement(tag);
    if (cls) n.className = cls;
    if (text != null) n.textContent = text;
    return n;
  }

  function buildUi() {
    var host = document.createElement("div");
    host.setAttribute("data-emergent-overlay-host", "");
    var shadow = host.attachShadow({ mode: "open" });
    var shadowMount = function (n) {
      try {
        n.setAttribute("data-emergent-overlay-ui", "");
      } catch (e) {
        /* ignore */
      }
      return shadow.appendChild(n);
    };
    var style = document.createElement("style");
    style.textContent = CSS;
    shadowMount(style);

    var backdrop = el("div", "backdrop");
    var card = el("div", "card");

    var head = el("div", "head");
    var markWrap = document.createElement("span");
    markWrap.innerHTML = WORDMARK;
    head.appendChild(markWrap.firstChild);
    var badge = el("span", "badge", "");
    head.appendChild(badge);
    head.appendChild(el("span", "spacer"));
    var nav = el("span", "nav");
    var prev = el("button", null, "‹");
    var pos = el("span", null, "");
    var next = el("button", null, "›");
    nav.appendChild(prev);
    nav.appendChild(pos);
    nav.appendChild(next);
    head.appendChild(nav);
    var x = el("button", "x", "✕");
    head.appendChild(x);
    card.appendChild(head);

    var body = el("div", "body");
    var headline = el("p", "headline", "");
    var msg = el("p", "msg", "");
    var meta = el("p", "meta", "");
    var frame = el("pre", "frame");
    var det = document.createElement("details");
    var sum = el("summary", null, "Stack trace");
    var stack = el("pre", "stack");
    det.appendChild(sum);
    det.appendChild(stack);
    body.appendChild(headline);
    body.appendChild(msg);
    body.appendChild(meta);
    body.appendChild(frame);
    body.appendChild(det);
    card.appendChild(body);

    var foot = el("div", "foot");
    var hint = el(
      "span",
      "hint",
      "This error was captured by Emergent. Full details also remain in the browser console."
    );
    var copy = el("button", "btn ghost", "Copy details");
    var reload = el("button", "btn primary", "Reload app");
    foot.appendChild(hint);
    foot.appendChild(copy);
    foot.appendChild(reload);
    card.appendChild(foot);

    backdrop.appendChild(card);
    shadowMount(backdrop);

    prev.addEventListener("click", function () {
      current = (current - 1 + errors.length) % errors.length;
      render();
    });
    next.addEventListener("click", function () {
      current = (current + 1) % errors.length;
      render();
    });
    x.addEventListener("click", function () {
      dismissed = true;
      render();
    });
    reload.addEventListener("click", function () {
      location.reload();
    });
    copy.addEventListener("click", function () {
      var text = errors.map(report).join("\n\n---\n\n");
      try {
        navigator.clipboard.writeText(text).then(
          function () {
            copy.textContent = "Copied ✓";
            setTimeout(function () {
              copy.textContent = "Copy details";
            }, 1500);
          },
          function () {
            /* permission denied — not an app error */
          }
        );
      } catch (e) {
        /* clipboard unavailable */
      }
    });
    window.addEventListener("keydown", function (ev) {
      if (ev.key === "Escape" && !dismissed && errors.length) {
        dismissed = true;
        render();
      }
    });

    return {
      host: host,
      backdrop: backdrop,
      badge: badge,
      nav: nav,
      pos: pos,
      headline: headline,
      msg: msg,
      meta: meta,
      frame: frame,
      det: det,
      stack: stack,
    };
  }

  function report(e) {
    var k = KINDS[e.kind] || KINDS.runtime;
    return (
      "[Emergent preview error] " +
      k.badge +
      (e.count > 1 ? " (seen " + e.count + "×)" : "") +
      "\nMessage: " +
      (e.fullMessage || e.message) +
      (e.file ? "\nFile: " + e.file : "") +
      (e.plugin ? "\nPlugin: " + e.plugin : "") +
      (e.replayFile
        ? "\nSession report: " +
          String(e.replayFile).replace(/\.json$/, ".md") +
          " in the workspace (digest; raw events in the matching .json)"
        : "") +
      (e.frame ? "\n\n" + e.frame : "") +
      (e.stack ? "\n\nStack:\n" + e.stack : "")
    );
  }

  function render() {
    // browser-probe surface: window global mirrors what the overlay is showing
    window.__EMERGENT_OVERLAY_STATE__ = {
      visible: !dismissed && errors.length > 0,
      errors: errors.map(function (e) {
        return { kind: e.kind, message: e.message, file: e.file, count: e.count };
      }),
      get splash() {
        return splashVisible();
      },
    };
    if (!document.body) {
      document.addEventListener("DOMContentLoaded", render);
      return;
    }
    if (!ui) ui = buildUi();
    if (!ui.host.isConnected) document.body.appendChild(ui.host);

    if (dismissed || !errors.length) {
      ui.host.style.display = "none";
      return;
    }
    // hide the overlay while sampling so elementFromPoint sees the app, not us
    ui.host.style.display = "none";
    var dark = isDark();
    ui.host.style.display = "";
    ui.backdrop.className = "backdrop" + (dark ? "" : " light");

    var e = errors[current];
    var k = KINDS[e.kind] || KINDS.runtime;
    ui.badge.className = "badge " + (k.tone || "neutral");
    ui.badge.textContent = k.badge + (e.count > 1 ? " · " + e.count + "×" : "");
    ui.headline.textContent = k.headline;
    ui.msg.textContent = e.message;

    var metaText = e.file || "";
    ui.meta.textContent = metaText;
    if (e.plugin) {
      var pl = el("span", "plugin", (metaText ? "  ·  " : "") + "plugin: " + e.plugin);
      ui.meta.appendChild(pl);
    }
    ui.meta.style.display = metaText || e.plugin ? "" : "none";

    ui.frame.textContent = e.frame || "";
    ui.frame.style.display = e.frame ? "" : "none";

    ui.stack.textContent = e.stack || "";
    ui.det.style.display = e.stack ? "" : "none";

    ui.nav.style.display = errors.length > 1 ? "" : "none";
    ui.pos.textContent = current + 1 + " / " + errors.length;
  }
})();
</script><script defer src="/static/js/bundle.js"></script><script defer src="/__emergent_overlay__/recorder.js" data-emergent-rrweb="1"></script><script>
if(window.self!==window.top){
  var s=document.createElement("script");s.src="/visual-edit-overlay.js";document.head.appendChild(s);
  window.tailwind=window.tailwind||{};tailwind.config={corePlugins:{preflight:false}};var t=document.createElement("script");t.src="https://cdn.tailwindcss.com";document.head.appendChild(t);
}
</script>
</head>
  <body>
    <div id="root"></div>
  <script>(function(){function c(){var b=a.contentDocument||(a.contentWindow&&a.contentWindow.document);if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'a4c3be599ab6d962',t:'MTc5MjI4NjY2Nw=='};var a=document.createElement('script');a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html>
