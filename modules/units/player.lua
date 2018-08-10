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

    for i = 1, A.elements.player:len() do
        A.elements.player[i]:Init(frame)
    end

    return frame
end

function Player:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then

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
                A.general.clickcast:Setup(self, db.clickcast)
            end

            --[[ Background ]]--
            U:CreateBackground(self, db)

            for i = 1, self.tags:len() do
                if (not db.tags.list[self.tags(i)]) then
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

            for i = 1, self.orderedElements:len() do
                self.orderedElements[i]:Update(event)
            end

            -- Player specific elements
            for i = 1, A.elements.player:len() do
                A.elements.player[i]:Init(self)
            end
        end
    end
end

-- https://jsfiddle.net/859zu65s/

A.modules.player = Player