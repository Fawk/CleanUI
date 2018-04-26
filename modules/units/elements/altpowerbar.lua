local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
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

function AlternativePower(frame, db)

	local mult = db["Background Multiplier"]
	local texture = media:Fetch("statusbar", db["Texture"])
	local size = db["Size"]

	local bar = frame.AlternativePower or (function()
		local bar = CreateFrame("StatusBar", A:GetName().."_AltPowerBar", frame)
		bar.value = buildText(bar, 10):shadow():atCenter():build()
		bar.value:SetText("")
		bar.bg = bar:CreateTexture(nil, "BACKGROUND")
		bar.PostUpdate = function(self, min, cur, max)
			local r, g, b = self:GetStatusBarColor()
			if r > 0.95 and g > 0.95 and b > 0.95 then
				r, g, b = 0.67, 0.13, 0.13
			end
			self.bg:SetVertexColor(r * mult, g * mult, b * mult)
			self:SetStatusBarColor(r, g, b)
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

	local r, g, b = 0.67, 0.13, 0.13
	bar.bg:SetVertexColor(r * mult, g * mult, b * mult)
	bar:SetStatusBarColor(r, g, b)

	U:CreateBackground(bar, db, true)

	if db["Hide Blizzard"] then
		PlayerPowerBarAlt:UnregisterAllEvents()
		PlayerPowerBarAlt:SetAlpha(0)
	end

	frame:Tag(bar.value, "[altpp] / [altppmax]")

	bar:Hide()

	frame.AlternativePower = bar
end

A["Elements"]["AlternativePower"] = AlternativePower