local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local CreatePoolCollection = CreatePoolCollection

--[[ Lua ]]
local tremove = table.remove
local sort = table.sort

--[[ Locals ]]
local E = A.enum
local T = A.Tools
local Units = A.Units
local media = LibStub("LibSharedMedia-3.0")

local elementName = "Buffs"
local Buffs = {}
local buildText = A.TextBuilder

local function orderBuffs(auras, db, unit)
	for i = 1, #auras do
		local aura = auras[i]
		
		if (aura) then
			if (db["Own only"] and aura.caster ~= unit) then
				tremove(auras, i)
			end
			
			if (db["Hide no duration"] and (not aura.duration or aura.duration <= 0) then
				tremove(auras, i)
			end
		end
	end

	sort(auras, function(left, right) return left.expires < right.expires end)
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

	if (event == UnitEvent.UPDATE_DB) then

		if (db["Attached"]) then
			Units:Attach(self, self.db)
		else
			A:CreateMover(self, db["Position"], self:GetName())
		end

		orderBuffs(parent.buffs, self.db, parent.unit)

		local iconRow = 1
		local relative = self
		for i = 1, db["Limit"] do

			local aura = parent.buffs[i]
			local button = self.buttons[i]

			local barGrowth = db["Bar Growth"]
			local iconGrowth = db["Icon Growth"]
			local x, y = db["Offset X"], db["Offset Y"]
			local iconLimit = ["Icon Limit Per Row"]

			if (db["Style"] == "Bar") then
				button.Cooldown:Hide()
				button.Bar:Show()
				button.BarBackground:Show()
				button.Name:Show()
				button.Time:Show()

				button:SetSize(parent:GetWidth(), height)

				button:ClearAllPoints()
				if (barGrowth == "Upwards") then
					if (relative == self) then
						button:SetPoint("BOTTOM", relative, "BOTTOM", 0, 0)
					else
						button:SetPoint("BOTTOM", relative, "TOP", x, y)
					end
				else
					if (relative == self) then
						button:SetPoint("TOP", relative, "TOP", 0, 0)
					else
						button:SetPoint("TOP", relative, "BOTTOM", x, y)
					end
				end
			else
				button.Cooldown:Show()
				button.Bar:Hide()
				button.BarBackground:Hide()
				button.Name:Hide()
				button.Time:Hide()

				button:SetSize(height, height)

				local atLimit = iconLimit == ((i * iconRow) + 1)
				if (iconGrowth == "Right Then Down") then
					if (atLimit) then
						button:SetPoint("TOP", self.buttons[i - iconLimit], "BOTTOM", 0, -y)
					else
						button:SetPoint("LEFT", relative, relative == self and "LEFT" or "RIGHT", x, 0)
					end
				elseif (iconGrowth == "Right Then Up") then
					if (atLimit) then
						button:SetPoint("TOP", self.buttons[i - iconLimit], "BOTTOM", 0, y)
					else
						button:SetPoint("LEFT", relative, relative == self and "LEFT" or "RIGHT", x, 0)
					end
				elseif (iconGrowth == "Left Then Down") then
					if (atLimit) then
						button:SetPoint("TOP", self.buttons[i - iconLimit], "BOTTOM", 0, -y)
					else
						button:SetPoint("RIGHT", relative, relative == self and "RIGHT" or "LEFT", -x, 0)
					end
				elseif (iconGrowth == "Left Then Up") then
					if (atLimit) then
						button:SetPoint("TOP", self.buttons[i - iconLimit], "BOTTOM", 0, y)
					else
						button:SetPoint("RIGHT", relative, relative == self and "RIGHT" or "LEFT", -x, 0)
					end
				end
			end

			relative = button
		end

	elseif (T:anyOf(event, "UNIT_AURA", UnitEvent.UPDATE_BUFFS)) then
		if (event == "UNIT_AURA" and parent.unit ~= arg1) then return end

		parent:Update(UnitEvent.UPDATE_BUFFS)

		local size = db["Size"]
		local width, height = size["Width"], size["Height"]
		local mult = db["Background Multiplier"]
		local texture = media:Fetch("statusbar", db["Texture"])

		orderBuffs(parent.buffs, self.db, parent.unit)

		for i = 1, db["Limit"] do

			local aura = parent.buffs[i]
			local button = self.buttons[i]

			if (not button) then
				button = self.pool:Acquire("AuraIconBarTemplate")
				
				button.Icon:ClearAllPoints()
				button.Icon:SetPoint("LEFT")
				button.Icon:SetSize(height, height)

				local text = button.Cooldown:GetRegions()
				text:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")

				button.Bar:ClearAllPoints()
				button.Bar:SetSize(parent:GetWidth() - height, height)
				button.Bar:SetPoint("LEFT", button.Icon, "RIGHT", 0, 0)
				button.Bar:SetStatusBarTexture(texture)
				
				button.BarBackground:SetTexture(texture)

				button.Name:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
				button.Time:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")

				self.buttons[i] = button
			end

			button.aura = aura
	
			local expires = aura.expires - GetTime()

			button.Bar:SetMinMaxValues(0, expires)
			button.Bar:SetValue(expires)

			button.Icon:SetTexture(aura.icon)
			button.Name:SetText(aura.name)

			button:SetScript("OnUpdate", function(self, elapsed)
				if (not self:IsShown()) then return end

				local time = GetTime()
				local value = self.aura.expires - time

				if (value <= 0) then
					self:Hide()
					button:SetScript("OnUpdate", nil)
				end

				self.Time:SetText(T:timeShort(value))
				self.Bar:SetValue(value)
			end)

			CooldownFrame_Set(button.Cooldown, GetTime(), expires, true)

			-- Create background here...

			A:ColorBar(button.Bar, parent, 0, expires, A.noop)

			button:Show()			
		end
	end
end

A["Shared Elements"]:set(elementName, Buffs)