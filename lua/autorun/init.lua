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

for _,v in pairs(engine.GetAddons()) do
	if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode Lua Part") then
		SFP.Workshop = 1 --So we're using workshop version		
		MsgN("Workshop version initialized");
	elseif (v.mounted and v.wsid=="459224094") then
		SFP.Workshop = 1 --So we're using workshop version		
		MsgN("Workshop version initialized");
	else
		SFP.Workshop = 0 --We're using github/SVN/Unzipped version
		MsgN("Git/SVN/Zip version initialized");
		break;
	end
	
	if(SFP.Workshop) then
	
		if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode Mass Effect Part") then
			SFP.WkME = 1
			MsgN("Workshop Mass Effect Part Found !");
		else
			SFP.WkME = 0
			MsgN("ERROR : No workshop Mass Effect found !");
		end
		
		if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode Star Wars Part") then
			SFP.WkSW = 1
			MsgN("Workshop Star Wars Part Found !");
		else
			SFP.WkME = 0
			MsgN("ERROR : No workshop Star Wars found !");
		end
		
		if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode StarCraft Part") then
			SFP.WkSW = 1
			MsgN("Workshop StarCraft Part Found !");
		else
			SFP.WkME = 0
			MsgN("ERROR : No workshop StarCraft found !");
		end
	
		if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode Halo Part") then
			SFP.WkH = 1
			MsgN("Workshop Halo Part Found !");
		else
			SFP.WkH = 0
			MsgN("ERROR : No workshop Halo found !");
		end
		
		if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode Stargate Part") then
			SFP.WkSG = 1
			MsgN("Workshop Stargate Part Found !");
		else
			SFP.WkSG = 0
			MsgN("ERROR : No workshop Stargate found !");
		end
		
		if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode BSG Part") then
			SFP.WkBSG = 1
			MsgN("Workshop BSG Part Found !");
		else
			SFP.WkBSG = 0
			MsgN("ERROR : No workshop BSG found !");
		end
		
		if (v.mounted and v.title=="SciFi-Pack Addon/Gamemode Other Part") then
			SFP.WkO = 1
			MsgN("Workshop Other Part Found !");
		else
			SFP.WkO = 0
			MsgN("ERROR : No workshop Other found !");
		end
		
	end

end --End of for 

end

----------------------------------------Launch !!!!!!!!!!!-------------------------------------------------------
Init()