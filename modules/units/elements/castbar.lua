local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local buildText = A.TextBuilder

local CreateFrame = CreateFrame

local function CheckEnabled(e, db)
	if not db["Enabled"] then
		e:Hide()
	else
		e:Show()
	end
end

local function Castbar(frame, db)

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
		bar.bg = bar:CreateTexture(nil, "BACKGROUND")
		bar.bg:SetAllPoints()

		bar:HookScript("OnShow", function(self)
			self:SetStatusBarTexture(texture)
			self:SetStatusBarColor(0.33, 0.33, 0.67)
			self.bg:SetTexture(texture)
			self.bg:SetVertexColor(0.33 * 0.33, 0.33 * 0.33, 0.67 * 0.33)
		end)

		return bar
	end)()

	if not frame.ClassIcons then
		db["Position"]["Relative To"] = "Parent"
	end

	local iconDb = db["Icon"]

	Units:Position(bar, db["Position"])
	Units:Position(bar.Text, db["Name"]["Position"])
	Units:Position(bar.Time, db["Time"]["Position"])
	Units:Position(bar.Icon, iconDb["Position"])

	bar:SetSize(width, height)
	bar:SetStatusBarTexture(texture)
	bar:SetStatusBarColor(0.33, 0.33, 0.67)
	bar.bg:SetTexture(texture)
	bar.bg:SetVertexColor(0.33 * 0.33, 0.33 * 0.33, 0.67 * 0.33)

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