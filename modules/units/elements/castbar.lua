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
	local db = parent.db[elementName]

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
	    	self:Update(UnitEvent.UPDATE_CASTBAR, event, ...)
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

		local iconW, iconH
		local iconDb = db["Icon"]

		if iconDb["Enabled"] then

			local size = iconDb["Size"]
			local width, height = parent:GetSize()

			if size["Match width"] then
				iconW = width
				iconH = width
			elseif size["Match height"] then
				iconH = height
				iconW = height
			else
				iconW = size["Size"]
				iconH = size["Size"]
			end

			self.Icon:SetSize(iconW, iconH)
			T:Background(self, iconDb, self.Icon, false)

			self.Icon:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 1)
			self:SetPoint("LEFT", self.Icon, "RIGHT", 1, 0)
		else
			self:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 1)
		end

		Units:PlaceCastbar(parent, db)
	else
		parent:Update(event, arg1, arg2, arg3, arg4, arg5)

		local name = parent.castBarSpell
		if (not name) then
			self:Hide()
		else -- Add OnUpdate here...
			self:Show()
			local duration = parent.castBarEnd - parent.castBarStart
			self.Icon:SetTexture(parent.castBarTexture)
			self.Text:SetText(name)
			self.Time:SetText(duration / 1e3)

			self:SetMinMaxValues(parent.castBarStart, parent.castBarEnd)
			self:SetValue(duration + arg2)
		end
	end

	Units:SetupMissingBar(self, self.db["Missing Bar"], "missingBar", parent.castBarStart, parent.castBarEnd, A.noop, A.ColorBar)
	A:ColorBar(self, parent, parent.castBarStart, parent.castBarEnd, A.noop)
end