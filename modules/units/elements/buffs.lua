local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]

--[[ Lua ]]

--[[ Locals ]]
local elementName = "Buffs"
local Buffs = {}
local buildText = A.TextBuilder

local function orderBuffs(parent)

	local db = parent.db
	local all = {}

	for caster, spells in next, parent.buttons do
		for spellID, button in next, spells do
			table.insert(all, button)
		end
	end

	table.sort(all, function(left, right) return left.expires < right.expires end)

	local processed = {}

	local relative = parent
	for index, button in next, all do
		button:ClearAllPoints()

		if (button.expires >= GetTime()) then
			if (#processed == 0) then
				button:SetPoint("LEFT", parent, "LEFT", 0, 0)
			else
				button:SetPoint("BOTTOMLEFT", relative, "TOPLEFT", 0, 0)
			end
			relative = button

			table.insert(processed, button)
		end
	end
end

function Buffs:Init(parent)

	local db = parent.db[elementName]

	if (not db) then return end

	local buffs = parent.orderedElements:get(elementName)
	if (not buffs) then
		
		buffs = CreateFrame("Frame", parent:GetName().."_"..elementName, parent)
		buffs:SetSize(16, 16)
		buffs.db = db
		buffs.active = A:OrderedMap()

		buffs:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 0)

		buffs.pools = CreatePoolCollection()
		buffs.pool = buffs.pools:CreatePool("BUTTON", buffs, "AuraIconBarTemplate")
		buffs.buttons = {}

		buffs.Update = function(self, ...)
			Buffs:Update(self, ...)
		end

		buffs:RegisterUnitEvent("UNIT_AURA", parent.unit)
		buffs:SetScript("OnEvent", function(self, event, ...)
			self:Update(event, ...)
		end)

		BuffFrame:UnregisterEvent("UNIT_AURA")
		BuffFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
		BuffFrame:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")

		BuffFrame:SetParent(A.hiddenFrame)
	end

	buffs:Update(UnitEvent.UPDATE_DB)
	buffs:Update(UnitEvent.UPDATE_BUFFS)

	parent.orderedElements:set(elementName, buffs)

--[[
	local growth, attached, style, size = db["Growth"], db["Attached"], db["Style"], db["Size"]
	local buffs = frame.Buffs or (function()
		local buffs = 
		buffs:SetSize(frame:GetWidth(), 300)
		return buffs
	end)()

	local x, y = 0, 0
	if style == "Bar" then
		if growth == "Left" or growth == "Right" then
			x = 1
		else
			y = 1
		end
	elseif style == "Icon" then
		x = 1
		y = 1
	end

	if attached ~= false then
		buffs:SetPoint(T.reversedPoints[attached], frame, attached, x, y)
		A:DeleteMover("Buffs")
	else
		A:CreateMover(buffs, db, "Buffs")
		Units:Position(buffs, db["Position"])
	end

	T:Switch(style, 
		"Icon", function()
			local width = size["Width"]
			local height = size["Height"]
			
			buffs.CustomFilter = function(element, unit, button, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID)
				if db["Blacklist"]["Enabled"] then
					return not db["Blacklist"]["Ids"][spellID]
				elseif db["Whitelist"]["Enabled"] then
					return db["Whitelist"]["Ids"][spellID]
				end
			end

			buffs:SetSize(width * (db["Limit X"] or 5), height * (db["Limit Y"] or 2))
			buffs['spacing-x'] = 1
			buffs['spacing-y'] = 1

			buffs.PostUpdateIcon = function(element, unit, button, index)
				local name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID = UnitAura(unit, index, "HELPFUL")

				if db["Blacklist"]["Enabled"] and db["Blacklist"]["Ids"][spellID] then
					button:Hide()
					return
				elseif db["Whitelist"]["Enabled"] and not db["Whitelist"]["Ids"][spellID] then
					button:Hide()
					return
				end

				local background = button.background or CreateFrame("Frame", nil, button)
				background:SetPoint("CENTER")
				background:SetSize(button:GetSize())
				background:SetFrameLevel(button:GetFrameLevel() - 1)

				button.background = background

				T:Background(background, db, nil, true)

				button.icon:SetTexCoord(0.133,0.867,0.133,0.867)

				button.spellID = spellID

				if not button.initCount then
					button.initCount = true
					button.count:Hide()
					button.count = buildText(button, 10):outline():atCenter():build()
					button.count:Show()
					button.count:SetJustifyH("CENTER")
				end

				if not button.fixcd then
					button.fixcd = true
					for _,region in pairs({ button.cd:GetRegions() }) do
						if region.GetObjectType and region:GetObjectType() == "FontString" then
							region:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
							region:SetJustifyH("CENTER")
						end
					end
				end

				button.count:SetText(count > 1 and count or "")
				button:Show()
				
			end

		end,
		"Bar", function()
			local width = size["Match width"] and frame:GetWidth() or size["Width"]
			local height = size["Match height"] and frame:GetHeight() or size["Height"]

			buffs.disableCooldown = true
			buffs.CustomFilter = function(element, unit, button, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID)
				if db["Blacklist"]["Enabled"] then
					return not db["Blacklist"]["Ids"][spellID]
				elseif db["Whitelist"]["Enabled"] then
					return db["Whitelist"]["Ids"][spellID]
				end
			end

			buffs.SetPosition = function(element, from, to)
				local sizex = (element.size or 16) + (element['spacing-x'] or element.spacing or 0)
				local sizey = (element.size or 16) + (element['spacing-y'] or element.spacing or 0)
				local anchor = element.initialAnchor or 'BOTTOMLEFT'
				local x, y = 0, 0

				for i = from, to do

					local button = element[i]
					if(not button) then break end

					if not button.bar then
						button.bar = CreateFrame("StatusBar", nil, button)
						button.bar:SetStatusBarTexture(media:Fetch("statusbar", "Default2"))
						button.bar:SetStatusBarColor(0.3, 0.6, 0.8)
						button.bar.bg = button.bar.bg or button.bar:CreateTexture(nil, "BACKGROUND")
						button.bar.bg:SetTexture(media:Fetch("statusbar", "Default2"))
						button.bar.bg:SetVertexColor(0.3 * .3, 0.6 * .3, 0.8 * .3)
						button.bar.bg:SetAllPoints()

						button:SetScript("OnClick", function(self, button, down)
							if not down and IsShiftKeyDown() and IsAltKeyDown() and IsControlKeyDown() and button == "RightButton" then
								if db["Blacklist"]["Enabled"] then
									db["Blacklist"]["Ids"][self.spellID] = true
								elseif db["Whitelist"]["Enabled"] then
									table.remove(db["Whitelist"]["Ids"], self.spellID)
								end
								A.dbProvider:Save()
								buffs:ForceUpdate()
							end
						end)

						local name = buildText(button.bar, 0.7):enforceHeight():shadow():atLeft():x(3):build()
						name:SetJustifyH("LEFT")

						local time = buildText(button.bar, 9):shadow():atRight():x(-5):build()
						time:SetJustifyH("RIGHT")

						button.bar.name = name
						button.bar.time = time
					end

					button.bar:ClearAllPoints()
					button.icon:SetTexCoord(0.133,0.867,0.133,0.867)
					
					local background = button.background or CreateFrame("Frame", nil, button)
					background:SetPoint("LEFT")
					background:SetSize(width, sizey)
					background:SetFrameLevel(button:GetFrameLevel() - 1)

					button.background = background

					T:Background(background, db, nil, true)

					T:Switch(growth,
						"Upwards", function() 
							x = 0
							y = sizey * (i - 1)
							button.bar:SetPoint("LEFT", button, "RIGHT", 0, 0)
							button.bar:SetSize(width - sizex, sizey)
						end,
						"Downwards", function() 
							x = 0
							y = sizey * (i - 1) * -1
							button.bar:SetPoint("LEFT", button, "RIGHT", 0, 0)
							button.bar:SetSize(width - sizex, sizey)
						end,
						"Left", function()
							x = sizex * (i - 1) * -1
							y = 0
							button.bar:SetPoint("BOTTOM", button, "TOP", 0, 0)
							button.bar:SetSize(sizex, height - sizey)
						end,
						"Right", function()
							x = sizex * (i - 1)
							y = 0
							button.bar:SetPoint("BOTTOM", button, "TOP", 0, 0)
							button.bar:SetSize(sizex, height - sizey)
						end)

					button:ClearAllPoints()
					if i ~= 1 then
						y = y + i - 1
					end
					button:SetPoint(anchor, element, anchor, x, y)
				end
			end

			buffs.PostUpdateIcon = function(element, unit, button, index)
				local name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID = UnitAura(unit, index, "HELPFUL")
				if button.bar then

					if db["Blacklist"]["Enabled"] and db["Blacklist"]["Ids"][spellID] then
						button:Hide()
						return
					elseif db["Whitelist"]["Enabled"] and not db["Whitelist"]["Ids"][spellID] then
						button:Hide()
						return
					end

					button.spellID = spellID

					button.bar.name:SetText(name)
					if duration == 0 then
						button.bar:SetMinMaxValues(0, 1)
						button.bar:SetValue(1)
						button.bar.time:SetText("")
						if db["Hide zero duration"] then
							button:Hide()
							return
						end
					else
						local timeLeft = expiration - GetTime()
						button.bar:SetMinMaxValues(0, duration)
						button.bar:SetValue(timeLeft)
						button.bar.time:SetText(T:timeString(timeLeft))
					end

					if not button.initCount then
						button.initCount = true
						button.count:Hide()
						button.count = buildText(button, 11):outline():atCenter():build()
						button.count:Show()
						button.count:SetJustifyH("CENTER")
					end

					button.count:SetText(count > 1 and count or "")
					button:Show()
				end
			end
		end)
		--]]
end

function Buffs:Update(...)
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (event == UnitEvent.UPDATE_DB) then

	elseif (T:anyOf(event, "UNIT_AURA", UnitEvent.UPDATE_BUFFS)) then
		if (event == "UNIT_AURA" and parent.unit ~= arg1) then return end

		parent:Update(UnitEvent.UPDATE_BUFFS)

		local size = db["Size"]
		local width, height = size["Widht"], size["Height"]

		for caster, spells in next, self.buttons do
			for spellId, button in next, spells do
				if (not parent.buffs.own[spellId] and not parent.buffs.others[spellId]) then
					button:Hide()
					button:ClearAllPoints()
					button:SetScript("OnUpdate", nil)
				end
			end
		end

		local ownAppliedBuffs = parent.buffs.own
		for spellId, aura in next, ownAppliedBuffs do

			if (aura) then
				local name, texture, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, 
					canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(aura)

				if (duration and duration > 0) then
					if (not self.buttons[caster]) then
						self.buttons[caster] = {}
					end

					if (not self.buttons[caster][spellID]) then
						local button = self.pool:Acquire("AuraIconBarTemplate")

						button:SetSize(200 + height, height)
						
						button.Icon:ClearAllPoints()
						button.Icon:SetTexture(texture)
						button.Icon:SetPoint("LEFT")
						button.Icon:SetSize(height, height)

						local text = button.Cooldown:GetRegions()
						text:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")

						CooldownFrame_Set(button.Cooldown, GetTime(), expires - GetTime(), true)
						
						button.Bar:ClearAllPoints()
						button.Bar:SetSize(200, height)
						button.Bar:SetPoint("LEFT", button.Icon, "RIGHT", 0, 0)
						button.Bar:SetStatusBarTexture(media:Fetch("statusbar", "Default"))
						button.Bar:SetStatusBarColor(1, 1, 1)
						button.Bar:SetMinMaxValues(0, expires - GetTime())
						button.Bar:SetValue(expires)

						button.Name:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
						button.Name:SetText(name)

						button.Time:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")

						button.duration = duration
						button.expires = expires

						button:SetScript("OnUpdate", function(b, elapsed)
							if (not b:IsShown()) then return end

							local time = GetTime()
							local value = b.expires - time

							if (value <= 0) then
								b:Hide()
								button:SetScript("OnUpdate", nil)
							end

							b.Time:SetText(T:timeShort(value))
							b.Bar:SetValue(value)
						end)

						button:Show()

						self.buttons[caster][spellID] = button
					else
						local button = self.buttons[caster][spellID]
						if (button.expires ~= expires) then
							button.duration = duration
							button.expires = expires

							button.Bar:SetMinMaxValues(0, expires - GetTime())
							button.Bar:SetValue(expires)

							CooldownFrame_Set(button.Cooldown, GetTime(), expires - GetTime(), true)

							button:SetScript("OnUpdate", function(b, elapsed)
								if (not b:IsShown()) then return end

								local time = GetTime()
								local value = b.expires - time

								if (value <= 0) then
									b:Hide()
									button:SetScript("OnUpdate", nil)
								end

								b.Time:SetText(T:timeShort(value))
								b.Bar:SetValue(value)
							end)

							button:Show()
						end
					end
				end
			end
		end

		if (not db["Own only"]) then
			local othersAppliedBuffs = parent.buffs.others
			for spellId, aura in next, othersAppliedBuffs do
				local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, 
						canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(aura)

			-- Take a button from pool
				-- Here want to add OnUpdate script to the button if the duration is not 0
				-- Then remove the OnUpdate when the button's duration reaches 0
			end
		end

		orderBuffs(self)
	end
end

A["Shared Elements"]:set(elementName, Buffs)