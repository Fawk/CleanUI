local A, L = unpack(select(2, ...))
local E, T, media = A.enum, A.Tools, LibStub("LibSharedMedia-3.0")

local Standalone = {}

function Standalone:CreateDropdown(parent, options, selected, onItemClick, onHeaderClick)
	
	parent.options = A:OrderedTable()

	local top = CreateFrame("Button", nil, parent)
	top:SetPoint(E.regions.L, parent, E.regions.L, 0, 0)
	top:SetPoint(E.regions.R, parent, E.regions.R, 0, 0)
	top:SetBackdrop(E.backdrops.editboxborder)
	top:SetBackdropColor(0, 0, 0, 0.75)
    top:SetBackdropBorderColor(0.43, 0.43, 0.43, 1)
	top:SetHeight(20)

	parent.top = top

	local closedText = top:CreateFontString(nil, "OVERLAY")
	closedText:SetPoint(E.regions.TL, top, E.regions.TL, 0, 0)
	closedText:SetPoint(E.regions.TR, top, E.regions.TR, -24, 0)
	closedText:SetPoint(E.regions.B)
	closedText:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
	closedText:SetJustifyH(E.regions.R)

	parent.closedText = closedText

	top.openButtonTexture = top:CreateTexture(nil, "OVERLAY")
	top.openButtonTexture:SetTexture(media:Fetch("widget", "cui-dropdown-closed"))
	top.openButtonTexture:SetSize(16, 16)
	top.openButtonTexture:SetPoint(E.regions.R, top, E.regions.R, -2, 0)
	top.open = false

	local dropdownFrame = CreateFrame("Frame", nil, parent)
	dropdownFrame:SetFrameLevel(8)
	dropdownFrame:SetPoint(E.regions.TL, top, E.regions.BL, 0, -3)
	dropdownFrame:SetPoint(E.regions.TR, top, E.regions.BR, 0, -3)
	dropdownFrame:SetHeight((options:count() * 20))
	dropdownFrame:SetBackdrop(E.backdrops.editboxborder)
	dropdownFrame:SetBackdropColor(0.10, 0.10, 0.10, 1)
    dropdownFrame:SetBackdropBorderColor(0.43, 0.43, 0.43, 1)
	dropdownFrame:Hide()

	parent.dropdownFrame = dropdownFrame

	parent.Close = function(self, button, down)
		if button == "LeftButton" and not down then
			if self.top.open then 
				self.dropdownFrame:Hide()
			else
				self.dropdownFrame:Show()
			end
			self.top.open = not self.top.open
			if onHeaderClick then onHeaderClick() end
		end
	end

	top:SetScript("OnClick", function(self, button, down)
		parent:Close(button, down)
	end)

	for i = 1, options:count() do
		local key, name = unpack(options:get(i))
		local child = {}
		child.key = key
		child.name = name
		child.active = false
		child.SetActive = function(self) 
			for k = 1, parent.options:count() do
				parent.options:get(k).active = false
			end
			self.active = true
			closedText:SetText(self.name)
        	if onItemClick then onItemClick(self.name) end
		end
		parent.options:add(child)
	end

	for i = 1, parent.options:count() do
		local child = parent.options:get(i)
	    if child.key == selected then
	    	child:SetActive()
	    end
	end

	parent.GetActive = function(self)
		for i = 1, parent.options:count() do
			local str = parent.options:get(i)
			if str.active then
				return str
			end
		end
	end

	closedText:SetText(parent:GetActive().name)

	local relative = parent.dropdownFrame
    for i = 1, parent.options:count() do
    	local child = parent.options:get(i)
    	local createdOption = CreateFrame("Button", nil, parent.dropdownFrame)
    	createdOption:SetPoint(E.regions.T, relative, i == 1 and E.regions.T or E.regions.B, 0, i == 1 and -1 or 0)
    	createdOption:SetPoint(E.regions.R, parent.dropdownFrame, E.regions.R, -1, 0)
    	createdOption:SetPoint(E.regions.L, parent.dropdownFrame, E.regions.L, 1, 0)
    	createdOption:SetBackdrop(E.backdrops.editbox)
    	if child.active then
    		createdOption:SetBackdropColor(0.20, 0.20, 0.20, 1)
    	else
    		createdOption:SetBackdropColor(0.10, 0.10, 0.10, 1)
    	end
    	createdOption:SetHeight(20)

		createdOption:SetScript("OnClick", function(self, button, down)
			parent:GetActive():SetBackdropColor(0.10, 0.10, 0.10, 1)
			if button == "LeftButton" and not down then
				child:SetActive()
				parent:Close(button, down)
			end
		end)

		createdOption:SetScript("OnEnter", function(self, mouse)
			if mouse then 
				self:SetBackdropColor(0.20, 0.20, 0.20, 1)
			end
		end)

		createdOption:SetScript("OnLeave", function(self, mouse)
			if mouse then 
				if not child.active then
					self:SetBackdropColor(0.10, 0.10, 0.10, 1)
				end
			end
		end)

    	local text = createdOption:CreateFontString(nil, "OVERLAY")
    	text:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    	text:SetText(child.name)
    	text:SetJustifyH(E.directions.L)
    	text:SetPoint(E.regions.T)
    	text:SetPoint(E.regions.B)
    	text:SetPoint(E.regions.L, createdOption, E.regions.L, 5, 0)
    	text:SetPoint(E.regions.R)

    	child.SetBackdropColor = function(self, r, g, b, a) createdOption:SetBackdropColor(r, g, b, a) end

    	relative = createdOption
    end

end

A.StandaloneWidgets = Standalone