include('shared.lua')

function ViewPoint( ply, origin, angles, fov )

	local jump=LocalPlayer():GetNetworkedEntity("Ship",LocalPlayer())
	local dist= -300

	if LocalPlayer():GetNetworkedBool("Driving",false) and jump~=LocalPlayer() and jump:IsValid() then
		local view = {}
			view.origin = jump:GetPos()+Vector( 0, 0, 250 )+ply:GetAimVector():GetNormal()*dist +LocalPlayer():GetAimVector():GetNormal()
			view.angles = angles
		return view
	end
end
hook.Add("CalcView", "ShipView", ViewPoint)

function CalcViewThing( pl, origin, angle, fov )

	local ang = pl:GetAimVector();
	
	local pos = self.Entity:GetPos() + Vector( 0, 0, 64 ) - ( ang * 2000 );
	local speed = self.Entity:GetVelocity():Length() - 500;

	// the direction to face
	local face = ( ( self.Entity:GetPos() + Vector( 0, 0, 40 ) ) - pos ):Angle();

	// trace to keep it out of the walls
	local trace = {
		start = self.Entity:GetPos() + Vector( 0, 0, 64 ),
		endpos = self.Entity:GetPos() + Vector( 0, 0, 64 ) + face:Forward() * ( 2000 * -1 );
		mask = MASK_NPCWORLDSTATIC,

	};
	local tr = util.TraceLine( trace );

	// setup view
	local view = {
		origin = tr.HitPos + tr.HitNormal,
		angles = face,
		fov = 90,

	};

	return view;

end