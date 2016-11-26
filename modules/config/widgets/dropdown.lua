local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

A:Debug("Creating dropdown widget")

local E, T, D = A.enum, A.Tools, {}

function D:View(groupParent, container, creator)

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
    titleFrame:SetPoint(E.regions.T, previousOption or container, previousOption and E.regions.B or E.regions.T, 0, not previousOption and -25 or -5)
    
	titleFrame:SetPoint(E.regions.L, container, E.regions.L, groupParent.group and 40 or 20, 0)
	titleFrame:SetPoint(E.regions.R, container, E.regions.R, groupParent.group and -40 or -20, 0)

    titleFrame:SetHeight(20)

    local title = titleFrame:CreateFontString(nil, "OVERLAY")
    title:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    title:SetJustifyH(E.regions.L)
    title:SetText(groupParent.name)
    title:SetAllPoints()

    T.Desc:Set({ titleFrame, groupParent.top }, groupParent, groupParent.name, groupParent.desc)

    groupParent:SetPoint(E.regions.TL, titleFrame, E.regions.BL, 0, -2)
    groupParent:SetPoint(E.regions.TR, titleFrame, E.regions.BR, 0, -2)

    groupParent.titleFrame = titleFrame

    if groupParent.direction == E.directions.H then   
        groupParent:SetHeight(20)
    else
        groupParent:SetHeight(20)
    end

	function groupParent:SetValue(key)
		self.options:getBy("key", key, 0):SetActive()
	end

	function groupParent:GetValue()
		return self:GetActive().key
	end

	function groupParent:SetEnabled(enabled)
		if enabled then
			self.top:Enable()
			self.top:SetBackdropColor(0, 0, 0, 0.75)
    		self.top:SetBackdropBorderColor(0.43, 0.43, 0.43, 1)
            self.closedText:SetTextColor(1, 1, 1)
            self.top.openButtonTexture:SetVertexColor(1, 1, 1, 1)
            title:SetTextColor(1, 1, 1)
		else
			self.top:Disable()
			self.closedText:SetTextColor(0.66, 0.66, 0.66, 0.3)
			self.top:SetBackdropColor(0, 0, 0, 0.33)
    		self.top:SetBackdropBorderColor(0, 0, 0, 0.33)
    		self.top.openButtonTexture:SetVertexColor(1, 1, 1, 0.33)
    		title:SetTextColor(0.66, 0.66, 0.66, 0.3)
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

function D:Create(option, container, creator)

	local groupParent = CreateFrame("Frame", option.name.."_GroupParent", container)

	self.name = option.name
	groupParent.name = option.name
	groupParent.direction = option.direction
	groupParent.desc = option.desc
	groupParent.order = option.order

	local optionValue
    if option.group then
        groupParent.group = option.group
        optionValue = option.group.db[option.name]
    else
        optionValue = A.db[option.name]
    end

    A.StandaloneWidgets:CreateDropdown(groupParent, option.options, optionValue, function() creator:Update() end, nil)

    groupParent.enabled = option.enabledFunc or function() return true end

	A:Debug("Running View function on widget of type:", option.type)
	return self:View(groupParent, container, creator)

end

A:RegisterWidget("dropdown", D)