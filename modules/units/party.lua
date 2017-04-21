local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization

local Party = {}
local frameName = "Party"
 
function Party:Init()

	local db = A["Profile"]["Options"][frameName]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Party:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)
    Units:Add(Units:Get(frameName) or oUF:SpawnHeader(frameName))
    self:Update(Units:Get(frameName), db)
end
 
function Party:Setup(frame, db)
    if not db["Enabled"] then
        return frame:Disable()
    else
        frame:Enable()
    end
 
    local position, size, bindings = db["Position"], db["Size"], db["Key Bindings"]

    Units:Position(frame, position)
    frame:SetSize(size["Width"] * 5, size["Height"] * 5)
    Units:SetKeyBindings(frame, bindings)
    Units:UpdateElements(frame, db)
end
 
function Party:Update(frame, db)
    if not db["Enabled"] then
        return frame:Disable()
    else
        frame:Enable()
    end
 
    Units:UpdateElements(frame, db)
end

A.modules["party"] = Party