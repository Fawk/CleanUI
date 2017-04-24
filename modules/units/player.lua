local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization

local Player = {}
local frameName = "Player"
 
function Player:Init()

	local db = A["Profile"]["Options"][frameName]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Player:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)
    Units:Add(Units:Get(frameName) or oUF:Spawn(frameName, frameName))
end
-- https://jsfiddle.net/859zu65s/
function Player:Setup(frame, db)
    self:Update(frame, db)
    return frame
end
 
function Player:Update(frame, db)
    if not db["Enabled"] then
        return frame:Hide()
    else
        frame:Show()
    end

    local position, size, bindings = db["Position"], db["Size"], db["Key Bindings"]

    Units:Position(frame, position)
    frame:SetSize(size["Width"], size["Height"])
    Units:SetKeyBindings(frame, bindings)
    Units:UpdateElements(frame, db)

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    T:Tag(frame, "Name", db["Tags"]["Name"])

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        T:Tag(frame, name, custom)
    end
end

A.modules["player"] = Player