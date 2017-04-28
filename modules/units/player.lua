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
    Units:UpdateElements(frame, db)

    --[[ Bindings ]]--
    local formattedBindings = {}


    frame:SetAttribute("*type1", "macro")
    frame:SetAttribute("*macrotext1", string.format("/cast [@%s,help,nodead] Plea", frame.unit))
    frame:SetAttribute("shift-macrotext1", string.format("/cast [@%s,help,nodead] Shadow Mend", frame.unit))
    frame:SetAttribute("ctrl-macrotext1", string.format("/cast [@%s,help,nodead] Pain Suppression", frame.unit))
    frame:SetAttribute("alt-ctrl-macrotext1", string.format("/cast [@%s,help,nodead] Power Word: Shield", frame.unit))
    frame:SetAttribute("alt-ctrl-shift-macrotext1", string.format("/cast [@%s,help,nodead] Power Word: Radiance", frame.unit))
    frame:SetAttribute("ctrl-shift-type1", "target")

    Units:SetKeyBindings(frame, formattedBindings)

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    Units:Tag(frame, "Name", db["Tags"]["Name"])

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        Units:Tag(frame, name, custom)
    end
end

A.modules["player"] = Player