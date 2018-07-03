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

		bar:RegisterEvent('UNIT_SPELLCAST_START')
		bar:RegisterEvent('UNIT_SPELLCAST_FAILED')
		bar:RegisterEvent('UNIT_SPELLCAST_STOP')
		bar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
		bar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTIBLE')
		bar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
		bar:RegisterEvent('UNIT_SPELLCAST_DELAYED')
		bar:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
		bar:RegisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE')
		bar:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
	    bar:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(UnitEvent.UPDATE_CASTBAr, event, ...)
	    end)

		bar:HookScript("OnShow", function(self)
			self:SetStatusBarTexture(texture)
			self.bg:SetTexture(texture)
		end)

		if (parent.unit == 'player') then
			CastingBarFrame:UnregisterAllEvents()
			CastingBarFrame.Show = CastingBarFrame.Hide
			CastingBarFrame:Hide()

			PetCastingBarFrame:UnregisterAllEvents()
			PetCastingBarFrame.Show = PetCastingBarFrame.Hide
			PetCastingBarFrame:Hide()
		end
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
	bar:Update(UnitEvent.UPDATE_CASTBAR)

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
		parent:Update(event, arg1, arg2, arg3, arg4, arg5)

		local name = parent.castBarSpell
		if (not name) then
			self:Hide()
		else
			self:Show()
		end
	end

	Units:SetupMissingBar(self, self.db["Missing Bar"], "missingBar", parent.castBarCurrent, parent.castBarMax, A.noop, A.ColorBar)
	A:ColorBar(self, parent, parent.castBarCurrent, parent.castBarMax, A.noop)
end