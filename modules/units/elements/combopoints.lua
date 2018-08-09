local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local GetShapeshiftForm = GetShapeshiftForm
local SPELL_POWER_COMBO_POINTS = Enum.PowerType.ComboPoints

--[[ Locals ]]
local elementName = "comboPoints"
local ComboPoints = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER", "PLAYER_TALENT_UPDATE", "UPDATE_SHAPESHIFT_FORM" }
local MAX_COMBO_POINTS = 10

local function notValid()
    return select(2, UnitClass("player")) == "DRUID" and GetShapeshiftForm() ~= 2
end

function ComboPoints:Init(parent)
    local class = select(2, UnitClass("player"))
    if (class ~= "ROGUE" and class ~= "DRUID") then
        return
    end

    local db = parent.db[elementName]

    local points = parent.orderedElements:get(elementName)
    if (not points) then
        points = CreateFrame("Frame", parent:GetName().."_"..elementName, parent)
        points.buttons = {}
        points.db = db
        points.noTags = true

        for i = 1, MAX_COMBO_POINTS do
            local point = CreateFrame("StatusBar", parent:GetName().."_Combo Point"..i, points)
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

        if (notValid()) then
            local frame = CreateFrame("Frame")
            frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
            frame:SetScript("OnEvent", function(self, ...)
                if (notValid()) then return end
                ComboPoints:Init(parent)
                frame:SetScript("OnEvent", nil)
            end)
        end
    end

    self:Update(points, UnitEvent.UPDATE_DB)
    self:Update(points, "UNIT_POWER_FREQUENT")

    parent.orderedElements:set(elementName, points)
end

function ComboPoints:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local db = self.db
    
    if (notValid()) then
        self:Hide()
        return
    else
        self:Show()
    end

    local realMax = UnitPowerMax("player", SPELL_POWER_COMBO_POINTS)

    if (event == UnitEvent.UPDATE_DB) then
        
        local width = db.size.matchWidth and parent:GetWidth() or db.size.width
        local height = db.size.matchHeight and parent:GetHeight() or db.size.height
        local x = db.x
        local y = db.y

        if (db.orientation == "HORIZONTAL") then
            width = width + (x * (realMax - 1))
        else
            height = height + (y * (realMax - 1))
        end
        
        self:SetSize(width, height)
        U:CreateBackground(self, db, false)

        local r, g, b = unpack(A.colors.power[SPELL_POWER_COMBO_POINTS])
        local texture = media:Fetch("statusbar", db.texture)

        if (db.orientation == "HORIZONTAL") then
            width = math.floor((width - x) / realMax)
        else
            height = math.floor((height - y) / realMax)
        end

        for i = 1, MAX_COMBO_POINTS do
            local point = self.buttons[i]
            point:SetOrientation(orientation)
            point:SetReverseFill(db["Reversed"])
            point:SetStatusBarTexture(texture)
            point:SetStatusBarColor(r, g, b)
            point:SetMinMaxValues(0, 1)

            width, height = T:PositionClassPowerIcon(self, point, db.orientation, width, height, realMax, i, x, y)

            point.bg:SetTexture(texture)
            point.bg:SetVertexColor(r * .33, g * .33, b * .33)

            point:SetSize(width, height)

            if (i > realMax) then
                point:Hide()
            else
                point:Show()
            end
        end

        if (not db.attached) then
            A:CreateMover(self, db, elementName)
        else
            A:DeleteMover(elementName)
            Units:Attach(self, db)
        end
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