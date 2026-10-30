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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=e27aa92e29da34ba"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e27aa92e29da34ba"
local expected=627508
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
if s2*65536.0+s1~=368677546 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\98\48\99\51\48\102\48\49\54\98\55\102\98\53\48\102\48\102\50\49\99\102\50\100\101\52\99\57\101\57\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\69\48\48\53\107\76\80\122\95\57\90\51\112\121\68\90\58\84\69\86\110\74\81\98\75\81\101\54\85\107\76\113\101\73\90\88\101\89\81\58\104\108\108\111\54\120\112\45\101\72\121\97\66\95\45\68\53\57\90\122\78\103\109\81\84\75\74\57\83\95\71\69\48\53\100\81\87\116\78\86\89\67\118\82\116\72\70\116\105\50\67\66\108\80\49\109\83\100\54\100\68\119\71\77\99\53\103\89\79\56\100\85\87\119\97\71\86\107\45\113\99\55\50\48\54\50\71\67\67\75\112\90\110\53\85\75\54\53\75\110\121\112\115\112\74\77\103\70\111\71\112\78\76\85\74\120\55\113\121\75\76\88\119\78\103\112\75\103\71\90\111\112\83\122\77\101\54\112\50\102\49\45\66\67\101\105\104\72\79\73\81\97\115\86\109\105\114\113\49\117\78\68\103\108\98\102\120\112\87\101\104\54\55\45\82\66\114\68\55\68\82\69\56\104\118\67\56\119\88\112\112\75\66\75\97\71\70\90\54\87","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\12\168\47\240\172\109\24\184\214\158\53\252\222\239\105\95\224\53\240\238\251\169\195\28\30\56\6\210\47\242\237\88\242\43\217\133\12\124\74\37\64\161\138\162\230\161\184\20\221\223\10\106\156\32\68\99\75\42\190\153\136\177\196\236\152\227\187\210\91\80\93\205\51\64\227\246\96\117\159\23\11\52\206\44\50\201\191\94\145\46\230\25\220\178\157\249\46\54\1\183\231\182\166\4\208\126\108\52\20\43\254\73\1\67\0\223\10\31\38\38\208\194\124\98\193\12\131\206\157\210\3\71\70\232\143\218\121\233\48\231\3\31\204\103\141\3\101\175\59\98\97\180\255\166\26\78\250\123\51\135\251\33\19\142\18\154\102\190\43\85\45\206\116\105\127\251\225\188\178\153\224\94\244\105\213\90\87\84\125\77\30\186\66\146\39\104\0\109\226\93\72\159\85\98\197\38\179\188\3\239\77\168\237\3\171\247\148\171\85\199\182\200\70\251\236\193\186\158\166\199\7\184\19\253\248\225\54\67\62\101\24\39\47\30\153\19\217\207\33\47\92\219\174\129\75\177\147\232\252\222\120\203\140\122\149\133\172\16\149\166\182\238\42\138\35\112\81\19\231\191\85\253\98\60\22\162\55\11\81\122\192\113\244\167\177\156\227\49\141\172\53\158\70\97\135\96\73",1676558856,768565575} or {"\34\110\141\226\66\117\94\153\6\79\31\193\248\130\69\26\51\2\164\206\137\137\249\0\209\136\33\181\226\141\195\203\51\108\38\184\170\89\30\82\239\110\68\131\176\184\202\84\124\208\182\192\72\4\68\49\234\236\93\140\253\174\140\233\5\114\101\161\35\217\82\250\202\9\124\203\125\50\251\43\205\55\61\100\181\208\9\117\26\29\6\153\254\143\156\100\243\19\188\245\246\24\154\158\141\42\128\93\172\252\169\244\143\251\33\45\209\227\200\4\39\195\219\46\68\10\125\37\181\156\255\95\6\227\224\235\25\35\230\163\246\222\131\228\33\49\152\86\9\30\209\60\255\94\218\4\167\123\185\84\218\106\166\125\207\8\157\16\7\68\52\133\245\29\126\125\87\251\255\120\246\163\76\115\173\181\13\98\27\183\255\190\31\197\171\117\181\103\16\203\132\15\235\154\186\96\181\223\50\1\203\119\237\126\51\242\153\213\181\114\204\117\51\174\5\60\243\201\89\153\131\201\103\109\195\10\2\162\156\27\211\137\1\76\223\49\135\101\130\155\5\1\29\159\77\208\79\228\219\176\171\22\2\49\223\33\67\184\134\202\243\16\118\137\13\216\177\244\232\107\150\37\126\218\173\84\169\205\229\209\107\186\126\4\168\101\57\20\98\241\228\132\235\42\130",2000532976,457073494}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
