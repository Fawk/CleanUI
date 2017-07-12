local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

function AltPowerBar(frame, db)

	local mult = db["Background Multiplier"]
	local texture = db["Texture"]
	local size = db["Size"]

	local bar = frame.AltPowerBar or (function()
		local bar = CreateFrame("StatusBar", A:GetName().."_AltPowerBar", frame)
		bar.bg = bar:CreateTexture(nil, "BACKGROUND")
		bar.OnPostUpdate = function(self, min, cur, max)
			local r, g, b = self:GetStatusBarColor()
			self.bg:SetVertexColor(r * mult, g * mult, b * mult)
		end
		return bar
	end)()

	if not db["Enabled"] then
		bar:Hide()
		return
	end

	Units:Position(bar, db["Position"])
	bar:SetSize(size["Width"] - 2, size["Height"] - 2)
	bar:SetStatusBarTexture(texture)
	bar.bg:SetTexture(texture)
	bar.bg:SetAllPoints(bar)

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

	if db["Hide Blizzard"] then
		PlayerPowerBarAlt:UnregisterAllEvents()
		PlayerPowerBarAlt:SetAlpha(0)
	end

	frame.AltPowerBar = bar
end

A["Elements"]["AltPowerBar"] = AltPowerBar