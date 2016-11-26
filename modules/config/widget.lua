local A, L = unpack(select(2, ...))

A:Debug("Creating widgets table")
A.widgets = {}

function A:RegisterWidget(widgetName, obj)
	A:Debug("Registering widget with name: ", widgetName)
	if not A.widgets[widgetName] then
		A.widgets[widgetName] = obj
	else
		A:Print(string.format(L["Widget with name '%s' already exists!"], widgetName))
	end
end
