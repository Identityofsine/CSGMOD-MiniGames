if CLIENT then
SWEP.BounceWeaponIcon = false
SWEP.DrawWeaponInfoBox = false
surface.CreateFont( "CSSelectIcons",
{
font = "csd",
size = 96,
weight = 0
} )
surface.CreateFont( "CSKillIcons",
{
font = "csd",
size = 48,
weight = 0
} )
killicon.AddFont( "weapon_ak47_admin", "CSKillIcons", "b", Color( 80, 255, 0, 255 ) )
end

SWEP.PrintName = "Admin CV-47"
SWEP.Category = "Counter-Strike: Source"
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 1337
SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.UseHands = true
SWEP.HoldType = "ar2"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

SWEP.Scope = 0
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.WalkSpeed = 500
SWEP.RunSpeed = 1000

SWEP.Primary.Sound = Sound( "Weapon_XM1014.Single" )
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 999999
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.NumberofShots = 10
SWEP.Primary.NumberofShotsAlt = 1
SWEP.Primary.Spread = 0.04
SWEP.Primary.SpreadAlt = 0
SWEP.Primary.Delay = 0.1
SWEP.Primary.DelayAlt = 0.14
SWEP.Primary.Force = 420

SWEP.Secondary.Sound = Sound( "Weapon_Scout.Single" )
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.25

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
self.Idle = 0
self.IdleTimer = CurTime() + 1
end

function SWEP:DrawWeaponSelection( x, y, wide, tall )
draw.SimpleText( "b", "CSSelectIcons", x + wide / 2, y + tall / 4, Color( 80, 255, 0, 255 ), TEXT_ALIGN_CENTER )
end

function SWEP:DrawHUD()
if CLIENT then
surface.SetDrawColor( 255, 255, 255, self.Weapon:GetNWInt( "ScopeAlpha", 0 ) )
surface.SetTexture( surface.GetTextureID( "effects/combine_binocoverlay" ) )
surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
surface.SetDrawColor( 255 - self.Weapon:GetNWInt( "ScopeAlpha", 0 ), 255, 255, 255 )
surface.DrawLine( ScrW() / 2 - 8, ScrH() / 2, ScrW() / 2 - 2, ScrH() / 2 )
surface.DrawLine( ScrW() / 2 + 8, ScrH() / 2, ScrW() / 2 + 2, ScrH() / 2 )
surface.DrawLine( ScrW() / 2, ScrH() / 2 - 8, ScrW() / 2, ScrH() / 2 - 2 )
surface.DrawLine( ScrW() / 2, ScrH() / 2 + 8, ScrW() / 2, ScrH() / 2 + 2 )
surface.SetDrawColor( 100, 100, 100, 255 )
surface.DrawLine( ScrW() / 2 - 8, ScrH() / 2 + 1, ScrW() / 2 - 2, ScrH() / 2 + 1 )
surface.DrawLine( ScrW() / 2 + 8, ScrH() / 2 + 1, ScrW() / 2 + 2, ScrH() / 2 + 1 )
surface.DrawLine( ScrW() / 2 + 1, ScrH() / 2 - 8, ScrW() / 2 + 1, ScrH() / 2 - 2 )
surface.DrawLine( ScrW() / 2 + 1, ScrH() / 2 + 8, ScrW() / 2 + 1, ScrH() / 2 + 2 )
end
end

function SWEP:AdjustMouseSensitivity()
return self.Weapon:GetNWInt( "MouseSensitivity", 1 )
end

function SWEP:Deploy()
self:SetWeaponHoldType( self.HoldType )
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Scope = 0
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
self.Owner:SetHealth( 1337 )
return true
end

function SWEP:Holster()
self.Idle = 0
self.IdleTimer = CurTime()
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetFOV( 0, 0 )
self.Owner:SetWalkSpeed( 200 )
self.Owner:SetRunSpeed( 400 )
if self.Owner:Health() > 100 then
self.Owner:SetHealth( 100 )
end
return true
end

function SWEP:PrimaryAttack()
local bullet = {}
if self.Scope == 0 then
bullet.Num = self.Primary.NumberofShots
bullet.Spread = Vector( self.Primary.Spread, self.Primary.Spread, 0 )
self:EmitSound( self.Primary.Sound )
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end
if self.Scope == 1 then
bullet.Num = self.Primary.NumberofShotsAlt
bullet.Spread = Vector( self.Primary.SpreadAlt, self.Primary.SpreadAlt, 0 )
self:EmitSound( self.Secondary.Sound )
self:SetNextPrimaryFire( CurTime() + self.Primary.DelayAlt )
self:SetNextSecondaryFire( CurTime() + self.Primary.DelayAlt )
end
bullet.Src = self.Owner:GetShootPos()
bullet.Dir = self.Owner:GetAimVector()
bullet.Tracer = 0
bullet.Force = self.Primary.Force
bullet.Damage = self.Primary.Damage
bullet.AmmoType = self.Primary.Ammo
self.Owner:FireBullets( bullet )
self:ShootEffects()
self:TakePrimaryAmmo( self.Primary.TakeAmmo )
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
if self.Scope == 0 then
self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
if IsFirstTimePredicted() then
self.Scope = 1
end
self.Weapon:SetNWInt( "ScopeAlpha", 255 )
self.Weapon:SetNWInt( "MouseSensitivity", 0.2 )
self.Owner:SetFOV( self.Owner:GetFOV() / 5, 0.1 )
else
if self.Scope == 1 then
self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
if IsFirstTimePredicted() then
self.Scope = 0
end
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetFOV( 0, 0.1 )
end
end
end

function SWEP:ShootEffects()
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
self.Owner:SetAnimation( PLAYER_ATTACK1 )
self.Owner:MuzzleFlash()
end

function SWEP:Reload()
end

function SWEP:Think()
if self.IdleTimer <= CurTime() then
if self.Idle == 0 then
self.Idle = 1
end
if SERVER and self.Idle == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
end