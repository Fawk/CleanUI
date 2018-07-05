local A, L = unpack(select(2, ...))
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization

local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local buildDropdown = A.DropdownBuilder
local buildGroup = A.GroupBuilder
local buildEditBox = A.EditBoxBuilder
local buildColor = A.ColorBuilder
local buildToggle = A.ToggleBuilder
local buildNumber = A.NumberBuilder

local function tcount(t)
    local count = 0
    for k,v in next, t do
        count = count + 1
    end
    return count
end

local function printTable(t)
    for k,v in next, t do print(k,v) end
end

local media = LibStub("LibSharedMedia-3.0")

local bdColor = { 39/255, 37/255, 37/255, 1 }
local transparent = { 0, 0, 0, 0 }

local function setBackdropForEnabled(button, enabled)
    if (enabled) then
        button:SetBackdropColor(unpack(bdColor))
    else
        button:SetBackdropColor(180/255, 33/255, 33/255, 0.7)
    end
end

local function createDropdownTable(...)
    local tbl = {}
    for _,v in next, {...} do
        tbl[v] = v
    end
    return tbl
end

local function getChildWithOrder(group, groupName, order)
    for name, child in next, group.children do
        if (child.order and child.order == order) then
            return name, child
        end
    end
    A:Debug("Could not find child with order:", order, "for group:", groupName)
end

local function createToggle(key, item, parent)
    if (parent.enabledToggle) then
        parent.enabledToggle:Hide()
    end

    local enabled = item.enabled
    if (enabled) then
        local toggle = buildToggle(parent):atRight():x(-37):texts("ON", "OFF"):onClick(function(self)
            enabled:set(item.db, self.checked)
        end):build()

        toggle:SetValue(enabled:get(item.db["Enabled"]))

        parent.enabledToggle = toggle
    end
end

local function getEnabledFuncOrTrue(widget, child, db)
    if (child.enabled) then
        if (type(child.enabled) == "table") then
            return function() return child.enabled:get(db["Enabled"]) end
        else
            return function() return child:enabled(widget, child, db) end
        end
    end
    return function() return true end
end

local widgets = A:OrderedTable()
local function changeStateForWidgets()
    widgets:foreach(function(widget)
        if (widget.enabled) then
            local gp = widget.groupParent
            local enabled = widget.enabled
            if (type(enabled) == "table") then
                if (widget.db["Enabled"] == nil) then
                    print("SOMEBODY ONCE TOLD ME", widget.name)
                    for k,v in next, gp.db do print(k,v) end
                    print("------------")
                    for k,v in next, widget.db do print(k,v) end
                end
                widget:SetActive(enabled:get(widget.db["Enabled"]))
            else
                local enabled = widget:enabled(gp, widget.item, gp.db)
                widget:SetActive(enabled)

                local r, g, b, a = gp:GetBackdropColor()
                if (r) then
                    setBackdropForEnabled(gp, enabled)
                end
            end
        end
    end)
end

local O = {}

function O:CreateChild(childName, child, group, parent, childRelative)

    if (not child.db and group.db) then
        child.db = group.db[childName]
    end

    child.name = childName

    local childWidgetBuilder
    if (child.type == "group") then

        if (not parent.groups) then
            parent.groups = A:OrderedTable()
        end

        childWidgetBuilder = buildDropdown(parent)
                :size(parent:GetWidth(), 32)
                :overrideText(childName)
                :rightOfButton()
                :stayOpenAfterChoosing()
                :overrideRelative(parent.groups:first())
                :addItems(child.children)
                :fontSize(11)
                :onHover(function(self, d, b)
                    if (self.hover) then
                        local r, g, b, a = self:GetBackdropColor()
                        self:SetBackdropColor(r * 0.33, g * 0.33, b * 0.33, 1)
                    else
                        self:SetBackdropColor(unpack(bdColor))
                    end
                end)
                :onItemHover(function(self, motion)
                    local disabled = false

                    if (self.item) then
                        if (self.item.enabled) then
                            if (type(self.item.enabled) == "function") then
                                if (not self.item:enabled(self, self.item, child.db)) then
                                    disabled = true
                                end
                            else
                                if (not self.item.db["Enabled"]) then
                                    disabled = true
                                end
                            end
                        else
                            if (self.item.type == "toggle") then
                                if (not self.item.db) then
                                    disabled = true
                                end
                            end
                        end
                    end

                    if (not disabled) then
                        if (self.hover) then
                            local r, g, b, a = self:GetBackdropColor()
                            self:SetBackdropColor(r * 0.33, g * 0.33, b * 0.33, 1)
                        else
                            self:SetBackdropColor(unpack(bdColor))
                        end
                    end
                end)
                :backdrop(A.enum.backdrops.editboxborder, bdColor, transparent)
                :onClick(function(self, dropdown, mouseButton)
                    parent.groups:foreach(function(item)
                        item.selectedButton:SetBackdropBorderColor(unpack(transparent))
                        item:Close()
                    end)

                    local first = parent.groups:first()

                    if (first.groups) then
                        first.groups:foreach(function(group)
                            group:Close()
                            group:Hide()
                        end)

                        first.groups = A:OrderedTable()
                    end

                    if (first.children) then
                        first.children:foreach(function(child)
                            child:Hide()
                            child.anchor:Hide()
                        end)

                        first.children = A:OrderedTable()
                    end

                    if (mouseButton == "RightButton") then
                        print("Disable group: ", childName)
                    elseif (mouseButton == "LeftButton") then
                        self.dropdown:Open()
                        self.dropdown.selectedButton:SetBackdropBorderColor(1, 1, 1, 1)
                    end
                end)
                :onItemClick(function(self, button, dropdown, mouseButton)

                    print(button.item.name)

                    local first = parent.groups:first()

                    if (first.groups) then
                        first.groups:foreach(function(group)
                            group:Close()
                            group:Hide()
                        end)

                        first.groups = A:OrderedTable()
                    end

                    local item = button.item
                    local type = item.type

                    if (not item.db) then
                        item.db = child.db[button.name]
                    end

                    if (type == "group") then

                        button.name = item.name
                        local enabled = item.enabled
                        if (mouseButton == "RightButton") then
                            if (item.enabled) then
                                item.db["Enabled"] = not item.db["Enabled"]
                                A.dbProvider:Save()
                                changeStateForWidgets()
                                A:UpdateDb()

                                setBackdropForEnabled(button, item.db["Enabled"])
                            end
                        elseif (mouseButton == "LeftButton") then
                            if (not enabled or enabled:get(item.db["Enabled"])) then
                                O:CreateGroup(button, first, first)
                            end
                        end
                    else
                        if (not first.children) then
                            first.children = A:OrderedTable()
                        else
                            first.children:foreach(function(child)
                                child:Hide()
                                child.anchor:Hide()
                            end)

                            first.children = A:OrderedTable()
                        end

                        if (type == "toggle" and mouseButton == "RightButton") then
                            child.db[button.name] = not child.db[button.name]
                            button.item.db = child.db[button.name]
                            setBackdropForEnabled(button, button.item.db)

                            A.dbProvider:Save()
                            changeStateForWidgets()
                            A:UpdateDb()
                        end
                    end
                end)
                :onChildCreation(function(self, builder, button)
                    if (button.item) then 
                        local item = button.item
                        local type = item.type

                        if (not item.db) then
                            item.db = child.db[button.name]
                        end

                        if (type ~= "group") then
                            local widgetBuilder

                            if (button.widget) then
                                button.widget:Hide()
                            end

                            if (type == "color") then
                                widgetBuilder = buildColor(button)
                                        :size(30, 30)
                                        :atRight()
                                        :x(-1)
                            elseif (type == "text") then
                                widgetBuilder = buildEditBox(button)
                                        :atRight()
                                        :size(child.width or 30, child.height or 30)
                            elseif (type == "number") then
                                widgetBuilder = buildNumber(button)
                                        :size(child.width or 30, child.height or 30)
                                        :atRight()
                                        :min(child.min)
                                        :max(child.max)
                            elseif (type == "dropdown") then
                                widgetBuilder = buildDropdown(button)
                                        :addItems(item.values)
                                        :atRight()
                                        :size(parent:GetWidth(), 32)
                                        :backdrop(A.enum.backdrops.editboxborder, bdColor, transparent)
                                        :hideSelectedButtonBackdrop()
                                        :selectedButtonTextHorizontalAlign("RIGHT")
                                        :rightOfButton()
                                        :fontSize(11)
                                        :onItemHover(function(self, motion)

                                        end)
                                        :onHover(function(self, motion)

                                        end)
                                        :onClick(function(self, dropdown, mouseButton)

                                        end)
                                        :onItemClick(function(self, button, mouseButton)

                                        end)
                                        :onChildCreation(function(self, builder, button)

                                        end)
                            elseif (type == "toggle") then

                                setBackdropForEnabled(button, button.item.db)
                            end

                            if (widgetBuilder) then
                                button.widget = widgetBuilder
                                        :activeCondition(getEnabledFuncOrTrue(child, button.item, child.db))
                                        :onValueChanged(function(self, widget, value)
                                            button.item:set(child.db, value)
                                            setBackdropForEnabled(button, child.db[button.name])
                                            A.dbProvider:Save()
                                            changeStateForWidgets()
                                            A:UpdateDb()
                                        end)
                                        :build()

                                if (item.enabled) then
                                    local enabled = item:enabled(button, item, child.db)
                                    setBackdropForEnabled(button, enabled)
                                    button.widget:SetActive(enabled)
                                end

                                if (not button.db) then
                                    button.db = child.db
                                end

                                button.widget.groupParent = button
                                button.widget.db = child.db[button.name]
                                button.widget.name = button.name
                                button.widget.item = item
                                button.widget.enabled = item.enabled
                                button.widget:SetValue(button.item:get(child.db[button.name]))

                                widgets:add(button.widget)
                            end
                        else
                            if (item.enabled) then
                                setBackdropForEnabled(button, item.db["Enabled"])
                            end
                        end
                    end
                end)
    elseif (child.type == "text") then
        childWidgetBuilder = buildEditBox(parent)
                :atRight()
                :size(child.width or 30, child.height or 30)
    elseif (child.type == "number") then
        childWidgetBuilder = buildNumber(parent)
                :size(child.width or 30, child.height or 30)
                :atRight()
                :min(child.min)
                :max(child.max)
    elseif (child.type == "dropdown") then
        childWidgetBuilder = buildDropdown(parent)
                :addItems(child.values)
                :atRight()
                :size(parent:GetWidth(), 32)
                :backdrop(A.enum.backdrops.editboxborder, bdColor, transparent)
                :hideSelectedButtonBackdrop()
                :selectedButtonTextHorizontalAlign("RIGHT")
                :rightOfButton()
                :fontSize(11)
                :onItemHover(function(self, motion)
                    if (self.hover) then
                        local r, g, b, a = self:GetBackdropColor()
                        self:SetBackdropColor(r * 0.33, g * 0.33, b * 0.33, 1)
                    else
                        self:SetBackdropColor(unpack(bdColor))
                    end
                end)
                :onHover(function(self, motion)

                end)
                :onClick(function(self, dropdown, mouseButton)

                end)
                :onItemClick(function(self, button, mouseButton)

                end)
                :onChildCreation(function(self, builder, button)

                end)
    elseif (child.type == "toggle") then
        childWidgetBuilder = buildToggle(parent)
                :atRight()
                :texts("ON", "OFF")
    elseif (child.type == "color") then
        childWidgetBuilder = buildColor(parent)
                :size(30, 30)
                :atRight()
                :x(-1)
    end

    local childWidget = childWidgetBuilder
            :activeCondition(getEnabledFuncOrTrue(group, child, group.db))
            :onValueChanged(function(self, widget, value)
                child:set(group.db, value)
                A.dbProvider:Save()
                changeStateForWidgets()
                A:UpdateDb()
            end)
            :build()

    local anchorBuilder = buildButton(parent)
            :size(parent:GetSize())
            :backdrop(A.enum.backdrops.editboxborder, bdColor, transparent)

    if (childRelative == parent) then
        anchorBuilder:rightOf(childRelative):x(parent:GetWidth())
    else
        anchorBuilder:below(childRelative)
    end

    childWidget.anchor = anchorBuilder:build()
    childWidget.anchor:SetFrameLevel(5)

    childWidget:ClearAllPoints()
    childWidget:SetPoint("RIGHT", childWidget.anchor, "RIGHT", 0, 0)
    childWidget:SetFrameLevel(6)

    childWidget.title = buildText(childWidget.anchor, 11)
            :outline()
            :x(6)
            :atLeft()
            :build()

    childWidget.title:SetText(childName)

    if (child.type ~= "group") then
        childWidget:SetValue(child:get(group.db[childName]))
    else
        parent.groups:addUniqueByKey(childWidget, "name", childName)
    end

    parent.db = group.db

    childWidget.type = child.type
    childWidget.enabled = child.enabled
    childWidget.name = childName
    childWidget.db = child.db
    childWidget.groupParent = parent

    widgets:add(childWidget)

    return childWidget
end

function O:CreateGroup(button, parent, relative)
    local name, group = button.name, button.item

    if (not parent.children) then
        parent.children = A:OrderedTable()
    else
        parent.children:foreach(function(child)
            child:Hide()
            child.anchor:Hide()
        end)

        parent.children = A:OrderedTable()
    end

    local childRelative = relative
    for i = 1, tcount(group.children) do
        local childName, child = getChildWithOrder(group, name, i)
        if (childName and child) then

            local childWidget = O:CreateChild(childName, child, group, parent, childRelative)
            local added = parent.children:addUniqueByKey(childWidget, "name", childName)

            if (not added) then
                childWidget:Hide()
                childWidget.anchor:Hide()
            else
                if (child.enabled) then
                    if (child.type ~= "group") then
                        for k,v in next, group.db do print(k,v) end
                        local enabled = child:enabled(widget, child, group.db)
                        print("CreateGroup", name, childName, enabled)
                        childWidget:SetActive(enabled)
                    else
                        childWidget:SetActive(child.enabled:get(child.db["Enabled"]))
                    end
                else
                    if (group.enabled) then
                        local enabled = group.enabled:get(group.db["Enabled"])
                        childWidget:SetActive(enabled)
                    else
                        childWidget:SetActive(true)
                    end
                end

                childRelative = childWidget.anchor
            end
        end
    end
end

local function createScrollFrame(parent)
    local scrollContent = CreateFrame("Frame", nil, parent)
    scrollContent:SetAllPoints()
    scrollContent:SetSize(parent:GetWidth(), 465)
    scrollContent:EnableMouseWheel(true)

    parent:SetScrollChild(scrollContent)

    return scrollContent
end

function A:ConstructPreferences(db)

	local prefs = {
		["General"] = {
			type = "group",
            order = 1,
			children = {

			}
		},
		["Units"] = {
			type = "group",
            order = 2,
			children = {
				["Player"] = {
                    enabled = {
                        type = "toggle",
                        set = function(self, db, value)
                            db["Enabled"] = value
                        end,
                        get = function(self, db)
                            return db
                        end
                    },
                    type = "group",
                    order = 1,
                    children = {
                        ["Health"] = {
                            enabled = {
                                type = "toggle",
                                set = function(self, db, value)
                                    db["Enabled"] = value
                                end,
                                get = function(self, db)
                                    return db
                                end
                            },
							type = "group",
                            order = 1,
							children = {
                                ["Color By"] = {
                                    type = "dropdown",
                                    order = 1,
                                    values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Color By"] = value
                                    end
                                },
                                ["Custom Color"] = {
                                    enabled = function(self, parent, item, db)
                                        return db["Color By"] == "Custom"
                                    end,
                                    type = "color",
                                    order = 2,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Custom Color"] = value
                                    end
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    order = 3,
                                    min = -1,
                                    max = 1,
                                    width = 30,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Background Multiplier"] = value
                                    end 
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    order = 4,
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Orientation"] = value
                                    end 
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    order = 5,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Reversed"] = value
                                    end 
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 6,
                                    values = media:List("statusbar"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Texture"] = value
                                    end
                                },
                                ["Position"] = {
                                    type = "group",
                                    order = 7,
                                    children = {
                                        ["Point"] = {
                                            type = "dropdown",
                                            order = 1,
                                            values = A.Tools.points,
                                            set = function(self, db, value)
                                                db["Point"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                        ["Local Point"] = {
                                            type = "dropdown",
                                            order = 2,
                                            values = A.Tools.points,
                                            set = function(self, db, value)
                                                db["Local Point"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                        ["Relative To"] = {
                                            type = "dropdown",
                                            order = 3,
                                            values = createDropdownTable("Player", "Power"),
                                            set = function(self, db, value)
                                                db["Relative To"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                    }
                                },
                                ["Size"] = {
                                    type = "group",
                                    order = 8,
                                    children = {
                                        ["Match width"] = {
                                            type = "toggle",
                                            order = 1,
                                            set = function(self, db, value)
                                                db["Match width"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
                                            order = 2,
                                            set = function(self, db, value)
                                                db["Match height"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end                                         
                                        },
                                        ["Width"] = {
                                            enabled = function(self, parent, item, db) 
                                                return not db["Match width"]
                                            end,
                                            type = "number",
                                            order = 3,
                                            min = 1,
                                            width = 40,
                                            max = GetScreenWidth(),
                                            set = function(self, db, value)
                                                db["Width"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end     
                                        },
                                        ["Height"] = {
                                            enabled = function(self, parent, item, db) 
                                                return not db["Match height"]
                                            end,
                                            type = "number",
                                            min = 1,
                                            order = 4,
                                            width = 40,
                                            max = GetScreenHeight(),
                                            set = function(self, db, value)
                                                db["Height"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end     
                                        }
                                    }
                                },
                                ["Missing Health Bar"] = {
                                    enabled = {
                                        type = "toggle",
                                        set = function(self, db, value)
                                            db["Enabled"] = value
                                        end,
                                        get = function(self, db)
                                            return db 
                                        end
                                    },
                                    type = "group",
                                    order = 9,
                                    children = {
                                        ["Custom Color"] = {
                                            enabled = function(self, parent, item, db)
                                                return db["Color By"] == "Custom"
                                            end,
                                            order = 1,
                                            type = "color",
                                            get = function(self, db) return db end,
                                            set = function(self, db, value)
                                                db["Custom Color"] = value
                                            end
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            order = 2,
                                            values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                            get = function(self, db) return db end,
                                            set = function(self, db, value)
                                                db["Color By"] = value
                                            end
                                        }
                                    }
                                }
							}
						},
						["Power"] = {
                            enabled = {
                                type = "toggle",
                                set = function(self, db, value)
                                    db["Enabled"] = value
                                end,
                                get = function(self, db) return db end
                            },
                            type = "group",
                            order = 2,
                            children = {
                                ["Color By"] = {
                                    type = "dropdown",
                                    order = 1,
                                    values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Color By"] = value
                                    end
                                },
                                ["Custom Color"] = {
                                    enabled = function(self, parent, item, db)
                                        return db["Color By"] == "Custom"
                                    end,
                                    type = "color",
                                    order = 2,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Custom Color"] = value
                                    end
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    order = 3,
                                    min = -1,
                                    max = 1,
                                    width = 30,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Background Multiplier"] = value
                                    end 
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    order = 4,
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Orientation"] = value
                                    end 
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    order = 5,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Reversed"] = value
                                    end 
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 6,
                                    values = media:List("statusbar"),
                                    get = function(self, db) return db  end,
                                    set = function(self, db, value)
                                        db["Texture"] = value
                                    end
                                },
                                ["Position"] = {
                                    type = "group",
                                    order = 7,
                                    children = {
                                        ["Point"] = {
                                            type = "dropdown",
                                            order = 1,
                                            values = A.Tools.points,
                                            set = function(self, db, value)
                                                db["Point"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                        ["Local Point"] = {
                                            type = "dropdown",
                                            order = 2,
                                            values = A.Tools.points,
                                            set = function(self, db, value)
                                                db["Local Point"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                        ["Relative To"] = {
                                            type = "dropdown",
                                            order = 3,
                                            values = createDropdownTable("Player", "Health"),
                                            set = function(self, db, value)
                                                db["Relative To"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                    }
                                },
                                ["Size"] = {
                                    type = "group",
                                    order = 8,
                                    children = {
                                        ["Match width"] = {
                                            type = "toggle",
                                            order = 1,
                                            set = function(self, db, value)
                                                db["Match width"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
                                            order = 2,
                                            set = function(self, db, value)
                                                db["Match height"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end                                         
                                        },
                                        ["Width"] = {
                                            enabled = function(self, parent, item, db) 
                                                return not db["Match width"]
                                            end,
                                            type = "number",
                                            order = 3,
                                            min = 1,
                                            max = GetScreenWidth(),
                                            set = function(self, db, value)
                                                db["Width"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end     
                                        },
                                        ["Height"] = {
                                            enabled = function(self, parent, item, db) 
                                                return not db["Match height"]
                                            end,
                                            type = "number",
                                            order = 4,
                                            min = 1,
                                            max = GetScreenHeight(),
                                            set = function(self, db, value)
                                                db["Height"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end     
                                        }
                                    }
                                },
                                ["Missing Power Bar"] = {
                                    enabled = {
                                        type = "toggle",
                                        set = function(self, db, value)
                                            db["Enabled"] = value
                                        end,
                                        get = function(self, db) return db end
                                    },
                                    type = "group",
                                    order = 9,
                                    children = {
                                        ["Custom Color"] = {
                                            enabled = function(self, parent, item, db)
                                                return db["Color By"] == "Custom"
                                            end,
                                            type = "color",
                                            get = function(self, db) return db end,
                                            set = function(self, db, value)
                                                db["Custom Color"] = value
                                            end
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                            get = function(self, db) return db end,
                                            set = function(self, db, value)
                                                db["Color By"] = value
                                            end
                                        }
                                    }
                                }
                            }
						},
						["Castbar"] = {

						},
						["Alternative Power"] = {

						},
						["Class Power"] = {

						},
						["Combat"] = {

						},
						["Stagger"] = {

						},
						["Buffs"] = {

						},
						["Debuffs"] = {

						}
					}
				},
				["Target"] = {
                    enabled = {
                        type = "toggle",
                        set = function(self, db, value)
                            db["Enabled"] = value
                        end,
                        get = function(self, db)
                            return db
                        end
                    },
                    type = "group",
                    order = 2,
                    children = {}
				},
				["Target of Target"] = {
                    enabled = {
                        type = "toggle",
                        set = function(self, db, value)
                            db["Enabled"] = value
                        end,
                        get = function(self, db)
                            return db
                        end
                    },
                    type = "group",
                    order = 3,
                    children = {}
				},
				["Pet"] = {
                    enabled = {
                        type = "toggle",
                        set = function(self, db, value)
                            db["Enabled"] = value
                        end,
                        get = function(self, db)
                            return db
                        end
                    },
                    type = "group",
                    order = 4,
                    children = {}
				}
			}
		},
		["Group"] = {
			type = "group",
            order = 3,
			children = {
				["Party"] = {
					type = "group",
                    order = 1,
					children = {

                    }
				},
				["Raid"] = {
					type = "group",
                    order = 2,
					children = {}
				}
			}
		}
	}

    local frame = CreateFrame("Frame", nil, A.frameParent)
    frame:SetSize(1, 1)
    frame:SetPoint("TOPLEFT", 0, -300)
    frame.groups = A:OrderedTable()

    local relative = frame
    for name, group in next, prefs do
        local widget = buildDropdown(relative)
                :atTopLeft()
                :againstBottomLeft()
                :size(200, 32)
                :overrideText(name)
                :rightOfButton()
                :stayOpenAfterChoosing()
                :overrideRelative(frame.groups:first())
                :fontSize(11)
                :addItems(group.children)
                :backdrop(A.enum.backdrops.editboxborder, bdColor, transparent)
                :onItemHover(function(self, motion)
                    if (self.hover) then
                        local r, g, b, a = self:GetBackdropColor()
                        self:SetBackdropColor(r * 0.33, g * 0.33, b * 0.33, 1)
                    else
                        self:SetBackdropColor(unpack(bdColor))
                    end
                end)
                :onHover(function(self, motion)
                    if (self.hover) then
                        local r, g, b, a = self:GetBackdropColor()
                        self:SetBackdropColor(r * 0.33, g * 0.33, b * 0.33, 1)
                    else
                        self:SetBackdropColor(unpack(bdColor))
                    end
                end)
                :onClick(function(self, dropdown, mouseButton)
                    frame.groups:foreach(function(item)
                        item.selectedButton:SetBackdropBorderColor(unpack(transparent))
                        item:Close()
                    end)

                    local first = frame.groups:first()

                    if (first.groups) then
                        first.groups:foreach(function(group)
                            group:Close()
                            group:Hide()
                        end)

                        first.groups = A:OrderedTable()
                    end

                    if (first.children) then
                        first.children:foreach(function(child)
                            child:Hide()
                            child.anchor:Hide()
                        end)

                        first.children = A:OrderedTable()
                    end

                    self.dropdown:Open()
                    self.dropdown.selectedButton:SetBackdropBorderColor(1, 1, 1, 1)
                end)
                :onItemClick(function(self, button, dropdown, mouseButton)

                    button.item.db = db[button.name]
                    
                    local first = frame.groups:first()

                    if (first.groups) then
                        first.groups:foreach(function(group)
                            group:Close()
                            group:Hide()
                        end)

                        first.groups = A:OrderedTable()
                    end

                    if (mouseButton == "LeftButton") then
                        O:CreateGroup(button, first, first)
                    elseif (mouseButton == "RightButton") then
                        print("Disable group: ", button.name)
                    end
                end)
                :build()
        widget.name = name
        frame.groups:addUniqueByKey(widget, "name", name)
        relative = widget
    end
end

local function getChildrenInOrder(children)
    local tbl = {}
    for k,v in next, children do
        if (v.order) then
            tbl[v.order] = { k, v }
        end
    end

    if (#tbl > 0) then
        local c = 0
        return function()
            c = c + 1
            if(tbl[c]) then
                return unpack(tbl[c])
            end
        end
    else
        return function() end
    end
end

local X = {}

function X:CreateGroup(name, parent, setting, db)

    local group = buildGroup(parent)
            :onClick(function(self, button, down)
                if (not down) then
                    if (setting.canToggle and button == "RightButton") then
                        if (setting.special) then
                            if (not setting.special(self)) then 
                                return
                            end
                        end

                        self.db["Enabled"] = not self:enabled()
                        if (not self:enabled()) then
                            self.title:SetTextColor(1, .2, .2, 1)
                        else
                            self.title:SetTextColor(1, 1, 1, 1)
                        end

                        X:UpdateWidgetStates()
                        A.dbProvider:Save()
                        A:UpdateDb()
                    end

                    if (setting.onClick and button == "LeftButton") then
                        setting.onClick(self)
                    end
                end
            end)
            :build()

    group.name = name
    group.db = db
    group.enabled = setting.enabled
    group.special = setting.special
    group.set = setting.set
    group.get = setting.get

    group.placement = function(self)
        setting.placement(self)
        self.children:foreach(function(child)
            child:placement()
        end)
    end

    if (not group.enabled) then
        group.enabled = function(self) return true end
    end

    local child
    for childName, childSetting in getChildrenInOrder(setting.children) do
        child = X:CreateChild(childName, group, childSetting, db[childName])
        group:addChild(child)
    end

    group.last = child

    group:SetActive(group:enabled())

    return group
end

function X:CreateChild(name, parent, setting, db)

    local type = setting.type

    local child, childBuilder
    if (type == "group") then
        child = X:CreateGroup(name, parent, setting, db)
        -- What needs to be done here?
    else
        if (type == "dropdown") then
            childBuilder = buildDropdown(parent)
                    :addItems(setting.values)
                    :size(setting.width, setting.height)
                    :fontSize(11)
                    :selectedButtonTextHorizontalAlign("RIGHT")
                    :rightOfButton()
        elseif (type == "text") then
            childBuilder = buildText(parent, setting.textSize or 11)
                    :size(setting.width, setting.height)
        elseif (type == "number") then
            childBuilder = buildNumber(parent, setting.textSize or 11)
                    :min(setting.min)
                    :max(setting.max)
                    :stepValue(setting.step)
                    :allowDecimals(setting.decimals)
                    :size(setting.width, setting.height)
        elseif (type == "toggle") then
            childBuilder = buildToggle(parent)
                    :size(setting.width, setting.height)
                    :texts("ON", "OFF")
        elseif (type == "color") then
            childBuilder = buildColor(parent)
                    :size(setting.width, setting.height)
        end
    end

    if (not child) then
        child = childBuilder
            :onValueChanged(function(self, widget, value)
                widget:set(value)
                X:UpdateWidgetStates()
                A.dbProvider:Save()
                A:UpdateDb()
            end)
            :build()

        child.name = name
        child.db = db
        child.enabled = setting.enabled
        child.special = setting.special
        child.placement = setting.placement
        child.set = setting.set
        child.get = setting.get
    end

    if (not child.enabled) then
        child.enabled = function(self) 
            return self.parent:enabled()
        end
    end

    child.title = buildText(child, setting.titleSize or 11)
            :atLeft()
            :outline()
            :build()

    child.title:SetText(name)

    if (not child:enabled()) then
        child.title:SetTextColor(1, .2, .2, 1)
    else
        child.title:SetTextColor(1, 1, 1, 1)
    end

    child:SetActive(child:enabled())
    child:SetValue(db)

    child:SetSize(setting.width or child.title:GetWidth(), setting.height or 20)

    return child
end

function A:CreatePrefs(db)

    function X:HandleChildren(children, visible, once)
        if (not children) then return end
        children:foreach(function(child)
            if (not once) then
                X:HandleChildren(child.children, visible)
            end
            if (not visible) then 
                child:Hide()
            else
                child:Show()
            end
        end)
    end

    local hideOrShow = function(widget, visible)
        if (visible) then
            widget:Show()
        else
            widget:Hide()
        end
    end

    local handleChildrenTwoLevels = function(self, visible)
        self.children:foreach(function(child)
            if (child.children) then
                child.children:foreach(function(c)
                    hideOrShow(c, visible)
                end)
            end
            hideOrShow(child, visible)
        end)
    end

    local hideParentChildrenAndShowSelf = function(self)
        self.parent.children:foreach(function(child)
            X:HandleChildren(child.children, false)
        end)
        X:HandleChildren(self.children, true, true)
        
        if (A.clickcastWindow) then
            A.clickCastWindow:Hide()
        end
    end

    local genericOnClick = function(self)
        hideParentChildrenAndShowSelf(self, false)
        handleChildrenTwoLevels(self, true)
    end

    local genericEnabled = function(self) return self.parent:enabled() and self.db["Enabled"] end
    local genericGetValue = function(self) return self.db end
    local genericSetValue = function(self, value) self.parent.db[self.name] = value end

    local prefs = {
        ["General"] = {
            type = "group",
            order = 1,
            onClick = hideParentChildrenAndShowSelf,
            placement = function(self)
                self:SetPoint("TOPLEFT", self.parent, "TOPLEFT", 10, 0)
            end,
            children = {

            }
        },
        ["Units"] = {
            type = "group",
            order = 2,
            onClick = hideParentChildrenAndShowSelf,
            placement = function(self)
                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, 0)
            end,
            children = {
                ["Player"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 1,
                    placement = function(self)
                        self:SetPoint("LEFT", self.parent, "RIGHT", 50, 0)
                    end,
                    children = {
                        ["Health"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 1,
                            placement = function(self)
                                self:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                            end,
                            children = {
                                ["Color By"] = {
                                    type = "dropdown",
                                    order = 1,
                                    placement = function(self)
                                        self:SetPoint("LEFT", self.parent, "RIGHT", 120, 0)
                                    end,
                                    values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Custom Color"] = {
                                    enabled = function(self)
                                        return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                    end,
                                    type = "color",
                                    order = 2,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 20,
                                    height = 20
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    order = 3,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "RIGHT", 5, 0)
                                    end,
                                    min = -1,
                                    max = 1,
                                    width = 50,
                                    heigth = 20,
                                    step = 0.1,
                                    decimals = true,
                                    get = genericGetValue,
                                    set = genericSetValue
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    order = 4,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    order = 5,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 50,
                                    height = 20
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 6,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = media:List("statusbar"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Position"] = {
                                    type = "group",
                                    order = 7,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Point"] = {
                                            type = "dropdown",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = A.Tools.points,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        },
                                        ["Local Point"] = {
                                            type = "dropdown",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = A.Tools.points,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        },
                                        ["Relative To"] = {
                                            type = "dropdown",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = createDropdownTable("Player", "Power"),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        },
                                    }
                                },
                                ["Size"] = {
                                    type = "group",
                                    order = 8,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Match width"] = {
                                            type = "toggle",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20                               
                                        },
                                        ["Width"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match width"]
                                            end,
                                            type = "number",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                                            end,
                                            width = 50,
                                            height = 20,
                                            step = 10,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenWidth(),
                                            get = genericGetValue,
                                            set = genericSetValue
                                        },
                                        ["Height"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match height"]
                                            end,
                                            type = "number",
                                            order = 4,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            width = 50,
                                            height = 20,
                                            step = 10,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenHeight(),
                                            get = genericGetValue,
                                            set = genericSetValue   
                                        }
                                    }
                                },
                                ["Missing Health Bar"] = {
                                    enabled = genericEnabled,
                                    canToggle = true,
                                    type = "group",
                                    order = 9,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Custom Color"] = {
                                            enabled = function(self)
                                                return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                            end,
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                                            end,
                                            type = "color",
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        }
                                    }
                                }
                            }
                        },
                        ["Power"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 2,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {
                                ["Color By"] = {
                                    type = "dropdown",
                                    order = 1,
                                    placement = function(self)
                                        self:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                                    end,
                                    values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Custom Color"] = {
                                    enabled = function(self)
                                        return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                    end,
                                    type = "color",
                                    order = 2,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 20,
                                    height = 20
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    order = 3,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "RIGHT", 5, 0)
                                    end,
                                    min = -1,
                                    max = 1,
                                    step = 0.1,
                                    width = 50,
                                    height = 20,
                                    decimals = true,
                                    get = genericGetValue,
                                    set = genericSetValue
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    order = 4,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    order = 5,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 50,
                                    height = 20
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 6,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = media:List("statusbar"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Position"] = {
                                    type = "group",
                                    order = 7,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Point"] = {
                                            type = "dropdown",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = A.Tools.points,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        },
                                        ["Local Point"] = {
                                            type = "dropdown",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = A.Tools.points,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        },
                                        ["Relative To"] = {
                                            type = "dropdown",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = createDropdownTable("Player", "Health"),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        },
                                    }
                                },
                                ["Size"] = {
                                    type = "group",
                                    order = 8,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Match width"] = {
                                            type = "toggle",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20                               
                                        },
                                        ["Width"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match width"]
                                            end,
                                            type = "number",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                                            end,
                                            step = 10,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenWidth(),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Height"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match height"]
                                            end,
                                            type = "number",
                                            order = 4,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            step = 10,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenHeight(),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        }
                                    }
                                },
                                ["Missing Power Bar"] = {
                                    enabled = genericEnabled,
                                    canToggle = true,
                                    type = "group",
                                    order = 9,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Custom Color"] = {
                                            enabled = function(self)
                                                return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                            end,
                                            type = "color",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 150,
                                            height = 20
                                        }
                                    }
                                }
                            }
                        },
                        ["Castbar"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 3,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Alternative Power"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 4,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Runes"] = {
                            enabled = function(self)
                                return self.parent:enabled() and self:special()
                            end,
                            special = function(self)
                                return select(2, UnitClass("player")) == "DEATHKNIGHT"
                            end,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 5,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Combat Indicator"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 6,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Stagger"] = {
                            enabled = function(self)
                                return self.parent:enabled() and self:special()
                            end,
                            special = function(self)
                                return select(2, UnitClass("player")) == "MONK" and GetSpecialization() == 1
                            end,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 7,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Buffs"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 8,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Debuffs"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 9,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Background"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 10,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {
                                ["Color"] = {
                                    type = "color",
                                    order = 1,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                                        self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 20,
                                    height = 20
                                },
                                ["Offset"] = {
                                    canToggle = false,
                                    onClick = genericOnClick,
                                    type = "group",
                                    order = 2,
                                    placement = function(self)
                                        self:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -5)
                                    end,
                                    children = {
                                        ["Top"] = {
                                            type = "number",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 50, 0)
                                            end,
                                            step = 1,
                                            decimals = false,
                                            min = -100,
                                            max = 100,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Bottom"] = {
                                            type = "number",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 50, 0)
                                            end,
                                            step = 1,
                                            decimals = false,
                                            min = -100,
                                            max = 100,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Left"] = {
                                            type = "number",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 50, 0)
                                            end,
                                            step = 1,
                                            decimals = false,
                                            min = -100,
                                            max = 100,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Right"] = {
                                            type = "number",
                                            order = 4,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 50, 0)
                                            end,
                                            step = 1,
                                            decimals = false,
                                            min = -100,
                                            max = 100,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                ["Target"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 2,
                    placement = function(self)
                        self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                    end,
                    children = {}
                },
                ["Target of Target"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 3,
                    placement = function(self)
                        self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                    end,
                    children = {}
                },
                ["Pet"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 4,
                    placement = function(self)
                        self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                    end,
                    children = {}
                }
            }
        },
        ["Group"] = {
            type = "group",
            order = 3,
            onClick = hideParentChildrenAndShowSelf,
            placement = function(self)
                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, 0)
            end,
            children = {
                ["Party"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 1,
                    placement = function(self)
                        self:SetPoint("LEFT", self.parent, "RIGHT", 50, 0)
                    end,
                    children = {
                        ["Clickcast"] = A.modules.clickcast:GetOptions(genericEnabled, 1),
                    }
                },
                ["Raid"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    type = "group",
                    order = 2,
                    placement = function(self)

                    end,
                    children = {}
                }
            }
        }
    }

    local parent = CreateFrame("Frame", nil, A.frameParent)
    parent:SetSize(1, 1)
    parent:SetPoint("TOPLEFT", 0, -300)
    parent.children = A:OrderedTable()

    X.UpdateWidgetStates = function(self, widgets)
        local iterator = widgets or parent.children
        iterator:foreach(function(widget)
            if (widget.children) then
                X:UpdateWidgetStates(widget.children)
            end

            local enabled = widget:enabled()

            widget:SetActive(enabled)

            if (not enabled) then
                widget.title:SetTextColor(1, .2, .2, 1)
            else
                widget.title:SetTextColor(1, 1, 1, 1)
            end
        end)
    end

    -- Iterate prefs
    for name, setting in getChildrenInOrder(prefs) do
        
        local type = setting.type
        local widget

        if (type == "group") then
            widget = X:CreateGroup(name, parent, setting, db)

            widget.title = buildText(widget, 11)
                    :atLeft()
                    :outline()
                    :build()

            widget.title:SetText(name)

            widget:SetWidth(widget.title:GetWidth())

            X:HandleChildren(widget.children, false)
        else
            widget = X:CreateChild(name, parent, setting, db)
        end

        parent.children:add(widget)
    end

    parent.children:foreach(function(widget)
        widget:placement()
    end)
end
