local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum

function string.trim()
  return (self:gsub("^%s*(.-)%s*$", "%1"))
end

local object = {}

function object:center(x, y)
	self.c = { x, y }
	return self
end
function object:top(x, y)
	self.t = { x, y }
	return self
end
function object:bottom(x, y)
	self.b = { x, y }
	return self
end
function object:left(x, y)
	self.l = { x, y }
	return self
end
function object:right(x, y)
	self.r = { x, y }
	return self
end
function object:topRight(x, y)
	self.tr = { x, y }
	return self
end
function object:topLeft(x, y)
	self.tl = { x, y }
	return self
end
function object:bottomRight(x, y)
	self.br = { x, y }
	return self
end
function object:bottomLeft(x, y)
	self.bl = { x, y }
	return self
end
function object:alignAll()
	self.alignAllPoints = true
	return self
end
function object:alignWith(relative)
	self.aw = relative
	return self
end
function object:atCenter()
	self.atC = true
	return self
end
function object:atTop()
	self.atT = true
	return self
end
function object:atBottom()
	self.atB = true
	return self
end
function object:atLeft()
	self.atL = true
	return self
end
function object:atRight()
	self.atR = true
	return self
end
function object:atTopRight()
	self.atTR = true
	return self
end
function object:atTopLeft()
	self.atTL = true
	return self
end
function object:atBottomRight()
	self.atBR = true
	return self
end
function object:atBottomLeft()
	self.atBL = true
	return self
end
function object:againstCenter()
	self.againstC = true
	return self
end
function object:againstTop()
	self.againstT = true
	return self
end
function object:againstBottom()
	self.againstB = true
	return self
end
function object:againstLeft()
	self.againstL = true
	return self
end
function object:againstRight()
	self.againstR = true
	return self
end
function object:againstTopRight()
	self.againstTR = true
	return self
end
function object:againstTopLeft()
	self.againstTL = true
	return self
end
function object:againstBottomRight()
	self.againstBR = true
	return self
end
function object:againstBottomLeft()
	self.againstBL = true
	return self
end
function object:noOffsets()
	self.zeroOffsets = true
end
function object:x(offset)
	self.xo = offset
	return self
end
function object:y(offset)
	self.yo = offset
	return self
end
function object:below(relative)
	self:alignWith(relative)
	self:atTop()
	self:againstBottom()
	return self
end
function object:above(relative)
	self:alignWith(relative)
	self:atBottom()
	self:againstTop()
	return self
end
function object:rightOf(relative)
	self:alignWith(relative)
	self:atLeft()
	self:againstRight()
	return self
end
function object:leftOf(relative)
	self:alignWith(relative)
	self:atRight()
	self:againstLeft()
	return self
end
function object:size(w, h)
	if not h then
		local relative = w or self.parent
		self.w = relative:GetWidth()
		self.h = relative:GetHeight()
	else
		self.w = w
		self.h = h
	end
	return self
end
function object:activeCondition(func)
	self.activeCond = func
	return self
end
function object:onValueChanged(func)
	self.onValueChangedFunc = func
	return self
end


object.__index = object

local widget = setmetatable({}, object)
widget.__index = object

local points = {
	["atC"] = E.regions.C,
	["atT"] = E.regions.T,
	["atB"] = E.regions.B,
	["atL"] = E.regions.L,
	["atR"] = E.regions.R,
	["atTL"] = E.regions.TL,
	["atTR"] = E.regions.TR,
	["atBL"] = E.regions.BL,
	["atBR"] = E.regions.BR,
	["againstC"] = E.regions.C,
	["againstT"] = E.regions.T,
	["againstB"] = E.regions.B,
	["againstL"] = E.regions.L,
	["againstR"] = E.regions.R,
	["againstTL"] = E.regions.TL,
	["againstTR"] = E.regions.TR,
	["againstBL"] = E.regions.BL,
	["againstBR"] = E.regions.BR
}

local function setPoints(o, frame)

	frame:ClearAllPoints()

	if o.alignAllPoints then
		frame:SetAllPoints()
	else

		local lp, p = nil, nil
		for point, region in next, points do
			if o[point] then 
				if string.sub(point, 0, 2) == "at" then
					lp = region
				else
					p = region
				end
			end
		end

		local x, y = o.zeroOffsets and 0 or (o.xo ~= nil and o.xo or 0), o.zeroOffsets and 0 or (o.yo ~= nil and o.yo or 0)

		if not lp and p then
			lp = p
		elseif not p and lp then
			p = lp
		end

		if lp and p then
			frame:SetPoint(lp, o.aw or o.parent, p, x, y)
		else
			if o.c then
				x, y = unpack(o.c)
				frame:SetPoint(E.regions.C, x or 0, y or 0)
			end
			if o.t then
				x, y = unpack(o.t)
				frame:SetPoint(E.regions.T, x or 0, y or 0)
			end
			if o.b then
				x, y = unpack(o.b)
				frame:SetPoint(E.regions.B, x or 0, y or 0)
			end
			if o.l then
				x, y = unpack(o.l)
				frame:SetPoint(E.regions.L, x or 0, y or 0)
			end
			if o.r then
				x, y = unpack(o.r)
				frame:SetPoint(E.regions.R, x or 0, y or 0)
			end
			if o.tr then
				x, y = unpack(o.tr)
				frame:SetPoint(E.regions.TR, x or 0, y or 0)
			end
			if o.tl then
				x, y = unpack(o.tr)
				frame:SetPoint(E.regions.TL, x or 0, y or 0)
			end
			if o.br then
				x, y = unpack(o.br)
				frame:SetPoint(E.regions.BR, x or 0, y or 0)
			end
			if o.bl then
				x, y = unpack(o.bl)
				frame:SetPoint(E.regions.BL, x or 0, y or 0)
			end
		end
	end
end

local function shortenValue(value, decimals)
    if value > 1e9 then
        return string.format("%."..decimals.."f", value/1e9).."B"
    elseif value > 1e6 then
        return string.format("%."..decimals.."f", value/1e6).."M"
    elseif value > 1e3 then
        return string.format("%."..decimals.."f", value/1e3).."K"
    else
        return value
    end
end

local tags = {
	["health:deficit"] = {
		events = { "UNIT_HEALTH_FREQUENT", "UNIT_MAXHEALTH" },
		func = function(self)
			local health = self.parent.currentMaxHealth - self.parent.currentHealth
			return health > 0 and string.format("-%d", shortenValue(health, 0)) or ""
		end
	}
}

local function registerEvents(textObj, init)
	local hasEvents = false
	local newText = textObj.tag
	for tag, tbl in next, tags do
		if (newText:find("%["..tag.."%]")) then
			for _,event in next, tbl.events do 
				textObj:RegisterEvent(event)
			end
			hasEvents = true
			if (init) then
				newText = newText:replace("["..tag.."]", tbl:func())
			end
		end
	end

	if (hasEvents) then
		textObj:SetScript("OnEvent", function(self, event, ...)
			local newText = self.tag
			for tag, tbl in next, tags do
				newText = newText:replace("["..tag.."]", tbl:func())
			end
			self:SetText(newText)
		end)
	end

	self:SetText(newText)	
end

local function TextBuilder(parent, sizeInPerc)
	local o = {
		sizeInPerc = sizeInPerc,
		parent = parent
	}

	setmetatable(o, object)

	function o:outline()
		self.textOutline = "OUTLINE"
		return self
	end

	function o:thickOutline()
		self.textOutline = "THICKOUTLINE"
		return self
	end

	function o:shadow()
		self.textOutline = "SHADOW"
		return self
	end

	function o:enforceHeight()
		self.enforceH = true
		return self
	end

	function o:enforceWidth()
		self.enforceW = true
		return self
	end

	function o:overlay()
		self.layer = "OVERLAY"
		return self
	end

	function o:frameLevel(level)
		self.flevel = level
		return self
	end

	function o:build()
		local text = self.parent:CreateFontString(nil, self.layer or "ARTWORK")
		text:SetDrawLayer(self.layer or "ARTWORK", self.flevel or 1)

		local textOutline = "NONE"
		if self.textOutline then
			if self.textOutline == "SHADOW" then
				textOutline = "NONE"
				text:SetShadowOffset(1, -1)
				text:SetShadowColor(0, 0, 0)
			else
				textOutline = self.textOutline
			end
		end

		setPoints(self, text)
		text.tag = nil
		text.SetTag = function(self, tag)
			self.tag = tag
			registerEvents(self, true)
		end
        text.OldSetText = text.SetText
        text.SetText = function(self, value)
            local isSpecial, font, size = false, nil, 10
            if type(value) == "string" then
                for i = 1, #value do
                    local c = value:sub(i,i)
                    if string.byte(c) > 207 then
                        isSpecial = true
                    end
                end
            end
            if isSpecial then
                font = media:Fetch("font", "NotoBold")
                self:SetFont(font, size, textOutline)
            else
                font = media:Fetch("font", "Default")
                self:SetFont(font, size, textOutline)
            end
            self:OldSetText(value)

            if sizeInPerc <= 1 then
         		if o.enforceH then
            		self.oldText = self:GetText()
            		local t = ""
            		while self:GetStringWidth() > (parent:GetWidth() * sizeInPerc) do
            			t = self:GetText()
            			if t then
            				self:OldSetText(t:sub(0, t:len() - 1))
            			else
            				break
            			end
	                end
	                self:OldSetText((t and t ~= "") and (t:sub(0, t:len() - 3):trim().."..") or self:GetText())
            	elseif o.enforceW then

            	else
		            if self:GetStringWidth() > parent:GetWidth() then
		                while self:GetStringWidth() > (parent:GetWidth() * sizeInPerc) do
		                    size = size - 1
		                    self:SetFont(font, size, textOutline)
		                    if size == 1 then
		                    	return text
		                    end
		                end
		            elseif self:GetStringWidth() > (parent:GetWidth() * sizeInPerc) then
		                while self:GetStringWidth() > (parent:GetWidth() * sizeInPerc) do
		                    size = size - 1
		                    self:SetFont(font, size, textOutline)
		                    if size == 1 then
		                    	return text
		                    end
		                end
		            elseif self:GetStringWidth() < (parent:GetWidth() * sizeInPerc) then
		                while self:GetStringWidth() < (parent:GetWidth() * sizeInPerc) do
		                    size = size + 1
		                    self:SetFont(font, size, textOutline)
		                end
		            end
		        end
	        else
	        	self:SetFont(font, sizeInPerc, textOutline)
	        end
        end
		return text
	end

	return o
end

local function FrameBuilder(parent)
	local o = {
		parent = parent
	}

	setmetatable(o, object)
	o.frame = CreateFrame("Frame", nil, parent)

	function o:actAsTextureTowards(textureKey, layer)
		self.frame[textureKey] = self.frame:CreateTexture(nil, layer or "OVERLAY")
		self.frame.SetTexCoord = function(self, ...)
			return self[textureKey]:SetTexCoord(...)
		end
		self.frame.SetTexture = function(self, tex)
			return self[textureKey]:SetTexture(tex)
		end
		return self
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.frame:SetBackdrop(bd)
		self.frame:SetBackdropColor(unpack(bdColor))
		self.frame:SetBackdropColor(unpack(borderColor))
		return self
	end

	function o:build()
		setPoints(self, self.frame)
		self.frame:SetSize(self.w, self.h)
		return self.frame
	end

	return o
end

local function ButtonBuilder(parent)

	local o = {
		parent = parent
	}

	setmetatable(o, widget)
	o.button = CreateFrame("Button", nil, parent)

	o.button.parent = parent
	o.button.active = true

	o.button.SetActive = function(self, boolean)
		local active = boolean
		if (o.activeCond) then
			active = o:activeCond()
		end

		self.active = active
		self:SetEnabled(self.active)
	end
	o.button.IsActive = function(self)
		return parent:IsActive() and self.active and (self.activeCond and self:activeCond() or true)
	end

	function o:build()
		setPoints(self, self.button)
		self.button:SetSize(self.w or 0, self.h or 0)
		return self.button
	end

	function o:onClick(func)
		self.button:SetScript("OnClick", func)
		return self
	end

	function o:onHover(func)
		self.button:SetScript("OnEnter", function(self, motion)
			if motion then
				self.hover = true
				func(self, motion)
			end
		end)
		self.button:SetScript("OnLeave", function(self, motion)
			if motion then
				self.hover = false
				func(self, motion)
			end
		end)
		return self
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.button:SetBackdrop(bd)
		self.button:SetBackdropColor(unpack(bdColor))
		self.button:SetBackdropBorderColor(unpack(borderColor))
		return self
	end

	return o
end

local function EditBoxBuilder(parent)
	local o = {
		parent = parent
	}

	setmetatable(o, widget)
	o.textbox = CreateFrame("EditBox", nil, parent)

	o.textbox.parent = parent
	o.textbox.active = true

	o.textbox.SetActive = function(self, boolean)
		local active = (boolean and o.activeCond and o.activeCond()) or false
		self.active = active
		self:SetEnabled(self.active)
	end

	o.textbox.IsActive = function(self)
		return parent:IsActive() and self.active and (self.activeCond and self:activeCond() or true)
	end

	o.textbox.SetValue = function(self, value)
		self:SetText(value)
		if o.onValueChangedFunc then 
			o:onValueChangedFunc(self, self:GetText())
		end
	end

	o.textbox.GetValue = function(self)
		return self:GetText()
	end

	function o:onTextChanged(func)
		self.textbox:SetScript("OnTextChanged", func)
		return self
	end

	function o:onEnterPressed(func)
		self.textbox:SetScript("OnEnterPressed", func)
		return self
	end

	function o:build()
		setPoints(self, self.textbox)
		self.textbox:SetSize(self.w or self.parent:GetWidth(), self.h or 0)

		self.textbox:SetAutoFocus(false)
		self.textbox:ClearFocus()

		self.textbox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
		end)

		self.textbox:SetBackdrop(A.enum.backdrops.editboxborder)
		self.textbox:SetBackdropColor(0.3, 0.3, 0.3, 1)
		self.textbox:SetBackdropBorderColor(0, 0, 0, 1)

		return self.textbox
	end

	return o
end

local function NumberBuilder(parent)
	local o = {
		parent = parent
	}

	setmetatable(o, widget)
	o.textbox = CreateFrame("EditBox", nil, parent)

	o.textbox.parent = parent
	o.textbox.active = true

	local increase = CreateFrame("Button", nil, o.textbox)
	increase:SetSize(5, o.textbox:GetHeight() / 2)
	increase:SetPoint("TOPRIGHT")
	o.textbox.increaseButton = increase

	local decrease = CreateFrame("Button", nil, o.textbox)
	decrease:SetSize(5, o.textbox:GetHeight() / 2)
	decrease:SetPoint("TOP", increase, "BOTTOM", 0, 0)
	o.textbox.decreaseButton = decrease

	o.textbox.SetActive = function(self, boolean)
		local active = (boolean and o.activeCond()) or false
		self.active = active
		self:SetEnabled(self.active)
	end

	o.textbox.IsActive = function(self)
		return parent:IsActive() and self.active and (self.activeCond and self:activeCond() or true)
	end

	o.textbox.SetValue = function(self, value)
		self:SetNumber(value)
		if o.onValueChangedFunc then 
			o:onValueChangedFunc(self, self:GetNumber())
		end
	end

	o.textbox.GetValue = function(self)
		return self:GetNumber()
	end

	function o:onTextChanged(func)
		self.textbox:SetScript("OnTextChanged", func)
		return self
	end

	function o:onEnterPressed(func)
		self.textbox:SetScript("OnEnterPressed", func)
		return self
	end

	function o:onValueChanged(func)
		self.valueChanged = func
		return self
	end

	function o:min(minValue)
		self.minValue = minValue
		return self
	end

	function o:max(maxValue)
		self.maxValue = maxValue
		return self
	end

	function o:build()
		setPoints(self, self.textbox)
		self.textbox:SetSize(self.w or self.parent:GetWidth(), self.h or 0)
		self.textbox:SetNumeric(true)

		self.textbox.increaseButton:SetScript("OnClick", function(self, b, d)
			local number = self:GetNumber()
			if (number < o.maxValue) then
				self:SetNumber(number + 1)
				o:valueChanged(self, number + 1)
			end
		end)

		self.textbox.decreaseButton:SetScript("OnClick", function(self, b, d)
			local number = self:GetNumber()
			if (number > o.minValue) then
				self:SetNumber(number - 1)
				o:valueChanged(self, number - 1)
			end
		end)

		self.textbox:SetAutoFocus(false)
		self.textbox:ClearFocus()

		self.textbox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
		end)

		self.textbox:SetBackdrop(A.enum.backdrops.editboxborder)
		self.textbox:SetBackdropColor(0.3, 0.3, 0.3, 1)
		self.textbox:SetBackdropBorderColor(0, 0, 0, 1)
		self.textbox:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")

		return self.textbox
	end

	return o
end

local function DropdownBuilder(parent)
	local o = {
		parent = parent,
		items = A:OrderedTable()
	}

	setmetatable(o, widget)
	o.dropdown = CreateFrame("Button", nil, parent)
	o.dropdown.items = A:OrderedTable()

	o.dropdown.parent = parent
	o.dropdown.active = true
	o.dropdown.selected = nil
	o.dropdown.open = false

	o.dropdown.SetActive = function(self, boolean)
		local active = (boolean and o.activeCond and o:activeCond()) or false

		self.active = active
		self:SetEnabled(self.active)

		self.selectedButton.active = active
		self.selectedButton:SetActive(self.selectedButton.active)
	end

	o.dropdown.IsActive = function(self)
		return parent:IsActive() and self.active and (self.activeCond and self:activeCond() or true)
	end

	o.dropdown.SetValue = function(self, value)
		if (o.override) then return end;

		for i = 1, self.items:count() do
			local item = self.items:get(i)
			if (item.name == value) then
				self.selected = i
				self.selectedButton.text:SetText(item.name)
			end
		end

		if o.onValueChangedFunc then 
			o:onValueChangedFunc(self, self.selectedButton.text:GetText())
		end
	end

	o.dropdown.GetValue = function(self)
		if (self.override) then return self.override end
		return self.items:get(self.selected).name
	end

	o.dropdown.Open = function(self)
		self.open = true
		self.items:foreach(function(item)
			item:Show()
		end)
	end

	o.dropdown.Close = function(self)
		self.open = false
		self.items:foreach(function(item)
			item:SetBackdropBorderColor(0, 0, 0, 0)
			item:Hide()
		end)
	end

	function o:addItems(items)
		for name,item in next, items do
			if (type(item) == "table" and not item.name) then 
				item.name = name 
			end
			self.items:add(item)
		end
		return self
	end

	function o:addItem(item)
		self.items:add(item)
		return self
	end

	function o:fontSize(fontSize)
		self.fs = fontSize
		return self
	end

	function o:onItemClick(func)
		self.itemFunc = func
		return self
	end

	function o:onClick(func)
		self.func = func
		return self
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.dropdown.bd = bd
		self.dropdown.bdColor = bdColor
		self.dropdown.borderColor = borderColor
		return self
	end

	function o:overrideText(value)
		self.override = value
		return self
	end

	function o:upwards()
		self.directionUp = true
		return self
	end

	function o:leftOfButton()
		self.openAtLeft = true
		return self
	end

	function o:rightOfButton()
		self.openAtRight = true
		return self
	end

	function o:stayOpenAfterChoosing()
		self.dontClose = true
		return self
	end

	function o:overrideRelative(relative)
		self.realRelative = relative
		return self
	end

	function o:onHover(func)
		self.hoverFunc = func
		return self
	end

	function o:onChildCreation(func)
		self.childCreation = func
		return self
	end

	function o:build()
		setPoints(self, self.dropdown)
		self.dropdown:SetSize(self.w, self.h)

		self.dropdown:SetScript("OnClick", function(self, b, down)
			if not down then
				if (self.active) then

					self.items:foreach(function(item)
						if (self.open) then
							if (not o.dontClose) then
								item:Hide()
							end
						else
							item:Show()
						end
					end)
					self.open = not self.open

					if (o.func) then
						o:func(self, b)
					end
				end
			end
		end)

		self.itemClick = function(self, item, mouseButton)
			self.dropdown:SetValue(item.name)
			self.dropdown:GetScript("OnClick")(self.dropdown, "LeftButton", false)
			if (o.itemFunc) then o:itemFunc(item, self.dropdown, mouseButton) end
		end

		self.dropdown.selected = 1
		local selectedButton = A.ButtonBuilder(self.dropdown)
			:size(self.w, self.h)
			:backdrop(self.dropdown.bd, self.dropdown.bdColor, self.dropdown.borderColor)
			:atTopLeft()
			:onHover(self.hoverFunc or A.noop)
			:onClick(function(self, b, d)
				o.dropdown:GetScript("OnClick")(o.dropdown, b, d)
			end)
			:build()
		selectedButton:RegisterForClicks("AnyUp")
		selectedButton:SetFrameLevel(7)
		selectedButton.text = A.TextBuilder(selectedButton, o.fs or 14):atLeft():x(6):outline():build()

		self.items:foreach(function(item)

			local relative = self.dropdown.items:getRelative(self.realRelative or self.dropdown.selectedButton)

			local builder = A.ButtonBuilder(self.dropdown):size(self.w, self.h)
			:backdrop(self.dropdown.bd, self.dropdown.bdColor, self.dropdown.borderColor)
			:onClick(function(self, b, down)
				if not down then
					if o.dropdown.active then

						o.dropdown.items:foreach(function(item)
							item:SetBackdropBorderColor(0, 0, 0, 0)
						end)

						o:itemClick(self, b)

						self:SetBackdropBorderColor(1, 1, 1, 1)
					end
				end
			end)
			:onHover(function(self)
				if (self.hover) then
					local r, g, b, a = self:GetBackdropColor()
					self:SetBackdropColor(r * 0.33, g * 0.33, b * 0.33, 1)
				else
					self:SetBackdropColor(unpack(o.dropdown.bdColor))
				end
			end)

			if (relative == (self.realRelative or self.dropdown.selectedButton)) then
				if (self.openAtRight) then
					builder:rightOf(relative)
				elseif (self.openAtLeft) then
					builder:leftOf(relative)
				end
			else
				if (self.directionUp) then
					builder:above(relative)
				else
					builder:below(relative)
				end
			end

			local button = builder:build()
			button:RegisterForClicks("AnyUp")
			button:SetFrameLevel(10)
			button.item = item

			if (type(item) == "table") then
				button.name = item.name
			else
				button.name = item
			end

			button.text = A.TextBuilder(button, o.fs or 14):atLeft():x(6):outline():build()
			button.text:SetText(button.name)

			if (self.childCreation) then
				self:childCreation(self, button)
			end

			button:Hide()

			self.dropdown.items:add(button)
		end)

		if (self.override) then
			selectedButton.text:SetText(self.override)
		else
			local current = self.dropdown.items:get(self.dropdown.selected)
			selectedButton.text:SetText(current and current.name or "")
		end

		self.dropdown.selectedButton = selectedButton

		return self.dropdown
	end

	return o
end

local function ColorBuilder(parent)
	local o = {
		parent = parent,
	}

	setmetatable(o, widget)
	o.color = CreateFrame("Button", nil, parent)

	o.color.parent = parent
	o.color.active = true

	o.color.SetActive = function(self, boolean)
		local active = (boolean and o.activeCond and o:activeCond()) or false
		self.active = active
		self:SetEnabled(self.active)
	end

	o.color.IsActive = function(self)
		return parent:IsActive() and self.active and (self.activeCond and self:activeCond() or true)
	end

    o.color.GetValue = function(self) return { self.r, self.g, self.b, self.a } end
    o.color.SetValue = function(self, color) 
        self.r = color[1] or 1
        self.g = color[2] or 1
        self.b = color[3] or 1
        self.a = color[4] or 1
        self:SetBackdropColor(self.r, self.g, self.b, self.a)

        if o.onValueChangedFunc then 
			o:onValueChangedFunc(self, { self.r, self.g, self.b, self.a })
		end
    end

	o.color:SetScript("OnClick", function(self, button, down)
		if button == "LeftButton" and not down then
			HideUIPanel(ColorPickerFrame)

	        ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	        ColorPickerFrame:SetFrameLevel(self:GetFrameLevel() + 10)
	        ColorPickerFrame:SetClampedToScreen(true)

	        ColorPickerFrame.func = function()
	            local r, g, b = ColorPickerFrame:GetColorRGB()
	            local a = 1 - OpacitySliderFrame:GetValue()
	            o.color:SetValue({r, g, b, a })
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
	            o.color:SetValue({r, g, b, a })
	        end

	        local r, g, b, a = self.r, self.g, self.b, self.a
	        ColorPickerFrame.opacity = 1 - (a or 0)

	        ColorPickerFrame:SetColorRGB(r, g, b)

	        ColorPickerOkayButton:HookScript("OnClick", function() 
	            --A.dbProvider:Save()
	        end)

	        ShowUIPanel(ColorPickerFrame)
	    end
	end)

	function o:build()
		setPoints(self, self.color)
		self.color:SetSize(self.w, self.h)
		self.color:SetBackdrop(A.enum.backdrops.editboxborder)
		self.color:SetBackdropBorderColor(0.67, 0.67, 0.67, 1)
		return self.color
	end

	return o
end

local function ToggleBuilder(parent)
	local o = {
		parent = parent,
	}

	setmetatable(o, widget)
	o.toggle = CreateFrame("Button", nil, parent)

	o.toggle.parent = parent
	o.toggle.active = true
	o.toggle.checked = false

	o.toggle.SetActive = function(self, boolean)
		local active = (boolean and o.activeCond and o:activeCond()) or false
		self.active = active
		self:SetEnabled(self.active)
	end

	o.toggle.SetValue = function(self, checked)
		self.checked = checked
		self.block:ClearAllPoints()
		self.text:ClearAllPoints()

		if (self.checked) then
			self.block:SetPoint("RIGHT", self, "RIGHT", 0, 0)
			self.text:SetPoint("LEFT", self, "LEFT", 2, 0)
			self.text:SetText(self.onText)
		else
			self.block:SetPoint("LEFT", self, "LEFT", 0, 0)
			self.text:SetPoint("RIGHT", self, "RIGHT", 0, 0)
			self.text:SetText(self.offText)
		end

		if o.onValueChangedFunc then 
			o:onValueChangedFunc(self, self.checked)
		end
	end

	o.toggle.GetValue = function(self)
		return self.checked
	end

	o.toggle.IsActive = function(self)
		return parent:IsActive() and self.active and (self.activeCond and self:activeCond() or true)
	end

	function o:onClick(func)
		self.click = func
		return self
	end

	function o:texts(onText, offText)
		self.onText = onText
		self.offText = offText
		return self
	end

	function o:build()
		setPoints(self, self.toggle)

		self.toggle:SetSize(40, 15)
		self.toggle:SetScript("OnClick", function(self, button, down)
			if button == "LeftButton" and not down then
				if (self.active) then
					self:SetValue(not self.checked)
					if (o.click) then
						o:click(self)
					end
				end
		    end
		end)
		self.toggle:SetFrameLevel(8)

		self.toggle.block = A.ButtonBuilder(self.toggle):atRight():size(15, 15)
		   :backdrop(A.enum.backdrops.editbox, { .5, .5, .5, 0.8 }, { 0, 0, 0 })
		   :onClick(function(self, b, d)
		   		o.toggle:GetScript("OnClick")(o.toggle, "LeftButton", false)
		   end)
		   :build()

		self.toggle.path = A.ButtonBuilder(self.toggle):alignAll()
		   :backdrop(A.enum.backdrops.editbox, { 0.1, 0.1, 0.1, 1 }, { 0, 0, 0 }):build()
		self.toggle.path:SetFrameLevel(8)

		self.toggle.onText = self.onText
		self.toggle.offText = self.offText
		
		self.toggle.text = A.TextBuilder(self.toggle, 10):size(20, 15):atLeft():outline():overlay():frameLevel(5):x(2):build()
		self.toggle.text:SetText(self.toggle.onText)

		return self.toggle
	end

	return o
end

local function GroupBuilder(parent)
	local o = {
		parent = parent,
		children = A:OrderedTable()
	}

	setmetatable(o, object)
	o.group = CreateFrame("Frame", nil, parent)
	o.group.children = A:OrderedTable()

	o.group.parent = parent
	o.group.active = true

	o.group.SetActive = function(self, boolean)
		self.active = boolean
		self.children:foreach(function(child)
			child:SetActive(self.active)
		end)
	end

	o.group.IsActive = function(self)
		return (parent.IsActive and parent:IsActive() or true) and self.active
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.group:SetBackdrop(bd)
		self.group:SetBackdropColor(unpack(bdColor))
		self.group:SetBackdropBorderColor(unpack(borderColor))
		return self
	end

	function o:build()
		setPoints(self, self.group)

		self.group:SetSize(self.w or self.group.parent:GetWidth(), 32)
		
		self.group.addChild = function(self, child)

			local relative = self.children:getRelative(self)

			if type(child) ~= "table" then
				self.children:add({ name = child, relative = child })
			else
				self.children:add(child)
			end

			child:SetPoint("TOPLEFT", relative, "BOTTOMLEFT", 0, -2)

			self:SetHeight(self:GetHeight())
		end

		return self.group
	end

	return o
end

function A:ColumnBuilder()

	local o = {
		column = CreateFrame("Button", nil, UIParent),
		rows = A:OrderedTable()
	}

	function o:addRow(row)
		if self.rows:isEmpty() then
			row.first = true
		else
			row.first = false
		end
		row:Hide()
		self.rows:add(row)
		return self
	end

	function o:withView(view)
		self.view = view
		return self
	end

	function o:build()
		self.column.view = self.view
		self.column.replaceCallback = self.replaceCallback
		self.column.rows = self.rows

		self.column.alignRows = function(self, parent) 
			for index = 1, self.rows:count() do
				local row, width = self.rows:get(i), parent:GetWidth()
				if row.first then
					row.relative = parent
					row:SetPoint(E.regions.T, row.relative, E.regions.T, 0, 0)
				else
					row.relative = self.rows:get(index-1)
					row:SetPoint(E.regions.T, row.relative, E.regions.B, 0, 0)
				end
				row:SetSize(width, width / self.rows:count())
			end
		end

		return self.column
	end

	return o
end

function A:RowBuilder()

	local o = {
		columns = A:OrderedTable(),
		row = CreateFrame("Frame", nil, UIParent)
	}

	function o:addColumn(column)
	    column:SetParent(self.row)
	    
	    if self.columns:isEmpty() then
			column.first = true
			column.relative = self.row
			column:SetPoint(E.regions.L, column.relative, E.regions.L, 0, 0)
	    else
			column.first = false
			column.relative = self.columns:last()
			column:SetPoint(E.regions.L, column.relative, E.regions.R, 0, 0)
	    end

	    if column.rows:isEmpty() then
			column:SetScript("OnClick", function(self, b, d)
				if b == "RightButton" then
					A:CreateDropdown(o.row.index, self)
				end
			end)
	    else
			column:SetScript("OnClick", function(self, b, d)
				if b == "LeftButton" and not d then
					self.grid:multiLayerReplace(self)
				end
			end)
	    end

	    self.columns:add(column)
	    return self
	end

	function o:build()
		self.row.columns = self.columns

		return self.row
	end

	return o

end

function A:GridBuilder(parent, isSingleLevel, dbKey)

	local o = {
		parent = parent,
		previousButton = nil,
		isSingleLevel = isSingleLevel,
		rows = A:OrderedTable(),
		dbKey = dbKey
	}

	function o:getFirstColumnWithKey(key)
		for rowId = 1, grid.rows:count() do
			local row = grid.rows:get(rowId)
			for columnId = 1, row.columns:count() do
				local key, column = nil, row.columns:get(columnId)
				if type(column) == "table" then
					key = select(1, column:getView())
				else
					key = column.view
				end
				if key == new then
					return column
				end
			end
		end
		return nil
	end

	function o:singleLayerReplace(newColumn, oldRowId, oldColumnId)
		local g = { 
			isSingleLevel = self.isSingleLevel,
			parent = self.parent,
			dbKey = self.dbKey,
			rows = {}
		}

		for rowId = 1, self.rows:count() do
			local row = self.rows:get(rowId)
			local newRow = { columns = {} }
			for columnId = 1, row.columns:count() do
				if rowId == oldRowId and columnId == oldColumnId then
                    table.insert(newRow.columns, newColumn)
				else
					table.insert(newRow.columns, row.columns:get(columnId))
				end
			end
			table.insert(g.rows, newRow)
		end

		return A.Grid:parseDBGrid(g, g.parent, true)
	end

	function o:multiLayerReplace(grid)
		-- LOGICS
		local previousButton = self:GeneratePreviousButton(nil, grid.parent)
		
	end

	function o:addRow(row)
		local width = self.parent:GetWidth()
		row:SetSize(width, width / row.columns:count())
		row.grid = self

		for i = 1, row.columns:count() do
			local column, height = row.columns:get(i), row:GetHeight()
			column.grid = self
			column:SetSize(height, height)
			if column.alignRows then
				column:alignRows(self.parent)
			end
		end

		if self.rows:isEmpty() then
			row.first = true
			row.relative = self.parent
			row:SetPoint(E.regions.T, self.parent, E.regions.T, 0, 0)
		else
			row.first = false
			row.relative = self.rows:last()
			row:SetPoint(E.regions.T, row.relative, E.regions.B, 0, 0)
		end
		self.rows:add(row)
		return self
	end

	function o:build(callback)
		return callback(self)
	end

	return o

end

local function DrawerBuilder()

	local drawerWidth = 200

	local test = CreateFrame("Button", "TESTBUTTONWOO", UIParent)
	test:SetSize(200, 600)
	test:SetBackdrop(E.backdrops.editbox)
	test:SetBackdropColor(unpack(A.colors.backdrop.default))
	test:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
	test:SetPoint(E.regions.L, UIParent, E.regions.L, -190, 0)
	test:SetClampedToScreen(false)

	test.ag = test:CreateAnimationGroup()
	test.isOpen = false

	test.open = test.ag:CreateAnimation("Translation")
	test.open:SetOffset(200, 0)
	test.open:SetDuration(0.3)
	test.open:SetOrder(1)
	test.open:SetScript("OnFinished", function(self, req)
		test.isOpen = true
		test:ClearAllPoints()
		test:SetPoint(E.regions.L)
		test.ag:Stop()
		test.close:SetOrder(1)
		self:SetOrder(2)
	end)
	test.close = test.ag:CreateAnimation("Translation")
	test.close:SetOffset(-190, 0)
	test.close:SetDuration(0.3)
	test.close:SetOrder(2)
	test.close:SetScript("OnFinished", function(self, req)
		test.isOpen = false
		test:ClearAllPoints()
		test:SetPoint(E.regions.L, UIParent, E.regions.L, -190, 0)
		test.ag:Stop()
		test.open:SetOrder(1)
		self:SetOrder(2)
	end)

	test.time = 0
	test:SetScript("OnUpdate", function(self, elapsed)
		self.time = self.time + elapsed
		if self.time > 0.3 then
            if InCombatLockdown() and self.isOpen then
                self.ag:Play()
            else
                if not self.ag:IsPlaying() and self.forceClose and self.isOpen and not self:IsMouseOver() then
                    self.ag:Play()
                end
            end
			self.time = 0
		end
	end)

	test.ag:SetScript("OnPause", function(self)
		self:Finish()
	end)

	--[[test:SetScript("OnLeave", function(self, arg)
		if arg then
			if self.isOpen then
				self.ag:Play()
			else
				self.forceClose = true
			end
		end
	end)

	test:SetScript("OnEnter", function(self, arg)
		if arg then
			if not self.open:IsPlaying() and not self.isOpen then
				self.ag:Play()
			end
		end
	end)]]
    
    test:SetScript("OnClick", function(self, button, down)
        if button == "LeftButton" and not down then
            if self.isOpen then
                self.ag:Play()
            else
                self.ag:Play()
            end
        end
    end)
end

local Utils = {}

function Utils:CreateBackground(frame, db, useBackdrop)
	local ref = frame
	if db["Background"] and db["Background"]["Enabled"] then 
		if not useBackdrop then
			ref = frame.Background or CreateFrame("Frame", nil, frame)
			ref:SetPoint("CENTER", frame, "CENTER", 0, 0)
			ref:SetSize(frame:GetSize())
			ref:SetFrameStrata("LOW")
			ref:SetFrameLevel(1)
			ref:Show()
			frame.Background = ref
		end
		local offset = db["Background"]["Offset"]
		ref:SetBackdrop({
			bgFile = media:Fetch("statusbar", "Default"),
			tile = true,
			tileSize = 16,
			insets = {
				top = offset["Top"],
				bottom = offset["Bottom"],
				left = offset["Left"],
				right = offset["Right"],
			}
		})
		ref:SetBackdropColor(unpack(db["Background"]["Color"]))
	else
		ref:SetBackdrop(nil)
	end
end

A.Utils = Utils
A.TextBuilder = TextBuilder
A.ButtonBuilder = ButtonBuilder
A.FrameBuilder = FrameBuilder
A.EditBoxBuilder = EditBoxBuilder
A.DrawerBuilder = DrawerBuilder
A.DropdownBuilder = DropdownBuilder
A.ToggleBuilder = ToggleBuilder
A.GroupBuilder = GroupBuilder
A.NumberBuilder = NumberBuilder
A.ColorBuilder = ColorBuilder