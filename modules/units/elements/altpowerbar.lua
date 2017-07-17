local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local buildText = A.TextBuilder

for key, obj in next, {
    ["altpp"] = {
        method = [[function(u, r)
            if not u and not r then return end
            if UnitExists(r or u) then
				return UnitPower(r or u, SPELL_POWER_ALTERNATE_POWER)
            end
        end]],
        events = "UNIT_POWER_FREQUENT"
    },
    ["altppmax"] = {
        method = [[function(u, r)
            if not u and not r then return end
            if UnitExists(r or u) then
            	return UnitPowerMax(r or u, SPELL_POWER_ALTERNATE_POWER)
            end
        end]],
        events = "UNIT_MAXPOWER"
    }
} do
    oUF["Tags"]["Methods"][key] = obj.method
    oUF["Tags"]["Events"][key] = obj.events
end

function AltPowerBar(frame, db)

	local mult = db["Background Multiplier"]
	local texture = media:Fetch("statusbar", db["Texture"])
	local size = db["Size"]

	local bar = frame.AltPowerBar or (function()
		local bar = CreateFrame("StatusBar", A:GetName().."_AltPowerBar", frame)
		bar.value = buildText(bar, 10):shadow():atCenter():build()
		bar.value:SetText("")
		bar.bg = bar:CreateTexture(nil, "BACKGROUND")
		bar.OnPostUpdate = function(self, min, cur, max)
			local r, g, b = self:GetStatusBarColor()
			if r == 1 and g == 1 and b == 1 then
				r, g, b = 0.67, 0.13, 0.13
			end
			self.bg:SetVertexColor(r * mult, g * mult, b * mult)
		end
		return bar
	end)()

	if not db["Enabled"] then
		bar:Hide()
		return
	end

	Units:Position(bar, db["Position"])
	bar:SetSize(size["Width"], size["Height"])
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

	frame:Tag(bar.value, "[altpp] / [altppmax]")

	frame.AltPowerBar = bar
end

A["Elements"]["AltPowerBar"] = AltPowerBar