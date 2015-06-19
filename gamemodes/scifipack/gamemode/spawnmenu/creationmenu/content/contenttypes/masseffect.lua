spawnmenu.AddContentType( "Me_entity", function( container, obj )

	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	local icon = vgui.Create( "ContentIcon", container )
		icon:SetContentType( "entity" )
		icon:SetSpawnName( obj.spawnname )
		icon:SetName( obj.nicename )
		icon:SetMaterial( obj.material )
		
		icon.OpenMenu = function( icon )

						local menu = DermaMenu()
							menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
							menu:Open()

						end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon;

end )

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

hook.Add( "MeTab", "AddMeEntity", function( pnlContent, tree, node )


	local Categorised = {}
	
	-- Add this list into the tormoil
	local Vehicles = list.Get( "Me.Vehicles" )		
	if ( Vehicles ) then
		for k, v in pairs( Vehicles ) do
			
			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			v.ClassName = k
			v.PrintName = v.Name
			v.ScriptedEntityType = 'vehicle'
			table.insert( Categorised[ v.Category ], v )
			
		end
	end

	--
	-- Add a tree node for each category
	--
	for CategoryName, v in SortedPairs( Categorised ) do
					
		-- Add a node to the tree
		local node = tree:AddNode( CategoryName, "icon16/bricks.png" );

			-- When we click on the node - populate it using this function
		node.DoPopulate = function( self )
	
			-- If we've already populated it - forget it.
			if ( self.PropPanel ) then return end
		
			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
		
			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
							
				spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", self.PropPanel, 
				{ 
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.ClassName,
					material	= "entities/"..ent.ClassName..".png",
					admin		= ent.AdminOnly
							
				})
																
			end
					
		end

		-- If we click on the node populate it and switch to it.
		node.DoClick = function( self )
	
			self:DoPopulate()		
			pnlContent:SwitchPanel( self.PropPanel );
	
		end

	end

	local Categorised = {}

	-- Add this list into the tormoil
	local SpawnableEntities = list.Get( "Me.Ent" )
	if ( SpawnableEntities ) then
		for k, v in pairs( SpawnableEntities ) do
			v.Category = v.Category or "Other"
			v.__ClassName = k;
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			table.insert( Categorised[ v.Category ], v )
		end
	end

	AddToTab(Categorised, pnlContent, tree, node)
	Categorised = {}

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )

spawnmenu.AddCreationTab("Mass Effect",function()
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:CallPopulateHook( "MeTab" );
		return ctrl
	end, "icon16/bricks.png", 25 )