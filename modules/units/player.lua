local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization

local Player = {}
local frameName = "Player"
 
function Player:Init()

	local db = A["Profile"]["Options"][frameName]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Player:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)
    Units:Add(Units:Get(frameName) or oUF:Spawn(frameName, frameName))
    self:Update(Units:Get(frameName), db)
end
 
function Player:Setup(frame, db)
    if not db["Enabled"] then
        return frame:Disable()
    else
        frame:Enable()
    end
 
    local position, size, bindings = db["Position"], db["Size"], db["Key Bindings"]
 
    Units:Position(frame, position)
    frame:SetSize(size["Width"], size["Height"])
    Units:SetKeyBindings(frame, bindings)
    Units:UpdateElements(frame, db)

    self:CreateFrame(frame, db)
end
 
function Player:Update(frame, db)
    if not db["Enabled"] then
        return frame:Disable()
    else
        frame:Enable()
    end
 
    Units:UpdateElements(frame, db["Elements"])
    self:UpdateFrame()
end

function Player:CreateFrame(frame, db)
-- https://jsfiddle.net/859zu65s/
	local size = db.Size
	local position = db.Position
	local hdb = db.Health

	frame:SetSize(size.Width, size.Height)
	frame:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
	frame:SetBackdrop(E.backdrops.editbox)
	frame:SetBackdropColor(unpack(A.colors.backdrop.))
	frame:SetFrameStrata("LOW")

	local health = CreateFrame("StatusBar", "Health", frame)
	health:SetFrameStrata("LOW")
	health:SetOrientation("HORIZONTAL")
	health:SetStatusBarTexture(E.backdrops.editbox.bgFile)
	health.frequentUpdates = true

		local colors = {
			health = {
				low = { .54, .16, .11 },
				medium = { .40, .26, .04 }
			}
		}

		local function Gradient()
			local r1, g1, b1 = unpack(colors.health.low)
			local r2, g2, b2 = unpack(colors.health.medium)
			local r3, g3, b3 = unpack(A.colors.backdrop.)
			return r1, g1, b1, r2, g2, b2, r3, g3, b3
		end


	health.PostUpdate = function(self, unit, min, max)


		local min, max = UnitHealth("player"), UnitHealthMax("player")
		local r, g, b = oUF.ColorGradient(min, max, Gradient())

		self:SetStatusBarColor(r, g, b)
		self.bg:SetVertexColor(r * 0.33, g * 0.33, b * 0.33)
	end

	health.bg = health:CreateTexture("bg", "BACKGROUND")
	health.bg:SetTexture(E.backdrops.editbox.bgFile)
	
	local min, max = UnitHealth("player"), UnitHealthMax("player")
	local r, g, b = oUF.ColorGradient(min, max, Gradient())
	health:SetStatusBarColor(r, g, b)

	local power = CreateFrame("StatusBar", "Power", frame)
	power:SetFrameStrata("LOW")
	power:SetOrientation("VERTICAL")
	power:SetStatusBarTexture(E.backdrops.editbox.bgFile)
	power.frequentUpdates = true
	power.colorPower = true

	power.bg = power:CreateTexture("bg", "BACKGROUND")
	power.bg:SetTexture(E.backdrops.editbox.bgFile)

	oUF.colors.power["MANA"] = { 0.3, 0.3, 0.8 }

	local _,type = UnitPowerType("player")
	r, g, b =  unpack(oUF.colors.power[type])

	power:SetStatusBarColor(r, g, b)
	power.bg:SetVertexColor(r * 0.3, g * 0.3, b * 0.3)
	power.bg.multiplier = 0.3

	frame:SetAttribute("unit", "player")
	--frame:SetAttribute("type", "spell")
	--frame:SetAttribute("*helpbutton1", "help1")
	--frame:SetAttribute("*helpbutton2", "help2")
	--frame:SetAttribute("*helpbutton3", "help3")

	--frame:SetAttribute("spell-help1", "Flash Heal")
	--frame:SetAttribute("shift-spell-help1", "Renew")
	--frame:SetAttribute("ctrl-shift-type", "target")

	--frame:SetAttribute("spell-help2", "Heal")

	--frame:SetAttribute("spell-help3", "Purify")
	--frame:SetAttribute("shift-spell-help3", "Prayer of Mending")

	frame:SetAttribute("*type1", "target")
	frame:SetAttribute("*type2", "togglemenu")
	--frame:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");

	frame.Health = health
	frame.Power = power

	local _,name = GetSpecializationInfo(GetSpecialization())
end

function Player:UpdateFrame()

	if InCombatLockdown() then return end

	local db = A["Profile"]["Options"][frameName]
	local size = db.Size
	local position = db.Position
	local frame = Units:GetFrame(frameName)

	local unit = frame.unit
	if not unit then return end
	
	frame:SetSize(size.Width, size.Height)
	frame:ClearAllPoints()
	frame:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
    Units:UpdateElements(frame, db["Elements"])

end

A.modules["player"] = Player