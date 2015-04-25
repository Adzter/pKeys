net.Receive( "pKeysAdminMenu", function()
	local keys = net.ReadTable()

	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 400, 300 )
	DFrame:Center()
	DFrame:SetTitle("")
	DFrame:MakePopup()
	
	function DFrame:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 39, 174, 96) )
		draw.SimpleText( "Generate pKey", "Trebuchet18", w/2, 3, Color(255,255,255), TEXT_ALIGN_CENTER, 0 )
	end
	
	--Make a drop down menu 
	local DComboBox = vgui.Create( "DComboBox", DFrame )
	DComboBox:SetPos( 10, 35 )
	DComboBox:SetSize( DFrame:GetWide() - 210, 20 )
	
	--Add all of the possible ranks you can generate
	for k,v in pairs( pKey.canGenerate ) do
		DComboBox:AddChoice( v )
	end
	
	local DListView = vgui.Create( "DListView", DFrame )
	DListView:SetSize( DFrame:GetWide() - 20, DFrame:GetTall() - 75 )
	DListView:SetPos( 10, 65 )
	DListView:AddColumn( "Key" )
	DListView:AddColumn( "Rank" )
	DListView.OnRowRightClick = function( id, line)
		local value = DListView:GetLine( line ):GetValue( 1 )
		SetClipboardText( value )
		notification.AddLegacy( "Key copied to clipboard", NOTIFY_GENERIC, 3 )
	end
	
	local DButton = vgui.Create( "DButton", DFrame )
	DButton:SetSize( 90, 20 )
	DButton:SetText("Generate")
	DButton:SetPos( DFrame:GetWide() - 195, 35 )
	DButton.DoClick = function()		
		net.Start("pKeysGenerateKey")
			net.WriteString( DComboBox:GetSelected() )
		net.SendToServer()
		
		DFrame:Remove()
	end
	
	local DButton = vgui.Create( "DButton", DFrame )
	DButton:SetSize( 90, 20 )
	DButton:SetText("Destroy")
	DButton:SetPos( DFrame:GetWide() - 100, 35 )
	DButton.DoClick = function()
		local line = DListView:GetSelectedLine()
		local value = DListView:GetLine( line ):GetValue( 1 )

		net.Start("pKeysDestroyKey")
			net.WriteString( value .. ".txt" )
		net.SendToServer()
		
		DFrame:Remove()
	end
	
	--If there's any keys add them so the admin can see
	if #keys > 0 then
		for k,v in pairs( keys ) do
			DListView:AddLine( string.StripExtension( v[1] ), v[2] )
		end
	end
end )

net.Receive( "pKeysUserMenu", function()
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 300, 75 )
	DFrame:Center()
	DFrame:SetTitle("")
	DFrame:MakePopup()
	
	function DFrame:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 39, 174, 96) )
		draw.SimpleText( "Redeem pKey", "Trebuchet18", w/2, 3, Color(255,255,255), TEXT_ALIGN_CENTER, 0 )
	end
	
	local DTextEntry = vgui.Create("DTextEntry", DFrame )
	DTextEntry:SetSize( DFrame:GetWide() - 110, 20 )
	DTextEntry:SetPos( 10, 40 )

	local DButton = vgui.Create( "DButton", DFrame )
	DButton:SetSize( 90, 20 )
	DButton:SetText("Redeem")
	DButton:SetPos( DFrame:GetWide() - 95, 40 )
	DButton.DoClick = function()
		net.Start("pKeysRedeemKey")
			local value = DTextEntry:GetValue()
		
			net.WriteString( value .. ".txt" )
		net.SendToServer()
		
		DFrame:Remove()
	end	
end )