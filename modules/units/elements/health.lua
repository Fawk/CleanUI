local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

local function SetTagColor(frame, tag, color)
	if frame["Tags"][tag] then
		frame["Tags"][tag]:SetTextColor(unpack(color))
	end
end

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
			local a = 1
			local colorType = db["Color By"]
			local mult = db["Background Multiplier"]
			
			if colorType == "Class" then
				health.colorClass = true
				r, g, b = unpack(oUF.colors.class[select(2, UnitClass(unit))])
			elseif colorType == "Health" then
				health.colorHealth = true
			elseif colorType == "Custom" then
				t = db["Custom Color"]
			elseif colorType == "Gradient" then
				r, g, b = oUF.ColorGradient(min, max, Gradient())
			end
			
			if t then
				r, g, b = unpack(t)
			end

			if unit ~= "player" then
				if UnitIsDeadOrGhost(unit) then
					r, g, b = unpack(A.colors.health.dead)
					if UnitIsDead(unit) then
						SetTagColor(frame, "Name", A.colors.text.dead)
					else
						SetTagColor(frame, "Name", A.colors.text.ghost)
					end
				elseif not UnitIsConnected(unit) then
					r, g, b, a = unpack(A.colors.health.disconnected)
					SetTagColor(frame, "Name", A.colors.text.disconnected)
				else
					SetTagColor(frame, "Name", { 1, 1, 1, 1})
				end

				self.timer = 0
				self:SetScript("OnUpdate", function(self, elapsed)
					self.timer = self.timer + elapsed
					if self.timer > 0.10 then
						a = not select(1, UnitInRange(unit)) and 0.4 or 1
						self:SetStatusBarColor(r, g, b, a or 1)
						self.bg:SetVertexColor(r * mult, g * mult, b * mult, a or 1)
						SetTagColor(frame, "Name", { 1, 1, 1, a })
						self.timer = 0
					end
				end)
			end

			if r then
				self:SetStatusBarColor(r, g, b, a or 1)
				self.bg:SetVertexColor(r * mult, g * mult, b * mult, a or 1)
			end
		end

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