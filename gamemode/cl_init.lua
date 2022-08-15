-- include("shared.lua")
-- include("core/timeparser.lua")
resource.AddFile( "resource/fonts/cstrike.ttf" )
//start work on CSS GUI

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
}

local xAxis = 130
local rounttimer = 0
local function parseTime(seconds)
	-- local minutes = floor(mod(seconds, 3600) / 60)
	-- local seconds = floor(mod(time,60))
	return string.format("%d:%02d",math.floor(seconds / 60), (seconds % 60))

end
-- THIS IS HOW YOU RECIEVE VARIABLES FROM THE SERVER !!
net.Receive("roundtimer", function (length)

	local num = net.ReadInt(12)
	rounttimer = num
	return
end)

net.Receive("roundend", function(len)
	local teamWinner = net.ReadInt(12)
	local choice_table=
	{
		[0] = "radio/rounddraw.wav",
		[1] = "radio/ctwin.wav",
		[2] = "radio/terwin.wav"
	}
	local choice = choice_table[teamWinner]
	if(choice) then
		surface.PlaySound(choice)
	end
end)



hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end

	-- Don't return anything here, it may break other addons that rely on this hook.
end )

--draw health
hook.Add( "HUDPaint", "DRAW_HEALTH", function()
	//surface.SetDrawColor( 0, 0, 0, 61)
	local ply = LocalPlayer()
	local hp = ply:Health() or "0"
    draw.RoundedBox(10, 50, ScrH() - xAxis, 300, 100, Color( 0, 0, 0, 90))
    draw.SimpleText("b", "CSSFONT", 50 + 60, ScrH() - xAxis - 6,  Color(194, 137, 43, 250) , TEXT_ALIGN_CENTER)
	draw.SimpleText(hp, "CSSFONT", 50 + 220, ScrH() - xAxis - 6,  Color(194, 137, 43, 225) , TEXT_ALIGN_CENTER)
	-- pos = { 50 + 150, ScrH() - xAxis + 40  },
end )
--draw armour
hook.Add( "HUDPaint", "DRAW_ARMOUR", function()
	//surface.SetDrawColor( 0, 0, 0, 61)
	local ply = LocalPlayer()
	local discerpency = 450
	local arm = ply:Armor() or "0"
    draw.RoundedBox(10, discerpency + 50, ScrH() - xAxis, 300, 100, Color( 0, 0, 0, 90))
    draw.SimpleText("l", "CSSFONT", discerpency + 50 + 60, ScrH() - xAxis - 6,  Color(194, 137, 43, 250) , TEXT_ALIGN_CENTER)
	draw.SimpleText(arm, "CSSFONT", discerpency + 50 + 220, ScrH() - xAxis - 6,  Color(194, 137, 43, 225) , TEXT_ALIGN_CENTER)
	-- pos = { 50 + 150, ScrH() - xAxis + 40  },
end )
--draw timer
hook.Add( "HUDPaint", "DRAW_TIMER", function()
	//surface.SetDrawColor( 0, 0, 0, 61)
	local ply = LocalPlayer()
	local discerpency = ScrW() / 2 - 200
	local time = rounttimer or "0:00"
    draw.RoundedBox(10, discerpency + 50, ScrH() - xAxis, 350, 100, Color( 0, 0, 0, 90))
    draw.SimpleText("e", "CSSFONT", discerpency + 50 + 60, ScrH() - xAxis - 7,  Color(194, 137, 43, 250) , TEXT_ALIGN_CENTER)
	draw.SimpleText(parseTime(time), "CSSFONT", discerpency + 50 + 220, ScrH() - xAxis - 7,  Color(194, 137, 43, 225) , TEXT_ALIGN_CENTER)
	-- pos = { 50 + 150, ScrH() - xAxis + 40  },
end )
--draw ammoinfo
hook.Add( "HUDPaint", "DRAW_AMMO", function()
	//surface.SetDrawColor( 0, 0, 0, 61)
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	local reserveAmmo = IsValid( wep ) and ply:GetAmmoCount( wep:GetPrimaryAmmoType() ) or "-1"
	local primaryAmmo = IsValid(wep) and wep:Clip1() or "0"
	local discerpency = ScrW() / 2 + 600
	local time = rounttimer or "0:00"
    draw.RoundedBox(10, discerpency + 50, ScrH() - xAxis, 450, 100, Color( 0, 0, 0, 90))
    -- draw.SimpleText("e", "CSSFONT", discerpency + 50 + 60, ScrH() - xAxis - 7,  Color(194, 137, 43, 250) , TEXT_ALIGN_CENTER)
	draw.SimpleText(string.format("%02d|", primaryAmmo), "CSSFONT", discerpency + 50 + 140, ScrH() - xAxis - 7,  Color(194, 137, 43, 225) , TEXT_ALIGN_CENTER)
	draw.SimpleText(reserveAmmo, "CSSFONT", discerpency + 50 + 300, ScrH() - xAxis - 7,  Color(194, 137, 43, 225) , TEXT_ALIGN_CENTER)
	-- pos = { 50 + 150, ScrH() - xAxis + 40  },
end )

local avatars = {}
hook.Add( "ScoreboardShow", "Scoreboard", function()
	
	
	hook.Add( "HUDPaint", "scoreboard", function()
		local width, height =  ScrW() * .55, ScrH() * .65
		local x,y = (ScrW() / 4.425), (ScrH() / 6)
		//surface.SetDrawColor( 0, 0, 0, 61)
		surface.SetDrawColor( 0, 0, 0, 190 )
		surface.DrawRect( x, y, width, height )
		surface.SetDrawColor(190, 165, 82, 90)
		surface.DrawOutlinedRect(x, y, width, height, 2)
		local function drawText()
			local yaxis = 25 + y;
			surface.SetDrawColor(190, 165, 82, 200)
			draw.SimpleText(game.GetMap(), "server-info-font", x + 20, yaxis, Color(190, 165, 82, 200), TEXT_ALIGN_LEFT)
			draw.SimpleText(GetHostName(), "server-info-font", x + 250, yaxis, Color(190, 165, 82, 200), TEXT_ALIGN_LEFT)
			draw.SimpleText("Timeleft: 150", "server-info-font", x * 3, yaxis, Color(190, 165, 82, 200), TEXT_ALIGN_LEFT)
		end
		local function drawTeamBanner()
			local yaxis = 50 + y;
			local xaxis = x + 20;
			local bWidth,bHeight = width / 2 - 25 , 80
			local ctAlive, tAlive = 0, 0;
			for i in ipairs(team.GetPlayers(1)) do //ct
				local ply = team.GetPlayers(1)[i]
				if(ply:Alive()) then
					ctAlive = ctAlive + 1
				else
					ctAlive = ctAlive - 1 > 0 and ctAlive - 1 or 0
				end
			end
			for i in ipairs(team.GetPlayers(2)) do //t
				local ply = team.GetPlayers(2)[i]
				if(ply:Alive()) then
					tAlive = tAlive + 1
				else
					tAlive = tAlive - 1 > 0 and tAlive - 1 or 0
				end
			end
			--ct
			draw.RoundedBox(5, xaxis - 5, yaxis, bWidth, bHeight, Color(91, 113, 129, 190))
			surface.SetDrawColor(91, 113, 129, 250)
			surface.DrawOutlinedRect(xaxis - 5, yaxis, bWidth, bHeight, 2)
			draw.SimpleText("Counter-Terrorists", "banner-text-1", xaxis + 10, yaxis + 15, Color(255,255,255, 200), TEXT_ALIGN_LEFT)
			draw.SimpleText(string.format("%d / %d live players", ctAlive, #team.GetPlayers(1) ), "banner-text-2", xaxis + 50, yaxis + 50, Color(255,255,255, 200), TEXT_ALIGN_LEFT)
			draw.SimpleText("3", "banner-text-3", xaxis + bWidth - 55, yaxis - 12, Color(255,255,255, 200), TEXT_ALIGN_CENTER)
			
			--t
			draw.RoundedBox(5, xaxis + bWidth + 10 , yaxis, bWidth, bHeight, Color(115, 69, 54, 190))
			surface.SetDrawColor(115, 69, 54, 255)
			surface.DrawOutlinedRect(xaxis + bWidth + 10, yaxis, bWidth, bHeight, 2)
			draw.SimpleText("Terrorists", "banner-text-1", xaxis + bWidth * 2 - 100, yaxis + 15, Color(255,255,255, 200), TEXT_ALIGN_LEFT)
			draw.SimpleText(string.format("%d / %d live players", tAlive, #team.GetPlayers(2) ), "banner-text-2", xaxis + bWidth + bWidth * .75 - 5, yaxis + 50, Color(255,255,255, 200), TEXT_ALIGN_LEFT)
			draw.SimpleText("3", "banner-text-3", xaxis + bWidth + 55, yaxis - 12, Color(255,255,255, 200), TEXT_ALIGN_CENTER)
		end
		local function drawScoreBoardPane()
			local yaxis = 160 + y;
			local xaxis = x + 20;
			local bWidth,sHeight = width / 2 - 25 , height * .9 - 100
			--ct
			draw.SimpleText("Name", "scoreboard-text2", xaxis + 135, (yaxis - 20), Color(172, 197, 248, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Score", "scoreboard-text2", xaxis + 525, (yaxis - 20), Color(172, 197, 248, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Deaths", "scoreboard-text2", xaxis + 575, (yaxis - 20), Color(172, 197, 248, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Ping", "scoreboard-text2", xaxis + 625, (yaxis - 20), Color(172, 197, 248, 255), TEXT_ALIGN_LEFT)

			surface.SetDrawColor(91, 113, 129, 250)
			surface.DrawOutlinedRect(xaxis - 5, yaxis, bWidth, sHeight, 2)
			--t
			draw.SimpleText("Name", "scoreboard-text2", xaxis + 135 + bWidth, (yaxis - 20), Color(206, 103, 100, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Score", "scoreboard-text2", xaxis + 525 + bWidth, (yaxis - 20), Color(206, 103, 100, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Deaths", "scoreboard-text2", xaxis + 575 + bWidth, (yaxis - 20), Color(206, 103, 100, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Ping", "scoreboard-text2", xaxis + 625 + bWidth, (yaxis - 20), Color(206, 103, 100, 255), TEXT_ALIGN_LEFT)
			surface.SetDrawColor(115, 69, 54, 255)
			surface.DrawOutlinedRect(xaxis + bWidth + 10, yaxis, bWidth, sHeight, 2)

		end
		local function drawPlayers()
			local yaxis = 160 + y;
			local xaxis = x + 20;
			local function playerCard(player, i)
				local pCWidth, pCHeight = width / 2 - 30, 28;
				local discrepency = (yaxis - 20+ (30 * (i)))
				if(player:Team() == 1) then
					local color = player:Alive() and Color(172, 197, 248, 255) or Color(172, 197, 248, 100) 
					if(player == LocalPlayer()) then
						surface.SetDrawColor(227, 163, 38, 255)
						surface.DrawOutlinedRect(xaxis - 2.5, discrepency - 5, pCWidth,pCHeight, 2)
					end
					draw.SimpleText(player:GetName(), "scoreboard-text", xaxis + 135, discrepency, color, TEXT_ALIGN_LEFT)
					draw.SimpleText(player:Frags(), "scoreboard-text", xaxis + 525, discrepency, color, TEXT_ALIGN_LEFT)
					draw.SimpleText(player:Deaths(), "scoreboard-text", xaxis + 575, discrepency, color, TEXT_ALIGN_LEFT)
					draw.SimpleText(player:Ping(), "scoreboard-text", xaxis + 625, discrepency, color, TEXT_ALIGN_LEFT)
				elseif (player:Team() == 2) then
					local color = player:Alive() and Color(206, 103, 100, 255) or Color(206, 103, 100, 100)
					local gap = width / 2 - 25
					if(player == LocalPlayer()) then
						surface.SetDrawColor(227, 163, 38, 255)
						surface.DrawOutlinedRect(xaxis + 12.25 + gap, discrepency - 5, pCWidth,pCHeight, 2)
					end
					draw.SimpleText(player:GetName(), "scoreboard-text", xaxis + 135 + gap, discrepency, color, TEXT_ALIGN_LEFT)
					draw.SimpleText(player:Frags(), "scoreboard-text", xaxis + 525 + gap, discrepency, color, TEXT_ALIGN_LEFT)
					draw.SimpleText(player:Deaths(), "scoreboard-text", xaxis + 575 + gap, discrepency, color, TEXT_ALIGN_LEFT)
					draw.SimpleText(player:Ping(), "scoreboard-text", xaxis + 625 + gap, discrepency, color, TEXT_ALIGN_LEFT)
				end
			end
			local players = player.GetAll()
			local cti, ti = 0,0
			for ply in ipairs(players)
			do 
				if(players[ply]:Team() == 1) then
					cti = cti + 1
					playerCard(players[ply], cti)
				elseif(players[ply]:Team() == 2) then
					ti = ti + 1
					playerCard(players[ply], ti)
				end
			end
		end
		--inside element
		drawText()
		drawTeamBanner()
		drawScoreBoardPane()
		drawPlayers()
	end )
	print("gay")
	return true
end )
hook.Add("ScoreboardHide", "ScoreboardHide", function ()
	hook.Remove("HUDPaint", "scoreboard")
	for d, i in ipairs(avatars) do
		print(i)
		i:Hide()
		i:Remove()
	end
end)



// FONTS BLOCK

surface.CreateFont( "server-info-font", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 16,
	weight = 500,
	blursize =  0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = true,
	outline = false,
})

surface.CreateFont( "banner-text-1", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 28,
	weight = 500,
	blursize =  0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = true,
	outline = false,
})
surface.CreateFont( "banner-text-2", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 20,
	weight = 500,
	blursize =  0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = true,
	outline = false,
})
surface.CreateFont( "banner-text-3", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 105,
	weight = 500,
	blursize =  0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = true,
	outline = false,
})
surface.CreateFont( "scoreboard-text", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
	weight = 600,
	blursize =  0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = true,
	outline = false,
})
surface.CreateFont( "scoreboard-text2", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 16,
	weight = 400,
	blursize =  0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = true,
	outline = false,
})
surface.CreateFont( "CSSFONT",{
		font = "Counter-Strike", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 100,
		weight = 500,
		blursize = .5,
		scanlines = 2,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = true,
		outline = false,
    }
)
surface.CreateFont( "Arial",{
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 100,
	weight = 500,
	blursize = .5,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = true,
	outline = false,
}
)