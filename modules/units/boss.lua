local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local Boss = {}
local frameName = "Boss"
Boss.frames = A:OrderedTable()

function Boss:Init()

	local db = A["Profile"]["Options"]["Boss Header"]
	local size = db["Size"]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Boss:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)

    local header = oUF:SpawnHeader(
        T:frameName("Boss Header"),
        nil,
        "[@boss1,exists] show; hide",
        "showPlayer",         false,
        "showSolo",           true,
        "showParty",          true,
        "showRaid",			  true,
        "point",              point,
        "yOffset",            db["Offset Y"],
        "xOffset",            db["Offset X"],
        "maxColumns",         maxColumns,
        "unitsPerColumn",     unitsPerColumn,
        "columnAnchorPoint",  anchorPoint,
        "oUF-initialConfigFunction", [[
        	self:SetWidth(%d)
        	self:SetHeight(%d)
        ]]:format(size["Width"], size["Height"])
    )

    self.container = self.container or CreateFrame("Frame", T:frameName("Boss Container"), A.frameParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
    self.container:SetSize(size["Width"], size["Height"])

    RegisterStateDriver(self.container, "visibility", "[@boss1,exists] show; hide")

    for i = 1, MAX_BOSS_FRAMES do
	    local frame = Units:Get(frameName..i) or oUF:Spawn(frameName..i, frameName..i)
	    Units:Add(frame)
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
		local frame = Units:Get(frameName..i)
		if frame then
			if frame.Buffs then frame.Buffs:ForceUpdate() end -- TODO: This is way too often and could be improved, fix this for all units
			if frame.Debuffs then frame.Debuffs:ForceUpdate() end
			if frame.ClassIcons then frame.ClassIcons:ForceUpdate() end
		end
	end
end

function Boss:Update(frame, db)
	if not db["Enabled"] then return end

    T:RunNowOrAfterCombat(function() 
        Units:SetupClickcast(frame, db["Clickcast"])
    end)

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