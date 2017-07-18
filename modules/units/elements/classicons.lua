local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local CreateFrame = CreateFrame

-- Fix insanity, DK runes, maelstrom, lunar/astral power
local powerType = {
	["ROGUE"] = SPELL_POWER_COMBO_POINTS,
	["DEATHKNIGHT"] = SPELL_POWER_RUNES,
	["MAGE"] = SPELL_POWER_ARCANE_CHARGES,
	["DRUID"] = SPELL_POWER_LUNAR_POWER,
	["PALADIN"] = SPELL_POWER_HOLY_POWER,
	["WARLOCK"] = SPELL_POWER_SOUL_SHARDS
}

local powerTypeForBars = {
	["SHAMAN"] = SPELL_POWER_MAELSTROM,
	["PRIEST"] = SPELL_POWER_INSANITY,
	["DRUID"] = SPELL_POWER_LUNAR_POWER
}

local function getBarMax()
	return UnitPowerMax("player", powerTypeForBars[classFileName])
end

local function getIconCount()
	local class, classFileName, classIndex = UnitClass("player")
	return UnitPowerMax("player", powerType[classFileName])
end

local function ClassIcons(frame, db)

	local bar = frame.ClassIcons or (function()
		local bar = {}
		for i = 1, getIconCount() do
			bar[i] = CreateFrame("StatusBar", nil, frame)
			bar[i]:SetPoint("LEFT", bar[i-1] or frame, "LEFT", 0, 0)
			bar[i]:SetMinMaxValues(0, 1)
			bar[i]:HookScript("OnShow", function(self)
				self:SetValue(1)
			end)
			bar[i]:HookScript("OnHide", function(self)
				self:SetValue(0)
			end)
		end
		return bar
	end)()

end

A["Elements"]["ClassIcons"] = ClassIcons