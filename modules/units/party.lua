local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization

local Party = {}
local frameName = "Party"
local partyHeader, partyFrames = nil, {}
 
function Party:Init()

	local db = A["Profile"]["Options"][frameName]
    local maxColumns, unitsPerColumn = 5, 1

    local size, point, anchorPoint = db["Size"], "BOTTOM", "TOP"

    if db["Orientation"] == "VERTICAL" then
        maxColumns = 1
        unitsPerColumn = 5
        point = "LEFT"
        anchorPoint = "RIGHT"
    else
        maxColumns = 5
        unitsPerColumn = 1
    end

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        partyFrames[frame:GetName()] = Party:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)

    partyHeader = oUF:SpawnHeader(
        A:GetName().."_"..frameName,
        nil,
        "party",
        "showPlayer",         true,
        "showSolo",           false,
        "showParty",          true,
        "point",              point,
        "yOffset",            0,
        "xOffset",            2,
        "maxColumns",         maxColumns,
        "unitsPerColumn",     unitsPerColumn,
        "columnAnchorPoint",  anchorPoint,
        "oUF-initialConfigFunction", ([[
          self:SetWidth(%d)
          self:SetHeight(%d)
        ]]):format(size["Width"], size["Height"])
    )

    A["partyContainer"] = CreateFrame("Frame", A:GetName().."_PartyContainer", A.frameParent)
    A["partyContainer"]["UpdateSize"] = function(self, db) 
        local x, y = unpack({ 2, 0 })
        local w, h = ((size["Width"] * GetNumGroupMembers()) + ((GetNumGroupMembers()-1) * x)), size["Height"]
        if db["Orientation"] == "VERTICAL" then
            w = size["Width"]
            h = ((size["Height"] * GetNumGroupMembers()) + ((GetNumGroupMembers()-1) * y))
        end
        self:SetSize(w, h)
    end
    A["partyContainer"]:SetPoint("CENTER", A.frameParent, "CENTER", 200, -200)
    A["partyContainer"]:UpdateSize(db)
    A["partyContainer"]:RegisterEvent("GROUP_ROSTER_UPDATE")
    A["partyContainer"]:SetScript("OnEvent", function(self, event) 
        if event == "GROUP_ROSTER_UPDATE" then
            local i = 1
            for name, frame in next, partyFrames do
                local uf = partyHeader:GetAttribute("child"..i)
                if not uf then break end
                uf:RegisterForClicks("AnyUp")
                uf.unit = uf:GetAttribute("unit")
                Party:Update(frame, db)
                i = i + 1
            end
        end
    end)

    partyHeader:SetParent(A["partyContainer"])
    partyHeader:SetAllPoints()

end
 
function Party:Setup(frame, db)
    self:Update(frame, db)
    return frame
end
 
function Party:Update(frame, db)
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

A.modules["party"] = Party