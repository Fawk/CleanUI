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
		local relative = self.aw or self.parent
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
		self.active = boolean
		self:SetEnabled(self.active)
	end
	o.button.IsActive = function(self)
		return parent:IsActive() and self.active
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
		if (not bd) then return self end

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
		self.active = boolean
		self:SetEnabled(self.active)
	end

	o.textbox.IsActive = function(self)
		return parent:IsActive() and self.active
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

	function o:fontSize(fSize)
		self.fSize = fSize
		return self
	end

	function o:onEditFocusLost(focusLost)
		self.textbox:SetScript("OnEditFocusLost", focusLost)
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
		self.textbox:SetTextInsets(5, 0, 0, 0)
		self.textbox:SetFont(media:Fetch("font", "Default"), o.fSize or 10, "OUTLINE")

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
	increase.text = increase:CreateFontString(nil, "OVERLAY")
	increase.text:SetFont(media:Fetch("font", "Default"), 12, "OUTLINE")
	increase.text:SetAllPoints()
	increase.text:SetText("+")
	o.textbox.increaseButton = increase

	local decrease = CreateFrame("Button", nil, o.textbox)
	decrease.text = decrease:CreateFontString(nil, "OVERLAY")
	decrease.text:SetFont(media:Fetch("font", "Default"), 14, "OUTLINE")
	decrease.text:SetAllPoints()
	decrease.text:SetText("-")
	o.textbox.decreaseButton = decrease

	o.textbox.SetActive = function(self, boolean)
		self.active = boolean
		self:SetEnabled(self.active)
	end

	o.textbox.IsActive = function(self)
		return parent:IsActive() and self.active
	end

	o.textbox.SetValue = function(self, value)
		if (tonumber(value) < o.minValue) then
			value = o.minValue
		elseif (tonumber(value) > o.maxValue) then
			value = o.maxValue
		end

		self.lastValue = self:GetText()
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

	function o:stepValue(s)
		self.step = s
		return self
	end

	function o:allowDecimals(decimals)
		self.decimals = decimals
		return self
	end

	function o:build()
		setPoints(self, self.textbox)
		self.textbox:SetSize(self.w or self.parent:GetWidth(), self.h or 0)

		self.textbox.increaseButton:SetSize(15, self.textbox:GetHeight() / 2)
		self.textbox.increaseButton:SetPoint("TOPRIGHT", 3, -2)
		self.textbox.decreaseButton:SetSize(15, self.textbox:GetHeight() / 2)
		self.textbox.decreaseButton:SetPoint("TOP", self.textbox.increaseButton, "BOTTOM", 0, 3)

		self.textbox.increaseButton:SetScript("OnClick", function(self, b, d)
			if (not o.textbox.active) then return end

			local number = tonumber(o.textbox:GetText())
			if ((number + (o.step or 1)) <= o.maxValue) then
				o.textbox.lastValue = number
				o.textbox:SetText(number + (o.step or 1))
				o:valueChanged(o.textbox, number + (o.step or 1))
			end
		end)

		self.textbox.decreaseButton:SetScript("OnClick", function(self, b, d)
			if (not o.textbox.active) then return end

			local number = tonumber(o.textbox:GetText())
			if ((number - (o.step or 1)) >= o.minValue) then
				o.textbox.lastValue = number
				o.textbox:SetText(number - (o.step or 1))
				o:valueChanged(o.textbox, number - (o.step or 1))
			end
		end)

		self.textbox:SetAutoFocus(false)
		self.textbox:ClearFocus()

		self.textbox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()

			local text = self:GetText()

			if (tonumber(text) < o.minValue) then
				text = o.minValue
			elseif (tonumber(text) > o.maxValue) then
				text = o.maxValue
			end

			self:SetText(text)
			o:valueChanged(self, text)
		end)

		self.textbox:SetScript("OnEnterPressed", function(self)
			self:ClearFocus()

			local text = self:GetText()

			if (tonumber(text) < o.minValue) then
				text = o.minValue
			elseif (tonumber(text) > o.maxValue) then
				text = o.maxValue
			end

			self:SetText(text)
			o:valueChanged(self, text)
		end)

		self.textbox:SetScript("OnTextChanged", function(self)
			local text = self:GetText()
			if (text) then
				local formatted = text:match("[0-9"..(o.decimals and "%." or "")..(tostring(o.minValue):match("-") or "").."]+")
				if (formatted) then
					if (text ~= formatted) then
						text = formatted
					end
					self:SetText(text)
					self.lastValue = text
				end
			end
		end)

		self.textbox:SetBackdrop(A.enum.backdrops.editboxborder)
		self.textbox:SetBackdropColor(0.3, 0.3, 0.3, 1)
		self.textbox:SetBackdropBorderColor(0, 0, 0, 1)
		self.textbox:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
		self.textbox:SetTextInsets(5, 0, 0, 0)

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
		self.active = boolean
		self:SetEnabled(self.active)

		self.selectedButton.active = boolean
		self.selectedButton:SetActive(self.selectedButton.active)
	end

	o.dropdown.IsActive = function(self)
		return parent:IsActive() and self.active
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

		if (self.itemBackground) then
			self.itemBackground:Show()
		end
	end

	o.dropdown.Close = function(self)
		self.open = false
		self.items:foreach(function(item)
			item:SetBackdropBorderColor(0, 0, 0, 0)
			item:Hide()
		end)

		if (self.itemBackground) then
			self.itemBackground:Hide()
		end
	end

	function o:addItems(items)
		for name, item in next, items do
			if (type(item) == "table" and not item.name) then 
				item.name = name 
			end
			if (item.order) then
				self.items:addAt(item, item.order)
			else
				self.items:add(item)
			end
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

	function o:hideSelectedButtonBackdrop()
		self.hideSelectedButtonBd = true
		return self
	end

	function o:selectedButtonTextHorizontalAlign(halign)
		self.selectedButtonAlignH = halign
		return self
	end

	function o:selectedButtonTextVerticalAlign(valign)
		self.selectedButtonAlignV = valign
		return self
	end

	function o:onItemHover(func)
		self.itemHover = func
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

					if (self.itemBackground) then
						if (self.open) then
							self.itemBackground:Hide()
						else
							self.itemBackground:Show()
						end
					end

					self.open = not self.open

					if (o.func) then
						o:func(self, b)
					end
				end
			end
		end)

		self.dropdown.SimulateClickOnActiveItem = function(self)
			self.items:foreach(function(item)
				if (self.selected == item.index) then
					o:itemClick(item, "LeftButton")
				end
			end)
		end

		self.itemClick = function(self, item, mouseButton)
			self.dropdown:SetValue(item.name and item.name or item)
			self.dropdown:GetScript("OnClick")(self.dropdown, "LeftButton", false)
			if (o.itemFunc) then o:itemFunc(item, self.dropdown, mouseButton) end
		end

		self.dropdown.selected = 1
		local selectedButtonBuilder = A.ButtonBuilder(self.dropdown)
			:size(self.w, self.h)
			:atTopLeft()
			:onHover(self.hoverFunc or A.noop)
			:onClick(function(self, b, d)
				o.dropdown:GetScript("OnClick")(o.dropdown, b, d)
			end)

		if (not self.hideSelectedButtonBd) then
			selectedButtonBuilder
					:backdrop(self.dropdown.bd, self.dropdown.bdColor, self.dropdown.borderColor)
		end
			
		local selectedButton = selectedButtonBuilder:build()
		selectedButton:RegisterForClicks("AnyUp")
		selectedButton:SetFrameLevel(self.dropdown:GetFrameLevel() + 1)

		local tb = A.TextBuilder(selectedButton, o.fs or 14):outline()

		if (self.selectedButtonAlignH) then
			local h = self.selectedButtonAlignH
			if (h == "LEFT") then
				selectedButton.text = tb:atLeft():x(6)
			elseif (h == "RIGHT") then
				selectedButton.text = tb:atRight():x(-15)
			elseif (h == "CENTER") then
				selectedButton.text = tb:atCenter()
			end
			
			selectedButton.text = tb:build()
			selectedButton.text:SetJustifyH(h)
		end
		
		if (self.selectedButtonAlignV) then
			local v = self.selectedButtonAlignV
			if (v == "TOP") then
				selectedButton.text = tb:atTop():y(-6)
			elseif (v == "BOTTOM") then
				selectedButton.text = tb:atBottom():y(6)
			elseif (v == "MIDDLE") then
				selectedButton.text = tb:atCenter()
			end

			selectedButton.text = tb:build()
			selectedButton.text:SetJustifyV(v)
		end

		if (not selectedButton.text) then
			selectedButton.text = tb:atLeft():x(6):build()
		end

		local arrow = A.TextBuilder(selectedButton, 10)
				:atRight()
				:outline()
				:x(-3)
				:build()

		arrow:SetText("v")
		arrow:SetTextColor(.6, .6, 1, 1)

		self.items:foreach(function(item)

			local relative = self.dropdown.items:getRelative(self.realRelative or self.dropdown.selectedButton)

			local builder = A.ButtonBuilder(self.dropdown)
					:size(self.w, self.h)
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
			
			if (self.itemHover) then
				builder:onHover(self.itemHover)
			end

			if (relative == (self.realRelative or self.dropdown.selectedButton)) then
				if (self.openAtRight) then
					builder:rightOf(relative)
				elseif (self.openAtLeft) then
					builder:leftOf(relative)
				else
					builder:below(relative)
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

		if (self.dropdown.bd) then
			self.dropdown.itemBackground = CreateFrame("Frame", nil, self.dropdown)

			if (self.directionUp) then
				self.dropdown.itemBackground:SetPoint("BOTTOMLEFT", self.dropdown, "TOPLEFT")
			else
				self.dropdown.itemBackground:SetPoint("TOPLEFT", self.dropdown, "BOTTOMLEFT")
			end

			self.dropdown.itemBackground:SetSize(self.w, self.h * self.items:count())
			self.dropdown.itemBackground:SetBackdrop(self.dropdown.bd)
			self.dropdown.itemBackground:SetBackdropColor(unpack(self.dropdown.bdColor))
			self.dropdown.itemBackground:SetBackdropBorderColor(unpack(self.dropdown.borderColor))
			self.dropdown.itemBackground:SetFrameLevel(10)
			self.dropdown.itemBackground:Hide()
		end

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
		self.active = boolean
		self:SetEnabled(self.active)
	end

	o.color.IsActive = function(self)
		return parent:IsActive() and self.active
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
		self.active = boolean
		self:SetEnabled(self.active)
	end

	o.toggle.SetValue = function(self, checked)
		self.checked = checked
		self.block:ClearAllPoints()
		self.text:ClearAllPoints()

		if (self.checked) then
			self.block:SetPoint("RIGHT", self, "RIGHT", 0, 0)
			self.text:SetPoint("LEFT", self, "LEFT", 4, 0)
			self.text:SetText(self.onText)
		else
			self.block:SetPoint("LEFT", self, "LEFT", 0, 0)
			self.text:SetPoint("RIGHT", self, "RIGHT", -2, 0)
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
		return parent:IsActive() and self.active
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

		self.toggle:SetSize(self.w, self.h)
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

		self.toggle.block = A.ButtonBuilder(self.toggle):atRight():size(self.h, self.h)
		   :backdrop(A.enum.backdrops.editboxborder, { .1, .1, .1, 1 }, { .3, .3, .3, 1 })
		   :onClick(function(self, b, d)
		   		o.toggle:GetScript("OnClick")(o.toggle, "LeftButton", false)
		   end)
		   :build()

		self.toggle.path = A.ButtonBuilder(self.toggle):alignAll()
		   :backdrop(A.enum.backdrops.editboxborder, { 0.3, 0.3, 0.3, 1 }, { 0, 0, 0, 1 }):build()
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
	o.group = CreateFrame("Button", nil, parent)
	o.group:RegisterForClicks("AnyUp")
	o.group.children = A:OrderedTable()

	o.group.parent = parent
	o.group.active = true

	o.group.SetActive = function(self, boolean)
		self.active = boolean
		self.children:foreach(function(child)
			if (child.enabled) then
				child:SetActive(child:enabled())
			else
				child:SetActive(self.active)
			end
		end)
	end

	o.group.IsActive = function(self)
		return (parent.IsActive and parent:IsActive() or true) and self.active
	end

	o.group.SetValue = function(self)

	end

	o.group.GetValue = function(self)

	end

	function o:onClick(func)
		self.group:SetScript("OnClick", func)
		return self
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.group:SetBackdrop(bd)
		self.group:SetBackdropColor(unpack(bdColor))
		self.group:SetBackdropBorderColor(unpack(borderColor))
		return self
	end

	function o:build()
		setPoints(self, self.group)

		self.group:SetSize(self.w or 20, self.h or 20)

		self.group.addChild = function(self, child)
			if type(child) ~= "table" then
				child = { name = child }
			end

			if (not self.children:isEmpty()) then
				child.previous = self.children:last()
			else
				self.first = child
			end

			child.parent = self

			self.children:add(child)
		end

		return self.group
	end

	return o
end

local function CheckBoxBuilder(parent)
	local o = {
		parent = parent,
	}

	setmetatable(o, object)
	o.button = CreateFrame("CheckButton", nil, parent)

	o.button.parent = parent
	o.button.active = true

	hooksecurefunc(o.button, "SetChecked", function(self, checked)
		if (checked) then
			self.x:Show()
		else
			self.x:Hide()
		end
	end)

	o.button.SetActive = function(self, boolean)
		self.active = boolean
		self:SetEnabled(boolean)
	end

	o.button.IsActive = function(self)
		return (parent.IsActive and parent:IsActive() or true) and self.active
	end

	o.button.SetValue = function(self, checked)
		self:SetChecked(checked)
	end

	o.button.GetValue = function(self)
		return self:GetChecked()
	end

	function o:fontSize(size)
		o.xSize = size
		return self
	end

	function o:outline()
		self.xOutline = true
		return self
	end

	function o:onClick(func)
		self.func = func
		return self
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.button:SetBackdrop(bd)
		self.button:SetBackdropColor(unpack(bdColor))
		self.button:SetBackdropBorderColor(unpack(borderColor))
		return self
	end

	function o:build()
		setPoints(self, self.button)
		self.button:SetSize(self.w, self.h)
		
		local builder = A.TextBuilder(self.button, o.xSize)
				:atCenter()

		if (o.xOutline) then
			builder:outline()
		end

		self.button:SetScript("OnClick", function(self, b, d)
			if (not d) then
				self:SetValue(not self:GetValue())
				if (o.func) then o:func(self) end
			end
		end)

		self.button.x = builder:build()
		self.button.x:SetJustifyV("MIDDLE")
		self.button.x:SetJustifyH("CENTER")
		self.button.x:SetText("x")
		return self.button
	end

	return o
end

local function MultiDropdownBuilder(parent)
	local o = {
		parent = parent,
		items = A:OrderedTable()
	}

	setmetatable(o, widget)
	o.dropdown = CreateFrame("Button", nil, parent)
	o.dropdown.items = A:OrderedTable()

	o.dropdown.parent = parent
	o.dropdown.active = true
	o.dropdown.selectedItems = A:OrderedTable()
	o.dropdown.open = false

	o.dropdown.SetActive = function(self, boolean)
		self.active = boolean
		self:SetEnabled(self.active)

		self.selectedButton.active = boolean
		self.selectedButton:SetActive(self.selectedButton.active)
	end

	o.dropdown.IsActive = function(self)
		return parent:IsActive() and self.active
	end

	o.dropdown.SetValue = function(self, list)
		self.selectedItems:clear()

		for _,v in next, list do
			self.selectedItems:add(v)
		end

		self.items:foreach(function(item)
			if (self.selectedItems:contains(item.index)) then
				item.checkBox:SetChecked(true)
			else
				item.checkBox:SetChecked(false)
			end
		end)

		if o.onValueChangedFunc then 
			o:onValueChangedFunc(self, self.selectedItems)
		end
	end

	o.dropdown.GetValue = function(self)
		if (self.override) then return self.override end
		return self.selectedItems
	end

	o.dropdown.Open = function(self)
		self.open = true
		self.items:foreach(function(item)
			item:Show()
		end)

		if (self.itemBackground) then
			self.itemBackground:Show()
		end
	end

	o.dropdown.Close = function(self)
		self.open = false
		self.items:foreach(function(item)
			item:SetBackdropBorderColor(0, 0, 0, 0)
			item:Hide()
		end)

		if (self.itemBackground) then
			self.itemBackground:Hide()
		end
	end

	function o:addItems(items)
		for name, item in next, items do
			if (type(item) == "table" and not item.name) then 
				item.name = name 
			end
			if (item.order) then
				self.items:addAt(item, item.order)
			else
				self.items:add(item)
			end
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

	function o:hideSelectedButtonBackdrop()
		self.hideSelectedButtonBd = true
		return self
	end

	function o:selectedButtonTextHorizontalAlign(halign)
		self.selectedButtonAlignH = halign
		return self
	end

	function o:selectedButtonTextVerticalAlign(valign)
		self.selectedButtonAlignV = valign
		return self
	end

	function o:onItemHover(func)
		self.itemHover = func
		return self
	end

	function o:readonly()
		self.isReadOnly = true
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
							item:Hide()
						else
							item:Show()
						end
					end)
					
					if (self.itemBackground) then
						if (self.open) then
							self.itemBackground:Hide()
						else
							self.itemBackground:Show()
						end
					end

					self.open = not self.open

					if (o.func) then
						o:func(self, b)
					end
				end
			end
		end)

		self.itemClick = function(self, item, mouseButton)
			self.dropdown.selectedItems:addUnique(item.index)
			local cb = self.dropdown.items:get(item.index).checkBox
			cb:SetValue(not cb:GetValue())
			if (o.itemFunc) then o:itemFunc(item, self.dropdown, mouseButton) end
		end

		self.dropdown.selected = 1
		local selectedButtonBuilder = A.ButtonBuilder(self.dropdown)
			:size(self.w, self.h)
			:atTopLeft()
			:onHover(self.hoverFunc or A.noop)
			:onClick(function(self, b, d)
				o.dropdown:GetScript("OnClick")(o.dropdown, b, d)
			end)

		if (not self.hideSelectedButtonBd) then
			selectedButtonBuilder
					:backdrop(self.dropdown.bd, self.dropdown.bdColor, self.dropdown.borderColor)
		end
			
		local selectedButton = selectedButtonBuilder:build()
		selectedButton:RegisterForClicks("AnyUp")
		selectedButton:SetFrameLevel(self.dropdown:GetFrameLevel() + 1)

		local tb = A.TextBuilder(selectedButton, o.fs or 14):outline()

		if (self.selectedButtonAlignH) then
			local h = self.selectedButtonAlignH
			if (h == "LEFT") then
				selectedButton.text = tb:atLeft():x(6)
			elseif (h == "RIGHT") then
				selectedButton.text = tb:atRight():x(-6)
			elseif (h == "CENTER") then
				selectedButton.text = tb:atCenter()
			end
			
			selectedButton.text = tb:build()
			selectedButton.text:SetJustifyH(h)
		end
		
		if (self.selectedButtonAlignV) then
			local v = self.selectedButtonAlignV
			if (v == "TOP") then
				selectedButton.text = tb:atTop():y(-6)
			elseif (v == "BOTTOM") then
				selectedButton.text = tb:atBottom():y(6)
			elseif (v == "MIDDLE") then
				selectedButton.text = tb:atCenter()
			end

			selectedButton.text = tb:build()
			selectedButton.text:SetJustifyV(v)
		end

		if (not selectedButton.text) then
			selectedButton.text = tb:atLeft():x(6):build()
		end

		local arrow = A.TextBuilder(selectedButton, 10)
				:atRight()
				:outline()
				:x(-3)
				:build()

		arrow:SetText("v")
		arrow:SetTextColor(.6, .6, 1, 1)

		self.items:foreach(function(item)

			local relative = self.dropdown.items:getRelative(self.realRelative or self.dropdown.selectedButton)

			local builder = A.ButtonBuilder(self.dropdown)
					:size(self.w, self.h)
					:onClick(function(self, b, down)
						if not down then
							if o.dropdown.active then

								if (o.isReadOnly) then 
									return
								end

								o.dropdown.items:foreach(function(item)
									item:SetBackdropBorderColor(0, 0, 0, 0)
								end)

								o:itemClick(self, b)

								self:SetBackdropBorderColor(1, 1, 1, 1)
							end
						end
					end)
			
			if (self.itemHover) then
				builder:onHover(self.itemHover)
			end

			if (relative == (self.realRelative or self.dropdown.selectedButton)) then
				if (self.openAtRight) then
					builder:rightOf(relative)
				elseif (self.openAtLeft) then
					builder:leftOf(relative)
				else
					if (self.directionUp) then
						builder:above(relative)
					else
						builder:below(relative)
					end
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

			button.checkBox = A.CheckBoxBuilder(button)
					:atRight()
					:x(-5)
					:fontSize(18)
					:size(self.h - 4, self.h - 4)
					:outline()
					:backdrop(E.backdrops.editboxborder, { .1, .1, .1, 1 }, { .6, .6, .6, 1 })
					:onClick(function(self, b)
						if o.dropdown.active then
							o:itemClick(button, b)	
						end
					end)
					:build()

			button.checkBox:SetChecked(false)

			if (self.isReadOnly) then
				button.checkBox:SetActive(false)
			end

			if (self.childCreation) then
				self:childCreation(self, button)
			end

			button:Hide()

			self.dropdown.items:add(button)
		end)

		self.dropdown.items:foreach(function(item)
			if (o.dropdown.selectedItems:contains(item.index)) then
				item.checkBox:SetChecked(true)
			end
		end)

		if (self.override) then
			selectedButton.text:SetText(self.override)
		else
			local current = self.dropdown.items:get(self.dropdown.selected)
			selectedButton.text:SetText(current and current.name or "")
		end

		self.dropdown.selectedButton = selectedButton

		if (self.dropdown.bd) then
			self.dropdown.itemBackground = CreateFrame("Frame", nil, self.dropdown)

			if (self.directionUp) then
				self.dropdown.itemBackground:SetPoint("BOTTOMLEFT", self.dropdown, "TOPLEFT")
			else
				self.dropdown.itemBackground:SetPoint("TOPLEFT", self.dropdown, "BOTTOMLEFT")
			end

			self.dropdown.itemBackground:SetSize(self.w, self.h * self.items:count())
			self.dropdown.itemBackground:SetBackdrop(self.dropdown.bd)
			self.dropdown.itemBackground:SetBackdropColor(unpack(self.dropdown.bdColor))
			self.dropdown.itemBackground:SetBackdropBorderColor(unpack(self.dropdown.borderColor))
			self.dropdown.itemBackground:SetFrameLevel(10)
			self.dropdown.itemBackground:Hide()
		end

		return self.dropdown
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
			ref:SetSize(frame:GetWidth() + 3, frame:GetHeight() + 3)
			ref:SetFrameStrata("LOW")
			ref:SetFrameLevel(1)
			ref:Show()
			frame.Background = ref
		end
		local offset = db["Background"]["Offset"]
		ref:SetBackdrop({
	        bgFile = media:Fetch("background", "cui-default-bg"), 
	        tile = true, 
	        tileSize = 1,
	        edgeFile = media:Fetch("border", "test-border"), 
	        edgeSize = 3, 
	        insets = { 
	        	top = offset["Top"], 
	        	bottom = offset["Bottom"], 
	        	left = offset["Left"], 
	        	right = offset["Right"] 
	        } 
		})
		local r, g, b, a = unpack(db["Background"]["Color"])
		ref:SetBackdropColor(r, g, b, a or 1)
        ref:SetBackdropBorderColor(r, g, b, a or 1)
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
A.CheckBoxBuilder = CheckBoxBuilder
A.MultiDropdownBuilder = MultiDropdownBuilder