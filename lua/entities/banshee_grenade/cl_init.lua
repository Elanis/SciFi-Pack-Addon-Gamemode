
include('shared.lua')


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.Color = Color( 255, 255, 255, 255 )
	
end


/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
	
	self:DrawModel()

end

function ENT:Think()    
	local dlight = DynamicLight( self:EntIndex() ) 
	if ( dlight ) then 
		dlight.Pos = self:GetPos() 
		dlight.r = 0
		dlight.g = 121
		dlight.b = 255
		dlight.Brightness = 2.5
		dlight.Decay = 256
		dlight.Size = 256
		dlight.DieTime = CurTime() + 0.1
	end 
end 
