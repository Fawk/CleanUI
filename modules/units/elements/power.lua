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

local tags = {
	["pp"] = [[function(parent)
		return parent.currentPower
	end]],
	["maxpp"] = [[function(parent)
		return parent.currentMaxPower
	end]],
	["perpp"] = [[function(parent)
		local perpp = 0
		if (parent.currentPower ~= 0 and parent.currentMaxPower ~= 0) then
			perpp = floor(parent.currentPower / parent.currentMaxPower * 100 + .5)
		end
		return perpp
	end]],
	["pp:round"] = [[function(parent)
		return T:short(parent.currentPower, 1)
	end]],
	["maxpp:round"] = [[function(parent)
		return T:short(parent.currentMaxPower, 1)
	end]],
	["pp:deficit"] = [[function(parent)
		return parent.deficitPower > 0 and string.format("-%s", T:short(parent.deficitPower, 0)) or ""
	end]]
}

A["Shared Elements"]:set(elementName, Power)

function Power:Init(parent)

	local db = parent.db[elementName]

	local power = parent.orderedElements:get(elementName)
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

	   	local tagEventFrame = parent.tagEventFrame
	   	if (tagEventFrame) then
	   		Units:RegisterEvents(tagEventFrame, events)
	   	end

	   	Units:RegisterEvents(power, events)
	    power:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)
	end

	power:Update(UnitEvent.UPDATE_DB)

	parent.orderedElements:set(elementName, power)
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
	 	end
	elseif (event == UnitEvent.UPDATE_TAGS) then

		if (not T:anyOf(arg2, "UNIT_POWER_UPDATE", "UNIT_POWER", "UNIT_MAXPOWER", "UPDATE_SHAPESHIFT_FORM", "FORCED_TAG_UPDATE")) then
			return
		end

		if (parent.unit ~= arg3) then return end

		local tag = arg1

		parent:Update(UnitEvent.UPDATE_POWER)

		for key, func in next, tags do
			local k = "%["..key.."%]"
			local func, err = loadstring("return " .. func)
			if(func) then
				func = func()
				tag.replaced = replaced:replace(k, func(parent))
			end
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