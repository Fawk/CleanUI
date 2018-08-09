local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown

local TargetTarget = {}
local frameName = "Target of Target"
local unitName = "TargetTarget"

function TargetTarget:Init()

    local db = A.db.profile.units[unitName:lower()]

    local frame = Units:Get(frameName) or A:CreateUnit(unitName)
    frame.GetDbName = function(self) return frameName end
    frame.db = db
    frame.orderedElements = A:OrderedMap()
    frame.tags = A:OrderedMap()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB)
    end)

    frame.Update = function(self, ...)
        TargetTarget:Update(self, ...)
    end

    Units:Add(frame, frame:GetDbName())
    Units:Position(frame, db.position)
    
    frame:Update(UnitEvent.UPDATE_IDENTIFIER)
    frame:Update(UnitEvent.UPDATE_DB)

    A:CreateMover(frame, db, frameName)

    return frame
end

function TargetTarget:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then
        self.super:Update(...)

        -- Update player specific things based on the event
        if (event == UnitEvent.UPDATE_DB) then

            local db = self.db

            if (not InCombatLockdown()) then
                Units:Position(self, db.position)
                self:SetSize(db.size.width, db.size.height)
                self:SetAttribute("*type1", "target")
                self:SetAttribute("*type2", "togglemenu")
                A.general.clickcast:Setup(self, db.clickcast)
            end

            --[[ Bindings ]]--
            self:RegisterForClicks("AnyUp")

            --[[ Background ]]--
            U:CreateBackground(self, db, false)

            for i = 1, #self.tags do
                if (not db.tags.list[self.tags(i)) then
                    if (self.tags[i]) then
                        self.tags[i]:Hide()
                    end
                    self.tags[i] = nil
                end
            end

            for name,tag in next, db.tags.list do
                Units:Tag(self, name, tag)
            end

            self:ForceTagUpdate()

            for i = 1, #self.orderedElements do
                self.orderedElements[i]:Update(event)
            end
        end
    end
end

A.modules:set("Target of Target", TargetTarget)