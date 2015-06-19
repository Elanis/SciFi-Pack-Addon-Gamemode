ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName	= "Banshee"
ENT.Author	= "Elanis"
ENT.Contact	= ""
ENT.Purpose	= ""
ENT.Instructions= ""
ENT.Spawnable	= true
ENT.AdminSpawnable = true

if(gmod.GetGamemode().Name=="SciFiPack") then 
ENT.Category = "SpaceShips"
else
ENT.Category = "Halo"
end