local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local _G = _G

A:Debug("Creating radiobutton widget")

local E, T = A.Enum, A.Tools

local R = {}

function R:View(groupParent, container, creator)

	local first = groupParent.radioChildren:first()

	local relative = groupParent
	for i = 1, groupParent.radioChildren:count() do
		
		local radio = groupParent.radioChildren:get(i)
		radio:SetSize(24, 24)
		radio:SetText(radio.name)

		if groupParent.direction == E.directions.H then
			-- TODO: IMPLEMENT HORIZONTAL SUPPORT AND AUTOMATICALLY CHECK IF NUMBER OF OPTIONS + KEY VALUE EXCEEDS THE WIDTH OF THE CONTAINER, IF SO THEN SET TO VERTICAL AND CONTINUE
		else
			radio:SetPoint(E.regions.TL, relative, i == 1 and E.regions.TL or E.regions.BL, 0, 0)
			local text = T.FontString:setFirstInRegionAndGet(radio, E.regions.L, radio, E.regions.R, 0, 0)
		end

		relative = radio
	end

	local previousOption = creator:GetPreviousOption(groupParent.order)

    local titleFrame = CreateFrame("Frame", nil, container)
    titleFrame:SetPoint(E.regions.TL, previousOption or container, previousOption and E.regions.BL or E.regions.TL, 10, -5)
    titleFrame:SetPoint(E.regions.TR, previousOption or container, previousOption and E.regions.BR or E.regions.TR, -10, -5)
    titleFrame:SetHeight(20)

    local title = titleFrame:CreateFontString()
    title:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    title:SetJustifyH(E.directions.L)
    title:SetText(groupParent.name)
    title:SetAllPoints()

	T.Desc:Set({ titleFrame }, titleFrame, groupParent.name, groupParent.desc)

    groupParent:SetPoint(E.regions.TL, titleFrame, E.regions.BL, 0, 0)
    groupParent:SetPoint(E.regions.TR, titleFrame, E.regions.BR, 0, 0)

	if groupParent.direction == E.directions.H then
		
	else
		groupParent:SetHeight(groupParent.radioChildren:count() * first:GetHeight())
	end

	function groupParent:SetValue(key)
		self.radioChildren:getBy("key", key, 0):Click()
	end

	function groupParent:GetValue()
		return self:GetChecked()
	end
	
	return groupParent
end

function R:Create(option, container, creator)

	local groupParent = CreateFrame("Frame", option.name.."_GroupParent", container)
	groupParent.radioChildren = A:OrderedTable()

	local optionName = option.name
	local desc = option.desc
	local direction = option.direction
	local radioOptions = option.options

	self.name = optionName
	groupParent.name = optionName
	groupParent.direction = direction
	groupParent.desc = desc
	groupParent.order = option.order

	for i = 1, radioOptions:count() do
		local radioOption = radioOptions:get(i)
		local key, name = unpack(radioOption)
		local radio = CreateFrame("CheckButton", "Radio".."_"..name, groupParent)

		radio:SetNormalTexture(media:Fetch("widget", "cui-radio-unchecked"))
		radio:SetCheckedTexture(media:Fetch("widget", "cui-radio-checked"))

		local fo = groupParent:CreateFontString()
		fo:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
		radio:SetFontString(fo)

		radio:SetScript("OnClick", function(self, button, down)
			local children = groupParent.radioChildren
			for i = 1, children:count() do
				local child = children:get(i)
				child:SetChecked(false)
			end
			self:SetChecked(true)
			creator:Update()
		end)

		radio.name = name
		radio.key = key
		radio.options = radioOption
		groupParent.radioChildren:add(radio)

	end

	local active = groupParent.radioChildren:getBy("key", A.Database:GetStoredValueForKey(optionName), 0)
	active:SetChecked(true)

	groupParent.GetChecked = function(self)
		for i = 1, self.radioChildren:count() do
			local child = self.radioChildren:get(i)
			if child:GetChecked() then 
				return child.key
			end
		end
	end

	A:Debug("Running View function on widget of type:", option.type)
	return self:View(groupParent, container, creator)

end

A:RegisterWidget("radiobutton", R)