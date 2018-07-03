local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
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
    Units:DisableBlizzard(id:lower())

    local unit = CreateFrame("Button", T:frameName(id), A.frameParent, "SecureUnitButtonTemplate")
    unit:SetAttribute("unit", id:lower())
    unit.super = Unit

    RegisterUnitWatch(unit)

    return unit
end

function A:SetUnitMeta(frame)
    frame.super = Unit
end

function Unit:Init()

end

function Unit:Update(...)
    UnitFrame:Update(...)
    
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...

    if (event == UnitEvent.UPDATE_IDENTIFIER) then
        local previous = self.unit
        local realUnit, modUnit = SecureButton_GetUnit(self), SecureButton_GetModifiedUnit(self)
        self.unit = realUnit
        self.modUnit = modUnit
        if (self.OnIdentifier) then
            self:OnIdentifier(previous)
        end
    elseif (event == UnitEvent.UPDATE_HEALTH) then
        self.previousHealth = self.currentHealth
        self.previousMaxHealth = self.currentMaxHealth
        self.currentHealth = UnitHealth(self.unit)
        self.currentMaxHealth = UnitHealthMax(self.unit)

        if (self.OnHealth) then
            self:OnHealth(...)
        end
    elseif (event == UnitEvent.UPDATE_POWER) then
        self.previousPower = self.currentPower
        self.previousMaxPower = self.currentMaxPower

        local powerType, powerToken, altR, altG, altB = UnitPowerType(self.unit)
        self.currentPower = UnitPower(self.unit, powerType)
        self.currentMaxPower = UnitPowerMax(self.unit, powerType)

        self.powerType = powerType
        self.powerToken = powerToken
        
        if (self.OnPower) then
            self:OnPower(...)
        end
    elseif (event == UnitEvent.UPDATE_BUFFS) then
        if (not self.buffs) then self.buffs = {} end
        fetchAuraData(UnitBuff, self.buffs, self.unit)

        if (self.OnBuffs) then
            self:OnBuffs(...)
        end
    elseif (event == UnitEvent.UPDATE_DEBUFFS) then
        if (not self.debuffs) then self.debuffs = {} end
        fetchAuraData(UnitDebuff, self.debuffs, self.unit)

        if (self.OnDebuffs) then
            self:OnDebuffs(...)
        end
    elseif (event == UnitEvent.UPDATE_HEAL_PREDICTION) then
        
        local myIncomingHeal = UnitGetIncomingHeals(self.unit, 'player') or 0
        local allIncomingHeal = UnitGetIncomingHeals(self.unit) or 0
        local absorb = UnitGetTotalAbsorbs(self.unit) or 0
        local healAbsorb = UnitGetTotalHealAbsorbs(self.unit) or 0
        local health, maxHealth = UnitHealth(self.unit), UnitHealthMax(self.unit)

        local hasOverHealAbsorb = false
        if(health < healAbsorb) then
            hasOverHealAbsorb = true
            healAbsorb = health
        end

        local maxOverflow = self.maxOverflow or 1.2

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
    elseif (event == UnitEvent.UPDATE_CASTBAR) then
        if (arg2 ~= self.unit) then return end

        local name, _, text, texture, startTime, endTime, _, castID, notInterruptible, spellID
        if (arg1 == 'UNIT_SPELLCAST_START') then
            name, _, text, texture, startTime, endTime, _, castID, notInterruptible, spellID = UnitCastingInfo(self.unit)
        elseif (arg1 == 'UNIT_SPELLCAST_INTERRUPTIBLE') then
            notInterruptible = false
        elseif (arg1 == 'UNIT_SPELLCAST_NOT_INTERRUPTIBLE') then
            notInterruptible = true
        elseif (arg1 == 'UNIT_SPELLCAST_DELAYED') then
            name, _, _, _, startTime, _, _, castID = UnitCastingInfo(self.unit)
        elseif (arg1 == 'UNIT_SPELLCAST_CHANNEL_START') then
            name, _, _, texture, startTime, endTime, _, notInterruptible, spellID = UnitChannelInfo(self.unit)
        elseif (arg1 == 'UNIT_SPELLCAST_CHANNEL_UPDATE') then
            name, _, _, texture, startTime, endTime, _, notInterruptible, spellID = UnitChannelInfo(self.unit)
        end

        self.castBarSpell = name
        self.castBarSpellId = spellID
        self.castBarTexture = texture
        self.castBarStart = startTime
        self.castBarEnd = endTime
        self.castBarCastId = castID
        self.castBarInterruptable = not notInterruptible
    end

    if (self.AfterUpdate) then
        self:AfterUpdate(...)
    end
end
