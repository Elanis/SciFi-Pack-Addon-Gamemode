StarTrek = {};

StarTrek.Spawnlist = {};

StarTrek.Spawnlist.SpaceShips = {};


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


hook.Add( "StarTrekTab", "AddStarTrekProps", function( pnlContent, tree, node )

		local Categorised = {}

		-- Add this list into the tormoil
		local SpawnableEntities = list.Get( "St.Ent" )
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

--[[ 		local node = tree:AddNode( "SpaceShips", "icon16/folder.png", true );

		node.DoPopulate = function(self)

		-- If we've already populated it - forget it.
		if ( self.PropPanel ) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		--self.PropPanel:SetTriggerSpawnlistChange( false )

		local lines = StarTrek.SpawnList.SpaceShips;
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

	end ]]
	
		-- Loop through the weapons and add them to the menu
	local Weapons = list.Get( "Weapon" )
	local Categorised = {}
		
	-- Build into categories
	for k, weapon in pairs( Weapons ) do
			
		if ( !weapon.Spawnable ) then continue end

		Categorised[ weapon.Category ] = Categorised[ weapon.Category ] or {}
		table.insert( Categorised[ weapon.Category ], weapon )
		
	end

	Weapons = nil

	-- Loop through each category
	for CategoryName, v in SortedPairs( Categorised ) do
	
		if(CategoryName=="StarTrek") then
		
		-- Add a node to the tree
		local node = tree:AddNode( "Weapons", "icon16/gun.png" );
				
		-- When we click on the node - populate it using this function
		node.DoPopulate = function( self )
	
			-- If we've already populated it - forget it.
			if ( self.PropPanel ) then return end
		
			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
		
			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
									
				spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", self.PropPanel, 
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
		
	end


	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )

--################# Adds the tab to the spawnmenu @aVoN
function StarTrek.AddToolTab()
	-- Add Tab
	-- local logo;
	spawnmenu.AddCreationTab("StarTrek",function()
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:CallPopulateHook( "StarTrekTab" );
		return ctrl
	end, "icon16/bricks.png", 35 )

end
hook.Add("AddToolMenuTabs","StarTrek.AddToolTab",StarTrek.AddToolTab);