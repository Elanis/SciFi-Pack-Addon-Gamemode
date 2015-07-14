KSP = {};

KSP.Spawnlist = {};

KSP.Spawnlist.Props = {
"models/KSP/Cockpit.mdl",
"models/KSP/Engine.mdl",
"models/KSP/Engine2.mdl",
"models/KSP/MiniStockEngine.mdl",
"models/KSP/SolidBooster.mdl",
"models/KSP/StockEngine.mdl"
}

hook.Add( "KSPTab", "AddKSPProps", function( pnlContent, tree, node )

		local node = tree:AddNode( "Props", "icon16/folder.png", true );

		node.DoPopulate = function(self)

		-- If we've already populated it - forget it.
		if ( self.PropPanel ) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		--self.PropPanel:SetTriggerSpawnlistChange( false )

		local lines = KSP.Spawnlist.Props;
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
function KSP.AddToolTab()
	-- Add Tab
	-- local logo;
	spawnmenu.AddCreationTab("KSP",function()
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:CallPopulateHook( "KSPTab" );
		return ctrl
	end, "icon16/bricks.png", 70 )

end
hook.Add("AddToolMenuTabs","KSP.AddToolTab",KSP.AddToolTab);