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
	local iconW, iconH

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
		local p = iconDb["Position"]
		if p == "LEFT" then
			pos["Offset X"] = pos["Offset X"] + iconW
		elseif p == "RIGHT" then
			pos["Offset X"] = pos["Offset X"] - iconW
		end
		width = width - iconW
	end

	Units:Position(bar, pos)
	Units:Position(bar.Text, db["Name"]["Position"])
	Units:Position(bar.Time, db["Time"]["Position"])

	bar.Icon:ClearAllPoints()
	bar.Icon:SetPoint(T.reversedPoints[iconDb["Position"]], bar, iconDb["Position"], 0, 0)

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