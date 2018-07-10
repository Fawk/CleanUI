local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsDead = UnitIsDead
local UnitIsConnected = UnitIsConnected
local UnitName = UnitName
local UnitInRange = UnitInRange
local CreateFrame = CreateFrame

--[[ Lua ]]
local rand = math.random

--[[ Locals ]]
local elementName = "Status"
local Status = {}
A["Shared Elements"]:set(elementName, Status)

function Status:Init(parent)

    local db = parent.db[elementName]

    if (not db) then return end

    local status = parent.orderedElements:get(elementName)
    if (not status) then

        status = CreateFrame("Frame", parent:GetName().."_"..elementName, A.frameParent)

        status:SetParent(parent)
        status:SetFrameStrata("LOW")

        status.tags = A:OrderedTable()
        status.icons = A:OrderedTable()
        status.db = db

        status.Update = function(self, event, ...)
            Status:Update(self, event, ...)
        end

        status.timer = 0
        status:SetScript("OnUpdate", function(self, elapsed)
            self.timer = self.timer + elapsed
            if (self.timer > .5) then
                self:Update("OnUpdate", self.db, elapsed)
                self.timer = 0
            end
        end)
    end

    status:Update("OnUpdate", status.db)

    parent.orderedElements:set(elementName, status)
end

local function performAction(status, frame, parent, db, key, shouldAct)
    status[db["Action"]](status, frame, parent, db, key, shouldAct)
end

function Status:Update(...)

    local this = self

    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local parent = self:GetParent()
    local db = self.db or arg2

    local outofrange = db["Out of range"]
    local dead = db["Dead"]
    local offline = db["Offline"]
    local ghost = db["Ghost"]

    performAction(this, self, parent, outofrange, "Out of range", function()
        if UnitName(parent.unit, true) == UnitName("player", true) then
            return false
        else
            local inRange, checkedRange = UnitInRange(parent.unit)
            if checkedRange and not inRange then
                if (not UnitIsConnected(parent.unit)) then
                    return false
                else
                    return true
                end
            else
                return false
            end
        end
    end)
    performAction(this, self, parent, dead, "Dead", function()
        return UnitIsDead(parent.unit)
    end)
    performAction(this, self, parent, offline, "Offline", function()
        return not UnitIsConnected(parent.unit)
    end)
    performAction(this, self, parent, ghost, "Ghost", function()
        if UnitIsDeadOrGhost(parent.unit) then 
            return not UnitIsDead(parent.unit)
        end
    end)
end

function Status:Simulate(parent)
    self:Init(parent)
    local status = parent.orderedElements:get(elementName)
    status:SetScript("OnUpdate", nil)

    local this = self
    local db = status.db

    local waitFrame = CreateFrame("Frame")
    waitFrame.timer = 0
    waitFrame:SetScript("OnUpdate", function(self, elapsed)
        self.timer = self.timer + elapsed
        if (self.timer > 1) then

            local randomBool = function()
                return rand(1, 2) == 1 and true or false
            end

            performAction(this, status, parent, db["Out of range"], "Out of range", randomBool)
            performAction(this, status, parent, db["Dead"], "Dead", randomBool)
            performAction(this, status, parent, db["Offline"], "Offline", randomBool)
            performAction(this, status, parent, db["Ghost"], "Ghost", randomBool)

            waitFrame:SetScript("OnUpdate", nil)
        end
    end)
end

function Status:Modify(frame, parent, db, key, shouldAct)
    local settings = db["Settings"]
    local type = settings["Modify Type"]

    if (type == "Alpha") then
        if (shouldAct()) then
            parent:SetAlpha(tonumber(settings["Alpha Value"]) / 100)
        else
            parent:SetAlpha(1)
        end
    elseif (type == "Color") then
        if (shouldAct()) then
            if (not parent.oldBackdropColor) then
                parent.oldBackdropColor = parent:GetBackdropColor()
            end

            parent:SetBackdropColor(unpack(settings["Color"]))
        else
            if (parent.oldBackdropColor) then
                parent:SetBackdropColor(unpack(parent.oldBackdropColor))
            end
        end
    end
end

function Status:Present(frame, parent, db, key, shouldAct)
    local settings = db["Settings"]
    local type = settings["Present Type"]
    local position = settings["Position"]
    
    if (frame.tags[key]) then
        frame.tags[key]:Hide()
    end

    if (frame.icons[key]) then
        frame.icons[key]:Hide()
    end

    if (not shouldAct()) then return end

    if (type == "Text") then

        local fs = frame.tags[key] or parent:CreateFontString(nil, "OVERLAY")
        fs:SetFont(media:Fetch("font", "Default"), settings["Font Size"], "OUTLINE")
        fs:SetPoint(position["Local Point"], parent, position["Point"], position["Offset X"], position["Offset Y"])
        fs:SetTextColor(unpack(settings["Color"]))
        fs:SetText(key)

        frame.tags[key] = fs
        frame.tags[key]:Show()
    elseif (type == "Icon") then
        local size = settings["Icon Size"]

        local icon = frame.icons[key] or parent:CreateTexture(nil, "OVERLAY")
        icon:SetTexture(media:Fetch("icon", settings["Icon"]))
        icon:SetSize(size, size)
        icon:SetPoint(position["Local Point"], parent, position["Point"], position["Offset X"], position["Offset Y"])

        frame.icons[key] = icon
        frame.icons[key]:Show()
    end
end
