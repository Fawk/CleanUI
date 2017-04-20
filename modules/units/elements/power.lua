local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType

local function Power(frame, db)

	local colorType = db["Color By"]
	local powerType = powerType, powerToken, altR, altG, altB = UnitPowerType(frame.unit)

	local power = frame.Power or (function()

		local power = CreateFrame("StatusBar", "Power", frame)
		power:SetFrameStrata("LOW")
		power.frequentUpdates = true
		power.bg = power:CreateTexture(nil, "BACKGROUND")
		power.PostUpdate = function(self, unit, min, max)
			local r, g, b, t
			if colorType == "Class" then
				power.colorClass = true
			else if colorType == "Power" then
				power.colorPower = true
			else if colorType == "Custom" then
				t = db["Custom Color"]
			end
			if t then
				r, g, b = unpack(t)
			end
			self:SetStatusBarColor(r, g, b)
			local mult = db["Background Multiplier"]
			self.bg:SetVertexColor(r * mult, g * mult, b * mult)
		end
		
		local min, max = UnitPower(frame.unit), UnitPowerMax(frame.unit)
		power:PostUpdate(frame.unit, min, max)

		return power

	end)()

	Units:SetPosition(power, db["Position"])

	local texture = media:Fetch("texture", db["Texture"])

	power:SetOrientation(db["Orientation"])
	power:SetStatusBarTexture(texture)
	power.bg:ClearAllPoints()
	power.bg:SetAllPoints()
	power.bg:SetTexture(texture)

	if frame.PostPower then
		frame:PostPower(power)
	end

	frame.Power = power
end 

A["Elements"]["Power"] = Power