ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName	= "Shuttle"
ENT.Author	= "Elanis"
ENT.Contact	= ""
ENT.Purpose	= ""
ENT.Instructions= ""
ENT.Spawnable	= true
ENT.AdminSpawnable = true

list.Set("BSG.Ent", ENT.PrintName, ENT);

if(gmod.GetGamemode().Name=="SciFiPack") then 
ENT.Category = "SpaceShips"
else
ENT.Category = "BSG"
end
