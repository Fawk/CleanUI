local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType

--[[ Lua ]]
local floor = math.floor

--[[ Locals ]]
local elementName = "power"
local Power = { name = elementName }
local events = { "UNIT_POWER_UPDATE", "UNIT_MAXPOWER", "UPDATE_SHAPESHIFT_FORM" }

A.elements.shared[elementName] = Power

function Power:Init(parent)

	local db = parent.db[elementName]

	local power = parent.orderedElements[elementName]
	if (not power) then

		power = CreateFrame("StatusBar", parent:GetName().."_"..elementName, A.frameParent)

		power:SetParent(parent)
		power:SetFrameStrata("LOW")
		power.bg = power:CreateTexture(nil, "BACKGROUND")
		power.missingPowerBar = CreateFrame("StatusBar", nil, power)
		power.db = db

	    power.Update = function(self, event, ...)
	    	Power:Update(self, event, ...)
	   	end

	   	for _,event in next, events do
	   		A:RegisterTagEvent(event)
	   	end

	   	Units:RegisterEvents(power, events)
	    power:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)
	end

	power:Update(UnitEvent.UPDATE_DB)

	parent.orderedElements[elementName] = power
end

function Power:Disable(parent)
	self:Hide()
	self:UnregisterAllEvents()
	parent.orderedElements:remove(self)
end

function Power:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (not db.enabled) then
		self:Hide()
		return
	else
		self:Show()
	end

	if (T:anyOf(event, "UNIT_POWER_UPDATE", "UNIT_POWER", "UNIT_MAXPOWER", "UPDATE_SHAPESHIFT_FORM", UnitEvent.UPDATE_GROUP)) then

		if (parent.unit ~= arg1) then return end

		parent:Update(UnitEvent.UPDATE_POWER)

		if (parent.powerToken or parent.powerType) then
			self:SetMinMaxValues(0, parent.currentMaxPower or 1)
		  	self:SetValue(parent.currentPower or 1)

		  	if (parent.currentPower == 0 and parent.currentMaxPower == 0) then
		  		self:SetMinMaxValues(0, 1)
		  		self:SetValue(1)
		  	end

		  	if (db.missingBar.enabled) then
		  		Units:UpdateMissingBar(self, "missingPowerBar", parent.currentPower, parent.currentMaxPower)
		  	end

			A:ColorBar(self, parent, parent.currentPower, parent.currentMaxPower, A.noop, parent.classOverride)
	 	end
	elseif (event == UnitEvent.UPDATE_DB) then

		self:Update("UNIT_POWER_UPDATE", parent.unit)

		Units:Position(self, db.position)

		local texture = media:Fetch("statusbar", db.texture)

		self:SetOrientation(db.orientation)
		self:SetReverseFill(db.reversed)
		self:SetStatusBarTexture(texture)
		self:SetWidth(db.size.matchWidth and parent:GetWidth() or db.size.width)
		self:SetHeight(db.size.matchHeight and parent:GetHeight() or db.size.height)
		
		self.bg:ClearAllPoints()
		self.bg:SetAllPoints()
		self.bg:SetTexture(texture)

		if (db.mult == -1) then
			self.bg:Hide()
		else
			self.bg:Show()
		end

		Units:SetupMissingBar(self, self.db.missingBar, "missingPowerBar", parent.currentPower, parent.currentMaxPower, A.noop, A.ColorBar)
		A:ColorBar(self, parent, parent.currentPower, parent.currentMaxPower, A.noop, parent.classOverride)
	elseif (event == "UpdateColors") then
		parent:Update(UnitEvent.UPDATE_POWER)

		Units:SetupMissingBar(self, self.db.missingBar, "missingPowerBar", parent.currentPower, parent.currentMaxPower, A.noop, A.ColorBar)
		A:ColorBar(self, parent, parent.currentPower, parent.currentMaxPower, A.noop, parent.classOverride)
	end
end

local powerType = {
    ["WARRIOR"] = "RAGE",
    ["DEATHKNIGHT"] = "RUNIC_POWER",
    ["DRUID"] = "MANA",
    ["MAGE"] = "MANA",
    ["WARLOCK"] = "MANA",
    ["PRIEST"] = "MANA",
    ["MONK"] = "ENERGY",
    ["ROGUE"] = "ENERGY",
    ["DEMONHUNTER"] = "FURY",
    ["HUNTER"] = "FOCUS",
    ["PALADIN"] = "MANA",
    ["SHAMAN"] = "MANA",
}

function Power:Simulate(parent, class)

	local oldUnitClass = UnitClass
	UnitClass = function(self, unit)
		return "", class, 0
	end

    local maxPower = UnitPowerMax("player")
    local randomPower = math.random(0, maxPower)

    parent.powerType = powerType[class]
    parent.currentPower = randomPower
    parent.currentMaxPower = maxPower
    parent.deficitPower = maxPower - randomPower
    parent.classOverride = class

    self:Init(parent)

    UnitClass = oldUnitClass
end