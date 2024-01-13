AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- Include Other Scripts

AddCSLuaFile("round_controller/cl_round_controller.lua")
include("round_controller/sv_round_controller.lua")

AddCSLuaFile("lobby_manager/cl_lobby.lua")
include("lobby_manager/sv_lobby.lua")



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

function ply:GiveLoadout()

    for k, v in pairs(startWeapons) do
        
            self:Give(v)
            
    end

    self:GiveAmmo( 10, "RPG_Round", true ) -- better place to put this? (gives 10 rockets to player)

    for i, ply in ipairs( player.GetAll( ) ) do
        if ply:Armor() == 0 then
             ply:SetArmor( 100 )
        end
    end
  
end

function GM:PlayerConnect(name , ip)

    print("Player "..name.." connected with IP ("..ip..")")

end

function GM:PlayerInitialSpawn(ply)

    print("Player " ..ply:Name().." has spawned.")

end

function GM:OnNPCKilled(npc, attacker, inflictor)

    inflictor:SetArmor(inflictor:Armor() + 1 )

end

-- function GM:PlayerDeath(victim, inflictor, attacker)

    
  
-- end

-- function GM:PlayerSpawn( player, transition )

--     player:GiveLoadout()
--     net.Start("open_lobby")
--     net.Broadcast() 

-- end