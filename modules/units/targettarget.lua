local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown

local TargetTarget = {}
local frameName = "Target of Target"
local unitName = "TargetTarget"

function TargetTarget:Init()

    local db = A["Profile"]["Options"][frameName]

    local frame = Units:Get(frameName) or A:CreateUnit(unitName)
    frame.GetDbName = function(self) return frameName end
    frame.db = db
    frame.orderedElements = A:OrderedMap()
    frame.tags = A:OrderedMap()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB, db)
    end)

    A:CreateMover(frame, db, frameName)

    frame.Update = function(self, ...)
        TargetTarget:Update(self, ...)
    end

    frame:Update(UnitEvent.UPDATE_DB, db)

    return frame
end

function TargetTarget:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then
        self.super:Update(...)

        -- Update player specific things based on the event
        if (event == UnitEvent.UPDATE_DB) then

            local db = self.db or arg2
            local position, size = db["Position"], db["Size"]

            if (not InCombatLockdown()) then
                Units:Position(self, position)
                self:SetSize(size["Width"], size["Height"])
                self:SetAttribute("*type1", "target")
                self:SetAttribute("*type2", "togglemenu")
                A.general.clickcast:Setup(self, db["Clickcast"])
            end

            --[[ Bindings ]]--
            self:RegisterForClicks("AnyUp")

            --[[ Background ]]--
            U:CreateBackground(self, db)

            self.tags:foreach(function(key, tag)
                if (not db["Tags"][key]) then
                    tag:Hide()
                    self.tags:remove(key)
                end
            end)

            for name,tag in next, db["Tags"] do
                Units:Tag(self, name, tag)
            end

            self:ForceTagUpdate()

            self.orderedElements:foreach(function(key, obj)
                obj:Update(event, db[key])
            end)
        end
    end
end

A.modules["Target of Target"] = TargetTarget