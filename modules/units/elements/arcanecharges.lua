local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local GetSpecialization = GetSpecialization
local SPELL_POWER_ARCANE_CHARGES = Enum.PowerType.ArcaneCharges

--[[ Locals ]]
local elementName = "Arcane Charges"
local ArcaneCharges = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER" }
local MAX_ARCANE_CHARGES = 4

local function notValid(frame)
    if (select(2, UnitClass("player")) ~= "MAGE" or (GetSpecialization() ~= 1)) then
        return true
    end
end

function ArcaneCharges:Init(parent)
    if (select(2, UnitClass("player")) ~= "MAGE") then
        return
    end

    local db = parent.db[elementName]

    local charges = parent.orderedElements:get(elementName)
    if (not charges) then
        charges = CreateFrame("Frame", T:frameName(parentName, elementName), parent)
        charges.buttons = {}
        charges.db = db

        for i = 1, MAX_ARCANE_CHARGES do
            local power = CreateFrame("StatusBar", T:frameName(parentName, elementName..i), charges)
            power.bg = power:CreateTexture(nil, "BORDER")
            power.bg:SetAllPoints()
            charges.buttons[i] = power
        end

        charges.Update = function(self, ...)
            ArcaneCharges:Update(self, ...)
        end

        Units:RegisterEvents(charges, events)
        charges:SetScript("OnEvent", function(self, ...)
            ArcaneCharges:Update(self, ...)
        end)

        if (notValid()) then
            local frame = CreateFrame("Frame")
            frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
            frame:SetScript("OnEvent", function(self, event, ...)
                if (notValid()) then return end
                ArcaneCharges:Init(parent)
                frame:SetScript("OnEvent", nil)
            end)
        end
    end

    self:Update(charges, UnitEvent.UPDATE_DB)
    self:Update(charges, "UNIT_POWER_FREQUENT")

    parent.orderedElements:set(elementName, charges)
end

function ArcaneCharges:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local db = self.db

    if (notValid()) then
        self:Hide()
        return
    else
        self:Show()
    end

    if (event == UnitEvent.UPDATE_DB) then
        
        local size = db["Size"]
        local orientation = db["Orientation"]
        local width = size["Width"]
        local height = size["Height"]
        local x = db["X Spacing"]
        local y = db["Y Spacing"] 

        if (orientation == "HORIZONTAL") then
            width = width + (x * (MAX_ARCANE_CHARGES - 1))
        else
            height = height + (y * (MAX_ARCANE_CHARGES - 1))
        end
        
        self:SetSize(width, height)
        U:CreateBackground(self, db, false)

        local r, g, b = unpack(A.colors.power[SPELL_POWER_ARCANE_CHARGES])
        local texture = media:Fetch("statusbar", db["Texture"])

        if (orientation == "HORIZONTAL") then
            width = math.floor((width - x) / MAX_ARCANE_CHARGES)
        else
            height = math.floor((height - y) / MAX_ARCANE_CHARGES)
        end

        for i = 1, MAX_ARCANE_CHARGES do
            local power = self.buttons[i]
            power:SetOrientation(orientation)
            power:SetReverseFill(db["Reversed"])
            power:SetStatusBarTexture(texture)
            power:SetStatusBarColor(r, g, b)
            power:SetMinMaxValues(0, 1)

            width, height = T:PositionClassPowerIcon(self, power, orientation, width, height, MAX_ARCANE_CHARGES, i, x, y)

            power.bg:SetTexture(texture)
            power.bg:SetVertexColor(r * .33, g * .33, b * .33)

            power:SetSize(width, height)
        end

        if (not db["Attached"]) then
            A:CreateMover(self, db, elementName)
        else
            A:DeleteMover(elementName)
        end

        Units:Attach(self, db)
    else
        local current = UnitPower("player", SPELL_POWER_ARCANE_CHARGES)

        for i = 1, MAX_ARCANE_CHARGES do
            local power = self.buttons[i]
            if (i <= current) then
                power:SetValue(1)
            else
                power:SetValue(0)
            end
        end
    end
end

A["Player Elements"]:set(elementName, ArcaneCharges)