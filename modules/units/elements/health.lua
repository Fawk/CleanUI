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

	   	if (db.frequentUpdates) then
   			health:UnregisterEvent("UNIT_HEALTH")
   			health:RegisterEvent("UNIT_HEALTH_FREQUENT")
   		else
   			health:UnregisterEvent("UNIT_HEALTH_FREQUENT")
   			health:RegisterEvent("UNIT_HEALTH")
   		end

		A:UnregisterTagEvent("UNIT_HEALTH")
   		A:RegisterTagEvent("UNIT_MAXHEALTH")
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

		A:ColorBar(self, parent, parent.currentHealth, parent.currentMaxHealth, A.HealthGradient, parent.classOverride)
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

		Units:SetupMissingBar(self, db.missingBar, "missingHealthBar", parent.currentHealth, parent.currentMaxHealth, A.HealthGradient, A.ColorBar)
		A:ColorBar(self, parent, parent.currentHealth, parent.currentMaxHealth, A.HealthGradient, parent.classOverride)
	elseif (event == "UpdateColors") then
		parent:Update(UnitEvent.UPDATE_HEALTH)

		Units:SetupMissingBar(self, db.missingBar, "missingHealthBar", parent.currentHealth, parent.currentMaxHealth, A.HealthGradient, A.ColorBar)
		A:ColorBar(self, parent, parent.currentHealth, parent.currentMaxHealth, A.HealthGradient, parent.classOverride)
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