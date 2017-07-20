local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local GetShapeshiftFormID = GetShapeshiftFormID
local UnitClass = UnitClass
local UnitPowerMax = UnitPowerMax

local _,class = UnitClass("player")

local powerType = {
	["ROGUE"] = {
		isValid = function()
			return true
		end,
		powerType = SPELL_POWER_COMBO_POINTS
	},
	["DEATHKNIGHT"] = {
		isValid = function()
			return true
		end,
		powerType = SPELL_POWER_RUNES,
		isRunes = true
	},
	["MAGE"] = {
		isValid = function(spec)
			return spec == SPEC_MAGE_ARCANE
		end,
		powerType = SPELL_POWER_ARCANE_CHARGES
	},
	["DRUID"] = {
		isValid = function(spec, form)
			return spec == SPEC_DRUID_FERAL and form == 1
		end,
		powerType = SPELL_POWER_COMBO_POINTS
	},
	["PALADIN"] = {
		isValid = function(spec)
			return spec == SPEC_PALADIN_RETRIBUTION
		end,
		powerType = SPELL_POWER_HOLY_POWER
	},
	["WARLOCK"] = {
		isValid = function()
			return true
		end,
		powerType = SPELL_POWER_SOUL_SHARDS
	},
	["MONK"] = {
		isValid = function(spec)
			return spec == SPEC_MONK_WINDWALKER
		end,
		powerType = SPELL_POWER_CHI
	}
}

local powerTypeForBars = {
	["SHAMAN"] = {
		isValid = function(spec) 
			return spec == SPEC_SHAMAN_ELEMENTAL or spec == SPEC_SHAMAN_ENHANCEMENT
		end,
		powerType = SPELL_POWER_MAELSTROM,
	},
	["PRIEST"] = {
		isValid = function(spec)
			return spec == SPEC_PRIEST_SHADOW
		end,
		powerType = SPELL_POWER_INSANITY
	},
	["DRUID"] = {
		isValid = function(spec)
			return spec == SPEC_DRUID_BALANCE
		end,
		powerType = SPELL_POWER_LUNAR_POWER
	}
}

local runes = {
	[1] = 1,
	[2] = 2,
	[3] = 5,
	[4] = 6,
	[5] = 3,
	[6] = 4
}

local runeColors = {
	[250] = { .67, .13, .13 },
	[251] = { 0, .67, .99 },
	[252] = { 0.33, .67, .33 }
}

local function getBarMax()
	return UnitPowerMax("player", powerTypeForBars[class].powerType)
end

local function getIconCount()
	return UnitPowerMax("player", powerType[class].powerType)
end

local function Update(bar, event, unit, powerType, func)
	if(unit == 'vehicle') then
		return
	end

	local cur, max
	if(event ~= 'ClassPowerDisable') then
		if(unit == 'vehicle') then
			-- XXX: UnitPower is bugged for vehicles, always returns 0 combo points
			cur = GetComboPoints(unit)
			max = MAX_COMBO_POINTS
		else
			cur = UnitPower('player', powerType)
			max = UnitPowerMax('player', powerType)
		end
	end
	func(bar, cur, max)
end

local function buildIcons(frame, bar, size, iconCount, current, isRunes)
	local iconW = ((size["Match width"] and frame:GetWidth() or size["Width"]) / iconCount) - 2
	local iconH = (size["Match height"] and frame:GetHeight() or size["Height"]) - 2

	if bar.iconCount == iconCount then

		for i = 1, bar.iconCount do
			local icon = bar.icons[i]
			if isRunes then
				local start, duration, runeReady = GetRuneCooldown(i)
				if not runeReady and start and start ~= 0 then
					icon:SetMinMaxValues(0, duration)
					icon:SetValue(GetTime() - start)
				else
					icon:SetValue(duration)
				end

				local power = powerType[class]
				local r, g, b = unpack(oUF.colors.power[power.powerType])

				local spec = GetSpecializationInfo(GetSpecialization())
				if runeColors[spec] then
					r, g, b = unpack(runeColors[spec])
				end

				icon:SetStatusBarColor(r, g, b)
				icon.bg:SetVertexColor(r * .33, g * .33, b * .33)
			else
				print("bla")
				icon:oldShow()
				if i > current then
					icon:Hide()
				else
					icon:Show()
				end
			end
		end

	else

		for i = 1, 10 do
			if bar.icons[i] then
				bar.icons[i]:Hide()
			end
		end

		bar.icons = {}

		local anchor = frame
		for i = 1, getIconCount() do

			local icon = CreateFrame("StatusBar", "ClassPower"..i, frame)
			
			icon:SetPoint(anchor == frame and "TOPLEFT" or "LEFT", anchor, anchor == frame and "BOTTOMLEFT" or "RIGHT", anchor == frame and 1 or 2, anchor == frame and -1 or 0)
			icon:SetStatusBarTexture(media:Fetch("statusbar", "Default2"))
			icon:SetSize(iconW, iconH)

			icon.bg = icon:CreateTexture(nil, "BORDER")
			icon.bg:SetTexture(media:Fetch("statusbar", "Default2"))
			icon.bg:SetAllPoints()

			local power = powerType[class]
			local r, g, b = unpack(oUF.colors.power[power.powerType])

			local spec = GetSpecializationInfo(GetSpecialization())
			if runeColors[spec] then
				r, g, b = unpack(runeColors[spec])
			end

			icon:SetStatusBarColor(r, g, b)
			icon.bg:SetVertexColor(r * .33, g * .33, b * .33)

			if isRunes then
				local start, duration, runeReady = GetRuneCooldown(runes[i])
				icon:SetMinMaxValues(0, duration)
				icon:SetValue(duration)
			else
				icon:SetMinMaxValues(0, 1)
				icon:SetValue(1)
				icon.oldHide = icon.Hide
				icon.oldShow = icon.Show
				icon.Hide = function(self)
					self:SetValue(0)
				end
				icon.Show = function(self)
					self:SetValue(1)
				end
			end

			if i > current then
				icon:Hide()
			end

			anchor = icon

			bar.icons[i] = icon
		end

		bar.iconCount = iconCount

	end
end

local function ClassIcons(frame, db)

	local size = db["Size"]
	local spec, form = GetSpecialization(), GetShapeshiftFormID()

	local bar = frame.ClassIcons or (function()
		local bar = CreateFrame("Frame")
		bar.icons = {}
		bar.bar = CreateFrame("StatusBar", "BarBar", frame)

		local barPower = powerTypeForBars[class]
		local pt = powerType[class]

		bar.OverrideVisibility = function(...)
			local power = powerType[class]
			spec = GetSpecialization()
			form = GetShapeshiftFormID()

			if barPower or power then

				if barPower and barPower.isValid(spec) then

					bar.bar:Show()

					bar.Override = function(self, event, unit)
						Update(self, event, unit, barPower.powerType, function(f, c, m)
							f.bar:SetMinMaxValues(0, m)
							f.bar:SetValue(c)	
						end)
					end

				elseif power and power.isValid(spec, form) then
					print(spec)
					print("Should show")

					buildIcons(frame, bar, size, UnitPowerMax("player", pt.powerType), UnitPower("player", pt.powerType), pt.isRunes)

					bar.Override = function(self, event, unit)
						Update(self, event, unit, power.powerType, function(f, c, m)
							print(self, event, unit)
							buildIcons(frame, f, size, m, UnitPower("player", pt.powerType), pt.isRunes)
							for i = 1, m do
								if(i <= c) then
									if f.icons[i].oldShow then
										f.icons[i]:oldShow()
									else
										f.icons[i]:Show()
									end
								else
									f.icons[i]:Hide()
								end
							end
						end)
					end
					if pt.isRunes then
						bar.timer = 0
						bar:SetScript("OnUpdate", function(self, elapsed)
							self.timer = self.timer + elapsed
							if self.timer > 0.03 then
								self:Override(event, unit)
								self.timer = 0
							end
						end)
					else
						bar:SetScript("OnUpdate", nil)
						frame:RegisterEvent('UNIT_POWER_FREQUENT', function(self, event, unit)
							bar:Override(self, event, unit)
						end)
						frame:RegisterEvent('UNIT_MAXPOWER', function(self, event, unit)
							bar:Override(self, event, unit)
						end)
					end
				else
					print(spec)
					print("Should hide")
					for i = 1, getIconCount() do
						local icon = bar.icons[i]
						if icon then
							if icon.oldHide then icon:oldHide() end
							icon:Hide()
						end
					end
					bar.bar:Hide()
				end
			else
				for i = 1, getIconCount() do
					bar.icons[i]:oldHide()
				end
				bar.bar:Hide()
			end
		end

		local iconCount = getIconCount()
		if iconCount then
			buildIcons(frame, bar, size, iconCount, UnitPower("player", powerType[class].powerType))
		end

		local barW = size["Match width"] and frame:GetWidth() or size["Width"]
		local barH = size["Match height"] and frame:GetWidth() or size["Height"]
		
		bar.bar:SetSize(barW, barH)

		return bar
	end)()

	frame:RegisterEvent('SPELLS_CHANGED', function(self, event, unit)
		bar:OverrideVisibility(self, event, unit)
	end, true)
	frame:RegisterEvent('UNIT_DISPLAYPOWER', function(self, event, unit)
		bar:OverrideVisibility(self, event, unit)
	end, true)
	frame:RegisterEvent('PLAYER_TALENT_UPDATE', function(self, event, unit)
		bar:OverrideVisibility(self, event, unit)
	end, true)
	frame:RegisterEvent('UPDATE_SHAPESHIFT_FORM', function(self, event, unit)
		bar:OverrideVisibility(self, event, unit)
	end, true)
	frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', function(self, event, unit)
		bar:OverrideVisibility(self, event, unit)
	end, true)
	frame:RegisterEvent('PLAYER_ENTERING_WORLD', function(self, event, unit)
		bar:OverrideVisibility(self, event, unit)
	end, true)

	Units:Position(bar.bar, db["Position"])

	if bar.iconCount ~= getIconCount() then
		local pt = powerType[class]
		buildIcons(frame, bar, size, iconCount, UnitPower("player", pt.powerType), pt.isRunes)
	end

	local barPower = powerTypeForBars[class]
	local power = powerType[class]

	if (not barPower or not barPower.isValid(spec)) and (not power or not power.isValid(spec)) then
		for i = 1, 10 do
			if bar.icons[i] then
				bar.icons[i]:oldHide()
				bar.icons[i]:Hide()
			end
		end
		bar.bar:Hide()
	end

	if db["Background"] and db["Background"]["Enabled"] then
		local offset = db["Background"]["Offset"]
		bar.bar:SetBackdrop({
			bgFile = media:Fetch("statusbar", "Default"),
			tile = true,
			tileSize = 16,
			insets = {
				top = offset["Top"],
				bottom = offset["Bottom"],
				left = offset["Left"],
				right = offset["Right"],
			}
		})
		bar.bar:SetBackdropColor(unpack(db["Background"]["Color"]))
		for i = 1, bar.iconCount do
			bar.icons[i]:SetBackdrop({
				bgFile = media:Fetch("statusbar", "Default"),
				tile = true,
				tileSize = 16,
				insets = {
					top = offset["Top"],
					bottom = offset["Bottom"],
					left = offset["Left"],
					right = offset["Right"],
				}
			})
			bar.icons[i]:SetBackdropColor(unpack(db["Background"]["Color"]))
		end
	else
		bar.bar:SetBackdrop(nil)
		for i = 1, bar.iconCount do
			bar.icons[i]:SetBackdrop(nil)
		end
	end

	frame.ClassIcons = bar
end

A["Elements"]["ClassIcons"] = ClassIcons