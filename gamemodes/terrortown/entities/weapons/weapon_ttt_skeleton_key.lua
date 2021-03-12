if SERVER then
  resource.AddFile("materials/vgui/ttt/icon_skeletonkey.png")
  AddCSLuaFile()
end

if CLIENT then
  SWEP.PrintName = "Skeleton Key"
  SWEP.Slot = 7

  SWEP.EquipMenuData = {
    type = "item_weapon",
    desc = "Unlock handcuffs"
  }

  SWEP.Icon = "vgui/ttt/icon_skeletonkey.png"
end

SWEP.Base = "weapon_tttbase"
SWEP.Author = "Wasted"
SWEP.PrintName = "Skeleton Key"
SWEP.Purpose = "Free someone from handcuffs"
SWEP.Instructions = "Left click to unlock handcuff"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 90
SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.Uses = 1

SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.9
SWEP.Primary.Recoil = 0
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 0
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.Secondary.Delay = 0.9
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:RemoveJailerKey(ply)
  local jailers = ents.FindByClass("weapon_ttt_jailer_key")
  for i = 1, #jailers do
    local key = jailers[i]
    if key.jailed == ply:SteamID() then key:Remove() end
  end
end

function SWEP:PrimaryAttack()
  if SERVER then
    local owner = self:GetOwner()
    if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() or owner:IsSpec() then return end
    local tgt = owner:GetEyeTrace().Entity
    if not IsValid(tgt) or not tgt:IsPlayer() or not tgt:Alive() or tgt:IsSpec() then return end
    if tgt:GetPos():Distance(owner:GetPos()) > 80 or not tgt:GetNWBool("ttt2_handcuffed") then return end

    tgt:SetNWBool("ttt2_handcuffed", false)
    STATUS:RemoveStatus(tgt, "handcuffs_handcuffed_status")
    owner:PrintMessage(HUD_PRINTTALK, "You unhandcuffed " .. tgt:GetName())
    tgt:PrintMessage(HUD_PRINTTALK, "You were unhandcuffed by" .. tgt:GetName())

    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))

    owner:StripWeapon(self:GetClass())
    self:RemoveJailerKey(tgt)
  end
end
