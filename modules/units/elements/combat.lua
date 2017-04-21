local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum

function Combat(frame, db)

	local combat = frame.Combat or (function()
		local combat = CreateFrame("Frame", "Combat", frame)
		combat:SetBackdrop(E.backdrops.border)
		combat:SetFrameStrata("LOW")
		return combat
	end)

	combat:SetBackdropBorderColor(A.color.combat)
	combat:ClearAllPoints()
	combat:SetAllPoints()

	frame.Combat = combat
end

A["Elements"]["Combat"] = Combat

