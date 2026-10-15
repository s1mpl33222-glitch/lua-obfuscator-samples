-- This file was generated at discord.gg/syncrypt

local v1 = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local uDim2 = UDim2.fromOffset(520, 420)
local RightShift = Enum.KeyCode.RightShift
local v4 = v1:CreateWindow({
	Title = "T-Titans Script",
	Author = "YuriDev",
	Folder = "TTitansScript",
	Icon = "swords",
	Theme = "Dark",
	Size = uDim2,
	Transparent = false,
	ToggleKey = RightShift,
	Resizable = false
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local t1 = {
	Enabled = false,
	TargetMode = "Inimigos",
	HitboxSize = 20,
	TrackedPlayers = {}
}
local u9 = t1
local function v10(p1)
    if p1 == LocalPlayer then
        return false
    end

    local v41 = not p1.Character

    if not v41 then
        v41 = not p1.Character:FindFirstChild("HumanoidRootPart")
    end

    if v41 then
        return false
    end

    local Humanoid = p1.Character:FindFirstChildOfClass("Humanoid")

    if Humanoid and Humanoid.Health <= 0 then
        return false
    end

    if u9.TargetMode == "Todos" then
        return true
    end

    if u9.TargetMode == "Time" then
        return p1.Team == LocalPlayer.Team
    end

    if u9.TargetMode == "Inimigos" then
        return p1.Team ~= LocalPlayer.Team
    end

    return false
end
local function v11(p2)
    local v36 = u9.TrackedPlayers[p2]
    local v37 = v36

    if v36 then
        v37 = p2.Character

        if v37 then
            v37 = p2.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    if v37 then
        local HumanoidRootPart = p2.Character.HumanoidRootPart

        HumanoidRootPart.Size = v36.Size
        HumanoidRootPart.Transparency = v36.Transparency
        HumanoidRootPart.CanCollide = v36.CanCollide

        local CustomPhysicalProperties = HumanoidRootPart:FindFirstChild("CustomPhysicalProperties")

        if CustomPhysicalProperties then
            CustomPhysicalProperties:Destroy()
        end
    end

    u9.TrackedPlayers[p2] = nil
end
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if u9.Enabled and v10(player) then
            local HumanoidRootPart = player.Character.HumanoidRootPart

            if not u9.TrackedPlayers[player] then
                local TrackedPlayers = u9.TrackedPlayers
                local HumanoidRootPartSize = HumanoidRootPart.Size
                local HumanoidRootPartTransparency = HumanoidRootPart.Transparency
                local CanCollide = HumanoidRootPart.CanCollide

                TrackedPlayers[player] = {
					Size = HumanoidRootPartSize,
					Transparency = HumanoidRootPartTransparency,
					CanCollide = CanCollide
				}
            end

            HumanoidRootPart.Size = Vector3.new(u9.HitboxSize, u9.HitboxSize, u9.HitboxSize)
            HumanoidRootPart.Transparency = 0.6
            HumanoidRootPart.BrickColor = BrickColor.new("Bright red")
            HumanoidRootPart.CanCollide = false
            HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        elseif u9.TrackedPlayers[player] then
            v11(player)
        end
    end
end)
Players.PlayerRemoving:Connect(function(player)
    u9.TrackedPlayers[player] = nil
end)
local t2 = {
	NUM_ROCKS = 8,
	NUM_SHOTS = 60,
	RECHARGE_DOWNTIME = 0,
	CurrentCooldown = 0,
	DEBOUNCE = 0,
	MAX_NUM_HUMANOIDS_HIT = 999,
	PROJECTILE_SPEED = 299,
	CHARGE_DURATION = 3,
	ATTACK_DURATION = 0,
	SHOCKS_PER_SECOND = 0,
	ZONE_LIFETIME = 8,
	ACTIVE_DURATION = 1,
	HEAL_PER_SECOND = 0,
	PAUSE_DURATION = 0,
	SWING_DURATION = 3,
	SLOW_DURATION = 3,
	PUSH_FORCE = 500,
	SHOTS_PER_BURST = 8,
	BLIND_DURATION = 9,
	CLONE_HEALTH_LOST_PER_SECOND = 0.1,
	NUM_SPIKE_WAVES = 13,
	RAGE_DURATION = 20,
	NUM_ATTACKS = 14,
	NUM_TRIPLE_SHOTS = 10,
	NUM_AOE_SHOTS = 3,
	NUM_SCATTER_SHOTS = 31,
	HEAVY_DAMAGE = 30,
	LIGHT_DAMAGE = 15,
	FLIGHT_DURATION = 10,
	NUM_BOMBS = 10,
	TNT_DAMAGE = 35,
	TOXIC_BARREL_TICK_DAMAGE = 20,
	NUM_BURSTS = 10,
	MAX_NUM_PER_ATTACK = 10
}
local t3 = {}
local u14 = false
local function v15()
    if u14 then
        return
    end

    u14 = true

    local _next = next
    local v52, v53 = getgc(true)

    while true do
        local v54

        v53, v54 = _next(v52, v53)

        if not v53 then
            break
        end

        if type(v54) == "table" then
            for k, v in pairs(t2) do
                local v57 = k

                if rawget(v54, v57) ~= nil then
                    t3[v54] = t3[v54] or {}

                    if t3[v54][v57] == nil then
                        t3[v54][v57] = v54[v57]
                    end

                    setreadonly(v54, false)
                    rawset(v54, v57, v)
                    setreadonly(v54, true)
                end
            end
        end
    end
end
local function v16()
    if not u14 then
        return
    end

    for k, v in pairs(t3) do
        local v60 = k

        setreadonly(v60, false)

        for k2, v2 in pairs(v) do
            rawset(v60, k2, v2)
        end

        setreadonly(v60, true)
    end

    table.clear(t3)
end
local v17 = v4:Tab({
	Title = "Hitbox",
	Icon = "target",
	ShowTabTitle = true,
	TabTitle = "Controle de Hitbox",
	TabTitleAlign = "Center"
})
v17:Toggle({
	Title = "Ativar Hitbox Expander",
	Desc = "Liga ou desliga a expansão de hitbox",
	Icon = "power",
	Value = false,
	Callback = function(p3)
    u9.Enabled = p3

    if p3 then
        v1:Notify({
				Title = "Hitbox Ativado",
				Content = "Hitbox expander ligado com sucesso!",
				Icon = "solar:shield-check-bold",
				Duration = 3
			})

        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        v11(player)
    end

    v1:Notify({
			Title = "Hitbox Desativado",
			Content = "Hitbox expander desligado.",
			Icon = "solar:shield-minus-bold",
			Duration = 3
		})
end
})
v17:Dropdown({
	Title = "Modo de Alvo",
	Desc = "Selecione quem será afetado",
	Values = {
		"Inimigos",
		"Time",
		"Todos"
	},
	Value = "Inimigos",
	Callback = function(p4)
    u9.TargetMode = p4

    for _, player in ipairs(Players:GetPlayers()) do
        if u9.TrackedPlayers[player] and not v10(player) then
            v11(player)
        end
    end
end
})
local t4 = {
	Min = 1,
	Max = 2000,
	Default = 20
}
local Slider = v17.Slider
local t5 = {
	From = "sfsymbols:minus",
	To = "sfsymbols:plus"
}
Slider(v17, {
	Title = "Tamanho da Hitbox",
	Desc = "Define o tamanho da hitbox (1-2000)",
	IsTooltip = true,
	IsTextbox = true,
	Width = 200,
	Step = 1,
	Value = t4,
	Icons = t5,
	Callback = function(p5)
    u9.HitboxSize = p5
end
})
local v21 = v4:Tab({
	Title = "Battlegrounds",
	Icon = "zap",
	ShowTabTitle = true,
	TabTitle = "T Titans Battlegrounds",
	TabTitleAlign = "Center"
})
local FontWeight = Enum.FontWeight
local Section = v21.Section
local Medium = FontWeight.Medium
Section(v21, {
	Title = "Ative o buff para turbinar suas habilidades!",
	TextSize = 16,
	TextTransparency = 0.3,
	FontWeight = Medium
})
v21:Space()
v21:Toggle({
	Title = "Ativar Buffs",
	Desc = "Ativa todos os boosts de habilidades",
	Icon = "rocket",
	Value = false,
	Callback = function(p6)
    if p6 then
        v15()
        v1:Notify({
				Title = "⚡ T-Titans Buff Ativado!",
				Content = "Todas as habilidades foram turbinadas com sucesso!",
				Icon = "solar:bolt-bold",
				Duration = 5,
				CanClose = true
			})
        ToggleBuff:SetTitle("Buffs Ativados")

        return
    end

    v16()
    v1:Notify({
			Title = "❌ Buffs Desativados",
			Content = "Os buffs foram removidos.",
			Icon = "solar:shield-minus-bold",
			Duration = 4,
			CanClose = true
		})
    ToggleBuff:SetTitle("Ativar Buffs")
end
})
local v25 = v4:Tab({
	Title = "Sobre",
	Icon = "info",
	ShowTabTitle = true,
	TabTitle = "T-Titans Script",
	TabTitleAlign = "Center"
})
local FontWeight2 = Enum.FontWeight
local Section2 = v25.Section
local SemiBold = FontWeight2.SemiBold
Section2(v25, {
	Title = "Desenvolvido por YuriDev",
	TextSize = 18,
	FontWeight = SemiBold
})
local Medium2 = Enum.FontWeight.Medium
v25:Section({
	Title = "Hub oficial de scripts para T-Titans.",
	TextSize = 16,
	TextTransparency = 0.35,
	FontWeight = Medium2
})
local Section3 = v25.Section
local Medium3 = Enum.FontWeight.Medium
Section3(v25, {
	Title = "Inclui: Hitbox Expander + Battlegrounds Buffs",
	TextSize = 15,
	TextTransparency = 0.4,
	FontWeight = Medium3
})
v25:Space()
local _Color3 = Color3
local Button = v25.Button
local v34 = _Color3.fromHex("#305dff")
Button(v25, {
	Title = "Versão 1.0.0",
	Color = v34,
	Icon = "tag",
	Justify = "Center",
	Callback = function()
end
})
