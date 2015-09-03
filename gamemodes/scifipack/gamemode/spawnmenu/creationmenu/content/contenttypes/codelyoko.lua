CL = {};

CL.Spawnlist = {};

CL.Spawnlist.Props = {
"models/lyoko/evo_tower.mdl",
"models/lyoko/skid.mdl",
"models/CL/supercalculateur_mk2.mdl"
}

hook.Add( "CLTab", "AddCLProps", function( pnlContent, tree, node )

		local node = tree:AddNode( "Props", "icon16/folder.png", true );

		node.DoPopulate = function(self)

		-- If we've already populated it - forget it.
		if ( self.PropPanel ) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		--self.PropPanel:SetTriggerSpawnlistChange( false )

		local lines = CL.Spawnlist.Props;
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
function CL.AddToolTab()
	-- Add Tab
	-- local logo;
	spawnmenu.AddCreationTab("Code Lyoko",function()
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:CallPopulateHook( "CLTab" );
		return ctrl
	end, "icon16/bricks.png", 70 )

end
hook.Add("AddToolMenuTabs","CL.AddToolTab",CL.AddToolTab);