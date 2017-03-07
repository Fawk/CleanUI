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
    Units:AddFrame(Units:GetFrame(frameName) or oUF:SpawnHeader(frameName))
    self:Update(Units:GetFrame(frameName), db)
end
 
function Party:Setup(frame, db)
    if not db["Enabled"] then
        return frame:Disable()
    else
        frame:Enable()
    end
 
    local position, size, bindings = db["Position"], db["Size"], db["Key Bindings"]

    frame:SetAttribute("showParty", true)
 
    Units:Position(frame, position)
    frame:SetSize(size["Width"], size["Height"])
    Units:SetKeyBindings(frame, bindings)
    Units:UpdateElements(frame, db["Elements"])

    self:CreateFrame(frame, db)
end
 
function Party:Update(frame, db)
    if not db["Enabled"] then
        return frame:Disable()
    else
        frame:Enable()
    end
 
    Units:UpdateElements(frame, db["Elements"])
    self:UpdateFrame()
end

function Party:CreateFrame(frame, db)

end

function Party:UpdateFrame()

end

A.modules["party"] = Party