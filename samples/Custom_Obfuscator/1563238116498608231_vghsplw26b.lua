rac = rac or 0 --1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
-- ScriptVault Anti-Raw Runtime
local _pcall,_type,_str = pcall, type, tostring
local _env = (getfenv and getfenv(0)) or _G
if _env and (_env.decompile or _env.getgc or rawget(_env,"__DEOB__")) then return end
if _env then _env.print = function() end end
local _run = function() --[ The code Obfuscate By ScriptVault-io.lovable.app]--
(function() local _VM={}; _VM.d=function(s) local _V000fw={} for i=1,#s do _V000fw[i]=string.char(s:byte(i)) end return table.concat(_V000fw) end; _VM.k=function(x) return x end; _VM.run=function(f,...) return f(...) end; local _J1aeptr0=212135;_J1aeptr0=_J1aeptr0-((_J1aeptr0==212135)and 212135 or 0);if _J1aeptr0>0 then _J1aeptr0=0 end; local _Jbcg9re1=772919;_Jbcg9re1=_Jbcg9re1-((_Jbcg9re1==772919)and 772919 or 0);if _Jbcg9re1>0 then _Jbcg9re1=0 end; local _J9a5qxs2=719084;_J9a5qxs2=_J9a5qxs2-((_J9a5qxs2==719084)and 719084 or 0);if _J9a5qxs2>0 then _J9a5qxs2=0 end; local _J1mltxd3=451933;_J1mltxd3=_J1mltxd3-((_J1mltxd3==451933)and 451933 or 0);if _J1mltxd3>0 then _J1mltxd3=0 end; local _Jg0ej6u4=400917;_Jg0ej6u4=_Jg0ej6u4-((_Jg0ej6u4==400917)and 400917 or 0);if _Jg0ej6u4>0 then _Jg0ej6u4=0 end; local _Jeqeiuy5=61156;_Jeqeiuy5=_Jeqeiuy5-((_Jeqeiuy5==61156)and 61156 or 0);if _Jeqeiuy5>0 then _Jeqeiuy5=0 end; local _J6lu2b36=744858;_J6lu2b36=_J6lu2b36-((_J6lu2b36==744858)and 744858 or 0);if _J6lu2b36>0 then _J6lu2b36=0 end; local _Ja21z9h7=129398;_Ja21z9h7=_Ja21z9h7-((_Ja21z9h7==129398)and 129398 or 0);if _Ja21z9h7>0 then _Ja21z9h7=0 end; local _AT_pcall,_AT_type,_AT_dbg=pcall,type,debug local _AT_env=(getfenv and getfenv(0)) or _G if _AT_type(_AT_env)=="table" and (rawget(_AT_env,"decompile") or rawget(_AT_env,"__DEOB__")) then return end if _AT_dbg and _AT_type(_AT_dbg.gethook)=='function' then local _AT_h=_AT_dbg.gethook() if _AT_h then return end end local _LR_p=pcall local _LR_c=(7463827-7463826) if _LR_c~=1 then return end local _LR_ok=_LR_p(function() return #tostring(0.1)>0 end) if not _LR_ok then return end local _CA={"\80\108\97\121\101\114\115","\83\116\97\114\116\101\114\71\117\105","\83\101\110\100\78\111\116\105\102\105\99\97\116\105\111\110","\83\99\114\105\112\116\86\97\117\108\116","\76\111\97\100\101\100\32\115\101\99\117\114\101\108\121\32\102\111\114\32"}; -- ScriptVault Security
local _V00119c = game:GetService(_CA[(135-134)])
local _V002c9 = _V00119c.LocalPlayer

game:GetService(_CA[(223-221)]):SetCore(_CA[(622-619)], {
    Title = _CA[(158-154)],
    Text = _CA[(179-174)] .. _V002c9.Name,
    Duration = (108-103),
})
 end)();
end
_run()