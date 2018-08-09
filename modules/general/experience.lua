local A, L = unpack(select(2, ...))
local E, T, U = { name = "Experience Bar" }, A.Tools, A.Utils
local buildText = A.TextBuilder
local media = LibStub("LibSharedMedia-3.0")
local UnitLevel = UnitLevel
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax
local GetXPExhaustion = GetXPExhaustion
local GetMaxPlayerLevel = GetMaxPlayerLevel
local IsXPUserDisabled = IsXPUserDisabled

local function text(xp, xpmax)
    local smallxp, smallmax
    if xp > 1000000 then
        smallxp = string.format("%.1f", xp/1000000).."M"
    elseif xp > 1000 then
        smallxp = string.format("%.1f", xp/1000).."K"
    end
    if xpmax > 1000000 then
        smallmax = string.format("%.1f", xpmax/1000000).."M" 
    elseif xpmax > 1000 then
        smallmax = string.format("%.1f", xpmax/1000).."K"
    end
    return string.format("%s / %s (%.1f%%)", smallxp or xp, smallmax or xpmax, (xp / xpmax) * 100)
end

local function sizeRestedBar(experience, width)

    experience.restedBar:SetPoint("TOPLEFT", experience:GetStatusBarTexture(), "TOPRIGHT")
    experience.restedBar:SetPoint("BOTTOMLEFT", experience:GetStatusBarTexture(), "BOTTOMLEFT")

    local xp, xpMax, restXp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion() or 0
    if restXp > (xpMax - xp) then
        experience.restedBar:Show()
        experience.restedBar:SetWidth((1 - (xp / xpMax)) * width)
    else
        if restXp == 0 then
            experience.restedBar:Hide()
        end
        experience.restedBar:SetWidth((restXp / xpMax) * width)
    end 
end

function E:Init()
	
	local db = A.db.profile.general.experience
    local xp, xpMax = UnitXP("player"), UnitXPMax("player")
	
	local experience = A.frames.experienceBar or (function()
		local experience = CreateFrame("StatusBar", T:frameName(self.name), A.frameParent)
		experience.bg = experience:CreateTexture(nil, "BORDER")
		experience.bg:SetAllPoints()
        experience:RegisterEvent("PLAYER_XP_UPDATE")
        experience:RegisterEvent("UPDATE_EXHAUSTION")
		experience:SetScript("OnEvent", function(self, event, ...)
            T:Switch(event,
                "PLAYER_XP_UPDATE", function()
                    local xp, xpMax = UnitXP("player"), UnitXPMax("player")
                    self:SetValue(xp)
                    self:SetMinMaxValues(0, xpMax)
                    self.text:SetText(text(xp, xpMax))
                    sizeRestedBar(self, db.size.width)
                end,
                "UPDATE_EXHAUSTION", function()
                    sizeRestedBar(self, db.size.width)
                end)

            if (UnitLevel("player") == GetMaxPlayerLevel()) or IsXPUserDisabled() then
                self:Hide()
            end

		end)
        experience:SetScript("OnEnter", function(self, userMoved)
            if userMoved then 
                local restXp, xpMax = GetXPExhaustion(), UnitXPMax("player")
                GameTooltip_SetDefaultAnchor(GameTooltip, experience)
                GameTooltip:AddDoubleLine("Rested", string.format("%.1f%%", ((restXp or 0) / xpMax) * 100))
                GameTooltip:Show()
            end
        end)
        experience:SetScript("OnLeave", function(self, userMoved)
            if userMoved then 
                GameTooltip:Hide()
            end
        end)
        local textFrame = CreateFrame("Frame", nil, experience)
        textFrame:SetSize(db.size.width, db.size.height)
        textFrame:SetPoint("CENTER")
        textFrame:SetFrameLevel(2)
        
        local text = buildText(textFrame, 10):atCenter():outline():build()
        experience.text = text

        local rested = CreateFrame("StatusBar", T:frameName(self.name, "Rested"), experience)
        experience.restedBar = rested
		return experience
	end)()

    local position = db.position
    local size = db.size
    local texture = media:Fetch("statusbar", db.texture)
    local r, g, b = T:unpackColor(db.color)

    experience:ClearAllPoints()
    
    local x, y = position.x, position.y

    experience:SetPoint(position.localPoint, A.frameParent, position.point, x, y)
	experience:SetSize(size.width, size.height)
	experience:SetStatusBarTexture(texture)
    experience:SetStatusBarColor(r, g, b)
    experience:SetMinMaxValues(0, xpMax)
    experience:SetValue(xp)
    experience.bg:SetTexture(texture)
    experience.text:SetText(text(xp, xpMax))
    experience.restedBar:SetStatusBarTexture(texture)
    experience.restedBar:SetStatusBarColor(0, 0.2, 0.8)
    experience.restedBar:SetPoint("TOPLEFT", experience:GetStatusBarTexture(), "TOPRIGHT")
    experience.restedBar:SetPoint("BOTTOMLEFT", experience:GetStatusBarTexture(), "BOTTOMLEFT")
    sizeRestedBar(experience, size.width)

    local mult = db.mult
	experience.bg:SetVertexColor(r * mult, g * mult, b * mult)

	U:CreateBackground(experience, db, true)

    if (UnitLevel("player") == GetMaxPlayerLevel()) or IsXPUserDisabled() then
        experience:Hide()
    end

    experience.db = db

	A:CreateMover(experience, db, self.name)
	A.frames.experienceBar = experience
end

function E:Update(...)

    

end

A.general.experience = E
