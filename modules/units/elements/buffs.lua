local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local buildText = A.TextBuilder

local Buffs = function(frame, db)

	local growth, attached, style, size = db["Growth"], db["Attached"], db["Style"], db["Size"]
	local buffs = frame.Buffs or (function()
		local buffs = CreateFrame("Frame", T:frameName("Buffs"), frame)
		buffs:SetSize(frame:GetWidth(), 300)
		buffs:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 1)
		return buffs
	end)()

	if attached ~= false then
		buffs:SetPoint(T.reversedPoints[attached], frame, attached, 0, 0)
	else
		A:CreateMover(buffs, db, "Buffs")
		Units:Position(buffs, db["Position"])
	end

	T:Switch(style, 
		"Icon", function()
			local width = size["Width"]
			local height = size["Height"]
		end,
		"Bar", function()
			local width = size["Match width"] and frame:GetWidth() or size["Width"]
			local height = size["Match height"] and frame:GetHeight() or size["Height"]

			buffs.disableCooldown = true

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

						local name = buildText(button.bar, 0.7):enforceHeight():shadow():atLeft():x(3):build()
						name:SetJustifyH("LEFT")

						local time = buildText(button.bar, 9):shadow():atRight():x(-5):build()
						time:SetJustifyH("RIGHT")

						button.bar.name = name
						button.bar.time = time
					end

					button.bar:ClearAllPoints()
					button.icon:SetTexCoord(0.133,0.867,0.133,0.867)
					
					local background = CreateFrame("Frame", nil, button)
					background:SetPoint("LEFT")
					background:SetSize(width + sizex, sizey)
					background:SetFrameLevel(button:GetFrameLevel() - 1)

					T:Background(background, db, true)

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

			if not buffs.updateFrame then
				buffs.updateFrame = CreateFrame("Frame")
				buffs.updateFrame.timer = 0
				buffs.updateFrame:SetScript("OnUpdate", function(self, elapsed)
					self.timer = self.timer + elapsed
					if self.timer > 0.03 then
						buffs:ForceUpdate()
						self.timer = 0
					end
				end)
			end

			buffs.PostUpdateIcon = function(element, unit, button, index)
				local name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID = UnitAura(unit, index, "HELPFUL")
				if button.bar then

					if db["Blacklist"][spellID] then
						button:Hide()
						return
					end

					button:Show()

					button.bar.name:SetText(name)
					if duration == 0 then
						button.bar:SetMinMaxValues(0, 1)
						button.bar:SetValue(1)
						button.bar.time:SetText("")
					else
						local timeLeft = expiration - GetTime()
						button.bar:SetMinMaxValues(0, duration)
						button.bar:SetValue(timeLeft)
						button.bar.time:SetText(T:timeString(timeLeft))
					end
				end
			end
		end)

	frame.Buffs = buffs
end

A["Elements"]["Buffs"] = Buffs