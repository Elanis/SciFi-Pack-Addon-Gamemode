-- Global Vars
SFP = SFP or {};
Lib = Lib or {};
SFP.SpawnList = {};

-- We're including all librairies ! @Elanis

-- Monitoring (needed before init)
if(SERVER)then
	include('sfp_librairies/server/monitoring.lua');
end

--Initializing System
IncludeCS('sfp_librairies/shared/init.lua');

-- PlayerModels
IncludeCS('sfp_librairies/shared/playermodel.lua');

-- Halo Vehicles
IncludeCS('sfp_librairies/shared/halo_vehicles.lua');

-- Language Libs
IncludeCS('sfp_librairies/shared/sg_language_lib.lua');


MsgN("=======================================================");