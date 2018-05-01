local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local T = A.Tools

local function Update2(health, previous, current, amount)

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

local function HealPredictionPostUpdate2(self, my, all, absorb, healAbsorb)
	local frame = self:GetParent()
	local health = frame.orderedElements:getChildByKey("key", "Health").element
	local previous = health:GetStatusBarTexture()

	previous = Update2(health, previous, self.myBar, my)
	previous = Update2(health, previous, self.otherBar, all)
	previous = Update2(health, previous, self.absorbBar, absorb)
	previous = Update2(health, previous, self.healAbsorbBar, healAbsorb)
end

local function Update(frame, previous, current, amount)

	local orientation, reversed, width, height = frame.Health:GetOrientation(), frame.Health:GetReverseFill(), frame.Health:GetWidth(), frame.Health:GetHeight()
	
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

local function HealPredictionPostUpdate(self, unit, my, all, absorb, healAbsorb)
	local frame = self.parent or self.__owner
	local previous = frame.Health:GetStatusBarTexture()

	previous = Update(frame, previous, self.myBar, my)
	previous = Update(frame, previous, self.otherBar, all)
	previous = Update(frame, previous, self.absorbBar, absorb)
	previous = Update(frame, previous, self.healAbsorbBar, healAbsorb)
end

local elementName = "HealthPrediction"

local _HealthPrediction = { name = elementName }
A["Shared Elements"]:add(_HealthPrediction)

function _HealthPrediction:Init(parent)

	local parentName = parent:GetName()
	local db = A["Profile"]["Options"][parentName][elementName]

	local texture = media:Fetch("statusbar", db["Texture"] or "Default2")

	local healPrediction = parent.orderedElements:getChildByKey("key", elementName)
	if (not healPrediction) then

		healPrediction = CreateFrame("Frame", T:frameName("HealthPrediction"), A.frameParent)

		healPrediction:SetParent(parent)
		
		local my = CreateFrame("StatusBar", nil, parent)
		local all = CreateFrame("StatusBar", nil, parent)
		local absorb = CreateFrame("StatusBar", nil, parent)
		local healAbsorb = CreateFrame("StatusBar", nil, parent)

		my:Hide()
		all:Hide()
		absorb:Hide()
		healAbsorb:Hide()
		
		local health = parent.orderedElements:getChildByKey("key", "Health")
		if health then
			my:SetParent(health.element)
			all:SetParent(health.element)
			absorb:SetParent(health.element)
			healAbsorb:SetParent(health.element)

		    local overAbsorb = health.element:CreateTexture(nil, "OVERLAY")
		    overAbsorb:SetPoint('TOP')
		    overAbsorb:SetPoint('BOTTOM')
		    overAbsorb:SetPoint('LEFT', health.element, 'RIGHT')
		    overAbsorb:SetWidth(10)

			local overHealAbsorb = health.element:CreateTexture(nil, "OVERLAY")
		    overHealAbsorb:SetPoint('TOP')
		    overHealAbsorb:SetPoint('BOTTOM')
		    overHealAbsorb:SetPoint('RIGHT', health.element, 'LEFT')
		    overHealAbsorb:SetWidth(10)

		    overAbsorb:Hide()
		    overHealAbsorb:Hide()

		    healPrediction.overAbsorb = overAbsorb
			healPrediction.overHealAbsorb = overHealAbsorb
	    end

		healPrediction.myBar = my
		healPrediction.otherBar = all
		healPrediction.absorbBar = absorb
		healPrediction.healAbsorbBar = healAbsorb

		healPrediction.tags = A:OrderedTable()

	    healPrediction.Update = function(self, event, ...)
	    	_HealthPrediction:Update(self, event, ...)
		end

		healPrediction:RegisterEvent("UNIT_HEALTH_FREQUENT")
	    healPrediction:RegisterEvent("UNIT_MAXHEALTH")
	    healPrediction:RegisterEvent("UNIT_HEAL_PREDICTION")
		healPrediction:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
		healPrediction:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
	    healPrediction:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
		end)
	else
		healPrediction = healPrediction.element
	end

	healPrediction:Update(UnitEvent.UPDATE_DB, db)
	healPrediction:Update(UnitEvent.UPDATE_TEXTS)
	healPrediction:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements:add({ key = elementName, element = healPrediction })
end

function _HealthPrediction:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()		

	if (event == UnitEvent.UPDATE_DB) then
	
		local db = arg1
		local texture = media:Fetch("statusbar", db["Texture"] or "Default2")

		self.maxOverflow = db["MaxOverflow"]
		self.frequentUpdates = db["FrequentUpdates"]
		
		self.myBar:SetStatusBarTexture(texture)
		self.otherBar:SetStatusBarTexture(texture)
		self.absorbBar:SetStatusBarTexture(texture)
		self.healAbsorbBar:SetStatusBarTexture(texture)
		
		self.myBar:SetStatusBarColor(unpack(A.colors.healPrediction.my))
		self.otherBar:SetStatusBarColor(unpack(A.colors.healPrediction.all))
		self.absorbBar:SetStatusBarColor(unpack(A.colors.healPrediction.absorb))
		self.healAbsorbBar:SetStatusBarColor(unpack(A.colors.healPrediction.healAbsorb))

	elseif (event == UnitEvent.UPDATE_TEXTS) then

	else
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

		self.myBar:SetMinMaxValues(0, parent.currentMaxHealth)
		self.myBar:SetValue(parent.myIncomingHeal)
		self.myBar:Show()

		self.otherBar:SetMinMaxValues(0, parent.currentMaxHealth)
		self.otherBar:SetValue(parent.otherIncomingHeal)
		self.otherBar:Show()

		self.absorbBar:SetMinMaxValues(0, parent.currentMaxHealth)
		self.absorbBar:SetValue(parent.absorb)
		self.absorbBar:Show()

		self.healAbsorbBar:SetMinMaxValues(0, parent.currentMaxHealth)
		self.healAbsorbBar:SetValue(parent.healAbsorb)
		self.healAbsorbBar:Show()

		HealPredictionPostUpdate2(self, parent.myIncomingHeal, parent.otherIncomingHeal, parent.absorb, parent.healAbsorb)
	end
end

function HealthPrediction(frame, db)

	local texture = media:Fetch("statusbar", db["Texture"] or "Default2")

	local healPrediction = frame.HealthPrediction or (function()
		
		local healPrediction, my, all, absorb, healAbsorb = {}, CreateFrame("StatusBar", nil, frame), CreateFrame("StatusBar", nil, frame), CreateFrame("StatusBar", nil, frame), CreateFrame("StatusBar", nil, frame)
		
		my:SetStatusBarTexture(texture)
		my:SetStatusBarColor(unpack(A.colors.healPrediction.my))
		my:Hide()
		
		all:SetStatusBarTexture(texture)
		all:SetStatusBarColor(unpack(A.colors.healPrediction.all))
		all:Hide()
		
		absorb:SetStatusBarTexture(texture)
		absorb:SetStatusBarColor(unpack(A.colors.healPrediction.absorb))
		absorb:Hide()
		
		healAbsorb:SetStatusBarTexture(texture)
		healAbsorb:SetStatusBarColor(unpack(A.colors.healPrediction.healAbsorb))
		healAbsorb:Hide()
		
		if frame.Health then
			my:SetParent(frame.Health)
			all:SetParent(frame.Health)
			absorb:SetParent(frame.Health)
			healAbsorb:SetParent(frame.Health)
		end
		
		healPrediction.myBar = my
		healPrediction.otherBar = all
		healPrediction.absorbBar = absorb
		healPrediction.healAbsorbBar = healAbsorb
		healPrediction.PostUpdate = HealPredictionPostUpdate
		
		return healPrediction

	end)()
	
	healPrediction.maxOverflow = db["MaxOverflow"]
	healPrediction.frequentUpdates = db["FrequentUpdates"]
	
	healPrediction.myBar:SetStatusBarTexture(texture)
	healPrediction.otherBar:SetStatusBarTexture(texture)
	healPrediction.absorbBar:SetStatusBarTexture(texture)
	healPrediction.healAbsorbBar:SetStatusBarTexture(texture)

	frame.HealthPrediction = healPrediction
end

A["Elements"]:add({ name = "HealthPrediction", func = HealthPrediction })