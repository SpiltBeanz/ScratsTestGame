local round_status = 0 -- 0 = end, 1 = active
local activeRound = 1

local t = 0
local interval = 1
local zombieCount = 1
local zombieCount2 = 1
local isSpawning = false

local spawnPos = {
        Vector(-78, -1300, 140),
        Vector(219, -1452, 140),
        Vector(78, -1500, 140),
        Vector(-391, -1732, 140),
        Vector(-200, -1600, 140),
        Vector(280, -1852, 140),
        Vector(150, -1900, 140),
        Vector(-600, -1732, 140),

}

local spawnPos2 = {
        Vector(90, -1300, 140),
        Vector(180, -1452, 140),
        Vector(280, -1500, 140),
        Vector(400, -1400, 140),
        Vector(450, -1372, 140),
        Vector(-90, -1200, 140),
        Vector(-180, -1452, 140),
        Vector(-280, -1300, 140),
        Vector(-400, -1452, 140),
        Vector(-450, -1300, 140),
       

}

util.AddNetworkString("UpdateRoundStatus")

function beginRound()

    round_status = 1
    updateClientRoundStatus()
    player.GetAll()[1]:ChatPrint("The First Zombie Wave has Started!")


    isSpawning = true

    local startWeapons = {
        "weapon_crowbar",
        "weapon_pistol",
        "weapon_357",
        "weapon_smg1",
        "weapon_rpg",
        "weapon_m4a1",
        "weapon_ak47"
    }
    
    local ply = FindMetaTable("Player")
    
--     ply:GiveLoadout()

    player.GetAll()[1]:GiveAmmo( 18, "Pistol", true )
    player.GetAll()[1]:GiveAmmo( 12, "357", true )
    player.GetAll()[1]:GiveAmmo( 90, "SMG1", true )
    player.GetAll()[1]:GiveAmmo( 1, "SMG1_Grenade", true )
    player.GetAll()[1]:GiveAmmo( 86, "AR2", true )



end


function endRound()

        round_status = 0
        updateClientRoundStatus()
        

end

function getRoundStatus()

        return round_status

end

local nextWaveWaiting = false

function getBestSpawn(x, zombieType)

        local bestSpawn = Vector(0,0,0)
        local closestDistance = 0

        if table.Count(ents.FindByClass(zombieType)) == 0 then
                
                return x[math.random(1 , table.Count(spawnPos))]
        end

        for k , v in pairs (x) do
                
                local closestZombieDistance = 1000000

                for a , b in pairs(ents.FindByClass(zombieType)) do 
                        
                        if b:GetPos():Distance(v) < closestZombieDistance then
                                
                                closestZombieDistance = b:GetPos():Distance(v)
                        end
                end

                if closestZombieDistance > closestDistance then
                        
                        closestDistance = closestZombieDistance
                        bestSpawn = v

                end

        end
        return bestSpawn

end

hook.Add("Think","WaveThink", function()

        if round_status == 1 and isSpawning == true then

                nextWaveWaiting = false

        

                if t < CurTime() then
                        
                        t = CurTime() + interval

                        local zomb = ents.Create("npc_zombie")
                        zomb:SetPos(getBestSpawn(spawnPos, "npc_zombie"))
                        zomb:Spawn()
                        zomb:SetMaxLookDistance(6000)
                        zomb:SetHealth(10 * activeRound)
                      
                        local zomb2 = ents.Create("npc_fastzombie")
                        zomb2:SetPos(getBestSpawn(spawnPos2, "npc_fastzombie"))
                        zomb2:Spawn()
                        zomb2:SetMaxLookDistance(6000)
                        zomb2:SetHealth(5 * activeRound)

                        zombieCount = zombieCount - 1

                        if zombieCount <= 0 then
                                
                                isSpawning = false

                        end

                end
                
        end



        if round_status == 1 and isSpawning == false and table.Count(ents.FindByClass("npc_zombie")) == 0 and table.Count(ents.FindByClass("npc_fastzombie")) == 0 and nextWaveWaiting == false then
                
                activeRound = activeRound + 1
                
                nextWaveWaiting = true 
                        player.GetAll()[1]:ChatPrint("Next Zombie Wave Begins in 5 Seconds!")
                        player.GetAll()[1]:GiveAmmo( 10 * activeRound, "Pistol", true )
                        player.GetAll()[1]:GiveAmmo( 5 * activeRound, "357", true )
                        player.GetAll()[1]:GiveAmmo( 20 * activeRound, "SMG1", true )
                        player.GetAll()[1]:GiveAmmo( 1 * activeRound, "SMG1_Grenade", true )
                        player.GetAll()[1]:GiveAmmo( 15 * activeRound - 30, "AR2", true )


                timer.Simple(5,function()

                        zombieCount = 2 * activeRound
                        isSpawning = true

                end)
        end

end)

function updateClientRoundStatus()

        net.Start("UpdateRoundStatus")
            net.WriteInt(round_status, 4)
        net.Broadcast()
        
end