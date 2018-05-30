local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local Boss = {}
local frameName = "Boss"
Boss.updateFuncs = A:OrderedTable()

local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES

function Boss:Init()

	local db = A["Profile"]["Options"][frameName]
	local size = db["Size"]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Boss:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)

    self.container = self.container or Units:Get(frameName) or CreateFrame("Frame", T:frameName("Boss Container"), A.frameParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
    self.container:SetSize(size["Width"], size["Height"])
    self.container.db = db

    RegisterStateDriver(self.container, "visibility", "[@boss1,exists] show; hide")
    Units:Position(self.container, db["Position"])

	Units:Add(self.container, frameName)

    self.container.frames = self.container.frames or {}
    for i = 1, MAX_BOSS_FRAMES do
        local frame = self.container.frames[i] or oUF:Spawn(frameName..i, frameName..i)
        local anchor = self.container.frames[i - 1] or self.container
        local first = anchor == self.container

        if db["Orientation"] == "HORIZONTAL" then
            lp = "LEFT"
            p = T.reversedPoints[first and "RIGHT" or "LEFT"]
        else
            lp = "TOP"
            p = T.reversedPoints[first and "BOTTOM" or "TOP"]
        end

        frame:SetPoint(lp, anchor, p, db["Offset X"], db["Offset Y"])
        
        self.container.frames[i] = frame
        self:Update(frame, db)
    end

    self.container.UpdateUnits = function(self)
        for _,frame in next, self.frames do
            Boss:Update(frame, db)
        end
    end

    A:CreateMover(self.container, db, "Boss Header")
end

function Boss:Setup(frame, db)
    self:Update(frame, db)
    return frame
end

function Boss:Trigger()
    for i = 1, MAX_BOSS_FRAMES do
        local frame = self.container.frames[i]
        if frame then
            if frame.Buffs then frame.Buffs:ForceUpdate() end -- TODO: This is way too often and could be improved, fix this for all units
            if frame.Debuffs then frame.Debuffs:ForceUpdate() end
        end
    end
end

function Boss:Update(frame, db)
	if not db["Enabled"] then return end

    T:RunNowOrAfterCombat(function() 
        Units:SetupClickcast(frame, db["Clickcast"])
    end)

    frame:SetSize(db["Size"]["Width"], db["Size"]["Height"])
    Units:UpdateElements(frame, db)

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    Units:Tag(frame, "Name", db["Tags"]["Name"])

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        Units:Tag(frame, name, custom)
    end

    Units:CreateStatusBorder(frame, "Targeted", {
        ["Enabled"] = db["Highlight Target"],
        ["FrameLevel"] = 5,
        ["Color"] = A.colors.border.target, 
        ["Condition"] = function(self, elapsed)
            if self and self.unit and UnitExists("target") and UnitIsUnit(self.unit, "target") then
                self:SetAlpha(1)
            else
                self:SetAlpha(0)
            end
        end
    })

    self.updateFuncs:add(frame["StatusBorder"]["Targeted"]["Condition"])

    --[[ Background ]]--
    U:CreateBackground(frame, db)
end

A.modules["boss"] = Boss