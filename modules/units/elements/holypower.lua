local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local GetSpecialization = GetSpecialization
local SPELL_POWER_HOLY_POWER = Enum.PowerType.HolyPower

--[[ Locals ]]
local elementName = "holyPower"
local HolyPower = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER" }
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

    local holypower = parent.orderedElements[elementName]
    if (not holypower) then
        holypower = CreateFrame("Frame", T:frameName(parentName, elementName), parent)
        holypower.buttons = {}
        holypower.db = db
        holypower.noTags = true

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

    parent.orderedElements[elementName] = holypower
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
        
        local width = db.size.matchWidth and parent:GetWidth() or db.size.width
        local height = db.size.matchHeight and parent:GetHeight() or db.size.height
        local x = db.x
        local y = db.y

        if (db.orientation == "HORIZONTAL") then
            width = width + (x * (MAX_HOLY_POWER - 1))
        else
            height = height + (y * (MAX_HOLY_POWER - 1))
        end
        
        self:SetSize(width, height)
        U:CreateBackground(self, db, false)

        local r, g, b = unpack(A.colors.power[SPELL_POWER_HOLY_POWER])
        local texture = media:Fetch("statusbar", db.texture)

        if (db.orientation == "HORIZONTAL") then
            width = math.floor((width - x) / MAX_HOLY_POWER)
        else
            height = math.floor((height - y) / MAX_HOLY_POWER)
        end

        for i = 1, MAX_HOLY_POWER do
            local power = self.buttons[i]
            power:SetOrientation(db.orientation)
            power:SetReverseFill(db.reversed)
            power:SetStatusBarTexture(texture)
            power:SetStatusBarColor(r, g, b)
            power:SetMinMaxValues(0, 1)

            width, height = T:PositionClassPowerIcon(self, power, db.orientation, width, height, MAX_HOLY_POWER, i, x, y)

            power.bg:SetTexture(texture)
            power.bg:SetVertexColor(r * .33, g * .33, b * .33)

            power:SetSize(width, height)
        end

        if (not db["Attached"]) then
            A:CreateMover(self, db, elementName)
        else
            A:DeleteMover(elementName)
            Units:Attach(self, db)
        end
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

A.elements.player[elementName] = HolyPower