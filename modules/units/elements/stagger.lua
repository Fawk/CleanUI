local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization

local function Stagger(frame, db)
	local _,class = UnitClass("player")
	if class ~= "MONK" then
		if frame.Stagger then
			Units:PlaceCastbar(frame, true)
			frame.Stagger:Hide()
		end
		return
	end

	local size, texture = db["Size"], media:Fetch("statusbar", db["Texture"])

	local stagger = (function()
		local stagger = CreateFrame("StatusBar", T:frameName("Stagger"), frame)
		stagger.bg = stagger:CreateTexture(nil, "BORDER")
		stagger.bg:SetAllPoints()
		stagger.bg.multiplier = db["Background Multiplier"] or 0.3
		return stagger
	end)()

	Units:Position(stagger, db["Position"])

	stagger:SetSize(size["Match width"] and frame:GetWidth() or size["Width"], size["Match height"] and frame:GetHeight() or size["Height"])
	stagger:SetStatusBarTexture(texture)
	stagger.bg:SetTexture(texture)

	U:CreateBackground(stagger, db, true)

	Units:PlaceCastbar(frame, nil, true)

	frame.Stagger = stagger
end

A["Elements"]:add({ name = "Stagger", func = Stagger })