local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

local Pet = {}
local frameName = "Pet"

function Pet:Init()

    local db = A["Profile"]["Options"][frameName]

    local frame = Units:Get(frameName) or A:CreateUnit(frameName)
    frame.GetDbName = function(self) return frameName end
    frame.db = db
    frame.orderedElements = A:OrderedMap()
    frame.tags = A:OrderedMap()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB, db)
    end)

    A:CreateMover(frame, db, frameName)

    frame.Update = function(self, ...)
        Pet:Update(self, ...)
    end

    frame:Update(UnitEvent.UPDATE_DB, db)

    return frame
end

function Pet:Update(...)
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

            for _,tag in next, db["Tags"] do
                Units:Tag(self, tag)
            end

            self.orderedElements:foreach(function(key, obj)
                obj:Update(event, db[key])
            end)
        end
    end
end

A.modules["pet"] = Pet