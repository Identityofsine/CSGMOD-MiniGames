AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("player_class/player.lua")




function GM:PreGamemodeLoaded()
    team.SetUp(0, "T", Color(255,0,0,255), true) -- this is useless really
    team.SetUp(1, "CT", Color(0,0,255,255), true) -- idk if this works

end

function GM:PlayerConnect(name , ip) -- When somebody connects

  print("Player " ..name.. " Connected")

end

function GM:Initialize()
  print("Server Initialzied")
end

function GM:PlayerInitialSpawn(ply) -- When somebody first spawns
  print("Player "..ply:Name().." has spawned.")
  ply:SetupTeam(1) -- sets the team
  
end



function GM:PlayerSpawn(ply)
  ply:ChatPrint(string.format("you are on team %d", ply:Team())) -- prints the current team the player is on
end

function GM:PlayerSelectSpawn(ply)
  local spawnpoint -- local var uninit because of spawnpoint ass.
  for team in pairs(teams) do 
    if (team == ply:Team()) then
       spawnpoint = teams[team].spawnpoint -- for loop through a table, if the player's team has a match return the corresponding spawnpoint
    end
  end
  local spawnpoints = ents.FindByClass(spawnpoint) -- very useful for finding hammer ENTS
  local random_spawn = math.random(#spawnpoints) -- find a random spawn within the spawnpoint
  print(spawnpoint) -- print it disable this when release
  return spawnpoints[random_spawn] -- return the spawnpoint to game engine.
end


