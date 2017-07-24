local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType

local function Power(frame, db)

	local power = frame.Power or (function()

		local power = CreateFrame("StatusBar", frame:GetName().."_Power", frame)

		power:SetFrameStrata("LOW")
		power.frequentUpdates = true
		power.bg = power:CreateTexture(nil, "BACKGROUND")
		power.PostUpdate = function(self, unit, min, max)
			local r, g, b, t
			local mult = db["Background Multiplier"]
			local colorType = db["Color By"]
			if colorType == "Class" then
				power.colorClass = true
			elseif colorType == "Power" then
				local powerType = select(2, UnitPowerType(unit))
				t = A.colors.power[powerType]
				if not t then
					t = oUF.colors.power[powerType]
				end
			elseif colorType == "Custom" then
				t = db["Custom Color"]
			end
			if t then
				r, g, b = unpack(t)
			end

			if r then
				self:SetStatusBarColor(r, g, b)
				self.bg:SetVertexColor(r * mult, g * mult, b * mult)
			end
		end
		
		local min, max = UnitPower(frame.unit), UnitPowerMax(frame.unit)
		power:PostUpdate(frame.unit, min, max)

		return power

	end)()

	Units:Position(power, db["Position"])

	local texture = media:Fetch("statusbar", db["Texture"])
	local size = db["Size"]

	power:SetOrientation(db["Orientation"])
	power:SetReverseFill(db["Reversed"])
	power:SetStatusBarTexture(texture)
	power:SetWidth(size["Match width"] and frame:GetWidth() or size["Width"])
	power:SetHeight(size["Match height"] and frame:GetHeight() or size["Height"])
	power.bg:ClearAllPoints()
	power.bg:SetAllPoints()
	power.bg:SetTexture(texture)

	if frame.PostPower then
		frame:PostPower(power)
	end

	frame.Power = power
end

A["Elements"]["Power"] = Power