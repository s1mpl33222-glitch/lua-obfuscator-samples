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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=7641f38cfed505c4"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=7641f38cfed505c4"
local expected=618951
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
if s2*65536.0+s1~=733717851 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\52\90\120\114\67\103\83\78\110\53\119\78\56\120\118\51\58\65\122\104\116\78\103\112\90\78\70\87\98\102\102\121\110\69\105\106\85\75\119\58\110\56\78\57\109\97\68\106\102\115\56\49\89\118\84\66\88\48\115\68\68\71\84\110\56\73\85\50\77\82\49\56\86\50\111\106\68\90\108\85\95\110\110\51\52\50\71\68\97\106\111\114\119\74\82\81\112\90\72\55\116\56\72\97\81\110\53\52\71\45\98\98\98\89\85\89\78\100\115\86\110\67\113\52\104\82\56\50\45\75\73\56\120\78\86\112\117\66\82\87\53\102\114\51\121\56\84\116\69\110\103\111\87\105\99\99\87\49\75\111\105\86\70\99\49\78\56\106\102\83\90\85\82\49\79\98\79\122\110\82\75\55\83\56\69\85\118\72\66\88\104\71\108\98\71\109\66\118\67\121\100\69\97\121\100\97\122\86\73\119\56\78\112\105\71\50\45\83\86\120\110\45\85\121\48\53\56\89\73\81\78\70\121\119\85\65\73\112\86\115","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\157\217\227\73\230\211\221\226\154\249\213\1\0\66\35\15\88\191\114\93\224\25\160\226\244\3\131\27\71\96\102\245\154\168\65\92\148\17\156\23\139\109\162\202\65\124\182\110\32\135\219\71\1\92\106\50\236\181\185\88\89\239\230\171\216\150\199\161\155\227\95\138\44\185\60\88\174\186\163\99\121\101\92\9\130\206\189\205\225\242\189\41\110\67\201\142\129\221\195\66\133\66\205\149\156\186\100\96\237\162\173\188\148\242\37\186\184\174\73\17\63\125\44\74\59\111\226\55\247\227\255\209\110\205\152\109\213\174\255\16\140\125\102\168\91\82\154\53\165\215\53\197\82\10\97\246\36\216\9\84\198\62\209\172\110\196\211\41\124\85\214\167\27\170\100\54\183\39\103\162\48\191\207\129\28\127\71\90\33\134\167\63\5\133\197\123\85\246\197\111\250\171\140\180\36\20\40\231\31\20\141\98\10\14\21\122\50\10\122\53\138\148\177\186\96\26\223\22\98\20\59\135\179\123\140\241\110\104\17\88\131\78\21\78\103\121\34\42\59\18\107\20\234\134\216\174\33\221\52\12\191\213\38\227\211\205\3\183\90\15\61\23\119\203\117\112\137\232\1\220\252\1\198\176\90\242\43\220\35\37\47\11\6\62\70\188\96\62\17\21\201\16\91\168\166\68\194",3898974118,2244501972} or {"\187\147\16\52\144\49\225\255\186\158\177\21\132\233\62\212\19\160\92\122\83\194\87\31\161\5\137\153\243\19\198\109\95\157\151\196\164\61\177\169\234\184\132\68\3\47\81\63\134\9\158\159\212\87\16\126\152\108\119\99\122\96\61\177\130\236\133\167\240\201\185\216\174\173\168\233\66\133\15\20\228\252\246\123\43\225\25\237\58\176\117\102\241\24\80\161\111\34\255\73\150\50\28\73\155\73\222\191\221\17\4\137\188\150\38\208\33\15\116\247\179\186\122\196\218\135\125\199\171\78\138\5\13\190\39\129\239\33\186\231\169\34\98\224\227\58\151\145\175\109\225\7\238\41\140\201\221\68\3\242\132\20\188\204\200\195\37\175\236\44\158\74\124\186\38\75\232\227\43\240\207\121\104\72\108\59\236\220\145\174\67\30\82\135\103\167\114\127\197\53\116\34\11\244\99\184\141\195\242\46\92\38\245\152\115\254\7\210\94\18\67\206\129\9\148\206\228\72\79\214\46\92\44\90\126\40\169\253\217\174\25\24\154\37\88\38\194\246\115\246\197\188\232\254\149\65\114\33\180\66\173\70\107\105\37\60\146\160\114\85\184\167\213\61\152\84\140\59\233\107\186\226\8\35\222\28\153\122\115\84\192\88\92\75\86\210\46\249\50\243\71\71\71\112\210",3089978276,1943888867}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
