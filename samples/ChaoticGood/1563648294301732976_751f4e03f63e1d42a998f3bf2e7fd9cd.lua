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
local fresh=url.."?retry=e28adf5e81c9082e"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e28adf5e81c9082e"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\53\49\102\52\101\48\51\102\54\51\101\49\100\52\50\97\57\57\56\102\51\98\102\50\101\55\102\100\57\99\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\116\120\100\69\71\109\71\85\78\71\57\87\76\122\121\117\58\51\122\107\102\105\102\115\106\68\80\85\56\74\53\107\75\106\79\53\83\121\65\58\72\106\56\71\51\118\51\90\52\108\100\80\117\50\80\87\106\68\77\111\110\45\50\68\97\98\88\105\74\118\51\98\74\48\68\48\76\73\90\115\83\118\122\95\56\119\120\110\97\95\117\120\97\51\57\116\52\49\68\77\50\109\103\75\120\78\86\117\113\112\52\68\90\65\54\76\68\105\74\100\108\120\118\57\100\90\65\71\107\99\45\119\45\104\52\50\85\79\69\115\90\54\73\106\67\82\56\108\83\111\84\118\101\72\95\100\67\97\83\99\77\66\49\67\114\53\79\115\72\80\120\97\107\55\48\54\113\79\88\81\75\106\84\80\57\121\86\74\78\102\119\76\118\57\81\102\122\86\102\76\121\109\86\73\90\70\121\67\104\83\104\45\113\90\53\104\50\98\90\99\114\97\70\104\95\108\108\89\104\51\116\79\122\87\53\73\49\69\68\101","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\60\82\33\248\204\125\127\203\224\76\210\57\181\134\81\77\83\164\97\85\67\66\18\118\218\138\234\40\29\1\121\246\237\26\13\19\184\228\8\183\95\29\73\252\4\175\84\159\51\7\227\95\157\59\222\235\56\250\165\240\101\145\254\145\92\224\116\97\28\176\69\46\68\247\148\229\220\124\164\87\30\101\75\162\199\58\80\136\13\79\213\56\54\126\142\242\54\25\38\82\244\145\86\171\235\45\85\181\20\242\60\99\41\166\192\223\255\32\7\102\112\201\8\73\28\225\141\113\70\119\212\180\243\184\71\203\95\174\72\21\147\10\75\174\84\237\173\91\168\138\126\64\56\37\16\72\127\51\249\32\61\241\71\142\169\99\49\84\189\65\233\197\212\13\192\60\47\128\37\161\229\2\60\92\141\184\220\247\27\163\187\233\72\37\241\164\210\155\97\93\182\213\0\25\15\162\78\46\254\170\172\68\13\0\196\45\51\215\142\222\208\251\30\201\136\199\218\235\214\95\228\185\31\59\38\230\132\39\169\83\85\116\90\252\15\244\127\192\176\189\108\186\68\51\27\144\229\4\147\203\124\62\198\191\91\161\145\82\220\180\94\247\87\63\116\223\232\156\51\94\165\167\98\101\22\98\155\87\182\64\15\100\62\101\181\240\221\16\159\114\76\54\46\136\4\62\63",2066940256,4083507833} or {"\190\46\22\247\38\202\229\238\73\132\105\91\55\157\238\253\229\229\80\134\167\35\69\252\44\38\7\68\73\115\241\53\20\206\141\136\244\211\116\134\222\7\204\238\67\238\3\97\194\67\147\215\70\97\71\178\31\115\8\139\68\99\190\127\75\54\90\247\110\125\15\54\183\3\158\12\170\26\16\63\209\22\166\40\13\197\25\116\154\188\129\49\36\105\122\181\55\49\226\155\168\154\236\251\174\153\139\152\239\73\178\185\154\142\248\140\93\69\89\191\153\205\112\167\80\214\100\90\233\32\245\172\206\219\164\224\242\180\220\203\151\58\15\247\74\112\233\123\67\123\163\107\229\142\233\104\165\185\246\248\252\203\58\70\14\98\54\126\56\71\226\54\14\106\131\113\167\212\108\211\105\60\43\249\4\124\190\113\179\8\69\203\6\80\95\4\178\105\82\212\250\233\225\106\31\184\80\205\225\221\16\211\28\223\185\45\91\130\209\83\2\202\237\29\141\180\52\106\138\24\61\165\113\144\117\4\10\125\195\227\57\41\33\254\78\200\94\192\22\222\169\194\15\157\248\51\89\252\252\245\214\240\11\130\119\130\152\3\29\143\21\108\148\35\87\155\163\96\209\132\89\249\81\234\198\135\84\208\190\229\13\188\239\106\120\212\78\246\63\120\177\39\50\218\238",1310100712,3767952520}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
