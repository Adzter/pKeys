util.AddNetworkString("pKeysAdminMenu")
util.AddNetworkString("pKeysDestroyKey")
util.AddNetworkString("pKeysGenerateKey")
util.AddNetworkString("pKeysUserMenu")
util.AddNetworkString("pKeysRedeemKey")

--Helper function to update easily without repeating code
local function SendGUI( ply )
	local files = {}
	for k,v in pairs( file.Find( "pkeys/*.txt", "DATA" ) ) do
		local contents = file.Read( "pkeys/" .. v )
		table.insert( files, { v, contents } )
	end

	net.Start("pKeysAdminMenu")
		net.WriteTable( files )
	net.Send( ply )
end

hook.Add("PlayerSay", "pKeysCommand", function( ply, text, team )
	if (string.sub( text, 1, 3 ) == "!pk") then
	
		--If the player has the required rank then let them
		--open the generate menu, else let them open the
		--redeem menu.
		
		if table.HasValue( pKey.permissions, ply:GetUserGroup() ) then
			SendGUI( ply )
		else
			net.Start("pKeysUserMenu")
			net.Send( ply )
		end
	end
end)

net.Receive( "pKeysDestroyKey", function( len, ply )
	--Only continue if the player has correct permissions
	if not table.HasValue( pKey.permissions, ply:GetUserGroup() ) then return end

	local key = net.ReadString()
	file.Delete( "pkeys/" .. key )
	
	SendGUI( ply )
end )

net.Receive( "pKeysGenerateKey", function( len, ply )
	--Only continue if the player has correct permissions
	if not table.HasValue( pKey.permissions, ply:GetUserGroup() ) then return end
	
	local rank = net.ReadString()
	
	--Make sure the rank that's being generated is allowed
	--to have a key generated for it
	if table.HasValue( pKey.canGenerate, rank ) then
		file.Write( "pkeys/" .. generateKey() .. ".txt", rank )
	end

	SendGUI( ply )
end )

function generateKey()
	--Thanks to ^seth: 
	--http://facepunch.com/showthread.php?t=1072047&p=28755362&viewfull=1#post28755362
	
	--Essentially this function just generates a bunch
	--of random characters.
	local str = string.char(math.random(35, 41))
	for i=1, 5 do
		str = str .. string.char(math.random(97, 122))
	end
	for i=1, 5 do
		str = str .. string.char(math.random(63, 91))
	end
	for i=1, 5 do
		str = str .. string.char(math.random(97, 122))
	end	
	for i=1, 3 do
		str = str .. string.char(math.random(48, 57))
	end
	for i=1, 2 do
		str = str .. string.char(math.random(35, 41))
	end	
	
	return str
end

net.Receive( "pKeysRedeemKey", function( len, ply )
	--Setup the cooldown if this is the first time
	if not ply.cooldown then
		ply.cooldown = CurTime() - 1
	end
	
	--If the cooldown is still active, notify the player
	if ply.cooldown > CurTime() then
		if pKey.darkRP then
			DarkRP.notify( ply, 1, 3, pKey.cooldownMessage )
		else
			ply:ChatPrint( pKey.cooldownMessage )
		end
		return
	end
	
	--Set the cooldown
	ply.cooldown = CurTime() + pKey.cooldownTime
	
	--Find the files with that key name
	local files = file.Find( "pkeys/" .. net.ReadString(), "DATA" )
	
	--See if we've got a result
	if #files > 0 then
		--Read the contents of the file
		local contents = file.Read( "pkeys/" .. files[1], "DATA" )
		
		--Add the user to the rank
		RunConsoleCommand( "ulx", "adduser", ply:Nick(), contents )
		
		--Since they're redeeming a key, remove it
		file.Delete( "pkeys/" .. files[1] )
		
		--Notify the user
		if pKey.darkRP then
			DarkRP.notify( ply, 0, 3, pKey.added .. contents )
		else
			ply:ChatPrint( pKey.added .. contents )
		end
	else
		--If we couldn't find the key, tell the user
		if pKey.darkRP then
			DarkRP.notify( ply, 1, 3, pKey.notFound )
		else
			ply:ChatPrint( pKey.notFound )
		end
	end
end )