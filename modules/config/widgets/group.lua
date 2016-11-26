local A, L = unpack(select(2, ...))
local E, T, media = A.enum, A.Tools, LibStub("LibSharedMedia-3.0")

A:Debug("Creating toggle widget")

local Group = {}

function Group:View(holder, container, creator)

    local previousOption
    if holder.group then
        local groupChildren = holder.group.children
        if groupChildren:count() >= 1 then 
            previousOption = groupChildren:last()
        else
            previousOption = holder.group.title
        end
    else
        previousOption = creator:GetPreviousOption(holder.order)
    end

    holder:SetPoint(E.regions.T, previousOption or container, previousOption and E.regions.B or E.regions.T, 0, not previousOption and -25 or -5)

    holder:SetPoint(E.regions.L, container, E.regions.L, 20, 0)
    holder:SetPoint(E.regions.R, container, E.regions.R, -20, 0)

    T.Desc:Set({ holder }, holder, holder.name, holder.desc)

    holder.SetEnabled = function(self, enabled)
	    for i = 1, self.children:count() do
	    	local child = self.children:get(i) 
	    	if enabled == false then
	    		child:SetEnabled(enabled)
	    	else
	    		child:SetEnabled(child.enabled)
	    	end
		end
    end    

    return holder
end

function Group:Create(group, container, creator)

    local holder = CreateFrame("Frame", group.name.."_HOLDER", container)
    holder:SetBackdrop(E.backdrops.optiongroupborder)
    holder:SetBackdropColor(0, 0, 0, 0)
    holder:SetBackdropBorderColor(0,0,0,0)
    holder.isGroup = true

    if group.group then
    	holder.db = group.group.db[group.name]
    else
    	holder.db = A["Profile"][group.name]
   	end
    
    holder.children = A:OrderedTable()
    self.name = group.name
    holder.name = group.name
    holder.desc = group.desc
    holder.order = group.order

    holder.title = CreateFrame("Frame", nil, holder)
    holder.title:SetPoint(E.regions.TL)
    holder.title:SetPoint(E.regions.TR)
    holder.title:SetHeight(20)

    holder.title.text = holder.title:CreateFontString(nil, "OVERLAY")
    holder.title.text:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
    holder.title.text:SetText(group.name)
    holder.title.text:SetPoint(E.regions.L, holder.title, E.regions.L, 11, -5)

    local calculatedHeight = 30
    if group.options then
	    for i = 1, group.options:count() do
	    	local child = group.options:get(i)
	    	child.group = holder
	    	local created = A.widgets[child.type]:Create(child, holder, creator)
	    	holder.children:add(created)
      
	        creator.shortcuts[child.id] = created

	    	if child.type == "group" then
				calculatedHeight = calculatedHeight + created.calculatedHeight 
	    	else
	    		calculatedHeight = calculatedHeight + E.optionheight[child.type]
	    	end
		end
	end

	if holder.children:count() > 0 and group.groupStyle == "dropdown" then

		local r = A:OrderedTable()
		for i = 1, holder.children:count() do
			local option = holder.children:get(i)
			r:add({ option.name, option.name })
			option:Hide()
		end

		holder.children:first():Show()
		A.StandaloneWidgets:CreateDropdown(holder, r, holder.children:first().name, function(selected)
			for i = 1, holder.children:count() do
				local option = holder.children:get(i)
				option:Hide()
				if option.name == selected then
					option:Show()
				end
			end
		end, nil)

		holder.top:ClearAllPoints()
		holder.top:SetPoint(E.regions.TR, holder, E.regions.TR, -5, -5)
		holder.top:SetWidth(150)
	end


	holder.calculatedHeight = calculatedHeight

	holder:SetHeight(calculatedHeight)

	function holder:GetValue()
		local values = {}
		for i = 1, self.children:count() do
	    	local child = self.children:get(i)
	    	values[child.name] = child:GetValue()
		end
		return T.Table:merge(holder.db, values)
	end

    holder.enabled = group.enabledFunc or function() return true end
    holder.subscribers = group.subscribers
    holder.AddSubscriber = group.AddSubscriber

    function holder:Notify()
	    for _,subscriber in pairs(self.subscribers) do
            if subscriber.Update then 
                subscriber:Update(self:GetValue())
            end
        end
    end

    return self:View(holder, container, creator)
end

A:RegisterWidget("group", Group)