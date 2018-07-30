local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local S = A.Skins
local T = A.Tools
local media = LibStub("LibSharedMedia-3.0")

local moduleName = "Bag Bar"
local BagBar = {}

function BagBar:Init()

	local db = A["Profile"]["Options"][moduleName]

	if (db["Enabled"]) then

		local position = db["Position"]
		local bagBar = CreateFrame("Frame", nil, A.frameParent)

		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("RIGHT", bagBar, "RIGHT", 0, 0)

		hooksecurefunc(MainMenuBarBackpackButton, "SetPoint", function(self, lp, r, p, x, y)
			if (r ~= bagBar) then
				self:ClearAllPoints()
				self:SetPoint("RIGHT", microButtonBar, "RIGHT")
			end
		end)

		MainMenuBarBackpackButton:SetSize(32, 32)
		MainMenuBarBackpackButtonNormalTexture:SetTexture(nil)
		MicroButtonAndBagsBar.MicroBagBar:SetTexture(nil)
		MicroButtonAndBagsBar:SetMovable(true)
		MicroButtonAndBagsBar:SetUserPlaced(true)

		bagBar:SetHeight(MainMenuBarBackpackButton:GetHeight())
		bagBar:SetWidth(MainMenuBarBackpackButton:GetWidth())

		for i = 0, 3 do
			_G["CharacterBag"..i.."SlotNormalTexture"]:SetTexture(nil)
			bagBar:SetWidth(bagBar:GetWidth() + _G["CharacterBag"..i.."Slot"]:GetWidth())
		end

		_G["CharacterBag0Slot"]:ClearAllPoints()
		_G["CharacterBag0Slot"]:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -2, 0)

		bagBar:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
		A:CreateMover(bagBar, db, moduleName)

		if (db["Hide"]) then
			MainMenuBarBackpackButton:Hide()
			for i = 0, 3 do
				_G["CharacterBag"..i.."Slot"]:Hide()
			end
			bagBar:Hide()
		end
	end
end

function BagBar:Update(...)

end

A.general:set("bagbar", BagBar)