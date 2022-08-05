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
killicon.AddFont( "weapon_deagle", "CSKillIcons", "f", Color( 255, 80, 0, 255 ) )
end

SWEP.PrintName = "Night Hawk .50c"
SWEP.Category = "Counter-Strike: Source"
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 7
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.UseHands = true
SWEP.HoldType = "pistol"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

SWEP.ShotTimer = CurTime()
SWEP.Reloading = 0
SWEP.ReloadingTimer = CurTime()
SWEP.Recoil = 0
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.WalkSpeed = 200
SWEP.RunSpeed = 400

SWEP.Primary.Sound = Sound( "Weapon_DEagle.Single" )
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 42
SWEP.Primary.MaxAmmo = 35
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Damage = 54
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Spread = 0.004
SWEP.Primary.SpreadMin = 0.004
SWEP.Primary.SpreadMax = 0.055
SWEP.Primary.SpreadKick = 0.013
SWEP.Primary.SpreadMove = 0.0757
SWEP.Primary.SpreadAir = 0.345
SWEP.Primary.SpreadRecoveryTime = 0.38683
SWEP.Primary.SpreadRecoveryTimer = CurTime()
SWEP.Primary.Delay = 0.225
SWEP.Primary.Force = 2

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
self.Idle = 0
self.IdleTimer = CurTime() + 1
end

function SWEP:DrawWeaponSelection( x, y, wide, tall )
draw.SimpleText( "f", "CSSelectIcons", x + wide / 2, y + tall / 4, Color( 255, 220, 0, 255 ), TEXT_ALIGN_CENTER )
end

function SWEP:DrawHUD()
local x = ( ( self.Primary.Spread + 0.01 ) / 0.01 ) * 8
local y = ( ( self.Primary.Spread + 0.01 ) / 0.01 ) * 8 - 6
if CLIENT then
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawLine( ScrW() / 2 - x, ScrH() / 2, ScrW() / 2 - y, ScrH() / 2 )
surface.DrawLine( ScrW() / 2 + x, ScrH() / 2, ScrW() / 2 + y, ScrH() / 2 )
surface.DrawLine( ScrW() / 2, ScrH() / 2 - x, ScrW() / 2, ScrH() / 2 - y )
surface.DrawLine( ScrW() / 2, ScrH() / 2 + x, ScrW() / 2, ScrH() / 2 + y )
surface.SetDrawColor( 100, 100, 100, 255 )
surface.DrawLine( ScrW() / 2 - x, ScrH() / 2 + 1, ScrW() / 2 - y, ScrH() / 2 + 1 )
surface.DrawLine( ScrW() / 2 + x, ScrH() / 2 + 1, ScrW() / 2 + y, ScrH() / 2 + 1 )
surface.DrawLine( ScrW() / 2 + 1, ScrH() / 2 - x, ScrW() / 2 + 1, ScrH() / 2 - y )
surface.DrawLine( ScrW() / 2 + 1, ScrH() / 2 + x, ScrW() / 2 + 1, ScrH() / 2 + y )
end
end

function SWEP:Deploy()
self:SetWeaponHoldType( self.HoldType )
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.ShotTimer = CurTime()
self.Reloading = 0
self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Recoil = 0
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
return true
end

function SWEP:Holster()
self.ShotTimer = CurTime()
self.Reloading = 0
self.ReloadingTimer = CurTime()
self.Recoil = 0
self.Idle = 0
self.IdleTimer = CurTime()
self.Owner:SetWalkSpeed( 200 )
self.Owner:SetRunSpeed( 400 )
return true
end

function SWEP:PrimaryAttack()
if ( self.Weapon:Clip1() <= 0 and self.Weapon:Ammo1() <= 0 ) || ( self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 ) then
if SERVER then
self.Owner:EmitSound( "Default.ClipEmpty_Pistol" )
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
bullet.Distance = 4096
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
self.Primary.Spread = self.Primary.Spread + self.Primary.SpreadKick
end
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
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
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
end

function SWEP:ShootEffects()
if self.Weapon:Clip1() > 1 then
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
self.Idle = 0
end
if self.Weapon:Clip1() <= 1 then
self.Weapon:SendWeaponAnim( ACT_VM_DRYFIRE )
self.Idle = 2
end
self.Owner:SetAnimation( PLAYER_ATTACK1 )
self.Owner:MuzzleFlash()
end

function SWEP:Reload()
if self.Reloading == 0 and self.ReloadingTimer <= CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
self.Owner:SetAnimation( PLAYER_RELOAD )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Reloading = 1
self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
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
self.Primary.Spread = self.Primary.SpreadMin
end
if self.Primary.Spread > self.Primary.SpreadMin then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.Spread
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
if self.Primary.Spread > self.Primary.SpreadMin then
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