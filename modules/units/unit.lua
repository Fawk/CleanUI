local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitName = UnitName
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitHealth = UnitHealth
local UnitPower = UnitPower
local UnitPowerType = UnitPowerType
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local SecureButton_GetUnit = SecureButton_GetUnit
local SecureButton_GetModifiedUnit = SecureButton_GetModifiedUnit
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local replaceLogic = A:OrderedMap()

for key, color in next, A.colors.text do
    replaceLogic:set("[color:"..key.."]", color)
end

function A:FormatTag(tag)
    local parent = tag:GetParent()

    local name = UnitName(parent.unit) or ""

    replaceLogic:set("[name]", name, true)
    replaceLogic:set("[name:%d+]", name:sub(1, tag.format:match("%d+")), true)

    local classToken = select(2, UnitClass(parent.unit))

    A:AddColorReplaceLogicIfNeeded(tag, UnitIsPlayer(parent.unit) and classToken or "NPC")
    
    tag.replaceLogics:foreach(function(key, replace)
        replaceLogic:set(key, replace, true)
    end)

    local replaced = tag.format
    
    replaceLogic:foreach(function(key, replaceString)
        replaced = replaced:replace(key, replaceString)
    end)
    
    tag.text = replaced
end

-- name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3
local function fetchAuraData(func, tbl, id)
    if (not tbl.own) then tbl.own = {} end
    if (not tbl.others) then tbl.others = {} end

    local auras = { own = {}, others = {} }
    for i = 1, 40 do
        local aura = {func(id, i)}
        local spellID = aura[10]

        if (aura[1]) then
            if (tbl.own[spellID]) then
                tbl.own[spellID] = aura
                auras.own[spellID] = true
            elseif (tbl.others[spellID]) then
                tbl.others[spellID] = aura
                auras.others[spellID] = true
            else
                if (aura[7] == id) then
                    tbl.own[spellID] = aura
                    auras.own[spellID] = true
                else
                    tbl.others[spellID] = aura
                    auras.others[spellID] = true
                end
            end
        end
    end

    for spellID, a in next, tbl.own do
        if (a[6] < GetTime() or not auras.own[spellID]) then
            tbl.own[spellID] = nil
        end
    end

    for spellID, a in next, tbl.others do
        if (a[6] < GetTime() or not auras.others[spellID]) then
            tbl.others[spellID] = nil
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

    Unit:Init(unit)

    RegisterUnitWatch(unit)

    return unit
end

function A:SetUnitMeta(frame)
    frame.super = Unit
    Unit:Init(frame)
end

function Unit:Init(unit)
    unit.tagEventFrame = CreateFrame("Frame")
    unit.ForceTagUpdate = function(self)
        self.tagEventFrame:GetScript("OnEvent")(self.tagEventFrame, "FORCED_TAG_UPDATE")
    end
    unit.tagEventFrame:SetScript("OnEvent", function(self, ...)
        local event = ...
        unit.tags:foreach(function(key, tag)
            unit.orderedElements:foreach(function(k, element)
                element:Update(UnitEvent.UPDATE_TAGS, tag, event)
            end)
            A:FormatTag(tag)
            tag:SetText(tag.text)
        end)
    end)
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
        self.deficitHealth = self.currentMaxHealth - self.currentHealth

        if (self.OnHealth) then
            self:OnHealth(...)
        end
    elseif (event == UnitEvent.UPDATE_POWER) then
        self.previousPower = self.currentPower
        self.previousMaxPower = self.currentMaxPower

        local powerType, powerToken, altR, altG, altB = UnitPowerType(self.unit)
        self.currentPower = UnitPower(self.unit, powerType)
        self.currentMaxPower = UnitPowerMax(self.unit, powerType)
        self.deficitPower = self.currentMaxPower - self.currentPower

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
    end

    if (self.AfterUpdate) then
        self:AfterUpdate(...)
    end
end
