AddCSLuaFile("player_class/player.lua")

GM.Name = "CSS MiniGames"
GM.Author = "f/x/"
GM.TeamBased = false 


function GM:Initialize()

  self.BaseClass.Initialize(self)

end
-- ConCommand.Add is adding a console command with a function, lua is fuckin crazy
concommand.Add( "gay", function( ply, cmd, args)
  print(string.format("team : %s, class : %s", ply:Team(), ply:GetClass()))
end)

concommand.Add("setClass", function( ply, cmd, args)
  ply:SetupTeam(2) -- forces the player to enter team 2
  print(dump(player_manager.GetPlayerClasses())) -- dump all the player classe(not needed)
end)

concommand.Add("teamsTest", function( ply, cmd, args)  -- teamstest prints out all of the teams
  for team in pairs(teams) do print(teams[team].spawnpoint) end
  local team = pairs(teams)
  print(teams[ply:Team()].name)
end)

concommand.Add("changeTeam",  function( ply, cmd, args) -- randomly changes the team
  ply:SetupTeam(math.random(2))
end)
concommand.Add("spawn",  function( ply, cmd, args) -- forces a player respawn without death
  ply:Spawn()
  --print(ply:GetPlayerColor()) -- also prints team color
end)

function dump(o) -- dumps a tables content to string.
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end

