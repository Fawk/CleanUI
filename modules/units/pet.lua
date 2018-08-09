local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

local Pet = {}
local frameName = "Pet"

function Pet:Init()

    local db = A.db.profile.units[frameName:lower()]

    local frame = Units:Get(frameName) or A:CreateUnit(frameName)
    frame.GetDbName = function(self) return frameName end
    frame.db = db
    frame.orderedElements = A:OrderedMap()
    frame.tags = A:OrderedMap()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB)
    end)

    frame.Update = function(self, ...)
        Pet:Update(self, ...)
    end

    Units:Add(frame, frame:GetDbName())
    Units:Position(frame, db.position)
    
    frame:Update(UnitEvent.UPDATE_IDENTIFIER)
    frame:Update(UnitEvent.UPDATE_DB)

    A:CreateMover(frame, db, frameName)

    return frame
end

function Pet:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then
        self.super:Update(...)

        if (event == UnitEvent.UPDATE_DB) then

            local db = self.db
            
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
                obj:Update(event)
            end)
        end
    end
end

A.modules:set("pet", Pet)