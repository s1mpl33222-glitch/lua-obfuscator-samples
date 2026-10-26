import requests
import json
import random
import os
import sys
import time
import threading
import websocket
TOKEN = "YOUR_TOKEN_HERE"
PREFIX = "."
HEADERS = {
    "Authorization": TOKEN,
    "Content-Type": "application/json",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}
STOP_SIGNAL = {}
def send_msg(channel_id, content):
    url = f"https://discord.com/api/v9/channels/{channel_id}/messages"
    try:
        res = requests.post(url, headers=HEADERS, json={"content": str(content)})
        return res.json()
    except: pass
def delete_msg(channel_id, message_id):
    url = f"https://discord.com/api/v9/channels/{channel_id}/messages/{message_id}"
    try:
        requests.delete(url, headers=HEADERS)
    except: pass
def handle_commands(data, my_id):
    channel_id = data.get("channel_id")
    content = data.get("content", "")
    author = data.get("author", {})
    if author.get("id") != my_id or not content.startswith(PREFIX): return
    args = content[len(PREFIX):].split()
    if not args: return
    cmd = args[0].lower()
    if cmd == "r":
        info = (
            "**[ RU6YX V2 ]**\n"
            "`.keep` > إرسال عشوائي\n"
            "`.keep2 @user` > ارسال الرسائل المحفوضه بالترتيب\n"
            "`.spam <Amount> <msg>` > تكرار كلمة\n"
            "`.clear <Amount>` > حذف رسائلك\n"
            "`.avatar @user` > صورة مستخدم\n"
            "`.banner @user` > بانر مستخدم\n"
            "`.close-dms` > إغلاق الخاص\n"
            "`.leave-groups` > مغادرة الجروبات\n"
            "`.bc <msg>` > برودكاست للخاص\n"
            "`.stop` > إيقاف العملية\n"
            "حقوق > كيوجا روسي"
        )
        send_msg(channel_id, info)
    elif cmd == "keep":
        STOP_SIGNAL[channel_id] = False
        def run_keep():
            try:
                with open("messages.txt", "r", encoding="utf-8") as f:
                    lines = [l.strip() for l in f.readlines() if l.strip()]
                while not STOP_SIGNAL.get(channel_id):
                    send_msg(channel_id, random.choice(lines))
                    time.sleep(0.01)
            except: pass
        threading.Thread(target=run_keep).start()
    elif cmd == "keep2":
        STOP_SIGNAL[channel_id] = False
        mentions = " ".join(args[1:])
        send_msg(channel_id, f"{mentions}\nhttps://tenor.com/view/warrior-gif-6183644")
        def run_keep2():
            try:
                with open("messages.txt", "r", encoding="utf-8") as f:
                    lines = [l.strip() for l in f.readlines() if l.strip()]
                if not lines: return
                while not STOP_SIGNAL.get(channel_id):
                    for line in lines:
                        if STOP_SIGNAL.get(channel_id): break
                        send_msg(channel_id, f"{mentions} {line}")
                        time.sleep(0.01)
            except: pass
        threading.Thread(target=run_keep2).start()
    elif cmd == "spam":
        try:
            amount = int(args[1])
            msg = " ".join(args[2:])
            def run_spam():
                for _ in range(amount):
                    if STOP_SIGNAL.get(channel_id): break
                    send_msg(channel_id, msg)
                    time.sleep(0.01)
            threading.Thread(target=run_spam).start()
        except: pass
    elif cmd == "clear":
        def run_clear():
            limit = int(args[1]) if len(args) > 1 else 100
            url = f"https://discord.com/api/v9/channels/{channel_id}/messages?limit={limit}"
            try:
                r = requests.get(url, headers=HEADERS)
                msgs = r.json()
                for m in msgs:
                    if m['author']['id'] == my_id:
                        delete_msg(channel_id, m['id'])
                        time.sleep(0.3)
            except: pass
        threading.Thread(target=run_clear).start()
    elif cmd in ["avatar", "banner"]:
        u_id = args[1].replace("<@!", "").replace("<@", "").replace(">", "") if len(args) > 1 else my_id
        try:
            r = requests.get(f"https://discord.com/api/v9/users/{u_id}", headers=HEADERS)
            u = r.json()
            if cmd == "avatar": send_msg(channel_id, f"https://cdn.discordapp.com/avatars/{u_id}/{u['avatar']}.png?size=1024")
            else: send_msg(channel_id, f"https://cdn.discordapp.com/banners/{u_id}/{u['banner']}.png?size=1024" if u.get('banner') else "ما عنده بانر")
        except: pass
    elif cmd in ["close-dms", "leave-groups"]:
        def run_clean():
            try:
                r = requests.get("https://discord.com/api/v9/users/@me/channels", headers=HEADERS)
                for ch in r.json():
                    if (cmd == "close-dms" and ch['type'] == 1) or (cmd == "leave-groups" and ch['type'] == 3):
                        requests.delete(f"https://discord.com/api/v9/channels/{ch['id']}", headers=HEADERS)
                        time.sleep(0.4)
            except: pass
        threading.Thread(target=run_clean).start()
    elif cmd == "bc":
        bc_msg = " ".join(args[1:])
        def run_bc():
            try:
                r = requests.get("https://discord.com/api/v9/users/@me/channels", headers=HEADERS)
                for ch in r.json():
                    if ch['type'] == 1:
                        send_msg(ch['id'], bc_msg)
                        time.sleep(0.5)
            except: pass
        threading.Thread(target=run_bc).start()
    elif cmd == "stop":
        STOP_SIGNAL[channel_id] = True
def main():
    while True:
        try:
            r = requests.get("https://discord.com/api/v9/users/@me", headers=HEADERS)
            if r.status_code != 200:
                print("Token Error")
                time.sleep(5)
                continue
            me = r.json()
            my_id = me['id']
            print(f"Login as: {me['username']}")
            # Websocket connection
            ws = websocket.create_connection("wss://gateway.discord.gg/?v=9&encoding=json")
            # Identify
            payload = {
                "op": 2,
                "d": {
                    "token": TOKEN,
                    "properties": {"os": "Windows", "browser": "Chrome", "device": ""},
                    "presence": {"status": "online", "since": 0, "activities": [], "afk": False}
                }
            }
            ws.send(json.dumps(payload))
            # Loop listener (بديل الـ async for msg in ws)
            while True:
                result = ws.recv()
                if result:
                    data = json.loads(result)
                    if data["op"] == 10:
                        interval = data["d"]["heartbeat_interval"] / 1000
                        def hb():
                            while True:
                                time.sleep(interval)
                                try: ws.send(json.dumps({"op": 1, "d": None}))
                                except: break
                        threading.Thread(target=hb, daemon=True).start()
                    if data.get("t") == "MESSAGE_CREATE":
                      
threading.Thread(target=handle_commands, args=(data["d"], my_id)).start()
        except Exception as e:
            print(f"[!] ERROR: {e}.")
            time.sleep(5)
if __name__ == "__main__":
    main()