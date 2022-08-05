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
killicon.AddFont( "weapon_awp", "CSKillIcons", "r", Color( 255, 80, 0, 255 ) )
end

SWEP.PrintName = "Magnum Sniper Rifle"
SWEP.Category = "Counter-Strike: Source"
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 30
SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.UseHands = true
SWEP.HoldType = "ar2"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

SWEP.Scope = 0
SWEP.ShotTimer = CurTime()
SWEP.Reloading = 0
SWEP.ReloadingTimer = CurTime()
SWEP.Recoil = 0
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.WalkSpeed = 168
SWEP.RunSpeed = 336

SWEP.Primary.Sound = Sound( "Weapon_AWP.Single" )
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 40
SWEP.Primary.MaxAmmo = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Damage = 115
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Spread = 0.0808
SWEP.Primary.SpreadMin = 0.0808
SWEP.Primary.SpreadMax = 0.14
SWEP.Primary.SpreadKick = 0.0808
SWEP.Primary.SpreadMove = 0.273
SWEP.Primary.SpreadAir = 0.546
SWEP.Primary.SpreadMinAlt = 0.0002
SWEP.Primary.SpreadKickAlt = 0.002
SWEP.Primary.SpreadRecoveryTime = 0.34539
SWEP.Primary.SpreadRecoveryTimer = CurTime()
SWEP.Primary.Delay = 1.5
SWEP.Primary.Force = 2

SWEP.Secondary.Sound = Sound( "Default.Zoom" )
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
draw.SimpleText( "r", "CSSelectIcons", x + wide / 2, y + tall / 4, Color( 255, 220, 0, 255 ), TEXT_ALIGN_CENTER )
end

function SWEP:DrawHUD()
if CLIENT then
surface.SetDrawColor( 255, 255, 255, self.Weapon:GetNWInt( "ScopeAlpha", 0 ) )
surface.SetTexture( surface.GetTextureID( "overlays/scope_lens" ) )
surface.DrawTexturedRect( ( ScrW() - ScrH() ) / 2, 0, ScrH(), ScrH() )
surface.SetTexture( surface.GetTextureID( "sprites/scope_arc" ) )
surface.DrawTexturedRectRotated( ScrW() / 2 - ScrH() / 4, ScrH() / 4 * 3, ScrH() / 2, ScrH() / 2, -90 )
surface.SetTexture( surface.GetTextureID( "sprites/scope_arc" ) )
surface.DrawTexturedRect( ScrW() / 2, ScrH() / 2, ScrH() / 2, ScrH() / 2 )
surface.SetTexture( surface.GetTextureID( "sprites/scope_arc" ) )
surface.DrawTexturedRectRotated( ScrW() / 2 - ScrH() / 4, ScrH() / 4, ScrH() / 2, ScrH() / 2, 180 )
surface.SetTexture( surface.GetTextureID( "sprites/scope_arc" ) )
surface.DrawTexturedRectRotated( ScrW() / 2 + ScrH() / 4, ScrH() / 4, ScrH() / 2, ScrH() / 2, 90 )
surface.SetDrawColor( 0, 0, 0, self.Weapon:GetNWInt( "ScopeAlpha", 0 ) )
surface.DrawRect( 0, 0, ( ScrW() - ScrH() ) / 2 + 1, ScrH() )
surface.DrawRect( ( ScrW() + ScrH() ) / 2 - 1, 0, ( ScrW() - ScrH() ) / 2 + 1, ScrH() )
surface.DrawLine( 0, ScrH() / 2, ScrW(), ScrH() / 2 )
surface.DrawLine( ScrW() / 2, 0, ScrW() / 2, ScrH() )
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
self.ShotTimer = CurTime()
self.Reloading = 0
self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Recoil = 0
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
return true
end

function SWEP:Holster()
self.Scope = 0
self.ShotTimer = CurTime()
self.Reloading = 0
self.ReloadingTimer = CurTime()
self.Recoil = 0
self.Idle = 0
self.IdleTimer = CurTime()
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetFOV( 0, 0 )
self.Owner:SetWalkSpeed( 200 )
self.Owner:SetRunSpeed( 400 )
return true
end

function SWEP:PrimaryAttack()
if ( self.Weapon:Clip1() <= 0 and self.Weapon:Ammo1() <= 0 ) || ( self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 ) then
if SERVER then
self.Owner:EmitSound( "Default.ClipEmpty_Rifle" )
end
self:SetNextPrimaryFire( CurTime() + 0.15 )
end
if self.Weapon:Clip1() <= 0 then
self:Reload()
end
if self.Weapon:Clip1() <= 0 || ( self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 ) then return end
local bullet = {}
bullet.Num = self.Primary.NumberofShots
bullet.Src = self.Owner:GetShootPos()
bullet.Dir = self.Owner:GetAimVector()
bullet.Spread = Vector( self.Primary.Spread, self.Primary.Spread, 0 )
bullet.Tracer = 0
bullet.Distance = 8192
bullet.Force = self.Primary.Force
bullet.Damage = self.Primary.Damage
bullet.AmmoType = self.Primary.Ammo
self.Owner:FireBullets( bullet )
self:EmitSound( self.Primary.Sound )
self:ShootEffects()
self:TakePrimaryAmmo( self.Primary.TakeAmmo )
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
if self.Primary.Spread < self.Primary.SpreadMax then
if self.Scope == 0 then
self.Primary.Spread = self.Primary.Spread + self.Primary.SpreadKick
end
if !( self.Scope == 0 ) then
self.Primary.Spread = self.Primary.Spread + self.Primary.SpreadKickAlt
end
end
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
self.Scope = 0
self.ShotTimer = CurTime() + self.Primary.Delay
self.ReloadingTimer = CurTime() + self.Primary.Delay
if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
if self.Recoil > 4 and self.Recoil < 8 then
self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( self.Recoil - 8, 0, 0 ) )
self.Recoil = 8
end
if self.Recoil <= 4 then
self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -4, 0, 0 ) )
self.Recoil = self.Recoil + 4
end
end
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetFOV( 0, 0.1 )
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
end

function SWEP:SecondaryAttack()
self:EmitSound( self.Secondary.Sound )
if self.Scope == 0 then
self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
if IsFirstTimePredicted() then
self.Scope = 1
end
self.Weapon:SetNWInt( "ScopeAlpha", 255 )
self.Weapon:SetNWInt( "MouseSensitivity", 0.4 )
self.Owner:SetFOV( self.Owner:GetFOV() / 2.5, 0.1 )
self.Owner:SetWalkSpeed( 120 )
self.Owner:SetRunSpeed( 240 )
else
if self.Scope == 1 then
self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
if IsFirstTimePredicted() then
self.Scope = 2
end
self.Weapon:SetNWInt( "ScopeAlpha", 255 )
self.Weapon:SetNWInt( "MouseSensitivity", 0.16 )
self.Owner:SetFOV( self.Owner:GetFOV() / 2.5, 0.1 )
self.Owner:SetWalkSpeed( 120 )
self.Owner:SetRunSpeed( 240 )
else
if self.Scope == 2 then
self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
if IsFirstTimePredicted() then
self.Scope = 0
end
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetFOV( 0, 0.1 )
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
end
end
end
end

function SWEP:ShootEffects()
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
self.Owner:SetAnimation( PLAYER_ATTACK1 )
self.Owner:MuzzleFlash()
end

function SWEP:Reload()
if self.Reloading == 0 and self.ReloadingTimer <= CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
self.Owner:SetAnimation( PLAYER_RELOAD )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Scope = 0
self.Reloading = 1
self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:SetNWInt( "ScopeAlpha", 0 )
self.Weapon:SetNWInt( "MouseSensitivity", 1 )
self.Owner:SetFOV( 0, 0 )
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
end
end

function SWEP:Think()
if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
if self.Recoil < 0 then
self.Recoil = 0
end
if self.Recoil > 0 then
self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( 0.25, 0, 0 ) )
self.Recoil = self.Recoil - 0.25
end
end
if self.ShotTimer > CurTime() then
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
end
if self.Owner:IsOnGround() then
if self.Owner:GetVelocity():Length() <= 100 then
if self.Primary.SpreadRecoveryTimer <= CurTime() then
if self.Scope == 0 then
self.Primary.Spread = self.Primary.SpreadMin
end
if !( self.Scope == 0 ) then
self.Primary.Spread = self.Primary.SpreadMinAlt
end
end
if self.Scope == 0 and self.Primary.Spread > self.Primary.SpreadMin then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.Spread
end
if !( self.Scope == 0 ) and self.Primary.Spread > self.Primary.SpreadMinAlt then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * ( self.Primary.SpreadMinAlt + self.Primary.Spread )
end
end
if self.Owner:GetVelocity():Length() <= 100 and self.Primary.Spread > self.Primary.SpreadMax then
self.Primary.Spread = self.Primary.SpreadMax
end
if self.Owner:GetVelocity():Length() > 100 then
self.Primary.Spread = self.Primary.SpreadMove
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
if self.Primary.Spread > self.Primary.SpreadMin then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.SpreadMove
end
end
end
if !self.Owner:IsOnGround() then
self.Primary.Spread = self.Primary.SpreadAir
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
if self.Scope == 0 and self.Primary.Spread > self.Primary.SpreadMin then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.SpreadAir
end
if !( self.Scope == 0 ) and self.Primary.Spread > self.Primary.SpreadMinAlt then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.SpreadAir
end
end
if self.Reloading == 1 and self.ReloadingTimer <= CurTime() then
if self.Weapon:Ammo1() > ( self.Primary.ClipSize - self.Weapon:Clip1() ) then
self.Owner:SetAmmo( self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1(), self.Primary.Ammo )
self.Weapon:SetClip1( self.Primary.ClipSize )
end
if ( self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1() ) + self.Weapon:Clip1() < self.Primary.ClipSize then
self.Weapon:SetClip1( self.Weapon:Clip1() + self.Weapon:Ammo1() )
self.Owner:SetAmmo( 0, self.Primary.Ammo )
end
self.Reloading = 0
end
if self.IdleTimer <= CurTime() then
if self.Idle == 0 then
self.Idle = 1
end
if SERVER and self.Idle == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
if self.Weapon:Ammo1() > self.Primary.MaxAmmo then
self.Owner:SetAmmo( self.Primary.MaxAmmo, self.Primary.Ammo )
end
end