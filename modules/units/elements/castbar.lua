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

	if (not db) then return end

	local container = parent.orderedElements:get(elementName)
	if (not container) then
		container = CreateFrame("Frame", T:frameName(parent:GetName(), elementName), parent)
		container.db = db
		
		local bar = CreateFrame("StatusBar", nil, container)
		bar:SetFrameLevel(2)
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
			self.bar:SetStatusBarTexture(media:Fetch("statusbar", db["Texture"]))
			self.bar.bg:SetTexture(media:Fetch("statusbar", db["Texture"]))
		end)

		if (parent.unit == "player") then
			CastingBarFrame:UnregisterAllEvents()
			CastingBarFrame.Show = CastingBarFrame.Hide
			CastingBarFrame:Hide()

			PetCastingBarFrame:UnregisterAllEvents()
			PetCastingBarFrame.Show = PetCastingBarFrame.Hide
			PetCastingBarFrame:Hide()
		end

		container:Hide()
	end

	container:Update(UnitEvent.UPDATE_DB)
	container:Update(UnitEvent.UPDATE_CASTBAR)

	parent.orderedElements:set(elementName, container)
end

function Castbar:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db or arg2
	local bar = self.bar
	local texture = media:Fetch("statusbar", db["Texture"])

	if (event == UnitEvent.UPDATE_DB) then
		Units:Position(self.Text, db["Name"]["Position"])
		Units:Position(self.Time, db["Time"]["Position"])

		bar:SetStatusBarTexture(texture)
		bar.bg:SetTexture(texture)

		CheckEnabled(self.Text, db["Name"])
		CheckEnabled(self.Time, db["Time"])
		CheckEnabled(self.Icon, db["Icon"])

		local size = db["Size"]
		self:SetWidth(size["Match width"] and parent:GetWidth() or size["Width"])
		self:SetHeight(size["Match height"] and parent:GetHeight() or size["Height"])

		T:Background(self, db, nil, false)

		local iconW, iconH
		local iconDb = db["Icon"]

		if (iconDb["Enabled"]) then

			size = iconDb["Size"]
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
				self.Icon:SetPoint("LEFT", self, "LEFT", 0, 0)
				bar:SetPoint("TOPLEFT", self.Icon, "TOPRIGHT", 1, 0)
				bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
			elseif (iconPosition == "RIGHT") then
				self.Icon:SetPoint("RIGHT", self, "RIGHT", 0, 0)
				bar:SetPoint("TOPRIGHT", self.Icon, "TOPLEFT", -1, 0)
				bar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
			elseif (iconPosition == "TOP") then
				self.Icon:SetPoint("TOP", self, "TOP", 0, -1)
				bar:SetPoint("TOPLEFT", self.Icon, "BOTTOMLEFT", 0, 1)
				bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
			else
				self.Icon:SetPoint("BOTTOM", self, "BOTTOM", 0, 1)
				bar:SetPoint("BOTTOMLEFT", self.Icon, "TOPLEFT", 0, 1)
				bar:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
			end
		else
			bar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		end

		Units:PlaceCastbar(self, db)
	elseif (event == "OnUpdate") then
		if (parent.casting) then

			local duration = parent.castBarDuration + arg1
			if(duration >= parent.castBarMax) then
				parent.casting = nil
				parent.castBarCastId = nil

				self:SetScript("OnUpdate", nil)

				self:Hide()
			end

			self.Time:SetText(db["Time"]["Format"]
					:replace("[current]", T:short(duration, 1))
					:replace("[max]", T:short(parent.castBarMax, 1))
					:replace("[delay]", "-"..parent.castBarDelay)
			)

			self.Text:SetText(db["Name"]["Format"]
					:replace("[name]", parent.castBarSpell)
					:replace("[target]", UnitName("target") or "")
			)

			parent.castBarDuration = duration
			bar:SetValue(duration)
		else
			parent.casting = nil
			parent.castBarCastId = nil

			self:SetScript("OnUpdate", nil)

			self:Hide()
		end

		return
	else
		parent:Update(event, arg1, arg2, arg3, arg4, arg5)

		if (parent.castBarSpell and (arg1 == 'UNIT_SPELLCAST_START' or arg1 == 'UNIT_SPELLCAST_CHANNEL_START')) then
			self.Icon:SetTexture(parent.castBarTexture)
			bar:SetMinMaxValues(0, parent.castBarMax)
			bar:SetValue(0)

			self:SetScript("OnUpdate", function(self, elapsed)
				self:Update("OnUpdate", elapsed)
			end)

			self:Show()
		end

		return
	end

	Units:SetupMissingBar(self, self.db["Missing Bar"], "missingBar", parent.castBarDuration, parent.castBarMax, A.noop, A.ColorBar)
	A:ColorBar(self.bar, parent, parent.castBarDuration, parent.castBarMax, A.noop)
end