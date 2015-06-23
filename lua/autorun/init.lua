--SciFi-Pack Initializing System
--Made by Elanis

SFP = { } --Init Global Var !

if (SERVER) then
	AddCSLuaFile();
end

function GetRevision()

	if (file.Exists("lua/revision.lua","GAME")) then
			SFP.Revision = tonumber(file.Read("lua/revision.lua","GAME"));
	else
			SFP.Revision = 0 -- For no Lua Errors
	end

end

function Init()

GetRevision()

MsgN("=======================================================");
if(SFP.Revision==0) then
MsgN("Initializing SciFi-Pack Revision : UNKNOWN");
else
MsgN("Initializing SciFi-Pack Revision "..SFP.Revision);
end
MsgN("Searching Addons ...");

for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do
	
	if (addon.title=="SciFi-Pack Addon/Gamemode Lua Part") then SFP.Workshop = true end
	
	if(addon.title=="SciFi-Pack Addon/Gamemode BSG Part") then SFP.BSG = true end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Halo Part") then SFP.Halo = true end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Mass Effect Part") then SFP.Me = true end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode StarCraft Part") then SFP.SC = true end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Stargate Part") then SFP.SG = true end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Star Wars Part") then SFP.SW = true end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Other Part") then SFP.Other = true end
	
	end

	if(SFP.Workshop) then 
	
		MsgN("Workshop Version Launch !")
	
		if(SFP.BSG) then MsgN("BSG part found !") else MsgN("BSG part NOT found") end
	
		if(SFP.Halo) then MsgN("Halo part found !") else MsgN("Halo part NOT found") end
	
		if(SFP.Me) then MsgN("Mass Effect part found !") else MsgN("Mass Effect part NOT found") end
	
		if(SFP.SC) then MsgN("StarCraft part found !") else MsgN("StarCraft part NOT found") end
	
		if(SFP.SG) then MsgN("Stargate part found !") else MsgN("Stargate part NOT found") end
	
		if(SFP.SW) then MsgN("Star Wars part found !") else MsgN("Star Wars part NOT found") end
	
		if(SFP.Other) then MsgN("Other part found !") else MsgN("Other part NOT found") end
	
	else
	
		MsgN("Git/SVN/Zip Version Found !")
	
	end
	
MsgN("=======================================================");

end

----------------------------------------Launch !!!!!!!!!!!-------------------------------------------------------
Init()