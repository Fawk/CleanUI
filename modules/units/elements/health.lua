local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitClass = UnitClass

--[[ Locals ]]
local elementName = "Health"
local Health = { name = elementName }
local events = { "UNIT_HEALTH_FREQUENT", "UNIT_MAXHEALTH" }

A["Shared Elements"]:set(elementName, Health)

local function Gradient(unit, class)
	local r1, g1, b1 = unpack(A.colors.health.low)
	local r2, g2, b2 = unpack(A.colors.health.medium)
	local r3, g3, b3 = unpack(unit and A.colors.class[class or select(2, UnitClass(unit))] or A.colors.backdrop.light)
	return r1, g1, b1, r2, g2, b2, r3, g3, b3
end

function Health:Init(parent)

	local db = parent.db[elementName]

	local health = parent.orderedElements:get(elementName)
	if (not health) then

		health = CreateFrame("StatusBar", parent:GetName().."_"..elementName, A.frameParent)

		health:SetParent(parent)
		health:SetFrameStrata("LOW")
		health.bg = health:CreateTexture(nil, "BACKGROUND")

		health.missingHealthBar = CreateFrame("StatusBar", nil, health)

		health.db = db

	    health.Update = function(self, event, ...)
	    	Health:Update(self, event, ...)
	   	end

	   	local tagEventFrame = parent.tagEventFrame
	   	if (tagEventFrame) then
	   		Units:RegisterEvents(tagEventFrame, events)
	   	end

	   	Units:RegisterEvents(health, events, true)
	    health:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)
	end

	health:Update(UnitEvent.UPDATE_DB, self.db)
	health:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements:set(elementName, health)
end

function Health:Disable(parent)
	self:Hide()
	self:UnregisterAllEvents()
	parent.orderedElements:remove(self)
end

function Health:Update(...)
	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()

	parent:Update(UnitEvent.UPDATE_HEALTH)

	if (tostring(event):anyMatch("UNIT_HEALTH_FREQUENT", "UNIT_MAXHEALTH")) then
		self:SetMinMaxValues(0, parent.currentMaxHealth)
	  	self:SetValue(parent.currentHealth)
	elseif (event == UnitEvent.UPDATE_TAGS) then
		local tag = arg1
		tag.text = tag.format
			:replace("[hp]", parent.currentHealth)
		    :replace("[maxhp]", parent.currentMaxHealth)
		    :replace("[perhp]", math.floor(parent.currentHealth / parent.currentMaxHealth * 100 + .5))
		    :replace("[hp:round]", T:short(parent.currentHealth), 2)
			:replace("[maxhp:round]", T:short(parent.currentMaxHealth), 2)
			:replace("[hp:deficit]", parent.deficitHealth > 0 and string.format("-%d", T:short(parent.deficitHealth, 0)) or "")
	elseif (event == UnitEvent.UPDATE_DB) then
		
		self:Update("UNIT_HEALTH_FREQUENT")

		local db = self.db or arg1
		Units:Position(self, db["Position"])

		local texture = media:Fetch("statusbar", db["Texture"])
		local size = db["Size"]

		self:SetOrientation(db["Orientation"])
		self:SetReverseFill(db["Reversed"])
		self:SetStatusBarTexture(texture)
		self:SetWidth(size["Match width"] and parent:GetWidth() or size["Width"])
		self:SetHeight(size["Match height"] and parent:GetHeight() or size["Height"])
		
		self.bg:ClearAllPoints()
		self.bg:SetAllPoints()
		self.bg:SetTexture(texture)

		if (db["Background Multiplier"] == -1) then
			self.bg:Hide()
		else
			self.bg:Show()
		end
	end

	Units:SetupMissingBar(self, self.db["Missing Health Bar"], "missingHealthBar", parent.currentHealth, parent.currentMaxHealth, Gradient, A.ColorBar)
	A:ColorBar(self, parent, parent.currentHealth, parent.currentMaxHealth, Gradient)
end

function Health:Simulate(parent, class)
	local element = parent.orderedElements:get(elementName)

	-- Set the color using the class
	self:Init(parent)

end