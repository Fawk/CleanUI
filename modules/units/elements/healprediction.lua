local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local CreateFrame = CreateFrame
local T = A.Tools

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
	local health = frame.orderedElements:getChildByKey("key", "Health").element
	local previous = health:GetStatusBarTexture()

	previous = Update(health, previous, self.myBar, my)
	previous = Update(health, previous, self.otherBar, all)
	previous = Update(health, previous, self.absorbBar, absorb)
	previous = Update(health, previous, self.healAbsorbBar, healAbsorb)
end

local elementName = "Heal Prediction"

local HealthPrediction = { name = elementName }
A["Shared Elements"]:set(elementName, HealthPrediction)

function HealthPrediction:Init(parent)

	local parentName = parent.GetDbName and parent:GetDbName() or parent:GetName()
	local db = A["Profile"]["Options"][parentName][elementName]

	local texture = media:Fetch("statusbar", db["Texture"] or "Default2")

	local healPrediction = parent.orderedElements:get(elementName)
	if (not healPrediction) then

		healPrediction = CreateFrame("Frame", parent:GetName().."_"..elementName, A.frameParent)

		healPrediction:SetParent(parent)
		
		local my = CreateFrame("StatusBar", nil, parent)
		local all = CreateFrame("StatusBar", nil, parent)
		local absorb = CreateFrame("StatusBar", nil, parent)
		local healAbsorb = CreateFrame("StatusBar", nil, parent)

		my:Hide()
		all:Hide()
		absorb:Hide()
		healAbsorb:Hide()
		
		local health = parent.orderedElements:get("Health")
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

		my:SetFrameLevel(5)
		all:SetFrameLevel(5)
		absorb:SetFrameLevel(5)
		healAbsorb:SetFrameLevel(5)

		healPrediction.myBar = my
		healPrediction.otherBar = all
		healPrediction.absorbBar = absorb
		healPrediction.healAbsorbBar = healAbsorb

		healPrediction.tags = A:OrderedTable()

	    healPrediction.Update = function(self, event, ...)
	    	HealthPrediction:Update(self, event, ...)
		end

		healPrediction:RegisterEvent("UNIT_HEALTH_FREQUENT")
	    healPrediction:RegisterEvent("UNIT_MAXHEALTH")
	    healPrediction:RegisterEvent("UNIT_HEAL_PREDICTION")
		healPrediction:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
		healPrediction:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
	    healPrediction:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
		end)
	end

	healPrediction:Update(UnitEvent.UPDATE_DB, db)
	healPrediction:Update(UnitEvent.UPDATE_TEXTS)
	healPrediction:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements:set(elementName, healPrediction)
end

function HealthPrediction:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()

	if (event == UnitEvent.UPDATE_DB) then
		local db = arg1
		local texture = media:Fetch("statusbar", db["Texture"] or "Default2")

		self.maxOverflow = db["Max Overflow"]
		self.frequentUpdates = db["Frequent Updates"]
		
		self.myBar:SetStatusBarTexture(texture)
		self.otherBar:SetStatusBarTexture(texture)
		self.absorbBar:SetStatusBarTexture(texture)
		self.healAbsorbBar:SetStatusBarTexture(texture)

		local colors = db["Colors"]
		self.myBar:SetStatusBarColor(unpack(colors["My Heals"]))
		self.otherBar:SetStatusBarColor(unpack(colors["All Heals"]))
		self.absorbBar:SetStatusBarColor(unpack(colors["Absorb"]))
		self.healAbsorbBar:SetStatusBarColor(unpack(colors["Heal Absorb"]))

		parent.maxOverflow = self.maxOverflow

		parent:Update(UnitEvent.UPDATE_HEAL_PREDICTION)
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

		HealPredictionPostUpdate(self, parent.myIncomingHeal, parent.otherIncomingHeal, parent.absorb, parent.healAbsorb)
	end
end