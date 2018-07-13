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
            S:Font(child.HeaderText, 11)
            for _,line in next, child.lines do
                S:Font(line.Text, 10)
            end
        end
    end
end

local Tracker = {}

function Tracker:Init()

    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then 
        LoadAddOn("Blizzard_ObjectiveTracker")
    end

    local db = A["Profile"]["Options"]["Objective Tracker"]
    local size = db["Size"]
    local position = db["Position"]
    local x, y = position["Offset X"], position["Offset Y"]

    ObjectiveTrackerFrame.db = db
    ObjectiveTrackerFrame:SetAlpha(0)
    ObjectiveTrackerFrame.ignoreFramePositionManager = true
    ObjectiveTrackerFrame:SetSize(size["Width"], size["Height"])
    ObjectiveTrackerFrame:ClearAllPoints()
    ObjectiveTrackerFrame:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)

    hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(self, lp, r, p, x1, y2)
		if (r ~= A.frameParent) then
			if (r.GetName and r:GetName():find("Mover")) then return end;
		    self:ClearAllPoints()
    		self:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)
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
        setBlockFonts(ObjectiveTrackerBlocksFrame)
    end)
    
    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", function(_, block)
        skinBlockItem(block)
        setBlockFonts(ObjectiveTrackerBlocksFrame)
    end)

    A:CreateMover(ObjectiveTrackerFrame, db, "Objective Tracker")
end

function Tracker:Update(event)

end

A.modules.objectivetracker = Tracker