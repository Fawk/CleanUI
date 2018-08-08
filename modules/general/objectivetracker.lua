local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local S = A.Skins
local T = A.Tools
local media = LibStub("LibSharedMedia-3.0")

local function skinBlockItem(block)
    local item = block.itemButton
    if (item and not item.skinned) then
        item:SetSize(25, 25)
        item:SetNormalTexture(nil)
        item.icon:SetPoint("TOPLEFT", item, 2, -2)
        item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)
        item.Cooldown:SetAllPoints(item.icon)
        item.Count:ClearAllPoints()
        item.Count:SetPoint("TOPLEFT", 1, -1)
        S:Font(item.Count, 12)
        item.Count:SetShadowOffset(5, -5)
        item.skinned = true
    end
end

local function setBlockFonts(block)
    for _,child in next, { block:GetChildren() } do
        if (child.lines) then
            S:Font(child.HeaderText, 12, "SHADOW")
            for _,line in next, child.lines do
                S:Font(line.Text, 11, "SHADOW")
            end
        end
    end
end

local Tracker = {}

function Tracker:Init()

    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then 
        LoadAddOn("Blizzard_ObjectiveTracker")
    end

    local db = A.db.profile.general.objectiveTracker
    local size = db.size
    local position = db.position
    local x, y = position.x, position.y

    ObjectiveTrackerFrame.db = db
    ObjectiveTrackerFrame:SetAlpha(0)
    ObjectiveTrackerFrame.ignoreFramePositionManager = true
    ObjectiveTrackerFrame:SetMovable(true)
    ObjectiveTrackerFrame:SetUserPlaced(true)
    ObjectiveTrackerFrame:SetSize(size.width, size.height)
    ObjectiveTrackerFrame:ClearAllPoints()
    ObjectiveTrackerFrame:SetPoint(position.localPoint, A.frameParent, position.point, x, y)

    hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(self, lp, r, p, x1, y2)
		if (r ~= A.frameParent) then
			if (r.GetName and r:GetName():find("Mover")) then return end;
		    self:ClearAllPoints()
    		self:SetPoint(position.localPoint, A.frameParent, position.point, x, y)
    	end
    end)

    hooksecurefunc(ObjectiveTrackerFrame, "SetParent", function(self, parent)
    	if (parent ~= A.frameParent) then
    		self:SetParent(A.frameParent)
    	end
    end)

    T:delayedCall(function()
        if (ObjectiveTrackerBlocksFrameHeader ~= nil) then
            S:Kill(ObjectiveTrackerBlocksFrame.QuestHeader)
            S:Font(ObjectiveTrackerBlocksFrame.QuestHeader.Text, 12)
            S:Kill(ObjectiveTrackerBlocksFrame.AchievementHeader)
            S:Font(ObjectiveTrackerBlocksFrame.AchievementHeader.Text, 12)
            S:Kill(ObjectiveTrackerBlocksFrame.ScenarioHeader)
            S:Font(ObjectiveTrackerBlocksFrame.ScenarioHeader.Text, 12)

            S:Kill(BONUS_OBJECTIVE_TRACKER_MODULE.Header)
            S:Font(BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text, 11)
            S:Kill(WORLD_QUEST_TRACKER_MODULE.Header)
            S:Font(WORLD_QUEST_TRACKER_MODULE.Header.Text, 11)
            
            S:Font(ObjectiveTrackerFrame.HeaderMenu, 11)
            
            setBlockFonts(ObjectiveTrackerBlocksFrame)

            T:FadeIn(ObjectiveTrackerFrame)
        end
    end, 0.1)

    hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
        skinBlockItem(block)
    end)
    
    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", function(_, block)
        skinBlockItem(block)
    end)

    A:CreateMover(ObjectiveTrackerFrame, db, "Objective Tracker")

    local panel = CreateFrame("Frame", T:frameName("Panel"), A.frameParent)
    panel:SetSize(600, 50)
    panel:SetPoint("TOP")
    panel:SetBackdrop(A.enum.backdrops.editbox)
    panel:SetBackdropColor(0, 0, 0, 0.3)

    local map = C_Map.GetBestMapForUnit("player")
    local playerPos = C_Map.GetPlayerMapPosition(map, "player")

    local pois = {}
    for k,v in next, C_TaskQuest.GetQuestsForPlayerByMapID(map) do
        if (v.mapID == map) then
            local questName, questType = C_TaskQuest.GetQuestInfoByQuestID(v.questId)
            local distance = ((v.x - playerPos.x) ^ 2 + (v.y - playerPos.y) ^ 2) ^ 0.5

            local poi = {}
            poi.questName = questName
            poi.questId = v.questId
            poi.questType = questType
            poi.distance = distance

            table.insert(pois, poi)
        end
    end

    table.sort(pois, function(left, right) return left.distance < right.distance end)

    local visible = 3

    local relative = panel
    for i = 1, #pois do
        
        local poi = pois[i]
        
        local button = CreateFrame("Button", nil, panel)
        button.poi = poi

        button:SetScript("OnClick", function(self, b, d)
            if (not d) then
                if (b == "LeftButton") then
                    QuestMapFrame_OpenToQuestDetails(self.poi.questId)
                elseif (b == "RightButton") then

                end
            end
        end)

        local text = button:CreateFontString(nil, "OVERLAY")
        text:SetPoint("CENTER")
        S:Font(text, 10, "OUTLINE")
        text:SetText(poi.questName)

        button:SetSize(text:GetSize())

        if (relative == panel) then
            button:SetPoint("TOP", relative, "TOP", 0, -5)
        else
            button:SetPoint("TOP", relative, "BOTTOM", 0, -2)
        end
        
        relative = button

        if (i > visible) then
            button:Hide()
        end
    end
end

function Tracker:Update(event)

end

A.general:set("objectivetracker", Tracker)