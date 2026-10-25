<!DOCTYPE html>
<html lang="en">
	<head>
		<title>LuaU Obfuscator - WeAreDevs</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="keywords" content="wearedevs, obfuscator, lua obfuscator, obfuscation" />
        <meta name="description" content="Protect your Lua script with obfuscation, making it harder to read and reverse-engineer." />
		<!-- Open Graph Metadata -->
		<meta property="og:image" content="https://wearedevs.net/images/logo.png">
		<meta property="og:image:width" content="150">
		<meta property="og:image:height" content="150">
		<meta property="og:title" content="LuaU Obfuscator - WeAreDevs">
		<meta property="og:description" content="Protect your Lua script with obfuscation, making it harder to read and reverse-engineer.">
		<meta property="og:url" content="https://wearedevs.net/obfuscator">
		<meta property="og:type" content="website">
		
		<link rel="shortcut icon" href="/favicon.ico" />
<link href="/css/main.css?v=27&v2=17" rel="stylesheet" type="text/css">
<link href="/css/themes/night.css?v=27&v2=7" rel="stylesheet" type="text/css">
<link href="/css/navheader.css?v=27&v2=11" rel="stylesheet" type="text/css">
<link href="/css/roles.css?v=27&v2=4" rel="stylesheet" type="text/css">
<link rel="manifest" href="/manifest.json?v2=2" />
<link rel="canonical" href="https://wearedevs.net/obfuscator" /> 

<script type="text/javascript" src="/js/timestamp.js?v=27&v2=4"></script>
<script type="text/javascript" src="/js/utils.js?v=27&v2=3"></script>
<script type="text/javascript" src="/js/oembed.js?v=27&v2=28"></script>

<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-46VWDGRLXJ"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-46VWDGRLXJ');
</script>
		<link href="/css/obfuscator.css?v=27&v2=3" rel="stylesheet" type="text/css">

		 <!-- CodeMirror CSS -->
		 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.13/codemirror.min.css">
		 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.13/theme/monokai.min.css">	 
		 <style>
			 .CodeMirror {
				 height: 400px;
				 border: 1px solid #ccc;
			 }
		 </style>

		 <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-9142841210062390"crossorigin="anonymous"></script>
	</head>
	<body class="container">
		<header id="navigationbar" class="border1-bottom theme-bg-weak">
    <span class="menu-toggle "></span>
    <ul class="navItems">
        <li class='navItem'><a id="foologo" href="/library" title="WeAreDevs"><span id="navlogo"></span>WeAreDevs</a></li>
        <li class='navItem'><a href="/library" title="Featured releases page">Exploits</a></li>
        <li class='navItem navHeader_dropmenu'>
            <a href="/scripts" title="Featured scripts page">Scripts</a>
            <div class="menu round border1">
                <a href='/scripts'>Search</a>
                <a href='/scripts/upload'>Upload</a>
                <a href="/forum/t/37448">API</a>
            </div>
        </li>
        <li class='navItem'><a href="/obfuscator" title="Protect your LuaU scripts">Lua Obfuscator</a></li>
        

        <li class='navItem'><a title="Alternative contact with the community" href="https://wearedevs.net/discord" class="icon discord"></a></li>
        <li class='navItem'><a title="Visual demonstration of our exploits" href="https://www.youtube.com/@WeAreDevsExploits" class="icon youtube"></a></li>
        
        <li class='navItem' style="margin-left: auto;"><a href="/login">Login</a></li>
        
    </ul>
	
	<script>
        //Used to send logout request to API
		function logout(){
            if(!confirm("You are about to logout")) return

            fetch('/api/account/logout', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
            })
            .then(res => res.json())
            .then(res => {
                if(res.success || res?.reason == "Already logged out") window.location.reload()
                else {
                    if(res.reason) alert("Error: " + res.reason)
                    else alert("An unexpected error occured...")
                }
            })
            .catch(()=>alert("Failed to contact the server or an unexpected response was received..."))
        }

        async function DeleteNotifications(options){
            //Plainly received the notification document id
            let documentID = options
            let notificationElement = document.querySelector(`.notification[data-id="${documentID}"]`)
            
            //Requests API to delete notification from server database
            await fetch('/api/notifications', {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    id: documentID
                })
            })
            .then(res => res.json())

            // UI management
            //Only deleted one notification
            if(documentID) {
                let notificationsContainer = document.querySelector('.notifications')
                var numNotifs = notificationsContainer.childElementCount
                document.querySelector(".notifcount").innerHTML = numNotifs - 1
                if(numNotifs <= 1){
                    notificationsContainer.innerHTML = "No notifications"
                    document.querySelector(".notifcount").remove()
                    document.querySelector(".deleteallnotifs").remove()
                    document.querySelector(".menu-toggle-notif").classList.remove("menu-toggle-notif")
                }
                notificationElement.remove()
            }
            //The server will default to delete everything because there is no specified id
            else {
                document.getElementsByClassName("notifications")[0].innerHTML = "<p>No notifications...</p>"
                document.getElementsByClassName("notifcount")[0].style.display = "none"
                document.getElementsByClassName("menu-toggle-notif")[0].classList.remove("menu-toggle-notif")
                document.querySelector('.deleteallnotifs').style.display = 'none'
            }
        }
        
        // Listen to all clicks on the document
        document.addEventListener('click', function (event) {
            if (event.target.classList.contains('message-notif')){
                var parent = event.target.parentElement.parentElement
                var id = parent.getAttribute("data-id")

                DeleteNotifications(id)
            }
            //Navigation options display toggle (Mobile view)
            else if(event.target.classList.contains('menu-toggle')){
                if(document.getElementsByClassName("navItems")[0].style.display !== "flex"){
                    document.getElementsByClassName("navItems")[0].style.display = "flex"
                    document.getElementsByClassName("menu-toggle-notif")[0].classList.remove("menu-toggle-notif")
                }
                else {
                    document.getElementsByClassName("navItems")[0].style.display = "none"
                    if(document.getElementsByClassName("notification").length > 0) 
                        document.getElementsByClassName("menu-toggle")[0].classList.add("menu-toggle-notif")
                }
            }
            //Drop-menu toggle
            else if(event.target.classList.contains('dropmenu-title')){
                if(event.target.parentElement.getElementsByClassName("menu")[0].style.display !== "block"){
                    event.target.parentElement.getElementsByClassName("menu")[0].style.display = "block"
                }
                else event.target.parentElement.getElementsByClassName("menu")[0].style.display = "none"

                event.target.parentElement.onmouseleave = () => event.target.parentElement.getElementsByClassName("menu")[0].style.display = "none"
            } 
        })
    </script>
</header>
		<div class="wrapper">
			<div class="ad">
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-9142841210062390"
data-ad-slot="8260216639"
data-ad-format="auto"
data-full-width-responsive="true"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
			<main class="padding">
				<section class="gapchildren">
					<h1>LuaU Obfuscator</h1>
					<p>Built to protect Roblox Lua scripts</p>
					<textarea id="lua-editor"></textarea>
					<textarea id="lua-output"></textarea>
					<p class="status"></p>
					<button class="btn-obfuscate border1 round padding button">Obfuscate</button>
					<div class="verticalCenter btns-output">
						<button class="btn-copy border1 round padding button" onclick="copyScript()">Copy</button>
						<button class="btn-downloadscript border1 round padding button" onclick="downloadScript()">Download</button>
						<button class="btn-newscript border1 round padding button" onclick="newScript()">New Script</button>
					</div>
				</section>
				<section class="gapchildren">
					<h2>What is an obfuscator?</h2>
					<p>
						This tool allows you to obfuscate your code, making it harder for others to read and reverse-engineer. 
						By transforming your source code into a more complex and unreadable format, you can help protect your 
						intellectual property while maintaining functionality. Perfect for developers looking to add an extra 
						layer of security to their scripts.
					</p>
					<img src="/images/obfuscator/obfuscation-demo.webp"/>
				</section>
				<section class="gapchildren">
					<h2>Why use an obfuscator?</h2>
					<ul>
						<li><strong>Code Security</strong> – Prevents reverse engineering and unauthorized modifications.</li>
						<li><strong>Intellectual Property Protection</strong> – Safeguards proprietary algorithms and business logic.</li>
						<li><strong>Anti-Tampering</strong> – Makes it harder for attackers to modify or exploit your software.</li>
						<li><strong>Reduced Readability</strong> – Converts code into an obscure format while keeping it functional.</li>
						<li><strong>License Enforcement</strong> – Helps deter unauthorized use of software by making it difficult to bypass restrictions.</li>
					</ul>
					<p>
						If you're distributing your software and want to maintain control over its integrity, using an obfuscator is a smart choice.
					</p>
				</section>
				<section class="gapchildren">
					<h2>Is this safe to use?</h2>
					<p>
						Yes, this obfuscator is designed to transform your code without altering its functionality. It does not 
						store, transmit, or share your code in any way. Everything happens securely 
						on the server, ensuring your code remains private and protected.
					</p>
					<p>
						However, obfuscation is not a foolproof security measure. While it makes code harder to read and modify, 
						determined attackers may still attempt to deobfuscate it. For sensitive applications, consider combining 
						obfuscation with other security practices such as encryption and proper access controls.
					</p>
					<div class="lessgapchildren">
						<p>The obfuscation process is handled securely using Prometheus Lua Obfuscator, a widely trusted open-source obfuscation tool. Prometheus is licensed under a modified version of the MIT license. Ensuring transparency and security in its implementation, we have not modified its source code, but use it as a backend tool for obfuscation.</p>
						<p>Based on Prometheus by Elias Oelschner, <a href="https://github.com/wcrddn/Prometheus/tree/master" target="_blank" class="link" title="Fork linked for transparency of the exact source and license used">https://github.com/prometheus-lua/Prometheus</a></p>
						<p>For more information about the license, visit: ➡ <a href="https://github.com/prometheus-lua/Prometheus/blob/a4efc5f381c50ae2a111bdbb9272fa3203685be3/LICENSE" class="link">Prometheus License</a></p>
					</div>
				</section>
				<section class="gapchildren">
					<h2>Whats the cost?</h2>
					<p>This is a completely free Lua obfuscator. No hidden fees, no premium features, no limitations. No catch at all! We're happy enough that you're here.</p>
				</section>
			</main>
			<div class="ad">
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-9142841210062390"
data-ad-slot="8260216639"
data-ad-format="auto"
data-full-width-responsive="true"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
		</div>
		<footer>
	<ul class="footerlinks">
		<li><a href="/terms-of-service" title="Terms of Service">Terms of Use</a></li>
		<li><a href="/privacy" title="Privacy Policy">Privacy</a></li>
		<li><a href="/guidelines">Guidelines</a></li>
		<li class="footer-notifs"><span class="pointer" onclick="subNotifications()">Notifications</span></li>
		<li><a href="/faq">FAQ</a></li>
		<li><a href="/forum">Forum</a></li>
		<li><a href="/home#submission">Exploit Submission</a></li>
	</ul>
	<br/>
	<br/>
	<p>© <script>document.write(new Date().getFullYear())</script> WeAreDevs</p>
</footer>

<!-- Push notifications setup -->
<script>
	var registration = null

	const canPrompt = () => Notification.permission === "default" && (!localStorage.getItem("notifsLastPrompted") || (Date.now() - +localStorage.getItem("notifsLastPrompted")) / 864e5 > 7)

	//Notifications are blocked
	if (!canPrompt()) document.querySelector(".footer-notifs").remove()
	
	function urlBase64ToUint8Array(base64String) {
		const padding = '='.repeat((4 - base64String.length % 4) % 4);
		const base64 = (base64String + padding)
			.replace(/\-/g, '+')
			.replace(/_/g, '/')
		;
		const rawData = window.atob(base64);
		return Uint8Array.from([...rawData].map((char) => char.charCodeAt(0)));
	}
	
	function subNotifications() {
		//Check if push manager is supported on this browser
		if (!(registration && ('PushManager' in window))) return

		if (!canPrompt()) return

		//Only request once a week (Prevent browsers from blocking this site)
		localStorage.setItem("notifsLastPrompted", Date.now().toString())

		Notification.requestPermission()
		.then(async function(permissionResult) {
			if (permissionResult === 'granted') {
				//Notifications are enabled
				//Create subscription
				const subscribeOptions = {
					userVisibleOnly: true,
					applicationServerKey: urlBase64ToUint8Array(
						'BGyra8TIIln-swj30Hi4ZulNFcTe_EcmhqhIs0W1gMQv6ufiEorqnE-KvcgIO6kIfia6Jq0XYdHGv10jUdhiEko'
					)
				};

				let pushSubscription = await registration.pushManager.subscribe(subscribeOptions)
				if(!pushSubscription) throw new Error('Failed to subscribe')

				fetch('/api/notifications/subscribe', {
					method: "POST",
					headers: {
						"Content-Type": "application/json"
					},
					body: JSON.stringify(pushSubscription)
				})
				.then(res => res.json())
				.then(res => {
					if(!res.success) {
						if(res.reason) alert("Error: " + res.reason)
						else alert("An unexpected error occured...")
					}
				})
				.catch(()=>alert("Failed to contact the server or an unexpected response was received..."))
			}
			else {
				throw new Error('We weren\'t granted permission.');
			}
		})
	}
	
	//Register the service worker for notification display
	if ('serviceWorker' in navigator) { 
		//Service worker is supported on this browser
		
		//Register the service worker
		navigator.serviceWorker.register('/js/service-worker.js?cb=2')
		.then(function(_registration) {
			console.log('Service worker successfully registered.');
			
			registration = _registration
		})
		.catch(function(err) {
			console.warn('Unable to register service worker.', err);
		});
	}
</script>

		<!-- CodeMirror JS -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.13/codemirror.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.13/mode/lua/lua.min.js"></script>
	
		<script>
			const editor = CodeMirror.fromTextArea(document.getElementById("lua-editor"), {
				mode: "lua",
				theme: "monokai",
				lineNumbers: true,
				indentUnit: 4,
				tabSize: 4,
				lineWrapping: true
			});
			editor.setSize(null, "275px");

			const output = CodeMirror.fromTextArea(document.getElementById("lua-output"), {
				mode: "lua",
				theme: "monokai",
				lineNumbers: true,
				indentUnit: 4,
				tabSize: 4,
				lineWrapping: true
			});
			output.getWrapperElement().style.display = "none"

			const textarea = document.querySelector("textarea")
			const button = document.querySelector(".btn-obfuscate")

			button.addEventListener("click", () => {
				let text = editor.getValue()
				if (text.length < 1) return showStatus("Please enter some text to obfuscate", {color: "var(--red)"})
				button.style.display = "none"; // Show the obfuscate button again
				showStatus("Obfuscating your script, please wait...")
				fetch("/api/obfuscate", {
					method: "POST",
					headers: { "Content-Type": "application/json" },
					body: JSON.stringify({ script: text })
				})
				.then(res => res.json())
				.then(data => {
					if (data.error) throw data.error
					output.getWrapperElement().style.display = "block"
					output.setValue(data.obfuscated)
					showStatus("Obfuscation complete! You can now copy or download your script", {color: "var(--green)"})
					button.style.display = "none"
					document.querySelector(".btns-output").style.display = "flex"
				})
				.catch(e => {
					showStatus(typeof e === "string" ? e : "An error occurred while obfuscating your script. Please try again later", {color: "var(--red)"})
					button.style.display = "block"; // Show the obfuscate button again
				})
			})

			function copyScript() {
				const script = output.getValue();
				navigator.clipboard.writeText(script).then(() => {
					showStatus("Script copied to clipboard!", {autoclear: true}); // Show status message
				})
			}

			function downloadScript(){
				const script = output.getValue();
				if (!script || script.length === 0) return alert("No script to download!")
				const blob = new Blob([script], { type: "text/plain;charset=utf-8" });
				const url = URL.createObjectURL(blob);
				const a = document.createElement("a");
				a.href = url;
				a.download = `obfuscated_script-${Date.now()}.lua`; // Default filename
				document.body.appendChild(a);
				a.click();
				document.body.removeChild(a);
				URL.revokeObjectURL(url); // Clean up the URL object
			}

			function newScript() {
				editor.setValue(""); // Clear the editor
				output.setValue(""); // Clear the output
				document.querySelector(".btns-output").style.display = "none"; // Hide output buttons
				button.style.display = "block"; // Show the obfuscate button again
				output.getWrapperElement().style.display = "none"
			}

			let statusTimeout
			function showStatus(message, options) {
				if(statusTimeout) clearTimeout(statusTimeout)
				const statusElement = document.querySelector(".status")
				statusElement.textContent = message
				statusElement.style.opacity = 1

				if(options?.autoclear) statusTimeout = setTimeout(() => {
					statusElement.textContent = ""
					statusElement.style.opacity = 0
				}, 5000); // Hide after 5 seconds

				statusElement.style.color = options?.color ? options.color : "inherit"
			}
		</script>
	</body>
</html>
