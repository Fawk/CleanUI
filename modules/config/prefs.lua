local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local buildText = A.TextBuilder

local function fix(tbl)
    for k,v in next, tbl do
        if v.children then
            v["*"] = tbl
            fix(v.children)
            v.children["*"] = v
        else
            v["*"] = tbl
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
                        -- ["Background Multiplier"] = 0.33,
                        -- ["Orientation"] = "HORIZONTAL",
                        -- ["Reversed"] = false,
                        -- ["Texture"] = "Default2",
                        -- ["Missing Health Bar"] = {
                        --     ["Enabled"] = false,
                        --     ["Custom Color"] = {
                        --         0.5, -- [1]
                        --         0.5, -- [2]
                        --         0.5, -- [3]
                        --         1, -- [4]
                        --     },
                        --     ["Color By"] = "Custom",
                        -- }
	
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
                        type = "checkbox",
                        set = function(self, value)
                            db["Player"]["Enabled"] = value
                        end,
                        get = function() return db["Player"]["Enabled"] end
                    },
					type = "group",
					children = {
						["Health"] = {
                            ["Enabled"] = {
                                type = "checkbox",
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
											type = "checkbox",
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Match width"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Match width"]
											end
										},
			    						["Match height"] = {
			    							type = "checkbox",
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Match height"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Match height"]
											end											
										},
			    						["Width"] = {
			    							["Enabled"] = function(self) return not prefs["Player"].children["Health"].children["Size"].children["Match width"]:get() end,
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
			    							["Enabled"] = function(self) return not prefs["Player"].children["Health"].children["Size"].children["Match height"]:get() end,
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
                                    type = "checkbox",
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
                                        type = "checkbox",
                                        set = function(self, value)
                                            db["Player"]["Health"]["Missing Health Bar"]["Enabled"] = value
                                        end,
                                        get = function() return db["Player"]["Health"]["Missing Health Bar"]["Enabled"] end
                                    },
                                    type = "group",
                                    children = {
                                        ["Custom Color"] = {
                                            ["Enabled"] = function(self) return prefs["Player"].children["Health"].children["Missing Health Bar"].children["Color By"]:get() == "Custom" end,
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
                                type = "checkbox",
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
                                            type = "checkbox",
                                            set = function(self, value)
                                                db["Player"]["Power"]["Size"]["Match width"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Size"]["Match width"]
                                            end
                                        },
                                        ["Match height"] = {
                                            type = "checkbox",
                                            set = function(self, value)
                                                db["Player"]["Power"]["Size"]["Match height"] = value
                                            end,
                                            get = function()
                                                return db["Player"]["Power"]["Size"]["Match height"]
                                            end                                         
                                        },
                                        ["Width"] = {
                                            ["Enabled"] = function(self) return not prefs["Player"].children["Power"].children["Size"].children["Match width"]:get() end,
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
                                            ["Enabled"] = function(self) return not prefs["Player"].children["Power"].children["Size"].children["Match height"]:get() end,
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
                                    type = "checkbox",
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
                                        type = "checkbox",
                                        set = function(self, value)
                                            db["Player"]["Power"]["Missing Power Bar"]["Enabled"] = value
                                        end,
                                        get = function() return db["Player"]["Power"]["Missing Power Bar"]["Enabled"] end
                                    },
                                    type = "group",
                                    children = {
                                        ["Custom Color"] = {
                                            ["Enabled"] = function(self) return prefs["Player"].children["Power"].children["Missing Power Bar"].children["Color By"]:get() == "Custom" end,
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

	--fix(prefs)

    -- Use table to construct the visual widgets and bind everything together
    -- Make sure every widgets various SetValue functions is calling UnitEvent.UPDATE_DB for everything
    -- Also redraw the preferences to make sure that all dependencies go through between them, eg. enabled because something else is enabled

    local frame = CreateFrame("Frame", "Preferences", A.frameParent)
    frame:SetSize(500, 500)
    frame:SetPoint("CENTER")
    frame:SetBackdrop(A.enum.backdrops.editbox)
    frame:SetBackdropColor(0, 0, 0, 0.7)

    for name, child in next, prefs do
        if (child.type == "group") then
            constructGroup(frame, frame, name, child)
        end
    end

end