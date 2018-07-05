local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local buildText = A.TextBuilder

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitName = UnitName

--[[ Locals ]]
local elementName = "Castbar"
local Castbar = { name = elementName }

A["Shared Elements"]:set(elementName, Castbar)

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

	local container = parent.orderedElements:get(elementName)
	if (not container) then
		container = CreateFrame("Frame", T:frameName(parent:GetName(), elementName), parent)
		container.db = db
		
		local bar = CreateFrame("StatusBar", nil, parent)
		bar.db = db
		bar.bg = container:CreateTexture(nil, "BORDER")
		bar.bg:SetAllPoints()

		local name = buildText(container, db["Name"]["Font Size"]):shadow():enforceHeight():build()
		name:SetText("")

		local time = buildText(container, db["Time"]["Font Size"]):shadow():build()
		time:SetText("")

		container.bar = bar
		container.Text = name
		container.Time = time
		container.Icon = container:CreateTexture(nil, "OVERLAY")
		container.Icon:SetTexCoord(0.133,0.867,0.133,0.867)

		container.missingBar = CreateFrame("StatusBar", nil, container)

		container.Update = function(self, event, ...)
	    	Castbar:Update(self, event, ...)
	   	end

		container:RegisterEvent('UNIT_SPELLCAST_START')
		container:RegisterEvent('UNIT_SPELLCAST_FAILED')
		container:RegisterEvent('UNIT_SPELLCAST_STOP')
		container:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
		container:RegisterEvent('UNIT_SPELLCAST_INTERRUPTIBLE')
		container:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
		container:RegisterEvent('UNIT_SPELLCAST_DELAYED')
		container:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
		container:RegisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE')
		container:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
	    container:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(UnitEvent.UPDATE_CASTBAR, event, ...)
	    end)

		container:HookScript("OnShow", function(self)
			self.bar:SetStatusBarTexture(texture)
			self.bar.bg:SetTexture(texture)
		end)

		container:SetScript("OnUpdate", function(self, elapsed)
			self:Update("OnUpdate", elapsed)
		end)

		if (parent.unit == "player") then
			CastingBarFrame:UnregisterAllEvents()
			CastingBarFrame.Show = CastingBarFrame.Hide
			CastingBarFrame:Hide()

			PetCastingBarFrame:UnregisterAllEvents()
			PetCastingBarFrame.Show = PetCastingBarFrame.Hide
			PetCastingBarFrame:Hide()
		end
	end

	container:SetSize(width, height)

	container:Update(UnitEvent.UPDATE_DB)
	container:Update(UnitEvent.UPDATE_CASTBAR)

	parent.orderedElements:set(elementName, container)
end

function Castbar:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db or arg2
	local bar = self.bar

	if (event == UnitEvent.UPDATE_DB) then
		Units:Position(self.Text, db["Name"]["Position"])
		Units:Position(self.Time, db["Time"]["Position"])

		bar:SetStatusBarTexture(texture)
		bar.bg:SetTexture(texture)

		CheckEnabled(self.Text, db["Name"])
		CheckEnabled(self.Time, db["Time"])
		CheckEnabled(self.Icon, db["Icon"])

		T:Background(self, db, nil, true)
		self:SetBackdropBorderColor(0, 0, 0, 0)

		local iconW, iconH
		local iconDb = db["Icon"]

		if (iconDb["Enabled"]) then

			local size = iconDb["Size"]
			local width, height = self:GetSize()

			if (size["Match width"]) then
				iconW = width
				iconH = width
			elseif (size["Match height"]) then
				iconH = height
				iconW = height
			else
				iconW = size["Size"]
				iconH = size["Size"]
			end

			self.Icon:SetSize(iconW, iconH)
			T:Background(self, iconDb, self.Icon, false)
			self.Icon.bg:SetBackdropBorderColor(0, 0, 0, 0)

			local iconPosition = iconDb["Position"]
			if (iconPosition == "LEFT") then
				self.Icon:SetPoint("LEFT", self, "LEFT", 1, 0)
				bar:SetPoint("LEFT", self.Icon, "RIGHT", 1, 0)
				bar:SetPoint("RIGHT", self, "RIGHT", -1, 0)
			elseif (iconPosition == "RIGHT") then
				self.Icon:SetPoint("RIGHT", self, "RIGHT", -1, 0)
				bar:SetPoint("RIGHT", self.Icon, "LEFT", -1, 0)
				bar:SetPoint("LEFT", self, "LEFT", 1, 0)
			elseif (iconPosition == "TOP") then
				self.Icon:SetPoint("TOP", self, "TOP", 0, -1)
				bar:SetPoint("TOP", self.Icon, "BOTTOM", 0, -1)
				bar:SetPoint("BOTTOM", self, "BOTTOM", 0, -1)
			else
				self.Icon:SetPoint("BOTTOM", self, "BOTTOM", 0, 1)
				bar:SetPoint("BOTTOM", self.Icon, "TOP", 0, 1)
				bar:SetPoint("TOP", self, "TOP", 0, 1)
			end
		else
			if (db["Orientation"] == "HORIZONTAL") then
				bar:SetPoint("LEFT", parent, "LEFT", 1, 0)
			else
				bar:SetPoint("BOTTOM", parent, "BOTTOM", 0, 1)
			end
		end

		Units:PlaceCastbar(self, db)
	elseif (event == "OnUpdate") then
		if (parent.casting) then
			local max = parent.castBarEnd - parent.castBarStart
			local duration = parent.castBarEnd - GetTime()

			if (duration < 0) then
				duration = 0
			end

			local current = duration + arg1

			self.Time:SetText(db["Time"]["Format"]
					:format("[current]", current / 1e3)
					:format("[max]", max / 1e3)
					:format("[delay]", "-"..parent.castBarDelay)
			)

			self.Text:SetText(db["Text"]["Format"]
					:format("[name]", parent.castBarSpell)
					:format("[target]", UnitName("target") or "")
			)

			self:SetMinMaxValues(parent.castBarStart, parent.castBarEnd)
			self:SetValue(current)
		end
	else
		parent:Update(event, arg1, arg2, arg3, arg4, arg5)

		local name = parent.castBarSpell
		if (not name) then
			self:Hide()
		else -- Add OnUpdate here...
			self:Show()
			self.Icon:SetTexture(parent.castBarTexture)
		end
	end

	Units:SetupMissingBar(self, self.db["Missing Bar"], "missingBar", parent.castBarStart, parent.castBarEnd, A.noop, A.ColorBar)
	A:ColorBar(self.bar, parent, parent.castBarStart, parent.castBarEnd, A.noop)
end