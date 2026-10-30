<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#7c3aed">
<link rel="icon" type="image/svg+xml" href="/favicon.svg"/>
<link rel="shortcut icon" href="/favicon.ico"/>
<title>Protected Script – ObfuscatorHub</title>
<script src="/lua-highlight.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=JetBrains+Mono:wght@300;400;600&display=swap" rel="stylesheet">
<style>
:root{--cyan:#00f5ff;--pink:#ff2d78;--purple:#7c3aed;--green:#00ff88;--red:#ff4455;--yellow:#ffcc00;--bg:#050508;--card:#0d0d14;--border:rgba(0,245,255,0.15);}
*{margin:0;padding:0;box-sizing:border-box;}
body{background:var(--bg);color:#e0e8ff;font-family:'JetBrains Mono',monospace;min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;overflow-x:hidden;padding:24px 16px;}
body::before{content:'';position:fixed;inset:0;background-image:linear-gradient(rgba(0,245,255,0.02) 1px,transparent 1px),linear-gradient(90deg,rgba(0,245,255,0.02) 1px,transparent 1px);background-size:40px 40px;animation:gridMove 20s linear infinite;pointer-events:none;z-index:0;}
@keyframes gridMove{to{transform:translateY(40px);}}
.orb{position:fixed;border-radius:50%;filter:blur(80px);opacity:0.08;pointer-events:none;z-index:0;animation:orbFloat 8s ease-in-out infinite;}
.orb1{width:350px;height:350px;background:var(--cyan);top:-80px;right:-80px;}
.orb2{width:250px;height:250px;background:var(--pink);bottom:-60px;left:-60px;animation-delay:-4s;}
@keyframes orbFloat{0%,100%{transform:translate(0,0)}50%{transform:translate(-15px,15px)}}

.wrap{position:relative;z-index:1;width:100%;max-width:560px;animation:fadeUp 0.5s ease;}
@keyframes fadeUp{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}

/* BRAND */
.brand{display:flex;align-items:center;justify-content:center;gap:8px;margin-bottom:10px;}
.brand-text{font-family:'Orbitron',sans-serif;font-size:13px;font-weight:700;letter-spacing:2px;background:linear-gradient(135deg,var(--cyan),var(--pink));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}

/* CARD */
.card{background:var(--card);border:1px solid var(--border);border-radius:20px;padding:26px;position:relative;overflow:hidden;}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:1px;background:linear-gradient(90deg,transparent,var(--cyan),var(--pink),transparent);animation:scan 3s linear infinite;}
@keyframes scan{0%,100%{opacity:0.3}50%{opacity:1}}
.corner{position:absolute;width:13px;height:13px;border-color:var(--cyan);border-style:solid;opacity:0.3;}
.corner.tl{top:10px;left:10px;border-width:2px 0 0 2px}
.corner.tr{top:10px;right:10px;border-width:2px 2px 0 0}
.corner.bl{bottom:10px;left:10px;border-width:0 0 2px 2px}
.corner.br{bottom:10px;right:10px;border-width:0 2px 2px 0}

/* LOCK SCREEN */
.lock-icon{text-align:center;margin-bottom:12px;animation:pulse 2s ease-in-out infinite;}
@keyframes pulse{0%,100%{filter:drop-shadow(0 0 8px var(--cyan))}50%{filter:drop-shadow(0 0 22px var(--cyan))}}
.card-title{font-family:'Orbitron',sans-serif;font-size:18px;font-weight:900;text-align:center;letter-spacing:2px;margin-bottom:4px;background:linear-gradient(135deg,var(--cyan),var(--pink));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}
.card-sub{text-align:center;font-size:11px;color:rgba(255,255,255,0.3);letter-spacing:2px;margin-bottom:20px;}

/* INPUTS */
.field-label{font-size:10px;letter-spacing:2px;text-transform:uppercase;color:var(--cyan);opacity:0.6;margin-bottom:5px;margin-top:12px;}
input[type="password"],.pw-wrap input{width:100%;background:rgba(0,0,0,0.5);border:1px solid rgba(0,245,255,0.15);border-radius:10px;color:#e0e8ff;font-family:'JetBrains Mono',monospace;font-size:13px;padding:11px 14px;outline:none;transition:border-color 0.3s,box-shadow 0.3s;}
input:focus{border-color:var(--cyan);box-shadow:0 0 18px rgba(0,245,255,0.2);}
input.error{border-color:var(--red)!important;animation:shake 0.4s ease;}
@keyframes shake{0%,100%{transform:translateX(0)}20%{transform:translateX(-6px)}40%{transform:translateX(6px)}60%{transform:translateX(-4px)}80%{transform:translateX(4px)}}
.error-msg{font-size:11px;color:var(--red);margin-top:6px;display:none;}
.error-msg.show{display:block;}

/* UNLOCK BTN */
.btn-unlock{width:100%;margin-top:14px;padding:13px;border:none;border-radius:12px;font-family:'Orbitron',sans-serif;font-size:12px;font-weight:700;letter-spacing:2px;cursor:pointer;background:linear-gradient(135deg,var(--cyan),var(--pink));background-size:200%;color:#fff;animation:gradShift 4s ease infinite;transition:transform 0.2s,box-shadow 0.2s;display:flex;align-items:center;justify-content:center;gap:8px;}
.btn-unlock:hover{transform:translateY(-2px);box-shadow:0 8px 28px rgba(0,245,255,0.3);}
.btn-unlock:disabled{opacity:0.45;cursor:not-allowed;animation:none;}
@keyframes gradShift{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}

/* EDITOR */
.pw-change{margin-top:22px;padding-top:18px;border-top:1px solid rgba(255,255,255,0.08);display:flex;flex-direction:column;gap:12px;}
.pw-change-title{font-size:12px;font-weight:600;color:rgba(255,255,255,0.8);letter-spacing:0.5px;}
.pw-change-sub{font-size:10px;color:rgba(255,255,255,0.3);margin-top:-6px;}
.btn-pw-update{width:100%;background:rgba(0,245,255,0.08);color:var(--cyan,#00f5ff);border:1px solid rgba(0,245,255,0.28);padding:12px 18px;border-radius:10px;font-family:'JetBrains Mono',monospace;font-size:12px;font-weight:600;cursor:pointer;transition:all 0.2s;}
.btn-pw-update:hover{background:rgba(0,245,255,0.16);box-shadow:0 0 16px rgba(0,245,255,0.15);}
.btn-pw-update:active{transform:translateY(1px);}
.btn-pw-update:disabled{opacity:0.5;cursor:not-allowed;}
.hidden{display:none!important;}

/* STATUS */
.status-bar{display:flex;align-items:center;gap:8px;font-size:11px;padding:8px 12px;border-radius:8px;margin-bottom:14px;}
.status-ok{background:rgba(0,255,136,0.06);border:1px solid rgba(0,255,136,0.15);color:var(--green);}
.status-edit{background:rgba(255,204,0,0.06);border:1px solid rgba(255,204,0,0.2);color:var(--yellow);}
.status-dot{width:6px;height:6px;border-radius:50%;flex-shrink:0;animation:blink 1.5s ease-in-out infinite;}
@keyframes blink{0%,100%{opacity:1}50%{opacity:0.3}}
.dot-green{background:var(--green);box-shadow:0 0 8px var(--green);}
.dot-yellow{background:var(--yellow);box-shadow:0 0 8px var(--yellow);}
.unsaved{margin-left:auto;font-size:10px;background:rgba(255,204,0,0.1);color:var(--yellow);padding:2px 8px;border-radius:4px;display:none;}
.unsaved.show{display:inline-block;}

/* TABS */
.tabs{display:flex;gap:4px;background:rgba(0,0,0,0.4);border-radius:10px;padding:3px;margin-bottom:12px;}
.tab{flex:1;padding:8px;border:none;background:transparent;color:rgba(255,255,255,0.35);font-family:'JetBrains Mono',monospace;font-size:11px;letter-spacing:1px;border-radius:7px;cursor:pointer;transition:all 0.2s;text-transform:uppercase;}
.tab.active{background:rgba(0,245,255,0.1);color:var(--cyan);border:1px solid rgba(0,245,255,0.2);}
.tab.edit-tab.active{background:rgba(255,204,0,0.1);color:var(--yellow);border-color:rgba(255,204,0,0.25);}

/* LOADSTRING PANEL */
.ls-panel{background:rgba(0,0,0,0.4);border:1px solid rgba(0,245,255,0.1);border-radius:10px;padding:10px 13px;margin-bottom:12px;}
.ls-label{font-size:10px;letter-spacing:2px;text-transform:uppercase;color:rgba(255,255,255,0.25);margin-bottom:5px;display:flex;align-items:center;gap:6px;}
.ls-value{font-size:11px;color:var(--cyan);word-break:break-all;line-height:1.6;opacity:0.8;cursor:pointer;transition:opacity 0.2s;}
.ls-value:hover{opacity:1;}

/* TEXTAREA */
textarea{width:100%;background:rgba(0,0,0,0.55);border:1px solid rgba(0,245,255,0.13);border-radius:10px;color:var(--green);font-family:'JetBrains Mono',monospace;font-size:12px;padding:13px;outline:none;resize:vertical;min-height:240px;line-height:1.7;transition:border-color 0.3s;}
textarea:focus{border-color:var(--cyan);box-shadow:0 0 16px rgba(0,245,255,0.15);}
textarea.edit-mode{border-color:rgba(255,204,0,0.25)!important;}
textarea.edit-mode:focus{border-color:var(--yellow)!important;box-shadow:0 0 16px rgba(255,204,0,0.15)!important;}
.char-count{text-align:right;font-size:10px;color:rgba(255,255,255,0.2);margin-top:3px;}

/* BUTTON GRIDS */
.btn-grid-4{display:grid;grid-template-columns:1fr 1fr 1fr 1fr;gap:7px;margin-top:10px;}
.btn-grid-2{display:grid;grid-template-columns:1fr 1fr;gap:7px;margin-top:7px;}
.btn-grid-1{margin-top:7px;}
.action-btn{padding:10px 8px;border:none;border-radius:9px;font-family:'JetBrains Mono',monospace;font-size:11px;font-weight:600;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:5px;transition:all 0.2s;white-space:nowrap;}
.btn-copy-code{background:rgba(0,255,136,0.1);color:var(--green);border:1px solid rgba(0,255,136,0.2);}
.btn-copy-code:hover{background:rgba(0,255,136,0.2);}
.btn-copy-ls{background:rgba(0,245,255,0.08);color:var(--cyan);border:1px solid rgba(0,245,255,0.18);}
.btn-copy-ls:hover{background:rgba(0,245,255,0.16);}
.btn-dl-lua{background:rgba(124,58,237,0.1);color:#a78bfa;border:1px solid rgba(124,58,237,0.2);}
.btn-dl-lua:hover{background:rgba(124,58,237,0.2);}
.btn-dl-txt{background:rgba(124,58,237,0.06);color:#c4b5fd;border:1px solid rgba(196,181,253,0.15);}
.btn-dl-txt:hover{background:rgba(124,58,237,0.14);}
.btn-edit-link{background:rgba(255,204,0,0.08);color:var(--yellow);border:1px solid rgba(255,204,0,0.18);}
.btn-edit-link:hover{background:rgba(255,204,0,0.16);}
.btn-delete{background:rgba(255,68,85,0.08);color:var(--red);border:1px solid rgba(255,68,85,0.18);}
.btn-delete:hover{background:rgba(255,68,85,0.18);}
.btn-save-changes{background:rgba(0,245,255,0.1);color:var(--cyan);border:1px solid rgba(0,245,255,0.2);width:100%;padding:12px;margin-top:10px;border-radius:10px;font-family:'Orbitron',sans-serif;font-size:12px;font-weight:700;letter-spacing:1px;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;transition:all 0.2s;}
.btn-save-changes:hover{background:rgba(0,245,255,0.2);}
.btn-cancel{background:rgba(255,255,255,0.04);color:rgba(255,255,255,0.4);border:1px solid rgba(255,255,255,0.1);width:100%;padding:11px;margin-top:7px;border-radius:10px;font-family:'JetBrains Mono',monospace;font-size:12px;cursor:pointer;transition:all 0.2s;}
.btn-cancel:hover{background:rgba(255,255,255,0.08);}

/* TOAST */
.toast{position:fixed;bottom:24px;right:24px;padding:12px 18px;border-radius:10px;font-size:12px;font-weight:600;z-index:9999;animation:toastIn 0.3s ease;pointer-events:none;display:flex;align-items:center;gap:8px;}
.toast-ok{background:rgba(0,255,136,0.12);border:1px solid rgba(0,255,136,0.35);color:var(--green);}
.toast-err{background:rgba(255,68,85,0.12);border:1px solid rgba(255,68,85,0.35);color:var(--red);}
@keyframes toastIn{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}

/* DELETE MODAL */
.modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,0.85);backdrop-filter:blur(8px);z-index:999;display:flex;align-items:center;justify-content:center;padding:20px;}
.modal-overlay.hidden{display:none!important;}
.modal{background:var(--card);border:1px solid rgba(255,68,85,0.3);border-radius:18px;padding:28px;max-width:360px;width:100%;position:relative;animation:popIn 0.25s cubic-bezier(0.175,0.885,0.32,1.275);}
@keyframes popIn{from{transform:scale(0.85);opacity:0}to{transform:scale(1);opacity:1}}
.modal::before{content:'';position:absolute;top:0;left:0;right:0;height:1px;background:linear-gradient(90deg,transparent,var(--red),transparent);}
.modal-icon{text-align:center;margin-bottom:10px;}
.modal-title{font-family:'Orbitron',sans-serif;font-size:15px;font-weight:900;text-align:center;color:var(--red);margin-bottom:8px;letter-spacing:2px;}
.modal-sub{font-size:12px;color:rgba(255,255,255,0.4);text-align:center;line-height:1.7;margin-bottom:16px;}
.modal-btns{display:flex;gap:10px;}
.modal-btn{flex:1;padding:11px;border-radius:9px;font-family:'JetBrains Mono',monospace;font-size:12px;font-weight:600;cursor:pointer;border:none;transition:all 0.2s;}
.modal-cancel-btn{background:rgba(255,255,255,0.06);color:rgba(255,255,255,0.5);}
.modal-cancel-btn:hover{background:rgba(255,255,255,0.12);}
.modal-confirm-btn{background:rgba(255,68,85,0.15);color:var(--red);border:1px solid rgba(255,68,85,0.3)!important;}
.modal-confirm-btn:hover{background:rgba(255,68,85,0.3);}

/* SPINNER */
.spinner{display:inline-block;width:13px;height:13px;border:2px solid rgba(255,255,255,0.2);border-top-color:#fff;border-radius:50%;animation:spin 0.6s linear infinite;}
@keyframes spin{to{transform:rotate(360deg)}}

.home-link{text-align:center;margin-top:12px;}
.home-link a{font-size:11px;color:rgba(255,255,255,0.28);text-decoration:none;display:inline-flex;align-items:center;gap:5px;transition:color 0.2s;}
.home-link a:hover{color:var(--cyan);}

.upload-btn{display:inline-flex;align-items:center;gap:7px;padding:8px 14px;border-radius:8px;border:1px solid rgba(0,245,255,0.2);background:rgba(0,245,255,0.07);color:var(--cyan);font-family:'JetBrains Mono',monospace;font-size:11px;font-weight:600;cursor:pointer;transition:all 0.2s;margin-top:8px;}
.upload-btn:hover{background:rgba(0,245,255,0.15);border-color:rgba(0,245,255,0.4);}
.upload-btn input[type=file]{display:none;}
.file-name-label{font-size:11px;color:rgba(255,255,255,0.3);margin-top:5px;margin-left:2px;}

.pw-wrap{position:relative;width:100%;}
.pw-wrap input{padding-right:46px !important;}
.pw-toggle{position:absolute;right:6px;top:50%;transform:translateY(-50%);width:34px;height:34px;display:flex;align-items:center;justify-content:center;background:none;border:none;border-radius:8px;color:rgba(255,255,255,0.45);cursor:pointer;padding:0;transition:color .2s,background .2s;}
.pw-toggle:hover{color:var(--cyan,#00f5ff);background:rgba(0,245,255,0.08);}
.pw-toggle:focus-visible{outline:2px solid var(--cyan,#00f5ff);outline-offset:1px;}
.pw-toggle svg{width:18px;height:18px;display:block;}
.editor-pw-row .pw-wrap{flex:1;}
</style>
</head>
<body>
<div class="orb orb1"></div>
<div class="orb orb2"></div>

<!-- DELETE MODAL -->
<div class="modal-overlay hidden" id="deleteModal">
  <div class="modal">
    <div class="modal-icon" style="text-align:center;margin-bottom:10px;"><svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color:var(--red)"><path d="M10 11v6"/><path d="M14 11v6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></div>
    <div class="modal-title">Delete Script?</div>
    <div class="modal-sub">This permanently deletes the script and its loadstring. Anyone using it will get an error. This <strong style="color:#e0e8ff">cannot be undone</strong>.</div>
    <div class="modal-btns">
      <button class="modal-btn modal-cancel-btn" onclick="closeDeleteModal()">Cancel</button>
      <button class="modal-btn modal-confirm-btn" id="confirmDeleteBtn" onclick="confirmDelete()">
        <span id="deleteLabel">Delete Forever</span>
      </button>
    </div>
  </div>
</div>

<div class="wrap">
  <!-- Brand -->
  <div class="brand">
    <span class="brand-text">ObfuscatorHub</span>
  </div>

  <div class="card">
    <div class="corner tl"></div><div class="corner tr"></div>
    <div class="corner bl"></div><div class="corner br"></div>

    <!-- ── CHECKING SCREEN (owner auto-unlock probe) ── -->
    <div id="checkingScreen" style="text-align:center;padding:34px 0;">
      <span class="spinner"></span>
      <div style="margin-top:12px;color:#8891a8;font-size:12px;letter-spacing:1px;">Checking access...</div>
    </div>

    <!-- ── LOCK SCREEN ── -->
    <div id="lockScreen" class="hidden">
      <div class="lock-icon" style="text-align:center;margin-bottom:12px;"><svg xmlns="http://www.w3.org/2000/svg" width="42" height="42" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color:var(--cyan)"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
      <div class="card-title">Protected Script</div>
      <div class="card-sub">Enter password to access</div>
      <div class="field-label">// Password</div>
      <div class="pw-wrap"><input type="password" id="password" placeholder="Enter script password..."><button type="button" class="pw-toggle" onclick="togglePwVisibility(this)" aria-label="Show password" title="Show password"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-eye preview-icon"><path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/></svg></button></div>
      <div class="error-msg" id="pwError">Wrong password. Try again.</div>
      <button class="btn-unlock" id="unlockBtn" onclick="unlock()">
        Unlock Script
      </button>
    </div>

    <!-- ── EDITOR ── -->
    <div id="editor" class="hidden">

      <div class="status-bar status-ok" id="statusBar">
        <div class="status-dot dot-green"></div>
        <span id="statusText">Script unlocked</span>
        <span class="unsaved" id="unsavedBadge">● Unsaved</span>
      </div>

      <!-- Loadstring -->
      <div class="ls-panel" onclick="copyLoadstring()" title="Click to copy loadstring">
        <div class="ls-label">
          Loadstring — click to copy
        </div>
        <div class="ls-value" id="lsValue">—</div>
      </div>

      <!-- Tabs -->
      <div class="tabs">
        <button class="tab active" id="tabView" onclick="setMode('view')">
          View
        </button>
        <button class="tab edit-tab" id="tabEdit" onclick="setMode('edit')">
          Edit
        </button>
      </div>

      <!-- Code area -->
      <textarea id="code" data-lua-highlight spellcheck="false" readonly placeholder="Loading..."></textarea>
      <div class="char-count"><span id="charCount">0</span> chars</div>

      <!-- VIEW MODE buttons -->
      <div id="viewBtns">
        <div class="btn-grid-4">
          <button class="action-btn btn-copy-code" onclick="copyCode()">
            Copy
          </button>
          <button class="action-btn btn-copy-ls" onclick="copyLoadstring()">
            Copy LS
          </button>
          <button class="action-btn btn-dl-lua" onclick="downloadLua()">
            .lua
          </button>
          <button class="action-btn btn-dl-txt" onclick="downloadTxt()">
            .txt
          </button>
        </div>
        <div class="btn-grid-2">
          <button class="action-btn btn-edit-link" onclick="copyEditLink()">
            Copy Edit Link
          </button>
          <button class="action-btn btn-delete" onclick="openDeleteModal()">
            Delete Script
          </button>
        </div>
      </div>

      <!-- EDIT MODE buttons -->
      <div id="editBtns" class="hidden">
        <button class="btn-save-changes" id="saveBtn" onclick="saveCode()">
          Save Changes
        </button>
        <button class="btn-cancel" onclick="cancelEdit()">Cancel — Discard Changes</button>
        <div class="btn-grid-2" style="margin-top:7px;">
          <button class="action-btn btn-dl-lua" onclick="downloadLua()">
            Download .lua
          </button>
          <button class="action-btn btn-delete" onclick="openDeleteModal()">
            Delete Script
          </button>
        </div>
      </div>


      <!-- CHANGE PASSWORD -->
      <div class="pw-change">
        <div class="pw-change-title">Change password</div>
        <div class="pw-change-sub">New password must be 5-20 characters.</div>
        <div class="pw-wrap"><input type="password" id="newPassword" placeholder="New password..." minlength="5" maxlength="20" autocomplete="new-password"><button type="button" class="pw-toggle" onclick="togglePwVisibility(this)" aria-label="Show password" title="Show password"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-eye preview-icon"><path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/></svg></button></div>
        <button class="btn-pw-update" id="pwUpdateBtn" onclick="changePassword()">Update password</button>
      </div>

    </div><!-- end editor -->
  </div><!-- end card -->

  <div class="home-link">
    <a href="/">
      Back to Home
    </a>
  </div>
</div>

<script>
const PW_EYE = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-eye preview-icon"><path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/></svg>';
const PW_EYE_OFF = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-eye-off preview-icon"><path d="M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49"/><path d="M14.084 14.158a3 3 0 0 1-4.242-4.242"/><path d="M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143"/><path d="m2 2 20 20"/></svg>';
const PW_TOGGLE_BTN = '<button type="button" class="pw-toggle" onclick="togglePwVisibility(this)" aria-label="Show password" title="Show password">' + PW_EYE + '</button>';
function togglePwVisibility(btn) {
  const input = btn.parentElement.querySelector("input");
  if (!input) return;
  const reveal = input.type === "password";
  input.type = reveal ? "text" : "password";
  btn.innerHTML = reveal ? PW_EYE_OFF : PW_EYE;
  const label = reveal ? "Hide password" : "Show password";
  btn.setAttribute("aria-label", label);
  btn.title = label;
}
const scriptId = location.pathname.split("/").pop();
fetch("/api/script-bg/" + encodeURIComponent(scriptId)).then(r => r.json()).then(d => {
  if (d && d.bgUrl) {
    const b = document.body.style;
    b.backgroundImage = 'linear-gradient(rgba(0,0,0,0.45),rgba(0,0,0,0.45)), url("' + d.bgUrl + '")';
    b.backgroundSize = "cover"; b.backgroundPosition = "center"; b.backgroundAttachment = "fixed";
  }
}).catch(() => {});
const params   = new URLSearchParams(location.search);
const directEdit = params.get("edit") === "1";
let originalCode = "";
let currentMode  = "view";

// ── TOAST ─────────────────────────────────────────────────────────────────────
function toast(msg, ok) {
  const t = document.createElement("div");
  t.className = "toast " + (ok !== false ? "toast-ok" : "toast-err");
  t.innerHTML = (ok !== false
    ? ''
    : '')
    + msg;
  document.body.appendChild(t);
  setTimeout(() => t.remove(), 2800);
}

// ── SHARED: apply an unlocked response (used by both the silent owner
// auto-probe on load and the manual password unlock button) ─────────────────
function applyUnlockedState(data) {
  originalCode = data.code;
  document.getElementById("checkingScreen").classList.add("hidden");
  document.getElementById("lockScreen").classList.add("hidden");
  document.getElementById("editor").classList.remove("hidden");
  document.getElementById("code").value = data.code;
  if (window.LuaHighlight) {
    if (!window._hlCode) window._hlCode = window.LuaHighlight.init("code");
    window._hlCode.update();
  }
  document.getElementById("charCount").textContent = data.code.length.toLocaleString();
  document.getElementById("lsValue").textContent = 'loadstring(game:HttpGet("https://' + location.host + '/api/' + scriptId + '"))()';
  if (directEdit) setTimeout(() => setMode("edit"), 300);
}

// ── OWNER AUTO-PROBE ──────────────────────────────────────────────────────────
// Runs once on page load, before the password screen ever shows. /unlock now
// skips the password check entirely for a logged-in owner (see index.js) —
// this silently tries that with no password. If it succeeds, the owner goes
// straight to the editor and never sees a password prompt for their own
// script. If it fails (wrong owner, not logged in, script needs a real
// password), the normal lock screen appears exactly as before.
(async function attemptOwnerAutoUnlock() {
  try {
    const res  = await fetch("/unlock", { method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify({ id: scriptId }) });
    const data = await res.json();
    if (data.ok) { applyUnlockedState(data); return; }
    if (data.gone) { location.reload(); return; }
  } catch {
    // network error on the silent probe — fall through to showing the
    // normal password screen, same as "not the owner"
  }
  document.getElementById("checkingScreen").classList.add("hidden");
  document.getElementById("lockScreen").classList.remove("hidden");
})();

// ── UNLOCK ────────────────────────────────────────────────────────────────────
async function unlock() {
  const pw  = document.getElementById("password").value.trim();
  const btn = document.getElementById("unlockBtn");
  const inp = document.getElementById("password");
  const err = document.getElementById("pwError");
  if (!pw) { inp.classList.add("error"); setTimeout(() => inp.classList.remove("error"), 500); return; }
  btn.disabled = true;
  btn.innerHTML = '<span class="spinner"></span> Unlocking...';
  err.classList.remove("show");
  try {
    const res  = await fetch("/unlock", { method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify({ id: scriptId, password: pw }) });
    const data = await res.json();
    if (data.gone) { location.reload(); return; }
    if (!data.ok) {
      // storageError means the password was right but the script's storage
      // (Rubis/GitHub) couldn't be reached — showing "Wrong password" for
      // that is actively misleading, so it gets its own message instead.
      if (data.storageError) {
        err.textContent = data.error || "Could not load this script right now. Try again in a minute.";
        err.classList.add("show");
        btn.disabled = false;
        btn.innerHTML = 'Unlock Script';
        return;
      }
      err.textContent = "Wrong password. Try again.";
      inp.classList.add("error");
      err.classList.add("show");
      setTimeout(() => inp.classList.remove("error"), 500);
      btn.disabled = false;
      btn.innerHTML = 'Unlock Script';
      return;
    }
    applyUnlockedState(data);
  } catch {
    toast("Network error. Try again.", false);
    btn.disabled = false;
    btn.innerHTML = 'Unlock Script';
  }
}
document.getElementById("password").addEventListener("keydown", e => { if (e.key === "Enter") unlock(); });

// ── MODE ──────────────────────────────────────────────────────────────────────
function setMode(mode) {
  currentMode = mode;
  const ta    = document.getElementById("code");
  const sb    = document.getElementById("statusBar");
  const st    = document.getElementById("statusText");
  if (mode === "view") {
    ta.readOnly = true; ta.classList.remove("edit-mode");
    document.getElementById("tabView").classList.add("active");
    document.getElementById("tabEdit").classList.remove("active");
    document.getElementById("viewBtns").classList.remove("hidden");
    document.getElementById("editBtns").classList.add("hidden");
    sb.className = "status-bar status-ok";
    sb.querySelector(".status-dot").className = "status-dot dot-green";
    st.textContent = "Script unlocked";
    document.getElementById("unsavedBadge").classList.remove("show");
  } else {
    ta.readOnly = false; ta.classList.add("edit-mode");
    document.getElementById("tabView").classList.remove("active");
    document.getElementById("tabEdit").classList.add("active");
    document.getElementById("viewBtns").classList.add("hidden");
    document.getElementById("editBtns").classList.remove("hidden");
    sb.className = "status-bar status-edit";
    sb.querySelector(".status-dot").className = "status-dot dot-yellow";
    st.textContent = "Edit mode";
    ta.focus();
  }
}

document.getElementById("code").addEventListener("input", function() {
  document.getElementById("charCount").textContent = this.value.length.toLocaleString();
  if (currentMode === "edit") {
    document.getElementById("unsavedBadge").classList.toggle("show", this.value !== originalCode);
    document.getElementById("statusText").textContent = this.value !== originalCode ? "Unsaved changes" : "Edit mode";
  }
});

// ── SAVE ──────────────────────────────────────────────────────────────────────
async function saveCode() {
  const pw   = document.getElementById("password").value;
  const code = document.getElementById("code").value;
  const btn  = document.getElementById("saveBtn");
  btn.disabled = true;
  btn.innerHTML = '<span class="spinner"></span> Saving...';
  try {
    const res  = await fetch("/api/save", { method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify({ id: scriptId, password: pw, code }) });
    const data = await res.json();
    if (data.ok) {
      originalCode = code;
      document.getElementById("unsavedBadge").classList.remove("show");
      document.getElementById("statusText").textContent = "Saved!";
      toast("Script saved successfully", true);
      btn.innerHTML = 'Saved!';
      setTimeout(() => {
        btn.disabled = false;
        btn.innerHTML = 'Save Changes';
        document.getElementById("statusText").textContent = "Edit mode";
      }, 2000);
    } else {
      toast("Save failed — wrong password?", false);
      btn.disabled = false;
      btn.innerHTML = 'Save Changes';
    }
  } catch {
    toast("Network error", false);
    btn.disabled = false;
  }
}

function cancelEdit() {
  if (document.getElementById("code").value !== originalCode) {
    if (!confirm("Discard unsaved changes?")) return;
    document.getElementById("code").value = originalCode;
    document.getElementById("charCount").textContent = originalCode.length.toLocaleString();
  }
  setMode("view");
}

window.addEventListener("beforeunload", e => {
  if (currentMode === "edit" && document.getElementById("code").value !== originalCode) {
    e.preventDefault(); e.returnValue = "";
  }
});

// ── COPY / DOWNLOAD ───────────────────────────────────────────────────────────
function copyCode() {
  navigator.clipboard.writeText(document.getElementById("code").value);
  toast("Source code copied!", true);
}
function copyLoadstring() {
  navigator.clipboard.writeText(document.getElementById("lsValue").textContent);
  toast("Loadstring copied!", true);
}
function copyEditLink() {
  navigator.clipboard.writeText(location.origin + "/" + scriptId + "?edit=1");
  toast("Edit link copied!", true);
}
function downloadLua() { triggerDownload(document.getElementById("code").value, "script_" + scriptId + ".lua"); }
function downloadTxt() { triggerDownload(document.getElementById("code").value, "script_" + scriptId + ".txt"); }
function triggerDownload(content, filename) {
  const a = document.createElement("a");
  a.href = URL.createObjectURL(new Blob([content], {type:"text/plain"}));
  a.download = filename;
  document.body.appendChild(a); a.click(); document.body.removeChild(a);
  toast("Downloaded " + filename, true);
}

// -- CHANGE PASSWORD -----------------------------------------------------------
async function changePassword() {
  const newPw = document.getElementById("newPassword").value;
  const curPw = document.getElementById("password").value;
  const btn   = document.getElementById("pwUpdateBtn");
  if (newPw.length < 5 || newPw.length > 20 || newPw.trim().length < 5) {
    toast("New password must be 5-20 characters", false);
    return;
  }
  btn.disabled = true;
  btn.innerHTML = '<span class="spinner"></span> Updating...';
  try {
    const res = await fetch("/api/change-password", { method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify({ id: scriptId, newPassword: newPw, password: curPw }) });
    let data;
    try { data = await res.json(); } catch { data = { ok: false, error: "Unexpected server response (HTTP " + res.status + ")" }; }
    if (data.ok) {
      document.getElementById("password").value = newPw;
      document.getElementById("newPassword").value = "";
      toast("Password updated", true);
    } else {
      toast(data.error || "Could not update password", false);
    }
  } catch {
    toast("Network error. Try again.", false);
  }
  btn.disabled = false;
  btn.textContent = "Update password";
}

// ── DELETE ────────────────────────────────────────────────────────────────────
function openDeleteModal() { document.getElementById("deleteModal").classList.remove("hidden"); }
function closeDeleteModal() { document.getElementById("deleteModal").classList.add("hidden"); }

async function confirmDelete() {
  const pw  = document.getElementById("password").value;
  const btn = document.getElementById("confirmDeleteBtn");
  btn.disabled = true;
  document.getElementById("deleteLabel").innerHTML = '<span class="spinner"></span>';
  try {
    const res  = await fetch("/api/delete", { method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify({ id: scriptId, password: pw }) });
    const data = await res.json();
    if (data.ok) {
      window.onbeforeunload = null;
      window.location.href = "/";
    } else {
      toast("Delete failed — wrong password", false);
      btn.disabled = false;
      document.getElementById("deleteLabel").textContent = "Delete Forever";
    }
  } catch {
    toast("Network error", false);
    btn.disabled = false;
    document.getElementById("deleteLabel").textContent = "Delete Forever";
  }
}

document.getElementById("deleteModal").addEventListener("click", function(e) { if (e.target === this) closeDeleteModal(); });
document.addEventListener("keydown", e => { if (e.key === "Escape") closeDeleteModal(); });

function handleFileUpload_code(input) {
  var file = input.files[0];
  if (!file) return;
  var reader = new FileReader();
  reader.onload = function(e) {
    var ta = document.getElementById("code");
    if (!ta) return;
    // Set value and remove any limit
    ta.removeAttribute("maxlength");
    ta.value = e.target.result;
    // Trigger input event so char counter + highlighter both update
    ta.dispatchEvent(new Event("input", { bubbles: true }));
    // Update file label
    var label = document.getElementById("file-label-code");
    if (label) label.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:4px"><path d="M20 6 9 17l-5-5"/></svg>' + file.name + " (" + (file.size > 1024 ? (file.size/1024).toFixed(1) + " KB" : file.size + " B") + ")";
    // Init or update highlighter
    if (window.LuaHighlight) {
      if (!window._hlCode) window._hlCode = window.LuaHighlight.init("code");
      window._hlCode.update();
    }
    // Scroll textarea to top
    ta.scrollTop = 0;
  };
  reader.readAsText(file);
}

</script>
</body>
</html>
