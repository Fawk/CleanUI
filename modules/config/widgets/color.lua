local A, L = unpack(select(2, ...))
local E, T, media = A.enum, A.Tools, LibStub("LibSharedMedia-3.0")

A:Debug("Creating color widget")

local Color = {}

function Color:View(groupParent, container, creator)

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

    T.Desc:Set({ groupParent, groupParent.color }, groupParent, groupParent.name, groupParent.desc)

    if groupParent.direction == E.directions.H then   
        groupParent:SetHeight(20)
    else
        groupParent:SetHeight(20)
    end

    groupParent.SetEnabled = function(self, enabled)
        if enabled then
            self.color:Enable()
            self.color:GetFontString():SetTextColor(1, 1, 1)
        else
            self.color:Disable()
            self.color:GetFontString():SetTextColor(0.66, 0.66, 0.66, 0.3)
        end
    end

    return groupParent
end

function Color:Create(option, container, creator)

    local groupParent = CreateFrame("Frame", option.name.."_GROUPPARENT", container)

    self.name = option.name
    groupParent.type = option.type
    groupParent.name = option.name
    groupParent.desc = option.desc
    groupParent.order = option.order

    local color = CreateFrame("Button", nil, groupParent)
    color:SetSize(16, 16)
    color:SetPoint(E.regions.L)
    color:SetBackdrop(E.backdrops.editboxborder)
    color:SetBackdropBorderColor(0.67, 0.67, 0.67, 1)
    color:SetDisabledTexture(E.textures.colordisabled)

    local fo = color:CreateFontString()
    fo:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    fo:SetPoint(E.regions.L, color, E.regions.R, 5, 0)
    color:SetFontString(fo)
    color:SetText(option.name)

    color.GetColor = function(self) return self.r, self.g, self.b, self.a end
    color.SetColor = function(self, r, g, b, a) 
        self.r = r 
        self.g = g
        self.b = b
        self.a = a
        self:SetBackdropColor(self.r, self.g, self.b, self.a)
    end

    local optionValue
    if option.group then
        groupParent.group = option.groups
        optionValue = A.db[option.group.name][option.name]
    else
        optionValue = A.db[option.name]
    end

    color:SetColor(optionValue.r, optionValue.g, optionValue.b, optionValue.a)

    color:SetScript("OnClick", function(self, button, down)
        if button == "LeftButton" and not down then

            HideUIPanel(ColorPickerFrame)

            ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
            ColorPickerFrame:SetFrameLevel(self:GetFrameLevel() + 10)
            ColorPickerFrame:SetClampedToScreen(true)

            ColorPickerFrame.func = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                local a = 1 - OpacitySliderFrame:GetValue()
                color:SetColor(r, g, b, a)
            end

            ColorPickerFrame.hasOpacity = true
            ColorPickerFrame.opacityFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                local a = 1 - OpacitySliderFrame:GetValue()
                if ColorPickerFrame.ColorSwatch then 
                    ColorPickerFrame.ColorSwatch:SetVertexColor(1, 1, 1, a)
                end
            end

            ColorPickerFrame.cancelFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                local a = 1 - OpacitySliderFrame:GetValue()
                color:SetColor(r, g, b, a)
            end

            local r, g, b, a = self.r, self.g, self.b, self.a
            ColorPickerFrame.opacity = 1 - (a or 0)

            ColorPickerFrame:SetColorRGB(r, g, b)

            ColorPickerOkayButton:HookScript("OnClick", function() 
                creator:Update()
            end)

            ShowUIPanel(ColorPickerFrame)
        end
    end)

    groupParent.color = color
    
    function groupParent:SetValue(r, g, b, a)
        self.color:SetColor(r, g, b, a)
    end

    function groupParent:GetValue()
        local r, g, b, a = self.color:GetColor()
        return { r = r, g = g, b = b, a = a }
    end
    local result = option.enabledFunc and option:enabledFunc() or "Nope"

    groupParent.enabled = option.enabledFunc or function() return true end

    return self:View(groupParent, container, creator)
 
end

A:RegisterWidget("color", Color)