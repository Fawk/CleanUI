local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local buildText = A.TextBuilder

local Debuffs = function(frame, db)

	local growth, attached, style, size = db["Growth"], db["Attached"], db["Style"], db["Size"]
	local debuffs = frame.Debuffs or (function()
		local debuffs = CreateFrame("Frame", T:frameName(frame.unit, "Debuffs"), frame)
		debuffs:SetSize(frame:GetWidth(), 300)
		return debuffs
	end)()

	if attached ~= false then
		debuffs:SetPoint(T.reversedPoints[attached], frame, attached, 0, style == "Bar" and 1 or 0)
	else
		A:CreateMover(debuffs, db, "Debuffs")
		Units:Position(debuffs, db["Position"])
	end

	T:Switch(style, 
		"Icon", function()
			local width = size["Width"]
			local height = size["Height"]

			if growth == "Left" then
				debuffs['growth-x'] = "LEFT"
				debuffs.initialAnchor = "BOTTOMRIGHT"
			elseif growth == "Right" then
				debuffs['growth-x'] = "RIGHT"
				debuffs.initialAnchor = "BOTTOMLEFT"
			end

			debuffs.CustomFilter = function(element, unit, button, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID)
				if db["Blacklist"]["Enabled"] then
					return not db["Blacklist"]["Ids"][spellID]
				elseif db["Whitelist"]["Enabled"] then
					return db["Whitelist"]["Ids"][spellID]
				end
			end

			debuffs:SetSize(width * (db["Limit X"] or 5), height * (db["Limit Y"] or 2))

			debuffs.PostUpdateIcon = function(element, unit, button, index)
				local name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID = UnitAura(unit, index, "HARMFUL")

				if db["Blacklist"]["Enabled"] and db["Blacklist"]["Ids"][spellID] then
					button:Hide()
					return
				elseif db["Whitelist"]["Enabled"] and not db["Whitelist"]["Ids"][spellID] then
					button:Hide()
					return
				end

				button.spellID = spellID

				local background = button.background or CreateFrame("Frame", nil, button)
				background:SetPoint("CENTER")
				background:SetSize(button:GetSize())
				background:SetFrameLevel(button:GetFrameLevel() - 1)

				button.background = background

				T:Background(background, db, nil, true)

				button.icon:SetTexCoord(0.133,0.867,0.133,0.867)

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
							region:SetFont(media:Fetch("font", "Default"), 8, "OUTLINE")
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

			debuffs.disableCooldown = true
			debuffs.CustomFilter = function(element, unit, button, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID)
				if db["Blacklist"]["Enabled"] then
					return not db["Blacklist"]["Ids"][spellID] and caster == "player"
				elseif db["Whitelist"]["Enabled"] then
					return db["Whitelist"]["Ids"][spellID]
				end
			end

			debuffs.SetPosition = function(element, from, to)
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

			debuffs.PostUpdateIcon = function(element, unit, button, index)
				local name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID = UnitAura(unit, index, "HARMFUL")
				if button.bar then

					if db["Blacklist"]["Enabled"] and db["Blacklist"]["Ids"][spellID] then
						button:Hide()
						return
					elseif db["Whitelist"]["Enabled"] and not db["Whitelist"]["Ids"][spellID] then
						button:Hide()
						return
					end

					if caster ~= "player" then
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
						local timeLeft = (expiration or 0) - GetTime()
						button.bar:SetMinMaxValues(0, duration or 1)
						button.bar:SetValue(timeLeft < 0 and 1 or timeLeft)
						button.bar.time:SetText(timeLeft < 0 and "" or T:timeString(timeLeft))
					end

					if not button.initCount then
						button.initCount = true
						button.count:Hide()
						button.count = buildText(button, 11):outline():atCenter():build()
						button.count:Show()
						button.count:SetJustifyH("CENTER")
					end

					button.count:SetText((count or 0) > 1 and count or "")
					button:Show()
				end
			end
		end)

	frame.Debuffs = debuffs
end

--A["Elements"]:add({ name = "Debuffs", func = Debuffs })