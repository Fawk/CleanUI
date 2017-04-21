local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

function Health(frame, db)

	local health = frame.Health or (function()

		local health = CreateFrame("StatusBar", "Health", frame)
		health:SetFrameStrata("LOW")
		health.frequentUpdates = true
		health.bg = health:CreateTexture(nil, "BACKGROUND")

		local function Gradient()
			local r1, g1, b1 = unpack(A.colors.health.low)
			local r2, g2, b2 = unpack(A.colors.health.medium)
			local r3, g3, b3 = unpack(A.colors.backdrop.default)
			return r1, g1, b1, r2, g2, b2, r3, g3, b3
		end

		health.PostUpdate = function(self, unit, min, max)
			
			local r, g, b, t
			local colorType = db["Color By"]
			
			if colorType == "Class" then
				power.colorClass = true
			elseif colorType == "Health" then
				power.colorHealth = true
			elseif colorType == "Custom" then
				t = db["Custom Color"]
			elseif colorType == "Gradient" then
				r, g, b = oUF.ColorGradient(min, max, Gradient())
			end
			
			if t then
				r, g, b = unpack(t)
			end
			
			self:SetStatusBarColor(r, g, b)
			
			local mult = db["Background Multiplier"]
			self.bg:SetVertexColor(r * mult, g * mult, b * mult)
		end
		
		local min, max = UnitHealth(frame.unit), UnitHealthMax(frame.unit)
		health:PostUpdate(frame.unit, min, max)

		return health

	end)()

	Units:Position(health, db["Position"])

	local texture = media:Fetch("texture", db["Texture"])
	local size = db["Size"]

	health:SetOrientation(db["Orientation"])
	health:SetReverseFill(db["Reversed"])
	health:SetStatusBarTexture(texture)
	health:SetWidth(size["Match Width"] and frame:GetWidth() or size["Width"])
	health:SetHeight(size["Match Height"] and frame:GetHeight() or size["Height"])
	health.bg:ClearAllPoints()
	health.bg:SetAllPoints()
	health.bg:SetTexture(texture)

	if frame.PostHealth then
		frame:PostHealth(health)
	end

	frame.Health = health
end 

A["Elements"]["Health"] = Health