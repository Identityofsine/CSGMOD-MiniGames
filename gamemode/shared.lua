AddCSLuaFile("player_class/player.lua")
include("debug/console_commands.lua")
GM.Name = "CSS MiniGames"
GM.Author = "f/x/"
GM.TeamBased = false 


function GM:Initialize()

  self.BaseClass.Initialize(self)

end


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

