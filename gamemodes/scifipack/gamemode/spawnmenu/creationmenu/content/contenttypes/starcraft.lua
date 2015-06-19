Starcraft = {};

Starcraft.Spawnlist = {};

Starcraft.Spawnlist.Props = {
"models/starcraft/marauder.mdl",
"models/starcraft/marine.mdl",
"models/starcraft/marine_dominion.mdl",
"models/starcraft/marine_gold.mdl",
"models/starcraft/marine_raynor.mdl",
"models/starcraft/marine_tychus.mdl",
"models/starcraft/siegetank.mdl",
"models/starcraft/siegetank_siege.mdl",
"models/starcraft/viking.mdl"
}

local function AddToTab(Categorised, pnlContent, tree, node)
	--
	-- Add a tree node for each category
	--
	for CategoryName, v in SortedPairs( Categorised ) do
		-- Add a node to the tree
		local icon = "icon16/bricks.png";

			local node = tree:AddNode( CategoryName, icon );

				-- When we click on the node - populate it using this function
			node.DoPopulate = function( self )

				-- If we've already populated it - forget it.
				if ( self.PropPanel ) then return end

				-- Create the container panel
				self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
				self.PropPanel:SetVisible( false )
				self.PropPanel:SetTriggerSpawnlistChange( false )

				for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
					local adm_only = false;
					spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", self.PropPanel,
					{
						nicename	= ent.PrintName or ent.__ClassName,
						spawnname	= ent.ClassName,
						material	= "entities/"..ent.ClassName..".png",
						admin		= adm_only,
						author		= ent.Author,
						info		= ent.Instructions,
					})

				end
			end

			-- If we click on the node populate it and switch to it.
			node.DoClick = function( self )

				self:DoPopulate()
				pnlContent:SwitchPanel( self.PropPanel );

			end
    end

end

hook.Add( "StarcraftTab", "AddStarcraftProps", function( pnlContent, tree, node )

--[[ 		local Categorised = {}

		-- Add this list into the tormoil
		local SpawnableEntities = list.Get( "Sc.Ent" )
		if ( SpawnableEntities ) then
			for k, v in pairs( SpawnableEntities ) do
				v.Category = v.Category or "Other"
				v.__ClassName = k;
				Categorised[ v.Category ] = Categorised[ v.Category ] or {}
				table.insert( Categorised[ v.Category ], v )
			end
		end

		AddToTab(Categorised, pnlContent, tree, node)
		Categorised = {} ]]

		local node = tree:AddNode( "Props", "icon16/folder.png", true );

		node.DoPopulate = function(self)

		-- If we've already populated it - forget it.
		if ( self.PropPanel ) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		--self.PropPanel:SetTriggerSpawnlistChange( false )

		local lines = Starcraft.Spawnlist.Props;
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
function Starcraft.AddToolTab()
	-- Add Tab
	-- local logo;
	spawnmenu.AddCreationTab("Starcraft",function()
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:CallPopulateHook( "StarcraftTab" );
		return ctrl
	end, "icon16/bricks.png", 40 )

end
hook.Add("AddToolMenuTabs","Starcraft.AddToolTab",Starcraft.AddToolTab);