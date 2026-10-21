local SCRIPT_ID = "animedice"
local WORKER = "https://hamsterdiwa.com"
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local KEY = tostring((getgenv and getgenv().script_key) or script_key or "")
local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local function hwid() local ok,id=pcall(function() if gethwid then return gethwid() end return game:GetService("RBXAnalyticsService"):GetClientId() end) return ok and tostring(id) or "unknown" end
local function fail(m) local t=tostring(m) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Key System",Text=t,Duration=10}) end) pcall(function() warn("[Key System] "..t) end) pcall(function() LP:Kick("\n[Key System]\n"..t) end) error("[Key System] "..t,0) end
if not req then fail("executor ไม่รองรับ") end
if KEY=="" then fail("ไม่ได้ใส่ script_key") end
-- หมายเหตุ: ถอดด่าน iscclosure(req/loadstring) ออกแล้ว (2026-09-30)
-- เพราะ false-positive เตะลูกค้าจริงที่ executor ห่อ request/loadstring เป็น Lua closure
-- และมันไม่กัน hook แบบ newcclosure อยู่แล้ว (พิสูจน์บน Potassium: newcclosure แยกไม่ออกจากตัวแท้)
-- เหลือด่าน nonce challenge (กัน response ปลอมแบบ static) ซึ่งปลอดภัย ไม่ false-positive
-- [กันแครก] nonce challenge — เซิร์ฟต้อง echo ค่าสุ่มนี้กลับ ถ้ามีคนปลอม response แบบ static (เช่น Reaper) จะไม่มี nonce
local nonce = HttpService:GenerateGUID(false) .. tostring(os.clock())
local ok,res=pcall(req,{Url=WORKER.."/auth",Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode({key=KEY,hwid=hwid(),script=SCRIPT_ID,nonce=nonce})})
if not ok or not res or not res.Body then fail("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้") end
local ok2,data=pcall(function() return HttpService:JSONDecode(res.Body) end)
if not ok2 or type(data)~="table" then fail("เซิร์ฟเวอร์ตอบผิดพลาด") end
if data.nonce ~= nonce then fail("ตรวจพบการดัดแปลง (response ปลอม)") end
if data.allowed and data.code then local fn,e=loadstring(data.code) if not fn then fail("โหลดสคริปต์ไม่ได้: "..tostring(e)) end return fn() end
local R={["invalid key"]="คีย์ไม่ถูกต้อง",["expired"]="คีย์หมดอายุแล้ว",["banned"]="คีย์ถูกแบน",["hwid mismatch"]="คีย์นี้ผูกกับเครื่องอื่น กด Reset HWID ก่อน",["key not for this script"]="คีย์ผิดสคริปต์"}
fail(R[data.reason] or data.reason or "ยืนยันคีย์ไม่สำเร็จ")