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

local elementName = "Buffs"
local Buffs = {}
local buildText = A.TextBuilder

local function updateButtons(parent)
	local now = GetTime()
	
	for i = 1, #parent.buttons do
		local button = parent.buttons[i]
		if (button:IsVisible()) then
			local value = button.aura.expires - now
			button.bar.time:SetText(T:timeShort(value))
			button.bar:SetValue(value)
		end
	end
end

local function orderBuffs(auras, db, unit)
	local filteredAuras = {}

	for i = 1, #auras do
		local aura = auras[i]
		if ((not aura.duration or aura.duration <= 0 and not db["Hide no duration"]) or aura.duration > 0) then
			if ((db["Own only"] and aura.caster == unit) or not db["Own only"]) then
				tinsert(filteredAuras, aura)
			end
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
			T:PlaceFrame(button, "Right Of", parent, relative, x, 0)
		else
			T:PlaceFrame(button, "Left Of", parent, relative, -x, 0)
		end
	end
end

local function CreateButton(parent, width, height)
	local button = parent.pool:Acquire("AuraIconBarTemplate")
	
	button.icon:ClearAllPoints()
	button.icon:SetPoint("LEFT")
	button.icon:SetSize(height, height)

	local text = button.cd:GetRegions()
	text:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")

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

	local buffs = parent.orderedElements:get(elementName)
	if (not buffs) then
		
		buffs = CreateFrame("Frame", parent:GetName().."_"..elementName, parent)
		buffs.db = db

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

		buffs:SetScript("OnUpdate", updateButtons)

		BuffFrame:UnregisterEvent("UNIT_AURA")
		BuffFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
		BuffFrame:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")

		BuffFrame:SetParent(A.hiddenFrame)
	end

	buffs:Update(UnitEvent.UPDATE_DB)
	buffs:Update(UnitEvent.UPDATE_BUFFS)

	parent.orderedElements:set(elementName, buffs)
end

function Buffs:Update(...)
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (not db["Enabled"]) then
		self.pools:ReleaseAll()
		return self:Hide()
	else
		self:Show()
	end

	parent:Update(UnitEvent.UPDATE_BUFFS)

	local size = db["Size"]
	local width, height = size["Width"], size["Height"]
	local mult = db["Background Multiplier"]
	local texture = media:Fetch("statusbar", db["Texture"])
	local barGrowth = db["Bar Growth"]
	local iconGrowth = db["Icon Growth"]
	local x, y = db["Offset X"], db["Offset Y"]
	local iconLimit = db["Icon Limit Per Row"]

	self.limit = db["Limit"]

	if (event == UnitEvent.UPDATE_DB) then

		self:SetSize(parent:GetWidth(), height)

		if (db["Attached"]) then
			Units:Attach(self, self.db)
		else
			A:CreateMover(self, db["Position"], self:GetName())
		end

		self:Update(UnitEvent.UPDATE_BUFFS)

	elseif (T:anyOf(event, "UNIT_AURA", UnitEvent.UPDATE_BUFFS)) then
		if (event == "UNIT_AURA" and parent.unit ~= arg1) then return end

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

			button.aura = aura
			local bar = button.bar

			bar:SetMinMaxValues(0, aura.duration)
			bar:SetValue(aura.expires - GetTime())
			bar.db = self.db
			bar.name:SetText(aura.name..((aura.count and aura.count > 1) and " ["..aura.count.."]" or ""))

			button.icon:SetTexture(aura.icon)

			CooldownFrame_Set(button.cd, GetTime(), aura.expires, true)

			if (db["Style"] == "Bar") then
				button.cd:Hide()
				bar:Show()

				bar:SetStatusBarTexture(texture)
				bar.bg:SetTexture(texture)

				button:SetSize(parent:GetWidth(), height)

				placeBar(button, barGrowth, relative, self, x, y)
			else
				button.cd:Show()
				bar:Hide()

				button:SetSize(height, height)

				placeIcon(button, i, iconGrowth, iconLimit, relative, self, x, y)
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

A["Shared Elements"]:set(elementName, Buffs)