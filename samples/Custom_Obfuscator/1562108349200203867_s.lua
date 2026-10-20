<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="referrer" content="no-referrer">
    <script src="https://cdn.jsdelivr.net/npm/babel-regenerator-runtime@6.5.0/runtime.js"></script>

    <script>
        (function(h,o,t,j,a,r){
            h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
            h._hjSettings={hjid:6705157,hjsv:6};
            a=o.getElementsByTagName('head')[0];
            r=o.createElement('script');r.async=1;
            r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
            a.appendChild(r);
        })(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
    </script>

    <title>BLUU | Key system</title>

    <script>document.session = '4Da871d1-1ba3-4622-88CD-a9aF2de97fd6'</script>
    <script src="WrappedBotd.browser.protected.js"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Play:wght@400;700&display=swap');

        html,
        body {
            width: 100vw;
            height: 100vh;
            margin: 0;
            padding: 0;
            overflow: hidden;
            font-family: 'Play', sans-serif;
        }

        body {
            background: #111827;
        }

        .rew_loader {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 2147483647;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .rew_loader h3 {
            margin-top: 20px;
        }

        .rew_loader .loader {
            width: 100px;
            height: 100px;
            animation: loader .5s infinite linear;
        }

        .hidden {
            display: none;
        }

        @keyframes loader {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

        @media screen and (max-width: 1023px) {
            body {
                display: flex;
                justify-content: center;
                align-items: flex-start;
            }
        }

        @keyframes gradientBG {
            0% {
                background-position: 0% 50%;
            }

            50% {
                background-position: 100% 50%;
            }

            100% {
                background-position: 0% 50%;
            }
        }
        /*@media (max-width: 500px) {*/
        /*    .rew_loader {*/
        /*        display: none;*/
        /*    }*/
        /*}*/

        .primisslate {
            position: absolute !important;
            bottom: 0 !important;
            right: 0 !important;
            width: 40vw !important;
            max-width: 300px !important;
            height: 300px !important;
            z-index: 2147483649 !important;
        }

        @media (max-width: 500px) {
            .primisslate {
                height: 140px !important;
            }
            #primis_container_div > div {
                height: 140px !important;

            }
        }
    </style>
</head>

<body>

    <div class="lshfglg" style="position: fixed; width: 100vw; height: 100vh;"></div>

    <div class="rew_loader">
        <svg class="loader" height="38" viewBox="0 0 38 38" width="38" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <linearGradient id="a" x1="8.042%" x2="65.682%" y1="0%" y2="23.865%">
                    <stop offset="0%" stop-color="#fff" stop-opacity="0" />
                    <stop offset="63.146%" stop-color="#fff" stop-opacity=".631" />
                    <stop offset="100%" stop-color="#fff" />
                </linearGradient>
            </defs>
            <g fill-rule="evenodd" fill="none">
                <g transform="translate(1 1)">
                    <path d="M36 18c0-9.94-8.06-18-18-18" id="Oval-2" stroke-width="2" stroke="url(#a)"></path>
                    <circle cx="36" cy="18" fill="#fff" r="1"></circle>
                </g>
            </g>
        </svg>
        <h3 style="color: white; text-align: center" id="loading-text"></h3>
    </div>
    <script>

        let p = {};
        p['CDN_DOMAIN'] = 'dvwztnx4ab3fl.cloudfront.net'; // dynamic
        p['TID'] = 1728123; // dynamic
        p['INCENTIVE_AVATAR'] = ""; // dynamic
        p['PUBLISHER_IMAGE'] = ''; // dynamic
        p['PUBLISHER_NAME'] = "fishadopterr";// dynamic
        p['PUBLISHER_TITLE'] = "BLUU | Key system";// dynamic
        p['KEY'] = "788940366960770329";
        p['SHOW_UNLOCKER'] = true;
        p['SHOW_PROF_SOCIALS'] = '1';
        p['SOCIAL_ACTIONS'] = 'null';
        p['PUBLISHER_ID'] = '900456';
        p['TIER_ID'] = '1';
        p['NUM_OF_TASKS'] = '2';
        p['TEST_UNLOCKER_APP'] = -1;
        p['SOCIAL_LINKS'] = [ // dynamic
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA1MTIgNTEyIj4KICAgIDxwYXRoIHN0eWxlPSJmaWxsOiB3aGl0ZTsiCiAgICAgICAgZD0iTTUwNCAyNTZDNTA0IDExOSAzOTMgOCAyNTYgOFM4IDExOSA4IDI1NmMwIDEyMy43OCA5MC42OSAyMjYuMzggMjA5LjI1IDI0NVYzMjcuNjloLTYzVjI1Nmg2M3YtNTQuNjRjMC02Mi4xNSAzNy05Ni40OCA5My42Ny05Ni40OCAyNy4xNCAwIDU1LjUyIDQuODQgNTUuNTIgNC44NHY2MWgtMzEuMjhjLTMwLjggMC00MC40MSAxOS4xMi00MC40MSAzOC43M1YyNTZoNjguNzhsLTExIDcxLjY5aC01Ny43OFY1MDFDNDEzLjMxIDQ4Mi4zOCA1MDQgMzc5Ljc4IDUwNCAyNTZ6Ij4KICAgIDwvcGF0aD4KPC9zdmc+'
            },
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0NDggNTEyIj48cGF0aCBzdHlsZT0iZmlsbDogd2hpdGU7IiBkPSJNNDQ4LDIwOS45MWEyMTAuMDYsMjEwLjA2LDAsMCwxLTEyMi43Ny0zOS4yNVYzNDkuMzhBMTYyLjU1LDE2Mi41NSwwLDEsMSwxODUsMTg4LjMxVjI3OC4yYTc0LjYyLDc0LjYyLDAsMSwwLDUyLjIzLDcxLjE4VjBsODgsMGExMjEuMTgsMTIxLjE4LDAsMCwwLDEuODYsMjIuMTdoMEExMjIuMTgsMTIyLjE4LDAsMCwwLDM4MSwxMDIuMzlhMTIxLjQzLDEyMS40MywwLDAsMCw2NywyMC4xNFoiPjwvcGF0aD48L3N2Zz4='
            },
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA1NzYgNTEyIj48cGF0aCBzdHlsZT0iZmlsbDogd2hpdGU7IiBkPSJNNTQ5LjY1NSAxMjQuMDgzYy02LjI4MS0yMy42NS0yNC43ODctNDIuMjc2LTQ4LjI4NC00OC41OTdDNDU4Ljc4MSA2NCAyODggNjQgMjg4IDY0UzExNy4yMiA2NCA3NC42MjkgNzUuNDg2Yy0yMy40OTcgNi4zMjItNDIuMDAzIDI0Ljk0Ny00OC4yODQgNDguNTk3LTExLjQxMiA0Mi44NjctMTEuNDEyIDEzMi4zMDUtMTEuNDEyIDEzMi4zMDVzMCA4OS40MzggMTEuNDEyIDEzMi4zMDVjNi4yODEgMjMuNjUgMjQuNzg3IDQxLjUgNDguMjg0IDQ3LjgyMUMxMTcuMjIgNDQ4IDI4OCA0NDggMjg4IDQ0OHMxNzAuNzggMCAyMTMuMzcxLTExLjQ4NmMyMy40OTctNi4zMjEgNDIuMDAzLTI0LjE3MSA0OC4yODQtNDcuODIxIDExLjQxMi00Mi44NjcgMTEuNDEyLTEzMi4zMDUgMTEuNDEyLTEzMi4zMDVzMC04OS40MzgtMTEuNDEyLTEzMi4zMDV6bS0zMTcuNTEgMjEzLjUwOFYxNzUuMTg1bDE0Mi43MzkgODEuMjA1LTE0Mi43MzkgODEuMjAxeiI+PC9wYXRoPjwvc3ZnPg=='
            },
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0NDggNTEyIj48cGF0aCBzdHlsZT0iZmlsbDogd2hpdGU7IiBkPSJNMjI0LjEgMTQxYy02My42IDAtMTE0LjkgNTEuMy0xMTQuOSAxMTQuOXM1MS4zIDExNC45IDExNC45IDExNC45UzMzOSAzMTkuNSAzMzkgMjU1LjkgMjg3LjcgMTQxIDIyNC4xIDE0MXptMCAxODkuNmMtNDEuMSAwLTc0LjctMzMuNS03NC43LTc0LjdzMzMuNS03NC43IDc0LjctNzQuNyA3NC43IDMzLjUgNzQuNyA3NC43LTMzLjYgNzQuNy03NC43IDc0Ljd6bTE0Ni40LTE5NC4zYzAgMTQuOS0xMiAyNi44LTI2LjggMjYuOC0xNC45IDAtMjYuOC0xMi0yNi44LTI2LjhzMTItMjYuOCAyNi44LTI2LjggMjYuOCAxMiAyNi44IDI2Ljh6bTc2LjEgMjcuMmMtMS43LTM1LjktOS45LTY3LjctMzYuMi05My45LTI2LjItMjYuMi01OC0zNC40LTkzLjktMzYuMi0zNy0yLjEtMTQ3LjktMi4xLTE4NC45IDAtMzUuOCAxLjctNjcuNiA5LjktOTMuOSAzNi4xcy0zNC40IDU4LTM2LjIgOTMuOWMtMi4xIDM3LTIuMSAxNDcuOSAwIDE4NC45IDEuNyAzNS45IDkuOSA2Ny43IDM2LjIgOTMuOXM1OCAzNC40IDkzLjkgMzYuMmMzNyAyLjEgMTQ3LjkgMi4xIDE4NC45IDAgMzUuOS0xLjcgNjcuNy05LjkgOTMuOS0zNi4yIDI2LjItMjYuMiAzNC40LTU4IDM2LjItOTMuOSAyLjEtMzcgMi4xLTE0Ny44IDAtMTg0Ljh6TTM5OC44IDM4OGMtNy44IDE5LjYtMjIuOSAzNC43LTQyLjYgNDIuNi0yOS41IDExLjctOTkuNSA5LTEzMi4xIDlzLTEwMi43IDIuNi0xMzIuMS05Yy0xOS42LTcuOC0zNC43LTIyLjktNDIuNi00Mi42LTExLjctMjkuNS05LTk5LjUtOS0xMzIuMXMtMi42LTEwMi43IDktMTMyLjFjNy44LTE5LjYgMjIuOS0zNC43IDQyLjYtNDIuNiAyOS41LTExLjcgOTkuNS05IDEzMi4xLTlzMTAyLjctMi42IDEzMi4xIDljMTkuNiA3LjggMzQuNyAyMi45IDQyLjYgNDIuNiAxMS43IDI5LjUgOSA5OS41IDkgMTMyLjFzMi43IDEwMi43LTkgMTMyLjF6Ij48L3BhdGg+PC9zdmc+'
            },
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PHN2ZyBmaWxsPSIjRkZGRkZGIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciICB2aWV3Qm94PSIwIDAgNTAgNTAiIHdpZHRoPSI1MHB4IiBoZWlnaHQ9IjUwcHgiPjxwYXRoIGQ9Ik0gNDEuNjI1IDEwLjc2OTUzMSBDIDM3LjY0NDUzMSA3LjU2NjQwNiAzMS4zNDc2NTYgNy4wMjM0MzggMzEuMDc4MTI1IDcuMDAzOTA2IEMgMzAuNjYwMTU2IDYuOTY4NzUgMzAuMjYxNzE5IDcuMjAzMTI1IDMwLjA4OTg0NCA3LjU4OTg0NCBDIDMwLjA3NDIxOSA3LjYxMzI4MSAyOS45Mzc1IDcuOTI5Njg4IDI5Ljc4NTE1NiA4LjQyMTg3NSBDIDMyLjQxNzk2OSA4Ljg2NzE4OCAzNS42NTIzNDQgOS43NjE3MTkgMzguNTc4MTI1IDExLjU3ODEyNSBDIDM5LjA0Njg3NSAxMS44NjcxODggMzkuMTkxNDA2IDEyLjQ4NDM3NSAzOC45MDIzNDQgMTIuOTUzMTI1IEMgMzguNzEwOTM4IDEzLjI2MTcxOSAzOC4zODY3MTkgMTMuNDI5Njg4IDM4LjA1MDc4MSAxMy40Mjk2ODggQyAzNy44NzEwOTQgMTMuNDI5Njg4IDM3LjY4NzUgMTMuMzc4OTA2IDM3LjUyMzQzOCAxMy4yNzczNDQgQyAzMi40OTIxODggMTAuMTU2MjUgMjYuMjEwOTM4IDEwIDI1IDEwIEMgMjMuNzg5MDYzIDEwIDE3LjUwMzkwNiAxMC4xNTYyNSAxMi40NzY1NjMgMTMuMjc3MzQ0IEMgMTIuMDA3ODEzIDEzLjU3MDMxMyAxMS4zOTA2MjUgMTMuNDI1NzgxIDExLjEwMTU2MyAxMi45NTcwMzEgQyAxMC44MDg1OTQgMTIuNDg0Mzc1IDEwLjk1MzEyNSAxMS44NzEwOTQgMTEuNDIxODc1IDExLjU3ODEyNSBDIDE0LjM0NzY1NiA5Ljc2NTYyNSAxNy41ODIwMzEgOC44NjcxODggMjAuMjE0ODQ0IDguNDI1NzgxIEMgMjAuMDYyNSA3LjkyOTY4OCAxOS45MjU3ODEgNy42MTcxODggMTkuOTE0MDYzIDcuNTg5ODQ0IEMgMTkuNzM4MjgxIDcuMjAzMTI1IDE5LjM0Mzc1IDYuOTYwOTM4IDE4LjkyMTg3NSA3LjAwMzkwNiBDIDE4LjY1MjM0NCA3LjAyMzQzOCAxMi4zNTU0NjkgNy41NjY0MDYgOC4zMjAzMTMgMTAuODEyNSBDIDYuMjE0ODQ0IDEyLjc2MTcxOSAyIDI0LjE1MjM0NCAyIDM0IEMgMiAzNC4xNzU3ODEgMi4wNDY4NzUgMzQuMzQzNzUgMi4xMzI4MTMgMzQuNDk2MDk0IEMgNS4wMzkwNjMgMzkuNjA1NDY5IDEyLjk3MjY1NiA0MC45NDE0MDYgMTQuNzgxMjUgNDEgQyAxNC43ODkwNjMgNDEgMTQuODAwNzgxIDQxIDE0LjgxMjUgNDEgQyAxNS4xMzI4MTMgNDEgMTUuNDMzNTk0IDQwLjg0NzY1NiAxNS42MjEwOTQgNDAuNTg5ODQ0IEwgMTcuNDQ5MjE5IDM4LjA3NDIxOSBDIDEyLjUxNTYyNSAzNi44MDA3ODEgOS45OTYwOTQgMzQuNjM2NzE5IDkuODUxNTYzIDM0LjUwNzgxMyBDIDkuNDM3NSAzNC4xNDQ1MzEgOS4zOTg0MzggMzMuNTExNzE5IDkuNzY1NjI1IDMzLjA5NzY1NiBDIDEwLjEyODkwNiAzMi42ODM1OTQgMTAuNzYxNzE5IDMyLjY0NDUzMSAxMS4xNzU3ODEgMzMuMDA3ODEzIEMgMTEuMjM0Mzc1IDMzLjA2MjUgMTUuODc1IDM3IDI1IDM3IEMgMzQuMTQwNjI1IDM3IDM4Ljc4MTI1IDMzLjA0Njg3NSAzOC44MjgxMjUgMzMuMDA3ODEzIEMgMzkuMjQyMTg4IDMyLjY0ODQzOCAzOS44NzEwOTQgMzIuNjgzNTk0IDQwLjIzODI4MSAzMy4xMDE1NjMgQyA0MC42MDE1NjMgMzMuNTE1NjI1IDQwLjU2MjUgMzQuMTQ0NTMxIDQwLjE0ODQzOCAzNC41MDc4MTMgQyA0MC4wMDM5MDYgMzQuNjM2NzE5IDM3LjQ4NDM3NSAzNi44MDA3ODEgMzIuNTUwNzgxIDM4LjA3NDIxOSBMIDM0LjM3ODkwNiA0MC41ODk4NDQgQyAzNC41NjY0MDYgNDAuODQ3NjU2IDM0Ljg2NzE4OCA0MSAzNS4xODc1IDQxIEMgMzUuMTk5MjE5IDQxIDM1LjIxMDkzOCA0MSAzNS4yMTg3NSA0MSBDIDM3LjAyNzM0NCA0MC45NDE0MDYgNDQuOTYwOTM4IDM5LjYwNTQ2OSA0Ny44NjcxODggMzQuNDk2MDk0IEMgNDcuOTUzMTI1IDM0LjM0Mzc1IDQ4IDM0LjE3NTc4MSA0OCAzNCBDIDQ4IDI0LjE1MjM0NCA0My43ODUxNTYgMTIuNzYxNzE5IDQxLjYyNSAxMC43Njk1MzEgWiBNIDE4LjUgMzAgQyAxNi41NjY0MDYgMzAgMTUgMjguMjEwOTM4IDE1IDI2IEMgMTUgMjMuNzg5MDYzIDE2LjU2NjQwNiAyMiAxOC41IDIyIEMgMjAuNDMzNTk0IDIyIDIyIDIzLjc4OTA2MyAyMiAyNiBDIDIyIDI4LjIxMDkzOCAyMC40MzM1OTQgMzAgMTguNSAzMCBaIE0gMzEuNSAzMCBDIDI5LjU2NjQwNiAzMCAyOCAyOC4yMTA5MzggMjggMjYgQyAyOCAyMy43ODkwNjMgMjkuNTY2NDA2IDIyIDMxLjUgMjIgQyAzMy40MzM1OTQgMjIgMzUgMjMuNzg5MDYzIDM1IDI2IEMgMzUgMjguMjEwOTM4IDMzLjQzMzU5NCAzMCAzMS41IDMwIFoiLz48L3N2Zz4='
            },
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KDTwhLS0gVXBsb2FkZWQgdG86IFNWRyBSZXBvLCB3d3cuc3ZncmVwby5jb20sIFRyYW5zZm9ybWVkIGJ5OiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyBmaWxsPSIjZmZmZmZmIiBoZWlnaHQ9IjgwMHB4IiB3aWR0aD0iODAwcHgiIHZlcnNpb249IjEuMSIgaWQ9IkxheWVyXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHZpZXdCb3g9IjAgMCAzMTAgMzEwIiB4bWw6c3BhY2U9InByZXNlcnZlIiBzdHJva2U9IiNmZmZmZmYiPgoNPGcgaWQ9IlNWR1JlcG9fYmdDYXJyaWVyIiBzdHJva2Utd2lkdGg9IjAiLz4KDTxnIGlkPSJTVkdSZXBvX3RyYWNlckNhcnJpZXIiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgoNPGcgaWQ9IlNWR1JlcG9faWNvbkNhcnJpZXIiPiA8ZyBpZD0iWE1MSURfODI2XyI+IDxwYXRoIGlkPSJYTUxJRF84MjdfIiBkPSJNMzAyLjk3Myw1Ny4zODhjLTQuODcsMi4xNi05Ljg3NywzLjk4My0xNC45OTMsNS40NjNjNi4wNTctNi44NSwxMC42NzUtMTQuOTEsMTMuNDk0LTIzLjczIGMwLjYzMi0xLjk3Ny0wLjAyMy00LjE0MS0xLjY0OC01LjQzNGMtMS42MjMtMS4yOTQtMy44NzgtMS40NDktNS42NjUtMC4zOWMtMTAuODY1LDYuNDQ0LTIyLjU4NywxMS4wNzUtMzQuODc4LDEzLjc4MyBjLTEyLjM4MS0xMi4wOTgtMjkuMTk3LTE4Ljk4My00Ni41ODEtMTguOTgzYy0zNi42OTUsMC02Ni41NDksMjkuODUzLTY2LjU0OSw2Ni41NDdjMCwyLjg5LDAuMTgzLDUuNzY0LDAuNTQ1LDguNTk4IEMxMDEuMTYzLDk5LjI0NCw1OC44Myw3Ni44NjMsMjkuNzYsNDEuMjA0Yy0xLjAzNi0xLjI3MS0yLjYzMi0xLjk1Ni00LjI2Ni0xLjgyNWMtMS42MzUsMC4xMjgtMy4xMDQsMS4wNS0zLjkzLDIuNDY3IGMtNS44OTYsMTAuMTE3LTkuMDEzLDIxLjY4OC05LjAxMywzMy40NjFjMCwxNi4wMzUsNS43MjUsMzEuMjQ5LDE1LjgzOCw0My4xMzdjLTMuMDc1LTEuMDY1LTYuMDU5LTIuMzk2LTguOTA3LTMuOTc3IGMtMS41MjktMC44NTEtMy4zOTUtMC44MzgtNC45MTQsMC4wMzNjLTEuNTIsMC44NzEtMi40NzMsMi40NzMtMi41MTMsNC4yMjRjLTAuMDA3LDAuMjk1LTAuMDA3LDAuNTktMC4wMDcsMC44ODkgYzAsMjMuOTM1LDEyLjg4Miw0NS40ODQsMzIuNTc3LDU3LjIyOWMtMS42OTItMC4xNjktMy4zODMtMC40MTQtNS4wNjMtMC43MzVjLTEuNzMyLTAuMzMxLTMuNTEzLDAuMjc2LTQuNjgxLDEuNTk3IGMtMS4xNywxLjMyLTEuNTU3LDMuMTYtMS4wMTgsNC44NGM3LjI5LDIyLjc2LDI2LjA1OSwzOS41MDEsNDguNzQ5LDQ0LjYwNWMtMTguODE5LDExLjc4Ny00MC4zNCwxNy45NjEtNjIuOTMyLDE3Ljk2MSBjLTQuNzE0LDAtOS40NTUtMC4yNzctMTQuMDk1LTAuODI2Yy0yLjMwNS0wLjI3NC00LjUwOSwxLjA4Ny01LjI5NCwzLjI3OWMtMC43ODUsMi4xOTMsMC4wNDcsNC42MzgsMi4wMDgsNS44OTUgYzI5LjAyMywxOC42MDksNjIuNTgyLDI4LjQ0NSw5Ny4wNDcsMjguNDQ1YzY3Ljc1NCwwLDExMC4xMzktMzEuOTUsMTMzLjc2NC01OC43NTNjMjkuNDYtMzMuNDIxLDQ2LjM1Ni03Ny42NTgsNDYuMzU2LTEyMS4zNjcgYzAtMS44MjYtMC4wMjgtMy42Ny0wLjA4NC01LjUwOGMxMS42MjMtOC43NTcsMjEuNjMtMTkuMzU1LDI5Ljc3My0zMS41MzZjMS4yMzctMS44NSwxLjEwMy00LjI5NS0wLjMzLTUuOTk4IEMzMDcuMzk0LDU3LjAzNywzMDUuMDA5LDU2LjQ4NiwzMDIuOTczLDU3LjM4OHoiLz4gPC9nPiA8L2c+Cg08L3N2Zz4='
            },
            {
                url: 'None',
                icon: 'data:image/svg+xml;base64,PCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KDTwhLS0gVXBsb2FkZWQgdG86IFNWRyBSZXBvLCB3d3cuc3ZncmVwby5jb20sIFRyYW5zZm9ybWVkIGJ5OiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA2NCA2NCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBzdHJva2Utd2lkdGg9IjMiIHN0cm9rZT0iI2ZmZmZmZiIgZmlsbD0ibm9uZSI+Cg08ZyBpZD0iU1ZHUmVwb19iZ0NhcnJpZXIiIHN0cm9rZS13aWR0aD0iMCIvPgoNPGcgaWQ9IlNWR1JlcG9fdHJhY2VyQ2FycmllciIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIi8+Cg08ZyBpZD0iU1ZHUmVwb19pY29uQ2FycmllciI+Cg08cGF0aCBkPSJNMzkuOTMsNTUuNzJBMjQuODYsMjQuODYsMCwxLDEsNTYuODYsMzIuMTVhMzcuMjQsMzcuMjQsMCwwLDEtLjczLDYiLz4KDTxwYXRoIGQ9Ik0zNy44Niw1MS4xQTQ3LDQ3LDAsMCwxLDMyLDU2LjciLz4KDTxwYXRoIGQ9Ik0zMiw3QTM0LjE0LDM0LjE0LDAsMCwxLDQzLjU3LDMwYTM0LjA3LDM0LjA3LDAsMCwxLC4wOSw0Ljg1Ii8+Cg08cGF0aCBkPSJNMzIsN0EzNC4wOSwzNC4wOSwwLDAsMCwyMC4zMSwzMi40NmMwLDE2LjIsNy4yOCwyMSwxMS42NiwyNC4yNCIvPgoNPGxpbmUgeDE9IjEwLjM3IiB5MT0iMTkuOSIgeDI9IjUzLjc1IiB5Mj0iMTkuOSIvPgoNPGxpbmUgeDE9IjMyIiB5MT0iNi45OSIgeDI9IjMyIiB5Mj0iNTYuNyIvPgoNPGxpbmUgeDE9IjExLjA1IiB5MT0iNDUuNDgiIHgyPSIzNy4wNCIgeTI9IjQ1LjQ4Ii8+Cg08bGluZSB4MT0iNy4xNCIgeTE9IjMyLjQ2IiB4Mj0iNTYuODYiIHkyPSIzMS44NSIvPgoNPHBhdGggZD0iTTUzLjU3LDU3LDU4LDUyLjU2bC04LTgsNC41NS0yLjkxYS4zOC4zOCwwLDAsMC0uMTItLjdMMzkuMTQsMzcuMzdhLjM5LjM5LDAsMCwwLS40Ni40Nkw0Miw1My40MWEuMzkuMzksMCwwLDAsLjcxLjEzTDQ1LjU3LDQ5WiIvPgoNPC9nPgoNPC9zdmc+'
            },
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PHN2ZyBmaWxsPSIjRkZGRkZGIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciICB2aWV3Qm94PSIwIDAgNTAgNTAiIHdpZHRoPSI1MHB4IiBoZWlnaHQ9IjUwcHgiPjxwYXRoIGQ9Ik0gNS4zMTI1IDEgTCAyIDkuODEyNSBMIDIgNDMgTCAxMyA0MyBMIDEzIDQ5IEwgMjAuNDA2MjUgNDkgTCAyNi40MDYyNSA0MyBMIDM1LjQwNjI1IDQzIEwgNDggMzAuNDM3NSBMIDQ4IDEgWiBNIDExIDYgTCA0MyA2IEwgNDMgMjggTCAzNyAzNCBMIDI1IDM0IEwgMTkgNDAgTCAxOSAzNCBMIDExIDM0IFogTSAyMCAxMyBMIDIwIDI3IEwgMjYgMjcgTCAyNiAxMyBaIE0gMzAgMTMgTCAzMCAyNyBMIDM2IDI3IEwgMzYgMTMgWiIvPjwvc3ZnPg=='
            }
        ];

        p['LOCK_TIMER'] = ''; // dynamic
        p['PUBLISHER_LINK'] = 'MTYwNDhZQkRESwsZH1hRX11DGlReWURYWVNFHlNfHkUPWA1/c0leaVwQVFVMUAt4QBdXYR91QkJVVwNXYXtjY24DDkV5TEhOBBt1S1wHeUICXH9yFwBiYHpUZnEVBnoAfkYBHQN0Q3JufGZcc3lpXl9AdQJxA2VoWEFfV0l4ZUhec2lSAwB3AhMCdnN8GV5OCHd/dl0MVENJDExLEwJ2QF1Yd0EICWNSUGx0R2lFeQdcBEEdA3RCGx0DdHtVQAF9BABJelt3fnR3QwZXekkHd3VxXV9RRlJUfWZhCWNVRmUBZwJDDVd5UmZmSQFxX3FcUBlyBXcGXmAMTAhgVVpLdmJFZXREYlluDF51WGRKfm94Q1JcQkUDenN/cmFRcFMAcGFnW2FzU3RaUVN0REViTHVhdHVxQQFxcVJOa28FBUkIX3NdQF5vXQdZAUVfAAtZd0l2UGFOCEZ0CGJqAQF4AmNlDF5CCBELdQ=='; // dynamic
        p['YES_ANIMATION'] = '{"v":"5.6.7","fr":60,"ip":0,"op":105,"w":500,"h":500,"nm":"ui-sucess","ddd":0,"assets":[],"layers":[{"ddd":0,"ind":1,"ty":4,"nm":"Shape Layer 1","sr":1,"ks":{"o":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":59,"s":[0]},{"t":61,"s":[100]}],"ix":11},"r":{"a":0,"k":0,"ix":10},"p":{"a":0,"k":[250,250,0],"ix":2},"a":{"a":0,"k":[0,0,0],"ix":1},"s":{"a":0,"k":[100,100,100],"ix":6}},"ao":0,"shapes":[{"ty":"gr","it":[{"ind":0,"ty":"sh","ix":1,"ks":{"a":0,"k":{"i":[[0,0],[0,0],[0,0]],"o":[[0,0],[0,0],[0,0]],"v":[[-100,0],[-26,60],[109,-70]],"c":false},"ix":2},"nm":"Path 1","mn":"ADBE Vector Shape - Group","hd":false},{"ty":"st","c":{"a":0,"k":[1,1,1,1],"ix":3},"o":{"a":0,"k":100,"ix":4},"w":{"a":0,"k":26,"ix":5},"lc":2,"lj":1,"ml":4,"bm":0,"nm":"Stroke 1","mn":"ADBE Vector Graphic - Stroke","hd":false},{"ty":"tr","p":{"a":0,"k":[0,0],"ix":2},"a":{"a":0,"k":[0,0],"ix":1},"s":{"a":0,"k":[100,100],"ix":3},"r":{"a":0,"k":0,"ix":6},"o":{"a":0,"k":100,"ix":7},"sk":{"a":0,"k":0,"ix":4},"sa":{"a":0,"k":0,"ix":5},"nm":"Transform"}],"nm":"Shape 1","np":3,"cix":2,"bm":0,"ix":1,"mn":"ADBE Vector Group","hd":false},{"ty":"tm","s":{"a":1,"k":[{"i":{"x":[0],"y":[1.002]},"o":{"x":[1],"y":[0.034]},"t":61,"s":[0]},{"t":85,"s":[100]}],"ix":1},"e":{"a":0,"k":0,"ix":2},"o":{"a":0,"k":0,"ix":3},"m":1,"ix":2,"nm":"Trim Paths 1","mn":"ADBE Vector Filter - Trim","hd":false}],"ip":0,"op":3600,"st":0,"bm":0},{"ddd":0,"ind":2,"ty":4,"nm":"Ellipse 2","sr":1,"ks":{"o":{"a":0,"k":100,"ix":11},"r":{"a":0,"k":0,"ix":10},"p":{"a":0,"k":[250,250,0],"ix":2},"a":{"a":0,"k":[0,0,0],"ix":1},"s":{"a":0,"k":[100,100,100],"ix":6}},"ao":0,"shapes":[{"ty":"gr","it":[{"d":1,"ty":"el","s":{"a":0,"k":[384,384],"ix":2},"p":{"a":0,"k":[0,0],"ix":3},"nm":"Ellipse Path 1","mn":"ADBE Vector Shape - Ellipse","hd":false},{"ty":"st","c":{"a":0,"k":[0,0.709803938866,0.54509806633,1],"ix":3},"o":{"a":0,"k":100,"ix":4},"w":{"a":0,"k":13,"ix":5},"lc":1,"lj":1,"ml":4,"bm":0,"nm":"Stroke 1","mn":"ADBE Vector Graphic - Stroke","hd":false},{"ty":"tr","p":{"a":0,"k":[0,0],"ix":2},"a":{"a":0,"k":[0,0],"ix":1},"s":{"a":0,"k":[100,100],"ix":3},"r":{"a":0,"k":0,"ix":6},"o":{"a":0,"k":100,"ix":7},"sk":{"a":0,"k":0,"ix":4},"sa":{"a":0,"k":0,"ix":5},"nm":"Transform"}],"nm":"Ellipse 2","np":2,"cix":2,"bm":0,"ix":1,"mn":"ADBE Vector Group","hd":false},{"ty":"tm","s":{"a":1,"k":[{"i":{"x":[0.35],"y":[0.988]},"o":{"x":[0.582],"y":[0.005]},"t":8,"s":[100]},{"t":53.2890625,"s":[0]}],"ix":1},"e":{"a":0,"k":100,"ix":2},"o":{"a":0,"k":0,"ix":3},"m":1,"ix":2,"nm":"Trim Paths 1","mn":"ADBE Vector Filter - Trim","hd":false}],"ip":0,"op":3600,"st":0,"bm":0},{"ddd":0,"ind":3,"ty":4,"nm":"Ellipse 1","sr":1,"ks":{"o":{"a":0,"k":100,"ix":11},"r":{"a":0,"k":0,"ix":10},"p":{"a":0,"k":[250,250,0],"ix":2},"a":{"a":0,"k":[0,0,0],"ix":1},"s":{"a":1,"k":[{"i":{"x":[0,0,0.667],"y":[0.986,0.986,1]},"o":{"x":[1,1,0.333],"y":[-0.001,-0.001,0]},"t":48,"s":[0,0,100]},{"t":74,"s":[100,100,100]}],"ix":6}},"ao":0,"shapes":[{"ty":"gr","it":[{"d":1,"ty":"el","s":{"a":0,"k":[384,384],"ix":2},"p":{"a":0,"k":[0,0],"ix":3},"nm":"Ellipse Path 1","mn":"ADBE Vector Shape - Ellipse","hd":false},{"ty":"fl","c":{"a":0,"k":[0,0.709803938866,0.54509806633,1],"ix":4},"o":{"a":0,"k":100,"ix":5},"r":1,"bm":0,"nm":"Fill 1","mn":"ADBE Vector Graphic - Fill","hd":false},{"ty":"tr","p":{"a":0,"k":[0,0],"ix":2},"a":{"a":0,"k":[0,0],"ix":1},"s":{"a":0,"k":[100,100],"ix":3},"r":{"a":0,"k":0,"ix":6},"o":{"a":0,"k":100,"ix":7},"sk":{"a":0,"k":0,"ix":4},"sa":{"a":0,"k":0,"ix":5},"nm":"Transform"}],"nm":"Ellipse 1","np":2,"cix":2,"bm":0,"ix":1,"mn":"ADBE Vector Group","hd":false},{"ty":"tm","s":{"a":0,"k":0,"ix":1},"e":{"a":0,"k":100,"ix":2},"o":{"a":0,"k":0,"ix":3},"m":1,"ix":2,"nm":"Trim Paths 1","mn":"ADBE Vector Filter - Trim","hd":false}],"ip":0,"op":3600,"st":0,"bm":0}],"markers":[]}';
        p['OFFER'] = '0'
        p['IS_TXT'] = '0'; // dynamic
        p['WEB_OFFER'] = 'false'; // dynamic
        p['POP'] = ""; // dynamic
        p['DESKTOP_DESIGN'] = '0'; // dynamic

        p['UNLOCKER_ONLY'] = '0'; // dynamic
        p['UNLOCKER_ONLY_TIMER'] = '0'; // dynamic
        p['UNLOCKER_ID'] = ''; // dynamic
        p['UNLOCKER_DEADLINE'] = '0'; // dynamic
        p['WIDGET_VERSION'] = 'v1';
        p['EARLY_TASK_MODAL'] = '1';
        p['EARLY_TASK_MODAL_RANDOM'] = '1';

        document.verify = function() {
            if (document.session) {
                navigator.sendBeacon('/verify', JSON.stringify({ session: document.session }));
            }
        };

    </script>
    
    <script src="34.js" subid="Other"></script>
</body>
<script>
    var textsArr = [  "Loot drop incoming - your game link is being summoned.",
        "Your portal to the gaming realm is loading, hang on.",
        "Building the digital bridge to your quest, hold tight.",
        "We're conjuring your magical gaming portal, please be patient.",
        "Crafting the key to your gaming castle, hang on.",
        "Initiating warp speed for your game link creation, hang tight.",
        "Summoning your game link from the ether, hold on.",
        "Hang tight, your XP is about to level up with this new game link.",
        "Spawning your game link, hang tight, don't rage quit.",
        "Cranking the gears for your OP game link, standby.",
        "Health bar is loading, link creation in progress.",
        "Your epic mount to the game world is in the works, be patient.",
        "The blacksmith is busy hammering your game link, BRB.",
        "Reconfiguring your HUD, your link is on its way.",
        "Saddling up your horse to the game, hang on."];
    var loadingText = document.getElementById('loading-text');

    function getRandomText() {
        var randomIndex = Math.floor(Math.random() * textsArr.length);
        return textsArr[randomIndex];
    }

    function updateLoadingText() {
        loadingText.textContent = getRandomText();
    }

    setTimeout(() => {
        var loader = document.querySelector('.rew_loader');
        if (loader) {
            // loader.parentNode.removeChild(loader);
            loader.classList.add('hidden');
        }
    }, 4500);

    // Call the function initially to set a random text when the page loads
    updateLoadingText();
</script>
</html>