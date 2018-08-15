local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local Unit

--[[ Lua ]]


--[[ Locals ]]
local elementName = "border"
local Border = {}

function Border:Init(parent)
	
	local db = parent.db[elementName]

	if (not db) then return end

	local border = parent.orderedElements[elementName]
	if (not border) then
		border = CreateFrame("Frame", parent:GetName().."_"..elementName, parent)
		border.db = db
		border.noTags = true
		border.Update = function(self, ...)
			Border:Update(self, ...)
		end

		border:RegisterUnitEvent("UNIT_AURA", parent.unit)
		border:RegisterEvent("PLAYER_TARGET_CHANGED")
		border:RegisterEvent("PLAYER_ENTERING_WORLD")
		border:SetScript("OnEvent", function(self, event, ...)
			self:Update(event, ...)
		end)
	end

	parent.orderedElements[elementName] = border
end

function Border:Update(...)	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (not db.enabled) then
		self:Hide()
		return
	else
		self:Show()
	end

	if (not parent.Background or not parent.db.background.enabled) then
		print("Background is needed to show target highlight and debuff border on ", parent:GetName())
		return
	end

	if (event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD") then
		if (db.highlight) then
			if (parent.unit and UnitIsUnit("target", parent.unit)) then
				parent.Background:SetBackdropBorderColor(T:unpackColor(db.targetColor))
			else
				parent.Background:SetBackdropBorderColor(T:unpackColor(parent.db.background.color))
			end
		end
	elseif (event == "UNIT_AURA") then
		if (db.debuff) then
			if (arg1 ~= parent.unit) then return end

			local debuffTypes = {}
			for i = 1, 40 do
				local debuffType = select(4, UnitDebuff(parent.unit, i))
				if (debuffType) then
					debuffTypes[debuffType] = true
				end
			end

			local color
			for i = #db.debuffOrder, 1, -1 do
				local debuff = db.debuffOrder[i]
				if (debuffTypes[debuff]) then
					color = A.colors.debuff[debuff]
				end
			end

			if (color) then
				parent.Background:SetBackdropBorderColor(unpack(color))
			else
				if (parent.unit and UnitIsUnit("target", parent.unit)) then
					parent.Background:SetBackdropBorderColor(T:unpackColor(db.targetColor))
				else
					parent.Background:SetBackdropBorderColor(T:unpackColor(parent.db.background.color))
				end
			end
		end
	end
end

function Border:Simulate(parent)

end

A.elements.shared[elementName] = Border