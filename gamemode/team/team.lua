local Team = class(function(teamnum)
    self.teamnum = teamnum
 end)

function Team:GetAllTeamCount()
    teams = Team.GetAllTeams()
end