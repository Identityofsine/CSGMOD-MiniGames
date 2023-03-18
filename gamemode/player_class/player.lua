local ply = FindMetaTable("Player")
ply.prevTeam = 1
teams = { -- defined teams, definitely could use more stuff but this is good enough
	{
		name = "CT",
		number = 3,
		color = Vector (0, 0 ,1.0),
		spawnpoint = "info_player_counterterrorist",
		models = {
			"models/player/gasmask.mdl",
			"models/player/urban.mdl",
			"models/player/swat.mdl",
			"models/player/riot.mdl"
		},
		weapons = {"weapon_knife"}
	},
	{
		name = "T",
		number = 2,
		color = Vector (1.0, 0 ,0),
		spawnpoint = "info_player_terrorist",
		models = {
			"models/player/phoenix.mdl",
			"models/player/arctic.mdl",
			"models/player/leet.mdl",
			"models/player/guerilla.mdl"
		},
		weapons = {"weapon_knife"}
	},
	{
		name = "Spectator",
		color = Vector (0, 0, 0)
	}
}




function ply:SetupTeam( n,  --[[optional]]killplayer ) -- TEAM SETUP
	--for teams in pairs(teams) do print(k) end
	local killplayer = killplayer or false
    if ( not teams[n - 1] ) then return end
if (n <= 3) then
    self:SetObserverMode(OBS_MODE_NONE) -- turn off spectator mode(IF ON)
    self:UnSpectate(OBS_MODE_NONE)
    self:SetTeam( n ) -- set the team to N
	if (killplayer and self:Alive()) then -- if the player is alive, then kill him
		self:Kill()
	end
    self:Give("weapon_knife") -- give the player a knife
    self:SetPlayerColor( teams[n - 1].color ) -- set the players color based on the team
    self:SetHealth(100) -- set health
    --self:SetMaxHealth(200)
    self:SetWalkSpeed(180) -- css walk speed
    self:SetRunSpeed( 200 ) -- css run speed 
    self:SetModel(teams[n - 1].models[math.random(#teams[n - 1].models)]) -- we can change this based on team, and probably will.
	self:Spawn()
	end
  if (n == 4) then -- If they are a spectator, then please follow these stupid fucking guidelines.
    self:SetTeam(n)
    self:SetObserverMode(OBS_MODE_ROAMING)
    self:Spectate(OBS_MODE_ROAMING)
  end
end


function ply:SwitchTeam(--[[optional]]killplayer)
	-- run checks to make sure that the other team is not full.
	print(string.format("team 1 : %d, team 2: %d", team.NumPlayers(1), team.NumPlayers(2)))
	if(GetAll() > 1) then
		-- run code if players are in the server
		if(team.NumPlayers(2) > team.NumPlayers(3)) then -- check if ct > t, if so switch
			//ply:Kill()
			if(self:Team() == 3) then
				return
			end
			self:SetupTeam(3, false)
			self:ChatPrint(string.format("You are now on the %s side", teams[2].name))
		-- end
		elseif (team.NumPlayers(2) < team.NumPlayers(3)) then -- check if t > ct
			//ply:Kill()
			if(self:Team() == 2) then
				return
			end
			self:SetupTeam(2, false)
			self:ChatPrint(string.format("You are now on the %s side", teams[1].name))
		elseif (team.NumPlayers(2) == team.NumPlayers(3)) then
			if(self:Team() == 2 or self:Team() == 3) then
				self:ChatPrint("The other team is full")
				return
			else
				self:SetupTeam(math.random(3, 2), false)
			end
			return
		end
	else
		-- run code if server is empty
		self:SetupTeam(math.random(3, 2))
	end
end

function GetAll()
	return #player.GetAll()
end


--play death sound for everyone to hear
hook.Add("PlayerDeath", "DeathNoise", function (ply)
	sound.Play(string.format("player/death%d.wav", math.random(1,6)), ply:GetPos(), 150, 100, 1)
	-- death1 --> death6
end)

hook.Add("PlayerShouldTakeDamage", "AntiTeamKill", function(ply, attack)
	if(attack:IsPlayer()) then
		if(ply:Team() == attack:Team()) then
			--add code here to let the attacker know you are on the same team, maybe a css voice command
			local voiceline = {
				[0] = "bot/cut_it_out.wav",
				[1] = "bot/what_are_you_doing.wav",
				[2] = "bot/stop_it.wav",
				[3] = "bot/hold_your_fire.wav",
				[4] = "bot/pain2.wav", 
				[5] = "bot/pain10.wav",
				[6] = "bot/pain4.wav",
				[7] = "bot/pain5.wav",
				[8] = "bot/pain8.wav",
				[9] = "bot/pain9.wav",
			}
			sound.Play(voiceline[math.random(0,9)], attack:GetPos(), 50) -- print to chat
			return false
		end
	end
end)

hook.Add("PlayerSpawn", "BalanceTeam", function (ply)
	local playerbase = FindMetaTable("Player")
	ply:SetModel(teams[ply:Team() - 1].models[math.random(#teams[ply:Team() - 1].models)]) -- we can change this based on team, and probably will.
	
	if(GetAll() > 1) then
		print(string.format("team 1 : %d, team 2: %d", team.NumPlayers(2), team.NumPlayers(3)))
		if(ply:Team() == 2 and team.NumPlayers(2) - 1 > team.NumPlayers(3)) then -- check if ct > t, if so switch
			//ply:Kill()
			ply:SetupTeam(3, false)
			ply:ChatPrint(string.format("You've been autobalanced on to the %s side", teams[2].name))
		-- end
		elseif (ply:Team() == 3 and team.NumPlayers(3)  < team.NumPlayers(2) - 1) then -- check if t > ct
			//ply:Kill()
			ply:SetupTeam(2, false)
			ply:ChatPrint(string.format("You've been autobalanced on to the %s side", teams[1].name))
		-- end
		-- else
		-- 	ply:SetupTeam(math.random(2, 1), false)
		-- 	print("Randomizing Team...")
		end
	end
end)

hook.Add("PlayerSpawn", "GiveWeapons", function (ply)
	for item,weapon in pairs(teams[ply:Team() - 1].weapons) do
		ply:Give(weapon)
	end
end)

hook.Add("PlayerPostThink", "GiveSuit", function(ply)
	ply:EquipSuit()
end)
