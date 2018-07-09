local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local Units = A.Units
local buildText = A.TextBuilder
local CreateFrame = CreateFrame
local GetTexCoordsForRoleSmallCircle = GetTexCoordsForRoleSmallCircle
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local T = A.Tools

local elementName = "Group Role Indicator"
local Role = { name = elementName }
A["Shared Elements"]:set(elementName, Role)

function Role:Init(parent)
    local parentName = parent.GetDbName and parent:GetDbName() or parent:GetName()
    local db = A["Profile"]["Options"][parentName][elementName]

    if (not db) then return end

    local tbl =  parent.orderedElements:getChildByKey("key", elementName)
    local role = tbl and tbl.element or nil
    if (not role) then

        role = CreateFrame("Frame", parent:GetName().."_"..elementName, A.frameParent)
        role:SetParent(parent)
        role.db = db
        role.text = role:CreateFontString(nil, "ARTWORK")
        role.texture = role:CreateTexture(nil, "OVERLAY")
        role.texture:SetAllPoints()
        role.Update = function(self, event, ...)
            Role:Update(self, event, ...)
        end

        role:RegisterEvent("GROUP_ROSTER_UPDATE")
        role:RegisterEvent("PLAYER_ROLES_ASSIGNED")
        role:SetScript("OnEvent", function(self, event, ...)
            self:Update(event, ...)
        end)
    end

    role:Update(UnitEvent.UPDATE_DB, db)
    role:Update("GROUP_ROSTER_UPDATE")

    parent.orderedElements:set(elementName, role)
end

function Role:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local parent = self:GetParent()  
    local db = self.db or arg1
    local style = db["Style"]
    local size = db["Size"]
    local role = UnitGroupRolesAssigned(parent.unit)

    self:SetSize(size, size)
    Units:Position(self, db["Position"])
    
    self.text:Hide()
    self.texture:Hide()

    if (style == "Blizzard") then
        self.texture:Show()
        self.texture:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
        self.texture:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
    elseif (style == "Letter" or style == "Text") then
        local textStyle = db["Text Style"]
        local textExtra = "NONE"
        if (textStyle == "Outline") then
            textExtra = "OUTLINE"
            self.text:SetShadowColor(0, 0, 0, 0)
        elseif (textStyle == "Thick Outline") then
            textExtra = "THICKOUTLINE"
            self.text:SetShadowColor(0, 0, 0, 0)
        elseif (textStyle == "Shadow") then
            textExtra = "NONE"
            self.text:SetShadowOffset(1, -1)
            self.text:SetShadowColor(0, 0, 0)
        end
        self.text:SetFont(media:Fetch("font", "Default"), db["Text Size"], textExtra)
        self.text:SetText(style == "Letter" and role:sub(1, 1) or role:sub(1, 1)..role:sub(2):lower())
        self.text:SetTextColor(unpack(db["Text Color"]))
        self.text:SetAllPoints()
        self.text:Show()
    elseif (style == "Custom Texture") then
        self.texture:Show()
        self.texture:SetTexture(db["Texture"])
        self.texture:SetTexCoord(0, 1, 0, 1)
    end
end

local roles = { "TANK", "HEALER", "DAMAGER" }

function Role:Simulate(parent)
    local oldUnitGroupRolesAssigned = UnitGroupRolesAssigned

    
    
    UnitGroupRolesAssigned = oldUnitGroupRolesAssigned
end