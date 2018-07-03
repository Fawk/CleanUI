local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local buildText = A.TextBuilder

local CreateFrame = CreateFrame
local UnitClass = UnitClass

local elementName = "Castbar"

local Castbar = { name = elementName }
A["Shared Elements"]:set(elementName, Castbar)

local opposite = {
	["LEFT"] = "RIGHT",
	["RIGHT"] = "LEFT"
}

local function CheckEnabled(e, db)
	if not db["Enabled"] then
		e:Hide()
	else
		e:Show()
	end
end

local function Color(bar, parent)
	local unit = parent.unit
	local db = bar.db
	local r, g, b, t, a
	local colorType = db["Color By"]
	local mult = db["Background Multiplier"]
	
	if (colorType == "Class") then
		r, g, b = unpack(A.colors.class[class or select(2, UnitClass(unit))] or A.colors.backdrop.default)
	elseif (colorType == "Health") then
		r, g, b = unpack(A.colors.health.standard)
	elseif (colorType == "Power") then
		r, g, b = unpack(A.colors.power[parent.powerToken] or A.colors.power[parent.powerType])
	elseif (colorType == "Custom") then
		t = db["Custom Color"]
	end
	
	if t then
		r, g, b, a = unpack(t)
	end

	if r then
		bar:SetStatusBarColor(r, g, b, a or 1)
		if (bar.bg) then
			bar.bg:SetVertexColor(r * mult, g * mult, b * mult, a or 1)
		end
	end
end

local function setupMissingBar(castbar, db)
	if (not db) then return end

	local bar = castbar.missingBar
	local parent = castbar:GetParent()

	if (db["Enabled"]) then
		local tex = castbar:GetStatusBarTexture()
		local orientation = castbar:GetOrientation()
		local reversed = castbar:GetReverseFill()
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
		
		bar:SetSize(castbar:GetSize())

		-- Calculate value based on missing health
		bar:SetMinMaxValues(0, parent.castBarMax)
		bar:SetValue(parent.castBarMax - parent.castbarCurrent)

		-- Do coloring based on db
		Color(bar, parent)

		bar:Show()
	else
		bar:Hide()
	end
end

function Castbar:Init(parent)
	local parentName = parent.GetDbName and parent:GetDbName() or parent:GetName()
	local db = A["Profile"]["Options"][parentName][elementName]

	local size = db["Size"]
	local texture = media:Fetch("statusbar", db["Texture"])
	local width = size["Match width"] and parent:GetWidth() or size["Width"]
	local height = size["Match height"] and parent:GetWidth() or size["Height"]

	local bar = parent.orderedElements:get(elementName)
	if (not bar) then
		bar = CreateFrame("StatusBar", T:frameName(parent:GetName(), elementName), parent)
		bar.db = db

		local name = buildText(bar, db["Name"]["Font Size"]):shadow():enforceHeight():build()
		name:SetText("")

		local time = buildText(bar, db["Time"]["Font Size"]):shadow():build()
		time:SetText("")

		bar.Text = name
		bar.Time = time
		bar.Icon = bar:CreateTexture(nil, "OVERLAY")
		bar.Icon:SetTexCoord(0.133,0.867,0.133,0.867)
		bar.bg = bar:CreateTexture(nil, "BORDER")
		bar.bg:SetAllPoints()

		bar.missingBar = CreateFrame("StatusBar", nil, bar)

		bar.Update = function(self, event, ...)
	    	Castbar:Update(self, event, ...)
	   	end

	   	bar:RegisterEvent("UNIT_HEALTH_FREQUENT")
	    bar:RegisterEvent("UNIT_MAXHEALTH")
	    bar:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
	    end)

		bar:HookScript("OnShow", function(self)
			self:SetStatusBarTexture(texture)
			self.bg:SetTexture(texture)
		end)
	end

	bar:SetSize(width, height)

	local iconW, iconH, iconX, iconY
	local iconDb = db["Icon"]

	if iconDb["Enabled"] then

		if iconDb["Size"]["Match width"] then
			iconW = width
			iconH = width
		elseif iconDb["Size"]["Match height"] then
			iconH = height
			iconW = height
		else
			iconW = iconDb["Size"]
			iconH = iconDb["Size"]
		end

		bar.Icon:SetSize(iconW, iconH)
		T:Background(bar, iconDb, bar.Icon, false)
	end

	if not bar.setup then
		bar.oldSetPoint = bar.SetPoint
		bar.SetPoint = function(self, lp, r, p, x, y)
			if iconDb["Enabled"] then
				self.Icon:SetPoint(lp, r == self.Icon and self.Icon:GetParent():GetParent() or r, p, x or 0, (y or 0) - 1)
				local p = iconDb["Position"]
				if p == "LEFT" then
					bar:oldSetPoint("LEFT", bar.Icon, "RIGHT", 0, 0)
				elseif p == "RIGHT" then
					bar:oldSetPoint("RIGHT", bar.Icon, "LEFT", 0, 0)
				end
				width = (size["Match width"] and parent:GetWidth() or size["Width"]) - iconW
			else
				bar:oldSetPoint(lp, r, p, x or 0, (y or 0) - 1)
			end
			bar:SetSize(width, height)
		end
		bar.setup = true
	end

	bar:Update(UnitEvent.UPDATE_DB, self.db)
	bar:Update(UnitEvent.UPDATE_TEXTS)
	bar:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements:set(elementName, bar)
end

function Castbar:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db or arg2

	if (event == UnitEvent.UPDATE_DB) then
		Units:Position(self.Text, db["Name"]["Position"])
		Units:Position(self.Time, db["Time"]["Position"])

		self:SetStatusBarTexture(texture)
		self.bg:SetTexture(texture)

		CheckEnabled(self.Text, db["Name"])
		CheckEnabled(self.Time, db["Time"])
		CheckEnabled(self.Icon, db["Icon"])

		T:Background(self, db, nil, true)

		Units:PlaceCastbar(parent, true)
	else

	end

	Color(self, parent)
	setupMissingBar(self, self.db["Missing Bar"])
end