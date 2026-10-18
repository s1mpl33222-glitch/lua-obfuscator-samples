if not game:IsLoaded() then game.Loaded:Wait() end

cloneref = cloneref or function(o) return o end
local getupvalues = (debug and debug.getupvalues) or getupvalues
local getprotos = (debug and debug.getprotos) or getprotos
if not getupvalues then return end

local RS = cloneref(game:GetService("ReplicatedStorage"))
local netFolder = RS:WaitForChild("Packages"):WaitForChild("Net")
local okMod, ctrl = pcall(require, RS:WaitForChild("Controllers"):WaitForChild("TradeController"))
if not okMod or type(ctrl) ~= "table" then return end

local remotes, names = {}, {}
do
	local seenFn, seenInst = {}, {}
	local function walk(fn)
		if type(fn) ~= "function" or seenFn[fn] then return end
		seenFn[fn] = true
		local ok, ups = pcall(getupvalues, fn)
		if ok and ups then
			for _, v in pairs(ups) do
				if typeof(v) == "Instance" and v.Parent == netFolder
					and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
					if not seenInst[v] then
						seenInst[v] = true
						remotes[#remotes + 1] = v
						names[v.Name] = true
					end
				elseif type(v) == "function" then
					walk(v)
				end
			end
		end
		if getprotos then
			local ok2, ps = pcall(getprotos, fn)
			if ok2 and ps then for _, p in ipairs(ps) do walk(p) end end
		end
	end
	for _, fn in pairs(ctrl) do walk(fn) end
end

for _, r in ipairs(remotes) do
	pcall(function() r:Destroy() end)
end