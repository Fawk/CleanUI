local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame

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
        A:GetName().."_"..frameName.."Header",
        nil,
        "party",
        "showPlayer",         db["Show Player"],
        "showSolo",           false,
        "showParty",          true,
        "point",              point,
        "yOffset",            db["Offset Y"],
        "xOffset",            db["Offset X"],
        "maxColumns",         maxColumns,
        "unitsPerColumn",     unitsPerColumn,
        "columnAnchorPoint",  anchorPoint,
        "oUF-initialConfigFunction", ([[
          self:SetWidth(%d)
          self:SetHeight(%d)
        ]]):format(size["Width"], size["Height"])
    )

    local partyContainer = Units:Get(frameName)
    if not partyContainer then
        
        partyContainer = CreateFrame("Frame", A:GetName().."_"..frameName.."Container", A.frameParent)
        
        partyContainer.UpdateSize = function(self, db) 
            if InCombatLockdown() then return end
            local x, y = db["Offset X"], db["Offset Y"]
            local w, h = ((size["Width"] * GetNumGroupMembers()) + ((GetNumGroupMembers()-1) * x)), size["Height"]
            if db["Orientation"] == "VERTICAL" then
                w = size["Width"]
                h = ((size["Height"] * GetNumGroupMembers()) + ((GetNumGroupMembers()-1) * y))
            end
            self:SetSize(w, h)
        end

        partyContainer.UpdateUnits = function(self)
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

        partyContainer:RegisterEvent("GROUP_ROSTER_UPDATE")
        partyContainer:SetScript("OnEvent", function(self, event) 
            if event == "GROUP_ROSTER_UPDATE" then
                self:UpdateSize(db)
                self:UpdateUnits()
            end
        end)

        -- partyContainer.timer = 0
        -- partyContainer:SetScript("OnUpdate", function(self, elapsed)
        --     self.timer = self.timer + elapsed
        --     if self.timer > 0.05 then
        --         for i = 1, 5 do 
        --             local uf = partyHeader:GetAttribute("child"..i)
        --             if uf and uf.unit or uf:GetAttribute("unit") then
        --                 if UnitExists("target") then
        --                     local unit = uf.unit or uf:GetAttribute("unit")
        --                     local name = GetUnitName(unit, true)
        --                     if name == GetUnitName("target", true) then
        --                         uf:SetTargeted(true)
        --                     else
        --                         uf:SetTargeted(false)
        --                     end
        --                 else
        --                     if uf.targetedFrame:IsShown() then
        --                         uf:SetTargeted(false)
        --                     end
        --                 end
        --             end
        --         end
        --         self.timer = 0
        --     end
        -- end)

        partyContainer:UpdateUnits()

        Units:Add(partyContainer, frameName)
    end

    Units:Position(partyContainer, db["Position"])
    partyContainer:UpdateSize(db)
    A:CreateMover(partyContainer, db)

    partyHeader:SetParent(partyContainer)
    partyHeader:SetAllPoints()
end
 
function Party:Setup(frame, db)
    self:Update(frame, db)
    return frame
end
 
function Party:Update(frame, db)
    if InCombatLockdown() then return end

    if not db["Enabled"] then
        return frame:Hide()
    else
        frame:Show()
    end

    local size, bindings = db["Size"], db["Key Bindings"]

    frame:SetSize(size["Width"], size["Height"])
    Units:SetKeyBindings(frame, bindings)
    Units:UpdateElements(frame, db)

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

    Units:CreateStatusBorder(frame, "Targeted", {
        ["Enabled"] = db["Highlight Target"],
        ["FrameLevel"] = 5,
        ["Color"] = A.colors.border.target, 
        ["Condition"] = function(self, elapsed)
            self.timer = self.timer + elapsed
            if self.timer > 0.05 then
                if UnitExists("target") and GetUnitName(self.unit, true) == GetUnitName("target", true) then
                    self:SetAlpha(1)
                else
                    self:SetAlpha(0)
                end
                self.timer = 0
            end
        end
    })

    Units:CreateStatusBorder(frame, "Debuff", {
        ["Enabled"] = db["Show Debuff Border"],
        ["FrameLevel"] = 5,
        ["Condition"] = function(self, elapsed) 
            self.timer = self.timer + elapsed
            if self.timer > 0.05 then

                self.timer = 0
            end
        end
    })
end

A.modules["party"] = Party