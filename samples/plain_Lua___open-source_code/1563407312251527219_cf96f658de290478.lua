local function _lse436ba8440(t,k) local o={}; for i=1,#t do o[i]=string.char((t[i]-k)%256) end; return table.concat(o) end
print((_lse436ba8440({31,71,66,67,76},222)))