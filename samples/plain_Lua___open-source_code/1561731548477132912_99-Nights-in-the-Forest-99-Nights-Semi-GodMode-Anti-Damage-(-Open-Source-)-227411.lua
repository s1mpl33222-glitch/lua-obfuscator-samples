local RS = cloneref(game:GetService("ReplicatedStorage"))
local RE = RS:WaitForChild("RemoteEvents")


local eventstoblock = {
    RE.NPCProjectileDamagePlayer,
    RE.DamagePlayer,
    RE.ClientTriggerNPCAttack,
    RE.JungleSpikeTrapDamage,
    RE.ExplosiveProjectileDamageEnemy,
    RE.NPCProjectileDamagePet,
    RE.ProjectileDamageEnemy
}

for i,v in next, eventstoblock do
    v:Destroy()
end