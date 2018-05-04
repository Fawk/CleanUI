local A, L = unpack(select(2, ...))

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
					enabled = db["Player"]["Enabled"],
					type = "group",
					children = {
						["Health"] = {
							enabled = db["Player"]["Health"]["Enabled"],
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
											values = { ["Player"] = "Player", ["Power"] = "Power" },
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
										}
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
			    							enabled = function(self) return not self["*"]["Match width"]:get() end
			    							type = "number",
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Width"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Width"]
											end		
			    						},
			    						["Height"] = {
			    							enabled = function(self) return not self["*"]["Match height"]:get() end
			    							type = "number",
											set = function(self, value)
												db["Player"]["Health"]["Size"]["Height"] = value
											end,
											get = function()
												return db["Player"]["Health"]["Size"]["Height"]
											end		
			    						}
			    					}
								}
							}
						},
						["Power"] = {

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

	fix(prefs)

    -- Use table to construct the visual widgets and bind everything together
    -- Make sure every widgets various SetValue functions is calling UnitEvent.UPDATE_DB for everything
    -- Also redraw the preferences to make sure that all dependencies go through between them, eg. enabled because something else is enabled

end