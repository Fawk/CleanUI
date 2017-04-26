local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType

local function Power(frame, db)

	local power = frame.Power or (function()

		local power = CreateFrame("StatusBar", "Power", frame)
		power:SetFrameStrata("LOW")
		power.frequentUpdates = true
		power.bg = power:CreateTexture(nil, "BACKGROUND")
		power.PostUpdate = function(self, unit, min, max)
			local r, g, b, t, a
			local mult = db["Background Multiplier"]
			local colorType = db["Color By"]
			if colorType == "Class" then
				power.colorClass = true
			elseif colorType == "Power" then
				t = A.colors.power[select(2, UnitPowerType(unit))]
			elseif colorType == "Custom" then
				t = db["Custom Color"]
			end
			if t then
				r, g, b = unpack(t)
			end

			if unit ~= "player" then
				self.timer = 0
				self:SetScript("OnUpdate", function(self, elapsed)
					self.timer = self.timer + elapsed
					if self.timer > 0.10 then
						self.inRange = select(1, UnitInRange(unit))
						if r then
							self:SetStatusBarColor(r, g, b, self.inRange and 1 or 0.5)
							self.bg:SetVertexColor(r * mult, g * mult, b * mult, self.inRange and 1 or 0.5)
						end
						self.timer = 0
					end
				end)
			end

			if r then
				a = unit == "player" and 1 or (self.inRange and 1 or 0.5)
				self:SetStatusBarColor(r, g, b, a)
				self.bg:SetVertexColor(r * mult, g * mult, b * mult, a)
			end
		end
		
		local min, max = UnitPower(frame.unit), UnitPowerMax(frame.unit)
		power:PostUpdate(frame.unit, min, max)

		return power

	end)()

	Units:Position(power, db["Position"])

	local texture = media:Fetch("texture", db["Texture"])
	local size = db["Size"]

	power:SetOrientation(db["Orientation"])
	power:SetReverseFill(db["Reversed"])
	power:SetStatusBarTexture(texture)
	power:SetWidth(size["Match Width"] and frame:GetWidth() or size["Width"])
	power:SetHeight(size["Match Height"] and frame:GetHeight() or size["Height"])
	power.bg:ClearAllPoints()
	power.bg:SetAllPoints()
	power.bg:SetTexture(texture)

	if frame.PostPower then
		frame:PostPower(power)
	end

	frame.Power = power
end

A["Elements"]["Power"] = Power