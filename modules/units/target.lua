local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown

local Target = {}
local frameName = "Target"

local NewTarget = {}

function NewTarget:Init()

    local db = A["Profile"]["Options"][frameName]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        NewTarget:Update(frame, UnitEvent.UPDATE_DB, db)
    end)
    oUF:SetActiveStyle(frameName)

    local frame = Units:Get(frameName) or A:CreateUnit(frameName)
    frame.db = db
    frame.orderedElements = A:OrderedTable()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB, db)
    end)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD", function(self)
        self:Update(UnitEvent.UPDATE_DB, db)
    end)

    A:CreateMover(frame, db)

    frame.Update = function(self, ...)
        NewTarget:Update(self, ...)
    end

    frame:Update(UnitEvent.UPDATE_DB, db)

    return frame
end

function NewTarget:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then
        self.super:Update(...)

        -- Update player specific things based on the event
        if (event == UnitEvent.UPDATE_DB) then

            local db = self.db or arg2
            local position, size = db["Position"], db["Size"]

            Units:Position(self, position)
            self:SetSize(size["Width"], size["Height"])

            --[[ Bindings ]]--
            self:RegisterForClicks("AnyUp")
            self:SetAttribute("*type1", "target")
            self:SetAttribute("*type2", "togglemenu")

            Units:SetupClickcast(self, db["Clickcast"])

            --[[ Background ]]--
            U:CreateBackground(self, db)

            self.orderedElements:foreach(function(obj)
                obj.element:Update(event, db[obj.key])
            end)
        end
    end
end

 
function Target:Init()

	local db = A["Profile"]["Options"][frameName]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Target:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)

    local frame = Units:Get(frameName) or oUF:Spawn(frameName, frameName)
    Units:Add(frame)

    A:CreateMover(frame, db)
end
-- https://jsfiddle.net/859zu65s/
function Target:Setup(frame, db)
    T:RunNowOrAfterCombat(function()
        self:Update(frame, db)
    end)
    return frame
end

function Target:Trigger()
	local frame = Units:Get(frameName)
	if frame then
		if frame.Buffs then frame.Buffs:ForceUpdate() end
		if frame.Debuffs then frame.Debuffs:ForceUpdate() end
	end
end
 
function Target:Update(frame, db)
	if not db["Enabled"] then return end

    local position, size = db["Position"], db["Size"]

    Units:Position(frame, position)
    frame:SetSize(size["Width"], size["Height"])
    Units:UpdateElements(frame, db)

    --[[ Bindings ]]--
    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute("*type1", "target")
    frame:SetAttribute("*type2", "togglemenu")

    Units:SetupClickcast(frame, db["Clickcast"])
	
	--[[ Background ]]--
	U:CreateBackground(frame, db)

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    Units:Tag(frame, "Name", db["Tags"]["Name"], 4)

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        Units:Tag(frame, name, custom, 4)
    end
end

A.modules["target"] = Target