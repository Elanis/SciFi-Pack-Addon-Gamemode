AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local DESTROYABLE=true -- set to false to prevent damage
local HEALTH=1500 -- change to set spawn health
local FLAMETRAIL=false -- set to true for the old flame trail
local HOVERMODE=true -- set to true to hover instead of drop when shift is held

local soundx=Sound("ambient/atmosphere/undercity_loop1.wav")

function ENT:SpawnFunction( ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create( "pelican" ) --  name of the folder, the name of your flyable vehicle
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self.Entity:SetNetworkedInt("health",HEALTH)

	if (!self.Sound) then
 		self.Sound = CreateSound( self.Entity, soundx )
 	end

	self.Entity:SetUseType( SIMPLE_USE )

	self.Firee=nil
	self.Inflight=false
	self.Pilot=nil
	self.Entity:SetModel("models/pelican.mdl") -- change the model, default pelican.mdl
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
	
	self.Roll=0
end

function ENT:DoKill()
 	local effectdata = EffectData() 
 		effectdata:SetOrigin( self.Entity:GetPos() ) 
  	util.Effect( "Explosion", effectdata, true, true ) 

	self.Sound:Stop()

	if self.Inflight then
	self.Pilot:UnSpectate()
	self.Pilot:DrawViewModel(true)
	self.Pilot:DrawWorldModel(true)
	self.Pilot:Spawn()
	self.Pilot:SetNetworkedBool("isDriveShuttle",false)
	self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,100))
	end
end

function ENT:OnTakeDamage(dmg)
	if DESTROYABLE and not self.Done then
		local health=self.Entity:GetNetworkedInt("health")
		self.Entity:SetNetworkedInt("health",health-dmg:GetDamage())
		local health=self.Entity:GetNetworkedInt("health")
		if health<1 then
			self.Entity:DoKill()
			self.Done=true
			self.Entity:Remove()
		end
	end
end

function ENT:OnRemove()
 	if (self.Sound) then
 		self.Sound:Stop()
 	end
end

function ENT:Think()
--	if not ValidEntity(self.Pilot) then self.Pilot=nil self.Inflight=false end
	if self.Inflight and self.Pilot and self.Pilot:IsValid() then
		if self.Sound then
			self.Sound:ChangePitch(math.Clamp(self.Entity:GetVelocity():Length()/5,1,200),0.001)
		end
		self.Pilot:SetPos(self.Entity:GetPos())
		if self.Pilot:KeyDown(IN_USE) then
			self.Sound:Stop()

			self.Pilot:UnSpectate()
			self.Pilot:DrawViewModel(true)
			self.Pilot:DrawWorldModel(true)
			self.Pilot:Spawn()
			self.Pilot:SetNetworkedBool("isDriveShuttle",false)
			self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,200))

			self.Accel=0
			self.Inflight=false
			if self.Firee then
				self.Firee:Remove()
			end
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
	if not self.Inflight then
		self.Sound:Play()

		self.Entity:GetPhysicsObject():Wake()
		self.Entity:GetPhysicsObject():EnableMotion(true)
		self.Inflight=true
		self.Pilot=ply

		ply:Spectate( OBS_MODE_ROAMING )
		--ply:SpectateEntity( self.Entity )
		ply:DrawViewModel(false)
		ply:DrawWorldModel(false)
		ply:StripWeapons()
		ply:SetNetworkedBool("isDriveShuttle",true)
		ply:SetNetworkedEntity("Shuttle",self.Entity)
		
		if not FLAMETRAIL then return end
		self.Firee = ents.Create("env_fire_trail")
		if !self.Firee then return end
		self.Firee:SetKeyValue("spawnrate","3")
		self.Firee:SetKeyValue("firesprite","sprites/firetrail.spr" )
		self.Firee:SetPos(self.Entity:GetPos())
		self.Firee:SetParent(self.Entity)
		self.Firee:Spawn()
		self.Firee:Activate()
	end
end

function ENT:PhysicsSimulate( phys, deltatime )
	if self.Inflight then
		local hovering=false
		if HOVERMODE and self.Pilot:KeyDown(IN_SPEED) then
			hovering=true
		end
		self.Entity:SetNetworkedBool("hover",hovering)
		local num=0
		if self.Pilot:KeyDown(IN_ATTACK) then
			--Attack MOUSE_1
		elseif self.Pilot:KeyDown(IN_ATTACK2) then
			--Attack MOUSE_2
		elseif self.Pilot:KeyDown(IN_FORWARD) then
			num=700
		end
		
		if self.Pilot:KeyDown(IN_MOVELEFT) then
			//self.Roll=self.Roll-3
		elseif self.Pilot:KeyDown(IN_MOVERIGHT) then
			//self.Roll=self.Roll+3
		end
		
		phys:Wake()
			self.Accel=math.Approach(self.Accel,num,10)
			if self.Accel>-200 and self.Accel < 200 and not self.Pilot:KeyDown(IN_FORWARD) and not hovering then return end
		local pr={}
			pr.secondstoarrive	= 1
			pr.pos				= self.Entity:GetPos()+self.Entity:GetForward()*self.Accel
			pr.maxangular		= 5000
			pr.maxangulardamp	= 10000
			pr.maxspeed			= 1000000
			pr.maxspeeddamp		= 10000
			pr.dampfactor		= 0.8
			pr.teleportdistance	= 5000
				local ang = self.Pilot:GetAimVector():Angle()
				ang.r=ang.r+self.Roll
			pr.angle			= ang
			if self.Pilot:KeyDown(IN_SPEED) then
				if HOVERMODE and num>0 then
					pr.angle=self.Entity:GetAngles()
				elseif not HOVERMODE then
					pr.angle=self.Entity:GetAngles()
				end
			end
			pr.deltatime		= deltatime
		phys:ComputeShadowControl(pr)
	end
end
