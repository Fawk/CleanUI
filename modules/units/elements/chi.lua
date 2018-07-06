local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local SPELL_POWER_CHI = SPELL_POWER_CHI

--[[ Locals ]]
local elementName = "Chi"
local Chi = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER", "UPDATE_VEHICLE_ACTION_BAR", "PLAYER_TALENT_UPDATE" }
local MAX_CHI = 5

function Chi:Init(parent)
    if (select(2, UnitClass("player")) ~= "MONK") then
        return
    end

    local db = parent.db[elementName]

    local chis = parent.orderedElements:get(elementName)
    if (not chis) then
        chis = CreateFrame("Frame", T:frameName(parentName, elementName), parent)
        chis.buttons = {}
        chis.db = db

        for i = 1, MAX_CHI do
            local chi = CreateFrame("StatusBar", T:frameName(parentName, elementName..i), parent)
            chi.bg = chi:CreateTexture(nil, "BORDER")
            chi.bg:SetAllPoints()
            chis.buttons[i] = chi
        end

        chis.Update = function(self, ...)
            Chi:Update(self, ...)
        end

        Units:RegisterEvents(chis, events)
        chis:SetScript("OnEvent", function(self, ...)
            Chi:Update(self, ...)
        end)

        chis.ExtraAttachLogic = function(self)
            local stagger = parent.orderedElements:get("Stagger")
                if (stagger and stagger:IsShown()) then
                    if (stagger.db["Attached"] and stagger.db["Attached Position"] == self.db["Attached Position"] and not stagger.db["Place After Chi"]) then
                        return stagger
                    end
                end
            end
            return self
        end
    end

    self:Update(chis, UnitEvent.UPDATE_DB)
    self:Update(chis, "UNIT_POWER_FREQUENT")

    parent.orderedElements:set(elementName, chis)
end

function Chi:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local db = self.db

    if (event == UnitEvent.UPDATE_DB) then
        
        local size = db["Size"]
        local orientation = db["Orientation"]
        local width = size["Width"]
        local height = size["Height"]
        local x = db["X Spacing"]
        local y = db["Y Spacing"] 

        if (orientation == "HORIZONTAL") then
            width = (width * MAX_CHI) + (x * (MAX_CHI - 1))
        else
            height = (height * MAX_CHI) + (y * (MAX_CHI - 1))
        end
        
        self:SetSize(width, height)
        U:CreateBackground(self, db, false)

        local r, g, b = unpack(A.colors.power[SPELL_POWER_CHI])
        local texture = media:Fetch("statusbar", db["Texture"])

        for i = 1, MAX_CHI do
            local chi = self.buttons[i]
            chi:SetSize(size["Width"], size["Height"])
            chi:SetOrientation(orientation)
            chi:SetReverseFill(db["Reversed"])
            chi:SetStatusBarTexture(texture)
            chi:SetStatusBarColor(r, g, b)
            chi:SetMinMaxValues(0, 1)

            if (orientation == "HORIZONTAL") then
                if (i == 1) then
                    chi:SetPoint("LEFT", self, "LEFT", 0, 0)
                else
                    chi:SetPoint("LEFT", self.buttons[i-1], "RIGHT", x, 0)
                end
            else
                if (i == 1) then
                    chi:SetPoint("TOP", self, "TOP", 0, 0)
                else
                    chi:SetPoint("TOP", self.buttons[i-1], "BOTTOM", 0, -y)
                end
            end

            chi.bg:SetTexture(texture)
            chi.bg:SetVertexColor(r * .33, g * .33, b * .33)
        end

        if (not db["Attached"]) then
            A:CreateMover(self, db, elementName)
        else
            A:DeleteMover(elementName)
        end

        Units:Attach(self, db)
    else
        local current = UnitPower("player", SPELL_POWER_CHI)

        for i = 1, MAX_CHI do
            local chi = self.buttons[i]
            if (i <= current) then
                chi:SetValue(1)
            else
                chi:SetValue(0)
            end
        end
    end
end

A["Player Elements"]:set(elementName, Chi)