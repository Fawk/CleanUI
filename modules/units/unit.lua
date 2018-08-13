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

local max = math.max

local tagEventFrame = CreateFrame("Frame")
tagEventFrame:RegisterEvent("UNIT_NAME_UPDATE")
tagEventFrame:SetScript("OnEvent", function(self, ...)
    local event = ...
    for _,key in A.Units:iterateKeys() do
        local unit = Units:Get(key)
        if (unit.UpdateUnits) then
            unit:UpdateUnits(UnitEvent.UPDATE_TAGS)
        else
            for i = 1, unit.tags:len() do
                if (unit.tags[i]) then
                    unit.tags[i].replaced = unit.tags[i].format
                    for x = 1, unit.orderedElements:len() do
                        if (not unit.orderedElements[x].noTags) then
                            unit.orderedElements[x]:Update(UnitEvent.UPDATE_TAGS, unit.tags[i], event, unit.unit)
                        end
                    end
                    A:FormatTag(unit.tags[i])
                    unit.tags[i]:SetText(unit.tags[i].replaced)
                end
            end
        end
    end
end)

function A:RegisterTagEvent(event)
    if (not tagEventFrame:IsEventRegistered(event)) then
        tagEventFrame:RegisterEvent(event)
    end
end

function A:UnregisterTagEvent(event)
    if (tagEventFrame:IsEventRegistered(event)) then
        tagEventFrame:UnregisterEvent(event)
    end
end

function A:FormatTag(tag)
    local parent = tag:GetParent()
    if (not UnitExists(parent.unit)) then
        return
    end

    local name = UnitName(parent.unit) or ""

    tag.replaced = tag.replaced:replace("[name]", name)
    tag.replaced = tag.replaced:replace("[name:%d+]", name:utf8sub(1, tonumber(tag.replaced:match("%d+"))))

    local className, classToken = UnitClass(parent.unit)
    tag.replaced = tag.replaced:replace("[class]", className)

    local token = parent.powerToken or parent.powerType
    if (not token) then
        parent:Update(UnitEvent.UPDATE_POWER)
        token = parent.powerToken or parent.powerType
    end

    for key, color in next, A.colors.text do
        tag.replaced = tag.replaced:replace("[color:"..key.."]", color)
    end

    A:AddColorReplaceLogicIfNeeded(tag, UnitIsPlayer(parent.unit) and classToken or "NPC", token, parent.currentHealth, parent.currentMaxHealth)
end

local function fetchAuraData(func, id, filter)
    local tbl = {}
    for i = 1, 40 do
        local name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = func(id, i)
        if (name) then
            local aura = {}
            aura.name = name
            aura.index = i
            aura.icon = icon
            aura.count = count
            aura.dispelType = dispelType
            aura.duration = duration
            aura.expires = expires
            aura.caster = caster
            aura.isStealable = isStealable
            aura.nameplateShowPersonal = nameplateShowPersonal
            aura.spellID = spellID
            aura.canApplyAura = canApplyAura
            aura.isBossDebuff = isBossDebuff
            aura.nameplateShowAll = nameplateShowAll
            aura.timeMod = timeMod
            aura.filter = filter

            tbl[i] = aura
        end
    end
    return tbl
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
    Unit:Update(unit, UnitEvent.UPDATE_IDENTIFIER)

    RegisterUnitWatch(unit)

    return unit
end

function A:SetUnitMeta(frame)
    frame.super = Unit
    Unit:Init(frame)
end

function Unit:Init(unit)
    unit.ForceTagUpdate = function(self)
        tagEventFrame:GetScript("OnEvent")(tagEventFrame, "FORCED_TAG_UPDATE")
    end
end

function Unit:Update(...)
    UnitFrame:Update(...)
    
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...

    if (event == UnitEvent.UPDATE_IDENTIFIER) then

        --print("UPDATE_IDENTIFIER", GetTime())

        local previous = self.unit
        local realUnit, modUnit = SecureButton_GetUnit(self), SecureButton_GetModifiedUnit(self)
        self.unit = realUnit
        self.modUnit = modUnit
        if (self.OnIdentifier) then
            self:OnIdentifier(previous)
        end
    elseif (event == UnitEvent.UPDATE_HEALTH) then

        --print("UPDATE_HEALTH", GetTime())

        self.previousHealth = self.currentHealth
        self.previousMaxHealth = self.currentMaxHealth
        self.currentHealth = UnitHealth(self.unit)
        self.currentMaxHealth = UnitHealthMax(self.unit)
        self.deficitHealth = self.currentMaxHealth - self.currentHealth

        if (self.OnHealth) then
            self:OnHealth(...)
        end
    elseif (event == UnitEvent.UPDATE_POWER) then

        --print("UPDATE_POWER", GetTime())

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

        --print("UPDATE_BUFFS", GetTime(), self.unit)

        self.buffs = fetchAuraData(UnitBuff, self.unit, "HELPFUL")

        if (self.OnBuffs) then
            self:OnBuffs(...)
        end
    elseif (event == UnitEvent.UPDATE_DEBUFFS) then

        --print("UPDATE_DEBUFF", GetTime(), self.unit)

        self.debuffs = fetchAuraData(UnitDebuff, self.unit, "HARMFUL")

        if (self.OnDebuffs) then
            self:OnDebuffs(...)
        end
    elseif (event == UnitEvent.UPDATE_HEAL_PREDICTION) then
        
        --print("UPDATE_HEAL_PREDICTION", GetTime())

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
                absorb = max(0, maxHealth - (health - healAbsorb + allIncomingHeal))
            else
                absorb = max(0, maxHealth - health)
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
