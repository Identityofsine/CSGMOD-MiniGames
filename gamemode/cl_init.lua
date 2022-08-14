-- include("shared.lua")
-- include("core/timeparser.lua")
resource.AddFile( "resource/fonts/cstrike.ttf" )
//start work on CSS GUI

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
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
