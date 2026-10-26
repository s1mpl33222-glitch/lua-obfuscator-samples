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
local fresh=url.."?retry=460698675b40e44d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=460698675b40e44d"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\48\100\55\51\98\57\97\50\53\54\53\56\51\56\56\48\98\52\49\54\98\52\54\50\99\53\52\56\54\49\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\65\45\108\45\50\56\70\80\118\89\101\114\53\99\100\101\58\115\48\98\56\86\85\82\81\65\53\56\108\71\67\101\67\99\81\98\78\51\65\58\80\102\122\78\49\104\87\70\69\84\86\65\65\48\72\67\108\52\107\51\106\120\102\72\108\57\70\112\71\77\70\118\95\101\87\86\119\105\88\72\45\73\104\68\100\121\68\90\118\99\100\65\103\115\55\90\110\103\78\79\90\114\103\49\105\109\73\51\54\104\113\54\101\117\114\75\50\115\54\105\102\84\113\105\51\51\71\89\74\86\109\67\100\109\98\89\112\69\52\89\99\120\107\77\110\56\116\55\52\72\74\118\116\117\100\89\95\77\99\77\122\67\56\70\86\115\69\108\76\100\118\111\69\71\97\66\121\67\84\82\90\73\98\87\71\50\68\76\84\82\116\103\74\74\49\109\106\45\89\108\57\100\95\83\116\72\100\88\48\87\87\72\122\97\109\99\119\117\79\53\99\95\102\68\85\90\108\103\75\54\78\89\104\102\108\98\105\95\68\107","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\143\203\247\160\176\232\21\132\144\190\171\75\76\48\103\210\190\116\38\95\43\241\10\120\186\143\209\232\85\91\161\23\38\20\34\126\220\74\69\222\51\101\0\232\81\15\121\189\127\5\68\191\22\191\214\214\43\236\157\143\65\78\167\225\232\178\224\152\55\76\103\52\205\192\220\8\227\104\47\221\252\35\21\197\136\226\146\109\200\98\191\228\90\5\184\158\65\104\159\131\169\183\247\18\61\103\147\23\73\115\115\248\127\223\21\172\79\243\238\184\34\208\213\114\191\94\239\122\181\205\101\132\144\98\70\134\14\251\199\58\171\10\132\234\102\28\227\104\25\246\22\147\17\246\174\181\108\139\94\106\30\12\52\25\45\67\254\231\103\187\33\193\10\229\228\168\240\185\92\150\239\216\144\237\156\235\100\2\53\228\29\14\27\165\29\255\165\77\191\166\35\147\201\207\157\114\57\145\111\186\62\36\106\153\49\194\79\179\234\123\77\248\143\135\173\182\59\12\188\77\180\123\178\37\250\95\22\6\226\221\254\154\47\197\26\1\55\1\117\211\248\58\171\7\65\15\19\131\15\182\100\35\125\120\29\174\131\91\95\154\127\199\44\201\0\53\161\138\139\80\33\146\181\206\136\183\221\145\189\14\112\18\136\67\46\203\251\186\206\133\223\143\156\124\251\194\51",826213884,2958582016} or {"\15\13\211\162\104\0\161\131\68\156\109\112\35\181\109\183\95\127\131\14\228\139\47\22\214\134\58\251\115\101\235\172\21\243\172\13\229\200\189\89\68\47\233\47\2\96\13\243\161\249\166\91\107\38\94\215\134\86\206\119\58\203\5\246\81\173\97\19\130\123\201\163\41\31\238\27\168\18\38\207\119\122\30\30\14\37\49\205\103\22\212\234\102\102\57\168\10\17\218\11\142\102\98\141\224\50\129\84\12\207\184\146\148\250\237\9\92\137\155\255\208\202\171\244\179\198\212\199\141\154\143\96\130\101\204\112\85\229\132\6\247\234\61\151\44\31\142\21\246\132\60\177\18\10\112\103\181\150\4\0\229\73\106\44\31\37\30\221\173\4\231\13\140\177\190\55\76\21\250\200\44\57\95\30\60\38\135\48\60\34\239\154\94\20\91\31\49\150\59\208\241\163\30\182\185\51\94\234\251\150\236\68\128\102\124\146\255\177\61\32\147\53\202\143\145\207\19\213\41\111\57\253\159\176\122\33\109\205\150\109\48\128\122\217\190\170\243\59\33\103\68\29\120\163\187\216\129\53\71\107\101\119\85\28\152\218\12\43\156\119\141\54\200\150\170\96\69\42\24\132\141\82\135\33\175\81\153\20\159\43\27\98\197\116\48\124\79\209\16\163\191\128\78\20\191",1670800677,2689295119}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
