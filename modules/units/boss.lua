local A, L = unpack(select(2, ...))
local E, T, U,  Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

local Boss = {}
local frameName = "Boss"

local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES

function Boss:Init()

    local db = A["Profile"]["Options"][frameName]
    local size = db["Size"]

    self.container = self.container or Units:Get(frameName) or CreateFrame("Frame", T:frameName("Boss Container"), A.frameParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
    self.container:SetSize(size["Width"], size["Height"])
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

        if db["Orientation"] == "HORIZONTAL" then
            lp = "LEFT"
            p = T.reversedPoints[first and "RIGHT" or "LEFT"]
        else
            lp = "TOP"
            p = T.reversedPoints[first and "BOTTOM" or "TOP"]
        end

        frame:SetPoint(lp, anchor, p, db["Offset X"], db["Offset Y"])
        
        self.container.frames[i] = frame
        self:Update(frame, db)
    end

    self.container.UpdateUnits = function(self)
        for _,frame in next, self.frames do
            Boss:Update(frame, db)
        end
    end

    self.container:UpdateUnits()

    RegisterStateDriver(self.container, "visibility", "[@boss1,exists] show; hide")
    Units:Position(self.container, db["Position"])

    Units:Add(self.container, frameName)

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
A.modules["boss"] = Boss