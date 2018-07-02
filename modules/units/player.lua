local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown

local Player = {}
local frameName = "Player"

local NewPlayer = {}

function NewPlayer:Init()

    local db = A["Profile"]["Options"][frameName]

    local frame = Units:Get(frameName) or A:CreateUnit(frameName)
    frame.GetDbName = function(self) return frameName end
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
        NewPlayer:Update(self, ...)
    end

    frame:Update(UnitEvent.UPDATE_DB, db)

    return frame
end

function NewPlayer:Update(...)
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

function Player:Init()

	local db = A["Profile"]["Options"][frameName]
    Units:RegisterStyle(frameName, function(frame) 
        Player:Update(frame, db)
    end)

    local frame = Units:Get(frameName) or oUF:Spawn(frameName, frameName)
    frame.db = db
    Units:Add(frame)

    A:CreateMover(frame, db)
end
-- https://jsfiddle.net/859zu65s/
function Player:Setup(frame, db)
    T:RunNowOrAfterCombat(function()
        self:Update(frame, db)
    end)
    return frame
end

function Player:Trigger()
	local frame = Units:Get(frameName)
	if frame then
		if frame.Buffs then frame.Buffs:ForceUpdate() end -- TODO: This is way too often and could be improved, fix this for all units
		if frame.Debuffs then frame.Debuffs:ForceUpdate() end
		if frame.ClassIcons then frame.ClassIcons:ForceUpdate() end
	end
end
 
function Player:Update(frame, db)
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

	frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", function(self, ...) Units:UpdateElements(self, db) end)

	--[[ Background ]]--
	U:CreateBackground(frame, db)

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    Units:Tag(frame, "Name", db["Tags"]["Name"], 5)

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        Units:Tag(frame, name, custom)
    end
end

A.modules["player"] = NewPlayer