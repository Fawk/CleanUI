local AddonName, Args = ...

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
  if type(t) == "table" then
    local p = self.e[self.c - 1]
    if p then
      t.previous = p
      p.next = t
    end
    t.parent = self
    t.index = self.c
  end
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

function OT:addUniqueByKey(t, k, v)
  local f = false
  self:foreach(function(i)
    if (i[k] == v) then f = true end
  end)
  if (not f) then 
    return self:add(t) 
  end
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

function OT:getRelative(default)
  local count = self:count()
  return count == 0 and default or self:get(count)
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
	local result, parents = Args:OrderedTable(), Args:OrderedTable()
	--search(result, self.e, key, value, steps, parents)
    return result:count() ~= 0 and (result:count() == 1 and result:get(1) or result) or nil
end

function OT:foreach(func)
  for i = 1, self.c do
    func(self.e[i])
  end
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

function OT:isLessThan(size)
  return self:count() < size
end

function OT:isMoreThan(size)
  return self:count() > size
end

function OT:isLessOrEqualTo(size)
  return self:count() <= size
end

function OT:isMoreOrEqualTo(size)
  return self:count() >= size
end

function OT:isSize(size)
	return self:count() == size
end

function Args:OrderedTable(s)

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

function Args:Option(builder)
  local opt = {
    children = Args:OrderedTable(),
    items = Args:OrderedTable(),
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

function Args:OptionBuilder()
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
    self.defaultValue = value
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