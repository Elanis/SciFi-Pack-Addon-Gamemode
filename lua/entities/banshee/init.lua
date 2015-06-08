AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:SpawnFunction( ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create( "banshee" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	
	self.Target = Vector(0,0,0);
	self.DroneMaxSpeed = (8000);
	self.AllowAutoTrack = (true);
	self.AllowEyeTrack = (false);
	self.TrackTime = 1000000;
	self.Drones = {};
	self.DroneCount = 0;
	self.MaxDrones = (4);
	self.Track = false;
	self.Launched = false;
	
	self.reloadtime = (4);
	self.Hover = true;
	
	self.Entity:SetUseType( SIMPLE_USE )
	self.In=false
	self.Pilot=nil
	self.Entity:SetModel("models/banshee.mdl")
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


	local trail_one = self.Entity:LookupAttachment( "trail" )
	if (  trail_one == 0 ) then return end

	local trail_two = self.Entity:LookupAttachment( "trail2" )
	if ( trail_two == 0 ) then return end

	local trail = util.SpriteTrail(self.Entity, trail_one, Color(255,255,255), false, 15, 5, 2, 1/(15+1)*0.5, "trails/smoke.vmt")  
	local trail = util.SpriteTrail(self.Entity, trail_two, Color(255,255,255), false, 15, 5, 2, 1/(15+1)*0.5, "trails/smoke.vmt")  


end

function ENT:OnTakeDamage( dmginfo )
	 if self.Pilot != nil then
		self.Pilot:TakeDamage(dmginfo:GetDamage()/3, dmginfo:GetAttacker())
	end
end

function ENT:OnRemove()
	if self.In then
	self.Pilot:UnSpectate()
	self.Pilot:DrawViewModel(true)
	self.Pilot:DrawWorldModel(true)
	self.Pilot:Spawn()
	self.Pilot:SetNetworkedBool("isDriveJumper",false)
	self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,100))
	end
end

function ENT:Think()
	--if not ValidEntity(self.Pilot) then self.Pilot=nil self.In=false end
	if self.In and self.Pilot and self.Pilot:IsValid() then
	
		if self.CanBomb == true then
			if self.Pilot:KeyDown(IN_ATTACK2) then 
				self:FireDrone()
				self.CanBomb = false
				timer.Simple(5,function() self.CanBomb=true end)  
			end
		end
		if self.CanShoot == true then
			if self.Pilot:KeyDown(IN_ATTACK) then 
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
			self.Pilot:SetNetworkedBool("isDriveJumper",false)
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
	ply:SetNetworkedBool("isDriveJumper",true)
	ply:SetNetworkedEntity("Jumper",self.Entity)
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

function ENT:FireDrone()
	local pos = self.Entity:GetPos();
	local vel = self.Entity:GetVelocity();
	local up = self.Entity:GetUp();

	local e = ents.Create("banshee_grenade");

	e.Parent = self.Entity;
	e:SetPos(pos);
	e:SetOwner(self.Pilot);
	e.Owner = self.Entity.Owner;
	e:Spawn();
	e:GetPhysicsObject():SetVelocity(self.Pilot:GetAimVector() * 99999999 + vel);
end