-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local t1 = {
	Code = ""
}
local function v3(p1)
	local t2 = {}

	while p1 and p1 ~= game do
		local p1Name = p1.Name

		if p1Name:sub(1, 4) == "Game" then
			p1Name = "game" .. p1Name:sub(5)
		end

		table.insert(t2, 1, p1Name)
		p1 = p1.Parent
	end

	return table.concat(t2, ".")
end
local function v4(p2)
	if typeof(p2) == "string" then
		return string.format("%q", p2)
	end

	if typeof(p2) == "number" then
		return tostring(p2)
	end

	if typeof(p2) == "boolean" then
		return not p2 and "false" or "true"
	end

	if typeof(p2) == "Instance" then
		return v3(p2)
	end

	return string.format("%q", tostring(p2))
end
local function v5(p3)
	local t3 = {}

	for i, v in ipairs(p3) do
		t3[i] = string.format("[%d] = %s", i, v4(v))
	end

	return t3
end
local NanamiCheck = game:GetService("ReplicatedStorage"):WaitForChild("NanamiCheck");
(function(p4)
	local t4 = {}
	local v17 = p4

	while v17 and v17.Parent ~= game do
		local Name = v17.Name

		if Name:sub(1, 4) == "Game" then
			Name = "game" .. Name:sub(5)
		end

		table.insert(t4, 1, Name)
		v17 = v17.Parent
	end

	local v19 = table.concat(t4, ".")

	if p4:IsA("RemoteEvent") then
		p4.OnClientEvent:Connect(function(...)
			local v20 = v5({ ... })
			local v21 = table.concat(v20, ",\n    ")

			t1.Code = string.format("local args = {\n    %s\n}\n%s:FireServer(unpack(args))", v21, v19)
			print(t1.Code)
		end)

		return
	end

	if p4:IsA("RemoteFunction") then
		function p4.OnClientInvoke(...)
			local v22 = v5({ ... })
			local v23 = table.concat(v22, ",\n    ")

			t1.Code = string.format("local args = {\n    %s\n}\n%s:InvokeServer(unpack(args))", v23, v19)
			print(t1.Code)

			return ...
		end
	end
end)(NanamiCheck)
NanamiCheck:FireServer(v1({ unpack({
	"arg1",
	123,
	true
}) }))
