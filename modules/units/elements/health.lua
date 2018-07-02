local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitClass = UnitClass

local elementName = "Health"

local Health = { name = elementName }
A["Shared Elements"]:add(Health)

local function Gradient(unit, class)
	local r1, g1, b1 = unpack(A.colors.health.low)
	local r2, g2, b2 = unpack(A.colors.health.medium)
	local r3, g3, b3 = unpack(unit and oUF.colors.class[class or select(2, UnitClass(unit))] or A.colors.backdrop.light)
	return r1, g1, b1, r2, g2, b2, r3, g3, b3
end

local function Color(bar, parent, class)

	local unit = parent.unit
	local db = bar.db
	local r, g, b, t, a
	local colorType = db["Color By"]
	local mult = db["Background Multiplier"]
	
	if colorType == "Class" then
		r, g, b = unpack(oUF.colors.class[class or select(2, UnitClass(unit))] or A.colors.backdrop.default)
	elseif colorType == "Health" then
		r, g, b = unpack(oUF.colors.health)
	elseif colorType == "Custom" then
		t = db["Custom Color"]
	elseif colorType == "Gradient" then
		r, g, b = oUF.ColorGradient(parent.currentHealth or UnitHealth(unit), parent.currentMaxHealth or UnitHealthMax(unit), Gradient(unit))
	end
	
	if t then
		r, g, b, a = unpack(t)
	end

	if r then
		bar:SetStatusBarColor(r, g, b, a or 1)
		if (bar.bg) then
			if (mult == -1) then
				bar.bg:Hide()
			else
				bar.bg:SetVertexColor(r * mult, g * mult, b * mult, a or 1)
				bar.bg:Show()
			end
		end
	end
end

local function setupMissingHealthBar(health, db, current, max, class)
	if (not db) then return end

	local bar = health.missingHealthBar
	local parent = health:GetParent()

	if (db["Enabled"]) then
		local tex = health:GetStatusBarTexture()
		local orientation = health:GetOrientation()
		local reversed = health:GetReverseFill()
		bar:SetOrientation(orientation)
		bar:SetReverseFill(reversed)
		bar:SetStatusBarTexture(tex:GetTexture())
		bar.db = db

		if (orientation == "HORIZONTAL") then
			if (reversed) then
				bar:SetPoint("TOPRIGHT", tex, "TOPLEFT")
				bar:SetPoint("BOTTOMRIGHT", tex, "BOTTOMLEFT")
			else
				bar:SetPoint("TOPLEFT", tex, "TOPRIGHT")
				bar:SetPoint("BOTTOMLEFT", tex, "BOTTOMRIGHT")
			end
		else
			if (reversed) then
				bar:SetPoint("TOPRIGHT", tex, "BOTTOMRIGHT")
				bar:SetPoint("TOPLEFT", tex, "BOTTOMLEFT")
			else
				bar:SetPoint("BOTTOMRIGHT", tex, "TOPRIGHT")
				bar:SetPoint("BOTTOMLEFT", tex, "TOPLEFT")
			end
		end
		
		bar:SetSize(health:GetSize())

		-- Calculate value based on missing health
		bar:SetMinMaxValues(0, parent.currentMaxHealth or max)
		bar:SetValue((parent.currentMaxHealth or max) - (parent.currentHealth or current))

		-- Do coloring based on db
		Color(bar, parent, class)

		bar:Show()
	else
		bar:Hide()
	end
end

function Health:Init(parent)

	local parentName = parent.GetDbName and parent:GetDbName() or parent:GetName()
	local db = A["Profile"]["Options"][parentName][elementName]

	local tbl =  parent.orderedElements:getChildByKey("key", elementName)
	local health = tbl and tbl.element or nil
	if (not health) then

		health = CreateFrame("StatusBar", parent:GetName().."_"..elementName, A.frameParent)

		health:SetParent(parent)
		health:SetFrameStrata("LOW")
		health.bg = health:CreateTexture(nil, "BACKGROUND")

		health.missingHealthBar = CreateFrame("StatusBar", nil, health)

		health.tags = A:OrderedTable()
		health.db = db

	    health.Update = function(self, event, ...)
	    	Health:Update(self, event, ...)
	   	end

		health:RegisterEvent("UNIT_HEALTH_FREQUENT")
	    health:RegisterEvent("UNIT_MAXHEALTH")
	    health:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)
	end

	health:Update(UnitEvent.UPDATE_DB, self.db)
	health:Update(UnitEvent.UPDATE_TEXTS)
	health:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements:add({ key = elementName, element = health })
end

function Health:Disable(parent)
	self:Hide()
	self:UnregisterAllEvents()
	parent.orderedElements:remove(self)
end

function Health:Update(...)
	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()

	parent:Update(UnitEvent.UPDATE_HEALTH)

	if (tostring(event):anyMatch("UNIT_HEALTH_FREQUENT", "UNIT_MAXHEALTH")) then
		self:SetMinMaxValues(0, parent.currentMaxHealth)
	  	self:SetValue(parent.currentHealth)
	elseif (event == UnitEvent.UPDATE_TEXTS) then
		self.tags:foreach(function(tag)
			tag:SetText(tag.format
				:replace("[hp]", parent.currentHealth)
			    :replace("[maxhp]", parent.currentMaxHealth)
			    :replace("[perhp]", math.floor(parent.currentHealth / parent.currentMaxHealth * 100 + .5))
			)
		end)
	elseif (event == UnitEvent.UPDATE_DB) then
		
		self:Update("UNIT_HEALTH_FREQUENT")

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
		end

		self.tags:foreach(function(tag)
			tag:Hide()
		end)

		local tags = db["Tags"] or {}
		for _,tag in next, tags do
			self.tags:add(tag)
		end
	end
	
	setupMissingHealthBar(self, self.db["Missing Health Bar"])
	Color(self, parent)
end

function Health:Simulate(parent, class)

	local tbl =  parent.orderedElements:getChildByKey("key", elementName)
	local element = tbl.element

	-- Set the color using the class
	self:Init(parent)
	Color(element, class) -- This needs to be broken out and re-written nicer...

end