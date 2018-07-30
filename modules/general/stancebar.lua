local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local S = A.Skins
local T = A.Tools
local AB = A.general:get("actionbars")
local media = LibStub("LibSharedMedia-3.0")

local moduleName = "Stance Bar"
local StanceBar = {}

local emptySlots = {}

function StanceBar:Init()

	local db = A["Profile"]["Options"][moduleName]

	if (db["Enabled"]) then

		local position = db["Position"]
		local stanceBar = CreateFrame("Frame", nil, A.frameParent)

		local relative = stanceBar
		for i = 1, NUM_STANCE_SLOTS do
			local button = StanceBarFrame.StanceButtons[i]
			button:ClearAllPoints()
			if (button) then
				button.icon:SetTexCoord(0.133,0.867,0.133,0.867)
				_G[button:GetName().."NormalTexture2"]:SetTexture(nil)
				
				local hotKey = _G[button:GetName().."HotKey"]
				hotKey:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
				hotKey:ClearAllPoints()
				hotKey:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, 0)
				
				if (not hotKey:GetText() or hotKey:GetText() == "") then
					local key = GetBindingKey("SHAPESHIFTBUTTON"..i)
					if (key and key ~= "") then
						hotKey:SetText(AB:ShortKey(key))
					end
				end

				if (relative == stanceBar) then
					button:SetPoint("RIGHT", relative, "RIGHT", 0, 0)
				else
					button:SetPoint("RIGHT", relative, "LEFT", 0, 0)
				end

				if (not emptySlots[i]) then
					emptySlots[i] = CreateFrame("Frame", nil, A.frameParent)
					emptySlots[i]:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
					emptySlots[i]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
					emptySlots[i]:SetBackdrop(A.enum.backdrops.editboxborder)
					emptySlots[i]:SetBackdropColor(0.1, 0.1, 0.1, 1)
					emptySlots[i]:SetBackdropBorderColor(0, 0, 0, 1)
				end

				button:SetCheckedTexture(nil)
				hooksecurefunc(button, "SetChecked", function(self, checked)
					if (checked) then
						emptySlots[i]:SetBackdropBorderColor(0.8, 0.8, 0, 1)
					else
						emptySlots[i]:SetBackdropBorderColor(0, 0, 0, 1)
					end
				end)

				if (not button.icon:GetTexture()) then
					emptySlots[i]:Hide()
				end
			end
			stanceBar:SetSize(stanceBar:GetWidth() + button:GetWidth(), button:GetHeight())
			relative = button
		end
		
		stanceBar:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
		A:CreateMover(stanceBar, db, moduleName)

		if (db["Hide"]) then

			stanceBar:Hide()
		end
	end
end

function StanceBar:Update(...)

end

A.general:set("stanceBar", StanceBar)