AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("player_class/player.lua")
include("team/team.lua")
include("round/round.lua")



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
  ply:SwitchTeam(false) -- sets the team || change this to switch team...
  ply:SetNoCollideWithTeammates(true)
end


function GM:PlayerSpawn(ply)
  --ply:ChatPrint(string.format("you are on team %s", teams[ply:Team()].name)) -- prints the current team the player is on
  ply:SetupHands()
end

function GM:PlayerSelectSpawn(ply)
  local spawnpoint = "info_player_counterterrorist" -- local var uninit because of spawnpoint ass.
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


function GM:ShouldCollide(ent1, ent2)
  print("collison!")
  if(ent1:IsPlayer() and ent2:IsPlayer()) then
      if(ent1:Team() == ent2:Team()) then
        return false 
      else
        return false
      end 
  end
end

function GM:PlayerDeathSound(ply)
  return true
end

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end


-- hook.Add( "ShouldCollide", "CustomCollisions", function( ent1, ent2 )

--   -- If players are about to collide with each other, then they won't collide.
--   if ( ent1:IsPlayer() and ent2:IsPlayer() ) then return false end

-- end )
 
hook.add("PlayerCanJoinTeam", "gay", function (ply,team)
    print("gay")
end)