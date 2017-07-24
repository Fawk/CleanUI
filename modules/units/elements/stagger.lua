local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame

local function Stagger(frame, db)

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

	if db["Background"] and db["Background"]["Enabled"] then
		local offset = db["Background"]["Offset"]
		stagger:SetBackdrop({
			bgFile = media:Fetch("statusbar", "Default"),
			tile = true,
			tileSize = 16,
			insets = {
				top = offset["Top"],
				bottom = offset["Bottom"],
				left = offset["Left"],
				right = offset["Right"],
			}
		})
		stagger:SetBackdropColor(unpack(db["Background"]["Color"]))
	else
		stagger:SetBackdrop(nil)
	end

	Units:PlaceCastbar(frame, nil, true)

	frame.Stagger = stagger
end

A["Elements"]["Stagger"] = Stagger