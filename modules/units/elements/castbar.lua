local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local U = A.Utils
local buildText = A.TextBuilder

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitName = UnitName

--[[ Locals ]]
local elementName = "castbar"
local Castbar = { name = elementName }

A.elements.shared[elementName] = Castbar

local function CheckEnabled(e, db)
	if not db.enabled then
		e:Hide()
	else
		e:Show()
	end
end

local function updateSafeZone(self)
	local safeZone = self.safeZone
	local width = self.bar:GetWidth()
	local _, _, _, ms = GetNetStats()

	local safeZoneRatio = (ms / 1e3) / self.max
	if(safeZoneRatio > 1) then
		safeZoneRatio = 1
	end

	safeZone:SetWidth(width * safeZoneRatio)
end

function Castbar:Init(parent)
	local db = parent.db[elementName]

	if (not db) then return end

	local container = parent.orderedElements[elementName]
	if (not container) then
		container = CreateFrame("Frame", parent:GetName().."_"..elementName, parent)
		container.db = db
		container.noTags = true
		
		local bar = CreateFrame("StatusBar", nil, container)
		bar:SetFrameLevel(2)
		bar.db = db
		bar.bg = container:CreateTexture(nil, "BORDER")
		bar.bg:SetAllPoints()

		local safeZone = bar:CreateTexture(nil, "OVERLAY")
		safeZone:SetTexture(A.enum.backdrops.editbox.bgFile)
		safeZone:SetVertexColor(0.8, 0.3, 0.3, 0.5)
		safeZone:SetDrawLayer("OVERLAY", 4)

		local name = buildText(container, db.name.size):shadow():enforceHeight():build()
		name:SetText("")

		local time = buildText(container, db.time.size):shadow():build()
		time:SetText("")

		container.bar = bar
		container.safeZone = safeZone
		container.Text = name
		container.Time = time
		container.Icon = container:CreateTexture(nil, "OVERLAY")
		container.Icon:SetTexCoord(0.133,0.867,0.133,0.867)

		container.bar.missingBar = CreateFrame("StatusBar", nil, container.bar)
		container.bar.missingBar:SetFrameLevel(container.bar:GetFrameLevel())

		container.Update = function(self, event, ...)
	    	Castbar:Update(self, event, ...)
	   	end

		container:RegisterUnitEvent("UNIT_SPELLCAST_START", parent.unit);
		container:RegisterUnitEvent("UNIT_SPELLCAST_STOP", parent.unit);
		container:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", parent.unit);
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
			self.bar:SetStatusBarTexture(media:Fetch("statusbar", db.texture))
			self.bar.bg:SetTexture(media:Fetch("statusbar", db.texture))

			if (parent.unit) then
				if (self.casting) then
					local _,_,_,startTime = UnitCastingInfo(parent.unit)
					if (startTime) then
						self.value = (GetTime() - (startTime / 1000))
					end
				else
					local _,_,_,_,endTime = UnitChannelInfo(parent.unit)
					if (endTime) then
						self.value = ((endTime / 1000) - GetTime())
					end
				end
			end

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

		container:Hide()
	end

	container:Update(UnitEvent.UPDATE_DB)
	container:Update(UnitEvent.UPDATE_CASTBAR)

	parent.orderedElements[elementName] = container
end

function Castbar:Update(...)

	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db or arg2
	local bar = self.bar

	if (event == UnitEvent.UPDATE_DB) then
		Units:Position(self.Text, db.name.position)
		Units:Position(self.Time, db.time.position)

		local texture = media:Fetch("statusbar", db.texture)

		bar:SetStatusBarTexture(texture)
		bar.bg:SetTexture(texture)

		CheckEnabled(self.Text, db.name)
		CheckEnabled(self.Time, db.time)
		CheckEnabled(self.Icon, db.icon)

		self:SetWidth(db.size.matchWidth and parent:GetWidth() or db.size.width)
		self:SetHeight(db.size.matchHeight and parent:GetHeight() or db.size.height)

		self.getMoverSize = function(self)
			return self:GetSize()
		end

		U:CreateBackground(self, db, false)

		local iconW, iconH

		if (db.icon.enabled) then

			size = db.icon.size
			local width, height = self:GetSize()

			if (size.matchWidth) then
				iconW = width
				iconH = width
			elseif (size.matchHeight) then
				iconH = height
				iconW = height
			else
				iconW = size.size
				iconH = size.size
			end

			self.Icon:SetSize(iconW, iconH)
			U:CreateBackground(self.Icon, db.icon, false)
			self.Icon.Background:SetBackdropBorderColor(0, 0, 0, 0)

			if (db.icon.position == "LEFT") then
				self.Icon:SetPoint("LEFT", self, "LEFT", 0, 0)
				bar:SetPoint("TOPLEFT", self.Icon, "TOPRIGHT", 1, 0)
				bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
			elseif (db.icon.position == "RIGHT") then
				self.Icon:SetPoint("RIGHT", self, "RIGHT", 0, 0)
				bar:SetPoint("TOPRIGHT", self.Icon, "TOPLEFT", -1, 0)
				bar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
			elseif (db.icon.position == "TOP") then
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
		Units:SetupMissingBar(self.bar, self.db.missingBar, "missingBar", self.value, self.max, A.noop, A.ColorBar)
	elseif (event == "OnUpdate") then

		if (self.casting) then

			self.value = self.value + arg1
			if(self.value >= self.max) then
				self.casting = nil
				self.id = nil

				return self:Hide()
			end

			self.Time:SetText(db.time.format
					:replace("[current]", T:timeShort(self.value, 1, true))
					:replace("[max]", T:timeShort(self.max, 1, true))
					:replace("[delay]", "-"..self.delay)
			)

			self.Text:SetText(db.name.format
					:replace("[name]", self.spell)
					:replace("[target]", UnitName("target") or "")
			)

			Units:UpdateMissingBar(self.bar, "missingBar", self.value, self.max)
			bar:SetValue(self.value)
		elseif (self.channeling) then
			
			self.value = self.value - arg1;
			if (self.value <= 0) then
				self.channeling = nil
				self.id = nil

				return self:Hide()
			end

			self.Time:SetText(db.time.format
					:replace("[current]", T:timeShort(self.value, 1, true))
					:replace("[max]", T:timeShort(self.max, 1, true))
					:replace("[delay]", "-"..self.delay)
			)

			self.Text:SetText(db.name.format
					:replace("[name]", self.spell)
					:replace("[target]", UnitName("target") or "")
			)
			
			Units:UpdateMissingBar(self.bar, "missingBar", self.value, self.max)
			bar:SetValue(self.value);
		else
			self.casting = nil
			self.channeling = nil
			self.id = nil

			self:Hide()
		end

		return
	else
		if (arg2 ~= parent.unit) then return end

        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID
        if (arg1 == 'UNIT_SPELLCAST_START') then
            
			name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo(parent.unit)
            
            if (not name) then
                return self:Hide()
            end

            self.Icon:SetTexture(texture)

            self.spell = text
			self.value = (GetTime() - (startTime / 1000))
			self.max = (endTime - startTime) / 1000
			bar:SetMinMaxValues(0, self.max)
			bar:SetValue(self.value)

			self.holdTime = 0
			self.casting = true
			self.id = castID
			self.channeling = nil
			self.fadeOut = nil
            self.delay = 0

			self.safeZone:ClearAllPoints()
			self.safeZone:SetPoint(self.bar:GetReverseFill() and "LEFT" or "RIGHT")
			self.safeZone:SetPoint("TOP")
			self.safeZone:SetPoint("BOTTOM")
			updateSafeZone(self)

			self:Show()

		elseif (arg1 == 'UNIT_SPELLCAST_CHANNEL_START') then
        
			name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = UnitChannelInfo(parent.unit)
	        
            if (not name) then
                return self:Hide()
            end

            self.Icon:SetTexture(texture)
	        
	        self.value = (endTime / 1000) - GetTime()
			self.max = (endTime - startTime) / 1000
			bar:SetMinMaxValues(0, self.max)
			bar:SetValue(self.value);

			self.spell = text
			self.holdTime = 0
			self.casting = nil
			self.channeling = true
			self.fadeOut = nil
	        self.delay = 0

	        self.safeZone:ClearAllPoints()
			self.safeZone:SetPoint(self.bar:GetReverseFill() and "RIGHT" or "LEFT")
			self.safeZone:SetPoint("TOP")
			self.safeZone:SetPoint("BOTTOM")
			updateSafeZone(self)

	        self:Show()

        elseif (arg1 == 'UNIT_SPELLCAST_INTERRUPTIBLE') then
            
            notInterruptible = false

        elseif (arg1 == 'UNIT_SPELLCAST_NOT_INTERRUPTIBLE') then
            
            notInterruptible = true

        elseif (arg1 == 'UNIT_SPELLCAST_DELAYED') then
            if (self:IsShown()) then
				
				name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(parent.unit)
				
				if (not name) then
					return self:Hide()
				end

				self.value = (GetTime() - (startTime / 1000))
				self.max = (endTime - startTime) / 1000
				bar:SetMinMaxValues(0, self.max)
				if (not self.casting) then
					self.casting = true
					self.channeling = nil
					self.flash = nil
					self.fadeOut = nil
				end
	        end
        elseif (arg1 == 'UNIT_SPELLCAST_CHANNEL_UPDATE') then

            if (self:IsShown()) then
				name, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(parent.unit)
				
				if (not name) then
					return self:Hide()
				end
				
				self.value = ((endTime / 1000) - GetTime())
				self.max = (endTime - startTime) / 1000
				
				bar:SetMinMaxValues(0, self.max)
				bar:SetValue(self.value)
			end

        elseif (arg1 == 'UNIT_SPELLCAST_FAILED') then
        	if (self:IsShown()) then
	            if(self.id ~= arg5) then
	                return
	            end

	            self.Text:SetText(FAILED)

	            self.casting = nil
				self.channeling = nil
	        end
        elseif (arg1 == 'UNIT_SPELLCAST_STOP') then
        	if (not self:IsVisible()) then
        		self:Hide()
        	end

        	bar:SetValue(self.max or 0)
        	self.casting = nil

            if(self.id ~= arg5) then
                return
            end

        elseif (arg1 == 'UNIT_SPELLCAST_CHANNEL_STOP') then
        	if (not self:IsVisible()) then
        		self:Hide()
        	end

        	bar:SetValue(self.max)
        	self.channeling = nil

        elseif (arg1 == 'UNIT_SPELLCAST_INTERRUPTED') then

        	if (self:IsShown()) then
	            if(self.id ~= arg5) then
	                return
	            end

	            self.Text:SetText(INTERRUPTED)

	            self.casting = nil
				self.channeling = nil
	        end
        end

		return
	end

	A:ColorBar(self.bar, parent, self.value, self.max, A.noop)
end