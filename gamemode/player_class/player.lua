local ply = FindMetaTable("Player")

teams = { -- defined teams, definitely could use more stuff but this is good enough
	{
		name = "CT",
		color = Vector (0, 0 ,1.0),
		spawnpoint = "info_player_counterterrorist",
		weapons = {}
	},
	{
		name = "T",
		color = Vector (1.0, 0 ,0),
		spawnpoint = "info_player_terrorist",
		weapons = {}
	},
	{
		name = "Spectator",
		color = Vector (0, 0, 0)
	}
}


function ply:SetupTeam( n ) -- TEAM SETUP
	--for teams in pairs(teams) do print(k) end
    if ( not teams[n] ) then return end
if (n <= 2) then
    self:SetObserverMode(OBS_MODE_NONE) -- turn off spectator mode(IF ON)
    self:UnSpectate(OBS_MODE_NONE)
    self:SetTeam( n ) -- set the team to N
	if (self:Alive()) then -- if the player is alive, then kill him
		self:Kill()
	end
    self:Give("weapon_knife") -- give the player a knife
    self:SetPlayerColor( teams[n].color ) -- set the players color based on the team
    self:SetHealth(100) -- set health
    --self:SetMaxHealth(200)
    self:SetWalkSpeed(180) -- css walk speed
    self:SetRunSpeed( 200 ) -- css run speed 
    self:SetModel( "models/player/Group03m/Male_0" .. math.random(1,9) .. ".mdl" ) -- we can change this based on team, and probably will.
  end
  if (n == 3) then -- If they are a spectator, then please follow these stupid fucking guidelines.
    self:SetTeam(n)
    self:SetObserverMode(OBS_MODE_ROAMING)
    self:Spectate(OBS_MODE_ROAMING)
  end
end

hook.Add("PlayerShouldTakeDamage", "AntiTeamKill", function(ply, attack)
	if(attack:IsPlayer()) then
		if(ply:Team() == attack:Team()) then
			--add code here to let the attacker know you are on the same team, maybe a css voice command
			attack:ChatPrint("Hey That's your teammate!") -- print to chat
			return false
		end
	end
end)