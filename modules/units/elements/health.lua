local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local colors = {
	health = {
		low = { .54, .16, .11 },
		medium = { .40, .26, .04 }
	}
}

local function Health(frame, db)

	local health = frame.Health or (function()

		local health = CreateFrame("StatusBar", "Health", frame)
		health:SetFrameStrata("LOW")
		health.frequentUpdates = true

		local function Gradient()
			local r1, g1, b1 = unpack(colors.health.low)
			local r2, g2, b2 = unpack(colors.health.medium)
			local r3, g3, b3 = unpack(E.colors.backdrop)
			return r1, g1, b1, r2, g2, b2, r3, g3, b3
		end

		health.PostUpdate = function(self, unit, min, max)
			local min, max = UnitHealth(unit), UnitHealthMax(unit)
			local r, g, b = oUF.ColorGradient(min, max, Gradient())

			self:SetStatusBarColor(r, g, b)
			self.bg:SetVertexColor(r * 0.33, g * 0.33, b * 0.33)
		end

		health.bg = health:CreateTexture(nil, "BACKGROUND")
		
		local min, max = UnitHealth(frame.unit), UnitHealthMax(frame.unit)
		local r, g, b = oUF.ColorGradient(min, max, Gradient())
		health:SetStatusBarColor(r, g, b)

		return health

	)()

	health:ClearAllPoints()
	if db.Position["Local Point"] == "ALL" then
		health:SetAllPoints()
	else

	end

	health:SetOrientation(db["Orientation"])
	health:SetStatusBarTexture(db["Texture"])
	health.bg:ClearAllPoints()
	health.bg:SetAllPoints()
	health.bg:SetTexture(db["Texture"])

	if frame.PostHealth then
		frame:PostHealth(health)
	end

end 

A["Elements"]["Health"] = Health