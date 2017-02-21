local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum

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

local function TextBuilder(parent, size)
	local o = {
		size = size,
		parent = parent
	}

	setmetatable(o, object)

	function o:build()
		local text = self.parent:CreateFontString(nil, "OVERLAY")
		text:SetFont(media:Fetch("font", "FrancophilSans"), self.size, "NONE")
		setPoints(self, text)
		return text
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
		return self.button
	end

	function o:onClick(func)
		self.button:SetScript("OnClick", func)
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

	function o:build()
		setPoints(self, self.textbox)
		return self.textbox
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
    self.column.getView = self.view
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
          A:CreateDropdown(self)
        end
      end)
    else
      column:SetScript("OnClick", function(self, b, d)
        if b == "LeftButton" and not d then
          A.Grid:Replace(self)
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

  function o:addRow(row)
    row:SetParent(self.parent)
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

A.TextBuilder = TextBuilder
A.ButtonBuilder = ButtonBuilder
A.EditBoxBuilder = EditBoxBuilder