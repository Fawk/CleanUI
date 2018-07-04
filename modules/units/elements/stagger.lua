local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local UnitClass = UnitClass

--[[ Locals ]]
local elementName = "Stagger"
local Stagger = { isClassPower = true }

function Stagger:Init(parent)
	if (select(2, UnitClass("player")) ~= "MONK") then
		return
	end

	local parentName = parent:GetDbName()
	local db = parent.db[elementName]

	local size, texture = db["Size"], media:Fetch("statusbar", db["Texture"])

	local stagger = frame.Stagger or (function()
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

A["Player Elements"]:add(elementName, Stagger)