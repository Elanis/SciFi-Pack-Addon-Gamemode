--[[
	SciFi-Pack Ship Base
	Copyright 2014-2016 - Made by Elanis

	This script is based on scripts by RononDex / CatDeamon / LightDemon/ Votekick
	Thanks to them to helping me making my system.

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

ENT.Type = "vehicle"
ENT.Base = "base_anim"
ENT.PrintName	= "Ship Base"
ENT.Author	= "Elanis"
ENT.Contact	= "elanis@hotmail.com"
ENT.Spawnable	= false
ENT.AdminSpawnable = false

if (SERVER) then

	function ENT:Initialize()

		self.Pilot = nil
		self.Piloting = false
		self.WeaponsTable = {}

		self.Entity:SetModel(self.Model)
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		
		self.Entity:StartMotionController()
		
		self.Speed=0
	end


	function ENT:Think()
		
		if self.Piloting and self.Pilot and self.Pilot:IsValid() and IsValid(self.Pilot)then
		
			if self.Pilot:KeyDown(IN_ATTACK) then
				self:PrimaryFire()
			elseif self.Pilot:KeyDown(IN_ATTACK2) then
				self:SecondaryFire()
			elseif self.Pilot:KeyDown(IN_USE) then
				self.Exit()
			end

			self.Entity:NextThink(CurTime())
		else
			self.Entity:NextThink(CurTime()+1)
		end

		return true
	end

	function ENT:Exit()

		if (self.EngineSound) then
			self.EngineSound:Stop();
		end

		self.Piloting=false

		self.Pilot:UnSpectate()
		self.Pilot:DrawViewModel(true)
		self.Pilot:DrawWorldModel(true)
		self.Pilot:Spawn()

		self.Entity:SetOwner(nil)
		self.Pilot:SetNetworkedBool("Driving",false)
		self.Pilot:SetPos(self.Entity:GetPos()+self.Entity:GetRight()*150)

		self.Speed = 0 -- Stop the motor
		self.Entity:SetLocalVelocity(Vector(0,0,0)) -- Stop the ship
		
		for _,v in pairs(self.WeaponsTable) do
		self.Pilot:Give(tostring(v));
		end

		table.Empty(self.WeaponsTable);

		self.Pilot=nil

	end

	function ENT:OnTakeDamage(dmg)
		
		local health = self.Entity:GetNetworkedInt("health")
		local damage = dmg:GetDamage()

		self.Entity:SetNetworkedInt("health",health-damage)

		if((health-damage)<1) then
			self.Entity:Remove()
		end
	end


	function ENT:OnRemove()

		if (self.EngineSound) then
			self.EngineSound:Stop();
		end

		local health = self.Entity:GetNetworkedInt("health")

		if(health<1) then	
			local effect = EffectData()
				effect:SetOrigin(self.Entity:GetPos())
			util.Effect("Explosion", effect, true, true )
		end
		
		if(self.Piloting) then
			self.Pilot:UnSpectate()
			self.Pilot:DrawViewModel(true)
			self.Pilot:DrawWorldModel(true)
			self.Pilot:Spawn()
			self.Pilot:SetNetworkedBool("Driving",false)
			self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,100))
		end
	end

	function ENT:Use(ply,caller)
		if not self.Piloting then
		
			self.Piloting=true
		
			ply:Spectate( OBS_MODE_CHASE )
			ply:SpectateEntity(self.Entity) 
			ply:StripWeapons()
			
			self.Entity:GetPhysicsObject():Wake()
			self.Entity:GetPhysicsObject():EnableMotion(true)
			self.Entity:SetOwner(ply)
			
			ply:DrawViewModel(false)
			ply:DrawWorldModel(false)
			ply:SetNetworkedBool("Driving",true)
			ply:SetNetworkedEntity("Ship",self.Entity)
			self.Pilot=ply
			
		end
	end

end

if(CLIENT) then

	function ENT:Initialize()
		if (self.Sounds and self.Sounds.Engine!="") then
			self.EngineSound = self.EngineSound or CreateSound(self.Entity,self.Sounds.Engine);
		end
	end

	function ViewPoint( ply, origin, angles, fov )
		
		local ship = LocalPlayer():GetNetworkedEntity("Ship",LocalPlayer())

		if LocalPlayer():GetNetworkedBool("Driving",false) and ship~=LocalPlayer() and ship:IsValid() then
			local view = {}
				view.origin = ship:GetPos() + ship.View.Pos + ply:GetAimVector():GetNormal()*ship.View.Dist + LocalPlayer():GetAimVector():GetNormal()
				view.angles = angles + ship.View.Angles
			return view
		end
	end
	hook.Add("CalcView", "ShipView", ViewPoint)

	function CalcViewThing( pl, origin, angle, fov )

		local ang = pl:GetAimVector();
		local pos = self.Entity:GetPos() + Vector( 0, 0, 64 ) - ( ang * 2000 );
		local speed = self.Entity:GetVelocity():Length() - 500;

		--Direction to Face
		local face = ( ( self.Entity:GetPos() + Vector( 0, 0, 40 ) ) - pos ):Angle();

		--Trace to keep it out the walls
		local trace = {
			start = self.Entity:GetPos() + Vector( 0, 0, 64 ),
			endpos = self.Entity:GetPos() + Vector( 0, 0, 64 ) + face:Forward() * ( 2000 * -1 );
			mask = MASK_NPCWORLDSTATIC,
		};
		local tr = util.TraceLine( trace );

		--View
		local view = {
			origin = tr.HitPos + tr.HitNormal,
			angles = face,
			fov = 90,

		};

		return view;
	end

	function ENT:Think()
		if(self.Piloting) then
			self:StartClientsideSound("Engine");
		else
			self:StopClientsideSound("Engine");
		end
	end

	--################# Starts a sound clientside @aVoN
	function ENT:StartClientsideSound(mode)
		if(not self.SoundsOn[mode]) then
			if(mode == "Engine" and self.EngineSound) then
				self.EngineSound:Stop();
				self.EngineSound:SetSoundLevel(90);
				self.EngineSound:PlayEx(1,100);
			end
			self.SoundsOn[mode] = true;
		end
	end

	--################# Stops a sound clientside @aVoN
	function ENT:StopClientsideSound(mode)
		if(self.SoundsOn[mode]) then
			if(mode == "Engine" and self.EngineSound) then
				self.EngineSound:FadeOut(2);
			end
			self.SoundsOn[mode] = nil;
		end
	end
end