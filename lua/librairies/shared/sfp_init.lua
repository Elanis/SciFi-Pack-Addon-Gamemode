--SciFi-Pack Initializing System
--Made by Elanis

SFP = SFP or {}; --Init Global Var !
SFP.WebVar = "https://raw.githubusercontent.com/Elanis/SciFi-Pack-Addon-Gamemode/master/lua/scifipack_revision.lua"
SFP.LastRev = 0; --Default


if (SERVER) then
	AddCSLuaFile();
end

function GetRevision()

	if (file.Exists("lua/scifipack_revision.lua","GAME")) then
			SFP.Revision = tonumber(file.Read("lua/scifipack_revision.lua","GAME"));
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
	
	if (addon.title=="SciFi-Pack Addon/Gamemode Main Part - Maps / Lua") then SFP.Workshop = true else SFP.Workshop = false end
	
	end

	if(SFP.Workshop) then 
	
		MsgN("Workshop Version Launch !")
	
		if(SFP.Models) then MsgN("Models part found !") else MsgN("Models part NOT found") end
		
		if(SFP.Materials) then MsgN("Materials part found !") else MsgN("Materials part NOT found") end
		
		if(SFP.Sounds) then MsgN("Sounds part found !") else MsgN("Sounds part NOT found") end
	
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
	
		if(!SFP.Models or !SFP.Materials or !SFP.Sounds) then
	
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