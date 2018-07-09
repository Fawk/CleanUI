local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local GetSpecialization = GetSpecialization
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER

--[[ Locals ]]
local elementName = "Holy Power"
local HolyPower = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER", "UPDATE_VEHICLE_ACTION_BAR" }
local MAX_HOLY_POWER = 5

local function notValid(frame)
    if (select(2, UnitClass("player")) ~= "PALADIN" or (GetSpecialization() ~= 3)) then
        return true
    end
end

function HolyPower:Init(parent)
    if (select(2, UnitClass("player")) ~= "PALADIN") then
        return
    end

    local db = parent.db[elementName]

    local holypower = parent.orderedElements:get(elementName)
    if (not holypower) then
        holypower = CreateFrame("Frame", T:frameName(parentName, elementName), parent)
        holypower.buttons = {}
        holypower.db = db

        for i = 1, MAX_HOLY_POWER do
            local power = CreateFrame("StatusBar", T:frameName(parentName, elementName..i), holypower)
            power.bg = power:CreateTexture(nil, "BORDER")
            power.bg:SetAllPoints()
            holypower.buttons[i] = power
        end

        holypower.Update = function(self, ...)
            HolyPower:Update(self, ...)
        end

        Units:RegisterEvents(holypower, events)
        holypower:SetScript("OnEvent", function(self, ...)
            HolyPower:Update(self, ...)
        end)

        if (notValid()) then
            local frame = CreateFrame("Frame")
            frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
            frame:SetScript("OnEvent", function(self, event, ...)
                if (notValid()) then return end
                HolyPower:Init(parent)
                frame:SetScript("OnEvent", nil)
            end)
        end
    end

    self:Update(holypower, UnitEvent.UPDATE_DB)
    self:Update(holypower, "UNIT_POWER_FREQUENT")

    parent.orderedElements:set(elementName, holypower)
end

function HolyPower:Update(...)
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
            width = width + (x * (MAX_HOLY_POWER - 1))
        else
            height = height + (y * (MAX_HOLY_POWER - 1))
        end
        
        self:SetSize(width, height)
        U:CreateBackground(self, db, false)

        local r, g, b = unpack(A.colors.power[SPELL_POWER_HOLY_POWER])
        local texture = media:Fetch("statusbar", db["Texture"])

        if (orientation == "HORIZONTAL") then
            width = math.floor((width - x) / MAX_HOLY_POWER)
        else
            height = math.floor((height - y) / MAX_HOLY_POWER)
        end

        for i = 1, MAX_HOLY_POWER do
            local power = self.buttons[i]
            power:SetOrientation(orientation)
            power:SetReverseFill(db["Reversed"])
            power:SetStatusBarTexture(texture)
            power:SetStatusBarColor(r, g, b)
            power:SetMinMaxValues(0, 10)

            width, height = T:PositionClassPowerIcon(self, power, orientation, width, height, MAX_HOLY_POWER, i, x, y)

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
        local current = UnitPower("player", SPELL_POWER_HOLY_POWER)

        for i = 1, MAX_HOLY_POWER do
            local power = self.buttons[i]
            if (i <= current) then
                power:SetValue(1)
            else
                power:SetValue(0)
            end
        end
    end
end

A["Player Elements"]:set(elementName, HolyPower)