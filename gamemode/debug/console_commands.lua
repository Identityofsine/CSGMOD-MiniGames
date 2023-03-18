include('../core/hammer.lua')

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
      local teleporter = ents.FindByClass("trigger_teleport")
      

      for k,v in pairs(FindAllTeleports()) do 
        local teleporterKeyValues = v:GetKeyValues()

        -- Print out the key values of the teleporter entity
        for k, v in pairs(teleporterKeyValues) do
          print(k, v)
        end
        print('\n')

      end

  end)


  --reset map    
concommand.Add("fix", function( ply, cmd, args)
  FixTeleporters();

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

-- Define the concommand
concommand.Add("mp_playercollision", function(ply, cmd, args)
  -- Check if the player has permission to change the cvar
  if not ply:IsAdmin() then
      ply:ChatPrint("You do not have permission to change mp_playercollision")
      return
  end

  -- Get the value to set the cvar to
  local value = tonumber(args[1])

  -- Validate the value
  if value == nil then
      ply:ChatPrint("Invalid value for mp_playercollision")
      return
  end


  -- Set the cvar
  -- Notify the player that the cvar was changed
  ply:ChatPrint("mp_playercollision set to " .. value)

  if value == 1 then
      print("COLLISION OFF")
      
  end

  if value == 1 then
-- Hook to check for player collision
  hook.Add("ShouldCollide", "PushPlayersOutOfEachOther", function(ent1, ent2)
    -- Check if the entities are both players
    if ent1:IsPlayer() and ent2:IsPlayer() then
        -- Check if they are colliding
        if ent1:isDead() then return
        if ent1:NearestPoint(ent2:GetPos()):DistToSqr(ent2:NearestPoint(ent1:GetPos())) < 25 then
            -- Calculate the direction to push the colliding player in the X and Z directions only
            local pushDirection = Vector(ent1:GetPos().x - ent2:GetPos().x, 0, ent1:GetPos().z - ent2:GetPos().z)
            pushDirection:Normalize()

            -- Move the colliding player out of the other player's collision bounds
            local pushDistance = 25
            ent1:SetPos(Vector(ent2:GetPos().x + pushDirection.x * pushDistance, ent1:GetPos().y, ent2:GetPos().z + pushDirection.z * pushDistance))

            -- Return false to disable collision between the two players for this frame
            return false
        end
    end

    -- Return true to allow collision between other entities
    return true
  end)

  elseif (value == 0) then
    hook.Remove("ShouldCollide", "PushPlayersOutOfEachOther")
  end



end)