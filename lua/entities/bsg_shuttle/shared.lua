ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName	= "Shuttle"
ENT.Author	= "Catdeamon , Elanis"
ENT.Contact	= ""
ENT.Purpose	= ""
ENT.Instructions= ""
ENT.Spawnable	= true
ENT.AdminSpawnable = true

list.Set("Bsg.Ent", ENT.PrintName, ENT);

if(gmod.GetGamemode().Name=="SciFiPack") then 
ENT.Category = "SpaceShips"
else
ENT.Category = "BSG"
end
