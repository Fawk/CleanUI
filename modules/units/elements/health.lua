local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitClass = UnitClass

--[[ Lua ]]
local floor = math.floor
local format = string.format
local unpack = unpack
local rand = math.random
local select = select

--[[ Locals ]]
local elementName = "health"
local Health = {}

A.elements.shared[elementName] = Health

local function Gradient(unit, class)
	local r1, g1, b1 = unpack(A.colors.health.low)
	local r2, g2, b2 = unpack(A.colors.health.medium)
	local r3, g3, b3 = unpack(unit and A.colors.class[class or select(2, UnitClass(unit))] or A.colors.backdrop.light)
	return r1, g1, b1, r2, g2, b2, r3, g3, b3
end

function Health:Init(parent)

	local db = parent.db[elementName]

	local health = parent.orderedElements[elementName]
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
	   		if (db.frequentUpdates) then
	   			tagEventFrame:UnregisterEvent("UNIT_HEALTH")
	   			tagEventFrame:RegisterEvent("UNIT_HEALTH_FREQUENT")
	   		else
	   			tagEventFrame:RegisterEvent("UNIT_HEALTH")
	   			tagEventFrame:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	   		end
	   	end

	   	if (db.frequentUpdates) then
   			health:UnregisterEvent("UNIT_HEALTH")
   			health:RegisterEvent("UNIT_HEALTH_FREQUENT")
   		else
   			health:RegisterEvent("UNIT_HEALTH")
   			health:UnregisterEvent("UNIT_HEALTH_FREQUENT")
   		end

   		health:RegisterEvent("UNIT_MAXHEALTH")
	    health:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)
	end

	health:Update(UnitEvent.UPDATE_DB, self.db)
	health:Update("UNIT_HEALTH")

	parent.orderedElements[elementName] = health
end

function Health:Update(...)
	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (not db.enabled) then
		self:Hide()
		return
	else
		self:Show()
	end

	if (T:anyOf(event, "UNIT_HEALTH_FREQUENT", "UNIT_HEALTH", "UNIT_MAXHEALTH", UnitEvent.GROUP_UPDATE)) then
		if (parent.unit ~= arg1) then return end

		parent:Update(UnitEvent.UPDATE_HEALTH)
		self:SetMinMaxValues(0, parent.currentMaxHealth)
	  	self:SetValue(parent.currentHealth)
	  	
	  	if (db.missingBar.enabled) then
	  		Units:UpdateMissingBar(self, "missingHealthBar", parent.currentHealth, parent.currentMaxHealth)
	  	end

	  	if (db.colorBy == "gradient") then
			A:ColorBar(self, parent, parent.currentHealth, parent.currentMaxHealth, Gradient, parent.classOverride)
		end
	elseif (event == UnitEvent.UPDATE_TAGS) then

		if (not T:anyOf(arg2, "UNIT_HEALTH_FREQUENT", "UNIT_HEALTH", "FORCED_TAG_UPDATE")) then
			return
		end

		if (parent.unit ~= arg3) then return end

		if (not parent.currentHealth) then
			parent:Update(UnitEvent.UPDATE_HEALTH)
		end

		local tag = arg1
		tag.replaced = tag.replaced:replace("[hp]", parent.currentHealth)
		tag.replaced = tag.replaced:replace("[maxhp]", parent.currentMaxHealth)
		tag.replaced = tag.replaced:replace("[perhp]", floor(parent.currentHealth / parent.currentMaxHealth * 100 + .5))
		tag.replaced = tag.replaced:replace("[hp:round]", T:short(parent.currentHealth, 1))
		tag.replaced = tag.replaced:replace("[maxhp:round]", T:short(parent.currentMaxHealth, 1))
		tag.replaced = tag.replaced:replace("[hp:deficit]", parent.deficitHealth > 0 and format("-%s", T:short(parent.deficitHealth, 0)) or "")
	elseif (event == UnitEvent.UPDATE_DB) then
		
		self:Update("UNIT_HEALTH_FREQUENT", parent.unit)

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

		Units:SetupMissingBar(self, db.missingBar, "missingHealthBar", parent.currentHealth, parent.currentMaxHealth, Gradient, A.ColorBar)
		A:ColorBar(self, parent, parent.currentHealth, parent.currentMaxHealth, Gradient, parent.classOverride)
	elseif (event == "UpdateColors") then
		Units:SetupMissingBar(self, db.missingBar, "missingHealthBar", parent.currentHealth, parent.currentMaxHealth, Gradient, A.ColorBar)
		A:ColorBar(self, parent, parent.currentHealth, parent.currentMaxHealth, Gradient, parent.classOverride)
	end
end

function Health:Simulate(parent, class)
	
	local oldUnitClass = UnitClass
	UnitClass = function(self, unit)
		return "", class, 0
	end

    local maxHealth = UnitHealthMax("player")
    local randomHealth = rand(0, maxHealth)

    parent.currentHealth = randomHealth
    parent.currentMaxHealth = maxHealth
    parent.deficitHealth = maxHealth - randomHealth
    parent.classOverride = class

    self:Init(parent)

    UnitClass = oldUnitClass
end