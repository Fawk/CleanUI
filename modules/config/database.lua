local AddonName = ...
local A, L = unpack(select(2, ...))
local rawset = rawset
local rawget = rawget
local pairs = pairs
local smatch = string.match
local setmetatable = setmetatable

local Database = {
    prepared = {}
}

Database.TYPE_CHARACTER = "Characters"

for k,v in pairs(Database) do
    if smatch(k, "%a+_%a+") then
        Database.prepared[Database[k]] = {}
    end
end

local global = _G[AddonName.."_DB"]

local defaults =  {
    ["Profiles"] = {
	    ["Default"] = {
    		["Options"] = {
    			["Player"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = -266.735260009766,
                        ["Offset Y"] = -202.188110351563,
                    },
    				["Health"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "TOP",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Player"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 150,
    						["Height"] = 35
    					},
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
    				},
    				["Power"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "BOTTOM",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = -1,
    						["Relative To"] = "Health"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 150,
    						["Height"] = 15
    					},
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
    				},
    				["Buffs"] = {
    					["Enabled"] = true,
    					["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
    					["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Debuffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Icon",
                        ["Growth"] = "Left",
                        ["Attached"] = "LEFT",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Size"] = {
    					["Width"] = 200,
    					["Height"] = 51
    				},
                    ["Tags"] = {},
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
					["Background"] = {
						["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
						["Enabled"] = true,
					},
                    ["Alternative Power"] = {
                        ["Enabled"] = true,
                        ["Background"] = {
                            ["Enabled"] = true,
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Color"] = { 0, 0, 0 }
                        },
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 300,
                            ["Offset Y"] = -400,
                            ["Relative To"] = "FrameParent"
                        },
                        ["Size"] = {
                            ["Width"] = 200,
                            ["Height"] = 20
                        },
                        ["Texture"] = "Default2",
                        ["Background Multiplier"] = 0.3,
                        ["Hide Blizzard"] = true
                    },
                    ["Runes"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Width"] = 25,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Combo Points"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default2",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Soul Shards"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default2",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Chi"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default2",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Arcane Charge"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default2",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Holy Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default2",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true
                    },              
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 16
                        },
                        ["Time"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "RIGHT",
                                ["Local Point"] = "RIGHT",
                                ["Offset X"] = -5,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 10
                        },
                        ["Name"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 18,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 0.7
                        },
                        ["Icon"] = {
                            ["Enabled"] = true,
                            ["Position"] = "LEFT",
                            ["Size"] = {
                                ["Match width"] = false,
                                ["Match height"] = true,
                                ["Size"] = 10
                            },
                            ["Background"] = {
                                ["Color"] = { 0, 0, 0 },
                                ["Offset"] = {
                                    ["Top"] = 2,
                                    ["Bottom"] = 2,
                                    ["Left"] = 2,
                                    ["Right"] = 2
                                },
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached Position"] = "Below",
                        ["Attached"] = true,
                    },
                    ["Stagger"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached"] = true
                    },
                    ["Combat Indicator"] = {
                        ["Enabled"] = true
                    },
    				["Enabled"] = true
    			},
    			["Target"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 265.640625,
                        ["Offset Y"] = -202.187973022461,
                    },
    				["Health"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "TOP",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Target"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 35
    					},
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
    				},
    				["Power"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "BOTTOM",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = -1,
    						["Relative To"] = "Health"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 15
    					},
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
    				},
    				["Buffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Icon",
                        ["Growth"] = "Right",
                        ["Attached"] = "RIGHT",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Debuffs"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Attached"] = "TOP",
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Size"] = {
    					["Width"] = 200,
    					["Height"] = 51
    				},
					["Tags"] = {},
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                        ["Enabled"] = true,
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "Class Icons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 16
                        },
                        ["Time"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "RIGHT",
                                ["Local Point"] = "RIGHT",
                                ["Offset X"] = -5,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 10
                        },
                        ["Name"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 18,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 0.7
                        },
                        ["Icon"] = {
                            ["Enabled"] = true,
                            ["Position"] = "LEFT",
                            ["Size"] = {
                                ["Match width"] = false,
                                ["Match height"] = true,
                                ["Size"] = 10
                            },
                            ["Background"] = {
                                ["Color"] = { 0, 0, 0 },
                                ["Offset"] = {
                                    ["Top"] = 2,
                                    ["Bottom"] = 2,
                                    ["Left"] = 2,
                                    ["Right"] = 2
                                },
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached Position"] = "Below"
                    },
                    ["Enabled"] = true
    			},
                ["Target of Target"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 400,
                        ["Offset Y"] = 0,
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 16
                        },
                        ["Time"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "RIGHT",
                                ["Local Point"] = "RIGHT",
                                ["Offset X"] = -5,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 10
                        },
                        ["Name"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 18,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 0.7
                        },
                        ["Icon"] = {
                            ["Enabled"] = true,
                            ["Position"] = "LEFT",
                            ["Size"] = {
                                ["Match width"] = false,
                                ["Match height"] = true,
                                ["Size"] = 10
                            },
                            ["Background"] = {
                                ["Color"] = { 0, 0, 0 },
                                ["Offset"] = {
                                    ["Top"] = 2,
                                    ["Bottom"] = 2,
                                    ["Left"] = 2,
                                    ["Right"] = 2
                                },
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached Position"] = "Below",
                    },
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Target of Target"
                        },
                        ["Size"] = {
                            ["Match width"] = false,
                            ["Match height"] = false,
                            ["Width"] = 100,
                            ["Height"] = 20
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Health"
                        },
                        ["Size"] = {
                            ["Match width"] = false,
                            ["Match height"] = false,
                            ["Width"] = 100,
                            ["Height"] = 5
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Buffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
                    },
                    ["Debuffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
                    },
                    ["Size"] = {
                        ["Width"] = 100,
                        ["Height"] = 25
                    },
                    ["Tags"] = {},
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Enabled"] = true
                },
                ["Party"] = {
                    ["Clickcast"] = {
                        ["Enabled"] = true,
                        ["Actions"] = {}
                    },
                    ["Status"] = {
                        ["Out of range"] = {
                            ["Action"] = "Modify",
                            ["Settings"] = {
                                ["Present Type"] = "None",
                                ["Modify Type"] = "Alpha",
                                ["Alpha Value"] = 50,
                                ["Color"] = { 1, 1, 1, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10
                            }
                        },
                        ["Dead"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10
                            }
                        },
                        ["Offline"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10
                            }
                        },
                        ["Ghost"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 1, 0.8, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10
                            }
                        }
                    },
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = -1.29987347126007,
                        ["Offset Y"] = -201.094223022461,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Parent"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 41
                        },
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "VERTICAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Health"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 5
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Size"] = {
                        ["Width"] = 63,
                        ["Height"] = 47
                    },
                    ["Orientation"] = "HORIZONTAL",
                    ["Growth Direction"] = "Right",
                    ["Tags"] = {},
                    ["Raid Buffs"] = {
                        ["Limit"] = 40,
                        ["Tracked"] = {
                        },
						["Important"] = true,
                        ["Enabled"] = true
                    },
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Offset X"] = 2,
                    ["Offset Y"] = 0,
                    ["Show Player"] = true,
                    ["Highlight Target"] = true,
                    ["Show Debuff Border"] = true,
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison" },
                    ["Visibility"] = "[@party1,exists] show; hide",
                    ["Group By"] = "Role",
                    ["Sort Alphabetically"] = true,
                    ["Sorting Direction"] = "ASC",
                    ["Group Role Indicator"] = {
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 2,
                            ["Offset Y"] = -2,
                            ["Relative To"] = "Parent"    
                        },
                        ["Size"] = 20,
                        ["Style"] = "Letter",
                        ["Text Size"] = 10,
                        ["Text Color"] = { 1, 1, 1, 1 },
                        ["Text Style"] = "Outline",
                        ["Texture"] = nil,
                        ["Enabled"] = true
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Enabled"] = true
                },
                ["Raid"] = {
                    ["Clickcast"] = {
                        ["Enabled"] = true,
                        ["Actions"] = {}
                    },
                    ["Visibility"] = "[@raid1,exists] show; hide",
                    ["Group By"] = "Role",
                    ["Sort Alphabetically"] = true,
                    ["Sorting Direction"] = "ASC",
                    ["Max Columns"] = 5,
                    ["Status"] = {
                        ["Out of range"] = {
                            ["Action"] = "Modify",
                            ["Settings"] = {
                                ["Present Type"] = "None",
                                ["Modify Type"] = "Alpha",
                                ["Alpha Value"] = 50,
                                ["Color"] = { 1, 1, 1, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Dead"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Offline"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Ghost"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 1, 0.8, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        }
                    },
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 1117.7001953125,
                        ["Offset Y"] = -899.094360351563,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Parent"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 41
                        },
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "VERTICAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Health"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 5
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Size"] = {
                        ["Width"] = 63,
                        ["Height"] = 47
                    },
                    ["Growth Direction"] = "Right Then Down",
                    ["Tags"] = {},
                    ["Raid Buffs"] = {
                        ["Tracked"] = {},
                        ["Important"] = true,
                        ["Enabled"] = true
                    },
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Offset X"] = 2,
                    ["Offset Y"] = 2,
                    ["Show Player"] = true,
                    ["Highlight Target"] = true,
                    ["Show Debuff Border"] = true,
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison" },
                    ["Group Role Indicator"] = {
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 2,
                            ["Offset Y"] = -2,
                            ["Relative To"] = "Parent"    
                        },
                        ["Size"] = 20,
                        ["Style"] = "Letter",
                        ["Text Size"] = 10,
                        ["Text Color"] = { 1, 1, 1, 1 },
                        ["Text Style"] = "Outline",
                        ["Texture"] = nil,
                        ["Enabled"] = true
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Enabled"] = true
                },
                ["Pet"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = -265.640625,
                        ["Offset Y"] = -202.187973022461,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Parent"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
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
                        ["Texture"] = "Default2",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Buffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Icon",
                        ["Growth"] = "Right",
                        ["Attached"] = "RIGHT",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
                    },
                    ["Debuffs"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Attached"] = "TOP",
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
                    },
                    ["Size"] = {
                        ["Width"] = 200,
                        ["Height"] = 22
                    },
                    ["Tags"] = {},
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "Class Icons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 16
                        },
                        ["Time"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "RIGHT",
                                ["Local Point"] = "RIGHT",
                                ["Offset X"] = -5,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 10
                        },
                        ["Name"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 18,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 0.7
                        },
                        ["Icon"] = {
                            ["Enabled"] = true,
                            ["Position"] = "LEFT",
                            ["Size"] = {
                                ["Match width"] = false,
                                ["Match height"] = true,
                                ["Size"] = 10
                            },
                            ["Background"] = {
                                ["Color"] = { 0, 0, 0 },
                                ["Offset"] = {
                                    ["Top"] = 2,
                                    ["Bottom"] = 2,
                                    ["Left"] = 2,
                                    ["Right"] = 2
                                },
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached Position"] = "Below"
                    },
                    ["Enabled"] = true
                },
                ["Boss"] = {
                    ["Clickcast"] = {},
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPRIGHT",
                        ["Local Point"] = "TOPRIGHT",
                        ["Offset X"] = -250,
                        ["Offset Y"] = -200
                    },
                    ["Size"] = {
                        ["Width"] = 150,
                        ["Height"] = 50
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Parent"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 35
                        },
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Health"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Orientation"] = "VERTICAL",
                    ["Tags"] = {},
                    ["Offset X"] = 2,
                    ["Offset Y"] = 0,
                    ["Highlight Target"] = true,
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "Class Icons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 16
                        },
                        ["Time"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "RIGHT",
                                ["Local Point"] = "RIGHT",
                                ["Offset X"] = -5,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 10
                        },
                        ["Name"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 18,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 0.7
                        },
                        ["Icon"] = {
                            ["Enabled"] = true,
                            ["Position"] = "LEFT",
                            ["Size"] = {
                                ["Match width"] = false,
                                ["Match height"] = true,
                                ["Size"] = 10
                            },
                            ["Background"] = {
                                ["Color"] = { 0, 0, 0 },
                                ["Offset"] = {
                                    ["Top"] = 2,
                                    ["Bottom"] = 2,
                                    ["Left"] = 2,
                                    ["Right"] = 2
                                },
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = 2,
                                ["Bottom"] = 2,
                                ["Left"] = 2,
                                ["Right"] = 2
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached Position"] = "Below"
                    },
                    ["Enabled"] = true
                },
    			["Minimap"] = {
    				["Size"] = 200,
    				["Position"] = {
    					["Point"] = "TOPRIGHT",
    					["Local Point"] = "TOPRIGHT",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    					["Relative To"] = "FrameParent"
    				}
    			},
                ["Vehicle Seat Indicator"] = {
                    ["Position"] = {
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 100,
                        ["Offset Y"] = -100,
                        ["Relative To"] = "FrameParent"
                    }
                },
                ["Objective Tracker"] = {
                    ["Position"] = {
                        ["Point"] = "TOPRIGHT",
                        ["Local Point"] = "TOPRIGHT",
                        ["Offset X"] = -10,
                        ["Offset Y"] = -300,
                        ["Relative To"] = "FrameParent"
                    },
                    ["Size"] = {
                        ["Width"] = 250,
                        ["Height"] = 800
                    }
                },
                ["Cooldown bar"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 3.4875648021698,
                        ["Offset Y"] = -158.936065673828,
                    },
                },
				["Chat"] = {
					["Hide In Combat"] = false
				},
                ["Extra Action Button"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "BOTTOM",
                        ["Local Point"] = "BOTTOM",
                        ["Offset X"] = -6.56422424316406,
                        ["Offset Y"] = 144.222183227539,
                    },
                },
                ["Info Field"] = {
                    ["Enabled"] = true,
                    ["Limit"] = 10,
                    ["Size"] = 20,
                    ["Direction"] = "Right",
                    ["Orientation"] = "HORIZONTAL",
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 3.4875648021698,
                        ["Offset Y"] = -158.936065673828,
                    },
                    ["Presets"] = {}
                },
                ["Talking Head Frame"] = {
                     ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 10,
                        ["Offset Y"] = -10,
                    }
                },
                ["Actionbars"] = {
                    [1] = { 
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 500,
                            ["Offset Y"] = -50,
                        },
                        ["Icon Size"] = 24,
                        ["Vertical Limit"] = 12,
                        ["Horizontal Limit"] = 1
                    },
                    [2] = { 
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 500,
                            ["Offset Y"] = -83,
                        },
                        ["Icon Size"] = 32,
                        ["Vertical Limit"] = 12,
                        ["Horizontal Limit"] = 1
                    },
                    [3] = { 
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 500,
                            ["Offset Y"] = -116,
                        },
                        ["Icon Size"] = 32,
                        ["Vertical Limit"] = 12,
                        ["Horizontal Limit"] = 1
                    },
                    [4] = { 
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 500,
                            ["Offset Y"] = -149,
                        },
                        ["Icon Size"] = 32,
                        ["Vertical Limit"] = 12,
                        ["Horizontal Limit"] = 1
                    },
                    [5] = { 
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 500,
                            ["Offset Y"] = -186,
                        },
                        ["Icon Size"] = 32,
                        ["Vertical Limit"] = 12,
                        ["Horizontal Limit"] = 1
                    }
                },
                ["Pet Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 850,
                        ["Offset Y"] = -50,
                    },
                    ["Icon Size"] = 24,
                    ["Vertical Limit"] = 12,
                    ["Horizontal Limit"] = 1
                },
                ["Experience Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 500,
                        ["Offset Y"] = -50,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Size"] = {
                        ["Width"] = 250,
                        ["Height"] = 25
                    },
                    ["Background Multiplier"] = 0.33,
                    ["Orientation"] = "HORIZONTAL",
                    ["Reversed"] = false,
                    ["Texture"] = "Default2",
                    ["Color"] = { 0.8, 0, 0.4 }
                },
                ["Reputation Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 500,
                        ["Offset Y"] = -250,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Size"] = {
                        ["Width"] = 500,
                        ["Height"] = 25
                    },
                    ["Background Multiplier"] = 0.33,
                    ["Orientation"] = "HORIZONTAL",
                    ["Reversed"] = false,
                    ["Texture"] = "Default2"
                },
                ["Artifact Power Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 500,
                        ["Offset Y"] = -50,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Size"] = {
                        ["Width"] = 500,
                        ["Height"] = 25
                    },
                    ["Background Multiplier"] = 0.33,
                    ["Orientation"] = "HORIZONTAL",
                    ["Reversed"] = false,
                    ["Texture"] = "Default2",
                    ["Color"] = { 0.90196, 0.8, 0.50196 }
                },
                ["Vehicle Leave Button"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 1200,
                        ["Offset Y"] = -500,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = 2,
                            ["Bottom"] = 2,
                            ["Left"] = 2,
                            ["Right"] = 2
                        },
                        ["Enabled"] = true,
                    },
                    ["Size"] = 48,
                },
                ["Character Info"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 100,
                        ["Offset Y"] = -500,
                    },
                },
                ["Key Bindings"] = {
                    ["1"] = AddonName.."_ActionBar1Button1",
                    ["2"] = AddonName.."_ActionBar1Button2",
                    ["3"] = AddonName.."_ActionBar1Button3",
                    ["4"] = AddonName.."_ActionBar1Button4",
                    ["5"] = AddonName.."_ActionBar1Button5",
                    ["6"] = AddonName.."_ActionBar1Button6",
                    ["7"] = AddonName.."_ActionBar1Button7",
                    ["8"] = AddonName.."_ActionBar1Button8",
                    ["9"] = AddonName.."_ActionBar1Button9"
                }
    		}
	    }
	},
	["Characters"] = {}
}

A.defaults = defaults

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

local function scan(tbl, d)
    for k,v in pairs(d) do
        if type(v) == "table" then
            if not tbl[k] then
                tbl[k] = setmetatable({}, {
                    __index = function(t, kv)
                        if not rawget(t, kv) and rawget(v, kv) then
                            rawset(t, kv, deepCopy(rawget(v, kv)))
                        end
                        return rawget(t, kv)
                    end
                })
            end
            scan(tbl[k], v)
        else
            if not tbl[k] then
                tbl[k] = v
            end
        end
    end
end

for profile, tbl in next, defaults["Profiles"] do
    if profile ~= "Default" then
        scan(tbl, defaults["Profiles"]["Default"])
    end
end

function Database:Prepare(type, value)
    if not self.prepared[type] then
        self.prepared[type] = {}
    end
    self.prepared[type] = value
end

function Database:GetDefaults(profile)
    return defaults["Profiles"][profile]
end

function Database:Save()
    local activeProfile = A["Modules"]["Profile"]:GetActive()
    local save = setmetatable({}, defaultsMeta)
    save[self.TYPE_CHARACTER] = deepCopy(defaults[self.TYPE_CHARACTER])

    for k,v in pairs(self.prepared) do
        if not save["Profiles"][activeProfile] then
            save["Profiles"][activeProfile] = deepCopy(A.db["Profiles"][activeProfile])
        end
        save["Profiles"][activeProfile]["Options"][k] = v
    end
    
    --A:DebugTable(save["Profiles"][activeProfile]["Options"]["Minimap"])

    global = save
end

function Database:CreateDatabase()
	if global == nil then 
		global = {}
        return deepCopy(defaults)
	else
        return merge(deepCopy(defaults), deepCopy(global))
    end
end

A["Database"] = Database