local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local Units = A.Units
local buildText = A.TextBuilder
local CreateFrame = CreateFrame
local GetTexCoordsForRoleSmallCircle = GetTexCoordsForRoleSmallCircle
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local T = A.Tools

local elementName = "role"
local Role = {}
A.elements.shared[elementName] = Role

function Role:Init(parent)

    local db = parent.db[elementName]

    if (not db) then return end

    local role = parent.orderedElements[elementName]
    if (not role) then

        role = CreateFrame("Frame", parent:GetName().."_"..elementName, A.frameParent)
        role:SetParent(parent)
        role.db = db
        role.noTags = true
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

    parent.orderedElements[elementName] = role
end

function Role:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local parent = self:GetParent()  
    local db = self.db or arg1
    
    parent:Update(UnitEvent.UPDATE_IDENTIFIER)
    local role = UnitGroupRolesAssigned(parent.unit)

    self:SetSize(db.size, db.size)
    Units:Position(self, db.position)
    
    self.text:Hide()
    self.texture:Hide()

    if (db.style == "Blizzard") then
        self.texture:Show()
        self.texture:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
        self.texture:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
    elseif (db.style == "Letter" or style == "Text") then
        local textExtra = "NONE"
        if (db.textStyle == "Outline") then
            textExtra = "OUTLINE"
            self.text:SetShadowColor(0, 0, 0, 0)
        elseif (db.textStyle == "Thick Outline") then
            textExtra = "THICKOUTLINE"
            self.text:SetShadowColor(0, 0, 0, 0)
        elseif (db.textStyle == "Shadow") then
            textExtra = "NONE"
            self.text:SetShadowOffset(1, -1)
            self.text:SetShadowColor(0, 0, 0)
        end
        self.text:SetFont(media:Fetch("font", "Default"), db.textSize, textExtra)
        self.text:SetText(db.style == "Letter" and role:sub(1, 1) or role:sub(1, 1)..role:sub(2):lower())
        self.text:SetTextColor(T:unpackColor(db.color))
        self.text:SetAllPoints()
        self.text:Show()
    elseif (db.style == "Custom Texture") then
        self.texture:Show()
        self.texture:SetTexture(db.texture)
        self.texture:SetTexCoord(0, 1, 0, 1)
    end
end

local roles = { "TANK", "HEALER", "DAMAGER" }

function Role:Simulate(parent)
    local oldUnitGroupRolesAssigned = UnitGroupRolesAssigned

    UnitGroupRolesAssigned = function(self)
        return roles[math.random(1, 3)]
    end

    self:Init(parent)
    
    UnitGroupRolesAssigned = oldUnitGroupRolesAssigned
end