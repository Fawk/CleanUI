local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsDead = UnitIsDead
local UnitIsConnected = UnitIsConnected
local UnitName = UnitName
local UnitInRange = UnitInRange
local CreateFrame = CreateFrame

local elementName = "Status"

local Status = { name = elementName }
A["Shared Elements"]:add(Status)

local colors = {
    ["red"] = "ff0000",
    ["yellow"] = "ffff00",
    ["white"] = "ffffff",
    ["green"] = "00ff00",
    ["black"] = "000000",
    ["blue"] = "0000ff",
    ["orange"] = "ff9900"
}

--Implement custom states (text, icon, modify color/alpha for the frame) for out-of-range, dead, offline, ghost
function Status:Init(parent)

    local parentName = parent:GetName()
    local db = A["Profile"]["Options"][parentName][elementName]

    local tbl =  parent.orderedElements:getChildByKey("key", elementName)
    local status = tbl and tbl.element or nil
    if (not status) then

        status = CreateFrame("Frame", T:frameName(parentName, elementName), A.frameParent)

        status:SetParent(parent)
        status:SetFrameStrata("LOW")

        status.tags = A:OrderedTable()
        status.icon = status:CreateTexture(nil, "OVERLAY")
        status.db = db

        status.Update = function(self, event, ...)
            Status:Update(self, event, ...)
        end

        status:SetScript("OnUpdate", function(self, elapsed)
            self:Update("OnUpdate", self.db, elapsed)
        end)
    end

    status:Update("OnUpdate", self.db)

    parent.orderedElements:add({ key = elementName, element = status })
end

--[[

    Party/Raid = {
        ["Status"] = {
            ["Out of range"] = {
                ["Action"] = "Modify",
                ["Settings"] = "[alpha:50]"
            },
            ["Dead"] = {
                ["Action"] = "Present",
                ["Settings"] = "[text,color:ff0000,outline]"
            },
            ["Offline"] = {
                ["Action"] = "Present",
                ["Settings"] = "[text,color:ff0000,outline]"
            },
            ["Ghost"] = {
                ["Action"] = "Present",
                ["Settings"] = "[text,color:ffff00,outline]"
            }
        }
    }

]]
function Status:Update(...)

    local this = self

    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local parent = self:GetParent()
    local db = self.db or arg2

    local outofrange = db["Out of range"]
    local dead = db["Dead"]
    local offline = db["Offline"]
    local ghost = db["Ghost"]

    this[outofrange["Action"]](parent, outofrange)
    this[dead["Action"]](parent, outofrange)
    this[offline["Action"]](parent, outofrange)
    this[ghost["Action"]](parent, outofrange)
end


function Status:Modify(parent, db)

    local settings = db["Settings"]

    -- find target:something or use parent
    local target = parent
    if (settings:find("target")) then
        -- evaluate target
        local t = settings:match("target:[%w]+"):explode(":")[2]
        if (parent[t]) then
            target = parent[t]
        elseif (parent[t:fupper()]) then
            target = parent[t:fupper()]
        end
    end

    if (settings:find("alpha")) then
        local alpha = settings:match("[0-9][0-9][0-9]?")
    elseif (settings:find("color")) then
        local color = settings:match("[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]")

    end

end

function Status:Present(parent, db)

    local settings = db["Settings"]
    if (settings:find("text")) then

    elseif (settings:find("icon")) then

    end

end
