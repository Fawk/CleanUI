local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum

function Combat(frame, db)

	local combat = frame.Combat or (function()
		local combat = CreateFrame("Frame", "Combat", frame)
		combat:SetBackdrop({
			bgFile = media:Fetch("statusbar", "Default"),
			tile = true,
			tileSize = 16,
			insets = {
				top = -1,
				bottom = -1,
				left = -1,
				right = -1,
			}
		})
		combat:SetFrameStrata("LOW")
		combat:SetFrameLevel(2)
		return combat
	end)()

	combat:SetBackdropColor(unpack(A.colors.border.combat))
	combat:ClearAllPoints()
	combat:SetPoint("CENTER", frame, "CENTER", 0, 0)
	combat:SetSize(frame:GetSize())

	frame.Combat = combat
end

A["Elements"]["Combat"] = Combat

