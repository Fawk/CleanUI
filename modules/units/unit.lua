local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitPower = UnitPower
local UnitPowerType = UnitPowerType
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local SecureButton_GetUnit = SecureButton_GetUnit
local SecureButton_GetModifiedUnit = SecureButton_GetModifiedUnit

-- name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3
local function fetchAuraData(func, tbl, id)
    for i = 1, 40 do
        local aura = {func(id, i)}
        if (aura[1]) then
            if (aura[8] == id) then
                tbl.own[aura[11]] = aura[6] > 0 and aura or nil
            else
                tbl.others[aura[11]] = aura[6] > 0 and aura or nil
            end
        end
    end
end

local UnitFrame = {}

function UnitFrame:Init()

end

function UnitFrame:Update(...)

end

local Unit = {}

function A:CreateUnit(id)
    local unit = oUF:Spawn(id, id)
    unit.super = Unit
    unit.id = id

    return unit
end

function Unit:Init()

end

function Unit:Update(...)
    UnitFrame:Update(...)
    
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...

    if (event == UnitEvent.UPDATE_IDENTIFIER) then

        local previous = self.id
        local realUnit, modUnit = SecureButton_GetUnit(self), SecureButton_GetModifiedUnit(self)
        self.id = realUnit
        self.modId = modUnit
        if (self.OnIdentifier) then
            self:OnIdentifier(previous)
        end
    elseif (event == UnitEvent.UPDATE_HEALTH) then
        self.previousHealth = self.currentHealth
        self.previousMaxHealth = self.currentMaxHealth
        self.currentHealth = UnitHealth(self.id)
        self.currentMaxHealth = UnitHealthMax(self.id)

        if (self.OnHealth) then
            self:OnHealth(...)
        end
    elseif (event == UnitEvent.UPDATE_POWER) then
        self.previousPower = self.currentPower
        self.previousMaxPower = self.currentMaxPower

        local powerType, powerToken, altR, altG, altB = UnitPowerType(self.id)
        self.currentPower = UnitPower(self.id, powerType)
        self.currentMaxPower = UnitPowerMax(self.id, powerType)

        self.powerType = powerType
        self.powerToken = powerToken
        
        if (self.OnPower) then
            self:OnPower(...)
        end
    elseif (event == UnitEvent.UPDATE_BUFFS) then
        if (not self.buffs) then self.buffs = {} end
        fetchAuraData(UnitBuff, self.buffs, self.id)

        if (self.OnBuffs) then
            self:OnBuffs(...)
        end
    elseif (event == UnitEvent.UPDATE_DEBUFFS) then
        if (not self.debuffs) then self.debuffs = {} end
        fetchAuraData(UnitDebuff, self.debuffs, self.id)

        if (self.OnDebuffs) then
            self:OnDebuffs(...)
        end
    elseif (event == UnitEvent.UPDATE_CLICKCAST) then
        if (arg2 and self.id and self:CanChangeAttribute()) then
            for _,binding in next, arg2 do
                local f, t = binding.action:gsub("@unit", "@mouseover")
                self:SetAttribute(binding.type, f)
            end
        end
        if (self.OnClickCast) then
            self:OnClickCast(arg2)
        end
    elseif (event == UnitEvent.UPDATE_HEAL_PREDICTION) then
        
        local myIncomingHeal = UnitGetIncomingHeals(self.id, 'player') or 0
        local allIncomingHeal = UnitGetIncomingHeals(self.id) or 0
        local absorb = UnitGetTotalAbsorbs(self.id) or 0
        local healAbsorb = UnitGetTotalHealAbsorbs(self.id) or 0
        local health, maxHealth = UnitHealth(self.id), UnitHealthMax(self.id)

        local hasOverHealAbsorb = false
        if(health < healAbsorb) then
            hasOverHealAbsorb = true
            healAbsorb = health
        end

        local maxOverflow = 1.2

        if(health - healAbsorb + allIncomingHeal > maxHealth * maxOverflow) then
            allIncomingHeal = maxHealth * maxOverflow - health + healAbsorb
        end

        local otherIncomingHeal = 0
        if(allIncomingHeal < myIncomingHeal) then
            myIncomingHeal = allIncomingHeal
        else
            otherIncomingHeal = allIncomingHeal - myIncomingHeal
        end

        local hasOverAbsorb = false
        if(health - healAbsorb + allIncomingHeal + absorb >= maxHealth or health + absorb >= maxHealth) then
            if(absorb > 0) then
                hasOverAbsorb = true
            end

            if(allIncomingHeal > healAbsorb) then
                absorb = math.max(0, maxHealth - (health - healAbsorb + allIncomingHeal))
            else
                absorb = math.max(0, maxHealth - health)
            end
        end

        if(healAbsorb > allIncomingHeal) then
            healAbsorb = healAbsorb - allIncomingHeal
        else
            healAbsorb = 0
        end

        self.myIncomingHeal = myIncomingHeal
        self.otherIncomingHeal = otherIncomingHeal
        self.absorb = absorb
        self.healAbsorb = healAbsorb
        self.hasOverAbsorb = hasOverAbsorb
        self.hasOverHealAbsorb = hasOverHealAbsorb
    end

    if (self.AfterUpdate) then
        self:AfterUpdate(...)
    end
end

function Unit:GetId()
    return self.id
end

