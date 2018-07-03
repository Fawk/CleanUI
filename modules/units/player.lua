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
    frame.orderedElements = A:OrderedMap()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB, db)
    end)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD", function(self)
        self:Update(UnitEvent.UPDATE_DB, db)
    end)

    A:CreateMover(frame, db, frameName)

    frame.Update = function(self, ...)
        NewPlayer:Update(self, ...)
    end

    -- Player specific elements
    A["Player Elements"]:foreach(function(key, element)
        element:Init(frame, db[key])
    end)

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

            A.modules.clickcast:Setup(self, db["Clickcast"])

            --[[ Background ]]--
            U:CreateBackground(self, db)

            self.orderedElements:foreach(function(key, obj)
                obj:Update(event, db[key])
            end)

            -- Player specific elements
            A["Player Elements"]:foreach(function(key, element)
                element:Init(frame, db[key])
            end)
        end
    end
end

-- https://jsfiddle.net/859zu65s/

A.modules["player"] = NewPlayer