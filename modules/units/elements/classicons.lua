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
	local iconW = (size["Match width"] and frame:GetWidth() or size["Width"]) / iconCount
	local iconH = (size["Match height"] and frame:GetHeight() or size["Height"])

	if bar.iconCount == iconCount then

		for i = 1, bar.iconCount do
			local icon = bar.icons[i]
			if isRunes then
				local start, duration, runeReady = GetRuneCooldown(1) -- FIX THIS
				icon:SetValue()
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
			bar.icons[i] = CreateFrame("StatusBar", "ClassPower"..i, frame)
			bar.icons[i]:SetPoint("TOPLEFT", anchor, anchor == frame and "BOTTOMLEFT" or "TOPLEFT", iconW * (i - 1), 0)
			bar.icons[i]:SetStatusBarTexture(media:Fetch("statusbar", "Default2"))
			bar.icons[i]:SetSize(iconW, iconH)

			if isRunes then
				local start, duration, runeReady = GetRuneCooldown(1)
				bar.icons[i]:SetMinMaxValues(0, duration)
				bar.icons[i]:SetValue(duration)
			else
				bar.icons[i]:SetMinMaxValues(0, 1)
				bar.icons[i]:SetValue(1)
			end

			if i > current then
				bar.icons[i]:Hide()
			end
		end

		bar.iconCount = iconCount

	end
end

local function ClassIcons(frame, db)

	local size = db["Size"]

	local bar = frame.ClassIcons or (function()
		local bar = {
			icons = {},
			bar = CreateFrame("StatusBar", nil, frame)
		}

		local barPower = powerTypeForBars[class]

		bar.OverrideVisibility = function(self, event, unit)
			if not unit or unit ~= "player" then return end
			
			local power = powerType[class]
			local spec, form = GetSpecialization(), GetShapeshiftFormID()

			if barPower and barPower.isValid(spec) then
				bar.Override = function(self, event, unit)
					Update(self, event, unit, barPower.powerType, function(f, c, m)
						f.bar:SetMinMaxValues(0, m)
						f.bar:SetValue(c)	
					end)
				end
			elseif power and power.isValid(spec, form) then
				bar.Override = function(self, event, unit)
					Update(self, event, unit, power.powerType, function(f, c, m)
						local pt = powerType[class]
						buildIcons(frame, f, size, m, UnitPower("player", pt.powerType), pt.isRunes)
						for i = 1, m do
							if(i <= c) then
								f.icons[i]:Show()
							else
								f.icons[i]:Hide()
							end
						end
					end)
				end
			end

			frame:RegisterEvent('UPDATE_POWER_RUNE', function(self, event, unit)
				bar:Override(self, event, unit)
			end)
			frame:RegisterEvent('SPELLS_CHANGED', function(self, event, unit)
				bar:OverrideVisibility(self, event, unit)
			end, true)
			frame:RegisterEvent('UNIT_DISPLAYPOWER', function(self, event, unit)
				bar:OverrideVisibility(self, event, unit)
			end)
			frame:RegisterEvent('UNIT_POWER_FREQUENT', function(self, event, unit)
				bar:Override(self, event, unit)
			end)
			frame:RegisterEvent('UNIT_MAXPOWER', function(self, event, unit)
				bar:Override(self, event, unit)
			end)
			frame:RegisterEvent('PLAYER_TALENT_UPDATE', function(self, event, unit)
				bar:OverrideVisibility(self, event, unit)
			end, true)
			frame:RegisterEvent('UPDATE_SHAPESHIFT_FORM', function(self, event, unit)
				bar:OverrideVisibility(self, event, unit)
			end, true)
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

	Units:Position(bar.bar, db["Position"])

	if bar.iconCount ~= getIconCount() then
		local pt = powerType[class]
		buildIcons(frame, bar, size, iconCount, UnitPower("player", pt.powerType), pt.isRunes)
	end

	frame.ClassIcons = bar
end

A["Elements"]["ClassIcons"] = ClassIcons