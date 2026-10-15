-- Do not save this file
  -- Always use the loadstring
  _bsdata0={583269926,"=JtJPuV5cO9ourUA7DlrSQ.nLaLwEs3J_iFzZfHtHf9E04AzR1ZzEHCVRfxRoPlPTjTKLNh0iRAuwlE.DvQ1ZqNKlE",1792079045897,"\176\59\178\171\30\193\101\42\136\170\87\198\43\82\41\132","WHFIlid1snNSsJY5etOhc5qipLVmGtf7ujlZOLmCVZzXGLSSyHVu1X_ovBZ3fkZ6Yc_sfQsWxsyCLjgqYUEO54w4V","vrtGSLIyZYKHdDHgGpUu.6bJ9CGBJZcSWybtNxGvU0S_xIbMGXITTnWjUb_jaotE__k5Z1GlM9EG9XYH85qmnZiyT",3353075602,2739743375,3841622059,2229187393,1936666388,965371071,"81518611d9c46f843fb130fb2e97f540532221be7f98d0993326b03d9f527ebb2292627fe67cc9430cd531c00c2e58bb74a65f0415e40c8421e3f929a289a47c49a10ad84961d8293da747f5933d2994afe84f00bfbf827b9436da1974711046855d4bccad2aade1dbd4346e55c0df9d5cada27f8303c9329581fb3e452261fda59dc13d47e7f409f595f7decc497848732062b70a49da5a6faa33289a9d2efd99eeee0dc30addec77edeb43d1650dea7b157f5a27bd5551b88b1e6cf9e342a933d33bcc9c122aa6","\127\200\221\201\228\105\229\4\202\188\219\207\205\190\254\213\131\85\69\92\219\51\5\177"};
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