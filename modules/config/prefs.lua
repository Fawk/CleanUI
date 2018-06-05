local A, L = unpack(select(2, ...))
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local CreateFrame = CreateFrame

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

local media = LibStub("LibSharedMedia-3.0")

local bdColor = { 39/255, 37/255, 37/255, 1 }
local transparent = { 0, 0, 0, 0 }

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
            local enabled = widget.enabled
            if (type(enabled) == "table") then
                widget:SetActive(widget.enabled:get(widget.db["Enabled"]))
            else
                local gp = widget.groupParent
                if (gp) then
                    if (not gp.enabledToggle or (gp.enabledToggle and gp.enabledToggle:GetValue())) then
                        widget:SetActive(widget:enabled(widget:GetParent(), widget.item, gp.db))
                    end
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
                :size(171, 32)
                :overrideText(childName)
                :rightOfButton()
                :stayOpenAfterChoosing()
                :overrideRelative(parent.groups:first())
                :addItems(child.children)
                :fontSize(12)
                :onHover(function(self, d, b)
                    if (self.hover) then
                        local r, g, b, a = self:GetBackdropColor()
                        self:SetBackdropColor(r * 0.33, g * 0.33, b * 0.33, 1)
                    else
                        self:SetBackdropColor(unpack(bdColor))
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

                    if (mouseButton == "RightButton") then
                        print("Disable group: ", childName)
                    elseif (mouseButton == "LeftButton") then
                        self.dropdown:Open()
                        self.dropdown.selectedButton:SetBackdropBorderColor(1, 1, 1, 1)
                    end
                end)
                :onItemClick(function(self, button, mouseButton)

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
                        O:CreateGroup(button, first, first)
                    else
                        if (not first.children) then
                            first.children = A:OrderedTable()
                        else
                            first.children:foreach(function(child)
                                child:Hide()
                            end)

                            first.children = A:OrderedTable()
                        end

                        local value = child.db[button.name]

                        if (type == "toggle") then
                            item:set(child.db, not value)
                            A.dbProvider:Save()
                            changeStateForWidgets()
                            A:UpdateDb()
                        end
                    end

                end)
                :onChildCreation(function(builder, button)

                    local widgetBuilder

                    if (button.widget) then
                        button.widget:Hide()
                    end

                    -- SetValue using db
                    button:SetValue(button.item:get(child.db[button.name]))

                    if (type == "color") then
                        widgetBuilder = buildColor(button)
                                :size(30, 30)
                                :atRight()
                                :x(-1)
                    elseif (type == "text") then
                        
                    elseif (type == "number") then
                        
                    elseif (type == "dropdown") then
                        
                    end

                    button.widget = widgetBuilder
                            :activeCondition(getEnabledFuncOrTrue(child, button.item, child.db))
                            :onValueChanged(function(self, widget, value)
                                button.item:set(child.db, value)
                                A.dbProvider:Save()
                                changeStateForWidgets()
                                A:UpdateDb()
                            end)
                            :build()
                end)
    elseif (child.type == "text") then
        childWidgetBuilder = buildEditBox(childRelative)
                :size(child.width or 30, child.height or 32)
    elseif (child.type == "number") then
        childWidgetBuilder = buildNumber(childRelative)
                :size(child.width or 30, child.height or 32)
                :min(child.min)
                :max(child.max)
    elseif (child.type == "dropdown") then
        childWidgetBuilder = buildDropdown(childRelative)
                :addItems(child.values)
                :size(parent:GetWidth(), 32)
                :backdrop(A.enum.backdrops.editbox, bdColor, transparent)
                :fontSize(12)
    elseif (child.type == "toggle") then
        childWidgetBuilder = buildToggle(childRelative)
                :texts("ON", "OFF")
    elseif (child.type == "color") then
        childWidgetBuilder = buildColor(childRelative)
                :size(30, 30)
                :atRight()
                :x(-1)
    end

    if (childRelative == parent) then
        childWidgetBuilder
                :atTopLeft()
                :againstTopRight()
                :alignWith(childRelative)
                :x(parent:GetWidth())
    else
        -- This needs to be changed, introduce an anchor or something instead
        childWidgetBuilder
                :below(childRelative)
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

    childWidget.title = buildText(childWidget, 12)
            :outline()
            :atLeft()
            :build()

    childWidget.title:SetText(childName)

    if (child.type ~= "group") then
        childWidget:SetValue(child:get(group.db[childName]))
    else
        parent.groups:addUniqueByKey(childWidget, "name", childName)
    end

    childWidget.type = child.type
    childWidget.enabled = child.enabled
    childWidget.name = childName
    childWidget.db = child.db

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
            else
                if (child.enabled) then
                    if (child.type ~= "group") then
                        childWidget:SetActive(child:enabled(widget, child, group.db))
                    else
                        childWidget:SetActive(child.enabled:get(child.db["Enabled"]))
                    end
                else
                    if (group.enabled) then
                        childWidget:SetActive(group.enabled:get(group.db["Enabled"]))
                    else
                        childWidget:SetActive(true)
                    end
                end

                childRelative = childWidget
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
                                            width = 60,
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
                                            width = 60,
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
                                ["Position"] = {
                                    type = "group",
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
                                ["Color By"] = {
                                    type = "dropdown",
                                    order = 3,
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
                                    order = 4,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Custom Color"] = value
                                    end
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    order = 5,
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
                                    order = 6,
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Orientation"] = value
                                    end 
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    order = 7,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Reversed"] = value
                                    end 
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 8,
                                    values = media:List("statusbar"),
                                    get = function(self, db) return db  end,
                                    set = function(self, db, value)
                                        db["Texture"] = value
                                    end
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
					children = {}
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
    frame:SetPoint("TOPLEFT", 0, -200)
    frame.groups = A:OrderedTable()

    local relative = frame
    for name, group in next, prefs do
        local widget = buildDropdown(relative)
                :atTopLeft()
                :againstBottomLeft()
                :size(171, 32)
                :overrideText(name)
                :rightOfButton()
                :stayOpenAfterChoosing()
                :overrideRelative(frame.groups:first())
                :fontSize(12)
                :addItems(group.children)
                :backdrop(A.enum.backdrops.editboxborder, bdColor, transparent)
                :onHover(function(self, d, b)
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
