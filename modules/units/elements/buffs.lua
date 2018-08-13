local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local CreatePoolCollection = CreatePoolCollection

--[[ Lua ]]
local tremove = table.remove
local tinster = table.insert
local sort = table.sort

--[[ Locals ]]
local E = A.enum
local T = A.Tools
local Units = A.Units
local U = A.Utils
local media = LibStub("LibSharedMedia-3.0")

local elementName = "buffs"
local Buffs = {}
local buildText = A.TextBuilder

local function updateButtons(parent)
	local now = GetTime()
	
	for i = 1, #parent.buttons do
		local button = parent.buttons[i]
		if (button:IsVisible()) then
			local value = button.aura.expires - now

			local time = T:timeShort(value)
			button.bar.time:SetText(time)
			button.bar:SetValue(value)
			button.iconText:SetText(time)
		end
	end
end

local function filterAura(aura, db, unit)
	local duration = aura.duration or 0
	local durationFilter = (duration == 0 and not db.hideNoDuration) or (duration > 0)
	local casterFilter = (db.own and aura.caster == unit) or (not db.own)
	local blackListFilter = db.blacklist.enabled and not db.blacklist.ids[aura.spellID]
	local whiteListFilter = db.whitelist.enabled and db.whitelist.ids[aura.spellID]

	if (not db.blacklist.enabled and not db.whitelist.enabled) then
		whiteListFilter = true
	end

	return durationFilter and casterFilter and (blackListFilter or whiteListFilter)
end

local function orderBuffs(auras, db, unit)
	local filteredAuras = {}

	for i = 1, #auras do
		local aura = auras[i]
		if (filterAura(aura, db, unit)) then
			tinsert(filteredAuras, aura)
		end
	end

	sort(filteredAuras, function(left, right) return left.expires < right.expires end)

	return filteredAuras
end

local function placeBar(button, barGrowth, relative, parent, x, y)
	button:ClearAllPoints()
	if (barGrowth == "Upwards") then
		if (relative == parent) then
			button:SetPoint("BOTTOM", relative, "BOTTOM", 0, 0)
		else
			button:SetPoint("BOTTOM", relative, "TOP", 0, y)
		end
	else
		if (relative == parent) then
			button:SetPoint("TOP", relative, "TOP", 0, 0)
		else
			button:SetPoint("TOP", relative, "BOTTOM", 0, -y)
		end
	end
end

local function placeIcon(button, index, iconGrowth, iconLimit, relative, parent, x, y)
	local atLimit = index % (iconLimit + 1) == 0
	local limitAnchor = parent.buttons[index - iconLimit]

	button:ClearAllPoints()
	if (atLimit) then
		if (iconGrowth:find("Down")) then
			button:SetPoint("TOP", limitAnchor, "BOTTOM", 0, -y)
		else
			button:SetPoint("BOTTOM", limitAnchor, "TOP", 0, y)
		end
	else
		if (iconGrowth:find("Right")) then
			if (iconGrowth:find("Down")) then
				if (relative == parent) then
					button:SetPoint("TOPLEFT", relative, "TOPLEFT", 0, 0)
				else
					button:SetPoint("LEFT", relative, "RIGHT", x, 0)
				end
			else
				if (relative == parent) then
					button:SetPoint("BOTTOMLEFT", relative, "BOTTOMLEFT", 0, 0)
				else
					button:SetPoint("LEFT", relative, "RIGHT", x, 0)
				end
			end
		else
			if (iconGrowth:find("Down")) then
				if (relative == parent) then
					button:SetPoint("TOPRIGHT", relative, "TOPRIGHT", 0, 0)
				else
					button:SetPoint("RIGHT", relative, "LEFT", -x, 0)
				end
			else
				if (relative == parent) then
					button:SetPoint("BOTTOMRIGHT", relative, "BOTTOMRIGHT", 0, 0)
				else
					button:SetPoint("RIGHT", relative, "LEFT", -x, 0)
				end
			end
		end
	end
end

local function CreateButton(parent, width, height)
	local button = parent.pool:Acquire("AuraIconBarTemplate")
	
	if (parent:GetParent().unit == "player") then
		button:RegisterForClicks("AnyUp")
		button:SetScript("OnClick", function(self, b, down)
			if (not down and b == "MiddleButton") then
				CancelUnitBuff(parent:GetParent().unit, button.aura.index)
			end
		end)
	end

	button.icon:ClearAllPoints()
	button.icon:SetPoint("LEFT")
	button.icon:SetSize(height, height)

	button.iconText:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
	button.iconText:SetPoint("CENTER")

	local bar = button.bar
	bar:ClearAllPoints()
	bar:SetSize(parent:GetWidth() - height, height)
	bar:SetPoint("LEFT", button.icon, "RIGHT", 0, 0)
	bar.name:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
	bar.time:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")

	return button
end

function Buffs:Init(parent)

	local db = parent.db[elementName]

	if (not db) then return end

	local buffs = parent.orderedElements[elementName]
	if (not buffs) then
		
		buffs = CreateFrame("Frame", parent:GetName().."_"..elementName, parent)
		buffs.db = db
		buffs.noTags = true

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

		buffs:SetScript("OnUpdate", updateButtons)

		BuffFrame:UnregisterEvent("UNIT_AURA")
		BuffFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
		BuffFrame:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")

		BuffFrame:SetParent(A.hiddenFrame)
	end

	buffs:Update(UnitEvent.UPDATE_DB)

	parent.orderedElements[elementName] = buffs
end

function Buffs:Update(...)
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (not db.enabled) then
		self.pools:ReleaseAll()
		return self:Hide()
	else
		self:Show()
	end

	local width = db.size.matchWidth and parent:GetWidth() or db.size.width
	local height = db.size.matchHeight and parent:GetHeight() or db.size.height
	local texture = media:Fetch("statusbar", db.texture)
	local font = media:Fetch("font", "Default")

	self.limit = db.limit

	if (event == UnitEvent.UPDATE_DB) then

		if (db.style == "Bar") then
			self:SetSize(width, height * self.limit)
		else
			self:SetSize(height * db.iconLimit, height * 40 / db.iconLimit)
		end

		if (db.attached) then
			Units:Attach(self, self.db)
		else
			self.getMoverSize = function(self)
				return self:GetSize()
			end

			A:CreateMover(self, db, self:GetName())
			Units:Position(self, db.position)
		end

		self:Update(UnitEvent.UPDATE_BUFFS)

	elseif (T:anyOf(event, "UNIT_AURA", UnitEvent.UPDATE_BUFFS, "UpdateColors")) then
		if (event == "UNIT_AURA" and parent.unit ~= arg1) then return end

		parent:Update(UnitEvent.UPDATE_BUFFS)

		parent.buffs = orderBuffs(parent.buffs, self.db, parent.unit)

		local relative = self
		local last = 0

		for i = 1, #parent.buffs do
			if (i > self.limit) then
				tremove(parent.buffs, i)
			else
				last = i
			end
		end

		for i = 1, last do

			local aura = parent.buffs[i]
			local button = self.buttons[i]

			if (not button) then
				self.buttons[i] = CreateButton(self, width, height)
				button = self.buttons[i]
			end

			local hasCount = aura.count and aura.count > 1

			button.aura = aura
			local bar = button.bar

			bar:SetMinMaxValues(0, aura.duration)
			bar:SetValue(aura.expires - GetTime())
			bar.db = self.db
			bar.name:SetFormattedText("%s %s", aura.name, hasCount and "["..aura.count.."]" or "")

			local textRatio = bar.name:GetWidth() / bar:GetWidth()
			local sub = aura.name:len()
			local text = aura.name
			if (bar.name:GetWidth() > bar:GetWidth() or textRatio > 0.55) then
				while (textRatio > 0.55) do
					bar.name:SetText(aura.name:sub(1, sub))
					textRatio = bar.name:GetWidth() / bar:GetWidth()
					sub = sub - 1
				end
				bar.name:SetFormattedText("%s...%s", bar.name:GetText(), hasCount and " ["..aura.count.."]" or "")
			end

			button.icon:SetTexture(aura.icon)

			if (db.style == "Bar") then
				button.iconText:Hide()
				button.iconCount:Hide()
				bar:Show()

				bar:SetStatusBarTexture(texture)
				bar.bg:SetTexture(texture)
				bar.name:SetFont(font, db.name.size, "OUTLINE")
				bar.time:SetFont(font, db.time.size, "OUTLINE")

				button:SetSize(parent:GetWidth(), height)

				placeBar(button, db.barGrowth, relative, self, db.spacingX, db.spacingY)
			else
				button.iconText:Show()
				button.iconCount:Show()
				bar:Hide()

				button:SetSize(height, height)
				button.icon:SetSize(height, height)
				button.iconText:SetFont(font, db.iconTextSize, "OUTLINE")
				button.iconCount:SetFont(font, 10, "OUTLINE")
				button.iconCount:SetText(hasCount and aura.count or "")

				placeIcon(button, i, db.iconGrowth, db.iconLimit, relative, self, db.spacingX, db.spacingY)
			end

			U:CreateBackground(button, db, false)

			A:ColorBar(bar, parent, 0, duration, A.noop)
			button:Show()

			relative = button
		end

		for i = last + 1, #self.buttons do
			self.buttons[i]:Hide()
		end
	end
end

A.elements.shared[elementName] = Buffs