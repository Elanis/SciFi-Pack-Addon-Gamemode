--SciFi-Pack Initializing System
--Made by Elanis

SFP = SFP or {}; --Init Global Var !
Lib = Lib or {};

-- We're including all librairies ! @Elanis

--Vehicles
IncludeCS('librairies/shared/sfp_vehicles.lua');

--Initializing System
IncludeCS('librairies/shared/sfp_init.lua');

--Playermodels
IncludeCS('librairies/shared/sfp_playermodel.lua');


if(SERVER) then
--Vehicles
include('librairies/server/sfp_convars.lua');

end