local A, L, keys = unpack(select(2, ...))
local T = A.Tools

A:Debug("Creating options container")

local Container = {
	options = {},
	shortcuts = {}
}

function Container:GetPreviousOption(order)
	local options = self.options[order-1]
	local same = self.options[order]

	if options then
		if options:count() > 1 then
			if same then
				return same:count() > 1 and same:last() or same:first()
			else
				return options:last()
			end
		else
			return options:first()
		end
	else
		if same then
			return same:count() > 1 and same:last() or same:first()
		end
	end
	return nil
end

function Container:CreateOptions(optionsWindow, opts)
	
	A:Debug("Creating options")
	
	for i = 1, opts:count() do
		local option = opts:get(i)
		A:Debug("Running create function on widget of type:", option.type, option.name)
		local created = A.widgets[option.type]:Create(option, optionsWindow, self)
		if not self.options[option.order] then 
			A:Debug("Option table for order:", option.order, "did not exist, creating...")
			self.options[option.order] = A:OrderedTable() 
		end

		created.Notify = function(self)
			for _,subscriber in pairs(self.subscribers) do
				if subscriber.Update then 
					subscriber:Update(self:GetValue())
				end
			end
		end
        self.shortcuts[option.id] = created
		
		self.options[option.order]:add(created)
	end
	
	self:Update()
end

function Container:Update()
	A:Update()
end

function Container:GetOption(id)
	return shortcuts[keys[id]]
end

A["OptionsContainer"] = Container