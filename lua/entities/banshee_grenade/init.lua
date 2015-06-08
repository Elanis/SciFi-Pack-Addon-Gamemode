
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Armed = 0
ENT.Bounces = 0

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "banshee_grenade" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent
	
end


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.Entity:SetModel( "models/h2plasma.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	 
	local phys = self.Entity:GetPhysicsObject()
	
		  if (phys:IsValid()) then
			phys:Wake()
		  end
	MakeSprite( self.Entity, "14", "10 10 255", "sprites/glow1.vmt", "5", "155")
	
	util.PrecacheSound("halo/banshee/plasmagrenexpl.wav")
end

function MakeSprite( Entity, fx, color, spritePath, scale, transity)
	local Sprite = ents.Create("env_sprite");
	Sprite:SetPos( Entity:GetPos() );
	Sprite:SetKeyValue( "renderfx", fx )
	Sprite:SetKeyValue( "model", spritePath)
	Sprite:SetKeyValue( "scale", scale)
	Sprite:SetKeyValue( "spawnflags", "1")
	Sprite:SetKeyValue( "angles", "0 0 0")
	Sprite:SetKeyValue( "rendermode", "9")
	Sprite:SetKeyValue( "renderamt", transity)
	Sprite:SetKeyValue( "rendercolor", color )

	Sprite:Spawn()
	Sprite:Activate()
	Sprite:SetParent( Entity )

end 


/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(ent)

		local effectdata2 = EffectData()
		effectdata2:SetOrigin(self.Entity:GetPos())
		effectdata2:SetEntity(self.Entity)
		effectdata2:SetAttachment(1)
		effectdata2:SetMagnitude(.5)
		effectdata2:SetScale(250)
		util.Effect("plasma_explode", effectdata2)

		local effectdata2 = EffectData()
		effectdata2:SetOrigin(self.Entity:GetPos())
		effectdata2:SetEntity(self.Entity)
		effectdata2:SetAttachment(1)
		effectdata2:SetMagnitude(300)
		util.Effect("plasma_explode_large", effectdata2)

		--ent:EmitSound("weapons/plasmagrenexpl.wav", 500, 100)
		--WorldSound( "weapons/plasmagrenexpl.wav", self.Entity:GetPos(), 400, 100 )

		util.BlastDamage( self.Entity:GetOwner(), self.Entity:GetOwner(), self.Entity:GetPos(), 350, 100 )

		self.Entity:Remove()
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )

	// React physically when shot/getting blown
	self.Entity:TakePhysicsDamage( dmginfo )
	
end

function ENT:Touch(ent)
	if ent:IsValid() then
		if string.find(ent:GetClass(),"trigger_") == 1 then return end
		if string.find(ent:GetClass(),"func_") == 1 then return end
	end
end

/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )


end

function ENT:Think()
	local effectdata = EffectData()
	effectdata:SetOrigin(self.Entity:GetPos())
	effectdata:SetEntity(self.Entity)
	effectdata:SetAttachment(1)
	util.Effect("plasma_emit", effectdata)
	self.Entity:NextThink( CurTime() + 0.1 )
	return true
end


