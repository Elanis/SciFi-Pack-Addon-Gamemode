TOOL.Tab="BSO";
TOOL.Category = 'Constraints';
TOOL.Name = 'Ultimate Constrainer';

if(CLIENT) then
	language.Add("Tool.ultimate_constrainer.name", "Ultimate Constrainer")
	language.Add("Tool.ultimate_constrainer.desc", "Clear lags , weld and nocollide everything !")
	language.Add("Tool.ultimate_constrainer.0", "Left click - selects/deselects props. Right click - Apply. Reload - Unselect all")
	language.Add("Tool.ultimate_constrainer.1", "Left click - selects/deselects props. Right click - Apply. Reload - Unselect all")
	language.Add("Undone_ultimate_constrainer", "Undone Ultimate Constrainer")
	language.Add("Cleanup_ultimate_constrainer", "Ultimate Constrainer")
end

TOOL.enttbl = {}

function TOOL:IsPropOwner( ply, ent )
	if CPPI then
		return ent:CPPIGetOwner() == ply
	else
		for k, v in pairs( g_SBoxObjects ) do
			for b, j in pairs( v ) do
				for _, e in pairs( j ) do
					if e == ent and k == ply:UniqueID() then return true end
				end
			end
		end
	end
	return false
end

function TOOL:IsSelected( ent )
	local eid = ent:EntIndex()
	return self.enttbl[eid] ~= nil
end

function TOOL:Select( ent )
	local eid = ent:EntIndex()
	if not self:IsSelected( ent ) then -- Select
		local col = Color(0, 0, 0, 0)
		col = ent:GetColor()
		self.enttbl[eid] = col
		ent:SetColor( Color(0, 0, 255, 100) )
		ent:SetRenderMode( RENDERMODE_TRANSALPHA )
	end
end

function TOOL:Deselect( ent )
	local eid = ent:EntIndex()
	if self:IsSelected( ent ) then -- Deselect
		local col = self.enttbl[eid]
		ent:SetColor( col )
		self.enttbl[eid] = nil
	end
end

function TOOL:ParentCheck( child, parent )
	while IsValid( parent ) do
		if child == parent then
			return false
		end
		parent = parent:GetParent()
	end
	return true
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end
	if trace.Entity:IsValid() and trace.Entity:IsPlayer() then return end
	if SERVER and not util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) then return false end
	
	local ply = self:GetOwner()
	
	if (not ply:KeyDown( IN_USE )) and trace.Entity:IsWorld() then return false end

	local ent = trace.Entity
	
	if ply:KeyDown( IN_SPEED ) then -- Area select function
		local SelectedProps = 0
		local Radius = math.Clamp( self:GetClientNumber( "radius" ), 64, 1024 )
		
		for k, v in pairs( ents.FindInSphere( trace.HitPos, Radius ) ) do
			if v:IsValid() and not self:IsSelected( v ) and self:IsPropOwner( ply, v ) then
				self:Select( v )
				SelectedProps = SelectedProps + 1
			end
		end
		
		ply:PrintMessage( HUD_PRINTTALK, "Ultimate Constrainer:" .. SelectedProps .. " props were selected. Ready to constraint!" )
		
	elseif self:IsSelected( ent ) then -- Ent is already selected, deselect it
		self:Deselect( ent )
		
	else -- Select all constrained entities
		local SelectedProps = 0
		
		for k, v in pairs( constraint.GetAllConstrainedEntities( ent ) ) do
			self:Select( v )
			SelectedProps = SelectedProps + 1
		end
		
		ply:PrintMessage( HUD_PRINTTALK, "Ultimate Constrainer:" .. SelectedProps .. " props were selected. Ready to constraint!" )
		
	end
	
	return true
end

function TOOL:RightClick( trace )
	if CLIENT then return true end
	if table.Count( self.enttbl ) < 1 then return end
	if trace.Entity:IsValid() and trace.Entity:IsPlayer() then return end
	if SERVER and not util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) then return false end
	if trace.Entity:IsWorld() then return false end
	
	local ent = trace.Entity
	
	local undo_tbl = {}

	undo.Create( "Utlimate-Constrainer" )
	for k, v in pairs( self.enttbl ) do
		local prop = Entity( k )
		if IsValid( prop ) and self:ParentCheck( prop, ent ) then
			local phys = prop:GetPhysicsObject()
			if IsValid( phys ) then
				local data = {}

				undo.AddEntity( constraint.NoCollide( prop, ent, 0, 0 ) )
				
				undo.AddEntity( constraint.Weld( prop, ent, 0, 0 ) )
					
				data.Mass = phys:GetMass()
				phys:SetMass( 0.1 )
				duplicator.StoreEntityModifier( prop, "mass", { Mass = 0.1 } )
				
				-- Unfreeze and sleep the physobj
				phys:EnableMotion( true )
				phys:Sleep()
				
				-- Restore original color and parent
				prop:SetColor( v )
				prop:SetParent( ent )
				self.enttbl[k] = nil
				
				-- Undo shit
				undo_tbl[prop] = data
			end
		else
			-- Not going to parent, just deselect it
			if IsValid( prop ) then prop:SetColor( v ) end
			self.enttbl[k] = nil
		end
	end
	
	-- Unparenting function for undo
	undo.AddFunction( function( tab, undo_tbl )
		for prop, data in pairs( undo_tbl ) do
			if IsValid( prop ) then
				local phys = prop:GetPhysicsObject()
				if IsValid( phys ) then
					-- Save some stuff because we want ent values not physobj values
					local pos = prop:GetPos()
					local ang = prop:GetAngles()
					local mat = prop:GetMaterial()
					local col = prop:GetColor()
					
					-- Unparent
					phys:EnableMotion( false )
					prop:SetParent( nil )
					
					-- Restore values
					prop:SetColor( col )
					prop:SetMaterial( mat )
					prop:SetAngles( ang )
					prop:SetPos( pos )
					
					if data.Mass then
						phys:SetMass( data.Mass )
					end
					if data.ColGroup then
						prop:SetCollisionGroup( data.ColGroup )
					end
					if data.DisabledShadow then
						prop:DrawShadow( true )
					end
						
				end
			end
		end
	end, undo_tbl )
	undo.SetPlayer( self:GetOwner() )
	undo.Finish()
	
	self.enttbl = {}
	return true
end

function TOOL:Reload()
	if CLIENT then return false end
	if table.Count( self.enttbl ) < 1 then return end
	
	for k,v in pairs( self.enttbl ) do
		local prop = ents.GetByIndex( k )
		if prop:IsValid() then
			prop:SetColor( v )
			self.enttbl[k] = nil
		end
	end
	self.enttbl = {}
	return true
end