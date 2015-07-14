ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName	= "Red Eta-2 Actis"
ENT.Author	= "Elanis"
ENT.Contact	= ""
ENT.Purpose	= ""
ENT.Instructions= ""
ENT.Spawnable	= true
ENT.AdminSpawnable = true

list.Set("Sw.Ent", ENT.PrintName, ENT);

if(gmod.GetGamemode().Name=="SciFiPack") then 
ENT.Category = "SpaceShips"
else
ENT.Category = "Star Wars"
end