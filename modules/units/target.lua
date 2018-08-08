local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown

local Target = {}
local frameName = "Target"

local Target = {}

function Target:Init()

    local db = A.db.profile.units[frameName:lower()]

    local frame = Units:Get(frameName) or A:CreateUnit(frameName)
    frame.GetDbName = function(self) return frameName end
    frame.db = db
    frame.orderedElements = A:OrderedMap()
    frame.tags = A:OrderedMap()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB)
    end)

    A:CreateMover(frame, db, frameName)

    frame.Update = function(self, ...)
        Target:Update(self, ...)
    end

    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:SetScript("OnEvent", function(self, ...)
        self:Update(UnitEvent.UPDATE_DB)
    end)

    Units:Add(frame, frame:GetDbName())
    Units:Position(frame, db.position)
    
    frame:Update(UnitEvent.UPDATE_IDENTIFIER)
    frame:Update(UnitEvent.UPDATE_DB)

    A:CreateMover(frame, db, frameName)

    return frame
end

function Target:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then
        self.super:Update(...)

        self.super:Update(self, UnitEvent.UPDATE_IDENTIFIER)

        if (event == UnitEvent.UPDATE_DB) then

            local db = self.db or arg2

            if (not InCombatLockdown()) then
                Units:Position(self, db.position)
                self:SetSize(db.size.width, db.size.height)
                self:SetAttribute("*type1", "target")
                self:SetAttribute("*type2", "togglemenu")
                A.general:get("clickcast"):Setup(self, db.clickcast)
            end

            self:RegisterForClicks("AnyUp")

            U:CreateBackground(self, db)

            self.tags:foreach(function(key, tag)
                if (not db.tags.list[key]) then
                    if (tag) then
                        tag:Hide()
                    end
                    self.tags:remove(key)
                end
            end)
            for name,tag in next, db.tags.list do
                Units:Tag(self, name, tag)
            end

            self:ForceTagUpdate()

            self.orderedElements:foreach(function(key, obj)
                obj:Update(event, db[key])
            end)
        end
    end
end

A.modules:set("target", Target)