local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local GetSpecialization = GetSpecialization
local SPELL_POWER_CHI = SPELL_POWER_CHI

--[[ Locals ]]
local elementName = "Chi"
local Chi = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER", "UPDATE_VEHICLE_ACTION_BAR", "PLAYER_TALENT_UPDATE" }
local MAX_CHI = 6

local function notValid(frame)
	if (select(2, UnitClass("player")) ~= "MONK" or (GetSpecialization() ~= 3)) then
		return true
	end
end

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
            local chi = CreateFrame("StatusBar", T:frameName(parentName, elementName..i), chis)
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

        if (notValid()) then
        	local frame = CreateFrame("Frame")
	   		frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	   		frame:SetScript("OnEvent", function(self, event, ...)
	   			if (notValid()) then return end
		    	Chi:Init(parent)
		    	frame:SetScript("OnEvent", nil)
			end)
	   	end
    end

    self:Update(chis, UnitEvent.UPDATE_DB)
    self:Update(chis, "UNIT_POWER_FREQUENT")

    parent.orderedElements:set(elementName, chis)
end

function Chi:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local db = self.db
    
    if (notValid()) then
		self:Hide()
		return
	else
		self:Show()
	end

    local realMax = UnitPowerMax("player", SPELL_POWER_CHI)

    if (event == UnitEvent.UPDATE_DB) then
        
        local size = db["Size"]
        local orientation = db["Orientation"]
        local width = size["Width"]
        local height = size["Height"]
        local x = db["X Spacing"]
        local y = db["Y Spacing"] 

        if (orientation == "HORIZONTAL") then
            width = width + (x * (realMax - 1))
        else
            height = height + (y * (realMax - 1))
        end
        
        self:SetSize(width, height)
        U:CreateBackground(self, db, false)

        local r, g, b = unpack(A.colors.power[SPELL_POWER_CHI])
        local texture = media:Fetch("statusbar", db["Texture"])

		if (orientation == "HORIZONTAL") then
			width = math.floor((width - x) / realMax)
		else
	        height = math.floor((height - y) / realMax)
		end

        for i = 1, MAX_CHI do
            local chi = self.buttons[i]
            chi:SetOrientation(orientation)
            chi:SetReverseFill(db["Reversed"])
            chi:SetStatusBarTexture(texture)
            chi:SetStatusBarColor(r, g, b)
            chi:SetMinMaxValues(0, 1)

			width, height = T:PositionClassPowerIcon(self, chi, orientation, width, height, realMax, i, x, y)

            chi.bg:SetTexture(texture)
            chi.bg:SetVertexColor(r * .33, g * .33, b * .33)

            chi:SetSize(width, height)

            if (i > realMax) then
                chi:Hide()
            else
                chi:Show()
            end
        end

        if (not db["Attached"]) then
            A:CreateMover(self, db, elementName)
        else
            A:DeleteMover(elementName)
        end

        Units:Attach(self, db)
    else
        local current = UnitPower("player", SPELL_POWER_CHI)

        if (realMax ~= self.oldMax) then
            self:Update(UnitEvent.UPDATE_DB)
        end

        for i = 1, MAX_CHI do
            local chi = self.buttons[i]
            if (i <= current) then
                chi:SetValue(1)
            else
                chi:SetValue(0)
            end
        end

        self.oldMax = realMax
    end
end

A["Player Elements"]:set(elementName, Chi)