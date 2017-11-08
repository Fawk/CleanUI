local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local buildText = A.TextBuilder

local CreateFrame = CreateFrame

local opposite = {
	["LEFT"] = "RIGHT",
	["RIGHT"] = "LEFT"
}

local function CheckEnabled(e, db)
	if not db["Enabled"] then
		e:Hide()
	else
		e:Show()
	end
end

local function Castbar(frame, db)

	local mult = 0.33
	local r, g, b = unpack(A.colors.castbar)

	local size = db["Size"]
	local texture = media:Fetch("statusbar", db["Texture"])
	local width = size["Match width"] and frame:GetWidth() or size["Width"]
	local height = size["Match height"] and frame:GetWidth() or size["Height"]

	local bar = frame.Castbar or (function()
		local bar = CreateFrame("StatusBar", A:GetName().."_"..frame:GetName().."Castbar", frame)

		local name = buildText(bar, db["Name"]["Font Size"]):shadow():enforceHeight():build()
		name:SetText("")

		local time = buildText(bar, db["Time"]["Font Size"]):shadow():build()
		time:SetText("")

		bar.Text = name
		bar.Time = time
		bar.Icon = bar:CreateTexture(nil, "OVERLAY")
		bar.Icon:SetTexCoord(0.133,0.867,0.133,0.867)
		bar.bg = bar:CreateTexture(nil, "BORDER")
		bar.bg:SetAllPoints()

		bar:HookScript("OnShow", function(self)
			self:SetStatusBarTexture(texture)
			self:SetStatusBarColor(r, g, b)
			self.bg:SetTexture(texture)
			self.bg:SetVertexColor(r * mult, g * mult, b * mult)
		end)

		return bar
	end)()

	bar:SetSize(width, height)

	local iconW, iconH, iconX, iconY
	local iconDb = db["Icon"]

	if iconDb["Enabled"] then

		if iconDb["Size"]["Match width"] then
			iconW = width
			iconH = width
		elseif iconDb["Size"]["Match height"] then
			iconH = height
			iconW = height
		else
			iconW = iconDb["Size"]
			iconH = iconDb["Size"]
		end

		bar.Icon:SetSize(iconW, iconH)
		T:Background(bar, iconDb, bar.Icon, false)
	end

	if not bar.setup then
		bar.oldSetPoint = bar.SetPoint
		bar.SetPoint = function(self, lp, r, p, x, y)
			if iconDb["Enabled"] then
				self.Icon:SetPoint(lp, r == self.Icon and self.Icon:GetParent():GetParent() or r, p, x or 0, (y or 0) - 1)
				local p = iconDb["Position"]
				if p == "LEFT" then
					bar:oldSetPoint("LEFT", bar.Icon, "RIGHT", 0, 0)
				elseif p == "RIGHT" then
					bar:oldSetPoint("RIGHT", bar.Icon, "LEFT", 0, 0)
				end
				width = (size["Match width"] and frame:GetWidth() or size["Width"]) - iconW
			else
				bar:oldSetPoint(lp, r, p, x or 0, (y or 0) - 1)
			end
			bar:SetSize(width, height)
		end
		bar.setup = true
	end

	Units:Position(bar, db["Position"])
	Units:Position(bar.Text, db["Name"]["Position"])
	Units:Position(bar.Time, db["Time"]["Position"])

	bar:SetStatusBarTexture(texture)
	bar:SetStatusBarColor(r, g, b)
	bar.bg:SetTexture(texture)
	bar.bg:SetVertexColor(r * mult, g * mult, b * mult)

	CheckEnabled(bar.Text, db["Name"])
	CheckEnabled(bar.Time, db["Time"])
	CheckEnabled(bar.Icon, db["Icon"])

	T:Background(bar, db, nil, true)

	frame.Castbar = bar

	Units:PlaceCastbar(frame, true)
end

A["Elements"]["Castbar"] = Castbar