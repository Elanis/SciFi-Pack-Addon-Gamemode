include('shared.lua')

local HoverTex=Material("effects/blueflare1")

local EnterMessageAlpha=0
LocalPlayerIsDrivingShuttle=false

function ShuttleLocalDrivingChanged(entity, name, oldval, newval)
	if newval==true and LocalPlayerIsDrivingShuttle==false then
		EnterMessageAlpha=4
	end
	LocalPlayerIsDrivingShuttle=newval
end
hook.Add("InitPostEntity","ShuttleInitAddProxy",function()
	LocalPlayer():SetNetworkedVarProxy( "isDriveShuttle", ShuttleLocalDrivingChanged )
end)

function sCalc( ply, origin, angles, fov )
	if not LocalPlayer().sDistz then
		LocalPlayer().sDistz=100
	end
	if LocalPlayer().sDistz<1 then LocalPlayer().sDistz=1 end
	if LocalPlayer().sDistz>1000 then LocalPlayer().sDistz=1000 end
	local shut=LocalPlayer():GetNetworkedEntity("Shuttle",LocalPlayer())
	if LocalPlayerIsDrivingShuttle and shut~=LocalPlayer() and shut:IsValid() then
		local view = {}
			view.origin = shut:GetPos()+ply:GetAimVector():GetNormal()*-LocalPlayer().sDistz
			view.angles = angles
		return view
	end
end
hook.Add("CalcView", "MyCalcView", sCalc)

function ENT:Think()	
	if LocalPlayerIsDrivingShuttle then
		if LocalPlayer():KeyDown(IN_JUMP) then
			LocalPlayer().sDistz=LocalPlayer().sDistz+5
		end
		if LocalPlayer():KeyDown(IN_DUCK) then
			LocalPlayer().sDistz=LocalPlayer().sDistz-5
		end
	end
end