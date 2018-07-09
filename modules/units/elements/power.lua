local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType

--[[ Locals ]]
local elementName = "Power"
local Power = { name = elementName }
local events = { "UNIT_POWER_FREQUENT", "UNIT_MAXPOWER", "UPDATE_SHAPESHIFT_FORM" }

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

	   	Units:RegisterEvents(power, events, true)
	    power:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)
	end

	power:Update(UnitEvent.UPDATE_DB, db)

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

	if (event == "UNIT_POWER_FREQUENT" or event == "UNIT_MAXPOWER" or event == "UPDATE_SHAPESHIFT_FORM") then
		parent:Update(UnitEvent.UPDATE_POWER)

		if (parent.powerToken or parent.powerType) then
			self:SetMinMaxValues(0, parent.currentMaxPower)
		  	self:SetValue(parent.currentPower)
	 	end
	elseif (event == UnitEvent.UPDATE_TAGS) then
		parent:Update(UnitEvent.UPDATE_POWER)
		local tag = arg1
		tag:AddReplaceLogic("[pp]", parent.currentPower)
		tag:AddReplaceLogic("[maxpp]", parent.currentMaxPower)
		tag:AddReplaceLogic("[perpp]", math.floor(parent.currentPower / parent.currentMaxPower * 100 + .5))
		tag:AddReplaceLogic("[pp:round]", T:short(parent.currentPower, 1))
		tag:AddReplaceLogic("[maxpp:round]", T:short(parent.currentMaxPower, 1))
		tag:AddReplaceLogic("[pp:deficit]", parent.deficitPower > 0 and string.format("-%d", T:short(parent.deficitPower, 0)) or "")
	elseif (event == UnitEvent.UPDATE_DB) then

		self:Update("UNIT_POWER_FREQUENT")
		
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

	Units:SetupMissingBar(self, self.db["Missing Power Bar"], "missingPowerBar", parent.currentPower, parent.currentMaxPower, A.noop, A.ColorBar)
	A:ColorBar(self, parent, parent.currentPower, parent.currentMaxPower, A.noop, parent.classOverride)
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