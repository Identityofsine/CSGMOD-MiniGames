Round = {}
Round.length = 180
Round.progress = Round.length
Round.inProgress = false
Round.timerID = "ROUNDTIMER"




local function resetTimer(--[[optional]] length)
    length = length or Round.length
    Round.progress = Round.length
    timer.Remove(Round.timerID)    
end

local function counttimer(--[[optional]] length)
    length = length or Round.length
    if(Round.progress > 0 and Round.inProgress) then
        Round.progress = Round.progress - 1
        PrintMessage(HUD_PRINTTALK, string.format("There is %d seconds left in the round", Round.progress))
    elseif (Round.progress <= 0) then
        PrintMessage(HUD_PRINTTALK, "ROUND OVER")
        Round:End(.5)
    elseif(!Round.inProgress) then
        timer.Remove(Round.timerID)
    
    end
end

function Round:Start() 
    if(GetAll() > 1) then
        game.CleanUpMap()
        self.inProgress = true;
        resetTimer(Round.length)
        timer.Create(self.timerID, 1, 0, function () 
            counttimer(Round.length)
        end)
        for item, player in pairs(player.GetAll())
        do
            player:StripWeapons()
            player:Spawn()
            player:PrintMessage(HUD_PRINTTALK, "ROUND HAS STARTED")
        end
    else
        PrintMessage(HUD_PRINTTALK, "Not enough players to start the round")
    end
end

function Round:End(--[[optional]] delay)
    local delay = delay or 2.5
    -- this should be called when every person is dead or the round timer is over.
    -- award team with points
    local function reset() 
        game.CleanUpMap()
        for item, player in pairs(player.GetAll())
        do
            player:StripWeapons()
            player:Spawn()
            PrintMessage(HUD_PRINTTALK, "ROUND HAS ENDED")
            Round:Start()
        end
    end
    if(self.inProgress) then
            self.inProgress = false;
            PrintMessage(HUD_PRINTTALK, "ROUND IS ENDING!!!")
            timer.Simple(delay, function ()
                reset()
            end)
    else
        print("Round Already Over...")            
    end
end


hook.Add("PlayerInitialSpawn", "StartRoundAfterPlayerConnect", function (player)
    if(GetAll() == 2 and !Round.inProgress) then
        Round:Start()
    end
end)

hook.Add("PlayerDeathThink", "DisableRespawnDuringRound", function (ply)
    print(Round.inProgress)
    return false
end)

-- check player count if death, if so end round if a team is empty
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

