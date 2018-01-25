local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetShapeshiftFormID = GetShapeshiftFormID
local UnitClass = UnitClass
local UnitPowerMax = UnitPowerMax

local INVALID_POWER = true
local VALID_POWER = false

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
			return spec == 2 and form == 1
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

local runeColors = {
	[1] = { .67, .13, .13 },
	[2] = { 0, .67, .99 },
	[3] = { 0.33, .67, .33 }
}

local function getPowerMax()
	local p
	if powerType[class] then
		p = UnitPowerMax("player", powerType[class].powerType)
	end
	return p
end

local function getPowerCurrent()
	local p
	if powerType[class] then
		p = UnitPower("player", powerType[class].powerType)
	end
	return p
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

local function createIcon(parent, index)
	local icon = CreateFrame("StatusBar", T:frameName("ClassIcons", index), parent)

	icon:SetStatusBarTexture(media:Fetch("statusbar", "Default2"))
	icon:SetSize(parent.iconW, parent.iconH)

	icon.bg = icon:CreateTexture(nil, "BORDER")
	icon.bg:SetTexture(media:Fetch("statusbar", "Default2"))
	icon.bg:SetAllPoints()

	local db = parent.db
	local offset = db["Background"]["Offset"]

	if db["Background"] and db["Background"]["Enabled"] then 
		icon:SetBackdrop({
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
		icon:SetBackdropColor(unpack(db["Background"]["Color"]))
	else
		icon:SetBackdrop(nil)
	end

	return icon
end

local function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0
		local iter = function ()
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
		end
	end
	return iter
end

local function tfirst(t)
	for k,v in pairsByKeys(t) do
		return k
	end
end

local function tfirstValue(t)
	return #t > 1 and t[1] or nil
end

local function OrderRunes(parent)
	local readyRunes, notReadyRunes = {}, {}
	local frame = parent:GetParent()

	local anchor = frame
	for i = 1, parent.max do
		local icon = parent.icons[i]
		local start,_,runeReady = GetRuneCooldown(i)
		if runeReady then
			table.insert(readyRunes, i)
		else
			if notReadyRunes[start] then
				notReadyRunes[start+1] = i
			else
				notReadyRunes[start] = i
			end
		end
		icon:ClearAllPoints()
	end

	for i, realIndex in pairs(readyRunes) do
		local icon = parent.icons[realIndex]
		icon:SetPoint(i == 1 and "TOPLEFT" or "LEFT", i == 1 and frame or parent.icons[readyRunes[i-1]], i == 1 and "BOTTOMLEFT" or "RIGHT", i == 1 and 0 or 1, i == 1 and -1 or 0)
	end

	local oldIndex = parent.realIndex

	local first = tfirst(notReadyRunes)
	local prev = first
	for i, realIndex in pairsByKeys(notReadyRunes) do
		local icon = parent.icons[realIndex]
		if i == first then
			parent.realIndex = realIndex
		end
		if #readyRunes > 0 then
			icon:SetPoint("LEFT", i == first and parent.icons[readyRunes[#readyRunes]] or parent.icons[notReadyRunes[prev]], "RIGHT", 1, 0)
		else
			icon:SetPoint(i == first and "TOPLEFT" or "LEFT", i == first and frame or parent.icons[notReadyRunes[prev]], i == first and "BOTTOMLEFT" or "RIGHT", i == first and 0 or 1, i == first and -1 or 0)
		end
		prev = i
	end

	if #readyRunes > 0 then
		parent.realIndex = tfirstValue(readyRunes)
	end

	if parent.realIndex ~= oldIndex then
		frame.__castbarAnchor = parent.icons[parent.realIndex or 1]
		Units:PlaceCastbar(frame, VALID_POWER)
	end
end

local function UpdateIcons(parent, current, max, maxChanged)

	local power = parent.power

	if not power.isValid(GetSpecialization(), GetShapeshiftFormID()) then
		for i = 1, parent.max do
			local icon = parent.icons[i]
			if icon then
				icon:Hide()
			end
		end
		return
	end

	if not parent.initiated then

		-- Create icons according to max count value
		local frame = parent:GetParent()
		local anchor = frame
		for i = 1, max do
			local icon = parent.icons[i] or createIcon(parent, i)
			if not power.isRunes then
				icon:SetPoint(anchor == frame and "TOPLEFT" or "LEFT", anchor, anchor == frame and "BOTTOMLEFT" or "RIGHT", i == 1 and 0 or 1, anchor == frame and -1 or 0)
			end
			parent.icons[i] = icon
			anchor = icon
		end

		parent.initiated = true
	end

	-- Order runes in order of availability
	if power.isRunes then
		OrderRunes(parent)
	end

	if maxChanged then

		-- Add or remove the extra icon
		local oldMax = parent.max
		if oldMax > max then
			for i = 1, oldMax do
				local icon = parent.icons[i]
				if i > max then
					icon:Hide()
					parent.icons[i] = nil
				end
			end
		elseif oldMax < max then
			for i = 1, max do
				local icon = parent.icons[i]
				if i > oldMax then
					local icon = parent.icons[i] or createIcon(parent, i)
					icon:SetPoint("LEFT", parent.icons[i-1], "RIGHT", 1, 0)
					parent.icons[i] = icon
				end
			end
		end

		parent.max = max
		parent:calculateSize()
	end

	for i = 1, max do
		local icon, r, g, b = parent.icons[i]
		if power.isRunes then
			local start, duration, runeReady = GetRuneCooldown(i)
			local minValue, maxValue = icon:GetMinMaxValues()
			if not runeReady and start and start ~= 0 then
				if min ~= 0 or maxValue ~= duration then
					icon:SetMinMaxValues(0, duration)
				end
				icon:SetValue(GetTime() - start)
			else
				icon:SetValue(duration)
			end

			-- Update color values
			r, g, b = unpack(runeColors[GetSpecialization()])
		else
			local mod = UnitPowerDisplayMod(power.powerType)

			-- Update min/max values
			if mod > 1 then
				current = UnitPower("player", power.powerType, true)
				icon:SetMinMaxValues(0, mod)

				if current >= ((i - 1) * mod) then
					if current < ((i - 1) * mod) + mod then
						icon:SetValue(current - (mod * (i - 1)))
					else
						icon:SetValue(mod)
					end
				else
					icon:SetValue(0)
				end
			else
				icon:SetMinMaxValues(0, 1)

				if current >= i then
					icon:SetValue(1)
				else
					icon:SetValue(0)
				end
			end

			-- Update color values
			if A.colors.power[power.powerType] then
				r, g, b = unpack(A.colors.power[power.powerType])
			else
				r, g, b = unpack(oUF.colors.power[power.powerType])
			end
		end
		icon:SetStatusBarColor(r, g, b)
		icon.bg:SetVertexColor(r * .33, g * .33, b * .33)
		icon:Show()
	end
end

local function ClassIcons(frame, db)

	local size = db["Size"]
	local spec, form = GetSpecialization(), GetShapeshiftFormID()
	local power = powerType[class]

	if not power or (power and not power.isValid(spec, form)) then
		if frame.Stagger and spec == 1 then
			Units:PlaceCastbar(frame, nil, true)
		else
			Units:PlaceCastbar(frame, INVALID_POWER)
		end
		return 
	end

	local bar = frame.ClassIcons or (function()
		local bar = CreateFrame("Frame", nil, frame)
		bar.icons = {}
		bar.max = getPowerMax()
		bar.isRunes = power and power.isRunes or nil
		bar.power = power
		bar.db = db

		bar.calculateSize = function(self)

			self.iconW = ((size["Match width"] and frame:GetWidth() or size["Width"]) / self.max) - 1
			self.iconH = (size["Match height"] and frame:GetHeight() or size["Height"]) - 2
			
			for i = 1, self.max do
				local icon = self.icons[i]
				if icon then
					icon:SetSize(self.iconW + (self.max == i and 1 or 0), self.iconH)
				end
			end
		end

		bar:calculateSize()

		bar.OverrideVisibility = function(...)

			spec = GetSpecialization()
			form = GetShapeshiftFormID()

			power = powerType[class]
			bar.power = power

			bar:calculateSize()

			--A:Debug("power valid:", power.isValid(spec, form))

			if power and power.isValid(spec, form) then

				bar.power = power

				local max = getPowerMax()
				UpdateIcons(bar, getPowerCurrent(), max, max ~= bar.max)

				bar.Override = function(self, event, unit)
					Update(self, event, unit, power.powerType, function(f, c, m)
						f.isRunes = power.isRunes
						UpdateIcons(f, c, m, f.max ~= m)
					end)
				end
				if power.isRunes then
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
					bar:RegisterEvent('UNIT_POWER_FREQUENT')
					bar:RegisterEvent('UNIT_MAXPOWER')
				end
			else
				bar:UnregisterEvent('UNIT_POWER_FREQUENT')
				bar:UnregisterEvent('UNIT_MAXPOWER')

				for i = 1, bar.max do
					local icon = bar.icons[i]
					if icon then
						icon:Hide()
					end
				end
			end
		end

		local current = getPowerCurrent()
		if current then
			local max = getPowerMax()
			if power then
				bar.power = power
				UpdateIcons(bar, current, max, max ~= bar.max)
			end
		end

		local barW = size["Match width"] and frame:GetWidth() or size["Width"]
		local barH = size["Match height"] and frame:GetWidth() or size["Height"]

		return bar
	end)()

	bar:calculateSize()

	bar:RegisterEvent('SPELLS_CHANGED')
	bar:RegisterEvent('UNIT_DISPLAYPOWER')
	bar:RegisterEvent('PLAYER_TALENT_UPDATE')
	bar:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
	bar:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
	bar:RegisterEvent('PLAYER_ENTERING_WORLD')

	bar:SetScript("OnEvent", function(self, event, unit)
		if event == "UNIT_POWER_FREQUENT" or event == "UNIT_MAXPOWER" then
			self:Override(self, event, unit)
		else
			self:OverrideVisibility(self, event, unit)
		end
	end)

	if power then
		bar.isRunes = power.isRunes
	end

	if not power or not power.isValid(spec) then
		for i = 1, 10 do
			if bar.icons[i] then
				bar.icons[i]:Hide()
			end
		end
	end

	if db["Background"] and db["Background"]["Enabled"] then
		local offset = db["Background"]["Offset"]
		for i = 1, bar.max do
			local icon = bar.icons[i]
			if icon then
				icon:SetBackdrop({
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
				icon:SetBackdropColor(unpack(db["Background"]["Color"]))
			end
		end
	else
		for i = 1, bar.max do
			local icon = bar.icons[i]
			if icon then
				icon:SetBackdrop(nil)
			end
		end
	end

	if power and power.isValid(spec, form) then
		frame.__castbarAnchor = bar.icons[bar.realIndex or 1]
		Units:PlaceCastbar(frame, VALID_POWER)
	end

	frame.ClassIcons = bar
end

A["Elements"]:add({ name = "ClassIcons", func = ClassIcons })