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
local fresh=url.."?retry=6a75a65e73a975e1"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=6a75a65e73a975e1"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\97\52\98\98\57\49\98\52\48\97\102\98\100\102\99\52\102\51\53\56\97\100\49\49\57\51\57\98\99\50\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\90\73\85\45\54\110\72\65\68\114\95\104\89\86\82\57\58\71\104\101\75\81\74\74\109\99\84\95\120\109\103\84\70\105\116\87\118\100\103\58\103\54\78\95\90\99\78\115\69\112\71\122\97\101\74\118\88\66\53\50\122\119\79\99\119\95\82\116\70\110\99\112\67\52\51\82\101\110\77\99\70\116\100\90\117\102\54\110\106\105\72\99\106\70\49\111\102\82\66\57\81\105\78\73\68\105\116\102\69\103\118\101\54\54\90\56\72\89\89\55\113\52\77\81\45\70\77\53\86\111\70\77\55\121\66\67\83\110\88\116\84\72\98\117\112\84\119\51\97\117\45\67\49\72\118\82\111\51\112\117\98\54\97\105\113\102\114\84\57\81\52\117\86\106\66\114\48\48\112\105\52\95\52\100\114\101\52\120\81\101\99\117\54\110\68\99\74\76\90\56\89\57\57\74\105\110\89\113\79\101\114\55\76\118\55\55\114\113\90\54\66\105\57\87\118\68\45\107\78\95\70\117\121\102\111\112\90\73\75\74","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\28\161\15\180\229\48\253\209\90\58\142\248\14\248\89\185\74\216\154\185\212\208\227\114\105\19\212\146\237\1\172\188\167\248\125\80\183\244\48\168\221\46\77\1\58\149\234\3\67\1\201\255\222\78\138\251\9\212\245\148\109\83\0\116\223\76\140\110\184\58\186\8\233\92\254\123\74\116\175\197\120\14\152\48\202\199\126\155\21\186\254\140\103\31\245\102\201\184\203\14\119\175\119\28\89\106\15\146\209\193\56\126\223\254\203\73\116\186\36\178\187\163\192\215\2\243\24\214\64\68\64\119\8\31\179\242\95\106\77\106\211\184\215\198\209\253\223\147\37\29\106\22\155\40\180\120\241\18\3\131\104\222\245\2\19\77\218\43\42\172\164\45\145\66\197\38\32\235\68\132\46\161\104\110\26\228\97\139\145\58\238\76\68\49\120\66\21\247\162\96\177\70\83\90\55\62\125\26\210\145\244\80\241\195\238\224\111\12\190\59\64\5\121\117\222\242\253\14\72\207\205\119\165\133\133\29\231\123\178\27\139\170\146\130\199\176\177\86\181\137\123\48\114\126\196\2\220\39\44\116\241\190\99\231\167\52\29\203\170\2\240\129\63\88\78\105\14\156\81\134\184\99\62\11\75\110\177\163\113\182\40\16\4\141\181\209\137\2\172\172\145\217\10\239\58\87\146",172358217,3935593375} or {"\131\204\152\146\144\119\137\128\101\217\126\64\237\199\189\233\155\228\175\188\245\193\82\165\219\107\242\71\92\61\100\143\39\4\211\155\130\65\41\63\90\123\0\12\181\83\10\113\250\199\121\168\51\246\35\121\22\216\152\188\164\60\201\61\233\205\142\117\14\226\155\19\182\34\63\106\164\217\87\155\58\14\153\112\130\147\129\140\237\144\26\196\220\115\222\220\17\36\106\154\235\92\222\135\114\165\42\233\88\45\186\54\76\241\156\196\248\4\202\100\83\167\108\75\126\67\116\94\195\137\221\98\242\102\232\199\14\56\87\180\249\194\147\37\244\209\41\210\122\159\119\109\7\201\204\88\91\1\232\239\17\144\31\129\250\184\194\102\82\112\210\31\92\216\106\157\98\240\240\126\29\11\83\144\198\8\41\161\167\158\108\247\112\81\18\223\66\239\213\54\157\236\71\36\91\82\240\11\165\2\91\119\61\226\164\125\132\225\108\44\33\198\143\209\2\210\71\222\83\209\56\152\181\111\34\112\219\3\254\73\90\234\244\221\135\164\172\106\129\33\30\141\213\90\98\55\88\216\54\43\157\25\227\119\13\24\53\185\233\190\76\33\222\252\126\141\59\9\4\232\0\239\146\63\141\247\73\10\208\177\174\219\232\168\145\179\105\27\232\180\237\103\217\11\167",447663141,3611387310}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
