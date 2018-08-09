local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum
local Units = A.Units
local T = A.Tools

local elementName = "combat"
local CombatIndicator = {}

function CombatIndicator:Init(parent)
	local db = parent.db[elementName]

	local combat = parent.orderedElements:get(elementName)
	if (not combat) then
		combat = CreateFrame("Frame", parent:GetName().."_"..elementName, parent)
		combat.db = db
		combat.noTags = true
		combat.text = combat:CreateFontString(nil, "OVERLAY")
		combat.text:SetPoint("CENTER")
		combat.texture = combat:CreateTexture(nil, "OVERLAY")
		combat.texture:SetAllPoints()

		combat.Update = function(self, ...)
			CombatIndicator:Update(self, ...)
		end

		combat:RegisterEvent("PLAYER_REGEN_ENABLED")
		combat:RegisterEvent("PLAYER_REGEN_DISABLED")
		combat:SetScript("OnEvent", function(self, ...)
			self:Update(UnitEvent.UPDATE_DB)
		end)
	end

	combat:Update(UnitEvent.UPDATE_DB)

	parent.orderedElements:set(elementName, combat)
end

function CombatIndicator:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local db = self.db

	local inCombat = UnitAffectingCombat("player")
	if (inCombat) then
		self:Show()
	else
		self:Hide()
	end

	if (not self.style) then
    	self.style = db.style
    else
    	if (self.style == db.style) then
    		return -- Let's not update if we don't have to
    	else
    		self.style = db.style
    	end
    end

    self:SetSize(db.size, db.size)
    Units:Position(self, db.position)

	if (db.style == "Text" or db.style == "Letter") then
		self.texture:Hide()
		self.text:Show()

		local value = "Combat"
		if (db.style == "Letter") then
			value = value:sub(1, 1)
		end
		self.text:SetFont(media:Fetch("font", "Default"), db.fontSize, "OUTLINE")
		self.text:SetText(value)
		self.text:SetTextColor(T:unpackColor(db.color))
	elseif (db.style == "texture") then
		self.texture:Show()
		self.text:Hide()

		self.texture:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
		self.texture:SetTexCoord(.5, 1, 0, .49)
	elseif (db.style == "color") then
		self.texture:Show()
		self.text:Hide()

		self.texture:SetTexture(T:unpackColor(db.color))
		self.texture:SetTexCoord(0, 1, 0, 1)
	end
end

A["Player Elements"]:set(elementName, CombatIndicator)

