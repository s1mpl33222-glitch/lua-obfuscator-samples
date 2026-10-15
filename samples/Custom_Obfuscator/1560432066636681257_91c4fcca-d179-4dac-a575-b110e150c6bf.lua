-- Luraph v15 | protected by rxztop1
local _E="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"
local _K="vM8bDmcDy2gzJTM5DTzPLAnTbpccOaQvKwJMGOWpstk="
local _R={}
local _S={}
local _P={0x01,0x02,0x03,0x04}
local _A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local _B={}
for _i=1,64 do _B[string.sub(_A,_i,_i)]=_i-1 end
local function _dec(s)
	local out,n={},0
	local acc,bits=0,0
	for i=1,#s do
		local v=_B[string.sub(s,i,i)]
		if v then
			acc=acc*0x40+v
			bits=bits+6
			if bits>=8 then
				bits=bits-8
				local p=2^bits
				local b=math.floor(acc/p)
				acc=acc-b*p
				n=n+1
				out[n]=string.char(bit32.band(b,0xFF))
			end
		end
	end
	return table.concat(out)
end
local _bxor=(bit32 and bit32.bxor) or (bit and bit.bxor) or function(a,b)
	local r,p=0,1
	while a>0 or b>0 do
		local m,n=a%2,b%2
		if m~=n then r=r+p end
		a=(a-m)/2 b=(b-n)/2 p=p*2
	end
	return r
end
local _bnd=(bit32 and bit32.band) or function(a,b)
	local r,p=0,1
	while a>0 and b>0 do
		local m,n=a%2,b%2
		if m==1 and n==1 then r=r+p end
		a=(a-m)/2 b=(b-n)/2 p=p*2
	end
	return r
end
local _brs=(bit32 and bit32.rshift) or function(a,n) return math.floor(a/(2^n)) end
local _p=_dec(_E)
local _k=_dec(_K)
local _kl=#_k
local _pl=#_p
local _D={
	[0]=function(a,b,c)
		local x=string.byte(_p,a,a)
		local y=string.byte(_k,b,b)
		local z=_bxor(x,y)
		_S[c]=string.char(_bnd(z,0xFF))
		return _P[1]
	end,
	[1]=function(a,b,c)
		local hi=_brs(a,0x4)
		local lo=_bnd(a,0xF)
		return hi+lo+_P[2]
	end,
	[2]=function(a,b,c)
		return _bnd(a,0xFF)+_brs(b,0x8)+c
	end,
	[3]=function() return _P end,
}
local _n=0
for _i=1,_pl do
	_n=_n+1
	_R[_n]=_D[0](_i, ((_i-1) % _kl)+1, _n)
end
local _code=table.concat(_S)
local _loader=loadstring or load
local _fn,_err=_loader(_code,"=rxztop1")
if not _fn then error("rxz vm: "..tostring(_err)) end
return _fn()
