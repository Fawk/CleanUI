local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

local Boss = {}
local frameName = "Boss"

local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES

function Boss:Init()

    local db = A.db.profile.units[frameName:lower()]

    self.container = self.container or Units:Get(frameName) or CreateFrame("Frame", T:frameName("Boss Container"), A.frameParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
    self.container:SetSize(db.size.width, db.size.height)
    self.container.db = db
    self.container.frames = self.container.frames or {}
    
    for i = 1, MAX_BOSS_FRAMES do
        
        local frame = self.container.frames[i] or A:CreateUnit(frameName..i)
        frame.db = db
        frame.GetDbName = function(self) return frameName end
        frame.orderedElements = A:OrderedMap()
        frame.tags = A:OrderedMap()
        frame:SetParent(self.container)

        frame.Update = function(self, ...)
            Boss:Update(self, ...)
        end
        
        frame:SetScript("OnShow", function(self)
            self:Update(UnitEvent.UPDATE_DB, db)
        end)

        local anchor = self.container.frames[i - 1] or self.container
        local first = anchor == self.container

        local lp, p
        if db.orientation == "HORIZONTAL" then
            lp = "LEFT"
            p = T.reversedPoints[first and "RIGHT" or "LEFT"]
        else
            lp = "TOP"
            p = T.reversedPoints[first and "BOTTOM" or "TOP"]
        end

        frame:SetPoint(lp, anchor, p, db.x, db.y)
        
        self.container.frames[i] = frame
        self:Update(frame, db)
    end

    self.container.UpdateUnits = function(self)
        for _,frame in next, self.frames do
            Boss:Update(frame, db)
        end
    end

    RegisterStateDriver(self.container, "visibility", "[@boss1,exists] show; hide")
    Units:Position(self.container, db.position)

    Units:Add(self.container, frameName)

    self.container:UpdateUnits()

    A:CreateMover(self.container, db, "Boss Header")

    return container
end

function Boss:Update(...)
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (self.super) then
        self.super:Update(...)

        -- Update player specific things based on the event
        if (event == UnitEvent.UPDATE_DB) then

            local db = self.db or arg2

            if (not InCombatLockdown()) then
                Units:Position(self, position)
                self:SetSize(db.size.width, db.size.height)
                self:SetAttribute("*type1", "target")
                self:SetAttribute("*type2", "togglemenu")
                A.general:get("clickcast"):Setup(self, db.clickcast)
            end

            --[[ Bindings ]]--
            self:RegisterForClicks("AnyUp")

            --[[ Background ]]--
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
A.modules:set("boss", Boss)