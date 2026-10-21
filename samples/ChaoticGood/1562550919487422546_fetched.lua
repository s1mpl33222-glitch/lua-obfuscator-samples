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
local fresh=url.."?retry=bb4271016d6e8e2f"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=bb4271016d6e8e2f"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\54\71\118\72\118\78\109\49\99\117\79\50\81\95\118\95\58\80\80\97\113\109\95\76\85\86\104\83\122\106\102\109\79\67\86\108\84\89\65\58\111\55\101\79\110\85\78\45\104\118\120\114\117\45\85\89\45\85\113\104\99\72\112\104\72\113\80\81\116\48\81\117\85\65\89\55\115\112\86\66\54\54\113\70\121\89\87\108\53\99\97\100\78\86\67\69\101\81\83\122\49\65\88\87\69\97\116\111\69\57\77\117\81\117\110\71\76\45\70\69\122\103\121\53\75\104\67\57\52\83\102\118\101\54\73\122\52\48\73\54\48\117\57\78\106\80\69\97\109\50\73\66\109\49\84\109\83\80\86\102\81\83\122\80\104\117\48\109\74\103\86\98\78\54\106\75\51\70\98\66\87\81\103\68\84\52\98\78\80\79\83\85\98\77\78\87\115\78\107\54\53\52\114\118\115\68\51\112\51\75\122\119\85\52\122\102\102\79\114\54\109\79\49\120\79\68\84\88\49\88\108\81\108\105\99\101\81\104\72\87","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\115\21\117\249\239\176\252\107\7\148\243\33\85\148\212\49\54\56\149\176\31\182\200\182\83\175\171\183\50\4\75\216\125\165\1\114\164\252\93\76\103\203\237\234\0\1\14\245\99\151\227\159\237\172\171\167\8\118\41\43\181\65\232\77\195\60\142\238\231\79\51\195\119\92\105\107\115\105\15\241\154\28\138\134\100\236\125\60\17\26\141\246\24\87\219\228\131\29\34\186\32\123\47\183\48\175\230\51\129\197\204\242\80\104\174\108\12\130\20\49\122\94\86\168\101\173\78\68\50\204\151\181\109\173\42\72\179\243\156\198\31\22\133\96\70\254\142\111\6\70\177\24\26\226\230\221\91\5\107\209\110\106\252\210\41\12\190\24\197\54\3\133\67\125\80\46\221\68\126\91\253\34\103\182\116\248\21\98\157\62\199\93\98\125\61\138\6\41\106\152\21\227\102\200\138\92\94\32\117\58\117\198\82\124\35\90\163\28\4\127\14\183\28\194\59\119\92\24\16\248\122\84\149\238\55\243\194\16\75\30\82\122\39\217\56\64\142\56\88\108\61\94\27\159\1\64\99\54\87\218\23\16\202\221\158\1\103\49\71\35\127\19\99\42\217\125\220\39\193\180\57\99\126\4\111\35\22\229\201\119\67\206\231\133\147\76\221\8\198\184\173\219\153\201\198\165\20",3337004871,3881853461} or {"\60\26\148\126\230\168\74\153\157\229\29\213\204\177\99\240\86\26\47\205\235\228\86\199\133\64\102\240\252\246\238\43\192\232\248\26\39\53\215\74\222\117\10\61\175\17\199\92\241\82\205\72\175\192\108\26\192\122\58\248\84\110\112\224\36\160\179\178\188\172\41\17\208\218\47\73\122\19\8\85\209\214\236\178\79\58\204\144\141\225\164\213\18\105\241\136\14\200\219\249\142\250\197\96\167\193\238\163\61\154\140\94\63\211\12\28\170\2\98\134\14\19\209\131\148\237\49\239\250\203\76\134\2\8\173\77\44\104\225\64\71\104\181\56\128\142\128\158\230\69\155\212\175\251\30\220\170\133\70\164\161\241\100\216\187\239\16\96\57\53\174\208\25\178\243\8\121\228\48\56\70\47\148\102\241\16\193\44\186\251\239\130\183\214\184\84\184\99\59\242\84\155\87\98\15\51\213\231\36\10\212\175\158\112\123\168\252\110\197\203\52\62\34\135\216\30\23\206\156\17\74\57\119\205\53\60\150\62\108\197\194\83\37\64\6\38\137\66\202\55\76\83\126\87\123\39\178\252\122\204\153\52\158\166\246\159\102\183\231\246\240\82\160\113\248\246\201\72\17\68\118\124\60\250\35\152\160\224\238\70\208\180\114\87\20\40\125\206\59\123\245\213\134\255\183",3373169621,3579536420}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
