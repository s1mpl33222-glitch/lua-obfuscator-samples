-- Do not save this file
  -- Always use the loadstring
  _bsdata0={762112560,"=V0O8sI3ZALLwrTBbl_jwEspVGkrRxBt2siPwI1uSWkzEqD1DjI44DOI8EA8KDWiV5lUhD6vQvxXh4w1ped1wVXRTa",1792244036783,"\179\39\239\141\66\190\105\140\199\118\211\196\2\18\117\25","YTT0gE831Rb7uxOmRHYvGfV0IsdXH_C8uP6eKjMfdOQdM5HBm6tX7OqAeeVPugTVss2DHnXc2hqziLPULxaQKF40W","tEAc3MkcWHLxZRHVMvrIbYosDY0o8vEqklEMI.yJSE9cYVWz6mvDYdc98w9bRZFKuu5Ej8GChB_tVFHxiS9U2PFsp","d12143337a2e873b9e4a16b69693370a",3720920362,1213048992,817503754,1881008577,3374353410,3449687182,"d5a1a04c2ea13ababfc8d52fca3a2ea83783ce6fcec0ebff0e7b557fe3804d9a98db3681be22e6cadb1d0a2cabb4bc6e76d7e0713c77336c444a3a3ba2c22fab5d960f25f9c173f1e4d5481e94d1461543b9943b0ddec582e658e031674d8c7e8c1d08591e17104f6191cf2ce665b4a8b1ed5df3ec3c71f2858080274343744130f4fb5d894c10a2512d8831e3a69599a0bd787fffcdafb2742fdbfb8d8dd7ed7fb235f400e68d2dff376f2ecad34f6fc06fd6523e605948273ca2876568d7999b06cf7eb56da582","\251\12\69\153\218\86\113\217\38\49\109\66\79\101\149\141\88\219\128\199\225\44\203\34"};
  local f,b,a="static_content_130520","ab41c9f0eso-sephal"
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