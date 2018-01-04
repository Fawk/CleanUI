local A, L = unpack(select(2, ...))
local Artifact, T, U = { name = "Artifact Power Bar" }, A.Tools, A.Utils
local buildText = A.TextBuilder
local media = LibStub("LibSharedMedia-3.0")

local function text(xp, xpmax)
    local smallxp, smallmax
    if xp > 1000000000 then
        smallxp = string.format("%.1f", xp/1000000000).."B"
    elseif xp > 1000000 then
        smallxp = string.format("%.1f", xp/1000000).."M"
    elseif xp > 1000 then
        smallxp = string.format("%.1f", xp/1000).."K"
    end
    if xpmax > 1000000000 then
        smallmax = string.format("%.1f", xpmax/1000000000).."B" 
    elseif xpmax > 1000000 then
        smallmax = string.format("%.1f", xpmax/1000000).."M" 
    elseif xpmax > 1000 then
        smallmax = string.format("%.1f", xpmax/1000).."K"
    end
    return string.format("%s / %s (%.1f%%)", smallxp or xp, smallmax or xpmax, (xp / xpmax) * 100)
end

local function getNumAvailableTraits(self)
    local points, current, tier, numTraits, cost = 0, self.current, self.tier, self.numTraits, self.nextCost

    while cost < current do
        points = points + 1
        numTraits = numTraits + 1
        cost = cost + C_ArtifactUI.GetCostForPointAtRank(numTraits, tier)
    end

    return points
end

local function updatePower(self)
    local current = select(5, C_ArtifactUI.GetEquippedArtifactInfo())
    local numTraits = select(6, C_ArtifactUI.GetEquippedArtifactInfo())
    local tier = select(13, C_ArtifactUI.GetEquippedArtifactInfo())
    local nextCost = C_ArtifactUI.GetCostForPointAtRank(numTraits, tier)

    self.current = current
    self.numTraits = numTraits
    self.tier = tier
    self.nextCost = nextCost

    self:SetMinMaxValues(0, nextCost)
    self:SetValue(current)
    self.text:SetText(text(current, nextCost))
end

local function setup(name, artifact, db)
    
    local position = db["Position"]
    local size = db["Size"]
    local texture = media:Fetch("statusbar", db["Texture"])
    local r, g, b = unpack(db["Color"])
    local current = select(5, C_ArtifactUI.GetEquippedArtifactInfo())
    local numTraits = select(6, C_ArtifactUI.GetEquippedArtifactInfo())
    local tier = select(13, C_ArtifactUI.GetEquippedArtifactInfo())
    local nextCost = C_ArtifactUI.GetCostForPointAtRank(numTraits, tier)

    artifact.current = current
    artifact.numTraits = numTraits
    artifact.tier = tier
    artifact.nextCost = nextCost

    artifact:ClearAllPoints()
    artifact:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
    artifact:SetSize(size["Width"], size["Height"])
    artifact:SetStatusBarTexture(texture)
    artifact:SetStatusBarColor(r, g, b)
    artifact:SetMinMaxValues(0, nextCost)
    artifact:SetValue(current)
    artifact.bg:SetTexture(texture)
    artifact.text:SetText(text(current, nextCost))

    local mult = db["Background Multiplier"]
    artifact.bg:SetVertexColor(r * mult, g * mult, b * mult)

    U:CreateBackground(artifact, db, true)

    if not HasArtifactEquipped() then
        artifact:Hide()
    end

    A:CreateMover(artifact, db, name)
    A.frames.artifactPowerBar = artifact
end

function Artifact:Init()
    
    local db = A["Profile"]["Options"][self.name]
    
    local artifact = A.frames.artifactPowerBar or (function()
        local artifact = CreateFrame("StatusBar", T:frameName(self.name), A.frameParent)
        artifact.bg = artifact:CreateTexture(nil, "BORDER")
        artifact.bg:SetAllPoints()
        artifact:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
        artifact:RegisterEvent("ARTIFACT_XP_UPDATE")
        artifact:SetScript("OnEvent", function(self, event, ...)
            T:Switch(event,
                "PLAYER_EQUIPMENT_CHANGED", function()
                    if not HasArtifactEquipped() then
                        self:Hide()
                    else
                        self:Show()
                        updatePower(self)
                    end
                end,
                "ARTIFACT_XP_UPDATE", function()
                    updatePower(self)
                end)
        end)

        artifact:SetScript("OnEnter", function(self, userMoved)
            if userMoved then 
                local restXp, xpMax = GetXPExhaustion(), UnitXPMax("player")
                GameTooltip:SetOwner(artifact)
                GameTooltip:AddLine(string.format("You have enough artifact power to upgrade %d times", getNumAvailableTraits(self)))
                GameTooltip:Show()
            end
        end)
        artifact:SetScript("OnLeave", function(self, userMoved)
            if userMoved then 
                GameTooltip:Hide()
            end
        end)

        local textFrame = CreateFrame("Frame", nil, artifact)
        textFrame:SetSize(db["Size"]["Width"], db["Size"]["Height"])
        textFrame:SetPoint("CENTER")
        textFrame:SetFrameLevel(2)
        
        local text = buildText(textFrame, 10):atCenter():outline():build()
        artifact.text = text

        return artifact
    end)()

    local setupFrame = CreateFrame("Frame")
    setupFrame.timer = 0
    setupFrame:SetScript("OnUpdate", function(self, elapsed)
        self.timer = self.timer + elapsed
        if self.timer > .10 then
            self.timer = 0
            if C_ArtifactUI.GetEquippedArtifactInfo() then
                setup(self.name, artifact, db)
                self:SetScript("OnUpdate", nil)
            end
        end
    end)
    
end

A.modules.artifact = Artifact