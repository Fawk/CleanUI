local A, L = unpack(select(2, ...))

local Database = {
    prepared = {}
}

Database.TYPE_GRID = "Grids"

for k,v in pairs(Database) do
    if string.match(k, "%a+_%a+") then
        Database.prepared[Database[k]] = {}
    end
end

local defaults =  {
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

local function iter(old, new)
    for k,v in pairs(old) do
        if type(v) == "table" then
            iter(v, new[k]) 
        else
            if v ~= new[k] then
                print(v, new[k])
                old[k] = new[k]
            end
        end
    end
end

function Database:Prepare(type, ...)
    local key, value = ...
    local t = self.prepared[type][key]
    if not t then
        self.prepared[type][key] = value
    else
        iter(self.prepared[type][key], value)
    end
end

function Database:GetDefaults(profile)
    return defaults["Profiles"][profile]
end

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
                merge(t1[k] or {}, t2[k] or {})
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
            extract(old[k], new[k], save[k])
        else
            if new[k] ~= v then
                print(k)
                save[k] = new[k]
            end
        end
    end
end

function Database:Save()
    local activeProfile = A["Modules"]["Profile"]:GetActive()
    
    local save = {
        ["Profiles"] = {
            [activeProfile] = {
                ["Options"] = {
                    [self.TYPE_GRID] = {}
                }
            }
        },
        ["Characters"] = defaults["Characters"]
    }
    
    A:DebugWindow(self.prepared, "prepared")
    
    -- Grids
    for k,v in pairs(self.prepared[self.TYPE_GRID]) do
        for rowId, row in pairs(defaults["Profiles"][activeProfile]["Options"][self.TYPE_GRID][k].rows) do
            for columnId, column in pairs(row.columns) do
                local newColumn = v.rows[rowId].columns[columnId].view
                if type(column) == "string" and type(newColumn) == "string" then
                    if column ~= newColumn then
                        local x = save["Profiles"][activeProfile]["Options"][self.TYPE_GRID][k]
                        if not x then
                            save["Profiles"][activeProfile]["Options"][self.TYPE_GRID][k] = {}
                            x = save["Profiles"][activeProfile]["Options"][self.TYPE_GRID][k]
                        end
                        if not x.rows then
                            x.rows = {}
                        end
                        if not x.rows[rowId] then
                            x.rows[rowId] = {}
                        end
                        if not x.rows[rowId].columns then
                            x.rows[rowId].columns = {}
                        end
                        if not x.rows[rowId].columns[columnId] then
                            x.rows[rowId].columns[columnId] = newColumn
                        end
                    end
                end
            end
        end
    end
    
    A:DebugWindow(save["Profiles"]["Default"], "saved")

    CleanUI_DB = save
end

function Database:CreateDatabase()
	if CleanUI_DB == nil then 
		CleanUI_DB = {}
        return copy(defaults)
	else
        return merge(copy(defaults), CleanUI_DB)
    end
end

A["Database"] = Database
