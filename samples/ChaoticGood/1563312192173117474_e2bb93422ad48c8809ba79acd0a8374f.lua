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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=4641ab0b4c0ceac2"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=4641ab0b4c0ceac2"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\101\50\98\98\57\51\52\50\50\97\100\52\56\99\56\56\48\57\98\97\55\57\97\99\100\48\97\56\51\55\52\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\49\79\55\81\100\114\70\65\103\89\80\97\71\113\57\51\58\84\97\89\69\113\54\78\105\122\68\120\55\97\115\89\72\79\55\79\76\112\103\58\117\82\120\90\78\55\87\122\79\68\45\56\72\84\80\86\115\118\85\70\113\56\66\50\120\56\85\65\83\57\121\72\98\65\75\110\50\87\116\81\102\101\121\50\114\108\54\66\105\77\85\54\85\73\45\53\112\85\105\105\52\78\103\90\106\98\68\78\78\68\108\111\97\104\106\81\106\65\85\87\97\78\85\115\111\89\106\71\100\69\106\113\95\112\122\68\105\67\68\83\66\77\119\114\48\51\98\76\95\50\74\50\114\97\57\116\79\84\57\99\67\121\99\90\50\95\110\105\70\110\48\82\99\52\56\89\122\68\82\72\109\68\122\78\106\89\103\70\116\48\57\99\115\72\67\114\55\80\89\74\52\57\65\113\52\119\57\74\119\86\89\98\100\86\67\122\108\104\112\77\72\81\55\50\69\99\114\117\73\106\45\74\107\85\112\95\101\88\103\117","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\226\171\123\109\223\24\95\192\193\36\82\120\195\4\100\197\1\125\104\123\13\237\80\242\184\1\115\254\65\139\79\100\131\58\188\83\94\32\31\43\22\239\250\126\168\158\95\52\254\248\246\133\148\2\61\119\154\118\29\80\137\179\39\23\121\194\171\61\232\148\219\109\195\139\59\56\32\214\133\149\184\165\90\35\141\15\149\133\181\75\130\238\51\105\202\150\68\224\209\122\191\150\235\19\231\136\217\140\239\200\110\85\36\12\126\68\228\212\112\90\178\239\46\170\219\201\10\133\116\123\148\162\110\233\240\75\180\161\186\98\241\167\36\185\164\218\134\46\29\151\118\170\32\170\100\155\120\89\33\140\10\203\1\253\32\197\169\168\202\141\198\178\88\60\88\21\39\6\171\83\29\55\150\129\76\44\6\26\155\118\107\122\201\173\16\158\39\70\77\201\1\45\125\237\179\106\194\234\185\253\137\171\57\113\8\124\126\100\76\209\27\20\240\172\101\48\90\93\122\176\187\236\246\11\206\19\217\126\65\33\51\43\132\195\26\47\165\233\212\225\46\174\48\207\212\158\128\166\65\171\217\51\110\246\110\64\37\222\117\131\70\229\250\147\8\131\176\174\142\122\4\211\215\53\213\57\65\110\15\17\244\145\46\80\205\87\171\231\25\112\67\218\40\115\216\195\89",554818023,887972288} or {"\143\126\172\248\129\73\194\130\174\241\4\74\107\104\67\239\31\117\97\169\72\65\6\10\17\190\236\133\9\199\107\50\145\171\181\84\247\212\227\91\167\140\123\69\252\189\79\14\250\56\35\24\252\219\47\189\239\154\39\230\67\14\27\200\251\107\110\16\38\154\3\15\75\12\204\1\188\54\32\209\11\118\67\82\81\213\159\231\200\38\172\104\175\3\38\5\203\76\213\220\158\169\78\253\68\232\251\180\105\36\205\236\147\155\20\246\1\103\51\73\150\242\238\105\157\67\96\176\11\231\158\60\200\197\101\22\170\216\228\9\184\169\255\170\187\116\42\15\147\23\237\135\102\51\164\177\47\7\165\248\115\109\41\225\204\56\28\247\46\126\179\50\143\193\205\71\39\183\95\33\17\89\242\168\189\22\147\104\14\91\7\99\60\231\211\1\22\169\59\173\255\129\47\107\237\76\60\141\70\147\77\128\33\160\163\235\130\116\235\107\56\168\251\100\157\42\172\145\186\25\13\207\69\231\105\250\55\176\207\149\141\239\133\82\58\4\238\158\17\233\120\46\253\74\69\185\119\181\111\43\124\236\129\51\40\218\15\170\205\191\130\122\30\248\85\140\172\86\41\106\41\95\211\252\49\246\57\179\10\157\105\61\20\26\198\254\194\34\32\68\87\178\169\87\46",3265872460,580543439}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
