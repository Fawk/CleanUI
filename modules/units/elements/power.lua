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
local events = { "UNIT_POWER_FREQUENT", "UNIT_MAXPOWER" }

A["Shared Elements"]:set(elementName, Power)

function Power:Init(parent)

	local db = parent.db[elementName]

	local power = parent.orderedElements:get(elementName)
	if (not power) then

		power = CreateFrame("StatusBar", T:frameName(parentName, elementName), A.frameParent)

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
	power:Update("UNIT_POWER_FREQUENT")

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

	if (event == "UNIT_POWER_FREQUENT" or event == "UNIT_MAXPOWER") then
		parent:Update(UnitEvent.UPDATE_POWER)
		self:SetMinMaxValues(0, parent.currentMaxPower)
	  	self:SetValue(parent.currentPower)
	elseif (event == UnitEvent.UPDATE_TAGS) then
		parent:Update(UnitEvent.UPDATE_POWER)
		local tag = arg1
		tag.text = tag.format
			:replace("[pp]", parent.currentPower)
		    :replace("[maxpp]", parent.currentMaxPower)
		    :replace("[perpp]", math.floor(parent.currentPower / parent.currentMaxPower * 100 + .5))
		    :replace("[pp:round]", T:round(parent.currentPower))
		    :replace("[maxpp:round]", T:round(parent.currentMaxPower))
		    :replace("[pp:deficit]", parent.deficitPower > 0 and string.format("-%d", T:short(parent.deficitPower, 0)) or "")
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

		self:SetStatusBarColor(.5, 1, .5, 1)
		self.bg:SetVertexColor(.5 * .3, .5 * .3, .5 * .3, 1)

		if (db["Background Multiplier"] == -1) then
			self.bg:Hide()
		else
			self.bg:Show()
		end
	end

	Units:SetupMissingBar(self, self.db["Missing Power Bar"], "missingPowerBar", parent.currentPower, parent.currentMaxPower, A.noop, A.ColorBar)
	A:ColorBar(self, parent, parent.currentPower, parent.currentMaxPower, A.noop)
end