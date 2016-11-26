local A, L = unpack(select(2, ...))
local E, T, media = A.enum, A.Tools, LibStub("LibSharedMedia-3.0")

A:Debug("Creating toggle widget")

local Toggle = {}

function Toggle:View(groupParent, container, creator)

    local previousOption
    if groupParent.group then
        local groupChildren = groupParent.group.children
        if groupChildren:count() >= 1 then 
            previousOption = groupChildren:last()
        else
            previousOption = groupParent.group.title
        end
    else
        previousOption = creator:GetPreviousOption(groupParent.order)
    end

    groupParent:SetPoint(E.regions.T, previousOption or container, previousOption and E.regions.B or E.regions.T, 0, not previousOption and -25 or -5)

    groupParent:SetPoint(E.regions.L, container, E.regions.L, groupParent.group and 40 or 20, 0)
    groupParent:SetPoint(E.regions.R, container, E.regions.R, groupParent.group and -40 or -20, 0)

    T.Desc:Set({ groupParent, groupParent.toggle }, groupParent, groupParent.name, groupParent.desc)

    if groupParent.direction == E.directions.H then
        groupParent:SetHeight(20)
    else
        groupParent:SetHeight(20)
    end

    local toggle = groupParent.toggle

    groupParent.SetEnabled = function(self, enabled)
        if enabled then
            toggle:Enable()
            toggle:GetFontString():SetTextColor(1, 1, 1)
        else
            toggle:Disable()
            toggle:GetFontString():SetTextColor(0.66, 0.66, 0.66, 0.3)
        end
    end    

    return groupParent
end

function Toggle:Create(option, container, creator)

    local groupParent = CreateFrame("Frame", option.name.."_GROUPPARENT", container)

    self.name = option.name
    groupParent.name = option.name
    groupParent.direction = option.direction
    groupParent.desc = option.desc
    groupParent.order = option.order
    groupParent.dependentWidgets = option.dependentWidgets

    local toggle = CreateFrame("CheckButton", nil, groupParent)
    toggle:SetPoint(E.regions.L)
    toggle:SetSize(16, 16)
    toggle:SetNormalTexture(media:Fetch("widget", "cui-checkbox-unchecked"))
    toggle:SetCheckedTexture(media:Fetch("widget", "cui-checkbox-checked"))
    toggle:SetDisabledTexture(media:Fetch("widget", "cui-checkbox-disabled-unchecked"))
    toggle:SetDisabledCheckedTexture(media:Fetch("widget", "cui-checkbox-disabled-checked"))

    local fo = groupParent:CreateFontString()
    fo:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    fo:SetPoint(E.regions.L, toggle, E.regions.R, 5, 0)
    toggle:SetFontString(fo)
    toggle:SetText(option.name)

    local optionValue
    if option.group then
        groupParent.group = option.group
        optionValue = option.group.db[option.name]
    else
        optionValue = A.db[option.name]
    end

    toggle:SetChecked(optionValue)
    groupParent.toggle = toggle
    
    function groupParent:SetValue()
        self:SetChecked(not self:GetChecked()) 
        creator:Update()
    end

    function groupParent:GetValue()
        return toggle:GetChecked()
    end

    toggle:SetScript("PostClick", function(self, button, down)
        if button == "LeftButton" and not down then
            creator:Update()
        end
    end)

    groupParent.enabled = option.enabledFunc or function() return true end

    return self:View(groupParent, container, creator)
 
end

A:RegisterWidget("toggle", Toggle)