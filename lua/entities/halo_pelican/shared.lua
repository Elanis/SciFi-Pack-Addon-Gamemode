ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName	= "Halo Pelican"
ENT.Author	= "Catdaemon , Elanis"
ENT.Contact	= ""
ENT.Purpose	= ""
ENT.Instructions= ""
ENT.Spawnable	= true
ENT.AdminSpawnable = true

ShuttleEntRollOffset=Angle(0,90,0) -- change if the model you are using fails DOES NOT WORK YET

list.Set("Halo.Ent", ENT.PrintName, ENT);

if(gmod.GetGamemode().Name=="SciFiPack") then 
ENT.Category = "SpaceShips"
else
ENT.Category = "Halo"
end