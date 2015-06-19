StarWars = {};

StarWars.Spawnlist = {};

StarWars.Spawnlist.Props = {
"models/hgn/swrp/vehicles/at-st_01.mdl",
"models/at-at.mdl"
}

hook.Add( "StarWarsTab", "AddStarWarsProps", function( pnlContent, tree, node )

		local node = tree:AddNode( "Props", "icon16/folder.png", true );

		node.DoPopulate = function(self)

		-- If we've already populated it - forget it.
		if ( self.PropPanel ) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		--self.PropPanel:SetTriggerSpawnlistChange( false )

		local lines = StarWars.Spawnlist.Props;
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
function StarWars.AddToolTab()
	-- Add Tab
	-- local logo;
	spawnmenu.AddCreationTab("StarWars",function()
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:CallPopulateHook( "StarWarsTab" );
		return ctrl
	end, "icon16/bricks.png", 70 )

end
hook.Add("AddToolMenuTabs","StarWars.AddToolTab",StarWars.AddToolTab);