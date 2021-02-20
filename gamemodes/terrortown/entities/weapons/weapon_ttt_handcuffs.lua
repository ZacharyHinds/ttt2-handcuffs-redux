if SERVER then
  resource.AddFile("materials/vgui/ttt/icon_handcuffs.png")
  resource.AddFile("materials/vgiu/ttt/icon_handcuffed.png")
end
AddCSLuaFile()

if CLIENT then
  hook.Add("Initialize", "HandcuffsInitStatus", function()
    STATUS:RegisterStatus("handcuffs_handcuffed_status", {
      hud = Material("vgui/ttt/icon_handcuffed.png"),
      type = "bad"
    })
  end)

  SWEP.PrintName = "Handcuffs"
  SWEP.Slot = 7

  SWEP.EquipMenuData = {
    type = "item_weapon",
    desc = "Unarm and handcuff targeted player"
  }

  SWEP.Icon = "vgui/ttt/icon_handcuffs.png"
end

SWEP.Base = "weapon_tttbase"
SWEP.Author = "Wasted"
SWEP.PrintName = "Handcuffs"
SWEP.Purpose = "Handcuffing a player drops their weapons"
SWEP.Instructions = "Left click to handcuff"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 90
SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.limited = true
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

function ResetHandcuffs()
  local plys = player.GetAll()
  for i = 1, #plys do
    local ply = plys[i]
    if (ply:GetNWBool("ttt2_handcuffed")) then
      ply:SetNWBool("ttt2_handcuffed", false) -- Set their network bool "handcuffed" to false
      -- Reset bone back to normal if they were handcuffed
      STATUS:RemoveStatus(ply, "handcuffs_handcuffed_status")
      ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
      ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
      ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
      ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
      ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
      ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
    end
  end
end

if SERVER then
  hook.Add("PlayerCanPickupWeapon", "PreventHandcuffedPickup", function(ply, wep)
    if ply:GetNWBool("ttt2_handcuffed") then
      return false
    end
  end)

  -- hook.Add("TTTEquipmentTabs", "PreventHandcuffedTabs", function(dtabs)
  --   if ply:GetNWBool("ttt2_handcuffed") then
  --     return false
  --   end
  -- end)
  --
  -- hook.Add("TTTBoughtItem", "PreventHandcuffedPurchase", function(is_item, equip)
  --   if ply:GetNWBool("ttt2_handcuffed") then
  --     return false
  --   end
  -- end)

  hook.Add("TTTOrderedEquipment", "PreventHandcuffedPurchaseEquip", function(ply, equip, is_item)
    if ply:GetNWBool("ttt2_handcuffed") then
      return false
    end
  end)

  hook.Add("TTTPrepRound", "ResetHandcuffs", ResetHandcuffs)
  hook.Add("TTTBeginRound", "ResetHandcuffs", ResetHandcuffs)
  hook.Add("TTTEndRound", "ResetHandcuffs", ResetHandcuffs)

  hook.Add("Think", "HandcuffForceUnarmed", function()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]
      if ply:GetNWBool("ttt2_handcuffed") then
        local unarmed = ply:GetWeapon("weapon_ttt_unarmed")
        ply:SetActiveWeapon(unarmed)
      end
    end
  end)

  hook.Add("TTT2PostPlayerDeath", "HandcuffedDeath", function(ply, _, attacker)
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then return end
    if not ply:GetNWBool("ttt2_handcuffed") then return end
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))

    local ragdoll = ply.server_ragdoll or ply:GetRagdollEntity()
    ragdoll:SetNWBool("ttt2_handcuffed", true)
  end)
end

function SWEP:PrimaryAttack()
  if SERVER then
    local owner = self:GetOwner()
    if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() or owner:IsSpec() then return end
    local tgt = owner:GetEyeTrace().Entity
    if not IsValid(tgt) or not tgt:IsPlayer() or not tgt:Alive() or tgt:IsSpec() then return end

    if tgt:GetPos():Distance(owner:GetPos()) > 80 or tgt:GetNWBool("ttt2_handcuffed") then return end

    local weps = tgt:GetWeapons()
    for i = 1, #weps do
      local wep = tgt:GetWeapon(weps[i]:GetClass())
      if (wep.Kind == WEAPON_EQUIP or wep.Kind == WEAPON_EQUIP2 or wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) and wep.AllowDrop then
        tgt:DropWeapon(wep)
      end
    end
    tgt:SetNWBool("ttt2_handcuffed", true)
    STATUS:AddStatus(tgt, "handcuffs_handcuffed_status")
    owner:PrintMessage(HUD_PRINTTALK, "You handcuffed " .. tgt:GetName())
    tgt:PrintMessage(HUD_PRINTTALK, "You were handcuffed by " .. owner:GetName())

    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(20, 8.8, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(15, 0, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 75))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-15, 0, 0))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, -75))
    tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(-20, 16.6, 0))
    owner:StripWeapon(self:GetClass())
    owner:Give("weapon_ttt_jailer_key")
    owner:GetWeapon("weapon_ttt_jailer_key"):SetJailed(tgt)
    owner:SelectWeapon("weapon_ttt_jailer_key")
  end
end

local function HandcuffPly(tgt)
  local weps = tgt:GetWeapons()
  for i = 1, #weps do
    local wep = weps[i]
    if (wep.Kind == WEAPON_EQUIP or wep.Kind == WEAPON_EQUIP2 or wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) and wep.AllowDrop then
      tgt:DropWeapon(wep)
    end
  end
  tgt:SetNWBool("ttt2_handcuffed", true)
  STATUS:AddStatus(tgt, "handcuffs_handcuffed_status")
  tgt:PrintMessage(HUD_PRINTTALK, "You were handcuffed")

  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(20, 8.8, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(15, 0, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 75))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-15, 0, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, -75))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(-20, 16.6, 0))
end

local function UnHandcuffPly(tgt)
  tgt:SetNWBool("ttt2_handcuffed", false)
  STATUS:RemoveStatus(tgt, "handcuffs_handcuffed_status")
  tgt:PrintMessage(HUD_PRINTTALK, "You were unhandcuffed")

  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
  tgt:ManipulateBoneAngles(tgt:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
end

if SERVER then
  util.AddNetworkString("force_handcuff_tgt")

  net.Receive("force_handcuff_tgt", function()
    local tgt = net.ReadEntity()
    if net.ReadBool() then
      HandcuffPly(tgt)
    else
      UnHandcuffPly(tgt)
    end
  end)

end

concommand.Add("ttt2_handcuff", function(ply, cmd, args)
  if CLIENT and GetConVar("sv_cheats"):GetBool() then
    net.Start("force_handcuff_tgt")
    net.WriteEntity(ply)
    net.WriteBool(true)
    net.SendToServer()
  end
end)

concommand.Add("ttt2_unhandcuff", function(ply, cmd, args)
  if CLIENT and GetConVar("sv_cheats"):GetBool() then
    net.Start("force_handcuff_tgt")
    net.WriteEntity(ply)
    net.WriteBool(false)
    net.SendToServer()
  end
end)
