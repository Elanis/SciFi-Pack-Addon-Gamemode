ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName	= "Gunship"
ENT.Author	= "Elanis"
ENT.Category 		= "SpaceShip"
ENT.Contact	= ""
ENT.Purpose	= ""
ENT.Instructions= ""
ENT.Spawnable	= true
ENT.AdminSpawnable = true

list.Set("Me.Ent", ENT.PrintName, ENT);

if(gmod.GetGamemode().Name=="SciFiPack") then 
ENT.Category = "SpaceShips"
else
ENT.Category = "Mass Effect"
end