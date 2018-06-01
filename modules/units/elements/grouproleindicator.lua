local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local Units = A.Units
local buildText = A.TextBuilder
local CreateFrame = CreateFrame
local GetTexCoordsForRoleSmallCircle = GetTexCoordsForRoleSmallCircle
local T = A.Tools

local elementName = "Group Role Indicator"
local Role = { name = elementName }
A["Shared Elements"]:add(Role)

function Role:Init(parent)
    local parentName = parent:GetName()
    local db = A["Profile"]["Options"][parentName][elementName]

    if (not db) then return end

    local tbl =  parent.orderedElements:getChildByKey("key", elementName)
    local role = tbl and tbl.element or nil
    if (not role) then

        role = CreateFrame("Frame", T:frameName(parentName, elementName), A.frameParent)
        role:SetParent(parent)
        role.db = db
        role.text = role:CreateFontString(nil, "OVERLAY")
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

    parent.orderedElements:add({ key = elementName, element = role })
end

function Role:Update(...)
    local self, event, arg1, arg2, arg3, arg4, arg5 = ...
    local parent = self:GetParent()  
    local db = self.db or arg1
    local style = db["Style"]
    local role = UnitGroupRolesAssigned(self.unit)

    self:SetSize(db["Size"], db["Size"])
    Units:Position(self, db["Position"])

    if (style == "Blizzard") then
        self.texture:Show()
        self.texture:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
        self.texture:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
        self.text:Hide()
    elseif (style == "Letter" or style == "Text") then
        local textStyle = db["Text style"]
        local builder = buildText(self, db["Text size"]):alignAll()
        if (textStyle == "Outline") then
            builder:outline()
        elseif (textStyle == "Thick Outline") then
            builder:thickOutline()
        elseif (textStyle == "Shadow") then
            builder:shadow()
        end
        self.text = builder:build()
        self.text:SetText(style == "Letter" and role:sub(1, 1) or role:sub(1, 1)..role:sub(2):lower())
        self.text:SetTextColor(unpack(db["Text Color"]))
        self.texture:Hide()
    elseif (style == "Custom Texture") then
        self.texture:Show()
        self.texture:SetTexture(db["Texture"])
        self.texture:SetTexCoord(0, 1, 0, 1)
        self.text:Hide()
    end
end

function GroupRoleIndicator(frame, db)
	local role = frame.GroupRoleIndicator or (function()
		local role = CreateFrame("Frame", T:frameName(frame:GetName(), elementName), frame)
		role:SetSize(14, 14)
		role:SetFrameLevel(4)
		local texture = role:CreateTexture(nil, "OVERLAY")
        role.texture = texture
        role.PostUpdate = function(self, role)
            self.texture:SetTexture(media:Fetch("icon", role))
            self.texture:SetTexCoord(0, 1, 0, 1)
        end
        role.SetTexCoord = function(self) end
		return role
	end)()

	Units:Position(role, db["Position"])
	role.texture:SetAllPoints()

	frame.GroupRoleIndicator = role
end

A["Elements"]:add({ name = elementName, func = GroupRoleIndicator })