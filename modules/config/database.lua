local A, L = unpack(select(2, ...))

local Database = {}

local db = {
	["Profiles"] = {
	    ["Default"] = {
    		["Options"] = {
    			["Player"] = {
    				["Position"] = {
    					["Point"] = "CENTER",
    					["Local Point"] = "CENTER",
    					["Offset X"] = -200,
    					["Offset Y"] = -200,
    					["Relative To"] = "UIParent"
    				},
    				["Health"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "CENTER",
    						["Local Point"] = "ALL",
    						["Offset X"] = -200,
    						["Offset Y"] = -200,
    						["Relative To"] = "Player"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 25,
    					}
    				},
    				["Power"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "BOTTOM",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Health"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 25,
    					}
    				},
    				["Buffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Player",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    				},
    				["Debuffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Buffs",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    				},
    				["Size"] = {
    					["Width"] = 250,
    					["Height"] = 50,
    				},
    				["Enabled"] = true
    			},
    			["Target"] = {
    				["Position"] = {
    					["Point"] = "CENTER",
    					["Local Point"] = "CENTER",
    					["Offset X"] = 200,
    					["Offset Y"] = -200,
    					["Relative To"] = "UIParent"
    				},
    				["Health"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "CENTER",
    						["Local Point"] = "CENTER",
    						["Offset X"] = -200,
    						["Offset Y"] = -200,
    						["Relative To"] = "Target"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 25,
    					}
    				},
    				["Power"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "CENTER",
    						["Local Point"] = "CENTER",
    						["Offset X"] = -200,
    						["Offset Y"] = -200,
    						["Relative To"] = "Health"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 25,
    					}
    				},
    				["Buffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Player",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    				},
    				["Debuffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Buffs",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    				},
    				["Size"] = {
    					["Width"] = 250,
    					["Height"] = 50,
    				}
    			},
    			["Minimap"] = {
    				["Size"] = 250,
    				["Position"] = {
    					["Point"] = "TOPRIGHT",
    					["Local Point"] = "TOPRIGHT",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    					["Relative To"] = "UIParent"
    				}
    			},
                ["Grids"] = {
                    ["Test"] = {
                        ["singleLayer"] = true,
                        ["rows"] = {
                            {
                                ["columns"] = { "Gold", "Gold", "Gold" }
                            },
                            {
                                ["columns"] = { "Gold", "Gold", "Gold" }
                            },
                            {
                                ["columns"] = { "Gold", "Gold", "Gold" }
                            }
                        }
                    }
                }
    		}
	    }
	},
	["Characters"] = {
        ["Aiwen-ShatteredHand"] = "Default",
    }
}

function Database:CreateDatabase()
	if CleanUI_DB == nil then 
		CleanUI_DB = {}
		for k,v in pairs(db) do
			CleanUI_DB[k] = v 
		end
	end
	return CleanUI_DB
end

A["Database"] = Database
