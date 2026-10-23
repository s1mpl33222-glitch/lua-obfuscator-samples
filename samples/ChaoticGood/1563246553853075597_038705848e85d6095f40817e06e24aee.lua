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
local fresh=url.."?retry=adc173e108f27c25"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=adc173e108f27c25"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\51\56\55\48\53\56\52\56\101\56\53\100\54\48\57\53\102\52\48\56\49\55\101\48\54\101\50\52\97\101\101","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\105\57\112\122\84\54\114\109\73\118\112\106\120\84\87\56\58\109\120\98\51\90\53\66\121\67\75\84\120\102\76\97\54\54\103\84\55\116\81\58\54\45\75\107\109\116\48\90\113\49\87\55\105\72\74\80\83\104\70\97\107\113\77\108\100\48\95\106\45\88\84\49\80\115\76\83\111\118\78\51\77\51\66\75\86\78\51\106\114\98\81\110\68\82\53\121\105\118\103\119\87\119\68\118\69\85\52\121\115\49\75\89\70\68\103\54\48\49\121\107\102\119\111\121\122\70\87\48\95\108\70\70\99\116\97\84\97\78\78\95\110\95\51\122\112\51\74\116\90\114\77\88\88\89\116\105\71\52\73\90\78\72\72\77\55\116\101\84\86\45\115\104\80\81\111\79\111\73\121\66\100\75\48\70\82\82\84\102\80\66\68\105\78\79\104\53\90\54\54\120\86\70\112\108\55\87\57\55\66\95\72\89\51\52\57\119\100\88\76\77\57\108\66\115\115\113\57\89\113\116\88\53\72\80\105\108\55\113\98\100","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\70\182\6\64\215\8\214\101\229\130\58\143\81\40\156\199\38\183\113\15\39\12\99\208\232\162\115\247\49\254\40\131\201\81\81\24\117\142\18\208\233\71\237\81\16\147\154\49\140\192\245\47\60\83\216\67\70\193\65\164\0\154\201\37\104\214\93\241\237\115\78\39\235\31\59\47\189\230\34\241\196\183\252\46\163\158\128\138\107\54\247\237\2\145\125\9\248\142\170\110\125\76\160\20\227\106\141\149\59\49\113\68\108\52\136\14\83\211\30\229\6\37\115\133\136\120\212\21\92\72\179\202\27\119\31\245\48\200\3\225\27\106\94\117\148\177\81\161\76\75\80\139\76\141\214\159\218\5\239\189\134\193\62\28\180\166\54\12\40\67\143\54\11\175\209\103\203\136\152\89\98\14\230\97\20\154\36\192\221\102\87\239\58\174\179\154\60\109\124\101\104\163\48\63\102\171\117\130\233\0\63\7\220\184\2\163\137\127\37\76\199\242\135\114\106\209\251\126\31\180\247\216\189\147\239\6\64\161\46\221\218\51\237\186\90\199\15\186\49\162\78\59\180\219\162\119\29\25\109\95\195\55\149\112\236\135\150\6\56\80\190\174\123\173\204\57\96\201\249\105\12\74\31\186\136\84\208\110\195\240\122\190\131\121\7\91\31\10\27\5\45\66\157\185\128\20\111",2373444170,4059914580} or {"\105\152\174\169\164\243\22\51\176\24\112\152\160\230\187\172\249\19\21\195\219\208\171\51\70\66\48\118\218\44\36\43\220\151\7\255\145\83\7\228\15\104\230\53\62\18\4\41\210\160\201\198\143\185\231\127\167\67\112\26\62\42\73\234\49\158\4\251\148\119\175\238\61\33\204\215\101\58\83\138\16\143\150\163\99\17\50\175\117\48\137\17\95\110\6\30\247\121\107\35\204\40\104\8\238\56\111\98\208\123\103\214\176\210\248\202\115\112\22\89\197\77\219\53\233\194\134\136\183\107\84\65\45\164\28\117\231\225\173\231\183\195\120\147\16\160\125\95\228\78\160\105\238\9\67\189\207\171\203\63\141\109\191\8\66\163\213\143\15\163\123\174\138\203\216\31\31\235\85\188\243\223\85\182\2\122\62\202\191\118\31\101\112\40\247\104\30\109\13\128\248\27\140\8\238\205\198\110\187\179\57\197\1\179\7\90\107\175\56\81\219\39\28\17\7\234\74\169\190\219\234\72\161\225\226\234\151\21\58\73\36\189\225\76\200\172\242\131\17\160\163\194\221\117\12\133\93\35\229\164\182\165\66\61\53\60\245\151\103\175\101\87\239\73\160\189\198\135\243\104\209\78\94\250\224\56\142\221\47\246\234\123\85\45\35\241\225\186\37\187\57\185\190\241\32",3121629578,3782370147}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
