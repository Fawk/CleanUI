local A, L = unpack(select(2, ...))
local E, T, media = A.enum, A.Tools, LibStub("LibSharedMedia-3.0")

A:Debug("Creating slider widget")

local S = {}

function S:View(groupParent, container, creator)

    local slider, valueBox = groupParent.slider, groupParent.valueBox

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

    local titleFrame = CreateFrame("Frame", nil, container)
    titleFrame:SetPoint(E.regions.T, previousOption or container, previousOption and E.regions.B or E.regions.T, 0, -5)

    titleFrame:SetPoint(E.regions.L, container, E.regions.L, groupParent.group and 40 or 20, 0)
    titleFrame:SetPoint(E.regions.R, container, E.regions.R, groupParent.group and -40 or -20, 0)

    titleFrame:SetHeight(20)

    local title = titleFrame:CreateFontString()
    title:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    title:SetJustifyH(E.regions.C)
    title:SetText(groupParent.name)
    title:SetAllPoints()
    groupParent.title = title

    T.Desc:Set({ groupParent, slider, valueBox }, groupParent, groupParent.name, groupParent.desc)

    groupParent:SetPoint(E.regions.TL, titleFrame, E.regions.BL, 0, 20)
    groupParent:SetPoint(E.regions.TR, titleFrame, E.regions.BR, 0, 20)

    groupParent.titleFrame = titleFrame

    if groupParent.direction == E.directions.H then   
        groupParent:SetHeight(slider:GetHeight() + valueBox:GetHeight() + 30)
    else
        groupParent:SetHeight(slider:GetHeight())
    end

    function groupParent:SetValue(value)
        self.slider:SetValue(value)
        self.valueBox:SetText(value)
    end

    function groupParent:GetValue()
        return self.valueBox:GetText()
    end

    self.controls = { valueBox, slider }
    self.texts = { valueBox, groupParent.minText, groupParent.maxText, groupParent.title }
    self.textures = { slider.active, slider:GetThumbTexture() }
    self.backdrops = { valueBox, slider }

    groupParent.SetEnabled = function(self, enabled)
        if enabled then
            T.Controls:setEnabled(S.controls, true)
            T.Backdrops:setColors(S.backdrops, 0, 0, 0, 0.75, 0.43, 0.43, 0.43, 1)
            T.Textures:setColors(S.textures, 0.67, 0.67, 0.67, 1)
            T.FontString:setColors(S.texts, 1, 1, 1)
            self:SetScript("OnMouseWheel", self.OnMouseWheel)
        else
            T.Controls:setEnabled(S.controls, false)
            T.Backdrops:setColors(S.backdrops, 0, 0, 0, 0.3, 0, 0, 0, 0.3)
            T.Textures:setColors(S.textures, 0.66, 0.66, 0.66, 0.3)
            T.FontString:setColors(S.texts, 0.66, 0.66, 0.66, 0.3)
            self:SetScript("OnMouseWheel", nil)
        end
    end

     hooksecurefunc(groupParent, "Hide", function(self)
        self.titleFrame:Hide()
    end)
    
    hooksecurefunc(groupParent, "Show", function(self)
        self.titleFrame:Show()
    end)

    return groupParent
end

function S:Create(option, container, creator)

    local name, desc, direction, min, max, defaultValue, order = option.name, option.desc, option.direction, option.min, option.max, option.defaultValue, option.order
 
    self.name = name

    local groupParent = CreateFrame("Frame", name.."_GROUPPARENT", container)
    T.Table:shallowCopy(option, groupParent)

    local optionValue
    if option.group then
        groupParent.group = option.group
        optionValue = option.group.db[name]
    else
        optionValue = A.db[name]
    end

    function groupParent:Notify()
        if self.group then
            self.group:Notify()
        else
            for _,subscriber in pairs(self.subscribers) do
                if subscriber.Update then 
                    subscriber:Update(self:GetValue())
                end
            end
        end
    end

    local slider = CreateFrame("Slider", name.."_SLIDER", groupParent)
    slider:SetOrientation(direction)
    slider:SetThumbTexture(media:Fetch("widget", "cui-slider-thumb-texture"))
    slider:GetThumbTexture():SetSize(16, 16)
    slider:SetMinMaxValues(min, max)
    slider:SetBackdrop(E.backdrops.editboxborder)
    slider:SetBackdropBorderColor(0.43, 0.43, 0.43, 1)
    slider:SetBackdropColor(0, 0, 0, 0.75)
    slider:SetValue(tonumber(optionValue))
    slider.min = min
    slider.max = max

    slider.active = slider:CreateTexture(nil, "OVERLAY")
    slider.active:SetTexture(E.backdrops.editbox.bgFile)
    slider.active:SetVertexColor(1, 1, 1, 0.7)
    slider.active:SetPoint(E.regions.T, slider, E.regions.T, 0, -2)
    slider.active:SetPoint(E.regions.B, slider, E.regions.B, 0, 2)
    slider.active:SetPoint(E.regions.L, slider, E.regions.L, 2, 0)
    slider.active:SetPoint(E.regions.R, slider:GetThumbTexture(), E.regions.L, 2, 0)

    local minText, maxText = groupParent:CreateFontString(nil, "OVERLAY"), groupParent:CreateFontString(nil, "OVERLAY")
    
    minText:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    minText:SetText(min)
    minText:SetPoint(E.regions.TL, slider, E.regions.BL, 0, -3)
    
    maxText:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    maxText:SetText(max)
    maxText:SetPoint(E.regions.TR, slider, E.regions.BR, 0, -3)

    groupParent.minText = minText
    groupParent.maxText = maxText

    local valueBox = CreateFrame("EditBox", nil, groupParent)
    valueBox:SetBackdrop(E.backdrops.editboxborder)
    valueBox:SetAutoFocus(false)
    valueBox:SetSize(50, 16)
    valueBox:SetBackdropColor(0, 0, 0, 0.75)
    valueBox:SetBackdropBorderColor(0.43, 0.43, 0.43, 1)
    valueBox:SetText(optionValue)
    valueBox:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    valueBox:SetMultiLine(false)
    valueBox:SetMaxLetters(6)
    local text = T.FontString:setFirstInRegionAndGet(valueBox, E.regions.L, valueBox, E.regions.R, 0, 0)
    text:SetJustifyH(E.directions.C)

    if direction == E.directions.H then
        slider:SetPoint(E.regions.L, groupParent, E.regions.L, 0, 0)
        slider:SetPoint(E.regions.R, groupParent, E.regions.R, 0, 0)
        slider:SetHeight(6) -- TODO: WILL USE SOME DEFAULT VALUES HERE THAT WE STORE SOMEWHERE
        valueBox:SetPoint(E.regions.T, slider, E.regions.B, 0, -4)
    else
        slider:SetPoint(E.regions.T)
        slider:SetPoint(E.regions.B)
        slider:SetWidth(6) -- TODO: WILL USE SOME DEFAULT VALUES HERE THAT WE STORE SOMEWHERE
    end

    slider:SetScript("OnValueChanged", function(self, value)
        local value = floor(value * 100 + 0.5) / 100
        valueBox:SetText(value)
        self.active:SetPoint(E.regions.R, self:GetThumbTexture(), E.regions.L, 2, 0)
        groupParent:Notify()
        creator:Update()
    end)
 
    valueBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        slider:SetValue(value or 0)
        groupParent:Notify()
        creator:Update()
    end)

    valueBox:SetScript("OnEscapePressed", function(self)
        valueBox:ClearFocus()
    end)
    
    groupParent:SetScript("OnMouseWheel", function(self, v)
        local value = self.slider:GetValue()
        if v > 0 then
            value = math.min(value + (self.step or 5), self.max)
        else
            value = math.max(value - (self.step or 5), self.min)
        end
        self:Notify()
        self.slider:SetValue(value)
    end)
    groupParent.OnMouseWheel = groupParent:GetScript("OnMouseWheel")

    groupParent.slider = slider
    groupParent.valueBox = valueBox

    groupParent.enabled = option.enabledFunc or function() return true end

    return self:View(groupParent, container, creator)
 
end

A:RegisterWidget("slider", S)