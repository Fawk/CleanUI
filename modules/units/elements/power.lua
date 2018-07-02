local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType

local elementName = "Power"

local NewPower = { name = elementName }
A["Shared Elements"]:add(NewPower)

local function Color(bar, parent)
	local db = bar.db
	local r, g, b, t
	local mult = db["Background Multiplier"]
	local colorType = db["Color By"]
	if colorType == "Class" then
		r, g, b = unpack(oUF.colors.class[select(2, UnitClass(parent.unit))] or A.colors.backdrop.default)
	elseif colorType == "Power" then
		t = A.colors.power[parent.powerToken]
		if not t then
			t = oUF.colors.power[parent.powerToken]
		end
	elseif colorType == "Custom" then
		t = db["Custom Color"]
	end
	if t then
		r, g, b = unpack(t)
	end

	if r then
		bar:SetStatusBarColor(r, g, b)
		bar.bg:SetVertexColor(r * mult, g * mult, b * mult)
	end
end

function NewPower:Init(parent)

	local parentName = parent.GetDbName and parent:GetDbName() or parent:GetName()
	local db = A["Profile"]["Options"][parentName][elementName]

	local power = parent.orderedElements:getChildByKey("key", elementName)
	if (not power) then

		power = CreateFrame("StatusBar", T:frameName(parentName, elementName), A.frameParent)

		power:SetParent(parent)
		power:SetFrameStrata("LOW")
		power.bg = power:CreateTexture(nil, "BACKGROUND")
		power.db = db

		power.tags = A:OrderedTable()

	    power.Update = function(self, event, ...)
	    	NewPower:Update(self, event, ...)
	   	end

		power:RegisterEvent("UNIT_POWER_FREQUENT")
	    power:RegisterEvent("UNIT_MAXPOWER")
	    power:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)
	end

	power:Update(UnitEvent.UPDATE_DB, db)
	power:Update(UnitEvent.UPDATE_TEXTS)
	power:Update("UNIT_POWER_FREQUENT")

	parent.orderedElements:add({ key = elementName, element = power })
end

function NewPower:Disable(parent)
	self:Hide()
	self:UnregisterAllEvents()
	parent.orderedElements:remove(self)
end

function NewPower:Update(...)
	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()

	if (event == "UNIT_POWER_FREQUENT" or event == "UNIT_MAXPOWER") then
		parent:Update(UnitEvent.UPDATE_POWER)
		self:SetMinMaxValues(0, parent.currentMaxPower)
	  	self:SetValue(parent.currentPower)
	elseif (event == UnitEvent.UPDATE_TEXTS) then
		parent:Update(UnitEvent.UPDATE_POWER)
		self.tags:foreach(function(tag)
			tag:SetText(tag.format
				:replace("[pp]", parent.currentPower)
			    :replace("[maxpp]", parent.currentMaxPower)
			    :replace("[perpp]", math.floor(parent.currentPower / parent.currentMaxPower * 100 + .5))
			)
		end)
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

		self.tags:foreach(function(tag)
			tag:Hide()
		end)

		local tags = db["Tags"] or {}
		for _,tag in next, tags do
			self.tags:add(tag)
		end
	end

	Color(self, parent)
end

local function Power(frame, db)

	local power = frame.Power or (function()

		local power = CreateFrame("StatusBar", frame:GetName().."_Power", frame)

		power:SetFrameStrata("LOW")
		power.frequentUpdates = true
		power.bg = power:CreateTexture(nil, "BACKGROUND")
		power.PostUpdate = function(self, unit, min, max)
			local r, g, b, t
			local mult = db["Background Multiplier"]
			local colorType = db["Color By"]
			if colorType == "Class" then
				power.colorClass = true
			elseif colorType == "Power" then
				local powerType = select(2, UnitPowerType(unit))
				t = A.colors.power[powerType]
				if not t then
					t = oUF.colors.power[powerType]
				end
			elseif colorType == "Custom" then
				t = db["Custom Color"]
			end
			if t then
				r, g, b = unpack(t)
			end

			if r then
				self:SetStatusBarColor(r, g, b)
				self.bg:SetVertexColor(r * mult, g * mult, b * mult)
			end
		end

		local powerType = UnitPowerType(frame.unit)
		local min, max = UnitPower(frame.unit, powerType), UnitPowerMax(frame.unit, powerType)
		power:PostUpdate(frame.unit, min, max)

		return power

	end)()

	Units:Position(power, db["Position"])

	local texture = media:Fetch("statusbar", db["Texture"])
	local size = db["Size"]

	power:SetOrientation(db["Orientation"])
	power:SetReverseFill(db["Reversed"])
	power:SetStatusBarTexture(texture)
	power:SetWidth(size["Match width"] and frame:GetWidth() or size["Width"])
	power:SetHeight(size["Match height"] and frame:GetHeight() or size["Height"])
	power.bg:ClearAllPoints()
	power.bg:SetAllPoints()
	power.bg:SetTexture(texture)

	if frame.PostPower then
		frame:PostPower(power)
	end

	frame.Power = power
end

A["Elements"]:add({ name = "Power", func = Power })