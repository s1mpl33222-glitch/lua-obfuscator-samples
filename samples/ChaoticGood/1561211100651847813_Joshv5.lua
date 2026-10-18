local credential=...
local type,pcall,error,tostring,tonumber=type,pcall,error,tostring,tonumber
local rawset,getfenv=rawset,getfenv
local globals,host=_G,game
local byte,gsub,find=string.byte,string.gsub,string.find
local wait=type(task)=="table"and task.wait
local clock=os.clock
local compile=loadstring
local function member(value,key)
local ok,result=pcall(function()return value[key]end)
if ok then return result end
end
local keyless=false
if keyless then
credential=""
elseif type(credential)~="string"then
for lv=2,4 do
local f,sc=pcall(getfenv,lv)
local v=f and type(sc)=="table"and member(sc,"script_key")
if type(v)=="string"then credential=v;pcall(rawset,sc,"script_key",nil);break end
end
end
local spawn=member(task,"spawn")
local fetch=member(host,"HttpGet")
local ok,senv=pcall(function()return getfenv()end)
if not ok or type(senv)~="table"then senv=globals end
local ok,environment=pcall(function()return getgenv()end)
if not ok or type(environment)~="table"then environment=senv end
local function global(key)return member(environment,key)or member(senv,key)or member(globals,key)end
local sample=20
local platform="?"
pcall(function()
local input=host:GetService("UserInputService")
platform=input.TouchEnabled and not input.KeyboardEnabled and"m"or"d"
end)
local function ms(x)return math.floor(x*1000+.5)end
local reqs,seen={},{}
local function add(fn,name)
if type(fn)=="function"and not seen[fn]then seen[fn]=true;reqs[#reqs+1]={fn,name}end
end
add(global("request"),"request")
add(global("http_request"),"http_request")
add(global("httpRequest"),"httpRequest")
add(global("httprequest"),"httprequest")
add(member(global("http"),"request"),"http.request")
add(member(global("syn"),"request"),"syn.request")
local bt=member(global("buffer"),"tostring")
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=0bc645f161fdd414"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=0bc645f161fdd414"
local expected=622786
local runtime,reason,issue,pr=nil,nil,"request failed",0
local transport,issueTransport="HttpGet","HttpGet"
local function problem(message,rank)
if rank>=pr then issue,pr,issueTransport=message,rank,transport end
end
local arrived,ck,cm=0,0,0
local function accept(value)
local began=clock()
if type(value)=="buffer"then local ok,text=pcall(bt,value);value=ok and text or nil end
if type(value)~="string"then problem("unsupported response body",1);return end
if #value~=expected then
if #value<1024 and find(value,"Failed to send HTTP request.",1,true)then
problem(find(value,"timed out",1,true)and"HTTP request timed out"or"HTTP request failed",2)
else problem("received "..#value.." bytes; expected "..expected,2)end
return
end
local s1,s2,i=1.0,0.0,1
while i+7<=#value do
local a,b,c,d,e,f,g,h=byte(value,i,i+7)
s2=(s2+8*s1+8*a+7*b+6*c+5*d+4*e+3*f+2*g+h)%65521
s1=(s1+a+b+c+d+e+f+g+h)%65521;i=i+8
end
while i<=#value do s1=(s1+byte(value,i))%65521;s2=(s2+s1)%65521;i=i+1 end
if s2*65536.0+s1~=2050046860 then problem("runtime checksum mismatch",3);return end
local t=clock();ck=t-began
local ok,compiled,detail=pcall(compile,value,"=FlowAuthRuntime")
local text=not(ok and type(compiled)=="function")and tostring(ok and detail or compiled)
if text and not(find(text,"FlowAuthRuntime:")or find(text,"xpected")or find(text,"syntax"))then
if wait then pcall(wait,1.5)end
ok,compiled,detail=pcall(compile,value,"=FlowAuthRuntime")
end
cm=clock()-t
if ok and type(compiled)=="function"then runtime=compiled;return true end
reason=(ok and detail or compiled)or"compiler returned no function";issueTransport=transport
return false
end
local candidates={{fetch,"HttpGet",url}}
if fallback~=""then candidates[#candidates+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then candidates[#candidates+1]={candidate[1],candidate[2],fallback,true}end
candidates[#candidates+1]={candidate[1],candidate[2],pinned}
end
candidates[#candidates+1]={fetch,"HttpGet",retry}
local started,ni,ls=clock(),1,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=candidates[ni];ni=ni+1;ls=clock()
local job={name=candidate[2],alternate=candidate[4]};js[#js+1]=job
local function run()
if shut or job.started then return end
job.started=true
local ok,response
if job.name=="HttpGet"then ok,response=pcall(candidate[1],host,candidate[3])
else ok,response=pcall(candidate[1],{Url=candidate[3],Method="GET"})end
if not shut then job.ok,job.response,job.done=ok,response,true end
end
if asynchronous then
local ok,thread=pcall(spawn,run);job.thread=ok and thread or nil
if not job.started and type(job.thread)~="thread"then asynchronous=false;run()end
else run()end
end
launch()
for poll=1,2000 do
if clock()-started>=40 then problem("HTTP download timed out after 40 seconds",4);break end
local active,completed=0,false
for i=1,#js do
local job=js[i]
if not job.done then active=active+1
elseif not job.read then
job.read=true;completed=true;transport=job.name;arrived=clock()-started
local response=job.response;job.response=nil
if not job.ok then problem("request failed",1)
elseif type(response)=="table"then
local status=tonumber(member(response,"StatusCode")or member(response,"status_code")or member(response,"Status")or member(response,"status"))or 0
local success=member(response,"Success");if success==nil then success=member(response,"success")end
if status==0 and success==true then status=200 end
if success==false and status<400 then status=500 end
if status>=200 and status<300 then accept(member(response,"Body")or member(response,"body")or member(response,"ResponseBody")or member(response,"response_body"))
else problem("HTTP "..status,2)end
else accept(response)end
if runtime or reason then alternate=job.alternate;break end
end
end
if runtime or reason or(active==0 and ni>#candidates)then break end
if ni<=#candidates and(active==0 or(active<2 and(completed or clock()-ls>=8)))then launch()
elseif not asynchronous or not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\100\99\52\55\55\50\52\57\101\55\55\56\48\54\97\102\101\51\97\51\57\102\48\54\101\99\100\50\98\97\97\48","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\119\82\87\66\66\112\71\67\72\45\119\68\69\82\116\77\58\72\51\87\84\106\84\109\76\78\53\113\112\52\75\121\90\65\99\52\95\106\119\58\54\54\57\100\120\52\79\110\48\85\101\109\76\70\48\87\102\97\99\120\45\75\116\110\99\115\95\79\73\114\83\119\99\107\48\99\57\72\73\111\121\54\87\53\101\106\121\45\114\101\89\104\53\95\99\86\51\109\65\83\89\113\71\113\101\106\74\51\81\122\69\77\97\48\73\55\88\118\114\56\52\53\109\80\77\113\95\105\89\67\97\110\88\67\102\112\116\109\86\80\119\100\97\120\67\105\85\112\79\57\57\106\73\103\114\108\67\75\80\106\82\72\68\113\99\85\51\54\88\87\97\98\80\84\115\102\101\117\85\79\97\67\112\90\72\109\76\120\77\107\68\104\116\97\52\84\65\86\83\48\50\106\119\74\88\53\70\50\56\57\98\78\122\101\49\54\121\111\100\53\79\87\90\87\53\73\122\101\110\52\101\110\74\69\87\102\109\49\101\87","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if fetch then pcall(fetch,host,target)elseif reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
end)
end
if not runtime then
pcall(function()
local text=gsub(issueTransport..": "..tostring(reason or issue),"[^%w .:;,()=/_-]","?")
local body=(reason and"launcher_load"or"launcher_download")..'","executor":"launcher","diag":["pf='..platform..'"],"error":"'..string.sub(text,1,160)..'"}'
for _,base in ipairs{url,fallback}do
if base~=""then send(base,"/v1/telemetry/executor",body)end
end
end)
if reason then error("FlowAuth runtime compilation failed: "..tostring(reason),0)end
error("FlowAuth runtime download failed ("..issueTransport.."): "..tostring(issue)..". Please run the loader again.",0)
end
if sample>0 and spawn and math.random(sample)==1 then
pcall(send,alternate and fallback or url,"/v1/telemetry/load",'load","pf":"'..platform..'","tp":"'..transport..'","fb":'..(alternate and 1 or 0)..',"tr":'..#js..',"dl":'..ms(arrived)..',"ck":'..ms(ck)..',"cm":'..ms(cm)..',"w":'..sample..'}',2)
end
if asynchronous then pcall(wait)end
local handoff=alternate and {"\93\208\238\141\25\32\194\165\71\95\3\85\60\29\26\47\170\87\65\167\169\159\149\232\82\169\111\95\142\127\88\94\27\143\218\141\153\231\242\43\110\57\32\188\71\158\81\249\22\112\137\44\232\78\235\47\30\85\4\31\89\128\105\7\33\237\86\81\91\26\158\24\39\201\247\254\196\197\217\225\96\168\136\8\94\250\28\13\142\168\45\216\99\54\158\119\252\143\229\43\122\107\239\230\104\48\196\248\224\51\126\199\67\64\247\216\194\68\243\174\64\26\92\186\63\150\127\174\114\102\100\217\188\167\82\151\79\173\201\2\136\107\191\7\154\143\73\52\23\102\131\81\35\130\93\187\187\89\135\170\218\48\203\175\45\40\188\92\72\84\133\67\129\198\108\111\238\26\98\61\201\182\20\124\207\93\91\155\235\86\27\16\67\1\125\245\102\38\44\29\123\155\134\121\219\186\190\142\110\142\228\249\245\243\201\239\206\109\18\209\15\114\39\60\34\235\55\18\77\4\165\244\169\63\23\63\221\197\104\121\100\222\1\255\127\247\133\0\99\15\145\126\68\236\198\74\1\207\170\91\74\182\72\161\173\154\226\28\32\6\169\202\198\116\216\19\249\80\45\203\130\180\238\77\59\201\233\99\152\210\138\134\130\182\108\135\92\75\59\13\33\100\8\185\53\189\125",671941248,3978191519} or {"\215\190\138\31\18\20\140\61\3\31\254\5\38\233\107\95\138\198\45\161\191\159\167\249\40\50\211\106\75\152\72\209\115\154\40\247\49\156\185\248\217\181\146\153\189\190\42\0\13\255\189\47\175\243\32\143\115\241\232\164\188\245\130\224\82\39\91\40\82\44\39\251\74\52\145\214\10\136\248\240\218\108\192\166\31\230\147\13\214\147\250\31\166\31\183\13\165\7\238\17\62\151\174\247\150\1\187\76\165\207\45\120\88\202\57\32\52\125\15\116\207\235\205\202\101\206\230\68\212\58\233\176\127\69\124\39\67\133\74\30\103\210\20\63\16\166\33\51\242\6\155\191\61\169\165\228\141\128\252\200\38\16\186\7\69\184\217\102\7\186\126\79\208\251\30\130\85\173\225\239\213\65\167\99\166\248\133\220\79\86\200\236\141\205\174\163\58\190\118\113\167\142\42\235\27\147\27\136\126\209\181\30\255\128\54\152\84\49\88\129\100\135\244\197\146\161\254\169\54\84\169\132\218\183\14\152\19\156\12\7\229\211\185\252\31\89\181\244\145\13\44\175\132\197\189\158\20\101\68\236\39\147\111\181\211\42\12\104\132\144\135\124\67\136\22\219\220\158\112\230\130\11\224\100\198\145\127\14\210\26\92\235\206\177\17\113\157\174\124\67\228\57\145\124\226",727825975,3664602286}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
