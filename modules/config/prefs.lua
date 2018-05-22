local A, L = unpack(select(2, ...))
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local CreateFrame = CreateFrame

local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local buildDropdown = A.DropdownBuilder
local buildGroup = A.GroupBuilder

local media = LibStub("LibSharedMedia-3.0")

local function createDropdownTable(...)
    local tbl = {}
    for _,v in next, {...} do
        tbl[v] = v
    end
    return table
end

local function createToggle(key, item, parent)
    if (parent.enabledToggle) then
        parent.enabledToggle:Hide()
    end

    local enabled = item.enabled
    if (enabled) then
        local toggle = A.ToggleBuilder(parent):atRight():x(-37):texts("ON", "OFF"):onClick(function(self)
            enabled:set(item.db, self.checked)
        end):build()

        toggle:SetValue(enabled:get(item.db["Enabled"]))

        parent.enabledToggle = toggle
    end
end

local function createGroup(name, group, parent, relative)
    print("createGroup", group, name, parent, relative)

    local builder = buildGroup(parent)
    if (relative == parent) then
        builder:alignWith(relative):atTop()
    else
        builder:below(relative)
    end

    local widget = builder:build()

    local groupTitle = buildText(widget, 14):atTopLeft():x(10):y(-10):outline():build()
    groupTitle:SetText(group.name)

    widget.title = groupTitle

    local childRelative = widget
    for name, child in next, group.children do

        local childTitle = buildText(childRelative, 12):atTopLeft():x(10):y(-30):outline():build()
        childTitle:SetText(name)

        child.title = childTitle

        local childWidget
        if (child.type == "group") then
            childWidget = createGroup(name, child, widget, childRelative)
        elseif (child.type == "text") then

        elseif (child.type == "number") then
            childWidget = buildNumber(childRelative):size(childRelative:GetWidth(), 20):min(child.min):max(child.max):build()
            widget:addChild(childWidget)
        elseif (child.type == "dropdown") then

        elseif (child.type == "toggle") then

        elseif (child.type == "color") then

        end

        -- check enabled here

        childRelative = childWidget
    end

    return widget
end

local widgets = {}
local function changeStateForWidgets()
    for _,widget in next, widgets do
        if (widget and widget.enabled) then
            local enabled = widget.enabled
            if (type(enabled) == "table") then

            else

            end
        end
    end
end

local function createScrollFrame(parent)
    local scrollContent = CreateFrame("ScrollFrame", nil, parent)
    scrollContent:SetAllPoints()
    scrollContent:SetSize(497, 465)

    parent:SetScrollChild(scrollContent)

    return scrollContent
end

function A:ConstructPreferences(db)
	
	-- Construct the table used
	local prefs = {
		["General"] = {
			type = "group",
			children = {

			}
		},
		["Units"] = {
			type = "group",
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
							children = {
								["Position"] = {
									type = "group",
									children = {
										["Point"] = {
											type = "dropdown",
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
									children = {
										["Match width"] = {
											type = "toggle",
											set = function(self, db, value)
												db["Match width"] = value
											end,
											get = function(self, db)
												return db
											end
										},
			    						["Match height"] = {
			    							type = "toggle",
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
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Custom Color"] = value
                                    end
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    min = -1,
                                    max = 1,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Background Multiplier"] = value
                                    end 
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Orientation"] = value
                                    end 
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Reversed"] = value
                                    end 
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    values = media:List("statusbar"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Texture"] = value
                                    end
                                },
                                ["Missing Health Bar"] = {
                                    enabled = {
                                        type = "toggle",
                                        set = function(self, db, value)
                                            db["Enabled"] = value
                                        end,
                                        get = function(self, db) return db end
                                    },
                                    type = "group",
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
                            children = {
                                ["Position"] = {
                                    type = "group",
                                    children = {
                                        ["Point"] = {
                                            type = "dropdown",
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
                                            set = function(self, db, value)
                                                db["Match width"] = value
                                            end,
                                            get = function(self, db)
                                                return db
                                            end
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
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
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Custom Color"] = value
                                    end
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    min = -1,
                                    max = 1,
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Background Multiplier"] = value
                                    end 
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Orientation"] = value
                                    end 
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    get = function(self, db) return db end,
                                    set = function(self, db, value)
                                        db["Reversed"] = value
                                    end 
                                },
                                ["Texture"] = {
                                    type = "dropdown",
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

				},
				["Target of Target"] = {

				},
				["Pet"] = {

				}
			}
		},
		["Group"] = {
			type = "group",
			children = {
				["Party"] = {
					type = "group",
					children = {}
				},
				["Raid"] = {
					type = "group",
					children = {}
				}
			}
		}
	}

    --setmetatable(prefs, mt)
    --fix(prefs)

    -- Use table to construct the visual widgets and bind everything together
    -- Make sure every widgets various SetValue functions is calling UnitEvent.UPDATE_DB for everything
    -- Also redraw the preferences to make sure that all dependencies go through between them, eg. enabled because something else is enabled

    local frame = CreateFrame("Frame", "Preferences", A.frameParent)
    frame:SetSize(753, 500)
    frame:SetPoint("CENTER")
    frame:SetBackdrop(A.enum.backdrops.editbox)
    frame:SetBackdropColor(0, 0, 0, 0.75)

    local detailFrame = CreateFrame("ScrollFrame", nil, frame)
    detailFrame:SetSize(497, 465)
    detailFrame:SetPoint("BOTTOMRIGHT", -3, 3)
    detailFrame:SetBackdrop(A.enum.backdrops.editbox)
    detailFrame:SetBackdropColor(28/255, 28/255, 28/255, 0.5)

    detailFrame.scrollContent = createScrollFrame(detailFrame)

    frame.detailFrame = detailFrame

    local count = 1
    local buttons = {}
    for name, child in next, prefs do
        -- Construct list of names with onClick for replacement of first dropdown
        local builder
        if (count == 1) then
            builder = buildButton(frame):atTopLeft():x(3):y(-3)
        else
            builder = buildButton(buttons[count - 1]):below(buttons[count -1]):y(-3)
        end

        local color = { 123/255, 132/255, 132/255, .25 }
        if (count % 2 == 0) then
            color = { 0, 0, 0, 0 }
        end

        local button = builder
        :backdrop(A.enum.backdrops.editbox, color, { 0, 0, 0, 0 })
        :size(247, 25)
        :onClick(function(self)
            -- Create first dropdown with children
            if (frame.firstDropdown) then
                frame.firstDropdown:Hide()
            end

            if (frame.secondDropdown) then
                frame.secondDropdown:Hide()
            end

            local ddbuilder1 = buildDropdown(frame):size(247, 25):rightOf(buttons[1]):x(3)
            :onClick(function(self)
                -- Nothing
            end)
            :onItemClick(function(button, dropdown)
                -- Construct new second dropdown
                print("Constructing new dropdown for: ", button.name, button.item)
                frame.secondDropdown:Hide()
                
                local ddbuilder2 = buildDropdown(frame):size(247, 25):rightOf(dropdown):x(3)
                :backdrop(A.enum.backdrops.editbox, { 123/255, 132/255, 132/255, .25 }, { 0, 0, 0, 0 })
                :onClick(function(self)
                    -- Nothing
                end)
                :onItemClick(function(button, dropdown)
                    createToggle(button.name, button.item, dropdown)

                    detailFrame.scrollContent:Hide()
                    detailFrame.scrollContent = createScrollFrame(detailFrame)

                    local relative = detailFrame.scrollContent
                    local widget = createGroup(button.name, button.item, relative, relative)
                end)

                createToggle(button.name, button.item, dropdown)

                if (button.item.children) then
                    for k,v in next, button.item.children do
                        v.name = k
                        v.db = button.item.db[k]
                        ddbuilder2:addItem(v)
                    end
                end
                local dropdown2 = ddbuilder2:build()
                frame.secondDropdown = dropdown2

                if (not button.item.children) then
                    dropdown2:Hide()
                end
            end)
            :backdrop(A.enum.backdrops.editbox, { 123/255, 132/255, 132/255, .25 }, { 0, 0, 0, 0 })

            for k,v in next, child.children do
                v.name = k
                v.db = db[k]
                ddbuilder1:addItem(v)
            end

            local dropdown1 = ddbuilder1:build()
            createToggle(name, child, dropdown1)

            frame.firstDropdown = dropdown1

            local ddbuilder2 = buildDropdown(frame):size(247, 25):rightOf(dropdown1):x(3)
            :backdrop(A.enum.backdrops.editbox, { 123/255, 132/255, 132/255, .25 }, { 0, 0, 0, 0 })

            local firstChild = A.Tools.Table:first(child.children)
            if (firstChild and firstChild.children) then
                local childCount = 0
                for k,v in next, firstChild.children do
                    v.name = k
                    v.db = firstChild.db[k]
                    if (childCount == 0) then
                        createToggle(k, v, dropdown2)
                    end
                    ddbuilder2:addItem(v)
                    childCount = childCount + 1
                end
            end
            
            local dropdown2 = ddbuilder2:build() --more stuff needed here

            if (not firstChild or not firstChild.children) then
                dropdown2:Hide()
            end

            frame.secondDropdown = dropdown2
        end)
        :build()

        button:SetFrameLevel(3)

        local text = buildText(button, 14):atLeft():x(6):outline():build()
        text:SetText(name)

        --constructGroup(frame, frame, name, child)
        buttons[count] = button
        count = count + 1
    end

    widgets = buttons
end
