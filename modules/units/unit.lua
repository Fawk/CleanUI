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

local tags = {
    ["hp"] = function(parent)
        if (not parent.currentHealth) then parent:Update(UnitEvent.UPDATE_HEALTH) end
        return parent.currentHealth 
    end,
    ["maxhp"] = function(parent) 
        if (not parent.currentMaxHealth) then parent:Update(UnitEvent.UPDATE_HEALTH) end
        return parent.currentMaxHealth 
    end,
    ["perhp"] = function(parent)      
        if (not parent.currentHealth) then parent:Update(UnitEvent.UPDATE_HEALTH) end
        local perhp = 0
        if (parent.currentHealth ~= 0 and parent.currentMaxHealth ~= 0) then
            perhp = floor(parent.currentHealth / parent.currentMaxHealth * 100 + .5)
        end 
        return perhp
    end,
    ["hp:round"] = function(parent) 
        if (not parent.currentHealth) then parent:Update(UnitEvent.UPDATE_HEALTH) end
        return T:short(parent.currentHealth, 1) 
    end,
    ["maxhp:round"] = function(parent)
        if (not parent.currentMaxHealth) then parent:Update(UnitEvent.UPDATE_HEALTH) end
        return T:short(parent.currentMaxHealth, 1)
    end,
    ["hp:deficit"] = function(parent)
        if (not parent.currentHealth) then parent:Update(UnitEvent.UPDATE_HEALTH) end
        return parent.deficitHealth > 0 and format("-%s", T:short(parent.deficitHealth, 0)) or "" 
    end,
    ["pp"] = function(parent) 
        if (not parent.currentPower) then parent:Update(UnitEvent.UPDATE_POWER) end
        return parent.currentPower
    end,
    ["maxpp"] = function(parent) 
        if (not parent.currentMaxPower) then parent:Update(UnitEvent.UPDATE_POWER) end
        return parent.currentMaxPower 
    end,
    ["perpp"] = function(parent)
        if (not parent.currentPower) then parent:Update(UnitEvent.UPDATE_POWER) end 
        local perpp = 0
        if (parent.currentPower ~= 0 and parent.currentMaxPower ~= 0) then
            perpp = floor(parent.currentPower / parent.currentMaxPower * 100 + .5)
        end
        return perpp
    end,
    ["pp:round"] = function(parent) 
        if (not parent.currentPower) then parent:Update(UnitEvent.UPDATE_POWER) end
        return T:short(parent.currentPower, 1) 
    end,
    ["maxpp:round"] = function(parent)
        if (not parent.currentMaxPower) then parent:Update(UnitEvent.UPDATE_POWER) end
        return T:short(parent.currentMaxPower, 1)
    end,
    ["pp:deficit"] = function(parent) 
        if (not parent.currentPower) then parent:Update(UnitEvent.UPDATE_POWER) end
        return parent.deficitPower > 0 and format("-%s", T:short(parent.deficitPower, 0)) or ""
    end,
    ["name"] = function(parent) return UnitName(parent.unit) end,
    ["name:%d"] = function(parent, key)
        return UnitName(parent.unit):utf8sub(1, tonumber(key:match("%d+")))
    end,
    ["class"] = function(parent) return UnitClass(parent.unit) end,
    ["heal"] = function(parent) 
        if (not parent.myIncomingHeal) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return parent.myIncomingHeal
    end,
    ["heal:round"] = function(parent) 
        if (not parent.myIncomingHeal) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return T:short(parent.myIncomingHeal, 1)
    end,
    ["allheal"] = function(parent) 
        if (not parent.otherIncomingHeal) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return parent.otherIncomingHeal
    end,
    ["allheal:round"] = function(parent)
        if (not parent.otherIncomingHeal) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return T:short(parent.otherIncomingHeal, 1)
    end,
    ["absorb"] = function(parent)
        if (not parent.absorb) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return parent.absorb
    end,
    ["absorb:round"] = function(parent)
        if (not parent.absorb) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return T:short(parent.absorb, 1)
    end,
    ["healabsorb"] = function(parent)
        if (not parent.healAbsorb) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return parent.healAbsorb
    end,
    ["healabsorb:round"] = function(parent)
        if (not parent.healAbsorb) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        return T:short(parent.healAbsorb, 1)
    end,
    ["perabsorb"] = function(parent)  
        if (not parent.absorb) then parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION) end
        if (not parent.currentMaxHealth) then parent:Update(UnitEvent.UPDATE_HEALTH) end
        local per = 0
        if (parent.absorb ~= 0 and parent.currentMaxHealth ~= 0) then
            per = floor(parent.absorb / parent.currentMaxHealth * 100 + .5)
        end
        return per
    end,
    ["level"] = function(parent)
        return UnitLevel(parent.unit)
    end,
}

local function doTag(unit)
    for i = 1, unit.tags:len() do
        if (unit.tags[i]) then
            unit.tags[i].replaced = unit.tags[i].format

            for key, color in next, A.colors.text do
                if (unit.tags[i].replaced:find("%["..key.."%]")) then
                    unit.tags[i].replaced = unit.tags[i].replaced:replace("[color:"..key.."]", color)
                end
            end

            local colorPattern = "[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]"

            local x, y = unit.tags[i].replaced:find("%[color:"..colorPattern.."%]")
            if (x and y) then
                local m = unit.tags[i].replaced:sub(x, y)
                unit.tags[i].replaced = unit.tags[i].replaced:replace(m, "|cFF"..m:match(colorPattern))
            end

            local classToken = UnitIsPlayer(unit.unit) and select(2, UnitClass(unit.unit)) or "NPC"
            local powerToken = unit.powerType or unit.powerToken
            if (not powerToken) then
                unit:Update(UnitEvent.UPDATE_POWER)
                powerToken = unit.powerType or unit.powerToken
            end

            unit.tags[i].replaced = unit.tags[i].replaced:replace("[color:class]", "|cFF"..A:rgbToHex(A.colors.class[classToken]))
            unit.tags[i].replaced = unit.tags[i].replaced:replace("[color:health]", "|cFF"..A:rgbToHex(A.colors.health.standard))
            unit.tags[i].replaced = unit.tags[i].replaced:replace("[color:power]", "|cFF"..A:rgbToHex(A.colors.power[powerToken]))

            local x, y = unit.tags[i].replaced:find("[color:healthgradient]")
            if (x and y) then
                local r1, g1, b1, r2, g2, b2, r3, g3, b3 = A:HealthGradient() 
                local r, g, b = A:ColorGradient(currentHealth or 1, currentMaxHealth or 1, r1, g1, b1, r2, g2, b2, r3, g3, b3)
                unit.tags[i].replaced = unit.tags[i].replaced:replace("[color:healthgradient]", "|cFF"..A:rgbToHex({ r, g, b }))
            end

            for key, func in next, tags do
                if (key:find("name")) then
                    --print(key, unit.tags[i].replaced:find("%["..key.."%]"))
                end

                if (unit.tags[i].replaced:find("%["..key.."%]")) then
                    unit.tags[i].replaced = unit.tags[i].replaced:replace("["..key.."]", func(unit, key))
                end
            end
            
            unit.tags[i]:SetText(unit.tags[i].replaced)
        end
    end
end

--[[
    This needs to be changed, each event needs to update all values instead of each element
    This is because the format gets overwritten when there's an element that can not replace the certain tag
]]
local tagEventFrame = CreateFrame("Frame")
tagEventFrame:RegisterEvent("UNIT_NAME_UPDATE")
tagEventFrame:SetScript("OnEvent", function(self, ...)
    local event = ...
    for _,key in A.Units:iterateKeys() do
        local unit = Units:Get(key)
        if (unit.GetUnits) then
            for _,unit in next, unit:GetUnits() do
                if (UnitExists(unit.unit)) then
                    doTag(unit)
                end
            end
        else
            if (not UnitExists(unit.unit)) then return end
            doTag(unit)
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
