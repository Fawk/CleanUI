local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

local Player = {}
local frameName = "Player"

function Player:Init()

    local db = A.db.profile.units[frameName:lower()]

    local frame = Units:Get(frameName) or A:CreateUnit(frameName)
    frame.GetDbName = function(self) return frameName end
    frame.db = db
    frame.orderedElements = A:OrderedMap()
    frame.tags = A:OrderedMap()
    frame:SetScript("OnShow", function(self)
        self:Update(UnitEvent.UPDATE_DB)
    end)

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_TALENT_UPDATE")
    frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    frame:SetScript("OnEvent", function(self, event, ...)
        self:Update(UnitEvent.UPDATE_DB)
    end)

    frame.Update = function(self, ...)
        Player:Update(self, ...)
    end

    Units:Add(frame, frame:GetDbName())
    Units:Position(frame, db.position)
    
    frame:Update(UnitEvent.UPDATE_IDENTIFIER)
    frame:Update(UnitEvent.UPDATE_DB)

    A:CreateMover(frame, db, frameName)

    A["Player Elements"]:foreach(function(key, element)
        element:Init(frame)
    end)

    return frame
end

function Player:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then
        
        self.super:Update(self, UnitEvent.UPDATE_IDENTIFIER)

        self.super:Update(...)

        -- Update player specific things based on the event
        if (event == UnitEvent.UPDATE_DB) then
            
            local db = self.db or arg2

            --[[ Bindings ]]--
            self:RegisterForClicks("AnyUp")

            if (not InCombatLockdown()) then
                Units:Position(self, db.position)
                self:SetSize(db.size.width, db.size.height)
                self:SetAttribute("*type1", "target")
                self:SetAttribute("*type2", "togglemenu")
                A.general:get("clickcast"):Setup(self, db.clickcast)
            end

            --[[ Background ]]--
            U:CreateBackground(self, db)

            self.tags:foreach(function(key, tag)
                if (not db.tags[key]) then
                    if (tag) then
                        tag:Hide()
                    end
                    self.tags:remove(key)
                end
            end)

            for name,tag in next, db.tags do
                Units:Tag(self, name, tag)
            end

            self:ForceTagUpdate()

            self.orderedElements:foreach(function(key, obj)
                obj:Update(event, db[key])
            end)

            -- Player specific elements
            A["Player Elements"]:foreach(function(key, element)
                element:Init(self)
            end)
        end
    end
end

-- https://jsfiddle.net/859zu65s/

A.modules:set("player", Player)