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

A["Shared Elements"]:set(elementName, HealPrediction)

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
	local health = frame.orderedElements:get("health")
	local previous = health:GetStatusBarTexture()

	previous = Update(health, previous, self.myBar, my)
	previous = Update(health, previous, self.otherBar, all)
	previous = Update(health, previous, self.absorbBar, absorb)
	previous = Update(health, previous, self.healAbsorbBar, healAbsorb)
end

function HealPrediction:Init(parent)

	local db = parent.db[elementName]

	local texture = media:Fetch("statusbar", db.texture)

	local healPrediction = parent.orderedElements:get(elementName)
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
		
		local health = parent.orderedElements:get("health")
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

		my:SetFrameLevel(5)
		all:SetFrameLevel(5)
		absorb:SetFrameLevel(5)
		healAbsorb:SetFrameLevel(5)

		healPrediction.myBar = my
		healPrediction.otherBar = all
		healPrediction.absorbBar = absorb
		healPrediction.healAbsorbBar = healAbsorb

	    healPrediction.Update = function(self, event, ...)
	    	HealPrediction:Update(self, event, ...)
		end

	   	local tagEventFrame = parent.tagEventFrame
	   	if (tagEventFrame) then
	   		Units:RegisterEvents(tagEventFrame, events)
	   	end

	   	Units:RegisterEvents(healPrediction, events, true)
	    healPrediction:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
		end)
	end

	healPrediction:Update(UnitEvent.UPDATE_DB)
	healPrediction:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements:set(elementName, healPrediction)
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

	parent:Update(UnitEvent.UPDATE_IDENTIFIER)

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
	elseif (event == UnitEvent.UPDATE_TAGS) then

		if (not T:anyOf(arg2, "UNIT_HEALTH_FREQUENT", "UNIT_HEALTH", "UNIT_HEAL_PREDICTION", "UNIT_ABSORB_AMOUNT_CHANGED", "UNIT_HEAL_ABSORB_AMOUNT_CHANGED", "FORCED_TAG_UPDATE")) then
			return
		end

		local tag = arg1
		tag:AddReplaceLogic("[heal]", parent.myIncomingHeal)
		tag:AddReplaceLogic("[heal:round]", T:short(parent.myIncomingHeal, 2))
		tag:AddReplaceLogic("[allheal]", parent.otherIncomingHeal)
		tag:AddReplaceLogic("[allheal:round]", T:short(parent.otherIncomingHeal, 2))
		tag:AddReplaceLogic("[absorb]", parent.absorb)
		tag:AddReplaceLogic("[absorb:round]", T:short(parent.absorb, 2))
		tag:AddReplaceLogic("[healabsorb]", parent.healAbsorb)
		tag:AddReplaceLogic("[healabsorb:round]", T:short(parent.healAbsorb, 2))
		tag:AddReplaceLogic("[perabsorb]", floor(parent.absorb / parent.currentMaxHealth * 100 + .5))
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

function HealPrediction:Simulate(parent)

    parent.myIncomingHeal = rand(0, parent.deficitHealth)
    parent.otherIncomingHeal = rand(0, parent.deficitHealth)
    parent.absorb = rand(0, parent.deficitHealth)
    parent.healAbsorb = rand(0, parent.deficitHealth)

    self:Init(parent)
end