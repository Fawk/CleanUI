local A, L = unpack(select(2, ...))
local R, T, U = { name = "Reputation Bar" }, A.Tools, A.Utils
local buildText = A.TextBuilder
local media = LibStub("LibSharedMedia-3.0")
local GetSelectedFaction = GetSelectedFaction
local GetFactionInfoByID = GetFactionInfoByID
local GetNumFactions = GetNumFactions

local standings = {
    [1] = { value = 36000, name = "Hated", inverted = true },
    [2] = { value = 3000, name = "Hostile", inverted = true  },
    [3] = { value = 3000, name = "Unfriendly", inverted = true },
    [4] = { value = 3000, name = "Neutral" },
    [5] = { value = 6000, name = "Friendly" },
    [6] = { value = 12000, name = "Honored" },
    [7] = { value = 21000, name = "Revered" },
    [8] = { value = 999, name = "Exalted" }
}

local total = 0
for _,standing in next, standings do
    total = total + standing.value
end

local isWatching = false
local activeBar = nil

local function setupBarValues(self)
    for i = 1, GetNumFactions() do
        local n,_,standingId,min,max,value,_,_,_,_,_,isWatched = GetFactionInfo(i)
        if isWatched then
            isWatching = true
            for x, bar in next, self.bars do
                if standingId == x then
                    local v = value - min
                    local current = v == 0 and standings[x].value or v
                    bar:SetValue(current)
                    bar.current = current
                    bar.name = standings[x].name
                    bar.max = standings[x].value
                    bar.faction = n
                    activeBar = bar
                elseif x < standingId then
                    bar:SetValue(standings[x].inverted and 0 or standings[x].value)
                else
                    bar:SetValue(x < 4 and standings[x].value or 0)
                end
            end
            return
        end
    end
    isWatching = false
end

function R:Init()
    
    local db = A["Profile"]["Options"][self.name]
    local texture = media:Fetch("statusbar", db["Texture"])
    local size = db["Size"]

    local reputation = A.frames.reputationBar or (function()
        local reputation = CreateFrame("Frame", T:frameName(self.name), A.frameParent)
        reputation.bars = {}
        reputation:RegisterEvent("UPDATE_FACTION")
        reputation:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
        reputation:SetScript("OnEvent", function(self, event, ...)
            setupBarValues(self)
            if activeBar then
                self.text:SetText(string.format("%s, %s (%d / %d)", activeBar.faction, activeBar.name, activeBar.current, activeBar.max))
            end

            if isWatching then
                self:Show()
            else
                self:Hide()
            end
        end)
        reputation:SetScript("OnEnter", function(self, userMoved)
            if userMoved then 
                GameTooltip:SetOwner(self)
                GameTooltip:AddLine(string.format("Currently at %s with %d / %d", activeBar.name, activeBar.current, activeBar.max), activeBar.color[1], activeBar.color[2], activeBar.color[3])
                GameTooltip:Show()
            end
        end)
        reputation:SetScript("OnLeave", function(self, userMoved)
            if userMoved then 
                GameTooltip:Hide()
            end
        end)

        for i = 1, 8 do
            local bar = CreateFrame("StatusBar", T:frameName(self.name, standings[i].name), reputation)
            bar:SetPoint("LEFT", i == 1 and reputation or reputation.bars[i-1], i == 1 and "LEFT" or "RIGHT", 0, 0)
            bar:SetSize((standings[i].value / total) * size["Width"], size["Height"])
            bar:SetMinMaxValues(0, standings[i].value)
            bar:SetStatusBarTexture(texture)
           
            local r, g, b = FACTION_BAR_COLORS[i].r, FACTION_BAR_COLORS[i].g, FACTION_BAR_COLORS[i].b

            bar:SetStatusBarColor(r, g, b)
            bar.color = { r, g, b }

            if standings[i].inverted then
                bar:SetReverseFill(true)
            end

            bar.bg = bar:CreateTexture(nil, "BORDER")
            bar.bg:SetAllPoints()
            bar.bg:SetTexture(texture)

            local mult = db["Background Multiplier"]
            bar.bg:SetVertexColor(r * mult, g * mult, b * mult)

            local textFrame = CreateFrame("Frame", nil, bar)
            textFrame:SetSize(bar:GetSize())
            textFrame:SetPoint("CENTER")
            textFrame:SetFrameLevel(2)
            
            local text = buildText(textFrame, 10):atCenter():outline():build()
            bar.text = text

            reputation.bars[i] = bar
        end

        local textFrame = CreateFrame("Frame", nil, reputation)
        textFrame:SetAllPoints()
        textFrame:SetFrameLevel(2)
        
        local text = buildText(textFrame, 11):atCenter():outline():build()
        reputation.text = text

        return reputation
    end)()

    local position = db["Position"]

    reputation:ClearAllPoints()
    local x, y = position["Offset X"], position["Offset Y"]

    reputation:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)
    reputation:SetSize(size["Width"], size["Height"])

    setupBarValues(reputation)

    U:CreateBackground(reputation, db, true)

    if not isWatching then
        reputation:Hide()
    else
        reputation.text:SetText(string.format("%s, %s (%d / %d)", activeBar.faction, activeBar.name, activeBar.current, activeBar.max))
    end

    ReputationBarMixin.ShouldBeVisible = function(self) return false end

    reputation.db = db

    A:CreateMover(reputation, db, self.name)
    A.frames.reputationBar = reputation
end

A.general:set("reputation", R)