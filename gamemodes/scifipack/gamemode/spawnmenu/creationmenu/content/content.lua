include( "ContentIcon.lua" )
include( "PostProcessIcon.lua" )

--include( "NPCSpawnIcon.lua" )
--include( "WeaponSpawnIcon.lua" )

include( "ContentContainer.lua" )
include( "ContentSidebar.lua" )

include( 'ContentTypes/Build.lua' )
include( 'ContentTypes/Babylon.lua' )
include( 'ContentTypes/BSG.lua' )
include( 'ContentTypes/CodeLyoko.lua' )
include( 'ContentTypes/Halo.lua' )
include( 'ContentTypes/Ksp.lua' )
include( 'ContentTypes/MassEffect.lua' )
include( 'ContentTypes/Spacebuild.lua' )
include( 'ContentTypes/StarCraft.lua' )
include( 'ContentTypes/Stargate.lua' )
include( 'ContentTypes/StarTrek.lua' )
include( 'ContentTypes/StarWars.lua' )


local PANEL = {}

AccessorFunc( PANEL, "m_pSelectedPanel", "SelectedPanel" )

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()
		
	self:SetPaintBackground( false )
	
	self.CategoryTable = {}	
	
	self.ContentNavBar = vgui.Create( "ContentSidebar", self );
	self.ContentNavBar:Dock( LEFT );
	self.ContentNavBar:SetSize( 190, 10 );
	self.ContentNavBar:DockMargin( 0, 0, 4, 0 )
	
	
	self.HorizontalDivider = vgui.Create( "DHorizontalDivider", self );	
	self.HorizontalDivider:Dock( FILL );
	self.HorizontalDivider:SetLeftWidth( 175 )
	self.HorizontalDivider:SetLeftMin( 175 )
	self.HorizontalDivider:SetRightMin( 450 )
	
	self.HorizontalDivider:SetLeft( self.ContentNavBar );
	
end

function PANEL:EnableModify()
	self.ContentNavBar:EnableModify()
end

function PANEL:CallPopulateHook( HookName )

	hook.Call( HookName, GAMEMODE, self, self.ContentNavBar.Tree, self.OldSpawnlists )

end

function PANEL:SwitchPanel( panel )

	if ( IsValid( self.SelectedPanel ) ) then
		self.SelectedPanel:SetVisible( false );
		self.SelectedPanel = nil;
	end
	
	self.SelectedPanel = panel

	self.SelectedPanel:Dock( FILL )
	self.SelectedPanel:SetVisible( true )
	self:InvalidateParent()
	
	self.HorizontalDivider:SetRight( self.SelectedPanel );
	
end


vgui.Register( "SpawnmenuContentPanel", PANEL, "DPanel" )
