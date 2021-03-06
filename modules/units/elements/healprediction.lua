local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local Units = A.Units
local T = A.Tools

--[[ Blizzard ]]
local CreateFrame = CreateFrame

--[[ Lua ]]
local rand = math.random
local floor = math.floor
local unpack = unpack

--[[ Locals ]]
local elementName = "healPrediction"
local HealPrediction = {}
local events = { "UNIT_HEALTH_FREQUENT", "UNIT_MAXHEALTH", "UNIT_HEAL_PREDICTION", "UNIT_ABSORB_AMOUNT_CHANGED", "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" }

A.elements.shared[elementName] = HealPrediction

local function Update(health, previous, current, amount)

	local orientation, reversed, width, height = health:GetOrientation(), health:GetReverseFill(), health:GetWidth(), health:GetHeight()
	
	if amount == 0 then 
		current:Hide()
		return previous
	end
	
	current:ClearAllPoints()
	
	if orientation == "HORIZONTAL" then
		current:SetWidth(width)
		if reversed then
			current:SetPoint("TOPRIGHT", previous, "TOPLEFT")
			current:SetPoint("BOTTOMRIGHT", previous, "BOTTOMLEFT")
		else
			current:SetPoint("TOPLEFT", previous, "TOPRIGHT")
			current:SetPoint("BOTTOMLEFT", previous, "BOTTOMRIGHT")	
		end
	else
		current:SetHeight(height)
		if reversed then
			current:SetPoint("TOPLEFT", previous, "BOTTOMLEFT")
			current:SetPoint("TOPRIGHT", previous, "BOTTOMRIGHT")
		else
			current:SetPoint("BOTTOMLEFT", previous, "TOPLEFT")
			current:SetPoint("BOTTOMRIGHT", previous, "TOPRIGHT")		
		end
	end
	
	current:SetOrientation(orientation)
	current:SetReverseFill(reversed)
	
	return current:GetStatusBarTexture()
end

local function HealPredictionPostUpdate(self, my, all, absorb, healAbsorb)
	local frame = self:GetParent()
	local health = frame.orderedElements["health"]
	local previous = health:GetStatusBarTexture()

	previous = Update(health, previous, self.myBar, my)
	previous = Update(health, previous, self.otherBar, all)
	previous = Update(health, previous, self.absorbBar, absorb)
	previous = Update(health, previous, self.healAbsorbBar, healAbsorb)
end

function HealPrediction:Init(parent)

	local db = parent.db[elementName]

	local texture = media:Fetch("statusbar", db.texture)

	local healPrediction = parent.orderedElements[elementName]
	if (not healPrediction) then

		healPrediction = CreateFrame("Frame", parent:GetName().."_"..elementName, A.frameParent)
		healPrediction.db = db
		healPrediction:SetParent(parent)
		
		local my = CreateFrame("StatusBar", nil, parent)
		local all = CreateFrame("StatusBar", nil, parent)
		local absorb = CreateFrame("StatusBar", nil, parent)
		local healAbsorb = CreateFrame("StatusBar", nil, parent)

		my:Hide()
		all:Hide()
		absorb:Hide()
		healAbsorb:Hide()
		
		local health = parent.orderedElements["health"]
		if health then
			my:SetParent(health)
			all:SetParent(health)
			absorb:SetParent(health)
			healAbsorb:SetParent(health)

		    local overAbsorb = health:CreateTexture(nil, "OVERLAY")
		    overAbsorb:SetPoint('TOP')
		    overAbsorb:SetPoint('BOTTOM')
		    overAbsorb:SetPoint('LEFT', health, 'RIGHT')
		    overAbsorb:SetWidth(10)

			local overHealAbsorb = health:CreateTexture(nil, "OVERLAY")
		    overHealAbsorb:SetPoint('TOP')
		    overHealAbsorb:SetPoint('BOTTOM')
		    overHealAbsorb:SetPoint('RIGHT', health, 'LEFT')
		    overHealAbsorb:SetWidth(10)

		    overAbsorb:Hide()
		    overHealAbsorb:Hide()

		    healPrediction.overAbsorb = overAbsorb
			healPrediction.overHealAbsorb = overHealAbsorb
	    end

		my:SetFrameLevel(6)
		all:SetFrameLevel(6)
		absorb:SetFrameLevel(6)
		healAbsorb:SetFrameLevel(6)

		healPrediction.myBar = my
		healPrediction.otherBar = all
		healPrediction.absorbBar = absorb
		healPrediction.healAbsorbBar = healAbsorb

	    healPrediction.Update = function(self, event, ...)
	    	HealPrediction:Update(self, event, ...)
		end

	   	for _,event in next, events do
	   		A:RegisterTagEvent(event)
	   	end

	   	Units:RegisterEvents(healPrediction, events, true)
	    healPrediction:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
		end)
	end

	healPrediction:Update(UnitEvent.UPDATE_DB)
	healPrediction:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements[elementName] = healPrediction
end

function HealPrediction:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (not db.enabled) then
		self.myBar:Hide()
		self.otherBar:Hide()
		self.absorbBar:Hide()
		self.healAbsorbBar:Hide()
		return
	end

	if (event == UnitEvent.UPDATE_DB) then
		local texture = media:Fetch("statusbar", db.texture)

		self.maxOverflow = db.overflow
		
		self.myBar:SetStatusBarTexture(texture)
		self.otherBar:SetStatusBarTexture(texture)
		self.absorbBar:SetStatusBarTexture(texture)
		self.healAbsorbBar:SetStatusBarTexture(texture)

		self.myBar:SetStatusBarColor(T:unpackColor(db.colors.my))
		self.otherBar:SetStatusBarColor(T:unpackColor(db.colors.all))
		self.absorbBar:SetStatusBarColor(T:unpackColor(db.colors.absorb))
		self.healAbsorbBar:SetStatusBarColor(T:unpackColor(db.colors.healAbsorb))

		parent.maxOverflow = self.maxOverflow

		parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION)
	else
		if (parent.unit ~= arg1) then return end
		
		parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION)

		if(parent.hasOverAbsorb and self.overAbsorb) then
			self.overAbsorb:Show()
		else
			self.overAbsorb:Hide()
		end

		if(parent.hasOverHealAbsorb and self.overHealAbsorb) then
			self.overHealAbsorb:Show()
		else
			self.overHealAbsorb:Hide()
		end

		local hasValue = false

		if (parent.myIncomingHeal > 0) then
			hasValue = true
			self.myBar:SetMinMaxValues(0, parent.currentMaxHealth)
			self.myBar:SetValue(parent.myIncomingHeal)
			self.myBar:Show()
		else
			self.myBar:Hide()
		end

		if (parent.otherIncomingHeal > 0) then
			hasValue = true
			self.otherBar:SetMinMaxValues(0, parent.currentMaxHealth)
			self.otherBar:SetValue(parent.otherIncomingHeal)
			self.otherBar:Show()
		else
			self.otherBar:Hide()
		end

		if (parent.absorb > 0) then
			hasValue = true
			self.absorbBar:SetMinMaxValues(0, parent.currentMaxHealth)
			self.absorbBar:SetValue(parent.absorb)
			self.absorbBar:Show()
		else
			self.absorbBar:Hide()
		end

		if (parent.healAbsorb > 0) then
			hasValue = true
			self.healAbsorbBar:SetMinMaxValues(0, parent.currentMaxHealth)
			self.healAbsorbBar:SetValue(parent.healAbsorb)
			self.healAbsorbBar:Show()
		else
			self.healAbsorbBar:Hide()
		end

		if (hasValue) then
			HealPredictionPostUpdate(self, parent.myIncomingHeal, parent.otherIncomingHeal, parent.absorb, parent.healAbsorb)
		end
	end
end

function HealPrediction:Simulate(parent)

    parent.myIncomingHeal = rand(0, parent.deficitHealth)
    parent.otherIncomingHeal = rand(0, parent.deficitHealth)
    parent.absorb = rand(0, parent.deficitHealth)
    parent.healAbsorb = rand(0, parent.deficitHealth)

    self:Init(parent)
end