--[[
	SciFi-Pack Artemis Ship
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
ENT.Base = "sf_shipbase"
ENT.PrintName	= "Artemis"
ENT.Author	= "Elanis"
ENT.Contact	= "elanis@hotmail.com"
ENT.Spawnable	= true
ENT.AdminSpawnable = true

list.Set("B5.Ent", ENT.PrintName, ENT);

AddCSLuaFile()

if(gmod.GetGamemode().Name=="SciFiPack") then 
ENT.Category = "SpaceShips"
else
ENT.Category = "Babylon 5"
end

--Entity Global Vars
ENT.Model = Model("models/mymodel/Artemis/artemis.mdl")
ENT.Name = "Artemis"
ENT.Sounds = {}
ENT.Sounds.Engine = ""
ENT.Sounds.MainWeapon = ""
ENT.Sounds.SecondWeapon = ""

if (SERVER) then

	function ENT:SpawnFunction( ply, tr)

		local PropLimit = GetConVar("sf_ship_count_max"):GetInt()

		if(ply:GetCount("sf_ship_count")+1 > PropLimit) then
			print("TROP DE VAISSEAUX");
			return
		end

		local ent = ents.Create("b5_artemis") --SpaceShip entity
		ent:SetPos( tr.HitPos + Vector(0,0,100))
		ent:SetAngles( Angle(0,0,90) )
		ent:Spawn()
		ent:Activate()
		ply:AddCount("sf_ship_count",ent)
		return ent
	end

	function ENT:Initialize()

		self.View = {}
		self.View.Dist = -300
		self.View.Pos = Vector(0,0,150)
		self.View.Angles = Angle(0,0,0)

		self.MaxHealth = 1000
		self.Mass = 10000

		self.Entity:SetNetworkedInt("health",self.MaxHealth)

		local phys = self.Entity:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(self.Mass)
		end

	end

	function ENT:PhysicsSimulate( phys, deltatime )

		if self.Piloting and IsValid(self.Pilot) then
		
			local speedvalue=0
			
					if self.Pilot:KeyDown(IN_FORWARD) then
						speedvalue=500
					elseif self.Pilot:KeyDown(IN_BACK) then
						speedvalue=-500
					elseif self.Pilot:KeyDown(IN_SPEED) then
						speedvalue=1000
					end

			 phys:Wake()
			 
			 self.Speed = math.Approach(self.Speed,speedvalue,10)
			 
			 local move = { }
				 move.secondstoarrive = 1
				 move.pos = self.Entity:GetPos()+self.Entity:GetForward()*self.Speed
					
					if self.Pilot:KeyDown( IN_DUCK ) then
	                    move.pos = move.pos+self.Entity:GetRight()*200
	                elseif self.Pilot:KeyDown( IN_JUMP ) then
	                   move.pos = move.pos+self.Entity:GetRight()*-200
	                elseif self.Pilot:KeyDown( IN_MOVERIGHT ) then
						move.pos = move.pos+self.Entity:GetUp()*200
					elseif self.Pilot:KeyDown( IN_MOVELEFT ) then
						move.pos = move.pos+self.Entity:GetUp()*-200
					end
			
				move.maxangular		= 5000
				move.maxangulardamp	= 10000
				move.maxspeed			= 1000000
				move.maxspeeddamp		= 10000
				move.dampfactor		= 0.8
				move.teleportdistance	= 5000
				local ang = self.Pilot:GetAimVector():Angle() + Angle(0,0,90)
				move.angle			= ang
				move.deltatime		= deltatime
			phys:ComputeShadowControl(move)
			
			self.Pilot:SetPos(self.Entity:GetPos())
		end
	end

	function ENT:PrimaryFire()
	-- When we Push MOUSE_1

	end

	function ENT:SecondaryFire()
	-- When we Push MOUSE_2

	end
end