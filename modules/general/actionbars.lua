local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local LAB = LibStub("LibActionButton-1.0")

local AB = {}

function AB:Init()

	for x = 1, 4 do
		local bar = CreateFrame("Frame", "Baaaaar", A.frameParent, "SecureHandlerStateTemplate")
		bar.buttons = {}
		for i = 1, 12 do
			local button = LAB:CreateButton(i, string.format("%s_ActionBar%dButton%d", A:GetName(), x, i), bar)
			button:SetBackdrop(E.backdrops.statusbar)
			button:SetBackdropColor(0, 0, 0)
			button:SetPoint("LEFT", bar.buttons[i - 1] or bar, "RIGHT", 0, 0)
		end
		bar:SetPoint("TOP", -100)
	end

end

A["modules"]["Actionbars"] = AB