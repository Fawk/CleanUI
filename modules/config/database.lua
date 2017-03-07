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
    						["Height"] = 25
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
    						["Height"] = 25
    					}
    				},
    				["Buffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Player",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
    				},
    				["Debuffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Buffs",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
    				},
    				["Size"] = {
    					["Width"] = 250,
    					["Height"] = 50
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
    						["Height"] = 25
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
    						["Height"] = 25
    					}
    				},
    				["Buffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Player",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
    				},
    				["Debuffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Buffs",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
    				},
    				["Size"] = {
    					["Width"] = 250,
    					["Height"] = 50
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
                                ["columns"] = { "Artifact Power", "Time", "Gold" }
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
        ["Aiwen-ShatteredHand"] = "Default"
    }
}

local function copy(tbl)
    local new = {}
    for k,v in pairs(tbl) do
        new[k] = v
    end
    return new
end

local function merge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

local function extract(old, new, save)
    for k,v in pairs(old) do
        if type(v) == "table" then
            save[k] = {}
            iter(old[k], new[k], save[k])
        else
            if new[k] ~= v then
                save[k] = new[k]
            end
        end
    end
end

function Database:Save()
    local save = {}
    extract(db, A.db, save)
    CleanUI_DB = save
end

function Database:CreateDatabase()
	if CleanUI_DB == nil then 
		CleanUI_DB = {}
        return copy(db)
	else
        return merge(copy(db), CleanUI_DB)
    end
end

A["Database"] = Database
