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

	if db["Position"]["Relative To"] == "ClassIcons" and frame.unit == "player" then
		local ci = A["Profile"]["Options"]["Player"]["ClassIcons"]
		if not ci or not ci["Enabled"] then
			db["Position"]["Relative To"] = "Parent"
		end
	end

	local iconDb = db["Icon"]
	local iconW, iconH, iconX, iconY

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

	local pos = {
		["Local Point"] = db["Position"]["Local Point"],
		["Point"] = db["Position"]["Point"],
		["Offset X"] = db["Position"]["Offset X"],
		["Offset Y"] = db["Position"]["Offset Y"],
		["Relative To"] = db["Position"]["Relative To"]
	}

	if iconDb["Enabled"] then
		local p, f = iconDb["Position"], { x = 0, y = 0 }
		if p == "LEFT" then
			pos["Offset X"] = pos["Offset X"] + iconW
			f.x = iconW
		elseif p == "RIGHT" then
			pos["Offset X"] = pos["Offset X"] - iconW
			f.x = -iconW
		end
		width = width - iconW

		if iconDb["Background"]["Enabled"] then

			bar.Icon:SetSize(iconW - 1, iconH)

			width = width + 1
			pos["Offset X"] = pos["Offset X"] - 1
			f.x = f.x - 1

			local bg = bar.Icon.bg or CreateFrame("Frame", nil, bar)
			local offset = iconDb["Background"]["Offset"]
			bg:SetFrameStrata("LOW")
			bg:SetFrameLevel(2)
			bg:SetSize(iconW - 1, iconH)
			bg:ClearAllPoints()
			bg:SetPoint("CENTER", bar.Icon, "CENTER", 0, 0)
			bg:SetBackdrop({
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
			bg:SetBackdropColor(unpack(iconDb["Background"]["Color"]))
			bar.Icon.bg = bg
		else
			if bar.Icon.bg then
				bar.Icon.bg:Hide()
			end
		end

		bar.iconFix = f
	end

	Units:Position(bar, pos)
	Units:Position(bar.Text, db["Name"]["Position"])
	Units:Position(bar.Time, db["Time"]["Position"])

	bar.Icon:ClearAllPoints()
	bar.Icon:SetPoint(T.reversedPoints[iconDb["Position"]], bar, iconDb["Position"], iconX or 0, iconY or 0)

	bar:SetSize(width, height)
	bar:SetStatusBarTexture(texture)
	bar:SetStatusBarColor(r, g, b)
	bar.bg:SetTexture(texture)
	bar.bg:SetVertexColor(r * mult, g * mult, b * mult)

	CheckEnabled(bar.Text, db["Name"])
	CheckEnabled(bar.Time, db["Time"])
	CheckEnabled(bar.Icon, db["Icon"])

	if db["Background"] and db["Background"]["Enabled"] then
		local offset = db["Background"]["Offset"]
		bar:SetBackdrop({
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
		bar:SetBackdropColor(unpack(db["Background"]["Color"]))
	else
		bar:SetBackdrop(nil)
	end

	frame.Castbar = bar
end

A["Elements"]["Castbar"] = Castbar