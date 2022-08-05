Round = {}
Round.length = 180

function Round:Start() 
    game.CleanUpMap()
    for item, player in pairs(player.GetAll())
    do
        player:StripWeapons()
        player:Spawn()
        player:PrintMessage(HUD_PRINTTALK, "ROUND HAS STARTED")
    end
end

function Round:End()
    -- this should be called when every person is dead or the round timer is over.
    -- award team with points
    game.CleanUpMap()
    for item, player in pairs(player.GetAll())
    do
        player:StripWeapons()
        player:Spawn()
        PrintMessage(HUD_PRINTTALK, "ROUND HAS ENDED")
    end
end

hook.Add("PlayerDeath", "CheckifRoundEnded", function(victim, inf, att)
    local aliveplayers = 0;
    if(GetAll() > 1) then
        for item, player in pairs(player.GetAll())
        do
            if(player:Alive()) then
                aliveplayers = aliveplayers + 1
            end
        end
        if(aliveplayers <= 1) then
            Round:End()
            return
        end
        local ctPlayerAlive = 0;
        for item, tplayer in pairs(team.GetPlayers(1))
        do
            if(tplayer:Alive()) then
                ctPlayerAlive = ctPlayerAlive + 1
            end
        end
        if(ctPlayerAlive < 1) then
            Round:End()
            return
        end
        local tPlayerAlive = 0;
        for item, tplayer in pairs(team.GetPlayers(2))
        do
            if(tplayer:Alive()) then
                tPlayerAlive = tPlayerAlive + 1
            end
        end
        if(tPlayerAlive < 1) then
            Round:End()
            return
        end
    end
    print(aliveplayers)
end)