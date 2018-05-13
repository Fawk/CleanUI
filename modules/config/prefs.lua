local A, L = unpack(select(2, ...))
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local CreateFrame = CreateFrame

local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local buildDropdown = A.DropdownBuilder

local media = LibStub("LibSharedMedia-3.0")

local mt = { 
    __index = function(tbl, k, v) 
        return tbl.children[k]
    end 
}

local function fix(t)
   for _,v in next, t do
      if type(v) == "table" and v.children then
          fix(v.children)
          setmetatable(v, mt)
      end
   end    
end

local function createDropdownTable(...)
    local tbl = {}
    for _,v in next, {...} do
        tbl[v] = v
    end
    return table
end

local function constructGroup(parent, relative, name, tbl)
    local title = buildText(parent, 14):atTopLeft():outline():build()
    title:SetTextColor(1, 1, 1)
    title:SetText(name)

    if (tbl.type == "group") then
        local childCount = A.Tools:tcount(tbl.children)

        local group = CreateFrame("Frame", name, parent)
        group:SetSize(500, childCount * 20)
        group:SetPoint("TOPLEFT", relative, "TOPLEFT", 0,  childCount * -20)
        
        for n, g in next, tbl.children do
            if g.type == "group" then
                constructGroup(group, group, n, g)
            else
                local title2 = buildText(group, 12):atTopLeft():outline():build()
                title2:SetTextColor(1, 1, 1)
                title2:SetText(name)
            end
        end
    end
end

function A:ConstructPreferences(db)

	    				-- 	["Position"] = {
    					-- 	["Point"] = "TOP",
    					-- 	["Local Point"] = "TOP",
    					-- 	["Offset X"] = 0,
    					-- 	["Offset Y"] = 0,
    					-- 	["Relative To"] = "Player"
    					-- },
    					-- ["Size"] = {
    					-- 	["Match width"] = true,
    					-- 	["Match height"] = false,
    					-- 	["Width"] = 150,
    					-- 	["Height"] = 35
    					-- },
         --                ["Color By"] = "Gradient",
         --                ["Custom Color"] = { 1, 1, 1 },
         --                ["Background Multiplier"] = 0.33,
         --                ["Orientation"] = "HORIZONTAL",
         --                ["Reversed"] = false,
         --                ["Texture"] = "Default2",
         --                ["Missing Health Bar"] = {
         --                    ["Enabled"] = false,
         --                    ["Custom Color"] = {
         --                        0.5, -- [1]
         --                        0.5, -- [2]
         --                        0.5, -- [3]
         --                        1, -- [4]
         --                    },
         --                    ["Color By"] = "Custom",
         --                }
	
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
                    ["Enabled"] = {
                        type = "toggle",
                        set = function(self, value)
                            db["Player"]["Enabled"] = value
                        end,
                        get = function() return db["Player"]["Enabled"] end
                    },
                    type = "group",
                    children = {
                        ["Health"] = {
                            ["Enabled"] = {
                                type = "toggle",
                                set = function(self, value)
                                    db["Player"]["Health"]["Enabled"] = value
                                end,
                                get = function() return db["Player"]["Health"]["Enabled"] end
                            },
							type = "group",
							children = {
								["Position"] = {
									type = "group",
									children = {
										["Point"] = {
											type = "dropdown",
											values = A.Tools.points,
											set = function(self, value)
												db["Player"]["Health"]["Position"]["Point"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Position"]["Point"]
											end
										},
										["Local Point"] = {
											type = "dropdown",
											values = A.Tools.points,
											set = function(self, value)
												db["Player"]["Health"]["Position"]["Local Point"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Position"]["Local Point"]
											end
										},
										["Relative To"] = {
											type = "dropdown",
											values = createDropdownTable("Player", "Power"),
											set = function(self, value)
												db["Player"]["Health"]["Position"]["Relative To"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Position"]["Relative To"]
											end
										},
									}
								},
								["Size"] = {
									type = "group",
									children = {
										["Match width"] = {
											type = "toggle",
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Match width"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Match width"]
											end
										},
			    						["Match height"] = {
			    							type = "toggle",
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Match height"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Match height"]
											end											
										},
			    						["Width"] = {
			    							enabled = function(self) return not prefs["Player"]["Health"]["Size"]["Match width"]:get() end,
			    							type = "number",
                                            min = 1,
                                            max = GetScreenWidth(),
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Width"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Width"]
											end		
			    						},
			    						["Height"] = {
			    							enabled = function(self) return not prefs["Player"]["Health"]["Size"]["Match height"]:get() end,
			    							type = "number",
                                            min = 1,
                                            max = GetScreenHeight(),
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Height"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Height"]
											end		
			    						}
			    					}
								},
                                ["Color By"] = {
                                    type = "dropdown",
                                    values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                    get = function() return db["Player"]["Health"]["Color By"] end,
                                    set = function(self, value)
                                        db["Player"]["Health"]["Color By"] = value
                                    end
                                },
                                ["Custom Color"] = {
                                    ["Enabled"] = function(self)
                                        return self["*"]["*"]["Color By"]:get() == "Custom"
                                    end,
                                    type = "color",
                                    get = function() return db["Player"]["Health"]["Custom Color"] end,
                                    set = function(self, value)
                                        db["Player"]["Health"]["Custom Color"] = value
                                    end
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    min = -1,
                                    max = 1,
                                    get = function() return db["Player"]["Health"]["Background Multiplier"] end,
                                    set = function(self, value)
                                        db["Player"]["Health"]["Background Multiplier"] = value
                                    end 
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = function() return db["Player"]["Health"]["Orientation"] end,
                                    set = function(self, value)
                                        db["Player"]["Health"]["Orientation"] = value
                                    end 
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    get = function() return db["Player"]["Health"]["Reversed"] end,
                                    set = function(self, value)
                                        db["Player"]["Health"]["Reversed"] = value
                                    end 
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    values = media:List("statusbar"),
                                    get = function() return db["Player"]["Health"]["Texture"]  end,
                                    set = function(self, value)
                                        db["Player"]["Health"]["Texture"] = value
                                    end
                                },
                                ["Missing Health Bar"] = {
                                    ["Enabled"] = {
                                        type = "toggle",
                                        set = function(self, value)
                                            db["Player"]["Health"]["Missing Health Bar"]["Enabled"] = value
                                        end,
                                        get = function() return db["Player"]["Health"]["Missing Health Bar"]["Enabled"] end
                                    },
                                    type = "group",
                                    children = {
                                        ["Custom Color"] = {
                                            ["Enabled"] = function(self) return prefs["Player"]["Health"]["Missing Health Bar"]["Color By"]:get() == "Custom" end,
                                            type = "color",
                                            get = function() return db["Player"]["Health"]["Missing Health Bar"]["Custom Color"] end,
                                            set = function(self, value)
                                                db["Player"]["Health"]["Missing Health Bar"]["Custom Color"] = value
                                            end
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                            get = function() return db["Player"]["Health"]["Missing Health Bar"]["Color By"] end,
                                            set = function(self, value)
                                                db["Player"]["Health"]["Missing Health Bar"]["Color By"] = value
                                            end
                                        }
                                    }
                                }
							}
						},
						["Power"] = {
                            ["Enabled"] = {
                                type = "toggle",
                                set = function(self, value)
                                    db["Player"]["Power"]["Enabled"] = value
                                end,
                                get = function() return db["Player"]["Power"]["Enabled"] end
                            },
                            type = "group",
                            children = {
                                ["Position"] = {
                                    type = "group",
                                    children = {
                                        ["Point"] = {
                                            type = "dropdown",
                                            values = A.Tools.points,
                                            set = function(self, value)
                                                db["Player"]["Power"]["Position"]["Point"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Position"]["Point"]
                                            end
                                        },
                                        ["Local Point"] = {
                                            type = "dropdown",
                                            values = A.Tools.points,
                                            set = function(self, value)
                                                db["Player"]["Power"]["Position"]["Local Point"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Position"]["Local Point"]
                                            end
                                        },
                                        ["Relative To"] = {
                                            type = "dropdown",
                                            values = createDropdownTable("Player", "Health"),
                                            set = function(self, value)
                                                db["Player"]["Power"]["Position"]["Relative To"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Position"]["Relative To"]
                                            end
                                        },
                                    }
                                },
                                ["Size"] = {
                                    type = "group",
                                    children = {
                                        ["Match width"] = {
                                            type = "toggle",
                                            set = function(self, value)
                                                db["Player"]["Power"]["Size"]["Match width"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Size"]["Match width"]
                                            end
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
                                            set = function(self, value)
                                                db["Player"]["Power"]["Size"]["Match height"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Size"]["Match height"]
                                            end                                         
                                        },
                                        ["Width"] = {
                                            ["Enabled"] = function(self) return not prefs["Player"]["Power"]["Size"]["Match width"]:get() end,
                                            type = "number",
                                            min = 1,
                                            max = GetScreenWidth(),
                                            set = function(self, value)
                                                db["Player"]["Power"]["Size"]["Width"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Size"]["Width"]
                                            end     
                                        },
                                        ["Height"] = {
                                            ["Enabled"] = function(self) return not prefs["Player"]["Power"]["Size"]["Match height"]:get() end,
                                            type = "number",
                                            min = 1,
                                            max = GetScreenHeight(),
                                            set = function(self, value)
                                                db["Player"]["Power"]["Size"]["Height"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Size"]["Height"]
                                            end     
                                        }
                                    }
                                },
                                ["Color By"] = {
                                    type = "dropdown",
                                    values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                    get = function() return db["Player"]["Power"]["Color By"] end,
                                    set = function(self, value)
                                        db["Player"]["Power"]["Color By"] = value
                                    end
                                },
                                ["Custom Color"] = {
                                    ["Enabled"] = function(self)
                                        return self["*"]["*"]["Color By"]:get() == "Custom"
                                    end,
                                    type = "color",
                                    get = function() return db["Player"]["Power"]["Custom Color"] end,
                                    set = function(self, value)
                                        db["Player"]["Power"]["Custom Color"] = value
                                    end
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    min = -1,
                                    max = 1,
                                    get = function() return db["Player"]["Power"]["Background Multiplier"] end,
                                    set = function(self, value)
                                        db["Player"]["Power"]["Background Multiplier"] = value
                                    end 
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = function() return db["Player"]["Power"]["Orientation"] end,
                                    set = function(self, value)
                                        db["Player"]["Power"]["Orientation"] = value
                                    end 
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    get = function() return db["Player"]["Power"]["Reversed"] end,
                                    set = function(self, value)
                                        db["Player"]["Power"]["Reversed"] = value
                                    end 
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    values = media:List("statusbar"),
                                    get = function() return db["Player"]["Power"]["Texture"]  end,
                                    set = function(self, value)
                                        db["Player"]["Power"]["Texture"] = value
                                    end
                                },
                                ["Missing Power Bar"] = {
                                    ["Enabled"] = {
                                        type = "toggle",
                                        set = function(self, value)
                                            db["Player"]["Power"]["Missing Power Bar"]["Enabled"] = value
                                        end,
                                        get = function() return db["Player"]["Power"]["Missing Power Bar"]["Enabled"] end
                                    },
                                    type = "group",
                                    children = {
                                        ["Custom Color"] = {
                                            ["Enabled"] = function(self) return prefs["Player"]["Power"]["Missing Power Bar"]["Color By"]:get() == "Custom" end,
                                            type = "color",
                                            get = function() return db["Player"]["Power"]["Missing Power Bar"]["Custom Color"] end,
                                            set = function(self, value)
                                                db["Player"]["Power"]["Missing Power Bar"]["Custom Color"] = value
                                            end
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                            get = function() return db["Player"]["Power"]["Missing Power Bar"]["Color By"] end,
                                            set = function(self, value)
                                                db["Player"]["Power"]["Missing Power Bar"]["Color By"] = value
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

    setmetatable(prefs, mt)
    fix(prefs)

    -- Use table to construct the visual widgets and bind everything together
    -- Make sure every widgets various SetValue functions is calling UnitEvent.UPDATE_DB for everything
    -- Also redraw the preferences to make sure that all dependencies go through between them, eg. enabled because something else is enabled

    local frame = CreateFrame("Frame", "Preferences", A.frameParent)
    frame:SetSize(753, 500)
    frame:SetPoint("CENTER")
    frame:SetBackdrop(A.enum.backdrops.editbox)
    frame:SetBackdropColor(0, 0, 0, 0.75)

    local detailFrame = CreateFrame("Frame", nil, frame)
    detailFrame:SetSize(497, 465)
    detailFrame:SetPoint("BOTTOMRIGHT", -3, 3)
    detailFrame:SetBackdrop(A.enum.backdrops.editbox)
    detailFrame:SetBackdropColor(28/255, 28/255, 28/255, 0.5)

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
            :onClick(function(self, item)
                -- Nothing
            end)
            :onItemClick(function(self, item)
                -- Construct new second dropdown
            end)
            :backdrop(A.enum.backdrops.editbox, { 123/255, 132/255, 132/255, .25 }, { 0, 0, 0, 0 })

            for k,v in next, child.children do
                v.name = k
                ddbuilder1:addItem(v)
            end

            local dropdown1 = ddbuilder1:build()

            frame.firstDropdown = dropdown1

            local ddbuilder2 = buildDropdown(frame):size(247, 25):rightOf(dropdown1):x(3)
            :backdrop(A.enum.backdrops.editbox, { 123/255, 132/255, 132/255, .25 }, { 0, 0, 0, 0 })

            local firstChild = A.Tools.Table:first(child.children)
            if (firstChild.children) then
                for k,v in next, firstChild.children do
                    v.name = k
                    ddbuilder2:addItem(v)
                end
            end
            
            local dropdown2 = ddbuilder2:build() --more stuff needed here

            dropdown1.secondDropdown = dropdown2

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
end
