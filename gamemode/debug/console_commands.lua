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
    ply:SwitchTeam(true)
  end)
  concommand.Add("spawn",  function( ply, cmd, args) -- forces a player respawn without death
    ply:Spawn()
    --print(ply:GetPlayerColor()) -- also prints team color
  end)
  
  concommand.Add("listallTeleporters", function( ply, cmd, args)
      print(dump(ents.FindByClass("trigger_teleport")))
  end)

--reset map    
concommand.Add("resetmap", function( ply, cmd, args)
    Round.inProgress = true 
    Round:End()
end)

--debug command
concommand.Add("setspeed", function( ply, cmd, args)
    print(args[1])
    ply:SetRunSpeed(args[1])
end)