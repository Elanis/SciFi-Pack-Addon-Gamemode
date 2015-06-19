Stargate = {};

Stargate.Spawnlist = {};

Stargate.Spawnlist.SpaceShips = {};

hook.Add( "StargateTab", "AddStargateProps", function( pnlContent, tree, node )

		local node = tree:AddNode( "SpaceShips", "icon16/folder.png", true );

		node.DoPopulate = function(self)

		-- If we've already populated it - forget it.
		if ( self.PropPanel ) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		--self.PropPanel:SetTriggerSpawnlistChange( false )

		local lines = Stargate.SpawnList.SpaceShips;
		for _,l in pairs(lines) do
		if (not l or l=="") then continue; end
		local cp = spawnmenu.GetContentType( "model" );
		if ( cp ) then
		cp( self.PropPanel, { model = l } )
		end
		end
		
	end
	
	-- If we click on the node populate it and switch to it.
	node.DoClick = function( self )

		self:DoPopulate()
		pnlContent:SwitchPanel( self.PropPanel );

	end

end )

--################# Adds the tab to the spawnmenu @aVoN
function Stargate.AddToolTab()
	-- Add Tab
	-- local logo;
	spawnmenu.AddCreationTab("Stargate",function()
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:CallPopulateHook( "StargateTab" );
		return ctrl
	end, "gui/cap_logo", 30 )

end
hook.Add("AddToolMenuTabs","Stargate.AddToolTab",Stargate.AddToolTab);