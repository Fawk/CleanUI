local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local Boss = {}
local frameName = "Boss"
Boss.updateFuncs = A:OrderedTable()

function Boss:Init()

	local db = A["Profile"]["Options"][frameName]
	local size = db["Size"]
    local castbar = db["Castbar"]
    local castbarEnabled = castbar["Enabled"]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Boss:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)

    self.container = self.container or Units:Get(frameName) or CreateFrame("Frame", T:frameName("Boss Container"), A.frameParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
    self.container:SetSize(size["Width"], size["Height"])

    RegisterStateDriver(self.container, "visibility", "[@boss1,exists] show; hide")
    Units:Position(self.container, db["Position"])

	Units:Add(self.container, frameName)

    self.container.frames = self.container.frames or {}
    for i = 1, MAX_BOSS_FRAMES do
        local frame = self.container.frames[i] or oUF:Spawn(frameName..i, frameName..i)
        local anchor = self.container.frames[i - 1] or self.container
        local lp, p = "TOP", "BOTTOM"
        local x, y = db["Offset X"], db["Offset Y"]

        if db["Orientation"] == "HORIZONTAL" then
            lp = "LEFT"
            p = anchor == self.container and T.reversedPoints["RIGHT"] or "RIGHT"
        else
            lp = "TOP"
            p = anchor == self.container and T.reversedPoints["BOTTOM"] or "BOTTOM"
        end

        frame:SetPoint(lp, anchor, p, x, y)
        
        self.container.frames[i] = frame
        self:Update(frame, db)
    end

    A:CreateMover(self.container, db, "Boss Header")
end

function Boss:Setup(frame, db)
    self:Update(frame, db)
    return frame
end

function Boss:Trigger()

end

function Boss:Update(frame, db)
	if not db["Enabled"] then return end

    T:RunNowOrAfterCombat(function() 
        Units:SetupClickcast(frame, db["Clickcast"])
    end)

    local position, size = db["Position"], db["Size"]

    frame:SetSize(size["Width"], size["Height"])
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
            if self and self.unit and UnitExists("target") and GetUnitName(self.unit, true) == GetUnitName("target", true) then
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