local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local SPELL_POWER_COMBO_POINTS = SPELL_POWER_COMBO_POINTS

--[[ Locals ]]
local elementName = "Combo Points"
local ComboPoints = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER", "UPDATE_VEHICLE_ACTION_BAR", "PLAYER_TALENT_UPDATE" }
local MAX_COMBO_POINTS = 6

function ComboPoints:Init(parent)
    if (select(2, UnitClass("player")) ~= "ROGUE") then
        return
    end

    local db = parent.db[elementName]

    local points = parent.orderedElements:get(elementName)
    if (not points) then
        points = CreateFrame("Frame", T:frameName(parentName, elementName), parent)
        points.buttons = {}
        points.db = db

        for i = 1, MAX_COMBO_POINTS do
            local point = CreateFrame("StatusBar", T:frameName(parentName, "Combo Point"..i), parent)
            point.bg = point:CreateTexture(nil, "BORDER")
            point.bg:SetAllPoints()
            points.buttons[i] = point
        end

        points.Update = function(self, ...)
            ComboPoints:Update(self, ...)
        end

        Units:RegisterEvents(points, events)
        points:SetScript("OnEvent", function(self, ...)
            ComboPoints:Update(self, ...)
        end)
    end

    self:Update(points, UnitEvent.UPDATE_DB)
    self:Update(points, "UNIT_POWER_FREQUENT")

    parent.orderedElements:set(elementName, points)
end

function ComboPoints:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local db = self.db
    local realMax = UnitPowerMax("player", SPELL_POWER_COMBO_POINTS)

    if (event == UnitEvent.UPDATE_DB) then
        
        local size = db["Size"]
        local orientation = db["Orientation"]
        local width = size["Width"]
        local height = size["Height"]
        local x = db["X Spacing"]
        local y = db["Y Spacing"] 

        if (orientation == "HORIZONTAL") then
            width = (width * realMax) + (x * (realMax - 1))
        else
            height = (height * realMax) + (y * (realMax - 1))
        end
        
        self:SetSize(width, height)
        U:CreateBackground(self, db, false)

        local r, g, b = unpack(A.colors.power[SPELL_POWER_COMBO_POINTS])
        local texture = media:Fetch("statusbar", db["Texture"])

        for i = 1, MAX_COMBO_POINTS do
            local point = self.buttons[i]
            point:SetOrientation(orientation)
            point:SetReverseFill(db["Reversed"])
            point:SetStatusBarTexture(texture)
            point:SetStatusBarColor(r, g, b)
            point:SetMinMaxValues(0, 1)

            if (orientation == "HORIZONTAL") then
                if (i == 1) then
                    point:SetPoint("LEFT", self, "LEFT", 0, 0)
                else
                    point:SetPoint("LEFT", self.buttons[i-1], "RIGHT", x, 0)
                end
                width = width / realMax
            else
                if (i == 1) then
                    point:SetPoint("TOP", self, "TOP", 0, 0)
                else
                    point:SetPoint("TOP", self.buttons[i-1], "BOTTOM", 0, -y)
                end
                height = height / realMax
            end

            point.bg:SetTexture(texture)
            point.bg:SetVertexColor(r * .33, g * .33, b * .33)

            point:SetSize(width, height)

            if (i > realMax) then
                point:Hide()
            else
                point:Show()
            end
        end

        if (not db["Attached"]) then
            A:CreateMover(self, db, elementName)
        else
            A:DeleteMover(elementName)
        end

        Units:Attach(self, db)
    else
        local current = UnitPower("player", SPELL_POWER_COMBO_POINTS)

        if (realMax ~= self.oldMax) then
            self:Update(UnitEvent.UPDATE_DB)
        end

        for i = 1, MAX_COMBO_POINTS do
            local point = self.buttons[i]
            if (i <= current) then
                point:SetValue(1)
            else
                point:SetValue(0)
            end
        end

        self.oldMax = realMax
    end
end

A["Player Elements"]:set(elementName, ComboPoints)