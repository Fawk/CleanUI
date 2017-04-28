local A, L = unpack(select(2, ...))
local rawset = rawset
local rawget = rawget
local pairs = pairs
local smatch = string.match
local setmetatable = setmetatable

local Database = {
    prepared = {}
}

Database.TYPE_GRID = "Grids"
Database.TYPE_CHARACTER = "Characters"

for k,v in pairs(Database) do
    if smatch(k, "%a+_%a+") then
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
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Player"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 25
    					},
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default"
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
    						["Height"] = 5
    					},
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default"
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
                    ["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "Noto",
                            ["Size"] = 14,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "Outline",
                            ["Text"] = "[name]",
                            ["Position"] = {
                                ["Point"] = "TOPLEFT",
                                ["Local Point"] = "BOTTOMLEFT",
                                ["Offset X"] = 5,
                                ["Offset Y"] = 2,
                                ["Relative To"] = "Player"
                            },
                            ["Enabled"] = false
                        },
                        ["Custom"] = {}
                    },
                    ["HealPrediction"] = {
                        ["Texture"] = "Default",
                        ["MaxOverflow"] = 1,
                        ["FrequentUpdates"] = true,
                        ["Enabled"] = true
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
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Target"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 25
    					},
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default"
    				},
    				["Power"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "CENTER",
    						["Local Point"] = "CENTER",
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Health"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 5
    					},
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default"
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
                ["Party"] = {
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
                            ["Local Point"] = "ALL",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Party"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 48
                        },
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "VERTICAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default"
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
                            ["Width"] = 64,
                            ["Height"] = 3
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default"
                    },
                    ["Size"] = {
                        ["Width"] = 64,
                        ["Height"] = 48
                    },
                    ["Orientation"] = "VERTICAL",
                    ["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "Noto",
                            ["Size"] = 14,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "NONE",
                            ["Text"] = "[3charname]",
                            ["Position"] = {
                                ["Point"] = "ALL",
                                ["Local Point"] = "ALL",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 0,
                                ["Relative To"] = "Parent"
                            },
                            ["Enabled"] = true,
                        },
                        ["Custom"] = {}
                    },
                    ["RaidBuffs"] = {
                        ["Limit"] = 40,
                        ["Tracked"] = {
                            [194384] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOPRIGHT",
                                    ["Local Point"] = "TOPRIGHT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide countdown numbers"] = false,
                                ["Size"] = 14
                            }
                        },
                        ["Enabled"] = true
                    },
                    ["HealPrediction"] = {
                        ["Texture"] = "Default",
                        ["MaxOverflow"] = 1,
                        ["FrequentUpdates"] = true,
                        ["Enabled"] = true
                    },
                    ["Offset X"] = 2,
                    ["Offset Y"] = 0,
                    ["Show Player"] = true,
                    ["Highlight Target"] = true,
                    ["Show Debuff Border"] = true,
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison", "Physical" },
                    ["Enabled"] = true
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
                    ["Minimap"] = {
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

local function deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local function iter(old, new)
    for k,v in pairs(old) do
        if type(v) == "table" then
            iter(v, new[k]) 
        else
            if v ~= new[k] then
                old[k] = new[k]
            end
        end
    end
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

local defaultsMeta = {
    __index = function(t, k)
        if not rawget(t, k) and rawget(defaults, k) then
            rawset(t, k, deepCopy(rawget(defaults, k)))
        end
        return rawget(t, k)
    end
}

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

function Database:Save()
    local activeProfile = A["Modules"]["Profile"]:GetActive()   
    local save = setmetatable({}, defaultsMeta)
    local db = save["Profiles"][activeProfile]
    db[self.TYPE_CHARACTER] = deepCopy(defaults[self.TYPE_CHARACTER])
    db = db["Options"]

    for k,v in pairs(self.prepared) do
        db[k] = v
    end

    CleanUI_DB = save
end

function Database:CreateDatabase()
	if CleanUI_DB == nil then 
		CleanUI_DB = {}
        return deepCopy(defaults)
	else
        return merge(deepCopy(defaults), deepCopy(CleanUI_DB))
    end
end

A["Database"] = Database