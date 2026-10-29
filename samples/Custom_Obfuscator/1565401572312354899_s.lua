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

    <title>Get Delta Key</title>

    <script>document.session = '0a1f4bde-323D-4C15-bb18-a5Da98086F56'</script>
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
        p['TID'] = 1015561; // dynamic
        p['INCENTIVE_AVATAR'] = "https://d1wzdj81h1hubn.cloudfront.net/03f671adbbe471e5.png#"; // dynamic
        p['PUBLISHER_IMAGE'] = ''; // dynamic
        p['PUBLISHER_NAME'] = "Delta Executor";// dynamic
        p['PUBLISHER_TITLE'] = "Get Delta Key";// dynamic
        p['KEY'] = "537339134208869298";
        p['SHOW_UNLOCKER'] = true;
        p['SHOW_PROF_SOCIALS'] = '1';
        p['SOCIAL_ACTIONS'] = 'null';
        p['PUBLISHER_ID'] = '335385';
        p['TIER_ID'] = '4';
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
                url: 'https://www.instagram.com/a',
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
                url: '',
                icon: 'data:image/svg+xml;base64,PCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KDTwhLS0gVXBsb2FkZWQgdG86IFNWRyBSZXBvLCB3d3cuc3ZncmVwby5jb20sIFRyYW5zZm9ybWVkIGJ5OiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA2NCA2NCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBzdHJva2Utd2lkdGg9IjMiIHN0cm9rZT0iI2ZmZmZmZiIgZmlsbD0ibm9uZSI+Cg08ZyBpZD0iU1ZHUmVwb19iZ0NhcnJpZXIiIHN0cm9rZS13aWR0aD0iMCIvPgoNPGcgaWQ9IlNWR1JlcG9fdHJhY2VyQ2FycmllciIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIi8+Cg08ZyBpZD0iU1ZHUmVwb19pY29uQ2FycmllciI+Cg08cGF0aCBkPSJNMzkuOTMsNTUuNzJBMjQuODYsMjQuODYsMCwxLDEsNTYuODYsMzIuMTVhMzcuMjQsMzcuMjQsMCwwLDEtLjczLDYiLz4KDTxwYXRoIGQ9Ik0zNy44Niw1MS4xQTQ3LDQ3LDAsMCwxLDMyLDU2LjciLz4KDTxwYXRoIGQ9Ik0zMiw3QTM0LjE0LDM0LjE0LDAsMCwxLDQzLjU3LDMwYTM0LjA3LDM0LjA3LDAsMCwxLC4wOSw0Ljg1Ii8+Cg08cGF0aCBkPSJNMzIsN0EzNC4wOSwzNC4wOSwwLDAsMCwyMC4zMSwzMi40NmMwLDE2LjIsNy4yOCwyMSwxMS42NiwyNC4yNCIvPgoNPGxpbmUgeDE9IjEwLjM3IiB5MT0iMTkuOSIgeDI9IjUzLjc1IiB5Mj0iMTkuOSIvPgoNPGxpbmUgeDE9IjMyIiB5MT0iNi45OSIgeDI9IjMyIiB5Mj0iNTYuNyIvPgoNPGxpbmUgeDE9IjExLjA1IiB5MT0iNDUuNDgiIHgyPSIzNy4wNCIgeTI9IjQ1LjQ4Ii8+Cg08bGluZSB4MT0iNy4xNCIgeTE9IjMyLjQ2IiB4Mj0iNTYuODYiIHkyPSIzMS44NSIvPgoNPHBhdGggZD0iTTUzLjU3LDU3LDU4LDUyLjU2bC04LTgsNC41NS0yLjkxYS4zOC4zOCwwLDAsMC0uMTItLjdMMzkuMTQsMzcuMzdhLjM5LjM5LDAsMCwwLS40Ni40Nkw0Miw1My40MWEuMzkuMzksMCwwLDAsLjcxLjEzTDQ1LjU3LDQ5WiIvPgoNPC9nPgoNPC9zdmc+'
            },
            {
                url: '',
                icon: 'data:image/svg+xml;base64,PHN2ZyBmaWxsPSIjRkZGRkZGIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciICB2aWV3Qm94PSIwIDAgNTAgNTAiIHdpZHRoPSI1MHB4IiBoZWlnaHQ9IjUwcHgiPjxwYXRoIGQ9Ik0gNS4zMTI1IDEgTCAyIDkuODEyNSBMIDIgNDMgTCAxMyA0MyBMIDEzIDQ5IEwgMjAuNDA2MjUgNDkgTCAyNi40MDYyNSA0MyBMIDM1LjQwNjI1IDQzIEwgNDggMzAuNDM3NSBMIDQ4IDEgWiBNIDExIDYgTCA0MyA2IEwgNDMgMjggTCAzNyAzNCBMIDI1IDM0IEwgMTkgNDAgTCAxOSAzNCBMIDExIDM0IFogTSAyMCAxMyBMIDIwIDI3IEwgMjYgMjcgTCAyNiAxMyBaIE0gMzAgMTMgTCAzMCAyNyBMIDM2IDI3IEwgMzYgMTMgWiIvPjwvc3ZnPg=='
            }
        ];

        p['LOCK_TIMER'] = ''; // dynamic
        p['PUBLISHER_LINK'] = 'NDcxMzhcQ0VDSw4YHl9RWlxCHVRbWEVfWVZEH1RfG0QOVXJeWRdXWUBWDEFXRHxUQX4FdBQBenBhd2FwQFt7B3oHREVhaEwEXXV9cG5zAVdwXXMAbFxnY0pfZgVAcghTUGlAQVxYdmoAWl0FRl1DA3p0TEZYfnJ+VgREfw5gRWB5QUxwfQZpQFhmakh1b0VWdxEFc2QIZFhFV1BYWUAWCnZeAhxsRH4IWGpndQV2TEIYA19bY3ZrSV9+BEsGfQVaQn5SDAd4QUF2BWlwf1BhZAdbBGJCX0tVdFhBQg1AUFUXZQFEXm9EBHZHcXVOQQUKbn58A09OQAhUXHJBZUkOc0NTVlxscQZpQUcPVwMAAnZwcW4BdFthfV99UhYKdnNGf1kBdWFwDgZ9dmcIYAdUXwhQXFpQfWJWZXROV3tJcW15YVB9W3wCYGVuWGMCaQ1SZEhQSgBnQHwMAwRlXH1bEgNxc2NbBEtIcFBdWxcFTQB6VWwCUEFXbQ9IUHYBWAYHDQNyAQpKQ01lfW5xA0R6f0JwYgMMcgEGB1x/DwdJbFZFcEF0UnV7UkpYf2R2c2Nke1FzYANlYVVNUFp0f15cYFpRe3xyQEhARRQBellwfmpJUgZlAF97cwNfXFxjeFVofn99UXkNXQllXXdwR35bf3QBVVxcenhdcVp9SUsMenJ1Fgp2clRqQkJmQ2AMbmBeWlRQBkl4bgYSA3FocAVeAgt1QHRlfUZmSGtqQUNpRWpNQ2lxXV0Aa35KQE92Z0sHWVVdX19eAGFMUAR2AQl5BgdWSlMOZGBLd1EeYUh2c31YTQV4WXl7fFhyQFNiB0sDTgQHBGV0BWVdVVtFZWB8U1cEQXhIbE5fd0paEgNxDVVnXmFMbA5aZUwBBGgGcnZNS1EJenlgYHt4eERSS2ByBGVOfkNgQB0GdWtqXgx4ZVFxDXF0YGwDAl8Gb05UdmRaAnlzWEl4QWgKV2dVXmBwRQ5FFgp2c1BpD2QHREdJXU98BEFefwRyaREFc0YIUxgHAnVOWEdkflBPRXBNXGAeZnVhGAVYbllVe2pNAW8Ham5CQVIKDQNSCVpVfWZieGtxdGd+YBtjcndfAVlCcQhfBgRVDg=='; // dynamic
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
    
    <script>
        // "Log out" for a signed-in visitor (server rendered the AUTH_SIGNED_IN placeholder as '1'), or right
        // after a sign-in through the gate below (it calls window.__llShowLogout). Rendered in a shadow root so the
        // design's CSS can't restyle it; POSTs /auth/logout, then reloads.
        (function () {
            var shown = false;
            function show() {
                if (shown || !document.body) return;
                shown = true;
                // Designs put full-screen fixed layers at z-index 2147483640+, so z-index alone loses: show the
                // button as a manual popover, which lives in the browser's top layer above any z-index.
                var host = document.createElement('div');
                host.setAttribute('popover', 'manual');
                host.style.cssText = 'position:fixed;inset:auto;left:16px;bottom:16px;margin:0;padding:0;border:0;' +
                    'background:transparent;overflow:visible;width:auto;height:auto;z-index:2147483647;';
                var root = host.attachShadow ? host.attachShadow({ mode: 'open' }) : host;
                root.innerHTML =
                    '<style>' +
                    'button{display:inline-flex;align-items:center;gap:6px;font:500 13px/1 Inter,system-ui,-apple-system,sans-serif;' +
                    'color:#c3c7d3;background:rgba(14,16,22,.88);border:1px solid rgba(255,255,255,.12);border-radius:8px;' +
                    'padding:8px 12px;cursor:pointer;-webkit-backdrop-filter:blur(6px);backdrop-filter:blur(6px);' +
                    'transition:color .15s ease,border-color .15s ease,transform .16s cubic-bezier(.23,1,.32,1);}' +
                    'button:hover{color:#f4f5f8;border-color:rgba(255,255,255,.22);}' +
                    'button:active{transform:scale(.97);}' +
                    'button[disabled]{opacity:.6;cursor:default;transform:none;}' +
                    '</style>' +
                    '<button type="button" aria-label="Log out of your LootLabs account">' +
                    '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' +
                    '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/></svg>' +
                    '<span>Log out</span></button>';
                var btn = root.querySelector('button'), label = root.querySelector('span');
                btn.addEventListener('click', function () {
                    btn.disabled = true;
                    label.textContent = 'Logging out…';
                    fetch('/auth/logout', { method: 'POST', credentials: 'same-origin', headers: { 'X-LL-Auth': '1' } })
                        .then(function (res) { return res.ok ? location.reload() : Promise.reject(); })
                        .catch(function () { btn.disabled = false; label.textContent = 'Log out'; });
                });
                document.body.appendChild(host);
                if (typeof host.showPopover === 'function') {
                    host.showPopover();
                } else if (window.MutationObserver) {
                    // No popover support: max z-index, and stay the last child so equal z-index layers can't cover it.
                    new MutationObserver(function () {
                        if (document.body.lastElementChild !== host) document.body.appendChild(host);
                    }).observe(document.body, { childList: true });
                }
            }
            window.__llShowLogout = show;
            if ('0' === '1') show();
        })();
    </script>
    <script>
        // Sign-in gate. Inert unless the server turned the gate on (AUTH_GATE placeholder = '1'). Then the locker
        // loads as usual behind a blurred, non-interactive backdrop with the same-origin /auth/frame form on top,
        // and its POST to <syncer>/tc is held until sign-in succeeds — so /tc goes out after the server has bound
        // the user to this page's key (authctx_<rkey>) and the tasks server can attach the user id.
        (function () {
            if ('0' !== '1') return;

            var release;
            var signedIn = new Promise(function (resolve) { release = resolve; });
            var isTc = function (url) { return /\/tc(?:[?#]|$)/.test(String(url || '')); };

            var origFetch = window.fetch;
            window.fetch = function (input, init) {
                var url = input && typeof input === 'object' && 'url' in input ? input.url : input;
                if (!isTc(url)) return origFetch.apply(this, arguments);
                var self = this, args = arguments;
                return signedIn.then(function () { return origFetch.apply(self, args); });
            };
            var origOpen = XMLHttpRequest.prototype.open, origSend = XMLHttpRequest.prototype.send;
            XMLHttpRequest.prototype.open = function (method, url) {
                this._llTc = isTc(url);
                return origOpen.apply(this, arguments);
            };
            XMLHttpRequest.prototype.send = function () {
                if (!this._llTc) return origSend.apply(this, arguments);
                var self = this, args = arguments;
                signedIn.then(function () { origSend.apply(self, args); });
            };

            var style = document.createElement('style');
            style.textContent =
                '#ll-auth-gate{position:fixed;inset:0;width:100vw;height:100vh;max-width:none;max-height:none;margin:0;padding:16px;border:0;background:#0b0f1c;overflow:hidden;box-sizing:border-box;}' +
                '#ll-auth-gate[open]{display:flex;align-items:center;justify-content:center;}' +
                '#ll-auth-gate::backdrop{background:#0b0f1c;}' +
                '#ll-auth-gate.ll-fallback{z-index:2147483647;}' +
                '#ll-auth-gate iframe{position:relative;z-index:1;display:block;width:100%;height:600px;max-width:420px;max-height:calc(100vh - 32px);max-height:calc(100dvh - 32px);border:1px solid rgba(255,255,255,.08);border-radius:16px;background:#0e1016;box-shadow:0 30px 80px -20px rgba(0,0,0,.75);}' +
                // Blurred stand-in for the locker: the real one only renders after /tc answers, which waits for sign-in.
                '.llp{position:absolute;inset:-24px;z-index:0;pointer-events:none;filter:blur(9px);background:radial-gradient(ellipse at 50% 110%,#22305a 0%,#141c34 45%,#0b0f1c 100%);font-family:inherit;color:#e8ecff;}' +
                '.llp-bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:.45;}' +
                '.llp-col{position:relative;max-width:720px;margin:48px auto 0;padding:0 24px;display:flex;flex-direction:column;gap:18px;}' +
                '.llp-card{background:rgba(20,28,54,.88);border:1px solid rgba(110,140,255,.3);border-radius:10px;padding:18px 20px;}' +
                '.llp-head{display:flex;align-items:center;gap:14px;}' +
                '.llp-av{width:52px;height:52px;border-radius:10px;object-fit:cover;background:#2a365e;flex:none;}' +
                '.llp-name{font-size:18px;font-weight:700;}' +
                '.llp-sub{font-size:13px;opacity:.7;margin-top:2px;}' +
                '.llp-line{font-size:16px;margin-top:14px;}' +
                '.llp-unlock{height:170px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;}' +
                '.llp-bar{height:12px;border-radius:4px;background:rgba(200,210,255,.22);}' +
                '.llp-btn{width:60%;height:40px;border-radius:8px;background:#e9edff;}' +
                '.llp-btn2{width:60%;height:40px;border-radius:8px;border:1px solid rgba(200,210,255,.35);}' +
                '.llp-title{font-size:17px;margin-bottom:14px;}' +
                '.llp-task{display:flex;align-items:center;gap:14px;padding:12px 14px;margin-top:10px;border-radius:8px;background:rgba(40,52,92,.75);border:1px solid rgba(110,140,255,.2);}' +
                '.llp-ico{width:34px;height:34px;border-radius:8px;background:linear-gradient(135deg,#6d7dff,#9a6bff);flex:none;}' +
                '.llp-txt{flex:1;display:flex;flex-direction:column;gap:7px;}' +
                '.llp-ok{width:22px;height:22px;border-radius:50%;border:2px solid rgba(200,210,255,.4);flex:none;}';
            document.head.appendChild(style);

            var gate = document.createElement('dialog');
            gate.id = 'll-auth-gate';
            gate.appendChild(buildPreview());
            var frame = document.createElement('iframe');
            frame.title = 'Sign in to continue';
            frame.src = '/auth/frame?k=' + encodeURIComponent(p['KEY']) + '&s=' + encodeURIComponent(document.session || '');
            gate.appendChild(frame);
            document.body.appendChild(gate);

            function el(tag, cls, text) {
                var n = document.createElement(tag);
                if (cls) n.className = cls;
                if (text) n.textContent = text;
                return n;
            }
            function img(cls, src) {
                var n = el('img', cls);
                n.alt = '';
                if (/^https?:\/\//.test(src || '')) n.src = src; else n.style.visibility = cls === 'llp-bg' ? 'hidden' : '';
                return n;
            }
            function bar(width) { var b = el('div', 'llp-bar'); b.style.width = width; return b; }
            function buildPreview() {
                var root = el('div', 'llp');
                root.setAttribute('aria-hidden', 'true');
                root.appendChild(img('llp-bg', p['PUBLISHER_IMAGE']));
                var col = root.appendChild(el('div', 'llp-col'));

                var head = col.appendChild(el('div', 'llp-card'));
                var row = head.appendChild(el('div', 'llp-head'));
                row.appendChild(img('llp-av', p['INCENTIVE_AVATAR']));
                var who = row.appendChild(el('div'));
                who.appendChild(el('div', 'llp-name', p['PUBLISHER_NAME'] || 'LootLabs'));
                who.appendChild(el('div', 'llp-sub', p['PUBLISHER_TITLE'] || ''));
                head.appendChild(el('div', 'llp-line', 'Complete tasks to continue'));

                var unlock = col.appendChild(el('div', 'llp-card llp-unlock'));
                unlock.appendChild(bar('34%'));
                unlock.appendChild(el('div', 'llp-btn'));
                unlock.appendChild(el('div', 'llp-btn2'));

                var tasks = col.appendChild(el('div', 'llp-card'));
                tasks.appendChild(el('div', 'llp-title', 'Complete Tasks to Continue'));
                var n = Math.min(Math.max(parseInt(p['NUM_OF_TASKS'], 10) || 3, 2), 5);
                for (var i = 0; i < n; i++) {
                    var t = tasks.appendChild(el('div', 'llp-task'));
                    t.appendChild(el('div', 'llp-ico'));
                    var txt = t.appendChild(el('div', 'llp-txt'));
                    txt.appendChild(bar(['48%', '62%', '40%', '55%', '45%'][i]));
                    txt.appendChild(bar('28%'));
                    t.appendChild(el('div', 'llp-ok'));
                }
                return root;
            }

            // Fail open like the server side: if the form never reports in (frame 429/5xx/offline),
            // drop the gate and let the locker run anonymously instead of trapping the user.
            var ready = false, done = false;
            setTimeout(function () { if (!ready && !done) finish(); }, 10000);

            function finish(signedIn) {
                done = true;
                if (gate.open && typeof gate.close === 'function') gate.close();
                gate.remove();
                style.remove();
                release();
                if (signedIn && window.__llShowLogout) window.__llShowLogout();
            }

            // A modal <dialog> sits in the top layer (above any z-index the designs use) and makes the page
            // behind it inert. Older webviews without showModal get a fixed full-screen overlay instead.
            if (typeof gate.showModal === 'function') {
                gate.showModal();
                gate.addEventListener('cancel', function (e) { e.preventDefault(); });
                gate.addEventListener('close', function () { if (!done) gate.showModal(); });
            } else {
                gate.className = 'll-fallback';
                gate.setAttribute('open', '');
            }

            window.addEventListener('message', function (e) {
                if (e.source !== frame.contentWindow || e.origin !== location.origin || !e.data) return;
                if (e.data.type === 'll-auth-size' && e.data.h > 0) {
                    frame.style.height = Math.ceil(e.data.h + 2) + 'px';   // +2: the iframe's 1px border
                    return;
                }
                if (e.data.type === 'll-auth-ready') { ready = true; return; }
                if (e.data.type !== 'll-auth-done' || done) return;
                if (e.data.fresh === false) {
                    // The BotD session expired while the user was signing in; /tc would be rejected.
                    // Reload: the new ll_sess cookie skips the gate and the server mints a fresh session.
                    done = true;
                    location.reload();
                    return;
                }
                finish(true);
            });
        })();
    </script>
    <script src="35.js" subid="Other"></script>
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