local A, L = unpack(select(2, ...))
local E, T = A.enum, A.Tools

local Options = {}

local function base(t, id, name, desc, direction, order, enabledFunc, options, extras)
	local o = {
		type = t,
		id = id,
		name = name,
		desc = desc,
		direction = direction,
		order = order,
		options = options ~= nil and T.Table:orderedWidgets(name, options) or nil,
		enabledFunc = enabledFunc,
		subscribers = {},
	}
	o.AddSubscriber = function(self, module) table.insert(self.subscribers, module) end

	if extras and type(extras) == "table" then
		for k,v in pairs(extras) do
			o[k] = v
		end
	end

	return o
end

function Options:CreateRadio(id, name, desc, direction, order, enabledFunc, options)
	return base("radiobutton", id, name, desc, direction, order, enabledFunc, options)
end

function Options:CreateSlider(id, name, desc, direction, min, max, defaultValue, order, enabledFunc)
	return base("slider", id, name, desc, direction, order, enabledFunc, nil, { min = min, max = max, defaultValue = defaultValue })
end

function Options:CreateColor(id, name, desc, order, enabledFunc)
	return base("color", id, name, desc, nil, order, enabledFunc, nil)
end

function Options:CreateTextbox(id, name, desc, order, enabledFunc)
	return base("textbox", id, name, desc, nil, order, enabledFunc, nil)
end

function Options:CreateButton(id, name, desc, order, enabledFunc)
	return base("button", id, name, desc, direction, order, enabledFunc, nil)
end

function Options:CreateToggle(id, name, desc, direction, order, enabledFunc)
	return base("toggle", id, name, desc, direction, order, enabledFunc, nil)
end

function Options:CreateLabel(id, name, desc, order)
	return base("label", id, name, desc, nil, order, nil)
end

function Options:CreateDropdown(id, name, desc, direction, order, enabledFunc, options)
	return base("dropdown", id, name, desc, direction, order, enabledFunc, options)
end

function Options:CreateGroup(id, name, desc, order, groupStyle, enabledFunc, options)
	return {
		type = "group",
		id = id,
		name = name,
		desc = desc,
		order = order,
		groupStyle = groupStyle,
		options = options,
		subscribers = {},
		AddSubscriber = function(self, module) table.insert(self.subscribers, module) end
	}
end

function Options:PositionOptions(ids, unit, type, relatives)
	local positionOptions = A:OrderedTable()
	positionOptions:add(self:CreateDropdown(ids[1], "Local Point", string.format("The local point of the %s %s", unit, type), E.directions.H, 1, nil, E.optionLists.regions))
	positionOptions:add(self:CreateDropdown(ids[2], "Relative To", string.format("The relative frame which to position the %s %s against", unit, type), E.directions.H, 1, nil, relatives))
	positionOptions:add(self:CreateDropdown(ids[3], "Point", "The point of the relative frame", E.directions.H, 1, nil, E.optionLists.regions))
	positionOptions:add(self:CreateSlider(ids[4], "Offset X", "The horizontal offset to the relative frame", E.directions.H, E.unitoffset.min, E.unitoffset.max, 0, 1))
	positionOptions:add(self:CreateSlider(ids[5], "Offset Y", "The vertical offset to the relative frame", E.directions.H, E.unitoffset.min, E.unitoffset.max, 0, 1))
	return positionOptions
end

A.Options = Options