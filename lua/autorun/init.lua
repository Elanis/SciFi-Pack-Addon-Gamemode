--SciFi-Pack Initializing System
--Made by Elanis

SFP = { } --Init Global Var !
SFP.WebVar = "https://raw.githubusercontent.com/Elanis/SciFi-Pack-Addon-Gamemode/master/lua/revision.lua"
SFP.LastRev = 0; --Default


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

function IsUpdated()

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

function Init()

GetRevision()

IsUpdated()


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

MsgN("Searching Addons ...");

for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do
	
	if (addon.title=="SciFi-Pack Addon/Gamemode Lua Part") then SFP.Workshop = true else SFP.Workshop = false end
	
	if(addon.title=="SciFi-Pack Addon/Gamemode BSG Part") then SFP.BSG = true else SFP.BSG = false end
	
	if(addon.title=="SciFi-Pack Addon/Gamemode Babylon 5 Part") then SFP.Bab = true else SFP.Bab = false end
	
	if(addon.title=="SciFi-Pack Addon/Gamemode Code Lyoko Part") then SFP.CL = true else SFP.CL= false end
	
	if(addon.title=="SciFi-Pack Addon/Gamemode KSP Part") then SFP.KSP = true else SFP.KSP = false end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Halo Part") then SFP.Halo = true else SFP.Halo = false end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Mass Effect Part") then SFP.Me = true else SFP.Me = false end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode StarCraft Part") then SFP.SC = true else SFP.SC = false end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Stargate Part") then SFP.SG = true else SFP.SG = false end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Star Wars Part") then SFP.SW = true else SFP.SW = false end
			
	if(addon.title=="SciFi-Pack Addon/Gamemode Other Part") then SFP.Other = true else SFP.Other = false end
	
	end

	if(SFP.Workshop) then 
	
		MsgN("Workshop Version Launch !")
	
		if(SFP.BSG) then MsgN("BSG part found !") else MsgN("BSG part NOT found") end
		
		if(SFP.Bab) then MsgN("Babylon 5 part found !") else MsgN("Babylon 5 part NOT found") end
		
		if(SFP.CL) then MsgN("Code Lyoko part found !") else MsgN("Code Lyoko part NOT found") end
		
		if(SFP.Bab) then MsgN("KSP part found !") else MsgN("KSP part NOT found") end
	
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

if(CLIENT)then

function DrawErrors()

	if(SFP.Outaded)then

	local frame = vgui.Create("DFrame");
	frame:SetPos(ScrW()-540, 100);
	frame:SetSize(440,130);
	frame:SetTitle("SciFi-Pack Error");
	frame:SetVisible(true);
	frame:SetDraggable(true);
	frame:ShowCloseButton(true);
	frame:SetBackgroundBlur(false);
	frame:MakePopup();
	frame.Paint = function()
		local matBlurScreen = Material( "pp/blurscreen" )

		// Background
		surface.SetDrawColor( 255, 255, 255, 255 )

		surface.DrawTexturedRect( -ScrW()/10, -ScrH()/10, ScrW(), ScrH() )

		surface.SetDrawColor( 100, 100, 100, 150 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )

		// Border
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawOutlinedRect( 0, 0, frame:GetWide(), frame:GetTall() )

		draw.DrawText("Your version of Scifi-Pack is Outaded. Please update it !", "ScoreboardText", 220, 30, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER);
	end

	local close = vgui.Create("DButton", frame);
	close:SetText("Close");
	close:SetPos(340, 95);
	close:SetSize(80, 25);
	close.DoClick = function (btn)
		frame:Close();
	end
	
	end
	
	if(SFP.Workshop)then
	
		if(!SFP.BSG or !SFP.Bab or !SFP.CL or !SFP.KSP or !SFP.Halo or !SFP.ME or !SFP.SC or !SFP.SG or !SFP.SW or !SFP.Other) then
	
			local frame = vgui.Create("DFrame");
				frame:SetPos(ScrW()-540, 300);
				frame:SetSize(440,130);
				frame:SetTitle("SciFi-Pack Error");
				frame:SetVisible(true);
				frame:SetDraggable(true);
				frame:ShowCloseButton(true);
				frame:SetBackgroundBlur(false);
				frame:MakePopup();
				frame.Paint = function()
					local matBlurScreen = Material( "pp/blurscreen" )

					// Background
					surface.SetDrawColor( 255, 255, 255, 255 )

					surface.DrawTexturedRect( -ScrW()/10, -ScrH()/10, ScrW(), ScrH() )

					surface.SetDrawColor( 100, 100, 100, 150 )
					surface.DrawRect( 0, 0, ScrW(), ScrH() )

					// Border
					surface.SetDrawColor( 50, 50, 50, 255 )
					surface.DrawOutlinedRect( 0, 0, frame:GetWide(), frame:GetTall() )

					draw.DrawText("You haven't all the part of our addon please check at http://steamcommunity.com/workshop/filedetails/?id=459240346 if you subscribed to all the addons.", "ScoreboardText", 220, 30, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER);
				end

				local close = vgui.Create("DButton", frame);
					close:SetText("Close");
					close:SetPos(340, 95);
					close:SetSize(80, 25);
					close.DoClick = function (btn)
						frame:Close();
					end
	
		end
	
	end
	
	
end
hook.Add( "PlayerInitialSpawn", "verify",  DrawErrors )

end