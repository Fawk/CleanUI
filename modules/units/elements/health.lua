local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsDead = UnitIsDead
local UnitIsConnected = UnitIsConnected
local UnitClass = UnitClass
local UnitInRange = UnitInRange

function Health(frame, db)

	local health = frame.Health or (function()

		local health = CreateFrame("StatusBar", frame:GetName().."_Health", frame)
		health:SetFrameStrata("LOW")
		health.frequentUpdates = true
		health.bg = health:CreateTexture(nil, "BACKGROUND")

		local function Gradient(unit)
			local r1, g1, b1 = unpack(A.colors.health.low)
			local r2, g2, b2 = unpack(A.colors.health.medium)
			local r3, g3, b3 = unpack(unit and oUF.colors.class[select(2, UnitClass(unit))] or A.colors.backdrop.light)
			return r1, g1, b1, r2, g2, b2, r3, g3, b3
		end

		health.PostUpdate = function(self, unit, min, max)
			
			local r, g, b, t, a
			local colorType = db["Color By"]
			local mult = db["Background Multiplier"]
			
			if colorType == "Class" then
				health.colorClass = true
				r, g, b = unpack(oUF.colors.class[select(2, UnitClass(unit))] or A.colors.backdrop.default)
			elseif colorType == "Health" then
				health.colorHealth = true
			elseif colorType == "Custom" then
				t = db["Custom Color"]
			elseif colorType == "Gradient" then
				r, g, b = oUF.ColorGradient(min, max, Gradient(unit))
			end
			
			if t then
				r, g, b = unpack(t)
			end

			self.colorClassNPC = true

			if r then
				self:SetStatusBarColor(r, g, b, a or 1)
				self.bg:SetVertexColor(r * mult, g * mult, b * mult, a or 1)
			end
		end

		return health

	end)()

	Units:Position(health, db["Position"])

	local texture = media:Fetch("statusbar", db["Texture"])
	local size = db["Size"]

	health:SetOrientation(db["Orientation"])
	health:SetReverseFill(db["Reversed"])
	health:SetStatusBarTexture(texture)
	health:SetWidth(size["Match width"] and frame:GetWidth() or size["Width"])
	health:SetHeight(size["Match height"] and frame:GetHeight() or size["Height"])
	health.bg:ClearAllPoints()
	health.bg:SetAllPoints()
	health.bg:SetTexture(texture)

	if frame.PostHealth then
		frame:PostHealth(health)
	end

	frame.Health = health
end 

A["Elements"]["Health"] = Health