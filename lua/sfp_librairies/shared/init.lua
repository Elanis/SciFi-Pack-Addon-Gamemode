--SciFi-Pack Initializing System
--Made by Elanis

SFP = { } --Init Global Var !
SFP.WebVar = "https://raw.githubusercontent.com/Space-Scifi/SciFi-Pack-Addon-Gamemode/master/lua/revision.lua"
SFP.LastRev = 0; --Default


if (SERVER) then
	AddCSLuaFile();
end

-- All convars !
CreateConVar( "sf_ship_count_max", "10", FCVAR_ARCHIVE, "Max Ships" )

function SFP.GetRevision()

	if (file.Exists("lua/sfp_revision.lua","GAME")) then
			SFP.Revision = tonumber(file.Read("lua/sfp_revision.lua","GAME"));
	else
			SFP.Revision = 0 -- For no Lua Errors
	end

end

function SFP.IsUpdated()

	http.Fetch(SFP.WebVar,
		function(html,size)
			local version = tonumber(html);
			if(version) then
				SFP.LastRev = version;

				if (SFP.LastRev > SFP.Revision) then
					SFP.Outdated = true
				end
			end
		end
	);
	
end

function SFP.DrawErrors()
	MsgN("InstallProblem")

	local ErrorFrame = vgui.Create("DFrame");
	ErrorFrame:SetPos(ScrW()/4, ScrH()/4);
	ErrorFrame:SetSize(ScrW()/2,ScrH()/2);
	ErrorFrame:SetTitle("Error");
	ErrorFrame:SetVisible(true);
	ErrorFrame:SetDraggable(false);
	ErrorFrame:ShowCloseButton(true);
	ErrorFrame:SetBackgroundBlur(false);
	ErrorFrame:MakePopup();

	ErrorFrame.Paint = function()
		// Background
		surface.SetMaterial( Material("pp/blurscreen") )
		surface.SetDrawColor( 255, 255, 255, 255 )

		render.UpdateScreenEffectTexture()

		surface.DrawTexturedRect( ScrW()/4, ScrH()/4, ScrW()/2, ScrH()/2 )

		surface.SetDrawColor( 100, 100, 100, 150 )
		surface.DrawRect( ScrW()/4 +  ScrW()/10, ScrH()/4 +  ScrH()/10, ScrW()/2, ScrH()/2 )

		// Border
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawOutlinedRect( 0, 0, ErrorFrame:GetWide(), ErrorFrame:GetTall() )

		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawRect( 20, 35, ErrorFrame:GetWide() - 40, ErrorFrame:GetTall() - 55 )

	end
		local ErrorText = "ERROR: \n"
	if(table.Count(SFP.MissingAddons)>0) then
		ErrorText = ErrorText..Lib.Language.GetMessage('sfp_missing_addon').."\n";

		for i=1,table.Count(SFP.MissingAddons) do
			ErrorText = ErrorText..SFP.MissingAddons[i].."\n"
		end

		ErrorText = ErrorText.."\n"..Lib.Language.GetMessage('sfp_missing_collec').."\n"
	end

	if(SFP.Outdated) then
		ErrorText = ErrorText.."\n\n"..Lib.Language.GetMessage('sfp_outaded').."\n"
	end

	local DLabel = vgui.Create( "DLabel", ErrorFrame )
	DLabel:SetPos( ScrW()/17, ScrH()/20 )
	DLabel:SetSize( ScrW()/2, ScrH()/2 )
	DLabel:SetFont("DermaLarge")
	DLabel:SetText( ErrorText )

end

function SFP.Init()
	--Check Version
	SFP.GetRevision()

	SFP.IsUpdated()


	MsgN("=======================================================");
	if(SFP.Revision==0) then
	MsgN("Initializing SciFi-Pack Revision : UNKNOWN");
	else
	MsgN("Initializing SciFi-Pack Revision "..SFP.Revision);
	end

	if(SFP.Outdated)then
	MsgN("Your Version of SciFi-Pack is outdated ! Please Update it.");
	else
	MsgN("Your Version of SciFi-Pack is up to date !");
	end

	--Check Addons
	MsgN("Searching Addons ...");

	addons = { 
		"SciFi-Pack Addon/Gamemode - Maps / Lua",
		"SciFi-Pack Addon/Gamemode - Models", 
		"SciFi-Pack Addon/Gamemode - Sounds"}
	local materialsCount = 5;
	local modelsCount = 2;
	local errors = 0;
	SFP.MissingAddons = {};
	SFP.AddonsInstalled = {};

	for i=1,modelsCount do 
		table.insert( addons, "SciFi-Pack Addon/Gamemode - Models "..i )
	end

	for i=1,materialsCount do 
		table.insert( addons, "SciFi-Pack Addon/Gamemode - Materials "..i )
	end

	for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do
		if (addon.title==addons[1]) then SFP.AddonsInstalled[1]=true; end
	end
	SFP.Workshop = SFP.AddonsInstalled[1];

	if(SFP.Workshop) then
		MsgN("Workshop Version Launch !")

		for i=2,table.Count(addons) do
			for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do	
				if (addon.title==addons[i]) then 
					SFP.AddonsInstalled[i] = true
					MsgN(addons[i].." found !")
				end
			end

			if(SFP.AddonsInstalled[i]!=true) then
				MsgN(addons[i].." NOT found !")
				errors=errors+1;
				table.insert(SFP.MissingAddons,addons[i]);
			end
		end
	else
		MsgN("Git/Files Version Found !")
	end

	if(errors>0 && CLIENT) then
		MsgN("ERRORS : "..errors);

		hook.Add("SpawnMenuOpen","EAP.ErrorPanel",function()
			MsgN("InitalSpawn");
			EAP.DrawErrors()
			hook.Remove("SpawnMenuOpen","EAP.ErrorPanel")
		end);
		
	end

	MsgN("Loading Librairies ...")
end

----------------------------------------Launch !!!!!!!!!!!-------------------------------------------------------
SFP.Init()