util.AddNetworkString("roundtimer")
util.AddNetworkString("roundend")
-- ^ ALWAYS ADD THE NETWORK STRING BEFORE USING
-- DO NOT DEFINE SO MANY, INSTEAD SEND MORE IN ONE PACKET


Round = {}
Round.length = 180 -- length of the round timer in seconds
Round.progress = Round.length -- current progress of the round timer in seconds
Round.inProgress = false -- indicates whether the round is currently in progress
Round.timerID = "ROUNDTIMER" -- timer identifier used to reference the round timer

-- sends the current round timer progress to all players
local function networkTimer()
    net.Start("roundtimer")
    net.WriteInt(Round.progress, 12)
    net.Send(player.GetAll())
end

-- sends a signal to all players that the round has ended, and optionally includes a winning team number
local function SendRoundEnd(wTeam)
    wTeam = wTeam or 0
    net.Start("roundend")
    net.WriteInt(wTeam, 12)
    net.WriteTable({})
    net.Send(player.GetAll())
end

-- resets the round timer to its default length
local function resetTimer(length)
    length = length or Round.length
    Round.progress = Round.length
    timer.Remove(Round.timerID)    
end

-- updates the round timer, and optionally sets a new timer length
local function counttimer(length)
    length = length or Round.length
    if(Round.progress > 0 and Round.inProgress) then
        Round.progress = Round.progress - 1
    elseif (Round.progress <= 0) then
        Round:End(.5)
    elseif(!Round.inProgress) then
        timer.Remove(Round.timerID)
    end
    networkTimer()
end

-- starts a new round, assuming there are enough players
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

-- ends the current round, optionally specifying a winning team number and delay time
function Round:End(teamN, delay)
    local delay = delay or 2.5
    local teamN = teamN
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
        SendRoundEnd(teamN)
        timer.Simple(delay, function ()
            reset()
        end)
    else
        print("Round Already Over...")            
    end
end

-- starts a new round automatically when the second player joins, assuming the round is not already in progress
hook.Add("PlayerInitialSpawn", "StartRoundAfterPlayerConnect", function (player)
    if(GetAll() == 2 and !Round.inProgress) then
        Round:Start()
    end
end)

-- disables the respawn option during a round
hook.Add("PlayerDeathThink", "DisableRespawnDuringRound", function (ply)    
    return false
end)




-- check player count if death, if so end round if a team is empty

-- Add a hook to the "PlayerDeath" event
hook.Add("PlayerDeath", "CheckifRoundEnded", function(victim, inf, att)

    -- Initialize a variable to keep track of the number of alive players
    local aliveplayers = 0;

    -- Check if there are more than 1 players in the game
    if(GetAll() > 1) then

        -- Loop through all players in the game
        for item, player in pairs(player.GetAll()) do

            -- Check if the player is alive
            if(player:Alive()) then
                aliveplayers = aliveplayers + 1 -- Increment the alive player count
            end
        end

        -- Check if no players are alive
        if(aliveplayers < 1) then
            Round:End(1) -- End the round with team 1 as the winner
            return -- Exit the function
        end

        -- Initialize variables to keep track of the number of alive players on each team
        local ctPlayerAlive = 0;
        local tPlayerAlive = 0;

        -- Loop through all players on team 1
        for item, tplayer in pairs(team.GetPlayers(1)) do

            -- Check if the player is alive
            if(tplayer:Alive()) then
                ctPlayerAlive = ctPlayerAlive + 1 -- Increment the alive player count for team 1
            end
        end

        -- Check if no players on team 1 are alive
        if(ctPlayerAlive < 1) then
            Round:End(2) -- End the round with team 2 as the winner
            return -- Exit the function
        end

        -- Loop through all players on team 2
        for item, tplayer in pairs(team.GetPlayers(2)) do

            -- Check if the player is alive
            if(tplayer:Alive()) then
                tPlayerAlive = tPlayerAlive + 1 -- Increment the alive player count for team 2
            end
        end

        -- Check if no players on team 2 are alive
        if(tPlayerAlive < 1) then
            Round:End(1) -- End the round with team 1 as the winner
            return -- Exit the function
        end
    end

    print(aliveplayers) -- Print the number of alive players
end)

