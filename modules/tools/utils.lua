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
	self.w = w
	self.h = h
	return self
end

object.__index = object

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
		size = size,
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
            			self:OldSetText(t:sub(0, t:len() - 1))
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

	setmetatable(o, object)
	o.button = CreateFrame("Button", nil, parent)

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
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.button:SetBackdrop(bd)
		self.button:SetBackdropColor(unpack(bdColor))
		self.button:SetBackdropColor(unpack(borderColor))
		return self
	end

	return o
end

local function EditBoxBuilder(parent)
	local o = {
		parent = parent
	}

	setmetatable(o, object)
	o.textbox = CreateFrame("EditBox", nil, parent)

	function o:onTextChanged(func)
		self.textbox:SetScript("OnTextChanged", func)
		return self
	end

	function o:onEnterPressed(func)
		self.textbox:SetScript("OnEnterPressed", func)
		return self
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.textbox:SetBackdrop(bd)
		self.textbox:SetBackdropColor(unpack(bdColor))
		self.textbox:SetBackdropColor(unpack(borderColor))
		return self
	end

	function o:build()
		setPoints(self, self.textbox)
		self.textbox:SetSize(self.w or self.parent:GetWidth(), self.h or 0)
		return self.textbox
	end

	return o
end

local function DropdownBuilder(parent)
	local o = {
		parent = parent,
		items = A:OrderedTable()
	}

	setmetatable(o, object)
	o.dropdown = CreateFrame("Frame", nil, parent)
	o.dropdown.items = A:OrderedTable()

	function o:addItem(item)
		local count = self.items:count()
		local relative = self.items:getRelative(self.dropdown)
		if type(item) ~= "table" then
			self.items:add({ name = item, relative = relative })
		else
			item.relative = relative
			self.items:add(item)
		end
		return self
	end

	function o:onItemClick(func)
		self.itemClick = func
		return self
	end

	function o:backdrop(bd, bdColor, borderColor)
		self.dropdown:SetBackdrop(bd)
		self.dropdown:SetBackdropColor(unpack(bdColor))
		self.dropdown:SetBackdropColor(unpack(borderColor))
		return self
	end

	function o:build()
		setPoints(self, self.dropdown)
		self.dropdown:SetSize(self.w, self.h)

		for i = 1, self.items:count() do
			local item = self.items:get(i)
			
			local buttonBuilder = A:ButtonBuilder(self.dropdown):onClick(function(self, b, down)
				if b == "LeftButton" and not down then
					o:itemClick(self)
				end
			end):below(item.relative):build()

			button.name = item.name
			button:SetText(item.name)

			self.dropdown.items:add(button)
		end

		return self.dropdown
	end
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
	if db["Background"] and db["Background"]["Enabled"] then 
		local ref = frame
		if not useBackdrop then
			ref = frame.Background or CreateFrame("Frame", nil, frame)
			ref:SetPoint("CENTER", frame, "CENTER", 0, 0)
			ref:SetSize(frame:GetSize())
			ref:SetFrameStrata("LOW")
			ref:SetFrameLevel(1)
			ref:Show()
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
		if not useBackdrop then
			ref:Hide()
		end
	end
end

A.Utils = Utils
A.TextBuilder = TextBuilder
A.ButtonBuilder = ButtonBuilder
A.FrameBuilder = FrameBuilder
A.EditBoxBuilder = EditBoxBuilder
A.DrawerBuilder = DrawerBuilder
A.DropdownBuilder = DropdownBuilder