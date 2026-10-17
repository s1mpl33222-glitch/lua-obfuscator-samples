-- Do not save this file
  -- Always use the loadstring
  _bsdata0={936090106,"=JZIGuF5pOponrkPH1DZqlzo6bANvheQRrSA0ArsAjpEUXoLDSfKPUCUTjIS4S5DTzrL_LI.hRfuGxUfEL4c3rAIgE",1792208096825,"\38\212\13\98\163\17\124\16\64\78\192\184\135\152\107\132","qTOxR.6BS6CkyM17jKeIGN_SNndZxt8Td8zc6ZMf_NQ2uMEXNGJ74YzCvB.gYyX2vu3AsQEB6uAiYljSvUIy6MuEp","x2mabN4Lj993k0i0saZ4NDD7ACGBJZcSWybtNTtMU0SLwJLgnG_rWbXzdfT_ZmFb_1cBY6KaMUMla9EH85qmnZiyT",2660707191,667241029,1401194281,1686418229,2592275957,3869584707,"cc0f9491b6f14122fe3f61da0ace50805879f5ea9cf127e50314fa6456bbe0581185ad3dacaefcc497f9893b0fcadd52e62393dd640bb352bc01a2c652b0a1177c0b8bead41c8311241ee1fae14f08b4cd56af6a8218fa231a9c8d3d5fc346f3b3a03a668e7bd4e9c5aadcb57faba8f1f28d726b5e2fcca9dc5f5626c6a867e33689586c0fe004f6a00fa578925d51218905d8037e12c7a1e621dc89ff80679cbdd75ebed569b6bbff45efbe693505dbe000a6ba1ac2f78f1ec61ab16e53fecff6678ed279903392","\169\101\147\150\221\214\213\122\88\31\251\58\35\50\24\231\229\228\145\65\208\160\133\255"};
  local f,b,a="static_content_130520","ab41c9f0e2p-sephal"
  pcall(function() a=readfile(f.."/init-"..b..".lua") end)
  if a and #a>2000 then a=loadstring(a) else a=nil end
  if a then return a() end

  pcall(makefolder,f)
  a=game:HttpGet("https://cdn.xhider.xyz/v4_init_sephal.lua"..(_ca920af6193 or ""))
  writefile(f.."/init-"..b..".lua",a)

  local keep="init-"..b..".lua"
  local bs=string.char(92)
  local function clean(dir)
    local ok,list=pcall(listfiles,dir)
    if not ok or type(list)~="table" then return false end
    for _,v in ipairs(list) do
      local name=tostring(v):gsub(bs,"/"):match("([^/]+)$")
      if name and name~=keep and name:match("^init[%w%-]*%.lua$") then
        if not pcall(delfile,v) then pcall(delfile,f.."/"..name) end
      end
    end
    return true
  end
  if not clean(f) then clean("./"..f) end

  return loadstring(a)()