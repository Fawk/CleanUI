local A, L = unpack(select(2, ...))
local E = A.enum

local OT = {}

function OT:__re(i)
	local e, f = self.e, false
	self.e = {}
	for x = 1, i do
		if e[x] ~= nil then
			self.e[x] = e[x]
		end
	end
	for x = i+1, self.c do
		if e[x] ~= nil then
			self.e[x-1] = e[x]
		end
	end
	self.c = self.c - 1
	self.e = e
end

function OT:add(t)
	if self.s ~= -1 and self.c+1 > self.s then
		return false
	end
	self.c = self.c + 1
	self.e[self.c] = t
	return true
end

function OT:addAll(...)
	local t = {...}
	for k,v in pairs(t) do
		if not self:add(v) then
			return false
		end
	end
	return true
end

function OT:addUnique(t)
	if not self:contains(t) then
		return self:add(t)
	end
	return false
end

function OT:contains(tbl)
	for k = 1, self:count() do
		local v = self:get(k)
		if tostring(v) == tostring(tbl) then
			return true
		end
	end
	return false
end

function OT:remove(t)
	for i = 1, self.c do
		local e = self.e[i]
		if tostring(e) == tostring(t) then
			self.e[i] = nil
			self:__re(i)
			return true
		end
	end
	return false
end

local function search(result, tbl, key, value, steps, parents)
    for x, y in pairs(tbl) do
        if type(y) == "table" then
            parents:add(tbl)
            search(result, y, key, value, steps, parents)
        else 
            if x == key and y == value then
                if steps == 0 then
                	result:addUnique(tbl)
                else
                	local count = parents:count()-steps
                	result:addUnique(parents:get(count))
                end
            end
        end
    end
end

function OT:getChildByKey(key, value)
	for i = 1, self.c do
		local child = self.e[i] 
		if child[key] and child[key] == value then
			return child
		end
	end
	return nil
end

function OT:getBy(key, value, steps)
	local result, parents = A:OrderedTable(), A:OrderedTable()
	--search(result, self.e, key, value, steps, parents)
    return result:count() ~= 0 and (result:count() == 1 and result:get(1) or result) or nil
end

function OT:get(i)
	return self.e[i]
end

function OT:first()
	return self.e[1]
end

function OT:last()
	return self.e[self.c]
end

function OT:count()
	return self.c
end

function OT:isEmpty()
	return self:count() == 0
end

function OT:isSize(size)
	return self:count() == size
end

function A:OrderedTable(s)

	local opt = { 
		e = {},
		i = 0,
		c = 0,
		s = -1, 
	}

	OT.__index = OT
	setmetatable(opt, OT)

	return opt
end

function A:Option(builder)
  local opt = {
    children = A:OrderedTable(),
    items = A:OrderedTable(),
    isGroup = function() return self.children:count() > 0 end,
    getChildren = function() return self.children end,
    getItems = function() return self.items end,
    getName = function()
      return self.name
    end,
    getDesc = function()
      return self.desc
    end,
    getDirection = function()
      return self.direction
    end,
    getMin = function()
      return self.min
    end,
    getMax = function()
      return self.max
    end,
    getDefaultValue = function()
      return self.defaultValue
    end,
    getOrder = function()
      return self.order
    end,
    getEnabledFunc = function()
      return self.func
    end,
    getType = function()
      return self.type
    end,
    getGroupStyle = function()
      return self.groupStyle
    end
  }
  
  opt.children = builder.children
  opt.items = builder.items
  opt.id = builder.id
  opt.name = builder.name
  opt.desc = builder.desc
  opt.direction = builder.direction
  opt.min = builder.min
  opt.max = builder.max
  opt.defaultValue = builder.defaultValue
  opt.order = builder.order
  opt.func = builder.func
  opt.type = builder.type
  opt.groupStyle = builder.groupStyle
  
	return opt
end

function A:OptionBuilder()
  local opt = {
    children = A:OrderedTable(),
    items = A:OrderedTable(),
  }
  
  function opt:addChild(child) 
    self.children:add(child) 
    return self 
  end
  function opt:addChildren(children)
    for i = 1, children:count() do
      self:addChild(children:get(i))
    end
    return self
  end
  function opt:addItem(item) 
    self.items:add(item) 
    return self 
  end
  function opt:addItems(items)
    for i = 1, items:count() do
      self:addItem(items:get(i))
    end
    return self
  end
  function opt:withId(id) 
    self.id = id 
    return self 
  end
  function opt:withName(name)
      self.name = name
      return self
  end
  function opt:withDesc(desc)
    self.desc = desc
    return self
  end
  function opt:withDirection(direction)
    self.direction = direction
    return self
  end
  function opt:withMin(min)
    self.min = min
    return self
  end
  function opt:withMax(max)
    self.max = max
    return self
  end
  function opt:withDefaultValue(value)
    self.defaultValue = value;
    return self
  end
  function opt:withOrder(order)
      self.order = order
      return self
  end
  function opt:withEnabledFunc(func)
      self.func = func
      return self
  end
  function opt:withType(type)
    self.type = type
    return self
  end
  function opt:withGroupStyle(style)
    self.groupStyle = style
    return self
  end
  function opt:build()
    return A:Option(self)
  end
  
  return opt
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

  function o:withReplaceCallback(callback)
    self.replaceCallback = callback
    return self
  end

  function o:build()
    self.column.getView = self.view
    self.column.replaceCallback = self.replaceCallback
    self.column.rows = self.rows

    self.column.alignRows = function(self, parent) 
      for index, row in next, self.rows do
        if row.first then
          row.relative = parent
          row:SetPoint(E.regions.T, row.relative, E.regions.T, 0, 0)
        else
          row.relative = self.rows:get(index-1)
          row:SetPoint(E.regions.T, row.relative, E.regions.B, 0, 0)
        end
        row:SetSize(parent:GetWidth(), parent:GetWidth() / self.rows:count())
      end
    end

    return self.column
  end

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

    if not column.rows:isEmpty() then
      column:SetScript("OnClick", A.DropdownBuilder)
    else
      column:SetScript("OnClick", function(self, b, d)
        if b == "LeftButton" and not d then
          self:replaceCallback(self)
        end
      end)
    end

    self.columns:add(column)
    return self
  end

  function o:build()
    return self.row
  end

end

function A:GridBuilder(parent, isSingleLevel)

  local o = {
    parent = parent,
    previousButton = nil,
    isSingleLevel = isSingleLevel,
    rows = A:OrderedTable()
  }

  function o:addRow(row)
    row:SetParent(self.parent)
    row:SetSize(self.parent:GetWidth(), self.parent:GetWidth() / row.columns:size())

    for _,column in next, row.columns do
      column:SetSize(row:GetHeight(), row:GetHeight())
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

end