StarWars = {};

StarWars.Spawnlist = {};

StarWars.Spawnlist.Props = {
	"models/hgn/swrp/vehicles/at-st_01.mdl",
	"models/at-at.mdl"
}

local function AddToTab(Categorised, pnlContent, tree, node, icon)
	--
	-- Add a tree node for each category
	--
	for CategoryName, v in SortedPairs( Categorised ) do
		-- Add a node to the tree
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
		node.DoClick = function(self)
			self:DoPopulate()
			pnlContent:SwitchPanel( self.PropPanel );
		end
    end
end

hook.Add( "StarWarsTab", "AddStarWarsEntity", function( pnlContent, tree, node )
	local Categorised = {}

	local SpawnableEntities = list.Get( "SW.Ent" )
	if (SpawnableEntities) then
		for k, v in pairs(SpawnableEntities) do
			v.Category = v.Category or "Other"
			v.__ClassName = k;
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			table.insert( Categorised[ v.Category ], v )
		end
	end

	local icon = "icon16/bricks.png";
	AddToTab(Categorised, pnlContent, tree, node, icon)

	local node = tree:AddNode( "Props", "icon16/folder.png", true );

	node.DoPopulate = function(self)
		-- If we've already populated it - forget it.
		if (self.PropPanel) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible(false)
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

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if (IsValid(FirstNode)) then
		FirstNode:InternalDoClick()
	end
end )

spawnmenu.AddCreationTab("Star Wars",function()
	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "StarWarsTab" );
	return ctrl
end, "icon16/bricks.png", 70 )