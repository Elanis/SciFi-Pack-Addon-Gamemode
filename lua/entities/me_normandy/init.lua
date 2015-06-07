AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local DESTROYABLE=true -- set to false to prevent damage
local HEALTH=1500 -- change to set spawn health of shuttles

function ENT:SpawnFunction( ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create( "me_normandy" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()

	self.Entity:SetNetworkedInt("health",HEALTH)

	self.reloadtime = (4);
	self.Hover = true;
	
	self.Entity:SetUseType( SIMPLE_USE )
	self.In=false
	self.Pilot=nil
	self.Entity:SetModel("models/haxxer/ships/me3NR/normandy_sr2_scale2.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(10000)
		end
	self.Entity:StartMotionController()
	self.Accel=0

	self.CanBomb = true
	self.CanShoot = true

end

function ENT:DoKill()
 	local effectdata = EffectData() 
 		effectdata:SetOrigin( self.Entity:GetPos() ) 
  	util.Effect( "Explosion", effectdata, true, true ) 

	if self.Inf then
	self.Pilot:UnSpectate()
	self.Pilot:DrawViewModel(true)
	self.Pilot:DrawWorldModel(true)
	self.Pilot:Spawn()
	self.Pilot:SetNetworkedBool("isDriveShip",false)
	self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,100))
	end
end

function ENT:OnTakeDamage(dmg)
	if DESTROYABLE then
		local health=self.Entity:GetNetworkedInt("health")
		self.Entity:SetNetworkedInt("health",health-dmg:GetDamage())
		local health=self.Entity:GetNetworkedInt("health")
		if health<1 then
			self.Entity:DoKill()
			self.Entity:Remove()
		end
	end
end

function ENT:OnRemove()
	if self.In then
	self.Pilot:UnSpectate()
	self.Pilot:DrawViewModel(true)
	self.Pilot:DrawWorldModel(true)
	self.Pilot:Spawn()
	self.Pilot:SetNetworkedBool("isDriveShip",false)
	self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,100))
	end
end

function ENT:Think()
	--if not ValidEntity(self.Pilot) then self.Pilot=nil self.In=false end
	if self.In and self.Pilot and self.Pilot:IsValid() then
	
		if self.CanBomb == true then
			if self.Pilot:KeyDown(IN_ATTACK2) then 
				self:FireRight()
				self.CanBomb = false
				timer.Simple(5,function() self.CanBomb=true end)  
			end
		end
		if self.CanShoot == true then
			if self.Pilot:KeyDown(IN_ATTACK) then 
				--On MOUSE_1
				--Bullet FIRE ( TEMPORARY )
				bullet = {}
				bullet.Num=1
				bullet.Src=self.Entity:GetPos()+Vector( 0, 0, 150 )
				--bullet.Dir=self.Entity:GetAngles():Forward()
				bullet.Dir=self.Pilot:GetAimVector()
				bullet.Spread=Vector(0.04,0.04,0)
				bullet.Tracer=1
				bullet.Force=1
				bullet.Damage=25
				bullet.TracerName = "AirboatGunTracer"

				self.Entity:FireBullets(bullet)

				self.Entity:EmitSound("Weapon_AR2.Single") 

				self.CanShoot = false
				timer.Simple(0.1,function() self.CanShoot=true end)
			end
		end
	
		self.Pilot:SetPos(self.Entity:GetPos())
		if self.Pilot:KeyDown(IN_USE) then
			self.In=false
			self.Pilot:UnSpectate()
			self.Pilot:DrawViewModel(true)
			self.Pilot:DrawWorldModel(true)
			self.Pilot:Spawn()
			self.Entity:SetOwner(nil)
			self.Pilot:SetNetworkedBool("isDriveShip",false)
			--self.Pilot:SetPos(self.Entity:GetPos()+self.Entity:GetForward()*-200)
			self.Pilot:SetPos(self.Entity:GetPos()+self.Entity:GetForward()*-150)

			self.Accel=0
			
			self.Entity:SetLocalVelocity(Vector(0,0,0))
			self.Pilot=nil
		end	
		
		
		
			
		self.Entity:NextThink(CurTime())
	else
		self.Entity:NextThink(CurTime()+1)
	end

	
	
return true
end

function ENT:Use(ply,caller)
if !self.In then
	//ply:Spectate( OBS_MODE_ROAMING )
	ply:Spectate( OBS_MODE_CHASE )
	ply:SpectateEntity(self.Entity) 
	ply:StripWeapons()
	self.Entity:GetPhysicsObject():Wake()
	self.Entity:GetPhysicsObject():EnableMotion(true)
	self.Entity:SetOwner(ply)
	self.In=true
	ply:DrawViewModel(false)
	ply:DrawWorldModel(false)
	ply:SetNetworkedBool("isDriveShip",true)
	ply:SetNetworkedEntity("Ship",self.Entity)
	self.Pilot=ply	
	end
end

function ENT:PhysicsSimulate( phys, deltatime )
	if self.In then
		local num=0
		 if self.Pilot:KeyDown(IN_FORWARD) then
               num=500
           elseif self.Pilot:KeyDown(IN_BACK) then
               num=-500
          elseif self.Pilot:KeyDown(IN_SPEED) then
                num=1000
            end
		
		phys:Wake()
			self.Accel=math.Approach(self.Accel,num,10)
		 if not self.Hover then
             if self.Accel>-200 and self.Accel < 200 then return end --with out this you float
         end
		local move={}
			move.secondstoarrive	= 1
			move.pos = self.Entity:GetPos()+self.Entity:GetForward()*self.Accel
				if self.Pilot:KeyDown( IN_DUCK ) then
                   move.pos = move.pos+self.Entity:GetUp()*-200
               elseif self.Pilot:KeyDown( IN_JUMP ) then
                   move.pos = move.pos+self.Entity:GetUp()*300
				end

                if self.Pilot:KeyDown( IN_MOVERIGHT ) then
					move.pos = move.pos+self.Entity:GetRight()*200
				elseif self.Pilot:KeyDown( IN_MOVELEFT ) then
					move.pos = move.pos+self.Entity:GetRight()*-200
				end
			
			
			move.maxangular		= 5000
			move.maxangulardamp	= 10000
			move.maxspeed			= 1000000
			move.maxspeeddamp		= 10000
			move.dampfactor		= 0.8
			move.teleportdistance	= 5000
			local ang = self.Pilot:GetAimVector():Angle()
			move.angle			= ang
			move.deltatime		= deltatime
		phys:ComputeShadowControl(move)
	end
end

function ENT:FireRight()
--On MOUSE_2
end