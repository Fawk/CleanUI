local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local Unit

--[[ Lua ]]


--[[ Locals ]]
local elementName = "Border"
local Border = {}

function Border:Init(parent)
	
	local db = parent.db[elementName]

	if (not db) then return end

	local border = parent.orderedElements:get(elementName)
	if (not border) then
		border = CreateFrame("Frame")
		border.db = db
		border.Update = function(self, ...)
			Border:Update(self, ...)
		end

		border:SetScript("OnUpdate", function(self, elapsed)
			self:Update("OnUpdate", elapsed)
		end)
	end

	parent.orderedElements:set(elementName, border)
end

function Border:Update(...)	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	if (not db["Enabled"]) then
		self:Hide()
		return
	else
		self:Show()
	end

	if (event == UnitEvent.UPDATE_DB) then
		if (db["Highlight Target"]) then
			parent:SetBackdropBorderColor(unpack(db["Target Color"]))
		end

		if (db["Show Debuff Border"]) then
			local debuffTypes = {}
			for i = 1, 40 do
				local debuffType = select(5, UnitDebuff(parent.unit, i))
				if (debuffType) then
					debuffTypes[debuffType] = true
				end
			end
				
			local color
			if (debuffTypes["Poison"]) then
				color = A.colors.debuff["Poison"]
			end

			if (debuffTypes["Disease"]) then
				color = A.colors.debuff["Disease"]
			end

			if (debuffTypes["Curse"]) then
				color = A.colors.debuff["Curse"]
			end

			if (debuffTypes["Magic"]) then
				color = A.colors.debuff["Magic"]
			end
			
			parent:SetBackdropBorderColor(unpack(color))
		end
	else

	end
end

function Border:Simulate(parent)

end